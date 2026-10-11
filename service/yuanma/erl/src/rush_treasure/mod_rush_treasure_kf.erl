%%% -------------------------------------------------------------------
%%% @doc        mod_rush_treasure_kf                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-25 9:40               
%%% @deprecated 冲榜夺宝跨服进程
%%% -------------------------------------------------------------------

-module(mod_rush_treasure_kf).
%% API
-export([start_link/0, handle_cast/2, handle_call/3, handle_info/2, terminate/2, code_change/3]).
-export([
    init/1,
    cast_center/1,
    call_center/1,
    cast_mod/1,
    call_mod/1,
    zone_change/3,
    server_info_change/2,
    rush_treasure_no_zone_tv/2
]).

-include("errcode.hrl").
-include("common.hrl").

%% 本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)-> mod_clusters_node:apply_cast(?MODULE, cast_mod, Msg).

call_center(Msg)-> mod_clusters_node:apply_call(?MODULE, call_mod, Msg).

%% 跨服中心分发到管理进程
cast_mod(Msg) -> gen_server:cast(?MODULE, Msg).

call_mod(Msg) -> gen_server:call(?MODULE, Msg).

%% 区改变
zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {zone_change, ServerId, OldZone, NewZone}).

%% 服信息发生改变
server_info_change(ServerId, KVList) ->
    gen_server:cast(?MODULE, {server_info_change, ServerId, KVList}).

%% 传闻回调
rush_treasure_no_zone_tv(TvArgs, AllZoneIdList) ->
    gen_server:cast(?MODULE, {rush_treasure_no_zone_tv, TvArgs, AllZoneIdList}).

%%% ====================================== callback functions ======================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%% ====================================== respond functions ======================================

init([]) ->
    State = lib_rush_treasure_mod_kf:init(),
    {ok, State}.

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

do_handle_cast({mod, Module, Method, Args},State)->
    NState = Module:Method(Args, State),
    {noreply, NState};

do_handle_cast({send_rush_info, ServerId, RoleId, Type, SubType}, State) ->
    lib_rush_treasure_mod_kf:send_info(ServerId, RoleId, Type, SubType, State);

do_handle_cast({get_rush_type_rank,Type,SubType, RoleId, ServerId, Node}, State) ->
    ?PRINT("enter~n",[]),
    lib_rush_treasure_mod_kf:get_rush_type_rank(Type, SubType, RoleId, ServerId, Node, State);

do_handle_cast({rush_treasure_draw, ServerId, RoleId, Type, SubType, Times, AutoBuy}, State) ->
    lib_rush_treasure_mod_kf:rush_treasure_draw(ServerId, RoleId, Type, SubType, Times, AutoBuy, State);

do_handle_cast({get_rush_stage_reward, ServerId, RoleId, Type, SubType, RewardId}, State) ->
    lib_rush_treasure_mod_kf:get_stage_reward(ServerId, RoleId, Type, SubType, RewardId, State);

do_handle_cast({act_end,Type, SubType, ServerId}, State) ->
    lib_rush_treasure_mod_kf:act_end(Type, SubType, ServerId, State);

do_handle_cast({zone_change, ServerId, OldZone, NewZone}, State) ->
    lib_rush_treasure_mod_kf:rush_zone_change(ServerId, OldZone, NewZone, State);

do_handle_cast({server_info_change, ServerId, KVList}, State) ->
    lib_rush_treasure_mod_kf:server_info_change(ServerId, KVList, State);

do_handle_cast({gm_act_end,Type, SubType}, State) ->
    lib_rush_treasure_mod_kf:gm_act_end(Type, SubType, State);

do_handle_cast({rush_treasure_no_zone_tv, TvArgs, AllZoneIdList}, State) ->
    lib_rush_treasure_mod_kf:send_tv_act_is_zone_no(TvArgs, AllZoneIdList),
    {noreply, State};

do_handle_cast(_Msg, State) -> {noreply, State}.

do_handle_info(_Info, State) -> {noreply, State}.


