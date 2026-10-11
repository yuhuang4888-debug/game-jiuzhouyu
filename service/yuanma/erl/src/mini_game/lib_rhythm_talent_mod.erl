%%% ---------------------------------------------------------------------------
%%% @doc            lib_rhythm_talent_mod.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-04-19
%%% @description    小游戏节奏达人进程库函数
%%% ---------------------------------------------------------------------------
-module(lib_rhythm_talent_mod).

-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("mini_game.hrl").

-export([
    init/1                  % 初始化
    ,reconnect/1            % 断线重连
    ,game_feedback/2        % 游戏信息反馈
    ,send_game_rank_list/2  % 实时排行榜
    ,game_settlement/1      % 游戏结算
]).

%%% ================================ 小游戏流程相关 ================================

%% 初始化
init([PlayerInfo, ModuleId, SubId]) ->
    StartTime = utime:unixtime(),
    SongId = urand:list_rand(data_rhythm_talent:get_all_id()),
    TRef = erlang:send_after(?DUR_RHYTHM_TALENT * 1000, self(), 'time_out'),
    erlang:send_after((?DUR_RHYTHM_TALENT - ?SETTLE_TIME) * 1000, self(), 'game_settlement'),
    State = #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo,
        start_time  = StartTime,
        song_id     = SongId,
        tref        = TRef
    },
    % 通知对应功能模块和玩家游戏开启
    notify_module_start(State),
    notify_player_start(State),
    ?PRINT("~p start~n", [?MODULE]),
    State.

%% 断线重连
reconnect(State) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo,
        start_time  = StartTime
    } = State,
    #mini_game_player{
        id      = RoleId
    } = PlayerInfo,
    Args = [?GAME_RHYTHM_TALENT, ModuleId, SubId, StartTime, []],
    lib_server_send:send_to_uid(RoleId, pt_399, 39902, Args).

%% 游戏信息反馈
%% @param InfoList :: [BeatId, Score]
game_feedback(State, [_, _, InfoList] = Args) ->
    case check_game_feedback(State, Args) of
        true ->
            do_game_feedback(State, InfoList);
        {false, ErrCode} ->
            #rhythm_talent_state{player = PlayerInfo} = State,
            #mini_game_player{id = RoleId} = PlayerInfo,
            pp_mini_game:send_error_code(RoleId, ErrCode),
            State
    end.

%% @return NewState :: #rhythm_talent_state{}
do_game_feedback(State, InfoList) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    % 更新分数
    {NewScore, NewState} = update_score(State, InfoList),
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_feedback(NPlayerInfo, {?GAME_RHYTHM_TALENT, NewScore, []});
        _ ->
            skip
    end,
    NewState.

%% 实时排行榜
send_game_rank_list(State, [_RoleId]) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:send_game_rank_list(NPlayerInfo, ?GAME_RHYTHM_TALENT);
        _ ->
            skip
    end.

%% 游戏结算
game_settlement(State) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo,
        song_id     = SongId,
        score_map   = ScoreMap
    } = State,
    % 结算评分数据
    {TotalScore, PNum, ConsecPNum} = calc_game_result(SongId, ScoreMap),
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_time_out(NPlayerInfo, {?GAME_RHYTHM_TALENT, [TotalScore, PNum, ConsecPNum]});
        _ ->
            skip
    end.

%%% ================================ 内部函数 ================================

%% 通知对应功能模块
notify_module_start(State) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = PlayerInfo
    } = State,
    % 同步到活动进程
    case {ModuleId, SubId} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            NPlayerInfo = lib_guild_feast:trans_mgp_to_gfeast_player(PlayerInfo),
            mod_guild_feast_mgr:game_feedback(NPlayerInfo, {?GAME_RHYTHM_TALENT, ?GAME_START_SIGNAL, []});
        _ ->
            skip
    end.

%% 通知玩家(自动开启需要调用)
notify_player_start(State) ->
    #rhythm_talent_state{
        module_id   = ModuleId,
        sub_id      = SubId,
        player      = Player,
        start_time  = StartTime,
        song_id     = SongId
    } = State,
    #mini_game_player{
        id = RoleId
    } = Player,
    OtherInfos = [SongId],
    Args = [?SUCCESS, ?GAME_RHYTHM_TALENT, ModuleId, SubId, StartTime, OtherInfos],
    lib_server_send:send_to_uid(RoleId, pt_399, 39901, Args).

