%% ---------------------------------------------------------------------------
%% @doc mod_race_act
%% @author zengzy
%% @since  2017-12-20
%% @deprecated  竞榜活动进程
%% ---------------------------------------------------------------------------
-module(mod_race_act).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([
    start_link/0
]).
-compile(export_all).
-include("race_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------


%%本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mod, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mod, Msg).

%%跨服中心分发到管理进程
call_mod(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mod(Msg) ->
    gen_server:cast(?MODULE, Msg).

gm_refresh()->
    gen_server:cast(?MODULE, {gm_refresh}).

gm_close_act()->
    gen_server:cast(?MODULE, {gm_close_act}).

%%刷新定时器秘籍
gm_refresh_ref()->
    gen_server:cast(?MODULE, {gm_refresh_ref}).

print()->
    gen_server:cast(?MODULE, {print}).

%%区改变
zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {zone_change, ServerId, OldZone, NewZone}).

%%每天分配
midnight_recalc() ->
    gen_server:cast(?MODULE, {midnight_recalc}).

%%重置结束
reset_end() ->
    gen_server:cast(?MODULE, {reset_end}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

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
    State = lib_race_act_mod:init(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({mod,Module,Method,Args},State)->
    NState = Module:Method(Args,State),
    {noreply, NState};
do_handle_cast({zone_change, ServerId, OldZone, NewZone}, State) ->
    lib_race_act_mod:zone_change(ServerId, OldZone, NewZone, State);

do_handle_cast({send_info,ServerId,RoleId,Type,SubType}, State) ->
    lib_race_act_mod:send_info(ServerId,RoleId,Type,SubType,State);
do_handle_cast({get_type_rank,Type,SubType,RankRole}, State) ->
    lib_race_act_mod:get_type_rank(Type,SubType,RankRole,State);
do_handle_cast({treasure_draw,ServerId,RoleId,Type,SubType,Times}, State) ->
    lib_race_act_mod:treasure_draw(ServerId,RoleId,Type,SubType,Times,State);
do_handle_cast({get_stage_reward,ServerId,RoleId,Type,SubType,RewardId}, State) ->
    lib_race_act_mod:get_stage_reward(ServerId,RoleId,Type,SubType,RewardId,State);

%% 请求跨服的数据
do_handle_cast({'sync_server_data', ServerId}, State) ->
    lib_race_act_mod:sync_server_data(ServerId, State);

do_handle_cast({'midnight_recalc'}, State) ->
    lib_race_act_mod:midnight_recalc(State);

do_handle_cast({'reset_end'}, State) ->
    lib_race_act_mod:reset_end(State);


% %% 本地操作操作
% local_op(M, F, A) ->
%     ok.

do_handle_cast({gm_refresh},State)->
    lib_race_act_mod:gm_refresh(State);
do_handle_cast({gm_close_act},State)->
    lib_race_act_mod:close_act(State);
do_handle_cast({gm_refresh_ref},State)->
    lib_race_act_mod:gm_refresh_ref(State);
do_handle_cast({print},State)->
    ?INFO("~p~n",[State]),
    {noreply,State};
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({close_act}, State) ->
    lib_race_act_mod:close_act(State);
do_handle_info({open_act}, State) ->
    lib_race_act_mod:open_act(State);
do_handle_info({close_show_act}, State) ->
    lib_race_act_mod:close_show_act(State);
do_handle_info({zero_check}, State) ->
    lib_race_act_mod:zero_check(State);
do_handle_info(_Info, State) -> {noreply, State}.




