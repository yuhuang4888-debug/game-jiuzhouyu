%% ---------------------------------------------------------------------------
%% @doc mod_decoration_boss_center.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss跨服进程
%% ---------------------------------------------------------------------------
-module(mod_decoration_boss_center).
-compile(export_all).

-behavious(gen_server).

-include("common.hrl").
-include("decoration_boss.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% 本地->跨服中心 Msg = [{start,args}]
call_center(Msg) ->
    mod_clusters_node:apply_call(?MODULE, call_mod, Msg).
cast_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, cast_mod, Msg).
info_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, info_mod, Msg).

%% 跨服中心分发到管理进程
call_mod(Msg) ->
    gen_server:call({global, ?MODULE}, Msg).
cast_mod(Msg) ->
    gen_server:cast({global, ?MODULE}, Msg).
info_mod(Msg) ->
    misc:get_global_pid(?MODULE) ! Msg.

%% 同步数据
sync_server_data(ServerId, OpTime) ->
    cast_mod({'sync_server_data', ServerId, OpTime}).

%% 连接到中心
center_connected(ServerId, MergeSerIds, OpTime) ->
    cast_mod({'center_connected', ServerId, MergeSerIds, OpTime}).

%% 修复重生
gm_fix_reborn() ->
    cast_mod({'gm_fix_reborn'}).

%% 区域开始重置
reset_start() ->
    cast_mod({'reset_start'}).

%% 区域结束重置
reset_end() ->
    cast_mod({'reset_end'}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_decoration_boss_center:init(),
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        ok ->
            {noreply, State};
        {ok, NewState} when is_record(NewState, decoration_boss_center) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 检查进入
do_handle_cast({'check_and_enter_boss', RoleId, ServerId, BossId, Type}, State) ->
    lib_decoration_boss_center:check_and_enter_boss(State, RoleId, ServerId, BossId, Type);

%% 进入
do_handle_cast({'enter_boss', Role}, State) ->
    lib_decoration_boss_center:enter_boss(State, Role);

%% 退出
do_handle_cast({'quit', RoleId, ServerId}, State) ->
    lib_decoration_boss_center:quit(State, RoleId, ServerId);

%% 检测进入
do_handle_cast({'check_and_enter_sboss', RoleId, ServerId, EnterType}, State) ->
    lib_decoration_boss_center:check_and_enter_sboss(State, RoleId, ServerId, EnterType);

%% 进入特殊boss
do_handle_cast({'enter_sboss', Role}, State) ->
    lib_decoration_boss_center:enter_sboss(State, Role);

%% 战斗信息
do_handle_cast({'send_battle_info', RoleId, ServerId}, State) ->
    lib_decoration_boss_center:send_battle_info(State, RoleId, ServerId);

%% 同步数据
do_handle_cast({'sync_server_data', ServerId, OpTime}, State) ->
    lib_decoration_boss_center:sync_server_data(State, ServerId, OpTime);

%% 连接到中心
do_handle_cast({'center_connected', ServerId, MergeSerIds, OpTime}, State) ->
    lib_decoration_boss_center:center_connected(State, ServerId, MergeSerIds, OpTime);

%% 击杀怪物
do_handle_cast({'kill_mon', ZoneId, MonArgs, FirstAtter}, State) ->
    lib_decoration_boss_center:kill_mon(State, ZoneId, MonArgs, FirstAtter);

%% 击杀怪物
do_handle_cast({'local_kill_mon', ServerId, MonId}, State) ->
    lib_decoration_boss_center:local_kill_mon(State, ServerId, MonId);

%% 对怪物造成伤害
do_handle_cast({'hurt_mon', ScenePoolId, BossId, BossHurt}, State) ->
    lib_decoration_boss_center:hurt_mon(State, ScenePoolId, BossId, BossHurt);

%% 玩家死亡
do_handle_cast({'player_die', RoleId, ServerId}, State) ->
    lib_decoration_boss_center:player_die(State, RoleId, ServerId);

%% 玩家复活
do_handle_cast({'revive', RoleId, ServerId}, State) ->
    lib_decoration_boss_center:revive(State, RoleId, ServerId);

%% 日志
do_handle_cast({'add_drop_log', RoleId, ServerId, ServerNum, Name, BossId, GoodsInfoL}, State) ->
    lib_decoration_boss_center:add_drop_log(State, RoleId, ServerId, ServerNum, Name, BossId, GoodsInfoL);

%% 特殊boss的个人伤害记录
do_handle_cast({'send_role_sboss_hurt_info', RoleId, ServerId}, State) ->
    lib_decoration_boss_center:send_role_sboss_hurt_info(State, RoleId, ServerId);

%% 区域开始重置
do_handle_cast({'reset_start'}, State) ->
    lib_decoration_boss_center:reset_start(State);

%% 区域结束重置
do_handle_cast({'reset_end'}, State) ->
    lib_decoration_boss_center:reset_end(State);

%% 特殊boss死亡复活
do_handle_cast({'gm_sboss_ref'}, State) ->
    lib_decoration_boss_center:gm_sboss_ref(State);

%% 普通死亡复活
do_handle_cast({'gm_reborn_ref'}, State) ->
    lib_decoration_boss_center:gm_reborn_ref(State);

%% 秘籍修复复活
do_handle_cast({'gm_fix_reborn'}, State) ->
    lib_decoration_boss_center:gm_fix_reborn(State);

%% 
do_handle_cast({'set_enter_type', RoleId, EnterType}, State) ->
    lib_decoration_boss_center:set_enter_type(State, RoleId, EnterType);

do_handle_cast(_Msg, State) -> 
    {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, decoration_boss_center) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% boss 复活
do_handle_info({'reborn_ref', ZoneId, BossId}, State) ->
    lib_decoration_boss_center:reborn_ref(State, ZoneId, BossId);

%% boss 离开
do_handle_info({'leave_ref', ZoneId, BossId}, State) ->
    lib_decoration_boss_center:leave_ref(State, ZoneId, BossId);

%% 特殊boss 离开
do_handle_info({'sleave_ref', ZoneId}, State) ->
    lib_decoration_boss_center:sleave_ref(State, ZoneId);

%% 特殊boss 
do_handle_info({'sboss_ref'}, State) ->
    lib_decoration_boss_center:sboss_ref(State);

%% 死亡定时器
do_handle_info({'die_ref', RoleId, ServerId, SceneId}, State) ->
    lib_decoration_boss_center:die_ref(State, RoleId, ServerId, SceneId);

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

do_handle_call(_Request, _State) -> 
    {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> 
    {ok, State}.