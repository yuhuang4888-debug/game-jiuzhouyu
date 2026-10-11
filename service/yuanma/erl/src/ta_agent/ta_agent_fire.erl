%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% ta上报事件的触发接口封装
%%% @end
%%% @since 2021-05-24
%%% -------------------------------------------------------
-module(ta_agent_fire).
-export([
        online_track/0                  % 在线人数上报
        ,online_track/2                 % 在线人数上报
        ,create_role/1                  % 创角事件
        ,role_login/2                   % 登录事件
        ,role_logout/3                  % 登出事件
        ,online_simu_logout/0           % 虚拟登出
        ,role_simu_logout/1             % 虚拟登出
        % ,role_shop_by/2                 % 商城购买
        % ,order_finish/3                 % 订单完成
    ]).

-compile(export_all).

-include("predefine.hrl").
-include("server.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("shop.hrl").
-include("def_fun.hrl").
-include("rec_recharge.hrl").
-include("task.hrl").
-include("def_daily.hrl").
-include("activitycalen.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("welfare.hrl").
-include("guild.hrl").
-include("daily.hrl").
-include("boss.hrl").
-include("weekly_card.hrl").
-include("marriage.hrl").
-include("rec_event.hrl").
-include("investment.hrl").
-include("vip.hrl").
-include("common_rank.hrl").
-include("mount.hrl").

%% 注意事项
%%  1、 零点和四点的上传数据，要做延迟，要避开这个时间点，防止影响到结算。

%% 在线人数上报（特殊接口）
%% 【由定时器定时调用即可触发定期上报】
online_track() ->
    {OnlineCount, HostingNum} = lib_php_api:get_online_num(),
    online_track(OnlineCount, HostingNum).

%% 在线人数上报
%% 定期上报服务器的在线人数状况，
%% 由于TA系统中的事件以角色为单位，而这个在线人数并不是角色的属性或行为，
%% 所以这里实际上是通过虚拟一个用户来描述服务器的状态数据
%% （以游戏服编号为#account_id即可区分不同游戏服）
online_track(OnlineCount, HostingNum) ->
    case config:get_server_id() of
        ServerId when ServerId > 0 ->
            ServerIdBinStr = integer_to_binary(ServerId),
            IpBinStr = <<"127.0.0.1">>,
            Properties = #{
                server_id => ServerIdBinStr
                ,amount => OnlineCount
                ,hosting_amount => HostingNum
            },
            ta_agent:track_raw(ServerId, online_count, IpBinStr, Properties);
        _ ->
            ignore
    end.

%% 创角事件（特殊逻辑，缺少#player_status{}的情况下可参考此接口）
create_role([Id, Ip, Accname, Name, SimulatorFlag, IsChooseCareer, IsChangeName,
        Source, Career, TaGuestId, TaDeviceId]) ->
    IpBinStr = util:ip2bin(Ip),
    Now = utime:unixtime(),
    Properties = #{
        % 公共属性
        accname => Accname
        ,vip_level => 0
        ,role_level => 1
        ,current_power => 0
        ,total_pay_amount => 0
        ,is_month_card => false
        ,weekly_card_lv => 0
        ,is_weekly_card => false
        % 事件特殊属性
        ,create_ip => IpBinStr
        ,name => Name
        ,is_simulator => SimulatorFlag
    },
    UserProperties = #{
        % 公共属性
        accname => Accname
        ,vip_level => 0
        ,role_level => 1
        ,current_power => 0
        ,total_pay_amount => 0
        ,is_month_card => false
        ,weekly_card_lv => 0
        ,is_weekly_card => false
        % 用户属性
        ,channel => Source
        ,register_time => Now
        ,origin_server => config:get_server_id()
        ,server_open_time => util:get_open_time()
        ,career => Career
        ,create_role_time => Now
        ,reg_ip => IpBinStr
        ,is_choose_career => IsChooseCareer
        ,is_change_name => IsChangeName
        ,server_type => var_server_type(config:get_server_type())
    },
    TaSpclData = ta_agent:get_ta_spcl_data(TaGuestId, TaDeviceId),
    ta_agent:track_raw(Id, create_role, IpBinStr, Properties, TaSpclData, normal, Now),
    ta_agent:user_set_once_raw(Id, undefined, IpBinStr, UserProperties, TaSpclData, Now).

%% 登录事件
role_login(#player_status{login_type = ?ONHOOK_AGENT_LOGIN}, _Channel) ->
    %% 离线托管/伪在线不需要上报数据
    ignore;
role_login(PS, Channel) ->
    #player_status{
        gold = Gold, bgold = BGold,
        ip = Ip, network_type = NetworkType, server_id = ServerId,
        reconnect = Reconnect, last_login_time = LastLoginTime
    } = PS,
    ModulePowerL = lib_player:ta_get_module_power(PS),
    MountTypePowerL = proplists:get_value(mount_power, ModulePowerL, []),
    OtherProperties = #{
        login_type => val_login_type(Reconnect)
        ,login_ip => Ip
        ,network_type => val_network(NetworkType)
        ,current_gold => Gold
        ,current_bgold => BGold
        ,server_id => ServerId
        ,channel => Channel
        ,equip_power => proplists:get_value(?MOD_EQUIP, ModulePowerL, 0)
        ,seal_power => proplists:get_value(?MOD_SEAL, ModulePowerL, 0)
        ,mount_power => proplists:get_value(?MOUNT_ID, MountTypePowerL, 0)
        ,mate_power => proplists:get_value(?MATE_ID, MountTypePowerL, 0)
        ,divine_rune => proplists:get_value(?MOD_DRAGON, ModulePowerL, 0)
        ,soul_rune => proplists:get_value(?MOD_RUNE, ModulePowerL, 0)
        ,resonance_power => proplists:get_value(?MOD_RESONANCE_POWER, ModulePowerL, 0)
        ,atlas_power => proplists:get_value(?MOD_MON_PIC, ModulePowerL, 0)
        ,wing_power => proplists:get_value(?FLY_ID, MountTypePowerL, 0)
        ,divine_power => proplists:get_value(?HOLYORGAN_ID, MountTypePowerL, 0)
        ,omori_power => proplists:get_value(?ARTIFACT_ID, MountTypePowerL, 0)
        ,mirage_power => proplists:get_value(?MOD_EUDEMONS, ModulePowerL, 0)
        ,seance_power => proplists:get_value(?MOD_GOD, ModulePowerL, 0)
    },
    ta_agent:track(PS, role_login, OtherProperties, normal, LastLoginTime),
    % 部分用户数据上传
    UserProperties = #{
        server_type => var_server_type(config:get_server_type())
    },
    ta_agent:user_set(PS, UserProperties).

%% 登出事件
role_logout(#player_status{online = Online}, _NowTime, _LogoutType) when Online == ?ONLINE_OFF_ONHOOK orelse Online == ?ONLINE_FAKE_ON ->
    ignore;
role_logout(PS, NowTime, LogoutType) ->
    #player_status{
        gold = Gold, bgold = BGold,
        last_login_time = LastLoginTime,
        combat_power = Power,
        figure = #figure{lv = RoleLv, vip = Vip},
        source = Source
    } = PS,
    OnlineTime = NowTime - LastLoginTime,
    ModulePowerL = lib_player:ta_get_module_power(PS),
    MountTypePowerL = proplists:get_value(mount_power, ModulePowerL, []),
    OtherProperties = #{
        logout_type => val_logout_type(LogoutType)
        ,online_time => OnlineTime
        ,current_gold => Gold
        ,current_bgold => BGold
        ,equip_power => proplists:get_value(?MOD_EQUIP, ModulePowerL, 0)
        ,seal_power => proplists:get_value(?MOD_SEAL, ModulePowerL, 0)
        ,mount_power => proplists:get_value(?MOUNT_ID, MountTypePowerL, 0)
        ,mate_power => proplists:get_value(?MATE_ID, MountTypePowerL, 0)
        ,divine_rune => proplists:get_value(?MOD_DRAGON, ModulePowerL, 0)
        ,soul_rune => proplists:get_value(?MOD_RUNE, ModulePowerL, 0)
        ,resonance_power => proplists:get_value(?MOD_RESONANCE_POWER, ModulePowerL, 0)
        ,atlas_power => proplists:get_value(?MOD_MON_PIC, ModulePowerL, 0)
        ,wing_power => proplists:get_value(?FLY_ID, MountTypePowerL, 0)
        ,divine_power => proplists:get_value(?HOLYORGAN_ID, MountTypePowerL, 0)
        ,omori_power => proplists:get_value(?ARTIFACT_ID, MountTypePowerL, 0)
        ,mirage_power => proplists:get_value(?MOD_EUDEMONS, ModulePowerL, 0)
        ,seance_power => proplists:get_value(?MOD_GOD, ModulePowerL, 0)
    },
    UserProperties = #{
        latest_logout_time => NowTime
        ,vip_level => Vip
        ,role_level => RoleLv
        ,current_power => Power
        ,channel => Source
    },
    ta_agent:track(PS, role_logout, OtherProperties, normal, NowTime),
    ta_agent:user_set(PS, UserProperties).


%% 通知在线玩家上报虚拟登出信息【供留存数据分析之用】
online_simu_logout() ->
    lib_player:cast_online_role_apply(?APPLY_CAST_STATUS,
        ?MODULE, role_simu_logout, []
    ).
%% 在线玩家上报虚拟登出信息【供角色进程回调】
role_simu_logout(PS) ->
    NowTime = utime:unixtime(),
    LogoutType = role_simu_logout,
    role_logout(PS, NowTime, LogoutType),
    ok.

%% 充值订单完成
order_finish(PS, [PayNo, Money, Gold, ProductCfg, IsPay]) ->
    #player_status{reg_time = RegTime} = PS,
    Currency = data_ta_properties:get_ver_currency(?GAME_VER),
    NowTime = utime:unixtime(),
    #base_recharge_product{
        product_id = ProductId, product_type = ProductType,
        product_subtype = ProductSubType, product_name = ProductName
    } = ProductCfg,
    Properties = #{
        order_id => PayNo,
        currency => Currency,
        pay_amount => Money,
        act_value => Gold,
        pay_item_type => ProductType,
        pay_sub_type => ProductSubType,
        pay_item_id => ProductId,
        pay_item => ProductName,
        is_first_pay => IsPay == false,
        is_new_register => utime:is_same_day(RegTime, NowTime)
    },
    ta_agent:track(PS, order_finish, Properties, normal, NowTime).

