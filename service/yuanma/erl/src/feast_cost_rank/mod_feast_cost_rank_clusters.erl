%%%-----------------------------------
%%% @Module      : mod_feast_cost_rank_clusters
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 06. 十二月 2018 15:57
%%% @Description : 文件摘要
%%%-----------------------------------
-module(mod_feast_cost_rank_clusters).
-author("chenyiming").
-include("custom_act.hrl").
-include("feast_cost_rank.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%-------------------------------------api----------------------------- ()
refresh_rank(RoleRank) ->
%%	?MYLOG("cym", "RoleRank  ~p~n", [RoleRank]),
	case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2) of
		true ->
%%			?MYLOG("cym", "RoleRank  ~p~n", [RoleRank]),
%%			ZoneId = lib_clusters_center_api:get_zone(RoleRank#role_rank_clusters.server_id),
			case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2) of
				[#act_info{key = {_, SubType}} | _] ->
					case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType) of
						#custom_act_cfg{condition = Conditon, end_time = EndTime} ->
							ZoneId = 0, %% 改为大跨服，全部为0
							PreTime = lib_feast_cost_rank_clusters:get_pre_time(Conditon),
							Now = utime:unixtime(),
%%							?MYLOG("cost_rank", "~p  ~n", [{Now, EndTime, PreTime}]),
							if
								Now > EndTime - PreTime ->  %% 结算前的一段时间是刷新是没有用的
									sikp;
								true ->
									gen_server:cast({global, ?MODULE}, {'refresh_rank', RoleRank#role_rank_clusters{server_zone_id = ZoneId}})
							end;
						_ ->
							skip
					end;
				_ ->
					skip
			end;
		_ ->
%%			?MYLOG("cym", "RoleRank  ~p~n", [RoleRank]),
			skip
	end.
send_to_client(RoleId, ServerId) ->
	gen_server:cast({global, ?MODULE}, {'send_to_client', RoleId, ServerId}).
act_end(SubType) ->
	?MYLOG("cym", "end ++++++++~n", []),
	gen_server:cast({global, ?MODULE}, {'act_end', SubType}).
act_start(SubType) ->
	gen_server:cast({global, ?MODULE}, {'act_start', SubType}).
zone_change(ServerId, OldZone, NewZone) ->
	gen_server:cast({global, ?MODULE}, {'zone_change', ServerId, OldZone, NewZone}).
%%-------------------------------------api-----------------------------


%% ---------------------------------------------------------------------------
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
init([]) ->
	State = init(),
	{ok, State}.


init() ->
	Sql1 = io_lib:format(?select_feast_cost_rank_clusters_zone, []),
	ZoneIdList = db:get_all(Sql1),
	ZoneMap = lib_feast_cost_rank_clusters:init_state_from_db_help(lists:flatten(ZoneIdList), #{}),
	#feast_cost_clusters_state{rank_map = ZoneMap}.


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

do_handle_cast({'refresh_rank', RoleRank}, State) ->
	?MYLOG("cym", "RoleRank  ~p~n", [RoleRank]),
	NewState = lib_feast_cost_rank_clusters:refresh_rank(RoleRank, State),
	{ok, NewState};

do_handle_cast({'send_to_client', RoleId, ServerId}, State) ->
	lib_feast_cost_rank_clusters:send_to_client(RoleId, ServerId, State),
	{ok, State};

do_handle_cast({'act_end', SubType}, State) ->
	NewState = lib_feast_cost_rank_clusters:act_end(State, SubType),
	{ok, NewState};
do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State) ->
	NewState = lib_feast_cost_rank_clusters:zone_change(State, ServerId, OldZone, NewZone),
	?MYLOG("cym", "NewState ~p~n", [NewState]),
	{ok, NewState};

do_handle_cast({'act_start', SubType}, State) ->
	NewState = lib_feast_cost_rank_clusters:act_start(State, SubType),
	{ok, NewState};

do_handle_cast(_, State) ->
	?DEBUG("no match ~n", []),
	{ok, State}.

%%-------------------------------------handle----------------------------