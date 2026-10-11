%%%-----------------------------------
%%% @Module      : mod_kf_chrono_rift_goal
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 07. 十二月 2019 11:19
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_kf_chrono_rift_goal).
-include("chrono_rift.hrl").
-author("carlos").
-include("common.hrl").
-include("errcode.hrl").
%% API
-export([]).

-define(MOD_STATE, server_goal_state).


start_link() ->
	gen_server:start_link({local, ?MODULE}, mod_kf_chrono_rift_goal, [], []).


init([]) ->
	State = init(),
	{ok, State}.

init() ->
	List = lib_chrono_rift_data:db_get_server_goal(),
	ServerList = [#server_goal{server_id = ServerId,
		server_name = binary_to_list(ServerName),
		server_num = ServerNum,
		goal_list = util:bitstring_to_term(GoalList)
		, last_rank = LastRank
	} || [ServerId, ServerName, ServerNum, GoalList, LastRank] <- List],
%%	?MYLOG("chrono", "ServerList ~p~n", [ServerList]),
	#server_goal_state{server_list = ServerList}.


set_goal_value(GoalType, ServerId, ServerNum, ServerName, V) ->
	gen_server:cast(?MODULE, {set_goal_value, GoalType, ServerId, ServerNum, ServerName, V}).

add_goal_value(GoalType, ServerId, ServerNum, ServerName, V) ->
	gen_server:cast(?MODULE, {add_goal_value, GoalType, ServerId, ServerNum, ServerName, V}).


get_season_goal_info(ServerId, RoleId, SeasonReward) ->
	gen_server:cast(?MODULE, {get_season_goal_info, ServerId, RoleId, SeasonReward}).


get_season_goal_reward(ServerId, RoleId, GoalId, Type, NeedValue) ->
	gen_server:cast(?MODULE, {get_season_goal_reward, ServerId, RoleId, GoalId, Type, NeedValue}).


re_start() ->
	gen_server:cast(?MODULE, {re_start}).

day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).

act_end() ->
	gen_server:cast(?MODULE, {act_end}).
%% GoalRankList::[{serverId, Rank}]
set_server_rank(ZoneId, GoalRankList) ->
	gen_server:cast(?MODULE, {set_server_rank, ZoneId, GoalRankList}).



handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
			{noreply, State}
	end.


handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
			{noreply, State}
	end.


do_handle_cast({re_start}, _State) ->
	NewState = init(),
	{noreply, NewState};


