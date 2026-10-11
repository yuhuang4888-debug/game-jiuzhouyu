%% ---------------------------------------------------------------------------
%% @doc mod_race_act_local
%% @author zengzy
%% @since  2018-04-18
%% @deprecated  竞榜本服管理活动开启进程
%% ---------------------------------------------------------------------------
-module(mod_race_act_local).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([
    start_link/0
]).
-compile(export_all).
-include("race_act.hrl").
-include("common.hrl").
-include("def_fun.hrl").

%%-----------------------------

get_act(Type) ->
    Key = Type,
    case ets:lookup(?ETS_RACE_ACT, Key) of
        [] -> false;
        [Info] -> Info
    end.

gm_refresh()->
    misc:whereis_name(?MODULE) ! {zero}.

gm_refresh_type(Type)->
    gen_server:cast({global, ?MODULE}, {gm_refresh_type,Type}).

%% 更新区域的信息
%% List [{Type, SubType, WorldLv}]
sync_update(List) ->
    gen_server:cast({global, ?MODULE}, {sync_update,List}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    init(),
    Ref = ref([]),
    % 15 秒后再请求同步一次数据
    spawn(fun() ->
        timer:sleep(15000),
        ServerId = config:get_server_id(),
        case util:get_open_day() >= 1 of
            true -> mod_race_act:cast_center([{'sync_server_data', ServerId}]);
            false -> skip
        end
          end),
    {ok, Ref}.

%% ====================
%% hanle_call
%% ====================
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({gm_refresh_type,Type}, State) ->
    gm_refresh_type(Type,1),
    % ?INFO("gm_refresh~n",[]),
    {noreply,State};

% 同步跨服的数据
do_handle_cast({sync_update,List}, State) ->
    RaceActList = ets:tab2list(?ETS_RACE_ACT),
    F = fun(#ets_race_act{type=Type,subtype=SubType}=RaceAct) ->
        case lists:keyfind({Type, SubType}, 1, List) of
            false -> WorldLv = 0;
            {_, WorldLv} -> ok
        end,
        ets:insert(?ETS_RACE_ACT, RaceAct#ets_race_act{world_lv = WorldLv})
        end,
    lists:foreach(F, RaceActList),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({zero}, State) ->
    zero(),
    ORef = State,
    Ref = ref(ORef),
    % 零点触发同步
    case util:get_open_day() >= 1 of
        true ->
            ServerId = config:get_server_id(),
            mod_race_act:cast_center([{'sync_server_data', ServerId}]);
        false ->
            skip
    end,
    {noreply, Ref};
do_handle_info(_Info, State) -> {noreply, State}.

%%初始化
init() ->
    OpenAct = case lib_race_act_util:db_race_act_open_select() of
                  []-> [];
                  List ->
                      [{Type,SubType}||[Type,SubType]<-List]
              end,
    {OpenAct1,DelAct} = refresh_clear_act(OpenAct,[],[]),
    log(DelAct, 2),
    ?IF(DelAct==[], ok, ?INFO("~p~n",[DelAct])),
    save_act(OpenAct1),
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    AddAct = refresh_open_act(OpenList++ShowList, OpenAct1, []),
    ?IF(AddAct==[], ok, ?INFO("~p~n",[AddAct])),
    log(AddAct, 1),
    save_act(AddAct).

%%定时器
ref(Ref)->
    util:cancel_timer(Ref),
    {_, {H,Min,S}} = calendar:local_time(),
    PassTime = H*3600 + Min*60 + S,
    RefTime = ?ONE_DAY_SECONDS+1 - PassTime,
    erlang:send_after(RefTime*1000, self(), {zero}).

%%零点处理
zero() ->
    List = ets:tab2list(?ETS_RACE_ACT),
    OpenAct = [{Type,SubType}||#ets_race_act{type=Type,subtype=SubType}<-List],
    {OpenAct1,DelAct} = refresh_clear_act(OpenAct,[],[]),
    del_act(DelAct),
    log(DelAct, 2),
    % ?PRINT("~p~n",[DelAct]),
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    AddAct = refresh_open_act(OpenList++ShowList, OpenAct1, []),
    save_act(AddAct),
    log(AddAct, 1),
    % ?PRINT("~p~n",[AddAct]),
    send_to_all().

%%保存进ets
save_act([]) -> ok;
save_act([{Type,SubType}|T]) ->
    Info = #ets_race_act{type=Type,subtype=SubType},
    ets:insert(?ETS_RACE_ACT, Info),
    save_act(T).

%%删除ets
del_act([]) -> ok;
del_act([{Type,_SubType}|T]) ->
    ets:delete(?ETS_RACE_ACT, Type),
    del_act(T).

%%检测过期活动
refresh_clear_act([], OpenAct, DelAct) -> {OpenAct,DelAct};
refresh_clear_act([{Type,SubType}=Info|T], OpenAct, DelAct) ->
    case is_clear(Type,SubType) of
        true->
            lib_race_act_util:db_race_act_open_delete(Type,SubType),
            refresh_clear_act(T, OpenAct, [{Type,SubType}|DelAct]);
        false->
            refresh_clear_act(T, [Info|OpenAct], DelAct)
    end.

%%检测新开活动
refresh_open_act([], _OpenAct, AddAct) -> AddAct;
refresh_open_act([ActInfo|T], OpenAct, AddAct) ->
    #base_race_act_info{type=Type,sub_type=SubType} = ActInfo,
    IsAdd = lists:keyfind(Type, 1, AddAct) =/= false,
    IsMember = lists:keyfind(Type, 1, OpenAct) =/= false,
    case IsMember orelse IsAdd of
        true-> refresh_open_act(T, OpenAct, AddAct);
        false ->
            lib_race_act_util:db_race_act_open_replace(Type,SubType),
            refresh_open_act(T, OpenAct, [{Type,SubType}|AddAct])
    end.

%%是否清除
is_clear(Type,SubType)->
    Data = data_race_act:get_act_info(Type,SubType),
    IsOpen = is_open(Data),
    IsShow = is_show(Data),
    IsOpen =/= true andalso IsShow =/= true.

%%判断是否开启(只判断开服时间和北京时间)
is_open(#base_race_act_info{}=Data)->
    #base_race_act_info{
        open_day=OpenDay,
        open_over = OpenOver,
        start_time=StartTime,
        end_time=EndTime
    } = Data,
    Condition = [
        {open_day,OpenDay,OpenOver},
        {act_time,StartTime,EndTime}
    ],
    lib_race_act_util:check_condition_list(Condition);
is_open(_)->
    false.

%%检测是否展示(只判断开服时间，北京时间，和开服第一天是否展示天)
is_show(#base_race_act_info{type=Type,start_time=StartTime,open_day=_OpenDay,open_over=_OpenOver,end_time=EndTime})->
    case lists:member(Type,?SHOW_LIST) of
        true->
            ShowEtTime = EndTime + 86400,
            Condition = [
                % {open_day,OpenDay,OpenOver},
                {act_time,StartTime,ShowEtTime}
            ],
            lib_race_act_util:check_condition_list(Condition);
        false-> false
    end;
is_show(_)->
    false.

%%推送
send_to_all() ->
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    SendList = lib_race_act_util:combine_opening_act_list(OpenList,ShowList,[]),
    {ok, Bin} = pt_338:write(33800, [SendList]),
    lib_server_send:send_to_all(Bin).

%%gm刷新
%%把数据库和ets删了，重新加载一遍
gm_refresh_type(Type,_Num) ->
    Sql = io_lib:format(<<"delete from `race_act` where type=~p ">>,[Type]),
    db:execute(Sql),
    ets:delete(?ETS_RACE_ACT, Type),
    List = ets:tab2list(?ETS_RACE_ACT),
    OpenAct1 = [{Type1,SubType}||#ets_race_act{type=Type1,subtype=SubType}<-List],
    {OpenList,ShowList} = lib_race_act_util:get_opening_act(),
    AddAct = refresh_open_act(OpenList++ShowList, OpenAct1, []),
    ?IF(AddAct==[], ok, ?INFO("~p~n",[AddAct])),
    log(AddAct, 1),
    save_act(AddAct).

log([],_OpenType) -> ok;
log(List, OpenType) ->
    ServerId = config:get_server_id(),
    Utime = utime:unixtime(),
    LogList = [[ServerId,Type,SubType,OpenType,Utime]||{Type,SubType}<-List],
    lib_log_api:log_race_act(LogList).
    