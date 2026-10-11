%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-23
%% @deprecated 副本事件处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_event).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("rec_event.hrl").


%% ----------------------------------------------------
%% 派发处理
%% ----------------------------------------------------

%% 派发副本事件
dispatch_dungeon_event(State, EventTypeId, EventData) ->
    % ?PRINT("dispatch_dungeon_event ~n", []),
    EventCallback = #event_callback{type_id = EventTypeId, data = EventData},
    NewState = handle_event(State, EventCallback),
    case handle_callback(NewState) of
        nothing -> {noreply, NewState};
        Result -> Result
    end.

%% 击杀怪物
kill_mon(State, _AutoId, Mid, _DieSign, CreateKey, _OwnId, DieDatas) ->
    % ?PRINT("kill_mon CreateKey:~p, Mid:~p ~n", [CreateKey, Mid]),
    event_mon_die(State, Mid, CreateKey, DieDatas, killed).

%% 事件怪物死亡处理
event_mon_die(State, Mid, CreateKey, DieDatas, Reason) ->
    EventCallback = #event_callback{
        type_id = ?DUN_EVENT_TYPE_ID_KILL_MON
        , data = #dun_callback_kill_mon{create_key = CreateKey, mon_id = Mid}
        },
    #dungeon_state{dun_type = DunType} = State,
    NewState = lib_dungeon_mon_event:kill_mon(State, CreateKey, Mid, Reason),
    NewState1 = lib_dungeon_mon_event:handle_who_kill_mon(NewState, Mid, DieDatas),
    NewState2 =
    case lib_dungeon_api:invoke(DunType, dunex_handle_kill_mon, [NewState1, Mid, CreateKey, DieDatas], NewState1) of
        TmpState when is_record(TmpState, dungeon_state) ->
            TmpState;
        _ ->
            NewState1
    end,
    NewState3 = handle_event(NewState2, EventCallback),
    case handle_callback(NewState3) of
        nothing -> {noreply, NewState3};
        Result -> Result
    end.

%% 停止伙伴
stop_mon(State, _AutoId, Mid, _Sign, CreateKey, _OwnId, _Hp, _HpLim) ->
    event_mon_die(State, Mid, CreateKey, [], stoped).

