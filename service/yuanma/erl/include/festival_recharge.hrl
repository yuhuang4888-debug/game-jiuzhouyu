%%%-----------------------------------
%%% @Module      : festival_recharge
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 12. 六月 2019 14:20
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


-define(festival_recharge_not_got_reward, 0).    %未获取奖励
-define(festival_recharge_got_reward,     1).    %已经获取奖励

-define(festival_recharge_yet_recharge,     1).
-define(festival_recharge_not_recharge,     0).

-record(festival_recharge, {
	is_recharge = 0,                             %%是否充值了
	status = ?festival_recharge_not_got_reward   %%奖励领取状态
}).