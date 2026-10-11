%%%------------------------------------------------
%%% File    : data_goods.hrl
%%% Author  : xyj
%%% Created : 2012-4-18
%%% Description: 物品常量数据和计算公式
%%%------------------------------------------------
-module(data_goods).
-compile(export_all).
-include("record.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("goods.hrl").
-include("shop.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("def_module.hrl").

get_config(Type) ->
    case Type of
        %% 装备数量
        equip_num            -> 10;
        revelation_equip_num -> 10;
        %% 全身装备      chenyiming  暂时不用守护精灵这个装备
        %%whole_12_equip_award -> [{1,0}, {2,0},{3,0},{4,0},{5,0},{6,0},{7,0},{8,0},{9,0},{10,0},{11,0}];
        whole_12_equip_award -> [{1,0}, {2,0},{3,0},{4,0},{5,0},{6,0},{7,0},{8,0},{9,0},{10,0}];
        _ -> 0
    end.

%% 交易基准价
get_base_price(GoodsId) ->
    #ets_goods_type{trade_price = TradePrice} = data_goods_type:get(GoodsId),
    WorldLv = util:get_world_lv(),
    util:term_area_value(TradePrice, 1, 2, WorldLv).

%% 单次交易数量
get_trade_num_max(GoodsId) ->
    #ets_goods_type{trade_price = TradePrice} = data_goods_type:get(GoodsId),
    WorldLv = util:get_world_lv(),
    util:term_area_value(TradePrice, 1, 3, WorldLv).

is_custom_price_goods(GTypeId) ->
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{if_custom_price = IfCustomPrice} ->
            case IfCustomPrice of
                [_PriceMin, _PriceMax, _Num] -> true;
                _ -> false
            end;
        _ -> false
    end.

get_custom_price_info(GTypeId) ->
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{if_custom_price = IfCustomPrice} ->
            case IfCustomPrice of
                [_PriceMin, _PriceMax, _Num] -> IfCustomPrice;
                _ -> [0, 0, 0]
            end;
        _ -> [0, 0, 0]
    end.

count_goods_attribute(GoodsList) when is_list(GoodsList) ->
    lists:foldl(
      fun(GoodsInfo, TotalAttrList) ->
              AttrList = count_goods_attribute(GoodsInfo),
              ulists:kv_list_plus_extra([TotalAttrList, AttrList])
      end, [], GoodsList);

count_goods_attribute(GoodsInfo) ->
    NowTime = utime:unixtime(),
    if
        GoodsInfo#goods.expire_time =:= 0 orelse GoodsInfo#goods.expire_time > NowTime ->
            %% 基础属性
            BaseAttr     = count_base_attribute(GoodsInfo),
            %% 附加属性
            AdditionAttr = count_addition_attribute(GoodsInfo),
            ulists:kv_list_plus_extra([BaseAttr, AdditionAttr]);
        true -> []
    end.

%% 装备基础属性
count_base_attribute(GoodsInfo) ->
    case data_goods_type:get(GoodsInfo#goods.goods_id) of
        #ets_goods_type{base_attrlist = BaseAttr} -> BaseAttr;
        _ -> []
    end.

%% 装备附加属性
count_addition_attribute(GoodsInfo) ->
    Addition = GoodsInfo#goods.other#goods_other.addition,
    [{AttrType, Value}||{AttrType, Value, _Color, _CombatPower}<-Addition].

%% 强化属性（所有已穿戴装备强化属性）
count_stren_attribute(SoulAttr, GoodsStatus) ->
    StrenAdd =
        case lists:keyfind(?EQUIP_STREN_ADD_RATIO, 1, SoulAttr) of
            false -> 0;
            {?EQUIP_STREN_ADD_RATIO,StrenAddRatio} ->
                StrenAddRatio/?RATIO_COEFFICIENT
        end,
    EquipLocation = GoodsStatus#goods_status.equip_location,
    F = fun({EquipPos, GoodsId}, AttrList) ->
                %EquipStren = lib_equip:get_stren(GoodsStatus, EquipPos),
                case lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict) of
                    #goods{other = #goods_other{stren = Stren}} ->
                        case data_equip:stren_lv_cfg(EquipPos, Stren) of
                            #base_equip_stren{attr_list = List} ->
                                NewList = [{AttrId,round(AttrNum * Stren * (1 + StrenAdd))} || {AttrId,AttrNum} <- List],
                                ulists:kv_list_plus_extra([AttrList, NewList]);
                            _ -> AttrList
                        end;
                    _ ->
                        AttrList
                end
        end,
    lists:foldl(F, [], EquipLocation).

%% 精炼属性（所有已穿戴装备精炼属性）
count_refine_attribute(SoulAttr, GoodsStatus) ->
    RefineAdd =
        case lists:keyfind(?EQUIP_REFINE_ADD_RATIO, 1, SoulAttr) of
            false -> 0;
            {?EQUIP_REFINE_ADD_RATIO,RefineAddRatio} ->
                RefineAddRatio/?RATIO_COEFFICIENT
        end,
    EquipLocation = GoodsStatus#goods_status.equip_location,
    RefineAwardList = GoodsStatus#goods_status.refine_award_list,
    %% 精炼全身加成百分比
    WholeStrenRatio = lib_equip:get_whole_refine_stren_ratio(RefineAwardList, ?WHOLE_AWARD_REFINE),
    F = fun({EquipPos, GoodsId}, AttrList) ->
            case lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict) of
                #goods{other = #goods_other{refine = Refine, stren = Stren}} ->
                    %% 精炼属性
                    RefineAttrList = [{AttrId, round(AttrNum * (1 + RefineAdd))} || {AttrId,AttrNum} <- get_equip_total_refine_attr(EquipPos, Refine)],
                    case data_equip:stren_lv_cfg(EquipPos, Stren) of
                        #base_equip_stren{attr_list = StrenAttrList} ->
                            %% 当前装备强化属性
                            TotalStrenAttrList = [{AttrId, round(AttrNum * Stren)} || {AttrId, AttrNum} <- StrenAttrList],
                            TotalStrenRatio = get_refine_total_stren_ratio(EquipPos, Refine),
                            %% 强化加成属性(单件加成 + 全身加成)
                            StrenAddAttrList = [{TotalStrenAttrId, round(TotalStrenAttrNum * (TotalStrenRatio + WholeStrenRatio) / ?RATIO_COEFFICIENT)} || {TotalStrenAttrId, TotalStrenAttrNum} <- TotalStrenAttrList],
                            ulists:kv_list_plus_extra([AttrList, RefineAttrList ++ StrenAddAttrList]);
                        _ ->
                            ?ERR("no stren cfg, EquipPos:~p, Stren:~p", [EquipPos, Stren]),
                            AttrList
                    end;
                _ ->
                    AttrList
            end
        end,
    lists:foldl(F, [], EquipLocation).

%% 获取当前装备位置精炼属性
get_equip_total_refine_attr(EquipPos, Refine) when Refine > 0 ->
    F = fun(CurrentRefine, Acc) ->
            case data_equip:refine_lv_cfg(EquipPos, CurrentRefine) of
                #base_equip_refine{attr_list = AttrList} ->
                    F2 = fun({AttrId, AttrNum}, Acc2) ->
                            case lists:keyfind(AttrId, 1, Acc2) of
                                {_, OldAttrNum} ->
                                    lists:keyreplace(AttrId, 1, Acc2, {AttrId, AttrNum + OldAttrNum});
                                false ->
                                    lists:keystore(AttrId, 1, Acc2, {AttrId, AttrNum})
                            end
                    end,
                    lists:foldl(F2, Acc, AttrList);
                _ ->
                    Acc
            end
    end,
    lists:foldl(F, [], lists:seq(0, Refine - 1));
get_equip_total_refine_attr(_, _) -> [].

%% 获取当前精炼等级的强化比率
get_refine_total_stren_ratio(EquipPos, CurrentRefine) when CurrentRefine > 0 ->
    F = fun(Refine, TotalStrenRatio) ->
            case data_equip:refine_lv_cfg(EquipPos, Refine) of
                #base_equip_refine{stren_ratio = StrenRatio} ->
                    TotalStrenRatio + StrenRatio;
                _ ->
                    TotalStrenRatio
            end
    end,
    lists:foldl(F, 0, lists:seq(0, CurrentRefine - 1));
get_refine_total_stren_ratio(_, _) -> 0.


%% 宝石属性（所有已穿戴装备镶嵌的宝石属性）
count_stone_attribute(GoodsStatus) ->
    EquipStoneList = GoodsStatus#goods_status.equip_stone_list,
    F = fun({EquipPos, PosStoneInfoR}, AttrList) ->
                List = do_count_stone_attribute(EquipPos, PosStoneInfoR),
                ulists:kv_list_plus_extra([AttrList, List])
        end,
    lists:foldl(F, [], EquipStoneList).

do_count_stone_attribute(EquipPos, PosStoneInfoR) ->
    #equip_stone{refine_lv = RefineLv, stone_list = StoneList} = PosStoneInfoR,
    StoneBaseAttrL = do_count_stone_attribute_helper(StoneList),
    case data_equip:get_refine_cfg(EquipPos, RefineLv) of
        #equip_stone_refine_cfg{attr = RefineAttr, overall_plus = OverPlus} ->
            StoneBaseAttrLR = lists:map(fun({Key, Val}) ->
                              case lists:member(Key, ?BASE_ATTR_LIST) of
                                  true -> {Key, round(Val + Val * OverPlus / 100)};
                                  false -> {Key, Val}
                              end
                      end, StoneBaseAttrL),
            ulists:kv_list_plus_extra([StoneBaseAttrLR, RefineAttr]);
        _ -> StoneBaseAttrL
    end.

do_count_stone_attribute_helper(StoneList) ->
    F = fun(#stone_info{gtype_id = GTypeId}, AttrList) ->
                case data_equip:get_stone_lv_cfg(GTypeId) of
                    #equip_stone_lv_cfg{attr = List} -> List ++ AttrList;
                    _ -> AttrList
                end
        end,
    StoneBaseAttrL = lists:foldl(F, [], StoneList),
    util:combine_list(StoneBaseAttrL).

count_extra_attr(Level, GoodsList) when is_list(GoodsList) ->
    {AttrlistNew, SecAttrListNew} =
        lists:foldl(
          fun(GoodsInfo, {AttrList, SecAttrList}) ->
                  {Attr, SecAttr} = count_extra_attr(Level, GoodsInfo),
                  {[Attr|AttrList], [SecAttr|SecAttrList]}
          end, {[], []}, GoodsList),
    SecAttrMap = lib_sec_player_attr:to_attr_map(SecAttrListNew),
    NewSecAttr = lib_sec_player_attr:make_attr_with_lv_add(SecAttrMap, Level),
    NewSecAttrList = lib_player_attr:to_kv_list(NewSecAttr),
    lib_player_attr:add_attr(list, [NewSecAttrList|AttrlistNew]);

count_extra_attr(Level, GoodsInfo) ->
    NowTime = utime:unixtime(),
    if
        GoodsInfo#goods.expire_time =:= 0 orelse GoodsInfo#goods.expire_time > NowTime ->
            do_count_extra_attr(Level, GoodsInfo#goods.other#goods_other.extra_attr, [], []);
        true -> {[], []}
    end.

do_count_extra_attr(Level, [{_Color, AttrId, AttrVal}|ExtraAttr], AttrList, SecAttrList) ->
    do_count_extra_attr(Level, ExtraAttr, [{AttrId, AttrVal}|AttrList], SecAttrList);
do_count_extra_attr(Level, [{_Color, AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus}|ExtraAttr], AttrList, SecAttrList) ->
    %GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, AttrBaseVal, AttrPlusInterval, AttrPlus),
    do_count_extra_attr(Level, ExtraAttr, AttrList, [{AttrId, AttrPlusInterval, {AttrBaseVal, AttrPlus}}|SecAttrList]);
do_count_extra_attr(_Level, [], AttrList, SecAttrList) -> {AttrList, SecAttrList}.

%% 洗炼属性（所有已穿戴装备的洗炼属性）
count_wash_attribute(GoodsStatus) ->
    EquipLocation = GoodsStatus#goods_status.equip_location,
    F = fun({EquipPos, _GoodsId}, AccList) when _GoodsId > 0 ->
                WashData = lib_equip:get_wash_info_by_pos(GoodsStatus, EquipPos),
                #equip_wash{attr = AttrList} = WashData,
                LastAttrList = [{AttrId, AttrVal} || {_Pos, _Color, AttrId, AttrVal} <- AttrList],
                ulists:kv_list_plus_extra([AccList, LastAttrList]);
           (_, AccList) -> AccList
        end,
lists:foldl(F, [], EquipLocation).

%% 装备基础额外属性
count_equip_base_other_attribute(WeaponL) ->
    F = fun(GoodsInfo, AccList) when GoodsInfo#goods.goods_id > 0 ->
        LastAttrList = lib_equip:get_equip_other_attr(GoodsInfo#goods.goods_id),
        ulists:kv_list_plus_extra([AccList, LastAttrList]);
        (_, AccList) -> AccList
    end,
    lists:foldl(F, [], WeaponL).

%% 计算强化战力（所有已穿戴装备强化战力）
%%count_stren_power(GoodsStatus) ->
%%    EquipLocation = GoodsStatus#goods_status.equip_location,
%%    F = fun({EquipPos, _GoodsId}, CombatPower) ->
%%                EquipStren= lib_equip:get_stren(GoodsStatus, EquipPos),
%%                case data_equip:stren_lv_cfg(EquipPos, EquipStren#equip_stren.stren) of
%%                    #base_equip_stren{combat_power = Power} -> Power + CombatPower;
%%                    _ -> CombatPower
%%                end
%%        end,
%%    lists:foldl(F, 0, EquipLocation).

%% 计算单个物品强化战力
%%count_stren_power(GoodsStatus, GoodsInfo) ->
%%    Subtype              = GoodsInfo#goods.subtype,
%%    {Stren, _Proficiency} = lib_goods_do:get_info_stren(GoodsStatus, GoodsInfo),
%%    case data_equip:stren_lv_cfg(Subtype, Stren) of
%%        #base_equip_stren{combat_power = Power} -> Power;
%%        _ -> 0
%%    end.

%% 计算附加属性战力（所有已穿戴装备的附加属性）
count_addition_power(GoodsStatus) when is_record(GoodsStatus, goods_status) ->
    #goods_status{
       dict = Dict,
       player_id = PlayerId
      } = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),
    lists:foldl(
      fun(GoodsInfo, Power) -> count_addition_power(GoodsInfo) + Power end, 0, EquipList);

%% 计算附加属性战力
count_addition_power(GoodsInfo) ->
    Addition = GoodsInfo#goods.other#goods_other.addition,
    lists:foldl(fun({_AttrType, _Value, _Color, CombatPower}, Power) -> CombatPower + Power end, 0, Addition).

%% 取装备属性列表
get_goods_attribute(_GoodsInfo, _PlayerCareer) -> [].

%% 获取物品的基础属性列表
get_base_attribute_list(_GoodsInfo) -> [].

%% 获取物品的基础属性列表 - 2014-12-23 基础属性受橙装影响
get_base_attribute_list(_GoodsInfo, _PlayerCareer) ->
    [].

%% 计算装备基础属性
%% 把其他系统附加的属性合并到基础属性中
count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, AttrL)->
    ConvertMap = #{?WEAPON_ATT => ?ATT, ?WEAPON_WRECK => ?WRECK},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap);
count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, AttrL)->
    ConvertMap = #{?ARMOR_HP => ?HP, ?ARMOR_DEF => ?DEF},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap);
