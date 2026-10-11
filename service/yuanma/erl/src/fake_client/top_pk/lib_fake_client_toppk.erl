%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_toppk.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 巅峰竞技挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_toppk).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("def_fun.hrl").
-compile(export_all).

-record(fc_toppk, {
		module_id = 0             
        , sub_module = 0      
        , enter_cnt = 0
        , end_fight = 0           
        , behaviour_list = []
        , ref = undefined             %% 功能行为定时器
    }).

-record(fc_toppk_behaviour, {
		behaviour_id = 0
		, is_done = 0
		, times = 0
    }).

init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod, sub_behaviour_list = SubBehaviourList} = OnhookModule,
	BehaviourList = change_fc_toppk_behaviour(SubBehaviourList),
	FCToppk = #fc_toppk{
		module_id = ModuleId, sub_module = SubMod, behaviour_list = BehaviourList
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCToppk},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	%% 先切一次场景，回到野外先
	PS1 = lib_scene:change_relogin_scene(PS, []),
	%% 发匹配协议，匹配失败后停止挂机
	PS2 = go_match(PS1),
	%% 2s后执行toppk的行为
	Ref = util:send_after([], 2000, PS#player_status.pid, {'mod', ?MODULE, behaviour, []}),
	PS2#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_toppk{ref = Ref}}}.

%% 收到结束战斗通知
end_fight(PS, _Res, _Honor, _Flag, _Point) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	PS1 = PS#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_toppk{end_fight = 1}}},
	%?MYLOG("lxl_activity", "toppk end_fight    ~n", []),
	case lib_top_pk:is_in_top_pk_scene(PS1) == false of 
		true -> %% 已经收到结束战斗通知，并且不处于战斗场景，继续匹配
			go_match(PS1);
		_ ->
			PS1
	end.

load_scene_success(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_toppk{end_fight = EndFight} -> ok;
		_ -> EndFight = 0
	end,
	%?MYLOG("lxl_activity", "toppk load_scene_success: ~p   ~n", [PS#player_status.scene]),
	case EndFight == 1 andalso lib_top_pk:is_in_top_pk_scene(PS) == false of 
		true -> %% 已经收到结束战斗通知，并且不处于战斗场景，继续匹配
			go_match(PS);
		_ ->
			PS
	end.

go_match(PS) ->
	%?MYLOG("lxl_activity", "toppk go_match    ~n", []),
	case pp_top_pk:handle(28110, PS, []) of 
		{ok, PS1} -> 
			PS1;
		_ -> PS1 = PS
	end,
	PS1.

match_result(PS, Code) ->
	#player_status{
		id = RoleId, fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient
	} = PS,
	%?MYLOG("lxl_activity", "toppk match_result  Code:~p  ~n", [Code]),
	case Code == ?SUCCESS of 
		true -> %% 匹配成功
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			PS#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_toppk{end_fight = 0, enter_cnt = 1}}};
		_ -> %% 匹配失败，取消挂机
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, Code),
			Msg = ?IF(ModuleData#fc_toppk.enter_cnt == 0, enter_fail, undefined),
			lib_fake_client:close_fake_client(PS, Msg),
			PS
	end.

close_fake_client(PS, _Msg) ->
	%?MYLOG("lxl_activity", "toppk close_fake_client    ~n", []),
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	%% 清理巅峰竞技的状态
	case pp_top_pk:handle(28116, PS, []) of 
		{ok, PS1} -> ok; _ -> PS1 = PS
	end,
	case pp_top_pk:handle(28114, PS1, []) of 
		{ok, PS2} -> ok; _ -> PS2 = PS1
	end, 
	case ModuleData of 
		#fc_toppk{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS2#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.

behaviour(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_toppk{module_id = ModuleId, sub_module = SubMod, behaviour_list = BehaviourList} ->
			PS1 = do_behaviour(PS, ModuleId, SubMod, BehaviourList),
			{ok, PS1};
		_ ->
			{ok, PS}
	end.

do_behaviour(PS, _ModuleId, _SubMod, []) -> PS;
do_behaviour(PS, ModuleId, SubMod, [Behaviour|L]) ->
	#fc_toppk_behaviour{behaviour_id = BehaviourId, is_done = IsDone, times = Times} = Behaviour,
	case IsDone == 1 of
		true -> do_behaviour(PS, ModuleId, SubMod, L);
		_ ->
			% 特殊处理下巅峰竞技
			SubBehavior = lib_activity_onhook:prase_activity_behaviour(ModuleId, SubMod, BehaviourId),
			SubBehaviourList = [{SubBehavior, Times}],
			case do_sub_behaviour(SubBehaviourList, PS) of
				{ok, PS1} -> PS1;
				{next, PS1} -> %%
					#fake_client{module_data = ModuleData} = FakeClient = PS1#player_status.fake_client,
					#fc_toppk{behaviour_list = OldBehaviourList, ref = OldRef} = ModuleData,
					NewBehavior = Behaviour#fc_toppk_behaviour{is_done = 1},
					NewBehaviourList = lists:keystore(BehaviourId, #fc_toppk_behaviour.behaviour_id, OldBehaviourList, NewBehavior),
					Ref = util:send_after(OldRef, urand:rand(2000, 3000), PS#player_status.pid, {'mod', ?MODULE, behaviour, []}), 
					ModuleData1 = ModuleData#fc_toppk{behaviour_list = NewBehaviourList, ref = Ref},
					PS2 = PS1#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData1}},
					PS2
			end
	end.

do_sub_behaviour([], PS) -> {next, PS};
do_sub_behaviour([{buy_cnt, BuyCnt}|SubBehaviourList], PS) when BuyCnt > 0 ->
	%?MYLOG("lxl_activity", "toppk buy_cnt :  ~p~n", [BuyCnt]),
	Price = data_top_pk:get_kv(default, buy_cost),
	CostPrice = BuyCnt * Price,
	if
		PS#player_status.bgold >= CostPrice ->
			Count = BuyCnt;
		PS#player_status.bgold > Price ->
			Count = PS#player_status.bgold div Price;
		true ->
			Count = 0
	end,
	% 绑钻不够会消耗钻石，避免这种情况
	case Count > 0 of
		true ->
			case pp_top_pk:handle(28104, PS, [Count]) of
				{ok, PS1} -> %% 购买成功
					%?MYLOG("lxl_activity", "toppk buy_cnt succ :  ~p~n", [BuyCnt]),
					do_sub_behaviour(SubBehaviourList, PS1);
				_ -> %% 购买失败，不再购买
					do_sub_behaviour(SubBehaviourList, PS)
			end;
		_ -> do_sub_behaviour(SubBehaviourList, PS)
	end;
do_sub_behaviour([_|SubBehaviourList], PS) ->
	do_sub_behaviour(SubBehaviourList, PS).

change_fc_toppk_behaviour(SubBehaviourList) ->
	F = fun(SubBehaviour, Acc) ->
		#sub_behaviour{behaviour_id = BehaviourId, times = Times} = SubBehaviour,
		[#fc_toppk_behaviour{behaviour_id = BehaviourId, times = Times}|Acc]
	end,
	lists:foldl(F, [], SubBehaviourList).

%% 是否需要寻找攻击目标
need_find_target(PS) ->
	case lib_top_pk:is_in_top_pk_scene(PS) of
		true -> true;
		_ -> false
	end.