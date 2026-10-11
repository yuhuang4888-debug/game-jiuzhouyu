%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服秘境大妖
%%% @end
%%% Created : 18. 11月 2022 14:48
%%%-------------------------------------------------------------------
-module(mod_great_demon).

-behaviour(gen_server).

%% API
-export([start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

-define(SERVER, ?MODULE).

-include("def_gen_server.hrl").
-include("kf_great_demon.hrl").
-include("boss.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_fun.hrl").

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 批量重新分区时，设置玩法禁止进入的标志位
start_zone_change() ->
    gen_server:cast(?MODULE, {'start_zone_change'}).

%% 批量重新分区时，取消玩法禁止进入的标志位
end_zone_change() ->
    gen_server:cast(?MODULE, {'end_zone_change'}).

%% game => kf 申请链接跨服时,同步对应区的怪物等数据到游戏节点
sync_server_data_to_game(ServerId, OpenTime) ->
    gen_server:cast(?MODULE, {'sync_server_data_to_game', ServerId, OpenTime}).

%% 玩家进入场景
enter(KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut) ->
    gen_server:cast(?MODULE, {'enter', KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut}).

%% 玩家退出场景
quit(Node, RoleId, Scene, ServerId) ->
    gen_server:cast(?MODULE, {'quit', Node, RoleId, Scene, ServerId}).

exit_great_demon(RoleId, Scene, ServerId)->
    gen_server:cast(?MODULE, {'exit_great_demon', RoleId, Scene, ServerId}).

%% 游戏节点主动请求数据
game_req_server_data(ServerId, _Node, _IsForce) ->
    gen_server:cast(?MODULE, {'game_req_server_data', ServerId, _Node, _IsForce}).

great_demon_boss_be_kill(SceneId, ScenePoolId, Mid, ServerId, Attrker, BelonWhos, MonArgs, Minfo, FirstAttr) ->
    great_demon_boss_be_kill([SceneId, ScenePoolId, Mid, ServerId, Attrker, BelonWhos, MonArgs, Minfo, FirstAttr]).

%% 怪物被击杀
great_demon_boss_be_kill(Args) ->
    [SceneId|_] = Args,
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_GREAT_DEMON ->
            gen_server:cast(?MODULE, {'great_demon_boss_be_kill', Args});
        _ ->
            skip
    end.

%% 增加掉落物拾取日志
boss_add_drop_log(DropServerId, RecordList) ->
    gen_server:cast(?MODULE, {'boss_add_drop_log', DropServerId, RecordList}).

%% 场景玩家被击杀后
player_die(AttackerInfo, DerInfo, Scene, X, Y) ->
    gen_server:cast(?MODULE, {'player_die', AttackerInfo, DerInfo, Scene, X, Y}).

%% 分区发生改变
zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone}).

%% 拾取的小跨服传闻
send_tv_after_pick_drop(ServerId, TvArgs) ->
    gen_server:cast(?MODULE, {'send_tv_after_pick_drop', ServerId, TvArgs}).

%% 合服处理
handle_merge_server(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'handle_merge_server', ServerId, MergeSerIds}).

%% 秘籍 - 创建特殊boss
gm_create_special_boss(ServerId, Scene) ->
    gen_server:cast(?MODULE, {'gm_create_special_boss', ServerId, Scene}).
    
%% 秘籍 - 刷新采集怪
gm_reinit_cl_boss(ServerId) ->
    gen_server:cast(?MODULE, {'gm_reinit_cl_boss', ServerId}).

gm_reinit_boss_be_kill(ServerId, Scene) ->
    gen_server:cast(?MODULE, {'gm_reinit_boss_be_kill', ServerId, Scene}).

