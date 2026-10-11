%% ---------------------------------------------------------------------------
%% @doc lib_supreme_vip_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-07-29
%% @deprecated 至尊vip的接口
%% ---------------------------------------------------------------------------
-module(lib_supreme_vip_api).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("supreme_vip.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("boss.hrl").
-include("battle.hrl").
-include("drop.hrl").
-include("attr.hrl").

%% 是否有至尊vip
is_supvip_from_db(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_type_select, [RoleId]),
    case db:get_row(Sql) of
        [SupvipType, SupvipTime] -> lib_supreme_vip:is_supvip(SupvipType, SupvipTime);
        _ -> 0
    end.

%% 获得被动技能
get_passive_skill(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{passive_skills = PassiveSkills} = StatusSupVip,
    PassiveSkills.

%% 充值
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) ->
    case CallBackData of
        #callback_recharge_data{gold = Gold, recharge_product = Product} ->
            RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
            if
                RealGold > 0 ->
                    PlayerAfDay = lib_supreme_vip:handle_charge_day(Player, RealGold),
                    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(PlayerAfDay, ?SUPVIP_SKILL_TASK_RECHARGE, {add, RealGold}),
                    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(PlayerAfSkill, ?SUPVIP_CURRENCY_TASK_RECHARGE, {add, RealGold}),
                    PlayerAfReturn = lib_supreme_vip:return_currency(PlayerAfCurrency, RealGold),
                    {ok, PlayerAfReturn};
                true -> {ok, Player}
            end;
        _ ->
            {ok, Player}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
    %% 消耗钻石加vip经验，排除的消耗类型列表
    IgnoreTypeList = [pay_sell, pay_tax, seek_goods],
    #callback_money_cost{cost = Gold, money_type = MoneyType, consume_type = CosumeType} = Data,
    case lists:member(CosumeType, IgnoreTypeList) of
        true -> {ok, Player};
        false ->
            case MoneyType of
                ?GOLD -> cost_gold(Player, Gold);
                _ -> {ok, Player}
            end
    end;

%% 转生
handle_event(Player, #event_callback{type_id = ?EVENT_TURN_UP}) ->
    #player_status{figure = #figure{turn = Turn}} = Player,
    {ok, PlayerAfEvent} = turn_event(Player, Turn),
    {ok, PlayerAfEvent};

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%% 装备强化
equip_stren_event(Player, _Data) ->
    PlayerAfSkillTmp = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_EQUIP_STREN, trigger),
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(PlayerAfSkillTmp, ?SUPVIP_SKILL_TASK_EQUIP_STREN_SUM, trigger),
    {ok, PlayerAfSkill}.

%% 培养
train_something(Player, TypeId, _Stage, _Star) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_TRAIN, {trigger, TypeId}),
    {ok, PlayerAfSkill}.

%% 触发副本
trigger_dun(Player, DunType, _DunId) ->
    case DunType of
        ?DUNGEON_TYPE_ENCHANTMENT_GUARD -> {ok, Player};
        _ -> 
            if
                % DunType == ?DUNGEON_TYPE_RUNE2 ->
                %     Level = lib_dungeon_api:get_dungeon_level(Player, DunType),
                %     ?MYLOG("hjhsupvipskill", "================Level:~p ~n", [Level]),
                %     {ok, PlayerAfLevel} = fin_dun_level(Player, DunType, Level);
                true ->
                    PlayerAfLevel = Player
            end,
            fin_dun(PlayerAfLevel, DunType)
    end.

%% 通关符文本第N层
fin_dun_level(RoleId, DunType, Level) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, fin_dun_level, [DunType, Level]),
    ok;
fin_dun_level(Player, DunType, _Level) ->
    if
        DunType == ?DUNGEON_TYPE_RUNE2 ->
            PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_RUNE_DUN, trigger),
            {ok, PlayerAfSkill};
        true ->
            {ok, Player}
    end.

