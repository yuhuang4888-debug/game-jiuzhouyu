%% ---------------------------------------------------------------------------
%% @doc mod_zone_group

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/7/21 0021
%% @deNextcated  集群-游戏分区-分组管理器# 分区基础上根据开服天数与世界等级分组
%% ---------------------------------------------------------------------------
-module(mod_zone_mod).

-behaviour(gen_server).

%% API
-export([
      start_link/0
    , gm_reset/0
    , calc_zone_mod/1
    , sync_mod_wordlv/1
    , gm_zone_change/4
    , gm_recalc_all_specific/1
    , gm_fallback_mod/0
    , center_connected/2
]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    calc_zones_avg_lv/1
]).

-include("common.hrl").
-include("clusters.hrl").
-include("server.hrl").
-include("def_gen_server.hrl").
-include("def_fun.hrl").
-include("chat.hrl").
-include("def_module.hrl").

% 分组条件
%-define(ZONE_MOD_CONDITION, [{?ZONE_MOD_8, 371, 20}, {?ZONE_MOD_4, 331, 10}, {?ZONE_MOD_2, 301, 6}]).
-define(ZONE_MOD_CONDITION, data_key_value:get(8)).

-record(state, {
      server_last_mods = #{}    %% #{{SerId, ModuleId} => Mod}
    , zone_mod_map = #{}        %% #{zone_id => #zone_mod_data{}}
    , server_zone_map = #{}     %% #{SerId => #zone_base{}}
    , zone_server_list_map = #{}%% #{zone_id => [#zone_base{}]}
}).

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

gm_reset() ->
    gen_server:cast(?MODULE, 'gm_reset').

% 计算分区分组
calc_zone_mod(ZonesMap) ->
    #zone_data{zones = AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap, #zone_data{}),
    gen_server:cast(?MODULE, {'calc_zone_mod', AllZones}).

%% 同步世界等级#不会分区
sync_mod_wordlv(_ZonesMap) -> ok.
    % #zone_data{zones = AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap, #zone_data{}),
    % gen_server:cast(?MODULE, {'sync_mod_wordlv', AllZones}).

% gm使分区改变，重新计算分组情况
% 运营指定某个区更改分区，会对OldZone NewZone两个分区的服重新分组，并通知对应功能
gm_zone_change(ZonesMap, ServerId, OldZone, NewZone) ->
    #zone_data{zones = AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap, #zone_data{}),
    gen_server:cast(?MODULE, {'gm_zone_change', AllZones, ServerId, OldZone, NewZone}).

%% 运营批量修改服务器的分区信息
%% 改函数执行一般不会再活动期间（248的活动，已和运营商量好）
%% 直接执行重新分服逻辑即可
gm_recalc_all_specific(ZonesMap) ->
    #zone_data{zones = AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap, #zone_data{}),
    gen_server:cast(?MODULE, {'calc_zone_mod', AllZones}).

gm_fallback_mod() ->
    AllZone = mod_zone_mgr:get_all_zone(),
    F = fun(#zone_base{time = Time, server_id = ServerId}, AccParam) ->
        OpenDay = get_server_open_day(Time),
        ModuleIdL = data_zone_mod:get_module_list(),
        F2 = fun(ModuleId, Acc) ->
            CfgL = data_zone_mod:get_mod_cfg_list(ModuleId),
            F3 = fun({Mod, _, _, NeedDay}, AccMod) when OpenDay >= NeedDay -> max(AccMod, Mod);
                ({_, _, _, _}, AccMod) -> AccMod
            end,
            Mod = lists:foldl(F3, 1, CfgL),
            [[ModuleId, ServerId, Mod]|Acc]
        end,
        lists:foldl(F2, AccParam, ModuleIdL)
    end,
    Params = lists:foldl(F, [], AllZone),
    db:execute("truncate table server_zone_mod"),
    Sql = usql:insert(server_zone_mod, [module_id, server_id, last_mod], Params),
    Sql =/= [] andalso db:execute(Sql),
    gen_server:cast(?MODULE, {'re_init', AllZone}).

% 获取游戏服的分区分组
center_connected(ServerId, MergeSerIds) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    gen_server:cast(?MODULE, {'center_connected', ZoneId, ServerId, MergeSerIds}).


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
    ModList = db:get_all(<<"select module_id, server_id, last_mod from server_zone_mod">>),
    SerModMap = maps:from_list([{{ModuleId, SerId}, Mod}||[ModuleId, SerId, Mod]<-ModList]),
    InitState = #state{server_last_mods = SerModMap},
    AllZoneBases = mod_zone_mgr:get_all_zone(),
    spawn(fun() -> timer:sleep(30000), gen_server:cast(mod_zone_mod, {'calc_zone_mod', AllZoneBases}) end ),
    %{_, State} = do_handle_cast({'calc_zone_mod', AllZoneBases}, InitState),
    {ok, InitState}.

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'re_init', AllZone}, _State) ->
    ModList = db:get_all(<<"select module_id, server_id, last_mod from server_zone_mod">>),
    SerModMap = maps:from_list([{{ModuleId, SerId}, Mod}||[ModuleId, SerId, Mod]<-ModList]),
    InitState = #state{server_last_mods = SerModMap},
    do_handle_cast({'calc_zone_mod', AllZone}, InitState);

