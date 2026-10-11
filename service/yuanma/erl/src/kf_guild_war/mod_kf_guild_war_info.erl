%%-----------------------------------------------------------------------------
%% @Module  :       mod_kf_guild_war_info
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战info模块
%%-----------------------------------------------------------------------------
-module(mod_kf_guild_war_info).

-include("kf_guild_war.hrl").
-include("common.hrl").

-export([handle_info/2]).

handle_info({'check_stage'}, State) ->
    #kf_guild_war_state{ref = ORef, round = Round} = State,
    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    {ActStatus, NextStatus, CountDownTime, Etime} = lib_kf_guild_war:check_stage(State, NowTime),
    if
        ActStatus == ?ACT_STATUS_CLOSE andalso NextStatus == ?ACT_STATUS_APPOINT ->
            NRef = erlang:send_after(CountDownTime * 1000 + 1, self(), {'appoint'});
        true ->
            NRef = erlang:send_after(CountDownTime * 1000 + 1, self(), {'check_stage'})
    end,
    Args = {?MSG_TYPE_ACT_STATUS, ActStatus, Round, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),
    NewState = State#kf_guild_war_state{
        status = ActStatus,
        etime = Etime,
        ref = NRef
    },
    {ok, NewState};

handle_info({'appoint'}, #kf_guild_war_state{status = ?ACT_STATUS_CLOSE} = State) ->
    #kf_guild_war_state{ref = ORef} = State,

    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    AppointTime = data_kf_guild_war:get_cfg(?CFG_ID_APPOINT_TIME),
    [AppointStime, AppointEtime] = lib_kf_guild_war:format_time(AppointTime),
    CountDownTime = AppointEtime - AppointStime,
    Etime = CountDownTime + NowTime,
    NRef = erlang:send_after(max(1, CountDownTime) * 1000 + 1, self(), {'confirm'}),

    NewState = lib_kf_guild_war_mod:handle_stage_close2appoint(State),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_APPOINT, 0, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    LastState = NewState#kf_guild_war_state{
        status = ?ACT_STATUS_APPOINT,
        etime = Etime,
        ref = NRef
    },
    {ok, LastState};

