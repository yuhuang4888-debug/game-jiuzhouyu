%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_kf_1vN.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 1vn挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_kf_1vN).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("kf_1vN.hrl").
-compile(export_all).


-record(fc_kf_1vN, {
		module_id = 0             
        , sub_module = 0                  
        , behaviour_list = []
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	FCkf1vN = #fc_kf_1vN{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = SubBehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCkf1vN},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	pp_kf_1vN:handle(62103, PS, []),
	%?MYLOG("lxl_activity", "1vn enter_activity  ~n", []),
	PS.

enter_activity_result(PS, Code) ->
	#player_status{id = RoleId, fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubMod}} = PS,
	%?MYLOG("lxl_activity", "1vn enter_activity_result  ~p~n", [Code]),
	case Code == ?SUCCESS of 
		true -> %% 成功进入
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			PS;
		_ -> %% 进入活动，取消挂机
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, Code),
			lib_fake_client:close_fake_client(PS, enter_fail),
			PS
	end.

close_fake_client(PS, _Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_kf_1vN{ref = OldRef} -> 
			util:cancel_timer(OldRef),
			%?MYLOG("lxl_activity", "1vn close_fake_client ok ~n", []),
			PS#player_status{fake_client = FakeClient#fake_client{module_data = undefined}};
		_ -> PS
	end.

war_stage(PS, Stage) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod} = FakeClient,
	case Stage == ?KF_1VN_END of 
		true -> %% 结束挂机
			%?MYLOG("lxl_activity", "1vn war_stage  end onhook ~n", []),
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
			lib_fake_client:close_fake_client(PS),
			PS;
		_ ->
			PS
	end.
	

%% 获取复活:不复活
get_revive_type_and_time(_PS) ->
	false.

%% 是否需要寻找攻击目标
need_find_target(PS) ->
	case PS#player_status.scene == data_kf_1vN_m:get_config(race_1_pre_scene) of
		true -> false;
		_ -> true
	end.