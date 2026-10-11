%% ---------------------------------------------------------------------------
%% @doc afk.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-31
%% @deprecated 挂机(规则2)
%% ---------------------------------------------------------------------------

-module(lib_afk).
-compile(export_all).

-include("server.hrl").
-include("afk.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("drop.hrl").
-include("def_fun.hrl").
-include("buff.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("vip.hrl").

%% 登录##触发奖励
login(Player, LoginType) ->
    loading_afk(Player, LoginType, true).
loading_afk(#player_status{id = RoleId, accname = AccName, figure = #figure{lv = Lv}} = Player, LoginType, IsSubc) ->
    DbInfo = db_role_afk_select(RoleId),
    case DbInfo of
        [] ->
            AfkLeftTime = 0,
            StatusAfk = #status_afk{afk_left_time = AfkLeftTime};
        [AfkLeftTime, AfkUtime, NoGoodsLBin, DayBGold, DayUtime, ExpRatioLBin, AllAfkUTime, BackTime, BackExp, HadBackT] ->
            NoGoodsL = util:bitstring_to_term(NoGoodsLBin),
            ExpRatioL = util:bitstring_to_term(ExpRatioLBin),
            StatusAfk = #status_afk{
                afk_left_time = AfkLeftTime, afk_utime = AfkUtime, no_goods_list = NoGoodsL,
                day_bgold = DayBGold, day_utime = DayUtime, exp_ratio_list = ExpRatioL,
                all_afk_utime = AllAfkUTime, back_time = BackTime, back_exp = BackExp, had_back_time = HadBackT
                }
    end,
    OpenLv = ?AFK_KV_OPEN_LV,
    % ?MYLOG("hjhafk", "login OldExp:~p NewExp:~p ~n", [Player#player_status.exp, Player#player_status.exp]),
    IsInit = ?IF(LoginType == ?ONHOOK_AGENT_LOGIN, ?AFK_INIT_NO, ?AFK_INIT_YES),
    NewPlayer =
    if
        % 第一次初始化,则赋值10个小时挂机时间
        DbInfo == [] ->
            NewStatusAfk = StatusAfk#status_afk{
                is_init = IsInit, afk_left_time = ?AFK_KV_DEFAULT_AFK_TIME, afk_utime = utime:unixtime()
                },
            Player#player_status{afk = NewStatusAfk};
        % 1、没有挂机时间
        % 2、等级不足
        AfkLeftTime == 0 orelse Lv < OpenLv ->
            NewStatusAfk = StatusAfk#status_afk{is_init = IsInit, afk_utime = utime:unixtime()},
            Player#player_status{afk = NewStatusAfk};
        % 若是托管，默认不初始化
        LoginType == ?ONHOOK_AGENT_LOGIN ->
            Player#player_status{afk = StatusAfk#status_afk{is_init = ?AFK_INIT_NO}};
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, calc_off, []),
            Player#player_status{afk = StatusAfk}
    end,
    % 订阅处理
    IsSubc andalso lib_subscribe_api:login(?MOD_ONHOOK, AccName, RoleId),
    NewPlayer.

%% 接取某个主线任务后设置离线挂机奖励
after_trigger_main_task(PS) ->
    #player_status{afk = StatusAfk} = PS,
    #status_afk{afk_left_time = AfkLeftTime, afk_utime = AllUTime} = StatusAfk,
    NewAfkLeftTime = max(AfkLeftTime, 3600),
    NowTime = utime:unixtime(),
    CostTime = (NowTime - AllUTime),
    if
        CostTime > 7200 ->
            NewAllUTime = NowTime - 7200;
        CostTime < 3600 ->
            NewAllUTime = NowTime - 3600;
        true ->
            NewAllUTime = AllUTime
    end,
    ExpRatioL = get_exp_buff(PS, NowTime),
    NewStatusAfk = StatusAfk#status_afk{afk_left_time = NewAfkLeftTime, afk_utime = NewAllUTime, is_init = ?AFK_INIT_NO, exp_ratio_list = ExpRatioL},
    {ok, LastPS} = calc_off(PS#player_status{afk = NewStatusAfk}),
    pp_onhook:handle(13212, LastPS, []),
    LastPS.

%% 分离有经验加成和没有经验加成的分别计算
calc_off(Player) ->
    #player_status{figure = #figure{lv = Lv}, afk = StatusAfk} = Player,
    #status_afk{is_init = IsInit, afk_left_time = AfkLeftTime, all_afk_utime = AllAfkUTime} = StatusAfk,
    BaseAfk = data_afk:get_afk(Lv),
    IsMaxAfkTime = AllAfkUTime >= ?AFK_KV_MAX_ALL_AFK_TIME,
    if
        IsInit == ?AFK_INIT_YES -> {ok, Player};
        IsMaxAfkTime orelse AfkLeftTime == 0 orelse is_record(BaseAfk, base_afk) == false ->
            NewStatusAfk = StatusAfk#status_afk{is_init = ?AFK_INIT_YES, afk_utime = utime:unixtime()},
            NewPlayer = Player#player_status{afk = NewStatusAfk},
            {ok, NewPlayer};
        true ->
            OffPlayer = do_calc_off(Player, BaseAfk),
            % ?MYLOG("hjhafk", "calc_off OldExp:~p NewExp:~p ~n", [Player#player_status.exp, OffPlayer#player_status.exp]),
            {ok, OffPlayer}
    end.

do_calc_off(Player, BaseAfk) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, afk = StatusAfk} = Player,
    NowTime = utime:unixtime(),
    #status_afk{
        afk_left_time = AfkLeftTime, afk_utime = AfkUtime, exp_ratio_list = ExpRatioL, day_bgold = DayBGold,
        day_utime = DayUtime, all_afk_utime = AllAfkTime, back_exp = OBackExp, back_time = OBackTime
        } = StatusAfk,
    ExpBuffL = [{BuffExpRatio, BuffEndTime}||{_BuffType, BuffExpRatio, BuffEndTime}<-ExpRatioL, _BuffType == ?BUFF_EXP_KILL_MON],
    {NewAfkLeftTime, CostAfkTime, Multi, NorMulti, DayRatioL0} = calc_time(NowTime, AfkLeftTime, AfkUtime, AllAfkTime, ExpBuffL),
    %% 其余的经验buff加成（非经验符）不会占用多倍时间（可找回奖励）
    OtherRatio = lib_goods_buff:get_exp_buff_other(Player),
    DayRatioL = [{Date, DayMutil, DRatio + OtherRatio}||{Date, DayMutil, DRatio}<-DayRatioL0],
    %?MYLOG(4294969157 == RoleId, "lzhafk", "OldBuffExpRatio ~p, ExpRatioL ~p ~n", [OldBuffExpRatio, ExpRatioL]),
    %?MYLOG(4294969157 == RoleId, "lzhafk", "ExpBuffL ~p, DayRatioL ~p ~n", [ExpBuffL, DayRatioL]),
    BackTime = min(NorMulti * ?AFK_KV_UNIT_TIME + OBackTime, ?AFK_KV_MAX_BACK_SECOND),
    % 实际找回触发次数（找回的时间最多能保存一定的时间，超过一值则不会再保存，所以实际找回次数用于计算BackExp）
    RealBackMulti = max((BackTime - OBackTime) div ? AFK_KV_UNIT_TIME, 0),
    NewAfkUtime = NowTime,
    NewStatusAfk = StatusAfk#status_afk{is_init = ?AFK_INIT_YES, afk_left_time = NewAfkLeftTime, afk_utime = NewAfkUtime, back_time = BackTime},
    db_role_afk_replace(RoleId, NewStatusAfk),
    NewPlayer = Player#player_status{afk = NewStatusAfk},
    % 每天绑定钻石上限
    case utime:is_same_day(NowTime, DayUtime) of
        true -> NewDayBGold = DayBGold;
        false -> NewDayBGold = 0
    end,
    NewDayUtime = utime:standard_unixdate(NowTime),
    BGoldLimitL = [{NewDayUtime, NewDayBGold}],
    {RewardPlayer1, NewBGoldLimitL, BackExpL, SumExp, OffRewardL1} = send_reward(DayRatioL, NewPlayer, BaseAfk, BGoldLimitL, NewDayUtime, [], 0, []),
    %% 其他奖励
    if
        CostAfkTime >= 8*?ONE_HOUR_SECONDS ->
            OtherReward = lib_module_buff:get_offline_onhook_reward(RewardPlayer1),
            OtherRewardCnt = umath:floor(CostAfkTime / (8*?ONE_HOUR_SECONDS)),
            NewOtherReward = [{A,B,C*OtherRewardCnt} ||{A,B,C} <- OtherReward],
            % OtherProduce = #produce{type = afk_off, reward = NewOtherReward},
            % RewardPlayer = lib_goods_api:send_reward(RewardPlayer1, OtherProduce),
            RewardPlayer = RewardPlayer1,
            OffRewardL = NewOtherReward++OffRewardL1;
        true ->
            RewardPlayer = RewardPlayer1,
            OffRewardL = OffRewardL1
    end,
    % 每天绑定钻石的数量
    case lists:keysort(1, NewBGoldLimitL) of
        [{NewDayUtime2, NewDayBold2}|_] -> ok;
        _ -> NewDayUtime2 = DayUtime, NewDayBold2 = DayBGold
    end,
    case utime:is_same_day(NowTime, NewDayUtime2) of
        true -> NewDayBGold3 = NewDayBold2;
        false -> NewDayBGold3 = 0
    end,
    lib_log_api:log_afk(RoleId, 2, AfkLeftTime, NewAfkLeftTime, AfkUtime, NewAfkUtime, NewDayBGold, NewDayBGold3, Multi, CostAfkTime, OffRewardL),
    % 获得找回的经验,最大数量的倍数
    %BackExp = lists:sum([TmpExp||{TmpMulti, TmpExp}<-BackExpL, TmpMulti>=?AFK_KV_BACK_UNIT_TIME div ?AFK_KV_UNIT_TIME]),
    BackExpList = [{TmpMulti, TmpExp}||{TmpMulti, TmpExp}<-BackExpL, TmpMulti>=?AFK_KV_BACK_UNIT_TIME div ?AFK_KV_UNIT_TIME],
    F_back_exp =
        fun
            ({_TmpMulti, _TmpExp}, {0, AccExp}) -> {0, AccExp};
            ({TmpMulti, TmpExp}, {AccBackMulti, AccExp}) ->
                case AccBackMulti > TmpMulti of
                    true -> {AccBackMulti - TmpMulti, TmpExp + AccExp};
                    _ -> {0, round(TmpExp div TmpMulti * AccBackMulti) + AccExp}
                end
        end,
    {_, BackExp} = lists:foldl(F_back_exp, {RealBackMulti, 0}, BackExpList),
    % ?MYLOG("zh_afk", "lists:sum([TmpExp||{TmpMulti, TmpExp}<-BackExpL, TmpMulti>=?AFK_KV_BACK_UNIT_TIME div ?AFK_KV_UNIT_TIME]) ~p ~n",
    %     [lists:sum([TmpExp||{TmpMulti, TmpExp}<-BackExpL, TmpMulti>=?AFK_KV_BACK_UNIT_TIME div ?AFK_KV_UNIT_TIME])]),
    % ?MYLOG("zh_afk", "BackExpList ~p F_back_exp ~p ~n", [BackExpList, BackExp]),
    % 经验找回影响因子
    FtBackExp = round(BackExp * ?AFK_KV_BACK_EXP_FACTOR / ?RATIO_COEFFICIENT),
    MaxBackCount = BackTime div ?AFK_KV_BACK_UNIT_TIME,
    NewBackExp = ?IF(MaxBackCount==0, 0, FtBackExp) + OBackExp,
    #player_status{afk = NewStatusAfk2} = RewardPlayer,
    #status_afk{no_goods_list = NoGoodsList} = NewStatusAfk2,
    NewNoGoodsList = lib_goods_api:make_reward_unique(NoGoodsList ++ OffRewardL),
    %?MYLOG("zh_afk", "CostAfkTime ~p, AllAfkTime ~p ~n", [CostAfkTime, AllAfkTime]),
    NewStatusAfk3 = NewStatusAfk2#status_afk{
        exp_ratio_list = [], day_bgold = NewDayBGold3, day_utime = NowTime,
        no_goods_list = NewNoGoodsList, off_lv = Lv, off_cost_afk_time = Multi*?AFK_KV_UNIT_TIME,
        back_time = BackTime, back_exp = NewBackExp, all_afk_utime = CostAfkTime + AllAfkTime
        },
    db_role_afk_replace(RoleId, NewStatusAfk3),
    % 补偿
    % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_compensate_exp, compensate, [CostAfkTime, SumExp]),
    % ?MYLOG("hjhafk", "StatusAfk:~p NewStatusAfk3:~p BackExpL:~p ~n", [StatusAfk, NewStatusAfk3, BackExpL]),
    RewardPlayer#player_status{afk = NewStatusAfk3}.

%% 计算时间
%% @return {NewAfkLeftTime, CostAfkTime, Multi, NorMulti, DayRatioL}
%% {剩余的挂机时间, 消耗的挂机时间, 触发将计算次数（总的）, 触发计算次数（普通触发）, }
calc_time(TriggerTime, AfkLeftTime, AfkUtime, AllAfkTime, []) ->
    calc_time(TriggerTime, AfkLeftTime, AfkUtime, AllAfkTime, [{0, 0}]);
calc_time(TriggerTime, AfkLeftTime, AfkUtime, AllAfkTime, ExpBuffL) ->
    % 获得消耗的时间
    CostAfkTime0 = min(AfkLeftTime, max(0, TriggerTime - AfkUtime)),
    CostAfkTime = min(max(?AFK_KV_MAX_ALL_AFK_TIME - AllAfkTime, 0), CostAfkTime0),
    % 获得消耗的时间戳
    CostAfkTimestamp = AfkUtime + CostAfkTime,
    % 触发的次数以及剩余时间
    Multi = CostAfkTime div ?AFK_KV_UNIT_TIME,
    RealCostAfkTime = Multi*?AFK_KV_UNIT_TIME,
    NewAfkLeftTime = AfkLeftTime - RealCostAfkTime,
    % {无加成次数,倍率列表}
    {LastNorMulti, RatioL} = if
        Multi == 0 -> {0, []};
        true ->
            calc_time_ratio_recursive(Multi, AfkUtime, CostAfkTimestamp, ExpBuffL, [])
    end,
    % ?MYLOG("zh_afk", "calc_time CostAfkTime ~p, CostAfkTimestamp ~p, Multi ~p , RealCostAfkTime ~p ~n",
    %     [CostAfkTime, CostAfkTimestamp, Multi, RealCostAfkTime]),
    % ?MYLOG("zh_afk", "{LastNorMulti, RatioL} ~p ~n",
    %     [{LastNorMulti, RatioL}]),
    DayRatioL = calc_time_help(RatioL, AfkUtime),
    {NewAfkLeftTime, RealCostAfkTime, Multi, LastNorMulti, DayRatioL}.

calc_time_ratio_recursive(LeftMulti, _LeftAfkUTime, _CostAfkTimestamp, [], []) ->
    {LeftMulti, [{LeftMulti, 0}]};
calc_time_ratio_recursive(0, _LeftAfkUTime, _CostAfkTimestamp, [], Result) ->
    {0, lists:reverse(Result)};
calc_time_ratio_recursive(LeftMulti, _LeftAfkUTime, _CostAfkTimestamp, [], Result) ->
    {LeftMulti, lists:reverse([{LeftMulti, 0}|Result])};
calc_time_ratio_recursive(LeftMulti, LeftAfkUTime, CostAfkTimestamp, [{_BuffExpRatio, BuffEndTime}|H], Result)
    when LeftAfkUTime >= BuffEndTime ->% 比buff结束时间大
    calc_time_ratio_recursive(LeftMulti, LeftAfkUTime, CostAfkTimestamp, H, Result);
calc_time_ratio_recursive(LeftMulti, _LeftAfkUTime, CostAfkTimestamp, [{BuffExpRatio, BuffEndTime}|_], Result)
    when CostAfkTimestamp =< BuffEndTime ->% 比buff结束时间还小
    {0, lists:reverse([{LeftMulti, BuffExpRatio}|Result])};
calc_time_ratio_recursive(LeftMulti, LeftAfkUTime, CostAfkTimestamp, [{BuffExpRatio, BuffEndTime}|H], Result) ->
    CostMulti = (BuffEndTime - LeftAfkUTime) div ?AFK_KV_UNIT_TIME,
    case LeftMulti > CostMulti of
        true ->
            NewResult = [{CostMulti, BuffExpRatio}|Result],
            NewLeftMulti = LeftMulti - CostMulti,
            calc_time_ratio_recursive(NewLeftMulti, BuffEndTime, CostAfkTimestamp, H, NewResult);
        _ ->
            {0, lists:reverse([{LeftMulti, BuffExpRatio}|Result])}
    end.



%% @return {零点, 零点且当前倍率能执行的次数, 倍率},
calc_time_help(RatioL, Utime) ->
    UnixDate = max(utime:standard_unixdate(Utime), 0),
    NextDate = utime:get_next_unixdate(Utime),
    DayMulti = (NextDate - Utime) div ?AFK_KV_UNIT_TIME,
    calc_time_help(RatioL, UnixDate, DayMulti, []).

calc_time_help([], _UnixDate, _DayMulti, RatioL) -> lists:reverse(RatioL);
calc_time_help([{Multi, Ratio}|T] = L, UnixDate, DayMulti, RatioL) ->
    if
        DayMulti == 0 ->
            NextDate = utime:get_next_unixdate(UnixDate),
            NewDayMulti = (NextDate - UnixDate) div ?AFK_KV_UNIT_TIME,
            calc_time_help(L, NextDate, NewDayMulti, RatioL);
        DayMulti >= Multi ->
            calc_time_help(T, UnixDate, DayMulti-Multi, [{UnixDate, Multi, Ratio}|RatioL]);
        true ->
            calc_time_help([{Multi-DayMulti, Ratio}|T], UnixDate, 0, [{UnixDate, Multi, Ratio}|RatioL])
    end.

send_reward([], Player, _BaseAfk, BGoldLimitL, _NowDayUtime, BackExpL, SumExp, SumRewardL) ->
    {Player, BGoldLimitL, BackExpL, SumExp, lib_goods_api:make_reward_unique(SumRewardL)};
send_reward([{EveryDate, MaxMulti, Ratio}|DayRatioL], Player, BaseAfk, BGoldLimitL, NowDayUtime, BackExpL, SumExp, SumRewardL) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, exp = LeftExp, combat_power = Cp} = Player,
    NextLvMaxExp = data_exp:get(Lv),
    UnitExp = calc_exp(Player, BaseAfk, Cp, Ratio),
    if
        % 满级无法升级了,就全部使用这一套逻辑
        LeftExp >= NextLvMaxExp -> Multi = MaxMulti;
        % 单位经验值等于0
        UnitExp == 0 -> Multi = MaxMulti;
        true ->
            % 升级需要的次数
            ThisLvMulti = umath:ceil((NextLvMaxExp - LeftExp) / UnitExp),
            Multi = min(MaxMulti, ThisLvMulti)
    end,
    % 经验、铜币、
    AddExp = calc_exp(Player, BaseAfk, Cp, Ratio, Multi),
    AddCoin = round(Multi*calc_unit_coin(Player, BaseAfk, Cp)),
    % 任务掉落
    {PlayerTmp, TaskRewardL} = lib_task_drop:get_task_stage_func_reward_multi(Player, ?TASK_FUNC_TYPE_AFK, 0, Lv, Multi),
    % 掉落奖励
    #base_afk{drop_list = DropList, drop_rule = CfgDropRule} = BaseAfk,
    DropRule = #ets_drop_rule{drop_list = DropList, drop_rule = CfgDropRule},
    DropRewardL = lib_drop_reward:calc_pure_drop_rule_reward_multi(PlayerTmp, DropRule, Multi),
    % 额外掉落(不会统计绑定钻石上限)
    {NewPS, ExtraRewardL} = lib_afk_event:get_extra_afk_reward_on_off(PlayerTmp, EveryDate, Multi),
    SumDropRewardL = TaskRewardL ++ DropRewardL,
    % ?MYLOG("afk", "TaskRewardL:~p DropRewardL:~p ~n", [TaskRewardL, DropRewardL]),
    F = fun(T, {BGoldNum, RewardL}) ->
        case T of
            {?TYPE_GOODS, ?GOODS_ID_BGOLD, Num} -> {BGoldNum+Num, RewardL};
            _ -> {BGoldNum, [T|RewardL]}
        end
    end,
    {BGoldNum, NewDropRewardL} = lists:foldl(F, {0, []}, SumDropRewardL),
    % 绑定钻石
    MaxDayBGold = ?AFK_KV_MAX_DAY_BGOLD,
    case lists:keyfind(EveryDate, 1, BGoldLimitL) of
        {_, DayBGold} -> ok;
        _ -> DayBGold = 0
    end,
    AddBGoldNum = max(0, min(MaxDayBGold-DayBGold, BGoldNum)),
    NewDayBGold = DayBGold + AddBGoldNum,
    NewBGoldLimitL = lists:keystore(EveryDate, 1, BGoldLimitL, {EveryDate, NewDayBGold}),
    % 当天生成的绑定钻石,要写入数据库
    case EveryDate == NowDayUtime andalso AddBGoldNum > 0 of
        true -> db_role_afk_update_day_bgold(RoleId, NewDayBGold, NowDayUtime);
        false -> skip
    end,
    % 发送奖励
    BaseRewardL = [{?TYPE_EXP, 0, AddExp}, {?TYPE_COIN, 0, AddCoin}, {?TYPE_BGOLD, 0, AddBGoldNum}],
    NewBaseRewardL = [{Type, GoodTypeId, Num}||{Type, GoodTypeId, Num}<-BaseRewardL, Num > 0],
    OffRewardL = lib_goods_api:make_reward_unique(ExtraRewardL ++ NewBaseRewardL ++ NewDropRewardL),
    % Produce = #produce{type = afk_off, reward = OffRewardL},
    % % RewardPlayer = lib_goods_api:send_reward(NewPS, Produce),
    % {ok, _, RewardPlayer, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPS, Produce),
    % {_IsDevour, DevourPlayer} = auto_devour_equips(RewardPlayer, UpGoodsList),
    #player_status{figure = #figure{lv = NewLv}} = NewPS,
    % 使用最新
    case data_afk:get_afk(NewLv) of
        #base_afk{} = NewBaseAfk -> ok;
        _ -> NewBaseAfk = BaseAfk
    end,
    LeftMulti = MaxMulti - Multi,
    % 是否有剩余的
    case LeftMulti == 0 of
        true -> NewDayRatioL = DayRatioL;
        false -> NewDayRatioL = [{EveryDate, LeftMulti, Ratio}|DayRatioL]
    end,
    % 没有加成要汇总所有加成
    case Ratio == 0 of
        true ->
            % 原生经验值
            OrigUnitExp = round(calc_unit_exp(Player, BaseAfk, Cp)),
            NewBackExpL = calc_back_exp_list(BackExpL, Multi, OrigUnitExp);
        false ->
            NewBackExpL = BackExpL
    end,
    PlRatio = lib_player:get_exp_add_ratio(Player#player_status{goods_buff_exp_ratio = 0}, ?ADD_EXP_AFK, Ratio),
    lib_log_api:log_afk_off(RoleId, EveryDate, Multi, umath:ceil(Ratio*?RATIO_COEFFICIENT), umath:ceil(PlRatio*?RATIO_COEFFICIENT),
        Lv, Cp, NewLv, AddExp, AddCoin, AddBGoldNum, NewDayBGold, NewDropRewardL),
    send_reward(NewDayRatioL, NewPS, NewBaseAfk, NewBGoldLimitL, NowDayUtime, NewBackExpL, SumExp+AddExp, OffRewardL++SumRewardL).

%% 计算经验(把物品经验消耗重置)
calc_exp(Player, BaseAfk, Cp, Ratio, Multi) ->
    AddExp = calc_exp(Player, BaseAfk, Cp, Ratio),
    Multi*AddExp.

%% 计算经验(把物品经验消耗重置)
calc_exp(Player, BaseAfk, Cp, Ratio) ->
    AddRatio = lib_player:get_exp_add_ratio(Player#player_status{goods_buff_exp_ratio = 0}, ?ADD_EXP_AFK, umath:ceil(Ratio*?RATIO_COEFFICIENT)),
    round(calc_unit_exp(Player, BaseAfk, Cp)*AddRatio).

%% @param UnitBackMulti 单位放回值
%% @return {倍率, 经验值},塞满了就不处理了,默认最后一个就是不满的
calc_back_exp_list(BackExpL, AddMulti, UnitExp) ->
    UnitBackMulti = ?AFK_KV_BACK_UNIT_TIME div ?AFK_KV_UNIT_TIME,
    case BackExpL == [] of
        true -> calc_back_exp_list_help(UnitBackMulti, AddMulti, UnitExp, []);
        false ->
            {LastMulti, LastExp} = lists:last(BackExpL),
            CanAddMulti = min(AddMulti, UnitBackMulti - LastMulti),
            if
                CanAddMulti > 0 ->
                    NewBackExpL = lists:keystore(LastMulti, 1, BackExpL, {LastMulti+CanAddMulti, LastExp+CanAddMulti*UnitExp}),
                    LeftMulti = AddMulti - CanAddMulti,
                    calc_back_exp_list_help(UnitBackMulti, LeftMulti, UnitExp, NewBackExpL);
                true ->
                    calc_back_exp_list_help(UnitBackMulti, AddMulti, UnitExp, BackExpL)
            end
    end.

calc_back_exp_list_help(UnitBackMulti, AddMulti, UnitExp, List) when UnitBackMulti == 0 orelse AddMulti == 0 orelse UnitExp == 0 -> List;
calc_back_exp_list_help(UnitBackMulti, AddMulti, UnitExp, List) ->
    LeftMulti = AddMulti - UnitBackMulti,
    if
        LeftMulti > 0 -> calc_back_exp_list_help(UnitBackMulti, LeftMulti, UnitExp, [{UnitBackMulti, UnitBackMulti*UnitExp}|List]);
        true -> lists:reverse([{AddMulti, AddMulti*UnitExp}|List])
    end.

%% 登出
%% 修改时注意事项，否则会导致挂机计算出问题
%% 1、 2022年4月2日 托管 mod_login:logout 的执行，总的来说托管一定是会先走登陆模块，之后再正常走登出模块
%%  (1)玩家不在线但是进程存在，先执行登出(mod_login:logout(PS, ?LOGOUT_LOG_NORMAL))，再托管
%%  (2)托管结束的登出(mod_activitye_onhook进程的 timer_del_coin 和 act_end 消息)，关闭客户端(lib_fake_client:close_fake_client)，走 mod_server:do_delay_stop 模块，再走正常登出
logout(OldPlayer) ->
    Player = silent_trigger(OldPlayer),
    #player_status{id = RoleId, accname = AccName, afk = StatusAfk} = Player,
    #status_afk{is_init = IsInit} = StatusAfk,
    if
        IsInit == ?AFK_INIT_YES->
            NowTime = utime:unixtime(),
            ExpRatioL = get_exp_buff(Player, NowTime),
            % 处理日志
            #status_afk{
                trigger_log = TriggerLog, afk_left_time = AfkLeftTime, day_bgold = DayBGold,
                back_time = BackTime, back_exp = BackExp, had_back_time = HadBackTime
                } = StatusAfk,
            case TriggerLog of
                #status_afk_trigger_log{
                    acc_reward = AccReward, acc_multi = AccMulti,
                    begin_time = TriggerBeginT, acc_bgold = AccBeginGold
                } when AccReward =/= [] ->
                    lib_log_api:log_afk(RoleId, 1, AfkLeftTime, AfkLeftTime, TriggerBeginT,
                        utime:unixtime(), max(DayBGold - AccBeginGold, 0), DayBGold, AccMulti, 0, AccReward);
                _ -> skip
            end,
            MaxBackCount = BackTime div ?AFK_KV_BACK_UNIT_TIME,
            UnitBackExp = ?IF(MaxBackCount == 0, 0, BackExp div MaxBackCount),
            NewBackTime = max(0, BackTime - HadBackTime),
            LeftBackCount = NewBackTime div ?AFK_KV_BACK_UNIT_TIME,
            NewBackExp = UnitBackExp * LeftBackCount,
            NewStatusAfk = StatusAfk#status_afk{afk_utime = NowTime, exp_ratio_list = ExpRatioL, back_exp = NewBackExp, back_time = NewBackTime, had_back_time = 0},
            db_role_afk_replace(RoleId, NewStatusAfk),
            % 订阅处理
            lib_subscribe_api:logout(?MOD_ONHOOK, AccName, RoleId, [AfkLeftTime]);
        true ->
            ok
    end.

