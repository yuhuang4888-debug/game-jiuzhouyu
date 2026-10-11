-module(mod_online_statistics).

-behaviour(gen_server).

-include("online_statistics.hrl").
-include("common.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).
%%本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	erlang:send_after(1000, self(), 'init_data'),
	{ok, #online_state{user_map = #{}, lv_num = #{}, clear_ref = undefined}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Boss Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 跨服pk记录
do_handle_cast({'player_die', KServerId,AtterId,SceneId,SceneName,NowTime,DServerId,DServerNum,DieName,DieId}, State) ->
	mod_clusters_center:apply_cast(KServerId,lib_pk_log,kf_pk_log_map,[AtterId,SceneId,SceneName,NowTime,DServerId,DServerNum,DieName,DieId]),
	{noreply, State};

do_handle_cast({'user_lv_up', RoleId, RoleLv, ServerId}, State) ->
	#online_state{lv_num = LvMap, user_map = UserMap} = State,
	case maps:get({ServerId, RoleId}, UserMap, []) of
		#online_user{role_lv = OldRoleLv} = User ->
			OldKey = get_lv_interval(OldRoleLv),
			NewKey = get_lv_interval(RoleLv),
			if
				OldKey =/= NewKey ->
					NewLvMap = lv_up(OldKey, NewKey, LvMap),
					% mod_clusters_center:apply_to_all_node(mod_special_boss, online_num_map_update, [NewLvMap], 100),
					mod_clusters_center:apply_to_all_node(mod_boss, online_num_map_update, [NewLvMap], 100);
				true ->
					NewLvMap = LvMap
			end,
			NewUser = User#online_user{role_lv = RoleLv};
		_ ->
			NewLvMap = LvMap,
			NewUser = #online_user{role_id = RoleId, role_lv = RoleLv, online_sign = ?ONLINE}
	end,
	NewMap = maps:put({ServerId, RoleId}, NewUser, UserMap),
	% ?PRINT("LvMap:~p,NewLvMap:~p~n",[LvMap,NewLvMap]),
	{noreply, State#online_state{lv_num = NewLvMap, user_map = NewMap}};

do_handle_cast({'user_login', RoleId, RoleLv, ServerId, IsFirstLogin}, State) ->
	% ?PRINT("RoleId,RoleLv~p~n",[{RoleId, RoleLv}]),
	#online_state{lv_num = LvMap, user_map = UserMap} = State,
	case maps:get({ServerId, RoleId}, UserMap, []) of
		#online_user{role_lv = OldRoleLv} = User ->
			if
				RoleLv == OldRoleLv andalso IsFirstLogin == false ->
					NewLvMap = LvMap,
					NewUser = User#online_user{online_sign = ?ONLINE};
				true ->
					OldKey = get_lv_interval(OldRoleLv),
					NewKey = get_lv_interval(RoleLv),
					NewUser = User#online_user{role_lv =  RoleLv, online_sign = ?ONLINE},
					NewLvMap = lv_up(OldKey, NewKey, LvMap)
			end;
		_ ->
			if
				IsFirstLogin == true ->
					NewLvMap = add_num(RoleLv, LvMap);%% 更新内存及数据库;
				true ->
					NewLvMap = LvMap
			end,
			NewUser = #online_user{role_id = RoleId, role_lv = RoleLv, online_sign = ?ONLINE}
	end,
	NewMap = maps:put({ServerId, RoleId}, NewUser, UserMap),
	% mod_clusters_center:apply_to_all_node(mod_special_boss, online_num_map_update, [NewLvMap], 100),
	mod_clusters_center:apply_to_all_node(mod_boss, online_num_map_update, [NewLvMap], 100),
	% ?MYLOG("xlh", "login LvMap:~p,NewLvMap:~p~n",[LvMap,NewLvMap]),
	{noreply, State#online_state{lv_num = NewLvMap, user_map = NewMap}};

do_handle_cast({'user_logout', RoleId, RoleLv, ServerId}, State) ->
	#online_state{user_map = UserMap} = State,
	case maps:get({ServerId, RoleId}, UserMap, []) of
		#online_user{} = User ->
			NewUser = User#online_user{role_lv = RoleLv, online_sign = ?OFFLINE};
		_ ->
			NewUser = #online_user{role_id = RoleId, role_lv = RoleLv, online_sign = ?OFFLINE}
	end,
	NewMap = maps:put({ServerId, RoleId}, NewUser, UserMap),
	{noreply, State#online_state{user_map = NewMap}};

do_handle_cast(_Msg, State) ->
	{noreply, State}.

do_handle_call(_, State) ->
	{reply, ok, State}.

do_handle_info('init_data', State) ->
	LvMap = State#online_state.lv_num,
	NowDate = utime:unixdate(),
	NowTime = utime:unixtime(),
	ClearTime = NowDate + ?ONE_DAY_SECONDS - NowTime,
	ClearRef = erlang:send_after(ClearTime * 1000, self(), clear_data),
	List = db_select(),
	Fun = fun([MinLv, MaxLv, Num],TemMap) ->
		maps:put({MinLv, MaxLv}, Num, TemMap)
	end,
	NewLvMap = lists:foldl(Fun, LvMap, List),
	{noreply, State#online_state{lv_num = NewLvMap, clear_ref = ClearRef, clear_time = ClearTime}};

do_handle_info(clear_data, State) ->
	#online_state{user_map = UserMap, clear_ref = ClearRef, clear_time = ClearTime} = State,
	util:cancel_timer(ClearRef),
	%% 每天0点清理数据
	db_truncate(),
	NextClearTime = ClearTime + ?ONE_DAY_SECONDS,
	NewClearRef = erlang:send_after(NextClearTime * 1000, self(), clear_data),
	UserList = maps:to_list(UserMap),
	Fun = fun({Key, #online_user{role_lv = RoleLv, online_sign = Sign}}, {TemUserMap, TemLvMap}) ->
		if
			Sign =/= ?ONLINE ->
				{maps:remove(Key, TemUserMap), TemLvMap};
			true ->
				NewTemLvMap = add_num(RoleLv, TemLvMap),
				{TemUserMap, NewTemLvMap}
		end
	end,
	{NewUserMap, LvMap} = lists:foldl(Fun, {UserMap, #{}}, UserList),
	{noreply, State#online_state{lv_num = LvMap, user_map = NewUserMap, clear_ref = NewClearRef, clear_time = NextClearTime}};


do_handle_info(_, State) ->
	{noreply, State}.


%================================================分割线==============================================
db_select() ->
	db:get_all(io_lib:format(?sql_online_select, [])).

db_replace(MinLv, MaxLv, Num) ->
	db:execute(io_lib:format(?sql_online_replace, [MinLv, MaxLv, max(0, Num)])).

db_truncate() ->
	db:execute(io_lib:format(?sql_online_truncate, [])).

%%依据玩家等级计算等级区间
get_lv_interval(RoleLv) ->
	MinLv = (RoleLv div ?LV_GAP)*?LV_GAP,
	MaxLv = MinLv + ?LV_GAP,
	{MinLv, MaxLv}.

%%登陆时统计
add_num(RoleLv, LvMap) ->
	LvMapKey = get_lv_interval(RoleLv),
	{MinLv, MaxLv} = LvMapKey,
	case maps:get(LvMapKey, LvMap, []) of
		Num when is_integer(Num) ->
			NewLvMap = maps:put(LvMapKey, Num + 1, LvMap),
			db_replace(MinLv, MaxLv, Num + 1);
		_ ->
			NewLvMap = maps:put(LvMapKey, 1, LvMap)
	end,
	NewLvMap.

%%升级刷新
lv_up(OldKey, NewKey, LvMap) ->
	{OMinLv, OMaxLv} = OldKey,
	{NMinLv, NMaxLv} = NewKey,
	case maps:get(OldKey, LvMap, []) of
		Num when is_integer(Num) ->
			TemMap = maps:put(OldKey, Num - 1, LvMap),
			db_replace(OMinLv, OMaxLv, Num - 1),
			case maps:get(NewKey, TemMap, []) of
				TNum when is_integer(TNum) ->
					NewLvMap = maps:put(NewKey, TNum + 1, TemMap),
					db_replace(NMinLv, NMaxLv, TNum + 1);
				_ ->
					NewLvMap = maps:put(NewKey, 1, TemMap),
					db_replace(NMinLv, NMaxLv, 1)
			end;
		_ ->
			case maps:get(NewKey, LvMap, []) of
				SNum when is_integer(SNum) ->
					NewLvMap = maps:put(NewKey, SNum + 1, LvMap),
					db_replace(NMinLv, NMaxLv, SNum + 1);
				_ ->
					NewLvMap = maps:put(NewKey, 1, LvMap),
					db_replace(NMinLv, NMaxLv, 1)
			end
	end,
	NewLvMap.