%% 每天3:59记录，只对今日有登录的玩家进行统计
role_daily_active(#player_status{online = ?ONLINE_OFF_ONHOOK}) ->
    ignore;
role_daily_active(Player) ->
    #player_status{weekly_card_status = #weekly_card_status{lv = WeeklyCardLv}} = Player,
    Now = utime:unixtime(),
    {Time4Clock1, Time4Clock2} = {utime:unixdate_four()-60, utime:get_next_unixdate_four()-60}, % 3:59
    AtTime = ?IF(Now < Time4Clock1, Time4Clock1, Time4Clock2),
    Properties = get_daily_active_properties(Player),
    OtherProperties = Properties#{weekly_card_lv => WeeklyCardLv},
    ta_agent:track(Player, role_daily_active, OtherProperties, {at_time, AtTime}, Now),
    Player.

%% 每天23:59记录，只对今日登录的玩家进行统计
role_daily_attr(#player_status{online = ?ONLINE_OFF_ONHOOK}) ->
    ignore;
role_daily_attr(Player) ->
    #player_status{
        id = RoleId,
        gold = Gold,
        bgold = Bgold,
        combat_power = CombatPower
    } = Player,
    Now = utime:unixtime(),
    AtTime = utime:unixdate() + 23*3600 + 59*60,
    Properties = get_daily_attr_properties(RoleId),
    FCombatPower = lib_role:get_role_first_combat(RoleId),
    OtherProperties = Properties#{
        current_gold => Gold
        ,current_bgold => Bgold
        ,get_power => CombatPower - FCombatPower
    },
    ta_agent:track(Player, role_daily_attr, OtherProperties, {at_time, AtTime}, Now),
    Player.

%% 钻石消耗
gold_consume(PS, [CostAmount, ProductType]) ->
    #player_status{
        gold = Gold
    } = PS,
    OtherProperties = #{
        cost_amount => CostAmount,
        change_after => Gold,
        consume_type => ProductType
    },
    ta_agent:track(PS, gold_consume, OtherProperties, normal, utime:unixtime()),
    ok.

%% 绑钻消耗
bgold_consume(PS, [CostAmount, ProductType]) ->
    #player_status{
        bgold = BGold
    } = PS,
    OtherProperties = #{
        cost_amount => CostAmount,
        change_after => BGold,
        consume_type => ProductType
    },
    ta_agent:track(PS, bgold_consume, OtherProperties, normal, utime:unixtime()),
    ok.

%% 钻石获得
gold_get(PS, [AddAmount, ProductType]) ->
    #player_status{
        gold = Gold
    } = PS,
    OtherProperties = #{
        get_amount => AddAmount,
        change_after => Gold,
        get_type => ProductType
    },
    ta_agent:track(PS, gold_get, OtherProperties, normal, utime:unixtime()),
    ok.

%% 绑钻获得
bgold_get(PS, [AddAmount, ProductType]) ->
    #player_status{
        gold = Gold
    } = PS,
    OtherProperties = #{
        get_amount => AddAmount,
        change_after => Gold,
        get_type => ProductType
    },
    ta_agent:track(PS, bgold_get, OtherProperties, normal, utime:unixtime()),
    ok.

%% 输入礼包卡使用时记录，领取失败的也需要记录
gift_card(Player, [CardNo, CardType, GiftType, IsSuccess, FailType]) ->
    OtherProperties = #{
        card_no => CardNo
        ,card_type => CardType
        ,gift_type => GiftType
        ,is_success => IsSuccess
        ,fail_type => case data_errorcode_msg:get(FailType) of
                          #errorcode_msg{about = Msg} -> Msg;
                          _ -> ""
                      end
    },
    ta_agent:track(Player, gift_card, OtherProperties, normal, utime:unixtime()),
    ok.

% %% 完成任务时记录
task_completed(Player, Now, [TaskId, Type, Duration, SwapCount]) ->
    Task = lib_task:get_data(TaskId),
    OtherProperties = #{
        task_id => Task#task.id
        ,type => var_task_type(Type)
        ,task_name => Task#task.name
        ,task_type => var_task(Task#task.type)
        ,duration => Duration
        ,swap_count => SwapCount
    },
    % OpDay = util:get_open_day(),
    ta_agent:track(Player, task_completed, OtherProperties, normal, Now),
    % case OpDay=<3 andalso lists:member(Task#task.type,[?TASK_TYPE_MAIN,?TASK_TYPE_SIDE,?TASK_TYPE_TURN]) of
    %     true->
    %         ta_agent:track(Player, task_completed, OtherProperties, normal, Now);
    %     _->
    %         skip
    % end,
    Player.

task_completed_swap(Player, [TaskType, Count]) ->
    Now = utime:unixtime(),
    OtherProperties = #{
        task_id => 0
        ,type => var_task_type(0)
        ,task_name => ""
        ,task_type => var_task(TaskType)
        ,duration => 0
        ,swap_count => Count
    },
    % OpDay = util:get_open_day(),
    ta_agent:track(Player, task_completed, OtherProperties, normal, Now),
    %case OpDay=<3 andalso lists:member(TaskType,[?TASK_TYPE_MAIN,?TASK_TYPE_SIDE,?TASK_TYPE_TURN]) of
    %    true->
    %        ta_agent:track(Player, task_completed, OtherProperties, normal, Now);
    %    _->
    %        skip
    %end,
    Player.

%% 排行榜
ta_rank(PS, [RankType, Rank, Time]) when Rank =< 50 ->
    #player_status{guild = #status_guild{id = GuildId, name = GuildName}, last_login_time = LastLoginTime} = PS,
    OtherProperties = #{
        rank_order => Rank,
        guild_id => GuildId,
        guild_name => GuildName,
        last_login => LastLoginTime
    },
    case RankType of
        ?RANK_TYPE_COMBAT ->
            ta_agent:track(PS, power_rank, OtherProperties, normal, Time);
        ?RANK_TYPE_LV ->
            ta_agent:track(PS, level_rank, OtherProperties, normal, Time);
        _ ->
            skip
    end,
    ok;
ta_rank(_, _) -> skip.

