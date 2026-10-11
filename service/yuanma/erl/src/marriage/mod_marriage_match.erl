%%-----------------------------------------------------------------------------
%% @Module  :       mod_marriage_match.erl
%% @Author  :       J
%% @Email   :       
%% @Created :       2017-12-06
%% @Description:    
%%-----------------------------------------------------------------------------

-module(mod_marriage_match).

-include("common.hrl").
-include("marriage.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export([
	start_link/0
	, enter_match/4
	, cancel_match/1
	, logout/1
]).

-record(state, {
	match_ref = undefined,
	match_id = 1,
	match_queue = [],
	pair_list = []
}).

-record(match_info, {
	role_id = 0,
	match_id = 0,
	agree = 0,
	dun_id = 0,
	figure = [],
	power = 0,
	time = 0
}).


-define(MATCH_TIME_SPACE_MS, 8000).  %%匹配时间间隔

%% API
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

enter_match(RoleId, DunId, Figure, Power) ->
	gen_server:cast(?MODULE, {enter_match, RoleId, DunId, Figure, Power}).

cancel_match(RoleId) ->
	gen_server:cast(?MODULE, {cancel_match, RoleId}).

logout(RoleId) ->
	gen_server:cast(?MODULE, {logout, RoleId}).

%% private
init([]) ->
	{ok, #state{}}.

handle_call(Msg, From, State) ->
	case catch do_handle_call(Msg, From, State) of
		{'EXIT', Error} ->
			?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
			{reply, error, State};
		Return ->
			Return
	end.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{'EXIT', Error} ->
			?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
			{noreply, State};
		Return ->
			Return
	end.

handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		{'EXIT', Error} ->
			?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
			{noreply, State};
		Return ->
			Return
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

do_handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

do_handle_cast({logout, RoleId}, State) ->
	#state{match_queue = MatchQueue} = State,
	NewMatchQueue = lists:keydelete(RoleId, #match_info.role_id, MatchQueue),
	{noreply, State#state{match_queue = NewMatchQueue}};

do_handle_cast({enter_match, RoleId, DunId, Figure, Power}, State) ->
	#state{match_ref = MatchRef, match_queue = MatchQueue} = State,
	case lists:keyfind(RoleId, #match_info.role_id, MatchQueue) of
		false ->
			Info = #match_info{role_id = RoleId, dun_id = DunId, figure = Figure, power = Power, time = utime:unixtime()},
			NewMatchQueue = [Info|MatchQueue],
			NewState = State#state{match_queue = NewMatchQueue};
		_ ->
			Info = #match_info{role_id = RoleId, dun_id = DunId, figure = Figure, power = Power, time = utime:unixtime()},
			NewMatchQueue = [Info|lists:keydelete(RoleId, #match_info.role_id, MatchQueue)],
			NewState = State#state{match_queue = NewMatchQueue}
	end,
	?PRINT("enter_match LastMatchQueue ~p~n", [length(NewState#state.match_queue)]),
	if
		is_reference(MatchRef) =:= false ->
			do_handle_info({timeout, MatchRef, match}, NewState); %%开始匹配
		true ->
			{noreply, NewState}
	end;

do_handle_cast({cancel_match, RoleId}, State) ->
	#state{match_queue = MatchQueue} = State,
	NewMatchQueue = lists:keydelete(RoleId, #match_info.role_id, MatchQueue),
	{noreply, State#state{match_queue = NewMatchQueue}};

do_handle_cast(_Msg, State) ->
	{noreply, State}.

do_handle_info({timeout, TimerRef, match}, #state{match_ref = TimerRef, match_queue = OldMatchQueue} = State) ->
	case OldMatchQueue of
		[] ->
			{noreply, State#state{match_ref = undefined}};
		_ ->
			Ref = erlang:start_timer(?MATCH_TIME_SPACE_MS, self(), match),  %%开始匹配
			NewState = do_match(State),
			{noreply, NewState#state{match_ref = Ref}}
	end;

do_handle_info({prepare_enter_dun, MatchId}, State) ->
	#state{pair_list = PairList} = State,
	F = fun({Male, _FeMale}) -> Male#match_info.match_id == MatchId end,
	{PrepareEnterList, LeftPairList} = lists:partition(F, PairList),
	spawn(fun() -> prepare_enter_dun(PrepareEnterList) end),
	{noreply, State#state{pair_list = LeftPairList}};

do_handle_info(_Msg, State) ->
	{noreply, State}.

do_match(State) ->
	#state{match_id = MatchId, match_queue = MatchQueue, pair_list = OldPairList} = State,
	MatchQueueNew = lists:reverse(lists:keysort(#match_info.time, MatchQueue)),
	DunMatchList = divide_group_by_dun(MatchQueueNew, []),
	F = fun({_DunId, MatchList}, {List1, List2, Acc}) ->
		{MaleList, FeMaleList} = lists:partition(fun(#match_info{figure = Figure}) -> Figure#figure.sex == ?MALE end, MatchList),
		{LeftMatchList, PairList, NewAcc} = do_match_1(MaleList, FeMaleList, [], [], MatchId, Acc),
		{LeftMatchList++List1, PairList++List2, NewAcc}
	end,
	{LastMatchQueue, LastPairList, _} = lists:foldl(F, {[], [], 1}, DunMatchList),
	?PRINT("do_match LastMatchQueue ~p~n", [length(LastMatchQueue)]),
	?PRINT("do_match LastPairList ~p~n", [length(LastPairList)]),
	case length(LastPairList) > 0 of 
		true ->
			NewMatchId = MatchId + 1, NewPairList = LastPairList ++ OldPairList,
			push_info_to_pairs(LastPairList),
			util:send_after([], 5000, self(), {prepare_enter_dun, MatchId});
		_ -> NewMatchId = MatchId, NewPairList = OldPairList
	end,
	State#state{match_id = NewMatchId, match_queue = LastMatchQueue, pair_list = NewPairList}.

divide_group_by_dun([], Return) -> Return;
divide_group_by_dun([Item|MatchQueueNew], Return) ->
	DunId = Item#match_info.dun_id,
	{_, OL} = ulists:keyfind(DunId, 1, Return, {DunId, []}),
	divide_group_by_dun(MatchQueueNew, lists:keystore(DunId, 1, Return, {DunId, [Item|OL]})).


do_match_1([], FeMaleList, LeftMatchQueue, PairList, _MatchId, Acc) ->
	{FeMaleList ++ LeftMatchQueue, PairList, Acc};
do_match_1(MaleList, [], LeftMatchQueue, PairList, _MatchId, Acc) ->
	{MaleList ++ LeftMatchQueue, PairList, Acc};
do_match_1(MaleList, FeMaleList, LeftMatchQueue, PairList, _MatchId, Acc) when Acc>20 ->	%% 暂时每次匹配20对玩家
	{MaleList ++ FeMaleList ++ LeftMatchQueue, PairList, Acc};
do_match_1([Male|MaleList], [FeMale|FeMaleList], LeftMatchQueue, PairList, MatchId, Acc) ->
	NewPairList = [{Male#match_info{match_id=MatchId}, FeMale#match_info{match_id=MatchId}}|PairList],
	do_match_1(MaleList, FeMaleList, LeftMatchQueue, NewPairList, MatchId, Acc+1).

prepare_enter_dun(PairList) ->
	prepare_enter_dun(PairList, 1).

prepare_enter_dun([], _Count) -> ok;
prepare_enter_dun([{Male, FeMale}|PairList], Count) ->
	Count rem 5 == 0 andalso timer:sleep(200),
	#match_info{role_id = MaleId, dun_id = DunId} = Male,
	#match_info{role_id = FeMaleId} = FeMale,
	MalePid = lib_player:get_alive_pid(MaleId),
	FeMalePid = lib_player:get_alive_pid(FeMaleId),
	?PRINT("prepare_enter_dun start ~p~n", [{MaleId, FeMaleId, DunId}]),
	if
		MalePid == false ->
			lib_player:apply_cast(FeMaleId, ?APPLY_CAST_STATUS, lib_marriage, clear_marriage_match_state, [MaleId, DunId, 1]),
			ok;
		FeMalePid == false ->
			lib_player:apply_cast(MaleId, ?APPLY_CAST_STATUS, lib_marriage, clear_marriage_match_state, [FeMaleId, DunId, 2]),
			ok;
		true ->
			lib_marriage:push_role_into_dun(MaleId, FeMaleId, DunId)
	end,
	prepare_enter_dun(PairList, Count+1).


push_info_to_pairs(PairList) ->
	F = fun({Male, FeMale}) ->
		#match_info{role_id = MaleId, figure = MaleFigure, power = MalePower} = Male,
		#match_info{role_id = FeMaleId, figure = FeMaleFigure, power = FeMalePower} = FeMale,
		{ok, Bin} = pt_172:write(17246, [1, [{1, MaleId, MaleFigure, MalePower}, {2, FeMaleId, FeMaleFigure, FeMalePower}], 5]),
		lib_server_send:send_to_uid(MaleId, Bin),
		lib_server_send:send_to_uid(FeMaleId, Bin)
	end,
	lists:foreach(F, PairList).

