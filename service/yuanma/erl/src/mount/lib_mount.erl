%%-----------------------------------------------------------------------------
%% @Module  :       mount.hrl
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-9
%% @Description:    坐骑
%%-----------------------------------------------------------------------------
-module(lib_mount).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("mount.hrl").
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
-include("fashion.hrl").
-include("common_rank.hrl").
-include("battle.hrl").

%%-export([
%%    handle_event/2
%%    , login/1
%%    , change_ride_status/4
%%    , use_goods/4
%%    , upgrade_star/4
%%    , broadcast_to_scene/3
%%    , illusion_figure/5
%%    , active_figure/4
%%    , figure_upgrade_stage/4
%%    , count_mount_attr/1
%%    , get_stage_figure_id_from_db/1
%%    , get_goods_max_times/2
%%    , logout/1
%%    , get_mount_all_attr/1
%%    , get_all_passive_skills/1
%%    , get_mount_is_ride/1
%%    , get_mount_combat/1
%%    , get_status_star/2
%%    , get_mount_stage/1
%%]).
%%    , get_mount_figure_id/1
-compile(export_all).

%% 坐骑系统外观变化事件
event(figure_change, [Player, TypeId]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    lib_mount:broadcast_to_scene(TypeId, Player), % 发送16001 协议
    lib_role:update_role_show(RoleId, [{figure, Player#player_status.figure}]),
    lib_team_api:update_team_mb(Player, [{figure, Figure}]),
    mod_guild:update_guild_member_attr(Player#player_status.id, [{figure, Player#player_status.figure}]),
    ok;
event(_, _) -> ok.

%%%% 等级达到后解锁外形
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    F = fun(TypeId, PS) ->
        #player_status{figure = Figure, status_mount = OldStatusMount} = PS,
        OldStatusType = lists:keyfind(TypeId, #status_mount.type_id, OldStatusMount),
        OpenLv = data_mount:get_constant_cfg(mapping_type_to_cfg_id(TypeId)), % 各种外形类开放等级
        IsMember = lists:member(TypeId, ?APPERENCE),
        case OldStatusType =/= false of
            true -> PS;
            false ->
                case Figure#figure.lv >= OpenLv andalso IsMember == true of
                    true ->
                        do_base_active(TypeId, PS);
                    false -> PS
                end
        end
    end,
    LastPlayer = lists:foldl(F, Player, ?LV_ACTIVE_APPERENCE),
    {ok, LastPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

handle_event_figure(TypeId, Player) ->
    #player_status{figure = Figure} = Player,
    OpenLv = data_mount:get_constant_cfg(mapping_type_to_cfg_id(TypeId)), % 各种坐骑类开放等级
    case Figure#figure.lv >= OpenLv of % 外观形象等级 >= 开放等级
        true ->
            GTypeIds = data_mount:get_goods_ids(TypeId),
            F = fun(GTypeId) ->
                case data_mount:get_goods_cfg(TypeId, GTypeId) of
                    #mount_goods_cfg{max_times = MaxTimesL} ->
                        TmpL = [Tmp || {LLim, _HLim, _} = Tmp <- MaxTimesL, Figure#figure.lv == LLim],
                        TmpL =/= [];
                    _ -> false
                end
                end,
            IsUSign = lists:any(F, GTypeIds),
            case IsUSign of
                true ->
                    pp_mount:handle(16011, Player, [TypeId]);
                false -> skip
            end;
        false -> skip
    end.

do_base_active(TypeId, PS) ->
    #player_status{id = RoleId, figure = Figure, status_mount = OldStatusMount, original_attr = OriginalAttr} = PS,
    db:execute(io_lib:format(?sql_player_mount_insert,
        [RoleId, TypeId, ?MIN_STAGE, ?MIN_STAR, ?BASE_MOUNT_FIGURE, ?MIN_STAGE, 0, ?RIDE_STATUS])),
    {_SkillAttr, SkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, ?MIN_STAGE, ?MIN_STAR),
    %% 坐骑类升级养成线初始化各项状态数据
    {UpgradeLv, UpgradeExp, UpgradeSkill} = lib_mount_upgrade_sys:init_data(TypeId),

    %% 分离出战斗计算的被动
    PassiveSkills = lib_skill_api:divide_passive_skill(SkillIds ++ UpgradeSkill),
    case PassiveSkills =/= [] of
        true ->
            mod_scene_agent:update(PS, [{passive_skill, PassiveSkills}]);
        false -> skip
    end,
    %% 骑乘属性
    RideAttr =
        case data_mount:get_stage_cfg(TypeId, ?MIN_STAGE, Figure#figure.career) of
            #mount_stage_cfg{ride_attr = Attr} -> Attr;
            _ -> []
        end,
    %% 初始化坐骑类状态
    InitStatusMount =
        case TypeId == ?PET_ID of
            true ->
                PetId = 1,
                db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, PetId, 1, 0, 0, 0])),
                {FStarAttr, FAttr, PetUnlockSkills, FCombat} = count_figure_attr_origin_combat(TypeId, PetId, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, [], OriginalAttr),
                %%      % 更新被动技能
                PassiveSkillsAdd = lib_skill_api:divide_passive_skill(PetUnlockSkills), % 分离被动技能
                case PassiveSkillsAdd =/= [] of
                    true ->
                        mod_scene_agent:update(PS, [{passive_skill, PassiveSkillsAdd}]);
                    false -> skip
                end,
                TmpMountFigure = #mount_figure{type_id = ?PET_ID, id = PetId, stage = ?ILLUSION_MIN_STAGE, attr = FAttr, star_attr = FStarAttr, skills = PetUnlockSkills, combat = FCombat},
                %% 初始化坐骑类状态
                #status_mount{
                    type_id = TypeId,
                    stage = ?MIN_STAGE,
                    star = ?MIN_STAR,
                    illusion_type = ?ILLUSION_MOUNT_FIGURE,
                    illusion_id = 1,
                    skills = SkillIds,
                    passive_skills = PassiveSkills,
                    ride_attr = RideAttr,
                    is_ride = ?RIDE_STATUS,
                    figure_list = [TmpMountFigure],
                    upgrade_sys_skill = UpgradeSkill, upgrade_sys_exp = UpgradeExp, upgrade_sys_level = UpgradeLv
                };
            false ->
                %% 初始化坐骑类状态
                #status_mount{
                    type_id = TypeId,
                    stage = ?MIN_STAGE,
                    star = ?MIN_STAR,
                    illusion_type = ?BASE_MOUNT_FIGURE,
                    illusion_id = 1,
                    skills = SkillIds,
                    passive_skills = PassiveSkills,
                    ride_attr = RideAttr,
                    is_ride = ?RIDE_STATUS,
                    figure_list = [],
                    upgrade_sys_skill = UpgradeSkill, upgrade_sys_exp = UpgradeExp, upgrade_sys_level = UpgradeLv
                }
        end,
    IllType = InitStatusMount#status_mount.illusion_type,
    FigureId = get_figure_id(TypeId, IllType, 1, Figure#figure.career), % 获得形象Id
    InitStatusMount1 = InitStatusMount#status_mount{figure_id = FigureId},
    NewFigure = update_role_show(RoleId, Figure, {TypeId, FigureId, 0}), % 更新玩家排行榜展示Ets
    NextStatusType = refresh_illusion_data(InitStatusMount1), % 更新figure_attr figure_skill
    NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, OldStatusMount, NextStatusType),
    NewPlayerTmp = count_mount_attr(PS#player_status{status_mount = NewStatusMount, figure = NewFigure}), % 计算属性
    NewPlayer = broadcast_to_scene(TypeId, NewPlayerTmp),
    handle_event_figure(TypeId, NewPlayer), % 推送魔晶信息
    pp_mount:handle(16002, NewPlayer, [TypeId]), % 推送坐骑信息
    pp_mount:handle(16006, NewPlayer, [TypeId]), % 推送外形信息
    % lib_task_api:train_something(NewPlayer, InitStatusMount#status_mount.type_id,
    %     InitStatusMount#status_mount.stage, InitStatusMount#status_mount.star), %% 任务
    NewPS = lib_mount_api:active_mount_api(NewPlayer, NextStatusType, TypeId),
    NewPS1 = lib_mount_api:power_change_event(NewPS, TypeId),
    NewPS1.


%% 离线登录 （没有校正数据）
offline_login(Player, GoodsStatus) ->
    #player_status{id = RoleId, figure = InitFigure} = Player,
    MountSelectList = db:get_all(io_lib:format(?sql_player_mount_select, [RoleId])),
    NewSelectList = [{Type, Sg, Sr, Ble, Base, IllTy, IllId, IllColor, IR, FigID, Etime, AutoB} || [Type, Sg, Sr, Ble, Base, IllTy, IllId, IllColor, IR, FigID, Etime, AutoB] <- MountSelectList],
    DevourSelList = db:get_all(io_lib:format(?sql_mount_devour_all_select, [RoleId])),
    NewDevourSelList = [{Type1, DevLv, DevExp} || [Type1, DevLv, DevExp] <- DevourSelList],
    UpgradeDataL = db:get_all(io_lib:format(?SQL_SELECT_ALL_PLAYER_MOUNT_LEVEL, [RoleId])),
    UpgradeDataList = [erlang:list_to_tuple(I) || I <- UpgradeDataL],
    F1 = fun(TypeId, {PS, TmpFigure}) ->
        _NewPlayer =
            case lists:keyfind(TypeId, 1, NewSelectList) of
                {_Type, Stage, Star, Blessing, BaseAttrStr, IllusionType, IllusionId, IllusionColor, IsRide, FashionFigureID, _Endtime, _AutoBuy} ->
                    %% 计算通过兽魂增加的基础属性
                    {_SkillAttr, SkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, Stage, Star),
                    BaseAttr = util:bitstring_to_term(BaseAttrStr),
                    RideAttr =
                        case data_mount:get_stage_cfg(TypeId, Stage, InitFigure#figure.career) of
                            #mount_stage_cfg{ride_attr = Ride_Attr} -> Ride_Attr;
                            _ -> []
                        end,
                    FigureId = case FashionFigureID of
                                   1 -> 0;
                                   _ -> get_figure_id(TypeId, IllusionType, IllusionId, InitFigure#figure.career)
                               end,
                    Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
		    % 吞噬
                    {DevourLv, DevourExp} =
                        case lists:keyfind(TypeId, 1, NewDevourSelList) of
                            {TypeId, DLv, DExp} -> {DLv, DExp};
                            _ ->
                                {?INIT_DEVOUR_LV, ?INIT_DEVOUR_EXP}
                        end,

                    %% 升级养成线系统
                    {UpgradeLevel, UpgradeExp, UpgradeSkillL} =
                        case lists:keyfind(TypeId, 1, UpgradeDataList) of
                            {TypeId, ULv, UExp, UpgradeSkill} ->
                                {ULv, UExp, util:bitstring_to_term(UpgradeSkill)};
                            _ ->
                                AutoFixSkillList = lib_mount_upgrade_sys:auto_active_skill_by_level(TypeId, ?INIT_UPGRADE_LV, []),
                                {?INIT_UPGRADE_LV, ?INIT_UPGRADE_EXP, AutoFixSkillList}
                        end,


                    TmpStatusMount = #status_mount{
                        type_id = TypeId,
                        stage = Stage, star = Star, blessing = Blessing,
                        illusion_type = IllusionType, illusion_id = IllusionId, 
                        illusion_color = Color, figure_id = FigureId,
                        base_attr = BaseAttr, ride_attr = RideAttr,
                        skills = SkillIds, is_ride = IsRide,
                        devour_lv = DevourLv, devour_exp = DevourExp,
                        upgrade_sys_level = UpgradeLevel, upgrade_sys_exp = UpgradeExp,
                        upgrade_sys_skill = UpgradeSkillL
                    },
                    #player_status{status_mount = OldStatusMount} = PS,

                    NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, OldStatusMount, TmpStatusMount),
                    %%                    NewPS = count_mount_attr(TypeId, PS#player_status{status_mount = NewStatusMount}),
                    NewPS = PS#player_status{status_mount = NewStatusMount},
                    NewTmpFigure = [{TypeId, FigureId, Color} | TmpFigure],
                    {NewPS, NewTmpFigure};
                _ -> % 当该外形没有数据库数据
                    {PS, TmpFigure}
            end
         end,
    {Player1, TmpFigure1} = lists:foldl(F1, {Player, []}, ?APPERENCE),
    NextFigure = InitFigure#figure{mount_figure = TmpFigure1},
    NewPlayer1 = Player1#player_status{figure = NextFigure}, % 更新形象
    F2 = fun(TypeId, PS) ->
        StatuMount = PS#player_status.status_mount,
        StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatuMount),
        case StatuType =/= false of
            true ->
                Sql1 = io_lib:format(?sql_player_mount_figure_select, [RoleId, TypeId]),
                {FigureList, FigureStarAttrL, FigureAttrL, FigureSkillL}
                    = lists:foldl(fun([Id, Stage, Star, Bless, EndTime], {TmpFL, TmpStarFAttrL, TmpFAttrL, TmpFSkillL}) ->
                    Sql2 = io_lib:format(?sql_player_mount_color_select, [RoleId, TypeId, Id]),
                    ColorDbList = db:get_all(Sql2),
                    ColorList = [{ColorId, ColorLv} || [ColorId, ColorLv] <- ColorDbList],
                    {TmpStarAttr, TmpFAttr, TmpSkillIds} = count_figure_attr_combat_sk(TypeId, Id, Stage, Star, ColorList),
                    TmpR = #mount_figure{
                        id = Id, stage = Stage, star = Star,
                        blessing = Bless,
                        attr = TmpFAttr,
                        star_attr = TmpStarAttr,
                        skills = TmpSkillIds,
                        end_time = EndTime,
                        color_list = ColorList},
                    {[TmpR | TmpFL], TmpStarAttr ++ TmpStarFAttrL, TmpFAttr ++ TmpFAttrL, TmpSkillIds ++ TmpFSkillL}
                                  end, {[], [], [], []}, db:get_all(Sql1)),
                %% 把幻形属性Key相同的Val合并到一起
                LastFigureAttrL = util:combine_list(FigureAttrL),
                LastFigureStarAttrL = util:combine_list(FigureStarAttrL),
                UpgradeSysSkillL = StatuType#status_mount.upgrade_sys_skill,
                PassiveSkills = lib_skill_api:divide_passive_skill(StatuType#status_mount.skills ++ FigureSkillL ++ UpgradeSysSkillL),
                NewStatuType = StatuType#status_mount{
                    type_id = TypeId,
                    figure_list = FigureList,
                    figure_attr = LastFigureAttrL,
                    figure_star_attr = LastFigureStarAttrL,
                    figure_skills = FigureSkillL,
                    passive_skills = PassiveSkills,
                    figure_equip = lib_mount_equip:pet_equip_login(RoleId, GoodsStatus, TypeId)
                },
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatuMount, NewStatuType),
                PS#player_status{status_mount = NewStatusMount};
            false -> PS
        end
         end,
    Player2 = lists:foldl(F2, NewPlayer1, ?APPERENCE),
    Player3 = login_count_mount_attr(Player2),
    Player3.


login(Player, GoodsStatus) ->
    #player_status{id = RoleId, figure = InitFigure} = Player,
    RoleLv = InitFigure#figure.lv,
    MountSelectList = db:get_all(io_lib:format(?sql_player_mount_select, [RoleId])),
    NewSelectList = [{Type, Sg, Sr, Ble, Base, IllTy, IllId, IllColor, IR, FigID, Etime, AutoB} || [Type, Sg, Sr, Ble, Base, IllTy, IllId, IllColor, IR, FigID, Etime, AutoB] <- MountSelectList],
    DevourSelList = db:get_all(io_lib:format(?sql_mount_devour_all_select, [RoleId])),
    NewDevourSelList = [{Type1, DevLv, DevExp} || [Type1, DevLv, DevExp] <- DevourSelList],
    UpgradeDataL = db:get_all(io_lib:format(?SQL_SELECT_ALL_PLAYER_MOUNT_LEVEL, [RoleId])),
    UpgradeDataList = [ erlang:list_to_tuple(I) || I <- UpgradeDataL],
    F1 = fun(TypeId, {PS, TmpFigure}) ->
        case lists:keyfind(TypeId, 1, NewSelectList) of
            {_Type, Stage, Star, Blessing, BaseAttrStr, IllusionType, IllusionId, IllusionColor, IsRide, FashionFigureID, Endtime, AutoBuy} ->
                %% 计算通过兽魂增加的基础属性
                {_SkillAttr, SkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, Stage, Star),
                BaseAttr = util:bitstring_to_term(BaseAttrStr),
                RideAttr =
                    case data_mount:get_stage_cfg(TypeId, Stage, InitFigure#figure.career) of
                        #mount_stage_cfg{ride_attr = Ride_Attr} -> Ride_Attr;
                        _ -> []
                    end,
                % ?? 诡异的代码 如果数据库 figure_id=1 就是没有形象, 等于0就是重新计算形象

                FigureId = ?IF(FashionFigureID == 1, 0, get_figure_id(TypeId, IllusionType, IllusionId, InitFigure#figure.career)),

                Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
                % 吞噬
                {_, DevourLv, DevourExp} = ulists:keyfind(TypeId, 1, NewDevourSelList, {TypeId, ?INIT_DEVOUR_LV, ?INIT_DEVOUR_EXP}),

                %% 升级系统
                {UpgradeLv, UpgradeExp, UpgradeAutoSkill} =
                    case lists:keyfind(TypeId, 1, UpgradeDataList) of
                        {TypeId, ULv, UExp, UpgradeSkill} ->
                            {ULv, UExp, util:bitstring_to_term(UpgradeSkill)};
                        _ ->
                            AutoFixSkillList = lib_mount_upgrade_sys:auto_active_skill_by_level(TypeId, ?INIT_UPGRADE_LV, []),
                            {?INIT_UPGRADE_LV, ?INIT_UPGRADE_EXP, AutoFixSkillList}
                    end,

                % 祝福值定时器
                {NewBlessing, NewEtime, Ref} = loading_bless(RoleId, TypeId, Endtime, Blessing),
                TmpStatusMount = #status_mount{
                    type_id = TypeId,
                    stage = Stage, star = Star, blessing = NewBlessing,
                    illusion_type = IllusionType, illusion_id = IllusionId, figure_id = FigureId,
                    base_attr = BaseAttr, ride_attr = RideAttr,
                    skills = SkillIds, is_ride = IsRide, illusion_color = Color
                    , devour_lv = DevourLv, devour_exp = DevourExp
                    , etime = NewEtime, ref = Ref, auto_buy = AutoBuy
                    , upgrade_sys_level = UpgradeLv, upgrade_sys_exp = UpgradeExp
                    , upgrade_sys_skill = UpgradeAutoSkill
                },
                #player_status{status_mount = OldStatusMount} = PS,

                NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, OldStatusMount, TmpStatusMount),
                NewPS = PS#player_status{status_mount = NewStatusMount},
                NewTmpFigure = [{TypeId, FigureId, Color} | TmpFigure],
                {NewPS, NewTmpFigure};
            _ -> % 当该外形没有数据库数据
                OpenLv = data_mount:get_constant_cfg(mapping_type_to_cfg_id(TypeId)), % 各种外形类开放等级
                IsAutoActive = lists:member(TypeId, ?LV_ACTIVE_APPERENCE),
                % case RoleLv >= OpenLv andalso IsAutoActive andalso Player#player_status.robot_type == 0 of
                case RoleLv >= OpenLv andalso IsAutoActive of
                    true ->
                        db:execute(io_lib:format(?sql_player_mount_insert,
                            [RoleId, TypeId, ?MIN_STAGE, ?MIN_STAR, ?BASE_MOUNT_FIGURE, 0, 0, ?RIDE_STATUS])),
                        case TypeId == ?PET_ID of
                            true ->
                                PetId = 1,
                                db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, PetId, 1, 0, 0, 0]));
                            false -> skip
                        end,
                        Stage = ?MIN_STAGE,
                        Star = ?MIN_STAR,
                        Blessing = 0,
                        IllusionType = ?BASE_MOUNT_FIGURE,
                        case lists:member(TypeId, [?ZHENFA_ID, ?NEW_BACK_DECORATION]) of
                            true ->
                                IllusionId = 1;
                            _ ->
                                IllusionId = 0
                        end,
                        IsRide = ?RIDE_STATUS,
                        {_SkillAttr, SkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, Stage, Star),
                        RideAttr =
                            case data_mount:get_stage_cfg(TypeId, Stage, InitFigure#figure.career) of
                                #mount_stage_cfg{ride_attr = Ride_Attr} -> Ride_Attr;
                                _ -> []
                            end,
                        FigureId = get_figure_id(TypeId, IllusionType, IllusionId, InitFigure#figure.career),
                        TmpStatusMount = #status_mount{
                            type_id = TypeId,
                            stage = Stage, star = Star, blessing = Blessing,
                            illusion_type = IllusionType, illusion_id = IllusionId, figure_id = FigureId,
                            base_attr = [], ride_attr = RideAttr,
                            skills = SkillIds, is_ride = IsRide
                        },
                        #player_status{status_mount = OldStatusMount} = PS,
                        NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, OldStatusMount, TmpStatusMount),
                        NewPS = PS#player_status{status_mount = NewStatusMount},
                        NewTmpFigure = [{TypeId, FigureId, 0} | TmpFigure],
                        {NewPS, NewTmpFigure};
                    false -> %% 不符合条件
                        {PS, TmpFigure}
                end
        end
        end,
    {Player1, TmpFigure1} = lists:foldl(F1, {Player, []}, ?APPERENCE),
    NextFigure = InitFigure#figure{mount_figure = TmpFigure1},
    NewPlayer1 = Player1#player_status{figure = NextFigure}, % 更新形象

    F2 = fun(TypeId, PS) ->
        StatuMount = PS#player_status.status_mount,
        StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatuMount),
        case StatuType =/= false of
            true ->
                Sql1 = io_lib:format(?sql_player_mount_figure_select, [RoleId, TypeId]),
                {FigureList, FigureStarAttrL, FigureAttrL, FigureSkillL}
                    = lists:foldl(
                    fun([Id, Stage, Star, Bless, EndTime], {TmpFL, TmpFStarAttrL, TmpFAttrL, TmpFSkillL}) ->
                        NowTime = utime:unixtime(),
                        %% 当外形幻化的id 过期时，删除数据
                        case EndTime < NowTime andalso EndTime =/= 0 of
                            true ->
                                db:execute(io_lib:format(?sql_delete_mount_illusion_info, [RoleId, TypeId, Id])),
                                {TmpFL, TmpFAttrL, TmpFSkillL};
                            false ->
                                Sql2 = io_lib:format(?sql_player_mount_color_select, [RoleId, TypeId, Id]),
                                ColorDbList = db:get_all(Sql2),
                                ColorList = [{ColorId, ColorLv} || [ColorId, ColorLv] <- ColorDbList],
                                {TmpStarAttr, TmpFAttr, TmpSkillIds} = count_figure_attr_combat_sk(TypeId, Id, Stage, Star, ColorList),
                                TmpR = #mount_figure{
                                    id = Id,
                                    stage = Stage,
                                    star = Star,
                                    blessing = Bless,
                                    attr = TmpFAttr,
                                    star_attr = TmpStarAttr,
                                    skills = TmpSkillIds,
                                    end_time = EndTime,
                                    color_list = ColorList},
                                {[TmpR | TmpFL], TmpStarAttr ++ TmpFStarAttrL, TmpFAttr ++ TmpFAttrL, TmpSkillIds ++ TmpFSkillL}
                        end
                    end, {[], [], [], []}, db:get_all(Sql1)),
                %% 把幻形属性Key相同的Val合并到一起
                LastFigureAttrL = util:combine_list(FigureAttrL),
                LastFigureStarAttrL = util:combine_list(FigureStarAttrL),
                UpgradeSysSkillL = StatuType#status_mount.upgrade_sys_skill,
                PassiveSkills = lib_skill_api:divide_passive_skill(StatuType#status_mount.skills ++ FigureSkillL ++ UpgradeSysSkillL),
                NewStatuType = StatuType#status_mount{
                    type_id = TypeId,
                    figure_list = FigureList,
                    figure_attr = LastFigureAttrL,
                    figure_star_attr = LastFigureStarAttrL,
                    figure_skills = FigureSkillL,
                    passive_skills = PassiveSkills,
                    figure_equip = lib_mount_equip:pet_equip_login(RoleId, GoodsStatus, TypeId)
                },
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatuMount, NewStatuType),
                PS#player_status{status_mount = NewStatusMount};
            %%                count_mount_attr(TypeId, PS#player_status{status_mount = NewStatusMount});
            false -> PS
        end
         end,
    Player2 = lists:foldl(F2, NewPlayer1, ?APPERENCE),
    Player3 = check_figure_time(Player2),
    Player4 = login_count_mount_attr(Player3),
    Player4.

%% 登录之后计算战力
after_login(#player_status{original_attr = OriginAttr} = Player) ->
    Fun =
        fun(TypeId, Player1) ->
            #player_status{status_mount = StatusMount, original_attr = OriginAttr} = Player1,
            StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatuType =/= false of
                true ->
                    #status_mount{
                        type_id = TypeId,
                        stage = Stage,
                        star = Star,
                        attr = Attr,
                        skills = SkillIds, % 解锁的技能
                        figure_skills = FigureSkill, % 解锁幻型的技能
                        figure_list = FigureList,   %% 幻型列表,
                        upgrade_sys_skill = UpgradeSkill %% 升级新养成线的技能
                    } = StatuType,
                    case SkillIds =/= [] of
                        true ->
                            NewSkillIds = SkillIds;
                        false ->
                            {_, NewSkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, Stage, Star)
                    end,
                    %% 本功能的技能 全局加成
                    SkillByMod = NewSkillIds ++ FigureSkill,
                    NewSkillByMod = [{SkillTmp, 1} || SkillTmp <- SkillByMod],
                    Fun3 =
                        fun({SkillByModTmp, SkillByModLvTmp}, SkillPowerTmp) ->
                            lib_skill_api:get_skill_power(SkillByModTmp, SkillByModLvTmp) + SkillPowerTmp
                        end,
                    {_, FairyBuySkill} = lib_fairy_buy:get_fairy_buy_attr_and_skill(Player1, TypeId),
                    FairyBuySkillPow = lib_skill_api:get_skill_power(FairyBuySkill),
                    TypeSkillPower = lists:foldl(Fun3, 0, NewSkillByMod ++ UpgradeSkill),
                    NewCombat = lib_player:calc_partial_power(OriginAttr, TypeSkillPower + FairyBuySkillPow, Attr),
                    NewFigureList = get_mount_true_figure_list(OriginAttr, FigureList),
                    NewStatuType = StatuType#status_mount{combat = NewCombat, figure_list = NewFigureList},
                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatuType),
                    Player1#player_status{status_mount = LastStatusMount};
                false -> Player1
            end
        end,
    LastPlayer = lists:foldl(Fun, Player, ?APPERENCE),
    %% 刷新排行榜
    LastPlayer.

