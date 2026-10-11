%%%--------------------------------------
%%% @Module  : pp_mount
%%% @Author  : xiaoxiang
%%% @Created : 2017.1.5
%%% @Description:  坐骑系统
%%%--------------------------------------
-module(pp_mount).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("sql_goods.hrl").

handle(Cmd, Player, Data) ->
    #player_status{figure = Figure, status_mount = StatusMount} = Player,
    case Data =/= [] of % 检查数据是否为空
        true ->
            [TypeId | _T] = Data,
            OpenLv = data_mount:get_constant_cfg(lib_mount:mapping_type_to_cfg_id(TypeId)),
            case lists:member(TypeId, ?APPERENCE) andalso Figure#figure.lv >= OpenLv of % 是否有外观种类 和 达到等级
                true ->
                    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount), % 是否有外观配置
                    case StatusType =/= false of
                        true ->
                            do_handle(Cmd, Player, Data, StatusType);
                        false ->
                            skip
                    end;
                false ->
                    skip
            end;
        false -> skip
    end.


%% -----------------    坐骑   -------------------------
%% 坐骑信息
do_handle(Cmd = 16002, #player_status{sid = Sid} = Player, [TypeId], _StatusType) ->
    LPlayer = #player_status{status_mount = StatusMount} = lib_mount:count_mount_attr(Player), %% 重新计算下真实战力
    NewStatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #status_mount{
        type_id = TypeId,
        stage = Stage, star = Star, blessing = Blessing,
        illusion_type = IllusionType, illusion_id = IllusionId,
        attr = Attr, skills = Skills, combat = Combat, etime = Etime,
        auto_buy = AutoBuy
    } = NewStatusType,
    FigureStage = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, IllusionId, 0), % 没有形象的阶级为 0
    NewAttr = lists:keydelete(?SPEED, 1, Attr),
    Args = [TypeId, Stage, Star, Blessing, FigureStage, Combat, Etime, AutoBuy, NewAttr, Skills],
    %Args = [TypeId, Stage, Star, Blessing, FigureStage, Combat, Attr, Skills],
    {ok, BinData} = pt_160:write(Cmd, Args),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LPlayer};

