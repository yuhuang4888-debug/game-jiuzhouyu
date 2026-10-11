%%%-----------------------------------
%%% @Module      : mod_kf_chrono_rift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 27. 十一月 2019 15:20
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_kf_chrono_rift).
-author("carlos").


%% API
-export([]).




-include("chrono_rift.hrl").
-include("common.hrl").
-include("errcode.hrl").
-define(MOD_STATE, chrono_rift_state).     %%龙语boss状态
-include("clusters.hrl").
-include("def_fun.hrl").
%% API
-export([]).




start_link() ->
	gen_server:start_link({local, mod_kf_chrono_rift}, mod_kf_chrono_rift, [], []).


init([]) ->
	State = lib_kf_chrono_rift_mod:init(),
	{ok, State}.



gm_act_end() ->
	gen_server:cast(?MODULE, {gm_act_end}).

gm_repair_occupy() ->
	gen_server:cast(?MODULE, {gm_repair_occupy}).


re_load() ->
	gen_server:cast(?MODULE, {re_load}).


%%注入争夺值
add_scramble_value(Role, CastleId, Value, ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio) ->
	?MYLOG("chrono", "add_scramble_value ~n", []),
	gen_server:cast(?MODULE, {add_scramble_value, Role, CastleId, Value, ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio}).


get_act_info(ServerId, RoleId, MyScrambleValue) ->
	gen_server:cast(?MODULE, {get_act_info, ServerId, RoleId, MyScrambleValue}).

get_castle_info(ServerId, RoleId, CastleId, MyScrambleValue) ->
	gen_server:cast(?MODULE, {get_castle_info, ServerId, RoleId, CastleId, MyScrambleValue}).

change_castle(ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue) ->
	gen_server:cast(?MODULE, {change_castle, ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue}).


get_role_castle_id(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_role_castle_id, ServerId, RoleId}).


get_world_msg(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_world_msg, ServerId, RoleId}).

day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).


zone_change(ServerId, OldZone, NewZone) ->
	gen_server:cast(?MODULE, {zone_change, ServerId , OldZone, NewZone}).

handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds) ->
	gen_server:cast(?MODULE, {handle_new_merge_server_ids, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds}).


add_goal_value(ServerId, Msg) ->
	gen_server:cast(?MODULE, {add_goal_value, ServerId, Msg}).


gm_force_change_castle_id(ServerId, Role, OldCastleId, CastleId) ->
	gen_server:cast(?MODULE, {gm_force_change_castle_id, ServerId, Role, OldCastleId, CastleId}).

%% 更改服务器名字
change_server_name(ServerId, ServerName) ->
	gen_server:cast(?MODULE, {change_server_name,ServerId, ServerName}).

refresh_server_name(ServerId, ServerName) ->
	gen_server:cast(?MODULE, {refresh_server_name, ServerId, ServerName}).



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


