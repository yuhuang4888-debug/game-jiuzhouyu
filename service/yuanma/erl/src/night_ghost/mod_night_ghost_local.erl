%%% ------------------------------------------------------------------------------------------------
%%% @doc            mod_night_ghost_local.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行本服状态
%%% ------------------------------------------------------------------------------------------------
-module(mod_night_ghost_local).

-behaviour(gen_server).

-include("activitycalen.hrl").
-include("chat.hrl").
-include("clusters.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_gen_server.hrl").
-include("def_module.hrl").
-include("night_ghost.hrl").

%% 跨服通用数据相关
-export([sync_data/1]).

%% 活动数据相关
-export([
    start_link/0, act_start/2, act_end/0, send_act_info/1, send_boss_info/2, enter_scene/2,
    reconnect/2, boss_be_killed/4, boss_broadcast_reward/4
]).

%% 回调
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 秘籍
-export([gm_act_start/0, gm_act_end/0, gm_update_cache/1]).

%%% ====================================== exported functions ======================================

%% ===============
%% 跨服通用数据相关
%% ===============

%% 数据同步
sync_data(Args) ->
    gen_server:cast(?MODULE, {'sync_data', Args}).

%% ===========
%% 活动数据相关
%% ===========

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 活动开启
act_start(ModId, ModSub) ->
    gen_server:cast(?MODULE, {'act_start', ModId, ModSub}).

%% 发送活动信息
send_act_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId}).

%% 发送boss信息
send_boss_info(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'send_boss_info', RoleId, SceneId}).

%% 进入场景
enter_scene(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'enter_scene', RoleId, SceneId, true}). % NeedOut = true

%% 重连
reconnect(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'enter_scene', RoleId, SceneId, false}). % NeedOut = false

%% boss被击杀
boss_be_killed(Minfo, Klist, Atter, AtterSign) ->
    gen_server:cast(?MODULE, {'boss_be_killed', Minfo, Klist, Atter, AtterSign}).

%% boss召集奖励
boss_broadcast_reward(RoleId, Channel, SceneId, BossUId) ->
    gen_server:cast(?MODULE, {'boss_broadcast_reward', RoleId, Channel, SceneId, BossUId}).

