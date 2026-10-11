%%-----------------------------------------------------------------------------
%% @Module  :       diamond_league.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-18
%% @Description:    星钻联盟
%%-----------------------------------------------------------------------------

-define (GLOBAL_COUNTER_ID_TIME_OFFSET, 1).
-define (GLOBAL_COUNTER_ID_CYCLE_INDEX, 2).
-define (GLOBAL_COUNTER_ID_APPLY_TIME, 3).

-define (CFG_KEY_APPLY_COST, 1).
-define (CFG_KEY_OPEN_LV, 2).
-define (CFG_KEY_WAITING_SCENE, 3).
-define (CFG_KEY_BATTLE_SCENE, 4).
-define (CFG_KEY_BATTLE_BORN_POS, 5).
-define (CFG_KEY_LIFE_COST, 6).
-define (CFG_KEY_GUESS_COST, 7).

-define (STATE_CLOSED, 0).  %% 休战期
-define (STATE_APPLY, 1).   %% 报名期
-define (STATE_ENTER, 2).   %% 入场期
-define (STATE_MELEE, 3).   %% 混战期
-define (STATE_KING_CHOOSE, 4). %% 王选期

-define (WIN_STATE_NONE, 0).
-define (WIN_STATE_WIN, 1).
-define (WIN_STATE_LOSE, 2).

-define (TOTAL_APPLY_NUM, 2048).
-define (CANCEL_NUM, 16).
-define (MELEE_ROUND_NUM, 7).
-define (KING_ROUND_NUM, 4).
-define (MAX_LIFE, 3).

-define (RES_REASON_NORMAL, 1).
-define (RES_REASON_NO_ENTER, 2).
-define (RES_REASON_NO_ENEMY, 3).
-define (RES_REASON_QUIT, 4).
-define (RES_REASON_LATE, 5).

% -define (TOTAL_BATTLE_MS, 90000).
-define (TOTAL_BATTLE_MS, 180000).
-define (MAX_GUESS_COUNT, 4).
-define (POOL_NUM, ?ROLE_NUM(?MELEE_ROUND_NUM)).

-define (ROLE_NUM (Round), trunc(?TOTAL_APPLY_NUM / math:pow(2, (Round-1)))).

-define (VALUE (V, Default), case V of undefined -> Default; _ -> V end).

-record (league_role, {
    role_id,
    index = 0,
    round = 0,
    win = 0,
    power = 0,
    life = 0,
    data = #{}
    }).

-record (league_figure, {
    name = <<"">>,
    sex = 0,
    career = 0,
    turn = 0,
    pic = <<"">>,
    picvsn = 0,
    guild_name = <<"">>,
    power = 0,
    server_name = <<"">>,
    lv_model = [],
    fashion_model = [],
    god_weapon_model = [],
    wing = 0
    }).

-record (diamond_time_ctrl, {
    id,
    name,
    week_day,
    time,
    next_id
    }).


-record (schedule_state, {
    cycle_index = 0,
    state_id = 0,
    start_time = 0,
    end_time = 0,
    roles,
    typical_data
    }).

-record (apply_role, {
    role_id,
    power,
    time,
    server_name = <<"">>,
    role_name = <<"">>,
    guild_name = <<"">>,
    lv = 0
    }).
