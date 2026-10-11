%%%-----------------------------------
%%% @Module      : pp_holy_spirit_battlefield
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十月 2019 19:13
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_holy_spirit_battlefield).
-author("carlos").

-include("server.hrl").
-include("common.hrl").
-include("holy_spirit_battlefield.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
%% API
-export([]).

%% 判断是否开发
-ifdef(DEV_SERVER).
-define(is_kf,  true).
-else.
-define(is_kf,  false).  %%
-endif.




handle(CMD, PS, Data) ->
%%	?MYLOG("holy", "cmd ~p~n", [CMD]),
	OpenDay = util:get_open_day(),
	NeedOpenDay = data_holy_spirit_battlefield:get_kv(open_day),
	if
		OpenDay < NeedOpenDay ->
			send_error(PS#player_status.id, ?ERRCODE(err218_not_enough_day));
		true ->
			
			case do_handle(CMD, PS, Data) of
				#player_status{} = NewPS ->
					{ok, NewPS};
				{ok, NewPS} when is_record(NewPS, player_status) ->
					{ok, NewPS};
				_ ->
					{ok, PS}
			end
	end.





do_handle(21801, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId} = PS,
	mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_info, [ServerId, RoleId]);
	

%% 进入场景
do_handle(21802, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, sid = Sid, scene = Scene, combat_power = Power, figure = F, server_num = ServerNum,
		holy_spirit_battlefield = _Holy} = PS,
	case lib_holy_spirit_battlefield:is_local_open() orelse ?is_kf of %%
		true ->
			LvLimit = data_holy_spirit_battlefield:get_kv(lv_limit),
			if
				F#figure.lv >= LvLimit ->
					case lib_player_check:check_all(PS) of
						true ->
							case lib_holy_spirit_battlefield:is_in_scene(Scene) of
								true ->
									lib_server_send:send_to_sid(Sid, pt_218, 21802, [?ERRCODE(err218_in_scene)]);
								_ ->
									case lib_holy_spirit_battlefield:is_local_mod() of
										true ->
											?PRINT("enter local++++++++++++++++++++ ~n", []),
											mod_holy_spirit_battlefield_local:enter_scene(F#figure.turn, F#figure.career, F#figure.picture_ver,
												F#figure.picture, F#figure.lv, ServerNum, ServerId, RoleId, Power, F#figure.name);
										_ ->
											?PRINT("enter cls ++++++++++++++++++++ ~n", []),
											mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, enter_scene,
												[F#figure.turn, F#figure.career, F#figure.picture_ver, F#figure.picture, F#figure.lv, ServerNum, ServerId, RoleId, Power, F#figure.name])
									end
									end;
						{false, Error} ->
							lib_server_send:send_to_sid(Sid, pt_218, 21802, [Error])
					end;
				true ->
					lib_server_send:send_to_sid(Sid, pt_218, 21802, [?ERRCODE(lv_limit)])
			end;
		_ ->
			lib_server_send:send_to_sid(Sid, pt_218, 21802, [?ERRCODE(err218_act_close)])
	end;
	



%% 退出场景
do_handle(21803, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, scene = Scene} = PS,
	case lib_holy_spirit_battlefield:is_in_scene(Scene) of
		true ->
			lib_holy_spirit_battlefield:quit_scene(0, RoleId),
			case lib_holy_spirit_battlefield:is_local_mod() of
				true ->
					mod_holy_spirit_battlefield_local:quit_scene(ServerId, RoleId);
				_ ->
					mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, quit_scene, [ServerId, RoleId])
			end;
		_ ->
			ok
	end;


%% 获取经验信息
do_handle(21804, PS, []) ->
	#player_status{server_id = ServerId, id = RoleId, scene = Scene} = PS,
	case lib_holy_spirit_battlefield:is_wait_scene(Scene) of
		true ->
			case lib_holy_spirit_battlefield:is_local_mod() of
				true ->
					mod_holy_spirit_battlefield_local:get_exp(ServerId, RoleId);
				_ ->
					mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_exp, [ServerId, RoleId])
			end;
		_ ->
			ok
	end;

%% 个人奖励
do_handle(21805, PS, []) ->
	#player_status{id = RoleId, holy_spirit_battlefield = HolyBattle} = PS,
	#role_holy_spirit_battlefield{point = Point, reward = Reward, mod = Mod} = HolyBattle,
	PackReward = lib_holy_spirit_battlefield:get_pack_reward(Mod, Point, Reward),
%%	?MYLOG("holy", "Point ~p~n, PackReward ~p~n", [Point, PackReward]),
	{ok, Bin} = pt_218:write(21805, [Point, PackReward]),
	lib_server_send:send_to_uid(RoleId, Bin);

%% 领取个人积分奖励
do_handle(21806, PS, [Stage]) ->
	#player_status{id = RoleId, holy_spirit_battlefield = HolyBattle} = PS,
	#role_holy_spirit_battlefield{point = Point, reward = Reward, mod = Mod} = HolyBattle,
	PackReward = lib_holy_spirit_battlefield:get_pack_reward(Mod, Point, Reward),
	case lists:keyfind(Stage, 1, PackReward) of
		{Stage, 0} ->  %% 不能领取
			send_error(RoleId, ?ERRCODE(err218_not_enough_point));
		{Stage, 1} ->  %% 可以领取
%%			?MYLOG("holy", "Reward ~p ~p~n", [Mod, Stage]),
			case data_holy_spirit_battlefield:get_role_reward(Mod, Stage) of
				[] ->
%%					?MYLOG("holy", "_R ~p~n", [_R]),
					send_error(RoleId, ?MISSING_CONFIG);
				PointReward ->
					NewReward = lists:keystore(Stage, 1, Reward, {Stage, 2}),
					NewHolyBattle = HolyBattle#role_holy_spirit_battlefield{reward = NewReward},
					lib_holy_spirit_battlefield:save_role_holy_spirit_battlefield(RoleId, NewHolyBattle),
%%					?MYLOG("holy", "Reward ~p~n", [PointReward]),
					lib_log_api:log_holy_battle_pk_point_reward(RoleId, Mod, Stage, PointReward),
					%% 发送奖励
					lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = PointReward, type = holy_spirit_battlefield_point_reward}),
					{ok, Bin} = pt_218:write(21806, [PointReward]),
					lib_server_send:send_to_uid(RoleId, Bin),
					PS#player_status{holy_spirit_battlefield = NewHolyBattle}
			
			end;
		{Stage, 2} -> %%已经领取
			send_error(RoleId, ?ERRCODE(err218_yet_get_point_reward));
		_ -> %% 容错
			send_error(RoleId, ?FAIL)
	end;


