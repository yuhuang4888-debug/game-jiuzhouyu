%%%-----------------------------------
%%% @Module      : pp_soul_dungeon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 16. 十一月 2018 15:02
%%% @Description : 聚魂副本
%%%-----------------------------------
-module(pp_soul_dungeon).
-author("chenyiming").

%% API
-compile(export_all).

-include("server.hrl").
-include("soul_dungeon.hrl").
-include("def_goods.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("common.hrl").

handle(Cmd, Ps, Data) ->
	do_handle(Cmd, Ps, Data).


%% -----------------------------------------------------------------
%% @desc     功能描述  立即刷怪
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21501, #player_status{id = RoleId, copy_id = DunPid} = Ps, []) ->
	case is_pid(DunPid) of
		true ->
			gen_server:cast(DunPid, {'quik_create_mon_cast', RoleId});
		false ->
			skip
	end,
	{ok, Ps};


%% -----------------------------------------------------------------
%% @desc     功能描述  召唤boss
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21502, #player_status{id = RoleId, copy_id = DunPid, scene = SceneId, dungeon = Dungeon} = Ps, []) ->
	Cost = case data_soul_dungeon:get_value_by_key(create_boss_cost) of
		[V] ->
			V;
		_ ->
			[]
	end,
	case is_pid(DunPid) of
		true ->
			#status_dungeon{dun_id = DunId} = Dungeon,
			case data_soul_dungeon:get_value_by_key(boss_id) of
				[] ->
					lib_soul_dungeon:send_err_code(RoleId, ?MISSING_CONFIG);
				[BossList] ->
					case lists:keyfind(DunId, 1, BossList) of
						{DunId, MonId} ->
							case data_soul_dungeon:get_value_by_key(boss_xy) of
								[] ->
									lib_soul_dungeon:send_err_code(RoleId, ?MISSING_CONFIG);
								[{X, Y}] ->
									case data_soul_dungeon:get_value_by_key(scene_id) of
										[] ->
											lib_soul_dungeon:send_err_code(RoleId, ?MISSING_CONFIG);
										[SoulSceneId] ->
											case SceneId of
												SoulSceneId ->
													case lib_goods_api:check_object_list(Ps, Cost) of
														true ->
															gen_server:cast(DunPid, {'create_mon', RoleId, MonId, X, Y});
														{false, Err} ->
															lib_soul_dungeon:send_err_code(RoleId, Err)
													end;
												_ ->  %%不在场景中
													lib_soul_dungeon:send_err_code(RoleId, ?ERRCODE(err215_not_in_soul_scene))
											end
									end
							end;
						_ ->
							ok
					end
			end;
		false ->
			skip
	end,
	{ok, Ps};


%% -----------------------------------------------------------------
%% @desc     功能描述  获取击杀
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21503, #player_status{id = RoleId} = Ps, []) ->
	case lib_soul_dungeon_check:common_check(Ps) of
		true ->
			mod_soul_dungeon:get_grade(RoleId);
		{false, Err} ->
			lib_soul_dungeon:send_err_code(RoleId, Err)
	end,
	{ok, Ps};


%%%% -----------------------------------------------------------------
%%%% @desc     功能描述  使用技能
%%%% @param    参数
%%%% @return   返回值
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%do_handle(_Cmd = 21505, #player_status{id =  RoleId, copy_id = DunPId} = Ps, [SkillId]) ->
%%	case  lib_soul_dungeon_check:common_check(Ps) of
%%		true ->
%%			mod_soul_dungeon:use_skill(RoleId, SkillId, DunPId);
%%		{false, Err} ->
%%			lib_soul_dungeon:send_err_code(RoleId, Err)
%%	end,
%%	Ps;


%% -----------------------------------------------------------------
%% @desc     功能描述    下一波时间  这个应该要优化一下
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21508, #player_status{id = RoleId, copy_id = DunPid} = Ps, []) ->
	case lib_soul_dungeon_check:common_check(Ps) of
		true ->
			gen_server:cast(DunPid, {'get_refresh_time'});
		{false, Err} ->
			lib_soul_dungeon:send_err_code(RoleId, Err)
	end,
	{ok, Ps};


%% -----------------------------------------------------------------
%% @desc     功能描述    扫荡
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21507, #player_status{id = RoleId} = Ps, [DunId, Time, BossNum, Auto]) ->
	case lib_soul_dungeon_check:sweep(Ps, DunId, Time, BossNum) of
		true ->
			case data_soul_dungeon:get_value_by_key(dun_max_wave) of
				[WaveList] ->
					MaxWave =
						case lists:keyfind(DunId, 1, WaveList) of
							{DunId, V} ->
								V;
							_ ->
								0
						end;
				_ ->
					MaxWave = 0
			end,
			
			mod_soul_dungeon:sweep(RoleId, DunId, Time, BossNum, MaxWave, Auto);
		{false, Err} ->
			lib_soul_dungeon:send_err_code(RoleId, Err)
	end,
	{ok, Ps};


%% -----------------------------------------------------------------
%% @desc     功能描述    阶段奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21509, #player_status{id = RoleId, soul_dun = SoulDun, sid = Sid} = Ps, []) ->
%%	?MYLOG("cym", "SoulDun ~p~n", [SoulDun]),
	#soul_dungeon_ps{role_dungeon_list = DunList} = SoulDun,
	DunIdList = data_soul_dungeon:get_all_dun_id(),
	F = fun(DunId, Acc) ->
		Count = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
		if
			Count < 1 -> %%未完成
				Status = 0;
			true ->
				case lists:keyfind(DunId, #soul_dungeon_ps_sub.dun_id, DunList) of
					#soul_dungeon_ps_sub{status = Status} ->  %%有的话，基本就是领取了
						Status;
					_ ->%%可以领取，但是还没有领取
						Status = 1
				end
		end,
		[{DunId, Status} | Acc]
	end,
	SendList = lists:foldl(F, [], DunIdList),
%%	?MYLOG("cym", "sendList ~p~n", [SendList]),
	{ok, Bin} = pt_215:write(21509, [SendList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{ok, Ps};


%% -----------------------------------------------------------------
%% @desc     功能描述    阶段奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(_Cmd = 21510, #player_status{id = RoleId, soul_dun = SoulDun, sid = Sid} = Ps, [DunId]) ->
	#soul_dungeon_ps{role_dungeon_list = DunList} = SoulDun,
	Count = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
	if
		Count >= 1 ->
			case lists:keyfind(DunId, #soul_dungeon_ps_sub.dun_id, DunList) of
				#soul_dungeon_ps_sub{status = Status} ->
					if
						Status == 2 ->  %%已经领取了
							{ok, Bin} = pt_215:write(21510, [?ERRCODE(err215_yet_got_reward), DunId]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, Ps};
						true ->  %%未领取，且可以领取
							NewSub = #soul_dungeon_ps_sub{status = 2, dun_id = DunId},
							save_soul_dun_sub(RoleId, NewSub),
							NewDunList = lists:keystore(DunId, #soul_dungeon_ps_sub.dun_id, DunList, NewSub),
							NewSoulDun = SoulDun#soul_dungeon_ps{role_dungeon_list = NewDunList},
							send_stage_reward(RoleId, DunId),
							{ok, Bin} = pt_215:write(21510, [?SUCCESS, DunId]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, Ps#player_status{soul_dun = NewSoulDun}}
					end;
				_ ->  %%未领取，且可以领取
					NewSub = #soul_dungeon_ps_sub{status = 2, dun_id = DunId},
					save_soul_dun_sub(RoleId, NewSub),
					NewDunList = lists:keystore(DunId, #soul_dungeon_ps_sub.dun_id, DunList, NewSub),
					NewSoulDun = SoulDun#soul_dungeon_ps{role_dungeon_list = NewDunList},
					send_stage_reward(RoleId, DunId),
					{ok, Bin} = pt_215:write(21510, [?SUCCESS, DunId]),
					lib_server_send:send_to_sid(Sid, Bin),
					{ok, Ps#player_status{soul_dun = NewSoulDun}}
			end;
		true ->
			{ok, Bin} = pt_215:write(21510, [?ERRCODE(err215_not_finish_dun2), DunId]),
			lib_server_send:send_to_sid(Sid, Bin),
			{ok, Ps}
	end;



do_handle(_Cmd, _Ps, _Data) ->
	ok.





send_stage_reward(RoleId, DunId) ->
	case data_soul_dungeon:get_first_rewad_by_dun_id(DunId) of
		[_ | _] = Reward ->
			Produce = #produce{reward = Reward, type = soul_dun_stage_reward},
%%			?MYLOG("cym", "reward ~p~n", [Reward]),
			lib_goods_api:send_reward_with_mail(RoleId, Produce);
		_ ->
			ok
	end.

save_soul_dun_sub(RoleId, Sub) when is_record(Sub, soul_dungeon_ps_sub) ->
	#soul_dungeon_ps_sub{status = Status, max_wave = MaxWave, dun_id = DunId} = Sub,
	Sql = io_lib:format(?save_soul_dungeon_ps_sub, [RoleId, DunId, Status, MaxWave]),
	db:execute(Sql);

save_soul_dun_sub(_RoleId, _) ->
	ok.
	
























