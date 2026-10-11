%% ---------------------------------------------------------------------------
%% @doc lib_constellation_forge_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/6   星宿锻造接口， 提供个星宿装备调用
%%%% @deprecated
%%%% ---------------------------------------------------------------------------
-module(lib_constellation_forge_api).

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("constellation_forge.hrl").
-include("constellation_equip.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").

%% API
-compile([export_all]).

%% 登陆，完善加载锻造信息
%% return NewPS
login(PS, GoodsDict) ->
    #player_status{id = RoleId, constellation = Constellation} = PS,
    NewConstellation = lib_constellation_forge:login(RoleId, GoodsDict, Constellation),
    PS#player_status{constellation = NewConstellation}.
%% 登陆，加载每一个item
login_item(RoleId, Goodict, ConstellationItem, ForgeList, SMasterList, EMasterList) ->
    case catch lib_constellation_forge:load_forge_info(RoleId, Goodict, ConstellationItem, ForgeList, SMasterList, EMasterList) of
        {'EXIT', Error} ->
            ?ERR("login_item: ~p~n", [Error]),
            ConstellationItem;
        NewConstellationItem  ->
            NewConstellationItem
    end.


%% 获取锻造部分所以添加的属性
%% 不包括物品 other 下的屬性
get_forge_attr(ConstellationItem) ->
    #constellation_item{
        strength_master_attr = SMasterAttr,
        enchantment_master_attr = EMasterAttr,
        strength_buff_attr = SBuffAttr,
        strength_attr = StrengthAttr,
        evolution_attr = EvolutionAttr,
        enchantment_attr = EnchantmentAttr,
        spirit_attr = SpiritAttr
    } = ConstellationItem,
%%    ?MYLOG("zh_attr", "@@@SMasterAttr ~p ~n EMasterAttr ~p ~n SBuffAttr ~p ~n StrengthAttr ~p ~n EvolutionAttr ~p ~n EnchantmentAttr ~p ~n SpiritAttr ~p ~n",
%%        [SMasterAttr, EMasterAttr, SBuffAttr, StrengthAttr, EvolutionAttr, EnchantmentAttr, SpiritAttr]),
    ItemAttr = lib_player_attr:add_attr(list, [SMasterAttr, EMasterAttr, SBuffAttr, StrengthAttr, EvolutionAttr, EnchantmentAttr, SpiritAttr]),
    ItemAttr.

%% 每次更新装备调用
%% 更新ConstellationItem
change_constellation(_RoleId, GoodsInfo, ConstellationItem, EquipType, equip) ->
    #constellation_item{equip_list = EquipList} = ConstellationItem,
    #goods{other = #goods_other{stren = EvolutionLv}, id = EquipId, subtype = Pos} = GoodsInfo,
    ConstellationForge =
        case lists:keyfind(Pos, #constellation_forge.pos, EquipList) of
            #constellation_forge{} = ConstellationForg -> ConstellationForg;
            false ->
                #constellation_forge{}
        end,
    {NewELv, NewEAttr} =
        case data_constellation_forge:get_evolution_cfg(EquipType, Pos, EvolutionLv) of
            #base_constellation_evolution{attr = EAttr} -> {EvolutionLv, EAttr};
            [] -> {EvolutionLv, []}
        end,
    NewConstellationForge = ConstellationForge#constellation_forge{equip_id = EquipId, pos = Pos, evolution_attr = NewEAttr, evolution_lv = NewELv},
    NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
    EvolutionAttr = lib_constellation_forge:cal_forge_attr(NewEquipList, evolution),
    NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, evolution_attr = EvolutionAttr},
    cal_all_evolution_attr(NewConstellationItem);

change_constellation(_RoleId, GoodsInfo, ConstellationItem, _EquipType, unequip) ->
    #constellation_item{equip_list = EquipList} = ConstellationItem,
    #goods{subtype = Pos} = GoodsInfo,
    ConstellationForge = lists:keyfind(Pos, #constellation_forge.pos, EquipList),
    NewConstellationForge = ConstellationForge#constellation_forge{equip_id = 0, evolution_attr = [], evolution_lv = 0},
    NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
    EvolutionAttr = lib_constellation_forge:cal_forge_attr(NewEquipList, evolution),
    NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, evolution_attr = EvolutionAttr},
    cal_all_evolution_attr(NewConstellationItem).

%% 获取指定装备类型（星座）装备强化总等级
get_constellation_item_strength_lv(Constellation, EquipType) ->
    #constellation_status{constellation_list = ConstellationList} = Constellation,
    case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        false -> 0;
        #constellation_item{equip_list = EquipList} ->
            F = fun(#constellation_forge{strength_lv = StrengthLv}, SumLv) ->
                    SumLv + StrengthLv
                end,
            lists:foldl(F, 0, EquipList)
    end.

%% 获取装备属性详情
get_forge_attr_detail(ConstellationItem, Pos) ->
    #constellation_item{equip_list = EquipList} = ConstellationItem,
    ConstellationForge = ulists:keyfind(Pos, #constellation_forge.pos, EquipList, #constellation_forge{}),
    #constellation_forge{
        strength_attr = StrenAttr,
        evolution_attr = EvoluAttr,
        enchantment_attr = EnchaAttr,
        spirit_attr = SpiritAttr
    } = ConstellationForge,
    {StrenAttr, EvoluAttr, EnchaAttr, SpiritAttr}.

%% 获取item内 总的进化属性
%% 每次装备更新都需要调用
cal_all_evolution_attr(ConstellationItem) ->
    #constellation_item{enchantment_attr = EnchaMaster, id = EquipType, strength_attr = OldStrengthAttr, evolution_attr = OldEvolutionAttr}
        = ConstellationItem,
    {_, _, NewEvolutionAttr} =
        lib_constellation_forge:get_enchantment_master_attr(EnchaMaster, EquipType, 0, OldStrengthAttr, OldEvolutionAttr),
    ConstellationItem#constellation_item{evolution_attr = NewEvolutionAttr}.