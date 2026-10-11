%%%-----------------------------------
%%% @Module      : mod_dragon_language_boss
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 九月 2019 17:20
%%% @Description : 
%%%-----------------------------------
-module(mod_dragon_language_boss).
-compile(export_all).


-include("dragon_language_boss.hrl").
-include("common.hrl").

-define(MOD_STATE, dragon_language_boss_state).     %% 九魂圣殿状态


%% 界面信息
get_info(ServerId, AllCount, LastCount, RoleId) ->
	gen_server:cast(?MODULE, {get_info, ServerId, AllCount, LastCount, RoleId}).

%% 进入场景
enter(ServerId, ServerNum, RoleId, RoleName, MapId, MonId) ->
	gen_server:cast(?MODULE, {enter, ServerId, ServerNum, RoleId, RoleName, MapId, MonId}).

%% 退出场景
quit(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {quit, ServerId, RoleId}).

%% 怪物被杀死
mon_be_killed(PoolId, CopyId, MonCfgId) ->
	gen_server:cast(?MODULE, {mon_be_killed, PoolId, CopyId, MonCfgId}).

%% 获取剩余时间
get_left_time(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_left_time, ServerId, RoleId}).

%% 获取掉落记录
get_boss_drop_log(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {'get_boss_drop_log', ServerId, RoleId}).

%% 记录掉落
add_drop_log(ServerId, ServerNum, RoleId, Name, SceneId, MonId, GoodsInfoL) ->
	case length(GoodsInfoL) > 0 of
		true ->
			gen_server:cast(?MODULE, {'add_drop_log', ServerId, ServerNum, RoleId, Name, SceneId, MonId, GoodsInfoL});
		false ->
			skip
	end.

%% 增加时间
add_time(ServerId, RoleId, AddTime, AllCount, LeftCount, Cost) ->
	gen_server:cast(?MODULE, {add_time, ServerId, RoleId, AddTime, AllCount, LeftCount, Cost}).

repair_mon() ->
	gen_server:cast(?MODULE, {repair_mon}).

repair_on_line_num() ->
	gen_server:cast(?MODULE, {repair_on_line_num}).

%% 暂停玩法
gm_clear_user(ReqServerId) ->
	gen_server:cast(?MODULE, {gm_clear_user, ReqServerId}).

%% 调整分区
zone_change(ServerId, OldZone, NewZone) ->
	gen_server:cast(?MODULE, {zone_change, ServerId, OldZone, NewZone}).

start_link() ->
	gen_server:start_link({local, mod_dragon_language_boss}, mod_dragon_language_boss, [], []).

init([]) ->
	State = lib_dragon_language_boss_mod:init(),
	{ok, State}.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
			{noreply, State}
	end.


handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
			{noreply, State}
	end.

do_handle_cast({repair_mon}, State) ->
	NewState = lib_dragon_language_boss_mod:repair_mon(State),
	{noreply, NewState};


do_handle_cast({add_time, ServerId, RoleId, AddTime, AllCount, LeftCount, Cost}, State) ->
	NewState = lib_dragon_language_boss_mod:add_time(ServerId, RoleId, AddTime, AllCount, LeftCount, Cost, State),
	{noreply, NewState};


