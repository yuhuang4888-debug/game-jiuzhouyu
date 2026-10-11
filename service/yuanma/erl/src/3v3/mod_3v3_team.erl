%%%-----------------------------------
%%% @Module      : mod_3v3_team
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 15. 七月 2019 17:00
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_3v3_team).
-author("chenyiming").

-include("3v3.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_id_create.hrl").
-include("common.hrl").

%% API
-export([]).


start_link() ->
	gen_server:start_link({local, mod_3v3_team}, mod_3v3_team, [], []).


init([]) ->
	case util:is_cls() of
		true ->
			Sql = io_lib:format(?select_3v3_team, []),
			DBTeamList = db:get_all(Sql),
			
			TeamList = [#team_local_3v3{team_id = TeamId, name = binary_to_list(DbName),
				leader_id = LeaderId, match_count = MatchCount, win_count = WinCount, leader_name = binary_to_list(DbLeaderName),
				point = Point, today_count = TodayCount, yesterday_point = YesterdayPoint, champion_rank = ChampionRank, is_change_name = IsChangeName, server_id = ServerId}
				|| [TeamId, DbName, LeaderId, MatchCount, WinCount, Point, TodayCount, YesterdayPoint, ChampionRank, IsChangeName, ServerId, DbLeaderName] <- DBTeamList],
			TeamList1 = lib_3v3_api:sort_team(TeamList),
			TeamList2 = init_role(TeamList1),
			AllRoleList = get_all_role_id(TeamList2),
			State = #team_state{team_list = TeamList2, team_role_id_list = AllRoleList, kf_3v3_status = ?KF_3V3_STATE_END},
