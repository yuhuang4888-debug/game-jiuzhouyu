%%%-----------------------------------
%%% @Module      : lib_3v3_champion_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 06. 八月 2019 16:05
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).



-module(lib_3v3_champion_mod).
-author("chemyiming").



-include("3v3.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("def_id_create.hrl").
-include("common.hrl").

%% API
-export([]).




start_champion(State) ->
%%	?MYLOG("3v3", "State ~p~n", [State]),
	#champion_state{ref = _OldRef, get_data_ref = _OldDataRef, stage_ref = OldStageRef, team_list = TeamList} = State,
%%	NewTeamList = [Team#champion_team{win_count = 0} || Team <- TeamList],
	NewTeamList = handle_start_champion(TeamList),
	[save_team_only(Team) || Team <- NewTeamList],
	Now = utime:unixtime(),
%%	NextChampionStarTime = lib_3v3_api:champion_start_time(utime:unixtime() + 10 * ?ONE_DAY_SECONDS),
%%	GetDataRef = util:send_after(OldDataRef, max(utime:unixdate(NextChampionStarTime) - Now, 1) * 1000, self(), {get_champion_data}),
%%	Ref = util:send_after(OldRef, max(NextChampionStarTime - Now, 1) * 1000, self(), {start_champion}),
	%%开始的阶段  可以进场， 几分钟后开始匹配
%%	GuessTeamList = get_guess_team_list(NewTeamList, 1),
%%	?MYLOG("3v3", "GuessTeamList ~p~n", [GuessTeamList]),
%%	GuessList = info_guess_list(GuessTeamList, 1),
%%	send_all_server_guess_list(GuessList, 1),
	StageRef = util:send_after(OldStageRef, ?champion_pre_time * 1000, self(), {start_guess}),
	send_all_server_stage_msg(?champion_open, Now + ?champion_pre_time),
	%% 发送传闻
%%	lib_chat:send_TV({all}, ?MOD_KF_3V3, 7, []),
	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 7, []]),
	State#champion_state{status = ?champion_open, guess_list = [], guess_role_id_list = [],
		stage_ref = StageRef, stage_end_time = Now + ?champion_pre_time, turn = 0, team_list = NewTeamList}.

get_champion_data(State) ->
	%%
	mod_3v3_rank:get_champion_data(),
	State.



%% 更新队伍数据，但是没有更新玩家数据
update_champion_data(RankData, State) ->
%%	?MYLOG("cym", "RankData ~p~n", [RankData]),
	%% 删除旧数据
	Sql = io_lib:format(<<"truncate champion_kf_team_3v3">>, []),
	Sql1 = io_lib:format(<<"truncate champion_kf_team_3v3_role">>, []),
	db:execute(Sql),
	db:execute(Sql1),
	F = fun(A, {Rank, AccList}) ->
		#kf_3v3_team_rank_data{server_id = ServerId, server_num = ServerNum, leader_id = LeaderId, leader_name = LeaderName, team_name = TeamName, star = Star,
			server_name = ServerName, team_id = TeamId} = A,
		Team = #champion_team{team_name = TeamName, team_id = TeamId, server_name = ServerName,
			server_id = ServerId, server_num = ServerNum, leader_id = LeaderId, leader_name = LeaderName, star = Star, rank = Rank + 1},
		{Rank + 1, [Team | AccList]}
	    end,
	{_, TeamList} = lists:foldl(F, {0, []}, RankData),
	%%save_team_only(Team)
	NewTeamList = handle_team_group(lists:reverse(TeamList)),
	SortF = fun(A, B) ->
		A#champion_team.rank =< B#champion_team.rank
	        end,
	LastTeamList = lists:sort(SortF, NewTeamList),
	[save_team_only(TempTeam) || TempTeam <- LastTeamList],
	TeamIds = [TeamId1 || #champion_team{team_id = TeamId1} <- LastTeamList],
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, update_champion_role_data, [TeamIds]),
	mod_3v3_team:update_champion_role_data(TeamIds),
	State#champion_state{team_list = LastTeamList}.




update_champion_role_data(RoleMsg, State) ->
	#champion_state{team_list = TeamList} = State,
	F = fun({TeamId, RoleList, WinCount, MatchCount}, AccTeamList) ->
		case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
			#champion_team{} = Team ->
				NewTeam = Team#champion_team{role_list = RoleList, match_win_count = WinCount, match_count = MatchCount},
				save_team_only(NewTeam),
				save_champion_role_list(RoleList, TeamId),
				lists:keystore(TeamId, #champion_team.team_id, AccTeamList, NewTeam);
			_ ->
				AccTeamList
		end
	    end,
	NewTeamList = lists:foldl(F, TeamList, RoleMsg),
	State#champion_state{team_list = NewTeamList}.

%%%%%%%%%%%%%%%%%%%%%%%%% db %%%%%%%%%%%%%%%%%%%%%%%%%

save_champion_role_list(RoleList, TeamId) ->
	F = fun(Role) ->
		#champion_team_role{
			role_id = RoleId,
			role_name = RoleName,
			server_id = ServerId,
			server_num = ServerNum,
			server_name = ServerName,
			career = Career,
			sex = Sex,
			turn = Turn,
			power = Power,
			lv_figure = LvFigure,
			fashion_model = FashionModel,
			mount_figure = MountFigure,
			picture = Picture,
			picture_id = PictureId,
			lv = Lv
		} = Role,
		Sql = io_lib:format(<<"REPLACE into  champion_kf_team_3v3_role(team_id, role_id, role_name, server_id, server_num, server_name, career, sex, turn,
		power, lv_figure, fashion_model, mount_figure, picture, picture_id, lv) values(~p, ~p, '~s', ~p, ~p, '~s', ~p, ~p, ~p, ~p, '~s', '~s', '~s', '~s', ~p, ~p)">>,
			[TeamId, RoleId, RoleName, ServerId, ServerNum, ServerName, Career, Sex, Turn, Power, util:term_to_bitstring(LvFigure), util:term_to_bitstring(FashionModel),
				util:term_to_bitstring(MountFigure), Picture, PictureId, Lv]),
		db:execute(Sql)
	    end,
	lists:foreach(F, RoleList).


init_team_list() ->
	Sql = io_lib:format(<<"select  team_id ,  server_id, server_num, server_name, `name`, leader_id, leader_name, point, champion_rank, win_count, match_win_count, match_count from  champion_kf_team_3v3">>, []),
	List = db:get_all(Sql),
	TeamList = [#champion_team{team_id = TeamId, server_id = ServerId, server_num = ServerNum, server_name = ServerName, team_name = Name, leader_id = LeaderId,
		leader_name = LeaderName, star = Point, rank = ChampionRank, win_count = WinCount, match_win_count = MatchWinCount, match_count = MatchCount
	} || [TeamId, ServerId, ServerNum, ServerName, Name, LeaderId, LeaderName, Point, ChampionRank, WinCount, MatchWinCount, MatchCount] <- List],
	init_team_role_list(TeamList).


