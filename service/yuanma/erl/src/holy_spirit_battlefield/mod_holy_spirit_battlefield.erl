%%%-----------------------------------
%%% @Module      : mod_holy_spirit_battlefield
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 十月 2019 15:33
%%% @Description : 圣灵战场   跨服的
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_holy_spirit_battlefield).
-author("carlos").

%% API
-export([]).





-author("chenyiming").
-include("common.hrl").
-include("holy_spirit_battlefield.hrl").
-include("scene.hrl").
-define(MOD_STATE, holy_spirit_battle_state).

%% API
-export([]).






start_link() ->
	gen_server:start_link({local, mod_holy_spirit_battlefield}, mod_holy_spirit_battlefield, [], []).

%% 同步分服
sync_zone_group(InfoList) ->
	gen_server:cast(?MODULE, {sync_zone_group, InfoList}).

%% 弃用，使用 sync_zone_group/1 @20210916
%% 重新计算分组
re_alloc_group() ->
	gen_server:cast(?MODULE, {re_alloc_group}).

%% 跨天触发
day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).


%% 秘籍开启活动
gm_act_start() ->
	gen_server:cast(?MODULE, {gm_act_start}).


%% 秘籍直接进入pk
gm_pk_start() ->
	gen_server:cast(?MODULE, {gm_pk_start}).


%% 秘籍直接进入pk
gm_end() ->
	gen_server:cast(?MODULE, {gm_end}).


%%获取界面信息
get_info(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_info, ServerId, RoleId}).

%%进入场景
enter_scene(Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName) ->
	gen_server:cast(?MODULE, {enter_scene, Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName}).



quit_scene(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {quit_scene, ServerId, RoleId}).


get_exp(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_exp, ServerId, RoleId}).


add_exp(ServerId, RoleId, ExpAdd) ->
	gen_server:cast(?MODULE, {add_exp, ServerId, RoleId, ExpAdd}).

%%%% 怪物被击杀
%%kill_mon(SceneId, Atter, Klist, Minfo) ->
%%%%	?MYLOG("holy", "SceneId  ~p~n", [SceneId]),
%%	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) of
%%		true ->
%%%%			?MYLOG("holy", "SceneId  ~p~n", [SceneId]),
%%			gen_server:cast(?MODULE, {kill_mon, SceneId, Atter, Klist, Minfo});
%%		_ ->
%%			skip
%%	end.



%%击杀敌人
kill_enemy(SceneId, PoolId, RoomId, DefRoleId, Atter, HitList) ->
	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) of
		true ->
			gen_server:cast(?MODULE, {kill_enemy, SceneId, PoolId, RoomId, DefRoleId, Atter, HitList});
		_ ->
			skip
	end.



%%  塔受伤害  %% 废弃
%%mon_be_hurt(SceneId, Atter, Minfo) ->
%%	case lib_holy_spirit_battlefield:is_pk_scene(SceneId) of
%%		true ->
%%			gen_server:cast(?MODULE, {mon_be_hurt, SceneId, Atter, Minfo});
%%		_ ->
%%			skip
%%	end.


%% 战场统计信息
get_battle_all_msg(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_battle_all_msg, ServerId, RoleId}).


use_anger_skill(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {use_anger_skill, ServerId, RoleId}).




%% 战场信息
get_battle_msg(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_battle_msg, ServerId, RoleId}).


%%玩家复活
revive(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {revive, ServerId, RoleId}).


center_connected() ->
	gen_server:cast(?MODULE, {center_connected, 0, 0, 0, 0, 0, 0}).

center_connected(ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds) ->
	Day = lib_holy_spirit_battlefield:get_open_day(OpTime),
	NeedDay = data_holy_spirit_battlefield:get_kv(open_day),
	if
		Day >= NeedDay->
			gen_server:cast(?MODULE, {center_connected, ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds});
		true ->
			skip
	end.


get_status_time(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {get_status_time, ServerId, RoleId}).


get_mon_msg(ServerId, RoleId, PooId, CopyId) ->
	gen_server:cast(?MODULE, {get_mon_msg, ServerId, RoleId, PooId, CopyId}).
	
	


%%秘籍重新计算
gm_calc_server() ->
	gen_server:cast(?MODULE, {center_connected, 0, 0, 0, 0, 0, 0}).

init([]) ->
	State = lib_holy_spirit_battlefield_mod:init(),
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

do_handle_cast({get_status_time, ServerId, RoleId}, State) ->
	#holy_spirit_battle_state{status = Status, end_time = EndTime} = State,
	{ok ,Bin} = pt_218:write(21811, [Status, EndTime]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin),
	{noreply, State};

