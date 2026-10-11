%%%-----------------------------------
%%% @Module      : mod_holy_spirit_battlefield_room
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十月 2019 17:59
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_holy_spirit_battlefield_room_point).
-author("carlos").
-include("holy_spirit_battlefield.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("attr.hrl").


-define(MOD_STATE, holy_battle_point).

%% API
-export([]).





start(Args) ->
	gen_server:start_link(?MODULE, Args, []).

%% 排序
sort(Pid, Msg) ->
	Pid ! {sort, Msg}.

add_point(Pid, RoleMsg, Point) ->
%%	?MYLOG("holy",  " Pid, RoleMsg, Point ~p~n", [{Pid, RoleMsg, Point}]),
	Pid ! {add_point, RoleMsg, Point}.

add_point_list(Pid, RoleListNew, AddPoint) ->
	Pid ! {add_point_list, RoleListNew, AddPoint}.


get_battle_all_msg(PointPid, TowerList, ServerId, RoleId) ->
	PointPid ! {get_battle_all_msg, TowerList, ServerId, RoleId}.

%% 结算
act_end(PointPid, TowerList, ZoneId, CopyId) ->
	PointPid ! {sort, []},  %% 再排序一次
	PointPid ! {act_end, TowerList, ZoneId, CopyId}.

init([Mod]) ->
%%	Ref = util:send_after([], ?sort_time * 1000, self(), {sort}),
%%	?MYLOG("cym", "mod_holy_spirit_battlefield_room_point +++++++++ ~n", []),
	{ok, #holy_battle_point{role_list = [], mod = Mod}}.




handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{stop, A, B} ->
			{stop, A, B};
		Reason ->
			?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
			{noreply, State}
	end.


handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{stop, A, B} ->
			{stop, A, B};
		Reason ->
			?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
			{noreply, State}
	end.




do_handle_cast(_Request, State) ->
	{noreply, State}.



%% 增加积分不排序
do_handle_info({add_point, RoleMsg, Point}, State) ->
	PointRole = trans_to_point(RoleMsg),
	#holy_battle_point{role_list = RoleList} = State,
	NewRoleList = add_point_return_role_list(PointRole, RoleList, Point),
	{noreply, State#holy_battle_point{role_list = NewRoleList}};

%% 增加积分不排序
do_handle_info({add_point_list, RoleListNew, AddPoint}, State) ->
	PointRoleList = [trans_to_point(RoleMsg) || RoleMsg <- RoleListNew],
	#holy_battle_point{role_list = RoleList} = State,
	F = fun(PointRole, AccRoleList) ->
			add_point_return_role_list(PointRole, AccRoleList, AddPoint)
		end,
	NewRoleList = lists:foldl(F, RoleList, PointRoleList),
%%	?MYLOG("holy", "add_point_list  NewRoleList ~p~n", [NewRoleList]),
	{noreply, State#holy_battle_point{role_list = NewRoleList}};

%% 21808 信息
do_handle_info({get_battle_all_msg, TowerList, ServerId, RoleId}, State) ->
	#holy_battle_point{group_map = GroupMap, role_list = _RankRoleList1} = State,
	GroupMapList = maps:to_list(GroupMap),
	F = fun({GroupId, #group_point{point = Point, role_list = RankRoleList, rank = GroupRank}}, AccList) ->
		TowerNum = lib_holy_spirit_battlefield:get_tower_num(GroupId, TowerList),
		PackList = pack_role_list_21808(RankRoleList),
		[{GroupId, TowerNum, Point, GroupRank, PackList} | AccList]
	    end,
	FunRes = lists:reverse(lists:foldl(F, [], GroupMapList)),
	{ok, Bin} = pt_218:write(21808, [FunRes]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin),
%%	?MYLOG("holy2", "RankRoleList ~p~n", [RankRoleList1]),
	{noreply, State};


%% 结算
do_handle_info({act_end, TowerList, ZoneId, CopyId}, State) ->
	#holy_battle_point{group_map = GroupMap, mod = Mod} = State,
	%%	%% 计算奖励
	SortGroupList = get_group_res_msg(GroupMap, TowerList),  %% [{group, towerNum, point}]
	case data_holy_spirit_battlefield:get_battle_reward(Mod) of
		[] ->
			WinReward = [], FailReward = [];
		{WinReward, FailReward} ->
			ok
	end,
	{WinGroupId, _, _} = hd(SortGroupList),
	%% 阵营日志
	lib_log_api:log_holy_battle_pk_group(ZoneId, CopyId, Mod, SortGroupList),
	F = fun({GroupId, _, _}) ->
		case maps:get(GroupId, GroupMap, []) of
			#group_point{role_list = GroupRoleList} when GroupRoleList =/= [] -> %% 有序的
				Res = if
					      WinGroupId == GroupId ->
						      Reward = WinReward,
						      1;
					      true ->
						      Reward = FailReward,
						      0
				      end,
				spawn(fun() ->
					[begin
						 timer:sleep(200),
						 if
							 Reward =/= [] ->
								 case util:is_cls() of
									 true ->
										 mod_clusters_center:apply_cast(ServerId, lib_goods_api, send_reward_with_mail,
											 [RoleId, #produce{reward = Reward, type = holy_spirit_battlefield_reward}]);
									 _ ->
										 lib_goods_api:send_reward_with_mail(RoleId,
											 #produce{reward = Reward, type = holy_spirit_battlefield_reward})
								 end;
							 true ->
								 skip
						 end,
						 %% 日志
						 lib_log_api:log_holy_battle_pk_role(RoleId, ServerNum, ServerId, ZoneId, CopyId, RolePoint),
						 %%清理buff
						 lib_holy_spirit_battlefield:change_role_pk_buff(ServerId, RoleId, []),
						 lib_holy_spirit_battlefield:skill_quit(RoleId, ServerId),
						 {ok, Bin} = pt_218:write(21810, [Res, SortGroupList, GroupId, MyRank]),
						 lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin)
					 end
						|| #role_point{rank = MyRank, server_id = ServerId, role_id = RoleId, server_num = ServerNum, point = RolePoint} <- GroupRoleList]
				end);
			_ ->
				skip
		end
	    end,
	lists:foreach(F, SortGroupList),
	{stop, normal, State};









%% 排序
do_handle_info({sort, _Msg}, State) ->
	#holy_battle_point{role_list = RoleList, group_list = _GroupList, mod = ModId} = State,
	SortGroupList = calc_group_point(RoleList), %% 排序好的阵营列表
	F = fun(GroupId, AccMap) ->
			GroupRoleList = get_group_role_list(GroupId, RoleList),
			if
				GroupRoleList == [] ->
					maps:put(GroupId, #group_point{group_id = GroupId, point = 0, role_list = [], rank = 0}, AccMap);
				true ->
					GroupRoleList1 = sort_role_by_point(GroupRoleList),
					GroupRoleList2 = set_rank_pk_role(GroupRoleList1),
					case lists:keyfind(GroupId, 1, SortGroupList) of
						{_, Point, Rank} ->
							maps:put(GroupId, #group_point{group_id = GroupId, point = Point, role_list = GroupRoleList2, rank = Rank}, AccMap);
						_ ->
							maps:put(GroupId, #group_point{group_id = GroupId, point = 0, role_list = GroupRoleList2, rank = 0}, AccMap)
					end
			end
		end,
	
	GroupMap = lists:foldl(F, #{}, [1, 2, 3]),  %%  todo 优化 3个阵营
	%% 广播
	send_battle_msg_to_client(GroupMap),
	%% 同步本地
	update_point_to_local(RoleList, ModId),
	%%
	{noreply, State#holy_battle_point{role_list = RoleList, group_list = SortGroupList, group_map = GroupMap}};






do_handle_info(_Request, State) ->
%%	?MYLOG("cym", "send_battle_msg ++++++++++ ~p ~n", [_Request]),
	{noreply, State}.




terminate(_Reason, _State) ->
	ok.


trans_to_point(RolePk) ->
	#role_point{
		role_id = RolePk#role_pk_msg.role_id,
		role_name = RolePk#role_pk_msg.role_name,
		server_id = RolePk#role_pk_msg.server_id,
%%		copy_id = RolePk#role_pk_msg.copy_id,
%%		pk_pid = RolePk#role_pk_msg.pk_pid,
		group = RolePk#role_pk_msg.group,
		point = RolePk#role_pk_msg.point,
		rank = 0,
		server_num = RolePk#role_pk_msg.server_num,
		kill_num = RolePk#role_pk_msg.kill_num,
		assist = RolePk#role_pk_msg.assist
		,anger = RolePk#role_pk_msg.anger
		,anger_end = RolePk#role_pk_msg.anger_end
		,buff_list = RolePk#role_pk_msg.buff_list
	}.

add_point_return_role_list(PointRole, RoleList, Point) ->
	case lists:keyfind(PointRole#role_point.role_id, #role_point.role_id, RoleList) of
		#role_point{point = OldPoint} ->
			NewRoleList = lists:keystore(PointRole#role_point.role_id, #role_point.role_id,
				RoleList, PointRole#role_point{point = OldPoint + Point});
		_ ->
			NewRoleList = lists:keystore(PointRole#role_point.role_id, #role_point.role_id,
				RoleList, PointRole#role_point{point = Point})
	end,
	NewRoleList.


%% 积分排序
sort_role_by_point(RoleList) ->
	F = fun(#role_point{point = PointA}, #role_point{point = PointB}) ->
		PointA >= PointB  %%积分高前头
	    end,
	lists:sort(F, RoleList).


%% 积分排序
sort_group_by_point(GroupList) ->
	F = fun({_GroupId1, PointA, _}, {_GroupId2, PointB, _}) ->
		PointA >= PointB  %%积分高前头
	    end,
	lists:sort(F, GroupList).



%% 设置排名
set_rank_pk_role(SortList) ->
	set_rank_pk_role(SortList, [], 0).

%%
set_rank_pk_role([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank_pk_role([Role | SortList], AccList, PreRank) ->
	set_rank_pk_role(SortList, [Role#role_point{rank = PreRank + 1} | AccList], PreRank + 1).



%% 设置排名
set_rank_pk_group(SortList) ->
	set_rank_pk_group(SortList, [], 0).

%%
set_rank_pk_group([], AccList, _PreRank) ->
	lists:reverse(AccList);
set_rank_pk_group([{GroupId, Point, _} | SortList], AccList, PreRank) ->
	set_rank_pk_group(SortList, [{GroupId, Point, PreRank + 1} | AccList], PreRank + 1).


%% -----------------------------------------------------------------
%% @desc     功能描述  发送场景内的 21807协议
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_battle_msg_to_client(GroupMap) ->
	GroupMapList = maps:to_list(GroupMap),
	[
		begin
			[begin
				 {ok, Bin} = pt_218:write(21807, [Point, RoleRank, GroupRank, Anger, AngerEndTime, BuffList]),  %%
				 lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin)
			 end
				|| #role_point{server_id = ServerId, anger_end = AngerEndTime,
				role_id = RoleId, point = Point, rank = RoleRank, buff_list = BuffList, anger = Anger} <- RankRoleList]
		end
		|| {GroupId, #group_point{group_id = GroupId, role_list = RankRoleList, rank = GroupRank}} <- GroupMapList].



get_group_role_list(GroupId, RoleList) ->
	[Role || #role_point{group = RoleGroupId} = Role <- RoleList, RoleGroupId == GroupId].



%% 返回 [{groupId, Point, Rank}]  %% rank有序
calc_group_point(RoleList) ->
	%% todo  可优化
	F = fun(#role_point{group = GroupId, point = Point}, AccList) ->
		case lists:keyfind(GroupId, 1, AccList) of
			{GroupId, OldPoint, Rank} ->
				lists:keystore(GroupId, 1, AccList, {GroupId, OldPoint + Point, Rank});
			_ ->
				[{GroupId, Point, 0} | AccList]
		end
	    end,
	NewGroupList = lists:foldl(F, [{1, 0, 1}, {2, 0, 2}, {3, 0, 3}], RoleList),
	SortGroupList = sort_group_by_point(NewGroupList),
	set_rank_pk_group(SortGroupList).


update_point_to_local(RoleList, Mod) ->
%%	?MYLOG("holy2", "RoleList ~p~n", [RoleList]),
	case util:is_cls() of
		true ->
			[mod_clusters_center:apply_cast(ServerId, lib_holy_spirit_battlefield, update_point_to_local, [RoleId, Point, Mod])
				|| #role_point{point = Point, server_id = ServerId, role_id = RoleId} <- RoleList];
		_ ->
			[lib_holy_spirit_battlefield:update_point_to_local(RoleId, Point, Mod)
				|| #role_point{point = Point, role_id = RoleId} <- RoleList]
	end.
	


pack_role_list_21808(RankRoleList) ->
	[{RoleId, Rank, ServerId, ServerNum, Name, Point, KillNum, Assist} || #role_point{role_id = RoleId, rank = Rank, server_id = ServerId,
		server_num = ServerNum, role_name = Name, point = Point, kill_num = KillNum, assist = Assist} <- RankRoleList].


get_group_res_msg(GroupMap, TowerList) ->
	GroupMapList = maps:to_list(GroupMap),
	F = fun({GroupId, Group}, AccList) ->
			#group_point{point = GroupPoint} = Group,
			TowerNum = lib_holy_spirit_battlefield:get_tower_num(GroupId, TowerList),
			[{GroupId, TowerNum, GroupPoint} | AccList]
		end,
	List = lists:foldl(F, [], GroupMapList),
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


