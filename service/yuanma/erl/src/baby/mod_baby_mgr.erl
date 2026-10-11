%%-----------------------------------------------------------------------------
%% @Module  :       mod_baby_mgr
%% @Author  :       lxl
%% @Email   :       
%% @Created :       2019.5.10
%% @Description:    宝宝
%%-----------------------------------------------------------------------------
-module(mod_baby_mgr).

-include("rec_baby.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_module.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    cast/1
    , call/1
    , daily_clear/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = do_init(#baby_state{}),
    ets:new(?ets_baby_basic, [named_table, {keypos, #baby_basic.role_id}, {read_concurrency, true}, public]),
    %?PRINT("baby init## ~p~n", [State]),
    {ok, State}.

daily_clear() ->
    cast({daily_clear}).

cast(Msg) ->
    gen_server:cast(?MODULE, Msg).

call(Msg) ->
    gen_server:call(?MODULE, Msg).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, baby_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%%-------------------------------- 零点清理
do_handle_cast({daily_clear}, State) ->
    ?PRINT("daily_clear daily_clear############ ~p~n", [daily_clear]),
    #baby_state{task_map = TaskMap, praise_map = PraiseMap} = State,
    %% 零点清理任务和点赞信息
    lib_baby:db_delete_baby_task(),
    lib_baby:db_delete_baby_praise(),
    %% 点赞榜单发奖励
    send_praise_rank_reward(PraiseMap),
    NewTaskMap = maps:map(fun(_, _V) -> [] end, TaskMap),
    erase(praise_rank),
    erase(praise_change),
    erase(praise_rank_time),
    {ok, #baby_state{task_map = NewTaskMap}};

%%------------------------------ 宝宝激活：生成对应的任务
do_handle_cast({active_baby, [RoleId, RoleLv]}, State) ->
    #baby_state{task_map = TaskMap} = State,
    NewBabyTaskList = new_baby_task_list(RoleId, RoleLv),
    ?PRINT("active_baby ## NewBabyTaskList: ~p~n", [NewBabyTaskList]),
    NewTaskMap = maps:put(RoleId, NewBabyTaskList, TaskMap),
    {ok, State#baby_state{task_map = NewTaskMap}};

%%------------------------------ 宝宝任务触发
do_handle_cast({send_baby_raise_info, [RoleId, Sid, RoleLv, RaiseLv, RaiseExp, RaisePower]}, State) ->
    #baby_state{task_map = TaskMap} = State,
    {BabyTaskList, NewTaskMap} = get_baby_task(RoleId, RoleLv, TaskMap), 
    SendTaskList = [{TaskId, FinishNum, FinishState} ||#baby_task{task_id=TaskId, finish_num=FinishNum, finish_state=FinishState} <- BabyTaskList],
    ?PRINT("baby_raise_info ## SendTaskList: ~p~n", [SendTaskList]),
    {ok, Bin} = pt_182:write(18203, [RaiseLv, RaiseExp, SendTaskList, RaisePower]),
    lib_server_send:send_to_sid(Sid, Bin),
    {ok, State#baby_state{task_map = NewTaskMap}};

do_handle_cast({trigger_task, [RoleId, TaskId, Num]}, State) ->
    #baby_state{task_map = TaskMap} = State,
    {BabyTaskList, TaskMapAf} = get_baby_task(RoleId, TaskMap),
    case lists:keyfind(TaskId, #baby_task.task_id, BabyTaskList) of 
        #baby_task{finish_num = FinishNum, finish_state = 0} = BabyTask ->
            case data_baby_new:base_baby_raise(TaskId) of 
                #base_baby_raise{num_con = NumCon, raise_exp = _AddRaiseExp} ->
                    {NewFinishNum, NewFinishState} = ?IF(FinishNum+Num>=NumCon, {NumCon, 1}, {FinishNum+Num, 0}),
                    NewBabyTask = BabyTask#baby_task{finish_num = NewFinishNum, finish_state = NewFinishState},
                    lib_baby:db_replace_baby_task(RoleId, NewBabyTask),
                    %lib_baby:add_raise_exp(RoleId, AddRaiseExp, [TaskId]),
                    NewTaskMap = maps:put(RoleId, lists:keyreplace(TaskId, #baby_task.task_id, BabyTaskList, NewBabyTask), TaskMapAf),
                    lib_server_send:send_to_uid(RoleId, pt_182, 18221, [TaskId, NewFinishNum, NewFinishState]),
                    ?PRINT("trigger_task ## NewBabyTask: ~p~n", [NewBabyTask]),
                    {ok, State#baby_state{task_map = NewTaskMap}};
                _ ->
                    {ok, State}
            end;
        _ ->
            ?PRINT("trigger_task ## no task ~p~n", [{RoleId, TaskId}]),
            {ok, State}
    end;

do_handle_cast({display_baby, [RoleId, RoleName, BabyBasic]}, State) ->
    #baby_state{praise_map = PraiseMap} = State,
    PraiseInfo = #praise_info{role_id = RoleId, role_name = RoleName},
    NewPraiseMap = maps:put(RoleId, PraiseInfo, PraiseMap),
    lib_baby:ets_insert(BabyBasic),
    {ok, State#baby_state{praise_map = NewPraiseMap}};

do_handle_cast({send_praise_rank, [RoleId, Sid]}, State) ->
    IsNeedRefresh = is_need_refresh_rank(),
    #baby_state{praise_map = PraiseMap} = State,
    case IsNeedRefresh of 
        true ->
            RankList = refresh_praise_rank(PraiseMap),
            put(praise_rank, RankList),
            put(praise_change, false),
            put(praise_rank_time, utime:unixtime());
        _ ->
            case get(praise_rank) of 
                undefined ->
                    RankList = refresh_praise_rank(PraiseMap),
                    put(praise_rank, RankList),
                    put(praise_change, false),
                    put(praise_rank_time, utime:unixtime());
                List ->
                    RankList = List
            end
    end,
    %?PRINT("send_praise_rank ## RankList: ~p~n", [RankList]),
    {ok, Bin} = pt_182:write(18208, [RoleId, RankList]),
    lib_server_send:send_to_sid(Sid, Bin),
    {ok, State};

do_handle_cast({send_praise_rank_record, [RoleId, Sid]}, State) ->
    #baby_state{praise_map = PraiseMap} = State,
    case maps:get(RoleId, PraiseMap, 0) of 
        #praise_info{fan_list = FanList} -> 
            SendList = FanList;
        _ -> SendList = []
    end,
    F = fun({FanId, FanName}, List) ->
        case FanId =/= RoleId of 
            true ->
                case maps:get(FanId, PraiseMap, 0) of 
                    #praise_info{fan_list = FanList2} -> 
                        IsPraiseBack = ?IF(lists:keymember(RoleId, 1, FanList2) == true, 1, 0),
                        [{FanId, FanName, IsPraiseBack}|List];
                    _ ->
                        [{FanId, FanName, 0}|List]
                end;
            _ ->
                List
        end
    end,
    NewSendList = lists:foldl(F, [], SendList),
    {ok, Bin} = pt_182:write(18209, [NewSendList]),
    lib_server_send:send_to_sid(Sid, Bin),
    %?PRINT("send_praise_rank_record ## Bin: ~p~n", [Bin]),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, baby_state)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({is_in_display, RoleId}, State) ->
    #baby_state{praise_map = PraiseMap} = State,
    case maps:get(RoleId, PraiseMap, 0) of 
        #praise_info{} -> Reply = true;
        _ -> Reply = false
    end,
    {ok, Reply, State};

do_handle_call({praise_player_baby, [RoleId, PraiserId, PraiserName]}, State) ->
    #baby_state{praise_map = PraiseMap} = State,
    case maps:get(RoleId, PraiseMap, 0) of 
        #praise_info{fan_list = FanList} = PraiseInfo -> 
            case lists:keymember(PraiserId, 1, FanList) of 
                false ->
                    NewFanList = [{PraiserId, PraiserName}|FanList],
                    lib_baby:db_replace_baby_praise(RoleId, PraiserId, PraiserName),
                    NewPraiseInfo = PraiseInfo#praise_info{fan_list = NewFanList},
                    Reply = {ok, true},
                    put(praise_change, true),
                    case maps:get(PraiserId, PraiseMap, 0) of 
                        #praise_info{fan_list = FanList2} ->
                            IsPraise = ?IF(lists:keymember(RoleId, 1, FanList2) == true, true, false);
                        _ ->
                            IsPraise = false
                    end,
                    case IsPraise == false andalso PraiserId =/= RoleId of 
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_182, 18224, [PraiserId]),
                            lib_chat:send_TV({player, RoleId}, ?MOD_BABY, 2, [PraiserName, PraiserId]);
                        _ ->
                            ok
                    end,
                    NewState = State#baby_state{praise_map = maps:put(RoleId, NewPraiseInfo, PraiseMap)};
                _ ->
                    Reply = {ok, false}, NewState = State
            end;
        _ -> 
            case lib_baby:is_baby_active(RoleId) of 
                true ->
                    case lib_player:get_role_name_by_id(RoleId) of 
                        null -> RoleName = "";
                        RoleName -> ok
                    end,
                    NewFanList = [{PraiserId, PraiserName}],
                    lib_baby:db_replace_baby_praise(RoleId, PraiserId, PraiserName),
                    NewPraiseInfo = #praise_info{role_id = RoleId, role_name = RoleName, fan_list = NewFanList},
                    Reply = {ok, true},
                    put(praise_change, true),
                    case maps:get(PraiserId, PraiseMap, 0) of 
                        #praise_info{fan_list = FanList2} ->
                            IsPraise = ?IF(lists:keymember(RoleId, 1, FanList2) == true, true, false);
                        _ ->
                            IsPraise = false
                    end,
                    case IsPraise == false andalso PraiserId =/= RoleId of 
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_182, 18224, [PraiserId]),
                            lib_chat:send_TV({player, RoleId}, ?MOD_BABY, 2, [PraiserName, PraiserId]);
                        _ ->
                            ok
                    end,
                    NewState = State#baby_state{praise_map = maps:put(RoleId, NewPraiseInfo, PraiseMap)};
                _ ->
                    Reply = {false, ?ERRCODE(err182_player_not_active_baby)},
                    NewState = State
            end
    end,
    {ok, Reply, NewState};

do_handle_call({get_baby_task_reward, RoleId, TaskId}, State) ->
    #baby_state{task_map = TaskMap} = State,
    BabyTaskList = maps:get(RoleId, TaskMap, []),
    case lists:keyfind(TaskId, #baby_task.task_id, BabyTaskList) of 
        #baby_task{finish_num = FinishNum, finish_state = 1} = BabyTask -> 
            NewBabyTask = BabyTask#baby_task{finish_state = 2},
            lib_baby:db_replace_baby_task(RoleId, NewBabyTask),
            NewTaskMap = maps:put(RoleId, lists:keyreplace(TaskId, #baby_task.task_id, BabyTaskList, NewBabyTask), TaskMap),
            lib_server_send:send_to_uid(RoleId, pt_182, 18222, [?SUCCESS, TaskId, FinishNum, 2]),
            NewState = State#baby_state{task_map = NewTaskMap},
            Reply = {ok};
        #baby_task{finish_state = 2} ->
            NewState = State,
            Reply = {false, ?ERRCODE(err182_task_reward_get)};
        _ -> 
            NewState = State,
            Reply = {false, ?ERRCODE(err182_task_not_finish)}
    end,
    {ok, Reply, NewState};

do_handle_call(_Request, State) -> 
    {ok, ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进程初始化
do_init(BabyState) ->
    TaskMap = do_init_baby_task(),
    PraiseMap = do_init_baby_praise(),
    BabyState#baby_state{task_map = TaskMap, praise_map = PraiseMap}.

%% 任务初始化
do_init_baby_task() ->
    case lib_baby:db_select_baby_task_all() of 
        [] -> #{};
        TaskList ->
            F = fun([RoleId, TaskId, FinishNum, FinishState], Map) ->
                BabyTask = #baby_task{task_id = TaskId, finish_num = FinishNum, finish_state = FinishState},
                BabyTaskList = maps:get(RoleId, Map, []),
                maps:put(RoleId, [BabyTask|BabyTaskList], Map)
            end,
            lists:foldl(F, #{}, TaskList)
    end.

do_init_baby_praise() ->
    case lib_baby:db_select_baby_praise_all() of 
        [] -> #{};
        PraiseList ->
            F = fun([RoleId, PraiserId, PraiserName], Map) ->
                case maps:get(RoleId, Map, 0) of 
                    #praise_info{fan_list = FanList} = PraiseInfo -> ok;
                    _ ->
                        FanList = [],
                        case lib_player:get_role_name_by_id(RoleId) of 
                            null -> RoleName = "";
                            RoleName -> ok
                        end,
                        PraiseInfo = #praise_info{role_id = RoleId, role_name = RoleName}
                end,
                maps:put(RoleId, PraiseInfo#praise_info{fan_list = [{PraiserId, PraiserName}|FanList]}, Map)
            end,
            lists:foldl(F, #{}, PraiseList)
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 新建宝宝的任务列表
new_baby_task_list(RoleId, RoleLv) ->
    BabyTaskList = data_baby_new:get_all_baby_task(),
    BabyTaskListAfLv = [TaskId || {TaskId, OpenLv} <- BabyTaskList, OpenLv =< RoleLv],
    NewBabyTaskList = [#baby_task{task_id = TaskId} ||TaskId <- BabyTaskListAfLv],
    lib_baby:db_replace_baby_task_all(RoleId, NewBabyTaskList),
    NewBabyTaskList.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 发放宝宝点赞榜单奖励
send_praise_rank_reward(PraiseMap) ->
    NowTime = utime:unixtime(),
    PrasieList = refresh_praise_rank(PraiseMap),
    FSort = fun({_RoleId1, _RoleName1, BabyPower1, PraiseNum1}, {_RoleId2, _RoleName2, BabyPower2, PraiseNum2}) ->
        if 
            PraiseNum1 > PraiseNum2 -> true;
            PraiseNum1 < PraiseNum2 -> false;
            true ->
                BabyPower1 > BabyPower2
        end
    end,
    PraiseRankList = lists:sort(FSort, PrasieList),
    spawn(fun() ->
        FSend = fun({RoleId, _RoleName, _BabyPower, PraiseNum}, {Rank, LogList}) ->
            case data_baby_new:get_praise_reward_by_rank(Rank) of 
                RewardList when is_list(RewardList) ->
                    Title = utext:get(1820001),
                    Content = utext:get(1820002, [Rank]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
                _ ->
                    RewardList = [],
                    ?ERR("praise rank reward err:~p~n", [Rank]),
                    skip
            end,
            Rank rem 10 == 0 andalso timer:sleep(200),
            {Rank + 1, [[RoleId, Rank, PraiseNum, util:term_to_bitstring(RewardList), NowTime]|LogList]}
        end,
        {_, LogList} = lists:foldl(FSend, {1, []}, PraiseRankList),
        lib_log_api:log_baby_praise_rank(LogList)
    end),
    ok.

get_baby_task(RoleId, TaskMap) ->
    case maps:get(RoleId, TaskMap, 0) of 
        0 ->
            case lib_baby:is_baby_active(RoleId) of 
                false -> {[], TaskMap};
                _ ->
                    #figure{lv = RoleLv} = lib_role:get_role_figure(RoleId),
                    get_baby_task(RoleId, RoleLv, TaskMap)
            end;   
        [] ->
            #figure{lv = RoleLv} = lib_role:get_role_figure(RoleId),
            get_baby_task(RoleId, RoleLv, TaskMap);
        BabyTaskList ->
            {BabyTaskList, TaskMap}
    end.
%% 这个函数是在玩家激活了宝宝的情况下获取信息
get_baby_task(RoleId, RoleLv, TaskMap) ->
    case maps:get(RoleId, TaskMap, []) of  
        [] ->
            NewBabyTaskList = new_baby_task_list(RoleId, RoleLv),
            {NewBabyTaskList, maps:put(RoleId, NewBabyTaskList, TaskMap)};
        BabyTaskList ->
            {BabyTaskList, TaskMap}
    end.

%% 判断是否需要刷新点赞榜列表
is_need_refresh_rank() ->
    case get(praise_change) of 
        true -> true;
        _ ->
            case get(praise_rank_time) of 
                undefined -> true;
                Time ->
                    ?IF((utime:unixtime() - Time) >= 300, true, false)
            end
    end.
%% 刷新点赞榜列表
refresh_praise_rank(PraiseMap) ->
    F = fun(RoleId, PraiseInfo, Return) ->
        #praise_info{role_name = RoleName, fan_list = FanList} = PraiseInfo,
        PraiseNum = length(FanList),
        BabyBasic = lib_baby:ets_keyfind(RoleId),
        #baby_basic{
            active_time = ActiveTime, raise_lv = _RaiseLv, stage = _Stage, stage_lv = _StageLv, 
            equip_list = _EquipList, active_list = _ActiveList, total_power = BabyPower
        } = BabyBasic,
        case ActiveTime > 0 of 
            false -> Return;
            _ ->
                % CalcAttrList = [
                %     {?ATTR_TYPE_RAISE, RaiseLv}, {?ATTR_TYPE_STAGE, Stage, StageLv}, 
                %     {?ATTR_TYPE_EQUIP, EquipList}, {?ATTR_TYPE_FIGURE, ActiveList}
                % ],
                % BabyAttr = lib_baby:get_baby_type_attr(CalcAttrList),
                % BabyPower = lib_player:calc_all_power(BabyAttr),
                [{RoleId, RoleName, BabyPower, PraiseNum}|Return]
        end
    end,
    PraiseList = maps:fold(F, [], PraiseMap),
    PraiseList.