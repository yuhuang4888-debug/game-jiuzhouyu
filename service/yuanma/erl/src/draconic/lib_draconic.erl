%%-----------------------------------------------------------------------------
%% @Module  :       lib_draconic.erl
%% @Author  :       
%% @Email   :       
%% @Created :       2019-03-02
%% @Description:    龙语
%%-----------------------------------------------------------------------------

-module(lib_draconic).

-include("server.hrl").
-include("draconic.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("attr.hrl").

-export([
        calc_equip_dynamic_attr/2,
        cal_equip_rating /2
        ,login/3
        ,calc_over_all_rating/1
        ,check_strength/1
        ,calc_stren/3
        ,get_total_attr/1
        ,make_goods_other/2
        ,dress_on_equips/2
        ,takeoff_equips/1
        ,updata_draconic_status/2
        ,gm_add_equip/3
        ,calc_suit_info_preview/4
        ,up_equip_list_af_compose/2

        ,get_role_special_attr/1

        ,get_role_draconic/1
        ,get_role_draconic_helper/1
    ]).
% lib_draconic:get_role_draconic(4294967300).
get_role_draconic(RoleId) ->
    lib_player:apply_cast(RoleId, 2, lib_draconic, get_role_draconic_helper, []).
get_role_draconic_helper(PlayerStatus) ->
    % #player_status{id = RoleId} = PlayerStatus,
    % GoodsStatus = lib_goods_do:get_goods_status(),
    % #goods_status{dict = GoodsDict} = GoodsStatus,
    % EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC_EQUIP, GoodsDict),
    % EquipGoodsList1 = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC, GoodsDict),
    % F = fun(#goods{id = GoodsAutoId, subtype = Pos, goods_id = _GoodsTypeId}, Acc) ->
    %     [{GoodsAutoId, Pos}|Acc];
    %     (_E, Acc) -> 
    %         [_E|Acc]
    % end,
    % % GoodsTypeL = lists:foldl(F, [], EquipGoodsList),
    % GoodsTypeL1 = lists:foldl(F, [], EquipGoodsList1),
    % ?PRINT("======= GoodsTypeL1:~p~n",[GoodsTypeL1]),
    % EquipBagNum = lib_goods_api:get_cell_num(PlayerStatus, ?GOODS_LOC_DRACONIC),
    {ok, PlayerStatus}.


%% 物品生成时，计算物品的极品属性
calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOther) ->
    #ets_goods_type{goods_id = GoodsId} = GoodsTypeInfo,
    case data_draconic:get_draconic_equip_info(GoodsId) of
        #base_draconic_equip{base_attr = BaseAttr, extra_attr = ExtraAttrCfg} ->
            ExtraAttr = BaseAttr ++ ExtraAttrCfg,
            % ExtraAttr = BaseAttr,
            BaseRating = cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            % ?PRINT("BaseRating:~p~n",[BaseRating]),
            GoodsOther#goods_other{rating = BaseRating, extra_attr = []};
        _ ->
            GoodsOther
    end.

%% 获取特殊属性-- 对龙语玩法怪物的碾压属性
get_role_special_attr(PS) when is_record(PS, player_status) ->
    #player_status{draconic_status = DraconicStatus} = PS,
    #draconic_status{special_attr = SpAttr} = DraconicStatus,
    SpAttr;
get_role_special_attr(_) -> [].

