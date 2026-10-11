%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%         主角光环
%%% @end
%%% Created : 19. 11月 2022 15:04
%%%-------------------------------------------------------------------
-module(lib_hero_halo).

-include("daily.hrl").
-include("hero_halo.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("jjc.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("buff.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("activitycalen.hrl").
-include("custom_act.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("boss.hrl").
-include("rec_recharge.hrl").
-include("def_fun.hrl").
-include("drop.hrl").
-include("team.hrl").
-include("scene.hrl").

%% API
-export([
	notify_hero_halo_info/1
	, get_reward/2
	, login/1
	, handle_event/2
	, check_halo/1
	, set_privilege_state/4
	, add_dun_buff/3
	, remove_dun_buff/3
	, get_halo_extra_times/2
	, refresh/1
	, refresh_data/0
	, get_scene_privilege_state/1
	, change_drop_way/5
	, calc_jjc_challenge_times/2
	, calc_dun_challenge_times/2
	, gm_send_halo/1
	, gm_fix_jjc_task/1
]).

%% 登录初始化
login(Ps) ->
	#player_status{id = RoleId} = Ps,
	NewPsN =
		case db:get_all(io_lib:format(?sql_select_hero_halo, [RoleId])) of
			[] ->
				Ps#player_status{halo_status = #halo_status{}};
			[[Etime, PrivilegeListBin, IsSend]] ->
				HaloStatus = #halo_status{end_time = Etime, privilege_list = util:bitstring_to_term(PrivilegeListBin), is_send = IsSend},
				NewPs = Ps#player_status{halo_status = HaloStatus},
				Now = utime:unixtime(),
				case IsSend =/= 1 andalso Now >= Etime of
					true ->
						send_overdue_reward(NewPs);
					_ -> NewPs
				end
		end,
	notify_hero_halo_info(NewPsN),
	NewPsN.

 %% 充值回调
handle_event(Ps, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product}}) ->
	ProductId = Product#base_recharge_product.product_id,
	case ProductId == ?HALO_RECHARGE_ID of
		true ->
			#player_status{id = RoleId, halo_status = HaloStatus} = Ps,
			#halo_status{end_time = EndTime} = HaloStatus,
			Now = utime:unixtime(),
			case ?HALO_INTERVAL_BUY_TIME >= EndTime - Now of
				true ->
					EndTime =/= 0 andalso send_overdue_reward(Ps),
					NewEndTime = ?IF(EndTime < Now, Now + ?HALO_BUY_TIME, EndTime + ?HALO_BUY_TIME),
					NewHaloStatus = HaloStatus#halo_status{end_time = NewEndTime, privilege_list = [], is_send = 0},
					Ps1 = Ps#player_status{halo_status = NewHaloStatus},
					db_save_halo(RoleId, NewHaloStatus),
					pp_sea_treasure:handle(18902, Ps1, []),
					pp_adventure:handle(42701, Ps1, []),
					Ps2 = update_scene_info(Ps1),
					notify_hero_halo_info(Ps2),
					{ok, Ps2};
				_ -> {ok, Ps}
			end;
		_ ->
			{ok, Ps}
	end;
handle_event(PS, _) ->
	{ok, PS}.


gm_send_halo(RoleIdListStr) ->
	RoleIdS = util:string_to_term(RoleIdListStr),
	ServerRoleIds = db:get_all(io_lib:format(<<"select id from player_login">>, [])),
	RealRoleIds = [{Id, Times} || {Id, Times} <- RoleIdS, lists:member([Id], ServerRoleIds)],
	gm_send_halo_do(RealRoleIds, 0).


gm_send_halo_do([{RoleId, Times} | N], Num) ->
	case Num rem 10 of
		0 -> timer:sleep(1000);
		_ -> skip
	end,
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	case db:get_all(io_lib:format(?sql_select_hero_halo, [RoleId])) of
		[] ->
			Now = utime:unixtime(),
			NewEndTime = Now + ?HALO_BUY_TIME * Times,
			HaloStatus = #halo_status{end_time = NewEndTime, privilege_list = [], is_send = 0};
		[[Etime, PrivilegeListBin, _IsSend]] ->
			HaloStatus = #halo_status{end_time = Etime + ?HALO_BUY_TIME * Times-1, privilege_list = util:bitstring_to_term(PrivilegeListBin), is_send = 0}
	end,
	SendTimes = Times - 1,
	Ids = data_hero_halo:get_all_id(),
	case SendTimes >= 1 of
		true ->
			F = fun(Id, Acc) ->
				#base_hero_halo{reward = Reward} = data_hero_halo:get_halo_cfg(Id),
				[{G1, G2, N1 * SendTimes} ||{G1, G2, N1} <- Reward] ++ Acc
				end,
			RewardS = lists:foldl(F, [], Ids),
			Title1 = uio:format(<<"[主角光环]特权补发"/utf8>>,[]),
			Content1 =  uio:format(<<"尊敬的御灵师，您购买了{1}天主角光环特权，除首次购买奖励外，现为你奉上多次购买的额外奖励，请查收。"/utf8>>,[30 * Times]),
			lib_mail_api:send_sys_mail([RoleId], Title1, Content1, lib_goods_api:make_reward_unique(RewardS));
		_ ->
			skip
	end,

	Title = uio:format(<<"[主角光环]特权补发"/utf8>>,[]),
	Content =  uio:format(<<"尊敬的御灵师您好，系统现已为您补发{1}天的特权有效期，可前往特权界面自行领取特权奖励。"/utf8>>,[30 * Times]),
	lib_mail_api:send_sys_mail([RoleId], Title, Content, []),

	db_save_halo(RoleId, HaloStatus),
	case lists:keyfind(RoleId, #ets_online.id, OnlineRoles) of
		false -> ok;
		_ ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_hero_halo, login, []),
			ok
	end,
	gm_send_halo_do(N, Num + 1);
gm_send_halo_do([], _) ->
	ok.

%% 更新场景信息
update_scene_info(Ps) ->
	#player_status{scene = SceneId} = Ps,
	#base_hero_halo{value = SceneTypeL} = data_hero_halo:get_halo_cfg(?HALO_DROP_SPEED),
	SceneType = lib_scene:get_scene_type(SceneId),
	case SceneType of
		?SCENE_TYPE_DECORATION_BOSS ->
			NewPs = add_dun_buff(Ps, ?BOSS_TYPE, ?BOSS_TYPE_DECORATION_BOSS);
		?SCENE_TYPE_DUNGEON ->
			NewPs = lib_goods_buff:count_player_attr(Ps),
			mod_scene_agent:update(NewPs, [{halo_privilege, get_scene_privilege_state(Ps)}]);
		_ ->
			case lists:member(SceneType, SceneTypeL) of
				true ->
					mod_scene_agent:update(Ps, [{halo_privilege, get_scene_privilege_state(Ps)}]),
					NewPs = Ps;
				_ ->
					NewPs = Ps
			end
	end,
	NewPs.

%% 0点检查主角光环是否过期，过期则补发
refresh(_DelaySec) ->
	util:rand_time_to_delay(3000, lib_hero_halo, refresh_data, []).

refresh_data() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_hero_halo, login, []) || E <- OnlineRoles].