%% 完成副本
fin_dun(Player, DunType) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DUN_COUNT, {more, 1, DunType}),
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(PlayerAfSkill, ?SUPVIP_CURRENCY_TASK_DUN_COUNT, {more, 1, DunType}),
    {ok, PlayerAfCurrency}.

%% 勋章提升
upgrade_medal(Player, _MedadlId) ->
    ?PRINT("_MedadlId ~p ~n", [_MedadlId]),
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_MEDAL_ID, trigger),
    {ok, PlayerAfSkill}.

%% 购买副本
buy_dun(Player, DunType, Count) ->
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_BUY_DUN, {more, Count, DunType}),
    {ok, PlayerAfCurrency}.

%% 击杀boss
cluster_kill_boss(#battle_return_atter{sign = Sign, id = AtterId, node = AtterNode}, BLWhos, MonSys, MonLv) ->
    % 只针对部分boss,防止频繁
    IsMember = lists:member(MonSys, [?MON_SYS_BOSS_TYPE_PHANTOM]),
    if
        IsMember == false -> skip;
        BLWhos == [] andalso Sign == ?BATTLE_SIGN_PLAYER -> 
            Args = [AtterId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, kill_boss, [MonSys, MonLv]],
            mod_clusters_center:apply_cast(AtterNode, lib_player, apply_cast, Args);
        true -> 
            [begin
                Args = [RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, kill_boss, [MonSys, MonLv]],
                mod_clusters_center:apply_cast(Node, lib_player, apply_cast, Args)
            end||#mon_atter{id = RoleId, node = Node}<-BLWhos]
    end.

%% 击杀boss
kill_boss(#battle_return_atter{sign = Sign, id = AtterId}, BLWhos, MonSys, MonLv) ->
    % 只针对部分boss,防止频繁
    IsMember = lists:member(MonSys, [?MON_SYS_BOSS_TYPE_NEW_OUTSIDE, ?MON_SYS_BOSS_TYPE_ABYSS, ?MON_SYS_BOSS_TYPE_DOMAIN]),
    if
        IsMember == false -> skip;
        BLWhos == [] andalso Sign == ?BATTLE_SIGN_PLAYER -> lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, kill_boss, [MonSys, MonLv]);
        true -> [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, kill_boss, [MonSys, MonLv])||#mon_atter{id = RoleId}<-BLWhos]
    end.

kill_boss(Player, MonSys, MonLv) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_KILL_BOSS, {more_lv, 1, MonLv, MonSys}),
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(PlayerAfSkill, ?SUPVIP_CURRENCY_TASK_KILL_BOSS, {more, 1, MonSys}),
    {ok, PlayerAfCurrency}.

%% 转生
turn_event(Player, _Turn) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_TURN, trigger),
    {ok, PlayerAfSkill}.

%% 坐骑/伙伴装备
mount_equip_event(RoleId, TypeId) when is_integer(RoleId) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, mount_equip_event, [TypeId]),
    ok;
mount_equip_event(Player, TypeId) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_MOUNT_EQUIP, {trigger, TypeId}),
    {ok, PlayerAfSkill}.

%% 激活N本契约之书
eternal_valley_event(RoleId) when is_integer(RoleId) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, eternal_valley_event, []),
    ok;
eternal_valley_event(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_ETERNAL_VALLEY, trigger),
    {ok, PlayerAfSkill}.

%% 成就
achv_lv(RoleId, Stage) when is_integer(RoleId) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, achv_lv, [Stage]),
    ok;
achv_lv(Player, _Stage) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_ACHI_LV, trigger),
    {ok, PlayerAfSkill}.

%% 激活M功能(坐骑,伙伴,法阵...)N个幻化外形
mount_acti_figure_event(Player, TypeId, _Id) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_MOUNT_FIGURE, {trigger, TypeId}),
    {ok, PlayerAfSkill}.

%% 装备M品质Y类型N个龙纹##{13,N,M,Y}##{13,N}##{13,N}
dragon_equip_event(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DRAGON_EQUIP, trigger),
    {ok, PlayerAfSkill}.

