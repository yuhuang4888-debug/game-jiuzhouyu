%% ---------------------------------------------------------------------------
%% @doc mod_guild_battle_fight
%% @author zengzy
%% @since  2017-10-03
%% @deprecated  公会战（大乱斗）战场进程
%% ---------------------------------------------------------------------------
-module(mod_guild_battle_fight).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("guild_battle.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

%%初始化战场
init() ->
    gen_server:start(?MODULE, [], []).

%%结束战场
end_fight(RoomPid) ->
    gen_server:cast(RoomPid, {end_fight}).

%%重连发送场景信息
relogin_send_info(CopyId,Role, X, Y, BuffId) ->
    gen_server:cast(CopyId, {relogin_send_info, Role, X, Y, BuffId}).

%%初始化战场公会和时间
start(Pid,GuildList,EndTime) ->
    gen_server:cast(Pid, {start, GuildList, EndTime}).

%%进入战场
enter(RoomPid, Role, BuffId) ->
    gen_server:cast(RoomPid, {enter, Role, BuffId}).

%%退出战场
quit(RoomPid,RoleId) ->
    gen_server:cast(RoomPid, {quit, RoleId}).

%%进入走出据点
step_own_change(CopyId, RoleId, MonId, Type) ->
    gen_server:cast(CopyId, {step_own_change, RoleId, MonId, Type}).

%%领取奖励
send_stage_reward(CopyId, StageId, RoleId) ->
    gen_server:cast(CopyId, {send_stage_reward,StageId, RoleId}).

%%使用战场技能
use_battle_skill(CopyId,RoleId) ->
    gen_server:cast(CopyId, {use_battle_skill,RoleId}).

%%怪物死亡
kill_mon(CopyId,MonInfo,AtterId) ->
    gen_server:cast(CopyId, {kill_mon,MonInfo, AtterId}).

%%玩家死亡
kill_player(CopyId,AttId,RoleId) ->
    gen_server:cast(CopyId, {kill_player,AttId, RoleId}).

%%砍据点
hurt_mon(CopyId, MonInfo, AtterId) ->
    gen_server:cast(CopyId, {hurt_mon,MonInfo,AtterId}).

%%新公会进入
add_new_guild(RoomPid,GuildId,GuildName,ChiefId) ->
    gen_server:cast(RoomPid, {add_new_guild,GuildId,GuildName,ChiefId}).

%%apply_cast
apply_cast(RoomPid, Msg) ->
    gen_server:cast(RoomPid, Msg).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = lib_guild_battle_fight:init(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({start, GuildList, EndTime}, State) ->
    lib_guild_battle_fight:start(GuildList,EndTime,State); 
do_handle_cast({enter, Role, BuffId}, State) ->
    lib_guild_battle_fight:enter(Role, BuffId, State);
do_handle_cast({quit, RoleId}, State) ->
    lib_guild_battle_fight:quit(RoleId,State);
do_handle_cast({send_stage_reward, StageId,RoleId}, State) ->
    lib_guild_battle_fight:send_stage_reward(StageId, RoleId,State);
do_handle_cast({use_battle_skill,RoleId}, State) ->
    lib_guild_battle_fight:use_battle_skill(RoleId,State);
do_handle_cast({kill_mon, MonInfo, AtterId}, State) ->
    lib_guild_battle_fight:kill_mon(MonInfo, AtterId, State);
do_handle_cast({kill_player,AtterId, RoleId}, State) ->
    lib_guild_battle_fight:kill_player(AtterId, RoleId, State);
do_handle_cast({hurt_mon,MonInfo,AtterId}, State) ->
    lib_guild_battle_fight:hurt_mon_change(MonInfo, AtterId,State);
do_handle_cast({relogin_send_info, Role, X, Y, BuffId}, State) ->
    lib_guild_battle_fight:relogin_send_info(Role, X, Y, BuffId, State);
do_handle_cast({step_own_change, RoleId, MonId, Type}, State) ->
    lib_guild_battle_fight:step_own_change(RoleId, MonId, Type, State);
do_handle_cast({add_new_guild,GuildId,GuildName,ChiefId}, State) ->
    lib_guild_battle_fight:add_new_guild(GuildId,GuildName,ChiefId, State);
do_handle_cast({end_fight}, State) ->
    lib_guild_battle_fight:end_fight(State);
do_handle_cast({mod, Fun, Args}, State) ->
    apply(lib_guild_battle_fight, Fun, [State, Args]);
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({own_add_guild_score,GuildId,MonId}, State) ->
    lib_guild_battle_fight:check_own_add_guild_score(GuildId,MonId,State);
do_handle_info({in_own_add_score}, State) ->
    lib_guild_battle_fight:in_own_add_score(State);
do_handle_info({broadcast_guild_rank}, State) ->
    lib_guild_battle_fight:broadcast_guild_rank(State);
do_handle_info({send_own_list}, State) ->
    lib_guild_battle_fight:check_send_own_list(State);
do_handle_info({send_language}, State) ->
    lib_guild_battle_fight:send_language(State);
do_handle_info(_Info, State) -> {noreply, State}.



