%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服秘境大妖 - 游戏节点进程
%%% @end
%%% Created : 18. 11月 2022 14:48
%%%-------------------------------------------------------------------
-module(mod_great_demon_local).

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
-include("predefine.hrl").
-include("common.hrl").

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

sync_kf_server_data(ZoneBossMap, IsGrouping) ->
    gen_server:cast(?MODULE, {'sync_kf_server_data', ZoneBossMap, IsGrouping}).

zone_change(ZoneBossMap, IsGrouping) ->
    gen_server:cast(?MODULE, {'zone_change', ZoneBossMap, IsGrouping}).

%% KF => game
start_zone_change() ->
    gen_server:cast(?MODULE, {'start_zone_change'}).

%% 批量重新分区时，取消玩法禁止进入的标志位
end_zone_change() ->
    gen_server:cast(?MODULE, {'end_zone_change'}).

%% 击杀怪物后增加疲劳值
update_role_tired_in_scene(BossId, RoleId) ->
    gen_server:cast(?MODULE, {'update_role_tired_in_scene', BossId, RoleId}).

%% kf 通知更新的怪物信息与增加击杀日志、新增的特殊boss
sync_boss_kill_and_log(Args) ->
    gen_server:cast(?MODULE, {'sync_boss_kill_and_log', Args}).

%% 通知本服关注了boss的玩家
great_demon_boss_remind(BossId) ->
    gen_server:cast(?MODULE, {'great_demon_boss_remind', BossId}).

%% 玩家关注/取关boss
remind_great_demon_boss(RoleId, BossId, OpType, IsAuto) ->
    gen_server:cast(?MODULE, {'remind_great_demon_boss', RoleId, BossId, OpType, IsAuto}).

%% 获取怪物信息
get_great_demon_boss_info(RoleId, LessCount, AllCount) ->
    gen_server:cast(?MODULE, {'get_great_demon_boss_info', RoleId, LessCount, AllCount}).

%% 玩家进入场景(未进行检测)
enter_before_mod_check(BossId, RoleId) ->
    gen_server:cast(?MODULE, {'enter_before_mod_check', BossId, RoleId}).

%% 玩家通过检测后正常进程场景
enter_scene_after_check(RoleInfo, RoleId, BossType, BossId, Scene, X, Y, NeedOut) ->
    gen_server:cast(?MODULE, {'enter_scene_after_check', RoleInfo, RoleId, BossType, BossId, Scene, X, Y, NeedOut}).

%% 玩家退出场景
quit(Node, RoleId, Scene, ServerId, OldX, OldY) ->
    gen_server:cast(?MODULE, {'quit',Node, RoleId, Scene, ServerId, OldX, OldY}).

%% 单纯清理玩家定时器等数据
exit_great_demon(RoleId, Scene, ServerId) ->
    gen_server:cast(?MODULE, {'exit_great_demon', RoleId, Scene, ServerId}).

%% 玩家下线操作(暂时没看到需求，保留本服模式的处理方式)\
logout_great_demon(RoleId, Scene, ServerId, OldX, OldY) ->
    gen_server:cast(?MODULE, {'logout_great_demon', RoleId, Scene, ServerId, OldX, OldY}).

%% 获取boss击杀记录
get_boss_kill_log(RoleId, BossType, BossId) ->
    gen_server:cast(?MODULE, {'get_boss_kill_log', RoleId, BossType, BossId}).

%% 凌晨四点补发未领取的阶段性奖励
daily_clear_demon_kill() ->
    gen_server:cast(?MODULE, {'daily_clear_demon_kill'}).

%% 获取秘境领域阶段奖励状态
send_demon_kill_reward_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_demon_kill_reward_info', RoleId}).

%% 秘境领域阶段领取奖励
get_demon_kill_reward(RoleId, RoleLv, RewardId) ->
    gen_server:cast(?MODULE, {'get_demon_kill_reward', RoleId, RoleLv, RewardId}).

%% 发送领域内的宝箱信息
send_demon_box_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_demon_box_info', RoleId}).

%% 同步掉落日志
boss_add_drop_log(RecordList) ->
    gen_server:cast(?MODULE, {'boss_add_drop_log', RecordList}).

%% 获取掉落日志记录
get_boss_drop_log(RoleId) ->
    gen_server:cast(?MODULE, {'get_boss_drop_log', RoleId}).

get_boss_anger(RoleId) ->
    gen_server:cast(?MODULE, {'get_boss_anger', RoleId}).

%% 同步新生成的怪物信息
sync_boss_reborn_list(AddList) ->
    gen_server:cast(?MODULE, {'sync_boss_reborn_list', AddList}).

%% 被击杀的玩家增加疲劳
player_die_add_tried(BeKillRoleId) ->
    gen_server:cast(?MODULE, {'player_die_add_tried', BeKillRoleId}).

%% 秘籍 - 创建特殊boss
gm_create_special_boss(Scene) ->
    gen_server:cast(?MODULE, {'gm_create_special_boss', Scene}).

