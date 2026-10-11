%%---------------------------------------------------------------------------
%% @doc:        lib_player_look_over
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-4月-07. 10:33
%% @deprecated: 查看玩家信息
%%---------------------------------------------------------------------------
-module(lib_player_look_over).

-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("rec_offline.hrl").
-include("goods.hrl").
-include("magic_circle.hrl").
-include("figure.hrl").
-include("dragon_ball.hrl").
-include("seal.hrl").
-include("def_fun.hrl").
-include("draconic.hrl").
-include("mount.hrl").
-include("fashion.hrl").
-include("revelation_equip.hrl").
-include("god.hrl").
-include("decoration.hrl").
-include("def_goods.hrl").
-include("dragon.hrl").
-include("eudemons.hrl").
-include("companion.hrl").
-include("demons.hrl").
-include("rune.hrl").
-include("skill.hrl").
-include("fairy_buy.hrl").

%% API
-export([
    apply_look_over_player/3,
    do_apply_look_over_player/6,
    apply_other_server_player/4,
    apply_other_server_player/7,
    do_apply_other_server_player/6
]).

-export([
    calc_rune_power/4
]).

%% -----------------------------------------------------------------
%% @desc    功能描述 申请查看本服玩家的信息
%% @param   参数     SelfPs:发起申请的玩家，LookRoleId:需要查看信息的玩家 ModuleId:需要查看的数据
%% @return  返回值
%% -----------------------------------------------------------------
apply_look_over_player(SelfPs, LookRoleId, ModuleId) ->
    #player_status{ id = PlayerId, sid = Sid, figure =  #figure{name = Name} } = SelfPs,
    Flag = not lists:member(ModuleId, ?LOOK_OVER_MODULE_LIST),
    if
        PlayerId == LookRoleId -> %% 自己查看自己时，不处理该种请求
            ok;
        Flag ->
            ErrorCode = ?ERRCODE(err144_param_error),
            {ok, BinData} = pt_195:write(19501, [ErrorCode]),
            lib_server_send:send_to_uid(PlayerId, BinData);
        true ->
            OtherArgs = calc_other_args(ModuleId, SelfPs),
            lib_player:apply_cast(LookRoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, do_apply_look_over_player, [Sid, Name, PlayerId, ModuleId, OtherArgs])
    end.

do_apply_look_over_player(LookPlayer, Sid, ToName, ToPlayerId, ModuleId, OtherArgs) ->
    BinData = get_module_pack_data(LookPlayer, ToName, ToPlayerId, ModuleId, OtherArgs),
    case BinData of
        none ->
            skip;
        _ ->
            lib_server_send:send_to_sid(Sid, BinData)
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 申请查看其他服务器上的玩家信息
%% @param   参数     SelfPs:发起申请的玩家，LookServerId:需要查看的服务器ID LookRoleId:需要查看信息的玩家 ModuleId:需要查看的数据
%% @return  返回值
%% -----------------------------------------------------------------
apply_other_server_player(SelfPlayer, LookServerId, LookRoleId, ModuleId) ->
    #player_status{ id = ToPlayerId, figure = #figure{ name = ToName } } = SelfPlayer,
    Flag = lists:member(LookServerId, config:get_merge_server_ids()) orelse LookServerId == 0,
    Flag2 = not lists:member(ModuleId, ?LOOK_OVER_MODULE_LIST),
    if
        ToPlayerId == LookRoleId ->
            skip;
        Flag2 ->
            ErrorCode = ?ERRCODE(err144_param_error),
            {ok, BinData} = pt_195:write(19501, [ErrorCode]),
            lib_server_send:send_to_uid(ToPlayerId, BinData);
        Flag ->
            apply_look_over_player(SelfPlayer, LookRoleId, ModuleId);
        true ->
            Node = mod_disperse:get_clusters_node(),
            OtherArgs = calc_other_args(ModuleId, SelfPlayer),
            Args = [LookServerId, LookRoleId, Node, ToPlayerId, ToName, ModuleId, OtherArgs],
            mod_clusters_node:apply_cast(?MODULE, apply_other_server_player, Args)
    end.

apply_other_server_player(LookServerId, LookRoleId, Node, ToPlayerId, ToName, ModuleId, OtherArgs) ->
    Args = [LookRoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, do_apply_other_server_player, [Node, ToPlayerId, ToName, ModuleId, OtherArgs]],
    mod_clusters_center:apply_cast(LookServerId, lib_player, apply_cast, Args).

do_apply_other_server_player(LookPlayer, Node, ToPlayerId, ToName, ModuleId, OtherArgs) ->
    BinData = get_module_pack_data(LookPlayer, ToName, ToPlayerId, ModuleId, OtherArgs),
    case BinData of
        none ->
            skip;
        _ ->
            mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, ToPlayerId, BinData])
    end.

%% ==========================================================
%% inner_function
%% ==========================================================

