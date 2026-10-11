%%-----------------------------------------------------------------------------
%% @Module  :       lib_pet
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-12
%% @Description:    宠物
%%-----------------------------------------------------------------------------
-module(lib_pet).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("pet.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("common_rank.hrl").

-export([
    handle_event/2
    , login/2
    , change_display_status/2
    , use_goods/2
    , upgrade_star/2
    , upgrade_lv/2
    , broadcast_to_scene/1
    , illusion_figure/4
    , active_figure/2
    , figure_upgrade_stage/3
    , count_pet_attr/1
    , get_figure_id/2
    , get_stage_figure_id_from_db/1
    , is_upgrade_lv_goods/1
    , do_upgrade_lv/4
    , get_goods_max_times/2
    , logout/1
    , check_skill_has_learn/2
    , update_aircraft_ps/2
    , pet_aircraft_sql/1
    , get_aircraft_perform_id/2
    , get_aircraft_max_stage/1
    , update_wing_ps/2
    , pet_wing_sql/1
    , get_wing_perform_id/2
    , get_wing_max_stage/1
    , wing_time_out/1
    ,get_pet_equip_pos_lv/3
    ,get_pet_equip/2
    ,change_goods_other/1
    ,get_pet_equip_stage_star/1
    ,pet_equip_new_goods/1
    ,format_other_data/1
    ,get_now_point/4
    ,get_pos_lv_upgrade_cost_list/7
    ,get_cost_num_stage_star/6
    ,cal_equip_rating/2
    ,calc_over_all_rating/2
    ,pet_euip_pos_list_login/1
]).

%% 等级达到后解锁宠物
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        status_pet = OldStatusPet
    } = Player,
    OpenLv = lib_module:get_open_lv(?MOD_PET, 1),
    case Figure#figure.lv == OpenLv orelse (Figure#figure.lv > OpenLv andalso OldStatusPet#status_pet.stage < ?PET_MIN_STAGE) of
        true ->
            db:execute(io_lib:format(?sql_player_pet_insert,
                [RoleId, ?PET_MIN_STAGE, ?PET_MIN_STAR, ?PET_MIN_LV, ?BASE_PET_FIGURE, ?PET_MIN_STAGE, ?DISPLAY])),
            {_SkillAttr, SkillIds} = get_pet_skill(?PET_BASE_SKILL, 0, ?PET_MIN_STAGE),
            PassiveSkills = lib_skill_api:divide_passive_skill(SkillIds),
            case PassiveSkills =/= [] of
                true ->
                    mod_scene_agent:update(Player, [{passive_skill, PassiveSkills}]);
                false -> skip
            end,
            FigureId = get_figure_id(?BASE_PET_FIGURE, ?PET_MIN_STAGE),
            StatusPet = OldStatusPet#status_pet{
                stage = ?PET_MIN_STAGE,
                star = ?PET_MIN_STAR,
                lv = ?PET_MIN_LV,
                illusion_type = ?BASE_PET_FIGURE,
                illusion_id = ?PET_MIN_STAGE,
                figure_id = FigureId,
                skills = SkillIds,
                passive_skills = PassiveSkills,
                display_status = ?DISPLAY,
                battle_attr = #battle_attr{}
                },
            %% 同步到场景玩家并广播
            lib_role:update_role_show(RoleId, [{lb_pet_figure, FigureId}]),
            NewPlayerTmp = count_pet_attr(Player#player_status{status_pet = StatusPet}),
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            broadcast_to_scene(NewPlayer),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player
    end,
    case Figure#figure.lv >= OpenLv of
        true ->
            GTypeIds = data_pet:get_goods_ids(),
            F = fun(GTypeId) ->
                case data_pet:get_goods_cfg(GTypeId) of
                    #pet_goods_cfg{max_times = MaxTimesL} ->
                        TmpL = [Tmp|| {LLim, _HLim, _} = Tmp <- MaxTimesL, Figure#figure.lv == LLim],
                        TmpL =/= [];
                    _ -> false
                end
            end,
            IsUSign = lists:any(F, GTypeIds),
            case IsUSign of
                true ->
                    pp_pet:handle(16512, NewPlayer, []);
                false -> skip
            end;
        false -> skip
    end,
    {ok, NewPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

login(Player, GoodsStatus) ->
    #player_status{id = RoleId} = Player,
    Sql = io_lib:format(?sql_player_pet_select, [RoleId]),
    PetAircraft = pet_aircraft_login(RoleId),
    PetWing = pet_wing_login(RoleId),
    %% 精灵装备
    PetEquip = pet_equip_login(RoleId, GoodsStatus),
    NewPlayer = case db:get_row(Sql) of
        [Stage, Star, Lv, Blessing, Exp, BaseAttrStr, IllusionType, IllusionId, DisplayStatus] ->
            {_SkillAttr, SkillIds} = get_pet_skill(?PET_BASE_SKILL, 0, Stage),
            BaseAttr = util:bitstring_to_term(BaseAttrStr),
            FigureId = get_figure_id(IllusionType, IllusionId),
            TmpStatusPet = #status_pet{
                stage = Stage, star = Star, lv = Lv,
                blessing = Blessing, exp = Exp,
                illusion_type = IllusionType, illusion_id = IllusionId,
                figure_id = FigureId, base_attr = BaseAttr,
                skills = SkillIds, display_status = DisplayStatus,
                battle_attr = #battle_attr{},
                pet_aircraft = PetAircraft,
                pet_wing = PetWing,
                pet_equip = PetEquip
            },
            count_pet_attr(Player#player_status{status_pet = TmpStatusPet});
        _ -> Player#player_status{status_pet = #status_pet{battle_attr = #battle_attr{}, pet_aircraft = PetAircraft, pet_wing = PetWing, pet_equip = PetEquip}}
    end,
    #player_status{status_pet = StatusPet} = NewPlayer,
    Sql1 = io_lib:format(?sql_player_pet_figure_select, [RoleId]),
    {FigureList, FigureAttrL, FigureSkillL}
        = lists:foldl(fun([Id, Stage, Blessing], {TmpFL, TmpFAttrL, TmpFSkillL}) ->
            case data_pet:get_figure_stage_cfg(Id, Stage) of
                #pet_figure_stage_cfg{attr = FStageAttr} -> skip;
                _ -> FStageAttr = []
            end,
            {TmpSkillAttr, TmpSkillIds} = get_pet_skill(?PET_ILLUSION_SKILL, Id, Stage),
            %% 转换技能加成属性的局部属性
            TmpFAttr = lib_player_attr:partial_attr_convert(TmpSkillAttr ++ FStageAttr),
            TmpFAttrR = lib_player_attr:to_attr_record(TmpFAttr),
            TmpFCombat = lib_player:calc_all_power(TmpFAttrR),
            TmpR = #pet_figure{
                        id = Id, stage = Stage,
                        blessing = Blessing, attr = TmpFAttr,
                        skills = TmpSkillIds, combat = TmpFCombat},
            {[TmpR|TmpFL], TmpFAttr ++ TmpFAttrL, TmpSkillIds ++ TmpFSkillL}
        end, {[], [], []}, db:get_all(Sql1)),
    %% 把幻形属性Key相同的Val合并到一起
    LastFigureAttrL = util:combine_list(FigureAttrL),
    PassiveSkills = lib_skill_api:divide_passive_skill(StatusPet#status_pet.skills ++ FigureSkillL),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(StatusPet#status_pet.attr++LastFigureAttrL, ?SP_ATTR_MAP),
    NewStatusPet = StatusPet#status_pet{
        figure_list = FigureList,
        figure_attr = LastFigureAttrL,
        figure_skills = FigureSkillL,
        passive_skills = PassiveSkills,
        special_attr = SpecialAttrMap,
        pet_aircraft = PetAircraft,
        pet_wing = PetWing,
        pet_equip = PetEquip
    },
    NewPlayer#player_status{status_pet = NewStatusPet}.

logout(Player) ->
    #player_status{
        id = RoleId,
        status_pet = StatusMount
    } = Player,
    #status_pet{
        illusion_type = IllusionType,
        illusion_id = SelStage,
        display_status = DisplayStatus,
        pet_aircraft = PetAircraft,
        pet_wing = PetWing
    } = StatusMount,
    db:execute(io_lib:format(?sql_update_pet_illusion_and_display, [IllusionType, SelStage, DisplayStatus, RoleId])),
    pet_aircraft_sql(PetAircraft),
    pet_wing_sql(PetWing).

%%--------------------------------------------------
%% 从数据库获取当前阶级的形象id
%% @param  RoleId 玩家id
%% @return        description
%%--------------------------------------------------
get_stage_figure_id_from_db(RoleId) ->
    Sql = io_lib:format(?sql_player_pet_select, [RoleId]),
    case db:get_row(Sql) of
        [Stage, _Star, _Lv, _Blessing, _Exp, _BaseAttrStr, _IllusionType, _IllusionId, _DisplayStatus] ->
            get_figure_id(?BASE_PET_FIGURE, Stage);
        _ -> 0
    end.

%%--------------------------------------------------
%% 获取宠物解锁的技能列表
%% @param  Type        1:基础技能 2:幻形技能
%% @param  OwnerShipId 归属Id
%% @param  Stage       归属者当前等阶
%% @return             description
%%--------------------------------------------------
get_pet_skill(Type, OwnerShipId, Stage) ->
    SkillIds = data_pet:get_skill_by_type(Type, OwnerShipId),
    do_get_pet_skill(SkillIds, Stage, []).

do_get_pet_skill([], _Stage, LearnSkillIds) ->
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_PET, LearnSkillIds),
    {SkillAttr, LearnSkillIds};
do_get_pet_skill([Id|L], Stage, LearnSkillIds) ->
    #pet_skill_cfg{stage = UnlockStage} = data_pet:get_skill_cfg(Id),
    case Stage >= UnlockStage of
        true ->
            do_get_pet_skill(L, Stage, [Id|LearnSkillIds]);
        false ->
            do_get_pet_skill(L, Stage, LearnSkillIds)
    end.

