%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_nine.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 九魂圣殿挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_nine).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-compile(export_all).

-record(fake_nine_war, {
		module_id = 0             
        , sub_module = 0                  
        , behaviour_list = []
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	FakeNineWar = #fake_nine_war{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = SubBehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FakeNineWar},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	{ok, NewPS} = pp_nine:handle(13502, PS, []),
	NewPS.

enter_activity_result(PS, Code) ->
	#player_status{id = RoleId, fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubMod}} = PS,
	%?MYLOG("lxl_activity", "nine_war enter_activity_result  ~p~n", [Code]),
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
	%?MYLOG("lxl_activity", "nine_war close_fake_client  ~p~n", [_Msg]),
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	% case _Msg of 
	% 	relogin -> PS1 = PS;
	% 	_ ->
	% 		{ok, PS1} = lib_nine:quit(PS)
	% end,
	{ok, PS1} = lib_nine:quit(PS),
	case ModuleData of 
		#fake_nine_war{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS1#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.

get_loop_block_xy(_FakeClient, _SceneId, _CopyId, X, Y) ->
	F = fun({TX, TY}, {X1, Y1, Dis}) ->
		SimDis = abs(X - TX) + abs(Y - TY),
		case Dis == false orelse SimDis < Dis of 
			true ->  {TX, TY, SimDis};
			_ -> {X1, Y1, Dis}
		end
	end,
	{LastX, LastY, _} = lists:foldl(F, {X, Y, false}, [{2504,3891}, {2530,3840},{4103,5384},{5390,5000},{5661,3866},{5470,2420},{4077,2303},{2740,2390}]),
	{LastX, LastY}.

