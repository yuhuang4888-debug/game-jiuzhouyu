%%-----------------------------------------------------------------------------
%% @Module  :       lib_pray
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-20
%% @Description:    祈愿
%%-----------------------------------------------------------------------------
-module(lib_pray).

-include("pray.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-export([
    login/1
    , send_pray_info/4
    , pray/2
]).

login(RoleId) ->
    List = db:get_all(io_lib:format(?sql_select_player_pray, [RoleId])),
    PrayMap = init_pray_map(List, #{}),
    #status_pray{pray_map = PrayMap}.

init_pray_map([], Map) -> Map;
init_pray_map([[Type, Times, FreeTime, EndTime] | L], Map) ->
    NewMap = maps:put(Type, {Times, FreeTime, EndTime}, Map),
    init_pray_map(L, NewMap).

%% 发送祈愿界面
send_pray_info(RoleId, VipType, VipLv, StaPray) ->
    CounterList = mod_daily:get_count(RoleId, ?MOD_PRAY, ?PRAY_TYPES),
    NowTime = utime:unixtime(),
    F = fun(Type, TmpPray) ->
        TotalTimes = lib_vip_api:get_vip_privilege(?MOD_PRAY, Type, VipType, VipLv) + get_base_times(Type),    % 基础次数
        FreeTimes = get_free_times(Type),      % 免费次数
%%      已用次数
        UseTimes = case lists:keyfind(Type, 1, CounterList) of
                       {Type, TmpTimes} -> TmpTimes;
                       _ -> 0
                   end,
        % 剩余次数
        RemainTimes = max(0, TotalTimes - UseTimes),
        %% 优先消耗免费次数
        {Times, FreeTime, EndTime} = maps:get(Type, TmpPray, {0, 0, 0}),
        {RemainFreeTimes, NewEndTime, NewStaPray} =
        case {Times, FreeTime, EndTime} == {0, 0, 0} of
            true ->
                ETime = 0,
                NStaPray = maps:put(Type, {0, FreeTimes, ETime}, TmpPray),
                %%                    重新修改时间和次数时
                db:execute(io_lib:format(?sql_update_player_pray, [RoleId, Type, 0, FreeTimes, ETime])),
                {FreeTimes, ETime, NStaPray};
            false ->
                case NowTime >= EndTime andalso EndTime =/= 0 of
                    true ->   % 当过期的时候
                        ETime = 0,
                        NStaPray = maps:put(Type, {Times, FreeTimes, ETime}, TmpPray),
                        %%                    重新修改时间和次数时
                        db:execute(io_lib:format(?sql_update_player_pray, [RoleId, Type, Times, FreeTimes, ETime])),
                        {FreeTimes, ETime, NStaPray};
                    false ->
                        {FreeTime, EndTime, TmpPray}
                end
        end,
        {{Type, RemainTimes, RemainFreeTimes, NewEndTime}, NewStaPray}
        end,
    {List, FinStaPray} = lists:mapfoldl(F, StaPray, ?PRAY_TYPES),
%%    ?PRINT("mapfoldl {List} :~w~n", [{List}]),
    {ok, BinData} = pt_415:write(41501, [List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    FinStaPray.

pray(PlayerStatus, Type) ->
    #player_status{id = RoleId, figure = Figure, status_pray = StatusPray} = PlayerStatus,
    StaPray = StatusPray#status_pray.pray_map,
    #figure{vip = VipLv, vip_type = VipType, lv = RoleLv} = Figure,
    case lists:member(Type, ?PRAY_TYPES) of
        true ->
            UseTimes = mod_daily:get_count(RoleId, ?MOD_PRAY, Type),
            ?PRINT("41502 UseTimes:~p~n", [UseTimes]),
            TotalTimes = lib_vip_api:get_vip_privilege(?MOD_PRAY, Type, VipType, VipLv) + get_base_times(Type),    % 基础次数
            FreeTimes = get_free_times(Type),      % 免费次数
            RemainTimes = max(0, TotalTimes - UseTimes),
            ?PRINT("41502 RemainTimes:~p~n", [RemainTimes]),
            %% 优先消耗免费次数
            NowTime = utime:unixtime(),
            {Times, FreeTime, EndTime} = maps:get(Type, StaPray, {0, 0, 0}),
            {RemainFreeTimes, NewStaPray} =
                case NowTime >= EndTime andalso EndTime =/= 0  of
                    true ->   % 当过期的时候
                        ETime = 0,
                        NStaPray = maps:put(Type, {Times, FreeTimes, ETime}, StaPray),
                        db:execute(io_lib:format(?sql_update_player_pray, [RoleId, Type, Times, FreeTimes, ETime])),
                        {FreeTimes, NStaPray};
                    false ->
                        {FreeTime, StaPray}
                end,
            NewStatusPray = StatusPray#status_pray{pray_map = NewStaPray},
            StrongPs = lib_to_be_strong:update_data_pray(PlayerStatus, RemainTimes - 1),
            NewPS = StrongPs#player_status{status_pray = NewStatusPray},
            case data_pray:get_reward(Type, RoleLv) of
                [{_, _, _}] ->
                    if
                        RemainTimes == 0 andalso RemainFreeTimes == 0 ->   %% 没有剩余次数和免费次数
                            send_error_code(RoleId, ?ERRCODE(err415_no_enough_times));
                        RemainFreeTimes > 0 -> %% 使用免费次数直接祈愿
                            {ok, CritMul, RewardList, LastPlayerStatus1} = do_pray(NewPS, Type, UseTimes, free),
                            %% 祈愿日志
                            lib_log_api:log_pray(RoleId, RoleLv, Type, UseTimes + 1, 1, CritMul, [], RewardList),
                            % 事件触发
                            CallbackData = #callback_join_act{type = ?MOD_PRAY, subtype = Type},
                            {ok, LastPlayerStatus} = lib_player_event:dispatch(LastPlayerStatus1, ?EVENT_JOIN_ACT, CallbackData),
                            case  Type   of
                                ?PRAY_TYPE_EXP ->
                                    lib_achievement_api:async_event(RoleId, lib_achievement_api, exp_pray_event, []),
                                    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_PRAY, 0);
                                _ ->
                                    lib_achievement_api:async_event(RoleId, lib_achievement_api, coin_pray_event, []),
                                    skip
                            end,
                            {ok, LastPlayerStatus};
                        true ->
                            Cost = data_pray:get_cost(Type, UseTimes + 1),
                            case lib_goods_api:cost_object_list_with_check(NewPS, Cost, pray, Type) of
                                {true, NewPlayerStatus} ->
                                    {ok, CritMul, RewardList, LastPlayerStatus1} = do_pray(NewPlayerStatus, Type, UseTimes, cost),
                                    %% 祈愿日志
                                    lib_log_api:log_pray(RoleId, RoleLv, Type, UseTimes + 1, 0, CritMul, Cost, RewardList),
                                    % 事件触发
                                    CallbackData = #callback_join_act{type = ?MOD_PRAY, subtype = Type},
                                    {ok, LastPlayerStatus} = lib_player_event:dispatch(LastPlayerStatus1, ?EVENT_JOIN_ACT, CallbackData),
                                    case  Type   of
                                        ?PRAY_TYPE_EXP ->
                                            lib_achievement_api:async_event(RoleId, lib_achievement_api, exp_pray_event, []),
                                            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_PRAY, 0);
                                        _ ->
                                            lib_achievement_api:async_event(RoleId, lib_achievement_api, coin_pray_event, []),
                                            skip
                                    end,
                                    {ok, LastPlayerStatus};
                                _ ->
                                    send_error_code(RoleId, ?ERRCODE(gold_not_enough))
                            end
                    end;
                _ -> send_error_code(RoleId, ?ERRCODE(err415_not_reward_cfg))
            end;
        _ -> skip
    end.

do_pray(PlayerStatus, Type, DailyTimes, PrayType) ->
    #player_status{id = RoleId, figure = Figure, status_pray = StatusPray} = PlayerStatus,
    #status_pray{pray_map = PrayMap} = StatusPray,
    #figure{lv = RoleLv} = Figure,
    NowTime = utime:unixtime(),
    {PrayTimes, FreeTime, EndTime} = maps:get(Type, PrayMap, {0, 0, 0}),
    %%    判断是否免费
    {NewFreeTime, NewEndTime} =
        case PrayType == free of
            true ->
                NFreeTime = FreeTime - 1,
                NEndTime =  NowTime + data_pray:get_cfg(6),  % 如果没有祈愿次数,重置时间
                {NFreeTime, NEndTime};
            false ->
                %% 当天祈愿次数+1
                mod_daily:increment(RoleId, ?MOD_PRAY, Type),
                {FreeTime, EndTime}
        end,
    NewPrayTimes = PrayTimes + 1,
    [{GoodType, GoodId, Reward}] = data_pray:get_reward(Type, RoleLv),
    CritMul =
        case data_pray:get_crit(Type, DailyTimes + 1) of
            CritRatioL when is_list(CritRatioL) ->
                NewCritRatioL = refresh_ratio_with_other_module(PlayerStatus, CritRatioL),
                case urand:rand_with_weight(NewCritRatioL) of
                    CrMul when is_integer(CrMul) -> CrMul;
                    _ -> 1
                end;
            _ -> 1
        end,
    RealReward = Reward * CritMul,
    RewardList = [{GoodType, GoodId, RealReward}],
    %mod_hi_point:success_end(RoleId, ?MOD_PRAY, 0),
    %% 更新玩家的累计祈愿次数
    db:execute(io_lib:format(?sql_update_player_pray, [RoleId, Type, NewPrayTimes, NewFreeTime, NewEndTime])),
    lib_goods_api:send_reward_by_id(RewardList, pray, RoleId),
    {ok, BinData} = pt_415:write(41502, [Type, CritMul, RealReward]),
    lib_server_send:send_to_uid(RoleId, BinData),
    lib_hi_point_api:hi_point_task_pray(RoleId, Figure#figure.lv),
    NewPrayMap = maps:put(Type, {NewPrayTimes, NewFreeTime, NewEndTime}, PrayMap),
    NewStatusPray = StatusPray#status_pray{pray_map = NewPrayMap},
    {ok, CritMul, RewardList, PlayerStatus#player_status{status_pray = NewStatusPray}}.

get_free_times(?PRAY_TYPE_GCOIN) ->
    data_pray:get_cfg(1);
get_free_times(?PRAY_TYPE_EXP) ->
    data_pray:get_cfg(2);
get_free_times(_) -> 0.

get_base_times(?PRAY_TYPE_GCOIN) ->
    data_pray:get_cfg(3);
get_base_times(?PRAY_TYPE_EXP) ->
    data_pray:get_cfg(4);
get_base_times(_) -> 0.

%% 发送错误码
send_error_code(RoleId, ErrorCode) ->
    {ok, BinData} = pt_415:write(41500, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

refresh_ratio_with_other_module(PlayerStatus, CritRatioL) ->
    %% 生活技能加成: 必定暴击，删掉1倍权重，将2倍权重提高
    NewCritRatioL = case lib_module_buff:get_pray_crit_ratio(PlayerStatus) of
        0 -> CritRatioL;
        AddPersent ->
            case lists:keysort(2, CritRatioL) of
                [{WeightOne, 1}, {WeightTwo, Two}|L] ->
                    [{round(WeightTwo + WeightOne*AddPersent), Two}|L];
                _ ->
                    CritRatioL
            end
    end,
    NewCritRatioL.
