%% ---------------------------------------------------------------------------
%% @doc lib_3v3_pai.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-11-22
%% @deprecated 3v3接口
%% ---------------------------------------------------------------------------

-module(lib_3v3_api).

-compile(export_all).

-export([
	collect_mon/5
	, handle_event/2
	, is_3v3_scene/1
	, check_revive/2
	, send_to_3v3_team/2
	, get_tier/1
]).

-include("3v3.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("errcode.hrl").

%% 采集完毕
collect_mon(SceneId, ScenePoolId, CopyId, CollectorId, Mid) ->
	Is3v3Scene = is_3v3_scene(SceneId),
	case Is3v3Scene of
		true ->
			case lib_3v3_center:get_unite_role_data(CollectorId) of
				{ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) ->
					PKPid ! {collect_complete, [SceneId, ScenePoolId, CopyId, CollectorId, Mid]};
				_ -> skip
			end;
		false ->
			skip
	end.

%% 死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
	#player_status{id = DefRoleId, scene = SceneId, copy_id = RoomId, team_3v3 = Role3v3, battle_attr = BA} = Player,
	#{attersign := AtterSign, atter := Atter, hit := HitList} = Data,
	#battle_return_atter{id = AtterId} = Atter,
	case is_3v3_scene(SceneId) andalso AtterSign == ?BATTLE_SIGN_PLAYER of
		true ->
			% 助攻列表
			?MYLOG("revive", "DefRoleId  ~p group ~p~n", [DefRoleId, BA#battle_attr.group]),
			case Role3v3 of
				#role_3v3_new{is_in_champion_pk = 1, team_id = TeamId} ->
					mod_clusters_node:apply_cast(mod_3v3_champion, kill_enemy, [SceneId, RoomId, DefRoleId, AtterId, HitList, TeamId]);
				_ ->
					mod_clusters_node:apply_cast(mod_3v3_center, kill_enemy, [[SceneId, RoomId, DefRoleId, AtterId, HitList]])
			end,
			List = data_3v3:get_kv(altar_coordinate),
			[pp_3v3:handle(65042, Player, [0, TowerId]) || {TowerId, _} <- List],
			{ok, Player};
		false ->
			{ok, Player}
	end;

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
%%	lib_3v3_local:repair_tier(Player),
	%%
	#player_status{team_3v3 = Team3v3} = Player,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, role_login, [TeamId, Player#player_status.id]);
		_ ->
			sikp
	end,
%%	mod_3v3_team:role_login(TeamId, PS#player_status.id),
	{ok, Player};



%%客户端断开连接
handle_event(PS, #event_callback{type_id = LogoutEvent}) when is_record(PS, player_status) andalso
	(LogoutEvent =:= ?EVENT_DISCONNECT orelse
		LogoutEvent =:= ?EVENT_DISCONNECT_HOLD_END) ->
	#player_status{team_3v3 = Team3v3, id = RoleId, action_lock = Lock} = PS,
	IsInSingleMatch = Lock == ?ERRCODE(err650_in_kf_3v3_act_single),
%%	IsInTeamMatch = Lock == ?ERRCODE(err650_in_kf_3v3_act),
	if
		IsInSingleMatch == true ->
			pp_3v3:handle(65014, PS, [2]),
			pp_3v3:handle(65017, PS, []);
		true ->
			ok
	end,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, role_logout, [TeamId, RoleId]);
%%			mod_3v3_team:role_logout(TeamId, RoleId);
		_ ->
			ok
	end,
	{ok, PS};

%% 战力排行榜、 职业排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
	#player_status{team_3v3 = Team3v3, combat_power = Power, id = RoleId} = Player,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, update_power, [TeamId, RoleId, Power]);
%%			mod_3v3_team:update_power(TeamId, RoleId, Power);
		_ ->
			skip
	end,
	{ok, Player};


handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
	#player_status{team_3v3 = Team3v3, id = RoleId, figure = Figure} = Player,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, update_lv, [TeamId, RoleId, Figure#figure.lv]);
		_ ->
			sikp
	end,
	{ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(Player, player_status) ->
	#player_status{team_3v3 = Team3v3, id = RoleId, figure = Figure} = Player,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, update_picture,
				[TeamId, RoleId, Figure#figure.picture, Figure#figure.picture_ver]);
		_ ->
			sikp
	end,
	{ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Player, player_status) ->
	#player_status{team_3v3 = Team3v3, id = RoleId, figure = Figure} = Player,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, update_role_name,
				[TeamId, RoleId, Figure#figure.name]);
		_ ->
			sikp
	end,
	{ok, Player};





handle_event(Player, _EventCallback) ->
	{ok, Player}.

% %% 玩家死亡
% player_die(
%     #player_status{id = DefRoleId, scene = SceneID, copy_id = RoomID}, 
%     #battle_return_atter{
%         id = AttRoleId, sign = AttSign}, HitList) ->
%     Is3v3Scene = lib_3v3_api:is_3v3_scene(SceneID),
%     if
%         Is3v3Scene andalso AttSign == ?BATTLE_SIGN_PLAYER ->
%             % io:format("-------kill_enemy  000------~n"),
%             % TODO by hjh : 是否需要增加平台和平台数字
%             % by hjh 注释 KillerKey = [AttID, AttPlatform, AttServerNum],
%             AttPlatform = 0, AttServerNum = 0,
%             KillerKey = [AttRoleId, AttPlatform, AttServerNum],
%             HitKeyList = lists:keydelete(KillerKey, 1, HitList), %% 助攻列表
%             mod_clusters_node:apply_cast(mod_3v3_center, kill_enemy, [[SceneID, RoomID, DefRoleId, AttRoleId, HitKeyList]]);
%         true -> skip
%     end.

%% 是否是3v3场景
is_3v3_scene(SceneID) ->
	lists:member(SceneID, ?PK_3V3_SCENE).

%% 是否能复活
check_revive(Player, Type) ->
	#player_status{scene = SceneId, revive_status = ReviveStatus} = Player,
	Is3v3Scene = is_3v3_scene(SceneId),
	if
		Type =:= ?REVIVE_KF_3V3 ->
			if
				Is3v3Scene ->
					NowTime = utime:unixtime(),
					if
						ReviveStatus#revive_status.revive_time =< NowTime + 1 ->
							true;
						true ->
							{false, 5}
					end;
				true ->
					{false, 5}
			end;
		Is3v3Scene ->
			{false, 5};
		true ->
			true
	end.

%% 开启3v3
gm_start_3v3(LastTime, MemberLimit) ->
	mod_clusters_node:apply_cast(mod_3v3_center, gm_start_3v3, [LastTime, MemberLimit]),
	ok.

send_to_3v3_team(RoleId, BinData) ->
	mod_3v3_local:send_to_3v3_team(RoleId, BinData).

get_tier(Player) ->
	#player_status{role_3v3 = #role_3v3{tier = V}} = Player,
	V.


%% 赛季结算截止时间  半个月作为一个赛季
get_season_end_time() ->
	Now = utime:unixtime(),
	{{_Y, _M, Day}, _} = utime:unixtime_to_localtime(Now),
	{StartTime, EndTime} = utime:get_month_unixtime_range(),
	if
		Day > 15 ->  %% 属于下半月的赛季
			EndTime - ?ONE_DAY_SECONDS;
		true ->  %%属于上半月的赛季
			StartTime + 14 * ?ONE_DAY_SECONDS
	end.


%% 赛季结算截止时间
get_season_end_time(Time) ->
	{{_Y, _M, Day}, _} = utime:unixtime_to_localtime(Time),
	{StartTime, EndTime} = utime:get_month_unixtime_range(),
	if
		Day > 15 ->  %% 属于下半月的赛季
			EndTime;
		true ->  %%属于这个月的赛季
			StartTime + 14 * ?ONE_DAY_SECONDS
	end.
%%	Date = {{NewY, NewM, NewDay}, {0, 0, 0}},
%%	utime:unixtime(Date).


check_create_team(Status, _TeamName) ->
	#player_status{team_3v3 = Team3v3} = Status,
%%    Res = is_right_name(TeamName),
	#role_3v3_new{team_id = TeamId} = Team3v3,
	Cost = data_3v3:get_kv(create_team_cost),
	if
%%        Res == false ->
%%            {false, ?ERRCODE(err650_err_name)};
		TeamId > 0 ->
			{false, ?ERRCODE(err650_have_team)};
		true ->
			case lib_goods_api:check_object_list(Status, Cost) of
				true ->
					true;
				{false, Err} ->
					{false, Err}
			end
	end.


sort_team([]) ->
	[];
sort_team(TeamList) ->
	F = fun(A, B) ->
		if
			A#team_local_3v3.point >= B#team_local_3v3.point ->
				true;
			true ->
				false
		end
	    end,
	List = lists:sort(F, TeamList),
	F2 = fun(A, {Rank, AccList}) ->
		{Rank + 1, [A#team_local_3v3{rank = 0} | AccList]}
	     end,
	{_, List2} = lists:foldl(F2, {0, []}, List),
	lists:reverse(List2).


champion_start_time() ->
	SeasonTime = get_season_end_time(),
	SeasonWeekDay = utime:day_of_week(SeasonTime),
	#act_info{week = WeekInfo, time = Time} = data_3v3:get_act_info(1),
	DefaultWeekDay = hd(lists:reverse(WeekInfo)),
	%% 是否刚好是开启的时间
	IsStart = lists:member(SeasonWeekDay, WeekInfo),
	[{H, M, S}, {_, _, _}] = Time,
	if
		IsStart == true ->  %%刚好今天开启
			SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S;
		true ->
			F = fun(FunWeekDay, Res) ->
				if
					SeasonWeekDay > FunWeekDay ->
						FunWeekDay;
					true ->
						Res
				end
			    end,
			FunWeekDay1 = lists:foldl(F, DefaultWeekDay, WeekInfo),
			if
				SeasonWeekDay - FunWeekDay1 > 0 ->  %%往后减几天
					SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S - (SeasonWeekDay - FunWeekDay1) * ?ONE_DAY_SECONDS;
				true ->
					SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S - (SeasonWeekDay - FunWeekDay1 + 7) * ?ONE_DAY_SECONDS
			end
	end.


champion_start_time(Time) ->
	SeasonTime = get_season_end_time(Time),
	SeasonWeekDay = utime:day_of_week(SeasonTime),
	#act_info{week = WeekInfo, time = Time1} = data_3v3:get_act_info(1),
	DefaultWeekDay = hd(lists:reverse(WeekInfo)),
	%% 是否刚好是开启的时间
	IsStart = lists:member(SeasonWeekDay, WeekInfo),
	[{H, M, S}, {_, _, _}] = Time1,
	if
		IsStart == true ->
			SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S;
		true ->
			F = fun(FunWeekDay, Res) ->
				if
					SeasonWeekDay > FunWeekDay ->
						FunWeekDay;
					true ->
						Res
				end
			    end,
			FunWeekDay1 = lists:foldl(F, DefaultWeekDay, WeekInfo),
			if
				SeasonWeekDay - FunWeekDay1 > 0 ->  %%往后减几天
					SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S - (SeasonWeekDay - FunWeekDay1) * ?ONE_DAY_SECONDS;
				true ->
					SeasonTime + H * ?ONE_MIN * ?ONE_MIN + M * ?ONE_MIN + S - (SeasonWeekDay - FunWeekDay1 + 7) * ?ONE_DAY_SECONDS
			end
	end.

is_3v3_champion_scene(Scene) ->
	Scene == ?champion_pk_scene.

%%是否可以进行减员操作
is_can_cut_team() ->
	StartTime = champion_start_time(),
	StarTimeZero = utime:unixdate(StartTime),  %% 冠军赛的凌晨
	Now = utime:unixtime(),
	NowData = utime:unixdate(),
	#act_info{week = WeekInfo, time = Time} = data_3v3:get_act_info(1),
	DefaultWeekDay = hd(lists:reverse(WeekInfo)),  %% 下个排位赛默认比赛日
	[{_, _, _}, {EndH, EndM, EndS} | _] = Time,
	NowWeekDay = utime:day_of_week(Now), %%现在是周几
	F = fun(FunWeekDay, Res) ->
		if
			NowWeekDay =< FunWeekDay ->
				FunWeekDay;
			true ->
				Res
		end
	    end,
	FunWeekDay = lists:foldl(F, DefaultWeekDay, lists:reverse(WeekInfo)),  %% 下个排位赛的周几
%%	?PRINT("FunWeekDay ~p~n", [FunWeekDay]),
	if
		FunWeekDay == NowWeekDay andalso NowData < StarTimeZero ->  %%今天就有比赛, 且在排位赛结束之前 可以减员 排位赛后不能减员
			if
				NowData + EndH * 60 * 60 + EndM * 60 + EndS >= Now ->  %% 且在排位赛结束之前，可以减员
%%					?PRINT("FunWeekDay ~p~n", [FunWeekDay]),
					true;
				true -> %% 且在排位赛结束后之前，可以减员
%%					?PRINT("FunWeekDay ~p~n", [FunWeekDay]),
					false
			end;
		FunWeekDay == NowWeekDay andalso NowData == StarTimeZero ->  %%今天就是排位赛
			false;
		FunWeekDay == NowWeekDay andalso NowData > StarTimeZero ->  %%冠军赛后面还开了一场， 且同一个周几
			true;
		FunWeekDay > NowWeekDay ->  %%同一周
			TempTime = utime:unixdate() + (FunWeekDay - NowWeekDay) * ?ONE_DAY_SECONDS,  %% 下个排位赛的的凌晨
			if
				TempTime == StarTimeZero ->  %% 刚好冠军赛 不能减员
					false;
				TempTime < StarTimeZero -> %%下次排位赛冠军赛之前 ， 可以减员
					true;
				TempTime > StarTimeZero -> %% 已经过了冠军赛，准备下个赛季， 可以减员
					true;
				true ->  %% 容错
					false
			end;
		true ->  %%下一周
			TempTime = utime:unixdate() + (FunWeekDay - NowWeekDay + 7) * ?ONE_DAY_SECONDS,  %% 下个排位赛的的凌晨
			if
				TempTime == StarTimeZero ->  %% 刚好冠军赛 不能减员
					false;
				TempTime < StarTimeZero -> %%下次排位赛冠军赛之前 ， 可以减员
					true;
				TempTime > StarTimeZero -> %% 已经过了冠军赛，准备下个赛季， 可以减员
					true;
				true ->  %% 容错
					false
			end
	end.
%%	true.


is_time_to_clear() ->
	%% 每个月的 1 号和 16号结算
	case utime:day_of_month() of
		1 ->
			true;
		16 ->
			true;
		_ ->
			false
	end.












