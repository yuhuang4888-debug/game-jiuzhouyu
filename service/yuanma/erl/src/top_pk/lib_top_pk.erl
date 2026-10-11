%%-----------------------------------------------------------------------------
%% @Module  :       lib_top_pk.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-05
%% @Description:    巅峰竞技
%%-----------------------------------------------------------------------------

-module(lib_top_pk).
-include("top_pk.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("language.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("reincarnation.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("skill.hrl").
-include("guild.hrl").


%% 判断是否开发
-ifdef(DEV_SERVER).
-define(is_kf,  true).
-else.
-define(is_kf,  false).  %%
-endif.


%%-export([
%%	load_data/1  %% 加载数据
%%	, calc_bit_index_value/2 %% 获取一个整数某个二进制的值 段位奖励用一个整数保存领取状态
%%	, set_bit_index_1/2      %% 设置一个整数某个二进制位上的值为1
%%	, get_activity_enabled/0 %% 判断活动是否开启
%%	, set_player_match_start/2   %% 开始匹配
%%	, apply_cast/4           %% 根据当前节点，决定用不用rpc
%%	, match_break/2       %% 下线处理 从匹配队列中移除
%%	, handle_match_timeout/1 %% 匹配超时处理
%%	, create_battle/2        %% 匹配成功 创建战场 该逻辑可能在本服节点 也可能在跨服节点上
%%	, battle_field_create_done/4 %% 创建战场成功对玩家进程的处理
%%	, battle_field_close/2       %% 战场关闭
%%	, get_season_end_time/0      %% 获取赛季结束时间
%%	, calc_battle_result/3       %% 计算挑战结果
%%	, rank_sort_fun/2            %% 排行榜排序规则
%%	, gm_season_end/1            %% 根据当前段位结算赛季
%%	, daily_update/1             %% 每日更新
%%	, update_season_reward/2     %% 保存段位奖励领取状态
%%	, gm_start/1                 %% 秘籍开启
%%	, act_start/1                %% 活动开启
%%
%%]).
-compile(export_all).

load_data(#player_status{top_pk = undefined} = PS) ->
	#player_status{id = RoleId} = PS,
	SQL = io_lib:format("SELECT `season_id`, `grade_num`, `star_num`, `history_match_count`, `history_win_count`, `serial_win_count`, `season_match_count`, `season_win_count`, `season_reward_status`, `daily_honor_value` , `rank_lv`, `point`, `serial_fail_count`, `yesterday_rank_lv` FROM `top_pk_player_data` WHERE `role_id` = ~p LIMIT 1", [RoleId]),
	SeasonEndTime = get_season_end_time(),
	case db:get_row(SQL) of
		[SeasonId, GradeNum, StarNum, HistoryMatchCount, HistoryWinCount, SerialWinCount, SeasonMatchCount, SeasonWinCount, SeasonRewardStatus, DailyHonorValue, RankLv, Point, SerialFailCount, YesterdayRankLv] ->
			OPkStatus
				= #top_pk_status{
				season_id = SeasonId,
				grade_num = GradeNum,
				star_num = StarNum,
				history_match_count = HistoryMatchCount,
				history_win_count = HistoryWinCount,
				serial_win_count = SerialWinCount,
				season_match_count = SeasonMatchCount,
				season_win_count = SeasonWinCount,
				season_reward_status = SeasonRewardStatus,
				daily_honor_value = DailyHonorValue,
				season_end_time = SeasonEndTime,
				rank_lv = RankLv,
				point = Point,
				serial_fail_count = SerialFailCount
				,yesterday_rank_lv = YesterdayRankLv
			},
			CurSeasonId = get_cur_season_id(SeasonId),
			if
				SeasonId =:= CurSeasonId ->
					PKStatus = setup_daily_honor(RoleId, OPkStatus);
				true -> %%新赛季
%%					calc_season_result(PS, OPkStatus),  %%不需要发送奖励，在跨服排行榜里发
					PKStatus = new_season(RoleId, CurSeasonId, OPkStatus)
			end;
		[] ->
			PKStatus = #top_pk_status{season_id = get_cur_season_id(), season_end_time = SeasonEndTime},
			mod_daily:set_count_offline(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE, ?STATE_SETUP),
			insert_status(RoleId, PKStatus),
			PS#player_status{top_pk = PKStatus}
	end,
	PS#player_status{top_pk = PKStatus};

load_data(PS) ->
	PS.

daily_update(PS) ->
	#player_status{id = RoleId, top_pk = OPKStatus} = PS,
	#top_pk_status{
		season_id = SeasonId
	} = OPKStatus,
	CurSeasonId = get_cur_season_id(SeasonId),
	if
		SeasonId =:= CurSeasonId ->
			PKStatus = setup_daily_honor(RoleId, OPKStatus);
		true ->
			PKStatus = new_season(RoleId, CurSeasonId, OPKStatus)
	end,
	PS#player_status{top_pk = PKStatus}.

gm_season_end(PS) ->
	MakeSureLoadedPlayer = load_data(PS),
	#player_status{top_pk = PKStatus, id = RoleId} = MakeSureLoadedPlayer,
	CurSeasonId = get_cur_season_id(),
	NewPKStatus = new_season(RoleId, CurSeasonId, PKStatus),
	MakeSureLoadedPlayer#player_status{top_pk = NewPKStatus}.

gm_start(Time) ->
	mod_top_pk_match_room:gm_start(Time),
	mod_clusters_node:apply_cast(mod_top_pk_match_room, gm_start, [Time]),
	spawn(fun() ->
		timer:sleep(1 * 1000),
		lib_chat:send_TV({all}, ?MOD_TOPPK, 1, []),
		mod_top_pk_match_room:send_to_all_act_info()
	end).


act_start(Args) ->
%%	NowOpenDay = util:get_open_day(),
%%	LocalDayNum = data_top_pk:get_kv(default, local_serv_day),
	spawn(fun() ->
		timer:sleep(1 * 1000),
		lib_chat:send_TV({all}, ?MOD_TOPPK, 1, []),
		mod_top_pk_match_room:send_to_all_act_info()
	end),
	mod_top_pk_match_room:act_start(Args),
	case is_local_match() of
		true ->
			skip;
		false ->
			mod_clusters_node:apply_cast(mod_top_pk_match_room, act_start, [Args])
	end.

act_start_succ(StartTime, EndTime) ->
	lib_activitycalen_api:success_start_activity(?MOD_TOPPK),
	lib_chat:send_TV({all}, ?MOD_TOPPK, 1, []),
	OpenLv = data_top_pk:get_kv(default, open_lv),
	{ok, BinData} = pt_281:write(28107, [1, StartTime, EndTime]),
	lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData).

%%	if
%%		NowOpenDay =< LocalDayNum ->
%%			ok;
%%		true ->
%%			mod_clusters_node:apply_cast(mod_top_pk_match_room, act_start, [Args])
%%	end.

