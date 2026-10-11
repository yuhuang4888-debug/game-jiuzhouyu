
-define(MarriageOpenLv, (data_marriage:get_marriage_constant_val(1))).
-define(PersonalsContinueTime, (data_marriage:get_marriage_constant_val(2))).
-define(PersonalsNormalCost, (data_marriage:get_marriage_constant_val(3))).
-define(PersonalsSpecialCost, (data_marriage:get_marriage_constant_val(4))).

-define(PersonalsAskfollowTime, (data_marriage:get_marriage_constant_val(5))).
-define(PersonalsAskflowerTime, (data_marriage:get_marriage_constant_val(6))).

-define(RingPrayNumList, (data_marriage:get_marriage_constant_val(7))).

-define(BiaoBaiNeedIntimacy, (data_marriage:get_marriage_constant_val(8))).
-define(ProposeNeedIntimacy, (data_marriage:get_marriage_constant_val(9))).

% -define(MarriageProposeGoldCost, [{1, 10}, {2, 20}, {3, 30}]).
-define(MarriageProposeOverTime, (data_marriage:get_marriage_constant_val(10))).
-define(CoupleBreakCost, (data_marriage:get_marriage_constant_val(11))).  %% 分手消耗
-define(CoupleDivorceCost, (data_marriage:get_marriage_constant_val(12))).    %% 离婚消耗

%% 礼包常量
-define(LoveGiftBuyCost, (data_marriage:get_marriage_constant_val(13))).
-define(LoveGiftExpireDay, (data_marriage:get_marriage_constant_val(14))).  %% 
-define(LoveGiftBuyReward, (data_marriage:get_marriage_constant_val(15))).    %% 
-define(LoveGiftLoginReward, (data_marriage:get_marriage_constant_val(16))).    %% 

-define(SendPersonalGap, (data_marriage:get_marriage_constant_val(17))).    %% 发布信息间隔

-define(IntimacyDunNeed, (data_marriage:get_marriage_constant_val(18))).    %% 异性进入副本的亲密度

-define(WeddingOrderDay, (data_marriage:get_marriage_constant_val(19))).    %% 最大预约天数

-define(WeddingScene, (data_marriage:get_marriage_constant_val(20))).

-define(WeddingGuestMaxNumPrice, (data_marriage:get_marriage_constant_val(21))).

%% 喜糖
-define(WeddingNormalCandies, (data_marriage:get_marriage_constant_val(22))).
-define(WeddingSpecialCandies, (data_marriage:get_marriage_constant_val(23))).

%% 餐桌
-define(WeddingTable1, (data_marriage:get_marriage_constant_val(24))).
-define(WeddingTable2, (data_marriage:get_marriage_constant_val(25))).
-define(WeddingTable3, (data_marriage:get_marriage_constant_val(26))).

%% 气氛值
-define(WeddingAddAuraTime, (data_marriage:get_marriage_constant_val(27))).
-define(WeddingAddAuraNum, (data_marriage:get_marriage_constant_val(28))).

 %% 婚宴预告 5分钟
-define(WeddingStartPreTime, (data_marriage:get_marriage_constant_val(29))).

%% 交友平台开放等级
-define(PersonalOpenLv, (data_marriage:get_marriage_constant_val(30))).    %% 交友平台开放等级
%% 解锁戒指物品
-define(RingUnLockGoods, (data_marriage:get_marriage_constant_val(31))).    %% 解锁戒指物品
%% 婚宴新人时装模型
-define(WeddingFashion, (data_marriage:get_marriage_constant_val(32))).    %% 时装模型
%% 系统喜糖刷新间隔
-define(SysCandyTimeGap, (data_marriage:get_marriage_constant_val(33))).    %% 
-define(SysCandyNumRefresh, (data_marriage:get_marriage_constant_val(34))).    %% 
%% 喜糖上限
-define(SysCandyNumLimit, (data_marriage:get_marriage_constant_val(35))).    %% 
-define(SysCandyRefreshTimes, (data_marriage:get_marriage_constant_val(36))).    %% 
%% 邀请奖励
-define(InviteReward, (data_marriage:get_marriage_constant_val(37))).    %% 
%% 宾客总人数
-define(GuestMax, (data_marriage:get_marriage_constant_val(38))).    %%
%% 购买立得的等待天数
-define(WAIT_DAY, (data_marriage:get_marriage_constant_val(39))).
%% 满足离线时长的秒数
-define(FREE_OFFLINE_TIMES, (data_marriage:get_marriage_constant_val(40))).
%% 离婚时，根据恩爱值返还的道具ID
-define(DISCOVER_RETURN_ITEM, (data_marriage:get_marriage_constant_val(41))).

