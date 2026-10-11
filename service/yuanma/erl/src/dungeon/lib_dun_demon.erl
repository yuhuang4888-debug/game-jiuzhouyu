%%%-------------------------------------------------------------------
%%% @author carlos
%%% @copyright (C) 2019, <COMPANY>
%%% @doc    使魔副本
%%%
%%% @end
%%% Created : 06. 七月 2019 15:35
%%%-------------------------------------------------------------------
-module(lib_dun_demon).
-author("carlos").


-include("server.hrl").
-include("attr.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("demons.hrl").
-include("drop.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("demon_dungeon.hrl").

%% API
-compile(export_all).


login(PS) ->
	#player_status{last_logout_time = LastLogoutTime, id = RoleId} = PS,
	NowTime = utime:unixtime(),
	IsSameDay = utime_logic:is_logic_same_day(LastLogoutTime, NowTime),
%%	?MYLOG("cym", "LastLogoutTime ~p, NowTime ~p~n", [LastLogoutTime, NowTime]),
	if
		IsSameDay == true ->
			skip;
		true ->
			CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 1),
%%			?MYLOG("cym", "CurrentDunId~p~n", [CurrentDunId]),
			mod_counter:set_count(RoleId, ?MOD_DUNGEON, 2, CurrentDunId)
	end,
	Sql = io_lib:format(<<"select  demon_list  from   dun_demon_role where  role_id = ~p">>, [RoleId]),
	case db:get_row(Sql) of
		[] ->
			PS;
		[DbDemonList] ->
			DemonList = [{Id, 0, 0} || Id <- util:bitstring_to_term(DbDemonList)],
			DemonDun = #demon_dun{demon_list = DemonList},
			PS#player_status{demon_dun = DemonDun}
	end.


zero_update() ->
%%	?MYLOG("cym", "zero_update ++++++++++++++++++++++", []),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_dun_demon, zero_update, []) || E <- OnlineRoles].


zero_update(PS) ->
	#player_status{id = RoleId} = PS,
	CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 1),
%%	?MYLOG("cym", "CurrentDunId~p~n", [CurrentDunId]),
	mod_counter:set_count(RoleId, ?MOD_DUNGEON, 2, CurrentDunId),
	PS.


