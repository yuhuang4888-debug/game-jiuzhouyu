%%%-----------------------------------
%%% @Module      : lib_holy_spirit_battlefield_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 十月 2019 15:34
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_holy_spirit_battlefield_mod_local).
-include("holy_spirit_battlefield.hrl").
-include("clusters.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-author("carlos").



%% API
-export([]).





init() ->
%%	AllZone = mod_zone_mgr:get_all_zone(),
%%	?MYLOG("holy", "AllZone ~p~n", [AllZone]),
%%	GroupList = alloc_server_zone(AllZone),  %% 小跨服分区
%%	?MYLOG("holy", "GroupList ~p~n", [GroupList]),
	%%所有的模式
%%	ModList = data_holy_spirit_battlefield:get_mod_cfg_list(),
	%%分战场
%%	ZoneMap = alloc_battlefield(GroupList, lists:reverse(ModList)),
%%	?MYLOG("holy", "ZoneMap ~p~n", [ZoneMap]),
	Ref = lib_holy_spirit_battlefield:get_open_ref([]),
	#holy_spirit_battle_state{ref = Ref}.


%% -----------------------------------------------------------------
%% @desc     功能描述   服务器分区
%% @param    参数       ServerList::[#zone_base{}]
%% @return   返回值     #{}  Zone_id =>#server_group{}
%% @history  修改历史
%% -----------------------------------------------------------------
alloc_server_zone(ServerList) ->
	alloc_server_zone(ServerList, #{}).


alloc_server_zone([], Map) ->
	List = maps:to_list(Map),
	F = fun({ZoneId, ZoneGroup}, AccList) ->
		#server_group{server_list = ServerList, num = Num} = ZoneGroup,
		SortList = lib_holy_spirit_battlefield:sort_server(ServerList),
		NewSortList = lib_holy_spirit_battlefield:set_rank(SortList),
		AvgWorldLv = get_avg_world_lv(ServerList, Num),  %% 平均世界等级
		ModList = ModList = data_holy_spirit_battlefield:get_mod_cfg_list(),
		Mod = get_mod(AvgWorldLv, ModList),  %%模式
		OldMod = lib_holy_spirit_battlefield:get_max_mod_from_db(ZoneId),  %% 之前的最高模式
		MaxMod = max(OldMod, Mod),
		lib_holy_spirit_battlefield:save_max_mod(ZoneId, MaxMod),
		NewZoneGroup = ZoneGroup#server_group{max_mod = MaxMod, server_list = NewSortList},
		[{ZoneId, NewZoneGroup} | AccList]
	    end,
	TempList = lists:foldl(F, [], List),
	maps:from_list(TempList);
alloc_server_zone([BoneBase | ServerList], Map) ->
	#zone_base{zone = ZoneId, server_id = ServerId, time = Time, merge_ids = MergeIds, server_num = ServerNum
		, server_name = ServerName, world_lv = WorldLv} = BoneBase,
	Server =
		#server_msg{
			zone_id = ZoneId,
			server_id = ServerId,
			time = Time,
			merge_ids = MergeIds,
			server_num = ServerNum,
			server_name = ServerName,
			world_lv = WorldLv
		},
	Zone = maps:get(ZoneId, Map, #server_group{zone_id = ZoneId}),
	#server_group{num = Num, server_list = ServerMsgList} = Zone,
	NewServerList = lists:keystore(ServerId, #server_msg.server_id, ServerMsgList, Server),
	NewZone = Zone#server_group{server_list = NewServerList, num = Num + 1},
	NewMap = maps:put(ZoneId, NewZone, Map),
	alloc_server_zone(ServerList, NewMap).




%% -----------------------------------------------------------------
%% @desc     功能描述   根据分组来分战场
%%                     1.游戏中所有服务器将根据开服顺序每8个服务器为1个小组，比如1-8服为1个小组，8-16服为1个小组，以此类推
%%                     2.同个小组内的服务器将根据小组内的跨服世界等级和开服天数限制来决定服务器模式状态，然后和其他服一起进行玩法
%%                     3.跨服世界等级默认为小组内所有服务器的当前世界等级z平均值（如4服模式就取4个服的平均，8服就8个服的平均）
%% @param    参数      GroupMap:: zone_id => #server_group{},   ModList  [{模式, 最小世界等级, 最大世界等级, 开服天数}]]
%% @return   返回值    NewGroupMap
%% @history  修改历史
%% -----------------------------------------------------------------
alloc_battlefield(GroupMap, ModList) ->
	TempList = maps:to_list(GroupMap),
	F = fun({ZoneId, Group}, AccMap) ->
		NewGroup = alloc_battlefield_help(Group, ModList),
		maps:put(ZoneId, NewGroup, AccMap)
	    end,
	lists:foldl(F, #{}, TempList).


alloc_battlefield_help(Group, ModList) ->
	#server_group{server_list = ServerList, max_mod = _MaxMod} = Group,
%%	?MYLOG("holy", "ServerList ~p~n", [ServerList]),
%%	?MYLOG("holy", "ModList ~p~n", [ModList]),
	{NewServerList, BattleFieldList} = handle_server_mod(ServerList, ModList),
	Group#server_group{server_list = NewServerList, battlefield_list = BattleFieldList}.


get_avg_world_lv(ServerList, Num) ->
	F = fun(#server_msg{world_lv = Lv}, AccLv) ->
		Lv + AccLv
	    end,
	AllLv = lists:foldl(F, 0, ServerList),
	trunc(AllLv / Num).


%% -----------------------------------------------------------------
%% @desc     功能描述   返回应该开启的模式
%% @param    参数      AvgWorldLv  世界 平均等级    ModList  [{模式,最小等级,最大等级,开服天数}].
%% @return   返回值    mod
%% @history  修改历史
%% -----------------------------------------------------------------
get_mod(_AvgWorldLv, []) ->
	0;
get_mod(AvgWorldLv, [{Mod, MinLv, MaxLv, _} | T]) ->
	if
		AvgWorldLv >= MinLv andalso AvgWorldLv =< MaxLv ->
			Mod;
		true ->
			get_mod(AvgWorldLv, T)
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  给服务器分配copy和模式  ， 服务器的copy = 模式 * 100 + （排名 / 模式， 向上取整）
%% @param    参数      ServerList::[#server_msg{}]  ModList [{模式, 最小世界等级, 最大世界等级, 开服天数}]]  模式
%% @return   返回值    {NewServerList, BattleFieldList}  BattleFieldList:: [#battlefield_msg{}]
%% @history  修改历史
%% -----------------------------------------------------------------
handle_server_mod(ServerList, ModList) ->
	handle_server_mod(ServerList, ModList, {[], []}).


handle_server_mod([], _Mod, {ServerList, BattlefieldMsgList}) ->  %% 服务器分配完毕
	{lists:reverse(ServerList), BattlefieldMsgList};
handle_server_mod(LastServerList, [], {ServerList, BattlefieldMsgList}) ->  %% 模式分配完毕
	{lists:reverse(ServerList ++ LastServerList), BattlefieldMsgList};
handle_server_mod(AllServerList, [{Mod, MinWorldLv, _MaxWorldLv, OpenDay}| ModList], {AccServerList, BattlefieldMsgList}) ->
%%	RightMod = lib_holy_spirit_battlefield:get_server_mod(Server, Mod),  %% 满足条件的模式
	SatisfyServerList = [Server1 || #server_msg{time = Time} = Server1 <- AllServerList,
		lib_holy_spirit_battlefield:get_open_day(Time) >= OpenDay],
	NotSatisfyServerList = AllServerList -- SatisfyServerList,
	%%分组[{战场id, 平均世界等级, ServerList}]
	BattlefieldLvList = lib_holy_spirit_battlefield:get_avg_world_lv_order_by_battle_id(SatisfyServerList, Mod),
%%	?MYLOG("holy", "BattlefieldLvList ~p~n", [BattlefieldLvList]),
	F = fun({BattlefieldId, AvgLv, FunServerList}, {FunAccServerList, FunLastServerList, FunBattlefieldMsgList}) ->
%%		?MYLOG("holy", "{BattlefieldId, AvgLv, FunServerList} ~p~n", [{BattlefieldId, AvgLv, FunServerList}]),
		if
			AvgLv >= MinWorldLv ->  %%满足条件，进入战场

%%				NewServer = Server#server_msg{mod_id = RightMod, battlefield_id = BattlefieldId},
				FunServerList2 = [TempServer#server_msg{battlefield_id = BattlefieldId, mod_id = Mod} || TempServer <- FunServerList],
				NewBattlefieldMsgList =
					case lists:keyfind(BattlefieldId, #battlefield_msg.battlefield_id, FunBattlefieldMsgList) of %% 处理战场数据
						#battlefield_msg{server_list = TempServerList} = Copy ->
							NewCopy = Copy#battlefield_msg{server_list = TempServerList ++ FunServerList2},
							lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, FunBattlefieldMsgList, NewCopy);
						_ ->
							#server_msg{zone_id = ZoneId} = hd(FunServerList2),
							NewCopy = #battlefield_msg{server_list = FunServerList2, battlefield_id = BattlefieldId, zone_id = ZoneId},
							lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, FunBattlefieldMsgList, NewCopy)
					end,
				%%分配成功列表                          分配失败列表        新的战场列表
%%				?MYLOG("holy", "NewBattlefieldMsgList ~p  ~n", [NewBattlefieldMsgList]),
				{FunServerList2 ++ FunAccServerList, FunLastServerList, NewBattlefieldMsgList};
			true ->  %%世界等级不满足
				{FunAccServerList, FunServerList ++ FunLastServerList, FunBattlefieldMsgList}
		end
	    end,
	{AccServerList2, NotSatisfyServerList2, BattlefieldMsgList2} =
		lists:foldl(F, {AccServerList, NotSatisfyServerList, BattlefieldMsgList}, BattlefieldLvList),
	handle_server_mod(NotSatisfyServerList2, ModList, {AccServerList2, BattlefieldMsgList2}).




re_alloc_group(_State) ->
	AllZone = mod_zone_mgr:get_all_zone(),
	GroupList = alloc_server_zone(AllZone),
	%%所有的模式
	ModList = data_holy_spirit_battlefield:get_mod_cfg_list(),
	%%分战场
	ZoneMap = alloc_battlefield(GroupList, lists:reverse(ModList)),
	%% 推送  01协议
%%	mod_clusters_center:apply_to_all_node(lib_holy_spirit_battlefield, send_all_msg, []),
	#holy_spirit_battle_state{zone_map = ZoneMap}.


day_trigger(State) ->
	#holy_spirit_battle_state{ref = Old} = State,
	NewRef = lib_holy_spirit_battlefield:get_open_ref(Old),
	State#holy_spirit_battle_state{ref = NewRef}.

%% 活动开始，
act_open(State) ->
	#holy_spirit_battle_state{ref = OldRef} = State,
	WaitTime = lib_holy_spirit_battlefield:get_wait_time(),
	NewRef = util:send_after(OldRef, WaitTime * 1000, self(), {start_pk}),  %% 等待一段时间
	ExpRef = lib_holy_spirit_battlefield:get_exp_ref([]),
%%	?MYLOG("holy", "act_open +++++++++++++++~n", []),
	%% 全跨服广播
%%	?PRINT("send_all_act_open ++++++++++++++++++++++~n", []),
	%% 假设分区是 0 本服模式
	BattlefieldId = lib_holy_spirit_battlefield:get_battlefield_id(1, 1), %% 本服模式，排行第一
	Server = #server_msg{
		server_id = config:get_server_id(),
		server_num = config:get_server_num(),
		server_name = util:get_server_name(),
		time = util:get_open_time(),
		world_lv = util:get_world_lv(),
		rank = 1,
		battlefield_id = BattlefieldId
		},
	Battlefield = #battlefield_msg{battlefield_id = BattlefieldId, zone_id = 0, server_list = [Server]},
	Group = #server_group{zone_id = 0, max_mod = 1, num = 1, server_list = [Server], battlefield_list = [Battlefield]},
	ZoneMap = maps:put(0, Group, #{}),
	State#holy_spirit_battle_state{ref = NewRef, end_time = utime:unixtime() + WaitTime, status = ?wait,
		exp_map = #{}, exp_ref = ExpRef, zone_map = ZoneMap}.

%%开始战斗
start_pk(State) ->
	#holy_spirit_battle_state{ref = OldRef, zone_map = ZoneMap} = State,
	PkTime = lib_holy_spirit_battlefield:get_pk_time(),
%%	?MYLOG("holy", "start_pk ++++++++++++++++++++++++ pktime ~p~n", [PkTime]),
	NewRef = util:send_after(OldRef, PkTime * 1000, self(), {act_end}),  %% 等待一段时间
	%%  通知客户端
	%% 分配房间id
	{NewZoneMap, MaxCopyId} = handle_copy(utime:unixtime() + PkTime, ZoneMap),
%%	?MYLOG("holy", "start_pk  NewZoneMap  ~p~n", [NewZoneMap]),
%%	?MYLOG("holy", "start_pk +++++++++++++++~n", []),
	State#holy_spirit_battle_state{ref = NewRef, end_time = utime:unixtime() + PkTime,
		status = ?pk, zone_map = NewZoneMap, max_copy_id = MaxCopyId}.


%%活动结束
act_end(State) ->
	#holy_spirit_battle_state{zone_map = ZoneMap} = State,
%%	?MYLOG("holy", "act_end +++++++++++++++++++++++++++++++~n", []),
	%% 通知客户端
	%% 处理玩家离场，处理玩家排名奖励等等 在pk进程中处理，这里只要处理房间数据，和玩家数据即可， 和关闭进程
	List = maps:values(ZoneMap),
	F = fun(#server_group{zone_id = ZoneId, battlefield_list = BattlefieldList} = ServerZone, AccMap) ->
		NewBattlefieldList = lib_holy_spirit_battlefield:handle_battlefield_act_end_gm(BattlefieldList),
		NewServerZone = ServerZone#server_group{battlefield_list = NewBattlefieldList},
		maps:put(ZoneId, NewServerZone, AccMap)
	    end,
	lists:foldl(F, #{}, List),
%%	mod_clusters_center:apply_to_all_node(lib_activitycalen_api, success_end_activity, [?MOD_HOLY_SPIRIT_BATTLEFIELD, 0]),
	lib_activitycalen_api:success_end_activity(?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
	%% 全服通知 01
%%	mod_clusters_center:apply_to_all_node(lib_holy_spirit_battlefield, send_all_msg, []),
	lib_holy_spirit_battlefield:send_all_msg(),
	State#holy_spirit_battle_state{end_time = 0, status = ?close, exp_map = #{},
		max_copy_id = 0, ref = []}.


%% 根据人数分配房间
%% 房间创建完毕时，先根据所有匹配场景中的玩家进行排名，根据名次进行房间分配
%% 进行房间分配时默认按照匹配场景中的所有玩家的战力名次，取房间数量的名次区间随机分配到各房间中
%% 如有3个房间则取每次取3名玩家,1~3名随机分配一个房间，4~6各随机一个房间，以此类推
%% 如果剩余未分配玩家数量少于房间数量时，则分配时允许轮空出现
%% 返回    {#{} zone_id => server_group, MaxCopyId}
handle_copy(EndTime, ZoneMap) ->
	List = maps:values(ZoneMap),
	{NewList, MaxCopyId} = handle_copy(EndTime, List, 0, []),
	%%
	TempList = [{ZoneId, Group} || #server_group{zone_id = ZoneId} = Group <- NewList],
	{maps:from_list(TempList), MaxCopyId}.


handle_copy(_EndTime, [], MaxCopyId, AccList) ->
	{AccList, MaxCopyId};
handle_copy(EndTime, [Group | List], MaxCopyId, AccList) ->
	{NewGroup, NewMaxCopyId} = handle_copy_help(EndTime, Group, MaxCopyId),
	handle_copy(EndTime, List, NewMaxCopyId, [NewGroup | AccList]).

handle_copy_help(EndTime, Group, MaxCopyId) ->
	#server_group{max_mod = Mod, battlefield_list = BattlefieldList} = Group,
	case data_holy_spirit_battlefield:get_mod_cfg(Mod) of
		#mod_cfg{room_num = RoomNum} ->
			{NewBattlefieldList, NewMaxCopyId} = handle_copy_help(EndTime, BattlefieldList, RoomNum, MaxCopyId),
			{Group#server_group{battlefield_list = NewBattlefieldList}, NewMaxCopyId};
		_ ->
			?ERR("misscfig   Mod ~p~n", [Mod]),
			{Group, MaxCopyId}
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  为战场分配房间
%% @param    参数      BattlefieldList::[#battlefield_msg]   RoomNum::integer() 房间的最大人数  MaxCopyId::integer()  最大房间id
%% @return   返回值    {NewBattlefieldList， NewMaxCopyId}
%% @history  修改历史
%% -----------------------------------------------------------------
handle_copy_help(EndTime, BattlefieldList, RoomNum, MaxCopyId) ->
	handle_copy_help(EndTime, BattlefieldList, RoomNum, MaxCopyId, []).


handle_copy_help(_EndTime, [], _RoomNum, MaxCopyId, AccList) ->
	{lists:reverse(AccList), MaxCopyId};
handle_copy_help(EndTime, [Msg | BattlefieldList], RoomNum, MaxCopyId, AccList) ->
	#battlefield_msg{role_list = RoleList, zone_id = ZoneId, battlefield_id = BattleId} = Msg,
	Mod = lib_holy_spirit_battlefield:get_mod_by_battlefield_id(BattleId),
%%	FilterRoleList = [Role ||#role_msg{status = RoleStatus} = Role <-RoleList, RoleStatus == ?in_act],
	RoleNum = length(RoleList),  %% 战场内的人数
	if
		RoleNum =< 0 ->
			handle_copy_help(EndTime, BattlefieldList, RoomNum, MaxCopyId, [Msg | AccList]);
		true ->
			CopyNum = util:ceil(RoleNum / RoomNum),   %%需要多少个房间, 向上取整
			NewMaxId = CopyNum + MaxCopyId,
			SortRoleList = lib_holy_spirit_battlefield:sort_role(RoleList),
			RankRoleList = lib_holy_spirit_battlefield:set_rank_role(SortRoleList), %设置排名
			%%房间id逻辑    a = rank 取余 CopyNum ，房间id = a + 1 + MaxCopyId
			NewRoleList = handle_role_copy_id(RankRoleList, MaxCopyId, CopyNum),
%%			?MYLOG("holy", "MaxCopyId ~p   NewMaxId ~p ~n", [MaxCopyId, NewMaxId]),
%%			?MYLOG("holy", "NewRoleList ~p~n", [NewRoleList]),
			{LastRoleList, CopyList} = handle_start_pk(EndTime, Mod, ZoneId, NewRoleList, MaxCopyId + 1, NewMaxId + 1),
			NewBattleMsg = Msg#battlefield_msg{role_list = LastRoleList, copy_list = CopyList},
			handle_copy_help(EndTime, BattlefieldList, RoomNum, NewMaxId, [NewBattleMsg | AccList])
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述    房间id逻辑    a = rank(排名) 取余 CopyNum ，房间id = a + 1 + MaxCopyId
%% @param    参数      RankRoleList::[#role_msg{}] MaxCopyId::integer()  房间的最大id  CopyNum::integer() 房间数量
%% @return   返回值    NewRankRoleList
%% @history  修改历史
%% -----------------------------------------------------------------
%%
handle_role_copy_id(RankRoleList, MaxCopyId, CopyNum) ->
	handle_role_copy_id(RankRoleList, MaxCopyId, CopyNum, []).


handle_role_copy_id([], _MaxCopyId, _CopyNum, AccList) ->
	lists:reverse(AccList);
handle_role_copy_id([Role | RoleList], MaxCopyId, CopyNum, AccList) ->
	#role_msg{rank = Rank} = Role,
	CopyId = Rank rem CopyNum + 1 + MaxCopyId,
	NewRole = Role#role_msg{copy_id = CopyId},
	handle_role_copy_id(RoleList, MaxCopyId, CopyNum, [NewRole | AccList]).


%% -----------------------------------------------------------------
%% @desc     功能描述     开房间， 从 fromId 到  ToId - 1
%% @param    参数        RoleList::[#role_msg{}] FromId  房间开始id， ToId 房间结束id
%% @return   返回值      {NewRoleList, CopyList::[#copy_msg{}]}
%% @history  修改历史
%% ----------------------------------------------------------------
handle_start_pk(EndTime, Mod, ZoneId, RoleList, FromId, ToId) ->
	handle_start_pk(EndTime, Mod, ZoneId, RoleList, FromId, ToId, {[], []}).



handle_start_pk(_EndTime, _Mod, _ZoneId, _RoleList, ToId, ToId, {RoleList, CopyList}) ->
	{RoleList, CopyList};
handle_start_pk(EndTime, Mod, ZoneId, AllRoleList, FromId, ToId, {RoleList, CopyList}) ->
	CopyRoleList = [Role || #role_msg{copy_id = CopyId} = Role <- AllRoleList, CopyId == FromId],
%%	?MYLOG("holy", "CopyRoleList ~p~n", [{CopyRoleList, FromId, ZoneId}]),
	case mod_holy_spirit_battlefield_room:start([EndTime, Mod, CopyRoleList, FromId, ZoneId]) of   %% 开启房间
		{ok, Pid} ->
			NewCopyRoleList = [TempRole#role_msg{pk_pid = Pid} || TempRole <- CopyRoleList],
			handle_start_pk(EndTime, Mod, ZoneId, AllRoleList, FromId + 1, ToId,
				{NewCopyRoleList ++ RoleList, [#copy_msg{copy_id = FromId, pk_pid = Pid} | CopyList]});
		_R ->
			?ERR("create_pk_room~p ~n", [_R]),
			handle_start_pk(EndTime, Mod, ZoneId, AllRoleList, FromId + 1, ToId,
				{CopyRoleList ++ RoleList, [#copy_msg{copy_id = FromId} | CopyList]})

	end.


get_info(ServerId, RoleId, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#holy_spirit_battle_state{zone_map = ZoneMap, status = Status, end_time = EndTime} = State,
	#server_group{battlefield_list = BattlefieldList, server_list = ServerList}
		= maps:get(ZoneId, ZoneMap, #server_group{}),
	{ok, DefaultBin} = pt_218:write(21801, [0, 0, 0, []]),
	case lists:keyfind(ServerId, #server_msg.server_id, ServerList) of
		#server_msg{rank = Rank, mod_id = Mod}  when Mod =/= 0->
			BattlefieldId = lib_holy_spirit_battlefield:get_battlefield_id(Mod, Rank),
			case lists:keyfind(BattlefieldId, #battlefield_msg.battlefield_id, BattlefieldList) of
				#battlefield_msg{battlefield_id = BattleId} ->
					NewModId = lib_holy_spirit_battlefield:get_mod_by_battlefield_id(BattleId),
					PackList = pack_server_list(ServerList, NewModId, Rank),
%%					?MYLOG("holy", "Mod, Status, EndTime, PackList ~p", [{Mod, Status, EndTime, PackList}]),
					{ok, Bin} = pt_218:write(21801, [Mod, Status, EndTime, PackList]),
					lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin);
				_ ->
					lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin)
			end;
		_ ->
			lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin)
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述   获取下一个模式的服所有服的信息  如果当前服是 Mod , 那么下一个阶段所有的服应该是 满足
%%                    %% 当前模式一致
%%                    %% lib_holy_spirit_battlefield:get_battlefield_id(min(Mod * 2, 8), 服的排名) 如果是一致的，那么就是下一个阶段的
%% @param    参数      ServerList::[#server_msg{}] 分区下的所有服务器id
%%                     Mod::当前服的模式
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------

pack_server_list(ServerList, Mod, ServerRank) ->
	NextMod = lib_holy_spirit_battlefield:get_next_mod(Mod),
%%	?MYLOG("holy", "ServerList ~p~n", [ServerList]),
	NextBattleId = lib_holy_spirit_battlefield:get_battlefield_id(NextMod, ServerRank),
	F = fun(#server_msg{server_id = ServerId, server_num = ServerNum,
		server_name = ServerName, world_lv = Lv, rank = FunRank, mod_id = _FunMod}, AccList) ->
%%		FunNextMod = lib_holy_spirit_battlefield:get_next_mod(FunMod),
		FunNextBattleId = lib_holy_spirit_battlefield:get_battlefield_id(NextMod, FunRank),
		if
%%			FunMod =/= Mod ->
%%				AccList;
			FunNextBattleId =/= NextBattleId ->
				AccList;
			true ->
				[{ServerId, ServerNum, ServerName, Lv} | AccList]
		end
	    end,
	lists:foldl(F, [], ServerList).
%%	[{ServerId, ServerNum, ServerName, Lv} ||
%%		#server_msg{server_id = ServerId, server_num = ServerNum, server_name = ServerName, world_lv = Lv} <- ServerList].




enter_scene(_Turn, _Career, _PictureId, _Picture, _Lv, _ServerNum, ServerId, RoleId, _Power, _RoleName, #holy_spirit_battle_state{status = ?close} = State) ->
	{ok, Bin} = pt_218:write(21802, [?ERRCODE(err218_act_close)]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin),
%%	?MYLOG("holy", "cmd ++++++++++++++~p ~n", [State]),
	State;
enter_scene(Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName,
	#holy_spirit_battle_state{status = ?wait, zone_map = ZoneMap, end_time = EndTime} = State) ->
%%	?MYLOG("holy2", "cmd ++++++++++++++~p ~n", [State]),
	ZoneId = 0,
	{ok, DefaultBin} = pt_218:write(21802, [?FAIL]),  %% 默认错误
	case maps:get(ZoneId, ZoneMap, []) of
		#server_group{server_list = ServerList, battlefield_list = BattleList} = Group ->
			case lists:keyfind(ServerId, #server_msg.server_id, ServerList) of
				#server_msg{mod_id = ModId, rank = Rank} ->
					BattlefieldId = lib_holy_spirit_battlefield:get_battlefield_id(ModId, Rank),
					case lists:keyfind(BattlefieldId, #battlefield_msg.battlefield_id, BattleList) of
						#battlefield_msg{role_list = RoleList} = Battlefield ->
							%% 拉玩家进入等待场景
							lib_holy_spirit_battlefield:pull_role_into_wait_scene(ServerId, RoleId, ZoneId, BattlefieldId),
							NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList,
								#role_msg{
									role_id = RoleId,
									server_id = ServerId,
									status = ?in_act,
									power = Power,
									role_name = RoleName,
									server_num = ServerNum,
									lv = Lv,
									picture_id = PictureId,
									picture = Picture,
									turn = Turn,
									career = Career
								}),
%%							?MYLOG("holy2", "NewRoleList ++++++++++++++~p ~n", [NewRoleList]),
%%							?PRINT("holy2", "NewRoleList ~p~n", [NewRoleList]),
							NewBattlefield = Battlefield#battlefield_msg{role_list = NewRoleList},
							NewBattleList = lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, BattleList, NewBattlefield),
							NewGroup = Group#server_group{battlefield_list = NewBattleList},
							NewZoneMap = maps:put(ZoneId, NewGroup, ZoneMap),
							{ok, Bin2} = pt_218:write(21811, [?wait, EndTime]),
							lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin2),
							%% 参加活动了
%%							lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
							{ok, Bin} = pt_218:write(21802, [?SUCCESS]),
							lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin),
                            % 事件触发
                            CallbackData = #callback_join_act{type = ?MOD_HOLY_SPIRIT_BATTLEFIELD},
                            lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData),
							lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
%%							?MYLOG("holy2", "NewZoneMap ++++++++++++++~p ~n", [NewZoneMap]),
							State#holy_spirit_battle_state{zone_map = NewZoneMap};
						_ ->
							lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
							State
					end;
				_ ->
					lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
					State
			end;
		_ ->
			lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
			State
	end;

%% pk中
enter_scene(Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName,
	#holy_spirit_battle_state{status = ?pk, zone_map = ZoneMap, max_copy_id = MaxCopyId, end_time = EndTime} = State) ->
%%	?MYLOG("holy", "cmd ++++++++++++++~n", []),
	ZoneId = 0,
	{ok, DefaultBin} = pt_218:write(21800, [?FAIL]),  %% 默认错误
	case maps:get(ZoneId, ZoneMap, []) of
		#server_group{server_list = ServerList, battlefield_list = BattleList} = Group ->
			case lists:keyfind(ServerId, #server_msg.server_id, ServerList) of
				#server_msg{mod_id = ModId, rank = Rank} ->
					BattlefieldId = lib_holy_spirit_battlefield:get_battlefield_id(ModId, Rank),
					case lists:keyfind(BattlefieldId, #battlefield_msg.battlefield_id, BattleList) of
						#battlefield_msg{role_list = RoleList, copy_list = CopyList} = Battlefield ->
							case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
								#role_msg{pk_pid = Pid} = RoleMsg ->  %%曾经进入过pk场景, 不用修正copy里的人数
									%% 进入pk场景
									RolePkMsg = lib_holy_spirit_battlefield:role_msg_to_pk(RoleMsg#role_msg{status = ?pk}),
									mod_holy_spirit_battlefield_room:enter(Pid, RolePkMsg),  %%
									NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList, RoleMsg#role_msg{status = ?pk}),
									NewBattlefield = Battlefield#battlefield_msg{role_list = NewRoleList},
									NewBattleList = lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, BattleList, NewBattlefield),
									NewGroup = Group#server_group{battlefield_list = NewBattleList},
									NewZoneMap = maps:put(ZoneId, NewGroup, ZoneMap),
									State#holy_spirit_battle_state{zone_map = NewZoneMap};
								_ ->
									%%没有进入等待场景直接进入pk场景
									%%如果玩家进入玩法时，房间分配阶段已经完成，则直接默认将玩家分配到当前人数最少的战场房间中
									%%如果同时有多个房间人数一致，则默认进入平均战力最低的房间
									NewCopyId = lib_holy_spirit_battlefield:get_role_copy_when_enter(Battlefield, MaxCopyId),
									if
										NewCopyId > MaxCopyId ->  %% 需要新开房间， 这里的战场一个房间都没有
											NewRole =
												#role_msg{
													role_name = RoleName,
													server_id = ServerId,
													role_id = RoleId,
													power = Power,
													copy_id = NewCopyId,
													status = ?in_act
													, server_num = ServerNum
													, lv = Lv
													, picture_id = PictureId
													, picture = Picture
													,turn = Turn
													,career = Career
												},
											case mod_holy_spirit_battlefield_room:start([EndTime, ModId, [NewRole], NewCopyId, ZoneId]) of
												{ok, Pid} ->
													NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList, NewRole#role_msg{pk_pid = Pid}),
													NewCopy = #copy_msg{num = 1, copy_id = NewCopyId, pk_pid = Pid},
													NewCopyList = lists:keystore(NewCopyId, #copy_msg.copy_id, CopyList, NewCopy),
													NewBattlefield = Battlefield#battlefield_msg{role_list = NewRoleList, copy_list = NewCopyList},
													NewBattlefieldList = lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, BattleList, NewBattlefield),
													NewGroup = Group#server_group{battlefield_list = NewBattlefieldList},
													NewZoneMap = maps:put(ZoneId, NewGroup, ZoneMap),
													lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
													State#holy_spirit_battle_state{zone_map = NewZoneMap, max_copy_id = NewCopyId};
												_R ->
													?ERR("create_pk_room~p ~n", [_R]),
													State

											end;
										true ->  %% 进入旧房间
											case lists:keyfind(NewCopyId, #copy_msg.copy_id, CopyList) of
												#copy_msg{num = CopyRoleNum, pk_pid = Pid} = Copy ->
													NewCopy = Copy#copy_msg{num = CopyRoleNum + 1},
													NewRole =
														#role_msg{
															role_name = RoleName,
															server_id = ServerId,
															role_id = RoleId,
															power = Power,
															copy_id = NewCopyId,
															pk_pid = Pid,
															status = ?in_act
															, server_num = ServerNum
															, lv = Lv
															, picture_id = PictureId
															, picture = Picture
															,turn = Turn
															,career = Career
														},
													NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList, NewRole),
													RolePkMsg = lib_holy_spirit_battlefield:role_msg_to_pk(NewRole),
													mod_holy_spirit_battlefield_room:enter(Pid, RolePkMsg),
													NewCopyList = lists:keystore(NewCopyId, #copy_msg.copy_id, CopyList, NewCopy),
													NewBattlefield = Battlefield#battlefield_msg{role_list = NewRoleList, copy_list = NewCopyList},
													NewBattlefieldList = lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, BattleList, NewBattlefield),
													NewGroup = Group#server_group{battlefield_list = NewBattlefieldList},
													NewZoneMap = maps:put(ZoneId, NewGroup, ZoneMap),
													lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
													State#holy_spirit_battle_state{zone_map = NewZoneMap};
												_ ->  %% 容错，一般不会走到这
													State
											end
									end
							end;
						_ ->
							lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
							State
					end;
				_ ->
					lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
					State
			end;
		_ ->
			lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, DefaultBin),
			State
	end.



%%退出场景
quit_scene(_ServerId, _RoleId, #holy_spirit_battle_state{status = ?close} = State) ->
	State;
quit_scene(ServerId, RoleId, State) ->
	ZoneId = 0,
	#holy_spirit_battle_state{zone_map = Map, status = Status} = State,
	case maps:get(ZoneId, Map, []) of
		#server_group{battlefield_list = BattleList, server_list = ServerList} = Group ->
			case lists:keyfind(ServerId, #server_msg.server_id, ServerList) of
				#server_msg{rank = Rank, mod_id = Mod} = _ServerMsg ->
					BattlefieldId = lib_holy_spirit_battlefield:get_battlefield_id(Mod, Rank),
					case lists:keyfind(BattlefieldId, #battlefield_msg.battlefield_id, BattleList) of
						#battlefield_msg{role_list = RoleList} = BattleFieldMsg ->
							case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
								#role_msg{pk_pid = Pid} = Role ->
									if
										Status == ?wait ->
											NewRoleList = lists:keydelete(RoleId, #role_msg.role_id, RoleList);
										true ->  %% pk中
											NewRole = Role#role_msg{status = ?not_in_act},
											mod_holy_spirit_battlefield_room:quit(Pid, ServerId, RoleId),  %%通知pk进程
											NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList, NewRole)
									end,
									%%封装数据
									NewBattlefield = BattleFieldMsg#battlefield_msg{role_list = NewRoleList},
									NewBattlefieldList = lists:keystore(BattlefieldId, #battlefield_msg.battlefield_id, BattleList, NewBattlefield),
									NewGroup = Group#server_group{battlefield_list = NewBattlefieldList},
									NewZoneMap = maps:put(ZoneId, NewGroup, Map),
									State#holy_spirit_battle_state{zone_map = NewZoneMap};
								_ ->
									State
							end;
						_ ->
							State
					end;
				_ ->
					State
			end;
		_ ->
			State
	end.


%% 获得在场景中的经验
get_exp(ServerId, RoleId, State) ->
	#holy_spirit_battle_state{exp_map = ExpMap} = State,
%%	?MYLOG("holy", "expMap ~p~n", [ExpMap]),
	Exp = maps:get(RoleId, ExpMap, 0),
	{ok, Bin} = pt_218:write(21804, [Exp]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin).



%% 增加经验后的回写
add_exp(#holy_spirit_battle_state{status = ?wait, exp_ref = ExpRef, zone_map = Map} = State) ->
	NewExpRef = lib_holy_spirit_battlefield:get_exp_ref(ExpRef),
	List = maps:values(Map),
	?MYLOG("holy", "Map ~p~n", [Map]),
	[[[
		lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_holy_spirit_battlefield, add_exp, [])
		|| #role_msg{server_id = _ServerId, role_id = RoleId} <- RoleList]
		|| #battlefield_msg{role_list = RoleList} <- BattleList]
		|| #server_group{battlefield_list = BattleList} <- List],
	State#holy_spirit_battle_state{exp_ref = NewExpRef};
add_exp(State) ->
%%	?MYLOG("holy", "Map+9++++++++++++++++++++++ ~n", []),
	State.


kill_mon(_SceneId, Atter, Klist, Minfo, State) ->
	#battle_return_atter{server_id = ServerId, id = RoleId} = Atter,
	#scene_object{config_id = MonId} = Minfo,
%%	PkPid ! {kill_mon, Atter, Klist, MonId};
	case get_pk_pid(ServerId, RoleId, State) of
		undefine ->
			ok;
		Pid ->
			Pid ! {kill_mon, Atter, Klist, MonId}
	end.


mon_be_hurt(_SceneId, Atter, Minfo, State) ->
	#battle_return_atter{server_id = ServerId, id = RoleId} = Atter,
%%	PkPid ! {mon_be_hurt, Atter, MonId};
	#scene_object{config_id = MonId, battle_attr = BA, scene_pool_id = PoolId, copy_id = CopyId, id = MonAutoId} = Minfo,
	case get_pk_pid(ServerId, RoleId, State) of
		undefine ->
			ok;
		Pid ->
			Pid ! {mon_be_hurt, Atter, MonAutoId, MonId, PoolId, CopyId, BA#battle_attr.hp, BA#battle_attr.group}
	end.

kill_enemy(_SceneId, _PoolId, _RoomId, DefRoleId, Atter, HitList, State) ->
	%%PkPid ! {kill_enemy, Atter, DefRoleId, HitList};
	#battle_return_atter{server_id = ServerId, id = RoleId} = Atter,
	case get_pk_pid(ServerId, RoleId, State) of
		undefine ->
			ok;
		Pid ->
			Pid ! {kill_enemy, Atter, DefRoleId, HitList}
	end.

%% 秘籍结束活动
gm_end(State) ->
	#holy_spirit_battle_state{zone_map = ZoneMap} = State,
	%% 处理玩家离场，处理玩家排名奖励等等 在pk进程中处理，这里只要处理房间数据，和玩家数据即可， 和关闭进程
	List = maps:values(ZoneMap),
	F = fun(#server_group{zone_id = ZoneId, battlefield_list = BattlefieldList} = ServerZone, AccMap) ->
		NewBattlefieldList = lib_holy_spirit_battlefield:handle_battlefield_act_end_gm(BattlefieldList),
		NewServerZone = ServerZone#server_group{battlefield_list = NewBattlefieldList},
		maps:put(ZoneId, NewServerZone, AccMap)
	    end,
	lists:foldl(F, #{}, List),
%%	?MYLOG("holy2", " ++++++++++++~n", []),
	%% 全服通知 01
%%	lib_activitycalen_api:success_end_activity(?MOD_HOLY_SPIRIT_BATTLEFIELD, 0),
	lib_holy_spirit_battlefield:send_all_msg(),
	State#holy_spirit_battle_state{end_time = 0, status = ?close, exp_map = #{},
		max_copy_id = 0, ref = [], zone_map = #{}}.


get_pk_pid(ServerId, RoleId, State) ->
	ZoneId = 0,
	#holy_spirit_battle_state{zone_map = ZoneMap} = State,
	case maps:get(ZoneId, ZoneMap, []) of
		#server_group{server_list = ServerList, battlefield_list = BattleFieldList} ->
			case lists:keyfind(ServerId, #server_msg.server_id, ServerList) of
				#server_msg{rank = Rank, mod_id = ModId} ->
					BattleFieldId = lib_holy_spirit_battlefield:get_battlefield_id(ModId, Rank),
					case lists:keyfind(BattleFieldId, #battlefield_msg.battlefield_id, BattleFieldList) of
						#battlefield_msg{role_list = RoleList} ->
							case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
								#role_msg{pk_pid = PkPid} ->
									PkPid;
								_ ->
									undefine
							end;
						_ ->
							undefine
					end;
				_ ->
					undefine
			end;
		_ ->
			undefine
	end.


%%%% 跨服连接上来了
%%center_connected(_ServerId, _OpTime, _WorldLv, _ServerNum, _ServerName, _MergeSerIds, State) ->
%%	#holy_spirit_battle_state{status = Status, end_time = EndTime, calc_ref = OldCalcRef} = State,
%%	if
%%		Status =/= ?close ->
%%			Time = (EndTime - utime:unixtime() + 10),
%%%%			?MYLOG("holy", "Tiem ~p~n", [Time]),
%%			NewRef = util:send_after(OldCalcRef, max(500, Time * 1000), self(), {center_connected}),
%%			State#holy_spirit_battle_state{calc_ref = NewRef};
%%		true ->
%%%%			?MYLOG("holy", "center_connected ++++++++++=====  ~n", []),
%%			AllZone = mod_zone_mgr:get_all_zone(),
%%			GroupList = alloc_server_zone(AllZone),
%%			%%所有的模式
%%			ModList = data_holy_spirit_battlefield:get_mod_cfg_list(),
%%			%%分战场
%%			ZoneMap = alloc_battlefield(GroupList, lists:reverse(ModList)),
%%%%			?MYLOG("holy", "ZoneMap ~p~n", [ZoneMap]),
%%			%%Ref = lib_holy_spirit_battlefield:get_open_ref([]),
%%			mod_clusters_center:apply_to_all_node(lib_holy_spirit_battlefield, send_all_msg, []),
%%			State#holy_spirit_battle_state{zone_map = ZoneMap, max_copy_id = 0}
%%	end.

%%%% 跨服连接上来了
%%center_connected(State) ->
%%	#holy_spirit_battle_state{status = Status, end_time = EndTime, calc_ref = OldCalcRef} = State,
%%	if
%%		Status =/= ?close ->
%%			Time = (EndTime - utime:unixtime() + 10),
%%%%			?MYLOG("holy", "Time ~p~n", [Time]),
%%			NewRef = util:send_after(OldCalcRef, max(500, Time * 1000), self(), {center_connected}),
%%			State#holy_spirit_battle_state{calc_ref = NewRef};
%%		true ->
%%%%			?MYLOG("holy", "center_connected ++++++++++=====  ~n", []),
%%			AllZone = mod_zone_mgr:get_all_zone(),
%%			GroupList = alloc_server_zone(AllZone),
%%			%%所有的模式
%%			ModList = data_holy_spirit_battlefield:get_mod_cfg_list(),
%%			%%分战场
%%			ZoneMap = alloc_battlefield(GroupList, lists:reverse(ModList)),
%%			?MYLOG("holy", "ZoneMap ~p~n", [ZoneMap]),
%%			%%Ref = lib_holy_spirit_battlefield:get_open_ref([]),
%%			mod_clusters_center:apply_to_all_node(lib_holy_spirit_battlefield, send_all_msg, []),
%%			State#holy_spirit_battle_state{zone_map = ZoneMap, max_copy_id = 0}
%%	end.