-define(WeddingTroubleMakerCollect, (data_marriage:get_marriage_constant_val(50))). %% 婚礼捣蛋鬼采集怪物id 坐标
-define(WeddingTroubleMakerNum, (data_marriage:get_marriage_constant_val(50))). %% 婚礼捣蛋鬼怪物数量
-define(WeddingTroubleMakerTime, (data_marriage:get_marriage_constant_val(50))).
-define(WeddingTroubleMakerAppearTime, (data_marriage:get_marriage_constant_val(50))).
-define(WeddingTroubleMakerRefleshTimes, (data_marriage:get_marriage_constant_val(50))).
-define(WeddingTMLimitNum, (data_marriage:get_marriage_constant_val(50))).
-define(BabyKnowledgePrayNumList, (data_marriage:get_marriage_constant_val(50))).
-define(WeddingAskInviteLv, (data_marriage:get_marriage_constant_val(50))).


-define(BabySkillId, 22000001).
-define(WeddingSqlTime, 5).
-define(PersonalsFreeTimesId, 1).

-define(FANS_LENGTH, 100).

%% 真爱礼包次数类型
-define(LOVE_GIFT_COUNT_TYPE_1, 1).  %% 购买后立即返回的礼包 
-define(LOVE_GIFT_COUNT_TYPE_2, 2).  %% 对方每天领取的礼包

%% couple others数据key值
-define(COUPLE_OTHER_KEY_1, 1).  %% 婚礼预约使用次数
-define(COUPLE_OTHER_KEY_2, 2).  %% 求婚的类型

%% wedding_order others数据key值
-define(WEDDING_ORDER_OTHER_KEY_1, 1).  %% 婚礼消耗记录

%% 进程字典key
-define(P_STARTTING_WEDDING(Id), {startting_wedding, Id}).


-define(ManString, data_language:get(1720001)).
-define(WomanString, data_language:get(1720002)).

-define(WeddingExpCount(Lv), trunc(13862* math:pow(1.5, (Lv-170)/50))).

%% TA数据记录操作类型
-define(TA_MARRIAGE_APPLY,          1). % 申请结婚
-define(TA_MARRIAGE_BUILD,          2). % 建立婚姻
-define(TA_MARRIAGE_DIVORCE_FORCE,  3). % 强制离婚
-define(TA_MARRIAGE_DIVORCE_PROTO,  4). % 协议离婚

-record(marriage_status, {
    role_id = 0,
    lover_role_id = 0,
    lover_name = "",
    type = 0,   %% 0单身 1情侣 2夫妻
    now_wedding_state = 0,   %% 类型 0结婚预约 1当前无婚礼预约 2再次预约 3已预约
    wedding_pid = 0,
    marriage_life = [],
    ask_follow_time = 0,  %% 发送求关注时间
    ask_flower_time = 0,  %% 发送求送花时间
    love_gift_time_s = 0, %% 自己的真爱礼包时间
    love_gift_time_o = 0,  %% 对方的真爱礼包时间
    marriage_attr = [],
    in_personals = false,
    in_matching = 0         %% 0 无，dun_id：在匹配中
}).

-record(marriage_life, {
    role_id = 0,
    stage = 0,
    heart = 0
}).

-record(marriage_state, {
    personals = [],
    marriage_couple = [],
    proposal = [],
    dog_food_list = []
}).