%% 刷新幻形的技能以及属性信息
refresh_illusion_data(StatusPet) ->
    #status_pet{attr = BaseAttrL, figure_list = FigureList, skills = SkillList} = StatusPet,
    {FAttrList, FSkillList} =
        lists:foldl(fun(#pet_figure{attr = Attr, skills = Skills}, {TmpFAttrL, TmpFSkillL}) ->
            {Attr ++ TmpFAttrL, Skills ++ TmpFSkillL}
        end, {[], []}, FigureList),
    PassiveSkills = lib_skill_api:divide_passive_skill(SkillList ++ FSkillList),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(BaseAttrL++FAttrList, ?SP_ATTR_MAP),
    StatusPet#status_pet{figure_attr = FAttrList, figure_skills = FSkillList, passive_skills = PassiveSkills, special_attr = SpecialAttrMap}.

count_pet_attr(Player) ->
    #player_status{status_pet = StatusPet, skill = SkillStatus} = Player,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    #status_pet{
        stage = Stage,
        star = Star,
        lv = Lv,
        base_attr = BaseAttr,
        skills = SkillIds,
        battle_attr = BattleAttr,
        figure_attr = FigureAttr,
        pet_aircraft = PetAircraft,
        pet_wing = PetWing
    } = StatusPet,
    case data_pet:get_star_cfg(Stage, Star) of
        #pet_star_cfg{attr = StarAttr} -> skip;
        _ -> StarAttr = []
    end,
    case data_pet:get_lv_cfg(Lv) of
        #pet_lv_cfg{attr = LvAttr} -> skip;
        _ -> LvAttr = []
    end,
    case SkillIds =/= [] of
        true ->
            NewSkillIds = SkillIds,
            SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_PET, NewSkillIds);
        false ->
            {SkillAttr, NewSkillIds} = get_pet_skill(?PET_BASE_SKILL, 0, Stage)
    end,
    TalentSkillAttr = lib_skill_api:get_skill_attr2mod(?MOD_PET, SkillTalentList),
    AddPetCraftAttr = PetAircraft#pet_aircraft.add_pet_attr,
    AddpetWingAttr = PetWing#pet_wing.add_pet_attr,
    AttrList = util:combine_list(TalentSkillAttr ++ BaseAttr ++ StarAttr ++ LvAttr ++ SkillAttr ++ AddPetCraftAttr ++ AddpetWingAttr),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(NewAttr++FigureAttr, ?SP_ATTR_MAP),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    NewBaseAttr = BattleAttr#battle_attr{attr = NewAttrR},
    NewStatusPet = StatusPet#status_pet{
        skills = NewSkillIds, attr = NewAttr,
        battle_attr = NewBaseAttr, combat = NewCombat,
        special_attr = SpecialAttrMap
    },
    NewPlayer = Player#player_status{status_pet = NewStatusPet},
    case Player#player_status.scene > 0 of
        true ->
            mod_scene_agent:update(Player, [{pet_battle_attr, NewBaseAttr}]);
        false -> skip
    end,
    %% 刷新排行榜
    %lib_common_rank_api:refresh_common_rank(NewPlayer, ?RANK_TYPE_PET),
    NewPlayer.

%% 获取宠物显示的形象资源id
get_figure_id(IllusionType, Args) ->
    case IllusionType of
        ?ILLUSION_PET_FIGURE ->
            case data_pet:get_figure_cfg(Args) of
                #pet_figure_cfg{figure = FigureId} -> FigureId;
                _ -> 0
            end;
        _ ->
            case data_pet:get_stage_cfg(Args) of
                #pet_stage_cfg{figure = FigureId} -> FigureId;
                _ -> 0
            end
    end.

%% 改变宠物显示状态
%% Type: 0: 隐藏 1: 显示
change_display_status(Player, Type) ->
    #player_status{sid = Sid, id = _RoleId, status_pet = StatusPet} = Player,
    #status_pet{
        stage = Stage, illusion_type = IllusionType,
        illusion_id = IllusionId, display_status = DisplayStatus
        } = StatusPet,
    if
        Type =/= ?HIDE andalso Type =/= ?DISPLAY ->
            NewPlayer = Player, ErrorCode = skip;
        IllusionType == 0 orelse IllusionId == 0 ->
            NewPlayer = Player, ErrorCode = ?ERRCODE(err165_figure_not_active);
        Stage < 1 -> NewPlayer = Player, ErrorCode = ?ERRCODE(err165_figure_not_active);
        Type == DisplayStatus ->
            NewPlayer = Player, ErrorCode = skip;
        true ->
            % db:execute(io_lib:format(?sql_update_pet_display_status, [Type, RoleId])),
            NewStatusPet = StatusPet#status_pet{display_status = Type},
            NewPlayer = Player#player_status{status_pet = NewStatusPet},
            broadcast_to_scene(NewPlayer),
            ErrorCode = ?SUCCESS
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData} = pt_165:write(16504, [ErrorCode, Type]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip
    end,
    {ok, NewPlayer}.

%% 广播给场景玩家
broadcast_to_scene(Player) ->
    #player_status{
        id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, status_pet = StatusPet
    } = Player,
    #status_pet{
        figure_id = FigureId,
        display_status = DisplayStatus,
        pet_aircraft = PetAircraft,
        pet_wing = PetWing
    } = StatusPet,
    #pet_aircraft{
        perform_id = AircraftPerformId
    } = PetAircraft,
    #pet_wing{
        perform_id = WingPerFormId
    } = PetWing,
    mod_scene_agent:update(Player, [{pet_figure, {FigureId, DisplayStatus, AircraftPerformId, WingPerFormId}}]),
    {ok, BinData} = pt_165:write(16501, [RoleId, FigureId, DisplayStatus, AircraftPerformId, WingPerFormId]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).

get_goods_max_times([], _) -> 0;
get_goods_max_times([T|L], RoleLv) ->
    case T of
        {LLim, HLim, Times} when LLim =< RoleLv, RoleLv =< HLim ->
            Times;
        _ ->
           get_goods_max_times(L, RoleLv)
    end.

