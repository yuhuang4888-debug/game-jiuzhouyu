%%% ----------------------------------------------------
%%% @Module:        lib_3v3_local
%%% @Author:        zhl
%%% @Description:   跨服3v3
%%% @Created:       2017/07/05
%%% ----------------------------------------------------

-module(lib_3v3_local).

%% API
-compile(export_all).
%%-export([
%%        load_act_time/0,
%%
%%        login/1,                              %% 玩家上线
%%        daily_check/1,                        %% 日常更新
%%        calc_tier_by_star/2,                  %% 根据星数计算段位
%%        reconnect/2,                          %% 重连
%%        logout/1,                             %% 玩家下线
%%        handle_player_disconnect/2,           %% 玩家关闭客户端当下线
%%        leave_pk_room/1,                      %% 跨服3v3 - 离开战场
%%        % enter_pk_room/1,                      %% 跨服3v3 - 重登进入战场
%%        % player_die/3,                         %% 玩家死亡
%%
%%        change_status/2,                      %% 修改玩家状态
%%        cast_change_status/2,
%%        clear_role_status/1,
%%
%%        replace_role_3v3/2,                   %% 更新数据库
%%
%%        send_team_data/2,                     %% 推送队伍信息
%%        send_team_list/2,                     %% 推送队伍列表
%%        send_power_contrast/1,                %% 推送双方的战力对比
%%        send_battle_info/1,                   %% 推送战场信息
%%        send_page_rank/1,                     %% 获取荣誉排行榜
%%        cast_send_page_rank/2,
%%        send_pk_result/1,                     %% 推送战斗结算
%%        cast_send_pk_result/2,
%%        send_rank_rewards/1,                  %% 发送周榜奖励
%%        send_msg_to_team/1,                   %% 接受队伍消息
%%
%%        pack_team_info/1,                     %% 打包队伍信息
%%        pack_team_info/2,
%%        pack_team_list/3,                     %% 打包队伍列表
%%        pack_team_data/1,                     %% 打包队伍信息
%%
%%        is_in_team/1,                         %% 是否在队伍中
%%
%%        kick_out_room/2,                      %% 将房间内所有玩家踢出场景
%%        cast_kick_out_room/2,                 %% 将房间内所有玩家踢出场景 - cast
%%
%%        get_unite_role_data/1,                %% 获取玩家参与数据
%%        get_unite_team_data/1,                %% 找到玩家的队伍数据
%%        to_role_data/2                        %% 转换#role_data{}
%%        ,fix_bug/0
%%        ,new_season_handle/0                  %% 新赛季的处理
%%		,get_send_client_fame_reward/2        %% 处理声望领取列表
%%        ,get_score_add_by_ratio/2
%%        ,delay_stop/1
%%        ,repair/0                             %% 修复数据
%%        ,repair/1                             %% 修复错误段位
%%
%%        % open_call_member/1,                   %% 公开招募队友
%%%%        zero_time/1
%%    ]).

%% 修复逻辑
-export([
	get_tier_respond/3
	, setup_player_tier/3
	, repair_tier/1
]).