-record(dog_food_info, {
    role_id_m = 0,
    role_id_w = 0,
    dog_food_id = 0,
    type_id = 0,
    player_list = []
}).

-record(dog_food_player, {
    role_id = 0,
    get_time = 0
}).

-record(wedding_mgr_state, {
    wedding_list = [],
    wedding_order_list = [],
    refresh_timer = 0,
    wedding_start_timer = 0
}).

-record(wedding_state, {
    role_id_m = 0,
    figure_m = [],
    role_id_w = 0,
    figure_w = [],
    man_in = 0,
    woman_in = 0,
    wedding_type = 0,
    stage_id = 0,
    stage_begin_time = 0,
    stage_end_time = 0,
    wedding_begin_time = 0,
    wedding_end_time = 0,
    pos_count = 0,
    enter_member_list = [],
    aura = 0,
    less_normal_candies = 0,
    less_special_candies = 0,
    sys_candies_times = 0,
    if_sql = 0,
    stage_timer = 0,
    trouble_maker_timer = 0,
    trouble_maker_reflesh_times = 0,
    trouble_maker_num = 0,
    if_trouble_maker_collect = 0,
    sql_timer = 0,
    exp_timer = 0,
    stage_send_tv_timer = 0,
    aura_timer = 0,
    candies_timer = 0
}).

%% 进入婚礼场景玩家信息
-record(wedding_enter_member_info, {
    pos_id = 0,
    role_id = 0,
    sid = 0,
    enter_time = 0,
    free_candies = [],
    free_fires = [],
    if_enter = 0,       %% 0不在 1在
    table_list = [],
    all_exp = 0,
    get_trouble_maker_num = 0,
    get_normal_candies_num = 0,
    get_special_candies_num = 0
}).

-record(wedding_order_info, {
    id = 0,
    role_id_m = 0,
    role_id_w = 0,
    wedding_type = 0,   %% 1下 2中 3高
    order_unix_date = 0,
    time_id = 0,
    wedding_pid = 0,
    guest_list = [],
    ask_invite_list = [],
    guest_num_max = 0,
    propose_role_id = 0,    %% 求婚玩家/使用婚礼卡玩家
    begin_time = 0,
    invited_num = 0,
    others = []
}).

-record(wedding_guest_info, {
    id = 0,
    role_id_m = 0,
    role_id = 0,
    role_name = "",
    answer_type = 0
}).

-record(marriage_couple, {
    role_id_m = 0,  %% 男
    role_id_w = 0,  %% 女
    type = 0,       %% 1情侣 2夫妻
    now_wedding_state = 0,  %% 类型 0结婚预约/AA制再次预约 1当前无婚礼预约 2再次预约 3已预约
    wedding_pid = 0,
    marriage_time = 0,
    love_num = 0,          %% 恩爱值
    love_num_max = 0,       %% 历史恩爱值
    love_gift_time_m = 0,     %% 男真爱礼包时间
    love_gift_time_w = 0,     %% 女真爱礼包时间
    love_gift_count_m = [],   %% 男真爱礼包次数信息
    love_gift_count_w = [],   %% 女真爱礼包次数信息 [{次数类型, 领取状态, 领取时间戳}]
    others = [],              %% 其他信息
    dog_food_id_max = 0
}).

%% 表白的信息
-record(proposal, {
    role_id = 0,
    proposing_list = [],      %% 被表白列表#propose_info
    answer_list = [],        %% 回应列表#answer_info
    divorce_info = []
}).

-record(propose_info, {
    role_id = 0,
    propose_role_id = 0,    %% 表白的玩家
    type = 0,   %% 1表白 2求婚
    propose_type = 0,   %% 0婚礼（表白用） 1下 2中 3高
    msg = "",
    cost_list = [],
    other_cost_list = [],
    cost_key = "",
    other_cost_key = "",
    time = 0
}).

%% 回应的信息
-record(answer_info, {
    role_id = 0,    %% 回应的玩家
    type = 0,       %% 1表白 2求婚 3离婚 4 分手
    answer_type = 0,     %% 表白/求婚时：1答应 2拒绝 3超时; 分手/离婚时：1 协商离婚 2 强制离婚
    time = 0
}).