%%登陆初始化
login(RoleId, _RoleLv, GoodsStatus) ->
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr, SpecialAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating, TemSpAttr}) ->
        PosItem = #draconic_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, 
                strong = Strength, rating = BaseRating, attr = ExtraAttr}, 
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_draconic:get_draconic_strong_info(Pos, Strength) of
            #base_draconic_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([StrenAttrCfg, TemStrenAttr]),
        NewSpAttr = ulists:kv_list_plus_extra([SpecialAttr, TemSpAttr]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating, NewSpAttr}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating, SpAttr} = lists:foldl(Fun1, {#{}, [], [], [], 0, []}, EquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    #draconic_status{   pos_map = PosMap,
                    equip_list = NEquipList,
                    stren_attr = StrenAttr,
                    equip_attr = AllEquipAttr,
                    suit_info = RealSuitInfo, %% {color,stage,num}
                    suit_attr = SuitAttr,
                    rating = EquipRating + SuitRating,
                    special_attr = SpAttr}.

up_equip_list_af_compose(PS, GoodsStatus) ->
    #player_status{draconic_status = DraconicStatus, id = RoleId} = PS,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr, SpecialAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating, TemSpAttr}) ->
        PosItem = #draconic_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, 
                strong = Strength, rating = BaseRating, attr = ExtraAttr}, 
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_draconic:get_draconic_strong_info(Pos, Strength) of
            #base_draconic_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([StrenAttrCfg, TemStrenAttr]),
        NewSpAttr = ulists:kv_list_plus_extra([SpecialAttr, TemSpAttr]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating, NewSpAttr}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating, SpAttr} = lists:foldl(Fun1, {#{}, [], [], [], 0, []}, EquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    % ?PRINT("================ NEquipList:~p~n",[NEquipList]),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    NewDraconicStatus = DraconicStatus#draconic_status{   
                    pos_map = PosMap,
                    equip_list = NEquipList,
                    stren_attr = StrenAttr,
                    equip_attr = AllEquipAttr,
                    suit_info = RealSuitInfo, %% {color,stage,num}
                    suit_attr = SuitAttr,
                    rating = EquipRating + SuitRating,
                    special_attr = SpAttr},
    PS#player_status{draconic_status = NewDraconicStatus}.

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, _EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    #ets_goods_type{goods_id = GoodsTypeId, base_attrlist = BaseAttr, level = Level} = GoodsTypeInfo,
    case data_draconic:get_draconic_equip_info(GoodsTypeId) of
        #base_draconic_equip{base_attr = BaseAttrCfg, extra_attr = ExtraAttrCfg} ->
            ExtraAttr = BaseAttrCfg++ExtraAttrCfg;
        _ ->
            ExtraAttr = []
    end,
    Rating = lists:foldl(fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ -> RatingTmp
        end
    end, 0, BaseAttr ++ ExtraAttr),
    round(Rating);
cal_equip_rating(_, _) -> 0.

%% 计算装备加强化积分
calc_over_all_rating(GoodsInfo) ->
    #goods_other{
        stren = Stren, rating = Rating
    } = GoodsInfo#goods.other,
    StrenPower =
            case data_draconic:get_draconic_equip_info(GoodsInfo#goods.goods_id) of
                #base_draconic_equip{strong = StrenLimit} when Stren =< StrenLimit -> 
                    case data_draconic:get_draconic_strong_info(GoodsInfo#goods.subtype, Stren) of
                        #base_draconic_strong{add_attr = StrenAttr} ->
                            TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                            cal_equip_rating(TempInfo, StrenAttr);
                        _ ->
                            0
                    end;
                #base_draconic_equip{strong = StrenLimit} when Stren > StrenLimit ->
                    case data_draconic:get_draconic_strong_info(GoodsInfo#goods.subtype, StrenLimit) of
                        #base_draconic_strong{add_attr = StrenAttr} ->
                            TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                            cal_equip_rating(TempInfo, StrenAttr);
                        _ ->
                            0
                    end;
                _ ->
                    0
            end,
    Rating + StrenPower.

%% 强化检测当前装备强化等级上限
check_strength(GoodsInfo) ->
    if
        is_record(GoodsInfo, goods) =:= false ->
            ?ERRCODE(err150_no_goods);
        GoodsInfo#goods.location =/= ?GOODS_LOC_DRACONIC_EQUIP ->
            ?FAIL;
        true ->
            #goods{goods_id = GoodTypeId, other = #goods_other{stren = Strength}} = GoodsInfo,
            case data_draconic:get_draconic_equip_info(GoodTypeId) of
                #base_draconic_equip{strong = StrenLimit} when Strength < StrenLimit ->
                    {true, StrenLimit};
                _ ->
                    ?ERRCODE(err654_strength_level_limit)
            end
    end.

%% 强化
calc_stren(PlayerStatus, GoodsInfo, StrenType) ->
    #player_status{draconic_status = DraconicStatus} = PlayerStatus,
    #goods{cell = Pos, other = #goods_other{stren = Ostren}=Other} = GoodsInfo,
    #draconic_status{equip_list = EquipList} = DraconicStatus,
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, _, Streng} -> skip;
        _ -> Streng = 0
    end,
    Strength = max(Ostren, Streng), %% 修复数据用
    case check_strength(GoodsInfo) of
        {true, StrenLimit} ->
            Res = case calc_stren_core(PlayerStatus, Pos, Strength, StrenLimit, StrenType) of
                {false, _Code, NewPs, NewStren} ->
                    if
                        Strength < NewStren ->
                            NewStren;
                        true ->
                            {false, _Code}
                    end;
                {true, NewPs, NewStren} ->
                    NewStren
            end,
            case Res of
                {false, TemCode} ->
                    {NewPs, TemCode};
                TNewStren -> 
                    PS = updata_draconic_status(NewPs, [{stren, {Pos, NewStren}}]), %% 更新数据
                    {PS, GoodsInfo#goods{other = Other#goods_other{stren = TNewStren}}, NewStren}
            end;
        Code -> {PlayerStatus, Code}
    end.

%% 物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [Strength|_]) ->
    Other#goods_other{stren = Strength}.

%% 脱下装备处理强化等级
takeoff_equips(EquipGoodsList) ->
    [GoodsInfo#goods{other = Other#goods_other{stren = 0}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].

%% 穿戴装备处理强化等级
dress_on_equips(OldStren, #goods{other = Other} = GoodsInfo) ->
    GoodsInfo#goods{other = Other#goods_other{stren = OldStren}}.

%%更新ps里的龙语信息
updata_draconic_status(PS, []) ->PS;
updata_draconic_status(PlayerStatus, [{chang_equip, {GoodsStatus}}|T]) ->
    #player_status{id = RoleId, draconic_status = DraconicStatus} = PlayerStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr, SpecialAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating, TemGtypes, TemSpAttr}) ->
        PosItem = #draconic_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, 
                strong = Strength, rating = BaseRating, attr = ExtraAttr}, 
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_draconic:get_draconic_strong_info(Pos, Strength) of
            #base_draconic_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([TemStrenAttr, StrenAttrCfg]),
        NewSpAttr = ulists:kv_list_plus_extra([TemSpAttr, SpecialAttr]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating, [GoodsTypeId|TemGtypes], NewSpAttr}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating, _GoodsTypeIds, SpAttr} = lists:foldl(Fun1, {#{}, [], [], [], 0, [], []}, EquipList),
    % F1 = fun(GoodsTypeId, Acc) ->
    %     case data_draconic:get_draconic_equip_info(GoodsTypeId) of
    %         #base_draconic_equip{stage = Stage,color = Color} ->[{Color, Stage}|Acc];
    %         _ -> Acc
    %     end
    % end,
    % AchivList = lists:foldl(F1, [], GoodsTypeIds),
    % lib_achievement_api:async_event(RoleId, lib_achievement_api, draconic_equip_event, AchivList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    % mod_scene_agent:update(PS, [{?SCENE_USER_KEY, SpAttr}]),
    NewDraconicStatus = DraconicStatus#draconic_status{ 
                    pos_map = PosMap,
                    equip_list = NEquipList,
                    stren_attr = StrenAttr,
                    equip_attr = AllEquipAttr,
                    suit_info = RealSuitInfo, %% {color,stage,num}
                    suit_attr = SuitAttr,
                    rating = EquipRating + SuitRating, 
                    special_attr = SpAttr},
    NewPs = PlayerStatus#player_status{draconic_status = NewDraconicStatus},
    updata_draconic_status(NewPs, T);

updata_draconic_status(PlayerStatus, [{stren, {Pos, NewStren}}|T]) ->
    #player_status{draconic_status = DraconicStatus} = PlayerStatus,
    #draconic_status{equip_list = EquipList, stren_attr = StrenAttr} = DraconicStatus,
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, GoodsAutoId, Stren} -> 
            case data_draconic:get_draconic_strong_info(Pos, Stren) of
                #base_draconic_strong{add_attr = StrenAttrCfg} ->
                    StrenAttrCfg;
                _ ->
                    StrenAttrCfg = []
            end,
            case data_draconic:get_draconic_strong_info(Pos, NewStren) of
                #base_draconic_strong{add_attr = NewStrenAttrCfg} ->
                    NewStrenAttrCfg;
                _ ->
                    NewStrenAttrCfg = []
            end,
            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsAutoId, NewStren}),
            AddAttr = calc_stren_attr(StrenAttrCfg, NewStrenAttrCfg),
            NewStrenAttr = ulists:kv_list_plus_extra([StrenAttr, AddAttr]),
            % ?PRINT("StrenAttr:~p, NewStrenAttr:~p~n",[StrenAttr, NewStrenAttr]),
            NewDraconicStatus = DraconicStatus#draconic_status{equip_list = NewEquipList, stren_attr = NewStrenAttr};
        _ ->
            NewDraconicStatus = DraconicStatus
    end,
    NewPs = PlayerStatus#player_status{draconic_status = NewDraconicStatus},
    updata_draconic_status(NewPs, T).

%%普通强化，强化一次
calc_stren_core(PlayerStatus, Pos, Stren, _StrenLimit, StrenType) when StrenType == 0 ->
    case data_draconic:get_draconic_strong_info(Pos, Stren+1) of
        #base_draconic_strong{cost = Cost} ->
            case lib_goods_api:cost_object_list_with_check(PlayerStatus, Cost,  draconic_stren, "") of
                {false, _Code, _NewPs} ->
                    {false, _Code, _NewPs, Stren};
                {true, NewPs} ->
                    {true, NewPs, Stren+1}
            end;
        _ ->
            {false, ?ERRCODE(err654_strength_level_limit), PlayerStatus, Stren}
    end;

%自动强化，强化到强化材料不足
calc_stren_core(PlayerStatus, Pos, Stren, StrenLimit, _StrenType) when Stren < StrenLimit ->
    case data_draconic:get_draconic_strong_info(Pos, Stren+1) of
        #base_draconic_strong{cost = Cost} ->
            case lib_goods_api:cost_object_list_with_check(PlayerStatus, Cost,  draconic_stren, "") of
                {false, _Code, _NewPs} ->
                    {false, _Code, _NewPs, Stren};
                {true, NewPs} ->
                    calc_stren_core(NewPs, Pos, Stren+1, StrenLimit, _StrenType)
            end;
        _ ->
            {false, ?ERRCODE(err654_strength_level_limit), PlayerStatus, Stren}
    end;
calc_stren_core(PlayerStatus, _Pos, StrenLimit, StrenLimit, _StrenType) -> {true, PlayerStatus, StrenLimit}.

%%依据穿戴装备列表计算数据
calc_equip_list(EquipGoodsList) ->
    lists:foldl(fun
        (#goods{id = Id, goods_id = GoodsTypeId, other = #goods_other{stren = Strength, 
                    rating = BaseRating, extra_attr = _ExtraAttr}, subtype = Pos}, {Acc, TemEquipAttr}) ->
            case data_draconic:get_draconic_equip_info(GoodsTypeId) of
                #base_draconic_equip{base_attr = BaseAttr, extra_attr = ExtraAttrCfg} ->
                    SpecialAttr = get_sp_attr([?DRACONIC_SACRED, ?DRACONIC_TSPACE, ?DRACONIC_ARRAY], ExtraAttrCfg, []),
                    ExtraAttr = BaseAttr++ExtraAttrCfg;
                _ ->
                    ExtraAttr = [], SpecialAttr = []
            end,
            NewAttr = ulists:kv_list_plus_extra([TemEquipAttr, ExtraAttr]),
            {[{Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr, SpecialAttr}|Acc], NewAttr}

    end, {[], []}, EquipGoodsList).