-include("server.hrl").
%%-include("train.hrl").
-include("battle.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("3v3.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("clusters.hrl").

%% 读取活动时间
load_act_time() ->
	ActList = data_3v3:get_act_list(),
	DayOfWeek = utime:day_of_week(),
	NowSec = utime:get_seconds_from_midnight(),
	F = fun(ActID, List) ->
		case data_3v3:get_act_info(ActID) of
			#act_info{week = WeekList, time = [StarTime, EndTime]} ->
				IsToday = lists:member(DayOfWeek, WeekList),
				StTime = calendar:time_to_seconds(StarTime),
				EdTime = calendar:time_to_seconds(EndTime),
				IsNotEnd = EdTime > NowSec,
				if
					IsToday andalso IsNotEnd ->
						[{StTime, EdTime} | List];
					true ->
						List
				end;
			_ ->
				List
		end
	    end,
	case sort_time(lists:foldl(F, [], ActList)) of
		[] -> [];
		[ActTime | _] -> ActTime
	end.

sort_time(TimeList) ->
	F = fun({StTime1, _}, {StTime2, _}) ->
		StTime1 < StTime2
	    end,
	lists:sort(F, TimeList).

daily_check(Player) ->
	#role_3v3{
		old_tier = OldTier, old_star = OldStar, tier = Tier, star = Star,
		continued_win = ContinuedWin, daily_win = DailyWin, daily_pk = DailyPK,
		daily_honor = DailyHonor, pack_time = PackTime, pack_reward = PackReward,
		daily_time = DailyTime,
		fame_reward = FameReward,
		yesterday_tier = YesterdayTier
	} = Player#player_status.role_3v3,
	Role3v3 = calc_inherit_tier(Player#player_status.id, [OldTier, OldStar, Tier, Star, ContinuedWin, DailyWin,
		DailyPK, DailyHonor, PackReward, PackTime, FameReward, YesterdayTier], DailyTime),
	NewPlayer = Player#player_status{role_3v3 = Role3v3},
	pp_3v3:handle(65000, NewPlayer, []),
	IsSameMonth = is_same_season(DailyTime, utime:unixtime()),
	if
		IsSameMonth == false ->%%新赛季，
			%%清除计数器
			mod_counter:set_count(Player#player_status.id, ?MOD_KF_3V3, ?kf_3v3_count_win_id, 0),
			mod_counter:set_count(Player#player_status.id, ?MOD_KF_3V3, ?kf_3v3_count_match_id, 0),
			%%清除声望值
			Fame = lib_goods_api:get_currency(NewPlayer, ?GOODS_ID_3V3_HONOR),
			if
				Fame > 0 ->
					case lib_goods_api:cost_object_list_with_check(NewPlayer, [{?TYPE_CURRENCY, ?GOODS_ID_3V3_HONOR, Fame}], kf_3v3_season_end, "kf_3v3_season_end") of
						{true, LastPs} ->
							LastPs;
						_ ->
							NewPlayer
					end;
				true ->
					NewPlayer
			end;
		true ->
			NewPlayer
	end.

%% 玩家上线
login([RoleID]) ->
	DB = db:get_row(io_lib:format(<<"select old_tier, old_star, tier, star, continued_win, daily_win,
    daily_pk, daily_honor, pack_reward, pack_time, daily_time, fame_reward, yesterday_tier from role_3v3 where role_id = ~w">>, [RoleID])),
	case DB of
		[
			OldTier, OldStar, Tier, Star, ContinuedWin, DailyWin,
			DailyPK, DailyHonor, PackRewardBin, PackTime, DailyTime, FameRewardBin, YesterdayTier
		] ->
			_FameReward = util:bitstring_to_term(FameRewardBin),
			FameReward = ?IF(_FameReward == [], init_fame_reward(), _FameReward),
			calc_inherit_tier(RoleID, [OldTier, OldStar, Tier, Star, ContinuedWin, DailyWin,
				DailyPK, DailyHonor, util:bitstring_to_term(PackRewardBin), PackTime, FameReward, YesterdayTier], DailyTime);
		_ ->
			#role_3v3{pack_reward = [{I, 0} || I <- data_3v3:get_act_rewards_list()], daily_time = utime:unixtime(), fame_reward = init_fame_reward()}
	end.


login2(PS) ->
	DB = db:get_row(io_lib:format(<<"select  leader_id, team_id, team_name from    team_3v3_role_in_ps where role_id = ~p">>, [PS#player_status.id])),
	case DB of
		[
			LeaderId, TeamId, TeamName
		] ->
%%			%%通知战队登录了
%%			mod_3v3_team:role_login(TeamId, PS#player_status.id),
			lib_role:update_role_show(PS#player_status.id, [{team_3v3_id, TeamId}]),
			Role3v3New = #role_3v3_new{team_name = TeamName, leader_id = LeaderId, team_id = TeamId};
		_ ->
			Role3v3New = #role_3v3_new{}
	end,
	LastRoleNew = init_guess_record(Role3v3New, PS#player_status.id),
%%	?MYLOG("3v3", "LastRoleNew ~p~n", [LastRoleNew]),
	PS#player_status{team_3v3 = LastRoleNew}.

calc_inherit_tier(RoleID, [OldTier, OldStar, Tier, Star, ContinuedWin, DailyWin,
	DailyPK, DailyHonor, PackReward0, PackTime, FameReward, YesterdayTier], DailyTime) ->
	NowTime = utime:unixtime(),
	IsToday = utime:is_today(DailyTime),
	IsSameMonth = is_same_season(DailyTime, NowTime),
	Role3v3 = if
		          IsToday ->
			          RwIds = data_3v3:get_act_rewards_list(),
			          PackReward = lists:foldr(fun(I, Acc) ->
				          case lists:keyfind(I, 1, PackReward0) of
					          {I, C} ->
						          [{I, C} | Acc];
					          _ ->
						          [{I, 0} | Acc]
				          end
			                                   end, [], RwIds),
			          #role_3v3{
				          old_tier = OldTier, old_star = OldStar, tier = Tier, star = Star,
				          continued_win = ContinuedWin, daily_win = DailyWin, daily_pk = DailyPK,
				          daily_honor = DailyHonor, pack_time = PackTime, pack_reward = PackReward, fame_reward = FameReward
				          , daily_time = DailyTime, yesterday_tier = YesterdayTier
			          };
		          IsSameMonth == false -> %%不是同一个赛季
			          case data_3v3:get_inherit_tier(Tier) of
				          false -> %% 没有配置
					          NTier = Tier, NStar = Star;
				          NTier ->
					          #tier_info{star = NStar} = data_3v3:get_tier_info(NTier)
			          end,
			          lib_log_api:log_3v3(RoleID, 2, Tier, Star, NTier, NStar, 0, 0, []), %% 3v3段位继承日志
			          #role_3v3{old_tier = NTier, old_star = NStar, tier = NTier, star = NStar,
				          fame_reward = init_fame_reward(),
				          pack_reward = [{I, 0} || I <- data_3v3:get_act_rewards_list()]
				          , daily_time = NowTime};
		          true -> %%不是同一天，但是是同一个赛季
			          #role_3v3{old_tier = Tier, old_star = Star, tier = Tier, star = Star, daily_honor = DailyHonor,
				          fame_reward = FameReward,
				          pack_reward = [{I, 0} || I <- data_3v3:get_act_rewards_list()]
				          , daily_time = NowTime, yesterday_tier = Tier}
	          end,
	#role_3v3{tier = NTier2, star = NStar2} = Role3v3,
	{NTier3, NStar3} = calc_tier_by_star(NTier2, NStar2),
	Res = Role3v3#role_3v3{tier = NTier3, star = NStar3},
	case not IsToday orelse NTier3 =/= Tier orelse NStar3 =/= Star of
		true ->
			replace_role_3v3(RoleID, Res);
		_ ->
			ok
	end,
	Res.

%% 根据星数计算段位
%% @return {Tier, Star}
calc_tier_by_star(Tier, Star) ->
	KeyList = data_3v3:get_tier_and_star_info(),
	do_calc_tier_by_star(KeyList, {Tier, Star}).

do_calc_tier_by_star([], {Tier, Star}) -> {Tier, Star};
do_calc_tier_by_star([{TmpTier, TmpStar} | T], {Tier, Star}) ->
	case Star >= TmpStar of
		true -> do_calc_tier_by_star(T, {TmpTier, Star});
		false -> {Tier, Star}
	end.

%% 重连
reconnect(Player, LogType) when LogType == ?RE_LOGIN orelse LogType == ?RE_LOGIN ->
	#player_status{
		id = _RoleID, server_name = _ServerName, server_num = _ServerNum, server_id = _ServerId,
		sid = _RoleSid, figure = #figure{lv = RoleLv}, scene = SceneID, action_lock = Lock, team_3v3 = Team3v3
		,battle_attr = BA, x = OldX, y = OldY
	} = Player,
	Is3v3Scene = lib_3v3_api:is_3v3_scene(SceneID),
%%	?MYLOG("cym", "Lock ~p~n", [Lock]),
	#role_3v3_new{is_in_champion_pk = ChampionPK} = Team3v3,
	#battle_attr{hp=OldHp, hp_lim= HpLim, group = GroupId} = BA,
	IsIn3v3 = Lock == ?ERRCODE(err650_in_kf_3v3_act)  orelse   Lock == ?ERRCODE(err650_in_kf_3v3_act_single) orelse
		ChampionPK == 1,
	if
		RoleLv < ?KF_3V3_LV_LIMIT -> {next, Player};
		true ->
			if
				IsIn3v3 == false  andalso  Is3v3Scene == true->  %% 异常情况
					NewPS = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 100}, {ghost, 0}, {group, 0}]),
					{ok, NewPS};
				Is3v3Scene == true ->
%%                    mod_clusters_node:apply_cast(mod_3v3_center, enter_pk_room, [[ServerName, ServerNum, ServerId, RoleID, RoleSid, Is3v3Scene]]),
					Hp          = HpLim,
					if
						OldHp > 0 ->
							Player1 = lib_scene:change_relogin_scene(Player, [{change_scene_hp_lim, 100}, {ghost, 0}]);
						true ->
							case lib_3v3_center:revive(GroupId) of
								[{x, X}, {y, Y}] ->
									ok;
								_ ->
									X = OldX,
									Y = OldY
							end,
							Player1 = lib_scene:change_relogin_scene(Player#player_status{x = X, y = Y}, [{change_scene_hp_lim, 100}])
					end,
					{ok, Player1};
				true ->
					{next, Player}
			end
	
	end;
reconnect(Player, _LogType) ->
	{next, Player}.

%% 玩家下线
logout(#player_status{
	server_name = ServerName, server_num = ServerNum, server_id = ServerId, id = RoleID, sid = RoleSid,
	figure = #figure{lv = RoleLv}, scene = SceneID, role_3v3 = Role3v3, team_3v3 = Team3v3
}) ->
	Is3v3Scene = lib_3v3_api:is_3v3_scene(SceneID),
	if
		RoleLv < ?KF_3V3_LV_LIMIT -> skip;
		true -> mod_3v3_local:logout([ServerName, ServerNum, ServerId, RoleID, RoleSid, ?PK_3V3_OFFLINE, Is3v3Scene])
	% Is3v3Scene -> leave_pk_room([Platform, ServerNum, RoleID, ?PK_3V3_OFFLINE, ServerId, Is3v3Scene]);
	% true ->
	%     %% 将本服跟跨服的玩家数据删除
	%     mod_3v3_local:leave_team([Platform, ServerNum, ServerId, RoleID, RoleSid])
	end,
	case Team3v3 of
		#role_3v3_new{team_id = TeamId, is_in_champion_pk = IsChampionPk} when TeamId > 0 ->
			%%
			IsInChampionWaitScene = lib_3v3_api:is_3v3_champion_scene(SceneID),
			if
				IsChampionPk == 1 ->
					mod_clusters_node:apply_cast(mod_3v3_champion, quit_scene, [TeamId, RoleID, node()]);
				IsInChampionWaitScene == true ->
					mod_clusters_node:apply_cast(mod_3v3_champion, quit_scene, [TeamId, RoleID, node()]);
				true ->
					%% 去取消匹配，如果是离线的话
					mod_clusters_node:apply_cast(mod_3v3_team, stop_match, [TeamId, config:get_server_id(), RoleID])
%%					mod_3v3_team:stop_match(TeamId, RoleID)
			
			end;
		_ ->
			ok
	end,
	replace_role_3v3(RoleID, Role3v3#role_3v3{daily_time = utime:unixtime()}).

replace_role_3v3(RoleID, Role3v3) ->
	%% 保存跨服3v3 数据
	case Role3v3 of
		#role_3v3{
			old_tier = OldTier, old_star = OldStar, tier = Tier, star = Star,
			continued_win = ContinuedWin, daily_win = DailyWin, daily_pk = DailyPK,
			daily_honor = DailyHonor, pack_time = PackTime, pack_reward = PackReward, fame_reward = FameReward,
			daily_time = DailyTime, yesterday_tier = YesterdayTier
		} ->
			PackRewardBin = util:term_to_bitstring(PackReward),
			FameRewardBin = util:term_to_bitstring(FameReward),
			SQL = io_lib:format(?SQL_REPLACE_3V3_ROLE, [RoleID, OldTier, OldStar,
				Tier, Star, ContinuedWin, DailyWin, DailyPK, DailyHonor, PackRewardBin,
				PackTime, DailyTime, FameRewardBin, YesterdayTier]),
			db:execute(SQL);
		_ -> skip
	end.

%% 跨服3v3 - 离开战场
leave_pk_room([ServerName, ServerNum, RoleID, Type, ServerId, Is3v3Scene]) ->
	mod_clusters_node:apply_cast(mod_3v3_center, leave_pk_room, [[ServerName, ServerNum, RoleID, Type, ServerId, Is3v3Scene]]).

% %% 跨服3v3 - 重登进入战场
% enter_pk_room(#player_status{
%         platform = Platform, server_num = ServerNum, id = RoleID, sid = RoleSid,
%         figure = #figure{lv = RoleLv}
%     }) ->
%     if
%         RoleLv < ?KF_3V3_LV_LIMIT -> 
%             skip;
%         true ->
%             mod_clusters_node:apply_cast(mod_3v3_center, enter_pk_room, [[Platform, ServerNum, RoleID, RoleSid]])
%     end,
%     ok.

% zero_time(#player_status{id = RoleID, role_3v3 = Role3v3} = Status) ->
%     #role_3v3{tier = Tier, star = Star} = Role3v3,
%     DayOfWeek = utime:day_of_week(utime:unixtime() + 10),
%     if
%         DayOfWeek == 7 -> %% 是周一的话，今日段位是继承后的段位
%             case data_3v3:get_inherit_tier(Tier) of
%                 false -> %% 没有配置
%                     NTier = Tier, NStar = Star;
%                 NTier ->
%                     #tier_info{star = NStar} = data_3v3:get_tier_info(NTier)
%             end,
%             lib_log_api:log_3v3(RoleID, 2, Tier, Star, NTier, NStar, 0, 0), %% 3v3段位继承日志
%             NRole3v3 = #role_3v3{old_tier = Tier, old_star = Star, tier = NTier, star = NStar};
%         true ->
%             NRole3v3 = #role_3v3{old_tier = Tier, old_star = Star, tier = Tier, star = Star}
%     end,
%     case NRole3v3 of
%         Role3v3 -> skip;
%         _ ->
%             replace_role_3v3(RoleID, NRole3v3)
%     end,
%     NStatus = Status#player_status{role_3v3 = NRole3v3},
%     pp_3v3:handle(65000, NStatus, []),
%     NStatus.

%% 获取玩家参与数据
%% @return : {ok, UniteRoleData} | {false, ResID, TeamID}
%% @desc : 注意，这个方法只能在mod_3v3_local进程中使用
get_unite_role_data([_Platform, _ServerNum, RoleID]) ->
	% case ets:match_object(?ETS_ROLE_DATA, #kf_3v3_role_data{
	%         platform = Platform, server_num = ServerNum, role_id = RoleID, _ = '_'})
	% of
	%     [#kf_3v3_role_data{} = UniteRoleData] -> %% 参与过跨服3v3
	%         Ret = {ok, UniteRoleData};
	%     _ -> %% 不曾参与过跨服3v3
	%         Ret = {false, ?ERRCODE(err650_kf_3v3_not_joined)}
	% end,
	% Ret;
	get_unite_role_data(RoleID);
get_unite_role_data(RoleID) ->
	case ets:lookup(?ETS_ROLE_DATA, RoleID) of
		[#kf_3v3_role_data{} = UniteRoleData] -> %% 参与过跨服3v3
			Ret = {ok, UniteRoleData};
		_ -> %% 不曾参与过跨服3v3
%%			?MYLOG("3v32", "err650_kf_3v3_not_joined ~n", []),
			Ret = {false, ?ERRCODE(err650_kf_3v3_not_joined)}
	end,
	Ret.

%% 找到玩家的队伍数据
%% @desc : 注意这方法只能在mod_3v3_center进程中使用
get_unite_team_data(TeamID) when is_integer(TeamID) andalso TeamID > 0 ->
	case ets:lookup(?ETS_TEAM_DATA, TeamID) of
		[#kf_3v3_team_data{} = TeamData] ->
			{ok, TeamData};
		_ ->
			{false, ?ERRCODE(err650_kf_3v3_not_joined)}
	end;
get_unite_team_data(_) ->
	{false, ?ERRCODE(err650_kf_3v3_not_joined)}.

%% 转换#role_data{}
to_role_data(Status, [PowerLimit, LvLimit, Password, IsAuto]) ->
	#player_status{
		server_name = ServerName, server_num = ServerNum, server_id = ServerId, id = RoleID, sid = RoleSid,
		figure = Figure, combat_power = Power, role_3v3 = Role3v3,
		scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y
	} = Status,
	% FashionID = lib_role_fashion:get_fash(Status),
	% TWeapon = lib_role_train:get_sub_train_grade(?TWEAPON, RoleTrains),
	% TFly = lib_role_train:get_sub_train_grade(?TFLY, RoleTrains),
	case Role3v3 of
		#role_3v3{continued_win = ContinuedWin} -> ok;
		_ -> ContinuedWin = 0
	end,
	Node = mod_disperse:get_clusters_node(),
	#role_data{
		node = Node, server_name = ServerName, server_num = ServerNum, server_id = ServerId,
		role_id = RoleID, sid = RoleSid, figure = Figure, power = Power,
		power_limit = PowerLimit, lv_limit = LvLimit, password = Password,
		is_auto = IsAuto, tier = 1, star = 1, continued_win = ContinuedWin,
		is_single = ?is_single,
		old_scene_info = {SceneId, ScenePoolId, CopyId, X, Y}
	}.

%% 打包队伍信息
pack_team_info([]) ->
	[?SUCCESS, 0, 0, 0, 0, 0, 0, []];
pack_team_info(TeamData) ->
	#kf_3v3_team_data{
		team_id = TeamID, captain_id = CaptainID, is_auto = IsAuto,
		power_limit = PowerLimit, lv_limit = LvLimit, password = Password,
		member_data = MemberData
	} = TeamData,
	Data = pack_member_data(MemberData, CaptainID, []),
	[?SUCCESS, TeamID, PowerLimit, LvLimit, Password, IsAuto, CaptainID, Data].

pack_team_info(Type, []) ->
	[Type, 0, 0, 0, 0, 0, 0, []].

%% 打包队友信息
pack_member_data([], _, MemberData) ->
	MemberData;
pack_member_data([Member | Rest], CaptainID, MemberData) ->
	#kf_3v3_role_data{
		server_name = ServerName, server_num = ServerNum, server_id = ServerId, role_id = RoleID,
		figure = #figure{name = Nickname, career = Career, sex = Sex, turn = Turn, picture = Picture, picture_ver = PictureVer}, power = Power,
		% nickname = Nickname, sex = Sex,
		% fashion_id = FashionID, train_weapon = TWeapon, train_fly = TFly,
		is_ready = IsReady
	} = Member,
	if
		CaptainID == RoleID ->
			IsCaptain = 1;
		true ->
			IsCaptain = 0
	end,
	FashionID = 0, TWeapon = 0, TFly = 0,
	Data = {
		ServerName, ServerNum, ServerId, RoleID, Nickname, Career, Sex, Turn, Power, FashionID,
		TWeapon, TFly, IsCaptain, IsReady, Picture, PictureVer
	},
	pack_member_data(Rest, CaptainID, [Data | MemberData]).

%% 打包队伍列表
pack_team_list(ResID, [], _) ->
	[ResID, []];
pack_team_list(ResID, TeamList, _ServerId) ->
	F = fun(#kf_3v3_team_data{
		team_id = TeamID, server_name = ServerName, server_num = ServerNum,
		server_id = _TServerId, captain_id = CaptainID, captain_name = Nickname,
		member_num = MemberNum, power_limit = PowerLimit, lv_limit = LvLimit,
		password = Password, is_auto = IsAuto, member_data = MemberData, is_pk = IsPk
	}, List) ->
		ErrUpdateTeamList = ?ERRCODE(err650_kf_3v3_update_teamlist),
		ErrUpdateTeam = ?ERRCODE(err650_kf_3v3_update_team),
		ErrDeleteTeam = ?ERRCODE(err650_kf_3v3_delete_team),
		if
		%% 战斗中的不处理
			IsPk == 1 -> List;
		%% 筛选本服创建的队伍
			(
				(ResID == ErrUpdateTeamList orelse ResID == ErrUpdateTeam)
%%                    andalso TServerId == ServerId
			) orelse ResID == ErrDeleteTeam ->
				if
					Password > 0 -> IsPassword = 1;
					true -> IsPassword = 0
				end,
				case lists:keytake(CaptainID, #kf_3v3_role_data.role_id, MemberData) of
					false -> CareerList = [];
					{value, #kf_3v3_role_data{figure = #figure{career = Career}}, RestMemberData} ->
						RestCareerList = [TmpCareer || #kf_3v3_role_data{figure = #figure{career = TmpCareer}} <- RestMemberData],
						CareerList = [Career | RestCareerList]
				end,
				case lists:keyfind(CaptainID, #kf_3v3_role_data.role_id, MemberData) of
					#kf_3v3_role_data{power = Power, figure = #figure{lv = RoleLv}} ->
						[{TeamID, ServerName, ServerNum, CaptainID, Nickname, RoleLv, Power,
							MemberNum, PowerLimit, LvLimit, IsPassword, IsAuto, CareerList} | List];
					_ ->
						List
				end;
			true -> List
		end
	    end,
	[ResID, lists:foldl(F, [], TeamList)].

%% 打包队伍信息
pack_team_data(#kf_3v3_team_data{
	team_id = TeamID, server_name = ServerName,
	server_num = ServerNum, captain_id = CaptainID, captain_name = Nickname,
	member_num = MemberNum, power_limit = PowerLimit, lv_limit = LvLimit,
	password = Password, is_auto = IsAuto, member_data = MemberData
}) ->
	if
		Password > 0 -> IsPassword = 1;
		true -> IsPassword = 0
	end,
	case lists:keyfind(CaptainID, #kf_3v3_role_data.role_id, MemberData) of
		#kf_3v3_role_data{power = Power, figure = #figure{lv = RoleLv}} ->
			[?SUCCESS, TeamID, ServerName, ServerNum, CaptainID, Nickname,
				RoleLv, Power, MemberNum, PowerLimit, LvLimit, IsPassword, IsAuto];
		_ ->
			[?SUCCESS, 0, "", 0, 0, "", 0, 0, 0, 0, 0, 0, 0]
	end;
pack_team_data(_) ->
	[?SUCCESS, 0, "", 0, 0, "", 0, 0, 0, 0, 0, 0, 0].

%% 是否在队伍中
%% @desc : 注意，这个方法只允许mod_3v3_local进程使用
is_in_team(RoleID) ->
	case ets:lookup(?ETS_ROLE_DATA, RoleID) of
		[#kf_3v3_role_data{team_id = TeamID}] when TeamID > 0 ->
			Ret = {false, ?ERRCODE(err650_kf_3v3_in_team)};
		[#kf_3v3_role_data{} = UniteRoleData] ->
			Ret = {ok, UniteRoleData};
		_ -> %% 不曾参与过跨服3v3
			Ret = {ok, #kf_3v3_role_data{}}
	end,
	Ret.

%% 将房间内所有玩家踢出场景
kick_out_room(RoleID, OldSceneInfo) ->
	% Pid = misc:get_player_process(RoleID),
	% case misc:is_process_alive(Pid) of
	%     true ->
	%         MFA = {lib_3v3_local, cast_kick_out_room, []},
	%         gen_server:cast(Pid, {apply_cast_save, MFA});
	%     _ -> skip
	% end.
	lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_kick_out_room, [OldSceneInfo]),
	ok.

%% 将房间内所有玩家踢出场景
cast_kick_out_room(#player_status{scene = SceneID} = Status, OldSceneInfo) ->
	case lib_3v3_api:is_3v3_scene(SceneID) of
		true ->
			KeyValueList = [{group, 0}, {change_scene_hp_lim, 0}],
			?MYLOG("3v3", "KeyValueList ~p~n", [KeyValueList]),
			case OldSceneInfo of
				{OldScene, OldScenePooldId, OldCopyId, OldX, OldY} ->
					NStatus = lib_scene:change_scene(Status, OldScene, OldScenePooldId, OldCopyId, OldX, OldY, false, KeyValueList);
				_ ->
					NewSceneId = ?MAIN_CITY_SCENE,
					{X, Y} = lib_scene:get_main_city_x_y(),
					NStatus = lib_scene:change_scene(Status, NewSceneId, 0, 0, X, Y, false, KeyValueList)
			end,
			{ok, NStatus};
		false ->
			{ok, Status}
	end.

change_status(MemberData, RoleStatus) ->
	F = fun(#kf_3v3_role_data{node = Node, role_id = RoleID}) ->
		Pid = misc:get_player_process(RoleID),
		case is_pid(Pid) andalso Node == node() of
			true ->
				% MFA = {?MODULE, cast_change_status, [RoleStatus]},
				% gen_server:cast(Pid, {apply_cast_save, MFA});
				lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, cast_change_status, [RoleStatus]);
			_ -> skip
		end
	    end,
	lists:foreach(F, MemberData).

cast_change_status(Status, RoleStatus) ->
%%	?MYLOG("lock", "RoleStatus ~p~n", [RoleStatus]),
	#player_status{action_lock = Lock} = Status,
%%	?MYLOG("lock", "Lock ~p~n", [Lock]),
	if
		RoleStatus == free ->
			lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, handle_player_disconnect),
			LockTeam = ?ERRCODE(err650_in_kf_3v3_act),
			?MYLOG("lock", "LockTeam ~p~n", [LockTeam]),
			case Lock of
				LockTeam ->
					KeyValueList = [{action_free, ?ERRCODE(err650_in_kf_3v3_act)}, {group, 0}];
				_ ->
					KeyValueList = [{action_free, ?ERRCODE(err650_in_kf_3v3_act_single)}, {group, 0}]
			end;
		Lock =/= free ->
			KeyValueList = [];
		true ->
			lib_player_event:add_listener(?EVENT_DISCONNECT, ?MODULE, handle_player_disconnect),
			KeyValueList = [{action_lock, RoleStatus}]
	end,
	?MYLOG("lock", "KeyValueList ~p~n", [KeyValueList]),
	mod_server_cast:set_data_sub(KeyValueList, Status).

%% 清理所有玩家状态(开始结束通知)
clear_role_status(MemberData) ->
	F = fun(#kf_3v3_role_data{node = Node, role_id = RoleID}) ->
		Pid = misc:get_player_process(RoleID),
		case is_pid(Pid) andalso Node == node() of
			true ->
				{ok, BinData} = pt_650:write(65017, [?SUCCESS]),
				lib_server_send:send_to_uid(RoleID, BinData);
			_ ->
				skip
		end
	    end,
	lists:foreach(F, MemberData).

%% 推送队伍信息
send_team_data([], _) ->
	ok;
send_team_data([#kf_3v3_role_data{node = Node} | Rest], Data) when node() /= Node ->
	send_team_data(Rest, Data);
send_team_data([#kf_3v3_role_data{role_id = RoleId} | Rest], Data) ->
%%	?MYLOG("3v3", "Data ~p ~n", [Data]),
	{ok, Bin} = pt_650:write(65010, Data),
	lib_server_send:send_to_uid(RoleId, Bin),
	send_team_data(Rest, Data).

%% 推送队伍列表
send_team_list([], _) ->
	ok;
send_team_list([#attention_list{sid = RoleSid} | Rest], Data) ->
	{ok, Bin} = pt_650:write(65011, Data),
	lib_server_send:send_to_sid(RoleSid, Bin),
	send_team_list(Rest, Data).

%% 发送双方的战力对比
send_power_contrast([RoleID, Data]) ->
%%	?MYLOG("3v3", "send_power_contrast ~p~n", [Data]),
	{ok, Bin} = pt_650:write(65029, [Data]),
	lib_server_send:send_to_uid(RoleID, Bin).

%% 发送战场信息
send_battle_info([RoleId, Data]) ->
%%	?MYLOG("pk", "Data ~p~n", [Data]),
	{ok, Bin} = pt_650:write(65030, Data),
	lib_server_send:send_to_uid(RoleId, Bin).

%% 获取荣誉排行榜
send_page_rank([RoleID, Page, RankID, RankList]) ->
	% Pid = misc:get_player_process(RoleID),
	% case is_pid(Pid) andalso misc:is_process_alive(Pid) of
	%     true ->
	%         MFA = {lib_3v3_local, cast_send_page_rank, [[Page, RankID, RankList]]},
	%         gen_server:cast(Pid, {apply_cast_save, MFA});
	%     _ -> skip
	% end.
	lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_send_page_rank,
		[[Page, RankID, RankList]]),
	ok.

cast_send_page_rank(#player_status{sid = RoleSid, role_3v3 = Role3v3} = Status,
	[Page, RankID, RankList]) ->
	#role_3v3{old_tier = OldTier, old_star = OldStar, pack_time = PackTime} = Role3v3,
	case data_3v3:get_tier_info(OldTier) of
		#tier_info{daily_reward = DailyHonor} -> ok;
		_ -> DailyHonor = 0
	end,
	IsToday = utime:is_today(PackTime),
	if
		IsToday -> NRole3v3 = Role3v3;
		true ->
			NRole3v3 = Role3v3#role_3v3{daily_honor = DailyHonor}
	end,
	FormatRankList = [{
		ServerName,
		ServerNum,
		ServerId,
		RoleId,
		RoleName,
		Career,
		Sex,
		GradeNum,
		StartNum,
		Power} || #kf_3v3_rank_data{
		server_name = ServerName,
		server_num = ServerNum,
		server_id = ServerId,
		role_id = RoleId,
		nickname = RoleName,
		career = Career,
		sex = Sex,
		tier = GradeNum,
		star = StartNum,
		power = Power
	} <- RankList],
	{ok, Bin} = pt_650:write(65039, [Page, FormatRankList, OldTier, OldStar, RankID, DailyHonor]),
	lib_server_send:send_to_sid(RoleSid, Bin),
	Status#player_status{role_3v3 = NRole3v3}.

%% 推送战斗结算 && 发送单次战斗结算
%% @desc : 在线直接到背包，不在线则发邮件
send_pk_result([IsSingle, RoleID, Tier, Star, Honor, Reward, ContinuedWin, Data]) ->
	Pid = misc:get_player_process(RoleID),
	case is_pid(Pid) andalso misc:is_process_alive(Pid) of
		true ->
			% MFA = {lib_3v3_local, cast_send_pk_result, [[Tier, Star, Honor, ContinuedWin, Data]]},
			% gen_server:cast(Pid, {apply_cast_save, MFA});
%%			lib_scene:player_change_scene(RoleID, SceneId, 0, 0, X, Y, false, [{change_scene_hp_lim, 0}])
			lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, cast_send_pk_result,
				[[IsSingle, Tier, Star, Honor, Reward, ContinuedWin, Data]]);
		_ ->
			if
				ContinuedWin > 0 -> Title = utext:get(6500003), Content = utext:get(6500004);
				true -> Title = utext:get(6500005), Content = utext:get(6500006)
			end,
			lib_mail_api:send_sys_mail([RoleID], Title, Content, [{?TYPE_CURRENCY, ?GOODS_ID_3V3_HONOR, Honor}] ++ Reward),
			SQL = io_lib:format("update role_3v3 set tier = ~w, star = ~w where
                role_id = ~w", [Tier, Star, RoleID]),
			db:execute(SQL)
	end.


%% 推送战斗结算 && 发送单次战斗结算
%% @desc : 在线直接到背包，不在线则发邮件
send_pk_result_champion([RoleID, Tier, Star, Honor, Reward, ContinuedWin, Data]) ->
	Pid = misc:get_player_process(RoleID),
	case is_pid(Pid) andalso misc:is_process_alive(Pid) of
		true ->
			lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, send_pk_result_champion,
				[[Tier, Star, Honor, Reward, ContinuedWin, Data]]);
		_ ->
			ok
	end.


send_pk_result_champion_ob([RoleID, Data]) ->
	Pid = misc:get_player_process(RoleID),
	case is_pid(Pid) andalso misc:is_process_alive(Pid) of
		true ->
			lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_3v3_local, send_pk_result_champion_ob,
				[Data]);
		_ ->
			ok
	end.



cast_send_pk_result(#player_status{id = RoleID, sid = RoleSid, role_3v3 = Role3v3, battle_attr = BattleAttr} = Status,
	[IsSingle, _Tier, _Star, Honor, Reward, ContinuedWin, Data]) ->
	
	#role_3v3{tier = OldTier, star = OldStar, daily_win = DailyWin, daily_pk = DailyPK} = Role3v3,
%%	?MYLOG("3v3", "IsSingle ~p~n", [IsSingle]),
%%	?MYLOG("3v3", "_Star ~p~n", [_Star]),
	if
		IsSingle == ?is_single ->
			ResultType = ?single_result,
			mod_daily:increment_offline(RoleID, ?MOD_KF_3V3, 9),
			Tier = OldTier, Star = OldStar;
		true ->
			ResultType = ?common_result,
			Tier = _Tier, Star = _Star
	end,
	if
		ContinuedWin > 0 ->
			Result = 1, Type = 1,
			%%赛季胜利次数 + 1
			mod_counter:increment_offline(RoleID, ?MOD_KF_3V3, ?kf_3v3_count_win_id),
			NRole3v3 = Role3v3#role_3v3{tier = Tier, star = Star, continued_win = ContinuedWin,
				daily_win = DailyWin + 1, daily_pk = DailyPK + 1};
		true ->
			Result = 2, Type = 1,
			NRole3v3 = Role3v3#role_3v3{tier = Tier, star = Star, continued_win = 0,
				daily_pk = DailyPK + 1}
	end,
	mod_counter:increment_offline(RoleID, ?MOD_KF_3V3, ?kf_3v3_count_match_id),
	replace_role_3v3(RoleID, NRole3v3),
%%	?MYLOG("3v3", "Data ~p ~n ~p~n", [Data, {Star, ContinuedWin, Honor}]),
	lib_log_api:log_3v3(RoleID, Type, OldTier, OldStar, Tier, Star, Result, Honor, [{group, BattleAttr#battle_attr.group}]), %%  加一个reward 战斗日志
	% NStatus = lib_goods_api:send_reward([{honor, Honor}], kf_3v3, Status#player_status{role_3v3 = NRole3v3}),
%%	?MYLOG("3v3", "Reward ~p~n", [Reward]),
	Produce = #produce{type = kf_3v3, reward = [{?TYPE_CURRENCY, ?GOODS_ID_3V3_HONOR, Honor}] ++ Reward},
	{ok, NStatus} = lib_goods_api:send_reward_with_mail(Status#player_status{role_3v3 = NRole3v3}, Produce),
	BinData = [ResultType] ++ Data ++ [Star, ContinuedWin, lib_goods_api:get_currency(NStatus, ?GOODS_ID_3V3_HONOR), Tier],
	?MYLOG("3v3", "BinData ~p~n", [BinData]),
	{ok, Bin} = pt_650:write(65037, BinData),
	lib_server_send:send_to_sid(RoleSid, Bin),
	KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}],
	NewPS = lib_scene:change_default_scene(NStatus, KeyValueList),
	%%解锁
%%	lib_player:apply_cast(_RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free])
	NewPS1 = cast_change_status(NewPS, free),
	mod_server_cast:set_data_sub(KeyValueList, NewPS1). %% 战斗结束，将玩家状态直接复原
%%	NewPS.



%%冠军赛推送结果
send_pk_result_champion(#player_status{sid = RoleSid, id = RoleID, battle_attr = BattleAttr} = Status,
	[_Tier, _Star, _Honor, Reward, _ContinuedWin, Data]) ->
	Produce = #produce{type = kf_3v3, reward = Reward},
	{ok, NStatus} = lib_goods_api:send_reward_with_mail(Status, Produce),
	{ok, Bin} = pt_650:write(65037, [?champion_result] ++ Data ++ [0, 0, lib_goods_api:get_currency(Status, ?GOODS_ID_3V3_HONOR), 0]),
	lib_server_send:send_to_sid(RoleSid, Bin),
%%	KeyValueList = [{change_scene_hp_lim, 1}, {scene_hide_type, 0}],
	KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}, {scene_hide_type, 0}],
	NewPS = lib_scene:change_scene(NStatus, ?champion_pk_scene, 0, 0, ?champion_pk_x, ?champion_pk_y, false, KeyValueList),
	if
		_ContinuedWin > 0 ->  %%赢，
			Result = 1;
		true ->   %% 输
			Result = 2
	
	end,
	lib_log_api:log_3v3(RoleID, 1, _Tier, _Star, _Tier, _Star, Result, _Honor, [{group, BattleAttr#battle_attr.group}]), %%加一个reward 战斗日志
	mod_server_cast:set_data_sub(KeyValueList, NewPS), %% 战斗结束，将玩家状态直接复原
	NewPS.


%%冠军赛推送OB结果
send_pk_result_champion_ob(#player_status{sid = RoleSid} = Status,
	Data) ->
	{ok, Bin} = pt_650:write(65037, [?ob_result] ++ Data ++ [0, 0, 0, 0]),
	lib_server_send:send_to_sid(RoleSid, Bin),
	KeyValueList = [{group, 0}, {change_scene_hp_lim, 1}, {scene_hide_type, 0}],
	NewPS = lib_scene:change_default_scene(Status, KeyValueList),
	mod_server_cast:set_data_sub(KeyValueList, NewPS), %% 战斗结束，将玩家状态直接复原
	NewPS.

%% 发送赛季结算奖励
send_rank_rewards([RoleID, RankID]) ->
	case data_3v3:get_rank_rewards(RankID) of
		[] -> skip;
		0 -> skip;
		Rewards -> lib_mail_api:send_sys_mail([RoleID], utext:get(6500001), utext:get(6500002, [RankID]), Rewards)
	end;

%% 发送赛季结算奖励
send_rank_rewards([RoleID, _RankID, Rewards]) ->
	lib_mail_api:send_sys_mail([RoleID], utext:get(6500001), utext:get(6500007), Rewards).

%% 接受队伍消息
send_msg_to_team([RoleID, Bin]) ->
	lib_server_send:send_to_uid(RoleID, Bin).

handle_player_disconnect(Player, _) ->
%%    logout(Player), %%todo 只有真掉线才走这里
	{ok, Player}.

get_tier_respond(RoleId, Tier, Star) ->
	Pid = misc:get_player_process(RoleId),
	case is_pid(Pid) andalso misc:is_process_alive(Pid) of
		true ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, setup_player_tier, [Tier, Star]);
		_ ->
			case db:get_row(io_lib:format("SELECT `tier`, `star` FROM `role_3v3` WHERE `role_id`=~p", [RoleId])) of
				[Tier, Star] ->
					ok;
				_ ->
					SQL = io_lib:format("update role_3v3 set tier = ~w, star = ~w, old_tier = ~w, old_star = ~w where role_id = ~w", [Tier, Star, Tier, Star, RoleId]),
					db:execute(SQL)
			end
	end.

setup_player_tier(Player, Tier, Star) ->
	#player_status{role_3v3 = Role3v3, id = RoleId} = Player,
	case Role3v3 of
		#role_3v3{tier = Tier, star = Star} ->
			ok;
		_ ->
			NRole3v3 = Role3v3#role_3v3{tier = Tier, star = Star, old_star = Star, old_tier = Tier},
			replace_role_3v3(RoleId, NRole3v3),
			Player#player_status{role_3v3 = NRole3v3}
	end.

repair_tier(Player) ->
	case utime:unixtime() - 1528808400 of
		S when S < 0 ->
			Node = mod_disperse:get_clusters_node(),
			mod_clusters_node:apply_cast(mod_3v3_rank, get_my_tier, [Node, Player#player_status.id]);
		_ ->
			ok
	end.

fix_bug() ->
	StartTime = utime:unixtime({{2018, 7, 1}, {0, 0, 0}}),
	SQL = io_lib:format("SELECT `role_id`, `new_tier`, `new_star`, `time` FROM `log_3v3` WHERE `type`=2 AND `time` >= ~p", [StartTime]),
	All = db:get_all(SQL),
	List = lists:foldl(fun
		                   ([RoleId, Tier, Star, Time], Acc) ->
			                   case lists:keyfind(RoleId, 1, Acc) of
				                   {RoleId, Tier0, Star0, Time0, _} ->
					                   if
						                   Time < Time0 orelse (Time == Time0 andalso (Tier bsl 16 + Star) > (Tier0 bsl 16 + Star0)) ->
							                   lists:keystore(RoleId, 1, Acc, {RoleId, Tier, Star, Time, 1});
						                   true ->
							                   lists:keystore(RoleId, 1, Acc, {RoleId, Tier0, Star0, Time0, 1})
					                   end;
				                   _ ->
					                   [{RoleId, Tier, Star, Time, 0} | Acc]
			                   end
	                   end, [], All),
	SlimList = [{RoleId, Tier, Star} || {RoleId, Tier, Star, _Time, 1} <- List],
	spawn(fun() ->
		[begin
			 Pid = misc:get_player_process(RoleId),
			 case is_pid(Pid) andalso misc:is_process_alive(Pid) of
				 true ->
					 lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, setup_player_tier, [Tier, Star]);
				 _ ->
					 SQL2 = io_lib:format("update role_3v3 set tier = ~w, star = ~w where role_id = ~w", [Tier, Star, RoleId]),
					 db:execute(SQL2)
			 end,
			 timer:sleep(100)
		 end || {RoleId, Tier, Star} <- SlimList]
	      end),
	ok.


new_season_handle() ->
	D = utime:day_of_month(utime:unixtime() + 100),
	spawn(fun() ->
		if
			D == 16 -> %% 每月16号结算
				%%声望清0
%%				?MYLOG("cym", "69+++++++++++++++ ~n", []),
				Sql1 = io_lib:format(<<"DELETE from  player_special_currency where currency_id = ~p">>, [?GOODS_ID_3V3_HONOR]),
				db:execute(Sql1),
				OnlineList = ets:tab2list(?ETS_ONLINE),
				IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
				[begin
					 timer:sleep(100),
					 mod_counter:set_count(RoleId, ?MOD_KF_3V3, ?kf_3v3_count_win_id, 0),
					 mod_counter:set_count(RoleId, ?MOD_KF_3V3, ?kf_3v3_count_match_id, 0)
				 end
					|| RoleId <- IdList],
				Sql = io_lib:format("UPDATE   counter  SET count = 0  where module = ~p  and  (type =  ~p or type =  ~p)",
					[?MOD_KF_3V3, ?kf_3v3_count_win_id, ?kf_3v3_count_match_id]),
				db:execute(Sql),
				ok;
			true ->
				skip
		end
	end).
	
	
%% -----------------------------------------------------------------
%% @desc     功能描述 初始化声望列表
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
init_fame_reward() ->
	List = data_3v3:get_fame_reward_list(),
	[{Id, 0} || {Id, _} <- List].

%% -----------------------------------------------------------------
%% @desc     功能描述 获得要发送的声望列表
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_send_client_fame_reward(Fame, FameReward) ->
	F = fun({Id, Status}, AccList) ->
		NeedFame = data_3v3:get_fame_by_id(Id),
		if
			Status == 2 -> %%已经领取了
				[{Id, Status} | AccList];
			true -> %%未领取
				if
					Fame >= NeedFame ->
						[{Id, 1} | AccList];  %%可以领取
					true ->  %%不能领取
						[{Id, 0} | AccList]
				end
		end
	    end,
	lists:reverse(lists:foldl(F, [], FameReward)).

%% -----------------------------------------------------------------
%% @desc     功能描述  积分随塔数的增加有额外加成
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_score_add_by_ratio(Num, BaseScore) ->
	List = data_3v3:get_kv(add_score_ratio),
	case lists:keyfind(Num, 1, List) of
		{Num, Ratio} ->
			trunc(BaseScore * Ratio);
		_ ->
			0
	end.


delay_stop(PS) ->
	#player_status{action_lock = Lock, scene = Scene} = PS,
	IsLock = Lock == ?ERRCODE(err650_in_kf_3v3_act),
	Is3v3Scene = lib_3v3_api:is_3v3_scene(Scene),
	if
		IsLock == true andalso Is3v3Scene == false ->  %% 匹配阶段
			pp_3v3:handle(65014, PS, [2]),
			pp_3v3:handle(65017, PS, []),
			PS;
		true ->
			PS
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述 是否同一个赛季 15号为赛季结束
%% @param    参数     Time2 > Time1
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_same_season(Time1, Time2) ->
	{{_, M1, Day1}, _} = utime:unixtime_to_localtime(Time1),
	{{_, M2, Day2}, _} = utime:unixtime_to_localtime(Time2),
	is_same_season2(M1, Day1, M2, Day2).

%%同月的
is_same_season2(M, Day1, M, Day2) ->
	if
		(Day2 > 15 andalso Day1 > 15) orelse (Day2 =< 15 andalso Day1 =< 15) ->
			true;
		true ->
			false
	end;
is_same_season2(M1, Day1, M2, Day2) ->
	Abs = abs(M1 - M2),
	if
		((M1 == 12 andalso M2 == 1) orelse (M2 == 12 andalso M1 == 1)) orelse Abs =< 1 ->  %%相差一个月的
			if
				Day1 > 15 andalso Day2 =< 15 ->  %%一个在月末，一个在月初，处于同一个赛季
					true;
				true ->
					false
			end;
		true ->
			false
	end.

%%修复段位错误
repair() ->
	DB = db:get_all(io_lib:format(<<"select role_id from role_3v3">>, [])),
	F = fun([
		RoleId
	]) ->
		RolePid = misc:get_player_process(RoleId),
		case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
			true ->
				lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, repair, []);
			false ->
				case get_log_right_tier_and_star(RoleId) of
					{NewTier, Star} ->
						Sql = io_lib:format(<<"UPDATE role_3v3 set  tier = ~p, star = ~p , yesterday_tier = ~p where role_id = ~p">>,
							[NewTier, Star, NewTier, RoleId]),
						db:execute(Sql);
					_ ->
						skip
				end
		end
	    end,
	lists:foreach(F, DB).


repair(PS) ->
	#player_status{role_3v3 = Role3v3, id = RoleId} = PS,
	case get_log_right_tier_and_star(RoleId) of
		{NewTier, Star} ->
			NewRole3v3 = Role3v3#role_3v3{tier = NewTier, star = Star, yesterday_tier = NewTier},
			replace_role_3v3(RoleId, NewRole3v3),
			PS#player_status{role_3v3 = NewRole3v3};
		_ ->
			PS
	end.


get_log_right_tier_and_star(RoleId) ->
	Sql = io_lib:format(<<"select  new_tier, new_star  from  log_3v3 where role_id = ~p
    and time >= 1560614405 ORDER BY  time  desc limit 1">>, [RoleId]),
	case db:get_row(Sql) of
		[Tier, Star] ->
			{Tier, Star};
		_ ->
			[]
	end.

%%%---------------------------新优化-----------------------  记得队伍都要保持顺序

%%通知队长申请列表变更
send_apply_role_to_leader(LeaderId, RoleMsg, ServerId) ->
	#team_local_3v3_role{role_id = RoleId, role_name = RoleName, lv = Lv, server_id = ServerId1, server_num = ServerNum,
		picture = Picture, picture_id = PictureId, power = Power, career = Career} = RoleMsg,
	{ok, Bin} = pt_650:write(65070, [ServerId1, ServerNum, RoleId, RoleName, Power, Lv, Picture, PictureId, Career]),
	?MYLOG("3v3", "send_apply_role_to_leader +++++++~n", []),
	send_to_uid(ServerId, LeaderId, Bin).
%%	lib_server_send:send_to_uid(LeaderId, Bin);


%%LeaderId ::role_id  ApplyList::[##team_local_3v3_role{}]
send_apply_role_to_leader2(LeaderId, ApplyList, ServerId) ->
	F = fun(#team_local_3v3_role{role_id = RoleId, picture = Picture, picture_id = PictureVer, career = Career,
		lv = Lv, power = Power, role_name = Name}, AccList) ->
%%		case lib_role:get_role_show(RoleId) of
%%			#ets_role_show{figure = F, combat_power = Power} ->
%%				#figure{picture = Picture, picture_ver = PictureVer, career = Career, lv = Lv} = F,
%%				[{RoleId, F#figure.name, Picture, PictureVer, Career, Lv, Power} | AccList];
%%			_ ->
%%				AccList
%%		end
		
		[{RoleId, Name, Picture, PictureVer, Career, Lv, Power} | AccList]
	    end,
	Pack = lists:reverse(lists:foldl(F, [], ApplyList)),
	?MYLOG("3v3", "Pack ~p~n", [Pack]),
	{ok, Bin} = pt_650:write(65059, [Pack]),
	send_to_uid(ServerId, LeaderId, Bin).
%%	lib_server_send:send_to_uid(LeaderId, Bin).

%% err650_err_team_id
hand_apply_list(State, MyServerId, RoleId, Type, TeamId, MYRoleId) ->
	#team_state{team_list = TeamList, team_role_id_list = HaveTeamRoleList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{apply_list = ApplyList, role_list = TeamRoleList, leader_id = LeaderId, name = TeamName, matching_status = Status} = Team ->
			Length = length(TeamRoleList),
			IsCanCut = lib_3v3_api:is_can_cut_team(),
			IsHaveTeam = lists:member(RoleId, HaveTeamRoleList),
			if
				Length >= ?team_num ->
%%					?MYLOG("3v3", "NewTeamRoleList ~n", []),
					{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_team_max_member)]),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					
					send_to_uid(MyServerId, RoleId, Bin),  %%
					State;
				IsHaveTeam == true ->
%%					?MYLOG("3v3", "NewTeamRoleList ~n", []),
					{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_have_team)]),
%%					lib_server_send:s|end_to_uid(MYRoleId, Bin),
					send_to_uid(MyServerId, MYRoleId, Bin),
					State;
				true ->
					case lists:keyfind(RoleId, #team_local_3v3_role.role_id, ApplyList) of
						#team_local_3v3_role{server_id = ServerId, role_name = RoleName} = RoleMsg ->
							if
								Type == ?accept andalso (Status == ?team_pk orelse Status == ?team_matching) ->  %%同意进入队伍
%%									?MYLOG("3v3", "NewTeamRoleList ~n", []),
									{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_in_pk)]),
%%									lib_server_send:send_to_uid(MYRoleId, Bin),
									send_to_uid(MyServerId, MYRoleId, Bin),
									State;
								IsCanCut == false ->
%%									pp_3v3:send_error(MYRoleId, ?ERRCODE(err650_chanpion_can_not_change_team)),
									send_error(MyServerId, MYRoleId, ?ERRCODE(err650_chanpion_can_not_change_team)),
									State;
								Type == ?accept ->  %%同意进入队伍
									NewTeamRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, TeamRoleList, RoleMsg),
%%									?MYLOG("3v3", "NewTeamRoleList ~p~n", [NewTeamRoleList]),
									update_role_team_msg_success(RoleMsg, TeamId, LeaderId, TeamName, ServerId),  %%更新玩家信息
									save_to_db_role(RoleMsg, TeamId),
									NewTeam = Team#team_local_3v3{role_list = NewTeamRoleList},
%%									?MYLOG("3v3", "TeamList ~p~n", [TeamList]),
									NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
%%									?MYLOG("3v3", "NewTeamList ~p~n", [NewTeamList]),
									NewTeamList1 = delete_apply_role(NewTeamList, RoleId),   %%删除玩家在其他队伍的申请信息
									{ok, Bin} = pt_650:write(65060, [RoleId, Type, ?SUCCESS]),
%%									lib_server_send:send_to_uid(MYRoleId, Bin),
									send_to_uid(MyServerId, MYRoleId, Bin),
									_NewHaveTeamRoleList = lists:delete(RoleId, HaveTeamRoleList),
									%%广播 队伍信息
									send_team_msg_to_all(NewTeam),
									%%广播入队
									enter_team_TV(NewTeam, RoleId, RoleName),
									NewState = State#team_state{team_list = NewTeamList1, team_role_id_list = [RoleId | _NewHaveTeamRoleList]},
%%									%%通知别人被操作结果
									{ok, Bin1} = pt_650:write(65072, [TeamId, Type]),
									send_to_uid(MyServerId, MYRoleId, Bin1),
%%									lib_server_send:send_to_uid(RoleId, Bin1),
									lib_3v3_local:log_3v3_team_member(Team, ?team_3v3_join, [RoleMsg]),
									send_team_info(TeamId, ServerId, RoleId, 0, NewState),
									update_role_status(ServerId, RoleId, TeamId),
									NewState;
								true ->  %%拒绝
									ApplyList1 = lists:keydelete(RoleId, #team_local_3v3_role.role_id, ApplyList),
									NewTeam = Team#team_local_3v3{apply_list = ApplyList1},
									NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
									{ok, Bin} = pt_650:write(65060, [RoleId, Type, ?SUCCESS]),
									send_to_uid(MyServerId, MYRoleId, Bin),
%%									lib_server_send:send_to_uid(MYRoleId, Bin),
									update_role_team_msg_fail(RoleMsg, TeamId, LeaderId, "", ServerId),  %%更新玩家信息
									NewState = State#team_state{team_list = NewTeamList},
									%%通知别人被操作结果
									{ok, Bin1} = pt_650:write(65072, [TeamId, Type]),
%%									lib_server_send:send_to_uid(RoleId, Bin1),
									send_to_uid(ServerId, RoleId, Bin1),
									NewState
							end;
						_ ->
							{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_err_role_id)]),
%%							lib_server_send:send_to_uid(RoleId, Bin),
							send_to_uid(MyServerId, MYRoleId, Bin),
							State
					end
			end;
		_ ->
			{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_err_team_id)]),
			send_to_uid(MyServerId, MYRoleId, Bin),
%%			lib_server_send:send_to_uid(RoleId, Bin),
			State
	end.


%%广播队伍信息
send_team_msg_to_all(Team) ->
	#team_local_3v3{team_id = TeamId, name = TeamName, leader_id = LeaderId, match_count = MatchCount,
		win_count = WinCount, point = Point, champion_rank = Rank, role_list = RoleList, matching_status = MatchingStatus, is_change_name = IsChangeName
	} = Team,
	RankLv = get_rank_lv_by_point(Point),
	PackList = pack_role_list(RoleList, LeaderId),
	Power = get_all_power(RoleList),
	
	?MYLOG("3v3", "PackList ~p~n", [{TeamId, 0, TeamName, LeaderId, MatchCount, WinCount, Point, MatchingStatus, 0,
		Rank, RankLv, Power, IsChangeName, PackList}]),
%%	{ok, Bin} = pt_650:write(65052, [TeamId, 0, TeamName, LeaderId, MatchCount, WinCount, Point, MatchingStatus, TodayCount,
%%		Rank, RankLv, Power, IsChangeName, PackList]),
	[begin
%%		 TodayCount = mod_daily:get_count_offline(TempId, ?MOD_KF_3V3, 9),
		 {ok, Bin} = pt_650:write(65052, [TeamId, 0, TeamName, LeaderId, MatchCount, WinCount, Point,
			 MatchingStatus, Rank, RankLv, Power, IsChangeName, PackList]),
		 send_to_uid(ServerId, TempId, Bin)
%%		 lib_server_send:send_to_uid(TempId, Bin)
	 end
		|| #team_local_3v3_role{role_id = TempId, server_id = ServerId} <- RoleList].

%% 入队传闻
enter_team_TV(Team, _RoleId, RoleName) ->
%%	Name = lib_role:get_role_name(RoleId),
	#team_local_3v3{role_list = List} = Team,
	[
		mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{player, TempRoleId}, ?MOD_KF_3V3, 4, [RoleName]])
%%		lib_chat:send_TV({player, TempRoleId}, ?MOD_KF_3V3, 4, [Name])
		|| #team_local_3v3_role{role_id = TempRoleId, server_id = ServerId} <- List].

%%离开传闻传闻
kick_role_TV(RoleList, _RoleId, Name) ->
%%	Name = lib_role:get_role_name(RoleId),
	[
%%		lib_chat:send_TV({player, TempRoleId}, ?MOD_KF_3V3, 6, [Name])
		mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{player, TempRoleId}, ?MOD_KF_3V3, 6, [Name]])
		|| #team_local_3v3_role{role_id = TempRoleId, server_id = ServerId} <- RoleList].