enter(DunId, DemonIdList, Player) ->
	#player_status{demon_dun = DunDemon, sid = Sid, id = RoleId} = Player,
	_CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 1),
	if
		_CurrentDunId == 0 ->
			CurrentDunId = ?demon_dun_id - 1;
		true ->
			CurrentDunId = _CurrentDunId
	end,
	case check_demon_list(Player, DemonIdList) of
		true ->

			case DunDemon of
				#demon_dun{} ->
					NewDunDemon = DunDemon#demon_dun{demon_list = get_demon_list(Player, DemonIdList, [])};
				_ ->
					NewDunDemon = #demon_dun{demon_list = get_demon_list(Player, DemonIdList, [])}
			end,
			if
				DunId == CurrentDunId + 1 ->
					NewPs = Player#player_status{demon_dun = NewDunDemon},
					case lib_dungeon_check:can_change_scene(NewPs) of
						{false, Code} ->
							lib_server_send:send_to_sid(NewPs#player_status.sid, pt_610, 61001, [DunId, 0, Code, []]);
						_ ->
							save_to_db(RoleId, NewDunDemon),
							lib_dungeon:enter_dungeon(NewPs, DunId)
					end;
				true ->
					{ok, Bin} = pt_610:write(61000, [?ERRCODE(err610_just_once_finish), ""]),
					lib_server_send:send_to_sid(Sid, Bin)
			end;
		{false, Err} ->
			{ok, Bin} = pt_610:write(61000, [Err, ""]),
			lib_server_send:send_to_sid(Sid, Bin),
			{ok, Player}
	end.


%%
check_demon_list(Player, DemonIdList) ->
	#player_status{status_demons = StatusDemons} = Player,
	Length = length(DemonIdList),
	case StatusDemons of
		#status_demons{demons_list = MyDemonsList} ->
			Res = check_demon_list2(DemonIdList, MyDemonsList),
			if
				DemonIdList == [] ->
					{false, ?FAIL};
				Length > 5 ->
					{false, ?ERRCODE(err650_too_many_demon)};
				Res == false ->
					{false, ?ERRCODE(err610_not_exist_demon)};
				true ->
					true
			end;
		_ ->
			{false, ?ERRCODE(err610_not_exist_demon)}
	end.

check_demon_list2([], _MyDemonsList) ->
	true;
check_demon_list2([Id | DemonIdList], MyDemonsList) ->
	case lists:keyfind(Id, #demons.demons_id, MyDemonsList) of
		#demons{} ->
			check_demon_list2(DemonIdList, MyDemonsList);
		_ ->
			{false, ?ERRCODE(err610_not_exist_demon)}
	end.


%%获得副本初始化数据
dunex_get_start_dun_args(Player, _Dun) ->
	#player_status{demon_dun = DemonDun} = Player,
	case DemonDun of
		#demon_dun{demon_list = DemonList} ->
			[{typical_data, [{demon_list, DemonList}]}];
		_ ->
			[{typical_data, []}]
	end.

%%创建使魔
create_demon(State, _Dun) ->
	#dungeon_state{now_scene_id = SceneId, scene_pool_id = PoolId, typical_data = DataMap, dun_type = DunType} = State,
	DemonList = maps:get(demon_list, DataMap, []),
	DemonCfgList = lib_dungeon_api:get_demon_list(DunType),
	XYList = lib_dungeon_api:get_demon_xy(DunType),
	?MYLOG("cym", "DemonList ~p~n", [DemonList]),
	create_mon2(DemonList, DemonCfgList, XYList, SceneId, PoolId, self()).

create_mon2([], _DemonCfgList, _XYList, _SceneId, _PoolId, _Copy) ->
	ok;
create_mon2([{DemonId, DemonAttr, SkillList} | DemonList], DemonCfgList, [{Location, {X, Y}} | XYList], SceneId, PoolId, Copy) ->
%%	?MYLOG("cym", "DemonCfgList  ~p~n", [DemonCfgList]),
	Path = get_path(Location),
	case lists:keyfind(DemonId, 1, DemonCfgList) of
		{DemonId, MonId} ->
			lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, 1, Copy, 1,
				[{attr_replace, DemonAttr}, {group, ?DUN_DEF_GROUP}, {path, Path}, {state, walk}, {skill, SkillList}]);
		_ ->
			skip
	end,
	create_mon2(DemonList, DemonCfgList, XYList, SceneId, PoolId, Copy).



%% DemonIdList:: [{Id, Attr}]
get_demon_list(_Player, [], AccList) ->
	?MYLOG("cym", "AccList ~p~n", [AccList]),
	lists:reverse(AccList);
get_demon_list(Player, [Id | DemonIdList], AccList) ->
	?MYLOG("cym", "Id ~p~n", [Id]),
	Data = lib_demons:get_battle_demons_for_dun(Player),
	{SkillList, Attr} = get_demon_attr_skill(Id, Data),
	get_demon_list(Player, DemonIdList, [{Id, Attr, SkillList} | AccList]).


get_demon_attr_skill(Id, Data) ->
	case lists:keyfind(Id, 1, Data) of
		{Id, SkillList, Attr} ->
			{SkillList, Attr};
		_ ->
			?ERR("err demon id ~p~n", [Id]),
			{[], #attr{}}
	end.




%%使魔路径
get_path(Location) ->
	case data_dungeon_special:get(?DUNGEON_TYPE_PET2, demon_path) of
		[_ | _] = List ->
			case lists:keyfind(Location, 1, List) of
				{Location, Path} ->
					Path;
				_ ->
					[]
			end;
		_ ->
			[]
	end.


dunex_handle_dungeon_direct_end(#dungeon_state{result_type = ?DUN_RESULT_TYPE_SUCCESS,
	role_list = DunRoleList, dun_id = DunId, dun_type = ?DUNGEON_TYPE_PET2}) ->
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_dun_demon, update, [DunId]) || #dungeon_role{id = RoleId} <- DunRoleList];
dunex_handle_dungeon_direct_end(_) ->
	ok.

update(#player_status{id = RoleId} = PS, DunId) ->
	CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 1),
	if
		DunId > CurrentDunId ->
			mod_counter:set_count(RoleId, ?MOD_DUNGEON, 1, DunId);
		true ->
			skip
	end,
	PS.





get_current_dun(Player) ->
	#player_status{sid = Sid, id = RoleId, demon_dun = DemonDun} = Player,
	_CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 1),
	YesterdayCurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 2),
	SweepCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, 11),
	if
		_CurrentDunId == 0 ->
			CurrentDunId = ?demon_dun_id - 1;
		true ->
			CurrentDunId = _CurrentDunId
	end,
	case DemonDun of
		#demon_dun{demon_list = DemonList} ->
			ok;
		_ ->
			DemonList = []
	end,
%%	?MYLOG("cym", "~p~n", [{CurrentDunId, YesterdayCurrentDunId, [DemonId || {DemonId, _, _} <- DemonList], SweepCount}]),
	{ok, Bin} = pt_611:write(61103, [CurrentDunId, YesterdayCurrentDunId, [DemonId || {DemonId, _, _} <- DemonList], SweepCount]),
	lib_server_send:send_to_sid(Sid, Bin).





