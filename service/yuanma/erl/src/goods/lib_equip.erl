%% ---------------------------------------------------------------------------
%% @doc 装备模块
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_equip).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("equip_suit.hrl").
-include("language.hrl").
-include("decoration.hrl").
-include("sql_goods.hrl").
-include("rec_offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([handle_event/2]).
-export([get_equip_stage/1, get_equip_star/1, get_equip_stage_and_star/1, get_equip_class_type/1]).
-export([equip/2, unequip/2]).
-export([stren/3, stren_info/2, get_stren/2, count_stren_total_lv/1, conver_stren_lv/4, refine_info/1, refine/3, get_refine/2]).
-export([upgrade_stage_preview/1, upgrade_stage/2, cal_attr_rating/2]).
-export([
    equip_stone/4,
    unequip_stone/3,
    stone_refine/4,
    cal_stone_rating/2,
    upgrade_stone_on_equip/4,
    combine_stone/3,
    combine_stone_one_key_cost/3
]).
-export([
    get_stone_by_pos/3,
    get_stone_list_by_pos/2,
    get_equip_by_location/2,
    get_equip_stone_info_by_pos/2,
    count_stone_total_power/1,
    count_stone_total_lv/1,
    get_one_equip_suit_attr/2,
    unload_stones/5,
    log_auto_unload_stone/4,
    return_goods_to_player/2
]).
-export([
    manual_whole_award/2,
    list_manual_whole_award/1,
    init_manual_whole_award/1,
    add_12_equip_award/2,
    get_12_equip_award/2,
    get_12_equip_manual_award/2,
    get_12_equip_award_from_list/3,
    update_12_equip_award/2,
    get_whole_refine_stren_ratio/2,
    recalc_12_equip_reward/3
]).
-export([gen_equip_other_attr/2, cal_equip_rating/2, cal_equip_overall_rating/3, cal_equip_overall_rating/2]).
-export([
    unlock_wash_pos/3
    , equip_wash/4
    , get_wash_info_by_pos/2
    , count_equip_wash_rating/1
    , upgrade_division/3
    , get_wash_attr_base_rating/1
]).

-export([
    make_suit/3
    , restore_suit/3
    , restore_suit_preview/3
    , suit_info/0
    , get_suit_info/2
    , get_initual_suit/1
    , normal_stage2suit_state/3
    , calc_suit_attr/1
    , calc_suit_state/1
    , update_suit/5
    , update_suit/3
    , get_suit_stage_min/2
    , get_equipment_suit_info/1
    , get_accessory_suit_info/1
]).

-export([is_equip/1]).

-export([
    casting_spirit/2
    , upgrade_spirit/1
    , count_casting_spirit_attr/2
    , count_casting_spirit_rating/2
]).

-export([
    count_awakening_lv/2
    , count_awakening_attr/2
    , awakening/2
]).

-export([
    add_equip_skill/3
    , remove_equip_skill/2
    , upgrade_equip_skill/2
    , count_equip_skill_attr/2
    , count_equip_skill_power/2
    , conver_refine_lv/4
    , get_12_equip_award_sum_lv/2
    , get_all_equip_rating/1
    , statistics_suit_num/1
    , do_gen_equip_extra_attr/3
    , get_equip_other_attr/1
    , gen_equip_extra_attr_by_types/2
    , gen_equip_extra_attr/2
    , re_static_red_equip_award/1
    , get_equip_sub_mod_power/2
    , get_suit_power/1
    , get_suit_all_lv/1
    , count_stone_total_lv_off_line/1
    , is_equipment_suit/1
    , is_accessory_suit/1
    , get_suit_type/1
]).

%% 秘籍
-export([
    one_key_add_equip/3
    , one_key_add_equip/4
    , gm_restore_suit/0
    , gm_repaire_suit/0
    , repair_other_attr/0
    , repair_other_attr/2
    , gm_reset_suit/1
]).

%% 20220518新版规则
-export([
    get_data/1,
    new_make_suit_rule/3,
    db_update_suit_info/4,
    setup_equip_suit/4,
    get_cur_min_suit_stage/3,
    get_lv_restore_rewards/6,
    send_suit_combat_info/4,
    new_restore_suit/3,
    new_restore_suit_preview/3
]).

-export([
    calc_base_equip_power/4
]).

%% ------------------------------- 事件回调 %% -------------------------------
%% 玩家登录检查天使和恶魔的有效时间
handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(PS, player_status) ->
    #player_status{id = _RoleId, figure = Figure} = PS,
    %% 卸下过期的宝石
    case Figure#figure.vip == 0 of
        true ->
            unload_stones_on_equip(PS, ?UNLOAD_STONE_TYPE_VIP_TIME_OUT);
        false ->
            {ok, PS}
    end;

% handle_event(PS, #event_callback{type_id = ?EVENT_EQUIP, data = #goods{} = GoodsInfo}) when is_record(PS, player_status) ->
%     #figure{career = _Career, sex = _Sex, lv = _Lv, turn = _Turn, lv_model = LvModel} = Figure,
%     {ok, PS};
% handle_event(PS, #event_callback{type_id = ?EVENT_UNEQUIP, data = #goods{} = GoodsInfo}) when is_record(PS, player_status) ->
%     {ok, PS#player_status{figure = NewFigure}};
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    lib_god_equip:do_after_lv_up(Player, RoleLv, RoleId),
    lib_goods_util:count_role_equip_attribute(Player);
handle_event(Player, #event_callback{type_id = ?EVENT_VIP_TIME_OUT}) when is_record(Player, player_status) ->
    unload_stones_on_equip(Player, ?UNLOAD_STONE_TYPE_VIP_TIME_OUT);
handle_event(PS, _EC) ->
    {ok, PS}.

%% 获取装备阶数
get_equip_stage(#goods{goods_id = GoodsId}) ->
    get_equip_stage(GoodsId);
get_equip_stage(#ets_goods_type{goods_id = GoodsId}) ->
    get_equip_stage(GoodsId);
get_equip_stage(GoodsId) when is_integer(GoodsId) ->
    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{stage = Stage} ->
            Stage;
        _ ->
            0
    end;
get_equip_stage(_GoodsId) ->
    0.

%% 获取装备星级
get_equip_star(#goods{goods_id = GoodsId}) ->
    get_equip_star(GoodsId);
get_equip_star(#ets_goods_type{goods_id = GoodsId}) ->
    get_equip_star(GoodsId);
get_equip_star(GoodsId) when is_integer(GoodsId) ->
    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{star = Star} ->
            Star;
        _ ->
            0
    end;
get_equip_star(_GoodsId) ->
    0.

%% 获取装备分类
get_equip_class_type(#goods{goods_id = GoodsId}) ->
    get_equip_class_type(GoodsId);
get_equip_class_type(#ets_goods_type{goods_id = GoodsId}) ->
    get_equip_class_type(GoodsId);
get_equip_class_type(GoodsId) when is_integer(GoodsId) ->
    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{class_type = ClassType} -> ClassType;
        _ -> 0
    end;
get_equip_class_type(_GoodsId) ->
    0.

get_equip_stage_and_star(GoodsId) ->
    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{stage = Stage, star = Star} ->
            {Stage, Star};
        _ ->
            {0, 0}
    end.

is_equip(#ets_goods_type{type = ?GOODS_TYPE_REVELATION, equip_type = EquipType}) ->
    EquipNum = data_goods:get_config(revelation_equip_num),
    EquipType > 0 andalso EquipType =< EquipNum;
is_equip(#ets_goods_type{type = Type, equip_type = EquipType}) ->
    EquipNum = data_goods:get_config(equip_num),
    Type == ?GOODS_TYPE_EQUIP andalso EquipType > 0 andalso EquipType =< EquipNum;
is_equip(_) ->
    false.

%% ------------------------------- 穿戴装备 %% -------------------------------
equip(PS, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:equip(PS, GoodsStatus, GoodsId) of
        {true, GoodsInfo} ->
            do_equip(PS, GoodsStatus, GoodsInfo);
        {false, Res} ->
            {false, Res, PS}
    end.

do_equip(PS, GoodsStatus, GoodsInfo) ->
    #player_status{id = PlayerId, figure = #figure{vip = Vip, vip_type = VipType}} = PS,
    PlayerEquipArgs = {PlayerId, Vip, VipType},
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [?GOODS_LOC_EQUIP]}, {id_in, [GoodsInfo#goods.id]}]),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_equip_core(PlayerEquipArgs, GoodsStatusBfTrans, GoodsInfo)
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, OldGoodsInfo, NewGoodsInfo, GoodsL, Cell, RemoveStoneL, ReturnArgs} ->
            % 宝石移除日志
            log_auto_unload_stone(PlayerId, ?UNLOAD_STONE_TYPE_REPLACE_EQUIP, Cell, RemoveStoneL),
            GoodsStatusAfRestore = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
            LastGoodsStatus = recalc_12_equip_reward(GoodsStatusAfRestore, OldGoodsInfo, NewGoodsInfo),
            lib_goods_do:set_goods_status(LastGoodsStatus),
            % 宝石战力值刷新
            update_equip_sub_mod_power(PS, ?EQUIP_STONE_POWER),
            % 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
            lib_goods_api:notify_client_num(LastGoodsStatus#goods_status.player_id, [GoodsInfo#goods{num = 0}]),
            lib_goods_api:notify_client(LastGoodsStatus#goods_status.player_id, GoodsL),
            % 穿戴装备更新一下神炼属性
            RefinePS = lib_equip_refinement:count_equip_refinement_attr(PS, LastGoodsStatus),
            % 更新套装收集点亮进度
            SuitCltPS = lib_suit_collect:auto_activate(RefinePS, [NewGoodsInfo], ?SEND),
            % 还原当前位置套装 20220517 修改至替换装备时，如果不符合打造条件的也不在拆解共鸣
            %% SuitPS = lib_equip:update_suit(SuitCltPS, OldGoodsInfo, NewGoodsInfo),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(SuitCltPS),
            % 返还物品给玩家
            return_goods_to_player(PlayerId, ReturnArgs),
            EventPS = lib_equip_event:dress_equip_event(LastPS, LastGoodsStatus, NewGoodsInfo),
            {true, ?SUCCESS, OldGoodsInfo, NewGoodsInfo, Cell, EventPS};
        Error ->
            ?ERR("equip error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

do_equip_core(PlayerEquipArgs, GoodsStatus, GoodsInfo) ->
    {PlayerId, Vip, VipType} = PlayerEquipArgs,
    Location = ?GOODS_LOC_EQUIP,
    GoodDict = GoodsStatus#goods_status.dict,
    OldEquipLocation = GoodsStatus#goods_status.equip_location, % 记录装备位置装备的物品[{equip_pos, equip_id}]
    Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(PlayerId, Location, Cell, GoodDict),    % 获取要被替换的装备
    {NewOldGoodsInfo, NewGoodsInfo, NewGoodsStatus, RemoveStoneL, NewReturnArgs} =
        case is_record(OldGoodsInfo, goods) of
            true -> %% 存在已装备的物品，则替换装备
                OriginalCell = 0, %%现在没有格子位置的概念，全部置为0
                GoodsTypeTemp = data_goods_type:get(OldGoodsInfo#goods.goods_id),
                OriginalLocation = GoodsTypeTemp#ets_goods_type.bag_location,
                %%end
                %% 清理强化等级和精炼等级
                OldGoodsInfo1 = OldGoodsInfo#goods{other = OldGoodsInfo#goods.other#goods_other{stren = 0, refine = 0}},
                [OldGoodsInfo2, GoodsStatus1] =
                    lib_goods:change_goods_cell_and_use(OldGoodsInfo1, OriginalLocation, OriginalCell, GoodsStatus),

                %% 替换装备需要转换强化等级
                NewStrenLv = data_goods:get_equip_real_stren_level(GoodsStatus1, GoodsInfo),
                %% 替换装备需要转换精炼等级
                NewRefineLv = data_goods:get_equip_real_refine_level(GoodsStatus1, GoodsInfo),
                %% 更新强化等级
                GoodsInfoStren = GoodsInfo#goods{other = GoodsInfo#goods.other#goods_other{stren = NewStrenLv, refine = NewRefineLv}},
                [GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(GoodsInfoStren, Location, Cell, GoodsStatus1),
                %% 更新部位的装备id
                EquipLocation = lists:keystore(Cell, 1, OldEquipLocation, {Cell, GoodsInfo1#goods.id}),
                GoodsStatus3 = GoodsStatus2#goods_status{equip_location = EquipLocation},
                %% 高阶换低阶装备，超过镶嵌数量的宝石要自动卸下
                {GoodsStatus4, RStoneInfoL, RStonesL} = unload_stones(VipType, Vip, GoodsStatus3, Cell, ?UNLOAD_STONE_TYPE_REPLACE_EQUIP),
                ReturnArgs = [{stone_list, RStonesL}],
                {OldGoodsInfo2, GoodsInfo1, GoodsStatus4, RStoneInfoL, ReturnArgs};
            %% 不存在，直接穿戴
            false ->
                NewStrenLv = data_goods:get_equip_real_stren_level(GoodsStatus, GoodsInfo),%% 转换强化等级
                NewRefineLv = data_goods:get_equip_real_refine_level(GoodsStatus, GoodsInfo), % 不变
                GoodsInfoStren = GoodsInfo#goods{other = GoodsInfo#goods.other#goods_other{stren = NewStrenLv, refine = NewRefineLv}},  % 更新装备的强化等级和精炼等级
                [GoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(GoodsInfoStren, Location, Cell, GoodsStatus),
                %% 更新部位的装备id
                EquipLocation = lists:keystore(Cell, 1, OldEquipLocation, {Cell, GoodsInfo1#goods.id}),
                ReturnArgs = [],
                {OldGoodsInfo, GoodsInfo1, GoodsStatus1#goods_status{equip_location = EquipLocation}, [], ReturnArgs}
        end,

    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,

    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),

    NewStatus = NewGoodsStatus#goods_status{
        dict = GoodsDict,
        equip_location = EquipLocation
    },
    {ok, NewStatus, NewOldGoodsInfo, NewGoodsInfo, GoodsL, Cell, RemoveStoneL, NewReturnArgs}.

%% ------------------------------- 卸载装备 %% -------------------------------
unequip(PS, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:unequip(GoodsStatus, GoodsId) of
        {true, GoodsInfo} ->
            do_unequip(PS, GoodsStatus, GoodsInfo);
        {false, Res} ->
            {false, Res, PS}
    end.

do_unequip(PS, GoodsStatus, GoodsInfo) ->
    #player_status{id = PlayerId, figure = #figure{vip = Vip, vip_type = VipType}} = PS,
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [?GOODS_LOC_EQUIP]}]),
    PlayerUnEquipArgs = {PlayerId, Vip, VipType},
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_unequip_core(PlayerUnEquipArgs, GoodsStatusBfTrans, GoodsInfo)
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, NewGoodsInfo, GoodsL, Cell, _RemoveStoneL, ReturnGoodsL} ->
            %% 宝石移除日志
            %log_auto_unload_stone(PS#player_status.id, ?UNLOAD_STONE_TYPE_UNEQUIP, GoodsInfo#goods.cell, RemoveStoneL),
            GoodsStatusAfRestore = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
            LastGoodsStatus = recalc_12_equip_reward(GoodsStatusAfRestore, NewGoodsInfo, #goods{}),
            lib_goods_do:set_goods_status(LastGoodsStatus),
            lib_goods_api:notify_client(PlayerId, GoodsL),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(PS),
            % 宝石战力值刷新
            update_equip_sub_mod_power(LastPS, ?EQUIP_STONE_POWER),
            %% 返还物品给玩家
            return_goods_to_player(PlayerId, ReturnGoodsL),
            {true, ?SUCCESS, NewGoodsInfo, Cell, LastPS};
        Error ->
            ?ERR("equip error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

do_unequip_core(PlayerUnEquipArgs, GoodsStatus, GoodsInfo) ->
    {_PlayerId, _Vip, _VipType} = PlayerUnEquipArgs,
    GoodsType = data_goods_type:get(GoodsInfo#goods.goods_id),
    Location = GoodsType#ets_goods_type.bag_location,
    %%end
    Cell = 0, %% 背包没有具体的格子位置
    %% 卸下该件装备镶嵌的所有宝石
    EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
    %{GoodsStatusTmp, SuitReturn} = update_suit(PS, GoodsStatus, GoodsInfo, undefined, EquipPos),
    %{GoodsStatus0, RemoveStoneL, RStonesL} = unload_stones(VipType, Vip, GoodsStatusTmp, EquipPos, ?UNLOAD_STONE_TYPE_UNEQUIP),
    %% 清理强化等级和精炼等级
    GoodsInfo1 = GoodsInfo#goods{other = GoodsInfo#goods.other#goods_other{stren = 0, refine = 0}},
    [NewGoodsInfo, GoodsStatus1] =
        lib_goods:change_goods_cell_and_use(GoodsInfo1, Location, Cell, GoodsStatus),
    #goods_status{equip_location = OldEquipLocation, dict = OldGoodsDict} = GoodsStatus1,
    EquipLocation = lists:keydelete(EquipPos, 1, OldEquipLocation),
    {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    GoodsStatus2 = GoodsStatus1#goods_status{
        dict = Dict,
        equip_location = EquipLocation
    },
    ReturnGoodsL = [],
    {ok, GoodsStatus2, NewGoodsInfo, GoodsL, Cell, [], ReturnGoodsL}.

%% ------------------------------- 强化装备 -------------------------------
stren(PS, EquipPos, ?STREN_TYPE_ONCE) -> % 单次强化
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:stren(PS, GoodsStatus, EquipPos) of
        {true, EquipInfo, EquipStren, Cfg} ->
            do_stren(PS, GoodsStatus, [{EquipPos, EquipInfo, EquipStren, Cfg}]);
        {false, Res} ->
            {false, Res, PS}
    end;
stren(PS, _EquipPos, ?STREN_TYPE_AUTO) -> % 一键强化
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:stren(PS, GoodsStatus) of
        {true, StrenList} ->
            do_stren(PS, GoodsStatus, StrenList);
        {false, Res} ->
            {false, Res, PS}
    end.

do_stren(PS, GoodsStatus, StrenList) ->
    Args = {[], [], [], GoodsStatus#goods_status.equip_stren_list},
    {CostList, UpGoodsList, DoStrenList, EquipStrenList} = do_stren_core_pre(PS, StrenList, Args),
    case lib_goods_api:cost_object_list_with_check(PS, CostList, equip_stren, "") of
        {true, NewPS} ->
            PlayerId = PS#player_status.id, RoleName = PS#player_status.figure#figure.name,
            %% 日志
            [
            begin
                {_, _, #equip_stren{stren = OStren}, _} = lists:keyfind(EquipPos, 1, StrenList),
                lib_log_api:log_equip_stren(PlayerId, EquipPos, OneCost, OStren, NewStrenLv)
            end || {EquipPos, #equip_stren{stren = NewStrenLv}, OneCost} <- DoStrenList
            ],
            %% db强化等级
            [lib_goods_util:change_equip_stren(PlayerId, EquipPos, NewEquipStren) || {EquipPos, NewEquipStren, _} <- DoStrenList],
            %% 更改dict
            GSAfCost = #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
            NewDict = lists:foldl(fun(GoodsInfo, TmpDict) -> lib_goods_dict:add_dict_goods(GoodsInfo, TmpDict) end, Dict, UpGoodsList),
            NewGS = GSAfCost#goods_status{dict = NewDict, equip_stren_list = EquipStrenList},
            StrenAwardList = update_12_equip_award(?WHOLE_AWARD_STREN, [NewGS]),
            LastGS = NewGS#goods_status{stren_award_list = StrenAwardList},
            lib_goods_do:set_goods_status(LastGS),
            %% 战力更新
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS, LastGS),
            %% 传闻
            [begin
                case NewStrenLv >= 30 andalso (NewStrenLv - 30) rem 20 == 0  of
                    true ->
                        case [{GId, TypeId} ||#goods{id=GId, goods_id=TypeId, subtype=SubType} <- UpGoodsList, data_goods:get_equip_cell(SubType) == EquipPos] of
                            [{GoodsId, GoodsTypeId}|_] ->
                                lib_chat:send_TV({all}, ?MOD_EQUIP, 3,
                                    [RoleName, PlayerId, GoodsTypeId, GoodsId, PlayerId, NewStrenLv]);
                            _ -> skip
                        end;
                    _ -> skip
                end
            end|| {EquipPos, #equip_stren{stren = NewStrenLv}, _} <- DoStrenList],
            %% 强化事件
            EquipStrenInfo = [{EquipPos, NewStrenLv}||{EquipPos, #equip_stren{stren = NewStrenLv}, _} <- DoStrenList],
            EventPS = lib_equip_event:equip_stren_event(LastPS, LastGS, EquipStrenInfo),
            {true, ?SUCCESS, EquipStrenInfo, EventPS};
        {false, Res, NewPS} ->
            {false, Res, NewPS}
    end.

%% 判断强化前置工作(单次强化和自动强化都适用)
do_stren_core_pre(_, [], Acc) -> Acc;
do_stren_core_pre(PS, StrenList, Acc) ->
    {_, _, #equip_stren{stren = MinStren}, _} = hd(StrenList),
    {_, _, #equip_stren{stren = MaxStren}, _} = lists:last(StrenList),
    case MinStren == MaxStren of
        % 装备不同级,向最高级目标看齐(优先低等级)
        false -> do_stren_core(PS, MaxStren, StrenList, Acc);
        % 所有装备同级,目标升一级
        true -> do_stren_core(PS, MaxStren+1, StrenList, Acc)
    end.

do_stren_core(_, _, [], Acc) -> Acc;
do_stren_core(PS, MaxStren, [{EquipPos, EquipInfo, EquipStren, Cfg} | StrenList], {CostList, UpGoodsList, DoStrenList, EquipStrenList}) -> % {消耗汇总, 装备物品更新列表, 目标强化列表, 装备强化后全列表}
    NewCostList = CostList ++ Cfg#base_equip_stren.object_list,
    case {lib_goods_api:check_object_list(PS, NewCostList), EquipStren#equip_stren.stren < MaxStren} of
        {true, true} ->
            % 更新装备信息
            #equip_stren{stren = Stren} = EquipStren,
            #goods{other = EquipInfoOther} = EquipInfo,
            NewEquipInfo = EquipInfo#goods{other = EquipInfoOther#goods_other{stren = Stren+1}},
            NewEquipStren = EquipStren#equip_stren{stren = Stren+1},
            NewCfg = data_equip:stren_lv_cfg(EquipPos, Stren+1),
            NewStrenList0 =
            case lib_equip_check:check({check_stren_max, EquipPos, NewEquipInfo, NewEquipStren}) of
                true -> [{EquipPos, NewEquipInfo, NewEquipStren, NewCfg} | StrenList];
                _ -> StrenList
            end,
            F = fun({Pos1, _, #equip_stren{stren = Stren1}, _}, {Pos2, _, #equip_stren{stren = Stren2}, _}) ->
                if
                    Stren1 < Stren2 -> true;
                    Stren1 == Stren2, Pos1 < Pos2 -> true;
                    true -> false
                end
            end,
            NewStrenList = lists:sort(F, NewStrenList0), % 对待强化列表重新进行排序
            % 更新汇总信息
            NewUpGoodsList = lists:keystore(EquipInfo#goods.id, #goods.id, UpGoodsList, NewEquipInfo),
            {_, _, OneCost} = ulists:keyfind(EquipPos, 1, DoStrenList, {EquipPos, EquipStren, []}),
            NewDoStrenList = lists:keystore(EquipPos, 1, DoStrenList, {EquipPos, NewEquipStren, OneCost++Cfg#base_equip_stren.object_list}),
            NewEquipStrenList = lists:keystore(EquipPos, 1, EquipStrenList, {EquipPos, NewEquipStren}),
            % 递归
            do_stren_core(PS, MaxStren, NewStrenList, {NewCostList, NewUpGoodsList, NewDoStrenList, NewEquipStrenList});
        _ ->
            {CostList, UpGoodsList, DoStrenList, EquipStrenList}
    end.

%%  精炼装备
refine(PS, EquipPos, ?STREN_TYPE_ONCE) -> % 单次精炼
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:refine(PS, GoodsStatus, EquipPos) of
        {true, EquipInfo, EquipRefine, Cfg} ->
            do_refine(PS, GoodsStatus, [{EquipPos, EquipInfo, EquipRefine, Cfg}]);
        {false, Res} ->
            {false, Res, PS}
    end;
refine(PS, _EquipPos, ?STREN_TYPE_AUTO) -> % 一键精炼
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:refine(PS, GoodsStatus) of
        {true, RefineList} ->
            do_refine(PS, GoodsStatus, RefineList);
        {false, Res} ->
            {false, Res, PS}
    end.

do_refine(PS, GoodsStatus, RefineList) ->
    Args = {[], [], [], GoodsStatus#goods_status.equip_refine_list},
    {CostList, UpGoodsList, DoRefineList, EquipRefineList} = do_refine_core_pre(PS, RefineList, Args),
    case lib_goods_api:cost_object_list_with_check(PS, CostList, equip_refine, "") of
        {true, NewPS} ->
            PlayerId = PS#player_status.id,
            %% 日志
            [
            begin
                {_, _, #equip_refine{refine = ORefine}, _} = lists:keyfind(EquipPos, 1, RefineList),
                lib_log_api:log_equip_stren(PlayerId, EquipPos, OneCost, ORefine, NewRefineLv)
            end || {EquipPos, #equip_refine{refine = NewRefineLv}, OneCost} <- DoRefineList
            ],
            %% db强化等级
            [lib_goods_util:change_equip_refine(PlayerId, EquipPos, NewEquipRefine) || {EquipPos, NewEquipRefine, _} <- DoRefineList],
            %% 更改dict
            GSAfCost = #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
            NewDict = lists:foldl(fun(GoodsInfo, TmpDict) -> lib_goods_dict:add_dict_goods(GoodsInfo, TmpDict) end, Dict, UpGoodsList),
            NewGS = GSAfCost#goods_status{dict = NewDict, equip_refine_list = EquipRefineList},
            RefineAwardList = update_12_equip_award(?WHOLE_AWARD_REFINE, [NewGS]),
            LastGS = NewGS#goods_status{refine_award_list = RefineAwardList},
            lib_goods_do:set_goods_status(LastGS),
            %% 战力更新
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS, LastGS),
            %% 强化事件
            EquipRefineInfo = [{EquipPos, NewRefineLv}||{EquipPos, #equip_refine{refine = NewRefineLv}, _} <- DoRefineList],
            EventPS = lib_equip_event:equip_refine_event(LastPS, LastGS, EquipRefineInfo),
            {true, ?SUCCESS, EquipRefineInfo, EventPS};
        {false, Res, NewPS} ->
            {false, Res, NewPS}
    end.

%% 判断精炼前置工作(单次精炼和自动精炼都适用)
do_refine_core_pre(_, [], Acc) -> Acc;
do_refine_core_pre(PS, RefineList, Acc) ->
    {_, _, #equip_refine{refine = MinRefine}, _} = hd(RefineList),
    {_, _, #equip_refine{refine = MaxRefine}, _} = lists:last(RefineList),
    case MinRefine == MaxRefine of
        % 装备不同级,向最高级目标看齐(优先低等级)
        false -> do_refine_core(PS, MaxRefine, RefineList, Acc);
        % 所有装备同级,目标升一级
        true -> do_refine_core(PS, MaxRefine+1, RefineList, Acc)
    end.

do_refine_core(_, _, [], Acc) -> Acc;
do_refine_core(PS, MaxRefine, [{EquipPos, EquipInfo, EquipRefine, Cfg} | RefineList], {CostList, UpGoodsList, DoRefineList, EquipRefineList}) -> % {消耗汇总, 装备物品更新列表, 目标强化列表, 装备强化后全列表}
    NewCostList = CostList ++ Cfg#base_equip_refine.object_list,
    case {lib_goods_api:check_object_list(PS, NewCostList), EquipRefine#equip_refine.refine < MaxRefine} of
        {true, true} ->
            % 更新装备信息
            #equip_refine{refine = Refine} = EquipRefine,
            #goods{other = EquipInfoOther} = EquipInfo,
            NewEquipInfo = EquipInfo#goods{other = EquipInfoOther#goods_other{refine = Refine+1}},
            NewEquipRefine = EquipRefine#equip_refine{refine = Refine+1},
            NewCfg = data_equip:refine_lv_cfg(EquipPos, Refine+1),
            NewRefineList0 =
            case lib_equip_check:check({check_refine_max, EquipPos, NewEquipInfo, NewEquipRefine}) of
                true -> [{EquipPos, NewEquipInfo, NewEquipRefine, NewCfg} | RefineList];
                _ -> RefineList
            end,
            F = fun({Pos1, _,#equip_refine{refine = Refine1}, _}, {Pos2, _, #equip_refine{refine = Refine2}, _}) ->
                if
                    Refine1 < Refine2 -> true;
                    Refine1 == Refine2, Pos1 < Pos2 -> true;
                    true -> false
                end
            end,
            NewRefineList = lists:sort(F, NewRefineList0), % 对待强化列表重新进行排序
            % 更新汇总信息
            NewUpGoodsList = lists:keystore(EquipInfo#goods.id, #goods.id, UpGoodsList, NewEquipInfo),
            {_, _, OneCost} = ulists:keyfind(EquipPos, 1, DoRefineList, {EquipPos, EquipRefine, []}),
            NewDoRefineList = lists:keystore(EquipPos, 1, DoRefineList, {EquipPos, NewEquipRefine, OneCost++Cfg#base_equip_refine.object_list}),
            NewEquipRefineList = lists:keystore(EquipPos, 1, EquipRefineList, {EquipPos, NewEquipRefine}),
            % 递归
            do_refine_core(PS, MaxRefine, NewRefineList, {NewCostList, NewUpGoodsList, NewDoRefineList, NewEquipRefineList});
        _ ->
            {CostList, UpGoodsList, DoRefineList, EquipRefineList}
    end.

%% 获取强化数
get_stren(GoodsStatus, EquipPos) ->
    StrenList = GoodsStatus#goods_status.equip_stren_list,
    EquipStren = lists:keyfind(EquipPos, 1, StrenList),
    {EquipPos, EquipStren2} = ?IF(EquipStren == false, {EquipPos, #equip_stren{}}, EquipStren),
    EquipStren2.

%% 获取精炼数
get_refine(GoodsStatus, EquipPos) ->
    RefineList = GoodsStatus#goods_status.equip_refine_list,
    EquipRefine = lists:keyfind(EquipPos, 1, RefineList),
    {EquipPos, EquipRefine2} = ?IF(EquipRefine == false, {EquipPos, #equip_refine{}}, EquipRefine),
    EquipRefine2.

%% 替换装备的时候转换强化等级
%% return 强化等级
conver_stren_lv(_EquipColor, _Pos, PreStren, _EquipStage) ->
    PreStren.

%% 替换装备的时候转换精炼等级
conver_refine_lv(_EquipColor, _Pos, PreRefine, _EquipStage) ->
    PreRefine.



%% ------------------------------- 强化信息 %% -------------------------------
stren_info(_PS, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:stren_info(GoodsStatus, EquipPos) of
        {true, Stren} ->
            {1, Stren};
        {false, Res} ->
            {Res, 0}
    end.

%% 计算总的强化数量
count_stren_total_lv(PlayerStatus) when is_record(PlayerStatus, player_status) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{stren_award_list = StrenAwardList} = GoodsStatus,
    lists:foldl(fun({StrenLv, Num}, SumTemp) ->
        SumTemp + StrenLv * Num
                end, 0, StrenAwardList);
count_stren_total_lv(_) ->
    0.

%% ------------------------------- 精炼信息  -------------------------------
refine_info(EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:refine_info(GoodsStatus, EquipPos) of
        {true, Refine, RefineHigh} ->
            {1, Refine, RefineHigh};
        {false, _Res} ->
            {0, 0, 0}
    end.


%% ------------------------------- 进阶装备 -------------------------------
%%--------------------------------------------------
%% 进阶极品属性预览
%% @param  PS      description
%% @param  GoodsId 物品id
%% @return         description
%%--------------------------------------------------
upgrade_stage_preview(GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_stage_preview(GoodsStatus, GoodsId) of
        {true, EquipInfo, Cfg} ->
            #goods{other = GoodsOther} = EquipInfo,
            #equip_upgrade_stage_cfg{ngoods_id = NewGTypeId} = Cfg,
            NewGoodsTypeInfo = data_goods_type:get(NewGTypeId),
            NewExtraAttr = gen_equip_extra_attr_by_types(NewGoodsTypeInfo, GoodsOther#goods_other.extra_attr),
            PackAttrList = data_attr:unified_format_extra_attr(NewExtraAttr, []),
            Rating = cal_equip_rating(NewGoodsTypeInfo, NewExtraAttr),
            {true, NewGoodsTypeInfo#ets_goods_type.goods_id, Rating, Rating, PackAttrList};
        {false, Res} ->
            {false, Res}
    end.

%% 进阶装备直接更新旧装备的物品类型id 属性等字段
%% 要同时更新goods, goods_low, goods_high三张表
upgrade_stage(PS, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_stage(PS, GoodsStatus, GoodsId) of
        {true, EquipInfo, Cfg} ->
            do_upgrade_stage(PS, GoodsStatus, EquipInfo, Cfg);
        {false, Res} ->
            {false, Res, PS}
    end.

do_upgrade_stage(PS, GoodsStatus, EquipInfo, Cfg) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cfg#equip_upgrade_stage_cfg.cost, equip_upgrade_stage, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                {LastStatus, GoodsL, ReturnGoodsL, NewEquipInfo} = do_upgrade_stage_core(PS, NewStatus, EquipInfo, Cfg),
                {ok, LastStatus, GoodsL, NewPS, ReturnGoodsL, NewEquipInfo};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS, ReturnGoodsL, NewEquipInfo} ->
            %% 装备升阶日志
            lib_log_api:log_equip_upgrade_stage(NewPS#player_status.id, EquipInfo#goods.id, EquipInfo#goods.goods_id, Cfg#equip_upgrade_stage_cfg.cost, NewEquipInfo#goods.goods_id),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, UpdateGoodsList),
            return_goods_to_player(NewPS#player_status.id, ReturnGoodsL),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS};
        {error, Res, NewGoodsStatus, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            {false, Res, NewPS};
        Error ->
            ?ERR("upgrade_stage error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

do_upgrade_stage_core(PS, GoodsStatus, EquipInfo, Cfg) ->
    #goods{
        id = GoodsId,
        other = GoodsOther} = EquipInfo,
    #equip_upgrade_stage_cfg{
        ngoods_id = NewGTypeId
    } = Cfg,
    #ets_goods_type{
        %% price_type = NewPriceType,
        %% price = NewPrice,
        level = NewLv,
        color = NewColor,
        suit_id = NewSuitId,
        addition = NewAddition
    } = NewGoodsTypeInfo = data_goods_type:get(NewGTypeId),
    {NewPriceType, NewPrice} = data_goods:get_goods_buy_price(NewGTypeId),
    NewExtraAttr = gen_equip_extra_attr_by_types(NewGoodsTypeInfo, GoodsOther#goods_other.extra_attr),
    Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
        [NewPriceType, NewPrice, GoodsId]),
    db:execute(Sql),
    Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, color = ~p, addition = '~s', extra_attr = '~s' where gid = ~p">>,
        [NewGTypeId, NewLv, NewColor, util:term_to_string(NewAddition), util:term_to_string(NewExtraAttr), GoodsId]),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
        [NewGTypeId, GoodsId]),
    db:execute(Sql2),
    NewGoodsOther = GoodsOther#goods_other{
        suit_id = NewSuitId,
        addition = NewAddition,
        extra_attr = NewExtraAttr,
        rating = cal_equip_rating(NewGoodsTypeInfo, NewExtraAttr)
    },
    NewEquipInfo = EquipInfo#goods{
        goods_id = NewGTypeId,
        price_type = NewPriceType,
        price = NewPrice,
        level = NewLv,
        color = NewColor,
        other = NewGoodsOther
    },
    EquipPos = data_goods:get_equip_cell(EquipInfo#goods.equip_type),
    {NewGoodsStatusTmp, SuitReturn} = update_suit(PS, GoodsStatus, EquipInfo, NewEquipInfo, EquipPos),
    NewGoodsStatus = lib_goods:change_goods(NewEquipInfo, ?GOODS_LOC_EQUIP, NewGoodsStatusTmp),
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewStatus = NewGoodsStatus#goods_status{dict = GoodsDict},
    %% 装备属性
    case NewGTypeId =/= EquipInfo#goods.goods_id of
        true ->
            StarAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_STAR, [NewStatus, EquipInfo, NewEquipInfo]),
            StrenAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_STREN, [NewStatus]),
            StoneAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_STONE, [NewStatus]),
            RefineAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_REFINE, [NewStatus]),
            StageAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_STAGE, [NewStatus]),
            ColorAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_COLOR, [NewStatus]),
            RedEquipAwardList = lib_equip:update_12_equip_award(?WHOLE_AWARD_RED_EQUIP, [NewStatus]);
        false ->
            StarAwardList = NewStatus#goods_status.star_award_list,
            StrenAwardList = NewStatus#goods_status.stren_award_list,
            StoneAwardList = NewStatus#goods_status.stone_award_list,
            RefineAwardList = NewStatus#goods_status.refine_award_list,
            StageAwardList = NewStatus#goods_status.stage_award_list,
            ColorAwardList = NewStatus#goods_status.color_award_list,
            RedEquipAwardList = NewStatus#goods_status.red_equip_award_list
    end,
    LastStatus = NewStatus#goods_status{
        star_award_list = StarAwardList,
        stren_award_list = StrenAwardList,
        stone_award_list = StoneAwardList,
        refine_award_list = RefineAwardList,
        stage_award_list = StageAwardList,
        color_award_list = ColorAwardList,
        red_equip_award_list = RedEquipAwardList
    },
    ReturnGoodsL = [{suit_return, SuitReturn}],
    {LastStatus, GoodsL, ReturnGoodsL, NewEquipInfo}.

%% ------------------------------- 装备洗炼 ----------------------------------
%%  传闻
send_wash_tv(RoleId, RoleName, _WashAttrList, UpdateList) ->
    lists:foreach(fun({_Pos, Color, _Id, _Val}) ->
        case Color of
            ?RED ->
                lib_chat:send_TV({all}, ?MOD_EQUIP, 1, [RoleName, RoleId, Color, data_color:get_name(Color)]);
            ?ORANGE ->
                lib_chat:send_TV({all}, ?MOD_EQUIP, 7, [RoleName, RoleId, Color, data_color:get_name(Color)]);
            _ ->
                skip
        end
                  end, UpdateList).


%%  开启洗炼属性槽
unlock_wash_pos(PS, EquipPos, WashPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:unlock_wash_pos(PS, GoodsStatus, EquipPos, WashPos) of
        {true, EquipInfo, AttrWeightList, Cost} ->
            ?PRINT("true~n", []),
            do_unlock_wash_pos(PS, GoodsStatus, EquipInfo, EquipPos, WashPos, AttrWeightList, Cost);
        {false, Res} ->
            ?PRINT("false~n", []),
            {false, Res, PS}
    end.

do_unlock_wash_pos(PS, GoodsStatus, EquipInfo, EquipPos, WashPos, AttrWeightList, Cost) ->
    #goods_status{equip_wash_map = OldEquipWashMap} = GoodsStatus,
    AttrId = urand:rand_with_weight(AttrWeightList),
    {NewEquipWashMap, NewWashAttrList, WashUpdateAttrList}
        = do_equip_wash_core(OldEquipWashMap, EquipPos, EquipInfo, [WashPos], [AttrId], 0, 0, 0),
    case lib_goods_api:cost_object_list(PS, Cost, equip_unlock_wash_pos, "") of
        {true, NewPS} ->
            %% 洗炼日志
            #equip_wash{attr = OldAttr, wash_rating = OldRating} = maps:get(EquipPos, OldEquipWashMap, #equip_wash{}),
            EquipWash = maps:get(EquipPos, NewEquipWashMap, #equip_wash{}),
            #equip_wash{duan = NewDuan, attr = NewAttr, wash_rating = NewRating} = EquipWash,
            lib_log_api:log_equip_wash(NewPS#player_status.id, EquipPos, NewDuan, Cost, OldAttr, NewAttr, OldRating, NewRating, 0),
            %% 更新数据库洗炼信息
            lib_goods_util:update_equip_wash(NewPS#player_status.id, EquipPos, EquipWash),
            %% 更新gs
            NewStatus = lib_goods_do:get_goods_status(),
            LastStatus = NewStatus#goods_status{equip_wash_map = NewEquipWashMap},
            %% 传闻
            send_wash_tv(PS#player_status.id, PS#player_status.figure#figure.name, NewWashAttrList, WashUpdateAttrList),
            %% 人物装备属性重新计算
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS, LastStatus),
            EventPS = lib_equip_event:wash_equip_event(LastPS, EquipPos, NewWashAttrList, NewEquipWashMap, false),
            {true, ?SUCCESS, WashPos, EquipInfo#goods.id, EventPS};
        {false, Res, NewPS} ->
            {false, Res, NewPS}
    end.

%% 洗练装备
equip_wash(PS, EquipPos, LockAttrList, RatioPlus) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:equip_wash(PS, GoodsStatus, EquipPos, LockAttrList, RatioPlus) of
        {true, EquipInfo, AttrWeightList, WashPosList, Cost} ->
            LockNum = length(LockAttrList),
            do_equip_wash(PS, GoodsStatus, EquipInfo, EquipPos, AttrWeightList, WashPosList, Cost, RatioPlus, LockNum);
        {false, Res} ->
            {false, Res, PS}
    end.

do_equip_wash(PS, GoodsStatus, EquipInfo, EquipPos, AttrWeightList, WashPosList, Cost, RatioPlus, LockNum) ->
    #goods_status{equip_wash_map = OldEquipWashMap} = GoodsStatus,
    %%从列表取出需要洗炼的不重复的元素
    CandidateAttrList = urand:list_rand_by_weight(AttrWeightList, length(WashPosList)),
    RatioPlusAttrPos = ?IF(RatioPlus > 0, urand:list_rand(WashPosList), 0),
    {NewEquipWashMap, NewWashAttrList, WashUpdateAttrList}
        = do_equip_wash_core(OldEquipWashMap, EquipPos, EquipInfo, WashPosList, CandidateAttrList, RatioPlusAttrPos, RatioPlus, LockNum),
    case lib_goods_api:cost_object_list(PS, Cost, equip_wash, "") of
        {true, NewPS} ->
            %% 洗炼日志
            #equip_wash{attr = OldAttr, wash_rating = OldRating} = maps:get(EquipPos, OldEquipWashMap, #equip_wash{}),
            EquipWash = maps:get(EquipPos, NewEquipWashMap, #equip_wash{}),
            #equip_wash{duan = NewDuan, attr = NewAttr, wash_rating = NewRating} = EquipWash,
            lib_log_api:log_equip_wash(NewPS#player_status.id, EquipPos, NewDuan, Cost, OldAttr, NewAttr, OldRating, NewRating, RatioPlus),
            %% 更新gs
            NewStatus = lib_goods_do:get_goods_status(),
            LastStatus = NewStatus#goods_status{equip_wash_map = NewEquipWashMap},
            %% 更新数据库洗炼信息
            lib_goods_util:update_equip_wash(NewPS#player_status.id, EquipPos, EquipWash),
            %% 洗练次数
            UseTimes = mod_daily:get_count(NewPS#player_status.id, ?MOD_EQUIP, ?FREE_COUNT_ID),
            case RatioPlus == 0 andalso (?FREE_TIMES - UseTimes) > 0 of  % 增加免费次数
                true ->
                    mod_daily:increment(NewPS#player_status.id, ?MOD_EQUIP, ?FREE_COUNT_ID);
                false ->
                    skip
            end,
            %% 传闻
            send_wash_tv(NewPS#player_status.id, NewPS#player_status.figure#figure.name, NewWashAttrList, WashUpdateAttrList),
%%          重新计算装备属性
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS, LastStatus),
            WashUpdatePos = [TmpAttrPos || {TmpAttrPos, _TmpAttrColor, _TmpAttrId, _TmpAttrVal} <- WashUpdateAttrList],
            EventPS = lib_equip_event:wash_equip_event(LastPS, EquipPos, NewWashAttrList, NewEquipWashMap, false),
            {true, ?SUCCESS, EquipInfo#goods.id, WashUpdatePos, EventPS};
        {false, Res, NewPS} ->
            {false, Res, NewPS}
    end.

do_equip_wash_core(EquipWashMap, EquipPos, _EquipInfo, WashPosList, CandidateAttrList, RatioPlusAttrPos, RatioPlus, LockNum) ->
    #equip_wash{duan = Duan, attr = WashAttrList} = OneEquipWash
        = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
    UpdateWashAttrList = do_equip_wash_core_helper(EquipPos, Duan, WashPosList, CandidateAttrList, RatioPlusAttrPos, RatioPlus, LockNum, []),
    %%    ?PRINT("doing =========~w~n",[[WashPosList, CandidateAttrList, RatioPlusAttrPos, RatioPlus, LockNum]]),
    %% 根据更新的属性替换旧的属性
    NewWashAttrList = lists:foldl(fun({TmpAttrPos, TmpAttrColor, TmpAttrId, TmpAttrVal}, AccList) ->
        lists:keystore(TmpAttrPos, 1, AccList, {TmpAttrPos, TmpAttrColor, TmpAttrId, TmpAttrVal})
                                  end, WashAttrList, UpdateWashAttrList),

    NewWashRating = count_equip_wash_rating(NewWashAttrList),
    NewEquipWashMap = maps:put(EquipPos, OneEquipWash#equip_wash{wash_rating = NewWashRating, attr = NewWashAttrList}, EquipWashMap),
    {NewEquipWashMap, NewWashAttrList, UpdateWashAttrList}.

do_equip_wash_core_helper(_, _Duan, [], _, _, _RatioPlus, _LockNum, Result) -> Result;
do_equip_wash_core_helper(EquipPos, Duan, [WashPos | List], [AttrId | AttrList], RatioPlusAttrPos, RatioPlus, LockNum, Result) ->
    %%    ?PRINT("do_equip_wash_core_helper WashPos, AttrId  ~p  ~p~n",[WashPos, AttrId]),
    case data_equip:get_wash_attr_cfg(EquipPos, Duan, AttrId) of
        #equip_wash_attr_cfg{
            attr_color = ALLColorWeightList, attr_white = Attr0Range,
            attr_green = Attr1Range, attr_blue = Attr2Range, attr_purple = Attr3Range,
            attr_orange = Attr4Range, attr_red = Attr5Range
        } ->
            {_, ColorWeightList} = lists:keyfind(LockNum, 1, ALLColorWeightList),
            TmpMap =
                #{
                    ?WHITE => Attr0Range,
                    ?GREEN => Attr1Range,
                    ?BLUE => Attr2Range,
                    ?PURPLE => Attr3Range,
                    ?ORANGE => Attr4Range,
                    ?RED => Attr5Range
                },
%%          限制最低颜色
            LimitColor =
                case RatioPlus of
                    1 -> ?ORANGE;
                    2 -> ?RED;
                    3 -> ?ORANGE;
                    _ -> ?WHITE
                end,
%%          按权重获取颜色
            Color =
                case RatioPlusAttrPos > 0 andalso WashPos == RatioPlusAttrPos of
                    true ->
                        F = fun(T, Acc) ->
                            case T of
                                {TWeight, TColor} when TColor =< LimitColor ->
                                    PreWeight =
                                        case lists:keyfind(LimitColor, 2, Acc) of
                                            {PWeight, LimitColor} -> PWeight;
                                            _ -> 0
                                        end,
                                    lists:keystore(LimitColor, 2, Acc, {PreWeight + TWeight, LimitColor});
                                {TWeight, TColor} ->
                                    [{TWeight, TColor} | Acc];
                                _ -> Acc
                            end
                            end,
                        NewColorWeightList = lists:foldl(F, [], ColorWeightList),
                        urand:rand_with_weight(NewColorWeightList);
                    false ->
                        urand:rand_with_weight(ColorWeightList)
                end,
            MapsWeight = maps:get(Color, TmpMap, [{1, [0, 0]}]),
            [LAttrVal, HAttrVal] = urand:rand_with_weight(MapsWeight),
            AttrVal = urand:rand(LAttrVal, HAttrVal),
            %%            ?PRINT("WashPos, AttrId,LockNum,WeightList,Color:~w~n", [[WashPos, AttrId, LockNum, ColorWeightList,Color]]),
            do_equip_wash_core_helper(EquipPos, Duan, List, AttrList, RatioPlusAttrPos, RatioPlus, LockNum, [{WashPos, Color, AttrId, AttrVal} | Result]);
        _ ->
            do_equip_wash_core_helper(EquipPos, Duan, List, AttrList, RatioPlusAttrPos, RatioPlus, LockNum, [{WashPos, ?WHITE, AttrId, 0} | Result])
    end.

get_wash_info_by_pos(GoodsStatus, EquipPos) ->
    maps:get(EquipPos, GoodsStatus#goods_status.equip_wash_map, #equip_wash{}).

upgrade_division(PS, EquipPos, AutoBuy) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_division(PS, GoodsStatus, EquipPos, AutoBuy) of
        {true, EquipInfo, OldDivision, NewDivision, Cost, AttrWeightList, WashPosList} ->
            do_upgrade_division(PS, EquipPos, EquipInfo, OldDivision, NewDivision, Cost, AttrWeightList, WashPosList);
        {false, Res} ->
            {false, Res, PS}
    end.

do_upgrade_division(PS, EquipPos, EquipInfo, OldDivision, NewDivision, Cost, AttrWeightList, WashPosList) ->
    case lib_goods_api:cost_object_list_with_check(PS, Cost, equip_upgrade_division, "") of
        {false, ErrorCode, PS} ->  {false, ErrorCode, PS};
        {true, NewPS} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #player_status{id = PlayerId, figure = #figure{name = PlayerName}} =  NewPS,
            #goods_status{equip_wash_map = EquipWashMap} = GoodsStatus,
            F = fun() ->
                OneEquipWash = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
                NewOneEquipWash = OneEquipWash#equip_wash{duan = NewDivision},
                LastOneEquipWash = up_div_wash_attr(EquipPos, NewOneEquipWash), % 更新属性的颜色
                NewEquipWashMap1 = maps:put(EquipPos, LastOneEquipWash, EquipWashMap),
                CandidateAttrList = urand:list_rand_by_weight(AttrWeightList, length(WashPosList)),
                {NewEquipWashMap, NewWashAttrList, _WashUpdateAttrList} =
                    do_equip_wash_core(NewEquipWashMap1, EquipPos, EquipInfo, WashPosList, CandidateAttrList, 0, 0, 0),
                LastEquipWash = maps:get(EquipPos, NewEquipWashMap, #equip_wash{}),
                lib_goods_util:update_equip_wash(PlayerId, EquipPos, LastEquipWash),

                {ok, NewEquipWashMap, NewWashAttrList}
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewEquipWashMap, WashAttrList} ->
                    NewGoodsStatus = GoodsStatus#goods_status{equip_wash_map = NewEquipWashMap},
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    %% 神铸日志
                    lib_log_api:log_equip_upgrade_division(PS#player_status.id, EquipPos, Cost, OldDivision, NewDivision),

                    %% 洗炼日志
                    OldEquipWash = maps:get(EquipPos, EquipWashMap, #equip_wash{}),
                    #equip_wash{attr = OldAttr, wash_rating = OldRating} = OldEquipWash,

                    NewEquipWash = maps:get(EquipPos, NewEquipWashMap, #equip_wash{}),
                    #equip_wash{duan = NewDuan, attr = NewAttr, wash_rating = NewRating} = NewEquipWash,
                    lib_log_api:log_equip_wash(NewPS#player_status.id, EquipPos, NewDuan, Cost, OldAttr, NewAttr, OldRating, NewRating, 0),
                    %% 传闻
                    lib_chat:send_TV({all}, ?MOD_EQUIP, 9, [PlayerName, PlayerId, EquipInfo#goods.goods_id, EquipInfo#goods.id, PlayerId, NewDuan]),
                    EventPS = lib_equip_event:wash_equip_event(NewPS, EquipPos, WashAttrList, NewEquipWashMap, true),
                    %% 成就
                    %%			lib_achievement_api:wash_division(NewPS, NewDivision),
                    EquipWashMapList = maps:to_list(NewEquipWashMap),
                    EquipWashDuanList = lists:foldl(fun({_Key, Value}, Acc) ->
                        case Value of
                            #equip_wash{duan = Duan} ->
                                case lists:keyfind(Duan, 1, Acc) of
                                    {_, Num} -> lists:keystore(Duan, 1, Acc, {Duan, Num + 1});
                                    _ -> lists:keystore(Duan, 1, Acc, {Duan, 1})
                                end;
                            _ ->
                                Acc
                        end
                                                    end, [], EquipWashMapList),
                    lib_achievement_api:async_event(EventPS#player_status.id, lib_achievement_api, equip_wash_division, EquipWashDuanList),
                    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(EventPS),
                    {true, ?SUCCESS, EquipInfo#goods.id, NewDivision, LastPS};
                Error ->
                    ?ERR("equip_upgrade_division error:~p", [Error]),
                    {false, ?FAIL, PS}
            end
    end.

up_div_wash_attr(EquipPos, EquipWash) ->
    #equip_wash{duan = Duan, attr = Attr} = EquipWash,
    F = fun(AttrTmp, List) ->
        {Pos, _Color, AttrId, AttrVal} = AttrTmp,
        #equip_wash_attr_cfg{
            attr_green = [{_, [GreenLow, GreenHigh]}],
            attr_blue = [{_, [BlueLow, BlueHigh]}],
            attr_purple = [{_, [PurpleLow, PurpleHigh]}],
            attr_orange = [{_, [OrangeLow, OrangeHigh]}],
            attr_red = [{_, [RedLow, RedHigh]}]} =
            data_equip:get_wash_attr_cfg(EquipPos, Duan, AttrId),
        NewColor =
            case AttrVal of
                AttrVal when AttrVal < GreenLow -> ?GREEN;
                AttrVal when (GreenLow =< AttrVal andalso GreenHigh >= AttrVal) -> ?GREEN;
                AttrVal when (BlueLow =< AttrVal andalso BlueHigh >= AttrVal) -> ?BLUE;
                AttrVal when (PurpleLow =< AttrVal andalso PurpleHigh >= AttrVal) -> ?PURPLE;
                AttrVal when (OrangeLow =< AttrVal andalso OrangeHigh >= AttrVal) -> ?ORANGE;
                AttrVal when (RedLow =< AttrVal andalso RedHigh >= AttrVal) -> ?RED;
                AttrVal when AttrVal > RedHigh -> ?RED;
                Error -> ?ERR("equip error:~p", [Error]), 0
            end,
        [{Pos, NewColor, AttrId, AttrVal} | List]
        end,
    NewAttr = lists:foldl(F, [], Attr),
    LastAttr =  lists:reverse(NewAttr),
    NewEquipWash = EquipWash#equip_wash{duan = Duan, attr = LastAttr},
    NewEquipWash.

%% ------------------------------- 宝石镶嵌 -------------------------------
equip_stone(PS, EquipPos, StonePos, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:equip_stone(PS, GoodsStatus, EquipPos, StonePos, GoodsId) of
        {true, GoodsInfo} ->
            do_equip_stone(PS, GoodsStatus, EquipPos, StonePos, GoodsInfo);
        {false, Res} ->
            {false, Res, PS}
    end.

do_equip_stone(PS, GoodsStatus, EquipPos, StonePos, GoodsInfo) ->
    case do_equip_stone_core(PS, GoodsStatus, EquipPos, StonePos, GoodsInfo) of
        {ok, NewPS} ->
            NewGoodsStatus = lib_goods_do:get_goods_status(),
            EventPS = lib_equip_event:equip_stone_event(NewPS, NewGoodsStatus),
            {true, ?SUCCESS, GoodsInfo#goods.goods_id, EventPS};
        {false, ErrCode, NewPS} ->
            {false, ErrCode, NewPS}
    end.

do_equip_stone_core(PS, GoodsStatus, EquipPos, StonePos, GoodsInfo) ->
    #player_status{id = RoleId} = PS,
    #goods{id = GoodsId, bind = Bind, goods_id = StoneTypeId} = GoodsInfo,
    #goods_status{equip_stone_list = EquipStoneList} = GoodsStatus,
    {_, PosStoneInfoR} = ulists:keyfind(EquipPos, 1, GoodsStatus#goods_status.equip_stone_list, {EquipPos, #equip_stone{}}),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
    %% 该部位已经镶嵌宝石要卸下返还给玩家
    case lists:keyfind(StonePos, #stone_info.pos, PosStoneList) of
        #stone_info{bind = OldBind, gtype_id = OldStoneTypeId} = StoneInfo ->
            RStonesL = [{?TYPE_GOODS, OldStoneTypeId, 1, OldBind}];
        _ ->
            OldStoneTypeId = 0, StoneInfo = #stone_info{}, RStonesL = []
    end,
    case OldStoneTypeId =/= StoneTypeId of
        true -> %% 宝石孔镶嵌的旧宝石和新宝石不一致才操作
            %% 扣除背包的宝石
            case lib_goods_api:delete_more_by_list(RoleId, [{GoodsId, 1}], equip_stone) of
                1 ->
                    %% 日志
                    lib_log_api:log_stone_inlay(RoleId, 3, EquipPos, StonePos, OldStoneTypeId, StoneTypeId, ""),
                    %% 更新数据库
                    lib_goods_util:change_equip_stone(RoleId, EquipPos, StonePos, StoneTypeId, Bind),
                    NewStatus = lib_goods_do:get_goods_status(),
                    NewPosStoneList = lists:keystore(StonePos, #stone_info.pos, PosStoneList, StoneInfo#stone_info{pos = StonePos, bind = Bind, gtype_id = StoneTypeId}),
                    NewPosStoneInfoRTmp = PosStoneInfoR#equip_stone{stone_list = NewPosStoneList},
                    NewStoneRating = cal_stone_rating(EquipPos, NewPosStoneInfoRTmp),
                    NewPosStoneInfoR = NewPosStoneInfoRTmp#equip_stone{rating = NewStoneRating},
                    NewEquipStoneList = lists:keystore(EquipPos, 1, EquipStoneList, {EquipPos, NewPosStoneInfoR}),
                    NewStatus2 = NewStatus#goods_status{
                        equip_stone_list = NewEquipStoneList
                    },
                    %% 更新全身奖励
                    StoneAwardList = update_12_equip_award(?WHOLE_AWARD_STONE, [NewStatus2]),
                    LastStatus = NewStatus2#goods_status{stone_award_list = StoneAwardList},
                    %% 战力更新
                    {ok, PS1} = lib_goods_util:count_role_equip_attribute(PS, LastStatus),
                    %% 更新宝石战力值
                    update_equip_sub_mod_power(PS1, ?EQUIP_STONE_POWER),
                    %% 返还旧宝石
                    Produce = #produce{title = utext:get(1520005), content = utext:get(1520006), reward = RStonesL, type = equip_stone_return, show_tips = 1},
                    {_, LastPS} = lib_goods_api:send_reward_with_mail(PS1, Produce),
                    {ok, LastPS};
                ErrCode ->
                    {false, ErrCode, PS}
            end;
        false ->
            {ok, PS}
    end.

%% 计算宝石总战力(不算精炼属性的)
count_stone_total_power(PlayerStatus) when is_record(PlayerStatus, player_status) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    AttrList = data_goods:count_stone_attribute(GoodsStatus),
    AttrR = lib_player_attr:to_attr_record(AttrList),
    lib_player:calc_all_power(AttrR);
count_stone_total_power(_) ->
    0.

%% 计算宝石总等级
count_stone_total_lv(PlayerStatus) when is_record(PlayerStatus, player_status) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{stone_award_list = StoneAwardList} = GoodsStatus,
    lists:foldl(fun({StoneLv, Num}, SumTemp) ->
        SumTemp + StoneLv * Num
                end, 0, StoneAwardList);
count_stone_total_lv(_) ->
    0.


count_stone_total_lv_off_line(#player_status{off = Off} = _PlayerStatus) ->
    GoodsStatus = Off#status_off.goods_status,
    #goods_status{equip_stone_list = StoneList} = GoodsStatus,
    AllStoneList = lists:flatten([StoneInfo#equip_stone.stone_list ||{_, StoneInfo} <- StoneList]),
%%    ?MYLOG("stone", "AllStoneList ~p~n", [AllStoneList]),
    lists:foldl(fun(#stone_info{gtype_id = GoodsTypeId}, SumTemp) ->
        case data_equip:get_stone_lv_cfg(GoodsTypeId) of
            #equip_stone_lv_cfg{lv = Lv} ->
                SumTemp + Lv;
            _ ->
                SumTemp
        end end, 0, AllStoneList);
count_stone_total_lv_off_line(_) ->
    0.

%% ------------------------------- 宝石拆除 %% -------------------------------

%%--------------------------------------------------
%% 自动卸下宝石日志
%% @param  RoleId     玩家id
%% @param  Type       UNLOAD_STONE_TYPE_UNEQUIP | UNLOAD_STONE_TYPE_REPLACE_EQUIP | UNLOAD_STONE_TYPE_VIP_TIME_OUT
%% @param  EquipPos   装备位置
%% @param  StoneInfoL [#stone_info{}]
%% @return            description
%%--------------------------------------------------
log_auto_unload_stone(RoleId, Type, EquipPos, StoneInfoL) ->
    Msg = case Type of
              ?UNLOAD_STONE_TYPE_UNEQUIP ->
                  "玩家卸下装备";
              ?UNLOAD_STONE_TYPE_REPLACE_EQUIP ->
                  "玩家替换装备";
              ?UNLOAD_STONE_TYPE_VIP_TIME_OUT ->
                  "玩家VIP过期";
              _ ->
                  "其他"
          end,
    F = fun(T) ->
        case T of
            #stone_info{pos = CellPos, gtype_id = GTypeId} ->
                lib_log_api:log_stone_inlay(RoleId, 4, EquipPos, CellPos, GTypeId, 0, Msg);
            _ ->
                skip
        end
        end,
    lists:foreach(F, StoneInfoL).

%% 检测已经在装备的宝石，不满足要求的要卸下
%% Vip过期的时候会检测
unload_stones_on_equip(Player, Type) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    do_unload_stones_on_equip(Player, GoodsStatus, Type).

do_unload_stones_on_equip(Player, GoodsStatus, Type) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        Vip = Player#player_status.figure#figure.vip,
        VipType = Player#player_status.figure#figure.vip_type,
        {NewGoodsStatusT, RemoveL, RStonesL, UpdatePosL} = do_unload_stones_on_equip_core(VipType, Vip, GoodsStatus, Type),
        {ok, NewGoodsStatusT, RemoveL, RStonesL, UpdatePosL}
        end,
    case catch lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, RemoveL, RStonesList, UpdatePosL} ->

            %% 宝石移除日志
            F1 = fun(T) ->
                case T of
                    {TmpEquipPos, TmpRemoveL} when TmpRemoveL =/= [] ->
                        log_auto_unload_stone(Player#player_status.id, Type, TmpEquipPos, TmpRemoveL);
                    _ ->
                        skip
                end
                 end,
            lists:foreach(F1, RemoveL),

            lib_goods_do:set_goods_status(NewGoodsStatus),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(Player, NewGoodsStatus),
            %% 卸下宝石的装备要更新客户端缓存
            EquipLocation = NewGoodsStatus#goods_status.equip_location,
            lists:foreach(fun(TmpEquipPos) ->
                case lists:keyfind(TmpEquipPos, 1, EquipLocation) of
                    {TmpEquipPos, TmpEquipId} ->
                        pp_goods:handle(15000, Player, [TmpEquipId]);
                    false ->
                        skip
                end
                          end, UpdatePosL),
            case RStonesList =/= [] of
                true ->
                    %% 返还卸下的宝石给玩家
                    LastGoodsList = lists:map(fun({goods, TmpGTypeId, TmpNum, TmpBind}) ->
                        case TmpBind of
                            ?UNBIND ->
                                {?TYPE_GOODS, TmpGTypeId, TmpNum};
                            _ ->
                                {?TYPE_BIND_GOODS, TmpGTypeId, TmpNum}
                        end
                                              end, RStonesList),
                    Produce = #produce{title = utext:get(209), content = utext:get(210), reward = LastGoodsList, type = equip_stone_return, show_tips = 0},
                    lib_goods_api:send_reward_with_mail(NewGoodsStatus#goods_status.player_id, Produce);
                false ->
                    skip
            end,
            {ok, LastPS};
        Error ->
            ?ERR("unload_stones_on_equip error:~p", [Error]),
            {ok, Player}
    end.

do_unload_stones_on_equip_core(VipType, Vip, GoodsStatus, Type) ->
    F = fun({EquipPos, #equip_stone{stone_list = StoneList}}, {TmpGoodsStatus, RemoveL, UnloadL, UpdatePosL}) ->
        case StoneList =/= [] of
            true ->
                {NewTmpGoodsStatus, RemoveStoneL, TmpL} = unload_stones(VipType, Vip, TmpGoodsStatus, EquipPos, Type),
                case TmpL =/= [] of
                    true ->
                        NewUpdatePosL = [EquipPos | UpdatePosL];
                    false ->
                        NewUpdatePosL = UpdatePosL
                end,
                {NewTmpGoodsStatus, [{EquipPos, RemoveStoneL}] ++ RemoveL, TmpL ++ UnloadL, NewUpdatePosL};
            false ->
                {TmpGoodsStatus, RemoveL, UnloadL, UpdatePosL}
        end
        end,
    #goods_status{equip_stone_list = EquipStoneList} = GoodsStatus,
    lists:foldl(F, {GoodsStatus, [], [], []}, EquipStoneList).

%% 返还宝石给玩家
return_stone_to_player(_RoleId, []) ->
    skip;
return_stone_to_player(RoleId, GoodsList) ->
    LastGoodsList = lists:map(fun({goods, TmpGTypeId, TmpNum, TmpBind}) ->
        case TmpBind of
            ?UNBIND ->
                {?TYPE_GOODS, TmpGTypeId, TmpNum};
            _ ->
                {?TYPE_BIND_GOODS, TmpGTypeId, TmpNum}
        end
                              end, GoodsList),
    Produce = #produce{title = utext:get(1520005), content = utext:get(1520006), reward = LastGoodsList, type = equip_stone_return, show_tips = 1},
    lib_goods_api:send_reward_with_mail(RoleId, Produce).

%%--------------------------------------------------
%% 替换装备的时候自动把多余的宝石卸下
%% @param  PS          description
%% @param  GoodsStatus description
%% @param  EquipPos    装备位置
%% @return             description
%%--------------------------------------------------
unload_stones(VipType, RoleVip, GoodsStatus, EquipPos, Type) ->
    #goods_status{player_id = PlayerId, equip_stone_list = EquipStoneList} = GoodsStatus,
    PosStoneInfo = lists:keyfind(EquipPos, 1, EquipStoneList),
    {EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,

    {RemoveL, NewPosStoneList} = case Type of
         ?UNLOAD_STONE_TYPE_UNEQUIP ->
             {PosStoneList, []};
         _ ->
             %% 计算要卸下的宝石以及装备剩余的宝石列表
             Fun = fun(#stone_info{pos = TmpPos} = TmpStoneInfo, {TmpRemovePosL, TmpPosStoneL}) ->
                 CheckList = [
                     {check_inlay_pos_unlock, GoodsStatus, VipType, RoleVip, EquipPos, TmpPos}
                 ],
                 case lib_equip_check:checklist(CheckList) of
                     true ->
                         {TmpRemovePosL, [TmpStoneInfo | TmpPosStoneL]};
                     _ ->
                         {[TmpStoneInfo | TmpRemovePosL], TmpPosStoneL}
                 end
                   end,
             lists:foldl(Fun, {[], []}, PosStoneList)
     end,

    case RemoveL =/= [] of
        true ->
            RemovePosL = [Pos || #stone_info{pos = Pos} <- RemoveL],
            SqlArgs = [PlayerId, EquipPos, util:link_list(RemovePosL)],
            Sql = io_lib:format(<<"delete from equip_stone where player_id = ~p and equip_pos = ~p and stone_pos in (~s)">>, SqlArgs),
            db:execute(Sql),
            %% 返还卸下的宝石给玩家
            GoodsList = lists:foldl(fun(#stone_info{bind = TmpBind, gtype_id = TmpGTypeId}, AccList) ->
                case lists:keyfind({TmpGTypeId, TmpBind}, 1, AccList) of
                    {{TmpGTypeId, TmpBind}, PreNum} ->
                        skip;
                    _ ->
                        PreNum = 0
                end,
                lists:keystore({TmpGTypeId, TmpBind}, 1, AccList, {{TmpGTypeId, TmpBind}, PreNum + 1})
                                    end, [], RemoveL),
            LastGoodsList = [{goods, TmpGTypeId, TmpNum, TmpBind} || {{TmpGTypeId, TmpBind}, TmpNum} <- GoodsList],
            NewPosStoneInfoRTmp = PosStoneInfoR#equip_stone{stone_list = NewPosStoneList},
            NewStoneRating = cal_stone_rating(EquipPos, NewPosStoneInfoRTmp),
            NewPosStoneInfoR = NewPosStoneInfoRTmp#equip_stone{rating = NewStoneRating},
            NewEquipStoneList = lists:keystore(EquipPos, 1, EquipStoneList, {EquipPos, NewPosStoneInfoR}),
            NewStatus = GoodsStatus#goods_status{equip_stone_list = NewEquipStoneList},
            {NewStatus, RemoveL, LastGoodsList};
        false ->
            {GoodsStatus, RemoveL, []}
    end.

unequip_stone(PS, EquipPos, StonePos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:unequip_stone(GoodsStatus, EquipPos, StonePos) of
        {true, StoneInfo} ->
            do_unequip_stone(PS, EquipPos, StonePos, StoneInfo);
        {false, Res} ->
            {false, Res, PS}
    end.

do_unequip_stone(PS, EquipPos, StonePos, StoneInfo) ->
    {ok, NewPS} = do_unequip_stone_core(PS, EquipPos, StonePos, StoneInfo),
    lib_train_act:stone_train_power_up(NewPS),
    {true, ?SUCCESS, NewPS}.

do_unequip_stone_core(PS, EquipPos, StonePos, StoneInfo) ->
    #player_status{id = RoleId} = PS,
    %% 返还卸下的宝石给玩家
    #stone_info{bind = Bind, gtype_id = GTypeId} = StoneInfo,
    RewardList = [{?TYPE_GOODS, GTypeId, 1, Bind}],
    %% 日志
    lib_log_api:log_stone_inlay(RoleId, 2, EquipPos, StonePos, GTypeId, 0, ""),
    lib_goods_util:unequip_stone(RoleId, EquipPos, StonePos),
    %% 发道具
    Produce = #produce{reward = RewardList, type = unequip_stone, show_tips = 1},
    NewPS1 = lib_goods_api:send_reward(PS, Produce),
    %% 更新GS
    NewStatus = lib_goods_do:get_goods_status(),
    #goods_status{equip_stone_list = EquipStoneList} = NewStatus,
    {_, PosStoneInfoR} = ulists:keyfind(EquipPos, 1, EquipStoneList, {EquipPos, #equip_stone{}}),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
    NewPosStoneList = lists:keydelete(StonePos, #stone_info.pos, PosStoneList),
    NewPosStoneInfoRTmp = PosStoneInfoR#equip_stone{stone_list = NewPosStoneList},
    NewStoneRating = cal_stone_rating(EquipPos, NewPosStoneInfoRTmp),
    NewPosStoneInfoR = NewPosStoneInfoRTmp#equip_stone{rating = NewStoneRating},
    NewEquipStoneList = lists:keystore(EquipPos, 1, EquipStoneList, {EquipPos, NewPosStoneInfoR}),
    NewStatus1 = NewStatus#goods_status{equip_stone_list = NewEquipStoneList},
    %% 更新全身奖励
    StoneAwardList = update_12_equip_award(?WHOLE_AWARD_STONE, [NewStatus1]),
    LastStatus = NewStatus1#goods_status{stone_award_list = StoneAwardList},
    lib_goods_do:set_goods_status(LastStatus),
    NewPS2 = auto_downgrade_whole_award(NewPS1, ?WHOLE_AWARD_STONE),
    %% 战力
    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS2),
    %% 更新宝石战力值
    update_equip_sub_mod_power(LastPS, ?EQUIP_STONE_POWER),
    {ok, LastPS}.

%%--------------------------------------------------
%% 在佩戴位置升级宝石
%% @param  PS          description
%% @param  GoodsStatus description
%% @return             description
%%--------------------------------------------------
upgrade_stone_on_equip(PS, EquipPos, StonePos, IsOneKey) ->
    #player_status{id = RoleId} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_stone_on_equip(PS, GoodsStatus, EquipPos, StonePos, IsOneKey) of
        {false, Reason} ->
            {false, Reason};
        {true, StoneInfo, NextLvStoneId, _NeedNum, CostList} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                upgrade_stone_on_equip_core(RoleId, GoodsStatus, StoneInfo, EquipPos, StonePos, NextLvStoneId, CostList)
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, UpdateGoodsList} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    lib_goods_api:notify_client_num(RoleId, UpdateGoodsList),
                    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(PS),
                    %% 更新宝石战力值
                    update_equip_sub_mod_power(LastPS, ?EQUIP_STONE_POWER),
                    EventPS = lib_equip_event:equip_stone_event(LastPS, NewGoodsStatus),
                    {true, EventPS, NextLvStoneId};
                Err ->
                    ?ERR("upgrade_stone_on_equip ~p~n", [Err]),
                    {false, ?FAIL}
            end
    end.

upgrade_stone_on_equip_core(RoleId, GoodsStatus, StoneInfo, EquipPos, StonePos, NextLvStoneId, CostList) ->
    #goods_status{equip_stone_list = EquipStoneList} = GoodsStatus,
    #stone_info{bind = Bind, gtype_id = _GTypeId} = StoneInfo,
    PosStoneInfo = lists:keyfind(EquipPos, 1, EquipStoneList),
    {EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
    %% 删除合成所需宝石
    GoodsTypeList = [{GoodsTypeId, Num} || {_, GoodsTypeId, Num} <- CostList],
    F = fun lib_goods:delete_type_list_goods/2,
    {_, GoodsStatus1} = lib_goods_check:list_handle(F, GoodsStatus, GoodsTypeList),
    %% 更新装备上的宝石信息
    NewPosStoneList = lists:keystore(StonePos, #stone_info.pos, PosStoneList, StoneInfo#stone_info{pos = StonePos, bind = Bind, gtype_id = NextLvStoneId}),
    NewPosStoneInfoRTmp = PosStoneInfoR#equip_stone{stone_list = NewPosStoneList},
    NewStoneRating = cal_stone_rating(EquipPos, NewPosStoneInfoRTmp),
    NewPosStoneInfoR = NewPosStoneInfoRTmp#equip_stone{rating = NewStoneRating},
    NewEquipStoneList = lists:keystore(EquipPos, 1, EquipStoneList, {EquipPos, NewPosStoneInfoR}),
    %% 更新数据库
    lib_goods_util:change_equip_stone(RoleId, EquipPos, StonePos, NextLvStoneId, Bind),
    %% 更新GoodsStatus
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(GoodsStatus1#goods_status.dict),
    GoodsStatus2 = GoodsStatus1#goods_status{
        dict = GoodsDict, equip_stone_list = NewEquipStoneList
    },
    %% 更新全身奖励
    StoneAwardList = update_12_equip_award(?WHOLE_AWARD_STONE, [GoodsStatus2]),
    NewGoodsStatus = GoodsStatus2#goods_status{stone_award_list = StoneAwardList},
    %% 日志
    lib_log_api:log_combine_stone(RoleId, 1, CostList, [{?TYPE_GOODS, NextLvStoneId, 1}]),
    {ok, NewGoodsStatus, GoodsL}.

%%--------------------------------------------------
%% 宝石合成
%% @param  PS          description
%% @param  GoodsStatus description
%% @return             description
%%--------------------------------------------------
combine_stone(PS, GoodsTypeId, IsOneKey) ->
    #player_status{id = RoleId} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:combine_stone(PS, GoodsStatus, GoodsTypeId, IsOneKey) of
        {false, Reason} ->
            {false, Reason};
        {true, CostList, NextLvStoneId, CreateNum} ->
            case lib_goods_api:cost_object_list_with_check(PS, CostList, combine_stone, "") of
                {true, PS1} ->
                    %% 日志
                    lib_log_api:log_combine_stone(RoleId, 2, CostList, [{?TYPE_GOODS, NextLvStoneId, CreateNum}]),
                    NewPS = lib_goods_api:send_reward(PS1, #produce{type = combine_stone, reward = [{?TYPE_GOODS, NextLvStoneId, CreateNum}], show_tips = 3}),
                    {true, NewPS};
                {false, Res, _} ->
                    {false, Res}
            end
    end.

combine_stone_one_key_cost(PS, TargetId, NeedNum) ->
    LowStoneIds = get_lower_stone_id_list(TargetId, []),
    GoodsTypeList = [GoodsTypeId || {GoodsTypeId, _} <- LowStoneIds],
    %?PRINT("combine_stone_one_key_cost ~p~n", [GoodsTypeList]),
    GoodsNumList = lib_goods_api:get_goods_num(PS, GoodsTypeList),
    combine_stone_one_key_cost_do(TargetId, NeedNum, GoodsNumList, []).

combine_stone_one_key_cost_do(GoodsTypeId, NeedNum, GoodsNumList, CostList) ->
    StoneLvCfg = data_equip:get_stone_lv_cfg(GoodsTypeId),
    case lists:keyfind(GoodsTypeId, 1, GoodsNumList) of
        false ->
            GoodsNum = 0;
        {_, GoodsNum} ->
            ok
    end,
    if
        GoodsNum >= NeedNum ->
            {ok, [{GoodsTypeId, NeedNum} | CostList]};
        is_record(StoneLvCfg, equip_stone_lv_cfg) == false ->
            {ok, [{GoodsTypeId, NeedNum} | CostList]};
        StoneLvCfg#equip_stone_lv_cfg.pre_lv_stone == 0 ->
            {ok, [{GoodsTypeId, NeedNum} | CostList]};
        true ->
            PreLvStone = StoneLvCfg#equip_stone_lv_cfg.pre_lv_stone,
            #equip_stone_lv_cfg{need_num = CombineNeedNum} = data_equip:get_stone_lv_cfg(PreLvStone),
            PreLvNeedNum = (NeedNum - GoodsNum) * CombineNeedNum,
            NewCostList = ?IF(GoodsNum > 0, [{GoodsTypeId, GoodsNum} | CostList], CostList),
            combine_stone_one_key_cost_do(PreLvStone, PreLvNeedNum, GoodsNumList, NewCostList)
    end.

get_lower_stone_id_list(TargetId, List) ->
    #equip_stone_lv_cfg{pre_lv_stone = PreLvStone} = data_equip:get_stone_lv_cfg(TargetId),
    case PreLvStone > 0 of
        true ->
            get_lower_stone_id_list(PreLvStone, [{TargetId, PreLvStone} | List]);
        _ ->
            lists:reverse(List)
    end.


%% 宝石精炼
stone_refine(PS, EquipPos, GTypeId, OneKey) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:stone_refine(PS, GoodsStatus, EquipPos, GTypeId, OneKey) of
        {true, ExpPlus, Cost} ->
            do_stone_refine(PS, GoodsStatus, EquipPos, ExpPlus, Cost, OneKey);
        {false, Res} ->
            {false, Res, PS}
    end.

do_stone_refine(PS, GoodsStatus, EquipPos, ExpPlus, Cost, _OneKey) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, equip_stone_refine, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_stone_list = EquipStoneList
                } = GoodsStatus,
                case lists:keyfind(EquipPos, 1, EquipStoneList) of
                    {EquipPos, PosStoneInfoR} ->
                        skip;
                    _ ->
                        PosStoneInfoR = #equip_stone{}
                end,
                #equip_stone{exp = Exp, refine_lv = RefineLv} = PosStoneInfoR,
                {NewRefineLv, NewRemainExp} = count_refine_lv_helper(EquipPos, RefineLv, Exp, ExpPlus),

                IsUp = ?IF(NewRefineLv =/= RefineLv, 1, 0),

                lib_goods_util:stone_refine(PS#player_status.id, EquipPos, NewRefineLv, NewRemainExp),

                NewPosStoneInfoRTmp = PosStoneInfoR#equip_stone{refine_lv = NewRefineLv, exp = NewRemainExp},
                NewStoneRating = cal_stone_rating(EquipPos, NewPosStoneInfoRTmp),
                NewPosStoneInfoR = NewPosStoneInfoRTmp#equip_stone{rating = NewStoneRating},

                NewEquipStoneList = lists:keystore(EquipPos, 1, EquipStoneList, {EquipPos, NewPosStoneInfoR}),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                NewStatus1 = NewStatus#goods_status{
                    dict = Dict,
                    equip_stone_list = NewEquipStoneList
                },
                {ok, NewStatus1, IsUp, GoodsL, NewPS, RefineLv, NewRefineLv, Cost};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, IsUp, UpdateGoodsList, NewPS, RefineLv, NewRefineLv, Cost} ->
            %% 宝石精炼日志
            lib_log_api:log_stone_refine(NewPS#player_status.id, EquipPos, RefineLv, NewRefineLv, Cost),
            lib_goods_do:set_goods_status(NewGoodsStatus),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            %% 更新宝石战力值
            update_equip_sub_mod_power(LastPS, ?EQUIP_STONE_POWER),
            lib_train_act:stone_train_power_up(LastPS),
            {true, ?SUCCESS, IsUp, LastPS};
        Error ->
            ?ERR("equip_stone_refine error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

count_refine_lv_helper(EquipPos, Lv, Exp, ExpPlus) ->
    case data_equip:get_refine_cfg(EquipPos, Lv) of
        #equip_stone_refine_cfg{exp = MaxExp} when MaxExp > 0 ->
            case Exp + ExpPlus >= MaxExp of
                true ->
                    NewLv = Lv + 1,
                    count_refine_lv_helper(EquipPos, NewLv, 0, Exp + ExpPlus - MaxExp);
                false ->
                    {Lv, Exp + ExpPlus}
            end;
        _ ->
            {Lv, Exp + ExpPlus}
    end.

%% 根据装备位置，宝石位置获取宝石物品信息
get_stone_by_pos(GoodsStatus, EquipPos, StonePos) ->
    PosStoneInfo = lists:keyfind(EquipPos, 1, GoodsStatus#goods_status.equip_stone_list),
    {EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
    lists:keyfind(StonePos, #stone_info.pos, PosStoneList).

get_stone_list_by_pos(GoodsStatus, EquipPos) ->
    PosStoneInfo = lists:keyfind(EquipPos, 1, GoodsStatus#goods_status.equip_stone_list),
    {_EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    #equip_stone{stone_list = PosStoneList} = PosStoneInfoR,
    PosStoneList.

get_equip_stone_info_by_pos(GoodsStatus, EquipPos) ->
    PosStoneInfo = lists:keyfind(EquipPos, 1, GoodsStatus#goods_status.equip_stone_list),
    {_EquipPos, PosStoneInfoR} = ?IF(PosStoneInfo == false, {EquipPos, #equip_stone{}}, PosStoneInfo),
    PosStoneInfoR.

%% 根据装备位置，获取装备信息
get_equip_by_location(GoodsStatus, EquipPos) ->
    EquipLocation = GoodsStatus#goods_status.equip_location,
    % ?MYLOG("kyd_equip", "EquipLocation:~p~n", [EquipLocation]),
    case lists:keyfind(EquipPos, 1, EquipLocation) of
        false ->
            [];
        {EquipPos, EquipId} ->
            lib_goods_util:get_goods(EquipId, GoodsStatus#goods_status.dict)
    end.


%% ----------------------------- 全身装备奖励 %% -----------------------------
%% 手动激活全身奖励
manual_whole_award(PS, Type) ->
    #player_status{sid = Sid} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    {AwardList, CurrentLv} = get_whole_award_info_by_type(Type, GoodsStatus),
    AllLv = get_12_equip_award_sum_lv(AwardList, Type),
    Ids = data_equip:get_whole_reward_ids_by_type(Type),
    case get_whole_reward_cfg(Ids, AllLv, CurrentLv) of
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15260, [?ERRCODE(err152_lv_limit), Type, 0]);
        #base_whole_reward{need_lv = NewCurrentLv} ->
            update_whole_award_lv(Type, NewCurrentLv, PS)
    end.

%% 触发全身奖励自动降级
%% @return #player_status{}
auto_downgrade_whole_award(PS, ?WHOLE_AWARD_STONE = Type) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    {AwardList, CurrentLv} = get_whole_award_info_by_type(Type, GoodsStatus),
    AllLv = get_12_equip_award_sum_lv(AwardList, Type),
    Ids = data_equip:get_whole_reward_ids_by_type(Type),
    case get_range(Ids, AllLv) of
        false ->
            update_whole_award_lv(Type, 0, PS);
        #base_whole_reward{need_lv = NewCurrentLv, next_nlv = NextLv}
          when CurrentLv > NextLv ->
            update_whole_award_lv(Type, NewCurrentLv, PS);
        _ ->
            PS
    end;
auto_downgrade_whole_award(PS, _) -> PS.

%% 手动全身奖励信息
list_manual_whole_award(PS) ->
    #player_status{sid = Sid} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{
        stren_whole_lv = StrenWholeLv,
        stone_whole_lv = StoneWholeLv
    } = GoodsStatus,
    SendList = [{?WHOLE_AWARD_STREN, StrenWholeLv}, {?WHOLE_AWARD_STONE, StoneWholeLv}],
    lib_server_send:send_to_sid(Sid, pt_152, 15261, [SendList]).

init_manual_whole_award(RoleId) ->
    List = db:get_all(io_lib:format(?SQL_WHOLE_AWARD_SELECT, [RoleId])),
    AllList = [{Type, 0}||Type<-?MANUAL_WHOLE_AWARD_LIST],
    F = fun([Type, Val], AccL) -> lists:keyreplace(Type, 1, AccL, {Type, Val}) end,
    lists:keysort(1, lists:foldl(F, AllList, List)).

%% 获取全身装备奖励信息
%% @return {[{Lv, Num},...], CurrentLv}
get_whole_award_info_by_type(?WHOLE_AWARD_STREN, GoodsStatus) ->
    #goods_status{stren_award_list = AwardList, stren_whole_lv = CurrentLv} = GoodsStatus,
    {AwardList, CurrentLv};
get_whole_award_info_by_type(?WHOLE_AWARD_STONE, GoodsStatus) ->
    #goods_status{stone_award_list = AwardList, stone_whole_lv = CurrentLv} = GoodsStatus,
    {AwardList, CurrentLv};
get_whole_award_info_by_type(_, _) -> {[], 0}.

%% 更新全身装备当前等级操作
%% @return #player_status{}
update_whole_award_lv(Type, CurrentLv, PS) ->
    #player_status{sid = Sid, id = RoleId} = PS,
    % 入库
    Sql = io_lib:format(?SQL_WHOLE_AWARD_REPLACE, [RoleId, Type, CurrentLv]),
    db:execute(Sql),
    % 更新物品状态
    GoodsStatus = lib_goods_do:get_goods_status(),
    NewGoodsStatus = set_gs_whole_award_lv(Type, CurrentLv, GoodsStatus),
    lib_goods_do:set_goods_status(NewGoodsStatus),
    % 装备属性更新
    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(PS, NewGoodsStatus),
    lib_server_send:send_to_sid(Sid, pt_152, 15260, [?SUCCESS, Type, CurrentLv]),
    LastPS.

%% 设置物品状态全身装备当前等级
set_gs_whole_award_lv(?WHOLE_AWARD_STREN, CurrentLv, GS) ->
    GS#goods_status{stren_whole_lv = CurrentLv};
set_gs_whole_award_lv(?WHOLE_AWARD_STONE, CurrentLv, GS) ->
    GS#goods_status{stone_whole_lv = CurrentLv};
set_gs_whole_award_lv(_, _, GS) -> GS.

%% 直接增加全身装备奖励(初始化的时候调用)
%% OneTypeWholeAward  :: list()    列表
%% Type               :: integer() 类型 1.强化 2.星级 3.宝石等级
%% 全身奖励：强化 [{强化等级, 部位数量}]
%% 全身奖励：星级 [{装备星级, 部位数量}]
%% 全身奖励：宝石 [{宝石等级, 数量}]
%% 全身奖励：精炼 [{精炼等级, 数量}]
add_12_equip_award(GoodsInfo, [GoodsStatus, OneTypeWholeAward, Type]) when is_record(GoodsInfo, goods) ->
    [_GoodsStatus, AwardList, _Type] = do_add_12_equip_award(GoodsInfo, [GoodsStatus, OneTypeWholeAward, Type]),
    AwardList.

do_add_12_equip_award(#goods{location = ?GOODS_LOC_EQUIP} = GoodsInfo, [GoodsStatus, OneTypeWholeAward, Type]) ->
    case Type of
        %% 强化
        ?WHOLE_AWARD_STREN ->
            %Stren = get_stren(GoodsStatus, GoodsInfo#goods.cell),
            StrenLv = GoodsInfo#goods.other#goods_other.stren,
            NewOneTypeWholeAward = case StrenLv > 0 of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{StrenLv, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        %% 星级
        ?WHOLE_AWARD_STAR ->
            Star = get_equip_star(GoodsInfo),
            NewOneTypeWholeAward = case Star > 0 of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{Star, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        %% 镶嵌
        ?WHOLE_AWARD_STONE ->
            StoneList = get_stone_list_by_pos(GoodsStatus, GoodsInfo#goods.cell),
            NewOneTypeWholeAward = lists:foldl(fun(#stone_info{gtype_id = GTypeId}, AccList) ->
                case data_equip:get_stone_lv_cfg(GTypeId) of
                    #equip_stone_lv_cfg{lv = Lv} when Lv > 0 ->
                        ulists:kv_list_plus_extra([AccList, [{Lv, 1}]]);
                    _ ->
                        AccList
                end
                                               end, OneTypeWholeAward, StoneList),
            [GoodsStatus, NewOneTypeWholeAward, Type];
        %% 精炼
        ?WHOLE_AWARD_REFINE ->
            %Refine = get_refine(GoodsStatus, GoodsInfo#goods.cell),
            RefineLv = GoodsInfo#goods.other#goods_other.refine,
            NewOneTypeWholeAward = case RefineLv > 0 of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{RefineLv, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        ?WHOLE_AWARD_STAGE ->
            Stage = get_equip_stage(GoodsInfo),
            NewOneTypeWholeAward = case Stage > 0 of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{Stage, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        ?WHOLE_AWARD_COLOR ->
            Color = data_goods:get_goods_color(GoodsInfo#goods.goods_id),
            NewOneTypeWholeAward = case Color > 0 of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{Color, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        ?WHOLE_AWARD_RED_EQUIP ->
            Stage = get_equip_stage(GoodsInfo),
            Star = get_equip_star(GoodsInfo),
            NewOneTypeWholeAward = case satisfied_red_equip(GoodsInfo) of
                                       true ->
                                           ulists:kv_list_plus_extra([OneTypeWholeAward, [{{Stage, Star}, 1}]]);
                                       false ->
                                           OneTypeWholeAward
                                   end,
            [GoodsStatus, NewOneTypeWholeAward, Type];
        _ ->
            [GoodsStatus, OneTypeWholeAward, Type]
    end;
do_add_12_equip_award(_GoodsInfo, [GoodsStatus, OneTypeWholeAward, Type]) ->
    [GoodsStatus, OneTypeWholeAward, Type].


recalc_12_equip_reward(GoodsStatus, OldGoodsInfo, NewGoodsInfo) ->
    OldGTypeId = ?IF(is_record(OldGoodsInfo, goods) == true, OldGoodsInfo#goods.goods_id, 0),
    GTypeId = NewGoodsInfo#goods.goods_id,
    case OldGTypeId =/= GTypeId of
        true ->
            % 替换或增加全身装备奖励
            StarAwardList = update_12_equip_award(?WHOLE_AWARD_STAR, [GoodsStatus, OldGoodsInfo, NewGoodsInfo]),
            StrenAwardList = update_12_equip_award(?WHOLE_AWARD_STREN, [GoodsStatus]),
            RefineAwardList = update_12_equip_award(?WHOLE_AWARD_REFINE, [GoodsStatus]),
            StoneAwardList = update_12_equip_award(?WHOLE_AWARD_STONE, [GoodsStatus]),
            StageAwardList = update_12_equip_award(?WHOLE_AWARD_STAGE, [GoodsStatus]),
            ColorAwardList = update_12_equip_award(?WHOLE_AWARD_COLOR, [GoodsStatus]),
            RedEquipAwardList = update_12_equip_award(?WHOLE_AWARD_RED_EQUIP, [GoodsStatus]);
        false ->
            StarAwardList = GoodsStatus#goods_status.star_award_list,
            StrenAwardList = GoodsStatus#goods_status.stren_award_list,
            RefineAwardList = GoodsStatus#goods_status.refine_award_list,
            StoneAwardList = GoodsStatus#goods_status.stone_award_list,
            StageAwardList = GoodsStatus#goods_status.stage_award_list,
            ColorAwardList = GoodsStatus#goods_status.color_award_list,
            RedEquipAwardList = GoodsStatus#goods_status.red_equip_award_list
    end,
    LastStatus = GoodsStatus#goods_status{
        star_award_list = StarAwardList,
        stren_award_list = StrenAwardList,
        refine_award_list = RefineAwardList,
        stone_award_list = StoneAwardList,
        stage_award_list = StageAwardList,
        color_award_list = ColorAwardList,
        red_equip_award_list = RedEquipAwardList
    },
    LastStatus.

%% 更新全身装备奖励
update_12_equip_award(Type, UpdateData) ->
    case Type of
        %% 强化
        ?WHOLE_AWARD_STREN ->
            [GoodsStatus] = UpdateData,
            statistics_stren_lv_num(GoodsStatus);
        %% 精炼
        ?WHOLE_AWARD_REFINE ->
            [GoodsStatus] = UpdateData,
            statistics_refine_lv_num(GoodsStatus);
        %% 星级
        ?WHOLE_AWARD_STAR ->
            [GoodsStatus, OldGoodsInfo, NewGoodsInfo] = UpdateData,
            Args = [],
            NewArgs = case get_equip_star(OldGoodsInfo) of
                          PreEquipStar when PreEquipStar > 0 ->
                              [{PreEquipStar, -1} | Args];
                          _ ->
                              Args
                      end,
            LastArgs = case get_equip_star(NewGoodsInfo) of
                           CurEquipStar when CurEquipStar > 0 ->
                               [{CurEquipStar, 1} | NewArgs];
                           _ ->
                               NewArgs
                       end,
            List = lists:foldl(fun({K, V}, AccList) ->
                case lists:keyfind(K, 1, AccList) of
                    {K, PreVal} ->
                        skip;
                    _ ->
                        PreVal = 0
                end,
                lists:keystore(K, 1, AccList, {K, PreVal + V})
                               end, GoodsStatus#goods_status.star_award_list, LastArgs),
            [{K, V} || {K, V} <- List, V > 0];
        %% 镶嵌
        ?WHOLE_AWARD_STONE ->
            [GoodsStatus] = UpdateData,
            statistics_stone_lv_num(GoodsStatus#goods_status.equip_stone_list);
        ?WHOLE_AWARD_STAGE ->
            [GoodsStatus] = UpdateData,
            statistics_stage_list(GoodsStatus);
        ?WHOLE_AWARD_COLOR ->
            [GoodsStatus] = UpdateData,
            statistics_color_list(GoodsStatus);
        ?WHOLE_AWARD_RED_EQUIP ->
            [GoodsStatus] = UpdateData,
            statistics_red_equip_list(GoodsStatus);
        _ ->
            []
    end.

%% 统计强化等级的数量
%% return [{stren_lv, num}]
statistics_stren_lv_num(GoodsStatus) ->
    #goods_status{equip_location = EquipLocation} = GoodsStatus,
    lists:foldl(
        fun({EquipPos, _GoodsId}, AccList) ->
            EquipInfo = get_equip_by_location(GoodsStatus, EquipPos),
            case is_record(EquipInfo, goods) of
                true ->
                    StrenLv = EquipInfo#goods.other#goods_other.stren,
                    case lists:keyfind(StrenLv, 1, AccList) of
                        {StrenLv, PreNum} ->
                            skip;
                        _ ->
                            PreNum = 0
                    end,
                    lists:keystore(StrenLv, 1, AccList, {StrenLv, PreNum + 1});
                _ ->
                    AccList
            end
        end, [], EquipLocation).

%% 统计精炼等级的数量
statistics_refine_lv_num(GoodsStatus) ->
    #goods_status{equip_location = EquipLocation} = GoodsStatus,
    lists:foldl(
        fun({EquipPos, _GoodsId}, AccList) ->
            EquipInfo = get_equip_by_location(GoodsStatus, EquipPos),
            case is_record(EquipInfo, goods) of
                true ->
                    RefineLv = EquipInfo#goods.other#goods_other.refine,
                    case lists:keyfind(RefineLv, 1, AccList) of
                        {RefineLv, PreNum} ->
                            skip;
                        _ ->
                            PreNum = 0
                    end,
                    lists:keystore(RefineLv, 1, AccList, {RefineLv, PreNum + 1});
                _ ->
                    AccList
            end
        end, [], EquipLocation).


%% 统计镶嵌宝石等级的数量
%% return [{stone_lv, num}]
statistics_stone_lv_num(StoneList) ->
    lists:foldl(fun({_EquipPos, PosStoneInfoR}, AccList) ->
        lists:foldl(fun(#stone_info{gtype_id = GTypeId}, TmpAccList) ->
            case data_equip:get_stone_lv_cfg(GTypeId) of
                #equip_stone_lv_cfg{lv = TmpLv} ->
                    case lists:keyfind(TmpLv, 1, TmpAccList) of
                        {TmpLv, PreNum} ->
                            skip;
                        _ ->
                            PreNum = 0
                    end,
                    lists:keystore(TmpLv, 1, TmpAccList, {TmpLv, PreNum + 1});
                _ ->
                    TmpAccList
            end
                    end, AccList, PosStoneInfoR#equip_stone.stone_list)
                end, [], StoneList).

statistics_stage_list(GoodsStatus) ->
    #goods_status{equip_location = EquipLocation} = GoodsStatus,
    lists:foldl(
        fun({EquipPos, _GoodsId}, AccList) ->
            EquipInfo = get_equip_by_location(GoodsStatus, EquipPos),
            case is_record(EquipInfo, goods) of
                true ->
                    Stage = get_equip_stage(EquipInfo),
                    case lists:keyfind(Stage, 1, AccList) of
                        {Stage, PreNum} ->
                            skip;
                        _ ->
                            PreNum = 0
                    end,
                    lists:keystore(Stage, 1, AccList, {Stage, PreNum + 1});
                _ ->
                    AccList
            end
        end, [], EquipLocation).

statistics_color_list(GoodsStatus) ->
    #goods_status{equip_location = EquipLocation} = GoodsStatus,
    lists:foldl(
        fun({EquipPos, _GoodsId}, AccList) ->
            EquipInfo = get_equip_by_location(GoodsStatus, EquipPos),
            case is_record(EquipInfo, goods) of
                true ->
                    Color = data_goods:get_goods_color(EquipInfo#goods.goods_id),
                    case lists:keyfind(Color, 1, AccList) of
                        {Color, PreNum} ->
                            skip;
                        _ ->
                            PreNum = 0
                    end,
                    lists:keystore(Color, 1, AccList, {Color, PreNum + 1});
                _ ->
                    AccList
            end
        end, [], EquipLocation).

statistics_red_equip_list(GoodsStatus) ->
    #goods_status{equip_location = EquipLocation} = GoodsStatus,
    lists:foldl(
        fun({EquipPos, _GoodsId}, AccList) ->
            EquipInfo = get_equip_by_location(GoodsStatus, EquipPos),
            case is_record(EquipInfo, goods) of
                true ->
                    Stage = get_equip_stage(EquipInfo),
                    Star = get_equip_star(EquipInfo),
                    case satisfied_red_equip(EquipInfo) of
                        true ->
                            {_, PreNum} = ulists:keyfind({Stage, Star}, 1, AccList, {{Stage, Star}, 0}),
                            lists:keystore({Stage, Star}, 1, AccList, {{Stage, Star}, PreNum + 1});
                        false ->
                           AccList
                    end;
                _ ->
                    AccList
            end
        end, [], EquipLocation).

%% 初始化调用
%% Type     :1.强化 2.星级 3.宝石
%% EquipList: list()  [{pos, level}]
get_12_equip_award_from_list(GoodsStatus, EquipList, Type) ->
    List = [Info || Info <- EquipList, Info#goods.location =:= ?GOODS_LOC_EQUIP],
    [_GoodsStatus, AwardList, _Type] = lists:foldl(fun do_add_12_equip_award/2, [GoodsStatus, [], Type], List),
    AwardList.

%% 全身装备奖励
get_12_equip_award(AwardList, Type) ->
    get_12_equip_award_attr(AwardList, Type).

%% 全身装备奖励
get_12_equip_manual_award(SumLv, Type) ->
    Ids = data_equip:get_whole_reward_ids_by_type(Type),
    case get_range(Ids, SumLv) of
        false ->
            [];
        #base_whole_reward{attr_list = AttrList} ->
            AttrList
    end.

%% 获取精炼全身奖励强化加成比率
get_whole_refine_stren_ratio(AwardList, Type) when Type == ?WHOLE_AWARD_REFINE ->
    SumLv = get_12_equip_award_sum_lv(AwardList, Type),
    Ids = data_equip:get_whole_reward_ids_by_type(Type),
    case get_range(Ids, SumLv) of
        false ->
            0;
        #base_whole_reward{stren_ratio = StrenRatio} ->
            StrenRatio
    end;
get_whole_refine_stren_ratio(AwardList, Type) ->
    ?ERR("get_whole_refine_stren_ratio error, AwardList:~p~nType:~p", [AwardList, Type]),
    0.

get_12_equip_award_sum_lv(AwardList, Type) ->
    case Type of
        %% 镶嵌
        ?WHOLE_AWARD_STONE ->
            lists:foldl(fun({StoneLv, StoneNum}, SumTemp) ->
                SumTemp + StoneLv * StoneNum
                        end, 0, AwardList);
        ?WHOLE_AWARD_STREN ->
            lists:foldl(fun({StrenLv, Num}, SumTemp) ->
                SumTemp + StrenLv * Num
                        end, 0, AwardList);
        ?WHOLE_AWARD_STAR ->
            lists:foldl(fun({Star, Num}, SumTemp) ->
                SumTemp + Star * Num
                        end, 0, AwardList);
        ?WHOLE_AWARD_REFINE ->
            lists:foldl(fun({RefineLv, Num}, SumTemp) ->
                SumTemp + RefineLv * Num
                        end, 0, AwardList);
        ?WHOLE_AWARD_HOLY_SEAL_STREN ->
            AwardList;
        ?WHOLE_AWARD_PET_EQUIP_POS_LV ->
            AwardList;
        ?WHOLE_AWARD_PET_EQUIP_STAGE ->
            AwardList;
        ?WHOLE_AWARD_PET_EQUIP_STAR ->
            AwardList;

        ?WHOLE_AWARD_MOUNT_EQUIP_POS_LV ->
            AwardList;
        ?WHOLE_AWARD_MOUNT_EQUIP_STAGE ->
            AwardList;
        ?WHOLE_AWARD_MOUNT_EQUIP_STAR ->
            AwardList;
        ?WHOLE_AWARD_MATE_EQUIP_POS_LV ->
            AwardList;
        ?WHOLE_AWARD_MATE_EQUIP_STAGE ->
            AwardList;
        ?WHOLE_AWARD_MATE_EQUIP_STAR ->
            AwardList;
        _ ->
            0
    end.

%% 根据类型获得全身装备奖励加的属性
get_12_equip_award_attr(AwardList, ?WHOLE_AWARD_RED_EQUIP) ->
    NewAwardList = re_static_red_equip_award(AwardList),
    F = fun({{Stage, Star}, Num}, List) ->
        RedAttr = data_goods:get_red_equip_attr(Stage, Star, Num),
        lib_player_attr:add_attr(list, [List, RedAttr])
    end,
    lists:foldl(F, [], NewAwardList);

get_12_equip_award_attr(AwardList, Type) ->
    SumLv = get_12_equip_award_sum_lv(AwardList, Type),
    Ids = data_equip:get_whole_reward_ids_by_type(Type),
    case get_range(Ids, SumLv) of
        false ->
            [];
        #base_whole_reward{attr_list = AttrList} ->
            AttrList
    end.

get_range([], _SumLv) ->
    false;
get_range([Id | List], SumLv) ->
    case data_equip:get_whole_award_cfg(Id) of
        #base_whole_reward{need_lv = NeedLv, next_nlv = NextNLv} = OneAeward
            when (SumLv >= NeedLv andalso SumLv =< NextNLv) orelse (SumLv >= NeedLv andalso NextNLv == 0) ->
            OneAeward;
        _ ->
            get_range(List, SumLv)
    end.

get_whole_reward_cfg([], _AllLv, _Lv) -> false ;
get_whole_reward_cfg([Id | List], AllLv, Lv) ->
    case data_equip:get_whole_award_cfg(Id) of
        #base_whole_reward{need_lv = NeedLv} = OneAeward
            when AllLv >= NeedLv, Lv < NeedLv->
            OneAeward;
        #base_whole_reward{need_lv = NeedLv}
            when AllLv >= NeedLv, Lv >= NeedLv->
            get_whole_reward_cfg(List, AllLv, Lv);
        _ ->
            false
    end.

%% 获得装备的时候生成其他的附加属性
gen_equip_other_attr(GoodsTypeInfo, GoodsOther) ->
    ExtraAttr = gen_equip_extra_attr(GoodsTypeInfo, []),
%%    ?MYLOG("cym2", "==================== ~p   ~n", [ExtraAttr]),
    BaseRating = cal_equip_rating(GoodsTypeInfo, ExtraAttr),
    GoodsOther#goods_other{rating = BaseRating, extra_attr = ExtraAttr}.

%%--------------------------------------------------
%% 根据已有的属性生成新的装备极品属性
%% @param  GoodsTypeInfo description
%% @param  OldExtraAttr  [{color,id,val}|{color,id,base_val,plus_interval,plus}]
%% @return               description
%%--------------------------------------------------
gen_equip_extra_attr_by_types(GoodsTypeInfo, OldExtraAttr) ->
    gen_equip_extra_attr(GoodsTypeInfo, lists:reverse(OldExtraAttr)).

%% 生成装备的极品属性
gen_equip_extra_attr(GoodsTypeInfo, OldExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    case data_equip:get_equip_attr_cfg(GoodsTypeInfo#ets_goods_type.goods_id) of
        #equip_attr_cfg{
            nattr_1 = AttrNum1, vattr_1 = AttrVal1,
            nattr_2 = AttrNum2, vattr_2 = AttrVal2,
            nattr_3 = AttrNum3, vattr_3 = AttrVal3,
            nattr_4 = AttrNum4, vattr_4 = AttrVal4
        } ->
            AttrArgs = [{AttrNum4, AttrVal4}, {AttrNum3, AttrVal3}, {AttrNum2, AttrVal2}, {AttrNum1, AttrVal1}], %%先生成高品质的
            gen_equip_extra_attr(AttrArgs, OldExtraAttr);
        _ ->
            []
    end;
gen_equip_extra_attr(AttrArgs, OldExtraAttr) ->
    %%继承属性
    {NewExtraAttr,  NewAttrArgs} = inherit_attr(OldExtraAttr, AttrArgs),
    do_gen_equip_extra_attr(NewAttrArgs, [], NewExtraAttr).

do_gen_equip_extra_attr([], _CurExtraAttr, Result) ->
    Result;
do_gen_equip_extra_attr([{Num, RCAttrList} | List], OldExtraAttr, Result) ->
    case Num > 0 andalso RCAttrList =/= [] of
        true ->
            RemainAttrList = [{W, TmpAttr} || {W, TmpAttr} <- RCAttrList, %%去掉重复的属性
                is_include_attr(Result,  TmpAttr) == false],
            NewResult = case OldExtraAttr == [] of
                               true ->
                                   do_gen_equip_extra_attr_helper(0, Num, RemainAttrList, Result);
                               false ->
%%                                   ?PRINT("RCAttrList, OldExtraAttr:~w~n", [[RCAttrList, OldExtraAttr]]),
                                   do_gen_equip_extra_attr_helper1(RemainAttrList, OldExtraAttr,  Result)
                           end,
            do_gen_equip_extra_attr(List, OldExtraAttr,  NewResult);  %%装备升阶，极品属性不变
        false ->
            do_gen_equip_extra_attr(List, OldExtraAttr, Result)
    end.

do_gen_equip_extra_attr_helper(_, _, [], Result) ->
    Result;
do_gen_equip_extra_attr_helper(Num, Num, _, Result) ->
    Result;
do_gen_equip_extra_attr_helper(CurNum, Num, LastAttrList, Result) ->  %%LastAttrList   留下来的属性列表
    case urand:rand_with_weight(LastAttrList) of
        {_Color, _AttrId, _AttrVal} = GainAttr ->
            RemainAttrList = [{W, TmpAttr} || {W, TmpAttr} <- LastAttrList,
                TmpAttr =/= GainAttr, is_include_attr(Result ++ [GainAttr], TmpAttr) == false],  %%新的留下来的属性 ，去掉和结果列表相同属性id的部分，
            do_gen_equip_extra_attr_helper(CurNum + 1, Num, RemainAttrList, Result ++ [GainAttr]);
        {_Color, _AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus} = GainAttr ->
            RemainAttrList = [{W, TmpAttr} || {W, TmpAttr} <- LastAttrList,
                TmpAttr =/= GainAttr, is_include_attr(Result ++ [GainAttr], TmpAttr) == false],  %%新的留下来的属性 ，去掉和结果列表相同属性id的部分，
            do_gen_equip_extra_attr_helper(CurNum + 1, Num, RemainAttrList, Result ++ [GainAttr]);
        _ ->
            ?ERR("equip extra attr config error:~p", [LastAttrList]),
            do_gen_equip_extra_attr_helper(CurNum, Num, [], Result)
    end.
do_gen_equip_extra_attr_helper1([], _, Result) ->
    Result;
do_gen_equip_extra_attr_helper1([{_W, {Color, AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus}} | AttrList], OldExtraAttr, Result) ->  %%只要是旧属性就放到结果列表中
    IsOldAttrType = lists:any(fun(Tmp) ->
        case Tmp of
            {Color, AttrId, AttrBaseVal, AttrPlusInterval, _} ->
                true;
            _ ->
                false
        end
                              end, OldExtraAttr),
    case IsOldAttrType of
        true ->
            AttrAdd = {Color, AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus},
            do_gen_equip_extra_attr_helper1(AttrList, OldExtraAttr, [AttrAdd | Result]);
        false ->
            do_gen_equip_extra_attr_helper1(AttrList, OldExtraAttr, Result)
    end;
do_gen_equip_extra_attr_helper1([{_W, {Color, AttrId, AttrVal}} | AttrList], OldExtraAttr, Result) ->
    IsOldAttrType = lists:any(fun(Tmp) ->
        case Tmp of
            {Color, AttrId, _} ->
                true;
            _ ->
                false
        end
                              end, OldExtraAttr),
    case IsOldAttrType of
        true ->
            do_gen_equip_extra_attr_helper1(AttrList, OldExtraAttr, Result ++ [{Color, AttrId, AttrVal}]);
        false ->
            do_gen_equip_extra_attr_helper1(AttrList, OldExtraAttr, Result)
    end.

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when GoodsTypeInfo#ets_goods_type.type == ?GOODS_TYPE_BABY_EQUIP ->
    #ets_goods_type{goods_id = _GTypeId, base_attrlist = BaseAttr} = GoodsTypeInfo,
    Stage = 5, %% 宝宝装备默认用5阶
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力 改为 阶数 * 200
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, BaseAttr ++ EquipExtraAttr),
    round(Rating);

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when GoodsTypeInfo#ets_goods_type.type == ?GOODS_TYPE_DECORATION ->
    %%    ?MYLOG("cym2", "EquipExtraAttr ~p~n", [EquipExtraAttr]),
    #ets_goods_type{goods_id = GTypeId, level = _Level, base_attrlist = BaseAttr} = GoodsTypeInfo,
    Stage = 10,
%%    Stage = case data_decoration:get_dec_attr(GTypeId) of
%%                #dec_attr_cfg{stage = Stg} -> Stg;
%%                _ -> 1
%%            end,
    F = fun(OneExtraAttr, RatingTmp) ->
        %%                ?PRINT("cal_equip_rating OneExtraAttr, RatingTmp;~w~n",[[OneExtraAttr, RatingTmp]]),
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力 改为 阶数 * 200
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                %%                        GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, BaseAttr ++ EquipExtraAttr ++ get_equip_other_attr(GTypeId)),
    %%    ?MYLOG("cym2", "Rating ~p~n", [Rating]),
    round(Rating);

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when GoodsTypeInfo#ets_goods_type.type == ?GOODS_TYPE_REVELATION ->
    #ets_goods_type{goods_id = GTypeId, level = _Level, base_attrlist = BaseAttr} = GoodsTypeInfo,
    Stage = 12,
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating;
            _ ->
                RatingTmp
        end
        end,
    AllAttr =  BaseAttr ++ EquipExtraAttr ++ lib_revelation_equip:get_other_attr(GTypeId),
%%    ?MYLOG("cym2", "AllAttr ~p~n", [AllAttr]),
    Rating = lists:foldl(F, 0, AllAttr),
%%    ?MYLOG("cym2", "Rating ~p~n", [Rating]),
    round(Rating);

cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    case is_equip(GoodsTypeInfo) of
        true ->
            #ets_goods_type{goods_id = GTypeId, level = _Level, base_attrlist = BaseAttr} = GoodsTypeInfo,
            Stage = get_equip_stage(GTypeId),
%%            ?MYLOG("cym2", "EquipExtraAttr ~p  Stage ~p~n", [BaseAttr ++ EquipExtraAttr, Stage]),
            F = fun(OneExtraAttr, RatingTmp) ->
                case OneExtraAttr of
                    {OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
%%                        %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力 改为 阶数 * 200
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
%%                        GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                        RatingTmp + OneAttrRating;
                    %RatingTmp + Stage * 160;
                    _ ->
                        RatingTmp
                end
                end,
            Rating = lists:foldl(F, 0, BaseAttr ++ EquipExtraAttr ++ get_equip_other_attr(GTypeId)),
%%            ?MYLOG("cym2", "Rating ~p~n", [Rating]),
            round(Rating);
        false ->
            0
    end;
cal_equip_rating(_, _) ->
    0.

%% 计算装备的综合评分
cal_equip_overall_rating(?GOODS_LOC_EQUIP, GoodsStatus, GoodsInfo) ->
    #equip_stren{
        stren = Stren
    } = get_stren(GoodsStatus, GoodsInfo#goods.equip_type),
    StrenPower = case data_equip:stren_lv_cfg(GoodsInfo#goods.equip_type, Stren) of
                     #base_equip_stren{attr_list = StrenAttr} ->
                         TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                         cal_attr_rating(StrenAttr, TempInfo);
                     _ ->
                         0
                 end,
    GoodsOther = GoodsInfo#goods.other,
    #goods_other{rating = Rating} = GoodsOther,
    Rating + StrenPower;

cal_equip_overall_rating(?GOODS_LOC_DECORATION, GoodsStatus, GoodsInfo) ->
    DecGoods = GoodsStatus#goods_status.dec_level_list,
    StrenPower =
        case lists:keyfind(GoodsInfo#goods.cell, 1, DecGoods) of
            false -> 0;
            {Cell, Level} ->
                case data_decoration:get_dec_level(Cell, Level) of
                    #dec_level_cfg{attr = Attr} ->
                        cal_equip_rating(GoodsInfo, Attr);
                    _ -> 0
                end
        end,
    GoodsOther = GoodsInfo#goods.other,
    #goods_other{rating = Rating} = GoodsOther,
    Rating + StrenPower;

cal_equip_overall_rating(?GOODS_LOC_PET_EQUIP, GoodsStatus, GoodsInfo) ->
    lib_pet:calc_over_all_rating(GoodsStatus, GoodsInfo);

cal_equip_overall_rating(?GOODS_LOC_MOUNT_EQUIP, GoodsStatus, GoodsInfo) ->
    lib_mount_equip:calc_over_all_rating(GoodsStatus, GoodsInfo, 1);

cal_equip_overall_rating(?GOODS_LOC_MATE_EQUIP, GoodsStatus, GoodsInfo) ->
    lib_mount_equip:calc_over_all_rating(GoodsStatus, GoodsInfo, 2);


cal_equip_overall_rating(?GOODS_LOC_EUDEMONS, _GoodsStatus, GoodsInfo) ->
    lib_eudemons:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(?GOODS_LOC_SEAL_EQUIP, _GoodsStatus, GoodsInfo) ->
    lib_seal:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(?GOODS_LOC_DRACONIC_EQUIP, _GoodsStatus, GoodsInfo) ->
    lib_draconic:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(?GOODS_LOC_REVELATION, _GoodsStatus, GoodsInfo) ->
    lib_revelation_equip:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(?GOODS_LOC_REVELATION_BAG, _GoodsStatus, GoodsInfo) ->
    lib_revelation_equip:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(_, _, GoodsInfo) ->
    GoodsInfo#goods.other#goods_other.rating.

%% 计算装备的综合评分
cal_equip_overall_rating(?GOODS_LOC_EQUIP, GoodsInfo) ->
    #goods_other{
        stren = Stren, rating = Rating
    } = GoodsInfo#goods.other,
    StrenPower = case data_equip:stren_lv_cfg(GoodsInfo#goods.equip_type, Stren) of
                     #base_equip_stren{attr_list = StrenAttr} ->
                         TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                         cal_attr_rating(StrenAttr, TempInfo);
                     _ ->
                         0
                 end,
    Rating + StrenPower;

cal_equip_overall_rating(?GOODS_LOC_MOUNT_EQUIP, GoodsInfo) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    Rating = lib_mount_equip:calc_over_all_rating(GoodsStatus, GoodsInfo, 1),
    %%    ?PRINT("mount  all Rating:~p~n",[Rating]),
    Rating;

cal_equip_overall_rating(?GOODS_LOC_MATE_EQUIP, GoodsInfo) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    lib_mount_equip:calc_over_all_rating(GoodsStatus, GoodsInfo, 2);

%% 计算幻饰的综合评分
cal_equip_overall_rating(?GOODS_LOC_DECORATION, GoodsInfo) ->
    #goods_other{
        stren = Stren, rating = Rating
    } = GoodsInfo#goods.other,
    StrenPower = case data_decoration:get_dec_level(GoodsInfo#goods.cell, Stren) of
                     #dec_level_cfg{attr = StrenAttr} ->
                         TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                         % cal_attr_rating(StrenAttr, TempInfo);
                         % ?PRINT("=======StrenAttr :~p~n",[[StrenAttr]]),
                         lib_decoration:only_cal_level_rating(TempInfo, StrenAttr);
                     _ ->
                         0
                 end,
    % ?PRINT("=======equip_type, Stren, Rating, StrenPower :~p~n",[[GoodsInfo#goods.cell, Stren, Rating, StrenPower]]),
    Rating + StrenPower;

cal_equip_overall_rating(?GOODS_LOC_EUDEMONS, GoodsInfo) ->
    lib_eudemons:calc_over_all_rating(GoodsInfo);

cal_equip_overall_rating(_, GoodsInfo) ->
    GoodsInfo#goods.other#goods_other.rating.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取全身装备的综合评分 玩家进程中调用
%% @param    参数      PS::#player_status{}
%% @return   返回值    LastRating::integer  全身装备的综合评分
%% @history  修改历史
%% -----------------------------------------------------------------
get_all_equip_rating(#player_status{id = RoleId} = _PS) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GS,
    EquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_EQUIP, GoodsDict),  %%获得镶嵌中的符文列表
    F = fun(GoodInfo, Rating) ->
        TempRating = cal_equip_overall_rating(?GOODS_LOC_EQUIP, GoodInfo),
        Rating + TempRating
        end,
    LastRating = lists:foldl(F, 0, EquipWearList),
    LastRating.


%% -----------------------------------------------------------------
%% @desc     功能描述     计算属性评分
%% @param    参数         AttrList::lists    eg.[{3,50}]
%%                        GoodsTypeInfo::#ets_goods_type{}
%% @return   返回值       Rating::integer
%% @history  修改历史
%% -----------------------------------------------------------------
cal_attr_rating(AttrList, GoodsTypeInfo) ->
    case is_equip(GoodsTypeInfo) of
        true ->
            #ets_goods_type{goods_id = GTypeId, level = Level} = GoodsTypeInfo,
            Stage = get_equip_stage(GTypeId),
            F = fun(OneExtraAttr, RatingTmp) ->
                case OneExtraAttr of
                    {OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                        %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                        RatingTmp + OneAttrRating * GrowthAttrRealVal;
                    %RatingTmp + Stage * 160;
                    _ ->
                        RatingTmp
                end
                end,
            Rating = lists:foldl(F, 0, AttrList),
            round(Rating);
        false ->
            0
    end.


%%--------------------------------------------------
%% 计算装备洗炼评分
%% @param  WashAttrList 洗炼属性列表 [{pos, attr_id, attr_val}]
%% @return              description
%%--------------------------------------------------
count_equip_wash_rating(WashAttrList) ->
    F = fun(OneAttr, TmpRating) ->
        case OneAttr of
            {_Pos, _Color, OneAttrId, OneAttrValTmp} ->
                OneAttrRating = get_wash_attr_base_rating(OneAttrId),
                % OneAttrVal = case lists:member(OneAttrId, ?GLOBAL_ADD_RATIO_TYPE) of
                %     true -> OneAttrValTmp / ?RATIO_COEFFICIENT; %% 百分比的属性要除以10000
                %     _ -> OneAttrValTmp
                % end,
                TmpRating + OneAttrRating * OneAttrValTmp;
            _ ->
                TmpRating
        end
        end,
    Rating = lists:foldl(F, 0, WashAttrList),
    round(Rating).

get_wash_attr_base_rating(AttrId) ->
    case AttrId of
        ?ATT -> 10;
        ?HP -> 0.5;
        ?WRECK -> 10;
        ?DEF -> 10;
        ?HIT -> 10;
        ?DODGE -> 10;
        ?CRIT -> 10;
        ?TEN -> 10;
%%        ?ATT_ADD_RATIO -> 80;
%%        ?HP_ADD_RATIO -> 80;
%%        ?WRECK_ADD_RATIO -> 30;
%%        ?DEF_ADD_RATIO -> 10;
%%        ?HIT_ADD_RATIO -> 10;
%%        ?DODGE_ADD_RATIO -> 30;
%%        ?ELEM_ATT -> 10;
%%        ?ELEM_DEF -> 10;
        ?ABS_ATT -> 20;
        ?ABS_DEF -> 20;
        ?PVP_HURT_ADD -> 20;
        ?PVP_HURT_DEL ->20;
        _ -> 0
    end.



%% 计算宝石的评分
cal_stone_rating(EquipPos, PosStoneInfoR) ->
    #equip_stone{refine_lv = RefineLv, stone_list = PosStoneList} = PosStoneInfoR,
    F = fun(#stone_info{gtype_id = GTypeId}, TmpRating) ->
        case data_equip:get_stone_lv_cfg(GTypeId) of
            #equip_stone_lv_cfg{rating = StoneRating} ->
                TmpRating + StoneRating;
            _ ->
                TmpRating
        end
        end,
    SumRating = lists:foldl(F, 0, PosStoneList),
    case data_equip:get_refine_cfg(EquipPos, RefineLv) of
        #equip_stone_refine_cfg{rating = RefineRating} ->
            round(SumRating + RefineRating);
        _ ->
            round(SumRating)
    end.

%% 计算铸灵属性的评分
count_casting_spirit_rating(EquipInfo, CastingSpiritInfoR) ->
    AttrList = count_casting_spirit_attr([CastingSpiritInfoR], [EquipInfo]),
    F = fun(OneAttr, TmpRating) ->
        case OneAttr of
            {OneAttrId, OneAttrValTmp} ->
                OneAttrRating = data_attr:get_attr_base_rating_ex(OneAttrId),
                TmpRating + OneAttrRating * OneAttrValTmp;
            _ ->
                TmpRating
        end
        end,
    Rating = lists:foldl(F, 0, AttrList),
    round(Rating).

%%--------------------------------------------------
%% 返还物品给玩家
%% @param  RoleId         玩家id
%% @param  ReturnGoodsL   [{key, val}]
%% @return                description
%%--------------------------------------------------
return_goods_to_player(RoleId, ReturnGoodsL) ->
    F = fun({Key, Val}) ->
        case Key of
            stone_list ->
                return_stone_to_player(RoleId, Val);
            suit_return ->
                return_suit_cost(RoleId, Val);
            _ ->
                skip
        end
        end,
    lists:foreach(F, ReturnGoodsL).

%% 15220
%% 装备套装信息
suit_info() ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{equip_suit_list = SuitList, equip_suit_state = _SuitState} = GS,
    SuitListInfo = [{EquipPos, Lv, SLv} || #suit_item{pos = EquipPos, lv = Lv, slv = SLv} <- SuitList, SLv =/= 0 ],
%%    F = fun(InfoItem, SuitInfoSend) ->
%%            {EquipPos, Lv, _SLv} = InfoItem,
%%            case lib_equip:get_suit_type(EquipPos) of
%%                % 武防套装的信息各部位优先发更高级的套装
%%                %% ?EQUIPMENT ->
%%                %%     case lists:keyfind(EquipPos, 1, SuitInfoSend) of
%%                %%         false ->
%%                %%             [InfoItem|SuitInfoSend];
%%                %%         {EquipPos, CurLv, _CurSLv} ->
%%                %%             case Lv > CurLv of
%%                %%                 true -> lists:keyreplace(EquipPos, 1, SuitInfoSend, InfoItem);
%%                %%                 false -> SuitInfoSend
%%                %%             end
%%                %%     end;
%%                %% 共鸣三套互不影响
%%                ?EQUIPMENT ->
%%                    [InfoItem|SuitInfoSend];
%%                % 饰品套装信息则应该全部发
%%                ?ACCESSORY ->
%%                    [InfoItem|SuitInfoSend]
%%            end
%%        end,
%%    % SuitStateList = [{Type, Lv, Slv, Count} || #suit_state{key = {Type, Lv, Slv}, count = Count} <- SuitState],
%%    lists:foldl(F, [], SuitListInfo).
    SuitListInfo.

%% 15221
%% 打造套装
make_suit(PS, Lv, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    OldSuitState = GoodsStatus#goods_status.equip_suit_state,           % 原套装状态（传闻用）
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos), % 当前的槽位装备信息
    case lib_equip:get_suit_type(EquipPos) of
        ?EQUIPMENT -> SLv = lib_equip:get_equip_stage(EquipInfo);                       % 武防（套装阶数绑定装备阶数）
        ?ACCESSORY -> #suit_item{slv = SLv} = get_suit_item(EquipPos, Lv, GoodsStatus)  % 饰品（独立的套装阶数）
    end,
    case lib_equip_check:make_suit_check(PS, EquipInfo, EquipPos, Lv, SLv) of
        {true, EquipPos, NewSLv, Cost, MoneyList, DelGoodsList} ->
            ConsumeRecordMap = lib_goods_consume_record:get_consume_record_map(PS#player_status.id),    % 物品消耗记录表
            PsMoney = lib_player_record:trans_to_ps_money(PS, make_equip_suit),                         % 玩家金钱数据
            FilterConditions = [{id_in, [Id||{#goods{id=Id}, _} <- DelGoodsList]}],
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                case lib_goods_util:lightly_cost_object_list(PsMoney, MoneyList, make_equip_suit, integer_to_list(EquipPos), GoodsStatusBfTrans) of
                    {true, CostGoodsStatus, NewPsMoney} ->
                        {ok, NewGoodsStatus} = lib_goods:delete_goods_list(CostGoodsStatus, DelGoodsList),
                        db_update_suit_info(PS#player_status.id, EquipPos, Lv, NewSLv),
                        #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
                        {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                        NewGoodsStatus1 = NewGoodsStatus#goods_status{dict = GoodsDict},
                        [
                            lib_log_api:log_throw(make_equip_suit, PS#player_status.id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, TmpNum, 0, 0)
                            || {GoodsInfo, TmpNum} <- DelGoodsList
                        ],
                        {true, NewGoodsStatus1, GoodsL, NewPsMoney};
                    {false, Res, _, _} ->
                        throw({error, {not_enough, Res}})
                end
            end,
            case lib_goods_util:check_object_list(PS, Cost) of
                true ->
                    case lib_goods_util:transaction(F) of
                        {true, NewStatus, GoodsL, NewPsMoney} ->
                            CostGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                            CostPS = lib_player_record:update_ps_money_op(PS, PsMoney, NewPsMoney),
                            {_NewConsumeRecord, NewConsumeRecordMap} =
                                lib_goods_consume_record:add_goods_comsume_record(CostPS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, Lv, NewSLv}, MoneyList++DelGoodsList, [bind], ConsumeRecordMap),
                            lib_goods_consume_record:set_consume_record_map(NewConsumeRecordMap),
                            GoodsStatus1 = setup_equip_suit(CostGoodsStatus, EquipPos, Lv, NewSLv),         % 更新套装列表和状态
                            NewSuitState = GoodsStatus1#goods_status.equip_suit_state,
                            TotalSuitAttr = calc_suit_attr(NewSuitState),     % 更新套装属性
                            #player_status{goods = SG} = CostPS,
                            NewSG = SG#status_goods{equip_suit_attr = TotalSuitAttr},
                            NewPS0 = CostPS#player_status{goods = NewSG},
                            NewGoodsStatus = GoodsStatus1#goods_status{is_dirty_suit = false},
                            {ok, NewPS} = lib_goods_util:count_role_equip_attribute(NewPS0, NewGoodsStatus),
                            lib_goods_api:notify_client(PS, GoodsL),
                            lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
                            Type = data_equip_suit:pos2type(EquipPos),
                            NewSuitInfo = ?IF(Type =:= ?EQUIPMENT, get_equipment_suit_info(NewSuitState), get_accessory_suit_info(NewSuitState)),
                            % 传闻，日志
                            OldSuitInfo = ?IF(Type =:= ?EQUIPMENT, get_equipment_suit_info(OldSuitState), get_accessory_suit_info(OldSuitState)),
                            NewSortInfo = lists:keysort(3, NewSuitInfo),    % 按激活N件套排序
                            RumorF = fun({CurLv, CurSLv, Count}) ->
                                    case lists:keyfind(Count, 3, OldSuitInfo) of
                                        % 当前的N件套与原状态一致
                                        {CurLv, CurSLv, Count} -> skip;
                                        % 当前的N件套为新的更新状态
                                        _ ->
                                            RoleName = PS#player_status.figure#figure.name,
                                            SuitName = data_equip_suit:get_suit_name(Type, CurLv, CurSLv),
                                            lib_chat:send_TV({all}, ?MOD_EQUIP, 4, [RoleName, PS#player_status.id, EquipInfo#goods.goods_id, EquipInfo#goods.id, PS#player_status.id, SuitName, Count]),
                                            lib_log_api:log_equip_suit_operation(PS#player_status.id, EquipInfo#goods.id, EquipInfo#goods.goods_id, Type, CurLv, CurSLv, Count, 1)
                                    end
                                end,
                            lists:foreach(RumorF, NewSortInfo),
                            EventPS = lib_equip_event:make_suit_event(NewPS, NewGoodsStatus, EquipPos, Lv, NewSLv),
                            {true, EventPS, NewGoodsStatus, Lv, NewSLv, NewSuitInfo};
                        {db_error, {error, {not_enough, Res}}} ->
                            {false, Res};
                        _A ->
                            ?ERR("make_suit err ~p~n", [_A]),
                            {false, ?FAIL}
                    end;
                {false, ErrorCode} ->
                    {false, ErrorCode};
                _ ->
                    {false, ?FAIL}
            end;
        Error ->
            Error
    end.

%% 15222
%% 还原套装（由于主动还原以及穿戴装备被动还原都走这里，需要多留意这两方面）
restore_suit(PS, Lv, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    SuitList = GoodsStatus#goods_status.equip_suit_list,
    Type = lib_equip:get_suit_type(EquipPos),           % 套装类型
    BackLvs = [RestoreLv || #suit_item{key = {PosId, RestoreLv}} <- SuitList, PosId =:= EquipPos, RestoreLv >= Lv],  % 获取同级和更高级的套装id（针对武防）
    RestoreLvs = lists:reverse(lists:sort(BackLvs)),    % 当武防退回时，应先退回高级的套装
    #suit_item{slv = SLv} = get_suit_item(EquipPos, Lv, GoodsStatus),
    case SLv >= 1 of
        true ->
            NewSLv = ?IF(Type =:= ?EQUIPMENT, 0, get_cur_min_suit_stage(Type, Lv, EquipPos)-1),
            F = fun(CurLv, {LvRewardList, CurGS}) ->
                    RestoreStage = get_cur_min_suit_stage(Type, CurLv, EquipPos),
                    % 获取在该套装等级上各阶级总共需要退回的物品
                    NewRewardList = get_lv_restore_rewards(PS, RestoreStage, SLv, EquipPos, CurLv, LvRewardList),
                    % 如套装类型是武防，则更新阶数为0
                    % 如套装类型是饰品，则更新阶数为不能兼容的阶数-1
                    LastSLv = ?IF(Type =:= ?EQUIPMENT, 0, ?IF(RestoreStage =:= 0, SLv, RestoreStage-1)),
                    % 更新套装信息状态和信息并同步到数据库
                    db_update_suit_info(PS#player_status.id, EquipPos, CurLv, LastSLv),
                    LastGS = setup_equip_suit(CurGS, EquipPos, CurLv, LastSLv),
                    % 日志记录
                    case lists:keyfind({Type, CurLv, RestoreStage}, #suit_state.key, CurGS#goods_status.equip_suit_state) of
                        #suit_state{count = Count} ->
                            lib_log_api:log_equip_suit_operation(PS#player_status.id, 0, 0, Type, Lv, RestoreStage, Count, 0);
                        _ ->
                            skip
                    end,
                    {NewRewardList, LastGS}
                end,
            {TotalRewardList, NewGS} = lists:foldl(F, {[], GoodsStatus}, RestoreLvs),
            % 整理退回的物品列表发送格式
            RewardListSend = lib_goods_api:trans_to_attr_goods(TotalRewardList),
            RewardListSendNew = [{GoodsType, Id, Num, util:term_to_string(AttrList)} ||{GoodsType, Id, Num, AttrList} <- RewardListSend],
            % 更新套装属性和玩家信息
            NewSuitState = NewGS#goods_status.equip_suit_state,
            TotalSuitAttr = calc_suit_attr(NewSuitState),
            #player_status{goods = SG} = PS,
            NewSG = SG#status_goods{equip_suit_attr = TotalSuitAttr},
            NewPS0 = PS#player_status{goods = NewSG},
            NewGoodsStatus = NewGS#goods_status{is_dirty_suit = false},
            % 计算装备属性，通知客户端更新物品和战力信息
            {ok, NewPS} = lib_goods_util:count_role_equip_attribute(NewPS0, NewGoodsStatus),
            lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
            EventPS = lib_equip_event:make_suit_event(NewPS, NewGoodsStatus, EquipPos, Lv, NewSLv),
            {_, LastPS} = lib_goods_api:send_reward_with_mail(EventPS, #produce{type = make_equip_suit, reward = TotalRewardList, remark = lists:concat(["restore_suit_", Lv, "_", EquipPos])}),
            NewLv = ?IF(Type =:= ?EQUIPMENT, Lv-1, Lv), % 如果是武防，应该返回最高级的套装等级
            NewSuitInfo = ?IF(Type =:= ?EQUIPMENT, get_equipment_suit_info(NewSuitState), get_accessory_suit_info(NewSuitState)),
            {true, LastPS, NewLv, NewSLv, RewardListSendNew, NewSuitInfo};
        _ ->
            {false, ?ERRCODE(err152_not_make_suit)}
    end.

% 获取在该套装等级上各阶级总共需要退回的物品
get_lv_restore_rewards(_PS, RestoreStage, SLv, _EquipPos, _CurLv, StageRewardList) when RestoreStage > SLv -> StageRewardList;
get_lv_restore_rewards(PS, RestoreStage, SLv, EquipPos, CurLv, StageRewardList) ->
    Sex = PS#player_status.figure#figure.sex,
    case data_equip_suit:get_make_cfg(EquipPos, CurLv, RestoreStage) of
        #suit_make_cfg{cost = CostList} -> ok;
        _ -> CostList = []
    end,
    case lists:keyfind(Sex, 1, CostList) of
        {_, RestoreRewardCon} ->
            % 计算退回的物品内容
            case lib_goods_consume_record:get_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}) of
                % 防止配置修改而多发还原奖励
                [#consume_record{consume_list = ConsumeList}|_] ->
                    lib_goods_consume_record:del_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, RestoreStage}),
                    RestoreReward = ConsumeList;
                fail ->
                    RestoreReward = RestoreRewardCon
            end,
            NewRewardList = lists:append(StageRewardList, RestoreReward);
        _ ->
            NewRewardList = StageRewardList
    end,
    get_lv_restore_rewards(PS, RestoreStage+1, SLv, EquipPos, CurLv, NewRewardList).

%% 15223
%% 套装还原奖励预览
restore_suit_preview(PS, Lv, EquipPos) ->
    _Sex = PS#player_status.figure#figure.sex,
    Sex = ?IF(_Sex =:= 0, ?MALE, _Sex),
    GoodsStatus = lib_goods_do:get_goods_status(),
    SuitList = GoodsStatus#goods_status.equip_suit_list,
    Type = lib_equip:get_suit_type(EquipPos),   % 套装类型
    RestoreLvs = [RestoreLv || #suit_item{key = {PosId, RestoreLv}} <- SuitList, PosId =:= EquipPos, RestoreLv >= Lv],  % 获取同级和更高级的套装id（针对武防）
    #suit_item{slv = SLv} = get_suit_item(EquipPos, Lv, GoodsStatus),
    case SLv >= 1 of
        true ->
            F = fun(CurLv, CurRewardList) ->
                    case data_equip_suit:get_make_cfg(EquipPos, CurLv, SLv) of
                        #suit_make_cfg{cost = CostList} -> ok;
                        _ -> CostList = []
                    end,
                    case lists:keyfind(Sex, 1, CostList) of
                        {_, RestoreRewardCon} ->
                            case lib_goods_consume_record:get_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, CurLv, SLv}) of
                                % 防止配置修改而多发还原奖励
                                [#consume_record{consume_list = ConsumeList}|_] ->
                                    RestoreReward = ConsumeList;
                                fail -> RestoreReward = RestoreRewardCon
                            end,
                            lists:append(CurRewardList, RestoreReward);
                        _ ->
                            CurRewardList
                    end
                end,
            TotalRewardList =
                case Type of
                    ?EQUIPMENT -> lists:foldl(F, [], RestoreLvs);
                    ?ACCESSORY -> lists:foldl(F, [], [Lv])
                end,
            RewardListSend = lib_goods_api:trans_to_attr_goods(TotalRewardList),
            RewardListSendNew = [{GoodsType, Id, Num, util:term_to_string(AttrList)} || {GoodsType, Id, Num, AttrList} <- RewardListSend],
            {true, RewardListSendNew};
        _ ->
            {true, []}
    end.

%% NewSuitState: [{Type,Lv,Slv,Count}]
% suit_red_point(PS, NewSuitState) ->
%     #player_status{goods = SG, original_attr = OriginalAttr} = PS,
%     OldSuitAttr = SG#status_goods.equip_suit_attr,
%     OldOriginalAttr = lib_player_attr:minus_attr(record, [OriginalAttr, OldSuitAttr]),
%     List = [AttrList || {Type, Lv, SLv, Count} <- NewSuitState, {C, AttrList} <- data_equip_suit:get_attr_list(Type, Lv, SLv), C =< Count],
%     NewSuitAttr = ulists:kv_list_plus_extra(List),
%     _PowerAdd1 = lib_player:calc_expact_power(OldOriginalAttr, 0, OldSuitAttr),
%     _PowerAdd2 = lib_player:calc_expact_power(OldOriginalAttr, 0, NewSuitAttr),
%     ok.

get_suit_item(EquipPos, Lv, GoodsStatus) ->
    #goods_status{equip_suit_list = SuitList} = GoodsStatus,
    DefaultItem = #suit_item{key = {EquipPos, Lv}, pos = EquipPos, lv = Lv},
    ulists:keyfind({EquipPos, Lv}, #suit_item.key, SuitList, DefaultItem).

db_update_suit_info(RoleId, Pos, Lv, NSLv) ->
    SQL = usql:replace(equip_suit, [role_id, pos, suit_lv, suit_slv], [[RoleId, Pos, Lv, NSLv]]),
    db:execute(SQL).

setup_equip_suit(GoodsStatus, EquipPos, MakeType, NewSLv) ->
    #goods_status{equip_suit_list = SuitList} = GoodsStatus,
    case NewSLv =:= 0 of
        false ->
            NewSuitList = lists:keystore({EquipPos, MakeType}, #suit_item.key, SuitList, #suit_item{key = {EquipPos, MakeType}, pos = EquipPos, lv = MakeType, slv = NewSLv});
        true ->
            NewSuitList = lists:keydelete({EquipPos, MakeType}, #suit_item.key, SuitList)
    end,
    SuitState = calc_suit_state(NewSuitList),
    NewGoodsStatus = GoodsStatus#goods_status{equip_suit_list = NewSuitList, equip_suit_state = SuitState, is_dirty_suit = true},
    NewGoodsStatus.

statistics_suit_num(SuitList) ->
    F = fun(#suit_item{lv = Lv}, Map) ->
        ONum = maps:get(Lv, Map, 0),
        maps:put(Lv, ONum + 1, Map)
        end,
    SuitNumMap = lists:foldl(F, #{}, SuitList),
    maps:to_list(SuitNumMap).

get_suit_info(GoodsStatus, GoodsInfo) ->
    case GoodsInfo of
        #goods{type = ?GOODS_TYPE_EQUIP, subtype = EquipPos, location = ?GOODS_LOC_EQUIP} ->
            #goods_status{equip_suit_list = _SuitList, equip_suit_state = SuitState} = GoodsStatus,
            case lib_equip:get_suit_type(EquipPos) of
                ?EQUIPMENT ->
                    get_equipment_suit_info(SuitState);
                ?ACCESSORY ->
                    get_accessory_suit_info(SuitState);
                _ -> []
            end;
        _ ->
            []
    end.

%% 获取武防装备的套装信息
get_equipment_suit_info(SuitState) ->
    get_specific_suit_info(?EQUIPMENT, ?EQUIPMENT_ATTR_LIST, SuitState).    % [2,4,6]

%% 获取首饰装备的套装信息
get_accessory_suit_info(SuitState) ->
    get_specific_suit_info(?ACCESSORY, ?ACCESSORY_ATTR_LIST, SuitState).    % [2,3,4]

%% 获取具体类型装备的套装信息
get_specific_suit_info(SuitType, AttrList, SuitState) ->
    % 过滤特定类型的套装状态
    States = lists:filter(fun(State) -> #suit_state{key = {Type, _, _}} = State, Type =:= SuitType end, SuitState),
    % 按照套装类型lv、阶数slv的优先度排序
    SortF = fun(State1, State2) ->
                #suit_state{key = {_, Lv1, SLv1}} = State1,
                #suit_state{key = {_, Lv2, SLv2}} = State2,
                if
                    Lv1 > Lv2 -> true;
                    Lv1 =:= Lv2 andalso SLv1 >= SLv2 -> true;
                    true -> false
                end
            end,
    SortState = lists:sort(SortF, States),
    case SuitType of
        ?EQUIPMENT ->
            new_calc_suit_info_core(SortState, #{});
        _ ->
            calc_suit_info_core(SuitType, SortState, AttrList, [])
    end.

%% 计算武防装备套装信息核心
calc_suit_info_core(_SuitType, [], _List, InfoLists) -> InfoLists;      % 没有足够套装可以激活阶段属性
calc_suit_info_core(SuitType, SuitState, [], InfoLists) ->
    case SuitType of
        ?EQUIPMENT -> InfoLists;    % 对于武防只能激活一套属性
        ?ACCESSORY ->               % 对于饰品可以激活多套属性
            #suit_state{key = {?ACCESSORY, CurLv, _}} = lists:nth(1, SuitState),
            NextState = lists:filter(fun(State) -> #suit_state{key = {_, Lv, _}} = State, Lv =/= CurLv end, SuitState),
            calc_suit_info_core(SuitType, NextState, ?ACCESSORY_ATTR_LIST, InfoLists)
    end;
calc_suit_info_core(SuitType, SuitState, [N|T], InfoLists) ->
    % 取出当前状态列表中最高级的套装（即第一个状态的套装等级）
    #suit_state{key = {_Type, CurLv, _}} = lists:nth(1, SuitState),
    % 取出当前套装等级的套装状态
    CurState = lists:filter(fun(State) -> #suit_state{key = {_, Lv, _}} = State, Lv =:= CurLv end, SuitState),
    F = fun(State, {SLv, Num}) ->
            case Num >= N of
                true ->
                    {SLv, Num};
                false ->
                    #suit_state{key = {_, _, CurSLv}, count = Count} = State,
                    {CurSLv, Num+Count}
            end
        end,
    {CurSLv, CurCount} = lists:foldl(F, {0, 0}, CurState),
    case CurCount >= N of
        % 当前级别套装件数可以激活属性，当前级别套装可能还能激活下一阶段属性
        true ->
            calc_suit_info_core(SuitType, SuitState, T, [{CurLv, CurSLv, N}|InfoLists]);
        % 当前级别套装件数不可以激活属性，取出当前级别套装，进入下一阶段计算
        false ->
            NextState = lists:filter(fun(State) -> #suit_state{key = {_, Lv, _}} = State, Lv =/= CurLv end, SuitState),
            calc_suit_info_core(SuitType, NextState, [N|T], InfoLists)
    end.

calc_suit_state(SuitList) ->
    F = fun(#suit_item{pos = Pos, lv = Lv, slv = SLv}, Acc) ->
        case lib_equip:get_suit_type(Pos) of
            0 -> Acc;
            Type ->
                Key = {Type, Lv, SLv},
                case lists:keyfind(Key, #suit_state.key, Acc) of
                    #suit_state{count = Count} = Suit ->
                        lists:keystore(Key, #suit_state.key, Acc, Suit#suit_state{count = Count + 1});
                    false ->
                        [#suit_state{key = Key, count = 1} | Acc]
                end
        end
    end,
    lists:foldl(F, [], SuitList).

calc_suit_attr(SuitState) ->
    F = fun({MakeType, MakeLevel, Count}, {SuitType, AttrLists}) ->
            case SuitType of
                ?EQUIPMENT ->
                    CurAttrList =  [AttrList || {C, AttrList} <- data_equip_suit:get_attr_list(SuitType, MakeType, MakeLevel), C =< Count];
                _ ->
                    CurAttrList =  [AttrList || {C, AttrList} <- data_equip_suit:get_attr_list(SuitType, MakeType, MakeLevel), C =:= Count]
            end,
            NewAttrList = lists:append(CurAttrList, AttrLists),
            {SuitType, NewAttrList}
        end,
    % 获取武防装备信息
    EquipmentSuitInfo = get_equipment_suit_info(SuitState),
    {?EQUIPMENT, EquipmentList} = lists:foldl(F, {?EQUIPMENT, []}, EquipmentSuitInfo),
    % 获取饰品装备信息
    AccessorySuitInfo = get_accessory_suit_info(SuitState),
    {?ACCESSORY, AccessoryList} = lists:foldl(F, {?ACCESSORY, []}, AccessorySuitInfo),
    ulists:kv_list_plus_extra(lists:append(EquipmentList, AccessoryList)).  % 最后再来汇总计算

get_one_equip_suit_attr(GoodsStatus, GoodsInfo) ->
    SuitInfoList = get_suit_info(GoodsStatus, GoodsInfo),
    SuitType = data_equip_suit:pos2type(GoodsInfo#goods.subtype),
    ulists:kv_list_plus_extra([A || {Lv, SLv, Count} <- SuitInfoList, {C, A} <- data_equip_suit:get_attr_list(SuitType, Lv, SLv), C =< Count]).


%% 更换装备已经不需要判断套装是否需要替换的操作（装备升阶用）
update_suit(_PS, GoodsStatus, _OldGoodsInfo, _GoodsInfo, _EquipPos) ->
    {GoodsStatus, []}.
%% 更换装备引发套装还原
update_suit(PS, [], _NewEquipInfo) -> PS;
update_suit(PS, OldEquipInfo, NewEquipInfo) ->
    EquipPos = NewEquipInfo#goods.equip_type,
    case get_cur_min_suit_lv(OldEquipInfo, NewEquipInfo) of
        % 0则可以兼容旧装备的套装激活
        0 -> PS;
        RestoreLv ->
            case lib_equip:restore_suit(PS, RestoreLv, EquipPos) of
                {true, NewPS, NewLv, SLv, RewardListSendNew, NewSuitInfo} ->
                    lib_server_send:send_to_sid(PS#player_status.sid, pt_152, 15222, [EquipPos, NewLv, SLv, RewardListSendNew, NewSuitInfo]),
                    NewPS;
                {false, _Res} -> PS
            end
    end.

%% 获取新穿戴装备所不能兼容的最小套装类型
get_cur_min_suit_lv(OldEquipInfo, NewEquipInfo) ->
    EquipPos = NewEquipInfo#goods.equip_type,
    SuitType = lib_equip:get_suit_type(EquipPos),
    OldStage = lib_equip_api:get_equip_stage(OldEquipInfo),
    NewStage = lib_equip_api:get_equip_stage(NewEquipInfo),
    if
        % SuitType =:= ?ACCESSORY -> 0;
        SuitType =:= ?EQUIPMENT andalso OldStage =/= NewStage -> 1;
        SuitType =:= ?ACCESSORY andalso OldStage > NewStage -> 1;
        true ->
            GS = lib_goods_do:get_goods_status(),
            SuitList = GS#goods_status.equip_suit_list,
            LvList = [Lv || #suit_item{key = {PosId, Lv}} <- SuitList, PosId =:= EquipPos],
            ActivateLvs = lists:sort(LvList),   % 当前部位已激活的套装
            F = fun(Lv, CurLv) ->
                    SLv = ?IF(SuitType =:= ?EQUIPMENT, NewStage, get_suit_stage(EquipPos, Lv)),
                    SuitMakeCfg = data_equip_suit:get_make_cfg(EquipPos, Lv, SLv),
                    % SuitMakeCondition = SuitMakeCfg#suit_make_cfg.condition,
                    % QualityCondition = ulists:keyfind(quality, 1, SuitMakeCondition, {}),
                    case lib_equip_check:check({check_config_condition, SuitMakeCfg, NewEquipInfo}) of
                        {false, _Error} -> NewLv = ?IF(CurLv =:= 0, Lv, CurLv);
                        true -> NewLv = CurLv
                    end,
                    NewLv
                end,
            lists:foldl(F, 0, ActivateLvs)
    end.
%% 获取现穿戴装备所不能兼容的套装阶数
get_cur_min_suit_stage(SuitType, Lv, EquipPos) ->
    GS = lib_goods_do:get_goods_status(),
    #suit_item{slv = CurSLv} = get_suit_item(EquipPos, Lv, GS),
    case SuitType of
        ?EQUIPMENT -> CurSLv;
        ?ACCESSORY -> get_cur_min_suit_stage_core(1, CurSLv, Lv, EquipPos)
    end.
get_cur_min_suit_stage_core(SLv, CurSLv, _Lv, _EquipPos) when SLv > CurSLv -> CurSLv;   % 此时为主动退回套装打造
get_cur_min_suit_stage_core(SLv, CurSLv, Lv, EquipPos) ->
    GS = lib_goods_do:get_goods_status(),
    EquipInfo = lib_equip:get_equip_by_location(GS, EquipPos),
    SuitMakeCfg = data_equip_suit:get_make_cfg(EquipPos, Lv, SLv),
    SuitMakeCondition = SuitMakeCfg#suit_make_cfg.condition,
    StageCondition = ulists:keyfind(stage, 1, SuitMakeCondition, {}),
    % 主要通过判断阶数能否达到要求
    case lib_equip_check:check({suit_condition, StageCondition, EquipInfo}) of
        true -> get_cur_min_suit_stage_core(SLv+1, CurSLv, Lv, EquipPos);
        {false, _ERROR} -> SLv
    end.

return_suit_cost(RoleId, Data) ->
    case Data of
        {return, ReturnCost, EquipId, EquipTypeId, Type, Lv, Slv, Count} ->
            case ReturnCost of
                [_ | _] ->
                    Title = ?LAN_MSG(?LAN_TITLE_EQUIP_SUIT_TAKEOFF),
                    Content = ?LAN_MSG(?LAN_CONTENT_EQUIP_SUIT_TAKEOFF),
                    Goods = lib_goods_util:goods_to_bind_goods(ReturnCost),
                    Produce = #produce{title = Title, content = Content, reward = Goods, type = equip_suit_take_off, show_tips = 1},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce);
                _ ->
                    ok
            end,
            lib_log_api:log_equip_suit_operation(RoleId, EquipId, EquipTypeId, Type, Lv, Slv, Count, 0);
        _ ->
            ok
    end.

get_initual_suit(RoleId) ->
    SQL = io_lib:format("SELECT `pos`, `suit_lv`, `suit_slv` FROM `equip_suit` WHERE `role_id`=~p", [RoleId]),
    case db:get_all(SQL) of
        [] ->
            [];
        All ->
            [#suit_item{key = {Pos, Lv}, pos = Pos, lv = Lv, slv = SLv} || [Pos, Lv, SLv] <- All, SLv =/= 0]
    end.

normal_stage2suit_state(EquipPos, Lv, Stage) ->
    Type = data_equip_suit:pos2type(EquipPos),
    if
        Type =:= ?EQUIP_SUIT_LV_ORNAMENT ->
            case data_equip_suit:get_slvs(Type, Lv) of
                [SLv] ->
                    SLv;
                _ ->
                    Stage
            end;
        true ->
            Stage
    end.

%% 获取套装最低阶数
get_suit_stage_min(EquipPos, Lv) ->
    SuitType = data_equip_suit:pos2type(EquipPos),
    StageList = data_equip_suit:get_slvs(SuitType, Lv),
    lists:min(StageList).

%% 根据部位和套装级别获取当前阶数
get_suit_stage(EquipPos, Lv) ->
    GS = lib_goods_do:get_goods_status(),
    SuitList = GS#goods_status.equip_suit_list,
    #suit_item{slv = SLv} = ulists:keyfind({EquipPos, Lv}, #suit_item.key, SuitList, #suit_item{}),
    SLv.


%%--------------------------------------------------
%% 计算装备铸灵所加属性
%% @param  CastingSpiritL [#equip_casting_spirit{}]
%% @param  EquipList      [#goods{}]
%% @return                description
%%--------------------------------------------------
count_casting_spirit_attr(CastingSpiritL, EquipList) ->
    do_count_casting_spirit_attr(CastingSpiritL, EquipList, []).

do_count_casting_spirit_attr([], _, AttrList) ->
    util:combine_list(AttrList);
do_count_casting_spirit_attr([OneR | CastingSpiritL], EquipList, AttrList) ->
    #equip_casting_spirit{pos = EquipPos, stage = Stage, lv = Lv} = OneR,
    case lists:keyfind(EquipPos, #goods.cell, EquipList) of
        #goods{goods_id = GTypeId} = EquipInfo ->
            EquipStage = get_equip_stage(GTypeId),
            case EquipStage >= ?CASTING_SPIRIT_MIN_STAGE of
                true ->
                    BaseAttr = data_goods:count_base_attribute(EquipInfo),
                    LvAttrL = case data_equip_spirit:get_lv_cfg(EquipPos, Stage, Lv) of
                                  #casting_spirit_lv_cfg{attr_plus = AttrPlus} ->
                                      [{TAttrId, round(TAttrVal * AttrPlus / 10000)} || {TAttrId, TAttrVal} <- BaseAttr];
                                  _ ->
                                      []
                              end,
                    F = fun(T, Acc) ->
                        case data_equip_spirit:get_stage_cfg(EquipPos, T) of
                            #casting_spirit_stage_cfg{attr = SpecialAttrL} ->
                                SpecialAttrL ++ Acc;
                            _ ->
                                Acc
                        end
                        end,
                    NewAttrList = lists:foldl(F, LvAttrL ++ AttrList, lists:seq(1, Stage));
                false ->
                    NewAttrList = AttrList
            end;
        false ->
            NewAttrList = AttrList
    end,
    do_count_casting_spirit_attr(CastingSpiritL, EquipList, NewAttrList).

casting_spirit(PS, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:casting_spirit_check(PS, GoodsStatus, EquipPos) of
        {true, EquipInfo, Cost, OldStage, OldLv, NewStage, NewLv} ->
            do_casting_spirit(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldStage, OldLv, NewStage, NewLv);
        {false, Res} ->
            {false, Res, PS}
    end.

do_casting_spirit(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldStage, OldLv, NewStage, NewLv) ->
    #player_status{id = RoleId} = PS,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, equip_casting_spirit, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_casting_spirit = EquipCastingSpiritL
                } = GoodsStatus,
                case lists:keyfind(EquipPos, #equip_casting_spirit.pos, EquipCastingSpiritL) of
                    CastingSpiritInfoR when is_record(CastingSpiritInfoR, equip_casting_spirit) ->
                        NewCastingSpiritInfoR = CastingSpiritInfoR#equip_casting_spirit{stage = NewStage, lv = NewLv},
                        lib_goods_util:update_casting_spirit(RoleId, EquipPos, NewStage, NewLv);
                    _ ->
                        NewCastingSpiritInfoR = #equip_casting_spirit{pos = EquipPos, stage = NewStage, lv = NewLv},
                        lib_goods_util:insert_casting_spirit(RoleId, EquipPos, NewStage, NewLv)
                end,

                NewRating = count_casting_spirit_rating(EquipInfo, NewCastingSpiritInfoR),
                LastCastingSpiritInfoR = NewCastingSpiritInfoR#equip_casting_spirit{rating = NewRating},

                NewEquipCastingSpiritL = lists:keystore(EquipPos, #equip_casting_spirit.pos, EquipCastingSpiritL, LastCastingSpiritInfoR),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_casting_spirit = NewEquipCastingSpiritL
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_equip_casting_spirit(RoleId, EquipPos, Cost, OldStage, OldLv, NewStage, NewLv),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS, NewStage, NewLv};
        Error ->
            ?ERR("casting_spirit error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

upgrade_spirit(PS) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_spirit_check(PS, GoodsStatus) of
        {true, Cost, OldLv, NewLv} ->
            do_upgrade_spirit(PS, GoodsStatus, Cost, OldLv, NewLv);
        {false, Res} ->
            {false, Res, PS}
    end.

do_upgrade_spirit(PS, GoodsStatus, Cost, OldLv, NewLv) ->
    #player_status{id = RoleId} = PS,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, equip_upgrade_spirit, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_spirit = EquipSpirit
                } = GoodsStatus,

                lib_goods_util:update_spirit(RoleId, NewLv),

                NewEquipSpirit = EquipSpirit#equip_spirit{lv = NewLv},
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_spirit = NewEquipSpirit
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_equip_upgrade_spirit(RoleId, Cost, OldLv, NewLv),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS, NewLv};
        Error ->
            ?ERR("upgrade_spirit error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

%%--------------------------------------------------
%% 计算装备觉醒等级
%% @param  GoodsStatus #goods_status{}
%% @param  EquipInfo   #goods{}
%% @return             AwakeningLv
%%--------------------------------------------------
count_awakening_lv(GoodsStatus, EquipInfo) when is_record(EquipInfo, goods) ->
    #goods_status{
        equip_awakening_list = EquipAwakeningL
    } = GoodsStatus,
    #goods{
        goods_id = GTypeId,
        color = Color,
        cell = EquipPos
    } = EquipInfo,
    EquipStage = get_equip_stage(GTypeId),
    EquipStar = get_equip_star(GTypeId),
    case EquipStage >= ?EQUIP_AWAKENING_MIN_STAGE andalso EquipStar >= ?EQUIP_AWAKENING_MIN_START andalso Color >= ?ORANGE of
        true ->
            case lists:keyfind(EquipPos, #equip_awakening.pos, EquipAwakeningL) of
                #equip_awakening{lv = Lv} ->
                    LvLim = data_equip_awakening:get_lv_lim(EquipStage),
                    min(Lv, LvLim);
                _ ->
                    0
            end;
        false ->
            0
    end;
count_awakening_lv(_, _) ->
    0.

%%--------------------------------------------------
%% 计算装备觉醒属性
%% @param  GoodsStatus #goods_status{}
%% @param  EquipList   [#goods{}]
%% @return             [{属性id,属性值}]
%%--------------------------------------------------
count_awakening_attr(GoodsStatus, EquipList) ->
    #goods_status{
        equip_stren_list = StrenList
    } = GoodsStatus,
    F = fun(EquipInfo, Acc) ->
        case EquipInfo of
            #goods{cell = EquipPos} ->
                AwakeningLv = count_awakening_lv(GoodsStatus, EquipInfo),
                case AwakeningLv > 0 of
                    true ->
                        case data_equip_awakening:get_lv_cfg(EquipPos, AwakeningLv) of
                            #equip_awakening_lv_cfg{
                                base_plus = BasePlus,
                                stren_plus = StrenPlus,
                                suit_base_plus = SuitBasePlus,
                                suit_extra_plus = SuitExtraPlus
                            } ->
                                BaseAttr = data_goods:count_base_attribute(EquipInfo),
                                StrenAttr = case lists:keyfind(EquipPos, 1, StrenList) of
                                                {EquipPos, #equip_stren{stren = StrenLv}} ->
                                                    case data_equip:stren_lv_cfg(EquipPos, StrenLv) of
                                                        #base_equip_stren{attr_list = List} ->
                                                            List;
                                                        _ ->
                                                            []
                                                    end;
                                                _ ->
                                                    []
                                            end,
                                SuitAttr = get_one_equip_suit_attr(GoodsStatus, EquipInfo),
                                BaseAttrPlus = [{AttrId, round(AttrVal * (BasePlus / 10000))} || {AttrId, AttrVal} <- BaseAttr],
                                StrenAttrPlus = [{AttrId, round(AttrVal * (StrenPlus / 10000))} || {AttrId, AttrVal} <- StrenAttr],
                                F1 = fun(T, TmpAcc) ->
                                    case T of
                                        {AttrId, AttrVal} ->
                                            case lists:member(AttrId, ?BASE_ATTR_LIST) of
                                                true ->
                                                    [{AttrId, round(AttrVal * (SuitBasePlus / 10000))} | TmpAcc];
                                                false ->
                                                    [{AttrId, round(AttrVal * (SuitExtraPlus / 10000))} | TmpAcc]
                                            end;
                                        _ ->
                                            TmpAcc
                                    end
                                     end,
                                SuitAttrPlus = lists:foldl(F1, [], SuitAttr),
                                ulists:kv_list_plus_extra([SuitAttrPlus, BaseAttrPlus, StrenAttrPlus, Acc]);
                            _ ->
                                Acc
                        end;
                    false ->
                        Acc
                end;
            _ ->
                Acc
        end
        end,
    lists:foldl(F, [], EquipList).

%% 装备觉醒
awakening(PS, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:awakening_check(PS, GoodsStatus, EquipPos) of
        {true, EquipInfo, Cost, OldLv, NewLv} ->
            do_awakening(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldLv, NewLv);
        {false, Res} ->
            {false, Res, PS}
    end.

do_awakening(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldLv, NewLv) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    #figure{name = RoleName} = Figure,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, equip_awakening, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_awakening_list = EquipAwakeningL
                } = GoodsStatus,
                case lists:keyfind(EquipPos, #equip_awakening.pos, EquipAwakeningL) of
                    AwakeningInfoR when is_record(AwakeningInfoR, equip_awakening) ->
                        NewAwakeningInfoR = AwakeningInfoR#equip_awakening{lv = NewLv},
                        lib_goods_util:update_awakening(RoleId, EquipPos, NewLv);
                    _ ->
                        NewAwakeningInfoR = #equip_awakening{pos = EquipPos, lv = NewLv},
                        lib_goods_util:insert_awakening(RoleId, EquipPos, NewLv)
                end,

                NewEquipAwakeningL = lists:keystore(EquipPos, #equip_awakening.pos, EquipAwakeningL, NewAwakeningInfoR),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_awakening_list = NewEquipAwakeningL
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_equip_awakening(RoleId, EquipPos, Cost, OldLv, NewLv),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            %% 觉醒传闻
            lib_chat:send_TV({all}, ?MOD_EQUIP, 5, [RoleName, RoleId, EquipInfo#goods.goods_id, EquipInfo#goods.id, RoleId, NewLv]),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS};
        Error ->
            ?ERR("do_awakening error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

-define(EQUIP_SKILL_ADD, 1).
-define(EQUIP_SKILL_UPGRADE, 2).
-define(EQUIP_SKILL_REMOVE, 3).

%% 附加唤魔技能
add_equip_skill(PS, EquipPos, SkillId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:add_equip_skill_check(PS, GoodsStatus, EquipPos, SkillId) of
        {true, EquipInfo, Cost} ->
            do_add_equip_skill(PS, GoodsStatus, EquipPos, EquipInfo, Cost, SkillId);
        {false, Res} ->
            {false, Res, PS}
    end.

do_add_equip_skill(PS, GoodsStatus, EquipPos, EquipInfo, Cost, SkillId) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    #figure{name = RoleName} = Figure,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, add_equip_skill, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_skill_list = EquipSkillL
                } = GoodsStatus,
                case lists:keyfind(EquipPos, #equip_skill.pos, EquipSkillL) of
                    EquipSkillInfoR when is_record(EquipSkillInfoR, equip_skill) ->
                        NewEquipSkillInfoR = EquipSkillInfoR#equip_skill{skill_id = SkillId, skill_lv = 1},
                        lib_goods_util:update_equip_skill(RoleId, EquipPos, SkillId, 1);
                    _ ->
                        NewEquipSkillInfoR = #equip_skill{pos = EquipPos, skill_id = SkillId, skill_lv = 1},
                        lib_goods_util:insert_equip_skill(RoleId, EquipPos, SkillId, 1)
                end,

                NewEquipSkillL = lists:keystore(EquipPos, #equip_skill.pos, EquipSkillL, NewEquipSkillInfoR),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_skill_list = NewEquipSkillL
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_equip_skill(RoleId, EquipPos, SkillId, ?EQUIP_SKILL_ADD, Cost, 0, 1, []),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            %% 唤魔传闻
            SkillName = lib_skill_api:get_skill_name(SkillId, 1),
            lib_chat:send_TV({all}, ?MOD_EQUIP, 6, [RoleName, RoleId, EquipInfo#goods.goods_id, EquipInfo#goods.id, RoleId, 1, SkillName]),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS};
        Error ->
            ?ERR("add_equip_skill error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

%% 计算唤魔技能时候返还的消耗
count_equip_skill_return_cost(SkillId, SkillLv) ->
    do_count_equip_skill_return_cost(SkillId, 1, SkillLv, []).

do_count_equip_skill_return_cost(_SkillId, SkillLv, TargetLv, ReturnCostL) when SkillLv > TargetLv ->
    ulists:object_list_plus(ReturnCostL);
do_count_equip_skill_return_cost(SkillId, SkillLv, TargetLv, ReturnCostL) ->
    case data_equip_awakening:get_skill_lv_cfg(SkillId, SkillLv) of
        #equip_skill_lv_cfg{cost = Cost} when Cost =/= [] ->
            do_count_equip_skill_return_cost(SkillId, SkillLv + 1, TargetLv, [Cost | ReturnCostL]);
        _ ->
            do_count_equip_skill_return_cost(SkillId, SkillLv + 1, TargetLv, ReturnCostL)
    end.

%% 移除唤魔技能
remove_equip_skill(PS, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:remove_equip_skill_check(PS, GoodsStatus, EquipPos) of
        {true, Cost, OldSkillId, OldSkillLv} ->
            do_remove_equip_skill(PS, GoodsStatus, EquipPos, Cost, OldSkillId, OldSkillLv);
        {false, Res} ->
            {false, Res, PS}
    end.

do_remove_equip_skill(PS, GoodsStatus, EquipPos, Cost, OldSkillId, OldSkillLv) ->
    #player_status{id = RoleId} = PS,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, remove_equip_skill, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_skill_list = EquipSkillL
                } = GoodsStatus,
                lib_goods_util:delete_equip_skill(RoleId, EquipPos),
                NewEquipSkillL = lists:keydelete(EquipPos, #equip_skill.pos, EquipSkillL),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_skill_list = NewEquipSkillL
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            %% 返还之前的培养材料
            ReturnCostL = count_equip_skill_return_cost(OldSkillId, OldSkillLv),
            Produce = lib_goods_api:make_produce(remove_equip_skill_return_cost, 0, utext:get(203), utext:get(204), ReturnCostL, 1),
            {ok, LastPSTmp} = lib_goods_api:send_reward_with_mail(NewPS, Produce),
            %% 日志
            lib_log_api:log_equip_skill(RoleId, EquipPos, OldSkillId, ?EQUIP_SKILL_REMOVE, Cost, OldSkillLv, 0, ReturnCostL),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(LastPSTmp),
            {true, ?SUCCESS, LastPS};
        Error ->
            ?ERR("remove_equip_skill error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

upgrade_equip_skill(PS, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_equip_check:upgrade_equip_skill_check(PS, GoodsStatus, EquipPos) of
        {true, EquipInfo, Cost, OldEquipSkillInfo, NewEquipSkillInfo} ->
            do_upgrade_equip_skill(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldEquipSkillInfo, NewEquipSkillInfo);
        {false, Res} ->
            {false, Res, PS}
    end.

do_upgrade_equip_skill(PS, GoodsStatus, EquipPos, EquipInfo, Cost, OldEquipSkillInfo, NewEquipSkillInfo) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    #figure{name = RoleName} = Figure,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case lib_goods_util:cost_object_list(PS, Cost, upgrade_equip_skill, "", GoodsStatus) of
            {true, NewStatus, NewPS} ->
                #goods_status{
                    dict = OldGoodsDict,
                    equip_skill_list = EquipSkillL
                } = GoodsStatus,
                lib_goods_util:update_equip_skill_lv(RoleId, EquipPos, NewEquipSkillInfo#equip_skill.skill_lv),
                NewEquipSkillL = lists:keystore(EquipPos, #equip_skill.pos, EquipSkillL, NewEquipSkillInfo),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                    equip_skill_list = NewEquipSkillL
                },
                {ok, LastStatus, GoodsL, NewPS};
            {false, Res, NewStatus, NewPS} ->
                {error, Res, NewStatus, NewPS}
        end
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_equip_skill(RoleId, EquipPos, NewEquipSkillInfo#equip_skill.skill_id, ?EQUIP_SKILL_UPGRADE, Cost, OldEquipSkillInfo#equip_skill.skill_lv, NewEquipSkillInfo#equip_skill.skill_lv, []),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            %% 唤魔传闻
            SkillName = lib_skill_api:get_skill_name(NewEquipSkillInfo#equip_skill.skill_id, NewEquipSkillInfo#equip_skill.skill_lv),
            lib_chat:send_TV({all}, ?MOD_EQUIP, 6, [RoleName, RoleId, EquipInfo#goods.goods_id, EquipInfo#goods.id, RoleId, NewEquipSkillInfo#equip_skill.skill_lv, SkillName]),
            {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {true, ?SUCCESS, LastPS};
        Error ->
            ?ERR("upgrade_equip_skill error:~p", [Error]),
            {false, ?FAIL, PS}
    end.

count_equip_skill_attr(GoodsStatus, EquipInfoL) ->
    #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
    F = fun(#equip_skill{pos = Pos, skill_id = SkillId, skill_lv = Lv}, Acc) ->
        case lists:keyfind(Pos, #goods.cell, EquipInfoL) of
            EquipInfo when is_record(EquipInfo, goods) ->
                AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
                RealLv = min(Lv, AwakeningLv),
                [{SkillId, RealLv} | Acc];
            _ ->
                Acc
        end
        end,
    Data = lists:foldl(F, [], EquipSkillL),
    lib_skill:get_passive_skill_attr(Data).

count_equip_skill_power(GoodsStatus, EquipInfoL) ->
    #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
    F = fun(#equip_skill{pos = Pos, skill_id = SkillId, skill_lv = Lv}, Acc) ->
        case lists:member(SkillId, [23000007, 23000008]) of
            true ->
                case lists:keyfind(Pos, #goods.cell, EquipInfoL) of
                    EquipInfo when is_record(EquipInfo, goods) ->
                        AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
                        RealLv = min(Lv, AwakeningLv),
                        Acc + lib_skill_api:get_skill_power(SkillId, RealLv);
                    _ ->
                        Acc
                end;
            _ ->
                Acc
        end
        end,
    lists:foldl(F, 0, EquipSkillL).

%% 秘籍，一键添加装备
one_key_add_equip(Status, Color, Star) ->
    #player_status{id = RoleId, figure = #figure{sex = Sex}} = Status,
    SubTypeList = data_goods_type:get_subtype(?GOODS_TYPE_EQUIP),
    F = fun(SubType, List) ->
        GoodsTypeIdList = data_goods_type:get_by_type(?GOODS_TYPE_EQUIP, SubType),
        FI = fun(GoodsTypeId, ListI) ->
            EStar = get_equip_star(GoodsTypeId),
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{color = EColor, sex = ESex} when EColor == Color andalso EStar==Star andalso (ESex == 0 orelse ESex == Sex)  ->
                    [{?TYPE_GOODS, GoodsTypeId, 1}|ListI];
                _ -> ListI
            end
        end,
        lists:foldl(FI, List, GoodsTypeIdList)
    end,
    GiveGoodsList = lists:foldl(F, [], SubTypeList),
    ?PRINT("one_key_add_equip ~p~n", [length(GiveGoodsList)]),
    spawn(fun() -> one_key_add_equip_core(RoleId, GiveGoodsList) end),
    ok.

%% 秘籍，一键添加装备，带阶数
one_key_add_equip(Status, Stage, Color, Star) ->
    #player_status{id = RoleId, figure = #figure{sex = Career}} = Status,
    SubTypeList = data_goods_type:get_subtype(?GOODS_TYPE_EQUIP),
    F = fun(SubType, List) ->
        GoodsTypeIdList = data_goods_type:get_by_type(?GOODS_TYPE_EQUIP, SubType),
        FI = fun(GoodsTypeId, ListI) ->
            EStar = get_equip_star(GoodsTypeId),
            EStage = get_equip_stage(GoodsTypeId),
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{color = EColor, career = ECareer} when
                    EColor == Color andalso EStar==Star andalso (ECareer == 0 orelse ECareer == Career) andalso EStage == Stage  ->
                    [{?TYPE_GOODS, GoodsTypeId, 1}|ListI];
                _ -> ListI
            end
             end,
        lists:foldl(FI, List, GoodsTypeIdList)
        end,
    GiveGoodsList = lists:foldl(F, [], SubTypeList),
    ?PRINT("one_key_add_equip ~p~n", [length(GiveGoodsList)]),
    spawn(fun() -> one_key_add_equip_core(RoleId, GiveGoodsList) end),
    ok.

one_key_add_equip_core(RoleId, GiveGoodsList) ->
    Len = length(GiveGoodsList),
    case Len =< 50 of
        true -> lib_goods_api:send_reward_by_id(GiveGoodsList, gm, RoleId);
        _ ->
            {RewardList, LeftGiveList} = lists:split(50, GiveGoodsList),
            lib_goods_api:send_reward_by_id(RewardList, gm, RoleId),
            timer:sleep(1000),
            one_key_add_equip_core(RoleId, LeftGiveList)
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  是否包含属性id
%% @param    参数      AttrResult::lists    [{_Color, _AttrId, _AttrVal} |  {_Color, _AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus} ]
%%                     GainAttr   tuple     {_Color, _AttrId, _AttrVal} |  {_Color, _AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus}
%% @return   返回值    Boolean
%% @history  修改历史
%% -----------------------------------------------------------------
is_include_attr(AttrResult, {_Color, AttrId, _AttrVal}) ->
    case lists:keyfind(AttrId, 2, AttrResult) of
        false ->
            false;
        _ ->
            true
    end;
is_include_attr(AttrResult, {_Color, AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus}) ->
    case lists:keyfind(AttrId, 2, AttrResult) of
        false ->
            false;
        _ ->
            true
    end;
is_include_attr(_, _) ->
    false.



%% 是否满足红装要求
satisfied_red_equip(GoodsInfo) when is_record(GoodsInfo, goods) ->
    GoodsTypeId = GoodsInfo#goods.goods_id,
    satisfied_red_equip(GoodsTypeId);

satisfied_red_equip(GoodsTypeInfo) when is_record(GoodsTypeInfo, ets_goods_type) ->
    satisfied_red_equip(GoodsTypeInfo#ets_goods_type.goods_id);

satisfied_red_equip(GoodsTypeId) when is_integer(GoodsTypeId) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{equip_type = EquipPos} ->
            Stage = get_equip_stage(GoodsTypeId),
            Star = get_equip_star(GoodsTypeId),
            ClassType = get_equip_class_type(GoodsTypeId),
            Color = data_goods:get_goods_color(GoodsTypeId),
            RedEquipCon = data_goods:get_red_equip_con(),
            case lib_equip_check:check_satisfied_red_equip(RedEquipCon, [EquipPos, Stage, Star, Color, ClassType]) of
                true -> true;
                _ -> false
            end;
        _ -> false
    end;
satisfied_red_equip(_) ->
    false.

re_static_red_equip_award(AwardList) ->
    NAwardList = red_equip_award_sort(AwardList),
    re_static_red_equip_award(NAwardList, []).

re_static_red_equip_award([], Return) -> Return;
re_static_red_equip_award([{{Stage, Star}, Num}|AwardList], Return) ->
    StarList = data_equip:get_red_equip_star_list(Stage),
    DegradeStar = Star - 1,
    case DegradeStar > 1 andalso lists:member(DegradeStar, StarList) of
        true ->
            RedAttrList = data_equip:get_red_equip_attr(Stage, Star),
            StatisfyNumList = [EquipNum || {EquipNum, _Attr} <- RedAttrList, Num >= EquipNum],
            StatisfyNum = ?IF(StatisfyNumList == [], 0, lists:max(StatisfyNumList)),
            DegradeNum = Num - StatisfyNum,
            case AwardList of
                [{{Stage, DegradeStar}, Num2}|Left] ->
                    NAwardList = [{{Stage, DegradeStar}, Num2+DegradeNum}|Left];
                _ ->
                    NAwardList = ?IF(DegradeNum>0, [{{Stage, DegradeStar}, DegradeNum}|AwardList], AwardList)
            end,
            NReturn = ?IF(StatisfyNum>0, [{{Stage, Star}, StatisfyNum}|Return], Return),
            re_static_red_equip_award(NAwardList, NReturn);
        _ ->
            re_static_red_equip_award(AwardList, [{{Stage, Star}, Num}|Return])
    end.

red_equip_award_sort(AwardList) ->
    F = fun({{Stage1, Star1}, _Num1}, {{Stage2, Star2}, _Num2}) ->
        if
            Stage1 > Stage2 -> true;
            Stage1 == Stage2 -> Star1 >= Star2;
            true -> false
        end
    end,
    lists:sort(F, AwardList).

gm_restore_suit() ->
    case db:get_all("select `role_id`, `pos`, `suit_lv`, `suit_slv`, `sex` from `equip_suit` left join `player_low` on equip_suit.role_id = player_low.id") of
        [] -> ok;
        SuitListAll ->
            F = fun([RoleId, EquipPos, Lv, SLv, Sex], Return) ->
                FI = fun(SLv1, List) ->
                    case data_equip_suit:get_make_cfg(EquipPos, Lv, SLv1) of
                        #suit_make_cfg{cost = CostList} -> ok;
                        _ -> CostList = []
                    end,
                    case lists:keyfind(Sex, 1, CostList) of
                        {_, RestoreReward} -> RestoreReward ++ List;
                        _ -> List
                    end
                end,
                RewardList = lists:foldl(FI, [], lists:seq(1, SLv)),
                {_, RoleRewardList} = ulists:keyfind(RoleId, 1, Return, {RoleId, []}),
                NewRoleRewardList = ulists:object_list_plus_extra(RewardList ++ RoleRewardList),
                lists:keystore(RoleId, 1, Return, {RoleId, NewRoleRewardList})
            end,
            %% 删db数据
            _ReturnList = lists:foldl(F, [], SuitListAll)
    end.

gm_repaire_suit() -> ok.
    % case db:get_all("select `role_id`, `pos`, `suit_lv`, `suit_slv` from `equip_suit`") of
    %     [] -> ok;
    %     SuitListAll ->
    %         F = fun([RoleId, EquipPos, Lv, SLv]) ->
    %             case data_equip_suit:pos2type(EquipPos) of
    %                 2 when SLv > 0, SLv =< 4 ->
    %                     case Lv of
    %                         ?EQUIP_SUIT_LV_EQUIP ->
    %                             Sql1 = io_lib:format("update `equip_suit` set `suit_slv`=~p where `role_id`=~p and `pos`=~p and `suit_lv`=~p", [SLv+2, RoleId, EquipPos, Lv]),
    %                             db:execute(Sql1);
    %                         ?EQUIP_SUIT_LV_ORNAMENT ->
    %                             Sql1 = io_lib:format("update `equip_suit` set `suit_slv`=~p where `role_id`=~p and `pos`=~p and `suit_lv`=~p", [SLv+2, RoleId, EquipPos, Lv]),
    %                             db:execute(Sql1);
    %                         _ ->
    %                             ok
    %                     end;
    %                 _ -> ok
    %             end
    %         end,
    %         lists:foreach(F, SuitListAll)
    % end.

%%红2，红3，粉3装备增加额外基础属性
get_equip_other_attr(GoodsId) ->
    case data_equip:get_equip_attr_cfg(GoodsId) of
        #equip_attr_cfg{other_attr = Attr} ->
            Attr;
        _ ->
            []
    end.

%%%%%%%%%%%%%%%%% 装备战力
%% 宝石
get_equip_sub_mod_power(PS, ?EQUIP_STONE_POWER) ->
    case get({equip_power, ?EQUIP_STONE_POWER}) of
        undefined ->
            Power = update_equip_sub_mod_power(PS, ?EQUIP_STONE_POWER);
        Power -> ok
    end,
    Power;
get_equip_sub_mod_power(_PS, _) ->
    0.

%%%%%%%%%%%%%%%% 更新子模块战力
update_equip_sub_mod_power(PS, ?EQUIP_STONE_POWER) ->
    #player_status{original_attr = OriginalAttr} = PS,
    GS = lib_goods_do:get_goods_status(),
    StoneAttribute = data_goods:count_stone_attribute(GS),
    StonePower = lib_player:calc_partial_power(OriginalAttr, 0, StoneAttribute),
    put({equip_power, ?EQUIP_STONE_POWER}, StonePower),
    StonePower;
update_equip_sub_mod_power(_PS, _) ->
    0.


%%继承属性 ExtraAttr:: [{AttrId, Value}]
%%        AttrArgs :: [{Num, [{W, {AttrId, Value}}]   }]
inherit_attr([], AttrArgs) -> {[], AttrArgs};
inherit_attr(ExtraAttr, AttrArgs) ->
    %%可能生成的属性
    F = fun({Num, PoolList}, {LeftExtraAttr, AccInheritAttrList, AccAttrArgs}) -> %%还没有被继承的属性， 已经被继承的属性， 随机列表
        if
            Num >= 1 ->
                %%继承的属性  ， 未被继承的属性
                {InheritAttrList, NewLeftExtraAttr} = inherit_attr2(LeftExtraAttr, PoolList),  %%是否继承这个属性
                NewNum = max(Num - length(InheritAttrList), 0), %% 修正随机的长度
                %%还没有被继承的属性， 已经被继承的属性， 新的随机列表
                {NewLeftExtraAttr, InheritAttrList ++ AccInheritAttrList, [{NewNum, PoolList} | AccAttrArgs]};
            true ->
                {LeftExtraAttr, AccInheritAttrList, AccAttrArgs}
        end
        end,
    {_LastLeftExtraAttr, LastInheritAttrList, LastAttrArgs} = lists:foldl(F, {ExtraAttr, [], []}, AttrArgs),
    %% _LastLeftExtraAttr ::  未被继承的属性
    {LastInheritAttrList, lists:reverse(LastAttrArgs)}.


inherit_attr2(ExtraAttrList, PoolList) ->
    PoolAttrList = [TempAttr || {_W, TempAttr} <- PoolList],
    F = fun(ExtraAttr, {InheritAttrList, NewLeftExtraAttr}) ->  %% NewLeftExtraAttr未被继承的属性  InheritAttrList 被继承的属性
            case ExtraAttr of
                {Color, AttrId, AttrVal} ->
                    case lists:keyfind(AttrId, 2, PoolAttrList) of
                        {Color, AttrId, NewAttrVal} ->  %% 同颜色，同属性可以继承 ，获得新的属性值
                            {[ {Color, AttrId, NewAttrVal} | InheritAttrList], NewLeftExtraAttr};
                        _ -> %% 其他情况都是不能继承的
                            {InheritAttrList, [ {Color, AttrId, AttrVal}  | NewLeftExtraAttr]}
                    end;
                {Color, AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus} ->
                    case lists:keyfind(AttrId, 2, PoolAttrList) of
                        {Color, AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus} ->  %% 同颜色，同属性可以继承 ，获得新的属性值
                            {[ {Color, AttrId, AttrBaseVal, AttrPlusInterval, AttrPlus} | InheritAttrList], NewLeftExtraAttr};
                        _ -> %% 其他情况都是不能继承的
                            {InheritAttrList, [ {Color, AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus}  | NewLeftExtraAttr]}
                    end;
                _ ->%% 其他情况都是不能继承的
                    {InheritAttrList, [ ExtraAttr  | NewLeftExtraAttr]}
            end
        end,
    lists:foldl(F, {[], []}, ExtraAttrList).



%% 秘籍修复 极品属性
repair_other_attr() ->
    Sql = io_lib:format(<<"select pid, gid, gtype_id, extra_attr  from  goods_low  where  equip_type = 7 or  equip_type = 9">>, []),
    DbList = db:get_all(Sql),
    F = fun([RoleId, GoodsAutoId, GoodsTypeId, DbExtraAttr],  AccList) ->
            case lists:keyfind(RoleId, 1, AccList) of
                {RoleId, GoodsList} ->
                    NewGoodsList = [{GoodsAutoId, GoodsTypeId, util:bitstring_to_term(DbExtraAttr)} | GoodsList],
                    lists:keystore(RoleId, 1, AccList, {RoleId, NewGoodsList});
                _ ->
                    [{RoleId, [{GoodsAutoId, GoodsTypeId, util:bitstring_to_term(DbExtraAttr)}]} | AccList]
            end
        end,
    RoleGoodsList = lists:foldl(F, [], DbList),
    F2 = fun({RoleId, GoodsList}) ->
        case misc:get_player_process(RoleId) of
            Pid when is_pid(Pid) ->
                lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, lib_equip, repair_other_attr, [GoodsList]);
            _ ->
                repair_other_attr_off_line(RoleId, GoodsList)
        end
        end,
    lists:foreach(F2, RoleGoodsList).


%% 离线修复
repair_other_attr_off_line(_RoleId, GoodsList) ->
    F = fun({GoodsAutoId, GoodsTypeId, OtherAttr}) ->
        Res = is_other_attr_num_right(GoodsTypeId, OtherAttr),
        if
            Res == true -> %% 一致不用修复
                skip;
            true ->
                EtsGoodsInfo = data_goods_type:get(GoodsTypeId),
                ExtraAttr = gen_equip_extra_attr(EtsGoodsInfo, []),
                SExtraAttr = util:term_to_bitstring(ExtraAttr),
                Sql = io_lib:format(<<"update `goods_low` set  extra_attr = '~s' where gid = ~p ">>,
                    [SExtraAttr, GoodsAutoId]),
                db:execute(Sql)
        end
        end,
    lists:foreach(F, GoodsList).



repair_other_attr(PS, GoodsList) ->
    F = fun({GoodsAutoId, GoodsTypeId, OtherAttr}, GS) ->
            Res = is_other_attr_num_right(GoodsTypeId, OtherAttr),
            if
                Res == true -> %% 一致不用修复
                    GS;
                true ->
                    case lib_goods_api:get_goods_info(GoodsAutoId) of
                        GoodsInfo when is_record(GoodsInfo, goods) ->
                            #goods{other = OldOther} = GoodsInfo,
                            Other = gen_equip_other_attr(#ets_goods_type{goods_id = GoodsTypeId}, OldOther),
                            NewGoodsInfo = GoodsInfo#goods{other = Other},
                            %%同步数据库
                            [NewGoodsInfo, NewGS] = lib_goods:change_goods_level_extra_attr(NewGoodsInfo,
                                NewGoodsInfo#goods.location, NewGoodsInfo#goods.level, NewGoodsInfo#goods.other#goods_other.extra_attr, GS),
                            NewGS;
                        _ ->
                                GS
                    end

            end
        end,
    GS = lib_goods_do:get_goods_status(),
    NewGS = lists:foldl(F, GS, GoodsList),
    lib_goods_do:set_goods_status(NewGS),
    PS.

%%极品属性数量是否一致
is_other_attr_num_right(GoodsTypeId, OtherAttr) ->
    Length = length(OtherAttr),
    case data_equip:get_equip_attr_cfg(GoodsTypeId) of
        #equip_attr_cfg{nattr_1 = N1, nattr_2 = N2, nattr_3 = N3, nattr_4 = N4} ->
            N1 + N2 + N3 + N4 == Length;
        _ ->
           true
    end.

get_suit_power(Player) ->
    #player_status{goods = StatusGoods, original_attr = AllAttr} = Player,
    #status_goods{equip_suit_attr = Attr} = StatusGoods,
    lib_player:calc_partial_power(AllAttr, 0, Attr).

get_suit_all_lv(#player_status{off = Off, pid = undefined}) ->
    case Off of
        #status_off{goods_status = GoodsStatus} ->
            case GoodsStatus of
                #goods_status{equip_suit_list = SuitList} ->
                    F = fun(#suit_item{slv = Slv}, AccLv) ->
                        AccLv + Slv
                        end,
                    lists:foldl(F, 0, SuitList);
                _ ->
                    0
            end;
        _ ->
            0
    end;
get_suit_all_lv(_Player) ->
    #goods_status{equip_suit_list = SuitList} = lib_goods_do:get_goods_status(),
    F = fun(#suit_item{slv = Slv}, AccLv) ->
        AccLv + Slv
        end,
    lists:foldl(F, 0, SuitList).

%% 判断装备部位所属套装类型（武防/饰品）
is_equipment_suit(EquipPos) ->
    case data_equip_suit:pos2type(EquipPos) of
        ?EQUIPMENT -> true; % 武防
        _ -> false
    end.
is_accessory_suit(EquipPos) ->
    case data_equip_suit:pos2type(EquipPos) of
        ?ACCESSORY -> true; % 饰品
        _ -> false
    end.
get_suit_type(EquipPos) ->
    data_equip_suit:pos2type(EquipPos).

gm_reset_suit(PS) ->
    #player_status{figure = #figure{suit_clt_figure = SuitCltFigure}} = PS,
    {ok, NewPS} = ?IF(SuitCltFigure =:= 0, {ok, PS}, lib_suit_collect:wear_model(PS, SuitCltFigure, ?UNWEAR)),
    lib_suit_collect:db_delete_suit_clt_item(NewPS#player_status.id),
    NewPS#player_status{suit_collect = #suit_collect{}}.

%% -----------------------------------------------------------------
%% 新版装备套装规则 共鸣系统
%% -----------------------------------------------------------------
get_data(_Player) ->
    #goods_status{equip_suit_list = SuitList, equip_suit_state = SuitState} = lib_goods_do:get_goods_status(),
    ?MYLOG("lhh_equip", "SuitInfoLis:~p~n//SuitState:~p~n//Other:~p~n", [SuitList, SuitState, {get_equipment_suit_info(SuitState), calc_suit_attr(SuitState)}]).

%% 新的共鸣打造规则
new_make_suit_rule(PS, MakeType, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{ equip_suit_state = OldSuitState } = GoodsStatus,
    #suit_item{ slv = CurMakeLv } = get_suit_item(EquipPos, MakeType, GoodsStatus),
    EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos), % 当前的槽位装备信息
    case lib_equip_check:new_make_suit_rule_check(PS, EquipInfo, EquipPos, MakeType, CurMakeLv) of
        {true, EquipPos, NewMakeLv, Costs, MoneyList, DelGoodsList} ->
            ConsumeRecordMap = lib_goods_consume_record:get_consume_record_map(PS#player_status.id),    % 物品消耗记录表
            PsMoney = lib_player_record:trans_to_ps_money(PS, make_equip_suit),
            FilterConditions = [{id_in, [Id||{#goods{id=Id}, _} <- DelGoodsList]}],
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                case lib_goods_util:lightly_cost_object_list(PsMoney, MoneyList, make_equip_suit, integer_to_list(EquipPos), GoodsStatusBfTrans) of
                    {true, CostGoodsStatus, NewPsMoney} ->
                        {ok, NewGoodsStatus} = lib_goods:delete_goods_list(CostGoodsStatus, DelGoodsList),
                        db_update_suit_info(PS#player_status.id, EquipPos, MakeType, NewMakeLv),
                        #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
                        {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                        NewGoodsStatus1 = NewGoodsStatus#goods_status{dict = GoodsDict},
                        [
                            lib_log_api:log_throw(make_equip_suit, PS#player_status.id, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, TmpNum, 0, 0)
                            || {GoodsInfo, TmpNum} <- DelGoodsList
                        ],
                        {true, NewGoodsStatus1, GoodsL, NewPsMoney};
                    {false, Res, _, _} ->
                        throw({error, {not_enough, Res}})
                end
            end,
            case lib_goods_util:check_object_list(PS, Costs) of
                true ->
                    case lib_goods_util:transaction(F) of
                        {true, NewStatus, GoodsL, NewPsMoney} ->
                            CostGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
                            CostPS = lib_player_record:update_ps_money_op(PS, PsMoney, NewPsMoney),
                            {_NewConsumeRecord, NewConsumeRecordMap} =
                                lib_goods_consume_record:add_goods_comsume_record(CostPS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, MakeType, NewMakeLv}, MoneyList++DelGoodsList, [bind], ConsumeRecordMap),
                            lib_goods_consume_record:set_consume_record_map(NewConsumeRecordMap),
                            GoodsStatus1 = setup_equip_suit(CostGoodsStatus, EquipPos, MakeType, NewMakeLv),         % 更新套装列表和状态
                            NewSuitState = GoodsStatus1#goods_status.equip_suit_state,
                            TotalSuitAttr = calc_suit_attr(NewSuitState),     % 更新套装属性
                            #player_status{goods = SG} = CostPS,
                            NewSG = SG#status_goods{equip_suit_attr = TotalSuitAttr},
                            NewPS0 = CostPS#player_status{goods = NewSG},
                            NewGoodsStatus = GoodsStatus1#goods_status{is_dirty_suit = false},
                            {ok, NewPS} = lib_goods_util:count_role_equip_attribute(NewPS0, NewGoodsStatus),
                            lib_goods_api:notify_client(PS, GoodsL),
                            lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
                            Type = data_equip_suit:pos2type(EquipPos),
                            NewSuitInfo = ?IF(Type =:= ?EQUIPMENT, get_equipment_suit_info(NewSuitState), get_accessory_suit_info(NewSuitState)),
                            % 传闻，日志
                            OldSuitInfo = ?IF(Type =:= ?EQUIPMENT, get_equipment_suit_info(OldSuitState), get_accessory_suit_info(OldSuitState)),
                            NewSortInfo = lists:keysort(3, NewSuitInfo),    % 按激活N件套排序
                            RumorF = fun({CurLv, CurSLv, Count}) ->
                                case MakeType == CurLv andalso NewMakeLv == CurSLv of
                                    true ->
                                        case lists:keyfind(CurSLv, 2, OldSuitInfo) of
                                            % 当前的N件套与原状态一致
                                            {CurLv, CurSLv, Count} -> skip;
                                            % 当前的N件套为新的更新状态
                                            _ ->
                                                AttrL = data_equip_suit:get_attr_list(Type, CurLv, CurSLv),
                                                case lists:keymember(Count, 1, AttrL) of
                                                    true ->
                                                        RoleName = PS#player_status.figure#figure.name,
                                                        SuitName = data_equip_suit:get_suit_name(Type, CurLv, CurSLv),
                                                        lib_chat:send_TV({all}, ?MOD_EQUIP, 4, [RoleName, PS#player_status.id, EquipInfo#goods.goods_id, EquipInfo#goods.id, PS#player_status.id, SuitName, Count]),
                                                        lib_log_api:log_equip_suit_operation(PS#player_status.id, EquipInfo#goods.id, EquipInfo#goods.goods_id, Type, CurLv, CurSLv, Count, 1);
                                                    _ -> skip
                                                end
                                        end;
                                    _ ->
                                        skip
                                end
                            end,
                            lists:foreach(RumorF, NewSortInfo),
                            EventPS = lib_equip_event:make_suit_event(NewPS, NewGoodsStatus, EquipPos, MakeType, NewMakeLv),
                            send_15000(EventPS, NewGoodsStatus, EquipPos),
                            {true, EventPS, NewGoodsStatus, MakeType, NewMakeLv, NewSuitInfo};
                        {db_error, {error, {not_enough, Res}}} ->
                            {false, Res};
                        _A ->
                            ?ERR("make_suit err ~p~n", [_A]),
                            {false, ?FAIL}
                    end;
                {false, ErrorCode} ->
                    {false, ErrorCode};
                _ ->
                    {false, ?FAIL}
            end;
        Error ->
            Error
    end.

new_calc_suit_info_core([], InfoMaps) ->
    List = maps:to_list(InfoMaps),
    [{MakeType, MakeLevel, Count} || {{MakeType, MakeLevel}, Count} <- List];
new_calc_suit_info_core([#suit_state{count = Count}|Tail], InfoMaps) when Count < 1 ->
    new_calc_suit_info_core(Tail, InfoMaps);
new_calc_suit_info_core([State|Tail], InfoMaps) ->
    #suit_state{key = {_, MakeType, MakeLevel}, count = Count} = State,
    MapKey = {MakeType, MakeLevel},
    case maps:get(MapKey, InfoMaps, false) of
        false ->
            NewInfoMaps = maps:put(MapKey, Count, InfoMaps);
        HasCount when is_integer(HasCount) ->
            NewInfoMaps = maps:put(MapKey, HasCount + Count, InfoMaps)
    end,
    new_calc_suit_info_core(Tail, NewInfoMaps).

%% 发送套装详情
send_suit_combat_info(Player, EquipPos, MakeType, Level) ->
    #player_status{ id = PlayerId, figure = #figure{ lv = _RoleLV }, original_attr = OriginalAttr} = Player,
    Type = get_suit_type(EquipPos),
    case Type of
        0 -> skip;
        _ ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            SuitList = GoodsStatus#goods_status.equip_suit_state,
            SuitCfg = data_equip_suit:get_attr_list(Type, MakeType, Level),
            case SuitCfg of
                [] -> skip;
                _ ->
                    case lists:keyfind({Type, MakeType, Level}, #suit_state.key, SuitList) of
                        #suit_state{ count = Count } -> PlayerCount = Count;
                        _ -> PlayerCount = 0
                    end,
                    %% 判断玩家当前是否有生效的套装加成
                    Fun = fun({Num, AttrList}) ->
                        case PlayerCount >= Num of
                            true -> Combat = lib_player:calc_partial_power(OriginalAttr, 0, AttrList);
                            _ -> Combat = lib_player:calc_expact_power(OriginalAttr, 0, AttrList)
                        end,
                        {Num, Combat}
                    end,
                    SendList = lists:map(Fun, SuitCfg),
                    {ok, Bin} = pt_152:write(15262, [EquipPos, MakeType, Level, SendList]),
                    lib_server_send:send_to_uid(PlayerId, Bin)
            end
    end.

%% 新版回退规则
new_restore_suit(PS, MakeType, EquipPos) ->
    Type = ?EQUIPMENT,
    GoodsStatus = lib_goods_do:get_goods_status(),
    SuitList = GoodsStatus#goods_status.equip_suit_list,
    #suit_item{slv = CurMakeLevel} = get_suit_item(EquipPos, MakeType, GoodsStatus),
    case CurMakeLevel >= 1 of
        true ->
            NewMakeLevel = CurMakeLevel - 1,
            TotalRewardList = get_lv_restore_rewards(PS, CurMakeLevel, CurMakeLevel, EquipPos, MakeType, []),
            % 更新套装信息状态和信息并同步到数据库
            db_update_suit_info(PS#player_status.id, EquipPos, MakeType, NewMakeLevel),
            NewGS = setup_equip_suit(GoodsStatus, EquipPos, MakeType, NewMakeLevel),
            % 日志记录
            case lists:keyfind({Type, MakeType, CurMakeLevel}, #suit_state.key, NewGS#goods_status.equip_suit_state) of
                #suit_state{count = Count} ->
                    lib_log_api:log_equip_suit_operation(PS#player_status.id, 0, 0, Type, MakeType, CurMakeLevel, Count, 0);
                _ ->
                    skip
            end,
            % 整理退回的物品列表发送格式
            RewardListSend = lib_goods_api:trans_to_attr_goods(TotalRewardList),
            RewardListSendNew = [{GoodsType, Id, Num, util:term_to_string(AttrList)} ||{GoodsType, Id, Num, AttrList} <- RewardListSend],
            % 更新套装属性和玩家信息
            NewSuitState = NewGS#goods_status.equip_suit_state,
            TotalSuitAttr = calc_suit_attr(NewSuitState),
            #player_status{goods = SG} = PS,
            NewSG = SG#status_goods{equip_suit_attr = TotalSuitAttr},
            NewPS0 = PS#player_status{goods = NewSG},
            NewGoodsStatus = NewGS#goods_status{is_dirty_suit = false},
            % 计算装备属性，通知客户端更新物品和战力信息
            {ok, NewPS} = lib_goods_util:count_role_equip_attribute(NewPS0, NewGoodsStatus),
            lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
            EventPS = lib_equip_event:make_suit_event(NewPS, NewGoodsStatus, EquipPos, MakeType, SuitList),
            {_, LastPS} = lib_goods_api:send_reward_with_mail(EventPS, #produce{type = make_equip_suit, reward = TotalRewardList, remark = lists:concat(["restore_suit_", MakeType, "_", EquipPos])}),
            NewSuitInfo = get_equipment_suit_info(NewSuitState),
            send_15000(EventPS, NewGoodsStatus, EquipPos),
            {true, LastPS, MakeType, NewMakeLevel, RewardListSendNew, NewSuitInfo};
        _ ->
            {false, ?ERRCODE(err152_not_make_suit)}
    end.

new_restore_suit_preview(PS, MakeType, EquipPos) ->
    _Sex = PS#player_status.figure#figure.sex,
    Sex = ?IF(_Sex =:= 0, ?MALE, _Sex),
    GoodsStatus = lib_goods_do:get_goods_status(),
    #suit_item{slv = CurMakeLevel} = get_suit_item(EquipPos, MakeType, GoodsStatus),
    case CurMakeLevel >= 1 of
        true ->
            case data_equip_suit:get_make_cfg(EquipPos, MakeType, CurMakeLevel) of
                #suit_make_cfg{cost = CostList} -> ok;
                _ -> CostList = []
            end,
            case lists:keyfind(Sex, 1, CostList) of
                {_, RestoreRewardCon} ->
                    case lib_goods_consume_record:get_consume_record_with_mod_key(PS, ?MOD_EQUIP, ?MOD_EQUIP_SUIT, {EquipPos, MakeType, CurMakeLevel}) of
                        % 防止配置修改而多发还原奖励
                        [#consume_record{consume_list = ConsumeList}|_] -> RestoreReward = ConsumeList;
                        fail -> RestoreReward = RestoreRewardCon
                    end;
                _ -> RestoreReward = []
            end,
            RewardListSend = lib_goods_api:trans_to_attr_goods(RestoreReward),
            RewardListSendNew = [{GoodsType, Id, Num, util:term_to_string(AttrList)} || {GoodsType, Id, Num, AttrList} <- RewardListSend],
            {true, RewardListSendNew};
        _ ->
            {true, []}
    end.

send_15000(Ps, GoodsStatus, EquipPos) ->
    PlayerId = Ps#player_status.id,
    Dict = GoodsStatus#goods_status.dict,
    EquipList = lib_goods_util:get_equip_list(PlayerId, Dict),
    case lists:keyfind(EquipPos, #goods.equip_type, EquipList) of
        #goods{ id = GoodsId } when GoodsId > 0 ->
            pp_goods:handle(15000, Ps, [GoodsId]);
        _ ->
            skip
    end.

%% 计算装备战力(不包含套装战力)
calc_base_equip_power(RoleId, RoleLv, Goods, GoodsStatus) ->
    #goods_status{
        dict = GoodsDict,
        mount_equip_pos_list = MountEquipPos,
        mate_equip_pos_list = MateEquipPos
    } = GoodsStatus,
    %% 装备属性
    EquipAttr =
        case is_map(Goods#status_goods.equip_attribute) orelse is_record(Goods#status_goods.equip_attribute, attr) of
            true ->
                lib_player_attr:to_kv_list(Goods#status_goods.equip_attribute);
            false ->
                Goods#status_goods.equip_attribute
        end,
    FigureEquipAttr = lib_mount_equip:get_figure_equip_attr(RoleId, MountEquipPos, MateEquipPos, GoodsDict),
    StoneAttribute = data_goods:count_stone_attribute(GoodsStatus),
    LastEquipAttr = ulists:kv_list_minus_extra([EquipAttr, FigureEquipAttr, StoneAttribute]), % 去掉不计算在装备评分里属性
    pp_goods:get_count_attrlist_power([LastEquipAttr], RoleLv).