%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_guild_war.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 公会争霸挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_guild_war).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("fake_client.hrl").
-include("activity_onhook.hrl").
-include("def_fun.hrl").
-include("guild.hrl").
-include("territory_war.hrl").
-include("scene.hrl").
-compile(export_all).

-record(fc_guild_war, {
		module_id = 0             
        , sub_module = 0   
        , pre_enter = 0             %% 有可能会收到多次协议，然后连续多次请求进入活动
        , enter_cnt = 0             %% 进入次数
        , territory_id = 0
        , mon_list = []               %% 怪物列表
        , behaviour_list = [] 
        , ref = undefined             %% 功能行为定时器
    }).


init_fake_client(PS, OnhookModule) ->
	#onhook_module{module_id = ModuleId, sub_module = SubMod} = OnhookModule,
	FCGuildWar = #fc_guild_war{
		module_id = ModuleId, sub_module = SubMod
	},
	FakeClient = #fake_client{start_client = 1, in_module = ModuleId, in_sub_module = SubMod, module_data = FCGuildWar},
	PS#player_status{fake_client = FakeClient}.

enter_activity(PS) ->
	{_, PS1} = pp_territory_war:handle(50603, PS, [1]),
	#player_status{fake_client = FakeClient} = PS1,
	#fake_client{module_data = ModuleData} = FakeClient,
	PS1#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_guild_war{pre_enter=1}}}.

enter_activity_result(PS, Code, Type) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient,
	case Type == 1 andalso Code == ?SUCCESS of 
		true -> %% 成功进入
			mod_activity_onhook:activity_onhook_ok(RoleId, ModuleId, SubMod),
			PS#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_guild_war{pre_enter=0, enter_cnt = 1}}};
		_ -> %% 进入活动失败，取消挂机
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, Code),
			Msg = ?IF(ModuleData#fc_guild_war.enter_cnt == 0, enter_fail, undefined),
			lib_fake_client:close_fake_client(PS, Msg),
			PS
	end.

guild_war_msg(PS, TerritoryId, MonList) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	NewModuleData = ModuleData#fc_guild_war{territory_id = TerritoryId, mon_list = MonList},
	PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}}.

war_settlement(PS, _TerritoryId, GuildList) ->
	#player_status{id = RoleId, fake_client = FakeClient, guild = #status_guild{id = RoleGuildId}} = PS,
	#fake_client{in_module = ModuleId, in_sub_module = SubMod, module_data = ModuleData} = FakeClient,
	case lists:keyfind(RoleGuildId, 1, GuildList) of 
		{RoleGuildId, IsWin, _GuildName, _ServerId, _ServerNum, _Score, _OwnList} when IsWin == 1 -> %% 比赛赢了，不做处理
			PS1 = PS#player_status{fake_client = FakeClient#fake_client{module_data = ModuleData#fc_guild_war{mon_list = []}}},
			case lib_fake_client:get_onhook_type() of
				?ON_HOOK_BEHAVIOR ->
					PS2 = PS1;
				_ ->
					PS2 = lib_fake_client_battle:break_battle(PS1)
			end,
			case data_territory_war:get_territory_cfg(_TerritoryId) of 
				#base_territory{round = ?WAR_ROUND_3} ->
					mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
					lib_fake_client:close_fake_client(PS2);
				_ -> ok
			end,
			PS2;
		_ -> %% 比赛输了
			mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?SUCCESS),
			lib_fake_client:close_fake_client(PS),
			PS
	end.

next_round_fight(PS, _Round, _RoundStartTime, RoundEndTime) ->
	case RoundEndTime > 0 andalso PS#player_status.fake_client#fake_client.module_data#fc_guild_war.pre_enter == 0 of 
		true ->	
			enter_activity(PS);
		_ -> %% 不是通知进入场景
			PS
	end.

close_fake_client(PS, _Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_data = ModuleData} = FakeClient,
	case _Msg of 
		relogin -> %% 重登不离开
			PS1 = PS;
		_ -> 
			{_, PS1} = pp_territory_war:handle(50603, PS, [2])
	end,
	case ModuleData of 
		#fc_guild_war{ref = OldRef} -> util:cancel_timer(OldRef);
		_ -> ok
	end,
	PS1#player_status{fake_client = FakeClient#fake_client{module_data = undefined}}.

%% 加载场景后请求一些必要的协议
load_scene_success(PS) ->
	#player_status{scene = Scene} = PS,
	case lib_territory_war:is_in_territory_war(Scene) of 
		true ->
			{_, PS1} = pp_territory_war:handle(50604, PS, []),
			PS1;
		_ ->
			PS
	end.

