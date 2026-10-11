%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_night_ghost_mod.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-08
%%% @modified
%%% @description    百鬼夜行管理进程函数(local与kf共用)
%%% ------------------------------------------------------------------------------------------------
-module(lib_night_ghost_mod).

-include("battle.hrl").
-include("clusters.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("night_ghost.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").

-export([
    act_start/3, act_end/1, broadcast_act_info/1, get_cache/2, update_cache/2,
    boss_be_killed/5, boss_broadcast_reward/6
]).

-export([sync_data_to_group/3, sync_data_to_servers/2, sync_data/2, server_info_change/3]).

-export([get_server_group/3, get_group_servers/2, get_boss_info_local/3]).

% -compile(export_all).

%%% ====================================== exported functions ======================================

%% 活动开启
%% @return #night_ghost_state_local{} | #night_ghost_state_kf{}
act_start(ModId, ModSub, State) when is_record(State, night_ghost_state_local) -> % 本服模式
    % 计算活动时间信息及定时器
    ActInfo = init_act_time(ModId, ModSub),
    NewActInfo = lib_night_ghost_data:create_ref(ActInfo),
    % 生成各场景怪物(默认房间id=0)
    [_, Liveness] = lib_night_ghost_data:get_liveness_local(),
    Wlv = util:get_world_lv(),
    SceneInfo = init_scene_boss(State#night_ghost_state_local.ser_mod, Liveness, Wlv, {0, 0}),
    % 更新进程状态及一些相关数据更新
    Args = [
        {act_state, ?NG_ACT_OPEN}, {act_info, NewActInfo}, {scene_info, SceneInfo},
        {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]}, {broadcast_act_info},
        {send_tv, ['act_start', []]}, {role_success_end_activity}
    ],
    sync_data(Args, State);
act_start(ModId, ModSub, State) when is_record(State, night_ghost_state_kf) -> % 跨服模式
    % 计算活动时间信息
    ActInfo = init_act_time(ModId, ModSub),
    % 生成各场景怪物
    LivenessL = lib_night_ghost_data:get_liveness_cls(),
    SceneInfo = init_scene_boss_cls(State#night_ghost_state_kf.group_map, LivenessL),
    % 同步各服活动数据,场景数据以及其它操作
    GroupMap = State#night_ghost_state_kf.group_map,
    [
        begin
            Args = [
                {act_state, ?NG_ACT_OPEN}, {act_info, ActInfo}, {scene_info, GroupSceneInfo},
                {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]}, {broadcast_act_info},
                {send_tv, ['act_start', []]}, {role_success_end_activity}
            ],
            sync_data_to_group([SyncGroup], GroupMap, Args)
        end
     || {SyncGroup, GroupSceneInfo} <- maps:to_list(SceneInfo)
    ],
    % 更新进程状态
    State#night_ghost_state_kf{
        state = ?NG_ACT_OPEN,
        scene_info = SceneInfo,
        act_info = ActInfo
    }.

%% 活动结束
%% @return #night_ghost_state_local{} | #night_ghost_state_kf{}
act_end(State) when is_record(State, night_ghost_state_local) -> % 本服模式
    % 清理场景boss
    SceneInfo = State#night_ghost_state_local.scene_info,
    clear_scene_boss(SceneInfo, {0, 0}),
    % 更新进程状态及一些相关数据更新
    Args = [
        {act_state, ?NG_ACT_CLOSE}, {clear_act_data},
        {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]},
        {broadcast_act_info}
    ],
    sync_data(Args, State);
act_end(State) when is_record(State, night_ghost_state_kf) -> % 跨服模式
    % 清理场景boss;同步各服消息
    #night_ghost_state_kf{group_map = GroupMap, scene_info = SceneInfoM} = State,
    [
        begin
            clear_scene_boss(GroupSceneInfo, GroupKey),
            Args = [
                {act_state, ?NG_ACT_CLOSE}, {clear_act_data},
                {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]},
                {broadcast_act_info}
            ],
            sync_data_to_group([GroupKey], GroupMap, Args)
        end
     || {GroupKey, GroupSceneInfo} <- maps:to_list(SceneInfoM)
    ],
    % 更新进程状态
    State#night_ghost_state_kf{
        state = ?NG_ACT_CLOSE,
        scene_info = #{},
        act_info = undefined
    }.