%% 登陆加载祝福值
%% 判断是否过期，过期清空
loading_bless(RoleId, TypeId, Endtime, Blessing) ->
    Now = utime:unixtime(),
    if
        TypeId == ?MOUNT_ID orelse TypeId == ?MATE_ID ->
            if
                Endtime > Now  ->
                    AfterTime = (Endtime - Now) * 1000,
                    RefTmp = util:send_after(undefined, AfterTime, self(), {'clear_bless', TypeId}),
                    {Blessing, Endtime, RefTmp};
                Endtime < Now andalso Endtime =/= 0 ->
                    db:execute(io_lib:format(?sql_player_mount_clear_bless, [RoleId, TypeId])),
                    {0, 0, undefined};
                true ->
                    {Blessing, Endtime, undefined}
            end;
        true -> {Blessing, Endtime, undefined}
    end.

%% 获取真实的幻型列表
get_mount_true_figure_list(OriginAttr, FigureList) ->
    Fun =
        fun(#mount_figure{attr = TmpFAttr, skills = Skills} = MountFigureTmp, FigureListTmp) ->
            Fun2 =
                fun(SkillByModTmp, SkillPowerTmp) ->
                    lib_skill_api:get_skill_power(SkillByModTmp, 1) + SkillPowerTmp
                end,
            SkillPower = lists:foldl(Fun2, 0, Skills),
            TmpFCombat = lib_player:calc_partial_power(OriginAttr, SkillPower, TmpFAttr),
            NewMountFigureTmp = MountFigureTmp#mount_figure{combat = TmpFCombat},
            [NewMountFigureTmp | FigureListTmp]
        end,
    lists:foldl(Fun, [], FigureList).



logout(Player) ->
    #player_status{id = RoleId, status_mount = StatusMount} = Player,
    Fun =
        fun(TypeId) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{
                        type_id = TypeId,
                        illusion_type = IllusionType,
                        illusion_id = SelStage,
                        illusion_color = IllusionColor,
                        figure_id = FigureId
                    } = StatusType,
                    db:execute(io_lib:format(?sql_update_mount_illusion, [IllusionType, SelStage, IllusionColor, FigureId, RoleId, TypeId]));
                false -> ok
            end
        end,
    lists:foreach(Fun, ?APPERENCE).

%%--------------------------------------------------
%%     lib_role 调用
%% @param  RoleId 玩家id
%% @return        description
%%--------------------------------------------------
%%get_stage_figure_id_from_db(RoleId, TypeId) ->
%%    Sql = io_lib:format(?sql_player_mount_select, [RoleId, TypeId]),
%%    case db:get_row(Sql) of
%%        [Stage, _Star, _Blessing, _BaseAttrStr, _IllusionType, _IllusionId, _IsRide] ->
%%            get_figure_id(TypeId, ?BASE_MOUNT_FIGURE, Stage, ?RIDE_STATUS);
%%        _ -> 0
%%    end.

%%--------------------------------------------------
%% 获取坐骑类解锁的技能列表
%% @param  TypeId      外形类型
%% @param  Type        1:基础技能 2:幻形技能
%% @param  OwnerShipId 归属Id
%% @param  Stage       归属者当前等阶
%% @return             description
%%--------------------------------------------------
get_mount_skill(TypeId, Type, OwnerShipId, Stage, Star) ->
    SkillIds = data_mount:get_skill_by_type(TypeId, Type, OwnerShipId),
    do_get_mount_skill(TypeId, SkillIds, Stage, Star, []).

do_get_mount_skill(TypeId, [], _Stage, _Star, LearnSkillIds) ->
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(TypeId, LearnSkillIds), %% 计算功能自己相关技能加成的属性
    {SkillAttr, LearnSkillIds};
do_get_mount_skill(TypeId, [Id | L], Stage, Star, LearnSkillIds) ->
    #mount_skill_cfg{stage = UnlockStage} = data_mount:get_skill_cfg(TypeId, Id),
    case lists:member(TypeId, ?STAR_CONFIG) of
        true ->
            case Star >= UnlockStage of
                true ->
                    do_get_mount_skill(TypeId, L, Stage, Star, [Id | LearnSkillIds]);
                false ->
                    do_get_mount_skill(TypeId, L, Stage, Star, LearnSkillIds)
            end;
        false ->
            case Stage >= UnlockStage of
                true ->
                    do_get_mount_skill(TypeId, L, Stage, Star, [Id | LearnSkillIds]);
                false ->
                    do_get_mount_skill(TypeId, L, Stage, Star, LearnSkillIds)
            end
    end.

%% 刷新幻形的技能以及属性信息
refresh_illusion_data(StatusType) ->
    #status_mount{attr = BaseAttrL, figure_list = FigureList, skills = SkillList, upgrade_sys_skill = SkillL} = StatusType,
    %%  计算幻型的属性     (幻型基础属性 + 幻型技能属性) 取出所有激活的外形的属性 * 加成
    {FStarAttrList, FAttrList, FSkillList} =
        case FigureList of
            [] -> {[], [], []};
            _ -> lists:foldl(
                fun(TmpFigure, {TmpFStarAttrL, TmpFAttrL, TmpFSkillL}) ->
                    #mount_figure{star_attr = StarAttr, attr = Attr, skills = Skills} = TmpFigure,
                    {StarAttr ++ TmpFStarAttrL, Attr ++ TmpFAttrL, Skills ++ TmpFSkillL}
                    %% 这里会重复计算技能战力
                    % NewFigureSkillIds = lib_skill_api:divide_passive_skill(Skills),
                    % FigureSkillAttr = lib_skill:count_skill_attr_with_mod_id(TypeId, NewFigureSkillIds),
                    % case data_mount:get_figure_stage_cfg(TypeId, Id, Stage) of
                    %     #mount_figure_stage_cfg{add = Add} ->
                    %         Fun =
                    %             fun(TmpAdd, TmpAttr) ->
                    %                 {TmpAttrId, TmpAttrVal} = TmpAdd,
                    %                 TmpComList = Attr ++ FigureSkillAttr,
                    %                 NTmpComList = [{NTmpId, util:floor(NTmpVal * TmpAttrVal / ?TENTHOU)} || {NTmpId, NTmpVal} <- TmpComList, NTmpId == TmpAttrId],
                    %                 util:combine_list(NTmpComList ++ TmpAttr)
                    %             end,
                    %         FigureAddList = lists:foldl(Fun, [], Add),
                    %         {Attr ++ TmpFAttrL ++ FigureAddList, Skills ++ TmpFSkillL}
                    %     ;
                    %     _ -> {Attr ++ TmpFAttrL, Skills ++ TmpFSkillL}
                    % end
                end, {[], [], []}, FigureList)
        end,
    PassiveSkills = lib_skill_api:divide_passive_skill(SkillList ++ FSkillList), %% 分离出战斗计算的被动
    SpecialAttrMap = lib_player_attr:filter_specify_attr(BaseAttrL ++ FAttrList, ?SP_ATTR_MAP), %% 从属性列表中筛选出特殊属性
    StatusType#status_mount{figure_star_attr = FStarAttrList, figure_attr = FAttrList, figure_skills = FSkillList, passive_skills = PassiveSkills ++ SkillL, special_attr = SpecialAttrMap}.


%%  计算坐骑类总属性
login_count_mount_attr(Player) ->
    Fun =
        fun(TypeId, Player1) ->
            #player_status{status_mount = StatusMount} = Player1,
            StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatuType =/= false of
                true ->
                    {NewStatuType, _} = count_mount_attr_core(Player1, StatuType),
                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatuType),
                    Player1#player_status{status_mount = LastStatusMount};
                false -> Player1
            end
        end,
    LastPlayer = lists:foldl(Fun, Player, ?APPERENCE),
    LastPlayer.


%%  计算坐骑类总属性
count_mount_attr(Player) ->
    Fun =
        fun(TypeId, Player1) ->
            #player_status{status_mount = StatusMount, original_attr = OriginAttr} = Player1,
            StatuType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatuType =/= false of
                true ->
                    {StatuType1, SkillByMod} = count_mount_attr_core(Player1, StatuType),
                    #status_mount{attr = SumAttr} = StatuType1,
                    % 计算真实战力
                    Fun3 =
                        fun({SkillByModTmp, SkillByModLvTmp}, SkillPowerTmp) ->
                            lib_skill_api:get_skill_power(SkillByModTmp, SkillByModLvTmp) + SkillPowerTmp
                        end,
                    TypeSkillPower = lists:foldl(Fun3, 0, SkillByMod),
                    {_, FairyBuySkill} = lib_fairy_buy:get_fairy_buy_attr_and_skill(Player1, TypeId),
                    FairyBuySkillPow = lib_skill_api:get_skill_power(FairyBuySkill),
                    NewCombat = lib_player:calc_partial_power(OriginAttr, TypeSkillPower + FairyBuySkillPow, SumAttr),
                    NewStatuType = StatuType1#status_mount{combat = NewCombat},

                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatuType),

                    Player1#player_status{status_mount = LastStatusMount};
                false -> Player1
            end
        end,
    LastPlayer = lists:foldl(Fun, Player, ?APPERENCE),
    LastPlayer.

count_mount_attr_core(Player, StatuType) ->
    #player_status{id = RoleId} = Player,
    #status_mount{
        type_id = TypeId,
        stage = Stage,
        star = Star,
        skills = SkillIds, % 解锁的技能
        figure_skills = FigureSkill, % 解锁幻型的技能
        figure_attr = FigureAttr, % 幻型属性
        figure_star_attr = FigureStarAttr, % 幻形等阶属性
        ride_attr = RideAttr,
        upgrade_sys_level = UpgradeLevel,
        upgrade_sys_skill = UpgradeLevelL  %%  升级养成线的技能
    } = StatuType,
    StarAttr =
        case data_mount:get_star_cfg(TypeId, Stage, Star) of
            #mount_star_cfg{attr = Attr} -> Attr;
            _ -> []
        end,
    UpgradeAttr = case data_mount:get_mount_level_info(TypeId, UpgradeLevel) of
                      #base_mount_level_info{ attr = Attr2 } -> Attr2;
                      _ -> []
                  end,
    case SkillIds =/= [] of
        true ->
            NewSkillIds = SkillIds;
        false ->
            {_, NewSkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, Stage, Star)
    end,
    %% 仙灵直购属性技能
    {BuyAttr, BuySkill} = lib_fairy_buy:get_fairy_buy_attr_and_skill(Player, TypeId),
    BuySkillAttr = lib_skill:get_passive_skill_attr(BuySkill),

    %% 计算功能被动技能的属性
    AllFigSkill = get_all_figure_skills(Player),
    AllPassiveSkill = NewSkillIds ++ AllFigSkill ++ UpgradeLevelL,
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(TypeId, AllPassiveSkill), % 选取本功能id 的加成
    %% 本功能的技能 全局加成
    SkillByMod = NewSkillIds ++ FigureSkill,
    NewSkillByMod0 = [{SkillTmp, 1} || SkillTmp <- SkillByMod],
    NewSkillByMod = NewSkillByMod0 ++ UpgradeLevelL,  %% 增加坐骑新培养线的技能处理
    AllAddSkillAttr = lib_skill:get_passive_skill_attr(NewSkillByMod), % 选取基础 全局 的加成
    %% ?INFO("NewSkillByMod0:~p//NewSkillByMod:~p//UpgradeLevelL:~p", [NewSkillByMod0, NewSkillByMod, UpgradeLevelL]),
    %% ?INFO("Old:~p//New:~p//Sum:~p", [lib_skill:get_passive_skill_attr(NewSkillByMod0), lib_skill:get_passive_skill_attr(UpgradeLevelL), lib_skill:get_passive_skill_attr(NewSkillByMod)]),
    %% 魔晶属性
    TypeGoodIds = data_mount:get_goods_ids(TypeId),
    Fun1 =
        fun(TypeGoodId, {TypeGoodsListTmp, BaseAttrTmp}) ->
            GoodsIdNumTmp = mod_counter:get_count_offline(RoleId, ?MOD_GOODS, TypeGoodId), % 查询数据库
            #mount_goods_cfg{attr = TypeGoodAttr} = data_mount:get_goods_cfg(TypeId, TypeGoodId),
            NewTypeGoodAttr = [{AttrIdTmp, AttrNumTmp * GoodsIdNumTmp} || {AttrIdTmp, AttrNumTmp} <- TypeGoodAttr],
            {[{TypeGoodId, GoodsIdNumTmp} | TypeGoodsListTmp], util:combine_list(BaseAttrTmp ++ NewTypeGoodAttr)}
        end,
    {TypeGoodsList, BaseAttr} = lists:foldl(Fun1, {[], []}, TypeGoodIds), %   [{TypeGoodId, GoodsIdNum}]
%%    MagicAllAttr = util:combine_list(BaseAttr ++ StarAttr ++ SkillAttr ++ AllAddSkillAttr), % 受魔晶影响的属性  魔晶属性,  基础属性， 技能属性
    MagicAllAttr = lib_player_attr:add_attr(list, [BaseAttr, StarAttr++UpgradeAttr, SkillAttr, AllAddSkillAttr]),

    AllBaseAttr = util:combine_list(BaseAttr ++ StarAttr ++ UpgradeAttr),
    RealMagicAllAttr = calc_real_magic_all_attr(AllBaseAttr, MagicAllAttr),

    % %%  计算骑乘的加成属性  （星级属性 + 魔晶属性 + 等阶属性）*（魔晶a数量 * 加成 + 魔晶b数量 * 加成 + ...）
    MagicAddAttr = calc_magic_add_attr(TypeId, TypeGoodsList, AllBaseAttr),

    %% 计算天赋技能带来的加成
    TalentSpecialAttr = lib_skill:get_talent_extra_attr(Player, {?MOD_MOUNT, TypeId}),
    TalentAddAttr = calc_talent_add_attr(BaseAttr, StarAttr ++ UpgradeAttr, FigureStarAttr, TalentSpecialAttr),

    ?PRINT(TalentSpecialAttr =/= [], "TypeId ~p TalentSpecialAttr ~p ~n StarAttr ~p ~n TalentAddAttr ~p ~n", [TypeId, TalentSpecialAttr, StarAttr, TalentAddAttr]),