%%	        ?MYLOG("3v3", "State ~p~n", [State]),
			{ok, State};
		_ ->  %%本服的不处理
			{ok, #team_state{}}
	end.



init_role(TeamList) ->
	F = fun(Team, AccList) ->
		#team_local_3v3{team_id = TeamId, leader_id = LeaderId} = Team,
		Sql = io_lib:format(?select_3v3_team_role, [TeamId]),
		DbList = db:get_all(Sql),
		RoleList = [#team_local_3v3_role{role_id = RoleId, server_name = ServerName, lv = Lv, picture = binary_to_list(Picture), picture_id = PictureId,
			server_num = ServerNum, turn = Turn, login_time = LoginTime, logout_time = LogoutTime, power = Power, server_id = ServerId,
			role_name = binary_to_list(RoleName)}
			|| [RoleId, ServerNum, ServerName, Turn, LoginTime, LogoutTime, Power, ServerId, Lv, PictureId, Picture, RoleName] <- DbList],
		case lists:keyfind(LeaderId, #team_local_3v3_role.role_id, RoleList) of
			#team_local_3v3_role{} ->
				NewTeam = Team#team_local_3v3{role_list = RoleList};
			_ ->
				Length = length(RoleList),
				if
					Length >= 1->
						#team_local_3v3_role{role_id = NewLeaderId, role_name = NewLeaderName} = hd(RoleList),
						NewTeam = Team#team_local_3v3{role_list = RoleList, leader_id = NewLeaderId, leader_name = NewLeaderName},
						lib_3v3_local:save_to_db_only_team(NewTeam);
					true ->
						NewTeam = Team#team_local_3v3{role_list = RoleList}
				end
		end,
		[NewTeam | AccList]
	    end,
	lists:reverse(lists:foldl(F, [], TeamList)).



create_team(ServerId, TeamName, RoleId, RoleMsg, TeamId, LeaderName) ->
	gen_server:cast(?MODULE, {create_team, ServerId, TeamName, RoleId, RoleMsg, TeamId, LeaderName}).

apply_team(TeamId, RoleMsg, ServerId) ->
	gen_server:cast(?MODULE, {apply_team, TeamId, RoleMsg, ServerId}).

enter_team(TeamId, RoleMsg, ServerId) ->
	gen_server:cast(?MODULE, {enter_team, TeamId, RoleMsg, ServerId}).

info(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {info, ServerId, RoleId}).

apply_role_info(ServerId, TeamId, RoleId) ->
	gen_server:cast(?MODULE, {apply_role_info, ServerId, TeamId, RoleId}).

hand_apply_list(ServerId, RoleId, Type, TeamId, MYRoleId) ->
	gen_server:cast(?MODULE, {hand_apply_list, ServerId, RoleId, Type, TeamId, MYRoleId}).

%%发送战队详细信息
send_team_info(TeamId, ServerId, RoleId, Flag) ->
	gen_server:cast(?MODULE, {send_team_info, TeamId, ServerId, RoleId, Flag}).


%%RoleId 被踢的人
kick_role(MyServerId, RoleId, TeamId, LeaderId) ->
	gen_server:cast(?MODULE, {kick_role, MyServerId, TeamId, RoleId, LeaderId}).

%%改变队长
change_leader(MyServerId, OldLeader, TeamId, ChangeLeaderId, ChangeLeaderName) ->
	gen_server:cast(?MODULE, {change_leader, MyServerId, OldLeader, TeamId, ChangeLeaderId, ChangeLeaderName}).

%%解散队伍
disband_team(MyServerId, MyRoleId, TeamId) ->
	gen_server:cast(?MODULE, {disband_team, MyServerId, MyRoleId, TeamId}).

%%退出队伍
quit_team(MyServerId, TeamId, MyRoleId) ->
	gen_server:cast(?MODULE, {quit_team, MyServerId, MyRoleId, TeamId}).

%%战队排名
team_rank_info(MyRoleId) ->
	gen_server:cast(?MODULE, {team_rank_info, MyRoleId}).

%%改名
change_name(ServerId, MyRoleId, TeamId, Name) ->
	gen_server:cast(?MODULE, {change_team_name, ServerId, TeamId, MyRoleId, Name}).

%%快速加入
quick_enter_team(TeamId, RoleMsg) ->
	gen_server:cast(?MODULE, {quick_enter_team, TeamId, RoleMsg}).

%%发起投票
start_vote(ServerId, MyRoleId, TeamId) ->
	gen_server:cast(?MODULE, {start_vote, ServerId, MyRoleId, TeamId}).

vote(MyServerId, MyRoleId, TeamId, Type) ->
	gen_server:cast(?MODULE, {vote, MyServerId, MyRoleId, TeamId, Type}).

%%更新玩家的状态
refresh_team_match_status(TeamId, RoleList, MatchStatus) ->
	gen_server:cast(?MODULE, {refresh_team_match_status, TeamId, RoleList, MatchStatus}).

get_vote_list(ServerId, TeamId, RoleId) ->
%%	?MYLOG("3v3", "65071+++++++ ~n", []),
	gen_server:cast(?MODULE, {get_vote_list, ServerId, TeamId, RoleId}).

%%更新本地team的数据
center_update_local_team(TeamScore) ->
	gen_server:cast(?MODULE, {center_update_local_team, TeamScore}).

%%停止匹配
stop_match(TeamId, ServerId, RoleId) ->
	gen_server:cast(?MODULE, {stop_match, TeamId, ServerId, RoleId}).

daily_reset() ->
	gen_server:cast(?MODULE, {daily_reset}),
	case lib_3v3_api:is_time_to_clear() of
		true ->
			season_end();
		_ ->
			ok
	end.

season_end() ->
	gen_server:cast(?MODULE, {season_end}).

%%催促队长
urge_leader(ServerId, TeamId, MyRoleId, Name) ->
	gen_server:cast(?MODULE, {urge_leader, ServerId, TeamId, MyRoleId, Name}).

%%个人奖励领取状态
send_reward_info(ServerId, PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus) ->
	gen_server:cast(?MODULE, {send_reward_info, ServerId, PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus}).

%%领取个人今日奖励
get_today_reward(ServerId, RoleID, TeamId) ->
	gen_server:cast(?MODULE, {get_today_reward, ServerId, RoleID, TeamId}).

%%%%获取今日匹配奖励  不用
%%get_daily_match_reward(TeamId, RoleID, RewardID) ->
%%	gen_server:cast(?MODULE, {get_daily_match_reward, TeamId, RoleID, RewardID}).

%%更新昨日积分
update_yesterday_point() ->
	gen_server:cast(?MODULE, {update_yesterday_point}).


%%更新战队名字
update_change_name(ServerId, RoleId, TeamId, Name) ->
	gen_server:cast(?MODULE, {update_change_name, ServerId, RoleId, TeamId, Name}).

%% 更新战队的个人信息
update_champion_role_data(TeamIds) ->
	gen_server:cast(?MODULE, {update_champion_role_data, TeamIds}).


%%%%  不用
%%call_team_role(TeamId, MyRoleId) ->
%%	gen_server:cast(?MODULE, {call_team_role, TeamId, MyRoleId}).


role_login(TeamId, RoleId) ->
	gen_server:cast(?MODULE, {role_login, TeamId, RoleId}).

role_logout(TeamId, RoleId) ->
	gen_server:cast(?MODULE, {role_logout, TeamId, RoleId}).

update_power(TeamId, RoleId, Power) ->
	gen_server:cast(?MODULE, {update_power, TeamId, RoleId, Power}).

update_lv(TeamId, RoleId, Lv) ->
	gen_server:cast(?MODULE, {update_lv, TeamId, RoleId, Lv}).


update_picture(TeamId, RoleId, Picture, PictureId) ->
	gen_server:cast(?MODULE, {update_picture, TeamId, RoleId, Picture, PictureId}).

update_role_name(TeamId, RoleId, RoleName) ->
	gen_server:cast(?MODULE, {update_role_name, TeamId, RoleId, RoleName}).

%%更新排名
update_rank(TeamId, Rank) ->
	?PRINT("Rank ~p~n, TeamId, ~p~n", [Rank, TeamId]),
	gen_server:cast(?MODULE, {update_rank, TeamId, Rank}).

start_3v3(Time) ->
	gen_server:cast(?MODULE, {start_3v3, Time}).



sync_server_data(TeamList, AllRoleIds) ->
	gen_server:cast(?MODULE, {sync_server_data, TeamList, AllRoleIds}).


handle_cast(Request, State) ->
	try
		do_handle_cast(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.


handle_info(Request, State) ->
	try
		do_handle_info(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.


do_handle_cast({sync_server_data, TeamList, _AllRoleIds}, State) ->
	#team_state{team_list = OldTeamList, team_role_id_list = _OldRoleList} = State,
%%	NewRoleList = OldRoleList -- AllRoleIds,
	F = fun(Team, AccList) ->
		lists:keystore(Team#team_local_3v3.team_id, #team_local_3v3.team_id, AccList, Team)
	end,
	NewTeamList = lists:foldl(F, OldTeamList, TeamList),
%%	NewTeamList = TeamList ++ OldTeamList,
	[lib_3v3_local:save_to_db(Team) || Team <- TeamList],
	SortTeamList = lib_3v3_api:sort_team(NewTeamList),
%%	?MYLOG("3v3_team", "NewRoleList ~p~n", [NewRoleList]),
	AllRoleList = get_all_role_id(SortTeamList),
%%	?MYLOG("3v3_team", "AllRoleList ~p~n", [AllRoleList]),
	{noreply, State#team_state{team_list = SortTeamList, team_role_id_list = AllRoleList}};

do_handle_cast({start_3v3, Time}, State) ->
	NewState = lib_3v3_local:start_3v3(Time, State),
	{noreply, NewState};

do_handle_cast({update_rank, TeamId, Rank}, State) ->
	NewState = lib_3v3_local:update_rank(TeamId, Rank, State),
	{noreply, NewState};

do_handle_cast({update_power, TeamId, RoleId, Power}, State) ->
	NewState = lib_3v3_local:update_power(TeamId, RoleId, Power, State),
	{noreply, NewState};

do_handle_cast({update_lv, TeamId, RoleId, Lv}, State) ->
	NewState = lib_3v3_local:update_lv(TeamId, RoleId, Lv, State),
	{noreply, NewState};

do_handle_cast({update_picture, TeamId, RoleId, Picture, PictureId}, State) ->
	NewState = lib_3v3_local:update_picture(TeamId, RoleId, Picture, PictureId, State),
	{noreply, NewState};

do_handle_cast({update_role_name, TeamId, RoleId, RoleName}, State) ->
	NewState = lib_3v3_local:update_role_name(TeamId, RoleId, RoleName, State),
	{noreply, NewState};


do_handle_cast({role_logout, TeamId, RoleId}, State) ->
	NewState = lib_3v3_local:role_logout(TeamId, RoleId, State),
	{noreply, NewState};


do_handle_cast({role_login, TeamId, RoleId}, State) ->
	NewState = lib_3v3_local:role_login(TeamId, RoleId, State),
	{noreply, NewState};


do_handle_cast({call_team_role, TeamId, MyRoleId}, State) ->
	lib_3v3_local:call_team_role(TeamId, MyRoleId, State),
	{noreply, State};


do_handle_cast({update_champion_role_data, TeamIds}, State) ->
	lib_3v3_local:update_champion_role_data(TeamIds, State),
	{noreply, State};

do_handle_cast({update_change_name, ServerId, RoleId, TeamId, Name}, State) ->
	NewState = lib_3v3_local:update_change_name(ServerId, RoleId, TeamId, Name, State),
	{noreply, NewState};

do_handle_cast({update_yesterday_point}, State) ->
	NewState = lib_3v3_local:update_yesterday_point(State),
	{noreply, NewState};

do_handle_cast({get_daily_match_reward, TeamId, RoleID, RewardID}, State) ->
	lib_3v3_local:get_daily_match_reward(TeamId, RoleID, RewardID, State),
	{noreply, State};

do_handle_cast({get_today_reward, ServerId, RoleID, TeamId}, State) ->
	lib_3v3_local:get_today_reward(ServerId, RoleID, TeamId, State),
	{noreply, State};

do_handle_cast({send_reward_info, ServerId, PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus}, State) ->
	lib_3v3_local:send_reward_info(ServerId, PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus, State),
	{noreply, State};

do_handle_cast({urge_leader, ServerId, TeamId, MyRoleId, Name}, State) ->
	lib_3v3_local:urge_leader(ServerId, TeamId, MyRoleId, Name, State),
	{noreply, State};

do_handle_cast({daily_reset}, State) ->
	NewState = lib_3v3_local:daily_reset(State),
	{noreply, NewState};

do_handle_cast({stop_match, TeamId, MyServerId, RoleId}, State) ->
	NewState = lib_3v3_local:stop_match(TeamId, MyServerId, RoleId, State),
%%	?MYLOG("cym3", "NewState ~p~n", [NewState]),
	{noreply, NewState};

do_handle_cast({center_update_local_team, TeamScore}, State) ->
	NewState = lib_3v3_local:center_update_local_team(TeamScore, State),
	{noreply, NewState};

do_handle_cast({get_vote_list, ServerId, TeamId, RoleId}, State) ->
	lib_3v3_local:get_vote_list(ServerId, TeamId, RoleId, State),
%%	?MYLOG("cym3", "State ~p~n", [State]),
	{noreply, State};

do_handle_cast({refresh_team_match_status, TeamId, RoleList, MatchStatus}, State) ->
	NewState = lib_3v3_local:refresh_team_match_status(TeamId, RoleList, MatchStatus, State),
	{noreply, NewState};

do_handle_cast({vote, MyServerId, MyRoleId, TeamId, Type}, State) ->
	NewState = lib_3v3_local:vote(MyServerId, MyRoleId, TeamId, Type, State),
	{noreply, NewState};

do_handle_cast({start_vote, ServerId, MyRoleId, TeamId}, State) ->
	NewState = lib_3v3_local:start_vote(ServerId, MyRoleId, TeamId, State),
%%	?MYLOG("cym3", "NewState ~p~n", [NewState]),
	{noreply, NewState};

do_handle_cast({quick_enter_team, TeamId, RoleMsg}, State) ->
	NewState = lib_3v3_local:quick_enter_team(TeamId, RoleMsg, State),
	{noreply, NewState};

do_handle_cast({change_team_name, ServerId, TeamId, MyRoleId, Name}, State) ->
	NewState = lib_3v3_local:change_team_name(ServerId, TeamId, MyRoleId, Name, State),
%%	?MYLOG("3v3", "State ~p ~n", [State]),
	{noreply, NewState};

%%do_handle_cast({team_rank_info, MyRoleId}, State) ->
%%	lib_3v3_local:team_rank_info(MyRoleId, State),
%%	{noreply, State};

do_handle_cast({quit_team, MyServerId, MyRoleId, TeamId}, State) ->
	NewState = lib_3v3_local:quit_team(MyServerId, MyRoleId, TeamId, State),
	{noreply, NewState};

do_handle_cast({disband_team, MyServerId, MyRoleId, TeamId}, State) ->
	NewState = lib_3v3_local:disband_team(MyServerId, MyRoleId, TeamId, State),
	{noreply, NewState};

do_handle_cast({kick_role, MyServerId, TeamId, RoleId, LeaderId}, State) ->
	NewState = lib_3v3_local:kick_role(MyServerId, TeamId, RoleId, LeaderId, State),
	{noreply, NewState};

do_handle_cast({change_leader, MyServerId, OldLeader, TeamId, ChangeLeaderId, ChangeLeaderName}, State) ->
	NewState = lib_3v3_local:change_leader(MyServerId, OldLeader, TeamId, ChangeLeaderId, ChangeLeaderName, State),
	{noreply, NewState};

do_handle_cast({send_team_info, TeamId, ServerId, RoleId, Flag}, State) ->
	lib_3v3_local:send_team_info(TeamId, ServerId, RoleId, Flag, State),
	{noreply, State};


do_handle_cast({create_team, ServerId, TeamName, RoleId, RoleMsg, TeamId, LeaderName}, State) ->
	#team_state{team_list = TeamList, team_role_id_list = AllRoleList} = State,
	case lib_3v3_local:check_team_name(TeamName, TeamList) of
		true ->
%%			TeamId = mod_id_create:get_new_id(?TEAM_3V3_ID_CREATE),
			Team = #team_local_3v3{team_id = TeamId, name = TeamName, leader_id = RoleId,
				role_list = [RoleMsg], server_id = ServerId, leader_name = LeaderName},
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team),
			%%保存数据库
			lib_3v3_local:save_to_db(Team),
			{ok, Bin} = pt_650:write(65049, [?SUCCESS]),
			send_to_uid(ServerId, RoleId, Bin),
%%			lib_server_send:send_to_uid(RoleId, Bin),
			lib_3v3_local:update_role_team_msg(RoleId, TeamId, RoleId, TeamName, ServerId),  %% todo
			%%扣钱
			mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
				[RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, create_team_cost, []]),
%%			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, create_team_cost, []),
			NewAllRoleList = [RoleId | lists:delete(RoleId, AllRoleList)],
			{ok, Bin2} = pt_650:write(65060, [RoleId, 0, ?SUCCESS]),
			F = fun(#team_local_3v3{apply_list = ApplyList, leader_id = FunLeaderId} = FunTeam, AccTeamList) ->
				case lists:keyfind(RoleId, #team_local_3v3_role.role_id, ApplyList) of
					#team_local_3v3_role{} ->
						send_to_uid(ServerId, FunLeaderId, Bin2);
%%						lib_server_send:send_to_uid(FunLeaderId, Bin2);
					_ ->
						ok
				end,
				ApplyList1 = lists:keydelete(RoleId, #team_local_3v3_role.role_id, ApplyList),
				NewFunTeam = FunTeam#team_local_3v3{apply_list = ApplyList1},
				[NewFunTeam | AccTeamList]
			    end,
			NewTeamList1 = lists:foldl(F, [], NewTeamList),
			SortTeamList = lib_3v3_api:sort_team(NewTeamList1),
%%			NewTeamList1 = lib_3v3_local:delete_apply_role(NewTeamList, RoleId),   %%删除玩家在其他队伍的申请信息
			%% 日志
%%			?MYLOG("log_3v3", "EventParam ~p~n", [[RoleMsg]]),
			lib_3v3_local:log_3v3_team_member(Team, ?team_3v3_create, [RoleMsg]),
			{noreply, State#team_state{team_list = SortTeamList, team_role_id_list = NewAllRoleList}};
		{false, Error} ->
			send_error(ServerId, RoleId, Error),
			{noreply, State}
	end;



%%%%todo
%%do_handle_cast({enter_team, TeamId, RoleMsg, _ServerId}, State) ->
%%	#team_state{team_list = TeamList} = State,
%%	#team_local_3v3_role{role_id = RoleId} = RoleMsg,
%%	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
%%		#team_local_3v3{role_list = RoleList} = Team ->
%%			Length = length(RoleList),
%%			if
%%				Length >= ?team_num ->
%%					{ok, Bin} = pt_650:write(65050, [TeamId, ?ERRCODE(err650_team_max_member)]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
%%					{noreply, State};
%%				true ->
%%					NewRoleList = [RoleMsg | RoleList],
%%					NewTeam = Team#team_local_3v3{role_list = NewRoleList},
%%					{ok, Bin} = pt_650:write(65050, [TeamId, ?SUCCESS]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
%%					lib_3v3_local:save_to_db_role(RoleMsg, TeamId),
%%					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, NewTeam, TeamList),
%%					{noreply, State#team_state{team_list = NewTeamList}}
%%			end;
%%		_ ->
%%			%%保存数据库
%%			{ok, Bin} = pt_650:write(65050, [TeamId, ?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(RoleId, Bin),
%%			{noreply, State}
%%	end;

do_handle_cast({apply_team, TeamId, RoleMsg, ServerId}, State) ->
	#team_state{team_list = TeamList, team_role_id_list = AllRoleList} = State,
	#team_local_3v3_role{role_id = RoleId} = RoleMsg,
%%	?MYLOG("3v3", "TeamId ~p~n", [TeamId]),
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, apply_list = ApplyList, leader_id = LeaderId} = Team ->
			Length = length(RoleList),
%%			?MYLOG("3v3_team", "AllRoleList ~p~n", [AllRoleList]),
			IsHaveTeam = lists:member(RoleId, AllRoleList),
			if
				Length >= ?team_num ->  %%人数满了
					{ok, Bin} = pt_650:write(65050, [TeamId, ?ERRCODE(err650_team_max_member)]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					send_to_uid(ServerId, RoleId, Bin),
					{noreply, State};
				IsHaveTeam == true ->  %%已经有队伍了
%%					?MYLOG("3v3", "err650_have_team ~p~n", [err650_have_team]),
					{ok, Bin} = pt_650:write(65050, [TeamId, ?ERRCODE(err650_have_team)]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					send_to_uid(ServerId, RoleId, Bin),
					{noreply, State};
				true ->  %%进入申请列表
					NewApplyList = lists:keystore(RoleId, #team_local_3v3_role.role_id, ApplyList, RoleMsg),
%%					?MYLOG("3v3", "NewApplyList ~p~n", [NewApplyList]),
					{ok, Bin} = pt_650:write(65050, [TeamId, ?SUCCESS]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					send_to_uid(ServerId, RoleId, Bin),
					LeaderServerId = get_leader_server_id(LeaderId, RoleList),  %%
					lib_3v3_local:send_apply_role_to_leader(LeaderId, RoleMsg, LeaderServerId),  %%更新申请列表
					NewTeam = Team#team_local_3v3{apply_list = NewApplyList},
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
					{noreply, State#team_state{team_list = NewTeamList}}
			end;
		_ ->
			{ok, Bin} = pt_650:write(65050, [TeamId, ?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(RoleId, Bin),
			send_to_uid(ServerId, RoleId, Bin),
			{noreply, State}
	end;

do_handle_cast({info, ServerId, RoleId}, State) ->
	lib_3v3_local:send_team_list_new(State, ServerId, RoleId),
	{noreply, State};


do_handle_cast({apply_role_info, ServerId, TeamId, RoleId}, State) ->
	#team_state{team_list = TeamList} = State,
	?MYLOG("3v3", "apply_role_info  ~n", []),
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{apply_list = ApplyList, role_list = _RoleList} ->
%%			ServerId = get_leader_server_id(RoleId, RoleList),
			lib_3v3_local:send_apply_role_to_leader2(RoleId, ApplyList, ServerId);
		_ ->
			skip
%%			lib_3v3_local:send_apply_role_to_leader(RoleId, [])
	end,
	{noreply, State};


do_handle_cast({hand_apply_list, ServerId, RoleId, Type, TeamId, MYRoleId}, State) ->
	NewState = lib_3v3_local:hand_apply_list(State, ServerId, RoleId, Type, TeamId, MYRoleId),
	{noreply, NewState};


do_handle_cast({reload_state}, _State) ->
	Sql = io_lib:format(?select_3v3_team, []),
	DBTeamList = db:get_all(Sql),
	TeamList = [#team_local_3v3{team_id = TeamId, name = binary_to_list(DbName),
		leader_name = binary_to_list(DbLeaderName),
		leader_id = LeaderId, match_count = MatchCount, win_count = WinCount,
		point = Point, today_count = TodayCount, yesterday_point = YesterdayPoint, champion_rank = ChampionRank, is_change_name = IsChangeName, server_id = ServerId}
		|| [TeamId, DbName, LeaderId, MatchCount, WinCount, Point, TodayCount, YesterdayPoint, ChampionRank, IsChangeName, ServerId, DbLeaderName] <- DBTeamList],
	TeamList1 = lib_3v3_api:sort_team(TeamList),
	TeamList2 = init_role(TeamList1),
	%%更新玩家数据， 数据有可能有问题
	[  [lib_3v3_local:update_role_team_msg(TRoleId, TTeamId, TLeaderId, TTeamName, TServerId)
		|| #team_local_3v3_role{server_id = TServerId, role_id = TRoleId}<-TRoleList]
		||#team_local_3v3{role_list = TRoleList, team_id = TTeamId, name = TTeamName, leader_id = TLeaderId} <- TeamList2],
	AllRoleList = get_all_role_id(TeamList2),
	State = #team_state{team_list = TeamList2, team_role_id_list = AllRoleList},
	{noreply, State};


do_handle_cast({see_team_msg, RoleId, TeamId, ServerId}, _State) ->
	#team_state{team_list = TeamList} = _State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} ->  %% 确实存在这个战队，战队确实存在这个玩家， 跳过
					skip;
				_ ->
					lib_3v3_local:update_role_team_msg(RoleId, 0, 0, "", ServerId)
			end;
		_ -> %% 没有这个战队
			lib_3v3_local:update_role_team_msg(RoleId, 0, 0, "", ServerId)
	end,
	{noreply, _State};


do_handle_cast({season_end}, State) ->
	#team_state{team_list = TeamList} = State,
	NewTeamList = [Team#team_local_3v3{point = 0, rank = 0, yesterday_point = 0, match_count = 0, win_count = 0, champion_rank = 0} || Team <- TeamList],
	Sql = io_lib:format(<<" UPDATE   team_3v3 set point = 0 , yesterday_point = 0, champion_rank = 0, match_count = 0, win_count = 0">>, []),
	db:execute(Sql),
	Title = utext:get(6500017),
	Content = utext:get(6500018),
	spawn(fun() ->
		[[
			begin
				timer:sleep(200),
				mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, []])
			end
%%		    lib_mail_api:send_sys_mail([RoleId], Title, Content, [])
			|| #team_local_3v3_role{role_id = RoleId, server_id = ServerId} <- Team#team_local_3v3.role_list] || Team <- NewTeamList]
	end),
	{noreply, State#team_state{team_list = NewTeamList}};



do_handle_cast({mul_team_repair, RepairTeamList}, State) ->
	NewState = lib_3v3_local:mul_team_repair(RepairTeamList, State),
	{noreply, NewState};


do_handle_cast(_Request, State) ->
	{noreply, State}.

do_handle_info({vote_end, TeamId}, State) ->
	NewState = lib_3v3_local:vote_end(TeamId, State),
	{noreply, NewState};

do_handle_info({stop_3v3}, State) ->
	NewState = lib_3v3_local:stop_3v3(State),
	{noreply, NewState};

do_handle_info(_Request, State) ->
	{noreply, State}.



get_all_role_id(TeamList) ->
	RoleList = lists:flatten([TempRoleList || #team_local_3v3{role_list = TempRoleList} <- TeamList]),
	[RoleId || #team_local_3v3_role{role_id = RoleId} <- RoleList].

%% 重新加载进程数据
reload_state() ->
	gen_server:cast(?MODULE, {reload_state}).


send_to_uid(ServerId, RoleId, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).


send_error(ServerId, RoleId, Error) ->
	{ok, Bin} = pt_650:write(65001, [Error]),
	send_to_uid(ServerId, RoleId, Bin).


get_leader_server_id(LeaderId, RoleList) ->
	case lists:keyfind(LeaderId, #team_local_3v3_role.role_id, RoleList) of
		#team_local_3v3_role{server_id = ServerId} ->
			ServerId;
		_ ->
			0
	end.



see_team_msg(RoleId, TeamId, ServerId) ->
	gen_server:cast(?MODULE, {see_team_msg, RoleId, TeamId, ServerId}).



%%重复战队数据修复
mul_team_repair() ->
	Sql = io_lib:format(<<"select  a.team_id, a.role_id  from   team_3v3_role  a LEFT JOIN  team_3v3 b on   a.team_id = b.team_id ,
	team_3v3_role c   LEFT JOIN  team_3v3 d on   c.team_id = d.team_id WHERE   a.role_id = c.role_id and   a.team_id <> c.team_id
	 and   b.point <= d.point">>, []),
	TeamList = db:get_all(Sql),
	gen_server:cast(?MODULE, {mul_team_repair, TeamList}),
	reload_state().


















