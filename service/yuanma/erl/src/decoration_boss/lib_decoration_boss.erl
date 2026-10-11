%% ---------------------------------------------------------------------------
%% @doc lib_decoration_boss.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss
%% ---------------------------------------------------------------------------
-module(lib_decoration_boss).
-compile(export_all).

-include("server.hrl").
-include("decoration_boss.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("hero_halo.hrl").
-include("drop.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("constellation_equip.hrl").
-include("boss.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% gm关闭活动,出问题的游戏服调用
gm_clear_user(?MOD_DECORATION_BOSS, _) ->
    mod_decoration_boss_local:cheats_stop_act(?GM_CLOSE_MOD);
gm_clear_user(_, _) ->
    skip.
%% gm开活动
gm_open_act(?MOD_DECORATION_BOSS, _) ->
    mod_decoration_boss_local:cheats_stop_act(?GM_OPEN_MOD);
gm_open_act(_, _) -> skip.

%% 进入
trans_to_role(Player, BossId, ClsType, EnterType, SceneId) ->
    #player_status{id = RoleId, server_id = ServerId} = Player,
    #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
    #decoration_boss_role{
        role_id = RoleId, boss_id = BossId, cls_type = ClsType, enter_type = EnterType,
        server_id = ServerId, scene_id = SceneId, x = X, y = Y
        }.

%% 登录
login(#player_status{id = RoleId} = Player) ->
    case db_role_decoration_boss_select(RoleId) of
        [] -> UnfollowList = [], InBuff=0, BuffETime=0;
        [UnfollowListBin, InBuff, BuffETime] ->
            case util:bitstring_to_term(UnfollowListBin) of
                undefined -> UnfollowList = [];
                UnfollowList -> ok
            end
    end,
    StatusDecorationBoss = #status_decoration_boss{unfollow_list = UnfollowList, in_buff = InBuff, buff_etime = BuffETime},
    Player#player_status{status_decoration_boss = StatusDecorationBoss}.

%% 登出
logout(#player_status{id = RoleId, server_id = ServerId} = Player, _LogOutType) ->
    case lib_decoration_boss_api:is_decoration_boss_scene(Player) of
        true ->
            NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true,
                [{is_hurt_mon, 1}, {change_scene_hp_lim, 100}, {action_free, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}, {pk, {?PK_PEACE, true}}]),
            mod_decoration_boss_local:quit(RoleId, ServerId),
            {ok, NewPlayer};
        false ->
            {next, Player}
    end.

%% 使用Buff卡
use_buff_card(Ps, _GoodsTypeId) ->
    #player_status{status_decoration_boss = StatusDecBoss, id = RoleId} = Ps,
    Now = utime:unixtime(),
    case StatusDecBoss of
        #status_decoration_boss{in_buff = InBuff, buff_etime = OldBuffEndTime} ->
            IsSatisfy = Now >= OldBuffEndTime orelse InBuff == ?IsNotInBuff,
            if
                IsSatisfy ->
                    %% 今天四点
                    FourTimeStamp = utime:unixdate() + 4 * ?ONE_HOUR_SECONDS,
                    %% 今天4点后使用的，过期时间明天4点;今天4点前使用的，过期时间今天4点
                    NewBuffEndTime = ?IF(Now >= FourTimeStamp, FourTimeStamp + ?ONE_DAY_SECONDS, FourTimeStamp),
                    NewStatusDescBoss = StatusDecBoss#status_decoration_boss{in_buff = ?IsInBuff, buff_etime = NewBuffEndTime},
                    db_role_decoration_boss_buff(RoleId, NewStatusDescBoss),
                    NewPs = Ps#player_status{status_decoration_boss = NewStatusDescBoss},
                    pp_decoration_boss:handle(47101, NewPs, []),
                    {ok, only, NewPs};
                true ->
                    {false, ?ERRCODE(err471_buff_card_had_use)}
            end ;
        _ -> {false, ?ERRCODE(err471_buff_card_had_use)}
    end.


%% 发送消息
send_info(Player) ->
    #player_status{id = RoleId, status_decoration_boss = #status_decoration_boss{in_buff = InBuff, buff_etime = BuffEndTime}} = Player,
    IsInBuff = ?IF(InBuff == ?IsInBuff andalso BuffEndTime >= utime:unixtime(), 1, 0),
    Count = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_COUNT),
    AssistCount = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ASSIST_COUNT),
    BuyCount = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT),
    AddCount = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ADD_COUNT),
    mod_decoration_boss_local:send_info(RoleId, Count, AssistCount, BuyCount, AddCount, IsInBuff),
    ok.

