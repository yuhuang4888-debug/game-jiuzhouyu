%% ---------------------------------------------------------------------------
%% @doc mod_contract_challenge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/26
%% @deprecated  契约挑战（定制活动）
%% ---------------------------------------------------------------------------
-module(mod_contract_challenge).

-behaviour(gen_server).

%% API
-export([
    start_link/0,
    flush_daily_task/1,
    act_end/1,
    send_act_info/2,
    send_reward_status/2,
    receive_reward/3,
    get_point_reward/3,
    task_process/4,
    active_legend/3,
    gm_complete_task/2,
    gm_flush_daily/1,
    gm_add_point/3,
    act_start/1,
    fix_soul_dungeon/1,
    cancel_lenged_contract/2,
    get_open_day_and_flush_time/1,
    add_point/3,
    flush_recharge_cost/0
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).


-define(SERVER, ?MODULE).

-include ("common.hrl").
-include ("custom_act.hrl").
-include ("contract_challenge.hrl").
-include ("def_fun.hrl").
-include ("predefine.hrl").
-include ("server.hrl").
-include ("def_module.hrl").
-include ("figure.hrl").
-include ("dungeon.hrl").

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% 每日刷新任务
flush_daily_task(SubType) ->
    gen_server:cast(?MODULE, {'flush_daily_task', SubType}).

%% 活动开启
act_start(ActInfo) ->
    gen_server:cast(?MODULE, {'act_start', ActInfo}).

%% 活动结束
act_end(ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', ActInfo}).

%% 发送活动信息
send_act_info(RoleId, SubType) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId, SubType}).

%% 发送奖励
send_reward_status(RoleId, SubType) ->
    gen_server:cast(?MODULE, {'send_reward_status', RoleId, SubType}).

%% 领取奖励
receive_reward(RoleId, SubType, GradeId) ->
    gen_server:cast(?MODULE, {'receive_reward', RoleId, SubType, GradeId}).

%% 领取点数奖励
get_point_reward(RoleId, SubType, ItemId) ->
    gen_server:cast(?MODULE, {'get_point_reward', RoleId, SubType, ItemId}).

%% 任务进度触发
task_process(RoleId, Module, SubModule, Count) ->
    gen_server:cast(?MODULE, {'task_process', RoleId, Module, SubModule, Count}).

active_legend(RoleId, RoleName, SubType) ->
    gen_server:cast(?MODULE, {'active_legend', RoleId, RoleName, SubType}).

%% gm完成任务
gm_complete_task(RoleId, TaskId) ->
    gen_server:cast(?MODULE, {'gm_complete_task', RoleId, TaskId}).
%% gm刷新日常
gm_flush_daily(RoleId) ->
    gen_server:cast(?MODULE, {'gm_flush_daily', RoleId}).
%% gm激活传说契约
gm_add_point(Ps, SubType, AddPoint) ->
    #player_status{id = RoleId} = Ps,
    gen_server:cast(?MODULE, {'gm_add_point', SubType, RoleId, AddPoint}).
%% 修复聚魂本扫荡
fix_soul_dungeon(SubType) ->
    %gen_server:cast(?MODULE, {'fix_soul_dungeon', SubType}).
    gen_server:cast(?MODULE, {'fix_soul_dungeon2', SubType}).
%% 取消用户传说契约
cancel_lenged_contract(SubType, RoleId) ->
    gen_server:cast(?MODULE, {'cancel_lenged_contract', SubType, RoleId}).
add_point(SubType, Point, RoleId) ->
    gen_server:cast(?MODULE, {'add_point', SubType, Point, RoleId}).
flush_recharge_cost() ->
    gen_server:cast(?MODULE, 'flush_recharge_cost').