%% 活动结束
act_end() ->
    ?MODULE ! {'act_end'}.

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
    {ok, #night_ghost_state_local{}}.

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

%% 数据同步
do_handle_cast({'sync_data', Args}, State) ->
    NewState = lib_night_ghost_mod:sync_data(Args, State),
    {noreply, NewState};

%% 活动开启
do_handle_cast({'act_start', _, _}, #night_ghost_state_local{state = ?NG_ACT_OPEN} = State) ->
    {noreply, State};
do_handle_cast({'act_start', ModId, ModSub}, State) ->
    #night_ghost_state_local{ser_mod = SerMod} = State,
    case SerMod of
        ?ZONE_MOD_1 -> % 本服模式
            NewState = lib_night_ghost_mod:act_start(ModId, ModSub, State),
            {noreply, NewState};
        _ ->
            mod_night_ghost_kf:cast_center({'act_start', ModId, ModSub}),
            {noreply, State}
    end;

%% 发送活动信息
do_handle_cast({'send_act_info', RoleId}, State) ->
    Bin = lib_night_ghost_mod:get_cache(?CACHE_NG_ACT_INFO, State),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 发送boss信息
do_handle_cast({'send_boss_info', RoleId, SceneId}, State) ->
    BinMap = lib_night_ghost_mod:get_cache(?CACHE_NG_BOSS_INFO, State),
    DefBin = pt_206:write(20602, [[]]),
    Bin = maps:get(SceneId, BinMap, DefBin),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 进入场景
do_handle_cast({'enter_scene', RoleId, SceneId, NeedOut}, State) ->
    #night_ghost_state_local{ser_mod = SerMod, zone_id = ZoneId, group_id = GroupId} = State,
    case lib_night_ghost_check:enter_scene({RoleId, SceneId}, State) of
        true ->
            {PoolId, CopyId} = ?IF(SerMod == ?ZONE_MOD_1, {0, 0}, {ZoneId, GroupId}),
            lib_scene:player_change_scene(RoleId, SceneId, PoolId, CopyId, NeedOut, [{group, 0}, {change_scene_hp_lim, 1}]),
            mod_daily:plus_count_offline(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, ?AC_COUNTER_TYPE(?MOD_NIGHT_GHOST, 1), 1), % 目前百鬼夜行没有活跃度配置,所以此处手动加上次数
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_NIGHT_GHOST, 1);
        {false, ErrCode} ->
            lib_night_ghost:send_msg(RoleId, ErrCode)
    end,
    {noreply, State};

%% boss被击杀
do_handle_cast({'boss_be_killed', _, _, _, _}, #night_ghost_state_local{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_cast({'boss_be_killed', Minfo, Klist, Atter, AtterSign}, State) ->
    NewState = lib_night_ghost_mod:boss_be_killed(Minfo, Klist, Atter, AtterSign, State),
    {noreply, NewState};

%% boss召集奖励
do_handle_cast({'boss_broadcast_reward', _, _, _, _}, #night_ghost_state_local{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_cast({'boss_broadcast_reward', RoleId, Channel, SceneId, BossUId}, State) ->
    #night_ghost_state_local{ser_mod = SerMod} = State,
    SerId = config:get_server_id(),
    CheckRes = lib_night_ghost_check:boss_broadcast_reward({RoleId, Channel, SceneId, BossUId}, State),
    NewState =
    case {CheckRes, SerMod} of
        {true, ?ZONE_MOD_1} ->
            lib_night_ghost_mod:boss_broadcast_reward(SerId, RoleId, Channel, SceneId, BossUId, State);
        {true, _} ->
            mod_night_ghost_kf:cast_center({'boss_broadcast_reward', SerId, RoleId, Channel, SceneId, BossUId}),
            State;
        _ ->
            State
    end,
    {noreply, NewState};

%% 更新缓存
do_handle_cast({'update_cache', Key}, State) ->
    lib_night_ghost_mod:update_cache(Key, State),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% ===========
%% handle_info
%% ===========

%% boss剩余数量提醒
do_handle_info({'left_boss'}, #night_ghost_state_local{state = ?NG_ACT_OPEN} = State) ->
    #night_ghost_state_local{act_info = ActInfo, scene_info = SceneInfoM} = State,
    F = fun(#scene_info{scene_id = SceneId, boss_info = BossList}) ->
        AliveBoss = lists:filter(fun(#boss_info{is_alive = IsAlive}) -> IsAlive end, BossList),
        lib_night_ghost_api:send_tv('left_boss', [SceneId, length(AliveBoss)])
    end,
    lists:foreach(F, maps:values(SceneInfoM)),

    BossRef = erlang:send_after(timer:seconds(?NG_LEFT_BOSS_TV), self(), {'left_boss'}),
    NewActInfo = ActInfo#act_info{boss_ref = BossRef},

    {noreply, State#night_ghost_state_local{act_info = NewActInfo}};

%% 活动倒计时提醒
do_handle_info({'countdown'}, #night_ghost_state_local{state = ?NG_ACT_OPEN} = State) ->
    lib_night_ghost_api:send_tv('countdown', [?NG_COUNTDOWN_TV]),

    #night_ghost_state_local{act_info = ActInfo} = State,
    NewActInfo = ActInfo#act_info{cd_ref = undefined},

    {noreply, State#night_ghost_state_local{act_info = NewActInfo}};

%% 活动结束
do_handle_info({'act_end'}, #night_ghost_state_local{state = ?NG_ACT_CLOSE} = State) ->
    {noreply, State};
do_handle_info({'act_end'}, State) ->
    #night_ghost_state_local{ser_mod = SerMod} = State,
    case SerMod of
        ?ZONE_MOD_1 -> % 本服模式
            NewState = lib_night_ghost_mod:act_end(State),
            {noreply, NewState};
        _ ->
            mod_night_ghost_kf:cast_center({'act_end'}),
            {noreply, State}
    end;

do_handle_info(_Info, State) ->
    {noreply, State}.

%%% ============================================== gm ==============================================

%% 秘籍: 活动开启
%% mod_night_ghost_local:gm_act_start().
gm_act_start() -> act_start(?MOD_NIGHT_GHOST, 1).

%% 秘籍: 活动结束
%% mod_night_ghost_local:gm_act_end().
gm_act_end() -> act_end().

%% 秘籍：更新缓存
%% mod_night_ghost_local:gm_update_cache(20602).
gm_update_cache(Key) ->
    gen_server:cast(?MODULE, {'update_cache', Key}).