%% 秘籍 - 修复重新刷怪
gm_fix_zone_change_error() ->
    gen_server:cast(?MODULE, {'gm_fix_zone_change_error'}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    do_init().

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

do_init() ->
    process_flag(trap_exit, true),
    {ok, #kf_great_demon_state{}}.

%%%===================================================================
%%% handle_cast
%%%===================================================================

do_handle_cast({'start_zone_change'}, State) ->
    NewState = lib_great_demon:start_zone_change(State),
    {noreply, NewState};

do_handle_cast({'end_zone_change'}, State) ->
    %% 同步分服状态到各个游戏节点
    NewState = State#kf_great_demon_state{ is_grouping = ?NOT_IN_GROUPING },
    mod_clusters_center:apply_to_all_node(mod_great_demon_local, end_zone_change, [], 100),
    {noreply, NewState};

%% 游戏节点链接跨服同步数据
do_handle_cast({'sync_server_data_to_game', ServerId, OpenTime}, State) ->
    NewState = lib_great_demon:sync_server_data_to_game(ServerId, OpenTime, State),
    {noreply, NewState};

%% 游戏节点主动请求玩法数据
do_handle_cast({'game_req_server_data', ServerId, _Node, _IsForce}, State) ->
    NewState = lib_great_demon:game_req_server_data(ServerId, State),
    {noreply, NewState};

%% 怪物被击杀或采集怪被采集
do_handle_cast({'great_demon_boss_be_kill', Args}, State) ->
    case State#kf_great_demon_state.is_grouping of
        ?IN_GROUPING ->
            NewState = State;
        _ ->
            NewState = lib_great_demon:great_demon_boss_be_kill(Args, State)
    end,
    {noreply, NewState};

%% 玩家进入场景
do_handle_cast({'enter', KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut}, State) ->
    NewState = lib_great_demon:enter(KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut, State),
    {noreply, NewState};

%% 玩家退出场景
do_handle_cast({'quit', Node, RoleId, Scene, ServerId}, State) ->
    NewState = lib_great_demon:quit(Node, RoleId, Scene, ServerId, State),
    {noreply, NewState};

do_handle_cast({'exit_great_demon', RoleId, Scene, ServerId}, State) ->
    NewState = lib_great_demon:exit_great_demon(RoleId, Scene, ServerId, State),
    {noreply, NewState};

%% 记录拾取掉落物的日志
do_handle_cast({'boss_add_drop_log', DropServerId, RecordList}, State) ->
    #kf_great_demon_state{ boss_state_map = AllZoneBossMap } = State,
    ZoneId = lib_clusters_center_api:get_zone(DropServerId),
    case maps:get(ZoneId, AllZoneBossMap, none) of
        none ->
            skip;
        _ ->
            %% 区域广播
            ?PRINT("1231~n", []),
            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, boss_add_drop_log, [RecordList])
    end,
    {noreply, State};

do_handle_cast({'player_die', AttackerInfo, DerInfo, Scene, X, Y}, State) ->
    NewState = lib_great_demon:player_die(AttackerInfo, DerInfo, Scene, X, Y, State),
    {noreply, NewState};

do_handle_cast({'gm_create_special_boss', ServerId, Scene}, State) ->
    NewState = lib_great_demon:gm_create_special_boss(ServerId, Scene, State),
    {noreply, NewState};

do_handle_cast({'gm_reinit_cl_boss', ServerId}, State) ->
    NewState = lib_great_demon:gm_reinit_cl_boss(ServerId, State),
    {noreply, NewState};

do_handle_cast({'gm_reinit_boss_be_kill', ServerId, Scene}, State) ->
    NewState = lib_great_demon:gm_reinit_boss_be_kill(ServerId, Scene, State),
    {noreply, NewState};

do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State)->
    NewState = lib_great_demon:zone_change(ServerId, OldZone, NewZone, State),
    {noreply, NewState};

do_handle_cast({'send_tv_after_pick_drop', ServerId, TvArgs}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #kf_great_demon_state{ boss_state_map = AllZoneBossMap } = State,
    case maps:get(ZoneId, AllZoneBossMap, none) of
        none ->
            skip;
        _ ->
            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, lib_chat, send_TV, TvArgs)
    end,
    {noreply, State};

do_handle_cast({'gm_fix_zone_change_error'}, State) ->
    #kf_great_demon_state{ boss_state_map = BossStateMap, role_map = RoleMap } = State,
    %% 首先清除场景内的怪物
    lib_great_demon:clear_all_scene_boss(BossStateMap),
    %% 清除场景内的玩家
    lib_great_demon:leave_scene_force(RoleMap),
    mod_clusters_center:apply_to_all_node(mod_great_demon_local, gm_fix_zone_change_error, [], 1000),
    {noreply, #kf_great_demon_state{ is_grouping = ?NOT_IN_GROUPING }};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% =================================
%% handle_info
%% =================================

%% 普通怪物的生成等
do_handle_info({'great_demon_boss_reborn', ZoneId, MonType, BossId}, State) ->
    NewState = lib_great_demon:great_demon_boss_reborn(ZoneId, MonType, BossId, State),
    {noreply, NewState};

%% 采集怪的重生
do_handle_info({'pick_boss_reborn', ZoneId, MonType, BossId}, State) ->
    NewState = lib_great_demon:pick_boss_reborn(ZoneId, MonType, BossId, State),
    {noreply, NewState};

%% 通知关注的玩家
do_handle_info({'great_demon_boss_remind', ZoneId, BossId}, State) ->
    NewState = lib_great_demon:great_demon_boss_remind(ZoneId, BossId, State),
    {noreply, NewState};

do_handle_info(_Info, State) ->
    ?ERR_MSG("no_match_info:~p", [_Info]),
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call(_Request, _From, _State) ->
    no_match.

%%%===================================================================
%%% Internal functions
%%%===================================================================