%%%% 战场信息   不能自己请求了
%%do_handle(21807, PS, []) ->
%%	#player_status{id = RoleId, scene = Scene, server_id = ServerId, holy_spirit_battlefield = Holy} = PS,
%%	case lib_holy_spirit_battlefield:is_pk_scene(Scene) of
%%		true -> %% todo   优化
%%			#role_holy_spirit_battlefield{battle_pid = BattlePid} = Holy,
%%			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield_room, get_battle_msg, [BattlePid, ServerId, RoleId]);
%%		_ ->
%%			ok
%%	end;

%% 战场统计
do_handle(21808, PS, []) ->
	#player_status{id = RoleId, scene = Scene, server_id = ServerId} = PS,
	ScenePK = data_holy_spirit_battlefield:get_kv(pk_scene),
	ScenePKLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	case Scene of
		ScenePK -> %% 优化
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_battle_all_msg, [ServerId, RoleId]);
		ScenePKLocal ->
			mod_holy_spirit_battlefield_local:get_battle_all_msg(ServerId, RoleId);
		_ ->
			ok
	end;

%% 状态时间信息信息
do_handle(21811, PS, []) ->
	#player_status{id = RoleId, scene = _Scene, server_id = ServerId} = PS,
	{ok, Bin} = pt_218:write(21811, [0, 0]),
	case lib_holy_spirit_battlefield:is_local_open() orelse ?is_kf of  %%
		true ->
			case lib_holy_spirit_battlefield:is_local_mod() of
				true ->
					mod_holy_spirit_battlefield_local:get_status_time(ServerId, RoleId);
				_ ->
					mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_status_time, [ServerId, RoleId])
			end;
		_ ->
			lib_server_send:send_to_uid(RoleId, Bin)
	end;
%%	case lib_holy_spirit_battlefield:is_in_scene(Scene) of
%%		true ->
%%			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_status_time, [ServerId, RoleId]);
%%		_ ->
%%			ok
%%	end;

%%  使用怒气技能
do_handle(21812, PS, []) ->
	#player_status{id = RoleId, scene = Scene, server_id = ServerId} = PS,
	ScenePK = data_holy_spirit_battlefield:get_kv(pk_scene),
	ScenePKLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	case Scene of
		ScenePK -> %% 优化
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, use_anger_skill, [ServerId, RoleId]);
		ScenePKLocal ->
			mod_holy_spirit_battlefield_local:use_anger_skill(ServerId, RoleId);
		_ ->
			ok
	end;

%% 怪物信息
do_handle(21813, PS, []) ->
	#player_status{id = RoleId, scene = Scene, server_id = ServerId, scene_pool_id = PooId, copy_id = CopyId} = PS,
	ScenePK = data_holy_spirit_battlefield:get_kv(pk_scene),
	ScenePKLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	case Scene of
		ScenePK -> %% 优化
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_mon_msg, [ServerId, RoleId, PooId, CopyId]);
		ScenePKLocal ->
			mod_holy_spirit_battlefield_local:get_mon_msg(ServerId, RoleId, PooId, CopyId);
		_ ->
			ok
	end;
%%	case lib_holy_spirit_battlefield:is_pk_scene(Scene) of
%%		true ->  %% todo 优化
%%			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, get_mon_msg, [ServerId, RoleId, PooId, CopyId]);
%%		_ ->  %% err650_not_in_act
%%			send_error(RoleId, ?ERRCODE(err650_not_in_act))
%%	end;




do_handle(_CMD, _PS, _Data) ->
	ok.
%%	?MYLOG("holy", "not match _CMD ~p~n", [_CMD]).

send_error(RoleId, Error) ->
%%	?MYLOG("holy", "Error ~p~n", [Error]),
	{ok, Bin} = pt_218:write(21800, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).


