%% 过期补发奖励
send_overdue_reward(Ps) ->
	#player_status{id = RoleId, halo_status = HaloStatus} = Ps,
	#halo_status{privilege_list = PrivilegeList} = HaloStatus,
	Ids = data_hero_halo:get_all_id(),
	F = fun(Id, Acc) ->
		case lists:keyfind(Id, 1, PrivilegeList) of
			false ->
				#base_hero_halo{condition = Condition, reward = Reward} = data_hero_halo:get_halo_cfg(Id),
				case check_list(Condition, Ps) of
					true ->
						Reward ++ Acc;
					_ -> Acc
				end;
			_ -> Acc
		end end,
	SendReward = lists:foldl(F, [], Ids),
	NewHaloStatus = HaloStatus#halo_status{is_send = 1},
	NewPs = Ps#player_status{halo_status = NewHaloStatus},
	db_save_halo(RoleId, NewHaloStatus),
	Title = utext:get(5140001),
	Content = utext:get(5140002),
	SendReward =/= [] andalso lib_mail_api:send_sys_mail([RoleId], Title, Content, lib_goods_api:make_reward_unique(SendReward)),
	NewPs.

%% 获取主角光环信息
notify_hero_halo_info(Ps) ->
	#player_status{id = RoleId, halo_status = HaloStatus} = Ps,
	#halo_status{end_time = EndTime, privilege_list = PrivilegeList} = HaloStatus,
	{ok, BinData} = pt_514:write(51400, [EndTime, PrivilegeList]),
	lib_server_send:send_to_uid(RoleId, BinData).

