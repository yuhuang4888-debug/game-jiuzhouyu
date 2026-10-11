%%------------------------------------
%%% @Module  : mod_mon_active
%%% @Author  : zzm
%%% @Created : 2014.03.14
%%% @Description: 怪物活动状态
%%%------------------------------------

%%% 1.此模块注意ob_act记录和 #scene_object{}记录字段的取舍
%%% 2.#ob_act{}记录状态，行为相关字段
%%% 3.#scene_object{}记录静态属性字段, #scene_object{}涉及到跨进程间复制, 字段尽量精简, 无需共享的字段应放在#ob_act{}内

-module(mod_mon_active).
-behaviour(gen_fsm).

-define(stop_time, 250).

%% 消息处理
-export([
        stop/2
        , die/1
        , collect_mon/3
        , pick_mon/2
        , talk_to_mon/2
        , rob_mon_bl/3
        , rob_mon_bl_success/5
        , send_hurt_info/3
        , send_collectors_of_mon/3
        , gm_print/3
        , gm_statistics/2
    ]).

%% 怪物状态
-export([
        back/2, sleep/2, thorough_sleep/2, revive/2,
        trace/2, dead/2, walk/2
        ]).
-export([start/1]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("server.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("battle.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("drop.hrl").
-include("predefine.hrl").
-include("errcode.hrl").

%%开启一个怪物活动进程
start([_, MonId|_] = M)->
    case data_mon:get(MonId) of
        [] -> ?DEBUG("mon cfg error MonId:~p M:~p ~n", [MonId, M]);
        #mon{kind = Kind} = Mon ->
            case lib_mon:mon_init_model() of
                behavior ->
                    case Kind == ?MON_KIND_PICK orelse Kind == ?MON_KIND_COLLECT orelse Kind == ?MON_KIND_TASK_COLLECT
                        orelse Kind == ?MON_KIND_UNDIE_COLLECT orelse Kind == ?MON_KIND_COUNT_COLLECT of
                        true ->
                            mod_collect_mon:start(M++[Mon]);
                        _ ->
                            mod_btree_mon:start(M++[Mon])
                    end;
                _ ->
                    gen_fsm:start(?MODULE, M++[Mon], [{spawn_opt, [{fullsweep_after, 100}]}])
            end
    end.

%% 清理怪物
stop(Aid, BroadCast) ->
    Aid ! {'stop', BroadCast}.

%% 杀死怪物
die(Aid) ->
    Aid ! 'die'.

%% 采集怪物
collect_mon(Aid, User, Type) ->
    %% 第一个攻击的玩家
    FirstAttr = #mon_atter{id = RoleId, pid = Pid, node = Node, server_id = ServerId, name = Name} = lib_mon_util:create_mon_atter(User),
    case Type of
        ?COLLECT_STATR ->
            Aid ! {'start_collect_mon', RoleId, Node, Pid};
        ?COLLECT_FINISH ->
            Aid ! {'finish_collect_mon', RoleId, Node, ServerId, Name, FirstAttr};
        ?COLLECT_CANCEL ->
            Aid ! {'cancel_collect_mon', RoleId};
        _ -> skip
    end.

%% 拾取怪物
pick_mon(Aid, User) ->
    Aid ! {'pick_mon', User#ets_scene_user.id, User#ets_scene_user.node, User#ets_scene_user.pid}.

%% 与赏金型怪物对话
talk_to_mon(Aid, User) ->
    Aid ! {'talk_to_mon', User#ets_scene_user.id, User#ets_scene_user.pid, User#ets_scene_user.team#status_team.team_id}.

%% 抢夺怪物的归属
rob_mon_bl(Aid, Node, RoleId) ->
    Aid ! {'rob_mon_bl', Node, RoleId}.

%% 强夺成功
rob_mon_bl_success(Aid, MonAtter, RobbedId, WinCode, WinHp) ->
    Aid ! {'rob_mon_bl_success', MonAtter, RobbedId, WinCode, WinHp}.

%% 怪物伤害列表
send_hurt_info(Aid, Node, RoleId) ->
    Aid ! {'send_hurt_info', Node, RoleId}.

%% 获取怪物的采集者
send_collectors_of_mon(Aid, Node, PlayerId) ->
    Aid ! {'send_collectors_of_mon', Node, PlayerId}.

%% 输出
gm_print(SceneId, ScenePoolId, Id) ->
    case lib_mon:get_scene_mon_by_ids(SceneId, ScenePoolId, [Id], all) of
        [Mon] -> gen_fsm:sync_send_all_state_event(Mon#scene_object.aid, {gm_print});
        _ -> no_mon
    end.

%% 统计
gm_statistics(Aid, DestPid) ->
    Aid ! {'gm_statistics', DestPid}.


%% 怪物属性和初始状态初始化
init([_Id, _MonId, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, BroadCast, Arg, M])->
    %% 配置转换为内存数据
    InitMon = lib_mon_util:base_to_cache([_Id, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, self()], M),
    %% 自定义创建参数初始化,这里会根据参数覆盖原来的属性根据
    {Mon, InitState, BaseStateName, _} =
        lib_mon_util:set_mon(Arg, InitMon#scene_object{aid = self()}, #ob_act{}, null, ?BROADCAST_0, []),
    % 设置其他参数信息
    MonAfOther = lib_mon_util:set_mon_other(Mon, Arg),
    % 主动怪物寻找目标
    lib_mon_mod:find_target(MonAfOther, Scene, ScenePoolId, CopyId, Xpx, Ypx),
    State = InitState#ob_act{object = MonAfOther, w_point = {Mon#scene_object.x, Mon#scene_object.y}},
    %% 在场景进程中保存怪物信息
    lib_scene_object:insert(MonAfOther),
    %% 广播怪物
    case BroadCast  of
        ?BROADCAST_0 -> skip;
        % _ when Mon1#scene_object.mon#scene_mon.visible == 0 ->
            % skip;
        _ ->
            lib_scene_object:broadcast_object(MonAfOther)
    end,
    %% 怪物出生ai
    {NewState, StateName} = lib_mon_ai:born(State, BaseStateName),
    lib_mon_mod:born_handler(NewState),
    lib_scene_object:send_event_after([], 100, repeat),
    if
        StateName /= null ->
            {ok, StateName, NewState};
        true->
            {ok, sleep, NewState}
    end.

handle_event(_Event, StateName, Status) ->
    {next_state, StateName, Status}.

handle_sync_event({gm_print}, _From, StateName, State) ->
    #ob_act{bl_who = BLWhos, hurt_remove_ref = HurtRemoveRef} = State,
    ?MYLOG("hjh", "StateName:~p BLWhos:~p HurtRemoveRef:~p ~n", [StateName, BLWhos, HurtRemoveRef]),
    {reply, {BLWhos, HurtRemoveRef}, StateName, State};

handle_sync_event(_Event, _From, StateName, Status) ->
    {reply, ok, StateName, Status}.

%% ===================================================怪物进程消息处理=============================================
handle_info(Info, StateName, State) ->
    do_handle_info(Info, StateName, State).

%% 修改怪物属性
do_handle_info({'change_attr', KeyValues}, StateName, State) ->
    {Object, NewState, NewStateName, UpList} = lib_mon_util:set_mon(KeyValues, State#ob_act.object, State, StateName, 1, []),
    lib_scene_object:update(Object, UpList),
    lib_scene_object:change_attr_broadcast(UpList, Object, []),
    Ref1 = case NewStateName /= StateName of
               true  -> lib_scene_object:send_event_after(NewState#ob_act.ref, 0, repeat);
               false -> NewState#ob_act.ref
           end,
    {next_state, NewStateName, NewState#ob_act{object=Object, ref = Ref1}};

do_handle_info(_, dead, State) ->
    {next_state, dead, State};

do_handle_info({'ripple', Id, Pid, Sign, X, Y, Group}, StateName, State) ->
    #ob_act{att=Att, object=#scene_object{id=_ObjId, x=_ObjX, y=_ObjY, aid=_Aid, battle_attr = #battle_attr{group = MGroup}, mon = Mon} } = State,
    case Att of
        % 不攻击人的怪物,不会选择玩家攻击
        _ when Mon#scene_mon.kind == ?MON_KIND_ATT_NOT_PLAYER andalso Sign == ?BATTLE_SIGN_PLAYER ->
            {next_state, StateName, State};
        _ when StateName == thorough_sleep ->
            {next_state, StateName, State};
        undefined when MGroup =/= Group -> %% 新目标
            NewAtt = #{id=>Id, pid=>Pid, sign=>Sign, x=>X, y=>Y},
            Ref
            = if
                StateName =/= walk ->
                    lib_scene_object:send_event_after(State#ob_act.ref, 500, go);
                true ->
                    State#ob_act.ref
            end,
            {next_state, trace, State#ob_act{att=NewAtt, ref=Ref}};
        _ -> %% 其他目标
            {next_state, StateName, State}
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
    #ob_act{object=Object, ref=Ref, bl_who = BLWhos, bl_who_ref = OldBLWhosRef} = State,
    #scene_object{mon = Mon, d_x = Dx, d_y = Dy, tracing_distance = TraceDistance, aid = Aid , battle_attr = BA, figure = Figure} = Object,
    #battle_attr{group = MonGroup} = BA,
    #figure{guild_id = MonGuildId} = Figure,
    case Object#scene_object.type == 1 of
        true ->
            %% 是不是显示掉落boss
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            %% 是否需要队伍的boss归属
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
            if
                BLWhos == [] orelse not DropBoss -> skip;
                true -> lib_mon_util:check_sync_team_boss_bl_whos(BlType, RoleId, TeamId, BLWhos, Object)
            end,
            if
                StateName == sleep ->
                    case is_continue_trace_with_check(Dx, Dy, TX, TY, TraceDistance, MonGroup, MonGuildId, RoleGroupId, RoleGuildId) of %% 追踪范围, 检查pk状态和
                        false ->
                            {next_state, sleep, State};
                        true ->
                            Ref1 = lib_scene_object:send_event_after(Ref, 0, go),
                            {next_state, trace, State#ob_act{att=#{id=>RoleId, sign=>Sign, pid=>RolePid, x=>TX, y=>TY}, ref=Ref1}}
                    end;
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, State};
                true ->
                    case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false -> {next_state, StateName, State};
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
                                            {next_state, StateName, State};
                                        {RoleId, OBlWhoRef} ->
                                            util:cancel_timer(OBlWhoRef),
                                            NewBLWhosRef = lists:keydelete(RoleId, 1, OldBLWhosRef),
                                            {next_state, StateName, State#ob_act{bl_who_ref = NewBLWhosRef}}
                                    end
                            end
                    end
            end;
        false ->
            {next_state, sleep, State}
    end;

%% 寻找是否有攻击目标
do_handle_info('find_target', StateName, State) ->
    #ob_act{object=Object, att=Att} = State,
    case Att of
        undefined ->
            lib_mon_mod:find_target_cast(Object),
            {next_state, StateName, State};
        _ -> {next_state, StateName, State}
    end;

%% 找目标追踪
do_handle_info({'get_for_trace', Res}, StateName, State) ->
    #ob_act{ref=Ref, att=Att, object=_Object, bl_who=_BLWhos} = State,
    case Res of
        {TgSign, TgId, TgPid, TgX, TgY}->
            case Att of
                undefined ->
                    if
                        not is_reference(Ref) ->
                            NewState = State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}},
                            Msg = if StateName =:= trace -> repeat; true -> go end,
                            do_handle_info({'trace_info_back', [TgId, TgX, TgY, Msg]}, StateName, NewState);
                            % Ref1 = lib_scene_object:send_event_after(Ref, 0, go),
                            % State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}, ref = Ref1};
                        true ->
                            case erlang:read_timer(Ref) of
                                Time when is_integer(Time) andalso Time > 100 ->
                                    Ref1 = lib_scene_object:send_event_after(Ref, Time, go),
                                    NewState = State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}, ref = Ref1},
                                    {next_state, trace, NewState};
                                _ ->
                                    NewState = State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}},
                                    Msg = if StateName =:= trace -> repeat; true -> go end,
                                    do_handle_info({'trace_info_back', [TgId, TgX, TgY, Msg]}, StateName, NewState)
                            end
                    end;
                _ ->
                    {next_state, StateName, State}
            end;
        _ ->
            if
                StateName =:= sleep ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 3500, repeat),
                    {next_state, sleep, State#ob_act{ref = Ref1}};
                true ->
                    {next_state, StateName, State}
            end
    end;

%% 追踪目标返回
do_handle_info({'trace_info_back', [Id, X, Y, Msg|_]}, StateName, State) ->
    #ob_act{
        att=Att, object=Minfo, skill_link_info=SkillLinkInfo, next_att_time=NextAttTime, next_move_time=NextMoveTime, ref=Ref, check_block = CheckBlock,
        w_point = {OX, OY}, release_skill=ReleaseSkill
        } = State,
    #scene_object{mon=Mon, tracing_distance=TracingDistance} = Minfo,
    #scene_mon{d_x=Dx, d_y=Dy, kind = Kind} = Mon,
    case Att of
        #{id := Id, sign := Sign} ->
            if Kind =:= ?MON_KIND_ATT orelse Kind =:= ?MON_KIND_ATT_NOT_PLAYER -> Dx1 = OX, Dy1 = OY; true -> Dx1 = Dx, Dy1 = Dy end,
            % TODO: 输出怎么无法 trace
            % ?PRINT("is_continue_trace:~p ~n", [is_continue_trace(Dx1, Dy1, X, Y, TracingDistance)]),
            case is_continue_trace(Dx1, Dy1, X, Y, TracingDistance) of
                % false when Kind =/= ?MON_KIND_ATT->
                false ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                    {next_state, back, State#ob_act{att=undefined, ref=Ref1}};
                _R ->
                    NowTime = utime:longunixtime(),
                    {Next, Args}  = lib_scene_object_ai:trace_to_att(Minfo, X, Y, {target, Sign, Id}, Ref, NextAttTime, NextMoveTime, NowTime, SkillLinkInfo, CheckBlock, ReleaseSkill),
                    %io:format("~p ~p {Next, Args} :~w~n", [?MODULE, ?LINE, {Next, Args}]),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State),
                    NextStateName = case Next of
                        trace -> trace;
                        back -> back;
                        _ -> back
                    end,

                    {AIState, AIStateName} = case Msg of
                        go -> lib_mon_ai:wake_up(AfBattleState, NextStateName);
                        _  -> {AfBattleState, NextStateName}
                    end,
                    {next_state, AIStateName, AIState}
            end;
            % trace(Msg, State#ob_act{att = Att#{x => X, y => Y}});
        _ ->
            {next_state, StateName, State}
    end;
%% 追踪目标返回 找不到目标
do_handle_info({'trace_info_back', _}, StateName, State) ->
    case StateName of
        back ->
            Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 1500, repeat),
            {next_state, back, State#ob_act{att = undefined, ref = Ref1}};
        _ ->
            {next_state, StateName, State}
    end;

%% 采集怪
do_handle_info({'start_collect_mon', CollectorId, CollectorNode, CollectorPid}, StateName, State) ->
    #ob_act{object = Minfo, clist = Clist} = State,
    #scene_object{scene =SceneId, scene_pool_id = ScenePoolId, battle_attr = BA, mon = Mon} = Minfo,
    #scene_mon{kind=Kind, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
    IsCanCollect = lib_mon_util:is_collect_mon(Kind),
    IsUnLimitTimesType = lists:member(Kind, [?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT]), %% 不需要判断采集次数的采集怪类型
    RemainClTimes = CollectCount - CollectTimes,
    Now = utime:unixtime(),
    if
        BA#battle_attr.hp =< 0 orelse IsCanCollect == false ->
            UpdateArgs = [{clear_collect_info, {Minfo#scene_object.aid, Minfo#scene_object.mon#scene_mon.mid}}, {is_collecting, 0}],
            mod_scene_agent:update(SceneId, ScenePoolId, CollectorId, UpdateArgs),
            {next_state, StateName, State};
        true ->
            CurCollectPersonNum = length(Clist),
            case IsUnLimitTimesType orelse CurCollectPersonNum < RemainClTimes of
                true ->
                    NewClist = [{CollectorId, CollectorPid, Now} | lists:keydelete(CollectorId, 1, Clist)],
                    case not IsUnLimitTimesType andalso RemainClTimes - CurCollectPersonNum == 1 of  %% 只剩最后一次
                        true -> Args = [{has_cltimes, 0}];
                        false -> Args = []
                    end,
                    lib_scene_object:update(Minfo, [{is_collecting, 1}|Args]),
                    NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{is_collecting = 1}},
                    {next_state, StateName, State#ob_act{clist = NewClist, object = NewMinfo}};
                false -> %% 如果怪物的剩余采集次数不足要进行提示
                    {ok, BinData} = pt_200:write(20008, ?COLLECT_RES_HAD_FINISHED),
                    lib_battle:rpc_cast_to_node(CollectorNode, lib_server_send, send_to_uid, [CollectorId, BinData]),
                    UpdateArgs = [{clear_collect_info, {Minfo#scene_object.aid, Minfo#scene_object.mon#scene_mon.mid}}, {is_collecting, 0}],
                    mod_scene_agent:update(SceneId, ScenePoolId, CollectorId, UpdateArgs),
                    {next_state, StateName, State}
            end
    end;
do_handle_info({'finish_collect_mon', CollectorId, CollectorNode, ServerId, CollectorName, FirstAttr}, StateName, State) ->
    #ob_act{object = Minfo, clist = Clist, ref = Ref} = State,
    Now   = utime:unixtime(),
    #scene_object{scene =SceneId, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y, battle_attr=BA, mon=Mon} = Minfo,
    #scene_mon{kind=Kind, collect_time=CollectTime, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
    IsCanCollect = lists:member(Kind, [?MON_KIND_COLLECT, ?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT, ?MON_KIND_COUNT_COLLECT]),
    IsUnLimitTimesType = lists:member(Kind, [?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT]), %% 不需要判断采集次数的采集怪类型
    RemainClTimes = CollectCount - CollectTimes,
    CollectInfo = lists:keyfind(CollectorId, 1, Clist),
    if
        BA#battle_attr.hp =< 0 orelse IsCanCollect == false orelse CollectInfo == false ->
            {next_state, StateName, State};
        true -> %% 结束采集
            case CollectInfo of
                {_, _, Time} when Now - Time >= CollectTime ->
                    if
                        Kind == 8 -> %% 无限采集，不死亡(不死采集怪)
                            NewClist = lists:keydelete(CollectorId, 1, Clist),
                            IsCollecting = ?IF(NewClist =/= [], 1, 0),
                            lib_scene_object:update(Minfo, [{is_collecting, IsCollecting}]),
                            NewStateName = StateName, NewState = State#ob_act{clist = NewClist};
                        Kind == 2 -> %% 无限采集，不死亡(任务采集怪)
                            NewClist = lists:keydelete(CollectorId, 1, Clist),
                            IsCollecting = ?IF(NewClist =/= [], 1, 0),
                            lib_scene_object:update(Minfo, [{is_collecting, IsCollecting}]),
                            NewStateName = StateName, NewState = State#ob_act{clist = NewClist};
                        Kind == ?MON_KIND_COUNT_COLLECT andalso CollectTimes + 1 >= CollectCount -> %% 有次数限制采集怪，不死亡
                            NewClist = lists:keydelete(CollectorId, 1, Clist),
                            IsCollecting = ?IF(NewClist =/= [], 1, 0),
                            NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{collect_times = CollectCount, is_collecting = IsCollecting, has_cltimes = 0}},
                            lib_scene_object:update(NewMinfo, [{is_collecting, IsCollecting}, {has_cltimes, 0}]),
                            NewStateName = StateName, NewState = State#ob_act{object = NewMinfo, clist = NewClist};
                        CollectTimes + 1 >= CollectCount ->
                            {ok, BinData} = pt_120:write(12081, [Minfo#scene_object.id, 0]),
                            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, X, Y, BinData),
                            NewMinfo = Minfo#scene_object{battle_attr = BA#battle_attr{hp=0}, mon=Mon#scene_mon{collect_times = 0, is_collecting = 0, has_cltimes = 1}},
                            lib_scene_object:update(NewMinfo, [{hp, 0}, {is_collecting, 0}, {has_cltimes, 1}]),
                            %% {NewState, _} = lib_mon_ai:die(State#ob_act{object = NewMinfo}, StateName),
                            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                            NewStateName = dead, NewState = State#ob_act{object=NewMinfo, ref = Ref1};
                        true ->
                            NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{collect_times = CollectTimes + 1}},
                            NewClist = lists:keydelete(CollectorId, 1, Clist),
                            IsCollecting = ?IF(NewClist =/= [], 1, 0),
                            lib_scene_object:update(NewMinfo, [{is_collecting, IsCollecting}]),
                            NewStateName = StateName, NewState = State#ob_act{object = NewMinfo, clist = NewClist}
                    end,
                    %% 采集成功
                    lib_mon_mod:collect_handler(NewState, CollectorNode, CollectorId, ServerId, CollectorName, FirstAttr),
                    {next_state, NewStateName, NewState};
                _ ->
                    %% 采集时间不足
                    {ok, BinData} = pt_200:write(20008, ?COLLECT_RES_TIME_ERR),
                    lib_battle:rpc_cast_to_node(CollectorNode, lib_server_send, send_to_uid, [CollectorId, BinData]),
                    NewClist = lists:keydelete(CollectorId, 1, Clist),
                    case not IsUnLimitTimesType andalso RemainClTimes - length(NewClist) > 0 of
                        true -> Args = [{has_cltimes, 1}];
                        false -> Args = []
                    end,
                    ?IF(NewClist =/= [], lib_scene_object:update(Minfo, Args),
                        lib_scene_object:update(Minfo, [{is_collecting, 0}|Args])),
                    {next_state, StateName, State#ob_act{clist = NewClist}}
            end
    end;
do_handle_info({'cancel_collect_mon', CollectorId}, StateName, State) ->
    #ob_act{object = Minfo, clist = Clist, ref = _Ref} = State,
    #scene_object{battle_attr=BA, mon=Mon} = Minfo,
    #scene_mon{kind=Kind, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
    IsCanCollect = lists:member(Kind, [?MON_KIND_COLLECT, ?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT, ?MON_KIND_COUNT_COLLECT]),
    IsUnlimitTimesType = lists:member(Kind, [?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT]), %% 不需要判断采集次数的采集怪类型
    RemainClTimes = CollectCount - CollectTimes,
    CollectInfo = lists:keyfind(CollectorId, 1, Clist),
    if
        BA#battle_attr.hp =< 0 orelse IsCanCollect == false orelse CollectInfo == false ->
            {next_state, StateName, State};
        true -> %% 其他情况都默认中断采集
            NewClist = lists:keydelete(CollectorId, 1, Clist),
            case not IsUnlimitTimesType andalso RemainClTimes - length(NewClist) > 0 of
                true -> Args = [{has_cltimes, 1}];
                false -> Args = []
            end,
            ?IF(NewClist =/= [], lib_scene_object:update(Minfo, Args),
                lib_scene_object:update(Minfo, [{is_collecting, 0}|Args])),
            {next_state, StateName, State#ob_act{clist = NewClist}}
    end;

%% 停止采集怪
do_handle_info({'stop_collect', CollectorId, CollectorNode, StopperId}, StateName, State) ->
    case lists:keyfind(CollectorId, 1, State#ob_act.clist) of
        false->
            {next_state, StateName, State};
        _ ->
            #ob_act{clist = Clist, object = Minfo} = State,
            #scene_object{mon = Mon} = Minfo,
            NewClist = lists:keydelete(CollectorId, 1, Clist),
            IsCollecting = ?IF(NewClist =/= [], 1, 0),
            NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{collect_times = length(NewClist), is_collecting = IsCollecting, has_cltimes = 1}},
            lib_scene_object:update(State#ob_act.object, [{is_collecting, IsCollecting},{has_cltimes, 1}]),
            {ok, BinData} = pt_200:write(20008, ?COLLECT_RES_CANCEL_SUCCESS),
            {ok, BinData2} = pt_200:write(20026, StopperId),
            lib_server_send:send_to_uid(CollectorNode, CollectorId, <<BinData/binary, BinData2/binary>>),
            {next_state, StateName, State#ob_act{clist = NewClist, object = NewMinfo}}
    end;

%% 拾取
do_handle_info({'pick_mon', CollectorId, _CollectorNode, _CollectorPid}, _StateName, State) ->
    #ob_act{object = Minfo, ref = Ref} = State,
    lib_mon_event:be_picked(Minfo, CollectorId),
    {AiState, _} = lib_mon_ai:die(State, none, _StateName),
    Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
    {next_state, dead, AiState#ob_act{ref = Ref1}};

%% 反弹伤害.
%% 注意:不要进行赋值,目前只是用于计算伤害值
%% @BattleReturn #battle_return{hurt = AfReBAerHurt, sign = AerRetrunSign, atter = AerRetrunAtter}, 只有这三个字段有效
do_handle_info({'rebound_battle_info', BattleReturn}, StateName, State) ->
    % #battle_return{
    %    hurt = Hurt,
    %    sign = AtterSign,
    %    atter = Atter
    %   } = BattleReturn,
    % #ob_act{object = Minfo} = State,
    % lib_mon_event:be_rebound_hurt(Minfo, Atter, AtterSign, Hurt),
    % {next_state, StateName, State};
    do_handle_info({'battle_info', BattleReturn}, StateName, State);

%% 受到攻击
do_handle_info({'battle_info', BattleReturn}, StateName, OldState) ->
    #battle_return{
        hp = Hp,
        hurt = OldFullHurt,
        real_hurt = RealHurt,
        move_x = MoveX,
        move_y = MoveY,
        taunt = Taunt,
        attr_buff_list = AttrBuffList,
        other_buff_list = OtherBuffList,
        atter = Atter,
        sign  = AtterSign  %% 1：怪物， 2：人 其他
    } = BattleReturn,
    #battle_return_atter{
        id = AtterId, pid = AtterPid, real_id=RealId, node = AtterNode, server_id = ServerId, camp_id = Camp,
        real_sign=RealSign, team_id = TeamId, x=Xatt, y=Yatt, lv = AtterLv, real_name = RealName, career = Career,
        server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, mask_id = MaskId, assist_id = AssistId
	, guild_id = GuildId, halo_privilege = HaloPrivilegeL
        } = Atter,
    State = OldState, % lib_mon_mod:battle_to_clear_bl_who_die_ref(OldState, AtterSign, AtterId),
    #ob_act{
        att = OldAtt, object = Minfo, klist = Klist, first_att = FirstAttr, bl_who = OldBLWhos,
        ref = Ref, hurt_remove_ref = HurtRemoveRef,
        move_begin_time = MoveBeginTime, each_move_time = EachMoveTime, o_point = {OX, OY},
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist
        } = State,

    #scene_object{
        id = ObjectId,
        scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Xnow, y = Ynow,
        mon = Mon, battle_attr = BA, aid = Aid, is_hit_ac = IsHitAc} = Minfo,
    % 伤害计算
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} when
        SceneType == ?SCENE_TYPE_TERRITORY orelse SceneType == ?SCENE_TYPE_KF_SANCTUARY
        orelse ?SCENE_TYPE_NEW_OUTSIDE_BOSS orelse SceneType == ?SCENE_TYPE_SPECIAL_BOSS
        orelse ?SCENE_TYPE_NIGHT_GHOST ->
            FullHurt = RealHurt,
            Hurt = RealHurt;
        % 最后伤害等于血量
        #ets_scene{type = SceneType} ->
            FullHurt = OldFullHurt,
            Hurt = min(FullHurt, Minfo#scene_object.battle_attr#battle_attr.hp)
    end,
    %% 第一个攻击的玩家
    MonAtter = #mon_atter{
        id = AtterId, pid = AtterPid, node = AtterNode, guild_id = GuildId,
        server_id = ServerId, team_id = TeamId, att_sign = AtterSign, att_lv = AtterLv,
        name = RealName, server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel,
        camp_id = Camp, mask_id = MaskId, assist_id = AssistId, assist_ex_id = lib_mon_util:get_assist_ex_id(AssistId, AssistDataList),
        halo_privilege = HaloPrivilegeL, career = Career
    },
    NewFirstAttr = ?IF(FirstAttr == [] andalso FullHurt /= 0, MonAtter, FirstAttr),
    %% 如果攻击者是人，就加入伤害列表里面
    NewKlist = ?IF(AtterSign == ?BATTLE_SIGN_PLAYER andalso FullHurt /= 0, lib_mon_util:add_hatred_list(Klist, MonAtter, Hurt), Klist),
    % case data_scene:get(Scene) of
    %     #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
    %         ?MYLOG("hjhhurtsum", "AtterId:~p MonId:~p Hurt:~p ~n", [AtterId, Mon#scene_mon.mid, Hurt]);
    %     _ -> skip
    % end,
    %% 定时移除离开boss范围的伤害玩家
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    NewHurtRemoveRef = if
        not DropBoss orelse AtterSign == ?BATTLE_SIGN_MON orelse FullHurt == 0 -> HurtRemoveRef;
        HurtRemoveRef == [] ->
            case lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Minfo#scene_object.figure#figure.lv) of
                skip -> ?IF(lists:member(SceneType, ?SCENE_TYPE_NOT_DROP_HURT_REMOVE), erlang:send_after(5000, Aid, {'hurt_remove'}), []);
                _ -> erlang:send_after(5000, Aid, {'hurt_remove'})
            end;
        true -> HurtRemoveRef
    end,
    %% 怪物新的归属者
    if
        not DropBoss orelse AtterSign == ?BATTLE_SIGN_MON orelse FullHurt == 0 ->
            NewBLWhos = OldBLWhos, NewBlWhosAssist = OldBlWhosAssist;
        true ->
            case lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Minfo#scene_object.figure#figure.lv) of
                skip -> NewBLWhos = OldBLWhos, NewBlWhosAssist = OldBlWhosAssist;
                BlType ->
                    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBLWhos, NewKlist, NewFirstAttr, AssistDataList),
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Xnow, Ynow, Adds, Dels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKlist, AssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Xnow, Ynow, AddsAssist, DelsAssist),
                    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Minfo)
            end
    end,
    % ?MYLOG("hjhbattlebl", "NewFirstAttr:~p NewBLWhos:~p OldBLWhos:~p ~n", [NewFirstAttr, NewBLWhos, OldBLWhos]),
    NewHpChangeHandler = lib_mon_mod:hp_change_handler(State, Hp, NewKlist),
    Minfo1 = Minfo#scene_object{battle_attr = BA#battle_attr{hp=max(0,Hp), attr_buff_list = AttrBuffList, other_buff_list = OtherBuffList} },
    State1 = State#ob_act{
        object = Minfo1, bl_who = NewBLWhos,hp_change_handler = NewHpChangeHandler,
        first_att = NewFirstAttr,  klist = NewKlist, hurt_remove_ref = NewHurtRemoveRef, bl_who_assist = NewBlWhosAssist},
    lib_mon_event:be_hurted(Minfo1, Minfo, Atter, MonAtter, AtterSign, Hurt, NewKlist, Klist),
    lib_mon_event:hp_change(Minfo1, Minfo, NewKlist),
    {HpAiState, HpAiStateName} = lib_mon_ai:hp_change(BA#battle_attr.hp, Hp, State1, null),
    #ob_act{object=MinfoAfHpAi} = HpAiState,
    if
        Hp =< 0 -> %% 死亡掉落，功能杀怪物处理
            KListAfCombine = lib_mon_util:combine_hurt_with_same_assist(NewKlist, AssistDataList),
            lib_mon_event:be_killed(MinfoAfHpAi, KListAfCombine, Atter, AtterSign, NewFirstAttr, NewBLWhos, AssistDataList),
            {AiState, _} = lib_mon_ai:die(HpAiState, Atter, StateName),
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            % lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_custom_act_api, calc_act_drop, [Scene, Mon#scene_mon.boss]),
            lib_mon_mod:die_handler(HpAiState, KListAfCombine, Atter, AtterSign),
            {next_state, dead, AiState#ob_act{ref=Ref1}};
        true ->
            if
                ((HpAiStateName==null orelse HpAiStateName == trace) andalso
                        MinfoAfHpAi#scene_object.is_fight_back == 1) -> %% 是否反击
                    NewAttTarget =
                        if
                            OldAtt == undefined -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign};
                            Taunt == {0, 0} ->
                                case OldAtt of
                                    % 进击怪:追踪的攻击者是怪物的话,被玩家攻击会追踪打
                                    #{sign:=OldSign} when Mon#scene_mon.kind == ?MON_KIND_ATT_TO_PLAYER andalso OldSign =/= ?BATTLE_SIGN_PLAYER andalso RealSign == ?BATTLE_SIGN_PLAYER ->
                                        #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign};
                                    #{x:=Xtr, y:=Ytr} when (abs(Xtr-Xnow) > 300 andalso abs(Xtr-Xnow) > abs(Xatt-Xnow)) orelse
                                                           (abs(Ytr-Ynow) > 150 andalso abs(Ytr-Ynow) > abs(Yatt-Ynow)) ->
                                        #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign};
                                    _ ->
                                        OldAtt
                                end;
                            true -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign}
                        end,

                    {IsPlayHitAc, UpX, UpY} =
                        if
                            MoveX /= 0 orelse MoveY /= 0 -> {false, MoveX, MoveY};
                            IsHitAc == 1 ->
                                NowTime = utime:longunixtime(),
                                if
                                    MoveBeginTime == 0 orelse MoveBeginTime+EachMoveTime < NowTime ->
                                        {false, Xnow, Ynow};
                                    true ->
                                        R = (MoveBeginTime+EachMoveTime-NowTime) / EachMoveTime,
                                        { true, round((OX-Xnow)*R) + Xnow, round((OY-Ynow)*R) + Ynow }
                                end;
                            true -> {false, Xnow, Ynow}
                        end,
                    if
                        % 是否追踪
                        StateName == sleep orelse StateName == back orelse StateName == walk ->
                            Ref1 = case IsPlayHitAc of
                                       true  -> lib_scene_object:send_event_after(Ref, ?stop_time, go);
                                       false -> lib_scene_object:send_event_after(Ref, 0, go)
                                   end,
                            {next_state, trace, HpAiState#ob_act{att=NewAttTarget, ref=Ref1, move_begin_time=0}};
                        IsPlayHitAc ->
                            Ref1 = lib_scene_object:send_event_after(Ref, ?stop_time, repeat),
                            MonInfoPlayerHitAc = MinfoAfHpAi#scene_object{x=UpX, y=UpY},
                            {next_state, StateName, HpAiState#ob_act{object=MonInfoPlayerHitAc, att=NewAttTarget, ref=Ref1, move_begin_time=0}};
                        true ->
                            {next_state, StateName, HpAiState#ob_act{att=NewAttTarget}}
                    end;
                HpAiStateName /= null -> %% hp_ai影响了怪物行为
                    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                    {next_state, HpAiStateName, HpAiState#ob_act{ref=Ref1}};
                true -> %% 其余不反击的怪物，保持现状
                    {next_state, StateName, HpAiState}
            end
    end;

do_handle_info({'object_assist_back', Res}, StateName, State) ->
    #ob_act{selected_skill = SelectSkillMap, ref = Ref, object = SceneObject} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    {Next, Args} = lib_scene_object_ai:handle_assist_res(State, SelectedSkillInfo, SceneObject, Ref, Res),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State),
                    if
                        StateName == thorough_sleep ->
                            {next_state, StateName, AfBattleState};
                        true ->
                            NextStateName = case Next of
                                trace -> trace;
                                _ -> back
                            end,
                            {next_state, NextStateName, AfBattleState}
                    end;
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
                    {next_state, StateName, State#ob_act{ref = Ref1}}
            end;
        _ ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1}}
    end;

do_handle_info({'object_battle_back', Res}, StateName, State) ->
    #ob_act{selected_skill = SelectSkillMap, ref = Ref, object = SceneObject} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    {Next, Args} = lib_scene_object_ai:handle_battle_res(State, SelectedSkillInfo, SceneObject, Ref, Res),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State),
                    NextStateName = case Next of
                        trace -> trace;
                        _ -> back
                    end,
                    {next_state, NextStateName, AfBattleState};
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
                    {next_state, StateName, State#ob_act{ref = Ref1}}
            end;
        _ ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1}}
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
    #scene_object{scene = Scene, mon = Mon} = Object,
    #scene_mon{is_collecting = IsCollecting} = Mon,
    IsForbidStopScene = lib_mon_util:is_forbid_stop_scene(Scene),
    %%?MYLOG("mon", "IsForbidStopScene ~p,  IsCollecting ~p~n", [IsForbidStopScene, IsCollecting]),
    if
        IsForbidStopScene == true andalso IsCollecting > 0 ->
            {next_state, StateName, State};
        true ->
            util:cancel_timer(State#ob_act.ref),
            lib_scene_object:stop(State#ob_act.object, Broadcast),
            lib_mon_event:be_stop(State#ob_act.object),
            {stop, normal, State}
    end;


%% 杀死怪物
do_handle_info('die', StateName, State) ->
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, 1),
    lib_mon_ai:die(State, none, StateName),
    lib_mon_event:be_die(State#ob_act.object),
    {stop, normal, State};

%% 持续施放副技能
do_handle_info({'combo', Args}, StateName, State) ->
    State1 = lib_scene_object_ai:combo(Args, State),
    {next_state, StateName, State1};

%% 持续施放特殊副技能
do_handle_info({'find_target_combo', Args}, StateName, State) ->
    State1 = lib_scene_object_ai:find_target_combo(Args, State),
    {next_state, StateName, State1};

do_handle_info({'combo_battle_back', Res}, StateName, State) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    NewState = lib_scene_object_ai:battle_combo_res(SelectedSkillInfo, State, Res),
                    {next_state, StateName, NewState};
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    {next_state, StateName, State#ob_act{object = BackObj}}
            end;
        _ ->
            {next_state, StateName, State}
    end;

do_handle_info({'combo_assist_back', Res}, StateName, State) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    NewState = lib_scene_object_ai:assist_combo_res(SelectedSkillInfo, State, Res),
                    {next_state, StateName, NewState};
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    {next_state, StateName, State#ob_act{object = BackObj}}
            end;
        _ ->
            {next_state, StateName, State}
    end;

%% 处理怪物的AI定时事件
do_handle_info({'special_event', Events}, StateName, State) ->
    {NewState, NewStateName} = lib_mon_ai:do_ai_list(Events, State, utime:longunixtime(), StateName, none),
    %%lib_scene_object:insert(NewState#ob_act.object),
    % ?MYLOG(State#ob_act.object#scene_object.config_id==6, "monai", "ac_skill eref:~p New eref:~p ~n", [State#ob_act.eref, NewState#ob_act.eref]),
    Ref1 = case NewStateName /= StateName of
        true  -> lib_scene_object:send_event_after(State#ob_act.ref, 100, repeat);
        false -> NewState#ob_act.ref
    end,
    {next_state, NewStateName, NewState#ob_act{ref = Ref1}};

%% 进入狂暴
do_handle_info({'frenzy', Events}, StateName, State) ->
    % ?MYLOG("hjhmon", "frenzy Events:~p ~n", [Events]),
    #ob_act{frenzy_ref = FrenzyRef} = State,
    {NewState, NewStateName} = lib_mon_ai:do_ai_list(Events, State, utime:longunixtime(), StateName, none),
    Ref1 = case NewStateName /= StateName of
        true  -> lib_scene_object:send_event_after(State#ob_act.ref, 100, repeat);
        false -> NewState#ob_act.ref
    end,
    util:cancel_timer(FrenzyRef),
    {next_state, NewStateName, NewState#ob_act{ref = Ref1, frenzy_ref = []}};

%% 广播伤害
do_handle_info('broadcast_hurt_list', StateName, State) ->
    DelayTime = case get({?MODULE, hurt_ref}) of
                    undefined -> 10*1000;
                    Time -> Time
                end,
    lib_mon_event:broadcast_hurt_list(State#ob_act.object, State#ob_act.klist),
    HurtRef = lib_mon_ai:send_after(DelayTime, self(), 'broadcast_hurt_list', State#ob_act.hurt_ref),
    {next_state, StateName, State#ob_act{hurt_ref = HurtRef}};

%% 怪物随机走路
do_handle_info('auto_move', sleep, State) ->
    #ob_act{object=Object} = State,
    #scene_object{mon=#scene_mon{kind=Kind}} = Object,
    case Kind of
        ?MON_KIND_NORMAL ->
            {NewObject, _Time} = lib_scene_object_ai:auto_move(Object),
            {next_state, sleep, State#ob_act{object=NewObject}};
        _ ->
            {next_state, sleep, State}
    end;

%% 睡觉
do_handle_info('sleep', _StateName, State) ->
    {next_state, sleep, State};

%% 定时请求移除玩家伤害列表
%% hurt_remove_ref 定时器触发,攻击的时候出发定时器
do_handle_info({'hurt_remove'}, StateName, State) ->
    #ob_act{object=Object, bl_who = BLWhos, hurt_remove_ref = HurtRemoveRef} = State,
    util:cancel_timer(HurtRemoveRef),
    #scene_object{aid = Pid, d_x = DX, d_y = DY, x = X, y = Y, scene = Scene, scene_pool_id = PoolId,
                  copy_id = CopyId, tracing_distance = TracingDistance} = Object,
    lib_scene:is_need_to_remove_hurt(Scene) andalso
    mod_scene_agent:apply_cast(Scene, PoolId, lib_scene_agent, get_scene_boss_hurt_user, [Pid, Scene, CopyId, DX, DY, X, Y, TracingDistance]),
    if
        StateName == sleep -> %% 休眠
            if
                BLWhos == [] -> NewHurtRemoveRef = [];
                true -> NewHurtRemoveRef = erlang:send_after(5000, Pid, {'hurt_remove'})
            end,
            {next_state, StateName, State#ob_act{hurt_remove_ref = NewHurtRemoveRef}};
        true ->
            NewHurtRemoveRef = erlang:send_after(5000, Pid, {'hurt_remove'}),
            %% io:format("~p ~p 'hurt_remove':~w~n", [?MODULE, ?LINE, ['hurt_remove']]),
            {next_state, StateName, State#ob_act{hurt_remove_ref = NewHurtRemoveRef}}
    end;

%% 接受移除玩家列表
%% @param UsersIds 有伤害的玩家id列表
do_handle_info({'hurt_remove', UsersIds}, StateName, State) ->
    #ob_act{
        ref = Ref, klist = Klist, bl_who = BLWhos, object = Object, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y} = Object,
    NewKList = [P || P <- Klist, lists:member(P#mon_atter.id, UsersIds)],
    DelUsersIds = [P#mon_atter.id || P <- Klist, not lists:member(P#mon_atter.id, UsersIds)],
    lib_mon_event:hurt_remove(Object, Klist, NewKList, DelUsersIds),
    % OldBLWhos = [P || P <- BLWhos, lists:member(P#mon_atter.id, UsersIds)],
    % ?PRINT("hurt_remove UsersIds:~p FirstAttr:~p BLWhos:~p, Klist:~p, NewKList:~p ~n", [UsersIds, FirstAttr, BLWhos, Klist, NewKList]),
    %% 首次攻击
    {NewFirstAttr, DelRoleId} = case FirstAttr of
        [] -> {[], 0};
        _ -> ?IF(lists:member(FirstAttr#mon_atter.id, UsersIds), {FirstAttr, 0}, {[], FirstAttr#mon_atter.id})
    end,
    %% 重新计算Boss归属
    BlType = lib_mon_util:get_boss_drop_bltype(Object#scene_object.mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Object#scene_object.mon#scene_mon.mid, BlType, BLWhos, NewKList, NewFirstAttr, AssistDataList),
    NewDels = case lists:keyfind(DelRoleId, #mon_atter.id, BLWhos) of
        false -> Dels;
        E ->
            case lists:keymember(DelRoleId, #mon_atter.id, Dels) of
                true -> Dels;
                false -> [E|Dels]
            end
    end,
    % ?MYLOG("hjhbl", "hurt_remove OldBLWhos:~p Adds:~p Dels:~p, NewBLWhos:~p NewDels:~p ~n", [BLWhos, Adds, Dels, NewBLWhos, NewDels]),
    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, X, Y, Adds, NewDels),
    %% 重新计算归属者的协助列表
    {AddsAssist, DelsAssist, NewBlWhosAssist} = lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, X, Y, AddsAssist, DelsAssist),
    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
    if
        % 睡眠状态且没有归属,则快速进入睡眠
        StateName == sleep andalso BLWhos =/= [] andalso NewBLWhos == [] ->
            Ref1 = lib_scene_object:send_event_after(Ref, 20, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1, first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        % 睡眠状态切有归属寻找目标
        StateName == sleep andalso NewBLWhos =/= [] ->
            lib_mon_mod:find_target_cast(Object),
            {next_state, StateName, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        BLWhos == [] ->
            Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1, first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}};
        true ->
            {next_state, StateName, State#ob_act{first_att = NewFirstAttr, bl_who = NewBLWhos, klist = NewKList, bl_who_assist = NewBlWhosAssist}}
    end;

%% 离开或者加入队伍操作
do_handle_info({'team_flag', RoleId, TeamId}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case Object#scene_object.type == 1 of
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
            {next_state, StateName, State}
    end;

%% 增加队伍的攻击列表
do_handle_info({'add_team_mon_atter_list', MonAtterL}, StateName, State) ->
    #ob_act{
        object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr, bl_who_ref = BlWhoRefL,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, aid = Aid, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case Object#scene_object.type == 1 of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            if
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, State};
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
                    % ?MYLOG("hjhteam", "add_team_mon_atter_list NewMonAtterL:~p MonAtterL:~p ~n", [NewMonAtterL, MonAtterL]),
                    case NewMonAtterL == [] of
                        true -> {next_state, StateName, State};
                        false ->
                            F = fun(#mon_atter{id = RoleId} = MonAtter, {TmpKList, TmpBlWhoRefL}) ->
                                NewTmpKList = lib_mon_util:add_hatred_list(TmpKList, MonAtter, 0),
                                NewTmpBlWhoRefL = case lists:keyfind(RoleId, 1, TmpBlWhoRefL) of
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
            {next_state, StateName, State}
    end;

%% 玩家第一次进入场景
do_handle_info({'enter', RoleId, _RolePid, _Sign, TeamId}, StateName, State) ->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_die_ref = BlWhoDieRefL, clist = Clist} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    % ?MYLOG("hjhenter", "enter:RoleId:~p BLWhos:~p IsDropBoss:~p ~n", [RoleId, BLWhos, ?IS_DROP_BOSS(Mon#scene_mon.boss)]),
    case Object#scene_object.type == 1 of
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
                            % ?MYLOG("hjhenter", "===========12022:RoleId:~p ~n", [RoleId]),
                            lib_server_send:send_to_area_scene(Scene, PoolId, CopyId, Mx, My, Bin),
                            mod_scene_agent:update(Scene, PoolId, RoleId, [{bl_who, 1}, {bl_who_op, {ObjectId, 1}}])
                    end,
                    {next_state, StateName, NewState}
            end;
        false ->
            #scene_mon{kind = Kind, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
            IsCanCollect = lib_mon_util:is_collect_mon(Kind),
            IsCollecting = lists:keyfind(RoleId, 1, Clist),
            if
                IsCanCollect == false ->
                    {next_state, sleep, State};
                IsCollecting == false ->
                    {next_state, sleep, State};
                true ->
                    RemainClTimes = CollectCount - CollectTimes,
                    NClist = lists:keydelete(RoleId, 1, Clist),
                    case RemainClTimes - length(NClist) > 0 of
                        true ->
                            Args = [{has_cltimes, 1}];
                        false ->
                            Args = []
                    end,
                    if
                        NClist =/= [] ->
                            lib_scene_object:update(Object, Args);
                        true ->
                            lib_scene_object:update(Object, [{is_collecting, 0}|Args])
                    end,
                    {next_state, sleep, State#ob_act{clist = NClist}}
            end
    end;

%% 玩家离开场景(复活，切场景之类)
do_handle_info({'leave', RoleId, _RolePid, _Sign}, StateName, State) ->
    #ob_act{
        object=Object, bl_who = BLWhos, bl_who_ref = BLWhosRef, bl_who_die_ref = BlWhoDieRefL, klist = KList, ref = Ref,
        first_att = FirstAttr, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case Object#scene_object.type == 1 of
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
                    % ?MYLOG("hjhmon", "NewDels:~p ~n", [NewDels]),
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, NewDels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} =
                        lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                    lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                    Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                    {next_state, StateName, State#ob_act{ref = Ref1, bl_who_ref = NewBLWhosRef, bl_who_die_ref = NewBlWhoDieRefL,
                        bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist}}
            end;
        false ->
            {next_state, sleep, State}
    end;

%% 玩家死亡
do_handle_info({'player_die', RoleId, MonAtter, SceneBossTired, VipType, VipLv, IsHurtMon}, StateName, State) ->
    #ob_act{assist_list = AssistDataList} = State,
    NewMonAtter = ?IF(is_record(MonAtter, mon_atter),
        MonAtter#mon_atter{assist_ex_id = lib_mon_util:get_assist_ex_id(MonAtter#mon_atter.assist_id, AssistDataList)},
        MonAtter),
    lib_mon_mod:player_die(State, StateName, RoleId, NewMonAtter, SceneBossTired, VipType, VipLv, IsHurtMon);

%% 归属玩家死亡定时器
do_handle_info({'bl_who_die_ref', RoleId}, StateName, State) ->
    lib_mon_mod:bl_who_die_ref(State, StateName, RoleId);

%% 抢夺归属权
do_handle_info({'rob_mon_bl', Node, RoleId}, StateName, State) ->
    lib_mon_mod:rob_mon_bl(State, StateName, Node, RoleId);

%% 抢夺归属权
do_handle_info({'rob_mon_bl_success', MonAtter, RobbedId, WinCode, WinHp}, StateName, State) ->
    lib_mon_mod:rob_mon_bl_success(State, StateName, MonAtter, RobbedId, WinCode, WinHp);

%% 移除玩家的boss归属
%% bl_who_ref 定时器触发,追踪范围,清理不在本场景的玩家
do_handle_info({'remove_bl_who', RoleId}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_ref = OBLWhosRef} = State,
    #scene_object{ scene = Scene, scene_pool_id = PoolId, aid = Aid, copy_id = _CopyId,
                   d_x = Dx, d_y = Dy, x = X, y = Y, mon = Mon, tracing_distance = TracingDistance} = Object,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        BLWhos == [] orelse not DropBoss ->
            {next_state, StateName, State};
        true ->
            case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                false ->
                    {next_state, StateName, State#ob_act{bl_who_ref = lists:keydelete(RoleId, 1, OBLWhosRef)}};
                _ ->
                    case lists:keyfind(RoleId, 1, OBLWhosRef) of
                        false ->
                            {next_state, StateName, State};
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
    %% io:format("~p ~p Args:~w~n", [?MODULE, ?LINE, [real_remove_bl_who]]),
    #ob_act{
        object=Object, bl_who = BLWhos, klist = KList, ref = Ref, bl_who_ref = BLWhosRef, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My, mon = Mon} = Object,
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        BLWhos == [] orelse not DropBoss-> {next_state, StateName, State};
        true ->
            case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                false -> {next_state, StateName, State};
                E ->
                    if
                        User =/= [] -> {next_state, StateName, State}; %% 归属者还存在
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
                            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                            {next_state, StateName, State#ob_act{ref = Ref1, bl_who_ref = NewBLWhosRef,
                                                                bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist}}
                    end
            end
    end;

do_handle_info({'send_mon_own_info', Node, Sid}, StateName, State) ->
    Info = lib_mon_mod:get_mon_own_info(State),
    {ok, BinData} = pt_200:write(20021, Info),
    lib_server_send:send_to_uid(Node, Sid, BinData),
    {next_state, StateName, State};

do_handle_info({'send_hurt_info', Node, RoleId}, StateName, State) ->
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
    % ?MYLOG("hjhhurt", "ConfigId:~p send_hurt_info List:~w ~n", [ConfigId, Klist]),
    {ok, BinData} = pt_120:write(12025, [Id, ConfigId, List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {next_state, StateName, State};

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
            {HpAiState, HpAiStateName} = lib_mon_ai:hp_change(Hp, NewHp, State1, StateName),
            {next_state, HpAiStateName, HpAiState};
        true ->
            {next_state, StateName, State}
    end;

%% 移除彻底休眠状态
do_handle_info({'remove_thorough_sleep', NextStateName}, StateName, State) ->
    #ob_act{ref = Ref, path = MonPath} = State,
    if
        StateName =/= thorough_sleep -> {next_state, StateName, State};
        % 没有移动路径就进入睡眠
        NextStateName == walk andalso MonPath == [] ->
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, sleep, State#ob_act{ref=Ref1}};
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, NextStateName, State#ob_act{ref=Ref1}}
    end;

do_handle_info({'send_collectors_of_mon', Node, RoleId}, StateName, State) ->
    #ob_act{clist = Clist} = State,
    List = [CollectorId||{CollectorId, _CollectorPid, _Time} <- Clist],
    %?PRINT("send_collectors_of_mon List:~w ~n", [List]),
    {ok, BinData} = pt_200:write(20025, [List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {next_state, StateName, State};

do_handle_info({'check_walk'}, StateName, State) ->
    #ob_act{object=Object, walk_type = WalkType, walk_ref = OldWalkRef, walk_time = WalkTime} = State,
    #scene_object{id=ObjectId, scene = Scene, scene_pool_id = PoolId} = Object,
    mod_scene_agent:apply_cast_with_state(Scene, PoolId, lib_mon_ai, check_walk, [ObjectId, WalkType]),
    WalkRef = util:send_after(OldWalkRef, max(WalkTime, 100), Object#scene_object.aid, {'check_walk'}),
    NewState = State#ob_act{walk_ref = WalkRef},
    {next_state, StateName, NewState};

do_handle_info({'check_walk_back', OldWalkType, CanWalk}, StateName, State) ->
    #ob_act{ref = Ref, path = Path, walk_type = WalkType, can_walk = OldCanWalk} = State,
    if
        % 是否能走路
        WalkType == OldWalkType -> NewCanWalk = CanWalk;
        true -> NewCanWalk = OldCanWalk
    end,
    if
        Path == [] orelse StateName == thorough_sleep orelse NewCanWalk == false ->
            {next_state, StateName, State#ob_act{can_walk = NewCanWalk}};
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, walk, State#ob_act{can_walk = NewCanWalk, ref=Ref1}}
    end;

%% 协助id变化
do_handle_info({'assist_change', AssistId, RoleIdList}, StateName, State)->
    #ob_act{object=Object, bl_who = BLWhos, klist = KList, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    case Object#scene_object.type == 1 of
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
                   {next_state, StateName, State}
            end;
        false ->
            {next_state, StateName, State}
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

do_handle_info({'gm_statistics', DestPid}, StateName, State) ->
    #ob_act{object = Object} = State,
    #scene_object{config_id = ConfigId, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = Object,
    DestPid ! {'gm_statistics', ConfigId, SceneId, ScenePoolId, CopyId},
    {next_state, StateName, State};


do_handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(normal, _StateName, _Status) ->
    cancle_special_event(_Status),
    ok;
terminate(Reason, _StateName, _Status) ->
    cancle_special_event(_Status),
    Minfo = _Status#ob_act.object,
    ?ERR("mod_mon_active error_terminate:SceneId:~p, CopyId:~p,~n ConfigId:~p~n Reason:~p~n",
        [Minfo#scene_object.scene, Minfo#scene_object.copy_id, Minfo#scene_object.config_id, Reason]),
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.

%% =========处理怪物所有状态=========
%%返回默认出生点
back(_R, State) ->
    #ob_act{object = Minfo, ref = Ref, first_att = FirstAttr, klist=Klist, back_dest_path=BackDestPath, path = Path} = State,
    #scene_object{battle_attr=BA, x = X, y = Y, mon=#scene_mon{d_x = Dx, d_y = Dy, boss=Boss, kind = Kind}} = Minfo,
    State1 = cancle_special_event(State),
    case BA#battle_attr.hp =< 0 of
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, dead, State1#ob_act{att = undefined, ref=Ref1, back_dest_path=null}};
        false ->
            if
                Kind =:= ?MON_KIND_ATT orelse Kind =:= ?MON_KIND_ATT_NOT_PLAYER orelse Kind =:= ?MON_KIND_ATT_TO_PLAYER ->
                    util:cancel_timer(Ref),
                    if
                        Path =:= [] ->
                            lib_mon_mod:find_target_cast(Minfo),
                            {next_state, sleep, State1#ob_act{ref = [], att = undefined}};
                        true ->
                            walk(repeat, State1#ob_act{ref = [], att = undefined})
                    end;
                % 如果还有路,则继续走
                Path =/= [] ->
                    walk(repeat, State1#ob_act{ref = [], att = undefined});
                true ->
                    ReturnPath = case BackDestPath of
                        null -> lib_scene_object_ai:dest_path(X, Y, Dx, Dy, BA#battle_attr.speed);
                        _ -> BackDestPath
                    end,
                    case ReturnPath of
                        [] ->
                            Klist1 = case Boss > 0 of true -> Klist; false -> [] end,
                            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                            FirstAttr1 = ?IF(?IS_DROP_BOSS(Boss), FirstAttr, []),
                            {next_state, sleep, State1#ob_act{att = undefined, first_att = FirstAttr1, back_dest_path=null, klist=Klist1, ref=Ref1}};
                        [{NextX, NextY}|T] ->
                            {NewMinfo, Time} = lib_scene_object_ai:move_dest_path(Minfo, X, Y, NextX, NextY),
                            Ref1 = lib_scene_object:send_event_after(Ref, Time, repeat),
                            {next_state, back, State1#ob_act{att=undefined, ref=Ref1, object=NewMinfo, back_dest_path=T}}
                    end
            end
    end.

%%静止状态并回血
sleep(_Msg, State) ->
    % State1 = cancle_special_event(State),
    #ob_act{object=Object, ref=Ref, bl_who = BLWho, klist = Klist, hurt_remove_ref = HurtRemoveRef} = State,
    #scene_object{
        id = Id, aid = Pid, x = X, y = Y, copy_id = CopyId, scene = SceneId, scene_pool_id = ScenePoolId,
        no_battle_hp_ex=NoBattleHpEx, hp_time=HpTime, battle_attr=BA, mon= #scene_mon{kind = Kind, boss = Boss}
        } = Object,
    DropBoss = ?IS_DROP_BOSS(Boss),
    if
        %% 塔防怪和进击怪一闲下来就尝试去找目标
        Kind =:= ?MON_KIND_ATT orelse Kind =:= ?MON_KIND_TOWER_DEF orelse Kind =:= ?MON_KIND_ATT_NOT_PLAYER orelse Kind =:= ?MON_KIND_ATT_TO_PLAYER ->
            lib_mon_mod:find_target_cast(Object);
        true ->
            skip
    end,
    % ?PRINT("BlWhos:~p ~n NoBattleHpEx:~p ~n", [BLWho, NoBattleHpEx]),
    if
        % 检查清理归属
        DropBoss andalso (BLWho =/= [] orelse Klist =/= []) ->
            lib_mon_mod:find_target_cast(Object),
            util:cancel_timer(HurtRemoveRef),
            NewHurtRemoveRef = erlang:send_after(50, Pid, {'hurt_remove'}),
            {next_state, sleep, State#ob_act{hurt_remove_ref = NewHurtRemoveRef}};
        % BA#battle_attr.hp < BA#battle_attr.hp_lim andalso NoBattleHpEx > 0 andalso BLWho == [] andalso Msg =/= sleep_resume ->
        %     Ref1 = lib_scene_object:send_event_after(Ref, 6*1000, sleep_resume),
        %     {next_state, sleep, NewState#ob_act{ref=Ref1}};
        BA#battle_attr.hp < BA#battle_attr.hp_lim andalso NoBattleHpEx > 0 andalso BLWho == [] ->
            Ref1 = lib_scene_object:send_event_after(Ref, HpTime, repeat),
            case is_integer(NoBattleHpEx) of
                true -> Hp = min(BA#battle_attr.hp+NoBattleHpEx, BA#battle_attr.hp_lim);
                false -> Hp = min(round(BA#battle_attr.hp+BA#battle_attr.hp_lim*NoBattleHpEx), BA#battle_attr.hp_lim)
            end,
            {Object1, NewState, _, UpList} = lib_mon_util:set_mon([{hp, Hp}], Object, State, sleep, 1, []),
            {ok, BinData} = pt_120:write(12009, [Id, Hp, BA#battle_attr.hp_lim]),
            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, X, Y, BinData),
            lib_scene_object:update(Object1, UpList),
            % {next_state, sleep, NewState#ob_act{ref=Ref1, object = Object1, hurt_remove_ref = []}};
            {next_state, sleep, NewState#ob_act{ref=Ref1, object = Object1}};
        true ->
            {next_state, sleep, State}
    end.

%% 彻底休眠状态，只接受死亡信息
thorough_sleep(_R, State) ->
    {next_state, thorough_sleep, State}.

%% 死亡
dead(_R, State) ->
    #ob_act{object=Object, ref=Ref, bl_who_ref = BlWhosRef, bl_who = BlWhos, hurt_remove_ref = HurtRef, bl_who_assist = BlWhosAssist} = State,
    #scene_object{
        id=ObjectId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My,
        mon=#scene_mon{retime=ReTime, boss = Boss}
        } = Object,
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
            util:cancel_timer(Ref),
            lib_scene_object:stop(Object, 1),
            {stop, normal, State};
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, ReTime, repeat),
            {next_state, revive, State#ob_act{back_dest_path=null, ref=Ref1}}
    end.

%% 复活
revive(_R, State) ->
    #ob_act{object = Minfo, ref=Ref} = State,
    util:cancel_timer(Ref),
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
    {next_state, sleep, NewState}.

is_continue_trace(Dx, Dy, Tx, Ty, TracingDistance) ->
    abs(Dx-Tx) =< TracingDistance andalso abs(Dy-Ty) =< TracingDistance.


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


%% 追踪
trace(Msg, State) ->
%%    ?PRINT("Msg:~w~n", [Msg]),
    #ob_act{att=Att, object=Minfo, next_move_time=NextMoveTime, ref=Ref} = State,
    #scene_object{scene = SceneId, scene_pool_id = ScenePoolId, aid = Aid} = Minfo,
    case Att of
        undefined -> %% 目标丢失，尝试等待
            Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 6000, repeat),
            {next_state, back, State#ob_act{ref=Ref1}};
        #{id:=Id, sign:=Sign} -> %% 有目标
%%            ?PRINT("Id:~p~n", [Id]),
            case catch utime:longunixtime() of %% 停服会产生报错输出，先暂时容错，后续优化
                {'EXIT', _R} ->
                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent,
                                               get_trace_info_cast, [Aid, Sign, Id, Msg]),
                    Ref1 = lib_scene_object:send_event_after(Ref, 5000, repeat),
                    {next_state, back, State#ob_act{ref = Ref1}};
                NowTime ->
                    if
                        NextMoveTime > NowTime ->
                            Ref1 = lib_scene_object:send_event_after(Ref, NextMoveTime-NowTime, Msg),
                            {next_state, trace, State#ob_act{ref = Ref1}};
                        true ->
                            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent,
                                                       get_trace_info_cast, [Aid, Sign, Id, Msg]),
                            Ref1 = lib_scene_object:send_event_after(Ref, 5000, repeat),
                            {next_state, back, State#ob_act{ref = Ref1}}
                    end
            end
    end.

%% 走路
walk(_R, State) ->
    #ob_act{object=Minfo, path=MonPath, ref=Ref, can_walk = CanWalk, check_block = CheckBlock} = State,
    #scene_object{scene = MSceneId, battle_attr= BA, x = X, y = Y, mon = #scene_mon{kind = Kind}} = Minfo,
    % ?MYLOG("hjh", "walk Id:~p CanWalk:~p ~n", [Minfo#scene_object.id, CanWalk]),
    if
        % 为空
        MonPath == [] ->
            lib_mon_event:move_end(Minfo),
            {NewState, NewStateName} = lib_mon_ai:walk_end(State, back),
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, NewStateName, NewState#ob_act{ref = Ref1}};
        % 不能走路
        CanWalk == false ->
            {next_state, sleep, State};
        true ->
            [WPoint|RemainPath] = MonPath,
            case WPoint of
                {SceneId, NextX, NextY} ->
                    ok;
                {NextX, NextY} ->
                    SceneId = MSceneId
            end,
            case SceneId =/= MSceneId of
                true ->
                    %% 切换怪物场景
                    NewMinfo = Minfo#scene_object{scene = SceneId, x = NextX, y = NextY},
                    %% 消失
                    lib_scene_object:stop(Minfo, 1),
                    %% 有怪物进入
                    lib_scene_object:insert(NewMinfo),
                    lib_scene_object:broadcast_object(NewMinfo),

                    Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                    {next_state, walk, State#ob_act{object=NewMinfo, ref=Ref1, path=RemainPath, w_point = {NextX, NextY}}};
                false -> %% 继续走
                    #battle_attr{speed=Speed} = BA,
                    NowTime = utime:longunixtime(),
                    if
                        Kind =:= ?MON_KIND_ATT orelse Kind =:= ?MON_KIND_ATT_NOT_PLAYER orelse Kind =:= ?MON_KIND_ATT_TO_PLAYER ->
                            lib_mon_mod:find_target_cast(Minfo);
                        true ->
                            ok
                    end,
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        {false, MoveWaitMs} ->
                            Ref1 = lib_scene_object:send_event_after(Ref, MoveWaitMs, repeat),
                            {next_state, walk, State#ob_act{ref=Ref1}};
                        false ->
                            {next_state, sleep, State#ob_act{att=undefined}};
                        true ->
                            case lib_scene_object_ai:move(NextX, NextY, Minfo, Speed, CheckBlock) of
                                block ->
                                    Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                                    {next_state, sleep, State#ob_act{ref=Ref1, path=[]}};
                                {true, NewMinfo, Time} ->
                                    lib_mon_event:move(NewMinfo),
                                    Ref1 = lib_scene_object:send_event_after(Ref, Time, repeat),
                                    % 警戒区目前不改变,看后面的需求
                                    % lib_scene_object:change_ai(Aid, SceneId, ScenePoolId, CopyId, X, Y, WaringRange, OX, OY),
                                    {next_state, walk, State#ob_act{object=NewMinfo, ref=Ref1, path=RemainPath, o_point = {X, Y}, w_point = {NextX, NextY}}}
                            end
                    end
            end
    end.

%%取消事件
cancle_special_event(State) ->
    {LastState, _} = lib_mon_ai:resume(State),
    LastState.
