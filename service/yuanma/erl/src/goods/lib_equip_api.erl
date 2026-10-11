%% ---------------------------------------------------------------------------
%% @doc 装备模块
%% @author lxl
%% @since  2020-3-9
%% @deprecated 装备模块api调用
%% ---------------------------------------------------------------------------
-module(lib_equip_api).
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("server.hrl").
-include("equip_suit.hrl").
-compile(export_all).

%% 获取装备阶数和星数
%% Equip:GoodsTypeId|#goods{}|#ets_goods_type{}
get_equip_stage(Equip) ->
	lib_equip:get_equip_stage(Equip).

get_equip_star(Equip) ->
	lib_equip:get_equip_star(Equip).


%% 计算装备评分
%% GoodsTypeInfo:#ets_goods_type{}
%% EquipExtraAttr：装备极品属性
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) ->
	lib_equip:cal_equip_rating(GoodsTypeInfo, EquipExtraAttr).

%% 生成装备属性
%% AttrArgs：[{生成数量,属性池}]
%% OldExtraAttr：旧属性列表，用于继承
gen_equip_extra_attr(AttrArgs, OldExtraAttr) ->
	lib_equip:gen_equip_extra_attr(AttrArgs, OldExtraAttr).

%% 获取装备洗练段数
get_equip_wash_total_duan(_PS) ->
	#goods_status{
        equip_wash_map = EquipWashMap
    } = lib_goods_do:get_goods_status(),
    F = fun(_, #equip_wash{duan = Division}, Acc) ->
    	Division + Acc
    end,
    maps:fold(F, 0, EquipWashMap).

%% 单件装备段数
get_equip_wash_duan(_PS, EquipPos) ->
	#goods_status{
        equip_wash_map = EquipWashMap
    } = lib_goods_do:get_goods_status(),
    #equip_wash{
        duan = Division
    } = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    Division.

%% 取最高洗练阶数的装备
get_one_equip_wash_duan_high(_PS) ->
	#goods_status{
        equip_wash_map = EquipWashMap
    } = lib_goods_do:get_goods_status(),
    F = fun(_, #equip_wash{duan = Division}, Cnt) ->
    	max(Division, Cnt)
    end,
    maps:fold(F, 0, EquipWashMap).

%% 获取评分最低的防装
%% @return #goods{} | undefined
get_worst_defence_equip(PS) ->
    #player_status{id = RoleId} = PS,
    #goods_status{dict = GoodsDict} = lib_goods_do:get_goods_status(),
    DefEquipList = lib_goods_util:get_defence_equip_list(RoleId, GoodsDict),
    get_worst_rating_equip(DefEquipList).

%% 从装备列表获取评分最低的装备
%% @param EquipList :: [#goods{},...]
%% @return #goods{} | undefined
get_worst_rating_equip([]) -> undefined;
get_worst_rating_equip(EquipList) ->
    F = fun(Equip1, Equip2) ->
        Rating1 = Equip1#goods.other#goods_other.rating,
        Rating2 = Equip2#goods.other#goods_other.rating,
        Rating1 < Rating2
    end,
    [Worst | _] =  lists:sort(F, EquipList),
    Worst.

%% 获取装备自身的总评分
get_all_equip_rating(#player_status{id = RoleId} = _PS) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GS,
    EquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_EQUIP, GoodsDict),  %%获得镶嵌中的符文列表
    F = fun(GoodInfo, Rating) ->
        Rating + GoodInfo#goods.other#goods_other.rating
        end,
    LastRating = lists:foldl(F, 0, EquipWearList),
    LastRating.

get_suit_cnt_between(PS, Lv, SLv) ->
    get_suit_cnt_between(PS, Lv, SLv, 99999).

get_suit_cnt_between(_PS, Lv, SLvmin, SLvmax) ->
    #goods_status{equip_suit_list = SuitList} = lib_goods_do:get_goods_status(),
    lists:sum([1 ||#suit_item{lv = Lv1, slv = SLv} <- SuitList, Lv1 == Lv, SLv >= SLvmin, SLv < SLvmax]).

%% 需要在玩家进程调用
get_equip_task_info(RoleId) ->
    case lib_goods_do:get_goods_status() of
        #goods_status{dict = GoodsDict} ->
            EquipList = lib_goods_util:get_equip_list(RoleId, GoodsDict),
            F = fun(#goods{goods_id = GoodsTypeId, color = Color}) ->
                case data_equip:get_equip_attr_cfg(GoodsTypeId) of
                    #equip_attr_cfg{stage = Stage, star = Star} -> {Color, Stage, Star};
                    _ -> {Color, 1, 0}
                end
            end,
            lists:map(F, EquipList);
        _ ->
            []
    end.