do_handle_cast({'add_drop_log', ServerId, ServerNum, RoleId, RoleName, _SceneId, BossId, GoodsInfoL}, State) ->
	NowTime = utime:unixtime(),
	#dragon_language_boss_state{drop_log = BossDropLog, zone_list = ZoneList} = State,
	F = fun(#drop_log{is_top = IsTop}) -> IsTop == 1 end,  %% 目前所有都不置顶
	{Satisfying, NotSatisfying} = lists:partition(F, BossDropLog),
	F2 = fun({GoodsId, Num, Rating, Attr}, {TmpSatisfying, TmpNotSatisfying}) ->
		Log = #drop_log{
			role_id = RoleId, name = RoleName, boss_type = 0, boss_id = BossId, goods_id = GoodsId, num = Num,
			rating = Rating, equip_extra_attr = Attr, time = NowTime, server_id = ServerId, server_num = ServerNum
		},
		{TmpSatisfying, [Log#drop_log{is_top = 0} | TmpNotSatisfying]}
	end,
	{NewSatisfying, NewNotSatisfying} = lists:foldl(F2, {Satisfying, NotSatisfying}, GoodsInfoL),
	LogLen = data_dragon_language_boss:get_kv(log_length),
	NewBossDropLog = lists:sublist(NewSatisfying ++ NewNotSatisfying, LogLen),
	%% 发送分区传闻
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{server_info_list = ServerInfoList} ->
			ServerIds = [ServerId2 || #server_info{server_id = ServerId2} <- ServerInfoList],
			lib_dragon_language_boss_util:send_tv(add_drop_log, [GoodsInfoL, RoleName, ServerNum, ServerIds]);
		_ -> skip
	end,
	{noreply, State#dragon_language_boss_state{drop_log = NewBossDropLog}};

do_handle_cast({'get_boss_drop_log', ServerId, RoleId}, State) ->
	#dragon_language_boss_state{drop_log = DropLog} = State,
	F = fun(Log) ->
		#drop_log{
			role_id = RoleId1, name = RoleName, boss_type = _BossType, boss_id = BossId, goods_id = GoodsId, num = Num,
			rating = Rating, equip_extra_attr = Attr, is_top = IsTop, time = Time, server_id = ServerId2, server_num = ServerNum
		} = Log,
		{Time, ServerId2, ServerNum, RoleId1, RoleName, BossId, GoodsId, Num, Rating, Attr, IsTop}
	    end,
	List = lists:map(F, DropLog),
	{ok, Bin} = pt_651:write(65106, [List]),
	lib_dragon_language_boss_mod:send_to_uid(ServerId, RoleId, Bin),
	{noreply, State};

do_handle_cast({get_left_time, ServerId, RoleId}, State) ->
	lib_dragon_language_boss_mod:get_left_time(ServerId, RoleId, State),
	{noreply, State};

do_handle_cast({mon_be_killed, PoolId, CopyId, MonCfgId}, State) ->
	NewState = lib_dragon_language_boss_mod:mon_be_killed(PoolId, CopyId, MonCfgId, State),
	{noreply, NewState};

do_handle_cast({quit, ServerId, RoleId}, State) ->
	NewState = lib_dragon_language_boss_mod:quit(ServerId, RoleId, State),
	{noreply, NewState};

do_handle_cast({enter, ServerId, ServerNum, RoleId, RoleName, MapId, MonId}, State) ->
	NewState = lib_dragon_language_boss_mod:enter(ServerId, ServerNum, RoleId, RoleName, MapId, MonId, State),
	{noreply, NewState};

do_handle_cast({get_info, ServerId, AllCount, LastCount, RoleId}, State) ->
	lib_dragon_language_boss_mod:get_info(ServerId, AllCount, LastCount, RoleId, State),
	{noreply, State};

do_handle_cast({repair_on_line_num}, State) ->
	NewState = lib_dragon_language_boss_mod:repair_on_line_num(State),
	{noreply, NewState};

do_handle_cast({gm_clear_user, ReqServerId}, State) ->
	NewState = lib_dragon_language_boss_mod:gm_clear_user(ReqServerId, State),
	{noreply, NewState};

do_handle_cast({zone_change, ServerId, OldZone, NewZone}, State) ->
	NewState = lib_dragon_language_boss_mod:zone_change(ServerId, OldZone, NewZone, State),
	{noreply, NewState};

do_handle_cast(_Request, State) ->
	{noreply, State}.


do_handle_info({role_time_out, ZoneId, RoleId}, State) ->
	NewState = lib_dragon_language_boss_mod:role_time_out(ZoneId, RoleId, State),
	{noreply, NewState};

do_handle_info(_Request, State) ->
	{noreply, State}.



























