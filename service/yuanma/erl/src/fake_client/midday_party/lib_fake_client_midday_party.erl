%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_midday_party.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 午间派对挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_midday_party).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-compile(export_all).

-record(fc_midday_party, {
		module_id = 0             
        , sub_module = 0                  
        , behaviour_list = []
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	FCMiddayParty = #fc_midday_party{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = SubBehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCMiddayParty},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	case pp_midday_party:handle(28501, PS, []) of 
		{ok, NewPS} -> NewPS;
		_ -> PS
	end.

enter_activity_result(PS, Code) ->
	#player_status{id = RoleId, fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubMod}} = PS,
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
	case _Msg of 
		relogin -> PS1 = PS;
		_ ->
			case pp_midday_party:handle(28502, PS, []) of 
				{ok, PS1} -> ok; _ -> PS1 = PS
			end
	end,
	case ModuleData of 
		#fc_midday_party{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS1#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.