%%更新玩家的战队信息  分离线和在线版 进入队伍了
update_role_team_msg_success(RoleMsg, TeamId, LeaderId, TeamName, ServerId) ->
	update_role_team_msg(RoleMsg#team_local_3v3_role.role_id, TeamId, LeaderId, TeamName, ServerId).


%%通知玩家申请失败
update_role_team_msg_fail(RoleMsg, _TeamId, _LeaderId, _TeamName, ServerId) ->
	%% 针对玩家广播失败
	mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
		[{player, RoleMsg#team_local_3v3_role.role_id}, ?MOD_KF_3V3, 5, [RoleMsg#team_local_3v3_role.role_name]]).
%%	lib_chat:send_TV({player, RoleMsg#team_local_3v3_role.role_id}, ?MOD_KF_3V3, 5, [Name]).

%%%%更新玩家状态   被踢了 ， 创建队伍成功
%%update_role_team_msg(RoleId, TeamId, LeaderId, TeamName) ->
%%	RoleMsg = #role_3v3_new{team_name = TeamName, team_id = TeamId, leader_id = LeaderId},
%%	case misc:is_process_alive(misc:get_player_process(RoleId)) of
%%		true ->
%%			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, update_role_team_msg, [RoleMsg]);
%%		_ ->
%%			save_to_db_role_ps(RoleId, RoleMsg)
%%	end.

%%更新玩家状态   被踢了 ， 创建队伍成功
update_role_team_msg(RoleId, TeamId, LeaderId, TeamName, ServerId) ->
%%	?PRINT("~p~n", [{RoleId, TeamId, LeaderId, TeamName, ServerId}]),
	RoleMsg = #role_3v3_new{team_name = TeamName, team_id = TeamId, leader_id = LeaderId},
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, save_to_db_role_ps, [RoleId, RoleMsg]),
	mod_clusters_center:apply_cast(ServerId,
		lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_3v3_local, update_role_team_msg, [RoleMsg]]).
%%	case misc:is_process_alive(misc:get_player_process(RoleId)) of
%%		true ->
%%			mod_clusters_center:apply_cast(ServerId,
%%				lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, update_role_team_msg, [RoleMsg]]);
%%%%			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, update_role_team_msg, [RoleMsg]);
%%		_ ->
%%			mod_clusters_center:apply_cast(ServerId, lib_3v3_local, save_to_db_role_ps, [RoleId, RoleMsg])
%%%%			save_to_db_role_ps(RoleId, RoleMsg)
%%	end.