do_handle_cast({change_server_name,ServerId, ServerName}, State) ->
	%% 更新数据库
	Sql1 = io_lib:format(<<"UPDATE  chrono_rift_castle set current_server_name = '~s' where current_server = ~p">>, [ServerName, ServerId]),
	db:execute(Sql1),
	Sql2 = io_lib:format(<<"UPDATE  chrono_rift_castle_role  set server_name = '~s' where  server_id = ~p">>, [ServerName, ServerId]),
	db:execute(Sql2),
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_state{castle_map = OldCastleMap}= State,
	case maps:get(ZoneId, OldCastleMap, []) of
		ListCastleList when ListCastleList =/= [] ->
			F = fun(#chrono_rift_castle{current_server_id = FunServerId, scramble_value = ValueList, role_list = RoleList} = OldCastle, AccList) ->
				if
					FunServerId  == ServerId ->
						NewCastle1 = OldCastle#chrono_rift_castle{current_server_name = ServerName};
					true ->
						NewCastle1 = OldCastle
				end,
				F1 = fun(#castle_server_msg{server_id = FunServerId2} = OldServerMsg, AccList2) ->
					if
						FunServerId2  == ServerId ->
							NewServerMsg = OldServerMsg#castle_server_msg{server_name = ServerName};
						true ->
							NewServerMsg = OldServerMsg
					end,
					[NewServerMsg | AccList2]
					end,
				NewValueList = lib_kf_chrono_rift:sort_scramble_value(lists:foldl(F1, [], ValueList)),
				F2 = fun(#castle_role_msg{server_id = FunServerId2} = RoleMsg, AccList2) ->
					if
						FunServerId2  == ServerId ->
							NewRoleMsg = RoleMsg#castle_role_msg{server_name = ServerName};
						true ->
							NewRoleMsg = RoleMsg
					end,
					[NewRoleMsg | AccList2]
				     end,
				NewRoleList = lists:foldl(F2, [], RoleList),
				NewCastle2 = NewCastle1#chrono_rift_castle{scramble_value = NewValueList, role_list = NewRoleList},
				[NewCastle2 | AccList]
			    end,
			NewListCastleList = lists:foldl(F, [], ListCastleList),
			NewCastleMap = maps:put(ZoneId, NewListCastleList, OldCastleMap);
		_ ->
			NewCastleMap = OldCastleMap
	end,
	{noreply, State#chrono_rift_state{castle_map = NewCastleMap}};

do_handle_cast({handle_new_merge_server_ids, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds}, State) ->
	NewState = lib_kf_chrono_rift_mod:handle_new_merge_server_ids(State, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds),
	{noreply, NewState};

do_handle_cast({re_load}, _State) ->
	State = lib_kf_chrono_rift_mod:init(_State),
	{noreply, State};


do_handle_cast({zone_change, ServerId , OldZone, NewZone}, State) ->
	NewState = lib_kf_chrono_rift_mod:zone_change(State, ServerId , OldZone, NewZone),
	{noreply, NewState};

do_handle_cast({day_trigger}, State) ->
	NewState = lib_kf_chrono_rift_mod:day_trigger(State),
	{noreply, NewState};


do_handle_cast({gm_act_end}, State) ->
	lib_kf_chrono_rift_mod:act_end(State),
	NewState1 = lib_kf_chrono_rift_mod:init(State),
    NewState = lib_kf_chrono_rift_mod:recalc_zone_state(NewState1),
	{noreply, NewState};


do_handle_cast({add_goal_value, ServerId, Msg}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_state{zone_state = ZoneState} = State,
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneState) of
		#zone_msg{status = ?act_open} ->
			[GoalType, ServerId2, ServerNum, ServerName, V] =  Msg,
			mod_kf_chrono_rift_goal:add_goal_value(GoalType, ServerId2, ServerNum, ServerName, V);
		_ ->  %% 活动未开启
			skip
	end,
	{noreply, State};

do_handle_cast({refresh_server_name, ServerId, ServerName}, State) ->
	#chrono_rift_state{castle_map = CastleMap} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	CastleList = maps:get(ZoneId, CastleMap, []),
	F = fun(CastleItem) ->
		#chrono_rift_castle{
			current_server_id = CurrentServerId,
			current_server_name = CurrentServerName,
			scramble_value = ValueList,
			role_list = RoleList
		} = CastleItem,
		NewCurrentServerName = ?IF(ServerId == CurrentServerId, ServerName, CurrentServerName),
		NewValueList = [begin
			 NewVServerName = ?IF(ServerId == VServerId, ServerName, VServerName),
			 Value#castle_server_msg{server_name = NewVServerName}
		 end || #castle_server_msg{server_id = VServerId, server_name = VServerName} = Value <- ValueList],

		NewRoleList = [begin
			 NewRServerName = ?IF(ServerId == RServerId, ServerName, RServerName),
			 Role#castle_role_msg{server_name = NewRServerName}
		 end|| #castle_role_msg{server_id = RServerId, server_name = RServerName} = Role <- RoleList],

		CastleItem#chrono_rift_castle{
			current_server_name = NewCurrentServerName,
			scramble_value = NewValueList,
			role_list = NewRoleList
		}
		end,
	NewCastleList = lists:map(F, CastleList),
	NewCastleMap = maps:put(ZoneId, NewCastleList, CastleMap),

	{noreply, State#chrono_rift_state{castle_map = NewCastleMap}};

do_handle_cast({get_world_msg, ServerId, RoleId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_state{zone_state = ZoneState} = State,
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneState) of
		#zone_msg{status = ?act_open} ->
			Status = ?act_open;
		_ ->  %% 活动未开启
			Status = ?act_close
	end,
	AllServerList = mod_zone_mgr:get_zone_server(ZoneId),
	OpenDayLimit = ?CR_OPEN_DAY,
	Pack = [{ServerNum, SerName, Lv} ||
		#zone_base{server_num = ServerNum, server_name = SerName, world_lv = Lv, time = OpenTime}<-AllServerList,
		util:get_open_day_in_center(OpenTime) >= OpenDayLimit],
%%	?MYLOG("chrono", "Status ~p, Pack ~p~n", [Status, Pack]),
	{ok, Bin} = pt_204:write(20411, [Status, Pack]),
	lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
	{noreply, State};


do_handle_cast({get_role_castle_id, ServerId, RoleId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_state{zone_state = ZoneState} = State,
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneState) of
		#zone_msg{status = ?act_open} ->
			#chrono_rift_state{castle_map = Map} = State,
			CastleList = maps:get(ZoneId, Map, []),
			CastleId = lib_kf_chrono_rift:get_default_castle_id(CastleList, ServerId),
			{ok, Bin} = pt_204:write(20410, [CastleId]),
			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin);
		_ ->  %% 活动未开启
			skip
	end,
	{noreply, State};


do_handle_cast({add_scramble_value, Role, CastleId, Value,  ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio}, State) ->
%%	?MYLOG("chrono", "add_scramble_value ~n", []),
	#castle_role_msg{server_id = ServerId, role_id = RoleId} = Role,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#chrono_rift_state{zone_state = ZoneState} = State,
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneState) of
		#zone_msg{status = ?act_open} ->
			%% 确定是开启的话 就返回玩家进程添加增多值
			mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, add_scramble_value_only, [RoleId, ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio]),
			NewState = lib_kf_chrono_rift_mod:add_scramble_value(Role#castle_role_msg{zone_id = ZoneId}, CastleId, Value, State);
		_ ->  %% 活动未开启
			NewState = State
	end,
	{noreply, NewState};




do_handle_cast({change_castle, ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue}, State) ->
	#chrono_rift_state{zone_state = ZoneState} = State,
	IsOpen = lib_kf_chrono_rift:is_act_open(ServerId, ZoneState),
	if
		IsOpen == true ->
			?MYLOG("chrono", "change_castle ~p~n", [{ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue}]),
			NewState = lib_kf_chrono_rift_mod:change_castle(ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue, State),
			{noreply, NewState};
		true -> %% 活动未开始
			%% err204_act_close
			mod_clusters_center:apply_cast(ServerId, pp_chrono_rift, send_error, [Role#castle_role_msg.role_id, ?ERRCODE(err204_act_close)]),
			{noreply, State}
	end;


do_handle_cast({gm_force_change_castle_id, ServerId, Role, OldCastleId, CastleId}, State) ->
%%	#chrono_rift_state{zone_state = ZoneState} = State,
	NewState = lib_kf_chrono_rift_mod:change_castle_force(ServerId, Role, OldCastleId, CastleId, State),
	{noreply, NewState};


do_handle_cast({get_castle_info, ServerId, RoleId, CastleId, MyScrambleValue}, State) ->
	#chrono_rift_state{zone_state = ZoneState} = State,
	IsOpen = lib_kf_chrono_rift:is_act_open(ServerId, ZoneState),
	if
		IsOpen == true ->
			lib_kf_chrono_rift_mod:get_castle_info(ServerId, RoleId, CastleId, MyScrambleValue, State);
		true -> %% 活动未开始
			%% err204_act_close
			%%  或者发送一个 世界等级信息
			mod_clusters_center:apply_cast(ServerId, pp_chrono_rift, send_error, [RoleId, ?ERRCODE(err204_act_close)])
	end,
	{noreply, State};



do_handle_cast({get_act_info, ServerId, RoleId, MyScrambleValue}, State) ->
	#chrono_rift_state{zone_state = ZoneState} = State,
	IsOpen = lib_kf_chrono_rift:is_act_open(ServerId, ZoneState),
	if
		IsOpen == true ->
			lib_kf_chrono_rift_mod:get_act_info(ServerId, RoleId, MyScrambleValue, State);
		true -> %% 活动未开始
			%% err204_act_close
			%%  或者发送一个 世界等级信息
			mod_clusters_center:apply_cast(ServerId, pp_chrono_rift, send_error, [RoleId, ?ERRCODE(err204_act_close)])
	end,
	{noreply, State};


do_handle_cast({gm_repair_occupy}, State) ->
	#chrono_rift_state{castle_map = Map} = State,
	List = maps:to_list(Map),
	F = fun({Key, CastleList}, AccList) ->
			F2 = fun(Castle, AccList2) ->
					#chrono_rift_castle{have_servers = HaveServerS,  base_server_id = BaseSer} = Castle,
					if
						BaseSer == 0 ->
							NewCastle = Castle;
						true ->
							NewCastle = Castle#chrono_rift_castle{have_servers = [BaseSer | lists:delete(BaseSer, HaveServerS)]},
                            lib_chrono_rift_data:db_save_castle(NewCastle)
					end,
					[NewCastle | AccList2]
				end,
			NewCastleList = lists:foldl(F2, [], CastleList),
			[{Key, NewCastleList} |  AccList]
		end,
	NewList = lists:foldl(F, [], List),
	NewMap = maps:from_list(NewList),
	{noreply, State#chrono_rift_state{castle_map = NewMap}};

do_handle_cast(_Request, State) ->
	{noreply, State}.



do_handle_info({occupy_twelve, ServerId, CastleId}, State) ->
	NewState = lib_kf_chrono_rift_mod:occupy_twelve(ServerId, CastleId, State),
	{noreply, NewState};

do_handle_info({act_end}, State) ->
	%%发奖励一天内不能重复结算
	case get(acd_flag) of
		Time when is_integer(Time) ->
			case utime:is_same_date(Time, utime:unixtime()) of
				true ->
					{noreply, State};
				_ ->
					put(acd_flag, utime:unixtime()),
					lib_kf_chrono_rift_mod:act_end(State),
					NewState = lib_kf_chrono_rift_mod:init(State),
					{noreply, NewState}
			end;
		_ ->
			put(acd_flag, utime:unixtime()),
			lib_kf_chrono_rift_mod:act_end(State),
			NewState = lib_kf_chrono_rift_mod:init(State),
			{noreply, NewState}
	end;


do_handle_info(_Request, State) ->
	{noreply, State}.