calc_suit_info_2(GoodsTypeId, TemSuitInfo) ->
    case data_draconic:get_draconic_equip_info(GoodsTypeId) of
        #base_draconic_equip{stage = Stage, color = Color, suit = SuitId} ->
            case data_draconic:get_draconic_suit_info(SuitId) of
                #base_draconic_suit{suit_type = SuitType, attr = Attr} ->
                    [{SuitId, Color, Stage, 1, Attr, SuitType, GoodsTypeId}|TemSuitInfo];
                _ ->
                    TemSuitInfo
            end;
        _ -> TemSuitInfo
    end.

hand_suit_info_2(SuitInfo) ->
    Fun = fun({SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeId}, Acc) ->
        case lists:keyfind(SuitId, 1, Acc) of
            {SuitId, _, _, TemNum, _, _, GoodsTypeIdList} ->
                lists:keystore(SuitId, 1, Acc, {SuitId, Color, Stage, Num+TemNum, Attr, SuitType, [GoodsTypeId|GoodsTypeIdList]});
            _ ->
                lists:keystore(SuitId, 1, Acc, {SuitId, Color, Stage, Num, Attr, SuitType, [GoodsTypeId]})
        end
    end,
    HandleSuitList = lists:foldl(Fun, [], SuitInfo),
    {CalcSuitInfo, NeedHandleList} = hand_suit_info_2_helper(HandleSuitList, [], []),
    {HandleList, NewSuitInfo} = hand_suit_info_2_before(lists:reverse(lists:keysort(2, NeedHandleList)), NeedHandleList, CalcSuitInfo),
    % ?PRINT("NewSuitInfo:~p~n HandleList:~p~n",[NewSuitInfo, HandleList]),
    % ?MYLOG("xlh_draconic1", "SuitInfo:~p~nHandleSuitList:~p~n~n", [SuitInfo,HandleSuitList]),
    hand_suit_info_2_core(NewSuitInfo, HandleList, []).

