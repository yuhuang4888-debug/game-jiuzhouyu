-module (lib_act_join_mod).
-include ("common.hrl").
-include ("rec_act_join.hrl").

-export ([
	init/0,
	daily_clear/2,
	add_join/2,
	to_db/1,
	stop/1,
	get_join/2,
	clear_module/2,
	quit_guild/2,
	add_authentication_player/2,
	get_authentication_player/2,
	clear_with_authentication_id/2
]).

%% 初始化参与记录
init() ->
	delete_join_log_db(),
	delete_authentication_log_db(),
	List = load_join_log_db(),
	JoinMap = init_helper(List, #{}),
	List2 = load_authentication_log_db(),
	AuthenticationMap = init_authentication(List2, #{}),
	NewState = #act_join_state{join_map = JoinMap, authentication_map = AuthenticationMap},
	{ok, NewState}.

init_helper([], JoinMap) -> JoinMap;
init_helper([[PlayerId, GuildId, ModuleId, Time]|T], JoinMap) ->
	ModuleJoin 	= maps:get(ModuleId, JoinMap, #{}),
	JoinPlayer 	= make(join_player, {PlayerId, GuildId, ModuleId, Time}),
	NewModuleJoin = maps:put(PlayerId, JoinPlayer, ModuleJoin),
	NewJoinMap 	= maps:put(ModuleId, NewModuleJoin, JoinMap),
	init_helper(T, NewJoinMap).

init_authentication([], AuthenticationMap) -> AuthenticationMap;
init_authentication([[AuthenticationId, PlayerId, GuildId, ModuleId, Time]|List], AuthenticationMap) ->
	OldPlayerList = maps:get(AuthenticationId, AuthenticationMap, []),
	AuthenticationPlayer = make(authentication_player, {AuthenticationId, PlayerId, GuildId, ModuleId, Time}),
	NewAuthenticationMap = maps:put(AuthenticationId, [AuthenticationPlayer|OldPlayerList], AuthenticationMap),
	init_authentication(List, NewAuthenticationMap).

make(join_player, {PlayerId, GuildId, ModuleId, Time}) ->
	#join_player{
		player_id = PlayerId,
		guild_id  = GuildId,
		module_id = ModuleId,
		time      = Time
	};
make(authentication_player, {AuthenticationId, PlayerId, GuildId, ModuleId, Time}) ->
	#authentication_player{
		authentication_id = AuthenticationId,
		player_id = PlayerId,
		guild_id  = GuildId,
		module_id = ModuleId,
		time      = Time
	}.

%% 日清：活动参与记录
daily_clear({_DelaySec}, _State) ->
	{ok, NewState} = init(),
	{ok, NewState}.

%% 添加参与记录
add_join({PlayerId, GuildId, ModuleId}, State) ->
	#act_join_state{
		join_map = JoinMap} = State,
	ModuleJoin 	= maps:get(ModuleId, JoinMap, #{}),
	JoinPlayer 	= make(join_player, {PlayerId, GuildId, ModuleId, utime:unixtime()}),
	NewState = do_add_join(JoinPlayer, ModuleJoin, State),
	LastState = reset_ref(NewState),
	{ok, LastState}.

do_add_join(JoinPlayer, ModuleJoin, State) ->
	#join_player{
		player_id = PlayerId,
		module_id = ModuleId
	} = JoinPlayer,
	#act_join_state{
		join_map = JoinMap,
		add_num  = AddNum,
		add_list = AddList
	} = State,
	NewModuleJoin = maps:put(PlayerId, JoinPlayer, ModuleJoin),
	NewJoinMap 	= maps:put(ModuleId, NewModuleJoin, JoinMap),
	State#act_join_state{				
		join_map = NewJoinMap, 
		add_num  = AddNum+1,
		add_list = [JoinPlayer|AddList]}.

add_authentication_player([], State) -> 
	{ok, State};
