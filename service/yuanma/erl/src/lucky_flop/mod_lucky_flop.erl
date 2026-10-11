%%-----------------------------------------------------------------------------
%% @Module  :       mod_lucky_flop
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-05-26
%% @Description:    幸运翻牌
%%-----------------------------------------------------------------------------
-module(mod_lucky_flop).

-include("custom_act.hrl").
-include("lucky_flop.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    send_act_info/4
    , refresh/4
    , flop/6
    , set_open_status/3
    , act_end/2
    ]).

-export([
    check_refresh/4
    , check_flop/5
    ]).

-export([
    reload/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    List = db:get_all(?sql_select_lucky_flop),
    F = fun
        ([SubType, RoleId, OpenStatus, ObtainRewardsStr, AllRewardsStr, UseTimes, TotalUseTimes, RefreshTimes, FreeTimes, Time], TmpMap) ->
            RoleInfo = #role_info{
                role_id = RoleId,
                open_status = OpenStatus,
                obtain_rewards = util:bitstring_to_term(ObtainRewardsStr),
                all_rewards = util:bitstring_to_term(AllRewardsStr),
                use_times = UseTimes,
                total_use_times = TotalUseTimes,
                refresh_times = RefreshTimes,
                free_times = FreeTimes,
                time = Time
            },
            RoleMap = maps:get(SubType, TmpMap, #{}),
            NewRoleMap = maps:put(RoleId, RoleInfo, RoleMap),
            maps:put(SubType, NewRoleMap, TmpMap);
        (_, TmpMap) -> TmpMap
    end,
    ActDataMap = lists:foldl(F, #{}, List),
    State = #act_state{data_map = ActDataMap},
    {ok, State}.

send_act_info(Type, SubType, RoleId, RoleLv) ->
    gen_server:cast(?MODULE, {'send_act_info', Type, SubType, RoleId, RoleLv}).

refresh(Type, SubType, RoleId, Cost) ->
    gen_server:cast(?MODULE, {'refresh', Type, SubType, RoleId, Cost}).

flop(Type, SubType, RoleId, RoleName, Pos, Cost) ->
    gen_server:cast(?MODULE, {'flop', Type, SubType, RoleId, RoleName, Pos, Cost}).

set_open_status(Type, SubType, RoleId) ->
    gen_server:cast(?MODULE, {'set_open_status', Type, SubType, RoleId}).

act_end(Type, SubType) ->
    gen_server:cast(?MODULE, {'act_end', Type, SubType}).

reload() ->
    gen_server:cast(?MODULE, {'reload'}).

%% 刷新检查
check_refresh(Type, SubType, RoleId, RoleLv) ->
    gen_server:call(?MODULE, {'check_refresh', Type, SubType, RoleId, RoleLv}, 1000).

%% 翻牌检查
check_flop(Type, SubType, RoleId, RoleLv, Pos) ->
    gen_server:call(?MODULE, {'check_flop', Type, SubType, RoleId, RoleLv, Pos}, 1000).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state)->
            {noreply, NewState};
        Err ->
            util:errlog("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 获取活动界面信息
do_handle_cast({'send_act_info', Type, SubType, RoleId, RoleLv}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, ActInfo, _OpenLv, _TimesLim, _RefreshCostGTypeId, _RefreshCost, _FlopCostGTypeId, _FlopCost} ->
            #act_info{wlv = WorldLv} = ActInfo,
            #act_state{data_map = DataMap, record_map = RecordMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    time = Utime
                } = RoleInfo ->
                    case utime:is_same_day(NowTime, Utime) of
                        true ->
                            RealRoleInfo = RoleInfo,
                            NewDataMap = DataMap;
                        _ ->
                            RealRoleInfo = make_role_info(Type, SubType, RoleId, WorldLv, NowTime),
                            NewRoleMap = maps:put(RoleId, RealRoleInfo, RoleMap),
                            NewDataMap = maps:put(SubType, NewRoleMap, DataMap)
                    end;
                _ ->
                    RealRoleInfo = make_role_info(Type, SubType, RoleId, WorldLv, NowTime),
                    NewRoleMap = maps:put(RoleId, RealRoleInfo, RoleMap),
                    NewDataMap = maps:put(SubType, NewRoleMap, DataMap)
            end,
            #role_info{
                open_status = OpenStatus,
                obtain_rewards = ObtainRewardsL,
                all_rewards = AllRewardsL,
                use_times = UseTimes,
                total_use_times = TotalUseTimes,
                refresh_times = RefreshTimes,
                free_times = FreeTimes
            } = RealRoleInfo,
            IsFreeRefresh = ?IF(FreeTimes > 0, 1, 0),
            RecordL = maps:get(SubType, RecordMap, []),
            PackRewardL = pack_reward_list(AllRewardsL, ObtainRewardsL, Type, SubType, []),
            PackRecordL = pack_record_list(RecordL, []),
            {ok, BinData} = pt_331:write(33180, [Type, SubType, OpenStatus, UseTimes, TotalUseTimes, IsFreeRefresh, RefreshTimes, PackRewardL, PackRecordL]),
            lib_server_send:send_to_uid(RoleId, BinData),

            NewState = State#act_state{data_map = NewDataMap};
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]),
            NewState = State;
        _ ->
            NewState = State
    end,
    {ok, NewState};

