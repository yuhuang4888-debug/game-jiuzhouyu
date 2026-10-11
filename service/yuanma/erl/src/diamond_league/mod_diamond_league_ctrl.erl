%%-----------------------------------------------------------------------------
%% @Module  :       mod_diamond_league_ctrl.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-17
%% @Description:    星钻联盟时间控制器
%%-----------------------------------------------------------------------------
-module (mod_diamond_league_ctrl).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("def_module.hrl").
-include ("counter_global.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,gm_next/0
    ,get_cur_state/1
    ,cancel/0
    ,fix_the_cycle_index/0
    ,reload_time_ctrl/0
    ,sync_act_status/1
    ,sync_act_status/0
]).

-define (SERVER, ?MODULE).

-record (state, {
    cycle_index = 0,
    state_id = 0,
    step_ref = nil,
    start_time = 0,
    end_time = 0,
    is_cancel = 0
    }).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

gm_next() ->
    gen_server:cast(?SERVER, gm_next).

get_cur_state(Node) ->
    gen_server:cast(?SERVER, {get_cur_state, Node}).
sync_act_status(Node) ->
    gen_server:cast(?SERVER, {get_cur_state, Node}).
sync_act_status() ->
    gen_server:cast(?SERVER, sync_act_status).

cancel() ->
    gen_server:cast(?SERVER, cancel).

fix_the_cycle_index() ->
    gen_server:cast(?SERVER, fix_the_cycle_index).

reload_time_ctrl() ->
    gen_server:cast(?SERVER, reload_time_ctrl).



%% private
init([]) ->
    case mod_global_counter:get_count(?MOD_DIAMOND_LEAGUE, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, [?GLOBAL_COUNTER_ID_TIME_OFFSET, ?GLOBAL_COUNTER_ID_CYCLE_INDEX, ?GLOBAL_COUNTER_ID_APPLY_TIME]) of
        [{?GLOBAL_COUNTER_ID_APPLY_TIME, LastApplyTime},{?GLOBAL_COUNTER_ID_CYCLE_INDEX, CycleIndex},{?GLOBAL_COUNTER_ID_TIME_OFFSET, Offset}] -> ok;
        [{?GLOBAL_COUNTER_ID_TIME_OFFSET, Offset},{?GLOBAL_COUNTER_ID_CYCLE_INDEX, CycleIndex},{?GLOBAL_COUNTER_ID_APPLY_TIME, LastApplyTime}] -> ok
    end,
    put(gm_set_fake_time, Offset),
    {StateId, StartTime, EndTime} = lib_diamond_league:calc_cur_state(Offset),
    CycleIndex1
    = if
        StateId =:= ?STATE_APPLY andalso LastApplyTime < StartTime ->
            mod_global_counter:increment(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_CYCLE_INDEX),
            mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_APPLY_TIME, StartTime),
            CycleIndex + 1;
        true ->
            CycleIndex
    end,
    init_state(CycleIndex1, StateId, StartTime, EndTime),
    Now = utime:unixtime(),
    Ref = erlang:send_after((EndTime - Now + 1) * 1000, self(), check_next_state),
    % lib_kf_chaotic_battle:try_init_scene(),
    % mod_clusters_center:apply_to_all_node(mod_diamond_league_local, setup_state, [CycleIndex, StateId, StartTime, EndTime], 50),
    State = #state{state_id = StateId, step_ref = Ref, start_time = StartTime, end_time = EndTime, cycle_index = CycleIndex1},
    {ok, State}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast(gm_next, State) ->
    #state{end_time = EndTime} = State,
    Offset0 = get(gm_set_fake_time),
    Offset = EndTime - utime:unixtime() + Offset0,
    % ?PRINT("Offset = ~p~n", [Offset]),
    put(gm_set_fake_time, Offset),
    mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_TIME_OFFSET, Offset),
    do_handle_info(check_next_state, State);

do_handle_cast({get_cur_state, Node}, State) ->
    #state{state_id = StateId, is_cancel = IsCancel, cycle_index = CycleIndex, start_time = StartTime, end_time = EndTime} = State,
    if
        IsCancel == 0 ->
            mod_clusters_center:apply_cast(Node, lib_diamond_league, local_setup_state, [CycleIndex, StateId, StartTime, EndTime]);
        true ->
            mod_clusters_center:apply_cast(Node, lib_diamond_league, local_setup_state, [CycleIndex, 0, 0, 0])
    end,
    {noreply, State};

