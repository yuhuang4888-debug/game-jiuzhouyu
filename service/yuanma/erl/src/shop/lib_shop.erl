%%%--------------------------------------
%%% @Module  : lib_shop
%%% @Author  : xiaoxiang
%%% @Created : 2017-01-04
%%% @Description:  商城
%%%--------------------------------------
-module(lib_shop).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("goods.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("top_pk.hrl").
-include("daily.hrl").
-include("constellation_equip.hrl").
-include("god_court.hrl").
-include("guild.hrl").

%% 获取商城列表
get_goods_list(#player_status{id = RoleId, sid = Sid, figure = #figure{career = RoleCareer, lv = RoleLv, turn = RoleTurn, vip = Vip, vip_type = VipType}}=Player, Type) ->
    ServerTime = util:get_open_day(), %  开服天数
    WorldLv = util:get_world_lv(), %  世界等级
    KeyList = data_shop:get_shop(Type), %  id 列表
    %%    ?PRINT("ServerTime:~w~n",[{ServerTime,WorldLv,KeyList}]),
    F = fun(KeyId, GoodsList) ->
        case data_shop:get_shop_config(KeyId) of
            #shop{key_id = KeyId, shop_type = Type, shop_subtype_list = ShopSubtypeL, career = Career, rank = Rank, ctype = MoneyType,
                goods_id = GoodsId, num = Num, price = Price, discount = Discount,
                quota_type = QuotaType, quota_num = QuotaNum, on_sale = OnSale, halt_sale = HaltSale,
                counter_module = _Module, counter_id = CounterId, bind = Bind,
                wlv_sale = WlvSale, wlv_unsale = WlvUnsale, condition = Condition, turn = Turn} ->
                if
                %%                  还没有开始出售 或 已经结束出售
                    (OnSale > ServerTime) orelse (ServerTime > HaltSale andalso HaltSale /= 0) ->
                        GoodsList;
                %%                   世界等级限制同上
                    (WlvSale > WorldLv) orelse (WorldLv > WlvUnsale andalso WlvUnsale /= 0) ->
                        GoodsList;
                    true ->
                        %%                      玩家等级限制
                        Send = case lists:keyfind(lv, 1, Condition) of
                                   {lv, Lv} when RoleLv >= Lv -> 1;
                                   {lv, SLv, ELv} when RoleLv >= SLv andalso RoleLv =< ELv -> 1;
                                   false -> 1;
                                   _ -> 0
                               end,
                        %%                      转生限制
                        TurnCond = case lists:keyfind(turn, 1, Turn) of
                                       {turn, TurnTmp} when RoleTurn >= TurnTmp -> 1;
                                       false -> 1;
                                       _ -> 0
                                   end,
                        TriggerTaskId = case lists:keyfind(trigger_task, 1, Turn) of
                                            {trigger_task, TriggerTaskId0} -> TriggerTaskId0;
                                            _ -> 0
                                        end,
                        %%                      职业可见
                        IsLook =
                            case Career == [] of
                                true -> true;
                                false ->
                                    case is_exist(RoleCareer, Career) of
                                        true -> true;
                                        _ -> false
                                    end
                            end,
                        %% 是否前置任务
                        CheckIsPre = case lists:keyfind(pre, 1, Condition) of
                            {pre, PreShopId} ->
                                Count = mod_counter:get_count(RoleId, ?MOD_SHOP, ?MOD_SHOP_PRE_GOODS, PreShopId),
                                % ?PRINT(Type==10, "15301 GoodsId:~p PreShopId:~p Count:~p  ~n", [GoodsId, PreShopId, Count]),
                                Count > 0;
                            _ -> true
                        end,
                        % ?PRINT(Type==10, "15301 GoodsId:~p Condition :~p  CheckIsPre:~p CheckIsPre2:~p~n", [GoodsId, Condition, CheckIsPre, lists:keyfind(pre, 1, Condition)]),
                        if
                            Send == 0 orelse IsLook == false orelse TurnCond == 0 orelse CheckIsPre == false -> GoodsList;
                            true ->
                                case util:term_to_string(ShopSubtypeL) of
                                    undefined -> ShopSubtypeLStr = [];
                                    ShopSubtypeLStr -> ok
                                end,
                                % 判断是否战魂商店，根据vip和特权改变物品绑定
                                NewBind = ?IF(Type == ?SHOP_ZEN_SOUL, ?IF(Vip >= 4 andalso VipType =/= 0, ?UNBIND, ?BIND), Bind),
                                case util:term_to_string(Condition) of
                                    undefined -> % 不能序列化不能传输
                                        GoodsList;
                                    StrCondition ->
                                        UsedTime = ?IF(QuotaNum > 0, get_buyed_time(RoleId, KeyId, CounterId, QuotaType), 0),
                                        RealQuotaNum = get_real_quota_num(QuotaType, QuotaNum, Condition, Player),
                                        [{KeyId, ShopSubtypeLStr, Rank, GoodsId, Num, MoneyType, Price,
                                            Discount, QuotaType, RealQuotaNum, UsedTime, StrCondition, TriggerTaskId, NewBind} | GoodsList]
                                end
                        end
                end;
            _ -> % 没有商品配置为 []
                GoodsList
        end
        end,
    NewGoodsList = lists:foldl(F, [], KeyList),
    {ok, BinData} = pt_153:write(15301, [Type, NewGoodsList]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 购买商品
buy_goods_by_money_type(#player_status{id = RoleId, figure = #figure{name = _Name}} = Player, KeyId, BuyNum) ->
    case data_shop:get_shop_config(KeyId) of
        #shop{key_id = KeyId, shop_type = ShopType, goods_id = GoodsId, num = GNum,
            ctype = CType, price = Price, bind = Bind,
            quota_type = QuotaType, quota_num = QuotaNum, on_sale = OnSale, halt_sale = HaltSale,
            wlv_sale = WlvSale, wlv_unsale = WlvUnsale, condition = Condition,
            counter_id = CounterId} = GoodShop ->
            CheckList = [
                {args, [BuyNum]}, % num >=0
                {server_time, OnSale, HaltSale},
                {wlv, WlvSale, WlvUnsale},
                {condition, Condition},
                {quota_num, QuotaType, QuotaNum, KeyId, CounterId, BuyNum, Condition},
                {bag, GoodsId, GNum * BuyNum, Bind},
                {money, GoodShop, BuyNum}
            ],
            case check_buy_goods(CheckList, Player) of
                {true, NewPS} ->
                    ErrCode = ?SUCCESS,
                    log_shop(RoleId, ShopType, GoodsId, GNum * BuyNum, BuyNum, CType, Price * BuyNum),
                    %%                    lib_player_event:async_dispatch(RoleId, ?EVENT_SHOP_CONSUME, GNum * BuyNum),
                    ta_agent_fire:role_shop_by(NewPS, [shop, ShopType, GoodsId, GNum * BuyNum, CType, Price * BuyNum]),
                    PsAfBuy = af_buy_goods(NewPS, ShopType, KeyId);
                {false, ErrCode, PsAfBuy} -> ok
            end,
            {ErrCode, PsAfBuy};
        _ -> % 没有商品配置为 []
            {?ERRCODE(err_config), Player}
    end.

af_buy_goods(#player_status{id = RoleId} = PS, ShopType, KeyId) ->
    %% 检查是否是前置
    case check_is_pre(ShopType, KeyId) of
        true ->
            Count = mod_counter:get_count(RoleId, ?MOD_SHOP, ?MOD_SHOP_PRE_GOODS, KeyId),
            if
                Count > 0 -> skip;
                true ->
                    mod_counter:increment(RoleId, ?MOD_SHOP, ?MOD_SHOP_PRE_GOODS, KeyId),
                    lib_shop:get_goods_list(PS, ShopType)
            end;
        false ->
            skip
    end,
    PS.

%% 检查是否是前置
check_is_pre(ShopType, KeyId) ->
    KeyList = data_shop:get_shop(ShopType),
    F = fun(TmpKeyId) ->
        #shop{condition = Condition} = data_shop:get_shop_config(TmpKeyId),
        case lists:keyfind(pre, 1, Condition) of
            {pre, KeyId} -> true;
            _ -> false
        end
    end,
    lists:any(F, KeyList).

%% -------------------check-------------------------------------
check_buy_goods([], Player) -> {true, Player};
check_buy_goods([Check | List], Player) ->
    case do_check_buy_goods(Check, Player) of
        {true, NewPlayer} -> check_buy_goods(List, NewPlayer);
        Error -> Error
    end.

%% 检查参数
do_check_buy_goods({args, [BuyNum]}, Player) ->
    if
        BuyNum =< 0 -> {false, ?ERRCODE(err153_goods_not_equal), Player};
        true -> {true, Player}
    end;

%% 开服时间
do_check_buy_goods({server_time, OnSale, HaltSale}, Player) ->
    OpTime = util:get_open_day(),
    if
        (OpTime < OnSale) orelse (OpTime > HaltSale andalso HaltSale =/= 0) ->
            {false, ?ERRCODE(err153_not_enough_server_time), Player};
        true ->
            {true, Player}
    end;

%% 世界等级
do_check_buy_goods({wlv, WlvSale, WlvUnsale}, Player) ->
    ServerLv = util:get_world_lv(),
    if
        (ServerLv < WlvSale) orelse (ServerLv > WlvUnsale andalso WlvUnsale /= 0) ->
            {false, ?ERRCODE(err153_not_enough_world_lv), Player};
        true ->
            {true, Player}
    end;

%% 购买条件检查
do_check_buy_goods({condition, Condition}, Player) ->
    case check_player_condition(Condition, Player) of
        true -> {true, Player};
        Res -> Res
    end;

%% 次数限制
do_check_buy_goods({quota_num, QuotaType, QuotaNum, KeyId, CounterId, Num, Condition},
        #player_status{id = RoleId} = Player) ->
    case QuotaNum of
        0 -> {true, Player};
        _ ->
            case QuotaType of
                ?QUATO_TYPE_NONE -> {true, Player};
                _ ->
                    GoodsNum = ?IF(QuotaNum > 0, get_buyed_time(RoleId, KeyId, CounterId, QuotaType), 0),
                    RealQuotaNum = get_real_quota_num(QuotaType, QuotaNum, Condition, Player),
                    case GoodsNum < RealQuotaNum of
                        false -> {false, ?ERRCODE(err153_goods_sold_out), Player};
                        true ->
                            case ((GoodsNum + Num) =< RealQuotaNum) of
                                false -> {false, ?ERRCODE(err153_not_enough_goods_to_buy), Player};
                                true -> {true, Player}
                            end
                    end
            end
    end;

%% 检查背包数
do_check_buy_goods({bag, GoodsId, Num, Bind}, Player) ->
    case lib_goods_api:can_give_goods(Player, [{?TYPE_GOODS, GoodsId, Num, Bind}]) of
        true ->
            {true, Player};
        {false, ErrorCode} ->
            {false, ErrorCode, Player}
    end;

%% 判断金钱是否足够,并扣钱
do_check_buy_goods({money, GoodShop, BuyNum}, #player_status{id = RoleId, figure = #figure{vip = Vip, vip_type = VipType}} = Player) ->
    #shop{
        key_id = KeyId,
        shop_type = ShopType, goods_id = GoodsId, num = GoodNum,
        ctype = CType, price = Price, discount = Discount, bind = Bind,
        quota_type = QuotaType, quota_num = QuotaNum,  counter_id = CounterId} = GoodShop,
    case do_check_money_enough(Player, Price, Discount, BuyNum, CType, ShopType) of
        true ->
            case do_check_cost_money(Player, Price, CType, BuyNum, Discount, GoodsId, GoodNum, ShopType) of
                {true, CostType, NewPS} ->
                    % 判断是否战魂商店，根据vip和特权改变物品绑定
                    NewBind = ?IF(ShopType == ?SHOP_ZEN_SOUL, ?IF(Vip >= 4 andalso VipType =/= 0, ?UNBIND, ?BIND), Bind),
                    %% 发送物品
                    Produce = #produce{type = CostType, subtype = 0, remark = "shop sale",
                        reward = [{NewBind * ?TYPE_BIND_GOODS, GoodsId, GoodNum * BuyNum}], show_tips = 1},
                    LastPs = lib_goods_api:send_reward(NewPS, Produce),
                    %% 添加次数
                    ?IF(QuotaNum > 0, add_buyed_time(RoleId, KeyId, CounterId, QuotaType, BuyNum), skip),
                    {true, LastPs};
                {false, ErrCode, NewPS} ->
                    {false, ErrCode, NewPS}
            end;
        {false, ErrCode} ->
            {false, ErrCode, Player}
    end;

do_check_buy_goods(_, PS) ->
    {false, ?FAIL, PS}.

%% 检查扣钱
do_check_money_enough(Player, Price, Discount, BuyNum, CType, ShopType) ->
    if
        CType == ?TYPE_BGOLD orelse CType == ?TYPE_GOLD orelse CType == ?TYPE_HONOUR orelse CType == ?GOODS_ID_TOP_HONOR
            orelse CType == ?GOODS_ID_MEDAL orelse CType == ?GOODS_ID_KF_SAN orelse CType == ?GOODS_ID_3V3_POINT orelse CType == ?GOODS_ID_EUDEMONS_SCORE
            orelse CType == ?GOODS_ID_SUPVIP orelse CType == ?GOODS_ID_RDUNGEON_SCORE orelse CType == ?GOODS_ID_LUCKY_SHOP_COIN
            orelse CType == ?GOODS_ID_DRACONIC_SHOP_COIN orelse CType == ?GOODS_ID_GODCOURT_SHOP_COIN orelse CType == ?GOODS_ID_GUILD_PRESTIGE orelse
            CType == ?GOODS_ID_GUILD_PRESTIGE_GOOD orelse CType == ?GOODS_ID_ZEN_SOUL orelse CType == ?GOODS_ID_NIGHT_GHOST_POINT ->
            Gold = round(Price * BuyNum * Discount / 100),
            Cost = case ShopType of
                        ?SHOP_GLORY -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_SEAL -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_MEDAL -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_3V3 -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_SUPVIP -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_EUDEMONS -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_RDUNGEON -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_LUCKY -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_DRACONIC -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_GOD_COURT -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_PRESITIGE ->
                            ?IF(CType == ?GOODS_ID_GUILD_PRESTIGE_GOOD, [{?TYPE_GOODS, CType, Gold}], [{?TYPE_CURRENCY, CType, Gold}]);
                        ?SHOP_ZEN_SOUL -> [{?TYPE_CURRENCY, CType, Gold}];
                        ?SHOP_NIGHT_GHOST -> [{?TYPE_CURRENCY, CType, Gold}];
                       _ -> [{CType, 0, Gold}]
                   end,
            %% 通用的扣东西检查
            case lib_goods_api:check_object_list(Player, Cost) of
                true -> true;
                {false, Err} ->
                    ErrCode = convert_cost_errcode(ShopType, Err),
                    {false, ErrCode}
            end;
        true ->
            {false, ?ERRCODE(err153_money_type_wrong)}
    end.

%% 通用的扣除东西检查
do_check_cost_money(Player, Price, CType, BuyNum, Discount, GoodsId, Num, ShopType) ->
    MoneyNum = round(Price * BuyNum * Discount / ?BASE_DISCOUNT),
    About = #cost_log_about{type = 3, data = [GoodsId, Num * BuyNum], remark = "shop cost"},
    CostType = case ShopType of
                   ?SHOP_DIAMOND -> shop_diamond;
                   ?SHOP_WEEK -> shop_week;
                   ?SHOP_BGOLD -> shop_bgold;
                   ?SHOP_FIGURE -> shop_figure;
                   ?SHOP_NORMAL -> shop_normal;
                   ?SHOP_GLORY -> shop_glory;
                   ?SHOP_SEAL -> shop_seal;
                   ?SHOP_MEDAL -> shop_medal;
                   ?SHOP_3V3 -> shop_3v3;
                   ?SHOP_SUPVIP -> shop_supvip;
                   ?SHOP_EUDEMONS -> shop_eudemons;
                   ?SHOP_RDUNGEON -> shop_rdungeon;
                   ?SHOP_LUCKY -> shop_lucky;
                   ?SHOP_DRACONIC -> shop_draconic;
                   ?SHOP_GOD_COURT -> shop_god_court;
                   ?SHOP_PRESITIGE -> shop_prestige;
                   ?SHOP_ZEN_SOUL -> shop_zen_soul;
                   ?SHOP_NIGHT_GHOST -> shop_night_ghost;
                    _ -> shop_life
               end,
    Cost = case ShopType of
               ?SHOP_GLORY -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_SEAL -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_MEDAL -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_3V3 -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_SUPVIP -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_EUDEMONS -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_RDUNGEON -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_LUCKY -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_DRACONIC -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_GOD_COURT -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               ?SHOP_PRESITIGE ->
                    ?IF(CType == ?GOODS_ID_GUILD_PRESTIGE_GOOD, [{?TYPE_GOODS, CType, MoneyNum}], [{?TYPE_CURRENCY, CType, MoneyNum}]);
                ?SHOP_ZEN_SOUL -> [{?TYPE_CURRENCY, CType, MoneyNum}];
                ?SHOP_NIGHT_GHOST -> [{?TYPE_CURRENCY, CType, MoneyNum}];
               _ -> [{CType, 0, MoneyNum}]
           end,
    case lib_goods_api:cost_object_list(Player, Cost, CostType, About) of
        {true, NewPS} -> {true, CostType, NewPS};
        {false, Err, NewPS} ->
            Errcode = convert_cost_errcode(ShopType, Err),
            {false, Errcode, NewPS}
    end.

%% 记录日志
log_shop(RoleId, ShopType, GoodsId, AllNum, BuyNum, CType, AllPrice) ->
    Time = utime:unixtime(),
    lib_log_api:log_shop(RoleId, ShopType, GoodsId, AllNum, BuyNum, CType, AllPrice, Time).


%% 检查物品的购买条件
check_player_condition([], _Player) -> true;
check_player_condition([{lv, Lv} | Condition], Player) ->
    if
        Player#player_status.figure#figure.lv < Lv -> {false, ?ERRCODE(err153_not_enough_lv), Player};
        true -> check_player_condition(Condition, Player)
    end;
check_player_condition([{lv, SLv, ELv} | Condition], Player) ->
    if
        Player#player_status.figure#figure.lv > ELv -> {false, ?ERRCODE(err153_not_enough_lv), Player};
        Player#player_status.figure#figure.lv < SLv -> {false, ?ERRCODE(err153_not_enough_lv), Player};
        true -> check_player_condition(Condition, Player)
    end;
check_player_condition([{vip, Vip} | Condition], Player) ->
    if
        Player#player_status.figure#figure.vip < Vip -> {false, ?ERRCODE(err159_vip_not_enough), Player};
        true -> check_player_condition(Condition, Player)
    end;

check_player_condition([{top_pk_grade, Grade} | Condition], Player) ->
    if
        Player#player_status.top_pk#top_pk_status.rank_lv < Grade -> {false, ?ERRCODE(err153_top_pk_grade), Player};
        true -> check_player_condition(Condition, Player)
    end;

check_player_condition([{supvip_right} | Condition], Player) ->
    case lib_supreme_vip_api:is_buy_shop_right(Player) of
        true -> check_player_condition(Condition, Player);
        false -> {false, ?ERRCODE(err153_supvip_right_not_to_buy), Player}
    end;

check_player_condition([{pre, ShopId} | Condition], #player_status{id = RoleId} = Player) ->
    Count = mod_counter:get_count(RoleId, ?MOD_SHOP, ?MOD_SHOP_PRE_GOODS, ShopId),
    if
        Count > 0 -> check_player_condition(Condition, Player);
        true -> {false, ?ERRCODE(err153_must_buy_pre_shop), Player}
    end;
check_player_condition([{rank_dun_level, NeedLevel} | Condition], Player) ->
    case lib_kf_rank_dungeon:get_player_cur_max_level(Player) of
        {ok, MaxLevel} ->
            case MaxLevel >= NeedLevel of
                true ->
                    check_player_condition(Condition, Player);
                _ ->
                    {false, ?ERRCODE(err153_kf_rank_level_err), Player}
            end;
        {false, Errcode} ->
            {false, Errcode, Player}
    end;
check_player_condition([{attr, NeedAttr} | Condition], Player) ->
    #player_status{original_attr=OTotalAttr} = Player,
    RoleAttrL = lib_player_attr:to_kv_list(OTotalAttr),
    case check_role_attr(NeedAttr, RoleAttrL, false) of
        true ->
            check_player_condition(Condition, Player);
        _ ->
            {false, ?ERRCODE(err153_attr_not_enougth), Player}
    end;
check_player_condition([{constellation_equip, ConstellationId}|Condition], Player) ->
    #player_status{constellation = ConstellationStatus} = Player,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        #constellation_item{is_active = IsActive} when IsActive == ?ACTIVE ->
            check_player_condition(Condition, Player);
        _ ->
            {false, ?ERRCODE(err153_attr_constellation_not_active), Player}
    end;

check_player_condition([{god_pool_lv, Lv}|Condition], Player) ->
    #player_status{god_court_status = #god_court_status{house_status = #god_house_status{sum_num = SumNum}}} = Player,
    LvList = data_god_court:get_house_reward_lvs(),
    {RewardLv, _} = lib_god_court:get_reward_pool(SumNum, LvList),
    case RewardLv >= Lv of
       true ->
           check_player_condition(Condition, Player);
       false ->
           {false, ?ERRCODE(err153_god_pool_lv), Player}
    end;
check_player_condition([{guild_lv, NeedGuildLv}|Condition], Player) ->
    #player_status{guild = #status_guild{lv = GuildLv}} = Player,
    case GuildLv >= NeedGuildLv of
       true ->
           check_player_condition(Condition, Player);
       false ->
           {false, ?ERRCODE(err153_guild_lv), Player}
    end;
check_player_condition([{guild_title, NeedTitle}|Condition], Player) ->
    {ok, AllPrestige} = mod_guild_prestige:get_role_prestige(Player#player_status.id),
    PrestigeTitleId = lib_guild_data:get_prestige_title_id(AllPrestige),
    case PrestigeTitleId >= NeedTitle of
       true ->
           check_player_condition(Condition, Player);
       false ->
           {false, ?ERRCODE(err153_guild_lv), Player}
    end;
%% 不处理
check_player_condition([{extra_quota, _ExtraQuotaType, _Data}|Condition], Player) ->
    check_player_condition(Condition, Player);
check_player_condition([_ | _Condition], _Player) ->
    % check_player_condition(Condition, Player).
    {false, ?FAIL}.

check_role_attr([], _, _) -> true;
check_role_attr([{_, 0}|NeedAttr], RoleAttrL, Res) ->
    check_role_attr(NeedAttr, RoleAttrL, Res);
check_role_attr([{AttrKey, AttrValue}|NeedAttr], RoleAttrL, Res) ->
    case lists:keyfind(AttrKey, 1, RoleAttrL) of
        {_, RoleValue} when RoleValue >= AttrValue ->
            check_role_attr(NeedAttr, RoleAttrL, Res);
        _ ->
            false
    end.

%% 玩家id, goods_key, count_id,  quota_type
%% 获取已经使用的次数  mod_daily  mod_week  mod_counter
get_buyed_time(RoleId, GoodsKey, CounterId, QuotaType) ->
    #shop{shop_type = ShopType} = data_shop:get_shop_config(GoodsKey),
    {SubModType, CountType} =
        case CounterId == 0 of
            true -> {?MOD_SHOP_NEW_GOODS, GoodsKey};
            false ->
                if
                    ShopType == ?SHOP_EUDEMONS ->
                        {?DEFAULT_SUB_MODULE, CounterId};
                    true ->
                       {?MOD_SHOP_GOODS, CounterId}
                end

        end,
    case QuotaType of
        ?QUATO_TYPE_NONE -> 0;
        ?QUATO_TYPE_DAILY ->
            mod_daily:get_count(RoleId, ?MOD_SHOP, SubModType, CountType);
        ?QUATO_TYPE_WEEK ->
            mod_week:get_count(RoleId, ?MOD_SHOP, SubModType, CountType);
        ?QUATO_TYPE_LIFE ->
            mod_counter:get_count(RoleId, ?MOD_SHOP, SubModType, CountType);
        _ -> 0
    end.

%% 添加购买的次数
add_buyed_time(RoleId, GoodsKey, CounterId, QuotaType, Num) ->
    #shop{shop_type = ShopType} = data_shop:get_shop_config(GoodsKey),
    {SubModType, CountType} =
        case CounterId == 0 of
            true -> {?MOD_SHOP_NEW_GOODS, GoodsKey};
            false ->
                if
                    ShopType == ?SHOP_EUDEMONS ->
                        {?DEFAULT_SUB_MODULE, CounterId};
                    true ->
                        {?MOD_SHOP_GOODS, CounterId}
                end
        end,
    case QuotaType of
        ?QUATO_TYPE_NONE -> ok;
        ?QUATO_TYPE_DAILY -> mod_daily:plus_count(RoleId, ?MOD_SHOP, SubModType, CountType, Num);
        ?QUATO_TYPE_WEEK -> mod_week:plus_count(RoleId, ?MOD_SHOP, SubModType, CountType, Num);
        ?QUATO_TYPE_LIFE -> mod_counter:plus_count(RoleId, ?MOD_SHOP, SubModType, CountType, Num);
        _ -> ok
    end.


%%convert_cost_errcode(?SHOP_3V3, _) -> ?ERRCODE(err650_hornor_limit);
convert_cost_errcode(_, Code) -> Code.

%%  判断职业是否可见
is_exist(_I, []) -> false;
is_exist(I, [H | T]) ->
    case I == H of
        true ->
            true;
        _ ->
            is_exist(I, T)
    end.

get_real_quota_num(_QuotaType, QuotaNum, Condition, Player) ->
    case QuotaNum == 0 of
        true -> %% 无限购
            QuotaNum;
        _ ->
            case lists:keyfind(extra_quota, 1, Condition) of
                {extra_quota, ExtraQuotaType, Data} ->
                    ExtraQuotaNum = get_real_quota_num_do(ExtraQuotaType, Data, Player),
                    ExtraQuotaNum + QuotaNum;
                _ ->
                    QuotaNum
            end
    end.

get_real_quota_num_do(vip, Data, Player) ->
    #player_status{figure = #figure{vip = VipLv}} = Player,
    case lists:reverse(lists:keysort(1, [{NeedVipLv, Num} ||{NeedVipLv, Num} <- Data, VipLv>=NeedVipLv])) of
        [{_, AddNum}|_] -> AddNum;
        _ ->
            0
    end;
get_real_quota_num_do(_, _Data, _Player) ->
    0.