%% 宝宝培养至N级##{14,N}##{14,N}##{14,N}
baby_raise_up(Player, _RaiseLv) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_BABY_LV, trigger),
    {ok, PlayerAfSkill}.

%% N件装备神装打造至M级#{15,N,M}##{15,N}##{15,N}
god_equip(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_GOD_EQUIP, trigger),
    {ok, PlayerAfSkill}.

%% 激活N个降神##{16,N}##{16,N}##{16,N}
active_god(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_GOD_NUM, trigger),
    {ok, PlayerAfSkill}.

%% 任意幻饰升至N阶##{17,N}##{17,N}##{17,N}
decoration_equip(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DECORATION_STAGE, trigger),
    {ok, PlayerAfSkill}.

%% 购买N类型投资##{18,N}##{18,N}##{18,N} 
buy_investment(Player, _Type) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_INVESTMENT, trigger),
    {ok, PlayerAfSkill}.

%% 宝宝N个幻化外形##{19,N}##{19,N}##{19,N}
baby_active_figure(Player, _BabyId) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_BABY_FIGURE, trigger),
    {ok, PlayerAfSkill}.

%% 穿戴粉红色装备N件##{20,N}##{20,N}##{20,N}
wear_equip_event(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_PINK_EQUIP, trigger),
    {ok, PlayerAfSkill}.

%% 激活任意天启N件套##{21,N}##{21,N}##{21,N}
%% 激活M类型天启套装N件##{22,N,M}##{22,N}##{22,N}
revelation_equip(Player) ->
    PlayerAfSkill1 = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_REVELATION_EQUIP, trigger),
    PlayerAfSkill2 = lib_supreme_vip:trigger_skill_task(PlayerAfSkill1, ?SUPVIP_SKILL_TASK_REVELATION_EQUIP_SUIT, trigger),
    {ok, PlayerAfSkill2}.

%% 激活N个使魔##{23,N}##{23,N}##{23,N}
active_demons(Player, _DemonsId) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DEMONS, trigger),
    {ok, PlayerAfSkill}.

%% 装备M品质使魔技能N种##{24,N,M}##{24,N}##{24,N}
equip_demons_skill(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DEMONS_SKILL, trigger),
    {ok, PlayerAfSkill}.

%% 累计登录N天##{25,N}##{25,N}##{25,N}
trigger_login_days(Player, _LoginDays) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_LOGIN_DAYS, trigger),
    {ok, PlayerAfSkill}.

%% 进入boss
enter_boss(RoleId, BossType, BossId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, enter_boss, [BossType, BossId]),
    ok;
enter_boss(Player, BossType, _BossId) ->
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_ENTER, {more, 1, BossType}),
    {ok, PlayerAfCurrency}.

%% 护送N次
fin_husong(Player, Count) ->
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_HUSONG, {add, Count}),
    {ok, PlayerAfCurrency}.

%% 消耗金钱
cost_gold(Player, Gold) ->
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_COST, {add, Gold}),
    {ok, PlayerAfCurrency}.

%% 参与N次永恒圣殿玩法
enter_sanctum(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, enter_sanctum, []),
    ok;
enter_sanctum(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_SANCTUM, {add, 1}),
    {ok, PlayerAfSkill}.

%% 激活伙伴
active_companion(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, active_companion, []),
    ok;
active_companion(Player) ->
    PlayerAfSkillTmp = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_COMPANION_ACTIVE, trigger),
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(PlayerAfSkillTmp, ?SUPVIP_SKILL_TASK_COMPANION_NUM, trigger),
    {ok, PlayerAfSkill}.

%% 粉色装备合成
compose_equip(RoleId, GiveGoodsInfoList) when is_integer(RoleId) ->
    case [1||#goods{color = Color}<-GiveGoodsInfoList, Color == ?PINK] of
        [] -> ok;
        _ -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, compose_equip, [])
    end.
compose_equip(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_COMPOSE_PINK, {add, 1}),
    {ok, PlayerAfSkill}.