add_authentication_player(AuthenticationList, State) ->
	#act_join_state{authentication_map = AuthenticationMap, add_list2 = AddList2} = State,
	NowTime = utime:unixtime(),
	[{AddAuthenticationId, _, _, _}|_] = AuthenticationList,
	OPlayerList = maps:get(AddAuthenticationId, AuthenticationMap, []),
	AddPlayerList = [
		make(authentication_player, {AuthenticationId, PlayerId, GuildId, ModuleId, NowTime})
		|| {AuthenticationId, PlayerId, GuildId, ModuleId} <- AuthenticationList, lists:keymember(PlayerId, #authentication_player.player_id, OPlayerList) == false
	],
	NewAuthenticationMap = maps:put(AddAuthenticationId, AddPlayerList ++ OPlayerList, AuthenticationMap),
	?PRINT("add_authentication_player:~p~n", [AddPlayerList]),
	NewAddList2 = AddPlayerList ++ AddList2,
	NewState = State#act_join_state{authentication_map = NewAuthenticationMap, add_list2 = NewAddList2},
	LastState = reset_ref(NewState),
	{ok, LastState}.


-define(WRITE_TIME, 5000).
-define(WRITE_NUM, 30).
reset_ref(State) ->
	case State#act_join_state.ref of
		[] ->
			Ref = util:send_after([], 10, self(), {to_db}),
			State#act_join_state{ref = Ref};
		OldRef when State#act_join_state.add_list==[] orelse State#act_join_state.add_list2 == [] ->
			util:cancel_timer(OldRef),
			State#act_join_state{ref = []};
		OldRef -> 
			Ref = util:send_after(OldRef, ?WRITE_TIME, self(), {to_db}),
			State#act_join_state{ref = Ref}
	end.

%% 入库操作
to_db(State) ->
	#act_join_state{
		add_num = AddNum,
		add_list = AddList,
		add_list2 = AddList2
	} = State,
	case AddNum>?WRITE_NUM of
		true ->
			NewAddNum = AddNum - ?WRITE_NUM,
			{Pre, Post} = lists:split(?WRITE_NUM, AddList);
		false ->
			NewAddNum = 0,
			Pre = AddList, Post = []
	end,
	case length(AddList2) > ?WRITE_NUM of 
		true ->
			{DbAddList2, LeftDbAddList2} = lists:split(?WRITE_NUM, AddList2);
		_ ->
			DbAddList2 = AddList2, LeftDbAddList2 = []
	end,
	spawn(fun() -> to_db_helper(Pre, DbAddList2) end),
	NewState= State#act_join_state{
		add_num = NewAddNum,
		add_list = Post,
		add_list2 = LeftDbAddList2
	},
	LastState = reset_ref(NewState),
	{ok, LastState}.

%% 关闭服务处理
stop(State) ->
	#act_join_state{
		add_list = AddList,
		add_list2 = AddList2
	} = State,
	to_db_helper(AddList, AddList2),
	NewState = State#act_join_state{
		add_num = 0,
		add_list= [],
		add_list2 = []
	},
	LastState = reset_ref(NewState),
	{ok, LastState}.

to_db_helper([], []) -> ok;
to_db_helper(Pre, DbAddList2) ->
	to_db_helper_1(Pre),
	timer:sleep(500),
	to_db_helper_2(DbAddList2),
	ok.