%% 玩家死亡
player_die(State, _RoleId, _HpLim) ->
    #dungeon_state{scene_helper = #dungeon_scene_helper{hp_rate_list = HpRateList}} = State,
    {noreply, StateAfDieCount} = dispatch_dungeon_event(State, ?DUN_EVENT_TYPE_ID_DIE_COUNT, #dun_callback_die{role_id = _RoleId}),
    {noreply, StateAfHpRate} = case lists:member(0, HpRateList) of
        true ->
            dispatch_dungeon_event(StateAfDieCount, ?DUN_EVENT_TYPE_ID_ROLE_HP, #dun_callback_role_hp{hp_rate_list = [0]});
        false ->
            {noreply, StateAfDieCount}
    end,
    case lib_dungeon_mod:player_die_without_revive(StateAfHpRate) of
        true ->
            dispatch_dungeon_event(StateAfHpRate, ?DUN_EVENT_TYPE_ID_DIE_WITHOUT_REVIVE, []);
        _ ->
            {noreply, StateAfHpRate}
    end.

%% 派发时间事件
dispatch_event_time(State, EventTime) ->
    NewState = handle_event_time(State, EventTime),
    case handle_callback(NewState) of
        nothing ->
            NewState2 = lib_dungeon_mod:calc_ref(NewState),
            {noreply, NewState2};
        Result ->
            Result
    end.

%% 处理回调
%% {noreply, State} | nothing
handle_callback(State) ->
    if
        State#dungeon_state.is_end == ?DUN_IS_END_YES -> nothing;
        State#dungeon_state.is_level_end == ?DUN_IS_LEVEL_END_YES -> nothing;
        State#dungeon_state.callback_type == ?DUN_CALLBACK_TYPE_RESULT ->
            % ?PRINT("handle_callback :~p ~n", [State#dungeon_state.callback_type]),
            do_handle_call_back(State#dungeon_state.callback_args, State);
        true ->
            nothing
    end.

do_handle_call_back({'dungeon_result', CommonEvent}, State) ->
    %% 清理玩家并且发放奖励
    lib_dungeon_mod:dungeon_result(State, CommonEvent);
do_handle_call_back(_, State) ->
    {noreply, State}.

%% ----------------------------------------------------
%% 处理触发因子(不会结算的,要调用handle_callback回调才行)
%% ----------------------------------------------------

%% 处理时间事件
handle_event_time(State, EventTime) ->
    % ?PRINT("handle_event_time ~n", []),
    EventCallback = #event_callback{type_id = ?DUN_EVENT_TYPE_ID_TIME, data = #dun_callback_time{event_time = EventTime} },
    handle_event(State, EventCallback).

%% 处理对应怪物事件配置ID的怪全部被杀死
handle_mon_event_id_kill_all_mon(State, CommonEvent) ->
    % ?PRINT("handle_mon_event_id_kill_all_mon MonEventId:~p ~n", [MonEventId]),
    #dungeon_common_event{id = MonEventId, args = Args, first_time = FirstTime} = CommonEvent,
    #dungeon_state{dun_type = DunType} = State,
    State1 = lib_dungeon_api:invoke(DunType, dunex_mon_event_id_kill_all_mon, [State, CommonEvent], State),
    #dungeon_state{dun_id = DunId, dun_type = DunType, wave_num = CurWave, role_list = RoleList} = State1,
    WavePassTime = ?IF(FirstTime>0, utime:unixtime() - FirstTime, 0),
    % 通知玩家完成的当前波数
%%    ?MYLOG("dundragon", "~p~n", [Args]),
    case lists:keyfind(wave_no, 1, Args) of
        false -> NewState2 = State1;
        {wave_no, NewCurWave} when NewCurWave > CurWave ->
            NewCurWave2 = NewCurWave,
            if
                DunType == ?DUNGEON_TYPE_DRAGON ->
                    RoleMsgList = [{RoleId, Figure#figure.name, Power, ServerNum, ServerId}||
                        #dungeon_role{id = RoleId, figure = Figure, combat_power = Power, server_id = ServerId, server_num = ServerNum}<-RoleList],
%%                    ?MYLOG("dundragon", "~p~n", [{NewCurWave2, WavePassTime}]),
                    NewState = lib_dungeon_mod:finish_wave(State1, NewCurWave2, WavePassTime),
                    mod_dun_dragon_rank_cluster:finish_one_wave(DunId, NewCurWave2, WavePassTime, RoleMsgList);
                true ->
                    NewState = State1
            end,
            NewState2 = NewState#dungeon_state{wave_num = NewCurWave2},
            lib_dungeon_mod:send_info(NewState2);
        {wave_no, NewCurWave2} ->
            if
                DunType == ?DUNGEON_TYPE_DRAGON ->
%%                    ?MYLOG("dundragon", "~p~n", [{NewCurWave2, WavePassTime}]),
                    RoleMsgList = [{RoleId, Figure#figure.name, Power, ServerNum, ServerId}||
                        #dungeon_role{id = RoleId, figure = Figure, combat_power = Power, server_id = ServerId, server_num = ServerNum}<-RoleList],
                    NewState = lib_dungeon_mod:finish_wave(State1, NewCurWave2, WavePassTime),
                    mod_dun_dragon_rank_cluster:finish_one_wave(DunId, NewCurWave2, WavePassTime, RoleMsgList);
                true ->
                    NewState = State1
            end,
            NewState2 = NewState;
        _ ->
            NewState2 = State1
    end,
    EventCallback = #event_callback{
        type_id = ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_KILL_ALL_MON
        , data = #dun_callback_mon_event_id_kill_all_mon{kill_mon_event_id = MonEventId}
        },
    handle_event(NewState2, EventCallback).

%% 处理对应怪物事件配置ID的触发元素全部触发
handle_mon_event_id_finish(State, MonEventId) ->
    % ?PRINT("handle_mon_event_id_finish MonEventId:~p ~n", [MonEventId]),
    #dungeon_state{dun_type = DunType} = State,
    State1 = lib_dungeon_api:invoke(DunType, dunex_mon_event_id_finish, [State, MonEventId], State),
    EventCallback = #event_callback{
        type_id = ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_FINISH
        , data = #dun_callback_mon_event_id_finish{mon_event_id = MonEventId}
        },
    handle_event(State1, EventCallback).

%% 跳过副本
handle_skip_dungeon(State) ->
    % ?PRINT("handle_skip_dungeon DUN_EVENT_TYPE_ID_SKIP_DUNGEON~n", []),
    EventCallback = #event_callback{type_id = ?DUN_EVENT_TYPE_ID_SKIP_DUNGEON},
    handle_event(State, EventCallback).

%% 主动退出副本
handle_active_quit(State) ->
    % ?PRINT("handle_active_quit DUN_EVENT_TYPE_ID_ACTIVE_DUNGEON~n", []),
    EventCallback = #event_callback{type_id = ?DUN_EVENT_TYPE_ID_ACTIVE_QUIT},
    handle_event(State, EventCallback).

%% 登出
handle_logout(State) ->
    % ?PRINT("handle_logout DUN_RESULT_SUBTYPE_LOGOUT~n", []),
    EventCallback = #event_callback{type_id = ?DUN_EVENT_TYPE_ID_LOGOUT},
    handle_event(State, EventCallback).

%% 延迟登出
% handle_delay_logout(State, RoleId, DelayLogoutTime) ->
%     % ?PRINT("handle_delay_logout DUN_EVENT_TYPE_ID_DELAY_LOGOUT~n", []),
%     EventCallback = #event_callback{type_id = ?DUN_EVENT_TYPE_ID_DELAY_LOGOUT,
%                                     data = #dun_callback_delay_logout{role_id = RoleId, delay_logout_time = DelayLogoutTime}
%                                    },
%     handle_event(State, EventCallback).

%% 延迟登出定时器
% handle_delay_logout_ref(State, RoleId, DelayLogoutTime, EventTime) ->
%     % ?PRINT("handle_delay_logout_ref DUN_EVENT_TYPE_ID_DELAY_LOGOUT~n", []),
%     EventCallback = #event_callback{
%         type_id = ?DUN_EVENT_TYPE_ID_DELAY_LOGOUT
%         , data = #dun_callback_delay_logout_ref{role_id = RoleId, delay_logout_time = DelayLogoutTime, event_time = EventTime}
%         },
%     handle_event(State, EventCallback).

%% 处理波数刷出
handle_wave_subtype_refresh(State, CommonEventId, WaveSubtype) ->
    #dungeon_state{dun_type = DunType} = State,
    State1 = lib_dungeon_api:invoke(DunType, dunex_handle_wave_subtype_refresh, [State, CommonEventId, WaveSubtype], State),
    EventCallback = #event_callback{
        type_id = ?DUN_EVENT_TYPE_ID_WAVE_SUBTYPE_REFRESH
        , data = #dun_callback_wave_subtype_refresh{mon_event_id = CommonEventId, wave_subtype = WaveSubtype}
        },
    handle_event(State1, EventCallback).

%% 通用处理
handle_event(State, #event_callback{type_id = EventTypeId} = EventCallback) ->
    #dungeon_state{now_scene_id = NowSceneId, group_map = GroupMap} = State,
    GroupList = maps:get({NowSceneId, EventTypeId}, GroupMap, []),
    do_handle_event(GroupList, State, EventCallback).

do_handle_event([], State, _EventCallback) -> State;
do_handle_event([{BelongType, CommonEventId, EventId}|L], State, EventCallback) ->
    if
        State#dungeon_state.is_end == ?DUN_IS_END_YES -> State;
        true ->
            NewState = lib_dungeon_common_event:handle_event(State, BelongType, CommonEventId, EventId, EventCallback),
            do_handle_event(L, NewState, EventCallback)
    end.

%% ----------------------------------------------------
%% 其他
%% ----------------------------------------------------

%% 输出
print_sub_group_map() -> ok.

%% 拾取怪物
pick_mon(State, DungeonRole, Mid, Coord, Skill) ->
    NewState = lib_dungeon_mon_event:pick_mon(State, DungeonRole, Mid, Coord, Skill),
    {noreply, NewState}.
