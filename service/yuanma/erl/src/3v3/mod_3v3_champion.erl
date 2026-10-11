%%%-----------------------------------
%%% @Module      : mod_3v3_champion
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 15. 七月 2019 17:00
%%% @Description : 冠军赛
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_3v3_champion).
-author("chenyiming").

-include("3v3.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_id_create.hrl").
-include("common.hrl").

%% API
-export([]).


start_link() ->
	gen_server:start_link({local, mod_3v3_champion}, mod_3v3_champion, [], []).



update_champion_data(RankData) ->
	gen_server:cast(?MODULE, {update_champion_data, RankData}).

update_champion_role_data(RoleMsg) ->
	gen_server:cast(?MODULE, {update_champion_role_data, RoleMsg}).


gm_start_champion_pk() ->
	gen_server:cast(?MODULE, {gm_start_champion_pk}).

refresh_champion_team(Data, TeamA, TeamB) ->
	gen_server:cast(?MODULE, {refresh_champion_team, Data, TeamA, TeamB}).
%%进入场景
enter_scene(TeamId, RoleId, Node) ->
%%	?MYLOG("3v3", " +++++++++++++++65076 ~n", []),
	gen_server:cast(?MODULE, {enter_scene, TeamId, RoleId, Node}).

%%获得战场信息
get_battle_info(ServerId, RoleID, RoleSid, TeamId) ->
	gen_server:cast(?MODULE, {get_battle_info, ServerId, RoleID, RoleSid, TeamId}).

%%进出塔
enter_or_quit_tower(RoleId, Type, TowerId, TeamId) ->
	gen_server:cast(?MODULE, {enter_or_quit_tower, RoleId, Type, TowerId, TeamId}).

%%击杀统计
kill_enemy(SceneId, RoomId, DefRoleId, AtterId, HitList, TeamId) ->
	gen_server:cast(?MODULE, {kill_enemy, SceneId, RoomId, DefRoleId, AtterId, HitList, TeamId}).

quit_scene(TeamId, MyRoleId, Node) ->
	gen_server:cast(?MODULE, {quit_scene, TeamId, MyRoleId, Node}).

%%获得队伍的比赛信息
get_champion_msg(TeamId, MyRoleId, ServerId, Node) ->
	gen_server:cast(?MODULE, {get_champion_msg, TeamId, MyRoleId, ServerId, Node}).

%%召集队员
call_team_role(TeamId, MyRoleId) ->
	gen_server:cast(?MODULE, {call_team_role, TeamId, MyRoleId}).


%%冠军赛整个比赛概况
champion_team_list_info(RoleId, Node) ->
	gen_server:cast(?MODULE, {champion_team_list_info, RoleId, Node}).

%%竞猜
guess(ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum) ->
	gen_server:cast(?MODULE, {guess, ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum}).

%%竞猜列表
guess_list(ServerId, MyRoleId, ToDayGuessRecordList) ->
	gen_server:cast(?MODULE, {guess_list, ServerId, MyRoleId, ToDayGuessRecordList}).

%%16强战队，详细信息
champion_team_detail_msg(ServerId, MyRoleId, TeamId) ->
	gen_server:cast(?MODULE, {champion_team_detail_msg, ServerId, MyRoleId, TeamId}).

%%战力对比
power_compare(ServerId, MyRoleId, TeamAId, TeamBId) ->
	gen_server:cast(?MODULE, {power_compare, ServerId, MyRoleId, TeamAId, TeamBId}).


observed(ServerId, MyRoleId, TeamId) ->
	gen_server:cast(?MODULE, {observed, ServerId, MyRoleId, TeamId}).

quit_observed(ServerId, MyRoleId, TeamId) ->
	gen_server:cast(?MODULE, {quit_observed, ServerId, MyRoleId, TeamId}).

day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).

get_role_list_msg(RoleId, Node, ClientTeamId) ->
	gen_server:cast(?MODULE, {get_role_list_msg, RoleId, Node, ClientTeamId}).

