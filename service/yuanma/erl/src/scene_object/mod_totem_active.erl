%%%-------------------------------------------------------------------
%%% @author J
%%% @email j-som@foxmail.com
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%     图腾
%%% @end
%%% Created : 28. 五月 2018 15:47
%%%-------------------------------------------------------------------
-module(mod_totem_active).
-include("scene.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("common.hrl").

-behaviour(gen_statem).

%% API
-export([start/1]).

%% gen_statem callbacks
-export([
    init/1,
    format_status/2,
    state_name/3,
    handle_event/4,
    terminate/3,
    code_change/4,
    callback_mode/0
]).

-define(SERVER, ?MODULE).

-record(totem, {
    clist = [],
    owner_list = [],
    ref,
    object,
    args = #{}
}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Creates a gen_statem process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start(Args) ->
    gen_statem:start(?MODULE, Args, []).

%%%===================================================================
%%% gen_statem callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_statem is started using gen_statem:start/[3,4] or
%% gen_statem:start_link/[3,4], this function is called by the new
%% process to initialize.
%%
%% @spec init([Id, ConfigId, Scene, ScenePoolId, Xpx, Ypx, CopyId, BroadCast, Args]) -> {CallbackMode, StateName, State} |
%%                     {CallbackMode, StateName, State, Actions} |
%%                     ignore |
%%                     {stop, StopReason}
%%      Args    :: [{Key, Value}]
%%      Key     :: hold_call | free_call...
%%      Valye   :: term()
%%          {hold_call, {M, F, A}}
%%          {free_call, {M, F, A}}
%% @end
%%--------------------------------------------------------------------
init([Id, ConfigId, Scene, ScenePoolId, Xpx, Ypx, _Type, CopyId, BroadCast, Args]) ->
    %% 当做一只怪物来处理
    #mon{
        id=Mid, name=Name, color=Color, type=Type, kind = Kind,
        icon=Icon, icon_effect=IconEffect, icon_texture=IconTextrue, lv=Lv,
%%            hit=Hit, dodge=Dodge, crit=Crit,  hp_lim=Hp, def = Def, ten = Ten, wreck = Wreck, special_attr = SpecailAttr,
        striking_distance=StrikingDistance, tracing_distance=TracingDistance,  warning_range = WarningRange,
%%            att_time=AttTime, att_type=AttType, retime=ReTime, is_fight_back=IsFightBack, is_be_atted=IsBeAtt,
        is_be_clicked = IsBeClicked, collect_time = CollectTime,
        collect_count=CollectCount
    } = data_mon:get(ConfigId),
    Pid = self(),
    Figure      = #figure{name=Name, body=Icon, lv=Lv},
    SceneMon    = #scene_mon{d_x=Xpx, d_y=Ypx, mid=Mid, kind=Kind, collect_time = CollectTime,
        collect_count=CollectCount},
    SceneObject = #scene_object{
        sign=?BATTLE_SIGN_MON, id=Id, config_id=Mid, scene=Scene, scene_pool_id=ScenePoolId,
        copy_id=CopyId, x=Xpx, y=Ypx, type=Type, figure=Figure, color=Color, battle_attr = #battle_attr{},
        icon_effect=IconEffect, icon_texture=IconTextrue, striking_distance=StrikingDistance,
        tracing_distance=TracingDistance, warning_range = WarningRange, d_x=Xpx,
        d_y=Ypx, is_be_atted=0, is_be_clicked = IsBeClicked, aid=Pid, mon=SceneMon
    },
    %% 怪物出生ai
    %% 在场景进程中保存怪物信息
    lib_scene_object:insert(SceneObject),
    %% 广播怪物
    case BroadCast  of
        ?BROADCAST_0 -> skip;
        %% _ when Mon1#scene_object.mon#scene_mon.visible == 0 ->
        %% skip;
        _ ->
            lib_scene_object:broadcast_object(SceneObject)
    end,
    Totem = #totem{object = SceneObject, args = maps:from_list(Args)},
%%    ?ERR("totem init ~p~n", [[ConfigId, Scene, ScenePoolId, CopyId, Xpx/60, Ypx/30]]),
    {ok, sleep, Totem}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_statem when it needs to find out 
