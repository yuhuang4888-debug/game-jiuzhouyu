%%%-----------------------------------
%%% @Module      : lib_holy_spirit_battlefield
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 十月 2019 15:34
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_holy_spirit_battlefield).

-author("carlos").


-include("clusters.hrl").
-include("def_module.hrl").
-include("holy_spirit_battlefield.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("battle.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
%% API
-export([]).

%% 判断是否开发
-ifdef(DEV_SERVER).
-define(is_kf, true).
-else.
-define(is_kf, false).  %%
-endif.




logout(PS) ->
	#player_status{scene = Scene, server_id = ServerId, id = RoleId} = PS,
	case is_in_scene(Scene) of
		true ->
%%			?MYLOG("holy", "logout +++++++++++++++++++~n", []),
			lib_holy_spirit_battlefield:quit_scene(0, RoleId),
			mod_holy_spirit_battlefield_local:quit_scene(ServerId, RoleId),
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, quit_scene, [ServerId, RoleId]);
		_ ->
			skip
	end.



%% 死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
	#player_status{id = DefRoleId, scene = SceneId,
		copy_id = RoomId, server_id = _ServerId, scene_pool_id = PoolId, player_die = PlayerDieInfo} = Player,
	#{attersign := AtterSign, atter := Atter, hit := HitList} = Data,
%%	#battle_return_atter{id = AtterId} = Atter,
	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) andalso AtterSign == ?BATTLE_SIGN_PLAYER of
		true ->
			LocalPkScene = data_holy_spirit_battlefield:get_kv(pk_scene_local),
%%			PkScene = data_holy_spirit_battlefield:get_kv(pk_scene_local),
			case SceneId of
				LocalPkScene ->
					mod_holy_spirit_battlefield_local:kill_enemy(SceneId, PoolId, RoomId, DefRoleId, Atter, HitList);
				_ ->
					mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, kill_enemy,
						[SceneId, PoolId, RoomId, DefRoleId, Atter, HitList])
			end;
		false ->
			ok
	end,
	OldModDieInfo = maps:get(?MOD_HOLY_SPIRIT_BATTLEFIELD, PlayerDieInfo, []),
	case OldModDieInfo of
		[] ->
			OldRef = [],
			ModDieInfo = #mod_player_die{mod = ?MOD_HOLY_SPIRIT_BATTLEFIELD, reborn_ref = undefined};
		_ ->
			#mod_player_die{reborn_ref = OldRef} = OldModDieInfo,
			ModDieInfo = OldModDieInfo
	end,
	RebornTime = data_holy_spirit_battlefield:get_kv(relive_time),
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} when Type == ?SCENE_TYPE_HOLY_SPIRIT_BATTLE ->
			Ref = util:send_after(OldRef, RebornTime * 1000, self(), {'mod', lib_holy_spirit_battlefield, reborn, []}),
			NewModDieInfo = ModDieInfo#mod_player_die{mod = ?MOD_HOLY_SPIRIT_BATTLEFIELD, reborn_ref = Ref},
			NewPlayerDieInfo = maps:put(?MOD_HOLY_SPIRIT_BATTLEFIELD, NewModDieInfo, PlayerDieInfo),
			{ok, Player#player_status{player_die = NewPlayerDieInfo}};
		_ ->
			{ok, Player}
	end;


%% 复活事件
handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE}) when is_record(Player, player_status) ->
	#player_status{scene = Scene, server_id = ServerId, id = RoleId} = Player,
	case is_pk_scene(Scene) of
		true ->
			LocalPkScene = data_holy_spirit_battlefield:get_kv(pk_scene_local),
%%			PkScene = data_holy_spirit_battlefield:get_kv(pk_scene_local),
			case Scene of
				LocalPkScene ->
					mod_holy_spirit_battlefield_local:revive(ServerId, RoleId);
				_ ->
					mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, revive,
						[ServerId, RoleId])
			end;
		false ->
			skip
	end,
	{ok, Player};

handle_event(Player, _) ->
	{ok, Player}.


login(PS) ->
	#player_status{id = RoleId} = PS,
	Sql = io_lib:format(?select_role_msg, [RoleId]),
	case db:get_row(Sql) of
		[Mod, Point, Reward] ->
			NewRoleMsg = #role_holy_spirit_battlefield{point = Point, mod = Mod, reward = util:bitstring_to_term(Reward)},
			PS#player_status{holy_spirit_battlefield = NewRoleMsg};
		_ ->
			PS#player_status{holy_spirit_battlefield = #role_holy_spirit_battlefield{}}
	end.


re_login(PS) ->
	#player_status{scene = Scene} = PS,
	case is_pk_scene(Scene) of
		true ->
			pp_holy_spirit_battlefield:handle(21813, PS, []);
		_ ->
			skip
	end.

