%% ---------------------------------------------------------------------------
%% @doc lib_constellation_equip

%% @author  xlh
%% @email
%% @since   2019/11/4
%% @deprecated   星宿装备
%% ---------------------------------------------------------------------------
-module(lib_constellation_equip).

-include ("constellation_equip.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("def_module.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-include ("common.hrl").
-include ("server.hrl").
-include ("figure.hrl").
-include ("attr.hrl").
-include ("def_fun.hrl").
-include ("constellation_forge.hrl").

-export ([
    calc_equip_dynamic_attr/2
    ,make_goods_other/2
    ,change_goods_other/1
    ,format_other_data/1
    ,item_data_for_send/1
    ,dress_on_equips/2
    ,takeoff_equips/1
    ,update_status_other_mod/5
    ,update_status/5
    ,takeoff_equips/2
    ,calc_default_addtion_and_refine/1
    ,calc_partial_power/2
    ,get_total_attr/1
    ,login/3
    ,after_login/1
    ,check_equip/6
    ,save_info/3
    ,save_other_info/7
    ,check_active/3
    ,check_decompose/1
    ,calc_decompose/4
    ,cal_equip_rating/1
    ,calc_constellation_status/2
    ,gm_add_equip/2
    ,gm_add_goods/2
    ,calc_dsgt_suit_effect/1
    ,calc_suit_effect/2
    ,count_addtion_attr/2
    ,check_before_show_tips/2
    ,check_before_show_tips/3
    ,notify_client_star/2
    ,update_status_after_compose/3
    ,save_compose/2
    ,get_role_active_constellation/1
    ,check_translate/3
    ,judge_has_star_attr/1
    ]).
% lib_constellation_equip:calc_suit_effect(1,[{2,2},{1,1}])
-export([
    find_value/4
    ,gm_check_role_info_helper/2
    ,gm_check_role_info/2
    ]).
% lib_constellation_equip:gm_check_role_info(4294967310, 46).
gm_check_role_info(RoleId, Location) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_check_role_info_helper, [Location]).
gm_check_role_info_helper(Player, Location) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    WearList = lib_goods_util:get_goods_list(Player#player_status.id, Location, GoodsDict),
    ?MYLOG("XLH", "WearList:~p~n",[WearList]),
    {ok, Player}.

gm_add_goods(RoleId, Num) ->
    GtypeIdList = data_constellation_equip:get_value(goods_for_gm),
    Fun = fun(GoodsTypeId, Acc) ->
        [{?TYPE_GOODS, GoodsTypeId, Num}|Acc]
    end,
    Reward = lists:foldl(Fun, [], GtypeIdList),
    lib_goods_api:send_reward_by_id(Reward, gm, RoleId).

gm_add_equip(Status, Page) ->
    case data_constellation_equip:get_all_equip(Page) of
        GtypeIdList when is_list(GtypeIdList) andalso GtypeIdList =/= [] -> skip;
        _ -> GtypeIdList = []
    end,
    Fun = fun(GoodsTypeId, Acc) ->
        [{?TYPE_GOODS, GoodsTypeId, 1}|Acc]
    end,
    Reward = lists:foldl(Fun, [], GtypeIdList),
    lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id).


cal_equip_rating(GoodsTypeInfo) ->
    #ets_goods_type{goods_id = GoodsTypeId, subtype = _Pos} = GoodsTypeInfo,
    {_, _, ExtraAttr} = calc_default_addtion_and_refine(GoodsTypeId),
    lib_eudemons:cal_equip_rating(GoodsTypeInfo, ExtraAttr).

%% 物品生成时，计算物品的极品属性
calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOther) ->
    #ets_goods_type{goods_id = GoodsTypeId, subtype = _Pos} = GoodsTypeInfo,
    {AddtionAttr, Refine, ExtraBaseAttr} = calc_default_addtion_and_refine(GoodsTypeId),
    BaseRating = lib_eudemons:cal_equip_rating(GoodsTypeInfo, ExtraBaseAttr),  %% 策划说基础评分不加上卓越属性
    GoodsOther#goods_other{rating = BaseRating, addition = AddtionAttr, refine = Refine}.


calc_dynamic_attr([{AttrId, AttrVal, Color, AttrType}|T], Acc, Sum) ->
    calc_dynamic_attr(T, [{AttrId, AttrVal, 0, 0, Color, AttrType}|Acc], Sum+AttrType);
calc_dynamic_attr([{AttrId, AttrVal, Level, PerAdd, Color, AttrType}|T], Acc, Sum) ->
    calc_dynamic_attr(T, [{AttrId, AttrVal, Level, PerAdd, Color, AttrType}|Acc], Sum+AttrType);
calc_dynamic_attr(_, Acc, Sum) -> {Acc, Sum}.

calc_default_addtion_and_refine(GoodsTypeId) ->
    case data_constellation_equip:get_equip_info(GoodsTypeId) of
        #base_constellation_equip{page = _Page, extra_attr = ExtraAttrCfg, extra_base_attr = ExtraAttr} ->
            {AddtionAttr, Refine} = calc_dynamic_attr(ExtraAttrCfg, [], 0),
            % ?PRINT("AddtionAttr:~p, Refine:~p,ExtraAttrCfg:~p~n",[AddtionAttr, Refine,ExtraAttrCfg]),
            {AddtionAttr, Refine, ExtraAttr};
        _ ->
            {[], 0, []}
    end.

