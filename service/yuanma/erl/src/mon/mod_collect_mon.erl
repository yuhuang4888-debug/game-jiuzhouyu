%% ---------------------------------------------------------------------------
%% @doc mod_collect_mon

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/12/15
%% @deprecated  采集怪/拾取怪 进程
%% ---------------------------------------------------------------------------
-module(mod_collect_mon).

-behaviour(gen_statem).

%% API
-export([start/1]).
-export([idle/3, dead/3]).
-export([collect_mon/3, pick_mon/2, send_collectors_of_mon/3]).

%% gen_statem callbacks
-export([init/1, terminate/3, code_change/4, callback_mode/0]).


-include("common.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("figure.hrl").


start(Args) ->
    gen_statem:start_link(?MODULE, Args, [{spawn_opt, [{fullsweep_after, 100}]}]).

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

%% 获取怪物的采集者
send_collectors_of_mon(Aid, Node, PlayerId) ->
    Aid ! {'send_collectors_of_mon', Node, PlayerId}.


init([_Id, _MonId, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, BroadCast, Arg, M])->
    %% 配置转换为内存数据
    InitMon = lib_mon_util:base_to_cache([_Id, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, self()], M),
    %% 自定义创建参数初始化,这里会根据参数覆盖原来的属性根据
    {Mon, InitState, _, _} =
        lib_mon_util:set_mon(Arg, InitMon#scene_object{aid = self()}, #ob_act{}, null, ?BROADCAST_0, []),
    % 设置其他参数信息
    MonAfOther = lib_mon_util:set_mon_other(Mon, Arg),
    % 主动怪物寻找目标
    State = InitState#ob_act{object = MonAfOther, w_point = {Mon#scene_object.x, Mon#scene_object.y}},
    %% 在场景进程中保存怪物信息
    lib_scene_object:insert(MonAfOther),
    %% 广播怪物
    case BroadCast  of
        ?BROADCAST_0 -> skip;
        _ ->
            lib_scene_object:broadcast_object(MonAfOther)
    end,
    %% 怪物出生ai
    lib_mon_mod:born_handler(State),
    {ok, idle, State}.

callback_mode() ->
    [state_functions, state_enter].

idle(enter, idle, _State) ->
    keep_state_and_data;
idle(info, Msg, State) ->
    do_handle_info(Msg, idle, State);
idle(_EventType, _EventContent, _State) ->
    keep_state_and_data.

dead(enter, _StateName, State) ->
    #ob_act{object=SceneObject} = State,
    #scene_object{mon=#scene_mon{retime = ReTime}} = SceneObject,
    if
        ReTime =< 0 ->
            lib_scene_object:stop(SceneObject, 1),
            {stop, normal, State};
        true ->
            erlang:send_after(ReTime, self(), 'do_revive'),
            {next_state, dead, State#ob_act{back_dest_path=null}}
    end;
dead(info, 'do_revive', State) ->
    #ob_act{object = Minfo} = State,
    lib_scene_object:broadcast_object(Minfo),
    NewState = State#ob_act{clist = []},
    lib_mon_mod:revive_handler(NewState),
    {next_state, idle, NewState};
dead(info, Msg, State) ->
    do_handle_info(Msg, dead, State);
dead(_EventType, _Msg, _State) ->
    keep_state_and_data.

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
    #ob_act{object = Minfo, clist = Clist} = State,
    Now   = utime:unixtime(),
    #scene_object{scene =SceneId, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y, battle_attr=BA, mon=Mon} = Minfo,
    #scene_mon{kind=Kind, collect_time=CollectTime, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
    IsCanCollect = lib_mon_util:is_collect_mon(Kind),
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
                            NewStateName = dead, NewState = State#ob_act{object=NewMinfo};
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
    IsCanCollect = lib_mon_util:is_collect_mon(Kind),
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
    #ob_act{object = Minfo} = State,
    lib_mon_event:be_picked(Minfo, CollectorId),
    {AiState, _} = lib_mon_ai:die(State, none, _StateName),
    {next_state, dead, AiState};

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
            lib_scene_object:stop(State#ob_act.object, Broadcast),
            lib_mon_event:be_stop(State#ob_act.object),
            {stop, normal, State}
    end;

%% 玩家第一次进入场景
do_handle_info({'enter', RoleId, _RolePid, _Sign, _TeamId}, _StateName, State) ->
    #ob_act{object=Object, clist = Clist} = State,
    #scene_object{mon = Mon} = Object,
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
    end;

%% 玩家离开场景(复活，切场景之类)
do_handle_info({'leave', _RoleId, _RolePid, _Sign}, _StateName, State) ->
    {next_state, sleep, State};

do_handle_info({'send_collectors_of_mon', Node, RoleId}, _StateName, State) ->
    #ob_act{clist = Clist} = State,
    List = [CollectorId||{CollectorId, _CollectorPid, _Time} <- Clist],
    {ok, BinData} = pt_200:write(20025, [List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    keep_state_and_data;

do_handle_info(_Msg, _StateName, _State) ->
    keep_state_and_data.

terminate(_Reason, _StateName, _State) ->
    ok.

%% @private
%% @doc Convert process state when code is changed
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

