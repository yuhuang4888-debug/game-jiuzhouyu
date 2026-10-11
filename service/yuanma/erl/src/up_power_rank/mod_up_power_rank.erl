%%%-----------------------------------
%%% @Module      : mod_up_power_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 04. 六月 2020 17:52
%%% @Description : 战力升榜 定制活动
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_up_power_rank).
-author("carlos").

%% API
-export([]).


-include("up_power_rank.hrl").
-include("common.hrl").

%% API
-export([]).


-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%%%% @param [{RankType, CommonRankRole}]
%%refresh_rush_rank_by_list(List) ->
%%	gen_server:cast({global, ?MODULE}, {'refresh_rush_rank_by_list', List}).

%% 根据类型刷新榜单
refresh_rush_rank(SubType, RushRole) ->
	gen_server:cast({global, ?MODULE}, {'refresh_rush_rank', SubType, RushRole}).

%% 发送榜单的数据
send_rank_list(SubType, RoleId, SelValue) ->
	gen_server:cast({global, ?MODULE}, {'send_rank_list', SubType, RoleId, SelValue}).



act_end(SubType) ->
	gen_server:cast({global,  ?MODULE}, {'act_end', SubType}).

%% ---------------------------------------------------------------------------
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
init([]) ->
	State = lib_up_power_rank_mod:init(),
	{ok, State}.


handle_call(_Request, _From, State) ->
	%% ?ERR1("Handle unkown request[~w]~n", [_Request]),
	Reply = ok,
	{reply, Reply, State}.

%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{ok, NewState} ->
			{noreply, NewState};
		Err ->
			%% util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
			?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
			{noreply, State}
	end.

%%do_handle_cast({'refresh_rush_rank_by_list', List}, State) ->
%%	lib_up_power_rank_mod:refresh_rush_rank_by_list(State, List);
do_handle_cast({'refresh_rush_rank', SubType, RushRole}, State) ->
	lib_up_power_rank_mod:refresh_rush_rank(State, SubType, RushRole);
do_handle_cast({'send_rank_list', SubType, RoleId, SelValue}, State) ->
	lib_up_power_rank_mod:send_rank_list(State, SubType, RoleId, SelValue),
	{ok, State};


do_handle_cast({'act_end', SubType}, State) ->
%%	?PRINT("SubType ~p~n", [SubType]),
	NewState = lib_up_power_rank_mod:act_end(State, SubType),
	{ok, NewState};

%%do_handle_cast({'apply_cast', M, F, A}, State) ->
%%	lib_rush_rank_mod:apply_cast(State, M, F, A);

do_handle_cast(_Msg, State) ->
	%% ?ERR1("Handle unkown msg[~w]~n", [_Msg]),
	{ok, State}.

%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
	?ERR("Handle unkown info[~w]~n", [_Info]),
	{noreply, State}.


%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
