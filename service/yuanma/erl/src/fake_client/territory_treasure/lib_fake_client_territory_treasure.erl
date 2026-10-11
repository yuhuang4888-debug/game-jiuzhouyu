%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_territory_treasure.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 领地夺宝挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_territory_treasure).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("territory_treasure.hrl").
-include("def_fun.hrl").
-compile(export_all).

-define(predefind_xy_list, 
	[{0,10116,7196}, {0,6851,6199}, {0,10092,14447}, {0,12788,7062}, {0,7114,10300}, {0,6665,14326}, 
	 {0,13385,11077}, {0,13498,14525}, {0,4156,10613}, {0,10170,9940}, {0,16085,11764}]
	).

-record(fc_t_treasure, {
		module_id = 0             
        , sub_module = 0   
        , dunid = 0                   %% 副本id
        , wave = 0                    %% 当前波数
        , wave_time = 0               %% 波数刷新时间
        , mon_list = []               %% 怪物列表
        , behaviour_list = [] 
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod} = OnhookModule,
	FCTTreasure = #fc_t_treasure{
		module_id = ModuleId, sub_module = SubMod
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCTTreasure},
	%?MYLOG("lxl_activity", "tt_war FCTTreasure: ~p~n", [FCTTreasure]),
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	%?MYLOG("lxl_activity", "tt_war enter_activity ~n", []),
	pp_territory_treasure:handle(65202, PS, []),
	PS.

enter_activity_result(PS, Code, Dunid) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient,
	%?MYLOG("lxl_activity", "tt_war : ~p~n", [{Code, Dunid}]),
	case Code == ?SUCCESS of 
		true -> %% 成功进入
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			NewModuleData = ModuleData#fc_t_treasure{dunid = Dunid},
			PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}};
		_ -> %% 进入活动失败，取消挂机
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, Code),
			lib_fake_client:close_fake_client(PS, enter_fail),
			PS
	end.

refresh_wave(PS, Wave, _Num, Time) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_t_treasure{dunid = Dunid, wave = OldWave} ->
			case Wave =/= OldWave of 
				true -> %% 更新波数信息
					case data_territory_treasure:get_wave_cfg(Dunid, Wave) of 
						#base_wave{mon_info = MonList} -> ok;
						_ -> MonList = []
					end,
					%?MYLOG("lxl_activity", "tt_war refresh_wave mon len : ~p ~n", [length(MonList)]),
					NewModuleData = ModuleData#fc_t_treasure{wave = Wave, wave_time = Time, mon_list = MonList},
					PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}};
				_ -> %% 波数没变不处理
					PS
			end;
		_ ->
			PS
	end.

mon_die(PS, MonId, X, Y) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_t_treasure{mon_list = MonList} ->
			%?MYLOG("lxl_activity", "tt_war mon_die : ~p ~n", [lists:member({MonId, X, Y}, MonList)]),
			NewMonList = lists:delete({MonId, X, Y}, MonList),
			NewModuleData = ModuleData#fc_t_treasure{mon_list = NewMonList},
			PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}};
		_ -> PS
	end.

close_fake_client(PS, _Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case _Msg of 
		relogin -> %% 重登不离开
			PS1 = PS;
		_ -> 
			{ok, PS1} = pp_territory_treasure:handle(65206, PS, [])
	end,
	case ModuleData of 
		#fc_t_treasure{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS1#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.


%% 是否要重选目标
need_find_target(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{
		att_target = AttTarget, module_data = ModuleData
	} = FakeClient,
	case AttTarget of 
		#att_target{mon_id = MonId, x = X, y = Y} ->
			case lists:member({MonId, X, Y}, ModuleData#fc_t_treasure.mon_list) of 
				true -> %% 怪没死
					false;
				_ -> true
			end;
		_ -> true
	end.

%% 场景那边已经找不到攻击目标，来功能这边寻找目标
find_target_in_module(PS, _Type) ->
	#player_status{fake_client = FakeClient, x = X, y = Y} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	NowTime = utime:unixtime(),
	case ModuleData of 
		#fc_t_treasure{wave = Wave, wave_time = WaveTime, mon_list = MonList} when Wave > 0 andalso NowTime >= WaveTime -> %% 小于WaveTime时，怪物是没刷新的
			%% 选择x或者y方向上的目标，如果没有再去预定义坐标中寻找目的地
			%% 服务端的自动选择路径会出现循环来回走，出现死循环
			F = fun({MonId, TX, TY}, Acc) ->
				Abx = abs(X-TX),
				Aby = abs(Y-TY),
				SimDis = Abx + Aby,
				case SimDis < 200 andalso MonId == 0 of 
					true -> %% 排除已经身处的地方并且没有怪物
						Acc;
					_ ->
						Angle = ?IF(Abx < Aby, math:atan2(Abx, Aby), math:atan2(Aby, Abx)),
						[{Angle, SimDis, MonId, TX, TY}|Acc]
				end
			end,
			List = lists:foldl(F, [], ?predefind_xy_list++MonList),
			%% 按角度排序，截取前4个, 再随机一个
			[{_, _, MonId, TX, TY}|_TargetList] = ulists:list_shuffle(lists:sublist(lists:keysort(1, List), 2)),
			Target = #att_target{key = module_object, mon_id = MonId, x = TX, y = TY},
			%?MYLOG("lxl_activity", "tt_war find target : ~p~n", [Target]),
			Target;
		_ ->
			false
	end.

get_loop_block_xy(_FakeClient, _SceneId, _CopyId, X, Y) ->
	F = fun({_, TX, TY}, Acc) ->
		SimDis = abs(X - TX) + abs(Y - TY),
		[{SimDis, TX, TY}|Acc]
	end,
	List = lists:foldl(F, [], ?predefind_xy_list),
	[{_, LastX, LastY}|_] = ulists:list_shuffle(lists:sublist(lists:keysort(1, List), 2)),
	{LastX, LastY}.
	