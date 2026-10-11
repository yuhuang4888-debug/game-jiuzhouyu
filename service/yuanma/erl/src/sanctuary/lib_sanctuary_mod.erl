%%%-----------------------------------
%%% @Module      : lib_sanctuary_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 01. 三月 2019 15:08
%%% @Description : 文件摘要
%%%-----------------------------------



-module(lib_sanctuary_mod).
-author("chenyiming").

-include("sanctuary.hrl").
-include("boss.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("activitycalen.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% API
-compile(export_all).


%% 活动结束时间
get_end_time(SubType) ->
    case data_activitycalen:get_ac(?MOD_SANCTUARY, ?sanctuary_act_sub_id, SubType) of
        #base_ac{time_region = TimeList} ->
            get_end_time_help(TimeList);
        _ ->
            utime:unixtime() + 5
    end.

get_end_time_help([]) ->
    utime:unixtime() + 5;
get_end_time_help([{{H, M}, {EndH, EndM}} | TimeList]) ->
    StartTime = utime:unixdate() + H * 60 * 60 + M * 60,
    if
        H > EndH orelse (H == EndH andalso M > EndM) -> %%跨天了
            EndTime = utime:unixdate() + EndH * 60 * 60 + EndM * 60 + ?ONE_DAY_SECONDS;
        true ->
            EndTime = utime:unixdate() + EndH * 60 * 60 + EndM * 60
    end,
    Now = utime:unixtime(),
    if
        Now >= StartTime andalso Now =< EndTime ->
            EndTime;
        true ->
            get_end_time_help(TimeList)
    end.


get_last_day_end_time(SubType) ->
    case data_activitycalen:get_ac(?MOD_SANCTUARY, ?sanctuary_act_sub_id, SubType) of
        #base_ac{time_region = [{{_H, _M}, {EndH, EndM}}]} ->
            utime:unixdate() + EndH * 60 * 60 + EndM * 60;
        _ ->
            utime:unixtime() - 5
    end.

act_start(_EndTime, #sanctuary_state{status = ?sanctuary_open} = State) ->
    State;
act_start(EndTime, State) ->
    Time = max(1 * 1000, (EndTime - utime:unixtime()) * 1000),
    #sanctuary_state{act_end_ref = OldRef, result_ref = OldResRef} = State,
    Ref = util:send_after(OldRef, Time, self(), {act_end}), %%活动结束定时器
    PreTime = EndTime - ?sanctuary_preview_time,
    %%活动结束预告定时器
    PreRef = util:send_after(OldRef, max(1 * 1000, (PreTime - utime:unixtime()) * 1000), self(), {'priview_act_end'}),
    NewState = init_sanctuary_list(State),
    {ResultTime, ResultRef} = send_result(OldResRef),  %%结算定时器
%%    ?MYLOG("cym", "ResultTime ~p Endtime ~p  PreTime ~p~n", [ResultTime, EndTime, PreTime]),
    NewState#sanctuary_state{act_end_ref = Ref, status = ?sanctuary_open, act_end_time = EndTime,
        preview_end_ref = PreRef, result_time = ResultTime, result_ref = ResultRef}.

init() ->
    Status = lib_sanctuary:get_status(),
%%    ?MYLOG("cym", "init Status ~p ~n", [Status]),
    SanctuaryMap = lib_sanctuary:init_sanctuary_map_from_db(),
    %%通知公会进程 前三名
    GuildIdList = [GuildId || #sanctuary_msg{belong = GuildId} <- maps:values(SanctuaryMap), GuildId =/= 0],
%%    ?MYLOG("cym", "GuildIdList ~p~n", [GuildIdList]),
    mod_guild:update_sanctuary_top3_guild_list(GuildIdList),
    DesignationMap = lib_sanctuary:init_designation_from_db(),
    LastDesignationMap = lib_sanctuary:init_last_time_designation_from_db(),
    PersonRankRefreshTime = get_person_rank_refresh_time(),
    PersonRankRef = util:send_after([], (PersonRankRefreshTime - utime:unixtime()) * 1000, self(), {'person_rank_refresh'}),
    LastGuildRankList = lib_sanctuary:get_last_guild_list_from_db(),
%%  ?MYLOG("cym", "init Status ~p SanctuaryMap ~p ~nDesignationMap ~p LastGuildRankList ~p~n", [Status, SanctuaryMap, DesignationMap, LastGuildRankList]),
    {ResultTime, ResultRef} = send_result([]),  %%结算定时器
%%    ?MYLOG("cym", "ResultTime ~p~n", [ResultTime]),
    State1 = #sanctuary_state{status = Status, sanctuary_map = SanctuaryMap, designation_map = DesignationMap, person_rank_ref = PersonRankRef,
        last_time_designation = LastDesignationMap, last_time_guild_rank_list = LastGuildRankList, result_ref = ResultRef, result_time = ResultTime},
    case is_act_open() of
        {true, SubType} ->
            if
                Status =/= ?sanctuary_yet_over->
                    EndTime = lib_sanctuary_mod:get_end_time(SubType),    %%活动结束时间戳
                    lib_sanctuary_mod:act_start(EndTime, State1);
                true ->
                    State1
            end;
        _ ->
          MergeDay = util:get_merge_day(),
          if
              MergeDay == 1 andalso Status == ?sanctuary_yet_over ->
                  util:send_after([], 10 * 1000, self(), {'merge_handle'}),
                  %%合服第一天，重新10秒后重新结算
                  ok;
              true ->
                  skip
          end,
            State1
    end.


send_result(OldRef) ->
    %% 开服天数是否满足
    {_Min, Max} = data_sanctuary:get_kv(open_day),
    {H, M} = ?sanctuary_result_time,
    ResultTime = utime:unixdate() + H * 60 * 60 + M * 60, %%结算时间戳
    OpenDay = util:get_open_day(),
    Now = utime:unixtime(),
    if
        OpenDay < Max andalso ResultTime > Now->
%%            ?MYLOG("cym", "do_result ++++++++~n", []),
            {ResultTime, util:send_after(OldRef, max(500, (ResultTime - utime:unixtime()) * 1000), self(), {'do_result'})};
        true ->
            {0, []}
    end.

send_result2(OldRef) -> %%整点发送定时器
    %% 开服天数是否满足
    {_Min, Max} = data_sanctuary:get_kv(open_day),
%%    {H, M} = ?sanctuary_result_time,
%%    ResultTime = utime:unixdate() + H * 60 * 60 + M * 60, %%结算时间戳
    OpenDay = util:get_open_day(),
    Now = utime:unixtime(),
    if
        OpenDay < Max->
%%            ?MYLOG("cym", "do_result ++++++++time ~p~n", [Now + 86400]),
            {Now + 86400, util:send_after(OldRef, max(500, 86400 * 1000), self(), {'do_result'})};
        true ->
            {0, []}
    end.


end_act(State) ->
    State1 = all_role_force_quit(State),
    %% 清理场景内怪物
    State2 = clear_mon(State1),
    % ?MYLOG("cym", "end_act +++++++++++ ~n", []),
    %%发送广播
    #sanctuary_state{act_end_time = Time} = State2,
    {ok, Bin} = pt_283:write(28306, [Time]),
    lib_server_send:send_to_local_all(Bin),
%%    OpenDay = util:get_open_day(),
%%    {_, MaxDay} = data_sanctuary:get_kv(open_day),
%%    Status = ?IF(OpenDay == MaxDay, ?sanctuary_yet_over, ?sanctuary_close), %%最后一天结束，则永久结束
    Status = lib_sanctuary:get_status(),
%%    ?MYLOG("sanctuary", "Status ~p~n", [Status]),
    State2#sanctuary_state{status = Status}.

%%清理怪物
clear_mon(State) ->
	#sanctuary_state{sanctuary_map = SanctuaryMap} = State,
	F = fun(#sanctuary_msg{sanctuary_id = SanctuaryId, mon_msg = MonList}) ->
		SceneId = data_sanctuary:get_sanctuary_scene(SanctuaryId),
		[util:cancel_timer(Ref) || #sanctuary_mon_msg{ref = Ref} <- MonList],
		lib_scene:clear_scene(SceneId, ?sanctuary_scene_pool)
	end,
	SanctuaryList = maps:values(SanctuaryMap),
	lists:foreach(F, SanctuaryList),
	State.

%%第一次初始化，没有归属
init_mon_list(Map) when map_size(Map) == 0 ->
	F = fun(SanctuaryId, AccMap) ->
		SceneId = data_sanctuary:get_sanctuary_scene(SanctuaryId),
		lib_scene:clear_scene(SceneId, ?sanctuary_scene_pool),
		MonList = data_sanctuary:get_mon_list_by_sanctuary(SanctuaryId),
		F2 = fun(MonId, Acc) ->
			MonMsg = create_mon(MonId, SceneId, 0),
			[MonMsg | Acc]
		end,
		MonMsgList = lists:foldl(F2, [], MonList),
		Sanctuary = #sanctuary_msg{mon_msg = MonMsgList, sanctuary_id = SanctuaryId},
		maps:put(SanctuaryId, Sanctuary, AccMap)
	end,
	lists:foldl(F, #{}, ?sanctuary_id_list);
init_mon_list(Map) ->
	F = fun(SanctuaryId, AccMap) ->
		Sanctuary = maps:get(SanctuaryId, AccMap, #sanctuary_msg{}),
		#sanctuary_msg{belong = BelongGuild, mon_msg = OldMonList} = Sanctuary,
		SceneId = data_sanctuary:get_sanctuary_scene(SanctuaryId),
		lib_scene:clear_scene(SceneId, ?sanctuary_scene_pool),
		MonList = data_sanctuary:get_mon_list_by_sanctuary(SanctuaryId),
		F2 = fun(MonId, Acc) ->
			MonMsg = create_mon(MonId, SceneId, BelongGuild),
			[MonMsg | Acc]
		end,
		_MonMsgList = lists:foldl(F2, [], MonList),
		NewMonList = [X#sanctuary_mon_msg{reborn_time = 0, ref = [], status = ?sanctuary_mon_live} || X <- OldMonList],
		NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = NewMonList, sanctuary_id = SanctuaryId},
		maps:put(SanctuaryId, NewSanctuary, AccMap)
	end,
	lists:foldl(F, Map, ?sanctuary_id_list).

%% -----------------------------------------------------------------
%% @desc     功能描述  创建归属怪物
%% @param    参数     BelongGuild::归属的公会，如果是0 则没有归属
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
create_mon(MonId, SceneId, BelongGuild) ->
	case get_mon_xy(MonId) of
		{X, Y} ->
			lib_mon:async_create_mon(MonId, SceneId, ?sanctuary_scene_pool, X, Y, 1, ?sanctuary_copy_id, 1, [{guild_id, BelongGuild}]),
			#sanctuary_mon_msg{cfg_id = MonId, status = ?sanctuary_mon_live};
		_ ->
			?ERR("MissCfg ~p~n", [MonId]),
			#sanctuary_mon_msg{}
	end.

%%全部玩家退出
all_role_force_quit(State) ->
	#sanctuary_state{role_list = RoleList} = State,
	F = fun(#sanctuary_role{role_id = RoleId}) ->
		lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{change_scene_hp_lim, 100}])
	end,
	lists:foreach(F, RoleList),
	State#sanctuary_state{role_list = []}.

%%初始化圣域列表
init_sanctuary_list(State) ->
	#sanctuary_state{sanctuary_map = Map} = State,
	NewMap = init_mon_list(Map),
%%	?MYLOG("cym", "Map ~p~n", [NewMap]),
	State#sanctuary_state{sanctuary_map = NewMap}.



add_role_to_sanctuary(RoleId, SanctuaryId, State, LastDieTime, DieCount) ->
	KillTimeList = get_kill_time_list(LastDieTime, DieCount),
	RoleMsg = #sanctuary_role{role_id = RoleId, sanctuary_id = SanctuaryId, be_kill_time_list = KillTimeList},
	#sanctuary_state{role_list = RoleList} = State,
	RoleList1 = lists:keystore(RoleId, #sanctuary_role.role_id, RoleList, RoleMsg),
	State#sanctuary_state{role_list = RoleList1}.



quit(RoleId, State) ->
	#sanctuary_state{role_list = RoleList} = State,
	NewRoleList = lists:keydelete(RoleId, #sanctuary_role.role_id, RoleList),
	back_to_out_side(RoleId),
	State#sanctuary_state{role_list = NewRoleList}.

back_to_out_side(RoleId) ->
	lib_scene:player_change_scene(RoleId, 0, 0, 0, true,
		[{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]).



is_open(State) ->
	#sanctuary_state{status = Status} = State,
	Status == ?sanctuary_open.

get_info(RoleId, SanctuaryId, State) ->
	#sanctuary_state{sanctuary_map = Map, act_end_time = EndTime} = State,
	Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	#sanctuary_msg{mon_msg = MonList, point = Point, belong = Belong, belong_name = BelongName} = Sanctuary,
	PickMonList = pick_mon_list(MonList, RoleId),
%%	?MYLOG("cym", "get_mon_info ~p~n", [{SanctuaryId, Point, Belong, BelongName, EndTime, PickMonList}]),
	{ok, Bin} = pt_283:write(28301, [SanctuaryId, Point, Belong, BelongName, EndTime, PickMonList]),
	lib_server_send:send_to_uid(RoleId, Bin).

pick_mon_list(MonList, RoleId) ->
	pick_mon_list(MonList, RoleId, []).

pick_mon_list([], _RoleId, Acc) ->
	Acc;
pick_mon_list([H | MonList], RoleId, Acc) ->
	#sanctuary_mon_msg{remind_list = RemindList, cfg_id = MonId, reborn_time = RebornTime, status = Status} = H,
	IsRemind =
		case RemindList of
			undefined ->
				0;
			_ ->
				?IF(lists:member(RoleId, RemindList) == true, 1, 0)
		end,
	LastRebornTime = ?IF(Status == ?sanctuary_mon_dead, RebornTime, 0),
	pick_mon_list(MonList, RoleId, [{MonId, LastRebornTime, IsRemind} | Acc]).

remind(_RoleId, _SanctuaryId, [], State) ->
	State;
remind(RoleId, SanctuaryId, [H | MonList], State) ->
	NewState = remind(RoleId, SanctuaryId, H, 1, State, ?not_send_protocol),
	remind(RoleId, SanctuaryId, MonList, NewState).

%%添加或者取消关注
remind(RoleId, SanctuaryId, BossId, Remind, State, IsSend) ->
	#sanctuary_state{sanctuary_map = Map} = State,
	Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	#sanctuary_msg{mon_msg = MonList} = Sanctuary,
	case lists:keyfind(BossId, #sanctuary_mon_msg.cfg_id, MonList) of
		#sanctuary_mon_msg{remind_list = RemindList} = MonMsg ->
			NewRemindList = lists:delete(RoleId, RemindList),
			if
				Remind == ?sanctuary_mon_no_remind -> %%取消关注
					LastRemindList = NewRemindList;
				true ->
					LastRemindList = [RoleId | NewRemindList]
			end,
			lib_sanctuary:db_save_mon_remind_list(BossId, LastRemindList),
			if
				IsSend == ?send_protocol ->
					%%发送信息
					{ok, Bin} = pt_283:write(28305, [SanctuaryId, BossId, Remind]),
					lib_server_send:send_to_uid(RoleId, Bin);
				true ->
					skip
			end,
			%%组装信息
			NewMonMsg = MonMsg#sanctuary_mon_msg{remind_list = LastRemindList},
			NewMonList = lists:keystore(BossId, #sanctuary_mon_msg.cfg_id, MonList, NewMonMsg),
			NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = NewMonList},
			NewMap = maps:put(SanctuaryId, NewSanctuary, Map),
			State#sanctuary_state{sanctuary_map = NewMap};
		_ ->
			pp_sanctuary:send_error(RoleId, ?FAIL),
			State
	end.

%%怪物被击杀
boss_be_kill(SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName, _State) ->
	#scene_mon{mid = MonCfgId} = MonInfo,
	%%增加圣域积分
	{State, KillLog, GetPointSanctuaryId, ReducePointSanctuaryId, DiffPoint} =
		add_sanctuary_point(RoleId, GuildId, MonCfgId, SanctuaryId, RoleName, _State),
	%%通知公会的玩家增加积分信息
	lib_sanctuary:send_point_to_client(DiffPoint, GuildId, KillList, RoleId),
	%%积分日志
	lib_log_api:log_sanctuary_point(RoleId, MonCfgId, GetPointSanctuaryId, ReducePointSanctuaryId, DiffPoint),
	%%同步圣域信息(除了怪物信息)
	lib_sanctuary:db_save_sanctuary_msg(State),
	lib_eternal_valley_api:sanctuary_boss(KillList),
	CallBackData = #callback_boss_kill{boss_type = ?BOSS_TYPE_SANCTUARY, boss_id = MonCfgId},
	[lib_player_event:async_dispatch(RId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RId}<-KillList],
	#sanctuary_state{sanctuary_map = Map} = State,
	Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	#sanctuary_msg{mon_msg = MonList} = Sanctuary,
	case lists:keyfind(MonCfgId, #sanctuary_mon_msg.cfg_id, MonList) of
		#sanctuary_mon_msg{ref = OldRef, kill_log = KillLogList} = MonMsg ->
			%%日常处理
			handle_activity(KillList),
			%%发送固定奖励
			lib_sanctuary:send_kill_reward(MonInfo, KillList, SanctuaryId),
			case get_mon_reborn_time(MonCfgId) of
				{ok, RebornTime} ->
					Ref = util:send_after(OldRef, RebornTime * 1000, self(), {'reborn_boss', SanctuaryId, MonCfgId}), %%重生定时器
					%%通知客户端怪物死亡信息
					send_to_client_boss_die(RebornTime + utime:unixtime(), MonCfgId, SanctuaryId),
					%%修改怪物信息
					NewKillLogList = lists:sublist([KillLog | KillLogList], ?sanctuary_kill_log_len),
					NewMonMsg = MonMsg#sanctuary_mon_msg{reborn_time = utime:unixtime() + RebornTime,
						ref = Ref, status = ?sanctuary_mon_dead, kill_log = NewKillLogList},
					%%击杀记录数据库
					lib_sanctuary:db_save_mon_kill_log(KillLog, MonCfgId),
					NewMonList = lists:keystore(MonCfgId, #sanctuary_mon_msg.cfg_id, MonList, NewMonMsg),
					NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = NewMonList},
					NewMap = maps:put(SanctuaryId, NewSanctuary, Map),
					State#sanctuary_state{sanctuary_map = NewMap};
				_ ->
					?ERR("MissCfg ~p~n", [MonCfgId]),
					State
			end;
		_ ->
			State
	end.


%%重生
reborn_boss(SanctuaryId, MonCfgId, State) ->
	#sanctuary_state{status = Status, sanctuary_map = Map} = State,
	SceneId = data_sanctuary:get_sanctuary_scene(SanctuaryId),
	if
		Status == ?sanctuary_open ->
			Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
			#sanctuary_msg{mon_msg = MonList, belong = Belong} = Sanctuary,
			case lists:keyfind(MonCfgId, #sanctuary_mon_msg.cfg_id, MonList) of
				#sanctuary_mon_msg{remind_list = RemindList} = MonMsg ->
					?MYLOG("cym", "MonCfgId ~p reborn ~n", [MonCfgId]),
					create_mon(MonCfgId, SceneId, Belong),  %%创建怪物
					%%提醒功能
					remind_to_client(RemindList, SanctuaryId, MonCfgId, Belong),
					%%改变怪物状态信息
					NewMonMsg = MonMsg#sanctuary_mon_msg{reborn_time = 0, status = ?sanctuary_mon_live},
					NewMonList = lists:keystore(MonCfgId, #sanctuary_mon_msg.cfg_id, MonList, NewMonMsg),
					NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = NewMonList},
					NewMap = maps:put(SanctuaryId, NewSanctuary, Map),
					State#sanctuary_state{sanctuary_map = NewMap};
				_ ->
					State
			end;
		true ->
			State
	end.

%% 秘籍重生Boss
gm_reset_boss(SanctuaryId, State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
	Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	#sanctuary_msg{mon_msg = MonList} = Sanctuary,
    F = fun(MonMsg, NewMonList) ->
        #sanctuary_mon_msg{cfg_id = MonCfgId, status = MonStatus, ref = OldRef} = MonMsg,
        case MonStatus of
            ?sanctuary_mon_dead ->
                Ref = util:send_after(OldRef, 100, self(), {'reborn_boss', SanctuaryId, MonCfgId}),
                NewMonMsg = MonMsg#sanctuary_mon_msg{ref = Ref},
                lists:keystore(MonCfgId, #sanctuary_mon_msg.cfg_id, MonList, NewMonMsg);
            _ -> NewMonList
        end
    end,
    LastMonList = lists:foldl(F, MonList,MonList),
    NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = LastMonList},
    NewMap = maps:put(SanctuaryId, NewSanctuary,Map),
    State#sanctuary_state{sanctuary_map = NewMap}.


%%提醒功能
remind_to_client(RemindList, SanctuaryId, MonCfgId, BelongGuildId) ->
%%	?MYLOG("cym", "RemindList ~p~n", [RemindList]),
%%	{ok, Bin} = pt_283:write(28307, [SanctuaryId, MonCfgId]),
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, remind_in_ps, [SanctuaryId, MonCfgId, BelongGuildId]) || RoleId <- RemindList].

%% -----------------------------------------------------------------
%% @desc     功能描述  抢夺积分
%% @param    参数
%% @return   返回值    返回{State, killLogm, 获得积分圣域， 减少积分圣域， 积分}  killLog:击杀记录
%% @history  修改历史
%% -----------------------------------------------------------------
add_sanctuary_point(RoleId, GuildId, MonCfgId, SanctuaryId, RoleName, State) when is_integer(GuildId) andalso GuildId > 0 ->
	#sanctuary_state{sanctuary_map = Map} = State,
	SanctuaryList = maps:values(Map),
	InSanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),  %%被抢夺的圣域
	Now = utime:unixtime(),
	#sanctuary_msg{belong = BeGrabBelong, point = BeGrabPoint} = InSanctuary,
	if
		BeGrabBelong == 0 ->  %%被抢夺的圣域没有归属
			?MYLOG("cym", "BeGrabBelong ~p~n", [BeGrabBelong]),
			KillLog = #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = 0, diff_point = 0, time = Now},
			{State, KillLog, 0, 0, 0};
		BeGrabBelong == GuildId -> %%同一个圣域归属，即在自己圣域击杀怪物
			{State, #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = 0, diff_point = 0, time = Now}, 0, 0, 0};
		true ->
			case lists:keyfind(GuildId, #sanctuary_msg.belong, SanctuaryList) of
				#sanctuary_msg{point = OldPoint, sanctuary_id = GrabSanctuaryId} = Sanctuary ->
					DiffPoint = get_add_point_by_mon_id(MonCfgId, SanctuaryId, InSanctuary),
					?MYLOG("cym", "DiffPoint ~p MonCfgId ~p~n", [DiffPoint, MonCfgId]),
					BeGrabSanctuary = InSanctuary#sanctuary_msg{point = max(BeGrabPoint - DiffPoint, 0)}, %%被抢夺积分
					NewSanctuary = Sanctuary#sanctuary_msg{point = OldPoint + DiffPoint},    %%抢夺积分
					Map1 = maps:put(SanctuaryId, BeGrabSanctuary, Map),                      %%被抢夺的圣域
					Map2 = maps:put(GrabSanctuaryId, NewSanctuary, Map1),                    %%抢夺别人的圣域
					State3 = State#sanctuary_state{sanctuary_map = Map2},
					KillLog = #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = 1, diff_point = DiffPoint, time = Now},
					{State3, KillLog, GrabSanctuaryId, SanctuaryId, DiffPoint};
				_ -> %%击杀者没有圣域
					?MYLOG("cym", "DiffPoint +++++++++++++~n", []),
					{State, #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = 0, diff_point = 0, time = Now},
						0, SanctuaryId, 0}
			end
	end;
add_sanctuary_point(RoleId, _GuildId, _MonCfgId, _SanctuaryId, RoleName, State) ->
    {State, #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = 0, diff_point = 0, time = utime:unixtime()}, 0, 0, 0}.

get_add_point_by_mon_id(MonCfgId, SanctuaryId, InSanctuary) ->
    #sanctuary_msg{point = Point} = InSanctuary, %%被抢夺的圣域
    PointList = data_sanctuary:get_kv(kill_point),
    case data_boss:get_boss_cfg(MonCfgId) of
        #boss_cfg{sign = Sign} ->
            if
                Sign == 1 -> %% 和平
                    0;
                true ->
                    case data_sanctuary:get_mon_type(SanctuaryId, MonCfgId) of
                        [] ->
                            0;
                        Type ->
                            if
                                Type =< ?sanctuary_mon_type_boss ->
                                    case lists:keyfind(Type, 1, PointList) of
                                        {Type, Value} ->
                                            if
                                                Value < 1 ->
                                                    trunc(Point * Value);
                                                true ->
                                                    min(Value, Point)
                                            end;
                                        _ ->
                                            0
                                    end;
                                true ->
                                    0
                            end
                    end
            end;
        _ ->
            0
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述 玩家被击杀
%% @param    参数     DieId::integer() 死亡玩家id
%%                   DieGuildId::integer() 死亡玩家公会id
%%                   AttackId::integer() 攻击者id
%%                   AttackGuildId::integer() 攻击者公会id
%%                   SceneId::integer() 当前场景id
%%                   HitRoleList::[RoleId] 助攻玩家id，
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
player_be_kill(DieId, _DieName, DieGuildId, 0, _AtterName, 0, SceneId, _X, _Y, _HitRoleList, State) ->
	%%日志
	lib_log_api:log_sanctuary_kill(0, 0, DieId, []),
	%%增加疲劳
	handle_player_die(DieId, DieGuildId, SceneId, State);
player_be_kill(DieId, DieName, DieGuildId, AttackId, AtterName, AttackGuildId, SceneId, X, Y, HitRoleList, State) ->
	?MYLOG("cym", "AttackId ~p,     HitList ~p~n", [AttackId, HitRoleList]),
	%%增加勋章
	SanctuaryId = get_sanctuary_id_by_scene_id(SceneId),
	#sanctuary_state{sanctuary_map = Map} = State,
	Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	#sanctuary_msg{belong = BelongGuildId} = Sanctuary,
	Reward = data_sanctuary:get_kv(kill_player_reward),
	Produce = #produce{reward = Reward, type = sanctuary_kill_reward, show_tips = ?SHOW_TIPS_3},
	%%日志
	lib_log_api:log_sanctuary_kill(AttackId, 0, DieId, Reward),
	if
		BelongGuildId == AttackGuildId ->  %% 在己方圣域击杀玩家
			lib_goods_api:send_reward_with_mail(AttackId, Produce), %%发送奖励
			[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, send_kill_player_reward, [Produce, AttackGuildId, DieId])
				|| RoleId <- HitRoleList];
		true ->
			skip
	end,
	BossType = ?BOSS_TYPE_SANCTUARY,
	BossTypeName = data_boss:get_boss_type_name(BossType),
	DieGuildId > 0 andalso
		lib_chat:send_TV({guild, DieGuildId}, ?MOD_BOSS, 15, [DieName, util:make_sure_binary(BossTypeName), AtterName, BossType, SanctuaryId, SceneId, X, Y]),
	AttackGuildId > 0 andalso
		lib_chat:send_TV({guild, AttackGuildId}, ?MOD_BOSS, 16, [AtterName, util:make_sure_binary(BossTypeName), DieName]),
	%%增加疲劳
	NewState = handle_player_die(DieId, DieGuildId, SceneId, State),
	NewState.

get_sanctuary_id_by_scene_id(SceneId) ->
	case data_sanctuary:get_sanctuary_id_by_scene(SceneId) of
		[] ->
			0;
		V ->
			V
	end.

handle_player_die(DieId, _DieGuildId, _SceneId, State) ->
	#sanctuary_state{role_list = RoleList} = State,
	case lists:keyfind(DieId, #sanctuary_role.role_id, RoleList) of
		#sanctuary_role{be_kill_time_list = TimeList} = RoleMsg ->
			FatigueBuffTime = get_fatigue_buff_time(),
			ReviveGhostTime = get_revive_ghost_time(),
			NowTime = utime:unixtime(),
			NewList = lib_boss_mod:get_real_die_time_list_2(TimeList, FatigueBuffTime, NowTime),
			DieTimes = erlang:length([NowTime | NewList]),  %%死亡次数
			{RebornTime, MinTimes} = lib_sanctuary:count_die_wait_time(DieTimes, NowTime),
			%%更新ps信息
			lib_player:apply_cast(DieId, ?APPLY_CAST_SAVE, lib_boss, update_role_boss, [?BOSS_TYPE_SANCTUARY,
				RebornTime, NowTime, DieTimes]),
			%%发送信息给客户端
			?MYLOG("cym", "die NowTime ~p~n", [NowTime]),
			if
				DieTimes > MinTimes ->
					?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, NowTime + FatigueBuffTime, NowTime + ReviveGhostTime}]),
					lib_server_send:send_to_uid(DieId, pt_283, 28308, [DieTimes, RebornTime, NowTime + FatigueBuffTime, NowTime + ReviveGhostTime]);
				true ->
					?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, NowTime + FatigueBuffTime, 0}]),
					lib_server_send:send_to_uid(DieId, pt_283, 28308, [DieTimes, RebornTime, NowTime + FatigueBuffTime, 0])
			end,
			%%组装信息
			NewRoleMsg = RoleMsg#sanctuary_role{be_kill_time_list = [NowTime | NewList]},
			NewRoleList = lists:keystore(DieId, #sanctuary_role.role_id, RoleList, NewRoleMsg),
			State#sanctuary_state{role_list = NewRoleList};
		_ ->
			State
	end.

%%疲劳持续时间
get_fatigue_buff_time() ->
	data_sanctuary:get_kv(player_die_times).

%%恢复为幽灵的时间
get_revive_ghost_time() ->
	data_sanctuary:get_kv(revive_point_gost).


get_kill_time_list(LastDieTime, DieCount) when DieCount >= 1 ->
	List = lists:seq(1, DieCount),
	[LastDieTime || _ <- List];
get_kill_time_list(_, _) ->
	[].

send_to_client_boss_die(RebornTime, MonCfgId, SanctuaryId) ->
	{ok, Bin} = pt_283:write(28309, [SanctuaryId, MonCfgId, RebornTime]),
	lib_server_send:send_to_local_all(Bin).

%%结算
do_result(State) ->
    % ?MYLOG("cym", "do_result +++++++++++ ~n", []),
    OpenDay = util:get_open_day(),
    {MinDay, MaxDay} = data_sanctuary:get_kv(open_day),
    if
        OpenDay < MaxDay andalso OpenDay >= (MinDay - 1) ->  %%开启的前一天结算排行榜
            mod_common_rank:sanctuary_do_result(),  %%通知排行榜
            NewState = State;
        OpenDay > MaxDay ->
            NewState = State;
        true ->
            #sanctuary_state{result_ref = OldResRef} = State,
            %%活动结束预告定时器
            {ResultTime, ResultRef} = send_result2(OldResRef),  %%结算定时器
            NewState = State#sanctuary_state{result_time = ResultTime, result_ref = ResultRef}
    end,
    NewState.

do_result_force() ->
	mod_common_rank:sanctuary_do_result(). %%通知排行榜

%% 排行榜一个公会都没有
do_result_with_guild_with_msg([], State) ->
	State;
do_result_with_guild_with_msg(GuildList, State) ->
	#sanctuary_state{sanctuary_map = SanctuaryMap} = State,
	IsTheSameGuild = is_the_same_guild(GuildList, SanctuaryMap),
    ?INFO("sanc do result ~p~n", [{GuildList, SanctuaryMap, IsTheSameGuild}]),
	if
		IsTheSameGuild == true -> %% 前三没有变化
			%%重置评分, 怪物的分组也不用变化, 称号也没有变化
			SanctuaryList = maps:values(SanctuaryMap),
			NewSanctuaryList = [Sanctuary#sanctuary_msg{point = ?sanctuary_default_point} || Sanctuary <- SanctuaryList],
			NewSanctuaryMap = sanctuary_list_to_map(NewSanctuaryList),
			NewState = State#sanctuary_state{sanctuary_map = NewSanctuaryMap};
		true ->
			GuildIdList = [GuildId || {GuildId, _} <- GuildList],
			%%通知公会进程前三名 前3名的公会人数上限临时增加20人，若是下次结算时公会掉出前3不会强制T人，但是无法再加人
			mod_guild:update_sanctuary_top3_guild_list(GuildIdList),
			NewSanctuaryMap = reset_sanctuary(SanctuaryMap, GuildList),
			NewState = State#sanctuary_state{sanctuary_map = NewSanctuaryMap}
	end,
    ?INFO("sanc after do result ~p~n", [NewSanctuaryMap]),
	%%日志
	#sanctuary_state{sanctuary_map = NewMap} = NewState,
	[lib_log_api:log_sanctuary_belong(SId, BelongId) || #sanctuary_msg{sanctuary_id = SId, belong = BelongId} <- maps:values(NewMap)],
	send_sanctuary_belong_msg_to_guild(NewState),
	%% 同步数据库
	lib_sanctuary:db_save_sanctuary_msg(NewState),
	%%个人排行榜结算
	do_result_guild_person_rank(NewState),
	NewState.

%%新的前三名是否和以前的一样
is_the_same_guild(GuildList, SanctuaryMap) ->
    GuildIdList = [Id || {Id, _} <- GuildList],
    SanctuaryList = maps:values(SanctuaryMap),
    OldGuildList = [BelongGuildId || #sanctuary_msg{belong = BelongGuildId} <- SanctuaryList],
    DiffList = OldGuildList -- GuildIdList,
    if
        DiffList == [] ->  %% 一样
            true;
        true ->
            false
    end.

merge_sanctuary_do_result([], State) ->
    State;
merge_sanctuary_do_result(GuildList, State) ->
    #sanctuary_state{sanctuary_map = _SanctuaryMap} = State,
    GuildIdList = [GuildId || {GuildId, _} <- GuildList],
    %%通知公会进程前三名 前3名的公会人数上限临时增加20人，若是下次结算时公会掉出前3不会强制T人，但是无法再加人
    mod_guild:update_sanctuary_top3_guild_list(GuildIdList),
%%    NewSanctuaryMap = reset_sanctuary(SanctuaryMap, GuildList),
    F = fun({GuildId, GuildName}, {AccMap, SanctuaryId}) ->
            Sanctuary = #sanctuary_msg{sanctuary_id = SanctuaryId + 1, belong = GuildId, belong_name = GuildName},
            NewMap1 = maps:put(SanctuaryId + 1, Sanctuary, AccMap),
            {NewMap1, SanctuaryId + 1}
        end,
    {NewSanctuaryMap, _}= lists:foldl(F, {#{}, 0}, GuildList),
    NewState = State#sanctuary_state{sanctuary_map = NewSanctuaryMap},
    %%日志
%%    ?MYLOG("cym", "~p~n", [NewSanctuaryMap]),
%%    #sanctuary_state{sanctuary_map = NewMap} = NewState,
    [lib_log_api:log_sanctuary_belong(SId, BelongId) || #sanctuary_msg{sanctuary_id = SId, belong = BelongId} <- maps:values(NewSanctuaryMap)],
%%    send_sanctuary_belong_msg_to_guild(NewState),
    %% 同步数据库
    lib_sanctuary:db_save_sanctuary_msg(NewState),
    NewState.

%% 列表转为map
sanctuary_list_to_map(SanctuaryList) ->
	sanctuary_list_to_map(SanctuaryList, #{}).
sanctuary_list_to_map([], Map) ->
	Map;
sanctuary_list_to_map([H | SanctuaryList], Map) ->
	#sanctuary_msg{sanctuary_id = SanctuaryId} = H,
	sanctuary_list_to_map(SanctuaryList, maps:put(SanctuaryId, H, Map)).

%% -----------------------------------------------------------------
%% @desc     功能描述  计算归属 =》重置评分 =》 怪物的分组 =》 称号变化
%% @param    参数      SanctuaryMap::map()  SanctuaryId => #sanctuary_msg{}
%%                     GuildList::lists()  [{GuildI, GuildName}]
%% @return   返回值    NewSanctuaryMap
%% @history  修改历史
%% -----------------------------------------------------------------
reset_sanctuary(SanctuaryMap, GuildList) ->
	ShuffleGuildList = ulists:list_shuffle(GuildList),
	SanctuaryList = maps:values(SanctuaryMap),
	reset_sanctuary_help(SanctuaryList, ShuffleGuildList, []).

reset_sanctuary_help([], [], AccList) ->
	sanctuary_list_to_map(AccList);

reset_sanctuary_help([Sanctuary | SanctuaryList], [], AccList) ->  %%排行榜公会数量不足
	#sanctuary_msg{sanctuary_id = SanctuaryId, belong = OldBelongGuildId} = Sanctuary,
	%%改变分组
	?IF(OldBelongGuildId == 0, skip, change_mon_group(SanctuaryId, 0)),
	NewSanctuary = Sanctuary#sanctuary_msg{point = 0, belong = 0, belong_name = ""},
	reset_sanctuary_help(SanctuaryList, [], [NewSanctuary | AccList]);

reset_sanctuary_help([Sanctuary | SanctuaryList], [{GuildId, GuildName} | GuildList], AccList) ->
	#sanctuary_msg{sanctuary_id = SanctuaryId, belong = OldBelongGuildId} = Sanctuary,
	%%改变分组
	?IF(OldBelongGuildId == GuildId, skip, change_mon_group(SanctuaryId, GuildId)), %% 如果是同一个分组则不改变分组
	NewSanctuary = Sanctuary#sanctuary_msg{point = ?sanctuary_default_point,
		belong = GuildId, belong_name = GuildName},
	reset_sanctuary_help(SanctuaryList, GuildList, [NewSanctuary | AccList]).


%%改变怪物公会所属 ，不再是改变战斗分组
change_mon_group(SanctuaryId, GuildId) ->
%%	?MYLOG("cym", "change battle group SanctuaryId ~p , Group ~p~n", [SanctuaryId, Group]),
	SceneId = data_sanctuary:get_sanctuary_scene(SanctuaryId),
	lib_scene_agent:change_mon_attr(SceneId, ?sanctuary_scene_pool, [{guild_id, GuildId}]).

send_sanctuary_belong_msg_to_guild(State) ->
	#sanctuary_state{sanctuary_map = SanctuaryMap} = State,
	SanctuaryList = maps:values(SanctuaryMap),
	%%发送邮件
	send_sanctuary_belong_msg_to_guild_help(SanctuaryList).

send_sanctuary_belong_msg_to_guild_help([]) ->
	ok;
send_sanctuary_belong_msg_to_guild_help([H | SanctuaryList]) ->
	#sanctuary_msg{belong = BelongId, belong_name = GuildName, sanctuary_id = SanctuaryId} = H,
	if
		BelongId == 0 ->
			skip;
		true ->
			SanctuaryName = data_sanctuary:get_sanctuary_name(SanctuaryId),
			Title = utext:get(2830001),
			Content = utext:get(2830002, [GuildName, SanctuaryName]),
			mod_guild:send_guild_mail_by_guild_id(BelongId, Title, Content, [], [])
	end,
	send_sanctuary_belong_msg_to_guild_help(SanctuaryList).


%% 个人排行榜
do_result_guild_person_rank(State) ->
	#sanctuary_state{sanctuary_map = Map, designation_map = DesignationMap} = State,
	SanctuaryList = maps:values(Map),
	BelongSanctuaryList = [{SanctuaryId, Belong} || #sanctuary_msg{sanctuary_id = SanctuaryId, belong = Belong} <- SanctuaryList, Belong =/= 0],
%%	?MYLOG("cym", "DesignationMap ~p~nBelongSanctuarytList ~p~n", [DesignationMap, BelongSanctuaryList]),
	%%更新个人排行榜
	mod_guild:do_result_guild_person_rank(DesignationMap, BelongSanctuaryList).

%%更新称号信息
update_designation(DesignationMap, State) ->
    lib_sanctuary:db_save_designation_msg(DesignationMap),
    State#sanctuary_state{designation_map = DesignationMap}.

%%获取工会排行榜
get_guild_rank_info_with_guild_id(RoleId, GuildId, State) ->
    #sanctuary_state{designation_map = Map} = State,
    mod_guild:get_guild_rank_info_with_guild_id(RoleId, GuildId, Map).


get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId, State) ->
    #sanctuary_state{sanctuary_map = Map, last_time_designation = DesignationMap} = State,
    #sanctuary_msg{belong = BelongGuild} = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
    if
        BelongGuild == 0 ->
            {ok, Bin} = pt_283:write(28312, [SanctuaryId, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            DesList = maps:get(SanctuaryId, DesignationMap, []),
            ResList = [{Rank, RankName, Power, DesId} ||
                #sanctuary_not_change_designation{rank = Rank, role_name = RankName, power = Power, designation = DesId} <- DesList],
            % ?MYLOG("mlsanc","reslist: ~p~n", [ResList]),
            {ok, Bin} = pt_283:write(28312, [SanctuaryId, ResList]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end.


get_mon_kill_info(RoleId, SanctuaryId, BossId, State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    #sanctuary_msg{mon_msg = MonList} = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
    case lists:keyfind(BossId, #sanctuary_mon_msg.cfg_id, MonList) of
        #sanctuary_mon_msg{kill_log = _KillLogList} ->
            KillLogList = lists:sublist(_KillLogList, ?sanctuary_kill_log_len),
            PackList = [{Time, RoleName, IsShow, ReducePoint} ||
                #sanctuary_kill_log{time = Time, role_name = RoleName, is_show = IsShow, diff_point = ReducePoint} <- KillLogList];
        _ ->
            PackList = []
    end,
    % ?MYLOG("cym", "SanctuaryId ~p, BossId ~p, PackList~p~n", [SanctuaryId, BossId, PackList]),
    {ok, Bin} = pt_283:write(28311, [SanctuaryId, BossId, PackList]),
    lib_server_send:send_to_uid(RoleId, Bin).

%%怪物给攻击
mon_be_hurt(MonInfo, _RoleId, State) ->
    #scene_object{mon = Mon, scene = SceneId} = MonInfo,
    #scene_mon{mid = MonId, auto_lv = _MonLv} = Mon,
    IsSanctuaryScene = lib_sanctuary:is_sanctuary_scene(SceneId),
    if
        IsSanctuaryScene == true ->
            SanctuaryId = get_sanctuary_id_by_scene_id(SceneId),
            #sanctuary_state{sanctuary_map = Map} = State,
            Sanctuary = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
            #sanctuary_msg{belong = BelongGuildId, mon_msg = MonList} = Sanctuary,
            if
                BelongGuildId == 0 -> %% 没有归属
                    State;
                true ->
                    case lists:keyfind(MonId, #sanctuary_mon_msg.cfg_id, MonList) of
                        #sanctuary_mon_msg{remind_list = RemindList, remind_cd = CD} = MonMsg ->
                            Now = utime:unixtime(),
                            if
                                CD > Now -> %%cd没到
                                    State;
                                true ->
                                    [lib_sanctuary:mon_be_hurt_remind(RoleId1, SanctuaryId, MonId, BelongGuildId) || RoleId1 <- RemindList],
                                    CfgCd = data_sanctuary:get_kv(remind_cd),
                                    NewMonMsg = MonMsg#sanctuary_mon_msg{remind_cd = Now + CfgCd},
                                    NewMonList = lists:keystore(MonId, #sanctuary_mon_msg.cfg_id, MonList, NewMonMsg),
                                    NewSanctuary = Sanctuary#sanctuary_msg{mon_msg = NewMonList},
                                    NewMap = maps:put(SanctuaryId, NewSanctuary, Map),
                                    State#sanctuary_state{sanctuary_map = NewMap}
                            end;
                        _ ->
                            State
                    end
            end;
        true ->
            State
    end.

%%退出公会
quit_guild(RoleId, LeaveGuildId, State) ->
    #sanctuary_state{designation_map = DesMap, status = Status} = State,
    if
        Status == ?sanctuary_yet_over -> %%活动已经永久关闭
            State;
        true ->
            DesignationKeys = maps:keys(DesMap),
            case lists:keyfind(LeaveGuildId, 2, DesignationKeys) of
                {SanctuaryId, LeaveGuildId} ->
                    DesignationList = maps:get({SanctuaryId, LeaveGuildId}, DesMap),
                    case lists:keyfind(RoleId, #sanctuary_designation.role_id, DesignationList) of
                        #sanctuary_designation{designation = DesId} ->
                            lib_sanctuary:remove_designation_when_quit_guild(RoleId, DesId),
                            NewDesignationList = lists:keydelete(RoleId, #sanctuary_designation.role_id, DesignationList),
                            NewDesMap = maps:put({SanctuaryId, LeaveGuildId}, NewDesignationList, DesMap),
                            lib_sanctuary:db_save_designation_msg(NewDesMap),
                            State#sanctuary_state{designation_map = NewDesMap};
                        _ ->
                            State
                    end;
                _ -> %%没有称号的人
                    State
            end
    end.


update_not_change_designation(NotChangeDesignationMap, State) ->
    %%日志
    F = fun({SanctuaryId, List}) ->
        [lib_log_api:log_sanctuary_designation(SanctuaryId, GuildId, RoleId, DesId) ||
            #sanctuary_not_change_designation{role_id = RoleId, guild_id = GuildId, designation = DesId} <- List]
    end,
    lists:foreach(F, maps:to_list(NotChangeDesignationMap)),
    lib_sanctuary:db_save_last_time_designation(NotChangeDesignationMap),
    State#sanctuary_state{last_time_designation = NotChangeDesignationMap}.


%%公会内个人排行榜刷新时间下一个 整点 + 10秒
get_person_rank_refresh_time() ->
    {_, {H, _M, _S}} = calendar:local_time(),
    utime:unixdate() + (H + 1) * 60 * 60 + 10.


%%刷新公会内的个人排行榜
person_rank_refresh(#sanctuary_state{status = Status} = State) ->
    OpenDay = util:get_open_day(),
    {MinDay, MaxDay} = data_sanctuary:get_kv(open_day),
    {_, {H, _, _}} = calendar:local_time(),
    {EndH, _} = ?sanctuary_last_person_rank_time,
    %%先写 20点，需要热出去
    if
        MaxDay == OpenDay  andalso H == EndH->  %第4天 ，晚上8点最后一刷
            do_result_guild_person_rank(State),
            State;
        Status == ?sanctuary_yet_over ->
%%            ?MYLOG("cym", "person_rank_refresh   act over +++++++++++~n", []),
            State;
        true ->
%%            ?MYLOG("cym", "person_rank_refresh +++++++++++~n", []),
            {ResultH, _} = ?sanctuary_result_time,
            if
                ResultH == H ->   %%23点就不刷了,结算哪里会会刷
                    skip;
                true ->
                    if
                        OpenDay < MinDay orelse OpenDay > MaxDay -> %%开服天数不满足也不刷
                            skip;
                        true ->
                            do_result_guild_person_rank(State)
                    end
            end,
            #sanctuary_state{person_rank_ref = Ref} = State,
%%          Time = get_person_rank_refresh_time(),
            NewRef = util:send_after(Ref, ?person_rank_time * 1000, self(), {'person_rank_refresh'}),  %%
            State#sanctuary_state{person_rank_ref = NewRef}
    end.

get_sanctuary_info(State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    F = fun(#sanctuary_msg{sanctuary_id = Id, point = Point, belong = GId, belong_name = GName}, Acc) ->
        [{Id, Point, GId, GName} | Acc]
    end,
    lists:foldl(F, [], maps:values(Map)).

get_sanctuary_point_by_guild_id(GuildId, State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    List = maps:values(Map),
    case lists:keyfind(GuildId, #sanctuary_msg.belong, List) of
        #sanctuary_msg{point = Point} ->
            Point;
        _ ->
            0
    end.
%% return  1 有 | 0 没有
is_have_sanctuary_by_guild_id(GuildId, State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    List = maps:values(Map),
    case lists:keyfind(GuildId, #sanctuary_msg.belong, List) of
        #sanctuary_msg{} when GuildId =/= 0 ->
            1;
        _ ->
            0
    end.

get_last_settlement_msg(RoleId, GuildId, PersonRank, GuildIdRank, State) ->
    SanctuaryId = get_sanctuary_id_by_guild_id(GuildId, State),
    DesId = get_last_designation_id_by_role_id(RoleId, State, PersonRank),
%%  ?MYLOG("cym", "GuildIdRank ~p, SanctuaryId ~p, PersonRank ~p, DesId ~p", [GuildIdRank, SanctuaryId, PersonRank, DesId]),
    {ok, Bin} = pt_283:write(28314, [GuildIdRank, ?IF(GuildId == 0, 0, SanctuaryId), PersonRank, DesId]),
    lib_server_send:send_to_uid(RoleId, Bin).


get_sanctuary_id_by_guild_id(GuildId, State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    List = maps:values(Map),
    case lists:keyfind(GuildId, #sanctuary_msg.belong, List) of
        #sanctuary_msg{sanctuary_id = Id} ->
            Id;
        _ ->
            0
    end.
get_last_designation_id_by_role_id(_RoleId, _State, 0) ->
    0;
get_last_designation_id_by_role_id(RoleId, State, _PersonRank) ->
    #sanctuary_state{last_time_designation = Map} = State,
    List = lists:flatten(maps:values(Map)),
    case lists:keyfind(RoleId, #sanctuary_not_change_designation.role_id, List) of
        #sanctuary_not_change_designation{designation = Id} ->
            Id;
        _ ->
            0
    end.


join_guild(RoleId, GuildId, State) ->
    #sanctuary_state{last_time_guild_rank_list = List} = State,
    case lists:keyfind(GuildId, #last_guild_rank.guild_id, List) of
        #last_guild_rank{rank = Rank} ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, update_sanctuary_guild_rank, [GuildId, Rank]);
        _ ->
            skip
    end.

handle_activity([]) ->
    skip;
handle_activity(KillLogList) ->
%%  SortFun = fun(A, B) ->
%%      A#mon_atter.hurt >= B#mon_atter.hurt
%%  end,
%%  SortList = lists:sort(SortFun, KillLogList),
%%  #mon_atter{id = RoleId} = hd(SortList), 不用最高伤害，用参与
    [lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_SANCTUARY, ?sanctuary_act_sub_id) || #mon_atter{id = RoleId} <-KillLogList].

get_mon_xy(MonId) ->
%%  data_sanctuary:get_xy(MonId).
    case data_boss:get_boss_cfg(MonId) of
        #boss_cfg{x = X, y = Y} ->
            {X, Y};
        _ ->
            []
    end.

get_mon_reborn_time(MonCfgId) ->
%%  case data_sanctuary:get_reborn_time(MonCfgId) of
%%      [] ->
%%          [];
%%      Time ->
%%          {ok, Time}
%%  end.
    case data_boss:get_boss_cfg(MonCfgId) of
        #boss_cfg{reborn_time = Time} ->
            {ok, mod_boss:get_reborn_time(Time)};
        _ ->
            []
    end.


%% {true, subType} | false
is_act_open() ->
    OpenDay = util:get_open_day(),
    {MinDay, MaxDay} = data_sanctuary:get_kv(open_day),
    if
        OpenDay < MinDay orelse OpenDay > MaxDay ->
            false;
        true ->
            SubIdList = data_activitycalen:get_ac_sub(?MOD_SANCTUARY, ?sanctuary_act_sub_id),
            is_act_open(SubIdList)
    end.
is_act_open([]) ->
    false;
is_act_open([SubType | SubIdList]) ->
    case data_activitycalen:get_ac(?MOD_SANCTUARY, ?sanctuary_act_sub_id, SubType) of
        #base_ac{time_region = TimeList, open_day = OpenDayList} ->
            IsOpenDay = is_open_day(OpenDayList),
%%          ?MYLOG("cym", "IsOpenDay ~p~n", [IsOpenDay]),
            if
                IsOpenDay == true ->
                    case is_act_open_help(TimeList) of
                        true ->
                            {true, SubType};
                        false ->
                            is_act_open(SubIdList)
                    end;
                true ->
                    is_act_open(SubIdList)
            end;
        _ ->
            false
    end.
is_act_open_help([]) ->
    false;
is_act_open_help([{{H, M}, {EndH, EndM}} | TimeList]) ->
    Now = utime:unixtime(),
    Start = utime:unixdate() + H * 60 * 60 + M * 60,
    End =
        if
            H < EndH orelse (H == EndH andalso M < EndM) ->
                utime:unixdate() + EndH * 60 * 60 + EndM * 60;
            true -> %% 跨天了
                utime:unixdate() + EndH * 60 * 60 + EndM * 60 + ?ONE_DAY_SECONDS
        end,
    if
        Now >= Start andalso Now =< End ->  %% 活动期间内
            true;
        true ->
            is_act_open_help(TimeList)
    end.

is_open_day([]) ->
    false;
is_open_day([{MinDay, MaxDay} | List]) ->
    OpenDay = util:get_open_day(),
    if
        OpenDay >= MinDay andalso OpenDay =< MaxDay ->
            true;
        true ->
            is_open_day(List)
    end.



timer_repair(State) ->
    #sanctuary_state{result_ref = Ref} = State,
    {Time, NewRef} = send_result(Ref),
%%    ?MYLOG("cym", "Time ~p~n", [Time]),
    State#sanctuary_state{result_time = Time, result_ref = NewRef}.


merge_handle(State) ->
    mod_common_rank:merge_sanctuary_do_result(),  %%合服
    State.