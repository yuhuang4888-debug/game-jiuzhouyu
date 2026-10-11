%% ---------------------------------------------------------------------------
%% @doc 跨服自增Id服务
%% @author lxl
%% @since  2020-08-28
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (mod_id_create_cls).
-behaviour(gen_server).
-include ("common.hrl").
-include ("def_id_create.hrl").
-include ("clusters.hrl").

%% API
-export([get_new_id/1, get_new_id/2, start_link/0, node_conn/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {server_id = 0, rand_server_id = 0, id_map = #{}}).

%%% Usage: 
%%% 新增Id类型步骤
%%% 1. def_id_create.hrl中定义一个Id类型（IdType）
%%% End.

get_new_id(IdType) -> 
    gen_server:call(?MODULE, {'get_new_id', IdType}).

get_new_id(_IdType, 0) -> [];
get_new_id(IdType, Count) -> 
    gen_server:call(?MODULE, {'get_new_id', IdType, Count}).

node_conn(ServerId) ->
    gen_server:cast(?MODULE, {node_conn, ServerId}).

start_link() ->	
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).


do_init([]) ->
	process_flag(priority, high),
    case db:get_all(io_lib:format(<<"select type, count from auto_id_cls ">>, [])) of
        [] -> IdMap = #{};
        DbList -> 
            IdMap = lists:foldl(fun([IdType, Count], Map) -> maps:put(IdType, Count+1, Map) end, #{}, DbList)
    end,    
    % case ets:tab2list(lib_zone:ets_name(?ZONE_TYPE_1)) of 
    %     [] -> ServerId = 0;
    %     EtsServerList ->
    %         ServerId = lists:min([SerId ||#clusters_zone{server_id = SerId} <- EtsServerList])
    % end,
    ServerId = config:get_server_id(),
    {ok, #state{server_id = ServerId, rand_server_id = erlang:phash2(node(), 16#FFFF), id_map = IdMap}}.

do_call({'get_new_id', IdType}, _From, #state{server_id=SerId, rand_server_id = RandServerId, id_map = IdMap} = State) ->
    LastId = maps:get(IdType, IdMap, 1),
    case SerId == 0 of 
        true -> 
            <<AutoId:48>> = <<RandServerId:16, LastId:32>>;
        _ ->
            <<AutoId:48>> = <<SerId:16, LastId:32>>
    end,
    case catch db:execute(io_lib:format(<<"replace into auto_id_cls set type=~w, count=~w">>, [IdType, LastId])) of
        {'EXIT', _} = Reason -> ?ERR("get_new_id error = ~p", [Reason]);
        _ -> skip
    end,
    NewIdMap = maps:put(IdType, LastId+1, IdMap),
    {reply, AutoId, State#state{id_map = NewIdMap}};

do_call({'get_new_id', IdType, Count}, _From, #state{server_id=SerId, rand_server_id = RandServerId, id_map = IdMap} = State) ->
    LastId = maps:get(IdType, IdMap, 1),
    case SerId == 0 of 
        true -> 
            <<AutoId:48>> = <<RandServerId:16, LastId:32>>;
        _ ->
            <<AutoId:48>> = <<SerId:16, LastId:32>>
    end,
    case catch db:execute(io_lib:format(<<"replace into auto_id_cls set type=~w, count=~w">>, [IdType, LastId+Count])) of
        {'EXIT', _} = Reason -> ?ERR("get_new_id error = ~p", [Reason]);
        _ -> skip
    end,
    NewIdMap = maps:put(IdType, LastId+Count, IdMap),
    AutoIdList = lists:seq(AutoId, AutoId+Count-1),
    {reply, AutoIdList, State#state{id_map = NewIdMap}};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast({node_conn, ServerId}, #state{server_id=SerId} = State) ->
    case SerId == 0 of 
        true -> 
            NewState = State#state{server_id = ServerId};
        _ ->
            NewState = State
    end, 
    {noreply, NewState};

do_cast(stop, State) ->
    {stop, normal, State};

do_cast(_Msg, State) ->
    {noreply, State}.

do_info(_Info, State) ->
    {noreply, State}.   

%% --------------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------------
init(Args) ->
    case catch do_init(Args) of
        {'EXIT', Reason} ->
            ?ERR("init error:~p~n", [Reason]),
            {stop, Reason};
        {ok, State} ->
            {ok, State};
        Other ->
            {stop, Other}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

%% --------------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------------