login(RoleId, RoleLv, GoodsStatus) ->
    ConstellationIdList = data_constellation_equip:get_all_constellation(),
    StatusList = db:get_all(io_lib:format(?SQL_SELECT_CONSTELLATION, [RoleId])),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_CONSTELLATION_EQUIP, GoodsDict),
    % ?MYLOG("XLH", "EquipGoodsList:~p~n",[EquipGoodsList]),
    {ForgeList, SMasterList, EMasterList} = lib_constellation_forge:db_load_role_info(RoleId),
    Items = [
        begin
            case ulists:find(fun
                ([ConstellationId|_]) ->
                    ConstellationId =:= Id
            end, StatusList) of
                {ok, [_, State]} ->
                    NewState = State;
                _ ->
                    NewState = ?UNACTIVE
            end,
            EquipList = calc_equip_list(Id, EquipGoodsList),
            Item = #constellation_item{id = Id, pos_equip = EquipList, is_active = NewState},
            StrenItem = lib_constellation_forge_api:login_item(RoleId, GoodsDict, Item, ForgeList, SMasterList, EMasterList),
            refresh_item(RoleLv, StrenItem, GoodsDict)        end
    || Id <- ConstellationIdList],
    SumStar = lists:foldl(fun(#constellation_item{star = ItemStar}, Sum) -> Sum+ItemStar end, 0, Items),
    List = db:get_row(io_lib:format(?SQL_SELECT_CONSTELLATION_DECOMPOSE, [RoleId])),
    case List of
        [SelectColor, SelectStar, DecomposeLevel, DecomposeExp, StarMaxLevel, StarLevel] ->
            Decompose = #decompose_status{lv = DecomposeLevel, exp = DecomposeExp, star = SelectStar, color = SelectColor},
            StarStatus = #attr_star{star_level = StarLevel, max_level = StarMaxLevel, star = SumStar};
        _ ->
            Decompose = #decompose_status{},
            StarStatus = #attr_star{star = SumStar}
    end,
    % ?MYLOG("XLH","Items:~p~nDecompose:~p~n",[Items, Decompose]),
    List1 = db:get_row(io_lib:format(?SQL_SELECT_COMPOSE, [RoleId])),
    Compose = case List1 of
        [ComposeStr] -> util:bitstring_to_term(ComposeStr);
        _ -> []
    end,
    FirstConstellation = #constellation_status{constellation_list = Items, attr_star = StarStatus, decompose = Decompose, compose = Compose},
    calc_constellation_status(RoleId, FirstConstellation).

after_login(PS) ->
    #player_status{constellation = ConstellationStatus, original_attr = SumOAttr} = PS,
    NewConstellationStatus = calc_partial_power(ConstellationStatus, SumOAttr),
    PS#player_status{constellation = NewConstellationStatus}.

get_total_attr(PS) ->
    #player_status{constellation = ConstellationStatus} = PS,
    #constellation_status{total_attr = ConstellationAttr} = ConstellationStatus,
    ConstellationAttr.

%% 物品other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_CONSTELLATION, other = Other}) ->
    #goods_other{refine = Star, addition = AddtionAttr, stren = Stren, optional_data = T} = Other,
    [?GOODS_OTHER_KEY_CONSTELLATION, Stren, AddtionAttr, Star|T];

format_other_data(_) -> [].

%% 物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [Stren, AddtionAttr, Star|T]) ->
    Other#goods_other{refine = Star, addition = AddtionAttr, stren = Stren, optional_data = T}.

change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

