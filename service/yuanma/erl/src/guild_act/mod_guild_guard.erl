%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_guard.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-15
%% @Description:    守卫公会活动控制器
%%-----------------------------------------------------------------------------
-module (mod_guild_guard).

-include ("common.hrl").
-include ("def_module.hrl").
-include ("activitycalen.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("dungeon.hrl").
-include ("def_fun.hrl").

-define (SERVER, ?MODULE).
-define (END_NOTICE_TIME, 120). %% 结束前通知时间
-define (END_NO, 0).
-define (END_YES, 1).
-define (END_ERROR, 2).

-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,act_start/1
    ,enter_act/2
    ,create_dun/2
    ,dungeon_finish/1
    ,dungeon_end/1
    ,gm_start/1
    ,get_info/2
    ,get_guild_wave_num/2
]).

-record (state, {
    act_id = 0,
    start_time = 0,
    end_time = 0,
    guilds_map = #{},
    end_ref = undefined,    %%结束定时器
    end_before_ref = undefined,   %%活动结束前的通知定时器
    waiting_map = #{}
    }).

-record (act_guild, {
    guild_id,
    level = 0,
    dun_id,
    dun_pid,
    is_end = ?END_NO,
    start_time = 0,
    challenge_guard = 1
    }).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_start(Args) ->
    gen_server:cast(?SERVER, {act_start, Args}).

enter_act(RoleId, GuildId) ->
    case misc:is_process_alive(misc:whereis_name(local, ?SERVER)) of
        true ->
            gen_server:cast(?SERVER, {enter_act, RoleId, GuildId});
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_act_close)])
    end.

create_dun(GuildId, Args) ->
    gen_server:cast(?SERVER, {create_dun, GuildId, Args}).

dungeon_finish([GuildId, NewChallengeGuard]) ->
    gen_server:cast(?SERVER, {dungeon_finish, GuildId, NewChallengeGuard}).

dungeon_end(GuildId) ->
    gen_server:cast(?SERVER, {dungeon_end, GuildId}).

gm_start(Time) ->
    gen_server:cast(?SERVER, {gm_start, Time}).

get_info(Sid, GuildId) ->
    gen_server:cast(?SERVER, {get_info, Sid, GuildId}).

get_guild_wave_num(Sid, GuildId) ->
    gen_server:cast(?SERVER, {get_guild_wave_num, Sid, GuildId}).