%% 领取奖励
get_reward(Ps, Id) ->
	#player_status{id = RoleId, halo_status = HaloStatus} = Ps,
	#halo_status{end_time = EndTime, privilege_list = PrivilegeList} = HaloStatus,
	case data_hero_halo:get_halo_cfg(Id) of
		#base_hero_halo{condition = Condition, reward = Reward} ->
			CheckList = [{check_time, EndTime} | Condition],
			case check_list(CheckList, Ps) of
				true ->
					case lists:keyfind(Id, 1, PrivilegeList) of
						false ->
							NewPrivilegeList = lists:keystore(Id, 1, PrivilegeList, {Id, ?ALREADY_REWARD}),
							NewHaloStatus = HaloStatus#halo_status{privilege_list = NewPrivilegeList},
							Ps1 = Ps#player_status{halo_status = NewHaloStatus},
							db_save_halo(RoleId, NewHaloStatus),
							SendPs = lib_goods_api:send_reward(Ps1, Reward, hero_halo_reward, 0),
							{ok, SendPs, ?ALREADY_REWARD};
						{Id, State} ->
							{false, Ps, State}
					end;
				{false, Code} ->
					{false, Code, ?NO_REWARD}
			end;
		_ ->
			{false, ?MISSING_CONFIG, ?NO_REWARD}
	end.

%% 检查条件
check_list([], _Ps) -> true;
check_list([{check_time, Etime}| N], Ps) ->
	case utime:unixtime() =< Etime of
		true ->
			check_list(N, Ps);
		_ ->
			{false, ?ERRCODE(err_not_buy_halo)}
	end;
check_list([{lv, CheckLv}| N], Ps) ->
	#player_status{figure = #figure{lv = Lv}} = Ps,
	case CheckLv =< Lv of
		true ->
			check_list(N, Ps);
		_ ->
			{false, ?ERRCODE(lv_not_enougth)}
	end;
check_list([{task, CheckTaskId}| N], Ps) ->
	#player_status{tid = TaskPid} = Ps,
	case mod_task:is_finish_task_id(TaskPid, CheckTaskId) of
		false ->
			{false, ?ERRCODE(err381_not_finish_task)};
		_ ->
			check_list(N, Ps)
	end;
check_list([{_, _} | _N], _Ps) ->
	{false, ?MISSING_CONFIG}.

%% 检查是否拥有特权
check_halo(Ps) ->
	#player_status{halo_status = HaloStatus} = Ps,
	#halo_status{end_time = EndTime} = HaloStatus,
	utime:unixtime() =< EndTime.

