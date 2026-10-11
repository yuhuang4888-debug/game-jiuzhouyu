-module(mod_escort_kf).

-behaviour(gen_server).

-include("common.hrl").
-include("escort.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

%% 秘籍
-export([]).

-export([
        init_after/2            %% 从跨服中心获取数据
        ,zone_change/3          %% 分区更改
        ,center_connected/3     %% 本地连接跨服中心

        ,enter_scene/9          %% 进入
        ,exit/3                 %% 退出
        ,reconnect/3            %% 重连
        ,mon_reborn/13          %% 召唤水晶
        ,mon_hurt/13            %% 攻击水晶
        ,mon_be_killed/12       %% 掠夺水晶
        ,mon_stop/10            %% 护送水晶完成
        ,walk_check_back/7      %% 护送检测
        ,mon_move/10            %% 护送
        ,local_init/1           %% 本地数据更新
        ,gm_start/0             %% 秘籍开启
        ,gm_act_end/0           %% 秘籍关闭
        ,act_start/1            %% 定制活动开启
        ,custom_act_end/0       %% 定制活动结束
    ]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

%%=========================================================================
%% 接口函数
%%=========================================================================
%%本地->跨服中心 
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

%%=========================================================================
%% 跨服中心使用
%%=========================================================================

%% -----------------------------------------------------------------
%% 零点重新计算活动时间/进程初始化
%% -----------------------------------------------------------------
init_after(ZoneMap, ServerInfo) ->
    gen_server:cast(?MODULE, {'init_after', ZoneMap, ServerInfo}).

%% -----------------------------------------------------------------
%% 更改分区
%% -----------------------------------------------------------------
zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone}).

%% -----------------------------------------------------------------
%% 连上跨服中心
%% -----------------------------------------------------------------
center_connected(ServerId, ServerNum, MergeSerIds) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId, ServerNum, MergeSerIds}).

%% -----------------------------------------------------------------
%% 跨服定制活动开启
%% -----------------------------------------------------------------
act_start(TimeList) ->
    gen_server:cast(?MODULE, {'act_start', TimeList}).

%% -----------------------------------------------------------------
%% 跨服定制活动结束
%% -----------------------------------------------------------------
custom_act_end() ->
    gen_server:cast(?MODULE, {'custom_act_end'}).
%%=========================================================================
%% 本地使用
%%=========================================================================

%% -----------------------------------------------------------------
%% 玩家进入场景
%% -----------------------------------------------------------------
enter_scene(ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut) ->
    cast_center([{'enter_scene', ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut}]).

%% -----------------------------------------------------------------
%% 玩家退出场景
%% -----------------------------------------------------------------    
exit(ServerId, GuildId, RoleId) ->
    cast_center([{'exit', ServerId, GuildId, RoleId}]).

%% -----------------------------------------------------------------
%% 玩家重连
%% -----------------------------------------------------------------
reconnect(ServerId, GuildId, RoleId) ->
    cast_center([{'reconnect', ServerId, GuildId, RoleId}]).

%% -----------------------------------------------------------------
%% 召唤护送的怪物
%% -----------------------------------------------------------------
mon_reborn(ServerId, ServerNum, GuildId, GuildName, MonType, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost) ->
    cast_center([{'mon_reborn', ServerId, ServerNum, GuildId, GuildName, MonType, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost}]).

%% -----------------------------------------------------------------
%% 攻击水晶
%% -----------------------------------------------------------------
mon_hurt(Scene, PoolId, CopyId, ServerNum, ServerId, AttrGuildId, GuildId, Monid, RoleId, RoleName, Hurt, MonAutoId, Hp) ->
    cast_center([{'mon_hurt', Scene, PoolId, CopyId, ServerNum, ServerId, AttrGuildId, GuildId, Monid, RoleId, RoleName, Hurt, MonAutoId, Hp}]).

%% -----------------------------------------------------------------
%% 水晶被掠夺
%% -----------------------------------------------------------------
mon_be_killed(Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName) ->
    cast_center([{'mon_be_killed', Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName}]).

%% -----------------------------------------------------------------
%% 护送成功
%% -----------------------------------------------------------------
mon_stop(Scene, PoolId, CopyId, Monid, MonAutoId, MonLv, Hp, GuildId, X, Y) ->
    cast_center([{'mon_stop', Scene, PoolId, CopyId, Monid, MonAutoId, MonLv, Hp, GuildId, X, Y}]).

%% -----------------------------------------------------------------
%% 护送检测
%% -----------------------------------------------------------------
walk_check_back(Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, UserList) ->
    cast_center([{'walk_check_back', Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, UserList}]).

%% -----------------------------------------------------------------
%% 护送
%% -----------------------------------------------------------------
mon_move(Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, X, Y, Hp, HpMax) ->
    cast_center([{'mon_move', Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, X, Y, Hp, HpMax}]).

