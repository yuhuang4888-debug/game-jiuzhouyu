%% ---------------------------------------------------------------------------
%% @doc 自增Id服务
%% @author hek
%% @since  2016-11-30
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (mod_id_create).
-behaviour(gen_server).
-include ("common.hrl").
-include ("def_id_create.hrl").

%% API
-export([get_new_id/1, get_serid_by_id/1, start_link/1, start_transaction/1, commit/1, abnormal_commit/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {last_id = 1, server_id = 1, id_type = 0}).

%%% Usage: 
%%% 新增Id类型步骤
%%% 1. def_id_create.hrl中定义一个Id类型（IdType）
%%% 2. gsrv_server_base中添加mod_id_create:start_link(IdType)
%%% 3. mod_id_create中实现该IdType的get_last_id函数
%%% End.

get_new_id(IdType) -> 
    gen_server:call(misc:get_autoid_process(IdType), 'get_new_id').

get_serid_by_id(Id) -> 
    <<SerId:16, _/binary>> = <<Id:48>>,
    SerId.

%% 自增id不立即写数据库，提交再写
start_transaction(IdType) ->
    gen_server:call(misc:get_autoid_process(IdType), 'start_transaction').

commit(IdType) ->
    gen_server:call(misc:get_autoid_process(IdType), 'commit').

abnormal_commit(IdType) ->
    commit(IdType).

start_link(IdType) ->	
	ProcessName = misc:autoid_process_name(IdType),
    gen_server:start_link({global, ProcessName}, ?MODULE, [IdType, ProcessName], []).

%% --------------------------------- %% ---------------------------------
%% 注：新增Id类型，
%% --------------------------------- %% ---------------------------------

% get_last_id(?PLAYER_ID_CREATE) ->
% 	SerId = config:get_server_id(),
% 	db:get_row(io_lib:format(<<"select id from player_login where server_id=~w order by id desc limit 1">>, [SerId]));
get_last_id(?GOODS_ID_CREATE) ->
	db:get_row(io_lib:format(<<"select id from goods where 1=1 order by id desc limit 1">>, []));

get_last_id(?GUILD_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from guild where 1=1 order by id desc limit 1">>, []));

get_last_id(?AUCTION_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select auction_id from auction where 1=1 order by auction_id desc limit 1">>, []));

get_last_id(?AUCTION_GOODS_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select goods_id from auction_goods where 1=1 order by goods_id desc limit 1">>, []));

get_last_id(?MAIL_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from mail_attr where 1=1 order by id desc limit 1">>, []));

get_last_id(?PARTNER_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from partner where 1=1 order by id desc limit 1">>, []));

get_last_id(?LOC_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select `loc_id` from `house_furniture_location` where 1=1 order by `loc_id` desc limit 1">>, []));
   
%% get_last_id(?DSGT_ID_CREATE) ->
%%     db:get_row(io_lib:format(<<"select auto_id from designation where 1=1 order by id desc limit 1">>, []));

get_last_id(?SELL_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from sell_list where 1=1 order by id desc limit 1">>, []));

get_last_id(?CHARGE_PAY_NO_CREATE) ->
    db:get_row(io_lib:format(<<"select id from charge where 1=1 order by id desc limit 1">>, []));

get_last_id(?FLOWER_GIFT_RECORD_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from flower_gift_record where 1=1 order by id desc limit 1">>, []));

get_last_id(?GUILD_DEPOT_GOODS_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from guild_depot_goods where 1=1 order by id desc limit 1">>, []));
    
get_last_id(?RED_ENVELOPES_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from red_envelopes where 1=1 order by id desc limit 1">>, []));

get_last_id(?WEDDING_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from marriage_wedding_order_info where 1=1 order by id desc limit 1">>, []));

get_last_id(?CONSUME_RECORD_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from consume_record where 1=1 order by id desc limit 1">>, []));

get_last_id(?TEAM_3V3_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select team_id from team_3v3 where 1=1 order by team_id desc limit 1">>, []));

get_last_id(?GUILD_DAILY_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select id from guild_daily where 1=1 order by id desc limit 1">>, []));

get_last_id(?SHIPPING_ID_CREATE) ->
    db:get_row(io_lib:format(<<"select value from sea_auto_id where 1=1 order by value desc limit 1">>, []));

get_last_id(?AUTHENTICATION_ID_CREATE) ->
    [];

get_last_id(?ASSIST_ID_CREATE) ->
    [];

    
get_last_id(_IdType) ->
	?ERR("unkown id_type:~p", [_IdType]),
	[].

do_init([IdType, ProcessName]) ->
	process_flag(priority, high),
	misc:register(global, ProcessName, self()),
    AutoId = case db:get_row(io_lib:format(<<"select count from auto_id where type=~w">>, [IdType])) of
        [] -> 0;
        [TmpAutoId|_] -> TmpAutoId
    end,    
    SerId = config:get_server_id(),
    LastId = case get_last_id(IdType) of
    	[] -> AutoId + 1;
        [Id|_] ->        
            <<_:16, TmpLastId:32>> = <<Id:48>>,
            max(TmpLastId, AutoId) + 1
    end,
    {ok, #state{last_id = LastId, server_id = SerId, id_type = IdType}}.

do_call('get_new_id', _From, #state{last_id=LastId, server_id=SerId, id_type = IdType} = State) ->
	<<AutoId:48>> = <<SerId:16, LastId:32>>,
    Transaction = get(transaction),
    case Transaction of 
        {TransactionCnt, _OldLastId} when TransactionCnt > 0 -> skip;
        _ ->
            case catch db:execute(io_lib:format(<<"replace into auto_id set type=~w, count=~w">>, [IdType, LastId])) of
                {'EXIT', _} = Reason -> ?ERR("get_new_id error = ~p", [Reason]);
                _ -> skip
            end
    end,
    {reply, AutoId, State#state{last_id=LastId+1}};

do_call('start_transaction', _From, #state{last_id=LastId} = State) ->
    case get(transaction) of 
        undefined -> Transaction = {1, LastId};
        {TransactionCnt, OldLastId} -> Transaction = {TransactionCnt+1, min(OldLastId, LastId)}
    end,
    put(transaction, Transaction),
    {reply, ok, State};

do_call('commit', _From, #state{last_id=LastId, id_type = IdType} = State) ->
    case get(transaction) of 
        undefined -> OldLastId = 0;
        {TransactionCnt, OldLastId} -> 
            put(transaction, {TransactionCnt-1, LastId})
    end,
    case LastId > OldLastId of 
        true ->
            catch db:execute(io_lib:format(<<"replace into auto_id set type=~w, count=~w">>, [IdType, LastId]));
        _ -> skip
    end,
    {reply, ok, State};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

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

