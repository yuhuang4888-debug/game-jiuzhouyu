%% ---------------------------------------------------------------------------
%% @doc lib_node_buff

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/17 0017
%% @desc    添加Buff
%% ---------------------------------------------------------------------------
-module(lib_node_buff).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").

action(State, StateName, Node, _Now, _TickGap) when is_record(State, ob_act) ->
    #action_node{args = Args} = Node,
    case Args of
        [{skill_id, _SkillL}|_] ->
            %lib_scene_object_ai:add_buff(State, SkillL),
            {State,StateName , ?BTREESUCCESS};
        _ ->
            {State,StateName , ?BTREEFAILURE}
    end.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State,StateName , ?BTREESUCCESS}.

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
