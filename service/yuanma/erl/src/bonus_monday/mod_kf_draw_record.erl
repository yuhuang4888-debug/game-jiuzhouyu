%%-----------------------------------------------------------------------------
%% @Module  :       mod_kf_draw_record.hrl
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-4-26
%% @Description:    跨服抽奖记录管理
%%-----------------------------------------------------------------------------
-module(mod_kf_draw_record).

-include("common.hrl").
-include("def_module.hrl").

-behaviour(gen_server).
%% API
-export([start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).
%%本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

-record(draw_state, {
        record_map = #{}    %% key {modid, submodid} => #log_list{}
    }).

-record(log_list, {
        key = {0,0},  %% {mod,submod}
        log_list = [] %% [#log{},..]
    }).

-record(log,{
        server_id = 0,
        server_num = 0,
        server_name = <<>>,
        role_id = 0,
        role_name = <<>>,
        reward = [],
        utime = 0,
        picture = <<>>,
        picture_ver = 0,
        turn = 0,   
        creer = 0
        ,reward_list = []   %% 奖励列表  目前用的有藏宝图
    }).

-define(SQL_SELECT_KF,  <<"SELECT `mod_id`,`sub_mod`,`server_id`,`server_num`,`server_name`,`role_id`,`role_name`,`reward`,`utime`, `picture`, `picture_ver`,`creer`,`turn` FROM `kf_draw_log`">>).
-define(SQL_INSERT_KF,  <<"INSERT INTO `kf_draw_log` (`mod_id`,`sub_mod`,`server_id`,`server_num`,`server_name`,`role_id`,`role_name`,`reward`,`utime`,`picture`, `picture_ver`, `creer`,`turn`) VALUES (~p,~p,~p,~p,'~s',~p,'~s','~s',~p,'~s',~p,~p,~p)">>).
-define(SQL_TRUNCATE,   <<"TRUNCATE TABLE `kf_draw_log`">>).
-define(SQL_DELETE,     <<"DELETE FROM `kf_draw_log` WHERE `mod_id` = ~p AND `sub_mod` = ~p">>).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    DbDataList = db:get_all(io_lib:format(?SQL_SELECT_KF,[])),
    Now = utime:unixtime(),
    Fun = fun([Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, Reward, Utime, Picture, PictureVer, Creer, Turn], TemMap) ->
        RewardList = util:bitstring_to_term(Reward),
        % ServerName = util:fix_sql_str(SName),
        case maps:get({Mod, SubMod}, TemMap, []) of
            #log_list{log_list = LogList} ->skip;
            _ ->
                LogList = []
        end,
        IsClean = is_clean(Now, Utime, Mod),
%%        SameWeek = utime:is_same_week(Now, Utime),
        if
            IsClean ->
                LogListMap = #log_list{key = {Mod, SubMod}, log_list = LogList};
            true ->
                Log = #log{
                    server_id = ServerId, server_num = ServerNum, server_name = ServerName, role_id = RoleId,
                    role_name = RoleName, reward = RewardList, utime = Utime, picture = Picture, picture_ver = PictureVer, 
                    creer = Creer, reward_list = RewardList, turn = Turn
                },
                LogListMap = #log_list{key = {Mod, SubMod}, log_list = [Log|LogList]}
               
        end,
        maps:put({Mod, SubMod}, LogListMap, TemMap)
    end,
    RecordMap = lists:foldl(Fun, #{}, DbDataList),
   {ok, #draw_state{record_map = RecordMap}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_kf_draw_record Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_draw_record Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_draw_record Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'get_draw_log', Mod, SubMod, ServerId, RoleId}, State) ->
    #draw_state{record_map = RecordMap} = State,
    case maps:get({Mod, SubMod}, RecordMap, []) of
        #log_list{log_list = LogList} ->skip;
        _ ->
            LogList = []
    end,
    send_to_mod(Mod, ServerId, RoleId, LogList),
    {noreply, State};

do_handle_cast({'save_draw_log', Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, Type, GoodsPoolid, Utime, Picture, PictureVer, Creer, Turn}, State) ->
    #draw_state{record_map = RecordMap} = State,
    case maps:get({Mod, SubMod}, RecordMap, []) of
        #log_list{log_list = LogList} ->skip;
        _ ->
            LogList = []
    end,
    Log = #log{server_id = ServerId, server_num = ServerNum, server_name = ServerName, role_id = RoleId, role_name = RoleName, 
        reward = {Type, GoodsPoolid}, utime = Utime, picture = Picture, picture_ver = PictureVer, creer = Creer, turn = Turn},
    Num = get_list_length(Mod, SubMod),
    NewLogList = lists:sublist([Log|LogList], Num),
    LogListMap = #log_list{key = {Mod, SubMod}, log_list = NewLogList},
    notify_all_player(Mod, SubMod, NewLogList),
    NewMap = maps:put({Mod, SubMod}, LogListMap, RecordMap),
    db_save(Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, {Type, GoodsPoolid}, Utime, Picture, PictureVer, Creer, Turn),
    {noreply, State#draw_state{record_map = NewMap}};

%% 支持多列表  目前用的有藏宝图的
do_handle_cast({'save_draw_log2', Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, RewardList, Utime, Picture, PictureVer, Creer}, State) ->
    #draw_state{record_map = RecordMap} = State,
    case maps:get({Mod, SubMod}, RecordMap, []) of
        #log_list{log_list = LogList} ->skip;
        _ ->
            LogList = []
    end,
    Log = #log{server_id = ServerId, server_num = ServerNum, server_name = ServerName, role_id = RoleId, role_name = RoleName,
        reward = RewardList, utime = Utime, picture = Picture, picture_ver = PictureVer, creer = Creer, reward_list = RewardList, turn = 0},
    Num = get_list_length(Mod, SubMod),
    NewLogList = lists:sublist([Log|LogList], Num),
    LogListMap = #log_list{key = {Mod, SubMod}, log_list = NewLogList},
    notify_all_player(Mod, SubMod, NewLogList),
    NewMap = maps:put({Mod, SubMod}, LogListMap, RecordMap),
    db_save(Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, RewardList, Utime, Picture, PictureVer, Creer, 0),
    {noreply, State#draw_state{record_map = NewMap}};

%% 支持多列表  目前用的有藏宝图的
do_handle_cast({'get_draw_log2', Mod, SubMod, ServerId, RoleId}, State) ->
    #draw_state{record_map = RecordMap} = State,
    case maps:get({Mod, SubMod}, RecordMap, []) of
        #log_list{log_list = LogList} ->skip;
        _ ->
            LogList = []
    end,
    send_to_mod(Mod, ServerId, RoleId, LogList),
    {noreply, State};



do_handle_cast({'remove_draw_log', Mod, SubMod}, State) ->
    #draw_state{record_map = RecordMap} = State,
    NewMap = maps:remove({Mod, SubMod}, RecordMap),
    db_delete(Mod, SubMod),
    {noreply, State#draw_state{record_map = NewMap}};

do_handle_cast({'server_name_change', ServerId, ServerName}, State) ->
    #draw_state{record_map = RecordMap} = State,
    Fun = fun(_, Value) ->
        #log_list{log_list = LogList} = Value,
        F1 = fun
                 (#log{server_id = SerId} = Log, Acc) when ServerId == SerId ->
                     NewLog = Log#log{server_name = ServerName},
                     [NewLog|Acc];
                 (Log, Acc) -> [Log|Acc]
             end,
        NewLogList = lists:foldl(F1, [], LogList),
        Value#log_list{log_list = NewLogList}
          end,
    Sql = io_lib:format(<<"Update `kf_draw_log` SET server_name = '~s' WHERE server_id = ~p">>, [ServerName, ServerId]),
    db:execute(Sql),
    NewMap = maps:map(Fun, RecordMap),
    {noreply, State#draw_state{record_map = NewMap}};

do_handle_cast(_, State) -> {noreply, State}.

do_handle_call(_,  State) -> {noreply, ok, State}.

do_handle_info(_, State) -> {noreply, State}.



get_list_length(Mod, _SubMod) when Mod == ?MOD_BONUS_MONDAY ->
    case data_monday_bonus:get_value(kf_log_num) of
        Num when is_integer(Num) -> skip;
        _ -> Num = 0
    end,
    Num;
get_list_length(Mod, _SubMod) when Mod == ?MOD_TREASURE_MAP ->
    case data_treasure_map:get_kv(log_num) of
        Num when is_integer(Num) -> skip;
        _ -> Num = 0
    end,
    Num;
get_list_length(_, _) -> 0.

get_open_lv(Mod, _SubMod) when Mod == ?MOD_BONUS_MONDAY ->
    case data_monday_bonus:get_value(open_lv) of
        Num when is_integer(Num) -> skip;
        _ -> Num = 0
    end,
    {Num, 9999};
get_open_lv(_,_) -> {0,9999}.

db_save(Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, Reward, Utime, Picture, PictureVer, Creer, Turn) ->
    RewardList = util:term_to_string(Reward),
    db:execute(io_lib:format(?SQL_INSERT_KF, [Mod, SubMod, ServerId, ServerNum, ServerName, RoleId, RoleName, 
        RewardList, Utime, Picture, PictureVer, Creer, Turn])).

db_delete(Mod, SubMod) ->
    db:execute(io_lib:format(?SQL_DELETE, [Mod, SubMod])).

send_to_mod(Mod, ServerId, RoleId, LogList) when Mod == ?MOD_BONUS_MONDAY ->
    Fun = fun(#log{server_id = TServerId, server_num = ServerNum,role_id = TRoleId, role_name = RoleName, turn = Turn,
            reward = {Type, GoodsPoolid}, utime = Utime, picture = Picture, picture_ver = PictureVer, creer = Creer}, Acc) ->
        [{TServerId, ServerNum, TRoleId, RoleName,Type, GoodsPoolid, Utime, Picture, PictureVer, Creer, Turn}|Acc]
    end,
    SendList = lists:foldl(Fun, [], LogList),
    {ok, Bin} = pt_179:write(17905, [lists:reverse(SendList)]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]);


send_to_mod(Mod, ServerId, RoleId, LogList) when Mod == ?MOD_TREASURE_MAP ->
    Fun = fun(#log{server_num = ServerNum,  role_name = RoleName, reward_list = RewardList, role_id = RoleId1}, Acc) ->
        [{ServerNum, RoleId1, RoleName, RewardList}|Acc]
          end,
    SendList = lists:foldl(Fun, [], LogList),
%%    ?PRINT("++++++++++ SendList  ~p ~n", [SendList]),
    {ok, Bin} = pt_203:write(20303, [lists:reverse(SendList)]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).

notify_all_player(Mod, SubMod, LogList) when Mod == ?MOD_BONUS_MONDAY ->
    Type = all_lv,
    Value = get_open_lv(Mod, SubMod),
    Fun = fun(#log{server_id = TServerId, server_num = ServerNum, role_id = TRoleId, role_name = RoleName, turn = Turn,
            reward = {TType, GoodsPoolid}, utime = Utime, picture = Picture, picture_ver = PictureVer, creer = Creer}, Acc) ->
        [{TServerId, ServerNum, TRoleId, RoleName,TType, GoodsPoolid, Utime, Picture, PictureVer, Creer, Turn}|Acc]
    end,
    SendList = lists:foldl(Fun, [], LogList),
    {ok, BinData} = pt_179:write(17905, [lists:reverse(SendList)]),
    mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [Type, Value, BinData]);
notify_all_player(_,_,_) ->
    skip.



is_clean(_Now, _Utime, ?MOD_TREASURE_MAP) ->
    false;
is_clean(Now, Utime, _) ->
    SameWeek = utime:is_same_week(Now, Utime),
    if
        SameWeek == true ->
            false;
        true ->
            true
    end.