%% 商城购买
%% @param ShopMain
%%      shop:正常商城; quick_buy:快速购买;
role_shop_by(Player, [ShopMain, ShopType, GoodsTypeId, GoodsNum, CostType, Price]) ->
    {NCostType, CostGoodsId, CurrencyLeft} = case CostType of
        ?TYPE_GOLD ->   {CostType, 0, Player#player_status.gold};
        ?TYPE_BGOLD ->  {CostType, 0, Player#player_status.bgold};
        ?TYPE_COIN ->   {CostType, 0, Player#player_status.coin};
        ?TYPE_HONOUR -> {CostType, 0, Player#player_status.jjc_honour};
        _ when ShopMain == shop ->
            case ShopType of
                ?SHOP_GLORY ->      {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_SEAL ->       {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_MEDAL ->      {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_3V3 ->        {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_SUPVIP ->     {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_EUDEMONS ->   {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_RDUNGEON ->   {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_LUCKY ->      {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_DRACONIC ->   {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_GOD_COURT ->  {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_PRESITIGE when CostType == ?GOODS_ID_GUILD_PRESTIGE_GOOD ->
                    [{_, PresitigeGoodsNum}] = lib_goods_api:get_goods_num(Player, [CostType]),
                    {?TYPE_GOODS, CostType, PresitigeGoodsNum};
                ?SHOP_PRESITIGE ->      {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_ZEN_SOUL ->       {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                ?SHOP_NIGHT_GHOST ->    {?TYPE_CURRENCY, CostType, lib_goods_api:get_currency(Player, CostType)};
                _ -> {0, 0, 0}
            end;
        _ -> {0, 0, 0}
    end,
    OtherProperties = #{
        shop_type => var_shop_type(ShopMain, ShopType)
        ,goods_id => GoodsTypeId
        ,goods_num => GoodsNum
        ,cost_type => NCostType
        ,cost_goods_id => CostGoodsId
        ,cost_num => Price
        ,currency_left => CurrencyLeft
    },
    % ?MYLOG("ta", "OtherProperties:~p", [OtherProperties]),
    ta_agent:track(Player, shop_buy, OtherProperties, normal, utime:unixtime()).

log_welfare(PS, [WelfareType, GoldNum, Op, LeftCount]) ->
    OtherProperties = #{
        welfare_type => WelfareType
        ,gold_num => GoldNum
        ,op => var_welfare_type(Op)
        ,left_count => LeftCount
    },
    ta_agent:track(PS, log_welfare, OtherProperties).

log_recharge_return(PS, [ProductId, ReturnType, GoldNum, ReturnGold]) ->
    OtherProperties = #{
        pay_item_id => ProductId
        ,return_type => ReturnType
        ,gold_num => GoldNum
        ,return_gold => ReturnGold
    },
    ta_agent:track(PS, log_recharge_return, OtherProperties).

log_bonus_tree(PS, [Type, SubType, DrawTimes, AutoBuy, GradeIds]) ->
    OtherProperties = #{
        custom_act_type => Type
        ,act_sub_type => SubType
        ,draw_times => DrawTimes
        ,auto_buy => AutoBuy
        ,grade_ids => GradeIds
    },
    ta_agent:track(PS, log_bonus_tree, OtherProperties).

log_smashed_egg(RoleId, Args) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ta_agent_fire, log_smashed_egg, [Args]);
log_smashed_egg(PS, [SmashedType, DrawTimes, Index, IsFree, AutoBuy]) ->
    OtherProperties = #{
        smashed_type => SmashedType
        ,draw_times => DrawTimes
        ,index => Index
        ,is_free => IsFree
        ,auto_buy => AutoBuy
    },
    ta_agent:track(PS, log_smashed_egg, OtherProperties).

%% 嗨点值变化
log_hi_points(Player, ActSubType, ModuleId, ModuleSubId, BeforeHiPoint, AfterHiPoint) ->
    Properties = #{
        act_sub_type => ActSubType,
        module_id => ModuleId,
        module_subid => ModuleSubId,
        before_hi_point => BeforeHiPoint,
        after_hi_point => AfterHiPoint
    },
    ta_agent:track(Player, log_hi_points, Properties, normal, utime:unixtime()).

%% 幸运鉴宝抽奖
log_treasure_evaluation(Player, TreasureEvalType, BeforeLuckyNum, AfterLuckyNum) ->
    Properties = #{
        treasure_eval_type => TreasureEvalType,
        before_lucky_num => BeforeLuckyNum,
        after_lucky_num => AfterLuckyNum
    },
    ta_agent:track(Player, log_treasure_evaluation, Properties, normal, utime:unixtime()).

%% 幸运鉴宝
log_custom_treasure(Player, CustomActType, CustomActSubType, Turn, DrawTimes, LuckyValue, GradeList) ->
    Properties = #{
        custom_act_type => CustomActType,
        custom_act_subtype => CustomActSubType,
        turn => Turn,
        draw_times => DrawTimes,
        lucky_value => LuckyValue,
        grade_list => GradeList
    },
    ta_agent:track(Player, log_custom_treasure, Properties, normal, utime:unixtime()).

%% boss进入退出
log_enter_or_exit_boss(Player, Lv, Stage, BossId, BossType, OpType, StayTime, BeforeScene, X, Y, TeamId) ->
    BossName = lib_mon:get_name_by_mon_id(BossId),
    Properties = #{
        lv => Lv,
        stage => Stage,
        boss_id => BossId,
        boss_type => BossType,
        boss_name => BossName,
        op_type => OpType,
        stay_time => StayTime,
        before_scene => BeforeScene,
        x => X,
        y => Y,
        team_id => TeamId
    },
    ta_agent:track(Player, log_enter_or_exit_boss, Properties, normal, utime:unixtime()).

%% boss击杀
log_boss_kill(Player, Lv, Stage, BossType, BossId, TeamId) ->
    BossName = lib_mon:get_name_by_mon_id(BossId),
    Properties = #{
        lv => Lv,
        stage => Stage,
        boss_id => BossId,
        boss_type => BossType,
        boss_name => BossName,
        team_id => TeamId
    },
    ta_agent:track(Player, log_boss_kill, Properties, normal, utime:unixtime()).

%% 玩家升级
log_uplv(Player, Lv, From, AddExp, SceneId) ->
    Properties = #{
        lv => Lv,
        from => From,
        add_exp => AddExp,
        scene_id => SceneId
    },
    ta_agent:track(Player, log_uplv, Properties, normal, utime:unixtime()).

%% 开服冲榜
log_rush_rank_reward(Player, RankType, Rank, Value, _Reward) ->
    Properties = #{
        rush_rank_type => RankType,
        rank => Rank,
        rush_rank_value => Value
    },
    ta_agent:track(Player, log_rush_rank_reward, Properties, normal, utime:unixtime()).

% role_shop_by(Player, [Cfg, GoodsNum, IsQuick]) ->
%     CurrencyLeft = case Cfg#shop.ctype of
%         ?TYPE_GOLD -> Player#player_status.gold;
%         ?TYPE_BGOLD -> Player#player_status.bgold;
%         ?TYPE_COIN -> Player#player_status.coin;
%         ?TYPE_HONOUR -> Player#player_status.jjc_honour;
%         % ?TYPE_MATE -> lib_goods_api:get_currency(Player, ?GOODS_ID_MATE);
%         _ -> 0
%     end,
%     OtherProperties = #{
%         shop_type => var_shop_type(Cfg#shop.shop_type)
%         ,goods_id => Cfg#shop.goods_id
%         ,goods_num => GoodsNum
%         ,cost_type => Cfg#shop.ctype
%         ,cost_num => Cfg#shop.price * GoodsNum
%         ,currency_left => CurrencyLeft
%         ,is_quick => ?IF(IsQuick > 0, true, false)
%     },
%     ta_agent:track(Player, shop_buy, OtherProperties, normal, utime:unixtime()).

% %% 紫色以上品质的装备获取时记录
% %% get_type:1宝箱|2赏金幻魔|3个人幻魔|4星域幻魔|5幻魔之家
% equip_get(Player, GoodsId, GetType) ->
%     case equip_api:get_cfg_equip_info(GoodsId) of
%         #base_equip_attr{equip_type = EquipType, stage = Stage, star = Star, color = Color, career = Career}
%             when Color >= ?PURPLE ->
%             OtherProperties = #{
%                 equip_type => EquipType
%                 ,equip_career => var_career_type(Career)
%                 ,get_type => GetType
%                 ,goods_id => GoodsId
%                 ,goods_color => Color
%                 ,equip_stage => Stage
%                 ,equip_star => Star
%             },
%             ta_agent:track(Player, equip_get, OtherProperties);
%         _ ->
%             ignore
%     end.

% %% 玩家进行装备洗练操作时记录
% equip_wash(Player, [PosInfo, PlusType, CostList]) ->
%     CostListNoBgold =
%     case lists:keytake(?TYPE_BGOLD, 1, CostList) of
%         {value, {_, _, Bgold}, LeftCost1} ->
%             LeftCost1;
%         _ ->
%             Bgold = 0,
%             CostList
%     end,
%     CostListNoGold =
%         case lists:keytake(?TYPE_GOLD, 1, CostListNoBgold) of
%             {value, {_, _, Gold}, LeftCost2} ->
%                 LeftCost2;
%             _ ->
%                 Gold = 0,
%                 CostListNoBgold
%         end,
%     OtherProperties = #{
%         equip_type => PosInfo#equip_pos_info.pos
%         ,division => PosInfo#equip_pos_info.wash_division
%         ,wash_score => round(equip_api:count_equip_attr_rating(PosInfo#equip_pos_info.wash_attr, 0))
%         ,ratio_plus => PlusType
%         ,cost_list => CostListNoGold
%         ,cost_gold => Gold
%         ,cost_bgold => Bgold
%         ,current_gold => Player#player_status.gold
%         ,current_bgold => Player#player_status.bgold
%     },
%     ta_agent:track(Player, equip_wash, OtherProperties).

% %% 玩家进行粉装激活、升阶操作时记录
% equip_empower(Player, PosInfo) ->
%     OtherProperties = #{
%         equip_type => PosInfo#equip_pos_info.pos
%         ,equip_pink_lv => PosInfo#equip_pos_info.pink_lv
%     },
%     ta_agent:track(Player, equip_empower, OtherProperties).

% %% 玩家进行套装晋升、回退操作时记录
% %% OpType:1晋升0回退
% %% SuitType:1装备2配饰
% equip_suit(Player, [PosInfo, OpType]) ->
%     OtherProperties = #{
%         equip_type => PosInfo#equip_pos_info.pos
%         ,op_type => OpType
%         ,suit_type => equip_api:get_cfg_pos2suit(PosInfo#equip_pos_info.pos)
%         ,suit_lv => PosInfo#equip_pos_info.suit_lv
%         ,suit_power => equip_api:get_suit_power(Player)
%     },
%     ta_agent:track(Player, equip_suit, OtherProperties).

% %% 玩家进行红装合成操作时记录
% equip_red(Player, [Config, Cost, Ratio, Result]) ->
%     {Stage, Star} = equip_api:get_equip_stage_and_star(Config#base_goods_compose_or_evolution_info.target_goods_id),
%     CostList = [
%         case One of
%             {_, GoodsId, _} -> GoodsId;
%             {#goods{goods_id = GoodsId}, _Num} -> GoodsId;
%             _ -> 0
%         end
%         || One <- Cost
%     ],
%     OtherProperties = #{
%         cost_list => CostList
%         ,cost_equip_num => length(CostList)
%         ,red_ratio => Ratio
%         ,red_type => Star
%         ,is_success => Result == 1
%         ,equip_series => Stage
%     },
%     ta_agent:track(Player, equip_red, OtherProperties).

% %% 玩家对戒指和手镯进行升阶、升星、降阶操作时记录
% equip_great(Player, RuleConfig) ->
%     {Stage, Star} = equip_api:get_equip_stage_and_star(RuleConfig#base_goods_compose_or_evolution_info.main_goods_id),
%     EquipType = equip_api:get_equip_type(RuleConfig#base_goods_compose_or_evolution_info.main_goods_id),
%     OtherProperties = #{
%         equip_series => Stage
%         ,star_level => Star
%         ,equip_type => EquipType
%         ,op_type => RuleConfig#base_goods_compose_or_evolution_info.subclass
%     },
%     ta_agent:track(Player, equip_great, OtherProperties).

% %% 战魂上阵/替换/进化/觉醒时记录
% warsoul_equip(Player, [Type, Pos, OldId, Stage, EquipConfig, PlayerOld]) ->
%     OtherProperties = #{
%         type => var_warsoul_type(Type)
%         ,pos => Pos
%         ,old_goods_id => OldId
%         ,new_goods_id => EquipConfig#base_war_soul_info.goods_id
%         ,goods_color => EquipConfig#base_war_soul_info.color
%         ,soul_attr => EquipConfig#base_war_soul_info.kind
%         ,goods_star => Stage
%         ,group_type => Player#player_status.role_war_soul#role_war_soul.array_id
%         ,promote_power => Player#player_status.combat_power - PlayerOld#player_status.combat_power
%     },
%     ta_agent:track(Player, warsoul_equip, OtherProperties, normal, utime:unixtime()).

% %% 羁绊关系变更时记录：运营决定暂时不上报，触发代码已注释
% mate_friend(Player, [Friends, Type]) ->
%     [{_, _, Intimacy}] = lib_relationship_api:get_rela_and_intimacy_online(Player#player_status.id, [Friends]),
%     OtherProperties = #{
%         friend_id => Friends
%         ,type => var_mate_type(Type)
%         ,intimacy => Intimacy
%     },
%     ta_agent:track(Player, mate_friend, OtherProperties, normal, utime:unixtime()).

% %% 名望券获得
% honour_get(PS, [AddAmount, ProductType, About]) ->
%     #player_status{
%          honour = Honour
%     } = PS,
%     OtherProperties = #{
%         get_amount => AddAmount,
%         change_after => Honour,
%         get_type => ProductType,
%         assist_type => unicode:characters_to_binary(About)
%     },
%     ta_agent:track(PS, fame_get, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 名望券消耗
% honour_consume(PS, [CostAmount, ProductType]) ->
%     #player_status{
%         honour = Honour
%     } = PS,
%     OtherProperties = #{
%         cost_amount => CostAmount,
%         change_after => Honour,
%         consume_type => ProductType
%     },
%     ta_agent:track(PS, fame_consume, OtherProperties, normal, utime:unixtime()),
%     ok.


