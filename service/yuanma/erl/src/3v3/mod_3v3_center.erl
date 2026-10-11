%%% ----------------------------------------------------
%%% @Module:        mod_3v3_center
%%% @Author:        zhl
%%% @Description:   跨服3v3 - 跨服中心
%%% @Created:       2017/07/04
%%% ----------------------------------------------------

-module(mod_3v3_center).
-behaviour(gen_server).
-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-compile(export_all).

%%-export([
%%	logout/1,                                    %% 登出
%%	start_link/0,                                %% 启动跨服3v3进程
%%	create_team/1,                               %% 创建队伍
%%	apply_join_team/1,                           %% 申请入队伍
%%	invite_join_team/1,                          %% 受邀入队伍
%%	leave_team/1,                                %% 离开队伍
%%	ret_leave_team/1,                            %% 离开队伍 - 战场返回
%%	kick_out_team/1,                             %% 踢出队伍
%%	invite_role/1,                               %% 邀请玩家
%%	start_matching_team/1,                       %% 开始匹配 - 战斗
%%	stop_matching_team/1,                        %% 取消匹配 - 战斗
%%	start_matching_role/1,                       %% 开始匹配 - 组队
%%	stop_matching_role/1,                        %% 取消匹配 - 组队
%%	reset_ready/1,                               %% 准备 | 取消准备
%%	reset_auto/1,                                %% 自动开始 | 取消自动开始
%%	get_battle_info/1,                           %% 获取战场信息
%%	update_team_pk/1,                            %%
%%
%%	stop_pk_room/1,                              %% 退出房间
%%
%%	leave_pk_room/1,                             %% 离开战斗房间
%%	enter_pk_room/1,                             %% 重登战斗战场
%%	kill_enemy/1,                                %% 击杀玩家
%%	msg_to_team/1,                               %% 发送队伍消息
%%	get_left_time/1,
%%
%%	update_unite_data/1,
%%
%%	gm_start_3v3/1,
%%	gm_start_3v3/2,
%%	gm_start_3v3_2/1,
%%	gm_set_member_limit/1,
%%	test/1
%%]).