%% 开启龙纹N个孔
dragon_pos_unlock(Player) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DRAGON_POS, trigger),
    {ok, PlayerAfSkill}.

%% 收集物品
collect_goods(RoleId, FFGoodsList) ->
    DemonsGoodsIds = data_supreme_vip:get_kv(8),
    NumList = [GoodsNum||{GoodsId, GoodsNum}<-FFGoodsList, lists:member(GoodsId, DemonsGoodsIds)],
    Num = lists:sum(NumList),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, collect_demons_goods, [{add, Num}]).
%% 市场上架物品
trading_putaway(Player, GoodsId, GoodsNum) ->
    DemonsGoodsIds = data_supreme_vip:get_kv(8),
    case lists:member(GoodsId, DemonsGoodsIds) of
        true -> collect_demons_goods(Player, {reduce, GoodsNum});
        false -> {ok, Player}
    end.
%% 收集使魔天赋书
collect_demons_goods(Player, Args) ->
    PlayerAfSkill = lib_supreme_vip:trigger_skill_task(Player, ?SUPVIP_SKILL_TASK_DEMONS_GOODS, Args),
    {ok, PlayerAfSkill}.

%% 扫荡副本
dun_clean(Player, DunType, Count) ->
    Flag = lib_dungeon_resource:is_resource_dungeon_type(DunType),
    if
        Flag ->
            PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_DUN_CLEAN, {more, Count, DunType});
        DunType == ?DUNGEON_TYPE_PARTNER_NEW ->
            PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_DUN_CLEAN, {more, Count, DunType});
        true -> PlayerAfCurrency = Player
    end,
    {ok, PlayerAfCurrency}.

%% 璀璨之海N次
sea_treasure(Player) ->
    PlayerAfCurrency = lib_supreme_vip:trigger_currency_task(Player, ?SUPVIP_CURRENCY_TASK_SEA_TREA, {add, 1}),
    {ok, PlayerAfCurrency}.

%% ----------------------------------------------------
%% 特权
%% ----------------------------------------------------

%% 红装装备合成加成##万分比
get_red_equip_ratio_add(Player, #goods_compose_cfg{type = ComposeGoodsType, goods = [{_, GoodsTypeId, _}]}) ->
    if
        ComposeGoodsType =/= ?COMPOSE_EQUIP -> 0;
        true ->
            case data_goods_type:get(GoodsTypeId) of 
                #ets_goods_type{color = ?RED} -> get_red_equip_ratio_add(Player);
                _ -> 0
            end
    end;
get_red_equip_ratio_add(_Player, _ComposeCfg) ->
    0.

%% 红装装备合成加成##万分比
get_red_equip_ratio_add(Player) ->
    RightType = ?SUPVIP_RIGHT_RED_EQUIP_RATIO,
    SupvipType = lib_supreme_vip:get_supvip_type(Player),
    case data_supreme_vip:get_supreme_vip(SupvipType, RightType) of
        #base_supreme_vip{value = Value} -> Value;
        _ -> 0
    end.
    
%% 是否有购买商品的特权
is_buy_shop_right(Player) ->
    IsHaveRight = lib_supreme_vip:is_have_right(Player, ?SUPVIP_RIGHT_SHOP),
    IsHaveRight.

%% 副本数量加成
get_dungeon_num_add(Player, DunType) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime} = StatusSupVip,
    get_dungeon_num_add(SupvipType, SupvipTime, DunType).

get_dungeon_num_add(SupvipType, SupvipTime, DunType) when 
        DunType == ?DUNGEON_TYPE_VIP_PER_BOSS ->
    RightType = ?SUPVIP_RIGHT_VIP_BOSS_COUNT,
    NewSupvipType = lib_supreme_vip:get_supvip_type(SupvipType, SupvipTime),
    case data_supreme_vip:get_supreme_vip(NewSupvipType, RightType) of
        #base_supreme_vip{value = Value} -> Value;
        _ -> 0
    end;