%% 挑出所有已经满足的套装
hand_suit_info_2_helper([], CalcSuitInfo, NeedHandleList) -> {CalcSuitInfo, NeedHandleList};
hand_suit_info_2_helper([{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList}|H], CalcSuitInfo, NeedHandleList) -> 
    {SatisfyNum, ResetNum} = calc_suit_num(Num, Attr),
    if
        SatisfyNum =/= 0 andalso ResetNum =/= 0 ->
            {SubList, RemainList} = ulists:sublist(GoodsTypeIdList, SatisfyNum),
            NewCalcSuitInfo = lists:keystore(SuitId, 1, CalcSuitInfo, {SuitId, Color, Stage, SatisfyNum, Attr, SuitType, SubList}),
            NewNeedHandleList = [{SuitId, Color, Stage, ResetNum, Attr, SuitType, RemainList}|NeedHandleList];
        SatisfyNum =/= 0 andalso ResetNum == 0 ->
            NewCalcSuitInfo = lists:keystore(SuitId, 1, CalcSuitInfo, 
                    {SuitId, Color, Stage, SatisfyNum, Attr, SuitType, GoodsTypeIdList}),
            NewNeedHandleList = NeedHandleList;
        true ->
            NewCalcSuitInfo = CalcSuitInfo,
            NewNeedHandleList = [{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList}|NeedHandleList]
    end,
    hand_suit_info_2_helper(H, NewCalcSuitInfo, NewNeedHandleList).