%%    AttrList = util:combine_list(RealMagicAllAttr ++ MagicAddAttr ++ FigureAttr ++ RideAttr ++ TalentAddAttr),
    AttrList = lib_player_attr:add_attr(list, [RealMagicAllAttr, MagicAddAttr, FigureAttr, RideAttr, TalentAddAttr]),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList),
    %% 其他模块加成属性计算
    OtherModAddAttr = lib_mount_api:other_mod_add_attr(Player, TypeId, BaseAttr, StarAttr),

    AttrAfTalent = util:combine_list(NewAttr ++ OtherModAddAttr ++ BuyAttr ++ BuySkillAttr),
    {StatuType#status_mount{skills = NewSkillIds, attr = AttrAfTalent}, NewSkillByMod}.

calc_magic_add_attr(TypeId, TypeGoodsList, AllBaseAttr) ->
    Fun =
        fun({TypeGoodId, GoodsIdNum}, TmpAttr) ->
            GetGoodsCfg = data_mount:get_goods_cfg(TypeId, TypeGoodId),
            GetGoodsAdd = % 魔晶加成
            case GetGoodsCfg =/= [] of
                true -> GetGoodsCfg#mount_goods_cfg.add;
                false -> 0
            end,
            NMagicBaseAttr = [
                {TmpId, util:floor(TmpVal * GoodsIdNum * GetGoodsAdd / ?TENTHOU)} 
                    || {TmpId, TmpVal} <- AllBaseAttr, lists:member(TmpId, ?BASE_ATTR_LIST) == true
            ],
            util:combine_list(NMagicBaseAttr ++ TmpAttr)
        end,
    lists:foldl(Fun, [], TypeGoodsList).

%% 计算天赋技能带来的额外属性加成
%% @param BaseAttr 属性丹属性 (弃用)
%% @param StarAttr 模块等阶属性
%% @param BaseAttr 模块幻形等阶属性 (弃用)
%% @param TalentSpecialAttr 天赋属性
calc_talent_add_attr(_BaseAttr, StarAttr, _FigureStarAttr, TalentSpecialAttr) ->
    Fun = fun
%%        ({figure_id_list, AttrId, AttrVal}, AccAddAttr) -> calc_talent_add_attr_core(StarAttr ++ FigureStarAttr, AttrId, AttrVal) ++ AccAddAttr;
%%        ({stage, AttrId, AttrVal}, AccAddAttr) -> calc_talent_add_attr_core(BaseAttr ++ StarAttr, AttrId, AttrVal) ++ AccAddAttr;
        ({AttrId, AttrVal}, AccAddAttr) -> calc_talent_add_attr_core(StarAttr, AttrId, AttrVal) ++ AccAddAttr;
        (_, AccAddAttr) -> AccAddAttr
    end,
    lists:foldl(Fun, [], TalentSpecialAttr).

calc_talent_add_attr_core(NeedHandleAttr, AttrId, AttrVal) ->
    SpecialAttrKeyList = [
        ?PARTIAL_ATT_ADD_RATIO,
        ?PARTIAL_HP_ADD_RATIO,
        ?PARTIAL_WRECK_ADD_RATIO,
        ?PARTIAL_DEF_ADD_RATIO,
        ?PARTIAL_HIT_ADD_RATIO,
        ?PARTIAL_DODGE_ADD_RATIO,
        ?PARTIAL_CRIT_ADD_RATIO,
        ?PARTIAL_TEN_ADD_RATIO
    ],
    %% 判断是否全局属性加成
    IsGlobalRatio = ?IF(AttrId == ?PARTIAL_WHOLE_ADD_RATIO, true, false),
    if
        IsGlobalRatio -> NeedTranAttrIds = SpecialAttrKeyList;
        true -> NeedTranAttrIds = [AttrId]
    end,
    Fun = fun(TmpId, AccIdL) ->
        case ?PARTIAL2GLOBAL(TmpId) of
            false -> AccIdL;
            TranAttrId -> [TranAttrId|AccIdL]
        end
    end,
    TranAttrIds = lists:foldl(Fun, [], NeedTranAttrIds),
    [{AId, round(AVal * AttrVal / 10000)}||{AId, AVal}<-NeedHandleAttr, TranAttrId<-TranAttrIds, TranAttrId == AId].


%% 获取坐骑显示的形象资源id
get_figure_id(TypeId, IllusionType, Args, Career) ->
    case IllusionType of
        ?ILLUSION_MOUNT_FIGURE ->
            case data_mount:get_figure_cfg(TypeId, Args, Career) of
                #mount_figure_cfg{ride_figure = RideFigureId} -> RideFigureId;
                _ -> 0
            end;
        _ ->
            case data_mount:get_stage_cfg(TypeId, Args, Career) of
                #mount_stage_cfg{ride_figure = RideFigureId} -> RideFigureId;
                _ -> 0
            end
    end.

%% 检测当前场景是否可以上坐骑
check_ride_mount_in_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{mount = 1} -> true;
        _ -> false
    end.

%% 改变骑乘状态
%% Type: 0: 下坐骑 1: 上坐骑
change_ride_status(TypeId, Player, Type, StatusType) ->
    #player_status{sid = Sid, id = _RoleId, scene = Scene, figure = #figure{career = Career}, status_mount = StatusMount, is_battle = IsBattle} = Player,
    #status_mount{
        stage = Stage,
        illusion_type = IllusionType,
        illusion_id = IllusionId,
        figure_id = OldFigureId,
        is_ride = IsRide} = StatusType,
    IsCanRideMount = check_ride_mount_in_scene(Scene), % 检测场景ets的 is_ride 的状态
    %% 还要检测负面状态
    if
        Type =/= ?NOT_RIDE_STATUS andalso Type =/= ?RIDE_STATUS ->
            NewPlayer = Player, ErrorCode = skip;
        IllusionType == 0 orelse IllusionId == 0 -> % 外形未激活
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_3_figure_inactive);
        Stage < ?MIN_STAGE -> % 外形未激活
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_3_figure_inactive);
        Type == ?NOT_RIDE_STATUS andalso IsRide == ?NOT_RIDE_STATUS orelse Type == ?RIDE_STATUS andalso IsRide == ?RIDE_STATUS ->
            NewPlayer = Player, ErrorCode = skip;
        IsCanRideMount == false andalso Type == ?RIDE_STATUS -> % 该场景不可骑乘坐骑
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_8_mount_scene_limit);
        IsBattle == 1 andalso Type == ?RIDE_STATUS ->
            NewPlayer = Player, ErrorCode = ?ERRCODE(err160_on_battle_status_not_to_ride);
        true ->
            % FigureId = get_figure_id(TypeId, IllusionType, IllusionId, Type),
            FigureId = ?IF(Type == ?RIDE_STATUS, get_figure_id(TypeId, IllusionType, IllusionId, Career), OldFigureId),
            case Type == 0 of
                true -> %% 下坐骑
                    NewRideStatus = ?NOT_RIDE_STATUS,
                    RideAttr = [];
                _ -> %% 上坐骑
                    NewRideStatus = ?RIDE_STATUS,
                    RideAttr =
                        case data_mount:get_stage_cfg(TypeId, Stage, Career) of
                            #mount_stage_cfg{ride_attr = Ride_Attr} -> Ride_Attr;
                            _ -> []
                        end
            end,
            NewStatusType = StatusType#status_mount{figure_id = FigureId, ride_attr = RideAttr, is_ride = NewRideStatus},
            NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
            Player1 = count_mount_attr(Player#player_status{status_mount = NewStatusMount}),
            NewPlayer = broadcast_to_scene(TypeId, Player1), %% 玩家坐骑信息发生变化 广播给场景玩家
            ErrorCode = ?SUCCESS
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData} = pt_160:write(16004, [ErrorCode, TypeId, Type]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip
    end,
    {ok, battle_attr, NewPlayer}.

%% 玩家坐骑信息发生变化 广播给场景玩家
broadcast_to_scene(TypeId, Player) ->
    NewPlayer = lib_player:count_player_attribute(Player),
    #player_status{
        id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BattleAttr,
        status_mount = StatusMount, is_battle = IsBattle, figure = Figure} = NewPlayer,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{
                figure_id = FigureId, attr = Attr, is_ride = IsRide, 
                illusion_type = IllusionType, illusion_color = IllusionColor} = StatusType,
            case train_type_to_att_type(TypeId) of
                0 -> SceneTrainKv = [];
                Sign ->
                    AttrRecord = lib_player_attr:to_attr_record(Attr),
                    SceneTrainKv = lib_player:calc_scene_train_obj_kvlist(NewPlayer, Sign, 
                        StatusType, [{scene_train_attr, {Sign, AttrRecord}}])
            end,
            % NewFigureId =
            %     case IsBattle == 1 andalso TypeId == ?MOUNT_ID of
            %         true -> % 在战斗状态
            %             0;
            %         false ->
            %             case IsRide of
            %                 ?RIDE_STATUS -> FigureId;
            %                 _ -> 0
            %             end
            %     end,
            % 战斗中则下坐骑
            Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
            IsCanRideMount = check_ride_mount_in_scene(Sid),
            NewIsRide = case (FigureId == 0 orelse IsCanRideMount==false orelse IsBattle == ?IS_BATTLE_YES) andalso TypeId == ?MOUNT_ID of
                true -> ?NOT_RIDE_STATUS;
                false -> IsRide
            end,
            NewStatusType = StatusType#status_mount{is_ride = NewIsRide},
            NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
            % 头像
            #figure{mount_figure_ride = MountFigureRide} = Figure,
            case NewIsRide of
                ?RIDE_STATUS -> NewMountFigureRide = lists:keydelete(TypeId, 1, MountFigureRide);
                _ -> NewMountFigureRide = lists:keystore(TypeId, 1, MountFigureRide, {TypeId, NewIsRide})
            end,
            NewFigure = Figure#figure{mount_figure_ride = NewMountFigureRide},
            PlayerAfRide = NewPlayer#player_status{figure = NewFigure, status_mount = NewStatusMount},
            mod_scene_agent:update(PlayerAfRide, [
                {mount_figure_ride, {TypeId, NewIsRide}},
                {mount_figure, {TypeId, FigureId, Color}}, 
                {battle_attr, BattleAttr} | SceneTrainKv 
                ]),
            lib_player:send_attribute_change_notify(PlayerAfRide, ?NOTIFY_ATTR),
            {ok, BinData} = pt_160:write(16001, [TypeId, RoleId, NewIsRide, FigureId, BattleAttr#battle_attr.speed]),
            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
            NewPlayer2 = lib_player:update_scene_train_obj(SceneTrainKv, PlayerAfRide),
            NewPlayer2;
        false -> NewPlayer
    end.


broadcast_to_scene_1(TypeId, Player) ->
    #player_status{
        id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BattleAttr,
        status_mount = StatusMount, is_battle = IsBattle, figure = Figure} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_id = FigureId, attr = Attr, is_ride = IsRide, 
                illusion_type = IllusionType, illusion_color = IllusionColor} = StatusType,
            case train_type_to_att_type(TypeId) of
                0 -> SceneTrainKv = [];
                Sign ->
                    AttrRecord = lib_player_attr:to_attr_record(Attr),
                    SceneTrainKv = lib_player:calc_scene_train_obj_kvlist(Player, Sign, StatusType, [{scene_train_attr, {Sign, AttrRecord}}])
            end,
            % NewFigureId =
            %     case IsBattle == 1 andalso TypeId == ?MOUNT_ID of
            %         true -> % 在战斗状态
            %             0;
            %         false ->
            %             case IsRide of
            %                 ?RIDE_STATUS -> FigureId;
            %                 _ -> 0
            %             end
            %     end,
            % 战斗中则下坐骑
            Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
            IsCanRideMount = check_ride_mount_in_scene(Sid),
            NewIsRide = case (IsCanRideMount==false orelse IsBattle == ?IS_BATTLE_YES) andalso TypeId == ?MOUNT_ID of
                true -> ?NOT_RIDE_STATUS;
                false -> IsRide
            end,
            NewStatusType = StatusType#status_mount{is_ride = NewIsRide},
            NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
            % 头像
            #figure{mount_figure_ride = MountFigureRide} = Figure,
            case NewIsRide of
                ?RIDE_STATUS -> NewMountFigureRide = lists:keydelete(TypeId, 1, MountFigureRide);
                _ -> NewMountFigureRide = lists:keystore(TypeId, 1, MountFigureRide, {TypeId, NewIsRide})
            end,
            PlayerAfRide = Player#player_status{figure = Figure#figure{mount_figure_ride = NewMountFigureRide}, status_mount = NewStatusMount},
            mod_scene_agent:update(PlayerAfRide, [
                {mount_figure_ride, {TypeId, NewIsRide}},
                {mount_figure, {TypeId, FigureId, Color}}, 
                {battle_attr, BattleAttr} | SceneTrainKv
                ]),
            {ok, BinData} = pt_160:write(16001, [TypeId, RoleId, NewIsRide, FigureId, BattleAttr#battle_attr.speed]),
            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
            NewPlayer2 = lib_player:update_scene_train_obj(SceneTrainKv, PlayerAfRide),
            NewPlayer2;
        false -> Player
    end.


%%broadcast_to_scene(TypeId, ?SEL_FIGURE, Player) ->
%%    #player_status{
%%        id = RoleId, scene = Sid,
%%        scene_pool_id = PoolId, copy_id = CopyId,
%%        x = X, y = Y, battle_attr = BattleAttr,
%%        status_mount = StatusMount} = Player,
%%    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
%%    case StatusType =/= false of
%%        true ->
%%            #status_mount{figure_id = FigureId} = StatusType,
%%            mod_scene_agent:update(Player, [{mount_figure, {TypeId, FigureId}}]),
%%            {ok, BinData} = pt_160:write(16001, [TypeId, RoleId, 1, FigureId, BattleAttr#battle_attr.speed]),
%%            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
%%            Player;
%%        false -> Player
%%    end;
%%broadcast_to_scene(_, Player) -> Player.


%% 物品使用上限
get_goods_max_times([], _) -> 0;
get_goods_max_times([T | L], RoleLv) ->
    case T of
        {LLim, HLim, Times} when LLim =< RoleLv, RoleLv =< HLim ->
            Times;
        _ ->
            get_goods_max_times(L, RoleLv)
    end.

check_before_use_mount_goods(Player, RoleLv, TypeId, GTypeId, StatusType) ->
    MountGoodsCfg = data_mount:get_goods_cfg(TypeId, GTypeId),
    if
        is_record(MountGoodsCfg, mount_goods_cfg) == false -> {fail, ?ERRCODE(err160_9_config_err)};
        is_record(StatusType, status_mount) == false -> {fail, ?ERRCODE(err160_3_figure_inactive)};
        true ->
            #mount_goods_cfg{max_times = MaxTimesL} = MountGoodsCfg,
            MaxTimes = get_goods_max_times(MaxTimesL, RoleLv), % 物品使用上限
            [{_GTypeId, GoodsNum}] = lib_goods_api:get_goods_num(Player, [GTypeId]), % 获得物品数量
            Counter = mod_counter:get_count_offline(Player#player_status.id, ?MOD_GOODS, GTypeId),
            CostNum = ?IF(Counter + GoodsNum =< MaxTimes, GoodsNum, MaxTimes - Counter),
            if
                Counter > MaxTimes -> {fail, ?ERRCODE(err160_max_goods_use_times)};
                CostNum =< 0 -> {fail, ?ERRCODE(err160_not_enough_cost)};
                true ->
                    {ok, StatusType, MountGoodsCfg, CostNum, MaxTimes, Counter}
            end
    end.

%% 使用兽魂/魔晶
use_goods(Player, TypeId, GTypeId, StatusType) ->
    #player_status{id = RoleId, figure = Figure, status_mount = StatusMount} = Player,
    #figure{lv = RoleLv} = Figure,
    case check_before_use_mount_goods(Player, RoleLv, TypeId, GTypeId, StatusType) of
        {ok, StatusType, MountGoodsCfg, CostNum, MaxTimes, Counter} ->
            #mount_goods_cfg{attr = Attr} = MountGoodsCfg,
            #status_mount{base_attr = BaseAttr, attr = OAttrL} = StatusType,
            Cost = [{?TYPE_GOODS, GTypeId, CostNum}],
            case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_upgrade_star, "") of
                {true, NewPlayerTmp} ->
                    NewAttr = [{Type_Id, TypeNum * CostNum} || {Type_Id, TypeNum} <- Attr],
                    NewBaseAttr = util:combine_list(NewAttr ++ BaseAttr),
                    db:execute(io_lib:format(?sql_update_mount_base_attr, [util:term_to_string(NewBaseAttr), RoleId, TypeId])),
                    mod_counter:plus_count(RoleId, ?MOD_GOODS, GTypeId, CostNum),
                    NewStatusType = StatusType#status_mount{base_attr = NewBaseAttr},
                    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                    NewPlayerTmp1 = count_mount_attr(NewPlayerTmp#player_status{status_mount = NewStatusMount}),
                    LastStatusMount = NewPlayerTmp1#player_status.status_mount,
                    LastStatusType = lists:keyfind(TypeId, #status_mount.type_id, LastStatusMount), % 这里不用判断false
                    %% 日志
                    lib_log_api:log_mount_goods_use(RoleId, TypeId, GTypeId, Counter + CostNum, MaxTimes, OAttrL, LastStatusType#status_mount.attr),
                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                    NewPlayer1 = lib_mount_api:power_change_event(NewPlayer, TypeId),
                    % lib_common_rank_api:refresh_rank_by_upgrade(NewPlayer, TypeId),
                    % %% 升阶升战活动
                    % lib_train_act:mount_train_power_up(NewPlayer, TypeId),
                    {ok, ?SUCCESS, NewPlayer1};
                {false, 1003, NewPlayerTmp} ->
                    {fail, ?ERRCODE(err160_not_enough_cost), NewPlayerTmp};
                {false, ErrorCode, NewPlayerTmp} -> {fail, ErrorCode, NewPlayerTmp}
            end;
        {_, Code} -> {fail, Code, Player}
    end.

gm_delete_used_wing_goods(RoleId, GoodsTypeId, Num) ->
    Counter = mod_counter:get_count_offline(RoleId, ?MOD_GOODS, GoodsTypeId),
    if
        Counter > Num andalso Num > 0 ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_delete_used_goods, [?FLY_ID, GoodsTypeId, Num]);
        true ->
            skip
    end.

gm_delete_used_goods(Player, TypeId, GoodsTypeId, Num) ->
    #player_status{id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #mount_goods_cfg{attr = Attr, max_times = MaxTimesL} = data_mount:get_goods_cfg(TypeId, GoodsTypeId),
    MaxTimes = get_goods_max_times(MaxTimesL, RoleLv), % 物品使用上限
    NewAttr = [{Type_Id, TypeNum * Num} || {Type_Id, TypeNum} <- Attr],
    NewBaseAttr = util:combine_list(NewAttr),
    db:execute(io_lib:format(?sql_update_mount_base_attr, [util:term_to_string(NewBaseAttr), RoleId, TypeId])),
    mod_counter:set_count(RoleId, ?MOD_GOODS, GoodsTypeId, Num),
    NewStatusType = StatusType#status_mount{base_attr = NewBaseAttr},
    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
    NewPlayerTmp1 = count_mount_attr(Player#player_status{status_mount = NewStatusMount}),
    LastStatusMount = NewPlayerTmp1#player_status.status_mount,
    LastStatusType = lists:keyfind(TypeId, #status_mount.type_id, LastStatusMount), % 这里不用判断false
    %% 日志
    lib_log_api:log_mount_goods_use(RoleId, TypeId, GoodsTypeId, Num, MaxTimes, 
        StatusType#status_mount.attr, LastStatusType#status_mount.attr),
    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    lib_common_rank_api:gm_refresh_rank(NewPlayer, TypeId),
    pp_mount:handle(16011, NewPlayer, [TypeId]),
    pp_mount:handle(16002, Player, [TypeId]),
    {ok, NewPlayer}.

%% 坐骑升阶检测
check_upgrade_stage(StatusMount) ->
    #status_mount{type_id = TypeId, stage = Stage, star = Star, blessing = _Blessing} = StatusMount,
    StageCfg = data_mount:get_stage_cfg(TypeId, Stage),
    StageUpCfg = data_mount:get_mount_stage_info(TypeId, Stage),
    if
        is_record(StageCfg, mount_stage_cfg) == false -> {fail, ?ERRCODE(err160_9_config_err)};
        true ->
            #mount_stage_cfg{max_star = CurStageMaxStar} = StageCfg,
            StarCfg = data_mount:get_star_cfg(TypeId, Stage, Star),
            case StarCfg of
                [] -> {fail, ?ERRCODE(err160_9_config_err)};
                _ ->
                    #mount_star_cfg{max_blessing = MaxBlessing} = StarCfg,
                    NextStageCfg = data_mount:get_stage_cfg(TypeId, Stage + 1),
                    if
                        MaxBlessing == 0 -> {fail, ?ERRCODE(err160_max_star)};
                        Star < CurStageMaxStar -> {fail, ?ERRCODE(err160_up_star_first)};
                        Star == CurStageMaxStar andalso is_record(NextStageCfg, mount_stage_cfg) == false ->
                            {fail, ?ERRCODE(err160_max_star)};   %% 当已达到最大等级配置，并且没有下一级配置
                        % Blessing < MaxBlessing -> {fail, ?ERRCODE(err160_more_blessing_need)};
                        true -> {ok, StageUpCfg, Stage+1, MaxBlessing, Star}
                    end
            end
    end.

%% 坐骑升星检测
check_upgrade_star(StatusMount, Career) ->
    #status_mount{type_id = TypeId, stage = Stage, star = Star} = StatusMount,
    StageCfg = data_mount:get_stage_cfg(TypeId, Stage, Career),
    if
        is_record(StageCfg, mount_stage_cfg) == false -> {fail, ?ERRCODE(err160_9_config_err)};
        true ->
            #mount_stage_cfg{max_star = CurStageMaxStar} = StageCfg,
            StarCfg = data_mount:get_star_cfg(TypeId, Stage, Star),
            case StarCfg of
                [] -> {fail, ?ERRCODE(err160_9_config_err)};
                _ ->
                    #mount_star_cfg{max_blessing = MaxBlessing} = StarCfg,
                    NextStageCfg = data_mount:get_stage_cfg(TypeId, Stage + 1, Career),
                    if
                        MaxBlessing == 0 -> {fail, ?ERRCODE(err160_max_star)};
                        Star == CurStageMaxStar andalso is_record(NextStageCfg, mount_stage_cfg) == false ->
                            {fail, ?ERRCODE(err160_max_star)};   %% 当已达到最大等级配置，并且没有下一级配置
                        true -> {ok, MaxBlessing}
                    end
            end
    end.

%% 坐骑类升级计算暴击
mount_grage_cost(Blessing, OwnNum, Exp, Ratio, NeedCostNum, RealCostNum, BlessingPlus, RateList) ->
    ExpPlus = urand:rand_with_weight(Ratio), % 暴击倍率
    NewRateList =
        case ExpPlus of
            1 -> RateList;
            _ ->
                case lists:keyfind(ExpPlus, 1, RateList) of
                    false ->
                        lists:keystore(ExpPlus, 1, RateList, {ExpPlus, 1});
                    {Rate, RateNum} ->
                        lists:keyreplace(ExpPlus, 1, RateList, {Rate, RateNum + 1})
                end
        end,
    NewBlessingPlus = BlessingPlus + ExpPlus * Exp, % 新增长的经验值
    NewRealCostNum = RealCostNum + 1, % 实际需要的数量
    NewOwnNum = OwnNum - 1, % 拥有的数量
    case NewOwnNum > 0 of
        true ->
            case NewBlessingPlus >= NeedCostNum of
                true ->
                    {NewRealCostNum, NewBlessingPlus, NewRateList};
                false ->
                    mount_grage_cost(Blessing, NewOwnNum, Exp, Ratio, NeedCostNum, NewRealCostNum, NewBlessingPlus, NewRateList)
            end;
        false ->
            {NewRealCostNum, NewBlessingPlus, NewRateList}
    end.

%% 坐骑升星(不包括坐骑伙伴类型)
upgrade_star(_TypeId, Player, []) -> 
    {ok, BinData1} = pt_160:write(16000, [?ERRCODE(err160_not_enough_cost)]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData1),
    Player;
upgrade_star(TypeId, Player, [GoodsId | GoodsList]) ->
    #player_status{sid = Sid, figure = Figure, status_mount = StatusMount} = Player,
    #status_mount{stage = Stage, star = Star, blessing = Blessing} = StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    {Code, NewPlayer} =
        case check_upgrade_star(StatusType, Figure#figure.career) of % 判断是否可以升级
            {ok, MaxBlessing} ->
                #mount_prop_cfg{exp = Exp, ratio = Ratio} = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
                [{_GoodsId, OwnNum}] = lib_goods_api:get_goods_num(Player, [GoodsId]),
                case OwnNum > 0 of
                    true ->
                        NeedCost = MaxBlessing - Blessing, % 升级所需的消耗数量
                        {RealCostNum, BlessingPlus, RateList} = mount_grage_cost(Blessing, OwnNum, Exp, Ratio, NeedCost, 0, 0, []),
                        {NewStage, NewStar, NewBlessing} = count_star_helper(TypeId, Stage, Star, Blessing, BlessingPlus, Figure#figure.career),
                        Cost = [{?TYPE_GOODS, GoodsId, RealCostNum}],
                        case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_upgrade_star, "") of
                            {true, NewPlayerTmp} -> % 物品满足条件扣除
                                Back = do_upgrade_star(NewPlayerTmp, TypeId, NewStage, NewStar, NewBlessing, BlessingPlus, Cost, RateList, 0),
                                %% lib_cycle_rank:calc_cycle_rank_score(Player, [{0, GoodsId, RealCostNum}]),
                                Back;
                            {false, 1003, NewPlayerTmp} -> % 物品不足
                                {?ERRCODE(err160_not_enough_cost), NewPlayerTmp};
                            {false, ErrorCode, NewPlayerTmp} -> {ErrorCode, NewPlayerTmp}
                        end;
                    false ->
                        {?ERRCODE(err160_not_enough_cost), Player}
                end;
            {fail, ErrorCode} -> {ErrorCode, Player}
        end,
    NStar = get_status_star(TypeId, NewPlayer), % 获取外形的星级
    % _LastPlayer =
        %%     循环判断
    case Star =/= NStar orelse Code =:= ?ERRCODE(err160_max_star) of % 判断是否升级 或 达到最高等级、物品配置
        true -> % 当已经升级 或 达到最高等级、物品配置
            case is_integer(Code) of
                true ->
                    {ok, BinData1} = pt_160:write(16000, [Code]),
                    lib_server_send:send_to_sid(Sid, BinData1);
                false -> skip
            end,
            % lib_common_rank_api:refresh_rank_by_upgrade(NewPlayer, TypeId),
            % %% 培养升阶升战活动
            % lib_train_act:mount_train_stage_up(NewPlayer, TypeId),
            % lib_train_act:mount_train_power_up(NewPlayer, TypeId),
            NewPlayer;
        false -> % 当没有升级
            upgrade_star(TypeId, NewPlayer, GoodsList)
    end.

create_etime(TypeId, NewStage, NewStar) ->
    case data_mount:get_star_cfg(TypeId, NewStage, NewStar) of
        #mount_star_cfg{clear_status = 1} -> utime:unixtime() + ?CLEAR_BLESSING_TIME;
        _ -> 0
    end.

upgrade_star_one(Player, _TypeId, ?NOAUTOBUY, _GoldType, []) -> {?ERRCODE(err160_not_enough_cost), Player};
upgrade_star_one(Player, TypeId, AutoBuy, GoldType, AllGoods) ->
    #player_status{figure = Figure, status_mount = StatusMount} = Player,
    #status_mount{stage = Stage, star = Star, blessing = Blessing, etime = OldEtime} = StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    % ?PRINT("allgoods: ~p ~n Stage:~p ~n Star:~p ~n Blessing:~p ~n", [AllGoods, Stage, Star, Blessing]),
    case check_upgrade_star(StatusType, Figure#figure.career) of % 判断是否可以升级
        {ok, MaxBlessing} ->
            %case cost_one_goods(Player, AllGoods, TypeId, AutoBuy, GoldType) of 升得太慢，弃用
            case cost_precent(Player, Blessing, MaxBlessing, AllGoods, TypeId, AutoBuy, GoldType) of
                {false, Errorcode} -> {Errorcode, Player};
                {Cost, Exp} ->
                    NeedCost = MaxBlessing - Blessing,
                    case Exp >= NeedCost of 
                        true -> %升级了
                            {NewStage, NewStar, NewOverFlowExp} = get_new_status(TypeId, Exp - NeedCost, Stage, Star, Figure#figure.career),
                            Etime = create_etime(TypeId, NewStage, NewStar);
                        false -> %没升级
                            NewStage = Stage, NewStar = Star, NewOverFlowExp = Blessing + Exp,
                            case OldEtime == 0 of 
                                false -> Etime = OldEtime;
                                true ->
                                    if  
                                        Blessing =/= 0 -> Etime = 0;%照顾有经验条的老玩家
                                        true -> Etime = create_etime(TypeId, NewStage, NewStar) %经验条为0的老玩家直接加
                                    end
                            end
                    end,
                    case lib_goods_api:cost_object_list_with_check(Player, before_cost(Cost), mount_upgrade_star, "") of
                        {true, NewPlayerTmp} -> % 物品满足条件扣除
                            {ok, NewPlayer} = do_upgrade_star(NewPlayerTmp, TypeId, NewStage, NewStar, NewOverFlowExp, Exp, Cost, [], Etime),
                            %% lib_cycle_rank:calc_cycle_rank_score(NewPlayer, Cost),
                            {ok, NewPlayer};
                        {false, ErrorCode1, NewPlayerTmp} -> 
                            % ?PRINT("error ~p~n", [ErrorCode]),
                            {ErrorCode1, NewPlayerTmp}
                    end
            end;
        {fail, ErrorCode3} -> {ErrorCode3, Player} %当前不能升级
    end.

%% 改变当前坐骑升级是否自动购买状态
change_auto_buy(Player, TypeId, AutoBuy) ->
    #player_status{sid = Sid, status_mount = StatusMount, id = RoleId} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    NewStatusType = StatusType#status_mount{auto_buy = AutoBuy},
    NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
    NewPlayer = Player#player_status{status_mount = NewStatusMount},
    db:execute(io_lib:format(?sql_player_mount_change_auto_buy, [AutoBuy, RoleId, TypeId])),
    {ok, BinData} = pt_160:write(16024, [?SUCCESS, TypeId, AutoBuy]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

%% 清空祝福值，定时器调用
clear_bless(Player, TypeId) ->
    #player_status{status_mount = StatusMount, id = RoleId, sid = Sid} = Player,
    #status_mount{ref = Ref} = StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    util:cancel_timer(Ref),
    NewStatusType = StatusType#status_mount{blessing = 0, ref = undefined, etime = 0},
    NewStatusMount = lists:keystore(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
    NewPlayer = Player#player_status{status_mount = NewStatusMount},
    db:execute(io_lib:format(?sql_player_mount_clear_bless, [RoleId, TypeId])),
    #status_mount{
        stage = Stage, star = Star, illusion_type = IllusionType, 
        illusion_id = IllusionId, attr = Attr, skills = Skills, 
        combat = Combat, auto_buy = AutoBuy
    } = NewStatusType,
    FigureStage = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, IllusionId, 0), % 没有形象的阶级为 0
    Args = [TypeId, Stage, Star, 0, FigureStage, Combat, 0, AutoBuy, Attr, Skills],
    {ok, BinData} = pt_160:write(16002, Args),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

%%   修改这里时同步处理   dirct_upgrade_star <- (修改了，但是没有找到这个)
do_upgrade_star(Player, TypeId, NewStage, NewStar, NewBlessing, BlessingPlus, Cost, _RateList, Etime) ->
    #player_status{id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #status_mount{
        stage = Stage, star = Star,
        illusion_type = IllusionType, illusion_id = IllusionId, illusion_color = IllusionColor, 
        figure_id = FigureId, ride_attr = RideAttr, figure_skills = FigureSkills, blessing = Blessing,
        skills = _SkillIds, passive_skills = _PassiveSkills, ref = OldRef, etime = OldTime, upgrade_sys_skill = USkillL
    } = StatusType,
    {NewRideAttr, NewIllusionId, NewIllusionColor, _NewFigureId} =
        case NewStage =/= Stage of
            true -> % 升级切换形象
                #mount_stage_cfg{ride_attr = RideAttr1} = data_mount:get_stage_cfg(TypeId, NewStage, Figure#figure.career),
                {IllusionId1, IllusionColor1} = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, {NewStage, 0}, {IllusionId, IllusionColor}),
                FigureId1 = get_figure_id(TypeId, IllusionType, IllusionId1, Figure#figure.career),
                {RideAttr1, IllusionId1, IllusionColor1, FigureId1};
            false ->
                {RideAttr, IllusionId, IllusionColor, FigureId}
        end,
    %% 派发升级事件
    lib_player_event:async_dispatch(RoleId, 400 + TypeId),
    %% 祝福值清空机制
    if 
        TypeId == ?MOUNT_ID orelse TypeId == ?MATE_ID ->
%%            lib_hi_point_api:hi_point_task_mount_upgrade(RoleId,Figure#figure.lv, {NewStage, NewStar}, TypeId),
            case check_max_state(TypeId, NewStage, NewStar) of
                true -> % 特殊情况，满级了，取消定时器，并且设置祝福值为0
                    NewTime = 0,
                    util:cancel_timer(OldRef),
                    NewStatusTypeTmp = StatusType#status_mount{etime = NewTime, ref = undefined};
                false ->
                    if
                        Etime == 0 -> %% 没不动定时器
                            NewTime = OldTime,
                            NewStatusTypeTmp = StatusType;
                        Etime == OldTime -> %% 没升级, 没不动定时器
                            NewTime = OldTime,
                            NewStatusTypeTmp = StatusType;
                        true ->
                            NewTime = Etime,
                            % NewRef = util:send_after(OldRef, 120 * 1000, self(), {'clear_bless', TypeId}), 测试使用
                            NewRef = util:send_after(OldRef, ?CLEAR_BLESSING_TIME * 1000, self(), {'clear_bless', TypeId}),
                            NewStatusTypeTmp = StatusType#status_mount{etime = NewTime, ref = NewRef}
                    end
            end;
        true -> 
            NewTime = OldTime,
            NewStatusTypeTmp = StatusType
    end,
    %% 日志
    lib_log_api:log_mount_upgrade_star(RoleId, TypeId, Stage, Star, Blessing, BlessingPlus, NewStage, NewStar, NewBlessing, Cost, NewTime),
    db:execute(io_lib:format(?sql_update_mount_stage_and_star_and_etime, [NewStage, NewStar, NewBlessing, NewIllusionId, NewIllusionColor, NewTime, RoleId, TypeId])),
    NewPlayer =
        case NewStage =/= Stage orelse NewStar =/= Star of
            true ->
                %%                FigureId = get_figure_id(TypeId, ?BASE_MOUNT_FIGURE, NewStage, ?RIDE_STATUS),
                {_SkillAttr, NewSkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, NewStage, NewStar),
                NewPassiveSkills = lib_skill_api:divide_passive_skill(NewSkillIds ++ FigureSkills ++ USkillL),
                case NewPassiveSkills =/= [] of
                    true ->
                        mod_scene_agent:update(Player, [{passive_skill, NewPassiveSkills}]);
                    false -> skip
                end,
                NewStatusType = NewStatusTypeTmp#status_mount{
                    stage = NewStage,
                    star = NewStar,
                    %% illusion_id = NewIllusionId,
                    %% illusion_color = NewIllusionColor,
                    %% figure_id = NewFigureId,
                    blessing = NewBlessing,
                    ride_attr = NewRideAttr,
                    skills = NewSkillIds,
                    passive_skills = NewPassiveSkills},
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                %% if
                %%     % 形象没有变化
                %%     FigureId == NewFigureId ->
                %%         PlayerAfFigure = count_mount_attr(Player#player_status{status_mount = NewStatusMount});
                %%     true ->
                %%         NewFigure = update_role_show(RoleId, Figure, {TypeId, NewFigureId, NewIllusionColor}),
                %%         NewPlayerTmp = count_mount_attr(Player#player_status{status_mount = NewStatusMount, figure = NewFigure}),
                %%         PlayerAfFigure = unequip_fashion(NewPlayerTmp, TypeId)
                %% end,
                PlayerAfFigure = count_mount_attr(Player#player_status{status_mount = NewStatusMount}),
                Player1 = broadcast_to_scene(TypeId, PlayerAfFigure),
                PlayerAfPower = lib_mount_api:power_change_event(Player1, TypeId),
                PlayerAfEvent = lib_mount_api:star_or_stage_change_event(PlayerAfPower, TypeId, NewStage, NewStar),
                % lib_task_api:train_something(Player1, TypeId, NewStage, NewStar),
                % %%    升级或升阶时调用排行
                % case TypeId of
                %     ?MOUNT_ID ->
                %         lib_rush_rank_api:reflash_rank_by_mount_rush(Player1);
                %     ?MATE_ID -> lib_rush_rank_api:reflash_rank_by_partner_rush(Player1);
                %     ?FLY_ID ->
                %         lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_WING, 1),
                %         lib_rush_rank_api:reflash_rank_by_wing_rush(Player1);
                %     _ ->
                %         skip
                % end,
                % lib_common_rank_api:refresh_rank_by_upgrade(Player1, TypeId),
                % {ok, PlayerAfSupvip} = lib_supreme_vip_api:train_something(Player1, TypeId, NewStage, NewStar),
                PlayerAfEvent;
            false ->
                NewStatusType = NewStatusTypeTmp#status_mount{
                    stage = NewStage,
                    star = NewStar,
                    blessing = NewBlessing,
                    ride_attr = NewRideAttr
                },
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                Player#player_status{status_mount = NewStatusMount}
        end,
    % %成就
    % lib_achievement_api:handle_achievement(TypeId, NewPlayer, NewStage, NewStar),
    %% 更新冲榜榜单信息
    %%    lib_rush_rank_api:reflash_rank_by_mount_rush(NewPlayer),
    % {ok, BinData} = pt_160:write(16005, [?SUCCESS, TypeId, NewStage, NewStar, NewBlessing, BlessingPlus, RateList]),
    % lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

count_star_helper(TypeId, Stage, Star, Blessing, BlessingPlus, Career) ->
    case data_mount:get_star_cfg(TypeId, Stage, Star) of
        #mount_star_cfg{max_blessing = MaxBlessing} when MaxBlessing > 0 ->
            case data_mount:get_stage_cfg(TypeId, Stage, Career) of
                #mount_stage_cfg{max_star = MaxStar} ->
                    case Blessing + BlessingPlus >= MaxBlessing of
                        true ->
                            case Star == MaxStar of
                                true -> %% 升阶
                                    NewStage = Stage + 1,
                                    NewStar = ?MIN_STAR;
                                false ->
                                    NewStage = Stage,
                                    NewStar = Star + 1
                            end,
                            NewBlessingPlus = Blessing + BlessingPlus - MaxBlessing,
                            count_star_helper(TypeId, NewStage, NewStar, 0, NewBlessingPlus, Career);
                        false ->
                            {Stage, Star, Blessing + BlessingPlus}
                    end;
                _ -> {Stage, Star, Blessing + BlessingPlus}
            end;
        _ ->
            {Stage, Star, Blessing + BlessingPlus}
    end.

%% 基础形象
illusion_figure(TypeId, ?BASE_MOUNT_FIGURE, Career, StatusMount, SelStage, _) ->
    #status_mount{stage = Stage, figure_id = OldFigureId} = StatusMount,
    StageCfg = data_mount:get_stage_cfg(TypeId, SelStage, Career),
    if
        SelStage > Stage -> {fail, ?ERRCODE(err160_figure_not_active)};
        is_record(StageCfg, mount_stage_cfg) == false -> {fail, ?ERRCODE(err160_9_config_err)};
        true ->
            FigureId = get_figure_id(TypeId, ?BASE_MOUNT_FIGURE, SelStage, Career),
            if
                FigureId =/= OldFigureId ->
                    NewStatusMount = StatusMount#status_mount{
                        illusion_type = ?BASE_MOUNT_FIGURE,
                        illusion_id = SelStage,
                        illusion_color = 0,
                        figure_id = FigureId
                    },
                    {ok, NewStatusMount, FigureId, 0};
                true ->
                    NewStatusMount = StatusMount#status_mount{
                        illusion_type = 0,
                        illusion_id = 0,
                        illusion_color = 0,
                        figure_id = 0
                    },
                    {ok, NewStatusMount, 0, 0}
            end
    end;

%% 幻化形象
illusion_figure(TypeId, ?ILLUSION_MOUNT_FIGURE, Career, StatusMount, SelId, Color) ->
    #status_mount{figure_list = FigureList, figure_id = OldFigureId} = StatusMount,
    ColorCfgList = data_mount:get_all_color_id(TypeId, SelId),
    FigureInfo = lists:keyfind(SelId, #mount_figure.id, FigureList),
    FigureCfg = data_mount:get_figure_cfg(TypeId, SelId, Career),
    IsMember = Color == 0 orelse lists:member(Color, ColorCfgList),
    if
        IsMember == false -> {fail, ?ERRCODE(err160_figure_color_cfg_missing)};
        FigureInfo == false -> {fail, ?ERRCODE(err160_figure_not_active)};  % 没有激活
        is_record(FigureCfg, mount_figure_cfg) == false -> {fail, ?ERRCODE(err160_9_config_err)};  % 没有配置
        true ->
            #mount_figure{color_list = ColorList} = FigureInfo,
            MaxLevel = data_mount:get_max_color_level(TypeId, SelId, Color),
            FigureId = get_figure_id(TypeId, ?ILLUSION_MOUNT_FIGURE, SelId, Career),
            % db:execute(io_lib:format(?sql_update_mount_illusion, [?ILLUSION_MOUNT_FIGURE, SelId, RoleId])),
            NewStatusMount = StatusMount#status_mount{
                illusion_type = ?ILLUSION_MOUNT_FIGURE,
                illusion_id = SelId,
                illusion_color = Color,
                figure_id = FigureId
            },
            ?PRINT("OldFigureId:~p,FigureId:~p~n",[OldFigureId, FigureId]),
            if
                FigureId == OldFigureId ->
                    {ok, StatusMount#status_mount{illusion_type = 0,illusion_id = 0,illusion_color = 0, figure_id = 0}, 0, 0};
                Color == 0 orelse MaxLevel == 0 ->
                    {ok, NewStatusMount, FigureId, 0};
                true ->
                    case lists:keyfind(Color, 1, ColorList) of
                        {_, Level} when Level >= MaxLevel ->
                            {ok, NewStatusMount, FigureId, Color};
                        _ -> {fail, ?ERRCODE(err160_figure_color_not_active)} %% 染色进度未完成
                    end
            end
    end.




check_active_figure_cost([], _Turn, _FigureList, Result) -> Result;
check_active_figure_cost([H | L], Turn, FigureList, Result) ->
    case H of
        {active_id, [ConId, LimitLv]} ->
            ConFigure = lists:keyfind(ConId, #mount_figure.id, FigureList),
            case ConFigure =/= false of
                true -> % 有条件中的形象Id
                    ConFigureLv = ConFigure#mount_figure.stage,
                    case ConFigureLv >= LimitLv of % 是否满足限制条件
                        true -> check_active_figure_cost(L, Turn, FigureList, Result);
                        false -> {false, ?FAIL}
                    end;
                false -> {false, ?FAIL}
            end;
        {turn, TurnLimit} ->
            case Turn >= TurnLimit of
                true -> check_active_figure_cost(L, Turn, FigureList, Result);
                false -> {false, ?ERRCODE(err160_not_enough_turn)}
            end;
        _ -> {false, ?MISSING_CONFIG}
    end.


%% 激活形象
active_figure(Player, TypeId, Id, StatusType) ->
    #player_status{sid = Sid, id = RoleId, status_mount = StatusMount, figure = Figure = #figure{turn = Turn}, original_attr = OriginalAttr} = Player,
    #status_mount{figure_list = FigureList} = StatusType,
    case lists:keyfind(Id, #mount_figure.id, FigureList) of
        false -> % 已激活幻象列表中没有，需要激活
            case data_mount:get_figure_cfg(TypeId, Id, Figure#figure.career) of % 判断消耗物品的配置
                #mount_figure_cfg{goods_id = ActiveGId, goods_num = ActiveGNum, condition_list = ConList, name = FigureName} ->
                    case check_active_figure_cost(ConList, Turn, FigureList, true) of
                        true ->
                            Cost = case ActiveGNum == 0 of
                                       true -> [];
                                       false -> [{?TYPE_GOODS, ActiveGId, ActiveGNum}]
                                   end,
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_active_figure, "") of
                                {true, NewPlayerTmp} ->
                                    %% 替换为新的幻形形象
                                    _NewIllusionId = Id,
                                    Sql2 = io_lib:format(?sql_player_mount_color_select, [RoleId, TypeId, Id]),
                                    ColorDbList = db:get_all(Sql2),
                                    ColorList = [{ColorId, ColorLv} || [ColorId, ColorLv] <- ColorDbList],
                                    _NewFigureId = get_figure_id(TypeId, ?ILLUSION_MOUNT_FIGURE, Id, Figure#figure.career),
                                    %% 日志     参数：RoleId,FigureId,Type,PreStage,CurStage,Cost
                                    lib_log_api:log_mount_figure_upgrade_stage(RoleId, TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, 1, Cost, 0, 0),
                                    %% 更新数据库
                                    db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, 0, 0])),
                                    {FStarAttr, FAttr, UnlockSkills, FCombat} = count_figure_attr_origin_combat(TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, ColorList, OriginalAttr),
                                    %% 同步新解锁的被动技能到玩家场景
                                    PassiveSkillsAdd = lib_skill_api:divide_passive_skill(UnlockSkills), % 分离被动技能
                                    case PassiveSkillsAdd =/= [] of
                                        true ->
                                            mod_scene_agent:update(NewPlayerTmp, [{passive_skill, PassiveSkillsAdd}]);
                                        false -> skip
                                    end,
                                    TmpR = #mount_figure{id = Id, stage = ?ILLUSION_MIN_STAGE, star = ?ILLUSION_MIN_STAR, star_attr = FStarAttr, attr = FAttr, skills = UnlockSkills, combat = FCombat},
                                    NewFigureList = [TmpR | FigureList],
                                    % 更新幻化数据
                                    %% NewStatusType = refresh_illusion_data(StatusType#status_mount{illusion_type = ?ILLUSION_MOUNT_FIGURE, illusion_id = NewIllusionId, figure_id = NewFigureId, figure_list = NewFigureList}),
                                    %% 激活幻化形象时不在默认穿戴
                                    %% NewStatusType = refresh_illusion_data(StatusType#status_mount{illusion_type = ?ILLUSION_MOUNT_FIGURE, figure_list = NewFigureList}),
                                    NewStatusType = refresh_illusion_data(StatusType#status_mount{figure_list = NewFigureList}),
                                    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                                    % 要用新的figure
                                    %% 20220615版本修改为玩家自由选择穿戴
                                    %% NewPlayerTmp1 = unequip_fashion(NewPlayerTmp, TypeId),
                                    %% NewFigure = update_role_show(RoleId, NewPlayerTmp1#player_status.figure, {TypeId, NewFigureId, NewIllusionColor}),
                                    %% 判断当前是否激活翅膀,是的话脱背饰
                                    %% {ok, NewPlayerJudge} = judgeactive(NewPlayer, TypeId),
                                    NewPlayer = count_mount_attr(NewPlayerTmp#player_status{status_mount = NewStatusMount}),
                                    %% 更新时装套装属性
                                    lib_fashion_suit:event_update_attr(NewPlayer),
                                    NewPlayer2 = broadcast_to_scene(TypeId, NewPlayer), % 坐骑信息变化通知场景玩家
                                    {_, _, _, NewFCombat} = count_figure_attr_origin_combat(TypeId, Id,
                                        ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, ColorList, NewPlayer2#player_status.original_attr),
                                    lib_server_send:send_to_sid(Sid, pt_160, 16008, [?SUCCESS, TypeId, Id, NewFCombat]),
                                    % 传闻
                                    lib_chat:send_TV({all}, ?MOD_MOUNT, 3, [Figure#figure.name, get_mount_name(TypeId), FigureName]),
                                    NewPlayer3 = lib_mount_api:active_mount_figure_event(NewPlayer2, TypeId, Id, NewFigureList),
                                    {ok, LastPlayer} = pp_mount:handle(16002, NewPlayer3, [TypeId]),
                                    LastPlayer2 = lib_mount_api:power_change_event(LastPlayer, TypeId),
                                    lib_common_rank_api:refresh_rank_by_upgrade(LastPlayer2, TypeId),
                                    lib_fashion_suit:update_conform_num(LastPlayer2, ?SUIT_POST_MOUNT, TypeId, Id),
                                    {ok, LastPlayer2};
                                    % %% 成就
                                    % lib_achievement_api:handle_achievement_figure(NewPlayer2, TypeId, erlang:length(NewFigureList)),
                                    % lib_task_api:train_something(NewPlayer2, TypeId, 1, 0), %% 更新任务
                                    % %% 升阶升战活动
                                    % lib_train_act:mount_train_stage_up(NewPlayer2, TypeId),
                                    % lib_train_act:mount_train_power_up(NewPlayer2, TypeId),
                                    % {ok, PlayerAfSupVip} = lib_supreme_vip_api:mount_acti_figure_event(NewPlayer2, TypeId, Id),
                                    % {ok, LastPlayer} = lib_achievement_api:mount_acti_figure_event(PlayerAfSupVip, Id); % 成就api
                                {false, ErrorCode, LastPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_160, 16000, [ErrorCode])
                            end;
                        {false, ErrCode} ->
                            LastPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_160, 16000, [ErrCode])
                    end;
                _ ->
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_160, 16000, [?ERRCODE(missing_config)])
            end;
        _ -> LastPlayer = Player, %% 已经激活过
            lib_server_send:send_to_sid(Sid, pt_160, 16000, [?ERRCODE(err160_figure_already_active)])
    end,
    if
        TypeId == ?PET_ID ->
            lib_rush_rank_api:reflash_rank_by_aircraft_rush(LastPlayer);
        true ->
            sip
    end,
    {ok, LastPlayer}.

%% 坐骑幻形升星检测
check_figure_upgrade_stage(TypeId, StatusMount, SelId, Career, GoodsId) ->
    #status_mount{figure_list = FigureList} = StatusMount,
    FigureInfo = lists:keyfind(SelId, #mount_figure.id, FigureList),
    FigureCfg = data_mount:get_figure_cfg(TypeId, SelId, Career),
    if
        is_record(FigureCfg, mount_figure_cfg) == false -> {fail, ?ERRCODE(err_config)};  %后台没有配置
        FigureInfo == false -> {fail, ?ERRCODE(err160_figure_not_active)};   % 坐骑形象未激活
        true ->
            #mount_figure_cfg{exp_goods = ExpGoods} = FigureCfg,
            SpeGoods = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_SPECIAL),
            IsMember = lists:member(TypeId, ?STAGE_CONFIG),
            AllGoods = ?IF(IsMember == true, ?IF(GoodsId == 0, ExpGoods -- SpeGoods, [GoodsId]), []),
            #mount_figure{stage = Stage, end_time = EndTime} = FigureInfo,
            StageCfg = data_mount:get_figure_stage_cfg(TypeId, SelId, Stage),
            NextStageCfg = data_mount:get_figure_stage_cfg(TypeId, SelId, Stage + 1),
            IsGoodsMember = lists:member(GoodsId, ExpGoods),
            if
                GoodsId =/= 0 andalso IsGoodsMember == false -> {fail, ?ERRCODE(err160_not_exp_goods)};
                EndTime =/= 0 ->
                    {fail, ?ERRCODE(err160_temp_figure)};
                is_record(StageCfg, mount_figure_stage_cfg) == false ->
                    {fail, ?ERRCODE(err_config)};
                is_record(NextStageCfg, mount_figure_stage_cfg) == false ->
                    {fail, ?ERRCODE(err160_figure_max_stage)};  % 没有配置 ，已达满阶
                true -> {ok, StageCfg, FigureInfo, AllGoods}
            end
    end.
%%------------------------------------------------------------------------------
%% 计算升阶辅助
count_stage_sp_helper(TypeId, Id, Stage, Blessing, BlessingPlus) ->
    case data_mount:get_figure_stage_cfg(TypeId, Id, Stage) of
        #mount_figure_stage_cfg{max_blessing = MaxBlessing} when MaxBlessing > 0 ->
            case Blessing + BlessingPlus >= MaxBlessing of
                true ->
                    NewStage = Stage + 1,
                    NewBlessingPlus = Blessing + BlessingPlus - MaxBlessing,
                    count_stage_sp_helper(TypeId, Id, NewStage, 0, NewBlessingPlus);
                false ->
                    {Stage, Blessing + BlessingPlus}
            end;
        _ ->
            {Stage, Blessing + BlessingPlus}
    end.


%% 外形类幻形升阶 (坐骑，伙伴)
upgrade_stage_sp(Player, _MaxBless, _TypeId, _Id, ErrCode, [], _) -> {ErrCode, Player};
upgrade_stage_sp(Player, MaxBless, TypeId, Id, _ErrCode, [GoodsId | GoodsList], SendGoodsId) ->
    #player_status{sid = Sid, status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #status_mount{figure_list = FigureList} = StatusType, % 已激活的幻形列表
    FigureInfo = lists:keyfind(Id, #mount_figure.id, FigureList),
    #mount_figure{stage = Stage, blessing = Blessing} = FigureInfo,
    % 物品的加的经验和暴击
    #mount_prop_cfg{exp = Exp, ratio = Ratio} = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
    [{_GoodsId, OwnNum}] = lib_goods_api:get_goods_num(Player, [GoodsId]),
    {Code, NewPlayer} =
        case OwnNum > 0 of
            true ->
                NeedCost = MaxBless - Blessing, % 升级所需的消耗数量
                {RealCostNum, BlessingPlus, RateList} = mount_grage_cost(Blessing, OwnNum, Exp, Ratio, NeedCost, 0, 0, []),
                {NewStage, NewBlessing} = count_stage_sp_helper(TypeId, Id, Stage, Blessing, BlessingPlus),
                Cost = [{?TYPE_GOODS, GoodsId, RealCostNum}],
                {ErrCode1, Player1} = do_upgrade_stage_sp(Player, TypeId, Id, NewStage, NewBlessing, BlessingPlus, Cost),
                case ErrCode1 == ok orelse ErrCode1 == notup of
                    true ->
                        {ok, BinData} = pt_160:write(16009, [?SUCCESS, TypeId, Id, NewStage, NewBlessing, BlessingPlus, RateList, SendGoodsId]),
                        lib_server_send:send_to_sid(Sid, BinData);
                    _ -> 
                        skip
                end,
                {ErrCode1, Player1};
            false ->
                {?ERRCODE(err160_not_enough_cost), Player}
        end,
    case Code =:= ok orelse Code =:= ?ERRCODE(err160_max_star) of % 判断是否升级 或 达到最高等级、物品配置
        true -> % 当已经升级 或 达到最高等级、物品配置
            {Code, NewPlayer};
        false -> % 当没有升级
            upgrade_stage_sp(NewPlayer, MaxBless, TypeId, Id, Code, GoodsList, SendGoodsId)
    end.

do_upgrade_stage_sp(Player, TypeId, Id, NewStage, NewBlessing, BlessingPlus, Cost) ->
    case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_figure_upgrade_stage, "") of
        {true, NewPlayerTmp} -> % 物品满足条件扣除
            #player_status{id = RoleId, status_mount = StatusMount, original_attr = OriginAttr} = Player,
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            #status_mount{figure_list = FigureList} = StatusType, % 已激活的幻形列表
            FigureInfo = lists:keyfind(Id, #mount_figure.id, FigureList),
            #mount_figure{stage = Stage, end_time = EndTime} = FigureInfo,
            %% 日志   RoleId, FigureId, Type, PreStage, CurStage, Cost , BlessingPlus, Blessing
            lib_log_api:log_mount_figure_upgrade_stage(RoleId, TypeId, Id, 2, Stage, NewStage, Cost, BlessingPlus, NewBlessing),
            NewFigureInfo = do_figure_upgrade_stage(TypeId, FigureInfo, NewStage, NewBlessing, OriginAttr),
            NewFigureList = lists:keystore(Id, #mount_figure.id, FigureList, NewFigureInfo),
            NewStatusType = StatusType#status_mount{figure_list = NewFigureList},
            #mount_figure{stage = NewStage, star = Star, skills = UnlockSkills} = NewFigureInfo,
            db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, NewStage, Star, NewBlessing, EndTime])),
            case NewStage =/= Stage of
                true ->
                    LastStatusType = refresh_illusion_data(NewStatusType),
                    %% 同步新解锁的被动技能到玩家场景
                    PassiveSkills = lib_skill_api:divide_passive_skill(UnlockSkills),
                    case PassiveSkills =/= [] of
                        true ->
                            mod_scene_agent:update(NewPlayerTmp, [{passive_skill, PassiveSkills}]);
                        false -> skip
                    end,
                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, LastStatusType),
                    NewPlayerTmp1 = NewPlayerTmp#player_status{status_mount = LastStatusMount},
%%                                NewPlayerTmp1 = count_mount_attr(TypeId, NewPlayerTmp#player_status{status_mount = LastStatusMount}),
                    LastPlayer = broadcast_to_scene_1(TypeId, NewPlayerTmp1),
                    LastPlayer1 = lib_mount_api:power_change_event(LastPlayer, TypeId),
                    LastPlayerAfEvent = lib_mount_api:figure_stage_star_change(LastPlayer1, NewFigureList, TypeId, Id, NewStage, Star),
                    {ok, LastPlayerAfEvent};
                false ->
                    NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                    LastPlayer = NewPlayerTmp#player_status{status_mount = NewStatusMount},
                    {notup, LastPlayer}
            end;
        {false, 1003, NewPlayerTmp} -> {?ERRCODE(err160_not_enough_cost), NewPlayerTmp};
        {false, ErrorCode, NewPlayerTmp} -> ?PRINT("ErrorCode:~p, Cost:~p~n",[ErrorCode,Cost]),{ErrorCode, NewPlayerTmp}
    end.

%% 幻型升阶
figure_upgrade_stage_sp(Player, TypeId, Id, StatusType, GoodsId) ->
    #player_status{sid = Sid, figure = Figure} = Player,
    {ECode, LPlayer} =
        case check_figure_upgrade_stage(TypeId, StatusType, Id, Figure#figure.career, GoodsId) of % 检查是否可以升阶
            {ok, StageCfg, _FigureInfo, AllGoods} ->
                MaxBless = StageCfg#mount_figure_stage_cfg.max_blessing, % 幻型升阶的所需经验
                {Code, NewPlayer} = upgrade_stage_sp(Player, MaxBless, TypeId, Id, 0, AllGoods, GoodsId),
                %% 更新时装套装属性
                lib_fashion_suit:event_update_attr(NewPlayer),
                NewPlayer1 = count_mount_attr(NewPlayer),
                NewPlayer2 = lib_player:count_player_attribute(NewPlayer1),
                lib_player:send_attribute_change_notify(NewPlayer2, ?NOTIFY_ATTR),
                % lib_common_rank_api:refresh_rank_by_upgrade(NewPlayer2, TypeId),
                % %% 升阶升战活动
                % lib_train_act:mount_train_stage_up(NewPlayer2, TypeId),
                % lib_train_act:mount_train_power_up(NewPlayer2, TypeId),
                {Code, NewPlayer2};
            {fail, ErrorCode3} -> {ErrorCode3, Player}
        end,
    case is_integer(ECode) of
        true ->
            {ok, BinData1} = pt_160:write(16000, [ECode]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,

    {ok, LPlayer}.


%% 外形类幻形升阶（除坐骑，伙伴）
figure_upgrade_stage(Player, TypeId, Id, StatusType) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_mount = StatusMount, original_attr = OriginAttr} = Player,
    #status_mount{figure_list = FigureList} = StatusType, % 已激活的幻形列表
    {ECode, LPlayer} =
        case check_figure_upgrade_stage(TypeId, StatusType, Id, Figure#figure.career, 0) of % 检查是否可以升阶
            {ok, StageCfg, FigureInfo, _} ->
                #mount_figure{stage = Stage, blessing = Bless, end_time = EndTime} = FigureInfo,
                Cost = StageCfg#mount_figure_stage_cfg.cost, % 幻型升阶的消耗
                case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_figure_upgrade_stage, "") of
                    {true, NewPlayerTmp} ->
                        NewStage = Stage + 1, % 更新阶级
                        %% 日志   RoleId, FigureId, Type, PreStage, CurStage, Cost
                        lib_log_api:log_mount_figure_upgrade_stage(RoleId, TypeId, Id, 2, Stage, NewStage, Cost, 0, 0),
                        NewFigureInfo = do_figure_upgrade_stage(TypeId, FigureInfo, NewStage, 0, OriginAttr),
                        NewFigureList = lists:keystore(Id, #mount_figure.id, FigureList, NewFigureInfo),
                        NewStatusType = StatusType#status_mount{figure_list = NewFigureList},
                        #mount_figure{stage = NewStage, star = Star, skills = UnlockSkills} = NewFigureInfo,
                        db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, NewStage, Star, Bless, EndTime])),
                        case NewStage =/= Stage of
                            true ->
                                LastStatusType = refresh_illusion_data(NewStatusType),
                                %% 同步新解锁的被动技能到玩家场景
                                PassiveSkills = lib_skill_api:divide_passive_skill(UnlockSkills),
                                case PassiveSkills =/= [] of
                                    true ->
                                        mod_scene_agent:update(NewPlayerTmp, [{passive_skill, PassiveSkills}]);
                                    false -> skip
                                end,
                                LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, LastStatusType),
                                NewPlayerTmp1 = NewPlayerTmp#player_status{status_mount = LastStatusMount},
                                %% 更新时装套装属性
                                lib_fashion_suit:event_update_attr(NewPlayerTmp1),
                                NewPlayerTmp2 = count_mount_attr(NewPlayerTmp1),
                                LastPlayer = broadcast_to_scene(TypeId, NewPlayerTmp2);
                            false ->
                                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                                LastPlayer = NewPlayerTmp#player_status{status_mount = NewStatusMount}
                        end,
                        {ok, BinData} = pt_160:write(16009, [?SUCCESS, TypeId, Id, NewStage, 0, 0, [], 0]),
                        lib_server_send:send_to_sid(Sid, BinData),
                        LastPlayer1 = lib_mount_api:power_change_event(LastPlayer, TypeId),
                        LastPlayerAfEvent = lib_mount_api:figure_stage_star_change(LastPlayer1, NewFigureList, TypeId, Id, NewStage, Star),
                        % TypeId == ?PET_ID andalso 
                        %     lib_achievement_api:async_event(RoleId, lib_achievement_api, pet_lv_up_event, NewFigureList),
                        % lib_common_rank_api:refresh_rank_by_upgrade(LastPlayer, TypeId),
                        % %% 升阶升战活动
                        % lib_train_act:mount_train_stage_up(LastPlayer, TypeId),
                        % lib_train_act:mount_train_power_up(LastPlayer, TypeId),
                        {nothing, LastPlayerAfEvent};
                    {false, 1003, LastPlayer1} -> {?ERRCODE(err160_not_enough_cost), LastPlayer1};
                    {false, ErrorCode2, LastPlayer2} -> {ErrorCode2, LastPlayer2}
                end;
            {fail, ErrorCode3} -> {ErrorCode3, Player}
        end,
    case is_integer(ECode) of
        true ->
            {ok, BinData1} = pt_160:write(16000, [ECode]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,
    if
        TypeId == ?PET_ID ->
            lib_rush_rank_api:reflash_rank_by_aircraft_rush(LPlayer);
        true ->
            skip
    end,
    {ok, battle_attr, LPlayer}.

do_figure_upgrade_stage(TypeId, FigureInfo, NewStage, NewBlessing, OriginAttr) ->
    #mount_figure{id = Id, star = Star, color_list = ColorList} = FigureInfo,
    {FStarAttr, FAttr, UnlockSkills, FCombat} = count_figure_attr_origin_combat(TypeId, Id, NewStage, Star, ColorList, OriginAttr),
    FigureInfo#mount_figure
    {
        stage = NewStage,
        attr = FAttr,
        star_attr = FStarAttr,
        skills = UnlockSkills,
        combat = FCombat,
        blessing = NewBlessing
    }.

%% 外形直升丹   (PlayerStatus, GoodsInfo, GoodsNum) -> {ok, PlayerStatus,UsedNum} | {fail, ?ErrCode}
direct_level_up(#player_status{status_mount = StatusMount} = Player, GoodsInfo, GoodsNum) ->
    #goods{goods_id = GoodsId} = GoodsInfo,
    case data_mount:get_special_goods(GoodsId) of
        #mount_sp_goods_cfg{type_id = TypeId, use_condition = Cond, add_star = AddStar, add_exp = AddExp} ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount), % 是否有外观配置
            case StatusType =/= false of
                true ->
                    case lists:member(TypeId, ?STAGE_CONFIG) of
                        true -> % 升阶配置
                            {NewGoodsNum, NewPlayer} = direct_stage_up_help(Player, TypeId, Cond, GoodsNum, AddStar, AddExp, GoodsId),
                            UsedNum = GoodsNum - NewGoodsNum,
                            {ok, NewPlayer, UsedNum};
                        false -> % 升星配置
                            {NewGoodsNum, NewPlayer} = direct_star_up_help(Player, TypeId, Cond, GoodsNum, AddStar, AddExp, GoodsId),
                            UsedNum = GoodsNum - NewGoodsNum,
                            {ok, NewPlayer, UsedNum}
                    end;
                false ->
                    {fail, ?ERRCODE(err160_3_figure_inactive)}
            end;
        [] ->
            {fail, ?MISSING_CONFIG}
    end.

%% 升阶
direct_stage_up_help(Player, _TypeId, _StageCond, GoodsNum, _AddStar, _AddExp, _GoodsId) when GoodsNum =< 0 ->
    {GoodsNum, Player};
direct_stage_up_help(Player, TypeId, StageCond, GoodsNum, AddStar, AddExp, GoodsId) ->
    #player_status{figure = #figure{career = Career}, status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case check_upgrade_star(StatusType, Career) of
        {ok, _MaxBless} ->
            #status_mount{type_id = TypeId, stage = Stage, star = Star, blessing = Blessing} = StatusType,
            Cost = [{?TYPE_GOODS, GoodsId, 1}],
            case StageCond < Stage of
                true -> % 增加经验
                    {NewStage, NewStar, NewBlessing} = count_star_helper(TypeId, Stage, Star, Blessing, AddExp, Career),
                    {ok, NewPlayer} = direct_upgrade_star(Player, TypeId, NewStage, NewStar, NewBlessing, AddExp, Cost);
                false -> % 增加阶级
                    {ok, NewPlayer} = direct_upgrade_star(Player, TypeId, Stage + AddStar, Star, Blessing, 0, Cost)
            end,
            direct_stage_up_help(NewPlayer, TypeId, StageCond, GoodsNum - 1, AddStar, AddExp, GoodsId);
        {fail, _ErrCode} ->
            {GoodsNum, Player}
    end.


%% 升星
direct_star_up_help(Player, _TypeId, _StageCond, GoodsNum, _AddStar, _AddExp, _GoodsId) when GoodsNum =< 0 ->
    {GoodsNum, Player};
direct_star_up_help(Player, TypeId, StarCond, GoodsNum, AddStar, AddExp, GoodsId) ->
    #player_status{figure = #figure{career = Career}, status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case check_upgrade_star(StatusType, Career) of
        {ok, _MaxBless} ->
            #status_mount{type_id = TypeId, stage = Stage, star = Star, blessing = Blessing} = StatusType,
            Cost = [{?TYPE_GOODS, GoodsId, 1}],
            case StarCond < Star of
                true -> % 增加经验
                    {NewStage, NewStar, NewBlessing} = count_star_helper(TypeId, Stage, Star, Blessing, AddExp, Career),
                    {ok, NewPlayer} = direct_upgrade_star(Player, TypeId, NewStage, NewStar, NewBlessing, AddExp, Cost);
                false -> % 增加星级
                    {ok, NewPlayer} = direct_upgrade_star(Player, TypeId, Stage, Star + AddStar, Blessing, 0, Cost)
            end,
            direct_star_up_help(NewPlayer, TypeId, StarCond, GoodsNum - 1, AddStar, AddExp, GoodsId);
        {fail, _ErrCode} ->
            {GoodsNum, Player}
    end.


%% 直接升星
direct_upgrade_star(Player, TypeId, NewStage, NewStar, NewBlessing, BlessingPlus, Cost) ->
    #player_status{sid = Sid, id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    #status_mount{
        stage = Stage, star = Star, illusion_color = IllusionColor,
        illusion_type = IllusionType, illusion_id = IllusionId, figure_id = FigureId,
        ride_attr = RideAttr, figure_skills = FigureSkills, blessing = Blessing, etime = Etime,
        upgrade_sys_skill = USkillL
    } = StatusType,
    {NewRideAttr, NewIllusionId, NewIllusionColor, NewFigureId} =
        case NewStage =/= Stage of
            true -> % 升级切换形象
                #mount_stage_cfg{ride_attr = RideAttr1} = data_mount:get_stage_cfg(TypeId, NewStage, Figure#figure.career),
                {IllusionId1, IllusionColor1} = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, {NewStage, 0}, {IllusionId, IllusionColor}),
                FigureId1 = get_figure_id(TypeId, IllusionType, IllusionId1, Figure#figure.career),
                {RideAttr1, IllusionId1, IllusionColor1, FigureId1};
            false ->
                {RideAttr, IllusionId, IllusionColor, FigureId}
        end,
    %% 派发升级事件
    lib_player_event:async_dispatch(RoleId, 400 + TypeId),
    %% 日志 
    lib_log_api:log_mount_upgrade_star(RoleId, TypeId, Stage, Star, Blessing, BlessingPlus, NewStage, NewStar, NewBlessing, Cost, Etime),
    db:execute(io_lib:format(?sql_update_mount_stage_and_star, [NewStage, NewStar, NewBlessing, NewIllusionId, NewIllusionColor, RoleId, TypeId])),
    NewPlayer =
        case NewStage =/= Stage orelse NewStar =/= Star of
            true ->
                
                {_SkillAttr, NewSkillIds} = get_mount_skill(TypeId, ?MOUNT_BASE_SKILL, 0, NewStage, NewStar),
                NewPassiveSkills = lib_skill_api:divide_passive_skill(NewSkillIds ++ FigureSkills ++ USkillL),
                case NewPassiveSkills =/= [] of
                    true ->
                        mod_scene_agent:update(Player, [{passive_skill, NewPassiveSkills}]);
                    false -> skip
                end,
                NewStatusType = StatusType#status_mount{
                    stage = NewStage,
                    star = NewStar,
                    illusion_id = NewIllusionId,
                    illusion_color = NewIllusionColor,
                    figure_id = NewFigureId,
                    blessing = NewBlessing,
                    ride_attr = NewRideAttr,
                    skills = NewSkillIds,
                    passive_skills = NewPassiveSkills},
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                if
                    % 形象没有变化
                    FigureId == NewFigureId ->
                        PlayerAfFigure = count_mount_attr(Player#player_status{status_mount = NewStatusMount});
                    true ->
                        NewFigure = update_role_show(RoleId, Figure, {TypeId, NewFigureId, NewIllusionColor}),
                        NewPlayerTmp = count_mount_attr(Player#player_status{status_mount = NewStatusMount, figure = NewFigure}),
                        PlayerAfFigure = unequip_fashion(NewPlayerTmp, TypeId)
                end,
                Player1 = broadcast_to_scene(TypeId, PlayerAfFigure),
                NewPlayer1 = lib_mount_api:power_change_event(Player1, TypeId),
                NewPlayer2 = lib_mount_api:star_or_stage_change_event(NewPlayer1, TypeId, NewStage, NewStar),
                % lib_task_api:train_something(Player1, TypeId, NewStage, NewStar),
                % %%    升级或升阶时调用排行
                % case TypeId of
                %     ?MOUNT_ID -> lib_rush_rank_api:reflash_rank_by_mount_rush(Player1);
                %     ?MATE_ID -> lib_rush_rank_api:reflash_rank_by_partner_rush(Player1);
                %     ?FLY_ID -> lib_rush_rank_api:reflash_rank_by_wing_rush(Player1);
                %     _ ->
                %         skip
                % end,
                NewPlayer2;
            false ->
                NewStatusType = StatusType#status_mount{
                    stage = NewStage,
                    star = NewStar,
                    blessing = NewBlessing,
                    ride_attr = NewRideAttr
                },
                NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                Player#player_status{status_mount = NewStatusMount}
        end,
    % %  成就
    % lib_achievement_api:handle_achievement(TypeId, NewPlayer, NewStage, NewStar),
    {ok, BinData} = pt_160:write(16005, [?SUCCESS, TypeId, NewStage, NewStar, NewBlessing, BlessingPlus, []]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.


%%-----------------------外部调用 -----------------------------------

%% 外形坐骑类的总属性和总战力
get_mount_all_attr(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    Fun =
        fun(TypeId, {Attr, PowTmp}) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{attr = AttrType, skills = Skills, figure_skills = FigureSkill, upgrade_sys_skill = USkill} = StatusType,
                    AttrSum = util:combine_list(Attr ++ AttrType),
                    Fun1 =  fun(SkillId, PowerTmp) ->
                        lib_skill_api:get_skill_power(SkillId, 1) + PowerTmp
                        end,
                    NewPower = lists:foldl(Fun1, 0, Skills ++ FigureSkill ++ USkill),
                    {_, FairyBuySkill} = lib_fairy_buy:get_fairy_buy_attr_and_skill(PS, TypeId),
                    FairyBuySkillPow = lib_skill_api:get_skill_power(FairyBuySkill),
                    {AttrSum, NewPower + PowTmp + FairyBuySkillPow};
                false ->
                    {Attr, PowTmp}
            end
        end,
    lists:foldl(Fun, {[], 0}, ?APPERENCE).

get_exp_ratio(PS) ->
    {MountAttr, _MountPower} = lib_mount:get_mount_all_attr(PS),
    {_, ExpRatio} = ulists:keyfind(?EXP_ADD, 1, MountAttr, {?EXP_ADD, 0}),
    ExpRatio.

%% 获取所有的技能
get_all_skills(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    Fun =
        fun(TypeId, Attr) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{skills = Skill} = StatusType,
                    Attr ++ Skill;
                false -> Attr
            end
        end,
    lists:foldl(Fun, [], ?APPERENCE).
%%
get_all_figure_skills(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    Fun =
        fun(TypeId, Attr) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{figure_skills = Skill} = StatusType,
                    Attr ++ Skill;
                false -> Attr
            end
        end,
    lists:foldl(Fun, [], ?APPERENCE).


%% 外形类的总被动属性
get_all_passive_skills(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    Fun =
        fun(TypeId, Attr) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{passive_skills = PassiveSkill} = StatusType,
                    _AttrSum = util:combine_list(Attr ++ PassiveSkill);
                false -> Attr
            end
        end,
    lists:foldl(Fun, [], ?APPERENCE).


%% 外形类的等级
get_status_star(TypeId, Player) ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            _Star = StatusType#status_mount.star;
        false -> 0
    end.

%% 获取外形所有的 is_ride 状态
get_status_all_is_ride(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    _IsRide = [{MonRecord#status_mount.type_id, MonRecord#status_mount.is_ride} || MonRecord <- StatusMount, is_record(MonRecord, status_mount)]
.


%% 外形的 is_ride 状态
get_status_is_ride(TypeId, PS) ->
    #player_status{status_mount = StatusMount} = PS,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            _IsRide = StatusType#status_mount.is_ride;
        false -> 0
    end.

%% 获取外形所有的 figure_id 状态
get_status_all_figure_id(PS) ->
    #player_status{status_mount = StatusMount} = PS,
    _FigureIds = [{MonRecord#status_mount.type_id, MonRecord#status_mount.figure_id} || MonRecord <- StatusMount, is_record(MonRecord, status_mount)]
.

%% 外形的坐骑id
get_status_figure_id(TypeId, PS) ->
    #player_status{status_mount = StatusMount} = PS,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            _FigureId = StatusType#status_mount.figure_id;
        false -> 0
    end.


%% 外形的 combat
get_status_combat(TypeId, Player) ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            _Star = StatusType#status_mount.combat;
        false -> 0
    end.


%% 外形的 stage
get_status_stage(TypeId, Player) ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            _Star = StatusType#status_mount.stage;
        false -> 0
    end.

%% 外形的 阶数和星数
get_status_stage_star(TypeId, Player) ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            {StatusType#status_mount.stage, StatusType#status_mount.star};
        false ->
            {0, 0}
    end.


%% 更新角色的 figure
update_role_show(RoleId, Figure, {TypeId, FigureId, ColorId}) ->
    #figure{mount_figure = MountFigure} = Figure,
    NewMountFigure = lists:keystore(TypeId, 1, MountFigure, {TypeId, FigureId, ColorId}),
    lib_role:update_role_show(RoleId, [{mount_figure, NewMountFigure}]),
    Figure#figure{mount_figure = NewMountFigure}.

%% 检查技能是否存在
check_skill_has_learn(Player, Type, SkillId) ->
    #player_status{status_mount = StatusMountL} = Player,
    case lists:keyfind(Type, #status_mount.type_id, StatusMountL) of
        false -> false;
        #status_mount{figure_list = FigureList, stage = Stage, skills = Skills, figure_skills = FigureSkills, upgrade_sys_skill = USkill} ->
            FigureIds = [Id || #mount_figure{id = Id} <- FigureList],
            ActiveSkills = get_active_skills(Type, FigureIds, Stage),
            lists:member(SkillId, Skills ++ FigureSkills ++ ActiveSkills ++ USkill)
    end.

%% 技能职业转化成培养类型
skill_career_to_train_type(?SKILL_CAREER_MATE) -> ?MATE_ID;
skill_career_to_train_type(_) -> 0.

%% 培养类型转换战斗对象
train_type_to_att_type(?MATE_ID) -> ?BATTLE_SIGN_MATE;
train_type_to_att_type(_) -> 0.


%%任务触发激活 (相当于等级激活)
active_base_task(RoleId, TypeId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_mount, cast_active_base_task, [TypeId]),
    ok.

cast_active_base_task(Player, TypeId) ->
    #player_status{status_mount = OldStatusMount} = Player,
    case lists:member(TypeId, ?APPERENCE) of % 是否有外观种类
        true ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, OldStatusMount), % 是否有外观配置
            case StatusType =/= false of
                true ->
                    lib_task_api:train_something(Player, TypeId, 1, 0), ok; %% 还是让培养人物触发
                false ->
                    NewPlayer = do_base_active(TypeId, Player),
                    {ok, NewPlayer}
            end;
        false -> skip
    end.

%% 获取外形数据库  return [{外形类型，形象类型}]
get_figure_list(RoleId, Career) ->
    FigureList = db:get_all(io_lib:format(?sql_player_all_figure_select, [RoleId])),
    case is_list(FigureList) of
        true -> get_figure_list_help(FigureList, Career, []);
        false -> []
    end.

get_figure_list_help([], _Career, MountList) -> MountList;
get_figure_list_help([FigureList | T], Career, MountList) ->
    [TypeId, IllusionType, IllusionId, IllusionColor] = FigureList,
    FigureId = get_figure_id(TypeId, IllusionType, IllusionId, Career),
    Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
    get_figure_list_help(T, Career, [{TypeId, FigureId, Color} | MountList]).


%% 根据配置获取主动技能
get_active_skills(TypeId, FigureIds, Stage) ->
    %%   幻型形象对应的主动技能
    F = fun(Id, List) ->
        List ++ data_mount:get_unlock_skill(TypeId, 3, Id, 0)
        end,
    ActiveFigureSkills = lists:foldl(F, [], FigureIds),
    %%  基础形象对应的主动技能
    ActiveBaseSkills = get_unlock_skill_help(TypeId, Stage, []),
    ActiveFigureSkills ++ ActiveBaseSkills.


get_unlock_skill_help(_TypeId, Stage, SkillList) when Stage < ?MIN_STAGE ->
    case SkillList of
        [] ->
            [800101];
        ActiveSkills ->
            ActiveSkills
    end;
get_unlock_skill_help(TypeId, Stage, SkillList) ->
    SkillIdList = data_mount:get_unlock_skill(TypeId, 3, 0, Stage),
    get_unlock_skill_help(TypeId, Stage - 1, SkillIdList ++ SkillList).

%% 外形幻化激活临时形象 api   SetArgs :[{end_time,Time}|其他参数] （end_time 结束的时间戳）
active_figure_api(Player, TypeId, Id, SetArgs) ->
    #player_status{sid = Sid, id = RoleId, status_mount = StatusMount, figure = Figure, original_attr = OriginAttr} = Player,
    % 是否有外观种类
    case lists:member(TypeId, ?APPERENCE) of
        true ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            % 是否有外观配置
            case StatusType =/= false of
                true ->
                    #status_mount{figure_list = FigureList} = StatusType,
                    %%  是否有幻化形象
                    case lists:keyfind(Id, #mount_figure.id, FigureList) of
                        false -> % 已激活幻象列表中没有，需要激活
                            %% 替换为新的幻形形象
                            NewFigureId = get_figure_id(TypeId, ?ILLUSION_MOUNT_FIGURE, Id, Figure#figure.career),
                            %% 日志     参数：RoleId,FigureId,Type,PreStage,CurStage,Cost
                            lib_log_api:log_mount_figure_upgrade_stage(RoleId, TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, 1, [], 0, 0),
                            EndTime = case lists:keyfind(end_time, 1, SetArgs) of
                                          {end_time, ETime} -> ETime;
                                          false -> 0
                                      end,
                            Sql2 = io_lib:format(?sql_player_mount_color_select, [RoleId, TypeId, Id]),
                            ColorDbList = db:get_all(Sql2),
                            ColorList = [{ColorId, ColorLv} || [ColorId, ColorLv] <- ColorDbList],
                            %% 更新数据库
                            db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, 0, EndTime])),
                            {FStarAttr, FAttr, UnlockSkills, FCombat} = count_figure_attr_origin_combat(TypeId, Id, ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, ColorList, OriginAttr),
                            %% 同步新解锁的被动技能到玩家场景
                            PassiveSkillsAdd = lib_skill_api:divide_passive_skill(UnlockSkills), % 分离被动技能
                            case PassiveSkillsAdd =/= [] of
                                true ->
                                    mod_scene_agent:update(Player, [{passive_skill, PassiveSkillsAdd}]);
                                false -> skip
                            end,
                            TmpR = #mount_figure{
                                id = Id, stage = ?ILLUSION_MIN_STAGE, 
                                star = ?ILLUSION_MIN_STAR, attr = FAttr,
                                star_attr = FStarAttr,
                                skills = UnlockSkills, combat = FCombat, 
                                end_time = EndTime, color_list = ColorList},
                            NewFigureList = [TmpR | FigureList],
                             %% 成就
                            lib_achievement_api:handle_achievement_figure(Player, TypeId, erlang:length(NewFigureList)),
                            % 更新幻化数据
                            NewStatusType = refresh_illusion_data(StatusType#status_mount{illusion_type = ?ILLUSION_MOUNT_FIGURE, illusion_id = Id, figure_id = NewFigureId, figure_list = NewFigureList}),
                            NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                            NewFigure = update_role_show(RoleId, Figure, {TypeId, NewFigureId}),
                            NewPlayer = count_mount_attr(Player#player_status{status_mount = NewStatusMount, figure = NewFigure}),
                            NewPlayer1 = check_figure_time(NewPlayer),
                            LastPlayer = broadcast_to_scene(TypeId, NewPlayer1), % 坐骑信息变化通知场景玩家
                            {_,_, _, NewFCombat} = count_figure_attr_origin_combat(TypeId, Id,
                                ?ILLUSION_MIN_STAGE, ?ILLUSION_MIN_STAR, ColorList, LastPlayer#player_status.original_attr),
                            lib_server_send:send_to_sid(Sid, pt_160, 16008, [?SUCCESS, TypeId, Id, NewFCombat]),
                            LastPlayer;
                        #mount_figure{end_time = OldEndTime, star = Star, color_list = ColorList} = MountFigure when OldEndTime =/= 0 -> %% 更改形象的过期时间
                            EndTime = case lists:keyfind(end_time, 1, SetArgs) of
                                          {end_time, ETime} -> ETime;
                                          false -> OldEndTime
                                      end,
                            %% 更新数据库
                            db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, 1, Star, 0, EndTime])),
                            {_,_, _, NewFCombat} = count_figure_attr_origin_combat(TypeId, Id,
                                1, Star, ColorList, Player#player_status.original_attr),
                            lib_server_send:send_to_sid(Sid, pt_160, 16008, [?SUCCESS, TypeId, Id, NewFCombat]),
                            NewFigureList = lists:keyreplace(Id, #mount_figure.id, FigureList, MountFigure#mount_figure{end_time = EndTime}),
                            NewStatusType = StatusType#status_mount{figure_list = NewFigureList},
                            NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
                            NewPlayer = Player#player_status{status_mount = NewStatusMount},
                            NewPlayer1 = check_figure_time(NewPlayer),
                            NewPlayer1;
                        _ -> %% 已永久激活，不再更新形象的过期时间
                            Player
                    end;
                false -> Player
            end;
        false -> Player
    end.

%% 清除figure中 形象id 为 0
clear_figure_id_api(Player, TypeId) ->
    FigureId = 0,
    #player_status{id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    #figure{mount_figure = MountFigure} = Figure,
    NewStatusMount =
        case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
            false ->
                StatusMount;
            StatusType ->
                db:execute(io_lib:format(?sql_update_mount_fashion_figure, [1, RoleId, TypeId])),
                lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, StatusType#status_mount{figure_id = FigureId})
        end,
    NewMountFigure = lists:keystore(TypeId, 1, MountFigure, {TypeId, FigureId, 0}),
    NewFigure = Figure#figure{mount_figure = NewMountFigure},
    NewPlayer = Player#player_status{status_mount = NewStatusMount, figure = NewFigure},
    %% 通知场景玩家
    LastPlayer = broadcast_to_scene(TypeId, NewPlayer),
    LastPlayer.

%% 卸下时装
unequip_fashion_api(Player, TypeId) ->
    #player_status{id = RoleId, status_mount = StatusMount, figure = Figure} = Player,
    #figure{mount_figure = MountFigure} = Figure,
    NewStatusMount =
        case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
            false ->
                FigureId = 0,
                Color = 0,
                StatusMount;
            StatusType ->
                #status_mount{illusion_type = IllusionType, illusion_id = IllusionId, illusion_color = IllusionColor} = StatusType,
                FigureId = get_figure_id(TypeId, IllusionType, IllusionId, Figure#figure.career),
                Color = ?IF(IllusionType == ?ILLUSION_MOUNT_FIGURE, IllusionColor, 0),
                db:execute(io_lib:format(?sql_update_mount_fashion_figure, [0, RoleId, TypeId])),
                lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, StatusType#status_mount{figure_id = FigureId})
        end,
    NewMountFigure = lists:keystore(TypeId, 1, MountFigure, {TypeId, FigureId, Color}),
    NewFigure = Figure#figure{mount_figure = NewMountFigure},
    NewPlayer = Player#player_status{status_mount = NewStatusMount, figure = NewFigure},
    db:execute(io_lib:format(?sql_update_mount_fashion_figure, [1, RoleId, TypeId])),
    %% 通知场景玩家
    LastPlayer = broadcast_to_scene(TypeId, NewPlayer),
    LastPlayer.


unequip_fashion(#player_status{id = RoleId} = Player, TypeId) ->
    case TypeId == ?HOLYORGAN_ID of
        true ->
            NewPlayer = lib_fashion:unequip_fashion_weapon(Player),
            db:execute(io_lib:format(?sql_update_mount_fashion_figure, [0, RoleId, TypeId])),
            NewPlayer;
        false ->
            Player
    end.

%%卸下翅膀
cancel_wing(Player) ->
    #player_status{
        id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BattleAttr,
        figure = Figure, status_mount = StatusMount} = Player,
    NewStatusMount = 
    case lists:keyfind(?FLY_ID, #status_mount.type_id, StatusMount) of 
        false -> StatusMount;
        FlyStatusMount -> 
            lists:keystore(?FLY_ID, #status_mount.type_id, StatusMount, FlyStatusMount#status_mount{is_ride = 0})
    end,
    #figure{mount_figure_ride = MountFigureRide, mount_figure = MountFigure} = Figure,
    NewMountFigureRide = lists:keystore(?FLY_ID, 1, MountFigureRide, {?FLY_ID, ?NOT_RIDE_STATUS}),
    NewFigure = Figure#figure{mount_figure_ride = NewMountFigureRide},
    NewPlayer = Player#player_status{figure = NewFigure, status_mount = NewStatusMount},
    case lists:keyfind(?FLY_ID, 1, MountFigure) of
        false -> FigureId = 0;
        {_, FigureId, _} -> skip
    end,
    %% 通知场景玩家
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    {ok, BinData} = pt_160:write(16001, [?FLY_ID, RoleId, ?NOT_RIDE_STATUS, FigureId, BattleAttr#battle_attr.speed]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
    mod_scene_agent:update(NewPlayer, [{mount_figure_ride, {?FLY_ID, ?NOT_RIDE_STATUS}}]),
    {ok, NewPlayer}.


%% 判断是否可以激活外形的接口
%% {false, Res}: Res 1 配置错误 2 外形没开放 3 形象已激活
can_active_figure(PS, TypeId, Id) ->
    #player_status{status_mount = StatusMount} = PS,
    % 是否有外观种类
    case lists:member(TypeId, ?APPERENCE) of
        true ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            % 是否有外观配置
            case StatusType =/= false of
                true ->
                    case lists:member(Id, data_mount:get_all_figure_id(TypeId)) of
                        true ->
                            #status_mount{figure_list = FigureList} = StatusType,
                            case lists:keyfind(Id, #mount_figure.id, FigureList) of
                                #mount_figure{end_time = EndTime} when EndTime == 0 -> %% 已永久激活,不需要再激活
                                    {false, 3};
                                _ -> true
                            end;
                        false -> {false, 1}
                    end;
                false -> {false, 2}
            end;
        false -> {false, 1}
    end.


%% 检测外形清理
check_figure_time(PS) ->
    #player_status{pid = RolePid, status_mount = StatusMount, mount_ref = OldRef} = PS,
    Fun =
        fun(TypeId, TimeTmp) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
            case StatusType =/= false of
                true ->
                    #status_mount{figure_list = FigureList} = StatusType,
                    Now = utime:unixtime(),
                    LimitTime = [{TypeId, Id, ETime - Now} || #mount_figure{id = Id, end_time = ETime} <- FigureList, ETime > Now],
                    LimitTime ++ TimeTmp;
                false ->
                    TimeTmp
            end
        end,
    LimitTime0 = lists:foldl(Fun, [], ?APPERENCE),
    LimitTime1 = lists:keysort(3, LimitTime0),
    case LimitTime1 of
        [] -> % 没有超时不处理
            util:cancel_timer(OldRef),
            Ref = none;
        [{TypeTmp, IdTmp, CTime} | _] ->
            case CTime > 0 of
                true ->
                    Ref = util:send_after(OldRef, CTime * 1000, RolePid, {'role_check_figure_time', TypeTmp, IdTmp});
                false ->
                    util:cancel_timer(OldRef),
                    Ref = none
            end
    end,
    PS#player_status{mount_ref = Ref}.


clear_figure(PS, TypeId, Id) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_mount = StatusMount} = PS,
    #figure{career = Career, mount_figure = MountFigure} = Figure,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    % 是否有外观配置
    case StatusType =/= false of
        true ->
            #status_mount{
                stage = Stage, figure_id = FigureId, 
                illusion_type = IllusionType, illusion_id = IllusionId, 
                illusion_color = IllusionColor, figure_list = FigureList} = StatusType,
            NewFigureList = lists:keydelete(Id, #mount_figure.id, FigureList),
            db:execute(io_lib:format(?sql_delete_mount_illusion_info, [RoleId, TypeId, Id])),
            case IllusionType == ?ILLUSION_MOUNT_FIGURE andalso IllusionId == Id of
                true ->
                    NewIllusionType = ?BASE_MOUNT_FIGURE,
                    NewFigureId = get_figure_id(TypeId, ?BASE_MOUNT_FIGURE, Stage, Career);
                false ->
                    NewIllusionType = IllusionType,
                    NewFigureId = FigureId
            end,
            NewMountFigure = lists:keyreplace(TypeId, 1, MountFigure, {TypeId, NewFigureId, IllusionColor}), %更新figure
            NewStatusType = refresh_illusion_data(StatusType#status_mount{figure_id = NewFigureId, illusion_type = NewIllusionType, figure_list = NewFigureList}),
            NewStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, NewStatusType),
            NewPlayer = PS#player_status{figure = Figure#figure{mount_figure = NewMountFigure}, status_mount = NewStatusMount, mount_ref = none},
            NewPlayer1 = count_mount_attr(NewPlayer),
            LastPlayer = broadcast_to_scene(TypeId, NewPlayer1), % 坐骑信息变化通知场景玩家 并 角色属性计算
            %%          告知客户端形象已被删除成功
            lib_server_send:send_to_sid(Sid, pt_160, 16012, [TypeId, Id]), % 推送外形信息
            check_figure_time(LastPlayer);
        false -> PS
    end.

get_illusion_name(TypeId, Id, Career) ->
    case data_mount:get_figure_cfg(TypeId, Id, Career) of
        #mount_figure_cfg{name = Name} -> Name;
        _ -> <<>>
    end.


get_passive_skill_attr(SkillList) ->
    F = fun({SkillId, SkillLv}, Result) ->
        case data_skill:get(SkillId, SkillLv) of
            [] -> Result;
            #skill{type = _Type, lv_data = LvData} ->
                BaseAttr = [{AttrId, AttrVal} || {TmpMonId, AttrId, AttrVal} <- LvData#skill_lv.base_attr, TmpMonId == 0],
                BaseAttr ++ Result;
            _ ->
                Result
        end
        end,
    lists:foldl(F, [], SkillList).


count_skill_attr_with_mod_id(_Key, SkillList) ->
    F = fun(SkillId, AccList) ->
        case data_skill:get(SkillId, 1) of
            [] -> AccList;
            #skill{type = Type, lv_data = LvData} when
                Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_PERMANENT_GAIN;
                Type == ?SKILL_TYPE_TALENT_ATT; Type == ?SKILL_TYPE_TALENT_DEF;
                Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS;
                Type == ?SKILL_CAREER_SECRET ->
                Attr = LvData#skill_lv.base_attr,
                BaseAttr = [{AttrId, AttrVal} || {_TmpKey, AttrId, AttrVal} <- Attr],
                BaseAttr ++ AccList;
            _ -> AccList
        end
        end,
    lists:foldl(F, [], SkillList).


get_mount_name(?MOUNT_ID) -> utext:get(1600001); %%"坐骑";
get_mount_name(?MATE_ID) -> utext:get(1600002); %%"伙伴";
get_mount_name(?FLY_ID) -> utext:get(1600003); %%"翅膀";
get_mount_name(?ARTIFACT_ID) -> utext:get(1600004); %%"圣器";
get_mount_name(?HOLYORGAN_ID) -> utext:get(1600005); %%"神兵";
get_mount_name(?PET_ID) -> utext:get(1600006); %%"飞骑";
get_mount_name(?ZHENFA_ID) -> utext:get(1600007); %%"法阵";
get_mount_name(?NEW_BACK_DECORATION) -> utext:get(1600012); %%"背饰";
get_mount_name(_) -> "".

check_upgrade_figure_color(FigureList, TypeId, Id, ColorId) ->
    FigureInfo = lists:keyfind(Id, #mount_figure.id, FigureList),
    ColorCfgList = data_mount:get_all_color_id(TypeId, Id),
    IsMember = lists:member(ColorId, ColorCfgList),
    if
        ColorId == 0 -> {fail, ?ERRCODE(err160_figure_color_cfg_missing)};
        IsMember == false -> {fail, ?ERRCODE(err160_figure_color_cfg_missing)};
        is_record(FigureInfo, mount_figure) == false -> {fail, ?ERRCODE(err160_3_figure_inactive)};
        true ->
            #mount_figure{color_list = ColorList} = FigureInfo,
            {_, ColorLv} = ulists:keyfind(ColorId, 1, ColorList, {ColorId, 0}),
            MaxLevel = data_mount:get_max_color_level(TypeId, Id, ColorId),
            ColorInfo = data_mount:get_type_figure_color_info(TypeId, Id, ColorId, ColorLv+1),
            if
                ColorLv >= MaxLevel -> {fail, ?ERRCODE(err160_figure_color_level_max)};
                is_record(ColorInfo, base_mount_color_up) == false -> {fail, ?ERRCODE(err160_figure_color_cfg_missing)};
                true -> {ok, ColorLv, ColorInfo, FigureInfo}
            end
    end.

color_level_up(Player, TypeId, Id, ColorId, StatusType) ->
    #player_status{sid = Sid, id = RoleId, status_mount = StatusMount,original_attr = OriginAttr} = Player,
    #status_mount{figure_list = FigureList} = StatusType,
    case check_upgrade_figure_color(FigureList, TypeId, Id, ColorId) of
        {ok, ColorLv, ColorInfo, FigureInfo} ->
            #base_mount_color_up{color_lv = NewColorLv, cost = Cost} = ColorInfo,
            case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_figure_color, "") of
                {true, NewPlayer} ->
                    #mount_figure{star = Star, stage = Stage, color_list = ColorList} = FigureInfo,
                    NewColorList = lists:keystore(ColorId, 1, ColorList, {ColorId, NewColorLv}),
                    %% 日志
                    ?PRINT("============ Id:~p~n",[Id]),
                    lib_log_api:log_mount_figure_upgrade_color(RoleId, TypeId, Id, ColorId, ColorLv, NewColorLv, Cost),
                    {_, FAttr, _SkillIds, FCombat} = count_figure_attr_origin_combat(TypeId, Id, Stage, Star, ColorList, OriginAttr),
                    NewFigureInfo = FigureInfo#mount_figure{
                        attr = FAttr, combat = FCombat, 
                        color_list = NewColorList
                    },
                    % ?PRINT("RoleId, TypeId, Id, ColorId, NewColorLv:~p~n",[[RoleId, TypeId, Id, ColorId, NewColorLv]]),
                    db:execute(io_lib:format(?sql_player_mount_color_replace, [RoleId, TypeId, Id, ColorId, NewColorLv])),
                    NewFigureList = lists:keystore(Id, #mount_figure.id, FigureList, NewFigureInfo),
                    NewStatusType = StatusType#status_mount{figure_list = NewFigureList},
                    LastStatusType = refresh_illusion_data(NewStatusType),
                    LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, LastStatusType),
                    NewPlayerTmp1 = count_mount_attr(NewPlayer#player_status{status_mount = LastStatusMount}),
                    NewPlayer1 = broadcast_to_scene(TypeId, NewPlayerTmp1),
                    lib_server_send:send_to_sid(Sid, pt_160, 16026, [TypeId, Id, ColorId, ?SUCCESS]),
                    % ?PRINT("Id:~p, NewColorList :~p~n",[Id, NewColorList]),
                    NewPlayer2 = lib_mount_api:power_change_event(NewPlayer1, TypeId),
                    LastPlayer = lib_mount_api:figure_color_lv_up(NewPlayer2, ColorId, NewColorLv);
                {false, ErrorCode, NewPlayer} ->
                    LastPlayer = NewPlayer,
                    lib_server_send:send_to_sid(Sid, pt_160, 16000, [ErrorCode])
            end;
        {_, ErrCode} ->
            LastPlayer = Player,
            lib_server_send:send_to_sid(Sid, pt_160, 16000, [ErrCode])
    end,
    {ok, LastPlayer}.

%% 幻型升级
figure_upgrade_star(Player, TypeId, Id, StatusType) ->
    #player_status{sid = Sid, id = RoleId, status_mount = StatusMount,original_attr = OriginAttr} = Player,
    #status_mount{figure_list = FigureList} = StatusType,
    case lists:keyfind(Id, #mount_figure.id, FigureList) of
        #mount_figure{star = Star, stage = Stage, blessing = Blessing, end_time = EndTime, color_list = ColorList} = FigureInfo -> % 已经激活幻型
            NewStar = Star + 1,
            case data_mount:get_mount_figure_star(TypeId, Id, NewStar) of
                #mount_figure_star_cfg{} ->
                    #mount_figure_star_cfg{cost = Cost} = data_mount:get_mount_figure_star(TypeId, Id, Star),
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, mount_figure_star, "") of
                        {true, NewPlayer} ->
                            %% 日志
                            lib_log_api:log_mount_figure_upgrade_star(RoleId, TypeId, Id, Star, NewStar, Cost),
                            {FStarAttr, FAttr, _SkillIds, FCombat} = count_figure_attr_origin_combat(TypeId, Id, Stage, NewStar, ColorList, OriginAttr),
                            NewFigureInfo = FigureInfo#mount_figure{star = NewStar, star_attr = FStarAttr, attr = FAttr, combat = FCombat},
                            NewFigureList = lists:keystore(Id, #mount_figure.id, FigureList, NewFigureInfo),
                            NewStatusType = StatusType#status_mount{figure_list = NewFigureList},
                            db:execute(io_lib:format(?sql_update_mount_illusion_info, [RoleId, TypeId, Id, Stage, NewStar, Blessing, EndTime])),
                            LastStatusType = refresh_illusion_data(NewStatusType),
                            LastStatusMount = lists:keyreplace(TypeId, #status_mount.type_id, StatusMount, LastStatusType),
                            NewPlayers = NewPlayer#player_status{status_mount = LastStatusMount},
                            %% 更新时装套装属性
                            lib_fashion_suit:event_update_attr(NewPlayers),
                            NewPlayerTmp1 = count_mount_attr(NewPlayers),
                            NewPlayer1 = broadcast_to_scene(TypeId, NewPlayerTmp1),
                            NewPlayer2 = lib_mount_api:power_change_event(NewPlayer1, TypeId),
                            NewPlayer3 = lib_mount_api:figure_stage_star_change(NewPlayer2, NewFigureList, TypeId, Id, Stage, NewStar),
                            {ok, LastPlayer} = pp_mount:handle(16002, NewPlayer3, [TypeId]),
                            lib_common_rank_api:refresh_rank_by_upgrade(LastPlayer, TypeId),
                            %% 升阶升战活动
                            %lib_train_act:mount_train_stage_up(LastPlayer, TypeId),
                            % lib_train_act:mount_train_power_up(LastPlayer, TypeId),
                            {ok, BinData} = pt_160:write(16020, [?SUCCESS, TypeId, Id, NewStar]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        {false, ErrorCode, NewPlayer} ->
                            LastPlayer = NewPlayer,
                            lib_server_send:send_to_sid(Sid, pt_160, 16000, [ErrorCode])
                    end;
                _ -> % 没有配置 或者 已达最高等级
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_160, 16000, [?ERRCODE(err160_10_exp_max)])
            end;
        false -> % 没有激活幻型
            LastPlayer = Player,
            lib_server_send:send_to_sid(Sid, pt_160, 16000, [?ERRCODE(err160_3_figure_inactive)])
    end,
    if
        TypeId == ?PET_ID ->
            lib_rush_rank_api:reflash_rank_by_aircraft_rush(LastPlayer);
        true ->
            ok
    end,
    {ok, battle_attr, LastPlayer}.


%% 计算幻型属性，战力，技能
count_figure_attr_combat_sk(TypeId, Id, Stage, Star, ColorList) ->
    FStageAttr =
        case data_mount:get_figure_stage_cfg(TypeId, Id, Stage) of
            #mount_figure_stage_cfg{attr = Attr} -> Attr;
            _ -> []
        end,
    FStarAttr =
        case data_mount:get_mount_figure_star(TypeId, Id, Star) of
            #mount_figure_star_cfg{attr = Attr1} -> Attr1;
            _ -> []
        end,
    AllColorAttrList =
        [begin
            case data_mount:get_type_figure_color_info(TypeId, Id, ColorId, ColorLv) of
                #base_mount_color_up{attr = Attr2, sp_attr = SpecialAttr} -> SpecialAttr ++ Attr2;
                _ -> []
            end
         end ||{ColorId, ColorLv} <- ColorList],
    FColorAttr = lib_player_attr:add_attr(list, AllColorAttrList),
    %% 注意这里没问题的，幻化是阶数解锁技能
    {TmpSkillAttr, TmpSkillIds} = get_mount_skill(TypeId, ?MOUNT_ILLUSION_SKILL, Id, Stage, Stage),
    %% 转换技能加成属性的局部属性
    TmpFAttr = lib_player_attr:partial_attr_convert(FColorAttr ++ TmpSkillAttr ++ FStageAttr ++ FStarAttr),
    {FStarAttr, TmpFAttr, TmpSkillIds}.


%% 计算幻型属性，战力，技能
count_figure_attr_origin_combat(TypeId, Id, Stage, Star, ColorList, OriginAttr) ->
    FStageAttr =
        case data_mount:get_figure_stage_cfg(TypeId, Id, Stage) of
            #mount_figure_stage_cfg{attr = Attr} -> Attr;
            _ -> []
        end,
    FStarAttr =
        case data_mount:get_mount_figure_star(TypeId, Id, Star) of
            #mount_figure_star_cfg{attr = Attr1} -> Attr1;
            _ -> []
        end,
    AllColorAttrList =
        [begin
            case data_mount:get_type_figure_color_info(TypeId, Id, ColorId, ColorLv) of
                #base_mount_color_up{attr = Attr2, sp_attr = SpecialAttr} -> SpecialAttr ++ Attr2;
                _ -> []
            end
         end ||{ColorId, ColorLv} <- ColorList],
    FColorAttr = lib_player_attr:add_attr(list, AllColorAttrList),
        
    {TmpSkillAttr, TmpSkillIds} = get_mount_skill(TypeId, ?MOUNT_ILLUSION_SKILL, Id, Stage, Stage),
    %% 转换技能加成属性的局部属性
    TmpFAttr = lib_player_attr:partial_attr_convert(FColorAttr ++ TmpSkillAttr ++ FStageAttr ++ FStarAttr),
    Fun3 =
        fun(SkillByModTmp, SkillPowerTmp) ->
            lib_skill_api:get_skill_power(SkillByModTmp, 1) + SkillPowerTmp
        end,
    TypeSkillPower = lists:foldl(Fun3, 0, TmpSkillIds),
    TmpFCombat = lib_player:calc_partial_power(OriginAttr, TypeSkillPower, TmpFAttr),
    {FStarAttr, TmpFAttr, TmpSkillIds, TmpFCombat}.



%% 获取坐骑培养物的 阶数和星数
get_train_stage_star(TypeId, Player) when
    TypeId == ?MOUNT_ID; TypeId == ?MATE_ID;
    TypeId == ?FLY_ID; TypeId == ?NEW_BACK_DECORATION ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            {StatusType#status_mount.stage, StatusType#status_mount.star};
        false ->
            {0, 0}
    end;
get_train_stage_star(TypeId, Player) when TypeId == ?PET_ID ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_list = FigureList} = StatusType,
            StageList = [Stage || #mount_figure{stage = Stage} <- FigureList],
            StageSum = lists:sum([0|StageList]),
            {StageSum, 0};
        false ->
            {0, 0}
    end;
get_train_stage_star(_TypeId, _Player) ->
    {0, 0}.


%% 获取坐骑培养物的 战力
get_train_combat(TypeId, Player) when TypeId == ?MOUNT_ID; TypeId == ?MATE_ID; TypeId == ?FLY_ID; TypeId == ?NEW_BACK_DECORATION ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            StatusType#status_mount.combat;
        false ->
            0
    end;
get_train_combat(TypeId, Player) when TypeId == ?PET_ID ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_list = FigureList} = StatusType,
            PowerList = [Power || #mount_figure{combat = Power} <- FigureList],
            PowerSum = lists:sum([0|PowerList]),
            PowerSum;
        false ->
            0
    end;
get_train_combat(_TypeId, _Player) ->
    0.


%% 获取外形数量
get_figure_count(Player, TypeId) ->
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_list = FigureList} = StatusType,
            length(FigureList);
        false ->
            0
    end.



%% 外形坐骑类的总属性和总战力
get_power_by_type_id(PS, TypeId) ->
    #player_status{status_mount = StatusMount, original_attr = OriginAttr} = PS,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{attr = AttrType, skills = Skills, figure_skills = FigureSkill, upgrade_sys_skill = USkill} = StatusType,
            AttrSum = util:combine_list(AttrType),
            Fun1 = fun(SkillId, PowerTmp) ->
                lib_skill_api:get_skill_power(SkillId, 1) + PowerTmp
                   end,
            StarCombat = lib_player:calc_partial_power(OriginAttr, 0, AttrSum),
            NewPower = lists:foldl(Fun1, 0, Skills ++ FigureSkill ++ USkill),
            StarCombat + NewPower;
        false ->
            0
    end.



%% 外形坐骑类的的总阶数
get_all_lv_by_type_id(PS, TypeId) ->
    #player_status{status_mount = StatusMount} = PS,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount),
    case StatusType =/= false of
        true ->
            #status_mount{figure_list = FigureList} = StatusType,
            F = fun(#mount_figure{stage = Stage}, AccStage) ->
                AccStage + Stage
                end,
            lists:foldl(F, 0, FigureList);
        false ->
            0
    end.

% 判断当前是否翅膀幻化，是的话取消背饰幻化并提前广播一下
% 这个是针对类型为9的背饰系统，12的背饰系统不受这里的影响
judgeillusion(Player, TypeId) ->
    case TypeId of
        ?FLY_ID ->
            NewPlayer = lib_back_decoration_api:cancel_back_decoration_illusion(Player);
        _ -> NewPlayer = Player
    end,
%%    lib_temple_awaken_api:cancel_chapter_illusion(NewPlayer, TypeId).
    {ok, NewPlayer}.

%判断当前是否激活翅膀， 是的话取消背饰并且提前广播
% 这个是针对类型为9的背饰系统，12的背饰系统不受这里的影响
judgeactive(Player, TypeId) ->
    case TypeId of
        ?FLY_ID ->
            NewPlayer = lib_back_decoration_api:cancel_back_decoration_illusion(Player);
        _ -> NewPlayer = Player
    end,
    lib_temple_awaken_api:cancel_chapter_illusion(NewPlayer, TypeId).
%%    {ok, NewPlayer}.

%=======================升星坐骑或者伙伴（特殊处理私有函数）====================

%%一个物品产生的经验值
produce_bless(TypeId, GoodsId) ->
    #mount_prop_cfg{exp = Exp, ratio = Ratio} = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
    ExpPlus = urand:rand_with_weight(Ratio), % 暴击倍率
    ExpPlus * Exp.

%% 升星升阶
%% 处理溢出的经验能再升一级的情况
get_new_status(TypeId, OverFlowExp, Stage, Star, Career) ->
    #mount_stage_cfg{max_star = MaxStar} = data_mount:get_stage_cfg(TypeId, Stage, Career),
    case MaxStar == Star of 
        false -> 
            addStar(OverFlowExp,TypeId, Stage, Star, Career);
        true ->
            addStage(OverFlowExp,TypeId, Stage, Star, Career)
    end.

addStar(OverFlowExp, TypeId, Stage, Star, Career) ->
    NewStar = Star + 1,
    #mount_star_cfg{max_blessing = MaxBlessing} = data_mount:get_star_cfg(TypeId, Stage, NewStar),
    if
        MaxBlessing > OverFlowExp ->
            case check_max_state(TypeId, Stage, NewStar) of
                true -> {Stage, NewStar, 0}; % 满级，溢出的经验直接弄成0
                false -> {Stage, NewStar, OverFlowExp}
            end;
        true -> 
            #mount_stage_cfg{max_star = MaxStar} = data_mount:get_stage_cfg(TypeId, Stage, Career),
            case MaxStar == NewStar of 
                false -> addStar(OverFlowExp - MaxBlessing, TypeId, Stage, NewStar, Career);
                _ -> addStage(OverFlowExp - MaxBlessing, TypeId, Stage, NewStar, Career)
            end
    end.

addStage(OverFlowExp, TypeId, Stage, _Star, Career) ->
    NewStage = Stage + 1,
    NewStar = ?MIN_STAR,
    #mount_star_cfg{max_blessing = MaxBlessing} = data_mount:get_star_cfg(TypeId, NewStage, NewStar),
    if
        MaxBlessing > OverFlowExp -> {NewStage, NewStar, OverFlowExp};
        true -> 
            #mount_stage_cfg{max_star = MaxStar} = data_mount:get_stage_cfg(TypeId, NewStage, Career),
            case MaxStar == NewStar + 1 of 
                false -> addStar(OverFlowExp - MaxBlessing, TypeId, Stage, NewStar, Career);
                _ -> addStage(OverFlowExp - MaxBlessing, TypeId, Stage, NewStar, Career)
            end
    end.

%% 判断当前等级阶数是否最大
check_max_state(TypeId, Stage, NewStar) ->
    case data_mount:get_star_cfg(TypeId, Stage, NewStar + 1) of
        [] ->
            case data_mount:get_star_cfg(TypeId, Stage + 1, ?MIN_STAR) of
                [] -> true;
                _ -> false
            end;
        _ -> false
    end.

%% 获取自动购买物品的id
%% 需要最低经验值的物品
get_auto_buy_goodsId([], _TypeId, _MinExp, MinExpGoodsId) -> MinExpGoodsId;
get_auto_buy_goodsId([GoodsId|OtherGoodsId], TypeId, MinExp, MinExpGoodsId) ->
    #mount_prop_cfg{exp = Exp} = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
    case Exp =< MinExp of
        true -> get_auto_buy_goodsId(OtherGoodsId, TypeId, Exp, GoodsId);
        false -> get_auto_buy_goodsId(OtherGoodsId, TypeId, MinExp, MinExpGoodsId)
    end.

%% 防止消耗物品出错
%% 有些情况下Cost：[{Type, GoodsIs, 0}] ，要去除这种情况
before_cost(Cost) -> 
    F = fun({_, _, GoodsNum}) -> GoodsNum =/= 0 end,
    lists:filter(F, Cost).

%% 消耗一个物品增加经验 速度太慢暂时弃用
%% 优先消耗物品，当物品消耗完毕时，判断是否允许自动购买
%% 自动购买情况下，当绑钻不足，判断是否允许消耗钻石，在进行消耗
%% @param Player
%% @param AllGoods 所有能消耗的物品
%% @param AutoBuy 是否自动购买 1自动购买 0不自动购买
%% @param GoldType 是否允许消耗钻石 0只消耗绑钻 1允许消耗钻石
%% @return {消耗（物品或钻石）, 增加的经验}/{false, ErrorCode}
cost_one_goods(_Player, [], _TypeId, ?NOAUTOBUY, _GoldType) ->
    {false, ?ERRCODE(err160_not_enough_cost)};
cost_one_goods(Player, [], TypeId, _, GoldType) ->
    #player_status{gold = Gold, bgold = BGold} = Player,
    AllGoodsId = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_NORMAL),
    AutoBuyGoodsId = get_auto_buy_goodsId(AllGoodsId,TypeId, ?MAX_GOODS_EXP, 0),
    Exp = produce_bless(TypeId, AutoBuyGoodsId),
    #quick_buy_price{
        gold_price = GoldPrice,
        bgold_price = BGoldPrice
    } = data_quick_buy:get_quick_buy_price(AutoBuyGoodsId),
    if
        BGoldPrice > BGold -> %绑钻不够了
            case GoldType == 0 of 
                true -> %返回告诉绑钻不够了
                    {false, ?ERRCODE(err160_bgold_zero)};
                _ -> %消耗钻石
                    if 
                        GoldPrice > Gold -> %%钻石又不够
                            {false, ?ERRCODE(err160_gold_zero)}; %钻石不够
                        true -> {[{?TYPE_GOLD, ?GOODS_ID_GOLD, GoldPrice}], Exp}
                    end
            end;
        true -> {[{?TYPE_BGOLD, ?GOODS_ID_BGOLD, BGoldPrice}], Exp}
    end;
cost_one_goods(Player, [{GoodsId, GoodsNum}|OtherGoods], TypeId, _AutoBuy, _GoldType) ->
    case GoodsNum == 0 of 
        true -> cost_one_goods(Player, [OtherGoods], TypeId, _AutoBuy, _GoldType);
        false -> 
            Exp = produce_bless(TypeId, GoodsId),
            {[{?TYPE_GOODS, GoodsId, 1}], Exp}
    end.

%% 增加百分比经验所消耗的材料
%% 消耗物品，当物品消耗完毕时终止
%% 自动购买情况下，当绑钻不足，判断是否允许消耗钻石，在进行消耗
%% @param Player
%% @param Blessing 当前祝福值
%% @param MaxBlessing 最大祝福值
%% @param AllGoods 所有能消耗的物品
%% @param AutoBuy 是否自动购买 1自动购买 0不自动购买
%% @param GoldType 是否允许消耗钻石 0只消耗绑钻 1允许消耗钻石
%% @return {消耗（物品或钻石）, 增加的经验}/{false, ErrorCode}
cost_precent(Player, Blessing, MaxBlessing, AllGoods, TypeId, AutoBuy, GoldType) ->
    SurplusBlessing = MaxBlessing - Blessing,
    AddExp = util:ceil(MaxBlessing * ?UPGRADE_PRECENT),
    if
        SurplusBlessing < AddExp -> %剩下的经验不够配置的百分比，直接扣完这个
            cost_precent_do(Player, SurplusBlessing, AllGoods, TypeId, AutoBuy, GoldType);
        true -> %大于配置的百分比
            cost_precent_do(Player, AddExp, AllGoods, TypeId, AutoBuy, GoldType)
    end.

cost_precent_do(_Player, _, [], _TypeId, ?NOAUTOBUY, _GoldType) ->
    {false, ?ERRCODE(err160_not_enough_cost)};
cost_precent_do(Player, NeedExp, [], TypeId, _AutoBuy, GoldType) ->
    #player_status{gold = Gold, bgold = BGold} = Player,
    AllGoodsId = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_NORMAL),
    AutoBuyGoodsId = get_auto_buy_goodsId(AllGoodsId,TypeId, ?MAX_GOODS_EXP, 0),
    PerExp = produce_bless(TypeId, AutoBuyGoodsId),
    Num = calcu_num(NeedExp, PerExp),
    #quick_buy_price{
        gold_price = GoldPrice,
        bgold_price = BGoldPrice
    } = data_quick_buy:get_quick_buy_price(AutoBuyGoodsId),
    if
        (Num * BGoldPrice) > BGold -> %绑钻不够了
            case GoldType == 0 of
                true -> %返回告诉绑钻不够了
                    case BGold < BGoldPrice of
                        true -> {false, ?ERRCODE(err160_bgold_zero)};
                        false ->
                            BGNum = BGold div BGoldPrice,
                            {[{?TYPE_BGOLD, ?GOODS_ID_BGOLD, BGoldPrice * BGNum}], BGNum * PerExp}
                    end ;
                _ -> %消耗钻石
                    BGNum = BGold div BGoldPrice,
                    GNum = Num - BGNum,
                    if
                        (GNum * GoldPrice) > Gold -> %%钻石又不够
                            case Gold < GoldPrice of
                                true -> {false, ?ERRCODE(err160_gold_zero)}; %钻石不够
                                false ->
                                    GNum0 = Gold div GoldPrice,
                                    {[{?TYPE_BGOLD, ?GOODS_ID_BGOLD, BGoldPrice * BGNum}, {?TYPE_GOLD, ?GOODS_ID_GOLD, GoldPrice * GNum0}], (BGNum + GNum0) * PerExp}
                            end ;
                        true -> {[{?TYPE_BGOLD, ?GOODS_ID_BGOLD, BGoldPrice * BGNum}, {?TYPE_GOLD, ?GOODS_ID_GOLD, GoldPrice * GNum}], PerExp * Num}
                    end
            end;
        true -> {[{?TYPE_BGOLD, ?GOODS_ID_BGOLD, BGoldPrice * Num}], PerExp * Num}
    end;
cost_precent_do(_Player, NeedExp, AllGoods, TypeId, _AutoBuy, _GoldType) ->
    calcu_goods_cost(NeedExp, AllGoods, TypeId, [], 0).

calcu_goods_cost(_NeedExp, [], _TypeId, Cost, Exp) -> {Cost, Exp};
calcu_goods_cost(NeedExp, [{GoodsId, GoodsNum}|OtherGoods], TypeId, Cost, Exp) ->
    PerExp = produce_bless(TypeId, GoodsId),
    Num = calcu_num(NeedExp, PerExp),
    if
        GoodsNum > Num ->
            {[{?TYPE_GOODS, GoodsId, Num}] ++ Cost, Num * PerExp + Exp};
        true ->
            Cost1 = [{?TYPE_GOODS, GoodsId, GoodsNum}],
            Exp1 = GoodsNum * PerExp,
            calcu_goods_cost(NeedExp - GoodsNum * PerExp, OtherGoods, TypeId, Cost1++Cost, Exp1 + Exp)
    end.

%% 计算达到指定经验需要的数量
calcu_num(NeedExp, PerExp) ->
    case PerExp >= NeedExp of
        true -> 1;
        false ->
            if
                NeedExp rem PerExp ==0 ->
                    NeedExp div PerExp;
                true ->
                    NeedExp div PerExp + 1
            end
    end.

%========================================================================

%% 刷新坐骑形象列表
refresh_mount_figure_list(PS) ->
    #player_status{figure = Figure, status_mount = StatusMount} = PS,
    #figure{career = Career} = Figure,
    F = fun(StatusType, {List, List2}) ->
        #status_mount{type_id = TypeId, illusion_color = IllusionColor, illusion_type = IllusionType, illusion_id = IllusionId, figure_id = FigureId} = StatusType,
        case FigureId > 0 of 
            true ->
                NewFigureId = get_figure_id(TypeId, IllusionType, IllusionId, Career),
                {[{TypeId, NewFigureId, IllusionColor}|List], [StatusType#status_mount{figure_id = NewFigureId}|List2]};
            _ -> {List, [StatusType|List2]}
        end
    end,
    {NewMountFigure, NewStatusMount} = lists:foldl(F, {[], []}, StatusMount),
    PS#player_status{status_mount = NewStatusMount, figure = Figure#figure{mount_figure = NewMountFigure}}.

%% 计算局部属性对星级属性、等阶属性、魔晶属性的8个基础属性的加成，并汇总
calc_real_magic_all_attr(NeedHandleBaseAttr, MagicAllAttr) ->
    SpecialAttrKeyList = [
        ?PARTIAL_ATT_ADD_RATIO,
        ?PARTIAL_HP_ADD_RATIO,
        ?PARTIAL_WRECK_ADD_RATIO,
        ?PARTIAL_DEF_ADD_RATIO,
        ?PARTIAL_HIT_ADD_RATIO,
        ?PARTIAL_DODGE_ADD_RATIO,
        ?PARTIAL_CRIT_ADD_RATIO,
        ?PARTIAL_TEN_ADD_RATIO
    ],
    %% 局部全属性加成转换为8个局部属性加成 策划说不要 局部元素攻击/防御
    CombineList = case lists:keyfind(?PARTIAL_WHOLE_ADD_RATIO, 1, MagicAllAttr) of
                      {?PARTIAL_WHOLE_ADD_RATIO, WholeAddRatio} when WholeAddRatio > 0 ->
                          % WholeAdd = [{AttrId + ?PARTIAL2GLOBAL_INTERVAL, WholeAddRatio} || AttrId <- ?BASE_ATTR_LIST],
                          WholeAdd = [{AttrId, WholeAddRatio} || AttrId <- SpecialAttrKeyList],
                          AttrList2 = lists:keydelete(?PARTIAL_WHOLE_ADD_RATIO, 1, MagicAllAttr),
                          util:combine_list(WholeAdd ++ AttrList2);
                      _ -> MagicAllAttr
                  end,

    %% 筛选出全局的属性 
    GlobalAttrList = lists:filter(fun({TmpKey, _TmpVal}) ->
                                          lists:member(TmpKey, ?PARTIAL_TYPE) == false
                                  end, CombineList),

    lists:foldl(
        fun({TmpKey, TmpVal}, AccList) ->
            case ?PARTIAL2GLOBAL(TmpKey) of
                TmpCKey when is_integer(TmpCKey) ->
                    case lists:keyfind(TmpCKey, 1, AccList) of
                        {TmpCKey, AttrVal} ->
                            case lists:keyfind(TmpCKey, 1, NeedHandleBaseAttr) of
                                {_, BaseValue} -> skip;
                                _ -> BaseValue = 0
                            end,
                            lists:keystore(TmpCKey, 1, AccList, 
                                {TmpCKey, AttrVal + round(BaseValue * (TmpVal / ?RATIO_COEFFICIENT))}
                            );
                        _ -> AccList
                    end;
                _ -> AccList
            end
        end, GlobalAttrList, CombineList).

task_active_base(RoleId, TaskId) ->
    case data_mount:get_constant_cfg(TaskId) of
        TypeId when is_integer(TypeId) ->
            case lists:member(TypeId, ?APPERENCE) of
                true ->
                    lib_mount:active_base_task(RoleId, TypeId);
                _ -> skip
            end;
        _ -> skip
    end.

%% 外形类型与配置表映射关系
mapping_type_to_cfg_id(?MOUNT_ID) -> ?MOUNT_ID; %%"坐骑";
mapping_type_to_cfg_id(?MATE_ID) -> ?MATE_ID; %%"伙伴";
mapping_type_to_cfg_id(?FLY_ID) -> ?FLY_ID; %%"翅膀";
mapping_type_to_cfg_id(?ARTIFACT_ID) -> ?ARTIFACT_ID; %%"圣器";
mapping_type_to_cfg_id(?HOLYORGAN_ID) -> ?HOLYORGAN_ID; %%"神兵";
mapping_type_to_cfg_id(?PET_ID) -> ?PET_ID; %%"飞骑";
mapping_type_to_cfg_id(?ZHENFA_ID) -> ?ZHENFA_ID; %%"法阵";
mapping_type_to_cfg_id(?NEW_BACK_DECORATION) -> 22; %%"背饰";
mapping_type_to_cfg_id(_) -> "".


calc_mount_star_attr(TypeId, Id, Star) ->
    case lists:member(TypeId, [?MOUNT_ID, ?MATE_ID]) of
        true ->
            case data_mount:get_mount_figure_star(TypeId, Id, Star) of
                #mount_figure_star_cfg{attr = Attr1} ->
                    lib_player_attr:partial_attr_convert(Attr1);
                _ -> []
            end;
        false ->
            case data_mount:get_figure_stage_cfg(TypeId, Id, Star) of
                #mount_figure_stage_cfg{attr = Attr1} ->
                    lib_player_attr:partial_attr_convert(Attr1);
                _ -> []
            end     
    end.