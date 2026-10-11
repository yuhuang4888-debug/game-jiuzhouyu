%%%-----------------------------------
%%% @Module      : mod_sanctuary
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 01. 三月 2019 15:06
%%% @Description : 文件摘要
%%%-----------------------------------
-module(mod_sanctuary).
-author("chenyiming").


-include("common.hrl").
-include("errcode.hrl").
-include("sanctuary.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("attr.hrl").
%% API
-compile(export_all).


-define(SERVER, ?MODULE).


%% API
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% =============================领地夺宝相关接口=============================
get_score(RoleId, GuildId) ->
	gen_server:cast(?MODULE, {'get_score', RoleId, GuildId}).

enter_territory_treasure(RoleId, RoleName, GuildId, GuildName) ->
	gen_server:cast(?MODULE, {'enter_territory_treasure', RoleId, RoleName, GuildId, GuildName}).

gm_start_territory_treasure(RoleId, RoleName, GuildId, GuildName) ->
	gen_server:cast(?MODULE, {'gm_start_territory_treasure', RoleId, RoleName, GuildId, GuildName}).

get_act_time(RoleId, GuildId) ->
	gen_server:cast(?MODULE, {'get_act_time', RoleId, GuildId}).
%% =============================分    割     线=============================

act_start(SubType) ->
	gen_server:cast(?MODULE, {start, SubType}).

gm_start(Time) ->
	?MYLOG("cym", "gm_start ~p~n", [Time]),
	gen_server:cast(?MODULE, {gm_start, Time}).

gm_reset_boss(SanctuaryId) ->
	gen_server:cast(?MODULE, {'gm_reset_boss', SanctuaryId}).

quit(RoleId) ->
	gen_server:cast(?MODULE, {quit, RoleId}).

enter(SanctuaryId, RoleId, GuildId, LastDieTime, DieCount, OldScene, PKStatus) ->
	gen_server:cast(?MODULE, {enter, SanctuaryId, RoleId, GuildId, LastDieTime, DieCount, OldScene, PKStatus}).
%%添加关注
remind(RoleId, SanctuaryId, BossId, Remind) ->
	gen_server:cast(?MODULE, {'remind', RoleId, SanctuaryId, BossId, Remind}).

%%批量添加关注
remind(RoleId, SanctuaryId, MonList) ->
	gen_server:cast(?MODULE, {'remind', RoleId, SanctuaryId, MonList}).

%%获取领地信息
get_info(SanctuaryId, RoleId) ->
	gen_server:cast(?MODULE, {get_info, SanctuaryId, RoleId}).

boss_be_kill(SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName) ->
	gen_server:cast(?MODULE, {'boss_be_kill', SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName}).

player_be_kill(DieId, DieName, DieGuildId, AttackId, AtterName, AttackGuildId, SceneId, X, Y, HitRoleList) ->
	gen_server:cast(?MODULE, {'player_be_kill', DieId, DieName, DieGuildId, AttackId, AtterName, AttackGuildId, SceneId, X, Y, HitRoleList}).

%%带有前3名公会id进行结算
do_result_with_guild_with_msg(GuildList) ->
	gen_server:cast(?MODULE, {'do_result_with_guild_with_msg', GuildList}).

%%更新称号信息
update_designation(DesignationMap) ->
	gen_server:cast(?MODULE, {'update_designation', DesignationMap}).

get_guild_rank_info_with_guild_id(RoleId, GuildId) ->
	gen_server:cast(?MODULE, {'get_guild_rank_info_with_guild_id', RoleId, GuildId}).

get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId) ->
	gen_server:cast(?MODULE, {'get_guild_rank_info_with_sanctuary_id', RoleId, SanctuaryId}).

get_mon_kill_info(RoleId, SanctuaryId, BossId) ->
	gen_server:cast(?MODULE, {'get_mon_kill_info', RoleId, SanctuaryId, BossId}).

mon_be_hurt(MonInfo, RoleId) ->
	#scene_object{scene = SceneId} = MonInfo,
	case lib_sanctuary:is_sanctuary_scene(SceneId) of
		true ->
			gen_server:cast(?MODULE, {'mon_be_hurt', MonInfo, RoleId});
		_ ->
			ok
	end.