%% 更具模块ID获取各个模块的数据
get_module_pack_data(LookPlayer, ToName, ToPlayerId, ModuleId, Args) ->
    case ModuleId of
        ?MOD_BASE_EQUIP_DATA ->
            BinData = make_base_equip_info_pack(LookPlayer, ToName, ToPlayerId);
        ?MOD_DRAGON_BALL_DATA ->
            BinData = make_dragon_ball_info_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_SEAL_EQUIP_DATA ->
            BinData = make_seal_equip_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_DRACONIC_EQUIP_DATA ->
            BinData = make_draconic_equip_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_ILLUSION_DATA ->
            [SelfComparePowerL|_] = Args,
            BinData = make_illusion_info_data(LookPlayer, ToName, ToPlayerId, SelfComparePowerL);
        ?MOD_REVELATION_EQUIP_DATA ->
            BinData = make_revelation_equip_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_GOD_DATA ->
            BinData = make_god_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_DECORATION_EQUIP_DATA ->
            BinData = make_decoration_equip_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_DRAGON_EQUIP_DATA ->
            BinData = make_dragon_equip_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_EUDEMONS_DATA ->
            BinData = make_eudemons_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_COMPANION_DEMONS_DATA ->
            BinData = make_companion_and_demons_data(LookPlayer, ToName, ToPlayerId);
        ?MOD_RUNE_EQUIP_DATA ->
            BinData = make_rune_equip_data(LookPlayer, ToName, ToPlayerId);
        _ ->
            BinData = none
    end,
    BinData.

%% 打包模块1 - 查看玩家的基本装备信息数据
make_base_equip_info_pack(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        id = RoleId, server_id = ServerId, status_achievement = NewStarRewardL,
        combat_power = Combat, magic_circle = MagicCircleList, off = Off, figure = Figure,
        fairy_buy_status = FairyBuyList
    } = LookOverPs,
    AchvStage = lib_achievement_api:get_cur_stage_offline(NewStarRewardL),  %% 爵位等级
    case Off#status_off.goods_status of
        undefined ->
            GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
        GoodsStatus ->
            ok
    end,
    Dict = GoodsStatus#goods_status.dict,
    GodEquipLevelList = GoodsStatus#goods_status.god_equip_list,
    EquipList = lib_goods_util:get_equip_list(RoleId, Dict),
    F = fun(GoodsInfo) ->
        #goods{id = GoodsId, equip_type = Pos, goods_id = TypeId, cell = Cell, color = Color, level = Level} = GoodsInfo,
        case lists:keyfind(Pos, 1, GodEquipLevelList) of
            {_, GodEquipLevel} -> skip;
            _ -> GodEquipLevel = 0
        end,
        Stren = lib_goods_do:get_info_stren(GoodsStatus, GoodsInfo),
        Stage = lib_equip:get_equip_stage(TypeId),
        Star = lib_equip:get_equip_star(TypeId),
        {GoodsId, TypeId, Cell, Color, Stren, Star, Stage, Level, GodEquipLevel}
        end,
    SendEquipList = lists:map(F, EquipList),
    Fun2 = fun(MagicInfo) ->
        #magic_circle{status = IsOpen, lv = MagicCircleLv, end_time = EndTime, free_flag = FreeFlag} = MagicInfo,
        {MagicCircleLv, IsOpen, FreeFlag, EndTime}
    end,
    SendMagicList = lists:map(Fun2, MagicCircleList),
    %% 新增仙灵部分
    AllFairyId = data_fairy_buy:get_all_fairy_id(),
    Fun = fun(FairyId) ->
        case lists:keyfind(FairyId, #status_fairy_buy.fairy_id, FairyBuyList) of
            false ->
                IsActive = 0;   %% 0 表示未激活
            _ ->
                IsActive = 1    %% 1 表示激活
        end,
        {FairyId, IsActive}
    end,
    SendFairyBuyList = lists:map(Fun, AllFairyId),
    Args = [ServerId, RoleId, Combat, AchvStage, Figure, SendEquipList, SendMagicList, SendFairyBuyList],
    %% ?INFO("args:~p~n", [Args]),
    {ok, BinData} = pt_195:write(19502, Args),
    BinData.

%% 打包星核数据
make_dragon_ball_info_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        server_id = ServerId, pid = Pid, id = RoleId,
        original_attr = AttAttr, dragon_ball = StatusDragonBall
    } = LookOverPs,
    case StatusDragonBall of
        #status_dragon_ball{items = DragonBallItems, statue = Statue, figure_list = FigureList} ->
            case is_pid(Pid) of
                true ->
                    get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                false ->
                    ok
            end,
            {TotalAttr, SkillPower} = lib_dragon_ball:get_skill_and_attr(LookOverPs),
            SumPower = lib_player:calc_partial_power(AttAttr, SkillPower, TotalAttr),
            SendDragonBallItems = [{BallId, BallLv} || {BallId, BallLv, _} <- DragonBallItems],
            Args = [SumPower, Statue, SendDragonBallItems, FigureList];
        _ ->
            Args = [0, 0, [], []]
    end,
    %% ?INFO("args:~p~n", [Args]),
    {ok, BinData} = pt_195:write(19503, Args),
    BinData.

