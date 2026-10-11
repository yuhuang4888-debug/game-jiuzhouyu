%%%------------------------------------
%%% @Module  : weekly_card
%%% @Author  : lwc
%%% @Created : 2022-03-21
%%% @Description: 周卡
%%%------------------------------------

-define(ACTIVATION_CLOSE,          0). % 未激活
-define(ACTIVATION_OPEN,           1). % 激活
-define(WEEKLY_CARD_DUNGEON,       1). % 副本
-define(WEEKLY_CARD_ACTIVITY,      2). % 活跃度
-define(ACTIVATION_CLOSE_REISSUE,  1). % 未激活的补发奖励
-define(ACTIVATION_OPEN_REISSUE,   2). % 激活的补发奖励
-define(ACTIVATION_OPEN_RED_POINT, 3). % 未激活的补发奖励红点

-define(KV(Key),                              data_weekly_card:get_value(Key)).
-define(WEEKLY_CARD_ACTIVATION_REWARD,        ?KV(weekly_card_activation_reward)).
-define(WEEKLY_CARD_BOSS_KILL,                ?KV(weekly_card_boss_kill)).
-define(WEEKLY_CARD_DAILY_ACTIVITY,           ?KV(weekly_card_daily_activity)).
-define(WEEKLY_CARD_DUNGEON_ADD,              ?KV(weekly_card_dungeon_add)).
-define(WEEKLY_CARD_EXP,                      ?KV(weekly_card_exp)).
-define(WEEKLY_CARD_GIFT_BAG,                 ?KV(weekly_card_gift_bag)).
-define(WEEKLY_CARD_PHYSICAL_STRENGTH,        ?KV(weekly_card_physical_strength)).
-define(WEEKLY_CARD_ROLE_LV,                  ?KV(weekly_card_role_lv)).
-define(WEEKLY_CARD_PRODUCT_ID,               ?KV(weekly_card_product_id)).
-define(WEEKLY_CARD_LAST_DAY,                 ?KV(weekly_card_last_day)).
-define(WEEKLY_CARD_BASE_GIFT_NUM,            ?KV(weekly_card_base_gift_num)).
-define(WEEKLY_CARD_LV_ADD_NUM,               ?KV(weekly_card_lv_add_num)).
-define(WEEKLY_CARD_SHIELDED_TREASURE_CHESTS, ?KV(weekly_card_shielded_treasure_chests)).

-record(weekly_card_status, {
        lv               = 1, % 等级
        exp              = 0, % 经验
        is_activity      = 0, % 是否激活
        gift_bag_num     = 0, % 已领取礼包数量
        can_receive_gift = 0  % 可领取礼包数量
        ,expired_time    = 0  % 过期时间
        ,reward_list     = [] % 未开通的补发奖励 [{Type, [{GoodsType, GoodsId, Num},...]},...]
        ,ref             = [] % 定时器（兼容旧规则）
}).

%% 周卡信息配置
-record(base_weekly_card, {
        lv      = 0,
        exp     = 0,
        add_num = 0
}).
