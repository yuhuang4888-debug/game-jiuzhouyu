%%%-----------------------------------
%%% @Module      : mod_holy_spirit_battlefield_room
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十月 2019 17:59
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_holy_spirit_battlefield_room).
-author("carlos").
-include("holy_spirit_battlefield.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("attr.hrl").


-define(MOD_STATE, battle_state).

%% API
-export([]).


%%============================================================================================
%% 怪物受到伤害
mon_be_hurt(SceneId, Atter, Minfo) ->
	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) of
		true ->
			#scene_object{config_id = MonId, battle_attr = BA, scene_pool_id = PoolId, copy_id = CopyId, id = MonAutoId, mod_args = Args} = Minfo,
			case Args of
				{battle_pid, Pid} ->
%%					?MYLOG("holy", "mon_be_hurt  Pid ~p~n", [Pid]),
					Pid ! {mon_be_hurt, Atter, MonAutoId, MonId, PoolId, CopyId, BA#battle_attr.hp, BA#battle_attr.group};
				_ ->
					skip
			end;
		_ ->
			skip
	end.
%% 怪物被击杀
kill_mon(SceneId, Atter, Klist, Minfo) ->
	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) of
		true ->
			#scene_object{config_id = MonId, mod_args = Args} = Minfo,
			case Args of
				{battle_pid, Pid} ->
%%					?MYLOG("holy", "kill_mon  Pid ~p~n", [Pid]),
					Pid ! {kill_mon, Atter, Klist, MonId};
				_ ->
					skip
			end;
		_ ->
			skip
	end.


get_battle_msg(BattlePid, ServerId, RoleId) ->
	BattlePid ! {get_battle_all_msg, ServerId, RoleId}.

%%============================================================================================



%% @desc : 不能让子进程挂掉而导致公共进程挂掉
start(Args) ->
	gen_server:start_link(?MODULE, Args, []).