%% 每月一个赛季
get_cur_season_id() ->
	{{NowYear, NowMon, _}, _} = calendar:local_time(),
	NowYear * 12 + NowMon.

get_cur_season_id(0) ->
	get_cur_season_id();
get_cur_season_id(OldSeasonId) ->
	{_, MaxOpenDay} = data_top_pk:get_kv(local_match_day,default),
	OpenDay = util:get_open_day(),
	% 没进入跨服模式前都不会变赛季
	if
		OpenDay > MaxOpenDay ->
			get_cur_season_id();
		true ->
			OldSeasonId
	end.

get_season_end_time() ->
	{_, EndTime} = utime:get_month_unixtime_range(),
	EndTime.

new_season(RoleId, CurSeasonId, #top_pk_status{
} = OldPKStatus) ->
	SeasonEndTime = get_season_end_time(),
	NewPKStatus
		= OldPKStatus#top_pk_status{
		season_id = CurSeasonId,
		grade_num = 1,
		rank_lv = 1,
		point = 0,
		serial_fail_count = 0,
		serial_win_count = 0,
		season_match_count = 0,
		season_win_count = 0,
		season_reward_status = 0,  %%阶段奖励重置
		daily_honor_value = 0,
		yesterday_rank_lv = 1,
		season_end_time = SeasonEndTime
	},
	mod_daily:set_count_offline(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE, ?STATE_SETUP),
	update_status(RoleId, NewPKStatus),
	NewPKStatus.

calc_bit_index_value(Index, Mark) ->
	1 band (Mark bsr (Index - 1)).

set_bit_index_1(Index, Mark) ->
	(1 bsl (Index - 1)) bor Mark.

get_activity_enabled() ->
	if
		?is_kf == true-> %% 开发没有时间限制，方便测试
			true;
		true ->
			case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_TOPPK, 0) of
				{ok, _} ->
					true;
				_ ->
					false
			end
	end.


set_player_match_start(Player, Node) ->
	#player_status{action_lock = ActionLock, top_pk = PKStatus, id = RoleId} = Player,
	Lock = ?ERRCODE(err281_on_matching_state),
	if
		ActionLock =:= free ->
			lib_player_event:add_listener(?EVENT_DISCONNECT, ?MODULE, match_break, []),
			lib_player_event:add_listener(?EVENT_PLAYER_DIE, ?MODULE, match_break, []),
			{ok, lib_player:setup_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = {match, Node}}}, Lock)};
		true ->
			if
				ActionLock =:= Lock ->
					{ok, Player};
				true ->
					MyNode = mod_disperse:get_clusters_node(),
					apply_cast(Node, mod_top_pk_match_room, cancel_match, [MyNode, RoleId]),
					{ok, Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = []}}}
			end
	end.
%% 监听事件，匹配断开
match_break(Player, #event_callback{type_id = Type}) when is_record(Player, player_status), Type =:= ?EVENT_DISCONNECT orelse Type =:= ?EVENT_PLAYER_DIE ->
	PKStatus = Player#player_status.top_pk,
	case PKStatus of
		#top_pk_status{pk_state = {match, Node}} ->
			lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, match_break),
			lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, match_break),
			MyNode = mod_disperse:get_clusters_node(),
			apply_cast(Node, mod_top_pk_match_room, cancel_match, [MyNode, Player#player_status.id]),
			{ok, lib_player:break_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = []}}, ?ERRCODE(err281_on_matching_state))};
		_ ->
			{ok, Player}
	end;
match_break(Player, _) ->
	{ok, Player}.

handle_match_timeout(#player_status{top_pk = TopPK} = Player, #match_info{match_step = Step}) ->
	DelayTime = lib_top_pk:get_fake_man_delay_time(),
	if
		Step == 0->
%%			?MYLOG("cym", "delay ~p ~n", [DelayTime]),
			Ref = util:send_after(TopPK#top_pk_status.ref, DelayTime * 1000, self(), {'mod', lib_top_pk, handle_match_timeout, []}),
%%			spawn(fun() ->
%%				timer:sleep(DelayTime * 1000),
%%				?MYLOG("cym", "delay ~p ~n", [DelayTime]),
%%				lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE,
%%					lib_top_pk, handle_match_timeout, [])
%%			end),
			NewTopPk = TopPK#top_pk_status{ref = Ref},
			{ok, Player#player_status{top_pk = NewTopPk}};
		true ->
			handle_match_timeout(Player)
	end.


handle_match_timeout(Player) ->
	lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, match_break),
	lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, match_break),
	#player_status{top_pk = PKStatus, sid = Sid} = Player,
	case get_activity_enabled() of  %%
		true ->
%%            MyNode = mod_disperse:get_clusters_node(),
%%            Key1 = {MyNode, RoleId},
%%            mod_top_pk_rank:choose_a_fake_man_and_battle(Key1, GradeNum, RankLv, Player#player_status.combat_power), 不去管理进程创建，直接在玩家进程创建
%%			?MYLOG("cym", "create_fake_battle+++++++++++ ~n", []),
			create_fake_battle(Player),
			{ok, Player};
		_ ->
			{ok, BinData} = pt_281:write(28111, [?FAIL, 0, 0, 0]),
			lib_server_send:send_to_sid(Sid, BinData),
			{ok, lib_player:break_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = []}}, ?ERRCODE(err281_on_matching_state))}
	end.

create_battle({Key1, RankMsg1} = Args1, {Key2, RankMsg2} = Args2) ->
	BattleNode = node(),
	{Node1, RoleId1} = Key1, {Node2, RoleId2} = Key2,
	case catch mod_battle_field:start(lib_top_pk_battle, [Args1, Args2]) of
		BattlePid when is_pid(BattlePid) ->
			send_to_client_match_msg(Node1, RoleId1, ?SUCCESS, RankMsg1, RankMsg2),
			send_to_client_match_msg(Node2, RoleId2, ?SUCCESS, RankMsg2, RankMsg1),
			apply_cast(Node1, lib_player, apply_cast, [RoleId1, ?APPLY_CAST_STATUS, ?MODULE, battle_field_create_done, [BattleNode, BattlePid, Key1]]),
			apply_cast(Node2, lib_player, apply_cast, [RoleId2, ?APPLY_CAST_STATUS, ?MODULE, battle_field_create_done, [BattleNode, BattlePid, Key2]]);
		_ ->
			send_to_client_match_msg(Node1, RoleId1, ?FAIL, RankMsg1, RankMsg2),
			apply_cast(Node1, lib_player, apply_cast, [RoleId1, ?APPLY_CAST_STATUS, ?MODULE, battle_field_close, [init_error]]),
			apply_cast(Node2, lib_player, apply_cast, [RoleId2, ?APPLY_CAST_STATUS, ?MODULE, battle_field_close, [init_error]])
	end.

