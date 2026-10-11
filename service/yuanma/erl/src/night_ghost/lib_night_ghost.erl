%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_night_ghost.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行玩家库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_night_ghost).

-include("activitycalen.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("night_ghost.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").

-export([
    send_act_info/1, send_boss_info/2, enter_scene/2, exit_scene/1, reconnect/2,
    role_success_end_activity/1
]).

-export([send_msg/2, is_night_ghost_scene/1]).

% -compile(export_all).

%%% ======================================== init/load/clear =======================================



%%% ======================================= protocol related =======================================

%% 获取活动信息
send_act_info(PS) ->
    #player_status{id = RoleId} = PS,
    mod_night_ghost_local:send_act_info(RoleId).

%% 获取boss信息
send_boss_info(SceneId, PS) ->
    #player_status{id = RoleId} = PS,
    mod_night_ghost_local:send_boss_info(RoleId, SceneId).

%% 进入场景
enter_scene(SceneId, PS) ->
    #player_status{id = RoleId} = PS,
    case lib_night_ghost_check:enter_scene(SceneId, PS) of
        true ->
            mod_night_ghost_local:enter_scene(RoleId, SceneId);
        {false, ErrCode} ->
            send_msg(PS, ErrCode)
    end,
    ok.

%% 退出场景
exit_scene(PS) ->
    case lib_night_ghost_check:exit_scene(PS) of
        true ->
            lib_scene:change_scene(PS, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 1}]);
        {false, ErrCode} ->
            send_msg(PS, ErrCode),
            PS
    end.

%% 玩家重连
%% @return {ok, PS} | {next, PS}
reconnect(PS, ?NORMAL_LOGIN) ->
    #player_status{scene = SceneId} = PS,
    case is_night_ghost_scene(SceneId) of
        true ->
            % mod_night_ghost_local:reconnect(RoleId, SceneId), % 正常登录不重连至场景
            NewPS = lib_scene:change_default_scene(PS, [{group, 0}, {change_scene_hp_lim, 1}]),
            {ok, NewPS};
        false ->
            {next, PS}
    end;
reconnect(PS, ?RE_LOGIN) ->
    #player_status{scene = SceneId} = PS,
    case is_night_ghost_scene(SceneId) of
        true ->
            {X, Y} = get_scene_default_xy(SceneId),
            NewPS = PS#player_status{x = X, y = Y},
            {ok, lib_scene:change_relogin_scene(NewPS, [{change_scene_hp_lim, 1}])};
        false ->
            {next, PS}
    end.

%% 根据玩家场景判断玩家是否完成活动
%% @return #player_status{}
role_success_end_activity(PS) ->
    #player_status{id = RoleId, scene = SceneId} = PS,
    case is_night_ghost_scene(SceneId) of
        true ->
            mod_daily:plus_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_NIGHT_GHOST, 1), 1), % 目前百鬼夜行没有活跃度配置,所以此处手动加上次数
            lib_activitycalen_api:role_success_end_activity(PS, ?MOD_NIGHT_GHOST, 1);
        false ->
            PS
    end.

%%% ======================================= utility functions ======================================

%% 返回码信息
send_msg(#player_status{sid = SId}, Code) ->
    send_msg(SId, Code);
send_msg(SId, Code) when is_pid(SId) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    lib_server_send:send_to_sid(SId, pt_206, 20600, [CodeInt, CodeArgs]);
send_msg(UId, Code) when is_integer(UId) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    lib_server_send:send_to_uid(UId, pt_206, 20600, [CodeInt, CodeArgs]).

%% 判断是否百鬼夜行场景
%% @return boolean()
is_night_ghost_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_NIGHT_GHOST} ->
            true;
        _ ->
            false
    end.

%% 获取场景默认坐标值
get_scene_default_xy(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{x = X, y = Y} ->
            {X, Y};
        _ ->
            {0, 0}
    end.

%%% ======================================= private functions ======================================