%% private
init([]) ->
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD) of
        {ok, ActId} ->
            State = init_act(#state{}, ActId);
        _ ->
            State = #state{}
    end,
    NewState = load_data(State),
    %?PRINT("init NewState ~p~n", [NewState]),
    {ok, NewState}.

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
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({get_info, Sid, GuildId}, State) ->
    #state{guilds_map = GuildMap} = State,
    Now = utime:unixtime(),
    case maps:get(GuildId, GuildMap, 0) of 
        #act_guild{is_end = EndStatus} -> 
            IsEnd = ?IF(EndStatus == ?END_NO, 0, 1);
        _ ->
            IsEnd = 1
    end,
    if 
        State#state.start_time =< Now andalso Now =< State#state.end_time ->
            EndTime = State#state.end_time,
            Status = 1;
        true ->
            Status = 0, EndTime = 0
    end,
    {ok, BinData} = pt_402:write(40231, [Status, EndTime, IsEnd]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

do_handle_cast({get_guild_wave_num, Sid, GuildId}, State) ->
    #state{guilds_map = GuildMap} = State,
    #act_guild{challenge_guard = ChallengeGuard} = maps:get(GuildId, GuildMap, #act_guild{challenge_guard = 1}),
    {ok, BinData} = pt_402:write(40232, [ChallengeGuard]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

do_handle_cast({act_start, Args}, State) ->
    Now = utime:unixtime(),
    if
        State#state.start_time =< Now andalso Now =< State#state.end_time ->
            NewState = State;
        true ->
            State1 = clear_old_state(State),
            NewState = do_act_start(State1, Args)
    end,
    {noreply, NewState};

do_handle_cast({enter_act, RoleId, GuildId}, State) when is_record(State, state) ->
    #state{start_time = StartTime, end_time = EndTime, guilds_map = GuildMap, waiting_map = WaitingMap} = State,
    NowTime = utime:unixtime(),
    if
        StartTime > 0 andalso NowTime < StartTime andalso NowTime > EndTime ->
            lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_act_close)]),
            {noreply, State};
        true ->
            case maps:get(GuildId, GuildMap, #act_guild{}) of
                #act_guild{is_end = IsEnd} when IsEnd =/= ?END_NO ->
                    lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_guild_guard_end)]),
                    {noreply, State};
                #act_guild{dun_id = DunId, dun_pid = DunPId} ->
                    case misc:is_process_alive(DunPId) of 
                        true ->
                            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_GUILD_ACT, 3),
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_dungeon, enter_dungeon, [DunId, DunPId]),
                            lib_server_send:send_to_uid(RoleId, pt_402, 40230, [?SUCCESS]),
                            {noreply, State};
                        _ ->
                            {WaitingRolds, ReqCount} = maps:get(GuildId, WaitingMap, {[], 0}),
                            case ReqCount == 0 of
                                true ->
                                    mod_guild:apply_cast(lib_guild_guard, collect_guild_info_and_enter_act, [GuildId]);
                                _ ->
                                    skip
                            end,
                            NewWaitingRoles
                            = case lists:member(RoleId, WaitingRolds) of
                                true ->
                                    WaitingRolds;
                                _ ->
                                    [RoleId|WaitingRolds]
                            end,
                            NewWaitingMap = WaitingMap#{GuildId => {NewWaitingRoles, ReqCount + 1}},
                            {noreply, State#state{waiting_map = NewWaitingMap}}
                    end
            end
    end;

do_handle_cast({create_dun, GuildId, [Lv, CombatPower, ActiveNum]}, State) ->
    #state{guilds_map = GuildMap, waiting_map = WaitingMap, end_time = EndTime} = State,
    OldActGuild = maps:get(GuildId, GuildMap, #act_guild{guild_id = GuildId}),
    case data_dungeon:get_ids_by_type(?DUNGEON_TYPE_GUILD_GUARD) of
        [DunId|_] ->
            NowTime = utime:unixtime(),
            if
                NowTime < EndTime ->
                    #act_guild{challenge_guard = ChallengeGuard} = OldActGuild,
                    {ok, Pid} = lib_dungeon_guild_guard:create_dun(GuildId, DunId, Lv, CombatPower, EndTime, ActiveNum, ChallengeGuard),
                    ActGuild = OldActGuild#act_guild{guild_id = GuildId, dun_id = DunId, dun_pid = Pid, start_time = NowTime},
                    NewGuildMap = GuildMap#{GuildId => ActGuild},
                    case maps:take(GuildId, WaitingMap) of
                        {{WaitingRolds, _}, NewWaitingMap} ->
                            [begin
                                lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_GUILD_ACT, 3),
                                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_dungeon, enter_dungeon, [DunId, Pid]),
                                lib_server_send:send_to_uid(RoleId, pt_402, 40230, [?SUCCESS])
                            end || RoleId <- WaitingRolds];
                        _ ->
                            NewWaitingMap = WaitingMap
                    end;
                true ->
                    NewGuildMap = GuildMap,
                    case maps:take(GuildId, WaitingMap) of
                        {{WaitingRolds, _}, NewWaitingMap} ->
                            [begin
                                 lib_server_send:send_to_uid(RoleId, pt_402, 40200, [?ERRCODE(err402_act_close)])
                            end || RoleId <- WaitingRolds];
                        _ ->
                            NewWaitingMap = WaitingMap
                    end
            end,
            {noreply, State#state{guilds_map = NewGuildMap, waiting_map = NewWaitingMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({dungeon_finish, GuildId, NewChallengeGuard}, State) ->
    #state{guilds_map = GuildMap, act_id = ActId} = State,
    case maps:find(GuildId, GuildMap) of
        {ok, #act_guild{is_end = ?END_NO} = ActGuild} ->
            NewGuild = ActGuild#act_guild{dun_id = 0, dun_pid = 0, is_end = ?END_YES, challenge_guard = NewChallengeGuard},
            NewGuildMap = GuildMap#{GuildId => NewGuild},
            %% todo 持久化
            save_guild_state(ActId, NewGuild),
            {noreply, State#state{guilds_map = NewGuildMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({dungeon_end, GuildId}, State) ->
    #state{guilds_map = GuildMap, act_id = ActId} = State,
    case maps:find(GuildId, GuildMap) of
        {ok, #act_guild{is_end = ?END_NO} = ActGuild} ->
            NewGuild = ActGuild#act_guild{dun_id = 0, dun_pid = 0, is_end = ?END_ERROR},
            NewGuildMap = GuildMap#{GuildId => NewGuild},
            %% todo 持久化
            save_guild_state(ActId, NewGuild),
            {noreply, State#state{guilds_map = NewGuildMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_start, Time}, State) ->
    #state{start_time = _StartTime, end_time = _EndTime} = State,
    State1 = clear_old_state(State),
    NowTime = utime:unixtime(),
    {ok, BinData} = pt_402:write(40231, [1, NowTime + Time, 0]),
    lib_server_send:send_to_all(BinData),
    %lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 6, []),
    lib_activitycalen_api:success_start_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD),
    EndRef = erlang:start_timer(Time * 1000, self(), act_end),
    if
        Time - ?END_NOTICE_TIME > 0 ->
            EndBeforeRef = erlang:start_timer((Time - ?END_NOTICE_TIME) * 1000, self(), act_end_notice);
        true ->
            EndBeforeRef = undefined
    end,
    lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 24, []),
    NewState = State1#state{act_id = 0, start_time = NowTime, end_time = NowTime + Time, end_ref = EndRef, end_before_ref = EndBeforeRef},
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({timeout, TimerRef, act_end}, #state{end_ref = TimerRef} = State) ->
    NewState = act_end(State),
    {noreply, NewState};

do_handle_info({timeout, TimerRef, act_end_notice}, #state{end_before_ref = TimerRef} = State) ->
    % #state{guilds_map = GuildMap} = State,
    % maps:map(fun
    %     (_K, #act_guild{is_end = IsEnd, guild_id = GuildId}) ->
    %         if
    %             IsEnd =:= ?END_NO ->
    %                 lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 7, []);
    %             true ->
    %                 ok
    %         end
    % end, GuildMap),
    lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 7, []),
    {noreply, State};

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

clear_old_state(State) ->
    #state{guilds_map = GuildMap, end_ref = EndRef, end_before_ref = EndBeforeRef} = State,
    util:cancel_timer(EndRef),
    util:cancel_timer(EndBeforeRef),
    db:execute("update `guild_guard_dungeon` set `is_end` = 0"),
    F = fun(_K, V) -> V#act_guild{dun_id=0, dun_pid=0, is_end=?END_NO, start_time=0} end,
    NewGuildMap = maps:map(F, GuildMap),
    State#state{guilds_map = NewGuildMap, start_time = 0, end_time = 0, end_ref = undefined, end_before_ref = undefined}.

do_act_start(State, ActId) ->
    Act = data_activitycalen:get_ac(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD, ActId),
    #base_ac{time_region = TimeRegion} = Act,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    Now = NowH * 60 + NowM,
    ZeroAclock = utime:unixdate(),
    NowTime = utime:unixtime(),
    case ulists:find(fun
        ({{SH, SM}, {EH, EM}}) ->
            SH * 60 + SM =< Now andalso Now =< EH * 60 + EM 
    end, TimeRegion) of
        {ok, {{SH, SM}, {EH, EM}}} ->
            StartTime = ZeroAclock + SH * 3600 + SM * 60,
            EndTime = ZeroAclock + EH * 3600 + EM * 60,
            lib_activitycalen_api:success_start_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD),
            EndDelay = max(EndTime - NowTime, 1),
            EndRef = erlang:start_timer(EndDelay * 1000, self(), act_end),
            if
                EndDelay - ?END_NOTICE_TIME > 0 ->
                    EndBeforeRef = erlang:start_timer((EndDelay - ?END_NOTICE_TIME) * 1000, self(), act_end_notice);
                true ->
                    EndBeforeRef = undefined
            end,
            {ok, BinData} = pt_402:write(40231, [1, EndTime, 0]),
            lib_server_send:send_to_all(BinData),
            %lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 6, []),
            lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 24, []),
            State#state{act_id = ActId, start_time = StartTime, end_time = EndTime, end_ref = EndRef, end_before_ref = EndBeforeRef};
        _ ->
            State
    end.