battle_field_create_done(Player0, BattleNode, BattlePid, RoleKey) ->
	lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, match_break),
	lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, match_break),
	Player = lib_player:break_action_lock(Player0, ?ERRCODE(err281_on_matching_state)),
	#player_status{
		top_pk = PKStatus,
		% id = RoleId,
		scene = OSceneId,
		scene_pool_id = OPoolId,
		copy_id = OCopyId,
		x = X,
		y = Y,
		battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}
	} = Player,
	Lock = ?ERRCODE(err281_on_battle_state),
	Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim],
	apply_cast(BattleNode, mod_battle_field, player_enter, [BattlePid, RoleKey, Args]),
	NewPlayer = lib_player:setup_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = {battle, BattleNode, BattlePid}}}, Lock),
	{ok, NewPlayer}.

battle_field_close(Player, Resaon) ->
	lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, match_break),
	lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, match_break),
	#player_status{sid = Sid} = Player,
	case Resaon of
		init_error ->
			{ok, BinData} = pt_281:write(28111, [?FAIL, 0, 0, 0]),
			lib_server_send:send_to_sid(Sid, BinData),
			TmpPlayer = Player;
		_ ->
			TmpPlayer = Player
	end,
	{ok, lib_player:break_action_lock(TmpPlayer, ?ERRCODE(err281_on_matching_state))}.

calc_battle_result(RoleId, Res, OtherData) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, calc_battle_result, [Res, OtherData]);

%%玩家进程战斗结算
calc_battle_result(Player, Res, [OtherData, QuitTime]) when is_record(Player, player_status) ->
%%	?MYLOG("cym", "calc_battle_result++++++++++ res ~p~n", [Res]),
	MakeSureLoadedPlayer = load_data(Player),
	#player_status{id = RoleId, top_pk = #top_pk_status{rank_lv = RankLv0, point = Point0, grade_num = GradeNum1} = PKStatus,
		figure = #figure{name = RoleName, career = Career}, platform = Platform, server_num = Server, hightest_combat_power = Power,
		guild = #status_guild{name = GuildName}, server_id = ServerId} = MakeSureLoadedPlayer,
	{NewPKStatus, AddHonor, AddPoint} = calc_grade_with_res(PKStatus, Res, OtherData, Player#player_status.id),
	#top_pk_status{rank_lv = RankLv1, point = Point1, season_match_count = SeasonMatchCount} = NewPKStatus,
%%	?MYLOG("cym", "newPkStatus ~p~n", [NewPKStatus]),
	send_battle_reward(Player, Res, NewPKStatus, AddPoint, AddHonor),
	update_status(RoleId, NewPKStatus),
	NewPlayer1 = MakeSureLoadedPlayer#player_status{top_pk = NewPKStatus},
	mod_daily:increment_offline(RoleId, ?MOD_TOPPK, ?DAILY_ID_ENTER_COUNT), %%每日进入次数计数器
	%%日常
	lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_TOPPK, 0),
    % 事件触发
    CallbackData = #callback_join_act{type = ?MOD_TOPPK},
    {ok, NewPlayer2} = lib_player_event:dispatch(NewPlayer1, ?EVENT_JOIN_ACT, CallbackData),
	case OtherData of
		[OtherRoleId, OtherPlatform, OtherServ, OtherRoleName, _GradeNum1, _RankLv, _Point] ->
			IsFake = 0;
		_ ->
			IsFake = 1, OtherRoleId = 0, OtherPlatform = "", OtherServ = 0, OtherRoleName = ""
	end,
	lib_log_api:log_top_pk(RoleId, OtherRoleId, OtherRoleName, IsFake, OtherPlatform, OtherServ, Res, RankLv0, Point0, RankLv1, Point1),
	RankRole = #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, platform = Platform, server_id = ServerId,
		server = Server, grade_num = GradeNum1, star_num = 0, guild_name = GuildName, rank_lv = NewPKStatus#top_pk_status.rank_lv, point = NewPKStatus#top_pk_status.point, match_count = SeasonMatchCount},
	%%  更新榜单
	MyNode = mod_disperse:get_clusters_node(),
	case is_local_match() of
		true ->
			mod_top_pk_rank:update(RankRole);
		_ ->
			mod_clusters_node:apply_cast(mod_top_pk_rank_kf, update, [RankRole, MyNode])
	end,
%%	mod_top_pk_rank:update(RankRole),
	NewPlayer
		= if
		Res =:= ?top_rank_res_win ->
			%%成就
			{ok, TmpPlayer} = lib_achievement_api:top_pk_win_event(NewPlayer2, NewPKStatus#top_pk_status.grade_num),
			TmpPlayer;
		true ->
			NewPlayer2
	end,
	%%发送阶段时间
	send_stage_time(RoleId, ?top_pk_stage_quit, QuitTime), %%3是退出阶段
	{ok, NewPlayer}.
%%根据结果更新玩家状态
calc_grade_with_res(PKStatus, Res, OtherData, RoleId) ->
	#top_pk_status{
		grade_num = GradeNum,
		rank_lv = MyRankLv,
		point = OldPoint,
		history_match_count = HistoryMatchCount,
		history_win_count = HistoryWinCount,
		serial_win_count = SerialWinCount,
		season_match_count = SeasonMatchCount,
		season_win_count = SeasonWinCount,
		serial_fail_count = SerialFailCount
	} = PKStatus,
	RankDiff = get_enemy_rank_lv_diff(OtherData, GradeNum, MyRankLv),
	{NewGradeNum, NewRankLv, NewPoint, Honor, AddPoint} = calc_rank_with_res_and_diff_rank(GradeNum, MyRankLv, OldPoint, RankDiff, Res),
%%	?MYLOG("cym", "NewGradeNum, NewRankLv, NewPoint, Honor ~p~n", [{NewGradeNum, NewRankLv, NewPoint, Honor}]),
	if
		Res =:= ?top_rank_res_win ->
			NewHistoryWinCount = HistoryWinCount + 1,
			NewSerialWinCount = SerialWinCount + 1,
			NewSerialFailCount = 0,
			NewSeasonWinCount = SeasonWinCount + 1;
		true ->
			NewSerialFailCount = SerialFailCount + 1,
			NewHistoryWinCount = HistoryWinCount,
			NewSerialWinCount = 0,
			NewSeasonWinCount = SeasonWinCount
	end,
	%% 发送竞技场荣誉
	send_top_honor(RoleId, Honor),
	%%
	{PKStatus#top_pk_status{
		grade_num = NewGradeNum,
		rank_lv = NewRankLv,
		point = NewPoint,
		history_match_count = HistoryMatchCount + 1,
		history_win_count = NewHistoryWinCount,
		serial_win_count = NewSerialWinCount,
		serial_fail_count = NewSerialFailCount,
		season_match_count = SeasonMatchCount + 1,
		season_win_count = NewSeasonWinCount
	}, Honor, AddPoint}.


apply_cast(Node, Mod, Fun, Args) ->
	if
		Node =:= node() ->
			erlang:apply(Mod, Fun, Args);
		true ->
			rpc:cast(Node, Mod, Fun, Args)
	end.