%% 广播活动信息
broadcast_act_info(State) ->
    Bin20601 = get_cache(?CACHE_NG_ACT_INFO, State),
    lib_server_send:send_to_all(Bin20601).

%% 获取缓存数据
get_cache(Key, State) ->
    case get(Key) of
        undefined -> update_cache(Key, State);
        Value -> Value
    end.

%% 更新缓存数据
update_cache(Keys, State) when is_list(Keys) ->
    [update_cache(Key, State) || Key <- Keys];

%% 20601 - 活动信息数据
update_cache(?CACHE_NG_ACT_INFO = Key, State) ->
    #night_ghost_state_local{
        state = ActState,
        group_id = GroupId,
        ser_mod = SerMod,
        servers = Servers,
        act_info = ActInfo
    } = State,
    F = fun(Server, AccL) ->
        #zone_base{
            server_id = SerId,
            server_num = SerNum,
            % c_server_msg = CSerMsg,
            server_name = SerName,
            time = OpTime,
            world_lv = Wlv
        } = Server,
        OpDay = util:get_open_day(OpTime),
        % [{SerId, SerNum, CSerMsg, SerName, OpDay, Wlv} | AccL]
        [{SerId, SerNum, SerName, OpDay, Wlv} | AccL]
    end,
    ServerL = lists:foldl(F, [], Servers),
    ETime = lib_night_ghost_data:get_act_etime(ActInfo),
    AvgWlv = lib_night_ghost_data:get_avg_wlv(Servers),
    {ok, Bin} = pt_206:write(20601, [ActState, ETime, SerMod, GroupId, ServerL, AvgWlv]),
    put(Key, Bin),
    Bin;

%% 20602 - boss信息数据
update_cache(?CACHE_NG_BOSS_INFO = Key, State) ->
    #night_ghost_state_local{
        scene_info = SceneInfoM
    } = State,
    {_, BinMap} = lib_night_ghost_data:pack_20602(SceneInfoM),
    put(Key, BinMap),
    BinMap.

