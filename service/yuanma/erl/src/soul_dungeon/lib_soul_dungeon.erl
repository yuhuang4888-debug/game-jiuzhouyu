%%%-----------------------------------
%%% @Module      : lib_soul_dungeon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 16. 十一月 2018 15:14
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_soul_dungeon).
-author("chenyiming").

%% API
-compile(export_all).
-include("common.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("language.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("soul_dungeon.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").


%%quik_create_mon_cast(RoleId,  DunPid,   State) ->
%%  gen_server:cast(DunPid, {'quik_create_mon_cast', RoleId}).

%%初始化聚魂本的数据
login(PS) ->
	Sql = io_lib:format(?select_from_soul_dungeon_ps_sub, [PS#player_status.id]),
	List = db:get_all(Sql),
	NewList = [#soul_dungeon_ps_sub{dun_id = DunId, status = Status, max_wave = MaxWave} || [DunId, Status, MaxWave] <- List],
	PS#player_status{soul_dun = #soul_dungeon_ps{role_dungeon_list = NewList}}.

%% -----------------------------------------------------------------
%% @desc     功能描述 在副本进程中，进行立即刷怪
%% @param    参数     RoleId::玩家id
%%                    State::#dungeon_state{}
%% @return   返回值    NewState
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_quik_create_mon(RoleId, #dungeon_state{common_event_map = CommonEventMap, typical_data = DataMap} = State) ->
%%    ?MYLOG("cym", "quik_create_mon~n", []),
	case lib_soul_dungeon_check:quik_create_mon(State) of
		true -> %%可以刷怪  只要将刷新时间改为当前时间，在调用create_dungeon_mon(State, CommonEventId) 即可，
			%% 里面会取消定时器，下一波的由怪物死亡触发，再走定时器刷怪
			BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
			CommonEventId = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, DataMap, -1),
			CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap, []),
			case CommonEvent of
				[] ->
%%                    ?MYLOG("cym", "quik_create_mon1~n", []),
					State;
				_ ->
					#dungeon_common_event{wave_subtype_map = WaveSubtypeMap} = CommonEvent, %%刷怪事件
					NewWaveSubTypeMap = set_create_time(WaveSubtypeMap, utime:longunixtime()), %%设置刷新时间
					NewCommonEvent = CommonEvent#dungeon_common_event{wave_subtype_map = NewWaveSubTypeMap},
					NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
					NewState = State#dungeon_state{common_event_map = NewCommonEventMap}, %%修正state
%%                    ?MYLOG("cym", "CommonEventId ~p ~n", [CommonEventId]),
					lib_dungeon_mon_event:create_dungeon_mon(NewState, CommonEventId)
			end;
		{false, Err} ->
			send_err_code(RoleId, Err),
			State
	end.

send_err_code(RoleId, Err) ->
%%    ?MYLOG("cym", "Err ~p ~n", [Err]),
	{ok, Bin} = pt_215:write(21500, [Err]),
	lib_server_send:send_to_uid(RoleId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述  重置刷新时间
%% @param    参数     WaveSubtypeMap:: #{subWaveType =>  #dungeon_wave_subtype{}}
%% @return   返回值   NewWaveSubtypeMap
%% @history  修改历史
%% -----------------------------------------------------------------
set_create_time(WaveSubtypeMap, Time) ->
	List = maps:to_list(WaveSubtypeMap),
	F = fun({Key, Record}, AccList) ->
		NewRecord = Record#dungeon_wave_subtype{create_time = Time},
		[{Key, NewRecord} | AccList]
	end,
	NewList = lists:foldl(F, [], List),
	NewMap = maps:from_list(NewList),
	NewMap.

%% -----------------------------------------------------------------
%% @desc     功能描述  创建boss怪物 副本进程中
%% @param    参数     RoleId::玩家id    MonId::integer() 怪物id   X, Y  ::boss出生坐标    State::#dungeon_state{}
%% @return   返回值   NewState
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_create_mon(_RoleId, _MonId, _X, _Y, #dungeon_state{is_end = ?DUN_IS_END_YES} = State) ->
	State;
dunex_create_mon(RoleId, MonId, X, Y, #dungeon_state{typical_data = DataMap,
	common_event_map = CommonEventMap, now_scene_id = SceneId, scene_pool_id = PoooId} = State) ->
	%%检查能不能刷新  1 副本类型 (已检查)
	NewState =
		case lib_soul_dungeon_check:create_mon(State) of
			true ->
				BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
				CommonEventId = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, DataMap, -1),
				CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap, []),
				WaveSubtypeMap =
					case CommonEvent of
						[] ->
							#{};
						#dungeon_common_event{wave_subtype_map = _WaveSubtypeMap} ->  %%刷怪事件
							_WaveSubtypeMap
					end,
				WaveSubList = maps:values(WaveSubtypeMap),
				WaveSubtypeRecord = hd(WaveSubList),
				#dungeon_wave_subtype{create_time = CreateTime} = WaveSubtypeRecord,
				NewDataMap = maps:put(?boss_create_status, ?boss_can_not_create, DataMap), %%设置状态为不可创建
				case erlang:round(CreateTime / 1000) > utime:unixtime() of
					true -> %%处于等待时间,加入到下一波中
%%                        ?MYLOG("cym2", "create boss next wave End ~p~n", [End]),
						LastDataMap = maps:put(?DUN_ROLE_SPECIAL_KEY_CREATE_MON, {MonId, X, Y, 100, []}, NewDataMap),
						ok;
					false ->  %%立即刷新
%%                        ?MYLOG("cym2", "create boss now  End ~p~n", [End]),
						LastDataMap = NewDataMap,
						Pid = self(),
						lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_soul_dungeon, creat_mon_cost, []), %%立即扣除
						lib_mon:async_create_mon(MonId, SceneId, PoooId, X, Y, 1, Pid, 1, []) %%异步创建怪物
				end,
				%%通知玩家进程扣除
%%                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_soul_dungeon, creat_mon_cost, []),
				State#dungeon_state{typical_data = LastDataMap};
			{false, Err} ->
				?MYLOG("cym", " create  boss Err ~p  ~n", [Err]),
				send_err_code(RoleId, Err),
				State
		end,
	NewState.

