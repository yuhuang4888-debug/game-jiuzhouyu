%% ---------------------------------------------------------------------------
%% @doc mod_nine_local.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿
%% ---------------------------------------------------------------------------
-module(mod_nine_local).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

-include("role_nine.hrl").
-include("common.hrl").

-define(MOD_STATE, nine_state).     %% 九魂圣殿状态

%% 秘籍开启
%% @param Type 0本服，1:跨服
gm_act_start( Etime) ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_act_start, [Etime]}).

gm_act_end() ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_act_end, []}).

%% 活动开启
act_start(AcSub) ->
    gen_server:cast({global, ?MODULE}, {'apply', act_start, [AcSub]}).

%% 设置成单服模式(需要先改开服天数)
gm_single_mod() ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_single_mod, []}),
    mod_nine_center:gm_partition().

%% 发送状态信息
send_nine_info(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_nine_info, [RoleId]}).

%% 战场日志
send_nine_rank_list(RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_nine_rank_list, [RoleId, ServerId]}).

%% 参战
apply_war(NineRank, LayerId, EnterType) ->
    gen_server:cast({global, ?MODULE}, {'apply', apply_war, [NineRank, LayerId, EnterType]}).

%% 退出
quit(RoleId, ServerId, SceneId) ->
    gen_server:cast({global, ?MODULE}, {'apply', quit, [RoleId, ServerId, SceneId]}).

%% 发送旗帜信息
send_flag_info(RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_flag_info, [RoleId, ServerId]}).

%% 区域派发事件
zone_dispatch_execute(M, F, A) ->
    gen_server:cast({global, ?MODULE}, {'apply', zone_dispatch_execute, [M, F, A]}).

% %% 假人死亡
% dummy_die(SceneId, RoleId, ServerId) ->
%     gen_server:cast({global, ?MODULE}, {'apply', dummy_die, [SceneId, RoleId, ServerId]}).

%% 对象死亡
object_die(SceneId, RoleId, ServerId, PoolId, CopyId) ->
    gen_server:cast({global, ?MODULE}, {'apply', object_die, [SceneId, RoleId, ServerId, PoolId, CopyId]}).

%% 击杀玩家
kill_player(SceneId, ServerNum, AtterId, Name, DieId, DName, DServerId, PoolId, CopyId) ->
    gen_server:cast({global, ?MODULE}, {'apply', kill_player, [SceneId, ServerNum, AtterId, Name, DieId, DName, DServerId, PoolId, CopyId]}).

%% 复活
revive(RoleId, ServerId, Type, PoolId, CopyId) ->
    gen_server:cast({global, ?MODULE}, {'apply', revive, [RoleId, ServerId, Type, PoolId, CopyId]}).

%% 采集秘宝
collect_flag(CollectorId, SceneId, PoolId, CopyId) ->
    gen_server:cast({global, ?MODULE}, {'apply', collect_flag, [CollectorId, SceneId, PoolId, CopyId]}).

%% 同步数据
sync_data(Args) ->
    gen_server:cast({global, ?MODULE}, {'apply', sync_data, [Args]}).

%% 同步分服情况
sync_partition(NineZone) ->
    gen_server:cast({global, ?MODULE}, {'apply', sync_partition, [NineZone]}).

%% 获得战斗信息
get_battle_info(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'apply', get_battle_info, [RoleId]}).

%% 获得状态
print() ->
    gen_server:call({global, ?MODULE}, {'print'}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    State = lib_nine_battle:init(?CLS_TYPE_GAME),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("~p call error: ~p, Reason=~p~n", [?MODULE, Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
%%    ?MYLOG("nine_local_zh", "cast LogMsg ~p State zoneMap ~p ~n", [Msg, State#nine_state.zone_map]),
    case catch do_handle_cast(Msg, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
%%    ?MYLOG("nine_local_zh", "info Info ~p State zoneMap ~p ~n", [Info, State#nine_state.zone_map]),
    case catch do_handle_info(Info, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%% handle_call
%% --------------------------------------------------------------------------

do_handle_call({'get_state'}, _From, State) ->
    ?INFO("get_state:~p~n", [State]),
    {reply, State, State};

do_handle_call({'print'}, _From, State) ->
    #nine_state{state_type = StateType, cls_type = ClsType, status = Status, stime = Stime, etime = Etime} = State,
    Msg = {StateType, ClsType, Status, Stime, Etime},
    ?INFO("Msg:~p~n", [Msg]),
    {reply, Msg, State};

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match _Info:~p ~n",[_Request]),
    {reply, no_match, State}.

%% --------------------------------------------------------------------------
%% handle_cast
%% --------------------------------------------------------------------------

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_nine_battle, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_nine_battle, F, [State|Args]);

do_handle_cast(_Msg, State) -> 
    ?ERR("do_handle_cast no match _Msg:~p ~n",[_Msg]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% hanle_info
%% -----------------------------------------------------------------

do_handle_info(sync_server_data, _State) ->
    ?PRINT("@@@@reveice sync info now sync~n~n", []),
    ServerId = config:get_server_id(),
    mod_nine_center:cast_center([{'apply', request_init_data, [ServerId]}]),
    ok;

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_nine_battle, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_nine_battle, F, [State|Args]);

do_handle_info(_Info, State) -> 
    ?ERR("do_handle_info no match _Info:~p ~n",[_Info]),
    {noreply, State}.