to_db_helper_1([]) -> ok;
to_db_helper_1(JoinPlayerList) ->
	DbList = [[PlayerId, GuildId, ModuleId, Time] ||#join_player{player_id = PlayerId, guild_id = GuildId, module_id = ModuleId, time = Time} <- JoinPlayerList],
	Sql = usql:replace(join_log, [player_id, guild_id, module_id, time], DbList),
	db:execute(Sql),
	ok.

to_db_helper_2(AuthenticationPlayerList) ->
	DbList = [[AuthenticationId, PlayerId, GuildId, ModuleId, Time] ||
		#authentication_player{authentication_id = AuthenticationId, player_id = PlayerId, guild_id = GuildId, module_id = ModuleId, time = Time} <- AuthenticationPlayerList],
	Sql = usql:replace(authentication_log, [authentication_id, player_id, guild_id, module_id, time], DbList),
	db:execute(Sql),
	ok.

% to_db_helper_1([], _I) -> skip;
% to_db_helper_1([JoinPlayer|T], I) ->
% 	case I rem 10 of
%         0 -> timer:sleep(200);
%         _ -> skip
%     end,
% 	#join_player{
% 		player_id = PlayerId,
% 		guild_id  = GuildId,
% 		module_id = ModuleId,
% 		time      = Time
% 	} = JoinPlayer,
% 	replace_join_log_db(PlayerId, GuildId, ModuleId, Time),
% 	to_db_helper_1(T, I+1).

%% 获取参与一个活动的玩家(最近3个小时数据，用于拍卖分红)
get_join({ModuleId}, State) ->
	NowTime = utime:unixtime(),
	DelayTime = 3*3600,
	#act_join_state{join_map = JoinMap} = State,
	ModuleJoin 	= maps:get(ModuleId, JoinMap, #{}),
	[{PlayerId, GuildId}||#join_player{player_id = PlayerId, guild_id = GuildId, time = Time} 
		<- maps:values(ModuleJoin), Time + DelayTime > NowTime].

get_authentication_player({AuthenticationId, ModuleId}, State) ->
	#act_join_state{authentication_map = AuthenticationMap} = State,
	AuthenticationPlayerList 	= maps:get(AuthenticationId, AuthenticationMap, []),
	[{PlayerId, GuildId}||#authentication_player{player_id = PlayerId, guild_id = GuildId, module_id = ModuleId1} 
		<- AuthenticationPlayerList, ModuleId1 == ModuleId].

%% 清除一个活动参与记录
clear_module({ModuleId}, State) ->
	#act_join_state{
		join_map = JoinMap
	} = State,
	case catch delete_join_log_module_db(ModuleId) of
		ok -> skip;
		Error -> ?ERR("clear_module:~p~n", [Error])
	end,
	NewJoinMap = maps:remove(ModuleId, JoinMap),
	{ok, State#act_join_state{join_map = NewJoinMap} }.


clear_with_authentication_id({AuthenticationId, _ModuleId}, State) ->
	#act_join_state{authentication_map = AuthenticationMap} = State,
	NewAuthenticationMap 	= maps:remove(AuthenticationId, AuthenticationMap),
	case catch delete_authentication_log_by_id(AuthenticationId) of
		ok -> skip;
		Error -> ?ERR("clear_with_authentication_id:~p~n", [Error])
	end,
	{ok, State#act_join_state{authentication_map = NewAuthenticationMap} }.


%% 退出公会，清除活动参与记录
quit_guild({PlayerId}, State) ->
	#act_join_state{
		join_map = JoinMap
	} = State,
	case catch delete_join_log_player_db(PlayerId) of
		ok -> skip;
		Error -> ?ERR("quit_guild:~p~n", [Error])
	end,
	NewJoinMap = maps:fold(
		fun(ModuleId, ModuleJoin, Map) -> 
			NewModuleJoin = maps:remove(PlayerId, ModuleJoin),
			maps:put(ModuleId, NewModuleJoin, Map)
		end, 
		JoinMap, JoinMap),
	{ok, State#act_join_state{join_map = NewJoinMap} }.

%% ------------------------------- db function %% ----------------------------

load_join_log_db() ->
	db:get_all(io_lib:format(?SQL_JOIN_LOG_SELECT, []) ).

% replace_join_log_db(PlayerId, GuildId, ModuleId, Time) ->
% 	db:execute(io_lib:format(?SQL_JOIN_LOG_REPLACE, [PlayerId, GuildId, ModuleId, Time]) ),
% 	ok.

delete_join_log_db() ->
	UnixDate = utime:unixdate(),
	db:execute(io_lib:format(?SQL_JOIN_LOG_DELETE_LOG, [UnixDate]) ),
	ok.

delete_join_log_module_db(ModuleId) ->
	db:execute(io_lib:format(?SQL_JOIN_LOG_DELETE_MODULE, [ModuleId]) ),	
	ok.	

delete_join_log_player_db(PlayerId) ->
	db:execute(io_lib:format(?SQL_JOIN_LOG_DELETE_PLAYER, [PlayerId]) ),	
	ok.

load_authentication_log_db() ->
	db:get_all(io_lib:format(?SQL_AUTHENTICATION_LOG_SELECT, []) ).

delete_authentication_log_by_id(AuthenticationId) ->
	db:execute(io_lib:format(?SQL_AUTHENTICATION_LOG_DELETE, [AuthenticationId]) ),	
	ok.	

delete_authentication_log_db() ->
	UnixDate = utime:unixdate(),
	db:execute(io_lib:format(?SQL_AUTHENTICATION_LOG_DELETE_LOG, [UnixDate]) ),
	ok.