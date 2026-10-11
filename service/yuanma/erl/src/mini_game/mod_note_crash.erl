%%% ---------------------------------------------------------------------------
%%% @doc            mod_note_crash.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏-音符碰撞进程
%%% ---------------------------------------------------------------------------
-module(mod_note_crash).

-behaviour(gen_server).

-include("common.hrl").
-include("mini_game.hrl").

-export([
    start/1                 % 游戏开启
    ,start2/1
    ,start_fail/1
    ,set_board/1            % 棋盘设置
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
    case erlang:whereis(pname(RoleId)) of
        PId when is_pid(PId) -> % 存在旧进程
            ?ERR("start game error ~p~n", [{utime:unixtime(), Args}]),
            stop(RoleId);
        _ ->
            gen_server:start({local, pname(RoleId)}, ?MODULE, Args, [])
    end.

start2([RoleId, EndTime]) ->
    gen_server:cast(pname(RoleId), {'init', EndTime}).

%% 开启失败
start_fail([RoleId]) ->
    gen_server:cast(pname(RoleId), {'start_fail'}).

%% 棋盘设置
set_board([RoleId | Args]) ->
    gen_server:cast(pname(RoleId), {'set_board', Args}).

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
    case erlang:whereis(pname(RoleId)) of
        PId when is_pid(PId) ->
            PId ! 'time_out';
        _ -> % undefined 可能因快捷键开启
            skip
    end.

%%% ================================ 回调函数 ================================

init(Args) ->
    State = lib_note_crash_mod:init(Args),
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

%% 时间初始化
do_cast({'init', EndTime}, State) ->
    NewState = lib_note_crash_mod:init([EndTime, State]),
    {noreply, NewState};

do_cast({'start_fail'}, State) ->
    lib_note_crash_mod:start_fail(State),
    {stop, normal, State};

%% 棋盘初始化
do_cast({'set_board', Args}, State) ->
    NewState = lib_note_crash_mod:set_board(State, Args),
    {noreply, NewState};

%% 断线重连
do_cast('reconnect', State) ->
    lib_note_crash_mod:reconnect(State),
    {noreply, State};

%% 游戏信息反馈(音符碰撞游戏反馈已不走这里,走39921协议)
do_cast({'game_feedback', _Args}, State) ->
    % NewState = lib_note_crash_mod:game_feedback(State, Args),
    {noreply, State};

%% 实时排行榜
do_cast({'send_game_rank_list', Args}, State) ->
    lib_note_crash_mod:send_game_rank_list(State, Args),
    {noreply, State};

do_cast(_Msg, State) ->
    {noreply, State}.

%% ---------------------------------
%% handle_info
%% ---------------------------------

%% 游戏结算信息(预留时间结算)
do_info('game_settlement', State) ->
    erlang:send_after(?SETTLE_TIME * 1000, self(), 'time_out'),
    {noreply, State};

%% 游戏计时器到时
do_info('time_out', State) ->
    lib_note_crash_mod:game_time_out(State),
    {stop, normal, State};

do_info(_Info, State) ->
    {noreply, State}.

%%% ================================ 内部函数 ================================

%% 进程名
pname(RoleId) ->
    list_to_atom(lists:concat([?MODULE, '_', RoleId])).