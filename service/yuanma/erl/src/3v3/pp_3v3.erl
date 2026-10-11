%%% ----------------------------------------------------
%%% @Module:        pp_3v3
%%% @Author:        zhl
%%% @Description:   跨服3v3
%%% @Created:       2017/07/04
%%% ----------------------------------------------------

-module(pp_3v3).
-compile(export_all).
-export([handle/3,
	send_error/2
]).

-include("server.hrl").
-include("predefine.hrl").
%%-include("train.hrl").
-include("scene.hrl").
-include("3v3.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("guild.hrl").
-include("goods.hrl").
-include("role.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("relationship.hrl").
-include("common.hrl").
-include("def_id_create.hrl").
-include("def_goods.hrl").

%% 获取跨服3v3个人战绩
handle(65000, #player_status{role_3v3 = Role3v3, id = RoleId, team_3v3 = Team3v3, action_lock = Lock, scene = Scene, figure = F} = Status, []) ->
	ServOpenDay = util:get_open_day(),
	OpenDay = data_3v3:get_kv(server_open_day),
	if
		ServOpenDay < OpenDay ->
			ok;
		F#figure.lv < ?KF_3V3_LV_LIMIT ->
			ok;
		true ->
			#role_3v3{pack_time = _PackTime, pack_reward = PackReward} = Role3v3,
			#role_3v3_new{team_id = TeamId} = Team3v3,
			Honor = lib_goods_api:get_currency(Status, ?GOODS_ID_3V3_HONOR),
			%%是否在单人匹配中
			IsIn3v3Scene = lib_3v3_api:is_3v3_scene(Scene),
			Error = ?ERRCODE(err650_in_kf_3v3_act_single),
			case Lock of
				Error when IsIn3v3Scene == false->
					MatchingStatus = 1; %%匹配中
				Error when IsIn3v3Scene == true->
					MatchingStatus = 2; %%pk中
				_ ->
					MatchingStatus = 0
			end,
			DailyPk = DailyPk = mod_daily:get_count(RoleId, ?MOD_KF_3V3, 9),
			TodayRewardStatus = ?IF(mod_daily:get_count(RoleId, ?MOD_KF_3V3, 8) >= 1, 1, 0),  %% 0是未领取 ，1 是已经领取
			mod_clusters_node:apply_cast(mod_3v3_team, send_reward_info,
				[config:get_server_id(), PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus])
	end,
	{ok, Status};

%% 领取今日段位奖励
handle(65003, #player_status{id = RoleID, sid = RoleSid, role_3v3 = Role3v3, team_3v3 = Team3v3} = Status, []) ->
	#role_3v3{yesterday_tier = _Tier} = Role3v3,
	#role_3v3_new{team_id = TeamId} = Team3v3,
	IsGet = mod_daily:get_count(RoleID, ?MOD_KF_3V3, 8) >= 1,
	?PRINT("65003 ~p ~n", [mod_daily:get_count(RoleID, ?MOD_KF_3V3, 8)]),
	if
		IsGet ->
			ResID = ?ERRCODE(err650_kf_3v3_is_packed),
			{ok, Bin} = pt_650:write(65003, [ResID]),
			?PRINT("65003 ~n", []),
			lib_server_send:send_to_sid(RoleSid, Bin);
		true ->
			?PRINT("65003 ~n", []),
			mod_clusters_node:apply_cast(mod_3v3_team, get_today_reward, [config:get_server_id(), RoleID, TeamId])
%%			mod_3v3_team:get_today_reward(config:get_server_id(), RoleID, TeamId)
%%			case data_3v3:get_tier_info(Tier) of
%%				#tier_info{today_reward = Reward} ->
%%%%                    ?MYLOG("cym", "Reward ~p~n", [Reward]),
%%					Produce = #produce{type = kf_3v3_daily, reward = Reward},
%%					lib_log_api:log_3v3_today_reward(RoleID, Tier, Reward),
%%					mod_daily:increment_offline(RoleID, ?MOD_KF_3V3, 8),
%%					{ok, NStatus} = lib_goods_api:send_reward_with_mail(Status, Produce);
%%				_ ->
%%					NStatus = Status
%%			end
	end,
%%	{ok, Bin} = pt_650:write(65003, [ResID]),
%%	lib_server_send:send_to_sid(RoleSid, Bin),
	{ok, Status};

handle(65005, #player_status{sid = RoleSid} = Status, []) ->
	mod_3v3_local:get_left_time(RoleSid),
	{ok, Status};

%% 领取活跃奖励
handle(65004, #player_status{id = RoleID, team_3v3 = _Team3v3, role_3v3 = Role3v3, sid = RoleSid} = Status, [RewardID]) ->
%%	#role_3v3_new{team_id = TeamId} = Team3v3,
%%	if
%%		TeamId > 0 ->
%%			mod_3v3_team:get_daily_match_reward(TeamId, RoleID, RewardID);
%%		true ->
%%			send_error(RoleID, ?ERRCODE(err650_not_have_team))
%%	end,
    #role_3v3{pack_reward = PackReward, daily_win = DailyWin} = Role3v3,
	DailyPk = mod_daily:get_count(RoleID, ?MOD_KF_3V3, 9),
    case lists:keyfind(RewardID, 1, PackReward) of
        {_, Time} ->
            IsToday = utime:is_today(Time),
            if
                IsToday -> %% 今日已领取
                    ResID = ?ERRCODE(err650_kf_3v3_is_packed),
                    NStatus = Status;
                RewardID > 0 andalso DailyPk < RewardID ->
                    ResID = ?ERRCODE(err650_kf_3v3_lack_count),
                    NStatus = Status;
                RewardID == 0 andalso DailyWin =< 0 ->
                    ResID = ?ERRCODE(err650_kf_3v3_lack_wincount),
                    NStatus = Status;
                true ->
                    case data_3v3:get_act_rewards(RewardID) of
                        [] ->
                            ResID = ?FAIL,
                            NStatus = Status;
                        Rewards ->
                            case lib_goods_api:can_give_goods(Status, Rewards) of
                                true ->
                                    ResID = ?SUCCESS,
                                    NPackReward = lists:keyreplace(
                                        RewardID, 1, PackReward, {RewardID, utime:unixtime()}),
                                    NRole3v3 = Role3v3#role_3v3{pack_reward = NPackReward},
                                    lib_3v3_local:replace_role_3v3(RoleID, NRole3v3),
                                    Status1 = Status#player_status{role_3v3 = NRole3v3},
                                    % NStatus = lib_goods_api:send_reward(Rewards, kf_3v3, Status1)
                                    Produce = #produce{type = kf_3v3_wincount, reward = Rewards, show_tips = ?SHOW_TIPS_3},
                                    {ok, NStatus} = lib_goods_api:send_reward_with_mail(Status1, Produce);
                                {false, ErrorCode} ->
                                    ResID = ErrorCode,
                                    NStatus = Status;
                                _ ->
                                    ResID = ?ERRCODE(err150_no_cell),
                                    NStatus = Status
                            end
                    end
            end;
        _ ->
            ResID = ?FAIL,
            NStatus = Status
    end,
    {ok, Bin} = pt_650:write(65004, [ResID, RewardID]),
    lib_server_send:send_to_sid(RoleSid, Bin),
	{ok, NStatus};

%% 连接不上跨服提示 | 等级不足 | 全局错误码
%% @desc : 连接不上跨服中心时活动不开启
handle(Cmd, #player_status{
	figure = #figure{lv = RoleLv}, sid = RoleSid, action_lock = _ActionLock, scene = _SceneID
} = Status, Recv) ->
	ServOpenDay = util:get_open_day(),
	OpenDay = data_3v3:get_kv(server_open_day),
	if
		ServOpenDay < OpenDay ->
			ok;
		RoleLv < ?KF_3V3_LV_LIMIT -> %% 等级不足
			{ok, Bin} = pt_650:write(65001, [?ERRCODE(lv_limit)]),
			lib_server_send:send_to_sid(RoleSid, Bin),
			{ok, Status};
		Cmd == 65038 orelse Cmd == 65039 orelse Cmd == 65045 ->
			do_handle(Cmd, Status, Recv);
		true ->
			do_handle(Cmd, Status, Recv)
%%            case ?ERRCODE(err650_in_kf_3v3_act) of
%%                ActionLock ->
%%                    do_handle(Cmd, Status, Recv);
%%                _ ->
%%                    case lib_player_check:check_all(Status) of
%%                        true ->
%%                            do_handle(Cmd, Status, Recv);
%%                        {false, ErrorStatus} ->
%%                            {ok, Bin} = pt_650:write(65001, [ErrorStatus]),
%%                            lib_server_send:send_to_sid(RoleSid, Bin),
%%                            {ok, Status}
%%                    end
%%            end
	end.

%% 取消关注界面
do_handle(65002, #player_status{id = RoleID} = Status, []) ->
	mod_3v3_local:cancel_attention([RoleID]),
	{ok, Status};

%% 获取自身队伍信息
do_handle(65010, Status, []) ->
%%    ?MYLOG("3v3", "65010 ++++++++++~n", []),
	#player_status{id = RoleID, sid = RoleSid} = Status,
	mod_3v3_local:get_team_info([RoleID, RoleSid]),
	{ok, Status};

%% 获取3v3队伍列表
do_handle(65011, #player_status{sid = RoleSid, id = RoleID, server_id = ServerId} = Status, []) ->
	mod_3v3_local:get_team_list([RoleID, RoleSid, ServerId]),
	{ok, Status};

%% 查询3v3队伍信息
do_handle(65012, #player_status{sid = RoleSid} = Status, [TeamID]) ->
	mod_3v3_local:get_team_data([RoleSid, TeamID]),
	{ok, Status};

%% 创建队伍
do_handle(65013, Status, [PowerLimit, LvLimit, Password, IsAuto]) ->
	RoleData = lib_3v3_local:to_role_data(Status, [PowerLimit, LvLimit, Password, IsAuto]),
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		Status#player_status.action_lock =:= Lock ->
			mod_3v3_local:create_team(RoleData);
		true ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:create_team(RoleData);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(Status#player_status.sid, Bin)
			end
	end,
	{ok, Status};

%% 快速加入队伍（个人匹配）
do_handle(65014, #player_status{role_3v3 = _Role3v3, scene = Scene, id = RoleId} = Status, [Type]) ->
	RoleData = lib_3v3_local:to_role_data(Status, [0, 0, 0, ?KF_3V3_IS_AUTO]),
%%	#role_3v3{daily_pk = DailyPk} = Role3v3,
	DailyPk = mod_daily:get_count_offline(RoleId, ?MOD_KF_3V3, 9),
	DailyMatchLimit = data_3v3:get_kv(daily_match_count),
	Is3v3Scene = lib_3v3_api:is_3v3_scene(Scene),
	?MYLOG("3v3", "65014 +++++++ ~n", []),
	Lock = ?ERRCODE(err650_in_kf_3v3_act_single),
	ChampionTime = lib_3v3_api:champion_start_time(),
	IsToday = utime:is_today(ChampionTime),
	if
		IsToday == true ->
			send_error(RoleId, ?ERRCODE(err650_kf_3v3_not_start));
		DailyPk >= DailyMatchLimit ->
			{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_kf_3v3_match_limt)]),
			lib_server_send:send_to_sid(Status#player_status.sid, Bin);
		Status#player_status.action_lock =:= Lock andalso Is3v3Scene == false andalso Type == 1 ->
			?MYLOG("3v3", "65014 +++++++ ~n", []),
			{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_kf_3v3_matching)]),
			lib_server_send:send_to_sid(Status#player_status.sid, Bin);
		Status#player_status.action_lock =:= Lock ->
			if  %% 容错客户端不发17的协议
				Type == 2 ->
					pp_3v3:handle(65017, Status, []);
				true ->
					ok
			end,
			mod_3v3_local:quick_join_team([RoleData, Type]);
		true ->
			case lib_player_check:check_all(Status) of
				true ->
					if  %% 容错客户端不发17的协议
						Type == 2 ->
							pp_3v3:handle(65017, Status, []);
						true ->
							ok
					end,
					mod_3v3_local:quick_join_team([RoleData, Type]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(Status#player_status.sid, Bin)
			end
	end,
	{ok, Status};

%% 申请入队伍
do_handle(65015, Status, [TeamID, Password]) ->
	RoleData = lib_3v3_local:to_role_data(Status, [0, 0, 0, 0]),
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		Status#player_status.action_lock == Lock ->
			mod_3v3_local:apply_join_team([RoleData, TeamID, Password]);
		true ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:apply_join_team([RoleData, TeamID, Password]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(Status#player_status.sid, Bin)
			end
	end,
	{ok, Status};

%% 受邀入队伍
do_handle(65016, Status, [TeamID, Password]) ->
	RoleData = lib_3v3_local:to_role_data(Status, [0, 0, 0, 0]),
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		Status#player_status.action_lock =:= Lock ->
			mod_3v3_local:invite_join_team([RoleData, TeamID, Password]);
		true ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:invite_join_team([RoleData, TeamID, Password]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(Status#player_status.sid, Bin)
			end
	end,
	{ok, Status};

%% 离开队伍
do_handle(65017, Status, []) ->
	#player_status{
		platform = Platform, server_num = ServerNum, server_id = ServerId, id = RoleID, sid = RoleSid
	} = Status,
	mod_3v3_local:leave_team([Platform, ServerNum, ServerId, RoleID, RoleSid]),
	{ok, Status};

%% 踢出队伍
do_handle(65018, Status, [_TPlatform, _TServerNum, TRID]) ->
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid} = Status,
	mod_3v3_local:kick_out_team([ServerId, RoleID, RoleSid, TRID]),
	{ok, Status};

%% 邀请玩家 - 邀请的玩家只能是本服的玩家
do_handle(65019, Status, [TRID]) ->
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid} = Status,
	mod_3v3_local:invite_role([ServerId, RoleID, RoleSid, TRID]),
	{ok, Status};

%% 开始匹配
do_handle(65021, Status, []) ->
%%    ?MYLOG("3v3", "65021 ++++++++++++++++++~n", []),
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid, role_3v3 = Role3v3} = Status,
	#role_3v3{daily_pk = DailyPk} = Role3v3,
	DailyMatchLimit = data_3v3:get_kv(daily_match_count),
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		DailyPk >= DailyMatchLimit ->
			{ok, Bin} = pt_650:write(65001, [?ERRCODE(err650_kf_3v3_match_limt)]),
			lib_server_send:send_to_sid(Status#player_status.sid, Bin);
		Status#player_status.action_lock =/= Lock ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:start_matching_team([ServerId, RoleID, RoleSid]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(RoleSid, Bin)
			end;
		true ->
			mod_3v3_local:start_matching_team([ServerId, RoleID, RoleSid])
	end,
	{ok, Status};

%% 取消匹配 todo
do_handle(65022, Status, []) ->
	#player_status{
		team_3v3 = Team3v3,
		id = RoleId
	} = Status,
	?MYLOG("3v3", "Team3v3 ~p~n", [Team3v3]),
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, stop_match, [TeamId, config:get_server_id(), RoleId]);
%%			mod_3v3_team:stop_match(TeamId, RoleId);
		_ ->
			send_error(RoleId, ?ERRCODE(err650_not_have_team))
	end,
	{ok, Status};

%% 准备 | 取消准备
do_handle(65023, Status, [IsReady]) ->
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid} = Status,
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		Status#player_status.action_lock =/= Lock ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:reset_ready([ServerId, RoleID, RoleSid, IsReady]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(RoleSid, Bin)
			end;
		true ->
			mod_3v3_local:reset_ready([ServerId, RoleID, RoleSid, IsReady])
	end,
	{ok, Status};

%% 自动开始 | 取消自动开始
do_handle(65024, Status, [IsAuto]) ->
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid} = Status,
	Lock = ?ERRCODE(err650_in_kf_3v3_act),
	if
		Status#player_status.action_lock =/= Lock ->
			case lib_player_check:check_all(Status) of
				true ->
					mod_3v3_local:reset_auto([ServerId, RoleID, RoleSid, IsAuto]);
				{false, ErrorCode} ->
					{ok, Bin} = pt_650:write(65001, [ErrorCode]),
					lib_server_send:send_to_sid(RoleSid, Bin)
			end;
		true ->
			mod_3v3_local:reset_auto([ServerId, RoleID, RoleSid, IsAuto])
	end,
	{ok, Status};

%% 3v3战场信息
do_handle(65030, Status, [ClientTeamId]) ->
	#player_status{server_id = ServerId, id = RoleID, sid = RoleSid, team_3v3 = Role3v3} = Status,
%%	?MYLOG("3v3", "Role3v3 ~p~n, ClientTeamId ~p~n", [Role3v3, ClientTeamId]),
	case Role3v3 of
		#role_3v3_new{is_in_champion_pk = 1, team_id = TeamId} when ClientTeamId == 0 ->  %% 冠军赛自己
			mod_clusters_node:apply_cast(mod_3v3_champion, get_battle_info, [ServerId, RoleID, RoleSid, TeamId]);
		#role_3v3_new{team_id = TeamId} when ClientTeamId =/= TeamId andalso ClientTeamId =/= 0 ->  %% 观战的
			mod_clusters_node:apply_cast(mod_3v3_champion, get_battle_info, [ServerId, RoleID, RoleSid, ClientTeamId]);
		_ ->
			mod_3v3_local:get_battle_info([ServerId, RoleID, RoleSid])
	end,
	{ok, Status};

%% 获取天梯排行榜 - 活动结束推送20强
do_handle(65038, Status, []) ->
	#player_status{server_id = ServerId, sid = RoleSid} = Status,
	mod_3v3_local:get_score_rank([ServerId, RoleSid]),
	{ok, Status};

%% 获取荣誉排行榜 - 每页最多5个排名
do_handle(65039, Status, [Page]) when Page >= 0 ->
	#player_status{server_id = ServerId, id = RoleID} = Status,
	mod_clusters_node:apply_cast(mod_3v3_rank, get_page_rank, [[Page, ServerId, RoleID]]),
	{ok, Status};

%% 离开战场
do_handle(65040, Status, []) ->
	#player_status{platform = Platform, server_num = ServerNum, server_id = ServerId, id = RoleID, scene = SceneId} = Status,
	Is3v3Scene = lib_3v3_api:is_3v3_scene(SceneId),
	lib_3v3_local:leave_pk_room([Platform, ServerNum, RoleID, ?PK_3V3_ONLINE, ServerId, Is3v3Scene]),
	{ok, Status};

%% 公开招募
do_handle(65041, Status, [Type]) ->
	#player_status{id = RoleID, figure = Figure, combat_power = CombatPower} = Status,
	mod_3v3_local:open_call_member([RoleID, Type, Figure, CombatPower]);




%% 进出塔 //1 进入塔  0 出塔
do_handle(65042, Status, [Type, TowerId]) ->
	#player_status{id = RoleId, scene = Scene, team_3v3 = Role3v3} = Status,
	case lib_3v3_api:is_3v3_scene(Scene) of
		true ->
			case Role3v3 of
				#role_3v3_new{is_in_champion_pk = 1, team_id = TeamId} ->
					mod_clusters_node:apply_cast(mod_3v3_champion, enter_or_quit_tower, [RoleId, Type, TowerId, TeamId]);
				_ ->
					mod_clusters_node:apply_cast(lib_3v3_center, enter_or_quit_tower, [RoleId, Type, TowerId])
			end;
		false ->
			skip
	end,
	{ok, Status};

%% 玩家信息
do_handle(65043, Status, [ClientTeamId]) ->  %% todo
	#player_status{id = RoleId, scene = Scene, team_3v3 = Role3v3} = Status,
	?MYLOG("3v3", "Role3v3 ~p~n, ClientTeamId ~p~n", [Role3v3, ClientTeamId]),
	case lib_3v3_api:is_3v3_scene(Scene) of
		true ->
			case Role3v3 of
				#role_3v3_new{is_in_champion_pk = 1, team_id = TeamId} when ClientTeamId == 0 ->  %% 冠军赛自己
					mod_clusters_node:apply_cast(mod_3v3_champion, get_role_list_msg, [RoleId, node(), TeamId]);
				#role_3v3_new{team_id = TeamId} when ClientTeamId =/= TeamId andalso ClientTeamId =/= 0 ->  %% 观战的
					mod_clusters_node:apply_cast(mod_3v3_champion, get_role_list_msg, [RoleId, node(), ClientTeamId]);
				_ -> %%排位赛
					mod_clusters_node:apply_cast(lib_3v3_center, get_role_list_msg, [RoleId, node()])
%%			mod_3v3_local:get_battle_info([ServerId, RoleID, RoleSid])
			end;
		_ ->
			skip
	end,
	{ok, Status};


%% 创建队伍
do_handle(65049, Status, [TeamName]) ->
%%	?MYLOG("3v3", "TeamName ~p~n", [TeamName]),
	#player_status{id = RoleId, sid = Sid, server_name = ServerName, server_num = ServerNum,
		server_id = ServerId, figure = Figure, combat_power = Power} = Status,
	case lib_3v3_api:check_create_team(Status, TeamName) of
		true ->
			Cost = data_3v3:get_kv(create_team_cost),
%%            lib_goods_api:check_object_list()
%%            lib_goods_api:check_object_list(Status, Cost, create_3v3_team, "")
			case lib_goods_api:check_object_list(Status, Cost) of
				true -> %%
					RoleMsg = #team_local_3v3_role{role_id = RoleId,
						server_name = ServerName,
						server_num = ServerNum,
						server_id = config:get_server_id(),
						turn = Figure#figure.turn,
						login_time = utime:unixtime(),
						logout_time = utime:unixtime(),
						power = Power,
						picture = Figure#figure.picture,
						picture_id = Figure#figure.picture_ver
						,on_line = ?ONLINE_ON
						,role_name = Figure#figure.name
						,lv = Figure#figure.lv
						},
					TeamId = mod_id_create:get_new_id(?TEAM_3V3_ID_CREATE),
					mod_clusters_node:apply_cast(mod_3v3_team, create_team,
						[ServerId, TeamName, RoleId, RoleMsg, TeamId, Figure#figure.name]),
					{ok, Status};
				{false, Err} ->
					{ok, Bin} = pt_650:write(65049, [Err]),
					lib_server_send:send_to_sid(Sid, Bin)
			end;
		{false, Err} ->
			{ok, Bin} = pt_650:write(65049, [Err]),
			lib_server_send:send_to_sid(Sid, Bin)
	end;

%% 申请队伍
do_handle(65050, Status, [TeamId]) ->
%%	?MYLOG("3v3", "TeamId ~p~n", [TeamId]),
	#player_status{id = RoleId, server_name = ServerName, server_num = ServerNum, figure = Figure, server_id = ServerId, combat_power = Power} = Status,
	RoleMsg = #team_local_3v3_role{role_id = RoleId, server_name = ServerName, logout_time = utime:unixtime(), power = Power,
		server_num = ServerNum, turn = Figure#figure.turn, login_time = utime:unixtime(), server_id = config:get_server_id(),
		role_name = Figure#figure.name,
		lv = Figure#figure.lv,
		picture_id = Figure#figure.picture_ver,
		picture = Figure#figure.picture
		,on_line = ?ONLINE_ON
		},
	mod_clusters_node:apply_cast(mod_3v3_team, apply_team,
		[TeamId, RoleMsg, ServerId]);
%%	mod_3v3_team:apply_team(TeamId, RoleMsg, ServerId);

%% 战队列表
do_handle(65051, Status, []) ->
	mod_clusters_node:apply_cast(mod_3v3_team, info, [config:get_server_id(), Status#player_status.id]);
%%	mod_3v3_team:info(Status#player_status.id);

%% 战队信息
do_handle(65052, Status, [TeamId]) ->
	#player_status{team_3v3 = Team3v3, id = RoleId} = Status,
%%	?MYLOG("3v3", "Team3v3 ~p~n", [Team3v3]),
	#role_3v3_new{team_id = NewTeamId} = Team3v3,
	if
		TeamId == 0 ->
			if
				NewTeamId > 0 ->
					mod_clusters_node:apply_cast(mod_3v3_team, send_team_info, [NewTeamId, config:get_server_id(), RoleId, 0]);
%%					mod_3v3_team:send_team_info(NewTeamId, RoleId, 0);  %%0标识自己队  1 别人队
				true ->
%%                    ?MYLOG("3v3", "65052 +++++++++ ~n", []),
					ok
			end;
		TeamId == NewTeamId ->
			mod_clusters_node:apply_cast(mod_3v3_team, send_team_info, [NewTeamId, config:get_server_id(), RoleId, 0]);
%%			mod_3v3_team:send_team_info(NewTeamId, RoleId, 0);
		true ->
			mod_clusters_node:apply_cast(mod_3v3_team, send_team_info, [TeamId, config:get_server_id(), RoleId, 1])
%%			mod_3v3_team:send_team_info(TeamId, RoleId, 1)
	end;

%% 踢人
do_handle(65053, Status, [RoleId]) ->
%%	?MYLOG("3v3", "++++++++++~n", []),
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = Status,
%%	EndTime = lib_3v3_local:get_end_time(),
	IsCanCut = lib_3v3_api:is_can_cut_team(),
	if
%%		EndTime > 0 ->
%%			send_error(MyRoleId, ?ERRCODE(err650_can_not_handle_in_act));
		IsCanCut == false ->
			send_error(MyRoleId, ?ERRCODE(err650_can_not_cut));
		true ->  %%结束
			case Team3v3 of
				#role_3v3_new{team_id = TeamId, leader_id = MyRoleId} ->
					if
						RoleId == MyRoleId ->
							send_error(MyRoleId, ?ERRCODE(err650_can_not_kick_leader));
						true ->
							mod_clusters_node:apply_cast(mod_3v3_team, kick_role, [config:get_server_id(), RoleId, TeamId, MyRoleId])
%%							mod_3v3_team:kick_role(RoleId, TeamId, MyRoleId)
					end;
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_leader))
			end
	end;


%% 转让队长
do_handle(65054, Status, [ChangeLeaderId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = Status,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, leader_id = MyRoleId} ->
			ChangeLeaderName = lib_role:get_role_name(ChangeLeaderId),
			mod_clusters_node:apply_cast(mod_3v3_team, change_leader,
				[config:get_server_id(), MyRoleId, TeamId, ChangeLeaderId, ChangeLeaderName]);
%%			mod_3v3_team:change_leader(MyRoleId, TeamId, ChangeLeaderId, ChangeLeaderName);
		_ ->
			{ok, Bin} = pt_650:write(65054, [0, ?ERRCODE(err650_not_leader)]),
			lib_server_send:send_to_uid(MyRoleId, Bin)
	end;

%% 解散队伍
do_handle(65055, Status, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = Status,
%%	EndTime = lib_3v3_local:get_end_time(),
	IsCanCut = lib_3v3_api:is_can_cut_team(),
	if
%%		EndTime > 0 ->
%%			send_error(MyRoleId, ?ERRCODE(err650_can_not_handle_in_act));
		IsCanCut == false ->
			send_error(MyRoleId, ?ERRCODE(err650_chanpion_can_not_change_team));
		true ->  %%结束
			case Team3v3 of
				#role_3v3_new{team_id = TeamId, leader_id = MyRoleId} ->
					mod_clusters_node:apply_cast(mod_3v3_team, disband_team,
						[config:get_server_id(), MyRoleId, TeamId]);
%%					mod_3v3_team:disband_team(config:get_server_id(), MyRoleId, TeamId);
				_ ->
					{ok, Bin} = pt_650:write(65055, [?ERRCODE(err650_not_leader)]),
					lib_server_send:send_to_uid(MyRoleId, Bin)
			end
	end;


%% 退出队伍
do_handle(65056, Status, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = Status,
%%	EndTime = lib_3v3_local:get_end_time(),
	IsCanCut = lib_3v3_api:is_can_cut_team(),
	if
%%		EndTime > 0 ->
%%			send_error(MyRoleId, ?ERRCODE(err650_can_not_handle_in_act));
		IsCanCut == false ->
			send_error(MyRoleId, ?ERRCODE(err650_chanpion_can_not_change_team));
		true ->
			case Team3v3 of
				#role_3v3_new{leader_id = MyRoleId} ->
					{ok, Bin} = pt_650:write(65056, [?ERRCODE(err650_leader_can_not_quit_team)]),
					lib_server_send:send_to_uid(MyRoleId, Bin);
				#role_3v3_new{team_id = TeamId} ->
					mod_clusters_node:apply_cast(mod_3v3_team, quit_team,
						[config:get_server_id(), TeamId, MyRoleId]);
%%					mod_3v3_team:quit_team(TeamId, MyRoleId);
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_leader))
			end
	end;




%% 排名信息
do_handle(65057, Status, []) ->
	#player_status{sid = RoleSid, server_id = ServerId} = Status,
	mod_clusters_node:apply_cast(mod_3v3_rank, get_score_rank, [[ServerId, RoleSid]]);
%%    mod_3v3_team:team_rank_info(MyRoleId);

%% 战队改名
do_handle(65058, Status, [Name]) ->
%%	?MYLOG("3v3", "~p ~n", [Name]),
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = Status,
	%_Cost = data_3v3:get_kv(change_name_cost),
	case lib_game:is_ban_rename() of
		false ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId, leader_id = MyRoleId} ->
					mod_clusters_node:apply_cast(mod_3v3_team, change_name,
						[config:get_server_id(), MyRoleId, TeamId, Name]);
				% mod_3v3_team:change_name(MyRoleId, TeamId, Name);
				_ ->
					{ok, Bin} = pt_650:write(65058, ["", ?ERRCODE(err650_not_leader)]),
					lib_server_send:send_to_uid(MyRoleId, Bin)
			end;
		_ ->
			{ok, Bin} = pt_650:write(65058, ["", ?ERRCODE(err426_update_rename_system)]),
			lib_server_send:send_to_uid(MyRoleId, Bin)
	end;


%% 申请队伍列表
do_handle(65059, Status, []) ->
	#player_status{id = RoleId, team_3v3 = Team3v3} = Status,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, leader_id = RoleId} ->
%%			?MYLOG("3v3", "65059 +++++++++  ~n", []),
			mod_clusters_node:apply_cast(mod_3v3_team, apply_role_info, [config:get_server_id(), TeamId, RoleId]);
		_ ->
%%			?MYLOG("3v3", "65059 +++++++++  ~n", []),
			ok
%%            send_error(RoleId, ?FAIL)
	end;

%% 处理申请列表
do_handle(65060, Status, [RoleId, Type]) ->
%%	?MYLOG("3v3", "65060 +++++++++++++ ~n", []),
	#player_status{server_id = _ServerId, team_3v3 = Team3v3, id = MYRoleId, sid = Sid} = Status,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, leader_id = MYRoleId} ->
			mod_clusters_node:apply_cast(mod_3v3_team, hand_apply_list, [config:get_server_id(), RoleId, Type, TeamId, MYRoleId]);
%%			mod_3v3_team:hand_apply_list(RoleId, Type, TeamId, MYRoleId);
		_ ->
			{ok, Bin} = pt_650:write(65060, [0, 0, ?FAIL]),
			lib_server_send:send_to_sid(Sid, Bin)
	end;

%% 世界招募
do_handle(65061, Status, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, figure = F} = Status,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, leader_id = MyRoleId, team_name = TeamName} ->
			{ok, Bin} = pt_650:write(65061, [?SUCCESS]),
			lib_server_send:send_to_uid(MyRoleId, Bin),
			lib_chat:send_TV({all}, ?MOD_KF_3V3, 3, [F#figure.name, TeamName, TeamId]);
		_ ->
			{ok, Bin} = pt_650:write(65061, [?ERRCODE(err650_not_leader)]),
			lib_server_send:send_to_uid(MyRoleId, Bin)
	end;


%% 个人招募
do_handle(65062, Status, [RoleId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, figure = F} = Status,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, leader_id = MyRoleId, team_name = TeamName} ->
			%%是否在线
			Pid = misc:get_player_process(RoleId),
			case misc:is_process_alive(Pid) of
				true ->
					{ok, Bin} = pt_650:write(65063, [MyRoleId, F#figure.name, TeamId, TeamName]),
					lib_server_send:send_to_uid(RoleId, Bin),
					{ok, Bin1} = pt_650:write(65062, [?SUCCESS]),
					lib_server_send:send_to_uid(MyRoleId, Bin1);
				false ->
					{ok, Bin1} = pt_650:write(65062, [?ERRCODE(err650_role_off_line)]),
					lib_server_send:send_to_uid(MyRoleId, Bin1)
			end;
		_ ->
			{ok, Bin} = pt_650:write(65061, [?ERRCODE(err650_not_leader)]),
			lib_server_send:send_to_uid(MyRoleId, Bin)
	end;

%% 快速入队  s
do_handle(65064, Status, [TeamId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, figure = Figure, combat_power = Power} = Status,
%%	?MYLOG("3v3", "65064 +++++++++++++ ~p~n", [Team3v3]),
	case Team3v3 of
		#role_3v3_new{team_id = OldTeamId} when OldTeamId == 0 ->
			RoleMsg = #team_local_3v3_role{role_id = MyRoleId, server_name = util:get_server_name(),
				server_num = config:get_server_num(), turn = Figure#figure.turn, power = Power,
				logout_time = utime:unixtime(), login_time = utime:unixtime(), server_id = config:get_server_id(),
				role_name = Figure#figure.name,
				lv = Figure#figure.lv,
				picture_id = Figure#figure.picture_ver,
				picture = Figure#figure.picture
				,on_line = ?ONLINE_ON
				},
			mod_clusters_node:apply_cast(mod_3v3_team, quick_enter_team, [TeamId, RoleMsg]);
%%			mod_3v3_team:quick_enter_team(TeamId, RoleMsg);
		_ ->
%%			?MYLOG("3v3", "65064 +++++++++++++ ~n", []),
			{ok, Bin} = pt_650:write(65064, [?ERRCODE(err650_have_team)]),
			lib_server_send:send_to_uid(MyRoleId, Bin)
	end;


%% 招募列表 公会
do_handle(65065, #player_status{id = RoleId, figure = #figure{guild_id = GuildId}}, [1]) ->
%%	?MYLOG("3v3", "65065 1 ~n ", []),
	case GuildId > 0 of
		true -> mod_guild:send_recruit_3v3_list(RoleId, GuildId);
		false -> skip
	end;

%% 招募列表 好友
do_handle(65065, #player_status{id = RoleId}, [2]) ->
	RelaL = lib_relationship:get_relas_by_types(RoleId, 1),   %%好友列表
	F = fun(#rela{other_rid = OtherRid}, List) ->
		case lib_role:get_role_show(OtherRid) of
			#ets_role_show{
				figure = Figure,
				online_flag = ?ONLINE_ON,
				team_3v3_id = TeamId,
				combat_power = CombatPower
			} when TeamId == 0 ->
				#figure{picture_ver = PictureVer, picture = Picture, lv = Lv, career = Career, name = Name} = Figure,
				[{OtherRid, Name, Picture, PictureVer, Career, Lv, CombatPower} | List];
			_ ->
				List
		end
	    end,
	List = lists:foldl(F, [], RelaL),
	{ok, BinData} = pt_650:write(65065, [2, List]),
	lib_server_send:send_to_uid(RoleId, BinData),
	ok;


%% 发起投票 3v3
do_handle(65066, #player_status{id = MyRoleId} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = PS,
%%    EndTime = lib_3v3_local:get_end_time(),
	Times = mod_daily:get_count(MyRoleId, ?MOD_KF_3V3, 9),
	MaxMatchTime = data_3v3:get_kv(daily_match_count),
%%	EndTime = 1,
	ChampionTime = lib_3v3_api:champion_start_time(),
	IsToday = utime:is_today(ChampionTime),
	if
%%		EndTime == 0 ->
%%			send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_not_start));
		Times >= MaxMatchTime ->
			send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_match_limt));
		IsToday == true ->
			send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_not_start));
		true ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId, leader_id = MyRoleId} ->
					case lib_player_check:check_all(PS) of
						true ->
							mod_clusters_node:apply_cast(mod_3v3_team, start_vote, [config:get_server_id(), MyRoleId, TeamId]);
%%							mod_3v3_team:start_vote(MyRoleId, TeamId);
						{false, Error} ->
							send_error(MyRoleId, Error)
					end;
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_leader))
			end
	end;

%% 队员投票
do_handle(65067, #player_status{id = MyRoleId} = PS, [Type]) when Type == 1 orelse Type == 0 ->  %%赞成或者反对
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = PS,
	Times = mod_daily:get_count(MyRoleId, ?MOD_KF_3V3, 9),
	MaxMatchTime = data_3v3:get_kv(daily_match_count),
	if
		Times >= MaxMatchTime ->
			send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_match_limt));
		true ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
					case lib_player_check:check_all(PS) of
						true ->
							mod_clusters_node:apply_cast(mod_3v3_team, vote, [config:get_server_id(), MyRoleId, TeamId, Type]);
%%							mod_3v3_team:vote(MyRoleId, TeamId, Type);
						{false, Error} ->
							send_error(MyRoleId, Error)
					end;
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
			end
	end;


%% 广播队员投票
do_handle(65071, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [_TeamId]) ->  %%赞成或者反对
%%	?MYLOG("3v3", "65071+++++++ ~n", []),
	#player_status{team_3v3 = Team3v3, id = MyRoleId} = PS,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, get_vote_list, [config:get_server_id(), TeamId, MyRoleId]);
%%			mod_3v3_team:get_vote_list(TeamId, MyRoleId);
		_ ->
			send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
	end;


%%  催促队长
do_handle(65073, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
%%	?MYLOG("3v3", "65073+++++++ ~n", []),
	#player_status{team_3v3 = Team3v3, id = MyRoleId, figure = F} = PS,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
			mod_clusters_node:apply_cast(mod_3v3_team, urge_leader, [config:get_server_id(), TeamId, MyRoleId, F#figure.name]);
%%			mod_3v3_team:urge_leader(TeamId, MyRoleId, F#figure.name);
		_ ->
			send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
	end;


%%16强的才可以进入
do_handle(65075, PS, []) ->
	#player_status{id = RoleId} = PS,
%%	?MYLOG("3v3pk", "65075 ++++++++++++++++++ ~n", []),
	mod_clusters_node:apply_cast(mod_3v3_champion, champion_team_list_info, [RoleId, node()]);

%%16强的才可以进入
do_handle(65076, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
%%	?MYLOG("3v3", " +++++++++++++++65076 ~n", []),
	case lib_player_check:check_all(PS) of
		true ->
			#player_status{team_3v3 = Team3v3, id = MyRoleId} = PS,
			case Team3v3 of
				#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
					mod_clusters_node:apply_cast(mod_3v3_champion, enter_scene, [TeamId, MyRoleId, node()]);
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
			end;
		{false, Error} ->
			send_error(MyRoleId, Error)
	end;


%%离开冠军赛场景
do_handle(65077, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, scene = Scene} = PS,
	case lib_3v3_api:is_3v3_champion_scene(Scene) of
		true ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
					KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}],
					NewPS = lib_scene:change_default_scene(PS, KeyValueList),
					mod_clusters_node:apply_cast(mod_3v3_champion, quit_scene, [TeamId, MyRoleId, node()]),
					{ok, NewPS};
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
			end;
		false ->
			send_error(MyRoleId, ?ERRCODE(err650_not_in_champion_scene))
	end;

%%赛场信息
do_handle(65078, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, scene = Scene, server_id = ServerId} = PS,
	case lib_3v3_api:is_3v3_champion_scene(Scene) of
		true ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
%%					?MYLOG("pk", "65078 ++++++++++++++ ~n", []),
					mod_clusters_node:apply_cast(mod_3v3_champion, get_champion_msg, [TeamId, MyRoleId, ServerId, node()]),
					{ok, PS};
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
			end;
		false ->
			send_error(MyRoleId, ?ERRCODE(err650_not_in_champion_scene))
	end;


%%召集队员
do_handle(65079, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, scene = Scene} = PS,
	case lib_3v3_api:is_3v3_champion_scene(Scene) of
		true ->
			case Team3v3 of
				#role_3v3_new{team_id = TeamId} when TeamId > 0 ->
					mod_clusters_node:apply_cast(mod_3v3_champion, call_team_role, [TeamId, MyRoleId]);
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_team))
			end;
		false ->
			send_error(MyRoleId, ?ERRCODE(err650_not_in_champion_scene))
	end;


%%竞猜  每轮只能竞猜一次
do_handle(65080, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [Turn, TeamAId, TeamBId, Opt, CostType, CostNum]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId} = PS,
	Cost = lib_3v3_local:get_guess_cost(CostType, CostNum),
	case lib_goods_api:check_object_list(PS, Cost) of
		true ->
			if
				TeamAId > 0 andalso TeamBId > 0 ->
					mod_clusters_node:apply_cast(mod_3v3_champion, guess, [ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum]);
				true ->
					ok
			end;
		{false, Error} ->
			send_error(MyRoleId, Error)
	end;

%%竞猜列表
do_handle(65081, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId} = PS,
	case Team3v3 of
		#role_3v3_new{guess_record = RecordList} ->
			ToDayGuessRecordList = [Record || #role_guess_record{time = Time} = Record <- RecordList, utime:is_today(Time)],
			mod_clusters_node:apply_cast(mod_3v3_champion, guess_list,
				[ServerId, MyRoleId, ToDayGuessRecordList]);
		_ ->
			ok
	end;

%%竞猜记录列表
do_handle(65082, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, []) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, sid = Sid} = PS,
	case Team3v3 of
		#role_3v3_new{guess_record = RecordList} ->
			F = fun(Record, AccList) ->
				#role_guess_record{
					turn = Turn,
					team_a_id = TeamAid,
					team_b_id = TeamBId,
					team_a = TeamAName,
					team_b = TeamBName,
					opt = Opt,
					res = Result,
					reward = Reward,
					pk_res = PkRes,
					status = Status,
					time = Time
				} = Record,
%%				?MYLOG("3v3", "Reward ~p~n", [Reward]),
				case Reward of
					[{?TYPE_CURRENCY, RewardType, Num} | _] ->
						ok;
					[{RewardType, 0, Num} | _] ->
						ok;
					_ ->
						RewardType = 0,
						Num = 0
				end,
				RightOpt = get_right_opt(Turn, PkRes),
%%				?PRINT("RightOpt ~p~n", [RightOpt]),
				[{Turn, TeamAid, TeamBId, TeamAName, TeamBName, Opt, Result, RewardType, Num, RightOpt, Status, Time} | AccList]
			    end,
			PackList = lists:reverse(lists:foldl(F, [], RecordList)),
%%			?MYLOG("guess", "PackList ~p~n", [PackList]),
			{ok, Bin} = pt_650:write(65082, [PackList]),
			lib_server_send:send_to_sid(Sid, Bin);
		_ ->
			ok
	end;


%%竞猜列表
do_handle(65083, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [Turn, TeamAId, TeamBId, Time]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, sid = Sid} = PS,
	case Team3v3 of
		#role_3v3_new{guess_record = RecordList} ->
			case lists:keyfind({Turn, TeamAId, TeamBId, utime:unixdate(Time)}, #role_guess_record.key, RecordList) of
				#role_guess_record{status = Status, reward = Reward} = Record->
					if
						Status == 0 ->
							send_error(MyRoleId, ?ERRCODE(err650_can_not_get_guess_reward));
						Status == 2 ->
							send_error(MyRoleId, ?ERRCODE(err650_have_got_guess_reward));
						true ->
							lib_goods_api:send_reward_with_mail(MyRoleId, #produce{reward = Reward, type = guess_3v3_reward}),
							NewRecord = Record#role_guess_record{status = 2},
							lib_3v3_local:save_guess_record_to_db(MyRoleId, NewRecord),
							NewRecordList = lists:keystore({Turn, TeamAId, TeamBId, utime:unixdate(Time)}, #role_guess_record.key, RecordList, NewRecord),
							NewTeam3v3 = Team3v3#role_3v3_new{guess_record = NewRecordList},
							{ok, Bin} = pt_650:write(65083, [?SUCCESS, Reward]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, PS#player_status{team_3v3 = NewTeam3v3}}
					end;
				_ ->
					send_error(MyRoleId, ?ERRCODE(err650_not_have_guess_record))
			end;
		_ ->
			ok
	end;

%%战队详细信息
do_handle(65084, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [TeamId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId} = PS,
	mod_clusters_node:apply_cast(mod_3v3_champion, champion_team_detail_msg, [ServerId, MyRoleId, TeamId]);




%%竞猜中的战力对比
do_handle(65085, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [TeamAId, TeamBId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId} = PS,
	if
		TeamAId == 0 orelse  TeamBId == 0 -> %% 队伍被轮空了
			ok;
		true ->
			mod_clusters_node:apply_cast(mod_3v3_champion, power_compare, [ServerId, MyRoleId, TeamAId, TeamBId])
	end;


%%观战
do_handle(65086, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [TeamId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId, scene = Scene} = PS,
	case lib_3v3_api:is_3v3_scene(Scene) of
		true ->
			send_error(MyRoleId, ?ERRCODE(err650_yet_in_3v3_scene));
		false ->
			mod_clusters_node:apply_cast(mod_3v3_champion, observed, [ServerId, MyRoleId, TeamId])
	end;

%%退出观战
do_handle(65087, #player_status{id = MyRoleId, team_3v3 = Team3v3} = PS, [TeamId]) ->
	#player_status{team_3v3 = Team3v3, id = MyRoleId, server_id = ServerId, scene = Scene} = PS,
	case lib_3v3_api:is_3v3_scene(Scene) of
		true ->
			mod_clusters_node:apply_cast(mod_3v3_champion, quit_observed, [ServerId, MyRoleId, TeamId]);
		false ->
			send_error(MyRoleId, ?ERRCODE(err650_not_in_3v3_scene))
	end;


%%退出观战
do_handle(65088, #player_status{id = MyRoleId, server_id = ServerId} = _PS, []) ->
	mod_clusters_node:apply_cast(mod_3v3_champion, stage_msg, [ServerId, MyRoleId]);














do_handle(_Cmd, Status, _Recv) ->
	{ok, Status}.

send_error(RoleId, Error) ->
	?MYLOG("3v3", "Error ~p~n", [Error]),
	{ok, Bin} = pt_650:write(65001, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).

get_send_pack_reward(PackReward, DailyPk) ->
	F = fun({Count, Status}, AccList) ->
		if
			Status > 2 ->
				[{Count, 2} | AccList];
			true ->
				if
					DailyPk >= Count ->
						[{Count, 1} | AccList];
					true ->
						[{Count, 0} | AccList]
				end
		end
	    end,
	lists:reverse(lists:foldl(F, [], PackReward)).


get_right_opt(Turn, _Res) ->
	case _Res of
		[{_, Res} | _] ->
			ok;
		_ ->
			Res = 1
	end,
	case data_3v3:get_guess_config(Turn) of
		#base_guess_config{opt_list = OptList} ->
			get_right_opt2(OptList, Res);
		_ ->
			1
	end.

get_right_opt2([], _Res) ->
	1;
get_right_opt2([{Opt, Value} | T], Res) ->
	if
		Value == Res ->
			Opt;
		true ->
			get_right_opt2(T, Res)
	end;
get_right_opt2([{Opt, Value1, Value2} | T], Res) ->
	if
		Res >= Value1 andalso Res =< Value2 ->
			Opt;
		true ->
			get_right_opt2(T, Res)
	end.