% %% 进阶升级
% foster_up(PS, [Type, Stage, Star, Exp, AddExp, NeedExp, EndTime, IsAuto,
%     CostExp, CostNum, CostGold, CostBGold, CurrentGold, CurrentBGold]) ->
%     OtherProperties = #{
%         type => unicode:characters_to_binary(Type),
%         step_level => Stage,
%         star_level => Star,
%         exp => Exp,
%         add_exp => AddExp,
%         need_exp => NeedExp,
%         end_time => EndTime,
%         is_auto => IsAuto,
%         cost_exp => CostExp,
%         cost_num => CostNum,
%         cost_gold => CostGold,
%         cost_bgold => CostBGold,
%         current_gold => CurrentGold,
%         current_bgold => CurrentBGold
%     },
%     ta_agent:track(PS, foster_up, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 完成七日目标任务
% seven_goal_task(PS, [Days, ModId, SubId, TaskName]) ->
%     OtherProperties = #{
%         days => Days,
%         mod_id => ModId,
%         sub_id => SubId,
%         task_name => TaskName
%     },
%     ta_agent:track(PS, seven_goal, OtherProperties),
%     ok.

% %% 珍宝升星
% treasure_up(PS, [Type, TreasureId, OldStar, NewStar, CostGoods, CostNum]) ->
%     OtherProperties = #{
%         type => Type,
%         treasure_id => TreasureId,
%         old_star => OldStar,
%         new_star => NewStar,
%         cost_goods => CostGoods,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, treasure_up, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 进阶皮肤激活
% skin_up(PS, [Type, SkinId, CostGoods, CostNum]) ->
%     OtherProperties = #{
%         type => Type,
%         skin_id => SkinId,
%         cost_goods => CostGoods,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, skin_up, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 宠物激活/升星
% pet_star_up(PS, [PetId, RareDegree, ColorId, RaceId, OldStar, NewStar, CostGoods, CostNum]) ->
%     OtherProperties = #{
%         pet_id => PetId,
%         rare_degree => RareDegree,
%         color_id => ColorId,
%         race_id => RaceId,
%         old_star => OldStar,
%         new_star => NewStar,
%         cost_goods => CostGoods,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, pet_up, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 宝宝同心值变化
% child_heart(PS, [Type, TaskId, CostBGold, GetHeart, CurrentHeart]) ->
%     OtherProperties = #{
%         type => unicode:characters_to_binary(Type),
%         task_id => TaskId,
%         cost_bgold => CostBGold,
%         get_heart => GetHeart,
%         current_heart => CurrentHeart
%     },
%     ta_agent:track(PS, child_heart, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 宝宝技能激活/升级
% child_vehicle(PS, [GoodsId, NewStage, CostNum]) ->
%     OtherProperties = #{
%         goods_id => GoodsId,
%         new_stage => NewStage,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, child_vehicle, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 宝宝时装激活/升级
% child_fashion(PS, [GoodsId, NewLevel, CostNum]) ->
%     OtherProperties = #{
%         goods_id => GoodsId,
%         new_level => NewLevel,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, child_fashion, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 宝宝技能激活/升级
% child_skill(PS, [SkillId, NewLevel, CostGoods, CostNum]) ->
%     OtherProperties = #{
%         skill_id => SkillId,
%         new_level => NewLevel,
%         cost_goods => CostGoods,
%         cost_num => CostNum
%     },
%     ta_agent:track(PS, child_skill, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 玩家退出狂战领域场景时记录
% madness_land(Player, [FamStage, Score, DieCount, Interval]) ->
%     OtherProperties = #{
%         fam_stage => FamStage
%         ,score => Score
%         ,revive_times => DieCount
%         ,use_time => Interval
%     },
%     ta_agent:track(Player, madness_land, OtherProperties),
%     ok.

% %% 龙神宝库抽奖
% warsoul_draw(PS, [Times, AwardList, PurNum, OrangeNum, RedNum, IsAbsolute, TotalTimes, TowerDungeon, CostGold,
%     CostTicket, CurrentGold, CurrentTicket]) ->
%     Type =
%         if  Times == 1 -> <<"单抽"/utf8>>;
%             Times == 10 -> <<"十抽"/utf8>>;
%             true -> <<"单抽"/utf8>>
%         end,
%     OtherProperties = #{
%         type => Type,
%         award_list => AwardList,
%         purple_num => PurNum,
%         orange_num => OrangeNum,
%         red_num => RedNum,
%         is_absolute => IsAbsolute,
%         total_times => TotalTimes,
%         tower_dungeon => TowerDungeon,
%         cost_gold => CostGold,
%         cost_ticket => CostTicket,
%         current_gold => CurrentGold,
%         current_ticket => CurrentTicket
%     },
%     ta_agent:track(PS, warsoul_draw, OtherProperties),
%     ok.
% % warsoul_draw(PS, [Type, AwardList, PurpleNum, Orange4, Orange5, Red, IsPrize, IsAbsolute,
% %     TotalTimes, CostGold, CostTicket, CurrentGold, CurrentTicket]) ->
% %     OtherProperties = #{
% %         type => Type,
% %         award_list => AwardList,
% %         purple_num => PurpleNum,
% %         orange4_num => Orange4,
% %         orange5_num => Orange5,
% %         red_num => Red,
% %         is_prize => IsPrize,
% %         is_absolute => IsAbsolute,
% %         total_times => TotalTimes,
% %         cost_gold => CostGold,
% %         cost_ticket => CostTicket,
% %         current_gold => CurrentGold,
% %         current_ticket => CurrentTicket
% %     },
% %     ta_agent:track(PS, warsoul_draw, OtherProperties),
% %     ok.

% %% 圣物抽奖
% nucleon_draw(PS, [PoolType, Type, Orange1, Orange2, SectionPiece,
% 	CostGoods, CostGold, CostBGold, CurrentGold, CurrentBGold]) ->
% 	OtherProperties = #{
% 		pool_type => PoolType,
% 		type => Type,
% 		color_orange1 => Orange1,
% 		color_orange2 => Orange2,
% 		section_piece => SectionPiece,
% 		cost_goods => CostGoods,
% 		cost_gold => CostGold,
% 		cost_bgold => CostBGold,
% 		current_gold => CurrentGold,
% 		current_bgold => CurrentBGold
% 	},
% 	ta_agent:track(PS, nucleon_draw, OtherProperties),
% 	ok.

% %% 装备抽奖
% equip_draw(PS, [Times, AwardList, PrizeList, PrizeStage,
%     PrizeNum, IsAbsolute, TotalTimes, CostGold, CostTicket, CurrentGold, CurrentTicket]) ->
%     Type =
%         if  Times == 1 -> <<"单抽"/utf8>>;
%             Times == 10 -> <<"十连"/utf8>>;
%             Times == 50 -> <<"五十连"/utf8>>;
%             true -> <<"单抽"/utf8>>
%         end,
%     OtherProperties = #{
%         type => Type,
%         award_list => AwardList,
%         prize_list => PrizeList,
%         prize_stage => PrizeStage,
%         prize_num => PrizeNum,
%         is_absolute => IsAbsolute,
%         total_times => TotalTimes,
%         cost_gold => CostGold,
%         cost_ticket => CostTicket,
%         current_gold => CurrentGold,
%         current_ticket => CurrentTicket
%     },
%     ta_agent:track(PS, equip_draw, OtherProperties),
%     ok.

% %% 升级寻宝抽奖
% upgrade_draw(PS, [PoolType, Times, AwardList, PrizeList, PrizeStage,
%     PrizeNum, IsAbsolute, TotalTimes, CostGold, CostTicket, CurrentGold, CurrentTicket]) ->
%     Type =
%         if  Times == 1 -> <<"单抽"/utf8>>;
%             Times == 10 -> <<"十连"/utf8>>;
%             Times == 50 -> <<"五十连"/utf8>>;
%             true -> <<"单抽"/utf8>>
%         end,
%     OtherProperties = #{
%         type => Type,
%         pool_type => PoolType,
%         award_list => AwardList,
%         is_absolute => IsAbsolute,
%         prize_list => PrizeList,
%         prize_stage => PrizeStage,
%         prize_num => PrizeNum,
%         total_times => TotalTimes,
%         cost_gold => CostGold,
%         cost_ticket => CostTicket,
%         current_gold => CurrentGold,
%         current_ticket => CurrentTicket
%     },
%     ta_agent:track(PS, upgrade_draw, OtherProperties),
%     ok.

% %% 圣物变化
% nucleon_state(PS, [Pos, LevelPos, Type, OldGoodsId, GoodsId, OldColor, NewColor,
%     OldStar, NewStar, PromotePower]) ->
%     OtherProperties = #{
%         pos => Pos,
%         level_pos => LevelPos,
%         type => Type,
%         old_goods_id => OldGoodsId,
%         goods_id => GoodsId,
%         old_color => OldColor,
%         new_color => NewColor,
%         old_star => OldStar,
%         new_star => NewStar,
%         promote_power => PromotePower
%     },
%     ta_agent:track(PS, nucleon_state, OtherProperties),
%     ok.

% %% 社团状态变动
% guild_state(PS, [EventType, GuildId, GuildName, GuildLevel, GuildNum,
%     GuildPower, GuildRank, OldPosition, NewPosition]) ->
%     OtherProperties = #{
%         event_type => EventType,
%         guild_id => GuildId,
%         guild_name => GuildName,
%         guild_level => GuildLevel,
%         guild_num => GuildNum,
%         guild_power => GuildPower,
%         guild_rank => GuildRank,
%         old_position => OldPosition,
%         new_position => NewPosition
%     },
%     ta_agent:track(PS, guild_state, OtherProperties),
%     ok.

% %% 社团活跃变动
% guild_activity(PS, [GuildId, GuildName, GuildLevel, GuildNum,
%     TaskType, Live, PersonLive, GuildLive]) ->
%     OtherProperties = #{
%         guild_id => GuildId,
%         guild_name => GuildName,
%         guild_level => GuildLevel,
%         guild_num => GuildNum,
%         task_type => TaskType,
%         live => Live,
%         person_live => PersonLive,
%         guild_live => GuildLive
%     },
%     ta_agent:track(PS, guild_activity, OtherProperties),
%     ok.

