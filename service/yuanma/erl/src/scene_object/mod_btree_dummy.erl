%% ---------------------------------------------------------------------------
%% @doc mod_btree_dummy

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/30
%% @deprecated  行为树 假人进程
%% ---------------------------------------------------------------------------
-module(mod_btree_dummy).

-behaviour(gen_statem).

-export([
    init/1,
    terminate/3,
    code_change/4,
    callback_mode/0
]).

-export([start/1]).

%% 怪物状态
-export([
    idle/3, behavior/3, dead/3, thorough_sleep/3
]).

-include("common.hrl").
-include("scene_object_btree.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("figure.hrl").

-define(BEHAVIOR_KEY, '$behavior_dummy').

start(Args) ->
    gen_statem:start_link(?MODULE, Args, []).

init(Args) ->
    [Id, _ConfigId, Scene, ScenePoolId, Xpx, Ypx, Type, CopyId, BroadCast, Arg] = Args,
    Dummy  = #scene_object{
        sign=?BATTLE_SIGN_DUMMY, id=Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId,
        x=Xpx, y=Ypx, aid=self(), type=Type, warning_range = 1200
    },

    {State, _, _} = lib_scene_object:set_args(Arg, #ob_act{object = Dummy}, null, 0, []),
    lib_scene_object:insert(State#ob_act.object),
    case BroadCast of
        0 -> skip;
        _ -> lib_scene_object:broadcast_object(State#ob_act.object)
    end,
    TreeId = get_btree_id(Arg),
    init_behavior_tree(TreeId),
    {ok, idle, State}.

callback_mode() ->
    [state_functions, state_enter].

terminate(_Reason, _StateName, _State) ->
    behavior_stop_tick(),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

idle(enter, _StateName, State) ->
    {next_state, idle, State};
idle(info, 'find_target', State) ->
    {next_state, behavior, State};
idle(info, Msg, State) ->
    do_handle_info(Msg, idle, State);
idle(_EventType, _Msg, _State) ->
    keep_state_and_data.

behavior(enter, _StateName, State) ->
    self() ! tick,
    {next_state, behavior, State};
behavior(info, 'tick', State) ->
    {NewState, NewStateName} = behavior_tree_tick(State, behavior),
    {next_state, NewStateName, NewState};
behavior(info, Msg, State) ->
    do_handle_info(Msg, behavior, State);
behavior(_EventType, _Msg, _State) ->
    keep_state_and_data.

%% 彻底休眠状态，只接受死亡信息
thorough_sleep(enter, _StateName, State) ->
    behavior_suspended_tick(),
    {next_state, thorough_sleep, State};
thorough_sleep(info, dead, State) ->
    {next_state, dead, State};
thorough_sleep(_EventType, _Msg, _State) ->
    keep_state_and_data.

dead(enter, _StateName, State) ->
    behavior_suspended_tick(),
    #ob_act{object = SceneObject} = State,
    #ob_act{object = SceneObject, revive_time = ReTime} = State,
    if
        ReTime =< 0 ->
            lib_scene_object:stop(SceneObject, 1),
            {stop, normal, State};
        true ->
            erlang:send_after(ReTime, self(), 'do_revive'),
            {next_state, dead, State}
    end;
dead(info, 'do_revive', State) ->
    #ob_act{object = Minfo, born_handler = BornHandler} = State,
    #scene_object{battle_attr=BA} = Minfo,
    #battle_attr{hp_lim=HpLim} = BA,
    NewMinfo = Minfo#scene_object{battle_attr=BA#battle_attr{hp = HpLim}},
    case BornHandler of
        {BornM, BornF, BornA} ->
            case BornM:BornF(revive, NewMinfo, BornA) of
                NewMinfo2 when is_record(NewMinfo2, scene_object) -> ok;
                _ -> NewMinfo2 = NewMinfo
            end;
        _ ->
            NewMinfo2 = NewMinfo
    end,
    lib_scene_object:update(NewMinfo2, [{hp, HpLim}]),
    lib_scene_object:broadcast_object(NewMinfo2),
    {next_state, behavior, State#ob_act{object = NewMinfo2}};
dead(_EventType, _Msg, _State) ->
    keep_state_and_data.

%% =========================== Inner Func ===========================

%% find_target返回
do_handle_info({'get_for_trace', _} = Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);
%% trace/attack返回
do_handle_info({'trace_info_back', _} = Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);
%% attack/skill 返回
do_handle_info({'object_battle_back', _}= Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);

do_handle_info({'combo_battle_back', _}= Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);

do_handle_info({'object_assist_back', _}= Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);

do_handle_info({'combo_assist_back', _}= Msg, behavior, State) ->
    behavior_handle_info(State, behavior, Msg);

%% 副技能释放走通用逻辑
do_handle_info({'combo', Args}, behavior, State) ->
    NewState = lib_scene_object_ai:combo(Args, State),
    {next_state, behavior, NewState};

do_handle_info({sub_mon_born, {Id, CfgId, BA}}, behavior, State) ->
    #ob_act{sub_mons = SubMons} = State,
    NewSubMons = lists:keystore(Id, 1, SubMons, {Id, CfgId, BA}),
    NewState = State#ob_act{sub_mons = NewSubMons},
    {next_state, behavior, NewState};

do_handle_info({sub_mon_die, Id}, behavior, State) ->
    #ob_act{sub_mons = SubMons} = State,
    NewSubMons = lists:keydelete(Id, 1, SubMons),
    NewState = State#ob_act{sub_mons = NewSubMons},
    {next_state, behavior, NewState};

do_handle_info({'stop', Broadcast}, _StateName, State) ->
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, Broadcast),
    {stop, normal, State};

do_handle_info('die', _StateName, State) ->
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, 1),
    {stop, normal, State};

%% 反弹伤害.
%% 注意:不要进行赋值,目前只是用于计算伤害值
%% @BattleReturn #battle_return{hurt = AfReBAerHurt, sign = AerRetrunSign, atter = AerRetrunAtter}, 只有这三个字段有效
do_handle_info({'rebound_battle_info', BattleReturn}, behavior, State) ->
    do_handle_info({'battle_info', BattleReturn}, behavior, State);

%% 受到攻击
do_handle_info({'battle_info', BattleReturn}, StateName, State) ->
    #battle_return{
        hp = Hp,
        hurt = FullHurt,
        move_x = MoveX,
        move_y = MoveY,
        attr_buff_list = AttrBuffList,
        other_buff_list = OtherBuffList,
        atter = Atter,
        sign  = AtterSign  %% 1：怪物， 2：人
    } = BattleReturn,
    #ob_act{object = Object} = State,

    Hurt = min(FullHurt, Object#scene_object.battle_attr#battle_attr.hp),

    Object1 = Object#scene_object{
        battle_attr = Object#scene_object.battle_attr#battle_attr{hp=max(0,Hp), attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList},
        x = case MoveX == 0 of true -> Object#scene_object.x; false -> MoveX end,
        y = case MoveY == 0 of true -> Object#scene_object.y; false -> MoveY end
    },

    State1 = State#ob_act{object = Object1},
    lib_scene_object_event:be_hurted(Object1, Atter, AtterSign, Hurt),
    if
        Hp =< 0 ->
            lib_scene_object_event:be_killed(Object1, [], Atter, AtterSign),
            lib_mon_mod:die_handler(State, [], Atter, AtterSign),
            {next_state, dead, State1#ob_act{att=undefined}};
        true ->
            {next_state, StateName, State1}
    end;

%% 设置战斗状态
do_handle_info({'battle_attr', BA}, StateName, State) ->
    #ob_act{object=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA}}};

%% 设置buff
do_handle_info({'buff', AttrBuffL, OtherBuffL}, StateName, State) ->
    #ob_act{object=#scene_object{battle_attr=BA}=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL, other_buff_list=OtherBuffL}}}};

do_handle_info({'change_attr', KeyValues}, StateName, State) ->
    {NewState, NewStateName, UpList} = lib_scene_object:set_args(KeyValues, State, StateName, 1, []),
    lib_scene_object:update(NewState#ob_act.object, UpList),
    {next_state, NewStateName, NewState};

%% debuff伤害处理
do_handle_info({debuff_hurt, _EventId, _Hurt, NewHp}, StateName, State) ->
    #ob_act{object = Obj} = State,
    #scene_object{battle_attr = BA} = Obj,
    #battle_attr{hp = Hp} = BA,
    if
        Hp =/= NewHp ->
            BA1 = BA#battle_attr{hp = NewHp},
            Obj1 = Obj#scene_object{battle_attr = BA1},
            State1 = State#ob_act{object = Obj1},
            {next_state, StateName, State1};
        true ->
            {next_state, StateName, State}
    end;

do_handle_info('thorough_sleep', _StateName, State) ->
    {next_state, thorough_sleep, State};

do_handle_info(_Msg, _StateName, _State) ->
    keep_state_and_data.

%% 获取树ID
get_btree_id(Arg) ->
    case lists:keyfind(tree_id, 1, Arg) of
        {tree_id, TreeId} -> ok;
        _ -> TreeId = default_dummy
    end,
    TreeId.

%% 初始化
init_behavior_tree(TreeId) ->
    BTree = lib_object_btree:init_btree(TreeId),
    % TickRef = ?IF(IsTick, util:send_after(undefined, BTree#behavior_tree.tick_gap, self(), tick), undefined),
    put(?BEHAVIOR_KEY, {BTree, undefined}).

%% 触发tick
behavior_tree_tick(State, StateName) ->
    case get(?BEHAVIOR_KEY) of
        {Btree, TickRef} ->
            case lib_object_btree:tick_tree(State, StateName, Btree) of
                {NewState, NewStateName, NewBTree} ->
                    NextGapTime = NewBTree#behavior_tree.tick_gap;
                {NewState, NewStateName, NewBTree, NextGapTime} ->
                    ok
            end,
            %?PRINT("behavior_tree_tick StateName ~p NowTime ~p NextGapTime ~p ~n", [StateName, utime:longunixtime(), NextGapTime]),
            NewTickRef = util:send_after(TickRef, NextGapTime, self(), tick),
            put(?BEHAVIOR_KEY, {NewBTree, NewTickRef}),
            {NewState, NewStateName};
        _ ->
            {State, StateName}
    end.

%% 暂停tick
behavior_suspended_tick() ->
    case get(?BEHAVIOR_KEY) of
        {Btree, TickRef} ->
            util:cancel_timer(TickRef),
            put(?BEHAVIOR_KEY, {Btree, undefined});
        _ ->
            skip
    end.

%% 停止tick
behavior_stop_tick() ->
    case erase(?BEHAVIOR_KEY) of
        {_Btree, TickRef} ->
            util:cancel_timer(TickRef);
        _ ->
            skip
    end.

behavior_handle_info(State, StateName, InfoMsg) ->
    case get(?BEHAVIOR_KEY) of
        {Btree, TickRef} ->
            case lib_object_btree:handle_info(State, StateName, Btree, InfoMsg) of
                {NewState, NewStateName, NewBTree} ->
                    put(?BEHAVIOR_KEY, {NewBTree, TickRef});
                {NewState, NewStateName, NewBTree, NextTickTime} ->
                    %?PRINT("behavior_handle_info NewStateName ~p NowTime ~p NextTickTime ~p ~n", [NewStateName, utime:longunixtime(), NextTickTime]),
                    NewTickRef = util:send_after(TickRef, NextTickTime, self(), tick),
                    put(?BEHAVIOR_KEY, {NewBTree, NewTickRef})
            end,
            {next_state, NewStateName, NewState};
        _ ->
            keep_state_and_data
    end.