%% 使用兽魂
use_goods(Player, GTypeId) ->
    case data_pet:get_goods_cfg(GTypeId) of
        #pet_goods_cfg{attr = Attr, max_times = MaxTimesL} ->
            #player_status{id = RoleId, figure = Figure, status_pet = StatusPet} = Player,
            #figure{lv = RoleLv} = Figure,
            #status_pet{stage = Stage, base_attr = BaseAttr, attr = OAttrL} = StatusPet,
            case Stage > 0 of
                true ->
                    MaxTimes = get_goods_max_times(MaxTimesL, RoleLv),
                    Counter = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeId),
                    case Counter < MaxTimes of
                        true ->
                            Cost = [{?TYPE_GOODS, GTypeId, 1}],
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, pet_upgrade_star, "") of
                                {true, NewPlayerTmp} ->
                                    NewBaseAttr = util:combine_list(Attr ++ BaseAttr),
                                    db:execute(io_lib:format(?sql_update_pet_base_attr, [util:term_to_string(NewBaseAttr), RoleId])),
                                    mod_counter:increment(RoleId, ?MOD_GOODS, GTypeId),
                                    NewStatusPet = StatusPet#status_pet{base_attr = NewBaseAttr},
                                    NewPlayerTmp1 = count_pet_attr(NewPlayerTmp#player_status{status_pet = NewStatusPet}),
                                    %% 日志
                                    lib_log_api:log_pet_goods_use(RoleId, GTypeId, Counter + 1, MaxTimes, OAttrL, NewPlayerTmp1#player_status.status_pet#status_pet.attr),
                                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    {ok, ?SUCCESS, NewPlayer};
                                {false, 1003, NewPlayerTmp} ->
                                    {fail, ?ERRCODE(err160_not_enough_cost), NewPlayerTmp};
                                {false, ErrorCode, NewPlayerTmp} -> {fail, ErrorCode, NewPlayerTmp}
                            end;
                        _ -> {fail, ?ERRCODE(err165_max_goods_use_times), Player}
                    end;
                false -> {fail, ?ERRCODE(err165_figure_not_active), Player}
            end;
        _ -> {fail, ?ERRCODE(err_config), Player}
    end.

%% 宠物升星检测
check_upgrade_star(StatusPet) ->
    #status_pet{stage = Stage, star = Star} = StatusPet,
    StageCfg = data_pet:get_stage_cfg(Stage),
    if
        Stage == 0 -> {fail, ?ERRCODE(lv_limit)};
        is_record(StageCfg, pet_stage_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            #pet_stage_cfg{max_star = CurStageMaxStar} = StageCfg,
            #pet_star_cfg{max_blessing = MaxBlessing} = data_pet:get_star_cfg(Stage, Star),
            NextStageCfg = data_pet:get_stage_cfg(Stage + 1),
            if
                MaxBlessing == 0 -> {fail, ?ERRCODE(err165_max_star)};
                Star == CurStageMaxStar andalso is_record(NextStageCfg, pet_stage_cfg) == false ->
                    {fail, ?ERRCODE(err165_max_star)};
                true -> {ok, MaxBlessing}
            end
    end.

%% 宠物升星
upgrade_star(Player, Type) ->
    #player_status{sid = Sid, status_pet = StatusPet} = Player,
    #status_pet{stage = Stage, star = Star, blessing = Blessing} = StatusPet,
    {Code, NewPlayer} = case check_upgrade_star(StatusPet) of
        {ok, MaxBlessing} ->
            case Type of
                1 -> %% 普通道具
                    CostGTypeId = data_pet:get_constant_cfg(1),
                    OnePlus = data_pet:get_constant_cfg(3);
                2 ->
                    CostGTypeId = data_pet:get_constant_cfg(2),
                    OnePlus = data_pet:get_constant_cfg(4)
            end,
            [{_CostGTypeId, OwnNum}] = lib_goods_api:get_goods_num(Player, [CostGTypeId]),
            case OwnNum > 0 of
                true ->
                    NeedCostNum = util:ceil((MaxBlessing - Blessing) / OnePlus),
                    RealCostNum = ?IF(OwnNum >= NeedCostNum, NeedCostNum, OwnNum),
                    BlessingPlus = RealCostNum * OnePlus,
                    {NewStage, NewStar, NewBlessing, TvArgs}
                        = count_star_helper(Stage, Star, Blessing, BlessingPlus, []),
                    Cost = [{?TYPE_GOODS, CostGTypeId, RealCostNum}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, pet_upgrade_star, "") of
                        {true, NewPlayerTmp} ->
                            do_upgrade_star(NewPlayerTmp, NewStage, NewStar, NewBlessing, TvArgs, BlessingPlus, Cost);
                        {false, 1003, NewPlayerTmp} ->
                            {?ERRCODE(err165_not_enough_cost), NewPlayerTmp};
                        {false, ErrorCode, NewPlayerTmp} -> {ErrorCode, NewPlayerTmp}
                    end;
                false ->
                    {?ERRCODE(err165_not_enough_cost), Player}
            end;
        {fail, ErrorCode} -> {ErrorCode, Player}
    end,
    case is_integer(Code) of
        true ->
            {ok, BinData1} = pt_165:write(16500, [Code]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,
    {ok, battle_attr, NewPlayer}.

do_upgrade_star(Player, NewStage, NewStar, NewBlessing, TvArgs, BlessingPlus, Cost) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_pet = StatusPet} = Player,
    #status_pet{
        stage = Stage, star = Star, display_status = DisplayStatus, blessing = Blessing,
        illusion_type = IllusionType, illusion_id = IllusionId, figure_id = FigureId,
        figure_skills = FigureSkills, skills = SkillIds,
        passive_skills = PassiveSkills
    } = StatusPet,
    case NewStage =/= Stage of
        true ->
            NewIllusionId = ?IF(IllusionType == ?BASE_PET_FIGURE, NewStage, IllusionId),
            NewFigureId = get_figure_id(IllusionType, NewIllusionId);
        false ->
            NewIllusionId = IllusionId, NewFigureId = FigureId
    end,
    %% 日志
    lib_log_api:log_pet_upgrade_star(RoleId, Stage, Star, Blessing, BlessingPlus, NewStage, NewStar, NewBlessing, Cost),

    db:execute(io_lib:format(?sql_update_pet_stage_and_star, [NewStage, NewStar, NewBlessing, NewIllusionId, RoleId])),
    case NewStage =/= Stage orelse NewStar =/= Star of
        true ->
            case NewStage =/= Stage of
                true ->
                    lib_role:update_role_show(RoleId, [{lb_pet_figure, get_figure_id(?BASE_PET_FIGURE, NewStage)}]),
                    {_SkillAttr, NewSkillIds} = get_pet_skill(?PET_BASE_SKILL, 0, NewStage),
                    NewPassiveSkills = lib_skill_api:divide_passive_skill(NewSkillIds ++ FigureSkills),
                    case NewPassiveSkills =/= [] of
                        true ->
                            mod_scene_agent:update(Player, [{passive_skill, NewPassiveSkills}]);
                        false -> skip
                    end;
                false -> NewSkillIds = SkillIds, NewPassiveSkills = PassiveSkills
            end,
            NewStatusPet = StatusPet#status_pet{
                                stage = NewStage,
                                star = NewStar,
                                illusion_id = NewIllusionId,
                                figure_id = NewFigureId,
                                blessing = NewBlessing,
                                skills = NewSkillIds,
                                passive_skills = NewPassiveSkills},
            NewPlayerTmp = count_pet_attr(Player#player_status{status_pet = NewStatusPet}),
            case DisplayStatus == ?DISPLAY of
                true ->
                    broadcast_to_scene(NewPlayerTmp);
                false -> skip
            end,
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false ->
            NewStatusPet = StatusPet#status_pet{
                                stage = NewStage,
                                star = NewStar,
                                blessing = NewBlessing},
            NewPlayer = Player#player_status{status_pet = NewStatusPet}
    end,

    lists:foreach(fun(TmpStage) ->
        lib_chat:send_TV({all}, ?MOD_PET, 1, [Figure#figure.name, TmpStage])
    end, TvArgs),

    %% 更新冲榜榜单信息
    lib_rush_rank_api:reflash_rank_by_pet_rush(NewPlayer),
    {ok, BinData} = pt_165:write(16505, [?SUCCESS, NewStage, NewStar, NewBlessing, BlessingPlus]),
    lib_server_send:send_to_sid(Sid, BinData),

    case NewStage =/= Stage of
        true ->
            {ok, LastPlayer} = lib_achievement_api:pet_class_up_event(NewPlayer, NewStage);
        false -> LastPlayer = NewPlayer
    end,

    {ok, LastPlayer}.

count_star_helper(Stage, Star, Blessing, BlessingPlus, TvArgs) ->
    case data_pet:get_star_cfg(Stage, Star) of
        #pet_star_cfg{max_blessing = MaxBlessing} when MaxBlessing > 0 ->
            case data_pet:get_stage_cfg(Stage) of
                #pet_stage_cfg{max_star = MaxStar} ->
                    case Blessing + BlessingPlus >= MaxBlessing of
                        true ->
                            case Star == MaxStar of
                                true -> %% 升阶
                                    NewStage = Stage + 1,
                                    NewStar = ?PET_MIN_STAR,
                                    NewTvArgs = case data_pet:get_stage_cfg(NewStage) of
                                        #pet_stage_cfg{is_tv = IsTv} when IsTv > 0 ->
                                            [NewStage|TvArgs];
                                        _ -> TvArgs
                                    end;
                                false ->
                                    NewStage = Stage,
                                    NewStar = Star + 1,
                                    NewTvArgs = TvArgs
                            end,
                            NewBlessingPlus = Blessing + BlessingPlus - MaxBlessing,
                            count_star_helper(NewStage, NewStar, 0, NewBlessingPlus, NewTvArgs);
                        false ->
                            {Stage, Star, Blessing + BlessingPlus, TvArgs}
                    end;
                _ -> {Stage, Star, Blessing + BlessingPlus, TvArgs}
            end;
        _ ->
            {Stage, Star, Blessing + BlessingPlus, TvArgs}
    end.

%% 检测物品是否属于升级消耗的道具
is_upgrade_lv_goods(GTypeId) when is_integer(GTypeId) ->
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{type = GType, goods_id = GTypeId, color = Color} ->
            is_upgrade_lv_goods_helper(GType, GTypeId, Color);
        _ ->
            {fail, ?ERRCODE(err165_not_cost_res)}
    end;
is_upgrade_lv_goods(GoodsInfo) when is_record(GoodsInfo, goods) ->
    #goods{type = GType, goods_id = GTypeId, color = Color} = GoodsInfo,
    is_upgrade_lv_goods_helper(GType, GTypeId, Color).

is_upgrade_lv_goods_helper(GType, GTypeId, Color) ->
    case GType of
        ?GOODS_TYPE_EQUIP ->
            EquipStage = lib_equip_api:get_equip_stage(GTypeId),
            EquipStar = lib_equip_api:get_equip_star(GTypeId),
            case data_pet:get_goods_exp(EquipStage, Color, EquipStar, 0) of
                #pet_goods_exp_cfg{exp = Exp} -> {ok, Exp};
                _ ->
                    {fail, ?ERRCODE(err165_not_cost_res)}
            end;
        ?GOODS_TYPE_PET ->
            case data_pet:get_goods_exp(0, 0, 0, GTypeId) of
                #pet_goods_exp_cfg{exp = Exp} -> {ok, Exp};
                _ ->
                    {fail, ?ERRCODE(err165_not_cost_res)}
            end;
        _ ->
            {fail, ?ERRCODE(err165_not_cost_res)}
    end.

check_specify_goods([], CostList, ExpPlus) -> {ok, CostList, ExpPlus};
check_specify_goods([{GoodsId, CostNum}|L], CostList, ExpPlus) ->
    case lib_goods_api:get_goods_info(GoodsId) of
        #goods{goods_id = GTypeId, num = Num} ->
            case is_upgrade_lv_goods(GTypeId) of
                {ok, Exp} ->
                    RealCostNum = min(Num, CostNum),
                    check_specify_goods(L, [{GTypeId, RealCostNum}|CostList], ExpPlus + RealCostNum * Exp);
                {fail, ErrorCode} -> {fail, ErrorCode}
            end;
        _ -> {fail, ?ERRCODE(err150_no_goods)}
    end.

%% 宠物升级
upgrade_lv(Player, SpecifyGoodsCost) ->
    #player_status{sid = Sid, figure = Figure, status_pet = StatusPet} = Player,
    #status_pet{stage = Stage, lv = Lv} = StatusPet,
    LvCfg = data_pet:get_lv_cfg(Lv),
    NextLvCfg = data_pet:get_lv_cfg(Lv + 1),
    if
        Stage == 0 -> NewPlayer = Player, ErrorCode = ?ERRCODE(lv_limit);
        % SpecifyGoodsCost == [] andalso NormalGoodsCost == [] ->
        %     NewPlayer = Player, ErrorCode = ?ERRCODE(err165_sel_null_goods);
        is_record(LvCfg, pet_lv_cfg) == false ->
            NewPlayer = Player, ErrorCode = ?ERRCODE(err_config);
        is_record(NextLvCfg, pet_lv_cfg) == false ->
            NewPlayer = Player, ErrorCode = ?ERRCODE(err165_max_lv);
        LvCfg#pet_lv_cfg.max_exp == 0 ->
            NewPlayer = Player, ErrorCode = ?ERRCODE(err165_max_lv);
        true ->
            case check_specify_goods(SpecifyGoodsCost, [], 0) of
                {ok, CostList, ExpPlus} ->
                    case cost_specify_mat(Player, SpecifyGoodsCost) of
                        1 ->
                            VipPlusRatio = lib_vip:get_vip_privilege(Figure#figure.vip, ?MOD_PET, 1),
                            NewPlayer = do_upgrade_lv(Player, round(ExpPlus * (1 + VipPlusRatio)), VipPlusRatio, CostList),
                            ErrorCode = ok;
                        ErrorCode -> NewPlayer = Player, ErrorCode
                    end;
                {fail, ErrorCode} -> NewPlayer = Player, ErrorCode
            end
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData} = pt_165:write(16500, [ErrorCode]),
            lib_server_send:send_to_sid(Sid, BinData);
        false -> skip
    end,
    {ok, battle_attr, NewPlayer}.

do_upgrade_lv(Player, ExpPlus, VipPlusRatio, CostL) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_pet = StatusPet} = Player,
    #status_pet{lv = Lv, exp = Exp} = StatusPet,
    {NewLv, NewExp, TvArgs} = do_upgrade_lv_helper(Lv, Exp, ExpPlus, []),
    %% 日志
    lib_log_api:log_pet_upgrade_lv(RoleId, Lv, Exp, ExpPlus, VipPlusRatio, NewLv, NewExp, CostL),
    db:execute(io_lib:format(?sql_update_pet_lv, [NewLv, NewExp, RoleId])),
    NewStatusPet = StatusPet#status_pet{lv = NewLv, exp = NewExp},
    case NewLv =/= Lv of
        true ->
            lists:foreach(fun(TmpLv) ->
                lib_chat:send_TV({all}, ?MOD_PET, 2, [Figure#figure.name, TmpLv])
            end, TvArgs),
            NewNewPlayerTmp = count_pet_attr(Player#player_status{status_pet = NewStatusPet}),
            NewPlayer = lib_player:count_player_attribute(NewNewPlayerTmp),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
            {ok, LastPlayer} = lib_achievement_api:pet_lv_up_event(NewPlayer, NewLv);
        false ->
            LastPlayer = Player#player_status{status_pet = NewStatusPet}
    end,
    {ok, BinData} = pt_165:write(16506, [?SUCCESS, NewLv, NewExp, ExpPlus]),
    lib_server_send:send_to_sid(Sid, BinData),
    LastPlayer.

do_upgrade_lv_helper(Lv, Exp, ExpPlus, TvArgs) ->
    case data_pet:get_lv_cfg(Lv) of
        #pet_lv_cfg{max_exp = MaxExp} when MaxExp > 0 ->
            case Exp + ExpPlus >= MaxExp of
                true ->
                    NewLv = Lv + 1,
                    NewTvArgs = case data_pet:get_lv_cfg(NewLv) of
                        #pet_lv_cfg{is_tv = IsTv} when IsTv > 0 ->
                            [NewLv|TvArgs];
                        _ -> TvArgs
                    end,
                    do_upgrade_lv_helper(NewLv, 0, Exp + ExpPlus - MaxExp, NewTvArgs);
                false ->
                    {Lv, Exp + ExpPlus, TvArgs}
            end;
        _ ->
            {Lv, Exp + ExpPlus, TvArgs}
    end.

cost_specify_mat(Player, SpecifyGoodsCost) ->
    case SpecifyGoodsCost =/= [] of
        true ->
            lib_goods_api:delete_more_by_list(Player, SpecifyGoodsCost, pet_upgrade_lv);
        _ -> 1
    end.

illusion_figure(?BASE_PET_FIGURE, _RoleId, StatusPet, SelStage) ->
    #status_pet{stage = Stage} = StatusPet,
    StageCfg = data_pet:get_stage_cfg(SelStage),
    if
        SelStage > Stage -> {fail, ?ERRCODE(err165_figure_not_active)};
        is_record(StageCfg, pet_stage_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            FigureId = get_figure_id(?BASE_PET_FIGURE, SelStage),
            % db:execute(io_lib:format(?sql_update_pet_illusion, [?BASE_PET_FIGURE, SelStage, RoleId])),
            NewStatusPet = StatusPet#status_pet{
                illusion_type = ?BASE_PET_FIGURE,
                illusion_id = SelStage,
                figure_id = FigureId
            },
            {ok, NewStatusPet}
    end;
illusion_figure(?ILLUSION_PET_FIGURE, _RoleId, StatusPet, SelId) ->
    #status_pet{figure_list = FigureList} = StatusPet,
    IsActive = lists:keyfind(SelId, #pet_figure.id, FigureList),
    FigureCfg = data_pet:get_figure_cfg(SelId),
    if
        IsActive == false -> {fail, ?ERRCODE(err165_figure_not_active)};
        is_record(FigureCfg, pet_figure_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            FigureId = get_figure_id(?ILLUSION_PET_FIGURE, SelId),
            % db:execute(io_lib:format(?sql_update_pet_illusion, [?ILLUSION_PET_FIGURE, SelId, RoleId])),
            NewStatusPet = StatusPet#status_pet{
                illusion_type = ?ILLUSION_PET_FIGURE,
                illusion_id = SelId,
                figure_id = FigureId
            },
            {ok, NewStatusPet}
    end.

active_figure(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, status_pet = StatusPet} = Player,
    #status_pet{figure_list = FigureList} = StatusPet,
    case lists:keyfind(Id, #pet_figure.id, FigureList) of
        false ->
            case data_pet:get_figure_cfg(Id) of
                #pet_figure_cfg{goods_id = ActiveGId, goods_num = ActiveGNum} ->
                    Cost = [{?TYPE_GOODS, ActiveGId, ActiveGNum}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, pet_active_figure, "") of
                        {true, NewPlayerTmp} ->
                            %% 替换为新的形象
                            NewIllusionId = Id,
                            NewFigureId = get_figure_id(?ILLUSION_PET_FIGURE, Id),
                            %% 日志
                            lib_log_api:log_pet_figure_upgrade_stage(RoleId, Id, 1, 0, 0, 0, 1, 0, Cost),

                            db:execute(io_lib:format(?sql_update_pet_illusion_info, [RoleId, Id, 1, 0])),
                            % db:execute(io_lib:format(?sql_update_pet_illusion, [?ILLUSION_PET_FIGURE, Id, RoleId])),

                            case data_pet:get_figure_stage_cfg(Id, 1) of
                                #pet_figure_stage_cfg{attr = FStageAttr} -> skip;
                                _ -> FStageAttr = []
                            end,
                            %% 同步新解锁的被动技能到玩家场景
                            {SkillAttr, UnlockSkills} = get_pet_skill(?PET_ILLUSION_SKILL, Id, 1),
                            PassiveSkillsAdd = lib_skill_api:divide_passive_skill(UnlockSkills),
                            case PassiveSkillsAdd =/= [] of
                                true ->
                                    mod_scene_agent:update(NewPlayerTmp, [{passive_skill, PassiveSkillsAdd}]);
                                false -> skip
                            end,
                            FAttr = lib_player_attr:partial_attr_convert(SkillAttr ++ FStageAttr),
                            FAttrR = lib_player_attr:to_attr_record(FAttr),
                            FCombat = lib_player:calc_all_power(FAttrR),
                            TmpR = #pet_figure{id = Id, stage = 1, attr = FAttr, skills = UnlockSkills, combat = FCombat},
                            NewFigureList = [TmpR|FigureList],
                            NewStatusPet = refresh_illusion_data(StatusPet#status_pet{illusion_type = ?ILLUSION_PET_FIGURE, illusion_id = NewIllusionId, figure_id = NewFigureId, figure_list = NewFigureList}),
                            NewPlayer = NewPlayerTmp#player_status{status_pet = NewStatusPet},
                            NewPlayer1 = lib_player:count_player_attribute(NewPlayer),
                            broadcast_to_scene(NewPlayer1),
                            lib_player:send_attribute_change_notify(NewPlayer1, ?NOTIFY_ATTR),
                            lib_server_send:send_to_sid(Sid, pt_165, 16509, [?SUCCESS]),
                            {ok, LastPlayer} = lib_achievement_api:pet_acti_figure_event(NewPlayer1, Id);
                        {false, ErrorCode, LastPlayer} ->
                            lib_server_send:send_to_sid(Sid, pt_165, 16500, [ErrorCode])
                    end;
                _ ->
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_165, 16500, [?ERRCODE(missing_config)])
            end;
        _ -> LastPlayer = Player %% 已经激活过
    end,
    {ok, battle_attr, LastPlayer}.

%% 宠物幻形升星检测
check_figure_upgrade_stage(StatusPet, SelId) ->
    #status_pet{stage = PetStage, figure_list = FigureList} = StatusPet,
    FigureInfo = lists:keyfind(SelId, #pet_figure.id, FigureList),
    FigureCfg = data_pet:get_figure_cfg(SelId),
    if
        is_record(FigureCfg, pet_figure_cfg) == false -> {fail, ?ERRCODE(err_config)};
        FigureInfo == false -> {fail, ?ERRCODE(err165_figure_not_active)};
        true ->
            #pet_figure{stage = Stage} = FigureInfo,
            #pet_figure_cfg{stage_lim = StageLim} = FigureCfg,
            StageCfg = data_pet:get_figure_stage_cfg(SelId, Stage),
            NextStageCfg = data_pet:get_figure_stage_cfg(SelId, Stage + 1),
            if
                PetStage < StageLim -> {fail, ?FAIL};
                is_record(StageCfg, pet_figure_stage_cfg) == false ->
                    {fail, ?ERRCODE(err_config)};
                is_record(NextStageCfg, pet_figure_stage_cfg) == false ->
                    {fail, ?ERRCODE(err165_figure_max_stage)};
                true ->
                    #pet_figure_stage_cfg{blessing = NeedBlessing} = StageCfg,
                    if
                        NeedBlessing =< 0 ->
                            {fail, ?ERRCODE(err165_figure_max_stage)};
                        true -> {ok, StageCfg, FigureInfo}
                    end
            end
    end.

%% 宠物幻形升阶
figure_upgrade_stage(Player, Id, Type) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_pet = StatusPet} = Player,
    #status_pet{figure_list = FigureList} = StatusPet,
    case check_figure_upgrade_stage(StatusPet, Id) of
        {ok, StageCfg, FigureInfo} ->
            #pet_figure_stage_cfg{blessing = NeedBlessing} = StageCfg,
            #pet_figure_cfg{name = FigureName} = FigureCfg = data_pet:get_figure_cfg(Id),
            #pet_figure{stage = Stage, blessing = Blessing} = FigureInfo,
            case Type of
                1 -> %% 普通道具
                    CostGTypeId = data_pet:get_constant_cfg(5),
                    OnePlus = data_pet:get_constant_cfg(7);
                2 ->
                    CostGTypeId = data_pet:get_constant_cfg(6),
                    OnePlus = data_pet:get_constant_cfg(8);
                3 ->
                    CostGTypeId = FigureCfg#pet_figure_cfg.goods_id,
                    OnePlus = FigureCfg#pet_figure_cfg.goods_exp
            end,
            [{_CostGTypeId, OwnNum}] = lib_goods_api:get_goods_num(Player, [CostGTypeId]),
            case OwnNum > 0 of
                true ->
                    NeedCostNum = util:ceil((NeedBlessing - Blessing) / OnePlus),
                    RealCostNum = ?IF(OwnNum >= NeedCostNum, NeedCostNum, OwnNum),
                    BlessingPlus = RealCostNum * OnePlus,
                    {NewStage, NewBlessing, TvArgs}
                        = count_figure_stage_helper(Id, Stage, Blessing, BlessingPlus, []),
                    Cost = [{?TYPE_GOODS, CostGTypeId, RealCostNum}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, pet_figure_upgrade_stage, "") of
                        {true, NewPlayerTmp} ->

                            %% 日志
                            lib_log_api:log_pet_figure_upgrade_stage(RoleId, Id, 2, Stage, Blessing, BlessingPlus, NewStage, NewBlessing, Cost),

                            ErrorCode = nothing,
                            NewFigureInfo = do_figure_upgrade_stage(FigureInfo, NewStage, NewBlessing),
                            NewFigureList = lists:keystore(Id, #pet_figure.id, FigureList, NewFigureInfo),
                            NewStatusPet = StatusPet#status_pet{figure_list = NewFigureList},
                            #pet_figure{stage = NewStage, blessing = NewBlessing, skills = UnlockSkills} = NewFigureInfo,
                            db:execute(io_lib:format(?sql_update_pet_illusion_info, [RoleId, Id, NewStage, NewBlessing])),
                            case NewStage =/= Stage of
                                true ->
                                    LastStatusPet = refresh_illusion_data(NewStatusPet),
                                    %% 同步新解锁的被动技能到玩家场景
                                    PassiveSkills = lib_skill_api:divide_passive_skill(UnlockSkills),
                                    case PassiveSkills =/= [] of
                                        true ->
                                            mod_scene_agent:update(NewPlayerTmp, [{passive_skill, PassiveSkills}]);
                                        false -> skip
                                    end,
                                    LastPlayer = lib_player:count_player_attribute(NewPlayerTmp#player_status{status_pet = LastStatusPet}),
                                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR);
                                false ->
                                    LastPlayer = NewPlayerTmp#player_status{status_pet = NewStatusPet}
                            end,
                            lists:foreach(fun(TmpStage) ->
                                lib_chat:send_TV({all}, ?MOD_PET, 3, [Figure#figure.name, FigureName, TmpStage])
                            end, TvArgs),
                            {ok, BinData} = pt_165:write(16510, [?SUCCESS, NewStage, NewBlessing, BlessingPlus]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        {false, 1003, LastPlayer} ->
                            ErrorCode = ?ERRCODE(err165_not_enough_cost);
                        {false, ErrorCode, LastPlayer} -> skip
                    end;
                false ->
                    ErrorCode = ?ERRCODE(err165_not_enough_cost),
                    LastPlayer = Player
            end;
        {fail, ErrorCode} -> LastPlayer = Player
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData1} = pt_165:write(16500, [ErrorCode]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,
    {ok, battle_attr, LastPlayer}.

do_figure_upgrade_stage(FigureInfo, NewStage, NewBlessing) ->
    #pet_figure{id = Id, stage = Stage} = FigureInfo,
    case NewStage =/= Stage of
        true ->
            case data_pet:get_figure_stage_cfg(Id, NewStage) of
                #pet_figure_stage_cfg{attr = FStageAttr} -> skip;
                _ -> FStageAttr = []
            end,
            {SkillAttr, UnlockSkills} = get_pet_skill(?PET_ILLUSION_SKILL, Id, NewStage),
            FAttr = lib_player_attr:partial_attr_convert(SkillAttr ++ FStageAttr),
            FAttrR = lib_player_attr:to_attr_record(FAttr),
            FCombat = lib_player:calc_all_power(FAttrR),
            FigureInfo#pet_figure{
                stage = NewStage,
                blessing = NewBlessing,
                attr = FAttr,
                skills = UnlockSkills,
                combat = FCombat};
        false ->
            FigureInfo#pet_figure{blessing = NewBlessing}
    end.

count_figure_stage_helper(Id, Stage, Blessing, BlessingPlus, TvArgs) ->
    case data_pet:get_figure_stage_cfg(Id, Stage) of
        #pet_figure_stage_cfg{blessing = MaxBlessing} when MaxBlessing > 0 ->
            case Blessing + BlessingPlus >= MaxBlessing of
                true ->
                    NewStage = Stage + 1,
                    case data_pet:get_figure_stage_cfg(Id, NewStage) of
                        #pet_figure_stage_cfg{is_tv = IsTv} ->
                            NewTvArgs = ?IF(IsTv =< 0, TvArgs, [NewStage|TvArgs]),
                            NewBlessingPlus = Blessing + BlessingPlus - MaxBlessing,
                            count_figure_stage_helper(Id, NewStage, 0, NewBlessingPlus, NewTvArgs);
                        _ ->
                            {Stage, Blessing + BlessingPlus, TvArgs}
                    end;
                false ->
                    {Stage, Blessing + BlessingPlus, TvArgs}
            end;
        _ ->
            {Stage, Blessing + BlessingPlus, TvArgs}
    end.

check_skill_has_learn(StatusPet, SkillId) ->
    #status_pet{
        illusion_type = _IllusionType,
        skills = SkillList,
        figure_skills = FigureSkillL
    } = StatusPet,
    lists:member(SkillId,  SkillList ++ FigureSkillL).

update_aircraft_ps(NewAircraftInfo, Ps) ->
    #player_status{
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_aircraft = PetAircraft
    } = StatusPet,
    #pet_aircraft{
        aircraft_list = AircraftList,
        show_id = ShowId,
        if_show = IfShow
    } = PetAircraft,
    #aircraft_info{
        aircraft_id = NewAircraftId
    } = NewAircraftInfo,
    NewAircraftList = lists:keystore(NewAircraftId, #aircraft_info.aircraft_id, AircraftList, NewAircraftInfo),
    {AircraftAttrList, PassiveSkillList, AttrPetAttr} = get_aircraft_attr_skills(NewAircraftList),
    case lists:keyfind(NewAircraftId, #aircraft_info.aircraft_id, AircraftList) of
        false -> %% 第一次激活该飞行器自动使用
            NewShowId = NewAircraftId,
            case AircraftList of %% 首个激活直接显示
                [] ->
                    NewIfShow = 1;
                _ ->
                    NewIfShow = IfShow
            end;
        _ ->
            NewShowId = ShowId,
            NewIfShow = IfShow
    end,
    NewPerfromId = get_aircraft_perform_id(NewShowId, NewIfShow),
    NewPetAircraft = PetAircraft#pet_aircraft{
        aircraft_list = NewAircraftList,
        aircraft_attr = AircraftAttrList,
        aircraft_skills = PassiveSkillList,
        add_pet_attr = AttrPetAttr,
        show_id = NewShowId,
        perform_id = NewPerfromId,
        if_show = NewIfShow
    },
    pet_aircraft_sql(NewPetAircraft),
    NewStatusPet = StatusPet#status_pet{
        pet_aircraft = NewPetAircraft
    },
    NewNewPlayerTmp = count_pet_attr(Ps#player_status{status_pet = NewStatusPet}),
    NewPs = lib_player:count_player_attribute(NewNewPlayerTmp),
    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
    case PassiveSkillList of
        [] ->
            skip;
        _ ->
            mod_scene_agent:update(NewPs, [{passive_skill, PassiveSkillList}])
    end,
    lib_common_rank_api:refresh_rank_by_pet_aircraft(NewPs),
    NewPs.

%% return: {飞行器属性, 飞行器被动技能, 增加的精灵属性}
get_aircraft_attr_skills(NewAircraftList) ->
    F = fun(AircraftInfo, {Attr1, Skills1}) ->
        #aircraft_info{
            aircraft_id = AircraftId,
            stage = Stage
        } = AircraftInfo,
        PetAircraftInfoCon = data_pet_aircraft:get_pet_aircraft_info_con(AircraftId),
        #pet_aircraft_info_con{
            skill_list = SkillConList
        } = PetAircraftInfoCon,
        F1 = fun({SkillId, OpenStage}, SkillList1) ->
            case Stage >= OpenStage of
                true ->
                    [SkillId|SkillList1];
                false ->
                    SkillList1
            end
        end,
        SkillList = lists:foldl(F1, [], SkillConList),
        AircraftStageCon = data_pet_aircraft:get_pet_aircraft_stage_con(AircraftId, Stage),
        #pet_aircraft_stage_con{
            attr_list = AttrList
        } = AircraftStageCon,
        {[AttrList|Attr1], lists:umerge(SkillList, Skills1)}
    end,
    {BaseAttrs, AllSkillList} = lists:foldl(F, {[], []}, NewAircraftList),
    AddAircraftAttrs = lib_skill:count_skill_attr_with_mod_id(?MOD_PET_AIRCRAFT, AllSkillList),
    AircraftAttrList = ulists:kv_list_plus_extra([AddAircraftAttrs|BaseAttrs]),
    PassiveSkillList = lib_skill_api:divide_passive_skill(AllSkillList),
    AttrPetAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_PET, AllSkillList),
    {AircraftAttrList, PassiveSkillList, AttrPetAttr}.

pet_aircraft_login(RoleId) ->
    ReSql = io_lib:format(?sql_pet_aircraft_info_select, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            AircraftList = [],
            AttrList = [],
            SkillList = [],
            AttrPetAttr = [];
        AircraftSqlList ->
            F = fun(SqlInfo, AircraftList1) ->
                [_RoleId, AircraftId, Stage] = SqlInfo,
                AircraftInfo = #aircraft_info{
                    aircraft_id = AircraftId,
                    stage = Stage
                },
                [AircraftInfo|AircraftList1]
            end,
            AircraftList = lists:foldl(F, [], AircraftSqlList),
            {AttrList, SkillList, AttrPetAttr} = get_aircraft_attr_skills(AircraftList)
    end,
    ReSql1 = io_lib:format(?sql_pet_aircraft_player_select, [RoleId]),
    case db:get_row(ReSql1) of
        [_RoleId, ShowId, IfShow] ->
            PerfromId = get_aircraft_perform_id(ShowId, IfShow);
        _ ->
            ShowId = 0,
            PerfromId = 0,
            IfShow = 0
    end,
    PetAircraft = #pet_aircraft{
        role_id = RoleId,
        aircraft_list = AircraftList,
        aircraft_attr = AttrList,
        aircraft_skills = SkillList,
        add_pet_attr = AttrPetAttr,
        show_id = ShowId,
        perform_id = PerfromId,
        if_show = IfShow
    },
    PetAircraft.

pet_aircraft_sql(PetAircraft) ->
    #pet_aircraft{
        role_id = RoleId,
        aircraft_list = AircraftList,
        show_id = ShowId,
        if_show = IfShow
    } = PetAircraft,
    case AircraftList of
        [] ->
            skip;
        _ ->
            SqlStrList = [begin
                #aircraft_info{
                    aircraft_id = AircraftId,
                    stage = Stage
                } = AircraftInfo,
                io_lib:format("(~p, ~p, ~p)", [RoleId, AircraftId, Stage])
            end||AircraftInfo <- AircraftList],
            SqlUseList = ulists:list_to_string(SqlStrList, ","),
            ReSql = io_lib:format(?sql_pet_aircraft_info_replace, [SqlUseList]),
            db:execute(ReSql)
    end,
    ReSql1 = io_lib:format(?sql_pet_aircraft_player_replace, [RoleId, ShowId, IfShow]),
    db:execute(ReSql1).

