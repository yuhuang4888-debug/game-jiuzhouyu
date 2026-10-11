%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_evil.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-08
%% @Description:    诛邪战场
%%-----------------------------------------------------------------------------

-module (lib_dungeon_evil).
-include ("dungeon.hrl").
-include ("server.hrl").
-include ("rec_event.hrl").
-include ("common.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("skill.hrl").
-include ("scene.hrl").
-include ("language.hrl").

%% 副本行为接口
-export ([
    dunex_get_other_success_data/2
    ,dunex_get_send_reward/2
    ,dunex_update_dungeon_record/2
    ,dunex_get_best_record/2
    ,dunex_special_pp_handle/4
    ,dunex_push_settlement/2
    ,dunex_get_start_dun_args/2
    ,dunex_calc_auto_lv/2
    ,dunex_change_lv_when_role_out/2
]).

%% 其它接口
-export ([
    get_daily_reward/2
    ,set_daily_reward_got/2
    ,get_history_max_score/1
    ,push_evil_settlement/7
    ,upload_dummy_data/3
    ,handle_daily_reward/1
    ,create_dummy/2
    ,do_init/2
]).

-define (DUNID, begin [DunId|_] = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_EVIL), DunId end).

-define (DAILY_TIME_BOUNDARY, 79200). %% 22*3600