quit_guild(RoleId, LeaveGuildId) ->
	gen_server:cast(?MODULE, {'quit_guild', RoleId, LeaveGuildId}).

gm_settlement() ->
	gen_server:cast(?MODULE, {'gm_settlement'}).

update_not_change_designation(NotChangeDesignationMap) ->
	gen_server:cast(?MODULE, {'update_not_change_designation', NotChangeDesignationMap}).
%%获得上一次结算信息
get_last_settlement_msg(RoleId, GuildId, PersonRank, GuildIdRank) ->
	gen_server:cast(?MODULE, {'get_last_settlement_msg', RoleId, GuildId, PersonRank, GuildIdRank}).

update_last_guild_rank(NewRankList) ->
	gen_server:cast(?MODULE, {'update_last_guild_rank', NewRankList}).

join_guild(RoleId, GuildId) ->
	gen_server:cast(?MODULE, {'join_guild', RoleId, GuildId}).

%%公会排行榜
send_guild_rank_list_for_sanctuary(RoleId, GuildRank, MyGuildAvgPower, SendList) ->
	gen_server:cast(?MODULE, {'send_guild_rank_list_for_sanctuary', RoleId, GuildRank, MyGuildAvgPower, SendList}).

change_pk(RoleId, GuildId, PKType, Scene) ->
	gen_server:cast(?MODULE, {'change_pk', RoleId, GuildId, PKType, Scene}).

sanctuary_person_rank_settlement() ->
	gen_server:cast(?MODULE, {'sanctuary_person_rank_settlement'}).

%%合服
merge_sanctuary_do_result(GuildList) ->
	gen_server:cast(?MODULE, {'merge_sanctuary_do_result', GuildList}).


timer_repair() ->
	gen_server:cast(?MODULE, {'timer_repair'}).

%% private
init([]) ->
	State = lib_sanctuary_mod:init(),
	{ok, State}.

