%%%------------------------------------
%%% @Module  : mod_flower_rank_act
%%% @Author  :  fwx
%%% @Created :  2018-1-5
%%% @Description: 跨服鲜花榜
%%%------------------------------------

-module(mod_kf_flower_act_local).

% -include("common.hrl").
-include("flower_rank_act.hrl").
-include("common.hrl").

%% API
-export([start_link/0]).
-compile(export_all).
%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% 根据类型刷新榜单
refresh_common_rank(RankType, SubType, Info) ->
    gen_server:cast({global, ?MODULE}, {'refresh_common_rank', RankType, SubType, Info}).
send_rank_list(RankType, SubType, RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'send_rank_list', RankType, SubType, RoleId, ServerId}).
clear_data(SubType) ->
    gen_server:cast({global, ?MODULE}, {'clear_data', SubType}).
change_rank_by_type(SubType, RoleId, OldType, NewType, Sex) ->
    gen_server:cast({global, ?MODULE}, {'change_rank_by_type', SubType, RoleId, OldType, NewType, Sex}).

change_role_name_by_type(SubType, RoleId, ChangeRankType, PlayerName) ->
    gen_server:cast({global, ?MODULE}, {'change_role_name_by_type', SubType, RoleId, ChangeRankType, PlayerName}).

sync_top_n_figure(RankType, SubType, TopNIds) ->
    gen_server:cast({global, ?MODULE}, {'sync_top_n_figure', RankType, SubType, TopNIds}).
update_role_figure(RoleId, KeyList) ->
    gen_server:cast({global, ?MODULE}, {'update_role_figure', RoleId, KeyList}).
wlv_change(Type, SubType, WLv) ->
    gen_server:cast({global, ?MODULE}, {'wlv_change', Type, SubType, WLv}).
%% ---------------------------------------------------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().
%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
%% @doc Initializes the server
-spec init(Args) ->
    {ok, State}
    | {ok, State, Timeout}
    | ignore
    | {stop, Reason} when
    Args    :: term() ,
    State   :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason  :: term().
%% ---------------------------------------------------------------------------
init([]) ->
    State = lib_kf_flower_act_mod_local:init(),
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
%% ---------------------------------------------------------------------------

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
        Err ->
            % util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
            ?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
            {noreply, State}
    end.
    % {ok, NewState} = do_handle_cast(Msg, State),
    % {noreply, NewState}.

do_handle_cast({'refresh_common_rank', RankType, SubType, Info}, State) ->
    lib_kf_flower_act_mod_local:refresh_common_rank(State, RankType, SubType, Info);
do_handle_cast({'send_rank_list', RankType, SubType, RoleId, ServerId}, State) ->
    lib_kf_flower_act_mod_local:send_rank_list(State, RankType, SubType, RoleId, ServerId);
do_handle_cast({'clear_data', SubType}, State) ->
    lib_kf_flower_act_mod_local:clear_data(State, SubType);
do_handle_cast({'change_rank_by_type', SubType, RoleId, OldType, NewType, Sex}, State) ->
    lib_kf_flower_act_mod_local:change_rank_by_type(State, SubType, RoleId, OldType, NewType, Sex);
do_handle_cast({'change_role_name_by_type', SubType, RoleId, ChangeRankType, PlayerName}, State) ->
    lib_kf_flower_act_mod_local:change_role_name_by_type(State, SubType, RoleId, ChangeRankType, PlayerName);
do_handle_cast({'sync_top_n_figure', RankType, SubType, TopNIds}, State) ->
    lib_kf_flower_act_mod_local:sync_top_n_figure(State, RankType, SubType, TopNIds);
do_handle_cast({'update_role_figure', RoleId, KeyList}, State) ->
    lib_kf_flower_act_mod_local:update_role_figure(State, RoleId, KeyList);
do_handle_cast({'wlv_change', Type, SubType, WLv}, State) ->
    lib_kf_flower_act_mod_local:wlv_change(State, Type, SubType, WLv);

do_handle_cast(_Msg, State) ->
     ?ERR("Handle unkown msg[~w]~n", [_Msg]),
    {ok, State}.

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
handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("info_error:~p~n", [Res]),
            {noreply, State}
    end.

do_handle_info({refresh_power}, State) ->
    lib_kf_flower_act_mod_local:refresh_power(State);

do_handle_info(Info, State) ->
    ?ERR("unknow info :~p~n", [Info]),
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