sweep(#player_status{id = RoleId, sid = Sid} = Player, DunId) ->
	SweepCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, 11),
	CurrentDunId = mod_counter:get_count(RoleId, ?MOD_DUNGEON, 2),
	?MYLOG("cym", "CurrentDunId ++++++++++++ ~p~n", [CurrentDunId]),
	SweepDunId = data_dungeon_special:get(?DUNGEON_TYPE_PET2, sweep_dun_id),
	if
		DunId < SweepDunId ->  %%使魔副本层数太低了
			{ok, Bin} = pt_610:write(61000, [?ERRCODE(err610_dun_demon_low_dun), ""]),
			lib_server_send:send_to_sid(Sid, Bin);
		CurrentDunId =/= DunId ->  %%和当前副本id不一致
			{ok, Bin} = pt_610:write(61000, [?ERRCODE(err610_sweep_limit_error), ""]),
			lib_server_send:send_to_sid(Sid, Bin);
		SweepCount >= 1 ->  %%扫荡过
%%			?MYLOG("cym", "++++++++++++ ~p~n", [SweepCount]),
			{ok, Bin} = pt_610:write(61000, [?ERRCODE(err610_dungeon_count_daily), ""]),
			lib_server_send:send_to_sid(Sid, Bin);
		true ->
%%			?MYLOG("cym", "++++++++++++ ~n", []),
			mod_daily:get_count(RoleId, ?MOD_DUNGEON, 11),
			pp_dungeon:handle(61022, Player, [DunId, 1])
	end.




demon_die(#mon_args{scene = Scene, copy_id = CopyId, mid = MonId}) ->
%%	?MYLOG("cym", "MonId ~p~n", [MonId]),
	Res = is_in_demon_dun(Scene),
	if
		Res == true ->
			?MYLOG("cym", "MonId ~p~n", [MonId]),
			mod_dungeon:demon_die(CopyId, MonId);
		true ->
			ok
	end;
demon_die(_) ->
	ok.


is_in_demon_dun(Scene) ->
	if
		Scene == ?demon_scene ->
			true;
		true ->
			false
	end.



demon_die(State, DemonId) ->
	?MYLOG("cym", "DemonId ~p~n", [DemonId]),
	#dungeon_state{typical_data = DataMap} = State,
	DemonList = maps:get(demon_list, DataMap, []),      %%副本中的使魔列表
	?MYLOG("cym", "DemonList ~p~n", [DemonList]),
	DemonDieList = maps:get(demon_list_die, DataMap, []),  %%死亡的使魔列表
	case is_demon(DemonId) of
		true ->
			DemonDieList1 = [DemonId | DemonDieList],
			NewDataMap = maps:put(demon_list_die, DemonDieList1, DataMap),
			NewState = State#dungeon_state{typical_data = NewDataMap},
			L1 = length(DemonList),
			L2 = length(DemonDieList1),
			?MYLOG("cym", "DemonId ~p~n", [{L2, L1}]),
			if
				L2 == L1 ->  %%结算
					lib_dungeon_mod:dungeon_result(NewState, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ?DUN_RESULT_TYPE_FAIL, ?DUN_RESULT_SUBTYPE_NO, [], []);
				true ->
					{noreply, NewState}
			end;
		_ ->
			?MYLOG("cym", "DemonList ~p~n", [DemonList]),
			{noreply, State}
	end.


dunex_get_scene_args(_NewPlayer) ->
%%	?MYLOG("cym" , "++++++~n", []),
	[{scene_hide_type, ?HIDE_TYPE_VISITOR}].

dunex_get_quit_scene_args(_Player) ->
	[{scene_hide_type, 0}].


is_demon(DemonId) ->
	case data_mon:get(DemonId) of
		#mon{boss = ?MON_DEMON} ->
			true;
		_ ->
			false
	end.


save_to_db(RoleId, #demon_dun{demon_list = _List}) ->
	List = [Id || {Id, _, _} <- _List],
	Sql = io_lib:format(<<"REPLACE into dun_demon_role(role_id, demon_list)  values(~p, '~s')">>, [RoleId, util:term_to_bitstring(List)]),
	db:execute(Sql);
save_to_db(_RoleId, _) ->
	ok.


%%使魔副本奖励补偿
demon_dun_compensate() ->
	Sql = io_lib:format(<<"select  role_id from   dun_demon_role">>, []),
	List = db:get_all(Sql),
	[begin
%%		 ?MYLOG("dun", "RoleId ~p~n", [RoleId]),
		 _CurrentDunId = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, 1),
		 if
			 _CurrentDunId == 0 ->
				 CurrentDunId = ?demon_dun_id - 1;
			 true ->
				 CurrentDunId = _CurrentDunId
		 end,
		 case data_dungeon:get_dun_demon_compensate(CurrentDunId) of
			[_ | _] = Reward ->
				Title = utext:get(6100008),
				Content = utext:get(6100009),
				lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
			 _ ->
				 ok
		 end
	 end
		|| [RoleId] <- List].