init_act(State, ActId) ->
    NewState = do_act_start(State, ActId),
    NewState.

act_end(State) ->
    lib_activitycalen_api:success_end_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD),
    {ok, BinData} = pt_402:write(40231, [0, 0, 1]),
    lib_server_send:send_to_all(BinData),
    clear_old_state(State).

load_data(State) ->
    #state{start_time = StartTime, end_time = EndTime} = State,
    SQL = io_lib:format("SELECT `guild_id`, `start_time`, `is_end`, `challenge_guard` FROM `guild_guard_dungeon` ", []),
    FinishedGuildIds = db:get_all(SQL),
    F = fun([Id, GuildStartTime, IsEnd, ChallengeGuard], Map) ->
        {NewIsEnd, NewStartTime} = ?IF(StartTime > 0 andalso GuildStartTime > StartTime andalso GuildStartTime < EndTime, {IsEnd, GuildStartTime}, {?END_NO, 0}),
        ActGuild = #act_guild{guild_id = Id, start_time = NewStartTime, is_end = NewIsEnd, challenge_guard = ChallengeGuard},
        maps:put(Id, ActGuild, Map)
    end,
    GuildMap = lists:foldl(F, #{}, FinishedGuildIds),
    State#state{guilds_map = GuildMap}.

save_guild_state(ActId, #act_guild{guild_id = GuildId, start_time = StartTime, is_end = IsEnd, challenge_guard = ChallengeGuard}) ->
    SQL = io_lib:format("REPLACE INTO `guild_guard_dungeon` (`guild_id`, `act_id`, `start_time`, `is_end`, `challenge_guard`) VALUES (~p, ~p, ~p, ~p, ~p)", [GuildId, ActId, StartTime, IsEnd, ChallengeGuard]),
    db:execute(SQL).