do_handle_cast('gm_reset', State) ->
    db:execute(<<"truncate table server_zone_mod">>),
    mod_zone_mgr:calc_zone_mod(),
    {noreply, State#state{server_last_mods = #{}}};

do_handle_cast({'calc_zone_mod', AllZoneBases}, State) ->
    #state{server_last_mods = SerModMap} = State,
    {ZoneServerLMap, ServerBaseMap} = calc_zone_server_map(AllZoneBases),
    {NewSerModMap, ZoneModMap} = calc_zone_mod_core(ZoneServerLMap, SerModMap),
    % ?PRINT("ZoneModMap ~p ~n", [ZoneModMap]),
    calc_zone_mod_event(ZoneModMap),
    %?PRINT("Z2SMap ~p ~n NewSerModMap ~p ZoneModMap ~p ~n", [Z2SMap, NewSerModMap, ZoneModMap]),
    ReplaceParams = [[ModuleId, SerId, LastMod]||{{ModuleId, SerId}, LastMod}<-maps:to_list(NewSerModMap)],
    Sql = usql:replace(server_zone_mod, [module_id, server_id, last_mod], ReplaceParams),
    Sql =/= [] andalso db:execute(Sql),
    NewState = State#state{
        server_last_mods = NewSerModMap, zone_mod_map = ZoneModMap,
        server_zone_map = ServerBaseMap, zone_server_list_map = ZoneServerLMap
    },
    {noreply, NewState};

do_handle_cast({'gm_zone_change', AllZoneBases, ChangeServerId, OldZone, NewZone}, State) ->
    #state{server_last_mods = SerModMap, zone_mod_map = ZoneModMap} = State,
    {Z2SMap, ServerBaseMap} = calc_zone_server_map(AllZoneBases),
    ZoneBases1 = maps:get(OldZone, Z2SMap),
    ZoneBases2 = maps:get(NewZone, Z2SMap),

    {SerModMap1, ZoneModMap1} = calc_zone_mod_core([{OldZone, ZoneBases1}], SerModMap, ZoneModMap, SerModMap),
    {NewSerModMap, NewZoneModMap} = calc_zone_mod_core([{NewZone, ZoneBases2}], SerModMap1, ZoneModMap1, SerModMap1),

    zone_change_event(NewZoneModMap, ChangeServerId, OldZone, NewZone),

    ReplaceParams = [[ModuleId, SerId, LastMod]||{{SerId, ModuleId}, LastMod}<-maps:to_list(NewSerModMap)],
    Sql = usql:replace(server_zone_mod, [module_id, server_id, last_mod], ReplaceParams),
    Sql =/= [] andalso db:execute(Sql),

    NewState = State#state{
        server_last_mods = NewSerModMap, zone_mod_map = NewZoneModMap,
        server_zone_map = ServerBaseMap, zone_server_list_map = Z2SMap
    },
    {noreply, NewState};

% 世界等级同步，只会修改数据，不会重新分组
do_handle_cast({'sync_mod_wordlv', _AllZoneBases}, State) ->
    % #state{zone_mod_map = ZoneModMap} = State,
    % {Z2SMap, ServerBaseMap} = calc_zone_server_map(AllZoneBases),
    % F = fun(_, ZoneModData) ->
    %     #zone_mod_data{zone_id = ZoneId} = ZoneModData,
    %     case maps:get(ZoneId, Z2SMap, false) of
    %         false -> ZoneModData;
    %         ZoneBaseL ->
    %             AvgLv = calc_zones_avg_lv(ZoneBaseL),
    %             ZoneModData#zone_mod_data{avg_lv = AvgLv}
    %     end
    % end,
    % NewZoneModMap = maps:map(F, ZoneModMap),
    % sync_server_zone_mod(NewZoneModMap),
    % NewState = State#state{zone_mod_map = NewZoneModMap, server_zone_map = ServerBaseMap, zone_server_list_map = Z2SMap},
    {noreply, State};


do_handle_cast({'center_connected', ZoneId, ServerId, MergeSerIds}, State) ->
    {NewServerZoneMap, NewZoneServerLMap, NewZoneModMap, NewSerModMap} = manage_merge_server_mod(State, ZoneId, ServerId, MergeSerIds),
    ZoneModData = maps:get(ZoneId, NewZoneModMap, #zone_mod_data{}),
    mod_clusters_center:apply_cast(ServerId, lib_clusters_node_api, sync_zone_mod, [ZoneModData]),
    NewState = State#state{
        zone_mod_map = NewZoneModMap, server_zone_map = NewServerZoneMap,
        zone_server_list_map = NewZoneServerLMap, server_last_mods = NewSerModMap
    },
    {noreply, NewState};

