%% ---------------------------------------------------------------------------
%% @doc mod_decoration_boss_local.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss本地进程
%% ---------------------------------------------------------------------------
-module(mod_decoration_boss_local).
-compile(export_all).

-behavious(gen_server).

-include("common.hrl").
-include("decoration_boss.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% 幻饰boss信息
send_info(RoleId, Count, AssistCount, BuyCount, AddCount, InBuff) ->
    gen_server:cast(?MODULE, {'send_info', RoleId, Count, AssistCount, BuyCount, AddCount, InBuff}).

%% 检查
check_and_enter_boss(RoleId, ServerId, BossId, Type) ->
    gen_server:cast(?MODULE, {'check_and_enter_boss', RoleId, ServerId, BossId, Type}).

%% 进入
enter_boss(Role) ->
    gen_server:cast(?MODULE, {'enter_boss', Role}).

quit(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'quit', RoleId, ServerId}).

%% 掉落记录
send_log_list(RoleId) ->
    gen_server:cast(?MODULE, {'send_log_list', RoleId}).

%% 进入特殊boss
enter_sboss(Role) ->
    gen_server:cast(?MODULE, {'enter_sboss', Role}).

%% 战斗信息
send_battle_info(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'send_battle_info', RoleId, ServerId}).

%% 同步数据
sync_update(CBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList) ->
    gen_server:cast(?MODULE, {'sync_update', CBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList}).

%% 同步数据
sync_update(KvList) ->
    gen_server:cast(?MODULE, {'sync_update', KvList}).

%% 请求同步数据
ask_sync_update() ->
    gen_server:cast(?MODULE, {'ask_sync_update'}).

%% 击杀怪物
kill_mon(MonArgs, FirstAttr) ->
    gen_server:cast(?MODULE, {'kill_mon', MonArgs, FirstAttr}).

%% 对怪物造成伤害
hurt_mon(MonId, BossHurt) ->
    gen_server:cast(?MODULE, {'hurt_mon', MonId, BossHurt}).

%% 移除玩家信息
remove_role(RoleId) ->
    gen_server:cast(?MODULE, {'remove_role', RoleId}).

%% 玩家死亡
player_die(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'player_die', RoleId, ServerId}).

%% 复活
revive(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'revive', RoleId, ServerId}).

%% 区域开始重置
reset_start() ->
    gen_server:cast(?MODULE, {'reset_start'}).

%% 区域结束重置
reset_end() ->
    gen_server:cast(?MODULE, {'reset_end'}).

%% 普通boss复活
gm_reborn_ref() ->
    gen_server:cast(?MODULE, {'gm_reborn_ref'}).

%% 修复重生
gm_fix_reborn() ->
    gen_server:cast(?MODULE, {'gm_fix_reborn'}).

%% gm停止当前活动
%% @param Status 0:停止活动， 场景活动玩家被提出
%% @param Status 1:恢复活动， 场景活动玩家被提出
cheats_stop_act(Status) ->
    gen_server:cast(?MODULE, {'cheats_stop_act', Status}).

get_role_info(RoleId) ->
    gen_server:call(?MODULE, {'get_role_info', RoleId}).

%% 设置进入类型
set_enter_type(RoleId, EnterType) ->
    gen_server:cast(?MODULE, {'set_enter_type', RoleId, EnterType}).

init_sync_callback(single_play) ->
    gen_server:cast(?MODULE, {'init_sync_callback', single_play}).
