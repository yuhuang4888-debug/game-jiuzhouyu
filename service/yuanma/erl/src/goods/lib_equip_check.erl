%% ---------------------------------------------------------------------------
%% @doc 装备校验模块
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_equip_check).
-include("common.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("equip_suit.hrl").
-include("skill.hrl").

-export([equip/3, unequip/2]).
-export([unlock_wash_pos/4, equip_wash/5]).
-export([stren/3, stren/2, stren_info/2, refine/3, refine/2, refine_info/2]).
-export([equip_stone/5, unequip_stone/3, stone_refine/5, upgrade_stone_on_equip/5, combine_stone/4]).
-export([upgrade_stage_preview/2, upgrade_stage/3]).
-export([make_suit_check/5, check_satisfied_red_equip/2]).
-export([check/1]).
-export([checklist/1]).
-export([
    casting_spirit_check/3,
    upgrade_spirit_check/2,
    awakening_check/3
]).
-export([
    upgrade_division/4
    ,add_equip_skill_check/4
    , remove_equip_skill_check/3
    , upgrade_equip_skill_check/3
]).

-export([
    new_make_suit_rule_check/5
]).

equip(PS, GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) ->
            Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
            Location = ?GOODS_LOC_EQUIP,
            OldGoodsInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, Location, Cell, GoodsStatus#goods_status.dict),
            Temp2 = data_goods_type:get(GoodsInfo#goods.goods_id),
            NewdefaultLocation = Temp2#ets_goods_type.bag_location,
            case is_record(OldGoodsInfo, goods) of
                true ->
                    Temp1 = data_goods_type:get(OldGoodsInfo#goods.goods_id),
                    OlddefaultLocation = Temp1#ets_goods_type.bag_location;
                false ->
                    OlddefaultLocation = NewdefaultLocation  %%如果人物上没有装备
            end,
            CheckList = [
                {check_base, PS, GoodsInfo},
                {check_sex, GoodsInfo, PS#player_status.figure#figure.sex},
                {check_career, GoodsInfo, PS#player_status.figure#figure.career},
                {check_turn, GoodsInfo, PS#player_status.figure#figure.turn},
                {check_null_cells, GoodsStatus, OlddefaultLocation, NewdefaultLocation},
                {check_goods_type, GoodsInfo, ?GOODS_TYPE_EQUIP},
                {check_equip_type, GoodsInfo},
                {check_location, GoodsInfo, NewdefaultLocation}
            ],
            case checklist(CheckList) of
                true -> {true, GoodsInfo};
                {false, Res} -> {false, Res}
            end;
        true ->
            {false, ?ERRCODE(err150_no_goods)}
    end.


unequip(GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    CheckList = [
        {check_exist, GoodsInfo},
        {check_null_cells, GoodsStatus, GoodsInfo#goods.goods_id},
        {check_location, GoodsInfo, ?GOODS_LOC_EQUIP}
        %%chenyiming  新项目即使强化过也可以卸下来。
%%            {check_goods_type, GoodsInfo, ?GOODS_TYPE_EQUIP},
%%            {check_stren_lv, GoodsStatus, data_goods:get_equip_cell(GoodsInfo#goods.equip_type)},      %%强化校验
%%            {check_has_wash_attr, GoodsStatus, data_goods:get_equip_cell(GoodsInfo#goods.equip_type)}, %%洗练校验
%%            {check_has_refine, GoodsStatus, data_goods:get_equip_cell(GoodsInfo#goods.equip_type)},  %%宝石校验
%%            {check_has_awakening, GoodsStatus, data_goods:get_equip_cell(GoodsInfo#goods.equip_type)}  %%觉醒校验
    ],
    case checklist(CheckList) of
        true -> {true, GoodsInfo};
        {false, Res} -> {false, Res}
    end.

stren(PS, GoodsStatus, EquipPos) ->
    EquipStren = lib_equip:get_stren(GoodsStatus, EquipPos),
    Stren = EquipStren#equip_stren.stren,
    Cfg = data_equip:stren_lv_cfg(EquipPos, Stren),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    CheckList = [
        {check_config, Cfg, []},
        {check_equip_pos_correct, EquipPos},
        {check_has_equip, EquipPos, GoodsStatus#goods_status.equip_location},
        {check_stren_max, EquipPos, EquipInfo, EquipStren},
        {check_stren_cost, PS, Cfg}
    ],
    case checklist(CheckList) of
        true ->
            {true, EquipInfo, EquipStren, Cfg};
        {false, Res} ->
            {false, Res}
    end.

stren(PS, GoodsStatus) ->
    StrenL =
    [
    begin
        #equip_stren{stren = Stren} = lib_equip:get_stren(GoodsStatus, EquipPos),
        {EquipPos, Stren}
    end || EquipPos <- ?ALL_EQUIP_TYPES
    ],
    SortStrenL = lists:keysort(2, StrenL), % 按照强化强度由小到大排序
    F = fun({EquipPos, _}, {Acc1, Acc2}) ->
        case stren(PS, GoodsStatus, EquipPos) of
            {true, EquipInfo, EquipStren, Cfg} -> {[{EquipPos, EquipInfo, EquipStren, Cfg}|Acc1], Acc2};
            Error -> {Acc1, [Error|Acc2]} % 前面部分的装备不能强化时,可能后面的装备可以强化,所以先保留错误信息,在全部都不能强化时再用到
        end
    end,
    case lists:foldl(F, {[], []}, SortStrenL) of
        {[], ErrorList} -> lists:last(ErrorList); % 没有可强化装备,返回第一个错误信息
        {StrenList, _} -> {true, lists:reverse(StrenList)}
    end.

stren_info(GoodsStatus, EquipPos) ->
    EquipStren = lib_equip:get_stren(GoodsStatus, EquipPos),
    CheckList = [{check_equip_pos_correct, EquipPos}],
    case checklist(CheckList) of
        true -> {true, EquipStren#equip_stren.stren};
        {false, Res} ->
            {false, Res}
    end.

refine(PS, GoodsStatus, EquipPos) ->
    EquipRefine = lib_equip:get_refine(GoodsStatus, EquipPos),
    Refine = EquipRefine#equip_refine.refine,
    Cfg = data_equip:refine_lv_cfg(EquipPos, Refine),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    CheckList = [
        {check_config, Cfg, []},
        {check_equip_pos_correct, EquipPos},
        {check_has_equip, EquipPos, GoodsStatus#goods_status.equip_location},
        {check_refine_max, EquipPos, EquipInfo, EquipRefine},
        {check_refine_cost, PS, Cfg}
    ],
    case checklist(CheckList) of
        true -> {true, EquipInfo, EquipRefine, Cfg};
        {false, Res} -> {false, Res}
    end.

refine(PS, GoodsStatus) ->
    RefineL =
    [
    begin
        #equip_refine{refine = Refine} = lib_equip:get_refine(GoodsStatus, EquipPos),
        {EquipPos, Refine}
    end || EquipPos <- ?ALL_EQUIP_TYPES
    ],
    SortRefineL = lists:keysort(2, RefineL), % 按照强化强度由小到大排序
    F = fun({EquipPos, _}, {Acc1, Acc2}) ->
        case refine(PS, GoodsStatus, EquipPos) of
            {true, EquipInfo, EquipRefine, Cfg} -> {[{EquipPos, EquipInfo, EquipRefine, Cfg}|Acc1], Acc2};
            Error -> {Acc1, [Error|Acc2]} % 前面部分的装备不能精炼时,可能后面的装备可以精炼,所以先保留错误信息,在全部都不能精炼时再用到
        end
    end,
    case lists:foldl(F, {[], []}, SortRefineL) of
        {[], ErrorList} -> lists:last(ErrorList); % 没有可精炼装备,返回第一个错误信息
        {RefineList, _} -> {true, lists:reverse(RefineList)}
    end.

refine_info(GoodsStatus, EquipPos) ->
    %EquipRefine = lib_equip:get_refine(GoodsStatus, EquipPos),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    EquipRefine = lib_equip:get_refine(GoodsStatus, EquipPos),
    CheckList = [{check_equip_pos_correct, EquipPos}],
    case checklist(CheckList) of
        true when is_record(EquipInfo, goods) ->
            {true, EquipInfo#goods.other#goods_other.refine, EquipRefine#equip_refine.refine};
        {false, Res} -> {false, Res};
        _ ->  {false, ?FAIL}
    end.

upgrade_stage_preview(GoodsStatus, GoodsId) ->
    EquipInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    case EquipInfo of
        #goods{goods_id = GTypeId} ->
            Cfg = data_equip:upgrade_stage_cfg(GTypeId),
            CheckList = [
                {check_upgrade_stage, EquipInfo, Cfg}
            ],
            case checklist(CheckList) of
                true -> {true, EquipInfo, Cfg};
                {false, Res} -> {false, Res}
            end;
        _ -> {false, ?ERRCODE(err150_no_goods)}
    end.

upgrade_stage(PS, GoodsStatus, GoodsId) ->
    EquipInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    case EquipInfo of
        #goods{goods_id = GTypeId} ->
            Cfg = data_equip:upgrade_stage_cfg(GTypeId),
            CheckList = [
                {check_upgrade_stage, EquipInfo, Cfg},
                {check_upgrade_stage_cost, PS, Cfg}
            ],
            case checklist(CheckList) of
                true -> {true, EquipInfo, Cfg};
                {false, 1003} -> {false, ?ERRCODE(err152_not_enough_upgrade_stage_cost)};
                {false, Res} -> {false, Res}
            end;
        _ -> {false, ?ERRCODE(err150_no_goods)}
    end.

%% 开启洗练属性
unlock_wash_pos(PS, GoodsStatus, EquipPos, WashPos) ->
    #player_status{id = _RoleId, figure = #figure{lv = RoleLv}} = PS,
    #goods_status{equip_wash_map = EquipWashMap} = GoodsStatus,
    #equip_wash{duan = Duan, attr = OldWashAttrList} = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    WashAttrData = lists:keyfind(WashPos, 1, OldWashAttrList),
    WashAttrDataBef = lists:keyfind(WashPos - 1, 1, OldWashAttrList),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    WashCfg = data_equip:get_wash_cfg(EquipPos, Duan),   % 改get_wash_cfg(EquipPos)
    UnlockCfg = data_equip:get_wash_unlock_lv(EquipPos),
    if
%%		没有槽位配置
        WashPos < 1 orelse WashPos > 4 -> {false, ?ERRCODE(err_config)};
%%      槽位没有按顺序开启
        WashPos > 1 andalso WashAttrDataBef == false -> {false, ?ERRCODE(err152_no_order)};
%%		槽位已经开启
        WashAttrData =/= false -> {false, ?ERRCODE(err152_has_unlock_wash_pos)};
%%		获取有没有配置
        is_record(WashCfg, equip_wash_cfg) == false -> {false, ?ERRCODE(missing_config)};
%%		判断有没有穿戴装备
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_no_equip_cannot_wash)};
%%		判断部位没有解锁
        RoleLv < UnlockCfg#equip_wash_unlock_lv_cfg.unlock_lv ->
            {false, ?ERRCODE(err152_role_lv_not_satisfy_wash_lv)};
        true ->
%%          属性权重列表
            AttrWeightList = lists:filter(
                fun({_W, TmpAttrId}) ->
                    case lists:keyfind(TmpAttrId, 3, OldWashAttrList) of
                        false -> true;   % 排除已有的属性
                        _ -> false
                    end
                end, WashCfg#equip_wash_cfg.attr),
            case AttrWeightList =/= [] of
                true ->
                    {WashPos, Cost} = lists:keyfind(WashPos, 1, UnlockCfg#equip_wash_unlock_lv_cfg.unlock_cost),
                    case Cost =/= [] of
                        true ->
                            CheckList = [{check_object_cost, PS, Cost}],
                            case checklist(CheckList) of
                                true -> {true, EquipInfo, AttrWeightList, Cost};
                                {false, Res} -> {false, Res}
                            end;
                        false ->
                            {true, EquipInfo, AttrWeightList, Cost}
                    end;
                false -> {false, ?ERRCODE(err_config)}
            end
    end.

equip_wash(PS, GoodsStatus, EquipPos, LockAttrList, RatioPlus) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    #goods_status{equip_wash_map = EquipWashMap} = GoodsStatus,
    #equip_wash{duan = Duan, attr = WashAttrList} =
        maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    LockNum = length(LockAttrList),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    WashCfg = data_equip:get_wash_cfg(EquipPos, Duan),
    UnlockCfg = data_equip:get_wash_unlock_lv(EquipPos),
    IsRatioPlus = lists:member(RatioPlus, [0, 1, 2, 3]),
    if
%%      是否是协议的定义
        IsRatioPlus == false -> {false, ?ERRCODE(missing_config)};
%%      判断有没有配置
        is_record(WashCfg, equip_wash_cfg) == false -> {false, ?ERRCODE(missing_config)};
%%      判断是否有装备
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_no_equip_cannot_wash)};
%%      至少有一条属性未锁定时才可洗练
        length(WashAttrList) =< LockNum -> {false, ?ERRCODE(err152_can_not_lock_all)};
%%		判断部位没有解锁
        RoleLv < UnlockCfg#equip_wash_unlock_lv_cfg.unlock_lv ->
            {false, ?ERRCODE(err152_role_lv_not_satisfy_wash_lv)};
        true ->
            WashCostCfg = lists:keyfind(LockNum, 1, WashCfg#equip_wash_cfg.wash_cost),
%%          额外消耗
            PurplePlusCost = lists:keyfind(LockNum, 1, WashCfg#equip_wash_cfg.extra_cost),  % 改为必出橙色及以上
            RedPlusCost = lists:keyfind(LockNum, 1, WashCfg#equip_wash_cfg.extra_red_cost),
            OrangePlusCost = lists:keyfind(LockNum, 1, WashCfg#equip_wash_cfg.extra_orange_cost),
%%          需要的洗练槽位
            WashPosList = [TmpAttrPos || {TmpAttrPos, _TmpColor, _TmpAttrId, _TmpAttrVal} <- WashAttrList,
                lists:member(TmpAttrPos, LockAttrList) == false],
%%          属性列表
            AttrWeightList = lists:filter(
                fun({_W, TmpAttrId}) ->
                    case lists:keyfind(TmpAttrId, 3, WashAttrList) of
                        {TmpAttrPos, _TmpColor, _TmpAttrId, _TmpAttrVal} ->
                            lists:member(TmpAttrPos, WashPosList);
                        false -> true
                    end
                end, WashCfg#equip_wash_cfg.attr),
            if
                WashCostCfg == false orelse PurplePlusCost == false orelse RedPlusCost == false orelse OrangePlusCost == false ->
                    {false, ?ERRCODE(err_config)};
            %%  属性列表与部位的数量不同
                length(WashPosList) > length(AttrWeightList) -> {false, ?ERRCODE(err_config)};
                true ->
                    {_, NormalCost} = WashCostCfg,   % 普通消耗
                    UseTimes = mod_daily:get_count(RoleId, ?MOD_EQUIP, ?FREE_COUNT_ID),
                    NewNormalCost =   % 免费减除基础消耗
                    case (?FREE_TIMES - UseTimes) > 0 of
                        true -> [];
                        false ->
                            case RatioPlus of
                                1 -> [];   % 紫色不消耗洗练石
                                _ -> NormalCost
                            end
                    end,
                    RatioPlusCost =   % 额外消耗
                    case RatioPlus of   %是否有额外的消耗
                        0 ->    % 普通洗练
                            CheckList =
                                [{check_wash_nomal_cost, PS, NewNormalCost}],
                            [];
                        1 ->    % 1 紫色保底
                            {_, RCost} = PurplePlusCost,
                            CheckList =
                                [
%%                                    {check_wash_nomal_cost, PS, NewNormalCost},
                                    {check_wash_extra_cost, PS, RCost}],   % 显示钻石不足
                            RCost;
                        2 ->    % 2：红色保底
                            {_, RCost} = RedPlusCost,
                            CheckList =
                                [{check_wash_nomal_cost, PS, NewNormalCost},
                                    {check_object_cost, PS, RCost}],
                            RCost;
                        3 ->       % 3：橙色保底
                            {_, RCost} = OrangePlusCost,
                            CheckList =
                                [{check_wash_nomal_cost, PS, NewNormalCost},
                                    {check_object_cost, PS, RCost}],
                            RCost
                    end,
                    case checklist(CheckList) of
                        true ->
                            TotalCost = ulists:object_list_plus([NewNormalCost, RatioPlusCost]),
                            {true, EquipInfo, AttrWeightList, WashPosList, TotalCost};
                        {false, Res} -> {false, Res}
                    end
            end
    end.

upgrade_division(PS, GoodsStatus, EquipPos, AutoBuy) ->
    #goods_status{
        equip_wash_map = EquipWashMap
    } = GoodsStatus,
    #equip_wash{
        duan = Division,
        wash_rating = WashRating,
        attr = OneWashList
    } = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    WashCfg = data_equip:get_wash_cfg(EquipPos, Division),
    NextWashCfg = data_equip:get_wash_cfg(EquipPos, Division + 1),
    WashPosUnlockLv = data_equip:get_wash_unlock_lv(EquipPos),
    if
        is_record(WashCfg, equip_wash_cfg) == false -> {false, ?ERRCODE(missing_config)};
        is_record(NextWashCfg, equip_wash_cfg) == false -> {false, ?ERRCODE(err152_max_division)};
%%        length(OneWashList) < 4 -> {false, ?ERRCODE(err152_attr_num_not_satisfy_division)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_no_equip_can_not_upgrade_division)};
        PS#player_status.figure#figure.lv < WashPosUnlockLv#equip_wash_unlock_lv_cfg.unlock_lv ->
%%            ?PRINT("Lv :~p washposlv :~p~n", [PS#player_status.figure#figure.lv, WashPosUnlockLv#equip_wash_unlock_lv_cfg.unlock_lv]),
            {false, ?ERRCODE(err152_role_lv_not_satisfy_wash_lv)};
        true ->
            #equip_wash_cfg{need_rating = UpgradeScore, up_cost = UpgradeCost, need_stage = NeedStage} = WashCfg,
            EquipStage = lib_equip:get_equip_stage(EquipInfo),
            if
                EquipStage < NeedStage -> {false, ?ERRCODE(err152_not_upgrade_stage_quality)};
                UpgradeScore == 0 -> {false, ?ERRCODE(err152_max_division)};
                WashRating < UpgradeScore -> {false, ?ERRCODE(err152_rating_not_satisfy_division)};
                true ->
                    CheckList = [{check_object_cost, PS, UpgradeCost}],
                    case checklist(CheckList) of
                        true ->
                            WashPosList = [TmpAttrPos || {TmpAttrPos, _TmpColor, _TmpAttrId, _TmpAttrVal} <- OneWashList],
                            AttrWeightList = NextWashCfg#equip_wash_cfg.attr,
                            {true, EquipInfo, Division, Division + 1, UpgradeCost, AttrWeightList, WashPosList};
                        {false, Res} ->
                            case AutoBuy == 0 of
                                true ->
                                    {false, Res} ;
                                false ->
                                    case lib_goods_api:calc_auto_buy_list(UpgradeCost) of  % 判断购买时情况
                                        {ok, NewPrice} ->
                                            CheckList1 = [{check_object_cost, PS, NewPrice}],
                                            case checklist(CheckList1) of
                                                true ->
                                                    WashPosList = [TmpAttrPos || {TmpAttrPos, _TmpColor, _TmpAttrId, _TmpAttrVal} <- OneWashList],
                                                    AttrWeightList = NextWashCfg#equip_wash_cfg.attr,
                                                    {true, EquipInfo, Division, Division + 1, NewPrice, AttrWeightList, WashPosList};
                                                {false, Res1} ->
                                                    {false, Res1}
                                            end;
                                        _ ->
                                            {false, ?GOODS_NOT_ENOUGH}
                                    end
                            end
                    end
            end
    end.

equip_stone(PS, GoodsStatus, EquipPos, StonePos, GoodsId) ->
    #player_status{figure = #figure{vip_type = VipType, vip = VipLv}} = PS,
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    CheckList = [
        {check_base, PS, GoodsInfo},
        {check_location, GoodsInfo, ?GOODS_LOC_BAG},
        {check_equip_pos_correct, EquipPos},
        {check_has_equip, EquipPos, GoodsStatus#goods_status.equip_location},
        {check_inlay_pos_unlock, GoodsStatus, VipType, VipLv, EquipPos, StonePos},
        {check_equip_stone, EquipPos, StonePos, GoodsInfo}
    ],
    case checklist(CheckList) of
        true -> {true, GoodsInfo};
        {false, Res} -> {false, Res}
    end.

unequip_stone(GoodsStatus, EquipPos, StonePos) ->
    StoneInfo = lib_equip:get_stone_by_pos(GoodsStatus, EquipPos, StonePos),
    if
        is_record(StoneInfo, stone_info) == false -> {false, ?ERRCODE(err152_pos_no_stone)};
        true ->
            #stone_info{bind = Bind, gtype_id = GTypeId} = StoneInfo,
            CheckList = [
                {check_null_cells, [{?TYPE_GOODS, GTypeId, 1, Bind}]},
                {check_has_equip, EquipPos, GoodsStatus#goods_status.equip_location}
            ],
            case checklist(CheckList) of
                true -> {true, StoneInfo};
                {false, Res} -> {false, Res}
            end
    end.

upgrade_stone_on_equip(PS, GoodsStatus, EquipPos, StonePos, IsOneKey) ->
    StoneInfo = lib_equip:get_stone_by_pos(GoodsStatus, EquipPos, StonePos),
    if
        is_record(StoneInfo, stone_info) == false -> {false, ?ERRCODE(err152_pos_no_stone)};
        true ->
            #stone_info{bind = _Bind, gtype_id = GTypeId} = StoneInfo,
            StoneLvCfg = data_equip:get_stone_lv_cfg(GTypeId),
            CheckList = [
                {check_has_equip, EquipPos, GoodsStatus#goods_status.equip_location},
                {check_base_config, StoneLvCfg, equip_stone_lv_cfg},
                {check_stone_next_lv, GTypeId}
            ],
            case checklist(CheckList) of
                true ->
                    #equip_stone_lv_cfg{next_lv_stone = NextLvStoneId, need_num = NeedNum} = StoneLvCfg,
                    case IsOneKey of
                        0 ->
                            {_, GoodsTypeList} = lib_equip:combine_stone_one_key_cost(PS, GTypeId, NeedNum - 1),
                            CostList = [{?TYPE_GOODS, GoodsTypeId, Num} || {GoodsTypeId, Num} <- GoodsTypeList];
                        1 ->
                            {_, GoodsTypeList} = lib_equip:combine_stone_one_key_cost(PS, GTypeId, NeedNum - 1),
                            CostList = [{?TYPE_GOODS, GoodsTypeId, Num} || {GoodsTypeId, Num} <- GoodsTypeList];
                        2 ->
                            CostList = data_key_value:get(1520001) %% 宝石直升丹id
                    end,
                    case lib_goods_api:check_object_list(PS, CostList) of
                        true -> {true, StoneInfo, NextLvStoneId, NeedNum, CostList};
                        {false, Res} -> {false, Res}
                    end;
                {false, Res} -> {false, Res}
            end
    end.

combine_stone(PS, _GoodsStatus, GoodsTypeId, IsOneKey) ->
    %GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    CheckList = [
        {check_stone_next_lv, GoodsTypeId}
    ],
    case checklist(CheckList) of
        true ->
            #equip_stone_lv_cfg{next_lv_stone = NextLvStone, need_num = NeedNum} = data_equip:get_stone_lv_cfg(GoodsTypeId),
            case IsOneKey == 1 of
                false ->
                    {_, GoodsTypeList} = lib_equip:combine_stone_one_key_cost(PS, GoodsTypeId, NeedNum),
                    CostList = [{?TYPE_GOODS, TypeId, Num} || {TypeId, Num} <- GoodsTypeList];
                _ ->
                    {_, GoodsTypeList} = lib_equip:combine_stone_one_key_cost(PS, GoodsTypeId, NeedNum),
                    CostList = [{?TYPE_GOODS, TypeId, Num} || {TypeId, Num} <- GoodsTypeList]
            end,
            case lib_goods_api:check_object_list(PS, CostList) of
                true ->
                    case checklist([{check_null_cells, [{?TYPE_GOODS, NextLvStone, 1}]}]) of
                        true ->
                            {true, CostList, NextLvStone, 1};
                        {false, Res} ->
                            {false, Res}
                    end;
                {false, Res} -> {false, Res}
            end;
        {false, Res} -> {false, Res}
    end.


stone_refine(PS, GoodsStatus, EquipPos, GTypeId, OneKey) ->
    RoleLv = PS#player_status.figure#figure.lv,
    PosStoneInfo = lists:keyfind(EquipPos, 1, GoodsStatus#goods_status.equip_stone_list),
    {EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    #equip_stone{refine_lv = RefineLv, exp = Exp} = PosStoneInfoR,
    RefineLvCfg = data_equip:get_refine_cfg(EquipPos, RefineLv),
    NextRefineLvCfg = data_equip:get_refine_cfg(EquipPos, RefineLv + 1),
    IsOpen = lib_module:is_open(?MOD_EQUIP, 5, RoleLv),
    CanRefine = can_stone_refine(EquipPos, GoodsStatus),
    ExpPlus = data_equip:get_get_refine_goods_exp(GTypeId, EquipPos),
    if
        ExpPlus == 0 -> {false, ?ERRCODE(err150_type_err)};
        is_record(RefineLvCfg, equip_stone_refine_cfg) == false ->
            {false, ?ERRCODE(err_config)};
        is_record(NextRefineLvCfg, equip_stone_refine_cfg) == false ->
            {false, ?ERRCODE(err152_max_refine_lv)};
        IsOpen == false -> {false, ?ERRCODE(lv_limit)};
        RefineLvCfg#equip_stone_refine_cfg.exp == 0 ->
            {false, ?ERRCODE(err152_max_refine_lv)};
        CanRefine /= true ->
            {false, ?ERRCODE(err152_stone_refine_limit)};
        true ->
            case OneKey of
                1 ->
                    ExpGap = ?IF(RefineLvCfg#equip_stone_refine_cfg.exp > Exp, RefineLvCfg#equip_stone_refine_cfg.exp - Exp, 0),
                    StoneRefineList = data_equip:get_stone_refine_goods(EquipPos),
                    F = fun({NewGTypeId, NewExpPlus}, {ExpGapTmp, AccCost, AccExpPlus}) ->
                        case ExpGapTmp > 0 of
                            true ->
                                case data_goods_type:get(NewGTypeId) of
                                    #ets_goods_type{bag_location = BagLocation} ->
                                        GoodsList = lib_goods_util:get_type_goods_list(PS#player_status.id, NewGTypeId, BagLocation, GoodsStatus#goods_status.dict),
                                        TotalNum = lib_goods_util:get_goods_totalnum(GoodsList);
                                    _ ->
                                        TotalNum = 0
                                end,
                                CostGoodsNum1 = umath:ceil(ExpGapTmp / NewExpPlus),
                                CostGoodsNum = ?IF(CostGoodsNum1 =< TotalNum, CostGoodsNum1, TotalNum),
                                ExpPlusTmp = CostGoodsNum * NewExpPlus,
                                NewAccCost = ?IF(CostGoodsNum == 0, AccCost, [{?TYPE_GOODS, NewGTypeId, CostGoodsNum}|AccCost]),
                                NewExpGapTmp = ExpGapTmp - ExpPlusTmp,
                                NewAccExpPlus = AccExpPlus + ExpPlusTmp,
                                {NewExpGapTmp, NewAccCost, NewAccExpPlus};
                            _ ->
                                {ExpGapTmp, AccCost, AccExpPlus}
                        end
                    end,
                    {_, Cost, ExpPlusAll} = lists:foldl(F, {ExpGap, [], 0}, StoneRefineList);
                _ ->
                    Cost = [{?TYPE_GOODS, GTypeId, 1}],
                    ExpPlusAll = ExpPlus
            end,
            CheckList = [
                {check_object_cost, PS, Cost}
            ],
            case checklist(CheckList) of
                true -> {true, ExpPlusAll, Cost};
                {false, Res} -> {false, Res}
            end
    end.

make_suit_check(PS, EquipInfo, EquipPos, Lv, SLv) ->
    Stage = lib_equip:get_equip_stage(EquipInfo),
    SuitType = lib_equip:get_suit_type(EquipPos),
    case SuitType of
        ?EQUIPMENT -> NewSLv = SLv;
        ?ACCESSORY -> NewSLv = SLv+1
    end,
    Sex = PS#player_status.figure#figure.sex,
    SuitMakeCfg = data_equip_suit:get_make_cfg(EquipPos, Lv, NewSLv),
    CheckList = [
        {check_suit_lv, Lv},                                % 套装级别是否合法
        {check_stage_lv, Stage},                            % 阶数是否合法
        {check_cur_stage_max, SuitType, Stage, SLv},        % 是否达到装备所限制的阶数（针对饰品）
        {check_is_activated, SuitType, EquipPos, Lv},       % 当前套装位置是否激活（针对武防）
        {check_config_condition, SuitMakeCfg, EquipInfo},   % 配置中的检查项
        {check_exist, EquipInfo},                           % 物品是否存在
        {check_cost, Sex, SuitMakeCfg}                      % 物品是否足够
    ],
    case checklist(CheckList) of
        true ->
            CostList = SuitMakeCfg#suit_make_cfg.cost,
            {_, SexCostList} = lists:keyfind(Sex, 1, CostList),
            {ok, MoneyList, DelGoodsList} = lib_goods_api:calc_cost_goods(SexCostList),
            {true, EquipPos, NewSLv, SexCostList, MoneyList, DelGoodsList};
        Error ->
            Error
    end.

new_make_suit_rule_check(PS, EquipInfo, EquipPos, MakeType, CurMakeLv) ->
    NewMakeLv = CurMakeLv + 1,
    Sex = PS#player_status.figure#figure.sex,
    SuitMakeCfg = data_equip_suit:get_make_cfg(EquipPos, MakeType, NewMakeLv),
    CheckList = [
        {check_suit_lv, MakeType},                          % 套装共鸣类型是否合法
        {check_config_condition, SuitMakeCfg, EquipInfo},   % 配置中的检查项
        {check_exist, EquipInfo},                           % 物品是否存在
        {check_cost, Sex, SuitMakeCfg}                      % 物品是否足够
    ],
    case checklist(CheckList) of
        true ->
            CostList = SuitMakeCfg#suit_make_cfg.cost,
            {_, SexCostList} = lists:keyfind(Sex, 1, CostList),
            {ok, MoneyList, DelGoodsList} = lib_goods_api:calc_cost_goods(SexCostList),
            {true, EquipPos, NewMakeLv, SexCostList, MoneyList, DelGoodsList};
        Error ->
            Error
    end.

casting_spirit_check(PS, GoodsStatus, EquipPos) ->
    #goods_status{
        equip_casting_spirit = EquipCastingSpiritL
    } = GoodsStatus,
    case lists:keyfind(EquipPos, #equip_casting_spirit.pos, EquipCastingSpiritL) of
        #equip_casting_spirit{stage = Stage, lv = Lv} -> skip;
        _ -> Stage = 1, Lv = 0 %% 默认1阶 0级
    end,
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    StageCfg = data_equip_spirit:get_stage_cfg(EquipPos, Stage),
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    EquipStage = lib_equip:get_equip_stage(EquipInfo),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_pos_no_equip)};
        EquipStage < ?CASTING_SPIRIT_MIN_STAGE -> {false, ?ERRCODE(err152_casting_spirit_equip_stage_not_enough)};
        true ->
            #casting_spirit_stage_cfg{max_lv = MaxLv} = StageCfg,
            case Lv >= MaxLv of
                true ->
                    NewStage = Stage + 1,
                    NewLv = 1;
                false ->
                    NewStage = Stage,
                    NewLv = Lv + 1
            end,
            LvCfg = data_equip_spirit:get_lv_cfg(EquipPos, Stage, Lv),
            NextStageCfg = data_equip_spirit:get_stage_cfg(EquipPos, NewStage),
            NextLvCfg = data_equip_spirit:get_lv_cfg(EquipPos, NewStage, NewLv),
            if
                MaxLv == Lv andalso is_record(NextStageCfg, casting_spirit_stage_cfg) == false ->
                    {false, ?ERRCODE(err152_casting_spirit_max_lv)};
                is_record(NextStageCfg, casting_spirit_stage_cfg) == false ->
                    {false, ?ERRCODE(missing_config)};
                is_record(NextLvCfg, casting_spirit_lv_cfg) == false ->
                    {false, ?ERRCODE(missing_config)};
                is_record(LvCfg, casting_spirit_lv_cfg) == false ->
                    {false, ?ERRCODE(missing_config)};
                true ->
                    #casting_spirit_stage_cfg{score = OpenScore} = NextStageCfg,
                    #casting_spirit_lv_cfg{cost = Cost} = LvCfg,
                    GPTScore = lib_dungeon_evil:get_history_max_score(PS),
                    if
                        GPTScore < OpenScore -> %% 当前阶未开启
                            {false, ?ERRCODE(err152_casting_spirit_lv_lim)};
                        true ->
                            case lib_goods_api:check_object_list(PS, Cost) of
                                true ->
                                    {true, EquipInfo, Cost, Stage, Lv, NewStage, NewLv};
                                {false, _ErrorCode} ->
                                    {false, ?ERRCODE(err152_casting_spirit_material_not_enough)}
                            end
                    end
            end
    end.

awakening_check(PS, GoodsStatus, EquipPos) ->
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 9),
    EquipStage = lib_equip:get_equip_stage(EquipInfo),
    EquipStar = lib_equip:get_equip_star(EquipInfo),
    LvLim = data_equip_awakening:get_lv_lim(EquipStage),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_pos_no_equip)};
        EquipStage < ?EQUIP_AWAKENING_MIN_STAGE orelse EquipStar < ?EQUIP_AWAKENING_MIN_START orelse EquipInfo#goods.color < ?ORANGE ->
            {false, ?ERRCODE(err152_not_awakening_equip)};
        true ->
            AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
            if
                AwakeningLv >= LvLim -> {false, ?ERRCODE(err152_awakening_lv_lim)};
                true ->
                    LvCfg = data_equip_awakening:get_lv_cfg(EquipPos, AwakeningLv),
                    NextLvCfg = data_equip_awakening:get_lv_cfg(EquipPos, AwakeningLv + 1),
                    if
                        is_record(LvCfg, equip_awakening_lv_cfg) == false -> {false, ?ERRCODE(err_config)};
                        is_record(NextLvCfg, equip_awakening_lv_cfg) == false -> {false, ?ERRCODE(missing_config)};
                        true ->
                            #equip_awakening_lv_cfg{cost = Cost} = LvCfg,
                            case lib_goods_api:check_object_list(PS, Cost) of
                                true ->
                                    {true, EquipInfo, Cost, AwakeningLv, AwakeningLv + 1};
                                {false, _ErrorCode} ->
                                    {false, ?ERRCODE(err152_awakening_cost_not_enough)}
                            end
                    end
            end
    end.

upgrade_spirit_check(PS, GoodsStatus) ->
    #goods_status{
        equip_spirit = EquipSpirit
    } = GoodsStatus,
    #equip_spirit{lv = Lv} = EquipSpirit,
    NewLv = Lv + 1,
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    LvCfg = data_equip_spirit:get_spirit_lv_cfg(Lv),
    NextLvCfg = data_equip_spirit:get_spirit_lv_cfg(NewLv),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(LvCfg, spirit_lv_cfg) == false ->
            {false, ?ERRCODE(missing_config)};
        is_record(NextLvCfg, spirit_lv_cfg) == false ->
            {false, ?ERRCODE(err152_spirit_max_lv)};
        true ->
            #spirit_lv_cfg{cost = Cost} = LvCfg,
            case lib_goods_api:check_object_list(PS, Cost) of
                true ->
                    {true, Cost, Lv, NewLv};
                {false, _ErrorCode} ->
                    {false, ?ERRCODE(err152_upgrade_spirit_material_not_enough)}
            end
    end.

add_equip_skill_check(PS, GoodsStatus, EquipPos, NewSkillId) ->
    #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_pos_no_equip)};
        true ->
            AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
            case lists:keyfind(EquipPos, #equip_skill.pos, EquipSkillL) of
                #equip_skill{skill_id = OldSkillId} -> skip;
                _ -> OldSkillId = 0
            end,
            SkillBaseCfg = data_skill:get(NewSkillId, 1),
            EquipSkillCfgL = data_equip_awakening:get_skill_list(EquipPos),
            EquipSkillLvCfg = data_equip_awakening:get_skill_lv_cfg(NewSkillId, 1),
            if
                AwakeningLv < 1 -> {false, ?ERRCODE(err152_equip_skill_awakening_lim)};
                OldSkillId =/= 0 -> {false, ?ERRCODE(err152_equip_skill_has_skill)};
                is_record(SkillBaseCfg, skill) == false -> {false, ?ERRCODE(err152_equip_skill_cfg_err)};
                is_record(EquipSkillLvCfg, equip_skill_lv_cfg) == false ->
                    {false, ?ERRCODE(err152_equip_skill_cfg_err)};
                true ->
                    case lists:member(NewSkillId, EquipSkillCfgL) of
                        true ->
                            #equip_skill_lv_cfg{cost = Cost} = EquipSkillLvCfg,
                            case lib_goods_api:check_object_list(PS, Cost) of
                                true ->
                                    {true, EquipInfo, Cost};
                                {false, _ErrorCode} ->
                                    {false, ?ERRCODE(err152_equip_skill_no_cost_to_add_skill)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err152_equip_skill_skill_type_lim)}
                    end
            end
    end.

-define(EQUIP_SKILL_REMOVE_COST, [{?TYPE_COIN, ?GOODS_ID_COIN, 500000}]).
remove_equip_skill_check(PS, GoodsStatus, EquipPos) ->
    #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_pos_no_equip)};
        true ->
            case lists:keyfind(EquipPos, #equip_skill.pos, EquipSkillL) of
                #equip_skill{skill_id = OldSkillId, skill_lv = OldSkillLv} -> skip;
                _ -> OldSkillId = 0, OldSkillLv = 0
            end,
            if
                OldSkillId == 0 -> {false, ?ERRCODE(err152_equip_skill_no_skill_to_remove)};
                true ->
                    case lib_goods_api:check_object_list(PS, ?EQUIP_SKILL_REMOVE_COST) of
                        true ->
                            {true, ?EQUIP_SKILL_REMOVE_COST, OldSkillId, OldSkillLv};
                        {false, _ErrorCode} ->
                            {false, ?ERRCODE(err152_equip_skill_no_cost_to_remove)}
                    end
            end
    end.

upgrade_equip_skill_check(PS, GoodsStatus, EquipPos) ->
    #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(EquipInfo, goods) == false -> {false, ?ERRCODE(err152_pos_no_equip)};
        true ->
            EquipSkillInfo = lists:keyfind(EquipPos, #equip_skill.pos, EquipSkillL),
            if
                is_record(EquipSkillInfo, equip_skill) == false ->
                    {false, ?ERRCODE(err152_equip_skill_no_skill_to_upgrade)};
                true ->
                    #equip_skill{skill_id = SkillId, skill_lv = OldSkillLv} = EquipSkillInfo,
                    AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
                    % EquipSkillLvCfg = data_equip_awakening:get_skill_lv_cfg(SkillId, OldSkillLv),
                    NextEquipSkillLvCfg = data_equip_awakening:get_skill_lv_cfg(SkillId, OldSkillLv + 1),
                    SkillBaseCfg = data_skill:get(SkillId, OldSkillLv + 1),
                    if
                        SkillId == 0 -> {false, ?ERRCODE(err152_equip_skill_no_skill_to_upgrade)};
                        OldSkillLv >= AwakeningLv -> {false, ?ERRCODE(err152_equip_skill_skill_lv_lim)};
                    % is_record(EquipSkillLvCfg, equip_skill_lv_cfg) == false -> {false, ?ERRCODE(err152_equip_skill_cfg_err)};
                        is_record(NextEquipSkillLvCfg, equip_skill_lv_cfg) == false ->
                            {false, ?ERRCODE(err152_equip_skill_skill_lv_lim)};
                        is_record(SkillBaseCfg, skill) == false -> {false, ?ERRCODE(err152_equip_skill_cfg_err)};
                    % EquipSkillLvCfg#equip_skill_lv_cfg.cost == [] -> {false, ?ERRCODE(err152_equip_skill_skill_lv_lim)};
                        true ->
                            #equip_skill_lv_cfg{cost = Cost} = NextEquipSkillLvCfg,
                            case lib_goods_api:check_object_list(PS, Cost) of
                                true ->
                                    {true, EquipInfo, Cost, EquipSkillInfo, EquipSkillInfo#equip_skill{skill_lv = OldSkillLv + 1}};
                                {false, _ErrorCode} ->
                                    {false, ?ERRCODE(err152_equip_skill_no_cost_upgrade)}
                            end
                    end
            end
    end.

can_stone_refine(EquipPos, GoodsStatus) ->
    Limit = data_equip:get_stone_refine_limit(EquipPos),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    if
        Limit == [] -> true;
        is_record(EquipInfo, goods) == false -> false;
        true ->
            [{Stage, Color}] = Limit,
            EquipStage = lib_equip:get_equip_stage(EquipInfo),
            #goods{color = EquipColor} = EquipInfo,
            CanRefine = (EquipStage >= Stage andalso EquipColor >= Color),
            CanRefine
    end.

check_satisfied_red_equip(RedEquipCon, [EquipPos, Stage, Star, Color, ClassType]) ->
    F = fun(Item) ->
        case Item of
            {equip_pos, EquipPosList} -> lists:member(EquipPos, EquipPosList);
            {color, ColorNeed} -> Color >= ColorNeed;
            {stage, StageNeed} -> Stage >= StageNeed;
            {star, StarNeed} -> Star >= StarNeed;
            {equip_class_type, ClassTypeNeed} -> ClassType == ClassTypeNeed;
            _ -> false
        end
    end,
    lists:all(F, RedEquipCon).

%% 配置记录是否正确
check({check_base_config, BaseConfig, ConfigName}) ->
    case is_record(BaseConfig, ConfigName) of
        true -> true;
        false -> {false, ?ERRCODE(err_config)}
    end;

%% 配置的基本检查项（物品是否存在、是否过期、是否达到使用等级）
check({check_base, PS, GoodsInfo}) ->
    CheckList = [
        {check_exist, GoodsInfo},
        {check_expire, GoodsInfo},
        {check_lv, GoodsInfo, PS#player_status.figure#figure.lv}
    ],
    checklist(CheckList);

%% 物品是否存在
check({check_exist, GoodsInfo}) ->
    case is_record(GoodsInfo, goods) of
        true ->
            case data_goods_type:get(GoodsInfo#goods.goods_id) of
                #ets_goods_type{} -> true;
                _ -> {false, ?ERRCODE(err150_no_goods)}
            end;
        false -> {false, ?ERRCODE(err150_no_goods)}
    end;

%% 装备是否未强化
check({check_stren_lv, GoodsStatus, EquipPos}) ->
    #equip_stren{
        stren = Stren
    } = lib_equip:get_stren(GoodsStatus, EquipPos),
    case Stren == 0 of
        true -> true;
        false -> {false, ?ERRCODE(err152_has_stren_cant_unequip)}
    end;

%% 装备是否有洗炼属性
check({check_has_wash_attr, GoodsStatus, EquipPos}) ->
    #equip_wash{
        attr = Attr
    } = lib_equip:get_wash_info_by_pos(GoodsStatus, EquipPos),
    case Attr == [] of
        true -> true;
        false -> {false, ?ERRCODE(err152_has_wash_cant_unequip)}
    end;

%% 装备是否未唤醒
check({check_has_awakening, GoodsStatus, EquipPos}) ->
    #goods_status{
        equip_awakening_list = EquipAwakeningL
    } = GoodsStatus,
    case lists:keyfind(EquipPos, #equip_awakening.pos, EquipAwakeningL) of
        #equip_awakening{lv = Lv} when Lv > 0 ->
            {false, ?ERRCODE(err152_has_awakening_cant_unequip)};
        _ -> true
    end;

%% 物品是否过期
check({check_expire, GoodsInfo}) ->
    NowTime = utime:unixtime(),
    case GoodsInfo#goods.expire_time > 0 andalso
        GoodsInfo#goods.expire_time =< NowTime of
        true -> {false, ?ERRCODE(err152_expire_err)};
        false -> true
    end;

%% 物品是否达到等级
check({check_lv, GoodsInfo, Lv}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    case G#ets_goods_type.level =< Lv of
        true -> true;
        false -> {false, ?ERRCODE(err152_lv_err)}
    end;

%%chenyiming-20180802- 现在装备有可能在神器背包和装备背包里
check({check_location, GoodsInfo, LocList}) when is_list(LocList) ->
    case lists:member(GoodsInfo#goods.location, LocList) of
        true -> true;
        false -> {false, ?ERRCODE(err152_location_err)}
    end;
check({check_location, GoodsInfo, Loc}) ->
    case GoodsInfo#goods.location == Loc of
        true -> true;
        false -> {false, ?ERRCODE(err152_location_err)}
    end;

%% 物品是否指定类型
check({check_goods_type, GoodsInfo, Type}) ->
    case GoodsInfo#goods.type == Type of
        true -> true;
        false -> {false, ?ERRCODE(err152_type_err)}
    end;

%% 装备类型是否合法
check({check_equip_type, GoodsInfo}) ->
    EquipNum = data_goods:get_config(equip_num),
    case GoodsInfo#goods.equip_type > 0 andalso GoodsInfo#goods.equip_type =< EquipNum of
        true -> true;
        false -> {false, ?ERRCODE(err152_equip_type_error)}
    end;

%% 物品是否足够(弃用)
check({check_goods_num, PS, GoodsTypeList}) ->
    case lib_goods_api:check_goods_num(PS, lib_goods_api:trans_object_format(GoodsTypeList)) of
        1 -> true;
        _ -> {false, ?ERRCODE(err150_num_err)}
    end;

%% 物品职业属性合法性
check({check_career, GoodsInfo, Career}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.career == 0 -> true;
        G#ets_goods_type.career == Career -> true;
        true -> {false, ?ERRCODE(err152_career_error)}
    end;

%% 玩家是否有足够货币
check({check_enough_money, PS, Num, MoneyType}) ->
    case lib_goods_util:is_enough_money(PS, Num, MoneyType) of
        false -> {false, ?ERRCODE(err150_no_money)};
        true -> true
    end;

%% 背包是否还有空位
check({check_null_cells, GoodsStatus}) when is_record(GoodsStatus, goods_status) ->
    HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_BAG),
    if
        HaveCellNum < 1 ->
            {false, ?ERRCODE(err150_no_cell)};
        true -> true
    end;
%%根据物品默认的背包类型来去检查背包是否有位置	chenyiming-20180802
check({check_null_cells, GoodsStatus, GoodTypeId}) when is_record(GoodsStatus, goods_status) ->
    GoodsType = data_goods_type:get(GoodTypeId),
    Location = GoodsType#ets_goods_type.bag_location,
    HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, Location),
    if
        HaveCellNum < 1 ->
            {false, ?ERRCODE(err150_no_cell)};
        true -> true
    end;
%% -----------------------------------------------------------------
%% @desc     功能描述  穿戴装备时 检查背包格子是否支持 针对替换情况 chenyiming-20180802
%% @param    参数      GoodsStatus::#gooods_status{},
%%                    OlddefaultLocation::integer 装备在身上装备默认的背包位置
%%                    NewdefaultLocation::integer  将要穿戴装备的默认的背包位置
%% @return   返回值    true|{false,Res}
%% @history  修改历史
%% -----------------------------------------------------------------
check({check_null_cells, GoodsStatus, OldDefaultLocation, NewDefaultLocation}) ->
    case OldDefaultLocation == NewDefaultLocation of
        true ->  %%同背包替换，没有问题
            true;
        false -> %%不同背包替换,检查装备在身上的默认背包格子情况
            HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, OldDefaultLocation),
            if
                HaveCellNum < 1 ->
                    {false, ?ERRCODE(err150_no_cell)};
                true -> true
            end
    end;
check({check_null_cells, GoodsTypeList}) when is_list(GoodsTypeList) ->
    case lib_goods_do:can_give_goods(GoodsTypeList) of
        true -> true;
        {false, ErrorCode} -> {false, ErrorCode}
    end;

%% 装备强化等级是否合法
check({check_stren_max, _EquipPos, _EquipInfo, []}) -> true;
check({check_stren_max, EquipPos, EquipInfo, EquipStren}) ->
    Stren = EquipStren#equip_stren.stren,
    StrenMax = data_equip:strengthen_max(lib_equip:get_equip_stage(EquipInfo), EquipInfo#goods.color, EquipPos),
    if
        Stren >= StrenMax ->
            {false, ?ERRCODE(err152_stren_limit)};
        true -> true
    end;

%% 装备精炼等级是否合法
check({check_refine_max, _EquipPos, _EquipInfo, []}) -> true;
check({check_refine_max, EquipPos, EquipInfo, EquipRefine}) ->
    Refine = EquipRefine#equip_refine.refine,
    RefineMax = data_equip:refine_max(lib_equip:get_equip_stage(EquipInfo), EquipInfo#goods.color, EquipPos),
    if
        Refine >= RefineMax ->
            {false, ?ERRCODE(err152_refine_limit)};
        true -> true
    end;

%% 检查强化消耗
check({check_stren_cost, PS, Cfg}) when is_record(Cfg, base_equip_stren) ->
    check({check_object_cost, PS, Cfg#base_equip_stren.object_list});

check({check_stren_cost, PS, ObjectList}) ->
    check({check_object_cost, PS, ObjectList});

%% 检查精炼消耗
check({check_refine_cost, PS, Cfg}) when is_record(Cfg, base_equip_refine) ->
    check({check_object_cost, PS, Cfg#base_equip_refine.object_list});

check({check_refine_cost, PS, ObjectList}) ->
    check({check_object_cost, PS, ObjectList});


check({check_upgrade_stage_cost, PS, Cfg}) when is_record(Cfg, equip_upgrade_stage_cfg) ->
    check({check_object_cost, PS, Cfg#equip_upgrade_stage_cfg.cost});

%% 免费的不用检查
check({check_wash_nomal_cost, _PS, Cost}) when Cost == [] ->
    true;
check({check_wash_nomal_cost, PS, Cost}) ->
    case check({check_object_cost, PS, Cost}) of
        true -> true;
        {false, _Res} -> {false, ?ERRCODE(err152_wash_normal_cost_not_enough)}
    end;

check({check_wash_extra_cost, PS, Cost}) ->
    case check({check_object_cost, PS, Cost}) of
        true -> true;
        {false, _Res} -> {false, ?ERRCODE(err152_wash_extra_cost_not_enough)}
    end;

check({check_object_cost, PS, ObjectList}) when ObjectList =/= [] ->
    case lib_goods_api:check_object_list(PS, ObjectList) of
        true -> true;
        {false, Res} -> {false, Res}
    end;

check({check_object_cost, _PS, _ObjectList}) ->
    {false, ?GOODS_NOT_ENOUGH};

check({check_config, Cfg, MissDefault}) ->
    case Cfg of
        MissDefault -> {false, ?ERRCODE(err152_missing_cfg)};
        _ -> true
    end;

check({check_upgrade_stage, EquipInfo, Cfg}) ->
    #goods{goods_id = GoodsId, color = Color, location = Location, equip_type = EquipType} = EquipInfo,
    #equip_upgrade_stage_cfg{ngoods_id = NextStageGoodsId} = Cfg,
    #equip_attr_cfg{stage = CurStage} = data_equip:get_equip_attr_cfg(GoodsId),
    IsUpgradeStageType = lists:member(EquipType, [?EQUIP_BRACELET, ?EQUIP_RING]),
    if
        IsUpgradeStageType == false -> {false, ?ERRCODE(err152_not_upgrade_stage_pos)};
        Location =/= ?GOODS_LOC_EQUIP -> {false, ?ERRCODE(err152_not_equip_cannot_upgrade_stage)};
        CurStage < 7 orelse Color < ?PURPLE -> {false, ?ERRCODE(err152_not_upgrade_stage_quality)};
        NextStageGoodsId == 0 -> {false, ?ERRCODE(err152_max_stage)};
        true ->
            case data_goods_type:get(NextStageGoodsId) of
                #ets_goods_type{} ->
                    case data_equip:get_equip_attr_cfg(NextStageGoodsId) of
                        #equip_attr_cfg{} -> true;
                        % #equip_attr_cfg{} -> {false, ?ERRCODE(err_config)};
                        _ -> {false, ?ERRCODE(missing_config)}
                    end;
                _ -> {false, ?ERRCODE(missing_config)}
            end
    end;

check({check_inlay_pos_unlock, GoodsStatus, VipType, VipLv, EquipPos, StonePos}) when StonePos =< 6 ->
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
    Stage = lib_equip:get_equip_stage(EquipInfo),
    Condition = data_equip:get_inlay_pos_condition(EquipPos, StonePos),
    Fun = fun(T) ->
        case T of
            {stage, NeedStage} when Stage >= NeedStage -> true;
            {vip, NeedVipType, NeedVipLv} when VipType >= NeedVipType andalso VipLv >= NeedVipLv -> true;
            _ -> false
        end
          end,
    case lists:all(Fun, Condition) of
        true -> true;
        false -> {false, ?ERRCODE(err152_stone_pos_lock)}
    end;

check({check_equip_stone, EquipPos, _StonePos, GoodsInfo}) ->
    StoneCfg = data_equip:get_stone_lv_cfg(GoodsInfo#goods.goods_id),
    StoneTypeList = data_equip:get_inlay_stone_type(EquipPos),
    IsVaildStoneType = lists:member(GoodsInfo#goods.subtype, StoneTypeList),
    if
        is_record(StoneCfg, equip_stone_lv_cfg) == false ->
            {false, ?ERRCODE(missing_config)};
    % %% 该位置未穿戴装备
    % is_record(EquipInfo, goods) == false ->
    %     {false, ?ERRCODE(err152_pos_no_equip)};
    %% 该宝石不能镶嵌在本部位
        IsVaildStoneType == false ->
            {false, ?ERRCODE(err152_stone_part_err)};
        true -> true
    end;

%% 装备部位合法性
check({check_equip_pos_correct, EquipPos}) ->
    EquipNum = data_goods:get_config(equip_num),
    if
        EquipPos > EquipNum orelse EquipPos < 0 ->
            {false, ?ERRCODE(err152_equip_pos_err)};
        true -> true
    end;

%% 部位是否未装备
check({check_has_equip, EquipPos, EquipLocation}) ->
    case lists:keyfind(EquipPos, 1, EquipLocation) of
        false -> {false, ?ERRCODE(err152_pos_no_equip)};
        _ -> true
    end;

%% 转生是否合法
check({check_turn, GoodsInfo, RoleTurn}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.turn == 0 -> true;
        G#ets_goods_type.turn =< RoleTurn -> true;
        true -> {false, ?ERRCODE(err152_turn_error)}
    end;

%% 性别是否合法
check({check_sex, GoodsInfo, Sex}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.sex == 0 -> true;
        G#ets_goods_type.sex == Sex -> true;
        true -> {false, ?ERRCODE(err152_sex_error)}
    end;

check({check_has_refine, GoodsStatus, EquipPos}) ->
    #equip_stone{
        refine_lv = RefineLv,
        exp = Exp
    } = lib_equip:get_equip_stone_info_by_pos(GoodsStatus, EquipPos),
    case RefineLv == 0 andalso Exp == 0 of
        true -> true;
        false -> {false, ?ERRCODE(err152_has_refine_cant_unequip)}
    end;

%% 套装级别合法性
check({check_suit_lv, Lv}) ->
    SuitLvList = data_equip_suit:get_lvs(),
    case lists:member(Lv, SuitLvList) of
        true -> true;
        false -> {false, ?ERRCODE(err152_no_such_suit_lv)}
    end;

%% 阶数合法性
check({check_stage_lv, SLv}) ->
    LegalStages = data_equip_suit:get_legal_equip_stage(),
    MinStage = lists:min(LegalStages),
    MaxStage = lists:max(LegalStages),
    if
        SLv < MinStage -> {false, ?ERRCODE(err152_not_upgrade_stage_quality)};
        SLv > MaxStage -> {false, ?ERRCODE(err152_max_stage)};
        true -> true
    end;

%% 检查阶数合法性（针对饰品）
check({check_cur_stage_max, ?ACCESSORY, Stage, SLv}) ->
    SuitStageMax = data_equip_suit:get_suit_stage_max_decor(Stage),
    case SLv < SuitStageMax of
        true -> true;
        false -> {false, ?ERRCODE(err152_suit_stage_max_2)}
    end;
check({check_cur_stage_max, _Type, _Stage, _SLv}) -> true;  % 武防类型套装不做检查

% 当前套装位置是否激活（针对武防）
check({check_is_activated, ?EQUIPMENT, PosId, Lv}) ->
    GS = lib_goods_do:get_goods_status(),
    SuitList = GS#goods_status.equip_suit_list,
    case lists:keyfind({PosId, Lv}, #suit_item.key, SuitList) of
        false -> true;
        _ -> {false, ?ERRCODE(err152_suit_clt_is_active)}
    end;
check({check_is_activated, _Type, _PosId, _Lv}) -> true;    % 饰品类型套装不做检查

%% 套装的配置检查
check({check_config_condition, SuitMakeCfg, EquipInfo}) ->
    BaseCondition = SuitMakeCfg#suit_make_cfg.condition,
    ConfigCheckList = [{suit_condition, Item, EquipInfo} || Item <- BaseCondition],
    case checklist(ConfigCheckList) of
        true -> true;
        Error -> Error
    end;
check({suit_condition, Condition, EquipInfo}) ->
    case Condition of
        % 装备阶数是否合法
        {stage, Op, Value} ->
            Stage = lib_equip:get_equip_stage(EquipInfo),
            case ?OP(Stage, Op, Value) of
                true ->
                    true;
                _ ->
                    {false, ?ERRCODE(err152_make_suit_error)}
            end;
        % 装备稀有度或星级是否合法
        {quality, CValue, SValue} ->
            Star = lib_equip:get_equip_star(EquipInfo),
            Color = EquipInfo#goods.color,
            if
                Color > CValue orelse (Color =:= CValue andalso Star >= SValue) ->
                    true;
                true ->
                    {false, ?ERRCODE(err152_make_suit_error)}
            end;
        % 装备星级是否合法
        {star, Op, Value} ->
            Star = lib_equip:get_equip_star(EquipInfo),
            case ?OP(Star, Op, Value) of
                true ->
                    true;
                _ ->
                    {false, ?ERRCODE(err152_make_suit_error)}
            end;
        % 装备稀有度是否合法
        {color, Op, Value} ->
            Color = EquipInfo#goods.color,
            case ?OP(Color, Op, Value) of
                true ->
                    true;
                _ ->
                    {false, ?ERRCODE(err152_make_suit_error)}
            end;
        % 前置套装是否激活
        {activated, PosId, PreSuitLv} ->
            GS = lib_goods_do:get_goods_status(),
            SuitList = GS#goods_status.equip_suit_list,
            case lists:keyfind({PosId, PreSuitLv}, #suit_item.key, SuitList) of
                false -> {false, ?ERRCODE(err152_pre_suit_not_activate)};
                _ -> true
            end;
        {} ->
            true;
        _ ->
            {false, ?ERRCODE(err152_make_suit_error)}
    end;

%% 玩家物品是否足够消费
check({check_cost, Sex, SuitMakeCfg}) ->
    CostList = SuitMakeCfg#suit_make_cfg.cost,
    {_, SexCostList} = lists:keyfind(Sex, 1, CostList),
    case lib_goods_api:calc_cost_goods(SexCostList) of
        {ok, _, _} -> true;
        Error -> Error
    end;

check({check_stone_next_lv, GoodsTypeId}) ->
    case data_equip:get_stone_lv_cfg(GoodsTypeId) of
        #equip_stone_lv_cfg{next_lv_stone = NextLvStone} when NextLvStone > 0 ->
            case data_equip:get_stone_lv_cfg(NextLvStone) of
                #equip_stone_lv_cfg{} -> true;
                _ -> {false, ?MISSING_CONFIG}
            end;
        _ -> {false, ?ERRCODE(err152_stone_max_lv)}
    end;

check(X) ->
    ?INFO("equip_check error ~p~n", [X]),
    {false, ?FAIL}.

%% helper function

checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

