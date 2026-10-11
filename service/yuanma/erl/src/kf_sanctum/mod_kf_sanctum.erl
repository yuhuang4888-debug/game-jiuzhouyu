%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :永恒圣殿
%%%-------------------------------------------------------------------

-module(mod_kf_sanctum).

-behaviour(gen_server).

-include("kf_sanctum.hrl").
-include("common.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

        % ,boss_be_killed/7


-export([
        update_zone_map/2
        ,boss_be_killed/6
        ,enter/5
        ,exit/3
        ,reconect/4
        ,gm_start_act/1
        ,gm_close_act/0
        ,updata_role_info/1
        ,gm_clear_server_user/1
    ]).

enter(ServerId, Node, RoleId, Scene, RoleScene) ->
    cast_center([{'enter', ServerId, Node, RoleId, Scene, RoleScene}]).

exit(ServerId, RoleId, Scene) ->
    cast_center([{'exit', ServerId, RoleId, Scene}]).

reconect(ServerId, RoleId, Scene, Arg) ->
    cast_center([{'reconect', ServerId, RoleId, Scene, Arg}]).

gm_start_act(Min) ->
    cast_center([{'gm_start_act', Min}]).

gm_close_act() ->
    cast_center([{'gm_close_act'}]).

updata_role_info(ServerId) ->
    call_center([{'updata_role_info', ServerId}]).

gm_clear_server_user(ServerId) ->
    cast_center([{'gm_clear_server_user', ServerId}]).

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

update_zone_map(ServerInfo, Z2SMap) ->
    gen_server:cast(?MODULE, {'update_zone_map', ServerInfo, Z2SMap}).

boss_be_killed(BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId) ->
    gen_server:cast(?MODULE, {'boss_be_killed', BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_kf_sanctum_mod:init(),
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_kf_sanctum Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_sanctum Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_sanctum Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call({'updata_role_info', ServerId}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {reply, ZoneId, State};

do_handle_call(_, State) -> {reply, ok, State}.

do_handle_cast({'update_zone_map', ServerInfo, Z2SMap}, State) ->
    NewState = lib_kf_sanctum_mod:update_zone_map(State, ServerInfo, Z2SMap),
    {noreply, NewState};

do_handle_cast({'boss_be_killed', BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId}, State) ->
    NewState = lib_kf_sanctum_mod:boss_be_killed(State, BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId),
    {noreply, NewState};

do_handle_cast({'enter', ServerId, Node, RoleId, Scene, RoleScene}, State) ->
    NewState = lib_kf_sanctum_mod:enter(State, ServerId, Node, RoleId, Scene, RoleScene),
    {noreply, NewState};

do_handle_cast({'exit', ServerId, RoleId, Scene}, State) ->
    NewState = lib_kf_sanctum_mod:exit(State, ServerId, RoleId, Scene),
    {noreply, NewState};

do_handle_cast({'reconect', ServerId, RoleId, Scene, Arg}, State) ->
    NewState = lib_kf_sanctum_mod:reconect(State, ServerId, RoleId, Scene, Arg),
    {noreply, NewState};

do_handle_cast({'gm_start_act', Min}, State) ->
    NewState = lib_kf_sanctum_mod:gm_start_act(State, Min),
    {noreply, NewState};

do_handle_cast({'gm_clear_server_user', ServerId}, State) ->
    NewState = lib_kf_sanctum_mod:gm_clear_server_user(State, ServerId),
    {noreply, NewState};

do_handle_cast({'gm_close_act'}, State) ->
     NewState = lib_kf_sanctum_mod:act_end(State),
    {noreply, NewState};

do_handle_cast(_, State) -> {noreply, State}.

do_handle_info({'act_start'}, State) ->
    NewState = lib_kf_sanctum_mod:act_start(State),
    {noreply, NewState};

do_handle_info({'boss_reborn', CopyId, Scene, MonType, MonName, BossId, SanMontype}, State) ->
    NewState = lib_kf_sanctum_mod:boss_reborn(State, CopyId, Scene, MonType, MonName, BossId, SanMontype),
    {noreply, NewState};

do_handle_info({'notify_player_act_start', BefMintue}, State) ->
    NewState = lib_kf_sanctum_mod:notify_player_act_start(State, BefMintue),
    {noreply, NewState};

do_handle_info({'act_end'}, State) ->
    NewState = lib_kf_sanctum_mod:act_end(State),
    {noreply, NewState};

do_handle_info(_, State) -> {noreply, State}.