init_sync_callback(SyncCBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList) ->
    gen_server:cast(?MODULE, {'init_sync_callback', [SyncCBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_decoration_boss_local:init(),
    % 15 秒后再请求同步一次数据
    InitRef = util:send_after(undefined, ?SYNC_TIME_REF, self(), 'init_sync'),
    {ok, State#decoration_boss_local{init_def = InitRef}}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        ok ->
            {noreply, State};
        {ok, NewState} when is_record(NewState, decoration_boss_local) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 跨服中心同步数据
do_handle_cast({'init_sync_callback', List}, State) ->
    lib_decoration_boss_local:init_sync_callback(State, List);

%% 幻饰boss信息
do_handle_cast({'send_info', RoleId, Count, AssistCount, BuyCount, AddCount, InBuff}, State) ->
    lib_decoration_boss_local:send_info(State, RoleId, Count, AssistCount, BuyCount, AddCount, InBuff);

%% 检查进入
do_handle_cast({'check_and_enter_boss', RoleId, ServerId, BossId, Type}, State) ->
    lib_decoration_boss_local:check_and_enter_boss(State, RoleId, ServerId, BossId, Type);

%% 进入
do_handle_cast({'enter_boss', Role}, State) ->
    lib_decoration_boss_local:enter_boss(State, Role);

%% 退出
do_handle_cast({'quit', RoleId, ServerId}, State) ->
    lib_decoration_boss_local:quit(State, RoleId, ServerId);

%% 掉落记录
do_handle_cast({'send_log_list', RoleId}, State) ->
    lib_decoration_boss_local:send_log_list(State, RoleId);

%% 进入特殊boss
do_handle_cast({'enter_sboss', Role}, State) ->
    lib_decoration_boss_local:enter_sboss(State, Role);

%% 战斗信息
do_handle_cast({'send_battle_info', RoleId, ServerId}, State) ->
    lib_decoration_boss_local:send_battle_info(State, RoleId, ServerId);

%% 同步数据
do_handle_cast({'sync_update', CBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList}, State) ->
    lib_decoration_boss_local:sync_update(State, CBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList);

%% 同步数据
do_handle_cast({'sync_update', KvList}, State) ->
    lib_decoration_boss_local:sync_update(State, KvList);

%% 击杀怪物
do_handle_cast({'kill_mon', MonArgs, FirstAttr}, State) ->
    lib_decoration_boss_local:kill_mon(State, MonArgs, FirstAttr);

%% 对怪物造成伤害
do_handle_cast({'hurt_mon', MonId, BossHurt}, State) ->
    lib_decoration_boss_local:hurt_mon(State, MonId, BossHurt);

%% 移除玩家信息
do_handle_cast({'remove_role', RoleId}, State) ->
    lib_decoration_boss_local:remove_role(State, RoleId);

%% 玩家死亡
do_handle_cast({'player_die', RoleId, ServerId}, State) ->
    lib_decoration_boss_local:player_die(State, RoleId, ServerId);

%% 复活
do_handle_cast({'revive', RoleId, ServerId}, State) ->
    lib_decoration_boss_local:revive(State, RoleId, ServerId);

%% 请求同步数据
do_handle_cast({'ask_sync_update'}, State) ->
    spawn(fun() ->
        timer:sleep(urand:rand(1000, 10000)),
        ServerId = config:get_server_id(),
        OpTime = util:get_open_time(),
        mod_decoration_boss_center:cast_center([{'sync_server_data', ServerId, OpTime}])
    end),
    {ok, State};

%% 区域开始重置
do_handle_cast({'reset_start'}, State) ->
    lib_decoration_boss_local:reset_start(State);

%% 区域结束重置
do_handle_cast({'reset_end'}, State) ->
    lib_decoration_boss_local:reset_end(State);

%% 普通boss复活
do_handle_cast({'gm_reborn_ref'}, State) ->
    lib_decoration_boss_local:gm_reborn_ref(State);

%% 秘籍修复复活
do_handle_cast({'gm_fix_reborn'}, State) ->
    lib_decoration_boss_local:gm_fix_reborn(State);

do_handle_cast({'cheats_stop_act', Status}, State) ->
    lib_decoration_boss_local:cheats_stop_act(State, Status);

do_handle_cast({'set_enter_type', RoleId, EnterType}, State) ->
    lib_decoration_boss_local:set_enter_type(State, RoleId, EnterType);

do_handle_cast(_Msg, State) ->
    {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, decoration_boss_local) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info('init_sync', State) ->
    #decoration_boss_local{init_def = OldInitRef} = State,
    ServerId = config:get_server_id(),
    OpTime = util:get_open_time(),
    mod_decoration_boss_center:cast_center([{'sync_server_data', ServerId, OpTime}]),
    InitRef = util:send_after(OldInitRef, ?SYNC_TIME_REF, self(), 'init_sync'),
    {ok, State#decoration_boss_local{init_def = InitRef}};

%% boss 复活
do_handle_info({'reborn_ref', BossId}, State) ->
    lib_decoration_boss_local:reborn_ref(State, BossId);

%% boss 离开
do_handle_info({'leave_ref', BossId}, State) ->
    lib_decoration_boss_local:leave_ref(State, BossId);

%% 死亡定时器
do_handle_info({'die_ref', RoleId, ServerId, SceneId}, State) ->
    lib_decoration_boss_local:die_ref(State, RoleId, ServerId, SceneId);

do_handle_info(_Info, State) ->
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'get_role_info', RoleId}, State) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #decoration_boss_role{enter_type = EnterType} ->
            Reply = {ok, EnterType};
        _ ->
            Reply = false
    end,
    {ok, Reply};

do_handle_call(_Request, _State) ->
    {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.