%%%-----------------------------------
%%% @Module      : pp_seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 15:00
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_seacraft_daily).
-author("carlos").
-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("seacraft_daily.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("def_module.hrl").
%% API
-export([]).


handle(Cmd, Status, Args) ->
	#player_status{figure = Figure, guild = Guild, id = RoleId} = Status,
	#figure{lv = Lv} = Figure,
	OpenDayLimit = data_seacraft:get_value(open_day),
	OpenDay = util:get_open_day(),
	LvLimit = data_seacraft:get_value(open_lv),
	if
		(Guild#status_guild.id == 0 orelse Guild#status_guild.realm == 0)  andalso cmd == 18702->
			send_error(RoleId, ?ERRCODE(err187_not_have_sea));
		Lv >= LvLimit orelse OpenDay < OpenDayLimit ->
			case do_handle(Cmd, Status, Args) of
				#player_status{} = NewPS ->
					{ok, NewPS};
				{ok, NewPS} ->
					{ok, NewPS};
				_ ->
					{ok, Status}
			end;
		true ->
			{ok, Status}
	end.

do_handle(18701, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, sea_craft_daily = Daily} = PS,
	#role_sea_craft_daily{brick_color = BrickColor} = Daily,
	mod_clusters_node:apply_cast(mod_kf_seacraft_daily, get_info, [ServerId, RoleId, BrickColor]),
	PS;

%%进入海域
do_handle(18702, PS, [SeaId]) ->
	#player_status{server_id = ServerId, id = RoleId, guild = Guild, sea_craft_daily = Daily, figure = F,
		combat_power = Power, scene = Scene, copy_id = NowSeaId} = PS,
	#role_sea_craft_daily{brick_color = BrickColor, status = CarryStatus} = Daily,
%%	?PRINT("SeaId ~p~n", [SeaId]),
	IsInScene = lib_seacraft_daily:is_scene(Scene),
	NeedLv = data_seacraft:get_value(open_lv),
	{IsOut, ErrCode} = lib_scene:is_transferable_out(PS),
	GmRes =  lib_gm_stop:check_gm_close_act(?MOD_SEACRAFT_DAILY, 0),
	if
		IsOut == false ->
			send_error(RoleId, ErrCode);
		GmRes =/= true ->
			send_error(RoleId, ?ERR_GM_STOP);
		F#figure.lv < NeedLv ->
			send_error(RoleId, ?ERRCODE(lv_limit));
		IsInScene == true andalso  NowSeaId =/= SeaId ->%%  海域之间可以互相切换
			if
				CarryStatus == ?carrying ->
					pp_seacraft_daily:handle(18706, PS , []);
				true ->
					skip
			end,
			mod_clusters_node:apply_cast(mod_kf_seacraft_daily, quit_sea, [ServerId, RoleId, NowSeaId]),  %% 退出海域
			%%进入另外一个海域
			mod_seacraft_local:enter_daily(ServerId, RoleId, F#figure.name, Guild#status_guild.realm, BrickColor, SeaId, Power, Guild#status_guild.id);
		IsInScene == true andalso  NowSeaId == SeaId ->%%  海域之间可以互相切换
			send_error(RoleId, ?ERRCODE(err187_in_sea));
		true ->
			case lib_player_check:check_all(PS) of  %%t 检查锁,
				true ->
					if
						IsInScene == true andalso  NowSeaId == SeaId->  %%检查是否在同一个海域
							?INFO("in seam seaId~n", []),
							skip;
						true ->
							mod_seacraft_local:enter_daily(ServerId, RoleId, F#figure.name, Guild#status_guild.realm, BrickColor, SeaId, Power, Guild#status_guild.id)
					end;
				{false, Code} ->
					send_error(RoleId, Code)
			end
	end;


%%场景信息
do_handle(18703, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, sea_craft_daily = Daily, scene = Scene, copy_id = SeaId} = PS,
	#role_sea_craft_daily{carry_count = CarryCount, defend_count = DefendCount} = Daily,
	case lib_seacraft_daily:is_scene(Scene) of  %%场景内才能获取信息
		true ->
			mod_clusters_node:apply_cast(mod_kf_seacraft_daily, get_scene_msg, [ServerId, RoleId, SeaId, CarryCount, DefendCount]);
		_ -> %%不在海域场景
			skip
	end,
	PS;

%%排行榜信息
do_handle(18704, PS, [SeaId]) ->
	#player_status{server_id = ServerId, id = RoleId, figure = Figure, combat_power = Power} = PS,
	mod_seacraft_local:get_sea_daily_rank(ServerId, RoleId, Figure#figure.name, Power, SeaId),
	PS;

%%排行榜信息
do_handle(18711, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, figure = Figure, combat_power = Power, guild = Guild} = PS,
	#status_guild{realm = MySeaId} = Guild,
	mod_seacraft_local:get_sea_daily_all_rank(ServerId, RoleId, Figure#figure.name, Power, MySeaId),
	PS;


%%开启搬砖
do_handle(18705, PS, [_SeaId]) ->
	#player_status{server_id = ServerId, id = RoleId, copy_id = SeaId,x = X, y = Y,
		scene = Scene, sea_craft_daily = Daily, guild = Guild} = PS,
	#role_sea_craft_daily{brick_color = BrickColor, status = CarryStatus, carry_count = CarryCount} = Daily,
	#status_guild{realm = MySea} = Guild,
%%	?PRINT("SeaId ~p  MySea ~p~n", [SeaId, MySea]),
%%	ask_start_pos
	{TaskX, TaskY} = data_sea_craft_daily:get_kv(task_start_pos),
	Range = data_sea_craft_daily:get_kv(task_end_range) + 400,
	Length = (X - TaskX) *  (X - TaskX) + (Y - TaskY) * (Y - TaskY),
%%	?PRINT("x  ~p ,Y ~p ", [X, Y]),
	MaxCarryCount = data_sea_craft_daily:get_kv(carry_birck_max),
	case lib_seacraft_daily:is_scene(Scene) of
		true ->
			if
				CarryStatus == ?carrying ->
					send_error(RoleId, ?ERRCODE(err187_carrying));
				MySea == 0 ->
					send_error(RoleId, ?ERRCODE(err187_not_enter_sea));
				MySea == SeaId ->
					send_error(RoleId, ?ERRCODE(err187_same_sea));
				Length >  Range * Range ->
					send_error(RoleId, ?ERRCODE(err187_err_length));
				CarryCount >= MaxCarryCount ->
					send_error(RoleId, ?ERRCODE(err187_max_carry_count));
				true ->
					mod_clusters_node:apply_cast(mod_kf_seacraft_daily,
						start_carry_brick, [ServerId, RoleId, SeaId, BrickColor])
			end;
		_ ->
			skip
	end,
	PS;

%%卸下搬砖
do_handle(18706, PS, []) ->
%%	?PRINT("18706+++++++", []),
	#player_status{server_id = ServerId, id = RoleId, copy_id = SeaId, sea_craft_daily = Daily, guild = Guild} = PS,
	#status_guild{realm = MySeaId} = Guild,
	#role_sea_craft_daily{status = CarryStatus} = Daily,
	if
		CarryStatus == ?carrying ->
			mod_clusters_node:apply_cast(mod_kf_seacraft_daily, end_carry_brick, [ServerId, RoleId, SeaId, MySeaId]);
		true ->
			send_error(RoleId, ?ERRCODE(err187_not_carry_brick))
	end,
	PS;

%%升级砖块
do_handle(18707, PS, [Lv]) ->
	#player_status{id = RoleId, sea_craft_daily = Daily, guild = StatusGuild} = PS,
	case StatusGuild of
		#status_guild{realm = RoleSeaId} ->
			ok;
		_ ->
			RoleSeaId = 0
	end,
	#role_sea_craft_daily{brick_color = OldLv, status = CarryStatus} = Daily,
	%% 检查等级是否合法
	if
		OldLv >= Lv->
%%			?MYLOG("cym", "Lv ~p~n", [Lv]),
			send_error(RoleId, ?ERRCODE(err187_error_brick_color));
		CarryStatus == ?carrying ->
			send_error(RoleId, ?ERRCODE(err187_carrying2));
		true ->
			case data_sea_craft_daily:get_brick(OldLv) of
				#brick_cfg{cost = Cost} when Cost =/= [] ->
					RightCost = lib_seacraft_daily:get_upgrade(OldLv, Lv),
					case lib_goods_api:cost_objects_with_auto_buy(PS, RightCost, sea_daily_up_brick, "") of
						{true, NewPs} ->
							lib_log_api:log_sea_craft_daily_upgrade_brick(RoleId, RoleSeaId, OldLv, Lv, RightCost),
							NewDaily = Daily#role_sea_craft_daily{brick_color = Lv},
							lib_seacraft_daily:save_to_db(NewDaily, RoleId),
							{ok, Bin} = pt_187:write(18707, [Lv, ?SUCCESS]),
							lib_server_send:send_to_uid(RoleId, Bin),
							NewPs#player_status{sea_craft_daily = NewDaily};
						{true, NewPs, RealCost} ->
							lib_log_api:log_sea_craft_daily_upgrade_brick(RoleId, RoleSeaId, OldLv, Lv, RealCost),
							NewDaily = Daily#role_sea_craft_daily{brick_color = Lv},
							lib_seacraft_daily:save_to_db(NewDaily, RoleId),
							{ok, Bin} = pt_187:write(18707, [Lv, ?SUCCESS]),
							lib_server_send:send_to_uid(RoleId, Bin),
							NewPs#player_status{sea_craft_daily = NewDaily};
						{false, ErrorCode, _} ->
							send_error(RoleId, ErrorCode)
					end;
				_ ->
%%					?MYLOG("cym", "Lv ~p~n", [Lv]),
					send_error(RoleId, ?ERRCODE(err187_error_brick_color))
			end
	end;



%%退出场景
do_handle(18708, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, copy_id = SeaId, sea_craft_daily = Daily
	,scene = Scene, guild = StatuGuild} = PS,
	#role_sea_craft_daily{status = CarryStatus} = Daily,
	IsInScene = lib_seacraft_daily:is_scene(Scene),
	IsInScene = lib_seacraft_daily:is_scene(Scene),
	{IsOut, ErrCode} = lib_scene:is_transferable_out(PS),
	if
		IsOut == false ->
			send_error(RoleId, ErrCode);
		IsInScene == true ->
			lib_scene:player_change_scene(RoleId, 0, 0, 0, false, [{action_free, ?ERRCODE(err187_in_scene)}, {camp, 0}, {group, 0}, {del_hp_each_time,[]}, {change_scene_hp_lim, 100}]),
			if
				CarryStatus == ?carrying ->
					#status_guild{realm = MySeaId} = StatuGuild,
					mod_clusters_node:apply_cast(mod_kf_seacraft_daily, end_carry_brick, [ServerId, RoleId, SeaId, MySeaId]);
				true ->
					sikp
			end,
			mod_clusters_node:apply_cast(mod_kf_seacraft_daily, quit_sea, [ServerId, RoleId, SeaId]);
		true ->
			send_error(RoleId, ?ERRCODE(err187_not_in_scene)),
			PS
	end;


%%完成搬砖
do_handle(18709, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, copy_id = SeaId, sea_craft_daily = Daily, x = X, y = Y
		,scene = Scene, guild = StatuGuild} = PS,
	#role_sea_craft_daily{status = CarryStatus} = Daily,
	IsInScene = lib_seacraft_daily:is_scene(Scene),
	{TaskX, TaskY} = data_sea_craft_daily:get_kv(task_end_pos),
	Range = data_sea_craft_daily:get_kv(task_end_range) + 400,
	Length = (X - TaskX) *  (X - TaskX) + (Y - TaskY) * (Y - TaskY),
	#status_guild{realm = MySeaId} = StatuGuild,
	if
		Length >  Range * Range ->
			send_error(RoleId, ?ERRCODE(err187_err_length));
		IsInScene == true andalso  CarryStatus == ?carrying ->
			mod_clusters_node:apply_cast(mod_kf_seacraft_daily, finish_carry, [ServerId, RoleId, SeaId, MySeaId]);
		true ->
			send_error(RoleId, ?ERRCODE(err187_finish_fail)),
			PS
	end;



do_handle(18712, PS, []) ->
	#player_status{sea_craft_daily = Daily, id = RoleId} = PS,
	#role_sea_craft_daily{task_list = TaskList, week_task_list = WeekTaskList} = Daily,
	F = fun({TaskId, Count, Status}, AccList) ->
			case data_sea_craft_daily:get_task(TaskId) of
				#sea_daily_task_cfg{count = NeedCount} ->
					if
						Status == 2 ->  %% 已经领取了
							[{TaskId, Count, Status} | AccList];
						Count >= NeedCount ->  %% 可以领取
							[{TaskId, Count, 1} | AccList];
						true ->
							[{TaskId, Count, 0} | AccList]
					end;
				_ ->
					AccList
			end
		end,
	PackList = lists:foldl(F, [], TaskList ++ WeekTaskList),
	{ok, Bin} = pt_187:write(18712, [PackList]),
%%	?PRINT("TaskList ++ WeekTaskList ~p~n", [TaskList ++ WeekTaskList]),
%%	?PRINT("PackList ~p~n", [PackList]),
	lib_server_send:send_to_uid(RoleId, Bin);

%%领取任务
do_handle(18713, PS, [TaskId]) ->
	#player_status{sea_craft_daily = Daily, id = RoleId} = PS,
	#role_sea_craft_daily{task_list = TaskList, week_task_list = WeekTaskList} = Daily,
	?PRINT("TaskId ~p~n", [TaskId]),
    case data_sea_craft_daily:get_task(TaskId) of
        #sea_daily_task_cfg{type = ?task_daily} ->
			case lists:keyfind(TaskId, 1, TaskList) of
				{_, Count, Status} ->
					case data_sea_craft_daily:get_task(TaskId) of
						#sea_daily_task_cfg{count = NeedCount, reward = Reward} ->
							if
								Status == 2->  %% 已经领取了
									send_error(RoleId, ?ERRCODE(err187_yet_get_reward));
								Count >= NeedCount -> %% 可以领取
									%% todo log
									TaskListNew = lists:keystore(TaskId, 1, TaskList, {TaskId, Count, 2}),
									DailyNew = Daily#role_sea_craft_daily{task_list = TaskListNew},
									lib_seacraft_daily:save_to_db(DailyNew, RoleId),
									%% 发送奖励
									lib_goods_api:send_reward_with_mail(RoleId,
										#produce{reward = Reward, type = sea_craft_daily_task_reward}),
									{ok, Bin} = pt_187:write(18713, [?SUCCESS, TaskId, Reward]),
									lib_server_send:send_to_uid(RoleId, Bin),
									PS#player_status{sea_craft_daily = DailyNew};
								true ->
									send_error(RoleId, ?ERRCODE(err187_not_finish_task))
							end;
						_ ->
							send_error(RoleId, ?MISSING_CONFIG)
					end;
				_ ->
					send_error(RoleId, ?ERRCODE(err187_not_finish_task))
			end;
		_ ->
			case lists:keyfind(TaskId, 1, WeekTaskList) of
				{_, Count, Status} ->
					case data_sea_craft_daily:get_task(TaskId) of
						#sea_daily_task_cfg{count = NeedCount, reward = Reward} ->
							if
								Status == 2->  %% 已经领取了
									send_error(RoleId, ?ERRCODE(err187_yet_get_reward));
								Count >= NeedCount -> %% 可以领取
									%% todo log
									TaskListNew = lists:keystore(TaskId, 1, WeekTaskList, {TaskId, Count, 2}),
									DailyNew = Daily#role_sea_craft_daily{week_task_list = TaskListNew},
									lib_seacraft_daily:save_to_db(DailyNew, RoleId),
									%% 发送奖励
									lib_goods_api:send_reward_with_mail(RoleId,
										#produce{reward = Reward, type = sea_craft_daily_task_reward}),
									{ok, Bin} = pt_187:write(18713, [?SUCCESS, TaskId, Reward]),
									lib_server_send:send_to_uid(RoleId, Bin),
									PS#player_status{sea_craft_daily = DailyNew};
								true ->
									send_error(RoleId, ?ERRCODE(err187_not_finish_task))
							end;
						_ ->
							send_error(RoleId, ?MISSING_CONFIG)
					end;
				_ ->
					send_error(RoleId, ?ERRCODE(err187_not_finish_task))
			end
    end;



do_handle(18715, PS, []) ->
	#player_status{id = RoleId, battle_attr =  BA} = PS,
%%	#battle_attr{attr = Attr, speed = S2} = BA,
%%	?PRINT("~p, ~p~n", [Attr#attr.speed, S2]),
	mod_seacraft_local:get_sea_guild_msg(RoleId);


do_handle(_Cmd, _Status, _Args) ->
	_Status.



send_error(RoleId, Error) ->
	{ok, Bin} = pt_187:write(18700, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).







	