%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_drumwar.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 钻石大战挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_drumwar).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-compile(export_all).


-record(fc_drumwar, {
		module_id = 0             
        , sub_module = 0                  
        , behaviour_list = []
        , left_live = 1
        , is_over = 0                %% 已结束比赛(输比赛或者已经决出冠军)
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	FCDrumWar = #fc_drumwar{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = SubBehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCDrumWar},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	{ok, NewPS} = pp_drum:handle(13704, PS, []),
	%?MYLOG("lxl_activity", "drum_war enter_activity  ~n", []),
	NewPS.

enter_activity_result(PS, Code) ->
	#player_status{id = RoleId, fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubMod}} = PS,
	%?MYLOG("lxl_activity", "drum_war enter_activity_result  ~p~n", [Code]),
	case Code == ?SUCCESS of 
		true -> %% 成功进入
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			PS;
		_ -> %% 进入活动，取消挂机
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, Code),
			lib_fake_client:close_fake_client(PS, enter_fail),
			PS
	end.

set_left_live(PS, SelfLife) ->
	%?MYLOG("lxl_activity", "drum_war set_left_live SelfLife:~p ~n", [SelfLife]),
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_drumwar{} -> 
			NewModuleData = ModuleData#fc_drumwar{left_live = SelfLife},
			PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}};
		_ -> PS
	end.

close_fake_client(PS, _Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_drumwar{ref = OldRef} -> 
			util:cancel_timer(OldRef),
			%?MYLOG("lxl_activity", "drum_war close_fake_client ok ~n", []),
			PS#player_status{fake_client = FakeClient#fake_client{module_data = undefined}};
		_ -> PS
	end.

%% 比赛结果返回
match_settlement(PS, Settlement, Result, _ActionId) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient,
	InReadyScene = lib_role_drum:is_in_drumready(PS),
	IsOver = ?IF(Settlement == 1 andalso (Result == 2 orelse Result == 6 orelse Result == 5), 1, 0),
	case IsOver == 1 andalso is_record(ModuleData, fc_drumwar) of 
		true -> 
			PS1 = PS#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_drumwar{is_over = IsOver}}};
		_ -> PS1 = PS
	end,
	case IsOver == 1 andalso InReadyScene of 
		true -> %% 结束挂机
			%?MYLOG("lxl_activity", "drum_war match_settlement  end onhook ~n", []),
			{_, PS2} = pp_drum:handle(13707, PS1, [0]),
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
			lib_fake_client:close_fake_client(PS2),
			PS2;
		_ ->
			PS1
	end.

%% 成功加载场景
%% 如果玩家输掉比赛，并且切回到准备场景，结束挂机
load_scene_success(PS) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient,
	InReadyScene = lib_role_drum:is_in_drumready(PS),
	case ModuleData of 
		#fc_drumwar{is_over = 1} when InReadyScene -> %% 结束挂机
			%?MYLOG("lxl_activity", "drum_war load_scene_success  end onhook ~n", []),
			{_, PS1} = pp_drum:handle(13707, PS, [0]),
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
			lib_fake_client:close_fake_client(PS1),
			PS1;
		_ -> PS
	end.

%% 获取复活
%% 命数为1时，死亡就不会进行复活
get_revive_type_and_time(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_drumwar{left_live = SelfLife} -> 
			case SelfLife =< 1 of 
				true -> %% 只剩一条命，并且死亡了，不复活
					false;
				_ ->
					{?REVIVE_DRUMWAR, 1000}
			end;
		_ -> {?REVIVE_INPLACE, 5000}
	end.

%% 是否需要寻找攻击目标
need_find_target(PS) ->
	case lib_role_drum:is_in_drumready(PS) of
		true -> false;
		_ -> true
	end.