%% ---------------------------------------------------------------------------
%% @doc lib_guild_dun_mod.erl

%% @author  lxl
%% @email  
%% @since  2018-10-17
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_guild_dun_mod).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("guild_dun.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("predefine.hrl").

init() ->
	UnixData = utime:unixdate(),
	lib_guild_dun:db_delete_guild_dun_role_expire(UnixData),
	lib_guild_dun:db_delete_guild_dun_guild_expire(UnixData),
	case lib_guild_dun:db_select_guild_dun_guild() of 
		[] -> GuildMap = #{};
		GuildList -> GuildMap = init_guild_dun_guild(GuildList, #{})
	end,
	case lib_guild_dun:db_select_guild_dun_role() of 
		[] -> RoleMap = #{};
		RoleList -> RoleMap = init_guild_dun_role(RoleList, #{})
	end,
	LevelMap = init_guild_dun_level(),
	_State = #guild_dun_state{
		init_state = 0
		, level_map = LevelMap
		, guild_map = GuildMap
		, role_map = RoleMap
	},
	%?PRINT("init _State ~p~n", [_State]),
	_State.

zero_clear(_State) ->
	lib_guild_dun:db_delete_guild_dun_role(),
	lib_guild_dun:db_delete_guild_dun_guild(),
	LevelMap = init_guild_dun_level(),
	State = #guild_dun_state{
		init_state = 0
		, level_map = LevelMap
		, guild_map = #{}
		, role_map = #{}
	},
	{noreply, State}.

init_guild_dun_guild([], GuildMap) -> GuildMap;
init_guild_dun_guild([[GuildId, Score, CreateTime]|GuildList], GuildMap) ->
	GuildInfo = #guild_info{guild_id = GuildId, dun_score = Score, create_time = CreateTime},
	init_guild_dun_guild(GuildList, maps:put(GuildId, GuildInfo, GuildMap)).

init_guild_dun_role([], RoleMap) -> RoleMap;
init_guild_dun_role([[RoleId, GuildId, Level, ChallengeTimes, NotifyTimes, ScoreB, CreateTime, RoleName]|List], RoleMap) ->
	Score = util:bitstring_to_term(ScoreB),
	RoleInfo = #role_info{role_id = RoleId, guild_id = GuildId, role_name = RoleName, level = Level, challenge_times = ChallengeTimes, notify_times = NotifyTimes, dun_score = Score, create_time = CreateTime},
	NewRoleMap = maps:put(RoleId, RoleInfo, RoleMap),
	init_guild_dun_role(List, NewRoleMap).

init_guild_dun_level() ->
	LevelList = ?DUN_LEVEL_LIST,
	F = fun(Level, {LevelMap, RankList}) ->
		ChallengeType = rand_challenge_type(),
		ChallengeInfo = get_challenge_info(Level),
		#{rank := Rank} = ChallengeInfo,
		LevelInfo = #level_info{level = Level, challenge_type = ChallengeType, challenge_info = ChallengeInfo},
		{maps:put(Level, LevelInfo, LevelMap), [Rank|RankList]}
	end,
	{_LevelMap, _RankList} = lists:foldl(F, {#{}, []}, LevelList),
	URankList = util:ulist(_RankList),
	%mod_jjc:cast_get_rank_info({mod_guild_dun_mgr, finish_init_guild_dun, []}, URankList),
	_LevelMap.

rand_challenge_type() ->
	TypeList = data_guild_dun:get_all_challenge_type(),
	RandTypeList = ulists:list_shuffle(TypeList),
	F = fun(Door, {List, List2}) ->
		case List of 
			[Type|L] -> {L, [{Door, Type}|List2]};
			[] -> {[], [{Door, 1}|List2]}
		end
	end,
	{_, _ChallengeType} = lists:foldl(F, {RandTypeList, []}, ?DOOR_LIST),
	_ChallengeType.

get_challenge_info(Level) ->
	[{_, [{Rank1, Rank2}]}] = data_guild_dun:get_challenge_target(Level),
	Rank = urand:rand(Rank1, Rank2),
	#{target_id => 0, rank => Rank, figure => #figure{}, battle_attr => #battle_attr{}, skill => []}.

finish_init_guild_dun(State, [RankRoleInfoList]) ->
	#guild_dun_state{level_map = LevelMap} = State,
	F = fun(_Level, LevelInfo) ->
		#level_info{challenge_info = ChallengeInfo} = LevelInfo,
		#{rank := Rank} = ChallengeInfo,
		case lists:keyfind(Rank, 1, RankRoleInfoList) of 
			{Rank, RoleId, Figure, BA, CombatPower} ->
				Skill = data_skill:get_ids(Figure#figure.career, Figure#figure.sex),
				NCombatPower = ?IF(RoleId == 0, lib_player:calc_all_power(BA#battle_attr.attr), CombatPower),
				NewChallengeInfo = ChallengeInfo#{target_id => RoleId, figure => Figure, battle_attr => BA, skill => Skill, combat_power => NCombatPower},
				LevelInfo#level_info{challenge_info = NewChallengeInfo};
			_ ->
				LevelInfo
		end
	end,
	NewLevelMap = maps:map(F, LevelMap),
	%?PRINT("finish_init_guild_dun NewLevelMap : ~n ~p~n", [NewLevelMap]),
	{noreply, State#guild_dun_state{init_state = 1, level_map = NewLevelMap}}.

get_role_challenge_info(State, [RoleId, Sid, GuildId, RoleName, GiftStatusList]) ->
	{NewState, RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, RoleName),
	#guild_info{dun_score = DunScore} = GuildInfo,
	#role_info{level = Level, challenge_times = ChallengeTimes, dun_score = RoleScoreList} = RoleInfo,
	RoleScore = get_role_score_by_guild(RoleScoreList, GuildId),
	F = fun({GiftId, Status}, List) ->
		case Status == 1 of 
			true -> [{GiftId, 1}|List];
			_ ->
				case data_guild_dun:get_dun_score_gift(GiftId) of 
					#base_guild_dun_score_reward{score = ScoreNeed} when RoleScore >= ScoreNeed -> [{GiftId, 2}|List];
					_ -> [{GiftId, Status}|List]
				end
		end
	end,
	NewGiftStatusList = lists:foldl(F, [], GiftStatusList),
	?PRINT("get_role_challenge_info  : ~p~n", [{Level, DunScore, ChallengeTimes, RoleScore, NewGiftStatusList}]),
	{ok, Bin} = pt_400:write(40050, [1, Level, DunScore, ChallengeTimes, RoleScore, NewGiftStatusList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{noreply, NewState}.	


send_member_challenge_list(State, [_RoleId, Sid, GuildId, _RoleName]) ->
	%{NewState, _RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, RoleName),
	%#guild_info{role_map = RoleMap} = GuildInfo,
	#guild_dun_state{role_map = RoleMap} = State,
	F = fun(MemRoleId, #role_info{guild_id = _MemGuildId, role_name = Name, level = Level, dun_score = RoleScoreList}, List) ->
		RoleScore = get_role_score_by_guild(RoleScoreList, GuildId),
		?IF(RoleScore>0, [{MemRoleId, Name, Level, RoleScore}|List], List)
	end,
	InfoList = maps:fold(F, [], RoleMap),
	?PRINT("send_member_challenge_list  : ~p~n", [InfoList]),
	{ok, Bin} = pt_400:write(40056, [InfoList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{noreply, State}.
	
notify_guild_member(State, [RoleId, Sid, GuildId, Figure]) ->
	#figure{name = RoleName} = Figure,
	{NewState, RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, RoleName),
	#guild_dun_state{guild_map = GuildMap, role_map = RoleMap} = NewState,
	#guild_info{record_list = RecordList} = GuildInfo,
	#role_info{choose_door = ChooseDoor, notify_times = NotifyTimes} = RoleInfo,
	case NotifyTimes > 0 of 
		true ->
			case ChooseDoor of 
				{Level, Door, Type} ->
					RecordInfo = make_notify_record([RoleId, RoleName, Level, Door, Type]),
					NewRoleInfo = RoleInfo#role_info{notify_times = NotifyTimes - 1},
					NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
					NewGuildInfo = GuildInfo#guild_info{record_list = [RecordInfo|RecordList]},
					NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap),
					lib_guild_dun:db_replace_guild_dun_role(NewRoleInfo),
					lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_GUILD, 13, [Level, Door, util:make_sure_binary(data_guild_dun:get_name(Type))]),
					?PRINT("notify_guild_member  : ~p~n", [RecordInfo]),
					LastState = NewState#guild_dun_state{guild_map = NewGuildMap, role_map = NewRoleMap};
				_ -> ?PRINT("notify_guild_member NotifyTimes : ~p~n", [NotifyTimes]), LastState = NewState
			end,
			{ok, Bin} = pt_400:write(40057, [?SUCCESS]),
			lib_server_send:send_to_sid(Sid, Bin),
			{noreply, LastState};
		_ ->
			{ok, Bin} = pt_400:write(40057, [?ERRCODE(err400_no_notify_times)]),
			lib_server_send:send_to_sid(Sid, Bin),
			{noreply, NewState}
	end.

get_notify_record_list(State, [RoleId, Sid, GuildId, RoleName]) ->
	{NewState, RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, RoleName),
	#guild_info{record_list = RecordList} = GuildInfo,
	#role_info{level = Level} = RoleInfo,
	F = fun(RecordInfo, List) ->
		#record_info{id = Id, role_id = MemRoleId, role_name = Name, level = NotifyLevel, door = Door, type = Type, time = Time} = RecordInfo,
		case Level == NotifyLevel of 
			true -> [{Id, MemRoleId, Name, Level, Door, Type, Time}|List];
			_ -> List
		end
	end,
	InfoList = lists:foldl(F, [], RecordList),
	?PRINT("get_notify_record_list  : ~p~n", [InfoList]),
	{ok, Bin} = pt_400:write(40058, [InfoList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{noreply, NewState}.

get_guild_and_role_score(State, [RoleId, GuildId, RoleName]) ->
	{NewState, RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, RoleName),
	#guild_info{dun_score = DunScore} = GuildInfo,
	#role_info{dun_score = RoleScoreList} = RoleInfo,
	RoleScore = get_role_score_by_guild(RoleScoreList, GuildId),
	Reply = {ok, DunScore, RoleScore},
	{reply, Reply, NewState}.

get_role_state(State, [RoleId]) ->
	#guild_dun_state{role_map = RoleMap} = State,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{role_state = ?ROLE_STATE_FIGHT} ->		
			{reply, {ok, ?ROLE_STATE_FIGHT}, State};
		_ -> {reply, {ok, ?ROLE_STATE_FREE}, State}
	end.

quit_guild(State, [RoleId]) ->
	#guild_dun_state{role_map = RoleMap} = State,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{} = RoleInfo ->
			NewRoleInfo = RoleInfo#role_info{guild_id = 0},
			lib_guild_dun:db_replace_guild_dun_role(NewRoleInfo),
			NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
			{noreply, State#guild_dun_state{role_map = NewRoleMap}};
		_ -> {noreply, State}
	end.

join_guild(State, [RoleId, GuildId]) ->
	#guild_dun_state{role_map = RoleMap} = State,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{} = RoleInfo ->
			NewRoleInfo = RoleInfo#role_info{guild_id = GuildId},
			lib_guild_dun:db_replace_guild_dun_role(NewRoleInfo),
			NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
			{noreply, State#guild_dun_state{role_map = NewRoleMap}};
		_ -> {noreply, State}
	end.

reconnect(State, [RoleId]) ->
	#guild_dun_state{role_map = RoleMap} = State,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{fight_pid = FightPid, role_state = ?ROLE_STATE_FIGHT} ->
			case misc:is_process_alive(FightPid) of 
				true -> mod_guild_dun_fight:apply_cast(FightPid, {reconnect, [RoleId]});
				_ -> lib_scene:player_change_default_scene(RoleId, [])
			end,
			{noreply, State};
		_ -> 
			lib_scene:player_change_default_scene(RoleId, []),
			{noreply, State}
	end.

enter_challenge(State, [RoleId, GuildId, Sid, Figure, Door]) ->
	{State1, RoleInfo, _GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, Figure#figure.name),
	#guild_dun_state{
		init_state = InitState
		, level_map = LevelMap
		, guild_map = _GuildMap
		, role_map = RoleMap
	} = State1,
	#role_info{level = Level, challenge_times = ChallengeTimes} = RoleInfo,
	LevelInfo = maps:get(Level, LevelMap, 0),
	MaxLevel = ?MAX_LEVEL,
	if
		Level > MaxLevel -> Errcode = ?ERRCODE(err400_guild_dun_max_level), NewState = State1;
		InitState == 0 -> Errcode = ?ERRCODE(system_busy), NewState = State1;
		Door > ?MAX_DOOR -> Errcode = ?FAIL, NewState = State1;
	 	ChallengeTimes == 0 -> Errcode = ?ERRCODE(err400_no_challenge_times), NewState = State1;
		is_record(LevelInfo, level_info) == false -> Errcode = ?FAIL, NewState = State1;
		true ->
			Errcode = ?SUCCESS,
			#level_info{challenge_type = ChallengeType} = LevelInfo,
			Type = case lists:keyfind(Door, 1, ChallengeType) of 
				{_, _Type} -> _Type;
				_ -> 1
			end,
			case Type of 
				1 -> 
					?PRINT("enter_challenge Type  : ~p~n", [Type]),
					NewRoleInfo = RoleInfo#role_info{choose_door = {Level, Door, Type}},
					NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
					State2 = State1#guild_dun_state{role_map = NewRoleMap},
					NewState = handle_challenge_result(State2, RoleId, GuildId, Figure, 1, Type, Door);
				_ -> 
					?PRINT("enter_challenge Type  : ~p~n", [Type]),
					{ok, FightPid} = mod_guild_dun_fight:start([RoleId, GuildId, Figure, Type, Door, LevelInfo]),
					mod_guild_dun_fight:apply_cast(FightPid, {player_enter, [RoleId]}),
					NewRoleInfo = RoleInfo#role_info{role_state = ?ROLE_STATE_FIGHT, fight_pid = FightPid, choose_door = {Level, Door, Type}},
					NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
					NewState = State1#guild_dun_state{role_map = NewRoleMap}
			end
	end,
	{ok, Bin} = pt_400:write(40053, [Errcode, Door]),
    lib_server_send:send_to_sid(Sid, Bin),
	{noreply, NewState}.

end_battle(State, [RoleId, GuildId, Figure, IsWin, Type, Door]) ->
	NewState = handle_challenge_result(State, RoleId, GuildId, Figure, IsWin, Type, Door),
	{noreply, NewState}.

handle_challenge_result(State, RoleId, GuildId, Figure, IsWin, Type, Door) ->
	{State1, RoleInfo, GuildInfo} = get_guild_and_role_info(State, RoleId, GuildId, Figure#figure.name),
	#guild_dun_state{guild_map = GuildMap, role_map = RoleMap} = State1,
	#guild_info{dun_score = DunScore} = GuildInfo,
	#role_info{level = Level, dun_score = RoleScoreList, challenge_times = ChallengeTimes, notify_times = NotifyTimes} = RoleInfo,
	{ScoreAdd, Reward} = lib_guild_dun:get_win_reward(Level, Type, Figure#figure.lv),
	?PRINT("handle_challenge_result  : ~p ~n", [{ScoreAdd, Reward}]),
	case IsWin of 
		1 -> %% 胜利
			NewLevel = min(Level + 1, ?MAX_LEVEL+1), NewChallengeTimes = ChallengeTimes, NewRoleScoreList = update_role_score_by_guild(RoleScoreList, GuildId, ScoreAdd),
			NewDunScore = DunScore + ScoreAdd,
			lib_guild_dun:handle_result_win(RoleId, Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, Reward);
			%lib_goods_api:send_reward_with_mail(RoleId, #produce{type = guild_dun_challenge, reward = Reward, title = utext:get(203), content = utext:get(204)});
		_ ->
			{ok, Bin} = pt_400:write(40055, [Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, []]),
			lib_server_send:send_to_uid(RoleId, Bin),
			NewLevel = Level, NewChallengeTimes = max(ChallengeTimes - 1, 0), NewRoleScoreList = RoleScoreList,
			NewDunScore = DunScore
	end,
	NewRoleInfo = RoleInfo#role_info{level = NewLevel, dun_score = NewRoleScoreList, challenge_times = NewChallengeTimes, fight_pid = none, role_state = ?ROLE_STATE_FREE},
	MaxNum = ?MAX_LEVEL,
	if
		NewLevel >= MaxNum orelse NewChallengeTimes == 0 ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_to_be_strong, update_data, 
				[RoleId, [2007], 1]);
		true ->
			skip
	end,
	NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
	NewGuildInfo = GuildInfo#guild_info{dun_score = NewDunScore},
	NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap),
	lib_log_api:log_guild_dun_result(RoleId, GuildId, Level, Door, Type, IsWin, ?IF(IsWin == 1, Reward, []), ?IF(IsWin == 1, ScoreAdd, 0), NewChallengeTimes),
	lib_guild_dun:db_replace_guild_dun_role(NewRoleInfo),
	lib_guild_dun:db_replace_guild_dun_guild(NewGuildInfo),
	NewState = State1#guild_dun_state{guild_map = NewGuildMap, role_map = NewRoleMap},
	lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_GUILD, 0),
	%?PRINT("handle_challenge_result end NewRoleInfo  : ~p~n", [NewRoleInfo]),
	NewState.

get_guild_and_role_info(State, RoleId, GuildId, RoleName) ->
	#guild_dun_state{
		guild_map = GuildMap
		, role_map = RoleMap
	} = State,
	case maps:get(GuildId, GuildMap, 0) of 
		#guild_info{} = GuildInfo -> IsUpGuild = false;
		_ ->
			GuildInfo = add_new_guild(GuildId), IsUpGuild = true
	end,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{} = RoleInfo -> IsUpRole = false;
		_ -> RoleInfo = add_new_role(RoleId, GuildId, RoleName), IsUpRole = true
	end,
	if 
		IsUpGuild == true andalso IsUpRole == true -> 
			NewRoleMap = maps:put(RoleId, RoleInfo, RoleMap),
			NewGuildMap = maps:put(GuildId, GuildInfo, GuildMap),
			NewState = State#guild_dun_state{guild_map = NewGuildMap, role_map = NewRoleMap},
			{NewState, RoleInfo, GuildInfo};
		IsUpGuild == true ->
			NewGuildMap = maps:put(GuildId, GuildInfo, GuildMap),
			NewState = State#guild_dun_state{guild_map = NewGuildMap},
			{NewState, RoleInfo, GuildInfo};
		IsUpRole == true ->
			NewRoleMap = maps:put(RoleId, RoleInfo, RoleMap),
			NewState = State#guild_dun_state{role_map = NewRoleMap},
			{NewState, RoleInfo, GuildInfo};
		true -> {State, RoleInfo, GuildInfo}			
	end.

add_new_role(RoleId, GuildId, RoleName) ->
	RoleInfo = #role_info{
		role_id = RoleId,
		guild_id = GuildId,
		role_name = RoleName,
		level = 1,
		challenge_times = ?INIT_CHALLENGE_TIMES,
		notify_times = 2,
		create_time = utime:unixtime()
	},
	%lib_guild_dun:db_replace_guild_dun_role(RoleInfo),
	RoleInfo.

add_new_guild(GuildId) ->
	GuildInfo = #guild_info{
		guild_id = GuildId
		, create_time = utime:unixtime()
	},
	lib_guild_dun:db_replace_guild_dun_guild(GuildInfo),
	GuildInfo.

make_notify_record([RoleId, RoleName, Level, Door, Type]) ->
	Id = get_auto_id(),
	RecordInfo = #record_info{
		id = Id
		, role_id = RoleId
		, role_name = RoleName 		
		, level = Level    
		, door = Door  
		, type = Type
		, time = utime:unixtime()
	},
	RecordInfo.

get_auto_id() ->
	case get({?MODULE, auto_id}) of 
		Id when is_integer(Id) -> ok;
		_ -> Id = 1
	end,
	put({?MODULE, auto_id}, Id+1),
	Id+1.

get_role_score_by_guild(RoleScoreList, GuildId) ->
	case lists:keyfind(GuildId, 1, RoleScoreList) of 
		{_, RoleScore} -> RoleScore;
		_ -> 0
	end.
		
update_role_score_by_guild(RoleScoreList, GuildId, ScoreAdd) ->
	case lists:keyfind(GuildId, 1, RoleScoreList) of 
		{_, RoleScore} -> RoleScore;
		_ -> RoleScore = 0
	end,
	lists:keystore(GuildId, 1, RoleScoreList, {GuildId, RoleScore+ScoreAdd}).



gm_set_role_data(State, [RoleId, ChallengeTimes, Level, NotifyTimes]) ->
	#guild_dun_state{role_map = RoleMap} = State,
	case maps:get(RoleId, RoleMap, 0) of 
		#role_info{role_state = ?ROLE_STATE_FREE, level = OLevel, challenge_times = OChallengeTimes, notify_times = ONotifyTimes} = RoleInfo ->
			NewChallengeTimes = ?IF(ChallengeTimes == 0, OChallengeTimes, ChallengeTimes),
			NewLevel = ?IF(Level == 0, OLevel, Level),
			NewNotityTimes = ?IF(NotifyTimes == 0, ONotifyTimes, NotifyTimes),
			NewRoleInfo = RoleInfo#role_info{challenge_times = NewChallengeTimes, level = NewLevel, notify_times = NewNotityTimes},
			NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
			lib_guild_dun:db_replace_guild_dun_role(NewRoleInfo),
			{noreply, State#guild_dun_state{role_map = NewRoleMap}};
		_ -> {noreply, State}
	end.