handle_call(Msg, From, State) ->
	case catch do_handle_call(Msg, From, State) of
		{'EXIT', Error} ->
			?ERR("handle_call error: ~p~n Msg=~p~n", [Error, Msg]),
			{reply, error, State};
		Return ->
			Return
	end.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{'EXIT', Error} ->
			?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
			{noreply, State};
		Return ->
			case Return of
				{noreply, #sanctuary_state{}} ->
					Return;
				_ ->
					?ERR("handle_cast Msg= ~p ~n ~p~n", [Msg, State]),
					{noreply, State}
			end
	end.

handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		{'EXIT', Error} ->
			?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
			{noreply, State};
		Return ->
			case Return of
				{noreply, #sanctuary_state{}} ->
					Return;
				_ ->
					?ERR("handle_cast Msg= ~p ~n ~p~n", [Info, State]),
					{noreply, State}
			end
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

do_handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

%% =============================领地夺宝相关接口=============================
do_handle_cast({'get_score', RoleId, GuildId}, State) ->
    BelongL = lib_sanctuary_mod:get_sanctuary_info(State),
	Score = lib_sanctuary_mod:get_sanctuary_point_by_guild_id(GuildId, State),
	IsHave = lib_sanctuary_mod:is_have_sanctuary_by_guild_id(GuildId, State),
	lib_territory_treasure:get_player_score(BelongL, Score, IsHave, RoleId),
	{noreply, State};

do_handle_cast({'enter_territory_treasure', RoleId, RoleName, GuildId, GuildName}, State) ->
	Score = lib_sanctuary_mod:get_sanctuary_point_by_guild_id(GuildId, State),
	lib_territory_treasure:enter_territory(RoleId, RoleName, GuildId, GuildName, Score),
	{noreply, State};

do_handle_cast({'gm_start_territory_treasure', RoleId, RoleName, GuildId, GuildName}, State) ->
	Score = lib_sanctuary_mod:get_sanctuary_point_by_guild_id(GuildId, State),
	lib_territory_treasure:gm_start(RoleId, RoleName, GuildId, GuildName, Score),
	{noreply, State};

do_handle_cast({'get_act_time', RoleId, GuildId}, State) ->
	Score = lib_sanctuary_mod:get_sanctuary_point_by_guild_id(GuildId, State),
	lib_territory_treasure:get_act_time(RoleId, GuildId, Score),
	{noreply, State};
%% =============================分    割     线=============================


do_handle_cast({enter, SanctuaryId, RoleId, GuildId, LastDieTime, DieCount, OldScene, PKStatus}, State) ->
	?MYLOG("cym", "enter ~p~n", [{LastDieTime, DieCount}]),
	case data_sanctuary:get_sanctuary_scene(SanctuaryId) of
		0 ->
			{noreply, State};
		Scene ->
			IsOpen = lib_sanctuary_mod:is_open(State),
			if
				IsOpen == true ->
					%%切换默认状态
%%					lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, change_pk_status, [?PK_FORCE]),
					{ok, Bin} = pt_283:write(28303, [SanctuaryId, ?SUCCESS]),
					lib_server_send:send_to_uid(RoleId, Bin),
					IsOutSide = lib_scene:is_outside_scene(OldScene),
					NewState = lib_sanctuary_mod:add_role_to_sanctuary(RoleId, SanctuaryId, State, LastDieTime, DieCount),
					handle_enter_with_pk(State, RoleId, Scene, IsOutSide, GuildId, SanctuaryId, PKStatus),
					{noreply, NewState};
				true ->
					#sanctuary_state{status = Status} = State,
					?MYLOG("cym", "Status ~p~n", [Status]),
					OpenDay = util:get_open_day(),
					{MinDay, _MaxDay} = data_sanctuary:get_kv(open_day),
					if
						OpenDay < MinDay ->
							pp_sanctuary:send_error(RoleId, ?ERRCODE(err283_act_not_open3));
						Status == ?sanctuary_yet_over ->
							pp_sanctuary:send_error(RoleId, ?ERRCODE(err283_act_not_open2));
                        OpenDay == 4 -> % 开服第四天
                            pp_sanctuary:send_error(RoleId, ?ERRCODE(err283_act_not_open4));
						true -> % 开服第二、三天
							pp_sanctuary:send_error(RoleId, ?ERRCODE(err283_act_not_open))
					end,
					{noreply, State}
			end
	end;

do_handle_cast({start, SubType}, State) ->
	#sanctuary_state{status = Status} = State,
%%	?MYLOG("cym", "act_start ~n", []),
	if
		Status == ?sanctuary_yet_over ->
			{noreply, State};
		true ->
			EndTime = lib_sanctuary_mod:get_end_time(SubType),    %%活动结束时间戳
			NewState = lib_sanctuary_mod:act_start(EndTime, State),
			{noreply, NewState}
	end;


do_handle_cast({gm_start, Time}, State) ->
	?MYLOG("cym", "gm_start ~p~n", [Time]),
	EndTime = utime:unixtime() + Time,
	NewState = lib_sanctuary_mod:act_start(EndTime, State),
	{noreply, NewState};

do_handle_cast({quit, RoleId}, State) ->
%%	?MYLOG("cym", "quit ~p~n", [RoleId]),
	NewState = lib_sanctuary_mod:quit(RoleId, State),
	{noreply, NewState};

do_handle_cast({get_info, SanctuaryId, RoleId}, State) ->
	lib_sanctuary_mod:get_info(RoleId, SanctuaryId, State),
	{noreply, State};

do_handle_cast({'remind', RoleId, SanctuaryId, BossId, Remind}, State) ->
	?MYLOG("cym", "remind ~p  BossId ~p ~n", [Remind, BossId]),
	NewState = lib_sanctuary_mod:remind(RoleId, SanctuaryId, BossId, Remind, State, ?send_protocol),
	{noreply, NewState};

do_handle_cast({'remind', RoleId, SanctuaryId, MonList}, State) ->
%%	?MYLOG("cym", "remind ~p  BossId ~p ~n", [Remind, BossId]),
	NewState = lib_sanctuary_mod:remind(RoleId, SanctuaryId, MonList, State),
	{noreply, NewState};

do_handle_cast({'boss_be_kill', SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName}, State) ->
	?MYLOG("cym", "boss_be_kill ~n", []),
	NewState = lib_sanctuary_mod:boss_be_kill(SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName, State),
	{noreply, NewState};

do_handle_cast({'player_be_kill', DieId, DieName, DieGuildId, AttackId, AtterName, AttackGuildId, SceneId, X, Y, HitRoleList}, State) ->
	?MYLOG("cym", "player_be_kill ~n", []),
	NewState = lib_sanctuary_mod:player_be_kill(DieId, DieName, DieGuildId, AttackId, AtterName, AttackGuildId, SceneId, X, Y, HitRoleList, State),
	{noreply, NewState};

do_handle_cast({'do_result_with_guild_with_msg', GuildList}, State) ->
	NewState = lib_sanctuary_mod:do_result_with_guild_with_msg(GuildList, State),
	{noreply, NewState};

do_handle_cast({'merge_sanctuary_do_result', GuildList}, State) ->
	NewState = lib_sanctuary_mod:merge_sanctuary_do_result(GuildList, State),
	{noreply, NewState};

do_handle_cast({'update_designation', DesignationMap}, State) ->
	NewState = lib_sanctuary_mod:update_designation(DesignationMap, State),
	{noreply, NewState};

do_handle_cast({'get_guild_rank_info_with_guild_id', RoleId, GuildId}, State) ->
	lib_sanctuary_mod:get_guild_rank_info_with_guild_id(RoleId, GuildId, State),
	{noreply, State};
do_handle_cast({'get_guild_rank_info_with_sanctuary_id', RoleId, SanctuaryId}, State) ->
	lib_sanctuary_mod:get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId, State),
	{noreply, State};