do_handle_cast({'server_name_change', ZoneId, ServerId, ServerName}, State) ->
    #state{zone_mod_map = ZoneModMap} = State,
    ZoneModData = maps:get(ZoneId, ZoneModMap, #zone_mod_data{}),
    mod_clusters_center:apply_cast(ServerId, lib_clusters_node_api, sync_zone_mod, [ZoneModData]),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 按照分区Zone获取 ZoneBaseL
%% @return {#{Zone => ZoneBaseL}, #{ServerId => #zone_base{}}
calc_zone_server_map(AllZoneBases) ->
    F = fun
            (#zone_base{zone = 0}, Acc) -> Acc;
            (ZoneBase, {AccZoneServerLMap, AccServerMap}) ->
                #zone_base{zone = ZoneId, server_id = ServerId} = ZoneBase,
                ServerL = maps:get(ZoneId, AccZoneServerLMap, []),
                NewAccZoneServerLMap = AccZoneServerLMap#{ZoneId => [ZoneBase|ServerL]},
                NewAccServerMap = AccServerMap#{ServerId => ZoneBase},
                {NewAccZoneServerLMap, NewAccServerMap}
    end,
    {ZoneServerLMap, ServerMap} = lists:foldl(F, {#{}, #{}}, AllZoneBases),
    SortZoneServerLMap = maps:map(fun(_ZoneId, ZoneBaseL) -> lists:keysort(#zone_base.time, ZoneBaseL) end, ZoneServerLMap),
    {SortZoneServerLMap, ServerMap}.

%% 计算分组核心代码
calc_zone_mod_core(Z2SMap, SerModMap) ->
    calc_zone_mod_core(maps:to_list(Z2SMap), SerModMap, #{}, #{}).
calc_zone_mod_core([], _, ZoneModMap, NextSerModMap) ->
    {NextSerModMap, ZoneModMap};
calc_zone_mod_core([{ZoneId, ZoneBaseL}|H], LastSerModMap, ZoneModMap, NextSerModMap) ->
    ModuleIdL = data_zone_mod:get_module_list(),
    % 每个玩法独立计算
    F_module = fun(ModuleId, {AccSerModMap, AccModuleMap}) ->
        % 1. 计算出预计2/4/8玩法 服
        F_next = fun(ZoneBase, AccNextModMap) ->
            LastMod = maps:get({ModuleId, ZoneBase#zone_base.server_id}, LastSerModMap, ?ZONE_MOD_1),
            NextMod = get_next_mod(ModuleId, LastMod),
            NextModZoneL = maps:get(NextMod, AccNextModMap, []),
            AccNextModMap#{NextMod => [ZoneBase|NextModZoneL]}
        end,
        %1. 根据当前分组模式算出2 4 8。预计模式
        %2. 对预计玩法的服排序再进行判断是否满足条件
        %   a. 根据预计列表进行排序（活跃度, 等级, 天数）
        %   b. 对列表进行对应分服2服 => [[1,2], [3,4]]
        %   c. 尝试对[1, 2] 进行分组跃迁升2服 (两个服达到最小天数&&平均等级大于需求等级)
        %   d. 跃迁失败的话判断是否满足开服天数或者分服记录， 判断是否能跃迁
        %   e. 得出所有分组模式的服务器列表 2 => [1,2,3,4,5,6]
        %3. 组成小跨服分组
        %   a. 根据预计列表进行排序（活跃度, 等级, 天数）
        %   b. 对列表进行对应分服2服 => [[1,2], [3,4]]， 计算平均等级 [1, 2] 分组下的平均等级 = [1, 2]
        %4. 根据组成的小跨服计算下次的预计情况
        %   a. 根据预计列表进行排序（活跃度, 等级, 天数）
        %   b. 根据当前的模式进行分组[1, 2], [3, 4] 均处于2服模式，他们将会进入同一个预计列表 [1, 2, 3, 4]
        %       (情况列举) [1, 2], [3] 处理2服模式, [4] 处于 1服模式， 他们看到的预计列表分别是[1, 2, 3, 4], [1, 2, 3, 4], [3, 4]
        %   c. 保存预计列表切计算出预计列表的平均等级进行保存
        %% #{Mod => [#zone_bases{}]}
        NextModMap = lists:foldl(F_next, #{}, ZoneBaseL),
        % 2. 对预计玩法的服排序再进行判断是否满足条件,获取新 2/4/8 玩法zone_list
        F_calc = fun(NextMod, ZoneL, Acc) ->
            SortZoneL = sort_by_server_world_lv(ZoneL),
            SplitZoneLL = ulists:split_stable_num_list(SortZoneL, NextMod),
            % 3.获取满足NextMod与不满足的NextMod的分组
            % 条件：分组里的平均等级达标，且所有服达到了最小开服天数能进入
            {UpgradeL, RetainL} = lists:partition(fun(SplitZoneL) -> try_upgrade_mod(ModuleId, NextMod, SplitZoneL) end, SplitZoneLL),
            % 4. RetainL不满足的列表里面，也有可能是以前已经达到了NextMod模式或者达到了最大开服天数，但是新的服务器或其他因素导致不满足。这种情况跟也要处理
            {SatisfyL, UnSatisfyL} = lists:partition(fun(ZoneBase) -> try_keep_mod(ModuleId, NextMod, ZoneBase, LastSerModMap) end, lists:flatten(RetainL)),
            NextModZonL = lists:flatten(UpgradeL) ++ SatisfyL,

            NewNextModZonL = maps:get(NextMod, Acc, []) ++ NextModZonL,
            LastMod = get_last_mods(ModuleId, NextMod),
            NewLastModZonL = maps:get(LastMod, Acc, []) ++ UnSatisfyL,

            Acc#{NextMod => NewNextModZonL, LastMod => NewLastModZonL}
        end,
        %% #{Mod => [#zone_bases{}]}
        NewModMap = maps:fold(F_calc, #{}, NextModMap),
        F_group = fun(Mod, ServerZoneL, {AccList, AccSerModL}) ->
            SortZoneBaseL = sort_by_server_world_lv(ServerZoneL),
            IndexSerL = split_by_length(SortZoneBaseL, Mod, []),
            GroupModSerL =
                [begin
                     <<GroupId:16>> = <<ZoneId:8, Mod:4, Index:4>>,
                     #zone_mod_group_data{
                         group_id = GroupId, mod = Mod, avg_lv = calc_avg_world_lv(SerL),
                         server_ids = [SerId||#zone_base{server_id = SerId}<-SerL]
                     }
                 end||{Index, SerL}<-IndexSerL],
            NewAccList = GroupModSerL ++ AccList,
            NewAccSerModL = AccSerModL ++ [{{ModuleId, SerId}, Mod}||#zone_base{server_id = SerId} <- ServerZoneL],
            {NewAccList, NewAccSerModL}
        end,
        {GroupModSerL, NewSerModL} = maps:fold(F_group, {[], []}, NewModMap),
        F_last =
            fun(#zone_mod_group_data{group_id = GroupId, server_ids = ServerIds}, AccMap) ->
                List = [{SerId, GroupId}||SerId<-ServerIds],
                Map = maps:from_list(List),
                maps:merge(Map, AccMap)
            end,
        SerGroupMap = lists:foldl(F_last, #{}, GroupModSerL),
        GroupInfo = #zone_group_info{
            group_mod_servers = GroupModSerL,
            server_group_map = SerGroupMap,
            module_id = ModuleId
        },
        NewAccSerModMap = maps:merge(AccSerModMap,  maps:from_list(NewSerModL)),
        {NewAccSerModMap, AccModuleMap#{ModuleId => GroupInfo}}
    end,
    {NewSerModMap, ModuleMap} = lists:foldl(F_module, {#{}, #{}}, ModuleIdL),

    ZoneModDataTmp = #zone_mod_data{
        zone_id = ZoneId, module_map = ModuleMap,
        avg_lv = calc_zones_avg_lv(ZoneBaseL),
        servers = ZoneBaseL
    },
    ZoneModData = calc_next_mod_server(ZoneModDataTmp, ZoneBaseL),
    NewZoneModMap = ZoneModMap#{ZoneId => ZoneModData},
    NewNextSerModMap = maps:merge(NextSerModMap, NewSerModMap),
    calc_zone_mod_core(H, LastSerModMap, NewZoneModMap, NewNextSerModMap).


%% 小跨服分组后事件处理
%% 跨服玩法需要在此处执行相应的逻辑
calc_zone_mod_event(ZoneModMap) ->
    calc_filter_zone_mod_event(ZoneModMap, []).

%% 小跨服分组后事件处理（过滤指定的功能模块）
calc_filter_zone_mod_event(ZoneModMap, FilterModules) ->
    sync_server_zone_mod(ZoneModMap),
    % 处理功能模块分组同步
    F = fun(ZoneId, ZoneModData, AccL1) ->
        #zone_mod_data{module_map = ModuleMap, servers = Servers} = ZoneModData,
        F2 = fun({ModuleId, GroupInfo}, AccL2) -> [{ModuleId, ZoneId, {Servers, GroupInfo}}|AccL2] end,
        lists:foldl(F2, AccL1, maps:to_list(ModuleMap))
    end,
    ModuleZoneInfoL = maps:fold(F, [], ZoneModMap),
    F_module = fun({ModuleId, ZoneId, {Servers, GroupInfo}}, AccMap) ->
        L = maps:get(ModuleId, AccMap, []),
        NewL = [{ZoneId, {Servers, GroupInfo}}|L],
        AccMap#{ModuleId => NewL}
    end,
    ModuleZoneMap = lists:foldl(F_module, #{}, ModuleZoneInfoL),
    % 同步信息
    ModuleZoneL1 = maps:to_list(ModuleZoneMap),
    ModuleZoneL2 = [Item || {Module, _} = Item <- ModuleZoneL1, not lists:member(Module, FilterModules)],
    lists:foreach(fun lib_clusters_center_api:sync_zone_group/1, ModuleZoneL2),
    mod_team_enlist:sync_zone_mod(ModuleZoneMap),
    ok.

%% --------------------------------------
%% 同步每个分区的分组信息到对应的游戏服
sync_server_zone_mod(ZoneModMap) ->
    F = fun({ZoneId, ZoneModData}) ->
        mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_clusters_node_api, sync_zone_mod, [ZoneModData])
    end,
    lists:foreach(F, maps:to_list(ZoneModMap)).

sync_server_zone_mod(ZoneModMap, SyncZoneList) ->
    F = fun(ZoneId) ->
        ZoneModData = maps:get(ZoneId, ZoneModMap),
        mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_clusters_node_api, sync_zone_mod, [ZoneModData])
    end,
    lists:foreach(F, SyncZoneList).


%% --------------------------------------
%% 某个游戏服的分区修改， 需要处理有影响的分区
%% 重新分组的信息进行同步游戏服和相关功能
zone_change_event(ZoneModMap, ChangeServerId, OldZone, NewZone) ->
    sync_server_zone_mod(ZoneModMap, [OldZone, NewZone]),
    ZoneModData1 = maps:get(OldZone, ZoneModMap),
    ZoneModData2 = maps:get(NewZone, ZoneModMap),
    F = fun(ZoneModData, AccL1) ->
        #zone_mod_data{module_map = ModuleMap, servers = Servers, zone_id = ZoneId} = ZoneModData,
        F2 = fun({ModuleId, GroupInfo}, AccL2) -> [{ModuleId, ZoneId, {Servers, GroupInfo}}|AccL2] end,
        lists:foldl(F2, AccL1, maps:to_list(ModuleMap))
    end,
    ModuleZoneInfoL = lists:foldl(F, [], [ZoneModData1, ZoneModData2]),
    F_module = fun({ModuleId, ZoneId, {Servers, GroupInfo}}, AccMap) ->
        L = maps:get(ModuleId, AccMap, []),
        NewL = [{ZoneId, {Servers, GroupInfo}}|L],
        AccMap#{ModuleId => NewL}
    end,
    ModuleZoneMap = lists:foldl(F_module, #{}, ModuleZoneInfoL),
    lists:foreach(
        fun(Item) ->
            lib_clusters_center_api:sync_zone_change(Item, ChangeServerId, OldZone, NewZone)
        end,
        maps:to_list(ModuleZoneMap)
    ).

%% 判断是否有合服。（该进程是跨服进程，4点会分组，合服只会停机对应的游戏服）合服后需要处理的有：
%% 1. 获取被合服的Id
% 2.修改移除被合服所在zone_id的原有的信息
% 3.在被合服的zone里，重新分组
%% 4对需要重新分组的zone进行分组且同步
manage_merge_server_mod(State, ZoneId, ServerId, MergeSerIds0) ->
    #state{
        zone_mod_map = ZoneModMap, server_zone_map = ServerZoneMap,
        zone_server_list_map = ZoneServerLMap, server_last_mods = SerModMap
    } = State,
    MergeSerIds = lists:delete(ServerId, MergeSerIds0),
    %% 判断是否有合服。（该进程是跨服进程，4点会分组，合服只会停机对应的游戏服）合服后需要处理的有：
    #zone_base{merge_ids = OldMergeSerIds} = ConnectServerZone = maps:get(ServerId, ServerZoneMap, #zone_base{}),
    %% 1. 获取被合服的Id
    BeMergeSerIds = MergeSerIds -- OldMergeSerIds,
    %?PRINT("BeMergeSerIds ~p ~n", [BeMergeSerIds]),
    F = fun(BeMergeSerId, {AccServerZoneMap, AccZoneServerLMap, AccZoneModMap, AccSerModMap, AccChangeZoneL}) ->
        % 2.修改移除被合服所在zone_id的原有的信息
        % 3.在被合服的zone里，重新分组
        AccSerModMapTmp = maps:from_list([Item||{{_, SerId}, _} = Item<-maps:to_list(AccSerModMap), SerId =/= BeMergeSerId]),
        catch db:execute(io_lib:format(<<"delete from server_zone_mod where server_id = ~p">>, [BeMergeSerId])),
        case maps:get(BeMergeSerId, AccServerZoneMap, false) of
            % 被合的取与主服分区相同
            #zone_base{zone = ZoneId} ->
                BeMergeServerZoneL = maps:get(ZoneId, AccZoneServerLMap, []),
                NewBeMergeServerZoneL = lists:keydelete(BeMergeSerId, #zone_base.server_id, BeMergeServerZoneL),
                NewAccZoneServerLMap = AccZoneServerLMap#{ZoneId => NewBeMergeServerZoneL},
                NewAccChangeZoneL = [ZoneId|AccChangeZoneL],
                {NewAccSerModMap, ChangeZoneModMap} = calc_zone_mod_core([{ZoneId, NewBeMergeServerZoneL}], AccSerModMapTmp, #{}, AccSerModMapTmp),
                NewAccZoneModMap = maps:merge(AccZoneModMap, ChangeZoneModMap);
            % 被合的取与主服分区不相同
            #zone_base{zone = BeMergeZoneId} ->
                BeMergeServerZoneL = maps:get(BeMergeZoneId, AccZoneServerLMap, []),
                NewBeMergeServerZoneL = lists:keydelete(BeMergeSerId, #zone_base.server_id, BeMergeServerZoneL),
                NewAccZoneServerLMap = AccZoneServerLMap#{BeMergeZoneId => NewBeMergeServerZoneL},
                NewAccChangeZoneL = [BeMergeZoneId|AccChangeZoneL],
                {NewAccSerModMap, ChangeZoneModMap} = calc_zone_mod_core([{BeMergeZoneId, NewBeMergeServerZoneL}], AccSerModMapTmp, #{}, AccSerModMapTmp),
                NewAccZoneModMap = maps:merge(AccZoneModMap, ChangeZoneModMap);
            % 经过二次被合服，BeMergeZoneId 在服务器信息里面已经不存在了
            _ ->
                NewAccZoneServerLMap = AccZoneServerLMap, NewAccSerModMap = AccSerModMapTmp, NewAccZoneModMap = AccZoneModMap, NewAccChangeZoneL = AccChangeZoneL
        end,
        NewAccServerZoneMap = maps:remove(BeMergeSerId, AccServerZoneMap),
        {NewAccServerZoneMap, NewAccZoneServerLMap, NewAccZoneModMap, NewAccSerModMap, NewAccChangeZoneL}
        end,
    {NewServerZoneMap, NewZoneServerLMap, NewZoneModMap, NewSerModMap, ChangeZoneL} =
        lists:foldl(F, {ServerZoneMap#{ServerId => ConnectServerZone#zone_base{merge_ids = MergeSerIds}}, ZoneServerLMap,
            ZoneModMap, SerModMap, []}, BeMergeSerIds),
    %% 4对需要重新分组的zone进行分组且同步
    ChangZoneModMap =
        lists:foldl(fun(ChangeZoneId, AccMap) ->
            case maps:get(ChangeZoneId, NewZoneModMap, false) of
                false -> AccMap;
                ChangeZoneModData -> AccMap#{ChangeZoneId => ChangeZoneModData}
            end
                    end, #{}, ulists:removal_duplicate(ChangeZoneL)),
    ChangZoneModMap /= #{} andalso calc_filter_zone_mod_event(NewZoneModMap, [?MOD_C_SANCTUARY]),
    {NewServerZoneMap, NewZoneServerLMap, NewZoneModMap, NewSerModMap}.

%% ====================================================================================================================
%% 计算下一模式服务器列表
% 需要算给客户端玩家看的预计列表，处于4服模式的时候要看到8服模式的服务器；
% 有个特殊点就是比如有两个服处于2服模式，剩下的6个服都是四服模式了，二服模式看到的也要4个服(策划需求)
% 有其他问题，因为6个服都进入4服模式，剩下的2个服判断进入4服模式的时候只需要判断2个服的条件，这个时候显示4个服信息会有出入
calc_next_mod_server(ZoneModData, ZoneBaseL) ->
    SortZoneBaseL = sort_by_server_world_lv(ZoneBaseL),
    Mod2ZoneBaseLL = ulists:split_stable_num_list(SortZoneBaseL, ?ZONE_MOD_2),
    Mod4ZoneBaseLL = ulists:split_stable_num_list(SortZoneBaseL, ?ZONE_MOD_4),
    Mod8ZoneBaseLL = ulists:split_stable_num_list(SortZoneBaseL, ?ZONE_MOD_8),
    #zone_mod_data{module_map = ModuleMap} = ZoneModData,
    F = fun(ModuleId, ZoneGroupInfo) ->
        #zone_group_info{group_mod_servers = GroupModServerL} = ZoneGroupInfo,
        NewGroupModServerL = lists:map(
            fun(ZoneModGroup) -> calc_next_mod_server_core(ModuleId, ZoneModGroup, Mod2ZoneBaseLL, Mod4ZoneBaseLL, Mod8ZoneBaseLL) end
        , GroupModServerL),
        ZoneGroupInfo#zone_group_info{group_mod_servers = NewGroupModServerL}
    end,
    NewModuleMap = maps:map(F, ModuleMap),
    ZoneModData#zone_mod_data{module_map = NewModuleMap}.

calc_next_mod_server_core(?MOD_CHRONO_RIFT, ZoneModGroup, _Mod2ZoneBaseLL, _Mod4ZoneBaseLL, Mod8ZoneBaseLL) ->
    NextSerIdL = [SerId||#zone_base{server_id = SerId}<-lists:flatten(Mod8ZoneBaseLL)],
    ZoneModGroup#zone_mod_group_data{next_server_ids = NextSerIdL};
calc_next_mod_server_core(_ModuleId, ZoneModGroup, Mod2ZoneBaseLL, Mod4ZoneBaseLL, Mod8ZoneBaseLL) ->
    case ZoneModGroup of
        #zone_mod_group_data{mod = ?ZONE_MOD_1, server_ids = [SerId|_]} ->
            NextSerL = lists:filter(fun(L) -> lists:keymember(SerId, #zone_base.server_id, L) end, Mod2ZoneBaseLL);
        #zone_mod_group_data{mod = ?ZONE_MOD_2, server_ids = SerIds} ->
            %% 判断所有的2服server_id是否都在 4 服列表里面
            F_member = fun(L) -> lists:all(fun(SerId) -> lists:keymember(SerId, #zone_base.server_id, L) end, SerIds) end,
            NextSerLTmp = lists:filter(fun(L) -> F_member(L) end, Mod4ZoneBaseLL),
            case NextSerLTmp of
                [] ->
                    % 一般不会走到这里，做一个容错
                    F_del = fun(SerId, AccL) -> lists:keydelete(SerId, #zone_base.server_id, AccL) end,
                    SerTmps = [ulists:keyfind(SerId, #zone_base.server_id, lists:flatten(Mod8ZoneBaseLL), false)||SerId<-SerIds],
                    Sers = [Rec||#zone_base{} = Rec <-SerTmps],
                    case lists:foldl(F_del, Mod8ZoneBaseLL, SerIds) of
                        [Ser3, Ser4|_] -> NextSerL = [Ser3, Ser4|Sers];
                        [Ser3] -> NextSerL = [Ser3|Sers];
                        _ -> NextSerL = Sers
                    end;
                _ -> NextSerL = NextSerLTmp
            end;
        #zone_mod_group_data{mod = ?ZONE_MOD_4} ->
            NextSerL = Mod8ZoneBaseLL;
        _ ->
            NextSerL = Mod8ZoneBaseLL
    end,
    NextSerL0 = lists:flatten(NextSerL),
    NextSerIdL = [SerId||#zone_base{server_id = SerId}<-NextSerL0],
    ZoneModGroup#zone_mod_group_data{next_server_ids = NextSerIdL, next_avg_lv = calc_zones_avg_lv(NextSerL0)}.


%% 根据活跃类型和世界等级排序
sort_by_server_world_lv(ZoneList) ->
    F_sort = fun(ZoneBase1, ZoneBase2) ->
        #zone_base{world_lv = WorldLv1, active_type = ActiveType1, time = Time1} = ZoneBase1,
        #zone_base{world_lv = WorldLv2, active_type = ActiveType2, time = Time2} = ZoneBase2,
        if
            ActiveType1 > ActiveType2 -> true;
            ActiveType1 == ActiveType2, WorldLv1 > WorldLv2 -> true;
            ActiveType1 == ActiveType2, WorldLv1 == WorldLv2, Time1 < Time2 -> true;
            true -> false
        end
             end,
    lists:sort(F_sort, ZoneList).

% 尝试晋升模式
% 判断平均等级（不活跃用户不算），平均等级达标且所有服满足最小开服天数
try_upgrade_mod(ModuleId, NextMod, ZoneList) ->
    AvgLv = calc_avg_world_lv(ZoneList),
    #base_zone_mod_group{open_day = NeedDay, min_world_lv = NeedLv} = data_zone_mod:get_mod_cfg(ModuleId, NextMod),
    F = fun(#zone_base{time = OpTime}) -> get_server_open_day(OpTime) >= NeedDay end,
    AvgLv >= NeedLv andalso lists:all(F, ZoneList).

% 尝试保留当前的模式
% 旧的模式已经达到了NextMod模式 或者 达到了最大开服天数
try_keep_mod(ModuleId, NextMod, ZoneBase, LastSerModMap) ->
    #zone_base{server_id = ServerId, time = OpTime} = ZoneBase,
    #base_zone_mod_group{max_open_day = NeedDay} = data_zone_mod:get_mod_cfg(ModuleId, NextMod),
    IsKeep = maps:get({ModuleId, ServerId}, LastSerModMap, 0) == NextMod,
    IsSatisfy = get_server_open_day(OpTime) >= NeedDay,
    IsKeep orelse IsSatisfy.

% 计算平均世界等级， 只计算活跃服务器的
calc_avg_world_lv(ZoneList) ->
    F_split = fun(#zone_base{world_lv = WorldLv, active_type = ActiveType}, {Acc1, Acc2}) ->
        case ActiveType == 1 of
            true -> {[WorldLv|Acc1], Acc2};
            _ -> {Acc1, [WorldLv|Acc2]}
        end
              end,
    {ActiveLvL, DisActiveLvL} = lists:foldl(F_split, {[], []}, ZoneList),
    case ActiveLvL of
        [] -> lists:sum(DisActiveLvL) div length(DisActiveLvL);
        _ -> lists:sum(ActiveLvL) div length(ActiveLvL)
    end.

%% 获取下一分服
get_next_mod(?MOD_CHRONO_RIFT, _Mod) ->
    ?ZONE_MOD_8;
get_next_mod(_, Mod) ->
    if
        Mod == ?ZONE_MOD_1 -> ?ZONE_MOD_2;
        Mod == ?ZONE_MOD_2 -> ?ZONE_MOD_4;
        Mod == ?ZONE_MOD_4 -> ?ZONE_MOD_8;
        Mod == ?ZONE_MOD_8 -> ?ZONE_MOD_8;
        true -> ?ZONE_MOD_2
    end.

%% 获取上一轮分组
get_last_mods(?MOD_CHRONO_RIFT, _Mod) ->
    ?ZONE_MOD_1;
get_last_mods(_, Mod) ->
    if
        Mod == ?ZONE_MOD_1 -> ?ZONE_MOD_1;
        Mod == ?ZONE_MOD_2 -> ?ZONE_MOD_1;
        Mod == ?ZONE_MOD_4 -> ?ZONE_MOD_2;
        Mod == ?ZONE_MOD_8 -> ?ZONE_MOD_4;
        true -> ?ZONE_MOD_1
    end.

%% 计算当前分区的平均世界等级
calc_zones_avg_lv([]) -> 0;
calc_zones_avg_lv(ZoneBaseL) ->
    F_sum = fun(#zone_base{world_lv = WLv}, AccLv) -> WLv + AccLv end,
    SumLv = lists:foldl(F_sum, 0, ZoneBaseL),
    AvgLv = SumLv div length(ZoneBaseL),
    AvgLv.

%% 获取开服天数
get_server_open_day(OpenTime) ->
    Now = utime:unixtime(),
    Day = (Now - OpenTime) div ?ONE_DAY_SECONDS,
    Day + 1.

%% 将模式按照开发时间顺序进行分组
%% [1,2,3,4,5,6,7] 的 2 服模式 => [{1, [1,2]}, {2, [3,4]}, {3, [5,6]}, {4, [7]}]
split_by_length([], _Length, Result) ->
    F = fun(SerL, {Index, Acc}) -> {Index+1, [{Index, SerL}|Acc]} end,
    {_, IndexSerL} = lists:foldl(F, {1, []}, Result),
    IndexSerL;
split_by_length(List, Length, Result) ->
    case length(List) > Length of
        true ->
            {L1, L2} = lists:split(Length, List),
            split_by_length(L2, Length, [L1|Result]);
        _ ->
            split_by_length([], Length, [List|Result])
    end.


test_calc_zone_mod() ->
    db:execute(<<"truncate table server_zone">>),
    db:execute(<<"truncate table server_zone_mod">>),
    Now = utime:unixtime(),
    SqlPre = "insert into server_zone (zone_type, server_id, zone, time, combat_power, server_num, server_name, world_lv, c_server_msg, active_type) values",
    Server1 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [1, Now - (100 + 8) * ?ONE_DAY_SECONDS, 1, 1]),
    Server2 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [2, Now - (100 + 7) * ?ONE_DAY_SECONDS, 2, 2]),
    Server3 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [3, Now - (100 + 6) * ?ONE_DAY_SECONDS, 3, 3]),
    Server4 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [4, Now - (100 + 5) * ?ONE_DAY_SECONDS, 4, 4]),
    Server5 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [5, Now - (100 + 4) * ?ONE_DAY_SECONDS, 5, 5]),
    Server6 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 300, '', 1),", [6, Now - (100 + 3) * ?ONE_DAY_SECONDS, 6, 6]),
    Server7 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 150, '', 1),", [7, Now - (5 + 2) * ?ONE_DAY_SECONDS, 7, 7]),
    Server8 = io_lib:format("(1, ~p, 1, ~p, 888888888, ~p, '~p', 150, '', 1)",  [8, Now - (5 + 1) * ?ONE_DAY_SECONDS, 8, 8]),
    Sql = lists:concat([SqlPre, Server1, Server2, Server3, Server4, Server5, Server6, Server7, Server8]),
    %io:format('~s ~n', [Sql]),
    db:execute(Sql),
    SqlPre2 = "insert into server_zone_mod (module_id, server_id, last_mod) values",
    Module1 = io_lib:format("(135, ~p, ~p), ", [1, 2]),
    Module2 = io_lib:format("(135, ~p, ~p), ", [2, 2]),
    Module3 = io_lib:format("(135, ~p, ~p), ", [3, 2]),
    Module4 = io_lib:format("(135, ~p, ~p), ", [4, 2]),
    Module5 = io_lib:format("(135, ~p, ~p), ", [5, 2]),
    Module6 = io_lib:format("(135, ~p, ~p), ", [6, 2]),
    Module7 = io_lib:format("(135, ~p, ~p), ", [7, 2]),
    Module8 = io_lib:format("(135, ~p, ~p) ",  [8, 2]),
    Sql2 = lists:concat([SqlPre2, Module1, Module2, Module3, Module4, Module5, Module6, Module7, Module8]),
    %io:format('~s ~n', [Sql2]),
    db:execute(Sql2),
    ok.

