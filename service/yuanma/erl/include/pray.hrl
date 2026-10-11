%%-----------------------------------------------------------------------------
%% @Module  :       pray
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-20
%% @Description:    祈愿
%%-----------------------------------------------------------------------------

-define(PRAY_TYPE_GCOIN, 1).
-define(PRAY_TYPE_EXP, 2).

-define(PRAY_TYPES, [
    ?PRAY_TYPE_GCOIN
    , ?PRAY_TYPE_EXP
    ]).

%% 祈愿常量配置
-record(pray_cfg, {
    id = 0,
    val = 0,
    desc = ""
    }).

%% 祈愿奖励配置
-record(pray_reward_cfg, {
    type = 0,
    min_rlv = 0,
    max_rlv = 0,
    reward = 0
    }).

%% 祈愿消耗配置
-record(pray_cost_cfg, {
    type = 0,
    min_rlv = 0,
    max_rlv = 0,
    cost = 0
    }).

%% 祈愿暴击配置
-record(pray_crit_cfg, {
    type = 0,
    times = 0,
    crit = 0
    }).

-record(status_pray, {
    pray_map = #{}         % #{Type => {Times,FreeTimes ,EndTime}}  总次数、免费次数。结束时间
    }).

-define(sql_select_player_pray,
    <<"select type, times,freetimes, endtime from player_pray where role_id = ~p">>).

-define(sql_update_player_pray,
    <<"replace into player_pray(role_id, type, times,freetimes ,endtime) values(~p, ~p, ~p ,~p ,~p)">>).
