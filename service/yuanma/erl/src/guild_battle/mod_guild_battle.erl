%% ---------------------------------------------------------------------------
%% @doc mod_guild_battle
%% @author zengzy
%% @since  2017-10-03
%% @deprecated  公会战（大乱斗）数据进程
%% ---------------------------------------------------------------------------
-module(mod_guild_battle).

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

%% 
show_state() ->
    gen_server:cast({global, ?MODULE}, {show_state}).

%% 活动是否开启
check_open() ->
    gen_server:call({global, ?MODULE}, {check_open}, 1000).

%% 是否是霸主
is_dominator_guild(GuildId) ->
    gen_server:call({global, ?MODULE}, {is_dominator_guild, GuildId}, 1000).

get_battle_winner() ->
    gen_server:call({global, ?MODULE}, {get_battle_winner}, 1000).

timer_check()->
    Pid = misc:get_global_pid(?MODULE),
    case is_pid(Pid) of
        true-> misc:get_global_pid(?MODULE) ! 'timer_check';
        false-> ok
    end.

%%开启预告
start_tip() ->
    misc:get_global_pid(?MODULE) ! 'start_tip'.

start_fight() ->
    misc:get_global_pid(?MODULE) ! 'start_battle'.

%%gm开启预告
gm_start_tip() ->
    %% 先关闭
    spawn(fun() ->
        misc:get_global_pid(?MODULE) ! 'gm_end_battle',
        timer:sleep(5000),
        misc:get_global_pid(?MODULE) ! 'gm_start_tip'
    end).

gm_end_tip() ->
    misc:get_global_pid(?MODULE) ! 'gm_end_battle'.

%%查询活动状态
send_war_state(Sid) ->
    gen_server:cast({global, ?MODULE}, {send_war_state, Sid}).
    
%%断线重连
login(Role,X,Y) ->
    gen_server:cast({global, ?MODULE}, {login,Role,X,Y}).

%% 玩家登陆
role_login(RoleId, GuildId) ->
    gen_server:cast({global, ?MODULE}, {role_login, RoleId, GuildId}).

%%进入战场
enter(Role) ->
    gen_server:cast({global, ?MODULE}, {enter,Role}).

%%退出战场
quit(Role) ->
    gen_server:cast({global, ?MODULE}, {quit,Role}).

%%保存退出玩家信息
save_leave_role(Role)->
    gen_server:cast({global, ?MODULE}, {save_leave_role,Role}).

%%刷新公会排名
refresh_guild_rank(List) ->
    gen_server:cast({global, ?MODULE}, {refresh_guild_rank,List}).

%%刷新玩家排名
refresh_role_rank(List) ->
    gen_server:cast({global, ?MODULE}, {refresh_role_rank,List}).

%%获取公会排名
get_guild_rank(GuildId) ->
    gen_server:call({global, ?MODULE}, {get_guild_rank,GuildId}, 3000).

%%获取公会排名
is_winner(GuildId) ->
    gen_server:call({global, ?MODULE}, {is_winner, GuildId}, 3000).

%%活动主界面
send_guild_battle_show(GuildId,CreateTime,RoleId,Sid) ->
    gen_server:cast({global, ?MODULE}, {send_guild_battle_show,GuildId,CreateTime,RoleId,Sid}).

send_guild_battle_red_hot(GuildId,RoleId,Sid,Position, CreateTime) ->
    gen_server:cast({global, ?MODULE}, {send_guild_battle_red_hot,GuildId,RoleId,Sid,Position, CreateTime}).

%%玩家排行榜
send_role_rank(RoleId, Sid) ->
    gen_server:cast({global, ?MODULE}, {send_role_rank, RoleId, Sid}).

%%公会排行榜
send_guild_rank(RoleId, GuildId, Sid) ->
    gen_server:cast({global, ?MODULE}, {send_guild_rank, RoleId, GuildId, Sid}).

%%检测是否推送积分
% check_send_score(RoleId) ->
%     gen_server:cast({global, ?MODULE}, {check_send_score,RoleId}).

%%新公会加入
add_new_guild(GuildId,GuildName,ChiefId) ->
     gen_server:cast({global, ?MODULE}, {add_new_guild,GuildId,GuildName,ChiefId}).

%%公会换会长
change_chief(GuildId, ChiefId, Name) ->
    gen_server:cast({global, ?MODULE}, {change_chief, GuildId, ChiefId, Name}).


allocate_reward(ChiefId, GuildId, GuildName, RoleId, RoleName) -> 
    gen_server:cast({global, ?MODULE}, {allocate_reward, ChiefId, GuildId, GuildName, RoleId, RoleName}).

%%获取前N名公会
get_top_guilds(Rank) ->
    case catch gen_server:call({global, ?MODULE}, {get_top_guilds,Rank}, 3000) of
        List when is_list(List) -> List;
        _ -> []
    end.

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

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
    State = lib_guild_battle_mod:init(),
    %?PRINT("mod_guild_battle init ~p~n", [State]),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({check_open}, _From, State) ->
    #guild_battle_state{state = Type} = State,
    ?PRINT("player_can_apply WarState ~p~n", [Type]),
    Reply = ?IF(Type == ?START, true, false),  
    {reply, Reply, State};
