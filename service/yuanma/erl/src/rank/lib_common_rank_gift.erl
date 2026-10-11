%% ---------------------------------------------------------------------------
%% @doc lib_common_rank_gift

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/16
%% @deprecated  助力礼包，照顾相对弱的玩家根据排名补发奖励
%% ---------------------------------------------------------------------------
-module(lib_common_rank_gift).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("common_rank.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

init_first_rank_list() ->
    Sql = io_lib:format(<<"select `info` from `module_info` where `module` = ~p and `sub_module` = ~p">>, [?MOD_RANK, 0]),
    case db:get_row(Sql) of
        [] -> [];
        [FirstRankList] ->
            util:bitstring_to_term(FirstRankList)
    end.

%% 零点定时器执行，更新助力礼包阈值
%% 给在线玩家发放对应奖励
-ifdef(RANK_GIFT_OPEN).
zero_timer(_State, []) -> _State;
zero_timer(State, DealPowerGiftList) ->
    #common_rank_state{first_rank_list = FirstRankList} = State,
    spawn(fun() ->
        [begin
             timer:sleep(100),
             lib_player:apply_cast(OnlineId, ?APPLY_CAST_SAVE, ?MODULE, rank_power_gift_get, [DealPowerGiftList])
         end||#ets_online{id = OnlineId} <- ets:tab2list(?ETS_ONLINE)]
         end),
    NewFirstRankListTmp = [DealPowerGiftList|FirstRankList],
    %% 保存三天的第一名数据
    {NewFirstRankList, _} = ulists:sublist(NewFirstRankListTmp, 3),
    %% 考虑下只有一条数据怎么存比较好
    %% 使用玩家表保存，只存一条数据
    Sql = io_lib:format(<<"replace into `module_info` (`module`, `sub_module`, `info`) value (~p, ~p, '~s')">>, [?MOD_RANK, 0, util:term_to_string(NewFirstRankList)]),
    ?PRINT("Sql : ~s ~n", [Sql]),
    db:execute(Sql),
    State#common_rank_state{first_rank_list = NewFirstRankList}.
-else.
zero_timer(_State, _) -> _State.
-endif.

-ifdef(RANK_GIFT_OPEN).
login(Ps) ->
    RoleId = Ps#player_status.id,
    Sql = io_lib:format("select `gift_time_info` from `role_rank_power_gift_time` where `role_id`= ~p ", [RoleId]),
    Now = utime:unixtime(),
    case db:get_row(Sql) of
        [] ->
            RankPowerGiftTime = [{RankType, 0}||RankType<-?RANK_POWER_GIFT_LIST],
            mod_common_rank:player_login(RoleId);
        [RankPowerGiftTimeStr] ->
            [{_, GetTime}|_] = RankPowerGiftTime = util:bitstring_to_term(RankPowerGiftTimeStr),
            IsSameDay = utime:is_same_day(Now, GetTime),
            if
                IsSameDay -> skip;
                true ->
                    mod_common_rank:player_login(RoleId)
            end
    end,
%%    ?MYLOG("zh_rank_gift", "RankPowerGiftTime ~p ~n", [RankPowerGiftTime]),
    Ps#player_status{rank_power_gift_time = RankPowerGiftTime}.
-else.
login(Ps) -> Ps.
-endif.

-ifdef(RANK_GIFT_OPEN).
relogin(Ps) ->
    #player_status{rank_power_gift_time = RankPowerGiftTime, id=RoleId} = Ps,
    Now = utime:unixtime(),
    case RankPowerGiftTime of
        [{_, GetTime}|_] = RankPowerGiftTime ->
            IsSameDay = utime:is_same_day(Now, GetTime),
            if
                IsSameDay -> skip;
                true ->
                    mod_common_rank:player_login(RoleId)
            end,
            Ps;
        _ ->
            RankPowerGiftTime = [{RankType, 0}||RankType<-?RANK_POWER_GIFT_LIST],
            mod_common_rank:player_login(RoleId),
            Ps#player_status{rank_power_gift_time = RankPowerGiftTime}
    end.
-else.
relogin(Ps) -> Ps.
-endif.

%% 玩家登陆获取助力礼包
%% @param FirstRankList [[{RankType, #common_rank_role{}}|_]|_]
player_login(Ps, FirstRankList) ->
    #player_status{rank_power_gift_time = RankPowerGiftTime, id = RoleId} = Ps,
    [{_, LastTime}|_] = RankPowerGiftTime,
    %% 上次领取助力礼0定点时间
    LastMidNightTime = utime:unixdate(LastTime),
    %% 今天午夜
    TodayMidNightTime = utime:unixdate(),
    {LastPs, AllRewards} = send_login_power_gift(Ps, FirstRankList, LastMidNightTime, TodayMidNightTime, 1, []),
    send_reward_by_mail(LastPs#player_status.id, AllRewards),
    ?IF(Ps#player_status.rank_power_gift_time /= LastPs#player_status.rank_power_gift_time,
        save_power_gift_time(RoleId, LastPs#player_status.rank_power_gift_time), skip),
%%    ?MYLOG("zh_rank_gift", "FirstRankList ~p, LastPs RankPowerGiftTime ~p ~n", [FirstRankList, LastPs#player_status.rank_power_gift_time]),
    LastPs.

send_login_power_gift(Ps, [], _LastMidNightTime, _TodayMidNightTime, _DiffDay, GrandReward) -> {Ps, GrandReward};
send_login_power_gift(Ps, [DayRankPowerGift|T], LastMidNightTime, TodayMidNightTime, DiffDay, GrandReward) ->
    %% 判断n天前是否领取奖励，没领取则给予奖励
    LoginDay = lib_player_login_day:get_player_login_days(Ps) - 1,
    IsSatisfy = TodayMidNightTime >= LastMidNightTime + DiffDay * ?ONE_DAY_SECONDS andalso LoginDay >= DiffDay,
    case IsSatisfy of
        true ->
            OpenDay = util:get_open_day(),
            {NewPs, AllRewards} = rank_power_gift_get_do(Ps, DayRankPowerGift, OpenDay, []),
            send_login_power_gift(NewPs, T, LastMidNightTime, TodayMidNightTime, DiffDay + 1, [AllRewards|GrandReward]);
        _ -> {Ps, GrandReward}
    end.

%% 0点在线玩家进程领取助力奖励
rank_power_gift_get(Ps, DayRankPowerGift) ->
    OpenDay = util:get_open_day(),
    {LastPs, AllRewards} = rank_power_gift_get_do(Ps, DayRankPowerGift, OpenDay, []),
    send_reward_by_mail(Ps#player_status.id, AllRewards),
    #player_status{rank_power_gift_time = NewRankPowerGiftTime, id = RoleId} = LastPs,
    save_power_gift_time(RoleId, NewRankPowerGiftTime),
    LastPs.

rank_power_gift_get_do(Ps, [], _OpenDay, GrandReward) -> {Ps, GrandReward};
rank_power_gift_get_do(Ps, [{RankType, #common_rank_role{value = BaseValue}}|T], OpenDay, GrandReward) when
    RankType == ?RANK_TYPE_LV orelse RankType == ?RANK_TYPE_COMBAT ->
    #player_status{figure = #figure{lv = RoleLv}, rank_power_gift_time = RankPowerGiftTime, combat_power = Combat} = Ps,
    Now = utime:unixtime(),
    NewRankPowerGiftTime = lists:keystore(RankType, 1, RankPowerGiftTime, {RankType, Now}),
    {NewPsTmp, NewGrandReward} = send_power_gift_reward(Ps, RankType, BaseValue, RoleLv,  Combat, OpenDay, GrandReward),
    NewPs = NewPsTmp#player_status{rank_power_gift_time = NewRankPowerGiftTime},
    rank_power_gift_get_do(NewPs, T, OpenDay, NewGrandReward);
rank_power_gift_get_do(Ps, [_|T], OpenDay, GrandReward) ->
    rank_power_gift_get_do(Ps, T, OpenDay, GrandReward).

%% 助力礼包发放
%% 等级助力
send_power_gift_reward(Ps, ?RANK_TYPE_LV, FirstLv, RoleLv, _RoleCombat, OpenDay, GrandReward) ->
    DiffLv = FirstLv - RoleLv,
    case data_ranking:get_lv_power_gift(OpenDay, DiffLv) of
        #base_rank_reward_lv{reward_pool = RewardPool} ->
            [{ReceiveTimes, WeightPool}|_] = RewardPool,
            GetRewards = random_reward_times(ReceiveTimes, WeightPool, []),
%%            Produce = #produce{type = rank_power_gift, reward = GetRewards, show_tips = ?SHOW_TIPS_0},
%%            lib_goods_api:send_reward(Ps, Produce);
            {Ps, [GetRewards|GrandReward]};
        _ -> {Ps, GrandReward}
    end;
%% 战力助力
send_power_gift_reward(Ps, ?RANK_TYPE_COMBAT, FirstCombat, _RoleLv, RoleCombat, OpenDay, GrandReward) ->
    case data_ranking:get_combat_power_gift(OpenDay) of
        #base_rank_reward_combat{
            base_value1 = BaseValue1,
            cal_percent1 = CalPercent1,
            base_value2 = BaseValue2,
            cal_percent2 = CalPercent2,
            reward_pool1 = RewardPool1,
            reward_pool2 = RewardPool2,
            reward_pool3 = RewardPool3
        } ->
            %% 划分高战力， 活跃战力， 屌丝战力
            if
                BaseValue1 == 0 -> %% 基础值为0时，需要根据战力第一的仁兄根据百分比来计算
                    HighPowerLimit = FirstCombat * CalPercent1 div 1000,
                    ActivePowerLimit = FirstCombat * CalPercent2 div 1000;
                true ->
                    HighPowerLimit = BaseValue1,
                    ActivePowerLimit = BaseValue2
            end,
            if
                RoleCombat >= HighPowerLimit -> RewardPool = RewardPool1;%% 高战玩家
                RoleCombat < HighPowerLimit andalso RoleCombat >= ActivePowerLimit -> RewardPool = RewardPool2;%% 活跃玩家
                RoleCombat < ActivePowerLimit -> RewardPool = RewardPool3; %% 屌丝玩家
                true -> RewardPool = []
            end,
            case RewardPool of
                [{ReceiveTimes, WeightPool}|_] ->
                    GetRewards = random_reward_times(ReceiveTimes, WeightPool, []),
%%                    Produce = #produce{type = rank_power_gift, reward = GetRewards, show_tips = ?SHOW_TIPS_0},
%%                    lib_goods_api:send_reward(Ps, Produce);
                    {Ps, [GetRewards|GrandReward]};
                _ -> {Ps, GrandReward}
            end;
        _ -> {Ps, GrandReward}
    end.

%% 根据获取件数和权重获取奖励
random_reward_times(0, _WeightPool, Rewards) -> Rewards;
random_reward_times(Residue, WeightPool, GrandRewards) ->
    NewGrandRewards = urand:rand_with_weight(WeightPool) ++ GrandRewards,
    random_reward_times(Residue - 1, WeightPool, NewGrandRewards).


save_power_gift_time(RoleId, RankPowerGiftTime) ->
    Sql = io_lib:format(<<"replace into `role_rank_power_gift_time` (`role_id`, `gift_time_info`) value (~p, '~s')">>, [RoleId, util:term_to_string(RankPowerGiftTime)]),
    db:execute(Sql).

send_reward_by_mail(RoleId, RewardTmp) ->
    Reward = lists:flatten(RewardTmp),
    case Reward of
        [] -> skip;
        _ ->
            Title = utext:get(2210009),
            Content = utext:get(2210010),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, ulists:object_list_plus_extra(Reward))
    end.