-include("server.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("3v3.hrl").
-include("def_module.hrl").
-include("errcode.hrl").

%% 跨服3v3数据
-record(state, {
	state_3v3 = 0,                               %% 活动状态
	ed_time = 0,                                 %% 结束时间
	% scenelist = [],                              %% 剩余场景列表
	auto_id = 1,                                 %% 队伍ID - 自增ID  %% 不用
	candinates = [],                             %% 候选队伍 - 匹配中
	pk_timer = [],                               %% 战斗匹配倒计时
	match_role = [],                             %% 候选玩家 - 匹配中
	team_timer = [],                             %% 队伍匹配倒计时
	act_timer = [],                              %% 活动倒计时
	member_limit = ?KF_3V3_MEMBER_LIMIT          %% 人数限制
}).

%% @desc :
%%   1）将修改的数据推送给所有的节点，由各个节点处理数据
%%   2）离开队伍或者被踢出队伍则删除玩家信息，战场内掉线不删除玩家信息
%%   3）满员情况或队员准备&自动开始，队伍数据只刷新队友所在节点

%% 登出
logout(Args) ->
	gen_server:cast(?MODULE, {logout, Args}).

%% 启动跨服3v3进程
start_link() ->
	gen_server:start_link({local, mod_3v3_center}, mod_3v3_center, [], []).

%% 创建队伍
create_team(Args) ->
	gen_server:cast(?MODULE, {create_team, Args}).

%% 申请入队伍
apply_join_team(Args) ->
	gen_server:cast(?MODULE, {apply_join_team, Args}).

%% 受邀入队伍
invite_join_team(Args) ->
	gen_server:cast(?MODULE, {invite_join_team, Args}).

%% 离开队伍
leave_team(Args) ->
	gen_server:cast(?MODULE, {leave_team, Args}).

%% 离开队伍 - 战场返回
ret_leave_team(Args) ->
	gen_server:cast(?MODULE, {ret_leave_team, Args}).

%% 踢出队伍
kick_out_team(Args) ->
	gen_server:cast(?MODULE, {kick_out_team, Args}).

%% 邀请玩家
invite_role(Args) ->
	gen_server:cast(?MODULE, {invite_role, Args}).

%% 开始匹配
start_matching_team(Args) ->
	gen_server:cast(?MODULE, {start_matching_team, Args}).

%% 取消匹配
stop_matching_team(Args) ->
	gen_server:cast(?MODULE, {stop_matching_team, Args}).

%% 开始匹配 - 组队
start_matching_role(Args) ->
	gen_server:cast(?MODULE, {start_matching_role, Args}).

%% 取消匹配 - 组队
stop_matching_role(Args) ->
	gen_server:cast(?MODULE, {stop_matching_role, Args}).

%% 准备 | 取消准备
reset_ready(Args) ->
	gen_server:cast(?MODULE, {reset_ready, Args}).

%% 自动开始 | 取消自动开始
reset_auto(Args) ->
	gen_server:cast(?MODULE, {reset_auto, Args}).

%% 获取战场信息
get_battle_info(Args) ->
	gen_server:cast(?MODULE, {get_battle_info, Args}).




%%投票后拉队伍去匹配
pull_team_to_match(TeamData) ->
	gen_server:cast(?MODULE, {pull_team_to_match, TeamData}).


%% 更新队伍的pk状态
update_team_pk(Args) ->
	?MODULE ! {update_team_pk, Args}.

%% 退出房间
stop_pk_room(Args) ->
	?MODULE ! {stop_pk_room, Args}.

%% 离开战斗房间
leave_pk_room(Args) ->
	?MODULE ! {leave_pk_room, Args}.

%% 重登战斗战场
enter_pk_room(Args) ->
	case misc:is_process_alive(misc:whereis_name(local, ?MODULE)) of
		true -> ?MODULE ! {enter_pk_room, Args};
		false -> skip
	end.

%% 击杀玩家
kill_enemy(Args) ->
	?MODULE ! {kill_enemy, Args}.

%% 发送队伍消息
msg_to_team(Args) ->
	?MODULE ! {msg_to_team, Args}.

get_left_time(Args) ->
	?MODULE ! {get_left_time, Args}.

update_unite_data(Args) ->
	?MODULE ! {update_unite_data, Args}.

gm_start_3v3(LastTime) ->
	?MODULE ! {start_3v3, LastTime}.

gm_start_3v3(LastTime, MemberLimit) ->
	?MODULE ! {gm_start_3v3, LastTime, MemberLimit}.

gm_start_3v3_2(LastTime) ->
%%	?MYLOG("cym", "LastTime ~p~n", [LastTime]),
	?MODULE ! {gm_start_3v3, LastTime}.

gm_set_member_limit(MemberLimit) ->
	?MODULE ! {gm_set_member_limit, MemberLimit}.

send_chat_to_team(TeamId, Id, BinData) ->
	gen_server:cast(?MODULE, {send_chat_to_team, TeamId, Id, BinData}).


test(Args) ->
	?MODULE ! {test, Args}.

init([]) ->
	process_flag(trap_exit, true),
	ets:new(?ETS_TEAM_DATA, [named_table, {keypos, #kf_3v3_team_data.team_id}, {read_concurrency, true}]),
	ets:new(?ETS_ROLE_DATA, [named_table, {keypos, #kf_3v3_role_data.role_id}, {read_concurrency, true}]),
	ets:new(?ETS_PK_DATA, [named_table, {keypos, #kf_3v3_pk_data.pk_pid}, {read_concurrency, true}]),
	State = ready_timer_3v3(),
	{ok, State}.

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

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

terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% 发送信息
do_handle_cast({send_chat_to_team, TeamId, RoleID, BinData}, State) ->
	#state{state_3v3 = State3v3} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:get_unite_role_data(RoleID)
	end,
	case Res of
		{false, _ResID} ->
			ok;
%%			mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_battle_info, [[RoleID, [ResID, 0, 0, 0, [], 0, 0]]]);
		{ok, #kf_3v3_role_data{team_id = TeamID, pk_pid = PKPid}}
			when TeamID > 0 andalso is_pid(PKPid) ->
			catch PKPid ! {send_chat_to_team, [TeamId, RoleID, BinData]};
		_ -> %% 战斗已结束
			ok
	end,
	{noreply, State};

%% 登出
do_handle_cast({logout, [Platform, ServerNum, ServerId, RoleID, RoleSid, Type, Is3v3Scene]}, State) ->
	#state{state_3v3 = State3v3} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			{noreply, State};
		true ->
			% 先离开战场,没有战场就离开队伍
			case lib_3v3_center:get_unite_role_data(RoleID) of
				{ok, #kf_3v3_role_data{team_id = TeamID, pk_pid = PKPid}} when TeamID > 0 andalso is_pid(PKPid) ->
					do_handle_info({leave_pk_room, [Platform, ServerNum, RoleID, Type, ServerId, Is3v3Scene]}, State);
				_ ->
					do_handle_cast({leave_team, [Platform, ServerNum, ServerId, RoleID, RoleSid]}, State)
			end
	end;

%% 创建队伍  （废弃）
do_handle_cast({create_team, #role_data{server_id = ServerId, sid = RoleSid, role_id = RoleID} = RoleData},
	#state{state_3v3 = State3v3, auto_id = AutoID} = State) ->
	if
		State3v3 /= ?KF_3V3_STATE_START ->
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:is_in_team(RoleID)
	end,
	case Res of
		{false, ResID} ->
			NState = State;
		{ok, UniteRoleData1} ->
			{ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} =
				lib_3v3_center:create_team([RoleData, AutoID, UniteRoleData1]),
			KeyValueList = [
				{update, ?ETS_TEAM_DATA, TeamData},
				{update, ?ETS_ROLE_DATA, NUniteRoleData}
			],
			update_to_ets(KeyValueList),
			lib_3v3_center:refresh_team_member(MemberData, KeyValueList), %% 只刷新队友节点
			ResID = ?SUCCESS,
			NState = State#state{auto_id = AutoID + 1}
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_create_team, [[RoleSid, ResID]]),
	{noreply, NState};


%% 拉队伍进入匹配
do_handle_cast({pull_team_to_match, TeamData}, #state{state_3v3 = State3v3, pk_timer = PKTimer, candinates = Candinates} = State) ->
	?MYLOG("3v3", "~p ~n", [TeamData]),
	#kf_3v3_team_data{server_id = ServerId, team_id = TeamId, member_data = MemberData} = TeamData,
	if
		State3v3 /= ?KF_3V3_STATE_START ->
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:check_team_matching(TeamId, Candinates)
	end,
	case Res of
		{false, ResID} ->
%%			?MYLOG("3v32", "++++++++++++++ ~p~n", [ResID]),
			NCandinates = Candinates;
		true ->
%%			?MYLOG("3v32", "++++++++++++++MemberData ~p  ~n", [MemberData]),
			KeyValueList = [
				{update, ?ETS_ROLE_DATA, MemberData},
				{update, ?ETS_TEAM_DATA, TeamData}
			],
			update_to_ets(KeyValueList),
			NCandinates = lists:keystore(TeamId, #kf_3v3_team_data.team_id, Candinates, TeamData),
			lib_3v3_center:refresh_team_match_status(ServerId, TeamId,
				[MemberId || #kf_3v3_role_data{role_id = MemberId} <- MemberData], ?team_matching),
			ResID = ?SUCCESS
	end,
	send_pull_team_to_match_res(MemberData, ResID),
	case PKTimer of
		[] -> NPKTimer = erlang:send_after(?kf_3v3_match_time, ?MODULE, {matching_team});
		_ -> NPKTimer = PKTimer
	end,
	?MYLOG("3v3", "NCandinates ~p ~n", [NCandinates]),
	NState = State#state{candinates = NCandinates, pk_timer = NPKTimer},
	{noreply, NState};



%% 申请入队伍
do_handle_cast({apply_join_team, [RoleData, TeamID, Password]}, State) ->
	#state{state_3v3 = State3v3, member_limit = MemberLimit} = State,
	#role_data{server_id = ServerId, sid = RoleSid, role_id = RoleID} = RoleData,
	if
		State3v3 /= ?KF_3V3_STATE_START ->
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:is_in_team(RoleID)
	end,
	case Res of
		{false, ResID} ->
			skip;
		{ok, UniteRoleData} ->
			case lib_3v3_center:to_join_team([TeamID, Password, RoleData, UniteRoleData, MemberLimit]) of
				{ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
					ResID = ?SUCCESS,
					KeyValueList = [
						{update, ?ETS_TEAM_DATA, TeamData},
						{update, ?ETS_ROLE_DATA, NUniteRoleData}
					],
					update_to_ets(KeyValueList),
					lib_3v3_center:refresh_team_member(MemberData, KeyValueList); %% 只刷新队友节点
				{false, ResID} ->
					skip
			end
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_apply_join, [[RoleSid, ResID]]),
	{noreply, State};

%% 受邀入队伍
do_handle_cast({invite_join_team, [RoleData, TeamID, Password]}, State) ->
	#state{state_3v3 = State3v3, member_limit = MemberLimit} = State,
	#role_data{server_id = ServerId, sid = RoleSid, role_id = RoleID} = RoleData,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:is_in_team(RoleID)
	end,
	case Res of
		{false, ResID} ->
			skip;
		{ok, UniteRoleData1} ->
			case lib_3v3_center:to_join_team([TeamID, Password, RoleData, UniteRoleData1, MemberLimit]) of
				{ok, NUniteRoleData, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
					ResID = ?SUCCESS,
					KeyValueList = [
						{update, ?ETS_TEAM_DATA, TeamData},
						{update, ?ETS_ROLE_DATA, NUniteRoleData}
					],
					update_to_ets(KeyValueList),
					lib_3v3_center:refresh_team_member(MemberData, KeyValueList); %% 只刷新队友节点
				{false, ResID} ->
					skip
			end
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_invite_join, [[RoleSid, ResID]]),
	{noreply, State};

%% 离开队伍
%% @desc : 自动取消匹配 && 战场中不能离开队伍
do_handle_cast({leave_team, [Platform, ServerNum, ServerId, RoleID, RoleSid]}, State) ->
	#state{state_3v3 = State3v3, candinates = Candinates} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:get_unite_role_data(RoleID)
	end,
	case Res of
		{false, ResID} ->
			NState = State,
			mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_team, [[RoleSid, ResID]]);
		{ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID == 0 ->
			NState = State,
			mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_team, [[RoleSid, ?ERRCODE(err650_kf_3v3_not_joined)]]);
		{ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) ->
			PKPid ! {leave_team, RoleID}, %% 离开战场，并退出队伍
			NState = State;
		{ok, #kf_3v3_role_data{team_id = TeamID} = UniteRoleData} ->
			case lists:keyfind(TeamID, #kf_3v3_team_data.team_id, Candinates) of
				#kf_3v3_team_data{member_data = MemberData} -> %% 离队自动
                    Data = [?SUCCESS, Platform, ServerNum, RoleID],
                    lib_3v3_center:send_stop_matching_notice(MemberData, Data), %% 取消匹配  不通知队友取消匹配了
					NCandinates = lists:keydelete(TeamID, #kf_3v3_team_data.team_id, Candinates),
					NState = State#state{candinates = NCandinates};
				_ ->
					NState = State
			end,
			KeyValueList = lib_3v3_center:leave_team(UniteRoleData),
			update_to_ets(KeyValueList),
			case ets:lookup(?ETS_TEAM_DATA, TeamID) of
				[Team] ->
					#kf_3v3_team_data{member_data = M} = Team,
					ets:insert(?ETS_TEAM_DATA, Team#kf_3v3_team_data{is_match = 0, match_count_in_team = 0});
				_ -> M = []
			end,
			lib_3v3_center:refresh_team_member([UniteRoleData | M], KeyValueList), %% 只刷新队友节点
			mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_leave_team, [[RoleSid, ?SUCCESS]])
	end,
	{noreply, NState};

%% 退出队伍 - 战场返回
do_handle_cast({ret_leave_team, RoleID}, #state{state_3v3 = State3v3} = State) ->
	if
		State3v3 /= ?KF_3V3_STATE_START -> skip;
		true ->
			case ets:lookup(?ETS_ROLE_DATA, RoleID) of
				[#kf_3v3_role_data{team_id = TeamID} = R] ->
					KeyValueList = lib_3v3_center:leave_team(R),
					update_to_ets(KeyValueList),
					case ets:lookup(?ETS_TEAM_DATA, TeamID) of
						[#kf_3v3_team_data{member_data = MemberData}] -> ok;
						_ -> MemberData = []
					end,
					lib_3v3_center:refresh_team_member([R | MemberData], KeyValueList); %% 只刷新队友节点
				_ -> skip
			end
	end,
	{noreply, State};

%% 踢出队伍
do_handle_cast({kick_out_team, [ServerId, RoleID, RoleSid, TRID]}, #state{state_3v3 = State3v3} = State) ->
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:get_unite_role_data(RoleID)
	end,
	case Res of
		{false, ResID} -> ok;
		{ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID == 0 ->
			ResID = ?ERRCODE(err650_kf_3v3_not_joined);
		{ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) ->
			ResID = ?ERRCODE(err650_kf_3v3_fighting);
		{ok, #kf_3v3_role_data{team_id = TeamID} = UniteRoleData} ->
			T = ets:lookup(?ETS_TEAM_DATA, TeamID),
			case lib_3v3_center:kick_out_team([TRID, UniteRoleData]) of
				{_, ResID, KeyValueList} ->
					update_to_ets(KeyValueList),
					case T of
						[#kf_3v3_team_data{member_data = MemberData}] ->
							lib_3v3_center:refresh_team_member(MemberData, KeyValueList); %% 只刷新队友节点
						_ -> skip
					end;
				{false, ResID} -> ok
			end
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_kick_out, [[RoleSid, ResID]]),
	{noreply, State};

%% 邀请玩家
do_handle_cast({invite_role, [ServerId, RoleID, RoleSid, TRID]}, State) ->
	#state{state_3v3 = State3v3} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			case lib_3v3_center:get_unite_role_data(RoleID) of
				{ok, #kf_3v3_role_data{team_id = TeamID}} when TeamID == 0 ->
					Res = {false, ?ERRCODE(err650_kf_3v3_not_joined)};
				{ok, #kf_3v3_role_data{} = UniteRoleData} ->
					case lib_3v3_center:get_unite_role_data(TRID) of
						{ok, #kf_3v3_role_data{team_id = TTeamID}} when TTeamID > 0 ->
							Res = {false, ?ERRCODE(err650_kf_3v3_in_team)};
						_ ->
							Res = {ok, UniteRoleData}
					end;
				Res -> ok
			end
	end,
	case Res of
		{false, ResID} -> ok;
		{ok, #kf_3v3_role_data{team_id = _TeamID} = UniteRoleData1} ->
			case lib_3v3_center:get_captain_team_data([_TeamID, RoleID]) of
				{ok, #kf_3v3_team_data{} = TeamData} -> %% 发送受邀信息
					Data = lib_3v3_center:to_invite_info(UniteRoleData1, TeamData),
					mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_invite_info, [[TRID, Data]]),
					ResID = ?ERRCODE(err650_kf_3v3_watting);
				_ ->
					ResID = ?ERRCODE(err650_kf_3v3_not_captain)
			end
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_invite_role, [[RoleSid, ResID, TRID]]),
	{noreply, State};

%% 开始匹配
do_handle_cast({start_matching_team, [ServerId, RoleID, RoleSid]}, State) ->
	#state{
		state_3v3 = State3v3, candinates = Candinates, pk_timer = PKTimer, ed_time = EdTime,
		member_limit = MemberLimit
	} = State,
	NowSec = utime:get_seconds_from_midnight(),
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		EdTime =< NowSec + ?KF_3V3_PK_TIME2 -> %% 活动时间剩余不足3min
			Res = {false, ?ERRCODE(err650_kf_3v3_come_to_end)};
		true ->
			Res = lib_3v3_center:start_matching_team([RoleID, Candinates, MemberLimit])
	end,
	case Res of
		{false, ResID} ->
%%			?MYLOG("3v3", "ResID ~p~n", [ResID]),
			NState = State,
			lib_3v3_center:send_start_matching_notice(ServerId, [RoleSid, [ResID]]);
		{ok, NCandinates} ->
%%			?MYLOG("3v3", "NCandinates ~p~n", [NCandinates]),
			case PKTimer of
				[] -> NPKTimer = erlang:send_after(?kf_3v3_match_time, ?MODULE, {matching_team});
				_ -> NPKTimer = PKTimer
			end,
			NState = State#state{candinates = NCandinates, pk_timer = NPKTimer}
	end,
	{noreply, NState};

%% 取消匹配
do_handle_cast({stop_matching_team, [TeamId, _ServerId, _RoleId]}, State) ->
	#state{state_3v3 = _State3v3, candinates = Candinates} = State,
	NewCandinates = lists:keydelete(TeamId, #kf_3v3_team_data.team_id, Candinates),
%%	?MYLOG("3v32", "NewCandinates ~p~n", [NewCandinates]),
	case ets:lookup(?ETS_TEAM_DATA, TeamId) of
		[Team] ->
			ets:delete(?ETS_TEAM_DATA, TeamId),
			#kf_3v3_team_data{member_data = MemberData} = Team,
			[ets:delete(?ETS_ROLE_DATA, TeamRoleId)|| #kf_3v3_role_data{role_id = TeamRoleId} <- MemberData];
%%			ets:insert(?ETS_TEAM_DATA, Team#kf_3v3_team_data{is_match = 0, match_count_in_team = 0});
		_ ->
			skip
	end,
	{noreply, State#state{candinates = NewCandinates}};

%% 开始匹配 - 组队
do_handle_cast({start_matching_role, [#role_data{
	server_id = ServerId, sid = RoleSid} = RoleData]},
	#state{state_3v3 = State3v3, match_role = MatchRole, team_timer = TeamTimer} = State) ->
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:start_matching_role([RoleData, MatchRole])
	end,
	case Res of
		{false, ResID} ->
            ?MYLOG("3v3", "ResID ~p~n", [ResID]),
			NState = State;
		{ok, NMatchRole} ->
            ?MYLOG("3v3", "NMatchRole ~p~n", [NMatchRole]),
			ResID = ?SUCCESS,
			if
				TeamTimer == [] ->
					NTeamTimer = erlang:send_after(5000, self(), {matching_role});
				true ->
					NTeamTimer = TeamTimer
			end,
			NState = State#state{team_timer = NTeamTimer, match_role = NMatchRole}
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_quick_join, [[RoleSid, ResID, 1]]),
	{noreply, NState};

%% 取消匹配 - 组队
do_handle_cast({stop_matching_role, [ServerId, RoleSid, RoleID]},
	#state{match_role = MatchRole} = State) ->
	NMatchRole = lists:keydelete(RoleID, #role_data.role_id, MatchRole),
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_quick_join, [[RoleSid, ?SUCCESS, ?KF_3V3_STOP_ROLE]]),
	{noreply, State#state{match_role = NMatchRole}};

%% 准备 | 取消准备
do_handle_cast({reset_ready, [ServerId, RoleID, RoleSid, IsReady]}, State) ->
	#state{state_3v3 = State3v3, candinates = Candinates} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:reset_ready([RoleID, Candinates, IsReady])
	end,
	case Res of
		{false, ResID} ->
			NState = State,
			mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_reset_ready, [[RoleSid, ResID, IsReady]]);
		{ok, KeyValueList, NCandinates} ->
			update_to_ets(KeyValueList),
			NState = State#state{candinates = NCandinates}
	end,
	{noreply, NState};

%% 自动开始 | 取消自动开始
do_handle_cast({reset_auto, [ServerId, RoleID, RoleSid, IsAuto]}, State) ->
	#state{state_3v3 = State3v3} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:reset_auto([RoleID, IsAuto])
	end,
	case Res of
		{false, ResID} -> ok;
		{ok, KeyValueList} ->
			update_to_ets(KeyValueList),
			ResID = ?SUCCESS
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, send_reset_auto, [[RoleSid, ResID, IsAuto]]),
	{noreply, State};

%% 获取战场信息
do_handle_cast({get_battle_info, [ServerId, RoleID, _RoleSid]}, State) ->
	#state{state_3v3 = State3v3} = State,
	if
		State3v3 /= ?KF_3V3_STATE_START -> %% 活动未开启
			Res = {false, ?ERRCODE(err650_kf_3v3_not_start)};
		true ->
			Res = lib_3v3_center:get_unite_role_data(RoleID)
	end,
%%	?MYLOG("pk", "Res ~p~n", [Res]),
	case Res of
		{false, ResID} ->
%%			?MYLOG("pk", "ResID ~p~n", [ResID]),
			mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_battle_info, [[RoleID, [ResID, 0, 0, 0, [], 0, 0]]]);
		{ok, #kf_3v3_role_data{team_id = TeamID, pk_pid = PKPid}}
			when TeamID > 0 andalso is_pid(PKPid) ->
			catch PKPid ! {get_battle_info, [ServerId, RoleID, TeamID]};
		_ -> %% 战斗已结束
			mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_battle_info,
				[[RoleID, [?ERRCODE(err650_kf_3v3_war_end), 0, 0, 0, [], 0, 0]]])
	end,
	{noreply, State};

do_handle_cast(_Request, State) ->
	{noreply, State}.

do_handle_info({start_3v3}, #state{ed_time = EdTime} = State) ->
	%%传闻
	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 2, []]),
	NowSec = utime:get_seconds_from_midnight(),
	erlang:send_after((EdTime - NowSec) * 1000, self(), {end_3v3}),
	mod_clusters_center:apply_to_all_node(mod_3v3_local, start_3v3, [erlang:max(EdTime - NowSec, 1)]),
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, start_3v3, [erlang:max(EdTime - NowSec, 1)]),
	mod_3v3_team:start_3v3(erlang:max(EdTime - NowSec, 1)),
	{noreply, State#state{state_3v3 = ?KF_3V3_STATE_START}};

do_handle_info({end_3v3}, #state{pk_timer = _PKTimer, act_timer = _ActTimer, team_timer = _TeamTimer} = _State) ->
	util:cancel_timer(_ActTimer),
	util:cancel_timer(_PKTimer),
	util:cancel_timer(_TeamTimer),
	ets:delete_all_objects(?ETS_ROLE_DATA),
	ets:delete_all_objects(?ETS_TEAM_DATA),
	State = ready_timer_3v3(),
	mod_3v3_rank:replace_3v3_rank(), %% 活动一结束，排行榜数据写入数据库一次
	% mod_clusters_center:apply_to_all_node(mod_3v3_local, start_3v3, [0]),
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, start_3v3, [0]),
	mod_3v3_team:start_3v3(0),
	{noreply, State};

do_handle_info({start_3v3, LastTime}, #state{pk_timer = _PKTimer, act_timer = _ActTimer} = State) ->
	%%传闻
	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 2, []]),
	util:cancel_timer(_ActTimer),
	util:cancel_timer(_PKTimer),
	ets:delete_all_objects(?ETS_ROLE_DATA),
	ets:delete_all_objects(?ETS_TEAM_DATA),
	NowSec = utime:get_seconds_from_midnight(),
	ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
	mod_clusters_center:apply_to_all_node(mod_3v3_local, start_3v3, [LastTime]),
	mod_3v3_team:start_3v3(LastTime),
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, start_3v3, [LastTime]),
	{noreply, State#state{ed_time = NowSec + LastTime, state_3v3 = ?KF_3V3_STATE_START,
		act_timer = ActTimer, pk_timer = [], team_timer = []}};

do_handle_info({gm_start_3v3, LastTime}, #state{pk_timer = _PKTimer, act_timer = _ActTimer} = State) ->
	%%传闻
%%	?MYLOG("cym", "gm_start_3v3 ~p~n", [LastTime]),
	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 2, []]),
	util:cancel_timer(_ActTimer),
	util:cancel_timer(_PKTimer),
	ets:delete_all_objects(?ETS_ROLE_DATA),
	ets:delete_all_objects(?ETS_TEAM_DATA),
	NowSec = utime:get_seconds_from_midnight(),
	ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
	mod_clusters_center:apply_to_all_node(mod_3v3_local, gm_start_3v3, [LastTime]),
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, start_3v3, [LastTime]),
	mod_3v3_team:start_3v3(LastTime),
	{noreply, State#state{ed_time = NowSec + LastTime, state_3v3 = ?KF_3V3_STATE_START,
		act_timer = ActTimer, pk_timer = [], team_timer = []}};

do_handle_info({gm_start_3v3, LastTime, MemberLimit}, #state{pk_timer = _PKTimer, act_timer = _ActTimer} = State) ->
	%%传闻
	mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_KF_3V3, 2, []]),
	util:cancel_timer(_ActTimer),
	util:cancel_timer(_PKTimer),
	ets:delete_all_objects(?ETS_ROLE_DATA),
	ets:delete_all_objects(?ETS_TEAM_DATA),
	NowSec = utime:get_seconds_from_midnight(),
	ActTimer = erlang:send_after(LastTime * 1000, self(), {end_3v3}),
	mod_clusters_center:apply_to_all_node(mod_3v3_local, gm_start_3v3, [LastTime, MemberLimit]),
%%	mod_clusters_center:apply_to_all_node(mod_3v3_team, start_3v3, [LastTime]),
	mod_3v3_team:start_3v3(LastTime),
	{noreply, State#state{ed_time = NowSec + LastTime, state_3v3 = ?KF_3V3_STATE_START,
		act_timer = ActTimer, pk_timer = [], team_timer = [], member_limit = MemberLimit}};

do_handle_info({gm_set_member_limit, MemberLimit}, State) ->
	mod_clusters_center:apply_to_all_node(mod_3v3_local, gm_set_member_limit, [MemberLimit]),
	{noreply, State#state{member_limit = MemberLimit}};

%% 匹配战斗
do_handle_info({matching_team}, #state{candinates = Candinates, ed_time = EdTime} = State) ->
%%	?MYLOG("3v3", "matching_team ~n", []),
	NowSec = utime:get_seconds_from_midnight(),
	if
		EdTime =< NowSec + ?KF_3V3_PK_TIME2 -> %% 活动时间剩余不足3min
			%% 将匹配中队伍都取消掉
			lib_3v3_center:all_stop_matching_team(Candinates),
			NState = State#state{candinates = [], pk_timer = []},
			{noreply, NState};
		true ->
			NPKTimer = erlang:send_after(?kf_3v3_match_time, self(), {matching_team}),
			{NCandinates, SucceedList, FailList} = lib_3v3_center:matching_team(Candinates),
			?MYLOG("3v3", "Candinates  ~p~n", [Candinates]),
			?MYLOG("3v3", "SucceedList  ~p~n", [SucceedList]),
			lib_3v3_center:create_pk_room([?PK_3V3_SCENE_ID, ?PK_3V3_SCENE_POOL_ID_LIST, SucceedList]),
			update_succeed_list(SucceedList),
			NState = State#state{
				candinates = NCandinates ++ FailList, pk_timer = NPKTimer
			},
			{noreply, NState}
	end;
%%%%	NPKTimer = erlang:send_after(?kf_3v3_match_time, self(), {matching_team}),
%%%%	{NCandinates, SucceedList, FailList} = lib_3v3_center:matching_team(Candinates),
%%	?MYLOG("3v3", "SucceedList ~p~n", [SucceedList]),
%%	?MYLOG("3v3", "Candinates ~p~n", [Candinates]),
%%	lib_3v3_center:create_pk_room([?PK_3V3_SCENE_ID, ?PK_3V3_SCENE_POOL_ID_LIST, SucceedList]),
%%	update_succeed_list(SucceedList),
%%	NState = State#state{
%%		candinates = NCandinates ++ FailList, pk_timer = NPKTimer
%%	},
%%	{noreply, NState};

%% 匹配组队
do_handle_info({matching_role}, #state{match_role = MatchRole, auto_id = AutoID, member_limit = MemberLimit, ed_time = EdTime} = State) ->
	NowSec = utime:get_seconds_from_midnight(),
	?MYLOG("3v3", "EdTime  ~p ~n", [EdTime]),
	TeamTimer = erlang:send_after(?kf_3v3_match_time, self(), {matching_role}),
    if
        EdTime =< NowSec + ?KF_3V3_PK_TIME2 -> %% 活动时间剩余不足3min
            %% 将匹配人都取消掉
%%            send_stop_matching_notice(ServerId, [RoleSid, Data])
	        ?MYLOG("3v3", "matching_role  ~n", []),
            [lib_3v3_center:send_stop_matching_notice(ServerId, [RoleSid, [?SUCCESS, ServerName, ServerNum, RoleId]])  ||
                #role_data{server_name = ServerName, server_num = ServerNum, role_id = RoleId, sid = RoleSid, server_id = ServerId} <-MatchRole],
            {noreply, State#state{match_role = []}};
        true ->
            {NMatchRole, NAutoID} = lib_3v3_center:matching_role(MatchRole, AutoID, MemberLimit),
%%	        TeamList = ets:tab2list(?ETS_TEAM_DATA),
%%	        ?MYLOG("3v3", "TeamList ~p~n", [TeamList]),
%%	        ?MYLOG("3v3", "NMatchRole ~p~n", [NMatchRole]),
	        TempTeamList = ets:tab2list(?ETS_TEAM_DATA),
	        %%没有在队伍匹配中的，队伍人数小于 3的 匹配次数 + 1
	        F = fun(#kf_3v3_team_data{is_match = IsMatch, match_count_in_team = Count1, member_num = Num,
		        server_id = ServerId, captain_id = CaptainId, captain_sid = CaptainSid, team_type = TeamType} = FunTeam) ->
		        if
			        IsMatch == 1 -> %% 正在匹配中
				        ok;
			        Count1 =< ?single_max_match_count andalso Num < 3 andalso TeamType ==  1 -> %% 散人队伍，且人数小于3， 且次数没有最大值 + 1
				        NewFunTeam = FunTeam#kf_3v3_team_data{match_count_in_team =  Count1 + 1},
				        ets:insert(?ETS_TEAM_DATA, NewFunTeam);
			        Count1 > ?single_max_match_count andalso Num < 3 andalso TeamType ==  1 -> %%散人队伍匹配次数太多，直接去队伍匹配
				        mod_3v3_center:start_matching_team([ServerId, CaptainId, CaptainSid]);
			        true ->
				        ok
		        end
	            end,
	        lists:foreach(F, TempTeamList),
            NState = State#state{match_role = NMatchRole, team_timer = TeamTimer, auto_id = NAutoID},
            {noreply, NState}
    end;
%%	{NMatchRole, NAutoID} = lib_3v3_center:matching_role(MatchRole, AutoID, MemberLimit),
%%	NState = State#state{match_role = NMatchRole, team_timer = TeamTimer, auto_id = NAutoID},
%%	{noreply, NState};


%% 更新数据
do_handle_info({update_team_pk, [TeamIdList, IsPk]}, State) ->
	F = fun(TeamId) ->
		case lib_3v3_center:get_unite_team_data(TeamId) of
			{ok, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
				NewTeamData = TeamData#kf_3v3_team_data{is_pk = IsPk},
				KeyValueList = [{update, ?ETS_TEAM_DATA, NewTeamData}],
				update_to_ets(KeyValueList),
				lib_3v3_center:refresh_team_member(MemberData, KeyValueList);
			_ ->
				skip
		end
	    end,
	lists:foreach(F, TeamIdList),
	{noreply, State};

%% 退出房间
do_handle_info({stop_pk_room, [SceneID, RoomID]}, State) ->
	case ets:match_object(?ETS_PK_DATA, #kf_3v3_pk_data{
		scene_id = SceneID, room_id = RoomID, _ = '_'
	})
	of
		[#kf_3v3_pk_data{} = PKData] ->
			ets:delete_object(?ETS_PK_DATA, PKData);
		_ -> ok
	end,
	{noreply, State};

%% 离开战斗房间
do_handle_info({leave_pk_room, [Platform, ServerNum, RoleID, Type, ServerId, Is3v3Scene]}, State) ->
	case lib_3v3_center:get_unite_role_data(RoleID) of
		{ok, #kf_3v3_role_data{team_id = TeamID, pk_pid = PKPid}}
			when TeamID > 0 andalso is_pid(PKPid) ->
			case lib_3v3_center:get_unite_team_data(TeamID) of
				{ok, #kf_3v3_team_data{member_data = MemberData}} ->
					lib_3v3_center:send_leave_pk_room_notice(MemberData,
						[TeamID, Platform, ServerNum, RoleID]),
					PKPid ! {leave_pk_room, RoleID, Type}; %% 下线提醒
				_ when Is3v3Scene == true ->
					SceneId = ?MAIN_CITY_SCENE,
					{X, Y} = lib_scene:get_main_city_x_y(),
					mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
						[RoleID, SceneId, 0, 0, X, Y, false, [{change_scene_hp_lim, 0}]]);
				_ ->
					skip
			end;
		_ when Is3v3Scene == true ->
			SceneId = ?MAIN_CITY_SCENE,
			{X, Y} = lib_scene:get_main_city_x_y(),
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[RoleID, SceneId, 0, 0, X, Y, false, [{change_scene_hp_lim, 0}]]);
		_ ->
			skip
	end,
	{noreply, State};

%% 重登战斗战场
do_handle_info({enter_pk_room, [Platform, ServerNum, ServerId, RoleID, RoleSid, Is3v3Scene]}, State) ->
	?MYLOG("3v3", "enter_pk_room ~n", []),
	case lib_3v3_center:get_unite_role_data(RoleID) of
		{ok, #kf_3v3_role_data{team_id = TeamID, pk_pid = PKPid} = UniteRoleData}
			when TeamID > 0 andalso is_pid(PKPid) ->
			case lib_3v3_center:get_unite_team_data(TeamID) of
				{ok, #kf_3v3_team_data{member_data = MemberData} = TeamData} ->
					?MYLOG("3v3", "enter_pk_room ~n", []),
					NUniteRoleData = UniteRoleData#kf_3v3_role_data{sid = RoleSid},
					NMemberData = lists:keyreplace(
						RoleID, #kf_3v3_role_data.role_id, MemberData, NUniteRoleData),
					NTeamData = TeamData#kf_3v3_team_data{member_data = NMemberData},
					KeyValueList = [
						{update, ?ETS_ROLE_DATA, NUniteRoleData},
						{update, ?ETS_TEAM_DATA, NTeamData}
					],
					update_to_ets(KeyValueList),
					lib_3v3_center:send_enter_pk_room_notice(MemberData,
						[TeamID, Platform, ServerNum, RoleID]),
					PKPid ! {enter_pk_room, [RoleID, RoleSid]}; %% 重登提醒
				_ when Is3v3Scene == true ->
					?MYLOG("3v3", "enter_pk_room ~n", []),
					SceneId = ?MAIN_CITY_SCENE,
					{X, Y} = lib_scene:get_main_city_x_y(),
					mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
						[RoleID, SceneId, 0, 0, X, Y, false, [{change_scene_hp_lim, 0}]]);
				_ ->
					?MYLOG("3v3", "enter_pk_room ~n", []),
					skip
			end;
		_ when Is3v3Scene == true ->
			?MYLOG("3v3", "enter_pk_room ~n", []),
			SceneId = ?MAIN_CITY_SCENE,
			{X, Y} = lib_scene:get_main_city_x_y(),
			mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
				[RoleID, SceneId, 0, 0, X, Y, false, [{change_scene_hp_lim, 0}]]);
		_ ->
			?MYLOG("3v3", "enter_pk_room ~n", []),
			skip
	end,
	{noreply, State};

%% 击杀玩家
do_handle_info({kill_enemy, [_SceneID, _RoomID, DefRoleID, AttRoleID, AssistRoleList]}, State) ->
	case lib_3v3_center:get_unite_role_data(AttRoleID) of
		{ok, #kf_3v3_role_data{pk_pid = PKPid}} when is_pid(PKPid) ->
			PKPid ! {kill_enemy, DefRoleID, AttRoleID, AssistRoleList};
		_ -> skip
	end,
	{noreply, State};


%% 发送队伍消息
do_handle_info({msg_to_team, [Type, RoleID, Bin]}, #state{state_3v3 = State3v3} = State) ->
	if
		State3v3 == ?KF_3V3_STATE_START andalso Type == 1 -> %% 队伍聊天
			case ets:lookup(?ETS_ROLE_DATA, RoleID) of
				[#kf_3v3_role_data{team_id = TeamID}] ->
					case ets:lookup(?ETS_TEAM_DATA, TeamID) of
						[#kf_3v3_team_data{member_data = MemberData}] ->
							lib_3v3_center:msg_to_team(MemberData, Bin);
						_ -> skip
					end;
				_ -> skip
			end;
		State3v3 == ?KF_3V3_STATE_START andalso Type == 2 -> %% 场景房间聊天
			case ets:lookup(?ETS_ROLE_DATA, RoleID) of
				[#kf_3v3_role_data{pk_pid = PKPid}] when is_pid(PKPid) ->
					case ets:lookup(?ETS_PK_DATA, PKPid) of
						[#kf_3v3_pk_data{team_data_a = TeamA, team_data_b = TeamB}] ->
							#kf_3v3_team_data{member_data = MemberDataA} = TeamA,
							#kf_3v3_team_data{member_data = MemberDataB} = TeamB,
							lib_3v3_center:msg_to_team(MemberDataA ++ MemberDataB, Bin);
						_ -> skip
					end;
				_ -> skip
			end;
		true -> skip
	end,
	{noreply, State};

do_handle_info({get_left_time, [ServerId]}, #state{state_3v3 = State3v3, ed_time = EdTime} = State) ->
	if
		State3v3 /= ?KF_3V3_STATE_START ->
			LeftTime = 0;
		true ->
			NowSec = utime:get_seconds_from_midnight(),
			LeftTime = erlang:max(EdTime - NowSec, 1)
	end,
	mod_clusters_center:apply_cast(ServerId, mod_3v3_local, start_3v3, [LeftTime]),
	{noreply, State};

%% 更新队伍信息
do_handle_info({update_unite_data, [{TeamIDA, AList}, {TeamIDB, BList}, LeaveList]},
	#state{state_3v3 = State3v3} = State) when State3v3 == ?KF_3V3_STATE_START ->
	lib_3v3_center:update_unite_team_data([{TeamIDA, AList}, {TeamIDB, BList}]),
	F = fun(Data) -> leave_team(Data) end,
	lists:foreach(F, LeaveList),
	{noreply, State};

do_handle_info({test, [ServerId, RoleID, Group]}, State) ->
	KeyValueList = [{group, Group}],
	[{x, X}, {y, Y}] = lib_3v3_center:revive(Group),
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleID, 4500, 0, X, Y, false, KeyValueList]),
	mod_3v3_pk:create_mons([4500, 0]), %% 生成房间怪物
	{noreply, State};

do_handle_info({test}, State) ->
	io:format("~p, ~p, state: ~p~n", [?MODULE, ?LINE, State]),
	{noreply, State};

do_handle_info(_Request, State) ->
	{noreply, State}.

%% 更新ets
%% @desc : 注意，这个方法只有mod_3v3_center这个进程才能使用
update_to_ets(KeyValueList) ->
	F = fun({Type, Tab, Obejct}) ->
		case Type of
			update -> ets:insert(Tab, Obejct);
			delete -> ets:delete(Tab, Obejct);
			_ -> skip
		end
	    end,
	lists:foreach(F, KeyValueList).

%% 准备3v3定时器
ready_timer_3v3() ->
	NowSec = utime:get_seconds_from_midnight(),
	case lib_3v3_center:load_act_time() of
		{StTime, EdTime} when NowSec >= StTime -> %% 活动已开启
			NowSec = utime:get_seconds_from_midnight(),
			LastTime = erlang:max(EdTime - NowSec, 1),
			mod_clusters_center:apply_to_all_node(mod_3v3_local, start_3v3, [LastTime]),
			ActTimer = erlang:send_after((EdTime - NowSec) * 1000, self(), {end_3v3}),
			State = #state{ed_time = EdTime, state_3v3 = ?KF_3V3_STATE_START, act_timer = ActTimer};
		{StTime, EdTime} -> %% 活动还未开启
			ActTimer = erlang:send_after((StTime - NowSec) * 1000, self(), {start_3v3}),
			State = #state{ed_time = EdTime, state_3v3 = ?KF_3V3_STATE_YET, act_timer = ActTimer};
		_ -> %% 零点再读取一次
			ActTimer = erlang:send_after((86400 - NowSec) * 1000, self(), {end_3v3}),
			State = #state{act_timer = ActTimer}
	end,
	State.

%% 发送开始匹配结果  RoleList:: [#role_data{}]
send_pull_team_to_match_res(RoleList, ResId) ->
	[mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_pull_team_to_match_res, [RoleId, ResId])
		|| #kf_3v3_role_data{server_id = ServerId, role_id = RoleId} <- RoleList].


update_succeed_list([]) ->
	ok;
update_succeed_list([{TeamA, TeamB} | T]) ->
	#kf_3v3_team_data{member_data = MemberDataA, server_id = ServerIdA, team_id = TeamIdA} = TeamA,
	#kf_3v3_team_data{member_data = MemberDataB, server_id = ServerIdB, team_id = TeamIdB} = TeamB,
	lib_3v3_center:refresh_team_match_status(ServerIdA, TeamIdA,
		[MemberId || #kf_3v3_role_data{role_id = MemberId} <- MemberDataA], ?team_pk),
	lib_3v3_center:refresh_team_match_status(ServerIdB, TeamIdB,
		[MemberId || #kf_3v3_role_data{role_id = MemberId} <- MemberDataB], ?team_pk),
%%	%%单人的
%%	[mod_clusters_center:apply_cast(ServerId, mod_daily, increment_offline, [MemberId, ?MOD_KF_3V3, 9])
%%		|| #kf_3v3_role_data{role_id = MemberId, is_single = IsSingle, server_id = ServerId}
%%		<- MemberDataA ++ MemberDataB, IsSingle == ?is_single],
	update_succeed_list(T).





