is_in_exp_buff(Player) ->
    get_exp_buff(Player, utime:unixtime()) =/= [].

get_exp_buff(Player, NowTime) ->
    #player_status{player_buff = PlayerBuff} = Player,
    BuffType = ?BUFF_EXP_KILL_MON,
    case lib_goods_buff:get_player_buff(PlayerBuff, BuffType) of
        #ets_buff{effect_list = EffectList, end_time = EndTime} when NowTime =< EndTime ->
            case lists:keyfind(?BUFF_EFFECT_EXP_KILL_MON, 1, EffectList) of
                {?BUFF_EFFECT_EXP_KILL_MON, Ratio} when is_number(Ratio) ->
                    % 经验buff支持多条并存
                    {_, OtherRatioL0} = ulists:keyfind(?BUFF_EFFECT_EXP_STOP, 1, EffectList, {?BUFF_EFFECT_EXP_STOP, []}),
                    OtherRatioL = lists:reverse(lists:keysort(1, OtherRatioL0)),
                    F = fun({ExpRatio, _, RemainTime, _}, {AccEndTime, AccL}) ->
                        {AccEndTime + RemainTime, [{BuffType, ExpRatio, AccEndTime + RemainTime}|AccL]}
                        end,
                    {_, ExpRatioL0} = lists:foldl(F, {EndTime, [{BuffType, Ratio, EndTime}]}, OtherRatioL),
                    ExpRatioL = lists:reverse(ExpRatioL0);
                _ ->
                    ExpRatioL = []
            end;
        _ ->
            ExpRatioL = []
    end,
    ExpRatioL.

