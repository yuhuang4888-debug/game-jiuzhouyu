%%% ---------------------------------------------------------------------------
%%% @doc            pp_mini_game.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-22
%%% @description    小游戏协议路由
%%% ---------------------------------------------------------------------------
-module(pp_mini_game).

-include("common.hrl").
-include("mini_game.hrl").
-include("server.hrl").

-export([
    handle/3
    ,send_error_code/2
]).

handle(Cmd, PS, Data) ->
    % ?PRINT("Cmd ~p~n", [{Cmd, Data}]),
    do_handle(Cmd, PS, Data).

%% ---------------------------------
%% 小游戏-通用
%% ---------------------------------

%% 游戏开启(手动开启)
%% @param Args :: [GameType, ModuleId, SubId]
do_handle(39901, PS, Args) ->
    lib_mini_game:game_start(PS, Args);

%% 断线重连
do_handle(39902, PS, []) ->
    lib_mini_game:reconnect(PS);

%% 游戏信息反馈
%% @param Args :: [GameType, ModuleId, SubId, InfoList]
do_handle(39903, PS, Args) ->
    lib_mini_game:game_feedback(PS, Args);

%% 实时排行榜
%% @param Args :: [GameType, ModuleId, SubId]
do_handle(39904, PS, Args) ->
    lib_mini_game:send_game_rank_list(PS, Args);

%% ---------------------------------
%% 小游戏-音符碰撞
%% ---------------------------------

%% 棋盘初始化
%% @param Args :: [Type, InfoList, BoardRows, EffectList, RateList]
do_handle(39921, PS, Args) ->
    lib_mini_game:set_board(PS, Args);

%% 主动结算结束
do_handle(39923, PS, []) ->
    lib_mini_game:game_stop(PS, [?GAME_NOTE_CRASH]);

%% ---------------------------------
%% 小游戏-节奏达人
%% ---------------------------------

%% 容错
do_handle(_, _, _) ->
    {error, "Illegal protocol~n"}.

%% 发送错误码
%% @param ErrInfo :: integer() | {integer(), Args}
send_error_code(PS, ErrInfo) when is_record(PS, player_status) ->
    #player_status{sid = SId} = PS,
    send_error_code(SId, ErrInfo);
send_error_code(SId, ErrInfo) when is_pid(SId) ->
    ?PRINT("send errcode ~p~n", [ErrInfo]),
    {CodeInt, CodeArgs} = util:parse_error_code(ErrInfo),
    {ok, BinData} = pt_399:write(39900, [CodeInt, CodeArgs]),
    lib_server_send:send_to_sid(SId, BinData);
send_error_code(RoleId, ErrInfo) ->
    ?PRINT("send errcode ~p~n", [ErrInfo]),
    {CodeInt, CodeArgs} = util:parse_error_code(ErrInfo),
    {ok, BinData} = pt_399:write(39900, [CodeInt, CodeArgs]),
    lib_server_send:send_to_uid(RoleId, BinData).