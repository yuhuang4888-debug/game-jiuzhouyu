%%%-----------------------------------
%%% @Module      : mod_kf_chrono_rift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 27. 十一月 2019 15:20
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_kf_chrono_rift_scramble_rank).
-author("carlos").

%% API
-export([]).




-include("chrono_rift.hrl").
-include("common.hrl").
-include("errcode.hrl").

-define(MOD_STATE, chrono_rift_rank_state).     %

%% API
-export([]).




start_link() ->
	gen_server:start_link({local, ?MODULE}, mod_kf_chrono_rift_scramble_rank, [], []).

%% 增加玩家的争夺值
set_role_scramble_value(Role, Value) ->
	?MYLOG("chrono", "Role, Value ~p~n", [{Role, Value}]),
	gen_server:cast(?MODULE, {set_role_scramble_value, Role, Value}).

get_role_rank_list(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_role_rank_list, ServerId, RoleId}).


act_end() ->
	gen_server:cast(?MODULE, {act_end}).

re_start() ->
	gen_server:cast(?MODULE, {re_start}).

day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).

init([]) ->
	State = init(),
	{ok, State}.

init() ->
	List = lib_chrono_rift_data:db_get_rank_role(),
	RoleList = [
		#rank_role_msg{role_id = RoleId,
			role_name = binary_to_list(RoleName),
			server_id = ServerId,
			server_num = ServerNum
			, server_name = binary_to_list(ServerName)
			, scramble_value = ScrambleValue
		}
		|| [RoleId, RoleName, ServerId, ServerNum, ServerName, ScrambleValue] <- List],
	F = fun(#rank_role_msg{server_id = ServerId2} = Role, AccMap) ->
		ZoneId = lib_clusters_center_api:get_zone(ServerId2),
		TempList = maps:get(ZoneId, AccMap, []),
		NewTempList = [Role | TempList],
		maps:put(ZoneId, NewTempList, AccMap)
	    end,
	NewMap = lists:foldl(F, #{}, RoleList),
	F2 = fun({K, TempList2}, AccList) ->
		SortRoleList = lists:sublist(sort(TempList2), ?CR_RANK_LEN),
		[{K, SortRoleList} | AccList]
	     end,
	LastMap = maps:from_list(lists:foldl(F2, [], maps:to_list(NewMap))),
	ZoneIds = mod_zone_mgr:get_all_zone_ids(),
	ZoneList = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
%%	?MYLOG("chrono", "LastMap ~p~n", [LastMap]),
	#chrono_rift_rank_state{role_map = LastMap, zone_list = ZoneList}.





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
	ZoneIds = mod_zone_mgr:get_all_zone_ids(),
	ZoneList = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
	{noreply, State#chrono_rift_rank_state{zone_list = ZoneList}};

do_handle_cast({act_end}, State) ->
    lib_chrono_rift_data:db_truncate_rank_role(),
%%	NewState = init(),
	#chrono_rift_rank_state{role_map = Map} = State,
	List = maps:to_list(Map),
	F = fun({ZoneId, RoleList}) ->
		spawn(fun() ->
			send_rank_reward(sort(RoleList), ZoneId) end)
	    end,
	spawn(fun() ->
		%% 睡眠一分钟
		timer:sleep(60 * 1000),
		lists:foreach(F, List)
	end),
	ZoneIds = mod_zone_mgr:get_all_zone_ids(),
	ZoneList = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
%%	?MYLOG("chrono", "LastMap ~p~n", [LastMap]),
	{noreply, #chrono_rift_rank_state{zone_list = ZoneList}};

do_handle_cast({get_role_rank_list, ServerId, RoleId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_rank_state{zone_list = ZoneList, role_map = RoleMap} = State,
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
		#zone_msg{status = ?act_open} ->
			RoleList = maps:get(ZoneId, RoleMap, []),
			PackList = [{RoleSerNum, TempRoleId, TempRoleName, RoleValue} ||
				#rank_role_msg{server_num = RoleSerNum, role_id = TempRoleId, role_name = TempRoleName, scramble_value = RoleValue} <- RoleList],
%%			?MYLOG("chrono", "PackList ~p~n", [PackList]),
			{ok, Bin} = pt_204:write(20409, [PackList]),
			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin);
		_ ->
			lib_kf_chrono_rift:send_error(ServerId, RoleId, ?ERRCODE(err204_act_close))
	end,
	{noreply, State};



%% 判断活动是否开启
do_handle_cast({set_role_scramble_value, Role, _Value}, State) ->
	%%判断活动是否开启
	#rank_role_msg{server_id = ServerId, role_id = RoleId} = Role,
	#chrono_rift_rank_state{zone_list = ZoneList} = State,
	Res = lib_kf_chrono_rift:is_act_open(ServerId, ZoneList),
	if
		Res == true ->
			ZoneId = lib_clusters_center_api:get_zone(ServerId),
			#chrono_rift_rank_state{role_map = RoleMap} = State,
			RoleList = maps:get(ZoneId, RoleMap, []),
			Length = length(RoleList),
			if
				RoleList == [] ->
                    lib_chrono_rift_data:db_save_rank_role(Role),
					_NewRoleList = lists:keystore(RoleId, #rank_role_msg.role_id, RoleList, Role),
					NewRoleList = lists:sublist(sort(_NewRoleList), ?CR_RANK_LEN);
				Length < 50 ->
                    lib_chrono_rift_data:db_save_rank_role(Role),
					_NewRoleList = lists:keystore(RoleId, #rank_role_msg.role_id, RoleList, Role),
					NewRoleList = lists:sublist(sort(_NewRoleList), ?CR_RANK_LEN);
				true ->
					_NewRoleList = lists:keystore(RoleId, #rank_role_msg.role_id, RoleList, Role),
                    lib_chrono_rift_data:db_save_rank_role(Role),
					NewRoleList = lists:sublist(sort(_NewRoleList), ?CR_RANK_LEN)
			end,

			NewMap = maps:put(ZoneId, NewRoleList, RoleMap),
			{noreply, State#chrono_rift_rank_state{role_map = NewMap}};
		true ->
			{noreply, State}
	end;






do_handle_cast(_Request, State) ->
	?MYLOG("chrono", "nomatch _Request ~p ~n", [_Request]),
	{noreply, State}.


do_handle_info(_Request, State) ->
	{noreply, State}.



sort([]) ->
	[];
sort(RoleList) ->
	F = fun(#rank_role_msg{scramble_value = V1}, #rank_role_msg{scramble_value = V2}) ->
		V1 >= V2
	    end,
	lists:sort(F, RoleList).

%% 发送奖励
send_rank_reward(RoleList, ZoneId) ->
	send_rank_reward(RoleList, 0, ZoneId, #{}).


send_rank_reward([], _PreRank, _ZoneId, ResMap) ->
	List = maps:to_list(ResMap),
	[mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, send_rank_reward, [List1]) || {ServerId, List1} <-List ];
send_rank_reward([H | RoleList], PreRank, ZoneId, ResMap) ->
%%	timer:sleep(100),
	#rank_role_msg{server_id = ServerId, role_id = RoleId, server_num = ServerNum} = H,
	Title = utext:get(2040003),
	Content = utext:get(2040004, [PreRank + 1]),
	Reward = data_chrono_rift:get_role_rank_reward(PreRank + 1),
	if
		Reward == [] ->
			skip;
		true ->
			lib_log_api:log_chrono_rift_rank_reward(RoleId, ServerId, ServerNum, ZoneId, PreRank + 1, Reward),
			List = maps:get(ServerId, ResMap, []),
			NewList = [{RoleId, Title, Content, Reward} | List],
			NewMap = maps:put(ServerId, NewList, ResMap),
			send_rank_reward(RoleList, PreRank + 1, ZoneId, NewMap)
%%			mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward])
	end.
