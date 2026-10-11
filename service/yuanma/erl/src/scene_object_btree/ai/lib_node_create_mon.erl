%% ---------------------------------------------------------------------------
%% @doc lib_node_create_mon

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/5/12 0012
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_create_mon).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-export([
      sub_born_handler/3
    , sub_hp_change_handler/4
    , sub_die_handler/5
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").

action(State, StateName, Node, _Now, _TickGap) when is_record(State, ob_act) ->
    #ob_act{object = SceneObj} = State,
    #scene_object{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, aid = Aid, battle_attr = #battle_attr{group = Group}} = SceneObj,
    {Type, MonId, XMin, XMax, YMin, YMax, Num, OtherArgs} = get_create_mon_args(Node),
    NOtherArgs = [
        {born_handler, {?MODULE, sub_born_handler, [Aid]}}, {die_handler, {?MODULE, sub_die_handler, [Aid]}},
        {hp_change_handler, {?MODULE, sub_hp_change_handler, [Aid]}, {group, Group}}|OtherArgs
    ],
    case Type of
        2 ->
            Data = [X, Y, SceneObj#scene_object.tracing_distance, 1],
            lib_mon:create_mon_on_user(SceneId, ScenePoolId, CopyId, Data, MonId, true, NOtherArgs);
        _ ->
            F = fun() ->
                {Xzero, Yzero} = create_mon_xy(Type, XMin, XMax, YMin, YMax, SceneObj),
                lib_mon:async_create_mon(MonId, SceneId, ScenePoolId, Xzero, Yzero, true, CopyId, 1, NOtherArgs)
            end,
            [F()||_<-lists:seq(1, Num)]
    end,
    {State, StateName, ?BTREESUCCESS}.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State, StateName, ?BTREESUCCESS}.

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.

%% 怪物招怪的坐标选取
create_mon_xy(1, Xmin, Xmax, Ymin, Ymax, #scene_object{x = MonX, y = MonY, scene = SceneId, copy_id = CopyId})->
    % X = if
    %         % Xmin < 0 orelse Xmax < 0        -> MonX;                          %% 在目标位置召唤
    %         Xmin < Xmax                     -> MonX + urand:rand(Xmin, Xmax); %% 在Xmin-Xmax直接随机偏移
    %         Xmin == Xmax andalso Xmin == 0  -> MonX;                          %% 当Xmin=Xmax=0，直接取父辈值
    %         Xmin == Xmax                    -> Xmin;                          %% 当Xmin=Xmax/=0，直接取Xmin值
    %         Xmin > Xmax                     -> MonX + Xmin                    %% 取固定偏移值
    %     end,
    % Y = if
    %         % Ymin < 0 orelse Ymax < 0        -> MonY;                          %% 同X的取值规则
    %         Ymin < Ymax                     -> MonY + urand:rand(Ymin, Ymax);
    %         Ymin == Ymax andalso Ymin == 0  -> MonY;
    %         Ymin == Ymax                    -> Ymin;
    %         Ymin > Ymax                     -> MonY + Ymin
    %     end,
    % Xzero = case X > 0 of true -> X; false -> 0 end,
    % Yzero = case Y > 0 of true -> Y; false -> 0 end,
    % case lib_scene:is_blocked(SceneId, CopyId, Xzero, Yzero) of
    %     false ->
    %         {Xzero, Yzero};
    %     true ->
    %         {MonX, MonY}
    % end,
    RightX = urand:rand(Xmin, Xmax),
    TopY = urand:rand(Ymin, Ymax),
    % 随机出左右
    case urand:rand(1, 10000) =< 5000 of
        true -> X = MonX+RightX;
        false -> X = MonX-RightX
    end,
    % 随机出上下
    case urand:rand(1, 10000) =< 5000 of
        true -> Y = MonY+TopY;
        false -> Y = MonY-TopY
    end,
    Xzero = case X > 0 of true -> X; false -> 0 end,
    Yzero = case Y > 0 of true -> Y; false -> 0 end,
    case lib_scene:is_blocked(SceneId, CopyId, Xzero, Yzero) of
        true -> {MonX, MonY};
        false -> {Xzero, Yzero}
    end;
create_mon_xy(_, _, _, _, _, #scene_object{d_x = BornX, d_y = BornY}) ->
    {BornX, BornY}.

sub_born_handler(init, Object, [Aid]) when is_pid(Aid) ->
    #scene_object{battle_attr = BA, id = Id, config_id = CfgId} = Object,
    Aid ! {sub_mon_born, {Id, CfgId, BA}};
sub_born_handler(_, _, _) ->
    skip.

sub_hp_change_handler(Object, _Hp, _NewKList, [Aid]) when is_pid(Aid) ->
    #scene_object{battle_attr = BA, id = Id, config_id = CfgId} = Object,
    Aid ! {sub_mon_born, {Id, CfgId, BA}};
sub_hp_change_handler(_, _, _, _) ->
    skip.

sub_die_handler(Object, _KListAfCombine, _Atter, _AtterSign, [Aid]) when is_pid(Aid) ->
    #scene_object{id = Id} = Object,
    Aid ! {sub_mon_die, Id};
sub_die_handler(_, _, _, _, _) ->
    skip.

get_create_mon_args(Node) ->
    #action_node{args = Args} = Node,
    % Type 1以自身为中心，2以目标为中心，3以怪物出生点创建
    {type, Type} = lists:keyfind(type, 1, Args),
    {mon_id, MonId} = lists:keyfind(mon_id, 1, Args),
    {x, [{XMin, XMax}]} = lists:keyfind(x, 1, Args),
    {y, [{YMin, YMax}]} = lists:keyfind(y, 1, Args),
    {arg, Arg} = lists:keyfind(arg, 1, Args),
    {num, Num} = lists:keyfind(num, 1, Args),
    {Type, MonId, XMin, XMax, YMin, YMax, Num, Arg}.