%% 游戏分数校验
%% @param InfoList :: [BeatId, Score]
%% @return true | {false, ErrCode}
check_game_feedback(State, [ModuleId, SubId, InfoList]) ->
    #rhythm_talent_state{
        module_id   = MId,
        sub_id      = SId,
        start_time  = StartTime,
        song_id     = SongId,
        score_map   = ScoreMap
    } = State,
    [BeatId, Score] = InfoList,
    BaseBeat = data_rhythm_talent:get_beat(SongId, BeatId),
    Temp = maps:get(BeatId, ScoreMap, undefined),
    {_, HighestSc, ?GRADE_PERFECT} = lists:keyfind(?GRADE_PERFECT, 3, ?SCORE_GRADES),
    if
        % 游戏模块不匹配
        MId /= ModuleId orelse SId /= SubId ->
            ?ERR("error module_id/sub_id ~p~p~n", [{MId, SId}, {ModuleId, SubId}]),
            {false, ?FAIL};
        % 配置缺失
        not is_record(BaseBeat, base_rhythm_talent) ->
            ?ERR("error beat_id~p~n", [{SongId, BeatId}]),
            {false, ?MISSING_CONFIG};
        % 已有记录
        Temp /= undefined ->
            ?ERR("error already has record ~p~n", [BeatId]),
            {false, ?FAIL};
        % 非法分数
        Score < 0 orelse Score > HighestSc ->
            ?ERR("error illegal score ~p~n", [Score]),
            {false, ?FAIL};
        true ->
            NowTime = utime:longunixtime(),
            #base_rhythm_talent{
                time    = RelaTime
            } = BaseBeat,
            if
                % 出现时间非法(以毫秒计算)
                StartTime*1000+RelaTime > NowTime ->
                    ?ERR("error illegal appear time ~p~n", [{StartTime, RelaTime, NowTime}]),
                    {false, ?FAIL};
                true ->
                    true
            end
    end.

%% 更新分数
%% @param InfoList :: [BeatId, Score]
%% @return {NewScore, NewState}
update_score(State, [BeatId, Score]) ->
    #rhythm_talent_state{score_map = ScoreMap} = State,
    OTotalScore = maps:get(0, ScoreMap, 0),
    NTotalScore = OTotalScore+Score,
    NMap1 = maps:put(BeatId, Score, ScoreMap),
    NMap2 = maps:put(0, NTotalScore, NMap1),
    NewState = State#rhythm_talent_state{score_map = NMap2},
    {NTotalScore, NewState}.

%% 游戏结算
%% @return {总分, Perfect数, 连P数}
calc_game_result(SongId, ScoreMap) ->
    TotalScore = maps:get(0, ScoreMap, 0),
    AllBeats = data_rhythm_talent:get_all_beats(SongId),
    F = fun(BeatId, {PNum, ConsecPNum, TConsecPNum}) -> % {P数, 连P数, 当前连P数}
        Score = maps:get(BeatId, ScoreMap, 0),
        case calc_score_grade(Score, ?SCORE_GRADES) of
            ?GRADE_PERFECT ->
                {NPNum, NTConsecPNum} = {PNum + 1, TConsecPNum + 1};
            _ ->
                {NPNum, NTConsecPNum} = {PNum, 0}
        end,
        NConsecPNum = ?IF(NTConsecPNum > ConsecPNum, NTConsecPNum, ConsecPNum),
        {NPNum, NConsecPNum, NTConsecPNum}
    end,
    {PNum, ConsecPNum, _} = lists:foldl(F, {0, 0, 0}, AllBeats),
    {TotalScore, PNum, ConsecPNum}.

%% 计算分数评分
calc_score_grade(_, []) ->
    0;
calc_score_grade(Score, [{LowScore, HighScore, Grade}|_]) when Score >= LowScore, Score =< HighScore ->
    Grade;
calc_score_grade(Score, [_|T]) ->
    calc_score_grade(Score, T).