%% 兼容规则
hand_suit_info_2_core(RealSuitInfo, [], []) -> RealSuitInfo;
hand_suit_info_2_core([], [], RealSuitInfo) -> RealSuitInfo;
hand_suit_info_2_core([], NeedHandleList, RealSuitInfo) -> 
    hand_suit_info_2_last(lists:reverse(lists:keysort(2, NeedHandleList)), NeedHandleList, RealSuitInfo);
    % ?MYLOG("xlh_draconic2","Res:~p,NeedHandleList:~p~nRealSuitInfo:~p~n",[Res, NeedHandleList,RealSuitInfo]),Res;
hand_suit_info_2_core([{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList} = H|T], NeedHandleList, RealSuitInfo) ->
    {SatisfyList, RestList, Sum} = calc_compatible_suit(Stage, Color, SuitType, NeedHandleList),
    if
        Sum > 0 ->
            {SatisfyNum, _} = calc_suit_num(Num+Sum, Attr),
            if
                SatisfyNum > Num ->
                    {RestList1, SatisfyGoodsList} = calc_new_goods_list(SatisfyNum-Num, SatisfyList, []),
                    hand_suit_info_2_core(T, RestList1++RestList, [{SuitId, Color, Stage, SatisfyNum, Attr, SuitType, 
                            SatisfyGoodsList++GoodsTypeIdList}|RealSuitInfo]);
                true ->
                    NewRealSuitInfo = calc_real_suit(H, RealSuitInfo),
                    hand_suit_info_2_core(T, NeedHandleList, NewRealSuitInfo)
            end;
        true ->
            NewRealSuitInfo = calc_real_suit(H, RealSuitInfo),
            hand_suit_info_2_core(T, NeedHandleList, NewRealSuitInfo)
    end.

hand_suit_info_2_before([], HandleList, SuitList) -> {HandleList, SuitList};
hand_suit_info_2_before([{_, Color, Stage, _, _, SuitType, _}|T], NeedHandleList, SuitInfo) ->
    Fun = fun({TemSuitId, TemColor, TemStage, TemNum, TemAttr, TemSuitType, TemGoodsTypeIdList}, {Acc, Acc1}) ->
        if
            TemStage == Stage andalso TemSuitType == SuitType andalso TemColor >= Color ->
                {[{TemSuitId, TemColor, TemStage, TemNum, TemAttr, TemSuitType, TemGoodsTypeIdList}|Acc], Acc1};
            true ->
                {Acc, [{TemSuitId, TemColor, TemStage, TemNum, TemAttr, TemSuitType, TemGoodsTypeIdList}|Acc1]}
        end
    end,
    {List, NewNeedHandleList} = lists:foldl(Fun, {[], []}, NeedHandleList),
    {HandleList, SuitList} = hand_suit_info_2_before_helper(lists:reverse(lists:keysort(2, List)), List, SuitInfo),
    % ?PRINT("{Color, Stage}:~p,List:~p~nSuitInfo:~p~n",[{Color, Stage},List, SuitInfo]),
    % ?PRINT("HandleList:~p~n SuitList:~p~n NeedHandleList:~p~n",[HandleList, SuitList, NewNeedHandleList ++ HandleList]),
    hand_suit_info_2_before(T, NewNeedHandleList ++ HandleList, SuitList).