%% 检查进入
enter_boss(Player, BossId, EnterType, ClsType, SceneId, IsHadAssist) ->
    case check_enter_boss(Player, BossId, EnterType, IsHadAssist) of
        {false, ErrCode} ->
            % ?MYLOG("hjhboss", "[BossId, EnterType, ClsType, SceneId, ErrCode]:~w ~n", [[BossId, EnterType, ClsType, SceneId, ErrCode]]),
            {ok, BinData} = pt_471:write(47102, [ErrCode, BossId, EnterType]),
            lib_server_send:send_to_uid(Player#player_status.id, BinData),
            {ok, Player};
        true ->
            % ?MYLOG("hjhboss", "[BossId, EnterType, ClsType, SceneId, IsHadAssist, ErrCode]:~w ~n",
            %     [[BossId, EnterType, ClsType, SceneId, IsHadAssist, 1]]),
            NewPlayer = do_enter_boss(Player, BossId, EnterType, ClsType, SceneId, IsHadAssist),
            {ok, NewPlayer}
    end.

%% @param EnterType 进入类型
check_enter_boss(Player, BossId, ?DECORATION_BOSS_ENTER_TYPE_NORMAL, _IsHadAssist) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    #base_decoration_boss{condition = Condition} = data_decoration_boss:get_boss(BossId),
    NeedLv = ?DECORATION_BOSS_KV_LV,
    CheckCond = check_boss_condition(Condition, Player),
    CheckPlayer = lib_player_check:check_list(Player, [action_free, is_transferable]),
    MaxCount = get_max_enter_count(Player),
    Count = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_COUNT),
    OpenDay = util:get_open_day(),
    NeedOpenDay = ?DECORATION_BOSS_KV_OPEN_DAY,
    if
        Lv < NeedLv -> {false, ?LEVEL_LIMIT};
        CheckCond =/= true -> CheckCond;
        _IsHadAssist =/= guild_assist andalso CheckPlayer =/= true -> CheckPlayer;
        Count >= MaxCount -> {false, ?ERRCODE(err471_enter_boss_count_not_enough)};
        OpenDay < NeedOpenDay -> {false, ?ERRCODE(err471_open_day_not_enough)};
        true -> true
    end;
check_enter_boss(Player, BossId, ?DECORATION_BOSS_ENTER_TYPE_ASSIST, IsHadAssist) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    #base_decoration_boss{condition = Condition} = data_decoration_boss:get_boss(BossId),
    NeedLv = ?DECORATION_BOSS_KV_LV,
    CheckCond = check_boss_condition(Condition, Player),
    CheckPlayer = lib_player_check:check_list(Player, [action_free, is_transferable]),
    MaxCount = get_max_assist_count(Player),
    Count = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ASSIST_COUNT),
    OpenDay = util:get_open_day(),
    NeedOpenDay = ?DECORATION_BOSS_KV_OPEN_DAY,
    if
        Lv < NeedLv -> {false, ?LEVEL_LIMIT};
        CheckCond =/= true -> CheckCond;
        CheckPlayer =/= true -> CheckPlayer;
        Count >= MaxCount andalso IsHadAssist == false -> {false, ?ERRCODE(err471_enter_boss_assist_count_not_enough)};
        OpenDay < NeedOpenDay -> {false, ?ERRCODE(err471_open_day_not_enough)};
        true -> true
    end;
check_enter_boss(Player, BossId, ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST, _IsHadAssist) ->
    #player_status{id = _RoleId, figure = #figure{lv = Lv}} = Player,
    #base_decoration_boss{condition = Condition} = data_decoration_boss:get_boss(BossId),
    NeedLv = ?DECORATION_BOSS_KV_LV,
    CheckCond = check_boss_condition(Condition, Player),
    CheckPlayer = lib_player_check:check_list(Player, [action_free, is_transferable]),
    OpenDay = util:get_open_day(),
    NeedOpenDay = ?DECORATION_BOSS_KV_OPEN_DAY,
    if
        Lv < NeedLv -> {false, ?LEVEL_LIMIT};
        CheckCond =/= true -> CheckCond;
        CheckPlayer =/= true -> CheckPlayer;
        OpenDay < NeedOpenDay -> {false, ?ERRCODE(err471_open_day_not_enough)};
        true -> true
    end;
check_enter_boss(_Player, _BossId, _Type, _IsHadAssist) ->
    {false, ?FAIL}.

