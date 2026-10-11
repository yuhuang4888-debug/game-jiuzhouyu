%% ---------------------------------------------------------------------------
%% @doc lib_scene_object_event
%% @author ming_up@foxmail.com
%% @since  2017-04-11
%% @deprecated 场景事件
%% ---------------------------------------------------------------------------
-module (lib_scene_event).

-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("predefine.hrl").
-include("dungeon.hrl").
-include("attr.hrl").

-compile(export_all).


%% 开启一个新线路
copy_a_outside_scene(SceneId, PoolId, CopyId) ->
    %% 场景开启新线路的时候自动初始化青云夺宝的宝箱
    TreasureChestSceneId = data_treasure_chest:get_cfg(1),
    if
        TreasureChestSceneId == SceneId ->
            mod_treasure_chest:refresh_chest_by_auto_line(PoolId, CopyId);
        true -> skip
    end,
	ok.