rank_sort_fun(#rank_role{rank_lv = RankLv1, point = Point1}, #rank_role{rank_lv = RankLv2, point = Point2}) ->
	if
		RankLv1 =/= RankLv2 ->
			RankLv1 >= RankLv2;
		true ->
			Point1 >= Point2
	end.

setup_daily_honor(RoleId, #top_pk_status{} = PKStatus) ->
	case mod_daily:get_count_offline(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE) of
		?STATE_NONE ->
			mod_daily:set_count_offline(RoleId, ?MOD_TOPPK, ?DAILY_ID_REWARD_STATE, ?STATE_SETUP),
%%			case data_top_pk:get_grade_detail(GradeNum, StarNum) of
%%				#base_top_pk_grade_detail{honor_value = HonorValue} ->
%%					ok;
%%				_ ->
%%					HonorValue = 0
%%			end,
%%			SQL = io_lib:format("UPDATE `top_pk_player_data` SET `daily_honor_value` = ~p WHERE `role_id` = ~p", [HonorValue, RoleId]),
%%			db:execute(SQL),
			PKStatus;
		_ ->
			PKStatus
	end.

update_status(RoleId, #top_pk_status{
	season_id = SeasonId,
	grade_num = GradeNum,
	star_num = StarNum,
	rank_lv = RankLv,
	point = Point,
	history_match_count = HistoryMatchCount,
	history_win_count = HistoryWinCount,
	serial_win_count = SerialWinCount,
	serial_fail_count = SerialFailCount,
	season_match_count = SeasonMatchCount,
	season_win_count = SeasonWinCount,
	season_reward_status = SeasonRewardStatus,
	yesterday_rank_lv = YesterdayRankLv,
	daily_honor_value = DailyHonorValue
}) ->
	SQL = io_lib:format("UPDATE `top_pk_player_data` SET `season_id` = ~p, `grade_num` = ~p, `star_num` = ~p, `history_match_count` = ~p, `history_win_count` = ~p, `serial_win_count` = ~p, `season_match_count` = ~p, `season_win_count` = ~p,
	`season_reward_status` = ~p, `daily_honor_value` = ~p, `rank_lv` = ~p, `point` = ~p, `serial_fail_count` = ~p , `yesterday_rank_lv` = ~p  WHERE `role_id` = ~p",
		[SeasonId, GradeNum, StarNum, HistoryMatchCount, HistoryWinCount, SerialWinCount, SeasonMatchCount, SeasonWinCount, SeasonRewardStatus, DailyHonorValue, RankLv, Point, SerialFailCount, YesterdayRankLv, RoleId]),
	db:execute(SQL).

insert_status(RoleId, #top_pk_status{
	season_id = SeasonId,
	grade_num = GradeNum,
	star_num = StarNum,
	history_match_count = HistoryMatchCount,
	history_win_count = HistoryWinCount,
	serial_win_count = SerialWinCount,
	season_match_count = SeasonMatchCount,
	season_win_count = SeasonWinCount,
	season_reward_status = SeasonRewardStatus,
	daily_honor_value = DailyHonorValue,
	rank_lv = RankLv,
	yesterday_rank_lv = YesterdayRankLv,
	point = Point,
	serial_fail_count = SerialFailCount
}) ->
	SQL = io_lib:format("INSERT INTO `top_pk_player_data` (`role_id`, `season_id`, `grade_num`, `star_num`, `history_match_count`, `history_win_count`, `serial_win_count`, `season_match_count`, `season_win_count`, `season_reward_status`, `daily_honor_value`, `rank_lv`, `Point`, `serial_fail_count`, `yesterday_rank_lv`) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)",
		[RoleId, SeasonId, GradeNum, StarNum, HistoryMatchCount, HistoryWinCount, SerialWinCount,
			SeasonMatchCount, SeasonWinCount, SeasonRewardStatus, DailyHonorValue, RankLv, Point, SerialFailCount, YesterdayRankLv]),
	db:execute(SQL).

update_season_reward(RoleId, SeasonRewardStatus) ->
	SQL = io_lib:format("UPDATE `top_pk_player_data` SET `season_reward_status` = ~p WHERE `role_id`= ~p", [SeasonRewardStatus, RoleId]),
	db:execute(SQL).





create_fake_battle(Ps) ->
	#player_status{figure = Figure, battle_attr = BattleAttr, quickbar = _QuickBar, id = RoleId, top_pk = TopPk, sid = _Sid} = Ps,
	#top_pk_status{grade_num = GradeNum, rank_lv = RankLv, point = RankPoint} = TopPk,
	FakeMamBattleAttr = get_fake_man_attr(BattleAttr),
	FakeManFigure = get_fake_man_figure(Figure),
	MyNode = mod_disperse:get_clusters_node(),
	RoleKey = {MyNode, RoleId},
	spawn(fun
		() ->
			FakeRankMsg = random_fake_rank(GradeNum),
			{_GradeNum, _RankLv, _RankPoint} = FakeRankMsg,
			FakeManData = [FakeManFigure, FakeMamBattleAttr,
				data_skill:get_ids(FakeManFigure#figure.career, FakeManFigure#figure.sex), _GradeNum, _RankLv, _RankPoint],
			BattleNode = node(),
%%			?MYLOG("cym", "mod_battle_field:start++++++ ~n", []),
			case catch mod_battle_field:start(lib_top_pk_battle, [RoleKey, fake_man, FakeManData]) of
				BattlePid when is_pid(BattlePid) ->
%%					?MYLOG("cym", "mod_battle_field:start++++++ ~n", []),
					send_to_client_match_msg(node(), RoleId, ?SUCCESS, {GradeNum, RankLv, RankPoint}, FakeRankMsg, FakeMamBattleAttr),
					lib_top_pk:apply_cast(MyNode, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_top_pk, battle_field_create_done, [BattleNode, BattlePid, RoleKey]]);
				_ ->
					lib_top_pk:apply_cast(MyNode, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_top_pk, battle_field_close, [init_error]])
			end
	end).

get_fake_man_attr(#battle_attr{attr = Attr}) ->
	Ratio = hd(ulists:list_shuffle(lists:seq(85, 90))) / 100, %% 在 85 - 90中随机
	#attr{att = Att, hp = Hp, wreck = Wreck, def = Def, hit = Hit, dodge = Dodge, crit = Crit, ten = Ten} = Attr,

	RobotAttr = #attr{att = trunc(Att * Ratio), hp = trunc(Hp * Ratio), wreck = trunc(Wreck * Ratio), def = trunc(Def * Ratio), hit = trunc(Hit * Ratio),
		dodge = trunc(Dodge * Ratio), crit = trunc(Crit * Ratio), ten = trunc(Ten * Ratio)},
	#battle_attr{hp = RobotAttr#attr.hp, hp_lim = RobotAttr#attr.hp, speed = ?SPEED_VALUE, attr = RobotAttr}.

