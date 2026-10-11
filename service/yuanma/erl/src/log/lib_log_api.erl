%% ---------------------------------------------------------------------------
%% @doc 游戏日志api
%% @author hek
%% @since  2016-09-22
%% @deprecated 本模块提供游戏日志api
%% ---------------------------------------------------------------------------
-module(lib_log_api).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("rec_sell.hrl").
-include("predefine.hrl").
-include("enchantment_guard.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").

%% 商城/快速购买购买日志
log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, #cost_log_about{type = LogType, data=[GoodsId, GoodsNum],remark=Remark})
    when LogType =:= 3 orelse
    LogType =:= 4->
    log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, GoodsId, GoodsNum, Remark);

log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, #cost_log_about{remark=Remark}) ->
    log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, 0, 0, Remark);

log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, About) ->
    log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, 0, 0, About).

%% 货币消费日志
%% Type : 消费类型 atom 需要后台定义"产出消耗类型--产出类型"
%% MoneyType : 金钱类型 term  (coin, bcoin, gold, bgold)
%% PlayerStatus : 消费前的玩家状态  record
%% NewPlayerStatus : 消费后的玩家状态  record
%% About : 消费内容 string
log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus, GoodsTypeId, GoodsNum, About) ->
    NowTime = utime:unixtime(),
    ConsumeType = data_goods:get_consume_type(Type),
    if
        MoneyType =:= ?COIN ->
            Cost_coin = PlayerStatus#player_status.coin - NewPlayerStatus#player_status.coin,
            Remain_coin = NewPlayerStatus#player_status.coin,
            Lv = NewPlayerStatus#player_status.figure#figure.lv,
            Cost_coin > 0 andalso ta_agent_fire:log_consume_coin(NewPlayerStatus, [Cost_coin, ConsumeType]),
            Args = [NowTime, ConsumeType, PlayerStatus#player_status.id, GoodsTypeId, GoodsNum, Cost_coin, Remain_coin, About, Lv],
            log_consume_2(log_consume_coin, Args);
        MoneyType =:= ?GCOIN ->
            CostGCoin = PlayerStatus#player_status.gcoin - NewPlayerStatus#player_status.gcoin,
            RemainGCoin = NewPlayerStatus#player_status.gcoin,
            GuildId = NewPlayerStatus#player_status.guild#status_guild.id,
            Lv = NewPlayerStatus#player_status.figure#figure.lv,
            Args = [NowTime, ConsumeType, PlayerStatus#player_status.id, GuildId, GoodsTypeId, GoodsNum, CostGCoin, RemainGCoin, About, Lv],
            log_consume_2(log_consume_gcoin, Args);
        MoneyType =:= ?GOLD orelse MoneyType =:= ?BGOLD orelse MoneyType =:= ?BGOLD_AND_GOLD ->
            Cost_bgold = PlayerStatus#player_status.bgold - NewPlayerStatus#player_status.bgold,
            Cost_gold = PlayerStatus#player_status.gold - NewPlayerStatus#player_status.gold,
            Remain_bgold = NewPlayerStatus#player_status.bgold,
            Remain_gold = NewPlayerStatus#player_status.gold,
            Lv = NewPlayerStatus#player_status.figure#figure.lv,
            Cost_gold > 0 andalso ta_agent_fire:gold_consume(NewPlayerStatus, [Cost_gold, ConsumeType]),
            Cost_bgold > 0 andalso ta_agent_fire:bgold_consume(NewPlayerStatus, [Cost_bgold, ConsumeType]),
            Args = [NowTime, ConsumeType, PlayerStatus#player_status.id, GoodsTypeId, GoodsNum, Cost_gold, Cost_bgold, Remain_gold, Remain_bgold, About, Lv],
            log_consume_2(log_consume_gold, Args);
        true -> skip
    end,
    ok.

%% 货币消费日志（离线版）
log_consume_offline(PlayerId, Type, MoneyType, Cost, [Gold, BGold, _Coin, _GCoin], [NewGold, NewBGold, NewCoin, NewGCoin], About) ->
    NowTime = utime:unixtime(),
    ConsumeType = data_goods:get_consume_type(Type),
    GoodsTypeId = 0, GoodsNum = 0, Lv = 0, GuildId = 0,
    if
        MoneyType =:= ?COIN ->
            log_consume_2(log_consume_coin, [NowTime, ConsumeType, PlayerId,  GoodsTypeId, GoodsNum, Cost, NewCoin, About, Lv]);
        MoneyType =:= ?GCOIN ->
            log_consume_2(log_consume_gcoin, [NowTime, ConsumeType, PlayerId, GuildId, GoodsTypeId, GoodsNum, Cost, NewGCoin, About, Lv]);
        MoneyType =:= ?GOLD orelse MoneyType =:= ?BGOLD orelse MoneyType =:= ?BGOLD_AND_GOLD ->
            CostGold = BGold - NewBGold,
            CostBgold = Gold - NewGold,
            log_consume_2(log_consume_gold, [NowTime, ConsumeType, PlayerId, GoodsTypeId, GoodsNum, CostGold, CostBgold, NewGold, NewBGold, About, Lv]);
        true -> skip
    end,
    ok.

log_consume_2(LogType, Args) ->
    mod_log:add_log(LogType, Args).

%% 货币生产日志
%% Type : 生产类型 atom 需要后台定义"产出消耗类型--消耗类型"
%% MoneyType : 金钱类型 term  (coin, bcoin, gold, bgold)
%% PlayerStatus : 生产前的玩家状态  record
%% NewPlayerStatus : 生产后的玩家状态  record
%% About : 消费内容 string
%%【 注意】：这个方法在充值lib_recharge:pay_offline中，会模拟出PlayerStatus跟NewPlayerStatus
%% 因此，如果需要用到coin, bcoin, bgold, gold, id之外的数据，需要通知同步修改，否则影响充值处理
log_produce(Type, MoneyType, PlayerStatus, NewPlayerStatus, About) ->
    NowTime = utime:unixtime(),
    ProduceType = data_goods:get_produce_type(Type),
    case MoneyType of
        ?COIN ->
            Got_coin = NewPlayerStatus#player_status.coin - PlayerStatus#player_status.coin,
            Remain_coin = NewPlayerStatus#player_status.coin,
            Remain_coin > 0 andalso ta_agent_fire:log_produce_coin(NewPlayerStatus, [Remain_coin, ProduceType]),
            mod_log:add_log(log_produce_coin, [NowTime, ProduceType, PlayerStatus#player_status.id, Got_coin, Remain_coin, About]);
        ?GCOIN ->
            GotGCoin = NewPlayerStatus#player_status.gcoin - PlayerStatus#player_status.gcoin,
            RemainGCoin = NewPlayerStatus#player_status.gcoin,
            GuildId = NewPlayerStatus#player_status.guild#status_guild.id,
            mod_log:add_log(log_produce_gcoin, [NowTime, ProduceType, PlayerStatus#player_status.id, GuildId, GotGCoin, RemainGCoin, About]);
        ?CURRENCY ->
            {CurrencyId, Remark} = About,
            OldC = maps:get(CurrencyId, PlayerStatus#player_status.currency_map, 0),
            NewC = maps:get(CurrencyId, NewPlayerStatus#player_status.currency_map, 0),
            GotCurrency = NewC - OldC,
            GotCurrency > 0 andalso ta_agent_fire:log_produce_currency(NewPlayerStatus, [CurrencyId, GotCurrency, ProduceType]),
            mod_log:add_log(log_produce_currency, [NowTime, ProduceType, PlayerStatus#player_status.id, CurrencyId, GotCurrency, NewC, Remark]);
        _ when MoneyType =:= ?GOLD orelse MoneyType =:= ?BGOLD ->
            Got_bgold = NewPlayerStatus#player_status.bgold - PlayerStatus#player_status.bgold,
            Got_gold = NewPlayerStatus#player_status.gold - PlayerStatus#player_status.gold,
            Remain_bgold = NewPlayerStatus#player_status.bgold,
            Remain_gold = NewPlayerStatus#player_status.gold,
            Got_gold > 0 andalso ta_agent_fire:gold_get(NewPlayerStatus, [Got_gold, ProduceType]),
            Got_bgold > 0 andalso ta_agent_fire:bgold_get(NewPlayerStatus, [Got_bgold, ProduceType]),
            mod_log:add_log(log_produce_gold, [
                                               NowTime, ProduceType, PlayerStatus#player_status.id, Got_gold, Got_bgold, Remain_gold, Remain_bgold, About]);
        _ -> skip
    end,
    ok.

%% 物品使用日志
log_throw(Type, PlayerId, GoodsId, GoodsTypeId, GoodsNum, _Prefix, _Stren) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = GoodsType, color = Color}
            when (GoodsType == ?GOODS_TYPE_EQUIP orelse GoodsType == ?GOODS_TYPE_RUNE orelse GoodsType == ?GOODS_TYPE_SOUL)
                andalso Color =< ?BLUE ->
            ok;
        _ ->
            TypeId = data_goods:get_consume_type(Type),
            mod_log:add_log(log_throw, [utime:unixtime(), TypeId, PlayerId, GoodsId, GoodsTypeId, GoodsNum])
    end,
    ok.

%% 物品产出日志
log_goods(Type, SubType, GoodsTypeId, GoodsNum, PlayerId, Remark) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = GoodsType, color = Color}
            when (GoodsType == ?GOODS_TYPE_EQUIP orelse GoodsType == ?GOODS_TYPE_RUNE orelse GoodsType == ?GOODS_TYPE_SOUL)
                andalso Color =< ?BLUE ->
            ok;
        _ ->
            TypeId = data_goods:get_produce_type(Type),
            mod_log:add_log(log_goods, [utime:unixtime(), TypeId, SubType, GoodsTypeId, GoodsNum, PlayerId, Remark])
    end,
    ok.

%% 礼包日志
log_gift(PlayerId, GoodsId, GoodsTypeId, GiftId, UseNum, About) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_gift, [NowTime, PlayerId, GoodsId, GoodsTypeId, GiftId, UseNum]),
    GiftAbout = [[NowTime, PlayerId, GiftId, Id, Num]||{Id, Num}<-About, Num>0],
    case GiftAbout=/=[] of
        true ->
            mod_log:add_log(log_gift_about, GiftAbout);
        false -> skip
    end,
    ok.

%% 发物品失败结果日志
log_send_reward_result(RoleId, ProduceId, List, Res) ->
    mod_log:add_log(log_send_reward_result, [RoleId, ProduceId, util:term_to_bitstring(List), Res, utime:unixtime()]),
    ok.

%% 背包移动日志
log_move_goods(RoleId, FromLoc, ToLoc, SuccGoods, FailGoods) ->
    mod_log:add_log(log_move_goods, [RoleId, FromLoc, ToLoc, util:term_to_bitstring(SuccGoods), util:term_to_bitstring(FailGoods), utime:unixtime()]),
    ok.

%% 头衔升级日志
log_title(Pid, PreTitleId, TitleId, Cost, Combat) ->
    CostB = util:term_to_bitstring(Cost),
    mod_log:add_log(log_title, [Pid, PreTitleId, TitleId, CostB, Combat, utime:unixtime()]),
    ok.

log_common_rank_role(RoleId, RankType, Rank, Value, SecRoleId, SecValue) ->
    mod_log:add_log(log_common_rank_role, [RoleId, RankType, Rank, Value, SecRoleId, SecValue, utime:unixtime()]),
    ok.
%% 公会榜结算日志
log_common_rank_guild(GuildId, Rank, Combat, SecGuildId, SecCombat) ->
    mod_log:add_log(log_common_rank_guild, [GuildId, Rank, Combat, SecGuildId, SecCombat, utime:unixtime()]),
    ok.

%% 成就领取日志
log_achv(PlayerId, Lv, AchvId, AchvPoint) ->
    mod_log:add_log(log_achv, [PlayerId, Lv, AchvId, AchvPoint, utime:unixtime()]),
    ok.

%% 称号激活日志
log_active_dsgt(PlayerId, Id, Op, OpNow, ExpireTime, EndTime) ->
    mod_log:add_log(log_active_dsgt, [PlayerId, Id, Op, OpNow, ExpireTime, EndTime]),
    ok.

%%称号升阶日志
log_dsgt_upgrade_order(PlayerId, Id, PerOrder, NewOrder, Cost, Time) ->
    mod_log:add_log(log_dsgt_order, [PlayerId, Id, PerOrder, NewOrder, Cost, Time]),
    ok.

%% 活动日志
log_act_reward(RoleId, Type, Subtype, RewardId, Count, CTime, UTime) ->
    mod_log:add_log(log_act_reward, [utime:unixtime(), RoleId, Type, Subtype, RewardId, Count, CTime, UTime]).

log_activity_live(RoleId, AcId, AcSub, AcName, Live, OldLive, NewLive, Time) ->
    mod_log:add_log(log_activity_live, [RoleId, AcId, AcSub, AcName, Live, OldLive, NewLive, Time]),
    ok.

log_shop(RoleId, ShopType, GoodsId, AllNum, BuyNum, CType, AllPrice, Time) ->
    mod_log:add_log(log_shop, [RoleId, ShopType, GoodsId, AllNum, BuyNum, CType, AllPrice, Time]),
    ok.

%% 功能活动参与记录、日志
join_log(PlayerId, GuildId, ModuleId) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_join, [PlayerId, GuildId, ModuleId, NowTime]),
    ok.

log_partner_break(RoleId, PartnerId, Before, After, Time) ->
    mod_log:add_log(log_partner_break, [RoleId, PartnerId, Before, After, Time]),
    ok.

log_partner_equip(Pid, PartnerId, Quality, ObjectList_B, Combat, Time) ->
    mod_log:add_log(log_partner_equip, [Pid, PartnerId, Quality, ObjectList_B, Combat, Time]),
    ok.

log_auction_produce(ModuleId, AuctionType, GuildGoodsList) ->
    Time = utime:unixtime(),
    Args = [[GuildId, ModuleId, AuctionType, util:term_to_bitstring(GoodsList), Time]||{GuildId, GoodsList}<-GuildGoodsList],
    mod_log:add_log(log_auction_produce, Args),
    ok.

log_auction_pay(PlayerId, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Wlv, PayType, PriceList, Price) ->
    Time = utime:unixtime(),
    PriceList2 = util:term_to_bitstring(PriceList),
    mod_log:add_log(log_auction_pay, [PlayerId, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Wlv, PayType, PriceList2, Price,  Time]),
    ok.

log_auction_pay_kf(PlayerId, Name, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Wlv, PayType, PriceList, Price) ->
    Time = utime:unixtime(),
    PriceList2 = util:term_to_bitstring(PriceList),
    NameBin = util:fix_sql_str(Name),
    mod_log:add_log(log_auction_pay_kf, [PlayerId, NameBin, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Wlv, PayType, PriceList2, Price,  Time]),
    ok.

log_auction_award(PlayerId, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Price) ->
    Time = utime:unixtime(),
    mod_log:add_log(log_auction_award, [PlayerId, GuildId, ModuleId, AuctionType, GoodsId, TypeId, Price, Time]),
    ok.

log_auction_bonus(PlayerId, GuildId, ModuleId, MoneyList) ->
    Time = utime:unixtime(),
    MoneyList2 = util:term_to_bitstring(MoneyList),
    mod_log:add_log(log_auction_bonus, [PlayerId, GuildId, ModuleId, MoneyList2, Time]),
    ok.

log_ac_start(Module, ModuleSub, AcSub, State, Time) ->
    mod_log:add_log(log_ac_start, [Module, ModuleSub, AcSub, State, Time]),
    ok.

log_custom_act(Type, Subtype, WLv, Stime, Etime, State, Time) ->
    mod_log:add_log(log_custom_act, [Type, Subtype, WLv, Stime, Etime, State, Time]),
    ok.

log_daily_gift(RoleId, ProductName, GoodsTypeId, Time) ->
    mod_log:add_log(log_daily_gift, [RoleId, ProductName, GoodsTypeId, Time]),
    ok.

log_resource_back(RoleId, Id, ActSub, Cost, Times, LeftTimes, Reward) ->
    Cost_B = util:term_to_bitstring(Cost),
    Reward_B = util:term_to_bitstring(Reward),
    mod_log:add_log(log_resource_back, [RoleId, Id, ActSub, Cost_B, Times, LeftTimes, Reward_B, utime:unixtime()]),
    ok.

log_tsmap(RoleId, Lv, SubType, RandEventId, Status, HelpId, HelpNum, Time) ->
    mod_log:add_log(log_tsmap, [RoleId, Lv, SubType, RandEventId, Status, HelpId, HelpNum, Time]),
    ok.

log_welfare(RoleId, Type, Num, Op, LeftCount, Time) ->
    mod_log:add_log(log_welfare, [RoleId, Type, Num, Op, LeftCount, Time]),
    ok.

log_uplv(PlayerId, Lv, From, ExpAdd, CombatPower, SceneId) ->
    mod_log:add_log(log_uplv, [PlayerId, Lv, From, ExpAdd, CombatPower, SceneId, utime:unixtime()]),
    ok.

log_login(PlayerId, Ip, Accid, Accname, LoginType, CombatPower, ModulePower, Scene, X, Y, WxScene) ->
    mod_log:add_log(log_login, [PlayerId, tool:ip2bin(Ip), utime:unixtime(), Accid, Accname, LoginType, CombatPower, ModulePower, Scene, X, Y, WxScene]),
    ok.

log_partner_learn_sk(RoleId, PartnerId, QualityStr, SkillId, Cost_B, Combat) ->
    mod_log:add_log(log_partner_learn_sk, [RoleId, PartnerId, QualityStr, SkillId, Cost_B, Combat, utime:unixtime()]),
    ok.

log_partner_promote(RoleId, PartnerId, QualityStr, ObjectList_B, OldAttrString, NewAttrString, Combat) ->
    mod_log:add_log(log_partner_promote, [RoleId, PartnerId, QualityStr, ObjectList_B, OldAttrString, NewAttrString, Combat, utime:unixtime()]),
    ok.

log_partner_disband(RoleId, PartnerInfo, AptiTake, SkLearn, PReward, Time) ->
    mod_log:add_log(log_partner_disband, [RoleId, PartnerInfo, AptiTake, SkLearn, PReward, Time]),
    ok.

log_partner_add_exp(RoleId, PartnerId, QualityStr, ObjectList_B, OldLv, NewLv) ->
    mod_log:add_log(log_partner_add_exp, [RoleId, PartnerId, QualityStr, ObjectList_B, OldLv, NewLv, utime:unixtime()]),
    ok.

log_partner_wash(RoleId, PartnerId, QualityStr, Lv, CostObject, Reward, OldAttrString, NewAttrString, PowerChange, SkChange, ProdigyChange, Replace) ->
    mod_log:add_log(log_partner_wash, [RoleId, PartnerId, QualityStr, Lv, CostObject, Reward, OldAttrString, NewAttrString, PowerChange, SkChange, ProdigyChange, Replace, utime:unixtime()]),
    ok.

log_partner_recruit(List) ->
    case List=/=[] of
        true -> mod_log:add_log(log_partner_recruit, List);
        false -> skip
    end,
    ok.

log_coin_exchange(RoleId, VipLv, AlreadyExchanged, CanExchange, Cost, Reward, Time) ->
    mod_log:add_log(log_coin_exchange, [RoleId, VipLv, AlreadyExchanged, CanExchange, Cost, Reward, Time]),
    ok.

log_daily_checkin(RoleId, VipLv, Retro, Day, RewardL) ->
    RewardL1 = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_daily_checkin, [RoleId, VipLv, Retro, Day, RewardL1, utime:unixtime()]),
    ok.

log_online_reward(RoleId, RewardList, OnlineTime) ->
    NowTime = utime:unixtime(),
    RewardL = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_online_reward, [RoleId, NowTime, RewardL, OnlineTime]),
    ok.

log_total_checkin(RoleId, Day, RewardL) ->
    RewardL1 = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_total_checkin, [RoleId, Day, RewardL1, utime:unixtime()]),
    ok.

log_rush_giftbag(RoleId, PlayerLv, Sex, BagLv, HasGiftNum, Rewards) ->
    Rewards_B = util:term_to_bitstring(Rewards),
    mod_log:add_log(log_rush_giftbag, [RoleId, PlayerLv, Sex, BagLv, HasGiftNum, Rewards_B, utime:unixtime()]),
    ok.

log_equip_stren(PlayerId, EquipPos, Cost, PreLv, CurLv) ->
    mod_log:add_log(log_equip_stren, [PlayerId, EquipPos, util:term_to_bitstring(Cost), PreLv, CurLv, utime:unixtime()]),
    ok.

log_equip_refine(PlayerId, EquipPos, Cost, PreLv, CurLv) ->
    mod_log:add_log(log_equip_refine, [PlayerId, EquipPos, util:term_to_bitstring(Cost), PreLv, CurLv, utime:unixtime()]),
    ok.

log_equip_wash(PlayerId, Part, EquipTypeId, EquipId, EquipAddition1, EquipAddition2, GoodsTypeId, GoodsId, GoodsAddition1, GoodsAddition2, ObjectList) ->
    mod_log:add_log(log_equip_wash, [PlayerId, Part, EquipTypeId, EquipId, util:term_to_bitstring(EquipAddition1),
                                     util:term_to_bitstring(EquipAddition2), GoodsTypeId, GoodsId, util:term_to_bitstring(GoodsAddition1),
                                     util:term_to_bitstring(GoodsAddition2), util:term_to_bitstring(ObjectList), utime:unixtime()] ),
    ok.

log_goods_compose(PlayerId, RuleId, SpecifyMaterialList, MaterialList, CostList, IsSuccess, GoodsList) ->
    mod_log:add_log(log_goods_compose, [PlayerId, RuleId, util:term_to_bitstring(SpecifyMaterialList), util:term_to_bitstring(MaterialList), util:term_to_bitstring(CostList), IsSuccess, util:term_to_bitstring(GoodsList), utime:unixtime()]),
    ok.

log_goods_sell(PlayerId, GoodsTypeList, GoodsIdList, ObjectList) ->
    mod_log:add_log(log_goods_sell, [PlayerId, util:term_to_bitstring(GoodsTypeList), util:term_to_bitstring(GoodsIdList), util:term_to_bitstring(ObjectList), utime:unixtime()]),
    ok.

log_growup(RoleId, SubType, Lv, Num, GetTime, BuyTime) ->
    mod_log:add_log(log_growup, [RoleId, SubType, Lv, Num, GetTime, BuyTime]),
    ok.

% %% 公会建筑升级
% log_guild_building_upgrade(RoleId, GuildId, GuildName, BuildingType, BuildingLv, UpgradeLv, CostGfunds, LeftGunds, Time) ->
%     mod_log:add_log(log_guild_building_upgrade, [RoleId, GuildId, GuildName, BuildingType, BuildingLv, UpgradeLv, CostGfunds, LeftGunds, Time]).

%% 消耗资金日志
log_consume_gfunds(RoleId, GuildId, Type, CostGfunds, RemainGfunds, Time) ->
    ConsumeType = data_goods:get_consume_type(Type),
    mod_log:add_log(log_consume_gfunds, [RoleId, GuildId, ConsumeType, CostGfunds, RemainGfunds, Time]).

%% 增加资金日志
log_produce_gfunds(RoleId, GuildId, Type, AddGfunds, RemainGfunds, Time) ->
    ProduceType = data_goods:get_produce_type(Type),
    mod_log:add_log(log_produce_gfunds, [RoleId, GuildId, ProduceType, AddGfunds, RemainGfunds, Time]).

%% 公会成员日志
log_guild_member(GuildId, GuildName, EventType, RoleId, EventParam, Time) ->
    mod_log:add_log(log_guild_member, [GuildId, GuildName, EventType, RoleId, EventParam, Time]).

%% 首冲日志
log_recharge_first(PlayerId, RechargeTime, FetchTime, Status, Award) ->
    mod_log:add_log(log_recharge_first, [PlayerId, RechargeTime, FetchTime, Status, util:term_to_bitstring(Award)]),
    ok.

%% 充值返利日志
log_recharge_return(PlayerId, ProductId, ReturnType, Gold, ReturnGold, Time) ->
    mod_log:add_log(log_recharge_return, [PlayerId, ProductId, ReturnType, Gold, ReturnGold, Time]),
    ok.

%% 禁言日志
%% Type: 0：封号，1：IP黑名单，3：禁言 4：解除禁言
log_ban(Type, Object, Description, Time, Admin) ->
    mod_log:add_log(log_ban, [Type, Object, Description, Time, Admin]),
    ok.

% log_ac_custom(RoleId, Ac, AcSub, RewardId, Reward, Args, Time) ->
%     mod_log:add_log(log_ac_custom, [RoleId, Ac, AcSub, RewardId, Reward, Args, Time]),
%     ok.

log_throw_dice(RoleId, MoveStep, GridType, Time) ->
    mod_log:add_log(log_throw_dice, [RoleId, MoveStep, GridType, Time]),
    ok.

log_trigger_event(RoleId, EventId, Succ, Reward, Time) ->
    mod_log:add_log(log_trigger_event, [RoleId, EventId, Succ, util:term_to_bitstring(Reward), Time]),
    ok.

log_adventure_get_reward(RoleId, Reward) ->
    mod_log:add_log(log_adventure_get_reward, [RoleId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_unlock_box(RoleId, TypeId, Now) ->
    mod_log:add_log(log_unlock_box, [RoleId, TypeId, Now]),
    ok.

log_adventure_receive_box(RoleId, TypeId, Cost, GiveList) ->
    mod_log:add_log(log_adventure_receive_box, [RoleId, TypeId, util:term_to_bitstring(Cost), util:term_to_bitstring(GiveList), utime:unixtime()]),
    ok.

log_rename(RoleId,OldName,NewName,Lv,Cost) ->
    mod_log:add_log(log_rename, [RoleId, util:fix_sql_str(OldName), util:fix_sql_str(NewName), Lv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_player_guild_equip_hit(RoleId, Subtype, GoodsId, Count, HitPos, IsHit, GetGoodsId) ->
    mod_log:add_log(log_player_guild_equip_hit, [RoleId, Subtype, GoodsId, Count, HitPos, IsHit, GetGoodsId, utime:unixtime()]),
    ok.

log_war_god_score(PlayerId, Type, ScoreBefore, ScoreAfter, EnterTime, FinishTime, Hurt) ->
    mod_log:add_log(log_war_god_score, [PlayerId, Type, ScoreBefore, ScoreAfter, EnterTime, FinishTime, Hurt]),
    ok.

log_war_god_attack_player(PlayerId, EmbattleList, ScoreBefore, ScoreAfter, OppPlayerId, OppEmbattleList, OppScoreBefore, OppScoreAfter, Result, EnterTime, FinishTime) ->
    EmbattleList2 = util:term_to_bitstring(EmbattleList),
    OppEmbattleList2 = util:term_to_bitstring(OppEmbattleList),
    mod_log:add_log(log_war_god_attack_player, [PlayerId, EmbattleList2, ScoreBefore, ScoreAfter, OppPlayerId, OppEmbattleList2, OppScoreBefore, OppScoreAfter, Result, EnterTime, FinishTime]),
    ok.

log_war_god_award(PlayerId, Score, No, ObjectList, Time) ->
    mod_log:add_log(log_war_god_award, [PlayerId, Score, No, util:term_to_bitstring(ObjectList), Time]),
    ok.

log_offline(PlayerId, OffLineType, Power, ModulePower, SceneId, X, Y, Time) ->
    mod_log:add_log(log_offline, [PlayerId, OffLineType, Power, ModulePower, SceneId, X, Y, Time]),
    ok.

log_onhook(PlayerId, Type, LeftTime, Time) ->
    mod_log:add_log(log_onhook, [PlayerId, Type, LeftTime, Time]),
    ok.

log_onhook_result(RoleId, Lv, Exp, PetExp, CostOnhookTime, DevourEquips, PickUpGoods, NowTime)->
    mod_log:add_log(log_onhook_result, [RoleId, Lv, Exp, PetExp, CostOnhookTime, DevourEquips, PickUpGoods, NowTime]),
    ok.

log_gift_card_list(PlayerId, CardNo, GiftType, AwardList) ->
    mod_log:add_log(log_gift_card_list, [PlayerId, CardNo, GiftType, util:term_to_bitstring(AwardList), utime:unixtime()]),
    ok.

log_version_upgradebag(RoleId, VersionCode, RewardL) ->
    RewardL1 = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_version_upgradebag, [RoleId, VersionCode, RewardL1, utime:unixtime()]),
    ok.

log_top_pk(RoleId, OtherRoleId, OtherName, IsFake, Platform, ServerId, Res, RankLv0, Point0, RankLv1, Point1) ->
    mod_log:add_log(log_top_pk, [RoleId, OtherRoleId, util:fix_sql_str(OtherName), IsFake, Platform, ServerId, Res, RankLv0, Point0, RankLv1, Point1, utime:unixtime()]),
    ok.

%%log_vip_status(RoleId, VipLv, PropsId, VipStatus, EndTime) ->
%%    mod_log:add_log(log_vip_status, [RoleId, VipLv, PropsId, VipStatus, EndTime, utime:unixtime()]),
%%    ok.
%%
%%log_vip_upgrade(RoleId, VipLv, VipExp, DiamondExp, LoginExp) ->
%%    mod_log:add_log(log_vip_upgrade, [RoleId, VipLv, VipExp, DiamondExp, LoginExp, utime:unixtime()]),
%%    ok.
%%  vip
log_vip_buy(RoleID, VipType, Costs, FirstBuy, AwardList, VipExp, Forever, EndTime, Time) ->
    mod_log:add_log(log_vip_buy, [RoleID, VipType, Costs, FirstBuy, util:term_to_bitstring(AwardList), VipExp, Forever, EndTime, Time]),
    ok.

log_vip_goods(RoleID, GoodsId, VipType, VipExp, Forever, EndTime, Time) ->
    mod_log:add_log(log_vip_goods, [RoleID, GoodsId, VipType, VipExp, Forever, EndTime, Time]),
    ok.

log_vip_lv(RoleID, VipLv1, VipLv2, Time) ->
    mod_log:add_log(log_vip_lv, [RoleID, VipLv1, VipLv2, Time]),
    ok.

log_vip_exp(RoleID, Source, VipType, GoodsId, VipLv1, VipExp1, VipLv2, VipExp2, Time) ->
    mod_log:add_log(log_vip_exp, [RoleID, Source, VipType, GoodsId, VipLv1, VipExp1, VipLv2, VipExp2, Time]),
    ok.

log_consume_currency(PlayerId, Type, CurrencyId, Num, NewValue, About) ->
    TypeId = data_goods:get_consume_type(Type),
    mod_log:add_log(log_consume_currency, [PlayerId, TypeId, CurrencyId, Num, NewValue, About, utime:unixtime()]),
    ok.
%% 聊天举报
log_talk_report(FromId, ToId, Msg, Time) ->
    mod_log:add_log(log_talk_report, [FromId, ToId, Msg, Time]),
    ok.

%% 护送结束
log_husong_end(RoleId, AngelId, StartTime, EndStage, EndType, IfDouble, GoodsList) ->
    SGoodsList = util:term_to_bitstring(GoodsList),
    mod_log:add_log(log_husong_end, [RoleId, AngelId, StartTime, EndStage, EndType, IfDouble, SGoodsList, utime:unixtime()]),
    ok.

%% 护送刷新天使id
log_husong_reflesh(RoleId, OldAngelId, NewAngelId, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_husong_reflesh, [RoleId, OldAngelId, NewAngelId, SCostList, utime:unixtime()]),
    ok.

%% 护送拦截
log_husong_take(TakeRoleId, BeTakenRoleId) ->
    mod_log:add_log(log_husong_take, [TakeRoleId, BeTakenRoleId, utime:unixtime()]),
    ok.

%% 鸣海遗珠奖励日志
log_treasure_chest_reward(RoleId, Grade) ->
    mod_log:add_log(log_treasure_chest_reward, [RoleId, Grade, utime:unixtime()]),
    ok.

%% 幻兽出战休息
log_eudemons_operation(PlayerId, EudemonsId, Op) ->
    mod_log:add_log(log_eudemons_operation, [PlayerId, EudemonsId, Op, utime:unixtime()]),
    ok.

%% 幻兽装备强化
log_eudemons_strength(PlayerId, EquipId, EquipTypeId, CostExp, Stren0, Exp0, Stren1, Exp1) ->
    mod_log:add_log(log_eudemons_strength, [PlayerId, EquipId, EquipTypeId, CostExp, Stren0, Exp0, Stren1, Exp1, utime:unixtime()]),
    ok.

%% 七天登录领取
log_login_reward_day(RoleId, DayId, GetDate, RewardList) ->
    SRewardList = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_login_reward_day, [RoleId, DayId, GetDate, SRewardList, utime:unixtime()]),
    ok.

%% 转生日志
log_reincarnation(RoleId, Type, Turn) ->
    mod_log:add_log(log_reincarnation, [RoleId, Type, Turn, utime:unixtime()]),
    ok.

%% 星界觉醒日志
log_awakening(RoleId, Cell, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_awakening, [RoleId, Cell, CostStr, utime:unixtime()]),
    ok.

%% 宝石镶卸日志
log_stone_inlay(RoleId, CtrlType, EquipPos, Cell, PreStoneId, AfStoneId, Extra) ->
    ExtraStr = util:make_sure_list(Extra),
    mod_log:add_log(log_stone_inlay, [RoleId, CtrlType, EquipPos, Cell, PreStoneId, AfStoneId, ExtraStr, utime:unixtime()]),
    ok.

%% 宝石精炼日志
log_stone_refine(RoleId, EquipPos, PreLv, CurLv, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_stone_refine, [RoleId, EquipPos, PreLv, CurLv, CostStr, utime:unixtime()]),
    ok.

log_combine_stone(RoleId, CombineType, CostList, Reward) ->
    mod_log:add_log(log_combine_stone, [RoleId, CombineType, util:term_to_bitstring(CostList), util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 装备套装锻造
log_equip_suit_operation(PlayerId, EquipId, EquipTypeId, SuitType, SuitLv, SuitSLv, Count, Op) ->
    mod_log:add_log(log_equip_suit_operation, [PlayerId, EquipId, EquipTypeId, SuitType, SuitLv, SuitSLv, Count, Op, utime:unixtime()]),
    ok.

%% 虚空秘境日志
log_void_fam(RoleId, Type, Floor, Score) ->
    mod_log:add_log(log_void_fam, [RoleId, Type, Floor, Score, utime:unixtime()]),
    ok.

%% 装备进阶日志
log_equip_upgrade_stage(RoleId, GoodsId, OldGTypeId, Cost, NewGTypeId) ->
    mod_log:add_log(log_equip_upgrade_stage, [RoleId, GoodsId, OldGTypeId, util:term_to_bitstring(Cost), NewGTypeId, utime:unixtime()]),
    ok.

%% 装备洗炼日志
log_equip_wash(RoleId, EquipPos, Duan, Cost, PreAttr, CurAttr, PreRating, CurRating, RatioPlus) ->
    mod_log:add_log(log_equip_wash, [RoleId, EquipPos, Duan, util:term_to_bitstring(Cost), util:term_to_bitstring(PreAttr), util:term_to_bitstring(CurAttr), PreRating, CurRating, RatioPlus, utime:unixtime()]),
    ok.

%% 装备神铸日志
log_equip_upgrade_division(RoleId, EquipPos, Cost, PreDivision, CurDivision) ->
    mod_log:add_log(log_equip_upgrade_division, [RoleId, EquipPos, util:term_to_bitstring(Cost), PreDivision, CurDivision, utime:unixtime()]),
    ok.

%% 永恒碑谷奖励领取日志
log_eternal_valley_reward(RoleId, Chapter, Stage, Reward) ->
    mod_log:add_log(log_eternal_valley_reward, [RoleId, Chapter, Stage, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 记录幻兽之域的boss击杀归属记录
log_eudemons_land_boss(ZoneId, BossId, AttrId, AttrName, KPForm, KSName, Bl1, Bl2, Bl3, NowTime) ->
    mod_log:add_log(log_eudemons_land_boss, [ZoneId, BossId, AttrId, AttrName, KPForm, KSName, Bl1, Bl2, Bl3, NowTime]),
    ok.

log_eudemons_land_level(RoleId, Lv, Exp, NewLv, NewExp, ExpAdd) ->
    mod_log:add_log(log_eudemons_land_level, [RoleId, Lv, Exp, NewLv, NewExp, ExpAdd, utime:unixtime()]),
    ok.

log_eudemons_land_rank_center(LogList) ->
    case LogList =/= [] of
        true-> mod_log:add_log(log_eudemons_land_rank_center, LogList);
        false-> skip
    end,
    ok.

log_eudemons_land_rank_local(RoleId, RankType, RoleRank, Value, RewardList, NowTime) ->
    mod_log:add_log(log_eudemons_land_rank_local, [RoleId, RankType, RoleRank, Value, util:term_to_bitstring(RewardList), NowTime]),
    ok.

log_eudemons_land_score(RoleId, RoleName, ZoneId, ServerId, ServerNum, AddScore, AddKillNum, Score, KillNum, TotalScore, NowTime) ->
    mod_log:add_log(log_eudemons_land_score, [RoleId, RoleName, ZoneId, ServerId, ServerNum, AddScore, AddKillNum, Score, KillNum, TotalScore, NowTime]),
    ok.

%% 记录本服boss的掉落
log_boss(BossType, BossId, AttrId, BlId, NowTime)->
    mod_log:add_log(log_boss, [BossType, BossId, AttrId, BlId, NowTime]),
    ok.

%% 婚姻-戒指打磨
log_marriage_ring_polish(RoleId, OldPolishList, NewPolishList, CostList) ->
    SOldPolishList = util:term_to_bitstring(OldPolishList),
    SNewPolishList = util:term_to_bitstring(NewPolishList),
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_ring_polish, [RoleId, SOldPolishList, SNewPolishList, SCostList, utime:unixtime()]),
    ok.

%% 婚姻-戒指提升
log_marriage_ring_upgrade(RoleId, OldStage, OldStar, OldPrayNum, NewStage, NewStar, NewPrayNum, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_ring_upgrade, [RoleId, OldStage, OldStar, OldPrayNum, NewStage, NewStar, NewPrayNum, SCostList, utime:unixtime()]),
    ok.

%% 婚姻-宝宝学识提升
log_marriage_baby_knowledge_upgrade(RoleId, OldStage, OldStar, OldPrayNum, NewStage, NewStar, NewPrayNum, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_baby_knowledge_upgrade, [RoleId, OldStage, OldStar, OldPrayNum, NewStage, NewStar, NewPrayNum, SCostList, utime:unixtime()]),
    ok.

%% 婚姻-宝宝资质提升日志表
log_marriage_baby_aptitude_upgrade(RoleId, OldAptitudeLv, NewAptitudeLv, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_baby_aptitude_upgrade, [RoleId, OldAptitudeLv, NewAptitudeLv, SCostList, utime:unixtime()]),
    ok.

%% 婚姻-宝宝幻形提升日志表
log_marriage_baby_image_upgrade(RoleId, ImageId, OldStage, OldPrayNum, NewStage, NewPrayNum, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_baby_image_upgrade, [RoleId, ImageId, OldStage, OldPrayNum, NewStage, NewPrayNum, SCostList, utime:unixtime()]),
    ok.

%% 宝宝养育提升
log_baby_raise_up(RoleId, TaskId, AddRaiseExp, RaiseLv, RaiseExp, NewRaiseLv, NewRaiseExp) ->
    mod_log:add_log(log_baby_raise_up, [RoleId, TaskId, AddRaiseExp, RaiseLv, RaiseExp, NewRaiseLv, NewRaiseExp, utime:unixtime()]),
    ok.
%% 宝宝升阶
log_baby_upgrade_stage(RoleId, Stage, StageLv, StageExp, NewStage, NewStageLv, NewStageExp, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_baby_upgrade_stage, [RoleId, Stage, StageLv, StageExp, NewStage, NewStageLv, NewStageExp, SCostList, utime:unixtime()]),
    ok.
%% 宝宝幻化
log_baby_active_figure(RoleId, BabyId, ActiveType, OldStar, NewStar, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_baby_active_figure, [RoleId, BabyId, ActiveType, OldStar, NewStar, SCostList, utime:unixtime()]),
    ok.
%% 宝宝点赞
log_baby_praise(PraiserId, RoleId, PraiseCount, RewardList) ->
    SRewardList = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_baby_praise, [PraiserId, RoleId, PraiseCount, SRewardList, utime:unixtime()]),
    ok.
%% 宝宝点赞榜单
log_baby_praise_rank(LogList) ->
    case LogList=/=[] of
        true -> mod_log:add_log(log_baby_praise_rank, LogList);
        false -> skip
    end,
    ok.
%% 宝宝穿戴装备
log_baby_equip_goods(RoleId, PosId, OldGoodsId, OldGoodsTypeId, OldSkillId, NewGoodsId, NewGoodsTypeId, NewSkillId) ->
    mod_log:add_log(log_baby_equip_goods, [RoleId, PosId, OldGoodsId, OldGoodsTypeId, OldSkillId, NewGoodsId, NewGoodsTypeId, NewSkillId, utime:unixtime()]),
    ok.
%% 宝宝装备升阶
log_baby_equip_stage_up(RoleId, PosId, OprType, OldStage, OldStageLv, OldStageExp, NewStage, NewStageLv, NewStageExp, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_baby_equip_stage_up, [RoleId, PosId, OprType, OldStage, OldStageLv, OldStageExp, NewStage, NewStageLv, NewStageExp, SCostList, utime:unixtime()]),
    ok.
%% 宝宝装备铭刻
log_baby_equip_engrave(RoleId, GoodsId, GoodsTypeId, IsSucc, EngraveRation, SkillId, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_baby_equip_engrave, [RoleId, GoodsId, GoodsTypeId, IsSucc, EngraveRation, SkillId, SCostList, utime:unixtime()]),
    ok.

%% 市场上架日志
log_sell_up(SellerId, SellType, SellId, GoodsId, GoodsNum, UnitPrice, SpecifyerId, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_up, [SellerId, SellType, SellId, GoodsId, GoodsNum, UnitPrice, SpecifyerId, ExtraStr, utime:unixtime()]),
    ok.

%% 市场上架日志跨服
log_sell_up_kf(ServerId, ServerNum, SellerId, SellType, SellId, GoodsId, GoodsNum, UnitPrice, SpecifyerId, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_up_kf, [ServerId, ServerNum, SellerId, SellType, SellId, GoodsId, GoodsNum, UnitPrice, SpecifyerId, ExtraStr, utime:unixtime()]),
    ok.

%% 市场交易日志
log_sell_pay(SellType, SellId, GoodsId, GoodsNum, UnitPrice, Tax, SellerId, BuyerId, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_pay, [SellType, SellId, GoodsId, GoodsNum, UnitPrice, Tax, SellerId, BuyerId, ExtraStr, utime:unixtime()]),
    ok.

%% 市场交易日志
log_sell_pay_kf(SellType, SellId, GoodsId, GoodsNum, UnitPrice, Tax, ServerId1, ServerNum1, SellerId, ServerId2, ServerNum2, BuyerId, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_pay_kf, [SellType, SellId, GoodsId, GoodsNum, UnitPrice, Tax, ServerId1, ServerNum1,SellerId, ServerId2, ServerNum2, BuyerId, ExtraStr, utime:unixtime()]),
    ok.

%% 市场下架日志
log_sell_down(SellId, GoodsId, GoodsNum, SellerId, DownType, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_down, [SellId, GoodsId, GoodsNum, SellerId, DownType, ExtraStr, utime:unixtime()]),
    ok.

%% 市场下架日志
log_sell_down_kf(SellId, GoodsId, GoodsNum, ServerId, ServerNum, SellerId, DownType, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_sell_down_kf, [SellId, GoodsId, GoodsNum, ServerId, ServerNum, SellerId, DownType, ExtraStr, utime:unixtime()]),
    ok.



log_seek_up(Id, PlayerId, GTypeId, GoodsNum, UnitPrice) ->
    mod_log:add_log(log_seek_up, [Id,  PlayerId, GTypeId, GoodsNum, UnitPrice, utime:unixtime()]),
    ok.

log_seek_up_kf(Id, ServerId, ServerNum, PlayerId, GTypeId, GoodsNum, UnitPrice) ->
    mod_log:add_log(log_seek_up_kf, [Id,  ServerId, ServerNum, PlayerId, GTypeId, GoodsNum, UnitPrice, utime:unixtime()]),
    ok.


log_seek_down(Id, PlayerId, DownType, GTypeId, GoodsNum, UnitPrice, MoneyReturn) ->
    mod_log:add_log(log_seek_down, [Id,  PlayerId, DownType, GTypeId, GoodsNum, UnitPrice, util:term_to_bitstring(MoneyReturn), utime:unixtime()]),
    ok.


log_seek_down_kf(Id, ServerId, ServerNum, PlayerId, DownType, GTypeId, GoodsNum, UnitPrice, MoneyReturn) ->
    mod_log:add_log(log_seek_down_kf, [Id, ServerId, ServerNum, PlayerId, DownType, GTypeId, GoodsNum, UnitPrice, util:term_to_bitstring(MoneyReturn), utime:unixtime()]),
    ok.



%% 上传头像日志
log_picture(RoleId, Picture, PictureVer) ->
    mod_log:add_log(log_picture, [RoleId, Picture, PictureVer, utime:unixtime()]),
    ok.

%% 永恒碑谷阶段达成日志
log_eternal_valley_stage(RoleId, Chapter, Stage, Condition) ->
    ConditionStr = util:term_to_bitstring(Condition),
    mod_log:add_log(log_eternal_valley_stage, [RoleId, Chapter, Stage, ConditionStr, utime:unixtime()]),
    ok.

%% 符文合成日志
log_rune_compose(RoleId, GoodsList, NewGoodsTypeId, NewRuneLv, OldRunePoint, NewRunePoint) ->
    SGoodsList = util:term_to_bitstring(GoodsList),
    mod_log:add_log(log_rune_compose, [RoleId, SGoodsList, NewGoodsTypeId, NewRuneLv, OldRunePoint, NewRunePoint, utime:unixtime()]),
    ok.

%% 聚魂合成日志
log_soul_compose(RoleId, GoodsList, NewGoodsTypeId, NewSoulLv, NewAwakeLvlist, OldSoulPoint, NewSoulPoint) ->
    SGoodsList = util:term_to_bitstring(GoodsList),
    NewAwakeLvlistBin = util:term_to_bitstring(NewAwakeLvlist),
    mod_log:add_log(log_soul_compose, [RoleId, SGoodsList, NewGoodsTypeId, NewSoulLv, NewAwakeLvlistBin, OldSoulPoint, NewSoulPoint, utime:unixtime()]),
    ok.

%% 符文镶嵌日志
log_rune_wear(RoleId, PosId, NewGoodsTypeId, Color, Lv) ->
    mod_log:add_log(log_rune_wear, [RoleId, PosId, NewGoodsTypeId, Color, Lv, utime:unixtime()]),
    ok.

%% 聚魂镶嵌日志
log_soul_wear(RoleId, PosId, NewGoodsTypeId, Color, Lv) ->
    mod_log:add_log(log_soul_wear, [RoleId, PosId, NewGoodsTypeId, Color, Lv, utime:unixtime()]),
    ok.

%% 符文升级日志
log_rune_level_up(RoleId, GoodsTypeId, Level, NewLevel, NeedRunePoint) ->
    mod_log:add_log(log_rune_level_up, [RoleId, GoodsTypeId, Level, NewLevel, NeedRunePoint, utime:unixtime()]),
    ok.

%% 聚魂升级日志
log_soul_level_up(RoleId, GoodsTypeId, Level, NewLevel, NeedSoulPoint) ->
    mod_log:add_log(log_soul_level_up, [RoleId, GoodsTypeId, Level, NewLevel, NeedSoulPoint, utime:unixtime()]),
    ok.

%% 符文兑换日志
log_rune_exchange(RoleId, OldRuneChip, NewRuneChip, GoodsList) ->
    SGoodsList = util:term_to_bitstring(GoodsList),
    mod_log:add_log(log_rune_exchange, [RoleId, OldRuneChip, NewRuneChip, SGoodsList, utime:unixtime()]),
    ok.

%% 时装染色/解锁颜色日志
log_fashion_color(RoleId, PosId, FashionId, ColorId, Type, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_fashion_color, [RoleId, PosId, FashionId, ColorId, Type, SCostList, utime:unixtime()]),
    ok.

%% 时装激活/升星日志
log_fashion_star(RoleId, PosId, FashionId, Type, OldStarLv, NewStarLv, CostList) ->
    SCostList = util:term_to_bitstring(CostList),
    mod_log:add_log(log_fashion_star, [RoleId, PosId, FashionId, Type, OldStarLv, NewStarLv, SCostList, utime:unixtime()]),
    ok.

%% 时装部位升级日志(弃用)
log_fashion_pos(RoleId, PosId, OldPosLv, NewPosLv, Cost) ->
    mod_log:add_log(log_fashion_pos, [RoleId, PosId, OldPosLv, NewPosLv, Cost, utime:unixtime()]),
    ok.

%% 时装部位升级日志
log_fashion_upgrade(RoleId, PosId, PosLv, PosUpgradeNum, NewPosLv, NewPosUpgradeNum, CostList) ->
    mod_log:add_log(log_fashion_upgrade, [RoleId, PosId, PosLv, PosUpgradeNum, NewPosLv, NewPosUpgradeNum, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

%% 爵位升级日志
log_juewei_level_up(RoleId, OldJueWeiLv, NewJueWeiLv) ->
    mod_log:add_log(log_juewei_level_up, [RoleId, OldJueWeiLv, NewJueWeiLv, utime:unixtime()]),
    ok.


%% 竞技购买次数日志
log_jjc_buy_times(RoleId, PreGold, PreBGold, PreCoin, BuyTimes, AfterGold, AfterBGold, AfterCoin) ->
    mod_log:add_log(log_jjc_buy_times, [RoleId, PreGold, PreBGold, PreCoin, BuyTimes, AfterGold, AfterBGold, AfterCoin, utime:unixtime()]),
    ok.

%% 竞技鼓舞次数日志
log_jjc_inspire(RoleId, PreGold, PreBGold, PreCoin, PreCombat, InspireTimes, AfterGold, AfterBGold, AfterCoin, AfterCombat) ->
    mod_log:add_log(log_jjc_inspire, [RoleId, PreGold, PreBGold, PreCoin, PreCombat, InspireTimes, AfterGold, AfterBGold, AfterCoin, AfterCombat, utime:unixtime()]),
    ok.

%% 竞技名次突破日志
log_jjc_break_rank(RoleId, BreakId, BreakRank, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_jjc_break_rank, [RoleId, BreakId, BreakRank, RewardStr, utime:unixtime()]),
    ok.

%% 竞技结算排名日志
log_jjc_clear(RoleId, Rank, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_jjc_clear, [RoleId, Rank, RewardStr, utime:unixtime()]),
    ok.

%% 竞技排位赛日志
log_jjc(RoleId, BeforeRank, RivalId,  RivalRank, Result, AfterRank) ->
    mod_log:add_log(log_jjc, [RoleId, BeforeRank, RivalId, RivalRank, Result, AfterRank, utime:unixtime()]),
    ok.

%% 装扮激活升星日志
log_dress_star(RoleId, DressType, DressId, DressLv, DressExp, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_dress_star, [RoleId, DressType, DressId, DressLv, DressExp, CostStr, utime:unixtime()]),
    ok.

%% 装扮图鉴升级日志
log_dress_illu_lv(RoleId, IlluLv, IlluExp, NewIlluLv, NewIlluExp, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_dress_illu_lv, [RoleId, IlluLv, IlluExp, NewIlluLv, NewIlluExp, CostStr, utime:unixtime()]),
    ok.

%% 装扮激活
log_active_dress_up(RoleId, DressType, DressId, OldLevel, NewLevel, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_active_dress_up, [RoleId, DressType, DressId, OldLevel, NewLevel, CostStr, utime:unixtime()]),
    ok.

%% 求婚日志
log_marriage_propose(RoleId1, CostList1, RoleId2, CostList2, Type, WeddingType) ->
    mod_log:add_log(log_marriage_propose, [RoleId1, util:term_to_bitstring(CostList1), RoleId2, util:term_to_bitstring(CostList2), Type, WeddingType, utime:unixtime()]),
    ok.

%% 翅膀升级日志
log_wing_lv(RoleId, PreLv, PreExp, AfterLv, AfterExp, Cost, SkillIds) ->
    CostStr = util:term_to_bitstring(Cost),
    SkillIdsStr = util:term_to_bitstring(SkillIds),
    mod_log:add_log(log_wing_lv, [RoleId, PreLv, PreExp, AfterLv, AfterExp, CostStr, SkillIdsStr, utime:unixtime()]),
    ok.

%% 翅膀培养道具日志
log_wing_develop(RoleId, GoodsId, UseNum, MaxNum, PreAttr, AfterAttr) ->
    PreAttrStr = util:term_to_bitstring(PreAttr),
    AfterAttrStr = util:term_to_bitstring(AfterAttr),
    mod_log:add_log(log_wing_develop, [RoleId, GoodsId, UseNum, MaxNum, PreAttrStr, AfterAttrStr, utime:unixtime()]),
    ok.

%% 翅膀幻形日志
log_wing_illusion(RoleId, IllusionId, Opt, PreStar, AfterStar, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_wing_illusion, [RoleId, IllusionId, Opt, PreStar, AfterStar, CostStr, utime:unixtime()]),
    ok.

%% 法宝升级日志
log_talisman_lv(RoleId, PreLv, PreExp, AfterLv, AfterExp, Cost, SkillIds) ->
    CostStr = util:term_to_bitstring(Cost),
    SkillIdsStr = util:term_to_bitstring(SkillIds),
    mod_log:add_log(log_talisman_lv, [RoleId, PreLv, PreExp, AfterLv, AfterExp, CostStr, SkillIdsStr, utime:unixtime()]),
    ok.

%% 法宝培养道具日志
log_talisman_develop(RoleId, GoodsId, UseNum, MaxNum, PreAttr, AfterAttr) ->
    PreAttrStr = util:term_to_bitstring(PreAttr),
    AfterAttrStr = util:term_to_bitstring(AfterAttr),
    mod_log:add_log(log_talisman_develop, [RoleId, GoodsId, UseNum, MaxNum, PreAttrStr, AfterAttrStr, utime:unixtime()]),
    ok.

%% 法宝幻形日志
log_talisman_illusion(RoleId, IllusionId, Opt, PreStar, AfterStar, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_talisman_illusion, [RoleId, IllusionId, Opt, PreStar, AfterStar, CostStr, utime:unixtime()]),
    ok.

%% 神兵升级日志
log_godweapon_lv(RoleId, PreLv, PreExp, AfterLv, AfterExp, Cost, SkillIds) ->
    CostStr = util:term_to_bitstring(Cost),
    SkillIdsStr = util:term_to_bitstring(SkillIds),
    mod_log:add_log(log_godweapon_lv, [RoleId, PreLv, PreExp, AfterLv, AfterExp, CostStr, SkillIdsStr, utime:unixtime()]),
    ok.

%% 神兵培养道具日志
log_godweapon_develop(RoleId, GoodsId, UseNum, MaxNum, PreAttr, AfterAttr) ->
    PreAttrStr = util:term_to_bitstring(PreAttr),
    AfterAttrStr = util:term_to_bitstring(AfterAttr),
    mod_log:add_log(log_godweapon_develop, [RoleId, GoodsId, UseNum, MaxNum, PreAttrStr, AfterAttrStr, utime:unixtime()]),
    ok.

%% 神兵幻形日志
log_godweapon_illusion(RoleId, IllusionId, Opt, PreStar, AfterStar, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_godweapon_illusion, [RoleId, IllusionId, Opt, PreStar, AfterStar, CostStr, utime:unixtime()]),
    ok.

%% 装备寻宝日志
log_treasure_hunt(RoleId, HType, CType, AutoBuy, Cost, Reward, LuckeyValue, NewLuckyValue) ->
    CostStr = util:term_to_bitstring(Cost),
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_treasure_hunt, [RoleId, HType, CType, AutoBuy, CostStr, RewardStr, LuckeyValue, utime:unixtime(), NewLuckyValue]),
    ok.

%% 物品兑换日志
log_goods_exchange(RoleId, Type, Cost, Reward) ->
    CostStr = util:term_to_bitstring(Cost),
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_goods_exchange, [RoleId, Type, CostStr, RewardStr, utime:unixtime()]),
    ok.

%% 祈愿日志
log_pray(RoleId, RoleLv, Type, Times, Free, CritMul, Cost, Reward) ->
    CostStr = util:term_to_bitstring(Cost),
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_pray, [RoleId, RoleLv, Type, Times, Free, CritMul, CostStr, RewardStr, utime:unixtime()]),
    ok.

%% 求婚回应日志表
log_marriage_answer(RoleId, ProposeRoleId, AnswerType, MarriageType, ProposeType, RewardS, RewardO, ReturnCost) ->
    mod_log:add_log(log_marriage_answer, [RoleId, ProposeRoleId, AnswerType, MarriageType, ProposeType, util:term_to_bitstring(RewardS), util:term_to_bitstring(RewardO), util:term_to_bitstring(ReturnCost), utime:unixtime()]),
    ok.

%% 婚礼预约日志表
log_marriage_wedding_order(RoleIdM, RoleIdW, OrderTime, WeddingType, OrderType) ->
    mod_log:add_log(log_marriage_wedding_order, [RoleIdM, RoleIdW, OrderTime, WeddingType, OrderType, utime:unixtime()]),
    ok.

%% 婚礼结束日志表
log_marriage_wedding_end(RoleIdM, RoleIdW, ManIn, WomanIn, EndType, EnterRoleIdList) ->
    SEnterRoleIdList = util:term_to_bitstring(EnterRoleIdList),
    mod_log:add_log(log_marriage_wedding_end, [RoleIdM, RoleIdW, ManIn, WomanIn, EndType, SEnterRoleIdList, utime:unixtime()]),
    ok.

% 神器激活日志表
log_artifact_active(RoleId, ArtiId, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_artifact_active, [RoleId, ArtiId, CostStr, utime:unixtime()]),
    ok.

% 神器强化日志表
log_artifact_lv(RoleId, ArtiId, Lv, GiftId, GiftAttr, Cost) ->
    GiftAttrStr =  util:term_to_bitstring(GiftAttr),
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_artifact_lv, [RoleId, ArtiId, Lv, GiftId, GiftAttrStr, CostStr, utime:unixtime()]),
    ok.

% 神器附灵日志表
log_artifact_enchant(RoleId, ArtiId, EnchPec, EnchAttr, NewAttr, Cost) ->
    EnchPecStr = util:term_to_bitstring(EnchPec),
    EnchAttrStr = util:term_to_bitstring(EnchAttr),
    NewAttrStr = util:term_to_bitstring(NewAttr),
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_artifact_enchant, [RoleId, ArtiId, EnchPecStr, EnchAttrStr, NewAttrStr, CostStr, utime:unixtime()]),
    ok.

%% 婚礼气氛值日志表
log_marriage_wedding_aura(RoleIdM, RoleIdW, RoleId, Type, OldAura, NewAura) ->
    mod_log:add_log(log_marriage_wedding_aura, [RoleIdM, RoleIdW, RoleId, Type, OldAura, NewAura, utime:unixtime()]),
    ok.

%% 一生一世培养日志表
log_marriage_life_train(RoleId, OldStage, OldHeart, OldLoveNum, NewStage, NewHeart, NewLoveNum) ->
    mod_log:add_log(log_marriage_life_train, [RoleId, OldStage, OldHeart, OldLoveNum, NewStage, NewHeart, NewLoveNum, utime:unixtime()]),
    ok.

% 分手/离婚日志表
log_marriage_divorse(RoleIdM, RoleIdW, RoleId, MarriageType, CostList) ->
    SCostList =  util:term_to_bitstring(CostList),
    mod_log:add_log(log_marriage_divorse, [RoleIdM, RoleIdW, RoleId, MarriageType, SCostList, utime:unixtime()]),
    ok.

%% 真爱礼包
log_buy_love_gift(RoleId, RoleIdOther, Type, Cost, LoveGiftTimeS, LoveGiftTimeO, Reward) ->
    mod_log:add_log(log_buy_love_gift, [RoleId, RoleIdOther, Type, util:term_to_bitstring(Cost), LoveGiftTimeS, LoveGiftTimeO, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_rename_guild(GuildId, RoleId, GuildName0, GuildName, Type) ->
    mod_log:add_log(log_rename_guild, [GuildId, RoleId, GuildName0, GuildName, Type, utime:unixtime()]),
    ok.

%% 活跃度外形升级日志
log_liveness_up(RoleId, PreLv, Liveness, AfterLv) ->
    mod_log:add_log(log_liveness_up, [RoleId, PreLv, Liveness, AfterLv, utime:unixtime()]),
    ok.

%% 荣誉值产出日志
log_produce_honour(Type, Ps, NewPS, Remark) ->
    ProduceType = data_goods:get_produce_type(Type),
    OldH = Ps#player_status.jjc_honour,
    NewH = NewPS#player_status.jjc_honour,
    GotH = max(NewH - OldH, 0),
    mod_log:add_log(log_produce_honour, [Ps#player_status.id, ProduceType, OldH, NewH, GotH, Remark, utime:unixtime()]),
    ok.

%% 荣誉值消耗日志
log_cost_honour(Type, Ps, NewPS, Remark) ->
    ProduceType = data_goods:get_consume_type(Type),
    OldH = Ps#player_status.jjc_honour,
    NewH = NewPS#player_status.jjc_honour,
    CostH = max(OldH - NewH, 0),
    mod_log:add_log(log_cost_honour, [Ps#player_status.id, ProduceType, OldH, NewH, CostH, Remark, utime:unixtime()]),
    ok.

%% 开服冲榜排行日志
log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_rush_rank_reward, [RoleId, RankType, Rank, Value, RewardStr, utime:unixtime()]),
    ok.

%% 开服冲榜目标日志
log_rush_goal_reward(RoleId, RankType, GoalId, Value, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_rush_goal_reward, [RoleId, RankType, GoalId, Value, RewardStr, utime:unixtime()]),
    ok.

%% 本服魅力榜日志
log_flower_rank_local(RoleId, Sex, Rank, Value, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_flower_rank_local, [RoleId, Sex, Rank, Value, RewardStr, utime:unixtime()]),
    ok.

%% 跨服魅力榜日志
log_flower_rank_kf(RoleId, Name, ServerId, PlatForm, ServerNum, Sex, Rank, Value, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_flower_rank_kf, [RoleId, Name, ServerId, PlatForm, ServerNum, Sex, Rank, Value, RewardStr, utime:unixtime()]),
    ok.

%% 婚礼榜日志
log_wed_rank(RoleId, SecId, Rank, BookTime, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_wed_rank, [RoleId, SecId, Rank, BookTime, RewardStr, utime:unixtime()]),
    ok.

%% 有礼分享分享次数日志
log_share_times(RoleId, Times) ->
    mod_log:add_log(log_share_times, [RoleId, Times, utime:unixtime()]),
    ok.

%% 后台删除邮件日志
log_mail_clear(RoleId, Title, CmAttachment, State, EffectSt) ->
    mod_log:add_log(log_mail_clear, [RoleId, Title, CmAttachment, State, EffectSt, utime:unixtime()]),
    ok.

%% 社交关系日志
log_rela(RoleId, OtherRoleId, PreRela, CtrlType, Rela) ->
    mod_log:add_log(log_rela, [RoleId, OtherRoleId, PreRela, CtrlType, Rela, utime:unixtime()]),
    ok.

%% 亲密度日志
log_intimacy(RoleId, OtherRoleId, PreIntimacy, ObtainWay, CurIntimacy, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_intimacy, [RoleId, OtherRoleId, PreIntimacy, ObtainWay, CurIntimacy, ExtraStr, utime:unixtime()]),
    ok.

%% 宠物升级日志
log_pet_upgrade_lv(RoleId, PreLv, PreExp, ExpPlus, VipPlusRatio, CurLv, CurExp, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    PlusRatioStr = util:term_to_bitstring(VipPlusRatio),
    mod_log:add_log(log_pet_upgrade_lv, [RoleId, PreLv, PreExp, ExpPlus, PlusRatioStr, CurLv, CurExp, CostStr, utime:unixtime()]),
    ok.

%% 宠物升星日志
log_pet_upgrade_star(RoleId, PreStage, PreStar, PreBlessing, BlessingPlus, CurStage, CurStar, CurBlessing, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_pet_upgrade_star, [RoleId, PreStage, PreStar, PreBlessing, BlessingPlus, CurStage, CurStar, CurBlessing, CostStr, utime:unixtime()]),
    ok.

%% 宠物幻形升阶日志
log_pet_figure_upgrade_stage(RoleId, FigureId, Type, PreStage, PreBlessing, BlessingPlus, CurStage, CurBlessing, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_pet_figure_upgrade_stage, [RoleId, FigureId, Type, PreStage, PreBlessing, BlessingPlus, CurStage, CurBlessing, CostStr, utime:unixtime()]),
    ok.

%% 宠物道具培养日志
log_pet_goods_use(RoleId, GoodsId, UseTimes, TimesLim, PreAttrL, CurAttrL) ->
    PreAttrLStr = util:term_to_bitstring(PreAttrL),
    CurAttrLStr = util:term_to_bitstring(CurAttrL),
    mod_log:add_log(log_pet_goods_use, [RoleId, GoodsId, UseTimes, TimesLim, PreAttrLStr, CurAttrLStr, utime:unixtime()]),
    ok.

%% 使魔激活
log_active_demons(RoleId, DemonsId, CostList) ->
    mod_log:add_log(log_active_demons, [RoleId, DemonsId, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

log_up_star_demons(RoleId, DemonsId, OldStar, NewStar, CostList) ->
    mod_log:add_log(log_up_star_demons, [RoleId, DemonsId, OldStar, NewStar, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

log_up_level_demons(RoleId, DemonsId, Level, Exp, NewLevel, NewExp, CostList) ->
    mod_log:add_log(log_up_level_demons, [RoleId, DemonsId, Level, Exp, NewLevel, NewExp, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

log_demons_painting_reward(RoleId, PaintingId, PaintingNum, Reward) ->
    mod_log:add_log(log_demons_painting_reward, [RoleId, PaintingId, PaintingNum, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_upgrade_demons_skill(RoleId, DemonsId, SkillId, SkillLv, CostList) ->
    mod_log:add_log(log_upgrade_demons_skill, [RoleId, DemonsId, SkillId, SkillLv, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

%% 坐骑类升星日志
log_mount_upgrade_star(RoleId,TypeId, PreStage, PreStar, PreBlessing, BlessingPlus, CurStage, CurStar, CurBlessing, Cost, ClearTime) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_mount_upgrade_star, [RoleId,TypeId, PreStage, PreStar, PreBlessing, BlessingPlus, CurStage, CurStar, CurBlessing, CostStr, utime:unixtime(), ClearTime]),
    ok.

%% 坐骑类幻形升阶日志
log_mount_figure_upgrade_stage(RoleId,TypeId, FigureId, Type, PreStage, CurStage, Cost, BlessPlus, Blessing) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_mount_figure_upgrade_stage, [RoleId, TypeId, FigureId, Type, PreStage, CurStage, CostStr,BlessPlus, Blessing, utime:unixtime()]),
    ok.

%% 坐骑类道具培养日志
log_mount_goods_use(RoleId,TypeId, GoodsId, UseTimes, TimesLim, PreAttrL, CurAttrL) ->
    PreAttrLStr = util:term_to_bitstring(PreAttrL),
    CurAttrLStr = util:term_to_bitstring(CurAttrL),
    mod_log:add_log(log_mount_goods_use, [RoleId, TypeId, GoodsId, UseTimes, TimesLim, PreAttrLStr, CurAttrLStr, utime:unixtime()]),
    ok.

%% 公会贡献产出日志
log_produce_gdonate(RoleId, Type, AddGDonate, RemainGDonate, HGDonate, Extra) ->
    ProduceType = data_goods:get_produce_type(Type),
    mod_log:add_log(log_produce_gdonate, [RoleId, ProduceType, AddGDonate, RemainGDonate, HGDonate, Extra, utime:unixtime()]).

%% 公会贡献消耗日志
log_consume_gdonate(RoleId, Type, CostGDonate, RemainGDonate, Extra) ->
    ConsumeType = data_goods:get_consume_type(Type),
    mod_log:add_log(log_consume_gdonate, [RoleId, ConsumeType, CostGDonate, RemainGDonate, Extra, utime:unixtime()]).

%% 公会成长值产出日志
log_produce_growth(GuildId, RoleId, Type, AddGrowth, NewGrowth) ->
    ProduceType = data_goods:get_produce_type(Type),
    mod_log:add_log(log_produce_growth, [GuildId, RoleId, ProduceType, AddGrowth, NewGrowth, utime:unixtime()]).

%% 公会成长值消耗日志
log_consume_growth(GuildId, RoleId, Type, CostGrowth, RemainGrowth, Extra) ->
    ConsumeType = data_goods:get_consume_type(Type),
    mod_log:add_log(log_consume_growth, [GuildId, RoleId, ConsumeType, CostGrowth, RemainGrowth, Extra, utime:unixtime()]).

%% 公会boss龙魂
log_gboss_mat(GuildId, RoleId, Type, GBossMatVal, NewGBossMat, Extra) ->
    mod_log:add_log(log_gboss_mat, [GuildId, RoleId, Type, GBossMatVal, NewGBossMat, util:term_to_bitstring(Extra), utime:unixtime()]).

%% 公会创建解散日志
log_guild(GuildId, GuildName, Type, Extra) ->
    mod_log:add_log(log_guild, [GuildId, GuildName, Type, Extra, utime:unixtime()]).

%% 红包日志
log_red_envelopes(RedEnvelopesId, OwnershipType, OwnershipId, OwnerId, Status, Type, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_red_envelopes, [RedEnvelopesId, OwnershipType, OwnershipId, OwnerId, Status, Type, ExtraStr, utime:unixtime()]).

%% 红包领取日志
log_red_envelopes_recipients(RoleId, RedEnvelopesId, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_red_envelopes_recipients, [RoleId, RedEnvelopesId, RewardStr, utime:unixtime()]).

%% 公会仓库日志
log_guild_depot(RoleId, CtrlType, UniqueId, GTypeId, PreScore, CurScore) ->
    mod_log:add_log(log_guild_depot, [RoleId, CtrlType, UniqueId, GTypeId, PreScore, CurScore, utime:unixtime()]).

%% 公会技能日志
log_guild_skill(GuildId, GuildName, RoleId, CtrlType, SkillId, Cost, PreLv, CurLv) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_guild_skill, [GuildId, GuildName, RoleId, CtrlType, SkillId, CostStr, PreLv, CurLv, utime:unixtime()]).

log_guild_daily_gift(RoleId, Reward) ->
    mod_log:add_log(log_guild_daily_gift, [RoleId, util:term_to_bitstring(Reward), utime:unixtime()]).

log_guild_donate_gift(RoleId, Id, Reward) ->
    mod_log:add_log(log_guild_donate_gift, [RoleId, Id, util:term_to_bitstring(Reward), utime:unixtime()]).

log_guild_dun_result(RoleId, GuildId, Level, Door, Type, IsWin, Reward, ScoreAdd, NewChallengeTimes) ->
    mod_log:add_log(log_guild_dun_result, [RoleId, GuildId, Level, Door, Type, IsWin, util:term_to_bitstring(Reward), ScoreAdd, NewChallengeTimes, utime:unixtime()]).

%% 公会Boss日志 1:开启 2:挑战成功 3:挑战失败
log_guild_boss(GuildId, Status, Time) ->
    mod_log:add_log(log_guild_boss, [GuildId, Status, Time]).

%% 公会争霸赛区日志
log_guild_war_division(Stage, GuildId, GuildName, Division, Ranking) ->
    mod_log:add_log(log_guild_war_division, [Stage, GuildId, GuildName, Division, Ranking, utime:unixtime()]).

%% 公会争霸战斗日志
log_guild_war_battle(RedGid, RedGName, BlueGid, BlueGName, Round, WinnerGroup, WinnerReward, LoserReward) ->
    WinnerRewardStr = util:term_to_bitstring(WinnerReward),
    LoserRewardStr = util:term_to_bitstring(LoserReward),
    mod_log:add_log(log_guild_war_battle, [RedGid, RedGName, BlueGid, BlueGName, Round, WinnerGroup, WinnerRewardStr, LoserRewardStr, utime:unixtime()]).

%% 公会争霸玩家进出场景日志
%% Type  1:进入场景 2:主动退出场景 3:活动结束踢出场景
log_guild_war_scene(RoleId, Type, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_guild_war_scene, [RoleId, Type, ExtraStr, utime:unixtime()]).

%% 公会争霸连胜奖励日志
%% RewardType 1:连胜奖励 2:终结奖励
log_guild_war_reward(GuildId, GuildName, RewardType, Reward, Extra) ->
    RewardStr = util:term_to_bitstring(Reward),
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_guild_war_reward, [GuildId, GuildName, RewardType, RewardStr, ExtraStr, utime:unixtime()]).

%% 公会争霸奖励分配日志
%% AllotType 见ALLOT_TYPE
%% RewardType 1:连胜奖励 2:终结奖励
log_guild_war_allot_reward(GuildId, GuildName, RoleId, AllotType, RewardType, Reward) ->
    RewardStr = util:term_to_bitstring(Reward),
    mod_log:add_log(log_guild_war_allot_reward, [GuildId, GuildName, RoleId, AllotType, RewardType, RewardStr, utime:unixtime()]).

%% 砸蛋日志
log_smashed_egg(RoleId, SmashedType, SmashedEggNum, Index, FreeTimesLogTag, AutoBuy, CostL, RewardL) ->
    CostStr = util:term_to_bitstring(CostL),
    RewardStr = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_smashed_egg, [RoleId, SmashedType, SmashedEggNum, Index, FreeTimesLogTag, AutoBuy, CostStr, RewardStr, utime:unixtime()]).

%% 惊喜扭蛋日志
log_luckey_egg(RoleId, Type, SubType, FreeTimesUse, TotalTimesUse, Times, IsFree, AutoBuy, CostList, RewardList) ->
    CostStr = util:term_to_bitstring(CostList),
    RewardStr = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_luckey_egg, [RoleId, Type, SubType, FreeTimesUse, TotalTimesUse, Times, IsFree, AutoBuy, CostStr, RewardStr, utime:unixtime()]).

%% 云购日志
log_cloud_buy_kf(Values) ->
    mod_log:add_log(log_cloud_buy_kf, Values).

%% 活动Boss日志
log_act_boss(Platform, ServerId, AvgOnlineNum, Sum, KillNum, Extra) ->
    ExtraStr = util:term_to_bitstring(Extra),
    mod_log:add_log(log_act_boss, [Platform, ServerId, AvgOnlineNum, Sum, KillNum, ExtraStr, utime:unixtime()]).

log_eudemons_attack(ActId, RoleId, Rank, RoomId, BossKiller, Hurt, HurtPercent, Rewards, Time) ->
    RewardStr = util:term_to_string(Rewards),
    mod_log:add_log(log_eudemons_attack, [ActId, RoleId, Rank, RoomId, BossKiller, Hurt, HurtPercent, RewardStr, Time]).

%% 烟花使用日志
log_fireworks(RoleId, Num, Reward, AllNum) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_fireworks, [RoleId, Num, RewardStr, AllNum, utime:unixtime()]).

%% 嗨点日志
log_hi_points(SubType, RoleId, ModId, SubId, BeforePots, AfterPots) ->
    mod_log:add_log(log_hi_points, [SubType, RoleId, ModId, SubId, BeforePots, AfterPots, utime:unixtime()]).

%% 神秘限购购买日志
log_limit_shop_buy(RoleId, SellId, BuyNum, CostList, GoodsList, Discount, StartTime) ->
    mod_log:add_log(log_limit_shop_buy, [RoleId, SellId, BuyNum, CostList, GoodsList, Discount, StartTime, utime:unixtime()]).

%% 转职日志
log_transfer(RoleId, OldCareer, OldSex, NewCareer, NewSex, OldEquipList, NewEquipList) ->
    mod_log:add_log(log_transfer, [RoleId, OldCareer, OldSex, NewCareer, NewSex, util:term_to_string(OldEquipList), util:term_to_string(NewEquipList), utime:unixtime()]).

%% 幸运鉴宝
log_treasure_evaluation(RoleId, Type, OldLuckyNum, NewLuckyNum, CostList, RewardList) ->
    mod_log:add_log(log_treasure_evaluation, [RoleId, Type, OldLuckyNum, NewLuckyNum, CostList, RewardList, utime:unixtime()]).

%% 铸灵日志
log_equip_casting_spirit(RoleId, EquipPos, Cost, OldStage, OldLv, NewStage, NewLv) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_equip_casting_spirit, [RoleId, EquipPos, CostStr, OldStage, OldLv, NewStage, NewLv, utime:unixtime()]).

%% 护灵日志
log_equip_upgrade_spirit(RoleId, Cost, OldLv, NewLv) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_equip_upgrade_spirit, [RoleId, CostStr, OldLv, NewLv, utime:unixtime()]).

%% 收集活动日志
log_collect_put(SubType, AllRewardId, AllRewardType, NewAllPoint, RoleId, PutType, SelfRewardId, SelfRewardType, NewSelfPoint) ->
    mod_log:add_log(log_collect_put, [SubType, AllRewardId, AllRewardType, NewAllPoint, RoleId, PutType, SelfRewardId, SelfRewardType, NewSelfPoint, utime:unixtime()]).

%% 装备觉醒日志
log_equip_awakening(RoleId, EquipPos, Cost, PreLv, CurLv) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_equip_awakening, [RoleId, EquipPos, CostStr, PreLv, CurLv, utime:unixtime()]).

%% 装备唤魔日志
log_equip_skill(RoleId, EquipPos, SkillId, CtrlType, Cost, PreLv, CurLv, Extra) ->
    CostStr = util:term_to_string(Cost),
    ExtraStr = util:term_to_string(Extra),
    mod_log:add_log(log_equip_skill, [RoleId, EquipPos, SkillId, CtrlType, CostStr, PreLv, CurLv, ExtraStr, utime:unixtime()]).

%% 充值榜活动结算日志
log_recharge_rank_act(RoleId, Rank, Value, Reward) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_recharge_rank_act, [RoleId, Rank, Value, RewardStr, utime:unixtime()]).

%% 消费榜活动结算日志
log_consume_rank_act(RoleId, Rank, Value, Reward) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_consume_rank_act, [RoleId, Rank, Value, RewardStr, utime:unixtime()]).

%% 0元豪礼日志
log_login_return_reward(RoleId, SubType, Grade, Status, Cost, Reward) ->
    CostStr = util:term_to_string(Cost),
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_login_return_reward, [RoleId, SubType, Grade, Status, CostStr, RewardStr, utime:unixtime()]).

%% 星钻联赛报名
log_diamond_league_apply(Values) ->
    mod_log:add_log(log_diamond_league_apply, Values).

log_diamond_league_battle(RoundName, WinnerId, WinnerName, WinnerServ, WinnerDieCount, WinnerLife, LoserId, LoserName, LoserServ, LoserDieCount, Time) ->
    mod_log:add_log(log_diamond_league_battle, [RoundName, WinnerId, WinnerName, WinnerServ, WinnerDieCount, WinnerLife, LoserId, LoserName, LoserServ, LoserDieCount, Time]).

log_diamond_league_guess(RoleId, RoundName, GuessInfoStr, Op, Time) ->
    mod_log:add_log(log_diamond_league_guess, [RoleId, RoundName, GuessInfoStr, Op, Time]).

log_pet_aircraft_stage(RoleId, AircraftId, OldStage, NewStage, SCostList) ->
    mod_log:add_log(log_pet_aircraft_stage, [RoleId, AircraftId, OldStage, NewStage, SCostList, utime:unixtime()]).
log_flower_act_send_kf(SId, SName, SSerId, RId, RName, RSerId, OldCharm, NewCharm, GoodId) ->
    mod_log:add_log(log_flower_act_send_kf, [SId, SName, SSerId, RId, RName, RSerId, OldCharm, NewCharm, GoodId, utime:unixtime()]).

log_send_flower(SenderId, ReceiverId, Cost, IsFriend) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_send_flower, [SenderId, ReceiverId, CostStr, IsFriend, utime:unixtime()]).

log_fame(RoleId, PreVal, CurVal, Extra) ->
    case Extra of
        [{mail, Title}] ->
            ExtraStr = uio:format("mail_title:{1}", [Title]);
        _ ->
            ExtraStr = util:term_to_string(Extra)
    end,
    mod_log:add_log(log_fame, [RoleId, PreVal, CurVal, ExtraStr, utime:unixtime()]).

log_charm(RoleId, PreVal, CurVal, Extra) ->
    case Extra of
        [{mail, Title}] ->
            ExtraStr = uio:format("mail_title:{1}", [Title]);
        _ ->
            ExtraStr = util:term_to_string(Extra)
    end,
    mod_log:add_log(log_charm, [RoleId, PreVal, CurVal, ExtraStr, utime:unixtime()]).

log_3v3_pk_room(SceneId, ScenePoolId, RoomId, TowerDataF, PkId, Result, BName1, BName2, BName3, BScore,
    BTowerNum, RName1, RName2, RName3, RScore, RTowerNum) ->
    mod_log:add_log(log_3v3_pk_room, [SceneId, ScenePoolId, RoomId, util:term_to_string(TowerDataF), PkId, Result, BName1, BName2, BName3, BScore,
        BTowerNum, RName1, RName2, RName3, RScore, RTowerNum, utime:unixtime()]).

log_3v3_pk_team(PkId, TeamId, Group, Score, Kill, Killed, Assist, Result) ->
    mod_log:add_log(log_3v3_pk_team, [PkId, TeamId, Group, Score, Kill, Killed, Assist, Result, utime:unixtime()]).

log_3v3_pk_role(PkId, RoleId, Name, Group, OldTier, OldStar, OldContinuedWin, NewTier, NewStar, NewContinuedWin,
    Kill, Killed, Collect, Assist, Honor, IsMvp, Result) ->
    mod_log:add_log(log_3v3_pk_role, [PkId, RoleId, Name, Group, OldTier, OldStar, OldContinuedWin, NewTier, NewStar, NewContinuedWin,
        Kill, Killed, Collect, Assist, Honor, IsMvp, Result, utime:unixtime()]).

log_3v3_rank_reward(RankID, RoleID, Nickname, Tier, Star, Reward) ->
    mod_log:add_log(log_3v3_rank_reward, [RankID, RoleID, Nickname, Tier, Star, util:term_to_string(Reward), utime:unixtime()]).

log_3v3(RoleID, Type, OldTier, OldStar, Tier, Star, Result, Honor, OtherMsg) ->
    mod_log:add_log(log_3v3, [RoleID, Type, OldTier, OldStar, Tier, Star, Result, Honor, util:term_to_bitstring(OtherMsg), utime:unixtime()]).

log_dungeon_exp_gain(RoleId, DunId, Lv, NewLv, Exp, MonExp, Ratio1, Ratio2, ResultSubtype, Score, Time) ->
    mod_log:add_log(log_dungeon_exp_gain, [RoleId, DunId, Lv, NewLv, Exp, MonExp, Ratio1, Ratio2, ResultSubtype, Score, Time]).

log_lucky_flop_refresh(RoleId, RefreshTimes, IsFree, Cost, Reward, Time) ->
    CostStr = util:term_to_string(Cost),
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_lucky_flop_refresh, [RoleId, RefreshTimes, IsFree, CostStr, RewardStr, Time]).

log_lucky_flop_reward(RoleId, UseTimes, Cost, Reward, Time) ->
    CostStr = util:term_to_string(Cost),
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_lucky_flop_reward, [RoleId, UseTimes, CostStr, RewardStr, Time]).

log_holy_ghost_active(RoleId, GhostName, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_holy_ghost_active, [RoleId, GhostName, CostStr, utime:unixtime()]).

log_holy_ghost_stage(RoleId, GhostName, Cost, Stage, Exp, NewStage, NewExp) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_holy_ghost_stage, [RoleId, GhostName, CostStr, Stage, Exp, NewStage, NewExp, utime:unixtime()]).

log_holy_ghost_awake(RoleId, GhostName, Cost, Lv, NewLv) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_holy_ghost_awake, [RoleId, GhostName, CostStr, Lv, NewLv, utime:unixtime()]).

log_holy_ghost_illu_active(RoleId, IlluName, Op, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_holy_ghost_illu_active, [RoleId, IlluName, Op, CostStr, utime:unixtime()]).

log_holy_ghost_fight(RoleId, GhostName) ->
    mod_log:add_log(log_holy_ghost_fight, [RoleId, GhostName, utime:unixtime()]).

log_holy_ghost_relic(RoleId, RelicName, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_holy_ghost_relic, [RoleId, RelicName, CostStr, utime:unixtime()]).

log_house_buy_upgrade(AskRoleId, AnswerRoleId, RoleId1, RoleId2, OldHouseLv, NewHouseLv, AskCostList, AnswerCostList, OldHousePoint, NewHousePoint) ->
    SAskCostList = util:term_to_string(AskCostList),
    SAnswerCostList = util:term_to_string(AnswerCostList),
    mod_log:add_log(log_house_buy_upgrade, [AskRoleId, AnswerRoleId, RoleId1, RoleId2, OldHouseLv, NewHouseLv, SAskCostList, SAnswerCostList, OldHousePoint, NewHousePoint, utime:unixtime()]).

log_house_divorce(RoleId, LoverRoleId, BeForeBlockId, BeforeHouseId, BeforeHouseLv, AfterBlockId, AfterHouseId, AfterHouseLv) ->
    mod_log:add_log(log_house_divorce, [RoleId, LoverRoleId, BeForeBlockId, BeforeHouseId, BeforeHouseLv, AfterBlockId, AfterHouseId, AfterHouseLv, utime:unixtime()]).

log_house_choose(RoleId1, RoleId2, BlockId, HouseId, HouseLv, Type, AnswerType) ->
    mod_log:add_log(log_house_choose, [RoleId1, RoleId2, BlockId, HouseId, HouseLv, Type, AnswerType, utime:unixtime()]).

log_house_add_furniture(RoleId, GoodsId, GoodsTypeId, GoodsNum) ->
    mod_log:add_log(log_house_add_furniture, [RoleId, GoodsId, GoodsTypeId, GoodsNum, utime:unixtime()]).

log_mount_equip_lv(RoleId, Pos, PreLv, PreExp, NewLv, NewExp, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_mount_equip_lv, [RoleId, Pos, PreLv, PreExp, NewLv, NewExp, CostStr, utime:unixtime()]).

log_mount_equip_stage(RoleId, Pos, PreStage, NewStage, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_mount_equip_stage, [RoleId, Pos, PreStage, NewStage, CostStr, utime:unixtime()]).

log_mount_equip_engrave(RoleId, GoodId, TypeId, IsSuccess, SkillId, Cost) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_mount_equip_engrave, [RoleId, GoodId, TypeId, IsSuccess, SkillId, CostStr, utime:unixtime()]).

log_single_guess_bet(RoleId, GameType, SubType, CfgId, TotalTimes, Times, Odds, SelResult, Cost, Time) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_single_guess_bet, [RoleId, GameType, SubType, CfgId, TotalTimes, Times, Odds, SelResult, CostStr, Time]).

log_group_guess_bet(RoleId, GameType, CfgId, TotalTimes, Times, Odds, Cost, Time) ->
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_group_guess_bet, [RoleId, GameType, CfgId, TotalTimes, Times, Odds, CostStr, Time]).

log_guess_reward(RoleId, GameType, Type, CfgId, ReceiveType, Reward, Time) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_guess_reward, [RoleId, GameType, Type, CfgId, ReceiveType, RewardStr, Time]).

log_talent_skill(RoleId, Type, SkillId, SkillLv, OPower, Power, Time)->
    mod_log:add_log(log_talent_skill, [RoleId, Type, SkillId, SkillLv, OPower, Power, Time]).

log_investment_reward(RoleId, Type, Lv, Condition, Rewards, Bgold0, Bgold1, Op, Time) ->
    mod_log:add_log(log_investment_reward, [RoleId, Type, Lv, util:term_to_string(Condition), util:term_to_string(Rewards), Bgold0, Bgold1, Op, Time]).

log_investment_buy(RoleId, Type, Lv0, Lv1, Cost, Gold0, Gold1, Time) ->
    mod_log:add_log(log_investment_buy, [RoleId, Type, Lv0, Lv1, util:term_to_string(Cost), Gold0, Gold1, Time]).

log_kf_1vn_auction(AuctionId, Id, SerId, SerNum, Name, PriceAdd, Price, VoucherAdd) ->
    mod_log:add_log(log_kf_1vn_auction, [AuctionId, Id, SerId, SerNum, util:fix_sql_str(Name), PriceAdd, Price, VoucherAdd, utime:unixtime()]).

log_kf_1vn_race_1(Area, IdA, SerIdA, SerNumA, NameA, CPA, ScoreA, IdB, SerIdB, SerNumB, NameB, CPB, ScoreB, EndType) ->
    mod_log:add_log(log_kf_1vn_race_1, [Area, IdA, SerIdA, SerNumA, util:fix_sql_str(NameA), CPA, ScoreA, IdB, SerIdB, SerNumB, util:fix_sql_str(NameB), CPB, ScoreB, EndType, utime:unixtime()]).

%% Win 0:失败 1:胜利
%% EndType: 1击杀 2超时 3投降
%% Status 0:存活 1:死亡
log_kf_1vn_race_2(Area, MatchTurn, BattleId, Id, ServerId, SerNum, Name, CP, DefType, SidBWin, EndType, IsDead) ->
    mod_log:add_log(log_kf_1vn_race_2, [Area, MatchTurn, BattleId, Id, ServerId, SerNum, util:fix_sql_str(Name), CP, DefType, SidBWin, EndType, IsDead, utime:unixtime()]).

log_kf_1vn_sign(Id, ServerId, Lv, Name) ->
    mod_log:add_log(log_kf_1vn_sign, [Id, util:fix_sql_str(Name), ServerId, Lv, utime:unixtime()]).

log_pet_wing_stage(RoleId, WingId, OldStage, NewStage, SCostList) ->
    mod_log:add_log(log_pet_wing_stage, [RoleId, WingId, OldStage, NewStage, SCostList, utime:unixtime()]).

log_house_gift(BlockId, HouseId, RoleId1, RoleId2, RoleId, GiftId, OldPopularity, NewPopularity) ->
    mod_log:add_log(log_house_gift, [BlockId, HouseId, RoleId1, RoleId2, RoleId, GiftId, OldPopularity, NewPopularity, utime:unixtime()]).

log_kf_saint_challenge(ZoneId, SaintId, RoleServerName, RoleId, RoleName, SaintServerName, SaintRoleId, SaintRoleName, Res, DsgtId) ->
    mod_log:add_log(log_kf_saint_challenge, [ZoneId, SaintId, RoleServerName, RoleId, RoleName, SaintServerName, SaintRoleId, SaintRoleName, Res, DsgtId, utime:unixtime()]).

log_kf_saint_fight(SaintId, RoleId, RoleName, TurnId, InspireId, InspireNum) ->
    mod_log:add_log(log_kf_saint_fight, [SaintId, RoleId, RoleName, TurnId, InspireId, InspireNum, utime:unixtime()]).

log_pet_wing_add_time(RoleId, WingId, OldEndTime, NewEndTime, SCostList) ->
    mod_log:add_log(log_pet_wing_add_time, [RoleId, WingId, OldEndTime, NewEndTime, SCostList, utime:unixtime()]).

log_pet_wing_time_out(RoleId, WingId, OldShowId, NewShowId) ->
    mod_log:add_log(log_pet_wing_time_out, [RoleId, WingId, OldShowId, NewShowId, utime:unixtime()]).

log_boss_drop(SceneId, BossId, BossType, DropRoleId, BLIds, Goods, TeamId, Time)->
    mod_log:add_log(log_boss_drop, [SceneId, BossId, BossType, DropRoleId, BLIds, Goods, TeamId, Time]).

log_mount_equip_wear(RoleId, Pos, OldGoodsId, OldGTypeId, OldSkill, GoodsAutoId, GTypeId, NewSkill) ->
    mod_log:add_log(log_mount_equip_wear, [RoleId, Pos, OldGoodsId, OldGTypeId, OldSkill, GoodsAutoId, GTypeId, NewSkill, utime:unixtime()]).

log_pet_equip_pos_upgrade(RoleId, TypeId, Pos, GoodsTypeId, OldPosLv, AllPoint, NewPosLv, NewAllPoint, SCostLogList) ->
    mod_log:add_log(log_pet_equip_pos_upgrade, [RoleId, TypeId, Pos, GoodsTypeId, OldPosLv, AllPoint, NewPosLv, NewAllPoint, SCostLogList, utime:unixtime()]).

log_pet_equip_goods_upgrade(RoleId, TypeId, Pos, GoodsTypeId, CostGoodsTypeId, OldStage, OldStar, OldPosLv, OldAllPoint, NewStage, NewStar, NewPosLv, NewAllPoint) ->
    mod_log:add_log(log_pet_equip_goods_upgrade, [RoleId, TypeId, Pos, GoodsTypeId, CostGoodsTypeId, OldStage, OldStar, OldPosLv, OldAllPoint, NewStage, NewStar, NewPosLv, NewAllPoint, utime:unixtime()]).

log_house_merge(BlockId, HouseId, ServerIdA, ServerB, RoleId1A, RoleId2A, RoleId1B, RoleId2B, ReturnList1A, ReturnList2A, ReturnList1B, ReturnList2B) ->
    mod_log:add_log(log_house_merge, [BlockId, HouseId, ServerIdA, ServerB, RoleId1A, RoleId2A, RoleId1B, RoleId2B, ReturnList1A, ReturnList2A, ReturnList1B, ReturnList2B, utime:unixtime()]).

log_kf_1vn_bet(RoleId, RoleName, Turn, BattleId, BetOpt, Cost, Time) ->
    RoleNameF = util:fix_sql_str(RoleName),
    CostStr = util:term_to_string(Cost),
    mod_log:add_log(log_kf_1vn_bet, [RoleId, RoleNameF, Turn, BattleId, BetOpt, CostStr, Time]).

log_kf_1vn_bet_result(RoleId, RoleName, Turn, BattleId, BetTime, BattleResult, Hp, HpLim, LiveNum, BetCostType, BetOpt, BetResult) ->
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_kf_1vn_bet_result, [RoleId, RoleNameF, Turn, BattleId, BetTime, BattleResult, Hp, HpLim, LiveNum, BetCostType, BetOpt, BetResult, utime:unixtime()]).