%% 秘籍 - 重置秘境领域采集怪
gm_reinit_cl_boss() ->
    gen_server:cast(?MODULE, {'gm_reinit_cl_boss'}).

%% 秘籍 - 立即刷新玩家当前所在场景中被击杀的怪物
gm_reinit_boss_be_kill(Scene) ->
    gen_server:cast(?MODULE, {'gm_reinit_boss_be_kill', Scene}).

reconnect(RoleId) ->
    gen_server:cast(?MODULE, {'reconnect', RoleId}).

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
    DemonKill = lib_great_demon_sql:load_great_demon_kill(),
    {ok, #local_great_demon_state{ demon_kill = DemonKill }}.

%%%===================================================================
%%% handle_cast
%%%===================================================================

%%
do_handle_cast({'sync_kf_server_data', ZoneBossMap, IsGrouping}, State) ->
    NewState = State#local_great_demon_state{
        boss_state_map = ZoneBossMap, is_grouping = IsGrouping, sync_flag = ?SYNC_YES
    },
    {noreply, NewState};

do_handle_cast({'zone_change', ZoneBossMap, IsGrouping}, State) ->
    NewState = State#local_great_demon_state{
        boss_state_map = ZoneBossMap,
        is_grouping = IsGrouping,
        sync_flag = ?SYNC_YES,
        drop_list = []         %% 分区时候，掉落记录统一清理（与策划商定）
    },
    {noreply, NewState};

do_handle_cast({'start_zone_change'}, State) ->
    #local_great_demon_state{ role_info_map = RoleMap } = State,
    %% 剔除场景内的玩家,同时清空玩家关于疲劳值的定时器
    ChangeSceneArgs = [{collect_checker, undefined}, {pk, {?PK_PEACE, true}}],
    Fun = fun(RoleId, #local_role_info{tried_ref = TriedRef}) ->
        lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, ChangeSceneArgs),
        util:cancel_timer(TriedRef),
        timer:sleep(300)
    end,
    maps:map(Fun, RoleMap),
    %% 清空已有的玩家信息，怪物信息等
    NewState = #local_great_demon_state{ is_grouping = ?IN_GROUPING },
    {noreply, NewState};

do_handle_cast({'end_zone_change'}, State) ->
    NewState = State#local_great_demon_state{ is_grouping = ?NOT_IN_GROUPING },
    {noreply, NewState};

do_handle_cast({'update_role_tired_in_scene', BossId, RoleId}, State) ->
    NewState = lib_great_demon_local:update_role_tired_in_scene(BossId, RoleId, State),
    {noreply, NewState};

%% 通知怪物重生
do_handle_cast({'great_demon_boss_remind', BossId}, State) ->
    lib_great_demon_local:great_demon_boss_remind(BossId, State),
    {noreply, State};

%% 玩家关注boss
do_handle_cast({'remind_great_demon_boss', RoleId, BossId, OpType, IsAuto}, State) ->
    NewState = lib_great_demon_local:remind_great_demon_boss(RoleId, BossId, OpType, IsAuto, State),
    {noreply, NewState};

%%
do_handle_cast({'get_great_demon_boss_info', RoleId, LessCount, AllCount}, State) ->
    lib_great_demon_local:get_great_demon_boss_info(RoleId, LessCount, AllCount, State),
    {noreply, State};

%% 进行基础检测
do_handle_cast({'enter_before_mod_check',  BossId, RoleId}, State) ->
    lib_great_demon_local:enter_before_mod_check(BossId, RoleId, State),
    {noreply, State};

%% 通过基础检测
do_handle_cast({'enter_scene_after_check', RoleInfo, RoleId, BossType, BossId, Scene, X, Y, NeedOut}, State) ->
    NewState = lib_great_demon_local:enter_scene_after_check(RoleInfo, RoleId, BossType, BossId, Scene, X, Y, NeedOut, State),
    {noreply, NewState};

%% 玩家退出场景清空平疲劳定时器
do_handle_cast({'quit',Node, RoleId, Scene, ServerId,  OldX, OldY}, State) ->
    NewState = lib_great_demon_local:quit(Node, RoleId, Scene, ServerId, OldX, OldY, State),
    {noreply, NewState};

%% 单纯清零玩家数据
do_handle_cast({'exit_great_demon', RoleId, Scene, ServerId}, State) ->
    NewState = lib_great_demon_local:exit_great_demon(RoleId, Scene, ServerId, State),
    {noreply, NewState};

do_handle_cast({'sync_boss_kill_and_log', Args}, State) ->
    NewState = lib_great_demon_local:sync_boss_kill_and_log(Args, State),
    {noreply, NewState};

%% 凌晨四点结算阶段奖励清空
do_handle_cast({'daily_clear_demon_kill'}, State) ->
    NewState = lib_great_demon_local:daily_clear_demon_kill(State),
    {noreply, NewState};

%% 获取阶段性奖励信息
do_handle_cast({'send_demon_kill_reward_info', RoleId}, State) ->
    lib_great_demon_local:send_demon_kill_reward_info(RoleId, State),
    {noreply, State};

