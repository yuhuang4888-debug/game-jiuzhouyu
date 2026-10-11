%%%-----------------------------------
%%% @Module      : lib_holy_spirit_battlefield_room_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 29. 十月 2019 10:49
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_holy_spirit_battlefield_room_mod).
-author("carlos").

-include("common.hrl").
-include("holy_spirit_battlefield.hrl").
-include("errcode.hrl").
-include("battle.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("attr.hrl").
%% API
-export([]).



%% -----------------------------------------------------------------
%% @desc     功能描述 房间匹配阶段结束后进入阵营匹配阶段
%%                  进行阵营匹配时先检测在战场房间的所有玩家战力，根据玩家战力排名随机分配至三个阵营
%%                  1~3名随机分配至各个阵营，4~6名随机分配一个阵营，依此类推直至所有玩家分配完毕
%%                  阵营分配完毕后正式开启战场战斗，并自动将所有玩家放入对应战场房间的各阵营出生点，并正式触发战斗阶段
%% @param    参数    RoleList::[#role_pk_msg{}]
%% @return   返回值  NewRoleList
%% @history  修改历史
%% -----------------------------------------------------------------
alloc_group(RoleList) ->
	GroupIdList = ulists:list_shuffle(lib_holy_spirit_battlefield:get_group_list()),
	GroupNum = length(GroupIdList),
	%% 排序，设置排名
	SortRoleList = lib_holy_spirit_battlefield:sort_pk_role(RoleList),
	RankRoleList = lib_holy_spirit_battlefield:set_rank_pk_role(SortRoleList),
	GroupList = lib_holy_spirit_battlefield:init_battle_group_list(GroupIdList),
	F = fun(#role_pk_msg{rank = Rank, power = RolePower} = Role, {AccRoleList, AccGroupList}) ->  %% 分组
		GroupId = lib_holy_spirit_battlefield:get_group_id_by_rank(Rank, GroupNum, GroupIdList),
		case lists:keyfind(GroupId, #battle_group.group_id, AccGroupList) of
			#battle_group{num = Num, power = OldPower} = BattleGroup ->
				NewBattleGroup = BattleGroup#battle_group{num = Num + 1, power = OldPower + RolePower},
				NewBattleGroupList = lists:keystore(GroupId, #battle_group.group_id, AccGroupList, NewBattleGroup),
				{[Role#role_pk_msg{group = GroupId} | AccRoleList], NewBattleGroupList};
			_ ->
				NewBattleGroup = #battle_group{num = 1, group_id = GroupId, power = RolePower},
				NewBattleGroupList = lists:keystore(GroupId, #battle_group.group_id, AccGroupList, NewBattleGroup),
				{[Role#role_pk_msg{group = GroupId} | AccRoleList], NewBattleGroupList}
		end
	    end,
	lists:foldl(F, {[], GroupList}, RankRoleList).




%% -----------------------------------------------------------------
%% @desc     功能描述   创建塔， ZoneId作为  场景进程id
%% @param    参数      ZoneId::小分区的id, copyId  房间id
%% @return   返回值    TowerList::[#tower{}]
%% @history  修改历史
%% -----------------------------------------------------------------
create_tower(ZoneId, CopyId) ->
	case data_holy_spirit_battlefield:get_kv(tower_list) of
		[_ | _] = MonList ->
			create_tower(ZoneId, CopyId, MonList);
		_ ->
			ok
	end.

%% MonList::[{MonId, X,Y}]
create_tower(ZoneId, CopyId, MonList) ->
	PkScene = data_holy_spirit_battlefield:get_kv(pk_scene),
	PkSceneLocal = data_holy_spirit_battlefield:get_kv(pk_scene_local),
	case util:is_cls() of
		true ->
			create_tower(PkScene, ZoneId, CopyId, MonList, []);
		_ ->
			create_tower(PkSceneLocal, ZoneId, CopyId, MonList, [])
	end.
	



create_tower(_PkScene, _ZoneId, _CopyId, [], TowerList) ->
	TowerList;
create_tower(PkScene, ZoneId, CopyId, [{MonList, X, Y} | TMonList], TowerList) ->
	MonId = lib_holy_spirit_battlefield:get_default_group_tower(MonList),
	MonAid = lib_mon:sync_create_mon(MonId, PkScene, ZoneId, X, Y, 0, CopyId, true, [{mod_args, {battle_pid, self()}}]),
	Tower = #tower{mon_id = MonId, aid = MonAid, group = 0, x = X, y = Y, mon_list = MonList},
	create_tower(PkScene, ZoneId, CopyId, TMonList, [Tower | TowerList]).

%% -----------------------------------------------------------------
%% @desc     功能描述  怪物被击杀=>  占领据点时，获得据点的最后一击获得据点占领积分
%% @param    参数     Atter::##battle_return_atter  Klist::[#mon_atter{}]  MonId::怪物configId
%% @return   返回值   NewState
%% @history  修改历史
%% -----------------------------------------------------------------
kill_mon(Atter, _Klist, MonId, State) ->
	#battle_return_atter{id = KillId} = Atter,
	#battle_state{role_list = RoleList, tower_list = TowerList, group_list = _GroupList, zone_id = ZoneId, copy_id = CopyId, mod = _ModId,
		point_pid = PointPid} = State,
	AddPoint = data_holy_spirit_battlefield:get_kv(destroy), %% 击杀怪物得分
	case lists:keyfind(KillId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{group = NewGroupId} ->
			skip;
		_ ->
			NewGroupId = 0
	end,
	%% 添加传闻
	%% 获得阵营名字
	GroupName = lib_holy_spirit_battlefield:get_group_name(NewGroupId),
	MonName = lib_holy_spirit_battlefield:get_tower_name(MonId),  %% 塔的名字
	PkScene = lib_holy_spirit_battlefield:get_pk_scene(),
	lib_chat:send_TV({scene, PkScene, ZoneId, CopyId}, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 3, [GroupName, MonName]),
%%	NewGroupList = lib_holy_spirit_battlefield:add_group_point(NewGroupId, GroupList, AddPoint),  %% 加阵营积分
	%%处理塔怪
	{NewTowerList, _OldGroupId} = lib_holy_spirit_battlefield:handle_tower_be_kill(MonId, ZoneId, CopyId, NewGroupId, TowerList),
%%	NewGroupList1 = lib_holy_spirit_battlefield:tower_change_group(OldGroupId, NewGroupId, NewGroupList),  %%处理塔的变化
	BuffRoleList = lib_holy_spirit_battlefield:handle_role_buff(RoleList, NewTowerList),
	lib_holy_spirit_battlefield:add_battle_role_point(KillId, BuffRoleList, AddPoint, PointPid), %% 加玩家积分
	NewState = State#battle_state{role_list = BuffRoleList, tower_list = NewTowerList},
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState), %% 广播
%%	?MYLOG("holy", "NewTowerList  ~p~n", [NewTowerList]),
%%	lib_holy_spirit_battlefield:update_point_to_local_single(BuffRoleList, ModId, KillId),
	%% 广播怪物信息
	%%  排序
	mod_holy_spirit_battlefield_room_point:sort(PointPid, []),
	broadcast_mon_msg(0, MonId, ZoneId, CopyId, 0, 0),  %%% 广播死亡信息
	broadcast_mon_msg(ZoneId, CopyId, NewTowerList),
	NewState.

mon_be_hurt(Atter, _MonAutoId, _MonId, _PoolId, _CopyId, _Hp, _Group, State) ->
	#battle_return_atter{id = KillId} = Atter,
	#battle_state{role_list = RoleList, point_pid = PointPid} = State,
	AddPoint = data_holy_spirit_battlefield:get_kv(attack), %% 伤害怪物得分
	lib_holy_spirit_battlefield:add_battle_role_point(KillId, RoleList, AddPoint, PointPid), %% 加玩家积分
%%	NewGroupList = lib_holy_spirit_battlefield:add_group_point(NewGroupId, GroupList, AddPoint),  %% 加阵营积分
	NewState = State,
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState), %% 广播
%%	?MYLOG("holy", "NewState  ~p~n", [NewState]),
%%	lib_holy_spirit_battlefield:update_point_to_local_single(NewRoleList, ModId, KillId),
	%% 广播怪物信息
%%	broadcast_mon_msg(MonAutoId, MonId, PoolId, CopyId, Hp, Group),
	NewState.



%% -----------------------------------------------------------------
%% @desc     功能描述  活动结束  计算奖励 => 脱离场景
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
act_end(State) ->
	#battle_state{role_list = RoleList, zone_id = ZoneId,
		copy_id = CopyId, tower_list = TowerList, group_list = _GroupList, mod = _Mod, point_pid = PointPid} = State,
	Scene = lib_holy_spirit_battlefield:get_pk_scene(),
	mod_holy_spirit_battlefield_room_point:act_end(PointPid, TowerList, ZoneId, CopyId),
%%	%% 计算奖励
%%	SortGroupList = lib_holy_spirit_battlefield:get_group_res_msg(GroupList, TowerList),  %% [{group, towerNum, point}]
%%	case data_holy_spirit_battlefield:get_battle_reward(Mod) of
%%		[] ->
%%			WinReward = [], FailReward = [];
%%		{WinReward, FailReward} ->
%%			ok
%%	end,
%%	{WinGroupId, _, _} = hd(SortGroupList),
%%	%% 阵营日志
%%	lib_log_api:log_holy_battle_pk_group(ZoneId, CopyId, Mod, SortGroupList),
%%
%%	F = fun({GroupId, _, _}) ->
%%		case lib_holy_spirit_battlefield:get_group_role_list(GroupId, RoleList) of
%%			[_ | _] = GroupRoleList ->
%%				Res = if
%%					      WinGroupId == GroupId ->
%%						      Reward = WinReward,
%%						      1;
%%					      true ->
%%						      Reward = FailReward,
%%						      0
%%				      end,
%%
%%
%%				SortRoleList = lib_holy_spirit_battlefield:sort_pk_role_by_point(GroupRoleList),
%%				RankRoleList = lib_holy_spirit_battlefield:set_rank_pk_role(SortRoleList),
%%				[begin
%%					 if
%%						 Reward =/= [] ->
%%							 mod_clusters_center:apply_cast(ServerId, lib_goods_api, send_reward_with_mail,
%%								 [RoleId, #produce{reward = Reward, type = holy_spirit_battlefield_reward}]);
%%						 true ->
%%							 skip
%%					 end,
%%					 %% 日志
%%					 lib_log_api:log_holy_battle_pk_role(RoleId, ServerNum, ServerId, ZoneId, CopyId, RolePoint),
%%					 %%清理buff
%%					 lib_holy_spirit_battlefield:change_role_pk_buff(ServerId, RoleId, []),
%%					 lib_holy_spirit_battlefield:skill_quit(RoleId, ServerId),
%%					 {ok, Bin} = pt_218:write(21810, [Res, SortGroupList, GroupId, MyRank]),
%%					 lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin)
%%				 end
%%					|| #role_pk_msg{rank = MyRank, server_id = ServerId, role_id = RoleId, server_num = ServerNum, point = RolePoint} <- RankRoleList];
%%			_ ->
%%				skip
%%		end
%%	    end,
%%	lists:foreach(F, SortGroupList),
	%%脱离场景
	[lib_holy_spirit_battlefield:quit_scene(ServerId, RoleId) ||
		#role_pk_msg{role_id = RoleId, server_id = ServerId, status = Status} <- RoleList, Status == ?in_act],
	lib_scene:clear_scene_room(Scene, ZoneId, CopyId),
	#battle_state{}.



%% 发送场景积分
scene_point(State) ->
	#battle_state{role_list = RoleList, group_list = _GroupList, scene_point_ref = OldRef,
		tower_list = TowerList, mod = _ModId, point_pid = PointPid} = State,
	NewRef = lib_holy_spirit_battlefield:get_in_scene_point_ref(OldRef),
	AddPoint = data_holy_spirit_battlefield:get_kv(sence_point), %% 场景积分
	%% GroupAddPointMsg  [{GroupId, AddPoint}]
	lib_holy_spirit_battlefield:add_battle_role_point_to_point_process(RoleList, AddPoint, PointPid), %% 加玩家积分
%%	NewRoleList = RoleList,
%%	NewGroupList = GroupList,
%%	{NewRoleList2, GroupAddPointMsg2} = lib_holy_spirit_battlefield:handle_occupy_tower_point(NewRoleList, TowerList, PointPid), %% 加玩家积分
	lib_holy_spirit_battlefield:handle_occupy_tower_point(RoleList, TowerList, PointPid), %% 加玩家积分
%%	NewGroupList2 = lib_holy_spirit_battlefield:add_group_point(NewGroupList, GroupAddPointMsg2),  %% 加阵营积分
	NewState = State#battle_state{scene_point_ref = NewRef},
	mod_holy_spirit_battlefield_room_point:sort(PointPid, []),
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState), %% 广播
%%	lib_holy_spirit_battlefield:update_point_to_local(NewRoleList2, ModId),
%%	?MYLOG("holy", "NewState  ~p~n", [NewState]),
	NewState.

%% 场景内击杀对面
kill_enemy(Atter, DefRoleId, HitList, State) ->
	#battle_state{role_list = RoleList, zone_id = ZoneId, copy_id = CopyId, mod = _ModId, point_pid = PointPid} = State,
	#battle_return_atter{id = KillId} = Atter,
	AddPoint = data_holy_spirit_battlefield:get_kv(assists_integral), %%助攻积分
	KillAddPoint = data_holy_spirit_battlefield:get_kv(kill_integral), %%杀人积分积分
	RoleIdList = lib_holy_spirit_battlefield:get_assist_role_id_list(KillId, HitList, RoleList), %%助攻者id
	%%增加 助攻次数
	NewRoleList3 = lib_holy_spirit_battlefield:add_assist_count(RoleList, RoleIdList, 1),  %%
	NewRoleList4 = lib_holy_spirit_battlefield:handle_be_kill(NewRoleList3, DefRoleId, KillId, PointPid),     %%处理怒气，
	NewRoleList5 = lib_holy_spirit_battlefield:handle_kill_enemy(NewRoleList4, KillId, ZoneId, CopyId),  %% 处理连杀的
	
	
	%% 增加积分
	lib_holy_spirit_battlefield:add_role_point_by_role_ids(NewRoleList5, RoleIdList, AddPoint, PointPid),
%%	NewGroupList1 = lib_holy_spirit_battlefield:add_group_point(GroupList, AddPointGroupList),  %% 加阵营积分, 增加助攻者的积分
	lib_holy_spirit_battlefield:add_battle_role_point(KillId, NewRoleList5, KillAddPoint, PointPid),  %% 增加击杀者积分
%%	NewGroupList2 = lib_holy_spirit_battlefield:add_group_point(AddPointGroupId, NewGroupList1, KillAddPoint),  %% 加阵营积分, 击杀者积分

	NewState = State#battle_state{role_list = NewRoleList5},
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState),
%%	lib_holy_spirit_battlefield:update_point_to_local_single(NewRoleList5, ModId, KillId),
%%	[lib_holy_spirit_battlefield:update_point_to_local_single(NewRoleList5, ModId, TempRoleId) || TempRoleId <- RoleIdList],
	mod_holy_spirit_battlefield_room_point:sort(PointPid, []), %% 击杀排序一次
	NewState.


get_battle_all_msg(ServerId, RoleId, State) ->  %% todo
	#battle_state{tower_list = TowerList, point_pid = PointPid} = State,
%%	SortGroupList = lib_holy_spirit_battlefield:sort_battle_group(GroupList),
%%	RankGroupList = lib_holy_spirit_battlefield:set_rank_battle_group(SortGroupList),
%%	F = fun(Group, AccList) ->
%%		#battle_group{group_id = GroupId, point = Point, rank = GroupRank} = Group,
%%		TowerNum = lib_holy_spirit_battlefield:get_tower_num(GroupId, TowerList),
%%		GroupRoleList = lib_holy_spirit_battlefield:get_group_role_list(GroupId, RoleList),
%%		SortRoleList = lib_holy_spirit_battlefield:sort_pk_role_by_point(GroupRoleList),
%%		RankRoleList = lib_holy_spirit_battlefield:set_rank_pk_role(SortRoleList),
%%		PackList = pack_role_list(RankRoleList),
%%		[{GroupId, TowerNum, Point, GroupRank, PackList} | AccList]
%%	    end,
%%	FunRes = lists:reverse(lists:foldl(F, [], RankGroupList)),
%%	{ok, Bin} = pt_218:write(21808, [FunRes]),
	mod_holy_spirit_battlefield_room_point:get_battle_all_msg(PointPid, TowerList, ServerId, RoleId).
%%	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin).



pack_role_list(RankRoleList) ->
	[{RoleId, Rank, ServerId, ServerNum, Name, Point, KillNum, Assist} || #role_pk_msg{role_id = RoleId, rank = Rank, server_id = ServerId,
		server_num = ServerNum, role_name = Name, point = Point, kill_num = KillNum, assist = Assist} <- RankRoleList].




%%如果是在战斗阶段开始后进入房间的玩家，则会默认自动分配到当前人数最少的阵营中
%%如果当前同时存在多个阵营人数最少，则默认分配到阵营平均战力最低的阵营
%%若多个阵营人数和平均战力一样，则随机分配其中一个阵营即可
enter(RolePkMsg, State) ->
	#battle_state{role_list = RoleList, group_list = GroupList, end_time = EndTime,
		tower_list = TowerList, zone_id = ZoneId, copy_id = CopyId} = State,
	#role_pk_msg{role_id = RoleId, server_id = ServerId} = RolePkMsg,
	{ok, Bin2} = pt_218:write(21811, [?pk, EndTime]),
%%	?MYLOG("cym", "enter msg ~p~n", [TowerList]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin2),
	State1 =
		case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
			#role_pk_msg{status = ?in_act} ->
				State;
			#role_pk_msg{group = GroupId, buff_list = BuffList, anger = Anger} = Role -> %% 重新进来
				NewRole = Role#role_pk_msg{status = ?in_act},
				NewRoleList = lists:keystore(RoleId, #role_pk_msg.role_id, RoleList, NewRole),
				%% 拉入场景
				{X, Y} = lib_holy_spirit_battlefield:get_bron_xy(GroupId),
				lib_holy_spirit_battlefield:pull_role_into_pk_scene(ServerId, RoleId, ZoneId, CopyId, GroupId, X, Y),
%%				?MYLOG("buff", "roleid  ~p BuffList ~p~n", [RoleId, BuffList]),
				lib_holy_spirit_battlefield:change_role_pk_buff(ServerId, RoleId, BuffList),  %% 更新buff
				%% %% 重设怒气
				lib_holy_spirit_battlefield:set_energy(ServerId, RoleId, Anger),
%%				mod_clusters_center:apply_cast(ServerId, lib_skill_api, set_energy, [RoleId, Anger]),  %% 设置怒气值
				State#battle_state{role_list = NewRoleList};
			_ -> %% 新进来的的
				%%
				Group = lib_holy_spirit_battlefield:get_right_group_before_enter(GroupList),
				#battle_group{group_id = GroupId, num = OldNum, power = OldPower} = Group,
				NewRole = RolePkMsg#role_pk_msg{group = GroupId},
				%% 拉入场景
				{X, Y} = lib_holy_spirit_battlefield:get_bron_xy(GroupId),
				lib_holy_spirit_battlefield:pull_role_into_pk_scene(ServerId, RoleId, ZoneId, CopyId, GroupId, X, Y),
				NewRoleList = lists:keystore(RoleId, #role_pk_msg.role_id, RoleList, NewRole),
				NewGroupList = lists:keystore(GroupId, #battle_group.group_id, GroupList,
					Group#battle_group{num = OldNum + 1, power = OldPower + RolePkMsg#role_pk_msg.power}),
				NewRoleList2 = lib_holy_spirit_battlefield:handle_role_buff(NewRoleList, TowerList),
				State#battle_state{role_list = NewRoleList2, group_list = NewGroupList}
		end,
%%	#battle_state{role_list = RoleList1} = State1,
%%	BuffRoleList = lib_holy_spirit_battlefield:handle_role_buff(RoleList1, TowerList),
	%% 推送怪物信息
	get_mon_msg(ServerId, RoleId, ZoneId, CopyId, State1),
	State1.


quit(ServerId, RoleId, State) ->
	#battle_state{role_list = RoleList} = State,
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{} = Role ->
			NewRole = Role#role_pk_msg{status = 0},
			RoleList1 = lists:keystore(RoleId, #role_pk_msg.role_id, RoleList, NewRole),
%%			lib_holy_spirit_battlefield:quit_scene(ServerId, RoleId),
			%% 清理buff
			lib_holy_spirit_battlefield:change_role_pk_buff(ServerId, RoleId, []),
			State#battle_state{role_list = RoleList1};
		_ ->
			State
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述   玩家复活， 有可能要触发怒气技能
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
revive(ServerId, RoleId, State) ->
	#battle_state{role_list = RoleList, zone_id = _ZoneId} = State,
%%	PKScene = data_holy_spirit_battlefield:get_kv(pk_scene),
%%	MaxAnger = data_holy_spirit_battlefield:get_kv(max_anger),
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{} = _Role ->
%%			NewRole =
%%				if
%%					Anger >= MaxAnger ->
%%						Skill = data_holy_spirit_battlefield:get_kv(anger_skill),
%%						mod_scene_agent:apply_cast_with_state(PKScene, ZoneId, lib_skill_buff, add_buff, [RoleId, Skill, 1]),
%%						EndTime = lib_holy_spirit_battlefield:get_anger_end_time(Skill),
%%						Role#role_pk_msg{anger_end = EndTime, anger = 0};
%%					true ->
%%						Role
%%				end,
%%			NewRoleList = lists:keystore(RoleId, #role_pk_msg.role_id, RoleList, NewRole),
			Skill = data_holy_spirit_battlefield:get_kv(reborn_skill),
%%			?MYLOG("kill", "~p~n", [Skill]),
			%% 更新玩家状态
			BuffTime = lib_holy_spirit_battlefield:get_reborn_buff_time(),
%%			?MYLOG("kill", "BuffTime  ~p~n", [BuffTime]),
%%			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, update_buff_time, [BuffTime]),
			case util:is_cls() of
				true ->
					mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
						[RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, update_buff_time, [BuffTime]]),
					mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
						[RoleId, ?APPLY_CAST_SAVE, lib_skill_buff, add_buff, [Skill, 1]]);
				_ ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_holy_spirit_battlefield, update_buff_time, [BuffTime]),
					lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_skill_buff, add_buff, [Skill, 1])
			end,
%%			mod_scene_agent:apply_cast_with_state(PKScene, ZoneId, lib_skill_buff, add_buff, [RoleId, Skill, 1]),
			State;
		_ ->
			State
	end.


use_anger_skill(_ServerId, RoleId, State) ->
	#battle_state{role_list = RoleList, zone_id = _ZoneId, point_pid = PointPid} = State,
%%	MaxAnger = data_holy_spirit_battlefield:get_kv(max_anger),
	case lists:keyfind(RoleId, #role_pk_msg.role_id, RoleList) of
		#role_pk_msg{server_id = _ServerId, group = _GroupId} = Role ->
			NewRole = Role#role_pk_msg{anger_end = 0, anger = 0},
			NewRoleList = lists:keystore(RoleId, #role_pk_msg.role_id, RoleList, NewRole),
			%% 使用技能
			NewState = State#battle_state{role_list = NewRoleList},
			mod_holy_spirit_battlefield_room_point:add_point(PointPid, NewRole, 0),
			mod_holy_spirit_battlefield_room_point:sort(PointPid, []),
%%			lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState, ServerId, RoleId, GroupId), %%
			NewState;
		_ ->
			State
	end.


broadcast_mon_msg(MonAutoId, MonCfgId, PoolId, CopyId, Hp, Group) ->
	HpAll = get_mon_max_hp(MonCfgId),
	List = [{MonAutoId, MonCfgId, Hp, HpAll, Group}],
	{ok, Bin} = pt_218:write(21813, [List]),
	SceneId = lib_holy_spirit_battlefield:get_pk_scene(),
	lib_server_send:send_to_scene(SceneId, PoolId, CopyId, Bin).


broadcast_mon_msg(PoolId, CopyId, TowerList) ->
	SceneId = lib_holy_spirit_battlefield:get_pk_scene(),
	mod_scene_agent:apply_cast(SceneId, PoolId, lib_holy_spirit_battlefield_room_mod, broadcast_mon_msg_in_scene, [SceneId, PoolId, CopyId, TowerList]).

broadcast_mon_msg_in_scene(SceneId, PoolId, CopyId, TowerList) ->
	F = fun(#tower{aid = MonAutoId, mon_id = MonCfgId}, AccList) ->
			case lib_scene_object_agent:get_object(MonAutoId) of
				#scene_object{battle_attr = BA} ->
					HpAll = get_mon_max_hp(MonCfgId),
					[{MonAutoId, MonCfgId, BA#battle_attr.hp, HpAll, BA#battle_attr.group} | AccList];
				_ ->
					AccList
			end
		end,
	PackList = lists:foldl(F, [], TowerList),
	{ok, Bin} = pt_218:write(21813, [PackList]),
%%	SceneId = data_holy_spirit_battlefield:get_kv(pk_scene),
	lib_server_send:send_to_scene(SceneId, PoolId, CopyId, Bin).





get_mon_max_hp(MonCfgId) ->
	case data_mon:get(MonCfgId) of
		#mon{hp_lim = Hp} ->
			Hp;
		_ ->
			0
	end.


get_mon_msg(ServerId, RoleId, PoolId, CopyId, State) ->
	#battle_state{tower_list = TowerList} = State,
%%	?MYLOG("cym", "enter msg ~p~n", [TowerList]),
	send_mon_msg_to_single(PoolId, CopyId, TowerList, ServerId, RoleId).




send_mon_msg_to_single(PoolId, CopyId, TowerList, ServerId, RoleId) ->
%%	SceneId = data_holy_spirit_battlefield:get_kv(pk_scene),
	SceneId = lib_holy_spirit_battlefield:get_pk_scene(),
	mod_scene_agent:apply_cast(SceneId, PoolId, lib_holy_spirit_battlefield_room_mod, send_mon_msg_to_single_in_scene, [PoolId, CopyId, TowerList, ServerId, RoleId]).

send_mon_msg_to_single_in_scene(_PoolId, _CopyId, TowerList, ServerId, RoleId) ->
	F = fun(#tower{aid = MonAutoId, mon_id = MonCfgId}, AccList) ->
		case lib_scene_object_agent:get_object(MonAutoId) of
			#scene_object{battle_attr = BA} ->
				HpAll = get_mon_max_hp(MonCfgId),
				[{MonAutoId, MonCfgId, BA#battle_attr.hp, HpAll, BA#battle_attr.group} | AccList];
			_ ->
				AccList
		end
	    end,
	PackList = lists:foldl(F, [], TowerList),
%%	?MYLOG("cym", "enter msg ~p~n", [PackList]),
	{ok, Bin} = pt_218:write(21813, [PackList]),
%%	SceneId = data_holy_spirit_battlefield:get_kv(pk_scene),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin).



