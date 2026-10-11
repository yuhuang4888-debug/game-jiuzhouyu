%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 幻饰
%%% @end
%%% Created : 03. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-module(lib_decoration_check).
-author("whao").

%% API
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("decoration.hrl").
-include("predefine.hrl").
%% API
-compile(export_all).


%% 检查装备条件
equip(#player_status{figure = #figure{lv = Lv}} = PS, GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
%%    ?PRINT(" id ~p  goods_id:~p~n",[GoodsInfo#goods.id,GoodsInfo#goods.goods_id]),
    Cell = GoodsInfo#goods.subtype,   % 物品子位置
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, ?GOODS_LOC_DECORATION, Cell, GoodsStatus#goods_status.dict),
    EtsGoods = data_goods_type:get(GoodsInfo#goods.goods_id),  % 物品配置
    NewdefaultLocation = EtsGoods#ets_goods_type.bag_location, % 存放的背包位置
    OlddefaultLocation =
        case is_record(OldGoodsInfo, goods) of
            true ->
                EtsGoods1 = data_goods_type:get(OldGoodsInfo#goods.goods_id),
                EtsGoods1#ets_goods_type.bag_location;
            false ->
                NewdefaultLocation  % 如果人物上没有装备
        end,
    CheckList = [
        {check_base, PS, GoodsInfo},
        {check_lv, GoodsInfo, PS#player_status.figure#figure.lv},
        {check_sex, GoodsInfo, PS#player_status.figure#figure.sex},
        {check_career, GoodsInfo, PS#player_status.figure#figure.career},
        {check_turn, GoodsInfo, PS#player_status.figure#figure.turn},
        {check_location, GoodsInfo, ?GOODS_LOC_DECORATION_BAG},
        {check_null_cells, GoodsStatus, OlddefaultLocation, NewdefaultLocation},
        {check_goods_type, GoodsInfo, ?GOODS_TYPE_DECORATION},
        {check_cell_unlock, PS#player_status.decoration#decoration.unlock_cell_list, Cell}
        % {check_goods_stage, Lv, GoodsInfo#goods.goods_id}     % 写法有问题，暂时废弃
    ],
    case checklist(CheckList) of
        true -> {true, GoodsInfo};
        {false, Res} -> {false, Res}
    end.

%% 检查卸装条件
unequip(GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    CheckList = [
        {check_exist, GoodsInfo},
        {check_null_cells, GoodsStatus, GoodsInfo#goods.goods_id},
        {check_location, GoodsInfo, ?GOODS_LOC_DECORATION}],
    case checklist(CheckList) of
        true -> {true, GoodsInfo};
        {false, Res} -> {false, Res}
    end.

%%  检查升阶条件
stage_up(PS, GoodsStatus, GoodsId) ->
    #player_status{figure = #figure{lv = PlayerLv}, decoration = #decoration{level_list = LevelList}} = PS,
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    Cell = GoodsInfo#goods.subtype,
    Level = case lists:keyfind(Cell, 1, LevelList) of
                false -> 0;  % 当没有数据，默认等级为0
                {Cell, TmpLevel} -> TmpLevel
            end,
    CheckList = [
        {check_exist, GoodsInfo},
        {check_lv, GoodsInfo, PS#player_status.figure#figure.lv},
        {check_null_cells, GoodsStatus, GoodsInfo#goods.goods_id},
        {check_location, GoodsInfo, ?GOODS_LOC_DECORATION},
        {check_stage_up, PlayerLv, Level, GoodsInfo},
        {check_stage_cost, PS, GoodsInfo}],
    case checklist(CheckList) of
        true -> {true, GoodsInfo};
        {false, Res} -> {false, Res}
    end.

%% 检查强化条件
stren(PS, GoodsStatus, Pos) ->
    Level = lib_decoration:get_dec_level(PS, Pos),
    Cfg = data_decoration:get_dec_level(Pos, Level),
    ?PRINT("Cfg:~p~n",[Cfg]),
    EquipInfo = lib_decoration:get_dec_by_location(PS, GoodsStatus, Pos),
    CheckList = [
        {check_config, Cfg, []},
        {check_equip_pos_correct, Pos},
        {check_has_equip, Pos, PS},
        {check_level_up, Level, EquipInfo},
        {check_level_cost, PS, Cfg}
    ],
    case checklist(CheckList) of
        true ->
            {true, EquipInfo, Level, Cfg};
        {false, Res} ->
            {false, Res}
    end.

%% 检查有没有配置
check({check_config, Cfg, MissDefault}) ->
    case Cfg of
        MissDefault -> {false, ?ERRCODE(err152_missing_cfg)};
        _ -> true
    end;


check({check_base, PS, GoodsInfo}) ->
    CheckList = [
        {check_exist, GoodsInfo},  % 检查物品是否存在
        {check_expire, GoodsInfo}, % 装备是否过了有效期
        {check_lv, GoodsInfo, PS#player_status.figure#figure.lv} % 检查等级限制
    ],
    checklist(CheckList);

% 检查物品是否存在
check({check_exist, GoodsInfo}) ->
    case is_record(GoodsInfo, goods) of
        true -> true;
        false -> {false, ?ERRCODE(err150_no_goods)}
    end;

%% 装备是否过了有效期
check({check_expire, GoodsInfo}) ->
    NowTime = utime:unixtime(),
    case GoodsInfo#goods.expire_time > 0 andalso
        GoodsInfo#goods.expire_time =< NowTime of
        true -> {false, ?ERRCODE(err152_expire_err)};
        false -> true
    end;

%% 检查等级限制
check({check_lv, GoodsInfo, Lv}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    case G#ets_goods_type.level =< Lv of
        true -> true;
        false -> {false, ?ERRCODE(err152_lv_err)}
    end;

%% 检查性别是否满足
check({check_sex, GoodsInfo, Sex}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.sex == 0 -> true;
        G#ets_goods_type.sex == Sex -> true;
        true -> {false, ?ERRCODE(err152_sex_error)}
    end;


%% 检查职业是否满足
check({check_career, GoodsInfo, Career}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.career == 0 -> true;
        G#ets_goods_type.career == Career -> true;
        true -> {false, ?ERRCODE(err152_career_error)}
    end;

%% 检查转职限制
check({check_turn, GoodsInfo, RoleTurn}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.turn == 0 -> true;
        G#ets_goods_type.turn =< RoleTurn -> true;
        true -> {false, ?ERRCODE(err152_turn_error)}
    end;

%% 检查物品所在位置
check({check_location, GoodsInfo, Loc}) ->
    case GoodsInfo#goods.location == Loc of
        true -> true;
        false -> {false, ?ERRCODE(err152_location_err)}
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
%% 根据物品默认的背包类型来去检查背包是否有位置	chenyiming-20180802
check({check_null_cells, GoodsStatus, GoodTypeId}) when is_record(GoodsStatus, goods_status) ->
    GoodsType = data_goods_type:get(GoodTypeId),
    Location = GoodsType#ets_goods_type.bag_location,
    HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, Location),
    if
        HaveCellNum < 1 ->
            {false, ?ERRCODE(err150_no_cell)};
        true -> true
    end;
check({check_null_cells, GoodsStatus}) when is_record(GoodsStatus, goods_status) ->
    HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_BAG),
    if
        HaveCellNum < 1 ->
            {false, ?ERRCODE(err150_no_cell)};
        true -> true
    end;

%% 检查物品类型
check({check_goods_type, GoodsInfo, Type}) ->
    case GoodsInfo#goods.type == Type of
        true -> true;
        false -> {false, ?ERRCODE(err152_type_err)}
    end;

%% 检查幻饰阶数上限
check({check_goods_stage, Lv, GoodsId}) ->
    case data_decoration:get_dec_attr(GoodsId) of
        #dec_attr_cfg{stage = Stage} ->
            LimitStage = data_decoration:get_dec_stage_max(Lv),
%%            ?PRINT("GoodsId,Stage,LimitStage:~w~n",[[GoodsId,Stage,LimitStage]]),
            case Stage > LimitStage of
                true -> {false, ?ERRCODE(err149_equip_stage_limit)};
                false -> true
            end;
        _ ->
            {false, ?ERRCODE(err149_err_dec)}
    end;

%% 检查升阶条件
check({check_stage_up, PlayerLv, Level, GoodsInfo}) ->
    DecStage = data_decoration:get_dec_stage(GoodsInfo#goods.goods_id),
    case is_record(DecStage, dec_stage_cfg) of
        true ->
            #dec_stage_cfg{new_goods_id = NewGoodsId} = DecStage,
            case NewGoodsId of
                0 ->    % 当为0 时阶数到上限
                    {false, ?ERRCODE(err149_stage_max)};
                _ ->
                    case check({check_level_up, Level, GoodsInfo}) of
                        {false, _} ->
                            check({check_goods_stage, PlayerLv, NewGoodsId});
                        true ->
                            {false, ?ERRCODE(err149_lev_not_enough)}
                    end
            end;
        false ->
            {false, ?ERRCODE(err149_stage_max)}
    end;

%% 检查升阶消耗
check({check_stage_cost, PS, GoodsInfo}) ->
    Cfg = data_decoration:get_dec_stage(GoodsInfo#goods.goods_id),
    case is_record(Cfg, dec_stage_cfg) of
        false ->
            {false,?MISSING_CONFIG };
        true ->
            check({check_object_cost, PS, Cfg#dec_stage_cfg.cost})
    end;

%% 检查是否强化到上限
check({check_level_up, Level, GoodsInfo}) ->
    Loc = GoodsInfo#goods.cell,
    Color = GoodsInfo#goods.color,
    DecStageAttr = data_decoration:get_dec_attr(GoodsInfo#goods.goods_id),
    case is_record(DecStageAttr, dec_attr_cfg) of
        false ->
            {false ,?MISSING_CONFIG};
        true ->
            DecLevMax = data_decoration:get_dec_level_max(Loc, DecStageAttr#dec_attr_cfg.stage, Color),
            case is_record(DecLevMax, dec_level_max_cfg)  of
                false ->
                    {false ,?MISSING_CONFIG};
                true ->
                    case Level >= DecLevMax#dec_level_max_cfg.limit_level  of
                        true -> {false, ?ERRCODE(err149_level_max)};
                        false -> true
                    end
            end
    end;


%% 检查是否有该装备位置
check({check_equip_pos_correct, EquipPos}) ->
    if  %% 装备位置参数错误
        EquipPos > ?DECORATION_CELL_NUM orelse EquipPos < 0 ->
            {false, ?ERRCODE(err152_equip_pos_err)};
        true -> true
    end;

%% 检查是否有该装备
check({check_has_equip, EquipPos, PS}) ->
    #player_status{decoration = Dec} = PS,
    #decoration{pos_goods = PosGoods} = Dec,
%%    ?PRINT("check_has_equip  EquipPos,LevelList :~w~n",[[EquipPos,PosGoods]]),
    case lists:keyfind(EquipPos, 1, PosGoods) of
        false -> {false, ?ERRCODE(err152_pos_no_equip)};
        {_Cell, _TmpLevel} -> true
    end;

%% 检查是否强化到上限
check({check_level_cost, PS, Cfg}) ->
    check({check_object_cost, PS, Cfg#dec_level_cfg.cost});

%% 检查消耗
check({check_object_cost, PS, ObjectList}) when ObjectList =/= [] ->
    case lib_goods_api:check_object_list(PS, ObjectList) of
        true -> true;
        {false, Res} -> {false, Res}
    end;

check({check_object_cost, _PS, _ObjectList}) ->
    {false, ?ERRCODE(err152_missing_cfg)};


check({check_base_config, BaseConfig, ConfigName}) ->
    case is_record(BaseConfig, ConfigName) of
        true -> true;
        false -> {false, ?ERRCODE(err_config)}
    end;

check({check_stren_lv, GoodsStatus, EquipPos}) ->
    #equip_stren{
        stren = Stren
    } = lib_equip:get_stren(GoodsStatus, EquipPos),
    case Stren == 0 of
        true -> true;
        false -> {false, ?ERRCODE(err152_has_stren_cant_unequip)}
    end;

check({check_has_wash_attr, GoodsStatus, EquipPos}) ->
    #equip_wash{
        attr = Attr
    } = lib_equip:get_wash_info_by_pos(GoodsStatus, EquipPos),
    case Attr == [] of
        true -> true;
        false -> {false, ?ERRCODE(err152_has_wash_cant_unequip)}
    end;

check({check_has_awakening, GoodsStatus, EquipPos}) ->
    #goods_status{
        equip_awakening_list = EquipAwakeningL
    } = GoodsStatus,
    case lists:keyfind(EquipPos, #equip_awakening.pos, EquipAwakeningL) of
        #equip_awakening{lv = Lv} when Lv > 0 ->
            {false, ?ERRCODE(err152_has_awakening_cant_unequip)};
        _ -> true
    end;

check({check_enough_money, PS, Num, MoneyType}) ->
    case lib_goods_util:is_enough_money(PS, Num, MoneyType) of
        false -> {false, ?ERRCODE(err150_no_money)};
        true -> true
    end;

check({check_cell_unlock, UnlockCellList, Cell}) ->
    case lists:member(Cell, UnlockCellList) of 
        true -> true;
        false -> {false, ?ERRCODE(err149_cell_lock_limit)}
    end;

check(X) ->
    ?INFO("equip_check error ~p~n", [X]),
    {false, ?FAIL}.

checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.