do_handle_cast({'get_mon_kill_info', RoleId, SanctuaryId, BossId}, State) ->
	lib_sanctuary_mod:get_mon_kill_info(RoleId, SanctuaryId, BossId, State),
	{noreply, State};
do_handle_cast({'mon_be_hurt', MonInfo, RoleId}, State) ->
	NewState = lib_sanctuary_mod:mon_be_hurt(MonInfo, RoleId, State),
	{noreply, NewState};

do_handle_cast({'gm_settlement'}, State) ->
	lib_sanctuary_mod:do_result_force(),
	{noreply, State};

do_handle_cast({'quit_guild', RoleId, LeaveGuildId}, State) ->
	NewState = lib_sanctuary_mod:quit_guild(RoleId, LeaveGuildId, State),
	{noreply, NewState};
do_handle_cast({'update_not_change_designation', NotChangeDesignationMap}, State) ->
	NewState = lib_sanctuary_mod:update_not_change_designation(NotChangeDesignationMap, State),
	{noreply, NewState};

do_handle_cast({'get_last_settlement_msg', RoleId, GuildId, PersonRank, GuildIdRank}, State) ->
	lib_sanctuary_mod:get_last_settlement_msg(RoleId, GuildId, PersonRank, GuildIdRank, State),
	{noreply, State};
