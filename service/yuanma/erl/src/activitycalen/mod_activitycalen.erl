% %% ---------------------------------------------------------------------------
% %% @doc mod_activitycalen
% %% @author xiaoxiang
% %% @since  2017-03-01
% %% @deprecated  pushmail
% %% ---------------------------------------------------------------------------

-module(mod_activitycalen).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/3, code_change/3]).
-export([

    ]).
-compile(export_all).
%% -include("flagwar.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("server.hrl").
-include("activitycalen.hrl").
-include("pushmail.hrl").
-behavious(gen_server).
% -define(AC_WAIT, 0).    %% 活动等待
% -define(AC_OPEN, 0).    %% 活动开启
% -define(AC_END, 0).     %% 活动结束



%% 活动开启和活动结束都需要调用这两个接口
%% ------------------------------api-------------------------------------------------------------
%% 活动完成
success_end_activity(AcId) ->
    success_end_activity(AcId, 0).
success_end_activity(AcId, AcSub) ->
    gen_server:cast({global, ?MODULE}, {'success_end_activity', AcId, AcSub}).
%% 活动开启
success_start_activity(AcId) ->
    success_start_activity(AcId, 0).
success_start_activity(AcId, AcSub) ->
    %% 推送   15718 的协议


    gen_server:cast({global, ?MODULE}, {'success_start_activity', AcId, AcSub}).

% ask_activity_status(RoleId, Lv) ->
%     gen_server:cast({global, ?MODULE}, {'ask_activity_status', RoleId, Lv}).

ask_activity_num(RoleId, Lv, OnHookTime, Type) ->
    gen_server:cast({global, ?MODULE}, {'ask_activity_num', RoleId, Lv, OnHookTime, Type}).

send_act_remind(RoleId, Lv, SignUpList) ->
    gen_server:cast({global, ?MODULE}, {'send_act_remind', RoleId, Lv, SignUpList}).

set_act_remind(RoleId, Lv, IsRemind) ->
    gen_server:cast({global, ?MODULE}, {'set_act_remind', RoleId, Lv, IsRemind}).

get_ac_first_start(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'get_ac_first_start', RoleId}).

timer_check() ->
    gen_server:cast({global, ?MODULE}, 'timer_check').

send_act_status(Mod, Sub, RoleId, Lv) ->
    gen_server:cast({global, ?MODULE}, {'send_act_status', Mod, Sub, RoleId, Lv}).

gm_end_act_state(Mod, Sub, AcSub) ->
    gen_server:cast({global, ?MODULE}, {'gm_end_act_state', Mod, Sub, AcSub}).

%% ---------------------------------------------------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
%% @doc Initializes the server
-spec init(Args) ->
    {ok, State}
    | {ok, State, Timeout}
    | ignore
    | {stop, Reason} when
    Args    :: [term()] ,
    State   :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason  :: term().

init([]) ->
    State = lib_activitycalen_mod:init(),
    {ok, State}.

%% ---------------------------------------------------------------------------
%% @doc Handling call messages
-spec handle_call(Request, From, State) ->
    {reply, Reply, State}
    | {reply, Reply, State, Timeout}
    | {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, Reply, State}
    | {stop, Reason, State} when
    Request :: term(),
    From :: pid(),
    State :: term(),
    Reply :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity.
handle_call(_Request, _From, State) ->
    % ?ERR1("Handle unkown request[~w]~n", [_Request]),
    Reply = ok,
    {reply, Reply, State}.


%% ---------------------------------------------------------------------------
%% @doc Handling cast messages
-spec handle_cast(Msg, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Msg :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        {stop, Reason, NewState} ->
            {stop, Reason, NewState};
        Err ->
            % util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
            ?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% -------------------handle_info---------------------------------------------
do_handle_cast({'ask_activity_status', RoleId, Lv}, State) ->
    NewState = lib_activitycalen_mod:ask_activity_status(RoleId, Lv, State),
    {ok, NewState};
do_handle_cast({'success_end_activity', AcId, AcSub}, State) ->
    NewState = lib_activitycalen_mod:success_end_activity(AcId, AcSub, State),
    {ok, NewState};
do_handle_cast({'success_start_activity', AcId, AcSub}, State) ->
    NewState = lib_activitycalen_mod:success_start_activity(AcId, AcSub, State),
    {ok, NewState};
do_handle_cast({'ask_activity_num', RoleId, Lv, OnHookTime, Type}, State) ->
    IsOnline = lib_player:is_online_global(RoleId),
    if
        IsOnline == true ->
            NewState = lib_activitycalen_mod:ask_activity_num(RoleId, Lv, OnHookTime, Type, State),
            {ok, NewState};
        true ->
            {ok, State}
    end;
do_handle_cast({'send_act_remind', RoleId, Lv, SignUpList}, State) ->
    lib_activitycalen_mod:send_act_remind(RoleId, Lv, SignUpList, State),
    {ok, State};
do_handle_cast({'set_act_remind', RoleId, Lv, IsRemind}, State) ->
    NewState = lib_activitycalen_mod:set_act_remind(RoleId, Lv, IsRemind, State),
    {ok, NewState};
do_handle_cast({'get_ac_first_start', RoleId}, State) ->
    NewState = lib_activitycalen_mod:get_ac_first_start(RoleId, State),
    {ok, NewState};

do_handle_cast('timer_check', State) ->
    NewState = lib_activitycalen_mod:timer_check(State),
    {ok, NewState};

do_handle_cast({'send_act_status', Mod, Sub, RoleId, Lv}, State) ->
    NewState = lib_activitycalen_mod:send_act_status(Mod, Sub, RoleId, Lv, State),
    {ok, NewState};
do_handle_cast({'gm_end_act_state', Mod, Sub, AcSub}, State) ->
    NewState = lib_activitycalen_mod:gm_end_act_state(Mod, Sub, AcSub, State),
    {ok, NewState};

do_handle_cast(_Msg, State) ->
    % ?ERR1("Handle unkown msg[~w]~n", [_Msg]),
    %?PRINT("_Msg:~p ~n", [_Msg]),
    {ok, State}.

terminate(_Any, _StateName, _Opts) ->
    ok.

%% ---------------------------------------------------------------------------
%% @doc Handling all non call/cast messages
-spec handle_info(Info, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Info :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
    % ?ERR1("Handle unkown info[~w]~n", [_Info]),
    {noreply, State}.


%% ---------------------------------------------------------------------------
%% @doc called by a gen_server when it is about to terminate
-spec terminate(Reason, State) -> ok when
    Reason :: term(),
    State :: term().
%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.


%% ---------------------------------------------------------------------------
%% @doc Convert process state when code is changed
-spec code_change(OldVsn, State, Extra) -> {ok, NewState} when
    OldVsn :: term(),
    State :: term(),
    Extra :: term(),
    NewState :: term().
%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