init([EndTime, Mod, _RoleList, CopyId, ZoneId]) ->
	RoleList = [ lib_holy_spirit_battlefield:role_msg_to_pk(Role)|| Role<-_RoleList],
	%%更新玩家进程的Pid
	case util:is_cls() of
		true ->
			[mod_clusters_center:apply_cast(ServerIdTemp, lib_holy_spirit_battlefield, update_battle_pid, [RoleIdTemp, self()]) ||
				#role_pk_msg{role_id = RoleIdTemp, server_id = ServerIdTemp} <- RoleList];
		_ ->
			[lib_holy_spirit_battlefield:update_battle_pid(RoleIdTemp, self()) ||
				#role_pk_msg{role_id = RoleIdTemp} <- RoleList]
	end,
	{NewRoleList, GroupList} = lib_holy_spirit_battlefield_room_mod:alloc_group(RoleList),
	%% 生成塔
	TowerList =  lib_holy_spirit_battlefield_room_mod:create_tower(ZoneId, CopyId),
	lib_holy_spirit_battlefield:pull_role_into_pk_scene(NewRoleList, ZoneId), %% 拉玩家进场
	ScenePointRef = lib_holy_spirit_battlefield:get_in_scene_point_ref([]),
	%%通知客户端
	{ok, Bin} = pt_218:write(21811, [?pk, EndTime]),
	{ok, Bin} = pt_218:write(21811, [?pk, EndTime]),
	[lib_holy_spirit_battlefield:send_to_client(ServerId1, RoleId1, Bin) ||
		#role_pk_msg{server_id = ServerId1, role_id = RoleId1} <- RoleList],
	SendRef = util:send_after([], ?send_time * 1000, self(), {'send_battle_msg'}),  %%
	{ok, PointPid} = mod_holy_spirit_battlefield_room_point:start([Mod]),
	State = #battle_state{role_list = NewRoleList, copy_id = CopyId,
		zone_id = ZoneId, mod = Mod, group_list = GroupList, tower_list = TowerList,
		end_ref = [], scene_point_ref = ScenePointRef, end_time = EndTime, send_ref = SendRef, point_pid = PointPid},
	lib_holy_spirit_battlefield_room_mod:broadcast_mon_msg(ZoneId, CopyId, TowerList),
	{ok, State}.


enter(Pid, RolePkMsg) ->
	Pid ! {enter, RolePkMsg}.

quit(Pid, ServerId, RoleId) ->
	Pid ! {quit, ServerId, RoleId}.


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


do_handle_info({kill_enemy, Atter, DefRoleId, HitList}, State) ->
	NewState = lib_holy_spirit_battlefield_room_mod:kill_enemy(Atter, DefRoleId, HitList, State),
	{noreply, NewState};




do_handle_info({mon_be_hurt, Atter, MonAutoId, MonId, PoolId, CopyId, Hp, Group}, State) ->
%%	?MYLOG("holy", "MonId  ~p~n", [MonId]),
	NewState = lib_holy_spirit_battlefield_room_mod:mon_be_hurt(Atter, MonAutoId, MonId, PoolId, CopyId, Hp, Group, State),
	{noreply, NewState};



do_handle_info({kill_mon, Atter, Klist, MonId}, State) ->
%%	?MYLOG("holy", "MonId  ~p~n", [MonId]),
%%	?MYLOG("holy", "kill_mon  MonId  ~p~n", [MonId]),
	NewState = lib_holy_spirit_battlefield_room_mod:kill_mon(Atter, Klist, MonId, State),
	{noreply, NewState};


do_handle_info({enter, RolePkMsg}, State) ->
	NewState = lib_holy_spirit_battlefield_room_mod:enter(RolePkMsg, State),
	{noreply, NewState};

do_handle_info({quit, ServerId, RoleId}, State) ->
	NewState = lib_holy_spirit_battlefield_room_mod:quit( ServerId, RoleId, State),
	{noreply, NewState};


do_handle_info({act_end}, State) ->
%%	?MYLOG("holy", "act_end  act_end   ~n", []),
	lib_holy_spirit_battlefield_room_mod:act_end(State),
	{stop, normal, State};

do_handle_info({scene_point}, State) ->
%%    ?MYLOG("holy", "scene_point  +++++++++++++++   ~n", []),
	NewState =lib_holy_spirit_battlefield_room_mod:scene_point(State),
	{noreply, NewState};

do_handle_info({battle_msg}, State) ->
%%%%    ?MYLOG("holy", "scene_point  +++++++++++++++   ~n", []),
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(State), %% 广播
%%%%	OldRef = get(battle_msg),
%%	BattleRef = util:send_after(State#battle_state.battle_msg_ref, 3 * 1000, self(), {battle_msg}),
%%%%	put(battle_msg, BattleRef),
	{noreply, State};





do_handle_info({get_battle_all_msg, ServerId, RoleId}, State) ->
%%	?MYLOG("holy", "act_end  act_end   ~n", []),
	lib_holy_spirit_battlefield_room_mod:get_battle_all_msg(ServerId, RoleId, State),  %% 不能自动请求
	{noreply, State};




do_handle_info({get_battle_msg, _ServerId, _RoleId}, State) ->
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(State, RoleId),
	{noreply, State};

do_handle_info({'send_battle_msg'}, State) ->
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(State),
	lib_holy_spirit_battlefield_room_mod:broadcast_mon_msg(State#battle_state.zone_id, State#battle_state.copy_id, State#battle_state.tower_list),
	#battle_state{send_ref = Ref} = State,
%%	?MYLOG("cym", "send_battle_msg ++++++++++ ~n", []),
	NewRef = util:send_after(Ref, ?send_time * 1000, self(), {'send_battle_msg'}),
	{noreply, State#battle_state{send_ref = NewRef}};



do_handle_info({revive, ServerId, RoleId}, State) ->
	NewState = lib_holy_spirit_battlefield_room_mod:revive(ServerId, RoleId, State),
%%	lib_holy_spirit_battlefield:send_battle_msg_to_client(NewState, RoleId),
	#battle_state{zone_id = ZoneId, copy_id = CopyId} = State,
	lib_holy_spirit_battlefield_room_mod:get_mon_msg(ServerId, RoleId, ZoneId, CopyId, NewState),
	{noreply, NewState};

do_handle_info({use_anger_skill, ServerId, RoleId}, State) ->
	NewState = lib_holy_spirit_battlefield_room_mod:use_anger_skill(ServerId, RoleId, State),
	{noreply, NewState};

do_handle_info({get_mon_msg, ServerId, RoleId, PoolId, CopyId}, State) ->
	lib_holy_spirit_battlefield_room_mod:get_mon_msg(ServerId, RoleId, PoolId, CopyId, State),
	{noreply, State};





do_handle_info(_Request, State) ->
%%	?MYLOG("cym", "send_battle_msg ++++++++++ ~p ~n", [_Request]),
	{noreply, State}.




terminate(_Reason, _State) ->
	ok.