%% the callback mode of the callback module.
%%
%% @spec callback_mode() -> atom().
%% @end
%%--------------------------------------------------------------------
callback_mode() ->
    handle_event_function.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Called (1) whenever sys:get_status/1,2 is called by gen_statem or
%% (2) when gen_statem terminates abnormally.
%% This callback is optional.
%%
%% @spec format_status(Opt, [PDict, StateName, State]) -> term()
%% @end
%%--------------------------------------------------------------------
format_status(_Opt, [_PDict, StateName, _State]) ->
    StateName.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name.  If callback_mode is statefunctions, one of these
%% functions is called when gen_statem receives and event from
%% call/2, cast/2, or as a normal process message.
%%
%% @spec state_name(Event, From, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Actions} |
%%                   {stop, Reason, NewState} |
%%    				 stop |
%%                   {stop, Reason :: term()} |
%%                   {stop, Reason :: term(), NewData :: data()} |
%%                   {stop_and_reply, Reason, Replies} |
%%                   {stop_and_reply, Reason, Replies, NewState} |
%%                   {keep_state, NewData :: data()} |
%%                   {keep_state, NewState, Actions} |
%%                   keep_state_and_data |
%%                   {keep_state_and_data, Actions}
%% @end
%%--------------------------------------------------------------------
state_name(_EventType, _EventContent, State) ->
    NextStateName = next_state,
    {next_state, NextStateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%%
%% If callback_mode is handle_event_function, then whenever a
%% gen_statem receives an event from call/2, cast/2, or as a normal
%% process message, this function is called.
%%
%% @spec handle_event(Event, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Actions} |
%%                   {stop, Reason, NewState} |
%%    				 stop |
%%                   {stop, Reason :: term()} |
%%                   {stop, Reason :: term(), NewData :: data()} |
%%                   {stop_and_reply, Reason, Replies} |
%%                   {stop_and_reply, Reason, Replies, NewState} |
%%                   {keep_state, NewData :: data()} |
%%                   {keep_state, NewState, Actions} |
%%                   keep_state_and_data |
%%                   {keep_state_and_data, Actions}
%% @end
%%--------------------------------------------------------------------
handle_event(info, {'collect_mon', CollectorId, CollectorNode, CollectorPid, Type, _ServerId}, StateName, State) ->
    #totem{object = Minfo, clist = Clist, owner_list = OwnerList, ref = Ref, args = TotemArgs} = State,
    case lists:keyfind(CollectorId, 1, OwnerList) of
        false ->
            Now   = utime:unixtime(),
            #scene_object{mon=Mon} = Minfo,
            #scene_mon{collect_time=CollectTime, collect_times = CollectTimes, collect_count=CollectCount} = Mon,
            RemainClTimes = CollectCount - CollectTimes,
            if
                Type == 1 ->
                    ClistLen = length(Clist),
                    case ClistLen + 1 =< RemainClTimes of
                        true ->
                            NewClist = [{CollectorId, CollectorPid, Now} | lists:keydelete(CollectorId, 1, Clist)],
                            case RemainClTimes - ClistLen == 1 of  %% 只剩最后一次
                                true -> Args = [{has_cltimes, 0}];
                                false -> Args = []
                            end,
                            lib_scene_object:update(Minfo, [{is_collecting, 1}|Args]),
                            {next_state, StateName, State#totem{clist = NewClist}};
                        false -> %% 如果怪物的剩余采集次数不足要进行提示
                            {ok, BinData} = pt_200:write(20008, ?IF(RemainClTimes == 0, 19, 13)),
                            lib_battle:rpc_cast_to_node(CollectorNode, lib_server_send, send_to_uid, [CollectorId, BinData]),
                            {next_state, StateName, State}
                    end;
                Type == 2 -> %% 结束采集
                    case lists:keyfind(CollectorId, 1, Clist) of
                        false -> {next_state, StateName, State};
                        {_, _, Time} ->
                            case Now - Time >= CollectTime of %% 毫米级别的控制
                                true ->
                                    %% 采集成功
                                    if
                                        is_reference(Ref) ->
                                            Ref1 = Ref;
                                        true ->
                                            Ref1 = erlang:send_after(2000, self(), trace)
                                    end,
                                    NewClist = lists:keydelete(CollectorId, 1, Clist),
                                    IsCollecting = ?IF(NewClist =/= [], 1, 0),
                                    case RemainClTimes =< 1 of  %% 只剩最后一次
                                        true -> Args = [{has_cltimes, {false, 19}}];
                                        false -> Args = []
                                    end,
                                    lib_scene_object:update(Minfo, [{is_collecting, IsCollecting}|Args]),
                                    NewOwnerList = [{CollectorId, CollectorPid, CollectorNode, Now}|OwnerList],
                                    case maps:find(hold_call, TotemArgs) of
                                        {ok, {M, F, A}} ->
                                            M:F(Minfo, A, [CollectorNode, CollectorId, CollectorPid]);
                                        _ ->
                                            ok
                                    end,
                                    NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{collect_times = CollectTimes + 1}},
                                    {next_state, trace, State#totem{object = NewMinfo, clist = NewClist, owner_list = NewOwnerList, ref = Ref1}};
                                false ->
                                    %% 采集时间不足
                                    {ok, BinData} = pt_200:write(20008, 5),
                                    lib_battle:rpc_cast_to_node(CollectorNode, lib_server_send, send_to_uid, [CollectorId, BinData]),
                                    NewClist = lists:keydelete(CollectorId, 1, Clist),
                                    case RemainClTimes - length(NewClist) > 0 of
                                        true -> Args = [{has_cltimes, 1}];
                                        false -> Args = []
                                    end,
                                    ?IF(NewClist =/= [], lib_scene_object:update(Minfo, Args),
                                        lib_scene_object:update(Minfo, [{is_collecting, 0}|Args])),
                                    {next_state, StateName, State#totem{clist = NewClist}}
                            end
                    end;
                true -> %% 其他情况都默认中断采集
                    case lists:keyfind(CollectorId, 1, Clist) of
                        false -> {next_state, StateName, State};
                        _ ->
                            NewClist = lists:keydelete(CollectorId, 1, Clist),
                            case RemainClTimes - length(NewClist) > 0 of
                                true -> Args = [{has_cltimes, 1}];
                                false -> Args = []
                            end,
                            ?IF(NewClist =/= [], lib_scene_object:update(Minfo, Args),
                                lib_scene_object:update(Minfo, [{is_collecting, 0}|Args])),
                            {next_state, StateName, State#totem{clist = NewClist}}
                    end
            end;
        _ ->
            {ok, BinData} = pt_200:write(20008, 4),
            lib_battle:rpc_cast_to_node(CollectorNode, lib_server_send, send_to_uid, [CollectorId, BinData]),
            {next_state, StateName, State}
    end;

handle_event(info, {'stop_collect', CollectorId, CollectorNode, StopperId}, StateName, State) ->
    case lists:keyfind(CollectorId, 1, State#totem.clist) of
        false->
            {next_state, StateName, State};
        _ ->
            #totem{clist = Clist, object = Minfo} = State,
            #scene_object{mon = Mon} = Minfo,
            NewClist = lists:keydelete(CollectorId, 1, Clist),
            IsCollecting = ?IF(NewClist =/= [], 1, 0),
            NewMinfo = Minfo#scene_object{mon=Mon#scene_mon{collect_times = length(NewClist), is_collecting = IsCollecting, has_cltimes = 1}},
            lib_scene_object:update(State#totem.object, [{is_collecting, IsCollecting},{has_cltimes, 1}]),
            {ok, BinData} = pt_200:write(20008, 14),
            {ok, BinData2} = pt_200:write(20026, StopperId),
            lib_server_send:send_to_uid(CollectorNode, CollectorId, <<BinData/binary, BinData2/binary>>),
            {next_state, StateName, State#totem{clist = NewClist, object = NewMinfo}}
    end;

handle_event(info, trace, StateName, State) ->
    #totem{owner_list = OwnerList, args = Args, object = Minfo} = State,
    #scene_object{
        scene = SceneId,
        scene_pool_id = ScenePoolId,
        warning_range = Distance,
        x = ObjectX,
        y = ObjectY,
        aid = Aid
    } = Minfo,
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_calc, check_user_in_range,
        [Aid, ObjectX, ObjectY, Distance, [Id || {Id, _, _, _} <- OwnerList]]),
    HoldTime = maps:get(hold_time, Args, 5),
    NowTime = utime:unixtime(),
    {TimeoutList, OtherList} = lists:partition(
        fun ({_, _, _, Time}) ->
            NowTime - Time > HoldTime
        end, OwnerList),
    if
        TimeoutList =:= [] ->
            NewMinfo = Minfo;
        true ->
            TimeoutCount = length(TimeoutList),
            #scene_object{mon=#scene_mon{collect_times = CollectTimes} = Mon} = Minfo,
            lib_scene_object:update(Minfo, [{has_cltimes, 1}]),
            case maps:find(free_call, Args) of
                {ok, {M1, F1, A1}} ->
                    [M1:F1(Minfo, A1, [Node, RoleId, Pid]) || {RoleId, Pid, Node, _} <- TimeoutList];
                _ ->
                    ok
            end,
            NewMinfo = Minfo#scene_object{mon = Mon#scene_mon{collect_times = max(0, CollectTimes - TimeoutCount)}}
    end,
    if
        OtherList =:= [] -> ok;
        true ->
            case maps:find(hold_call, Args) of
                {ok, {M2, F2, A2}} ->
                    [M2:F2(Minfo, A2, [Node, RoleId, Pid]) || {RoleId, Pid, Node, _} <- OtherList];
                _ ->
                    ok
            end
    end,
%%    NewOtherList = [{RoleId, Pid, NowTime} || {RoleId, Pid, _} <- OtherList],
    NewState = State#totem{owner_list = OtherList, object = NewMinfo},
    if
        OtherList =:= [] ->
            {next_state, sleep, NewState#totem{ref = undefined}};
        true ->
            Ref = erlang:send_after(2000, self(), trace),
            {next_state, StateName, NewState#totem{ref = Ref}}
    end;

handle_event(info, {check_user_in_range_res, UserIds}, StateName, State) ->
    #totem{owner_list = OwnerList, args = Args, object = Minfo} = State,
    NowTime = utime:unixtime(),
    F = fun({RoleId, Pid, Node, _} = X) ->
            case lists:member(RoleId, UserIds) of
                true ->
                    {RoleId, Pid, Node, NowTime};
                _ ->
                    case maps:find(miss_call, Args) of
                        {ok, {M, F, A}} ->
                            M:F(Minfo, A, [Node, RoleId, Pid]);
                        _ ->
                            ok
                    end,
                    X
            end
        end,
    NewOwnerList = [F(X) || X <- OwnerList],
    {next_state, StateName, State#totem{owner_list = NewOwnerList}};

handle_event(info, {'stop', _Broadcast}, _StateName, State) ->
    lib_mon_event:be_stop(State#totem.object),
    {stop, normal, State};


handle_event(info, 'die', _StateName, State) ->
%%    lib_mon_ai:die(State, none, StateName),
    {stop, normal, State};

handle_event(_EventType, _EventContent, StateName, State) ->
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_statem when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_statem terminates with
%% Reason. The return value is ignored.
%%
%% @spec terminate(Reason, StateName, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _StateName, State) ->
    #totem{args = Args, owner_list = OwnerList, object = Minfo, ref = Ref} = State,
    case maps:find(free_call, Args) of
        {ok, {M, F, A}} ->
            [M:F(Minfo, A, [Node, RoleId, Pid]) || {RoleId, Pid, Node, _} <- OwnerList];
        _ ->
            ok
    end,
%%    ?ERR("totem stoped ~p~n", [Minfo#scene_object.config_id]),
    util:cancel_timer(Ref),
    lib_scene_object:stop(Minfo, 1),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, StateName, State, Extra) ->
%%                   {ok, StateName, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
