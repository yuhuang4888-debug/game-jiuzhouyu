%%-----------------------------------------------------------------------------
%% @Module  :       battle_field.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-01
%% @Description:    战场
%%-----------------------------------------------------------------------------

-define (ROLE_STATE_OUT, 0).        %% 不在战场中
-define (ROLE_STATE_BEFORE_IN, 1).  %% 已经调用了change_scene但是还没有触发finish_change_scene
-define (ROLE_STATE_IN, 2).         %% 正在战场中

-define (HAS_API(Mod, ApiName, ArgsNum), lists:member({ApiName, ArgsNum}, Mod:module_info(exports))).

-record (battle_state, {
    lib = lib_battle_field,
    cur_scene = 0,
    scene_pool_id = 0,
    copy_id = 0,
    data = #{},
    roles = #{},
    is_end = false,
    self = undefined
    }).

-record (battle_role, {
    key,
    out_info = #{},   %% #{scene := SceneId, scene_pool_id := ScenePoolId, copy_id := CopyId, x := X, y := Y, scene_args := []}
    in_info = #{}, %% #{x := X, y := Y, scene_args := []}
    state = ?ROLE_STATE_OUT,
    data = #{}
    }).