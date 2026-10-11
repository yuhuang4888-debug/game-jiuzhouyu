%% ---------------------------------------------------------------------------
%% @doc lib_node_revive

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/10/28 0028
%% @desc    复活
%% ---------------------------------------------------------------------------
-module(lib_node_revive).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").

action(State, StateName, _Node, _Now, _TickGap) when is_record(State, player_status) ->
    {State,StateName , ?BTREESUCCESS}.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State,StateName , ?BTREESUCCESS}.

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
