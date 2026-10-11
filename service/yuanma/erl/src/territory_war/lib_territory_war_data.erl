
-module(lib_territory_war_data).

-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

%%-------------------------------------------- 活动的时间数据
get_territory_war_time(NowTime) ->
	WeekDay = utime:day_of_week(NowTime),
	UnixDate = utime:unixdate(NowTime),
	OpenList = data_territory_war:get_cfg(?TERRI_KEY_1),
	ReadyDuration = data_territory_war:get_cfg(?TERRI_KEY_2),
	case lists:keyfind(WeekDay, 1, OpenList) of 
		{WeekDay, StartTimeGap} ->
			StartTime = UnixDate + StartTimeGap,
			case StartTime < NowTime of 
				true -> {0, 0};
				_ ->
					ReadyTime = StartTime - ReadyDuration,
					{StartTime, ReadyTime}
			end;
		_ -> {0, 0}
	end.

get_territory_war_time_local(NowTime) ->
	{StartTime, ReadyTime} = get_territory_war_time(NowTime),
	OpenDay = util:get_open_day(),
	[_MultiModeOpenDay, OpenDaysSpec, OpenDays] = data_territory_war:get_cfg(?TERRI_KEY_14),
	case NowTime < ReadyTime of 
		true -> %% 活动开启日
			[OpenDay1, OpenDay2] = OpenDays,
			case (OpenDay1 =< OpenDay andalso OpenDay =< OpenDay2) orelse lists:member(OpenDay, OpenDaysSpec) of 
				true -> {StartTime, ReadyTime};
				_ -> {0, 0}
			end;
		_ -> %% 非活动开启日
			case lists:member(OpenDay, OpenDaysSpec) of 
				true -> %% 指定开服天数一定开
					UnixDate = utime:unixdate(NowTime),
					OpenList = data_territory_war:get_cfg(?TERRI_KEY_1),
					ReadyDuration = data_territory_war:get_cfg(?TERRI_KEY_2),
					case OpenList of 
						[{_WeekDay, StartTimeGap}|_] ->
							NewStartTime = UnixDate + StartTimeGap,
							case NewStartTime < NowTime of 
								true -> {0, 0};
								_ ->
									NewReadyTime = NewStartTime - ReadyDuration,
									{NewStartTime, NewReadyTime}
							end;
						_ -> 
							{0, 0}
					end;
				_ ->
					{0, 0}
			end
	end.

%% 获取每轮战斗时长w
get_round_duration(_Round) -> 
	data_territory_war:get_cfg(?TERRI_KEY_5).

%% 每轮结算预留时间
get_round_prepare_time() ->
	2.

%% 每轮间隔时长
get_round_gap_time() ->
	data_territory_war:get_cfg(?TERRI_KEY_4).