%% 打包影装数据
make_seal_equip_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        server_id = ServerId, off = Off, id = RoleId,
        seal_status = SealStatus, original_attr = SumOAttr
    } = LookOverPs,
    case SealStatus of
        #seal_status{
            pos_map = PosMap, pill_map = _PillMap, equip_list = EquipList,
            stren_attr = StrenAttr, equip_attr = EquipAttr, pill_attr = PillAttr,
            suit_attr = SuitAttr, suit_info = SuitInfo, rating = Rating
        } ->
            case Off#status_off.goods_status of
                undefined ->
                    GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                GoodsStatus ->
                    ok
            end,
            PosList = maps:to_list(PosMap),
            Fun = fun({Pos, SealPosTuple}) ->
                #seal_pos{ pos = Pos, type_id = TypeId, goods_id = GoodsId, attr = AttrL, rating = Rat} = SealPosTuple,
                case lists:keyfind(Pos, 1, EquipList) of
                    {Pos, _GId, StrenLvl} -> ok;
                    _ -> StrenLvl = 0
                end,
                case lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict) of
                    #goods{ cell = GoodsCell } -> ok;
                    _ -> GoodsCell = 0
                end,
                {Pos, TypeId, GoodsId, AttrL, Rat, StrenLvl, GoodsCell}
            end,
            SendPosList = lists:map(Fun, PosList),
            %% PillList = maps:to_list(PillList), %% 无显示需求，预留
            SendPillList = [],
            Fun2 = fun({SuitId, _, _, RealNum, _, _, _}, Acc) ->
                {SuitId, OldRealNum} = ulists:keyfind(SuitId, 1, Acc, {SuitId, 0}),
                ?IF(RealNum >= OldRealNum, lists:keystore(SuitId, 1, Acc, {SuitId, RealNum}), Acc)
            end,
            SendSuitList = lists:foldl(Fun2, [], SuitInfo),
            SealSumAttr = lib_seal:get_total_attr(LookOverPs),
            SumPower = lib_player:calc_partial_power(SumOAttr, 0, SealSumAttr),
            Args = [3, Rating, SumPower, SendPosList, SendPillList, StrenAttr, EquipAttr, PillAttr, SuitAttr, SendSuitList];
        _ ->
            Args = [3, 0, 0, [], [], [], [], [], [], []]
    end,
    %% ?INFO("args:~p~n", [Args]),
    {ok, BinData} = pt_195:write(19504, Args),
    BinData.

%% 打包神祭数据
make_draconic_equip_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        server_id = ServerId,id = RoleId, off = Off,
        draconic_status = DraconicStatus, original_attr = SumOAttr
    } = LookOverPs,
    case DraconicStatus of
        #draconic_status{
            pos_map = PosMap, equip_list = EquipList, rating = Rating,
            stren_attr = StrenAttr, equip_attr = EquipAttr,
            suit_attr = SuitAttr, suit_info = SuitInfo, special_attr = SpecialAttr
        } ->
            case Off#status_off.goods_status of
                undefined ->
                    get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                _GoodsStatus ->
                    ok
            end,
            PosList = maps:to_list(PosMap),
            Fun = fun({Pos, DraPosTuple}) ->
                #draconic_pos{ pos = Pos, type_id = TypeId, goods_id = GoodsId, attr = AttrL, rating = Rat} = DraPosTuple,
                case lists:keyfind(Pos, 1, EquipList) of
                    {Pos, _GId, StrenLvl} -> ok;
                    _ -> StrenLvl = 0
                end,
                {Pos, TypeId, GoodsId, AttrL, Rat, StrenLvl, 0}
            end,
            SendPosList = lists:map(Fun, PosList),
            %% PillList = maps:to_list(PillList), %% 无显示需求，预留
            SendPillList = [],
            Fun2 = fun({SuitId, _, _, RealNum, _, _, _}, Acc) ->
                {SuitId, OldRealNum} = ulists:keyfind(SuitId, 1, Acc, {SuitId, 0}),
                ?IF(RealNum >= OldRealNum, lists:keystore(SuitId, 1, Acc, {SuitId, RealNum}), Acc)
            end,
            SendSuitList = lists:foldl(Fun2, [], SuitInfo),
            DraSumAttr = lib_draconic:get_total_attr(LookOverPs),
            SumPower = lib_player:calc_partial_power(SumOAttr, 0, DraSumAttr),
            Args = [4, Rating, SumPower, SendPosList, SendPillList, StrenAttr, EquipAttr, SpecialAttr, SuitAttr, SendSuitList];
        _ ->
            Args = [4, 0, 0, [], [], [], [], [], [], []]
    end,
    %% ?INFO("args:~p~n", [Args]),
    {ok, BinData} = pt_195:write(19504, Args),
    BinData.