% %% 宠物副本
% pet_dungeon(PS, [DunType, ResultType, ResultSubType, UseTime,
%     IsFirst, IsSweep, DunTimes, TimesLeft]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime,
%         is_first => IsFirst,
%         is_sweep => IsSweep,
%         dun_times => DunTimes,
%         times_left => TimesLeft
%     },
%     ta_agent:track(PS, pet_dungeon, OtherProperties),
%     ok.

% %% ai娘副本
% ai_dungeon(PS, [DunType, ResultType, ResultSubType, UseTime,
%     IsFirst, IsSweep, DunTimes, TimesLeft]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime,
%         is_first => IsFirst,
%         is_sweep => IsSweep,
%         dun_times => DunTimes,
%         times_left => TimesLeft
%     },
%     ta_agent:track(PS, ai_dungeon, OtherProperties),
%     ok.

% %% 舞池
% activity_beach(PS, [IsHosting, UseTime, IsCountDown]) ->
%     OtherProperties = #{
%         is_offline_hosting => IsHosting,
%         use_time => UseTime,
%         is_count_down => IsCountDown
%     },
%     ta_agent:track(PS, activity_beach, OtherProperties),
%     ok.

% %% 社团晚宴
% guild_ballroom(PS, [IsHosting, IsCountDown, LikeTimes, FreeTimes, PayTimes, UseTime]) ->
%     OtherProperties = #{
%         is_offline_hosting => IsHosting,
%         is_count_down => IsCountDown,
%         glamour_like_times => LikeTimes,
%         glamour_free_items => FreeTimes,
%         glamour_pay_items => PayTimes,
%         use_time => UseTime
%     },
%     ta_agent:track(PS, guild_ballroom, OtherProperties),
%     ok.

% %% 社团boss
% guild_boss(PS, [IsHosting, IsCountDown, EncourageTimes, ReviveTimes, DamagePercent]) ->
%     OtherProperties = #{
%         is_offline_hosting => IsHosting,
%         is_count_down => IsCountDown,
%         encourage_times => EncourageTimes,
%         revive_times => ReviveTimes,
%         damage_percent => DamagePercent
%     },
%     ta_agent:track(PS, guild_boss, OtherProperties),
%     ok.

% %% 饥饿游戏
% wasteland_war_kv(PS, [WarRound, ResultType, CrystalScore, KillScore, RankNum, ReviveTimes, UseTime]) ->
%     OtherProperties = #{
%         war_round => WarRound,
%         result_type => ResultType,
%         crystal_score => CrystalScore,
%         kill_score => KillScore,
%         rank_num => RankNum,
%         revive_times => ReviveTimes,
%         use_time => UseTime
%     },
%     ta_agent:track(PS, wasteland_war_kv, OtherProperties),
%     ok.

% %% 衣橱时装
% fashion_up(PS, [PosId, FashionId, ColorId, OptionType, CostGood, CostNum, OldStar, NewStar]) ->
%     OtherProperties = #{
%         pos_id => PosId,
%         fashion_id => FashionId,
%         color_id => ColorId,
%         option_type => OptionType,
%         cost_goods => CostGood,
%         cost_num => CostNum,
%         old_star => OldStar,
%         new_star => NewStar
%     },
%     ta_agent:track(PS, fashion_up, OtherProperties),
%     ok.

% %% 圣物觉醒
% nucleon_section_up(PS, [Pos, Next, GoodsNum]) ->
%     OtherProperties = #{
%         pos => Pos,
%         level => Next,
%         cost_num => GoodsNum
%     },
%     ta_agent:track(PS, nucleon_section, OtherProperties, normal, utime:unixtime()),
%     ok.

% %% 材料副本
% foster_dungeon(PS, [DunType, IsSweep, ResultType, DunTimes]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         is_sweep => IsSweep,
%         result_type => ResultType,
%         dun_times => DunTimes
%     },
%     ta_agent:track(PS, foster_dungeon, OtherProperties),
%     ok.

% %% 无尽回廊
% tower_dungeon(PS, [DunType, ResultType, ResultSubType, UseTime, IsFirst]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime,
%         is_first => IsFirst
%     },
%     ta_agent:track(PS, tower_dungeon, OtherProperties),
%     ok.

% %% AI娘(巫女副本)
% witch_dungeon(PS, [DunType, ResultType, ResultSubType, UseTime, IsFirst, IsSweep, DunTimes, TimesLeft]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime,
%         is_first => IsFirst,
%         is_sweep => IsSweep,
%         dun_times => DunTimes,
%         times_left => TimesLeft
%     },
%     ta_agent:track(PS, ai_dungeon, OtherProperties),
%     ok.

% %% 星币副本
% money_dungeon(PS, [DunType, ResultType, ResultSubType, UseTime, IsFirst, IsSweep, DunTimes, TimesLeft]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime,
%         is_first => IsFirst,
%         is_sweep => IsSweep,
%         dun_times => DunTimes,
%         times_left => TimesLeft
%     },
%     ta_agent:track(PS, money_dungeon, OtherProperties),
%     ok.

% %% 姻缘副本
% couple_dungeon(PS, [DunType, Intimacy, IsMate, ResultType, ResultSubType, DunStar, UseTime]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         intimacy => Intimacy,
%         is_mate => IsMate,
%         dun_star => DunStar,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime
%     },
%     ta_agent:track(PS, couple_dungeon, OtherProperties),
%     ok.

% %% 幻光副本
% llusory_light(Player, [DunType, OldDunWave, NewDunWave, ResultType, ResultSubType, UseTime]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         old_dun_wave => OldDunWave,
%         new_dun_wave => NewDunWave,
%         result_type => ResultType,
%         result_subtype => ResultSubType,
%         use_time => UseTime
%     },
%     erase(dungeon_ta_visus),
%     ta_agent:track(Player, path_dungeon, OtherProperties),
%     ok.

% %% 经验副本
% exp_dungeon(Player, [DunType, ExpGet, ResultSubType, IsSweep, DunTimes, UseTime]) ->
%     OtherProperties = #{
%         dun_type => DunType,
%         exp_get => ExpGet,
%         is_sweep => IsSweep,
%         dun_times => DunTimes,
%         result_subtype => ResultSubType,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, exp_dungeon, OtherProperties),
%     ok.

% %% 试炼副本
% trial_dungeon(Player, [DunType,ResultSubType]) ->
%     case ResultSubType =:= ?DUN_RESULT_SUBTYPE_NO of
%         true->
%             lib_dungeon_trial:update_ta_trial_cache(DunType);
%         _->
%             TaCache = lib_dungeon_trial:erase_ta_trial_cache(),
%             Ret =
%                 case TaCache of
%                     {_OldDunId,_StarTime} ->  {_OldDunId,_StarTime};
%                     {_OldDunId,_TempDunId,_StarTime} -> {_OldDunId,_StarTime};
%                     _-> undefined
%                 end,
%             if
%                 Ret =:= undefined -> ok;
%                 true ->
%                     {OldDunId,StarTime} = Ret,
%                     case data_dungeon:get_dun(DunType) of
%                         #dun_cfg{name = Name} ->
%                             OtherProperties = #{
%                                 dun_type => DunType,
%                                 dun_name=> Name,
%                                 into_dun_type=>OldDunId,
%                                 result_subtype => ResultSubType,
%                                 use_time => max(0,utime:unixtime()-StarTime)
%                             },
%                             ta_agent:track(Player, trial_dungeon, OtherProperties);
%                         _->
%                             ok
%                     end
%             end
%     end.

% trial_dungeon(Player,[DunType,ResultSubType],track) ->
%     TaCache = lib_dungeon_trial:erase_ta_trial_cache(),
%     Ret =
%         case TaCache of
%             {_OldDunId,_StarTime} ->  {_OldDunId,_StarTime};
%             {_OldDunId,_TempDunId,_StarTime} -> {_OldDunId,_StarTime};
%             _-> undefined
%         end,
%     if
%         Ret =:= undefined -> ok;
%         true ->
%             {OldDunId,StarTime} = Ret,
%             case data_dungeon:get_dun(DunType) of
%                 #dun_cfg{name = Name} ->
%                     OtherProperties = #{
%                         dun_type => DunType,
%                         dun_name=> Name,
%                         into_dun_type=>OldDunId,
%                         result_subtype => ResultSubType,
%                         use_time => max(0,utime:unixtime()-StarTime)
%                     },
%                     ta_agent:track(Player, trial_dungeon, OtherProperties);
%                 _->
%                     ok
%             end
%     end.


% %%千星源塔
% stars_tower_dungeon(Player, [DunType,ResultSubType]) ->
%     case ResultSubType =:= ?DUN_RESULT_SUBTYPE_NO of
%         true->
%             lib_dungeon_stars_tower:update_ta_stars_tower_cache(DunType);
%         _->
%             TaCache = lib_dungeon_stars_tower:erase_ta_stars_tower_cache(),
%             Ret =
%                 case TaCache of
%                     {_OldDunId,_StarTime}->  {_OldDunId,_StarTime};
%                     {_OldDunId,_TempDunId,_StarTime} -> {_OldDunId,_StarTime};
%                     _-> undefined
%                 end,
%             if
%                 Ret =:= undefined -> ok;
%                 true ->
%                     {OldDunId,StarTime} = Ret,
%                     case data_dungeon:get_dun(DunType) of
%                         #dun_cfg{name = Name} ->
%                             OtherProperties = #{
%                                 dun_type => DunType,
%                                 dun_name=> Name,
%                                 into_dun_type=>OldDunId,
%                                 result_subtype => ResultSubType,
%                                 use_time => max(0,utime:unixtime() - StarTime)
%                             },
%                             ta_agent:track(Player, star_tower_dungeon, OtherProperties);
%                         _-> ok
%                     end
%             end
%     end.

% stars_tower_dungeon(Player,[DunType,ResultSubType],track) ->
%     TaCache = lib_dungeon_stars_tower:erase_ta_stars_tower_cache(),
%     Ret =
%         case TaCache of
%             {_OldDunId,_StarTime} ->  {_OldDunId,_StarTime};
%             {_OldDunId,_TempDunId,_StarTime} -> {_OldDunId,_StarTime};
%             _-> undefined
%         end,
%     if
%         Ret =:= undefined -> ok;
%         true ->
%             {OldDunId,StarTime} = Ret,
%             case data_dungeon:get_dun(DunType) of
%                 #dun_cfg{name = Name} ->
%                     OtherProperties = #{
%                         dun_type => DunType,
%                         dun_name=> Name,
%                         into_dun_type=>OldDunId,
%                         result_subtype => ResultSubType,
%                         use_time => max(0,utime:unixtime()-StarTime)
%                     },
%                     ta_agent:track(Player, star_tower_dungeon, OtherProperties);
%                 _->
%                     ok
%             end
%     end.