%% 幻化坐骑 pt_16003_[12,1,0,0]
do_handle(Cmd = 16003, Player, [TypeId, Type, Args, Color], StatusType)
    when is_integer(Args) andalso Type >= 1 andalso Type =< 2 ->
    #player_status{sid = Sid, status_mount = StatusMount, figure = Figure, id = RoleId} = Player,
    #figure{career = Career, mount_figure = MountFigure} = Figure,
    if
        Type =/= ?BASE_MOUNT_FIGURE andalso Type =/= ?ILLUSION_MOUNT_FIGURE -> % 没有形象
            LastPlayer = Player;
        true -> % 形象会有变化
            case lib_temple_awaken_api:check_and_unwear_model(Player, StatusType, Type, Args) of
                {ok, nodeal, NewPs} ->
                    NewStatusType = StatusType, FigureId = StatusType#status_mount.figure_id,
                    NewColor = StatusType#status_mount.illusion_color, ErrorCode = ?SUCCESS;
                {ok, NewPs} ->
                    case lib_mount:illusion_figure(TypeId, Type, Career, StatusType, Args, Color) of
                        {ok, NewStatusType, FigureId, NewColor} -> ErrorCode = ?SUCCESS;
                        {fail, ErrorCode} ->
                            NewStatusType = StatusType, FigureId = StatusType#status_mount.figure_id,
                            NewColor = StatusType#status_mount.illusion_color
                    end
            end,
            case TypeId =:= ?HOLYORGAN_ID andalso Args =:= 1 of
                % 穿戴神兵
                true -> {ok, TakeOffPS} = lib_fashion_api:take_off_other(holyorgan, NewPs);
                false -> TakeOffPS = NewPs
            end,
            IsSatisfy = ErrorCode == ?SUCCESS,
            case IsSatisfy of
                true ->
                    #status_mount{
                        illusion_id = IllusionId
                    } = NewStatusType,
                    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                    NewMountFigure = lists:keyreplace(TypeId, 1, MountFigure, {TypeId, FigureId, NewColor}),
                    NewFigure = Figure#figure{mount_figure = NewMountFigure},
                    Player1 = TakeOffPS#player_status{status_mount = NewStatusMount, figure = NewFigure},
                    NewPlayer = lib_mount:unequip_fashion(Player1, TypeId),
                    lib_common_rank_api:refresh_rank_by_upgrade(NewPlayer, TypeId),
                    %% 判断当前是否翅膀幻化,是的话脱背饰
                    {ok, LastPlayer} = lib_mount:judgeillusion(NewPlayer, TypeId),
                    lib_mount:event(figure_change, [LastPlayer, TypeId]),
                    {ok, BinData} = pt_160:write(Cmd, [?SUCCESS, TypeId, Type, IllusionId, NewColor]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    LastPlayer;
                _ ->
                    {ok, BinData} = pt_160:write(16000, [ErrorCode]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    LastPlayer = Player
            end
    end,
    {ok, LastPlayer};

%% 上下坐骑
%% Type: 0: 下坐骑 1: 上坐骑
do_handle(16004, Player, [TypeId, Type], StatusType) ->
    lib_mount:change_ride_status(TypeId, Player, Type, StatusType);

%% 一键升星（不包括坐骑和伙伴）
do_handle(16005, Player, [TypeId], StatusType) when TypeId =/= ?MOUNT_ID andalso TypeId =/= ?MATE_ID ->
    AllGoods = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_NORMAL),
    %%    ?PRINT("16005 TypeId:~p  AllGoods :~p~n", [TypeId, AllGoods]),
    LastPlayer = lib_mount:upgrade_star(TypeId, Player, AllGoods),
    % 旧
    #status_mount{stage = Stage, star = Star, blessing = Blessing} = StatusType,
    % 新
    #player_status{status_mount = NewStatusMount} = LastPlayer,
    #status_mount{stage = NewStage, star = NewStar, blessing = NewBlessing} = 
        lists:keyfind(TypeId, #status_mount.type_id, NewStatusMount),
    case {Stage, Star, Blessing} =/= {NewStage, NewStar, NewBlessing} of
        true ->
            {ok, BinData} = pt_160:write(16005, [?SUCCESS, TypeId, NewStage, NewStar, NewBlessing, 0, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false -> 
            skip
    end,
    if
        TypeId == ?PET_ID ->
            lib_rush_rank_api:reflash_rank_by_aircraft_rush(LastPlayer);
        true ->
            ok
    end,
    {ok, battle_attr, LastPlayer};

%% 幻形界面信息
do_handle(Cmd = 16006, Player, [TypeId], StatusType) ->
    #player_status{sid = Sid} = Player,
    #status_mount{
        type_id = TypeId,
        illusion_type = IllusionType,
        illusion_id = IllusionId,
        illusion_color = IllusionColor,
        figure_list = FigureList
    } = StatusType,
    {SelFigureId, ColorId} = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, {0, 0}, {IllusionId, IllusionColor}),
    List = [{Id, Stage, Star, EndTime} || #mount_figure{id = Id, stage = Stage, star = Star, end_time = EndTime} <- FigureList],
       % ?PRINT("16006 TypeId, SelFigureId, List :~w~n FigureList:~p~n",[[TypeId, SelFigureId, List], FigureList]),
    {ok, BinData} = pt_160:write(Cmd, [?SUCCESS, TypeId, SelFigureId, ColorId, List]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 幻形形象详细信息
do_handle(Cmd = 16007, Player, [TypeId, Id], StatusType) ->
    #player_status{id = PlayerId, original_attr = OriginAttr} = Player,
    #status_mount{figure_list = FigureList} = StatusType,
    case lists:keyfind(Id, #mount_figure.id, FigureList) of
        #mount_figure{stage = Stage, star = BaseStar, blessing = Blessing, end_time = EndTime,
        skills = _Skills, color_list = ColorList} ->
            Star = ?IF(lists:member(TypeId, [?MOUNT_ID, ?MATE_ID]), BaseStar, Stage),
            FStarAttr = lib_mount:calc_mount_star_attr(TypeId, Id, Star),
            StarCombat = lib_player:calc_partial_power(Player, OriginAttr, 0, FStarAttr),
            NextStarAttrL = lib_mount:calc_mount_star_attr(TypeId, Id, Star + 1),
            case NextStarAttrL of
                [] ->
                    NextStarCombat = 0;
                _ ->
                    NextStarCombat = lib_player:calc_expact_power(Player, OriginAttr, 0, ulists:kv_list_minus_extra(NextStarAttrL, FStarAttr)) + StarCombat
            end,
            {_, Attr, UnlockList, Combat} = lib_mount:count_figure_attr_origin_combat(TypeId, Id, Stage, BaseStar, ColorList, OriginAttr),
            {ok, BinData} = pt_160:write(Cmd, [?SUCCESS, TypeId, Id, Stage, Star, Blessing, Combat, StarCombat, EndTime, Attr, UnlockList, ColorList, NextStarCombat]),
            lib_server_send:send_to_uid(PlayerId, BinData);
        _ -> 
            skip   %% 未激活不处理
    end;

%% 激活形象
do_handle(_Cmd = 16008, Player, [TypeId, Id], StatusType) ->
    %%    ?PRINT("16008 TypeId, Id :~w~n", [[TypeId, Id]]),
    lib_mount:active_figure(Player, TypeId, Id, StatusType);

%% 幻形升阶
do_handle(_Cmd = 16009, Player, [TypeId, Id, GoodsId], StatusType) ->
    case lists:member(TypeId, [?MOUNT_ID, ?MATE_ID]) of
        true -> %  坐骑伙伴特殊处理
            lib_mount:figure_upgrade_stage_sp(Player, TypeId, Id, StatusType, GoodsId);
        false ->
            lib_mount:figure_upgrade_stage(Player, TypeId, Id, StatusType)
    end;

%% 使用魔晶
do_handle(Cmd = 16010, Player, [TypeId, GTypeId], StatusType) ->
    {ErrorCode, NewPlayer} =
        case lib_mount:use_goods(Player, TypeId, GTypeId, StatusType) of
            {ok, ErrorCode1, NewPlayer1} -> {ErrorCode1, NewPlayer1};
            {fail, ErrorCode2, NewPlayer2} -> {ErrorCode2, NewPlayer2}
        end,
    {ok, BinData} = pt_160:write(Cmd, [ErrorCode, TypeId, GTypeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, battle_attr, NewPlayer};

%% 魔晶使用次数
do_handle(Cmd = 16011, Player, [TypeId], _StatusType) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    GTypeIds = data_mount:get_goods_ids(TypeId),
    CounterList = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeIds),
    F = fun(GTypeId) ->
        Times =
            case lists:keyfind(GTypeId, 1, CounterList) of
                {GTypeId, Ts} -> Ts;
                _ -> 0
            end,
        MaxTimes =
            case data_mount:get_goods_cfg(TypeId, GTypeId) of
                #mount_goods_cfg{max_times = MaxTimesL} ->
                    lib_mount:get_goods_max_times(MaxTimesL, RoleLv);
                _ -> 0
            end,
        {GTypeId, Times, MaxTimes}
        end,
    TimesL = lists:map(F, GTypeIds),
    {ok, BinData} = pt_160:write(Cmd, [TypeId, TimesL]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 技能属性战力显示
do_handle(Cmd = 16013, #player_status{sid = Sid}, [TypeId, SkillId], _StatusType) ->
    OldAttrList = lib_mount:get_passive_skill_attr([{SkillId, 1}]),
    AttrList = lib_mount:count_skill_attr_with_mod_id(TypeId, [SkillId]),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList ++ OldAttrList),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    {ok, BinData} = pt_160:write(Cmd, [SkillId, NewCombat]),
    lib_server_send:send_to_sid(Sid, BinData);





%% 打开坐骑、伙伴装备
do_handle(16014, Ps, [TypeId], StatusType) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    case lists:member(TypeId, ?FIGURE_EQUIP) of
        false -> skip;
        true ->
            case Lv >= ?NEW_MOUNT_OPEN_LV of
                false ->
                    Code = ?LEVEL_LIMIT,
                    CombatPower = 0,
                    SendList = [];
                true ->
                    Code = ?SUCCESS,
                    GoodsStatus = lib_goods_do:get_goods_status(),
                    % 坐骑装备列表
                    EquipPosList =
                        case TypeId of
                            ?MOUNT_ID ->
                                GoodsStatus#goods_status.mount_equip_pos_list;
                            ?MATE_ID ->
                                GoodsStatus#goods_status.mate_equip_pos_list
                        end,
                    %%                   ?PRINT("EquipPosList :~p~n", [EquipPosList]),
                    #status_mount{figure_equip = FigureEquip} = StatusType,
                    #figure_equip{equip_attr = EquipAttrList} = FigureEquip,
                    % 获取物品
                    GS = lib_goods_do:get_goods_status(),
                    #goods_status{dict = Dict} = GS,
                    % 取装备位置上的物品
                    EquipWearList =
                        case TypeId of
                            ?MOUNT_ID ->
                                lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict);
                            ?MATE_ID ->
                                lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MATE_EQUIP, Dict)
                        end,
                    EquipAttr = lib_player_attr:to_attr_record(EquipAttrList),
                    CombatPower = lib_player:calc_all_power(EquipAttr), % 计算战力
                    PosList = data_pet_equip:get_pet_equip_pos_list(TypeId),
                    F = fun(Pos, SendList1) ->
                        case lists:keyfind(Pos, #goods.cell, EquipWearList) of
                            false -> SendList1;
                            GoodsInfo ->
                                #goods{
                                    id = GoodsId,
                                    goods_id = GoodsTypeId,
                                    other = #goods_other{optional_data = OptionalData}
                                } = GoodsInfo,
                                case OptionalData of
                                    [_, PEStage, PEStar] -> skip;
                                    _ -> 
                                        case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                                            #pet_equip_goods_con{stage = PEStage, star = PEStar} -> skip;
                                            _ ->  PEStage = 0, PEStar = 0
                                        end
                                end,
                                case lists:keyfind(Pos, #figure_equip_pos.pos, EquipPosList) of
                                    false ->
                                        PosLv = 0,
                                        PosPoint = 0;
                                    #figure_equip_pos{equip_point = AllPosPoint} ->
                                        {PosLv, PosPoint} = lib_mount_equip:get_figure_equip_pos_lv(AllPosPoint, Pos, PEStage, TypeId)
                                end,
                                [{Pos, PosLv, PEStage, PEStar, PosPoint, GoodsId, GoodsTypeId} | SendList1]
                        end
                        end,
                    SendList = lists:foldl(F, [], PosList)
            end,
            %%           ?PRINT("16014 TypeId, Code, SendList :~w~n", [[TypeId, Code, SendList]]),
            {ok, BinData} = pt_160:write(16014, [TypeId, Code, CombatPower, SendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end;

%% 精灵装备镶嵌
do_handle(16015, Ps, [TypeId, Pos, GoodsId], StatusType) ->
    %%    ?PRINT("16015 TypeId, Pos, GoodsId :~w~n", [[TypeId, Pos, GoodsId]]),
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = GS,
    GoodsLoc =
        case TypeId of
            ?MOUNT_ID ->
                ?GOODS_LOC_MOUNT_EQUIP_BAG;
            ?MATE_ID ->
                ?GOODS_LOC_MATE_EQUIP_BAG
        end,
    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, GoodsLoc, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipBagList),
    PosList = data_pet_equip:get_pet_equip_pos_list(TypeId),
    IfPos = lists:member(Pos, PosList),
    if
        Lv < ?NEW_MOUNT_OPEN_LV -> % 等级限制
            Code = ?LEVEL_LIMIT,
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo =:= false -> % 不是该装备
            Code = ?ERRCODE(err160_equip_not),
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        IfPos =:= false -> % 没有该部位
            Code = ?ERRCODE(err160_equip_not_pos),
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                subtype = SubType,
                location = OriginalLocation,
                cell = OriginalCell
            } = GoodsInfo,
            PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
            IfPetEquip = lists:member(GoodsTypeId, PEGoodsTypeIdList),
            if
                IfPetEquip =:= false -> % 不是装备
                    Code = ?ERRCODE(err160_equip_not),
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps;
                SubType =/= Pos -> % 不是对应的装备位置
                    Code = ?ERRCODE(err160_equip_not_right_pos),
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps;
                true ->
                    case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                        [] -> % 没有装备配置
                            Code = ?MISSING_CONFIG,
                            NewGoodsId = 0,
                            OldGoodsId = 0,
                            NewGoodsTypeId = 0,
                            NewPs = Ps;
                        #pet_equip_goods_con{player_lv_limit = PlayerLvLimit, pet_stage_limit = PetStagelimit} ->
                            #status_mount{stage = PetStage} = StatusType,
                            case Lv >= PlayerLvLimit andalso PetStage >= PetStagelimit of
                                false -> % 没有达到装备要求
                                    Code = ?ERRCODE(err160_equip_not_wear_con),
                                    NewGoodsId = 0,
                                    OldGoodsId = 0,
                                    NewGoodsTypeId = 0,
                                    NewPs = Ps;
                                true ->
                                    F = fun() ->
                                        ok = lib_goods_dict:start_dict(),
                                        GoodLocal =
                                            case TypeId of
                                                ?MOUNT_ID -> ?GOODS_LOC_MOUNT_EQUIP;
                                                ?MATE_ID -> ?GOODS_LOC_MATE_EQUIP
                                            end,
                                        OldGoodsInfo = lib_goods_util:get_goods_by_cell(RoleId, GoodLocal, Pos, Dict),
                                        case is_record(OldGoodsInfo, goods) of
                                            true ->
                                                [NewOldGoodsInfo, GS1] = lib_goods:change_goods_cell_and_use(OldGoodsInfo, OriginalLocation, OriginalCell, GS),
                                                [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, GoodLocal, Pos, GS1),
                                                OldGoodsId = NewOldGoodsInfo#goods.id;
                                            false ->
                                                OldGoodsId = 0,
                                                [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, GoodLocal, Pos, GS)
                                        end,
                                        #goods_status{dict = OldGoodsDict} = NewGS1,
                                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                        NewGS = NewGS1#goods_status{dict = NewGoodsDict},
                                        {NewGS, NewGoodsInfo, OldGoodsId, GoodsL}
                                        end,
                                    case lib_goods_util:transaction(F) of
                                        {NewGS, NewGoodsInfo, OldGoodsId, GoodsL} ->
                                            Code = ?SUCCESS,
                                            #goods{id = NewGoodsId, goods_id = NewGoodsTypeId} = NewGoodsInfo,
                                            lib_goods_do:set_goods_status(NewGS),
                                            % 获取装备
                                            NewPs1 = lib_mount_equip:get_pet_equip(StatusType, Ps, NewGS, TypeId),
                                            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                                            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                            lib_supreme_vip_api:mount_equip_event(RoleId, TypeId),
                                            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                                            %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                            lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [GoodsInfo#goods{num = 0}]);
                                        Error ->
                                            ?ERR("pet_equip error:~p", [Error]),
                                            Code = ?FAIL,
                                            NewGoodsId = 0,
                                            OldGoodsId = 0,
                                            NewGoodsTypeId = 0,
                                            NewPs = Ps
                                    end
                            end
                    end
            end
    end,
    %%    ?PRINT("16015 [Code, Pos, NewGoodsId, OldGoodsId, NewGoodsTypeId] : ~w~n", [[Code, Pos, NewGoodsId, OldGoodsId, NewGoodsTypeId]]),
    CombatPower = lib_mount_equip:get_figure_power(RoleId, TypeId),
    {ok, BinData} = pt_160:write(16015, [TypeId, Code, Pos, NewGoodsId, OldGoodsId, NewGoodsTypeId, CombatPower]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 精灵装备强化
do_handle(16016, Ps, [TypeId, GoodsId, CostList], StatusType) ->
    %%    ?PRINT("16016 [TypeId, GoodsId, CostList]:~p~n", [[TypeId, GoodsId, CostList]]),
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict, mount_equip_pos_list = MountEquipPosList, mate_equip_pos_list = MateEquipPosList} = GS,
    {PetEquipWearList, GoodsLoc, EquipPosList} =
        case TypeId of
            ?MOUNT_ID ->
                EqWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
                {EqWearList, ?GOODS_LOC_MOUNT_EQUIP_BAG, MountEquipPosList};
            ?MATE_ID ->
                EqWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MATE_EQUIP, Dict),
                {EqWearList, ?GOODS_LOC_MATE_EQUIP_BAG, MateEquipPosList}
        end,
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipWearList),
    if
        Lv < ?NEW_MOUNT_OPEN_LV -> % 等级不足
            Code = ?LEVEL_LIMIT,
            %%            NewAllPoint = 0,
            NewPosPoint = 0,
            NewPosLv = 0,
            NewPs = Ps;
        GoodsInfo =:= false -> % 不是外形装备
            Code = ?ERRCODE(err160_equip_not),
            %%            NewAllPoint = 0,
            NewPosPoint = 0,
            NewPosLv = 0,
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                cell = Pos,
                other = #goods_other{optional_data = [_GoodsOther, PEStage, _PEStar]}
            } = GoodsInfo,
            AllPoint =
                case lists:keyfind(Pos, #figure_equip_pos.pos, EquipPosList) of
                    false -> 0;
                    #figure_equip_pos{equip_point = APoint} -> APoint
                end,
            {OldPosLv, PosPoint, IfMax} = lib_mount_equip:get_pet_equip_pos_lv(AllPoint, Pos, PEStage, TypeId),
            #pet_equip_stage_con{limit_pos_lv = LimitPosLv} = data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage),
            NowLimitPoint = lib_mount_equip:get_now_point(0, LimitPosLv - 1, Pos, 0, TypeId),
            case IfMax of
                0 -> % 没有满级
                    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, GoodsLoc, Dict),
                    PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
                    {CostGoodsList, AddPoint} = lib_mount_equip:get_pos_lv_upgrade_cost_list(CostList, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, [], 0, TypeId, Pos, PEStage),
                    %%                    ?PRINT("CostGoodsList:~p~n",[CostGoodsList]),
                    case CostGoodsList of
                        [] -> % 消耗品不正确
                            Code = ?ERRCODE(err165_pet_equip_not_right_cost),
                            %%                            NewAllPoint = PosPoint,
                            NewPosPoint = PosPoint,
                            NewPosLv = OldPosLv,
                            NewPs = Ps;
                        _ ->
                            GS = lib_goods_do:get_goods_status(),
                            F = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                {ok, NewGS1} = lib_goods:delete_goods_list(GS, CostGoodsList),
                                #goods_status{dict = OldGoodsDict} = NewGS1,
                                {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                NewAllPoint = AllPoint + AddPoint,
                                NewPetEquipPosInfo = #figure_equip_pos{
                                    pos = Pos,
                                    equip_point = NewAllPoint
                                },
                                ReSql = io_lib:format(?sql_figure_equip_pos_replace, [RoleId, TypeId, Pos, NewAllPoint]),
                                db:execute(ReSql),
                                NewPetEquipPosList = lists:keystore(Pos, #figure_equip_pos.pos, EquipPosList, NewPetEquipPosInfo),
                                NewGS = case TypeId of
                                            ?MOUNT_ID ->
                                                NewGS1#goods_status{
                                                    dict = NewGoodsDict,
                                                    mount_equip_pos_list = NewPetEquipPosList
                                                };
                                            ?MATE_ID ->
                                                NewGS1#goods_status{
                                                    dict = NewGoodsDict,
                                                    mate_equip_pos_list = NewPetEquipPosList
                                                }
                                        end,
                                {ok, NewGS, GoodsL, NewAllPoint}
                                end,
                            case lib_goods_util:transaction(F) of
                                {ok, NewGS, GoodsL, NewAllPoint} ->
                                    Code = ?SUCCESS,
                                    lib_goods_do:set_goods_status(NewGS),
                                    NewPs2 = lib_mount_equip:get_pet_equip(StatusType, Ps, NewGS, TypeId),
                                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs2),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                                    {NewPosLv, NewPosPoint} = lib_mount_equip:get_figure_equip_pos_lv(NewAllPoint, Pos, PEStage, TypeId),
                                    CostLogList = [begin
                                                       #goods{type = GoodsTypeLog, goods_id = GoodsTypeIdLog} = GoodsInfoLog,
                                                       {GoodsTypeLog, GoodsTypeIdLog, GoodsNumLog}
                                                   end || {GoodsInfoLog, GoodsNumLog} <- CostGoodsList],
                                    SCostLogList = util:term_to_string(CostLogList),
                                    %%                                    ?PRINT("16016  TypeId ~p, Pos ~p, GoodsTypeId ~p, OldPosLv ~p, AllPoint ~p, NewPosLv ~p, NewPosPoint ~p, SCostLogList: ~p~n",[TypeId, Pos, GoodsTypeId, OldPosLv, AllPoint, NewPosLv, NewPosPoint, SCostLogList]),
                                    lib_log_api:log_pet_equip_pos_upgrade(RoleId, TypeId, Pos, GoodsTypeId, OldPosLv, AllPoint, NewPosLv, NewPosPoint, SCostLogList);
                                Error ->
                                    ?ERR("pet_equip error:~p", [Error]),
                                    %%                                    NewAllPoint = PosPoint,
                                    NewPosPoint = PosPoint,
                                    NewPosLv = OldPosLv,
                                    Code = ?FAIL,
                                    NewPs = Ps
                            end
                    end;
                _ ->
                    Code = ?ERRCODE(err165_pet_equip_lv_max),
                    %%                    NewAllPoint = PosPoint,
                    NewPosPoint = PosPoint,
                    NewPosLv = OldPosLv,
                    NewPs = Ps
            end
    end,
    CombatPower = lib_mount_equip:get_figure_power(RoleId, TypeId),
    %%    ?PRINT("16016 TypeId, Code, NewPosPoint, NewPosLv, GoodsId :~w~n", [[TypeId, Code, NewPosPoint, NewPosLv, GoodsId]]),
    {ok, BinData} = pt_160:write(16016, [TypeId, Code, NewPosPoint, NewPosLv, GoodsId, CombatPower]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%% 精灵装备打磨
do_handle(16017, Ps, [TypeId, GoodsId, CostGoodsId], StatusType) ->
    ?PRINT("16017 :~p~n", [TypeId]),
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = GS,
    {PetEquipPosList, GoodLocEquip, GoodsOtherKey, GoodsLocBag} =
        case TypeId of
            ?MOUNT_ID ->
                EPosList = GS#goods_status.mount_equip_pos_list,
                GdLocEquip = ?GOODS_LOC_MOUNT_EQUIP,
                GdsOther = ?GOODS_OTHER_KEY_MOUNT_EQUIP,
                {EPosList, GdLocEquip, GdsOther, ?GOODS_LOC_MOUNT_EQUIP_BAG};
            _ ->
                EPosList = GS#goods_status.mate_equip_pos_list,
                GdLocEquip = ?GOODS_LOC_MATE_EQUIP,
                GdsOther = ?GOODS_OTHER_KEY_MATE_EQUIP,
                {EPosList, GdLocEquip, GdsOther, ?GOODS_LOC_MATE_EQUIP_BAG}
        end,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, GoodLocEquip, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, PetEquipWearList),
    PetEquipBagList = lib_goods_util:get_goods_list(RoleId, GoodsLocBag, Dict),
    CostGoodsInfo = lists:keyfind(CostGoodsId, #goods.id, PetEquipBagList),
    if
        Lv < ?NEW_MOUNT_OPEN_LV ->
            Code = ?LEVEL_LIMIT,
            NewPEStage = 0,
            NewPEStar = 0,
            NewPosLv = 0,
            NewPosPoint = 0,
            NewPs = Ps;
        GoodsInfo =:= false ->
            Code = ?ERRCODE(err160_equip_not),
            NewPEStage = 0,
            NewPEStar = 0,
            NewPosLv = 0,
            NewPosPoint = 0,
            NewPs = Ps;
        CostGoodsInfo =:= false ->
            Code = ?ERRCODE(err165_pet_equip_cost_not),
            NewPEStage = 0,
            NewPEStar = 0,
            NewPosLv = 0,
            NewPosPoint = 0,
            NewPs = Ps;
        true ->
            #goods{
                goods_id = GoodsTypeId,
                cell = Pos,
                other = GoodsOther1
            } = GoodsInfo,
            #goods_other{
                optional_data = [_GOODS_OTHER, PEStage, PEStar]
            } = GoodsOther1,
            #goods{
                goods_id = CostGoodsTypeId,
                other = CostOther,
                num = CostGoodsNum
            } = CostGoodsInfo,
            AllPoint =
                case lists:keyfind(Pos, #figure_equip_pos.pos, PetEquipPosList) of
                    false -> 0;
                    #figure_equip_pos{equip_point = APoint} -> APoint
                end,
            {OldPosLv, _PosPoint, _IfMax} = lib_mount_equip:get_pet_equip_pos_lv(AllPoint, Pos, PEStage, TypeId),
            PEGoodsTypeIdList = data_pet_equip:get_pet_equip_goods_list(),
            case lists:member(CostGoodsTypeId, PEGoodsTypeIdList) of
                false -> %% 升阶 升星
                    #pet_equip_stage_con{cost_list = [{_GoodsType, StageGoodsTypeId, _GoodsNum} | _]} =
                        data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, 1),
                    Code1 =
                        case CostGoodsTypeId of
                            StageGoodsTypeId -> 1;
                            _ ->
                                #pet_equip_star_con{cost_list = [{_GoodsType, StarGoodsTypeId, _GoodsNum} | _]} =
                                    data_pet_equip:get_pet_equip_star_con(TypeId, Pos, 1),
                                case CostGoodsTypeId of
                                    StarGoodsTypeId -> 2;
                                    _ -> 0
                                end
                        end,
                    PEStageConList = data_pet_equip:get_pet_equip_stage_list(TypeId, Pos),
                    PEStageMax = lists:max(PEStageConList),
                    PEStarConList = data_pet_equip:get_pet_equip_star_list(TypeId, Pos),
                    PEStarMax = lists:max(PEStarConList),
                    if
                        Code1 =:= 0 ->
                            Code = ?MISSING_CONFIG,
                            NewPEStage = 0,
                            NewPEStar = 0,
                            NewPosLv = 0,
                            NewPosPoint = 0,
                            NewPs = Ps;
                        PEStage >= PEStageMax andalso Code1 =:= 1 -> % 阶级满了
                            Code = ?ERRCODE(err165_pet_equip_stage_max),
                            NewPEStage = 0,
                            NewPEStar = 0,
                            NewPosLv = 0,
                            NewPosPoint = 0,
                            NewPs = Ps;
                        PEStar >= PEStarMax andalso Code1 =:= 2 -> % 星数满了
                            Code = ?ERRCODE(err165_pet_equip_star_max),
                            NewPEStage = 0,
                            NewPEStar = 0,
                            NewPosLv = 0,
                            NewPosPoint = 0,
                            NewPs = Ps;
                        true ->
                            CostNum =
                                case Code1 of
                                    1 ->
                                        lib_mount_equip:get_cost_num_stage_star(PEStage, PEStageMax, Pos, CostGoodsNum, 1, 0, TypeId);
                                    _ ->
                                        lib_mount_equip:get_cost_num_stage_star(PEStar, PEStarMax, Pos, CostGoodsNum, 2, 0, TypeId)
                                end,
                            F1 = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                {ok, NewGS1, _NewNum} = lib_goods:delete_one(GS, CostGoodsInfo, CostNum),
                                case Code1 of
                                    1 ->
                                        NewPEStage = PEStage + CostNum,
                                        NewPEStar = PEStar;
                                    _ ->
                                        NewPEStage = PEStage,
                                        NewPEStar = PEStar + CostNum
                                end,
                                #pet_equip_stage_con{color = NewColor} =
                                    data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, NewPEStage),
                                NewRating = lib_mount_equip:cal_figure_equip_rating(Pos, [GoodsOtherKey, NewPEStage, NewPEStar], TypeId),

                                NewGoodsInfo = GoodsInfo#goods{
                                    color = NewColor,
                                    other = GoodsOther1#goods_other{
                                        rating = NewRating,
                                        optional_data = [GoodsOtherKey, NewPEStage, NewPEStar]
                                    }
                                },
                                ReSqlC = io_lib:format(?SQL_GOODS_UPDATE_GOODS2, [GoodsTypeId, NewColor, GoodsId]),
                                db:execute(ReSqlC),
                                lib_mount_equip:change_goods_other(NewGoodsInfo),
                                Dict1 = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, NewGS1#goods_status.dict),
                                {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(Dict1),
                                NewGS = NewGS1#goods_status{dict = NewGoodsDict},
                                {ok, NewGS, GoodsL, NewPEStage, NewPEStar}
                                 end,
                            case lib_goods_util:transaction(F1) of
                                {ok, NewGS, GoodsL, NewPEStage, NewPEStar} ->
                                    Code = ?SUCCESS,
                                    lib_goods_do:set_goods_status(NewGS),
                                    NewPs1 = lib_mount_equip:get_pet_equip(StatusType, Ps, NewGS, TypeId),
                                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                    lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                                    %%   lib_goods_api:notify_client_num(RoleId, [CostGoodsInfo#goods{num = max(0, (CostGoodsNum-CostNum))}]),
                                    {NewPosLv, NewPosPoint} = lib_mount_equip:get_figure_equip_pos_lv(AllPoint, Pos, NewPEStage, TypeId),
                                    lib_log_api:log_pet_equip_goods_upgrade(RoleId, TypeId, Pos, GoodsTypeId, CostGoodsTypeId, PEStage, PEStar, OldPosLv, AllPoint, NewPEStage, NewPEStar, NewPosLv, AllPoint);
                                Error ->
                                    ?ERR("pet_equip error:~p", [Error]),
                                    Code = ?FAIL,
                                    NewPEStage = 0,
                                    NewPEStar = 0,
                                    NewPs = Ps,
                                    NewPosLv = 0,
                                    NewPosPoint = 0
                            end
                    end;
                true -> %% 吞噬
                    #goods_other{optional_data = [_GoodsOther, CostPEStage, CostPEStar]} = CostOther,
                    F2 = fun() ->
                        {ok, NewGS1, _NewNum} = lib_goods:delete_one(GS, CostGoodsInfo, CostGoodsInfo#goods.num),
                        case PEStage >= CostPEStage of
                            true ->
                                NewPEStage = PEStage,
                                AddPEStage = CostPEStage;
                            false ->
                                NewPEStage = CostPEStage,
                                AddPEStage = PEStage
                        end,
                        case PEStar >= CostPEStar of
                            true ->
                                NewPEStar = PEStar,
                                AddPEStar = CostPEStar;
                            false ->
                                NewPEStar = CostPEStar,
                                AddPEStar = PEStar
                        end,
                        #pet_equip_stage_con{exp = AddExpStage} =
                            data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, AddPEStage),
                        #pet_equip_star_con{exp = AddExpStar} =
                            data_pet_equip:get_pet_equip_star_con(TypeId, Pos, AddPEStar),
                        AddPoint = AddExpStage + AddExpStar,
                        #pet_equip_stage_con{color = NewColor} =
                            data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, NewPEStage),
                        ReSqlC = io_lib:format(?SQL_GOODS_UPDATE_GOODS2, [GoodsTypeId, NewColor, GoodsId]),
                        db:execute(ReSqlC),
                        NewRating = lib_mount_equip:cal_figure_equip_rating(Pos, [GoodsOtherKey, NewPEStage, NewPEStar], TypeId),
                        NewGoodsInfo = GoodsInfo#goods{
                            color = NewColor,
                            other = GoodsOther1#goods_other{
                                rating = NewRating,
                                optional_data = [GoodsOtherKey, NewPEStage, NewPEStar]
                            }
                        },
                        lib_mount_equip:change_goods_other(NewGoodsInfo),
                        Dict1 = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, NewGS1#goods_status.dict),
                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(Dict1),
                        NewAllPoint = AllPoint + AddPoint,
                        NewPetEquipPosInfo = #figure_equip_pos{
                            pos = Pos,
                            equip_point = NewAllPoint
                        },
                        ReSql = io_lib:format(?sql_figure_equip_pos_replace, [RoleId, TypeId, Pos, NewAllPoint]),
                        db:execute(ReSql),
                        NewPetEquipPosList = lists:keystore(Pos, #figure_equip_pos.pos, PetEquipPosList, NewPetEquipPosInfo),
                        NewGS =
                            case TypeId of
                                ?MOUNT_ID ->
                                    NewGS1#goods_status{dict = NewGoodsDict, mount_equip_pos_list = NewPetEquipPosList};
                                ?MATE_ID ->
                                    NewGS1#goods_status{dict = NewGoodsDict, mate_equip_pos_list = NewPetEquipPosList}
                            end,
                        {ok, NewGS, GoodsL, NewPEStage, NewPEStar, NewAllPoint}
                         end,
                    case lib_goods_util:transaction(F2) of
                        {ok, NewGS, GoodsL, NewPEStage, NewPEStar, NewAllPoint} ->
                            Code = ?SUCCESS,
                            lib_goods_do:set_goods_status(NewGS),
                            NewPs2 = lib_mount_equip:get_pet_equip(StatusType, Ps, NewGS, TypeId),
                            NewPs3 = lib_mount_equip:get_pet_equip(StatusType, NewPs2, NewGS, TypeId),
                            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs3),
                            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
                            lib_goods_api:notify_client_num(RoleId, [CostGoodsInfo#goods{num = 0}]),
                            {NewPosLv, NewPosPoint} = lib_mount_equip:get_figure_equip_pos_lv(NewAllPoint, Pos, NewPEStage, TypeId),
                            lib_log_api:log_pet_equip_goods_upgrade(RoleId, TypeId, Pos, GoodsTypeId, CostGoodsTypeId, PEStage, PEStar, OldPosLv, AllPoint, NewPEStage, NewPEStar, NewPosLv, NewAllPoint);
                        Error ->
                            ?ERR("pet_equip error:~p", [Error]),
                            Code = ?FAIL,
                            NewPEStage = 0,
                            NewPEStar = 0,
                            NewPs = Ps,
                            NewPosLv = 0,
                            NewPosPoint = 0
                    end
            end
    end,
    CombatPower = lib_mount_equip:get_figure_power(RoleId, TypeId),
    {ok, BinData} = pt_160:write(16017, [TypeId, Code, NewPEStage, NewPEStar, GoodsId, CostGoodsId, CombatPower, NewPosPoint, NewPosLv]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};



%%   外形吞噬
do_handle(Cmd = 16018, #player_status{sid = Sid, status_mount = StatuMount} = Player, [TypeId, GoodsList], StatusType) ->
    case lib_mount_devour:check_devour(StatusType) of %% 检查吞噬的条件
        true ->
            GS = lib_goods_do:get_goods_status(),
            {ErrCode, NewPlayer} =
                case lib_mount_devour:add_devour(TypeId, GoodsList, StatusType, Player, GS) of
                    {ok, NewGS, UpdateGoodsList, NewStatusType, IsUpgrade} ->
                        lib_goods_api:notify_client(Player, UpdateGoodsList),
                        lib_goods_do:set_goods_status(NewGS),
                        NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatuMount, NewStatusType),
                        NewPs = Player#player_status{status_mount = NewStatusMount},
                        case IsUpgrade of
                            true ->
                                NewPs1 = lib_mount:count_mount_attr(NewPs),
                                NewPs2 = lib_player:count_player_attribute(NewPs1),
                                lib_player:send_attribute_change_notify(NewPs2, ?NOTIFY_ATTR),
                                %% 更新场景玩家属性
                                mod_scene_agent:update(NewPs2, [{battle_attr, NewPs2#player_status.battle_attr}]),
                                {?SUCCESS, NewPs2};
                            _ -> {?SUCCESS, NewPs}
                        end;
                    {false, Code} ->
                        {Code, Player}
                end,
            {NewLv, NewExp} = lib_mount_devour:get_devour_lv_exp(TypeId, NewPlayer),
            {ok, BinData} = pt_160:write(Cmd, [ErrCode, TypeId, NewLv, NewExp]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, battle_attr, NewPlayer};
        {false, ErrCode} ->
            {ok, BinData} = pt_160:write(Cmd, [ErrCode, TypeId, StatusType#status_mount.devour_lv, StatusType#status_mount.devour_exp]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, Player}
    end;


%%   吞噬信息
do_handle(Cmd = 16019, #player_status{sid = Sid}, [TypeId], StatusType) ->
    #status_mount{devour_exp = Exp, devour_lv = Lv} = StatusType,
    {ok, BinData} = pt_160:write(Cmd, [?SUCCESS, TypeId, Lv, Exp]),
    lib_server_send:send_to_sid(Sid, BinData);



%% 幻形升级
do_handle(_Cmd = 16020, Player, [TypeId, Id], StatusType) ->
    lib_mount:figure_upgrade_star(Player, TypeId, Id, StatusType);


%% 法阵广播
do_handle(_Cmd = 16021, Player, [TypeId], _StatusType) ->
    #player_status{id = RoleId, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId} = Player,
    NowTime = utime:unixtime(),
    BroadcastGap = data_mount:get_constant_cfg(13),
    case get({resource, TypeId}) of
        undefined -> NeedBroadcast = true;
        Time when (NowTime - Time) >= BroadcastGap ->
            put({resource, TypeId}, NowTime),
            NeedBroadcast = true;
        _ ->
            NeedBroadcast = false
    end,
    case NeedBroadcast of
        true ->
            {ok, Bin} = pt_160:write(16021, [RoleId]),
            lib_server_send:send_to_scene(Scene, ScenePoolId, CopyId, Bin);
        _ -> ok
    end;


do_handle(16022, #player_status{sid = Sid, original_attr = OriginAttr} = Ps, [TypeId, Id], StatusType) ->
    #status_mount{figure_list = FigureList} = StatusType,
    {NewStage, NewStar, NewColorList} =
        case lists:keyfind(Id, #mount_figure.id, FigureList) of
            #mount_figure{stage = Stage, star = Star, color_list = ColorList} ->
                IsActive = true,
                {Stage, Star, ColorList};
            _ ->
                IsActive = false,
                {?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, []}
        end,
    {_, TmpFAttr, TmpSkillIds} = lib_mount:count_figure_attr_combat_sk(TypeId, Id, NewStage, NewStar, NewColorList),
    Fun3 =
        fun(SkillByModTmp, SkillPowerTmp) ->
            lib_skill_api:get_skill_power(SkillByModTmp, 1) + SkillPowerTmp
        end,
    TypeSkillPower = lists:foldl(Fun3, 0, TmpSkillIds),
    if
        IsActive == true ->
            FigurePower = lib_player:calc_partial_power(OriginAttr, TypeSkillPower, TmpFAttr),
            FixNewStar = ?IF(lists:member(TypeId, [?MOUNT_ID, ?MATE_ID]), NewStar, NewStage),
            CurStarAttrL = lib_mount:calc_mount_star_attr(TypeId, Id, FixNewStar),
            CurStarCombat = lib_player:calc_partial_power(Ps, OriginAttr, 0, CurStarAttrL),
            NextStarAttrL = lib_mount:calc_mount_star_attr(TypeId, Id, FixNewStar + 1),
            case NextStarAttrL of
                [] ->
                    NextStarPower = 0;
                _ ->
                    NextStarPower = lib_player:calc_expact_power(Ps, OriginAttr, 0, NextStarAttrL)
            end;
        true ->
            NextStarPower = 0, CurStarCombat = 0,
            FigurePower = lib_player:calc_expact_power(OriginAttr, TypeSkillPower, TmpFAttr)
    end,
    {ok, BinData} = pt_160:write(16022, [TypeId, Id, FigurePower, CurStarCombat, NextStarPower]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 坐骑和伙伴 升星
do_handle(16023, Player, [TypeId, AutoBuy, GoldType], _StatusType) when TypeId == ?MOUNT_ID orelse TypeId == ?MATE_ID ->
    AllGoodsId = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_NORMAL),
    F = fun(GoodsId, Goods) -> Goods ++ lib_goods_api:get_goods_num(Player, [GoodsId]) end,
    AllGoods = lists:foldl(F, [], AllGoodsId),
    case lib_mount:upgrade_star_one(Player, TypeId, AutoBuy, GoldType, lists:filter(fun({_, GoodsNum}) -> GoodsNum =/= 0 end, AllGoods)) of 
        {ok, NewPlayer} -> %% code可能是一个标识码，但是是正确的的返回
            #player_status{status_mount = NewStatusMount} = NewPlayer,
            #status_mount{stage = NewStage, star = NewStar, blessing = NewBlessing, etime = Etime} = lists:keyfind(TypeId, #status_mount.type_id, NewStatusMount),
            {ok, BinData} = pt_160:write(16023, [?SUCCESS, TypeId, NewStage, NewStar, NewBlessing, 0, Etime, AutoBuy, []]);
        {ErrorCode, NewPlayer} ->
            {ok, BinData} = pt_160:write(16023, [ErrorCode, TypeId, 0, 0, 0, 0, 0, 0, []])
    end,
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, battle_attr, NewPlayer};
%% 改变自动购买状态
do_handle(16024, Player, [TypeId, AutoBuy], _StatusType) when TypeId == ?MOUNT_ID orelse TypeId == ?MATE_ID ->
    lib_mount:change_auto_buy(Player, TypeId, AutoBuy);


%% 染色（幻化）
do_handle(16026, Player, [TypeId, Id, ColorId], StatusType)->
    lib_mount:color_level_up(Player, TypeId, Id, ColorId, StatusType);

%% 升星预览
do_handle(16027, #player_status{sid = Sid, original_attr = OriginAttr} = Ps, [TypeId, Id], StatusType) ->
    #status_mount{figure_list = FigureList} = StatusType,
    case lists:keyfind(Id, #mount_figure.id, FigureList) of
        #mount_figure{stage = Stage, star = BaseStar } ->
            Star = ?IF(lists:member(TypeId, [?MOUNT_ID, ?MATE_ID]), BaseStar, Stage),
            FStarAttr = lib_mount:calc_mount_star_attr(TypeId, Id, Star),
            StarCombat = lib_player:calc_partial_power(Ps, OriginAttr, 0, FStarAttr),
            NextStarAttrL = lib_mount:calc_mount_star_attr(TypeId, Id, Star + 1),
            case NextStarAttrL of
                [] ->
                    NextStarCombat = 0;
                _ ->
                    NextStarCombat = lib_player:calc_expact_power(Ps, OriginAttr, 0, NextStarAttrL)
            end;
        _ ->
            StarCombat = 0, NextStarCombat = 0
    end,
    {ok, BinData} = pt_160:write(16027, [TypeId, Id, StarCombat, NextStarCombat]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 坐骑类新养成线的面板信息
do_handle(16028, Player, [TypeId], _StatusType)->
    lib_mount_upgrade_sys:send_panel_info(Player, TypeId);

%% 坐骑类新养成线的升级
do_handle(16029, Player, [TypeId], _StatusType)->
    lib_mount_upgrade_sys:upgrade_mount(Player, TypeId);

%% 坐骑类新养成线的技能升级
do_handle(16030, Player, [TypeId, SkillId], _StatusType)->
    lib_mount_upgrade_sys:upgrade_skill_level(Player, TypeId, SkillId);




%% ------------------坐骑装备----------------------- %%
%% ########### 穿戴 ###########
%%do_handle(Cmd = 16015, PS, [GoodsAutoId]) ->
%%    #player_status{id = PlayerId, sid = Sid, figure = #figure{lv = RoleLv}} = PS,
%%    case lib_module:is_open(?MOD_MOUNT_EQUIP, 1, RoleLv) of
%%        true ->
%%            GoodsStatus = lib_goods_do:get_goods_status(),
%%            case lib_goods_check:check_use_goods(PS, GoodsAutoId, 1, GoodsStatus) of
%%                {ok, #goods{goods_id = GTypeId, location = ?GOODS_LOC_BAG, type = ?GOODS_TYPE_MOUNT_EQUIP, subtype = Pos, cell = BagCell, other = #goods_other{skill_id = NewSkill}} = GoodsInfo} ->
%%                    case lib_mount_equip:check_equip(PS, GTypeId, GoodsStatus) of
%%                        true ->
%%                            F = fun
%%                                    () ->
%%                                        ok = lib_goods_dict:start_dict(),
%%                                        #goods_status{dict = GoodDict} = GoodsStatus,
%%                                        case lib_goods_util:get_goods_by_cell(PlayerId, ?GOODS_LOC_MOUNT_EQUIP, Pos, GoodDict) of
%%                                            #goods{id = OldGoodsId, goods_id = OldGTypeId, other = #goods_other{skill_id = OldSkill}} = OldGoodsInfo ->
%%                                                [_OldGoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell_and_use(OldGoodsInfo, ?GOODS_LOC_BAG, BagCell, GoodsStatus);
%%                                            _ ->
%%                                                OldGoodsId = 0,
%%                                                OldSkill = 0,
%%                                                OldGTypeId = 0,
%%                                                GoodsStatus1 = GoodsStatus
%%                                        end,
%%                                        [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_MOUNT_EQUIP, Pos, GoodsStatus1),
%%                                        #goods_status{dict = OldGoodsDict} = GoodsStatus2,
%%                                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
%%                                        NewGoodsStatus = GoodsStatus2#goods_status{dict = NewGoodsDict},
%%                                        {ok, NewGoodsStatus, GoodsL, OldGoodsId, OldGTypeId, OldSkill, NewSkill}
%%                                end,
%%                            case lib_goods_util:transaction(F) of
%%                                {ok, NewGoodsStatus, GoodsL, OldGoodsId, OldGTypeId, OldSkill, NewSkill} ->
%%                                    lib_goods_do:set_goods_status(NewGoodsStatus),
%%                                    lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, GoodsL),
%%                                    lib_goods_api:notify_client_num(PlayerId, [GoodsInfo#goods{num = 0}]),
%%                                    case OldSkill =:= 0 of
%%                                        true -> skip;
%%                                        _ -> mod_scene_agent:update(PS, [{delete_passive_skill, [{OldSkill, 1}]}])
%%                                    end,
%%                                    NewPS = lib_mount_equip:update_mount_equip_change(PS),
%%                                    lib_log_api:log_mount_equip_wear(PlayerId, Pos, OldGoodsId, OldGTypeId, OldSkill, GoodsAutoId, GTypeId, NewSkill),
%%                                    lib_server_send:send_to_sid(Sid, pt_160, Cmd, [GoodsAutoId, OldGoodsId]),
%%                                    {ok, battle_attr, NewPS};
%%                                Error ->
%%                                    ?ERR("mount equip error ~p~n", [Error]),
%%                                    send_error(Sid, ?FAIL)
%%                            end;
%%                        {false, Code} ->
%%                            send_error(Sid, Code)
%%                    end;
%%                {fail, Code} ->
%%                    send_error(Sid, Code);
%%                _ ->
%%                    send_error(Sid, ?FAIL)
%%            end;
%%        _ ->
%%            skip
%%    end;


%% ########### 锻造信息 ##############
%%do_handle(Cmd = 16016, PS, [Pos]) ->
%%    #goods_status{mount_equip_list = List, dict = GoodDict} = lib_goods_do:get_goods_status(),
%%    case lib_goods_util:get_goods_by_cell(PS#player_status.id, ?GOODS_LOC_MOUNT_EQUIP, Pos, GoodDict) of
%%        #goods{goods_id = _GTypeId} ->
%%            case lists:keyfind(Pos, 1, List) of
%%                {Pos, #equip_mount{lv = Lv, exp = Exp, stage = Stage}} ->
%%                    ok;
%%                _ ->
%%                    Lv = Exp = Stage = 0
%%            end;
%%        _ ->
%%            Lv = Exp = Stage = 0
%%    end,
%%    {ok, BinData} = pt_160:write(Cmd, [Pos, Lv, Exp, Stage]),
%%    lib_server_send:send_to_sid(PS#player_status.sid, BinData);

%% ########### 锻造装备 ##############
%%do_handle(Cmd = 16017, PS, [Pos, CostGId]) ->
%%    #player_status{id = RoleId, sid = Sid} = PS,
%%    #goods_status{mount_equip_list = List, dict = GoodDict} = GoodsStatus = lib_goods_do:get_goods_status(),
%%    case lists:keyfind(Pos, 1, List) of
%%        {_, StrenObj} ->
%%            ok;
%%        _ ->
%%            StrenObj = #equip_mount{}
%%    end,
%%    #equip_mount{lv = Lv, exp = Exp, stage = Stage} = StrenObj,
%%    case lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Pos, GoodDict) of
%%        #goods{} -> %% 有装备才给锻造
%%            [{_, OwnNum}] = lib_goods_api:get_goods_num(PS, [CostGId]),
%%            LvLim = lib_mount_equip:get_lv_max_by_stage(Pos, Stage),
%%            CostInfo = lists:keyfind(CostGId, 1, data_mount_equip:get(stren_goods)),
%%            NextCfg = data_mount_equip:get_stren_attr(Pos, Stage, Lv + 1),
%%            if
%%                Lv >= LvLim -> send_error(Sid, ?ERRCODE(err160_equip_stren_stage_limit));
%%                OwnNum =< 0 -> send_error(Sid, ?ERRCODE(err160_not_enough_cost));
%%                CostInfo =:= false -> send_error(Sid, ?ERRCODE(err_config));
%%                NextCfg =:= [] -> send_error(Sid, ?ERRCODE(err160_equip_stren_stage_limit));
%%                true ->
%%                    case data_mount_equip:get_stren_attr(Pos, Stage, Lv) of
%%                        #base_mount_equip_attr{exp = MaxExp} ->
%%                            {_, OneExp} = CostInfo,
%%                            GoodNum = case Exp + OneExp >= MaxExp of
%%                                          true -> 1;
%%                                          _ -> min(OwnNum, util:ceil((MaxExp - Exp) / OneExp))
%%                                      end,
%%                            ExpPlus = OneExp * GoodNum,
%%                            case lib_goods_util:check_object_list(PS, Cost = [{?TYPE_GOODS, CostGId, GoodNum}]) of
%%                                true ->
%%                                    F = fun() ->
%%                                        ok = lib_goods_dict:start_dict(),
%%                                        case lib_goods_util:cost_object_list(PS, Cost, mount_equip, "", GoodsStatus) of
%%                                            {true, NewStatus, NewPS} ->
%%                                                {NewLv, NewExp} = lib_mount_equip:calc_lv(Pos, Stage, Lv, Exp, ExpPlus, MaxExp),
%%                                                NewList = lists:keystore(Pos, 1, List, {Pos, StrenObj#equip_mount{lv = NewLv, exp = NewExp}}),
%%                                                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%%                                                NewGoodsStatus = NewStatus#goods_status{mount_equip_list = NewList, dict = Dict},
%%                                                lib_mount_equip:save_stren(RoleId, Pos, NewLv, NewExp, Stage),
%%                                                {ok, NewPS, NewGoodsStatus, GoodsL, NewLv, NewExp};
%%                                            {false, Res, _NewStatus, _NewPS} ->
%%                                                {false, Res}
%%                                        end
%%                                        end,
%%                                    case lib_goods_util:transaction(F) of
%%                                        {ok, NewPS, NewGoodsStatus, GoodsL, NewLv, NewExp} ->
%%                                            lib_goods_do:set_goods_status(NewGoodsStatus),
%%                                            lib_goods_api:notify_client_num(RoleId, GoodsL),
%%                                            lib_server_send:send_to_sid(Sid, pt_160, Cmd, [Pos, NewLv, NewExp, Stage]),
%%                                            lib_log_api:log_mount_equip_lv(RoleId, Pos, Lv, Exp, NewLv, NewExp, Cost),
%%                                            if
%%                                                NewLv =/= Lv ->
%%                                                    NewPS1 = lib_mount_equip:update_mount_equip_change(NewPS),
%%                                                    {ok, battle_attr, NewPS1};
%%                                                true ->
%%                                                    {ok, NewPS}
%%                                            end;
%%                                        {false, Code} ->
%%                                            send_error(Sid, Code)
%%                                    end;
%%                                {false, Code} ->
%%                                    send_error(Sid, Code)
%%                            end;
%%                        _ ->
%%                            send_error(Sid, ?ERRCODE(err_config))
%%                    end
%%            end;
%%        _ ->
%%            send_error(Sid, ?ERRCODE(err160_equip_stren_no_equip))
%%    end;

%% ########### 升阶 ##############
%%do_handle(Cmd = 16018, PS, [Pos]) ->
%%    #player_status{id = RoleId, sid = Sid} = PS,
%%    #goods_status{mount_equip_list = List, dict = GoodDict} = GoodsStatus = lib_goods_do:get_goods_status(),
%%    case lists:keyfind(Pos, 1, List) of
%%        {Pos, StrenObj} ->
%%            ok;
%%        _ ->
%%            StrenObj = #equip_mount{}
%%    end,
%%    #equip_mount{lv = Lv, exp = Exp, stage = Stage} = StrenObj,
%%    case lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Pos, GoodDict) of
%%        #goods{} ->  % 穿了才让操作
%%            LvLim = lib_mount_equip:get_lv_max_by_stage(Pos, Stage),
%%            StageCfg = data_mount_equip:get_stage(Stage + 1),
%%            if
%%                Lv < LvLim -> send_error(Sid, ?ERRCODE(err160_equip_not_enough_lv));
%%                StageCfg =:= [] -> send_error(Sid, ?ERRCODE(err160_equip_stren_max_stage));
%%                true ->
%%                    #base_mount_equip_stage{cost = Cost} = data_mount_equip:get_stage(Stage + 1),
%%                    case lib_goods_util:check_object_list(PS, Cost) of
%%                        true ->
%%                            F = fun() ->
%%                                ok = lib_goods_dict:start_dict(),
%%                                case lib_goods_util:cost_object_list(PS, Cost, mount_equip, "", GoodsStatus) of
%%                                    {true, NewStatus, NewPS} ->
%%                                        NewStage = Stage + 1,
%%                                        #base_mount_equip_attr{exp = MaxExp} = data_mount_equip:get_stren_attr(Pos, NewStage, 0),
%%                                        {NewLv, NewExp} = lib_mount_equip:calc_lv(Pos, NewStage, 0, 0, Exp, MaxExp),
%%                                        NewList = lists:keystore(Pos, 1, List, {Pos, StrenObj#equip_mount{lv = NewLv, exp = NewExp, stage = NewStage}}),
%%                                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%%                                        NewGoodsStatus = NewStatus#goods_status{mount_equip_list = NewList, dict = Dict},
%%                                        lib_mount_equip:save_stren(RoleId, Pos, NewLv, NewExp, NewStage),
%%                                        {ok, NewPS, NewGoodsStatus, GoodsL, NewLv, NewExp, NewStage};
%%                                    {false, Res, _NewStatus, _NewPS} ->
%%                                        {false, Res}
%%                                end
%%                                end,
%%                            case lib_goods_util:transaction(F) of
%%                                {ok, NewPS, NewGoodsStatus, GoodsL, NewLv, NewExp, NewStage} ->
%%                                    lib_goods_do:set_goods_status(NewGoodsStatus),
%%                                    lib_goods_api:notify_client_num(RoleId, GoodsL),
%%                                    lib_server_send:send_to_sid(Sid, pt_160, Cmd, [Pos, NewLv, NewExp, NewStage]),
%%                                    lib_log_api:log_mount_equip_stage(RoleId, Pos, Stage, NewStage, Cost),
%%                                    NewPS1 = lib_mount_equip:update_mount_equip_change(NewPS),
%%                                    {ok, battle_attr, NewPS1};
%%                                {false, Code} ->
%%                                    send_error(Sid, Code)
%%                            end;
%%                        {false, Code} ->
%%                            send_error(Sid, Code)
%%                    end
%%            end;
%%        _ ->
%%            send_error(Sid, ?ERRCODE(err160_equip_stren_no_equip))
%%    end;

%% ########### 铭刻 ##############
%%do_handle(Cmd = 16019, PS, [GoodId, GoodList]) ->
%%    #player_status{id = RoleId, sid = Sid, figure = #figure{lv = RoleLv}} = PS,
%%    GoodsStatus = lib_goods_do:get_goods_status(),
%%    %?PRINT("~p~n", [GoodsStatus]),
%%    case lib_module:is_open(?MOD_MOUNT_EQUIP, 1, RoleLv) of
%%        true ->
%%            case lib_goods_util:get_goods(GoodId, GoodsStatus#goods_status.dict) of
%%                #goods{color = Color, goods_id = GTypeId, other = #goods_other{skill_id = OldSkill}} = GoodsInfo when Color >= ?BLUE, OldSkill =:= 0 ->    %% 蓝色品质以上才可铭刻
%%                    case data_mount_equip:get_equip(GTypeId) of
%%                        #base_mount_equip{quality = Color} ->
%%                            Cost = [{?TYPE_GOODS, GId, Num} || {GId, Num} <- util:combine_list(GoodList)],
%%                            case lib_goods_util:check_object_list(PS, Cost) of
%%                                true ->
%%                                    F = fun() ->
%%                                        ok = lib_goods_dict:start_dict(),
%%                                        case lib_goods_util:cost_object_list(PS, Cost, mount_equip, "", GoodsStatus) of
%%                                            {true, NewStatus, NewPS} ->
%%                                                Prob = lib_mount_equip:get_engrave_prob(Color, GoodList),
%%                                                case urand:rand(1, 10000) =< Prob of
%%                                                    true ->
%%                                                        NewGoodsInfo = lib_mount_equip:change_goods_info(GoodsInfo),
%%                                                        lib_mount_equip:change_goods_other_db(NewGoodsInfo),
%%                                                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%%                                                        Dict2 = lib_goods_dict:add_dict_goods(NewGoodsInfo, Dict),
%%                                                        NewGoodsStatus = NewStatus#goods_status{dict = Dict2},
%%                                                        {ok, NewPS, NewGoodsStatus, GoodsL, 1, NewGoodsInfo#goods.other#goods_other.skill_id};
%%                                                    false ->
%%                                                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%%                                                        NewGoodsStatus = NewStatus#goods_status{dict = Dict},
%%                                                        {ok, NewPS, NewGoodsStatus, GoodsL, 0, 0}
%%                                                end;
%%                                            {false, Res, _NewStatus, _NewPS} ->
%%                                                {false, Res}
%%                                        end
%%                                        end,
%%                                    case lib_goods_util:transaction(F) of
%%                                        {ok, NewPS, NewGoodsStatus, GoodsL, IsSuccess, SkillId} ->
%%                                            lib_goods_do:set_goods_status(NewGoodsStatus),
%%                                            lib_goods_api:notify_client_num(RoleId, GoodsL),
%%                                            lib_server_send:send_to_sid(Sid, pt_160, Cmd, [IsSuccess]),
%%                                            lib_log_api:log_mount_equip_engrave(RoleId, GoodId, GTypeId, IsSuccess, SkillId, Cost),
%%                                            NewPS1 = lib_mount_equip:update_mount_equip_change(NewPS),
%%                                            {ok, battle_attr, NewPS1};
%%                                        {false, Code} ->
%%                                            send_error(Sid, Code)
%%                                    end;
%%                                {false, Code} ->
%%                                    send_error(Sid, Code)
%%                            end;
%%                        _ ->
%%                            send_error(Sid, ?ERRCODE(err_config))
%%                    end;
%%                #goods{} ->
%%                    send_error(Sid, ?ERRCODE(err160_equip_engrave_color_limit));
%%                _ ->
%%                    send_error(Sid, ?ERRCODE(err150_no_goods))
%%            end;
%%        _ ->
%%            skip
%%    end;




do_handle(_Cmd, _Player, _Data, _StatusType) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

%%send_error(Sid, Code) ->
%%    {ok, BinData} = pt_160:write(16000, [Code]),
%%    lib_server_send:send_to_sid(Sid, BinData).