log_kf_1vn_bet_receive(RoleId, Turn, BattleId, BetTime, BattleResult, BetCostType, BetOpt, BetResult, Reward) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_kf_1vn_bet_receive, [RoleId, Turn, BattleId, BetTime, BattleResult, BetCostType, BetOpt, BetResult, RewardStr, utime:unixtime()]).

log_daily_turntable(RoleId, SubType, OpType, IsAuto, Cost, Reward) ->
    CostStr = util:term_to_string(Cost),
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_daily_turntable, [RoleId, SubType, OpType, IsAuto, CostStr, RewardStr, utime:unixtime()]).

log_kf_guild_war_bid(SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, IslandName, Type, Extra, Time) ->
    ExtraStr = util:term_to_string(Extra),
    mod_log:add_log(log_kf_guild_war_bid, [SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, IslandName, Type, ExtraStr, Time]).

log_kf_guild_war_ranking_reward(SerId, SerName, RoleId, RoleName, KillNum, MaxCombo, KillRanking, KillReward, GuildRanking, GuildRankingReward, Time) ->
    KillRewardStr = util:term_to_string(KillReward),
    GuildRankingRewardStr = util:term_to_string(GuildRankingReward),
    mod_log:add_log(log_kf_guild_war_ranking_reward, [SerId, SerName, RoleId, RoleName, KillNum, MaxCombo, KillRanking, KillRewardStr, GuildRanking, GuildRankingRewardStr, Time]).

