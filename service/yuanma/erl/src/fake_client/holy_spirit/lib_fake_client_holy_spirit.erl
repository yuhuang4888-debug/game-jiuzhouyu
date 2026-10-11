%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_holy_spirit.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 圣灵战场挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_holy_spirit).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-compile(export_all).

-record(fc_holy_spirit, {
		module_id = 0             
        , sub_module = 0   
        , anger = 0
        , mon_list = []               %% 怪物列表
        , behaviour_list = [] 
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod} = OnhookModule,
	FCHolySpirit = #fc_holy_spirit{
		module_id = ModuleId, sub_module = SubMod
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCHolySpirit},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	%?MYLOG("lxl_activity", "holy_spirit enter_activity ~n", []),
	pp_holy_spirit_battlefield:do_handle(21802, PS, []),
	PS.

enter_activity_result(PS, Code) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod} = FakeClient,
	%?MYLOG("lxl_activity", "holy_spirit enter_activity_result : ~p~n", [{Code}]),
	case Code == ?SUCCESS of 
		true -> %% 成功进入
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			PS;
		_ -> %% 进入活动失败，取消挂机
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
			pp_holy_spirit_battlefield:do_handle(21803, PS, [])
	end,
	case ModuleData of 
		#fc_holy_spirit{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.

%% 加载场景后请求一些必要的协议
load_scene_success(PS) ->
	#player_status{scene = Scene} = PS,
	case lib_holy_spirit_battlefield:is_pk_scene(Scene) of 
		true ->
			pp_holy_spirit_battlefield:do_handle(21813, PS, []),
			PS;
		_ ->
			PS
	end.

select_a_skill(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData#fc_holy_spirit.anger >= data_holy_spirit_battlefield:get_kv(max_anger) of 
		true -> 
			{data_holy_spirit_battlefield:get_kv(anger_skill), 1};
		_ -> false
	end.

use_skill_succ(PS, SkillId) ->
	case data_holy_spirit_battlefield:get_kv(anger_skill) == SkillId of 
		true ->
			#player_status{id = RoleId, server_id = ServerId, fake_client = FakeClient} = PS,
			#fake_client{module_data = ModuleData} = FakeClient,
			NewModuleData = ModuleData#fc_holy_spirit{anger = 0},
			lib_holy_spirit_battlefield:user_anger_skill(ServerId, RoleId),
			PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}};
		_ ->
			PS
	end.

update_anger(PS, Anger) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	NewModuleData = ModuleData#fc_holy_spirit{anger = Anger},
	PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}}.


mon_list(PS, MonList) ->
	#player_status{fake_client = FakeClient, battle_attr = BA} = PS,
	#fake_client{att_target = AttTarget, module_data = ModuleData} = FakeClient,
	#battle_attr{group = RoleGroup} = BA,
	OldMonList = ModuleData#fc_holy_spirit.mon_list,
	NewMonList = update_mon_list(MonList, OldMonList),
	NewModuleData = ModuleData#fc_holy_spirit{mon_list = NewMonList},
	case AttTarget of 
		#att_target{key = Key, id = OldTId} when Key == object orelse Key == module_object -> %% 判断一下原攻击目标是否已经死亡 
		 	NeedBreakBattle = (lists:keymember(OldTId, 1, NewMonList) == false) ;
		#att_target{key = user} ->
			NeedBreakBattle = ( [1 ||{_Id, _MonId, _Hp, _HPAll, MonGroup} <- NewMonList, MonGroup =/= RoleGroup] =/= [] );
		_ ->
			NeedBreakBattle = false
	end,
	PS1 = PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}},
	case NeedBreakBattle of 
		true ->
			case lib_fake_client:get_onhook_type() of
				?ON_HOOK_BEHAVIOR ->
					PS1;
				_ ->
					lib_fake_client_battle:break_battle(PS1)
			end;
		_ -> PS1
	end.