hand_suit_info_2_before_helper([], NeedHandleList, RealSuitInfo) -> {NeedHandleList, RealSuitInfo};
hand_suit_info_2_before_helper([{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList} = H|T], NeedHandleList, RealSuitInfo) ->
    {SatisfyList, RestList, Sum} = calc_compatible_suit(Stage, Color, SuitType, NeedHandleList--[H]),
    if
        Sum > 0 ->
            {SatisfyNum, _} = calc_suit_num(Num+Sum, Attr),
            if
                SatisfyNum > Num ->
                    {RestList1, SatisfyGoodsList} = calc_new_goods_list(SatisfyNum-Num, SatisfyList, []),
                    NewSuitInfo = case lists:keyfind(SuitId, 1, RealSuitInfo) of
                        {SuitId, _, _, OldNum, _, SuitType, OldGoodsTypeIdList} ->
                            lists:keystore(SuitId, 1, RealSuitInfo, {SuitId, Color, Stage, OldNum+SatisfyNum, 
                                    Attr, SuitType, SatisfyGoodsList++GoodsTypeIdList++OldGoodsTypeIdList});
                        _ ->
                            lists:keystore(SuitId, 1, RealSuitInfo, {SuitId, Color, Stage, SatisfyNum, Attr, SuitType, 
                                    SatisfyGoodsList++GoodsTypeIdList})
                    end,
                    % ?MYLOG("xlh_draconic2","SatisfyList:~p,RestList1++RestList:~p,SatisfyGoodsList:~p~n",[SatisfyList,RestList1++RestList, SatisfyGoodsList]),
                    hand_suit_info_2_before_helper(RestList1++RestList, RestList1++RestList, NewSuitInfo);
                true ->
                    hand_suit_info_2_before_helper(T, NeedHandleList, RealSuitInfo)
            end;
        true ->
            hand_suit_info_2_before_helper(T, NeedHandleList, RealSuitInfo)
    end.

%% 计算完套装后再次检测有没有满足的套装
hand_suit_info_2_last([], _, RealSuitInfo) -> RealSuitInfo;
hand_suit_info_2_last([{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList} = H|T], NeedHandleList, RealSuitInfo) ->
    {SatisfyList, RestList, Sum} = calc_compatible_suit(Stage, Color, SuitType, NeedHandleList--[H]),
    if
        Sum > 0 ->
            {SatisfyNum, _} = calc_suit_num(Num+Sum, Attr),
            if
                SatisfyNum > Num ->
                    {RestList1, SatisfyGoodsList} = calc_new_goods_list(SatisfyNum-Num, SatisfyList, []),
                    % ?MYLOG("xlh_draconic2","SatisfyList:~p,RestList1++RestList:~p,SatisfyGoodsList:~p~n",[SatisfyList,RestList1++RestList, SatisfyGoodsList]),
                    hand_suit_info_2_last(RestList1++RestList, RestList1++RestList, [{SuitId, Color, Stage, SatisfyNum, Attr, SuitType, 
                            SatisfyGoodsList++GoodsTypeIdList}|RealSuitInfo]);
                true ->
                    NewRealSuitInfo = calc_real_suit(H, RealSuitInfo),
                    hand_suit_info_2_last(T, NeedHandleList, NewRealSuitInfo)
            end;
        true ->
            NewRealSuitInfo = calc_real_suit(H, RealSuitInfo),
            hand_suit_info_2_last(T, NeedHandleList, NewRealSuitInfo)
    end.

calc_real_suit({SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList}, RealSuitInfo) ->
    case lists:keyfind(SuitId, 1, RealSuitInfo) of
        {SuitId, Color, Stage, TemNum, _, SuitType, TemGoodsTypeIdList} ->
            lists:keystore(SuitId, 1, RealSuitInfo, 
                    {SuitId, Color, Stage, TemNum+Num, Attr, SuitType, TemGoodsTypeIdList++GoodsTypeIdList});
        _ ->
            lists:keystore(SuitId, 1, RealSuitInfo, 
                    {SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList})
    end.