%% 展开牌组
do_handle_cast({'set_open_status', Type, SubType, RoleId}, State) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} when NowTime < Etime ->
            #act_state{data_map = DataMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    open_status = OpenStatus
                } = RoleInfo->
                    case OpenStatus == 0 of
                        true ->
                            NewOpenStatus = 1,
                            db:execute(io_lib:format(?sql_update_open_status, [NewOpenStatus, SubType, RoleId])),
                            NewRoleInfo = RoleInfo#role_info{open_status = NewOpenStatus},
                            NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                            NewDataMap = maps:put(SubType, NewRoleMap, DataMap),
                            lib_server_send:send_to_uid(RoleId, pt_331, 33183, [?SUCCESS, Type, SubType]),
                            NewState = State#act_state{data_map = NewDataMap};
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?FAIL]),
                            NewState = State
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?FAIL]),
                    NewState = State
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_act_closed)]),
            NewState = State
    end,
    {ok, NewState};

%% 刷新奖励
do_handle_cast({'refresh', Type, SubType, RoleId, Cost}, State) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = WorldLv, etime = Etime} when NowTime < Etime ->
            #act_state{data_map = DataMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    refresh_times = OldRefreshTimes,
                    free_times = OldFreeTimes,
                    time = Utime
                } = RoleInfo -> %% 同一天的数据直接刷新奖励
                    case utime:is_same_day(NowTime, Utime) of
                        true ->
                            NewRewardL = count_reward_list(Type, SubType, WorldLv),
                            case OldFreeTimes > 0 of
                                true ->
                                    IsFree = 1,
                                    NewRefreshTimes = OldRefreshTimes,
                                    NewFreeTimes = OldFreeTimes - 1;
                                _ ->
                                    IsFree = 0,
                                    NewRefreshTimes = OldRefreshTimes + 1,
                                    NewFreeTimes = OldFreeTimes
                            end,
                            NewRoleInfo = RoleInfo#role_info{open_status = 0, use_times = 0, refresh_times = NewRefreshTimes, free_times = NewFreeTimes, obtain_rewards = [], all_rewards = NewRewardL};
                        _ ->
                            IsFree = 0,
                            RoleInfo = make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime),
                            NewRoleInfo = RoleInfo#role_info{open_status = 0, refresh_times = 1}
                    end;
                _ -> %% 不在同一天的直接初始化
                    IsFree = 0,
                    RoleInfo = make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime),
                    NewRoleInfo = RoleInfo#role_info{open_status = 0, refresh_times = 1}
            end,
            NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
            NewDataMap = maps:put(SubType, NewRoleMap, DataMap),

            log_lucky_flop_refresh(Type, SubType, NewRoleInfo, IsFree, Cost, NowTime),

            save_role_info(SubType, NewRoleInfo),

            {ok, BinData} = pt_331:write(33181, [?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData),

            NewState = State#act_state{data_map = NewDataMap};
        _ ->
            ?ERR("lucky flop refresh err cuz act close", []),
            NewState = State
    end,
    {ok, NewState};

%% 翻牌
do_handle_cast({'flop', Type, SubType, RoleId, RoleName, Pos, Cost}, State) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = WorldLv, etime = Etime} when NowTime < Etime ->
            #act_state{data_map = DataMap, record_map = RecordMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    time = Utime
                } = RoleInfo ->
                    case utime:is_same_day(NowTime, Utime) of
                        true ->
                            RealRoleInfo = RoleInfo;
                        _ ->
                            RealRoleInfo = make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime)
                    end;
                _ ->
                    RealRoleInfo = make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime)
            end,

            #role_info{
                use_times = UseTimes,
                total_use_times = TotalUseTimes,
                free_times = FreeTimes,
                obtain_rewards = ObtainL
            } = RealRoleInfo,

            case count_flop_reward(RealRoleInfo, Type, SubType) of
                #custom_act_reward_cfg{
                    grade = RewardId,
                    reward = [{_ObjectType, GTypeId, GoodsNum}] = Reward,
                    condition = Condition
                } ->
                    NewUseTimes = UseTimes + 1,
                    NewTotalUseTimes = TotalUseTimes + 1,
                    NewFreeTimes = ?IF(NewUseTimes >= ?REWARD_NUM, FreeTimes + 1, FreeTimes),
                    NewRoleInfo = RealRoleInfo#role_info{open_status = 1, use_times = NewUseTimes, total_use_times = NewTotalUseTimes, free_times = NewFreeTimes, obtain_rewards = [{Pos, RewardId}|ObtainL], time = NowTime},

                    NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                    NewDataMap = maps:put(SubType, NewRoleMap, DataMap),

                    save_role_info(SubType, NewRoleInfo),

                    lib_log_api:log_lucky_flop_reward(RoleId, NewUseTimes, Cost, Reward, NowTime),

                    case lists:keyfind(is_tv, 1, Condition) of
                        {is_tv, 1} ->
                            RecordL = maps:get(SubType, RecordMap, []),
                            NewRecordL = lists:sublist([#record_info{role_name = RoleName, goods_id = GTypeId, num = GoodsNum, time = NowTime}|RecordL], ?RECORD_LEN),

                            PackRecordL = pack_record_list(NewRecordL, []),
                            {ok, BinData} = pt_331:write(33184, [Type, SubType, PackRecordL]),
                            lib_server_send:send_to_uid(RoleId, BinData),

                            NewRecordMap = maps:put(SubType, NewRecordL, RecordMap),
                            ActName = lib_custom_act_api:get_act_name(Type, SubType),
                            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 20, [RoleName, ActName, GTypeId, GoodsNum]);
                        _ -> NewRecordMap = RecordMap
                    end,

                    {ok, BinData1} = pt_331:write(33182, [?SUCCESS, Pos, GTypeId, GoodsNum, NewUseTimes, NewTotalUseTimes]),
                    lib_server_send:send_to_uid(RoleId, BinData1),

                    Produce = lib_goods_api:make_produce(lucky_flop, SubType, utext:get(3310030), utext:get(3310031), Reward, 1),
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),

                    NewState = State#act_state{data_map = NewDataMap, record_map = NewRecordMap};
                _ ->
                    ?ERR("role:~p count flop reward err", [RoleId]),
                    NewState = State
            end;
        _ ->
            ?ERR("lucky flop flop err cuz act close", []),
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'act_end', _Type, SubType}, State) ->
    #act_state{data_map = DataMap, record_map = RecordMap} = State,
    db:execute(io_lib:format(?sql_clear_lucky_flop, [SubType])),
    NewDataMap = maps:remove(SubType, DataMap),
    NewRecordMap = maps:remove(SubType, RecordMap),
    NewState = State#act_state{data_map = NewDataMap, record_map = NewRecordMap},
    {ok, NewState};