%% 领取阶段奖励
do_handle_cast({'get_demon_kill_reward', RoleId, RoleLv, RewardId}, State) ->
    NewState = lib_great_demon_local:get_demon_kill_reward(RoleId, RoleLv, RewardId, State),
    {noreply, NewState};

%% 发送场景宝箱信息
do_handle_cast({'send_demon_box_info', RoleId}, State) ->
    lib_great_demon_local:send_demon_box_info(RoleId, State),
    {noreply, State};

%% 玩家真实登出游戏，清理玩家定时器数据
do_handle_cast({'logout_great_demon', RoleId, Scene, ServerId, OldX, OldY}, State) ->
    NewState = lib_great_demon_local:logout_great_demon(RoleId, Scene, ServerId, OldX, OldY, State),
    {noreply, NewState};

%% 获取怪物击杀日志
do_handle_cast({'get_boss_kill_log', RoleId, BossType, BossId}, State) ->
    lib_great_demon_local:get_boss_kill_log(RoleId, BossType, BossId, State),
    {noreply, State};

%%
do_handle_cast({'boss_add_drop_log', RecordList}, State) ->
    #local_great_demon_state{ drop_list = OldDropList} = State,
    NewState = State#local_great_demon_state{
        drop_list = lists:sublist(RecordList ++ OldDropList, ?BOSS_TYPE_KV_LOG_GOODS_LEN(?BOSS_TYPE_GLOBAL))
    },
    {noreply, NewState};

%%
do_handle_cast({'get_boss_drop_log', RoleId}, State) ->
    #local_great_demon_state{
        drop_list = DropList
    } = State,
    {ok, Bin} = pt_460:write(46046, [?BOSS_TYPE_KF_GREAT_DEMON, DropList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({'gm_create_special_boss', Scene}, State) ->
    mod_clusters_node:apply_cast(mod_great_demon, gm_create_special_boss, [config:get_server_id(), Scene]),
    {noreply, State};

do_handle_cast({'gm_reinit_cl_boss'}, State) ->
    mod_clusters_node:apply_cast(mod_great_demon, gm_reinit_cl_boss, [config:get_server_id()]),
    {noreply, State};

do_handle_cast({'gm_reinit_boss_be_kill', Scene}, State) ->
    mod_clusters_node:apply_cast(mod_great_demon, gm_reinit_boss_be_kill, [config:get_server_id(), Scene]),
    {noreply, State};

do_handle_cast({'sync_boss_reborn_list', AddBossList}, State) ->
    #local_great_demon_state{ boss_state_map = AllBossMap } = State,
    Fun = fun(#great_demon_boss_status{ boss_id = BossId } = AddBoss, TemAllBossMap) ->
        maps:put(BossId, AddBoss,TemAllBossMap)
    end,
    NewAllBossMap = lists:foldl(Fun, AllBossMap, AddBossList),
    {noreply, State#local_great_demon_state{ boss_state_map = NewAllBossMap }};

do_handle_cast({'get_boss_anger', RoleId}, State) ->
    #local_great_demon_state{ role_info_map = RoleInfoMap } = State,
    case maps:get(RoleId, RoleInfoMap, none)  of
        #local_role_info{ tried = RoleTried } -> ok;
        _ -> RoleTried = 0
    end,
    case data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON) of
        #boss_type{ max_anger = MaxTried } -> ok;
        _ -> MaxTried = 100
    end,
    lib_server_send:send_to_uid(RoleId, pt_460, 46005, [RoleTried, MaxTried]),
    {noreply, State};

do_handle_cast({'player_die_add_tried', BeKillRoleId}, State) ->
    NewState = lib_great_demon_local:player_die_add_tried(BeKillRoleId, State),
    {noreply, NewState};

do_handle_cast({'reconnect', RoleId}, State) ->
    NewState = lib_great_demon_local:role_reconnect(RoleId, State),
    {noreply, NewState};

do_handle_cast({'gm_fix_zone_change_error'}, _State) ->
    put('great_demon_boss_sync', 1),
    Node = mod_disperse:get_clusters_node(),
    ServerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_great_demon, game_req_server_data, [ServerId, Node, ?FORCE_UP]),
    DemonKill = lib_great_demon_sql:load_great_demon_kill(),
    {noreply, #local_great_demon_state{ demon_kill = DemonKill }};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% ========================================
%% do_handle_info()
%% ========================================

do_handle_info({'tried_tickout_delay', RoleId, BossId}, State) ->
    NewState = lib_great_demon_local:tried_tickout_delay(RoleId, BossId, State),
    {noreply, NewState};

do_handle_info({'tried_tick_out', RoleId, BossId}, State) ->
    NewState = lib_great_demon_local:tried_tick_out(RoleId, BossId, State),
    {noreply, NewState};

do_handle_info({'tried_add', RoleId, BossId}, State) ->
    NewState = lib_great_demon_local:tried_add(RoleId, BossId, State),
    {noreply, NewState};

do_handle_info(_Info, State) ->
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