do_handle_cast({'update_last_guild_rank', NewRankList}, State) ->
	lib_sanctuary:db_save_last_guild_rank(NewRankList),
	{noreply, State#sanctuary_state{last_time_guild_rank_list = NewRankList}};

do_handle_cast({'join_guild', RoleId, GuildId}, State) ->
	lib_sanctuary_mod:join_guild(RoleId, GuildId, State),
	{noreply, State};

do_handle_cast({'send_guild_rank_list_for_sanctuary', RoleId, GuildRank, MyGuildAvgPower, SendList}, State) ->
	%%SendList == [{TmpGuildId, GuildName, ChairmanName, Rank, MembersNum, LimitNum, Value}]
	#sanctuary_state{sanctuary_map = Map} = State,
	GuildIdList = [GuildId || #sanctuary_msg{belong = GuildId} <- maps:values(Map), GuildId =/= 0],
	AddLimitMemberNum = data_sanctuary:get_kv(add_guild_member_limit),
	F = fun(GuildId, AccList) ->
		case lists:keyfind(GuildId, 1, AccList) of
			{TmpGuildId, GuildName, ChairmanName, Rank, MembersNum, LimitNum, Value} ->
				lists:keystore(GuildId, 1, AccList, {TmpGuildId, GuildName, ChairmanName,
					Rank, MembersNum, LimitNum + AddLimitMemberNum, Value});
			_ ->
				AccList
		end
	end,
	SendList1 = lists:foldl(F, SendList, GuildIdList),
	SendList2 = [{GuildName1, ChairmanName1, Rank1, MembersNum1, LimitNum1, Value1} ||
		{_TmpGuildId1, GuildName1, ChairmanName1, Rank1, MembersNum1, LimitNum1, Value1} <- SendList1],
	{ok, BinData} = pt_283:write(28302, [GuildRank, MyGuildAvgPower, SendList2]),
	lib_server_send:send_to_uid(RoleId, BinData),
	{noreply, State};

do_handle_cast({'change_pk', RoleId, GuildId, PKType, Scene}, State) ->
	#sanctuary_state{sanctuary_map = Map} = State,
	SanctuaryId =
		case data_sanctuary:get_sanctuary_id_by_scene(Scene) of
			[] ->
				0;
			V ->
				V
		end,
	#sanctuary_msg{belong = Belong} = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	if
		GuildId == Belong andalso PKType == ?PK_ALL ->
			{ok, BinData} = pt_130:write(13012, [?ERRCODE(err130_user_cant_change_this_pk), PKType, 0]),
			lib_server_send:send_to_uid(RoleId, BinData);
		true -> %%可以切换
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, change_mod, [PKType])
	end,
	{noreply, State};

do_handle_cast({'sanctuary_person_rank_settlement'}, State) ->
	lib_sanctuary_mod:do_result_guild_person_rank(State),
	{noreply, State};

do_handle_cast({'timer_repair'}, State) ->
	NewState = lib_sanctuary_mod:timer_repair(State),
	{noreply, NewState};
do_handle_cast({'gm_reset_boss', SanctuaryId}, State) ->
	NewState = lib_sanctuary_mod:gm_reset_boss(SanctuaryId, State),
	{noreply, NewState};


do_handle_cast(_Msg, State) ->
	{noreply, State}.


do_handle_info({act_end}, State) ->
	NewState = lib_sanctuary_mod:end_act(State),
	{noreply, NewState};

do_handle_info({'priview_act_end'}, State) ->
	?MYLOG("cym", "priview_act_end +++++++~n", []),
	#sanctuary_state{act_end_time = Time} = State,
	{ok, Bin} = pt_283:write(28306, [Time]),
	lib_server_send:send_to_local_all(Bin),
	{noreply, State};

do_handle_info({'do_result'}, State) ->
	NewSate = lib_sanctuary_mod:do_result(State),
	{noreply, NewSate};

%%强制结算，不检查任何东西
do_handle_info({'do_result_force'}, State) ->
	lib_sanctuary_mod:do_result_force(),
	{noreply, State};

do_handle_info({'reborn_boss', SanctuaryId, MonCfgId}, State) ->
	NewState = lib_sanctuary_mod:reborn_boss(SanctuaryId, MonCfgId, State),
	{noreply, NewState};
do_handle_info({'person_rank_refresh'}, State) ->
	NewState = lib_sanctuary_mod:person_rank_refresh(State),
	{noreply, NewState};

do_handle_info({'merge_handle'}, State) ->
	NewState = lib_sanctuary_mod:merge_handle(State),
	{noreply, NewState};


do_handle_info(_Msg, State) ->
	{noreply, State}.

handle_enter_with_pk(State, RoleId, Scene, IsOutSide, GuildId, SanctuaryId, PKStatus) ->
	#sanctuary_state{sanctuary_map = Map} = State,
	#sanctuary_msg{belong = Belong} = maps:get(SanctuaryId, Map, #sanctuary_msg{}),
	if
		GuildId == 0 orelse Belong =/= GuildId ->
			lib_scene:player_change_scene(RoleId, Scene, ?sanctuary_scene_pool, ?sanctuary_copy_id,
				IsOutSide, [{change_scene_hp_lim, 100}, {pk, PKStatus}]);
		true ->
			lib_scene:player_change_scene(RoleId, Scene, ?sanctuary_scene_pool, ?sanctuary_copy_id,
				IsOutSide, [{change_scene_hp_lim, 100}])
	end.