mon_list(PS, MonList) ->
	#player_status{x = X, y = Y, fake_client = FakeClient, guild = #status_guild{id = RoleGuildId}} = PS,
	#fake_client{att_target = AttTarget, module_data = ModuleData} = FakeClient,
	NewModuleData = ModuleData#fc_guild_war{mon_list = MonList},
	case AttTarget of 
		#att_target{key = Key, mon_id = MonId} when Key == object orelse Key == module_object -> %% 判断一下目标还能不能攻击 
		 	case check_can_att_mon(ModuleData#fc_guild_war.territory_id, MonId, RoleGuildId, MonList) of 
		 		true -> NeedBreakBattle = false; _ -> NeedBreakBattle = true
		 	end;
		#att_target{key = user} ->
			case find_target(RoleGuildId, X, Y, ModuleData#fc_guild_war.territory_id, MonList) of 
				false -> NeedBreakBattle = false; _ -> NeedBreakBattle = true
			end;
		_ ->
			NeedBreakBattle = false
	end,
	PS1 = PS#player_status{fake_client = FakeClient#fake_client{module_data = NewModuleData}},
	case NeedBreakBattle of 
		true ->
			%?MYLOG("lxl_guild_war", "guild_war break_battle:~p ~n", [MonList]),
			case lib_fake_client:get_onhook_type() of
				?ON_HOOK_BEHAVIOR ->
					PS1;
				_ ->
					lib_fake_client_battle:break_battle(PS1)
			end;
		_ -> PS1
	end.

%% 是否需要寻找攻击目标
need_find_target(PS) ->
	#player_status{scene = Scene} = PS,
	case lib_territory_war:is_in_territory_war(Scene) of
		false -> 
			false;
		_ -> 
			#player_status{fake_client = FakeClient} = PS,
			#fake_client{att_target = AttTarget, module_data = ModuleData} = FakeClient,
			case AttTarget of 
				#att_target{key = module_object, mon_id = MonId} ->
					case lists:keymember(MonId, 4, ModuleData#fc_guild_war.mon_list) of 
						true -> false; _ -> true
					end;
				_ -> true
			end
	end.

%% 场景那边已经找不到攻击目标，来功能这边寻找目标
find_target_in_module(PS, _Type) ->
	#player_status{x = X, y = Y, fake_client = FakeClient, guild = #status_guild{id = RoleGuildId}} = PS,
	#fake_client{scene_object_data = SceneObjectData, module_data = ModuleData} = FakeClient,
	case ModuleData of 
		#fc_guild_war{territory_id = TerritoryId, mon_list = MonList} -> 
			Target = find_target(RoleGuildId, X, Y, TerritoryId, MonList),
			case Target of 
				#att_target{mon_id = MonId} -> %% 判断一下怪物是否在玩家附近
				 	Fun = fun(Id, #scene_object{config_id = MonId1}, _Id1) when MonId1 == MonId -> Id;
							(_Id, _, Id1) -> Id1
					end,
					TId = maps:fold(Fun, 0, maps:get(object, SceneObjectData, #{})),
					Target#att_target{id = TId};
				_ -> Target
			end;
		_ ->
			false
	end.

find_target(RoleGuildId, X, Y, TerritoryId, MonList) ->
	CanAttKing = can_att_king_mon(RoleGuildId, MonList),
	F = fun({_, GuildId, _GuildName, MonId, _, _}, {Target, Dis}) ->
		case RoleGuildId == GuildId of 
			true -> {Target, Dis};
			_ ->
				#base_terri_mon{mon_type = MonType, x = TX, y = TY} = data_territory_war:get_terri_mon(TerritoryId, MonId),
				case MonType == ?KING_TYPE of 
	                true-> CanAtt = CanAttKing;
	                false-> CanAtt = true
	            end,
	            case CanAtt of 
	            	false -> {Target, Dis};
	            	true ->
						SimDis = abs(X - TX) + abs(Y - TY),
						case Dis == false orelse SimDis < Dis of 
							true -> 
								{#att_target{key = module_object, mon_id = MonId, x = TX, y = TY}, SimDis};
							_ -> {Target, Dis}
						end
				end
		end
	end,
	{Target, _} = lists:foldl(F, {false, false}, MonList),
	Target.

check_can_att_mon(TerritoryId, MonId, RoleGuildId, MonList) ->
	case lists:keyfind(MonId, 4, MonList) of 
		false -> false;
		{_, GuildId, _GuildName, _MonId, _Hp, _HpLim} ->
			case GuildId == RoleGuildId of 
				true -> false;
				_ ->
					#base_terri_mon{mon_type = MonType} = data_territory_war:get_terri_mon(TerritoryId, MonId),
		            case MonType == ?KING_TYPE of 
		                true-> 
		                	can_att_king_mon(RoleGuildId, MonList);
		                false-> true
		            end
			end
	end.

can_att_king_mon(RoleGuildId, MonList) ->
	lists:keyfind(RoleGuildId, 2, MonList) =/= false.

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
				#fc_guild_war{territory_id = TerritoryId, mon_list = MonList} -> 
					F = fun({_, _, _, MonId, _, _}, {X1, Y1, Dis}) ->
							#base_terri_mon{x = TX, y = TY} = 
								data_territory_war:get_terri_mon(TerritoryId, MonId),
							SimDis = abs(RoleX - TX) + abs(RoleY - TY),
							case Dis == false orelse SimDis < Dis of 
								true ->  {TX, TY, SimDis};
								_ -> {X1, Y1, Dis}
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