do_handle_call({get_battle_winner}, _From, State) ->
    #guild_battle_state{winner = Winner} = State, 
    {reply, Winner, State};
do_handle_call({is_dominator_guild, GuildId}, _From, State) ->
    #guild_battle_state{winner = Winner} = State,
    Reply = ?IF(Winner == GuildId, true, false),  
    {reply, Reply, State};
do_handle_call({get_guild_rank,GuildId}, _From, State) ->
    #guild_battle_state{rank_list=Guildlist} = State,
    case lists:keyfind(GuildId,1,Guildlist) of
        false -> GuildRank = 0, GuildScore = 0;
        {_,GuildRank,_,_,_,GuildScore,_PowerRank,_Own} -> ok
    end,  
    {reply, {GuildRank,GuildScore}, State};
do_handle_call({is_winner, GuildId}, _From, State) ->
    #guild_battle_state{winner=Winner} = State,
    IsWinner = ?IF(GuildId == Winner andalso GuildId > 0, true, false), 
    {reply, IsWinner, State};
do_handle_call({get_top_guilds,Rank}, _From, State) ->
    lib_guild_battle_mod:get_top_guilds(Rank, State);
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({send_war_state, Sid}, State) -> 
    #guild_battle_state{state = Type} = State,
    {ok, Bin} = pt_505:write(50520, [Type]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, State};
do_handle_cast({enter, Role}, State) -> 
    lib_guild_battle_mod:enter(Role,State);
do_handle_cast({role_login, RoleId, GuildId}, State) -> 
    lib_guild_battle_mod:role_login(RoleId, GuildId, State);
do_handle_cast({login,Role,X,Y}, State) -> 
    lib_guild_battle_mod:login(Role,X,Y,State);
do_handle_cast({quit, Role}, State) -> 
    lib_guild_battle_mod:quit(Role,State);
% do_handle_cast({save_leave_role, Role}, State) -> 
%     lib_guild_battle_mod:save_leave_role(Role,State);
do_handle_cast({refresh_guild_rank,List}, State) -> 
    lib_guild_battle_mod:refresh_guild_rank(List,State);
do_handle_cast({refresh_role_rank,List}, State) -> 
    lib_guild_battle_mod:refresh_role_rank(List,State);
do_handle_cast({send_guild_battle_show,GuildId,CreateTime,RoleId,Sid}, State) -> 
    lib_guild_battle_mod:send_guild_battle_show(GuildId,CreateTime,RoleId,Sid,State);
do_handle_cast({send_guild_battle_red_hot,GuildId,RoleId,Sid, Position, CreateTime}, State) -> 
    lib_guild_battle_mod:send_guild_battle_red_hot(GuildId,RoleId,Sid, Position, CreateTime,State);
do_handle_cast({send_role_rank, RoleId, Sid}, State) -> 
    lib_guild_battle_mod:send_role_rank(RoleId, Sid, State);
do_handle_cast({send_guild_rank, RoleId, GuildId, Sid}, State) -> 
    lib_guild_battle_mod:send_guild_rank(RoleId, GuildId, Sid, State);

% do_handle_cast({check_send_score,RoleId}, State) -> 
%     lib_guild_battle_mod:check_send_score(RoleId,State);
do_handle_cast({add_new_guild,GuildId,GuildName,ChiefId}, State) -> 
    lib_guild_battle_mod:add_new_guild(GuildId,GuildName,ChiefId,State);
do_handle_cast({change_chief, GuildId, ChiefId, Name}, State) -> 
    lib_guild_battle_mod:change_chief(GuildId, ChiefId, Name, State);
do_handle_cast({allocate_reward, ChiefId, GuildId, GuildName, RoleId, RoleName}, State) -> 
    lib_guild_battle_mod:allocate_reward(ChiefId, GuildId, GuildName, RoleId, RoleName,State);
do_handle_cast({show_state}, State) -> 
    ?PRINT("show state ~p~n", [State]),
    {noreply, State};
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info('timer_check', State) ->
    %lib_guild_battle_mod:timer_check(State),
    {noreply, State};
do_handle_info('gm_start_tip', State) ->
    ?PRINT("gm start_tip~n",[]),
    lib_guild_battle_mod:gm_start_tip(State); 
do_handle_info('gm_end_battle', State) ->
    ?PRINT("gm end_battle~n",[]),
    lib_guild_battle_mod:gm_end_battle(State); 
do_handle_info('start_tip', State) ->
    ?PRINT("battle start_tip~n",[]),
    lib_guild_battle_mod:start_tip(State); 
do_handle_info('start_battle', State) ->
    ?PRINT("battle start_battle~n",[]),
    lib_guild_battle_mod:start_battle(State); 
do_handle_info('end_battle', State) ->
    ?PRINT("battle end_battle~n",[]),
    lib_guild_battle_mod:end_battle(State); 
do_handle_info(_Info, State) -> {noreply, State}.