%% 打包幻化数据
make_illusion_info_data(LookOverPs, ToName, ToPlayerId, SelfComparePowerL) ->
    #player_status{
        server_id = ServerId, id = RoleId,
        status_mount = MountStatus, off = Off, figure = #figure{lv = Lv}
    } = LookOverPs,
    case Off#status_off.goods_status of
        undefined ->
            GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
        GoodsStatus ->
            ok
    end,
    Fun = fun(I, {MountCombat, MountNum, MountInfoL, ComparePowerL}) ->
        #status_mount{
            type_id = TypeId, stage = BaseState, star = BaseStar, combat = BaseCombat,
            figure_list = FigureList, etime = BaseEndTime, skills = BaseSkill
        } = I,
        Fun2 = fun(Figure, {FigureNum, FigureAccL}) ->
            #mount_figure{
                id = Id, stage = Stage, star = Star, attr = Attr, skills = Skills,
                combat = Combat, end_time = EndTime, star_attr = StarAttr
            } = Figure,
            %%NewSum = SumCombat + Combat,
            NewNum = FigureNum + 1,
            FigureInfo = {?ILLUSION_MOUNT_FIGURE, Id, Stage, Star, Combat, EndTime, Attr, StarAttr, Skills},
            {NewNum, [FigureInfo|FigureAccL]}
        end,
        {AllFigureNum, AllFigureInfoL} = lists:foldl(Fun2, {0, []}, FigureList),
        BaseFigureInfo = {?BASE_MOUNT_FIGURE, 0, BaseState, BaseStar, BaseCombat, BaseEndTime, [], [], BaseSkill},
        LastAllFigureInfoL = [BaseFigureInfo|AllFigureInfoL],
        LastAllFigureCombat = BaseCombat,
        LastAllFigureNum = AllFigureNum + 1,
        MountInfo = {TypeId, LastAllFigureNum, LastAllFigureCombat, LastAllFigureInfoL},
        NewMountInfoL = [MountInfo|MountInfoL],
        NewMountNum = MountNum + LastAllFigureNum,
        NewMountCombat = MountCombat + LastAllFigureCombat,
        NewComparePowerL = [{TypeId, LastAllFigureCombat}|ComparePowerL],
        {NewMountCombat, NewMountNum, NewMountInfoL, NewComparePowerL}
    end,
    {MountFigureCombat, MountFigureNum, MountFigureInfoL, MountComparePowerL} = lists:foldl(Fun, {0, 0, [], []}, MountStatus),
    % ?INFO("Mount:~p", [MountFigureInfoL]),
    %% 计算拿取时装类的
    #goods_status{fashion = #fashion{position_list = PositionList} } = GoodsStatus,
    case lib_fashion_check:check_show_fashion(Lv) of
        true ->
            Fun3 = fun(FashionPos, {FashionCombat, FashionNum, FashionInfoL}) ->
                #fashion_pos{
                    pos_id = PosId, pos_lv = PosLv, wear_fashion_id = WearFashionId, fashion_list = FashionList
                } = FashionPos,
                Fun4 = fun(I, {FCombat, FNum, FInfoL}) ->
                    #fashion_info{
                        fashion_id = FId, color_id = ActiveNowColorId,
                        color_list = ActiveColorList, fashion_star_lv = FashionStarlv
                    } = I,
                    ThisCombat = lib_fashion:calc_real_power(LookOverPs, PosId, FId, GoodsStatus),
                    NewInfo = {FId, FashionStarlv, ThisCombat, ActiveNowColorId, ActiveColorList},
                    NewFCombat = FCombat + ThisCombat,
                    NewFNum = FNum + 1,
                    {NewFCombat, NewFNum, [NewInfo|FInfoL]}
                 end,
                {SumCombat, SumNum, SumInfoL} = lists:foldl(Fun4, {0, 0, []}, FashionList),
                FashionInfo = {PosId, PosLv, WearFashionId, SumInfoL},
                NewFashionCombat = FashionCombat + SumCombat,
                NewFashionNum = FashionNum + SumNum,
                {NewFashionCombat, NewFashionNum, [FashionInfo|FashionInfoL]}
             end,
            {SendFashionCombat, SendFashionNum, SendFashionInfoL} = lists:foldl(Fun3, {0, 0, []}, PositionList);
        false ->
            SendFashionCombat = 0,
            SendFashionNum = 0,
            SendFashionInfoL = []
    end,
    %% 协议发送的数据
    SumPower = MountFigureCombat + SendFashionCombat,
    AllNum = MountFigureNum + SendFashionNum,
    Args = [SumPower, AllNum, MountFigureInfoL, SendFashionInfoL, SelfComparePowerL ,MountComparePowerL],
    %% ?INFO("Args:~p~n", [Args]),
    {ok, BinData} = pt_195:write(19506, Args),
    BinData.