calc_compatible_suit(Stage, Color, SuitType, NeedHandleList) ->
    Fun = fun({SuitId, TemColor, TemStage, Num, Attr, TemSuitType, GoodsTypeIdList}, {Acc, Acc1, Sum}) ->
        if
            TemStage == Stage andalso TemSuitType == SuitType andalso TemColor >= Color ->
                {[{SuitId, TemColor, TemStage, Num, Attr, SuitType, GoodsTypeIdList}|Acc], Acc1, Num+Sum};
            true ->
                {Acc, [{SuitId, TemColor, TemStage, Num, Attr, TemSuitType, GoodsTypeIdList}|Acc1], Sum}
        end
    end,
    lists:foldl(Fun, {[], [], 0}, NeedHandleList).

calc_new_goods_list(0, T, GoodsTypeIdList) -> {T, GoodsTypeIdList};
calc_new_goods_list(NeedNum, [{SuitId, Color, Stage, Num, Attr, SuitType, GoodsTypeIdList}|T], Acc) ->
    if
        NeedNum >= Num ->
            calc_new_goods_list(NeedNum-Num, T, GoodsTypeIdList++Acc);
        true ->
            {SubList, RemainList} = ulists:sublist(GoodsTypeIdList, Num - NeedNum),
            calc_new_goods_list(0, [{SuitId, Color, Stage, Num, Attr, SuitType, RemainList}|T], SubList++Acc)
    end.
calc_suit_num(Num, Attr) ->
    SortList = lists:reverse(lists:keysort(1, Attr)),
    F = fun({Value, _}) ->
        Num >= Value
    end,
    case ulists:find(F, SortList) of
        {ok, {SNum, _}} -> {SNum, Num - SNum};
        _ -> {0, Num}
    end.


%计算所有套装的属性及评分
calc_suit_attr_rating(RealSuitInfo) ->
    Fun = fun({SuitId, _Color, _Stage, Num, _, _, _}, {TemAttr, TemScore}) ->
        % case lists:keyfind(Stage, 1, Acc) of
        %     {Stage, TemColor, TemNum} ->
        %         if
        %             TemColor > Color ->
        %                 NewAcc = [{Stage, Color, TemNum+Num}];
        %             true ->
        %                 NewAcc = [{Stage, TemColor, TemNum+Num}]
        %         end;
        %     _ ->
        %         NewAcc = Acc
        % end,
        {Attr, Score} = hand_suit_cfg(SuitId, Num),
        % ?PRINT("@@@ Score:~p,Attr:~p~n",[Score, Attr]),
        NewAttr = ulists:kv_list_plus_extra([TemAttr, Attr]),
        {NewAttr, Score + TemScore}
    end,
    lists:foldl(Fun, {[], 0}, RealSuitInfo).
    % case ExtraSuit of
    %     [{ExStage, ExColor, 11}] ->
    %         case data_draconic:get_special_suit_id(ExStage, ExColor) of
    %             [ExtraSuitId] ->
    %                 #base_special_suit{attr = AttrCfg, score = ScoreC} = data_draconic:get_special_suit_info(ExtraSuitId),
    %                 if
    %                     is_integer(ScoreC) ->
    %                         ScoreCfg = ScoreC;
    %                     true ->
    %                         ScoreCfg = 0
    %                 end,
    %                 {ulists:kv_list_plus_extra([Attr, AttrCfg]), Score+ScoreCfg};
    %             _ ->
    %                 {Attr, Score}
    %         end;
    %     _ ->
    %         {Attr, Score}   
    % end.

%计算单个套装的属性及评分
hand_suit_cfg(SuitId, Num) ->
    case data_draconic:get_draconic_suit_info(SuitId) of
        #base_draconic_suit{attr = AttrCfg, score = ScoreCfg} ->
            Fun = fun({NumCfg, Attr}, {TemAttr, TemScore}) ->
                case NumCfg =< Num of
                    true ->
                        case lists:keyfind(NumCfg, 1, ScoreCfg) of
                            {_, Score} ->{Attr++TemAttr, TemScore + Score};
                            _ ->?ERR("draconic cfg lost, rating lost, SuitId:~p~n", [SuitId]),{Attr++TemAttr, TemScore}
                        end;
                    _ ->
                        {TemAttr, TemScore}
                end
            end,
            {Attr, Score} = lists:foldl(Fun, {[], 0}, AttrCfg),
            {Attr, Score};
        _ ->
            ?ERR("draconic cfg lost, SuitId:~p~n", [SuitId]),{[], 0}
    end.