% %%exp_dungeon(Player, [OldDunWave, NewDunWave, PowerAdvice, ResultType, ResultSubType, UseTime]) ->
% %%    OtherProperties = #{
% %%        old_dun_wave => OldDunWave,
% %%        new_dun_wave => NewDunWave,
% %%        power_advice => PowerAdvice,
% %%        result_type => ResultType,
% %%        result_subtype => ResultSubType,
% %%        use_time => UseTime
% %%    },
% %%    ta_agent:track(Player, exp_dungeon, OtherProperties),
% %%    ok.

% %% 护送
% ta_convoy(Player, [ColorId, ResultType, OldColor, RefreshTime, CostCard, CostBGold, DoubleRet]) ->
%     OtherProperties = #{
%         color_id => ColorId,
%         result_type => ResultType,
%         old_color => OldColor,
%         refresh_times => RefreshTime,
%         cost_card => CostCard,
%         cost_bgold => CostBGold,
%         double_type => DoubleRet
%     },
%     ta_agent:track(Player, convoy, OtherProperties),
%     ok.

% ta_fast_exp_drop(Player, [RewardTimes, SupVipTpye, UpLv, CostGold]) ->
%     OtherProperties = #{
%         type => RewardTimes,
%         supervip_state => SupVipTpye,
%         level_up => UpLv,
%         cost_gold => CostGold
%     },
%     ta_agent:track(Player, onhook_fast, OtherProperties),
%     ok.

% %% 玩家rfmt数据(充值相关)
% charge_rfmt(Player, Rfmt) ->
%     RfmtBin = util:term_to_bitstring(Rfmt),
%     UserProperties = #{
%         charge_rfmt => RfmtBin
%     },
%     ta_agent:user_set(Player, UserProperties),
%     ok.

%% 玩家累计充值金额
total_pay_amount(Player, Now, NewTotalMoney) ->
    UserProperties = #{
        total_pay_amount => NewTotalMoney
    },
    ta_agent:user_set(Player, UserProperties, normal, Now),
    ok.

%% 定制活动
log_custom_act_reward(Player, [Type, Subtype, RewardIdList]) when is_list(RewardIdList) ->
    [log_custom_act_reward(Player, [Type, Subtype, RewardId])||RewardId<-RewardIdList],
    ok;
log_custom_act_reward(Player, [Type, Subtype, RewardId]) ->
    OtherProperties = #{
        custom_act_type => Type,
        custom_act_subtype => Subtype,
        reward_id => RewardId
    },
    ta_agent:track(Player, log_custom_act_reward, OtherProperties, normal, utime:unixtime()),
    ok.

%% 金币消耗
log_consume_coin(PS, [CostAmount, ProductType]) ->
    #player_status{
        coin = Coin
    } = PS,
    OtherProperties = #{
        cost_amount => CostAmount,
        change_after => Coin,
        consume_type => ProductType
    },
    ta_agent:track(PS, log_consume_coin, OtherProperties, normal, utime:unixtime()),
    ok.

%% 金币产出
log_produce_coin(PS, [AddAmount, ProductType]) ->
    #player_status{
        coin = Coin
    } = PS,
    OtherProperties = #{
        get_amount => AddAmount,
        change_after => Coin,
        get_type => ProductType
    },
    ta_agent:track(PS, log_produce_coin, OtherProperties, normal, utime:unixtime()),
    ok.

%% 特殊货币消耗
log_consume_currency(PS, [CurrencyId, CostAmount, ProductType]) ->
    #player_status{
        currency_map = CMap
    } = PS,
    case is_map(CMap) of
        true -> Currency = maps:get(CurrencyId, CMap, 0);
        false -> Currency = 0
    end,
    OtherProperties = #{
        currency_id => CurrencyId,
        cost_amount => CostAmount,
        change_after => Currency,
        consume_type => ProductType
    },
    ta_agent:track(PS, log_consume_currency, OtherProperties, normal, utime:unixtime()),
    ok.

%% 特殊货币产出
log_produce_currency(PS, [CurrencyId, AddAmount, ProductType]) ->
    #player_status{
        currency_map = CMap
    } = PS,
    case is_map(CMap) of
        true -> Currency = maps:get(CurrencyId, CMap, 0);
        false -> Currency = 0
    end,
    OtherProperties = #{
        currency_id => CurrencyId,
        get_amount => AddAmount,
        change_after => Currency,
        get_type => ProductType
    },
    ta_agent:track(PS, log_produce_currency, OtherProperties, normal, utime:unixtime()),
    ok.

%% 等级抢购活动
log_level_act(Player, [Type, Subtype, Grade, Cost]) ->
    case Cost of
        [{CostType, _, CostNum}|_] -> ok;
        _ -> CostType = 0, CostNum = 0
    end,
    OtherProperties = #{
        level_act_type => Type,
        level_act_subtype => Subtype,
        grade => Grade,
        cost_type => CostType,
        cost_num => CostNum
    },
    ta_agent:track(Player, log_level_act, OtherProperties, normal, utime:unixtime()),
    ok.

%%% ===============
%%% 羁绊
%%% ===============

%% 姻缘关系
marriage_state(PS, OtherRId, Type) ->
    #player_status{id = RoleId} = PS,
    [{_, _, Intimacy}] = lib_relationship:get_rela_and_intimacy_online(RoleId, [OtherRId]),
    Properties = #{
        friend_id => OtherRId,
        marriage_type => var_mate_type(Type),
        intimacy => Intimacy
    },
    ta_agent:track(PS, marriage_state, Properties),
    PS.

%%% ===============
%%% 特权卡购买
%%% ===============

%% 周卡购买
weekly_card_buy(PS, RechargeData) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #callback_recharge_data{
        money = BuyCost
    } = RechargeData,
    #weekly_card_status{
        expired_time = ExpiredTime
    } = WeeklyCardStatus,
    BuyCount = mod_counter:get_count_offline(RoleId, ?MOD_WEEKLY_CARD, ?MOD_WEEKLY_CARD_BUY_COUNT),
    ValidDays = ExpiredTime div ?ONE_DAY_SECONDS,
    Properties = #{
        buy_count => BuyCount,
        valid_days => ValidDays,
        buy_cost => BuyCost
    },
    ta_agent:track(PS, weekly_card_buy, Properties),
    PS.

%% 月卡购买
monthly_card_buy(PS) ->
    #player_status{id = RoleId} = PS,
    RechargeId = ?MONTH_CARD_RECHARGE_ID,
    BuyCount = mod_counter:get_count_offline(RoleId, ?MOD_INVESTMENT, ?MOD_INVESTMENT_MONTHLY_CARD_BUY_COUNT),
    ValidDays = ?MONTH_CARD_EFFECTIVE_TIME,
    #base_recharge_product{money = BuyCost} = data_recharge:get_product(RechargeId),
    Properties = #{
        buy_count => BuyCount,
        valid_days => ValidDays,
        buy_cost => BuyCost
    },
    ta_agent:track(PS, monthly_card_buy, Properties),
    PS.

%% vip购买
vip_card_buy(PS, VipType, Price) ->
    NowTime = utime:unixtime(),
    #player_status{vip = RoleVip} = PS,
    #role_vip{vip_card_list = VipCardList} = RoleVip,
    #vip_card{end_time = EndTime} = ulists:keyfind(VipType, #vip_card.vip_type, VipCardList, #vip_card{}),
    Properties = #{
        vip_type => var_vip_type(VipType),
        valid_days => (EndTime - NowTime) div ?ONE_DAY_SECONDS,
        buy_cost => Price
    },
    ta_agent:track(PS, vip_card_buy, Properties),
    PS.

%% 至尊vip激活
log_supvip_active(Player, [ActiveType, SupVipType, SupvipTime]) ->
    OtherProperties = #{
        active_type => ActiveType,
        supvip_type => SupVipType,
        ex_end_time => SupvipTime
    },
    ta_agent:track(Player, log_supvip_active, OtherProperties, normal, utime:unixtime()),
    ok.

%% 至尊vip技能任务
log_supvip_skill_task(Player, [Stage, SubStage, TaskId]) ->
    OtherProperties = #{
        supvip_stage => Stage,
        supvip_sub_stage => SubStage,
        task_id => TaskId
    },
    ta_agent:track(Player, log_supvip_skill_task, OtherProperties, normal, utime:unixtime()),
    ok.

%% 至尊vip至尊币任务
log_supvip_currency_task(Player, [TaskId]) ->
    OtherProperties = #{
        task_id => TaskId
    },
    ta_agent:track(Player, log_supvip_currency_task, OtherProperties, normal, utime:unixtime()),
    ok.

%% 结界守护挑战
log_enchantment_guard_battle(Player, [PassGate]) ->
    OtherProperties = #{
        guard_pass_gate => PassGate
    },
    ta_agent:track(Player, log_enchantment_guard_battle, OtherProperties, normal, utime:unixtime()),
    ok.

%% 结界守护封印
log_enchantment_guard_seal(Player, [SealTimes, CurGate]) ->
    OtherProperties = #{
        seal_times => SealTimes,
        cur_guard_gate => CurGate
    },
    ta_agent:track(Player, log_enchantment_guard_seal, OtherProperties, normal, utime:unixtime()),
    ok.

%% 结界守护扫荡
log_enchantment_guard_sweep(Player, [SwapTimes, CurGate]) ->
    OtherProperties = #{
        swap_count => SwapTimes,
        cur_guard_gate => CurGate
    },
    ta_agent:track(Player, log_enchantment_guard_sweep, OtherProperties, normal, utime:unixtime()),
    ok.

%% 冲级豪礼
log_rush_giftbag(Player, [Sex, BagLv, BagNum]) ->
    OtherProperties = #{
        sex => Sex,
        rush_gift_lv => BagLv,
        rush_gift_num => BagNum
    },
    ta_agent:track(Player, log_rush_giftbag, OtherProperties, normal, utime:unixtime()),
    ok.
    %% lib_player:apply_cast(4294967301, 2, ta_agent_fire, log_achv, [[1,1]]).

