%%% ----------------------------------------------------
%%% @Module:        mod_3v3_pk
%%% @Author:        zhl
%%% @Description:   跨服3v3战斗房间
%%% @Created:       2017/07/07
%%% ----------------------------------------------------

-module(mod_3v3_pk).
-behaviour(gen_server).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-export([
	start/1,                                %% 启动3v3战斗进程
	start_fight/0,                          %% 开始战斗
	stop_fight/0,                           %% 结束战斗
	
	create_mons/1,                          %% 创建房间怪物
	to_team_score/1,                        %% 转换#team_score{}
	kick_out_room/1,                        %% 将房间内所有玩家踢出场景
	tower_be_collected/3,                       %% 塔被占领
	test/0
	,leave_team/1
]).

-include("predefine.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("chat.hrl").
-include("3v3.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_module.hrl").


-record(state, {
	scene_id = 0,                           %% 场景id
	scene_pool_id = 0,                      %% 场景PoolId
	room_id = 0,                            %% 房间id
	pk_state = 0,                           %% 战斗状态
	ed_time = 0,                            %% 结束时间戳 - 不是进程结束时间戳
	team_score = [],                        %% 队伍积分
	role_score = [],                        %% 玩家积分
	tower_data = []                         %% 神塔数据
	, timer = []                              %% 积分倒计时
	, type = 0                              %% 0 普通排位赛  1 冠军赛
	, observer_list = []                    %% [{ServerId, Id}]
}).

%% ================== 3v3游戏部分规则=======================
%%
%% 占据塔数，积分（个人积分，队伍总积分）
%% 神塔每5s + 5积分
%% 击杀1人 + 2积分
%% 复活3s
%% 无敌10s
%%
%% ================== 3v3游戏部分规则=======================

%% @desc : 不能让子进程挂掉而导致公共进程挂掉
start(Args) ->
	gen_server:start(?MODULE, Args, []).

start_fight() ->
	self() ! {start_fight}.

stop_fight() ->
	self() ! {stop_fight}.


test() -> ok.

init([PKData]) ->
	#kf_3v3_pk_data{
		scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID, team_data_a = TeamA, team_data_b = TeamB,
		type = Type
	} = PKData,
	send_power_contrast(TeamA, TeamB), %% 发送双方的战力对比
%%	#kf_3v3_team_data{server_id = AServerId, team_id = ATeamId} = TeamA,
%%	#kf_3v3_team_data{server_id = BServerId, team_id = BTeamId} = TeamB,
%%	?MYLOG("pk", "pk init ~n", []),
%%    mod_clusters_center:apply_cast(AServerId, mod_3v3_local, send_team_info_to_all, [ATeamId]),
%%    mod_clusters_center:apply_cast(BServerId, mod_3v3_local, send_team_info_to_all, [BTeamId]),
	erlang:send_after(3000, self(), {pk_start}), %% 三秒之后拉人进房间战斗
	{TeamList, RoleList} = to_team_score([TeamA, TeamB]),
%%	?MYLOG("pk", "TeamList ~p~n", [TeamList]),
	State = #state{
		scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID, pk_state = ?KF_3V3_PK_READY, team_score = TeamList,
		role_score = RoleList, ed_time = utime:unixtime() + ?KF_3V3_PK_TIME + 3, type = Type
	},
	{ok, State}.

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

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

terminate(
	_Reason
	, #state{
		scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID,
		team_score = _TeamList, role_score = RoleList
	}
) ->
%%	leave_team(RoleList), %% 战斗结束 将不在线的玩家数据清除
	
	%% 将房间内所有玩家踢出房间
	case mod_scene_agent:apply_call(SceneID, ScenePoolId, lib_scene_agent, get_scene_user, [RoomID]) of
		false -> skip;
		UserList -> kick_out_room([UserList, RoleList])
	end,
	%% 清除房间数据
	lib_scene:clear_scene_room(SceneID, ScenePoolId, RoomID),
	
	% io:format("----UserList---~p~n", [UserList]),
	mod_3v3_center:stop_pk_room([SceneID, RoomID]), %% 退出房间 - 最好放在最后执行这方法
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% 发出开始战斗信号 - 拉人进场景
do_handle_info({pk_start}, State) ->
	#state{
		scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID, role_score = RoleList
	} = State,
	erlang:send_after(?KF_3V3_PK_TIME * 1000, self(), {stop_fight}), %% 三分钟之后终止，避免一直占用房间
	TowerData = init_tower(),
