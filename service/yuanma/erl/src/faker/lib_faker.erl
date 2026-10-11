%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_faker.erl
%%% @author         lzh
%%% @email          lu13824949032@gmail.com
%%% @created        2021-06-05
%%% @description    假人生成接口
%%% ------------------------------------------------------------------------------------------------
-module(lib_faker).

-include("attr.hrl").
-include("common.hrl").
-include("companion.hrl").
-include("def_fun.hrl").
-include("faker.hrl").
-include("figure.hrl").
-include("mount.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("server.hrl").

-export([create_faker_by_role/1, create_faker/1]).

% -compile(export_all).

%% 默认参数
-define(DEFAULT_POWER               , 15000).                                                                                 % 战力
-define(DEFAULT_LV                  , 150).                                                                                   % 等级
-define(DEFAULT_TURN                , 1).
-define(DEFAULT_ATTR_COE            , [{1,0.013},{2,0.308},{3,0.052},{4,0.052},{5,0.0003},{6,0.0003},{7,0.0017},{8,0.0017}]). % 属性参数因子
-define(DEFAULT_COMPANION_ATTR_COE  , [{1,0.013},{2,0.308},{3,0.052},{4,0.052},{5,0.0003},{6,0.0003},{7,0.0017},{8,0.0017}]). % 伙伴属性参数因子
-define(DEFAULT_SPEED               , 370).                                                                                   % 速度

%% ============================================== exported functions ==============================================

%% 根据真实玩家构造假人参数
create_faker_by_role(RoleId) when is_integer(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            case catch lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, ?MODULE, create_faker_by_role, [], 2000) of
                #faker_info{} = FakerInfo -> FakerInfo;
                _ -> create_faker_by_role_ets(RoleId)
            end;
        _ -> create_faker_by_role_ets(RoleId)
    end;
create_faker_by_role(PS) when is_record(PS, player_status) ->
    #player_status{id = RoleId, combat_power = CombatPower, battle_attr = BA, figure = Figure} = PS,
    #figure{career = Career, sex = Sex, turn = Turn} = Figure,
    % PassiveSkill = lib_skill:get_skill_passive(PS),
    {ActiveSKills, PassiveSkills} = get_skills(Career, Sex, Turn),
    % ActiveSkill  = lib_skill_api:get_can_use_active_skill(PS),
    % ObCompanion  = lib_companion_on_api:make_ob_companion(PS),
    #faker_info{
        role_id        = RoleId,
        server_id      = config:get_server_id(),
        server_num     = config:get_server_num(),
        server_name    = util:get_server_name(),
        figure         = Figure,
        combat_power   = CombatPower,
        active_skills  = ActiveSKills,
        passive_skills = PassiveSkills,
        battle_attr    = BA
        % ob_companion = ObCompanion
    }.

create_faker_by_role_ets(RoleId) ->
    case lib_offline_player:get_player_info(RoleId, all) of
        not_exist ->
            % #faker_info{ob_companion = #ob_companion{}, battle_attr = #battle_attr{}};
            #faker_info{battle_attr = #battle_attr{}};
        PS ->
            create_faker_by_role(PS)
    end.

%% 构造假人参数
create_faker(FakerArgs) ->
    #make_faker_args{
        server_id      = ServerId,      server_num        = ServerNum, server_name       = ServerName,
        power_range    = PowerRange,    lv_range          = LvRange,   turn_range        = TurnRange,
        mount_list     = MountList,     wing_list         = WingList,  holyorgan_list    = HolyOrganList,
        companion_list = CompanionList, appellation_range = AppellationRange,
        attr_coe       = AttrCoe,       other             = OtherData
        % companion_list = CompanionIdList, companion_lv_range = CompanionLvRange,
        % companion_attr_coe = CompanionAttrCoe
    } = FakerArgs,

    FakerName                           = get_faker_name(),
    {Career, Sex}                       = lib_career:rand_career_and_sex(),
    Turn                                = get_faker_turn(TurnRange),
    CombatPower                         = get_faker_power(PowerRange),
    Lv                                  = get_faker_lv(LvRange),
    Appellation                         = get_faker_appellation(AppellationRange),
    LvModel                             = lib_player:get_model_list(Career, Sex, Turn, Lv),
    MountTypeL                          = [{?MOUNT_ID, MountList}, {?FLY_ID, WingList},
                                           {?HOLYORGAN_ID, {Career, HolyOrganList}}, {?MATE_ID, CompanionList}],
    MountFigureList                     = get_figure_mount(MountTypeL),
    % {ObCompanion, CompanionFigures}     = get_companion([CombatPower, CompanionIdList, CompanionLvRange, CompanionAttrCoe]),
    {ActiveSKills, PassiveSkills}       = get_skills(Career, Sex, Turn),
    BattleAttr                          = get_battle_attr(CombatPower, AttrCoe),

    Figure = #figure{
        name = FakerName, sex = Sex, turn = Turn, career = Career,
        lv = Lv, lv_model = LvModel, mount_figure = MountFigureList,
        medal_id = Appellation
    },

    #faker_info{
        server_id = ServerId, server_num = ServerNum, server_name = ServerName,
        combat_power = CombatPower, figure = Figure, battle_attr = BattleAttr,
        active_skills = ActiveSKills, passive_skills = PassiveSkills,
        other = OtherData
        % ob_companion = ObCompanion
    }.


