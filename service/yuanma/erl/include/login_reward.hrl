%%%--------------------------------------
%%% @Module  : login_reward.hrl
%%% @Author  : hyh
%%% @Created : 2018.01.12
%%% @Description:  七天登录
%%%--------------------------------------

-define(LoginRewardOpenLv, 0). %%70 以前是70， 现在么有

-record(login_reward, {  %%登录信息
    reward_list = [],       %%领取状态  0 不可领取， 1  可领取  2 已领取
    create_time = 0         %%第一次登录当前0点时间戳
    ,login_day = 0          %%登录天数
    ,last_login_time = 0   %%最后登录时间
}).

-record(login_reward_day_con, {
    day_id = 0,
    name = "",
    reward_list = [],
    resource_id = 0,
    show_type = 0
}).

-record(login_merge_reward_day_con, {
    day_id = 0,
    merge_wlv = 0,
    merge_wlv2 = 0,
    name = "",
    reward_list = [],
    resource_id = 0,
    show_type = 0
}).

-define(SelectLoginRewardPlayerSql,
    <<"SELECT   `reward_list` ,  `create_time` , `login_day`, `last_login_time`  FROM `login_reward_player` WHERE `role_id` = ~p">>).

-define(ReplaceLoginRewardPlayerSql,
    <<"REPLACE INTO `login_reward_player` (`role_id`,  `reward_list` ,  `create_time`, `login_day`, `last_login_time`)  VALUES (~p, ~p, ~p, ~p, ~p)">>).


-define(SelectLoginRewardPlayerSqlMarge,
	<<"SELECT   `reward_list` ,  `create_time` , `login_day`, `last_login_time`  FROM `login_merge_reward_player` WHERE `role_id` = ~p">>).

-define(ReplaceLoginRewardPlayerSqlMarge,
	<<"REPLACE INTO `login_merge_reward_player` (`role_id`,  `reward_list` ,  `create_time`, `login_day`, `last_login_time`)  VALUES (~p, ~p, ~p, ~p, ~p)">>).