%% boss被击杀
%% @param Minfo :: #scene_object{} 怪物信息
%%        Klist :: [#mon_atter{},...] 怪物攻击者列表
%%        Atter :: #battle_return_atter{} 最后击杀者
%%        AtterSign :: integer() 击杀者标识类型
%%        State :: #night_ghost_state_local{} | #night_ghost_state_kf{}
%% @return #night_ghost_state_local{} | #night_ghost_state_kf{}
boss_be_killed(Minfo, Klist, Atter, AtterSign, State) ->
    #scene_object{scene = SceneId, scene_pool_id = ZoneId, copy_id = GroupId, config_id = BossId} = Minfo,
    % 计算伤害排名
    RankList = lib_night_ghost_data:calc_rank_list(Klist), % [#rank_info{},...]
    % 日志
    lib_night_ghost_api:log_night_ghost_rank(ZoneId, GroupId, SceneId, BossId, RankList),
    lib_night_ghost_api:log_night_ghost_killer(ZoneId, GroupId, SceneId, BossId, Atter),
    % 发放排名奖励
    send_reward(?NG_REWARD_TYPE_RANK, {{ZoneId, GroupId}, RankList}, State),
    % 发放尾刀奖励
    send_reward(?NG_REWARD_TYPE_KILLER, {{ZoneId, GroupId}, Atter, AtterSign}, State),
    % 发传闻
    send_tv('boss_be_killed', [Minfo, Atter], State),
    % 更新怪物状态
    NewState = update_boss_die(Minfo, State),
    NewState.

%% boss召集奖励
%% @return #night_ghost_state_local{} | #night_ghost_state_kf{}
boss_broadcast_reward(SerId, RoleId, _Channel, SceneId, BossUId, State) when is_record(State, night_ghost_state_local) ->
    Args = [{broadcast_boss_player, SerId, RoleId, SceneId, BossUId}],
    NewState = sync_data(Args, State),

    send_reward(?NG_REWARD_TYPE_BC_BOSS, {SerId, RoleId}, NewState),

    NewState;
boss_broadcast_reward(SerId, RoleId, _Channel, SceneId, BossUId, State) when is_record(State, night_ghost_state_kf) ->
    ZoneId = lib_clusters_center_api:get_zone(SerId),
    GroupId = get_server_group(SerId, ZoneId, State),

    {BossInfo, BossList, SceneInfo, SceneInfoM} = gex_boss_info_kf({ZoneId, GroupId}, BossUId, SceneId, State),
    #boss_info{bc_player = BroadCastL} = BossInfo,
    NBossInfo = BossInfo#boss_info{bc_player = [ {SerId, RoleId} | BroadCastL ]},
    NewState = set_boss_info_kf({ZoneId, GroupId}, NBossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State),

    Args = [{broadcast_boss_player, SerId, RoleId, SceneId, BossUId}],
    sync_data_to_group([{ZoneId, GroupId}], get_group_map(NewState), Args),

    send_reward(?NG_REWARD_TYPE_BC_BOSS, {ZoneId, GroupId, SerId, RoleId}, NewState),

    NewState.

%% 同步跨服信息至分组
%% @param GroupList :: [{zone_id, group_id},...]
%%        GroupMap :: #{zone_id => {S2MG, G2S, G2M}}
%%        Args :: [{type, Data},...]
sync_data_to_group([], _, _) -> ok;
sync_data_to_group([{ZoneId, GroupId} | T], GroupMap, Args) ->
    {_, G2S, _} = maps:get(ZoneId, GroupMap),
    SerList = maps:get(GroupId, G2S),
    sync_data_to_servers(SerList, Args),
    sync_data_to_group(T, GroupMap, Args).

sync_data_to_servers(SerList, Args) ->
    [
        mod_clusters_center:apply_cast(SerId, mod_night_ghost_local, sync_data, [Args])
     || #zone_base{server_id = SerId} <- SerList
    ].

%% 本服更新同步数据
sync_data([], State) -> State;
sync_data([H | T], State) when is_record(State, night_ghost_state_local) ->
    NewState =
    case H of
        % 进程数据同步相关
        {act_state, ?NG_ACT_OPEN} ->
            lib_activitycalen_api:success_start_activity(?MOD_NIGHT_GHOST, 1),
            State#night_ghost_state_local{state = ?NG_ACT_OPEN};
        {act_state, ?NG_ACT_CLOSE} ->
            lib_activitycalen_api:success_end_activity(?MOD_NIGHT_GHOST, 1),
            State#night_ghost_state_local{state = ?NG_ACT_CLOSE};
        {zone_id, ZoneId} ->
            State#night_ghost_state_local{zone_id = ZoneId};
        {group_id, GroupId} ->
            State#night_ghost_state_local{group_id = GroupId};
        {mod, SerMod} ->
            SceneInfoM = init_scene_info(SerMod),
            State#night_ghost_state_local{ser_mod = SerMod, scene_info = SceneInfoM};
        {group_servers, Servers} ->
            State#night_ghost_state_local{servers = Servers};
        {server, Server} ->
            #zone_base{server_id = SerId} = Server,
            #night_ghost_state_local{servers = Servers} = State,
            NServers = lists:keyreplace(SerId, #zone_base.server_id, Servers, Server),
            State#night_ghost_state_local{servers = NServers};
        {scene_info, SceneInfo} ->
            State#night_ghost_state_local{scene_info = SceneInfo};
        {act_info, ActInfo} ->
            NewActInfo = lib_night_ghost_data:create_ref(ActInfo),
            State#night_ghost_state_local{act_info = NewActInfo};
        {boss_info, BossUId, SceneId} ->
            {BossInfo, BossList, SceneInfo, SceneInfoM} = gex_boss_info_local(BossUId, SceneId, State),
            NBossInfo = BossInfo#boss_info{is_alive = false},
            set_boss_info_local(NBossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State);
        {broadcast_boss_player, SerId, RoleId, SceneId, BossUId} ->
            {BossInfo, BossList, SceneInfo, SceneInfoM} = gex_boss_info_local(BossUId, SceneId, State),
            #boss_info{bc_player = BroadCastL} = BossInfo,
            NBossInfo = BossInfo#boss_info{bc_player = [ {SerId, RoleId} | BroadCastL ]},
            set_boss_info_local(NBossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State);
        % 同步数据后的操作指令相关
        {update_cache, Key} ->
            update_cache(Key, State),
            State;
        {broadcast_act_info} ->
            broadcast_act_info(State),
            State;
        {clear_act_data} ->
            #night_ghost_state_local{ser_mod = SerMod} = State,
            lib_night_ghost_data:clear_ref(State#night_ghost_state_local.act_info),
            State#night_ghost_state_local{scene_info = init_scene_info(SerMod), act_info = undefined};
        {send_tv, [Type, Args]} ->
            lib_night_ghost_api:send_tv(Type, Args),
            State;
        {role_success_end_activity} ->
            [
                lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, lib_night_ghost, role_success_end_activity, [])
             || Id <- lib_online:get_online_ids()
            ],
            State;
        _ ->
            State
    end,
    sync_data(T, NewState);
sync_data(_, State) when is_record(State, night_ghost_state_kf) ->
    State.

%% 游戏服信息变更(跨服调用)
%% @return #night_ghost_state_kf{}
server_info_change(SerId, KvList, State) ->
    ZoneId = lib_clusters_center_api:get_zone(SerId),

    case catch gex_server(SerId, ZoneId, State) of
        {Server, GroupId, Servers, Tuple, GroupMap} ->
            NServer = lib_clusters:update_zone_base(KvList, Server),
            NewState = set_server(NServer, ZoneId, GroupId, Servers, Tuple, GroupMap, State),

            Args = [
                {server, NServer}, {update_cache, ?CACHE_NG_ACT_INFO}
            ],
            sync_data_to_group([{ZoneId, GroupId}], GroupMap, Args);
        _ ->
            NewState = State
    end,

    NewState.

%%% ======================================= private functions ======================================

%% 初始化活动时间信息
%% @return #act_info{}
init_act_time(ModId, ModSub) ->
    NowTime = utime:unixtime(),
    ActId = lib_activitycalen_api:get_today_act(ModId, ModSub),
    case lib_activitycalen:get_act_open_time_region(ModId, ModSub, ActId) of
        {ok, [STime, ETime]} when NowTime >= STime, NowTime - STime < 3 -> % NowTime和STime可能会有误差,作3秒内兼容,活动日历开启
            skip;
        _ -> % 秘籍开启
            STime = NowTime,
            ETime = NowTime + ?NG_ACT_DURATION
    end,

    #act_info{
        stime = STime,
        etime = ETime
    }.

%% 初始化场景列表(活动开始前)
init_scene_info(SerMod) ->
    SceneList = data_night_ghost:get_scene_list(SerMod),
    F = fun(SceneId, AccM) -> AccM#{SceneId => #scene_info{scene_id = SceneId, boss_info = []}} end,
    lists:foldl(F, #{}, SceneList).

%% 初始化不同分区分组的场景怪物(跨服)
%% @return #{{zone_id, group_id} => #{scene_id => #{scene_info{}}}}
init_scene_boss_cls(GroupMap, LivenessL) ->
    ZoneF = fun(ZoneId, {_, G2S, G2M}, AccZoneM) ->
        GroupF = fun(GroupId, SerList, AccGroupM) ->
            SerMod = maps:get(GroupId, G2M),
            case SerMod of
                ?ZONE_MOD_1 -> % 单服模式已自行处理
                    AccGroupM;
                _ ->
                    Liveness = lib_night_ghost_data:get_liveness(SerList, LivenessL),
                    AvgWlv = lib_night_ghost_data:get_avg_wlv(SerList),
                    SceneInfo = init_scene_boss(SerMod, Liveness, AvgWlv, {ZoneId, GroupId}),
                    AccGroupM#{{ZoneId, GroupId} => SceneInfo}
            end
        end,
        maps:merge(AccZoneM, maps:fold(GroupF, #{}, G2S))
    end,
    maps:fold(ZoneF, #{}, GroupMap).

%% 初始化场景怪物
%% @return #{scene_id => #scene_info{}}
init_scene_boss(SerMod, Liveness, Wlv, {PoolId, CopyId}) ->
    SceneList = data_night_ghost:get_scene_list(SerMod),
    F = fun(SceneId, AccM) ->
        #base_night_ghost_boss{
            liveness_num = LivenessNum
        } = BossCfg = data_night_ghost:get_ng_boss(SerMod, SceneId),
        N = lib_night_ghost_data:get_boss_num(LivenessNum, Liveness),
        BossList = init_boss_list({SceneId, PoolId, CopyId}, N, Wlv, BossCfg),
        lib_night_ghost_api:log_night_ghost_boss(PoolId, CopyId, SceneId, BossList),
        AccM#{SceneId => #scene_info{scene_id = SceneId, boss_info = BossList}}
    end,
    lists:foldl(F, #{}, SceneList).

%% 初始化生成一个场景内的boss
%% @return [#boss_info{},...]
init_boss_list({SceneId, PoolId, CopyId}, N, Wlv, BossCfg) ->
    #base_night_ghost_boss{mon_id = BossId, loc_list = LocList0} = BossCfg,
    LocList = urand:get_rand_list(N, LocList0),
    [
        begin
            {{X, Y}, _} = Loc,
            BossUId = lib_mon:sync_create_mon(BossId, SceneId, PoolId, X, Y, 0, CopyId, 1, [{dynamic_lv, Wlv}]),
            #boss_info{
                boss_uid = BossUId,
                boss_id = BossId,
                x = X,
                y = Y,
                is_alive = true
            }
        end
     || Loc <- LocList
    ].

%% 奖励发放
send_reward(?NG_REWARD_TYPE_RANK, {_, RankList}, State) when is_record(State, night_ghost_state_local) -> % 本服伤害排名奖励
    Fun = fun(#rank_info{key = Key, rank = Rank, role_list = _RoleList}) ->
        case Key of
            {?NG_ROLE, RoleId} ->
                lib_night_ghost_api:send_reward(?NG_REWARD_TYPE_RANK, [RoleId], Rank);
            {?NG_TEAM, TeamId} ->
                {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_RANK, Rank]},
                mod_team:cast_to_team(TeamId, {'apply_cast', M, F, A})
        end
    end,
    lists:foreach(Fun, RankList);

send_reward(?NG_REWARD_TYPE_RANK, {{_ZoneId, _GroupId}, RankList}, State) when is_record(State, night_ghost_state_kf) -> % 跨服伤害排名奖励
    Fun = fun(#rank_info{key = Key, rank = Rank, role_list = [#mon_atter{server_id = SerId}|_]}) ->
        case Key of
            {?NG_ROLE, RoleId} ->
                {M, F, A} = {lib_night_ghost_api, send_reward, [?NG_REWARD_TYPE_RANK, [RoleId], Rank]},
                mod_clusters_center:apply_cast(SerId, M, F, A);
            {?NG_TEAM, TeamId} when TeamId rem 2 == 1 -> % 本服队伍
                {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_RANK, Rank]},
                mod_clusters_center:apply_cast(SerId, mod_team, cast_to_team, [TeamId, {'apply_cast', M, F, A}]);
            {?NG_TEAM, TeamId} when TeamId rem 2 == 0 -> % 跨服队伍
                {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_RANK, Rank]},
                mod_team:cast_to_team(TeamId, {'apply_cast', M, F, A})
        end
    end,
    lists:foreach(Fun, RankList);

send_reward(?NG_REWARD_TYPE_KILLER, {_, Atter, ?BATTLE_SIGN_PLAYER}, State) when is_record(State, night_ghost_state_local) -> % 本服尾刀奖励
    #battle_return_atter{
        real_id = RoleId, team_id = TeamId
    } = Atter,
    case TeamId of
        0 ->
            lib_night_ghost_api:send_reward(?NG_REWARD_TYPE_KILLER, [RoleId], 0);
        _ ->
            {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_KILLER, 0]},
            mod_team:cast_to_team(TeamId, {'apply_cast', M, F, A})
    end;

send_reward(?NG_REWARD_TYPE_KILLER, {{_ZoneId, _GroupId}, Atter, ?BATTLE_SIGN_PLAYER}, State) when is_record(State, night_ghost_state_kf) -> % 跨服尾刀奖励
    #battle_return_atter{
        real_id = RoleId, team_id = TeamId, server_id = SerId
    } = Atter,
    case TeamId of
        0 ->
            {M, F, A} = {lib_night_ghost_api, send_reward, [?NG_REWARD_TYPE_KILLER, [RoleId], 0]},
            mod_clusters_center:apply_cast(SerId, M, F, A);
        _ when TeamId rem 2 == 1 -> % 本服队伍
            {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_KILLER, 0]},
            mod_clusters_center:apply_cast(SerId, mod_team, cast_to_team, [TeamId, {'apply_cast', M, F, A}]);
        _ when TeamId rem 2 == 0 -> % 跨服队伍
            {M, F, A} = {lib_night_ghost_api, send_team_reward, [?NG_REWARD_TYPE_KILLER, 0]},
            mod_team:cast_to_team(TeamId, {'apply_cast', M, F, A})
    end;

send_reward(?NG_REWARD_TYPE_BC_BOSS, {_SerId, RoleId}, State) when is_record(State, night_ghost_state_local) -> % 本服boss召集奖励
    lib_night_ghost_api:send_reward(?NG_REWARD_TYPE_BC_BOSS, [RoleId], ?ZONE_MOD_1);

send_reward(?NG_REWARD_TYPE_BC_BOSS, {ZoneId, _GroupId, SerId, RoleId}, State) when is_record(State, night_ghost_state_kf) -> % 跨服boss召集奖励
    {M, F, A} = {lib_night_ghost_api, send_reward, [?NG_REWARD_TYPE_BC_BOSS, [RoleId], get_server_mod(SerId, ZoneId, State)]},
    mod_clusters_center:apply_cast(SerId, M, F, A);

send_reward(_, _, _) -> skip.

%% boss死亡信息
send_tv('boss_be_killed', [Minfo, Atter], State) when is_record(State, night_ghost_state_local) ->
    #scene_object{config_id = BossId} = Minfo,
    #battle_return_atter{
        real_name = RoleName
    } = Atter,

    lib_night_ghost_api:send_tv('boss_be_killed', [RoleName, BossId]);

