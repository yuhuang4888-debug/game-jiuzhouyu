%%% -------------------------------------------------------------------
%%% @doc        lib_rush_treasure_mod_kf                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-25 9:55               
%%% @deprecated 冲榜夺宝跨服进程逻辑层
%%% -------------------------------------------------------------------

-module(lib_rush_treasure_mod_kf).

-include("rush_treasure.hrl").
-include("def_fun.hrl").
-include("clusters.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("common.hrl").

%% API
-export([
    init/0
    , get_rush_type_rank/6
    , send_info/5
    , rush_treasure_draw/7
    , enter_rank/2
    , send_tv/2
    , get_stage_reward/6
    , act_end/4
    , per_rank_reward/5
    , server_rank_reward/5
    , gm_act_end/3
    , rush_zone_change/4
    , server_info_change/3
    , send_tv_act_is_zone_no/2
]).

%% -----------------------------------------------------------------
%% @desc 初始化榜单
%% @param State 进程State
%% @return NewState
%% -----------------------------------------------------------------
init() ->
    case lib_rush_treasure_sql:db_select_rush_treasure_rank() of
        [] -> NewState = #rank_status{};
        List ->
            F = fun(RoleInfo, RankTypeListA) ->
                [RoleId, Type, SubType, ServerId, Form, ServerNum, Name, MaskId, Score, Time, ServerName] = RoleInfo,
                PForm = binary_to_list(Form),
                RankRole = #rank_role{
                    node       = ServerId,
                    id         = RoleId,
                    server_id  = ServerId,
                    platform   = PForm,
                    server_num = ServerNum,
                    score      = Score,
                    last_time  = Time,
                    figure=#figure{name = Name, mask_id = MaskId},
                    server_name = ServerName
                },
                make_data_rank(Type, SubType, RankTypeListA, RankRole)
                end,
            RankTypeList = lists:foldl(F, [], List),
            NewRankTypeList = sort_all_type_rank(RankTypeList, []),
            %?MYLOG("lwcrank","NRankList:~p~n",[NewRankTypeList]),
            NewState = #rank_status{rush_per_rank = NewRankTypeList}
    end,
    NewState.