%% -----------------------------------------------------------------
%% @desc     功能描述  设置typical_data 数据， 1.事件编号  2重置召唤boss状态为
%% @param    参数     CommonEventId::integer() 事件编号
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_set_typical_data(#dungeon_state{typical_data = DataMap} = State, CommonEventId) ->
%%    ?MYLOG("cym", "typical ~p CommonEventId ~p~n", [DataMap, CommonEventId]),
	Map1 = maps:put(?DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, CommonEventId, DataMap),
	Map2 = maps:put(?boss_create_status, ?boss_can_create, Map1),
	State#dungeon_state{typical_data = Map2}.

%% -----------------------------------------------------------------
%% @desc     功能描述  副本初始化时的参数
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_get_start_dun_args(_, _) ->
	[{do_sth, {lib_soul_dungeon, init_dungeon, []}}].


%%副本初始化
init_dungeon(State, _) ->
	#dungeon_state{dun_id = DunId, scene_pool_id = _PoolId, typical_data = DataMap, wave_num = WaveNum, owner_id = RoleId} = State,
	SceneId =
		case data_dungeon:get(DunId) of
			#dungeon{scene_id = _SceneId} ->
				_SceneId;
			_ ->
				?ERR("MissCfg ~n", []),
				0
		end,
	%% 1创建水晶， 玩家分组，水晶分组
%%    MonId =
%%        case data_soul_dungeon:get_value_by_key(crystal_mon_id) of
%%            [_MonId] ->
%%                _MonId;
%%            _ ->
%%                0
%%        end,
%%    {X, Y} =
%%        case data_soul_dungeon:get_value_by_key(crystal_mon_xy) of
%%            [{_X, _Y}] ->
%%                {_X, _Y};
%%            _ ->
%%                {0, 0}
%%        end,
%%    Pid = self(),
%%    ?MYLOG("cym", "init DunId ~p SceneId ~p WaveNum ~p MonId ~p ~n", [DunId, SceneId, WaveNum, MonId]),
%%    lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, 0, Pid, 1, [{group, ?DUN_DEF_GROUP}]), %%战斗分组设置为99, 玩家的默认分组也是99
	%%通知聚魂本管理进程，副本初始化
	mod_soul_dungeon:add_role_into_dungeon(State#dungeon_state.owner_id),
	Time =
		case data_dungeon_wave:get_wave(DunId, SceneId, WaveNum + 1, 1) of  %%波数子类型默认是1
			#dungeon_wave{refresh_time = RefreshTime} ->
				erlang:round(RefreshTime / 1000) + utime:unixtime();
			_ ->
				0
		end,
	%%增加临时技能
	add_temp_skill(RoleId),
	NewDataMap = maps:put(refreshTime, {WaveNum + 1, Time}, DataMap),
	State#dungeon_state{typical_data = NewDataMap}.


%% -----------------------------------------------------------------
%% @desc     功能描述  用于怪物死亡事件的处理
%% @param    参数      State::#dungeon_state{}  DidData::lists() 死亡信息
%% @return   返回值    State
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_handle_kill_mon(State, MonId, _, DieDatas) ->
%%  ?MYLOG("cym", "DieDatas ~p", [DieDatas]),
	[Power] = data_soul_dungeon:get_power_by_mon_id(MonId),
	case lists:keyfind(killer, 1, DieDatas) of
		{killer, PlayerId} ->
			#dungeon_state{role_list = RoleList} = State,
			case lists:keyfind(PlayerId, #dungeon_role.id, RoleList) of
				#dungeon_role{} ->  %%通知聚魂本管理进程， 加能量
%%                  ?MYLOG("cym", "Power ~p~n",  [Power]),
					mod_soul_dungeon:add_power_and_kill_mon(PlayerId, Power, 1);
				_ ->
%%                  ?MYLOG("cym", "skip ~n",  []),
					skip
			end;
		_ ->
			skip
	end,
	State.

%%加能量
add_power_and_kill_mon(RoleId, AddPower, AddkillNum, State) ->
%%  ?MYLOG("cym", "RoleId ~p AddPower ~p AddKillNum ~p  ~n State ~p~n", [RoleId, AddPower, AddkillNum, State]),
	%%通知玩家进程加能量.
	lib_skill_api:add_energy(RoleId, AddPower),
	#soul_dungeon{role_dungeon_list = RoleDungeonList} = State,
	NewState =
		case lists:keyfind(RoleId, #role_soul_dungeon.role_id, RoleDungeonList) of
			false ->
				NewRoleSoulDungeon = #role_soul_dungeon{power = AddPower,
					kill_mon = AddkillNum, role_id = RoleId, max_kill = AddkillNum},  %%能量, 击杀怪物
				NewRoleDungeonList = lists:keystore(RoleId, #role_soul_dungeon.role_id, RoleDungeonList, NewRoleSoulDungeon),
				%%通知客户端
				send_power_and_kill(RoleId, AddPower, AddkillNum),
				update_record(NewRoleSoulDungeon, AddkillNum), %%同步数据库
				State#soul_dungeon{role_dungeon_list = NewRoleDungeonList};
			#role_soul_dungeon{power = OldPower, kill_mon = OldKillMon, max_kill = Maxkill} = RoleSoulDungeon ->
				NewMaxKill =
					case (OldKillMon + AddkillNum) > Maxkill of
						true ->
							OldKillMon + AddkillNum;
						false ->
							Maxkill
					end,
				NewRoleSoulDungeon = RoleSoulDungeon#role_soul_dungeon{power = OldPower + AddPower,
					kill_mon = OldKillMon + AddkillNum, max_kill = NewMaxKill, role_id = RoleId},  %%能量, 击杀怪物
				%%通知客户端
				send_power_and_kill(RoleId, AddPower + OldPower, AddkillNum + OldKillMon),
				update_record(NewRoleSoulDungeon, AddkillNum + OldKillMon),
				NewRoleDungeonList = lists:keystore(RoleId, #role_soul_dungeon.role_id, RoleDungeonList, NewRoleSoulDungeon),
				State#soul_dungeon{role_dungeon_list = NewRoleDungeonList}
		end,
%%  ?MYLOG("cym", "State ~p~n", [State]),
	NewState.


%% -----------------------------------------------------------------
%% @desc     功能描述 获取评价
%% @param    参数     RoleId::ingeter() 玩家id   State::#dungeon_state{}
%% @return   返回值 无
%% @history  修改历史
%% -----------------------------------------------------------------
get_grade(RoleId, #soul_dungeon{role_dungeon_list = List} = _State) ->
	case lists:keyfind(RoleId, #role_soul_dungeon.role_id, List) of
		#role_soul_dungeon{kill_mon = KillNum} ->
			{ok, Bin} = pt_215:write(21503, [KillNum]),
			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
			{ok, Bin} = pt_215:write(21503, [0]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end.

%%初始化， 暂时不用做什么东西
add_role_into_dungeon(RoleId, #soul_dungeon{role_dungeon_list = List} = State) ->
	case lists:keyfind(RoleId, #role_soul_dungeon.role_id, List) of
		#role_soul_dungeon{} ->
			State;
		_ -> %%初始化
			State
	end.

%%通知客户端能量更新和击杀更新
send_power_and_kill(RoleId, _Power, Kill) ->
%%  ?MYLOG("cym", "Power ~p kill ~p ~n",  [Power, Kill]),
	{ok, Bin1} = pt_215:write(21503, [Kill]),
%%  {ok, Bin2} = pt_215:write(21504, [Power]),
	lib_server_send:send_to_uid(RoleId, Bin1).
%%  lib_server_send:send_to_uid(RoleId, Bin2).


%% -----------------------------------------------------------------
%% @desc     功能描述  使用技能
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
use_skill(RoleId, _SkillId, _DunPid, #soul_dungeon{role_dungeon_list = RoleDungeonList} = State) ->
	case lists:keyfind(RoleId, #role_soul_dungeon.role_id, RoleDungeonList) of
		#role_soul_dungeon{power = _Power} ->
			State;
		_ ->
			send_err_code(RoleId, ?ERRCODE(err215_not_enough_power)),
			State
	end.


%% @desc     功能描述  推送，这里什么都不做，放在handle_dungeon_direct_end里做
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_push_settlement(_State, _Role) ->
	ok.


%% -----------------------------------------------------------------
%% @desc     功能描述  通关结算 副本进程中  %%没有失败的讲法，大多数算多少
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_handle_dungeon_direct_end(#dungeon_state{dun_id = DunId, now_scene_id = SceneId, result_type = ResultType, role_list = RoleDungeonList,
	wave_num = WaveNum} = _State)
	when ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
	#dungeon_role{id = PlayerId, reward_map = RewardMap} = hd(RoleDungeonList),  %%单人副本
	skill_quit(PlayerId),
%%    ?MYLOG("cym", "RewardMap ~p~n", [RewardMap]),
	DropList = lib_dungeon:get_source_list(RewardMap),
	mod_soul_dungeon:battle_success(PlayerId, DropList, DunId, SceneId, WaveNum - 1);  %%有一波是水晶

%% @desc     功能描述  通关结算
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
dunex_handle_dungeon_direct_end(#dungeon_state{dun_id = DunId, now_scene_id = SceneId, role_list = RoleDungeonList, wave_num = WaveNum} = _State) ->
	%%副本成功记录
	#dungeon_role{id = PlayerId, reward_map = RewardMap} = hd(RoleDungeonList), %%单人副本
	skill_quit(PlayerId),
%%    ?MYLOG("cym", "RewardMap ~p~n", [RewardMap]),
	DropList = lib_dungeon:get_source_list(RewardMap),
	%% 资源找回 的处理
	Data1 = #act_data{act_id = ?MOD_DUNGEON, act_sub = 8, num = 1},
	lib_player_event:async_dispatch(PlayerId, ?EVENT_PARTICIPATE_ACT, Data1),
	Count = mod_counter:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
	mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId, Count + 1),
	mod_soul_dungeon:battle_success(PlayerId, DropList, DunId, SceneId, WaveNum - 1).


%% -----------------------------------------------------------------
%% @desc     功能描述  成功
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
battle_success(RoleId, DropList, State, DunId, SceneId, WaveNum) ->
	{NewState, _KillNum} = clear(RoleId, State),
	case data_soul_dungeon:get_reward_by_kill_num(DunId, WaveNum) of
		#soul_dungeon_reward{reward_list = RewardList} ->  %%通关奖励
%%            ?MYLOG("cym", "RoleId ~p KillNum ~p DropList ~p RewardList ~p NewState ~p~n",
%%                [RoleId, KillNum, DropList, RewardList, NewState]),
			%%发送奖励
%%            Pid = misc:get_player_process(RoleId),
%%            case misc:is_process_alive(Pid) of
%%                true -> %%直接发送
%%                    lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardList, type = soul_dungeon_reward});
%%                false -> %%离线, 发送邮件
%%                    Title = ?LAN_MSG(2150000),
%%                    Content = ?LAN_MSG(2150001),
%%                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList)
%%            end,
%%            {ok, Bin} = pt_610:write(61003, [1, 0, DunId, 0,
%%                SceneId, DropList ++ RewardList, [{4, KillNum}]]),
%%            lib_server_send:send_to_uid(RoleId, Bin);
			%%去到玩家进程发送奖励
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_soul_dungeon, send_reward,
				[DropList, RewardList, DunId, SceneId, WaveNum]);
		_ ->
			send_err_code(RoleId, ?MISSING_CONFIG)
	end,
	NewState.

%%清理击杀和能量，且返回击杀数量
clear(RoleId, #soul_dungeon{role_dungeon_list = List} = State) ->
	case lists:keyfind(RoleId, #role_soul_dungeon.role_id, List) of
		#role_soul_dungeon{kill_mon = _kill} = SoulRole ->
			NewSoulRole = SoulRole#role_soul_dungeon{kill_mon = 0, power = 0}, %%重置为0
			NewList = lists:keystore(RoleId, #role_soul_dungeon.role_id, List, NewSoulRole),
			{State#soul_dungeon{role_dungeon_list = NewList}, _kill};
		_ ->
			{State, 0}
	end.

%%handle所有怪物死亡事件， 计算刷新时间
mon_event_id_kill_all_mon(#dungeon_state{typical_data = DataMap, wave_num = WaveNum,
	dun_id = DunId, now_scene_id = SceneId, owner_id = RoleId} = State, _CommonEvent) ->
	Time =
		case data_dungeon_wave:get_wave(DunId, SceneId, WaveNum, 1) of  %%实际波数是往后推一波，因为有一波是水晶
			#dungeon_wave{refresh_time = RefreshTime} ->
				erlang:round(RefreshTime / 1000)
					+ utime:unixtime();
			_ ->
				0
		end,
	NewDataMap = maps:put(refreshTime, {WaveNum + 1, Time}, DataMap),
%%    ?MYLOG("cym", "WaveNum ~p   Time ~p Now ~p ~n", [WaveNum + 1, Time, utime:unixtime()]),
	{ok, Bin} = pt_215:write(21508, [WaveNum, Time]),
	lib_server_send:send_to_uid(RoleId, Bin),
	State#dungeon_state{typical_data = NewDataMap}.

%%下一波刷新时间
dunex_get_refresh_time(#dungeon_state{typical_data = DataMap, owner_id = RoleId} = State) ->
	{Wave, Time} = maps:get(refreshTime, DataMap, {0, 0}),
%%    ?MYLOG("cym", "WaveNum ~p   Time ~p ~n", [Wave, Time]),
	{ok, Bin} = pt_215:write(21508, [max(Wave - 1, 1), Time]),
	lib_server_send:send_to_uid(RoleId, Bin),
	State.

%% -----------------------------------------------------------------
%% @desc     功能描述  扫荡
%% @param    参数      Time::integer() 扫荡次数   BossNum::integer() 召唤boss数量
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
sweep(#player_status{id = RoleId, figure = Figure, combat_power = Power} = Player, DunId, AutoNum, BossNum, Wave, Auto) ->
	case lib_dungeon:is_on_dungeon(Player) of
		true ->
			send_err_code(RoleId, ?ERRCODE(err610_had_on_dungeon)),
			Player;
		_ ->
			case data_dungeon:get(DunId) of
				#dungeon{type = DunType, count_cond = CountCondition, sweep_cost = SweepCost} = Dun ->
					DailyList = lib_dungeon_api:get_daily_sweep_times_type_list(DunType),
					DailyCountList = mod_daily:get_count(Player#player_status.id, DailyList),
					case lib_soul_dungeon_check:check_sweep(Player, Dun, AutoNum, DailyCountList) of
						{false, Code} ->
							send_err_code(RoleId, Code),
							Player;
						true ->
							_CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
%%                          _DailyCount
%%                              = case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType}, 1, DailyCountList) of
%%                              {_, Count} ->
%%                                  Count + AutoNum;
%%                              _ ->
%%                                  AutoNum
%%                          end,
							%% 1计算消耗 -> 2 计算奖励 3 ->消耗 ->发送奖励 -通知客户端-> 返回Ps
							%%1 计算消耗
							_Cost = get_sweep_cost(AutoNum, BossNum),
							Cost = [{_GoodTpe, _GoodId, _Num} || {_GoodTpe, _GoodId, _Num} <- _Cost, _Num > 0],
							_RewardList = get_sweep_reward(DunId, Wave, BossNum, AutoNum),
							RewardList = [{_GoodType, _GoodId, _Num} || {_GoodType, _GoodId, _Num} <- _RewardList, _Num > 0],
							Res =
								if
									Auto == 1 ->
										lib_goods_api:cost_objects_with_auto_buy(Player, Cost ++ SweepCost, dungeon_count_sweep_cost, "");
									true ->
										lib_goods_api:cost_object_list_with_check(Player, Cost ++ SweepCost, dungeon_count_sweep_cost, "")
								end,
%%							?MYLOG("cym", "Res ~p~n", [Res]),
							case Res of
								{true, NewPs} ->
%%                                    ?MYLOG("cym", "Cost ~p RewardList ~p~n", [Cost, RewardList]),
									lib_dungeon:dungeon_count_plus(CountCondition, DunId, DunType, Player#player_status.id, AutoNum), %%减去次数
									lib_log_api:log_single_dungeon_sweep(RoleId, Figure#figure.lv, Power, DunId, DunType, RewardList, AutoNum, Cost ++ SweepCost),
									lib_goods_api:send_reward_with_mail(RoleId,
										#produce{reward = RewardList, type = dungeon_count_sweep_rewards}), %%发送邮件
									{_, _, NewPs1, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPs,
										#produce{reward = RewardList, type = dungeon_count_sweep_rewards}),
									SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList),
%%                                    ?MYLOG("cym", "SeeRewardList ~p~n", [SeeRewardList]),
									NewPlayer = lib_dungeon_sweep:handle_finish_duns(NewPs1, DunType, lists:duplicate(AutoNum, DunId)), %%完成扫荡
									{ok, Bin} = pt_610:write(61003, [1, 0, DunId, 0, 0, SeeRewardList, [], [{4, Wave}, {8, 2}], AutoNum]),
									lib_server_send:send_to_uid(RoleId, Bin),  %%通知客户端
									pp_dungeon:handle(61020, NewPlayer, [?DUNGEON_TYPE_RUNE]),

									Data = #callback_dungeon_enter{dun_id = DunId, dun_type = DunType, count = 1},
									lib_player_event:async_dispatch(Player#player_status.id, ?EVENT_DUNGEON_ENTER, Data),

									lib_dungeon:handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON, DunType, 1),
									NewPlayer;
								{true, NewPs, RealCost} ->
									?MYLOG("cym", "Cost ~p RewardList ~p~n", [Cost, RewardList]),
									lib_dungeon:dungeon_count_plus(CountCondition, DunId, DunType, Player#player_status.id, AutoNum), %%减去次数
									lib_log_api:log_single_dungeon_sweep(RoleId, Figure#figure.lv, Power, DunId, DunType, RewardList, AutoNum, RealCost),
									lib_goods_api:send_reward_with_mail(RoleId,
										#produce{reward = RewardList, type = dungeon_count_sweep_rewards}), %%发送邮件
									{_, _, NewPs1, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPs,
										#produce{reward = RewardList, type = dungeon_count_sweep_rewards}),
									SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList),
                                    ?MYLOG("cym", "Wave ~p~n", [Wave]),

									Data = #callback_dungeon_enter{dun_id = DunId, dun_type = DunType, count = 1},
									lib_player_event:async_dispatch(Player#player_status.id, ?EVENT_DUNGEON_ENTER, Data),

									lib_dungeon:handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON, DunType, 1),
									NewPlayer = lib_dungeon_sweep:handle_finish_duns(NewPs1, DunType, lists:duplicate(AutoNum, DunId)), %%完成扫荡
									{ok, Bin} = pt_610:write(61003, [1, 0, DunId, 0, 0, SeeRewardList, [], [{4, Wave}, {8, 2}], AutoNum]),
									lib_server_send:send_to_uid(RoleId, Bin),  %%通知客户端
									pp_dungeon:handle(61020, NewPlayer, [?DUNGEON_TYPE_RUNE]),
									NewPlayer;
								{false, Err, _} ->
									?MYLOG("cym", "Err ~p~n", [Err]),
									NewErr =
										case ?ERRCODE(goods_not_enough) of
											Err ->
												?ERRCODE(err215_not_enough_sweep_goods);
											_ ->
												Err
										end,
									send_err_code(RoleId, NewErr),
									Player
							end
					end;
				_ ->
					send_err_code(RoleId, ?MISSING_CONFIG),
					Player
			end
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  计算扫荡消耗
%% @param    参数      AutoNum::integer() 扫荡次数 BossNum::integer()  boss数量
%% @return   返回值    lists()   消耗列表
%% @history  修改历史
%% -----------------------------------------------------------------
get_sweep_cost(AutoNum, BossNum) ->
	BaseCost =
		case data_soul_dungeon:get_value_by_key(sweep_cost) of
			[_Cost] ->
				Res = [{_Type, _GoodId, _Num * AutoNum} || {_Type, _GoodId, _Num} <- _Cost],
				Res;
			_ ->
				[]
		end,
	BossCost =
		case data_soul_dungeon:get_value_by_key(create_boss_cost) of
			[_Cost2] ->
				Res2 = [{_Type2, _GoodId2, _Num2 * BossNum} || {_Type2, _GoodId2, _Num2} <- _Cost2],
				Res2;
			_ ->
				[]
		end,
	BossCost ++ BaseCost.
%% -----------------------------------------------------------------
%% @desc     功能描述  计算扫荡奖励
%% @param    参数      KillNum::integer() 最大击杀，
%%                     BossNum::integer() boss数量
%%                     AutoNum::integer() 扫荡次数
%% @return   返回值     list() 奖励列表
%% @history  修改历史
%% -----------------------------------------------------------------
get_sweep_reward(DunId, Wave, BossNum, AutoNum) ->
	get_sweep_reward_helper(DunId, Wave, BossNum, AutoNum, []).

get_sweep_reward_helper(_DunId, _Wave, 0, 0, Res) ->
	Res;
get_sweep_reward_helper(DunId, Wave, BossNum, 0, Res) ->  %%只是抽boss
	RewardList =
		case data_soul_dungeon:get_reward_by_kill_num(DunId, Wave) of   %%目前所有奖励都一样
			#soul_dungeon_reward{boss_rewrad_list = BossSweepList, boss_reward_draw_list = BossDrawList} ->
%%                {_, RList2} = util:find_ratio(BossSweepList, 1),
				get_sweep_reward_helper2(BossDrawList, BossSweepList);
			_ ->
				[]
		end,
	get_sweep_reward_helper(DunId, Wave, BossNum - 1, 0, Res ++ RewardList);
get_sweep_reward_helper(DunId, Wave, 0, AutoNum, Res) ->  %%只是抽普通扫荡
	RewardList =
		case data_soul_dungeon:get_reward_by_kill_num(DunId, Wave) of
			#soul_dungeon_reward{sweep_reward_list = SweepList, sweep_reward_draw_list = SweepDrawList} ->
				get_sweep_reward_helper2(SweepDrawList, SweepList);
%%                {_, RList} = util:find_ratio(SweepList, 1),
%%                RList;
			_ ->
				[]
		end,
	get_sweep_reward_helper(DunId, Wave, 0, AutoNum - 1, Res ++ RewardList);
get_sweep_reward_helper(DunId, Wave, BossNum, AutoNum, Res) ->
	RewardList =
		case data_soul_dungeon:get_reward_by_kill_num(DunId, Wave) of
			#soul_dungeon_reward{sweep_reward_list = SweepList, boss_rewrad_list = BossSweepList,
				boss_reward_draw_list = BossDrawList, sweep_reward_draw_list = SweepDrawList} ->
				get_sweep_reward_helper2(SweepDrawList, SweepList) ++ get_sweep_reward_helper2(BossDrawList, BossSweepList);
%%                {_, RList} = util:find_ratio(SweepList, 1),
%%                {_, RList2} = util:find_ratio(BossSweepList, 1),
%%                RList ++ RList2;
			_ ->
				[]
		end,
	get_sweep_reward_helper(DunId, Wave, BossNum - 1, AutoNum - 1, Res ++ RewardList).


get_sweep_reward_helper2(DrawList, PoolList) ->
	case DrawList of
		[{_, _} | _] -> %%必须是这种格式的配置配置
			lib_dungeon_api:get_dungeon_grade_help(DrawList, PoolList, []);
		_ ->
			[]
	end.

%%扣除召唤boss的消耗
creat_mon_cost(#player_status{id = RoleId} = Ps) ->
%%    ?MYLOG("cym", "create_mon cost ~n", []),
	case data_soul_dungeon:get_value_by_key(create_boss_cost) of
		[Cost] ->
			case lib_goods_api:cost_object_list_with_check(Ps, Cost, soul_dungeon_create_boss, "") of
				{true, NewPs} ->
					NewPs;
				{false, Err, _} ->
					send_err_code(RoleId, Err),
					Ps
			end;
		_ ->
			Ps
	end.


%%----------------------------------------------db相关-----------------------
%% -----------------------------------------------------------------
%% @desc     功能描述   同步数据库      1判断是否超过最大击杀  2 写入操作
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
update_record(#role_soul_dungeon{max_kill = MaxKill, role_id = RoleId}, NowKillNum) ->
	case NowKillNum >= MaxKill of
		true ->%%同步
			Sql = io_lib:format("replace into    role_soul_dungeon   VALUES(~p, ~p)", [RoleId, MaxKill]),
			db:execute(Sql);
		false ->
			skip
	end.

get_record_from_db() ->
	Sql = "select  role_id, max_kill from  role_soul_dungeon",
	List = db:get_all(Sql),
	RoleSoulDungeonList = [#role_soul_dungeon{role_id = RoleId, max_kill = MaxKill} || [RoleId, MaxKill] <- List],
	#soul_dungeon{role_dungeon_list = RoleSoulDungeonList}.

%%----------------------------------------------db相关-----------------------


%% -----------------------------------------------------------------
%% @desc     功能描述   取消副本定时器
%% @param    参数       Ps
%% @return   返回值     无
%% @history  修改历史
%% -----------------------------------------------------------------
cancel_revive_timer(#player_status{copy_id = DunPid, dungeon = Dungeon, id = RoleId}, ?REVIVE_SOUL_DUNGEON) ->
	#status_dungeon{dun_type = DunType} = Dungeon,
	case DunType of
		?DUNGEON_TYPE_RUNE ->  %%取消复活定时器
			gen_server:cast(DunPid, {'player_revive', RoleId});
		_ ->
			ok
	end;
cancel_revive_timer(_PS, _) ->
	ok.

%%添加临时技能
add_temp_skill(PlayerId) ->
	List = case data_soul_dungeon:get_all_skill() of
		[] ->
			[];
		_list ->
			_list
	end,
	SkillList = [{SkillId, 1} || {SkillId, _} <- List],
	%%设置能量
%%    ?MYLOG("cym",  "skill init ~n", []),
	lib_skill_api:set_energy(PlayerId, 0),
	lib_skill_api:add_tmp_skill_list(PlayerId, SkillList).


%%获得技能相对应的能量
get_need_energy(SkillId) ->
	[Power] = data_soul_dungeon:get_power_by_skill_id(SkillId),
	Power.


%%临时技能离场
skill_quit(PlayerId) ->
	%%取消临时技能
	List = case data_soul_dungeon:get_all_skill() of
		[] ->
			[];
		_list ->
			_list
	end,
	SkillList = [{SkillId, 1} || {SkillId, _} <- List],
	lib_skill_api:del_tmp_skill_list(PlayerId, SkillList),
	%%设置能量
	lib_skill_api:set_energy(PlayerId, 0).


dunex_handle_create_mon_special_cost([]) ->
	ok;
dunex_handle_create_mon_special_cost([#dungeon_role{id = RoleId} | RoleList]) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_soul_dungeon, creat_mon_cost, []), %%立即扣除
	dunex_handle_create_mon_special_cost(RoleList).

send_reward(#player_status{pid = PID, id = RoleId} = PS, DropList, RewardList, DunId, SceneId, WaveNum) ->
	Produce = #produce{reward = RewardList, type = soul_dungeon_reward},
	IsOnline = ?IF(PID == undefined, false, is_process_alive(PID)),
	case IsOnline of
		false ->
			?IF(Produce#produce.reward == [], skip, lib_goods_api:send_reward_with_mail(RoleId, Produce)),
			PS;
		true ->
			case lib_goods_api:send_reward_with_mail_return_goods(PS, Produce) of
				{ok, bag, LastPlayer, UpGoodsList} ->
					ok;
				{ok, mail, LastPlayer, []} ->
					UpGoodsList = []
			end,
			SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList),
			LastRewardList = lib_goods_api:combine_object_with_auto_goods_id(SeeRewardList ++ DropList),
			{ok, Bin} = pt_610:write(61003, [1, 0, DunId, 0,
				SceneId, LastRewardList, [], [{4, WaveNum}, {8, 1}], 1]),
%%            ?MYLOG("cym", "WaveNum ~n ~p~n", [WaveNum]),
			lib_server_send:send_to_uid(RoleId, Bin),
			LastPlayer
	end.

%%refresh_wave(PS, DunId, Wave) ->
%%	#player_status{soul_dun = SoulDun} = PS,
%%	#soul_dungeon_ps{role_dungeon_list = DungeonList} = SoulDun,
%%	case lists:keyfind(DunId, #soul_dungeon_ps_sub.dun_id, DungeonList) of
%%		#soul_dungeon_ps_sub{max_wave = } = Sub ->
%%			ok;
%%		_ ->
%%			Sub = #soul_dungeon_ps_sub{dun_id = DunId, s}
%%	end

sweep_repair() ->
	Sql = io_lib:format(<<"select  role_id, reward_list from   log_single_dungeon_sweep where  dun_type  = 8  and  time <=  1562128800  and  time >= 1562018400">>, []),
	List = db:get_all(Sql),
	Tile = "源力副本扫荡异常补偿",
	Content = "尊敬的玩家，关于源力副本扫荡获取奖励异常的问题现已处理解决，由此给您带来的不便敬请谅解。请收下副本扫荡相关异常问题补偿。感谢您对我们的支持，祝您游戏愉快。",
	[
		begin
			Reward = get_repair_reward(DbReward),
			if
				Reward == [] ->
					skip;
				true ->
					lib_mail:send_sys_mail([RoleId], Tile, Content, Reward)
			end
		end
		||
		[RoleId, DbReward]
			<- List].

get_repair_reward(DbReward) ->
	Reward = util:bitstring_to_term(DbReward),
%%	?MYLOG("cym", "Reward ~p~n", [Reward]),
	NewReward = [{GoodsType, GoodsId, Num} || {GoodsType, GoodsId, Num} <- Reward, (GoodsType == 0 andalso GoodsId =/= 0) orelse (GoodsType =/= 0 andalso GoodsId == 0)],
%%	?MYLOG("cym", "NewReward ~p~n", [NewReward]),
	L1 = length(Reward),
	L2 = length(NewReward),
	if
		L1 > L2 ->
			NewReward;
		true ->  %%长度一样，说明数据格式都是对的， 不用重发
			[]
	end.


