get_fake_man_figure(#figure{lv = OldLv}) ->
	{Career, Sex} = lib_career:rand_career_and_sex(),
	Turn = urand:list_rand(lists:seq(0, ?MAX_TURN)),                %%随机转生
	_Lv = max(OldLv - hd(ulists:list_shuffle(lists:seq(1, 5))), 1), %%随机 - 1~5
	Lv  = max(_Lv, ?top_pk_fake_man_min_lv),
	LvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),  %%等级模型
	Name = case data_jjc:get_robot_name_list() of
		[] ->
			utext:get(182); %%"守卫";
		NameList ->
			urand:list_rand(NameList)
	end,
	MountFigure = get_fake_mount_figure(Career),
	%%称号
	RDesignationList = data_top_pk:get_kv(designation_list, global),
	Designation = ?IF(RDesignationList == [], 0, urand:list_rand(RDesignationList)),
	%%时装
	FashionFigure = get_fake_fashion_figure(Career),
	Figure = #figure{name = Name, sex = Sex, turn = Turn, career = Career, lv = Lv, lv_model = LvModel, fashion_model = FashionFigure,
		mount_figure = MountFigure, designation = Designation},
	Figure.
%%坐骑外形
get_fake_mount_figure(Career) ->
	RMount = data_top_pk:get_kv(mount_list, global),       %%坐骑
	RFly = data_top_pk:get_kv(fly_list, global),         %%翅膀
	RHolyorgan = data_top_pk:get_kv(holyorgan_list, global),        %%神兵
	MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount), 0}]),
	FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly), 0}]),
	HolyorganKv = case lists:keyfind(Career, 1, RHolyorgan) of
		{_, HolyorganL} when HolyorganL =/= [] ->
			[{?HOLYORGAN_ID, urand:list_rand(HolyorganL), 0}];
		_ ->
			[]
	end,
	MountKv ++ FlyKv ++ HolyorganKv.
%%时装外形
get_fake_fashion_figure(Career) ->
	RFashion = data_top_pk:get_kv(fashion_list, global),
	case lists:keyfind(Career, 1, RFashion) of
		{_, RFashionList} when RFashionList =/= [] ->
			FashionId = urand:list_rand(RFashionList),
			[{1, FashionId, 0}];  %%1是衣服， 只是给衣服；颜色置0
		_ ->
			[]
	end.

send_to_client_match_msg(Node1, RoleId1, Res, RankMsg1, RankMsg2) ->
	send_to_client_match_msg(Node1, RoleId1, Res, RankMsg1, RankMsg2, []).

%%  发送匹配信息给玩家
send_to_client_match_msg(Node, RoleId, Res, {_GradeNum, RankLv1, _RankPoint}, {_GradeNum2, RankLv2, _RankPoint2}, FakeManBattleAttr) ->
	FakeManPower = get_fake_man_power(FakeManBattleAttr),
%%	?MYLOG("cym", "send match msg ~p~n", [{RankLv1, RankLv2, FakeManPower}]),
	case Res of
		0 ->  %% 失败
			{ok, BinData} = pt_281:write(28111, [?FAIL, 0, 0, 0]);
		1 ->  %% 成功
			{ok, BinData} = pt_281:write(28111, [?SUCCESS, RankLv1, RankLv2, FakeManPower])
	end,
	lib_server_send:send_to_uid(Node, RoleId, BinData);
send_to_client_match_msg(Node, RoleId, Res, [_, _, _, _GradeNum1, RankLv1, _Point1], [_, _, _, _GradeNum2, RankLv2, _Point2], _FakeMamBattleAttr) ->
%%	?MYLOG("cym", "send match msg ~p~n", [{RankLv1, RankLv2}]),
	case Res of
		0 ->  %% 失败
			{ok, BinData} = pt_281:write(28111, [?FAIL, 0, 0, 0]);
		1 ->  %% 成功
			{ok, BinData} = pt_281:write(28111, [?SUCCESS, RankLv1, RankLv2, 0])
	end,
	lib_server_send:send_to_uid(Node, RoleId, BinData).


%%假人段位
random_fake_rank(GradeNum) ->
	case data_top_pk:get_small_rank_by_big_rank(GradeNum) of
		[RankLv | _] ->
			{GradeNum, RankLv, 0};
		_ ->
			{GradeNum, 1, 0}
	end.

%% 段位差距
get_enemy_rank_lv_diff([], GradeNum, MyRankLv) ->
	case data_top_pk:get_small_rank_by_big_rank(GradeNum) of
		[_RankLv | _] ->
			get_enemy_rank_lv_diff_help(_RankLv, MyRankLv);
		_ ->
			0
	end;
get_enemy_rank_lv_diff([_RoleId, _Platform, _Serv, _RoleName, _GradeNum1, EnemyRankLv, _Point], _MyGradeNum, MyRankLv) ->
	get_enemy_rank_lv_diff_help(EnemyRankLv, MyRankLv).

%%阶位差=对手阶位-玩家阶位，当阶位差>4时，取4，阶位差<-4时，取-4
get_enemy_rank_lv_diff_help(EnemyRankLv, MyRankLv) ->
	Diff = EnemyRankLv - MyRankLv,
	if
		Diff >= 4 ->
			4;
		Diff =< -4 ->
			-4;
		true ->
			Diff
	end.


%%荣耀奖励：每场比赛根据玩家胜负以及段位给予荣耀
calc_rank_with_res_and_diff_rank(GradeNum, MyRankLv, OldPoint, _RankDiff, Res) ->
	case data_top_pk:get_battle_reward(MyRankLv) of
		[{BaseWinPoint, BaseFailPoint, WinHonor, FailHonor}] ->
%%			AddPoint = get_battle_add_point_with_res(BaseWinPoint, BaseFailPoint, RankDiff, Res),  %%所得积分
			%%改为直接读取积分
			AddPoint = ?IF(Res == ?top_rank_res_win, BaseWinPoint, BaseFailPoint),
			{NewGradeNum, NewRankLv, NewPoint} = add_rank_point(GradeNum, MyRankLv, max(OldPoint + AddPoint, 0)),
			{NewGradeNum, NewRankLv, NewPoint, ?IF(Res == ?top_rank_res_win, WinHonor, FailHonor), AddPoint};
		_ ->
			{GradeNum, MyRankLv, OldPoint, 0, 0}
	end.

get_need_point(MyRankLv) ->
	case data_top_pk:get_rank_reward(MyRankLv) of
		#base_top_pk_rank_reward{point = NeedPoint} ->
			NeedPoint;
		_ ->
			0
	end.

add_rank_point(GradeNum, MyRankLv, Point) ->
	NeedPoint = get_need_point(MyRankLv),
	if
		Point >= NeedPoint ->
			case data_top_pk:get_rank_reward(MyRankLv + 1) of
				#base_top_pk_rank_reward{big_rank = NewGradeNum} ->
					{NewGradeNum, MyRankLv + 1, Point - NeedPoint};
				_ ->
					{GradeNum, MyRankLv, Point}
			end;
		true ->
			{GradeNum, MyRankLv, Point}
	end.