do_handle_cast(sync_act_status, State) ->
    #state{state_id = StateId, is_cancel = IsCancel, cycle_index = CycleIndex, start_time = StartTime, end_time = EndTime} = State,
    if
        IsCancel == 0 ->
            mod_clusters_center:apply_to_all_node(lib_diamond_league, local_update_state, [CycleIndex, StateId, StartTime, EndTime]);
        true ->
            mod_clusters_center:apply_to_all_node(lib_diamond_league, local_update_state, [CycleIndex, 0, 0, 0])
    end,
    {noreply, State};

do_handle_cast(cancel, State) ->
    {noreply, State#state{is_cancel = 1}};

do_handle_cast(fix_the_cycle_index, State) ->
    #state{state_id = StateId, start_time = StartTime, cycle_index = CycleIndex} = State,
    if
        StateId =:= ?STATE_APPLY ->
            LastApplyTime = mod_global_counter:get_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_APPLY_TIME),
            if
                LastApplyTime < StartTime ->
                    NewCycleIndex = CycleIndex + 1,
                    mod_global_counter:increment(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_CYCLE_INDEX),
                    mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_APPLY_TIME, StartTime),
                    {noreply, State#state{cycle_index = NewCycleIndex}};
                true ->
                    {noreply, State}
            end;
        true ->
            {noreply, State}
    end;

do_handle_cast(reload_time_ctrl, State) ->
    do_handle_info(check_next_state, State);

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(check_next_state, State) ->
    #state{state_id = StateId, step_ref = Ref, is_cancel = IsCancel, cycle_index = CycleIndex} = State,
    Offset = get(gm_set_fake_time),
    Now = utime:unixtime(),
    case lib_diamond_league:calc_cur_state(Offset) of
        {StateId, StartTime, EndTime} ->
            Ref2 = util:send_after(Ref, (EndTime - Now + 1) * 1000, self(), check_next_state),
            State2 = State#state{state_id = StateId, step_ref = Ref2, start_time = StartTime, end_time = EndTime},
            {noreply, State2};
        {StateId2, StartTime, EndTime} ->
            if
                StateId2 =:= ?STATE_APPLY ->
                    NewCycleIndex = CycleIndex + 1,
                    mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_CYCLE_INDEX, NewCycleIndex),
                    mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_APPLY_TIME, StartTime),
                    NewIsCancel = 0;
                StateId2 =:= ?STATE_CLOSED ->
                    NewCycleIndex = CycleIndex,
                    NewIsCancel = 0;
                true ->
                    NewCycleIndex = CycleIndex,
                    NewIsCancel = IsCancel
            end,
            if
                NewIsCancel =:= 0 ->
                    update_state(NewCycleIndex, StateId2, StartTime, EndTime);
                    % mod_clusters_center:apply_to_all_node(lib_diamond_league, local_update_state, [NewCycleIndex, StateId2, StartTime, EndTime], 50);
                true ->
                    ok
            end,
            if
                StateId2 =:= ?STATE_KING_CHOOSE ->
                    put(gm_set_fake_time, 0),
                    mod_global_counter:set_count(?MOD_DIAMOND_LEAGUE, ?GLOBAL_COUNTER_ID_TIME_OFFSET, 0);
                true ->
                    ok
            end,
            Ref2 = util:send_after(Ref, (EndTime - Now + 1) * 1000, self(), check_next_state),
            State2 = State#state{state_id = StateId2, step_ref = Ref2, start_time = StartTime, end_time = EndTime, is_cancel = NewIsCancel, cycle_index = NewCycleIndex},
            {noreply, State2}
    end;

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

init_state(CycleIndex, StateId, StartTime, EndTime) -> 
%%    ?PRINT("init_state ~p~n", [[CycleIndex, StateId, StartTime, EndTime]]),
    mod_diamond_league_schedule:init_state(CycleIndex, StateId, StartTime, EndTime).

% handle_last_state_end(StateId) -> ok.

update_state(CycleIndex, StateId, StartTime, EndTime) -> 
    % ?PRINT("update_state ~p~n", [[CycleIndex, StateId, StartTime, EndTime]]),
    mod_diamond_league_schedule:update_state(CycleIndex, StateId, StartTime, EndTime).