do_handle_cast({day_trigger}, State) ->
	#server_goal_state{server_list = ServerList} = State,
	%%特殊处理， goal1 且难度未 2， 3 的都需要清0
	F = fun(Server, AccList) ->
			#server_goal{goal_list = GoalList, last_rank = Rank} = Server,
			NeedLv = lib_kf_chrono_rift:get_lv_by_rank(Rank),
			if
				NeedLv >= 2 ->  %% 难度是2级以上
					GoalId = lib_kf_chrono_rift:get_goal_id_by_type_rank(?goal1, Rank),
					NeedValue = data_chrono_rift:get_goal_value(GoalId),
					case lists:keyfind(?goal1, 1, GoalList) of
						{_, Value} ->
							if
								NeedValue > Value ->  %% 没有完成
									NewGoalList = lists:keystore(?goal1, 1, GoalList, {?goal1, 0}),
									NewServer = Server#server_goal{goal_list = NewGoalList},
                                    lib_chrono_rift_data:db_save_server_goal(NewServer),
									[NewServer | AccList];
								true ->  %% 完成了
									[Server | AccList]
							end;
						_ ->
							[Server | AccList]
					end;
				true ->
					[Server | AccList]
			end
		end,
	NewServerList = lists:foldl(F, [], ServerList),
	{noreply, State#server_goal_state{server_list = NewServerList}};





do_handle_cast({set_server_rank, _ZoneId, GoalRankList}, State) ->
	#server_goal_state{server_list = ServertList} = State,
	F = fun({ServerId, Rank}, AccServerList) ->
			case lists:keyfind(ServerId, #server_goal.server_id, AccServerList) of
				#server_goal{} = Server ->
					NewServer = Server#server_goal{last_rank = Rank},
                    lib_chrono_rift_data:db_save_server_goal(NewServer),
					lists:keystore(ServerId, #server_goal.server_id, AccServerList, NewServer);
				_ ->
					AccServerList
			end
		end,
	LastServerList = lists:foldl(F, ServertList, GoalRankList),
	{noreply, State#server_goal_state{server_list = LastServerList}};


do_handle_cast({act_end}, _State) ->
	%%通知跨服信息
	#server_goal_state{server_list = ServerList} = _State,
	ZoneIds = mod_zone_mgr:get_all_zone_ids(),
	ZoneList = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
	[   begin
			ZoneId = lib_clusters_center_api:get_zone(ServerId),
			case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
				#zone_msg{status = ?act_open} ->
					mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, handle_act_end_goal_list, [GoalList, Rank]);
				_ ->
					skip
			end
		    end
		|| #server_goal{server_id = ServerId, last_rank = Rank, goal_list = GoalList}<-ServerList],
    lib_chrono_rift_data:db_clear_server_goal(),
	NewState = init(),
	{noreply, NewState};

do_handle_cast({get_season_goal_reward, ServerId, RoleId, GoalId, Type, NeedValue}, State) ->
	#server_goal_state{server_list = ServerList} = State,
	case lists:keyfind(ServerId, #server_goal.server_id, ServerList) of
		#server_goal{goal_list = GoalList, last_rank = _Rank} ->
			case lists:keyfind(Type, 1, GoalList) of
				{_, Value} ->
					if
						Value >= NeedValue ->  %% 完成任务了
							mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, finish_goal, [RoleId, GoalId, Type]);
						true -> %% 没有完成任务
							lib_kf_chrono_rift:send_error(ServerId, RoleId, ?ERRCODE(err204_goal_not_finish))
					end;
				_ ->
					lib_kf_chrono_rift:send_error(ServerId, RoleId, ?ERRCODE(err204_goal_not_finish))
			end;
		_ -> %% 第一次
			lib_kf_chrono_rift:send_error(ServerId, RoleId, ?ERRCODE(err204_goal_not_finish))
	end,
	{noreply, State};

do_handle_cast({get_season_goal_info, ServerId, RoleId, SeasonReward}, State) ->
	#server_goal_state{server_list = ServerList} = State,
	case lists:keyfind(ServerId, #server_goal.server_id, ServerList) of
		#server_goal{goal_list = GoalList, last_rank = Rank} ->
			skip;
		_ -> %% 第一次
			GoalList = ?goal_default_list,
			Rank = 0
	end,
	PackList = lib_kf_chrono_rift:get_pack_goal_info(GoalList, Rank, SeasonReward),
%%	?MYLOG("chrono", "PackList ~p~n", [PackList]),
	{ok, Bin} = pt_204:write(20407, [PackList]),
	lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
	{noreply, State};



do_handle_cast({set_goal_value, GoalType, ServerId, ServerNum, ServerName, V}, State) ->
	#server_goal_state{server_list = ServerList} = State,
	case lists:keyfind(ServerId, #server_goal.server_id, ServerList) of
		#server_goal{goal_list = GoalList} = OldServer ->
			NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, V}),
			NewServer = OldServer#server_goal{goal_list = NewGoalList},
            lib_chrono_rift_data:db_save_server_goal(NewServer),
			NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer);
		_ -> %% 第一次
			GoalList = ?goal_default_list,
			NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, V}),
			NewServer = #server_goal{goal_list = NewGoalList, server_id = ServerId, server_num = ServerNum, server_name = ServerName},
            lib_chrono_rift_data:db_save_server_goal(NewServer),
			NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer)
	end,
	mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, handle_cmd, [20407, []]),
	{noreply, State#server_goal_state{server_list = NewServerList}};


do_handle_cast({add_goal_value, GoalType, ServerId, ServerNum, ServerName, CastleLv}, State) when GoalType == ?goal4 ->  %% 任务4特别处理
	#server_goal_state{server_list = ServerList} = State,
	FinishLv = get_goal_lv_by_castle_lv(CastleLv),
%%	?MYLOG("chrono", "")
	case lists:keyfind(ServerId, #server_goal.server_id, ServerList) of
		#server_goal{goal_list = GoalList, last_rank = LastRank} = OldServer ->
			NeedLv = lib_kf_chrono_rift:get_lv_by_rank(LastRank),
			if
				FinishLv >= NeedLv ->  %% 完成对应的难度任务
					case lists:keyfind(GoalType, 1, GoalList) of
						{_, OldV} ->
							skip;
						_ ->
							OldV = 0
					end,
					NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, 1 + OldV}),
					NewServer = OldServer#server_goal{goal_list = NewGoalList},
                    lib_chrono_rift_data:db_save_server_goal(NewServer),
					NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer);
				true ->
					NewServerList = ServerList
			end;

		_ -> %% 第一次
			NeedLv = lib_kf_chrono_rift:get_lv_by_rank(0),
			if
				FinishLv >= NeedLv ->  %% 完成对应的难度任务
					GoalList = ?goal_default_list,
					NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, 1}),
					NewServer = #server_goal{goal_list = NewGoalList, server_id = ServerId, server_num = ServerNum, server_name = ServerName, last_rank = 0},
                    lib_chrono_rift_data:db_save_server_goal(NewServer),
					NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer);
				true ->
					NewServerList = ServerList
			end
	end,
	mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, handle_cmd, [20407, []]),
	{noreply, State#server_goal_state{server_list = NewServerList}};


do_handle_cast({add_goal_value, GoalType, ServerId, ServerNum, ServerName, V}, State) ->
	#server_goal_state{server_list = ServerList} = State,
	case lists:keyfind(ServerId, #server_goal.server_id, ServerList) of
		#server_goal{goal_list = GoalList} = OldServer ->
			case lists:keyfind(GoalType, 1, GoalList) of
				{_, OldV} ->
					skip;
				_ ->
					OldV = 0
			end,
			NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, V + OldV}),
			NewServer = OldServer#server_goal{goal_list = NewGoalList},
            lib_chrono_rift_data:db_save_server_goal(NewServer),
			NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer);
		_ -> %% 第一次
			GoalList = ?goal_default_list,
			NewGoalList = lists:keystore(GoalType, 1, GoalList, {GoalType, V}),
			NewServer = #server_goal{goal_list = NewGoalList, server_id = ServerId, server_num = ServerNum, server_name = ServerName, last_rank = 0},
            lib_chrono_rift_data:db_save_server_goal(NewServer),
			NewServerList = lists:keystore(ServerId, #server_goal.server_id, ServerList, NewServer)
	end,
	mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, handle_cmd, [20407, []]),
	{noreply, State#server_goal_state{server_list = NewServerList}};








do_handle_cast(_Request, State) ->
	?MYLOG("chrono", "nomatch _Request ~p ~n", [_Request]),
	{noreply, State}.


do_handle_info(_Request, State) ->
	{noreply, State}.




test1() ->
	set_goal_value(1, 1, 1, "11", 1).

test2() ->
	add_goal_value(1, 1, 1, "11", 5).


%%据点等级对应任务难度  针对任务 4
get_goal_lv_by_castle_lv(CastleLv) ->
	if
		CastleLv >= 5 ->
			3;  %% 3级难度
		CastleLv >= 4 ->
			2;  %% 2级难度
		CastleLv >= 3 ->
			1;  %% 1级难度
		true ->  %% 0级难度
			0
	end.
