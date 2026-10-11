%% ---------------------------------------------------------------------------
%% @doc lib_node_check

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/4/27 0027
%% @desc       叶子节点判断模块
%% ---------------------------------------------------------------------------
-module(lib_node_check).

-export([
      check_condition/2
    , is_continue_trace/3             % 是否继续追踪
]).

-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("scene.hrl").
-include("server.hrl").

%% ====================
%% 检查条件
check_condition(_State, []) -> ?BTREESUCCESS;
check_condition(State, [H|T]) ->
    case do_check_condition(State, H) of
        true -> check_condition(State, T);
        _ -> ?BTREEFAILURE
    end.

%% ====================
%% 判断血量
do_check_condition(State, {hp_more, NeedHpRatio}) when is_record(State, ob_act) ->
    #ob_act{object = Minfo} = State,
    #scene_object{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLimit}} = Minfo,
    Per = round((Hp / HpLimit) * ?RATIO_COEFFICIENT),
    Per >= NeedHpRatio;

do_check_condition(State, {hp_less, NeedHpRatio}) when is_record(State, ob_act) ->
    #ob_act{object = Minfo} = State,
    #scene_object{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLimit}} = Minfo,
    Per = round((Hp / HpLimit) * ?RATIO_COEFFICIENT),
    Per =< NeedHpRatio;

% 伴生怪物数量
do_check_condition(State, {mon_num_less, MonNum}) when is_record(State, ob_act) ->
    #ob_act{sub_mons = SubMonList} = State,
    length(SubMonList) =< MonNum;
do_check_condition(State, {mon_num_more, MonNum}) when is_record(State, ob_act) ->
    #ob_act{sub_mons = SubMonList} = State,
    length(SubMonList) >= MonNum;
% 伴生怪物血量状态
do_check_condition(State, {sub_mon_hp, all, MaxPer}) when is_record(State, ob_act) ->
    #ob_act{sub_mons = SubMonList} = State,
    F = fun({_MonId, _CfgId, BA}) ->
        #battle_attr{hp = Hp, hp_lim = HpLimit} = BA,
        round((Hp / HpLimit) * ?RATIO_COEFFICIENT) >= MaxPer
    end,
    lists:all(F, SubMonList);

do_check_condition(_State, _) ->
    false.

%% ====================
%% 判断是否继续追踪
is_continue_trace(TX, TY, SceneObject) when is_record(SceneObject, scene_object) ->
    case SceneObject of
        #scene_object{mon = #scene_mon{d_x = DX, d_y = DY}, tracing_distance = TracingDistance} ->
            IsContinueTrace = abs(DX-TX) =< TracingDistance andalso abs(DY-TY) =< TracingDistance;
        _ ->
            IsContinueTrace = true
    end,
    IsContinueTrace.