log_kf_guild_war_props(GuildId, GuildName, RoleId, Type, PropsName, PreNum, CurNum, Extra, Time) ->
    ExtraStr = util:term_to_string(Extra),
    mod_log:add_log(log_kf_guild_war_props, [GuildId, GuildName, RoleId, Type, PropsName, PreNum, CurNum, ExtraStr, Time]).

log_kf_guild_war_resource(GuildId, RoleId, Type, PreNum, CurNum, Extra, Time) ->
    ExtraStr = util:term_to_string(Extra),
    mod_log:add_log(log_kf_guild_war_resource, [GuildId, RoleId, Type, PreNum, CurNum, ExtraStr, Time]).

log_kf_guild_war_season_reward(SerId, SerName, GuildId, GuildName, Score, Ranking, Reward, Time) ->
    RewardStr = util:term_to_string(Reward),
    mod_log:add_log(log_kf_guild_war_season_reward, [SerId, SerName, GuildId, GuildName, Score, Ranking, RewardStr, Time]).

log_kf_guild_war_battle(SerId, SerName, GuildId, GuildName, Tag, IslandId, IslandName, Ranking, PreIslandId, CurIslandId, Time) ->
    mod_log:add_log(log_kf_guild_war_battle, [SerId, SerName, GuildId, GuildName, Tag, IslandId, IslandName, Ranking, PreIslandId, CurIslandId, Time]).