count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, AttrL)->
    ConvertMap = #{?ORNAMENT_ATT => ?ATT, ?ORNAMENT_WRECK => ?WRECK},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap).

do_count_euqip_base_attr_ex(AttrL, ConvertMap) ->
    lists:foldl(
      fun({AttrId, Val}, AccL) ->
              case maps:get(AttrId, ConvertMap, false) of
                  false -> AccL;
                  ConvertId ->
                      case lists:keyfind(ConvertId, 1, AccL) of
                          {ConvertId, PreVal} ->
                              lists:keystore(ConvertId, 1, AccL, {ConvertId, PreVal * (1 + Val / ?RATIO_COEFFICIENT)});
                          _ -> AccL
                      end
              end
      end, AttrL, AttrL).

%%----------------------------------------------
%% 根据物品子类型取装备格子位置
%%----------------------------------------------

%% 装备的格子
get_equip_cell(Part) ->
    case Part of
        1 -> 1;    % 武器
        2 -> 2;    % 头盔
        3 -> 3;    % 项链
        4 -> 4;    % 衣服
        5 -> 5;    % 护符
        6 -> 6;    % 裤子
        7 -> 7;    % 手镯
        8 -> 8;    % 护腕
        9 -> 9;    % 戒子
        10 -> 10;  % 鞋子
        %11 -> 11;  % 小恶魔/小仙女
        _ -> Part
    end.

