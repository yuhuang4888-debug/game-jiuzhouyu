%% ---------------------------------------------------------------------------
%% @doc mod_territory_war_fight
%% @author 
%% @since  
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(mod_territory_war_fight).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("server.hrl").
%%-----------------------------


start([IsCls, TerriWar, ModeNum, StartTime, EndTime]) ->
    gen_server:start(?MODULE, [IsCls, TerriWar, ModeNum, StartTime, EndTime], []).

%%进入战场
enter_fight(FightPid, Msg) ->
    gen_server:cast(FightPid, {enter_fight, Msg}).

re_login(FightPid, Msg) ->
    gen_server:cast(FightPid, {re_login, Msg}).

%%退出战场
leave_war(FightPid, Msg) ->
    gen_server:cast(FightPid, {leave_war, Msg}).

%%查询战场信息
send_war_info(FightPid, Msg) ->
    gen_server:cast(FightPid, {send_war_info, Msg}).

%% 召集会员
convene_guild_member(FightPid, Msg) ->
    gen_server:cast(FightPid, {convene_guild_member, Msg}).

%% 击杀怪物
kill_mon(Atter, MonInfo) ->
    #scene_object{scene = SceneId, copy_id=CopyId} = MonInfo,
    #battle_return_atter{id = AtterId} = Atter,
    case lib_territory_war:is_in_territory_war(SceneId) of
        true ->
            case misc:is_process_alive(CopyId) of
                true -> 
                    gen_server:cast(CopyId, {kill_mon, MonInfo, AtterId});
                false -> skip
            end;
        _ ->
            skip
    end.

%% 砍据点
hurt_mon(Minfo, AtterId) ->
    #scene_object{scene = SceneId, copy_id=CopyId} = Minfo,
    case lib_territory_war:is_in_territory_war(SceneId) of
        true->
            case misc:is_process_alive(CopyId) of
                true->
                    gen_server:cast(CopyId, {hurt_mon, Minfo, AtterId});
                _->
                    skip
            end;
        false ->
                skip
    end.

%%杀死玩家
kill_player(FightPid, AttId, RoleId) ->
    gen_server:cast(FightPid, {kill_player, AttId, RoleId}).

advance_end(FightPid) ->
    gen_server:cast(FightPid, {advance_end}).

%%apply_cast
apply_cast(Pid, Msg) ->
    gen_server:cast(Pid, Msg).

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
        {stop, normal, NewState} ->
            {stop, normal, NewState};
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

init([IsCls, TerriWar, ModeNum, StartTime, EndTime]) ->
    State = #terri_fight_state{
        terri_war = TerriWar, mode_num = ModeNum, is_cls = IsCls, start_time = StartTime, end_time = EndTime
    },
    NewState = lib_territory_war_fight:init_war(State),
    {ok, NewState}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
% do_handle_cast({start_fight, [StartTime, EndTime]}, State) ->
%     NewState = lib_territory_war_fight:start_fight(State, StartTime, EndTime),
%     {noreply, NewState};

do_handle_cast({send_war_info, Msg}, State) ->
    lib_territory_war_fight:send_war_info(State, Msg),
    {noreply, State};

do_handle_cast({convene_guild_member, Msg}, State) ->
    lib_territory_war_fight:convene_guild_member(State, Msg),
    {noreply, State};

do_handle_cast({enter_fight, [TFRole, BuffId]}, State) ->
    NewState = lib_territory_war_fight:enter_fight(State, TFRole, BuffId),
    {noreply, NewState};

do_handle_cast({re_login, [TFRole, X, Y]}, State) ->
    NewState = lib_territory_war_fight:re_login(State, TFRole, X, Y),
    {noreply, NewState};


do_handle_cast({leave_war, [RoleId, GuildId, Node]}, State) ->
    NewState = lib_territory_war_fight:leave_war(State, RoleId, GuildId, Node),
    {noreply, NewState};

do_handle_cast({kill_mon, MonInfo, AtterId}, State) ->
    NewState = lib_territory_war_fight:kill_mon(State, MonInfo, AtterId),
    {noreply, NewState};

do_handle_cast({hurt_mon, MonInfo, AtterId}, State) ->
    NewState = lib_territory_war_fight:hurt_mon(State, MonInfo, AtterId),
    {noreply, NewState};

do_handle_cast({kill_player, AtterId, RoleId}, State) ->
    NewState = lib_territory_war_fight:kill_player(State, AtterId, RoleId),
    {noreply, NewState};

do_handle_cast({advance_end}, State) ->
    lib_territory_war_fight:end_fight(State, 2);

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================


do_handle_info({own_add_guild_score, GuildId, MonId}, State) ->
    NewState = lib_territory_war_fight:own_add_guild_score(State, GuildId, MonId),
    {noreply, NewState};

do_handle_info({broadcast_war_info}, State) ->
    NewState = lib_territory_war_fight:broadcast_war_info(State),
    {noreply, NewState};

do_handle_info({send_language}, State) ->
    NewState = lib_territory_war_fight:send_language(State),
    {noreply, NewState};

do_handle_info({end_fight}, State) ->
    lib_territory_war_fight:end_fight(State, 1);

do_handle_info(_Info, State) -> {noreply, State}.


