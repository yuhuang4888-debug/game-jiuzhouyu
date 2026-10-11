%% ---------------------------------------------------------------------------
%% @doc 玩家历史镜像(1个小时更新一次)
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (mod_player_mirror).
%% -behaviour(gen_server).
%% -include ("common.hrl").
%% -include ("predefine.hrl").
%% -include ("rec_mirror.hrl").

%% %% API
%% -export([start_link/0, timer_rank/1, cast_to_mirror/4, send_rival_list/1, gm/1]).
%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% start_link() ->
%%     gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

%% timer_rank(Stage) ->
%% 	gen_server:cast(misc:get_global_pid(?MODULE), {'timer_rank', Stage}).
%% cast_to_mirror(PlayerId, M, F, Args) ->
%%     gen_server:cast(misc:get_global_pid(?MODULE), {'cast_to_mirror', PlayerId, M, F, Args}).
%% send_rival_list(Args) ->
%%     gen_server:cast(misc:get_global_pid(?MODULE), {'send_rival_list', Args}).

%% gm(Args) ->
%%     gen_server:cast(misc:get_global_pid(?MODULE), {'gm', Args}).

%% do_init(_Args) ->
%% 	self() ! 'init',
%%     {ok, #mirror_state{}}.

%% do_call(_Request, _From, State) ->
%%     {reply, ok, State}.

%% do_cast(stop, State) ->
%%     {stop, normal, State};
%% do_cast({'timer_rank', Stage}, State) ->
%% 	{ok, NewState} = lib_player_mirror_mod:timer_rank(State, Stage),
%%     {noreply, NewState};
%% do_cast({cast_to_mirror, PlayerId, M, F, A}, State) ->
%%     #mirror_state{player_map = PlayerMap} = State,
%%     PlayerMirror = maps:get(PlayerId, PlayerMap, #mirror_player{id = PlayerId}),
%%     #mirror_player{embattle_list = EmbattleList} = PlayerMirror,
%%     EmbattleList2 = lib_partner_api:get_partner_embattle_2_core(PlayerId, EmbattleList),
%%     PlayerMirror2 = PlayerMirror#mirror_player{embattle_list = EmbattleList2},
%%     lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, M, F, [PlayerMirror2|A]),
%%     {noreply, State};
%% do_cast({send_rival_list, Args}, State) ->
%%     #mirror_state{player_map = PlayerMap} = State,
%%     lib_hero_war_mod:cast_send_rival_list(Args, PlayerMap),
%%     {noreply, State};
%% do_cast({'gm', print}, State) ->
%%     #mirror_state{
%%         player_map = PlayerMap, rank_map = RankMap,
%%         player_tmp_map = PlayerTmpMap, rank_tmp_map = RankTmpMap
%%     } = State,
%%     ?PRINT("print:~p~n", [
%%         {
%%             maps:size(PlayerMap), maps:size(RankMap), 
%%             maps:size(PlayerTmpMap), maps:size(RankTmpMap)
%%         }]),
%%     {noreply, State};
%% do_cast({'gm', clear}, _State) ->
%%     {noreply, #mirror_state{}};    
%% do_cast({'gm', garbage_collect}, State) ->
%%     erlang:garbage_collect(self()),
%%     {noreply, State};
%% do_cast(_Msg, State) ->
%%     {noreply, State}.

%% do_info('init', _State) ->
%% 	{ok, NewState} = lib_player_mirror_mod:server_init(),
%%     {noreply, NewState};
%% do_info({'timer_init_player_mirror_rank', Page, PageCount, TotalCount}, State) ->
%% 	{ok, NewState} = lib_player_mirror_mod:timer_init_player_mirror_rank(State, Page, PageCount, TotalCount),
%% 	{noreply, NewState};
%% do_info(_Info, State) ->
%%     {noreply, State}.   

%% %% --------------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %% --------------------------------------------------------------------------
%% init(Args) ->
%%     case catch do_init(Args) of
%%         {'EXIT', Reason} ->
%%             ?ERR("init error:~p~n", [Reason]),
%%             {stop, Reason};
%%         {ok, State} ->
%%             {ok, State};
%%         Other ->
%%             {stop, Other}
%%     end.

%% %% --------------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------------
%% handle_call(Request, From, State) ->
%%     case catch do_call(Request, From, State) of
%%         {'EXIT', Reason} ->
%%             ?ERR("handle_call error:~p~n", [Reason]),
%%             {reply, error, State};
%%         {reply, Reply, NewState} ->
%%             {reply, Reply, NewState};
%%         _ ->
%%             {reply, true, State}
%%     end.

%% %% --------------------------------------------------------------------------
%% %% Function: handle_cast/2
%% %% Description: Handling cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------------
%% handle_cast(Msg, State) ->
%%     case catch do_cast(Msg, State) of
%%         {'EXIT', Reason} ->
%%             ?ERR("handle_cast error:~p~n", [Reason]),
%%             {noreply, State};
%%         {noreply, NewState} ->
%%             {noreply, NewState};
%%         {stop, normal, NewState} ->
%%             {stop, normal, NewState};
%%         _ ->
%%             {noreply, State}
%%     end.

%% %% --------------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------------
%% handle_info(Info, State) ->
%%     case catch do_info(Info, State) of
%%         {'EXIT', Reason} ->
%%             ?ERR("handle_info error:~p~n", [Reason]),
%%             {noreply, State};
%%         {noreply, NewState} ->
%%             {noreply, NewState};
%%         _ ->
%%             {noreply, State}
%%     end.

%% %% --------------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %% --------------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%%     ok.

%% %% --------------------------------------------------------------------------
%% %% Func: code_change/3
%% %% Purpose: Convert process state when code is changed
%% %% Returns: {ok, NewState}
%% %% --------------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.

%% --------------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------------