%%更新玩家3v3战队的信息
update_role_team_msg(PS, Role3v3New) ->
	save_to_db_role_ps(PS#player_status.id, Role3v3New),
	lib_role:update_role_show(PS#player_status.id, [{team_3v3_id, Role3v3New#role_3v3_new.team_id}]),
	PS#player_status{team_3v3 = Role3v3New}.

%%删除玩家在队伍的请求信息  并保持队伍排名的顺序
delete_apply_role(TeamList, RoleId) ->
	F = fun(#team_local_3v3{apply_list = ApplyList} = Team, AccList) ->
		ApplyList1 = lists:keydelete(RoleId, #team_local_3v3_role.role_id, ApplyList),
		NewTeam = Team#team_local_3v3{apply_list = ApplyList1},
		[NewTeam | AccList]
	    end,
	lists:reverse(lists:foldl(F, [], TeamList)).



%%发送战队列表
send_team_list_new(State, ServerId, RoleId) ->
	#team_state{team_list = TeamList} = State,
	F = fun(#team_local_3v3{team_id = TeamId, name = TeamName, leader_id = LeaderId, leader_name = LeaderName,
		role_list = RoleList, apply_list = ApplyList, point = Point}, {Rank, AccLis}) ->
		Rank1 = Rank + 1,
%%		?MYLOG("3v3", "ApplyList ~p~n", [ApplyList]),
		Status = case lists:keyfind(RoleId, #team_local_3v3_role.role_id, ApplyList) of
			         #team_local_3v3_role{} ->
				         1;
			         _ ->
				         0
		         end,
		{Rank1, [{TeamId, TeamName, Point, LeaderId, LeaderName, length(RoleList), Rank1, Status} | AccLis]}
	    end,
	{_, PackList} = lists:foldl(F, {0, []}, TeamList),
	?MYLOG("3v3", "PackList ~p~n", [PackList]),
	{ok, Bin} = pt_650:write(65051, [lists:reverse(PackList)]),
	send_to_uid(ServerId, RoleId, Bin).


%%发送战队详细信息  Flag 0 自己队  1 别人队
send_team_info(TeamId, ServerId, RoleId, Flag, State) ->
	#team_state{team_list = TeamList} = State,
%%	?MYLOG("3v3", "TeamId ~p~n", [TeamId]),
%%	?MYLOG("3v3", "TeamList ~p~n", [TeamList]),
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{team_id = TeamId, name = TeamName, leader_id = LeaderId, match_count = MatchCount,
			win_count = WinCount, point = Point, champion_rank = Rank, role_list = RoleList,
			matching_status = MatchingStatus, is_change_name = IsChange} ->
			RankLv = get_rank_lv_by_point(Point),
			PackList = pack_role_list(RoleList, LeaderId),
			Power = get_all_power(RoleList),
%%			?MYLOG("3v3", "RoleList ~p~n", [RoleList]),
%%			TodayCount = mod_daily:get_count_offline(RoleId, ?MOD_KF_3V3, 9),
%%			?MYLOG("3v3", "PackList ~p~n", [{TeamId, Flag, TeamName, LeaderId, MatchCount, WinCount, Point,
%%				MatchingStatus, Rank, RankLv, Power, IsChange, PackList}]),
			{ok, Bin} = pt_650:write(65052, [TeamId, Flag, TeamName, LeaderId, MatchCount, WinCount, Point,
				MatchingStatus, Rank, RankLv, Power, IsChange, PackList]),
			send_to_uid(ServerId, RoleId, Bin);
%%			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
%%			?MYLOG("3v3", "TeamId ~p~n", [TeamId]),
			send_error(ServerId, RoleId, ?ERRCODE(err650_err_team_id))
%%			pp_3v3:send_error(RoleId, ?ERRCODE(err650_err_team_id))
	end.




%%通过评分获取段位
get_rank_lv_by_point(Point) ->
	{NewTier, _BasePoint} = calc_tier_by_star(0, Point),
	NewTier.


%%打包战队中的详细信息
pack_role_list(RoleList, LeaderId) ->
	F = fun(#team_local_3v3_role{server_num = ServerNum, server_name = ServerName, role_id = RoleId, server_id = ServerId, on_line = Online, role_name = RoleName}, AccList) ->
%%		case lib_role:get_role_show(RoleId) of
%%			#ets_role_show{figure = Figure, combat_power = Power, online_flag = OnlineFlag} ->
%%				RoleName = Figure#figure.name,
%%				Career = Figure#figure.career,
%%				Sex = Figure#figure.sex,
%%				Turn = Figure#figure.turn,
%%				LvModel = Figure#figure.lv_model,
%%				FashionModel = Figure#figure.fashion_model,
%%				MountFigure = Figure#figure.mount_figure ++ Figure#figure.back_decora_figure,
%%				IsLeader = ?IF(RoleId == LeaderId, 1, 0),
%%				Picture = Figure#figure.picture,
%%				PictureId = Figure#figure.picture_ver,
%%				Lv = Figure#figure.lv,
%%				[{ServerId, ServerName, ServerNum, RoleId, OnlineFlag, Lv, RoleName, Career, Sex, Turn,
%%					Power, LvModel, FashionModel, MountFigure, IsLeader, Picture, PictureId}
%%					| AccList];
%%			_ ->
%%				AccList
%%		end
		IsLeader = ?IF(RoleId == LeaderId, 1, 0),
		[{ServerId, ServerName, ServerNum, RoleId, RoleName, Online, IsLeader}
			| AccList]
	    end,
	lists:foldl(F, [], RoleList).


kick_role(MyServerId, TeamId, RoleId, LeaderId, State) ->
%%	?MYLOG("3v3", "RoleList +++++++++++++++ ~n", []),
	#team_state{team_list = TeamList, team_role_id_list = AllRoleList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, name = TeamName, matching_status = Status} = Team ->
			if
				Status == ?team_pk orelse Status == ?team_matching ->
%%					pp_3v3:send_error(LeaderId, ?ERRCODE(err650_in_pk)),
					send_error(MyServerId, LeaderId, ?ERRCODE(err650_in_pk)),
					State;
				true ->
%%					?MYLOG("3v3", "RoleList ~p~n", [RoleList]),
					case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
						#team_local_3v3_role{server_id = ServerId, role_name = RoleName} = RoleMsg ->
							NewRoleList = lists:keydelete(RoleId, #team_local_3v3_role.role_id, RoleList),
							NewTeam = Team#team_local_3v3{role_list = NewRoleList},
							NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
							NewAllRoleList = lists:delete(RoleId, AllRoleList),
							db_delete_role_only(RoleId, TeamId),     %%操作数据库
							update_role_team_msg(RoleId, 0, 0, "", ServerId),  %%更新玩家个人信息
							%%发送传闻
							kick_role_TV(RoleList, RoleId, RoleName),
							%% 单独发送给被踢的玩家
							{ok, Bin} = pt_650:write(65053, [RoleId, ?SUCCESS]),
%%							lib_server_send:send_to_uid(RoleId, Bin),
							send_to_uid(ServerId, RoleId, Bin),
%%							lib_server_send:send_to_uid(LeaderId, Bin),
							send_to_uid(MyServerId, LeaderId, Bin),
							%%邮件
							Title = utext:get(6500009),
							Content = utext:get(6500008, [TeamName]),
%%							lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
							mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, []]),
							send_team_msg_to_all(NewTeam),  %%广播队伍信息
							lib_3v3_local:log_3v3_team_member(Team, ?team_3v3_knick_out, [RoleMsg]),
							State#team_state{team_list = NewTeamList, team_role_id_list = NewAllRoleList};
						_ ->
%%							pp_3v3:send_error(LeaderId, ?ERRCODE(err650_err_role_id)),
							send_error(MyServerId, LeaderId, ?ERRCODE(err650_err_role_id)),
							State
					end
			end;
		_ ->
			send_error(MyServerId, LeaderId, ?ERRCODE(err650_err_team_id)),
%%			pp_3v3:send_error(LeaderId, ?ERRCODE(err650_err_team_id)),
			State
	end.



%%
change_leader(ServerId, OldLeader, TeamId, ChangeLeaderId, ChangeLeaderName, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{leader_id = OldLeader, role_list = RoleList, name = TeamName, matching_status = Status, leader_name = OldLeaderName} = OldTeam ->
			if
				Status == ?team_pk orelse Status == ?team_matching ->
					send_error(ServerId, OldLeader, ?ERRCODE(err650_in_pk)),
					State;
				true ->
					case lists:keyfind(ChangeLeaderId, #team_local_3v3_role.role_id, RoleList) of
						#team_local_3v3_role{server_id = ChangeLeaderServerId} = RoleMsg ->
							NewTeam = OldTeam#team_local_3v3{leader_id = ChangeLeaderId, leader_name = ChangeLeaderName},
							save_to_db_only_team(NewTeam),
							[update_role_team_msg(MemberId, TeamId, ChangeLeaderId, TeamName, ServerId2) || #team_local_3v3_role{role_id = MemberId,
								server_id = ServerId2} <- RoleList],
							NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
							NewState = State#team_state{team_list = NewTeamList},
							{ok, Bin} = pt_650:write(65054, [ChangeLeaderId, ?SUCCESS]),
%%							lib_server_send:send_to_uid(OldLeader, Bin),
							send_to_uid(ServerId, OldLeader, Bin),
							%%广播队伍信息
							send_team_msg_to_all(NewTeam),
%%							OldLeaderName = lib_role:get_role_name(OldLeader),
							%%邮件
							Title = utext:get(6500009),
							Content = utext:get(6500010, [OldLeaderName, TeamName]),
%%							lib_mail_api:send_sys_mail([ChangeLeaderId], Title, Content, []),
							mod_clusters_center:apply_cast(ChangeLeaderServerId, lib_mail_api, send_sys_mail, [[ChangeLeaderId], Title, Content, []]),
%%							NewLeaderName = lib_role:get_role_name(ChangeLeaderId),
%%							mod_clusters_node:apply_cast(mod_3v3_rank, refresh_3v3_team2, [{update_leader_id, TeamId, ChangeLeaderId, ChangeLeaderName}]),
							mod_3v3_rank:refresh_3v3_team2({update_leader_id, TeamId, ChangeLeaderId, ChangeLeaderName}),
							log_3v3_team_member(OldTeam, ?team_3v3_change_leader, [RoleMsg]),
							NewState;
						_ ->
							send_error(ServerId, OldLeader, ?ERRCODE(err650_err_role_id)),
%%							pp_3v3:send_error(OldLeader, ?ERRCODE(err650_err_role_id)),
							State
					end
			end;
		_ ->
			send_error(ServerId, OldLeader, ?ERRCODE(err650_err_team_id)),
%%			pp_3v3:send_error(OldLeader, ?ERRCODE(err650_err_team_id)),
			State
	end.

%%解散队伍
disband_team(MyServerId, MyRoleId, TeamId, State) ->
	#team_state{team_list = TeamList, team_role_id_list = AllRoleList} = State,
%%	?MYLOG("3v3", "TeamId +++++++++++++++ ~p~n", [TeamId]),
%%	?MYLOG("3v3", "TeamList +++++++++++++++ ~p~n", [TeamList]),
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{leader_id = MyRoleId, role_list = RoleList, name = TeamName, matching_status = Status} = OldTeam ->
			if
				Status == ?team_pk orelse Status == ?team_matching ->
					{ok, Bin} = pt_650:write(65055, [?ERRCODE(err650_in_pk)]),
					send_to_uid(MyServerId, MyRoleId, Bin),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					State;
				true ->
					db_delete_team(OldTeam),
					NewTeamList = lists:keydelete(TeamId, #team_local_3v3.team_id, TeamList),
					F = fun(#team_local_3v3_role{role_id = TempRoleId, server_id = ServerId}, AccRoleList) ->
						send_role_disband_team(TeamId, TeamName, TempRoleId, ServerId),
						lists:delete(TempRoleId, AccRoleList)
					    end,
					NewAllRoleList = lists:foldl(F, AllRoleList, RoleList),
					%%通知跨服中心，解散队伍
%%					mod_clusters_node:apply_cast(mod_3v3_rank, refresh_3v3_team2, [{delete, TeamId}]),
					mod_3v3_rank:refresh_3v3_team2({delete, TeamId}),
					LastTeamList = lib_3v3_api:sort_team(NewTeamList),
					log_3v3_team_member(OldTeam, ?team_3v3_disband, [#team_local_3v3_role{role_id = MyRoleId}]),
					State#team_state{team_list = LastTeamList, team_role_id_list = NewAllRoleList}
			end;
		_ ->
			{ok, Bin} = pt_650:write(65055, [?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			%% 做个容错处理
%%			update_role_team_msg(MyRoleId, 0, 0, "", MyServerId),
			send_to_uid(MyServerId, MyRoleId, Bin),
			State
	end.



%%退出队伍
quit_team(MyServerId, MyRoleId, TeamId, State) ->
	#team_state{team_list = TeamList, team_role_id_list = AllRoleList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{leader_id = _LeaderId, role_list = RoleList, matching_status = Status} = OldTeam ->
			if
				Status == ?team_pk orelse Status == ?team_matching ->
%%					{ok, Bin} = pt_650:write(65000, [?ERRCODE(err650_in_pk)]),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					send_error(MyServerId, MyRoleId, ?ERRCODE(err650_in_pk)),
					State;
				true ->
					case lists:keyfind(MyRoleId, #team_local_3v3_role.role_id, RoleList) of
						#team_local_3v3_role{server_id = ServerId, role_name = RoleName} = RoleMsg ->
							NewRoleList = lists:keydelete(MyRoleId, #team_local_3v3_role.role_id, RoleList),
							NewTeam = OldTeam#team_local_3v3{role_list = NewRoleList},
							NewAllRoleList = lists:delete(MyRoleId, AllRoleList),
							NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
							NewState = State#team_state{team_role_id_list = NewAllRoleList, team_list = NewTeamList},
							db_delete_role_only(MyRoleId, TeamId),  %%修改数据库
							{ok, Bin} = pt_650:write(65056, [?SUCCESS]),
%%							lib_server_send:send_to_uid(MyRoleId, Bin),
							send_to_uid(MyServerId, MyRoleId, Bin),
							update_role_team_msg(MyRoleId, 0, 0, "", ServerId),  %%个人信息更新
							kick_role_TV(RoleList, MyRoleId, RoleName),  %%传闻
							send_team_msg_to_all(NewTeam),  %%广播队伍信息
							log_3v3_team_member(OldTeam, ?team_3v3_quit, [RoleMsg]),
							NewState;
						_ ->
							{ok, Bin} = pt_650:write(65056, [?ERRCODE(err650_err_role_id)]),
							send_to_uid(MyServerId, MyRoleId, Bin),
%%							lib_server_send:send_to_uid(MyRoleId, Bin),
							State
					end
			end;
		_ ->
			{ok, Bin} = pt_650:write(65056, [?ERRCODE(err650_err_team_id)]),
			send_to_uid(MyServerId, MyRoleId, Bin),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			State
	end.

%%战队排名  废弃
%%team_rank_info(MyRoleId, State) ->
%%	#team_state{team_list = TeamList} = State,
%%	F = fun(#team_local_3v3{team_id = TeamId, name = TeamName,
%%		leader_id = LeaderId, role_list = RoleList, point = Point, leader_name = LeaderName}, {Rank, AccLis}) ->
%%		Rank1 = Rank + 1,
%%		util:get_server_name(),
%%		config:get_server_num(),
%%		Power = get_all_power(RoleList),
%%		{Rank1, [{TeamId, Rank1, LeaderId, LeaderName, config:get_server_num(), util:get_server_name(), TeamName, Power, Point} | AccLis]}
%%	    end,
%%	{_, PackList} = lists:foldl(F, {0, []}, TeamList),
%%	{ok, Bin} = pt_650:write(65057, [lists:sublist(lists:reverse(PackList), ?team_rank_length)]),
%%	lib_server_send:send_to_uid(MyRoleId, Bin).


change_team_name(ServerId, TeamId, MyRoleId, Name, State) ->
%%	?MYLOG("3v3", "~p ~n", [Name]),
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, leader_id = LeaderId, is_change_name = IsChange} = OldTeam when IsChange == 0 ->
			case lib_3v3_local:check_team_name(Name, TeamList) of
				true ->
					NewTeam = OldTeam#team_local_3v3{name = Name, is_change_name = 1},
					save_to_db_only_team(NewTeam),
					[update_role_team_msg(MemberId, TeamId, LeaderId, Name, ServerId2) || #team_local_3v3_role{role_id = MemberId, server_id = ServerId2} <- RoleList],
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
					{ok, Bin} = pt_650:write(65058, [Name, ?SUCCESS]),
					send_to_uid(ServerId, MyRoleId, Bin),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
%%					lib_player:apply_cast(MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, change_team_name_cost, []),
%%					mod_clusters_node:apply_cast(mod_3v3_rank, refresh_3v3_team2, [{update_name, TeamId, Name}]),
					mod_3v3_rank:refresh_3v3_team2({update_name, TeamId, Name}),
					log_3v3_team_member(NewTeam, ?team_3v3_change_name, [#team_local_3v3_role{role_id = MyRoleId}]),
					State#team_state{team_list = NewTeamList};
				{false, Error} ->
					{ok, Bin} = pt_650:write(65058, ["", Error]),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					send_to_uid(ServerId, MyRoleId, Bin),
					State
			end;
		#team_local_3v3{is_change_name = IsChange} when IsChange > 0 ->  %%已经改过名字所以要消耗
%%			lib_player:apply_cast(MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, change_team_name_check_cost, [TeamId, Name]),
			mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
				[MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, change_team_name_check_cost, [TeamId, Name]]),
			State;
		_ ->
			{ok, Bin} = pt_650:write(65058, ["", ?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			send_to_uid(ServerId, MyRoleId, Bin),
			State
	end.



%%改名的消耗
change_team_name_cost(PS) ->
	Cost = data_3v3:get_kv(change_name_cost),
	case lib_goods_api:cost_object_list_with_check(PS, Cost, change_name_cost, "") of
		{true, NewPS} ->
%%			?MYLOG("3v3", "Cost ~p~n", [Cost]),
			NewPS;
		{false, Error, _} ->
			pp_3v3:send_error(PS#player_status.id, Error),
			PS
	end.


%%检查改名消耗
change_team_name_check_cost(PS, TeamId, Name) ->
	Cost = data_3v3:get_kv(change_name_cost),
	case lib_goods_api:check_object_list(PS, Cost) of
		true ->
			mod_clusters_node:apply_cast(mod_3v3_team, update_change_name, [config:get_server_id(), PS#player_status.id, TeamId, Name]);
%%			mod_3v3_team:update_change_name(PS#player_status.id, TeamId, Name);
		{false, Error} ->
			pp_3v3:send_error(PS#player_status.id, Error),
			PS
	end,
	PS.




%%通知玩家队伍已经解散
send_role_disband_team(_TeamId, _TeamName, RoleId, ServerId) ->
	{ok, Bin} = pt_650:write(65055, [?SUCCESS]),
	send_to_uid(ServerId, RoleId, Bin),
%%	lib_server_send:send_to_uid(RoleId, Bin),
	update_role_team_msg(RoleId, 0, 0, "", ServerId).

get_all_power(RoleList) ->
	get_all_power2(RoleList, 0).

get_all_power2([], Power) ->
	Power;
get_all_power2([#team_local_3v3_role{role_id = _RoleId, power = TempPower} | RoleList], Power) ->
	get_all_power2(RoleList, TempPower + Power).


%%快速入队
quick_enter_team(TeamId, RoleMsg, State) ->
	#team_local_3v3_role{role_id = RoleId, server_id = ServerId, role_name = RoleName} = RoleMsg,
	#team_state{team_list = TeamList, team_role_id_list = HaveTeamRoleList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{apply_list = _ApplyList, role_list = TeamRoleList, leader_id = LeaderId, name = TeamName, matching_status = Status} = Team ->
			Length = length(TeamRoleList),
			IsHaveTeam = lists:member(RoleId, HaveTeamRoleList),
			if
				Length >= ?team_num ->
					{ok, Bin} = pt_650:write(65064, [?ERRCODE(err650_team_max_member)]),
					send_to_uid(ServerId, RoleId, Bin),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					State;
				Status == ?team_pk orelse Status == ?team_matching ->
					{ok, Bin} = pt_650:write(65064, [?ERRCODE(err650_in_pk)]),
					send_to_uid(ServerId, RoleId, Bin),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					State;
				IsHaveTeam == true ->
					{ok, Bin} = pt_650:write(65064, [?ERRCODE(err650_have_team)]),
					send_to_uid(ServerId, RoleId, Bin),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					State;
				true ->
					NewTeamRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, TeamRoleList, RoleMsg),
%%					?MYLOG("3v3", "~p ~n", [NewTeamRoleList]),
					update_role_team_msg_success(RoleMsg, TeamId, LeaderId, TeamName, ServerId),  %%更新玩家信息
					save_to_db_role(RoleMsg, TeamId),
					NewTeam = Team#team_local_3v3{role_list = NewTeamRoleList},
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
					NewTeamList1 = delete_apply_role(NewTeamList, RoleId),   %%删除玩家在其他队伍的申请信息
					{ok, Bin} = pt_650:write(65064, [?SUCCESS]),
					send_to_uid(ServerId, RoleId, Bin),
%%					lib_server_send:send_to_uid(RoleId, Bin),
					_HaveTeamRoleList = lists:delete(RoleId, HaveTeamRoleList),
					send_team_msg_to_all(NewTeam),  %%广播队伍信息
					enter_team_TV(NewTeam, RoleId, RoleName),
					update_role_status(ServerId, RoleId, TeamId),
					lib_3v3_local:log_3v3_team_member(Team, ?team_3v3_join, [RoleMsg]),
					NewState = State#team_state{team_list = NewTeamList1, team_role_id_list = [RoleId | _HaveTeamRoleList]},
					NewState
			end;
		_ ->
			{ok, Bin} = pt_650:write(65060, [0, 0, ?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(RoleId, Bin),
			send_to_uid(ServerId, RoleId, Bin),
			State
	end.


%%队长发起投票
start_vote(MyServerId, MyRoleId, TeamId, #team_state{kf_3v3_status = ?KF_3V3_PK_START, kf_3v3_end_time = Kf3v3EndTime} = State) ->
	#team_state{team_list = TeamList} = State,
	DailyCount = data_3v3:get_kv(daily_match_count),
	LeftTime = Kf3v3EndTime - utime:unixtime(),
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = TeamRoleList, leader_id = LeaderId, vote_ref = VoteRef,
			today_count = TodayCount, matching_status = ?team_not_matching} = Team ->
			VoteRoleList = get_vote_list(TeamRoleList, LeaderId),
			Length = length(VoteRoleList),
			RoleLength = length(TeamRoleList),
			if
				LeftTime =< ?KF_3V3_PK_TIME2 ->
					pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_come_to_end)),
					send_error(MyServerId, MyRoleId, ?ERRCODE(err650_kf_3v3_come_to_end)),
					State;
				TodayCount >= DailyCount ->  %% 匹配次数没了
%%					pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_lack_count)),
					send_error(MyServerId, MyRoleId, ?ERRCODE(err650_kf_3v3_lack_count)),
					State;
				RoleLength =/= Length ->
%%					pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_have_teammate_offline)),
					send_error(MyServerId, MyRoleId, ?ERRCODE(err650_have_teammate_offline)),
					State;
				true ->
					send_vote_role_list(VoteRoleList),
					if
						Length == 1 ->  %%只有一个人直接去匹配
							%% 广播投票结果
							VoteRole = hd(
								VoteRoleList),
							go_to_match(Team, VoteRole, []),
							send_vote_res(VoteRoleList, ?SUCCESS),
							NewTeam = Team#team_local_3v3{vote_list = VoteRoleList},
							NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
							State#team_state{team_list = NewTeamList};
						true ->
							EndTime = utime:unixtime() + ?vote_time,
							%%通知各个玩家投票的结束时间戳
							{ok, Bin} = pt_650:write(65066, [EndTime]),
							[
%%								lib_server_send:send_to_uid(VoteRoleId, Bin)
								send_to_uid(VoteServerId, VoteRoleId, Bin)
								|| #vote_role{role_id = VoteRoleId, server_id = VoteServerId} <- VoteRoleList],
							Ref = util:send_after(VoteRef, ?vote_time * 1000, self(), {vote_end, TeamId}),
							NewTeam = Team#team_local_3v3{vote_end_time = EndTime, vote_ref = Ref, vote_list = VoteRoleList},
							NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
							State#team_state{team_list = NewTeamList}
					end
			end;
		#team_local_3v3{matching_status = _Status} ->
%%			?MYLOG("3v3", "Status ~p~n", [Status]),
%%			pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_can_not_vote)),
			send_error(MyServerId, MyRoleId, ?ERRCODE(err650_can_not_vote)),
			State;
		_ ->
%%			pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_err_team_id)),
			send_error(MyServerId, MyRoleId, ?ERRCODE(err650_err_team_id)),
			State
	end;

%%队长发起投票
start_vote(MyServerId, MyRoleId, _TeamId, State) ->
%%	?MYLOG("3v3", "Status ~p~n", [Status]),
%%	pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_kf_3v3_not_start)),
	send_error(MyServerId, MyRoleId, ?ERRCODE(err650_kf_3v3_not_start)),
	State.

get_vote_list(ServerId, TeamId, MyRoleId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{vote_list = VoteRoleList, role_list = _RoleList} ->
%%			?MYLOG("cym3", "VoteRoleList ~p~n", [VoteRoleList]),
			{ok, Bin} = pt_650:write(65071, [[RoleId || #vote_role{role_id = RoleId} <- VoteRoleList]]),
			send_to_uid(ServerId, MyRoleId, Bin);
%%			lib_server_send:send_to_uid(MyRoleId, Bin);
		_ ->
			State
	end.


%%获得投票的人，只有在线的人才能投票
get_vote_list(RoleList, LeaderId) ->
	F = fun(#team_local_3v3_role{role_id = RoleId, on_line = OnlineFlag, server_id = ServerId, role_name = RoleName}, AccList) ->
		if
			OnlineFlag == ?ONLINE_ON andalso LeaderId == RoleId ->  %%队长默认同意
				[#vote_role{role_id = RoleId, vote_type = ?vote_accept, server_id = ServerId, role_name = RoleName} | AccList];
			OnlineFlag == ?ONLINE_ON ->
				[#vote_role{role_id = RoleId, vote_type = ?vote_default, server_id = ServerId, role_name = RoleName} | AccList];
			true ->
				AccList
		end
	    end,
	lists:foldl(F, [], RoleList).

%% 投票
vote(MyServerId, MyRoleId, TeamId, Type, State) ->
	Now = utime:unixtime(),
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{leader_id = LeaderId, vote_ref = VoteRef, vote_end_time = VoteEndTime, vote_list = VoteList} = Team ->
			if
				Now > VoteEndTime ->  %%超时了， 不能投票
					{ok, Bin} = pt_650:write(65067, [?ERRCODE(err286_vote_over_time), Type]),
					send_to_uid(MyServerId, MyRoleId, Bin),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					State;
				true ->
					case lists:keyfind(MyRoleId, #vote_role.role_id, VoteList) of
						#vote_role{vote_type = VoteType, role_name = VoteName} = VoteRole ->
							if
							%% 已经投票了，且是队长，有权改变投票，且是反对的，就是中途取消投票
								(VoteType =/= ?vote_default andalso MyRoleId == LeaderId andalso Type == ?vote_not_accept) orelse
									VoteType == ?vote_default -> %%没有投过票的
									%%处理投票逻辑
									{ok, Bin} = pt_650:write(65067, [?SUCCESS, Type]),
%%									lib_server_send:send_to_uid(MyRoleId, Bin),
									send_to_uid(MyServerId, MyRoleId, Bin),
									%% 广播队员投票
%%									?MYLOG("3v3", "Type ~p~n", [Type]),
									send_vote_role_type(VoteList, MyRoleId, VoteName, Type),
									if
										Type == ?vote_not_accept ->  %% 反对投票，结束整个投票进程
											erlang:cancel_timer(VoteRef),  %% 取消定时器 ， 投票结束
											NewTeam = Team#team_local_3v3{vote_ref = [], vote_end_time = 0},
											%% 广播投票结果
%%											?MYLOG("3v3", "+++++++++++to match   FAIL~n", []),
											send_vote_res(VoteList, ?FAIL),
											NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
											State#team_state{team_list = NewTeamList};
										true ->  %% 赞成
											NewVoteList = lists:keystore(MyRoleId, #vote_role.role_id, VoteList, VoteRole#vote_role{vote_type = ?vote_accept}),
											case is_can_start_match(NewVoteList) of
												true ->  %%投票结束，成功饿
													erlang:cancel_timer(VoteRef),  %% 取消定时器 ， 投票结束
													NewTeam = Team#team_local_3v3{vote_ref = [], vote_end_time = 0},
													%% 广播投票结果
													send_vote_res(VoteList, ?SUCCESS),
													NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
													%%  去匹配
%%													?MYLOG("3v3", "go_to_match VoteList ~p LeaderId ~p~n", [VoteList, LeaderId]),
													case lists:keyfind(LeaderId, #vote_role.role_id, VoteList) of
														#vote_role{} = LeaderVoteRole ->
%%															?MYLOG("3v3", "go_to_match ~n", []),
															VoteList1 = lists:keydelete(LeaderId, #vote_role.role_id, VoteList),
															go_to_match(NewTeam, LeaderVoteRole, VoteList1);
														_ ->
%%															?MYLOG("3v3", "go_to_match ~n", []),
															ok
													end,
													State#team_state{team_list = NewTeamList};
												_ -> %%还有人没有投票
													NewTeam = Team#team_local_3v3{vote_list = NewVoteList},
													NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
%%													?MYLOG("cym", "NewVoteList ~p", [NewVoteList]),
													State#team_state{team_list = NewTeamList}
											end
									end;
								true ->
									{ok, Bin} = pt_650:write(65067, [?ERRCODE(err650_voto_repeat), Type]),
									send_to_uid(MyServerId, MyRoleId, Bin),
%%									lib_server_send:send_to_uid(MyRoleId, Bin),
									State
							end;
						_ ->  %%不是投票中人
							State
					end
			end;
		_ ->
			{ok, Bin} = pt_650:write(65067, [?ERRCODE(err650_err_team_id), Type]),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			send_to_uid(MyServerId, MyRoleId, Bin),
			State
	end.

%%投票超时
vote_end(TeamId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{vote_ref = VoteRef, vote_list = VoteList} = Team ->
			erlang:cancel_timer(VoteRef),  %% 取消定时器 ， 投票结束
			NewTeam = Team#team_local_3v3{vote_list = [], vote_ref = [], vote_end_time = 0},
			[begin
				 {ok, Bin} = pt_650:write(65068, [RoleId, RoleName, ?vote_not_accept]),
				 send_to_uid(ServerId, RoleId, Bin)
%%				 lib_server_send:send_to_uid(RoleId, Bin)
			 end
				|| #vote_role{role_id = RoleId, vote_type = VoteType, server_id = ServerId, role_name = RoleName} <- VoteList, VoteType =/= ?vote_accept],
			%% 广播投票结果
%%			?MYLOG("3v3", "over time VoteList ~p~n", [VoteList]),
			send_vote_res(VoteList, ?FAIL),
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
			State#team_state{team_list = NewTeamList};
		_ ->
			State
	end.

is_can_start_match([]) ->
	true;
is_can_start_match([#vote_role{vote_type = Type} | VoteList]) ->
	if
		Type == ?vote_accept ->
			is_can_start_match(VoteList);
		true ->
			false
	end.




%%广播投票结果
send_vote_res(VoteList, Code) ->
	{ok, Bin} = pt_650:write(65069, [Code]),
	[
		send_to_uid(ServerId, RoleId, Bin)
%%		lib_server_send:send_to_uid(RoleId, Bin)
		|| #vote_role{role_id = RoleId, server_id = ServerId} <- VoteList].

send_vote_role_type(VoteList, MyRoleId, VoteName, Type) ->
	{ok, Bin} = pt_650:write(65068, [MyRoleId, VoteName, Type]),
	[
%%		lib_server_send:send_to_uid(RoleId, Bin)
		send_to_uid(ServerId, RoleId, Bin)
		|| #vote_role{role_id = RoleId, server_id = ServerId} <- VoteList].


%%通知开始匹配结果
send_pull_team_to_match_res(RoleId, Res) ->
	{ok, Bin} = pt_650:write(65021, [Res]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%通知客户端投票的在线人员
send_vote_role_list(VoteRoleList) ->
	{ok, Bin} = pt_650:write(65071, [[RoleId || #vote_role{role_id = RoleId} <- VoteRoleList]]),
	[send_to_uid(ServerId, RoleId1, Bin)
		|| #vote_role{role_id = RoleId1, server_id = ServerId} <- VoteRoleList].



%% 更新匹配状态  MatchRoleIdList zheng
refresh_team_match_status(TeamId, MatchRoleIdList, Status, State) when Status == ?team_matching orelse Status == ?team_pk ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, today_count = TodayCount} = Team ->
%%			if
%%				Status == ?team_pk ->
%%					%%
%%					[mod_daily:increment_offline(MatchRoleId, ?MOD_KF_3V3, 9)
%%						|| MatchRoleId <- MatchRoleIdList],
%%					TodayCount1 = TodayCount + 1;
%%				true ->
%%					TodayCount1 = TodayCount
%%			end,
			TodayCount1 = TodayCount,
			F = fun(#team_local_3v3_role{role_id = RoleId, server_id = ServerId} = FunRole, AccList) ->
				case lists:member(RoleId, MatchRoleIdList) of
					true ->
						if
							Status == ?team_pk ->
								mod_clusters_center:apply_cast(ServerId, mod_daily, increment_offline, [RoleId, ?MOD_KF_3V3, 9]);
							true ->
								skip
						end,
						%%通知本地锁住
						mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
							[RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [?ERRCODE(err650_in_kf_3v3_act)]]),
%%						lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [?ERRCODE(err650_in_kf_3v3_act)]),
						[FunRole#team_local_3v3_role{matching_status = Status} | AccList];
					_ ->
						[FunRole | AccList]
				end
			    end,
			NewRoleList = lists:foldl(F, [], RoleList),
			NewTeam = Team#team_local_3v3{matching_status = Status, role_list = NewRoleList, today_count = TodayCount1},
			save_to_db_only_team(NewTeam),
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
			State#team_state{team_list = NewTeamList};
		_ ->
			State
	end;
refresh_team_match_status(TeamId, _MatchRoleIdList, MatchStatus, State) ->
%%	?MYLOG("3v3", "TeamId ~p  Status ~p~n", [TeamId, MatchStatus]),
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, server_id = ServerId} = Team ->
%%			?MYLOG("3v3", "TeamId ~p  Status ~p~n", [TeamId, MatchStatus]),
			NewRoleList = [Role#team_local_3v3_role{matching_status = MatchStatus} || Role <- RoleList],
			[
%%				lib_player:apply_cast(_RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free])
				mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
					[_RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free]])
				|| #team_local_3v3_role{role_id = _RoleId} <- NewRoleList],
			NewTeam = Team#team_local_3v3{matching_status = MatchStatus, role_list = NewRoleList},
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
			State#team_state{team_list = NewTeamList};
		_ ->
			State
	end.

%%去跨服中心匹配
go_to_match(Team, LeaderVote, VoteRoleList) ->
	#team_local_3v3{
		team_id = TeamId,
		name = TeamName,
		leader_id = LeaderId
		, match_count = MatchCount
		, win_count = WinCount
		, point = Point
		, leader_name = LeaderName
		, server_id = TeamServerId
		, role_list = RoleList
	} = Team,
	case lists:keyfind(LeaderId, #team_local_3v3_role.role_id, RoleList) of
		#team_local_3v3_role{server_num = LeaderServerNum} ->
			ok;
		_ ->
			LeaderServerNum = 0
	end,
	{NTier, NewPoint} = lib_3v3_local:calc_tier_by_star(0, Point),
	F = fun(#vote_role{role_id = FunRoleId}, {AccPower, AccList}) ->
%%				case lib_role:get_role_show(FunRoleId) of
%%					#ets_role_show{figure = TempFigure, combat_power = FunPower} ->
%%						KfRole = #kf_3v3_role_data{
%%							node = node()
%%							, server_name = util:get_server_name()
%%							, server_num = config:get_server_num()
%%							, server_id = config:get_server_id()
%%							, role_id = FunRoleId
%%							, figure = TempFigure
%%							, power = FunPower
%%							, team_id = TeamId
%%							, tier = NTier
%%							, star = NewPoint
%%						},
%%						{AccPower + FunPower, [KfRole | AccList]};
%%					_ ->
%%						{AccPower, AccList}
%%				end
		case lists:keyfind(FunRoleId, #team_local_3v3_role.role_id, RoleList) of
			#team_local_3v3_role{server_num = ServerNum, server_id = ServerId, server_name = ServerName, power = FunPower, lv = Lv
				, picture_id = PictureId, picture = Picture, role_name = TempName} ->
				KfRole = #kf_3v3_role_data{
					node = node()
					, server_name = ServerName
					, server_num = ServerNum
					, server_id = ServerId
					, role_id = FunRoleId
					, figure = #figure{lv = Lv, picture = Picture, picture_ver = PictureId, name = TempName}
					, power = FunPower
					, team_id = TeamId
					, tier = NTier
					, star = NewPoint
				},
				{AccPower + FunPower, [KfRole | AccList]};
			_ ->
				{AccPower, AccList}
		end
	    end,
	{AllPower, KfRoleList} = lists:foldl(F, {0, []}, [LeaderVote | VoteRoleList]),
	
	TeamData = #kf_3v3_team_data{
		team_id = TeamId,
		team_name = TeamName,
		captain_id = LeaderId,
		captain_name = LeaderName
		, server_id = TeamServerId
		, server_num = LeaderServerNum
		, server_name = ""
		, member_num = 1 + length(VoteRoleList)
		, match_count2 = MatchCount
		, win_count = WinCount
		, power = AllPower
		, map_power = AllPower
		, member_data = KfRoleList
		, tier = NTier
		, point = NewPoint
	},
%%	?MYLOG("pk", "vote  ~p  RoleList ~p~n", [[LeaderVote | VoteRoleList], RoleList]),
%%    ?MYLOG("pk", "KfRoleList ~p~n", [KfRoleList]),
%%	?MYLOG("pk", "LeaderName ~p~n", [LeaderName]),
%%	?MYLOG("pk", "TeamData ~p~n", [TeamData]),
	mod_3v3_center:pull_team_to_match(TeamData).
%%	mod_clusters_node:apply_cast(mod_3v3_center, pull_team_to_match, [TeamData]);


send_score_rank([RoleSid, ScoreRank]) ->
%%	?MYLOG("3v3_rank", "ScoreRank ~p~n", [ScoreRank]),
	{ok, Bin} = pt_650:write(65057, [ScoreRank]),
	lib_server_send:send_to_sid(RoleSid, Bin).


%%更新战队数据的数据
center_update_local_team(TeamScore, State) ->
	#team_score{
		team_id = TeamId,
		star = Point, result = Result
	} = TeamScore,
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{win_count = WinCount, match_count = MatchCount, role_list = RoleList} = Team ->
			if
				Result == ?team_win ->
					NewWinCount = WinCount + 1;
				true ->
					NewWinCount = WinCount
			end,
			NewMatchCount = MatchCount + 1,
			NewRoleList = [Role#team_local_3v3_role{matching_status = ?team_not_matching} || Role <- RoleList],
			NewTeam = Team#team_local_3v3{point = Point, win_count = NewWinCount,
				match_count = NewMatchCount, matching_status = ?team_not_matching, role_list = NewRoleList},
%%			?MYLOG("3v3", "RoleList ~p~n NewRoleList ~p~n", [RoleList, NewRoleList]),
			save_to_db_only_team(NewTeam),
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
			LastTeamList = lib_3v3_api:sort_team(NewTeamList),
			NewState = State#team_state{team_list = LastTeamList},
			NewState;
		_ ->
			State
	end.


%%停止匹配
stop_match(TeamId, MyServerId, RoleId, State) ->
%%	?MYLOG("cym3", "stop_match ~p~n", [stop_match]),
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{matching_status = MatchingStatus, vote_list = VoteList, role_list = RoleList} = Team ->
			if
				MatchingStatus == ?team_matching ->
%%					mod_clusters_node:apply_cast(mod_3v3_center, stop_matching_team, [[TeamId, config:get_server_id(), RoleId]]),
					mod_3v3_center:stop_matching_team([TeamId, MyServerId, RoleId]),
					{ok, Bin} = pt_650:write(65022, [?SUCCESS, util:get_server_name(), config:get_server_num(), RoleId]),
					?MYLOG("cym3", "VoteList ~p~n", [VoteList]),
					[send_to_uid(ServerId, TempRoleId, Bin) || #vote_role{role_id = TempRoleId, server_id = ServerId} <- VoteList],
					NewRoleList = [Role#team_local_3v3_role{matching_status = ?team_not_matching} || Role <- RoleList],
					[
						mod_clusters_center:apply_cast(ServerId2, lib_player,
							apply_cast, [_RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, cast_change_status, [free]])
						|| #team_local_3v3_role{role_id = _RoleId, server_id = ServerId2} <- NewRoleList],
					Team1 = Team#team_local_3v3{matching_status = ?team_not_matching, role_list = NewRoleList},
%%					?MYLOG("cym3", "RoleList ~p NewRoleList ~p~n", [RoleList, NewRoleList]),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team1),
					State#team_state{team_list = NewTeamList};
				true ->
%%					?MYLOG("cym3", "VoteList ~p~n", [VoteList]),
					send_error(MyServerId, RoleId, ?ERRCODE(err650_team_not_matching)),
%%					pp_3v3:send_error(RoleId, ?ERRCODE(err650_team_not_matching)),
					State
			end;
		_ ->
			send_error(MyServerId, RoleId, ?ERRCODE(err650_err_team_id)),
%%			pp_3v3:send_error(RoleId, ?ERRCODE(err650_err_team_id)),
			State
	end.



daily_reset(State) ->
	Sql = io_lib:format(<<"UPDATE  team_3v3 set  today_count = 0   where   today_count > 0 ">>, []),
	db:execute(Sql),
	Sql2 = io_lib:format(<<"update  team_3v3 set yesterday_point = point  where   yesterday_point <> point ">>, []),
	db:execute(Sql2),
	#team_state{team_list = TeamList} = State,
	NewTeamList = [Team#team_local_3v3{matching_status = ?team_not_matching, today_count = 0, yesterday_point = Point}
		|| #team_local_3v3{point = Point} = Team <- TeamList],
	LastTeamList = handle_over_time_leader(NewTeamList),
	State#team_state{team_list = LastTeamList}.


%---------------------------------------------- db -----------------------------------------------------
%%删除单个玩家
db_delete_role_only(RoleId, TeamId) ->
	Sql = io_lib:format(?delete_team_role, [TeamId, RoleId]),
	db:execute(Sql).

%%删除整个队伍
db_delete_team(Team) ->
	#team_local_3v3{team_id = TeamId, role_list = RoleList} = Team,
	Sql = io_lib:format(?delete_team, [TeamId]),
	db:execute(Sql),
	[db_delete_role_only(RoleId, TeamId) || #team_local_3v3_role{role_id = RoleId}
		<- RoleList].

save_to_db(Team) ->
	#team_local_3v3{role_list = RoleList, team_id = TeamId} = Team,
	save_to_db_only_team(Team),
	save_to_db_role_list(RoleList, TeamId).

save_to_db_only_team(Team) ->
	#team_local_3v3{team_id = TeamId, name = Name,
		leader_id = LeaderId, match_count = MatchCount, win_count = WinCount, point = Point,
		today_count = TodayCount, yesterday_point = YesterdayPoint, champion_rank = ChampionRank, is_change_name = IsChange, leader_name = LeaderName
		, server_id = ServerId} = Team,
	Sql = io_lib:format(?save_team, [TeamId, util:fix_sql_str(Name), LeaderId, MatchCount, WinCount, Point, TodayCount, YesterdayPoint, ChampionRank, IsChange, ServerId, util:fix_sql_str(LeaderName)]),
%%	?MYLOG("sql", "Sql ~s~n", [Sql]),
	db:execute(Sql).

save_to_db_role_list(RoleList, TeamId) ->
	[save_to_db_role(RoleMsg, TeamId) || RoleMsg <- RoleList].


save_to_db_role(RoleMsg, TeamId) ->
	#team_local_3v3_role{role_id = RoleId, server_name = ServerName,
		server_num = ServerNum, turn = Turn, login_time = LoginTime, logout_time = LogoutTime, power = Power, server_id = ServerId, lv = Lv,
		picture = Picture,
		picture_id = PictureId,
		role_name = RoleName
	} = RoleMsg,
%%	?MYLOG("sql", "Sql ~p~n", [{TeamId, RoleId, ServerNum, ServerName, Turn, LoginTime,
%%		LogoutTime, Power, ServerId, Lv, PictureId, Picture, RoleName}]),
	Sql = io_lib:format(?save_team_role, [TeamId, RoleId, ServerNum, ServerName, Turn, LoginTime,
		LogoutTime, Power, ServerId, Lv, PictureId, Picture, util:fix_sql_str(RoleName)]),
%%	?MYLOG("sql", "Sql ~s~n", [Sql]),
	db:execute(Sql).

%%保存玩家进程中的战队数据
save_to_db_role_ps(RoleId, #role_3v3_new{team_id = TeamId, team_name = TeamName, leader_id = LeaderId}) ->
	Sql = io_lib:format(?save_team_role_ps, [RoleId, LeaderId, TeamId, util:fix_sql_str(TeamName)]),
	db:execute(Sql).


%---------------------------------------------- db -----------------------------------------------------




%%检查名字
check_team_name(TeamName, TeamList) ->
	case validate_name(TeamName) of
		{false, 7} -> {false, ?ERRCODE(err145_2_word_is_sensitive)};
		{false, 5} -> {false, ?ERRCODE(err650_team_err_length)};
		{false, 4} -> {false, ?ERRCODE(illegal_character)};
		{false, 3} -> {false, ?ERRCODE(name_exist)};
		true ->
			%%名字是否重复
			validate_name_repeat(TeamName, TeamList);
		_ -> {false, 0}
	end.


%% 角色名合法性检测
validate_name(Name) ->
	validate_name(len, Name).

%% 角色名合法性检测:长度
validate_name(len, Name) ->
	case unicode:characters_to_list(list_to_binary(Name)) of
		CharList when is_list(CharList) ->
			case lib_player:judge_char_len(CharList) of
				true ->
					Len = util:string_width(CharList),
%%					?MYLOG("3v3", "Len ~p~n", [Len]),
					case Len =< 10 andalso Len >= 1 of  %%角色名称长度为1~5个汉字
						true ->
							true;
%%							validate_name(keyword, Name);
						false ->
							{false, 5}
					end;
				_ ->
					{false, 4}
			end;
		_ ->
			%%非法字符
			{false, 4}
	end;


%%判断角色名是有敏感词
%%Name:角色名
validate_name(keyword, Name) ->
	case lib_word:check_keyword_name(Name) of
		false -> true;
		_ -> {false, 7}
	end;

validate_name(_, _Name) ->
	{false, 2}.


validate_name_repeat(_TeamName, []) ->
	true;
validate_name_repeat(TeamName, [Team | TeamList]) ->
	#team_local_3v3{name = OldTeamName} = Team,
%%	?MYLOG("3v3", "OldTeamName ~p~n", [OldTeamName]),
	IsBinary = is_binary(OldTeamName),
	if
		IsBinary == true ->
			OldTeamName1 = binary_to_list(OldTeamName);
		true ->
			OldTeamName1 = OldTeamName
	end,
	if
		TeamName == OldTeamName1 ->
			{false, ?ERRCODE(name_exist)};
		true ->
			validate_name_repeat(TeamName, TeamList)
	end.


%%创建队伍扣钱
create_team_cost(PS) ->
	Cost = data_3v3:get_kv(create_team_cost),
	case lib_goods_api:cost_object_list_with_check(PS, Cost, create_3v3_team, "") of
		{true, NewPS} ->
%%			?MYLOG("3v3", "Cost ~p~n", [Cost]),
			NewPS;
		{false, Error, _} ->
			pp_3v3:send_error(PS#player_status.id, Error),
			PS
	end.

%%催促队长
urge_leader(ServerId, TeamId, MyRoleId, Name, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{leader_id = LeaderId} ->
			{ok, Bin} = pt_650:write(65073, [?SUCCESS]),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			send_to_uid(ServerId, MyRoleId, Bin),
			{ok, Bin1} = pt_650:write(65074, [MyRoleId, Name]),
			send_to_uid(ServerId, LeaderId, Bin1);
%%			lib_server_send:send_to_uid(LeaderId, Bin1);
		_ ->
			send_error(ServerId, MyRoleId, ?ERRCODE(err650_err_team_id))
%%			pp_3v3:send_error(MyRoleId, ?ERRCODE(err650_err_team_id))
	end.

%%发送个人奖励领取状态
send_reward_info(ServerId, PackReward, Honor, TeamId, RoleId, MatchingStatus, DailyPk, TodayRewardStatus, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{win_count = SeasonWin, match_count = SeasonCount,
			point = Point, yesterday_point = YesterdayPoint, champion_rank = ChampionRank} ->
			SeasonEndTime = lib_3v3_api:get_season_end_time(),
%%			DailyPk = mod_daily:get_count(RoleId, ?MOD_KF_3V3, 9),
			NewPackReward = pp_3v3:get_send_pack_reward(PackReward, DailyPk),
			ActEndTime = get_end_time(),
			{Tier, Star} = calc_tier_by_star(0, Point),
			{OldTier, _OldStar} = calc_tier_by_star(0, YesterdayPoint),
%%			TodayRewardStatus = ?IF(mod_daily:get_count(RoleId, ?MOD_KF_3V3, 8) >= 1, 1, 0),  %% 0是未领取 ，1 是已经领取
			Data = [Tier, Star, 0, 0, DailyPk, SeasonWin, SeasonCount, NewPackReward, Honor,
				OldTier, ChampionRank, TodayRewardStatus, SeasonEndTime, ActEndTime, MatchingStatus],
%%			?MYLOG("3v3", "Data ~p~n", [Data]),
			{ok, Bin} = pt_650:write(65000, Data),
			send_to_uid(ServerId, RoleId, Bin);
%%			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
			SeasonEndTime = lib_3v3_api:get_season_end_time(),
%%			DailyPk = mod_daily:get_count(RoleId, ?MOD_KF_3V3, 9),
			NewPackReward = pp_3v3:get_send_pack_reward(PackReward, DailyPk),
			ActEndTime = get_end_time(),
			{Tier, Star} = calc_tier_by_star(0, 0),
			{OldTier, _OldStar} = calc_tier_by_star(0, 0),
%%			TodayRewardStatus = ?IF(mod_daily:get_count(RoleId, ?MOD_KF_3V3, 8) >= 1, 1, 0),  %% 0是未领取 ，1 是已经领取
			Data = [Tier, Star, 0, 0, DailyPk, 0, 0, NewPackReward, Honor,
				OldTier, 0, TodayRewardStatus, SeasonEndTime, ActEndTime, MatchingStatus],
%%			?MYLOG("3v3", "Data ~p~n", [Data]),
			{ok, Bin} = pt_650:write(65000, Data),
			send_to_uid(ServerId, RoleId, Bin)
%%			lib_server_send:send_to_uid(RoleId, Bin)
	end.


get_end_time() ->
	case lib_3v3_local:load_act_time() of
		{StTime, EdTime} ->
			Now = utime:unixtime(),
			DataTime = utime:unixdate(),
			if
				Now >= StTime + DataTime andalso Now =< EdTime + DataTime ->
					EdTime + DataTime;
				true ->
					0
			end;
		_ ->
			0
	end.


get_today_reward(ServerId, RoleID, TeamId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{point = Point} ->
			{Tier, _} = calc_tier_by_star(0, Point),
			case data_3v3:get_tier_info(Tier) of
				#tier_info{today_reward = Reward} ->
%%					?MYLOG("cym", "Reward ~p~n", [Reward]),
					Produce = #produce{type = kf_3v3_daily, reward = Reward},
					lib_log_api:log_3v3_today_reward(RoleID, Tier, Reward),
%%					mod_daily:increment_offline(RoleID, ?MOD_KF_3V3, 8),
					mod_clusters_center:apply_cast(ServerId, mod_daily, increment_offline, [RoleID, ?MOD_KF_3V3, 8]),
%%					lib_goods_api:send_reward_with_mail(RoleID, Produce),
					mod_clusters_center:apply_cast(ServerId, lib_goods_api, send_reward_with_mail, [RoleID, Produce]),
					{ok, Bin} = pt_650:write(65003, [?SUCCESS]),
					send_to_uid(ServerId, RoleID, Bin);
%%					lib_server_send:send_to_uid(RoleID, Bin);
				_ ->
					ok
			end;
		_ ->
			{Tier, _} = calc_tier_by_star(0, 0),
			case data_3v3:get_tier_info(Tier) of
				#tier_info{today_reward = Reward} ->
%%					?MYLOG("cym", "Reward ~p~n", [Reward]),
					Produce = #produce{type = kf_3v3_daily, reward = Reward},
					lib_log_api:log_3v3_today_reward(RoleID, Tier, Reward),
%%					mod_daily:increment_offline(RoleID, ?MOD_KF_3V3, 8),
					mod_clusters_center:apply_cast(ServerId, mod_daily, increment_offline, [RoleID, ?MOD_KF_3V3, 8]),
%%					lib_goods_api:send_reward_with_mail(RoleID, Produce),
					mod_clusters_center:apply_cast(ServerId, lib_goods_api, send_reward_with_mail, [RoleID, Produce]),
					{ok, Bin} = pt_650:write(65003, [?SUCCESS]),
					send_to_uid(ServerId, RoleID, Bin);
%%					lib_server_send:send_to_uid(RoleID, Bin);
				_ ->
					ok
			end
	end.

%%获取每日匹配奖励
get_daily_match_reward(TeamId, RoleID, RewardID, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{today_count = TodayCount} ->
			lib_player:apply_cast(RoleID, ?APPLY_CAST_SAVE, lib_3v3_local, get_daily_match_reward, [RewardID, TodayCount]);
		_ ->
			ok
	end.


get_daily_match_reward(Status, RewardID, DailyPk) ->
	#player_status{role_3v3 = Role3v3, id = RoleID} = Status,
	#role_3v3{pack_reward = PackReward} = Role3v3,
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
				RewardID == 0 ->
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
	lib_server_send:send_to_uid(RoleID, Bin),
	NStatus.


update_yesterday_point(State) ->
	#team_state{team_list = TeamList} = State,
	NewTeamList = [Team#team_local_3v3{yesterday_point = Point} || #team_local_3v3{point = Point} = Team <- TeamList],
	Sql = io_lib:format(<<"update  team_3v3 set yesterday_point = point">>, []),
	db:execute(Sql),
	State#team_state{team_list = NewTeamList}.


update_change_name(ServerId, MyRoleId, TeamId, Name, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList, leader_id = LeaderId} = OldTeam ->
			case lib_3v3_local:check_team_name(Name, TeamList) of
				true ->
					NewTeam = OldTeam#team_local_3v3{name = Name, is_change_name = 1},
					save_to_db_only_team(NewTeam),
					[update_role_team_msg(MemberId, TeamId, LeaderId, Name, ServerId2) || #team_local_3v3_role{role_id = MemberId, server_id = ServerId2} <- RoleList],
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
					{ok, Bin} = pt_650:write(65058, [Name, ?SUCCESS]),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					send_to_uid(ServerId, MyRoleId, Bin),
%%					lib_player:apply_cast(MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, change_team_name_cost, []),
					mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
						[MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, change_team_name_cost, []]),
					log_3v3_team_member(NewTeam, ?team_3v3_change_name, [#team_local_3v3_role{role_id = MyRoleId}]),
%%					mod_clusters_node:apply_cast(mod_3v3_rank, refresh_3v3_team2, [{update_name, TeamId, Name}]),
					mod_3v3_rank:refresh_3v3_team2({update_name, TeamId, Name}),
					State#team_state{team_list = NewTeamList};
				{false, Error} ->
					{ok, Bin} = pt_650:write(65058, ["", Error]),
%%					lib_server_send:send_to_uid(MyRoleId, Bin),
					send_to_uid(ServerId, MyRoleId, Bin),
					State
			end;
		_ ->
			{ok, Bin} = pt_650:write(65058, ["", ?ERRCODE(err650_err_team_id)]),
%%			lib_server_send:send_to_uid(MyRoleId, Bin),
			send_to_uid(ServerId, MyRoleId, Bin),
			State
	end.



%%更新跨服中心冠军赛的信息  todo
update_champion_role_data(TeamIds, State) ->
%%	?MYLOG("3v3", "TeamIds ~p~n", [TeamIds]),
	#team_state{team_list = TeamList} = State,
	%%
	Title = utext:get(6500015),
	Content = utext:get(6500016),
	F = fun(#team_local_3v3{team_id = TeamId, role_list = RoleList, match_count = MatchCount, win_count = WinCount}, AccList) ->
		case lists:member(TeamId, TeamIds) of
			true ->
				ChampionRoleList = get_champion_role_list(RoleList),
%%				?MYLOG("3v3", "RoleList ~p~n", [RoleList]),
%%				lib_mail_api:send_sys_mail([RoleId], Title, Content, [])
				[   mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, []])
					|| #team_local_3v3_role{role_id = RoleId, server_id = ServerId} <- RoleList],
				[{TeamId, ChampionRoleList, WinCount, MatchCount} | AccList];
			_ ->
				AccList
		end
	    end,
	Res = lists:foldl(F, [], TeamList),
%%	?MYLOG("3v3", "Res ~p~n", [Res]),
	mod_3v3_champion:update_champion_role_data(Res).
%%	mod_clusters_node:apply_cast(mod_3v3_champion, update_champion_role_data, [Res]).



%%
get_champion_role_list(RoleList) ->
	F = fun(#team_local_3v3_role{role_id = RoleId, server_id = ServerId, role_name = RoleName, lv = Lv,
		server_name = ServerName, server_num = ServerNum, career = Career, power = Power}, AccList) ->
		Role =
			#champion_team_role{
				role_id = RoleId,
				role_name = RoleName,
				server_id = ServerId,
				server_num = ServerNum
				, server_name = ServerName,
				career = Career
				, sex = 0
				, power = Power
				, lv = Lv
				, lv_figure = []
				, fashion_model = []
				, mount_figure = []
				, picture = []
				, picture_id = 0
			},
		[Role | AccList]
	    end,
	lists:foldl(F, [], RoleList).


update_local_role_status(RoleId, Status) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_3v3_local, update_local_role_status, [Status]);


update_local_role_status(PS, Status) ->
%%	?MYLOG("pk", "Status ~p~n", [Status]),
	#player_status{team_3v3 = Role3v3} = PS,
	case Role3v3 of
		#role_3v3_new{} ->
			PS#player_status{team_3v3 = Role3v3#role_3v3_new{is_in_champion_pk = Status}};
		_ ->
			PS
	end.


call_team_role(TeamId, MyRoleId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} ->
			[lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_3v3_local, call_team_role, []) ||
				#team_local_3v3_role{role_id = RoleId} <- RoleList, RoleId =/= MyRoleId];
		_ ->
			ok
	end.


%%召集队员
call_team_role(PS) ->
	#player_status{id = RoleId, scene = Scene} = PS,
	case lib_3v3_api:is_3v3_champion_scene(Scene) of
		true ->
			ok;
		_ ->
			{ok, Bin} = pt_650:write(65079, []),
			lib_server_send:send_to_uid(RoleId, Bin)
	end.

init_guess_record(Role3v3, RoleId) ->
	Sql = io_lib:format(?select_from_guess_record, [RoleId]),
	List = db:get_all(Sql),
	RecordList = [#role_guess_record{
		key = {Turn, TeamAId, TeamBId, utime:unixdate(Time)},
		pk_res = util:bitstring_to_term(PkRes),
		turn = Turn, opt = Opt, res = Res,
		team_a = binary_to_list(TeamAName),
		team_b = binary_to_list(TeamBName),
		reward = util:bitstring_to_term(Reward),
		cost = util:bitstring_to_term(Cost),
		status = Status,
		time = Time,
		team_a_id = TeamAId,
		team_b_id = TeamBId
	}
		|| [PkRes, Turn, Opt, Res, TeamAName, TeamBName, Reward, Cost, Status, Time, TeamAId, TeamBId] <- List],
	Role3v3#role_3v3_new{guess_record = RecordList}.

%%通知玩家竞猜结果
notice_role_guess_result(RoleId, PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn) when is_integer(RoleId) ->
%%	?MYLOG("guess", "PkRes ~p~n", [PkRes]),
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE,
		lib_3v3_local, notice_role_guess_result, [PkRes, TeamAId, TeamAName, TeamBId, TeamBName, Turn]);
notice_role_guess_result(PS, PkRes, TeamAId, _TeamAName, TeamBId, _TeamBName, Turn) ->
%%	?MYLOG("guess", "PkRes ~p~n", [PkRes]),
	#player_status{team_3v3 = Team3v3, id = RoleId} = PS,
	case Team3v3 of
		#role_3v3_new{guess_record = GuessRecordList} ->
			case lists:keyfind({Turn, TeamAId, TeamBId, utime:unixdate()}, #role_guess_record.key, GuessRecordList) of
				#role_guess_record{pk_res = OldPKRes, opt = Opt, cost = Cost} = Record ->
					{Result, Reward} = handle_guess_answer(Turn, Opt, PkRes, Cost),  %%计算竞猜结果
					case Reward of
						[{_, _, Num} | _] when Num =< 0 -> %% 数量 = 0是不能领取的
							NewRecord = Record#role_guess_record{pk_res = [PkRes | OldPKRes], res = Result, reward = Reward, status = 0};
						_ ->
							NewRecord = Record#role_guess_record{pk_res = [PkRes | OldPKRes], res = Result, reward = Reward, status = 1}
					end,
					%%save to db
					save_guess_record_to_db(RoleId, NewRecord),
					log_3v3_guess(RoleId, NewRecord),
					NewGuessRecordList = lists:keystore({Turn, TeamAId, TeamBId, utime:unixdate()}, #role_guess_record.key, GuessRecordList, NewRecord),
					NewTeam3v3 = Team3v3#role_3v3_new{guess_record = NewGuessRecordList},
					NewPS = PS#player_status{team_3v3 = NewTeam3v3},
					pp_3v3:handle(65082, NewPS, []),
					NewPS;
				_ ->
					PS
			end;
		_ ->
			PS
	end.

%% 计算竞猜所得
%% Turn 轮次
%% opt  选项
%% pkRes 结果  {类型, 值}
handle_guess_answer(Turn, Opt, PkRes, Cost) ->
	{_, Answer} = PkRes,   %%比赛答案
	CostType =
		case Cost of
			[{?TYPE_BGOLD, 0, CostNum} | _] ->
				?TYPE_BGOLD;
			[{?TYPE_CURRENCY, _CostType, CostNum} | _] ->
				_CostType;
			_ ->
				CostNum = 0,
				?TYPE_BGOLD
		end,
	case data_3v3:get_guess_config(Turn) of
		#base_guess_config{opt_list = OptList, reward_list = RewardList} ->
			Result =
				case lists:keyfind(Opt, 1, OptList) of
					{Opt, Value} ->
						if
							Answer == Value ->  %% 1对
								1;
							true -> %% 2错
								2
						end;
					{Opt, MinValue, MaxValue} ->
						if
							Answer >= MinValue andalso Answer =< MaxValue -> %% 1对
								1;
							true -> %% 2错
								2
						end;
					_ ->
						?ERR("missconfig~n", []),
						0
				end,
			case lists:keyfind(Result, 1, RewardList) of
				{Result, RewardList2} ->
					case lists:keyfind(CostType, 1, RewardList2) of
						{CostType, Ratio} ->  %%倍率
							RewardNum = erlang:round(CostNum * Ratio),
							case CostType of
								?TYPE_BGOLD ->
									{Result, [{?TYPE_BGOLD, 0, RewardNum}]};
								_ ->
									{Result, [{?TYPE_CURRENCY, CostType, RewardNum}]}
							end;
						_ ->
							?ERR("missconfig~n", []),
							{0, []}
					end;
				_ ->
					?ERR("missconfig~n", []),
					{0, []}
			end;
		_ ->
			?ERR("missconfig~n", []),
			{0, []}
	end.



save_guess_record_to_db(RoleId, Record) ->
	#role_guess_record{
		turn = Turn,
		pk_res = PkRes,
		opt = Opt,
		res = Res,
		team_a = TeamAName,
		team_b = TeamBName,
		reward = Reward,
		cost = Cost,
		status = Status,
		time = Time,
		team_a_id = TeamAId,
		team_b_id = TeamBId
	} = Record,
	Sql = io_lib:format(?save_guess_record, [RoleId, util:term_to_bitstring(PkRes), Turn,
		Opt, Res, TeamAName, TeamBName, util:term_to_bitstring(Reward), util:term_to_bitstring(Cost), Status, Time, TeamAId, TeamBId]),
	db:execute(Sql).


guess_success(MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum, TeamAName, TeamBName) when is_integer(MyRoleId) ->
	lib_player:apply_cast(MyRoleId, ?APPLY_CAST_SAVE, lib_3v3_local, guess_success, [Turn, TeamAId, TeamBId, Opt, CostType, CostNum, TeamAName, TeamBName]);


guess_success(PS, Turn, TeamAId, TeamBId, Opt, CostType, CostNum, TeamAName, TeamBName) ->
	#player_status{team_3v3 = Team3v3, id = RoleId} = PS,
	case Team3v3 of
		#role_3v3_new{guess_record = GuessRecordList} ->
			Cost = get_guess_cost(CostType, CostNum),
			case lib_goods_api:cost_object_list_with_check(PS, Cost, guess_3v3_cost, "") of
				{true, NewPs} ->
					Record =
						#role_guess_record{
							key = {Turn, TeamAId, TeamBId, utime:unixdate()},
							turn = Turn,
							pk_res = [],
							opt = Opt,
							res = 0,
							team_a = TeamAName,
							team_b = TeamBName,
							reward = [],
							cost = Cost,
							status = 0,
							team_a_id = TeamAId,
							team_b_id = TeamBId,
							time = utime:unixtime()
						},
					save_guess_record_to_db(RoleId, Record),
					NewGuessRecordList = lists:keystore({Turn, TeamAId, TeamBId, utime:unixdate()}, #role_guess_record.key, GuessRecordList, Record),
					NewPs#player_status{team_3v3 = Team3v3#role_3v3_new{guess_record = NewGuessRecordList}};
				{false, Error, _} ->
					pp_3v3:send_error(RoleId, Error),
					PS
			end;
		_ ->
			PS
	end.



get_guess_cost(CostType, Num) ->
	if
		CostType < 10 ->
			[{CostType, 0, Num}];
		true ->
			[{?TYPE_CURRENCY, CostType, Num}]
	end.



send_all_server_guess_list_and_team_list(Bin1, Bin2) ->
%%	?MYLOG("3v3pk", "Bin ~p  ~p ~n", [Bin1, Bin2]),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, lib_3v3_local, send_all_server_guess_list_and_team_list, [Bin1, Bin2]) || E <- OnlineRoles].

%%
send_all_server_guess_list_and_team_list(PS, Bin1, Bin2) ->
	#player_status{sid = Sid, figure = Figure} = PS,
	if
		Figure#figure.lv >= ?KF_3V3_LV_LIMIT ->
%%			?MYLOG("3v3pk", "Bin ~p  ~p ~n", [Bin1, Bin2]),
			lib_server_send:send_to_sid(Sid, Bin1),
			lib_server_send:send_to_sid(Sid, Bin2);  %% 65075的协议
		true ->
			ok
	end.

send_all_server_stage_msg(Bin) ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
%%	?MYLOG("3v3pk", "send_all_server_stage_msg ~n", []),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, lib_3v3_local, send_all_server_stage_msg, [Bin]) || E <- OnlineRoles].


send_all_server_stage_msg(PS, Bin) ->
%%	?MYLOG("3v3pk", "send_all_server_stage_msg ~p~n", [Bin]),
	#player_status{sid = Sid, figure = Figure} = PS,
	if
		Figure#figure.lv >= ?KF_3V3_LV_LIMIT ->
			lib_server_send:send_to_sid(Sid, Bin);  %% 65088的协议
		true ->
			ok
	end.

%%玩家登录
role_login(TeamId, RoleId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{login_time = utime:unixtime(), on_line = ?ONLINE_ON},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.

%% 玩家客户端断开连接
role_logout(TeamId, RoleId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{logout_time = utime:unixtime(), on_line = ?ONLINE_OFF},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.


update_power(TeamId, RoleId, Power, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{power = Power},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.

update_lv(TeamId, RoleId, Lv, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{lv = Lv},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.

update_picture(TeamId, RoleId, Picture, PictureId, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{picture = Picture, picture_id = PictureId},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.


update_role_name(TeamId, RoleId, RoleName, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{role_list = RoleList} = Team ->
			case lists:keyfind(RoleId, #team_local_3v3_role.role_id, RoleList) of
				#team_local_3v3_role{} = Role ->
					NewRole = Role#team_local_3v3_role{role_name = RoleName},
					NewRoleList = lists:keystore(RoleId, #team_local_3v3_role.role_id, RoleList, NewRole),
					NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, Team#team_local_3v3{role_list = NewRoleList}),
					save_to_db_role(NewRole, TeamId),  %% 同步数据库
					State#team_state{team_list = NewTeamList};
				_ ->
					State
			end;
		_ ->
			State
	end.


handle_over_time_leader(TeamList) ->
	F = fun(Team, AccList) ->
		#team_local_3v3{role_list = RoleList, leader_id = LeaderId, name = TeamName, team_id = TeamId} = Team,
		case lists:keyfind(LeaderId, #team_local_3v3_role.role_id, RoleList) of
			#team_local_3v3_role{login_time = LoginTime, logout_time = LogoutTime} ->
				IsOverTime = is_over_time(LoginTime, LogoutTime),
				if
					IsOverTime == true ->
						case get_other_leader(RoleList) of
							#team_local_3v3_role{role_id = ChangeLeaderId, role_name = NewLeaderName} ->
								NewTeam = Team#team_local_3v3{leader_id = ChangeLeaderId},
								save_to_db_only_team(NewTeam),
								[update_role_team_msg(MemberId, TeamId, ChangeLeaderId, TeamName, ServerId) || #team_local_3v3_role{role_id = MemberId, server_id = ServerId} <- RoleList],
								%%广播队伍信息
								send_team_msg_to_all(NewTeam),
%%								OldLeaderName = lib_role:get_role_name(OldLeader),
%%								%%邮件
%%								Title = utext:get(6500009),
%%								Content = utext:get(6500010, [OldLeaderName, TeamName]),
%%								lib_mail_api:send_sys_mail([ChangeLeaderId], Title, Content, []),
%%								NewLeaderName = lib_role:get_role_name(ChangeLeaderId),
								mod_clusters_node:apply_cast(mod_3v3_rank, refresh_3v3_team2, [{update_leader_id, TeamId, ChangeLeaderId, NewLeaderName}]),
								[NewTeam | AccList];
							_ ->
								[Team | AccList]
						end;
					true ->
						[Team | AccList]
				end;
			_ ->
				[Team | AccList]
		end
	    end,
	lists:reverse(lists:foldl(F, [], TeamList)).


is_over_time(Time1, Time2) ->
	Now = utime:unixtime(),
	if
		Now - Time1 > 3 * ?ONE_DAY_SECONDS andalso Now - Time2 > 3 * ?ONE_DAY_SECONDS ->
			true;
		true ->
			false
	end.

get_other_leader(RoleList) ->
	RoleList1 = [Role || #team_local_3v3_role{logout_time = LogoutTime, login_time = LoginTime} = Role <- RoleList,
		is_over_time(LoginTime, LogoutTime) == false],
	case RoleList1 of
		[] ->
			[];
		_ ->
			SortRoleList = sort_role_list_by_power(RoleList1),
			hd(SortRoleList)
	end.


sort_role_list_by_power(RoleList) ->
	F = fun(A, B) ->
		A#team_local_3v3_role.power >= B#team_local_3v3_role.power
	    end,
	lists:sort(F, RoleList).



update_rank(TeamId, Rank, State) ->
	#team_state{team_list = TeamList} = State,
	case lists:keyfind(TeamId, #team_local_3v3.team_id, TeamList) of
		#team_local_3v3{} = OldTeam ->
			NewTeam = OldTeam#team_local_3v3{champion_rank = Rank},
			save_to_db_only_team(NewTeam),
			NewTeamList = lists:keystore(TeamId, #team_local_3v3.team_id, TeamList, NewTeam),
			State#team_state{team_list = NewTeamList};
		_ ->
			State
	end.


%% 记录战队成员日志
log_3v3_team_member(#team_local_3v3{team_id = TeamId, name = TeamName}, EventType, EventParam) ->
%%	?MYLOG("log_3v3", "EventType, EventParam ~p~n", [{EventType, EventParam}]),
	{NewRoleId, NewEventParam} = case EventType of
		                             ?team_3v3_create ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = util:term_to_string(),
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "创队"]),
			                             {RoleId, Str};
		                             ?team_3v3_join ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "加入队伍"]),
			                             {RoleId, Str};
		                             ?team_3v3_knick_out ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             Rlib_3v3_champion_modoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "被踢"]),
			                             {RoleId, Str};
		                             ?team_3v3_change_leader ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "队长"]),
			                             {RoleId, Str};
		                             ?team_3v3_disband ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "解散"]),
			                             {RoleId, Str};
		                             ?team_3v3_quit ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "自动退出"]),
			                             {RoleId, Str};
		                             ?team_3v3_auto_leader ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "自动继承队长"]),
			                             {RoleId, Str};
		                             ?team_3v3_change_name ->
			                             [#team_local_3v3_role{role_id = RoleId}] = EventParam,
%%			                             RoleName = lib_role:get_role_name(RoleId),
%%			                             RoleName = "",
			                             Str = lists:concat([uio:thing_to_string(RoleId), ?SEPARATOR_STRING, "改名"]),
			                             {RoleId, Str};
		                             _ ->
			                             ""
	                             end,
	lib_log_api:log_3v3_team_member(TeamId, TeamName, EventType, NewRoleId, NewEventParam, utime:unixtime()),
	ok.


log_3v3_guess(RoleId, Record) ->
	#role_guess_record{turn = Turn, pk_res = PKRes, opt = Opt, reward = Reward, cost = Cost} = Record,
	lib_log_api:log_3v3_guess(RoleId, Turn, PKRes, Opt, Reward, Cost).


start_3v3(Time, State) ->
	#team_state{end_ref = OldRef} = State,
	if
		Time == 0 ->
			util:cancel_timer(OldRef),
			State#team_state{kf_3v3_status = ?KF_3V3_STATE_END, kf_3v3_end_time = 0, end_ref = []};
		Time > 0 ->
			NewRef = util:send_after(OldRef, Time * 1000, self(), {stop_3v3}),
			State#team_state{kf_3v3_status = ?KF_3V3_STATE_START,
				kf_3v3_end_time = utime:unixtime() + Time, end_ref = NewRef}
	end.


stop_3v3(State) ->
	#team_state{end_ref = Ref} = State,
	util:cancel_timer(Ref),
	State#team_state{kf_3v3_status = ?KF_3V3_STATE_END, kf_3v3_end_time = 0, end_ref = []}.


send_to_uid(ServerId, RoleId, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).


send_error(ServerId, RoleId, Error) ->
	{ok, Bin} = pt_650:write(65001, [Error]),
	send_to_uid(ServerId, RoleId, Bin).

%% 将本地的数据更新到跨服中心
sync_server_data() ->
	%% 旧战队是没有队长名字和服务器id的
	%% 个人信息也没有等级， 头像id, 头像，名字，战力最好也是重新取
	Sql = io_lib:format(?select_3v3_team, []),
	DBTeamList = db:get_all(Sql),
	
	TeamList = [#team_local_3v3{team_id = TeamId, name = binary_to_list(DbName),
		leader_id = LeaderId, match_count = MatchCount, win_count = WinCount, server_id = config:get_server_id(),
		point = Point, today_count = TodayCount, yesterday_point = YesterdayPoint, champion_rank = ChampionRank, is_change_name = IsChangeName}
		|| [TeamId, DbName, LeaderId, MatchCount, WinCount, Point, TodayCount, YesterdayPoint, ChampionRank, IsChangeName, _ServerId, _DbLeaderName] <- DBTeamList],
	TeamList1 = lib_3v3_api:sort_team(TeamList),
	F = fun(Team, {AccList, RoleIdList}) ->
		#team_local_3v3{team_id = TeamId, leader_id = LeaderId} = Team,
		LeaderName = lib_role:get_role_name(LeaderId),
		_Sql = io_lib:format(?select_3v3_team_role, [TeamId]),
		DbList = db:get_all(_Sql),
%%		RoleList = [#team_local_3v3_role{role_id = RoleId, server_name = ServerName, lv = Lv, picture = binary_to_list(Picture), picture_id = PictureId,
%%			server_num = ServerNum, turn = Turn, login_time = LoginTime, logout_time = LogoutTime, power = Power, server_id = ServerId,
%%			role_name = binary_to_list(RoleName)}
%%			|| [RoleId, ServerNum, ServerName, Turn, LoginTime, LogoutTime, Power, ServerId, _Lv, _PictureId, _Picture, _RoleName] <- DbList],
		RoleList = get_role_list_old(DbList),
		NewTeam = Team#team_local_3v3{role_list = RoleList, leader_name = LeaderName},
		_RoleIds = [_RoleId || #team_local_3v3_role{role_id = _RoleId}<-RoleList],
		{[NewTeam | AccList], _RoleIds ++ RoleIdList}
	    end,
	{TeamList2, AllRoleIds} = lists:foldl(F, {[], []}, TeamList1),
	Sql1 = io_lib:format(<<"DELETE  from   team_3v3">>, []),
	Sql2 = io_lib:format(<<"DELETE  from   team_3v3_role">>, []),
	db:execute(Sql1),
	db:execute(Sql2),
	mod_clusters_node:apply_cast(mod_3v3_team, sync_server_data, [TeamList2, AllRoleIds]).  %% 同步到跨服中心


%% 队友本地旧数据
get_role_list_old(DbList) ->
	F = fun([RoleId, _ServerNum, ServerName, _Turn, LoginTime, LogoutTime, _Power, _ServerId, _Lv, _PictureId, _Picture, _RoleName], AccList) ->
		case lib_role:get_role_show(RoleId) of
			#ets_role_show{figure = Figure, combat_power = Power} ->
				Role =
					#team_local_3v3_role{
						role_id = RoleId,
						server_name = ServerName,
						lv = Figure#figure.lv,
						picture = Figure#figure.picture,
						picture_id = Figure#figure.picture_ver,
						server_num = config:get_server_num(),
						turn = Figure#figure.turn,
						login_time = LoginTime,
						logout_time = LogoutTime,
						power = Power,
						server_id = config:get_server_id(),
						role_name = Figure#figure.name
					},
				[Role | AccList];
			_ ->
				AccList
		end
	    end,
	lists:foldl(F, [], DbList).



%% 更新玩家的状态
update_role_status(ServerId, RoleId, TeamId) ->
%%	lib_player:apply_cast(RoleId, ?APPLY_CAST, ?HAND_OFFLINE, lib_3v3_local, update_role_status, []),
	mod_clusters_center:apply_cast(ServerId,lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_3v3_local, update_role_status, [TeamId]]).

update_role_status(#player_status{pid = undefined, id = RoleId} = PS, TeamId) ->
	mod_clusters_node:apply_cast(mod_3v3_team, role_logout, [TeamId, RoleId]),
	PS;
update_role_status(#player_status{id = RoleId, online = Online} = PS, TeamId) ->
%%	?MYLOG("cym", "Online ~p~n", [Online]),
	if
		Online == 0 orelse  Online == 2->  %% 离线
			mod_clusters_node:apply_cast(mod_3v3_team, role_logout, [TeamId, RoleId]);
		true ->
			mod_clusters_node:apply_cast(mod_3v3_team, role_login, [TeamId, RoleId])
	end,
	PS.





gm_update_center_server() ->
	mod_clusters_node:apply_cast(lib_3v3_local, gm_update_center_server, [config:get_server_id(), config:get_merge_server_ids()]).


gm_update_center_server(ServerId, MergeSerIds) ->
	case lib_clusters_center:get_node(ServerId) of
		undefined -> skip;
		Node ->
			F = fun(MergeSrvId) ->
				ets:insert(?ROUTE, #route{server_id=MergeSrvId, node=Node})
%%				?MYLOG("server", "MergeSrvId:~p ServerId:~p Node:~p ~n", [MergeSrvId, ServerId, Node])
			    end,
			lists:foreach(F, MergeSerIds)
	end.





gm_update_local_3v3_msg() ->
	Sql = io_lib:format(<<"select  role_id, team_id  from    team_3v3_role_in_ps where team_id <> 0">>, []),
	RoleIds = db:get_all(Sql),
	[
		mod_clusters_node:apply_cast(mod_3v3_team, see_team_msg, [RoleId, TeamId, config:get_server_id()])
		|| [RoleId, TeamId] <-RoleIds].




mul_team_repair(RepairTeamList, State) ->
	?MYLOG("3v3", "RepairTeamList ~p~n", [RepairTeamList]),
	#team_state{team_list = Team} = State,
	F = fun([ReTeamId, ReRoleId], AccTeamList) ->
		case lists:keyfind(ReTeamId, #team_local_3v3.team_id, AccTeamList) of
			#team_local_3v3{leader_id = MyRoleId, role_list = RoleList, name = TeamName} = OldTeam ->
				case lists:keyfind(ReRoleId, #team_local_3v3_role.role_id, RoleList) of
					#team_local_3v3_role{} ->
						Length = length(RoleList),
						if
							Length =< 1 ->  %%只有一个人的时候直接解散队伍
								db_delete_team(OldTeam),
								NewAccTeamList = lists:keydelete(ReTeamId, #team_local_3v3.team_id, AccTeamList),
								mod_3v3_rank:refresh_3v3_team2({delete, ReTeamId}),
%%								log_3v3_team_member(OldTeam, ?team_3v3_disband, [#team_local_3v3_role{role_id = MyRoleId}]),
								NewAccTeamList;
							true -> %%转移队长;
								NewRoleList = lists:keydelete(ReRoleId, #team_local_3v3_role.role_id, RoleList),
								db_delete_role_only(ReRoleId, ReTeamId),     %%操作数据库
								RoleMsg = hd(NewRoleList),
%%								lib_3v3_local:log_3v3_team_member(Team, ?team_3v3_knick_out, [RoleMsg]),
								#team_local_3v3_role{role_name = ChangeLeaderName, role_id = ChangeLeaderId} = RoleMsg,
								NewTeam = OldTeam#team_local_3v3{leader_id = ChangeLeaderId, leader_name = ChangeLeaderName, role_list = NewRoleList},
								save_to_db_only_team(NewTeam),
								[update_role_team_msg(MemberId, ReTeamId, ChangeLeaderId, TeamName, ServerId2) || #team_local_3v3_role{role_id = MemberId,
									server_id = ServerId2} <- NewRoleList],
								NewTeamList = lists:keystore(ReTeamId, #team_local_3v3.team_id, AccTeamList, NewTeam),
								mod_3v3_rank:refresh_3v3_team2({update_leader_id, ReTeamId, ChangeLeaderId, ChangeLeaderName}),
%%								log_3v3_team_member(OldTeam, ?team_3v3_change_leader, [RoleMsg]),
								NewTeamList
						end;
					_ ->
						AccTeamList
				end;
			_ ->
				AccTeamList
		end
		end,
	LastTeam = lists:foldl(F, Team, RepairTeamList),
	State#team_state{team_list = LastTeam}.