-record(personals_player, {
    role_id = 0,
    name = "",
    lv = 0,
    sex = 0,
    vip = 0,
    msg = "",              %% 信息
    career = 0,
    turn = 0,
    picture = "",           %% 玩家上传的头像地址(默认是玩家id)
    picture_ver = 0,        %% 玩家上传的头像版本号
    if_online = 0,          %% 是否在线
    fans_list = [],         %% 粉丝列表 [{role_id, time}]
    type = 0,               %% 类型
    tag_list = [],          %% 标签列表 [{tag_type, tag_subtype}]
    time = 0,               %% 发布时间
    vip_exp = 0,            %% Vip经验
    vip_hide = 0,           %% vip是否隐藏
    is_supvip = 0           %% 是否有至尊vip标识
}).

-record(baby_status, {
    role_id = 0,
    if_active = 0,              %% 是否开启
    baby_knowledge = [],        %% 宝宝学识
    baby_aptitude = [],         %% 宝宝资质
    baby_image = [],            %% 宝宝幻形
    attr = [],                  %% 宝宝属性
    battle_attr = undefined,    %% 战斗属性
    skills = []                 %% 宝宝技能
}).

-record(baby_knowledge, {
    stage = 0,
    star = 0,
    pray_num = 0
}).

-record(baby_aptitude, {
    aptitude_lv = 0
}).

-record(baby_image, {
    image_list = []
}).

-record(baby_image_info, {
    image_id = 0,
    stage = 0,
    pray_num = 0
}).

-record(ring, {
    role_id = 0,
    stage = 0,
    star = 0,
    pray_num = 0,
    attr_list = [],
    polish_list = []
}).

-record(ring_polish_con, {
    goods_type_id = 0,
    attr_list = [],
    use_max = 0
}).

-record(ring_stage_con, {
    stage = 0,
    name = "",
    resource_id = 0
}).

-record(ring_star_con, {
    stage = 0,
    star = 0,
    upgrade_pray_num = 0,
    attr_list = [],
    marriage_attr = []
}).

-record(wedding_info_con, {
    type = 0,
    name = "",
    wedding_name = "",
    cost = [],
    reward = [],
    wedding_fail_return = [],
    designation_id = 0,
    guest_num = 0,
    guest_num_max = 0,
    time = 0,
    exp_time = 0,
    exp_coefficient = 0,
    explain = ""
}).

-record(marriage_life_stage_con, {
    stage = 0,
    name = "",
    resource_id = 0
}).

-record(marriage_life_heart_con, {
    stage = 0,
    heart = 0,
    upgrade_love_num = 0,
    attr_list = []
}).

-record(baby_knowledge_stage_con, {
    stage = 0,
    name = "",
    resource_id = 0
}).

-record(baby_knowledge_star_con, {
    stage = 0,
    star = 0,
    upgrade_pray_num = 0,
    attr_list = []
}).

-record(baby_aptitude_lv_con, {
    aptitude_lv = 0,
    cost_list = [],
    attr_list = []
}).

-record(baby_image_stage_con, {
    image_id = 0,
    stage = 0,
    upgrade_pray_num = 0,
    attr_list = []
}).

-record(baby_active_con, {
    image_id = 0,
    image_name = "",
    cost_list = [],
    pray_num_list = [],
    resource_id = 0,
    skill_id = 0
}).

-record(marriage_show_love_con, {
    id = 0,
    name = "",
    cost_list = [],
    add_intimacy = 0,
    self_goods_list = [],
    lover_goods_list = [],
    good_food = [],
    dog_food = [],
    dog_food_num = 0
}).

-record(wedding_card_con, {
    goods_type_id = 0,
    goods_name = "",
    goods_num = 0,
    cost_list = [],
    wedding_type = 0,
    if_reward =0
}).

-record(wedding_time_con, {
    time_id = 0,
    begin_time = {},
    end_time = {}
}).