item_data_for_send(#constellation_item{id = Page, power = Power, suit = Suit, all_attr = AttrList, is_active = Active}) ->
    NormalNum = find_value(?NORMAL_SUIT, 1, 0, Suit),
    SpecialNum = find_value(?SPECIAL_SUIT, 1, 0, Suit),
    {Page, Power, NormalNum, SpecialNum, AttrList, Active}.

takeoff_equips(EquipGoodsList) ->
    [GoodsInfo#goods{other = Other#goods_other{optional_data = []}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].

takeoff_equips(Replace, EquipGoodsList) ->
    if
        Replace == 1 ->
            [GoodsInfo#goods{other = Other#goods_other{refine = 0, addition = [], stren = 0, optional_data = []}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList];
        true ->
            takeoff_equips(EquipGoodsList)
    end.

dress_on_equips(#goods{other = Other} = GoodsInfo, ConstellationId) ->
    GoodsInfo#goods{other = Other#goods_other{optional_data = [ConstellationId]}}.

%% 调用这个计算item总属性后还要重新计算功能内真实战力
%% lib_player:count_player_attribute(NewPS) 在这行代码之后调用下
%% NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
update_status_other_mod(RoleId, ConstellationStatus, RoleLv, Item, GoodsDict) ->
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    NewItem = refresh_item(RoleLv, Item, GoodsDict),
    NewItems = lists:keystore(Item#constellation_item.id, #constellation_item.id, Items, NewItem),
    NewConstellationStatus = calc_constellation_status(RoleId, ConstellationStatus#constellation_status{constellation_list = NewItems}),
    ItemsForSend = [lib_constellation_equip:item_data_for_send(NewItem)],
    case NewConstellationStatus#constellation_status.attr_star of
        #attr_star{star = Totalstar} -> skip;
        _ -> Totalstar = 0
    end,
    {ok, BinData} = pt_232:write(23201, [Totalstar, ItemsForSend]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewConstellationStatus.

update_status(PS, ConstellationStatus, Item, GoodsDict, GoodsInfo) ->
    #constellation_status{constellation_list = Items, attr_star = _AttrStar} = ConstellationStatus,
    % OldStar = AttrStar#attr_star.star,
    OldSkillList = Item#constellation_item.passive_skills,
    OldSkillList =/= [] andalso mod_scene_agent:update(PS, [{delete_passive_skill, OldSkillList}]),
    % OldItem = lists:keyfind(Item#constellation_item.id, #constellation_item.id, Items),
    NewItem = refresh_item(PS#player_status.figure#figure.lv, PS#player_status.id, Item, GoodsDict, GoodsInfo),
    % ?MYLOG("xlh_item","Item:~p~n NewItem:~p~n",[Item,NewItem]),
    SkillList = NewItem#constellation_item.passive_skills,
    SkillList =/= [] andalso mod_scene_agent:update(PS, [{passive_skill, SkillList}]),
    NewItems = lists:keystore(Item#constellation_item.id, #constellation_item.id, Items, NewItem),
    NewConstellationStatus = calc_constellation_status(PS#player_status.id, ConstellationStatus#constellation_status{constellation_list = NewItems}),
    % NewStar = NewConstellationStatus#constellation_status.attr_star#attr_star.star,
    % NewStar =/= OldStar andalso notify_client_star(NewStar, PS#player_status.id),
    {NewConstellationStatus, NewItem}.

update_status_after_compose(PS, GoodsInfo, GoodsStatus) ->
    #goods{id = GoodsAutoId, subtype = Pos, other = #goods_other{optional_data = [ConstellationId|_]}} = GoodsInfo,
    #player_status{id = RoleId, sid = Sid, constellation = ConstellationStatus, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = Items, attr_star = AttrStar} = ConstellationStatus,
    OldStar = AttrStar#attr_star.star,
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        #constellation_item{pos_equip = EquipList} = Item ->
            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsAutoId}),
            lib_constellation_equip:change_goods_other(GoodsInfo),
            {NewConstellationStatus, _} = 
                update_status(PS, ConstellationStatus, Item#constellation_item{pos_equip = NewEquipList}, GoodsStatus#goods_status.dict, GoodsInfo),
            NewPS = PS#player_status{constellation = NewConstellationStatus},
            NewPS2 = lib_player:count_player_attribute(NewPS),
            NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
            NewStar = NewConstellation#constellation_status.attr_star#attr_star.star,
            if
                NewStar =/= OldStar ->
                    #attr_star{star_level = StarLevel, max_level = MaxLevel} = NewConstellation#constellation_status.attr_star,
                    lib_log_api:log_constellation_star(RoleId, Name, 3, NewStar, StarLevel, StarLevel, MaxLevel),
                    lib_constellation_equip:notify_client_star(NewConstellation#constellation_status.attr_star, RoleId);
                true ->
                    skip
            end,
            pp_constellation_equip:send_item(Sid, NewConstellation, ConstellationId),
            NewPS2#player_status{constellation = NewConstellation};
        _ ->
            PS
    end.
    

refresh_item(RoleLv, Item, GoodsDict) ->
    #constellation_item{id = ConstellationId, pos_equip = EquipList} = Item,
    {EquipAttr, StarSum, Suit, DsgtAttr, DsgtSuit} = calc_equip_attr(EquipList, RoleLv, ConstellationId, GoodsDict, {[],0,[],[],[]}),
    {SuitAttr, SuitSkill} = calc_suit_effect(ConstellationId, Suit),
    {DsgtSuitAttr, DsgtSkill} = calc_dsgt_suit_effect(DsgtSuit),
    SkillList = DsgtSkill ++ SuitSkill,
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_CONSTELLATION, SkillList),
    %% 更新 item
    OtherAttr = lib_constellation_forge_api:get_forge_attr(Item),
    AllAttr = lib_player_attr:add_attr(list, [SkillAttr, EquipAttr, SuitAttr, DsgtAttr, DsgtSuitAttr, OtherAttr]),
    Item#constellation_item{equip_attr = EquipAttr, suit_attr = SuitAttr, all_attr = AllAttr, star = StarSum,
        dsgt_attr = DsgtAttr, dsgt_suit_attr = DsgtSuitAttr, suit = Suit, passive_skills = SkillList, dsgt_suit = DsgtSuit}.

refresh_item(RoleLv, RoleId, Item, GoodsDict, ChangeGoods) ->
    #constellation_item{id = ConstellationId, pos_equip = EquipList} = Item,
    {EquipAttr, StarSum, Suit, DsgtAttr, DsgtSuit} = calc_equip_attr(EquipList, RoleLv, ConstellationId, GoodsDict, {[],0,[],[],[]}),
    {SuitAttr, SuitSkill} = calc_suit_effect(ConstellationId, Suit),
    {DsgtSuitAttr, DsgtSkill} = calc_dsgt_suit_effect(DsgtSuit),
    SkillList = DsgtSkill ++ SuitSkill,
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_CONSTELLATION, SkillList),
    %% 更新 item
    BaseItem = calc_new_item_other_mod(RoleId, ChangeGoods, Item, ConstellationId),
    NewItem = lib_constellation_forge:after_dress_on_evolution_callback(BaseItem, ConstellationId),
    OtherAttr = lib_constellation_forge_api:get_forge_attr(NewItem),
    AllAttr = lib_player_attr:add_attr(list, [SkillAttr, EquipAttr, SuitAttr, DsgtAttr, DsgtSuitAttr, OtherAttr]),
    % ?MYLOG("XLH_ATTR", "{SkillAttr, EquipAttr, SuitAttr, DsgtAttr, DsgtSuitAttr, OtherAttr}:~p~n",[{SkillAttr, EquipAttr, SuitAttr, DsgtAttr, DsgtSuitAttr, OtherAttr}]),
    % ?MYLOG("XLH_ATTR", "EquipList:~p,AllAttr:~p~n",[EquipList, AllAttr]),
    NewItem#constellation_item{equip_attr = EquipAttr, suit_attr = SuitAttr, all_attr = AllAttr, star = StarSum,
        dsgt_attr = DsgtAttr, dsgt_suit_attr = DsgtSuitAttr, suit = Suit, passive_skills = SkillList, dsgt_suit = DsgtSuit}.

calc_new_item_other_mod(RoleId, ChangeGoods, Item, ConstellationId) when is_record(ChangeGoods, goods) ->
    lib_constellation_forge_api:change_constellation(RoleId, ChangeGoods, Item, ConstellationId, equip);
calc_new_item_other_mod(RoleId, ChangeGoods, Item, ConstellationId) when is_list(ChangeGoods) -> 
    Fun = fun
        (GoodsInfo, TemItem) when is_record(GoodsInfo, goods) ->
            lib_constellation_forge_api:change_constellation(RoleId, GoodsInfo, TemItem, ConstellationId, unequip);
        (_, TemItem) -> TemItem
    end,
    lists:foldl(Fun, Item, ChangeGoods).


calc_decompose_attr(DecompLv) ->
    case data_constellation_equip:get_decompose_info(DecompLv) of
        #base_constellation_decompose{attr = Attr} ->
            Attr;
        _ -> []
    end.

calc_star_level_attr(StarLevel) ->
    case data_constellation_equip:get_star_info(StarLevel) of
        #base_equip_star{attr = Attr} -> Attr;
        _ -> []
    end.

%% 计算星宿装备的装备属性，套装，词缀属性，词缀套装
calc_equip_attr([{Pos, GId}|T], RoleLv, ConstellationId, GoodsDict, {Acc, StarSum, SuitAcc, DsgtAttrAcc, DsgtAcc}) ->
    case lib_goods_util:get_goods(GId, GoodsDict) of
        #goods{goods_id = GoodsTypeId, other = #goods_other{refine = Star, addition = AddtionAttr}} ->
            BaseAttr
            = case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{base_attrlist = BAttr, color = _Color} ->
                    BAttr;
                _ ->
                    _Color = 0, []
            end,
            DynamicAttr = count_addtion_attr(RoleLv, AddtionAttr),
            % ?MYLOG("XLH_ATTR","DynamicAttr:~p, AddtionAttr:~p~n", [DynamicAttr, AddtionAttr]),      
            % Acc1 = lib_player_attr:add_attr(list, [BaseAttr, DynamicAttr, Acc]),
            {Acc1, NewDsgtAttr, Suit, NewDsgtAcc}
            = case data_constellation_equip:get_equip_info(GoodsTypeId) of
                #base_constellation_equip{is_suit = IsSuit, extra_list = ExtraList, extra_base_attr = ExtraAttrCfg} ->
                    Fun = fun({AttrList, DsgtId}, {TemAttrAcc, TemDsgtAcc}) ->
                        TemNum = find_value(DsgtId, 1, 0, TemDsgtAcc),
                        {AttrList++TemAttrAcc, lists:keystore(DsgtId, 1, TemDsgtAcc, {DsgtId, TemNum+1})}
                    end,
                    {AddDsgtAttr, NewDsgtAccL} = lists:foldl(Fun, {[], DsgtAcc}, ExtraList),

                    
                    NewAcc = lib_player_attr:add_attr(list, [BaseAttr, Acc, ExtraAttrCfg]),

                    NewDsgtAttrL = lib_player_attr:add_attr(list, [AddDsgtAttr, DsgtAttrAcc]),
                    case data_constellation_equip:get_equip_type(Pos) of
                        SuitType when SuitType > 0 andalso IsSuit > 0 -> 
                            OldNum = find_value(SuitType, 1, 0, SuitAcc),
                            {NewAcc, NewDsgtAttrL, lists:keystore(SuitType, 1, SuitAcc, {SuitType, OldNum+1}), NewDsgtAccL};
                        _ ->
                            {NewAcc, NewDsgtAttrL, SuitAcc, NewDsgtAccL}
                    end;
                _ ->
                    NewAcc = lib_player_attr:add_attr(list, [BaseAttr, Acc]),
                    {NewAcc, DsgtAttrAcc, SuitAcc, DsgtAcc}
            end,
            NewAcc1 = lib_player_attr:add_attr(list, [DynamicAttr, Acc1]),
            calc_equip_attr(T, RoleLv, ConstellationId, GoodsDict, {NewAcc1, StarSum+Star, Suit, NewDsgtAttr, NewDsgtAcc});
        _ ->
            calc_equip_attr(T, RoleLv, ConstellationId, GoodsDict, {Acc, StarSum, SuitAcc, DsgtAttrAcc, DsgtAcc})
    end;
calc_equip_attr([], _, _, _, Acc) -> Acc.

calc_suit_effect(ConstellationId, Suit) ->
    Fun = fun({Type, Num}, {AttrAcc, SkillAcc}) ->
        case data_constellation_equip:get_page_info(ConstellationId) of
            #base_constellation_page{normal_suit_attr = NormalCfg, special_suit_attr = SpecialCfg} ->
                if
                    Type == ?NORMAL_SUIT ->
                        calc_effrct_core(AttrAcc, SkillAcc, NormalCfg, Num);
                    true ->
                        calc_effrct_core(AttrAcc, SkillAcc, SpecialCfg, Num)
                end;
            _ -> 
                {AttrAcc, SkillAcc}
        end
    end,
    lists:foldl(Fun, {[], []}, Suit).

calc_effrct_core(Attr, Skill, NormalCfg, Num) ->
    Fun = fun({NeedNum, Effect, Value}, {AttrAcc, SkillAcc}) when is_list(Value) andalso NeedNum =< Num ->
        if
            Effect == ?SKILL ->
                F1 = fun({Key, V}, TemAcc) ->
                    case lists:keyfind(Key, 1, TemAcc) of
                        {_, OldV} ->
                            ?IF(OldV >= V, TemAcc, lists:keystore(Key, 1, TemAcc, {Key, V}));
                        _ ->
                            lists:keystore(Key, 1, TemAcc, {Key, V})
                    end
                end,
                {AttrAcc, lists:foldl(F1, SkillAcc, Value)};
            true ->
                {Value++AttrAcc, SkillAcc}
        end;
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, {Attr, Skill}, NormalCfg).

calc_dsgt_suit_effect(DsgtSuit) ->
    Fun = fun({DsgtId, Num}, {AttrAcc, SkillAcc}) ->
        case data_constellation_equip:get_desgt_suit(DsgtId) of
            #base_attr_desgt{suit_attr = SuitAttrCfg} ->
                calc_effrct_core(AttrAcc, SkillAcc, SuitAttrCfg, Num);
            _ -> 
                {AttrAcc, SkillAcc}
        end
    end,
    lists:foldl(Fun, {[], []}, DsgtSuit).

find_value(Key, Index, Default, List) ->
    case lists:keyfind(Key, Index, List) of
        {_, Value} -> Value;
        _ -> Default
    end.

calc_constellation_status(RoleId, ConstellationStatus) ->
    #constellation_status{constellation_list = Items, attr_star = #attr_star{star_level = StarLevel, max_level = MaxLevel} = OldAttrS, 
        decompose = #decompose_status{lv = DecompLv, exp = Exp, star = Star, color = Color}} = ConstellationStatus,
    
    Fun = fun(#constellation_item{passive_skills = PassSkill, star = StarNum, all_attr = ItemSumAttrList}, {SkillAcc, StarSum, AttrSum}) ->
        {PassSkill++SkillAcc, StarSum+StarNum, [ItemSumAttrList|AttrSum]}
    end,
    {PassSkills, SumStar, TotalAttr} = lists:foldl(Fun, {[], 0, []}, Items),
    NewStarLevel = calc_new_star_level(StarLevel, MaxLevel, SumStar),
    % ?PRINT("Star{StarLevel, MaxLevel, SumStar}:~p,NewStarLevel:~p~n",[{StarLevel, MaxLevel, SumStar}, NewStarLevel]),
    DecompAttr = calc_decompose_attr(DecompLv),
    StarAttr = calc_star_level_attr(NewStarLevel),
    TotalAttr1 = ulists:kv_list_plus_extra([StarAttr, DecompAttr|TotalAttr]),
    NewTotalAttr = lib_player_attr:partial_attr_convert(TotalAttr1),
    if
        NewStarLevel == StarLevel ->
            skip;
        true ->
            lib_constellation_equip:save_other_info(RoleId, Color, Star, DecompLv, Exp, MaxLevel, NewStarLevel)
    end,
    ConstellationStatus#constellation_status{total_attr = NewTotalAttr, 
        passive_skills = PassSkills, attr_star = OldAttrS#attr_star{star = SumStar, star_level = NewStarLevel}}.

calc_partial_power(ConstellationStatus, SumOAttr) ->
    #constellation_status{total_attr = _TotalAttr, constellation_list = Items, attr_star = #attr_star{star_level = StarLevel} = OldAttrS, 
        decompose = #decompose_status{lv = DecompLv} = Decompose} = ConstellationStatus,
    
    DecompAttr = calc_decompose_attr(DecompLv),
    StarAttr = calc_star_level_attr(StarLevel),

    DecomPower = lib_player:calc_partial_power(SumOAttr, 0, DecompAttr),
    StarPower = lib_player:calc_partial_power(SumOAttr, 0, StarAttr),

    Fun = fun(#constellation_item{all_attr = ItemSumAttrList} = Item, Acc) ->
        ItemPower = lib_player:calc_partial_power(SumOAttr, 0, ItemSumAttrList),
        [Item#constellation_item{power = ItemPower}|Acc]
    end,
    NewItems = lists:foldl(Fun, [], Items),
    % ?MYLOG("XLH","NewItems:~p~n",[NewItems]),
    ConstellationStatus#constellation_status{
        constellation_list = NewItems
        ,attr_star = OldAttrS#attr_star{power = StarPower}
        ,decompose = Decompose#decompose_status{power = DecomPower}}.

calc_new_star_level(StarLevel, MaxLevel, SumStar) ->
    case data_constellation_equip:get_star_info(StarLevel) of
        #base_equip_star{star = NeedStar} ->
            if     
                NeedStar > SumStar ->
                    StarList = data_constellation_equip:get_all_star(),
                    Fun = fun(Star) ->
                        SumStar >= Star
                    end,
                    case ulists:find(Fun, lists:reverse(StarList)) of
                        {ok, LevelStar} -> 
                            case data_constellation_equip:get_level_by_satr(LevelStar) of
                                [NewLevel] -> NewLevel;
                                _ -> 0
                            end;
                        _ ->
                            0
                    end;
                NeedStar < SumStar andalso StarLevel < MaxLevel ->
                    calc_new_star_level(StarLevel+1, MaxLevel, SumStar);
                true ->
                    StarLevel
            end;
        _ ->
            if
                StarLevel == 0 andalso MaxLevel > 0 ->
                    calc_new_star_level(StarLevel+1, MaxLevel, SumStar);
                true ->
                    StarLevel
            end
    end.

calc_equip_list(CsId, EquipGoodsList) ->
    lists:foldl(fun
        (#goods{id = Id, other = #goods_other{optional_data = OData}, subtype = Pos}, Acc) ->
            case OData of
                [CsId] ->
                    [{Pos, Id}|Acc];
                _ ->
                    Acc
            end
    end, [], EquipGoodsList).

check_equip(ConstellationId, GoodsInfo, Active, IsReplace, EquipList, GoodsStatus) ->
    case Active of
        ?UNACTIVE ->
            {false, ?ERRCODE(err232_not_active)};
        _ ->
            case data_constellation_equip:get_equip_info(GoodsInfo#goods.goods_id) of
                #base_constellation_equip{page = NeedConstellationId} ->
                    case ConstellationId == NeedConstellationId of
                        true -> 
                            if
                                IsReplace == 1 ->
                                    GoodsAutoId = find_value(GoodsInfo#goods.subtype, 1, 0, EquipList),
                                    OldGoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
                                    case check_before_show_tips(OldGoodsInfo, GoodsInfo, GoodsStatus) of
                                        {true, _, _} -> true;
                                        Res -> Res
                                    end;
                                true ->
                                    true
                            end;
                        _ -> 
                            {false, ?ERRCODE(err232_can_not_equip)}
                    end;
                _ ->
                    {false, ?MISSING_CONFIG}
            end
    end.

check_translate(CostGoodsAutoId, TargetGoodsAutoId, GoodsStatus) ->
    CostGoodsInfo = lib_goods_util:get_goods(CostGoodsAutoId, GoodsStatus#goods_status.dict),
    TargetGoodsInfo = lib_goods_util:get_goods(TargetGoodsAutoId, GoodsStatus#goods_status.dict),
    if
        is_record(CostGoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        is_record(TargetGoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        true ->
            #goods{color = Color, location = Location, other = #goods_other{optional_data = Data, addition = AddtionAttr}} = TargetGoodsInfo,
            #goods{color = ColorO, other = #goods_other{addition = CostAddtionAttr}} = CostGoodsInfo,
            case judge_has_star_attr(AddtionAttr) of
                false ->
                    case judge_has_star_attr(CostAddtionAttr) of
                        true ->
                            if
                                Color > ColorO ->
                                    case Data of
                                        [ConstellationId|_] ->
                                            case data_constellation_equip:get_page_info(ConstellationId) of
                                                #base_constellation_page{} when Location == ?GOODS_LOC_CONSTELLATION_EQUIP ->
                                                    {true, CostGoodsInfo, TargetGoodsInfo, ConstellationId};
                                                _ -> 
                                                    {true, CostGoodsInfo, TargetGoodsInfo, 0}
                                            end;
                                        _ ->
                                            {true, CostGoodsInfo, TargetGoodsInfo, 0}
                                    end;
                                true ->
                                    {false, ?ERRCODE(err232_color_not_enougth_to_translate)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err232_star_not_enougth_to_translate)}
                    end;
                _ ->
                    {false, ?ERRCODE(err232_has_star_attr)}
            end
    end.

judge_has_star_attr([]) -> false;
judge_has_star_attr([{_, _, _, AttrType}|_]) when AttrType >= 1 -> true;
judge_has_star_attr([{_, _, _, _, _, AttrType}|_]) when AttrType >= 1 -> true;
judge_has_star_attr([_|AddtionAttr]) ->
    judge_has_star_attr(AddtionAttr).

check_active(ConstellationStatus, ConstellationId, GoodsDict) ->
    case data_constellation_equip:get_page_info(ConstellationId) of
        #base_constellation_page{condition = Condition} ->
            do_check_active(Condition, ConstellationStatus, GoodsDict);
        _ ->
            {false, ?MISSING_CONFIG}
    end.

do_check_active([{constellation_num, NeedConstellationId, PosType, NeedNum, NeedColor}|T], ConstellationStatus, GoodsDict) ->
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    case lists:keyfind(NeedConstellationId, #constellation_item.id, Items) of
        #constellation_item{pos_equip = EquipList} ->
            Fun = fun({Pos, GoodsAutoId}, Sum) ->
                case data_constellation_equip:get_equip_type(Pos) of
                    Type when PosType == Type ->
                        case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
                            #goods{color = Color} when Color >= NeedColor ->
                                Sum + 1;
                            _ ->
                                Sum
                        end;
                    _ ->
                        Sum
                end
                
            end,
            Num = lists:foldl(Fun, 0, EquipList),
            if
                Num >= NeedNum ->
                    do_check_active(T, ConstellationStatus, GoodsDict);
                true ->
                    {false, ?ERRCODE(err232_equip_condition_error)}
            end;
        _ ->
           {false, ?ERRCODE(err232_equip_condition_error)} 
    end;
do_check_active([{evolution_lv, NeedConstellationId, NeedLevel}|T], ConstellationStatus, GoodsDict) ->
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    case lists:keyfind(NeedConstellationId, #constellation_item.id, Items) of
        #constellation_item{pos_equip = EquipList} ->
            Fun = fun({_Pos, GoodsAutoId}, Sum) ->
                case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
                    #goods{other = #goods_other{stren = Stren}} -> %% 进化等级
                        Sum + Stren;
                    _ ->
                        Sum
                end
            end,
            SumStren = lists:foldl(Fun, 0, EquipList),
            if
                SumStren >= NeedLevel ->
                    do_check_active(T, ConstellationStatus, GoodsDict);
                true ->
                    {false, ?ERRCODE(err232_equip_condition_error)}
            end;
        _ ->
           {false, ?ERRCODE(err232_equip_condition_error)} 
    end;
do_check_active([{strength_lv, NeedConstellationId, NeedLevel}|T], ConstellationStatus, GoodsDict) ->
    Level = lib_constellation_forge_api:get_constellation_item_strength_lv(ConstellationStatus, NeedConstellationId),
    if
        Level >= NeedLevel ->
            do_check_active(T, ConstellationStatus, GoodsDict);
        true ->
            {false, ?ERRCODE(err232_equip_condition_error)}
    end;
do_check_active([_|_], _, _) ->
    {false, ?ERRCODE(config_error)};

do_check_active([], _, _) -> true.

check_decompose(Level) ->
    case data_constellation_equip:get_decompose_info(Level+1) of
        #base_constellation_decompose{} -> true;
        _ -> ?ERRCODE(err232_max_decompose_level)
    end.

calc_decompose(Exp, Level, [#goods{num = 0}|T] = List, Acc) ->
    case data_constellation_equip:get_decompose_info(Level+1) of
        #base_constellation_decompose{exp = NeedExp} -> 
            if
                Exp >= NeedExp ->
                    calc_decompose(Exp - NeedExp, Level+1, List, Acc);
                true ->
                    calc_decompose(Exp, Level, T, Acc)
            end;
        _ -> 
            calc_decompose(Exp, Level, T, Acc)
    end;
calc_decompose(Exp, Level, [], Acc) -> {Exp, Level, Acc};
calc_decompose(Exp, Level, [#goods{id = GoodsAutoId, goods_id = GoodsTypeId, num = Num} = GoodsInfo|T] = List, Acc) ->
    case data_constellation_equip:get_decompose_info(Level+1) of
        #base_constellation_decompose{exp = NeedExp} -> 
            if
                Exp >= NeedExp ->
                    calc_decompose(Exp - NeedExp, Level+1, List, Acc);
                true ->
                    case data_constellation_equip:get_equip_info(GoodsTypeId) of
                        #base_constellation_equip{decompose_exp = AddExp} ->
                            case find_value(GoodsAutoId, #goods.id, [], Acc) of
                                #goods{num = OldNum} = OldGoods ->
                                    NewAcc = lists:keystore(GoodsAutoId, #goods.id, Acc, OldGoods#goods{num = OldNum + 1});
                                _ ->
                                    NewAcc = lists:keystore(GoodsAutoId, #goods.id, Acc, GoodsInfo#goods{num = 1})
                            end,
                            if
                                Exp + AddExp >= NeedExp ->
                                    calc_decompose(Exp + AddExp - NeedExp, Level+1, [GoodsInfo#goods{num = Num - 1}|T], NewAcc);
                                true ->
                                    calc_decompose(Exp + AddExp, Level, T, NewAcc)
                            end
                    end
            end;
        _ -> 
            calc_decompose(Exp, Level, T, Acc)
    end.

notify_client_star(AttrStar, RoleId) when is_record(AttrStar, attr_star) ->
    #attr_star{power = Power, star_level = StarLevel, max_level = MaxLevel, star = Star} = AttrStar,
    {ok, BinData} = pt_232:write(23251, [StarLevel, MaxLevel, Star, Power]),
    lib_server_send:send_to_uid(RoleId, BinData);
notify_client_star(_, _) -> skip.

%% 计算成长属性
count_addtion_attr(Level, AddtionAttr) ->
    {AttrlistNew, SecAttrListNew} = count_addtion_attr(AddtionAttr, [], []),
    SecAttrMap = lib_sec_player_attr:to_attr_map(SecAttrListNew),
    NewSecAttr = lib_sec_player_attr:make_attr_with_lv_add(SecAttrMap, Level),
    NewSecAttrList = lib_player_attr:to_kv_list(NewSecAttr),
    % ?MYLOG("XLH_ATTR","AttrlistNew:~p, NewSecAttrList:~p~n", [AttrlistNew, NewSecAttrList]), 
    lib_player_attr:add_attr(list, [NewSecAttrList,AttrlistNew]).

count_addtion_attr([{AttrId, AttrVal, _Color, _AttrType}|AddtionAttr], AttrList, SecAttrList) ->
    count_addtion_attr(AddtionAttr, [{AttrId, AttrVal}|AttrList], SecAttrList);
count_addtion_attr([{AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus, _Color, _AttrType}|AddtionAttr], AttrList, SecAttrList) 
when AttrPlusInterval =/= 0 andalso AttrPlus =/= 0 ->
    count_addtion_attr(AddtionAttr, AttrList, [{AttrId, AttrPlusInterval, {AttrBaseVal, AttrPlus}}|SecAttrList]);
count_addtion_attr([{AttrId, AttrBaseVal, _, _, _Color, _AttrType}|AddtionAttr], AttrList, SecAttrList) ->
    count_addtion_attr(AddtionAttr, [{AttrId, AttrBaseVal}|AttrList], SecAttrList);
count_addtion_attr([], AttrList, SecAttrList) -> {AttrList, SecAttrList}.    


check_before_show_tips(GoodsInfo, GoodsStatus) ->
    if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        GoodsInfo#goods.type =/= ?GOODS_TYPE_CONSTELLATION ->
            {false, ?ERRCODE(err232_wrong_data)};
        true ->
            case data_goods_type:get(GoodsInfo#goods.goods_id) of
                #ets_goods_type{} = GoodsTypeInfo -> 
                    case data_constellation_equip:get_equip_info(GoodsInfo#goods.goods_id) of
                        #base_constellation_equip{} = BaseEquipCfg -> {true, BaseEquipCfg, GoodsTypeInfo};
                        _ -> 
                            {false, ?ERRCODE(missing_config)}
                    end;
                _ -> {false, ?ERRCODE(missing_config)}
            end
    end.

check_before_show_tips(#goods{color = Color, other = #goods_other{addition = Addition}} = GoodsInfo, TargetGoodsInfo, GoodsStatus) ->
    Fun1 = fun
        ({_, _, _, AttrType}, Sum) ->
            AttrType+Sum;
        ({_, _, _, _, _, AttrType}, Sum) ->
            AttrType+Sum;
        (_, Acc) -> Acc
    end,
    SumAttr = lists:foldl(Fun1, 0, Addition),
    case check_before_show_tips(GoodsInfo, GoodsStatus) of
        {true, _, _} when SumAttr >= 2 andalso Color < TargetGoodsInfo#goods.color ->
            check_before_show_tips(TargetGoodsInfo, GoodsStatus);
        Res ->
            Res
    end.

get_role_active_constellation(PS) ->
    #player_status{constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    List = [ConstellationId || #constellation_item{is_active = IsActive, id = ConstellationId} <- Items, IsActive == ?ACTIVE],
    ?IF(List == [], 0, lists:max(List)).

% ############################# db
% Color:吞噬颜色, Star:吞噬品质, Level:吞噬等级, Exp:当前吞噬经验, MaxLevel:星级大师最大星级, StarLevel:星级大师当前星级
save_other_info(RoleId, Color, Star, Level, Exp, MaxLevel, StarLevel) ->
    db:execute(io_lib:format(?SQL_REPLACE_CONSTELLATION_DECOMPOSE, [RoleId, Color, Star, Level, Exp, MaxLevel, StarLevel])).

save_info(RoleId, ConstellationId, Status) ->
    db:execute(io_lib:format(?SQL_INSERT_CONSTELLATION, [RoleId, ConstellationId, Status])).

save_compose(RoleId, Compose) ->
    db:execute(io_lib:format(?SQL_REPLACE_COMPOSE, [RoleId, util:term_to_string(Compose)])).