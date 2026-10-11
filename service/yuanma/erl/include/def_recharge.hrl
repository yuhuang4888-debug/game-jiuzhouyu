%%%---------------------------------------------------------------------
%%% 充值相关define定义
%%%---------------------------------------------------------------------


%% ============================= 商品大类 =============================
-define(PRODUCT_TYPE_NORMAL,    1).     %% 普通充值(含充值返利)
%% -define(PRODUCT_TYPE_FUND,      2).    %% 基金
-define(PRODUCT_TYPE_WELFARE,   2).     %% 福利卡
-define(PRODUCT_TYPE_DAILY_GIFT,3).     %% 每日礼包
-define(PRODUCT_TYPE_FIRST_GIFT,4).     %% 首充礼包
-define(PRODUCT_TYPE_GIFT,   5).        %% 礼包充值 不出发任何活动
-define(PRODUCT_TYPE_DIRECT_GIFT,6).    %% 直购礼包 触发充值活动

-define(PRODUCT_TYPE_VERIFY,    99).    %% 审核专用


%% ============================= 商品子类 =============================

%% 福利卡－－－－－－－－－－－－
-define(WELFARE_SUBTYPE_QUARTER, 1).    %% 季度卡
-define(WELFARE_SUBTYPE_MONTH,   2).    %% 月卡
-define(WELFARE_SUBTYPE_WEEK,    3).    %% 周卡

%% ============================= 返利类型 =============================

-define(RETURN_TYPE_NO,             0).	%% 返利类型：无返利
-define(RETURN_TYPE_LIFE_FIRST,     1).	%% 返利类型：终生首次
-define(RETURN_TYPE_ACT_FIRST,      2).	%% 返利类型：活动时间首次

-define(PAY_EXPIRE_TIME, 150).      %% 超时秒数
-define(PAY_TOTAL_RECHARGE(RoleId), lists:concat(["recharge_total_gold_", RoleId])).
-define(PAY_DAILY_RECHARGE(RoleId), lists:concat(["recharge_daily_gold_", RoleId])).

%% 充值后更新总充值金额-元宝
-define(sql_recharge_update_total,  <<"UPDATE player_recharge SET total=~p WHERE id=~p">>).

%% 充值后更新同账号的总充值金额-元宝
-define(sql_acc_charge_update_total,<<"UPDATE acc_share_data SET total_charge = total_charge + ~p WHERE accid=~p and accname = '~s'">>).

%% 插入新的充值数据
-define(sql_recharge_insert_total,     <<"INSERT INTO player_recharge (`id`, `total`, `merge`) VALUES ( ~w, ~w, ~w)">>).

%% 查询总充值金额-元宝
-define(sql_recharge_get_total,     <<"SELECT `total` FROM player_recharge WHERE id=~p">>).

%% 写入充值记录(只用于秘籍)
-define(sql_pay_insert_gm,          <<"INSERT INTO `charge`(`type`,pay_no,accname,player_id,nickname,product_id,money,gold,ctime,status,lv)  VALUES(~p, ~p, '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p)" >>).
%% 取出充值待处理的记录
-define(sql_pay_fetch_all,          <<"SELECT `id`, `player_id`, `ctime` FROM `charge` WHERE `status`=0">>).
%% 更新充值待处理的记录的状态为已处理
-define(sql_pay_update_recharge,    <<"UPDATE `charge` SET `status`=1 WHERE id=~p AND `status`=0">>).
%% 取出指定玩家所有待处理的充值记录
-define(sql_pay_fetch_all_of_user,  <<"SELECT `id`, `type`, `product_id`, `money`, `gold`, `ctime`, `pay_no` FROM `charge` WHERE `player_id`=~p AND `status`=0 ORDER BY `id`">>).
%% 取出充值任务期间玩家的充值总额
-define(sql_pay_task_get_gold,      <<"SELECT SUM(gold) FROM recharge_log WHERE player_id=~p AND time >= ~p AND time < ~p">>).
%% 取出玩家指定期间的充值总额(是人民币)
-define(sql_get_pay_rmb_sum,        <<"SELECT SUM(money) FROM charge WHERE player_id=~p AND `status`=1 AND ctime >= ~p AND ctime < ~p">>).
%% 取出充值元宝道具使用总额
-define(sql_gold_goods_total,       <<"SELECT SUM(gold) FROM recharge_log WHERE `player_id`=~p AND `type`=2 AND time >= ~p AND time < ~p">>).

%% 更新玩家最后充值时间
-define(sql_update_last_pay_time,   <<"update player_login set last_pay_time=~p where id=~p">>).

%% 插入充值日志（根据charge的记录插入，以及元宝卡）
%% Type 1:充钱 2:元宝卡
-define(sql_insert_recharge_log,
        <<"insert into `recharge_log`(`accid`, `accname`, `player_id`, `type`, `product_id`, `money`, `gold`, `real_gold`, `time`) values(~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_delete_recharge_log,
        <<"delete from recharge_log where player_id = ~p and `id` = ~p">>).

%% 获得充值数据 - 最大取一千条记录
-define(sql_get_recharge_list,
        <<"SELECT `time`, `type`, `money`, `gold` FROM `recharge_log` WHERE `accid`=~p AND `accname`='~s' AND `player_id`=~p AND `time`>=~p order by `time` desc limit 1000">>).

-define(sql_get_recharge_list_by_player_id,
        <<"SELECT `time`, `type`, `money`, `gold` FROM `recharge_log` WHERE `player_id`=~p AND `time`>=~p order by `time` desc limit 1000">>).