gm_repaire_data(RoleId) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, gm_repaire_data, []);
gm_repaire_data(Player) when is_record(Player, player_status) ->
	#player_status{id = RoleId, holy_spirit_battlefield = RoleMsg} = Player,
	#role_holy_spirit_battlefield{point = Point, mod = Mod} = RoleMsg,
	NewReward = get_pack_reward(Mod, Point, []),
	{ok, Bin} = pt_218:write(21805, [Point, NewReward]),
	lib_server_send:send_to_uid(RoleId, Bin),
	NewRoleMsg = RoleMsg#role_holy_spirit_battlefield{reward = NewReward},
	lib_holy_spirit_battlefield:save_role_holy_spirit_battlefield(RoleId, NewRoleMsg),
	{ok, Player#player_status{holy_spirit_battlefield = NewRoleMsg}};
gm_repaire_data(_) -> skip.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
sort_server(ZoneList) ->
	F = fun(#server_msg{time = TimeA}, #server_msg{time = TimeB}) ->
		TimeA < TimeB  %%开服时间早的排在前头
	    end,
	NewZoneList = lists:sort(F, ZoneList),
	NewZoneList.


%% 获取开服天数
get_open_day(OpenTime) ->
	Now = utime:unixtime(),
	Day = (Now - OpenTime) div 86400,
	Day + 1.


%% 从数据库获取最大的模式
get_max_mod_from_db(ZoneId) ->
	Sql = io_lib:format(?select_max_mod, [ZoneId]),
	case db:get_row(Sql) of
		[MaxMod] ->
			MaxMod;
		_ ->
			0
	end.


set_rank(SortList) ->
	set_rank(SortList, [], 0).


%% 设置区域内排名
set_rank([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank([Server | SortList], AccList, PreRank) ->
%%	?MYLOG("holy", "Server ~p~n", [Server]),
	set_rank(SortList, [Server#server_msg{rank = PreRank + 1} | AccList], PreRank + 1).



set_rank_role(SortList) ->
	set_rank_role(SortList, [], 0).


%%
set_rank_role([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank_role([Role | SortList], AccList, PreRank) ->
	set_rank_role(SortList, [Role#role_msg{rank = PreRank + 1} | AccList], PreRank + 1).


set_rank_pk_role(SortList) ->
	set_rank_pk_role(SortList, [], 0).

%%
set_rank_pk_role([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank_pk_role([Role | SortList], AccList, PreRank) ->
	set_rank_pk_role(SortList, [Role#role_pk_msg{rank = PreRank + 1} | AccList], PreRank + 1).




set_rank_battle_group(SortList) ->
	set_rank_battle_group(SortList, [], 0).

%%
set_rank_battle_group([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank_battle_group([Group | SortList], AccList, PreRank) ->
	set_rank_battle_group(SortList, [Group#battle_group{rank = PreRank + 1} | AccList], PreRank + 1).



%% -----------------------------------------------------------------
%% @desc     功能描述   获取服的满足的模式，最高为Mod
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_server_mod(Server, Mod) ->
	#server_msg{time = Time} = Server,
	OpenDay = get_open_day(Time),
	get_server_mod2(OpenDay, Mod).

get_server_mod2(OpenDay, Mod) ->
	case data_holy_spirit_battlefield:get_mod_cfg(Mod) of
		#mod_cfg{open_day = CfgOpenDay} ->
			if
				OpenDay >= CfgOpenDay ->
					Mod;
				true ->
					get_server_mod2(OpenDay, trunc(Mod / 2))
			end;
		_ -> %%  默认不开
			0
	end.



%% 服务器的战场id = 模式 * 100 + （排名 / 模式， 向上取整）
get_battlefield_id(RightMod, Rank) ->
	RightMod * 100 + util:ceil(Rank / RightMod).


get_open_ref(OldRef) ->
	Day = utime:day_of_week(),
	WeekList = data_holy_spirit_battlefield:get_kv(week),
	NowTimes = utime:get_seconds_from_midnight(),
	{{H, M}, _} = data_holy_spirit_battlefield:get_kv(open_time),
	OpenTime = H * 60 * 60 + M * 60,
	case lists:member(Day, WeekList) of
		true ->
			if
				NowTimes > OpenTime ->  %% 开启时间已经过了
					[];
				true ->
					util:send_after(OldRef, (OpenTime - NowTimes) * 1000, self(), {act_open})
			end;
		_ ->
			[]
	end.


get_pk_time() ->
	data_holy_spirit_battlefield:get_kv(pk_time).

get_wait_time() ->
	data_holy_spirit_battlefield:get_kv(wait_time).



sort_role(RoleList) ->
	F = fun(#role_msg{power = PowerA}, #role_msg{power = PowerB}) ->
		PowerA >= PowerB  %%战力高的排前头
	    end,
	lists:sort(F, RoleList).

%% 战力排序
sort_pk_role(RoleList) ->
	F = fun(#role_pk_msg{power = PowerA}, #role_pk_msg{power = PowerB}) ->
		PowerA >= PowerB  %%战力高的排前头
	    end,
	lists:sort(F, RoleList).

%% 积分排序
sort_pk_role_by_point(RoleList) ->
	F = fun(#role_pk_msg{point = PointA}, #role_pk_msg{point = PointB}) ->
		PointA >= PointB  %%积分高前头
	    end,
	lists:sort(F, RoleList).


sort_battle_group(GroupList) ->
	F = fun(#battle_group{point = PointA}, #battle_group{point = PointB}) ->
		PointA >= PointB  %%积分的排前头
	    end,
	lists:sort(F, GroupList).

%% 阵营人数排名
sort_battle_group_by_num(GroupList) ->
	F = fun(#battle_group{num = Num1, power = Power1}, #battle_group{num = Num2, power = Power2}) ->
		if
			Num1 < Num2 ->%%人数少的前面
				true;
			Num1 == Num2 ->
				Power1 =< Power2;
			true ->
				false
		end
	    end,
	lists:sort(F, GroupList).




send_to_client(ServerId, RoleId, Bin) ->
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]);
		_ ->
			lib_server_send:send_to_uid(RoleId, Bin)
	end.

apply_cast(ServerId, M, F, A) ->
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_cast(ServerId, M, F, A);
        _ ->
            apply(M, F, A)
    end.

%%是否在匹配或者战斗场景中
is_in_scene(Scene) ->
	SceneMatch = data_holy_spirit_battlefield:get_kv(wait_scene),
	SceneMatchLocal = data_holy_spirit_battlefield:get_kv(wait_scene_local),
	ScenePK = data_holy_spirit_battlefield:get_kv(pk_scene),
	ScenePKLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	if
		Scene == SceneMatch orelse Scene == ScenePK orelse Scene == ScenePKLocal ->
			true;
		Scene == SceneMatchLocal ->
			true;
		true ->
			false
	end.

%%是否等待场景
is_wait_scene(Scene) ->
	SceneMatch = data_holy_spirit_battlefield:get_kv(wait_scene),
	SceneMatchLocal = data_holy_spirit_battlefield:get_kv(wait_scene_local),
	if
		Scene == SceneMatch ->
			true;
		Scene == SceneMatchLocal ->
			true;
		true ->
			false
	end.

%%是否pk场景
is_pk_scene(Scene) ->
	ScenePK = data_holy_spirit_battlefield:get_kv(pk_scene),
	ScenePKLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	%%
	if
		Scene == ScenePK orelse Scene == ScenePKLocal ->
			true;
		true ->
			false
	end.


%% 进入等待场景
pull_role_into_wait_scene(ServerId, RoleId, ZoneId, BattlefieldId) ->
%%	Scene = data_holy_spirit_battlefield:get_kv(wait_scene),
	Scene = lib_holy_spirit_battlefield:get_wait_scene(),
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[RoleId, Scene, ZoneId, BattlefieldId, true, [{group, 0}, {change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err218_in_act)}]]);
		_ ->
			lib_scene:player_change_scene(RoleId, Scene, ZoneId, BattlefieldId, true,
				[{group, 0}, {change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err218_in_act)}])
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述   玩家进入pk场景
%% @param    参数      RoleList::[#role_pk_msg]
%% @return   返回值    无
%% @history  修改历史
%% -----------------------------------------------------------------
pull_role_into_pk_scene(RoleList, ZoneId) ->
	[begin
		 {X, Y} = get_bron_xy(GroupId),
		 pull_role_into_pk_scene(ServerId, RoleId, ZoneId, CopyId, GroupId, X, Y)
	 end
		|| #role_pk_msg{group = GroupId, server_id = ServerId, copy_id = CopyId, role_id = RoleId} <- RoleList].

%% 进入pk场景
pull_role_into_pk_scene(ServerId, RoleId, ZoneId, CopyId, Group, X, Y) ->
%%	?MYLOG("holy", "RoleId ~p   ~p~n", [RoleId, Group]),
	add_temp_skill(RoleId, ServerId),
	Scene = lib_holy_spirit_battlefield:get_pk_scene(),
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[RoleId, Scene, ZoneId, CopyId, X, Y, false,
					[{group, Group}, {change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err218_in_act)}]]);
		_ ->
			lib_scene:player_change_scene(RoleId, Scene, ZoneId, CopyId, X, Y, false, [{group, Group},
				{change_scene_hp_lim, 100}, {action_lock, ?ERRCODE(err218_in_act)}])
	end.







quit_scene(ServerId, RoleId) ->
	skill_quit(RoleId, ServerId),
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {action_free, ?ERRCODE(err218_in_act)}]]);
		false ->
			lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {action_free, ?ERRCODE(err218_in_act)}])
	end.

role_msg_to_pk(RoleMsg) ->
	#role_pk_msg{
		role_id = RoleMsg#role_msg.role_id,
		role_name = RoleMsg#role_msg.role_name,
		server_id = RoleMsg#role_msg.server_id,
		copy_id = RoleMsg#role_msg.copy_id
		, pk_pid = RoleMsg#role_msg.pk_pid  %% 战斗进程
		, status = RoleMsg#role_msg.status
		, power = RoleMsg#role_msg.power
		, server_num = RoleMsg#role_msg.server_num
		, lv = RoleMsg#role_msg.lv
		, picture_id = RoleMsg#role_msg.picture_id
		, picture = RoleMsg#role_msg.picture
		, rank = 0   %%排名，用于分配，暂时用下，不可靠数据
		, turn = RoleMsg#role_msg.turn
		, career = RoleMsg#role_msg.career
	}.


%%
%%role_msg_to_pk(ServerId, RoleId, Power, CopyId, Pid, Status) ->
%%	#role_pk_msg{
%%		role_id = RoleId,
%%		server_id = ServerId,
%%		copy_id = CopyId
%%		, pk_pid = Pid  %% 战斗进程
%%		, status = Status
%%		, power = Power
%%		, rank = 0   %%排名，用于分配，暂时用下，不可靠数据
%%	}.



%% -----------------------------------------------------------------
%% @desc     功能描述  %%没有进入等待场景直接进入pk场景
%%					 %%如果玩家进入玩法时，房间分配阶段已经完成，则直接默认将玩家分配到当前人数最少的战场房间中
%%					 %%如果同时有多个房间人数一致，则默认进入平均战力最低的房间
%% @param    参数     Battlefield::#battlefield{}   MaxCopyId::integer()  最大房间值
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_role_copy_when_enter(#battlefield_msg{copy_list = []}, MaxCopyId) ->
	MaxCopyId + 1;
get_role_copy_when_enter(Battlefield, _MaxCopyId) ->
	#battlefield_msg{copy_list = CopyList} = Battlefield,
	F = fun(#copy_msg{num = NumA}, #copy_msg{num = NumB}) ->
		NumA < NumB
	    end,
	NewSortList = lists:sort(F, CopyList),
	#copy_msg{copy_id = CopyId} = hd(NewSortList),
	CopyId.



%% 发送经验定时器
get_exp_ref(OldRef) ->
	Time = data_holy_spirit_battlefield:get_kv(exp_time),
	util:send_after(OldRef, Time * 1000, self(), {add_exp}).



add_exp(PS) ->
%%	?MYLOG("holy", "add Exp++++++++++++++++", []),
	#player_status{id = RoleId, scene = Scene, figure = F} = PS,
	RewardList = data_holy_spirit_battlefield:get_exp(F#figure.lv),
%%	?MYLOG("holy", "add RewardList ~p", [RewardList]),
	WaitScene = data_holy_spirit_battlefield:get_kv(wait_scene),
	WaitSceneLocal = data_holy_spirit_battlefield:get_kv(wait_scene_local),
	if
		RewardList == [] ->
			skip;
		WaitScene == Scene orelse WaitSceneLocal == Scene ->
%%			?MYLOG("holy", "add RewardList ~p", [RewardList]),
			lib_goods_api:send_reward_with_mail(RoleId,
				#produce{reward = RewardList, type = holy_spirit_battlefield_exp, show_tips = ?SHOW_TIPS_3});
		true ->
			skip
	end,
	PS.

%%真实的增加经验数据，增加经验受世界等级，各种的影响
send_exp_by_cast(RoleId, ExpAdd) ->
%%	?MYLOG("holy", "ExpAdd ~p", [ExpAdd]),
	case is_local_mod() of
		true ->
			mod_holy_spirit_battlefield_local:add_exp(RoleId, ExpAdd);
		false ->
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, add_exp, [config:get_server_id(), RoleId, ExpAdd])
	end.



get_pack_reward(0, _Point, _Reward) ->
	[];
get_pack_reward(Mod, Point, Reward) ->
	PointList = data_holy_spirit_battlefield:get_role_reward_list(Mod),
	F = fun({Stage, NeedPoint}, AccList) ->
		if
			Point >= NeedPoint ->
				case lists:keyfind(Stage, 1, Reward) of
					{Stage, 0} ->  %%未领取 => 可以领取
						[{Stage, 1} | AccList];
					{Stage, 2} ->  %%已经领取
						[{Stage, 2} | AccList];
					_ ->  %%可以领取
						[{Stage, 1} | AccList]
				end;
			true ->  %% 不能领取
				[{Stage, 0} | AccList]
		end
	    end,
	lists:reverse(lists:foldl(F, [], PointList)).


add_point(PS, AddPoint, Mod) ->
	#player_status{holy_spirit_battlefield = HoleBattle, id = RoleId} = PS,
	#role_holy_spirit_battlefield{point = OldPint} = HoleBattle,
	NewHoleBattle = HoleBattle#role_holy_spirit_battlefield{point = OldPint + AddPoint, mod = Mod},
	save_role_holy_spirit_battlefield(RoleId, NewHoleBattle),
	PS#player_status{holy_spirit_battlefield = NewHoleBattle}.


%%增加个人疾风
add_point(PS, AddPoint) ->
	#player_status{holy_spirit_battlefield = HoleBattle, id = RoleId} = PS,
	#role_holy_spirit_battlefield{point = OldPint} = HoleBattle,
	NewHoleBattle = HoleBattle#role_holy_spirit_battlefield{point = OldPint + AddPoint},
	save_role_holy_spirit_battlefield(RoleId, NewHoleBattle),
	PS#player_status{holy_spirit_battlefield = NewHoleBattle}.


%% 根据战场id获得模式id   %% 战场id  = 服的模式 * 100 +  ceil(排名 / 模式)向上取证
get_mod_by_battlefield_id(BattleId) ->
	trunc(BattleId / 100).

%% 获取阵营id列表
get_group_list() ->
	data_holy_spirit_battlefield:get_group_list().

%% -----------------------------------------------------------------
%% @desc     功能描述   根据玩家排名 和阵营id数量来获取id
%% @param    参数       Rank::integer() 玩家排名  GroupNum::integer() 阵营数量
%% @return   返回值     GroupId
%% @history  修改历史
%% -----------------------------------------------------------------
get_group_id_by_rank(Rank, GroupNum, GroupIdList) ->
	TemDiv = (Rank - 1) div GroupNum,
	case (TemDiv rem 2) > 0 of
		true ->
			SelectGroupIdList = lists:reverse(GroupIdList);
		_ ->
			SelectGroupIdList = GroupIdList
	end,
	TemRem = Rank rem GroupNum,
	?IF(TemRem == 0, lists:last(SelectGroupIdList), lists:nth(TemRem, SelectGroupIdList)).
	%%(Rank rem GroupNum) + 1.  %% 取余然后 + 1  保证id在  区间 [1, GroupNum]中

%% 初始化，阵营列表
init_battle_group_list(GroupIdList) ->
	[#battle_group{group_id = Id} || Id <- GroupIdList].



%% -----------------------------------------------------------------
%% @desc     功能描述    pk中增加玩家的积分， 并且返回阵营
%% @param    参数        RoleList::[#role_pk_msg{}] AddPoint::integer() 增加的积分 RoleId::integer() 增加积分玩家
%% @return   返回值     {NewRoleList, Group(阵营)}
%% @history  修改历史
%% -----------------------------------------------------------------
add_battle_role_point(RoleId, RoleList, AddPoint, PointPid) ->
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{group = GroupId} = Role ->
			mod_holy_spirit_battlefield_room_point:add_point(PointPid, Role, AddPoint),
			GroupId;
		_ ->
			0
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述    pk中增加玩家的积分, 返回需要增加积分的分组
%% @param    参数       RoleList::[#role_pk_msg{}] AddPoint::integer() 增加的积分 RoleId::integer() 增加积分玩家
%% @return   返回值     {NewRoleList, [{Group, AddPoint}]}
%% @history  修改历史
%% -----------------------------------------------------------------
add_battle_role_point(RoleList, AddPoint) ->
	F = fun(#role_pk_msg{status = Status, group = GroupId, point = RoleOldPoint} = Role, {AccRoleList, SumList}) ->
		if
			Status == ?in_act ->
				NewSumList =
					case lists:keyfind(GroupId, 1, SumList) of
						{GroupId, OldPoint} ->
							lists:keystore(GroupId, 1, SumList, {GroupId, OldPoint + AddPoint});
						_ ->
							lists:keystore(GroupId, 1, SumList, {GroupId, AddPoint})
					end,
				{[Role#role_pk_msg{point = RoleOldPoint + AddPoint} | AccRoleList], NewSumList};
			true ->
				{[Role | AccRoleList], SumList}
		end
	    end,
	lists:foldl(F, {[], []}, RoleList).



add_battle_role_point_to_point_process(RoleList, AddPoint, Pid) ->
	RoleListNew = [Role || #role_pk_msg{status = Status} = Role <- RoleList, Status == ?in_act],
	mod_holy_spirit_battlefield_room_point:add_point_list(Pid, RoleListNew, AddPoint).




%% -----------------------------------------------------------------
%% @desc     功能描述    pk中增加玩家的积分， 并且返回阵营
%% @param    参数        GroupList::[#battle_group{}] AddPoint::integer() 增加的积分 GroupId::integer() 增加积分的阵营Id
%% @return   返回值     NewGroupList
%% @history  修改历史
%% -----------------------------------------------------------------
add_group_point(GroupId, GroupList, AddPoint) ->
	case lists:keyfind(GroupId, #battle_group.group_id, GroupList) of
		#battle_group{point = OldPoint} = Group ->
			lists:keystore(GroupId, #battle_group.group_id, GroupList, Group#battle_group{point = OldPoint + AddPoint});
		_ ->
			GroupList
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述    pk中增加玩家的积分， 并且返回阵营
%% @param    参数       GroupList::[#battle_group{}] GroupAddPointMsg::[{group_id, AddPoint}]
%% @return   返回值     NewGroupList
%% @history  修改历史
%% -----------------------------------------------------------------
add_group_point(GroupList, GroupAddPointMsg) ->
	F = fun({GroupId, AddPoint}, AccGroupList) ->
		add_group_point(GroupId, AccGroupList, AddPoint)
	    end,
	lists:foldl(F, GroupList, GroupAddPointMsg).

%% -----------------------------------------------------------------
%% @desc     功能描述   处理塔被摧毁时的逻辑
%% @param    参数      MonId::integer() 塔怪di   GroupId::integer() 分组id TowerList::[#tower{}]
%% @return   返回值    {TowerList, OldGroupId(旧的分组)}
%% @history  修改历史
%% -----------------------------------------------------------------
handle_tower_be_kill(MonId, ZoneId, CopyId, GroupId, TowerList) ->
	PkScene = lib_holy_spirit_battlefield:get_pk_scene(),
%%	?MYLOG("holy", "TowerList  ~p~n", [TowerList]),
	case lists:keyfind(MonId, #tower.mon_id, TowerList) of
		#tower{x = X, y = Y, group = OldGroup, mon_list = MonList} = Tower ->
%%			?MYLOG("holy", "MonId  ~p~n", [MonId]),
%%			?MYLOG("holy", "MonId  ~p~n", [{MonId, PkScene, ZoneId, X, Y, 0, CopyId, true, [{group, GroupId}]}]),
			NewMonId = lib_holy_spirit_battlefield:get_tower_by_group(GroupId, MonList),
			MonAutoId = lib_mon:sync_create_mon(NewMonId, PkScene, ZoneId, X, Y, 0, CopyId, true, [{group, GroupId}, {mod_args, {battle_pid, self()}}]),
			NewTower = Tower#tower{group = GroupId, mon_id = NewMonId, aid = MonAutoId},
			NewTowerList = lists:keydelete(MonId, #tower.mon_id, TowerList),
			{lists:keystore(MonId, #tower.mon_id, NewTowerList, NewTower), OldGroup};
		_ ->
			{TowerList, 0}
	end.


%% 获取组内的玩家
get_group_role_list(GroupId, RoleList) ->
	[Role || #role_pk_msg{group = RoleGroupId} = Role <- RoleList, RoleGroupId == GroupId].

%% -----------------------------------------------------------------
%% @desc     功能描述  发送场景内的 21807协议
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_battle_msg_to_client(State) ->
	#battle_state{group_list = GroupList, role_list = RoleList} = State,
	SortGroupList = sort_battle_group(GroupList),
	RankGroupList = set_rank_battle_group(SortGroupList),
	[begin
		 GroupRoleList = get_group_role_list(GroupId, RoleList),
		 SortRoleList = sort_pk_role_by_point(GroupRoleList),
		 RankRoleList = set_rank_pk_role(SortRoleList),
		 [begin
			  {ok, Bin} = pt_218:write(21807, [Point, RoleRank, GroupRank, Anger, AngerEndTime, BuffList]),
			  send_to_client(ServerId, RoleId, Bin)
		  end
			 || #role_pk_msg{server_id = ServerId, anger_end = AngerEndTime,
			 role_id = RoleId, point = Point, rank = RoleRank, buff_list = BuffList, anger = Anger} <- RankRoleList]
	 end
		|| #battle_group{group_id = GroupId, rank = GroupRank} <- RankGroupList].


%% -----------------------------------------------------------------
%% @desc     功能描述  发送场景内的 21807协议  给变化值的人
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_battle_msg_to_client(State, ServerId, RoleId, GroupId) ->
	#battle_state{group_list = GroupList, role_list = RoleList} = State,
	SortGroupList = sort_battle_group(GroupList),
	RankGroupList = set_rank_battle_group(SortGroupList),
	{Point, RoleRank, Anger, AngerEndTime, BuffList} = get_role_pack(RoleList, RoleId),
	GroupRank = get_group_rank(GroupId, RankGroupList),
	{ok, Bin} = pt_218:write(21807, [Point, RoleRank, GroupRank, Anger, AngerEndTime, BuffList]),
	send_to_client(ServerId, RoleId, Bin).
%%	[begin
%%		 GroupRoleList = get_group_role_list(GroupId, RoleList),
%%		 SortRoleList = sort_pk_role_by_point(GroupRoleList),
%%		 RankRoleList = set_rank_pk_role(SortRoleList),
%%		 [begin
%%			  {ok, Bin} = pt_218:write(21807, [Point, RoleRank, GroupRank, Anger, AngerEndTime, BuffList]),
%%			  send_to_client(ServerId, RoleId, Bin)
%%		  end
%%			 || #role_pk_msg{server_id = ServerId, anger_end = AngerEndTime,
%%			 role_id = RoleId, point = Point, rank = RoleRank, buff_list = BuffList, anger = Anger} <- RankRoleList]
%%	 end
%%		|| #battle_group{group_id = GroupId, rank = GroupRank} <- RankGroupList].


%% -----------------------------------------------------------------
%% @desc     功能描述  发送场景内的 21807协议
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_battle_msg_to_client(State, RoleId) ->
	#battle_state{role_list = RoleList} = State,
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{server_id = ServerId, group = GroupId} ->
			send_battle_msg_to_client(State, ServerId, RoleId, GroupId);
		_ ->
			skip
	end.
%%	SortGroupList = sort_battle_group(GroupList),
%%	RankGroupList = set_rank_battle_group(SortGroupList),
%%	[begin
%%		 GroupRoleList = get_group_role_list(GroupId, RoleList),
%%		 SortRoleList = sort_pk_role_by_point(GroupRoleList),
%%		 RankRoleList = set_rank_pk_role(SortRoleList),
%%		 case lists:keyfind(RoleId, #role_pk_msg.role_id, RankRoleList) of
%%			 #role_pk_msg{server_id = ServerId, role_id = RoleId, anger_end = AngerEndTime, anger = Anger,
%%				 point = Point, rank = RoleRank, buff_list = BuffList} ->
%%				 {ok, Bin} = pt_218:write(21807, [Point, RoleRank, GroupRank, Anger, AngerEndTime, BuffList]),
%%				 send_to_client(ServerId, RoleId, Bin);
%%			 _ ->
%%				 ok
%%		 end
%%	 end
%%		|| #battle_group{group_id = GroupId, rank = GroupRank} <- RankGroupList].



%%%% -----------------------------------------------------------------
%%%% @desc     功能描述    塔的归属变了
%%%% @param    参数        OldGroupId::integer()  旧的分组  NewGroupId::integer() 新的分组   GroupList::[#battle_group{}]
%%%% @return   返回值
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%tower_change_group(OldGroupId, NewGroupId, GroupList) ->
%%	GroupList1 =
%%		case lists:keyfind(OldGroupId, #battle_group.group_id, GroupList) of
%%			#battle_group{}
%%		end,
%%	ok.

%% 占领了多少塔
get_tower_num(GroupId, TowerList) ->
	F = fun(#tower{group = TowerGroup}, Num) ->
		if
			TowerGroup == GroupId ->
				Num + 1;
			true ->
				Num
		end
	    end,
	lists:foldl(F, 0, TowerList).




%%=====================================db================================================
save_max_mod(ZoneId, MaxMod) ->
	Sql = io_lib:format(?save_max_mod, [ZoneId, MaxMod]),
	db:execute(Sql).


%% 玩家的圣灵战场信息
save_role_holy_spirit_battlefield(RoleId, HolyBattle) ->
	#role_holy_spirit_battlefield{mod = Mod, point = Point, reward = Reward} = HolyBattle,
	Sql = io_lib:format(?save_role_msg, [RoleId, Mod, Point, util:term_to_bitstring(Reward)]),
%%	?MYLOG("holy", "~s ~n", [Sql]),
	db:execute(Sql).



%%=====================================db================================================



%% -----------------------------------------------------------------
%% @desc     功能描述    鼓舞buff
%%                      玩法中，每隔一段时间，据点占领据点数量与占领据点最多的阵营有一定数量差距时
%%                      弱势阵营会根据据点占领差距获得一定的的增益buff
%%                      如：据点数量差为0时本阵营不获得任何buff
%%                      差为1时，本阵营获得5%属性加成
%%                      差为2时，本阵营获得10%属性加成，具体效果根据配置读取
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_role_buff(RoleList, TowerList) ->
	GroupOccupyList = get_group_occupy_tower(TowerList),
%%	?MYLOG("holy", "GroupOccupyList ~p~n", [GroupOccupyList]),
	case GroupOccupyList of
		[] ->
			RoleList;
		_ ->
			{_MaxGroupId, MaxNum} = hd(GroupOccupyList),
			handle_role_buff(GroupOccupyList, RoleList, MaxNum)
	end.




handle_role_buff(GroupOccupyList, RoleList, MaxNum) ->
	F = fun(#role_pk_msg{group = RoleGroupId, buff_list = OldBuff, server_id = ServerId, role_id = RoleId} = Role, AccList) ->
		case lists:keyfind(RoleGroupId, 1, GroupOccupyList) of
			{_, Num} ->
				DiffNum = max(MaxNum - Num, 0),  %% 站塔差距
				BuffList = get_buff_list(DiffNum),  %% 技能buff
				if
					BuffList == OldBuff ->
						[Role | AccList];
					true ->
						%% 改变buff
%%						?MYLOG("holy", "BuffList ~p~n", [BuffList]),
						change_role_pk_buff(ServerId, RoleId, BuffList),
						[Role#role_pk_msg{buff_list = BuffList} | AccList]
				end;
			_ ->
				[Role | AccList]
		end
	    end,
	lists:foldl(F, [], RoleList).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取阵营占领塔的信息
%% @param    参数       TowerList::[#tower]
%% @return   返回值     [{GroupId, Num}] {分组， 占领数量}, 且是有顺序的
%% @history  修改历史
%% -----------------------------------------------------------------
get_group_occupy_tower(TowerList) ->
	GroupIdList = get_group_list(),
	GroupOccupyList = [{_GroupId, 0} || _GroupId <- GroupIdList],
	F = fun(#tower{group = GroupId}, AccList) ->
		case lists:keyfind(GroupId, 1, AccList) of
			{GroupId, Num} ->
				lists:keystore(GroupId, 1, AccList, {GroupId, Num + 1});
			_ ->
				AccList
		end
	    end,
	ResList = lists:foldl(F, GroupOccupyList, TowerList),
	SortF = fun({_, NumA}, {_, NumB}) ->
		NumA >= NumB
	        end,
	lists:sort(SortF, ResList).



%%%% 获得技能buff的属性
%%get_buff_list(SkillId) ->
%%	case data_skill:get(SkillId, 1) of
%%		#skill{lv_data = Data} ->
%%			#skill_lv{base_attr = AttrList} = Data,
%%			[{AttrId, Value} || {_, AttrId, Value} <- AttrList];
%%		_ ->
%%			[]
%%	end.
%%
%%
%%get_buff_skill_id(DiffNum) ->
%%	BuffList =  data_holy_spirit_battlefield:get_kv(buff_list),
%%	case lists:keyfind(DiffNum, 1, BuffList) of
%%		{_, SkillId} ->
%%			SkillId;
%%		_ ->
%%			0
%%	end.


get_buff_list(DiffNum) ->
	BuffList = data_holy_spirit_battlefield:get_kv(buff_list),
	case lists:keyfind(DiffNum, 1, BuffList) of
		{_, BuffAttr} ->
			BuffAttr;
		_ ->
			[]
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述    更改玩家的buff属性
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
change_role_pk_buff(ServerId, RoleId, BuffList) ->
%%	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, change_role_pk_buff, [BuffList]),
%%	?MYLOG("holy", "change_role_pk_buff ~p~n", [BuffList]),
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
				[RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, change_role_pk_buff, [BuffList]]);
		_ ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, change_role_pk_buff, [BuffList])
	end.



change_role_pk_buff(PS, BuffList) ->
%%	?MYLOG("holy", "change_role_pk_buff ~p~n", [BuffList]),
	#player_status{holy_spirit_battlefield = HolyBattle} = PS,
	#role_holy_spirit_battlefield{} = HolyBattle,
	NewHolyBattle = HolyBattle#role_holy_spirit_battlefield{buff_list = BuffList},
	NewPS = PS#player_status{holy_spirit_battlefield = NewHolyBattle},
	LastPs = lib_player:count_player_attribute(NewPS),
	#player_status{battle_attr = BattleAttr} = PS,
	mod_scene_agent:update(LastPs, [{battle_attr, BattleAttr}]),  %% 更新场景
	lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
	LastPs.



%%获取buff
get_holy_spirit_battlefield_buff(PlayerStatus) ->
	#player_status{scene = Scene, holy_spirit_battlefield = HolyBattle} = PlayerStatus,
	case is_pk_scene(Scene) of
		true ->
			case HolyBattle of
				#role_holy_spirit_battlefield{buff_list = BuffAttr} ->
					BuffAttr;
				_ ->
					[]
			end;
		_ ->
			[]
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述   活动结束， 处理数据
%% @param    参数       BattlefieldList::[##battlefield_msg{}]
%% @return   返回值     NewBattlefieldList
%% @history  修改历史
%% -----------------------------------------------------------------
handle_battlefield_act_end(BattlefieldList) ->
	handle_battlefield_act_end(BattlefieldList, []).




handle_battlefield_act_end([], AccList) ->
	AccList;
handle_battlefield_act_end([Battle | BattlefieldList], AccList) ->
%%	#battlefield_msg{copy_list = CopyList} = Battle,
%%	[begin
%%		Pid ! {act_end}
%%	 end || #copy_msg{pk_pid = Pid}<-CopyList],
	handle_battlefield_act_end(BattlefieldList, [Battle#battlefield_msg{copy_list = [], role_list = []} | AccList]).



%% -----------------------------------------------------------------
%% @desc     功能描述   活动结束， 处理数据
%% @param    参数       BattlefieldList::[##battlefield_msg{}]
%% @return   返回值     NewBattlefieldList
%% @history  修改历史
%% -----------------------------------------------------------------
handle_battlefield_act_end_gm(BattlefieldList) ->
	handle_battlefield_act_end_gm(BattlefieldList, []).




handle_battlefield_act_end_gm([], AccList) ->
	AccList;
handle_battlefield_act_end_gm([Battle | BattlefieldList], AccList) ->
	#battlefield_msg{copy_list = CopyList} = Battle,
	[begin
		 Pid ! {act_end}
	 end || #copy_msg{pk_pid = Pid} <- CopyList],
	handle_battlefield_act_end_gm(BattlefieldList, [Battle#battlefield_msg{copy_list = [], role_list = []} | AccList]).



%% -----------------------------------------------------------------
%% @desc     功能描述   场景内的积分定时器
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_in_scene_point_ref(OldRef) ->
	Time = data_holy_spirit_battlefield:get_kv(scene_point_time),  %% 同时也是排序时间间隔
	util:send_after(OldRef, Time * 1000, self(), {scene_point}).


%% 占领塔给相应的阵营增加积分
handle_occupy_tower_point(RoleList, TowerList, PointPid) ->
	F = fun(#tower{group = GroupId}, GroupMsgList) ->
		case lists:keyfind(GroupId, 1, GroupMsgList) of
			{GroupId, TowerNum} ->
				lists:keystore(GroupId, 1, GroupMsgList, {GroupId, TowerNum + 1});
			_ ->
				[{GroupId, 1} | GroupMsgList]
		end
	    end,
	GroupMsgList1 = lists:foldl(F, [], TowerList),  %% [{分组， 占塔数量}]
	GroupMsgList2 = [{GroupId, data_holy_spirit_battlefield:get_kv(occupy) * TowerNum}
		|| {GroupId, TowerNum} <- GroupMsgList1],
	add_battle_role_point_by_group(RoleList, GroupMsgList2, PointPid).

%% -----------------------------------------------------------------
%% @desc     功能描述   增加个人积分
%% @param    参数       GroupMsgList2::[{groupId, AddPoint}]  RoleList::[#role_pk_msg]
%% @return   返回值    {NewRoleList, GroupAddPointMsg}  GroupAddPointMsg:: [{分组,  分组加的积分}]
%% @history  修改历史
%% -----------------------------------------------------------------
add_battle_role_point_by_group(RoleList, GroupMsgList, PointPid) ->
	F = fun(#role_pk_msg{status = Status, group = GroupId} = Role, {AccList, GroupAddPoint}) ->
		if
			Status == ?in_act ->
				case lists:keyfind(GroupId, 1, GroupMsgList) of
					{_, AddPoint} ->
						mod_holy_spirit_battlefield_room_point:add_point(PointPid, Role, AddPoint),
%%						NewRoleList = [Role#role_pk_msg{point = OldPoint + AddPoint} | AccList],
%%						NewGroupAddPoint =
%%							case lists:keyfind(GroupId, 1, GroupAddPoint) of
%%								{GroupId, GroupOldPoint} ->
%%									lists:keystore(GroupId, 1, GroupAddPoint, {GroupId, GroupOldPoint + AddPoint});
%%								_ ->
%%									lists:keystore(GroupId, 1, GroupAddPoint, {GroupId, AddPoint})
%%							end,
						{AccList, GroupAddPoint};
					_ ->
						{[Role | AccList], GroupAddPoint}
				end;
			true ->
				{[Role | AccList], GroupAddPoint}
		end
	    end,
	lists:foldl(F, {[], []}, RoleList).
%%	NewRoleList = [Role || #role_pk_msg{status = Status} = Role<- RoleList, Status == ?in_act],
%%	mod_holy_spirit_battlefield_room_point:add_point_list(PointPid, NewRoleList)

%% 获得助攻者id
get_assist_role_id_list(KillRoleId, HitList, RoleList) ->
	AssistIds = [RoleId || #hit{id = RoleId} <- HitList, RoleId =/= KillRoleId],
	KillGroup = case lists:keyfind(KillRoleId, #role_pk_msg.role_id, RoleList) of
		            #role_pk_msg{group = GroupId} ->
			            GroupId;
		            _ ->
			            0
	            end,
	F = fun(#role_pk_msg{group = GroupId, role_id = RoleId1}, Ids) ->
		if
			GroupId =/= KillGroup ->  %% 不同组
				Ids;
			true ->
				case lists:member(RoleId1, AssistIds) of
					true ->
						[RoleId1 | Ids];
					_ ->
						Ids
				end
		end
	    end,
	lists:foldl(F, [], RoleList).



%% -----------------------------------------------------------------
%% @desc     功能描述    pk中增加玩家的积分， 并且返回阵营
%% @param    参数        RoleList::[#role_pk_msg{}] AddPoint::integer() 增加的积分 RoleIds::[integer()] 增加积分玩家
%% @return   返回值     {NewRoleList, Group(阵营)}
%% @history  修改历史
%% -----------------------------------------------------------------
add_role_point_by_role_ids(RoleList, RoleIds, AddPoint, PointPid) ->
	[mod_holy_spirit_battlefield_room_point:add_point(PointPid, Role, AddPoint) ||
		#role_pk_msg{role_id = RoleId} = Role <- RoleList, lists:member(RoleId, RoleIds) == true].
%%	F = fun(#role_pk_msg{role_id = RoleId, point = RoleOldPoint, group = GroupId} = Role, {AccRoleList, GroupList}) ->
%%		case lists:member(RoleId, RoleIds) of
%%			true ->
%%				NewRoleList = [Role#role_pk_msg{point = RoleOldPoint + AddPoint} | AccRoleList],
%%				case lists:keyfind(GroupId, 1, GroupList) of
%%					{GroupId, GroupOldPoint} ->
%%						{NewRoleList, lists:keystore(GroupId, 1, GroupList, {GroupId, AddPoint + GroupOldPoint})};
%%					_ ->
%%						{NewRoleList, lists:keystore(GroupId, 1, GroupList, {GroupId, AddPoint})}
%%				end;
%%			_ ->
%%				{[Role | AccRoleList], GroupList}
%%		end
%%	    end,
%%	lists:foldl(F, {[], []}, RoleList).



%% -----------------------------------------------------------------
%% @desc     功能描述    增加助攻次数
%% @param    参数        RoleIdList::[RoleId]  AssistCount::integer()  助攻次数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
add_assist_count(RoleList, RoleIdList, AssistCount) ->
	F = fun(#role_pk_msg{role_id = RoleId, assist = OldCount} = Role, AccList) ->
		case lists:member(RoleId, RoleIdList) of
			true ->
				[Role#role_pk_msg{assist = OldCount + AssistCount} | AccList];
			false ->
				[Role | AccList]
		end
	    end,
	lists:foldl(F, [], RoleList).




%% -----------------------------------------------------------------
%% @desc     功能描述   玩家被杀后的逻辑，    清除连杀=》增加怒气=》通知客户端
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_be_kill(RoleList, DefRoleId, KillRoleId, PointPid) ->
	MaxAnger = data_holy_spirit_battlefield:get_kv(max_anger),
	case lists:keyfind(DefRoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{anger = OldAnger, server_id = DefServerId} = Role ->
			Add = data_holy_spirit_battlefield:get_kv(anger),
			NewAnger = min(OldAnger + Add, MaxAnger),
			set_energy(DefServerId, DefRoleId, NewAnger),
			NewRoleList = lists:keystore(DefRoleId, #role_pk_msg.role_id, RoleList,
				Role#role_pk_msg{continue_kill = 0, anger = NewAnger}),
			case lists:keyfind(KillRoleId, #role_pk_msg.role_id, NewRoleList) of
				#role_pk_msg{role_name = RoleName, lv = RoleLv, power = Power,
					picture_id = PictureId, picture = Picture, server_id = ServerId, turn = Turn, career = Career} ->
					{ok, Bin} = pt_218:write(21809, [RoleName, KillRoleId, RoleLv, Power, PictureId, Picture, min(OldAnger + Add, MaxAnger), ServerId, Career, Turn]),
					lib_holy_spirit_battlefield:send_to_client(DefServerId, DefRoleId, Bin);
				_ ->
					sikp
			end,
			add_battle_role_point(DefRoleId, RoleList, 0, PointPid),
			NewRoleList;
		_ ->
			RoleList
	end.


handle_kill_enemy(RoleList, KillId, ZoneId, CopyId) ->
	Scene = lib_holy_spirit_battlefield:get_pk_scene(),
	case lists:keyfind(KillId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{continue_kill = Count, role_name = RoleName, kill_num = KillNum} = Role ->
			KillTv = data_holy_spirit_battlefield:get_kv(kill_tv),
			%% 3 的倍数才发
			Flag = (Count + 1) rem 3,
			if
				Count + 1 >= KillTv andalso Flag == 0 ->
					%%广播
					lib_chat:send_TV({scene, Scene, ZoneId, CopyId}, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 2, [RoleName, Count + 1]);
%%					mod_clusters_center:apply_to_all_node(lib_chat, send_TV,
%%						[{scene, Scene, ZoneId, CopyId}, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 2, [RoleName, Count + 1]]);
				true ->
					skip
			end,
			lists:keystore(KillId, #role_pk_msg.role_id, RoleList, Role#role_pk_msg{continue_kill = Count + 1, kill_num = KillNum + 1});
		_ ->
			RoleList
	end.



get_group_name(GroupId) ->
	data_holy_spirit_battlefield:get_group_name(GroupId).



get_tower_name(MonId) ->
	case data_mon:get(MonId) of
		#mon{name = Name} ->
			Name;
		_ ->
			<<>>
	end.


%% 返回  [{group, TowerNun, Point}]  且有序
get_group_res_msg(GroupList, TowerList) ->
	F = fun(#battle_group{group_id = GroupId, point = Point}, AccList) ->
		TowerNum = get_tower_num(GroupId, TowerList),
		[{GroupId, TowerNum, Point} | AccList]
	    end,
	List = lists:foldl(F, [], GroupList),
	SortF = fun({_, TowerA, PointA}, {_, TowerB, PointB}) ->
		if
			TowerA > TowerB ->
				true;
			TowerA == TowerB ->
				PointA >= PointB;
			true ->
				false
		end
	        end,
	lists:sort(SortF, List).



%% 更新 01 和 05协议
send_all_msg() ->
%%	case is_local_open() of
%%		true ->
%%			lib_activitycalen_api:success_end_activity(?MOD_HOLY_SPIRIT_BATTLEFIELD, 0);
%%		_ ->
%%			skip
%%	end,
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_holy_spirit_battlefield, send_all_msg, []) || RoleId <- IdList].



send_all_msg(PS) ->
	pp_holy_spirit_battlefield:handle(21801, PS, []),
	pp_holy_spirit_battlefield:handle(21805, PS, []),
	PS.


send_all_act_open() ->
	case is_local_open() orelse ?is_kf of
		true ->
			lib_activitycalen_api:success_start_activity(?MOD_HOLY_SPIRIT_BATTLEFIELD, 0);
		_ ->
			skip
	end,
	%% 删除积分
	Sql = io_lib:format(?set_role_msg, []),
	db:execute(Sql),
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_holy_spirit_battlefield, send_all_act_open, []) || RoleId <- IdList].



send_all_act_open(PS) ->  %% 活动开启，积分清0
	pp_holy_spirit_battlefield:handle(21801, PS, []),
	#player_status{holy_spirit_battlefield = HolyBattle, id = RoleId} = PS,
	case HolyBattle of
		#role_holy_spirit_battlefield{} ->
			NewHolyBattle = HolyBattle#role_holy_spirit_battlefield{point = 0, reward = [], battle_pid = []},
			save_role_holy_spirit_battlefield(RoleId, NewHolyBattle),
			NewPS = PS#player_status{holy_spirit_battlefield = NewHolyBattle},
			pp_holy_spirit_battlefield:handle(21805, NewPS, []),
			NewPS;
		_ ->
			PS
	end.


get_bron_xy(GroupId) ->
	case data_holy_spirit_battlefield:get_bron_xy(GroupId) of
		[{X, Y}] ->
			{X, Y};
		_ ->
			{0, 0}
	end.


%% 获得技能有效时间
get_anger_end_time(Skill) ->
	case data_skill:get(Skill, 1) of
		#skill{lv_data = LvData} ->
%%			?MYLOG("holy", "skill +++++++++++++++++ ~p ~n", [Skill]),
			#skill_lv{attr = Attr} = LvData,
%%			?MYLOG("holy", "skill Effect ~p  ~n", [Attr]),
			case Attr of
				[{_, _, _, _, _, _, TimeMs, _, _}] ->
%%					?MYLOG("holy", "skill +++++++++++++++++~n", []),
					utime:unixtime() + trunc(TimeMs / 1000);
				_ ->
					utime:unixtime()
			end;
		_ ->
			utime:unixtime()
	end.





revive(GroupId) ->
	{X, Y} = get_bron_xy(GroupId),
	[{x, X}, {y, Y}].



get_next_mod(Mod) ->
	min(Mod * 2, ?max_mod).




reborn(PS) ->
	#player_status{battle_attr = BA, scene = Scene, server_id = ServerId, id = RoleId} = PS,
	#battle_attr{hp = Hp} = BA,
%%	{X, Y} = get_bron_xy(GroupId),
	InPk = is_pk_scene(Scene),
	if
		Hp > 0 ->
			PS;
		InPk == true ->
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, revive,
				[ServerId, RoleId]),
			{_Result, NewPlayer} = lib_revive:revive(PS, 24),
			mod_scene_agent:update(NewPlayer, [{battle_attr, NewPlayer#player_status.battle_attr}]),
%%			NewPlayer = lib_scene:change_relogin_scene(PS#player_status{x = X, y = Y},
%%				[{change_scene_hp_lim, 100}]),
			NewPlayer;
		true ->
			PS
	end.


update_point_to_local(RoleList, Mod) ->
	[mod_clusters_center:apply_cast(ServerId, lib_holy_spirit_battlefield, update_point_to_local, [RoleId, Point, Mod])
		|| #role_pk_msg{point = Point, server_id = ServerId, role_id = RoleId, status = Status} <- RoleList, Status == ?in_act].


update_point_to_local_single(RoleList, Mod, RoleId) ->
%%	?MYLOG("holy2", "RoleId, Point, Mod ~p~n", [{RoleId, Point, Mod}]),
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{point = Point, server_id = ServerId, role_id = RoleId, status = ?in_act} ->
			mod_clusters_center:apply_cast(ServerId, lib_holy_spirit_battlefield, update_point_to_local, [RoleId, Point, Mod]);
		_ ->
			skip
	end.



update_point_to_local(RoleId, Point, Mod) ->
%%	?PRINT("RoleId, Point, Mod ~p~n", [{RoleId, Point, Mod}]),
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, update_point_to_local2, [Point, Mod]).




update_point_to_local2(PS, Point, Mod) ->
	#player_status{holy_spirit_battlefield = HolyBattle, id = RoleId} = PS,
	case HolyBattle of
		#role_holy_spirit_battlefield{} ->
			NewHolyBattle = HolyBattle#role_holy_spirit_battlefield{point = Point, mod = Mod},
			save_role_holy_spirit_battlefield(RoleId, NewHolyBattle),
			PS#player_status{holy_spirit_battlefield = NewHolyBattle};
		_ ->
			PS
	end.



%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_right_group_before_enter(GroupList) ->
	SortGroupList = lib_holy_spirit_battlefield:sort_battle_group_by_num(GroupList),
	hd(SortGroupList).




%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数        ServerList::[#server_msg{}]
%% @return   返回值      [{战场id, 平均世界等级, ServerList}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_avg_world_lv_order_by_battle_id(ServerList, Mod) ->
	get_avg_world_lv_order_by_battle_id(ServerList, Mod, []).




get_avg_world_lv_order_by_battle_id([], _Mod, List) ->
	[{BattleId, trunc(Lv / Num), ServerList} || {BattleId, Lv, Num, ServerList} <- List];
get_avg_world_lv_order_by_battle_id([Server | ServerList], Mod, AccList) ->
	#server_msg{rank = Rank, world_lv = Lv} = Server,
	BattleId = lib_holy_spirit_battlefield:get_battlefield_id(Mod, Rank),
	case lists:keyfind(BattleId, 1, AccList) of
		{BattleId, OldLv, Num, OldServerList} ->
			NewAccList = lists:keystore(BattleId, 1, AccList, {BattleId, OldLv + Lv, Num + 1, [Server | OldServerList]}),
			get_avg_world_lv_order_by_battle_id(ServerList, Mod, NewAccList);
		_ ->
			NewAccList = lists:keystore(BattleId, 1, AccList, {BattleId, Lv, 1, [Server]}),
			get_avg_world_lv_order_by_battle_id(ServerList, Mod, NewAccList)
	end.


%%本服是否开启
is_local_open() ->
	OpenDay = util:get_open_day(),
	List = data_holy_spirit_battlefield:get_kv(local_week),
	is_local_open(OpenDay, List).


is_local_open(_OpenDay, []) ->
	false;
is_local_open(OpenDay, [{Day1, Day2, WeekList} | T]) ->
	Day = utime:day_of_week(),
	if
		OpenDay >= Day1 andalso OpenDay =< Day2 ->
			lists:member(Day, WeekList);
		true ->
			is_local_open(OpenDay, T)
	end.




send_open_TV() ->
%%	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 1, []]),
	case is_local_open() orelse ?is_kf of
		true ->
			lib_chat:send_TV({all}, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 1, []);
		_ ->
			skip
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获得默认分组的塔的怪物id
%% @param    参数      MonId::integer()
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_default_group_tower(MonList) ->
	case lists:keyfind(0, 1, MonList) of
		{_, MonId} ->
			MonId;
		_ ->
			0
	end.


get_tower_by_group(GroupId, MonList) ->
	case lists:keyfind(GroupId, 1, MonList) of
		{_, MonId} ->
			MonId;
		_ ->
			0
	end.

get_need_energy(_SkillId) ->
	data_holy_spirit_battlefield:get_kv(max_anger).


%%添加临时技能
add_temp_skill(PlayerId, ServerId) ->
	SkillId = data_holy_spirit_battlefield:get_kv(anger_skill),
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_skill_api, add_tmp_skill_list, [PlayerId, [{SkillId, 1}]]);
		_ ->
			lib_skill_api:add_tmp_skill_list(PlayerId, [{SkillId, 1}])
	end.




%%临时技能离场
skill_quit(PlayerId, ServerId) ->
	SkillId = data_holy_spirit_battlefield:get_kv(anger_skill),
	SkillList = [{SkillId, 1}],
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(ServerId, lib_skill_api, del_tmp_skill_list, [PlayerId, [{SkillId, 1}]]);
		_ ->
			lib_skill_api:del_tmp_skill_list(PlayerId, SkillList)
	end.

%%	%%设置能量
%%	lib_skill_api:set_energy(PlayerId, 0).



user_anger_skill(ServerId, RoleId) ->
	?PRINT("use_anger_skill   ~n", []),
	case util:is_cls() of
		true ->
			mod_clusters_node:apply_cast(mod_holy_spirit_battlefield, use_anger_skill, [ServerId, RoleId]);
		_ ->
			mod_holy_spirit_battlefield_local:use_anger_skill(ServerId, RoleId)

	end.



handle_af_battle_success(PS) ->
	#player_status{holy_spirit_battlefield = HolyBattle} = PS,
	Now = utime:unixtime(),
%%	?MYLOG("holy_buff", "HolyBattle ~p  Now ~p  ~n", [HolyBattle, Now]),
	case HolyBattle of
		#role_holy_spirit_battlefield{buff_time = Time} when Time >= Now ->
			BuffId = data_holy_spirit_battlefield:get_kv(reborn_skill),
			lib_skill_buff:clean_buff(PS, BuffId),
			NewHolyBattle = HolyBattle#role_holy_spirit_battlefield{buff_time = 0},
			PS#player_status{holy_spirit_battlefield = NewHolyBattle};
		_ ->
			PS
	end.



get_reborn_buff_time() ->
	SkillId = data_holy_spirit_battlefield:get_kv(reborn_skill),
%%	[{106,1,1000,1,0,0,0,10000,0,1}]
	case data_skill:get_lv_data(SkillId, 1) of
		#skill_lv{effect = Effect} ->
			case Effect of
				[{_, _, _, _, _, _, _, Time, _, _} | _] ->
					trunc(Time / 1000) + utime:unixtime();
				_ ->
					utime:unixtime()
			end;
		_ ->
			utime:unixtime()
	end.


update_buff_time(PS, BuffTime) ->
%%	?MYLOG("holy_buff", "Bufftime ~p,  Times  ~p~n", [BuffTime, utime:unixtime()]),
	#player_status{holy_spirit_battlefield = RoleHolyBattle} = PS,
	case RoleHolyBattle of
		#role_holy_spirit_battlefield{} ->
			PS#player_status{holy_spirit_battlefield = RoleHolyBattle#role_holy_spirit_battlefield{buff_time = BuffTime}};
		_ ->
			PS
	end.





check_skill_has_learn(Status, _SkillId) ->
	#player_status{scene = Scene} = Status,
	case is_pk_scene(Scene) of
		true ->
			true;
		_ ->
			false
	end.




%% 打包数据  return  {Point, RoleRank, Anger, AngerEndTime, BuffList}
get_role_pack(RoleList, RoleId) ->
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{point = Point, rank = RoleRank, anger = Anger, anger_end = AngerEndTime, buff_list = BuffList} ->
			{Point, RoleRank, Anger, AngerEndTime, BuffList};
		_ ->
			{0, 0, 0, 0, []}
	end.


get_group_rank(GroupId, SortGroupList) ->
	case lists:keyfind(GroupId, #battle_group.group_id, SortGroupList) of
		#battle_group{rank = Rank} ->
			Rank;
		_ ->
			0
	end.


gm_fake_join(JoinNum) -> gm_fake_join(JoinNum, 218, 0).
gm_fake_join(JoinNum, Module, SubModule) ->
	NeedLv = 1,
	Sql_player = io_lib:format("select w.id, n.accname from player_login as n left join player_low as w on w.id = n.id where w.lv > ~p", [NeedLv]),
	case db:get_all(Sql_player) of
		[] -> ok;
		Players ->
			F_clc = fun([Id, AccName], AccList) -> lists:keystore(AccName, 1, AccList, {AccName, Id}) end,
			JoinInfos = lists:sublist(lists:foldl(F_clc, [], Players), JoinNum),
			Now = utime:unixtime(),
			OnHookParams = [[RoleId, Module, SubModule, Now] || {_, RoleId} <- JoinInfos],
			Sql_onHook = usql:replace(role_activity_onhook_modules, [role_id, module_id, sub_module, select_time], OnHookParams),
			CoinParams = [[RoleId, 100, 0, Now] || {_, RoleId} <- JoinInfos],
			Sql_coin = usql:replace(role_activity_onhook_coin, [role_id, onhook_coin, exchange_left, coin_utime], CoinParams),
			Sql_onHook =/= [] andalso Sql_coin =/= [] andalso begin db:execute(Sql_onHook), db:execute(Sql_coin) end,
			lib_php_api:restart_process("{mod_activity_onhook, start_link, []}")
	end.



update_battle_pid(RoleId, BattlePid) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, update_battle_pid, [BattlePid]);
update_battle_pid(PS, BattlePid) ->
	#player_status{holy_spirit_battlefield = Holy} = PS,
%%	?MYLOG("holy", "battlePid  ~p~n", [BattlePid]),
	{ok, PS#player_status{holy_spirit_battlefield = Holy#role_holy_spirit_battlefield{battle_pid = BattlePid}}}.


%% -----------------------------------------------------------------
%% @desc     功能描述   是否本地模式
%% @param    参数
%% @return   返回值     true | false
%% @history  修改历史
%% -----------------------------------------------------------------
is_local_mod() -> %% todo  测试
	LocalOpenDay = util:get_open_day(),
	case data_holy_spirit_battlefield:get_mod_cfg(2) of %% 2服模式的最小开服天数
		#mod_cfg{open_day = OpenDay} ->
			if
				LocalOpenDay < OpenDay -> %% 天数不满足
					true;
				true ->
					ModId = mod_global_counter:get_count(?MOD_HOLY_SPIRIT_BATTLEFIELD, 1),
					if
						ModId >= 2 -> %% 如果模式id大于等于2 就是跨服模式，如果不是则是本服模式
							false;
						true ->
							true
					end
			end;
		_ -> %% 容错
			true
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述   在对应的节点获取不同的pk场景
%% @param    参数
%% @return   返回值     integer()
%% @history  修改历史
%% -----------------------------------------------------------------
get_pk_scene() ->
	case util:is_cls() of
		true ->
			data_holy_spirit_battlefield:get_kv(pk_scene);
		_ ->
			data_holy_spirit_battlefield:get_kv(pk_scene_local)
	end.


set_energy(DefServerId, DefRoleId, NewAnger) ->
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_cast(DefServerId, lib_skill_api, set_energy, [DefRoleId, NewAnger]);  %% 设置怒气值
		_ ->
			lib_skill_api:set_energy(DefRoleId, NewAnger)
	end.


get_wait_scene() ->
	case util:is_cls() of
		true ->
			data_holy_spirit_battlefield:get_kv(wait_scene);
		_ ->
			data_holy_spirit_battlefield:get_kv(wait_scene_local)
	end.