get_aircraft_perform_id(AircraftId, IfShow) ->
    case IfShow of
        0 ->
            PerfromId = 0;
        _ ->
            case data_pet_aircraft:get_pet_aircraft_info_con(AircraftId) of
                [] ->
                    PerfromId = 0;
                #pet_aircraft_info_con{perform_id = PerfromId} ->
                    skip
            end
    end,
    PerfromId.

get_aircraft_max_stage(Ps) ->
    #player_status{
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_aircraft = PetAircraft
    } = StatusPet,
    #pet_aircraft{
        aircraft_list = AircraftList
    } = PetAircraft,
    F = fun(AirCraftInfo, {MaxAircraftId1, MaxStage1}) ->
        #aircraft_info{
            aircraft_id = AircraftId,
            stage = Stage
        } = AirCraftInfo,
        case AircraftId > MaxAircraftId1  of
            false ->
                {MaxAircraftId1, MaxStage1};
            true ->
                case data_pet_aircraft:get_pet_aircraft_info_con(AircraftId) of
                    #pet_aircraft_info_con{type = 1} ->
                        {AircraftId, Stage};
                    _ ->
                        {MaxAircraftId1, MaxStage1}
                end
        end
    end,
    lists:foldl(F, {0, 0}, AircraftList).

update_wing_ps(NewWingInfo, Ps) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_wing = PetWing
    } = StatusPet,
    #pet_wing{
        wing_list = WingList,
        show_id = ShowId,
        if_show = IfShow,
        limit_timer = OldLimitTimer,
        wing_skills = OldPassiveSkillList
    } = PetWing,
    #wing_info{
        wing_id = NewWingId
    } = NewWingInfo,
    NewNewWingInfoList1 = lists:keystore(NewWingId, #wing_info.wing_id, WingList, NewWingInfo),
    case lists:keyfind(NewWingId, #wing_info.wing_id, WingList) of
        false -> %% 第一次激活该翅膀自动使用
            NewShowId = NewWingId,
            case WingList of %% 首个激活直接显示
                [] ->
                    NewIfShow = 1;
                _ ->
                    NewIfShow = IfShow
            end;
        _ ->
            NewShowId = ShowId,
            NewIfShow = IfShow
    end,
    NewPerfromId = get_wing_perform_id(NewShowId, NewIfShow),
    NowTime = utime:unixtime(),
    {EndTime, NewLimitWingId, NewNewWingInfoList} = get_wing_limit_wing_id(NewNewWingInfoList1, NowTime, RoleId, 0, 0, []),
    {WingAttrList, PassiveSkillList, AttrPetAttr} = get_wing_attr_skills(NewNewWingInfoList),
    util:cancel_timer(OldLimitTimer),
    case NewLimitWingId of
        0 ->
            NewLimitTimer = 0;
        _ ->
            NewLimitTimer = erlang:send_after((EndTime-NowTime)*1000, self(), {'mod', lib_pet, wing_time_out, []})
    end,
    NewPetWing = PetWing#pet_wing{
        wing_list = NewNewWingInfoList,
        wing_attr = WingAttrList,
        wing_skills = PassiveSkillList,
        add_pet_attr = AttrPetAttr,
        show_id = NewShowId,
        perform_id = NewPerfromId,
        if_show = NewIfShow,
        limit_wing_id = NewLimitWingId,
        limit_timer = NewLimitTimer
    },
    pet_wing_sql(NewPetWing),
    NewStatusPet = StatusPet#status_pet{
        pet_wing = NewPetWing
    },
    NewNewPlayerTmp = count_pet_attr(Ps#player_status{status_pet = NewStatusPet}),
    NewPs = lib_player:count_player_attribute(NewNewPlayerTmp),
    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
    DeleteSkillList = get_passive_delete_skill_list(OldPassiveSkillList, PassiveSkillList, []),
    case DeleteSkillList of
        [] ->
            UpdateSceneList1 = [];
        _ ->
            UpdateSceneList1 = [{delete_passive_skill, DeleteSkillList}]
    end,
    case PassiveSkillList of
        [] ->
            UpdateSceneList = UpdateSceneList1;
        _ ->
            UpdateSceneList = [{passive_skill, PassiveSkillList}|UpdateSceneList1]
    end,
    case UpdateSceneList of
        [] ->
            skip;
        _ ->
            mod_scene_agent:update(NewPs, UpdateSceneList)
    end,
    lib_common_rank_api:refresh_rank_by_pet_wing(NewPs),
    NewPs.

%% return: {翅膀属性, 翅膀被动技能, 增加的精灵属性}
get_wing_attr_skills(NewWingList) ->
    F = fun(WingInfo, {Attr1, Skills1}) ->
        #wing_info{
            wing_id = WingId,
            stage = Stage
        } = WingInfo,
        PetWingInfoCon = data_pet_wing:get_pet_wing_info_con(WingId),
        #pet_wing_info_con{
            skill_list = SkillConList
        } = PetWingInfoCon,
        F1 = fun({SkillId, OpenStage}, SkillList1) ->
            case Stage >= OpenStage of
                true ->
                    [SkillId|SkillList1];
                false ->
                    SkillList1
            end
        end,
        SkillList = lists:foldl(F1, [], SkillConList),
        WingStageCon = data_pet_wing:get_pet_wing_stage_con(WingId, Stage),
        #pet_wing_stage_con{
            attr_list = AttrList
        } = WingStageCon,
        {[AttrList|Attr1], lists:umerge(SkillList, Skills1)}
    end,
    {BaseAttrs, AllSkillList} = lists:foldl(F, {[], []}, NewWingList),
    AddWingAttrs = lib_skill:count_skill_attr_with_mod_id(?MOD_PET_WING, AllSkillList),
    WingAttrList = ulists:kv_list_plus_extra([AddWingAttrs|BaseAttrs]),
    PassiveSkillList = lib_skill_api:divide_passive_skill(AllSkillList),
    AttrPetAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_PET, AllSkillList),
    {WingAttrList, PassiveSkillList, AttrPetAttr}.