init_team_role_list(TeamList) ->
	F = fun(Team, AccTeamList) ->
		#champion_team{team_id = TeamId} = Team,
		Sql = io_lib:format(<<"select  role_id, role_name, server_id, server_num, server_name, career, sex, turn, power, lv_figure,
	    fashion_model, mount_figure, picture, picture_id, lv from  champion_kf_team_3v3_role where team_id = ~p">>, [TeamId]),
		DbList = db:get_all(Sql),
		RoleList = [#champion_team_role{role_id = RoleId, server_id = ServerId, server_num = ServerNum,
			server_name = ServerName,
			role_name = RoleName,
			career = Career,
			sex = Sex, turn = Turn,
			power = Power,
			lv_figure = util:bitstring_to_term(LvFigure),
			fashion_model = util:bitstring_to_term(FashionModel),
			mount_figure = util:bitstring_to_term(MountFigure),
			picture = Picture,
			picture_id = PictureId,
			lv = Lv
		}
			|| [RoleId, RoleName, ServerId, ServerNum, ServerName, Career, Sex, Turn, Power, LvFigure, FashionModel, MountFigure, Picture, PictureId, Lv] <- DbList],
		NewTeam = Team#champion_team{role_list = RoleList},
		[NewTeam | AccTeamList]
	    end,
	NewTeamList = lists:foldl(F, [], TeamList),
	sort(NewTeamList).

