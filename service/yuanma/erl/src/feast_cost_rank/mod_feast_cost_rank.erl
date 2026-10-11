%%%-----------------------------------
%%% @Module      : mod_feast_cost_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 06. 十二月 2018 15:57
%%% @Description : 文件摘要
%%%-----------------------------------
-module(mod_feast_cost_rank).
-author("chenyiming").
-include("feast_cost_rank.hrl").
-include("custom_act.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%-------------------------------------api-----------------------------  act_end()
refresh_rank(RoleRank) ->
	gen_server:cast({global, ?MODULE},  {'refresh_rank', RoleRank}).

send_to_client(RoleId) ->
	gen_server:cast({global, ?MODULE},  {'send_to_client', RoleId}).
act_end(SubType) ->
	gen_server:cast({global, ?MODULE},  {'act_end', SubType}).

act_start(SubType) ->
	gen_server:cast({global, ?MODULE},  {'act_start', SubType}).

repair() ->
	gen_server:cast({global, ?MODULE},  {'repair'}).
%%-------------------------------------api-----------------------------


%% ---------------------------------------------------------------------------
start_link() ->
	gen_server:start_link({global, ?MODULE},  ?MODULE,  [],  []).

%% ---------------------------------------------------------------------------
init([]) ->
	State = init(),
	{ok, State}.


init() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	if
		IsOpen == true->
%%			?MYLOG("cym2", "IsOpen +++++++++++~n", []),
			Sql = io_lib:format(?select_feast_cost_rank_all, [lib_feast_cost_rank:get_limit_lv(),
				lib_feast_cost_rank:get_limit_cost(),   lib_feast_cost_rank:get_limit_length()]),
			List = db:get_all(Sql),
			RoleRankList =  [#role_rank{role_id = RoleId, role_name = RoleName, cost = Cost, refresh_time = RefreshTime, lv = Lv}
				|| [RoleId, RoleName, Cost, RefreshTime, Lv] <- List],
			Length = length(RoleRankList),
			MinCost = case  RoleRankList of
				[] ->
					0;
				_ ->
					[#role_rank{cost = Cost}] = lists:sublist(RoleRankList, Length, 1),
					Cost
			end,
			LastRoleRankList = lib_feast_cost_rank:set_rank(RoleRankList),
			#feast_cost_state{rank_list = LastRoleRankList, length = Length, limit_cost = lib_feast_cost_rank:get_limit_cost(), min_cost = MinCost};
		true ->
			#feast_cost_state{}
	end.
	


%%-------------------------------------handle----------------------------
%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{ok, NewState} ->
			{noreply, NewState};
		Err ->
			?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
			{noreply, State}
	end.

do_handle_cast({'refresh_rank',  RoleRank}, State) ->
	NewState = lib_feast_cost_rank:refresh_rank(RoleRank, State),
	{ok, NewState};

do_handle_cast({'send_to_client', RoleId}, State) ->
	lib_feast_cost_rank:send_to_client(RoleId, State),
	{ok, State};

do_handle_cast({'act_end', SubType}, State) ->
	NewState = lib_feast_cost_rank:act_end(State, SubType),
	{ok, NewState};

do_handle_cast({'act_start', SubType}, State) ->
	NewState = lib_feast_cost_rank:act_start(State, SubType),
	{ok, NewState};

do_handle_cast({'repair'}, State) ->
	NewState = lib_feast_cost_rank:act_start(State),
	{ok, NewState};

do_handle_cast(_,  State) ->
	?DEBUG("no match ~n",  []),
	{ok, State}.

%%-------------------------------------handle----------------------------