send_tv('boss_be_killed', [Minfo, Atter], State) when is_record(State, night_ghost_state_kf) ->
    #scene_object{config_id = BossId, scene_pool_id = ZoneId, copy_id = GroupId} = Minfo,
    #battle_return_atter{
        real_name = RoleName
    } = Atter,

    Servers = get_group_servers({ZoneId, GroupId}, State),
    [
        begin
            {M, F, A} = {lib_night_ghost_api, send_tv, ['boss_be_killed', [RoleName, BossId]]},
            mod_clusters_center:apply_cast(SerId, M, F, A)
        end
     || #zone_base{server_id = SerId} <- Servers
    ].

%% boss死亡更新
update_boss_die(Minfo, State) when is_record(State, night_ghost_state_local) ->
    #scene_object{scene = SceneId, id = BossUId} = Minfo,

    {BossInfo, BossList, SceneInfo, SceneInfoM} = gex_boss_info_local(BossUId, SceneId, State),
    NBossInfo = BossInfo#boss_info{is_alive = false},
    NewState = set_boss_info_local(NBossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State),

    lib_night_ghost_api:log_night_ghost_boss(0, 0, SceneId, [NBossInfo]),
    update_cache(?CACHE_NG_BOSS_INFO, NewState),

    BinMap = get_cache(?CACHE_NG_BOSS_INFO, NewState),
    Bin20602 = maps:get(SceneId, BinMap),
    lib_server_send:send_to_scene(SceneId, 0, 0, Bin20602),

    NewState;
