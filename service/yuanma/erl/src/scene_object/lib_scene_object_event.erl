%% ---------------------------------------------------------------------------
%% @doc lib_scene_object_event
%% @author ming_up@foxmail.com
%% @since  2017-04-11
%% @deprecated 场景对象事件
%% ---------------------------------------------------------------------------
-module(lib_scene_object_event).

-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("predefine.hrl").
-include("dungeon.hrl").
-include("attr.hrl").

-compile(export_all).

be_killed(Object, _Klist, _Atter, _AtterSign) -> 
    #scene_object{sign=Sign, id = _AutoId, scene = SceneId, copy_id = _CopyId} = Object,

    case lib_scene:is_clusters_scene(SceneId) of
        true  -> skip;
        false when Sign == ?BATTLE_SIGN_MON -> skip;
        false when Sign == ?BATTLE_SIGN_PARTNER -> 
            %lib_jjc_api:object_be_killed(SceneId, AutoId, CopyId),
            % lib_war_god_api:object_die(Object),
            % lib_adventure_tour_api:object_die(Object),
            % lib_hero_war_api:object_die(Object),
            lib_dungeon_api:object_die(Object);
        % false when Sign == ?BATTLE_SIGN_DUMMY -> 
            %lib_jjc_api:object_be_killed(SceneId, AutoId, CopyId),
            % lib_war_god_api:object_die(Object),
            % lib_adventure_tour_api:object_die(Object),
            % lib_hero_war_api:object_die(Object);
        false -> skip
    end,
    ok.

be_hurted(_Object, _Atter, _AtterSign, _Hurt) ->
    % #scene_object{scene=SceneId} = Object,
    % case lib_scene:is_clusters_scene(SceneId) of
    %     true  -> skip;
    %     false -> 
    %         lib_war_god_api:hurt_object(Object, Atter, Hurt),
    %         lib_hero_war_api:hurt_object(Object, Atter, Hurt)
    % end,
    ok.

%% 被清理
be_stop(Object) -> 
    #scene_object{sign=Sign, scene=SceneId} = Object,
    case lib_scene:is_clusters_scene(SceneId) of
        true  -> skip;
        false when Sign == ?BATTLE_SIGN_PARTNER -> 
            lib_dungeon_api:object_stop(Object);
        false -> skip
    end,
    ok.