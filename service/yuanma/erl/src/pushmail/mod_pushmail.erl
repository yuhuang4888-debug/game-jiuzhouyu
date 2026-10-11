%% ---------------------------------------------------------------------------
%% @doc mod_pushmail
%% @author xiaoxiang
%% @since  2017-03-01
%% @deprecated  pushmail
%% ---------------------------------------------------------------------------

-module(mod_pushmail).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-compile(export_all).
-include("common.hrl").
-include("def_event.hrl").
-include("server.hrl").
-include("pushmail.hrl").
-include("predefine.hrl").


start_link() ->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_fsm:send_all_state_event(misc:get_global_pid(?MODULE), stop).

timer_check() ->
    Pid = misc:get_global_pid(?MODULE),
    case is_pid(Pid) of 
        true ->
            Pid ! 'timer_check';
        _ ->
            skip
    end.

open_day() ->
    misc:get_global_pid(?MODULE) ! 'open_day'.

marge_day() ->
    misc:get_global_pid(?MODULE) ! 'marge_day'.


open_day(Delay) ->
    misc:get_global_pid(?MODULE) ! {'open_day', Delay}.

marge_day(Delay) ->
    misc:get_global_pid(?MODULE) ! {'marge_day', Delay}.


init([]) ->
    {ok, wait, #push_state{}}.

handle_event(stop, _StateName, State) ->
    {stop, normal, State};
handle_event(_Event, _StateName, State) ->
    {next_state, _StateName, State}.


handle_sync_event(_Event, _From, _StateName, State) ->
    {next_state, _StateName, State}.

code_change(_OldVsn, _StateName, State, _Extra) ->
    {ok, _StateName, State}.

handle_info('timer_check', _StateName, State) ->
    NewState = do_timer_check(State),
    {next_state, _StateName, NewState};
handle_info('open_day', _StateName, State) ->
    NewState = do_open_day(State),
    {next_state, _StateName, NewState};

handle_info({'open_day', Delay}, _StateName, State) ->
    spawn(fun() -> util:multiserver_delay(Delay, ?MODULE, open_day, []) end),
    {next_state, _StateName, State};

handle_info({'marge_day', Delay}, _StateName, State) ->
    spawn(fun() -> util:multiserver_delay(Delay, ?MODULE, marge_day, []) end),
    {next_state, _StateName, State};

handle_info(_Any, _StateName, State) ->
    {next_state, _StateName, State}.

terminate(_Reason, _StateName, _Opts) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

%% -------------------------- state -------------------------------------------
wait(Event, State) ->
    case Event of
        'time' ->
            NewState = do_timer_check(State),
            {next_state, wait, NewState};
        'server' ->
            NewState = do_open_day(State),
            {next_state, wait, NewState};
        'marge' ->
            NewState = do_merge_day(State),
            {next_state, wait, NewState};
        _ ->
            {next_state, wait, State}
    end.


do_timer_check(State) ->
    {{NowY, NowM, NowD}, {NowH, NowMin, _}} = calendar:local_time(),
    IdList = data_pushmail:get_id_list(),
    F = fun(Id) ->
        #base_pushmail{time = Time} = data_pushmail:get_pushmail_config(Id),
        case Time of
            [{Y, M, D}, {H, Min}] ->
                case Y==NowY andalso M == NowM andalso D==NowD andalso H==NowH andalso Min==NowMin of
                    true ->
                        ?PRINT("------------------Id:~p ~n", [Id]),
                        RefreshList = ets:tab2list(?ETS_ONLINE),
                        RoleIdList = [PlayerId||#ets_online{id = PlayerId}<-RefreshList],
                        send_push_mail(RoleIdList);
                    _ ->
                        skip
                end;
            _ ->
                false
        end
    end,
    lists:foreach(F, IdList),
    State.

do_open_day(State) ->
    Now = util:get_open_day(),
    IdList = data_pushmail:get_id_list(),
    F = fun(Id) ->
        #base_pushmail{open_day = OpenDay} = data_pushmail:get_pushmail_config(Id),
        case Now == OpenDay of
            true ->
                RefreshList = ets:tab2list(?ETS_ONLINE),
                RoleIdList = [PlayerId||#ets_online{id = PlayerId}<-RefreshList],
                send_push_mail(RoleIdList);
            _ ->
                false
        end
    end,
    lists:foreach(F, IdList),
    State.


do_merge_day(State) ->
    Now = util:get_merge_day(),
    IdList = data_pushmail:get_id_list(),
    F = fun(Id) ->
        #base_pushmail{merge_day = MargeDay} = data_pushmail:get_pushmail_config(Id),
        case Now == MargeDay of
            true ->
                RefreshList = ets:tab2list(?ETS_ONLINE),
                RoleIdList = [PlayerId||#ets_online{id = PlayerId}<-RefreshList],
                send_push_mail(RoleIdList);
            _ ->
                false
        end
    end,
    lists:foreach(F, IdList),
    State.

send_push_mail(RoleIdList) ->
    spawn(?MODULE, send_push_mail_pro, [RoleIdList]).

send_push_mail_pro(RoleIdList) ->
    [begin
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_pushmail, pushmail, []),
        timer:sleep(50)
    end||RoleId<-RoleIdList].