%汇总龙语总属性
get_total_attr(PlayerStatus) ->
    DraconicStatus = PlayerStatus#player_status.draconic_status,
    #draconic_status{   stren_attr = StrenAttr,
                    equip_attr = AllEquipAttr,
                    suit_attr = SuitAttr} = DraconicStatus,
    Allattr = StrenAttr ++ AllEquipAttr ++ SuitAttr,
    % ?PRINT("======= Allattr:~p~nStrenAttr:~p~n AllEquipAttr:~p~nSuitAttr:~p~n",[Allattr,StrenAttr,AllEquipAttr,SuitAttr]),
    Allattr.


%% 秘籍
gm_add_equip(Status, Stage, Color) ->
    case data_draconic:get_all_equip(Stage, Color) of   
        GoodsTypeIds when is_list(GoodsTypeIds) andalso GoodsTypeIds =/= [] ->
            Fun = fun(GoodsTypeId, Acc) ->
                [{?TYPE_GOODS, GoodsTypeId, 1}|Acc]
            end,
            Reward = lists:foldl(Fun, [], GoodsTypeIds),
            % ?PRINT("=========== Reward:~p~n",[Reward]),
            lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id);
        _->
            skip
    end.

%% StrenAttrCfg1：前一阶强化配置属性，StrenAttrCfg2：当前阶强化配置属性
calc_stren_attr([], StrenAttr) -> StrenAttr;
calc_stren_attr([{Key, Value}|T], StrenAttrCfg2) ->
    case lists:keyfind(Key, 1, StrenAttrCfg2) of
        {Key, Value2} when Value2 >= Value ->
            NewList = lists:keystore(Key, 1, StrenAttrCfg2, {Key, Value2 - Value}),
            calc_stren_attr(T, NewList);
        _ ->
            calc_stren_attr(T, StrenAttrCfg2)
    end.

%% 套装预览
calc_suit_info_preview(PlayerStatus, GoodsStatus, GoodsTypeId, Pos) ->
    #player_status{id = RoleId} = PlayerStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_DRACONIC_EQUIP, GoodsDict),
    {EquipList, _AllEquipAttr} = calc_equip_list(EquipGoodsList),
    case lists:keyfind(GoodsTypeId, 3, EquipList) of
        {_, _, GoodsTypeId, _, _, _, _} -> NewEquipList = EquipList;
        _ -> 
            NewEquipList1 = lists:keydelete(Pos, 1, EquipList),
            case data_draconic:get_draconic_equip_info(GoodsTypeId) of
                #base_draconic_equip{extra_attr = ExtraAttr} -> 
                    SpecialAttr = get_sp_attr([?DRACONIC_SACRED, ?DRACONIC_TSPACE, ?DRACONIC_ARRAY], ExtraAttr, []);
                _ -> SpecialAttr = []
            end,
            NewEquipList = [{Pos, 0, GoodsTypeId, 0, 0, [], SpecialAttr}|NewEquipList1]
    end,
    % NewEquipList = lists:keydelete(Pos, 1, EquipList),
    Fun1 = fun({_, _Id, TGoodsTypeId, _Strength, _BaseRating, _ExtraAttr, _}, TemSuitInfo) ->
        SuitInfo = calc_suit_info_2(TGoodsTypeId, TemSuitInfo),
        SuitInfo
    end,

    NSuitInfo = lists:foldl(Fun1, [], NewEquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    % ?MYLOG("xlh_draconic", "RNSuitInfo:~p~nRealSuitInfo:~p~n",[RNSuitInfo,RealSuitInfo]),
    handle_suitinfo_1(RealSuitInfo, GoodsTypeId).

get_sp_attr([], _, SpAttr) -> SpAttr;
get_sp_attr([AttrId|T], ExtraAttr, SpAttr) ->
    case lists:keyfind(AttrId, 1, ExtraAttr) of
        {AttrId, Value} -> 
            case lists:keyfind(AttrId, 1, SpAttr) of
                {_, Value1} ->
                    NewSpAttr = lists:keystore(AttrId, 1, SpAttr, {AttrId, Value1+Value});
                _ ->
                    NewSpAttr = lists:keystore(AttrId, 1, SpAttr, {AttrId, Value})
            end;
        _ ->
            NewSpAttr = SpAttr
    end,
    get_sp_attr(T, ExtraAttr, NewSpAttr).
    
handle_suitinfo_1([], _) -> {[], ?ERRCODE(err622_not_be_suit)};
handle_suitinfo_1([{SuitId, _, _, Num, _, _, GoodsTypeIdList}|H], GoodsTypeId) ->
    case lists:member(GoodsTypeId, GoodsTypeIdList) of
        true ->
            {[{SuitId, Num}], 1};
        _ ->
            handle_suitinfo_1(H, GoodsTypeId)
    end.