%%--------------------------------------------------- 获取相同组的公会选择领地列表
get_group_choose_list(Group, ServerMap, GuildMap) ->
	F = fun(_, #terri_server{group = SGroup, guild_list = GuildIds}, List) when Group == SGroup ->
			get_group_choose_list_do(GuildIds, GuildMap, List);
		(_, _, List) -> List
	end,
	maps:fold(F, [], ServerMap).

get_group_choose_list_do([], _GuildMap, List) -> List;
get_group_choose_list_do([GuildId|GuildIds], GuildMap, List) ->
	case maps:get(GuildId, GuildMap, 0) of 
		#terri_guild{guild_name = GuildName, server_id = ServerId, server_num = ServerNum, choose_terri_id = ChooseTerritoryId} ->
			NewList = [{ChooseTerritoryId, GuildId, GuildName, ServerId, ServerNum}|List],
			get_group_choose_list_do(GuildIds, GuildMap, NewList);
		_ -> 
			get_group_choose_list_do(GuildIds, GuildMap, List)
	end.

%% 是否是在本服战斗
fight_in_local(State) ->
	#terri_state{is_cls = IsCls, server_map = ServerMap} = State,
	case IsCls == 0 of 
		true ->
			ServerList = maps:values(ServerMap),
			length([1 ||#terri_server{mode = Mode} <- ServerList, Mode == ?MODE_NUM_1]) > 0;
		_ -> false
	end.

is_guild_fight_local(GuildId, State) ->
	#terri_state{server_map = ServerMap, guild_map = GuildMap} = State,
	case maps:get(GuildId, GuildMap, 0) of 
		#terri_guild{server_id = ServerId} ->
			case maps:get(ServerId, ServerMap, 0) of 
				#terri_server{mode = Mode, guild_list = GuildList} ->
					Cantake = lists:member(GuildId, GuildList),
					if
						Mode == ?MODE_NUM_1 andalso Cantake -> true;
						Cantake == false -> {false, ?ERRCODE(err506_no_qualification)};
						true -> false
					end;
				_ ->
					{false, ?ERRCODE(err506_no_qualification)}
			end;
		_ -> {false, ?ERRCODE(err506_no_qualification)}
	end.

get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) ->
	case maps:get(GuildId, GuildMap, 0) of 
		#terri_guild{server_id = ServerId} ->
			case maps:get(ServerId, ServerMap, 0) of 
				#terri_server{mode = ?MODE_NUM_1} = TerriServer when IsCls == 0 ->
					{ok, TerriServer};
				#terri_server{mode = Mode} = TerriServer when Mode > ?MODE_NUM_1 andalso IsCls == 1 ->
					{ok, TerriServer};
				#terri_server{mode = Mode} = TerriServer when Mode > ?MODE_NUM_1 andalso IsCls == 0 ->
					{cast_center, TerriServer};
				_ -> none
			end;
		_ -> none
	end.

get_terri_group_by_server_id(State, ServerId) ->
	#terri_state{server_map = ServerMap, group_map = GroupMap} = State,
	case maps:get(ServerId, ServerMap, 0) of 
		#terri_server{group = Group} ->
			case maps:get(Group, GroupMap, 0) of 
				#terri_group{} = TerriGroup -> TerriGroup;
				_ -> none
			end;
		_ ->
			none
	end.

find_war_by_guild_id(GuildId, State) ->
	#terri_state{round = Round, server_map = ServerMap, guild_map = GuildMap, group_map = GroupMap} = State,
	case maps:get(GuildId, GuildMap, 0) of 
		#terri_guild{server_id = ServerId} ->
			case maps:get(ServerId, ServerMap, 0) of 
				#terri_server{group = Group} ->
					#terri_group{war_list = WarList} = maps:get(Group, GroupMap, #terri_group{}),
					find_war(WarList, GuildId, Round);
				_ ->
					none
			end;
		_ -> none
	end.

find_war([], _GuildId, _Round) -> none;
find_war([TerriWar|WarList], GuildId, Round) ->
	#terri_war{round = WRound, a_guild = AGuildId, b_guild = BGuildId} = TerriWar,
	case WRound == Round andalso (AGuildId == GuildId orelse BGuildId == GuildId) of 
		true -> TerriWar;
		_ -> find_war(WarList, GuildId, Round)
	end.

%%------------------------------------------ 历史战斗记录
get_history_terri_group_by_server_id(State, ServerId) ->
	#terri_state{history = History} = State,
	case lists:reverse(lists:keysort(1, History)) of 
		[{_DateId, HisGroupMap}|_] ->
			get_history_terri_group_by_server_id_helper(maps:values(HisGroupMap), ServerId);
		_ -> []
	end.

get_history_terri_group_by_server_id_helper([], _ServerId) -> [];
get_history_terri_group_by_server_id_helper([TerriGroup|GroupList], ServerId) ->
	#terri_group{server_list = ServerList} = TerriGroup,
	case lists:member(ServerId, ServerList) of 
		true ->
			TerriGroup;
		_ ->
			get_history_terri_group_by_server_id_helper(GroupList, ServerId)
	end.
	
%%---------------------------------------- 模式相关的数据
get_start_round_by_mode(ModeNum) ->
	case data_territory_war:get_mode_cfg(ModeNum) of 
		#base_territory_mode{start_round = StartRound} -> StartRound;
		_ -> 1
	end.

get_guild_num_by_mode(ModeNum) ->
	case data_territory_war:get_mode_cfg(ModeNum) of 
		#base_territory_mode{guild_num = GuildNum} -> GuildNum;
		_ -> 1
	end.

get_mode_world_lv(ModeNum) ->
	case data_territory_war:get_mode_cfg(ModeNum) of 
		#base_territory_mode{wlv = Wlv} -> Wlv;
		_ -> 400
	end.

get_mode_open_day(ModeNum) ->
	case data_territory_war:get_mode_cfg(ModeNum) of 
		#base_territory_mode{open_day = OpenDay} -> OpenDay;
		_ -> 5
	end.

get_pre_mode_num(?MODE_NUM_8) -> ?MODE_NUM_4;
get_pre_mode_num(?MODE_NUM_4) -> ?MODE_NUM_2;
get_pre_mode_num(?MODE_NUM_2) -> ?MODE_NUM_1.

%%------------------------------------- 战场逻辑相关的数据
%% 获取个人积分奖励配置
get_role_reward_cfg(TerritoryId, StageId) -> 
    case data_territory_war:get_role_reward(TerritoryId, StageId) of 
    	[{_StageId, _ScoreNeed, Reward}] -> Reward;
    	_ -> []
    end.

%% 最低阶段奖励的更新积分值
get_min_up_score(TerritoryId) ->
	List = data_territory_war:get_all_role_reward(TerritoryId),
	case List of 
		[{_, Score}|_] -> Score;
		_ -> 9999999
	end.

%% 策划要求出生点位固定，注释掉的是占领塔后随机在某个塔附近复活
get_role_born(TerritoryId, Camp, _Own) ->
	CampBornList = data_territory_war:get_camp_born_location(TerritoryId),
	case lists:keyfind(Camp, 1, CampBornList) of 
		{_, X, Y, Range} when X > 0 ->
			PosShift = urand:rand(-Range, Range),
			{X + PosShift, Y + PosShift};
		_ -> 
			{500, 500}
	end.
	% ?PRINT("get_role_born : ~p~n", [{TerritoryId, Camp, Own}]),
	% case Own of 
	% 	[] ->
	% 		CampBornList = data_territory_war:get_camp_born_location(TerritoryId),
	% 		case lists:keyfind(Camp, 1, CampBornList) of 
	% 			{_, X, Y, Range} when X > 0 ->
	% 				PosShift = urand:rand(-Range, Range),
	% 				{X + PosShift, Y + PosShift};
	% 			_ -> 
	% 				{500, 500}
	% 		end;
	% 	_ ->
	% 		F = fun(MonId, {RevivePriority1, X1, Y1, Range1}) ->
	% 			#base_terri_mon{x = X, y = Y, range = Range, revive_priority = RevivePriority} = data_territory_war:get_terri_mon(TerritoryId, MonId),
	% 			?IF(RevivePriority > RevivePriority1, {RevivePriority, X, Y, Range}, {RevivePriority1, X1, Y1, Range1})
	% 		end,
	% 		case lists:foldl(F, {0, 0, 0, 0}, ulists:list_shuffle(Own)) of 
	% 			{_, X, Y, Range} when X > 0 -> 
	% 				PosShift = urand:rand(-Range, Range),
	% 				{X + PosShift, Y + PosShift};
	% 			_ -> 
	% 				CampBornList = data_territory_war:get_camp_born_location(TerritoryId),
	% 				case lists:keyfind(Camp, 1, CampBornList) of 
	% 					{_, X, Y, Range} ->
	% 						PosShift = urand:rand(-Range, Range),
	% 						{X + PosShift, Y + PosShift};
	% 					_ -> 
	% 						{500, 500}
	% 				end
	% 		end
	% end.

get_scene_by_terrritory_id(TerritoryId, IsCls) ->
	case data_territory_war:get_territory_cfg(TerritoryId) of 
		#base_territory{scene = [Scene1, Scene2]} ->
			?IF(IsCls == 1, Scene2, Scene1);
		_ ->	
			error
	end.

get_next_territory_id(TerritoryId) ->
	case data_territory_war:get_territory_cfg(TerritoryId) of 
		#base_territory{next_territory_id = NextTerritoryId} ->
			NextTerritoryId;
		_ ->	
			TerritoryId
	end.

get_mon_kill_score(TerritoryId, MonId) ->
	case data_territory_war:get_terri_mon(TerritoryId, MonId) of 
		#base_terri_mon{kill_score = AddScore, guild_score = GuildAddScore} ->
			{AddScore, GuildAddScore};
		_ ->	
			{0, 0}
	end.

get_battle_reward() ->
	WorldLv = util:get_world_lv(),
    case data_territory_war:get_battle_reward(WorldLv) of 
    	[Reward1, Reward2] -> [Reward1, Reward2];
    	_ -> [[], []]
    end.

%%----------------------------------------------------- center db
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% terri_server db
db_clear_territory_server() ->
	db:execute(io_lib:format(?SQL_TERRITORY_SERVER_TRUNCATE, [])).

db_delete_territory_server_by_ids([]) -> ok;
db_delete_territory_server_by_ids(ServerIdList) ->
	Str = util:link_list(ServerIdList),
	db:execute(io_lib:format(?SQL_TERRITORY_SERVER_ID_DELETE, [Str])).

db_batch_replace_terri_server(ServerMap) ->
	F = fun(_, TerriServer, List) ->
		#terri_server{
			server_id = ServerId, server_num = ServerNum, server_name = ServerName, zone_id = ZoneId, open_time = OpenTime,
			world_lv = Wlv, mode = Mode, group = Group
		} = TerriServer,
		[[ServerId, ServerNum, util:fix_sql_str(ServerName), ZoneId, OpenTime, Wlv, Mode, Group]|List]
	end,
	case maps:fold(F, [], ServerMap) of 
		[] -> ok;
		DbList ->
			Sql = usql:replace(territory_server, [server_id, server_num, server_name, zone_id, open_time, wlv, mode, group_id], DbList),
			db:execute(Sql)
	end.

db_replace_terri_server(TerriServer) ->
	#terri_server{
		server_id = ServerId, server_num = ServerNum, server_name = ServerName, zone_id = ZoneId, open_time = OpenTime,
		world_lv = Wlv, mode = Mode, group = Group
	} = TerriServer,
	Sql = io_lib:format(?SQL_TERRITORY_SERVER_REPLACE, [ServerId, ServerNum, util:fix_sql_str(ServerName), ZoneId, OpenTime, Wlv, Mode, Group]),
	db:execute(Sql).