handle_info({'confirm'}, #kf_guild_war_state{status = ?ACT_STATUS_APPOINT} = State) ->
    #kf_guild_war_state{ref = ORef} = State,

    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    ConfirmTime = data_kf_guild_war:get_cfg(?CFG_ID_CONFIRM_TIME),
    [ConfirmStime, ConfirmEtime] = lib_kf_guild_war:format_time(ConfirmTime),
    CountDownTime = ConfirmEtime - ConfirmStime,
    Etime = CountDownTime + NowTime,
    NRef = erlang:send_after(max(1, CountDownTime) * 1000 + 1, self(), {'battle'}),

    % %% 确定期根据宣战情况确定分组
    % GameType = lib_kf_guild_war:get_game_type(),
    % NewState = lib_kf_guild_war_mod:confirm_group(GameType, State#kf_guild_war_state{round = 1}, NowTime),
    NewState = lib_kf_guild_war_mod:handle_stage_appoint2confirm(State),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_CONFIRM, 0, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    LastState = NewState#kf_guild_war_state{
        status = ?ACT_STATUS_CONFIRM,
        etime = Etime,
        ref = NRef
    },
    {ok, LastState};

handle_info({'battle'}, #kf_guild_war_state{status = ?ACT_STATUS_CONFIRM} = State) ->
    #kf_guild_war_state{ref = ORef, score_ref = OScoreRef} = State,

    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    BattleTime = data_kf_guild_war:get_cfg(?CFG_ID_FIR_ROUND_TIME),
    [BattleStime, BattleEtime] = lib_kf_guild_war:format_time(BattleTime),
    CountDownTime = BattleEtime - BattleStime,
    Etime = CountDownTime + NowTime,
    NRef = erlang:send_after(max(1, CountDownTime) * 1000 + 1, self(), {'rest'}),

    ScoreRef = lib_kf_guild_war_mod:start_score_ref(OScoreRef),

    NewState = State#kf_guild_war_state{
        status = ?ACT_STATUS_BATTLE,
        round = 1,
        etime = Etime,
        ref = NRef,
        score_ref = ScoreRef
    },

    GameType = lib_kf_guild_war:get_game_type(),
    LastState = lib_kf_guild_war_mod:start_battle(GameType, NewState, NowTime),
    % LastState = lib_kf_guild_war_mod:start_battle(NewState, 1, NowTime),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_BATTLE, 1, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    {ok, LastState};

handle_info({'rest'}, #kf_guild_war_state{status = ?ACT_STATUS_BATTLE} = State) ->
    #kf_guild_war_state{ref = ORef, score_ref = OScoreRef} = State,

    util:cancel_timer(ORef),
    util:cancel_timer(OScoreRef),
    NowTime = utime:unixtime(),
    RestTime = lib_kf_guild_war:get_rest_time(),
    Etime = NowTime + RestTime,
    NRef = erlang:send_after(max(1, RestTime) * 1000 + 1, self(), {'battle'}),

    NewState = lib_kf_guild_war_mod:battle_end(State, 1),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_REST, 1, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    LastState = NewState#kf_guild_war_state{
        status = ?ACT_STATUS_REST,
        etime = Etime,
        ref = NRef,
        score_ref = []
    },
    {ok, LastState};

handle_info({'battle'}, #kf_guild_war_state{status = ?ACT_STATUS_REST} = State) ->
    #kf_guild_war_state{ref = ORef, score_ref = OScoreRef} = State,

    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    BattleTime = data_kf_guild_war:get_cfg(?CFG_ID_SEC_ROUND_TIME),
    [BattleStime, BattleEtime] = lib_kf_guild_war:format_time(BattleTime),
    CountDownTime = BattleEtime - BattleStime,
    Etime = CountDownTime + NowTime,
    NRef = erlang:send_after(max(1, CountDownTime) * 1000 + 1, self(), {'act_end'}),
    ScoreRef = lib_kf_guild_war_mod:start_score_ref(OScoreRef),

    NewState = State#kf_guild_war_state{
        status = ?ACT_STATUS_BATTLE,
        round = 2,
        etime = Etime,
        ref = NRef,
        score_ref = ScoreRef
    },

    GameType = lib_kf_guild_war:get_game_type(),
    LastState = lib_kf_guild_war_mod:start_battle(GameType, NewState, NowTime),
    % LastState = lib_kf_guild_war_mod:start_battle(NewState, 2, NowTime),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_BATTLE, 2, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    {ok, LastState};

handle_info({'act_end'}, #kf_guild_war_state{status = ?ACT_STATUS_BATTLE} = State) ->
    #kf_guild_war_state{ref = ORef, score_ref = OScoreRef} = State,

    util:cancel_timer(ORef),
    util:cancel_timer(OScoreRef),
    Unixdate = utime:unixdate(),
    NowTime = utime:unixtime(),
    Etime = Unixdate + ?ONE_DAY_SECONDS,
    CountDownTime = Etime - NowTime,
    NRef = erlang:send_after(max(1, CountDownTime) * 1000 + 1, self(), {'check_stage'}),

    NewState = lib_kf_guild_war_mod:battle_end(State, 2),

    Args = {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_CLOSE, 0, Etime},
    mod_clusters_center:apply_to_all_node(mod_kf_guild_war_local, msg_center2local, [Args]),

    LastState = NewState#kf_guild_war_state{
        status = ?ACT_STATUS_CLOSE,
        etime = Etime,
        ref = NRef
    },
    {ok, LastState};

handle_info({'auto_add_score'}, #kf_guild_war_state{status = ?ACT_STATUS_BATTLE} = State) ->
    #kf_guild_war_state{score_ref = OScoreRef, island_map = IslandMap} = State,

    ScoreRef = lib_kf_guild_war_mod:start_score_ref(OScoreRef),

    F = fun(IslandInfo) ->
        case IslandInfo of
            #island_info{
                battle_pid = BattlePid
            } when is_pid(BattlePid) ->
                mod_kf_guild_war_battle:auto_add_score(BattlePid);
            _ -> skip
        end
    end,
    lists:foreach(F, maps:values(IslandMap)),

    NewState = State#kf_guild_war_state{
        score_ref = ScoreRef
    },

    {ok, NewState};

handle_info(_Msg, State) ->
    ?ERR("ignore info:~p", [_Msg]),
    {ok, State}.