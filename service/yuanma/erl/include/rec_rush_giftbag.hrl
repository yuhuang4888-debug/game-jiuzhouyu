%% 预定义字段
-define(RUSH_GIFTBAG,         1).      %% 冲级豪礼计数标志

-define(GIFTBAG_NOT_RECEIVED, 0).      %% 礼包未达到领取等级
-define(GIFTBAG_CAN_RECEIVE,  1).      %% 礼包可领取
-define(GIFTBAG_RECEIVED,     2).      %% 礼包已经领取
-define(GIFTBAG_TIME_OVER,    3).      %% 礼包已经过期
-define(GIFTBAG_GET_OVER,     4).      %% 礼包已经被领完

-define(GiftBagOpenLv, 30).            %% 冲级豪礼开放等级


%%-------------------------------------------------------------------------
%% 冲级礼包数据记录
%%-------------------------------------------------------------------------
-record(rush_giftbag,
        {
          giftbag_state = []                        %% 礼包领取状态{BagLv, State, LimitNum, LimitTime}
        }).


%%-------------------------------------------------------------------------
%% 冲级礼包配置记录
%%-------------------------------------------------------------------------
-record(base_rush_giftbag,{
    bag_lv = 0,                                     %% 礼包等级
    bag_name = "",                                  %% 礼包名字
    bag_upperlimit = 0,                             %% 礼包数量上限
    bag_upperday = 0,                               %% 礼包领取最大天数
    bag_gift_man = [],                              %% 男性礼包物品
    bag_gift_woman = [] ,                           %% 女性礼包物品
    limit_gift_man = [],                            %% 男性限量礼包奖励
    limit_gift_woman = [] ,                         %% 女性限量礼包奖励
    task_show = []                                  %% 任务显示
}).

%%-------------------------------------------------------------------------
%% 数据库操作相关
%%-------------------------------------------------------------------------
% 获取礼包的状态
-define(sql_get_rush_giftbag, <<"select giftbag_state from rush_giftbag where player_id = ~p">>).
% 更新礼包的状态
-define(sql_replace_rush_giftbag, <<"replace into rush_giftbag(player_id, giftbag_state) values(~p, '~s')">>).