%% 成就
log_achv(Player, [AchieveId, AchievePoints]) ->
    OtherProperties = #{
        achieve_id => AchieveId,
        achieve_points => AchievePoints
    },
    ta_agent:track(Player, log_achv, OtherProperties, normal, utime:unixtime()),
    ok.

% %% 物品拍卖成功或物品下架时记录
% %% auction_type:1公开交易，2指定交易
% %% option_type:1成交（主体记买家），2主动下架，3超时下架
% auction_state(Player, {MarketGoods, OptionType, Tax}) ->
%     OtherProperties = #{
%         auction_type => market_api:get_sell_type(MarketGoods),
%         option_type => OptionType,
%         market_sell_type => MarketGoods#sell_goods.type,
%         market_sell_sub_type => MarketGoods#sell_goods.sub_type,
%         goods_color => MarketGoods#sell_goods.color,
%         goods_id => MarketGoods#sell_goods.goods_type_id,
%         goods_num => MarketGoods#sell_goods.num,
%         equip_series => MarketGoods#sell_goods.stage,
%         equip_career => var_career_type(MarketGoods#sell_goods.career),
%         tax => round(Tax * 100),
%         origin_price => MarketGoods#sell_goods.price,
%         shelves_time => MarketGoods#sell_goods.time
%     },
%     ta_agent:track(Player, auction_state, OtherProperties),
%     Player.

% %% 无尽领域
% void_fam(Player, [MaxFloor, Score, DieNum, StayTime]) ->
%     OtherProperties = #{
%         max_floor => MaxFloor,
%         score => Score,
%         revive_times => DieNum,
%         use_time => StayTime
%     },
%     ta_agent:track(Player, void_fam, OtherProperties),
%     ok.

% %% 多人讨伐副本
% multi_dungeon(Player, [MaxRating, DunId, ResultSubType, PassTime, SingleMode, PlayerNum, RobotNum, AssistNum, MergeTimes]) ->
%     OtherProperties = #{
%         dun_type => DunId,
%         is_single_mode => SingleMode,
%         player_num => PlayerNum,
%         robot_num => RobotNum,
%         assist_num => AssistNum,
%         result_subtype => ResultSubType,
%         dun_star => MaxRating,
%         use_time => PassTime,
%         merge_times => MergeTimes
%     },
%     ta_agent:track(Player, multi_dungeon, OtherProperties),
%     ok.

% %% 守卫信标
% guard_dungeon(Player,
%     [ReviveCount, IsLeader, PlayerNum, RobotNum, PowerNeed, DunId, Role2Power, Role3Power, ResultSubType, PassTime, DunWave, HpTop, HpMid, HpBot, IsAssist, Assist]) ->
%     OtherProperties = #{
%         dun_type => DunId,
%         player_num => PlayerNum,
%         robot_num => RobotNum,
%         is_captain => IsLeader,
%         power_need => PowerNeed,
%         power_player2 => Role2Power,
%         power_player3 => Role3Power,
%         result_subtype => ResultSubType,
%         dun_wave_aft => DunWave,
%         hp_top => HpTop,
%         hp_mid => HpMid,
%         hp_bot => HpBot,
%         revive_times => ReviveCount,
%         use_time => PassTime,
%         is_assist => IsAssist,
%         assist_score => Assist
%     },
%     ta_agent:track(Player, guard_dungeon, OtherProperties),
%     ok.

% %% 社团采集
% guild_seal(Player, [EnterRec, CollectCount, AssistCount, StayTime]) ->
%     OtherProperties = #{
%         is_count_down => EnterRec,
%         collet_times => CollectCount,
%         assist_times => AssistCount,
%         use_time => StayTime
%     },
%     ta_agent:track(Player, guild_seal, OtherProperties),
%     ok.

% %% 赏金boss
% ta_gold_boss_belong(Player, [BossId, Grade, Level, BossLv, BossSeries, IsFirstKill, InspireTicket, InspireBGold, InspireGold, ReviveCount, TeamRoleNum, SupportNum,
%  HurtPercent, TeamRank, UseTime]) ->
%     OtherProperties = #{
%         boss_id => BossId,
%         boss_lv => BossLv,
%         boss_stage => Grade,
%         floor => Level,
%         boss_series => BossSeries,
%         is_first_kill => IsFirstKill,
%         inspire_ticket => InspireTicket,
%         inspire_bgold => InspireBGold,
%         inspire_gold => InspireGold,
%         revive_times => ReviveCount,
%         team_num => TeamRoleNum,
%         assist_num => SupportNum,
%         damage_percent => HurtPercent,
%         damage_rank => TeamRank,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, gold_boss_belong, OtherProperties),
%     ok.

% %% 废都boss
% ta_deserted_boss_belong(Player, [BossId, BossLv, Grade, ReviveCount, TeamRoleNum,
%  HurtPercent, Rank, UseTime]) ->
%     OtherProperties = #{
%         boss_id => BossId,
%         boss_lv => BossLv,
%         boss_stage => Grade,
%         revive_times => ReviveCount,
%         team_num => TeamRoleNum,
%         damage_percent => HurtPercent,
%         damage_rank => Rank,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, deserted_boss_belong, OtherProperties),
%     ok.

% %% 单人boss(副本)
% single_boss_belong(Player, [Mid, MinLv, Grade, RatingStr, ReviveCount, UseTime]) ->
%     OtherProperties = #{
%         boss_id => Mid,
%         boss_lv => MinLv,
%         boss_stage => Grade,
%         result => RatingStr,
%         revive_times => ReviveCount,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, single_boss_belong, OtherProperties),
%     ok.

% mystery_boss_belong(Player, [BossId, BossLv, BossStage, BossFtg, UseTime]) ->
%     OtherProperties = #{
%         boss_id => BossId,
%         boss_lv => BossLv,
%         boss_stage => BossStage,
%         boss_ftg => BossFtg,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, mystery_boss_belong, OtherProperties),
%     ok.

% mystery_boss_exit(Player, [BossNum, MobsNum, IntoTimes, Ftg, ReviveTime]) ->
%     OtherProperties = #{
%         boss_num => BossNum,
%         mobs_num => MobsNum,
%         into_times => IntoTimes,
%         ftg => Ftg,
%         revive_times => ReviveTime
%     },
%     ta_agent:track(Player, mystery_boss, OtherProperties),
%     ok.

% %% 星域争霸挑战
% cross_point_fight(Player, [DunId, Type, GetPoint]) ->
%     case data_dungeon:get_dun(DunId) of
%         #dun_cfg{type = DunType, name = Name} ->
%             #player_status{guild = #status_guild{id = GuildId}} = Player,
%             OtherProperties = #{
%                 dun_type => DunType,
%                 dun_name => Name,
%                 guild_id => GuildId,
%                 country_id => czone_api:env_get_faction(),
%                 challenge_type => Type,
%                 get_point => GetPoint,
%                 current_point => lib_role_legion:get_legion(Player),
%                 left_activity => lib_role_legion:get_process(Player)
%             },
%             ta_agent:track(Player, cross_point_fight, OtherProperties);
%         _ ->
%             ignore
%     end,
%     ok.

% home_boss_belong(Player, [BossId, BossLv, BossSeries, TeamNum, HomeType, Floor, ReviveTimes, DamagePercent, DamegeRank, UseTime]) ->
%     HomeStr =
%     if HomeType == 1 -> <<"公共"/utf8>>;
%         HomeType == 2 -> <<"社团"/utf8>>;
%         true -> <<"公共"/utf8>>
%     end,
%     OtherProperties = #{
%         boss_id => BossId,
%         boss_lv => BossLv,
%         boss_stage => BossSeries,
%         team_num => TeamNum,
%         home_type => HomeStr,
%         floor => Floor,
%         revive_times => ReviveTimes,
%         damage_percent => DamagePercent,
%         damage_rank => DamegeRank,
%         use_time => UseTime
%     },
%     ta_agent:track(Player, boss_home_belong, OtherProperties),
%     ok.

% %% 转职
% role_transform(Player, [Turn, Type, TaskId]) ->
%     OtherProperties = #{
%         transform_id => Turn,
%         transform_type => Type,
%         task_id => TaskId
%     },
%     ta_agent:track(Player, role_transform, OtherProperties),
%     ok.

% %% 完成天书秘卷任务/整章时记录
% eternal_valley(Player, Chapter, Stage) ->
%     #player_status{reg_time = RegTime} = Player,
%     OtherProperties = #{
%         days => utime:diff_day(RegTime) + 1,
%         mod_id => Chapter,
%         sub_id => Stage
%     },
%     ta_agent:track(Player, eternal_valley, OtherProperties),
%     ok.

%%