pet_wing_login(RoleId) ->
    ReSql = io_lib:format(?sql_pet_wing_info_select, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            WingList = [],
            AttrList = [],
            SkillList = [],
            AttrPetAttr = [],
            LimitWingId = 0,
            LimitTimer = 0;
        WingSqlList ->
            F = fun(SqlInfo, WingList1) ->
                [_RoleId, WingId, Stage, EndTime] = SqlInfo,
                WingInfo = #wing_info{
                    wing_id = WingId,
                    stage = Stage,
                    end_time = EndTime
                },
                [WingInfo|WingList1]
                end,
            WingList1 = lists:foldl(F, [], WingSqlList),
            NowTime = utime:unixtime(),
            {EndTime, LimitWingId, WingList} = get_wing_limit_wing_id(WingList1, NowTime, RoleId, 0, 0, []),
            {AttrList, SkillList, AttrPetAttr} = get_wing_attr_skills(WingList),
            case LimitWingId of
                0 ->
                    LimitTimer = 0;
                _ ->
                    LimitTimer = erlang:send_after((EndTime-NowTime)*1000, self(), {'mod', lib_pet, wing_time_out, []})
            end
    end,
    ReSql1 = io_lib:format(?sql_pet_wing_player_select, [RoleId]),
    case db:get_row(ReSql1) of
        [_RoleId, ShowId, IfShow] ->
            PerfromId = get_wing_perform_id(ShowId, IfShow);
        _ ->
            ShowId = 0,
            PerfromId = 0,
            IfShow = 0
    end,
    PetWing = #pet_wing{
        role_id = RoleId,
        wing_list = WingList,
        wing_attr = AttrList,
        wing_skills = SkillList,
        add_pet_attr = AttrPetAttr,
        show_id = ShowId,
        perform_id = PerfromId,
        if_show = IfShow,
        limit_wing_id = LimitWingId,
        limit_timer = LimitTimer
    },
    PetWing.