%% ============================================== inner functions ==============================================

%% 姓名
get_faker_name() ->
    case data_jjc:get_robot_name_list() of
        [] ->
            utext:get(182);
        NameList ->
            SelectedL = get_selected_name(),
            SelectName = urand:list_rand(NameList -- SelectedL),
            set_selected_name(SelectName),
            SelectName
    end.

%% 防止同一进程连续获取的人名重复(yy25dlaya队伍只有三个人，其中两个假人，判断一个就好)
%% SelectedL 不能过长，否认使用 -- 时候严重影响性能
get_selected_name() ->
    NowTime = erlang:system_time(second),
    case get('$faker_name_') of
        {SelectedL, OutTime} when NowTime < OutTime ->
            SelectedL;
        _ -> []
    end.
set_selected_name(Name) ->
    NowTime = erlang:system_time(second),
    OutTime = NowTime + 60 * 15,
    put('$faker_name_', {[Name, OutTime]}).

%% 转生
get_faker_turn(TurnRange) ->
    case TurnRange of
        Turn when is_integer(Turn) -> Turn;
        [MinTurn, MaxTurn] -> urand:rand(MinTurn, MaxTurn);
        _ -> ?DEFAULT_TURN
    end.

%% 战力
get_faker_power(PowerRange) ->
    case PowerRange of
        Power when is_integer(Power) -> Power;
        [MinPower, MaxPower] -> urand:rand(MinPower, MaxPower);
        _  -> ?DEFAULT_POWER
    end.

%% 等级
get_faker_lv(LvRange) ->
    case LvRange of
        Lv when is_integer(Lv) -> Lv;
        [MinLv, MaxLv] -> urand:rand(MinLv, MaxLv);
        _ -> ?DEFAULT_LV
    end.

%% 勋章
get_faker_appellation(AppellationRange) ->
    case AppellationRange of
        Appellation when is_integer(Appellation) -> Appellation;
        [Min, Max] -> urand:rand(Min, Max);
        _ -> 1
    end.

%% 属性
get_faker_attr(Power, []) ->
    get_faker_attr(Power, ?DEFAULT_ATTR_COE);
get_faker_attr(Power, Coe) ->
    NewPowerAttrList = [{AttrType, max(1, round(Value*Power))} || {AttrType, Value} <- Coe],
    lib_player_attr:to_attr_record(NewPowerAttrList).

% get_faker_companion_attr(Power, []) ->
%     get_faker_companion_attr(Power, ?DEFAULT_COMPANION_ATTR_COE);
% get_faker_companion_attr(Power, Coe) ->
%     NewPowerAttrList = [{AttrType, max(1, round(Value*Power))} || {AttrType, Value} <- Coe],
%     lib_player_attr:to_attr_record(NewPowerAttrList).

%% 外形
get_figure_mount(MountTypeL) -> get_figure_mount(MountTypeL, []).

get_figure_mount([], Acc) -> Acc;
get_figure_mount([{_, []} | T], Acc) -> get_figure_mount(T, Acc);
get_figure_mount([{Type, SpecList} | T], Acc) when Type == ?MOUNT_ID; Type == ?FLY_ID; Type == ?MATE_ID ->
    get_figure_mount(T, [{Type, urand:list_rand(SpecList), 0} | Acc]);
get_figure_mount([{?HOLYORGAN_ID, {Career, HolyOrganList}} | T], Acc) ->
    case lists:keyfind(Career, 1, HolyOrganList) of
        {_, HolyorganL} when HolyorganL /= [] ->
            get_figure_mount(T, [{?HOLYORGAN_ID, urand:list_rand(HolyorganL), 0} | Acc]);
        _ ->
            get_figure_mount(T, Acc)
    end.

%% 技能
get_skills(Career, Sex, _Turn) ->
    ActiveSkills = lib_skill_api:get_career_active_skill_default_lv_list(Career, Sex),
    % 被动技能先不做
    PassiveSkills = [],
    {ActiveSkills, PassiveSkills}.

%% 属性
get_battle_attr(CombatPower, AttrCoe) ->
    RivalAttr = get_faker_attr(CombatPower, AttrCoe),
    #battle_attr{hp=RivalAttr#attr.hp, hp_lim=RivalAttr#attr.hp, attr=RivalAttr, speed = ?DEFAULT_SPEED}.

% %% 使徒
% get_companion([CombatPower, CompanionIdList, CompanionLvRange, CompanionAttrCoe]) ->
%     case CompanionIdList of
%         [] -> {#ob_companion{}, []};
%         _ ->
%             CompanionId = urand:list_rand(CompanionIdList),
%             CompanionAttr = get_faker_companion_attr(CombatPower, CompanionAttrCoe),
%             ObCompanion = lib_companion_on_api:make_robot_ob_companion(CompanionAttr, CompanionId),
%             #base_companion_cfg{skin_id = SkinId, default_star = Star} = data_companion:get_companion_cfg(CompanionId),
%             Lv = case CompanionLvRange of
%                 [Min, Max] -> urand:rand(Min, Max);
%                 _ -> 1
%             end,
%             Figure = #companion_figure{
%                 type = 1, companion_id = CompanionId, pos = 1,
%                 star = Star, skin_id = SkinId, lv = Lv
%             },
%             {ObCompanion, [Figure]}
%     end.