%%%------------------------------------------------
%%% File    : guess.hrl
%%% Author  : hjh
%%% Created : 2016 - 06 - 06
%%% Description:  竞猜
%%%------------------------------------------------

%% ---------------------- 竞猜类别 ---------------------------------
%%　#guess_log.guess_type
-define(GUESS_TYPE_SINGLE,      1).         % 竞猜单场
-define(GUESS_TYPE_GROUP,       2).         % 竞猜组

%% ---------------------- 比赛类别 ---------------------------------
%% #guess_info_config.game_type
-define(GAME_TYPE_WORLD_CUP,    1).         % 世界杯

%% ---------------------- 组类别 ---------------------------------
%% #guess_group_config.guess_group
-define(GUESS_GROUP_TYPE_WINNER, 1).        % 冠军竞猜

%% ---------------------- 奖励状态 ---------------------------------

-define(NO_REWARD,              0).         % 没有奖励
-define(NOT_RECEIVE,            1).         % 未领取
-define(HAS_RECEIVE,            2).         % 已领取

%% ---------------------- 结果(A队) ---------------------------------

-define(RESULT_NO,              0).         % 无结果
-define(RESULT_WIN,             1).         % 胜利
-define(RESULT_LOSE,            2).         % 失败
-define(RESULT_DRAW,            3).         % 平局

%% ---------------------- 状态 ---------------------------------

-define(GUESS_BUY,              0).         % 押注期间
-define(GUESS_STOP,             1).         % 等待开奖(停止押注)
-define(GUESS_CAN_GET,          2).         % 可以领取
-define(GUESS_CAN_NOT_GET,      3).         % 未中奖
-define(GUESS_HAVE_GET,         4).         % 已经领取
-define(GUESS_OBSOLETE,         5).         % 被淘汰

%% ---------------------- 玩家record ------------------------------

%% 竞猜单场
-record(guess_single, {
    key = {0, 0, 0},                        % {比赛类型, 子类型, 配置id}
    role_id = 0,
    times = 0,                              % 投注次数
    odds_list = [],                         % [{赔率, 投注次数, 投注类型}]
    reward_status = 0,                      % 0: 未领取奖励 1: 已领取奖励
    is_timeout = 0,
    time = 0
    }).

%% 竞猜组
-record(guess_group, {
    key = {0, 0},                           % {比赛类型, 配置id}
    role_id = 0,
    times = 0,                              % 投注次数
    odds_list = [],                         % [{赔率, 投注次数}|...]
    reward_status = 0,                      % 0: 未领取奖励 1: 已领取奖励
    is_timeout = 0,
    time = 0
    }).

%% 下注记录
-record(bet_record, {
    key = {0, 0, 0, 0},
    type = 0,                               % 1: 单场竞猜 2: 分组竞猜
    game_type = 0,
    subtype = 0,
    cfg_id = 0,
    times = 0,                              % 投注次数
    odds = 0,                               % 赔率 自行除以100
    sel_result = 0,
    time = 0
    }).

%% 玩家的数据
-record(guess_state, {
    single_map = #{},                       % #{{比赛类型, 子类型, 配置id} => #{玩家id => #guess_single{}}}
    group_map = #{},                        % #{{比赛类型, 配置id} => #{玩家id => #guess_group{}}}
    record_map = #{}                        % #{玩家id => [#bet_record{}]}
    }).

%% 活动配置
-record(guess_info_config, {
        game_type = 0,              % 比赛类型
        name = "",                  % 名字
        desc = "",                  % 描述
        open_lv = 0,                % 开启等级
        start_time = 0,             % 开始时间
        end_time = 0,               % 结束时间
        clear_time = 0              % 数据清理时间
    }).

%% 竞猜单场配置
-record(guess_single_config, {
        id = 0,                     % 配置id
        game_type = 0,              % 比赛类型(1:欧洲杯)
        subtype = 0,
        cfg_name = "",              % 名字
        cfg_desc = "",              % 描述
        a_name = "",                % A方名字
        a_icon = 0,                 % A方图标(0:默认图标)
        b_name = "",                % B方名字
        b_icon = 0,                 % B方图标
        game_start_time = 0,        % 比赛开始时间
        guess_end_time = 0,         % 竞猜结束时间
        is_show = 0,                % 是否显示
        max_times = 0,              % 最大投注次数
        a_odds = 0,                 % A方赔率(千分比)
        b_odds = 0,                 % B方赔率(千分比)
        draw_odds = 0,              % 平局赔率
        result_desc = "",           % 结果描述
        result = 0                  % 结果(A队) 0:无结果 1:胜利 2:失败
    }).

%% 竞猜组配置
-record(guess_group_config, {
        id = 0,                    % 配置id
        game_type = 0,             % 比赛类型(1:欧洲杯)
        cfg_name = "",             % 名字
        cfg_desc = "",             % 描述
        group_type = 0,            % 组类别(1:冠军竞猜 2:小组出线竞猜 3:排名竞猜)
        group_id = 0,              % 小组id
        ranking = 0,               % 排名
        name = "",                 % 队名字
        icon = 0,                  % 图标
        guess_start_time = 0,      % 竞猜开始时间(开始时间、结束时间都为0,根据比赛类型取默认值)
        guess_end_time = 0,        % 竞猜结束时间
        max_times = 0,             % 最大投注次数
        odds = 0,                  % 赔率(千分比)
        result = 0                 % 结果 0:无结果 1:胜利 2:失败
    }).

%% ----------------------- 数据库 -----------------------------

-define(sql_guess_single_select,
    <<"select role_id, game_type, subtype, id, times, odds_list, reward_status, is_timeout, time from guess_single">>).

-define(sql_guess_single_save, <<"
    replace into
        guess_single(role_id, game_type, subtype, id, times, odds_list, reward_status, time)
    values(~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).

-define(sql_guess_single_auto_send_reward_bf_reload,
    <<"update guess_single set is_timeout = ~p where (game_type, subtype, id) in (~s)">>).

-define(sql_guess_single_auto_send_reward,
    <<"update guess_single set is_timeout = ~p where game_type in (~s)">>).

-define(sql_guess_single_delete,
    <<"delete from guess_single where game_type in (~s)">>).

-define(sql_guess_group_select,
    <<"select role_id, game_type, id, times, odds_list, reward_status, is_timeout, time from guess_group">>).

-define(sql_guess_group_auto_send_reward,
    <<"update guess_single set is_timeout = ~p where game_type in (~s)">>).

-define(sql_guess_group_save, <<"
    replace into
        guess_group(role_id, game_type, id, times, odds_list, reward_status, time)
    values(~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).

-define(sql_guess_group_delete,
    <<"delete from guess_group where game_type in (~s)">>).

-define(sql_select_guess_bet_record,
    <<"select role_id, type, game_type, subtype, cfg_id, times, odds, sel_result, time from guess_bet_record">>).

-define(sql_insert_guess_bet_record,
    <<"replace into
        guess_bet_record(role_id, type, game_type, subtype, cfg_id, times, odds, sel_result, time)
    values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_delete_guess_bet_record,
    <<"delete from guess_bet_record where game_type in (~s)">>).