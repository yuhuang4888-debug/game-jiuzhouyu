%% ---------------------------------------------------------------------------
%% @doc lib_decoration_boss_util.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss util
%% ---------------------------------------------------------------------------
-module(lib_decoration_boss_util).
-compile(export_all).

-include("decoration_boss.hrl").
-include("scene.hrl").

%% 初始化怪物
init_boss_map(ClsType) ->
    init_boss_map(ClsType, 0).

init_boss_map(ClsType, ScenePoolId) ->
    BossIdL = data_decoration_boss:get_boss_id_list(),
    init_boss_map(BossIdL, ClsType, ScenePoolId, #{}).

init_boss_map([], _ClsType, _ScenePoolId, BossMap) -> BossMap;
init_boss_map([BossId|L], ClsType, ScenePoolId, BossMap) ->
    #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
    case data_scene:get(SceneId) of
        #ets_scene{cls_type = ClsType} ->
            Boss = #decoration_boss{boss_id = BossId, scene_id = SceneId, cls_type = ClsType}, 
            lib_mon:async_create_mon(BossId, SceneId, ScenePoolId, X, Y, 1, BossId, 1, []),
            NewBossMap = maps:put(BossId, Boss, BossMap),
            init_boss_map(L, ClsType, ScenePoolId, NewBossMap);
        _ ->
            init_boss_map(L, ClsType, ScenePoolId, BossMap)
    end.

%% 场景处理内部处理
check_and_enter_on_scene(CopyId) ->
    length(lib_scene_agent:get_scene_user(CopyId)).