update_boss_die(Minfo, State) when is_record(State, night_ghost_state_kf) ->
    #scene_object{scene = SceneId, scene_pool_id = ZoneId, copy_id = GroupId, id = BossUId} = Minfo,

    {BossInfo, BossList, SceneInfo, SceneInfoM} = gex_boss_info_kf({ZoneId, GroupId}, BossUId, SceneId, State),
    NBossInfo = BossInfo#boss_info{is_alive = false},
    NewState = set_boss_info_kf({ZoneId, GroupId}, NBossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State),

    lib_night_ghost_api:log_night_ghost_boss(ZoneId, GroupId, SceneId, [NBossInfo]),
    #night_ghost_state_kf{group_map = GroupMap} = NewState,
    Args = [{boss_info, BossUId, SceneId}, {update_cache, ?CACHE_NG_BOSS_INFO}],
    sync_data_to_group([{ZoneId, GroupId}], GroupMap, Args),

    NSceneInfoM = get_scene_infos_kf({ZoneId, GroupId}, NewState),
    {_, Bin20602} = lib_night_ghost_data:pack_20602(SceneId, NSceneInfoM),
    lib_server_send:send_to_scene(SceneId, ZoneId, GroupId, Bin20602),

    NewState.

%% 清理场景内的boss
clear_scene_boss(SceneInfo, {PoolId, CopyId}) ->
    [
        lib_mon:clear_scene_mon(SceneId, PoolId, CopyId, 1)
     || SceneId <- maps:keys(SceneInfo)
    ].

