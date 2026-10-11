%%%--------------------------------------
%%% @Module  : lib_baby_api
%%% @Author  : lxl
%%% @Created : 2019.5.9
%%% @Description:  宝宝
%%%--------------------------------------

-module (lib_baby_api).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("marriage.hrl").
-include("figure.hrl").
-include("rec_baby.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("team.hrl").
-include("dungeon.hrl").
-export ([

]).   

-compile(export_all). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 宝宝任务触发
%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
    #callback_dungeon_succ{help_type=HelpType, dun_type = DunType} = Data,
    case lists:member(DunType, [?DUNGEON_TYPE_COUPLE]) of  %% 需要通关才加次数的副本
    	true ->
		    if
		        HelpType == ?HELP_TYPE_NO ->
		            TaskList = data_baby_new:get_task_by_mod_id(?MOD_DUNGEON),
		            [trigger_task(PS, TaskId, 1) || {TaskId, _, SubMod, OpenLv} <- TaskList, SubMod == DunType, Lv >= OpenLv],
		            ok;
		        true -> 
		            ok
		    end;
		_ -> 
			ok
    end,
    {ok, PS};
handle_event(PS, _) ->
	{ok, PS}.

%% 参与副本
join_dungeon(RoleKey, DunType) ->
	join_dungeon(RoleKey, DunType, 1).


join_dungeon(RoleId, DunType, Count) when is_integer(RoleId) ->
	case lists:member(DunType, [?DUNGEON_TYPE_EQUIP, ?DUNGEON_TYPE_DRAGON]) of  %% 只要参与就加次数的副本
		true ->
			case lib_player:get_alive_pid(RoleId) of 
				false ->
					TaskList = data_baby_new:get_task_by_mod_id(?MOD_DUNGEON),
					[mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, Count]}) || {TaskId, _, SubMod, _OpenLv} <- TaskList, SubMod == DunType],
					ok;
				Pid ->	
					lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, join_dungeon, [DunType, Count])
			end;
		_ ->
			ok
	end;
join_dungeon(PS, DunType, Count) ->
	case lists:member(DunType, [?DUNGEON_TYPE_EQUIP, ?DUNGEON_TYPE_DRAGON]) of  %% 只要参与就加次数的副本
		true ->
			#player_status{figure = #figure{lv = Lv}} = PS,
			TaskList = data_baby_new:get_task_by_mod_id(?MOD_DUNGEON),
			[trigger_task(PS, TaskId, Count) || {TaskId, _, SubMod, OpenLv} <- TaskList, SubMod == DunType, Lv >= OpenLv],
			{ok, PS};
		_ ->
			{ok, PS}
	end.

%% 击杀boss
boss_be_kill(RoleId, BossType, _BossId) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false ->
			TaskList = data_baby_new:get_task_by_mod_id(?MOD_BOSS),
			[mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, 1]}) || {TaskId, _, SubMod, _OpenLv} <- TaskList, SubMod == BossType],
			ok;
		Pid ->	
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, boss_be_kill, [BossType, _BossId])
	end;
boss_be_kill(PS, BossType, _BossId)	->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_BOSS),
	[trigger_task(PS, TaskId, 1) || {TaskId, _, SubMod, OpenLv} <- TaskList, SubMod == BossType, Lv >= OpenLv],
	{ok, PS}.

%% 完成任务
finish_task(PS, TaskType) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_TASK),
    [trigger_task(PS, TaskId, 1) || {TaskId, _, SubMod, OpenLv} <- TaskList, SubMod == TaskType, Lv >= OpenLv],
    ok.

%% 完成扫荡赏金任务
finish_sweep_bounty_task(PS, TaskType, LeftTaskCount) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_TASK),
    [trigger_task(PS, TaskId, LeftTaskCount) || {TaskId, _, SubMod, OpenLv} <- TaskList, SubMod == TaskType, Lv >= OpenLv],
    ok.

%% 参加九天争霸
join_nine(RoleId) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false ->
			TaskList = data_baby_new:get_task_by_mod_id(?MOD_NINE),
			[mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, 1]}) || {TaskId, _, _SubMod, _OpenLv} <- TaskList],
			ok;
		Pid ->	
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, join_nine, [])
	end;
join_nine(PS) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_NINE),
	[trigger_task(PS, TaskId, 1) || {TaskId, _, _SubMod, OpenLv} <- TaskList, Lv >= OpenLv],
	{ok, PS}.

%% 增加活跃度
add_liveness(RoleId, Add) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false ->
			TaskList = data_baby_new:get_task_by_mod_id(?MOD_ACTIVITY),
			[mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, Add]}) || {TaskId, _, _SubMod, _OpenLv} <- TaskList],
			ok;
		Pid ->	
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, add_liveness, [Add])
	end;
add_liveness(PS, Add) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_ACTIVITY),
	[trigger_task(PS, TaskId, Add) || {TaskId, _, _SubMod, OpenLv} <- TaskList, Lv >= OpenLv],
	{ok, PS}.

%% 完成护送
fin_husong(PS) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_HUSONG),
	[trigger_task(PS, TaskId, 1) || {TaskId, _, _SubMod, OpenLv} <- TaskList, Lv >= OpenLv],
	ok.

