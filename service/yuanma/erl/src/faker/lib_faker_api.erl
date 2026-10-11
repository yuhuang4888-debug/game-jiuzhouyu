%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_faker_api.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-09-29
%%% @description    假人生成外部接口
%%% ------------------------------------------------------------------------------------------------
-module(lib_faker_api).

-include("attr.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("faker.hrl").
-include("figure.hrl").
-include("jjc.hrl").
-include("scene.hrl").

-export([]).

-compile(export_all).

%%% ====================================== exported functions ======================================

%% -----------------------------------------------
%% @doc 生成假人信息
-spec
create_faker(Mod, Data) -> #faker_info{} when
    Mod  :: integer(),
    Data :: term().
%% -----------------------------------------------
create_faker(?MOD_JJC, {RoleId, _Rank}) -> % 竞技场真人镜像
    FakerInfo = lib_faker:create_faker_by_role(RoleId),
    handle_info_by_module(?MOD_JJC, FakerInfo);

create_faker(Mod, Data) -> % 常规假人
    FakerArgs = lib_faker_data:get_faker_args(Mod, Data),
    FakerInfo = lib_faker:create_faker(FakerArgs),
    handle_info_by_module(Mod, FakerInfo).

%% -----------------------------------------------
%% @doc 生成双方假人(应在战斗进程调用)
-spec
sync_create_object(Mod, {SelfImage, RivalImage}) -> {FakeId1, FakeId2, CallbackData} when
    Mod          :: integer(),
    SelfImage    :: #image_role{},
    RivalImage   :: #image_role{},
    FakeId1      :: integer(),
    FakeId2      :: integer(),
    CallbackData :: map().
%% -----------------------------------------------
sync_create_object(?MOD_JJC, {SelfImage, RivalImage}) ->
    % 场景
    [SceneId] = data_jjc:get_jjc_value(?JJC_SCENE_ID),
    ScenePoolId = 0,
    #image_role{role_info = #faker_info{role_id = CopyId}} = SelfImage, % 以玩家id作为房间id
    % 假人参数
    {Path1, Path2}   = lib_faker_data:get_faker_path(?MOD_JJC),
    [{X1, Y1}, End1] = Path1,
    [{X2, Y2}, End2] = Path2,
    SelfArgs0        = get_object_args(?MOD_JJC, SelfImage),
    SelfArgs         = SelfArgs0 ++ [{path, [End1]}, {group, 2}, {tree_id, jjc_dummy1}], % group要放在后面,先设值battle_attr
    RivalArgs0       = get_object_args(?MOD_JJC, RivalImage),
    RivalArgs        = RivalArgs0 ++ [{path, [End2]}, {group, 1}, {tree_id, jjc_dummy2}],
    % 反馈数据
    CallbackData = #{
        scene_id => SceneId,
        pool_id  => ScenePoolId,
        copy_id  => CopyId
    },
    FakeId1 = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X1, Y1, 1, CopyId, 1, SelfArgs),
    FakeId2 = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X2, Y2, 1, CopyId, 1, RivalArgs),
    {FakeId1, FakeId2, CallbackData};

sync_create_object(?MOD_DRUMWAR, FakerInfo) ->
    #faker_info{
        combat_power = Power,
        other = OtherInfo
    } = FakerInfo,
    #{group := Group} = OtherInfo,

    % 场景
    {SceneId, PoolId, CopyId} = lib_role_drum:get_war(Group),
    % 假人参数
    {X, Y} = lib_role_drum:left_pos(),
    Args = get_object_args(?MOD_DRUMWAR, FakerInfo),
    % 反馈数据
    CallbackData = #{power => Power},
    FakerId = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, PoolId, X, Y, 1, CopyId, 1, Args),
    {FakerId, CallbackData}.

%%% ======================================== inner functions =======================================

%% 根据功能模块进行后续参数处理
%% @return #faker_info{}
handle_info_by_module(?MOD_JJC, FakerInfo) ->
    #faker_info{
        figure = Figure
    } = FakerInfo,
    NewFigure = Figure#figure{god_id = 0, demons_id = 0}, % 降神、使魔不进入竞技场
    FakerInfo#faker_info{figure = NewFigure};

handle_info_by_module(?MOD_DRUMWAR, FakerInfo) ->
    #faker_info{
        figure = Figure,
        combat_power = Power,
        other = Other
    } = FakerInfo,
    #{
        role_attr := RoleAttr,
        mount_figure := MountFigure
    } = Other,
    BattleAttr = lib_role_drum_data:get_faker_battle_attr(RoleAttr),
    BattleAttr1 = BattleAttr#battle_attr{combat_power = Power},
    NewFigure = Figure#figure{vip = 3, mount_figure = MountFigure},
    FakerInfo#faker_info{battle_attr = BattleAttr1, figure = NewFigure};

handle_info_by_module(_, FakerInfo) -> FakerInfo.

%% 获取生成假人基本参数
%% @return list()
get_object_args(?MOD_JJC, ImageRole) ->
    #image_role{
        role_info = #faker_info{
            role_id = RoleId,
            figure = Figure,
            battle_attr = BA,
            active_skills = Skills
        }
    } = ImageRole,
    [{figure, Figure}, {battle_attr, BA}, {skill, Skills}, {die_handler, {lib_jjc_battle, fake_man_die_handler, [self()]}},
    {warning_range, 300}, {mod_args, RoleId}];

get_object_args(?MOD_DRUMWAR, FakerInfo) ->
    GapFight = data_drumwar:get_kv(16),
    #faker_info{
        figure = Figure,
        battle_attr = BA,
        active_skills = Skills
    } = FakerInfo,
    [{figure, Figure}, {battle_attr, BA}, {skill, Skills}, {die_handler, {lib_role_drum, dummy_die, []}},
    {group, 2}, {warning_range, 1000}, {find_target, GapFight*1000}].