%% 重连
%% 修改时注意事项，否则会导致挂机计算出问题
%% 1、2022年4月2日 只要是托管玩家，不会走重连，一定是登出玩家，再登陆。但是托管期间，玩家可以重连进去，不会走登出流程
%% （1）玩家下线后普通重连 mod_login:relogin
%% （2）玩家在托管期间重连(不会重连的，直接关进程重启)
%% （3）玩家在托管结束下线，等待3分钟延迟登出，期间玩家登陆
relogin(Player, OldOnline) ->
    %OldOnline == ?ONLINE_FAKE_ON andalso lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, calc_off, []),
    #player_status{afk = StatusAfk, id = RoleId} = Player,
    #status_afk{is_init = IsInit} = StatusAfk,
    if
        OldOnline == ?ONLINE_FAKE_ON; IsInit == ?AFK_INIT_NO ->
            db_role_afk_replace(RoleId, StatusAfk),
            loading_afk(Player, ?NORMAL_LOGIN, false);
        true ->
            NewStatusAfk = StatusAfk#status_afk{afk_utime = utime:unixtime(), afk_stop_et = 0, off_reward_list = []},
            Player#player_status{afk = NewStatusAfk}
    end.

%% 使用挂机时间卡
use_afk_goods(Player, GoodsInfo, GoodsNum) ->
    case data_goods_effect:get(GoodsInfo#goods.goods_id) of
        #goods_effect{effect_list = EffectList} ->
            case lists:keyfind(onhook_time, 1, EffectList) of
                false -> {false, ?MISSING_CONFIG};
                {onhook_time, H} ->
                    #player_status{id = RoleId, afk = StatusAfk} = Player,
                    #status_afk{afk_left_time = AfkLeftTime} = StatusAfk,
                    MaxAfkTime = get_afk_max_time(Player),
                    if
                        AfkLeftTime >= MaxAfkTime -> %% 大于20个小时不给使用离线时间卡
                            {false, ?ERRCODE(err150_onhook_time_enough)};
                        true ->
                            NewAfkLeftTime = min((H * GoodsNum) * 3600 + AfkLeftTime, MaxAfkTime),
                            NewStatusAfk = StatusAfk#status_afk{afk_left_time = NewAfkLeftTime},
                            %% 更新日常界面上的挂机时间
                            lib_activitycalen:refresh_onhook_time(RoleId, NewAfkLeftTime),
                            db_role_afk_replace(RoleId, NewStatusAfk),
                            NewPlayer = Player#player_status{afk = NewStatusAfk},
                            send_info(NewPlayer),
                            {ok, NewPlayer}
                    end
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

%% 加挂机时间接口(小时)
add_afk_time(Player, H) ->
    #player_status{id = RoleId, afk = StatusAfk} = Player,
    #status_afk{afk_left_time = AfkLeftTime} = StatusAfk,
    NewAfkLeftTime = min(H * 3600 + AfkLeftTime, get_afk_max_time(Player)),
    NewStatusAfk = StatusAfk#status_afk{afk_left_time = NewAfkLeftTime},
    %% 更新日常界面上的挂机时间
    lib_activitycalen:refresh_onhook_time(RoleId, NewAfkLeftTime),
    db_role_afk_replace(RoleId, NewStatusAfk),
    NewPlayer = Player#player_status{afk = NewStatusAfk},
    send_info(NewPlayer),
    {ok, NewPlayer}.

%% 直接设置挂机时间
set_afk_time(Player, AfkLeftTime) ->
    #player_status{id = RoleId, afk = StatusAfk} = Player,
    NewStatusAfk = StatusAfk#status_afk{afk_left_time = AfkLeftTime},
    %% 更新日常界面上的挂机时间
    lib_activitycalen:refresh_onhook_time(RoleId, AfkLeftTime),
    db_role_afk_replace(RoleId, NewStatusAfk),
    NewPlayer = Player#player_status{afk = NewStatusAfk},
    send_info(NewPlayer),
    {ok, NewPlayer}.

%% 触发
trigger(Player) ->
    NowTime = utime:unixtime(),
    {ErrCode, IsDevour, NewPlayer} = trigger_help(Player, NowTime),
    NextTime = calc_next_trigger_time(NewPlayer, NowTime),
    #player_status{afk = #status_afk{all_afk_utime = AllAfkTime}} = NewPlayer,
    {ok, BinData} = pt_132:write(13211, [ErrCode, NextTime, AllAfkTime]),
    % ?MYLOG("hjhafk", "ErrCode:~p, NowTime:~p, NextTime:~p ~n", [ErrCode, NowTime, NextTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    case IsDevour of
        true -> mod_scene_agent:update(NewPlayer, [{battle_attr, NewPlayer#player_status.battle_attr}]);
        false -> skip
    end,
    {ok, NewPlayer}.

%% 静默触发
silent_trigger(Player) ->
    {_ErrCode, IsDevour, NewPlayer} = trigger_help(Player, utime:unixtime()),
    case IsDevour of
        true -> mod_scene_agent:update(NewPlayer, [{battle_attr, NewPlayer#player_status.battle_attr}]);
        false -> skip
    end,
    NewPlayer.

%% 触发
trigger_help(Player, TriggerTime) ->
    case check_trigger(Player, TriggerTime) of
        {false, _ErrCode} ->
            % ?MYLOG("hjhafk", "trigger _ErrCode:~p ~n", [_ErrCode]),
            ErrCode = ?SUCCESS, IsDevour = false,
            NewPlayer = Player;
        {true, BaseAfk} ->
            {ok, IsDevour, NewPlayer} = do_trigger(Player, BaseAfk, TriggerTime),
            case lib_goods_api:get_cell_num(NewPlayer) > 0 of
                true -> ErrCode = ?SUCCESS;
                false -> ErrCode = ?ERRCODE(err132_bag_full_not_to_get_afk_goods)
            end
    end,
    {ErrCode, IsDevour, NewPlayer}.

check_trigger(Player, TriggerTime) ->
    #player_status{figure = #figure{lv = Lv}, afk = StatusAfk} = Player,
    #status_afk{is_init = IsInit, afk_utime = AfkUtime, afk_stop_et = AfkStopEt, all_afk_utime = AllAfkUTime}
        = recalc_status_afk(StatusAfk, TriggerTime),
    UnitTime = ?AFK_KV_UNIT_TIME,
    NewAfkUtime = max(AfkUtime, AfkStopEt),
    BaseAfk = data_afk:get_afk(Lv),
    OpenLv = ?AFK_KV_OPEN_LV,
    IsFull = AllAfkUTime >= ?AFK_KV_MAX_ALL_AFK_TIME,
    if
        IsInit == ?AFK_INIT_NO -> {false, ?FAIL};
        IsFull -> {false, ?FAIL};
        is_record(BaseAfk, base_afk) == false -> {false, ?MISSING_CONFIG};
        Lv < OpenLv -> {false, ?LEVEL_LIMIT};
        % 当前时间处于终止挂机时间戳无法触发
        TriggerTime =< AfkStopEt -> {false, ?ERRCODE(err132_in_afk_stop_et)};
        % 单位时间的配置等于0
        UnitTime == 0 -> {false, ?ERRCODE(err132_no_afk_left_time)};
        % 没到最小单位时间
        TriggerTime < NewAfkUtime + UnitTime -> {false, ?ERRCODE(err132_not_enough_afk_unit_time)};
        true -> {true, BaseAfk}
    end.

do_trigger(Player, BaseAfk, TriggerTime) ->
    #player_status{afk = StatusAfk} = Player,
    #status_afk{afk_utime = AfkUtime, all_afk_utime = AllAfkTime} = StatusAfk,
    {PlayerTmp, NewStatusAfk, Multi, AddExp, AddCoin, AddBGoldNum, NewDropRewardL, DayBGold, NewDayBGold, NewAllAfkTime}
        = do_trigger_help(Player, BaseAfk, TriggerTime, AllAfkTime),
    % #status_afk{afk_left_time = AfkLeftTime, afk_utime = NewAfkUtime, trigger_log = TriggerLog} = NewStatusAfk,
    #status_afk{trigger_log = TriggerLog, no_goods_list = NoGoodsList, back_time = OBackTime, back_exp = OBackExp} = NewStatusAfk,
    % 发奖励
    BaseRewardL = [{?TYPE_EXP, 0, AddExp}, {?TYPE_COIN, 0, AddCoin}, {?TYPE_BGOLD, 0, AddBGoldNum}],
    NewBaseRewardL = [{Type, GoodTypeId, Num}||{Type, GoodTypeId, Num}<-BaseRewardL, Num > 0],
    SumRewardL = lib_goods_api:make_reward_unique(NewBaseRewardL ++ NewDropRewardL),
    case TriggerLog of
        #status_afk_trigger_log{acc_multi = OldMulti, acc_reward = OldSumRewardL, acc_bgold = OBGold} ->
            NewTriggerLog = TriggerLog#status_afk_trigger_log{
                acc_reward = lib_goods_api:make_reward_unique(SumRewardL ++ OldSumRewardL),
                acc_multi = OldMulti + Multi, acc_bgold = OBGold + max(NewDayBGold - DayBGold, 0)
            };
        _ ->
            NewTriggerLog = #status_afk_trigger_log{
                acc_multi = Multi, acc_reward = SumRewardL,
                begin_time = AfkUtime, acc_bgold = max(NewDayBGold - DayBGold, 0)
            }
    end,
    NewNoGoodsList = lib_goods_api:make_reward_unique(SumRewardL ++ NoGoodsList),

    %% 判断是否添加双倍找回时间
    IsInBuff = is_in_exp_buff(Player),
    if
        IsInBuff ->
            BackExp = OBackExp, BackTime = OBackTime;
        true ->
            BackExp = round(AddExp * ?AFK_KV_BACK_EXP_FACTOR / ?RATIO_COEFFICIENT) + OBackExp,
            BackTime = Multi * ?AFK_KV_UNIT_TIME + OBackTime
    end,
    LastStatusAfk = NewStatusAfk#status_afk{
        back_time = BackTime, back_exp = BackExp, trigger_log = NewTriggerLog,
        no_goods_list = NewNoGoodsList, all_afk_utime = NewAllAfkTime
    },
    % 太频繁就先不存了，logout之后存一次，或者领取奖励之后
    %db_role_afk_replace(RoleId, LastStatusAfk),
    SavePlayer = PlayerTmp#player_status{afk = LastStatusAfk},
    % ！！不要提交体验,太频繁了 @modify 登出再记录
    %lib_log_api:log_afk(RoleId, 1, AfkLeftTime, AfkLeftTime, AfkUtime, NewAfkUtime, DayBGold, NewDayBGold, Multi, 0, SumRewardL),
    % Produce = #produce{type = afk_trigger, reward = SumRewardL, title = utext:get(1320001), content = utext:get(1320002)},
    % {ok, _, RewardPlayer, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(SavePlayer, Produce),
    % {IsDevour, DevourPlayer} = auto_devour_equips(RewardPlayer, UpGoodsList),
    % % 获得唯一键
    % SeeRewardL = lib_goods_api:make_see_reward_list(SumRewardL, UpGoodsList),
    % send_goods_tv(SeeRewardL, RoleId, Name),
    % case AddBGoldNum >= ?AFK_KV_TV_BGOLD_NUM of
    %     true -> lib_chat:send_TV({all}, ?MOD_ONHOOK, 2, [Name, RoleId, AddBGoldNum]);
    %     false -> skip
    % end,
    % 触发挂机
    EventPlayer = lib_afk_event:trigger_afk_on_online(SavePlayer, Multi),
    % ?MYLOG("hjhafk", "OldExp:~p NewExp:~p ~n", [Player#player_status.exp, DevourPlayer#player_status.exp]),
    % ?MYLOG("hjhafk", "send_off_reward DropRewardL:~p CanGoodsL:~p AddNoGoodsL:~p ~n", [SumGoodsL, CanGoodsL, NewNoGoodsL]),
    % ?MYLOG("hjhafk", "trigger SumRewardL:~p SeeRewardL:~p UpGoodsList:~p ~n", [SumRewardL, SeeRewardL, UpGoodsList]),
    % {ok, IsDevour, EventPlayer}.
    {ok, false, EventPlayer}.

do_trigger_help(Player, BaseAfk, TriggerTime, AllAfkTime) ->
    #player_status{figure = #figure{lv = Lv}, afk = OldStatusAfk, combat_power = Cp} = Player,
    #status_afk{
        afk_utime = AfkUtime, afk_stop_et = AfkStopEt, day_bgold = DayBGold
        } = StatusAfk = recalc_status_afk(OldStatusAfk, TriggerTime),
    EffectTime = max(?AFK_KV_MAX_ALL_AFK_TIME - AllAfkTime, 0),
    UnitTime = ?AFK_KV_UNIT_TIME,
    NewAfkUtime = max(AfkUtime, AfkStopEt),
    Multi = max(0, min(EffectTime, TriggerTime - NewAfkUtime)) div UnitTime,
    NewAfkUtime2 = NewAfkUtime + Multi*UnitTime,
    % 经验、铜币、
    AddExp = round(Multi*calc_unit_exp(Player, BaseAfk, Cp)*lib_player:get_exp_add_ratio(Player, ?ADD_EXP_AFK)),
    AddCoin = round(Multi*calc_unit_coin(Player, BaseAfk, Cp)),
    % 任务掉落
    {PlayerTmp, TaskRewardL} = lib_task_drop:get_task_stage_func_reward_multi(Player, ?TASK_FUNC_TYPE_AFK, 0, Lv, Multi),
    % 掉落奖励
    #base_afk{drop_list = DropList, drop_rule = CfgDropRule} = BaseAfk,
    DropRule = #ets_drop_rule{drop_list = DropList, drop_rule = CfgDropRule},
    DropRewardL = lib_drop_reward:calc_pure_drop_rule_reward_multi(PlayerTmp, DropRule, Multi),
    SumDropRewardL = TaskRewardL ++ DropRewardL,
    % ?MYLOG("hjhafk", "do_trigger_help TaskRewardL:~p DropRewardL:~p ~n", [TaskRewardL, DropRewardL]),
    F = fun(T, {BGoldNum, RewardL}) ->
        case T of
            {?TYPE_GOODS, ?GOODS_ID_BGOLD, Num} -> {BGoldNum+Num, RewardL};
            _ -> {BGoldNum, [T|RewardL]}
        end
    end,
    {BGoldNum, NewDropRewardL} = lists:foldl(F, {0, []}, SumDropRewardL),
    % 绑定钻石
    MaxDayBGold = ?AFK_KV_MAX_DAY_BGOLD,
    AddBGoldNum = max(0, min(MaxDayBGold-DayBGold, BGoldNum)),
    NewDayBGold = DayBGold + AddBGoldNum,
    NewStatusAfk = StatusAfk#status_afk{afk_utime = NewAfkUtime2, day_bgold = NewDayBGold, day_utime = TriggerTime},
    {PlayerTmp, NewStatusAfk, Multi, AddExp, AddCoin, AddBGoldNum, NewDropRewardL, DayBGold, NewDayBGold, AllAfkTime + Multi * ?AFK_KV_UNIT_TIME}.

%% 经验
calc_unit_exp(Player, BaseAfk, Cp) ->
    #base_afk{base_power = BasePower, base_exp = BaseExp} = BaseAfk,
    R = calc_cp_ratio(Cp, BasePower),
    {EnchantExp, _} = lib_enchantment_guard:get_afk_coe(Player),
    R*BaseExp + EnchantExp.

%% 铜币
calc_unit_coin(Player, BaseAfk, Cp) ->
    #base_afk{base_power = BasePower, base_coin = BaseCoin} = BaseAfk,
    R = calc_cp_ratio(Cp, BasePower),
    {_, EnchantCoin} = lib_enchantment_guard:get_afk_coe(Player),
    R*BaseCoin + EnchantCoin.

%% 战力比率
calc_cp_ratio(Cp, BasePower) ->
    % POWER(MAX(1,(玩家战力-标准战力)/标准战力+1),0.15)*标准经验(金钱)
    % (POWER(MAX(1,玩家战力/标准战力),0.22)+MIN(0.3,玩家战力/标准战力*0.1-0.1))*标准经验（金钱）
    Ratio = math:pow(max(1, Cp/BasePower), 0.22)+min(0.3, Cp/BasePower*0.1-0.1),
    % ?PRINT("Cp:~p, BaswPower:~p Ratio:~p ~n", [Cp, BasePower, Ratio]),
    Ratio.
    % math:pow(max(0, Cp-BasePower)/BasePower, 0.8) + 1.

%% 发送物品传闻
send_goods_tv([], _RoleId, _Name) -> ok;
send_goods_tv([{Type, GoodsTypeId, _Num, GoodsId}|T], RoleId, Name) when Type == ?TYPE_GOODS ->
    case lists:member(GoodsTypeId, ?AFK_KV_TV_LIST) of
        true -> lib_chat:send_TV({all}, ?MOD_ONHOOK, 1, [Name, RoleId, GoodsTypeId, GoodsId, RoleId]);
        false -> ok
    end,
    send_goods_tv(T, RoleId, Name);
send_goods_tv([_H|T], RoleId, Name) ->
    send_goods_tv(T, RoleId, Name).

%% 重新计算(先重新计算才能去使用存储)
recalc_status_afk(#status_afk{day_bgold = DayBGold, day_utime = DayUtime} = StatusAfk, TriggerTime) ->
    case utime:is_same_day(TriggerTime, DayUtime) of
        true -> NewDayBGold = DayBGold;
        false -> NewDayBGold = 0
    end,
    StatusAfk#status_afk{day_bgold = NewDayBGold}.

%% 获取下次触发时间戳
calc_next_trigger_time(Player, NowTime) ->
    #player_status{figure = #figure{lv = Lv}, afk = OldStatusAfk} = Player,
    #status_afk{afk_utime = AfkUtime, afk_stop_et = AfkStopEt} = recalc_status_afk(OldStatusAfk, NowTime),
    UnitTime = ?AFK_KV_UNIT_TIME,
    UnitTimeFactor = ?AFK_KV_UNIT_TIME_FACTOR,
    NewAfkUtime = max(AfkUtime, AfkStopEt),
    BaseAfk = data_afk:get_afk(Lv),
    if
        is_record(BaseAfk, base_afk) == false -> 0;
        % 间的配置等于0
        UnitTime == 0 orelse UnitTimeFactor == 0 -> 0;
        % 当前时间处于终止挂机时间戳无法触发
        NowTime =< AfkStopEt -> AfkStopEt+UnitTime*UnitTimeFactor;
        true ->
            NextTime = NewAfkUtime + UnitTime*UnitTimeFactor,
            if
                NextTime =< NowTime -> NowTime + UnitTime*UnitTimeFactor;
                true -> NextTime
            end
    end.

%% 发送消息
send_login_info(Player) ->
    #player_status{afk = StatusAfk, login_type = LoginType} = Player,
    #status_afk{
        afk_left_time = AfkLeftTime, no_goods_list = RewardL, off_lv = OffLv,
        off_cost_afk_time = OffCostAfkTime, back_time = BackTime, back_exp = BackExp, had_back_time = HadBackTime,
        all_afk_utime = AllAfkUTime
        } = StatusAfk,
    NextTime = calc_next_trigger_time(Player, utime:unixtime()),
    MaxBackCount = BackTime div ?AFK_KV_BACK_UNIT_TIME,
    UnitBackExp = ?IF(MaxBackCount==0, 0, BackExp div MaxBackCount),
    LeftBackCount = max(0, BackTime - HadBackTime) div ?AFK_KV_BACK_UNIT_TIME,
    LeftBackExp = UnitBackExp * LeftBackCount,
    ExpEffect = get_exp_effect(Player),
    {ok, BinData} = pt_132:write(13212, [LoginType, OffLv, OffCostAfkTime, RewardL, LeftBackCount, LeftBackExp,
        AfkLeftTime, NextTime, ExpEffect, AllAfkUTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 离线挂机赎回
back(#player_status{id = RoleId} = Player, Count) ->
    case check_back(Player, Count) of
        {false, ErrCode} -> AddExp = 0, ExpPlayer = Player;
        {true, UnitBackExp, NewHadBackTime} ->
            Cost = [{?TYPE_GOODS, ?AFK_KV_EXP_BACK_GOODS, Count}],
            Remark = lists:concat(["Count:", Count]),
            case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, afk_back, Remark) of
                {false, ErrCode, ExpPlayer} -> AddExp = 0;
                {true, CostPlayer, _CostBuyL} ->
                    ErrCode = ?SUCCESS,
                    #player_status{afk = StatusAfk} = CostPlayer,
                    NewStatusAfk = StatusAfk#status_afk{had_back_time = NewHadBackTime},
                    SavePlayer = CostPlayer#player_status{afk = NewStatusAfk},
                    AddExp = UnitBackExp*Count,
                    ExpPlayer = lib_player:add_exp(SavePlayer, AddExp, ?ADD_EXP_ONHOOK, []),
                    lib_log_api:log_afk_back(RoleId, Count, Cost, AddExp)
            end
    end,
    {ok, BinData} = pt_132:write(13213, [ErrCode, Count, AddExp]),
    lib_server_send:send_to_sid(ExpPlayer#player_status.sid, BinData),
    {ok, ExpPlayer}.

%% 检查是否能找回
check_back(Player, Count) ->
    #player_status{afk = StatusAfk} = Player,
    #status_afk{is_init = IsInit, back_time = BackTime, back_exp = BackExp, had_back_time = HadBackTime} = StatusAfk,
    MaxBackCount = BackTime div ?AFK_KV_BACK_UNIT_TIME,
    UnitBackExp = ?IF(MaxBackCount==0, 0, BackExp div MaxBackCount),
    HadBackCount = HadBackTime div ?AFK_KV_BACK_UNIT_TIME,
    LeftBackCount = max(0, BackTime - HadBackTime) div ?AFK_KV_BACK_UNIT_TIME,
    LeftBackExp = UnitBackExp * LeftBackCount,
    if
        IsInit == ?AFK_INIT_NO -> {false, ?FAIL};
        Count == 0 -> {false, ?FAIL};
        HadBackCount + Count > MaxBackCount -> {false, ?ERRCODE(err132_over_max_back_count)};
        LeftBackExp == 0 -> {false, ?ERRCODE(err132_no_left_back_exp)};
        true ->
            CostBackTime = Count * ?AFK_KV_BACK_UNIT_TIME,
            {true, UnitBackExp, CostBackTime+HadBackTime}
    end.

%% 离线挂机信息
send_info(Player) ->
    #player_status{afk = StatusAfk} = Player,
    #status_afk{afk_left_time = AfkLeftTime} = StatusAfk,
    NextTime = calc_next_trigger_time(Player, utime:unixtime()),
    {ok, BinData} = pt_132:write(13214, [AfkLeftTime, NextTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 每分钟的经验效率
send_exp_effect_info(Player) ->
    ExpEffect = get_exp_effect(Player),
    {ok, BinData} = pt_132:write(13215, [ExpEffect]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

get_exp_effect(Player) ->
    #player_status{figure = #figure{lv = Lv}, combat_power = Cp} = Player,
    BaseAfk = data_afk:get_afk(Lv),
    UnitTime = ?AFK_KV_UNIT_TIME,
    if
        is_record(BaseAfk, base_afk) == false -> 0;
        UnitTime == 0 -> 0;
        true ->
            Multi = ?ONE_MIN div UnitTime,
            round(Multi*calc_unit_exp(Player, BaseAfk, Cp)*lib_player:get_exp_add_ratio(Player, ?ADD_EXP_AFK))
    end.

%% 领取挂机奖励
receive_afk_reward(PS) ->
    #player_status{afk = StatusAfk, id = RoleId, figure = #figure{lv = OldLv}, exp = OldExp} = PS,
    #status_afk{no_goods_list = NoGoodsReward} = StatusAfk,
    case NoGoodsReward of
        [] ->
            LastPS = PS,
            Code = ?ERRCODE(err189_has_recieve);
        _ ->
            Sql = io_lib:format(?sql_role_afk_update_receive_reward, [RoleId]),
            db:execute(Sql),
            NewStatusAfk = StatusAfk#status_afk{all_afk_utime = 0, no_goods_list = []},
            %NewStatusAfk = StatusAfk#status_afk{all_afk_utime = 0, no_goods_list = [], back_exp = 0, back_time = 0, had_back_time = 0},
            case OldLv >= ?AFK_KV_AUTO_FUSION_LV of
                false ->
                    OtherProduce = #produce{type = afk_trigger, reward = NoGoodsReward},
                    LastPS = lib_goods_api:send_reward(PS#player_status{afk = NewStatusAfk}, OtherProduce);
                _ ->
                    F_split = fun({GoodsType, GoodsTypeId, _Num}) ->
                        if
                            GoodsType =/= ?TYPE_GOODS -> false;
                            true ->
                                case data_goods_type:get(GoodsTypeId) of
                                    #ets_goods_type{type = ?GOODS_TYPE_EQUIP, color = Color} when Color =< ?PURPLE ->
                                        lib_goods_check:get_fusion_exp_by_goods_type_id(GoodsTypeId)> 0;
                                    _ -> false
                                end
                        end
                    end,
                    {FusionList, RealReward} = lists:partition(F_split, NoGoodsReward),
                    NewPS = lib_goods_do:goods_fusion_no_cost(PS, [{GTypeId, GNum}||{_, GTypeId, GNum}<-FusionList]),
                    OtherProduce = #produce{type = afk_trigger, reward = RealReward},
                    LastPS = lib_goods_api:send_reward(NewPS#player_status{afk = NewStatusAfk}, OtherProduce)
            end,
            lib_task_api:receive_afk_times(LastPS),
            lib_log_api:log_afk(RoleId, 3, 0, 0, 0, 0, 0, 0, 0, 0, NoGoodsReward),
            Code = ?SUCCESS
    end,
    ThRatio = round(OldExp / data_exp:get(OldLv) * 1000),
    lib_server_send:send_to_uid(RoleId, pt_132, 13216, [Code, OldLv, ThRatio, NoGoodsReward]),
    send_login_info(LastPS),
    {ok, LastPS}.

send_exp_addition_info(Player) ->
    #player_status{id = RoleId, goods_buff_exp_ratio = BuffExpRatio, player_buff = PlayerBuff, magic_circle = MagicCircle, vip = VipStatus} = Player,
    BuffType = ?BUFF_EXP_KILL_MON,
    NowTime = utime:unixtime(),
    case lib_goods_buff:get_player_buff(PlayerBuff, BuffType) of
        #ets_buff{end_time = BuffEndTime} when NowTime =< BuffEndTime -> ok;
        _ -> BuffEndTime = 0
    end,
    #role_vip{vip_card_list = VipCardList, vip_type = VipType, vip_lv = VipLv} = VipStatus,
    #vip_card{end_time = VipEndTime} = ulists:keyfind(VipType, #vip_card.vip_type, VipCardList, #vip_card{}),
    VipExpRatio = lib_vip_api:get_vip_privilege(?MOD_BASE, ?MOD_BASE_EXP, VipType, VipLv),
    MountExpRatio = lib_mount:get_exp_ratio(Player),
    {MagicCircleExpRatio, CircleEndTime} = lib_magic_circle:get_exp_ratio_with_end_time(MagicCircle),
    RealBuffExpRatio = max(BuffExpRatio - lib_goods_buff:get_exp_buff_other(Player), 0),
    ExpAdditionList = [
        {?MOD_VIP, VipExpRatio * 100, VipEndTime}, {?MOD_MAGIC_CIRCLE, MagicCircleExpRatio, CircleEndTime},
        {?MOD_PARTNER, MountExpRatio, 0}, {?MOD_GOODS, round(RealBuffExpRatio * 10000), BuffEndTime}
    ],
    ?PRINT("ExpAdditionList:~p~n",[ExpAdditionList]),
    {ok, BinDate} = pt_132:write(13217, [ExpAdditionList]),
    lib_server_send:send_to_uid(RoleId, BinDate).

%% 切场景
change_scene(Player) ->
    % 目前切换场景不用处理(跟击杀怪物一致的)
    % #player_status{afk = StatusAfk} = Player,
    % #status_afk{is_init = IsInit, afk_utime = AfkUtime, afk_stop_et = AfkStopEt} = StatusAfk,
    % if
    %     % 没有初始化不修改
    %     IsInit == ?AFK_INIT_NO -> NewAfkUtime = AfkUtime;
    %     % 更新时间大于等于禁止时间,则更新时间不变
    %     AfkUtime >= AfkStopEt -> NewAfkUtime = AfkUtime;
    %     true -> NewAfkUtime = utime:unixtime()
    % end,
    % NewStatusAfk = StatusAfk#status_afk{afk_utime = NewAfkUtime, afk_stop_et = 0},
    % Player#player_status{afk = NewStatusAfk}.
    Player.

%% 击杀怪物
kill_mon(OldPlayer) ->
    % 目前击杀怪物不处理
    % Player = silent_trigger(OldPlayer),
    % #player_status{afk = StatusAfk} = Player,
    % NewStatusAfk = StatusAfk#status_afk{afk_stop_et = utime:unixtime() + ?AFK_KV_NO_KILL_MON_TIME},
    % NewPlayer = Player#player_status{afk = NewStatusAfk},
    % send_info(NewPlayer),
    % {ok, NewPlayer}.
    {ok, OldPlayer}.

%% 自动吞噬装备
%% 挂机获得的装备，如果是紫色及以下品质的，比自己身上的装备评分低的都直接吞噬
%% @return {IsDevour, #player_status{}}
auto_devour_equips(Player, [])-> {false, Player};
auto_devour_equips(#player_status{id = RoleId} = Player, UpGoodsList)->
    Gs = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = Gs,
    EquipsList = [GoodsInfo||#goods{id = GoodsId, type = Type, location = Location, color = Color} = GoodsInfo<-UpGoodsList,
        Type==?GOODS_TYPE_EQUIP,
        Location==?GOODS_LOC_BAG,
        lists:member(Color, [?WHITE, ?GREEN, ?BLUE, ?PURPLE]),
        dict:is_key(GoodsId, Dict)],
    case EquipsList of
        [] -> {false, Player};
        EquipsList ->
            MyEquipL = lib_goods_util:get_equip_list(RoleId, Dict),
            F = fun(#goods{equip_type = EquipType} = GoodsInfo, RatingMap) ->
                case lib_goods_util:load_goods_other(GoodsInfo) of
                    true -> Rating = GoodsInfo#goods.other#goods_other.rating;
                    false -> Rating = 0
                end,
                case maps:get(EquipType, RatingMap, false) of
                    false -> maps:put(EquipType, Rating, RatingMap);
                    OldRating -> maps:put(EquipType, min(Rating, OldRating), RatingMap)
                end
            end,
            RatingMap = lists:foldl(F, #{}, MyEquipL),
            {_DevourGoods, ExpGoods} = calc_auto_devour_equips(EquipsList, RatingMap, [], [], 0),
            GoodsNum = lists:sum([Num||{_GoodsId, Num}<-ExpGoods]),
            case GoodsNum > 0 of
                true ->
                    {IsDevour, NewPlayer} = lib_goods_do:goods_fusion_slient(Player, ExpGoods),
                    {IsDevour, NewPlayer};
                false ->
                    {false, Player}
            end
    end.

%% 计算10件吞噬的装备
%% 过滤掉戒指手镯
calc_auto_devour_equips([], _RatingMap, DevourGoods, ExpGoods, _Count) -> {DevourGoods, ExpGoods};
calc_auto_devour_equips(_EquipsList, _RatingMap, DevourGoods, ExpGoods, 50) -> {DevourGoods, ExpGoods};
calc_auto_devour_equips([#goods{equip_type = EquipType, id = GoodId, num = Num} = GInfo|EquipsList], RatingMap, DevourGoods, ExpGoods, Count) ->
    FusionExp = lib_goods_check:get_goods_fusion_exp(GInfo),
    MinRating = maps:get(EquipType, RatingMap, 0),
    case lib_goods_util:load_goods_other(GInfo) of
        true -> Rating = GInfo#goods.other#goods_other.rating;
        false -> Rating = 0
    end,
    if
        % 1:无吞噬经验
        % 2:评分大于等于当前装备类型不吞噬
        FusionExp =< 0 orelse Rating >= MinRating -> calc_auto_devour_equips(EquipsList, RatingMap, DevourGoods, ExpGoods, Count);
        EquipType == ?EQUIP_BRACELET orelse EquipType == ?EQUIP_RING ->
            calc_auto_devour_equips(EquipsList, RatingMap, DevourGoods, ExpGoods, Count);
        true ->
            NDevourGoods = [{GInfo, Num}|DevourGoods],
            NExpGoods    = [{GoodId, Num}|ExpGoods],
            calc_auto_devour_equips(EquipsList, RatingMap, NDevourGoods, NExpGoods, Count+1)
    end;
calc_auto_devour_equips([_|EquipsList], RatingMap, DevourGoods, ExpGoods, Count) ->
    calc_auto_devour_equips(EquipsList, RatingMap, DevourGoods, ExpGoods, Count).

% %% 自动吞噬装备
% %% 挂机获得的装备，如果是紫色及以下品质的，比自己身上的装备评分低的都直接吞噬
% %% @return {IsDevour, #player_status{}}
% auto_devour_ready_gain_equips(Player, [])-> {false, Player};
% auto_devour_ready_gain_equips(#player_status{id = RoleId} = Player, GoodsList)->

%% 获得玩家挂机信息
db_role_afk_select(RoleId) ->
    Sql = io_lib:format(?sql_role_afk_select, [RoleId]),
    db:get_row(Sql).

%% 存储玩家挂机信息
db_role_afk_replace(RoleId, StatusAfk) ->
    #status_afk{
        afk_left_time = AfkLeftTime, afk_utime = AfkUtime, no_goods_list = NoGoodsL,
        day_bgold = DayBGold, day_utime = DayUtime, exp_ratio_list = ExpRatioL,
        all_afk_utime = AllAfkUTime, back_time = BackTime, back_exp = BackExp, had_back_time = HadBackT
        } = StatusAfk,
    Sql = io_lib:format(?sql_role_afk_replace, [RoleId, AfkLeftTime, AfkUtime, util:term_to_bitstring(NoGoodsL),
        DayBGold, DayUtime, AllAfkUTime, util:term_to_bitstring(ExpRatioL), BackTime, BackExp, HadBackT]),
    db:execute(Sql).

db_role_afk_update_day_bgold(RoleId, DayBGold, DayUtime) ->
    Sql = io_lib:format(?sql_role_afk_update_day_bgold, [DayBGold, DayUtime, RoleId]),
    db:execute(Sql).

%% 模拟数据
gm_simulate_off(Player, BackTime) ->
    #player_status{figure = #figure{lv = Lv}, afk = StatusAfk} = Player,
    NewStatusAfk = StatusAfk#status_afk{
        no_goods_list = [{?TYPE_GOODS, 6001202, 10}, {?TYPE_COIN, 0, 1000}, {?TYPE_BGOLD, 0, 1000}, {?TYPE_EXP, 0, 10000}],
        off_lv = max(1, Lv-1),
        back_time = BackTime,
        back_exp = 100000,
        had_back_time = 0
        },
    NewPlayer = Player#player_status{login_type = ?NORMAL_LOGIN, afk = NewStatusAfk},
    send_login_info(NewPlayer),
    NewPlayer.

%% 数据模拟
gm_simulate_off(Player, AfkLeftTime, AfkUtime, DayBGold, DayUtime) ->
    #player_status{afk = StatusAfk} = Player,
    ExpRatioL = get_exp_buff(Player, utime:unixtime()),
    NewStatusAfk = StatusAfk#status_afk{
        is_init = ?AFK_INIT_NO, afk_left_time = AfkLeftTime, afk_utime = AfkUtime,
        day_bgold = DayBGold, day_utime = DayUtime, exp_ratio_list = ExpRatioL
        },
    NewPlayer = Player#player_status{login_type = ?NORMAL_LOGIN, afk = NewStatusAfk},
    {ok, NewPlayer2} = calc_off(NewPlayer),
    send_login_info(NewPlayer2),
    NewPlayer2.

%%
gm_simulate_off(Player, AfkLeftTime, AfkUtime, DayBGold, DayUtime, Ratio, RatioEndTime) ->
    #player_status{afk = StatusAfk} = Player,
    NewStatusAfk = StatusAfk#status_afk{
        is_init = ?AFK_INIT_NO, afk_left_time = AfkLeftTime, afk_utime = AfkUtime,
        exp_ratio_list = [{?BUFF_EXP_KILL_MON, Ratio / ?RATIO_COEFFICIENT, RatioEndTime}],
        day_bgold = DayBGold, day_utime = DayUtime
        },
    NewPlayer = Player#player_status{login_type = ?NORMAL_LOGIN, afk = NewStatusAfk},
    {ok, NewPlayer2} = calc_off(NewPlayer),
    send_login_info(NewPlayer2),
    NewPlayer2.

get_afk_max_time(Player) ->
    ?AFK_KV_MAX_TIME + lib_module_buff:get_offline_onhook_time(Player).