db_select_terri_server() ->
	db:get_all(io_lib:format(?SQL_TERRITORY_SERVER_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% terri_guild db
db_clear_territory_guild() ->
	db:execute(io_lib:format(?SQL_TERRITORY_GUILD_TRUNCATE, [])).

db_delete_territory_guild_by_ids([]) -> ok;
db_delete_territory_guild_by_ids(GuildIdList) ->
	Str = util:link_list(GuildIdList),
	db:execute(io_lib:format(?SQL_TERRITORY_GUILD_ID_DELETE, [Str])).

db_batch_replace_terri_guild(GuildMap) ->
	db_replace_terri_guild_list(maps:values(GuildMap)).

db_replace_terri_guild_list(AddGuildList) ->
	DbList = [
		[GuildId, util:fix_sql_str(GuildName), ServerId, ServerNum, ChooseTerritoryId, WinNum] 
		|| #terri_guild{guild_id = GuildId, guild_name = GuildName, server_id = ServerId, server_num = ServerNum, choose_terri_id = ChooseTerritoryId, win_num = WinNum} <- AddGuildList
	],
	case DbList == [] of 
		true -> ok;
		_ ->
			Sql = usql:replace(territory_guild, [guild_id, guild_name, server_id, server_num, choose_terri_id, win_num], DbList),
			db:execute(Sql)
	end.

% db_replace_terri_guild(TerriGuild) ->
% 	#terri_guild{guild_id = GuildId, guild_name = GuildName, server_id = ServerId, server_num = ServerNum, choose_terri_id = ChooseTerritoryId, win_num = WinNum} = TerriGuild,
% 	Sql = io_lib:format(?SQL_TERRITORY_GUILD_REPLACE, [GuildId, util:fix_sql_str(GuildName), ServerId, ServerNum, ChooseTerritoryId, WinNum]),
% 	db:execute(Sql).

db_update_guild_choose_terri_id(TerriGuild) ->
	#terri_guild{guild_id = GuildId, choose_terri_id = ChooseTerritoryId} = TerriGuild,
	Sql = io_lib:format(<<"update `territory_guild` set choose_terri_id=~p where guild_id=~p">>, [ChooseTerritoryId, GuildId]),
	db:execute(Sql).

db_select_terri_guild() ->
	db:get_all(io_lib:format(?SQL_TERRITORY_GUILD_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% history db
truncate_history_data() ->
	db:execute(io_lib:format(?SQL_TERRITORY_HISTORY_TRUNCATE, [])).

truncate_history_warlist() ->
	db:execute(io_lib:format(?SQL_TERRITORY_HISTORY_WARLIST_TRUNCATE, [])).

insert_history_group_batch(DateId, HisGroupMap) ->
	F = fun(Group, TerriGroup, List) ->
		#terri_group{winner_server = WinnerServerId, winner_guild = WinnerGuild, win_num = WinNum, server_list = ServerList} = TerriGroup,
		[[DateId, Group, WinnerServerId, WinnerGuild, WinNum, util:term_to_bitstring(ServerList)]|List]
	end,
	DbList = maps:fold(F, [], HisGroupMap),
	Sql = usql:insert(territory_history, [date_id, group_id, winner_server, winner_guild, win_num, server_list], lists:reverse(DbList)),
	db:execute(Sql).

insert_history_warlist_batch(DbList) ->
	Sql = usql:insert(territory_history_warlist, 
		[date_id, group_id, war_id, round, territory_id, a_guild, a_server, a_server_num, a_guild_name, b_guild, b_server, b_server_num, b_guild_name, winner], 
		DbList),
	db:execute(Sql).

db_select_history_group() ->
	db:get_all(io_lib:format(?SQL_TERRITORY_HISTORY_SELECT, [])).

db_select_history_warlist() ->
	db:get_all(io_lib:format(?SQL_TERRITORY_HISTORY_WARLIST_SELECT, [])).

%%-------------------------------------------------------- local
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% terri_server db
db_clear_local_territory_server() ->
	db:execute(io_lib:format(?SQL_LOCAL_TERRITORY_SERVER_TRUNCATE, [])).

db_batch_replace_local_terri_server(ServerMap) ->
	F = fun(_, TerriServer, List) ->
		#terri_server{
			server_id = ServerId, server_num = ServerNum, server_name = ServerName, zone_id = ZoneId, open_time = OpenTime,
			world_lv = Wlv, mode = Mode, group = Group
		} = TerriServer,
		[[ServerId, ServerNum, util:fix_sql_str(ServerName), ZoneId, OpenTime, Wlv, Mode, Group]|List]
	end,
	case maps:fold(F, [], ServerMap) of 
		[] -> ok;
		DbList ->
			Sql = usql:replace(territory_server_local, [server_id, server_num, server_name, zone_id, open_time, wlv, mode, group_id], DbList),
			db:execute(Sql)
	end.

db_replace_local_terri_server(TerriServer) ->
	#terri_server{
		server_id = ServerId, server_num = ServerNum, server_name = ServerName, zone_id = ZoneId, open_time = OpenTime,
		world_lv = Wlv, mode = Mode, group = Group
	} = TerriServer,
	Sql = io_lib:format(?SQL_LOCAL_TERRITORY_SERVER_REPLACE, [ServerId, ServerNum, util:fix_sql_str(ServerName), ZoneId, OpenTime, Wlv, Mode, Group]),
	db:execute(Sql).

db_select_local_terri_server() ->
	db:get_all(io_lib:format(?SQL_LOCAL_TERRITORY_SERVER_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% terri_guild db
db_clear_local_territory_guild() ->
	db:execute(io_lib:format(?SQL_LOCAL_TERRITORY_GUILD_TRUNCATE, [])).

db_batch_replace_local_terri_guild(GuildMap) ->
	db_replace_local_terri_guild_list(maps:values(GuildMap)).

db_replace_local_terri_guild_list(AddGuildList) ->
	DbList = [
		[GuildId, util:fix_sql_str(GuildName), ServerId, ServerNum, ChooseTerritoryId, WinNum] 
		|| #terri_guild{guild_id = GuildId, guild_name = GuildName, server_id = ServerId, server_num = ServerNum, choose_terri_id = ChooseTerritoryId, win_num = WinNum} <- AddGuildList
	],
	case DbList == [] of 
		true -> ok;
		_ ->
			Sql = usql:replace(territory_guild_local, [guild_id, guild_name, server_id, server_num, choose_terri_id, win_num], DbList),
			db:execute(Sql)
	end.

db_replace_local_terri_guild(TerriGuild) ->
	#terri_guild{guild_id = GuildId, guild_name = GuildName, server_id = ServerId, server_num = ServerNum, choose_terri_id = ChooseTerritoryId, win_num = WinNum} = TerriGuild,
	Sql = io_lib:format(?SQL_LOCAL_TERRITORY_GUILD_REPLACE, [GuildId, util:fix_sql_str(GuildName), ServerId, ServerNum, ChooseTerritoryId, WinNum]),
	db:execute(Sql).

db_update_local_guild_choose_terri_id(TerriGuild) ->
	#terri_guild{guild_id = GuildId, choose_terri_id = ChooseTerritoryId} = TerriGuild,
	Sql = io_lib:format(<<"update `territory_guild_local` set choose_terri_id=~p where guild_id=~p">>, [ChooseTerritoryId, GuildId]),
	db:execute(Sql).

db_update_local_guild_win_num(GuildId, WinNum) ->
	Sql = io_lib:format(<<"update `territory_guild_local` set win_num=~p where guild_id=~p">>, [WinNum, GuildId]),
	db:execute(Sql).

db_reset_local_guild_all() ->
	Sql = io_lib:format(<<"update `territory_guild_local` set choose_terri_id=0, win_num=0">>, []),
	db:execute(Sql).

db_select_local_terri_guild() ->
	db:get_all(io_lib:format(?SQL_LOCAL_TERRITORY_GUILD_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% history db
truncate_local_history_data() ->
	db:execute(io_lib:format(?SQL_LOCAL_TERRITORY_HISTORY_TRUNCATE, [])).

truncate_local_history_warlist() ->
	db:execute(io_lib:format(?SQL_LOCAL_TERRITORY_HISTORY_WARLIST_TRUNCATE, [])).

insert_local_history_group_batch(DateId, HisGroupMap) ->
	F = fun(Group, TerriGroup, List) ->
		#terri_group{winner_server = WinnerServerId, winner_guild = WinnerGuild, win_num = WinNum, server_list = ServerList} = TerriGroup,
		[[DateId, Group, WinnerServerId, WinnerGuild, WinNum, util:term_to_bitstring(ServerList)]|List]
	end,
	DbList = maps:fold(F, [], HisGroupMap),
	Sql = usql:insert(territory_history_local, [date_id, group_id, winner_server, winner_guild, win_num, server_list], lists:reverse(DbList)),
	db:execute(Sql).

insert_local_history_warlist_batch(DbList) ->
	Sql = usql:insert(territory_history_warlist_local, 
		[date_id, group_id, war_id, round, territory_id, a_guild, a_server, a_server_num, a_guild_name, b_guild, b_server, b_server_num, b_guild_name, winner], 
		DbList),
	db:execute(Sql).

db_select_local_history_group() ->
	db:get_all(io_lib:format(?SQL_LOCAL_TERRITORY_HISTORY_SELECT, [])).

db_select_local_history_warlist() ->
	db:get_all(io_lib:format(?SQL_LOCAL_TERRITORY_HISTORY_WARLIST_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 连胜信息 db
truncate_local_consecutive_win() ->
	db:execute(io_lib:format(?SQL_LOCAL_CONSECUTIVE_WIN_TRUNCATE, [])).

insert_local_consecutive_win(ConsecutiveWin) ->
	#consecutive_win{
		winner = NewWinner,                     
        win_server = NewWinServerId,     
        win_server_num = NewWinServerNum,            
        win_guild_name = NewWinGuildName,         
        win_num = NewWinNum,                    
        last_winner = LastWinner,            
        last_server = LastWinServerId,   
        last_server_num = LastServerNum,           
        last_guild_name = LastWinGuildName,      
        reward_type = NewRewardType,               
        reward_key = NewRewardKey,                 
        reward_owner = RewardOwner,             
        date_id = DateId
	} = ConsecutiveWin,
	Sql = io_lib:format(?SQL_LOCAL_CONSECUTIVE_WIN_INSERT, 
		[NewWinner, NewWinServerId, NewWinServerNum, util:fix_sql_str(NewWinGuildName), NewWinNum, LastWinner, LastWinServerId, LastServerNum, util:fix_sql_str(LastWinGuildName), NewRewardType, NewRewardKey, RewardOwner, DateId]),
	db:execute(Sql).

update_reward_onwer(ConsecutiveWin) ->
	#consecutive_win{
		winner = Winner,                               
        reward_owner = RewardOwner 
	} = ConsecutiveWin,
	Sql = io_lib:format(<<"update `consecutive_win_local` set reward_owner=~p where winner=~p">>, [RewardOwner, Winner]),
	db:execute(Sql).

db_select_local_consecutive_win() ->
	db:get_row(io_lib:format(?SQL_LOCAL_CONSECUTIVE_WIN_SELECT, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% make函数
make(terri_server, [ServerId, ServerNum, ServerName, ZoneId, OpenTime, Wlv, Mode, Group]) ->
	#terri_server{
		server_id = ServerId, server_num = ServerNum, server_name = ServerName, zone_id = ZoneId, open_time = OpenTime,
		world_lv = Wlv, mode = Mode, group = Group
	};
make(terri_guild, [GuildId, GuildName, ServerId, ServerNum, ChooseTerritoryId, WinNum]) ->
	#terri_guild{
		guild_id = GuildId, guild_name = GuildName, server_id = ServerId, server_num = ServerNum, 
		choose_terri_id = ChooseTerritoryId, win_num = WinNum
	};
make(terri_group, [GroupId, WinnerServerId, WinnerGuild, WinNum, ServerList]) ->
	#terri_group{
		group_id = GroupId,                 
		winner_server = WinnerServerId,
		winner_guild = WinnerGuild,
		win_num = WinNum,
		server_list = ServerList
	};
make(terri_war, [GroupId, WarId, Round, TerritoryId, AGuildId, AServerId, AServerNum, AGuildName, BGuildId, BServerId, BServerNum, BGuildName, Winner]) ->
	#terri_war{
		group = GroupId,                   %% 所在分组id
		war_id = WarId,                  %% 战场id
		round = Round,
		territory_id = TerritoryId,            %% 争夺的领地id
		a_guild = AGuildId,
		a_server = AServerId,
		a_server_num = AServerNum,
		a_guild_name = AGuildName,
		b_guild = BGuildId,
		b_server = BServerId,
		b_server_num = BServerNum,
		b_guild_name = BGuildName,
		winner = Winner
	};
make(consecutive_win, [Winner, WinServerId, WinServerNum, WinGuildName, WinNum, LastWinner, LastWinServerId, LastWinServerNum, LastWinGuildName, RewardType, RewardKey, RewardOwner, DateId]) ->
	#consecutive_win{
		winner = Winner,						
		win_server = WinServerId, 
		win_server_num = WinServerNum,               
		win_guild_name = WinGuildName,          
		win_num = WinNum,					
		last_winner = LastWinner, 				
		last_server = LastWinServerId, 
		last_server_num = LastWinServerNum,               
		last_guild_name = LastWinGuildName,         
		reward_type = RewardType, 				
		reward_key = RewardKey, 				%% 连胜奖励键(即连胜次数)
		reward_owner = RewardOwner, 				%% 连胜奖励分配者
		date_id = DateId
	};
make(_, _) ->
	error.
