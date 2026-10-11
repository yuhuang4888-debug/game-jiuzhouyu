%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%% 决斗场
%%% @end
%%% Created : 02. 一月 2019 14:25
%%%-------------------------------------------------------------------
-module(mod_glad_local).
-author("whao").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-compile(export_all).

-include("gladiator.hrl").
-include("common.hrl").

%%  1 : 秘籍开启
%% @param Type 0本服，1:跨服
%%--------------------------------------
gm_act_start(Type, Etime) ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_act_start, [Type, Etime]}).

%%  2: 秘籍关闭
gm_act_end() ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_act_end, []}).
%%--------------------------------------

%% 3： 活动开启
act_start(AcSub) ->
    ?PRINT("act start AcSub :~p~n",[AcSub]),
    gen_server:cast({global, ?MODULE}, {'apply', act_start, [AcSub]}).



%% 4： 发送状态信息
send_glad_info(RoleId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_glad_info, [RoleId]}).

%% 5: 获取人物信息
send_glad_role_info(RoleId,ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_glad_role_info, [RoleId, ServerId]}).


%% 7: 随机对手
glad_random_rival_role(RoleId, MedalLv, RoleCombat, RoleLv, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', glad_random_rival_role, [RoleId, MedalLv, RoleCombat, RoleLv, ServerId]}).

%% 8: 领取阶段奖励
get_stage_reward(RoleId, Stage, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', get_stage_reward, [RoleId, Stage, ServerId]}).

%% 9: 创建战场
create_glad_battle(ChallengeRole, Medal, GladRank) ->
    gen_server:cast({global, ?MODULE}, {'apply', create_glad_battle, [ChallengeRole, Medal, GladRank]}).

%% 10: 结算结果
challenge_image_role_result(RoleId, IsWin) ->
    gen_server:cast({global, ?MODULE}, {'apply', challenge_image_role_result, [RoleId, IsWin]}).

%% 11 : 设置state战斗状态
set_battle_status(RoleID, BattleStatus) ->
    gen_server:cast({global, ?MODULE}, {'apply', set_battle_status, [RoleID, BattleStatus]}).

%% 12 : 获取排行榜
get_glad_rank_list(RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', get_glad_rank_list, [RoleId, ServerId]}).

%% 13 :秘籍增加玩家积分
gm_add_player_score(RoleId, Score, GladRank) ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_add_player_score, [RoleId, Score, GladRank]}).

% 14 : 修复决斗场玩家数据
gm_repair() ->
    gen_server:cast({global, ?MODULE}, {'apply', gm_repair, []}).

login()->
    gen_server:cast({global, ?MODULE}, {'apply', login, []}).



%% 战场日志
send_glad_rank_list(RoleId, ServerId, Page, Per) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_glad_rank_list, [RoleId, ServerId, Page, Per]}).

%% 参战
apply_war(NineRank, LayerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', apply_war, [NineRank, LayerId]}).

%% 退出
quit(RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', quit, [RoleId, ServerId]}).

%% 发送旗帜信息
send_flag_info(RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', send_flag_info, [RoleId, ServerId]}).

%% 区域派发事件
zone_dispatch_execute(M, F, A) ->
    gen_server:cast({global, ?MODULE}, {'apply', zone_dispatch_execute, [M, F, A]}).

%% 假人死亡
dummy_die(SceneId, RoleId, ServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', dummy_die, [SceneId, RoleId, ServerId]}).

%% 击杀玩家
kill_player(SceneId, AtterId, Name, DieId, DName, DServerId) ->
    gen_server:cast({global, ?MODULE}, {'apply', kill_player, [SceneId, AtterId, Name, DieId, DName, DServerId]}).

%% 复活
revive(RoleId, ServerId, Type) ->
    gen_server:cast({global, ?MODULE}, {'apply', revive, [RoleId, ServerId, Type]}).

%% 采集秘宝
collect_flag(CollectorId) ->
    gen_server:cast({global, ?MODULE}, {'apply', collect_flag, [CollectorId]}).

%% 同步数据
sync_data(Args) ->
    gen_server:cast({global, ?MODULE}, {'apply', sync_data, [Args]}).

%% 获得状态
print() ->
    gen_server:call({global, ?MODULE}, {'print'}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    erlang:send_after(5000, self(), 'bf_act_start'),
    State = lib_glad_battle:init(?CLS_TYPE_GAME),
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
    case catch do_handle_cast(Msg, State) of
        ok ->
            {noreply, State};
        {ok, NewState} when is_record(NewState, glad_state) ->
            {noreply, NewState};
        {noreply, NewState} when is_record(NewState, glad_state) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, glad_state) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, glad_state) -> {noreply, NewState};
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
    #glad_state{state_type = StateType, cls_type = ClsType, status = Status, stime = Stime, etime = Etime} = State,
    Msg = {StateType, ClsType, Status, Stime, Etime},
    ?INFO("Msg:~p~n", [Msg]),
    {reply, Msg, State};

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match _Info:~p ~n", [_Request]),
    {reply, no_match, State}.

%% --------------------------------------------------------------------------
%% handle_cast
%% --------------------------------------------------------------------------

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_glad_battle, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_glad_battle, F, [State | Args]);

do_handle_cast(_Msg, State) ->
    ?ERR("do_handle_cast no match _Msg:~p ~n", [_Msg]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% hanle_info
%% -----------------------------------------------------------------
do_handle_info('bf_act_start', State) ->
    ?PRINT("bf_act_start ~n",[]),
    erlang:apply(lib_glad_battle, act_start, [ State | [0] ]);

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_glad_battle, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_glad_battle, F, [State | Args]);

do_handle_info(_Info, State) ->
    ?ERR("do_handle_info no match _Info:~p ~n", [_Info]),
    {noreply, State}.