%% -----------------------------------------------------------------
%% @desc  组合类型榜单
%% @param Type     主类型
%% @param SubType  次类型
%% @param List     类型榜单列表
%% @param RankRole 榜单角色记录
%% @return NewRankTypeList
%% -----------------------------------------------------------------
make_data_rank(Type, SubType, List, RankRole) ->
    TypeKey = {Type, SubType},
    #rank_role{server_id = ServerId} = RankRole,
    Zone = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
    RankType = lists:keyfind(TypeKey, #rank_type.id, List),
    if
        Zone == false -> List;
        RankType == false ->
            RankList = [RankRole],
            RankData = [#rank_data{id = Zone,rank_list = RankList}],
            NRankType = #rank_type{
                id        = TypeKey,
                type      = Type,
                subtype   = SubType,
                rank_data = RankData
            },
            lists:keystore(TypeKey, #rank_type.id, List, NRankType);
        true->
            #rank_type{rank_data = DataList} = RankType,
            ZoneKey = Zone,
            case lists:keyfind(ZoneKey, #rank_data.id, DataList) of
                false->
                    RankList = [RankRole],
                    RankData = #rank_data{id = ZoneKey,rank_list = RankList},
                    NDataList = lists:keystore(ZoneKey, #rank_data.id, DataList, RankData);
                #rank_data{rank_list = RankList} = RankData ->
                    NRankList = [RankRole | RankList],
                    NRankData = RankData#rank_data{rank_list = NRankList},
                    NDataList = lists:keystore(ZoneKey, #rank_data.id, DataList, NRankData)
            end,
            NRankType = RankType#rank_type{rank_data = NDataList},
            lists:keystore(TypeKey, #rank_type.id, List, NRankType)
    end.

%% -----------------------------------------------------------------
%% @desc  排序所有竞榜夺宝活动榜单
%% @param RankTypeList 竞榜夺宝活动列表
%% @return NewRankTypeList
%% -----------------------------------------------------------------
sort_all_type_rank([], List) -> List;
sort_all_type_rank([RankType | T], List) ->
    #rank_type{
        type      = Type,
        subtype   = SubType,
        rank_data = RankData
    } = RankType,
    NRankData = sort_type_rank(RankData, Type, SubType),
    NRankType = RankType#rank_type{rank_data = NRankData},
    sort_all_type_rank(T,[NRankType | List]).

%% -----------------------------------------------------------------
%% @desc 对同类型活动不同区进行排序
%% @param RankDataList 不同区的玩家信息
%% @return NewRankDataList
%% -----------------------------------------------------------------
sort_type_rank(RankDataList, Type, SubType) ->
    F = fun(RankData, NewRankDataList) ->
        NewRankList = sort_rank_list(Type, SubType, RankData),
        NewRankData = RankData#rank_data{rank_list = NewRankList},
        [NewRankData | NewRankDataList]
        end,
    lists:foldl(F, [], RankDataList).

%% -----------------------------------------------------------------
%% @desc  对同区的玩家进行排序
%% @param Type       主类型
%% @param SubType    子类型
%% @param RankData   排行数据记录
%% @return NewRankData
%% -----------------------------------------------------------------
sort_rank_list(Type, SubType, RankData) ->
    #rank_data{rank_list = RankList} = RankData,
    F = fun(RoleA, RoleB)->
        ?IF( RoleA#rank_role.score =:= RoleB#rank_role.score,
            RoleA#rank_role.last_time =< RoleB#rank_role.last_time,
            RoleA#rank_role.score >= RoleB#rank_role.score)
        end,
    NewRankListA = lists:sort(F, RankList),
    FA = fun(RankRole, {InitRank, RankListA}) ->
        #rank_role{score = Score} = RankRole,
        case lib_rush_treasure_helper:check_enter_rank(Score, Type, SubType, ?PERSON_RANK) of
            false-> {InitRank, [RankRole#rank_role{rank = 0} | RankListA]};
            {RankMin, _RankMax}->
                ?IF(InitRank >= RankMin,
                    {InitRank + 1, [RankRole#rank_role{rank = InitRank} | RankListA]},
                    {RankMin + 1, [RankRole#rank_role{rank = RankMin} | RankListA]})
        end
         end,
    {_InitRank, NewRankList} = lists:foldl(FA, {1, []}, NewRankListA),
    lists:reverse(NewRankList).

%% -----------------------------------------------------------------
%% @desc 发送界面信息
%% @param ServerId 服务器Id
%% @param RoleId   角色Id
%% @param Type     主类型
%% @param SubType  子类型
%% @param State    进程State
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_info(ServerId, RoleId, Type, SubType, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            ZoneEtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
            #ets_main_zone{world_lv = WorldLv} = ulists:keyfind(ZoneId, #ets_main_zone.zone_id, ZoneEtsList, #ets_main_zone{}),
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_rush_treasure_player, send_info, [Type, SubType, WorldLv]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
            {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc 获得榜单信息
%% @param Type     主类型
%% @param SubType  子类型
%% @param RoleId   玩家Id
%% @param ServerId 服务器Id
%% @param Node     节点
%% @param State    进程State
%% @return {noreply, State}
%% -----------------------------------------------------------------
get_rush_type_rank(Type, SubType, RoleId, ServerId, Node, State) ->
    #rank_status{rush_per_rank = RushPerRank} = State,
    ZoneId = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
    RankType = lists:keyfind({Type, SubType}, #rank_type.id, RushPerRank),
    if
        ZoneId =:= false orelse RankType =:= false -> PerRankList = [], PerRank = 0, PerScore = 0, ServerRankList = [], ServerRank = 0, ServerScore = 0;
        true ->
            #rank_type{rank_data = DataList} = RankType,
            case ulists:keyfind(ZoneId, #rank_data.id, DataList, []) of
                [] -> PerRankList = [], PerRank = 0, PerScore = 0, ServerRankList = [], ServerRank = 0, ServerScore = 0;
                #rank_data{rank_list = RankList} ->
                    {NewRankList, _LimitScore, NewRankServerList, _ServerLimitScore} = get_real_rank(Type, SubType, RankList),
                    PerRankList = lists:reverse(get_type_rank_help(NewRankList)),
                    % ZoneIdA  = lib_clusters_center_api:get_zone(ServerId),
                    % ServerList = mod_zone_mgr:get_zone_server(ZoneIdA),
                    % #zone_base{server_name = ServerName} = ulists:keyfind(ServerId, #zone_base.server_id, ServerList, #zone_base{}),
                    %% TODO
%%                    ServerRankList = [{Rank, NewServerId, ServerNum, ServerName, Score}
%%                        || #rank_server{rank = Rank, server_id = NewServerId, server_num = ServerNum, score = Score} <- NewRankServerList],
                    %% ServerNameList = mod_zone_mgr:get_server_name_list(),
                    ServerRankList = [ {Rank, NewServerId, ServerName, Score} || #rank_server{rank = Rank, server_id = NewServerId, score = Score, server_name = ServerName} <- NewRankServerList],
                    #rank_role{rank = PerRank,score = PerScore} = ulists:keyfind(RoleId, #rank_role.id, RankList, #rank_role{score = 0, rank = 0}),
                    #rank_server{rank = ServerRank,score = ServerScore} = ulists:keyfind(ServerId, #rank_server.server_id, NewRankServerList, #rank_server{score = 0, rank = 0})
            end
    end,
    %?MYLOG("lwcrank","PerRankList, ServerRankList:~p~n",[{PerRankList, ServerRankList}]),
    %?MYLOG("lwcrank","Type, SubType, PerScore, PerRank, PerRankList, ServerScore, ServerRank, ServerRankList:~p~n",[{Type, SubType, PerScore, PerRank, ServerScore, ServerRank}]),
    {ok, Bin} = pt_332:write(33253, [Type, SubType, PerScore, PerRank, PerRankList, ServerScore, ServerRank, ServerRankList]),
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [RoleId, Bin]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 封装个人榜单信息客户端显示
%% @param RankList 玩家榜单角色信息
%% @return NewRankList
%% -----------------------------------------------------------------
get_type_rank_help(RankList) ->
    F = fun(RankRole, PerRankList) ->
        #rank_role{
            id         = RoleId,
            server_num = ServerId,
            rank       = Rank,
            score      = Score,
            figure=#figure{
                name    = Name,
                mask_id = MaskId
            }
        } = RankRole,
        WrapName = lib_player:get_wrap_role_name(Name, [MaskId]),
        [{Rank, ServerId, RoleId, WrapName, Score} | PerRankList]
        end,
    lists:foldl(F, [], RankList).

%% -----------------------------------------------------------------
%% @desc  获得真实上榜的个人榜和区服榜
%% @param Type              活动主类型
%% @param SubType           活动子类型
%% @param RankList          同区玩家排行榜
%% @return {NewRankList, LimitScore, NewRankServerList, ServerLimitScore}
%% -----------------------------------------------------------------
get_real_rank(Type, SubType, RankList) ->
    RewardIdList = data_rush_treasure:get_rank_reward_all_id(Type, SubType, ?PERSON_RANK),
    MaxLength = ?IF(RewardIdList == [], 0, lists:max(RewardIdList)),
    RankListA = [RankRole || #rank_role{rank = Rank} = RankRole <- RankList, Rank =/= 0],
    {NewRankList, LimitScore} = lib_rush_treasure_helper:get_limit_score(RankListA, MaxLength),
    {NewRankServerList, ServerLimitScore} = sort_server_rank(Type, SubType, RankList),
    %?MYLOG("lwcrank","NewRankList:~p~n",[NewRankList]),
    %?MYLOG("lwcrank","NewRankServerList:~p~n",[NewRankServerList]),
    {NewRankList, LimitScore, NewRankServerList, ServerLimitScore}.

%% -----------------------------------------------------------------
%% @desc  获得区服排行榜
%% @param Type     活动主类型
%% @param SubType  活动子类型
%% @param RankList 同区玩家排行榜
%% @return {NewRankServerList, ServerLimitScore}
%% -----------------------------------------------------------------
sort_server_rank(Type, SubType, RankList) ->
    F = fun(RankRole, RankServerListA) ->
        #rank_role{
            server_id  = ServerId,
            score      = Score,
            platform   = PlatForm,
            server_num = ServerNum,
            node       = Node,
            last_time  = LastTime,
            server_name = ServerName
        } = RankRole,
        RankServer = ulists:keyfind(ServerId, #rank_server.server_id, RankServerListA,
            #rank_server{server_id = ServerId, platform = PlatForm, server_num = ServerNum, node = Node, server_name = ServerName}),
        #rank_server{score = OldScore, last_time = OldLastTime, role_list = RoleList} = RankServer,
        NewRankServer = RankServer#rank_server{score = OldScore + Score, last_time = max(OldLastTime, LastTime), role_list = [RankRole | RoleList]},
        lists:keystore(ServerId, #rank_server.server_id, RankServerListA, NewRankServer)
        end,
    RankServerList = lists:foldl(F, [], RankList),
    %% 排序
    RankServerListB = sort_rank_server(RankServerList),
    List = data_rush_treasure:get_rank_reward_all_id(Type, SubType, ?SERVER_RANK),
    MaxLength =  ?IF(List == [], 0, lists:max(List)),
    %% 设置排名
    FA = fun(RankServer, {InitRank, RankListA}) ->
        #rank_server{score=Score} = RankServer,
        case lib_rush_treasure_helper:check_enter_rank(Score,Type,SubType, ?SERVER_RANK) of
            false-> {InitRank, [RankServer#rank_server{rank = 0} | RankListA]};
            {RankMin,_RankMax}->
                ?IF(InitRank>=RankMin,
                    {InitRank + 1, [RankServer#rank_server{rank = InitRank} | RankListA]},
                    {RankMin + 1, [RankServer#rank_server{rank = RankMin} | RankListA]})
        end
         end,
    {_InitRank, RankServerListC} = lists:foldl(FA, {1, []}, RankServerListB),
    lib_rush_treasure_helper:get_server_limit_score(lists:reverse(RankServerListC), MaxLength).

%% -----------------------------------------------------------------
%% @desc 排序区服榜
%% @param RankServerList 同区服务器信息列表
%% @return NewRankServerList
%% -----------------------------------------------------------------
sort_rank_server(RankServerList) ->
    F = fun(ServerA, ServerB)->
        #rank_server{score = ScoreA, last_time = LastTimeA} = ServerA,
        #rank_server{score = ScoreB, last_time = LastTimeB} = ServerB,
        ?IF(ScoreA =:= ScoreB, LastTimeA =< LastTimeB, ScoreA >= ScoreB)
        end,
    lists:sort(F, RankServerList).

%% -----------------------------------------------------------------
%% @desc  冲榜夺宝抽奖
%% @param ServerId 服务器Id
%% @param RoleId   玩家Id
%% @param Type     主类型
%% @param SubType  子类型
%% @param Times    次数
%% @param AutoBuy  是否自动购买
%% @param State    进程State
%% @return {noreply, State}
%% -----------------------------------------------------------------
rush_treasure_draw(ServerId, RoleId, Type, SubType, Times, AutoBuy, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            ZoneEtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
            #ets_main_zone{world_lv = WorldLv} = ulists:keyfind(ZoneId, #ets_main_zone.zone_id, ZoneEtsList, #ets_main_zone{}),
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_rush_treasure_player, rush_treasure_draw, [Type, SubType, Times, WorldLv, AutoBuy]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
            {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc  更新排行榜数据
%% @param Type     主类型
%% @param SubType  子类型
%% @param RankRole 需要更新的玩家榜单记录
%% @return NewState
%% -----------------------------------------------------------------
enter_rank([Type, SubType, RankRole], State) ->
    #rank_status{rush_per_rank = RushPerRank} = State,
    #rank_role{
        id        = RoleId,
        server_id = ServerId,
        figure = #figure{name=Name}
    } = RankRole,
    ZoneId = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
    RankType = lists:keyfind({Type, SubType}, #rank_type.id, RushPerRank),
    % ?MYLOG("lwcrank","ZoneId, ServerId_enter_rank:~p~n",[{ZoneId, ServerId}]),
    if
        ZoneId == false -> NewState = State;
        true ->
            if
                RankType =:= false -> RankDataListA = [#rank_data{id = ZoneId, rank_list = [RankRole]}];
                true ->
                    #rank_type{rank_data = RankDataList} = RankType,
                    RankData = ulists:keyfind(ZoneId, #rank_data.id, RankDataList, #rank_data{id = ZoneId, rank_list = [RankRole]}),
                    #rank_data{rank_list = RankList} = RankData,
                    NewRankList = lists:keystore(RoleId, #rank_role.id, RankList, RankRole),
                    RankDataListA = lists:keystore(ZoneId, #rank_data.id, RankDataList, RankData#rank_data{rank_list = NewRankList})
            end,
            %% 排序
            NRankDataList = sort_type_rank(RankDataListA, Type, SubType),
            NRankType = #rank_type{id = {Type,SubType}, type = Type, subtype = SubType, rank_data = NRankDataList},
            NRankList = lists:keystore({Type, SubType}, #rank_type.id, RushPerRank, NRankType),
            %% 获得最新数据
            NewRankData = ulists:keyfind(ZoneId, #rank_data.id, NRankDataList, #rank_data{id = ZoneId, rank_list = [RankRole]}),
            #rank_role{rank = NewRank, score = NewScore} = NewRankRole= ulists:keyfind(RoleId, #rank_role.id, NewRankData#rank_data.rank_list, RankRole),
            lib_rush_treasure_sql:db_replace_rush_treasure_rank(Type,SubType,NewRankRole),
            {_NewRankListA, _LimitScore, NewRankServerList, _ServerLimitScore} = get_real_rank(Type, SubType, NewRankData#rank_data.rank_list),
            #rank_server{rank = ServerRank, score = ServerScore} = ulists:keyfind(ServerId, #rank_server.server_id, NewRankServerList, #rank_server{}),
            %% 日志
            lib_log_api:log_rush_treasure_rank(RoleId, Name, Type, SubType, ?PERSON_RANK, NewScore, NewRank, ZoneId, ServerId),
            lib_log_api:log_rush_treasure_rank(RoleId, Name, Type, SubType, ?SERVER_RANK, ServerScore, ServerRank, ZoneId, ServerId),
            % ?MYLOG("lwcrank","NRankList_enter_rank:~p~n",[{NRankList, NewRank}]),
            %% 发送最新榜单信息
            NewState = State#rank_status{rush_per_rank = NRankList},
            get_rush_type_rank(Type, SubType, RoleId, ServerId, ServerId, NewState)
    end,
    NewState.

%% -----------------------------------------------------------------
%% @desc  发送传闻
%% @param Type        主类型
%% @param SubType     子类型
%% @param ServerNum   服务器号
%% @param RoleName    角色名
%% @param ActName     活动名
%% @param RealGtypeId 奖励Id
%% @param ServerId    服务器Id
%% @param State       进程State
%% @return
%% -----------------------------------------------------------------
%%send_tv([Type, SubType, ServerNum, RoleName, RoleId, ActName, RealGtypeId, ServerId], State) ->
%%    Zone = lib_rush_treasure_helper:get_zone(Type,SubType,ServerId),
%%    ZoneId = lib_clusters_center_api:get_zone(ServerId),
%%    AllZoneIdList = mod_zone_mgr:get_all_zone_ids(),
%%    case Zone of
%%        ?CUSTOM_ACT_IS_ZONE_NO ->
%%            F = fun(ZoneIdA) ->
%%                AllZoneBaseList = mod_zone_mgr:get_zone_server(ZoneIdA),
%%                Args = [?MOD_AC_CUSTOM, 69, [ServerNum, RoleName, RoleId, ActName, RealGtypeId, Type, SubType]],
%%                [mod_clusters_center:apply_cast(NewServerId, lib_rush_treasure_player, do_send_tv, Args) || #zone_base{server_id = NewServerId} <- AllZoneBaseList]
%%                end,
%%            lists:foreach(F, AllZoneIdList);
%%        _ ->
%%            AllZoneBaseList = mod_zone_mgr:get_zone_server(ZoneId),
%%            Args = [?MOD_AC_CUSTOM, 69, [ServerNum, RoleName, RoleId, ActName, RealGtypeId, Type, SubType]],
%%            [mod_clusters_center:apply_cast(NewServerId, lib_rush_treasure_player, do_send_tv, Args) || #zone_base{server_id = NewServerId} <- AllZoneBaseList]
%%    end,
%%    State.

%% 优化旧版本发送传闻的方式
send_tv([Type, SubType, ServerNum, RoleName, RoleId, ActName, RealGtypeId, ServerId], State) ->
    Zone = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
    TvArgs = [?MOD_AC_CUSTOM, 69, [ServerNum, RoleName, RoleId, ActName, RealGtypeId, Type, SubType]],
    case Zone of
        ?CUSTOM_ACT_IS_ZONE_NO ->
            mod_zone_mgr:rush_treasure_no_zone_tv(TvArgs);
        _ ->
            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, Zone, lib_rush_treasure_player, do_send_tv, TvArgs)
    end,
    State.

send_tv_act_is_zone_no(TvArgs, AllZoneIdList) ->
    F = fun(ZoneId) ->
        mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_rush_treasure_player, do_send_tv, TvArgs)
    end,
    lists:foreach(F, AllZoneIdList).

%% -----------------------------------------------------------------
%% @desc  获得阶段奖励
%% @param ServerId 服务器Id
%% @param RoleId   角色Id
%% @param Type     主类型
%% @param SubType  子类型
%% @param RewardId 奖励Id
%% @param State    进程State
%% @return {noreply, State}
%% -----------------------------------------------------------------
get_stage_reward(ServerId, RoleId, Type, SubType, RewardId, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 -> {noreply, State};
        ZoneId ->
            ZoneEtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
            #ets_main_zone{world_lv = WorldLv} = ulists:keyfind(ZoneId, #ets_main_zone.zone_id, ZoneEtsList, #ets_main_zone{}),
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_rush_treasure_player, get_stage_reward, [Type, SubType, RewardId, WorldLv]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
            {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc  活动结束派发排行榜奖励
%% @param Type        主类型
%% @param SubType     子类型
%% @param ServerId    服务器Id
%% @param State       进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
act_end(Type, SubType, ServerId, State) ->
    #rank_status{rush_per_rank = RushPerRank} = State,
    RankType = lists:keyfind({Type, SubType}, #rank_type.id, RushPerRank),
    if
        RankType =:= false -> {noreply, State};
        true ->
            #rank_type{rank_data = DataList} = RankType,
            NewRankData = send_rank_reward(DataList, Type, SubType, ServerId),
            NewRankType = RankType#rank_type{rank_data = NewRankData},
            %% 更新内存数据
            NewRushPerRank = lists:keystore({Type, SubType}, #rank_type.id, RushPerRank, NewRankType),
            %% 删除榜单数据
            lib_rush_treasure_sql:db_delete_rush_treasure_rank(Type, SubType, ServerId),
            {noreply, State#rank_status{rush_per_rank = NewRushPerRank}}
    end.

%% -----------------------------------------------------------------
%% @desc  发送榜单奖励
%% @param DataList 排行数据列表
%% @param Type     主类型
%% @param SubType  子类型
%% @param ServerId 服务器Id
%% @return
%% -----------------------------------------------------------------
send_rank_reward(DataList, Type, SubType, ServerId) ->
    ZoneId = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
    ZoneEtsList = ets:tab2list(lib_zone:ets_main_zone_name(?ZONE_TYPE_1)),
    #ets_main_zone{world_lv = WorldLv} = ulists:keyfind(ZoneId, #ets_main_zone.zone_id, ZoneEtsList, #ets_main_zone{}),
    #rank_data{rank_list = RankList} = RankData = ulists:keyfind(ZoneId, #rank_data.id, DataList, #zone_base{}),
    {NewRankListA, _LimitScore, NewRankServerList, _ServerLimitScore} = get_real_rank(Type, SubType, RankList),
    FA = fun(RankServer) ->
        #rank_server{
            server_id = ServerIdA,
            rank      = Rank,
            role_list = RoleList,
            score = ServerScore
        } = RankServer,
        #custom_act_cfg{condition = Condition} = data_custom_act:get_act_info(Type, SubType),
        {target, Target} = ulists:keyfind(target, 1, Condition, {target, 10000}),
        [begin
        % ?MYLOG("lwcrank_end","RoleIdS:~p~n",[RoleId]),
             RewardId = data_rush_treasure:get_rank_reward_id(Type, SubType, ?SERVER_RANK, Rank),
             lib_log_api:log_rush_treasure_rank(RoleId, Name, Type, SubType, ?SERVER_RANK, ServerScore, Rank, ZoneId, ServerId),
             #base_rush_treasure_rank_reward{reward = Reward} = data_rush_treasure:get_rank_reward(Type, SubType, ?SERVER_RANK, RewardId),
             %% 日志
             lib_log_api:log_rush_treasure_rank_reward(RoleId, Name, ZoneId, ServerIdA, Type, ?SERVER_RANK, SubType, Score, Rank, Reward, WorldLv),
             mod_clusters_center:apply_cast(Node, ?MODULE, server_rank_reward, [Type, SubType, RoleId, Rank, Reward])
         end
            || #rank_role{id = RoleId, score = Score, node = Node, figure=#figure{name = Name}} <- RoleList, Score >= Target andalso ServerIdA =:= ServerId]
         end,
    %% 发送区服榜奖励
    lists:foreach(FA, NewRankServerList),
    FB = fun(RankRole, RankListA) ->
        #rank_role{
            rank      = Rank,
            id        = RoleId,
            node      = Node,
            server_id = ServerIdB,
            score     = Score,
            figure=#figure{name = Name}
        } = RankRole,
        if
            ServerIdB =:= ServerId ->
                RewardId = data_rush_treasure:get_rank_reward_id(Type, SubType, ?PERSON_RANK, Rank),
                lib_log_api:log_rush_treasure_rank(RoleId, Name, Type, SubType, ?PERSON_RANK, Score, Rank, ZoneId, ServerId),
                #base_rush_treasure_rank_reward{reward = Reward} = data_rush_treasure:get_rank_reward(Type, SubType, ?PERSON_RANK, RewardId),
                % ?MYLOG("lwcrank_end","RoleIdP:~p~n",[RoleId]),
                %% 日志
                lib_log_api:log_rush_treasure_rank_reward(RoleId, Name, ZoneId, ServerIdB, Type, ?PERSON_RANK, SubType, Score, Rank, Reward, WorldLv),
                mod_clusters_center:apply_cast(Node, ?MODULE, per_rank_reward, [Type, SubType, RoleId, Rank,Reward]),
                RankListA;
            true -> [RankRole | RankListA]
        end
         end,
    %% 发送个人榜奖励
    NewRankListB = lists:foldl(FB, [], NewRankListA),
    NewRankData = RankData#rank_data{rank_list = NewRankListB},
    lists:keystore(ZoneId, #rank_data.id, DataList, NewRankData).

%% -----------------------------------------------------------------
%% @desc  发送个人榜单奖励
%% @param Type     主类型
%% @param SubType  子类型
%% @param RoleId   玩家Id
%% @param Rank     排名
%% @param Reward   奖励
%% @return
%% -----------------------------------------------------------------
per_rank_reward(Type, SubType, RoleId, Rank, Reward) ->
    #custom_act_cfg{name = Name} = data_custom_act:get_act_info(Type, SubType),
    Title = utext:get(3310105, [Name]),
    Content = utext:get(3310106, [Name, Rank]),
    mod_mail_queue:add({Type, SubType}, [RoleId], Title, Content, Reward).

%% -----------------------------------------------------------------
%% @desc  发送区服榜单奖励
%% @param Type     主类型
%% @param SubType  子类型
%% @param RoleId   玩家Id
%% @param Rank     排名
%% @param Reward   奖励
%% @return
%% -----------------------------------------------------------------
server_rank_reward(Type, SubType, RoleId, Rank, Reward) ->
    #custom_act_cfg{name = Name} = data_custom_act:get_act_info(Type, SubType),
    Title = utext:get(3310107, [Name]),
    Content = utext:get(3310108, [Name, Rank]),
    mod_mail_queue:add({Type, SubType}, [RoleId], Title, Content, Reward).

%% -----------------------------------------------------------------
%% @desc  区Id改变时更新排行榜
%% @param ServerId    服务器Id
%% @param OldZone     旧的区域Id
%% @param NewZone     新的区域Id
%% @param State       进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
rush_zone_change(ServerId, OldZone, NewZone, State) ->
    #rank_status{rush_per_rank = RushPerRank} = State,
    F = fun(RankType, RushPerRankA) ->
        #rank_type{type = Type, subtype = SubType, rank_data = DataList} = RankType,
        #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
        {is_zone, IsZone} = ulists:keyfind(is_zone, 1, Condition, {is_zone, false}),
        case IsZone =:= ?CUSTOM_ACT_IS_ZONE_YES of
            false -> [RankType | RushPerRankA];
            true ->
                case lists:keyfind(OldZone,#rank_data.id,DataList) of
                    false -> [RankType | RushPerRankA];
                    #rank_data{rank_list = OZoneList} = OZoneData ->
                        {OZoneListA,ChangeRole} = zone_data_change(OZoneList, ServerId, [], []),
                        case length(ChangeRole) =:= 0 of
                            true -> [RankType | RushPerRankA];
                            false ->
                                case length(OZoneListA) =:= 0 of
                                    true -> NewDataListA = lists:keydelete(OldZone,#rank_data.id,DataList);
                                    false ->
                                        NOZoneData = OZoneData#rank_data{rank_list=OZoneListA},
                                        NewDataListA = lists:keystore(OldZone,#rank_data.id,DataList,NOZoneData)
                                end,
                                case lists:keyfind(NewZone, #rank_data.id, DataList) of
                                    false -> NZoneListA = ChangeRole;
                                    #rank_data{rank_list = NZoneList}->
                                        NZoneListA = NZoneList++ChangeRole
                                end,
                                NNZoneData = #rank_data{id = NewZone, rank_list = NZoneListA},
                                NewDataListB = lists:keystore(NewZone,#rank_data.id, NewDataListA, NNZoneData),
                                NewDataListC = sort_type_rank(NewDataListB, Type, SubType),
                                NRankType = RankType#rank_type{rank_data = NewDataListC},
                                [NRankType | RushPerRankA]
                        end
                end
        end
        end,
    NewRushPerRank = lists:foldl(F, [], RushPerRank),
    {noreply, State#rank_status{rush_per_rank = NewRushPerRank}}.

%% -----------------------------------------------------------------
%% @desc  服信息改变
%% @param ServerId
%% @param KVList
%% @param State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
server_info_change(ServerId, KVList, State) ->
    {server_name, ServerName} = ulists:keyfind(server_name, 1, KVList, {server_name, false}),
    #rank_status{rush_per_rank = RushPerRank} = State,
    FA = fun(RankPreType, TempRushPerRank) ->
        #rank_type{type = Type, subtype = SubType, rank_data = RankDataList} = RankPreType,
        ZoneId = lib_rush_treasure_helper:get_zone(Type, SubType, ServerId),
        FB = fun(RankData, TempRankDataList) ->
            #rank_data{id = TempZoneId, rank_list = RankList} = RankData,
            case TempZoneId =:= ZoneId of
                false ->
                    [RankData | TempRankDataList];
                true ->
                    FC = fun(Rank, {TempRankList, TempUpdateRankList}) ->
                        #rank_role{server_id = TempServerId} = Rank,
                        case ServerId =:= TempServerId of
                            false ->
                                {[Rank | TempRankList], TempUpdateRankList};
                            true ->
                                NewRank = ?IF( ServerName == false, Rank, Rank#rank_role{server_name = ServerName}),
                                {[NewRank | TempRankList], [{Type, SubType, NewRank} | TempUpdateRankList]}
                        end
                    end,
                    {NewRankList, UpdateRankList} = lists:foldl(FC, {[], []}, RankList),
                    NewRankData = RankData#rank_data{rank_list = NewRankList},
                    lib_rush_treasure_sql:db_batch_replace_rush_treasure_rank(UpdateRankList),
                    [NewRankData | TempRankDataList]
            end
        end,
        NewRankDataList = lists:foldl(FB, [], RankDataList),
        NewRankPreType = RankPreType#rank_type{rank_data = NewRankDataList},
        [NewRankPreType | TempRushPerRank]
    end,
    case ServerName == false of
        true ->
            NewState = State;
        _ ->
            NewRushPerRank = lists:foldl(FA, [], RushPerRank),
            NewState = State#rank_status{rush_per_rank = NewRushPerRank}
    end,
    %?MYLOG("lwctest","{State,NewState}:~p~n",[{State, NewState}]),
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 分类出变化的服务器Id
%% @param
%% @return
%% -----------------------------------------------------------------
zone_data_change([], _ServerId, RList, ChangeRole)-> {RList, ChangeRole};
zone_data_change([#rank_role{server_id = ServerId} = RankRole | T], ServerId, RList, ChangeRole)->
    zone_data_change(T, ServerId, RList, [RankRole | ChangeRole]);
zone_data_change([RankRole | T], ServerId, RList, ChangeRole)->
    zone_data_change(T, ServerId, [RankRole | RList] ,ChangeRole).

%% -----------------------------------------------------------------
%% @desc 活动结束秘籍
%% @param
%% @return
%% -----------------------------------------------------------------
gm_act_end(Type, SubType, _State) ->
    AllZoneIdList = mod_zone_mgr:get_all_zone_ids(),  %% 秘籍调用，不进行优化处理
    % ?MYLOG("lwcrank_end", "AllZoneIdList:~p~n", [AllZoneIdList]),
    F = fun(ZoneIdA) ->
        AllZoneBaseList = mod_zone_mgr:get_zone_server(ZoneIdA), %% 秘籍调用，不进行优化处理
        % ?MYLOG("lwcrank_end", "AllZoneBaseList:~p~n", [AllZoneBaseList]),
        [mod_clusters_center:apply_cast(NewServerId, lib_rush_treasure_api, act_end, [Type, SubType])
            || #zone_base{server_id = NewServerId} <- AllZoneBaseList]
        end,
    lists:foreach(F, AllZoneIdList).