save_team_only(Team) ->
	#champion_team{team_name = TeamName, team_id = TeamId, server_name = ServerName,
		server_id = ServerId, server_num = ServerNum, leader_id = LeaderId, leader_name = LeaderName, star = Star, rank = Rank, win_count = WinCount,
		match_win_count = MatchWinCount, match_count = MatchCount} = Team,
	Sql = io_lib:format(<<"REPLACE into  champion_kf_team_3v3(team_id, server_id, server_num, server_name, `name`, leader_id, leader_name, point, champion_rank, win_count, match_win_count, match_count)
	 VALUES(~p, ~p, ~p, '~s', '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p)">>, [TeamId, ServerId, ServerNum, ServerName, TeamName, LeaderId, LeaderName, Star, Rank, WinCount, MatchWinCount, MatchCount]),
	db:execute(Sql).

%%------------------------------------------------------------db-------------------------------------------------------------------


%%排序，从小-》大
sort(TeamList) ->
	F = fun(A, B) ->
		A#champion_team.rank < B#champion_team.rank
	    end,
	lists:sort(F, TeamList).



start_pk(State) ->
	#champion_state{stage_ref = OldRef, team_list = TeamList, turn = Turn, guess_list = GuessList} = State,
	StageRef = util:send_after(OldRef, ?champion_pk_time * 1000, self(), {start_guess}),   %%竞猜
	%% 去pk
%%	?MYLOG("pk", "TeamList ~p~n", [TeamList]),
	Team1 = filter(TeamList, Turn),
%%	?MYLOG("pk", "Team1 ~p~n", [Team1]),
	NewTeamList = start_pk_help(Team1, Turn, TeamList),
%%	?MYLOG("3v3pk", "NewTeamList ~p~n", [NewTeamList]),
	NewGuessList = handle_guess_list_before_pk(GuessList, TeamList),
	send_all_server_stage_msg(?champion_pk, utime:unixtime() + ?champion_pk_time),
	NewState = State#champion_state{status = ?champion_pk,
		stage_ref = StageRef, stage_end_time = utime:unixtime() + ?champion_pk_time, team_list = NewTeamList, guess_list = NewGuessList},
	%%场景广播阶段变化
	broadcast_stage(NewState),
	NewState.



%% 胜利次数必须 >= turn - 1 ,不然不得参加下次比赛
%% 第一轮 turn = 0 , 两队的位置pos1 pos2  必须是必须 （pos1 -1）/ math:pow(2, Turn + 1)  = （pos2 -1）/math:pow(2, Turn) , 否则 默认前队赢 如此类推
%% 第二轮 turn = 1 , 两队的位置pos1 pos2  必须是必须 （pos1 -1）/4 = （pos2 -1）/4 , 否则 默认前队赢 如此类推
%% 第三轮 turn = 2 , 两队的位置pos1 pos2  必须是必须 （pos1 -1）/8 = （pos2 -1）/8 , 否则 默认前队赢 如此类推
%% 第四轮 turn = 3 , 两队的位置pos1 pos2  必须是必须 （pos1 -1）/16 = （pos2 -1）/16 , 否则 默认前队赢 也是最后一轮
start_pk_help(TeamList, Turn, OldTeamList) ->
	TeamList1 = start_pk_help2(TeamList, [], Turn),
	F = fun(Team, AccList) ->
		lists:keystore(Team#champion_team.team_id, #champion_team.team_id, AccList, Team)
	    end,
	lists:foldl(F, OldTeamList, TeamList1).




start_pk_help2([TeamA, TeamB | TeamList], AccList, Turn) ->  %% A队和B队打
%%	?MYLOG("3v3", "TeamA ~p, TeamB ~p ~n", [TeamA, TeamB]),
	#champion_team{rank = RankA} = TeamA,
	#champion_team{rank = RankB} = TeamB,
	ResA = get_group(RankA, Turn),
	ResB = get_group(RankB, Turn),
	IsInSceneA = is_in_scene(TeamA),
	IsInSceneB = is_in_scene(TeamB),
	if
		ResA == ResB -> %% 满足要求, 同组的
			if
				IsInSceneA == true andalso IsInSceneB == false ->
					%%通知轮空胜利
					send_wheel_space_mail(TeamA, Turn),
					start_pk_help2(TeamList, [TeamA#champion_team{win_count = TeamA#champion_team.win_count + 1, wheel_space = 0}, TeamB | AccList], Turn);
				IsInSceneA == false andalso IsInSceneB == true ->
					%%通知轮空胜利
					send_wheel_space_mail(TeamB, Turn),
					start_pk_help2(TeamList, [TeamA, TeamB#champion_team{win_count = TeamB#champion_team.win_count + 1, wheel_space = 0} | AccList], Turn);
				IsInSceneA == false andalso IsInSceneB == false ->  %% 都不在场景内
					%%通知轮空胜利
					if
						TeamA#champion_team.star >= TeamB#champion_team.star ->  %% A组胜利
							send_wheel_space_mail(TeamA, Turn),
							start_pk_help2(TeamList, [TeamA#champion_team{win_count = TeamA#champion_team.win_count + 1, wheel_space = 0}, TeamB | AccList], Turn);
						true ->%% B组胜利
							send_wheel_space_mail(TeamB, Turn),
							start_pk_help2(TeamList, [TeamA, TeamB#champion_team{win_count = TeamB#champion_team.win_count + 1, wheel_space = 0} | AccList], Turn)
					end;
				true ->
					{NewTeamA, NewTeamB} = create_room(TeamA, TeamB),
					start_pk_help2(TeamList,
						[NewTeamA#champion_team{wheel_space = 1}, NewTeamB#champion_team{wheel_space = 1} | AccList], Turn)
			end;
		true ->         %% 默认TeamA 胜利
			%%通知一下A队自动胜利
			send_wheel_space_mail(TeamA, Turn),
			start_pk_help2([TeamB | TeamList], [TeamA#champion_team{win_count = TeamA#champion_team.win_count + 1, wheel_space = 0} | AccList], Turn)
	end;
start_pk_help2([TeamA | TeamList], AccList, Turn) ->  %% 队不够，自动胜利
	%% 通知一下A队自动胜利
	send_wheel_space_mail(TeamA, Turn),
	start_pk_help2(TeamList, [TeamA#champion_team{win_count = TeamA#champion_team.win_count + 1, wheel_space = 0} | AccList], Turn);
start_pk_help2([], AccList, _Turn) ->  %% 队不够，自动胜利
	AccList.


%%不在场不过滤了， 胜利次数不足的队伍
filter(TeamList, Turn) ->
	NewTeamList = sort(TeamList),
	F = fun(#champion_team{win_count = WinCount} = Team, AccList) ->
%%		IsInScene = is_in_scene(Team),
		if
			WinCount < Turn - 1 ->
				AccList;
			true ->
				[Team | AccList]
		end
	    end,
	lists:reverse(lists:foldl(F, [], NewTeamList)).


%%胜利次数不足的队伍
filter_guess(TeamList, Turn) ->
	NewTeamList = sort(TeamList),
	F = fun(#champion_team{win_count = WinCount} = Team, AccList) ->
%%		IsInScene = is_in_scene(Team),
		if
			WinCount < Turn - 1 ->
				AccList;
%%			IsInScene == false ->
%%				AccList;
			true ->
				[Team | AccList]
		end
	    end,
	lists:reverse(lists:foldl(F, [], NewTeamList)).


is_in_scene(Team) when is_record(Team, champion_team) ->
	#champion_team{role_list = RoleList} = Team,
	is_in_scene2(RoleList);
is_in_scene(_) ->
	false.


is_in_scene2([]) ->
	false;
is_in_scene2([#champion_team_role{is_in_champion_scene = Flag} | RoleList]) ->
	case Flag of
		1 ->
			true;
		_ ->
			is_in_scene2(RoleList)
	end.


get_pk_role_list(Team, GroupA) ->
	#champion_team{role_list = RoleList} = Team,
	F = fun(Role, AccList) ->
		#champion_team_role{is_in_champion_scene = Flag} = Role,
		if
			Flag == 0 ->  %% 不在场景里
				AccList;
			true ->
				Figure = #figure{
					name = Role#champion_team_role.role_name,
					lv_model = Role#champion_team_role.lv_figure,
					fashion_model = Role#champion_team_role.fashion_model,
					mount_figure = Role#champion_team_role.mount_figure,
					sex = Role#champion_team_role.sex,
					career = Role#champion_team_role.career,
					turn = Role#champion_team_role.turn,
					picture = Role#champion_team_role.picture,
					lv = Role#champion_team_role.lv,
					picture_ver = Role#champion_team_role.picture_id
				},
				NewRole = #kf_3v3_role_data{
					server_id = Role#champion_team_role.server_id,
					server_num = Role#champion_team_role.server_num,
					server_name = Role#champion_team_role.server_name,
					role_id = Role#champion_team_role.role_id,
					figure = Figure,
					power = Role#champion_team_role.power,
					team_id = Role#champion_team_role.team_id,
					group = GroupA
				},
				[NewRole | AccList]
		end
	    end,
	lists:foldl(F, [], RoleList).


create_room(TeamA, TeamB) ->
%%	?MYLOG("3v3", "TeamA ~p, TeamB ~p~n", [TeamA, TeamB]),
	if
		TeamA#champion_team.team_id > TeamB#champion_team.team_id ->
			GroupA = ?KF_3V3_GROUP_BLUE, GroupB = ?KF_3V3_GROUP_RED;
		true ->
			GroupA = ?KF_3V3_GROUP_RED, GroupB = ?KF_3V3_GROUP_BLUE
	end,
	RoleListA = get_pk_role_list(TeamA, GroupA),
	RoleListB = get_pk_role_list(TeamB, GroupB),
	PkTeamA = #kf_3v3_team_data{
		team_id = TeamA#champion_team.team_id,
		team_name = TeamA#champion_team.team_name,
		captain_id = TeamA#champion_team.leader_id,
		captain_name = TeamA#champion_team.leader_name,
		server_name = TeamA#champion_team.server_name,
		server_num = TeamA#champion_team.server_num,
		server_id = TeamA#champion_team.server_id,
		point = TeamA#champion_team.star,
		member_data = RoleListA
	},
	PkTeamB = #kf_3v3_team_data{
		team_id = TeamB#champion_team.team_id,
		team_name = TeamB#champion_team.team_name,
		captain_id = TeamB#champion_team.leader_id,
		captain_name = TeamB#champion_team.leader_name,
		server_name = TeamB#champion_team.server_name,
		server_num = TeamB#champion_team.server_num,
		server_id = TeamB#champion_team.server_id,
		point = TeamB#champion_team.star,
		member_data = RoleListB
	},
	PKData =
		#kf_3v3_pk_data{
			scene_id = ?PK_3V3_SCENE_ID, scene_pool_id = 0, room_id = TeamA#champion_team.team_id, team_data_a = PkTeamA, team_data_b = PkTeamB, type = 1
		},
	case mod_3v3_pk:start([PKData]) of
		{ok, Pid} ->
			%%更新信息
%%			?MYLOG("pk", "Pid ~p~n", [Pid]),
			LastRoleListA = [update_team_role_data(TempRole1, [{group, GroupA}, {pk_pid, Pid}]) || TempRole1 <- TeamA#champion_team.role_list],
			LastRoleListB = [update_team_role_data(TempRole2, [{group, GroupB}, {pk_pid, Pid}]) || TempRole2 <- TeamB#champion_team.role_list],
			LastTeamA = update_team_data(TeamA, [{group, GroupA}, {pk_pid, Pid}]),
			LastTeamB = update_team_data(TeamB, [{group, GroupB}, {pk_pid, Pid}]),
%%			?MYLOG("pk", "LastTeamA ~p~n", [LastTeamA]),
			update_local_role_status(RoleListA, 1),  %% 1 表示正常pk
			update_local_role_status(RoleListB, 1),  %% 1 表示正常pk
			{LastTeamA#champion_team{role_list = LastRoleListA}, LastTeamB#champion_team{role_list = LastRoleListB}};
		_R ->
			?ERR("mod_3v3_champion create_pk_room~p ~n", [_R]),
			{TeamA, TeamB}
	end.


update_team_data(Team, []) ->
	Team;
update_team_data(Team, [{Key, Value} | KV]) ->
	case Key of
		group ->
			update_team_data(Team#champion_team{group = Value}, KV);
		pk_pid ->
			update_team_data(Team#champion_team{pk_pid = Value}, KV);
		_ ->
			update_team_data(Team, KV)
	end.


update_team_role_data(Role, []) ->
	Role;
update_team_role_data(Role, [{Key, Value} | KV]) ->
	case Key of
		group ->
			update_team_role_data(Role#champion_team_role{group = Value}, KV);
		pk_pkd ->
			update_team_role_data(Role#champion_team_role{pk_pid = Value}, KV);
		_ ->
			update_team_role_data(Role, KV)
	end.

%% 加胜利次数, 处理竞猜信息
refresh_champion_team([Result, RedPoint, BluePoint, WinTower, _NWinnerList, _LoseTower, _NLoserList], TeamA, TeamB, State) ->
	if
		TeamA#team_score.group == Result ->
			WinTeamId = TeamA#team_score.team_id,
			ResList = [{TeamA#team_score.team_id, 1}, {TeamB#team_score.team_id, 0}];
		TeamB#team_score.group == Result ->
			WinTeamId = TeamB#team_score.team_id,
			ResList = [{TeamA#team_score.team_id, 0}, {TeamB#team_score.team_id, 1}];
		true ->  %% 打平了。分数高的，胜利
			if
				TeamA#team_score.star >= TeamB#team_score.star ->
					WinTeamId = TeamA#team_score.team_id,
					ResList = [{TeamA#team_score.team_id, 1}, {TeamB#team_score.team_id, 0}];
				true ->
					WinTeamId = TeamA#team_score.team_id,
					ResList = [{TeamA#team_score.team_id, 0}, {TeamB#team_score.team_id, 1}]
			end
	end,
	#champion_state{team_list = TeamList, guess_list = GuessList, turn = Turn} = State,
	F = fun({TeamId, Point}, AccTeamList) ->
		if
			Point == 0 ->
				AccTeamList;
			true ->
				case lists:keyfind(TeamId, #champion_team.team_id, AccTeamList) of
					#champion_team{win_count = WinCount} = Team ->
						lists:keystore(TeamId, #champion_team.team_id, AccTeamList, Team#champion_team{win_count = WinCount + 1});
					_ ->
						AccTeamList
				end
		end
	    end,
	NewTeamList = lists:foldl(F, TeamList, ResList),
	DiffPoint = abs(RedPoint - BluePoint),
	NewGuessList = handle_guess_result(TeamA, TeamB, WinTeamId, DiffPoint, WinTower, GuessList, Turn),
%%	?MYLOG("guess", "NewGuessList ~p~n", [NewGuessList]),
	State#champion_state{team_list = NewTeamList, guess_list = NewGuessList}.

%%  开始竞猜
%%1 是否是最后一轮
%%2 不是最后一轮轮次加1
%%3 结算上一轮竞猜结果
start_guess(State) ->
	#champion_state{turn = Turn, stage_ref = OldRef, team_list = TeamList, guess_list = OldGuessList, start_time = StartTime} = State,
	%%  结算上一轮竞猜结果
	handle_guess_result_all(OldGuessList),
	%% 是否是最后一轮
	if
		Turn == ?champion_last_turn ->  %%最后一轮
			%%结算奖励
			spawn(fun() -> calc_champion_reward(TeamList) end),
			send_tv_champion(TeamList),
			[save_team_only(Team) || Team <- TeamList],
			util:cancel_timer(OldRef),
			send_all_server_stage_msg(?champion_close, 0),
			State#champion_state{stage_end_time = 0, turn = 0, status = ?champion_close, guess_list = []};
		true ->   %%2 不是最后一轮轮次加1
			%%获得即将对战的队伍
			StageRef = util:send_after(OldRef, ?champion_guess_time * 1000, self(), {start_pk}),
			GuessTeamList = get_guess_team_list(TeamList, Turn + 1),
			GuessList = info_guess_list(GuessTeamList, Turn + 1),
			NewState = State#champion_state{turn = Turn + 1, status = ?champion_guess, guess_role_id_list = [],
				stage_ref = StageRef, stage_end_time = utime:unixtime() + ?champion_guess_time, guess_list = GuessList},
			%%场景广播阶段变化
			broadcast_stage(NewState),
			send_all_server_stage_msg(?champion_guess, utime:unixtime() + ?champion_guess_time),
			send_all_server_guess_list_and_team_list(GuessList, Turn + 1, TeamList, StartTime),
			NewState
	end.


enter_scene(TeamId, RoleId, Node, State) ->
	#champion_state{status = Status, team_list = TeamList, turn = Turn, stage_end_time = EndTime} = State,
%%	?MYLOG("3v3", " +++++++++++++++65076   ~p   ~n", [Status]),
%%	?MYLOG("3v3", " +++++++++++++++TeamId    ~p   ~n", [TeamId]),
%%	?MYLOG("3v3", " +++++++++++++++TeamList    ~p   ~n", [TeamList]),
	if
		Status == ?champion_close ->
%%			?MYLOG("3v3", " +++++++++++++++65076 ~n", []),
			{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_champion_pk_close)]),
			lib_server_send:send_to_uid(Node, RoleId, Bin),
			State;
		true ->
			case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
				#champion_team{role_list = RoleList, win_count = WinCount, wheel_space = WheelSpace} = Team ->
%%					Flag = is_wheel_space(TeamId, GuessList),
					case lists:keyfind(RoleId, #champion_team_role.role_id, RoleList) of
						#champion_team_role{server_id = ServerId} = Role ->
							NewRoleList = lists:keystore(RoleId, #champion_team_role.role_id, RoleList, Role#champion_team_role{is_in_champion_scene = 1}),
							NewTeamList = lists:keystore(TeamId, #champion_team.team_id, TeamList, Team#champion_team{role_list = NewRoleList}),
							KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}],
							%%切换场景
							lib_player:apply_cast(Node, RoleId, ?APPLY_CAST, ?NOT_HAND_OFFLINE, lib_scene, player_change_scene,
								[RoleId, ?champion_pk_scene, 0, 0, true, KeyValueList]),
							%% 广播78协议
							%% 加锁
							%%通知本地锁住
							mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
								[RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [?ERRCODE(err650_in_kf_3v3_act)]]),
							send_team_msg_to_all(NewRoleList, Turn, WinCount, Status, EndTime, WheelSpace),
							State#champion_state{team_list = NewTeamList};
						_ ->
							State
					end;
				_ ->
%%					?MYLOG("3v3", " +++++++++++++++65076 ~n", []),
					{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_not_16_team)]),
					lib_server_send:send_to_uid(Node, RoleId, Bin),
					State
			end
	end.

%%更新玩家
update_local_role_status(RoleList, Status) ->
	[mod_clusters_center:apply_cast(ServerId, lib_3v3_local, update_local_role_status, [RoleId, Status])
		|| #kf_3v3_role_data{server_id = ServerId, role_id = RoleId} <- RoleList].


get_battle_info(ServerId, RoleID, _RoleSid, TeamId, State) ->
	#champion_state{team_list = TeamList} = State,
%%	?MYLOG("pk", "get_battle_info +++++++++~n", []),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
%%			?MYLOG("pk", "get_battle_info +++++++++   ~p ~n", [PkPid]),
			catch PkPid ! {get_battle_info, [ServerId, RoleID, TeamId]};
		_ ->
			ok
	end.

enter_or_quit_tower(RoleId, Type, TowerId, TeamId, State) ->
	#champion_state{team_list = TeamList} = State,
%%	?MYLOG("pk", "enter_or_quit_tower +++++++++~n", []),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
			PkPid ! {enter_or_quit_tower, RoleId, Type, TowerId};
		_ ->
			ok
	end.


kill_enemy(_SceneId, _RoomId, DefRoleId, AtterId, AssistRoleList, TeamId, State) ->
	#champion_state{team_list = TeamList} = State,
%%	?MYLOG("pk", "kill_enemy +++++++++~n", []),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
			PkPid ! {kill_enemy, DefRoleId, AtterId, AssistRoleList};
		_ ->
			ok
	end.


quit_scene(TeamId, MyRoleId, _Node, State) ->
	#champion_state{team_list = TeamList, turn = Turn, status = Status, stage_end_time = EndTime} = State,
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{role_list = RoleList, win_count = WinCount, wheel_space = WheelSpace} = Team ->
%%			Flag = is_wheel_space(TeamId, GuessList),
			case lists:keyfind(MyRoleId, #champion_team_role.role_id, RoleList) of
				#champion_team_role{server_id = ServerId} = Role ->
					NewRole = Role#champion_team_role{is_in_champion_scene = 0},
					NewRoleList = lists:keystore(MyRoleId, #champion_team_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #champion_team.team_id, TeamList, Team#champion_team{role_list = NewRoleList}),
					send_team_msg_to_all(NewRoleList, Turn, WinCount, Status, EndTime, WheelSpace),
					%%通知本地锁住
					mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
						[MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free]]),
					State#champion_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.



get_champion_msg(TeamId, MyRoleId, _ServerId, Node, State) ->
	#champion_state{team_list = TeamList, turn = Turn, stage_end_time = Time, status = Status} = State,
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{role_list = RoleList, win_count = WinCount, wheel_space = WheelSpace} ->
%%			IsWheelFlag = is_wheel_space(TeamId, GuessList),
			case lists:keyfind(MyRoleId, #champion_team_role.role_id, RoleList) of
				#champion_team_role{} ->
					TempRoleList = [RoleId || #champion_team_role{is_in_champion_scene = Flag, role_id = RoleId} <- RoleList, Flag == 1],
					Num = length(TempRoleList),
					{ok, Bin} = pt_650:write(65078, [Turn, WinCount, Num, Status, WheelSpace, Time]),
%%					?MYLOG("pk", "65078 ~p~n", [{Turn, WinCount, Num, Status, Time}]),
%%					?PRINT("WheelSpace ~p~n", [WheelSpace]),
					lib_server_send:send_to_uid(Node, MyRoleId, Bin);
				_ ->
					ok
			end;
		_ ->
			ok
	end.

calc_champion_reward([]) ->
	[];
calc_champion_reward([H | TeamList]) ->
	timer:sleep(100),
	#champion_team{role_list = RoleLit, win_count = WinCount} = H,
	Rank = get_rank_by_win_count(WinCount),
	Reward = data_3v3:get_champion_reward(Rank),
	RankType = get_rank_type_by_win_count(WinCount),
	Title = utext:get(6500011),
	Content = utext:get(6500012, [RankType]),
%%	lib_player:apply_cast(Node, RoleId, ?APPLY_CAST, ?NOT_HAND_OFFLINE, lib_scene, player_change_scene,
%%		[RoleId, ?champion_pk_scene, 0, 0, true, KeyValueList]),
	KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}],
	[begin
		 mod_clusters_center:apply_cast(ServerId, lib_3v3_champion_mod, player_change_default_scene, [RoleId, KeyValueList]),
		 mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward]),
		 %%通知本地锁住
		 mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
			 [RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free]])
	 end
		
		|| #champion_team_role{server_id = ServerId, role_id = RoleId} <- RoleLit],
	calc_champion_reward(TeamList).



get_rank_by_win_count(WinCount) ->
	if
		WinCount == 0 ->
			16;
		WinCount == 1 ->
			8;
		WinCount == 2 ->
			4;
		WinCount == 3 ->
			2;
		true ->
			1
	end.

get_rank_type_by_win_count(WinCount) ->
	if
		WinCount == 0 ->
			utext:get(6500023); %%"16强";
		WinCount == 1 ->
			utext:get(6500019); %%"8强";
		WinCount == 2 ->
			utext:get(6500020); %%"4强";
		WinCount == 3 ->
			utext:get(6500021); %%"亚军";
		true ->
			utext:get(6500022)  %%"冠军"
	end.



%%获得要竞猜的队伍 Turn
get_guess_team_list(TeamList, Turn) ->
%%	?MYLOG("3v3", "TeamList ~p  ~p~n", [TeamList, Turn]),
	FilterTeamList = filter_guess(TeamList, Turn),
%%	?MYLOG("3v3", "FilterTeamList ~p~n", [FilterTeamList]),
	get_guess_team_list(FilterTeamList, [], Turn).



%%获取准备竞猜的队伍队伍
get_guess_team_list([TeamA, TeamB | TeamList], AccList, Turn) ->  %% A队和B队打
	#champion_team{rank = RankA} = TeamA,
	#champion_team{rank = RankB} = TeamB,
	ResA = get_group(RankA, Turn),
	ResB = get_group(RankB, Turn),
	if
		ResA == ResB -> %% 满足要求竞猜条件
			get_guess_team_list(TeamList, [{TeamA, TeamB} | AccList], Turn);
		true ->         %% 默认不同组，默认A组赢
			get_guess_team_list([TeamB | TeamList], [{TeamA, #champion_team{}} | AccList], Turn)
	end;
get_guess_team_list([_TeamA | TeamList], AccList, Turn) ->  %% 队不够，轮空的情况也要发
	start_pk_help2(TeamList, [{_TeamA, #champion_team{}} | AccList], Turn);
get_guess_team_list([], AccList, _Turn) ->
	AccList.



%%初始化竞猜列表  Turn 是从1开始的
info_guess_list(GuessTeamList, Turn) ->
	info_guess_list(GuessTeamList, Turn, []).

info_guess_list([], _Turn, GuessList) ->
	GuessList;
info_guess_list([{TeamA, TeamB} | GuessTeamList], Turn, GuessList) ->
	#champion_team{team_id = TeamAId, team_name = TeamAName} = TeamA,
	#champion_team{team_id = TeamBId, team_name = TeamBName} = TeamB,
	Msg = #kf_guess_msg{key = {Turn, TeamAId, TeamBId}, turn = Turn,
		team_a_id = TeamAId, team_a_name = TeamAName, team_b_id = TeamBId, team_b_name = TeamBName},
	info_guess_list(GuessTeamList, Turn, [Msg | GuessList]).



%%处理竞猜列表
handle_guess_result(TeamA, TeamB, WinTeamId, DiffPoint, WinTower, GuessList, Turn) ->
	#team_score{team_id = TeamAId, team_name = _TeamAName} = TeamA,
	#team_score{team_id = TeamBId, team_name = _TeamBName} = TeamB,
	WinOpt = ?IF(WinTeamId == TeamAId, 1, 2),  %% a队胜利，选项为 1  B队胜利为 2
	case lists:keyfind({Turn, TeamAId, TeamBId}, #kf_guess_msg.key, GuessList) of
		#kf_guess_msg{role_list = _RoleList} = GuessMsg ->
			case data_3v3:get_guess_config(Turn) of
				#base_guess_config{type = Type} ->
					if
						Type == 1 -> %%胜利方
							PkRes = {1, WinOpt};
						Type == 2 -> %% 塔数
							PkRes = {2, WinTower};
						Type == 3 -> %% 积分
							PkRes = {3, min(DiffPoint, ?PK_3V3_MAX_SCORE)};
						true ->
							PkRes = {1, WinOpt}
					end,
					NewGuessList =
						lists:keystore({Turn, TeamAId, TeamBId}, #kf_guess_msg.key, GuessList, GuessMsg#kf_guess_msg{pk_res = PkRes}),
%%					notice_role_guess_result(RoleList, PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn),
					NewGuessList;
				_ ->
					GuessList
			end;
		_ ->
			GuessList
	end.

%%通知玩家竞猜结果
notice_role_guess_result([], _PkRes, _TeamAId, _TeamAName, _TeamBId, _TeamBName, _Turn) ->
	ok;
notice_role_guess_result([{ServerId, RoleId} | RoleList], PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn) ->
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, notice_role_guess_result,
		[RoleId, PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn]),
	notice_role_guess_result(RoleList, PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn).


champion_team_list_info(RoleId, Node, State) ->
	#champion_state{team_list = TeamList, start_time = _StartTime} = State,
	PackList = get_team_list_info_pack(TeamList),
%%	?MYLOG("3v3pk", "champion_team_list_info ~p~n", [PackList]),
	Now = utime:unixtime(),
	ChampionStarTime = lib_3v3_api:champion_start_time(Now),
%%	if
%%		_StartTime < Now ->  %% 冠军赛已经过了
%%			StartTime = ChampionStarTime;
%%		true ->
%%			StartTime = _StartTime
%%	end,
	{ok, Bin} = pt_650:write(65075, [ChampionStarTime, PackList]),
	lib_server_send:send_to_uid(Node, RoleId, Bin).

get_team_list_info_pack(TeamList) ->
	F = fun(Team, AccList) ->
		#champion_team{team_id = TeamId, team_name = TeamName, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
			rank = Pos, win_count = WinCount} = Team,
		[{TeamId, TeamName, ServerId, ServerNum, ServerName, Pos, WinCount} | AccList]
	    end,
	lists:reverse(lists:foldl(F, [], TeamList)).


%%召集队员
call_team_role(TeamId, MyRoleId, State) ->
	#champion_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{role_list = RoleList, leader_name = LeaderName} ->
			[begin
				 {ok, Bin} = pt_650:write(65079, [LeaderName]),
%%				 ?MYLOG("call", "RoleId ~p~n", [RoleId]),
				 mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin])
			 end ||
				#champion_team_role{role_id = RoleId, server_id = ServerId, is_in_champion_scene = Flag} <- RoleList, Flag == 0 andalso RoleId =/= MyRoleId];
		_ ->
			ok
	end.

%%玩家竞猜
guess(ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum, #champion_state{status = ?champion_guess} = State) ->
	#champion_state{guess_role_id_list = GuessRoleIdList, guess_list = GuessList, team_list = TeamList} = State,
	case lists:member(MyRoleId, GuessRoleIdList) of
		true ->
			send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_have_guess_in_one_turn)),
			State;
		_ ->
			NewGuessRoleIdList = [MyRoleId | GuessRoleIdList],
			%%检查押注是否正确
			case data_3v3:get_guess_config(Turn) of
				#base_guess_config{opt_list = OptList, cost_list = CostList} ->
					case lists:keyfind(Opt, 1, OptList) of
						false ->
							send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_not_guess_opt)),
							State;
						_ ->
							case lists:keyfind(CostType, 1, CostList) of
								{CostType, Min, Max} ->
									if
										CostNum >= Min andalso CostNum =< Max ->
											case lists:keyfind({Turn, TeamAId, TeamBId}, #kf_guess_msg.key, GuessList) of
												#kf_guess_msg{role_list = RoleList, team_a_name = TeamAName, team_b_name = TeamBName} = GuessMsg -> %已经有这个竞猜记录，添加玩家信息就行了
													RoleList1 = lists:delete({ServerId, MyRoleId}, RoleList),
													RoleList2 = [{ServerId, MyRoleId} | RoleList1],
													NewGuessList =
														lists:keystore({Turn, TeamAId, TeamBId}, #kf_guess_msg.key, GuessList, GuessMsg#kf_guess_msg{role_list = RoleList2}),
													NewState = State#champion_state{guess_list = NewGuessList, guess_role_id_list = NewGuessRoleIdList};
												_ ->
													TeamAName = get_team_name_by_id(TeamList, TeamAId),
													TeamBName = get_team_name_by_id(TeamList, TeamBId),
													GuessMsg = #kf_guess_msg{key = {Turn, TeamAId, TeamBId}, role_list = [{ServerId, MyRoleId}],
														team_b_id = TeamBId, team_a_id = TeamAId, team_a_name = TeamAName, team_b_name = TeamBName},
													NewGuessList =
														lists:keystore({Turn, TeamAId, TeamBId}, #kf_guess_msg.key, GuessList, GuessMsg),
													NewState = State#champion_state{guess_list = NewGuessList, guess_role_id_list = NewGuessRoleIdList}
											end,
											send_to_role_err_80(ServerId, MyRoleId, ?SUCCESS),
											%%告诉通知本地进程，  竞猜成功， 扣除消耗
											mod_clusters_center:apply_cast(ServerId, lib_3v3_local, guess_success,
												[MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum, TeamAName, TeamBName]),
											NewState;
										true ->
											send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_guess_cost_num_err)),
											State
									end;
								_ ->
									send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_guess_cost_type_err)),
									State
							end
					end;
				_ ->
					send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_err_guess_turn)),
					State
			end
	end;
guess(ServerId, MyRoleId, _Turn, _TeamAId, _TeamBId, _Opt, _CostType, _CostNum, #champion_state{} = State) ->
	send_to_role_err_80(ServerId, MyRoleId, ?ERRCODE(err650_not_guess_stage)),
	State.


send_to_role_err(ServerId, RoleId, Error) ->
	{ok, Bin} = pt_650:write(65001, [Error]),
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).

send_to_role_err_80(ServerId, RoleId, Error) ->
	{ok, Bin} = pt_650:write(65080, [Error]),
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).





get_team_name_by_id(TeamList, TeamId) ->
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{team_name = TeamName} ->
			TeamName;
		_ ->
			""
	end.

%%竞猜列表
guess_list(ServerId, MyRoleId, TodayGuessRecordList, State) ->
	#champion_state{guess_list = GuessList, turn = Turn} = State,
	F = fun(#kf_guess_msg{team_a_id = TeamAid, team_b_id = TeamBid, team_a_name = TeamAName, team_b_name = TeamBName}, AccList) ->
		case lists:keyfind({Turn, TeamAid, TeamBid, utime:unixdate()}, #role_guess_record.key, TodayGuessRecordList) of
			#role_guess_record{opt = Opt, cost = Cost} ->
				case Cost of
					[{?TYPE_CURRENCY, CostType, Num} | _] ->
						ok;
					[{CostType, 0, Num} | _] ->
						ok;
					_ ->
						CostType = ?TYPE_BGOLD,
						Num = 0
				end,
				[{TeamAid, TeamBid, TeamAName, TeamBName, Opt, CostType, Num} | AccList];
			_ ->
				[{TeamAid, TeamBid, TeamAName, TeamBName, 0, 0, 0} | AccList]
		end
	
	    end,
%%	?MYLOG("guess", "GuessList ~p~n", [GuessList]),
	PackList = lists:reverse(lists:foldl(F, [], GuessList)),
	{ok, Bin} = pt_650:write(65081, [Turn, PackList]),
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin]).


%%发送竞猜列表和
send_all_server_guess_list_and_team_list(GuessList, Turn, TeamList, StartTime) ->
	PackList = [{TeamAId, TeamBId, TeamAName, TeamBName, 0, 0, 0} || #kf_guess_msg{team_a_id = TeamAId,
		team_b_id = TeamBId, team_a_name = TeamAName, team_b_name = TeamBName} <- GuessList],
	{ok, Bin} = pt_650:write(65081, [Turn, PackList]),
%%	?MYLOG("3v3pk", "PackList ~p~n", [PackList]),
	%% 推送 75 协议
	PackList2 = get_team_list_info_pack(TeamList),
	{ok, Bin2} = pt_650:write(65075, [StartTime, PackList2]),  %%  todo
%%	?MYLOG("3v3pk", "PackList ~p~n", [PackList]),
	mod_clusters_center:apply_to_all_node(lib_3v3_local, send_all_server_guess_list_and_team_list, [Bin, Bin2]).



champion_team_detail_msg(ServerId, MyRoleId, TeamId, State) ->
%%	?MYLOG("cym", "TeamId ~p~n", [TeamId]),
	#champion_state{team_list = TeamList} = State,
	SortF = fun(A, B) ->
		A#champion_team.star >= B#champion_team.star
	        end,
	SortTeamList = lists:sort(SortF, TeamList),
	SortTeamList1 = set_rank(SortTeamList),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{team_name = TeamName, leader_id = LeaderId, match_count = MatchCount, match_win_count = MatchWinCount, star = Star,
			role_list = RoleList
		} ->
			F = fun(Role, {Power, AccList}) ->
				#champion_team_role{
					server_name = ServerName,
					server_num = ServerNum,
					server_id = ServerId2,
					role_id = RoleId,
%%					role_name = RoleName,
%%					career = Career,
%%					sex = Sex,
%%					turn = Turn,
					power = RolePower
%%					lv_figure = LvFigure,
%%					fashion_model = FashionModel,
%%					mount_figure = MountFigure,
%%					picture = Picture,
%%					picture_id = PictureId
				} = Role,
				IsLeader = ?IF(RoleId == LeaderId, 1, 0),
%%				Lv = 0,
				{Power + RolePower,
					[{ServerId2, ServerName, ServerNum, RoleId, IsLeader} | AccList]}
			    end,
			{AllPower, PackList} = lists:foldl(F, {0, []}, RoleList),
			{Tier, Star} = lib_3v3_local:calc_tier_by_star(0, Star),
			case data_3v3:get_tier_info(Tier) of
				#tier_info{stage = BigRank} ->
					ok;
				_ ->
					BigRank = 0
			end,
			Rank = get_rank_by_team_id(TeamId, SortTeamList1),
%%			?MYLOG("cym", "Rank ~p~n", [Rank]),
			{ok, Bin} = pt_650:write(65084, [TeamId, TeamName, LeaderId, MatchCount, MatchWinCount, Rank, BigRank, Star, AllPower, PackList]),
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin]);
		_ ->
			ok
	end.


handle_guess_list_before_pk(GuessList, TeamList) ->
%%	?MYLOG("guess", "~p~n", [GuessList]),
	F = fun(GuessMsg, AccList) ->
		#kf_guess_msg{team_a_id = TeamAId, turn = Turn, team_b_id = TeamBId} = GuessMsg,
		TeamA = get_team_by_id(TeamList, TeamAId),
		TeamB = get_team_by_id(TeamList, TeamBId),
		ResA = is_in_scene(TeamA),
		ResB = is_in_scene(TeamB),
		if
			ResA == true andalso ResB == true ->
				[GuessMsg | AccList];
			ResA == true andalso ResB == false ->
				PkRes = get_default_pk_res(Turn, 1),
				[GuessMsg#kf_guess_msg{pk_res = PkRes} | AccList];
			ResA == false andalso ResB == true ->
				PkRes = get_default_pk_res(Turn, 2),
				[GuessMsg#kf_guess_msg{pk_res = PkRes} | AccList];
			true ->
				if
					TeamAId == 0 orelse TeamBId == 0 ->
						[GuessMsg | AccList];
					true ->
						Win = ?IF(TeamA#champion_team.star >= TeamB#champion_team.star, 1, 2),
						PkRes = get_default_pk_res(Turn, Win),
						[GuessMsg#kf_guess_msg{pk_res = PkRes} | AccList]
				end
		end
	    end,
	lists:reverse(lists:foldl(F, [], GuessList)).


get_team_by_id(TeamList, Id) ->
	case lists:keyfind(Id, #champion_team.team_id, TeamList) of
		#champion_team{} = Team ->
			Team;
		_ ->
			[]
	end.

%% Win 1 a对赢 2 b对赢
get_default_pk_res(Turn, Win) ->
	case data_3v3:get_guess_config(Turn) of
		#base_guess_config{type = Type} ->
			if
				Type == 1 -> %%胜利方
					{1, Win};
				Type == 2 -> %% 塔数  默认3个
					{2, 3};
				Type == 3 -> %% 分数  默认 2000
					{3, 2000};
				true ->
					{1, Win}
			end;
		_ ->
			{1, Win}
	end.

%%Turn 从1开始  POs 从1开始
get_group(Pos, Turn) ->
	util:floor((Pos - 1) / math:pow(2, Turn)).



handle_guess_result_all(GuessList) ->
%%	?MYLOG("guess", "GuessList ~p~n", [GuessList]),
	F = fun(GuessMsg) ->
		#kf_guess_msg{pk_res = PkRes, role_list = RoleList,
			team_a_id = TeamAId, team_b_id = TeamBId, team_a_name = TeamAName, team_b_name = TeamBName, turn = Turn} = GuessMsg,
		case PkRes of
			[] ->
				ok;
			_ ->
%%				?MYLOG("guess", "RoleList ~p~n", [RoleList]),
				notice_role_guess_result(RoleList, PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn)
		end
	    end,
	lists:foreach(F, GuessList).


%%发给场景内的玩家78协议
send_team_msg_to_all(RoleList, Turn, WinCount, Status, EndTime, WheelSpaceFlag) ->
	TempRoleList = [{ServerId, RoleId} || #champion_team_role{server_id = ServerId, is_in_champion_scene = Flag, role_id = RoleId} <- RoleList, Flag == 1],
	Num = length(TempRoleList),
%%	?MYLOG("3v3pk", "{Turn, WinCount, Num, Status, EndTime}  ~p~n", [{Turn, WinCount, Num, Status, EndTime}]),
%%	?MYLOG("3v3pk", "TempRoleList  ~p~n", [TempRoleList]),
	{ok, Bin} = pt_650:write(65078, [Turn, WinCount, Num, Status, WheelSpaceFlag, EndTime]),
	[mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin])
		|| {ServerId, RoleId} <- TempRoleList].


power_compare(ServerId, MyRoleId, TeamAId, TeamBId, State) ->
	#champion_state{team_list = TeamList} = State,
	TeamARoleList = get_team_power_msg(TeamAId, TeamList),
	TeamBRoleList = get_team_power_msg(TeamBId, TeamList),
	{ok, Bin} = pt_650:write(65085, [TeamARoleList ++ TeamBRoleList]),
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin]).



get_team_power_msg(TeamAId, TeamList) ->
	case lists:keyfind(TeamAId, #champion_team.team_id, TeamList) of
		#champion_team{role_list = RoleList, team_name = TeamName} ->
			[{TeamName, TeamAId, ServerName, ServerNum, RoleId, RoleName, Power, 0, Career, Sex, Lv, Turn, Picture, PictureId} ||
				#champion_team_role{server_name = ServerName, server_num = ServerNum, role_id = RoleId, role_name = RoleName,
					power = Power, career = Career, sex = Sex, turn = Turn, picture = Picture, picture_id = PictureId, lv = Lv} <- RoleList];
		_ ->
			[]
	end.


observed(ServerId, MyRoleId, TeamId, State) ->
	#champion_state{team_list = TeamList} = State,
	{ok, Bin} = pt_650:write(65086, [?ERRCODE(err650_no_in_pk), TeamId, 0, 0, 0]),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
			case is_pid(PkPid) of
				true ->
					case is_process_alive(PkPid) of
						true ->
							catch PkPid ! {observed, [ServerId, MyRoleId, TeamId]};
						false ->
							mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
					end;
				false ->
					mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
			end;
		_ ->
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
	end.

%% 退出观战
quit_observed(ServerId, MyRoleId, TeamId, State) ->
	#champion_state{team_list = TeamList} = State,
	{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_no_in_pk)]),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
			case is_pid(PkPid) of
				true ->
					case is_process_alive(PkPid) of
						true ->
							catch PkPid ! {quit_observed, [ServerId, MyRoleId, TeamId]};
						false ->
							mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
					end;
				false ->
					mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
			end;
		_ ->
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin])
	end.


broadcast_stage(State) ->
	%% 广播78协议
	#champion_state{team_list = TeamList, turn = Turn, status = Status, stage_end_time = EndTime} = State,
	F = fun(Team) ->
		#champion_team{role_list = RoleList, win_count = WinCount, wheel_space = WheelSpace, team_name = _TeamName} = Team,
%%		Flag = is_wheel_space(TeamId, GuessList),
%%		?MYLOG("3v3pk", "broadcast_stage TeamName ~s Wheel ~p ~n", [TeamName, WheelSpace]),
		send_team_msg_to_all(RoleList, Turn, WinCount, Status, EndTime, WheelSpace)
	    end,
	lists:foreach(F, TeamList).


%%发送竞猜列表和
send_all_server_stage_msg(Stage, EndTime) ->
%%	?MYLOG("3v3pk", "Stage ~p Endtime ~p~n", [Stage, EndTime]),
	{ok, Bin} = pt_650:write(65088, [?SUCCESS, Stage, EndTime]),
	mod_clusters_center:apply_to_all_node(lib_3v3_local, send_all_server_stage_msg, [Bin]).


handle_start_champion(TeamList) ->
	F = fun(Team, AccList) ->
		#champion_team{role_list = RoleList} = Team,
		NewRoleList = [Role#champion_team_role{is_in_champion_scene = 0} || Role <- RoleList],
		[Team#champion_team{role_list = NewRoleList, win_count = 0} | AccList]
	    end,
	lists:foldl(F, [], TeamList).

%% 分为A B C D 四组  ，第一 在A  第二在B  第三在C 第四在 D
%% 用排名最后的打最开始的
handle_team_group(TeamList) ->
	%% 顺序 TeamList 排名高到底
	List = [1, 5, 9, 13, 15, 11,  7,  3,  4, 8, 12, 16, 14, 10, 6, 2],
	handle_team_group(TeamList, List, []).
%% A 组第一个位置 1 B 组第一个位置 5 C 组第一个位置 9  D 组第一个位置 13
%%	handle_team_group_order(TeamList, 1, 5, 9, 13, []).  %% 暂时不用这个算法， 写了半天 :(

%%顺序放位置
handle_team_group_order([], _A, _B, _C, _D, AccList) ->
	AccList;
handle_team_group_order([Team1, Team2, Team3, Team4 | TeamList], A, B, C, D, AccList) ->   %% 剩下四个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	NewTeam3 = Team3#champion_team{rank = C},
	NewTeam4 = Team4#champion_team{rank = D},
	handle_team_group_desc(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2, NewTeam3, NewTeam4] ++ AccList);
handle_team_group_order([Team1, Team2, Team3 | TeamList], A, B, C, D, AccList) ->   %% 剩下3个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	NewTeam3 = Team3#champion_team{rank = C},
	handle_team_group_desc(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2, NewTeam3] ++ AccList);
handle_team_group_order([Team1, Team2 | TeamList], A, B, C, D, AccList) ->   %% 剩下2个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	handle_team_group_desc(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2] ++ AccList);
handle_team_group_order([Team1 | TeamList], A, B, C, D, AccList) ->   %% 剩下1个队
	NewTeam1 = Team1#champion_team{rank = A},
	handle_team_group_desc(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1] ++ AccList).


%%逆序放位置
handle_team_group_desc([], _A, _B, _C, _D, AccList) ->
	AccList;
handle_team_group_desc([Team1, Team2, Team3, Team4 | TeamList], A, B, C, D, AccList) ->   %% 剩下四个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	NewTeam3 = Team3#champion_team{rank = C},
	NewTeam4 = Team4#champion_team{rank = D},
	handle_team_group_order(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2, NewTeam3, NewTeam4] ++ AccList);
handle_team_group_desc([Team1, Team2, Team3 | TeamList], A, B, C, D, AccList) ->   %% 剩下3个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	NewTeam3 = Team3#champion_team{rank = C},
	handle_team_group_order(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2, NewTeam3] ++ AccList);
handle_team_group_desc([Team1, Team2 | TeamList], A, B, C, D, AccList) ->   %% 剩下2个队
	NewTeam1 = Team1#champion_team{rank = A},
	NewTeam2 = Team2#champion_team{rank = B},
	handle_team_group_order(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1, NewTeam2] ++ AccList);
handle_team_group_desc([Team1 | TeamList], A, B, C, D, AccList) ->   %% 剩下1个队
	NewTeam1 = Team1#champion_team{rank = A},
	handle_team_group_order(lists:reverse(TeamList), A + 1, B + 1, C + 1, D + 1, [NewTeam1] ++ AccList).


%% 轮空胜利邮件
send_wheel_space_mail(Team, Turn) ->
	PKType = case Turn of
		         1 ->
			         utext:get(6500019); %%"8强";
		         2 ->
			         utext:get(6500020); %%"4强";
		         3 ->
			         utext:get(6500021); %%"半决";
		         4 ->
			         utext:get(6500022); %%"冠军";
		         _ ->
			         utext:get(6500019) %%"8强";
	         end,
	Title = utext:get(6500013, [PKType]),
	Content = utext:get(6500014, [PKType]),
	case Team of
		#champion_team{role_list = RoleList} ->
			[mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, []])
				|| #champion_team_role{server_id = ServerId, role_id = RoleId} <- RoleList];
		_ ->
			skip
	end.

send_tv_champion(TeamList) ->
	TeamList1 = [Team || Team <- TeamList, Team#champion_team.win_count >= 4],
	case TeamList1 of
		[#champion_team{team_name = TeamName, role_list = RoleList, leader_id = LeaderId}] ->
			case lists:keyfind(LeaderId, #champion_team_role.role_id, RoleList) of
				#champion_team_role{server_num = ServerNum} ->
					mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 8, [ServerNum, TeamName]]);
				_ ->
					ok
			end;
		_ ->
			skip
	end.


get_rank_by_team_id(TeamId, SortTeamList) ->
	case lists:keyfind(TeamId, #champion_team.team_id, SortTeamList) of
		#champion_team{rank = Rank} ->
			Rank;
		_ ->
			0
	end.

set_rank(TeamList) ->
	set_rank(TeamList, 0, []).

set_rank([], _Rank, Res) ->
	Res;
set_rank([Team | T], Rank, Res) ->
	set_rank(T, Rank + 1, [Team#champion_team{rank = Rank + 1} | Res]).

handle_team_group([], _PosList, AccList) ->
	AccList;
handle_team_group([Team | TeamList], [Pos | PosList], AccList) ->
	handle_team_group(TeamList, PosList, [Team#champion_team{rank = Pos} | AccList]).


is_wheel_space(TeamId, GuessList) ->
	case lists:keyfind(TeamId, #kf_guess_msg.team_a_id, GuessList) of
		#kf_guess_msg{team_b_id = TeamB} when TeamB > 0->
			1; %% 不轮空
		_ ->
			case lists:keyfind(TeamId, #kf_guess_msg.team_a_id, GuessList) of
				#kf_guess_msg{team_a_id = TeamA} when TeamA > 0->
					1; %% 不轮空
				_ ->
					0
			end
	end.

player_change_default_scene(RoleId, KeyValueList) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_champion_mod, player_change_default_scene2, [KeyValueList]).

player_change_default_scene2(PS, KeyValueList) ->
	#player_status{scene = Scene, id = RoleId} = PS,
	case lib_3v3_api:is_3v3_champion_scene(Scene) of
		true ->
			lib_scene:player_change_default_scene(RoleId, KeyValueList);
		_ ->
			ok
	end,
	PS.





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	





















