%% ---------------------------------------------------------------------------
%% @doc lib_node_pick_up

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/10/28 0028
%% @desc    拾取地上宝箱
%% ---------------------------------------------------------------------------
-module(lib_node_pick_up).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("player_behavior.hrl").
-include("drop.hrl").

action(PS, StateName, Node, NowTime, TickGap) when is_record(PS, player_status) ->
    case lib_player_behavior:get_drop_att(PS, NowTime) of
        {PS1, DropGoods} when is_record(DropGoods, ets_drop) ->
            case lib_player_behavior:start_pick_drop(PS1, NowTime, TickGap, DropGoods) of
                wait_call_back ->
                    {PS1, ?BTREERUNNING, Node};
                {re_action, WaitMs} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {PS1, ?BTREERUNNING, NewNode};
                {re_action, WaitMs, NewPS} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                _ ->
                    FailPS = lib_player_behavior:remove_drop_att(PS1),
                    {FailPS,StateName , ?BTREEFAILURE}
            end;
        _ ->
            FailPS = lib_player_behavior:remove_drop_att(PS),
            {FailPS, StateName , ?BTREEFAILURE}
    end.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State,StateName , ?BTREEFAILURE}.

%% 拾取成功
action_call_back(PS, StateName, _Node, _NowTime, _TickGap, {'pick_up_end', DropId}) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    DropMap = lib_player_behavior:get_drop_map(PS),
    NewDropMap = maps:remove(DropId, DropMap),
    PS1 = PS#player_status{behavior_status = BehaviorStatus#player_behavior{drop_att = undefined}},
    PS2 = lib_player_behavior:set_drop_map(PS1, NewDropMap),
    {finish, PS2, StateName};

%% 拾取开始
action_call_back(PS, StateName, Node, NowTime, _TickGap, {'pick_up_start', DropId}) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    DropMap = lib_player_behavior:get_drop_map(PS),
    case maps:get(DropId, DropMap, false) of
        #ets_drop{pick_time = PickTime} ->
            NewNode = lib_node_action:set_time_success(Node, NowTime, PickTime),
            {update, PS, NewNode};
        _ ->
            NewDropMap = maps:remove(DropId, DropMap),
            PS1 = PS#player_status{behavior_status = BehaviorStatus#player_behavior{drop_att = undefined}},
            PS2 = lib_player_behavior:set_drop_map(PS1, NewDropMap),
            {failure, PS2, StateName}
    end;

%% 拾取成功
action_call_back(PS, StateName, _Node, _NowTime, _TickGap, {'pick_up_fail', DropId}) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    DropMap = lib_player_behavior:get_drop_map(PS),
    NewDropMap = maps:remove(DropId, DropMap),
    PS1 = PS#player_status{behavior_status = BehaviorStatus#player_behavior{drop_att = undefined}},
    PS2 = lib_player_behavior:set_drop_map(PS1, NewDropMap),
    {failure, PS2, StateName};

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