%%胜利获得积分=基础胜利积分+INT（（阶位差/4）×（胜利基础积分-失败基础积分）*0.6）
%%失败获得积分=基础失败积分+INT（（阶位差/4）×（胜利基础积分-失败基础积分）*0.2）
get_battle_add_point_with_res(BaseWinPoint, BaseFailPoint, RankDiff, ?top_rank_res_win) ->
	erlang:round(BaseWinPoint + (RankDiff / 4) * (BaseWinPoint - BaseFailPoint) * 0.6);
get_battle_add_point_with_res(BaseWinPoint, BaseFailPoint, RankDiff, ?top_rank_res_fail) ->
	erlang:round(BaseFailPoint + (RankDiff / 4) * (BaseWinPoint - BaseFailPoint) * 0.2).

send_top_honor(RoleId, HonorNum) ->
	Produce = #produce{reward = [{?TYPE_CURRENCY, ?GOODS_ID_TOP_HONOR, HonorNum}], type = top_pk_battle_honor},
	lib_goods_api:send_reward_with_mail(RoleId, Produce).

%%战斗结果推送
send_battle_reward(#player_status{id = RoleId, top_pk = PkStatus}, Res, NewPKStatus, AddPoint, AddHonor) ->
	#top_pk_status{rank_lv = RankLv1, point = OldPoint} = PkStatus,
	#top_pk_status{rank_lv = RankLv2, point = NewPoint} = NewPKStatus,
	{Flag, AbsPoint} = get_send_to_client_point(AddPoint),
	%% 28113 结算信息
	{ok, Bin1} = pt_281:write(28113, [Res, AddHonor, Flag, AbsPoint]),
	lib_server_send:send_to_uid(RoleId, Bin1),
	%%28117 段位提升
	if
		RankLv2 > RankLv1 ->
			{ok, Bin2} = pt_281:write(28117, [RankLv1, OldPoint, RankLv2, NewPoint]),
			lib_server_send:send_to_uid(RoleId, Bin2);
		true ->
			ok
	end.

%% 获得匹配参与次数奖励列表状态 [{次数， 状态}] 0已领取，1未达成 2可领取
get_match_reward_count_list(CountRewardState, EnterCount) ->
	RewardCountList = data_top_pk:get_reward_counts(),
	DailyRewardGotCounts = lists:foldl(fun
		(C, Acc) ->
			if
				EnterCount >= C ->  %%可以领取， 或则已经领取
					case lib_top_pk:calc_bit_index_value(C, CountRewardState) of
						1 -> %% 已经领取
							[{C, 0} | Acc];
						_ -> %% 可领取
							[{C, 2} | Acc]
					end;
				true ->
					[{C, 1} | Acc]
			end
	end, [], RewardCountList),
	DailyRewardGotCounts.

%%获取每日奖励
get_daily_reward(RankLv) ->
	IsLocal = is_local_match(),
	case data_top_pk:get_rank_reward(RankLv) of
		#base_top_pk_rank_reward{day_reward = DayReward} when IsLocal == false ->
			DayReward;
		#base_top_pk_rank_reward{local_day_reward = DayReward} ->
			DayReward;
		_ ->
			[]
	end.
%% 购买次数限制
get_match_buy_count_limit() ->
	case data_top_pk:get_kv(default, buy_count) of
		undefined ->
			ok;
		Count ->
			Count
	end.

%%获得赛季奖励列表状态  // 状态 0已领取 1未达成 2可领取
get_season_reward_list_by_season_reward_status(SeasonRewardStatus, MyRankLv) ->
	RankLvList = data_top_pk:get_rank_by_is_stage_reward(1),
	List = lists:foldl(fun
		(RankLv, Acc) ->
			case lib_top_pk:calc_bit_index_value(RankLv, SeasonRewardStatus) of
				1 ->
					[{RankLv, 0} | Acc];
				_ ->
					if
						MyRankLv >= RankLv ->
							[{RankLv, 2} | Acc];
						true ->
							[{RankLv, 1} | Acc]
					end
			end
	end, [], RankLvList),
	lists:reverse(List).

gm_set_rank_lv(Ps, RankLv) ->
	#player_status{top_pk = _TopPk, id = RoleId} = Ps,
	TopPk =
		if
			_TopPk == undefined ->
				new_season(RoleId, get_cur_season_id(), #top_pk_status{});
			true ->
				_TopPk
		end,
	GradeNum = get_grade_num_by_rank_lv(RankLv),
	NewTopPk = TopPk#top_pk_status{rank_lv = RankLv, grade_num = GradeNum},
	update_status(RoleId, NewTopPk),
	Ps#player_status{top_pk = NewTopPk}.

get_grade_num_by_rank_lv(RankLv) ->
	case data_top_pk:get_rank_reward(RankLv) of
		#base_top_pk_rank_reward{big_rank = GradeNum} ->
			GradeNum;
		_ ->
			1
	end.


send_stage_time(RoleId, Stage, Time) ->
	%%发送阶段，和结束时间
	{ok, BinData1} = pt_281:write(28112, [Stage, Time]),
	lib_server_send:send_to_uid(RoleId, BinData1).

get_fake_man_delay_time() ->
	case data_top_pk:get_kv(fake_man_battle_delay_time, default) of
		undefined ->
			0;
		Time ->
			Time
	end.

get_fake_man_power(#battle_attr{attr = Attr}) ->
	lib_player:calc_all_power(Attr);
get_fake_man_power(_) ->
	0.

%% 更新昨天段位等级
update_yesterday_rank_lv() ->
	%%
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_top_pk, update_yesterday_rank_lv, []) ||RoleId <- IdList],
	Sql = io_lib:format("UPDATE  top_pk_player_data  SET yesterday_rank_lv = rank_lv  where   yesterday_rank_lv <>  rank_lv", []),
	db:execute(Sql).

update_yesterday_rank_lv(PS) ->
	#player_status{top_pk = TopPk, id = RoleId} = PS,
	case TopPk of
		#top_pk_status{rank_lv = RankLv} ->
			NewTopPk = TopPk#top_pk_status{yesterday_rank_lv = RankLv},
			update_status(RoleId, NewTopPk),
			PS#player_status{top_pk = NewTopPk};
		_ ->
			PS
	end.


is_in_top_pk_scene(#player_status{scene = Scene}) ->
	LocalScene = data_top_pk:get_kv(battle_scene_local, local),
	KfScene    = data_top_pk:get_kv(battle_scene, global),
	if
		Scene == LocalScene ->
			true;
		Scene == KfScene ->
			true;
		true ->
			false
	end.

get_send_to_client_point(AddPoint) ->
	if
		AddPoint >= 0 ->
			{1, AddPoint};
		true ->
			{0, abs(AddPoint)}
	end.

is_not_lv_limit_cmd(CMD) ->
	lists:member(CMD, ?top_pk_not_lv_limit_cmd).



delay_stop(PS) ->
	#player_status{top_pk = PKStatus, id = RoleId} = PS,
	case PKStatus of
		#top_pk_status{pk_state = {match, Node}} ->
			MyNode = mod_disperse:get_clusters_node(),
			lib_top_pk:apply_cast(Node, mod_top_pk_match_room, cancel_match, [MyNode, RoleId]),
			util:cancel_timer(PKStatus#top_pk_status.ref), %% 取消定时器，如果有的话
			lib_player:break_action_lock(PS#player_status{top_pk = PKStatus#top_pk_status{pk_state = [], ref = []}},
				?ERRCODE(err281_on_matching_state));
		_ ->
			PS
	end.


gm_send_mail() ->
	mod_clusters_node:apply_cast(lib_top_pk, gm_send_mail_help, []).


gm_send_mail_help() ->
	Sql = "select  server_num, role_id, rank, reward  from   log_top_pk_season_reward",
	List = db:get_all(Sql),
	[ begin
		Title   = utext:get(?season_reward_title),
		Content = utext:get(?season_reward_content, [Rank]),
		mod_clusters_center:apply_to_all_node(lib_mail_api, send_sys_mail,
			[[RoleId], Title, Content, util:bitstring_to_term(Reward)])
	end
		||[_ServerId, RoleId, Rank, Reward]  <- List].



gm_update_rank_server_id() ->
	SQL = io_lib:format("SELECT  `role_id`, `season_id`, `season_match_count` FROM `top_pk_player_data` ", []),
%%	SeasonEndTime = get_season_end_time(),
%%	?MYLOG("cym", "Sql ~p~n", [SQL]),
	List = db:get_all(SQL),
%%	?MYLOG("cym", "List ~p~n", [List]),
	[begin
		mod_clusters_node:apply_cast(mod_top_pk_rank_kf, gm_update_rank_server_id, [RoleId, config:get_server_id(), Count])
	end
		|| [RoleId, _SeasonId, Count]
		<- List].


re_login(PS) ->
	#player_status{top_pk = #top_pk_status{pk_state = PkState}, id = RoleId, scene = Scene}  = PS,
	InPkScene = is_in_top_pk_scene(#player_status{scene = Scene}),
	if
		InPkScene == true ->
			case PkState of
				{battle, _BattleNode, BattlePid} ->
					case misc:is_process_alive(BattlePid) of
						true ->
							ok;
						_ ->
							lib_scene:player_change_scene(RoleId, 0, 0, 0, false, [{change_scene_hp_lim, 100}, {last_battle_time,0},{group,0}, {ghost,0}])
					end;
				_ ->
					lib_scene:player_change_scene(RoleId, 0, 0, 0, false, [{change_scene_hp_lim, 100}, {last_battle_time,0},{group,0}, {ghost,0}])
			end;
		true ->
			ok
	end.

%% 巅峰竞技和 时空超时补发奖励
gm_send_time_out_reward(SendServerId) ->
	Sql1 = io_lib:format(<<"select  server_num, role_id, rank, reward from  log_top_pk_season_reward  where  server_num = ~p  and
	role_id <>  4960687231802 and  time >=  1590940800">>, [SendServerId]),
	Title1   = utext:get(?season_reward_title),
	List1 = db:get_all(Sql1),
%%	?PRINT("~p", [List1]),
	[begin
		 timer:sleep(200),
		 Content1 = utext:get(?season_reward_content, [Rank1]),
				        mod_clusters_center:apply_cast(ServerId1, lib_mail_api, send_sys_mail,
					        [[RoleId1], Title1, Content1, util:bitstring_to_term(RewardDb)])
	 end || [ServerId1, RoleId1, Rank1, RewardDb] <-List1],
	Sql2 = io_lib:format(<<"select  server_id,  role_id, rank, reward from   log_chrono_rift_rank_reward
	 where  server_id = ~p  and  role_id <>  4960687231802 and  time >=  1590940800  limit 10000">>, [SendServerId]),
	List2 = db:get_all(Sql2),
	[begin
		 timer:sleep(200),
		 Title2 = utext:get(2040003),
		 Content2 = utext:get(2040004, [Rank2]),
		 mod_clusters_center:apply_cast(ServerId2, lib_mail_api, send_sys_mail,
			 [[RoleId2], Title2, Content2, util:bitstring_to_term(RewardDb2)])
	 end || [ServerId2, RoleId2, Rank2, RewardDb2] <-List2].


is_local_match() ->
	{MinDay, MaxDay} = data_top_pk:get_kv(local_match_day, default),
	OpenDay = util:get_open_day(),
	if
		OpenDay >= MinDay andalso OpenDay =< MaxDay ->
			true;
		true ->
			false
	end.





save_rank_role(#rank_role{
	role_id = RoleId,
	role_name = RoleName,
	platform = Platform,
	power = Power,
	server = Server,
	grade_num = GradeNum,
	star_num = StarNum,
	career = Career,
	rank_lv = RankLv,
	point = Point,
	server_id = ServerId,
	match_count = MatchCount
})  when Point > 0 orelse GradeNum >= 1 ->
	SQL = io_lib:format("REPLACE INTO `top_pk_rank_kf`
     (`role_id`, `role_name`, `career`, `power`, `platform`, `server`, `grade_num`, `star_num`, `time`, `rank_lv`, `point`, `server_id`, `match_count`)
    VALUES (~p, '~s', ~p, ~p, '~s', ~p, ~p, ~p, UNIX_TIMESTAMP(), ~p, ~p, ~p, ~p)",
		[RoleId, util:fix_sql_str(RoleName), Career, Power, Platform, Server, GradeNum, StarNum, RankLv, Point, ServerId, MatchCount]),
	?MYLOG("cym", "Sql ~p~n", [SQL]),
	db:execute(SQL);




save_rank_role(#rank_role{role_id = RoleId}) ->
	SQL = io_lib:format("DELETE FROM `top_pk_rank_kf` WHERE `role_id`=~p", [RoleId]),
	db:execute(SQL).




save_rank_role_local(#rank_role{
	role_id = RoleId,
	role_name = RoleName,
	platform = Platform,
	power = Power,
	server = Server,
	grade_num = GradeNum,
	star_num = StarNum,
	career = Career,
	rank_lv = RankLv,
	point = Point,
	server_id = ServerId,
	match_count = MatchCount
})  when Point > 0 orelse GradeNum >= 1 ->
	SQL = io_lib:format("REPLACE INTO `top_pk_rank`
     (`role_id`, `role_name`, `career`, `power`, `platform`, `server`, `grade_num`, `star_num`, `time`, `rank_lv`, `point`, `server_id`, `match_count`)
    VALUES (~p, '~s', ~p, ~p, '~s', ~p, ~p, ~p, UNIX_TIMESTAMP(), ~p, ~p, ~p, ~p)",
		[RoleId, util:fix_sql_str(RoleName), Career, Power, Platform, Server, GradeNum, StarNum, RankLv, Point, ServerId, MatchCount]),
%%	?MYLOG("cym", "Sql ~p~n", [SQL]),
	db:execute(SQL).



%% 新赛季
new_season(PS) ->
	#player_status{top_pk = TopPk, id = RoleId} = PS,
	PKStatus = new_season(RoleId, get_cur_season_id(), TopPk),
	PS#player_status{top_pk = PKStatus}.


get_show_season_time() ->
	Time = get_season_end_time(),
	OpenDay = util:get_open_day(),
	{_, MaxDay} = data_top_pk:get_kv(local_match_day,default),
	if
		OpenDay > MaxDay ->
			Time;
		true ->  %% 还是本服匹配
			LastOpenTime = (MaxDay - OpenDay + 1) * ?ONE_DAY_SECONDS + utime:unixdate(),
			LastOpenTime
%%			if
%%				Time >=  LastOpenTime-> %% 说明月底的时候，已经是超过了开服max了, 但是15号就要结算一次了， 所以时间是LastOpenTime
%%					LastOpenTime;
%%				true ->
%%					Time
%%			end
	end.

%% 根据对战日志修复玩家赛季数据(本服执行)
gm_fix_season_data() ->
    % 计算本赛季开始时间
    {_, MaxLocalDay} = data_top_pk:get_kv(local_match_day, default),
    OpenTime = util:get_open_time(),
    STime1 = OpenTime + (MaxLocalDay + 1) * ?ONE_DAY_SECONDS,
    {STime2, _} = utime:get_month_unixtime_range(),
    STime = max(STime1, STime2),

    % 获取玩家产出日志
    ProduceType = data_produce_type:get_produce(top_pk_battle_honor),
    Sql = <<"
        select player_id, got_value, time
        from log_produce_currency
        where time >= ~p and type = ~p
    ">>,
    LogList = db:get_all(io_lib:format(Sql, [STime, ProduceType])), % [[PlayerId, GotValue, Time],...]

    % 将日志按玩家id分开
    F = fun([RoleId | _] = Log, AccM) ->
        RoleLogs = maps:get(RoleId, AccM, []),
        AccM#{RoleId => [list_to_tuple(Log) | RoleLogs]}
    end,
    RoleMap = lists:foldl(F, #{}, LogList), % #{RoleId => [{RoleId, GotValue, Time},...]}

    % 计算玩家的pk状态
    SeasonId = get_cur_season_id(),
    RoleMap1 = maps:map(fun(_, RoleLogs) -> lists:keysort(3, RoleLogs) end, RoleMap), % 按时间升序排序
    RoleMap2 = maps:map(fun(_RoleId, RoleLogs) -> gm_fix_role_season_data(RoleLogs, #top_pk_status{season_id = SeasonId}) end, RoleMap1), % #{RoleId => #top_pk_status{}}

    % 更新玩家的pk状态到数据库和跨服管理进程
    F1 = fun(RoleId, PkStatus) ->
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, gm_fix_role_season_data2, [PkStatus])
    end,
    maps:map(F1, RoleMap2),

    ok.

gm_fix_role_season_data([], Status) ->
    #top_pk_status{rank_lv = RankLv} = Status,
    Status#top_pk_status{yesterday_rank_lv = RankLv};
gm_fix_role_season_data([{_RoleId, GotValue, _Time} | T], Status) ->
    #top_pk_status{
        grade_num = GradeNum,
        rank_lv = RankLv,
        point = Point,
        serial_win_count = SerialWinCount,
        season_match_count = SeasonMatchCount,
        season_win_count = SeasonWinCount,
        serial_fail_count = SerialFailCount
	} = Status,

    [{_, _, WinVal, _LostVal}] = data_top_pk:get_battle_reward(RankLv),
    Res = ?IF(GotValue == WinVal, ?top_rank_res_win, ?top_rank_res_fail),
    {GradeNum1, RankLv1, Point1, _, _} = calc_rank_with_res_and_diff_rank(GradeNum, RankLv, Point, 0, Res),
    if
        Res == ?top_rank_res_win ->
            SerialWinCount1 = SerialWinCount + 1,
            SerialFailCount1 = 0,
            SeasonWinCount1 = SeasonWinCount + 1;
        true ->
            SerialFailCount1 = SerialFailCount + 1,
            SerialWinCount1 = 0,
            SeasonWinCount1 = SeasonWinCount
	end,
    Status1 = Status#top_pk_status{
        grade_num = GradeNum1,
        rank_lv = RankLv1,
        point = Point1,
        serial_win_count = SerialWinCount1,
        serial_fail_count = SerialFailCount1,
        season_match_count = SeasonMatchCount + 1,
        season_win_count = SeasonWinCount1
    },
    gm_fix_role_season_data(T, Status1).

gm_fix_role_season_data2(PS, RolePkStatus) ->
    #player_status{
        id = RoleId, top_pk = RolePkStatus0,
		figure = #figure{name = RoleName, career = Career}, platform = Platform, server_num = ServerNum, hightest_combat_power = Power,
		guild = #status_guild{name = GuildName}, server_id = ServerId
    } = PS,
    #top_pk_status{rank_lv = RankLv, point = Point, grade_num = GradeNum, season_match_count = SeasonMatchCount} = RolePkStatus,

    % db
    case RolePkStatus0 of
        undefined -> % 离线玩家
            Sql = io_lib:format("select history_match_count, history_win_count, season_reward_status from top_pk_player_data where role_id = ~p limit 1", [RoleId]),
            [HistoryMatchCount, HistoryWinCount, SeasonRewardStatus] = db:get_row(Sql);
        _ ->
            #top_pk_status{
                history_match_count = HistoryMatchCount,
                history_win_count = HistoryWinCount,
                season_reward_status = SeasonRewardStatus
            } = RolePkStatus0
    end,
    RolePkStatus1 = RolePkStatus#top_pk_status{
        history_match_count = HistoryMatchCount,
        history_win_count = HistoryWinCount,
        season_reward_status = SeasonRewardStatus
    },
    update_status(RoleId, RolePkStatus1),

    % 更新rank_role
    Node = mod_disperse:get_clusters_node(),
    RankRole = #rank_role{
        role_id = RoleId, role_name = RoleName, career = Career, power = Power, platform = Platform, server_id = ServerId,
        server = ServerNum, grade_num = GradeNum, star_num = 0, guild_name = GuildName, rank_lv = RankLv, point = Point,
        match_count = SeasonMatchCount
    },
    case is_local_match() of
        true -> mod_top_pk_rank:update(RankRole);
        false -> mod_clusters_node:apply_cast(mod_top_pk_rank_kf, update, [RankRole, Node])
    end,

    PS#player_status{top_pk = RolePkStatus1}.