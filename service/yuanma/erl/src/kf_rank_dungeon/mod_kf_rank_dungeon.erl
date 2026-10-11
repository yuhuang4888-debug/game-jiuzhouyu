% %% ---------------------------------------------------------------------------
% %% @doc mod_kf_rank_dungeon
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_kf_rank_dungeon).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("kf_rank_dungeon.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

update_challenger_by_level(KfRDungeonRole, Level, NewGoTime, NowTime, IsFirstSucc) ->
    gen_server:cast(?MODULE, {update_challenger_by_level, KfRDungeonRole, Level, NewGoTime, NowTime, IsFirstSucc}).

send_self_area_challengers(Msg) ->
    gen_server:cast(?MODULE, {send_self_area_challengers, Msg}).

send_area_challengers(Msg) ->
    gen_server:cast(?MODULE, {send_area_challengers, Msg}).

midnight_reset() ->
    gen_server:cast(?MODULE, {midnight_reset}).

rename(Msg) ->
    gen_server:cast(?MODULE, {rename, Msg}).

role_attr_change(Msg) ->
    gen_server:cast(?MODULE, {role_attr_change, Msg}).

%% 修复重置
fix_reset_data() ->
    gen_server:cast(?MODULE, {fix_reset_data}).
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


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
%% 更新擂主的流程：
%% 1. 挑战时间比擂主时间长(不管向上层挑战还是向下层挑战，也不会更改擂主)
%% 2. 挑战时间比擂主短，但是擂主是自己, 或者level没有擂主，自己也不是擂主
%% 3. 本来是x层的擂主，挑战比x层低的层数(不管挑战时间长或短，都不会更改擂主)
%% 4. 挑战时间比擂主短并且自己不是擂主，更新该层所属区间的所有擂主
%% 5. 挑战时间比擂主短并且自己是擂主，更新该区间和自身擂主所在的区间的所有擂主
do_handle_cast({update_challenger_by_level, KfRDungeonRole, Level, NewGoTime, NowTime, IsFirstSucc}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, level_map = LevelMap, challenger = ChallengerMap} = State,
    db_replace_kf_rdungeon_role(KfRDungeonRole),
    NewRoleMap = maps:put(KfRDungeonRole#kf_rdungeon_role.role_id, KfRDungeonRole, RoleMap),
    NewLevelMap = update_level_map(LevelMap, KfRDungeonRole, Level),
    SelfLevel = lib_kf_rank_dungeon:get_challenger_level_by_role(ChallengerMap, KfRDungeonRole#kf_rdungeon_role.role_id),
    State1 = State#kf_rdungeon_state{role_map = NewRoleMap, level_map = NewLevelMap},
    OldLevelChallenger = maps:get(Level, ChallengerMap, false),
    case OldLevelChallenger of 
        #level_challenger{go_time = OldGoTime} when OldGoTime =< NewGoTime ->
            UpStep = 1;
        #level_challenger{role_id = RoleId} when RoleId == KfRDungeonRole#kf_rdungeon_role.role_id ->
            UpStep = 2;
        _ -> 
            case SelfLevel > 0 of 
                true -> %% 自己是擂主
                    UpStep = ?IF(Level < SelfLevel, 3, 5);
                _ ->
                    UpStep = ?IF(is_record(OldLevelChallenger, level_challenger), 4, 2)
            end
    end,
    ?PRINT("update_challenger_by_level UpStep : ~p~n", [UpStep]),
    if
        UpStep == 1 orelse UpStep == 3 ->
            %% 没有成为擂主
            IsChallenger = 0,
            NewState = State1;
        UpStep == 2 ->
            %% 成为擂主
            IsChallenger = 1,
            NewLevelChallenger = #level_challenger{level = Level, role_id = KfRDungeonRole#kf_rdungeon_role.role_id, go_time = NewGoTime, time = NowTime},
            NewChallengerMap = maps:put(Level, NewLevelChallenger, ChallengerMap),
            Area = lib_kf_rank_dungeon:get_area_by_level(Level),
            put({area_change, Area}, true),
            NewState = State1#kf_rdungeon_state{challenger = NewChallengerMap};
        UpStep == 4 orelse UpStep == 5 ->
            %% 成为擂主
            IsChallenger = 1,
            AreaSelf = lib_kf_rank_dungeon:get_area_by_level(SelfLevel),
            Area = lib_kf_rank_dungeon:get_area_by_level(Level),
            AreaListTmp = ?IF(AreaSelf =/= Area, [AreaSelf, Area], [Area]),
            ?PRINT("update_challenger_by_level AreaListTmp : ~p~n", [AreaListTmp]),
            AreaList = [begin put({area_change, AreaId}, true), AreaId end||AreaId <- AreaListTmp, AreaId > 0],
            F = fun(AreaId, StateTmp) ->
                update_level_challenger_by_area(StateTmp, AreaId)
            end,
            NewState = lists:foldl(F, State1, AreaList);
        true ->
            %% 没有成为擂主
            IsChallenger = 0,
            NewState = State1
    end,
    ?PRINT("new level_map : ~p~n", [NewState#kf_rdungeon_state.level_map]),
    ?PRINT("new challenger : ~p~n", [NewState#kf_rdungeon_state.challenger]),
    mod_clusters_center:apply_cast(KfRDungeonRole#kf_rdungeon_role.server_id, 
        lib_kf_rank_dungeon, send_dungeon_settlement, [1, KfRDungeonRole#kf_rdungeon_role.role_id, Level, NewGoTime, IsChallenger, IsFirstSucc]),
    {noreply, NewState};

do_handle_cast({send_self_area_challengers, [Node, _RoleId, Sid, AreaId]}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    case get({area_change, AreaId}) of 
        false ->
            ?PRINT("send_self_area_challengers not change ~n", []),
            ChallengerList = get({area_challenger, AreaId});
        _ ->
            ChallengerList = get_area_challenger_list(AreaId, RoleMap, ChallengerMap),
            put({area_challenger, AreaId}, ChallengerList),
            put({area_change, AreaId}, false)
    end,
    {ok, Bin} = pt_507:write(50702, [AreaId, ChallengerList]),
    lib_server_send:send_to_sid(Node, Sid, Bin),
    ?PRINT("send_self_area_challengers:~p~n", [{AreaId, ChallengerList}]),
    {noreply, State};

do_handle_cast({send_area_challengers, [Node, Sid, AreaId]}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    case get({area_change, AreaId}) of 
        false ->
            ChallengerList = get({area_challenger, AreaId});
        _ ->
            ChallengerList = get_area_challenger_list(AreaId, RoleMap, ChallengerMap),
            put({area_challenger, AreaId}, ChallengerList),
            put({area_change, AreaId}, false)
    end,
    SendList = [{Level, RoleId, RoleName, ServerNum, GoTime} || {Level, RoleId, RoleName, _SerId, ServerNum, _RoleLv, _Career, _Sex, _Turn, _Pic, _PicVer, GoTime} <- ChallengerList],
    {ok, Bin} = pt_507:write(50703, [AreaId, SendList]),
    lib_server_send:send_to_sid(Node, Sid, Bin),
    ?PRINT("send_area_challengers:~p~n", [{AreaId, SendList}]),
    {noreply, State};

do_handle_cast({rename, [RoleId, RoleName]}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    case maps:get(RoleId, RoleMap, 0) of 
        #kf_rdungeon_role{} = KfRDungeonRole ->
            NewKfRDungeonRole = KfRDungeonRole#kf_rdungeon_role{name = RoleName},
            F = fun(Level, LevelChallenger, Acc) ->
                case LevelChallenger#level_challenger.role_id == RoleId of 
                    true ->
                        Area = lib_kf_rank_dungeon:get_area_by_level(Level),
                        put({area_change, Area}, true),
                        Acc;
                    _ -> Acc
                end
            end,
            maps:fold(F, 0, ChallengerMap),
            db_update_kf_rdungeon_role_name(RoleId, RoleName),
            {noreply, State#kf_rdungeon_state{role_map = maps:put(RoleId, NewKfRDungeonRole, RoleMap)}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({role_attr_change, {RoleId, AttrList}}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    case maps:get(RoleId, RoleMap, 0) of 
        #kf_rdungeon_role{} = KfRDungeonRole ->
            NewKfRDungeonRole = update_role_attr(KfRDungeonRole, AttrList),
            F = fun(Level, LevelChallenger, Acc) ->
                case LevelChallenger#level_challenger.role_id == RoleId of 
                    true ->
                        Area = lib_kf_rank_dungeon:get_area_by_level(Level),
                        put({area_change, Area}, true),
                        Acc;
                    _ -> Acc
                end
            end,
            maps:fold(F, 0, ChallengerMap),
            {noreply, State#kf_rdungeon_state{role_map = maps:put(RoleId, NewKfRDungeonRole, RoleMap)}};
        _ ->
            {noreply, State}
    end;


do_handle_cast({midnight_reset}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    %% 清理进程数据
    erase(),
    %% 日志
    log_level_challenger(ChallengerMap, RoleMap),
    %% 发送擂主奖励
    send_challenger_reward(ChallengerMap, RoleMap),
    spawn(fun() -> 
        db:execute(io_lib:format(?SQL_KF_RANK_DUN_ROLE_TRUNCATE, []))
    end),
    {noreply, State#kf_rdungeon_state{role_map = #{}, challenger = #{}, level_map = #{}}};

do_handle_cast({fix_reset_data}, State) ->
    #kf_rdungeon_state{role_map = RoleMap, challenger = ChallengerMap} = State,
    %% 清理进程数据
    erase(),
    %% 日志
    log_level_challenger(ChallengerMap, RoleMap),
    spawn(fun() ->
        db:execute(io_lib:format(?SQL_KF_RANK_DUN_ROLE_TRUNCATE, []))
     end),
    {noreply, State#kf_rdungeon_state{role_map = #{}, challenger = #{}, level_map = #{}}};
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info(_Info, State) -> {noreply, State}.

init_do() ->
    case db:get_all(io_lib:format(?SQL_KF_RANK_DUN_ROLE_SELECT, [])) of 
        [] -> #kf_rdungeon_state{};
        DbList ->
            RoleMap = lists:foldl(fun([RoleId, Name, ServerId, ServerNum, RoleLv, Career, Sex, Turn, Pic, PicVer, LDungeonListStr], Map) ->
                KfRDungeonRole = lib_kf_rank_dungeon:make(kf_rdungeon_role, [RoleId, Name, ServerId, ServerNum, RoleLv, Career, Sex, Turn, Pic, PicVer, util:bitstring_to_term(LDungeonListStr)]),
                maps:put(RoleId, KfRDungeonRole, Map)
            end, #{}, DbList),
            LevelMap = reset_level_map(RoleMap),
            State = #kf_rdungeon_state{role_map = RoleMap, level_map = LevelMap},
            MaxLevel = lib_kf_rank_dungeon:get_dungeon_max_level(),
            LevelList = lists:reverse(lists:seq(1, MaxLevel)),
            update_level_challenger_by_level(LevelList, State)
    end.

reset_level_map(RoleMap) ->
    F = fun(_, KfRDungeonRole, Map) ->
        #kf_rdungeon_role{role_id = RoleId, ldungeon_list = LDungeonList} = KfRDungeonRole,
        MaxLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
        F1 = fun({Level, GoTime, Time}, Map1) ->
            case lib_kf_rank_dungeon:is_same_area(Level, MaxLevel) of 
                true ->
                    OldList = maps:get(Level, Map1, []),
                    NewList = [{RoleId, GoTime, Time}|OldList],
                    maps:put(Level, NewList, Map1);
                _ -> 
                    Map1
            end
        end,
        lists:foldl(F1, Map, LDungeonList)
    end,
    NewLevelMap = maps:fold(F, #{}, RoleMap),
    F2 = fun(_Level, LevelDungeonList) ->
        sort_level_dungeon_list(LevelDungeonList)
    end,
    maps:map(F2, NewLevelMap).

update_level_challenger_by_area(State, AreaId) ->
    LevelList = lib_kf_rank_dungeon:get_level_list_by_area(AreaId),
    update_level_challenger_by_level(LevelList, State).

update_level_challenger_by_level(LevelList, State) ->
    update_level_challenger_by_level(LevelList, #{}, State).

update_level_challenger_by_level([], _Map, State) -> State;
update_level_challenger_by_level([Level|LevelList], Map, State) ->
    #kf_rdungeon_state{level_map = LevelMap, challenger = ChallengerMap} = State,
    case maps:get(Level, LevelMap, []) of 
        [_|_] = LevelDungeonList ->
            %% 检查RoleId是否在这个区间的更高层数作为擂主，是的话继续往下选
            %AreaId = lib_kf_rank_dungeon:get_area_by_level(Level),
            %{_, AreaLevelMax} = lib_kf_rank_dungeon:get_level_range(AreaId),
            case find_challenger_do(LevelDungeonList, Map) of 
                {RoleId, GoTime, Time} ->
                    LevelChallenger = #level_challenger{level = Level, role_id = RoleId, go_time = GoTime, time = Time},
                    NewChallengerMap = maps:put(Level, LevelChallenger, ChallengerMap),
                    NewMap = maps:put(RoleId, 1, Map),
                    update_level_challenger_by_level(LevelList, NewMap, State#kf_rdungeon_state{challenger = NewChallengerMap});
                _ ->
                    NewChallengerMap = maps:remove(Level, ChallengerMap),
                    update_level_challenger_by_level(LevelList, Map, State#kf_rdungeon_state{challenger = NewChallengerMap})
            end;    
        _ ->
            NewChallengerMap = maps:remove(Level, ChallengerMap),
            update_level_challenger_by_level(LevelList, Map, State#kf_rdungeon_state{challenger = NewChallengerMap})
    end.

find_challenger_do([], _Map) -> none;
find_challenger_do([{RoleId, GoTime, Time}|LevelDungeonList], Map) ->
    case maps:is_key(RoleId, Map) of 
        true -> find_challenger_do(LevelDungeonList, Map);
        _ -> {RoleId, GoTime, Time}
    end.


% find_challenger_do([], _Level, _AreaLevelMax, _ChallengerMap) -> none;
% find_challenger_do([{RoleId, GoTime, Time}|LevelDungeonList], Level, AreaLevelMax, ChallengerMap) ->
%     case lib_kf_rank_dungeon:is_challengers_in_high_level(RoleId, Level, AreaLevelMax, ChallengerMap) of 
%         true ->
%             find_challenger_do(LevelDungeonList, Level, AreaLevelMax, ChallengerMap);
%         _ ->
%             {RoleId, GoTime, Time}
%     end.

update_level_map(LevelMap, KfRDungeonRole, LevelUpdate) ->
    #kf_rdungeon_role{role_id = RoleId, ldungeon_list = LDungeonList} = KfRDungeonRole,
    MaxLevel = lib_kf_rank_dungeon:get_max_level(LDungeonList),
    F = fun({Level, GoTime, Time}, Map) ->
        OldList = maps:get(Level, Map, []),
        case lib_kf_rank_dungeon:is_same_area(Level, MaxLevel) of 
            true ->
                case Level == LevelUpdate of 
                    true ->
                        NewList = lists:keystore(RoleId, 1, OldList, {RoleId, GoTime, Time}),
                        LastList = sort_level_dungeon_list(NewList),
                        maps:put(Level, LastList, Map);
                    _ ->
                        Map
                end;
            _ -> %% 删除数据
                NewList = lists:keydelete(RoleId, 1, OldList),
                maps:put(Level, NewList, Map)
        end
    end,
    lists:foldl(F, LevelMap, LDungeonList).

sort_level_dungeon_list(LevelDungeonList) ->
    F = fun({_, GoTime1, Time1}, {_, GoTime2, Time2}) ->
        if
            GoTime1 < GoTime2 -> true;
            GoTime1 == GoTime2 -> Time1 < Time2;
            true -> false
        end
    end,
    lists:sort(F, LevelDungeonList).

get_area_challenger_list(AreaId, RoleMap, ChallengerMap) ->
    {LevelLow, LevelUp} = lib_kf_rank_dungeon:get_level_range(AreaId),
    F = fun(Level, List) ->
        case maps:get(Level, ChallengerMap, 0) of 
            #level_challenger{role_id = RoleId, go_time = GoTime} ->
                case maps:get(RoleId, RoleMap, 0) of 
                    #kf_rdungeon_role{
                        name = Name
                        , server_id = ServerId
                        , server_num = ServerNum
                        , lv = RoleLv
                        , career = Career
                        , sex = Sex
                        , turn = Turn
                        , pic = Pic
                        , pic_ver = PicVer
                    } ->
                        [{Level, RoleId, Name, ServerId, ServerNum, RoleLv, Career, Sex, Turn, Pic, PicVer, GoTime}|List];
                    _ -> List
                end;
            _ ->
                List
        end
    end,
    lists:foldl(F, [], lists:seq(LevelLow, LevelUp)).

%% 擂主奖励
send_challenger_reward(ChallengerMap, RoleMap) ->
    F = fun(Level, LevelChallenger, Map) ->
        #level_challenger{role_id = RoleId} = LevelChallenger,
        case maps:get(RoleId, RoleMap, 0) of 
            #kf_rdungeon_role{server_id = ServerId} ->
                OList = maps:get(ServerId, Map, []),
                maps:put(ServerId, [{RoleId, Level}|OList], Map);
            _ -> Map
        end
    end,
    ServerMap = maps:fold(F, #{}, ChallengerMap),
    spawn(fun() -> send_challenger_reward_do(ServerMap) end),
    ok.

send_challenger_reward_do(ServerMap) ->
    F = fun(ServerId, RoleList, Acc) ->
        mod_clusters_center:apply_cast(ServerId, lib_kf_rank_dungeon, send_challenger_reward, [RoleList]),
        timer:sleep(20),
        Acc+1
    end,
    maps:fold(F, 1, ServerMap).

log_level_challenger(ChallengerMap, RoleMap) ->
    NowTime = utime:unixtime(),
    F = fun(Level, LevelChallenger, List) ->
        #level_challenger{role_id = RoleId, go_time = GoTime} = LevelChallenger,
        case maps:get(RoleId, RoleMap, 0) of 
            #kf_rdungeon_role{name = RoleName, server_id = ServerId, server_num = ServerNum} ->
                [[RoleId, RoleName, ServerId, ServerNum, Level, GoTime, NowTime]|List];
            _ -> List
        end
    end,
    LogList = maps:fold(F, [], ChallengerMap),
    lib_log_api:log_rank_dungeon_challengers(LogList).

update_role_attr(KfRDungeonRole, []) -> KfRDungeonRole;
update_role_attr(KfRDungeonRole, [Item|AttrList]) ->
    case Item of 
        {picture, Picture, PicVer} ->
            Sql = io_lib:format(<<"update `kf_rank_dun_role` set pic='~s', pic_ver=~p where role_id=~p">>, [Picture, PicVer, KfRDungeonRole#kf_rdungeon_role.role_id]),
            db:execute(Sql),
            update_role_attr(KfRDungeonRole#kf_rdungeon_role{pic = Picture, pic_ver = PicVer}, AttrList);
        {turn, Turn} ->
            Sql = io_lib:format(<<"update `kf_rank_dun_role` set turn=~p where role_id=~p">>, [Turn, KfRDungeonRole#kf_rdungeon_role.role_id]),
            db:execute(Sql),
            update_role_attr(KfRDungeonRole#kf_rdungeon_role{turn = Turn}, AttrList);
        _ ->
            update_role_attr(KfRDungeonRole, AttrList)
    end.


db_replace_kf_rdungeon_role(KfRDungeonRole) ->
    #kf_rdungeon_role{
        role_id = RoleId        % 擂主id
        , name = Name
        , server_id = ServerId
        , server_num = ServerNum
        , lv = RoleLv
        , career = Career
        , sex = Sex
        , turn = Turn
        , pic = Pic
        , pic_ver = PicVer
        , ldungeon_list = LDungeonList
    } = KfRDungeonRole,
    db:execute(io_lib:format(?SQL_KF_RANK_DUN_ROLE_REPLACE, [RoleId, Name, ServerId, ServerNum, RoleLv, Career, Sex, Turn, Pic, PicVer, util:term_to_bitstring(LDungeonList)])).

db_update_kf_rdungeon_role_name(RoleId, RoleName) ->
    Sql = io_lib:format(<<"update `kf_rank_dun_role` set name='~s' where role_id=~p ">>, [RoleName, RoleId]),
    db:execute(Sql).