do_handle_cast({center_connected, ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:center_connected(ServerId,
		OpTime, WorldLv, ServerNum, ServerName, MergeSerIds, State),
	{noreply, NewState};




do_handle_cast({revive, ServerId, RoleId}, State) ->
	case lib_holy_spirit_battlefield_mod:get_pk_pid(ServerId, RoleId, State) of
		Pid when is_pid(Pid) ->
%%			?MYLOG("holy", "revive ++++++++++++++++++++++  ~n", []),
			Pid ! {revive, ServerId, RoleId};
		_ ->
			skip
	end,
	{noreply, State};


do_handle_cast({get_mon_msg, ServerId, RoleId, PooId, CopyId}, State) ->
	case lib_holy_spirit_battlefield_mod:get_pk_pid(ServerId, RoleId, State) of
		Pid when is_pid(Pid) ->
			Pid ! {get_mon_msg, ServerId, RoleId, PooId, CopyId};
		_ ->
			skip
	end,
	{noreply, State};

do_handle_cast({use_anger_skill, ServerId, RoleId}, State) ->
	case lib_holy_spirit_battlefield_mod:get_pk_pid(ServerId, RoleId, State) of
		Pid when is_pid(Pid) ->
			Pid ! {use_anger_skill, ServerId, RoleId};
		_ ->
			skip
	end,
	{noreply, State};




do_handle_cast({get_battle_all_msg, ServerId, RoleId}, State) ->
	case lib_holy_spirit_battlefield_mod:get_pk_pid(ServerId, RoleId, State) of
		Pid when is_pid(Pid) ->
			Pid ! {get_battle_all_msg, ServerId, RoleId};
		_ ->
			skip
	end,
	{noreply, State};



do_handle_cast({get_battle_msg, ServerId, RoleId}, State) ->
	case lib_holy_spirit_battlefield_mod:get_pk_pid(ServerId, RoleId, State) of
		Pid when is_pid(Pid) ->
			Pid ! {get_battle_msg, ServerId, RoleId};
		_ ->
			skip
	end,
	{noreply, State};


do_handle_cast({kill_enemy, SceneId, PoolId, RoomId, DefRoleId, Atter, HitList}, State) ->
%%	##battle_return_atter{id = AtterId} = Atter,
	lib_holy_spirit_battlefield_mod:kill_enemy(SceneId, PoolId, RoomId, DefRoleId, Atter, HitList, State),
	{noreply, State};




do_handle_cast({mon_be_hurt, SceneId, Atter, Minfo}, State) ->
%%	##battle_return_atter{id = AtterId} = Atter,
	lib_holy_spirit_battlefield_mod:mon_be_hurt(SceneId, Atter, Minfo, State),
	{noreply, State};



do_handle_cast({kill_mon, SceneId, Atter, Klist, Minfo}, State) ->
%%	##battle_return_atter{id = AtterId} = Atter,
	lib_holy_spirit_battlefield_mod:kill_mon(SceneId, Atter, Klist, Minfo, State),
	{noreply, State};



do_handle_cast({add_exp, ServerId, RoleId, ExpAdd}, State) ->
	#holy_spirit_battle_state{exp_map = ExpMap} = State,
	OldExp = maps:get(RoleId, ExpMap, 0),
	NewMap = maps:put(RoleId, OldExp + ExpAdd, ExpMap),
	{ok, Bin} = pt_218:write(21804, [ExpAdd + OldExp]),
	lib_holy_spirit_battlefield:send_to_client(ServerId, RoleId, Bin),
	{noreply, State#holy_spirit_battle_state{exp_map = NewMap}};


do_handle_cast({get_exp, ServerId, RoleId}, State) ->
	lib_holy_spirit_battlefield_mod:get_exp(ServerId, RoleId, State),
	{noreply, State};


do_handle_cast({quit_scene, ServerId, RoleId}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:quit_scene(ServerId, RoleId, State),
	{noreply, NewState};

do_handle_cast({enter_scene, Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:enter_scene(Turn, Career, PictureId, Picture, Lv, ServerNum, ServerId, RoleId, Power, RoleName, State),
	{noreply, NewState};

do_handle_cast({get_info, ServerId, RoleId}, State) ->
	lib_holy_spirit_battlefield_mod:get_info(ServerId, RoleId, State),
	{noreply, State};


do_handle_cast({sync_zone_group, InfoList}, State) ->
	case State#holy_spirit_battle_state.is_init of
		1 ->
			NewState = lib_holy_spirit_battlefield_mod:sync_zone_group(State, InfoList);
		_ ->
			NewState = lib_holy_spirit_battlefield_mod:async_init(State, InfoList)
	end,
	{noreply, NewState};

do_handle_cast({re_alloc_group}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:re_alloc_group(State),
	{noreply, NewState};

do_handle_cast({day_trigger}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:day_trigger(State),
	{noreply, NewState};

do_handle_cast({gm_act_start}, State) ->
	#holy_spirit_battle_state{end_time = EndTime} = State,
	case utime:unixtime() < EndTime of 
		true -> 
			NewState = State;
		_ ->
			NewState = lib_holy_spirit_battlefield_mod:act_open(State)
	end, 
	{noreply, NewState};


do_handle_cast({gm_end}, State) ->
%%	?MYLOG("holy2", " ++++++++++++~n", []),
	NewState = lib_holy_spirit_battlefield_mod:gm_end(State),
	{noreply, NewState};

do_handle_cast({gm_pk_start}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:start_pk(State),
	{noreply, NewState};



do_handle_cast(_Request, State) ->
	{noreply, State}.





do_handle_info({add_exp}, State) ->
%%	?MYLOG("holy", "add exp ~n", []),
	NewState = lib_holy_spirit_battlefield_mod:add_exp(State),
	{noreply, NewState};

do_handle_info({act_open}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:act_open(State),
	{noreply, NewState};

do_handle_info({start_pk}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:start_pk(State),
	{noreply, NewState};

do_handle_info({act_end}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:act_end(State),
	{noreply, NewState};

do_handle_info({center_connected}, State) ->
	NewState = lib_holy_spirit_battlefield_mod:center_connected(State),
	{noreply, NewState};


do_handle_info(_Request, State) ->
	{noreply, State}.



