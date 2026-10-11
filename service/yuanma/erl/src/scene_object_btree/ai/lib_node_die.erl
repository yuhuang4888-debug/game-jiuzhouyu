%% ---------------------------------------------------------------------------
%% @doc lib_node_die

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/9 0009
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_die).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").

action(State, _StateName, Node, Now, _TickGap) when is_record(State, ob_act) ->
    erlang:send_after(100, self(), 'die'),
    NewNode = lib_node_action:set_time_success(Node, Now, 2000),
    {State, ?BTREERUNNING, NewNode}.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State,StateName , ?BTREESUCCESS}.

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