%% 打包天启数据
make_revelation_equip_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        revelation_equip = Revelation, id = RoleId, off = Off,
        server_id = ServerId, original_attr = OriginalAttr, goods = Goods
    } = LookOverPs,
    case Revelation of
        #role_revelation_equip{
            max_figure_id = MaxFigureId, current_figure = CurrentFigureId,
            gathering = Gathering, skill = SkillList
        } ->
            case Off#status_off.goods_status of
                undefined ->
                    GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                GoodsStatus ->
                    ok
            end,
            RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, GoodsStatus#goods_status.dict),
            Fun = fun(Pos, {PosInfoL, PosScore}) ->
                case lists:keyfind(Pos, #goods.cell, RevelationEquipList) of
                    #goods{ id = GoodsAutoId, goods_id = ItemId, other = #goods_other{ rating = Rating } } ->
                        ok ;
                    _ ->
                        GoodsAutoId = 0, ItemId = 0, Rating = 0
                end,
                case lists:keyfind(Pos, 1, Gathering) of
                    {Pos, Lv, Exp} ->
                        Flag = ?IF(GoodsAutoId > 0, ?gathering_enable, ?gathering_unable),
                        ok;
                    _ ->
                        Flag = ?gathering_unable,
                        Lv = 0,
                        Exp =0
                end,
                %% ?INFO("Args:~p", [{Pos, ItemId, Rating}]),
                Info = {Pos, Lv, Exp, Flag, GoodsAutoId, ItemId, Rating},
                {[Info|PosInfoL], Rating + PosScore}
            end,
            {PosInfoList, AllPosRating} = lists:foldl(Fun, {[], 0}, ?pos_list),
            {_, SuitList} = lib_revelation_equip:count_suit_attribute(RevelationEquipList),
            {AttrList, SkillPower} = calc_revelation_equip_all_attr(Goods, RevelationEquipList, SkillList, Gathering),
            Power = lib_player:calc_partial_power(OriginalAttr, SkillPower, AttrList),
            Args = [MaxFigureId, CurrentFigureId, Power, AllPosRating, PosInfoList, SuitList, SkillList];
        _ ->
            Args = [0, 0, 0, 0, [], [], []]
    end,
    %% ?INFO("Args:~p", [Args]),
    {ok, BinData} = pt_195:write(19505, Args),
    BinData.

%% 打包玩家当前变身对的降神界面信息
make_god_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{ id = RoleId, god = GodStatus, original_attr = OriginalAttr, off = Off, server_id = ServerId } = LookOverPs,
    case GodStatus of
        #status_god{ battle = Battle, god_list = GodList, god_stren = #god_stren{ stren_list = StrenList} } ->
            case Off#status_off.goods_status of
                undefined ->
                    get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                _ ->
                    ok
            end,
            %% Fun = fun({Pos, GodId}) ->
            %%     case lists:keyfind(GodId, #god.id, GodList) of
            %%         #god{ lv = Lv, grade = Grade, star = Star, equip_list = EquipList } ->
            %%             GodPower = lib_god:get_god_power(LookOverPs, GodId);
            %%         _ ->
            %%             Lv = 0, Grade = 0, Star = 0, EquipList = [], GodPower = 0
            %%     end,
            %%     case lists:keyfind(GodId, #god_stren_item.god_type, StrenList) of
            %%         #god_stren_item{ level = StrenLv } -> ok;
            %%         _ -> StrenLv = 0
            %%     end,
            %%     SendEquipList = [{EquipPos, GoodsId} || {EquipPos, _AutoId, GoodsId} <- EquipList],
            %%     {Pos, GodId, Lv, Grade, Star, GodPower, StrenLv, SendEquipList}
            %% end,
            %% 2022-4-21 根据策划要求，拿全部的降神信息而不是拿单个
            Fun = fun(GodInfo) ->
                #god{ id = GodId, lv = Lv, grade = Grade, star = Star, equip_list = EquipList } = GodInfo,
                GodPower = lib_god:get_god_power(LookOverPs, GodId),
                case lists:keyfind(GodId, #god_stren_item.god_type, StrenList) of
                    #god_stren_item{ level = StrenLv } -> ok;
                    _ -> StrenLv = 0
                end,
                SendEquipList = [{EquipPos, GoodsId} || {EquipPos, _AutoId, GoodsId} <- EquipList],
                case lists:keyfind(GodId, 2, Battle) of
                    {Pos, GodId} -> Pos;
                    _ -> Pos = 0  %% 0表示未出战的降神
                end,
                {Pos, GodId, Lv, Grade, Star, GodPower, StrenLv, SendEquipList}
            end,
            BattleGodInfoL = lists:map(Fun, GodList),
            AllGodCombat = lib_god:get_all_god_power(GodStatus, OriginalAttr),
            Args = [AllGodCombat, BattleGodInfoL];
        _ ->
            Args = [0, []]
    end,
    %% ?INFO("Args:~p//Or:~p", [Args, GodStatus]),
    {ok, BinData} = pt_195:write(19507, Args),
    BinData.

%% 打包灵饰数据
make_decoration_equip_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{ id = RoleId, decoration = Decoration, off = Off, server_id = ServerId } = LookOverPs,
    case Decoration of
        #decoration{ level_list = StrenList, pos_goods = GoodsList, unlock_cell_list = UnLockList} ->
            case Off#status_off.goods_status of
                undefined ->
                    GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                GoodsStatus ->
                    ok
            end,
            Fun = fun(UnlockPos, {UnlockInfoL, SumRating}) ->
                BaseStrenLevel = proplists:get_value(UnlockPos, StrenList, 0),
                GoodsAutoId = proplists:get_value(UnlockPos, GoodsList, 0),
                GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
                case GoodsInfo of
                    #goods{ goods_id = GoodsTypeId, other = #goods_other{ extra_attr = BaseExtraAttr }} ->
                        case lib_goods_util:load_goods_other(GoodsInfo) of
                            true ->
                                OverallRating = lib_equip:cal_equip_overall_rating(?GOODS_LOC_DECORATION, GoodsInfo),
                                ExtraAttr = data_attr:unified_format_extra_attr(BaseExtraAttr, []);
                            false ->
                                GoodsTypeId = 0,
                                OverallRating = 0,
                                ExtraAttr = []
                        end,
                        Stage = case data_decoration:get_dec_attr(GoodsTypeId) of
                                    #dec_attr_cfg{stage = Stg} -> Stg;
                                    _ -> 1
                                end,
                        DecLevMax = data_decoration:get_dec_level_max(UnlockPos, Stage, GoodsInfo#goods.color),
                        StrenLevel = case is_record(DecLevMax, dec_level_max_cfg) of
                                         true ->
                                             case BaseStrenLevel >= DecLevMax#dec_level_max_cfg.limit_level of
                                                 true -> DecLevMax#dec_level_max_cfg.limit_level;
                                                 false -> BaseStrenLevel
                                             end;
                                         false -> 0
                                     end,
                        Info = {UnlockPos, GoodsTypeId, StrenLevel, OverallRating, ExtraAttr},
                        LastOverallRating = OverallRating;
                    _ ->
                        Info = {UnlockPos, 0, 0, 0, []},
                        LastOverallRating = 0

                end,
                {[Info|UnlockInfoL], SumRating + LastOverallRating}
            end,
            {SendUnlockInfoL, AllUnLockPosRating} = lists:foldl(Fun, {[], 0}, UnLockList),
            Args = [AllUnLockPosRating, SendUnlockInfoL];
        _ ->
            Args = [0, []]
    end,
    %% ?INFO("Args:~p", [Args]),
    {ok, BinData} = pt_195:write(19508, Args),
    BinData.

%% 打包神纹装备数据
make_dragon_equip_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{id = RoleId, dragon = StatusDragon, off = Off, server_id = ServerId } = LookOverPs,
    case StatusDragon of
        #status_dragon{ pos_list = PosList, skill_list = _SkillList } ->
            case Off#status_off.goods_status of
                undefined ->
                    GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                GoodsStatus ->
                    ok
            end,
            Dict = GoodsStatus#goods_status.dict,
            EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_DRAGON_EQUIP, ?GOODS_LOC_DRAGON_EQUIP, Dict),
            RealCombat = lib_dragon:loo_over_calc_dragon_real_power(LookOverPs, [], GoodsStatus),
            Fun = fun(#dragon_pos{ pos = Pos, lv = PosLv}, {GoodsLevel, EquipInfoL}) ->
                case lists:keyfind(Pos, #goods.cell, EquipList) of
                    #goods{ goods_id = ItemId, level = Level } ->
                        Power= lib_dragon:calc_one_equip_add_power(ItemId, Level, LookOverPs, GoodsStatus),
                        case data_dragon:get_star_and_lv(Level) of
                            {ShowLv, _} -> ok;
                            _ -> ShowLv = 0
                        end,
                        AwakeLv = max(0, Level - ShowLv);
                    _ ->
                        ItemId = 0, Power = 0, ShowLv = 0, AwakeLv = 0
                end,
                EquipInfo = {Pos, PosLv, ItemId, ShowLv, AwakeLv, Power},
                {GoodsLevel + ShowLv, [EquipInfo|EquipInfoL]}
            end,
            {AllLevel, SendEquipInfoL} = lists:foldl(Fun, {0, []}, PosList),
            Args = [RealCombat, AllLevel, lists:reverse(SendEquipInfoL)];
        _ ->
            Args = [0, 0, []]
    end,
    %% ?INFO("Args:~p", [Args]),
    {ok, BinData} = pt_195:write(19509, Args),
    BinData.

%% 打包蜃妖数据
make_eudemons_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{ id = RoleId, eudemons = Eudemons, off = Off, server_id = ServerId } = LookOverPs,
    case Eudemons of
        #eudemons_status{  fight_location_count = MaxNum, eudemons_list = EudemonsList} ->
            case Off#status_off.goods_status of
                undefined ->
                    GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                GoodsStatus ->
                    ok
            end,
            Fun = fun(I, {BattleNum, SumScore, SendInfoL}) ->
                #eudemons_item{ id = Id, state = State, score = Score, equip_list = EquipList } = I,
                case State == ?EUDEMONS_STATE_SLEEP orelse State == ?EUDEMONS_STATE_ACTIVE of
                    true ->
                        {BattleNum, SumScore, SendInfoL};
                    _ ->
                        NewBattleNum = ?IF( State == ? EUDEMONS_STATE_FIGHT, BattleNum + 1, BattleNum),
                        FixEquipList = [begin
                                            GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
                                            #goods{ goods_id = GoodsTypeId, other = #goods_other{ extra_attr = BaseExtraAttr, rating = Rating } } = GoodsInfo,
                                            ExtraAttr = data_attr:unified_format_extra_attr(BaseExtraAttr, []),
                                            %% ?MYLOG("lhh", "ExtraAttr:~p", [ExtraAttr]),
                                            {Pos, GoodsTypeId, StrenLv, Rating, ExtraAttr}
                                        end|| {Pos, GoodsAutoId, StrenLv, _} <- EquipList],
                        Info = {Id, State, Score, FixEquipList},
                        {NewBattleNum, SumScore + Score, [Info|SendInfoL]}
                end
            end,
            {BattleNum, SumScore, SendInfoL} = lists:foldl(Fun, {0, 0, []}, EudemonsList),
            Args = [SumScore, MaxNum, BattleNum, SendInfoL];
        _ ->
            Args = [0, 0, 0, []]
    end,
    %% ?INFO("E:~p", [Args]),
    {ok, BinData} = pt_195:write(19510, Args),
    BinData.

%% 打包神巫妖灵界面数据
make_companion_and_demons_data(LookOverPs, ToName, ToPlayerId) ->
    #player_status{
        status_companion = StatusCompanion, id = RoleId, original_attr = OriginalAttr,
        status_demons = StatusDemons, server_id = ServerId, off = Off
    } = LookOverPs,
    case StatusCompanion of
        #status_companion{ companion_list = CompanionList } ->
            Fun = fun(I, {CompanionCombat, CompanionInfoL}) ->
                #companion_item{
                    companion_id = CompanionId, stage = Stage, star = Star, is_fight = IsFight,
                    skill = SkillL, stage_attr = StageAttr, train_num = TrainNum, train_attr = TrainAttr }  = I,
                ItemAttr = lib_player_attr:add_attr(list, [StageAttr, TrainAttr]),
                Combat = companion_real_power(I, ItemAttr, OriginalAttr),
                Info = {CompanionId, Stage, Star, IsFight, TrainNum, Combat, SkillL},
                NewCompanionCombat = CompanionCombat + Combat,
                {NewCompanionCombat, [Info|CompanionInfoL]}
            end,
            {AllCompanionPower, CompanionArgs} = lists:foldl(Fun, {0, []}, CompanionList);
        _ ->
            AllCompanionPower = 0,
            CompanionArgs = []
    end,
    case StatusDemons of
        #status_demons{ demons_id = BattleId, demons_list = DemonsList } ->
            Fun2 = fun(I, {DemonsCombat, SendInfoL}) ->
                #demons{
                    demons_id = DemonsId, level = Level, star = Star, slot_num = SlotNum,
                    skill_list = SkillList, slot_list = SlotList
                } = I,
                DemonsSkillInfo = [{SkillId, SkillLv, Process, IsActive} ||#demons_skill{skill_id = SkillId, level = SkillLv, process = Process, is_active = IsActive} <- SkillList],
                SlotSkillInfo = [{SkId, SkLv, Slot, Quality, Sort} || #slot_skill{skill_id = SkId, level = SkLv, slot = Slot, quality = Quality, sort = Sort} <- SlotList],
                Info = {DemonsId, Level, Star, SlotNum, 0, DemonsSkillInfo, SlotSkillInfo},
                Combat = lib_demons_util:count_demons_power(LookOverPs, I),
                {DemonsCombat + Combat, [Info|SendInfoL]}
            end,
            {DemonsPower, DemonsInfoList} = lists:foldl(Fun2, {0, []}, DemonsList);
    _ ->
            DemonsPower = 0, DemonsInfoList = [], BattleId = 0
    end,
    case CompanionArgs == [] andalso DemonsInfoList == [] of
        true ->
            skip;
        _ ->
            case Off#status_off.goods_status of
                undefined ->
                    get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
                _ -> ok
            end
    end,
    Args = [AllCompanionPower, CompanionArgs, DemonsPower, BattleId, DemonsInfoList],
    %% ?MYLOG("lhh", "Companion:~p", [{Args}]),
    {ok, BinData} = pt_195:write(19511, Args),
    BinData.

%% 打包御魂界面数据
make_rune_equip_data(LookPlayer, ToName, ToPlayerId) ->
    #player_status{ id = RoleId, server_id = ServerId, off = Off, original_attr = OriginalAttr} = LookPlayer,
    case Off#status_off.goods_status of
        undefined ->
            GoodsStatus = get_goods_status_and_send_tv(RoleId, ToName, ToPlayerId, ServerId);
        GoodsStatus ->
            ok
    end,
    #goods_status{ dict = Dict, rune = Rune } = GoodsStatus,
    case Rune of
        #rune{ skill_lv = SkillLv } ->
            RuneList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict),
            Fun = fun(PosId, AccRuneList) ->
                #rune_pos_con{ condition = ConditionList } = data_rune:get_rune_pos_con(PosId),
                IsOpen = ?IF(lib_rune:check_list(ConditionList, LookPlayer), 1, 0),
                GoodsInfo = lists:keyfind(PosId, #goods.cell, RuneList),
                case IsOpen == 0 of
                    true ->
                        AccRuneList;
                    _ ->
                        if
                            GoodsInfo == false ->
                                [{PosId, 0, 0, 0, 0, 0, []}|AccRuneList];
                            true ->
                                #goods{
                                    id = GoodsId, cell = Pos, goods_id = GoodsTypeId, subtype = GoodsSubType,
                                    color = GoodsColor, level = Level, other = Other
                                } = GoodsInfo,
                                case data_goods_type:get(GoodsTypeId) of
                                    #ets_goods_type{subtype = SubType0, color = Color0} ->
                                        SubType = SubType0,
                                        Color = Color0;
                                    _ ->
                                        SubType = GoodsSubType,
                                        Color = GoodsColor
                                end,
                                #goods_other{optional_data = OptionalData} = Other,
                                AwakeAttr = lib_rune:get_awake_attr(Other, Color),
                                BaseAttrList = lib_rune:count_one_rune_attr(SubType, Color, Level),
                                AttrList = ulists:kv_list_plus_extra([BaseAttrList, AwakeAttr]),
                                F = fun({AttrId, Value}, {AccList, AccLv}) ->
                                    case lists:keyfind(AttrId, 1, OptionalData) of
                                        {_, AwakeLv, _AwakeExp} ->
                                            {[{AttrId, Value, AwakeLv}|AccList], AccLv + AwakeLv};
                                        _ ->
                                            {[{AttrId, Value, 0} | AccList], AccLv}
                                    end
                                end,
                                {LastAttrList, SumAwakeLv} = lists:foldl(F, {[], 0}, AttrList),
                                [{Pos, GoodsId, GoodsTypeId, Color, Level, SumAwakeLv, LastAttrList}|AccRuneList]
                        end
                end
            end,
            SendRuneInfoL = lists:foldl(Fun, [], data_rune:get_rune_pos_list()),
            Power = calc_rune_power(RoleId, Dict, Rune, OriginalAttr),
            Args = [Power, SkillLv, SendRuneInfoL];
        _ ->
            Args = [0, 0, []]
    end,
    %% ?INFO("Companion:~p", [Args]),
    {ok, BinData} = pt_195:write(19512, Args),
    BinData.


%% =========================================
%% common_function
%% =========================================
%% 获取在线玩家的GoodsStatus并发送传闻
get_goods_status_and_send_tv(RoleId, ToName, ToId, ToServerId) ->
    case erlang:get(get_player_info) of
        Val when is_integer(Val) ->
            PreTime = Val;
         _ ->
            PreTime = 0
    end,
    NowSec = utime:unixtime(),
    if
        NowSec - PreTime >= 30 ->
            erlang:put(get_player_info, NowSec),
            LanguageId = urand:list_rand([9, 10, 11, 12, 13]), %% 语言配置额外中的消息id
            lib_chat:send_TV({player, RoleId}, ?MOD_GOODS, LanguageId, [ToName, ToId, ToServerId]);
        true ->
            skip
    end,
   lib_goods_do:get_goods_status().

%% 获取需要取发起申请玩家的相关数据
calc_other_args(?MOD_ILLUSION_DATA, SelfPs) ->
    #player_status{ status_mount = MountStatus} = SelfPs,
    Fun = fun(I, ComparePowerL) ->
        #status_mount{type_id = TypeId, combat = BaseCombat, figure_list = FigureList} = I,
        Fun2 = fun(Figure, SumCombat) ->
            #mount_figure{ combat = Combat } = Figure,
            SumCombat + Combat
        end,
        AllFigureCombat= lists:foldl(Fun2, 0, FigureList),
        LastAllFigureCombat = AllFigureCombat + BaseCombat,
        NewComparePowerL = [{TypeId, LastAllFigureCombat}|ComparePowerL],
        NewComparePowerL
    end,
    MountComparePowerL = lists:foldl(Fun, [], MountStatus),
    OtherArgs = [MountComparePowerL],
    OtherArgs;
calc_other_args(_, _Ps) ->
    [].

%% 特殊处理御魂的战力计算
calc_rune_power(RoleId, GoodsDict, Rune, OriginalAttr) ->
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),  %%获得镶嵌中的符文列表
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),    %%总属性
    EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL} = data_goods:classify_euqip(EquipList),
    WeaponAttr = data_goods:count_goods_attribute(WeaponL),
    ArmorAttr = data_goods:count_goods_attribute(ArmorL),
    OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
    WeaponOtherAttr = data_goods:count_equip_base_other_attribute(WeaponL),
    ArmorOtherAttr = data_goods:count_equip_base_other_attribute(ArmorL),
    OrnamentOtherAttr = data_goods:count_equip_base_other_attribute(OrnamentL),
    RuneAddAttr = Rune#rune.equip_add_ratio_attr,
    RuneSkillAddAttr = Rune#rune.skill_attr,
    NewWeaponAttr = ulists:kv_list_plus_extra([RuneAddAttr, WeaponAttr, WeaponOtherAttr]),
    NewArmorAttr = ulists:kv_list_plus_extra([RuneAddAttr, ArmorAttr, ArmorOtherAttr]),
    NewOrnamentAttr = ulists:kv_list_plus_extra([RuneAttr, OrnamentAttr, OrnamentOtherAttr]),
    LastWeaponAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
    LastArmorAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
    LastOrnamentAttr = lib_rune:count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),
    LastAttr = util:combine_list(RuneAttr ++ LastWeaponAttr ++ LastArmorAttr ++ LastOrnamentAttr ++ RuneSkillAddAttr),
    BaseAttrPower = lib_player:calc_partial_power(OriginalAttr, 0, LastAttr),
    AwakeSkillPower = lib_skill_api:get_skill_power(Rune#rune.skill),
    case data_skill:get(?rune_skill_id, Rune#rune.skill_lv) of
        #skill{lv_data = LvData, career = ?SKILL_CAREER_RUNE} ->
            case LvData of
                #skill_lv{power = SkillPower} -> ok;
                _ -> SkillPower = 0
            end;
        _ -> SkillPower = 0
    end,
    BaseAttrPower + SkillPower + AwakeSkillPower.

calc_revelation_equip_all_attr(GoodsStatus, WearEquipList, Skill, Gathering) ->
    #status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
    EnablePosList = lib_revelation_equip:get_enable_pos(WearEquipList),  %%有效的聚灵孔位
    EnablePosListLength = length(EnablePosList),
    if
        EnablePosListLength >= ?pos_length ->
            {SkillAttr, SkillPower} = lib_revelation_equip:get_skill_attr(Skill);
        true ->
            SkillAttr = [], SkillPower = 0
    end,
    AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ lib_revelation_equip:get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
    {AttrList, SkillPower}.

companion_real_power(Companion, ItemAttr, OriginalAttr) ->
    #companion_item{skill = SkillList} = Companion,
    SkillPower = lib_companion_util:get_skill_power(SkillList),
    Combat = lib_player:calc_partial_power(OriginalAttr, SkillPower, ItemAttr),
    Combat.