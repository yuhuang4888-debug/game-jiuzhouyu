%% ---------------------------------------------------------------------------
%% @doc gen_server模板
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-define(DEBUG_MODULE,   none).
-define(DEBUG_REQUEST,  none).
-define(LOCAL_DEBUG(Format, Args),
    case ?MODULE of
        ?DEBUG_MODULE -> ?PRINT(Format, Args);
        _ -> skip
    end
).
-define(LOCAL_DEBUG(Request, Format, Args),
    case {?MODULE, Request} of
        {?DEBUG_MODULE, DEBUG_REQUEST} -> ?PRINT(Format, Args);
        _ -> skip
    end
).

%% --------------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------------
-define(DO_INIT(Args), 
        case catch do_init(Args) of
            {'EXIT', Reason} ->                
                ?ERR("init error:~n~p~n", [Reason]),
                {stop, Reason};
            {ok, State} ->
                {ok, State};
            Other ->
                {stop, Other}
        end
).

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
-define(DO_HANDLE_CALL(Request, From, State),
        case catch do_handle_call(Request, From, State) of
            {'EXIT', Reason} ->
                ?ERR("handle_call Request:~p Reason:~p ~n", [Request, Reason]),
                {reply, error, State};
            {reply, Reply, NewState} ->
                {reply, Reply, NewState};
            _Error ->
                ?ERR("handle_call Request:~p no match:~p~n", [Request, _Error]),
                {noreply, no_match, State}
        end
).

%% --------------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
-define(DO_HANDLE_CAST(Msg, State),
        case catch do_handle_cast(Msg, State) of
            {'EXIT', Reason} ->
                ?ERR("handle_cast Msg:~p Reason:~p ~n", [Msg, Reason]),
                {noreply, State};
            {noreply, NewState} ->
                {noreply, NewState};
            {stop, normal, NewState} ->
                {stop, normal, NewState};
            ok -> 
                {noreply, State};
            _Error ->
                ?ERR("handle_cast Msg:~p no match:~n~p~n", [Msg, _Error]),
                {noreply, State}
        end
).

%% --------------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
-define(DO_HANDLE_INFO(Info, State),
        case catch do_handle_info(Info, State) of
            {'EXIT', Reason} ->
                ?ERR("handle_info Info:~p Reason:~p ~n", [Info, Reason]),
                {noreply, State};
            {noreply, NewState} ->
                {noreply, NewState};
            ok -> 
                {noreply, State};
            _Error ->
                ?ERR("handle_info Info:~p no match:~n~p~n", [Info, _Error]),
                {noreply, State}
        end
).

%% --------------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------------
-define(DO_TERMINATE(Reason, State),
        case catch do_terminate(Reason, State) of
            ok -> ok;
            {'EXIT', Reason} ->
                ?ERR("terminate error:~n~p~n", [Reason]),
                {noreply, State};
            {noreply, NewState} ->
                {noreply, NewState};
            _ ->
                {noreply, State}
        end
).

%% --------------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------------
-define(DO_CODE_CHANGE(OldVsn, State, Extra),
        case catch do_code_change(OldVsn, State, Extra) of
            {ok, NewState} -> {ok, NewState};
            {'EXIT', Reason} ->
                ?ERR("code_change error:~n~p~n", [Reason]),
                {ok, State};
            {noreply, NewState} ->
                {ok, NewState};
            _ ->
                {ok, State}
        end
).