do_handle_cast({'reload'}, _State) ->
    {ok, NewState} = init([]),
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state)->
            {noreply, NewState};
        Err ->
            util:errlog("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% 定时器执行操作
do_handle_info({'check'}, State) ->
    {ok, State};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            util:errlog("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

%% 刷新奖池检查
do_handle_call({'check_refresh', Type, SubType, RoleId, RoleLv}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, _ActInfo, _OpenLv, _TimesLim, RefreshCostGTypeId, RefreshCostL, _FlopCostGTypeId, _FlopCostL} ->
            #act_state{data_map = DataMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    time = Utime
                } = RoleInfo ->
                    case utime:is_same_day(NowTime, Utime) of
                        true ->
                            RealRoleInfo = RoleInfo;
                        _ ->
                            RealRoleInfo = #role_info{}
                    end;
                _ -> RealRoleInfo = #role_info{}
            end,
            #role_info{
                refresh_times = RefreshTimes,
                free_times = FreeTimes
            } = RealRoleInfo,
            case FreeTimes =< 0 of
                true ->
                    case count_refresh_cost(RefreshCostL, RefreshTimes + 1) of
                        CostNum when is_integer(CostNum) ->
                            case CostNum > 0 of
                                true ->
                                    {ok, {ok, [{?TYPE_GOODS, RefreshCostGTypeId, CostNum}]}};
                                _ ->
                                    {ok, {ok, free}}
                            end;
                        _ -> {ok, {false, ?ERRCODE(err_config)}}
                    end;
                _ ->
                    {ok, {ok, free}}
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