%% 参加竞技场
join_jjc(RoleId, Add) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false ->
			TaskList = data_baby_new:get_task_by_mod_id(?MOD_JJC),
			[mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, Add]}) || {TaskId, _, _SubMod, _OpenLv} <- TaskList],
			ok;
		Pid ->	
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, join_jjc, [Add])
	end;
join_jjc(PS, Add) ->
	#player_status{figure = #figure{lv = Lv}} = PS,
	TaskList = data_baby_new:get_task_by_mod_id(?MOD_JJC),
	[trigger_task(PS, TaskId, Add) || {TaskId, _, _SubMod, OpenLv} <- TaskList, Lv >= OpenLv],
	{ok, PS}.

trigger_task(PS, TaskId, Num) ->
	%?PRINT("trigger_task ## ~p~n", [{TaskId, Num}]),
	#player_status{id = RoleId, status_baby = #status_baby{active_time = ActiveTime}} = PS,
	case ActiveTime > 0 of 
		true ->
			mod_baby_mgr:cast({trigger_task, [RoleId, TaskId, Num]});
		_ ->
			ok
	end.

%% 宝宝激活
active_baby(RoleId, RoleLv, ActiveTime) ->
	mod_baby_mgr:cast({active_baby, [RoleId, RoleLv]}),
	lib_baby:ets_update(RoleId, [{#baby_basic.active_time, ActiveTime}]),
	ok.

%% 宝宝养育升级
baby_raise_up(PS, OldRaiseLv) ->
	#player_status{id = RoleId, marriage = #marriage_status{lover_role_id = LoverId}, status_baby = StatusBaby} = PS,
	#status_baby{raise_lv = RaiseLv} = StatusBaby,
	lib_baby:ets_update(RoleId, [{#baby_basic.raise_lv, RaiseLv}]),
	case LoverId > 0 andalso lib_baby:is_trigger_mate_attr(?ATTR_TYPE_RAISE, [OldRaiseLv, RaiseLv]) == true of
		true ->
			BabyBasic = lib_baby:trans_to_baby_basic(RoleId, StatusBaby),
	 		lib_player:apply_cast(LoverId, ?APPLY_CAST_STATUS, lib_baby, update_power_with_mate_baby, [BabyBasic]);
	 	_ -> skip
	end,
	ok.

%% 宝宝升阶
baby_stage_up(PS, OldStage, OldStageLv) ->
	#player_status{id = RoleId, marriage = #marriage_status{lover_role_id = LoverId}, status_baby = StatusBaby} = PS,
	#status_baby{stage = Stage, stage_lv = StageLv} = StatusBaby,
	lib_baby:ets_update(RoleId, [{#baby_basic.stage, Stage}, {#baby_basic.stage_lv, StageLv}]),
	case LoverId > 0 andalso lib_baby:is_trigger_mate_attr(?ATTR_TYPE_STAGE, [OldStage, OldStageLv, Stage, StageLv]) == true of
		true ->
			BabyBasic = lib_baby:trans_to_baby_basic(RoleId, StatusBaby),
	 		lib_player:apply_cast(LoverId, ?APPLY_CAST_STATUS, lib_baby, update_power_with_mate_baby, [BabyBasic]);
	 	_ -> skip
	end,
	ok.

%% 宝宝特长更新
baby_equip_update(PS) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{equip_list = EquipList} = StatusBaby,
	lib_baby:ets_update(RoleId, [{#baby_basic.equip_list, EquipList}]),
	ok.

%% 激活宝宝形象
active_baby_figure(PS, _BabyId) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{active_list = ActiveList} = StatusBaby,
	lib_baby:ets_update(RoleId, [{#baby_basic.active_list, ActiveList}]),
	ok.

%% ---------------------------秘籍----------------------------------
%% 修复宝宝养育值数据
gm_add_raise_af_sweep_bounty_task() ->
	%% 查询出所有需要处理的玩家
	UpdateTime = utime:unixtime({{2019, 12, 17}, {17, 23, 09}}),
	Sql = io_lib:format(<<"select role_id, count from `log_sweep_bounty_task` where time <= ~w">>, [
		UpdateTime]),
	FinishList = db:get_all(Sql),
	FinishList2 = [{Rid, Count} || [Rid, Count] <- FinishList],
	%% 获取在线的玩家列表，逐个处理
	OnlineList = ets:tab2list(?ETS_ONLINE),
	RoleIdList = [RoleId || #ets_online{id = RoleId} <- OnlineList],
	spawn(fun() -> gm_add_raise_af_sweep_bounty_task_helper(FinishList2, RoleIdList ) end).
	
gm_add_raise_af_sweep_bounty_task_helper(FinishList2, RoleIdList) ->
	%% 休眠0.5秒
	timer:sleep(500),
	F = fun(Id) ->
			case lists:keyfind(Id, 1, FinishList2) of
				false -> skip;
				{_, Count} ->
					%% 更新
					lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_baby_api, finish_sweep_bounty_task, [7, Count])
			end
	end,
	lists:map(F, RoleIdList).