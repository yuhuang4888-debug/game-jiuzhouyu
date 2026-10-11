%%% ---------------------------------------------------------------------------
%%% @doc            mod_rhythm_talent.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏-节奏达人进程
%%% ---------------------------------------------------------------------------
-module(mod_rhythm_talent).

-behaviour(gen_server).

-include("common.hrl").
-include("mini_game.hrl").

-export([
    start/1                 % 游戏开启
    ,reconnect/1            % 断线重连
    ,game_feedback/1        % 游戏信息反馈
    ,send_game_rank_list/1  % 实时排行榜
    ,stop/1                 % 游戏中止
]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%% ================================ 外部接口 ================================

%% 小游戏的开启绑定某个功能模块
start([PlayerInfo|_] = Args) ->
    #mini_game_player{id = RoleId} = PlayerInfo,
    gen_server:start({local, pname(RoleId)}, ?MODULE, Args, []).

%% 断线重连
reconnect([RoleId]) ->
    gen_server:cast(pname(RoleId), 'reconnect').

%% 游戏信息反馈
game_feedback([RoleId | Args]) ->
    gen_server:cast(pname(RoleId), {'game_feedback', Args}).

%% 实时排行榜
send_game_rank_list([RoleId]) ->
    gen_server:cast(pname(RoleId), {'send_game_rank_list', [RoleId]}).

%% 主动结束游戏
stop(RoleId) ->
    PId = erlang:whereis(pname(RoleId)),
    PId ! 'time_out'.

%%% ================================ 回调函数 ================================

init(Args) ->
    State = lib_rhythm_talent_mod:init(Args),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?PRINT("~p terminate for ~p~n", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%% ================================ 响应函数 ================================

%% ---------------------------------
%% handle_call
%% ---------------------------------

do_call(_Request, _From, State) ->
    {reply, ok, State}.

%% ---------------------------------
%% handle_cast
%% ---------------------------------

%% 断线重连
do_cast('reconnect', State) ->
    lib_rhythm_talent_mod:reconnect(State),
    {noreply, State};

%% 游戏信息反馈
do_cast({'game_feedback', Args}, State) ->
    NewState = lib_rhythm_talent_mod:game_feedback(State, Args),
    {noreply, NewState};

%% 实时排行榜
do_cast({'send_game_rank_list', Args}, State) ->
    lib_rhythm_talent_mod:send_game_rank_list(State, Args),
    {noreply, State};

do_cast(_Msg, State) ->
    {noreply, State}.

%% ---------------------------------
%% handle_info
%% ---------------------------------

%% 游戏结算信息
do_info('game_settlement', State) ->
    ?PRINT("~p game_settlement~n", [?MODULE]),
    lib_rhythm_talent_mod:game_settlement(State),
    {noreply, State};

%% 游戏计时器到时
do_info('time_out', State) ->
    {stop, normal, State};

do_info(_Info, State) ->
    {noreply, State}.

%%% ================================ 内部函数 ================================

%% 进程名
pname(RoleId) ->
    list_to_atom(lists:concat([?MODULE, '_', RoleId])).