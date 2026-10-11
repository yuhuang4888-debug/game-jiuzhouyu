%%% ---------------------------------------------------------------------------
%%% @doc            lib_note_crash_mod.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏音符碰撞进程库函数
%%% ---------------------------------------------------------------------------
-module(lib_note_crash_mod).

-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("mini_game.hrl").

-export([
    init/1                  % 初始化
    ,start_fail/1           % 开启失败
    ,set_board/2            % 棋盘设置
    ,reconnect/1            % 断线重连
    ,game_feedback/2        % 游戏信息反馈
    ,send_game_rank_list/2  % 实时排行榜
    ,game_time_out/1        % 游戏结束结算
]).

%%% ================================ 小游戏流程相关 ================================

%% 初始化
init([PlayerInfo, ModuleId, SubId]) ->
    State = #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    },

    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            GfeastPlayer = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:init_mini_game(GfeastPlayer, {?GAME_NOTE_CRASH});
        _ -> % 秘籍开启
            #mini_game_player{id = RoleId} = PlayerInfo,
            EndTime = utime:unixtime() + ?DUR_NOTE_CRASH,
            mod_note_crash:start2([RoleId, EndTime])
    end,

    State;

%% 活动功能模块回调初始化时间
init([EndTime, State]) ->
    NowTime = utime:unixtime(),
    StartTime = EndTime - ?DUR_NOTE_CRASH,
    TRef = erlang:send_after(timer:seconds(EndTime - NowTime), self(), 'time_out'),
    State1 = State#note_crash_state{start_time = StartTime, end_time = EndTime, tref = TRef},

    % 通知对应功能模块和玩家游戏开启
    notify_module_start(State1),
    notify_player_start(State1),

    State1.

%% 开启失败
start_fail(State) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = Player
    } = State,
    #mini_game_player{
        id = RoleId
    } = Player,
    Args = [?ERRCODE(err399_note_crash_too_late), ?GAME_NOTE_CRASH, ModuleId, SubId, 0, 0, []],
    lib_server_send:send_to_uid(RoleId, pt_399, 39901, Args).

%% 棋盘设置
%% @return NewState :: #note_crash_state{}
set_board(State, [?INITIALIZE, _InfoList, BoardRows, EffectList, RateList]) ->
    F = fun({RowId, RowNotes}, M) ->
        maps:put(RowId, RowNotes, M)
    end,
    Board = lists:foldl(F, #{}, BoardRows),
    State#note_crash_state{
        board       = Board,
        effects     = EffectList,
        rates       = RateList
    };
%% @param InfoList :: [X, Y, DirX, DirY, Score]
set_board(State, [?UPDATE, InfoList, BoardRows, EffectList, _RateList]) ->
    #note_crash_state{module_id = ModuleId, sub_id = SubId, rates = RateList} = State,
    NewState = set_board(State, [?INITIALIZE, [], BoardRows, EffectList, RateList]),
    game_feedback(NewState, [ModuleId, SubId, InfoList]).

%% 断线重连
reconnect(State) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo,
        start_time  = StartTime,
        end_time    = EndTime,
        board       = Board,
        effects     = EffectList,
        rates       = RateList,
        score       = Score
    } = State,
    #mini_game_player{
        id      = RoleId
    } = PlayerInfo,
    F = fun(RowId, RowNotes, Acc) ->
        [{RowId, RowNotes}|Acc]
    end,
    BoardRows = maps:fold(F, [], Board),
    Args = [ModuleId, SubId, StartTime, EndTime, Score, BoardRows, EffectList, RateList],
    lib_server_send:send_to_uid(RoleId, pt_399, 39922, Args).

%% 游戏信息反馈
%% @param InfoList :: [X, Y, DirX, DirY, Score]
game_feedback(State, [_, _, InfoList] = Args) ->
    #note_crash_state{player = PlayerInfo} = State,
    #mini_game_player{id = RoleId} = PlayerInfo,
    case check_game_feedback(State, Args) of
        true ->
            do_game_feedback(State, InfoList);
        {false, ErrCode} ->
            pp_mini_game:send_error_code(RoleId, ErrCode),
            ?IF(ErrCode == ?FAIL, self() ! 'time_out', skip), % 遇到非法错误，杀掉进程
            State
    end.

%% @return NewState :: #note_crash_state{}
do_game_feedback(State, [_X, _Y, _DirX, _DirY, Score]) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    % 更新分数
    {NewScore, NewState} = update_score(State, Score),
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_feedback(NPlayerInfo, {?GAME_NOTE_CRASH, NewScore, []});
        _ ->
            skip
    end,
    NewState.

%% 实时排行榜
send_game_rank_list(State, [_RoleId]) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:send_game_rank_list(NPlayerInfo, ?GAME_NOTE_CRASH);
        _ ->
            skip
    end.

%% 游戏结束结算
game_time_out(State) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_time_out(NPlayerInfo, {?GAME_NOTE_CRASH, []});
        _ ->
            skip
    end.

%%% ================================ 内部函数 ================================

%% 通知对应功能模块
notify_module_start(State) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_feedback(NPlayerInfo, {?GAME_NOTE_CRASH, ?GAME_START_SIGNAL, []});
        _ ->
            skip
    end.

%% 通知玩家(自动开启需要调用)
notify_player_start(State) ->
    #note_crash_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = Player,
        start_time  = StartTime,
        end_time    = EndTime
    } = State,
    #mini_game_player{
        id = RoleId
    } = Player,
    Args = [?SUCCESS, ?GAME_NOTE_CRASH, ModuleId, SubId, StartTime, EndTime, []],
    lib_server_send:send_to_uid(RoleId, pt_399, 39901, Args).

%% 游戏分数校验
%% @param InfoList :: [X, Y, DirX, DirY, Score]
%% @return true | {false, ErrCode}
check_game_feedback(State, [ModuleId, SubId, InfoList]) ->
    #note_crash_state{
        module_id   = MId,
        sub_id      = SId,
        start_time  = StartTime,
        end_time    = EndTime
    } = State,
    [X, Y, _DirX, _DirY, Score] = InfoList,
    [{MaxX, MaxY}] = ?BOARD_SIZE,
    % IsLegalDir = lists:member(Dir, ?DIRECTIONS),
    if
        % 游戏模块不匹配
        MId /= ModuleId; SId /= SubId ->
            ?ERR("error module_id/sub_id ~p~p~n", [{MId, SId}, {ModuleId, SubId}]),
            {false, ?FAIL};
        % 非法坐标
        X < 0; Y < 0; X > MaxX; Y > MaxY ->
            ?ERR("error coordination ~p~n", [{X, Y}]),
            {false, ?FAIL};
        % % 非法移动方向
        % not IsLegalDir ->
        %     ?ERR("error direction ~p~n", [Dir]),
        %     {false, ?FAIL};
        % 非法分数
        Score < 0 ->
            ?ERR("error illegal score ~p~n", [Score]),
            {false, ?FAIL};
        % 非法时间
        StartTime =< 0 orelse EndTime =< 0 ->
            ?ERR("err time info ~p~n", [{StartTime, EndTime}]),
            {false, ?FAIL};
        true ->
            true
    end.

%% 更新分数(传总分)
%% @return {NewScore, NewState}
update_score(State, Score) ->
    NewState = State#note_crash_state{score = Score},
    {Score, NewState}.