%% 进入boss
do_enter_boss(#player_status{id = RoleId} = Player, BossId, EnterType, ClsType, SceneId, IsHadAssist) ->
    IsHadAssistInt = ?IF(IsHadAssist, 1, 0),
    lib_log_api:log_decoration_boss_enter(RoleId, EnterType, IsHadAssistInt, BossId),
    Role = trans_to_role(Player, BossId, ClsType, EnterType, SceneId),
    Player1 = lib_hero_halo:add_dun_buff(Player, ?BOSS_TYPE, ?BOSS_TYPE_DECORATION_BOSS),
    mod_decoration_boss_local:enter_boss(Role),
    NewPlayer = lib_player:soft_action_lock(Player1, ?ERRCODE(err471_not_change_scene_on_decoration_boss), 3),
    NewPlayer.

check_boss_condition([], _Player) -> true;
check_boss_condition([{lv, NeedLv}|T], Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    if
        Lv >= NeedLv -> check_boss_condition(T, Player);
        true -> {false, ?ERRCODE(err471_lv_not_enough)}
    end;
check_boss_condition([{open_day, NeedOpenDay}|T], Player) ->
    OpenDay = util:get_open_day(),
    if
        OpenDay >= NeedOpenDay -> check_boss_condition(T, Player);
        true -> {false, ?ERRCODE(err471_open_day_not_enough)}
    end;
check_boss_condition([{decoration_rating, NeedRating}|T], Player) ->
    Rating = lib_decoration:get_overall_rating(Player),
    if
        Rating >= NeedRating -> check_boss_condition(T, Player);
        true -> {false, ?ERRCODE(err471_decoration_rating_not_enough)}
    end;
check_boss_condition([{constellation_suit, NeedConstellationId, NeedNum}|T], Player) ->
    #player_status{constellation = ConstellationStatus} = Player,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    case lists:keyfind(NeedConstellationId, #constellation_item.id, Items) of
        #constellation_item{suit = Suit} ->
            SumNum = lists:sum([Num||{_Type, Num}<-Suit]),
            if
                SumNum >= NeedNum -> check_boss_condition(T, Player);
                true -> {false, ?ERRCODE(err471_constellation_suit_not_enough)}
            end;
        _ ->
            {false, ?ERRCODE(err471_constellation_suit_not_enough)}
    end;
check_boss_condition(_T, _Player) ->
    {false, ?FAIL}.

quit(#player_status{scene = SceneId} = Player) ->
    IsBossScene = lib_decoration_boss_api:is_decoration_boss_scene(SceneId),
    if
        IsBossScene == false -> ErrCode = ?ERRCODE(err471_not_decoration_boss_scene), IsOut = false;
        true -> {IsOut, ErrCode} = lib_scene:is_transferable_out(Player)
    end,
    case IsOut of
        true ->
            #player_status{id = RoleId, server_id = ServerId} = Player,
            Player1 = lib_hero_halo:remove_dun_buff(Player, ?BOSS_TYPE, ?BOSS_TYPE_DECORATION_BOSS),
            NewPlayer = lib_scene:change_scene(Player1, 0, 0, 0, 0, 0, true,
                [{is_hurt_mon, 1}, {change_scene_hp_lim, 100}, {action_free, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}, {pk, {?PK_PEACE, true}}]),
            mod_decoration_boss_local:quit(RoleId, ServerId);
        false ->
            NewPlayer = Player
    end,
    % ?MYLOG("hjhboss", "[ErrCode]:~w ~n", [[ErrCode]]),
    {ok, BinData} = pt_471:write(47103, [ErrCode]),
    lib_server_send:send_to_uid(NewPlayer#player_status.id, BinData),
    {ok, NewPlayer}.

%% 进入特殊boss
enter_sboss(Player, SBossId, SceneId, EnterType) ->
    case check_enter_sboss(Player) of
        {false, ErrCode} ->
            {ok, BinData} = pt_471:write(47110, [ErrCode]),
            lib_server_send:send_to_uid(Player#player_status.id, BinData),
            {ok, Player};
        true ->
            Role = trans_to_role(Player, SBossId, ?CLS_TYPE_CENTER, EnterType, SceneId),
            mod_decoration_boss_local:enter_sboss(Role),
            NewPlayer = lib_player:soft_action_lock(Player, ?ERRCODE(err471_not_change_scene_on_decoration_boss), 3),
            {ok, NewPlayer}
    end.

check_enter_sboss(Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    NeedLv = ?DECORATION_BOSS_KV_LV,
    OpenDay = util:get_open_day(),
    NeedOpenDay = ?DECORATION_BOSS_KV_OPEN_DAY,
    CheckPlayer = lib_player_check:check_list(Player, [action_free, is_transferable]),
    if
        Lv < NeedLv -> {false, ?LEVEL_LIMIT};
        OpenDay < NeedOpenDay -> {false, ?ERRCODE(err471_open_day_not_enough)};
        CheckPlayer =/= true -> CheckPlayer;
        true -> true
    end.

%% 获得最大进入次数
get_max_enter_count(Player) ->
    #player_status{id = RoleId, figure = #figure{vip = VipLv, vip_type = VipType}} = Player,
    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_COUNT, VipType, VipLv),
    BuyCount = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT),
    AddCount = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ADD_COUNT),
    VipAddCount + BuyCount + AddCount.

%% 获得最大辅助次数
get_max_assist_count(Player) ->
    #player_status{figure = #figure{vip = VipLv, vip_type = VipType}} = Player,
    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ASSIST_COUNT, VipType, VipLv),
    VipAddCount.

%% 获得最大购买次数
get_max_buy_count(Player) ->
    #player_status{figure = #figure{vip = VipLv, vip_type = VipType}} = Player,
    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT, VipType, VipLv),
    VipAddCount.

%% 购买
buy(#player_status{id = RoleId} = Player) ->
    case check_buy(Player) of
        {false, ErrCode} -> PlayerAfBuy = Player;
        {true, Cost} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, decoration_boss_buy, "") of
                {false, ErrCode, PlayerAfBuy} -> ok;
                {true, PlayerAfBuy} ->
                    ErrCode = ?SUCCESS,
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, buy_dun, [26, 1]),
                    mod_daily:increment(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT)
            end
    end,
    {ok, BinData} = pt_471:write(47104, [ErrCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    %% 更新一下协助boss的状态
    lib_guild_assist:update_bl_state(PlayerAfBuy).

check_buy(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    NeedLv = ?DECORATION_BOSS_KV_LV,
    MaxCount = get_max_buy_count(Player),
    Count = mod_daily:get_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_BUY_COUNT),
    OpenDay = util:get_open_day(),
    NeedOpenDay = ?DECORATION_BOSS_KV_OPEN_DAY,
    if
        Lv < NeedLv -> {false, ?LEVEL_LIMIT};
        Count >= MaxCount -> {false, ?ERRCODE(err471_buy_count_not_enough)};
        OpenDay < NeedOpenDay -> {false, ?ERRCODE(err471_open_day_not_enough)};
        true ->
            Cost = ?DECORATION_BOSS_KV_BUY_COST,
            {true, Cost}
    end.

%% 关注
follow(Player, BossId, IsFollow) ->
    #player_status{id = RoleId, sid = Sid, status_decoration_boss = StatusDecorationBoss} = Player,
    #status_decoration_boss{unfollow_list = UnfollowList} = StatusDecorationBoss,
    BaseBoss = data_decoration_boss:get_boss(BossId),
    if
        is_record(BaseBoss, base_decoration_boss) == false ->
            ErrorCode = ?ERRCODE(err471_no_boss_cfg),
            NewPlayer = Player;
        true ->
            ErrorCode = ?SUCCESS,
            case IsFollow == 1 of
                true -> NewUnfollowList = lists:delete(BossId, UnfollowList);
                false -> NewUnfollowList = lists:usort([BossId|UnfollowList])
            end,
            NewStatusDecorationBoss = StatusDecorationBoss#status_decoration_boss{unfollow_list = NewUnfollowList},
            NewPlayer = Player#player_status{status_decoration_boss = NewStatusDecorationBoss},
            db_role_decoration_boss_follow(RoleId, NewStatusDecorationBoss)
    end,
    % ?MYLOG("hjhboss", "[ErrorCode, BossId, IsFollow]:~p ~n", [[ErrorCode, BossId, IsFollow]]),
    {ok, BinData} = pt_471:write(47106, [ErrorCode, BossId, IsFollow]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

%% 离开定时器
leave_ref(Player, _BossId) ->
    immediate_quit(Player).

%% 发送普通boss奖励

% 不是首次攻击玩家、正常进入状态, 且没有伤害,不结算
send_boss_reward(#player_status{id = RoleId} = Player, _MonArgs, ?DECORATION_BOSS_ENTER_TYPE_NORMAL, FirstId, _FirstServerId, Hurt) when
        RoleId =/= FirstId andalso Hurt == 0 ->
    {ok, Player};
% 协助模式,必须是本服玩家
% 协助模式新规则： 只要玩家属于协助状态进入，Boss挂的时候在场景，就算协助完成
send_boss_reward(#player_status{id = RoleId} = Player, #mon_args{mid = BossId} = _MonArgs, EnterType = ?DECORATION_BOSS_ENTER_TYPE_ASSIST, _FirstId, _FirstServerId, _Hurt) ->
    % 协助奖励
    IsBelong = 0,
    SingleReward = ?DECORATION_BOSS_KV_ASSIS_REWARD,
    Remark = lists:concat(["BossId:", BossId, "IsBelong:", IsBelong]),
    Produce = #produce{type = decoration_boss_assist, reward = SingleReward, remark = Remark},
    {ok, _, SinglePlayer, SingleUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
    SingleSeeRewardL = lib_goods_api:make_see_reward_list(SingleReward, SingleUpGoodsL),
    mod_daily:increment(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ASSIST_COUNT),
    %send_boss_tv(SingleUpGoodsL, SinglePlayer, _MonArgs),  %协助模式不发传闻了
    % ?MYLOG("hjhboss", "send_boss_reward RoleId:~p IsBelong:~p SingleSeeRewardL:~p ~n", [RoleId, IsBelong, SingleSeeRewardL]),
    {ok, BinData} = pt_471:write(47113, [IsBelong, [{?REWARD_SOURCE_ASSIST, SingleSeeRewardL}]]),
    lib_server_send:send_to_sid(SinglePlayer#player_status.sid, BinData),
    lib_log_api:log_decoration_boss_reward(RoleId, EnterType, BossId, IsBelong, SingleReward),
    {ok, SinglePlayer};
% 公会协助模式，不用处理(在通用协助那里处理了mod_guild_assist)
send_boss_reward(#player_status{id = _RoleId} = Player, _MonArgs, ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST, _FirstId, _FirstServerId, _Hurt) ->
    {ok, Player};
send_boss_reward(#player_status{id = RoleId, status_decoration_boss = StatusDecBoss} = Player, #mon_args{mid = BossId, lv = BossLv} = MonArgs, EnterType, FirstId, _FirstServerId, _Hurt) ->
    case EnterType == ?DECORATION_BOSS_ENTER_TYPE_NORMAL of
        true ->
            lib_task_api:kill_boss(Player, ?MON_SYS_BOSS_TYPE_DECORATION, BossLv),
            lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_DECORATION_BOSS, 1, 1),
            mod_daily:increment(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_COUNT),
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_DECORATION_BOSS, 0),
            lib_guild_assist:update_bl_state(Player);
        false -> skip
    end,
    %% 判断是否有双倍掉落卡状态
    Now = utime:unixtime(),
    #status_decoration_boss{in_buff = InBuff, buff_etime = BuffETime} = StatusDecBoss,
    IsDouble = InBuff == ?IsInBuff andalso BuffETime >= Now,
    #base_decoration_boss{boss_type = BossType} = data_decoration_boss:get_boss(BossId),
    IsShare = BossType == ?BOSS_TYPE_SHARE,
    if
        not IsShare -> %% 掠夺Boss
            IsBelong = ?IF(FirstId == RoleId, 1, 0),
            SingleReward = lib_drop_reward:calc_drop_reward(Player, MonArgs, ?ALLOC_SINGLE_2),
            Remark = lists:concat(["BossId:", BossId, "IsBelong:", IsBelong]),
            Produce = #produce{type = decoration_boss_join, reward = SingleReward, remark = Remark},
            {ok, _, SinglePlayerTmp, SingleUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
            SingleSeeRewardL = lib_goods_api:make_see_reward_list(SingleReward, SingleUpGoodsL),
            send_boss_tv(SingleUpGoodsL, SinglePlayerTmp, MonArgs),
            lib_decoration_boss_api:add_drop_log(SinglePlayerTmp, MonArgs, SingleSeeRewardL, SingleUpGoodsL),
            {SinglePlayer, DoubleReward, DoubleSeeRewardL} = deal_double_drop(SinglePlayerTmp, IsDouble, decoration_boss_join, Remark, MonArgs, ?ALLOC_SINGLE_2),
            lib_log_api:log_decoration_boss_reward(RoleId, EnterType, BossId, IsBelong, SingleReward ++ DoubleReward),
            case IsBelong of
                0 ->
                    PackageData = [IsBelong, InBuff, [{?REWARD_SOURCE_JOIN, SingleSeeRewardL}], [{?REWARD_SOURCE_JOIN, DoubleSeeRewardL}]],
                    LastPlayer = SinglePlayer;
                1 ->
                    % 归属额外奖励
%%                    BlRewardTmp = lib_drop_reward:calc_drop_reward(SinglePlayer, MonArgs, ?ALLOC_HURT_EQUAL),
                    BlReward = lib_drop_reward:calc_drop_reward(SinglePlayer, MonArgs, ?ALLOC_BLONG),
                    BlProduce = #produce{type = decoration_boss_bl, reward = BlReward, remark = Remark},
                    {ok, _, BlPlayerTmp, BlUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(SinglePlayer, BlProduce),
                    BlSeeRewardL = lib_goods_api:make_see_reward_list(BlReward, BlUpGoodsL),
                    send_boss_tv(BlUpGoodsL, BlPlayerTmp, MonArgs),
                    lib_decoration_boss_api:add_drop_log(BlPlayerTmp, MonArgs, BlSeeRewardL, BlUpGoodsL),
                    {BlPlayer, BlDRwL, BlDSeeRwL} = deal_double_drop(BlPlayerTmp, IsDouble, decoration_boss_bl, Remark, MonArgs, ?ALLOC_BLONG),
                    lib_log_api:log_decoration_boss_reward(RoleId, EnterType, BossId, IsBelong, BlReward ++ BlDRwL),
                    % 事件
                    CallbackData = #callback_boss_kill{boss_type = ?BOSS_TYPE_DECORATION_BOSS, boss_id = BossId},
                    lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallbackData),
                    lib_achievement_api:boss_decoration_event(BlPlayer, BossId),
                    PackageData = [IsBelong, InBuff,
                        [{?REWARD_SOURCE_JOIN, SingleSeeRewardL}, {?REWARD_SOURCE_DROP, BlSeeRewardL}],
                        [{?REWARD_SOURCE_JOIN, DoubleSeeRewardL}, {?REWARD_SOURCE_DROP, BlDSeeRwL}]],
                    LastPlayer = BlPlayer
            end;
        true ->     %% 共享Boss
            IsBelong = 1,
            ShareReward = lib_drop_reward:calc_drop_reward(Player, MonArgs, ?ALLOC_HURT_EQUAL),
            Remark = lists:concat(["BossId:", BossId, "IsBelong:", IsBelong]),
            Produce = #produce{type = decoration_boss_bl, reward = ShareReward, remark = Remark},
            {ok, _, SharePlayerTmp, ShareUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
            ShareSeeRewardL = lib_goods_api:make_see_reward_list(ShareReward, ShareUpGoodsL),
            send_boss_tv(ShareUpGoodsL, SharePlayerTmp, MonArgs),
            lib_decoration_boss_api:add_drop_log(SharePlayerTmp, MonArgs, ShareSeeRewardL, ShareUpGoodsL),
            {SharePlayer, ShareDRwL, ShareDSeeRwL} = deal_double_drop(SharePlayerTmp, IsDouble, decoration_boss_bl, Remark, MonArgs, ?ALLOC_HURT_EQUAL),
            lib_log_api:log_decoration_boss_reward(RoleId, EnterType, BossId, IsBelong, ShareReward ++ ShareDRwL),
            % 事件
            CallbackData = #callback_boss_kill{boss_type = ?BOSS_TYPE_DECORATION_BOSS, boss_id = BossId},
            lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallbackData),
            lib_achievement_api:boss_decoration_event(SharePlayer, BossId),
            PackageData = [IsBelong, InBuff, [{?REWARD_SOURCE_DROP, ShareSeeRewardL}], [{?REWARD_SOURCE_DROP, ShareDSeeRwL}]],
            LastPlayer = SharePlayer
    end,
    {ok, BinData} = pt_471:write(47113, PackageData),
    lib_server_send:send_to_sid(LastPlayer#player_status.sid, BinData),
    NewStatusDecBoss = StatusDecBoss#status_decoration_boss{in_buff = ?IsNotInBuff, buff_etime = 0},
    ?IF(IsDouble, db_role_decoration_boss_buff(RoleId, NewStatusDecBoss), skip),
    {ok, LastPlayer#player_status{status_decoration_boss = NewStatusDecBoss}}.

%% 处理双倍掉落卡
%% （发送到背包，返回奖励和物品信息，客户端需要判断哪些物品的双倍的，并且由于奇怪的掉落规则就这样分开写了）
deal_double_drop(Player, true, ProduceType, Remark, MonArgs, DropType) ->
    Reward = lib_drop_reward:calc_drop_reward(Player, MonArgs, DropType),
    Produce = #produce{type = ProduceType, reward = Reward, remark = Remark},
    {ok, _, NewPlayer, UpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
    SeeRewardL = lib_goods_api:make_see_reward_list(Reward, UpGoodsL),
    send_boss_tv(UpGoodsL, NewPlayer, MonArgs),
    lib_decoration_boss_api:add_drop_log(NewPlayer, MonArgs, SeeRewardL, UpGoodsL),
    {NewPlayer, Reward, SeeRewardL};
deal_double_drop(Player, _IsDouble, _ProduceType, _Remark, _MonArgs, _DropType) ->
    {Player, [], []}.

%% 离开定时器
sleave_ref(Player) ->
    immediate_quit(Player).

%% 发送特殊boss奖励
send_sboss_reward(RoleId, IsBelong, MonArgs) when is_integer(RoleId) ->
    % ?MYLOG("hjhboss", "send_sboss_reward RoleId:~p IsBelong:~p ~n", [RoleId, IsBelong]),
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, send_sboss_reward, [IsBelong, MonArgs]);
        false when IsBelong == 1 ->
            #mon_args{mid = BossId, lv = BossLv} = MonArgs,
            case lib_role:get_role_show(RoleId) of
                #ets_role_show{figure = #figure{career = Career}} ->
                    case lib_drop_reward:calc_drop_reward(Career, BossId, BossLv, ?ALLOC_SINGLE) of
                        [] ->
                            ?ERR("send_sboss_reward RoleId:~p IsBelong:~p BossId:~p BossLv:~p ~n", [RoleId, IsBelong, BossId, BossLv]),
                            Reward = [];
                        Reward ->
                            ok
                    end,
                    SumReward = ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD ++ Reward,
                    lib_mail_api:send_sys_mail([RoleId], utext:get(4710001), utext:get(4710002), SumReward),
                    lib_log_api:log_decoration_sboss_reward(RoleId, IsBelong, ?REWARD_SOURCE_JOIN, ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD),
                    lib_log_api:log_decoration_sboss_reward(RoleId, IsBelong, ?REWARD_SOURCE_DROP, Reward);
                _ ->
                    ?ERR("send_sboss_reward no role RoleId:~p IsBelong:~p BossId:~p BossLv:~p ~n", [RoleId, IsBelong, BossId, BossLv])
            end;
        _ ->
            lib_log_api:log_decoration_sboss_reward(RoleId, 0, ?REWARD_SOURCE_JOIN, ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD),
            lib_mail_api:send_sys_mail([RoleId], utext:get(4710003), utext:get(4710004), ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD)
    end;
send_sboss_reward(#player_status{id = RoleId, scene = SceneId} = Player, IsBelong = 0, #mon_args{lv = Lv}) ->
    RewardL = ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD,
    case lib_decoration_boss_api:is_sboss_scene(SceneId) of
        true ->
            Remark = lists:concat(["Lv:", Lv, "IsBelong:", IsBelong]),
            Produce = #produce{type = decoration_sboss_join, reward = RewardL, remark = Remark},
            {ok, _, NewPlayer, UpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
            SeeRewardList = lib_goods_api:make_see_reward_list(RewardL, UpGoodsL),
            {ok, BinData} = pt_471:write(47113, [IsBelong, [{?REWARD_SOURCE_JOIN, SeeRewardList}], []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false ->
            lib_mail_api:send_sys_mail([RoleId], utext:get(4710003), utext:get(4710004), RewardL),
            NewPlayer = Player
    end,
    lib_log_api:log_decoration_sboss_reward(RoleId, IsBelong, ?REWARD_SOURCE_JOIN, RewardL),
    {ok, NewPlayer};
send_sboss_reward(#player_status{id = RoleId, scene = SceneId} = Player, IsBelong, #mon_args{lv = Lv} = MonArgs) ->
    JoinReward = ?DECORATION_BOSS_KV_SBOSS_JOIN_REWARD,
    DropReward = lib_drop_reward:calc_drop_reward(Player, MonArgs, ?ALLOC_SINGLE),
    RewardL = lib_goods_api:make_reward_unique(JoinReward ++ DropReward),
    % ?MYLOG("hjhboss", "send_sboss_reward RoleId:~p RewardL:~p ~n", [RoleId, RewardL]),
    case lib_decoration_boss_api:is_sboss_scene(SceneId) of
        true ->
            % 参与奖
            Remark = lists:concat(["Lv:", Lv, "IsBelong:", IsBelong]),
            JoinProduce = #produce{type = decoration_sboss_join, reward = JoinReward, remark = Remark},
            {ok, _, PlayerAfJoin, JoinUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, JoinProduce),
            JoinSeeReward = lib_goods_api:make_see_reward_list(JoinReward, JoinUpGoodsL),
            % 掉落
            DropProduce = #produce{type = decoration_sboss_bl, reward = DropReward, remark = Remark},
            {ok, _, PlayerAfDrop, DropUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(PlayerAfJoin, DropProduce),
            DropSeeReward = lib_goods_api:make_see_reward_list(DropReward, DropUpGoodsL),
            {ok, BinData} = pt_471:write(47113, [IsBelong, [{?REWARD_SOURCE_DROP, DropSeeReward}, {?REWARD_SOURCE_JOIN, JoinSeeReward}], []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            send_boss_tv(DropUpGoodsL, PlayerAfDrop, MonArgs),
            lib_decoration_boss_api:add_drop_log(PlayerAfDrop, MonArgs, DropSeeReward, DropUpGoodsL);
        false ->
            lib_mail_api:send_sys_mail([RoleId], utext:get(4710001), utext:get(4710002), RewardL),
            DropSeeReward = lib_goods_api:make_see_reward_list(DropReward, []),
            lib_decoration_boss_api:add_drop_log(Player, MonArgs, DropSeeReward, []),
            PlayerAfDrop = Player
    end,
    lib_log_api:log_decoration_sboss_reward(RoleId, IsBelong, ?REWARD_SOURCE_JOIN, JoinReward),
    lib_log_api:log_decoration_sboss_reward(RoleId, IsBelong, ?REWARD_SOURCE_DROP, DropReward),
    {ok, PlayerAfDrop}.

%% 检查复活
check_revive(Player, Type) ->
    #player_status{scene = SceneId} = Player,
    IsSBossScene = lib_decoration_boss_api:is_sboss_scene(SceneId),
    IsNorBossScene = lib_decoration_boss_api:is_normal_boss_scene(SceneId),
    if
        IsSBossScene ->
            TypeList = [?REVIVE_GOLD],
            case lists:member(Type, TypeList) of
                true -> true;
                false -> {false, 10}
            end;
        IsNorBossScene ->
            TypeList = [?REVIVE_GOLD, ?REVIVE_ORIGIN],
            case lists:member(Type, TypeList) of
                true -> true;
                false -> {false, 10}
            end;
        true ->
            true
    end.

%% 死亡定时器
die_ref(Player) ->
    #player_status{scene = SceneId} = Player,
    case lib_decoration_boss_api:is_normal_boss_scene(SceneId) of
        true ->
            {ok, NewPlayer} = lib_revive:revive_without_check(Player, ?REVIVE_ORIGIN, []),
            NewPlayer;
        false ->
            immediate_quit(Player)
    end.

%% 发送传闻
send_boss_tv([], _Player, _MonArgs) -> skip;
send_boss_tv([#goods{goods_id = GoodsTypeId} = Goods|GoodsL], #player_status{id = RoleId, figure = #figure{name = _Name}} = Player, MonArgs) ->
    case lists:member(GoodsTypeId, ?DECORATION_BOSS_KV_DROP_LOG_LIST) of %orelse GoodsTypeId > 0 of
        true ->
            case Goods of
                #goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
                    ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []);
                _ ->
                    Rating = 0, ExtraAttr = []
            end,
            #mon_args{mid = MonId, scene = Scene} = MonArgs,
            MonName = lib_mon:get_name_by_mon_id(MonId),
            SceneName = lib_scene:get_scene_name(Scene),
            WrapRoleName = lib_player:get_wrap_role_name(Player),
            % 随机一个传闻
            case urand:list_rand(?DECORATION_BOSS_KV_TV_LIST) of
                {ModuleId, Id} ->
                    lib_chat:send_TV({all}, ModuleId, Id, [WrapRoleName, RoleId, SceneName, MonName, GoodsTypeId, Rating, util:term_to_string(ExtraAttr)]);
                _ ->
                    skip
            end;
        false ->
            skip
    end,
    send_boss_tv(GoodsL, Player, MonArgs).

%% 小跨服区域开始重置
zone_reset_start(Player) ->
    immediate_quit(Player).

%% 直接退出
%% @return #player_status{}
immediate_quit(Player) ->
    #player_status{scene = SceneId} = Player,
    case lib_decoration_boss_api:is_decoration_boss_scene(SceneId) of
        true ->
            Args = [{group, 0}, {is_hurt_mon, 1}, {action_free, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}, {change_scene_hp_lim, 1}],
            lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, Args);
        false ->
            Player
    end.

%% 使用次数物品
use_count_goods(Player, _GoodsTypeId, GoodsNum) ->
    NewPlayer = add_count(Player, GoodsNum),
    {ok, NewPlayer}.

add_count(#player_status{id = RoleId} = Player, AddCount) ->
    mod_daily:plus_count(RoleId, ?MOD_DECORATION_BOSS, ?DAILY_DECORATION_BOSS_ADD_COUNT, AddCount),
    send_info(Player),
    Player.

%% 查询幻饰boss的玩家信息
db_role_decoration_boss_select(RoleId) ->
    Sql = io_lib:format(?sql_role_decoration_boss_select, [RoleId]),
    db:get_row(Sql).

%% 插入幻饰boss的玩家信息
db_role_decoration_boss_follow(RoleId, StatusDecorationBoss) ->
    #status_decoration_boss{unfollow_list = UnfollowList} = StatusDecorationBoss,
    Sql = io_lib:format(?sql_role_decoration_boss_follow_update, [util:term_to_bitstring(UnfollowList), RoleId]),
    db:execute(Sql).

db_role_decoration_boss_buff(RoleId, StatusDecorationBoss) ->
    #status_decoration_boss{in_buff = InBuff, buff_etime = BuffETime, unfollow_list = UFList} = StatusDecorationBoss,
    Sql = io_lib:format(?sql_role_decoration_boss_buff_update, [RoleId, InBuff, BuffETime, util:term_to_string(UFList)]),
    db:execute(Sql).
