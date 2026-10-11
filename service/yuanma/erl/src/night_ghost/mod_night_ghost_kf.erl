%%% ------------------------------------------------------------------------------------------------
%%% @doc            mod_night_ghost_kf.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行跨服状态
%%% ------------------------------------------------------------------------------------------------
-module(mod_night_ghost_kf).

-behaviour(gen_server).

-include("chat.hrl").
-include("clusters.hrl").
-include("common.hrl").
-include("def_gen_server.hrl").
-include("night_ghost.hrl").

%% 跨服通用数据相关
-export([
    call_center/1, cast_center/1, info_center/1, call/1, cast/1, info/1,
    center_connected/1, sync_zone_group/1, server_info_change/2
]).

%% 活动数据相关
-export([start_link/0, boss_be_killed/4]).

%% 回调
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%% ====================================== exported functions ======================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% boss被击杀
boss_be_killed(Minfo, Klist, Atter, AtterSign) ->
    gen_server:cast(?MODULE, {'boss_be_killed', Minfo, Klist, Atter, AtterSign}).

%% ===============
%% 跨服通用数据相关
%% ===============

%% 游戏服 -> 跨服
call_center(Msg) -> mod_clusters_node:apply_call(?MODULE, call, [Msg]).

cast_center(Msg) -> mod_clusters_node:apply_cast(?MODULE, cast, [Msg]).

info_center(Msg) -> mod_clusters_node:apply_info(?MODULE, info, [Msg]).

%% 跨服接收数据请求
call(Msg) -> gen_server:call(?MODULE, Msg).

cast(Msg) -> gen_server:cast(?MODULE, Msg).

info(Msg) -> ?MODULE ! Msg.

%% 游戏服确认连接到跨服
center_connected(ServerId) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId}).

%% 区组数据同步
sync_zone_group(InfoList) ->
    gen_server:cast(?MODULE, {'sync_zone_group', InfoList}).

%% 游戏服信息变更
server_info_change(ServerId, KvList) ->
    gen_server:cast(?MODULE, {'server_info_change', ServerId, KvList}).

%% ===========
%% 活动数据相关
%% ===========

%%% ====================================== callback functions ======================================

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

%%% ======================================= respond functions ======================================

%% ===========
%% init/terminate/code_change
%% ===========