%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, init_data()}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Msg, State) ->
    case catch do_handle_info(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Handle function
%%%===================================================================
do_handle_call(_Msg, _From, State) ->  {reply, ok, State}.

%% 每日累计充值累计消费清空
do_handle_cast(flush_recharge_cost, State) ->
    F = fun(SubType, ChallengeStatus) ->
        #challenge_status{role_map = RoleMap} = ChallengeStatus,
        F2 = fun(RoleId, RoleChallenge) ->
            NewRoleChallenge = RoleChallenge#role_challenge{daily_recharge = 0, daily_cost = 0},
            lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallenge),
            NewRoleChallenge
            end,
        NewRoleMap = maps:map(F2, RoleMap),
        ChallengeStatus#challenge_status{role_map = NewRoleMap}
        end,
    NewState = maps:map(F, State),
    {noreply, NewState};

do_handle_cast({'add_point', SubType, Point, 0}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            F = fun(Key,Value) ->
                #role_challenge{sum_point = OldPoint} = Value,
                NewPoint = OldPoint + Point,
                NewValue = Value#role_challenge{sum_point = NewPoint},
                {LastValue, _} = lib_contract_challenge_util:flush_reward_status(SubType, NewValue),
                lib_contract_challenge_util:save_act_info(SubType, Key, LastValue),
                LastValue
                end,
            NewRoleMap = maps:map(F, RoleMap),
            NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;
do_handle_cast({'add_point', SubType, Point, RoleId}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            case maps:get(RoleId, RoleMap, false) of
                false -> {noreply, State};
                #role_challenge{sum_point = OldPoint} = RoleChallenge ->
                    NewPoint = OldPoint + Point,
                    NewRoleChallenge = RoleChallenge#role_challenge{sum_point = NewPoint},
                    {LastRoleChallenge, _} = lib_contract_challenge_util:flush_reward_status(SubType, NewRoleChallenge),
                    lib_contract_challenge_util:save_act_info(SubType, RoleId, LastRoleChallenge),
                    NewRoleMap = maps:put(RoleId, LastRoleChallenge, RoleMap),
                    NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
                    NewState = maps:put(SubType, NewChallengeStatus, State),
                    {noreply, NewState}
            end
    end;
%% 修复圣兽领
do_handle_cast({'fix_soul_dungeon2', SubType}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            F = fun(RoleId, RoleChallenge) ->
                    #role_challenge{challenge_list = ChallengeList} = RoleChallenge,
                    case lists:keyfind(?MOD_EUDEMONS_BOSS, #challenge_item.module, ChallengeList) of
                        #challenge_item{is_get = ?NO_GET, task_id = TaskId} = Item ->
                            Num = mod_daily:get_count_offline(RoleId, ?MOD_BOSS, ?MOD_BOSS_TIRE, 10),
                            #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TaskId),
                            IsGet = ?IF(Num >= NeedNum, ?CAN_GET, ?NO_GET),
                            NewItem = Item#challenge_item{is_get = IsGet, grand_num = Num},
                            lib_contract_challenge_util:save_act_task_item(SubType, RoleId, NewItem),
                            NewChallengeList = lists:keystore(?MOD_EUDEMONS_BOSS, #challenge_item.module, ChallengeList, NewItem),
                            lib_contract_challenge_util:push_challenge_status(SubType, RoleId, NewChallengeList),
                            RoleChallenge#role_challenge{challenge_list = NewChallengeList};
                        _ -> RoleChallenge
                    end
                end,
            NewRoleMap = maps:map(F, RoleMap),
            NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;
do_handle_cast({'fix_soul_dungeon', SubType}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            F = fun(RoleId, Value) ->
                #role_challenge{challenge_list = ChallengeList} = Value,
                ChallengeItem = lists:keyfind(?DUNGEON_TYPE_RUNE, #challenge_item.sub_module, ChallengeList),
                #challenge_item{is_get = IsGet, task_id = TaskId} = ChallengeItem,
                NewChallengeList =
                    case IsGet of
                        ?NO_GET ->
                            DailyCount = mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, ?DUNGEON_TYPE_RUNE),
                            #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TaskId),
                            NewChallengeItem =
                                case DailyCount >= NeedNum of
                                    true ->
                                        ChallengeItem#challenge_item{is_get = ?CAN_GET, grand_num = DailyCount};
                                    false -> ChallengeItem#challenge_item{is_get = ?NO_GET, grand_num = DailyCount}
                                end,
                            lib_contract_challenge_util:save_act_task_item(SubType, RoleId, NewChallengeItem),
                            lists:keystore(?DUNGEON_TYPE_RUNE, #challenge_item.sub_module, ChallengeList, NewChallengeItem);
                        _ -> ChallengeList
                    end,
                lib_contract_challenge_util:push_challenge_status(SubType, RoleId, NewChallengeList),
                NewValue = Value#role_challenge{challenge_list = NewChallengeList},
                fix_rechage_cost(RoleId, SubType, NewValue)
                end,
            NewRoleMap = maps:map(F, RoleMap),
            NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;
do_handle_cast({'flush_daily_task', SubType}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            NewChallengeStatus = lib_contract_challenge_mod:flush_daily_task(SubType, ChallengeStatus),
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;

%% 活动开启调用
%% 确保数据初始化了，未初始化成功则初始化
do_handle_cast({'act_start', #act_info{key = {_Type, SubType}}}, State) ->
    NewState =
    case maps:get(SubType, State, false) of
        false ->
            ChallengeStatus = init_sub_data(SubType),
            maps:put(SubType, ChallengeStatus, State);
        _ -> State
    end,
    {noreply, NewState};
%% 活动结束，结算未领取
do_handle_cast({'act_end', #act_info{key = {_Type, SubType}}}, State) ->
    NewState =
        case maps:get(SubType, State, false) of
            false -> State;
            ChallengeStatus ->
                OnlineRoles = ets:tab2list(?ETS_ONLINE),
                [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_contract_challenge, act_end_action, []) || E <- OnlineRoles],
                spawn(fun() -> send_reward_mail(SubType, ChallengeStatus) end),
                db:execute(io_lib:format(?DELETE_CONTRACT_ACT_INFO, [SubType])),
                db:execute(?TRUNCATE_ROLE_CONTRACT_BUFF),
                db:execute(io_lib:format(?DELETE_CONTRACT_ACT_TASK_ITEM, [SubType])),
                maps:remove(SubType, State)
        end,
    {noreply, NewState};

do_handle_cast({'send_act_info', RoleId, SubType}, State) ->
    case maps:get(SubType, State, false) of
        false -> {noreply, State};
        ChallengeStatus ->
            NewChallengeStatus = lib_contract_challenge_mod:send_act_info(RoleId, SubType, ChallengeStatus),
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;

do_handle_cast({'send_reward_status', RoleId, SubType}, State) ->
    case maps:get(SubType, State, false) of
        false -> {noreply, State};
        ChallengeStatus ->
            NewChallengeStatus = lib_contract_challenge_mod:send_reward_status(RoleId, SubType, ChallengeStatus),
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;

do_handle_cast({'get_point_reward', RoleId, SubType, ItemId}, State) ->
    case maps:get(SubType, State, false) of
        false ->
            {noreply, State};
        ChallengeStatus ->
            NewChallengeStatus = lib_contract_challenge_mod:get_point_reward(RoleId, SubType, ItemId, ChallengeStatus),
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;

do_handle_cast({'receive_reward', RoleId, SubType, Grade}, State) ->
    case maps:get(SubType, State, false) of
        false -> {noreply, State};
        ChallengeStatus ->
            NewChallengeStatus = lib_contract_challenge_mod:receive_reward(RoleId, SubType, Grade,  ChallengeStatus),
            NewState = maps:put(SubType, NewChallengeStatus, State),
            {noreply, NewState}
    end;

do_handle_cast({'task_process', RoleId, Module, SubModule, Count}, State) ->
    NewState = lib_contract_challenge_mod:task_process(RoleId, Module, SubModule, Count, State),
    {noreply, NewState};

do_handle_cast({'cancel_lenged_contract', SubType, RoleId}, State) ->
    case maps:get(SubType, State, false) of
        false -> {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            case maps:get(RoleId, RoleMap, false) of
                false -> {noreply, State};
                NewRoleChallengeTmp ->
                    NewRoleChallenge =
                        case NewRoleChallengeTmp#role_challenge.is_legend of
                            ?IS_LEGEND ->
                                NewRoleChallengeTmp1 = NewRoleChallengeTmp#role_challenge{is_legend = ?NOT_LEGEND},
                                {ok, BinData} = pt_332:write(33235, [?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, ?IS_LEGEND]),
                                lib_server_send:send_to_uid(RoleId, BinData),
                                {NewRoleChallenge1, _} = lib_contract_challenge_util:flush_reward_status(SubType, NewRoleChallengeTmp1),
                                lib_contract_challenge_mod:send_reward_list_core(RoleId, SubType, NewRoleChallenge1),
                                lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallenge1),
                                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_contract_challenge, cancel_legend_attr, [SubType]),
                                NewRoleChallenge1;
                            _ -> NewRoleChallengeTmp
                        end,
                    NewRoleMap = maps:put(RoleId, NewRoleChallenge, RoleMap),
                    NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
                    {noreply, maps:put(SubType, NewChallengeStatus, State)}
            end
    end;
do_handle_cast({'active_legend', RoleId, RoleName, SubType}, State) ->
    case maps:get(SubType, State, false) of
        false -> {noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap, open_day = OpenDay, etime = ETime, reward_grades = RewardGrades} = ChallengeStatus,
            NewRoleChallengeTmp = case maps:get(RoleId, RoleMap, false) of
                                      false -> lib_contract_challenge_util:init_role_challenge(SubType, OpenDay, RoleId, RewardGrades);
                                      Retrun -> Retrun
                                  end,
            NewRoleChallenge =
                case NewRoleChallengeTmp#role_challenge.is_legend of
                    ?NOT_LEGEND ->
                        NewRoleChallengeTmp1 = NewRoleChallengeTmp#role_challenge{is_legend = ?IS_LEGEND},
                        {ok, BinData} = pt_332:write(33235, [?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, ?IS_LEGEND]),
                        lib_server_send:send_to_uid(RoleId, BinData),
                        lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 55, [RoleName, RoleId, ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType]),
                        %% 推送奖励状态
                        {NewRoleChallenge1, _} = lib_contract_challenge_util:flush_reward_status(SubType, NewRoleChallengeTmp1),
                        lib_contract_challenge_mod:send_reward_list_core(RoleId, SubType, NewRoleChallenge1),
                        lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallenge1),
                        %% 激活属性Buff保存传说契约到期时间
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_contract_challenge, add_legend_attr, [SubType, ETime]),
                        NewRoleChallenge1;
                    ?IS_LEGEND -> NewRoleChallengeTmp
                end,
            NewRoleMap = maps:put(RoleId, NewRoleChallenge, RoleMap),
            NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
            {noreply, maps:put(SubType, NewChallengeStatus, State)}
    end;

do_handle_cast({'gm_complete_task', RoleId, TaskId}, State) ->
    F = fun(SubType, ChallengeStatus) ->
        #challenge_status{role_map = RoleMap} = ChallengeStatus,
        case maps:get(RoleId, RoleMap, false) of
            false -> {noreply, State};
            NewRoleChallengeTmp ->
                #role_challenge{challenge_list = ChallengeList} = NewRoleChallengeTmp,
                ?PRINT("ChallengeList ~p ~n", [ChallengeList]),
                TaskList = lists:filter(fun(Item) -> Item#challenge_item.task_id == TaskId end, ChallengeList),
                Now = utime:unixtime(),
                F2 = fun(TaskItem, OldList) ->
                    case TaskItem#challenge_item.is_get of
                        0 ->
                            #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TaskId),
                            NewTaskItem = TaskItem#challenge_item{grand_num = NeedNum, is_get = ?CAN_GET, utime = Now},
                            lib_contract_challenge_util:save_act_task_item(SubType, RoleId, NewTaskItem),
                            lists:keystore(NewTaskItem#challenge_item.item_id, #challenge_item.item_id, OldList, NewTaskItem);
                        _ -> OldList
                    end
                    end,
                NewChallengeList = lists:foldl(F2, ChallengeList, TaskList),
                lib_contract_challenge_util:push_challenge_status(SubType, RoleId, NewChallengeList),
                ?PRINT("NewChallengeList ~p ~n", [NewChallengeList]),
                NewRoleChallenge = NewRoleChallengeTmp#role_challenge{challenge_list = NewChallengeList},
                NewRoleMap = maps:put(RoleId, NewRoleChallenge, RoleMap),
                ChallengeStatus#challenge_status{role_map = NewRoleMap}
        end
        end,
    NewState = maps:map(F, State),
    {noreply, NewState};

do_handle_cast({'gm_add_point', SubType, RoleId, AddPoint}, State) ->
    case maps:get(SubType, State, false) of
        false ->{noreply, State};
        ChallengeStatus ->
            #challenge_status{role_map = RoleMap} = ChallengeStatus,
            case maps:get(RoleId, RoleMap, false) of
                false ->{noreply, State};
                NewRoleChallengeTmp ->
                    #role_challenge{sum_point = OldPoint} = NewRoleChallengeTmp,
                    {NewRoleChallenge, _} = lib_contract_challenge_util:flush_reward_status(SubType, NewRoleChallengeTmp#role_challenge{sum_point = OldPoint + AddPoint}),
                    send_act_info(RoleId, SubType),
                    lib_contract_challenge_mod:send_reward_list_core(RoleId, SubType, NewRoleChallenge),
                    lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallenge),
                    NewChallengeStatus = ChallengeStatus#challenge_status{role_map = maps:put(RoleId, NewRoleChallenge, RoleMap)},
                    {noreply, maps:put(SubType, NewChallengeStatus, State)}
            end
    end;

do_handle_cast({'gm_flush_daily', RoleId}, State) ->
    F = fun(SubType, ChallengeStatus) ->
        #challenge_status{role_map = RoleMap, open_day = OpenDay} = ChallengeStatus,
        case maps:get(RoleId, RoleMap, false) of
            false -> ChallengeStatus;
            OldRoleChallenge ->
                #role_challenge{challenge_list = ChallengeList} = OldRoleChallenge,
                ?PRINT("ChallengeList ~p ~n", [ChallengeList]),
                DaliyItems = lib_contract_challenge_util:init_daily_challenge_list(SubType, OpenDay, RoleId),
                F2 = fun(DaliyItem, ChallList) ->
                    lists:keystore(DaliyItem#challenge_item.item_id, #challenge_item.item_id, ChallList, DaliyItem)
                    end,
                NewChallengeList = lists:foldl(F2, ChallengeList, DaliyItems),
                ?PRINT("NewChallengeList ~p ~n", [NewChallengeList]),
                NewRoleChallenge = OldRoleChallenge #role_challenge{challenge_list = NewChallengeList},
                NewRoleMap = maps:put(RoleId, NewRoleChallenge, RoleMap),
                NewChallengeStatus = ChallengeStatus#challenge_status{role_map = NewRoleMap},
                lib_contract_challenge_mod:send_act_info(RoleId, SubType, NewChallengeStatus),
                NewChallengeStatus
        end
        end,
    NewState = maps:map(F, State),
    {noreply, NewState};


do_handle_cast(_Msg, State) -> {noreply, State}.

do_handle_info(_Msg, State) -> {noreply, State}.

%%=====================================================================
%%  Internal functions
%%=====================================================================
%% 初始化数据
init_data() ->
    SubTypeList = lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE),
    F = fun(#act_info{key = {_,SubType}}, ActMap) ->
        ChallengeStatus = init_sub_data(SubType),
        maps:put(SubType, ChallengeStatus, ActMap)
        end,
    lists:foldl(F, #{}, SubTypeList).

init_sub_data(SubType) ->
    List = db:get_all(io_lib:format(?SELECT_CONTRACT_ACT_INFO, [SubType])),
    RoleMap =
        case List of
            [] ->
                #{};
            _ ->
                lists:foldl(fun init_role_challenge/2, #{}, List)
        end,
    {OpenDay, FlushTime} = get_open_day_and_flush_time(SubType),
    #act_info{stime = STime, etime = ETime} = lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType),
    RewardGrades = init_reward_grades(SubType),
    #challenge_status{
        sub_type = SubType,
        role_map = RoleMap,
        open_day = OpenDay,
        flush_time = FlushTime,
        stime = STime,
        etime = ETime,
        reward_grades = RewardGrades
    }.

init_role_challenge([SubType, RoleId, SumPoint, IsLegend, RewardStatus, DailyRecharge, DailyCost], RoleMap) ->
    RoleChallengeList = init_challenge_list(SubType, RoleId),
    RoleChallenge = #role_challenge{
        sum_point = SumPoint,
        is_legend = IsLegend,
        challenge_list = lists:reverse(RoleChallengeList),
        reward_status = util:bitstring_to_term(RewardStatus),
        daily_recharge = DailyRecharge,
        daily_cost = DailyCost
    },
    maps:put(RoleId, RoleChallenge, RoleMap).

init_challenge_list(SubType, RoleId) ->
    List = db:get_all(io_lib:format(?SELECT_CONTRACT_ACT_TASK_ITEM, [SubType, RoleId])),
%%    ?MYLOG("zh", "List ~p ~n", [List]),
    lists:foldl(fun(Item, ResList)->
        [make_challenge_item_record(Item, SubType)|ResList]
        end,[], List).

make_challenge_item_record([ItemId, TaskId, GrandNum, IsGet, Utime], SubType) ->
    case data_contract_challenge:get_cfg(SubType, TaskId) of
        #base_contract_challenge{module = Module, sub_module = SubModule, challenge_type = ChallengeType} ->
            #challenge_item{
                item_id = ItemId,
                task_id = TaskId,
                grand_num = GrandNum,
                challenge_type = ChallengeType,
                module = Module,
                sub_module = SubModule,
                is_get = IsGet,
                utime = Utime
            };
        _ ->
            #challenge_item{}
    end.

get_open_day_and_flush_time(SubType) ->
    #act_info{stime = STime} = lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType),
    OpenDay = utime:logic_diff_days(STime - 3600 * 4) + 1,

    Now = utime:unixtime(),
    ZeroTime = utime:unixdate(Now), %% 今天凌晨
    FourClock = ZeroTime + 4*3600, %% 今天4点
    TomorrowDayFourClock = FourClock + ?ONE_DAY_SECONDS,  %% 明天4点
    FlushTime = ?IF(Now > FourClock, TomorrowDayFourClock, FourClock),
    {OpenDay, FlushTime}.

%% 初始化活动奖励等级
init_reward_grades(SubType) ->
    GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType),
    WorldLv = util:get_world_lv(),
    F = fun(Grade) ->
        #custom_act_reward_cfg{
            condition = Condition
        } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
        {world_lv, MinLv, MaxLv} = lists:keyfind(world_lv, 1, Condition),
        WorldLv >= MinLv andalso WorldLv < MaxLv
        end,
    lists:filter(F, GradeList).

send_reward_mail(SubType, ChallengeStatus) ->
    #challenge_status{role_map = RoleMap} = ChallengeStatus,
    F = fun(RoleId, RoleChallenge) ->
        #role_challenge{
            sum_point = SumPoint,
            challenge_list = ChallengeList,
            reward_status = RewardStatus,
            is_legend = IsLegend
        } = RoleChallenge,
        AddPoint = lib_contract_challenge_util:cal_not_get_point(SubType, ChallengeList),
        NewRewardStatus = lib_contract_challenge_util:flush_reward_status(SubType, SumPoint + AddPoint, IsLegend, RewardStatus),
        SendList = lists:filter(fun({_, IsGet}) -> IsGet == ?CAN_GET end, NewRewardStatus),
        [begin
             #custom_act_reward_cfg{
                 reward = Reward
             } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
             timer:sleep(20), %% 慢慢发
             lib_mail_api:send_sys_mail([RoleId], utext:get(3310016), utext:get(3310017), Reward)
         end||{Grade, _} <- SendList]
        end,
    maps:map(F, RoleMap).

fix_rechage_cost(RoleId, SubType, RoleChallenge) ->
    #role_challenge{challenge_list = ChallengeList} = RoleChallenge,
    NeedChallengeList = lists:filter(fun(#challenge_item{module = Module}) -> Module == ?MOD_RECHARGE end, ChallengeList),
    ZeroTime = utime:unixdate(),
    Sql = io_lib:format(<<"select `gold` from `recharge_log` where `player_id` = ~p and `time` between ~p and ~p">>, [RoleId, ZeroTime, ZeroTime + 3600 * 24]),
    RList = db:get_all(Sql),
    NewRecharge = lists:sum([Gold||[Gold]<-RList]),

    ?PRINT("NewRecharge ~p ~n", [NewRecharge]),

    {ODay, _} = get_open_day_and_flush_time(SubType),
    F = fun(Item) ->
        #challenge_item{task_id = TaskId} = Item,
        #base_contract_challenge{open_day = OpenDay} = data_contract_challenge:get_cfg(SubType, TaskId),
        OpenDay == ODay
        end,
    RechargeList =
        case lists:filter(F, lists:reverse(NeedChallengeList)) of
            [#challenge_item{is_get = IsGet, task_id = TaskId}|_] ->
                case IsGet of
                    ?NO_GET ->
                        #base_contract_challenge{special_value = SpecialV} = data_contract_challenge:get_cfg(SubType, TaskId),
                        if
                            NewRecharge >= SpecialV ->
                                [begin
                                     #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TId),
                                     NewNum = GrandNum + 1,
                                     if
                                         IGt == ?NO_GET ->
                                             Res = NItem#challenge_item{grand_num = NewNum, is_get = ?IF(NeedNum =< NewNum, ?CAN_GET, ?NO_GET)},
                                             lib_contract_challenge_util:save_act_task_item(SubType, RoleId, Res),
                                             Res;
                                         true -> NItem
                                     end
                                 end||#challenge_item{grand_num = GrandNum, task_id = TId, is_get = IGt} = NItem <- NeedChallengeList];
                            true -> NeedChallengeList
                        end;
                    _ -> NeedChallengeList
                end;
            _ -> NeedChallengeList
        end,

    NeedChallengeList2 = lists:filter(fun(#challenge_item{module = Module}) -> Module == ?COST_MODULE end, ChallengeList),
    Sql2 = io_lib:format(<<"select `cost_gold` from `log_consume_gold` where `player_id` = ~p and `time` between ~p and ~p">>, [RoleId, ZeroTime, ZeroTime + 3600 * 24]),
    CList = db:get_all(Sql2),
    NewCost = lists:sum([Cost||[Cost]<-CList]),
    CostList =
        case lists:filter(F, NeedChallengeList2) of
            [#challenge_item{is_get = IsGet2, task_id = TaskId2}|_] ->
                case IsGet2 of
                    ?NO_GET ->
                        #base_contract_challenge{special_value = SpecialV2} = data_contract_challenge:get_cfg(SubType, TaskId2),
                        if
                            NewCost >= SpecialV2 ->
                                [begin
                                     #base_contract_challenge{grand_num = NeedNum2} = data_contract_challenge:get_cfg(SubType, TId2),
                                     NewNum2 = GrandNum2 + 1,
                                     if
                                         IGt2 == ?NO_GET ->
                                             Res2 = NItem2#challenge_item{grand_num = NewNum2, is_get = ?IF(NeedNum2 =< NewNum2, ?CAN_GET, ?NO_GET)},
                                             lib_contract_challenge_util:save_act_task_item(SubType, RoleId, Res2),
                                             Res2;
                                         true -> NItem2
                                     end
                                 end||#challenge_item{grand_num = GrandNum2, task_id = TId2, is_get = IGt2} = NItem2 <- NeedChallengeList2];
                            true -> NeedChallengeList2
                        end;
                    _ ->  NeedChallengeList2
                end;
            _ ->NeedChallengeList2
        end,

    F3 = fun(#challenge_item{item_id = ItemId} = Itemm, ResList) ->
        lists:keystore(ItemId, #challenge_item.item_id, ResList, Itemm)
        end,
    Temp1 = lists:foldl(F3, ChallengeList, RechargeList),
    Temp2 = lists:foldl(F3, Temp1, CostList),
    RoleChallenge#role_challenge{challenge_list = Temp2}.