%% 物品的价格类型转成货币类型
get_price_type_to_right(PriceType)->
    case PriceType of
        ?TYPE_GOLD -> ?GOLD;
        ?TYPE_BGOLD -> ?BGOLD;
        ?TYPE_COIN -> ?COIN;
        _ -> none
    end.

%% 物品的价格类型转成货币物品id
get_price_type_to_goods_type_id(PriceType)->
    case PriceType of
        ?TYPE_GOLD -> ?GOODS_ID_GOLD;
        ?TYPE_BGOLD -> ?GOODS_ID_BGOLD;
        ?TYPE_COIN -> ?GOODS_ID_COIN;
        _ -> none
    end.

%% 获取产出类型
get_produce_type(Type) ->
    case data_produce_type:get_produce(Type) of
        0 ->
            ?ERR("unkown produce_type:~p~n", [Type]),
            0;
        Id -> Id
    end.

%% 消费类型 带有一些附加数据的
get_consume_type({Type, _}) ->
    get_consume_type(Type);

%% 获取消费类型
get_consume_type(Type) ->
    case data_produce_type:get_consume(Type) of
        0 ->
            ?ERR("unkown consume_type:~p~n", [Type]),
            0;
        Id -> Id
    end.

%% 帮派仓库升级所需材料 [铜币数, 帮派建设卡数]
get_extend_guild(GuildLevel) ->
    case GuildLevel of
        2 -> [500000, 50];
        3 -> [1000000, 100];
        4 -> [2000000, 200];
        5 -> [3000000, 300];
        6 -> [4000000, 400];
        7 -> [5000000, 500];
        8 -> [6000000, 600];
        9 -> [8000000, 800];
        10 -> [10000000, 1000];
        _ -> [0, 0]
    end.