%%% ====================================== general memory data =====================================
%%% gex_... 在获取相关数据后为方便后续的数据更新,返回多个相关结果
%%% get_... 仅获取相关数据
%%% set_... 设置相关数据,返回新的状态数据

%% 一级数据

get_group_map(State) ->
    State#night_ghost_state_kf.group_map.

set_group_map(GroupMap, State) ->
    State#night_ghost_state_kf{group_map = GroupMap}.

get_scene_infos_local(State) ->
    State#night_ghost_state_local.scene_info.

set_scene_infos_local(SceneInfoM, State) ->
    State#night_ghost_state_local{scene_info = SceneInfoM}.

get_scene_infos_kf({ZoneId, GroupId}, State) ->
    Map = State#night_ghost_state_kf.scene_info,
    maps:get({ZoneId, GroupId}, Map).

set_scene_infos_kf({ZoneId, GroupId}, SceneInfoM, State) ->
    OMap = State#night_ghost_state_kf.scene_info,
    NMap = maps:put({ZoneId, GroupId}, SceneInfoM, OMap),
    State#night_ghost_state_kf{scene_info = NMap}.

%% 二级数据

gex_zone_map(ZoneId, State) ->
    GroupMap = get_group_map(State),
    Tuple = maps:get(ZoneId, GroupMap),
    {Tuple, GroupMap}.