%% 翻牌检查
do_handle_call({'check_flop', Type, SubType, RoleId, RoleLv, Pos}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, #act_info{wlv = _WorldLv}, _OpenLv, TimesLim, _RefreshCostGTypeId, _RefreshCostL, FlopCostGTypeId, FlopCostL} ->
            #act_state{data_map = DataMap} = State,
            RoleMap = maps:get(SubType, DataMap, #{}),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    time = Utime
                } = RoleInfo ->
                    case utime:is_same_day(NowTime, Utime) of
                        true ->
                            RealRoleInfo = RoleInfo;
                        _ ->
                            RealRoleInfo = #role_info{}
                    end;
                _ ->
                    RealRoleInfo = #role_info{}
            end,
            #role_info{
                open_status = OpenStatus,
                use_times = UseTimes,
                total_use_times = TotalUseTimes,
                obtain_rewards = ObtainL
            } = RealRoleInfo,
            case OpenStatus == 1 of
                true ->
                    case TotalUseTimes < TimesLim of
                        true ->
                            case lists:keyfind(Pos, 1, ObtainL) of
                                false ->
                                    case count_flop_cost(FlopCostL, UseTimes + 1) of
                                        CostNum when is_integer(CostNum) ->
                                            case CostNum > 0 of
                                                true ->
                                                    {ok, {ok, [{?TYPE_GOODS, FlopCostGTypeId, CostNum}]}};
                                                _ ->
                                                    {ok, {ok, free}}
                                            end;
                                        _ ->
                                            ?ERR("FlopCostL:~p", [FlopCostL]),
                                            {ok, {false, ?ERRCODE(err_config)}}
                                    end;
                                _ ->
                                    {ok, {false, ?ERRCODE(err331_flop_reward_has_obtain)}}
                            end;
                        _ -> {ok, {false, ?ERRCODE(err331_flop_times_lim)}}
                    end;
                _ -> {ok, {false, ?ERRCODE(err331_pls_open_first)}}
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

check_act(Type, SubType, RoleLv, NowTime) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{
                    condition = Condition
                } ->
                    case lib_custom_act_check:check_act_condtion([role_lv, times_lim, refresh_gid, refresh_cost, flop_gid, flop_cost], Condition) of
                        [OpenLv, TimesLim, RefreshCostGTypeId, RefreshCost, FlopCostGTypeId, FlopCost] when RoleLv >= OpenLv ->
                            {true, ActInfo, OpenLv, TimesLim, RefreshCostGTypeId, RefreshCost, FlopCostGTypeId, FlopCost};
                        [_OpenLv|_] -> {false, ?ERRCODE(lv_limit)};
                        _ ->
                            ?ERR("Condition:~p", [Condition]),
                            {false, ?ERRCODE(err_config)}
                    end;
                _ ->
                    ?ERR(">>>>>>>>>>>>>>>", []),
                    {false, ?ERRCODE(err_config)}
            end;
        _ -> {false, ?ERRCODE(err331_act_closed)}
    end.

make_role_info(Type, SubType, RoleId, WorldLv, NowTime) ->
    RoleInfo = make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime),
    save_role_info(SubType, RoleInfo),
    RoleInfo.

make_role_info_no_db(Type, SubType, RoleId, WorldLv, NowTime) ->
    RewardL = count_reward_list(Type, SubType, WorldLv),
    #role_info{
        role_id = RoleId,
        all_rewards = RewardL,
        time = NowTime
    }.

count_reward_list(Type, SubType, _WorldLv) ->
    AllRewardIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    AllRewardL = [lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) || RewardId <- AllRewardIds],
    do_count_reward_list(AllRewardL, []).

do_count_reward_list([], Acc) ->
    urand:list_rand_by_weight(Acc, ?REWARD_NUM);
do_count_reward_list([RewardCfg|L], Acc) ->
    case RewardCfg of
        #custom_act_reward_cfg{
            grade = RewardId,
            condition = Condition
        } ->
            case lib_custom_act_check:check_act_condtion([rweight, sweight], Condition) of
                [RWeight, _SWeight] ->
                    do_count_reward_list(L, [{RWeight, RewardId}|Acc]);
                _ ->
                    do_count_reward_list(L, Acc)
            end;
        _ ->
           do_count_reward_list(L, Acc)
    end.