pet_wing_sql(PetWing) ->
    #pet_wing{
        role_id = RoleId,
        wing_list = WingList,
        show_id = ShowId,
        if_show = IfShow
    } = PetWing,
    case WingList of
        [] ->
            skip;
        _ ->
            SqlStrList = [begin
                              #wing_info{
                                  wing_id = WingId,
                                  stage = Stage,
                                  end_time = EndTime
                              } = WingInfo,
                              io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, WingId, Stage, EndTime])
                          end||WingInfo <- WingList],
            SqlUseList = ulists:list_to_string(SqlStrList, ","),
            ReSql = io_lib:format(?sql_pet_wing_info_replace, [SqlUseList]),
            db:execute(ReSql)
    end,
    ReSql1 = io_lib:format(?sql_pet_wing_player_replace, [RoleId, ShowId, IfShow]),
    db:execute(ReSql1).

get_wing_perform_id(WingId, IfShow) ->
    case IfShow of
        0 ->
            PerfromId = 0;
        _ ->
            case data_pet_wing:get_pet_wing_info_con(WingId) of
                [] ->
                    PerfromId = 0;
                #pet_wing_info_con{perform_id = PerfromId} ->
                    skip
            end
    end,
    PerfromId.

get_wing_max_stage(Ps) ->
    #player_status{
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_wing = PetWing
    } = StatusPet,
    #pet_wing{
        wing_list = WingList
    } = PetWing,
    F = fun(AirCraftInfo, {MaxWingId1, MaxStage1}) ->
        #wing_info{
            wing_id = WingId,
            stage = Stage
        } = AirCraftInfo,
        case WingId > MaxWingId1  of
            false ->
                {MaxWingId1, MaxStage1};
            true ->
                case data_pet_wing:get_pet_wing_info_con(WingId) of
                    #pet_wing_info_con{type = 1} ->
                        {WingId, Stage};
                    _ ->
                        {MaxWingId1, MaxStage1}
                end
        end
    end,
    lists:foldl(F, {0, 0}, WingList).

