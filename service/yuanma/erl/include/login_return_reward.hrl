%%-----------------------------------------------------------------------------
%% @Module  :       login_return_reward
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-05-08
%% @Description:    登录返还有礼(0元豪礼)
%%-----------------------------------------------------------------------------
-record(role_info, {
    key = {0, 0},               %% {活动子类型, 奖励档次}
    role_id = 0,                %% 玩家id
    buy_time = 0,               %% 购买时间
    receive_time = 0,           %% 领取返利时间
    utime = 0                   %% 数据更新时间
    }).

-record(act_state, {
    role_map = #{}              %% #{role_id => [#role_info{}]}
    }).

-define(REWARD_STATUS_NOT_BUY,      0).
-define(REWARD_STATUS_HAS_BUY,      1).
-define(REWARD_STATUS_HAS_RECEIVE,  2).

-define(sql_select_login_return_reward,
    <<"select role_id, subtype, grade, buy_time, receive_time, utime from player_login_return_reward">>).
-define(sql_save_login_return_reward,
    <<"replace into player_login_return_reward(role_id, subtype, grade, buy_time, receive_time, utime)
    values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_delete_login_return_reward,
    <<"delete from player_login_return_reward where subtype = ~p">>).
-define(sql_clear_login_return_reward,
    <<"truncate table player_login_return_reward">>).