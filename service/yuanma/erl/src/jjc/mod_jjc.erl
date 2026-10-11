%%%------------------------------------
%%% @Module  : mod_jjc
%%% @Author  :  xiaoxiang
%%% @Created :  2017-03-23
%%% @Description: jjc
%%%------------------------------------
-module(mod_jjc).
-export([]).

-compile(export_all).

-include("common.hrl").
-include("jjc.hrl").


%% 获取排名信息(异步返回)
%% @param Type 类型,根据类型来回调函数
%% @param RankNoL [排名位置,...]
%% @return [{RankNo, RoleId, Figure, BattleAttr, Combat},...]
cast_get_rank_info(Type, RankNoL) ->
    gen_server:cast({global, ?MODULE}, {cast_get_rank_info, [Type, RankNoL]}).

cast_to_jjc(F, A) ->
    case F of
        login ->
            Pid = misc:get_global_pid(?MODULE),
            case misc:is_process_alive(Pid) of
                true ->
                    gen_server:cast({global, ?MODULE}, {F, A});
                _ -> skip
                    % [RoleId] = A,
                    % lib_scene:player_change_default_scene(RoleId, [])
            end;
        _ ->
            gen_server:cast({global, ?MODULE}, {F, A})
    end.

role_rank(RoleId) ->
    gen_server:call({global, ?MODULE}, {role_rank, RoleId}).

jjc_reward(RoleId) ->
    gen_server:call({global, ?MODULE}, {jjc_reward, RoleId},1000).

do_call({role_rank, RoleId}, _From, State) ->
    Reply = mod_jjc_cast:get_real_role(State, RoleId),
    {reply, {ok, Reply}, State};

do_call({jjc_reward, RoleId}, _From, State) ->
    RealRole = mod_jjc_cast:get_real_role(State, RoleId),
    #real_role{is_reward = IsReward, reward_rank = RewardRank} = RealRole,
    Reply = case IsReward of
                ?JJC_HAVE_REWARD ->
                    case Reward = mod_jjc_cast:get_rank_reward(RewardRank) of
                        [] -> {ok, {?JJC_HAVE_NOT_REWARD, []}};
                        _ ->   {ok,{?JJC_HAVE_REWARD, Reward}}
                    end;
                ?JJC_HAVE_NOT_REWARD ->
                    {ok,{?JJC_HAVE_NOT_REWARD, []}}
             end,
    {reply, Reply, State}.




%% --------------------------------- 公共函数 ----------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().
%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).


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
    State = lib_jjc_util:do_init(),
    {ok, State}.


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


handle_call(Request, From, State) ->
    % ?ERR1("Handle unkown request[~w]~n", [_Request]),
   case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.


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

handle_cast({F,A}, State) ->
    NewState = case catch apply(mod_jjc_cast, F, [State|A]) of
        #jjc_state{} = State1 ->
            State1;
        ERR ->
            ?ERR("handle_cast {F,A}:~p error:~p~n", [{F,A}, ERR]),
            State
    end, 
    {noreply, NewState};


handle_cast(_Msg, State) ->
    {noreply, State}.


% handle_cast(Msg, State) ->
%     case catch do_handle_cast(Msg, State) of
%         {ok, NewState} ->
%             {noreply, NewState};
%         Err ->
%             util:errlog("~p ~p Msg:~p Cast_Error:~p, State:~p~n", [?MODULE, ?LINE, Msg, Err, State]),
%             {noreply, State}
%     end.

% do_handle_cast(_Msg, State) ->
%     {ok, State}.    
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