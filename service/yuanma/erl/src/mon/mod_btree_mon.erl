%% ---------------------------------------------------------------------------
%% @doc mod_btree_mon

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/2/01
%% @deprecated  行为树 怪物活动状态
%% ---------------------------------------------------------------------------
-module(mod_btree_mon).

-behaviour(gen_statem).

-export([
    init/1,
    terminate/3,
    code_change/4,
    callback_mode/0,
    manual_tick/1
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

-define(BEHAVIOR_KEY, '$behavior_mon').

manual_tick(Aid) ->
    gen_statem:cast(Aid, 'manual_tick').

start(Args) ->
    gen_statem:start_link(?MODULE, Args, [{spawn_opt, [{fullsweep_after, 100}]}]).

init(Args) ->
    [_Id, _MonId, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, BroadCast, Arg, M] = Args,
    #mon{tree_id = TreeId} = M,
    %% 配置转换为内存数据
    Mon = lib_mon_util:base_to_cache([_Id, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, self()], M),
    %% 自定义创建参数初始化,这里会根据参数覆盖原来的属性根据
    {Mon1, InitState, _, _} = lib_mon_util:set_mon(Arg, Mon#scene_object{aid = self()},
        #ob_act{}, idle, ?BROADCAST_0, []),
    State = InitState#ob_act{object = Mon1, w_point = {Mon#scene_object.x, Mon#scene_object.y}, tree_id = TreeId},
    %% 在场景进程中保存怪物信息
    lib_scene_object:insert(Mon1),
    %% 广播怪物
    case BroadCast  of
        ?BROADCAST_0 -> skip;
        _ ->
            lib_scene_object:broadcast_object(Mon1)
    end,
    init_behavior_tree(TreeId),
    % 调试使用
    % ?PRINT("===========================mod_btree_mon Pid is ~p ===========================~n", [self()]),
    {ok, idle, State}.
    % {ok, idle, State}.

callback_mode() ->
    [state_functions, state_enter].

terminate(_Reason, _StateName, _State) ->
    behavior_stop_tick(),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% 首次进入闲置状态，尝试开启行为
idle(enter, idle, State) ->
    try_behavior(State),
    {next_state, idle, State};
%% 行为状态 =》 闲置状态 || 一般是 back 行为节点导致
idle(enter, behavior, State) ->
    behavior_suspended_tick(),
    % try_behavior(State),
    {next_state, idle, State#ob_act{att = undefined}};
idle(info, 'try_behavior', State) ->
    {next_state, behavior, State};
idle(info, Msg, State) ->
    %?PRINT("idle info ~n", []),
    do_handle_info(Msg, idle, State);
idle(_EventType, _Msg, _State) ->
    keep_state_and_data.

behavior(enter, _StateName, State) ->
    self() ! tick,
    {next_state, behavior, State};
behavior(info, 'tick', State) ->
    %?PRINT("tick ~n", []),
    {NewState, NewStateName} = behavior_tree_tick(State, behavior),
    {next_state, NewStateName, NewState};
behavior(info, Msg, State) ->
    %?PRINT("behavior info ~p ~n", []),
    do_handle_info(Msg, behavior, State);
behavior(cast, 'manual_tick', State) ->
    {NewState, NewStateName} = behavior_tree_manual_tick(State, behavior),
    {next_state, NewStateName, NewState};
behavior(_EventType, _Msg, _State) ->
    keep_state_and_data.

%% 彻底休眠状态，只接受死亡信息
thorough_sleep(enter, _StateName, State) ->
    behavior_suspended_tick(),
    {next_state, thorough_sleep, State};
thorough_sleep(info, {'remove_thorough_sleep', NextStateName}, State) ->
    {next_state, NextStateName, State};
thorough_sleep(info, dead, State) ->
    {next_state, dead, State};
thorough_sleep(_EventType, _Msg, _State) ->
    keep_state_and_data.

dead(enter, _StateName, State) ->
    behavior_stop_tick(),
    #ob_act{object=SceneObject, bl_who_ref = BlWhosRef, bl_who = BlWhos, hurt_remove_ref = HurtRef, bl_who_assist = BlWhosAssist} = State,
    #scene_object{
        id=ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My,
        mon=#scene_mon{boss = Boss, retime = ReTime}
    } = SceneObject,
    case ?IS_DROP_BOSS(Boss) of
        false -> skip;
        true ->
            util:cancel_timer(HurtRef),
            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, [], BlWhos),
            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, [], BlWhosAssist),
            [util:cancel_timer(BlWhoRef)|| {_RId, BlWhoRef} <- BlWhosRef]
    end,
    if
        ReTime =< 0 ->
            lib_scene_object:stop(SceneObject, 1),
            {stop, normal, State};
        true ->
            erlang:send_after(ReTime, self(), 'do_revive'),
            {next_state, dead, State#ob_act{back_dest_path=null}}
    end;
dead(info, 'do_revive', State) ->
    #ob_act{object = Minfo, tree_id = TreeId} = State,
    #scene_object{mon=Mon, battle_attr=BA} = Minfo,
    #battle_attr{hp_lim=OHpLim, attr = Attr} = BA,
    %% 普通野外怪热更新经验/血量临时代码
    HpLim = case data_mon:get(Mon#scene_mon.mid) of
                #mon{hp_lim=CFGHpLim, boss=?MON_NORMAL_OUSIDE} -> CFGHpLim;
                _ -> OHpLim
            end,
    NewMinfo = Minfo#scene_object{battle_attr=BA#battle_attr{hp = HpLim, hp_lim = HpLim, attr = Attr#attr{hp = HpLim}}, x = Mon#scene_mon.d_x, y = Mon#scene_mon.d_y},
    lib_scene_object:update(NewMinfo, [{hp_lim, HpLim}, {hp, HpLim}, {xy, Mon#scene_mon.d_x, Mon#scene_mon.d_y}]),
    lib_scene_object:broadcast_object(NewMinfo),
    NewState = State#ob_act{att = undefined, object = NewMinfo, klist = [], first_att = [], clist = [], ref = [], assist_list = []},
    lib_mon_mod:revive_handler(NewState),
    init_behavior_tree(TreeId),
    case lib_mon_util:is_active_mon(Minfo) of
        true  ->
            {next_state, behavior, NewState};
        false ->
            {next_state, idle, NewState}
    end;
dead(info, Msg, State) ->
    do_handle_info(Msg, dead, State);
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

do_handle_info('die', _StateName, State) ->
    lib_scene_object:stop(State#ob_act.object, 1),
    lib_mon_event:be_die(State#ob_act.object),
    {stop, normal, State};

%% 反弹伤害.
%% 注意:不要进行赋值,目前只是用于计算伤害值
%% @BattleReturn #battle_return{hurt = AfReBAerHurt, sign = AerRetrunSign, atter = AerRetrunAtter}, 只有这三个字段有效
do_handle_info({'rebound_battle_info', BattleReturn}, StateName, State) ->
    do_handle_info({'battle_info', BattleReturn}, StateName, State);

%% 受到攻击
do_handle_info({'battle_info', BattleReturn}, StateName, State) ->
    #battle_return{
        hp = Hp,
        attr_buff_list = AttrBuffList,
        other_buff_list = OtherBuffList,
        atter = Atter,
        sign  = AttackerSign  %% 1：怪物， 2：人 其他
    } = BattleReturn,
    #ob_act{object = SceneObject, klist = OldKList, hurt_remove_ref = HurtRemoveRef} = State,
    #scene_object{battle_attr = BA} = SceneObject,
    % 伤害计算
    {FullHurt, Hurt} = calc_hurt(BattleReturn, SceneObject),
    % 获取攻击者信息
    {MonAttacker, NewFirstAttr, NewKList} = calc_attack_info(State, BattleReturn, FullHurt, Hurt),
    % 计算伤害移除定时器
    NewHurtRemoveRef = calc_hurt_remove_ref(SceneObject, AttackerSign, HurtRemoveRef, FullHurt),
    % 计算归属相关
    {NewBLWhos, NewBlWhosAssist} = calc_bl_who_and_assist(State, SceneObject, AttackerSign, FullHurt, NewKList, NewFirstAttr),
    NewHpChangeHandler = lib_mon_mod:hp_change_handler(State, Hp, NewKList),
    % 更新怪物的Hp, Buff相关
    NewSceneObject = SceneObject#scene_object{
        battle_attr = BA#battle_attr{hp=max(0,Hp), attr_buff_list = AttrBuffList, other_buff_list = OtherBuffList}
    },
    lib_mon_event:be_hurted(NewSceneObject, SceneObject, Atter, MonAttacker, AttackerSign, Hurt, NewKList, OldKList),
    lib_mon_event:hp_change(NewSceneObject, SceneObject, NewKList),
    AfHurtState = State#ob_act{
        object = NewSceneObject, bl_who = NewBLWhos, hp_change_handler = NewHpChangeHandler,
        first_att = NewFirstAttr,  klist = NewKList, hurt_remove_ref = NewHurtRemoveRef, bl_who_assist = NewBlWhosAssist
    },
    if
        Hp =< 0 -> %% 死亡掉落，功能杀怪物处理
            battle_die_event(AfHurtState, BattleReturn),
            {next_state, dead, AfHurtState};
        % 闲置状态被攻击 => 执行行为
        StateName == idle ->
            #mon_atter{id = AttId} = MonAttacker,
            LastState = AfHurtState#ob_act{att = #{id => AttId, sign => AttackerSign}},
            {next_state, behavior, LastState};
        true ->
            %% TODO 处理成触发怪物行为
            behavior_handle_info(AfHurtState#ob_act{object = NewSceneObject}, StateName, {'battle_info', MonAttacker})
    end;

%% 修改怪物属性
do_handle_info({'change_attr', KeyValues}, StateName, State) ->
    {Object, NewState, NewStateName, UpList} = lib_mon_util:set_mon(KeyValues, State#ob_act.object, State, StateName, 1, []),
    lib_scene_object:update(Object, UpList),
    lib_scene_object:change_attr_broadcast(UpList, Object, []),
    {next_state, NewStateName, NewState#ob_act{object=Object}};

do_handle_info({'ripple', Id, Pid, Sign, X, Y, Group}, StateName, State) ->
    #ob_act{att=Att, object=#scene_object{id=_ObjId, x=_ObjX, y=_ObjY, aid=_Aid, battle_attr = #battle_attr{group = MGroup}, mon = Mon} } = State,
    case Att of
        % 不攻击人的怪物,不会选择玩家攻击
        _ when Mon#scene_mon.kind == ?MON_KIND_ATT_NOT_PLAYER andalso Sign == ?BATTLE_SIGN_PLAYER ->
            keep_state_and_data;
        undefined when MGroup =/= Group, StateName == idle -> %% 新目标
            NewAtt = #{id=>Id, pid=>Pid, sign=>Sign, x=>X, y=>Y},
            {next_state, behavior, State#ob_act{att=NewAtt}};
        _ -> %% 其他目标
            keep_state_and_data
    end;

%% 触发怪物AI
%% Type: 1怪物, 2玩家
do_handle_info({'ai', MoveMsg}, StateName, State) ->
    #move_transport_to_mon{
        ob_id = RoleId,
        ob_pid = RolePid,
        target_x = TX,
        target_y = TY,
        sign = Sign,
        team_id = TeamId,
        group_id = RoleGroupId,
        guild_id = RoleGuildId
    } = MoveMsg,
    #ob_act{object=Minfo, bl_who = BLWhos, bl_who_ref = OldBLWhosRef} = State,
    #scene_object{mon = Mon, d_x = Dx, d_y = Dy, tracing_distance = TraceDistance, aid = Aid , battle_attr = BA, figure = Figure} = Minfo,
    #battle_attr{group = MonGroup} = BA,
    #figure{guild_id = MonGuildId, lv = MonLv} = Figure,
    case lib_mon_util:is_active_mon(Minfo) of
        true ->
            %% 是不是显示掉落boss
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            %% 是否需要队伍的boss归属
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, MonLv),
            if
                BLWhos == [] orelse not DropBoss -> skip;
                true -> lib_mon_util:check_sync_team_boss_bl_whos(BlType, RoleId, TeamId, BLWhos, Minfo)
            end,
            if
                StateName == idle ->
                    case is_continue_trace_with_check(Dx, Dy, TX, TY, TraceDistance, MonGroup, MonGuildId, RoleGroupId, RoleGuildId) of
                        false ->
                            keep_state_and_data;
                        true ->
                            {next_state, behavior, State#ob_act{att=#{id=>RoleId, sign=>Sign, pid=>RolePid, x=>TX, y=>TY}}}
                    end;
                BLWhos == [] orelse not DropBoss ->
                    keep_state_and_data;
                true ->
                    case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false -> keep_state_and_data;
                        _ ->
                            case is_continue_trace_with_check(Dx, Dy, TX, TY, TraceDistance, MonGroup, MonGuildId, RoleGroupId, RoleGuildId) of %% 追踪范围
                                false ->
                                    case lists:keyfind(RoleId, 1, OldBLWhosRef) of
                                        false ->
                                            BlWhoRef = erlang:send_after(5000, Aid, {'remove_bl_who', RoleId}),
                                            {next_state, StateName, State#ob_act{bl_who_ref = [{RoleId, BlWhoRef}|OldBLWhosRef]}};
                                        {RoleId, OBlWhoRef} ->
                                            case erlang:is_reference(OBlWhoRef) of
                                                true -> {next_state, StateName, State};
                                                false ->
                                                    BlWhoRef = erlang:send_after(5000, Aid, {'remove_bl_who', RoleId}),
                                                    NewBLWhosRef = [{RoleId, BlWhoRef}|lists:keydelete(RoleId, 1, OldBLWhosRef)],
                                                    {next_state, StateName, State#ob_act{bl_who_ref = NewBLWhosRef}}
                                            end
                                    end;
                                true ->
                                    case lists:keyfind(RoleId, 1, OldBLWhosRef) of
                                        false ->
                                            keep_state_and_data;
                                        {RoleId, OBlWhoRef} ->
                                            util:cancel_timer(OBlWhoRef),
                                            NewBLWhosRef = lists:keydelete(RoleId, 1, OldBLWhosRef),
                                            {next_state, StateName, State#ob_act{bl_who_ref = NewBLWhosRef}}
                                    end
                            end
                    end
            end;
        false ->
            keep_state_and_data
    end;

%% 设置战斗状态
do_handle_info({'battle_attr', BA}, StateName, State) ->
    #ob_act{object=Minfo} = State,
    {next_state, StateName, State#ob_act{object=Minfo#scene_object{battle_attr=BA}}};

%% 设置buff
do_handle_info({'buff', AttrBuffL, OtherBuffL}, StateName, State) ->
    #ob_act{object=#scene_object{battle_attr=BA}=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL, other_buff_list=OtherBuffL}}}};

%% 清理怪物
do_handle_info({'stop', Broadcast}, StateName, State) ->
    #ob_act{object = Object} = State,
    #scene_object{scene = Scene} = Object,
    IsForbidStopScene = lib_mon_util:is_forbid_stop_scene(Scene),
    if
        IsForbidStopScene  ->
            {next_state, StateName, State};
        true ->
            lib_scene_object:stop(State#ob_act.object, Broadcast),
            lib_mon_event:be_stop(State#ob_act.object),
            {stop, normal, State}
    end;

%% 定时请求移除玩家伤害列表
%% hurt_remove_ref 定时器触发,攻击的时候出发定时器
do_handle_info({'hurt_remove'}, StateName, State) ->
    #ob_act{object=Object, bl_who = BLWhos, hurt_remove_ref = HurtRemoveRef} = State,
    util:cancel_timer(HurtRemoveRef),
    #scene_object{aid = Pid, d_x = DX, d_y = DY, x = X, y = Y, scene = Scene, scene_pool_id = PoolId,
        copy_id = CopyId, tracing_distance = TracingDistance} = Object,
    mod_scene_agent:apply_cast(Scene, PoolId, lib_scene_agent, get_scene_boss_hurt_user, [Pid, Scene, CopyId, DX, DY, X, Y, TracingDistance]),
    if
        StateName == idle ->
            if
                BLWhos == [] -> NewHurtRemoveRef = [];
                true -> NewHurtRemoveRef = erlang:send_after(5000, Pid, {'hurt_remove'})
            end,
            {next_state, StateName, State#ob_act{hurt_remove_ref = NewHurtRemoveRef}};
        true ->
            NewHurtRemoveRef = erlang:send_after(5000, Pid, {'hurt_remove'}),
            {next_state, StateName, State#ob_act{hurt_remove_ref = NewHurtRemoveRef}}
    end;

%% 接受移除玩家列表
%% @param UsersIds 有伤害的玩家id列表
do_handle_info({'hurt_remove', UsersIds}, StateName, State) ->
    #ob_act{
        klist = Klist, bl_who = BLWhos, object = Object, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y} = Object,
    NewKList = [P || P <- Klist, lists:member(P#mon_atter.id, UsersIds)],
    DelUsersIds = [P#mon_atter.id || P <- Klist, not lists:member(P#mon_atter.id, UsersIds)],
    lib_mon_event:hurt_remove(Object, Klist, NewKList, DelUsersIds),
    %% 首次攻击
    {NewFirstAttr, DelRoleId} =
        case FirstAttr of
            [] -> {[], 0};
            _ -> ?IF(lists:member(FirstAttr#mon_atter.id, UsersIds), {FirstAttr, 0}, {[], FirstAttr#mon_atter.id})
        end,
    %% 重新计算Boss归属
    BlType = lib_mon_util:get_boss_drop_bltype(Object#scene_object.mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Object#scene_object.mon#scene_mon.mid, BlType, BLWhos, NewKList, NewFirstAttr, AssistDataList),
    NewDels =
        case lists:keyfind(DelRoleId, #mon_atter.id, BLWhos) of
            false -> Dels;
            E ->
                case lists:keymember(DelRoleId, #mon_atter.id, Dels) of
                    true -> Dels;
                    false -> [E|Dels]
                end
        end,
    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, X, Y, Adds, NewDels),
    %% 重新计算归属者的协助列表
    {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, X, Y, AddsAssist, DelsAssist),
    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
    if
        % 闲置状态且没有归属,则快速进入睡眠
        StateName == idle andalso BLWhos =/= [] andalso NewBLWhos == [] ->
            {next_state, StateName, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        % 闲置状态切有归属寻找目标
        StateName == idle andalso NewBLWhos =/= [] ->
            {next_state, behavior, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        BLWhos == [] ->
            {next_state, StateName, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        true ->
            {next_state, StateName, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}}
    end;

%% 离开或者加入队伍操作
do_handle_info({'team_flag', RoleId, TeamId}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case lib_mon_util:is_active_mon(Object) of
        true ->
            NewKList = case lists:keyfind(RoleId, #mon_atter.id, KList) of
                false -> KList;
                P ->
                    NP = P#mon_atter{team_id = TeamId},
                    lists:keystore(RoleId, #mon_atter.id, KList, NP)
            end,
            NewFirstAttr = case FirstAttr of
                [] -> [];
                _ -> ?IF(FirstAttr#mon_atter.id == RoleId, FirstAttr#mon_atter{team_id = TeamId}, FirstAttr)
            end,
            NewAssistDataList = [begin
                ?IF(MonAtter#mon_atter.id == RoleId, AD#assist_data{mon_atter = MonAtter#mon_atter{team_id = TeamId}}, AD)
            end ||#assist_data{mon_atter = MonAtter}=AD <- AssistDataList],
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            if
                not DropBoss orelse BLWhos == []->
                    {next_state, StateName, State#ob_act{klist = NewKList, first_att = NewFirstAttr, assist_list = NewAssistDataList}};
                true ->
                    %% 重新计算Boss归属
                    BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, BLWhos, NewKList, FirstAttr, NewAssistDataList),
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, Dels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, NewAssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                    NewState = State#ob_act{
                        bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, assist_list = NewAssistDataList,
                        bl_who_assist = NewBlWhosAssist},
                    {next_state, StateName, NewState}
            end;
        false ->
            keep_state_and_data
    end;

%% 增加队伍的攻击列表
do_handle_info({'add_team_mon_atter_list', MonAtterL}, StateName, State) ->
    #ob_act{
        object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr, bl_who_ref = BlWhoRefL,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, aid = Aid, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case lib_mon_util:is_active_mon(Object) of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            if
                BLWhos == [] orelse not DropBoss -> keep_state_and_data;
                true ->
                    case BLWhos of
                        [#mon_atter{team_id = TeamId}|_] ->
                            % 归属列表不存在,并且是同队伍
                            NewMonAtterL = [MonAtter#mon_atter{assist_ex_id = lib_mon_util:get_assist_ex_id(AssistId, AssistDataList)}
                                ||#mon_atter{id = RoleId, team_id = TmpTeamId, assist_id = AssistId}=MonAtter<-MonAtterL,
                                lists:keymember(RoleId, #mon_atter.id, BLWhos) == false andalso TmpTeamId == TeamId];
                        _ ->
                            NewMonAtterL = []
                    end,
                    case NewMonAtterL == [] of
                        true -> {next_state, StateName, State};
                        false ->
                            F = fun(#mon_atter{id = RoleId} = MonAtter, {TmpKList, TmpBlWhoRefL}) ->
                                NewTmpKList = lib_mon_util:add_hatred_list(TmpKList, MonAtter, 0),
                                NewTmpBlWhoRefL =
                                    case lists:keyfind(RoleId, 1, TmpBlWhoRefL) of
                                        false ->
                                            BlWhoRef = erlang:send_after(5000, Aid, {'remove_bl_who', RoleId}),
                                            [{RoleId, BlWhoRef}|TmpBlWhoRefL];
                                        {RoleId, OBlWhoRef} ->
                                            case erlang:is_reference(OBlWhoRef) of
                                                true -> TmpBlWhoRefL;
                                                false ->
                                                    BlWhoRef = erlang:send_after(5000, Aid, {'remove_bl_who', RoleId}),
                                                    [{RoleId, BlWhoRef}|lists:keydelete(RoleId, 1, TmpBlWhoRefL)]
                                            end
                                    end,
                                {NewTmpKList, NewTmpBlWhoRefL}
                                end,
                            {NewKList, NewBlWhoRefL} = lists:foldl(F, {KList, BlWhoRefL}, NewMonAtterL),
                            %% 重新计算Boss归属
                            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                            {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, BLWhos, NewKList, FirstAttr, AssistDataList),
                            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, Dels),
                            {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                            {next_state, StateName, State#ob_act{bl_who = NewBLWhos, klist = NewKList, bl_who_ref = NewBlWhoRefL, bl_who_assist = NewBlWhosAssist}}
                    end
            end;
        false ->
            keep_state_and_data
    end;

%% 玩家第一次进入场景
do_handle_info({'enter', RoleId, _RolePid, _Sign, TeamId}, StateName, State) ->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_die_ref = BlWhoDieRefL} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case lib_mon_util:is_active_mon(Object) of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            case lists:keyfind(RoleId, 1, BlWhoDieRefL) of
                false -> NewBlWhoDieRefL = BlWhoDieRefL;
                {RoleId, DieRef} ->
                    util:cancel_timer(DieRef),
                    NewBlWhoDieRefL = lists:keydelete(RoleId, 1, BlWhoDieRefL)
            end,
            NewState = State#ob_act{bl_who_die_ref = NewBlWhoDieRefL},
            if
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, NewState};
                true ->
                    case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false ->
                            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                            lib_mon_util:check_sync_team_boss_bl_whos(BlType, RoleId, TeamId, BLWhos, Object);
                        MonAtter ->
                            {ok, Bin} = pt_120:write(12022, [RoleId, 1]),
                            lib_battle:rpc_cast_to_node(MonAtter#mon_atter.node, lib_server_send, send_to_uid, [RoleId, Bin]),
                            lib_server_send:send_to_area_scene(Scene, PoolId, CopyId, Mx, My, Bin),
                            mod_scene_agent:update(Scene, PoolId, RoleId, [{bl_who, 1}, {bl_who_op, {ObjectId, 1}}])
                    end,
                    {next_state, StateName, NewState}
            end;
        false ->
            keep_state_and_data
    end;

%% 玩家离开场景(复活，切场景之类)
do_handle_info({'leave', RoleId, _RolePid, _Sign}, StateName, State) ->
    #ob_act{
        object=Object, bl_who = BLWhos, bl_who_ref = BLWhosRef, bl_who_die_ref = BlWhoDieRefL, klist = KList,
        first_att = FirstAttr, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case lib_mon_util:is_active_mon(Object) of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            case lists:keyfind(RoleId, 1, BlWhoDieRefL) of
                false -> NewBlWhoDieRefL = BlWhoDieRefL;
                {RoleId, DieRef} ->
                    util:cancel_timer(DieRef),
                    NewBlWhoDieRefL = lists:keydelete(RoleId, 1, BlWhoDieRefL)
            end,
            if
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, State#ob_act{bl_who_die_ref = NewBlWhoDieRefL}};
                true ->
                    NewKList = lists:keydelete(RoleId, #mon_atter.id, KList),
                    lib_mon_event:hurt_remove(Object, KList, NewKList, [RoleId]),
                    NewFirstAttr = case FirstAttr of
                        [] -> [];
                        _ -> ?IF(FirstAttr#mon_atter.id == RoleId, [], FirstAttr)
                    end,
                    OldBlWhos = case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false -> BLWhos;
                        _ -> lists:keydelete(RoleId, #mon_atter.id, BLWhos)
                    end,
                    NewBLWhosRef = case lists:keyfind(RoleId, 1, BLWhosRef) of
                        false -> BLWhosRef;
                        {RoleId, BlWhoRef} ->
                            util:cancel_timer(BlWhoRef),
                            lists:keydelete(RoleId, 1, BLWhosRef)
                    end,
                    %% 重新计算Boss归属
                    BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBlWhos, NewKList, NewFirstAttr, AssistDataList),
                    NewDels = case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of false -> Dels; E -> [E|Dels] end,
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, NewDels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} =
                        lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                    {next_state, StateName, State#ob_act{bl_who_ref = NewBLWhosRef, bl_who_die_ref = NewBlWhoDieRefL,
                        bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist}}
            end;
        false ->
            keep_state_and_data
    end;

%% 玩家死亡
do_handle_info({'player_die', RoleId, MonAtter, SceneBossTired, VipType, VipLv, IsHurtMon}, StateName, State) ->
    #ob_act{assist_list = AssistDataList} = State,
    NewMonAtter = ?IF(is_record(MonAtter, mon_atter),
        MonAtter#mon_atter{assist_ex_id = lib_mon_util:get_assist_ex_id(MonAtter#mon_atter.assist_id, AssistDataList)},
        MonAtter),
    case lib_mon_mod:player_die(State, StateName, RoleId, NewMonAtter, SceneBossTired, VipType, VipLv, IsHurtMon) of
        {next_state, sleep, State} ->
            {next_state, idle, State};
        Result ->
            Result
    end;

%% 归属玩家死亡定时器
do_handle_info({'bl_who_die_ref', RoleId}, StateName, State) ->
    lib_mon_mod:bl_who_die_ref(State, StateName, RoleId);

%% 抢夺归属权
do_handle_info({'rob_mon_bl', Node, RoleId}, StateName, State) ->
    lib_mon_mod:rob_mon_bl(State, StateName, Node, RoleId);

%% 抢夺归属权
do_handle_info({'rob_mon_bl_success', MonAtter, RobbedId, WinCode, WinHp}, StateName, State) ->
    case lib_mon_mod:rob_mon_bl_success(State, StateName, MonAtter, RobbedId, WinCode, WinHp)  of
        {next_state, sleep, State} ->
            {next_state, idle, State};
        Result ->
            Result
    end;

%% 移除玩家的boss归属
%% bl_who_ref 定时器触发,追踪范围,清理不在本场景的玩家
do_handle_info({'remove_bl_who', RoleId}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_ref = OBLWhosRef} = State,
    #scene_object{ scene = Scene, scene_pool_id = PoolId, aid = Aid, copy_id = _CopyId,
        d_x = Dx, d_y = Dy, x = X, y = Y, mon = Mon, tracing_distance = TracingDistance} = Object,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        BLWhos == [] orelse not DropBoss -> keep_state_and_data;
        true ->
            case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                false ->
                    {next_state, StateName, State#ob_act{bl_who_ref = lists:keydelete(RoleId, 1, OBLWhosRef)}};
                _ ->
                    case lists:keyfind(RoleId, 1, OBLWhosRef) of
                        false ->
                            keep_state_and_data;
                        {RoleId, BLWhoRef} ->
                            util:cancel_timer(BLWhoRef),
                            mod_scene_agent:apply_cast(Scene, PoolId, lib_scene_agent,
                                get_boss_bl_who_users, [Aid, Dx, Dy, X, Y, TracingDistance, RoleId]),
                            {next_state, StateName, State#ob_act{bl_who_ref = lists:keydelete(RoleId, 1, OBLWhosRef)}}
                    end
            end
    end;

%% 移除玩家的boss归属
do_handle_info({'get_boss_bl_who_users', RoleId, User}, StateName, State)->
    #ob_act{
        object=Object, bl_who = BLWhos, klist = KList, bl_who_ref = BLWhosRef, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My, mon = Mon} = Object,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        BLWhos == [] orelse not DropBoss-> keep_state_and_data;
        true ->
            case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                false -> {next_state, StateName, State};
                E ->
                    if
                        User =/= [] -> keep_state_and_data; %% 归属者还存在
                        true ->
                            NewKList = lists:keydelete(RoleId, #mon_atter.id, KList),
                            lib_mon_event:hurt_remove(Object, KList, NewKList, [RoleId]),
                            NewFirstAttr = case FirstAttr of
                                [] -> [];
                                _ -> ?IF(FirstAttr#mon_atter.id == RoleId, [], FirstAttr)
                            end,
                            OldBlWhos = lists:keydelete(RoleId, #mon_atter.id, BLWhos),
                            NewBLWhosRef = case lists:keyfind(RoleId, 1, BLWhosRef) of
                                false -> BLWhosRef;
                                {RoleId, BlWhoRef} ->
                                    util:cancel_timer(BlWhoRef),
                                    lists:keydelete(RoleId, 1, BLWhosRef)
                            end,
                            %% 重新计算Boss归属
                            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                            {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBlWhos, NewKList, NewFirstAttr, AssistDataList),
                            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, [E|Dels]),
                            {AddsAssist, DelsAssist, NewBlWhosAssist} =
                                lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                            lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                            {next_state, StateName, State#ob_act{bl_who_ref = NewBLWhosRef,
                                bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist}}
                    end
            end
    end;

do_handle_info({'send_mon_own_info', Node, Sid}, _StateName, State) ->
    Info = lib_mon_mod:get_mon_own_info(State),
    {ok, BinData} = pt_200:write(20021, Info),
    lib_server_send:send_to_uid(Node, Sid, BinData),
    keep_state_and_data;

do_handle_info({'send_hurt_info', Node, RoleId}, _StateName, State) ->
    #ob_act{klist = Klist, object=Object} = State,
    #scene_object{id = Id, config_id = ConfigId, scene = SceneId} = Object,
    NeedWrapName = lib_player:is_need_wrap_name_scene(SceneId),
    F = fun(#mon_atter{id = TmpRoleId, name = Name, server_id = ServerId, server_num = ServerNum, server_name = ServerName, team_id = TeamId, hurt = Hurt, mask_id = MaskId, assist_id = AssistId}, List) ->
        case Hurt =/= 0 of
            true ->
                WrapName = ?IF(NeedWrapName == true, lib_player:get_wrap_role_name(Name, [MaskId]), Name),
                [{TmpRoleId, WrapName, ServerId, ServerNum, ServerName, TeamId, 0, Hurt, AssistId}|List]; % 队伍职位暂定为0
            false -> List
        end
        end,
    List = lists:reverse(lists:foldl(F, [], Klist)),
    {ok, BinData} = pt_120:write(12025, [Id, ConfigId, List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    keep_state_and_data;

%% debuff伤害处理
%% todo:没有引进伤害人，没有添加伤害列表，原本只改变了血量变化，现在加上血量变化ai
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
            keep_state_and_data
    end;

%% 协助id变化
do_handle_info({'assist_change', AssistId, RoleIdList}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case lib_mon_util:is_active_mon(Object) of
        true ->
            AssistExId = lib_mon_util:get_assist_ex_id(AssistId, AssistDataList),
            F = fun({RoleId, BlState}, {IsChange, L, L1, L2}) ->
                case lists:keyfind(RoleId, #mon_atter.id, L) of
                    #mon_atter{assist_id = OAssistId} = P when OAssistId =/= AssistId ->
                        case AssistId == 0 andalso BlState == false of
                            true ->
                                NL = lists:keydelete(RoleId, #mon_atter.id, L),
                                {true, NL, [RoleId|L1], L2};
                            _ ->
                                NP = P#mon_atter{assist_id = AssistId, assist_ex_id = AssistExId},
                                NL = lists:keystore(RoleId, #mon_atter.id, L, NP),
                                {true, NL, L1, [{RoleId, AssistId}|L2]}
                        end;
                    _ -> {IsChange, L, L1, L2}
                end
            end,
            {IsChange, NewKList, DelUsersIds, ChangeIds} = lists:foldl(F, {false, KList, [], []}, RoleIdList),
            %?PRINT("assist_change {IsChange, DelUsersIds, ChangeIds}:~p~n", [{IsChange, DelUsersIds, ChangeIds}]),
            case IsChange of
                true ->
                    lib_mon_event:hurt_remove(Object, KList, NewKList, DelUsersIds),
                    lib_mon_event:assist_change(Object, ChangeIds),
                    NewFirstAttr = case FirstAttr of
                        [] -> [];
                        _ ->
                            case lists:keyfind(FirstAttr#mon_atter.id, 1, RoleIdList) of
                                {_, BlState} when BlState == false -> %% 玩家已经没有boss的归属权
                                    [];
                                {_, _BlState} ->
                                    FirstAttr#mon_atter{assist_id = AssistId, assist_ex_id = AssistExId};
                                _ -> FirstAttr
                            end
                    end,
                    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
                    if
                        not DropBoss orelse BLWhos == []->
                            {next_state, StateName, State#ob_act{klist = NewKList, first_att = NewFirstAttr}};
                        true ->
                            %% 重新计算Boss归属
                            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
                            {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, BLWhos, NewKList, NewFirstAttr, AssistDataList),
                            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, Dels),
                            {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                            lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                            NewState = State#ob_act{
                                bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist},
                            {next_state, StateName, NewState}
                    end;
                _ ->
                    keep_state_and_data
            end;
        false ->
            keep_state_and_data
    end;

do_handle_info({'send_assist_data_list', Node, Sid}, StateName, State) ->
    #ob_act{object=Object, assist_list = AssistDataList} = State,
    #scene_object{id = Id, config_id = ConfigId} = Object,
    F = fun(#assist_data{assist_id = AssistId, mon_atter = MonAtter}, Acc) ->
        #mon_atter{id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, server_name = ServerName} = MonAtter,
        [{AssistId, RoleId, Name, ServerId, ServerNum, ServerName}|Acc]
        end,
    List = lists:foldl(F, [], AssistDataList),
    {ok, BinData} = pt_120:write(12043, [Id, ConfigId, List]),
    lib_server_send:send_to_sid(Node, Sid, BinData),
    {next_state, StateName, State};

%% 移除彻底休眠状态
do_handle_info({'remove_thorough_sleep', NextStateName}, _StateName, State) ->
    {next_state, NextStateName, State};

do_handle_info(dead, _StateName, State) ->
    {next_state, dead, State};

do_handle_info(_Msg, _StateName, _State) ->
    keep_state_and_data.

% 计算 FullHurt 与 Hurt
calc_hurt(BattleReturn, SceneObject) ->
    #battle_return{ hurt = OldFullHurt, real_hurt = RealHurt } = BattleReturn,
    case data_scene:get(SceneObject#scene_object.scene) of
        #ets_scene{type = SceneType} when
            SceneType == ?SCENE_TYPE_TERRITORY orelse SceneType == ?SCENE_TYPE_KF_SANCTUARY
                orelse ?SCENE_TYPE_NEW_OUTSIDE_BOSS orelse SceneType == ?SCENE_TYPE_SPECIAL_BOSS->
            FullHurt = RealHurt,
            Hurt = RealHurt;
        % 最后伤害等于血量
        _ ->
            FullHurt = OldFullHurt,
            Hurt = min(FullHurt, SceneObject#scene_object.battle_attr#battle_attr.hp)
    end,
    {FullHurt, Hurt}.

%% 计算攻击者相关
%% {攻击者信息， 首次攻击者， 伤害列表}
calc_attack_info(State, BattleReturn, FullHurt, Hurt) ->
    #battle_return{atter = Attacker, sign = ASign} = BattleReturn,
    #ob_act{ first_att = FirstAttr, assist_list = AssistDataList, klist = KList } = State,
    #battle_return_atter{
        id = AId, pid = APid, node = ANode, server_id = ServerId, camp_id = Camp, team_id = TeamId,
        lv = ALv, real_name = RealName, server_num = ServerNum, world_lv = WorldLv, server_name = ServerName,
        mod_level = ModLevel, mask_id = MaskId, assist_id = AssistId
    } = Attacker,
    MonAttacker = #mon_atter{
        id = AId, pid = APid, node = ANode, server_id = ServerId, team_id = TeamId, att_sign = ASign, att_lv = ALv,
        name = RealName, server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel,
        camp_id = Camp, mask_id = MaskId, assist_id = AssistId, assist_ex_id = lib_mon_util:get_assist_ex_id(AssistId, AssistDataList)
    },
    NewFirstAttr = ?IF(FirstAttr == [] andalso FullHurt /= 0, MonAttacker, FirstAttr),
    NewKList = ?IF(ASign == ?BATTLE_SIGN_PLAYER andalso FullHurt /= 0, lib_mon_util:add_hatred_list(KList, MonAttacker, Hurt), KList),
    {MonAttacker, NewFirstAttr, NewKList}.

calc_hurt_remove_ref(SceneObject, AttackerSign, HurtRemoveRef, FullHurt) ->
    #scene_object{mon = Mon} = SceneObject,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        not DropBoss orelse AttackerSign == ?BATTLE_SIGN_MON orelse FullHurt == 0 -> HurtRemoveRef;
        HurtRemoveRef == [] ->
            case lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, SceneObject#scene_object.figure#figure.lv) of
                skip -> [];
                _ -> erlang:send_after(5000, self(), {'hurt_remove'})
            end;
        true -> HurtRemoveRef
    end.

calc_bl_who_and_assist(State, SceneObject, AttackerSign, FullHurt, NewKList, NewFirstAttr) ->
    #ob_act{bl_who = OldBLWhos, bl_who_assist = OldBlWhosAssist, assist_list = AssistDataList} = State,
    #scene_object{
        id = ObjectId,
        scene = Scene, scene_pool_id = PoolId, copy_id = CopyId,
        x = Xnow, y = Ynow, mon = Mon
    } = SceneObject,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        not DropBoss orelse AttackerSign == ?BATTLE_SIGN_MON orelse FullHurt == 0 ->
            NewBLWhos = OldBLWhos, NewBlWhosAssist = OldBlWhosAssist;
        true ->
            case lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, SceneObject#scene_object.figure#figure.lv) of
                skip -> NewBLWhos = OldBLWhos, NewBlWhosAssist = OldBlWhosAssist;
                BlType ->
                    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBLWhos, NewKList, NewFirstAttr, AssistDataList),
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Xnow, Ynow, Adds, Dels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Xnow, Ynow, AddsAssist, DelsAssist),
                    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, SceneObject)
            end
    end,
    {NewBLWhos, NewBlWhosAssist}.

battle_die_event(State, BattleReturn) ->
    #battle_return{atter = Atter, sign  = AttackerSign} = BattleReturn,
    #ob_act{object = SceneObject, klist = KList, assist_list = AssistDataList, first_att = NewFirstAttr, bl_who = NewBLWhos} = State,
    KListAfCombine = lib_mon_util:combine_hurt_with_same_assist(KList, AssistDataList),
    lib_mon_event:be_killed(SceneObject, KListAfCombine, Atter, AttackerSign, NewFirstAttr, NewBLWhos, AssistDataList),
    lib_mon_mod:die_handler(State, KListAfCombine, Atter, AttackerSign),
    ok.

%% 初始化
init_behavior_tree(TreeId) ->
    BTree = lib_object_btree:init_btree(TreeId),
    %TickRef = ?IF(IsTick, util:send_after(undefined, BTree#behavior_tree.tick_gap, self(), tick), undefined),
    put(?BEHAVIOR_KEY, {BTree, undefined}).

%% 尝试执行行为
%% 主动怪会主动执行行为
try_behavior(State) ->
    #ob_act{object = Minfo} = State,
    #scene_object{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Xpx, y = Ypx, warning_range = WarningRange} = Minfo,
    case lib_mon_util:is_active_mon(Minfo) of
        true  ->
            lib_scene_object:put_ai(Minfo#scene_object.aid, SceneId, ScenePoolId, CopyId, Xpx, Ypx, WarningRange),
            erlang:send_after(1000, self(), 'try_behavior');
        false ->
            skip
    end.

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
            %?PRINT("NextGapTime ~p ~n", [NextGapTime]),
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

%% 手动触发tick|测试使用
behavior_tree_manual_tick(State, StateName) ->
    case get(?BEHAVIOR_KEY) of
        {Btree, TickRef} ->
            case lib_object_btree:tick_tree(State, StateName, Btree) of
                {NewState, NewStateName, NewBTree} -> ok;
                {NewState, NewStateName, NewBTree, _} -> ok
            end,
            util:cancel_timer(TickRef),
            put(?BEHAVIOR_KEY, {NewBTree, []}),
            {NewState, NewStateName};
        _ ->
            {State, StateName}
    end.

behavior_handle_info(State, StateName, InfoMsg) ->
    case get(?BEHAVIOR_KEY) of
        {Btree, TickRef} ->
            case lib_object_btree:handle_info(State, StateName, Btree, InfoMsg) of
                {NewState, NewStateName, NewBTree} ->
                    put(?BEHAVIOR_KEY, {NewBTree, TickRef});
                {NewState, NewStateName, NewBTree, NextTickTime} ->
                    NewTickRef = util:send_after(TickRef, NextTickTime, self(), tick),
                    %?PRINT("NextTickTime ~p ~n", [NextTickTime]),
                    put(?BEHAVIOR_KEY, {NewBTree, NewTickRef})
            end,
            {next_state, NewStateName, NewState};
        _ ->
            keep_state_and_data
    end.

%%
%% 检查距离，且检查分组和公会id
is_continue_trace_with_check(Dx, Dy, Tx, Ty, TracingDistance, MonGroup, MonGuild, ObGroup, ObGuildId) ->
    if
        MonGroup == ObGroup andalso  MonGroup =/= 0 ->  %% 分组相同，则不追踪
            false;
        MonGuild == ObGuildId  andalso  MonGuild =/= 0 -> %% 如果怪物有公会id，则不追踪同公会的对象
            false;
        true ->
            is_continue_trace(Dx, Dy, Tx, Ty, TracingDistance)
    end.

is_continue_trace(Dx, Dy, Tx, Ty, TracingDistance) ->
    abs(Dx-Tx) =< TracingDistance andalso abs(Dy-Ty) =< TracingDistance.