get_wing_limit_wing_id([T|G], NowTime, RoleId, EndTime, LimitWingId, NewNewWingInfoList) ->
    #wing_info{
        wing_id = WingId,
        end_time = NewEndTime
    } = T,
    #pet_wing_info_con{
        time_limit = TimeLimit
    } = data_pet_wing:get_pet_wing_info_con(WingId),
    case TimeLimit of
        0 ->
            get_wing_limit_wing_id(G, NowTime, RoleId, EndTime, LimitWingId, [T|NewNewWingInfoList]);
        _ ->
            %% 两秒误差
            case NowTime+2 >= NewEndTime of
                true ->
                    ReSql = io_lib:format(?sql_pet_wing_info_delete, [WingId]),
                    db:execute(ReSql),
                    {ok, BinData1} = pt_165:write(16534, [?SUCCESS, WingId]),
                    lib_server_send:send_to_uid(RoleId, BinData1),
                    lib_log_api:log_pet_wing_time_out(RoleId, WingId, 0, 0),
                    get_wing_limit_wing_id(G, NowTime, RoleId, EndTime, LimitWingId, NewNewWingInfoList);
                false ->
                    case EndTime of
                        0 ->
                            get_wing_limit_wing_id(G, NowTime, RoleId, NewEndTime, WingId, [T|NewNewWingInfoList]);
                        _ ->
                            case NewEndTime < EndTime of
                                false ->
                                    get_wing_limit_wing_id(G, NowTime, RoleId, EndTime, LimitWingId, [T|NewNewWingInfoList]);
                                true ->
                                    get_wing_limit_wing_id(G, NowTime, RoleId, NewEndTime, WingId, [T|NewNewWingInfoList])
                            end
                    end
            end
    end;
get_wing_limit_wing_id([], _NowTime, _RoleId, EndTime, LimitWingId, NewNewWingInfoList) ->
    {EndTime, LimitWingId, NewNewWingInfoList}.

wing_time_out(Ps) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_wing = PetWing
    } = StatusPet,
    #pet_wing{
        limit_wing_id = OldLimitWingId,
        limit_timer = OldlimitTimer,
        show_id = OldShowId,
        perform_id = OldPerformId,
        if_show = OldIfShow,
        wing_list = WingList,
        wing_skills = OldPassiveSkillList
    } = PetWing,
    timer:cancel(OldlimitTimer),
    NewWingInfoList1 = lists:keydelete(OldLimitWingId, #wing_info.wing_id, WingList),
    ReSql = io_lib:format(?sql_pet_wing_info_delete, [OldLimitWingId]),
    db:execute(ReSql),
    NowTime = utime:unixtime(),
    {MinEndTime, NewLimitWingId, NewNewWingInfoList} = get_wing_limit_wing_id(NewWingInfoList1, NowTime, RoleId, 0, 0, []),
    {WingAttrList, PassiveSkillList, AttrPetAttr} = get_wing_attr_skills(NewNewWingInfoList),
    case NewLimitWingId of
        0 ->
            NewLimitTimer = 0;
        _ ->
            NewLimitTimer = erlang:send_after((MinEndTime-NowTime)*1000, self(), {'mod', lib_pet, wing_time_out, []})
    end,
    case OldShowId of
        OldLimitWingId ->
            UseWingIdList = [WingId1||#wing_info{wing_id = WingId1} <- NewNewWingInfoList, begin
                #pet_wing_info_con{
                    type = Type
                } = data_pet_wing:get_pet_wing_info_con(WingId1),
                Type =:= 1
            end],
            case UseWingIdList of
                [] ->
                    NewShowId = 0,
                    NewPerformId = 0,
                    NewIfShow = 0;
                _ ->
                    NewShowId = lists:max(UseWingIdList),
                    #pet_wing_info_con{
                        perform_id = NewPerformId
                    } = data_pet_wing:get_pet_wing_info_con(NewShowId),
                    NewIfShow = OldIfShow
            end;
        _ ->
            NewShowId = OldShowId,
            NewPerformId = OldPerformId,
            NewIfShow = OldIfShow
    end,
    NewPetWing = PetWing#pet_wing{
        wing_list = NewNewWingInfoList,
        wing_attr = WingAttrList,
        wing_skills = PassiveSkillList,
        add_pet_attr = AttrPetAttr,
        show_id = NewShowId,
        perform_id = NewPerformId,
        if_show = NewIfShow,
        limit_wing_id = NewLimitWingId,
        limit_timer = NewLimitTimer
    },
    pet_wing_sql(NewPetWing),
    NewStatusPet = StatusPet#status_pet{
        pet_wing = NewPetWing
    },
    NewNewPlayerTmp = count_pet_attr(Ps#player_status{status_pet = NewStatusPet}),
    NewPs = lib_player:count_player_attribute(NewNewPlayerTmp),
    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
    DeleteSkillList = get_passive_delete_skill_list(OldPassiveSkillList, PassiveSkillList, []),
    case DeleteSkillList of
        [] ->
            UpdateSceneList1 = [];
        _ ->
            UpdateSceneList1 = [{delete_passive_skill, DeleteSkillList}]
    end,
    case PassiveSkillList of
        [] ->
            UpdateSceneList = UpdateSceneList1;
        _ ->
            UpdateSceneList = [{passive_skill, PassiveSkillList}|UpdateSceneList1]
    end,
    case UpdateSceneList of
        [] ->
            skip;
        _ ->
            mod_scene_agent:update(NewPs, UpdateSceneList)
    end,
    broadcast_to_scene(NewPs),
    {ok, BinData1} = pt_165:write(16534, [?SUCCESS, OldLimitWingId]),
    lib_server_send:send_to_uid(RoleId, BinData1),
    lib_common_rank_api:refresh_rank_by_pet_wing(NewPs),
    lib_log_api:log_pet_wing_time_out(RoleId, OldLimitWingId, OldShowId, NewShowId),
    NewPs.

get_passive_delete_skill_list([T|G], PassiveSkillList, DeleteSkillList) ->
    {SkillId, _SkillLv} = T,
    case lists:keyfind(SkillId, 1, PassiveSkillList) of
        false ->
            get_passive_delete_skill_list(G, PassiveSkillList, [T|DeleteSkillList]);
%%            [T|DeleteSkillList];
        _ ->
            get_passive_delete_skill_list(G, PassiveSkillList, DeleteSkillList)
    end;
get_passive_delete_skill_list([], _PassiveSkillList, DeleteSkillList) ->
    DeleteSkillList.

get_pet_equip_pos_lv(AllPoint, Pos, PEStage) ->
    #pet_equip_stage_con{
        limit_pos_lv = LimitPosLv
    } = data_pet_equip:get_pet_equip_stage_con(Pos, PEStage),
    PosLvList = data_pet_equip:get_pet_equip_pos_lv_list(Pos),
    PosLv1 = get_pet_equip_pos_lv_1(PosLvList, AllPoint, Pos, 0, 0),
    case PosLv1 > LimitPosLv of
        true ->
            IfMax = 1,
            PosLv = LimitPosLv;
        false ->
            IfMax = 0,
            PosLv = PosLv1
    end,
    NowPoint = get_now_point(0, PosLv, Pos, 0),
    PosPoint = max(0, (AllPoint - NowPoint)),
    {PosLv, PosPoint, IfMax}.

get_now_point(PosLv, PosLv, Pos, NowPoint) ->
    #pet_equip_pos_lv_con{
        exp = Exp
    } = data_pet_equip:get_pet_equip_pos_lv_con(Pos, PosLv),
    NowPoint+Exp;
get_now_point(PosLv1, PosLv, Pos, NowPoint) ->
    #pet_equip_pos_lv_con{
        exp = Exp
    } = data_pet_equip:get_pet_equip_pos_lv_con(Pos, PosLv1),
    get_now_point(PosLv1+1, PosLv, Pos, NowPoint+Exp).

get_pet_equip_pos_lv_1([T|G], AllPoint, Pos, PosLv, NowPoint) ->
    #pet_equip_pos_lv_con{
        exp = Exp
    } = data_pet_equip:get_pet_equip_pos_lv_con(Pos, T),
    NewNowPoint = NowPoint + Exp,
    case AllPoint >= NewNowPoint of
        false ->
            PosLv;
        true ->
            get_pet_equip_pos_lv_1(G, AllPoint, Pos, T, NewNowPoint)
    end;
