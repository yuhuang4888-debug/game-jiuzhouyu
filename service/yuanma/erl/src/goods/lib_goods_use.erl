%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2012-1-3
%% Description: 物品他用类，物品进程内调用
%% --------------------------------------------------------
-module(lib_goods_use).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("buff.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("jjc.hrl").
-include("vip.hrl").
-include("guild.hrl").
-include("fiesta.hrl").
%% -include("sky_war.hrl").
%% -include("guild_act.hrl").

%%----------------------------------------------------------------
%% @dco 使用物品
%% -spec use_goods(PlayerStatus, Status, GoodsInfo, GoodsNum) ->
%%          {ok, NewPlayerStatus, NewStatus, NewNum} | {fail, ERRCODE}
%% when
%%          PlayerStatus|NewPlayerStatus :: #player_status{} 玩家记录
%%          Status|NewStatus             :: #goods_status{}  物品进程状态
%%          GoodsInfo                    :: #goods{}         物品信息
%%          GoodsNum                     :: integer()        数量
%% @end
%%---------------------------------------------------------------------------
use_goods(PlayerStatus, Status, GoodsInfo, GoodsNum) ->
    case GoodsInfo#goods.type of
        ?GOODS_TYPE_OBJECT -> %% 特殊类
            case use36(PlayerStatus, GoodsInfo, GoodsNum, Status) of
                {ok, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, NewGoodsStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [NewGoodsStatus, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                nothing ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {nothing, PlayerStatus, NewStatus, NewNum};
                _Error ->
                    _Error
            end;

        ?GOODS_TYPE_GAIN -> %% 增益类
            case use37(PlayerStatus, Status, GoodsInfo, GoodsNum) of
                {ok, only, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, 1]),
                    NewNum = GoodsInfo#goods.num - 1,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, NewStatus1} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [NewStatus1, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, NewStatus1, UsedNum} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [NewStatus1, UsedNum]),
                    NewNum = GoodsInfo#goods.num - UsedNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {fail, Errcode} ->
                    {fail, Errcode};
                _Error ->
                    skip
            end;

        ?GOODS_TYPE_PROPS -> %% 道具类
            case use38(PlayerStatus, Status, GoodsInfo, GoodsNum) of
                {ok, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, UsedNum} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, UsedNum]),
                    NewNum = GoodsInfo#goods.num - UsedNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {use_designtion_good, NewPlayerStatus, Coin, UsedNum} -> %% 使用称号获得铜币
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, UsedNum]),
                    NewNum = GoodsInfo#goods.num - UsedNum,
                    {use_designtion_good, NewPlayerStatus, NewStatus, NewNum, Coin};
                {fireworks, NewPlayerStatus, NewStatus, GiveList, Produce} ->
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {fireworks, NewPlayerStatus, NewStatus, NewNum, GiveList, Produce};
                {ok, NewPlayerStatus, NewStatus, NewNum} ->
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {false, ErrorCode} ->
                    {fail, ErrorCode};
                {fail, ErrorCode} ->
                    {fail, ErrorCode};
                _Error ->
                    skip
            end;
        ?GOODS_TYPE_LOVE -> %% 婚姻类
            case use40(PlayerStatus, Status, GoodsInfo, GoodsNum) of
                {ok, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, UsedNum} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, UsedNum]),
                    NewNum = GoodsInfo#goods.num - UsedNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, NewStatus, NewNum} ->
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {false, ErrorCode} ->
                    {fail, ErrorCode};
                {fail, ErrorCode} ->
                    {fail, ErrorCode};
                _Error ->
                    skip
            end;

        ?GOODS_TYPE_GUILD -> %% 帮派类
            case use42(PlayerStatus, GoodsInfo, GoodsNum, Status) of
                {ok, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus, NewGoodsStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [NewGoodsStatus, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                nothing ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {nothing, PlayerStatus, NewStatus, NewNum};
                _Error ->
                    _Error
            end;
        %% VIP类
        ?GOODS_TYPE_VIP ->
            case use52(PlayerStatus, Status, GoodsInfo, GoodsNum) of
                {ok, only, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, 1]),
                    NewNum = GoodsInfo#goods.num - 1,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {ok, NewPlayerStatus} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [Status, GoodsNum]),
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    {ok, NewPlayerStatus, NewStatus, NewNum};
                {fail, Errcode} ->
                    {fail, Errcode};
                {false, Errcode} ->
                    {fail, Errcode};
                _Error ->
                    skip
            end;
        _ ->
            {fail, ?ERRCODE(err150_type_err)}
    end.


%%--------------------------------------------------------------------
%% @doc 使用增益类物品
%% -spec use37(Ps, Gs, GoodsInfo, GoodsNum) -> {ok, NewPs, NewGs}|{fail, Errcode}
%% @end
%% ---------------------------------------------------------------------
use37(Ps, Gs, GoodsInfo, GoodsNum) ->
    #goods{goods_id = GoodsTypeId, subtype = SubType, bind = _Bind} = GoodsInfo,
    case SubType of
        %% %% 铜钱卡
        %% ?GOODS_SUBTYPE_COIN ->
        %%     Coin = data_goods:get_effect_val(GoodsTypeId, coin),
        %%     NewCoin = Coin * GoodsNum,
        %%     NewPs = case Bind > 0 of
        %%                 true ->
        %%                     NewPs1 = lib_goods_util:add_money(Ps, NewCoin, coin),
        %%                     lib_log_api:log_produce(goods_use, coin, Ps, NewPs1, ""),
        %%                     NewPs1;
        %%                 false ->
        %%                     NewPs1 = lib_goods_util:add_money(Ps, NewCoin, coin),
        %%                     lib_log_api:log_produce(goods_use, coin, Ps, NewPs1, ""),
        %%                     NewPs1
        %%             end,
        %%     {ok, NewPs, Gs};
        %% %% 绑定铜钱
        %% ?GOODS_SUBTYPE_BCOIN ->
        %%     Bcoin = data_goods:get_effect_val(GoodsTypeId, coin),
        %%     NewBcoin = Bcoin * GoodsNum,
        %%     NewPs = lib_goods_util:add_money(Ps, NewBcoin, coin),
        %%     lib_log_api:log_produce(goods_use, coin, Ps, NewPs, ""),
        %%     {ok, NewPs, Gs};
        %% ?GOODS_SUBTYPE_GCOIN ->
        %%     GCoin = data_goods:get_effect_val(GoodsTypeId, gcoin),
        %%     NewGCoin = GCoin * GoodsNum,
        %%     NewPs = lib_goods_util:add_money(Ps, NewGCoin, gcoin, goods_use, ""),
        %%     {ok, NewPs, Gs};
        ?GOODS_GAIN_SUBTYPE_GOLD ->
            Gold = data_goods:get_effect_val(GoodsTypeId, gold),
            NewGold = Gold * GoodsNum,
            NewPs = lib_goods_util:add_money(Ps, NewGold, gold, goods_use, ""),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_SUBTYPE_BGOLD ->
            Gold = data_goods:get_effect_val(GoodsTypeId, bgold),
            NewGold = Gold * GoodsNum,
            NewPs = lib_goods_util:add_money(Ps, NewGold, bgold, goods_use, ""),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_STYPE_EXP_PILL -> %% 经验丹
            #player_status{figure = #figure{lv = RoleLv, turn = Turn, career = Career, sex = Sex}, exp = RoleExp} = Ps,
            F = fun(_Index, {AccRoleLv, AccRoleExp, AccExp}) ->
                SingleExp0 =
                    case data_goods_effect:get_goods_dynamic_exp(GoodsTypeId, AccRoleLv) of
                        0 -> data_goods:get_effect_val(GoodsTypeId, exp);
                        V -> V
                    end,
                {SingleExp, _} = lib_player:calc_exp_add_and_ratio(Ps, ?ADD_EXP_GOODS, SingleExp0),
                LvMaxExp = data_exp:get(AccRoleLv),
                case data_exp:get_all_lv() of
                    [MaxLv|_] -> skip;
                    _ -> MaxLv = 0
                end,
                ExpSum = SingleExp + AccRoleExp,
                CanLv = lib_reincarnation:is_can_lv(Career, Sex, Turn, AccRoleLv),
                if
                    (AccRoleLv >= MaxLv orelse ExpSum < LvMaxExp) orelse CanLv == false ->
                        {AccRoleLv, ExpSum, AccExp + SingleExp};
                    true ->
                        LeftExp = ExpSum - LvMaxExp,
                        {AccRoleLv + 1, LeftExp, AccExp + SingleExp}
                end
            end,
            {_, _, Exp} = lists:foldl(F, {RoleLv, RoleExp, 0}, lists:seq(1, GoodsNum)),
            NewPs = lib_player:add_exp(Ps, Exp, ?ADD_EXP_GOODS, []),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_STYPE_EXP_WATER -> %% 经验药水
            case lib_goods_buff:use_buff_goods(Ps, GoodsInfo, GoodsNum) of
                {ok, NewPs} -> {ok, NewPs, Gs};
                Res -> Res
            end;
        ?GOODS_GAIN_SUBTYPE_CURRENCY ->
            AddCurrency =
                case data_goods:get_effect_val(GoodsTypeId, currency) of
                    0 -> [];
                    V -> V
                end,
            Reward = [{?TYPE_CURRENCY, TemGoodsTypeId, GoodsNum * Num}|| {TemGoodsTypeId, Num} <- AddCurrency],
            NewPs = lib_goods_api:send_reward(Ps, Reward, goods_use, 0),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_SUBTYPE_CONTRACT_CHALLENGE ->
            %% 处理契约挑战boos增益卡
            case data_goods:get_effect_val(GoodsTypeId, effect_time) of
                {0,0} -> {ok, Ps, Gs};
                EffectCustom ->
                    CAttr = data_goods:get_effect_val(GoodsTypeId, cattr),
                    ModTimes = data_goods:get_effect_val(GoodsTypeId, mod_times),
                    case lib_contract_challenge:use_contract_card(Ps, GoodsTypeId, EffectCustom, CAttr, ModTimes) of
                        {true, NewPs} ->
                            {ok, NewPs, Gs};
                        _ -> {fail, ?FAIL}
                    end
            end;
        ?GOODS_GAIN_SUBTYPE_GUILD_PRESTIGE ->
            %% 声望卡
            case data_goods:get_effect_val(GoodsTypeId, prestige) of
                [{PrestigeGoodsId, Num}|_] ->
                    #player_status{id = RoleId} = Ps,
                    case mod_guild_prestige:use_limit(RoleId, GoodsTypeId) of
                        ok ->
                            AddNum = GoodsNum * Num,
                            mod_guild_prestige:add_prestige([RoleId, goods_use, PrestigeGoodsId, AddNum, GoodsTypeId]),
                            {ok, Ps, Gs};
                        {ok, Left} ->
                            MaxCostNum = umath:ceil(Left / Num),
                            UsedNum = case GoodsNum >= MaxCostNum of
                                true -> MaxCostNum; _ -> GoodsNum
                            end,
                            AddNum = UsedNum * Num,
                            mod_guild_prestige:add_prestige([RoleId, goods_use, PrestigeGoodsId, AddNum, GoodsTypeId]),
                            {ok, Ps, Gs, UsedNum};
                        {fail, Res} ->
                            {fail, Res}
                    end;
                _ -> {fail, ?MISSING_CONFIG}
            end;
        ?GOODS_GAIN_SUBTYPE_GUILD_DONATE ->
            %%
            case data_goods:get_effect_val(GoodsTypeId, guild_donate) of
                Num when Num > 0 ->
                    #player_status{id = RoleId} = Ps,
                    AddNum = GoodsNum * Num,
                    mod_guild:add_donate(RoleId, AddNum, goods_use, ""),
                    {ok, Ps, Gs};
                _ -> {fail, ?MISSING_CONFIG}
            end;
        ?GOODS_GAIN_SUBTYPE_LEVEL_UP_CARD ->
            #player_status{figure = #figure{lv = Lv}, exp = OldExp} = Ps,
            %%
            F = fun(_Index, {AccRoleLv, AccRoleExp, AccExp}) ->
                case data_goods:get_effect_val(GoodsTypeId, level_up) of
                    {LevelUpper, ExpAdd1} ->
                        case AccRoleLv < LevelUpper of
                            true ->
                                ExpLimit = data_exp:get(AccRoleLv),
                                {AccRoleLv + 1, AccRoleExp, ExpLimit + AccExp};
                            _ ->
                                {AccRoleLv, AccRoleExp, ExpAdd1 + AccExp}
                        end;
                    _ -> {AccRoleLv, AccRoleExp, AccExp}
                end
            end,
            {_, _, AllExpAdd} = lists:foldl(F, {Lv, OldExp, 0}, lists:seq(1, GoodsNum)),
            % 异步加经验为了满足客户端的处理逻辑
            lib_player:apply_cast(Ps#player_status.id, ?APPLY_CAST_SAVE, lib_player, add_exp, [AllExpAdd, ?ADD_EXP_GOODS, []]),
            %NewPs = lib_player:add_exp(Ps, AllExpAdd, ?ADD_EXP_GOODS, []),
            {ok, Ps, Gs};
        ?GOODS_GAIN_SUBTYPE_DECORATION_BOSS ->
            lib_decoration_boss:use_buff_card(Ps, GoodsTypeId);
        ?GOODS_GAIN_SUBTYPE_ZEN_SOUL ->     %% 战魂卡
            case lib_goods_buff:use_buff_goods(Ps, GoodsInfo, GoodsNum) of
                {ok, NewPs} -> {ok, NewPs, Gs};
                Res -> Res
            end;
        ?GOODS_GAIN_SUBTYPE_FIESTA_EXP -> % 祭典经验
            ExpAdd1 = data_goods:get_effect_val(GoodsTypeId, fiesta_exp),
            ExpAdd2 = ExpAdd1 * GoodsNum,
            NewPs = lib_fiesta:add_fiesta_exp(ExpAdd2, Ps),
            lib_fiesta:send_fiesta_info(NewPs),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_SUBTYPE_FIESTA_BUFF -> % 祭典增益卡
            {ok, NewPs} = lib_fiesta_api:use_buff_goods(Ps, GoodsInfo, GoodsNum),
            {ok, NewPs, Gs};
        ?GOODS_GAIN_SUBTYPE_LOVE_NUM -> % 恩爱值道具
            case lib_marriage:is_single(Ps) of
                true ->
                    {fail, ?ERRCODE(err172_marriage_life_not_marry)};
                false ->
                    LoveNum = data_goods:get_effect_val(GoodsTypeId, love_num),
                    TotalLoveNum = LoveNum * GoodsNum,
                    lib_marriage:add_love_num(Ps#player_status.id, TotalLoveNum),
                    {ok, Ps, Gs}
            end;
        _ ->
            {fail, ?ERRCODE(err150_type_err)}
    end.

%%--------------------------------------------------------
%% @doc 道具类物品使用
%% use38(PlayerStatus, GoodsInfo, GoodsNum) -> {ok, PlayerStatus} | {fail, ?ErrCode}
%% @end
%%--------------------------------------------------------
use38(PlayerStatus, _Status, GoodsInfo, GoodsNum) ->
    #goods{goods_id = GoodsTypeId, subtype = SubType} = GoodsInfo,
    case SubType of
        ?GOODS_PROPS_STYPE_OFFCARD -> %% 离线时间卡
            lib_afk:use_afk_goods(PlayerStatus, GoodsInfo, GoodsNum);
        ?GOODS_PROPS_STYPE_RED_NAME -> %% 洗恶卡
            lib_player_record:use_red_name_goods(PlayerStatus);
        ?GOODS_PROPS_STYPE_WORLD_BOSS_TIRED -> %% 世界boss疲劳卡
            lib_boss:use_boss_tired_goods(PlayerStatus, GoodsTypeId, GoodsNum);
        ?GOODS_PROPS_STYPE_ACT ->  %% 活动道具
            lib_fireworks_act:use_fireworks(PlayerStatus, _Status, GoodsInfo, GoodsNum);
        % ?GOODS_PROPS_STYPE_PICTURE ->
        %   lib_player:use_picture_goods(PlayerStatus, _Status, GoodsInfo, GoodsNum);
        ?GOODS_PROPS_STYPE_LEVEL_UP ->  %% 外形直升丹
            lib_mount:direct_level_up(PlayerStatus, GoodsInfo, GoodsNum);
        ?GOODS_PROPS_STYPE_DUNGEON ->
            lib_dungeon:use_dungeon_count_goods(PlayerStatus, GoodsTypeId, GoodsNum);
        ?GOODS_PROPS_STYPE_PROTECT ->
            lib_protect:use_protect_goods(PlayerStatus, GoodsTypeId, GoodsNum);
        ?GOODS_PROPS_STYPE_DECORATION_BOSS ->
            lib_decoration_boss:use_count_goods(PlayerStatus, GoodsTypeId, GoodsNum);
        ?GOODS_PROPS_STYPE_HI ->
            lib_hi_point_api:use_hi_goods(PlayerStatus, GoodsTypeId, GoodsNum),
            {ok, PlayerStatus};
        ?GOODS_PROPS_STYPE_MASK ->
            lib_mask_role:use(PlayerStatus, _Status, GoodsInfo, GoodsNum);
        ?GOODS_PROPS_STYPE_PREMIUM_FIESTA ->
            NewPS = lib_fiesta:activate_premium_fiesta_prop(?PREMIUM_FIESTA2, PlayerStatus),
            {ok, NewPS};
        ?GOODS_PROPS_STYPE_REINCARNATION ->
            NewPS = lib_reincarnation:use_turn_prop(PlayerStatus, GoodsInfo, GoodsNum),
            {ok, NewPS};
        _ ->
            {fail, ?ERRCODE(err150_type_err)}
    end.

%%--------------------------------------------------------
%% @doc 婚姻物品使用
%% use40(PlayerStatus, GoodsInfo, GoodsNum) -> {ok, PlayerStatus} | {fail, ?ErrCode}
%% @end
%%--------------------------------------------------------
use40(PlayerStatus, Status, GoodsInfo, GoodsNum) ->
    #goods{goods_id = _GoodsTypeId, subtype = SubType} = GoodsInfo,
    case SubType of
        ?GOODS_SUBTYPE_MARRIAGE_RING -> %% 离线时间卡
            lib_marriage:use_ring_goods(PlayerStatus, Status, GoodsInfo, GoodsNum);
        _ ->
            {fail, ?ERRCODE(err150_type_err)}
    end.

%%--------------------------------------------------------
%% @doc 帮派类物品使用
%% use42(PlayerStatus, GoodsInfo, GoodsNum, _Status) -> {ok, PlayerStatus} | {fail, ?ErrCode}
%% @end
%%--------------------------------------------------------
use42(PlayerStatus, GoodsInfo, GoodsNum, _Status) ->
    case GoodsInfo#goods.subtype of
        ?GOODS_SUBTYPE_GDONATE_ITEM -> %% 帮贡道具
            case GoodsInfo#goods.goods_id of
                42020001 ->
                    mod_guild:add_donate(PlayerStatus#player_status.id, 1000 * GoodsNum, goods_use, "use_goods:42020001"),
                    {ok, PlayerStatus};
                _ -> {fail, ?ERRCODE(err150_type_err)}
            end;
        ?GOODS_SUBTYPE_RED_ENVELOPE -> %% 公会红包
            #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = PlayerStatus,
            case GuildId == 0 of
                true ->
                    {fail, ?ERRCODE(err400_not_join_guild)};
                false ->
                    case lib_red_envelopes:use_goods_send_red_envelopes(GoodsInfo#goods.goods_id, GuildId, RoleId) of
                        true -> {ok, PlayerStatus};
                        {false, ErrCode} -> {fail, ErrCode}
                    end
            end;
        _ ->
            {fail, ?ERRCODE(err150_type_err)}
    end.

%%-----------------------------------------------------------------------
%% @doc 使用特殊类物品
%% -spce use36(PlayStatus, GoodsInfo, GoodsNum, Status) ->
%%      {ok, NewPlayerStatus} | {fail, ErrCode}|{ok, NewPlayerStatus, NewStatus} | nothing
%% @end
%%-------------------------------------------------------------------------
use36(PlayerStatus, GoodsInfo, GoodsNum, GoodsStatus) ->
    case GoodsInfo#goods.subtype of
%%        ?GOODS_SUBTYPE_VIPCARD ->
%%            lib_vip:acti_vip(PlayerStatus, GoodsInfo);
        %% 充值卡
        ?GOODS_SUBTYPE_CHARGE_CARD when GoodsNum =:= 1 ->
            ProductId = data_goods:get_effect_val(GoodsInfo#goods.goods_id, charge_card),
            Product = lib_recharge_check:get_product(ProductId),
            #base_recharge_product{product_type = ProductType} = Product,
            Check = lib_recharge_check:check_product(ProductId),
            case {ProductType, Check} of
                %% 普通充值(含充值返利)商品由本身内部控制
                {?PRODUCT_TYPE_NORMAL, _} ->
                    case lib_recharge:pay_by_goods(PlayerStatus, Product, GoodsInfo#goods.goods_id) of
                        {fail, Res} -> {fail, Res};
                        NewPs when is_record(NewPs, player_status) -> {ok, NewPs};
                        _ -> {fail, ?FAIL}
                    end;
                {_, {false, Res}} -> {fail, Res};
                {_, {true, _Product2}} ->
                    case lib_recharge:pay_by_goods(PlayerStatus, Product, GoodsInfo#goods.goods_id) of
                        {fail, Res} -> {fail, Res};
                        NewPs when is_record(NewPs, player_status) -> {ok, NewPs};
                        _ -> {fail, ?FAIL}
                    end
            end;
        ?GOODS_SUBTYPE_BGOLD ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, GoodsNum, bgold),
            lib_log_api:log_produce(goods_use, bgold, PlayerStatus, NewPlayerStatus, ""),
            {ok, NewPlayerStatus, GoodsStatus};
        _ ->
            {fail, ?FAIL}
    end.
%%--------------------------------------------------------
%% @doc VIP类物品使用
%% -spec use28(PlayerStatus, GoodsInfo, GoodsNum) -> {ok, only, PlayerStatus} | {fail, ?ErrCode}
%%  when
%%      PlayerStatus    :: #player_status{}     玩家记录
%%      GoodsInfo       :: #goods{}             物品信息
%%      GoodsNum        :: integer()            使用数量
%%      ErrCode         :: integer()            错误码
%% @end
%%----------------------------------------------------------
use52(PlayerStatus, _Status, GoodsInfo, GoodsNum) ->
    lib_vip:use_goods(PlayerStatus, GoodsInfo, GoodsNum).