%%冠军赛阶段信息
stage_msg(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {stage_msg, ServerId, RoleId}).


init([]) ->
	%% 读取数据库
	Now = utime:unixtime(),
	ChampionStarTime = lib_3v3_api:champion_start_time(),
%%	?MYLOG("3v3", "ChampionStarTime ~p~n", [ChampionStarTime]),
	if
		Now > ChampionStarTime ->  %%比赛阶段已经过去了
%%			?MYLOG("3v3", "over+++++++++~n", []),
			GetDataRef = [],
			Ref = [];
		true ->
			%% get_champion_data  start_champion
			GetDataTime = utime:unixdate(ChampionStarTime) - Now,
			if
				GetDataTime < 0 ->
					GetDataRef = [];
				true ->
					GetDataRef = util:send_after([], max(utime:unixdate(ChampionStarTime) - Now, 1) * 1000, self(), {get_champion_data})
			end,
			Ref = util:send_after([], max(ChampionStarTime - Now, 1) * 1000, self(), {start_champion})
	end,
	TeamList = lib_3v3_champion_mod:init_team_list(),
%%	?MYLOG("3v3", "TeamList ~p~n", [TeamList]),
	{ok, #champion_state{ref = Ref, get_data_ref = GetDataRef, team_list = TeamList, start_time = ChampionStarTime}}.



handle_cast(Request, State) ->
	try
		do_handle_cast(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.


handle_info(Request, State) ->
	try
		do_handle_info(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% 冠军赛状态信息
do_handle_cast({stage_msg, ServerId, RoleId}, State) ->
	#champion_state{status = Status, stage_end_time = EndTime} = State,
	if
		Status == ?champion_close ->  %%未开启
			ok;
		true ->
			{ok, Bin} = pt_650:write(65088, [?SUCCESS, Status, EndTime]),
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin])
	end,
	{noreply, State};
do_handle_cast({get_role_list_msg, RoleId, Node, TeamId}, State) ->
	#champion_state{team_list = TeamList} = State,
	?MYLOG("3v3pk", "get_role_list_msg +++++++++ ~p ~n", [TeamId]),
	case lists:keyfind(TeamId, #champion_team.team_id, TeamList) of
		#champion_team{pk_pid = PkPid} ->
			?MYLOG("3v3pk", "get_role_list_msg +++++++++~n", []),
			PkPid ! {get_role_list_msg, RoleId, Node};
		_ ->
			ok
	end,
	{noreply, State};
do_handle_cast({day_trigger}, State) ->
	#champion_state{start_time = StartTime, ref = OldRef, get_data_ref = OldDataRef} = State,
	Now = utime:unixtime(),
	ChampionStarTime = lib_3v3_api:champion_start_time(),
	if
		ChampionStarTime > StartTime->  %% get_champion_data
			GetDataRef = util:send_after(OldDataRef, max(utime:unixdate(ChampionStarTime) - Now, 1) * 1000, self(), {get_champion_data}),
			Ref = util:send_after(OldRef, max(ChampionStarTime - Now, 1) * 1000, self(), {start_champion}),
			{noreply, State#champion_state{start_time = ChampionStarTime, ref = Ref, get_data_ref = GetDataRef}};
		true ->
			{noreply, State}
	end;

do_handle_cast({quit_observed, ServerId, MyRoleId, TeamId}, State) ->
	lib_3v3_champion_mod:quit_observed(ServerId, MyRoleId, TeamId, State),
	{noreply, State};
do_handle_cast({observed, ServerId, MyRoleId, TeamId}, State) ->
	lib_3v3_champion_mod:observed(ServerId, MyRoleId, TeamId, State),
	{noreply, State};


do_handle_cast({power_compare, ServerId, MyRoleId, TeamAId, TeamBId}, State) ->
	lib_3v3_champion_mod:power_compare(ServerId, MyRoleId, TeamAId, TeamBId, State),
	{noreply, State};

do_handle_cast({champion_team_detail_msg, ServerId, MyRoleId, TeamId}, State) ->
	lib_3v3_champion_mod:champion_team_detail_msg(ServerId, MyRoleId, TeamId, State),
	{noreply, State};

do_handle_cast({guess_list, ServerId, MyRoleId, ToDayGuessRecordList}, State) ->
	lib_3v3_champion_mod:guess_list(ServerId, MyRoleId, ToDayGuessRecordList, State),
	{noreply, State};

do_handle_cast({guess, ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum}, State) ->
	NewState = lib_3v3_champion_mod:guess(ServerId, MyRoleId, Turn, TeamAId, TeamBId, Opt, CostType, CostNum, State),
	{noreply, NewState};

do_handle_cast({call_team_role, TeamId, MyRoleId}, State) ->
	lib_3v3_champion_mod:call_team_role(TeamId, MyRoleId, State),
	{noreply, State};

do_handle_cast({champion_team_list_info, RoleId, Node}, State) ->
	lib_3v3_champion_mod:champion_team_list_info(RoleId, Node, State),
	{noreply, State};

do_handle_cast({get_champion_msg, TeamId, MyRoleId, ServerId, Node}, State) ->
	lib_3v3_champion_mod:get_champion_msg(TeamId, MyRoleId, ServerId, Node, State),
	{noreply, State};

do_handle_cast({quit_scene, TeamId, MyRoleId, Node}, State) ->
	NewState = lib_3v3_champion_mod:quit_scene(TeamId, MyRoleId, Node, State),
	{noreply, NewState};

do_handle_cast({kill_enemy, SceneId, RoomId, DefRoleId, AtterId, HitList, TeamId}, State) ->
	lib_3v3_champion_mod:kill_enemy(SceneId, RoomId, DefRoleId, AtterId, HitList, TeamId, State),
	{noreply, State};

do_handle_cast({enter_or_quit_tower, RoleId, Type, TowerId, TeamId}, State) ->
	lib_3v3_champion_mod:enter_or_quit_tower(RoleId, Type, TowerId, TeamId, State),
	{noreply, State};

do_handle_cast({get_battle_info, ServerId, RoleID, RoleSid, TeamId}, State) ->
	lib_3v3_champion_mod:get_battle_info(ServerId, RoleID, RoleSid, TeamId, State),
	{noreply, State};


do_handle_cast({enter_scene, TeamId, RoleId, Node}, State) ->
	NewState = lib_3v3_champion_mod:enter_scene(TeamId, RoleId, Node, State),
	{noreply, NewState};


do_handle_cast({refresh_champion_team, Data, TeamA, TeamB}, State) ->
	NewState = lib_3v3_champion_mod:refresh_champion_team(Data, TeamA, TeamB, State),
	{noreply, NewState};

do_handle_cast({gm_start_champion_pk}, State) ->
	NewState = lib_3v3_champion_mod:start_champion(State),
	{noreply, NewState};


do_handle_cast({update_champion_data, RankData}, State) ->
	NewState = lib_3v3_champion_mod:update_champion_data(RankData, State),
	{noreply, NewState};

do_handle_cast({update_champion_role_data, RoleMsg}, State) ->
	NewState = lib_3v3_champion_mod:update_champion_role_data(RoleMsg, State),
	{noreply, NewState};

do_handle_cast(_Request, State) ->
	{noreply, State}.




do_handle_info({start_champion}, State) ->
	NewState = lib_3v3_champion_mod:start_champion(State),
	{noreply, NewState};


do_handle_info({get_champion_data}, State) ->
	NewState = lib_3v3_champion_mod:get_champion_data(State),
	{noreply, NewState};

do_handle_info({start_pk}, State) ->
	NewState = lib_3v3_champion_mod:start_pk(State),
	{noreply, NewState};

do_handle_info({start_guess}, State) ->
	NewState = lib_3v3_champion_mod:start_guess(State),
	{noreply, NewState};


do_handle_info(_Request, State) ->
	{noreply, State}.



























