%% ---------------------------------------------------------------------------
%% @doc mod_custom_act_liveness.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-03-04
%% @deprecated 节日活跃奖励
%% ---------------------------------------------------------------------------
-module(mod_custom_act_liveness).

-behavious(gen_server).

-include("custom_act_liveness.hrl").
-include("common.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% 活动开启
act_start(Type, SubType) -> 
    gen_server:cast(?MODULE, {'act_start', Type, SubType}).

%% 活动结束
act_end(Type, SubType) -> 
    gen_server:cast(?MODULE, {'act_end', Type, SubType}).

%% 登录
login(RoleId) ->
    gen_server:cast(?MODULE, {'login', RoleId}).

%% 节日活跃界面
send_info(RoleId, Type, SubType) ->
    gen_server:cast(?MODULE, {'send_info', RoleId, Type, SubType}).

%% 增加提交次数
add_commit_count(Type, SubType, Count) ->
    gen_server:cast(?MODULE, {'add_commit_count', Type, SubType, Count}).

%% 领取奖励
receive_ser_reward(RoleId, Type, SubType, GradeId) ->
    gen_server:cast(?MODULE, {'receive_ser_reward', RoleId, Type, SubType, GradeId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_custom_act_liveness_mod:init(),
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'act_start', Type, SubType}, State) ->
    lib_custom_act_liveness_mod:act_start(State, Type, SubType);
do_handle_cast({'act_end', Type, SubType}, State) ->
    lib_custom_act_liveness_mod:act_end(State, Type, SubType);
do_handle_cast({'login', RoleId}, State) ->
    lib_custom_act_liveness_mod:login(State, RoleId);
do_handle_cast({'send_info', RoleId, Type, SubType}, State) -> 
    lib_custom_act_liveness_mod:send_info(State, RoleId, Type, SubType),
    {ok, State};
do_handle_cast({'add_commit_count', Type, SubType, Count}, State) -> 
    lib_custom_act_liveness_mod:add_commit_count(State, Type, SubType, Count);
do_handle_cast({'receive_ser_reward', RoleId, Type, SubType, GradeId}, State) -> 
    lib_custom_act_liveness_mod:receive_ser_reward(State, RoleId, Type, SubType, GradeId);

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.