update_mon_list(MonList, OldMonList) ->
	case MonList of 
		[{0, MonId, _, _, _}] -> %% 怪物死亡时，这个列表只有一条数据
			lists:keydelete(MonId, 2, OldMonList);
		_ -> MonList
	end.

%% 是否需要寻找攻击目标
need_find_target(PS) ->
	#player_status{scene = Scene} = PS,
	case lib_holy_spirit_battlefield:is_wait_scene(Scene) of
		true -> false;
		_ -> 
			#player_status{fake_client = FakeClient} = PS,
			#fake_client{att_target = AttTarget, module_data = ModuleData} = FakeClient,
			case AttTarget of 
				#att_target{key = module_object, id = TId} ->
					case lists:keymember(TId, 1, ModuleData#fc_holy_spirit.mon_list) of 
						true -> false; _ -> true
					end;
				_ -> true
			end
	end.

%% 场景那边已经找不到攻击目标，来功能这边寻找目标
find_target_in_module(PS, _Type) ->
	#player_status{x = X, y = Y, battle_attr = BA, fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	#battle_attr{group = RoleGroup} = BA,
	case ModuleData of 
		#fc_holy_spirit{mon_list = MonList} -> 
			F = fun({TId, MonId, _, _, MonGroup}, {Target, Dis}) ->
				case MonGroup == RoleGroup of 
					true -> {Target, Dis};
					_ ->
						case get_mon_xy(MonId) of 
							false -> {Target, Dis};
							{TX, TY} ->
								SimDis = abs(X - TX) + abs(Y - TY),
								case Dis == false orelse SimDis < Dis of 
									true -> 
										{#att_target{key = module_object, id = TId, mon_id = MonId, x = TX, y = TY}, SimDis};
									_ -> {Target, Dis}
								end
						end
				end
			end,
			{Target, _} = lists:foldl(F, {false, false}, MonList),
			Target;
		_ ->
			false
	end.

get_mon_xy(MonId) ->
	TowerList = data_holy_spirit_battlefield:get_kv(tower_list),
	get_mon_xy(TowerList, MonId).

get_mon_xy([], _MonId) -> false;
get_mon_xy([{SubList, X, Y}|TowerList], MonId) ->
	case lists:keyfind(MonId, 2, SubList) of 
		false ->
			get_mon_xy(TowerList, MonId);
		_ ->
			{X, Y}
	end.

%% 取周围8个点
get_loop_block_xy(FakeClient, SceneId, CopyId, RoleX, RoleY) ->
	XyList = [
        {RoleX+400, max(0, RoleY+320)}, {RoleX-400, max(0, RoleY-320)},  %% 右上
        {RoleX-400, max(0, RoleY+320)}, {RoleX+400, max(0, RoleY-320)},  %% 左下
        {RoleX+200, max(0, RoleY+160)}, {RoleX-200, max(0, RoleY-160)},  %% 左上
        {RoleX-200, max(0, RoleY+160)}, {RoleX+200, max(0, RoleY-160)}  %% 右下
    ],
    case lib_scene:get_unblocked_xy(XyList, SceneId, CopyId, {0, 0}) of 
    	{0, 0} -> %% 全是障碍点
    		#fake_client{module_data = ModuleData} = FakeClient,
			case ModuleData of 
				#fc_holy_spirit{mon_list = MonList} -> 
					F = fun({_TId, MonId, _, _, _MonGroup}, {X1, Y1, Dis}) ->
							case get_mon_xy(MonId) of 
								false -> {X1, Y1, Dis};
								{TX, TY} ->
									SimDis = abs(RoleX - TX) + abs(RoleY - TY),
									case Dis == false orelse SimDis < Dis of 
										true ->  {TX, TY, SimDis};
										_ -> {X1, Y1, Dis}
									end
							end
					end,
					{LastX, LastY, _} = lists:foldl(F, {RoleX, RoleY, false}, MonList),
					{LastX, LastY};
				_ ->
					{RoleX, RoleY}
			end;
    	{LastX, LastY} ->
    		{LastX, LastY}
    end.
    	
    
