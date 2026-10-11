%%%-----------------------------------
%%% @Module      : lib_midday_party
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 22. 四月 2019 14:09
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_midday_party).
-author("chenyiming").

-include("common.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("midday_party.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% API
-compile(export_all).




act_start(State) ->
	%%开启经验定时器
%%	?MYLOG("midday", "start +++++++~n", []),
	%%tv
	lib_chat:send_TV({all}, ?MOD_MIDDAY_PARTY, 2, [?MOD_MIDDAY_PARTY, ?midday_party_sub_id]),
	lib_scene:clear_scene(data_midday_party:get_kv(scene_id), ?midday_party_pool_id),
	%%通知日历开启
	lib_activitycalen_api:success_start_activity(?MOD_MIDDAY_PARTY, 1),
	#midday_party_state{exp_ref = OldExpRef, act_ref = OldActRef} = State,
	ExpTime = data_midday_party:get_kv(refresh_time_exp),
	NewExpRef = util:send_after(OldExpRef, ExpTime * 1000, self(), {send_exp}), %%经验定时器
	ActTime = data_midday_party:get_kv(act_time),                               %%活动结束定时器
	TimeOutRef = util:send_after(OldActRef, ActTime * 1000, self(), {time_out}),
	%创建宝箱怪物
%%	create_box_mon(),
	#midday_party_state{exp_ref = NewExpRef, status = ?midday_party_open, act_ref = TimeOutRef, end_time = ActTime + utime:unixtime()}.

%%进入午间晚宴
enter(_State, RoleId, RoleLv) ->
	{CopyId, State} = get_copy_id(RoleId, _State),
	#midday_party_state{role_list = RoleList} = State,
	BoxRef = send_box_refresh([], RoleId, CopyId),
	RoleMsg = #role_midday_part{role_id = RoleId, refresh_ref = BoxRef, lv = RoleLv, copy_id = CopyId},
	SceneId = data_midday_party:get_kv(scene_id),
	JoinNum = mod_daily:get_count(RoleId, ?MOD_MIDDAY_PARTY, ?MIDDAY_JOIN),
	if
		JoinNum < 1 ->
			mod_daily:set_count(RoleId, ?MOD_MIDDAY_PARTY, ?MIDDAY_JOIN, 1),
			% lib_contract_challenge_api:enter_midday_party(RoleId, 1),
			case lib_guild_god_util:is_open(RoleLv) of
				true -> mod_guild_prestige:add_prestige([RoleId, task, ?GOODS_ID_GUILD_PRESTIGE, 100, 0]);
				_ -> skip
			end,
            CallbackData = #callback_join_act{type = ?MOD_MIDDAY_PARTY},
            lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData),
			lib_achievement_api:async_event(RoleId, lib_achievement_api, mid_party_event, []);
		true ->
			skip
	end,
	%%完成活动
	lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_MIDDAY_PARTY, 1),
	KeyValueList = [{change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err285_can_not_change_scene_in_midday_party)},
		{collect_checker, {lib_midday_party, collect_checker, RoleId}}],
%%	?MYLOG("cym", "CopyId ~p~n", [CopyId]),
	lib_scene:player_change_scene(RoleId, SceneId, ?midday_party_pool_id, CopyId, true, KeyValueList),
	lib_server_send:send_to_uid(RoleId, pt_285, 28501, [?SUCCESS]),
	State#midday_party_state{role_list = [RoleMsg | RoleList]}.

%%创建宝箱怪物
create_box_mon(CopyId) ->
	BoxMonId = data_midday_party:get_kv(mon_id),
	{X, Y} = data_midday_party:get_kv(mon_id_cooordinate),
	SceneId = data_midday_party:get_kv(scene_id),
	lib_mon:async_create_mon(BoxMonId, SceneId, ?midday_party_pool_id, X, Y, 0, CopyId, 1, []).