get_daily_active_properties(Player) ->
    #player_status{id = RoleId} = Player,
    [
        {_, Activity},
        {_, NineBattle},
        {_, BeingsGate},
        {_, Jjc},
        {_, MidParty},
        {_, DailyTask},
        {_, GuildTask},
        {_, NightGhost},
        {_, HolyBattle},
        {_, TopPk},
        {_, GuildFeast},
        {_, ForbidBoss},
        {_, WorldBoss},
        {_, DomainBoss},
        {_, EquipDungeon},
        {_, VipDungeon},
        {_, CounpleDungeon},
        {_, ExpDungeon},
        {_, WeeklyGiftGet},
        {_, PartnerNewDungeon},
        {_, PartnerNewSweep},
        {_, CoinDungeon},
        {_, SpiritDungeon},
        {_, MountDungeon},
        {_, WingDungeon},
        {_, AmuletDungeon},
        {_, WeaponDungeon},
        {_, BackDungeon},
        {_, KfGreatDemon}
    ] = mod_daily:get_count_offline(RoleId,
        [
            {?MOD_ACTIVITY, 0, ?ACTIVITY_LIVE_DAILY}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_NINE, 0)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_BEINGS_GATE, 1)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_JJC, 0)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_MIDDAY_PARTY, 1)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_TASK, 1)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_TASK, 2)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_NIGHT_GHOST, 1)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_HOLY_SPIRIT_BATTLEFIELD, 0)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_TOPPK, 0)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_BOSS, ?BOSS_TYPE_FORBIDDEN)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_BOSS, ?BOSS_TYPE_NEW_OUTSIDE)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_BOSS, ?BOSS_TYPE_DOMAIN)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_DUNGEON, ?DUNGEON_TYPE_EQUIP)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_DUNGEON, ?DUNGEON_TYPE_VIP_PER_BOSS)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_DUNGEON, ?DUNGEON_TYPE_COUPLE)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_DUNGEON, ?DUNGEON_TYPE_EXP_SINGLE)}
            , {?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_BOSS, ?BOSS_TYPE_KF_GREAT_DEMON)}
            , {?MOD_WEEKLY_CARD, ?DEFAULT_SUB_MODULE, ?MOD_WEEKLY_CARD_DAILY_GIFT}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_PARTNER_NEW}
            , {?MOD_DUNGEON, ?DEFAULT_SUB_MODULE, 12}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_COIN}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_SPRITE_MATERIAL}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_MOUNT_MATERIAL}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_WING_MATERIAL}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_AMULET_MATERIAL}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_WEAPON_MATERIAL}
            , {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, ?DUNGEON_TYPE_BACK_ACCESSORIES}
        ]
    ),
    #{
        active_degree => Activity,
        nine_battle => NineBattle,
        beings_gate => BeingsGate,
        jjc => Jjc,
        mid_party => MidParty,
        daily_task => DailyTask,
        guild_task => GuildTask,
        night_ghost => NightGhost,
        holy_battle => HolyBattle,
        top_pk => TopPk,
        guild_feast => GuildFeast,
        forbid_boss => ForbidBoss,
        world_boss => WorldBoss,
        domain_boss => DomainBoss,
        equip_dungeon => EquipDungeon,
        vip_dungeon => VipDungeon,
        couple_dungeon => CounpleDungeon,
        exp_dungeon => ExpDungeon,
        get_weekly_gift => WeeklyGiftGet,
        partner_new_dungeon => PartnerNewDungeon + PartnerNewSweep,
        coin_dungeon => CoinDungeon,
        spirit_dungeon => SpiritDungeon,
        mount_dungeon => MountDungeon,
        wing_dungeon => WingDungeon,
        amulet_dungeon => AmuletDungeon,
        weapon_dungeon => WeaponDungeon,
        resource_dungeon => CoinDungeon + SpiritDungeon + MountDungeon + WingDungeon + AmuletDungeon + WeaponDungeon
    }.

get_daily_attr_properties(RoleId) ->
    [
        {_, OnlineTime},
        {_, GoldGet},
        {_, BGoldGet},
        {_, GoldConsume},
        {_, BGoldConsume},
        {_, OnhookCoinGet},
        {_, OnhookCoinConsume}
    ] = mod_daily:get_count_offline(RoleId,
        [
            {?MOD_BASE, ?DEFAULT_SUB_MODULE, ?MOD_BASE_DAILY_ONLINE_TIME},
            {?MOD_GOODS, ?MOD_GOODS_DAILY_GET, ?TYPE_GOLD},
            {?MOD_GOODS, ?MOD_GOODS_DAILY_GET, ?TYPE_BGOLD},
            {?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_GOLD},
            {?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_BGOLD},
            {?MOD_ACT_ONHOOK, ?DEFAULT_SUB_MODULE, ?MOD_ACT_ONHOOK_COIN_DAILY_GET},
            {?MOD_ACT_ONHOOK, ?DEFAULT_SUB_MODULE, ?MOD_ACT_ONHOOK_COIN_DAILY_CONSUME}
        ]
    ),
    #{
        total_online_time => OnlineTime,
        get_gold => GoldGet,
        get_bgold => BGoldGet,
        consume_gold => GoldConsume,
        consume_bgold => BGoldConsume,
        get_onhook_coin => OnhookCoinGet,
        consume_onhook_coin => OnhookCoinConsume
    }.

%% -------------------------------------------------------
%% TA系统属性值定义 - 开始
%% 相关事件属性值不多，暂时先硬编码到代码中，如有必要再统一改配置
%% 海外版翻译可排除本模块，函数名通常以“val_”为前缀
%% -------------------------------------------------------
%% 登录类型
val_login_type(?RE_LOGIN)  -> <<"重连"/utf8>>;
val_login_type(_Reconnect) -> <<"登录"/utf8>>.

%% 网络类型
val_network(?NETWORK_WIFI)      -> <<"WIFI">>;
val_network(?NETWORK_MOBILE)    -> <<"移动网络"/utf8>>;
val_network(_)                  -> <<"未知网络"/utf8>>.

%% 登出类型
val_logout_type(?LOGOUT_LOG_NORMAL)      -> <<"正常退出"/utf8>>;
val_logout_type(?LOGOUT_LOG_ERROR)       -> <<"异常退出"/utf8>>;
val_logout_type(?LOGOUT_LOG_SERVER_STOP) -> <<"停服退出"/utf8>>;
% val_logout_type(?LOGOUT_LOG_LIMIT_LOGIN) -> <<"停服退出"/utf8>>;
val_logout_type(role_simu_logout)        -> <<"0点截断"/utf8>>;
val_logout_type(_LogNormalOrErr)         -> <<"其他"/utf8>>.

%% 羁绊操作类型
var_mate_type(?TA_MARRIAGE_APPLY)  -> <<"申请结婚"/utf8>>;
var_mate_type(?TA_MARRIAGE_BUILD)  -> <<"建立婚姻"/utf8>>;
var_mate_type(?TA_MARRIAGE_DIVORCE_FORCE)  -> <<"强制离婚"/utf8>>;
var_mate_type(?TA_MARRIAGE_DIVORCE_PROTO)  -> <<"协议离婚"/utf8>>.

%% 任务操作类型
var_task_type(1)  -> <<"领取任务"/utf8>>;
var_task_type(_)  -> <<"任务完成"/utf8>>.

%% 任务类型
var_task(?TASK_TYPE_MAIN)     -> <<"主线任务"/utf8>>;
var_task(?TASK_TYPE_SIDE)     -> <<"支线任务"/utf8>>;
var_task(?TASK_TYPE_TURN)     -> <<"转生任务"/utf8>>;
var_task(?TASK_TYPE_CHAPTER)  -> <<"章节任务"/utf8>>;
var_task(?TASK_TYPE_GUILD)    -> <<"公会周任务"/utf8>>;
var_task(?TASK_TYPE_DAILY)    -> <<"日常支线任务"/utf8>>;
var_task(?TASK_TYPE_DAY)    -> <<"日常悬赏任务"/utf8>>;
var_task(?TASK_TYPE_DAILY_EUDEMONS)    -> <<"日常圣兽领任务"/utf8>>;
var_task(?TASK_TYPE_SANCTUARY_KF)    -> <<"跨服圣域阶段任务"/utf8>>;
var_task(_)  -> <<"无"/utf8>>.

%% 战魂操作类型
var_warsoul_type(1)  -> <<"英灵上阵"/utf8>>;
var_warsoul_type(2)  -> <<"英灵觉醒进化"/utf8>>;
var_warsoul_type(3)  -> <<"英灵替换"/utf8>>;
var_warsoul_type(_)  -> <<"无"/utf8>>.


%% 商店
var_shop_type(quick_shop, _)  -> <<"快速购买商城"/utf8>>;
var_shop_type(shop, 1)  -> <<"每周限购商城"/utf8>>;
var_shop_type(shop, 2)  -> <<"钻石商城"/utf8>>;
var_shop_type(shop, 3)  -> <<"绑钻商城"/utf8>>;
var_shop_type(shop, 4)  -> <<"外观商城"/utf8>>;
var_shop_type(shop, 5)  -> <<"常用道具"/utf8>>;
var_shop_type(shop, 6)  -> <<"荣耀商城"/utf8>>;
var_shop_type(shop, 7)  -> <<"领地商城"/utf8>>;
var_shop_type(shop, 8)  -> <<"勋章商城"/utf8>>;
var_shop_type(shop, 9)  -> <<"3v3商城"/utf8>>;
var_shop_type(shop, 10)  -> <<"至尊vip商城"/utf8>>;
var_shop_type(shop, 11)  -> <<"圣兽领商店"/utf8>>;
var_shop_type(shop, 12)  -> <<"跟人排行本商店"/utf8>>;
var_shop_type(shop, 13)  -> <<"幸运商店"/utf8>>;
var_shop_type(shop, 14)  -> <<"龙语商店"/utf8>>;
var_shop_type(shop, 15)  -> <<"神庭商店"/utf8>>;
var_shop_type(shop, 16)  -> <<"荣耀商城"/utf8>>;
var_shop_type(shop, 17)  -> <<"声望商店"/utf8>>;
var_shop_type(shop, 18)  -> <<"百鬼夜行"/utf8>>;
var_shop_type(_, _)  -> <<"无"/utf8>>.

%% 装备职业
var_career_type(1)  -> <<"男性"/utf8>>;
var_career_type(2)  -> <<"女性"/utf8>>;
var_career_type([1])  -> <<"男性"/utf8>>;
var_career_type([2])  -> <<"女性"/utf8>>;
var_career_type(_)  -> <<"通用"/utf8>>.

%% vip特权卡
var_vip_type(1) -> <<"vip1"/utf8>>;
var_vip_type(2) -> <<"vip2"/utf8>>;
var_vip_type(4) -> <<"vip4"/utf8>>;
var_vip_type(_) -> <<""/utf8>>.

var_welfare_type(1) -> <<"购买"/utf8>>;
var_welfare_type(2) -> <<"领奖"/utf8>>;
var_welfare_type(_) -> <<""/utf8>>.


%% 服类型 base_game.server_type
var_server_type(?SERVER_TYPE_OFFICIAL) -> <<"正式服"/utf8>>;
var_server_type(?SERVER_TYPE_TEST) -> <<"测试服"/utf8>>;
var_server_type(?SERVER_TYPE_SHENHE) -> <<"审核服"/utf8>>;
var_server_type(_) -> <<"无设置"/utf8>>.

%% -------------------------------------------------------
%% TA系统属性值定义 - 结束
%% 此部分在最后，其他接口添加请放在“TA系统属性值定义”之前
%% -------------------------------------------------------


%% -------------------------------------------------------
%% 测试
%% -------------------------------------------------------

%% 获取事件类型中不存在的key值，方便添加
get_no_exist_by_event_type(EventType) ->
    EventKeys = data_ta_properties:event_keys(EventType),
    [Key||Key<-EventKeys, data_ta_properties:property_data_type(Key)==undefined].


%% -------------------------------------------------------
%% 禁止下面新增代码
%% -------------------------------------------------------