get_zone_map(ZoneId, State) ->
    {Tuple, _} = gex_zone_map(ZoneId, State),
    Tuple.

set_zone_map(ZoneId, Tuple, GroupMap, State) ->
    NGroupMap = maps:put(ZoneId, Tuple, GroupMap),
    set_group_map(NGroupMap, State).

gex_scene_info_local(SceneId, State) ->
    SceneInfoM = get_scene_infos_local(State),
    SceneInfo = maps:get(SceneId, SceneInfoM),
    {SceneInfo, SceneInfoM}.

% get_scene_info_local(SceneId, State) ->
%     {SceneInfo, _} = gex_scene_info_local(SceneId, State),
%     SceneInfo.

set_scene_info_local(SceneId, SceneInfo, SceneInfoM, State) ->
    NSceneInfoM = maps:put(SceneId, SceneInfo, SceneInfoM),
    set_scene_infos_local(NSceneInfoM, State).

gex_scene_info_kf({ZoneId, GroupId}, SceneId, State) ->
    SceneInfoM = get_scene_infos_kf({ZoneId, GroupId}, State),
    SceneInfo = maps:get(SceneId, SceneInfoM),
    {SceneInfo, SceneInfoM}.

% get_scene_info_kf({ZoneId, GroupId}, SceneId, State) ->
%     {SceneInfo, _} = gex_scene_info_kf({ZoneId, GroupId}, SceneId, State),
%     SceneInfo.

set_scene_info_kf({ZoneId, GroupId}, SceneId, SceneInfo, SceneInfoM, State) ->
    NSceneInfoM = maps:put(SceneId, SceneInfo, SceneInfoM),
    set_scene_infos_kf({ZoneId, GroupId}, NSceneInfoM, State).

%% 三级数据

get_server_group(SerId, ZoneId, State) ->
    {S2MG, _, _} = get_zone_map(ZoneId, State),
    {_, GroupId} = maps:get(SerId, S2MG),
    GroupId.

get_server_mod(SerId, ZoneId, State) ->
    {S2MG, _, _} = get_zone_map(ZoneId, State),
    {SerMod, _} = maps:get(SerId, S2MG),
    SerMod.

gex_group_servers({ZoneId, GroupId}, State) ->
    {Tuple, GroupMap} = gex_zone_map(ZoneId, State),
    {_, G2S, _} = Tuple,
    Servers = maps:get(GroupId, G2S),
    {Servers, Tuple, GroupMap}.

