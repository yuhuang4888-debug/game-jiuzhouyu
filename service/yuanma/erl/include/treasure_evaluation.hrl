%%-----------------------------------------------------------------------------
%% @Module:treasure_evaluation
%% @Author:hyh
%% @Email:huyihao@sygame.com
%% @Created:2018/04/16
%% @Description:幸运鉴宝
%%-----------------------------------------------------------------------------

-define(TeCostListOnce, [{0, 38180007, 1}]).
-define(TeCostListTen, [{0, 38180007, 9}]).
-define(AddLuckNum, 10).

-record(te_status, {
    te_list = []
}).

-record(te_info, {
    sub_type = 0,
    lucky_num = 0
}).

-record(te_main_reward_con, {
    main_reward_id = 0,
    big_reward_id = 0,
    reward_id_list = []    
}).

-record(te_reward_weight_con, {
    main_reward_id = 0,
    reward_id = 0,
    goods_list = [],
    weight = 0
}).

-define(SelectTreasureEvaluationInfoSql,
    <<"SELECT `role_id`, `sub_type`, `lucky_num` FROM `treasure_evaluation_lucky_num` WHERE `role_id` = ~p">>).
-define(SelectTreasureEvaluationInfoAllSql,
    <<"SELECT `role_id`, `sub_type`, `lucky_num` FROM `treasure_evaluation_lucky_num`">>).
-define(ReplaceTreasureEvaluationInfoAllSql,
    <<"REPLACE INTO `treasure_evaluation_lucky_num` (`role_id`, `sub_type`, `lucky_num`) VALUE (~p, ~p, ~p)">>).
-define(DeleteTreasureEvalutionInfoAllSql,
    <<"DELETE FROM `treasure_evaluation_lucky_num` WHERE ~s">>).