-record(wedding_time_stage_con, {
    stage_id = 0,
    stage_name = "",
    continue_time = 0,
    test = ""
}).

-record(wedding_position_con, {
    pos_id = 0,
    type = 0,
    x = 0,
    y = 0
}).

-record(wedding_trouble_maker_con, {
    trouble_maker_id = 0,
    trouble_maker_name = "",
    solve_name = "",
    reward_list = [],
    aura = 0
}).

-record(wedding_candies_con, {
    candies_id = 0,
    candies_name = "",
    cost_list = [],
    free_times = 0,
    candies_num = 0,
    reward_list = [],
    aura = 0,
    limit_num = 0
}).

-record(wedding_fires_con, {
    fires_id = 0,
    fires_name = "",
    cost_list = [],
    charact = 0,
    free_times = 0,
    reward_list = [],
    aura = 0
}).

-record(wedding_table_con, {
    table_id = 0,
    table_name = "",
    wedding_type = 0,
    table_num = 0,
    reward_list = [],
    aura = 0
}).

-record(wedding_aura_con, {
    aura_id = 0,
    aura_num = 0,
    reward_list = []
}).

-record(wedding_guest_position_con, {
    id = 0,
    x = 0,
    y = 0,
    angle = 0
}).

-record(marriage_constant_con, {
    id = 0,
    constant = [],
    annotation = ""
}).

-record(base_propose_cfg, {
    propose_type = 0,
    propose_name = <<>>,
    reward = [],
    show_reward = [],
    dsgt = 0,
    cost = [],
    wedding_times = []
}).

-record(base_love_dsgt_cfg, {
    id = 0,
    dsgt = 0,
    love_num = 0
}).

-record(base_love_gift_config, {
    id = 0,
    day = 0,
    reward = [],
    daily_reward = []
}).

-record(base_wedding_scene_exp, {
    lv1 = 0,
    lv2 = 0,
    exp = 0
}).

-record(base_wedding_scene_exp_coef, {
    wedding_type = 0,
    num1 = 0,
    num2 = 0,
    aura_num = 0,
    exp_coef = 0
}).

-define(SelectMPPlayerAllSql,
    <<"SELECT `role_id`, `name`, `sex`, `vip`, `career`, `turn`, `msg`, `picture`, `picture_ver`, `type`, `tag_list`, `time`, `vip_exp`, `vip_hide`, `is_supvip` FROM `marriage_personals_player`">>).
-define(ReplaceMPPlayerSql,
    <<"REPLACE INTO `marriage_personals_player` (`role_id`, `name`, `sex`, `vip`, `career`, `turn`, `msg`, `picture`, `picture_ver`, `type`, `tag_list`, `time`, `vip_exp`, `vip_hide`, `is_supvip`) values (~p, '~s', ~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p, '~s', ~p, ~p, ~p, ~p)">>).
-define(UpdateMPPlayerSql,
    <<"UPDATE `marriage_personals_player` set `msg` = '~s', `tag_list` = '~s' WHERE `role_id` = ~p ">>).
-define(DeleteMPPlayerSql,
    <<"Delete from `marriage_personals_player` where 1=1 ">>).

-define(SelectMPFollowAllSql,
    <<"SELECT `role_id`, `followed_role_id`, `time` FROM `marriage_personals_follow`">>).
-define(ReplaceMPFollowSql,
    <<"REPLACE INTO `marriage_personals_follow` (`role_id`, `followed_role_id`, `time`) values (~p, ~p, ~p)">>).
-define(DeleteMPFollowSql,
    <<"DELETE FROM `marriage_personals_follow` WHERE `role_id` =~p and `followed_role_id` = ~p">>).
-define(SelectMPFollowSql,
    <<"SELECT `followed_role_id` FROM `marriage_personals_follow` WHERE `role_id` = ~p">>).
-define(SelectMPFansSql,
    <<"SELECT `role_id` FROM `marriage_personals_follow` WHERE `followed_role_id` = ~p">>).