get_group_servers({ZoneId, GroupId}, State) ->
    {Servers, _, _} = gex_group_servers({ZoneId, GroupId}, State),
    Servers.

set_group_servers({ZoneId, GroupId}, Servers, Tuple, GroupMap, State) ->
    {S2MG, G2S, G2M} = Tuple,
    NG2S = maps:put(GroupId, Servers, G2S),
    NTuple = {S2MG, NG2S, G2M},
    set_zone_map(ZoneId, NTuple, GroupMap, State).

gex_boss_list_local(SceneId, State) ->
    {SceneInfo, SceneInfoM} = gex_scene_info_local(SceneId, State),
    #scene_info{boss_info = BossList} = SceneInfo,
    {BossList, SceneInfo, SceneInfoM}.

set_boss_list_local(BossList, SceneId, SceneInfo, SceneInfoM, State) ->
    NSceneInfo = SceneInfo#scene_info{boss_info = BossList},
    set_scene_info_local(SceneId, NSceneInfo, SceneInfoM, State).

gex_boss_list_kf({ZoneId, GroupId}, SceneId, State) ->
    {SceneInfo, SceneInfoM} = gex_scene_info_kf({ZoneId, GroupId}, SceneId, State),
    #scene_info{boss_info = BossList} = SceneInfo,
    {BossList, SceneInfo, SceneInfoM}.

set_boss_list_kf({ZoneId, GroupId}, BossList, SceneId, SceneInfo, SceneInfoM, State) ->
    NSceneInfo = SceneInfo#scene_info{boss_info = BossList},
    set_scene_info_kf({ZoneId, GroupId}, SceneId, NSceneInfo, SceneInfoM, State).

%% 四级数据

gex_server(SerId, ZoneId, State) ->
    GroupId = get_server_group(SerId, ZoneId, State),
    {Servers, Tuple, GroupMap} = gex_group_servers({ZoneId, GroupId}, State),
    Server = lists:keyfind(SerId, #zone_base.server_id, Servers),
    {Server, GroupId, Servers, Tuple, GroupMap}.

% get_server(SerId, ZoneId, State) ->
%     {Server, _, _, _, _} = gex_server(SerId, ZoneId, State),
%     Server.

set_server(Server, ZoneId, GroupId, Servers, Tuple, GroupMap, State) ->
    #zone_base{server_id = SerId} = Server,
    NServers = lists:keyreplace(SerId, #zone_base.server_id, Servers, Server),
    set_group_servers({ZoneId, GroupId}, NServers, Tuple, GroupMap, State).

gex_boss_info_local(BossUId, SceneId, State) ->
    {BossList, SceneInfo, SceneInfoM} = gex_boss_list_local(SceneId, State),
    BossInfo = lists:keyfind(BossUId, #boss_info.boss_uid, BossList),
    {BossInfo, BossList, SceneInfo, SceneInfoM}.

get_boss_info_local(BossUId, SceneId, State) ->
    {BossInfo, _, _, _} = gex_boss_info_local(BossUId, SceneId, State),
    BossInfo.

set_boss_info_local(BossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State) ->
    #boss_info{boss_uid = BossUId} = BossInfo,
    NBossList = lists:keyreplace(BossUId, #boss_info.boss_uid, BossList, BossInfo),
    set_boss_list_local(NBossList, SceneId, SceneInfo, SceneInfoM, State).

gex_boss_info_kf({ZoneId, GroupId}, BossUId, SceneId, State) ->
    {BossList, SceneInfo, SceneInfoM} = gex_boss_list_kf({ZoneId, GroupId}, SceneId, State),
    BossInfo = lists:keyfind(BossUId, #boss_info.boss_uid, BossList),
    {BossInfo, BossList, SceneInfo, SceneInfoM}.

set_boss_info_kf({ZoneId, GroupId}, BossInfo, BossList, SceneId, SceneInfo, SceneInfoM, State) ->
    #boss_info{boss_uid = BossUId} = BossInfo,
    NBossList = lists:keyreplace(BossUId, #boss_info.boss_uid, BossList, BossInfo),
    set_boss_list_kf({ZoneId, GroupId}, NBossList, SceneId, SceneInfo, SceneInfoM, State).