%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_night_ghost_check.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-12
%%% @modified
%%% @description    百鬼夜行检查函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_night_ghost_check).

-include("chat.hrl").
-include("clusters.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("night_ghost.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").

-export([enter_scene/2, exit_scene/1, boss_broadcast_reward/2]).

% -compile(export_all).

%%% ====================================== exported functions ======================================

%% 进入场景
%% @return true | {false, ErrCode}
enter_scene(_SceneId, PS) when is_record(PS, player_status) -> % 玩家进程检查
    CheckList = [
        {general_check, PS}, {is_enough_lv, PS}
    ],
    check_list(CheckList);

enter_scene({_RoleId, SceneId}, State) when is_record(State, night_ghost_state_local) -> % 本服进程检查
    CheckList = [
        {is_scene_exist, SceneId, State}
    ],
    check_list(CheckList).

%% 退出场景
%% @return true | {false, ErrCode}
exit_scene(PS) ->
    #player_status{scene = SceneId} = PS,
    CheckList = [
        {is_ng_scene, SceneId}
    ],
    check_list(CheckList).

%% boss召集奖励(本服检查)
%% @return true | {false, ErrCode}
boss_broadcast_reward({_RoleId, Channel, SceneId, BossUId}, State) ->
    #night_ghost_state_local{ser_mod = SerMod} = State,
    CheckList = [
        {is_channel_match, SerMod, Channel}, {is_boss_alive, SceneId, BossUId, State},
        {is_first_player_bc, SceneId, BossUId, State}
    ],
    check_list(CheckList).

%%% ======================================== inner functions =======================================

%% 条件列表检查
%% @return true | {false, ErrCode}
check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        true -> check_list(T);
        {false, Res} -> ?PRINT("check error ~p~n", [Res]), {false, Res}    % {false, ?FAIL}都是非正常错误
    end.

%% 玩家通用检查
check({general_check, PS}) ->
    lib_player_check:check_all(PS);

%% 等级是否达到
check({is_enough_lv, PS}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case Lv >= ?NG_LV_LIMIT of
        true -> true;
        false -> {false, ?ERRCODE(err206_not_enough_lv)}
    end;

%% 场景是否存在
check({is_scene_exist, SceneId, State}) ->
    #night_ghost_state_local{ser_mod = SerMod} = State,
    SceneList = data_night_ghost:get_scene_list(SerMod),
    case lists:member(SceneId, SceneList) of
        true -> true;
        false -> {false, ?ERRCODE(err206_scene_not_exist)}
    end;

%% 是否百鬼之门场景
check({is_ng_scene, SceneId}) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_NIGHT_GHOST} -> true;
        _ -> {false, ?ERRCODE(err206_not_ng_scene)}
    end;

%% 广播频道和跨服模式是否匹配
check({is_channel_match, SerMod, Channel}) ->
    case {SerMod, Channel} of
        {?ZONE_MOD_1, ?CHAT_CHANNEL_WORLD} -> true;
        {_, ?CHAT_CHANNEL_NG} -> true;
        _ -> {false, ?FAIL}
    end;

%% boss是否还活着
check({is_boss_alive, SceneId, BossUId, State}) ->
    case lib_night_ghost_mod:get_boss_info_local(BossUId, SceneId, State) of
        #boss_info{is_alive = true} -> true;
        _ -> {false, ?FAIL}
    end;

%% 是否为首个召集的玩家
check({is_first_player_bc, SceneId, BossUId, State}) ->
    case lib_night_ghost_mod:get_boss_info_local(BossUId, SceneId, State) of
        #boss_info{bc_player = []} -> true;
        _ -> {false, ?FAIL}
    end;

check(_) ->
    {false, ?FAIL}.