count_flop_reward(RoleInfo, Type, SubType) ->
    #role_info{
        obtain_rewards = ObtainL,
        all_rewards = AllRewardL
    } = RoleInfo,
    F = fun(RewardId) ->
        case lists:keyfind(RewardId, 2, ObtainL) of
            false -> true;
            _ -> false
        end
    end,
    CandinatesL = lists:filter(F, AllRewardL),
    do_count_flop_reward(CandinatesL, Type, SubType, []).

do_count_flop_reward([], _Type, _SubType, Acc) ->
    urand:rand_with_weight(Acc);
do_count_flop_reward([RewardId|L], Type, SubType, Acc) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
        #custom_act_reward_cfg{
            reward = [{_ObjectType, _GTypeId, _GoodsNum}],
            condition = Condition
        } = RewardCfg ->
            case lib_custom_act_check:check_act_condtion([sweight], Condition) of
                [SWeight] ->
                    do_count_flop_reward(L, Type, SubType, [{SWeight, RewardCfg}|Acc]);
                _ ->
                    do_count_flop_reward(L, Type, SubType, Acc)
            end;
        _ ->
           do_count_flop_reward(L, Type, SubType, Acc)
    end.

%% 计算玩家刷新需要的消耗
count_refresh_cost([], _Times) -> false;
count_refresh_cost([{[MinTimes, MaxTimes], Num}|_L], Times) when Times >= MinTimes, Times =< MaxTimes -> Num;
count_refresh_cost([_|L], Times) ->
    count_refresh_cost(L, Times).

%% 计算玩家翻牌需要的消耗
count_flop_cost([], _Times) -> false;
count_flop_cost([{[MinTimes, MaxTimes], Num}|_L], Times) when Times >= MinTimes, Times =< MaxTimes -> Num;
count_flop_cost([_|L], Times) ->
    count_flop_cost(L, Times).

pack_reward_list([], _ObtainL, _Type, _SubType, Acc) -> Acc;
pack_reward_list([RewardId|L], ObtainL, Type, SubType, Acc) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
        #custom_act_reward_cfg{
            reward = [{_ObjectType, GTypeId, GoodsNum}]
        } ->
            case lists:keyfind(RewardId, 2, ObtainL) of
                {Pos, RewardId} ->
                    pack_reward_list(L, ObtainL, Type, SubType, [{GTypeId, GoodsNum, Pos}|Acc]);
                _ ->
                    pack_reward_list(L, ObtainL, Type, SubType, [{GTypeId, GoodsNum, 0}|Acc])
            end;
        _ ->
            pack_reward_list(L, ObtainL, Type, SubType, Acc)
    end.

pack_record_list([], Acc) -> Acc;
pack_record_list([T|L], Acc) ->
    case T of
        #record_info{
            role_name = RoleName,
            goods_id = GTypeId,
            num = Num,
            time = Time
        } ->
            pack_record_list(L, [{RoleName, GTypeId, Num, Time}|Acc]);
        _ ->
            pack_record_list(L, Acc)
    end.

save_role_info(SubType, RoleInfo) ->
    #role_info{
        role_id = RoleId,
        open_status = OpenStatus,
        obtain_rewards = ObtainL,
        all_rewards = AllRewardL,
        use_times = UseTimes,
        total_use_times = TotalUseTimes,
        refresh_times = RefreshTimes,
        free_times = FreeTimes,
        time = Utime
    } = RoleInfo,
    Sql = io_lib:format(?sql_save_lucky_flop,
        [SubType, RoleId, OpenStatus, util:term_to_string(ObtainL), util:term_to_string(AllRewardL), UseTimes, TotalUseTimes, RefreshTimes, FreeTimes, Utime]),
    db:execute(Sql).

log_lucky_flop_refresh(Type, SubType, RoleInfo, IsFree, Cost, Time) ->
    #role_info{
        role_id = RoleId,
        all_rewards = AllRewardL,
        refresh_times = RefreshTimes
    } = RoleInfo,
    F = fun(RewardId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
            #custom_act_reward_cfg{
                reward = Reward
            } ->
                Reward ++ Acc;
            _ ->
                Acc
        end
    end,
    RewardL = lists:foldl(F, [], AllRewardL),
    lib_log_api:log_lucky_flop_refresh(RoleId, RefreshTimes, IsFree, Cost, RewardL, Time).
