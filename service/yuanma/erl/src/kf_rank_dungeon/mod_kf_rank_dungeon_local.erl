% %% ---------------------------------------------------------------------------
% %% @doc mod_kf_rank_dungeon_local
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_kf_rank_dungeon_local).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

]).
-compile(export_all).
-include("kf_rank_dungeon.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("goods.hrl").
%%-----------------------------



dungeon_succ(Msg) ->
    gen_server:cast(?MODULE, {dungeon_succ, Msg}).

%%%% pp
send_self_rank_dungeon_info(Msg) ->
    gen_server:cast(?MODULE, {send_self_rank_dungeon_info, Msg}).

send_self_area_challengers(Msg) ->
    gen_server:cast(?MODULE, {send_self_area_challengers, Msg}).

get_level_reward(Msg) ->
    gen_server:cast(?MODULE, {get_level_reward, Msg}).

midnight_reset() ->
    gen_server:cast(?MODULE, {midnight_reset}).

rename(Msg) ->
    gen_server:cast(?MODULE, {rename, Msg}).

role_attr_change(Msg) ->
    gen_server:cast(?MODULE, {role_attr_change, Msg}).

gm_reset_rank_dungeon(Msg) ->
    gen_server:cast(?MODULE, {gm_reset_rank_dungeon, Msg}).

enter_dungeon_check(Msg) ->
    gen_server:call(?MODULE, {enter_dungeon_check, Msg}, 3000).

get_player_cur_max_level(Msg) ->
    gen_server:call(?MODULE, {get_player_cur_max_level, Msg}, 3000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    %?PRINT("init State : ~p~n", [State]),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({enter_dungeon_check, [RoleId, Level]}, _From, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
    #rdungeon_role{start_level = StartLevel, ldungeon_list = LDungeonList} = RDungeonRole,
    case Level >= StartLevel of
        true ->
            case LDungeonList == [] of
                true ->
                    NextChallengeLevel = StartLevel;
                _ ->
                    NextChallengeLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList) + 1
            end,
            if
                Level < NextChallengeLevel ->
                    Reply = true;
                Level == NextChallengeLevel ->
                    case length(LDungeonList) >= 20 of
                        false ->
                            Reply = true;
                        _ ->
                            Reply = {false, ?ERRCODE(err507_no_dungeon_times)}
                    end;
                true -> %% 前置层数未通关
                    Reply = {false, ?ERRCODE(err507_pre_level_not_pass)}
            end;
        _ -> %% 不能往底层挑战 
            Reply = {false, ?ERRCODE(err507_level_too_low)}
    end,
    {reply, Reply, State};

do_handle_call({get_player_cur_max_level, [RoleId]}, _From, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
    #rdungeon_role{start_level = StartLevel, ldungeon_list = LDungeonList} = RDungeonRole,
    case LDungeonList == [] of
        true ->
            MaxLevel = StartLevel;
        _ ->
            NextChallengeLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
            MaxLevel = max(0, NextChallengeLevel)
    end,
    CurArea = lib_kf_rank_dungeon:get_area_by_level(MaxLevel),
    Reply = {ok, CurArea},
    {reply, Reply, State};

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({dungeon_succ, [RoleArgs, Level, GoTime]}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    [RoleId, ServerId, ServerNum, RoleName, Lv, Career, Sex, Turn, Pic, PicVer] = RoleArgs,
    NowTime = utime:unixtime(),
    case maps:get(RoleId, RoleMap, 0) of
        #rdungeon_role{ldungeon_list = LDungeonList} = RDungeonRole ->
            case lists:keyfind(Level, 1, LDungeonList) of
                {_, OldGoTime, _OldTime} ->
                    case OldGoTime > GoTime of
                        true ->
                            NeedUp = true, IsFirstSucc = 0,
                            NewLDungeonList = lists:keyreplace(Level, 1, LDungeonList, {Level, GoTime, NowTime});
                        _ ->
                            NeedUp = false, IsFirstSucc = 0,
                            NewLDungeonList = LDungeonList
                    end;
                _ ->
                    NeedUp = true, IsFirstSucc = 1,
                    NewLDungeonList = [{Level, GoTime, NowTime}|LDungeonList]
            end,
            NewRDungeonRole = RDungeonRole#rdungeon_role{ldungeon_list = NewLDungeonList};
        _ ->
            %% 更新跨服的数据
            NeedUp = true, IsFirstSucc = 1,
            LDungeonList = [{Level, GoTime, NowTime}],
            NewRDungeonRole = #rdungeon_role{role_id = RoleId, time = NowTime, ldungeon_list = LDungeonList}
    end,
    NewRoleMap = maps:put(RoleId, NewRDungeonRole, RoleMap),
    NewState = State#rdungeon_state{role_map = NewRoleMap},
    ?PRINT("dungeon_succ NeedUp : ~p~n", [{NeedUp, GoTime}]),
    %?PRINT("dungeon_succ NewRDungeonRole : ~p~n", [NewRDungeonRole]),
    case NeedUp of
        true ->
            %% 更新跨服榜单数据
            KfRDungeonRole = lib_kf_rank_dungeon:make(kf_rdungeon_role,
                [RoleId, RoleName, ServerId, ServerNum, Lv, Career, Sex, Turn, Pic, PicVer, NewRDungeonRole#rdungeon_role.ldungeon_list]),
            mod_clusters_node:apply_cast(mod_kf_rank_dungeon, update_challenger_by_level, [KfRDungeonRole, Level, GoTime, NowTime, IsFirstSucc]),
            lib_log_api:log_rdungeon_success(RoleId, Level, GoTime),
            db_replace_rdungeon_role(NewRDungeonRole);
        _ -> %% 不用更新：已经挑战过并且比上次挑战时间还要长
            %% 发送结算
            lib_kf_rank_dungeon:send_dungeon_settlement(1, RoleId, Level, GoTime, 0, 0)
    end,
    {noreply, NewState};

do_handle_cast({midnight_reset}, State) ->
    NewState = reset_all(State),
    {noreply, NewState};

do_handle_cast({send_self_rank_dungeon_info, [RoleId, Sid]}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
    #rdungeon_role{start_level = StartLevel, rw_state = RwState, ldungeon_list = LDungeonList} = RDungeonRole,
    SendList = [{Level, GoTime} ||{Level, GoTime, _Time} <- LDungeonList],
    lib_server_send:send_to_sid(Sid, pt_507, 50701, [StartLevel, RwState, SendList]),
    ?PRINT("send_self_rank_dungeon_info:~p~n", [{StartLevel, RwState, SendList}]),
    {noreply, State};

do_handle_cast({send_self_area_challengers, [Node, RoleId, Sid, AreaIdIn]}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
    #rdungeon_role{start_level = StartLevel, ldungeon_list = LDungeonList} = RDungeonRole,
    RoleMaxLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
    NewRoleMaxLevel = ?IF(RoleMaxLevel =< StartLevel, StartLevel, RoleMaxLevel),
    AreaIdUp = lib_kf_rank_dungeon:get_area_by_level(NewRoleMaxLevel+1),
    AreaIdMin = lib_kf_rank_dungeon:get_area_by_level(StartLevel),
    ?PRINT("send_self_area_challengers : ~p~n", [{AreaIdIn, AreaIdMin, AreaIdUp}]),
    case lists:member(AreaIdIn, lists:seq(AreaIdMin, AreaIdUp)) of
        true ->
            mod_clusters_node:apply_cast(mod_kf_rank_dungeon, send_self_area_challengers, [[Node, RoleId, Sid, AreaIdIn]]);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_507, 50702, [AreaIdIn, []])
    end,
    {noreply, State};

do_handle_cast({get_level_reward, [RoleId, Sid]}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #rdungeon_role{start_level = StartLevel, rw_state = 0} = RDungeonRole when StartLevel > 1 ->
            case lib_kf_rank_dungeon:get_daily_reward(StartLevel) of
                none ->
                    lib_server_send:send_to_sid(Sid, pt_507, 50704, [?MISSING_CONFIG, 0]),
                    {noreply, State};
                RewardList ->
                    ?PRINT("get_level_reward:~p~n", [RewardList]),
                    Produce = #produce{type = kf_rank_dungeon, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    NewRDungeonRole = RDungeonRole#rdungeon_role{rw_state = 1},
                    db_replace_rdungeon_role(NewRDungeonRole),
                    lib_server_send:send_to_sid(Sid, pt_507, 50704, [?SUCCESS, 1]),
                    {noreply, State#rdungeon_state{role_map = maps:put(RoleId, NewRDungeonRole, RoleMap)}}
            end;
        #rdungeon_role{start_level = 1} ->
            lib_server_send:send_to_sid(Sid, pt_507, 50704, [?ERRCODE(err507_no_reward), 0]),
            {noreply, State};
        #rdungeon_role{} ->
            lib_server_send:send_to_sid(Sid, pt_507, 50704, [?ERRCODE(err507_reward_got), 0]),
            {noreply, State};
        _ ->
            lib_server_send:send_to_sid(Sid, pt_507, 50704, [?ERRCODE(err507_no_reward), 0]),
            {noreply, State}
    end;

do_handle_cast({rename, [RoleId, RoleName]}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #rdungeon_role{} ->
            mod_clusters_node:apply_cast(mod_kf_rank_dungeon, rename, [[RoleId, RoleName]]);
        _ ->
            skip
    end,
    {noreply, State};

do_handle_cast({role_attr_change, {RoleId, AttrList}}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #rdungeon_role{} ->
            mod_clusters_node:apply_cast(mod_kf_rank_dungeon, role_attr_change, [{RoleId, AttrList}]);
        _ ->
            skip
    end,
    {noreply, State};

do_handle_cast({gm_reset_rank_dungeon, RoleId}, State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
    #rdungeon_role{ldungeon_list = LDungeonList} = RDungeonRole,
    {Level, _GoTime, _Time} = lists:nth(1, LDungeonList),
    NewRDungeonRole = RDungeonRole#rdungeon_role{start_level = Level+1, rw_state = 1, ldungeon_list = []},
    NewRoleMap = maps:put(RoleId, NewRDungeonRole, RoleMap),
    NewState = State#rdungeon_state{role_map = NewRoleMap},
    {noreply, NewState};

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================


do_handle_info({reset_sql_save, ThisIds}, State) ->
    reset_sql_save(State, ThisIds),
    {noreply, State};
do_handle_info(_Info, State) -> {noreply, State}.

init_do() ->
    case db:get_all(io_lib:format(?SQL_RANK_DUN_ROLE_SELECT, [])) of
        [] -> RoleMap = #{};
        RoleDbList ->
            RoleMap = lists:foldl(fun([RoleId, StartLevel, RwState, Time, LDungeonListStr], Map) ->
                LDungeonList = util:bitstring_to_term(LDungeonListStr),
                RDungeonRole = lib_kf_rank_dungeon:make(rdungeon_role, [RoleId, StartLevel, RwState, Time, LDungeonList]),
                maps:put(RoleId, RDungeonRole, Map)
                                  end, #{}, RoleDbList)
    end,
    State = #rdungeon_state{role_map = RoleMap},
    NewState = check_reset_rank_dun_role(State),
    NewState.

check_reset_rank_dun_role(State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, RDungeonRole, {UpDbList, Map}) ->
        #rdungeon_role{start_level = OldStartLevel, time = Time, ldungeon_list = LDungeonList} = RDungeonRole,
        case utime_logic:is_logic_same_day(NowTime, Time) of
            true ->
                {UpDbList, Map};
            _ ->
                case LDungeonList == [] of
                    false ->
                        MaxLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
                        StartLevel = lib_kf_rank_dungeon:get_start_level(MaxLevel);
                    _ ->
                        StartLevel = OldStartLevel
                end,
                LastLDungeonList = [],
                NewRDungeonRole = RDungeonRole#rdungeon_role{start_level = StartLevel, rw_state = 0, time = NowTime, ldungeon_list = LastLDungeonList},
                {[[RoleId, StartLevel, 0, NowTime, util:term_to_bitstring(LastLDungeonList)]|UpDbList], maps:put(RoleId, NewRDungeonRole, Map)}
        end
        end,
    {UpDbList, NewRoleMap} = maps:fold(F, {[], RoleMap}, RoleMap),
    case length(UpDbList) > 0 of
        true ->
            FDo = fun() ->
                db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], UpDbList)),
                ok
                  end,
            case db:transaction(FDo) of
                ok ->
                    skip;
                _ERR ->
                    ?ERR("check_reset_rank_dun_role _ERR:~p~n", [_ERR])
            end;
        _ ->
            skip
    end,
    State#rdungeon_state{role_map = NewRoleMap}.

reset_all(State) ->
    #rdungeon_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, RDungeonRole, {UpDbList, Map}) ->
        #rdungeon_role{start_level = OldStartLevel, ldungeon_list = LDungeonList} = RDungeonRole,
        case LDungeonList == [] of
            false ->
                MaxLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
                StartLevel = lib_kf_rank_dungeon:get_start_level(MaxLevel);
            _ ->
                StartLevel = OldStartLevel
        end,
        LastLDungeonList = [],
        NewRDungeonRole = RDungeonRole#rdungeon_role{start_level = StartLevel, rw_state = 0, time = NowTime, ldungeon_list = LastLDungeonList},
        {[[RoleId, StartLevel, 0, NowTime, util:term_to_bitstring(LastLDungeonList)]|UpDbList], maps:put(RoleId, NewRDungeonRole, Map)}
        end,
    {UpDbList, NewRoleMap} = maps:fold(F, {[], RoleMap}, RoleMap),
    UpdLen = length(UpDbList),
    if
        UpdLen > 200 ->
            {DealArgs, LeftArgs} = lists:split(200, UpDbList),
            db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], DealArgs)),
            Pid = self(),
            spawn(
                fun() ->
                    LeftLen = length(LeftArgs),
                    LoopNum = umath:ceil(LeftLen / 200),
                    F_loop = fun(_, LeftL) ->
                        timer:sleep(1000),
                        case length(LeftL) > 200 of
                            true ->
                                {ThisIds, NextIds} = lists:split(200, LeftL);
                            _ ->
                                ThisIds = LeftL, NextIds = []
                        end,
                        Pid ! {reset_sql_save, ThisIds},
                        NextIds
                             end,
                    lists:foldl(F_loop, [Id||[Id, _, _, _,_]<-LeftArgs], lists:seq(1, LoopNum))
                end
            );
        UpdLen > 0 ->
            db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], UpDbList));
        true ->
            skip
    end,
    State#rdungeon_state{role_map = NewRoleMap}.

reset_sql_save(State, ThisIds) ->
    #rdungeon_state{role_map = RoleMap} = State,
    F = fun(RoleId, UpDbList) ->
        RDungeonRole = maps:get(RoleId, RoleMap, #rdungeon_role{}),
        #rdungeon_role{start_level = StartLevel, rw_state = 0, time = NowTime, ldungeon_list = LastLDungeonList} = RDungeonRole,
        [[RoleId, StartLevel, 0, NowTime, util:term_to_bitstring(LastLDungeonList)]|UpDbList]
        end,
    UpDbList = lists:foldl(F, [], ThisIds),
    db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], UpDbList)).


db_replace_rdungeon_role(RDungeonRole) ->
    #rdungeon_role{role_id = RoleId, start_level = StartLevel, rw_state = RwState, time = Time, ldungeon_list = LDungeonList} = RDungeonRole,
    db:execute(io_lib:format(?SQL_RANK_DUN_ROLE_REPLACE, [RoleId, StartLevel, RwState, Time, util:term_to_bitstring(LDungeonList)])).