set_privilege_state(Ps, HaloId, Type, State) ->
	case check_halo(Ps) of
		true ->
			#player_status{halo_setting = HaloSetting} = Ps,
			NewHaloSetting = lists:keystore({HaloId, Type}, 1, HaloSetting, {{HaloId, Type}, State}),
			NewPs = Ps#player_status{halo_setting = NewHaloSetting},
			{ok, BinData} = pt_514:write(51402, [HaloId, Type, State, ?SUCCESS]),
			lib_server_send:send_to_uid(Ps#player_status.id, BinData),
			{ok, NewPs};
		_ ->
			{ok, Ps}
	end.

%% 获取主角光环特权增加额外次数
get_halo_extra_times(Ps, HaloId) ->
	case check_halo(Ps) of
		true ->
			case data_hero_halo:get_halo_cfg(HaloId) of
				#base_hero_halo{value = [Times]} when is_integer(Times) -> Times;
				_ -> 0
			end;
		_ -> 0
	end.

%% 获取特权设置状态
get_privilege_setting(Ps, Key) ->
	#player_status{halo_setting = HaloSetting} = Ps,
	{_, Value} = ulists:keyfind(Key, 1, HaloSetting, {Key, 0}),
	Value.

%% 计算竞技场挑战次数
calc_jjc_challenge_times(Ps, ChallengeType) ->
	HaloSetting = get_privilege_setting(Ps, {?HALO_TYPE_JJC ,0}),
	case HaloSetting == ?USE_HALO andalso ChallengeType == 1 of
		true ->
			[MaxNum] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
			ChallengeNum = mod_daily:get_count(Ps#player_status.id, ?MOD_JJC, ?JJC_CHALLENGE_NUM),
			MaxNum - ChallengeNum;
		_ -> 1
	end.

%% 计算副本挑战次数
calc_dun_challenge_times(Ps, Dun) ->
	#dungeon{type = DunType} = Dun,
	{_AllCount, LeftCount} = lib_dungeon:get_daily_count(Ps, Dun),
	HaloUse = get_privilege_setting(Ps, {?HALO_DUNGEON_CHALLENGE_TIMES, DunType}),
	Count = ?IF(HaloUse == 1, LeftCount, 1),
	Count.

%% 根据副本类型获取特权id
get_id_by_dun_type(?DUN_TYPE, ?DUNGEON_TYPE_WEEK_DUNGEON) -> ?HALO_DUN_WEEK_BUFF;
get_id_by_dun_type(?BOSS_TYPE, ?BOSS_TYPE_DECORATION_BOSS) -> ?HALO_DECORATION_BUFF;
get_id_by_dun_type(_, _) -> err.

%% 特权副本添加BUFF
add_dun_buff(Ps, HaloType, Type) ->
	case get_id_by_dun_type(HaloType, Type) of
		HaloId when is_integer(HaloId) ->
			case check_halo(Ps) of
				true ->
				#base_hero_halo{value = [{SkillId, SkillLv}|_]} = data_hero_halo:get_halo_cfg(HaloId),
					NewPlayer = lib_goods_buff:add_skill_buff(Ps, SkillId, SkillLv, ?BUFF_SKILL_NO),
					NewPlayer;
				_ -> Ps
			end;
		_ -> Ps
	end.

%% 删除特权副本添加BUFF
remove_dun_buff(Ps, HaloType, Type) ->
	case get_id_by_dun_type(HaloType, Type) of
		HaloId when is_integer(HaloId) ->
			case check_halo(Ps) of
				true ->
				#base_hero_halo{value = [{SkillId, _SkillLv}|_]} = data_hero_halo:get_halo_cfg(HaloId),
					NewPlayer = lib_goods_buff:remove_skill_buff(Ps, SkillId),
					NewPlayer;
				_ -> Ps
			end;
		_ -> Ps
	end.

%% 获取特权列表
get_scene_privilege_state(PS) -> %[{?HALO_DROP_SPEED, 1}].
	ScenePrivilegeL = [?HALO_DROP_SPEED],
	[
		{Privilege, ?IF(check_halo(PS), 1, 0)}      %% 1为有特权，0为无特权
		||Privilege<-ScenePrivilegeL
	].

change_drop_way(#player_status{team = Team} = PS, MonArgs, Alloc, BLType, DropWay) ->
	case Team of
		#status_team{team_id = 0} ->
			HaloPrivilege = get_scene_privilege_state(PS),
			change_drop_way_core(HaloPrivilege, MonArgs, Alloc, BLType, DropWay);
		_ ->
			DropWay
	end;
change_drop_way(#method_role_drop_args{halo_privilege = HaloPrivilege, team_id = 0}, MonArgs, Alloc, BLType, DropWay) ->
	change_drop_way_core(HaloPrivilege, MonArgs, Alloc, BLType, DropWay);
change_drop_way(_, _MonArgs, _Alloc, _BLType, DropWay) ->
	DropWay.

change_drop_way_core([], _MonArgs, _Alloc, _BLType, DropWay) -> DropWay;
change_drop_way_core(HaloPrivilege, MonArgs, Alloc, BLType, DropWay) ->
	IsSatisfy = (Alloc == ?ALLOC_BLONG orelse Alloc == ?ALLOC_SINGLE orelse Alloc == ?ALLOC_SINGLE_2 orelse Alloc == ?ALLOC_HURT_EQUAL) andalso
		(BLType == ?DROP_HURT orelse BLType == ?DROP_FIRST_ATT orelse BLType == ?DROP_LAST_ATT orelse  BLType == ?DROP_HURT_SINGLE orelse BLType == ?DROP_ANY_HURT),
	case lists:keyfind(?HALO_DROP_SPEED, 1, HaloPrivilege) of
		{_, 1} when IsSatisfy ->
			#mon_args{scene = SceneId, kind = Kind} = MonArgs,
			SceneType = lib_scene:get_scene_type(SceneId),
			#base_hero_halo{value = SceneTypeL} = data_hero_halo:get_halo_cfg(?HALO_DROP_SPEED),
			IsCollect = Kind == ?MON_KIND_COLLECT orelse Kind == ?MON_KIND_TASK_COLLECT,
			case IsCollect == false andalso lists:member(SceneType, SceneTypeL) of
				true -> ?DROP_WAY_BAG;
				_ -> DropWay
			end;
		_ ->
			DropWay
	end.

gm_fix_jjc_task(Time) ->
	case db:get_all(io_lib:format(<<"select role_id from role_halo where end_time  <=  ~p">>, [Time + ?HALO_BUY_TIME])) of
		[] ->
			skip;
		RoleList ->
			IsHi = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT),
			spawn(fun() ->  cacl_send_goods_num(RoleList, IsHi, Time,  0) end)

	end,
	ok.

cacl_send_goods_num([], _IsHi, _CheckTime, _Number) -> ok;
cacl_send_goods_num([[RoleId] | Next], IsHi, CheckTime, Number) ->
	case Number rem 10 of
		0 -> timer:sleep(1000);
		_ -> skip
	end,
	BuyNum = mod_daily:get_count_offline(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_BUY_NUM),
	Value = mod_daily:get_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?MOD_JJC * ?AC_LIVE_ADD + 0),
	Reward =
		case BuyNum + 10 - Value of
			0 ->
				[];
			_ ->
				case db:get_one(io_lib:format(<<"select role_id from fiesta where role_id = ~p and expired_time > ~p and begin_time < ~p">>, [RoleId, CheckTime, CheckTime])) of
					RoleId ->
							case IsHi of
								true -> [{0, 38350001, BuyNum + 10 - Value}, {0, 37120001, 20}];
								_ -> [{0, 37120001, 20}]
							end;
					_Err ->
							case IsHi of
								true -> [{0, 38350001, BuyNum +10 - Value}];
								_ -> []
							end
				end
		end,

	case Reward of
		[] -> skip;
		_ ->
			Title1 = uio:format(<<"竞技场合并扫荡异常补偿"/utf8>>,[]),
			Content1 =  uio:format(<<"尊敬的御灵师您好，由于竞技场合并扫荡触发任务进度异常，特为您补上相关任务进度经验，请您查收，祝您游戏愉快。"/utf8>>,[]),
			lib_mail_api:send_sys_mail([RoleId], Title1, Content1, Reward)
	end,
	cacl_send_goods_num(Next, IsHi, CheckTime, Number + 1).


%%% ============================================== sql =============================================

db_save_halo(RoleId, HaloStatus) ->
	#halo_status{end_time = EndTime, privilege_list = PrivilegeList, is_send = IsSend} = HaloStatus,
	sql(execute, ?sql_replace_hero_halo, [RoleId, EndTime, util:term_to_bitstring(PrivilegeList), IsSend]).

sql(Func, Expr, Args) ->
	Sql = io_lib:format(Expr, Args),
	db:Func(Sql).