-define(SelectMRingSql,
    <<"SELECT `role_id`, `stage`, `star`, `pray_num`, `polish_list` FROM `marriage_ring_player` WHERE `role_id` = ~p">>).
-define(ReplaceMRingSql,
    <<"REPLACE INTO `marriage_ring_player` (`role_id`, `stage`, `star`, `pray_num`, `polish_list`) values (~p, ~p, ~p, ~p, '~s')">>).

-define(SelectMCoupleAllSql,
    <<"SELECT `role_id_m`, `role_id_w`, `type`, `now_wedding_state`, `marriage_time`, `love_num`, `love_num_max`, `love_gift_time_m`, `love_gift_time_w`, `others` FROM `marriage_couple_info`">>).
-define(SelectMCoupleSql,
    <<"SELECT `role_id_m`, `role_id_w`, `type` FROM `marriage_couple_info` WHERE `role_id_m` = ~p OR `role_id_w` = ~p">>).
-define(ReplaceMCoupleSql,
    <<"REPLACE INTO `marriage_couple_info` (`role_id_m`, `role_id_w`, `type`, `now_wedding_state`, `marriage_time`, `love_num`, `love_num_max`, `love_gift_time_m`, `love_gift_time_w`, `others`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s')">>).
-define(ReplaceMCoupleAllSql,
    <<"REPLACE INTO `marriage_couple_info` (`role_id_m`, `role_id_w`, `type`, `now_wedding_state`, `marriage_time`, `love_num`, `love_num_max`, `love_gift_time_m`, `love_gift_time_w`, `others`) values ~s">>).
-define(UpdateMCoupleLoveNumSql,
    <<"UPDATE `marriage_couple_info` set `love_num` = ~p, `love_num_max` = ~p WHERE `role_id_m` = ~p OR `role_id_w` = ~p">>).
-define(UpdateMCoupleLoveGiftSql,
    <<"UPDATE `marriage_couple_info` set `love_gift_time_m` = ~p, `love_gift_time_w` = ~p WHERE `role_id_m` = ~p OR `role_id_w` = ~p">>).
-define(DeleteMCoupleMSql,
    <<"DELETE FROM `marriage_couple_info` WHERE `role_id_m` = ~p">>).
-define(DeleteMCoupleWSql,
    <<"DELETE FROM `marriage_couple_info` WHERE `role_id_w` = ~p">>).

-define(SelectMProposeAllSql,
    <<"SELECT `role_id`, `propose_role_id`, `type`, `propose_type`, `msg`, `cost_list`, `other_cost_list`, `cost_key`, `time` FROM `marriage_couple_propose`">>).
-define(ReplaceMPProposeSql,
    <<"REPLACE INTO `marriage_couple_propose` (`role_id`, `propose_role_id`, `type`, `propose_type`, `msg`, `cost_list`, `other_cost_list`, `cost_key`, `time`) values (~p, ~p, ~p, ~p, '~s', '~s', '~s', '~s', ~p)">>).
-define(DelectMProposeRoleIdAllSql,
    <<"DELETE FROM `marriage_couple_propose` WHERE `role_id` = ~p AND `propose_role_id` IN (~s)">>).
-define(DelectMProposeProRoleIdAllSql,
    <<"DELETE FROM `marriage_couple_propose` WHERE `propose_role_id` = ~p AND `role_id` IN (~s)">>).

-define(SelectMLifeSql,
    <<"SELECT `role_id`, `stage`, `heart` FROM `marriage_life_player` WHERE `role_id` = ~p">>).
-define(ReplaceMLifeSql,
    <<"REPLACE INTO `marriage_life_player` (`role_id`, `stage`, `heart`) values (~p, ~p, ~p)">>).

-define(SelectMarriageAskTimeSql,
    <<"SELECT `role_id`, `ask_follow_time`, `ask_flower_time` FROM `marriage_ask_time` WHERE `role_id` = ~p">>).
-define(ReplaceMarriageAskTimeSql,
    <<"REPLACE INTO `marriage_ask_time` (`role_id`, `ask_follow_time`, `ask_flower_time`) values (~p, ~p, ~p)">>).