%% -----------------------------------------------------------------
%% 本地数据更新
%% -----------------------------------------------------------------
local_init(ServerId) ->
    cast_center([{'local_init', ServerId}]).

%% -----------------------------------------------------------------
%% 秘籍开启
%% -----------------------------------------------------------------
gm_start() ->
    cast_center([{'gm_start'}]).

%% -----------------------------------------------------------------
%% 秘籍关闭
%% -----------------------------------------------------------------
gm_act_end() ->
    cast_center([{'gm_act_end'}]).
%%=========================================================================
%% 回调函数
%%=========================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    spawn(fun() -> timer:sleep(5000), mod_zone_mgr:kf_escort_init() end),
    List = db:get_all(?SQL_SELECE_ESCORT),
    Fun = fun([ZoneId, ServerId, ServerNum, GuildId, GuildName], Map) ->
        maps:put(ZoneId, [{ServerId, ServerNum, GuildId, GuildName}], Map)
    end,
    ?PRINT("List:~p~n",[List]),
    NewMap = lists:foldl(Fun, #{}, List),
    {ok, #kf_escort_state{first_guild = NewMap}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'init_after', ZoneMap, ServerInfo}, State) ->
    NewState = lib_escort_mod:reset(State, ZoneMap, ServerInfo),
    {noreply, NewState};

do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State) ->
    NewState = lib_escort_mod:zone_change(State, ServerId, OldZone, NewZone),
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId, ServerNum, MergeSerIds}, State) ->
    NewState = lib_escort_mod:center_connected(State, ServerId, ServerNum, MergeSerIds),
    {noreply, NewState};

do_handle_cast({'act_start', TimeList}, State) ->
    NewState = lib_escort_mod:act_start(State, TimeList),
    {noreply, NewState};

do_handle_cast({'custom_act_end'}, State) ->
    NewState = lib_escort_mod:custom_act_end(State),
    {noreply, NewState};

do_handle_cast({'enter_scene', ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut}, State) ->
    NewState = lib_escort_mod:enter_scene(State, ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut),
    {noreply, NewState};

do_handle_cast({'exit', ServerId, GuildId, RoleId}, State) ->
    NewState = lib_escort_mod:exit(State, ServerId, GuildId, RoleId),
    {noreply, NewState};

do_handle_cast({'mon_reborn', ServerId, ServerNum, GuildId, GuildName, MonType, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost}, State) ->
    NewState = lib_escort_mod:mon_reborn(State, ServerId, ServerNum, GuildId, GuildName, MonType, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost),
    {noreply, NewState};

do_handle_cast({'mon_hurt', Scene, PoolId, CopyId, ServerNum, ServerId, AttrGuildId, GuildId, Monid, RoleId, RoleName, Hurt, MonAutoId, Hp}, State) ->
    NewState = lib_escort_mod:mon_hurt(State, Scene, PoolId, CopyId, ServerNum, ServerId, AttrGuildId, GuildId, Monid, RoleId, RoleName, Hurt, MonAutoId, Hp),
    {noreply, NewState};

do_handle_cast({'mon_be_killed', Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName}, State) ->
    NewState = lib_escort_mod:mon_be_killed(State, Scene, ScenePoolId, CopyId, X, Y, ServerId, Monid, MonAutoId, MonLv, GuildId, AtterId, AtterName),
    {noreply, NewState};

do_handle_cast({'mon_stop', Scene, PoolId, CopyId, Monid, MonAutoId, MonLv, Hp, GuildId, X, Y}, State) ->
    NewState = lib_escort_mod:mon_stop(State, Scene, PoolId, CopyId, Monid, MonAutoId, MonLv, Hp, GuildId, X, Y),
    {noreply, NewState};

do_handle_cast({'walk_check_back', Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, UserList}, State) ->
    NewState = lib_escort_mod:walk_check_back(State, Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, UserList),
    {noreply, NewState};

do_handle_cast({'mon_move', Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, X, Y, Hp, HpMax}, State) ->
    NewState = lib_escort_mod:mon_move(State, Scene, PoolId, CopyId, Monid, MonAutoId, GuildId, X, Y, Hp, HpMax),
    {noreply, NewState};

do_handle_cast({'reconnect', ServerId, GuildId, RoleId}, State) ->
    NewState = lib_escort_mod:reconnect(State, ServerId, GuildId, RoleId),
    {noreply, NewState};

do_handle_cast({'local_init', ServerId}, State) ->
    NewState = lib_escort_mod:local_init(State, ServerId),
    {noreply, NewState};

do_handle_cast({'gm_start'}, State) ->
    NewState = lib_escort_mod:gm_start(State),
    {noreply, NewState};

do_handle_cast({'gm_act_end'}, State) ->
    NewState = lib_escort_mod:act_end(State),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'act_start'}, State) ->
    NewState = lib_escort_mod:act_start(State),
    {noreply, NewState};

do_handle_info({'act_end'}, State) ->
    NewState = lib_escort_mod:act_end(State),
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.