%% 技能升级日志
log_skill_lv_up(RoleID, SkillId, SkillOldLv, SkillNewLv, UpType, ConsumeList, Time) ->
    mod_log:add_log(log_skill_lv_up, [RoleID, SkillId, SkillOldLv, SkillNewLv, UpType, util:term_to_bitstring(ConsumeList), Time]),
    ok.


%% 结界守护日志
log_enchantment_guard(LogTable, RewardList, #player_status{enchantment_guard = Guard, id = Id} = Ps, Times) ->
    #enchantment_guard{gate =  Gate} = Guard,
    NewRewardList =  util:term_to_string(RewardList),
    case LogTable of
        ?ENCHANTMENT_GUAND_LOG_BATTLE ->
            ArgsList = [Id,  Gate, NewRewardList, utime:unixtime()],
            mod_log:add_log(LogTable, ArgsList),
            ta_agent_fire:log_enchantment_guard_battle(Ps, [Gate]);
        ?ENCHANTMENT_GUAND_LOG_SEAL    ->
            ArgsList = [Id, Times, Gate, NewRewardList, utime:unixtime()],
            mod_log:add_log(LogTable, ArgsList),
            ta_agent_fire:log_enchantment_guard_seal(Ps, [Times, Gate]);
        ?ENCHANTMENT_GUAND_LOG_SWEEP ->
            ArgsList = [Id, Times, Gate, NewRewardList, utime:unixtime()],
            mod_log:add_log(LogTable, ArgsList),
            ta_agent_fire:log_enchantment_guard_sweep(Ps, [Times, Gate]);
        _ ->
            ok
    end.

log_boss_cost(RoleId, TeamId, VipLv, Type, BossType, BossId, BeforeVit, BeforeLastVitTime, Vit, LastVitTime, Cost) ->
    mod_log:add_log(log_boss_cost, [RoleId, TeamId, VipLv, Type, BossType, BossId, BeforeVit, BeforeLastVitTime, Vit, LastVitTime, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.


%% 怪物图鉴升级日志
log_mon_pic_lv(RoleId, PicId, Lv, Cost, Time) ->
    mod_log:add_log(log_mon_pic_lv, [RoleId, PicId, Lv, util:term_to_bitstring(Cost), Time]),
    ok.

%% 神秘商店的日志
log_mystery_shop_bag(RoleId, Id, Cost, GoodList) ->
    mod_log:add_log(log_mystery_shop_bag, [RoleId, Id, util:term_to_bitstring(Cost), util:term_to_bitstring(GoodList), utime:unixtime()]),
    ok.

log_guild_battle_role(RoleId, GuildId, Score, TotalReward, NowTime) ->
    mod_log:add_log(log_guild_battle_role, [RoleId, GuildId, Score, util:term_to_bitstring(TotalReward), NowTime]),
    ok.

log_guild_battle_rank(RoleId,GuildId,Reward,Time) ->
    mod_log:add_log(log_guild_battle_rank, [RoleId, GuildId, util:term_to_bitstring(Reward), Time]),
    ok.

log_guild_battle(GuildId,Num,Score,Rank,Time) ->
    mod_log:add_log(log_guild_battle, [GuildId, Num, Score, Rank, Time]),
    ok.

%% 领地战
log_terri_war_result(Group, WarId, TerritoryId, Round, WinnerGuildId, AGuildId, AGuildName, AServerId, AServerNum, AScore, ACamp,
        BGuildId, BGuildName, BServerId, BServerNum, BScore, BCamp) ->
    mod_log:add_log(log_terri_war_result, [Group, WarId, TerritoryId, Round, WinnerGuildId, AGuildId, AGuildName, AServerId, AServerNum, AScore, util:term_to_bitstring(ACamp),
        BGuildId, BGuildName, BServerId, BServerNum, BScore, util:term_to_bitstring(BCamp), utime:unixtime()]),
    ok.

log_terri_war_allot_reward(GuildId, GuildName, RoleId, AllocType, RewardType, WinNum, Reward) ->
    mod_log:add_log(log_terri_war_allot_reward, [GuildId, GuildName, RoleId, AllocType, RewardType, WinNum, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 战斗奖励
log_terri_war_battle_reward(List) ->
    case List =/= [] of
        true-> mod_log:add_log(log_terri_war_battle_reward, List);
        false-> skip
    end,
    ok.

log_nine(RoleId, Name, Score, Stage, Type, MinGrade, MaxGrade, Reward) ->
    mod_log:add_log(log_nine, [RoleId, Name, Score, Stage, Type, MinGrade, MaxGrade, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_holyorgan_hire(RoleId, Type, SubType, AccHireTimes, HireCost, EndTime) ->
    mod_log:add_log(log_holyorgan_hire, [RoleId, Type, SubType, AccHireTimes, util:term_to_bitstring(HireCost), EndTime, utime:unixtime()]),
    ok.

log_invite_box_reward(RoleId, DailyCount, TotalCount, Reward) ->
    mod_log:add_log(log_invite_box_reward, [RoleId, DailyCount, TotalCount, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_invite_reward(RoleId, Type, RewardId, Reward) ->
    mod_log:add_log(log_invite_reward, [RoleId, Type, RewardId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 竞榜活动消耗
log_race_act_cost(RoleId, Lv, Type, SubType, Cost) ->
    mod_log:add_log(log_race_act_cost, [RoleId, Lv, Type, SubType, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 竞榜活动产出
log_race_act_produce(RoleId, Type, SubType, Reward, PType, WorldLv) ->
    mod_log:add_log(log_race_act_produce, [RoleId, Type, SubType, util:term_to_bitstring(Reward), PType, WorldLv, utime:unixtime()]),
    ok.

%% 竞榜活动排名
log_race_act_rank(RoleId, Name, Type, SubType, Score, Rank, ZoneId, ServerId) ->
    mod_log:add_log(log_race_act_rank, [RoleId, Name, Type, SubType, Score, Rank, ZoneId, ServerId, utime:unixtime()]),
    ok.

%% 冲榜夺宝排名
log_rush_treasure_rank(RoleId, Name, Type, SubType, RankType, Score, Rank, ZoneId, ServerId) ->
    mod_log:add_log(log_rush_treasure_rank, [RoleId, Name, Type, SubType, RankType, Score, Rank, ZoneId, ServerId, utime:unixtime()]).

%% 竞榜开启日志
log_race_act(List)->
    case List =/= [] of
        true-> mod_log:add_log(log_race_act, List);
        false-> skip
    end,
    ok.

%% 积分
log_race_act_score_cost(RoleId, Lv, Type, SubType, HandleType, OScore, Cost, NScore) ->
    mod_log:add_log(log_race_act_score_cost, [RoleId, Lv, Type, SubType, HandleType, OScore, Cost, NScore, utime:unixtime()]),
    ok.

%% 摇摇乐
log_shake(RoleId, SubType, CType, AutoBuy, Cost, GradeId, Award) ->
    CostStr = util:term_to_string(Cost),
    AwardStr = util:term_to_string(Award),
    mod_log:add_log(log_shake, [RoleId, SubType, CType, AutoBuy, CostStr, GradeId, AwardStr, utime:unixtime()]),
    ok.

%% 幻饰进阶日志
log_decoration_stage_up(RoleId, GoodsId, OldGTypeId, Cost, NewGTypeId) ->
    mod_log:add_log(log_decoration_stage_up, [RoleId, GoodsId, OldGTypeId, util:term_to_bitstring(Cost), NewGTypeId, utime:unixtime()]),
    ok.

%% 幻饰强化日志
log_decoration_level_up(PlayerId, EquipPos, Cost, PreLv, CurLv) ->
    mod_log:add_log(log_decoration_level_up, [PlayerId, EquipPos, util:term_to_bitstring(Cost), PreLv, CurLv, utime:unixtime()]),
    ok.

%% 精灵进阶日志
log_fairy_stage(RoleId, FairyId, OldStage, NewStage, Cost) ->
    mod_log:add_log(log_fairy_stage, [RoleId, FairyId, OldStage, NewStage, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 精灵升级日志
log_fairy_level(PlayerId, FairyId, OldLev, OldBless, NewLevel, NewBless, Cost) ->
    mod_log:add_log(log_fairy_level, [PlayerId, FairyId, OldLev, OldBless, NewLevel, NewBless, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 精灵转盘
log_spirit_rotary(RoleId, RotaryId, Count, BlessValue, NewBlessValue, CostList, RewardList) ->
    mod_log:add_log(log_spirit_rotary, [RoleId, RotaryId, Count, BlessValue, NewBlessValue, util:term_to_bitstring(CostList), util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_bonus_tree(RoleId, Type, SubType, Times, AutoBuy, CostList, GradeIds, Reward) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_bonus_tree, [RoleId, Type, SubType, Times, AutoBuy,
        util:term_to_bitstring(CostList), util:term_to_bitstring(GradeIds), util:term_to_bitstring(Reward), NowTime]),
    ok.

%% 钻石大战
log_drum_sign(Name,RoleId, Lv) ->
    mod_log:add_log(log_drum_sign, [Name,RoleId, Lv, utime:unixtime()]),
    ok.

log_drum_cost(RoleId, Type, Cost) ->
    mod_log:add_log(log_drum_cost, [RoleId, Type, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_drum_refuce(List) ->
    case List == [] of
        true -> ok;
        _ ->
            mod_log:add_log(log_drum_refuce, List),
            ok
    end.

log_drum_refuce_mail(List) ->
    case List == [] of
        true -> ok;
        _ ->
            mod_log:add_log(log_drum_refuce_mail, List),
            ok
    end.

log_drum_war(DrumID,WZone,WWar,WRoleID,WName,WSId,WPlat,WSnum,WLive,WPower,LRoleID,LName,LSId,LPlat,LSnum,LLive,LPower,Type) ->
    mod_log:add_log(log_drum_war, [DrumID,WZone,WWar,WRoleID,WName,WSId,WPlat,WSnum,WLive,WPower,LRoleID,LName,LSId,LPlat,LSnum,LLive,LPower,Type,utime:unixtime()]),
    ok.

log_drumwar_enter_scene(RoleId, Act, Group, OldScene, Scene) ->
    mod_log:add_log(log_drumwar_enter_scene, [RoleId, Act, Group, OldScene, Scene, utime:unixtime()]),
    ok.

%% 决斗购买次数日志
log_glad_buy_times(RoleId, PreGold, PreBGold, BuyTimes, AfterGold, AfterBGold) ->
    mod_log:add_log(log_glad_buy_times, [RoleId, PreGold, PreBGold, BuyTimes, AfterGold, AfterBGold, utime:unixtime()]),
    ok.

%% 决斗阶段奖励
log_glad_stage(RoleId, Score, StageReward) ->
    mod_log:add_log(log_glad_stage, [RoleId, Score, util:term_to_bitstring(StageReward), utime:unixtime()]),
    ok.

%% 决斗排位赛日志
log_glad(RoleId, BeforeRank, RivalId,  RivalRank, Result, AfterRank, ChallReward) ->
    mod_log:add_log(log_glad, [RoleId, BeforeRank, RivalId, RivalRank, Result, AfterRank, util:term_to_bitstring(ChallReward), utime:unixtime()]),
    ok.

%% 决斗排行奖励
log_glad_rank(RoleId, Rank, Score, RankReward) ->
    mod_log:add_log(log_glad_rank, [RoleId, Rank, Score, util:term_to_bitstring(RankReward), utime:unixtime()]),
    ok.

log_ugrade_arbitrament(RoleId, WeaponId, OLv, OScore, NLv, NScore, Cost) ->
    mod_log:add_log(log_ugrade_arbitrament, [RoleId, WeaponId, OLv, OScore, NLv, NScore, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_loop_arbitrament(RoleId, WeaponId, OLoopTimes, NLoopTimest, ScoreAdd) ->
    mod_log:add_log(log_loop_arbitrament, [RoleId, WeaponId, OLoopTimes, NLoopTimest, ScoreAdd, utime:unixtime()]),
    ok.

log_role_guild_feast_fire(RoleId, Color, FireWave, Reward, DragonPoint, GuildId) ->
    mod_log:add_log(log_role_guild_feast_fire, [RoleId, Color, FireWave, util:term_to_bitstring(Reward), DragonPoint, GuildId, utime:unixtime()]),
    ok.
%%Stage 1答题， 2 结算
log_role_guild_feast_quiz(RoleId, Stage, Point, DragonPoint, Rank, RewardList, GuildId, No, Tid) ->
    mod_log:add_log(log_role_guild_feast_quiz,
        [RoleId, Stage, Point, DragonPoint, Rank, util:term_to_bitstring(RewardList), GuildId, No, Tid, utime:unixtime()]),
    ok.

log_role_guild_feast_dragon(RoleId, RewardList, GuildId) ->
    mod_log:add_log(log_role_guild_feast_dragon,
        [RoleId, util:term_to_bitstring(RewardList), GuildId, utime:unixtime()]),
    ok.

log_wldboss_kill(RoleId, RoleName, BossId, RewardType, Rank, Reward, Time) ->
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_wldboss_kill,[RoleId, RoleNameF, BossId, RewardType, Rank, util:term_to_bitstring(Reward), Time]),
    ok.

%% 公会争霸运营活动
log_custom_act_gwar(RoleId, GradeId, Reward) ->
    mod_log:add_log(log_custom_act_gwar,[RoleId, GradeId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.
%% 勋章升级
log_role_medal(RoleId, Cost, OldMedalId, NewMedalId) ->
    mod_log:add_log(log_role_medal,[RoleId, util:term_to_bitstring(Cost), OldMedalId, NewMedalId, utime:unixtime()]),
    ok.
%% 星座升级
log_role_star_map(RoleId, Cost, OldStarMapId, NewStarMapId) ->
    mod_log:add_log(log_role_star_map,[RoleId, util:term_to_bitstring(Cost), OldStarMapId, NewStarMapId, utime:unixtime()]),
    ok.
%% 额外掉落
log_role_other_drop(RoleId, MonId, NDropList) ->
    mod_log:add_log(log_role_other_drop,[RoleId, MonId, util:term_to_bitstring(NDropList), utime:unixtime()]),
    ok.

log_role_attr_medicament(RoleId, Cost, Lv) ->
    mod_log:add_log(log_role_attr_medicament,[RoleId, util:term_to_bitstring(Cost), Lv, utime:unixtime()]),
    ok.

%%定制活动奖励日志
log_custom_act_reward(#player_status{id = RoleId} = Player, ActType, ActSubType, RewardId, Reward) when is_record(Player, player_status) ->
    ta_agent_fire:log_custom_act_reward(Player, [ActType, ActSubType, RewardId]),
    log_custom_act_reward(RoleId, ActType, ActSubType, RewardId, Reward),
    ok;
log_custom_act_reward(RoleId, ActType, ActSubType, RewardId, Reward) ->
    mod_log:add_log(log_custom_act_reward, [RoleId, ActType, ActSubType, RewardId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%%定制活动消耗日志
log_custom_act_cost(RoleId, ActType, ActSubType, CostList, OtherArgs) ->
    mod_log:add_log(log_custom_act_cost, [RoleId, ActType, ActSubType, util:term_to_bitstring(CostList), util:term_to_bitstring(OtherArgs), utime:unixtime()]),
    ok.

log_goods_fusion(RoleId, OLv, OExp, NLv, NExp, DelGoodsList) ->
    mod_log:add_log(log_goods_fusion, [RoleId, OLv, OExp, NLv, NExp, util:term_to_bitstring(DelGoodsList), utime:unixtime()]),
    ok.
%% boss进入退出日志
log_enter_or_exit_boss(RoleId, RoleName, RoleLv, Stage, BossType, BossId, Type, Cost, StayTime, Scene, X, Y, TeamId) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    BossName = lib_mon:get_name_by_mon_id(BossId),
    mod_log:add_log(log_enter_or_exit_boss, [RoleId, RoleNameF, RoleLv, Stage, BossId, BossType,
         util:fix_sql_str(BossName), Type, util:term_to_bitstring(Cost), StayTime, Scene, X, Y, TeamId, NowTime]),
    ok.
%% boss击杀日志
log_boss_kill(RoleId, RoleName, RoleLv, Stage, BossType, BossId, BossName, RewardL, TeamId) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_boss_kill, [RoleId, RoleNameF, RoleLv, Stage, BossType, BossId, util:fix_sql_str(BossName),
            util:term_to_bitstring(RewardL), TeamId, NowTime]),
    ok.

log_top_pk_enter_reward(RoleId, Count, RewardList) ->
    mod_log:add_log(log_top_pk_enter_reward, [RoleId, Count, util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_top_pk_stage_reward(RoleId, RankLv, RewardList) ->
    mod_log:add_log(log_top_pk_stage_reward, [RoleId, RankLv, util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_top_pk_season_reward(ServerNum, RoleId, RoleName, Rank, RewardList) ->
    mod_log:add_log(log_top_pk_season_reward, [ServerNum, RoleId, util:fix_sql_str(RoleName), Rank,
        util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_seal_stren(RoleId, RoleName, Pos, EquipTypeId, Stren0, Stren1, Cost) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_seal_stren, [RoleId, RoleNameF, Pos, EquipTypeId, Stren0, Stren1, util:term_to_bitstring(Cost), NowTime]),
    ok.

log_seal_pill(RoleId, RoleName, GoodsTypeId, Num, NewNum, Cost) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_seal_pill, [RoleId, RoleNameF, GoodsTypeId, Num, NewNum, util:term_to_bitstring(Cost), NowTime]),
    ok.

log_draconic_stren(RoleId, RoleName, Pos, EquipTypeId, Stren0, Stren1, Cost) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_draconic_stren, [RoleId, RoleNameF, Pos, EquipTypeId, Stren0, Stren1, util:term_to_bitstring(Cost), NowTime]),
    ok.

log_territory_reward(RoleId, RoleName, DunId, MonId, Reward) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_territory_reward, [RoleId, RoleNameF,DunId, MonId, util:term_to_bitstring(Reward), NowTime]),
    ok.

log_territory_rank(GuildId, GuildName, RoleId, RoleName, Hurt, Rank, Reward) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    GuildNameF = util:fix_sql_str(GuildName),
    mod_log:add_log(log_territory_rank, [GuildId, GuildNameF, RoleId, RoleNameF, Hurt, Rank, util:term_to_bitstring(Reward), NowTime]),
    ok.

log_custom_act_liveness(RoleId, Type, SubType, Times, CostList, GradeIds, Reward) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_custom_act_liveness, [RoleId, Type, SubType, Times,
        util:term_to_bitstring(CostList), util:term_to_bitstring(GradeIds), util:term_to_bitstring(Reward), NowTime]),
    ok.

log_custom_act_liveness_ser_reward(Type, SubType, GradeId, TriggerType, Param) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_custom_act_liveness_ser_reward, [Type, SubType, GradeId, TriggerType, util:term_to_bitstring(Param), NowTime]),
    ok.

%%圣域怪物击杀
log_sanctuary_kill(RoleId, MonId, BeKillRoleId, RewardList) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_sanctuary_kill, [RoleId, MonId, BeKillRoleId,
        util:term_to_bitstring(RewardList), NowTime]),
    ok.

%%圣域积分
log_sanctuary_point(RoleId, MonId, GetPointSanctuary, ReducePointSanctuary, Point) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_sanctuary_point, [RoleId, MonId, GetPointSanctuary,
        ReducePointSanctuary, Point, NowTime]),
    ok.

%%圣域归属
log_sanctuary_belong(SanctuaryId, BelongId) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_sanctuary_belong, [SanctuaryId, BelongId, NowTime]),
    ok.

%%圣域称号
log_sanctuary_designation(SanctuaryId, BelongId, RoleId, DesId) ->
    NowTime = utime:unixtime(),
    mod_log:add_log(log_sanctuary_designation, [SanctuaryId, BelongId, RoleId, DesId, NowTime]),
    ok.

log_kf_score_reward(ServerId, ServerNum, RoleId, RoleName, Score, Paied, RewardList) ->
    NowTime = utime:unixtime(),
    Reward = util:term_to_bitstring(RewardList),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_kf_score_reward, [ServerId, ServerNum, RoleId, RoleNameF, Score, Paied, Reward, NowTime]),
    ok.

log_kf_san_construction_reward(Santype, Scene, Contype, BlServer, ServerId, ServerNum, RoleId, RoleName, RewardList) ->
    NowTime = utime:unixtime(),
    Reward = util:term_to_bitstring(RewardList),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_kf_san_construction_reward,
        [Santype, Scene, Contype, BlServer, ServerId, ServerNum, RoleId, RoleNameF, Reward, NowTime]),
    ok.

log_kf_san_medal(ServerId, ServerNum, RoleId, RoleName, Scene, MonId, RewardList) ->
    NowTime = utime:unixtime(),
    Reward = util:term_to_bitstring(RewardList),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_kf_san_medal, [ServerId, ServerNum, RoleId, RoleNameF, Scene, MonId, Reward, NowTime]),
    ok.

log_kf_san_kill_log(Role_id, RoleName, Scene, Construct, Mon_id, MonType, Old_anger, New_anger) ->
    NowTime = utime:unixtime(),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_kf_san_kill_log, [Role_id, RoleNameF, Scene, Construct, Mon_id, MonType, Old_anger, New_anger, NowTime]),
    ok.

log_cluster_sanctuary_occupy(ZoneId, BelongSerId, SceneId) ->
    mod_log:add_log(log_cluster_sanctuary_occupy, [ZoneId, BelongSerId, SceneId, utime:unixtime()]).

log_buy_surprise_gift(RoleId, GiftId, GiftCost, RewardList) ->
    NowTime = utime:unixtime(),
    Cost = util:term_to_bitstring(GiftCost),
    Reward = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_buy_surprise_gift, [RoleId, GiftId, Cost, Reward, NowTime]),
    ok.

log_draw_surprise_gift(RoleId, RewardList, DrawTimes) ->
    NowTime = utime:unixtime(),
    Reward = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_draw_surprise_gift, [RoleId, Reward, DrawTimes, NowTime]),
    ok.


log_back_surprise_gift(RoleId, GiftId, BackDay, RewardList) ->
    NowTime = utime:unixtime(),
    Reward = util:term_to_bitstring(RewardList),
    mod_log:add_log(log_back_surprise_gift, [RoleId, GiftId, BackDay, Reward, NowTime]),
    ok.


log_single_dungeon_sweep(RoleId, Lv, CombatPower, DunId, DunType, RewardList, AutoNum, Cost) ->
    mod_log:add_log(log_single_dungeon_sweep, [RoleId, Lv, CombatPower,
        DunId, DunType, AutoNum, util:term_to_string(Cost), util:term_to_string(RewardList),  utime:unixtime()]).

log_monday_draw(RoleId, RoleName, CostList, RewardList, DrawTimes) ->
    Now = utime:unixtime(),
    Cost = util:term_to_bitstring(CostList),
    Reward = util:term_to_bitstring(RewardList),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_monday_draw, [RoleId, RoleNameF, Cost, Reward, DrawTimes, Now]).

log_eudemons_compose(RoleId, RoleName, CostList, RewardList) ->
    Now = utime:unixtime(),
    Cost = util:term_to_bitstring(CostList),
    Reward = util:term_to_bitstring(RewardList),
    RoleNameF = util:fix_sql_str(RoleName),
    mod_log:add_log(log_eudemons_compose, [RoleId, RoleNameF, Cost, Reward, Now]).

%% 公会守卫
log_guild_guard_dungeon(GuildId, ResultType, ChallengeGuard, CycleNum) ->
    mod_log:add_log(log_guild_guard_dungeon, [GuildId, ResultType, ChallengeGuard, CycleNum, utime:unixtime()]).

log_compensate_exp(RoleId, OnhookTime, OnhookExp, Lv, AddExp, NewLv, Reward) ->
    mod_log:add_log(log_compensate_exp, [RoleId, OnhookTime, OnhookExp, Lv, AddExp, NewLv, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 龙纹培养日志
log_dragon_lv(RoleId, GoodsId, GoodsTypeId, LvType, Cost, OldLv, NewLv, OldShowLv, NewShowLv, OldQuality, NewQuality) ->
    mod_log:add_log(log_dragon_lv, [RoleId, GoodsId, GoodsTypeId, LvType, util:term_to_bitstring(Cost), OldLv, NewLv, OldShowLv, NewShowLv, OldQuality, NewQuality, utime:unixtime()]),
    ok.

%% 龙纹镶嵌日志
log_dragon_equip(RoleId, GoodsId, GoodsTypeId, OldPos, NewPos, Type) ->
    mod_log:add_log(log_dragon_equip, [RoleId, GoodsId, GoodsTypeId, OldPos, NewPos, Type, utime:unixtime()]),
    ok.

%% 龙纹分解日志
log_dragon_decompose(RoleId, GoodsId, GoodsTypeId, Lv, ShowLv, Quality, DecomposeList) ->
    mod_log:add_log(log_dragon_decompose, [RoleId, GoodsId, GoodsTypeId, Lv, ShowLv, Quality, util:term_to_bitstring(DecomposeList), utime:unixtime()]),
    ok.

%% 龙纹熔炉召唤日志
log_dragon_crucible_beckon(RoleId, StartTime, EndTime, CrucibleId, Cost, Reward, OldCount, NewCount) ->
    mod_log:add_log(log_dragon_crucible_beckon, [RoleId, StartTime, EndTime, CrucibleId, util:term_to_bitstring(Cost), util:term_to_bitstring(Reward), OldCount, NewCount, utime:unixtime()]),
    ok.

%% 龙纹熔炉奖励日志
log_dragon_crucible_reward(RoleId, StartTime, EndTime, Count, CrucibleId, CountCfg, Reward) ->
    mod_log:add_log(log_dragon_crucible_reward, [RoleId, StartTime, EndTime, Count, CrucibleId, CountCfg, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 龙纹槽位培养日志
%% 1:生成 2:升级 3:降级
log_dragon_pos_lv(RoleId, Pos, OldLv, NewLv, Type) ->
    mod_log:add_log(log_dragon_pos_lv, [RoleId, Pos, OldLv, NewLv, Type, utime:unixtime()]),
    ok.

%% 赛博夺宝
log_bonus_draw(Type, Subtype, RoleId, RoleNames, Wave, DrawTimes, CostL, RewardType, RewardL) ->
    CostList = util:term_to_bitstring(CostL),
    RoleName = util:fix_sql_str(RoleNames),
    Reward = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_bonus_draw, [Type, Subtype, RoleId, RoleName, Wave, DrawTimes, CostList, RewardType, Reward, utime:unixtime()]),
    ok.
log_dungeon_dragon_awards(RoleId, DunId, Wave, Rewards) ->
    mod_log:add_log(log_dungeon_dragon_awards, [RoleId, DunId, Wave, util:term_to_bitstring(Rewards), utime:unixtime()]),
    ok.

%% 坐骑类幻形升级日志
log_mount_figure_upgrade_star(RoleId, TypeId, Id, PreStar, CurStar, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_mount_figure_upgrade_star, [RoleId, TypeId, Id, PreStar, CurStar, CostStr, utime:unixtime()]),
    ok.

%% 3v3每日段位
log_3v3_today_reward(RoleId, YesterdayTier, _Reward) ->
    Reward = util:term_to_bitstring(_Reward),
    mod_log:add_log(log_3v3_today_reward, [RoleId, YesterdayTier, Reward, utime:unixtime()]),
    ok.

%% 神装升阶
log_god_equip_level(RoleId, RoleNameF, Pos, Oldlevel, NewLevel, _Cost) ->
    Cost = util:term_to_bitstring(_Cost),
    RoleName = util:fix_sql_str(RoleNameF),
    mod_log:add_log(log_god_equip_level, [RoleId, RoleName, Pos, Oldlevel, NewLevel, Cost, utime:unixtime()]),
    ok.

log_god_active(RoleId, GodId) ->
    mod_log:add_log(log_god_active, [RoleId, GodId, utime:unixtime()]),
    ok.

log_god_lv_up(RoleId, GodId, Olv, Nlv, OExp, NExp, Cost) ->
    mod_log:add_log(log_god_lv_up, [RoleId, GodId, Olv, Nlv, OExp, NExp, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_god_grade_up(RoleId, GodId, Grade, NGrade, Cost) ->
    mod_log:add_log(log_god_grade_up, [RoleId, GodId, Grade, NGrade, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_god_up_star(RoleId, GodId, OStar, NStar , GoodsList) ->
    mod_log:add_log(log_god_up_star, [RoleId, GodId, OStar, NStar, util:term_to_bitstring(GoodsList), utime:unixtime()]),
    ok.

log_god_stren(RoleId, GodType, OldLevel, OldExp, NewLevel, NewExp, CostList) ->
    mod_log:add_log(log_god_stren, [RoleId, GodType, OldLevel, OldExp, NewLevel, NewExp, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

log_adventure_throw(RoleId, Stage, Cost, Circle, Location, NewCircle, NewLocation, Point, Reward) ->
    mod_log:add_log(log_adventure_throw, [RoleId, Stage, util:term_to_bitstring(Cost), Circle, Location, NewCircle, NewLocation, Point, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_adventure_shop(RoleId, Action, Cost, Reward) ->
    mod_log:add_log(log_adventure_shop, [RoleId, Action, util:term_to_bitstring(Cost), util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_level_act(#player_status{id = RoleId} = Player, RoleNameF, Type, Subtype, Grade, _Cost, _Reward) ->
    NowTime = utime:unixtime(),
    RoleName = util:fix_sql_str(RoleNameF),
    Cost = util:term_to_bitstring(_Cost),
    Reward = util:term_to_bitstring(_Reward),
    ta_agent_fire:log_level_act(Player, [Type, Subtype, Grade, _Cost]),
    mod_log:add_log(log_level_act, [RoleId, RoleName, Type, Subtype, Grade, Cost, Reward, NowTime]),
    ok.

%%降神穿戴日志
log_god_equip_goods(RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId) ->
    mod_log:add_log(log_god_equip_goods, [RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId, utime:unixtime()]),
    ok.

%%守护日志
log_magic_circle(RoleId, MagicCircle, Cost, Type, EndTime) ->
    mod_log:add_log(log_magic_circle, [RoleId, MagicCircle, util:term_to_bitstring(Cost), Type, utime:unixtime(), EndTime]),
    ok.

%% 属性日志
log_attr(RoleId, OldCombatPower, CombatPower, Attr) ->
    mod_log:add_log(log_attr, [RoleId, OldCombatPower, CombatPower, Attr, utime:unixtime()]),
    ok.

%% 永恒圣殿boss归属
log_sanctum_boss(SceneId, MonId, ServerId) ->
    mod_log:add_log(log_sanctum_boss, [SceneId, MonId, ServerId, utime:unixtime()]),
    ok.

%% 永恒圣殿伤害排名
log_sanctum_rank(SceneId, MonId, Rank, ServerId, RoleId, RoleName, RewardL) ->
    Reward = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_sanctum_rank, [SceneId, MonId, Rank, ServerId, RoleId, util:fix_sql_str(RoleName), Reward, utime:unixtime()]),
    ok.

%% 聚魂唤醒
log_soul_awake(RoleId, GoodsId, GoodsTypeId, Cost, CostInfoL, OldAwakeLvList, NewAwakeLvList, Oldlevel, NewLevel, OldSoulPoint, NewSoulPoint) ->
    mod_log:add_log(log_soul_awake,
        [RoleId, GoodsId, GoodsTypeId, util:term_to_bitstring(Cost), util:term_to_bitstring(CostInfoL), util:term_to_bitstring(OldAwakeLvList),
            util:term_to_bitstring(NewAwakeLvList), Oldlevel, NewLevel, OldSoulPoint, NewSoulPoint, utime:unixtime()]),
    ok.

%% 聚魂唤醒拆解
log_soul_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsList) ->
    mod_log:add_log(log_soul_dismantle_awake, [RoleId, GoodsId, GoodsTypeId, util:term_to_bitstring(AwakeLvList), util:term_to_bitstring(ReturnGoodsList), utime:unixtime()]),
    ok.

%% 神佑祈愿
log_act_pray(RoleId, RoleName, Type, Subtype, DrawType, Cost, Reward) ->
    mod_log:add_log(log_act_pray, [RoleId, util:fix_sql_str(RoleName), Type, Subtype, DrawType, util:term_to_bitstring(Cost), util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%%天启替换装备日志
log_revelation_equip_goods(RoleId, PosId, OldId, OldTypeId, NewId, NewTypeId) ->
    mod_log:add_log(log_revelation_equip_goods, [RoleId, PosId, OldId, OldTypeId, NewId, NewTypeId, utime:unixtime()]),
    ok.

%%天启吞噬日志
log_revelation_equip_swallow(RoleId, PosId, Cost, AddExp, LastExp) ->
    mod_log:add_log(log_revelation_equip_swallow, [RoleId, PosId, util:term_to_bitstring(Cost), AddExp, LastExp, utime:unixtime()]),
    ok.

%%天启聚灵日志
log_revelation_equip_gathering(RoleId, Lv, NewLv, CostExp, LastExp) ->
    mod_log:add_log(log_revelation_equip_gathering, [RoleId, Lv, NewLv, CostExp, LastExp, utime:unixtime()]),
    ok.

%%天启激活套装日志
log_revelation_equip_suit(RoleId, Suit) ->
    mod_log:add_log(log_revelation_equip_suit, [RoleId, Suit, utime:unixtime()]),
    ok.

%% 使魔天赋技能
log_demons_slot_skill(RoleId, RoleName, DemonsId, Slot, BfSkillId, BfSkillLv, SkillId, SkillLv, Cost) ->
    mod_log:add_log(log_demons_slot_skill,
        [RoleId, util:fix_sql_str(RoleName), DemonsId, Slot, BfSkillId, BfSkillLv, SkillId, SkillLv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 使魔商店
log_demons_shop_refresh(RoleId, RoleName, RefreshTimes, Cost) ->
    mod_log:add_log(log_demons_shop_refresh,
        [RoleId, util:fix_sql_str(RoleName), RefreshTimes, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 自选奖池重置
log_select_pool_rest(RoleId, RoleName, Type, Subtype, RewardList, ResetTimes, Cost) ->
    mod_log:add_log(log_select_pool_rest,
        [RoleId, util:fix_sql_str(RoleName), Type, Subtype, util:term_to_bitstring(RewardList), ResetTimes, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 免战保护
log_protect(RoleId, Type, Value, SceneType, ProtectTime, UseCount) ->
    mod_log:add_log(log_protect, [RoleId, Type, Value, SceneType, ProtectTime, UseCount, utime:unixtime()]),
    ok.

%% 至尊vip激活
log_supvip_active(RoleId, Type, Cost, SupvipType, SupvipTime) ->
    mod_log:add_log(log_supvip_active, [RoleId, Type, util:term_to_bitstring(Cost), SupvipType, SupvipTime, utime:unixtime()]),
    ok.

%% 至尊vip技能任务
log_supvip_skill_task(RoleId, Stage, SubStage, TaskId, Reward) ->
    mod_log:add_log(log_supvip_skill_task, [RoleId, Stage, SubStage, TaskId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 至尊币任务
log_supvip_currency_task(RoleId, TaskId, Reward) ->
    mod_log:add_log(log_supvip_currency_task, [RoleId, TaskId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 游戏错误##一些比较特殊的错误,方便php抽取数据验证
%% @param Type
%%  1:挂机
%%  2:战斗状态
%%  3:场景切换
%%  4:邮件异常
%%  5:战斗调试
log_game_error(RoleId, Type, About) ->
    mod_log:add_log(log_game_error, [RoleId, Type, About, utime:unixtime()]),
    ok.

%% 符文唤醒
log_rune_awake(RoleId, GoodsId, GoodsTypeId, Cost, CostInfoL, OldAwakeLvList, NewAwakeLvList, OldLevel, NewLevel, OldRunePoint, NewRunePoint) ->
    mod_log:add_log(log_rune_awake,
        [RoleId, GoodsId, GoodsTypeId, util:term_to_bitstring(Cost), util:term_to_bitstring(CostInfoL), util:term_to_bitstring(OldAwakeLvList),
            util:term_to_bitstring(NewAwakeLvList), OldLevel, NewLevel, OldRunePoint, NewRunePoint, utime:unixtime()]),
    ok.


%% 符文唤醒拆解
log_rune_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsList) ->
    mod_log:add_log(log_rune_dismantle_awake, [RoleId, GoodsId, GoodsTypeId, util:term_to_bitstring(AwakeLvList), util:term_to_bitstring(ReturnGoodsList), utime:unixtime()]),
    ok.

%% 聚魂唤醒拆解
log_rune_skill_up(RoleId, OldLv, NewLv) ->
    mod_log:add_log(log_rune_skill_up, [RoleId, OldLv, NewLv, utime:unixtime()]),
    ok.

%% 跨服圣域拍卖产出
log_cluster_auction_produce(Type, ProduceId, Reward, RoleIdList) ->
    mod_log:add_log(log_cluster_auction_produce, [Type, ProduceId, util:term_to_bitstring(Reward), util:term_to_bitstring(RoleIdList), utime:unixtime()]),
    ok.

%% 贡献排行
log_cluster_point_rank(RoleId, RoleName, ServerNum, Point) ->
    mod_log:add_log(log_cluster_point_rank, [RoleId, util:fix_sql_str(RoleName), ServerNum, Point, utime:unixtime()]),
    ok.

%% 助力礼包
log_level_gift_send(Type, SubType, Grade, RoleID, RoleName, RoleLv, VipExp, Reward) ->
    mod_log:add_log(log_level_gift_send, [Type, SubType, Grade, RoleID, util:fix_sql_str(RoleName), RoleLv, VipExp, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.


log_3v3_team_member(TeamId, TeamName, EventType, NewRoleId, NewEventParam, Time) ->
    mod_log:add_log(log_3v3_team_member, [TeamId, TeamName, EventType, NewRoleId, NewEventParam, Time]).


log_3v3_guess(RoleId, Turn, PkRes, Opt, Reward, Cost) ->
    mod_log:add_log(log_3v3_guess,
        [RoleId, Turn, util:term_to_bitstring(PkRes), Opt, util:term_to_bitstring(Reward), util:term_to_bitstring(Cost), utime:unixtime()]).

%% 幻饰boss进入
log_decoration_boss_enter(RoleId, EnterType, IsHadAssist, BossId) ->
    mod_log:add_log(log_decoration_boss_enter, [RoleId, EnterType, IsHadAssist, BossId, utime:unixtime()]),
    ok.

%% 幻饰boss奖励
log_decoration_boss_reward(RoleId, EnterType, BossId, IsBelong, Reward) ->
    mod_log:add_log(log_decoration_boss_reward, [RoleId, EnterType, BossId, IsBelong, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 幻饰特殊boss伤害
log_decoration_sboss_hurt(RoleId, Name, ServerId, ZoneId, Hurt, RankNo, IsBelong) ->
    mod_log:add_log(log_decoration_sboss_hurt, [RoleId, Name, ServerId, ZoneId, Hurt, RankNo, IsBelong, utime:unixtime()]),
    ok.

%% 幻饰特殊boss奖励
log_decoration_sboss_reward(RoleId, IsBelong, RewardType, Reward) ->
    mod_log:add_log(log_decoration_sboss_reward, [RoleId, IsBelong, RewardType, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 封测登陆献礼--记录
log_beta_login_record(Accid, Accname, RoleId, RoleLv, Source) ->
    mod_log:add_log(log_beta_login_record, [Accid, Accname, RoleId, RoleLv, Source, utime:unixtime()]),
    ok.

%% 封测登陆献礼--奖励
log_beta_login_reward(Accid, Accname, RoleId, Source) ->
    mod_log:add_log(log_beta_login_reward, [Accid, Accname, RoleId, Source, utime:unixtime()]),
    ok.

%% 许愿池
log_bonus_pool(RoleId, RoleName, Type, Subtype, DrawTimes, Cost, Reward) ->
    mod_log:add_log(log_bonus_pool, [RoleId, util:fix_sql_str(RoleName), Type, Subtype, DrawTimes, util:term_to_bitstring(Cost),
                util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_treasure_map(RoleId, Type, Scene, XY, RewardList) ->
    mod_log:add_log(log_treasure_map, [RoleId, Type, Scene,
        util:term_to_bitstring(XY), util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

%% 背饰
log_back_decoration(RoleId, RoleName, BackDecorationId, OptionType, OldStage, NowStage, Cost) ->
    CostB = util:term_to_bitstring(Cost),
    mod_log:add_log(log_back_decoration, [RoleId, util:fix_sql_str(RoleName), BackDecorationId, OptionType, OldStage, NowStage, CostB, utime:unixtime()]),
    ok.

%% 切换场景日志
log_change_scene(RoleId, SceneId, DunId, DunType, Remark) ->
    mod_log:add_log(log_change_scene, [RoleId, SceneId, DunId, DunType, Remark, utime:unixtime()]),
    ok.

%% 头衔
log_title_info(RoleId, RoleName, TitleId, OldStar, Star, Cost) ->
    CostB = util:term_to_bitstring(Cost),
    mod_log:add_log(log_title_info, [RoleId, util:fix_sql_str(RoleName), TitleId, OldStar, Star, CostB, utime:unixtime()]),
    ok.

%% 个人副本排行
log_rank_dungeon_challengers(List)->
    case List =/= [] of
        true-> mod_log:add_log(log_rank_dungeon_challengers, List);
        false-> skip
    end,
    ok.

log_rdungeon_challengers_reward(RoleId, Level, Reward) ->
    mod_log:add_log(log_rdungeon_challengers_reward, [RoleId, Level, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_rdungeon_success(RoleId, Level, GoTime) ->
    mod_log:add_log(log_rdungeon_success, [RoleId, Level, GoTime, utime:unixtime()]),
    ok.

%% 喇叭
log_bugle(RoleId, Type, Msg, Cost) ->
    mod_log:add_log(log_bugle, [RoleId, Type, util:make_sure_binary(Msg), util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% pk日志
log_pk(Server, Roleid, RoleName, EnemyServer, Enemyid, Enemyname, Type, Scene, SceneType) ->
    mod_log:add_log(log_pk, [Server, Roleid, util:fix_sql_str(RoleName), EnemyServer, Enemyid, util:fix_sql_str(Enemyname), Type, Scene, SceneType, utime:unixtime()]),
    ok.

%% 微信分享日志
log_role_wx_share(RoleId, Count, Reward) ->
    mod_log:add_log(log_role_wx_share, [RoleId, Count, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 周常副本榜单
log_week_dungeon_rank(List) ->
    case List =/= [] of
        true-> mod_log:add_log(log_week_dungeon_rank, List);
        false-> skip
    end,
    ok.

%% 公会宝箱发放日志
log_guild_daily_send(Guild, GuildName, RoleId, RoleName, TaskId, AutoId, Num) ->
    mod_log:add_log(log_guild_daily_send, [Guild, util:fix_sql_str(GuildName), RoleId, util:fix_sql_str(RoleName),
            TaskId, AutoId, Num, utime:unixtime()]),
    ok.

%% 公会宝箱领取日志
log_guild_daily_recieve(Guild, GuildName, RoleId, RoleName, TaskId, AutoId, Reward) ->
    mod_log:add_log(log_guild_daily_recieve, [Guild, util:fix_sql_str(GuildName), RoleId, util:fix_sql_str(RoleName),
            TaskId, AutoId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 周常副本结算
log_week_dungeon_settlement(RoleId, DunId, SettlementType, PassTime, HelpType, SuccRewardStateList, RoleBossStateList) ->
    mod_log:add_log(log_week_dungeon_settlement, [RoleId, DunId, SettlementType, PassTime, HelpType, util:term_to_bitstring(SuccRewardStateList), util:term_to_bitstring(RoleBossStateList), utime:unixtime()]),
    ok.

%% boss转盘触发和放弃
log_boss_rotary_event(List) ->
    case List =/= [] of
        true-> mod_log:add_log(log_boss_rotary_event, List);
        false-> skip
    end,
    ok.

%% boss转盘
log_boss_rotary_reward(RoleId, RotaryId, BossType, BossRewardLevel, Wlv, PoolId, RewardId, CostList, Rewards) ->
    mod_log:add_log(log_boss_rotary_reward, [RoleId, RotaryId, BossType, BossRewardLevel, Wlv, PoolId, RewardId, util:term_to_bitstring(CostList), util:term_to_bitstring(Rewards), utime:unixtime()]),
    ok.

%% boss消耗复活
log_boss_cost_reborn(RoleId, SceneId, X, Y, BossType, BossId, Cost) ->
    mod_log:add_log(log_boss_cost_reborn, [RoleId, SceneId, X, Y, BossType, BossId, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_role_wx_share_touch(RoleId) ->
    mod_log:add_log(log_role_wx_share_touch, [RoleId, utime:unixtime()]),
    ok.

log_race_act_zone(ZoneId, Type, Subtype, WorldLv) ->
    mod_log:add_log(log_race_act_zone, [ZoneId, Type, Subtype, WorldLv, utime:unixtime()]),
    ok.

log_race_act_rank_reward(RoleId, Name, ZoneId, ServerId, Type, Subtype, Score, Rank, Reward, WorldLv) ->
    mod_log:add_log(log_race_act_rank_reward, [RoleId, util:fix_sql_str(Name), ZoneId, ServerId, Type, Subtype, Score, Rank, util:term_to_bitstring(Reward), WorldLv, utime:unixtime()]),
    ok.

log_rush_treasure_rank_reward(RoleId, Name, ZoneId, ServerId, Type, Subtype, RankType, Score, Rank, Reward, WorldLv) ->
    mod_log:add_log(log_rush_treasure_rank_reward, [RoleId, Name, ZoneId, ServerId, Type, Subtype, RankType, Score, Rank, util:term_to_bitstring(Reward), WorldLv, utime:unixtime()]),
    ok.

%% 圣灵战场阵营pk日志
log_holy_battle_pk_group(ZoneId, CopyId, Mod, Result) ->
    mod_log:add_log(log_holy_battle_pk_group, [ZoneId, CopyId, Mod,
        util:term_to_bitstring(Result), utime:unixtime()]),
    ok.



%% 圣灵战场阵营个人pk日志
log_holy_battle_pk_role(RoleId, ServerNum, ServerId, ZoneId, CopyId, Point) ->
    mod_log:add_log(log_holy_battle_pk_role, [RoleId, ServerNum, ServerId, ZoneId, CopyId, Point, utime:unixtime()]),
    ok.


%% 圣灵战场阵营个人pk日志
log_holy_battle_pk_point_reward(RoleId, Mod, Stage, Result) ->
    mod_log:add_log(log_holy_battle_pk_point_reward, [RoleId, Mod, Stage, util:term_to_bitstring(Result), utime:unixtime()]),
    ok.

log_constellation_forge(RoleId, Name, EquipType, Pos, OptionType, OldLv, NowLv, Cost) ->
    mod_log:add_log(log_constellation_forge, [RoleId, util:fix_sql_str(Name), EquipType, Pos, OptionType, OldLv,
        NowLv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_constellation_evolution(RoleId, Name, IsSuccess, EquipId, GoodsId, EquipType, OldLv, NowLv, Cost, AddAttr) ->
    mod_log:add_log(log_constellation_evolution, [RoleId, util:fix_sql_str(Name), IsSuccess, EquipId, GoodsId,
        EquipType, OldLv, NowLv, util:term_to_bitstring(Cost), util:term_to_bitstring(AddAttr), utime:unixtime()]),
    ok.

log_fortune_cat(RoleId, Name, Type, SubType, Turn, Reward) ->
    mod_log:add_log(log_fortune_cat, [RoleId, util:fix_sql_str(Name), Type, SubType, Turn, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_kf_cloud_buy_act_start(Type, SubType, StartType, StartTime, EndTime) ->
    mod_log:add_log(log_kf_cloud_buy_act_start, [Type, SubType, StartType, StartTime, EndTime, utime:unixtime()]),
    ok.

log_kf_cloud_buy_act_reset(Type, SubType, ZoneList) ->
    mod_log:add_log(log_kf_cloud_buy_act_reset, [Type, SubType, util:term_to_bitstring(ZoneList), utime:unixtime()]),
    ok.

log_kf_cloud_buy_reward(RoleId, ServerId, Name, Type, SubType, GradeId, Times, NewSelfCount, NewGradeCount, RewardList) ->
    mod_log:add_log(log_kf_cloud_buy_reward,
        [RoleId, ServerId, util:fix_sql_str(Name), Type, SubType, GradeId, Times, NewSelfCount, NewGradeCount, util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_kf_cloud_buy_stage_reward(RoleId, Name, Type, SubType, StageCount, Wlv, Rewards) ->
    mod_log:add_log(log_kf_cloud_buy_stage_reward, [RoleId, util:fix_sql_str(Name), Type, SubType, StageCount, Wlv, util:term_to_bitstring(Rewards), utime:unixtime()]),
    ok.

%% 星宿--属性转移
log_constellation_attr_change(RoleId, Name, OldGTypeId, OldAttr, GTypeId, Attr, NewAttr) ->
    mod_log:add_log(log_constellation_attr_change, [RoleId, util:fix_sql_str(Name), OldGTypeId,
            util:term_to_bitstring(OldAttr), GTypeId, util:term_to_bitstring(Attr), util:term_to_bitstring(NewAttr), utime:unixtime()]),
    ok.

%% 星宿--吞噬
log_constellation_decompose(RoleId, Name, MaterialList, OldLevel, OldExp, NewLevel, Exp) ->
    mod_log:add_log(log_constellation_decompose, [RoleId, util:fix_sql_str(Name),
            util:term_to_bitstring(MaterialList), OldLevel, OldExp, NewLevel, Exp, utime:unixtime()]),
    ok.

%% 星宿--星级大师
log_constellation_star(RoleId, Name, OpType, Star, OldLevel, Level, MaxLevel) ->
    mod_log:add_log(log_constellation_star, [RoleId, util:fix_sql_str(Name), OpType, Star, OldLevel, Level, MaxLevel, utime:unixtime()]),
    ok.

%% 星宿--合成
log_constellation_compose(RoleId, Name, ComposeId, Regular, Irregular, PointList, Cost, Ratio, Reward) ->
    mod_log:add_log(log_constellation_compose, [RoleId, util:fix_sql_str(Name), ComposeId, util:term_to_bitstring(Regular),
        util:term_to_bitstring(Irregular), util:term_to_bitstring(PointList), util:term_to_bitstring(Cost), Ratio, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_kf_group_buy_compensate(List) ->
    case List =/= [] of
        true-> mod_log:add_log(log_kf_group_buy_compensate, List);
        false-> skip
    end,
    ok.

log_arcana_lv(RoleId, ArcanaId, Lv, Cost) ->
    mod_log:add_log(log_arcana_lv, [RoleId, ArcanaId, Lv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_arcana_break(RoleId, ArcanaId, BreakLv, Cost) ->
    mod_log:add_log(log_arcana_break, [RoleId, ArcanaId, BreakLv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_arcana_core(RoleId, CoreType) ->
    mod_log:add_log(log_arcana_core, [RoleId, CoreType, utime:unixtime()]),
    ok.

log_constellation_master(RoleId, Name, EquipType, MasterType, LightLv, EquipStatus, MasterAttr) ->
    mod_log:add_log(log_constellation_master, [RoleId, util:fix_sql_str(Name), EquipType, MasterType, LightLv,
        util:term_to_bitstring(EquipStatus), util:term_to_bitstring(MasterAttr), utime:unixtime()]),
    ok.

log_medal_stren(RoleId, MedalLv, PreStrenLv, PreStrenExp, AfStrenLv, AfStrenExp, Cost) ->
    mod_log:add_log(log_medal_stren, [RoleId, MedalLv, PreStrenLv, PreStrenExp, AfStrenLv,
        AfStrenExp, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

%% 身份验证
log_real_info(RoleId, RoleName, Type, Phone, Name, PersonId, Reward) ->
    mod_log:add_log(log_real_info, [RoleId, util:fix_sql_str(RoleName), Type, Phone, util:fix_sql_str(Name), PersonId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_contract_challenge_task(SubType, RoleId, RoleName, TaskId, GrandNum) ->
    mod_log:add_log(log_contract_challenge_task, [SubType, RoleId, util:fix_sql_str(RoleName), TaskId, GrandNum, utime:unixtime()]),
    ok.

log_contract_challenge_point(SubType, RoleId, RoleName, TaskId, OldPoint, NewPoint) ->
    mod_log:add_log(log_contract_challenge_point, [SubType, RoleId, util:fix_sql_str(RoleName), TaskId, OldPoint, NewPoint, utime:unixtime()]),
    ok.

log_god_court_strength(RolId, Name, CourtId, OldLv, NowLv, Cost) ->
    mod_log:add_log(log_god_court_strength, [RolId, util:fix_sql_str(Name), CourtId, OldLv, NowLv, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_god_court_equip_stage(RolId, Name, CourtId, Pos, OldStage, NowStage, Cost) ->
    mod_log:add_log(log_god_court_equip_stage, [RolId, util:fix_sql_str(Name), CourtId, Pos, OldStage, NowStage, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_god_house_crystal(RolId, Name, OldColor, NowColor, OldLv, OldExp, NowLv, NowExp, Cost, Reward) ->
    mod_log:add_log(log_god_house_crystal, [RolId, util:fix_sql_str(Name), OldColor, NowColor, OldLv, OldExp, NowLv, NowExp, util:term_to_bitstring(Cost), util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_god_house_origin(RolId, Name, OldColor, Cost, DailyCount, SumCount) ->
    mod_log:add_log(log_god_house_origin, [RolId, util:fix_sql_str(Name), OldColor, util:term_to_bitstring(Cost), DailyCount, SumCount, utime:unixtime()]),
    ok.

log_god_house_reward(RolId, Name, TriggerCount, DailyCount, RewardLv, Reward) ->
    mod_log:add_log(log_god_house_reward, [RolId, util:fix_sql_str(Name), TriggerCount, DailyCount, RewardLv, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_sweep_bounty_task(RoleId, Reward, ExtraReward, LeftTaskCount) ->
    mod_log:add_log(log_sweep_bounty_task, [RoleId, LeftTaskCount, util:term_to_bitstring(Reward), util:term_to_bitstring(ExtraReward), utime:unixtime()]),
    ok.

log_sweep_guild_task(RoleId, Reward, ExtraReward, LeftTaskCount) ->
    mod_log:add_log(log_sweep_guild_task, [RoleId, LeftTaskCount, util:term_to_bitstring(Reward), util:term_to_bitstring(ExtraReward), utime:unixtime()]),
    ok.


%% 时空圣痕阶段奖励
log_chrono_rift_stage_reward(RoleId, Stage, DayValue, Reward) ->
    mod_log:add_log(log_chrono_rift_stage_reward, [RoleId, Stage, DayValue, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 时空圣痕目标奖励
log_chrono_rift_goal_reward(RoleId, GoalId, Reward) ->
    mod_log:add_log(log_chrono_rift_goal_reward, [RoleId, GoalId, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.


%% 时空圣痕个人排行榜日志
log_chrono_rift_rank_reward(RoleId, ServerId, ServerNum, ZoneId, Rank, Reward) ->
    mod_log:add_log(log_chrono_rift_rank_reward, [RoleId, ServerId, ServerNum, ZoneId, Rank, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%% 时空圣痕占领奖励
log_chrono_rift_castle_reward(RoleId, CastleMsg, Reward) ->
    mod_log:add_log(log_chrono_rift_castle_reward, [RoleId, util:term_to_bitstring(CastleMsg), util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.


%% 时空圣痕活动信息  ActValue::活动值   AddValue增加的争夺值(转化钱)  CurrDayValue当前累计争夺值   CurrValue 总争夺值   Ratio 转化率
log_chrono_rift_act(RoleId, Mod, SubMod, ActValue, AddValue, CurrDayValue,  CurrValue, Ratio) ->
    mod_log:add_log(log_chrono_rift_act, [RoleId, Mod, SubMod, ActValue, AddValue, CurrDayValue,  CurrValue, Ratio, utime:unixtime()]),
    ok.



%% 时空圣痕注入信息
log_chrono_rift_castle_add_value(RoleId, ZoneId, ServerId, ServerNum, CastleId, Count,
    CastleServerId, AfCastleServerId, PreServerList, AfServerList, Value, AfValue) ->
    mod_log:add_log(log_chrono_rift_castle_add_value, [RoleId, ZoneId, ServerId, ServerNum, CastleId, Count,
        CastleServerId, AfCastleServerId, util:term_to_bitstring(PreServerList), util:term_to_bitstring(AfServerList), Value, AfValue, utime:unixtime()]),
    ok.

log_escort_boss_born(ServerId, RoleId, RoleName, GuildId, GuildName, Position, MonType, Scene, Cost) ->
    mod_log:add_log(log_escort_boss_born, [ServerId, RoleId, util:fix_sql_str(RoleName), GuildId, util:fix_sql_str(GuildName),
        Position, MonType, Scene, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.

log_escort_role(ServerId, RoleId, RoleName, GuildId, GuildName, MonType, Sum, Reward) ->
    mod_log:add_log(log_escort_role, [ServerId, RoleId, util:fix_sql_str(RoleName), GuildId, util:fix_sql_str(GuildName),
        MonType, Sum, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_escort_guild(ServerId, GuildId, GuildName, MonType, Res, Reward) ->
    mod_log:add_log(log_escort_guild, [ServerId, GuildId, util:fix_sql_str(GuildName), MonType, Res, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_escort_rob(ServerId, RoleId, RoleName, GuildId, GuildName, MonType, Scene, Hurt, Reward) ->
    mod_log:add_log(log_escort_rob, [ServerId, RoleId, util:fix_sql_str(RoleName), GuildId, util:fix_sql_str(GuildName),
        MonType, Scene, Hurt, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_escort_rank(ServerId, RoleId, RoleName, GuildId, GuildName, Score, Rank, Reward, GuildReward) ->
    mod_log:add_log(log_escort_rank, [ServerId, RoleId, util:fix_sql_str(RoleName), GuildId, util:fix_sql_str(GuildName),
        Score, Rank, util:term_to_bitstring(Reward), util:term_to_bitstring(GuildReward), utime:unixtime()]),
    ok.

log_sign_up_msg(RoleId, ModId, SubModId, ActId, Type) ->
    mod_log:add_log(log_sign_up_msg, [RoleId, ModId, SubModId, ActId, Type, utime:unixtime()]).

log_dragon_language_boss(ServerId, RoleId, Cost, Type) ->
    mod_log:add_log(log_dragon_language_boss, [ServerId, RoleId, util:term_to_bitstring(Cost), Type, utime:unixtime()]).

%%神像操作日志
log_guild_god(RoleId, GodIdd, Type, Color, Lv, ComboId, Achievement, NewColor, NewLv, NewComboId, NewAchievement) ->
    mod_log:add_log(log_guild_god, [RoleId, GodIdd, Type, Color, Lv, ComboId,
        util:term_to_bitstring(Achievement), NewColor, NewLv, NewComboId, util:term_to_bitstring(NewAchievement), utime:unixtime()]).

%%神像穿戴铭文日志
log_guild_god_equip_rune(RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId) ->
    mod_log:add_log(log_guild_god_equip_rune, [RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId, utime:unixtime()]),
    ok.

%%神像升级铭文日志
log_guild_god_rune_upgrade(RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId) ->
    mod_log:add_log(log_guild_god_rune_upgrade, [RoleId, GodId, Pos, OldGoodsAutoId, OldGoodsTypeId, NewGoodsAutoId, NewGoodsTypeId, utime:unixtime()]),
    ok.

%% 发起公会协助
log_launch_guild_assist(AssistId, RoleId, Type, SubType, TargetCfgId) ->
    mod_log:add_log(log_launch_guild_assist, [AssistId, RoleId, Type, SubType, TargetCfgId, utime:unixtime()]),
    ok.

log_guild_assist_operation(List) ->
    case List =/= [] of
        true-> mod_log:add_log(log_guild_assist_operation, List);
        false-> skip
    end,
    ok.

log_degrade_guild_title(RoleId, LastWeekGot, AllPrestige, PrePrestige, NowTime) ->
    mod_log:add_log(log_degrade_guild_title, [RoleId, LastWeekGot, AllPrestige, PrePrestige, NowTime]),
    ok.

%%海域争霸 职位
log_seacraft_job(Camp, ServerId, RoleId, RoleName, OldJob, Job) ->
    mod_log:add_log(log_seacraft_job, [Camp, ServerId, RoleId, util:fix_sql_str(RoleName), OldJob, Job, utime:unixtime()]),
    ok.

%%海域争霸 福利
log_seacraft_daily(Camp, GuildId, GuildName, RoleId, RoleName, Job, Reward) ->
    mod_log:add_log(log_seacraft_daily, [Camp, GuildId, util:fix_sql_str(GuildName), RoleId, util:fix_sql_str(RoleName), Job,
        util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%%海域争霸 奖励
log_seacraft_reward(Camp, GuildId, GuildName, ActType, RoleId, RoleName, Rank, Score, Reward1, Reward2) ->
    mod_log:add_log(log_seacraft_reward, [Camp, GuildId, util:fix_sql_str(GuildName), ActType, RoleId, util:fix_sql_str(RoleName), Rank, Score,
        util:term_to_bitstring(Reward1), util:term_to_bitstring(Reward2), utime:unixtime()]),
    ok.

%%海域争霸 连胜奖励分配
log_seacraft_extra_reward(ActType, Camp, GuildId, GuildName, RoleId, RoleName, Reward) ->
    mod_log:add_log(log_seacraft_extra_reward, [ActType, Camp, GuildId, util:fix_sql_str(GuildName), RoleId, util:fix_sql_str(RoleName),
        util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%%海域争霸 结果
log_seacraft_result(ActType, Id, Name, Res) ->
    mod_log:add_log(log_seacraft_result, [ActType, Id, util:fix_sql_str(Name), Res, utime:unixtime()]),
    ok.

log_equip_refinement_promote(RoleId, EquipPos, NewRefineLv, CostList) ->
    mod_log:add_log(log_equip_refinement_promote, [RoleId, EquipPos, NewRefineLv, util:term_to_bitstring(CostList), utime:unixtime()]),
    ok.

%%海域日常 搬砖日志
log_sea_craft_daily_carry_brick(RoleId, RoleSeaId, CarrySeaId, MySeaNum, CarrySeaNum, BrickNum, BrickColor, Type, Reward) ->
    mod_log:add_log(log_sea_craft_daily_carry_brick,
        [RoleId, RoleSeaId, CarrySeaId, MySeaNum, CarrySeaNum, BrickNum, BrickColor, Type, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

%%海域日常 升级砖品质
log_sea_craft_daily_upgrade_brick(RoleId, RoleSeaId, NowBrickColor, AfBrickColor, Cost) ->
    mod_log:add_log(log_sea_craft_daily_upgrade_brick,
        [RoleId, RoleSeaId, NowBrickColor, AfBrickColor, util:term_to_bitstring(Cost), utime:unixtime()]),
    ok.


%%海域日常
log_sea_craft_daily_task(RoleId, TaskId, NowCount, AfCount) ->
    mod_log:add_log(log_sea_craft_daily_task,
        [RoleId, TaskId, NowCount, AfCount, utime:unixtime()]),
    ok.



%%海域日常 拦截日志
log_sea_craft_daily_defend(RoleId, CarryServerId, CarryServerNum, CarryRoleId, DefendCount, Reward) ->
    mod_log:add_log(log_sea_craft_daily_defend,
        [RoleId, CarryServerId, CarryServerNum, CarryRoleId, DefendCount, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_seacraft_exploit(RoleId, RoleName, AddExploit, Exploit, Extra) ->
    mod_log:add_log(log_seacraft_exploit, [RoleId, util:fix_sql_str(RoleName), AddExploit, Exploit,util:term_to_bitstring(Extra), utime:unixtime()]),
    ok.

%%海域日常
log_sea_craft_daily_rank_settle(Type, SeaId, RoleId, ServerId, ServerNum, BrickNum, Rank, Reward) ->
    mod_log:add_log(log_sea_craft_daily_rank_settle,
        [Type, SeaId, RoleId, ServerId, ServerNum, BrickNum, Rank, util:term_to_bitstring(Reward), utime:unixtime()]),
    ok.

log_seacraft_privilege_option(Zone, Camp, ServerId, RoleId, RoleName, PrivilegeId, Option, Times, EffectTime) ->
    mod_log:add_log(log_seacraft_privilege_option, [Zone, Camp, ServerId, RoleId, util:fix_sql_str(RoleName), PrivilegeId, Option, Times, EffectTime, utime:unixtime()]),
    ok.

log_en_zero_gift(RoleId, GiftStatus) ->
    mod_log:add_log(log_en_zero_gift, [RoleId, GiftStatus, utime:unixtime()]),
    ok.

log_god_auto_compose(RoleId, LogCostMat, LogComposeEquip) ->
    mod_log:add_log(log_god_auto_compose, [RoleId, util:term_to_bitstring(LogCostMat), util:term_to_bitstring(LogComposeEquip), utime:unixtime()]),
    ok.

log_afk_back(RoleId, Count, Cost, AddExp) ->
    mod_log:add_log(log_afk_back, [RoleId, Count, util:term_to_bitstring(Cost), AddExp, utime:unixtime()]),
    ok.

%% Type
%%  1 => 触发
%%  2 => 离线获得
log_afk(RoleId, Type, AfkLeftTimeBf, AfkLeftTimeAf, AfkUtimeBf, AfkUtimeAf, DayBgoldBf, DayBgoldAf, Multi, CostAfkTime, RewardList) ->
    mod_log:add_log(log_afk, [RoleId, Type, AfkLeftTimeBf, AfkLeftTimeAf, AfkUtimeBf, AfkUtimeAf, DayBgoldBf, DayBgoldAf, Multi, CostAfkTime, util:term_to_bitstring(RewardList), utime:unixtime()]),
    ok.

log_afk_off(RoleId, EveryDate, Multi, Ratio, PlRatio, Lv, Cp, NewLv, AddExp, AddCoin, AddBgold, EveryBgold, DropList) ->
    mod_log:add_log(log_afk_off, [RoleId, EveryDate, Multi, Ratio, PlRatio, Lv, Cp, NewLv, AddExp, AddCoin, AddBgold, EveryBgold, util:term_to_bitstring(DropList), utime:unixtime()]),
    ok.

%% 新boss首杀boss日志
log_boss_first_blood_plus_boss(Type, SubType, BossId, BossSceneName, RoleId, WholeFirstBlood) ->
    mod_log:add_log(log_boss_first_blood_plus_boss, [Type, SubType, BossId, BossSceneName, RoleId, WholeFirstBlood, utime:unixtime()]),
    ok.

%% 新boss首杀奖励日志
log_boss_first_blood_plus_reward(Type, SubType, RoleId, BossId, Reward) ->
    mod_log:add_log(log_boss_first_blood_plus_reward, [Type, SubType, RoleId, BossId, Reward, utime:unixtime()]),
    ok.

log_companion_stage(RoleId,CompanionId,BStage,BStar,BBlessing,AStage,AStar,ABlessing,Cost_) ->
    Cost = util:term_to_bitstring(Cost_),
    mod_log:add_log(log_companion_stage, [RoleId,CompanionId,BStage,BStar,BBlessing,AStage,AStar,ABlessing,Cost,utime:unixtime()]),
    ok.

log_companion_train(RoleId,CompanionId,TrainNum,Cost_,BAttr_,AAttr_) ->
    Cost = util:term_to_bitstring(Cost_),
    BAttr = util:term_to_bitstring(BAttr_),
    AAttr = util:term_to_bitstring(AAttr_),
    mod_log:add_log(log_companion_train, [RoleId,CompanionId,TrainNum,Cost,BAttr,AAttr,utime:unixtime()]),
    ok.

log_custom_treasure(RoleId, RoleNameStr, Type, SubType, Turn, DrawTimes, LuckeyValue, RewardStr, GradeIdListStr) ->
    RoleName = util:fix_sql_str(RoleNameStr),
    Reward = util:term_to_bitstring(RewardStr),
    GradeIdList = util:term_to_bitstring(GradeIdListStr),
    mod_log:add_log(log_custom_treasure,
        [RoleId, RoleName, Type, SubType, Turn, DrawTimes, LuckeyValue, Reward, GradeIdList, utime:unixtime()]),
    ok.


log_get_beta_recharge_reward(RoleId, Gold, ReturnGold, LoginDays) ->
    mod_log:add_log(log_get_beta_recharge_reward, [RoleId, Gold, ReturnGold, LoginDays, utime:unixtime()]),
    ok.

log_dec_unlock_cell(RoleId, UnlockList) ->
    mod_log:add_log(log_dec_unlock_cell, [RoleId, UnlockList, utime:unixtime()]),
    ok.

%% 分区更改日志
log_zone_change(ServerId, NewZone, OldZone) ->
    mod_log:add_log(log_zone_change, [ServerId, NewZone, OldZone, utime:unixtime()]),
    ok.

%% 服务器节点日志
log_server_open(ServerStatus, ServerType, Node, ServerId, ServerNum, Platform, BeginTime, EndTime, CostTime) ->
    mod_log:add_log(log_server_open, [ServerStatus, ServerType, Node, ServerId, ServerNum, ulists:list_to_bin(Platform), BeginTime, EndTime, CostTime, utime:unixtime()]),
    ok.

%% 服务器日清日志
log_server_daily_clear(LogType, BeginTime, EndTime) ->
    mod_log:add_log(log_server_daily_clear, [LogType, BeginTime, EndTime, max(EndTime - BeginTime, 0), utime:unixtime()]),
    ok.

%% 服务器热更日志
log_server_hot(ModuleList, BeginTime, EndTime) ->
    mod_log:add_log(log_server_hot, [util:term_to_bitstring(ModuleList), BeginTime, EndTime, max(EndTime - BeginTime, 0), utime:unixtime()]),
    ok.

%% 服务器内存日志
log_server_memory(MemoryTotal, MemoryProcesses, MemoryAtom, MemoryBinary, MemoryCode, MemoryEts, ProcessCNT, EtsCNT, PortCNT) ->
    mod_log:add_log(log_server_memory, [MemoryTotal, MemoryProcesses, MemoryAtom, MemoryBinary, MemoryCode, MemoryEts, ProcessCNT, EtsCNT, PortCNT, utime:unixtime()]),
    ok.

%% 服务器web_interface日志
log_server_interface(Module, Func, Args, Ret, BeginTime, EndTime) ->
    mod_log:add_log(log_server_interface, [Module, Func, util:fix_sql_str(util:term_to_bitstring(Args)), util:fix_sql_str(util:term_to_bitstring(Ret)), max(EndTime - BeginTime, 0), utime:unixtime()]),
    ok.

log_active_push_gift(LogList) ->
    case LogList == [] of
        true -> ok;
        _ -> mod_log:add_log(log_active_push_gift, LogList)
    end.

log_buy_push_gift(RoleId, GiftId, SubId, GradeId, CostList, RewardsList, NowTime) ->
    mod_log:add_log(log_buy_push_gift, [RoleId, GiftId, SubId, GradeId, util:term_to_bitstring(CostList), util:term_to_bitstring(RewardsList), NowTime]).

%% 璀璨之海 船只升级
log_sea_treasure_up(RoleId, RoleName, ShipId, ShipVal, NewShipId, NewShipVal, FreeTimesUse, UpType, Cost) ->
    mod_log:add_log(log_sea_treasure_up, [RoleId, util:fix_sql_str(RoleName), ShipId, ShipVal, NewShipId,
        NewShipVal, FreeTimesUse, UpType, util:term_to_bitstring(Cost), utime:unixtime()]).

%% 璀璨之海 巡航日志
log_sea_treasure(AutoId, ShipId, SerId, RoleId, RoleName, LogType, RoberSerId, RoberId, RoberName, Reward) ->
    mod_log:add_log(log_sea_treasure, [AutoId, ShipId, SerId, RoleId, util:fix_sql_str(RoleName), LogType, RoberSerId,
        RoberId, util:fix_sql_str(RoberName), util:term_to_bitstring(Reward), utime:unixtime()]).

%% 璀璨之海 掠夺日志
log_sea_treasure_rob(SerId, RoleId, RoleName, AutoId, ShipId, RoberSerId, RoberId, RoberName, Res, Reward) ->
    mod_log:add_log(log_sea_treasure_rob, [SerId, RoleId, util:fix_sql_str(RoleName), AutoId, ShipId, RoberSerId,
        RoberId, util:fix_sql_str(RoberName), Res, util:term_to_bitstring(Reward), utime:unixtime()]).

%% 璀璨之海 协助日志
log_sea_treasure_rback(
    SerId, RoleId, HelperId, HelperName, AutoId, ShipId, RoberSerId, RoberId, RoberName, Res, RobReward, Reward
) ->
    mod_log:add_log(log_sea_treasure_rback, [
        SerId, RoleId, HelperId, util:fix_sql_str(HelperName), AutoId, ShipId, RoberSerId,
        RoberId, util:fix_sql_str(RoberName), Res, util:term_to_bitstring(RobReward),
        util:term_to_bitstring(Reward), utime:unixtime()
    ]).

log_temple_awaken_chapter(RoleId, Chapter, Status) ->
    mod_log:add_log(log_temple_awaken_chapter, [RoleId, Chapter, Status, utime:unixtime()]).

log_temple_awaken_chapter_sub(RoleId, Chapter, SubChapter, Status) ->
    mod_log:add_log(log_temple_awaken_chapter_sub, [RoleId, Chapter, SubChapter, Status, utime:unixtime()]).

log_temple_awaken_chapter_stage(RoleId, Chapter, SubChapter, Stage, Process, Status) ->
    mod_log:add_log(log_temple_awaken_chapter_stage, [RoleId, Chapter, SubChapter, Stage, Process, Status, utime:unixtime()]).

%% 玩家掉落比率日志
log_role_drop_ratio(RoleId, RatioId, Count, IsHit) ->
    mod_log:add_log(log_role_drop_ratio, [RoleId, RatioId, Count, IsHit, utime:unixtime()]),
    ok.

%% 脱离卡死日志
log_escape_stuck(RoleId, SceneId, Coordinate) ->
    mod_log:add_log(log_escape_stuck, [RoleId, SceneId, util:term_to_bitstring(Coordinate), utime:unixtime()]).

%% 套装收集日志
log_suit_clt(RoleId, RoleName, SuitId, Stage) ->
    mod_log:add_log(log_suit_clt, [RoleId, util:fix_sql_str(RoleName), SuitId, Stage, utime:unixtime()]).

%% boss体力值
log_boss_vit_change(RoleId, RoleName, OldVit, LastVitTime, Cost, MonId, Vit, NewLastVitTime, MaxVit, AddVitTime) ->
    mod_log:add_log(log_boss_vit_change, [RoleId, util:fix_sql_str(RoleName), OldVit, LastVitTime,
        util:term_to_bitstring(Cost), MonId, Vit, NewLastVitTime, MaxVit, AddVitTime, utime:unixtime()]).

log_activity_onhook(RoleId, StartOrEnd, Module, SubModule, Code, OnhookTime, CostCoin, NowTime) ->
    mod_log:add_log(log_activity_onhook, [RoleId, StartOrEnd, Module, SubModule, Code, OnhookTime, CostCoin, NowTime]).

log_auto_forbid_chat(Platform, SerId, SerName, RoleId, RoleName, RoleLv, RoleVip, Reason, Time) ->
    mod_log:add_log(log_auto_forbid_chat, [Platform, SerId, SerName, RoleId, RoleName, RoleLv, RoleVip, Reason, Time]).

log_dragon_ball(RoleId, DragonId, OldLv, NewLv, Cost) ->
    mod_log:add_log(log_dragon_ball, [RoleId, DragonId, OldLv, NewLv, util:term_to_bitstring(Cost), utime:unixtime()]).

log_setting(RoleId, SettingList) ->
    mod_log:add_log(log_setting, [RoleId, util:term_to_bitstring(SettingList), utime:unixtime()]).

%% 战甲
log_armour(RoleId, RoleName, Stage, Type, Pos, EquipId, ConsumeList, EquipList) ->
    ConsumeListBin = util:term_to_bitstring(ConsumeList),
    EquipListBin = util:term_to_bitstring(EquipList),
    mod_log:add_log(log_armour, [RoleId, util:fix_sql_str(RoleName), Stage, Type, Pos, EquipId, ConsumeListBin, EquipListBin, utime:unixtime()]).

log_role_advertisement(RoleId, Mod, DunType, Count, Reward, GradeId) ->
    mod_log:add_log(log_role_advertisement, [RoleId, Mod, DunType, "0", utime:unixtime(), Count, util:term_to_bitstring(Reward), GradeId]).

%% 秘籍使用日志
log_gm_use(RoleId, RoleName, Content) ->
    mod_log:add_log(log_gm_use, [RoleId, util:fix_sql_str(RoleName), util:fix_sql_str(Content), utime:unixtime()]).

%% 日志:玩家(高级)祭典开启
log_fiesta(RoleId, RegDay, RoleLv, FiestaId, ActId, Type, BeginTime, ExpiredTime) ->
    mod_log:add_log(log_fiesta, [RoleId, RegDay, RoleLv, FiestaId, ActId, Type, BeginTime, ExpiredTime, utime:unixtime()]).

%% 日志:玩家任务完成进度
log_fiesta_task_progress(RoleId, TaskType, TaskId, Progress, FinishTimes, Status, AccTimes) ->
    mod_log:add_log(log_fiesta_task_progress, [RoleId, TaskType, TaskId, Progress, FinishTimes, Status, AccTimes, utime:unixtime()]).

%% 日志:玩家任务奖励领取
log_fiesta_task_reward(RoleId, TaskId, OExp, NExp) ->
    mod_log:add_log(log_fiesta_task_reward, [RoleId, TaskId, OExp, NExp, utime:unixtime()]).

%% 日志:玩家祭典奖励领取
log_fiesta_reward(RoleId, FiestaId, Lv, RewardL) ->
    RewardLBin = util:term_to_bitstring(RewardL),
    mod_log:add_log(log_fiesta_reward, [RoleId, FiestaId, Lv, RewardLBin, utime:unixtime()]).

%% 日志:玩家符文本每日奖励领取
log_dungeon_rune_daily_reward(RoleId, Level, LevelList, RewardList) ->
    mod_log:add_log(log_dungeon_rune_daily_reward, [RoleId, Level, util:term_to_bitstring(LevelList), util:term_to_bitstring(RewardList), utime:unixtime()]).

%% 成长福利任务进度日志
log_grow_welfare_task_process(RoleId, TaskId, Process, Status) ->
    mod_log:add_log(log_grow_welfare_task_process, [RoleId, TaskId, Process, Status, utime:unixtime()]).

%% 战力福利次数产出日志
log_combat_welfare_times(RoleId, RoleName, Power, AddTimes) ->
    mod_log:add_log(log_combat_welfare_times, [RoleId, util:fix_sql_str(RoleName), Power, AddTimes,  utime:unixtime()]).


%% 坐骑类升级养成线日志
log_mount_upgrade_sys(RoleId, TypeId, PreLevel, PreExp, ExpPlus, CurLevel, CurExp, Cost) ->
    CostStr = util:term_to_bitstring(Cost),
    mod_log:add_log(log_mount_upgrade_sys, [RoleId, TypeId, PreLevel, PreExp, ExpPlus, CurLevel, CurExp, CostStr, utime:unixtime()]),
    ok.

%% 红包返利金额日志
log_envelope_rebate_reward(Type, SubType, RoleId, EnvelopeType, EnvelopeId, Value, Sum) ->
    mod_log:add_log(log_envelope_rebate_reward, [Type, SubType, RoleId, EnvelopeType, EnvelopeId, Value, Sum,  utime:unixtime()]).

%% 红包返利提现
log_envelope_rebate_withdrawal(Type, SubType, RoleId, EnvelopeType, Ids, Value, Status) ->
    mod_log:add_log(log_envelope_rebate_withdrawal, [Type, SubType, RoleId, EnvelopeType, util:term_to_bitstring(Ids), Value, Status,  utime:unixtime()]).

%% 众生之门活动本服日志
log_beings_gate_activity(ServerId, YesterdayActivity, PortalList, ActivityTime) ->
    mod_log:add_log(log_beings_gate_activity, [ServerId, YesterdayActivity, util:term_to_bitstring(PortalList), ActivityTime,  utime:unixtime()]).

%% 众生之门活动本服日志
log_beings_gate_activity_cls(ZoneId, GroupId, Mod, YesterdayActivity, ActivityTime, PortalList) ->
    mod_log:add_log(log_beings_gate_activity_cls, [ZoneId, GroupId, Mod, YesterdayActivity, ActivityTime, util:term_to_bitstring(PortalList), utime:unixtime()]).

%% 战力福利抽奖记录日志(20220317应运营要求添加该日志)
log_combat_welfare_reward_info(RoleId, RoleName, Round, RewardId, Reward) ->
    mod_log:add_log(log_combat_welfare_reward_info, [RoleId, util:fix_sql_str(RoleName), Round, RewardId, util:term_to_bitstring(Reward), utime:unixtime()]).

%% 古宝激活日志
log_enchantment_guard_soap_debris(RoleId, SoapId, DebrisId) ->
    mod_log:add_log(log_enchantment_guard_soap_debris, [RoleId, SoapId, DebrisId, utime:unixtime()]).

%% 周卡激活日志
log_weekly_card_open(RoleId, Lv, ExpiredTime) ->
    mod_log:add_log(log_weekly_card_open, [RoleId, Lv, ExpiredTime, utime:unixtime()]).

%% 周卡玩家信息日志
log_weekly_card_info(RoleId, OldLv, NewLv, OldExp, NewExp, OldCanNum, NewCanNum, OldSumNum, NewSumNum, RewardList) ->
    mod_log:add_log(log_weekly_card_info, [RoleId, OldLv, NewLv, OldExp, NewExp, OldCanNum, NewCanNum, OldSumNum, NewSumNum, util:term_to_string(RewardList), utime:unixtime()]).

%% 循环冲榜玩家积分变化表
log_cycle_rank_role_score(RoleId, Name, Type, Subtype, HandleType, Cost, Oscore, AddScore, NScore) ->
    mod_log:add_log(log_cycle_rank_role_score, [RoleId, util:fix_sql_str(Name), Type, Subtype, HandleType, util:term_to_bitstring(Cost), Oscore, AddScore, NScore, utime:unixtime()]).

%% 循环冲榜目标奖励日志
log_cycle_rank_reach(RoleId, Name, Type, SubType, RewardId, Reward, PType) ->
    mod_log:add_log(log_cycle_rank_reach, [RoleId, util:fix_sql_str(Name), Type, SubType, RewardId, util:term_to_bitstring(Reward), PType, utime:unixtime()]).

%% 循环冲榜活动时间日志
log_cycle_rank_time(List)->
    case List =/= [] of
        true-> mod_log:add_log(log_cycle_rank_time, List);
        false-> skip
    end,
    ok.

%% 循环冲榜排名变化日志
log_cycle_rank_rank(RoleId, Name, Type, SubType, Score, Rank, ServerId) ->
    mod_log:add_log(log_cycle_rank_rank, [RoleId, util:fix_sql_str(Name), Type, SubType, Score, Rank, ServerId, utime:unixtime()]).

%% 循环冲榜排名奖励发放日志
log_cycle_rank_rank_reward(RoleId, Name, ServerId, Type, SubType, Score, Rank, Reward) ->
    mod_log:add_log(log_cycle_rank_rank_reward, [RoleId, util:fix_sql_str(Name), ServerId, Type, SubType, Score, Rank, util:term_to_bitstring(Reward), utime:unixtime()]).
log_cycle_rank_rank_reward(LogList) ->
    mod_log:add_log(log_cycle_rank_rank_reward, LogList).


%% 百鬼夜行 boss生成、死亡日志
log_night_ghost_boss(ZoneId, GroupId, SceneId, BossId, X, Y, Type) ->
    mod_log:add_log(log_night_ghost_boss, [ZoneId, GroupId, SceneId, BossId, X, Y, Type, utime:unixtime()]).

%% 百鬼夜行 伤害排名日志
log_night_ghost_rank(ZoneId, GroupId, SceneId, BossId, Sign, Id, SerId, RoleId, Rank, Hurt) ->
    mod_log:add_log(log_night_ghost_rank, [ZoneId, GroupId, SceneId, BossId, Sign, Id, SerId, RoleId, Rank, Hurt, utime:unixtime()]).

%% 百鬼夜行 尾刀日志
log_night_ghost_killer(ZoneId, GroupId, SceneId, BossId, SerId, TeamId, RoleId) ->
    mod_log:add_log(log_night_ghost_killer, [ZoneId, GroupId, SceneId, BossId, SerId, TeamId, RoleId, utime:unixtime()]).

%% 百鬼夜行 奖励日志
log_night_ghost_reward(RoleId, Type, Rank, RewardList) ->
    mod_log:add_log(log_night_ghost_reward, [RoleId, Type, Rank, util:term_to_bitstring(RewardList), utime:unixtime()]).

%% 模拟抽奖日志
log_treasure_hunt_imitate(Args) ->
    mod_log:add_log(log_treasure_hunt_imitate, Args).

%% 排行榜快照
log_midnight_common_rank(List) ->
    mod_log:add_log(log_midnight_common_rank, List).

%% 等级抢购活动玩家开启日志
log_level_act_open(RoleId, Type, SubType, Now, EndTime) ->
    mod_log:add_log(log_level_act_open, [RoleId, Type, SubType, Now, EndTime]).

%% 秘境Boss击杀日志
%% 记录幻兽之域的boss击杀归属记录
log_great_demon_boss_kf(ZoneId, BossId, AttrId, AttrName, KPForm, KSName, Bl1, Bl2, Bl3, NowTime) ->
    mod_log:add_log(log_great_demon_boss_kf, [ZoneId, BossId, AttrId, AttrName, KPForm, KSName, Bl1, Bl2, Bl3, NowTime]),
    ok.