-define(SelectMWeddingOrderInfoAllSql,
    <<"SELECT `id`, `role_id_m`, `role_id_w`, `wedding_type`, `order_unix_date`, `time_id`, `guest_num_max`, `propose_role_id`, `invited_num`, `others` FROM `marriage_wedding_order_info`">>).
-define(ReplaceMWeddingOrderInfoSql,
    <<"REPLACE INTO `marriage_wedding_order_info` (`id`, `role_id_m`, `role_id_w`, `wedding_type`, `order_unix_date`, `time_id`, `guest_num_max`, `propose_role_id`, `invited_num`, `others`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s')">>).
-define(DelectMWeddingOrderInfoAllSql,
    <<"DELETE FROM `marriage_wedding_order_info` WHERE `role_id_m` IN (~s)">>).
-define(DelectMWeddingOrderInfoAllSql2,
    <<"DELETE FROM `marriage_wedding_order_info` WHERE `id` IN (~s)">>).

-define(SelectMWeddingGuestInfoAllSql,
    <<"SELECT `id`, `role_id_m`, `role_id`, `role_name`, `answer_type` FROM `marriage_wedding_guest`">>).
-define(ReplaceMWeddingGuestInfoAllSql,
    <<"REPLACE INTO `marriage_wedding_guest` (`id`, `role_id_m`, `role_id`, `role_name`, `answer_type`) values ~s">>).
-define(DelectMWeddingGuestInfoAllSql,
    <<"DELETE FROM `marriage_wedding_guest` WHERE `role_id_m` IN (~s)">>).
-define(DelectMWeddingGuestInfoAllSql2,
    <<"DELETE FROM `marriage_wedding_guest` WHERE `id` IN (~s)">>).
-define(DelectMWeddingGuestInfoSql,
    <<"DELETE FROM `marriage_wedding_guest` WHERE `role_id_m` = ~p AND `role_id` = ~p">>).

-define(SelectMWeddingRestartAllSql,
    <<"SELECT `role_id_m`, `role_id_w`, `man_in`, `woman_in`, `aura`, `member_id_list` FROM `marriage_wedding_restart`">>).
-define(ReplaceMWeddingRestartSql,
    <<"REPLACE INTO `marriage_wedding_restart` (`role_id_m`, `role_id_w`, `man_in`, `woman_in`, `aura`, `member_id_list`) values (~p, ~p, ~p, ~p, ~p, '~s')">>).
-define(DelectMWeddingRestartAllSql,
    <<"DELETE FROM `marriage_wedding_restart` WHERE `role_id_m` IN (~s)">>).


-define(SelectMBabyInfoAllSql,
    <<"SELECT `role_id`, `stage`, `star`, `pray_num`, `aptitude_lv`, `resource_id`, `if_show` FROM `marriage_baby_info` WHERE `role_id` = ~p">>).
-define(ReplaceMBabyInfoAllSql,
    <<"REPLACE INTO `marriage_baby_info` (`role_id`, `stage`, `star`, `pray_num`, `aptitude_lv`, `resource_id`, `if_show`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(SelectMBabyImageInfoAllSql,
    <<"SELECT `role_id`, `image_id`, `stage`, `pray_num` FROM `marriage_baby_image` WHERE `role_id` = ~p">>).
-define(ReplaceMBabyImageInfoAllSql,
    <<"REPLACE INTO `marriage_baby_image` (`role_id`, `image_id`, `stage`, `pray_num`) values ~s">>).

-define(SelectMLoveGiftCountAll,
    <<"SELECT `role_id`, `count_type`, `state`, `time` FROM `marriage_love_gift_count` ">>).
-define(ReplaceMBabyImageInfoSql,
    <<"REPLACE INTO `marriage_love_gift_count` (`role_id`, `count_type`, `state`, `time`) values (~p, ~p, ~p, ~p)">>).
-define(DeleteMLoveGiftCountSql,
    <<"DELETE FROM `marriage_love_gift_count` WHERE `role_id` = ~p">>).