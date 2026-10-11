%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_gfeast.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 公会晚宴挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_gfeast).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-compile(export_all).

-record(fc_gfeast, {
		module_id = 0             
        , sub_module = 0                  
        , behaviour_list = []
        , ref = undefined             %% 功能行为定时器
    }).

-record(fc_gfeast_behaviour, {
		behaviour_id = 0
		, is_done = 0
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	BehaviourList = change_fc_gfeast_behaviour(SubBehaviourList),
	FakeGFeast = #fc_gfeast{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = BehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FakeGFeast},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	pp_guild_act:handle(40212, PS, []),
	PS.

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
		relogin -> %% 重登不离开
			ok;
		_ -> 
			pp_guild_act:handle(40218, PS, [])
	end,
	case ModuleData of 
		#fc_gfeast{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.

%% 加载场景成功，完成活动的行为列表
load_scene_success(PS) ->
	{ok, PS1} = behaviour(PS),
	PS1.

behaviour(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_gfeast{module_id = ModuleId, sub_module = SubMod, behaviour_list = BehaviourList} ->
			PS1 = do_behaviour(PS, ModuleId, SubMod, BehaviourList),
			{ok, PS1};
		_ ->
			{ok, PS}
	end.

do_behaviour(PS, _ModuleId, _SubMod, []) -> PS;
do_behaviour(PS, ModuleId, SubMod, [Behaviour|L]) ->
	#fc_gfeast_behaviour{behaviour_id = BehaviourId, is_done = IsDone} = Behaviour,
	case IsDone == 1 of 
		true -> do_behaviour(PS, ModuleId, SubMod, L);
		_ ->
			SubBehaviourList = lib_activity_onhook:prase_activity_behaviour(ModuleId, SubMod, BehaviourId),
			case do_sub_behaviour(SubBehaviourList, PS) of
				{ok, PS1} -> PS1;
				{next, PS1} -> %%
					#fake_client{module_data = ModuleData} = FakeClient = PS1#player_status.fake_client,
					#fc_gfeast{behaviour_list = OldBehaviourList, ref = OldRef} = ModuleData,
					NewBehavior = Behaviour#fc_gfeast_behaviour{is_done = 1},
					NewBehaviourList = lists:keystore(BehaviourId, #fc_gfeast_behaviour.behaviour_id, OldBehaviourList, NewBehavior),
					Ref = util:send_after(OldRef, urand:rand(2000, 3000), PS#player_status.pid, {'mod', ?MODULE, behaviour, []}), 
					ModuleData1 = ModuleData#fc_gfeast{behaviour_list = NewBehaviourList, ref = Ref},
					PS2 = PS1#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData1}},
					PS2
			end
	end.

do_sub_behaviour([], PS) -> {next, PS};
do_sub_behaviour([{buy_food, FoodType, BuyCnt}|SubBehaviourList], PS) when BuyCnt > 0 ->
	% 不允许通过消耗绑玉去消耗勾玉
	CostCfg = data_guild_feast:get_cfg(food_cost),
	case lists:keyfind(FoodType, 1, CostCfg) of
		{_, [{?TYPE_BGOLD, _, Num}|_], _} ->
			CanDo = PS#player_status.bgold >= Num;
		_ ->
			CanDo = true
	end,
	case CanDo of
		true ->
			case pp_guild_act:handle(40264, PS, [FoodType]) of
				{ok, PS1} -> %% 购买成功
					%?MYLOG("lxl_activity", "gfeast buy food :  ~p~n", [FoodType]),
					do_sub_behaviour([{buy_food, FoodType, BuyCnt-1}|SubBehaviourList], PS1);
				_ -> %% 购买失败，不再购买
					do_sub_behaviour(SubBehaviourList, PS)
			end;
		_ -> do_sub_behaviour(SubBehaviourList, PS)
	end;
do_sub_behaviour([_|SubBehaviourList], PS) ->
	do_sub_behaviour(SubBehaviourList, PS).

change_fc_gfeast_behaviour(SubBehaviourList) ->
	F = fun(SubBehaviour, Acc) ->
		#sub_behaviour{behaviour_id = BehaviourId} = SubBehaviour,
		[#fc_gfeast_behaviour{behaviour_id = BehaviourId}|Acc]
	end,
	lists:foldl(F, [], SubBehaviourList).