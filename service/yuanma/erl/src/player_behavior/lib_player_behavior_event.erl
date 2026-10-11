%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/12/6 0006
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_event).

-export([
    change_scene/1,
    load_scene/1
]).

-include("common.hrl").
-include("server.hrl").
-include("player_behavior.hrl").

change_scene(PS) ->
    lib_player_behavior:stop_behavior(PS).

load_scene(PS) ->
    lib_player_behavior:start_behavior(PS).