%%发送宝箱刷新定时器
send_box_refresh(OldRef, RoleId, CopyId) ->
	Time = data_midday_party:get_kv(refresh_time),
	util:send_after(OldRef, Time * 1000, self(), {box_refresh, RoleId, CopyId}).

%%发送经验
send_exp(State) ->
%%	?MYLOG("midday", "send_exp +++++++~n", []),
	ExpTime = data_midday_party:get_kv(refresh_time_exp),
	#midday_party_state{exp_ref = OldExpRef} = State,
	NewExpRef = util:send_after(OldExpRef, ExpTime * 1000, self(), {send_exp}),
	#midday_party_state{role_list = RoleList} = State,
	[lib_goods_api:send_reward_with_mail(RoleId, #produce{type = midday_party, reward = get_exp_by_lv(RoleLv), show_tips = ?SHOW_TIPS_3}) ||
		#role_midday_part{lv = RoleLv, role_id = RoleId} <- RoleList],
	State#midday_party_state{exp_ref = NewExpRef}.

%%获得经验增加值
get_exp_by_lv(Lv) ->
	case data_midday_party:get_exp(Lv) of
		[] ->
			[];
		Reward ->
			Reward
	end.

%%统计累加经验
count_exp(State, RoleId, ExpAdd) ->
	#midday_party_state{exp_map = ExpMap} = State,
	OldExp = maps:get(RoleId, ExpMap, 0),
	NewMap = maps:put(RoleId, OldExp + ExpAdd, ExpMap),
	{ok, Bin} = pt_285:write(28503, [OldExp + ExpAdd]),
	lib_server_send:send_to_uid(RoleId, Bin),
%%	?MYLOG("midday", "NewMap ~p RoleId ~p~n", [NewMap, RoleId]),
	State#midday_party_state{exp_map = NewMap}.

is_in_midday_party(SceneId) ->
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} ->
			Type == ?SCENE_TYPE_MIDDAY_PARTY;
		_ ->
			false
	end.

%%客户端获取累积经验
get_exp(State, RoleId) ->
	#midday_party_state{exp_map = Map} = State,
	Exp = maps:get(RoleId, Map, 0),
%%	?MYLOG("midday", "Exp ~p~n", [Exp]),
	{ok, Bin} = pt_285:write(28503, [Exp]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%活动结束
act_end(State) ->
	#midday_party_state{copy_msg = CopyList, exp_ref = ExpRef, act_ref = ActRef, role_list = RoleList} = State,
	%%活动结束
	lib_activitycalen_api:success_end_activity(?MOD_MIDDAY_PARTY, 1),
	%%tv
	lib_chat:send_TV({all}, ?MOD_MIDDAY_PARTY, 3, []),
	%%取消定时器
	[util:cancel_timer(MonRef) || #copy_msg{mon_reborn_ref = MonRef} <- CopyList],
	util:cancel_timer(ExpRef),
	util:cancel_timer(ActRef),
	%%所有玩家退场
	[back_to_out_side(X) || X <- RoleList],
	%%清理场景
	Scene = data_midday_party:get_kv(scene_id),
	lib_scene:clear_scene(Scene, ?midday_party_pool_id),
	#midday_party_state{}.

%%返回野外
back_to_out_side(#role_midday_part{role_id = RoleId, refresh_ref = RoleRef}) ->
	util:cancel_timer(RoleRef),
	lib_scene:player_change_scene(RoleId, 0, 0, 0, true,
		[{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {action_free, ?ERRCODE(err285_can_not_change_scene_in_midday_party)}]).

%%普通宝箱刷新逻辑
box_refresh(RoleId, State, CopyId) ->
	#midday_party_state{role_list = RoleList, refresh_box_map = BoxMap} = State,
	MonList = maps:get(RoleId, BoxMap, []),
	case lists:keyfind(RoleId, #role_midday_part.role_id, RoleList) of
		#role_midday_part{refresh_ref = OldRef} = RoleMsg ->
			BoxRef = send_box_refresh(OldRef, RoleId, CopyId),
			clear_mon_list(MonList),
			NewMonList = box_refresh_help(RoleId, CopyId),
			NewRoleMsg = RoleMsg#role_midday_part{refresh_ref = BoxRef},
			NewBoxMap = maps:put(RoleId, NewMonList, BoxMap),
			NewRoleList = lists:keystore(RoleId, #role_midday_part.role_id, RoleList, NewRoleMsg),
			State#midday_party_state{role_list = NewRoleList, refresh_box_map = NewBoxMap};
		_ ->
			State
	end.

%%清理怪物
clear_mon_list(MonList) ->
%%	?MYLOG("midday", "MonList ~p~n", [MonList]),
	SceneId = data_midday_party:get_kv(scene_id),
	lib_mon:clear_scene_mon_by_ids(SceneId, ?midday_party_pool_id, 1, MonList).

box_refresh_help(RoleId, CopyId) ->
	{LowBoxId, _} = data_midday_party:get_kv(box_id),
	SceneId = data_midday_party:get_kv(scene_id),
	XYList = data_midday_party:get_kv(box_coordinate),
	BoxNum = data_midday_party:get_kv(refresh_box_num),
	BoxNumList = lists:seq(1, BoxNum),
	ShuffleList = ulists:list_shuffle(XYList), %%随机打乱
	F = fun(_Num, {MonIdList, [{X, Y} | LastXYList]}) ->
		MonAutoId = lib_mon:sync_create_mon(LowBoxId, SceneId, ?midday_party_pool_id, X, Y, 0, CopyId, 1, [{bl_role_id, RoleId}]),
		{[MonAutoId | MonIdList], LastXYList}
	end,
	{BoxAutoIdList, _} = lists:foldl(F, {[], ShuffleList}, BoxNumList),
%%	?MYLOG("midday", "BoxAutoIdList ~p~n", [BoxAutoIdList]),
	BoxAutoIdList.

%%退出场景
quit(State, RoleId) ->
%%	?MYLOG("midday", "quit~n", []),
	#midday_party_state{role_list = RoleList} = State,
	case lists:keyfind(RoleId, #role_midday_part.role_id, RoleList) of
		#role_midday_part{} = RoleMsg ->
			back_to_out_side(RoleMsg),
			NewRoleLis = lists:keydelete(RoleId, #role_midday_part.role_id, RoleList),
			State#midday_party_state{role_list = NewRoleLis};
		_ ->
			RoleMsg = #role_midday_part{role_id = RoleId},
			back_to_out_side(RoleMsg),
			State
	end.
%%开启预告
start_tip() ->
%%	?MYLOG("midday", "start_tip ++++++~n", []),
	lib_chat:send_TV({all}, ?MOD_MIDDAY_PARTY, 1, []).


mon_be_kill(State, _KillId, MonArgs) ->
	#mon_args{hurt_list = HurtList, copy_id = CopyId} = MonArgs,
	#midday_party_state{role_list = RoleList, copy_msg = CopyList} = State,
	case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
		#copy_msg{box_map = BoxMap, mon_reborn_ref = OldRef} = CopyMsg ->
			%%清理宝箱
			OldMonList = get_clear_mon_list(CopyMsg, BoxMap),
			%%	OldMonList = lists:flatten(maps:values(BoxMap)),
			clear_mon_list(OldMonList),
			%%复活定时器
			Time = data_midday_party:get_kv(reborn_time),
			Scene = data_midday_party:get_kv(scene_id),
			NewRef = util:send_after(OldRef, Time * 1000, self(), {'mon_reborn', CopyId}),
			%%广播复活时间
			RebornTime = utime:unixtime() + Time,
			{ok, Bin} = pt_285:write(28505, [RebornTime]),
			lib_server_send:send_to_scene(Scene, ?midday_party_pool_id, CopyId, Bin),
			F = fun(#mon_atter{id = RoleId}, AccBoxMap) ->
				case lists:keyfind(RoleId, #role_midday_part.role_id, RoleList) of
					#role_midday_part{} ->
						NewMonList = create_box_af_mon_be_kill(RoleId, CopyId),
						maps:put(RoleId, NewMonList, AccBoxMap);
					_ ->
						AccBoxMap
				end
			end,
			NewBoxMap = lists:foldl(F, #{}, HurtList),
			NewCopyMsg = CopyMsg#copy_msg{box_map = NewBoxMap, mon_reborn_ref = NewRef, mon_reborn_time = RebornTime},
			NewCopyList = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
			State#midday_party_state{copy_msg = NewCopyList};
		_ ->
			State
	end.


%%宝箱怪物后
create_box_af_mon_be_kill(RoleId, CopyId) ->
	%%可见列表
	{LowBoxId, HighBoxId} = data_midday_party:get_kv(box_id),
	SceneId = data_midday_party:get_kv(scene_id),
	XYList = data_midday_party:get_kv(box_coordinate),
	{LowBoxNum, HighBoxNum} = data_midday_party:get_kv(box_num),
	_LowBoxNumList = lists:seq(1, LowBoxNum),
	LowBoxNumList = [{N1, LowBoxId} || N1 <- _LowBoxNumList],
	_HighBoxNumList = lists:seq(1, HighBoxNum),
	HighBoxNumList = [{N2, HighBoxId} || N2 <- _HighBoxNumList],
	ShuffleList = ulists:list_shuffle(XYList), %%随机打乱
	F = fun({_Num, MonId}, {MonIdList, [{X, Y} | LastXYList]}) ->
		MonAutoId = lib_mon:sync_create_mon(MonId, SceneId, ?midday_party_pool_id, X, Y, 0, CopyId, 1, [{bl_role_id, RoleId}]),
		{[MonAutoId | MonIdList], LastXYList}
	end,
	{BoxAutoIdList1, XYList1} = lists:foldl(F, {[], ShuffleList}, LowBoxNumList),
	{BoxAutoIdList2, _XYList2} = lists:foldl(F, {BoxAutoIdList1, XYList1}, HighBoxNumList),
%%	?MYLOG("midday", "BoxAutoIdList2 ~p~n", [BoxAutoIdList2]),
	BoxAutoIdList2.


collect_checker(_MonId, MonCfgId, RoleId) ->
	{LowBoxId, HighBoxId} = data_midday_party:get_kv(box_id),
	if
		MonCfgId == LowBoxId orelse MonCfgId == HighBoxId ->
			case MonCfgId of
				LowBoxId ->
					MaxNum = data_midday_party:get_kv(low_box_collect_limt),
					CurrentNum = mod_daily:get_count(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_low_box_count_id),
					if
						MaxNum > CurrentNum ->
							true;
						true ->
							{false, 23}
					end;
				_ ->
					MaxNum = data_midday_party:get_kv(high_box_collect_limt),
					CurrentNum = mod_daily:get_count(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_high_box_count_id),
					if
						MaxNum > CurrentNum ->
							true;
						true ->
							{false, 24}
					end
			end;
		true ->
			true
	end.

be_collected(State, RoleId, MonArgs) ->
	#mon_args{mid = MonId} = MonArgs,
	{LowBoxId, HighBoxId} = data_midday_party:get_kv(box_id),
	case MonId of
		LowBoxId ->
			mod_daily:plus_count_offline(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_low_box_count_id, 1),
			Reward = data_midday_party:get_kv(low_box_collect_reward);
		HighBoxId ->
			mod_daily:plus_count_offline(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_high_box_count_id, 1),
			Reward = data_midday_party:get_kv(high_box_collect_reward);
		_ ->
			Reward = []
	end,
	%%发送疲劳
	send_collect_msg_to_client(RoleId),
	%%发送奖励
	lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = midday_party}),
	%%
	State.

get_mon_reborn_time(State, RoleId) ->
	#midday_party_state{role_list = RoleList, copy_msg = CopyList} = State,
	case lists:keyfind(RoleId, #role_midday_part.role_id, RoleList) of
		#role_midday_part{copy_id = CopyId} ->
			case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
				#copy_msg{mon_reborn_time = Time} ->
					{ok, Bin} = pt_285:write(28505, [Time]),
					lib_server_send:send_to_uid(RoleId, Bin);
				_ ->
					ok
			end;
		_ ->
			ok
	end.

logout(#player_status{id = RoleId, scene = Scene} = _Ps) ->
	IsInScene = is_in_midday_party(Scene),
	if
		IsInScene == true ->
			mod_midday_party:quit(RoleId);
		true ->
			skip
	end.

send_collect_msg_to_client(RoleId) ->
	LowBoxCollectNum = mod_daily:get_count(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_low_box_count_id),
	HighBoxCollectNum = mod_daily:get_count(RoleId, ?MOD_MIDDAY_PARTY, ?midday_party_high_box_count_id),
%%	?MYLOG("midday", "Collect ~p~n", [{LowBoxCollectNum, HighBoxCollectNum}]),
	{ok, Bin} = pt_285:write(28504, [LowBoxCollectNum, HighBoxCollectNum]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%获取玩家进入id
get_copy_id(RoleId, State) ->
	#midday_party_state{copy_msg = CopyList, max_copy = MaxCopyId, copy_max_num = MaxNum} = State,
%%	?MYLOG("cym", "MaxNum  ~p~n", [MaxNum]),
	%%是否曾经进入过房间
	case get_copy_id_help(RoleId, CopyList) of
		CopyId when CopyId > 0 -> %%曾经进入过一个房间
%%			?MYLOG("cym", "CopyId  ~p~n", [CopyId]),
			{CopyId, State};
		_ ->%%没有进入过房间 ，找一个不满人的房间
			case get_copy_id_help2(RoleId, CopyList, MaxNum) of
				#copy_msg{copy_id = NewCopyId} = NewCopyMsg ->
%%					?MYLOG("cym", "CopyList  ~p~n", [CopyList]),
					NewCopyList = lists:keystore(NewCopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
					{NewCopyId, State#midday_party_state{copy_msg = NewCopyList}};
				_ ->
					%%创一个新的房间, 且创建一个怪物
%%					?MYLOG("cym", "MaxCopyId ~p~n", [MaxCopyId]),
					create_box_mon(MaxCopyId + 1),
					{MaxCopyId + 1, State#midday_party_state{max_copy = MaxCopyId + 1,
						copy_msg = [#copy_msg{copy_id = MaxCopyId + 1, role_list = [RoleId]} | CopyList]}}
			end
	end.

get_copy_id_help(_RoleId, []) ->
	0;
get_copy_id_help(RoleId, [CopyMsg | CopyMsgList]) ->
	#copy_msg{copy_id = CopyId, role_list = RoleList} = CopyMsg,
	case lists:member(RoleId, RoleList) of
		true ->
			CopyId;
		_ ->
			get_copy_id_help(RoleId, CopyMsgList)
	end.

get_copy_id_help2(_RoleId, [], _MaxNum) ->
	0;
get_copy_id_help2(RoleId, [CopyMsg | CopyMsgList], MaxNum) ->
	#copy_msg{copy_id = _CopyId, role_list = RoleList} = CopyMsg,
	Length = length(RoleList),
	if
		Length < MaxNum ->
			CopyMsg#copy_msg{role_list = [RoleId | RoleList]};
		true ->
			get_copy_id_help2(RoleId, CopyMsgList, MaxNum)
	end.


%%获得击杀时需要清理的宝箱
get_clear_mon_list(CopyMsg, BoxMap) ->
	#copy_msg{role_list = RoleList} = CopyMsg,
	MonList = [maps:get(RoleId, BoxMap, []) || RoleId <- RoleList],
	lists:flatten(MonList).