get_dungeon_num_add(_SupvipType, _SupvipTime, _DunType) -> 
    0.

%% 增加怒气值
get_anger_add(Player, BossType) when 
        BossType == ?BOSS_TYPE_FORBIDDEN ->
    RightType = ?SUPVIP_RIGHT_FORBIDDEN_ANGER,
    SupvipType = lib_supreme_vip:get_supvip_type(Player),
    case data_supreme_vip:get_supreme_vip(SupvipType, RightType) of
        #base_supreme_vip{value = Value} -> Value;
        _ -> 0
    end;
get_anger_add(_Player, _BossType) ->
    0.

% %% 掉落翻倍
% get_drop_add(Player, CanDrops) ->
%     RightType = ?SUPVIP_RIGHT_ORANGE_DROP_NUM,
%     SupvipType = lib_supreme_vip:get_supvip_type(Player),
%     case data_supreme_vip:get_supreme_vip(SupvipType, RightType) of
%         #base_supreme_vip{args = Args} when Args =/= [] -> 
%             F = fun(#ets_drop_goods{list_id = ListId} = Drops, TmpList) ->
%                 case lists:keyfind(ListId, 1, Args) of
%                     {ListId, Num, Ratio} -> 
%                         Rand = urand:rand(1, ?RATIO_COEFFICIENT),
%                         case Rand =< Ratio of
%                             true -> AddList = lists:duplicate(Num, Drops);
%                             false -> AddList = []
%                         end;
%                     _ -> 
%                         AddList = []
%                 end,
%                 % ?MYLOG("hjhdrop", "ListId:~p AddList:~p ~n", [ListId, AddList]),
%                 AddList ++ TmpList
%             end,
%             lists:foldl(F, [], CanDrops);
%         _ -> 
%             []
%     end.

%% 掉落翻倍
calc_drop_rule_for_drop_rule(Player, EtsDropRule) ->
    RightType = ?SUPVIP_RIGHT_ORANGE_DROP_NUM,
    SupvipType = lib_supreme_vip:get_supvip_type(Player),
    case data_supreme_vip:get_supreme_vip(SupvipType, RightType) of
        #base_supreme_vip{value = Value, args = Args} when Args =/= [] -> 
            #ets_drop_rule{drop_rule = DropRule} = EtsDropRule,
            NewDropRule = do_calc_drop_rule_for_drop_rule(DropRule, Value, Args, []),
            % case DropRule =/= NewDropRule of
            %     true -> ?MYLOG("hjhdrop", "DropRule:~p NewDropRule:~p ~n", [DropRule, NewDropRule]);
            %     false -> skip
            % end,
            EtsDropRule#ets_drop_rule{drop_rule = NewDropRule};
        _ -> 
            EtsDropRule
    end.

do_calc_drop_rule_for_drop_rule([], _Value, _Args, Result) -> lists:reverse(Result);
do_calc_drop_rule_for_drop_rule([{L,R}|T], Value, Args, Result) -> 
    F = fun({ListId, Num}) ->
        case lists:member(ListId, Args) of
            true ->
                NewNum = Num * (1 + Value / ?RATIO_COEFFICIENT),
                % 获得整数掉落数量
                NumInt = umath:floor(NewNum),
                % 小数值要随机是否掉落多1个
                NumFloatRatio = round((NewNum - NumInt) * ?RATIO_COEFFICIENT),
                Rand = urand:rand(1, ?RATIO_COEFFICIENT),   
                case Rand =< NumFloatRatio of
                    true -> NumSum = NumInt+1;
                    false -> NumSum = NumInt
                end,
                % ?MYLOG("hjhdrop", "Num:~p, NewNum:~p Rand:~p NumFloatRatio:~p NumSum:~p ~n", [Num, NewNum, Rand, NumFloatRatio, NumSum]),
                {ListId, NumSum};
            false ->
                {ListId, Num}
        end
    end,
    NewL = lists:map(F, L),
    do_calc_drop_rule_for_drop_rule(T, Value, Args, [{NewL,R}|Result]).
