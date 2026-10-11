%% ---------------------------------------------------------------------------
%% @doc lib_battle_api
%% @author ming_up@foxmail.com
%% @since  2017-07-11
%% @deprecated  战斗参数
%% ---------------------------------------------------------------------------
-module(lib_battle_api).
-export([
    assist_anything/8, 
    break_steath_force/4
    ,slim_back_data/2
    ,update_by_slim_back_data/2
    ,gm_battle/3
    ]).

-include ("scene.hrl").
-include ("attr.hrl").
-include ("server.hrl").
-include ("common.hrl").

%% 对目标释放一个辅助技能
assist_anything(Scene, ScenePoolId, SignA, IdA, SignT, IdT, SkillId, SkillLv) -> 
    mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, lib_battle, assist_anything, [SignA, IdA, SignT, IdT, SkillId, SkillLv]).

%% 对目标释放一个主动技能(目前不支持有副技能的)
% active_anything() ->
    % BattleArgs = #battle_args{
    %     att_key=RoleId, mon_list=NMonList, player_list=NPlayerList, att_x=AttX, att_y=AttY, sign = Sign,
    %     skill_id=SkillId, skill_lv=SkillLv, skill_call_back = CallBackArgs, now_time=NowTime, att_angle=AttAngle, 
    %     is_combo=IsCombo, skill_stren=lib_skill:get_skill_stren_for_battle(Status0, SkillId)
    %     },
    % mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, start_battle, [BattleArgs]),

break_steath_force(Scene, ScenePoolId, Sign, Id) -> 
    mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, lib_battle, break_steath_force, [Sign, Id]).

%% !!!注意!!!同步修改update_by_slim_back_data
%% 进程传输用的回写数据 怪物、假人、伙伴 
slim_back_data(
        #scene_object{
            battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim},
            skill_cd    = Cd,
            skill_cd_map = SkillCdMap,
            skill_combo = Combo,
            shaking_skill = SkSkill,
            last_skill_id = LastSkillId,
            pub_skill_cd = PubSkillCd,
            x = X,
            y = Y,
            per_hurt = PerHurt,
            per_hurt_time = PerHurtTime
        }, _) ->
    [Combo, Hp, HpLim, Cd, SkillCdMap, SkSkill, LastSkillId, PubSkillCd, X, Y, PerHurt, PerHurtTime];

slim_back_data(
        #ets_scene_user{
            battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim},
            skill_cd    = Cd,
            skill_cd_map = SkillCdMap,
            skill_combo = Combo,
            shaking_skill = SkSkill,
            last_skill_id = LastSkillId,
            pub_skill_cd = PubSkillCd,
            x = X,
            y = Y
        }, ?BATTLE_SIGN_PLAYER) ->
    [Combo, Hp, HpLim, Cd, SkillCdMap, SkSkill, LastSkillId, PubSkillCd, X, Y];

slim_back_data(Whatever, _) -> Whatever.

%% 更新怪物进程里的scene_object
update_by_slim_back_data(
        #scene_object{battle_attr = BA} = Object, 
        [Combo, Hp, HpLim, Cd, SkillCdMap, SkSkill, LastSkillId, PubSkillCd, X, Y, PerHurt, PerHurtTime]
        ) ->
    Object#scene_object{
        battle_attr = BA#battle_attr{hp = Hp, hp_lim = HpLim},
        skill_cd    = Cd,
        skill_cd_map = SkillCdMap,
        skill_combo = Combo,
        shaking_skill = SkSkill,
        last_skill_id = LastSkillId,
        pub_skill_cd = PubSkillCd,
        x = X,
        y = Y,
        per_hurt = PerHurt,
        per_hurt_time = PerHurtTime
    };

update_by_slim_back_data(
        #ets_scene_user{battle_attr = BA} = User,
        [Combo, Hp, HpLim, Cd, SkillCdMap, SkSkill, LastSkillId, PubSkillCd, X, Y]
        ) ->
    User#ets_scene_user{
        battle_attr = BA#battle_attr{hp = Hp, hp_lim = HpLim},
        skill_cd    = Cd,
        skill_cd_map = SkillCdMap,
        skill_combo = Combo,
        shaking_skill = SkSkill,
        last_skill_id = LastSkillId,
        pub_skill_cd = PubSkillCd,
        x = X,
        y = Y
    };

update_by_slim_back_data(#ets_scene_user{} = User, _) -> User;

update_by_slim_back_data(_Whatever, Whatever) -> Whatever.

%% 秘籍释放技能
gm_battle(Player, SkillId_, Angle_) ->
    #player_status{scene = SceneId, scene_pool_id = PoolId, x = X, y = Y, copy_id = CopyId} = Player,
    SkillId = list_to_integer(SkillId_),
    Angle = list_to_integer(Angle_),
    {ok, MonList, PlayerList} = mod_scene_agent:get_scene_area_all(SceneId, PoolId, X, Y, CopyId),
    {ok, ResPlayer} = pp_battle:handle(20001, Player, [MonList, PlayerList, SkillId, X, Y, Angle]),
    ResPlayer.