get_pet_equip_pos_lv_1([], _AllPoint, _Pos, PosLv, _NowPoint) ->
    PosLv.

get_pet_equip(Ps, GS) ->
    #player_status{
        id = RoleId,
        status_pet = StatusPet
    } = Ps,
    #status_pet{
        pet_equip = PetEquip
    } = StatusPet,
    #goods_status{
        dict = Dict,
        pet_equip_pos_list = PetEquipPosList
    } = GS,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_PET_EQUIP, Dict),
    PetEquipAttr = get_pet_equip_attr(PetEquipWearList, PetEquipPosList, [], 0, 0, 0),
    NewPetEquip = PetEquip#pet_equip{
        pet_equip_attr = PetEquipAttr
    },
    NewStatusPet = StatusPet#status_pet{
        pet_equip = NewPetEquip
    },
    NewPs = Ps#player_status{
        status_pet = NewStatusPet
    },
    NewPs.

get_pet_equip_attr([T|G], PetEquipPosList, AttrList, ALLPosLv, AllStage, AllStar) ->
    #goods{
        cell = Pos,
        other = #goods_other{
            optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar]
        }
    } = T,
    case lists:keyfind(Pos, #pet_equip_pos.pos, PetEquipPosList) of
        false ->
            AllPoint = 0;
        #pet_equip_pos{pet_equip_point = AllPoint} ->
            skip
    end,
    {PosLv, _Point, _IfMax} = get_pet_equip_pos_lv(AllPoint, Pos, PEStage),
    #pet_equip_pos_lv_con{
        attr_list = AttrListPosLv
    } = data_pet_equip:get_pet_equip_pos_lv_con(Pos, PosLv),
    #pet_equip_stage_con{
        attr_list = AttrListStage
    } = data_pet_equip:get_pet_equip_stage_con(Pos, PEStage),
    #pet_equip_star_con{
        attr_list = AttrListStar
    } = data_pet_equip:get_pet_equip_star_con(Pos, PEStar),
    get_pet_equip_attr(G, PetEquipPosList, [AttrListPosLv, AttrListStage, AttrListStar|AttrList], ALLPosLv+PosLv, AllStage+PEStage, AllStar+PEStar);
get_pet_equip_attr([], _PetEquipPosList, AttrList, ALLPosLv, AllStage, AllStar) ->
    %% 计算全身额外属性加成
    TotalPosLvAttr = lib_equip:get_12_equip_award(ALLPosLv, ?WHOLE_AWARD_PET_EQUIP_POS_LV),
    TotalStageAttr = lib_equip:get_12_equip_award(AllStage, ?WHOLE_AWARD_PET_EQUIP_STAGE),
    TotalStarAttr = lib_equip:get_12_equip_award(AllStar, ?WHOLE_AWARD_PET_EQUIP_STAR),
    lib_player_attr:add_attr(list, [TotalPosLvAttr, TotalStageAttr, TotalStarAttr|AttrList]).

change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

format_other_data(#goods{type = ?GOODS_TYPE_PET_EQUIP, other = Other}) ->
    #goods_other{optional_data = T} = Other,
    T;
format_other_data(_) -> [].

get_pet_equip_stage_star(GoodsInfo) ->
    #goods{
        goods_id = GoodsTypeId,
        type = Type,
        other = #goods_other{
            optional_data = OptionalData
        }
    } = GoodsInfo,
    case Type of
        ?GOODS_TYPE_PET_EQUIP ->
            case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                [] ->
                    PEStage = 0,
                    PEStar = 0;
                _ ->
                    [_, PEStage, PEStar] = OptionalData
            end;
        _ ->
            PEStage = 0,
            PEStar = 0
    end,
    {PEStage, PEStar}.

pet_equip_new_goods(GoodsInfo) ->
    #goods{
        goods_id = GoodsTypeId,
        subtype = SubType,
        other = GoodsOther
    } = GoodsInfo,
    case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
        [] ->
            GoodsOther;
        #pet_equip_goods_con{stage = PEStage, star = PEStar} ->
            GoodsOther#goods_other{
                rating = cal_equip_rating(SubType, [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar]),
                optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar]
            }
    end.

pet_euip_pos_list_login(RoleId) ->
    ReSql = io_lib:format(?sql_pet_equip_pos_select, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            PetEquipPosList = [];
        SqlList ->
            PetEquipPosList = [begin
                [_RoleId, Pos, PetEquipPosPoint] = SqlInfo,
                #pet_equip_pos{
                    pos = Pos,
                    pet_equip_point = PetEquipPosPoint
                }
            end||SqlInfo <- SqlList]
    end,
    PetEquipPosList.

pet_equip_login(RoleId, GoodsStatus) ->
    #goods_status{
        dict = Dict,
        pet_equip_pos_list = PetEquipPosList
    } = GoodsStatus,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_PET_EQUIP, Dict),
    PetEquipAttr = get_pet_equip_attr(PetEquipWearList, PetEquipPosList, [], 0, 0, 0),
    PetEquip = #pet_equip{
        role_id = RoleId,
        pet_equip_attr = PetEquipAttr
    },
    PetEquip.

get_pos_lv_upgrade_cost_list([T|G], NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint) ->
    case lists:keyfind(T, #goods.id, PetEquipBagList) of
        false ->
            get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint);
        GoodsInfo1 ->
            #goods{
                goods_id = GoodsTypeId1,
                subtype = SubType1,
                other = GoodsOther1,
                num = GoodsNum1
            } = GoodsInfo1,
            case lists:member(GoodsTypeId1, PEGoodsTypeIdList) of
                false ->
                    get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint);
                true ->
                    #goods_other{
                        optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage1, PEStar1]
                    } = GoodsOther1,
                    #pet_equip_stage_con{
                        exp = AddExpStage
                    } = data_pet_equip:get_pet_equip_stage_con(SubType1, PEStage1),
                    #pet_equip_star_con{
                        exp = AddExpStar
                    } = data_pet_equip:get_pet_equip_star_con(SubType1, PEStar1),
                    NewAddPoint = AddExpStage + AddExpStar + AddPoint,
                    case AllPoint + NewAddPoint >= NowLimitPoint of
                        true ->
                            {[{GoodsInfo1, GoodsNum1}|CostList], AddExpStage + AddExpStar + AddPoint};
                        false ->
                            get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, [{GoodsInfo1, GoodsNum1}|CostList], NewAddPoint)
                    end
            end
    end;
get_pos_lv_upgrade_cost_list([], _NowLimitPoint, _PetEquipBagList, _PEGoodsTypeIdList, _AllPoint, CostList, AddPoint) ->
    {CostList, AddPoint}.

get_cost_num_stage_star(PETypeMax, PETypeMax, _Pos, _GoodsNum, _Type, CostNum) ->
    CostNum;
get_cost_num_stage_star(PEType, PETypeMax, Pos, GoodsNum, Type, CostNum) ->
    case Type of
        1 ->
            #pet_equip_stage_con{
                cost_list = [{_GoodsType, _StageGoodsTypeId, CostNum1}|_]
            } = data_pet_equip:get_pet_equip_stage_con(Pos, PEType);
        _ ->
            #pet_equip_star_con{
                cost_list = [{_GoodsType, _StageGoodsTypeId, CostNum1}|_]
            } = data_pet_equip:get_pet_equip_star_con(Pos, PEType)
    end,
    case GoodsNum >= CostNum+CostNum1 of
        false ->
            CostNum;
        true ->
            get_cost_num_stage_star(PEType+1, PETypeMax, Pos, GoodsNum, Type, CostNum+CostNum1)
    end.

cal_pet_equip_rating([T|G], PEStage, RatingTmp) ->
    NewRatingTmp = case T of
        {OneAttrId, OneAttrVal} ->
            OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, PEStage),
            RatingTmp + OneAttrRating * OneAttrVal;
        {_Color, OneAttrId, OneAttrVal} ->
            OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, PEStage),
            RatingTmp + OneAttrRating * OneAttrVal;
        _ ->
            RatingTmp
    end,
    cal_pet_equip_rating(G, PEStage, NewRatingTmp);
cal_pet_equip_rating([], _PEStage, NewRatingTmp) ->
    NewRatingTmp.

cal_equip_rating(Pos, OptionalData) ->
    case OptionalData of
        [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar] ->
            #pet_equip_stage_con{
                attr_list = AttrListStage
            } = data_pet_equip:get_pet_equip_stage_con(Pos, PEStage),
            #pet_equip_star_con{
                attr_list = AttrListStar
            } = data_pet_equip:get_pet_equip_star_con(Pos, PEStar),
            AttrList = AttrListStage ++ AttrListStar,
            Rating = cal_pet_equip_rating(AttrList, PEStage, 0),
            round(Rating);
        _ ->
            0
    end.

calc_over_all_rating(GoodsStatus, GoodsInfo) ->
    #goods_status{
        pet_equip_pos_list = PetEquipPosList
    } = GoodsStatus,
    #goods{
        cell = Pos,
        other = #goods_other{
            optional_data = [?GOODS_OTHER_KEY_PET_EQUIP, PEStage, PEStar]
        }
    } = GoodsInfo,
    case lists:keyfind(Pos, #pet_equip_pos.pos, PetEquipPosList) of
        false ->
            AllPoint = 0;
        #pet_equip_pos{pet_equip_point = AllPoint} ->
            skip
    end,
    {PosLv, _Point, _IfMax} = get_pet_equip_pos_lv(AllPoint, Pos, PEStage),
    #pet_equip_pos_lv_con{
        attr_list = AttrListPosLv
    } = data_pet_equip:get_pet_equip_pos_lv_con(Pos, PosLv),
    #pet_equip_stage_con{
        attr_list = AttrListStage
    } = data_pet_equip:get_pet_equip_stage_con(Pos, PEStage),
    #pet_equip_star_con{
        attr_list = AttrListStar
    } = data_pet_equip:get_pet_equip_star_con(Pos, PEStar),
    AttrList = AttrListPosLv ++ AttrListStage ++ AttrListStar,
    Rating = cal_pet_equip_rating(AttrList, PEStage, 0),
    round(Rating).