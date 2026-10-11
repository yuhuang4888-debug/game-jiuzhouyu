%% ---------------------------------------------------------------------------
%% @doc mod_enchantment_guard_rank

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/3/22
%% @desc    推关排行榜，跨服进程数据
%% ---------------------------------------------------------------------------
-module(mod_enchantment_guard_rank).

-behaviour(gen_server).

%% API
-export([
    start_link/0,
    sync_zone_group/1,
    update_rank_list/1,
    init_game_node_list/2,
    center_connected/1
]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-export([
    dup_rank_player/1
]).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("clusters.hrl").
-include("enchantment_guard.hrl").

-record(state, {
    zone_server_map = #{}           %% 分区服务器信息 #{ZoneId => ServerList}
    , zone_group_servers_map = #{}  %% #{ZoneId => #{GroupId => ServerIdL}}
    , zone_server_group_map = #{}   %% 分区服务器分组信息 #{ZoneId => #{ServerId => GroupId}}
    , zone_group_rank_info = #{}    %% 分区分组的排行榜信息#{ZoneId => #{GroupId => #state_rank_info{} } }
}).

-record(state_rank_info, {
    rank = []
}).

-define(sql_select_rank, <<"select `zone_id`, `role_id`, `role_name`, `group_id`, `server_id`, `server_num`, `rank`,
        `gate`, `last_time`, `rank_combat` from `player_enchantment_guard_rank`">>).
-define(sql_truncate_rank, <<"truncate table `player_enchantment_guard_rank`">>).
-define(sql_delete_rank_by_group, <<"delete from `player_enchantment_guard_rank` where `zone_id` = ~p and `group_id` = ~p">>).
-define(sql_replace_rank, <<"replace into `player_enchantment_guard_rank` (`zone_id`, `role_id`, `role_name`, `group_id`,
    `server_id`, `server_num`, `rank`, `gate`, `last_time`, `rank_combat`) value (~p,~p,'~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

sync_zone_group(InfoList) ->
    gen_server:cast(?MODULE, {'sync_zone_group', InfoList}).

update_rank_list(RankInfo) ->
    gen_server:cast(?MODULE, {'update_rank_list', RankInfo}).

init_game_node_list(SerId, RankList) ->
    gen_server:cast(?MODULE, {'init_game_node_list', SerId, RankList}).

center_connected(ServerId) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId}).
%% 去除榜单上重复的玩家
dup_rank_player(ServerId) ->
    gen_server:cast(?MODULE, {'dup_rank_player', ServerId}).    

%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

%% =============================
%% gen_server callbacks
%% =============================

do_init([]) ->
    List = db:get_all(?sql_select_rank),
    F = fun([ZoneId, RoleId, RoleName, GroupId, ServerId, ServerNum, Rank, Gate, LastTime, RankCombat], AccMap) ->
        GroupRankMap = maps:get(ZoneId, AccMap, #{}),
        RankInfo = #state_rank_info{rank = RankL} = maps:get(GroupId, GroupRankMap, #state_rank_info{}),
        NewRankL = [#enchantment_role_rank{
            role_id = RoleId, server_id = ServerId, combat = RankCombat,
            server_num = ServerNum, role_name = RoleName,
            rank = Rank, gate = Gate, last_time = LastTime }|RankL],
        NewGroupRankMap = GroupRankMap#{GroupId => RankInfo#state_rank_info{rank = NewRankL}},
        AccMap#{ZoneId => NewGroupRankMap}
    end,
    ZoneGroupRank = lists:foldl(F, #{}, List),
    {ok, #state{zone_group_rank_info = ZoneGroupRank}}.

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'sync_zone_group', InfoList}, State) ->
    #state{
        zone_group_servers_map = OZoneGroupServerLMap,
        zone_group_rank_info = ZoneGroupRank
    } = State,
    F = fun({ZoneId, {Servers, GroupInfo}}, {AccZoneServerGroupMap, AccZoneGroupServerLMap, AccZSMap}) ->
        NewAccZSMap = AccZSMap#{ZoneId => Servers},
        #zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
        F2 = fun(ModGroupData, {AccMap1, AccMap2}) ->
            #zone_mod_group_data{group_id = GroupId, mod = Mod, server_ids = ServerIds} = ModGroupData,
            [mod_clusters_center:apply_cast(SerId, mod_enchantment_guard_rank_local, update_info, [[{mod, Mod}]])||SerId<-ServerIds],
            NewAccMap1 = maps:merge(maps:from_list([{SerId, GroupId}||SerId<-ServerIds]), AccMap1),
            NewAccMap2 = AccMap2#{GroupId => ServerIds},
            {NewAccMap1, NewAccMap2}
        end,
        {ServerGroupMap, GroupServerLMap} = lists:foldl(F2, {#{}, #{}}, GroupModServers),
        NewAccZoneServerGroupMap = AccZoneServerGroupMap#{ZoneId => ServerGroupMap},
        NewAccZoneGroupServerLMap = AccZoneGroupServerLMap#{ZoneId => GroupServerLMap},
        {NewAccZoneServerGroupMap, NewAccZoneGroupServerLMap, NewAccZSMap}
    end,
    {ZoneServerGroupMap, ZoneGroupServerLMap, ZoneServerMap} = lists:foldl(F, {#{}, #{}, #{}}, InfoList),

    NewZoneGroupRank = combine_group_rank_info(ZoneGroupRank, OZoneGroupServerLMap, ZoneGroupServerLMap),
    NewState = State#state{
        zone_server_group_map = ZoneServerGroupMap,
        zone_group_servers_map = ZoneGroupServerLMap,
        zone_server_map = ZoneServerMap,
        zone_group_rank_info = NewZoneGroupRank
    },
    {noreply, NewState};

do_handle_cast({'update_rank_list', RankInfo}, State) ->
    #enchantment_role_rank{server_id = ServerId, gate = Gate, role_id = RoleId} = RankInfo,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {StateRankInfo, GroupId} = get_rank_info(State, ZoneId, ServerId),
    #state_rank_info{rank = RankList} = StateRankInfo,
    case erlang:length(RankList) >= ?RANK_LIMIT_NUM of
        true ->
            case lists:reverse(RankList) of
                [#enchantment_role_rank{gate = MinGate}|_] when Gate > MinGate -> IsUpd = true;
                [] -> IsUpd = true;
                _ -> IsUpd = false
            end;
        _ ->
            IsUpd = true
    end,
    if
        IsUpd ->
            NewRankList = [RankInfo|lists:keydelete(RoleId, #enchantment_role_rank.role_id, RankList)],
            LastRankList = lib_enchantment_guard:sort_rank(NewRankList),
            NewRankInfo = ulists:keyfind(RoleId, #enchantment_role_rank.role_id, LastRankList, #enchantment_role_rank{}),
            persistence_one_rank(ZoneId, GroupId, NewRankInfo),
            CombineServerIds = get_combine_server_ids(State, ZoneId, GroupId),
            [mod_clusters_center:apply_cast(SerId, mod_enchantment_guard_rank_local, update_info, [[{update_rank_list, NewRankInfo}]])
                ||SerId<-CombineServerIds],
            NewStateRankInfo = StateRankInfo#state_rank_info{rank = LastRankList},
            NewState = save_rank_info(State, ZoneId, ServerId, NewStateRankInfo);
        true ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_cast({'init_game_node_list', ServerId, GameRankList}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {StateRankInfo, GroupId} = get_rank_info(State, ZoneId, ServerId),
    #state_rank_info{rank = RankList} = StateRankInfo,
    DupFun = fun(#enchantment_role_rank{ role_id = RoleId } = I, AccL) ->
        lists:keystore(RoleId, #enchantment_role_rank.role_id, AccL, I)
    end,
    NewRankList = lists:foldl(DupFun, RankList, GameRankList),    
    LastRankList = lib_enchantment_guard:sort_rank(NewRankList),    
    db:execute(io_lib:format(?sql_delete_rank_by_group, [ZoneId, GroupId])),
    InsertParams = [[ZoneId, RoleId, RoleName, GroupId, SerId, SerNum, Rank, Gate, Time, RankCombat]||#enchantment_role_rank{
        role_id = RoleId, role_name = RoleName, server_id = SerId, combat = RankCombat,
        server_num = SerNum, rank = Rank, gate = Gate, last_time = Time
    }<-LastRankList],
    CombineServerIds = get_combine_server_ids(State, ZoneId, GroupId),
    [mod_clusters_center:apply_cast(SerId, mod_enchantment_guard_rank_local, update_info, [[{rank_list, LastRankList}]])||SerId<-CombineServerIds],
    persistence_all_rank_no_delay(InsertParams),
    NewStateRankInfo = StateRankInfo#state_rank_info{rank = LastRankList},
    NewState = save_rank_info(State, ZoneId, ServerId, NewStateRankInfo),
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {StateRankInfo, GroupId} = get_rank_info(State, ZoneId, ServerId),
    <<_:8, Mod:4, _:4>> = <<GroupId:16>>,
    case Mod == 1 orelse Mod == 0 of
        true ->
            skip;
        _ ->
            #state_rank_info{rank = RankList} = StateRankInfo,
            mod_clusters_center:apply_cast(ServerId, mod_enchantment_guard_rank_local, update_info, [[{mod, Mod},{rank_list, RankList}]])
    end,
    {noreply, State};
do_handle_cast({'dup_rank_player', ServerId}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {StateRankInfo, GroupId} = get_rank_info(State, ZoneId, ServerId),
    #state_rank_info{rank = RankList} = StateRankInfo,
    DupFun = fun(#enchantment_role_rank{ role_id = RoleId } = I, AccL) ->
        lists:keystore(RoleId, #enchantment_role_rank.role_id, AccL, I)
    end,
    NewRankList = lists:foldl(DupFun, [], RankList),
    LastRankList = lib_enchantment_guard:sort_rank(NewRankList),
    CombineServerIds = get_combine_server_ids(State, ZoneId, GroupId),
    [mod_clusters_center:apply_cast(SerId, mod_enchantment_guard_rank_local, update_info, [[{rank_list, LastRankList}]])||SerId<-CombineServerIds],
    NewStateRankInfo = StateRankInfo#state_rank_info{rank = LastRankList},
    NewState = save_rank_info(State, ZoneId, ServerId, NewStateRankInfo),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, _State) ->
    {noreply, _State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 获取榜单信息
get_rank_info(State, ZoneId, ServerId) ->
    #state{zone_server_group_map = ZoneServerGroupMap, zone_group_rank_info = ZoneGroupRankInfo} = State,
    ServerGroupMap = maps:get(ZoneId, ZoneServerGroupMap, #{}),
    GroupId = maps:get(ServerId, ServerGroupMap, 0),
    GroupRankInfoMap = maps:get(ZoneId, ZoneGroupRankInfo, #{}),
    {maps:get(GroupId, GroupRankInfoMap, #state_rank_info{}), GroupId}.

%% 保存榜单信息
save_rank_info(State, ZoneId, ServerId, RankInfo) ->
    #state{zone_server_group_map = ZoneServerGroupMap, zone_group_rank_info = ZoneGroupRankInfo} = State,
    ServerGroupMap = maps:get(ZoneId, ZoneServerGroupMap, #{}),
    GroupId = maps:get(ServerId, ServerGroupMap, 0),
    GroupRankInfoMap = maps:get(ZoneId, ZoneGroupRankInfo, #{}),
    NewGroupRankInfoMap = GroupRankInfoMap#{GroupId => RankInfo},
    NewZoneGroupRankInfo = ZoneGroupRankInfo#{ZoneId => NewGroupRankInfoMap},
    State#state{zone_group_rank_info = NewZoneGroupRankInfo}.

%% 获取分组关联的服务器列表
get_combine_server_ids(State, ZoneId, GroupId) ->
    #state{zone_group_servers_map = ZoneGroupServersMap} = State,
    GroupServersMap = maps:get(ZoneId, ZoneGroupServersMap, #{}),
    maps:get(GroupId, GroupServersMap, []).


%% 处理排行榜
%% 248跨服进度修改之后，原本排行榜的数据也需要变动
combine_group_rank_info(ZoneGroupRank, ZoneGroupServerLMap, ZoneGroupServerLMap) -> ZoneGroupRank;
combine_group_rank_info(ZoneGroupRank, _OZoneGroupServerLMap, ZoneGroupServerLMap) ->
    db:execute(?sql_truncate_rank),
    F = fun(ZoneId, GroupRankMap, {AccMap, AccParams}) ->
        GroupServerLMap = maps:get(ZoneId, ZoneGroupServerLMap, #{}),
        {NewGroupRankMap, InsertParams} = combine_group_rank_info_core(ZoneId, GroupRankMap, GroupServerLMap),
        NewAccMap = AccMap#{ZoneId => NewGroupRankMap},
        NewAccParams = InsertParams ++ AccParams,
        {NewAccMap, NewAccParams}
    end,
    {NewZoneGroupRank, AllInsertParams} = maps:fold(F, {#{}, []}, ZoneGroupRank),
    persistence_all_rank(AllInsertParams),
    NewZoneGroupRank.

combine_group_rank_info_core(ZoneId, GroupRankMap, GroupServerLMap) ->
    % 获取#{ServerId => RankL}
    F1 = fun(_GroupId, #state_rank_info{rank = RankL}, AccServerRankL) ->
        ServerRankLMap = ulists:group(#enchantment_role_rank.server_id, RankL),
        maps:merge(ServerRankLMap, AccServerRankL)
    end,
    ServerRankLMap = maps:fold(F1, #{}, GroupRankMap),
    % 根据分组的变动重新组成 NewGroupRankMap
    F2 = fun(GroupId, ServerIdL, {AccMap, AccParams}) ->
        GroupRankL = lists:flatten([maps:get(SerId, ServerRankLMap, [])||SerId<-ServerIdL]),
        SortRankL = lib_enchantment_guard:sort_rank(GroupRankL),
        [mod_clusters_center:apply_cast(SerId, mod_enchantment_guard_rank_local, update_info, [[{rank_list, SortRankL}]])||SerId<-ServerIdL],
        InsertParams = [[ZoneId, RoleId, RoleName, GroupId, SerId, SerNum, Rank, Gate, Time, RankCombat]|| #enchantment_role_rank{
            role_id = RoleId, role_name = RoleName, server_id = SerId, combat = RankCombat,
            server_num = SerNum, rank = Rank, gate = Gate, last_time = Time
        }<-SortRankL],
        NewAccMap = AccMap#{GroupId => #state_rank_info{rank = SortRankL}},
        NewAccParams = InsertParams ++ AccParams,
        {NewAccMap, NewAccParams}
    end,
    maps:fold(F2, {#{}, []}, GroupServerLMap).

persistence_all_rank_no_delay(InsertRankParams) ->
    Sql = usql:replace(player_enchantment_guard_rank,
        [zone_id, role_id, role_name, group_id, server_id, server_num, rank, gate, last_time, rank_combat], InsertRankParams),
    Sql =/= [] andalso db:execute(Sql).
%% 持久化榜单数据,4点时调用，防止mysql进程超时，延时调用
persistence_all_rank(InsertRankParams) ->
    SplitParams = ulists:split_stable_num_list(InsertRankParams, 200),
    spawn(fun() -> timer:sleep(urand:rand(1, 10) * 1000), do_persistence_all_rank(SplitParams) end).
do_persistence_all_rank([]) -> ok;
do_persistence_all_rank([Params|H]) ->
    Sql = usql:insert(player_enchantment_guard_rank, [zone_id, role_id, role_name, group_id, server_id, server_num, rank, gate, last_time, rank_combat], Params),
    Sql =/= [] andalso db:execute(Sql),
    timer:sleep(100),
    do_persistence_all_rank(H).

persistence_one_rank(ZoneId, GroupId, RankInfo) ->
    #enchantment_role_rank{
        role_id = RoleId,
        server_id = SerId,
        server_num = SerNum,
        role_name = RoleName,
        rank = Rank,
        gate = Gate,
        last_time = Time,
        combat = HighCombat
    } = RankInfo,
    case RoleId == 0 of
        true -> skip;
        _ ->
            Sql = io_lib:format(?sql_replace_rank, [ZoneId, RoleId, RoleName, GroupId, SerId, SerNum, Rank, Gate, Time, HighCombat]),
            db:execute(Sql)
    end.