%%=====================================================
%% 背包仓库扩展栏
%%=====================================================
get_extend_num(GoodsTypeId) ->
    case GoodsTypeId of
        222001 -> 1;    %% 1级背包栏
        222002 -> 6;    %% 6级背包栏
        222101 -> 1;    %% 1级仓库栏
        222102 -> 6;    %% 6级背包栏
        _ -> 0
    end.

%% 变身
figure_buff(_Value)-> [].


%% 获取物品效果
get_effect_val(Id, Type) ->
    case data_goods_effect:get(Id) of
        [] when Type =:= buff -> [];
        [] -> 0;
        #goods_effect{effect_list = EffectList} = Info ->
            case Type of
                exp -> get_val(Type, 1, EffectList, 0);
                coin -> get_val(Type, 1, EffectList, 0);
                gcoin -> get_val(Type, 1, EffectList, 0);
                gold -> get_val(Type, 1, EffectList, 0);
                bgold -> get_val(Type, 1, EffectList, 0);
                charge_card -> get_val(Type, 1, EffectList, 0);
                physical -> get_val(Type, 1, EffectList, 0);
                time -> Info#goods_effect.time;
                buff -> {Info#goods_effect.buff_type, Info#goods_effect.effect_list, Info#goods_effect.time, Info#goods_effect.limit_scene};
                add_times -> get_val(Type, 1, EffectList, 0);
                dun_id -> get_val(Type, 1, EffectList, 0);
                onhook_time -> get_val(Type, 1, EffectList, 0);
                % 免战保护{protect_time,{场景类型,增加的时间}}
                protect_time -> get_val(Type, 1, EffectList, {0, 0});
                currency -> get_val(Type, 1, EffectList, 0);
                effect_time -> get_val(Type, 1, EffectList, {0, 0});
                cattr -> get_val(Type, 1, EffectList, []);
                mod_times -> get_val(Type, 1, EffectList, {0, 0});
                prestige -> get_val(Type, 1, EffectList, 0);
                guild_donate -> get_val(Type, 1, EffectList, 0);
                level_up -> get_val(Type, 1, EffectList, 0);
                fiesta_exp -> get_val(Type, 1, EffectList, 0);
                love_num -> get_val(Type, 1, EffectList, 0);
                _ -> []
            end
    end.

%% 获取物品buff效果列表
get_effect_list(Id) ->
    case data_goods_effect:get(Id) of
        [] -> [];
        #goods_effect{effect_list = EffectList} ->
            EffectList
    end.

get_val(Key, Pos, List, Default) ->
    case lists:keyfind(Key, Pos, List) of
        false -> Default;
        {Key, Value} -> Value
    end.

get_part_pos(EquipType) ->
    case EquipType of
        1 -> ?MODEL_PART_WEAPON;
        6 -> ?MODEL_PART_CLOTH;
        _ -> EquipType
    end.

%% 将装备列表按武器，防具，仙器归类
classify_euqip(EquipList) ->
    Map = #{?EQUIP_TYPE_WEAPON => [], ?EQUIP_TYPE_ARMOR => [], ?EQUIP_TYPE_ORNAMENT => [], ?EQUIP_TYPE_SPECIAL => []},
    lists:foldl(fun(T, Acc) ->
                        #goods{equip_type = EquipType} = T,
                        Classification = get_equip_classification(EquipType),
                        case maps:get(Classification, Acc, false) of
                            false ->
                                Acc;
                            List ->
                                maps:put(Classification, [T|List], Acc)
                        end
                end, Map, EquipList).

get_equip_classification(EquipType) ->
    case EquipType of
        1   -> ?EQUIP_TYPE_WEAPON;
        2   -> ?EQUIP_TYPE_ARMOR;
        3   -> ?EQUIP_TYPE_ORNAMENT;
        4   -> ?EQUIP_TYPE_ARMOR;
        5   -> ?EQUIP_TYPE_ORNAMENT;
        6   -> ?EQUIP_TYPE_ARMOR;
        7   -> ?EQUIP_TYPE_ORNAMENT;
        8   -> ?EQUIP_TYPE_ARMOR;
        9   -> ?EQUIP_TYPE_ORNAMENT;
        10  -> ?EQUIP_TYPE_ARMOR;
        %%11  -> ?EQUIP_TYPE_SPECIAL;
        _ -> 0
    end.

%% 获取物品名字
get_goods_name(GoodsTypeId)->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{goods_name = Name} ->
            util:make_sure_binary(Name);
        _ -> <<>>
    end.

%% 获取物品的出售价格
get_goods_sell_price(GoodsId) ->
    case data_goods_price:get_goods_price(GoodsId) of
        #goods_price{sell_price_type = SellType, sell_price = SellPrice}
          when SellType > 0, SellPrice > 0 ->
            {SellType, SellPrice};
        _ -> {0, 0}
    end.

%% 获取物品的购买价格
get_goods_buy_price(GoodsId) ->
    case data_goods_price:get_goods_price(GoodsId) of
        #goods_price{price_type = PriceType, price = Price}
          when PriceType > 0, Price > 0 -> {PriceType, Price};
        _ -> {0, 0}
    end.

get_goods_color(GoodsTypeId) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{color = Color} ->
            Color;
        _ -> 0
    end.

get_no_cell_errcode(Location) ->
    case Location of
        ?GOODS_LOC_BAG ->
            ?ERRCODE(err150_no_cell);
        ?GOODS_LOC_EQUIP_BAG ->
            ?ERRCODE(err150_no_cell_equip_bag);
        ?GOODS_LOC_GOD_EQUIP_BAG ->
            ?ERRCODE(err150_no_cell_god_equip_bag);
        ?GOODS_LOC_STORAGE ->
            ?ERRCODE(err150_storage_no_cell);
        ?GOODS_LOC_DECORATION_BAG ->
            ?ERRCODE(err150_decoration_no_cell);
        ?GOODS_LOC_SEAL ->
            ?ERRCODE(err150_seal_no_cell);     %% 圣印、硬装
        ?GOODS_LOC_MOUNT_EQUIP_BAG ->
            ?ERRCODE(err150_mount_equip_no_cell);
        ?GOODS_LOC_MATE_EQUIP_BAG ->
            ?ERRCODE(err150_mate_equip_no_cell);
        ?GOODS_LOC_DEMONS_SKILL ->
            ?ERRCODE(err150_demons_skill_no_cell);
        ?GOODS_LOC_CONSTELLATION ->
            ?ERRCODE(err150_constellation_no_cell);  %% 星宿、圣衣
        ?GOODS_LOC_DRACONIC ->
            ?ERRCODE(err622_bag_not_enough);  %% 龙语、神祭等叫法
        ?GOODS_LOC_EUDEMONS_BAG ->
            ?ERRCODE(err150_eudemonds_bag_nocell);   %%诚邀
        ?GOODS_LOC_DRAGON ->
            ?ERRCODE(err181_bag_not_enough);   %% 神纹背包
        ?GOODS_LOC_GOD_COURT ->
            ?ERRCODE(err233_bag_not_enough);   %% 神社背包
        _ ->
            ?ERRCODE(err150_no_cell)
    end.

%% 神装保护箱数量上限，根据vip决定
get_god_bag_prot_limit(PlayerStatus) ->
    #player_status{figure = #figure{vip_type = VipType, vip = VipLv}} = PlayerStatus,
    lib_vip_api:get_vip_privilege(?MOD_GOODS, 4, VipType, VipLv).

get_equip_real_stren_level(GoodsStatus, GoodsInfo) ->
    #goods_status{equip_stren_list = EquipStrenList} = GoodsStatus,
    #goods{goods_id = GoodsTypeId, color = Color, equip_type = EquipType} = GoodsInfo,
    EquipStage = lib_equip_api:get_equip_stage(GoodsTypeId),
    Cell = data_goods:get_equip_cell(EquipType),
    MaxStrenLvLimit = data_equip:strengthen_max(EquipStage, Color, Cell),
    case lists:keyfind(Cell, 1, EquipStrenList) of
        {Cell, #equip_stren{stren = CellStrenLv}} when CellStrenLv > 0 ->
            min(MaxStrenLvLimit, CellStrenLv);
        _ ->
            0
    end.

get_equip_real_refine_level(GoodsStatus, GoodsInfo) ->
    #goods_status{equip_refine_list = EquipRefineList} = GoodsStatus,
    #goods{goods_id = GoodsTypeId, color = Color, equip_type = EquipType} = GoodsInfo,
    EquipStage = lib_equip_api:get_equip_stage(GoodsTypeId),
    Cell = data_goods:get_equip_cell(EquipType),
    MaxRefineLvLimit = data_equip:refine_max(EquipStage, Color, Cell),
    case lists:keyfind(Cell, 1, EquipRefineList) of
        {Cell, #equip_refine{refine = CellRefineLv}} when CellRefineLv > 0 ->
            min(MaxRefineLvLimit, CellRefineLv);
        _ ->
            0
    end.

get_red_equip_attr(Stage, Star, Num) ->
    RedAttrList = data_equip:get_red_equip_attr(Stage, Star),
    AttrList = [Attr || {EquipNum, Attr} <- RedAttrList, Num >= EquipNum],
    lib_player_attr:add_attr(list, AttrList).

get_red_equip_con() ->
    [
        {color, ?RED}, {stage, 5}, {star, 2}, {equip_class_type, 0},
        {equip_pos, [?EQUIP_WEAPON, ?EQUIP_PILEUM, ?EQUIP_CLOTH, ?EQUIP_TROUSERS, ?EQUIP_CUFF, ?EQUIP_SHOE]}
    ].