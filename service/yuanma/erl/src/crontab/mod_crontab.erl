%%%----------------------------------------------------------------------
%%%
%%% wg @copyright 2009
%%%
%%% @author litao cheng <litaocheng@gmail.com>
%%% @doc the cron server, run the periodic task
%%%
%%%----------------------------------------------------------------------

-module(mod_crontab).
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("crontab.hrl").
-include("common.hrl").

%% API
-export([
    start_link/0
    , reload_file/0
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
    files =[],                      % file name
    file_activity :: list(),        % activity file lists
    mtime = 0 :: pos_integer(),     % last modify time
    entrys = [] :: [cron_entry()],  % the cron tasks
    file_timer :: reference(),      % the check file last modified timer
    cron_timer :: reference()       % the check cron task timer
}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

reload_file() ->
    ?MODULE ! {reload_file}.

%% ====================================================================
%% Server functions
%% ====================================================================

init([]) ->
    case catch do_init() of
        {'EXIT', Reason} ->
            ?ERR("init error:~p", [Reason]),
            {stop, Reason};
        {ok, State} ->
            {ok, State};
        Other ->
            {stop, Other}
    end.

handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p, request:~p", [Reason, Request]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p, msg:~p", [Reason, Msg]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p, info:~p", [Reason, Info]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.
                    
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
do_init() ->
    process_flag(trap_exit, true),
    FilesActivity = lib_crontab:get_cron_files(),
    MaxModified = get_max_modified(FilesActivity),
    case lib_crontab:parse() of
        {ok, Entrys} ->
            State = #state{
                files = FilesActivity,
                mtime = MaxModified,
                entrys = Entrys,
                file_timer = check_file_timer(),
                cron_timer = init_cron_timer()
            },
            {ok, State};
        Error ->
            ?ERR("error :~p", [Error]),
            Error
    end.

do_call(Info, _, State) ->
    ?INFO("mod_crontab call is not match:~w", [Info]),
    {reply, ok, State}.

do_cast(Info, State) ->
    ?INFO("mod_crontab cast is not match:~w", [Info]),
    {noreply, State}.

do_info({check_file},State) ->
    case lib_crontab:parse() of
        {ok, Entrys} ->
            State3 = State#state{
                entrys = Entrys
            },
            {noreply, State3};
        _Error ->
            ?ERR("the crontab reload file format error:~p", [_Error]),
            {noreply, State}
    end;

do_info({reload_file},State = #state{files = Files, mtime = _MTime}) ->
    case lib_crontab:parse() of
        {ok, Entrys} ->
            MTimeNew = get_max_modified([Files]),
            State3 = State#state{
                files = Files,
                mtime = MTimeNew,
                entrys = Entrys
            },
            {noreply, State3};
        _Error ->
            ?ERR("the crontab reload file format error:~p", [_Error]),
            {noreply, State}
    end;

do_info({timeout, _Ref, check_file}, State = #state{files = Files, mtime = MTime}) ->
    State2 = State#state{
        file_timer = check_file_timer()
    },
    %%检测文件最后修改事件
    MTimeNew = get_max_modified([Files]),
    case  MTimeNew > MTime of
        true -> % reload crontab
            case lib_crontab:parse() of
                {ok, Entrys} ->
                    State3 = State2#state{
                        files = Files,
                        mtime = MTimeNew,
                        entrys = Entrys
                    },
                    {noreply, State3};
                _Error ->
                    ?ERR("the crontab file ~s format error:~p", [Files, _Error]),
                    {noreply, State2}
            end;
        false ->
            {noreply, State2}
    end;

do_info({timeout, _Ref, check_cron}, State = #state{entrys = Entrys}) ->
    State2 = State#state{
        cron_timer = check_cron_timer()
    },
    lib_crontab:check_entrys(Entrys),
    {noreply, State2};

do_info(Info, State) ->
    ?INFO("mod_crontab info is not match:~w", [Info]),
    {noreply, State}.

get_max_modified(Files) ->
    lists:max([filelib:last_modified(F) || F <- Files]).

check_file_timer() ->
    erlang:start_timer(?CHECK_FILE_INTERVAL, self(), check_file).

init_cron_timer() ->
    Sec = (utime:unixtime() rem 60) * 1000,
    erlang:start_timer(?CHECK_FILE_INTERVAL - Sec + 2000, self(), check_cron).

check_cron_timer() ->
    init_cron_timer().

    