%%    ?MYLOG("pk", "pk init SceneID ~p ScenePoolId ~p RoomID~p~n", [SceneID, ScenePoolId, RoomID]),
%%    ?MYLOG("pk", "pk RoleList ~p~n", [RoleList]),
	pull_into_room(RoleList, [SceneID, ScenePoolId, RoomID]), %% 拉人进场景
	NTimer = erlang:send_after(?kf_3v3_pk_add_point_time, self(), {tower_score}),
	%% 一秒后发送传闻
	spawn(fun() ->
		timer:sleep(10000),
%%		?MYLOG("3v3", "Tv +++++  ~n", []),
		lib_chat:send_TV({scene, SceneID, ScenePoolId, RoomID}, ?MOD_KF_3V3, 1, [])
	      end
	),
	{noreply, State#state{pk_state = ?KF_3V3_PK_START, tower_data = TowerData, timer = NTimer}};


%% 聊天信息
do_handle_info({send_chat_to_team, [TeamId, _RoleID, BinData]}, State) ->
	#state{
		role_score = RoleList
	} = State,
	[mod_clusters_center:apply_cast(ServerId, lib_server_send:send_to_uid(RoleId, BinData))
		|| #role_score{team_id = TeamId1, role_id = RoleId, server_id = ServerId} <- RoleList, TeamId1 == TeamId],
	{noreply, State};



%% 冠军赛终止战斗
do_handle_info({stop_fight}, #state{scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID,
	team_score = TeamList, tower_data = TowerData, role_score = RoleList, timer = Timer,
	ed_time = EdTime, type = 1, observer_list = ObList} = State)
	when EdTime > 0 ->
	util:cancel_timer(Timer),
	erlang:send_after(10000, self(), {stop_pk_room}), %% 10s之后无论如何都会将玩家踢出场景
	case mod_scene_agent:apply_call(SceneID, ScenePoolId, lib_scene_agent, get_scene_user, [RoomID]) of
		false -> UserList = [];
		UserList -> ok
	end,
	RoleList1 = reset_online_all(RoleList, UserList), %% 活动结束就获取玩家是否在线
	{_Data, NRoleList, NewTeamA, NewTeamB} =
		calc_result_room(TeamList, TowerData, RoleList1), %% 结算积分，胜负
	[Result, RedPoint, BluePoint, WinTower, NWinnerList, LoseTower, NLoserList] = _Data,
	if
		Result == ?KF_3V3_RESULT_DRAW ->
			if
				NewTeamA#team_score.star >= NewTeamB#team_score.star ->
					WinTeamId = NewTeamA#team_score.team_id,   %%胜利的队伍id
					NewResult = NewTeamA#team_score.group;
				true ->
					WinTeamId = NewTeamB#team_score.team_id,
					NewResult = NewTeamB#team_score.group
			end;
		true ->
			if
				NewTeamA#team_score.group == Result ->
					WinTeamId = NewTeamA#team_score.team_id;   %%胜利的队伍id
				true ->
					WinTeamId = NewTeamB#team_score.team_id   %%胜利的队伍id
			end,
			NewResult = Result
	end,
	Data = [NewResult, RedPoint, BluePoint, WinTower, NWinnerList, LoseTower, NLoserList],
	log(State, Data, NRoleList),
	%% todo 更新team 的数据   冠军赛的pk算不算入胜率
	send_pk_result_champion(NRoleList, Data, WinTeamId, ObList), %% 推送战斗结算
	refresh_champion_team(Data, NewTeamA, NewTeamB), %%更新冠军赛数据
	%% 0 表示不再冠军赛pk
	[mod_clusters_center:apply_cast(ServerId, lib_3v3_local, update_local_role_status, [RoleId, 0])
		|| #role_score{server_id = ServerId, role_id = RoleId} <- NRoleList],
%%	%%解散队伍
	%%todo  清理数据
%%	lib_3v3_center:disband_team(NRoleList),
	{noreply, State#state{role_score = NRoleList, ed_time = 0}};

%% 终止战斗
do_handle_info({stop_fight}, #state{scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID,
	team_score = TeamList, tower_data = TowerData, role_score = RoleList, timer = Timer, ed_time = EdTime} = State)
	when EdTime > 0 ->
	util:cancel_timer(Timer),
	erlang:send_after(10000, self(), {stop_pk_room}), %% 10s之后无论如何都会将玩家踢出场景
	mod_3v3_center:update_team_pk([[TeamId || #team_score{team_id = TeamId} <- TeamList], 0]),
	% UserList = lib_scene:get_scene_user(SceneID, RoomID),
	case mod_scene_agent:apply_call(SceneID, ScenePoolId, lib_scene_agent, get_scene_user, [RoomID]) of
		false -> UserList = [];
		UserList -> ok
	end,
	lib_mon:clear_scene_mon(SceneID, ScenePoolId, self(), 1),   %% 清除房间怪物
	RoleList1 = reset_online_all(RoleList, UserList), %% 活动结束就获取玩家是否在线
	{Data, NRoleList, NewTeamA, NewTeamB} =
		calc_result_room(TeamList, TowerData, RoleList1), %% 结算积分，胜负
	log(State, Data, NRoleList),
	%%更新team 的数据
	send_pk_result(NRoleList, Data), %% 推送战斗结算
%%	?MYLOG("3v3", "NRoleList ~p~n", [NRoleList]),
%%	refresh_3v3_rank(NRoleList), %% 刷新积分排行榜
	refresh_3v3_team([NewTeamA, NewTeamB]), %% 刷新积分排行榜, 更新本地数据
	[lib_3v3_center:refresh_team_match_status(ServerId, TeamId, [], ?team_not_matching) ||
		#team_score{server_id = ServerId, team_id = TeamId} <- TeamList],
%%	%%解散队伍
	lib_3v3_center:disband_team(NRoleList),
	{noreply, State#state{role_score = NRoleList, ed_time = 0}};

%% 打扫房间
do_handle_info({stop_pk_room}, State) ->
	{stop, normal, State};

%% 采集完毕
do_handle_info(
	{collect_complete, [SceneID, ScenePoolId, RoomID, RoleID, MonID]}
	, #state{
		team_score = TeamList, tower_data = TowerData,
		role_score = RoleList, timer = Timer, ed_time = EdTime,
		observer_list = ObList
	} = State) when EdTime > 0 ->
	#role_score{group = Group, figure = #figure{name = Nickname}} = lists:keyfind(
		RoleID, #role_score.role_id, RoleList),
	if
		Timer == [] -> %% 每5s增加一次队伍积分
			NTimer = erlang:send_after(5000, self(), {tower_score});
		true -> NTimer = Timer
	end,
	case data_mon:get(MonID) of
		#mon{type = Type, name = MonName} ->
			% case Group == ?KF_3V3_GROUP_RED of
			%     true -> GroupName = utext:get(324);
			%     false -> GroupName  = utext:get(325)
			% end,
			% 编码可能有问题,用进程发送
			spawn(fun() ->
				lib_chat:send_TV({scene, SceneID, ScenePoolId, RoomID}, ?MOD_KF_3V3, 1, [MonName, unicode:characters_to_list(Nickname, unicode)])
			      end),
			NMonID = lib_3v3_center:get_tower_id(Group, MonID),
			{X, Y} = lib_3v3_center:get_tower_xy(MonID),
			CollectHandler = {?MODULE, tower_be_collected, self()},
			lib_mon:async_create_mon(NMonID, SceneID, ScenePoolId, X, Y, Type, RoomID, 1, [{group, Group}, {collected_handler, CollectHandler}]);
		_ -> skip
	end,
	NTeamList = add_score_team(TeamList, [Group, 2]), %% 队伍积分变动
%%    NRoleList = add_score_role(RoleList, RoleID, [{collect, 1}]), %% 玩家积分变动
	NTowerData = occupy_tower(TowerData, MonID, Group), %% 神塔变动
	% io:format("--------collect_complete-------~n"),
	send_occupy_tower(RoleList), %% 推送神塔采集广播
	send_score_notice(NTeamList, RoleList, ObList), %% 推送积分变更广播
	{noreply, State#state{team_score = NTeamList, role_score = RoleList,
		tower_data = NTowerData, timer = NTimer}};

%% 击杀玩家
do_handle_info({kill_enemy, DefRoleID, AttRoleID, AssistRoleList},
	#state{team_score = TeamList, role_score = RoleList, scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID,
		ed_time = EdTime, observer_list = ObList} = State) when EdTime > 0 ->
%%    case lists:keyfind(AttRoleID, #role_score.role_id, RoleList) of
%%        #role_score{figure = #figure{name = AttName}, group = Group} ->
%%            case lists:keyfind(DefRoleID, #role_score.role_id, RoleList) of
%%                #role_score{figure = #figure{name = DefName}} ->
%%                    % 编码可能有问题,用进程发送
%%                    spawn(fun() ->
%%                        lib_chat:send_TV({scene, SceneID, ScenePoolId, RoomID}, ?MOD_KF_3V3, 2, [AttName, DefName])
%%                    end);
%%                _ ->
%%                    skip
%%            end,
%%            NTeamList = add_score_team(TeamList, [Group, 2]); %% 积分变动
%%        _ ->
%%            NTeamList = TeamList
%%    end,
	NTeamList = TeamList,
	RoleList1 = add_score_role(RoleList, AttRoleID, [{kill, 1}], SceneID, ScenePoolId, RoomID), %% 玩家积分变动
	NRoleList = add_score_role(RoleList1, DefRoleID, [{killed, 1}], SceneID, ScenePoolId, RoomID), %% 玩家积分变动
	%%助攻者
	F = fun(#hit{id = HitId}, AccRoleList) ->
		if
			HitId =/= AttRoleID ->
				NewAccRoleList =
					add_score_role(AccRoleList, HitId, [{assist, 1}], SceneID, ScenePoolId, RoomID),
				NewAccRoleList;
			true ->
				AccRoleList
		end
	    end,
	LastRoleList = lists:foldl(F, NRoleList, AssistRoleList),
	% io:format("-------kill_enemy------~p~n", [{DefRoleID, AttRoleID, NRoleList}]),
	send_score_notice(NTeamList, LastRoleList, ObList), %% 推送积分变更广播
	{noreply, State#state{team_score = NTeamList, role_score = LastRoleList}};

%% 每5s增加一次队伍积分
do_handle_info({tower_score}, #state{team_score = TeamList, tower_data = TowerData,
	role_score = RoleList, ed_time = EdTime, observer_list = ObList} = State) when EdTime > 0 ->
	Timer = erlang:send_after(5000, self(), {tower_score}),
%%    NowTime = utime:unixtime(),
%%    ?MYLOG("3v32", "tower_score ++++++ ~n", []),
	
	F = fun(#tower_data{group = Group}, List) ->
		Temp = [Group || #tower_data{group = _Group} <- TowerData, _Group == Group],
		Length = length(Temp), %%占领塔数
		RatioScore = lib_3v3_local:get_score_add_by_ratio(Length, data_3v3:get_kv(add_score)),
		add_score_team(List, [Group, data_3v3:get_kv(add_score) + RatioScore])
	    end,
	NTeamList = lists:foldl(F, TeamList, TowerData),
%%    ?MYLOG("3v32", "TowerData  ~n ~p~n", [TowerData]),
%%	?MYLOG("3v3", "tower_score RoleList  ~n ~p~n", [RoleList]),
	send_score_notice(NTeamList, RoleList, ObList), %% 推送积分变更广播
	{noreply, State#state{timer = Timer, team_score = NTeamList}};

%% 获取战场信息
do_handle_info({get_battle_info, [ServerId, RoleId, TeamID]}, State) ->
	BattleInfo = to_battle_info(State, TeamID),
	?MYLOG("3v3", "BattleInfo ~p~n", [BattleInfo]),
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_battle_info, [[RoleId, BattleInfo]]),
	{noreply, State};

%% 离开战斗房间
%% @desc : 战斗未结算不能主动退出战场，主动退出战场不退出队伍
do_handle_info({leave_pk_room, RoleID, Type}, #state{
	role_score = RoleList, ed_time = EdTime} = State) ->
	case lists:keyfind(RoleID, #role_score.role_id, RoleList) of
		#role_score{
			server_id = ServerId, old_scene_info = OldScenInfo
		} = RoleScore when Type == ?PK_3V3_ONLINE andalso EdTime == 0 -> %% 结算时退出房间
			NRoleScore = RoleScore#role_score{online = Type},
			NRoleList = lists:keyreplace(
				RoleID, #role_score.role_id, RoleList, NRoleScore),
			NState = State#state{role_score = NRoleList},
			kick_out_room([ServerId, RoleID, OldScenInfo]);
		#role_score{} = RoleScore when Type == ?PK_3V3_OFFLINE -> %% 掉线
			NRoleScore = RoleScore#role_score{online = Type},
			NRoleList = lists:keyreplace(
				RoleID, #role_score.role_id, RoleList, NRoleScore),
			NState = State#state{role_score = NRoleList};
		_ ->
			NState = State
	end,
	{noreply, NState};

%% 重登战斗战场
do_handle_info({enter_pk_room, [RoleID, RoleSid]}, #state{role_score = RoleList, ed_time = EdTime} = State) ->
	NowTime = utime:unixtime(),
	if
		EdTime - NowTime =< 10 -> %% 玩家重登离战斗结束只剩10s，不拉进战场
			NRoleList = RoleList;
		true ->
			case lists:keyfind(RoleID, #role_score.role_id, RoleList) of
				#role_score{} = RoleScore ->
					NRoleScore = RoleScore#role_score{sid = RoleSid, online = ?PK_3V3_ONLINE},
					NRoleList = lists:keyreplace(
						RoleID, #role_score.role_id, RoleList, NRoleScore);
				_ ->
					NRoleList = RoleList
			end
%%            enter_pk_room(NRoleList, [RoleID, SceneID, ScenePoolId, RoomID]) %% 把玩家重新拉进战场
	end,
	{noreply, State#state{role_score = NRoleList}};

%% 退出队伍，并退出房间
do_handle_info({leave_team, RoleID}, #state{ed_time = EdTime,
	role_score = RoleList} = State) ->
	RoleScore = lists:keyfind(RoleID, #role_score.role_id, RoleList),
	if
		EdTime == 0 andalso RoleScore /= false -> %% 战斗结束，可以退出队伍
			#role_score{server_id = ServerId, old_scene_info = OldScenInfo} = RoleScore,
			mod_3v3_center:ret_leave_team(RoleID),
			kick_out_room([ServerId, RoleID, OldScenInfo]),
			
			NRoleList = lists:keydelete(RoleID, #role_score.role_id, RoleList),
			NState = State#state{role_score = NRoleList};
		RoleScore /= false -> %% 战斗未结束，不能退出队伍
			#role_score{server_id = ServerId, sid = RoleSid} = RoleScore,
			mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_team, [[RoleSid, ?ERRCODE(err650_kf_3v3_fighting)]]),
			NState = State;
		true ->
			NState = State
	end,
	{noreply, NState};

%% 进出塔
do_handle_info({enter_or_quit_tower, RoleId, Type, TowerId}, #state{ed_time = EdTime, tower_data = TowerDataList,
	role_score = RoleList, scene_pool_id = PoolId, scene_id = Scene, room_id = RoomId} = State) ->
	Now = utime:unixtime(),
	?MYLOG("3v32", "enter_or_quit_tower ~p~n", [{RoleId, Type, TowerId}]),
	if
		EdTime >= Now ->
			case lists:keyfind(TowerId, #tower_data.mon_id, TowerDataList) of
				#tower_data{} = TowerData ->
					#tower_data{red_role_list = RedRoleList, blue_role_list = BlueRoleList} = TowerData,
					case lists:keyfind(RoleId, #role_score.role_id, RoleList) of
						#role_score{group = Group} ->
							if
								Group == ?KF_3V3_GROUP_BLUE ->  %%蓝色方
									case Type of
										?kf_3v3_enter_tower -> %%进入塔
											_BlueRoleList = lists:delete(RoleId, BlueRoleList),
											NewBlueRoleList = [RoleId | _BlueRoleList];
										_ ->%%出塔
											NewBlueRoleList = lists:delete(RoleId, BlueRoleList)
									end,
									?MYLOG("3v32", "NewBlueRoleList ~p~n", [NewBlueRoleList]),
									NewTowerData = TowerData#tower_data{blue_role_list = NewBlueRoleList};
								true ->  %%红色方
									case Type of
										?kf_3v3_enter_tower -> %%进入塔
											_RedRoleList = lists:delete(RoleId, RedRoleList),
											NewRedRoleList = [RoleId | _RedRoleList];
										_ ->%%出塔
											NewRedRoleList = lists:delete(RoleId, RedRoleList)
									end,
									?MYLOG("3v32", "NewRedRoleList ~p~n", [NewRedRoleList]),
									NewTowerData = TowerData#tower_data{red_role_list = NewRedRoleList}
							end,
							?MYLOG("3v32", "NewTowerData ~p~n", [NewTowerData]),
							LastTowerData = handle_tower_progress(NewTowerData, Scene, PoolId, RoomId),
							NewTowerDataList = lists:keystore(TowerId, #tower_data.mon_id, TowerDataList, LastTowerData),
							NewState = State#state{tower_data = NewTowerDataList},
							{noreply, NewState};
						_ ->
							{noreply, State}
					end;
				_ -> %%错误的塔id
					{noreply, State}
			end;
		true ->  %% 时间不对
			{noreply, State}
	end;




%% 定时处理塔的进度
do_handle_info({handle_tower_rate, TowerId}, #state{ed_time = EdTime, tower_data = TowerDataList,
	scene_pool_id = PoolId, scene_id = Scene, room_id = RoomId} = State) ->
	?MYLOG("3v32", "handle_tower_rate ++++++~n", []),
	Now = utime:unixtime(),
	if
		EdTime >= Now ->
			case lists:keyfind(TowerId, #tower_data.mon_id, TowerDataList) of
				#tower_data{} = TowerData ->
					NewTowerData = handle_tower_progress(TowerData, Scene, PoolId, RoomId),
					NewTowerDataList = lists:keystore(TowerId, #tower_data.mon_id, TowerDataList, NewTowerData),
					{noreply, State#state{tower_data = NewTowerDataList}};
				_ ->
					{noreply, State}
			end;
		true ->
			{noreply, State}
	end;


%% 玩家信息
do_handle_info({get_role_list_msg, RoleId, Node}, #state{role_score = RoleList} = State) ->
	send_pk_role_list_msg_to_client(RoleId, Node, RoleList),
	{noreply, State};



%% 观战
do_handle_info({observed, [ServerId, MyRoleId, TeamId]},
	#state{team_score = TeamScoreList, observer_list = ObList, scene_id = SceneID, scene_pool_id = ScenePoolId, room_id = RoomID} = State) ->
	
	case lists:keyfind(TeamId, #team_score.team_id, TeamScoreList) of
		#team_score{leader_id = LeaderAId, group = Group} ->
			NewTeamList = lists:keydelete(TeamId, #team_score.team_id, TeamScoreList),
			#team_score{team_id = OtherTeamId, leader_id = LeaderBId} = hd(NewTeamList),
			case Group of  %% 蓝组的队长放在前面
				?KF_3V3_GROUP_BLUE ->
					{ok, Bin} = pt_650:write(65086, [?SUCCESS, TeamId, OtherTeamId, LeaderAId, LeaderBId]);
				_ ->
					{ok, Bin} = pt_650:write(65086, [?SUCCESS, TeamId, OtherTeamId, LeaderBId, LeaderAId])
			end,
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [MyRoleId, Bin]),
			%%切换场景
			?MYLOG("3v3pk", "ServerId, MyRoleId, TeamId ~p~n", [{ServerId, MyRoleId, TeamId}]),
			KeyValueList = [{change_scene_hp_lim, 1}, {scene_hide_type, ?HIDE_TYPE_VISITOR}],
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[MyRoleId, SceneID, ScenePoolId, RoomID, false, KeyValueList]),
			%%修改数据
			ObList1 = lists:delete({ServerId, MyRoleId}, ObList),
			ObList2 = [{ServerId, MyRoleId} | ObList1],
			{noreply, State#state{observer_list = ObList2}};
		_ ->
			{noreply, State}
	end;

%% 退出观战
do_handle_info({quit_observed, [ServerId, MyRoleId, _TeamId]},
	#state{observer_list = ObList} = State) ->
	%%切换场景
	KeyValueList = [{change_scene_hp_lim, 1}, {scene_hide_type, 0}],
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_default_scene,
		[MyRoleId, KeyValueList]),
	%%修改数据
	ObList1 = lists:delete({ServerId, MyRoleId}, ObList),
	{noreply, State#state{observer_list = ObList1}};
do_handle_info(_Request, State) ->
	{noreply, State}.

%% 转换#team_score{}
to_team_score([#kf_3v3_team_data{team_id = TeamIDA, team_name = TeamNameA, member_data = MemberDataA, map_power = MapPowerA, tier = TierA, point = PointA
	, server_id = ServerIdA, server_num = ServerNumA, server_name = ServerNameA, team_type = TeamTypeA} = TeamA,
	#kf_3v3_team_data{team_id = TeamIDB, team_name = TeamNameB, member_data = MemberDataB, map_power = MapPowerB, tier = TierB, point = PointB
		, server_id = ServerIdB, server_num = ServerNumB, server_name = ServerNameB, team_type = TeamTypeB} = TeamB]) ->
	if
		TeamIDA > TeamIDB ->
			GroupA = ?KF_3V3_GROUP_BLUE, GroupB = ?KF_3V3_GROUP_RED;
		true ->
			GroupA = ?KF_3V3_GROUP_RED, GroupB = ?KF_3V3_GROUP_BLUE
	end,
	{LeaderIdA, LeaderNameA} = get_leader_id_and_name(TeamA),
	{LeaderIdB, LeaderNameB} = get_leader_id_and_name(TeamB),
	RoleListA = to_role_score(MemberDataA, GroupA, []),
	RoleList = to_role_score(MemberDataB, GroupB, RoleListA),
	TeamScoreA = #team_score{team_id = TeamIDA, team_name = TeamNameA, group = GroupA, map_power = MapPowerA, tier = TierA, star = PointA, server_id = ServerIdA
		, server_num = ServerNumA, server_name = ServerNameA, leader_id = LeaderIdA, leader_name = LeaderNameA, team_type = TeamTypeA},
	TeamScoreB = #team_score{team_id = TeamIDB, team_name = TeamNameB, group = GroupB, map_power = MapPowerB, tier = TierB, star = PointB
		, server_id = ServerIdB, server_name = ServerNameB, server_num = ServerNumB, leader_id = LeaderIdB, leader_name = LeaderNameB, team_type = TeamTypeB},
	{[TeamScoreA, TeamScoreB], RoleList};
to_team_score(_) -> {[], []}.

%% 转换#role_score{}
to_role_score([], _, List) ->
	List;
to_role_score([Member | Rest], Group, List) ->
	#kf_3v3_role_data{
		server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
		figure = Figure, power = Power,
		% nickname = Nickname, sex = Sex, lv = RoleLv, vip = Vip, fashion_id = FashionID,
		% train_weapon = TWeapon, train_fly = TFly,
		sid = RoleSid, team_id = TeamID, is_single = IsSingle,
		tier = Tier, star = Star, continued_win = ContinuedWin, old_scene_info = OldScenInfo
	} = Member,
	RoleScore = #role_score{
		server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
		figure = Figure, power = Power, is_single = IsSingle,
		% nickname = Nickname, sex = Sex, lv = RoleLv, vip = Vip, fashion_id = FashionID,
		% train_weapon = TWeapon, train_fly = TFly,
		sid = RoleSid, team_id = TeamID, group = Group,
		tier = Tier, star = Star, continued_win = ContinuedWin, old_scene_info = OldScenInfo
	},
	to_role_score(Rest, Group, [RoleScore | List]).

%% 转换战力对比
to_power_contrast([], List) ->
	List;
to_power_contrast([#kf_3v3_team_data{
	team_id = TeamID, member_data = MemberData} | Rest], List) ->
	F = fun(
		       #kf_3v3_role_data{
			       server_name = ServerName, server_num = ServerNum, role_id = RoleID,
			       figure = #figure{name = Nickname, lv = Lv, vip = VipLv, career = Career, sex = Sex, turn = Turn, picture = Picture, picture_ver = PictureVer},
			       power = Power
		       }
		       , Data) ->
		[{TeamID, ServerName, ServerNum, RoleID, Nickname, Power, VipLv, Career, Sex, Lv, Turn, Picture, PictureVer} | Data]
	    end,
	NList = lists:foldl(F, List, MemberData),
	to_power_contrast(Rest, NList).

%% 转换战场信息
to_battle_info(#state{ed_time = EndTime, team_score = [TeamA, TeamB], role_score = _RoleList, tower_data = TowerDataList}, TeamID) ->
	#team_score{team_id = TeamIDA, score = ScoreA} = TeamA,
	#team_score{team_id = TeamIDB, score = ScoreB} = TeamB,
	RateMsg = get_tower_rate(TowerDataList),
	if
		TeamID == TeamIDA ->
%%            _RoleBattle = to_role_battle(RoleList, TeamID, []),
			MyTeamID = TeamIDA, MyTeamScore = ScoreA,
			EnemyScore = ScoreB, EnemyTeamID = TeamIDB;
		TeamID == TeamIDB ->
%%            RoleBattle = to_role_battle(RoleList, TeamID, []),
			MyTeamID = TeamIDB, MyTeamScore = ScoreB,
			EnemyScore = ScoreA, EnemyTeamID = TeamIDA;
		true ->
			MyTeamID = 0, MyTeamScore = 0,
%%            RoleBattle = [],
			EnemyScore = 0, EnemyTeamID = 0
	end,
	LeftTime = erlang:max(EndTime - utime:unixtime(), 0),
	[?SUCCESS, LeftTime, MyTeamScore, MyTeamID, RateMsg, EnemyScore, EnemyTeamID].

%%to_role_battle([], _, Data) ->
%%    Data;
%%to_role_battle([#role_score{team_id = TID} | Rest], TeamID, Data) when TID /= TeamID ->
%%    to_role_battle(Rest, TeamID, Data);
%%to_role_battle([#role_score{
%%        server_name = ServerName, server_num = ServerNum, role_id = RoleID,
%%        % nickname = Nickname, sex = Sex,
%%        figure = #figure{name = Nickname, career = Career, lv = Lv, sex = Sex, turn = Turn},
%%        collect = Collect, kill = Kill, killed = Killed
%%    } | Rest], TeamID, Data) ->
%%    NData = [{ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Kill, Killed, Collect} | Data],
%%    to_role_battle(Rest, TeamID, NData).

%% 拉人进场景，分组，满血量
pull_into_room([], _) ->
	ok;
pull_into_room([#role_score{role_id = RoleID, server_id = ServerId, group = Group} | Rest], [SceneID, ScenePoolId, RoomID]) ->
	[{x, X}, {y, Y}] = lib_3v3_center:revive(Group),
	KeyValueList = [{group, Group}, {change_scene_hp_lim, 1}],
	?MYLOG("room", "ServerId ~p~n", [ServerId]),
	mod_clusters_center:apply_cast(ServerId, lib_achievement_api, async_event, [RoleID, lib_achievement_api, cluster_3v3_event, 1]),
	?MYLOG("room", " ~p~n", [{ServerId, lib_scene, player_change_scene,
		[RoleID, SceneID, ScenePoolId, RoomID, X, Y, false, KeyValueList]}]),
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
		[RoleID, SceneID, ScenePoolId, RoomID, X, Y, false, KeyValueList]),
	%% 完成活动
	mod_clusters_center:apply_cast(ServerId, lib_activitycalen_api, role_success_end_activity, [RoleID, ?MOD_KF_3V3, 1, 1]),
	pull_into_room(Rest, [SceneID, ScenePoolId, RoomID]).

%% 玩家重新PK战场
%%enter_pk_room(RoleList, [RoleID, SceneID, ScenePoolId, RoomID]) ->
%%    case lists:keyfind(RoleID, #role_score.role_id, RoleList) of
%%        #role_score{group = Group, server_id = ServerId} ->
%%            [{x, X}, {y, Y}] = lib_3v3_center:revive(Group),
%%            KeyValueList = [{group, Group}],
%%            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
%%                [RoleID, SceneID, ScenePoolId, RoomID, X, Y, false, KeyValueList]);
%%            % ?MODULE ! {get_battle_info, [Platform, ServerNum, RoleSid, TeamID]};
%%        _ -> %% 检查第二组
%%            skip
%%    end.

%% 将房间内所有玩家踢出场景
%% @desc : 取消分组，回复血量 等状态更新在 lib_3v3_local 模块中
kick_out_room([ServerId, RoleID, OldScenInfo]) when is_integer(RoleID) ->
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, kick_out_room, [RoleID, OldScenInfo]);
kick_out_room([UserList, RoleList]) ->
	F = fun(#ets_scene_user{id = RoleID, server_id = ServerId}) ->
		case lists:keyfind(RoleID, #role_score.role_id, RoleList) of
			#role_score{old_scene_info = OldScenInfo} -> ok;
			_ -> OldScenInfo = undefined
		end,
		mod_clusters_center:apply_cast(ServerId, lib_3v3_local, kick_out_room, [RoleID, OldScenInfo])
	    end,
	lists:foreach(F, UserList);
kick_out_room(_) -> ok.

%% 发送双方的战力对比
send_power_contrast(TeamA, TeamB) ->
	Data = to_power_contrast([TeamA, TeamB], []),
	#kf_3v3_team_data{member_data = MemberDataA} = TeamA,
	#kf_3v3_team_data{member_data = MemberDataB} = TeamB,
	F = fun(#kf_3v3_role_data{server_id = ServerId, role_id = RoleID}) ->
		?MYLOG("3v3", "RoleID ~p Data ~p~n", [RoleID, Data]),
		mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_power_contrast, [[RoleID, Data]])
	    end,
	lists:foreach(F, MemberDataA ++ MemberDataB).

%% 发送神塔采集广播
send_occupy_tower(RoleList) ->
	F = fun(#role_score{server_id = ServerId, sid = RoleSid}) ->
		mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_occupy_tower, [[RoleSid]])
	    end,
	lists:foreach(F, RoleList).

%% 发送积分变更广播
send_score_notice([#team_score{group = GroupA, score = ScoreA},
	#team_score{group = GroupB, score = ScoreB}], RoleList, ObList) ->
	if
		GroupA > GroupB ->
			Data = [ScoreB, ScoreA];
		true ->
			Data = [ScoreA, ScoreB]
	end,
	F = fun(#role_score{server_id = ServerId, role_id = RoleId}) ->
		mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_score_notice, [[RoleId, Data]])
	    end,
	lists:foreach(F, RoleList),
	F2 = fun({ServerId2, RoleId2}) ->
		mod_clusters_center:apply_cast(ServerId2, mod_3v3_local, send_score_notice, [[RoleId2, Data]])
	     end,
	lists:foreach(F2, ObList).

%% 发送玩家战场数据变更广播
send_role_score(RoleList, Group, Data) ->
	F = fun(#role_score{server_id = ServerId, sid = RoleSid, group = TGroup}) ->
		if
			TGroup == Group ->
				mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_role_score, [[RoleSid, Data]]);
			true -> skip
		end
	    end,
	lists:foreach(F, RoleList).

%% 推送战斗结算
send_pk_result(RoleList, Data) ->
	F = fun(#role_score{
		server_id = ServerId, role_id = RoleID, honor = Honor, reward = Reward,
		tier = Tier, star = Star, continued_win = ContinuedWin, is_single = Single
	}) ->
		if
			Single == 1 ->
				NewTier = 1, NewStar = 0;
			true ->
				NewTier = Tier, NewStar = Star
		end,
		mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_pk_result, [[Single, RoleID, NewTier, NewStar, Honor, Reward, ContinuedWin, Data]])
	    end,
	lists:foreach(F, RoleList).

%%冠军赛结算
send_pk_result_champion(RoleList, Data, WinTeamId, ObList) ->
	WinReward = data_3v3:get_kv(champion_pk_win_reward),
	FailReward = data_3v3:get_kv(champion_pk_fail_reward),
	F = fun(#role_score{
		server_id = ServerId, role_id = RoleID, honor = Honor,
		tier = Tier, star = Star, continued_win = ContinuedWin, team_id = TeamId
	}) ->
		if
			TeamId == WinTeamId ->
				Reward = WinReward;
			true ->
				Reward = FailReward
		end,
		mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_pk_result_champion, [[RoleID, Tier, Star, Honor, Reward, ContinuedWin, Data]])
	    end,
	lists:foreach(F, RoleList),
	F2 = fun({ObServerId, ObRoleId}) ->
		mod_clusters_center:apply_cast(ObServerId, lib_3v3_local, send_pk_result_champion_ob, [[ObRoleId, Data]])
	     end,
	lists:foreach(F2, ObList).


reset_online_all(RoleList, UserList) when is_list(UserList) ->
	F = fun(#role_score{role_id = RoleID} = R, List) ->
		case lists:keyfind(RoleID, #ets_scene_user.id, UserList) of
			#ets_scene_user{} ->
				[R#role_score{online = ?PK_3V3_ONLINE} | List];
			_ ->
				[R#role_score{online = ?PK_3V3_OFFLINE} | List]
		end
	    end,
	lists:foldl(F, [], RoleList);
reset_online_all(RoleList, _) -> RoleList.

%% 队伍增加积分
%% @desc : 率先超过300积分的队伍获胜
add_score_team([#team_score{group = GroupA, score = OldScoreA} = TeamA,
	#team_score{group = GroupB, score = OldScoreB} = TeamB], [Group, Score]) ->
	if
		Group == GroupA ->
			if
				OldScoreA + Score >= ?PK_3V3_MAX_SCORE ->
					catch self() ! {stop_fight};
				true -> skip
			end,
			[TeamA#team_score{score = OldScoreA + Score}, TeamB];
		Group == GroupB ->
			if
				OldScoreB + Score >= ?PK_3V3_MAX_SCORE ->
					catch self() ! {stop_fight};
				true -> skip
			end,
			[TeamA, TeamB#team_score{score = OldScoreB + Score}];
		true ->
			[TeamA, TeamB]
	end.

%% 玩家增加积分
%% 击杀1人 + 2积分
add_score_role(RoleList, RoleID, KeyValueList, SceneId, PoolId, RoomId) ->
	case lists:keyfind(RoleID, #role_score.role_id, RoleList) of
		#role_score{group = Group} = RoleScore ->
			F = fun({Key, Val}, R) ->
				case Key of
					collect ->
						R#role_score{collect = R#role_score.collect + Val};
					kill ->
						#role_score{continuous_kill_count = ContinuousKill, role_id = RoleId, figure = Figure} = R,
						if
							ContinuousKill + Val >= ?kf_3v3_continuous_kill ->%%推送连杀
								{ok, Bin} = pt_650:write(65048, [RoleId, Figure, ContinuousKill + Val]),
								lib_server_send:send_to_scene(SceneId, PoolId, RoomId, Bin);
							true ->
								ok
						end,
						R#role_score{kill = R#role_score.kill + Val, continuous_kill_count = ContinuousKill + Val};
					killed ->
						R#role_score{killed = R#role_score.killed + Val, continuous_kill_count = 0};
					assist ->
						R#role_score{assist = R#role_score.assist + Val};
					_ ->
						R
				end
			    end,
			NRoleScore = lists:foldl(F, RoleScore, KeyValueList),
			NRoleList = lists:keyreplace(RoleID, #role_score.role_id, RoleList, NRoleScore),
			#role_score{
				server_name = ServerName, server_num = ServerNum, role_id = RoleID, kill = Kill,
				killed = Killed, collect = Collect
			} = NRoleScore,
			Data = [ServerName, ServerNum, RoleID, Kill, Killed, Collect],
			send_role_score(NRoleList, Group, Data), %% 推送玩家积分变更广播
			NRoleList;
		_ ->
			RoleList
	end.

%% 神塔每5s + 2积分，超过一分钟，每5s + 5积分
occupy_tower(TowerData, MonID, Group) ->
	NMonID = lib_3v3_center:get_tower_id(Group, MonID),
	%% 删除MonID
	case lists:keyfind(MonID, #tower_data.mon_id, TowerData) of
		#tower_data{group = G1} when G1 /= Group ->
			TowerData1 = lists:keydelete(MonID, #tower_data.mon_id, TowerData);
		_ ->
			TowerData1 = TowerData
	end,
	%% 新增NMonID
	case lists:keyfind(NMonID, #tower_data.mon_id, TowerData1) of
		#tower_data{group = G2} when G2 == Group ->
			TowerData1;
		_ ->
			TowerInfo = #tower_data{mon_id = NMonID, time = utime:unixtime(), group = Group},
			[TowerInfo | TowerData1]
	end.

%% 战斗结束 将不在线的玩家数据清除
leave_team(RoleList) ->
	{AList, BList, LeaveList} = leave_team_handler(RoleList, [], [], [], {0, 0}),
	mod_3v3_center:update_unite_data([AList, BList, LeaveList]).

leave_team_handler([], AList, BList, LeaveList, {TeamIDA, TeamIDB}) ->
	{{TeamIDA, AList}, {TeamIDB, BList}, LeaveList};
leave_team_handler([#role_score{
	server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
	sid = RoleSid, tier = Tier, star = Star,
	continued_win = ContinuedWin, group = Group, team_id = TeamID,
	online = IsOnline} | Rest], AList, BList, LeaveList, {TeamIDA, TeamIDB}) ->
	if
		IsOnline == ?PK_3V3_OFFLINE ->
			NLeaveList = [[ServerName, ServerNum, ServerId, RoleID, RoleSid] | LeaveList];
		true ->
			NLeaveList = LeaveList
	end,
	if
		Group == ?KF_3V3_GROUP_BLUE ->
			NAList = [{RoleID, [{pk_pid, 0}, {group, 0}, {tier, Tier}, {star, Star},
				{continued_win, ContinuedWin}]} | AList],
			leave_team_handler(Rest, NAList, BList, NLeaveList, {TeamID, TeamIDB});
		true ->
			NBList = [{RoleID, [{pk_pid, 0}, {group, 0}, {tier, Tier}, {star, Star},
				{continued_win, ContinuedWin}]} | BList],
			leave_team_handler(Rest, AList, NBList, NLeaveList, {TeamIDA, TeamID})
	end.

%% ========================= 结算战斗积分 ==========================
%% 1.正常结束                                   
%%  活动持续3分钟，结束时，哪方占领的塔数多，哪方获胜，如果塔数一样，总积分多的一方获胜                              
%%      增加积分的时候，塔顶需要飘字：xxx队+yyy分                            
%%  占领塔的数量 > 战斗积分 > 队伍匹配战力                              
%%      增加积分的时候，人物头顶需要飘字：xxx队+yyy分                          
%%  如果都一样，则为平局，所有玩家的竞技积分和荣耀积分不变                             

%% 2.提前结束                                   
%%  如果某方提前达到300分则提前结束游戏
%% =================================================================
calc_result_room([#team_score{score = ScoreA, group = GroupA, map_power = _MapPowerA, tier = _TierA, star = _StarA} = TeamA,
	#team_score{score = ScoreB, group = GroupB, map_power = _MapPowerB, tier = _TierB, star = _StarB} = TeamB], TowerData, RoleList) ->
	F = fun(#tower_data{group = OccupyID}, {TA, TB}) ->
		if
			OccupyID == GroupA -> {TA + 1, TB};
			OccupyID == GroupB -> {TA, TB + 1};
			true -> {TA, TB}
		end
	    end,
	{TowerA, TowerB} = lists:foldl(F, {0, 0}, TowerData),
	if
		TowerA > TowerB orelse
			(TowerA == TowerB andalso ScoreA > ScoreB) ->
			Result = GroupA, WinTower = TowerA, LoseTower = TowerB, WinGroup = GroupA; %% A队胜利
		TowerA < TowerB orelse
			(TowerA == TowerB andalso ScoreA < ScoreB) ->
			Result = GroupB, WinTower = TowerB, LoseTower = TowerA, WinGroup = GroupB; %% B队胜利
		true ->
			Result = ?KF_3V3_RESULT_DRAW, WinTower = TowerA, LoseTower = TowerB, WinGroup = GroupA %% 打平
	end,
	%% PS : Data发生变化需要修改一下所有函数
	case Result == ?KF_3V3_RESULT_DRAW of
		true -> WinType = draw, LoseType = draw;
		false -> WinType = win, LoseType = lose
	end,
	% 依然需要WinGroup 抽取数据
	MaxWorldLv = get_max_world_lv(RoleList),
	PowerList = get_power_list(RoleList),
	{WinnerList, LoserList} = calc_result_role(RoleList, WinGroup, {[], []}),
	NWinnerList = calc_mvp(sort_score(WinnerList), 0, WinType, []),  %% 基本无用
	NLoserList = calc_mvp(sort_score(LoserList), 0, LoseType, []),   %% 基本无用
	RoleList1 = get_tier_star(NWinnerList, WinType, RoleList),
	NRoleList = get_tier_star(NLoserList, LoseType, RoleList1),
	?MYLOG("pk", "NWinnerList ~p~n NLoserList ~p~n", [NWinnerList, NLoserList]),
	{NewTeamA, NewTeamB, NewTierList} = calc_team_tier(TeamA, TeamB, WinGroup, MaxWorldLv, PowerList),
	{RedPoint, BluePoint} = ?IF(GroupA == ?KF_3V3_GROUP_RED, {ScoreA, ScoreB}, {ScoreB, ScoreA}),
	LastRoleList = reset_tier(NRoleList, NewTierList),
	{[Result, RedPoint, BluePoint, WinTower, NWinnerList, LoseTower, NLoserList], LastRoleList, NewTeamA, NewTeamB}.




%% 计算各玩家积分
calc_result_role([], _, Result) ->
	Result;
calc_result_role([#role_score{group = Group, server_name = ServerName, server_num = ServerNum,
	role_id = RoleID, kill = Kill, killed = Killed, collect = Collect, assist = Assist,
	power = Power, figure = #figure{name = Nickname, career = Career, sex = Sex, lv = Lv, turn = Turn}} | Rest], WinGroup, {WinnerList, LoserList}) ->
	if
		Killed == 0 ->
			Score = (1.5 * Kill + Assist + 0.5 * Collect); %% 玩家积分值
		true ->
			Score = (1.5 * Kill + Assist + 0.5 * Collect) / Killed %% 玩家积分值
	end,
%%	Score = calc_score_new(MyTeamId, MyPoint),
	Data = {ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, Assist, Killed, Collect, Score},
	if
		Group == WinGroup ->
			calc_result_role(Rest, WinGroup, {[Data | WinnerList], LoserList});
		true ->
			calc_result_role(Rest, WinGroup, {WinnerList, [Data | LoserList]})
	end.

%% ========================= MVP 计算公式 ==============================
%% K：K头数
%% A：助攻数
%% D：死亡数
%% T：占塔数
%%
%% 胜方MVP：   获胜一方的人当中                
%%  评分=(1.5*K+A+0.5*T)/D            最高者得MVP 
%%                  
%% 败方MVP：   失败一方的人当中                
%%  满足两个条件才出现：              
%%  K>5 &   (1.5*K+A+0.5*T)/D > 2.5     
%%                  
%% 暂时没有助攻，则A=0                  
%% ======================================================================
calc_mvp([], _, _, List) ->
	List;
calc_mvp([{ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, AssistKilled, Killed, Collect, Score} | Rest],
	I, Type, List) ->
	if
		Type == win andalso I == 0 ->
			Data = {ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, AssistKilled, Killed, Collect, 1},
			calc_mvp(Rest, I + 1, Type, [Data | List]);
		Type == lose andalso I == 0 andalso Score > 2.5 andalso Kill > 5 ->
			Data = {ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, AssistKilled, Killed, Collect, 1},
			calc_mvp(Rest, I + 1, Type, [Data | List]);
		Type == draw andalso I == 0 andalso Score > 2.5 andalso Kill > 5 ->
			Data = {ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, AssistKilled, Killed, Collect, 1},
			calc_mvp(Rest, I + 1, Type, [Data | List]);
		true ->
			Data = {ServerName, ServerNum, RoleID, Nickname, Career, Sex, Lv, Turn, Power, Kill, AssistKilled, Killed, Collect, 0},
			calc_mvp(Rest, I + 1, Type, [Data | List])
	end.

%% 积分排序 - 降序
sort_score(List) ->
	F = fun({_, _, _, _, _, _, _, _, PowerA, _, _, _, _, ScoreA}, {_, _, _, _, _, _, _, _, PowerB, _, _, _, _, ScoreB}) ->
		if
			ScoreA > ScoreB -> true;
			ScoreA < ScoreB -> false;
			true -> PowerA >= PowerB
		end
	    end,
	lists:sort(F, List).

%% ======================== 计算段位星数 ================================
%% 1，玩家初始状态1星，可以通过3V3战斗，获得星数加减
%%  途径有：                            
%%      加：战斗胜利，MVP，连胜奖励                     
%%      减：战斗失败
%% 2，玩家参与3V3玩法，战斗获胜，星数+2，战斗失败，星数-1
%% 3，段位与星数的关系                               
%%  满足条件的星数，即进入下一段，段位头衔改变。
%% 4，保护措施：最低段位（青铜段位）的玩家，失败不掉星
%% 5，连胜奖励：从第3场连胜开始，玩家每连胜一次，可额外获得+1星奖励
%% 6，MVP：每局战斗结算，根据玩家战场表现，评选MVP，MVP获得星数+1
%% =====================================================================
get_tier_star([], _, RoleList) ->
	RoleList;
get_tier_star([{ServerName, ServerNum, RoleID, _, _, _, _, _, _, _, _, _, _, IsMVP} | Rest],
	Type, RoleList) ->
	case get_role_score(RoleList, [ServerName, ServerNum, RoleID]) of
		{ok, #role_score{continued_win = ContinuedWin,
			tier = Tier, star = Star} = RoleScore} ->
			{NTier, NStar, Reward, NContinuedWin, Fame} =
				calc_tier_star(Type, Tier, Star, IsMVP, ContinuedWin),
			?MYLOG("pk", "RoleID ~p Star ~p  NStar ~p  Type ~p~n", [RoleID, Star, NStar, Type]),
			NRoleScore = RoleScore#role_score{tier = NTier, star = NStar,
				continued_win = NContinuedWin, honor = Fame, reward = Reward},
			NRoleList = lists:keyreplace(RoleID, #role_score.role_id, RoleList, NRoleScore),
			get_tier_star(Rest, Type, NRoleList);
		_ ->
			get_tier_star(Rest, Type, RoleList)
	end.







-define(MVP_START, 0).
%% 计算段位星数 & 荣誉奖励
%% @return : {Tier, Star, Honor}
calc_tier_star(Type, Tier, Star, IsMVP, ContinuedWin) ->
	case data_3v3:get_tier_info(Tier) of
		#tier_info{star = NeedStar, win_star = WinStar, lose_star = LoseStar} ->
			ContinuedWinStar = data_3v3:get_win_row(ContinuedWin + 1),
			if
				Type == win andalso IsMVP == 1 ->
					{NTier, NStar} = calc_tier_star_handler(
						Tier, Star, WinStar + ContinuedWinStar + ?MVP_START, NeedStar),
					{WinReward, _LoseReward, _LoseFame, WinFame} = calc_tier_star_handler2(NTier),
					{NTier, NStar, WinReward, ContinuedWin + 1, WinFame};
				Type == win ->
					{NTier, NStar} = calc_tier_star_handler(
						Tier, Star, WinStar + ContinuedWinStar, NeedStar),
					{WinReward, _LoseReward, _LoseFame, WinFame} = calc_tier_star_handler2(NTier),
					{NTier, NStar, WinReward, ContinuedWin + 1, WinFame};
				Type == lose andalso IsMVP == 1 ->
					{NTier, NStar} = calc_tier_star_handler(
						Tier, Star, LoseStar + ?MVP_START, NeedStar),
					{_WinReward, LoseReward, LoseFame, _WinFame} = calc_tier_star_handler2(NTier),
					{NTier, NStar, LoseReward, 0, LoseFame};
				Type == draw andalso IsMVP == 1 ->
					{NTier, NStar} = calc_tier_star_handler(
						Tier, Star, LoseStar + ?MVP_START, NeedStar),
					{_WinReward, LoseReward, LoseFame, _WinFame} = calc_tier_star_handler2(NTier),
					{NTier, NStar, LoseReward, 0, LoseFame};
				true ->
					{NTier, NStar} = calc_tier_star_handler(
						Tier, Star, LoseStar, NeedStar),
					{_WinReward, LoseReward, LoseFame, _WinFame} = calc_tier_star_handler2(NTier),
					{NTier, NStar, LoseReward, 0, LoseFame}
			end;
		_ ->
			{Tier, Star, [], 0, 0}
	end.

%% 新的段位星数
calc_tier_star_handler(Tier, Star, AddStar, _NeedStar) ->
	NStar = Star + AddStar,
	lib_3v3_local:calc_tier_by_star(Tier, NStar).
% if
%     NStar > Star ->
%         case data_3v3:get_tier_info(Tier + 1) of
%             #tier_info{star = NextStar} when NStar < NextStar ->
%                 {Tier, NStar};
%             #tier_info{star = NextStar} when NStar >= NextStar ->
%                 {Tier + 1, NStar};
%             _ ->
%                 {Tier, NeedStar}
%         end;
%     NStar < Star andalso NStar < NeedStar ->
%         case data_3v3:get_tier_info(Tier - 1) of
%             #tier_info{} ->
%                 {Tier - 1, erlang:max(NStar, 0)};
%             _ ->
%                 {Tier, erlang:max(NStar, 0)}
%         end;
%     true ->
%         {Tier, NStar}
% end.

calc_tier_star_handler2(Tier) ->
	case data_3v3:get_tier_info(Tier) of
		#tier_info{win_reward = WinReward, lose_reward = LoseReward, lose_fame = LoseFame, win_fame = WinFame} ->
			{WinReward, LoseReward, LoseFame, WinFame};
		_ ->
			{[], [], 0, 0}
	end.

get_role_score(RoleList, [ServerName, ServerNum, RoleID]) ->
	get_role_score_handler(RoleList, [ServerName, ServerNum, RoleID]).

get_role_score_handler([], _) ->
	false;
get_role_score_handler([#role_score{server_name = SN, server_num = S, role_id = ID
} = RoleScore | Rest], [ServerName, ServerNum, RoleID]) ->
	case {ServerName, ServerNum, RoleID} of
		{SN, S, ID} ->
			{ok, RoleScore};
		_ ->
			get_role_score_handler(Rest, [ServerName, ServerNum, RoleID])
	end.

%%%% 刷新3v3排行榜
%%refresh_3v3_rank(RoleList) ->
%%	NowTime = utime:unixtime(),
%%	F = fun(
%%		       #role_score{
%%			       server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
%%			       figure = #figure{name = Nickname, lv = Lv, career = Career, sex = Sex, vip = VipLv},
%%			       power = Power, tier = Tier, star = Star}
%%		       , List
%%	       ) ->
%%		RoleRank = #kf_3v3_rank_data{
%%			server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
%%			nickname = Nickname, career = Career, sex = Sex, lv = Lv, vip_lv = VipLv,
%%			power = Power, tier = Tier, star = Star, time = NowTime
%%		},
%%		[RoleRank | List]
%%	    end,
%%	RankList = lists:foldl(F, [], RoleList),
%%	mod_3v3_rank:refresh_3v3_rank(RankList).

%% 刷新积分排行榜, 更新本地数据
refresh_3v3_team(TeamList) ->
	NowTime = utime:unixtime(),
	F = fun(
		       #team_score{
			       server_name = ServerName, server_num = ServerNum, server_id = ServerId, team_id = TeamId, tier = Tier, star = Star, team_name = TeamName, map_power = Power
			       , leader_name = LeaderName, leader_id = LeaderId, team_type = TeamType} = TeamScore
		       , List
	       ) ->
		TeamRank = #kf_3v3_team_rank_data{
			server_name = ServerName, server_num = ServerNum, server_id = ServerId, team_id = TeamId, team_name = TeamName,
			power = Power, tier = Tier, star = Star, time = NowTime, leader_name = LeaderName, leader_id = LeaderId
		},
		if
			TeamType == 0 ->  %%0 是战队
				%%同步本地
%%				mod_clusters_center:apply_cast(ServerId, mod_3v3_team, center_update_local_team, [TeamScore]),
				mod_3v3_team:center_update_local_team(TeamScore),
				[TeamRank | List];
			true ->
				List
		end
	    end,
	LastList = lists:foldl(F, [], TeamList),
	mod_3v3_rank:refresh_3v3_team(LastList).
%%	mod_3v3_rank:refresh_3v3_team(RankList).



%% 祭坛信息
create_mons([SceneID, ScenePoolId, RoomID]) ->
	TowerInfo = lib_3v3_center:get_tower_info(),
	TowerData = create_towers(TowerInfo, [SceneID, ScenePoolId, RoomID], []),
	GuardianInfoL = lib_3v3_center:get_guardian_info(),
	create_guardians(GuardianInfoL, [SceneID, ScenePoolId, RoomID]),
	TowerData.

%% 生成神塔
create_towers([], _, TowerData) ->
	TowerData;
create_towers([{MonID, {X, Y}} | Rest], [SceneID, ScenePoolId, RoomID], TowerData) ->
	case data_mon:get(MonID) of
		#mon{type = Type} ->
			CollectHandler = {?MODULE, tower_be_collected, self()},
%%            {collect_complete, [SceneID, ScenePoolId, RoomID, RoleID, MonID]}
			lib_mon:async_create_mon(MonID, SceneID, ScenePoolId, X, Y, Type, RoomID, 1, [{collected_handler, CollectHandler}]),
			NTowerData = [#tower_data{mon_id = MonID} | TowerData];
		_ ->
			NTowerData = TowerData
	end,
	create_towers(Rest, [SceneID, ScenePoolId, RoomID], NTowerData).

%% 生成守护神
create_guardians([], _) ->
	ok;
create_guardians([{MonID, X, Y, Args} | Rest], [SceneID, ScenePoolId, RoomID]) ->
	case data_mon:get(MonID) of
		#mon{type = Type} ->
			lib_mon:async_create_mon(MonID, SceneID, ScenePoolId, X, Y, Type, RoomID, 1, Args);
		_ -> skip
	end,
	create_guardians(Rest, [SceneID, ScenePoolId, RoomID]).

%% 日志
log(State, Data, NRoleList) ->
	#state{room_id = RoomID} = State,
	NowTime = utime:unixtime(),
	<<PkId:48>> = <<NowTime:32, RoomID:16>>,
	[Result, _RedPoint, _BluePoint, _WinTower, NWinnerList, _LoseTower, NLoserList] = Data,
	log_3v3_pk_room(State, PkId, Result),
	log_3v3_pk_team(State#state.team_score, PkId, Result),
	log_3v3_pk_role(NWinnerList ++ NLoserList, PkId, Result, NRoleList, State#state.role_score),
	ok.

log_3v3_pk_room(
	#state{
		scene_id = SceneId, scene_pool_id = ScenePoolId, room_id = RoomId, tower_data = TowerData,
		role_score = RoleList, team_score = TeamScoreL
	}
	, PkId, Result) ->
	F = fun(#tower_data{mon_id = MonId, time = Time, group = Group}) -> {MonId, Time, Group} end,
	TowerDataF = [F(T) || T <- TowerData],
	BRoleList = [Name || #role_score{figure = #figure{name = Name}, group = Group} <- RoleList, Group == ?KF_3V3_GROUP_BLUE],
	RRoleList = [Name || #role_score{figure = #figure{name = Name}, group = Group} <- RoleList, Group == ?KF_3V3_GROUP_RED],
	case BRoleList of
		[BName1, BName2, BName3 | _] -> ok;
		[BName1, BName2] -> BName3 = "";
		[BName1] -> BName2 = "", BName3 = "";
		_ -> BName1 = "", BName2 = "", BName3 = ""
	end,
	case RRoleList of
		[RName1, RName2, RName3 | _] -> ok;
		[RName1, RName2] -> RName3 = "";
		[RName1] -> RName2 = "", RName3 = "";
		_ -> RName1 = "", RName2 = "", RName3 = ""
	end,
	case lists:keyfind(?KF_3V3_GROUP_BLUE, #team_score.group, TeamScoreL) of
		false -> BScore = 0;
		#team_score{score = BScore} -> ok
	end,
	case lists:keyfind(?KF_3V3_GROUP_RED, #team_score.group, TeamScoreL) of
		false -> RScore = 0;
		#team_score{score = RScore} -> ok
	end,
	BTowerNum = length([Group || #tower_data{group = Group} <- TowerData, Group == ?KF_3V3_GROUP_BLUE]),
	RTowerNum = length([Group || #tower_data{group = Group} <- TowerData, Group == ?KF_3V3_GROUP_RED]),
	lib_log_api:log_3v3_pk_room(SceneId, ScenePoolId, RoomId, TowerDataF, PkId, Result, BName1, BName2, BName3, BScore,
		BTowerNum, RName1, RName2, RName3, RScore, RTowerNum),
	ok.

log_3v3_pk_team([], _PkId, _Result) -> skip;
log_3v3_pk_team([#team_score{
	team_id = TeamId, group = Group, score = Score, kill = Kill,
	killed = Killed, assist = Assist} | T]
	, PkId, Result) ->
	lib_log_api:log_3v3_pk_team(PkId, TeamId, Group, Score, Kill, Killed, Assist, Result),
	log_3v3_pk_team(T, PkId, Result).

log_3v3_pk_role([], _PkId, _Result, _NRoleList, _ORoleList) -> skip;
log_3v3_pk_role([{_Platform, _ServerNum, RoleId, Name, _Career, _Sex, _Lv, _Turn, _Power, Kill, Killed, _Assist, Collect, IsMvp} | T], PkId, Result, NRoleList, ORoleList) ->
	case lists:keyfind(RoleId, #role_score.role_id, NRoleList) of
		false -> NewTier = 0, NewStar = 0, NewContinuedWin = 0, Honor = 0, Assist = 0, Group = 0;
		#role_score{tier = NewTier, star = NewStar, continued_win = NewContinuedWin, honor = Honor, assist = Assist, group = Group} ->
			ok
	end,
	case lists:keyfind(RoleId, #role_score.role_id, ORoleList) of
		false -> OldTier = 0, OldStar = 0, OldContinuedWin = 0;
		#role_score{tier = OldTier, star = OldStar, continued_win = OldContinuedWin} -> ok
	end,
	lib_log_api:log_3v3_pk_role(PkId, RoleId, Name, Group, OldTier, OldStar, OldContinuedWin, NewTier, NewStar, NewContinuedWin,
		Kill, Killed, Collect, Assist, Honor, IsMvp, Result),
	log_3v3_pk_role(T, PkId, Result, NRoleList, ORoleList).

tower_be_collected(Minfo, CollectorId, BattlePid) ->
	#scene_object{scene = SceneID, scene_pool_id = ScenePoolId, copy_id = RoomID, config_id = MonID} = Minfo,
	BattlePid ! {collect_complete, [SceneID, ScenePoolId, RoomID, CollectorId, MonID]}.

init_tower() ->
	List = data_3v3:get_kv(altar_coordinate),
	[#tower_data{mon_id = Id} || {Id, _XY} <- List].

%% -----------------------------------------------------------------
%% @desc     功能描述  处理祭坛的进度函数
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_tower_progress(TowerData, SceneId, PoolId, RoomId) ->
	#tower_data{time = Time, progress_rate_speed = Speed, end_time = EndTime, mon_id = TowerId, rate_ref = RateRef,
		progress_rate = Rate, red_role_list = RedRoleList, blue_role_list = BlueRoleList, group = Group} = TowerData,
	Now = utime:unixtime(),
	LRed = length(RedRoleList),
	LBlue = length(BlueRoleList),
	if
		Time > 0 andalso Now >= Time andalso Now =< EndTime andalso Speed =/= 0 ->  %%有占领时间且当前时间在读条时间内，且读条数据 > 0
			TempRate = min((Now - Time) * Speed + Rate, 100),
			if
				TempRate < 0 ->   %%进度变为负数， 则改变组别
					NewGroup = change_group(Group);
				true ->
					NewGroup = Group
			end,
			NewRate = abs(TempRate);
		true ->
			if
				Group == 0 andalso LRed > LBlue ->
					NewGroup = ?KF_3V3_GROUP_RED;
				Group == 0 andalso LRed < LBlue ->
					NewGroup = ?KF_3V3_GROUP_BLUE;
				Group == 0 andalso LRed == LBlue ->
					NewGroup = 0;
				true ->
					NewGroup = Group
			end,
			NewRate = Rate
	end,
	NewSpeed = get_speed(LRed - LBlue), %%以红队为参考
	if
		NewGroup == ?KF_3V3_GROUP_RED ->  %% 红队占领
			LastSpeed = NewSpeed;
		NewGroup == 0 ->
			LastSpeed = abs(NewSpeed);
		true ->  %%蓝队占领，速度刚好相反
			LastSpeed = NewSpeed * (-1)
	end,
%%    ?MYLOG("towerProgress", "LRed ~p, LBlue ~p~n", [LRed, LBlue]),
%%    ?MYLOG("towerProgress", "~p~n", [{LastSpeed, NewRate, Now}]),
	NewEndTime = get_end_time(LastSpeed, NewRate, Now),
%%    ?MYLOG("towerProgress", "~p~n", [NewEndTime]),
	if
		NewEndTime > 0 ->  %%定时器
			Ref = util:send_after(RateRef, (NewEndTime - Now) * 1000, self(), {handle_tower_rate, TowerId});
		true ->
			Ref = [],
			util:cancel_timer(RateRef)
	end,
	NewTowerData = TowerData#tower_data{progress_rate_speed = LastSpeed, group = NewGroup, progress_rate = NewRate,
		time = Now, end_time = NewEndTime, rate_ref = Ref},
	%%广播
	send_to_all_tower_msg(NewTowerData, SceneId, PoolId, RoomId),
	NewTowerData.

change_group(Group) ->
	case Group of
		?KF_3V3_GROUP_RED ->
			?KF_3V3_GROUP_BLUE;
		_ ->
			?KF_3V3_GROUP_RED
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述 获取结束时间
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_end_time(0, _Rate, _Now) ->
	0;
get_end_time(Speed, 100, _Now) when Speed > 0 -> %%正向增长,但是进度已经100了
	0;
get_end_time(Speed, Rate, Now) when Speed > 0 -> %%正向增长,但是进度小于100
	util:ceil((100 - Rate) / Speed) + Now;
get_end_time(Speed, Rate, Now) when Speed < 0 -> %%负向增长, 要减到反方向的多12%
	Time = util:ceil(abs((Rate + 12) / Speed)),
%%    ?MYLOG("3v32", "Time ~p~n", [Time]),
	Time + Now.

%%房间广播祭坛信息
send_to_all_tower_msg(TowerData, SceneId, PoolId, RoomId) ->
	#tower_data{progress_rate_speed = Speed, group = Group, progress_rate = Rate,
		time = _StartTime, end_time = EndTime, mon_id = TowerId} = TowerData,
%%    ?MYLOG("3v32", "Now ~p~n", [utime:unixtime()]),
	?MYLOG("3v32", "send_to_all_tower_msg ~n ~p~n", [{TowerId, Group, ?IF(Speed > 0, 1, 0), EndTime, Rate}]),
	{ok, Bin} = pt_650:write(65044, [TowerId, Group, ?IF(Speed > 0, 1, 0), EndTime, Rate]),
	lib_server_send:send_to_scene(SceneId, PoolId, RoomId, Bin).


%%%%房间广播玩家信息， 在玩家信息有改变的情况下
%%send_pk_role_list_msg_to_client(RoleList, Scene, PoolId, CopyId) ->
%%    Msg = send_pk_role_list_msg_to_client_help(RoleList),
%%    ?MYLOG("3v3", "Msg ~p~n", [Msg]),
%%    {ok, Bin} = pt_650:write(65043, [Msg]),
%%    lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述  发送战场中的玩家信息给客户端
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_pk_role_list_msg_to_client(RoleId, Node, RoleList) ->
	Msg = send_pk_role_list_msg_to_client_help(RoleList),
	?MYLOG("3v3pk", "Msg ~p~n", [Msg]),
	{ok, Bin} = pt_650:write(65043, [Msg]),
	lib_server_send:send_to_uid(Node, RoleId, Bin).

send_pk_role_list_msg_to_client_help(RoleList) ->
	send_pk_role_list_msg_to_client_help(RoleList, []).


send_pk_role_list_msg_to_client_help([], AccList) ->
	AccList;
send_pk_role_list_msg_to_client_help([H | RoleList], AccList) ->
	#role_score{group = TeamGroup, server_name = ServerName, server_num = ServerNum, role_id = RoleId, figure = F, power = Power, assist = Assist
		, kill = KillCount, continuous_kill_count = ContinuousKillCount, killed = Killed} = H,
	#figure{name = RoleName, career = Career, sex = Sex, lv = Lv, turn = Turn} = F,
	NewList = [{TeamGroup, ServerName, ServerNum, RoleId, RoleName, Power, Career, Sex, Lv, Turn, KillCount, Assist, ContinuousKillCount, Killed} | AccList],
	send_pk_role_list_msg_to_client_help(RoleList, NewList).

%% -----------------------------------------------------------------
%% @desc     功能描述  获得塔的进度
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_tower_rate(TowerList) ->
	F = fun(TowerData, AccList) ->
		#tower_data{time = Time, progress_rate_speed = Speed, end_time = EndTime, mon_id = TowerId,
			progress_rate = Rate, red_role_list = RedRoleList, blue_role_list = BlueRoleList, group = Group} = TowerData,
		Now = utime:unixtime(),
		LRed = length(RedRoleList),
		LBlue = length(BlueRoleList),
		if
			Time > 0 andalso Now >= Time andalso Now =< EndTime andalso Speed =/= 0 ->  %%有占领时间且当前时间在读条时间内，且读条数据 > 0
				TempRate = min((Now - Time) * Speed + Rate, 100),
				if
					TempRate < 0 ->   %%进度变为负数， 则改变组别
						NewGroup = change_group(Group);
					true ->
						NewGroup = Group
				end,
				NewRate = abs(TempRate);
			true ->
				%%无人占领，则瞬间为人多的一方占领
				if
					Group == 0 andalso LRed > LBlue ->
						NewGroup = ?KF_3V3_GROUP_RED;
					Group == 0 andalso LRed < LBlue ->
						NewGroup = ?KF_3V3_GROUP_BLUE;
					Group == 0 andalso LRed == LBlue ->
						NewGroup = 0;
					true ->
						NewGroup = Group
				end,
				NewRate = Rate
		end,
		[{NewGroup, TowerId, NewRate} | AccList]
	    end,
	lists:foldl(F, [], TowerList).

%% -----------------------------------------------------------------
%% @desc     功能描述  获得占领进度
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_speed(0) ->
	0;
get_speed(Num) ->
	List = data_3v3:get_kv(speed),
	AbsNum = abs(Num),
	case lists:keyfind(AbsNum, 1, List) of
		{AbsNum, Speed} ->
			?IF(Num > 0, Speed, Speed * (-1));
		_ ->
			0
	end.

calc_result_new(Result, TA, TB, RoleList) ->
	#team_score{group = GroupA, tier = TierA, star = StarA, continue_win = ContinueWinA} = TA,
	#team_score{group = GroupB, tier = TierB, star = StarB, continue_win = ContinueWinB} = TB,
	F = fun(#role_score{group = TempGroup} = Role, {AccRoleA, AccRoleB}) ->
		if
			TempGroup == GroupA ->
				{[Role | AccRoleA], AccRoleB};
			true ->
				{AccRoleA, [Role | AccRoleB]}
		end
	    end,
	{RoleListA, RoleListB} = lists:foldl(F, {[], []}, RoleList), %% 分开A, B，组
	%%计算a组的奖励
	{NTierA, NStarA, RewardA, ContinuedWinA, FameA} =
		if
			Result == GroupA ->  %%A胜利了
				calc_tier_star(win, TierA, StarA, 0, ContinueWinA);
			Result == GroupB ->
				calc_tier_star(lose, TierA, StarA, 0, ContinueWinA);
			true ->  %%
				calc_tier_star(draw, TierA, StarA, 0, ContinueWinA)
		end,
	{NTierB, NStarB, RewardB, ContinuedWinB, FameB} =
		if
			Result == GroupA ->  %%B胜利了
				calc_tier_star(win, TierB, StarB, 0, ContinueWinB);
			Result == GroupB ->
				calc_tier_star(lose, TierB, StarB, 0, ContinueWinB);
			true ->  %%
				calc_tier_star(draw, TierB, StarB, 0, ContinueWinB)
		end,
	NewA = #team_score{tier = NTierA, star = NStarA, continue_win = ContinuedWinA, fame = FameA},
	NewB = #team_score{tier = NTierB, star = NStarB, continue_win = ContinuedWinB, fame = FameB},
	%%设置奖励
	NewRoleListA = [TempRoleA#role_score{reward = RewardA} || TempRoleA <- RoleListA],
	NewRoleListB = [TempRoleB#role_score{reward = RewardB} || TempRoleB <- RoleListB],
	if
		Result == GroupA ->
			{NewRoleListA, NewRoleListB, NewA, NewB};
		Result == GroupB ->
			{NewRoleListB, NewRoleListA, NewA, NewB};
		true ->
			{NewRoleListA, NewRoleListB, NewA, NewB}
	end.

calc_team_tier(TeamA, TeamB, WinGroup, MaxWorldLv, PowerList) ->
	#team_score{group = GroupA, tier = TierA, star = StarA, continue_win = ContinueWinA, team_id = TeamAId} = TeamA,
	#team_score{group = GroupB, tier = TierB, star = StarB, continue_win = ContinueWinB, team_id = TeamBId} = TeamB,
	%%计算a组的奖励
	{NTierA, NStarA, _RewardA, ContinuedWinA, FameA} =
		if
			WinGroup == GroupA ->  %%A胜利了
				calc_tier_star(win, TierA, StarA, 0, ContinueWinA);
			WinGroup == GroupB ->
				calc_tier_star(lose, TierA, StarA, 0, ContinueWinA);
			true ->  %%
				calc_tier_star(draw, TierA, StarA, 0, ContinueWinA)
		end,
	{NTierB, NStarB, _RewardB, ContinuedWinB, FameB} =
		if
			WinGroup == GroupB ->  %%B胜利了
				calc_tier_star(win, TierB, StarB, 0, ContinueWinB);
			WinGroup == GroupA ->
				calc_tier_star(lose, TierB, StarB, 0, ContinueWinB);
			true ->  %%
				calc_tier_star(draw, TierB, StarB, 0, ContinueWinB)
		end,
	NewA = TeamA#team_score{tier = NTierA, star = NStarA, continue_win = ContinuedWinA, fame = FameA},
	NewB = TeamB#team_score{tier = NTierB, star = NStarB, continue_win = ContinuedWinB, fame = FameB},
	if
		WinGroup == GroupA ->
			%%重算积分
			{LastATier, LastAPoint} = get_new_tier(win, StarA, StarB, MaxWorldLv, PowerList, TeamAId),
			{LastBTier, LastBPoint} = get_new_tier(lose, StarB, StarA, MaxWorldLv, PowerList, TeamBId),
			LastTeamA = NewA#team_score{result = ?team_win, tier = LastATier, star = LastAPoint},
			LastTeamB = NewB#team_score{result = ?team_fail, tier = LastBTier, star = LastBPoint};
		WinGroup == GroupB ->
			%%重算积分
			{LastATier, LastAPoint} = get_new_tier(lose, StarA, StarB, MaxWorldLv, PowerList, TeamAId),
			{LastBTier, LastBPoint} = get_new_tier(win, StarB, StarA, MaxWorldLv, PowerList, TeamBId),
			LastTeamA = NewA#team_score{result = ?team_fail, tier = LastATier, star = LastAPoint},
			LastTeamB = NewB#team_score{result = ?team_win, tier = LastBTier, star = LastBPoint};
		true ->
			%%重算积分
			{LastATier, LastAPoint} = get_new_tier(lose, StarA, StarB, MaxWorldLv, PowerList, TeamAId),
			{LastBTier, LastBPoint} = get_new_tier(lose, StarB, StarA, MaxWorldLv, PowerList, TeamBId),
			LastTeamA = NewA#team_score{result = ?team_draw, tier = LastATier, star = LastAPoint},
			LastTeamB = NewB#team_score{result = ?team_draw, tier = LastBTier, star = LastBPoint}
	end,
	{LastTeamA, LastTeamB, [{TeamAId, LastATier, LastAPoint}, {TeamBId, LastBTier, LastBPoint}]}.

%%获取队长id和名字
get_leader_id_and_name(Team) ->
	#kf_3v3_team_data{captain_id = Id, member_data = RoleList} = Team,
	case lists:keyfind(Id, #kf_3v3_role_data.role_id, RoleList) of
		#kf_3v3_role_data{figure = F} ->
			{Id, F#figure.name};
		_ ->
			{0, ""}
	end.


%%战斗结束后，更新数据
refresh_champion_team(Data, TeamA, TeamB) ->
	mod_3v3_champion:refresh_champion_team(Data, TeamA, TeamB).

%% 这个几个服的最大世界等级
get_max_world_lv(RoleList) ->
	F = fun(#role_score{server_id = ServerId}, MaxWorldLv) ->
		WorldLv = lib_clusters_center_api:get_world_lv(ServerId),
		if
			WorldLv > MaxWorldLv ->
				WorldLv;
			true ->
				MaxWorldLv
		end
	    end,
	lists:foldl(F, 0, RoleList).

%%返回 [{TeamId, [Power1, Power2, Power3]}] %% 没有排序
get_power_list(RoleList) ->
	F = fun(#role_score{team_id = TeamId, power = Power}, AccList) ->
		case lists:keyfind(TeamId, 1, AccList) of
			{TeamId, PowerList} ->
				lists:keystore(TeamId, 1, AccList, {TeamId, [Power | PowerList]});
			_ ->
				[{TeamId, [Power]} | AccList]
		end
	    end,
	lists:foldl(F, [], RoleList).

%% 计算新的段位积分， 根据策划给的公式计算
get_new_tier(lose, StarA, StarB, MaxWorldLv, PowerList, TeamId) ->
	get_new_tier2(?lose_k, StarA, StarB, MaxWorldLv, PowerList, TeamId);
get_new_tier(win, StarA, StarB, MaxWorldLv, PowerList, TeamId) ->
	get_new_tier2(1, StarA, StarB, MaxWorldLv, PowerList, TeamId).


%% 自己的积分+(1-1/(1+POWER(10,(对方的积分-自己的积分)/200)))*K值*MIN((战斗力第一高*0.6+战斗力第二高*0.3+战斗力第三高*0.1)/标准战力,3)
%% 第二版 自己的积分+(1-1/(1+max(POWER(10,(对方的积分-自己的积分)/200),0.6)))*K值*((战斗力第一高*0.6+战斗力第二高*0.3+战斗力第三高*0.1)/标准战力)  期待第三版
%% return {NewTier, NewStar}
get_new_tier2(KPlus, MyStar, OtherStar, MaxWorldLv, PowerList, TeamId) ->
	{OldTier, _} = lib_3v3_local:calc_tier_by_star(0, MyStar),
	case data_3v3:get_tier_info(OldTier) of
		#tier_info{k_value = KValue} ->
			case data_3v3:get_3v3_standard_power(MaxWorldLv, MyStar) of
				0 ->
					?MYLOG("3v3pk", "++++++++++++~n", []),
					{0, 0};
				StandardPower ->
					if
						KPlus < 1 ->
%%							?INFO("++++++++++++ ~p ~p~n", [KPlus, KValue]),
							AddStar = erlang:round(KPlus * KValue),
							lib_3v3_local:calc_tier_by_star(0, max(AddStar + MyStar, 0));
						true ->
							%% MIN((战斗力第一高*0.6+战斗力第二高*0.3+战斗力第三高*0.1)/标准战力,3)
							case lists:keyfind(TeamId, 1, PowerList) of
								false ->
%%									?INFO("++++++++++++ ~p ~n", [TeamId]),
%%									?INFO("++++++++++++ ~p ~n", [PowerList]),
%%									?INFO("++++++++++++ ~p ~p~n", [KPlus, KValue]),
%%									?MYLOG("3v3pk", "++++++++++++~n", []),
									{0, 0};
								{TeamId, MyPowerList} ->
%%									?INFO("++++++++++++ ~p ~p~n", [KPlus, KValue]),
									Sort = lists:reverse(lists:usort(MyPowerList)),
									Res = get_new_tier3(Sort, StandardPower),
									_AddStar = erlang:round((1 - 1 / (1 + max(math:pow(10, (OtherStar - MyStar) / 200), 0.6))) * KPlus * KValue * Res),
									AddStar = min(_AddStar, 500),
									AddStar2 = erlang:round(max(AddStar, KValue / 2)),
									lib_3v3_local:calc_tier_by_star(0, max(AddStar2 + MyStar, 0))
							end
					end
			end;
		_ ->
			?MYLOG("3v3pk", "++++++++++++~n", []),
			{0, 0}
	end.

get_new_tier3([], _StandardPower) ->
	0;
get_new_tier3([Power1], StandardPower) ->
	Power1 * 0.6 / StandardPower;
get_new_tier3([Power1, Power2], StandardPower) ->
	(Power1 * 0.6 + Power2 * 0.3) / StandardPower;
get_new_tier3([Power1, Power2, Power3 | _], StandardPower) ->
	(Power1 * 0.6 + Power2 * 0.3 + Power3 * 0.1) / StandardPower.


reset_tier(RoleList, TierList) ->
	F = fun(Role, AccList) ->
		#role_score{team_id = TeamId} = Role,
		case lists:keyfind(TeamId, 1, TierList) of
			{TeamId, Tier, Star} ->
				[Role#role_score{tier = Tier, star = Star} | AccList];
			_ ->
				[Role | AccList]
		end
	    end,
	lists:reverse(lists:foldl(F, [], RoleList)).


