dunex_get_other_success_data(State, DungeonRole) ->
    Score = lib_dungeon:calc_score(State, DungeonRole#dungeon_role.id),
    Score.

%% 奖励只能手动领取
dunex_get_send_reward(_, _) ->
    [].

dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = _DunId, 
        % pass_time = PassTime,
        other = Score
    } = ResultData,
    NowTime = utime:unixtime(),
    DunId = ?DUNID,
    case maps:get(DunId, Record, []) of
        [{?DUNGEON_REC_UPDATE_TIME, OldTime},{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, {?DUNGEON_REC_MAX_SCORE, MaxScore},{?DUNGEON_REC_EVIL_REWARD, RwState}|_] ->
            DiffDays = diff_days(OldTime, NowTime),
            if
                DiffDays /= 0 orelse Score > DailyScore ->
                    NewDailyScore = Score,
                    NewMaxScore = if Score > MaxScore -> Score; true -> MaxScore end,
                    NewRwState = if DiffDays =:= 0 -> RwState; true -> 1 end,
                    Data = [{?DUNGEON_REC_UPDATE_TIME, NowTime},{?DUNGEON_REC_DAILY_MAX_SCORE, NewDailyScore}, {?DUNGEON_REC_MAX_SCORE, NewMaxScore},{?DUNGEON_REC_EVIL_REWARD, NewRwState}],
                    NewRecord = maps:put(DunId, Data, Record),
                    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
                    PS#player_status{dungeon_record = NewRecord};
                true ->
                    PS
            end;
        _ ->
            % Score = lib_dungeon:get_time_score(DunId, PassTime),
            Data = [{?DUNGEON_REC_UPDATE_TIME, NowTime},{?DUNGEON_REC_DAILY_MAX_SCORE, Score}, {?DUNGEON_REC_MAX_SCORE, Score},{?DUNGEON_REC_EVIL_REWARD, 1}],
            NewRecord = maps:put(DunId, Data, Record),
            lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
            PS#player_status{dungeon_record = NewRecord}
    end.

dunex_get_best_record(_DunId, Record) ->
    DunId = ?DUNID,
    case maps:find(DunId, Record) of
        {ok, [{?DUNGEON_REC_UPDATE_TIME, OldTime},{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, {?DUNGEON_REC_MAX_SCORE, MaxScore}|_]} ->
            DiffDays = diff_days(OldTime, utime:unixtime()),
            if
                DiffDays /= 0 ->
                    [{?DUNGEON_REC_DAILY_MAX_SCORE, 0}, {?DUNGEON_REC_MAX_SCORE, MaxScore}];
                true ->
                    [{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, {?DUNGEON_REC_MAX_SCORE, MaxScore}]
            end;
        _ ->
            [{?DUNGEON_REC_DAILY_MAX_SCORE, 0}, {?DUNGEON_REC_MAX_SCORE, 0}]
    end.


diff_days(OldTime, NowTime) ->
    utime:diff_days(OldTime, NowTime).
    % ZeroTime = utime:unixdate(OldTime),
    % TimeBoundary = ZeroTime + ?DAILY_TIME_BOUNDARY,
    % if
    %     (OldTime - TimeBoundary) * (NowTime - TimeBoundary) < 0 ->
    %         1;
    %     true ->
    %         0
    % end.

get_daily_reward(Player, Record) ->
    DunId = ?DUNID,
    case maps:find(DunId, Record) of
        {ok, [{?DUNGEON_REC_UPDATE_TIME, OldTime},{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, _Max, {?DUNGEON_REC_EVIL_REWARD, State}|_]} ->
            case diff_days(OldTime, utime:unixtime()) of
                0 ->
                    Rewards = lib_dungeon_api:get_dungeon_grade(Player, DunId, DailyScore),
%%                    case data_dungeon_grade:get_dungeon_grade(DunId, DailyScore) of
%%                        #dungeon_grade{reward = [_|_] = Rewards} ->
%%                            {ok, State, Rewards};
%%                        _ ->
%%                            {false, ?FAIL}
%%                    end;
                    {ok, State, Rewards};
                _ ->
                    {ok, 0, []}
            end;
        _ ->
            {false, ?FAIL}
    end.

set_daily_reward_got(RoleId, Record) ->
    DunId = ?DUNID,
    [Time, DailyScore, MaxScore, _|T] = maps:get(DunId, Record),
    Data = [Time, DailyScore, MaxScore, {?DUNGEON_REC_EVIL_REWARD, 2}|T],
    NewRecord = maps:put(DunId, Data, Record),
    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
    NewRecord.

get_history_max_score(#player_status{dungeon_record = undefined} = Player) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    lib_player:apply_cast(Player#player_status.pid, ?APPLY_CAST_SAVE, lib_dungeon, load_dungeon_record, []),
    get_history_max_score(NewPlayer);

get_history_max_score(Player) ->
    #player_status{dungeon_record = Record} = Player,
    [_, {_, Score}|_] = dunex_get_best_record(0, Record),
    Score.

dunex_push_settlement(State, DungeonRole) ->
    #dungeon_state{
        result_type = ResultType, 
        dun_id = DunId,
        now_scene_id = SceneId,
        result_subtype = ResultSubtype,
        mon_score = MonScore
    } = State, 
    #dungeon_role{node = Node, id = RoleId, count = Count} = DungeonRole,
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, push_evil_settlement, [DunId, ResultType, ResultSubtype, SceneId, MonScore, Count]).


push_evil_settlement(#player_status{dungeon_record = Record} = Player, DunId, ResultType, ResultSubtype, SceneId, MonScore, Count) when Record =/= undefined ->
    #player_status{dungeon_record = Record, sid = Sid} = Player,
    [{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, {?DUNGEON_REC_MAX_SCORE, MaxScore}] = dunex_get_best_record(DunId, Record),
    Data = [
        {?DUNGEON_RES_KEY_EVIL_DAILY_SCORE, DailyScore},
        {?DUNGEON_RES_KEY_EVIL_MAX_SCORE, MaxScore},
        {?DUNGEON_RES_KEY_EVIL_NOW_SCORE, MonScore}
    ],
    Grade = if ResultType =:= ?DUN_RESULT_TYPE_SUCCESS -> 3; true -> 0 end,
    {ok, BinData} = pt_610:write(61003, [ResultType, ResultSubtype, DunId, Grade, SceneId, [], Data, Count]),
    lib_server_send:send_to_sid(Sid, BinData);

push_evil_settlement(Player, DunId, ResultType, ResultSubtype, SceneId, MonScore, Count) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    push_evil_settlement(NewPlayer, DunId, ResultType, ResultSubtype, SceneId, MonScore, Count),
    NewPlayer.

dunex_special_pp_handle(State, Sid, 61036, []) ->
    #dungeon_state{mon_score = MonScore} = State,
    {ok, BinData} = pt_610:write(61036, [MonScore]),
    lib_server_send:send_to_sid(Sid, BinData).

do_init(State, _) ->
    #dungeon_state{role_list = RoleList} = State,
    case length(RoleList) of
        L when L < 3 andalso L > 0 ->
            [#dungeon_role{node = Node, id = RoleId}|_] = RoleList,
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, upload_dummy_data, [3 - L, self()]),
            State;
        _ ->
            State
    end.

dunex_get_start_dun_args(from_match, _Dun) ->
    [{do_sth, {?MODULE, do_init, []}}];

dunex_get_start_dun_args(_, _) -> [].

upload_dummy_data(Player, Num, DunPid) ->
    #player_status{figure = Figure, battle_attr = BattleAttr} = Player,
    DummyData = [Figure, BattleAttr, lib_dummy_api:get_skill_list(Player)],
    mod_dungeon:apply(DunPid, ?MODULE, create_dummy, [DummyData, Num]).

create_dummy(State, [DummyData, Num]) ->
    #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
    [Figure, BattleAttr, SkillList] = DummyData,
    #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
    [begin
        ChangeFigure = lib_dummy_api:change_figure(Figure, [rand_wing, create_name]),
        BattleAttr1 = lib_dummy_api:change_battle_attr(BattleAttr, [{hp_r, 0.6}, {att_r, 0.6}]), 
        MyArgs = [{skill, SkillList}, {group, ?DUN_DEF_GROUP}, {find_target, 3000},{type, 1},{revive_time, 10000}],
        lib_scene_object:async_create_a_dummy(SceneId, ScenePoolId, X, Y, self(), 1, ChangeFigure, BattleAttr1, MyArgs)
        % (?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X, Y, 1, self(), 1, MyArgs)
    end || _ <- lists:seq(1, Num)].

handle_daily_reward(#player_status{dungeon_record = undefined} = Player) ->
    handle_daily_reward(lib_dungeon:load_dungeon_record(Player));

handle_daily_reward(Player) ->
    % % lib_dungeon:load_dungeon_record(Player),
    % #player_status{dungeon_record = Record, id = RoleId} = Player,
    % DunId = ?DUNID,
    % % ?PRINT("4294967358 ~p~n", [maps:find(DunId, Record)]),
    % NewPlayer
    % = case maps:find(DunId, Record) of
    %     {ok, [{?DUNGEON_REC_UPDATE_TIME, OldTime},{?DUNGEON_REC_DAILY_MAX_SCORE, DailyScore}, _MaxScore,{?DUNGEON_REC_EVIL_REWARD, RwState}|_]} when RwState =:= 1 ->
    %         % ?PRINT("Rewards = ~p~n", [diff_days(OldTime, utime:unixtime())]),
    %         case diff_days(OldTime, utime:unixtime()) of
    %             D when D /= 0 ->
    %                 case data_dungeon_grade:get_dungeon_grade(DunId, DailyScore) of
    %                     #dungeon_grade{reward = [_|_] = Rewards} ->
    %                         TimeText = utext:get_mm_dd_time_text(OldTime),
    %                         Title = utext:get(?LAN_TITLE_DUN_EVIL_REWARD),
    %                         Content = utext:get(?LAN_CONTENT_DUN_EVIL_REWARD, [TimeText]),
    %                         lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards),
    %                         NewRecord = set_daily_reward_got(RoleId, Record),
    %                         Player#player_status{dungeon_record = NewRecord};
    %                     _ ->
    %                         Player
    %                 end;
    %             _ ->
    %                 Player
    %         end;
    %     _ ->
    %         Player
    % end,
    % {ok, NewPlayer}.
    {ok, Player}.

dunex_calc_auto_lv(EnterLv, State) ->
    case State#dungeon_state.wave_num of
        1 ->
            trunc(EnterLv * 0.6);
        2 ->
            trunc(EnterLv * 0.8);
        _ ->
            EnterLv
    end.


dunex_change_lv_when_role_out(RoleList, _DunType) ->
    lib_dungeon:calc_enter_lv(RoleList, ?DUNGEON_TYPE_EVIL).