do_init(_Args) ->
    {ok, #night_ghost_state_kf{}}.

do_terminate(_Reason, _State) ->
    ?ERR("~p terminate for ~p~n", [?MODULE, _Reason]),
    ok.

do_code_change(_OldVsn, _State, _Extra) ->
    {ok, _State}.

%% ===========
%% handle_call
%% ===========

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% ===========
%% handle_cast
%% ===========

%% 游戏服确认连接到跨服
do_handle_cast({'center_connected', SerId}, State) ->
    #night_ghost_state_kf{group_map = GroupMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(SerId),
    case maps:get(ZoneId, State#night_ghost_state_kf.group_map, false) of
        {S2G, G2S, _} ->
            {SerMod, GroupId} = maps:get(SerId, S2G),
            GroupServers = maps:get(GroupId, G2S),
            SyncData = [
                {zone_id, ZoneId}, {group_id, GroupId}, {mod, SerMod}, {group_servers, GroupServers},
                {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]}
            ],
            lib_night_ghost_mod:sync_data_to_group([{ZoneId, GroupId}], GroupMap, SyncData);
        _ -> % 区组数据还未同步
            skip
    end,
    {noreply, State};

%% 区组数据同步(跨服启动时和分区变更时会调用)
do_handle_cast({'sync_zone_group', InfoList}, State) ->
    % 按区域zone_id处理
    F1 = fun({ZoneId, {Servers, GroupInfo}}, AccMap) ->
        #zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
        % 按区域内各分组group_id处理
        F2 = fun(ModGroupData, {AccS2G, AccG2S, AccG2M}) ->
            #zone_mod_group_data{group_id = GroupId, mod = SerMod, server_ids = ServerIds} = ModGroupData,

            % 计算该分组本服与mod跨服模式、group_id分组映射
            Map = maps:from_list([{SerId, {SerMod, GroupId}} || SerId <- ServerIds]),
            NAccS2G = maps:merge(AccS2G, Map),

            % 计算该分组group_id与本服映射
            ServerZones = [
                Server
             || Server <- Servers, lists:member(Server#zone_base.server_id, ServerIds)
            ],
            NAccG2S = AccG2S#{GroupId => ServerZones},

            % group_id与mod跨服模式映射
            NAccG2M = AccG2M#{GroupId => SerMod},

            % 同步分组信息到本服
            SyncData = [
                {zone_id, ZoneId}, {group_id, GroupId}, {mod, SerMod}, {group_servers, ServerZones},
                {update_cache, [?CACHE_NG_ACT_INFO, ?CACHE_NG_BOSS_INFO]}
            ],
            lib_night_ghost_mod:sync_data_to_servers(ServerZones, SyncData),

            {NAccS2G, NAccG2S, NAccG2M}
        end,
        {S2G, G2S, G2M} = lists:foldl(F2, {#{}, #{}, #{}}, GroupModServers),
        AccMap#{ZoneId => {S2G, G2S, G2M}}
    end,
    GroupMap = lists:foldl(F1, #{}, InfoList),
    {noreply, State#night_ghost_state_kf{group_map = GroupMap}};

%% 游戏服信息变更
do_handle_cast({'server_info_change', ServerId, KvList}, State) ->
    NewState = lib_night_ghost_mod:server_info_change(ServerId, KvList, State),
    {noreply, NewState};

%% 活动开启
do_handle_cast({'act_start', _, _}, #night_ghost_state_kf{state = ?NG_ACT_OPEN} = State) ->
    {noreply, State};
do_handle_cast({'act_start', ModId, ModSub}, State) ->
    NewState = lib_night_ghost_mod:act_start(ModId, ModSub, State),
    {noreply, NewState};

%% boss被击杀
do_handle_cast({'boss_be_killed', _, _, _, _}, #night_ghost_state_kf{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_cast({'boss_be_killed', Minfo, Klist, Atter, AtterSign}, State) ->
    NewState = lib_night_ghost_mod:boss_be_killed(Minfo, Klist, Atter, AtterSign, State),
    {noreply, NewState};

%% boss召集奖励
do_handle_cast({'boss_broadcast_reward', _, _, _, _, _}, #night_ghost_state_kf{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_cast({'boss_broadcast_reward', SerId, RoleId, Channel, SceneId, BossUId}, State) ->
    NewState = lib_night_ghost_mod:boss_broadcast_reward(SerId, RoleId, Channel, SceneId, BossUId, State),
    {noreply, NewState};

%% 发送小跨服信息
do_handle_cast({'send_chat_msg', ?CHAT_CHANNEL_NG, [SerId, SendId, ReceiveId, Chat, BinData]}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(SerId),
    GroupId = lib_night_ghost_mod:get_server_group(SerId, ZoneId, State),
    Servers = lib_night_ghost_mod:get_group_servers({ZoneId, GroupId}, State),
    [
        begin
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_all, [BinData]),
            mod_clusters_center:apply_cast(ServerId, mod_chat_cache, save_cache, [?CHAT_CHANNEL_NG, SendId, ReceiveId, Chat]) % 缓存保存到本服
        end
     || #zone_base{server_id = ServerId} <- Servers
    ],
    {noreply, State};

%% 活动结束(游戏服消息)
do_handle_cast({'act_end'}, #night_ghost_state_kf{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_cast({'act_end'}, State) ->
    NewState = lib_night_ghost_mod:act_end(State),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% ===========
%% handle_info
%% ===========

% %% 活动结束(自身进程消息)
% do_handle_info({'act_end'}, State) ->
%     {_, NewState} = do_handle_cast({'act_end'}, State),
%     {noreply, NewState};

do_handle_info(_Info, State) ->
    {noreply, State}.

%%% ============================================== gm ==============================================
