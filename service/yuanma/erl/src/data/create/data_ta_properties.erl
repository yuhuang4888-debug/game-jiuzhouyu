%%%---------------------------------------
%%% module      : data_ta_properties
%%% description : TA系统事件属性配置
%%%
%%%---------------------------------------
-module(data_ta_properties).
-compile(export_all).



%%账号登录
event_keys(account_login) ->
[login_ip,is_simulator];

%%账号注册
event_keys(account_register) ->
[reg_ip,is_simulator];

%%绑钻消耗
event_keys(bgold_consume) ->
[cost_amount,change_after,consume_type];

%%绑钻获取
event_keys(bgold_get) ->
[get_amount,change_after,get_type];

%%创建角色
event_keys(create_role) ->
[create_ip,name,is_simulator];

%%礼包卡日志
event_keys(gift_card) ->
[card_no,card_type,gift_type,is_success,fail_type];

%%钻石消耗
event_keys(gold_consume) ->
[cost_amount,change_after,consume_type];

%%钻石获取
event_keys(gold_get) ->
[get_amount,change_after,get_type];

%%等级排行
event_keys(level_rank) ->
[rank_order,guild_id,guild_name,last_login];

%%成就
event_keys(log_achv) ->
[achieve_id,achieve_points];

%%玩家触发摇钱树抽奖时记录
event_keys(log_bonus_tree) ->
[custom_act_type,act_sub_type,draw_times,auto_buy,grade_ids];

%%玩家触发击杀boss时记录
event_keys(log_boss_kill) ->
[lv, stage, boss_type, boss_id, boss_name, team_id];

%%金币消费
event_keys(log_consume_coin) ->
[cost_amount,change_after,consume_type];

%%特殊货币消耗
event_keys(log_consume_currency) ->
[currency_id,cost_amount,change_after,consume_type];

%%定制活动奖励
event_keys(log_custom_act_reward) ->
[custom_act_type,custom_act_subtype,reward_id];

%%幸运鉴宝抽奖
event_keys(log_custom_treasure) ->
[custom_act_type, custom_act_subtype, turn, draw_times, lucky_value, grade_list];

%%结界守护挑战
event_keys(log_enchantment_guard_battle) ->
[guard_pass_gate];

%%结界守护封印
event_keys(log_enchantment_guard_seal) ->
[seal_times,cur_guard_gate];

%%结界守护扫荡
event_keys(log_enchantment_guard_sweep) ->
[swap_count,cur_guard_gate];

%%boss进入退出
event_keys(log_enter_or_exit_boss) ->
[lv, stage, boss_id, boss_type, boss_name, op_type, stay_time, before_scene, x, y, team_id];

%%嗨点值日志
event_keys(log_hi_points) ->
[act_sub_type, module_id, module_subid, before_hi_point, after_hi_point];

%%等级抢购活动
event_keys(log_level_act) ->
[level_act_type,level_act_subtype,grade,cost_type,cost_num];

%%金币产出
event_keys(log_produce_coin) ->
[get_amount,change_after,get_type];

%%特殊货币产出
event_keys(log_produce_currency) ->
[currency_id,get_amount,change_after,get_type];

%%玩家触发充值返利时记录
event_keys(log_recharge_return) ->
[pay_item_id,return_type,gold_num,return_gold];

%%冲级豪礼
event_keys(log_rush_giftbag) ->
[sex,rush_gift_lv,rush_gift_num];

%%开服冲榜排行
event_keys(log_rush_rank_reward) ->
[rush_rank_type, rank, rush_rank_value];

%%玩家触发砸蛋时记录
event_keys(log_smashed_egg) ->
[smashed_type,draw_times,index,is_free,auto_buy];

%%至尊vip激活
event_keys(log_supvip_active) ->
[active_type,supvip_type,ex_end_time];

%%至尊vip至尊币任务
event_keys(log_supvip_currency_task) ->
[task_id];

%%至尊vip技能任务
event_keys(log_supvip_skill_task) ->
[supvip_stage,supvip_sub_stage,task_id];

%%幸运鉴宝抽奖
event_keys(log_treasure_evaluation) ->
[treasure_eval_type, before_lucky_num, after_lucky_num];

%%玩家升级
event_keys(log_uplv) ->
[lv, from, add_exp, scene_id];

%%玩家触发充值福利卡时记录
event_keys(log_welfare) ->
[welfare_type,gold_num,op,left_count];

%%姻缘关系
event_keys(marriage_state) ->
[friend_id, marriage_type, intimacy];

%%月卡购买
event_keys(monthly_card_buy) ->
[buy_count, valid_days, buy_cost];

%%在线表
event_keys(online_count) ->
[server_id,amount,hosting_amount];

%%订单完成
event_keys(order_finish) ->
[order_id,currency,pay_amount,act_value,pay_item_type,pay_sub_type,pay_item_id,pay_item,is_first_pay,is_new_register];

%%完成订单
event_keys(order_init) ->
[currency,pay_amount,pay_item_type,pay_sub_type,pay_item_id,pay_item,is_quick,is_first_pay];

%%战力排行
event_keys(power_rank) ->
[rank_order,guild_id,guild_name,last_login];

%%角色每日活跃
event_keys(role_daily_active) ->
[active_degree,daily_task,world_boss,jjc,exp_dungeon,resource_dungeon,guild_task,vip_dungeon,forbid_boss,couple_dungeon,domain_boss,beings_gate,guild_feast,holy_battle,top_pk,nine_battle,mid_party,night_ghost,spirit_dungeon,coin_dungeon,mount_dungeon,wing_dungeon,amulet_dungeon,weapon_dungeon,partner_new_dungeon,weekly_card_lv,get_weekly_gift];

%%角色每日状态
event_keys(role_daily_attr) ->
[total_online_time,current_gold,current_bgold,get_onhook_coin,consume_onhook_coin,get_bgold,get_gold,consume_gold,consume_bgold,get_power];

%%角色登录
event_keys(role_login) ->
[login_type,login_ip,network_type,channel,current_gold,current_bgold,server_id,equip_power,seal_power,mount_power,mate_power,divine_rune,soul_rune,resonance_power,atlas_power,wing_power,divine_power,omori_power,mirage_power,seance_power];

%%角色登出
event_keys(role_logout) ->
[logout_type,online_time,current_gold,current_bgold,equip_power,seal_power,mount_power,mate_power,divine_rune,soul_rune,resonance_power,atlas_power,wing_power,divine_power,omori_power,mirage_power,seance_power];

%%商城购买
event_keys(shop_buy) ->
[shop_type,goods_id,goods_num,cost_type,cost_goods_id,cost_num,currency_left];

%%完成任务
event_keys(task_completed) ->
[task_id,task_type,type,task_name,duration,swap_count];

%%vip购买
event_keys(vip_card_buy) ->
[vip_type, valid_days, buy_cost];

%%周卡购买
event_keys(weekly_card_buy) ->
[buy_count, valid_days, buy_cost];

event_keys(_Eventname) ->
	[].

%%服务端事件公共属性列表，properties字段内层每条事件都上报的公共内容
get(common_properties) ->
[accname,vip_level,role_level,current_power,total_pay_amount,open_day,is_month_card,weekly_card_lv,is_weekly_card,'#device_id'];

%%服务端用户属性列表，可使用user_set、user_setOnce等操作的属性
get(user_properties) ->
[channel,register_time,accname,origin_server,server_open_time,is_roll,career,create_role_time,reg_ip,is_choose_career,is_change_name,server_id,latest_logout_time,total_pay_amount,vip_level,role_level,current_power,is_month_card,weekly_card_lv,is_weekly_card,server_type];

get(_Key) ->
	[].
%% 设备id
property_data_type('#device_id') -> 1;
%% 在线时长1
property_data_type('#duration') -> 2;
%% 玩家账号
property_data_type('accname') -> 1;
%% 成就id
property_data_type('achieve_id') -> 2;
%% 玩家总成就点
property_data_type('achieve_points') -> 2;
%% 活跃度
property_data_type('active_degree') -> 2;
%% 激活类型
property_data_type('active_type') -> 2;
%% 活动子类型
property_data_type('act_sub_type') -> 2;
%% 触发累充额度
property_data_type('act_value') -> 2;
%% 增加的经验值
property_data_type('add_exp') -> 2;
%% 新嗨点值
property_data_type('after_hi_point') -> 2;
%% 新幸运值
property_data_type('after_lucky_num') -> 2;
%% 在线人数
property_data_type('amount') -> 2;
%% 御守副本次数
property_data_type('amulet_dungeon') -> 2;
%% 图谱战力
property_data_type('atlas_power') -> 2;
%% 自动购买
property_data_type('auto_buy') -> 3;
%% 原嗨点值
property_data_type('before_hi_point') -> 2;
%% 原幸运值
property_data_type('before_lucky_num') -> 2;
%% 进入前场景
property_data_type('before_scene') -> 2;
%% 众生之门次数
property_data_type('beings_gate') -> 2;
%% Boss Id
property_data_type('boss_id') -> 2;
%% Boss名字
property_data_type('boss_name') -> 1;
%% Boss类型
property_data_type('boss_type') -> 2;
%% 购买金额
property_data_type('buy_cost') -> 2;
%% 购买次数
property_data_type('buy_count') -> 2;
%% 卡号
property_data_type('card_no') -> 1;
%% 礼包卡类型
property_data_type('card_type') -> 1;
%% 职业
property_data_type('career') -> 1;
%% 变化后量
property_data_type('change_after') -> 2;
%% 渠道
property_data_type('channel') -> 1;
%% 铜币副本次数
property_data_type('coin_dungeon') -> 2;
%% 今日消费绑钻总量
property_data_type('consume_bgold') -> 2;
%% 今日消费钻石总量
property_data_type('consume_gold') -> 2;
%% 今日消耗托管值
property_data_type('consume_onhook_coin') -> 2;
%% 变动类型
property_data_type('consume_type') -> 2;
%% 消耗
property_data_type('cost') -> 5;
%% 消耗量
property_data_type('cost_amount') -> 2;
%% 货币类型ID
property_data_type('cost_goods_id') -> 1;
%% 消耗数量
property_data_type('cost_num') -> 2;
%% 货币种类
property_data_type('cost_type') -> 1;
%% 姻缘副本次数
property_data_type('couple_dungeon') -> 2;
%% 创角IP
property_data_type('create_ip') -> 1;
%% 创角时间
property_data_type('create_role_time') -> 4;
%% 支付币种
property_data_type('currency') -> 1;
%% 货币id
property_data_type('currency_id') -> 1;
%% 货币库存
property_data_type('currency_left') -> 2;
%% 当前绑玉
property_data_type('current_bgold') -> 2;
%% 当前勾玉
property_data_type('current_gold') -> 2;
%% 当前战力
property_data_type('current_power') -> 2;
%% 当前关卡
property_data_type('cur_guard_gate') -> 2;
%% 定制活动子类型
property_data_type('custom_act_subtype') -> 2;
%% 定制活动类型
property_data_type('custom_act_type') -> 2;
%% 日常任务次数
property_data_type('daily_task') -> 2;
%% 神兵战力
property_data_type('divine_power') -> 2;
%% 神纹战力
property_data_type('divine_rune') -> 2;
%% 秘境大妖次数
property_data_type('domain_boss') -> 2;
%% 抽奖次数
property_data_type('draw_times') -> 2;
%% 耗时
property_data_type('duration') -> 2;
%% 寻装觅刃次数
property_data_type('equip_dungeon') -> 2;
%% 装备战力
property_data_type('equip_power') -> 2;
%% 恶灵退治次数
property_data_type('exp_dungeon') -> 2;
%% 体验过期时间
property_data_type('ex_end_time') -> 4;
%% 失败类型
property_data_type('fail_type') -> 1;
%% 蛮荒大妖次数
property_data_type('forbid_boss') -> 2;
%% 对象id
property_data_type('friend_id') -> 2;
%% 来源标识
property_data_type('from') -> 2;
%% 获取量
property_data_type('get_amount') -> 2;
%% 今日获得绑钻
property_data_type('get_bgold') -> 2;
%% 今日获得勾玉
property_data_type('get_gold') -> 2;
%% 今日获得托管值
property_data_type('get_onhook_coin') -> 2;
%% 今日提升战力
property_data_type('get_power') -> 2;
%% 获取类型
property_data_type('get_type') -> 2;
%% 今日获得周卡资源礼包总量
property_data_type('get_weekly_gift') -> 2;
%% 标识符
property_data_type('gift_type') -> 1;
%% 钻石数
property_data_type('gold_num') -> 2;
%% 物品类型ID
property_data_type('goods_id') -> 1;
%% 商品数量
property_data_type('goods_num') -> 2;
%% 奖励档次
property_data_type('grade') -> 2;
%% 奖励ID
property_data_type('grade_id') -> 2;
%% 奖励ID列表
property_data_type('grade_ids') -> 5;
%% 抽中档次
property_data_type('grade_list') -> 5;
%% 通关关卡
property_data_type('guard_pass_gate') -> 2;
%% 结社晚宴次数
property_data_type('guild_feast') -> 2;
%% 社团ID
property_data_type('guild_id') -> 1;
%% 社团名称
property_data_type('guild_name') -> 1;
%% 结社任务次数
property_data_type('guild_task') -> 2;
%% 尊神战场次数
property_data_type('holy_battle') -> 2;
%% 托管人数
property_data_type('hosting_amount') -> 2;
%% 索引
property_data_type('index') -> 2;
%% 亲密度
property_data_type('intimacy') -> 2;
%% 是否修改昵称
property_data_type('is_change_name') -> 3;
%% 是否自选职业
property_data_type('is_choose_career') -> 3;
%% 是否首次付费
property_data_type('is_first_pay') -> 3;
%% 是否免费
property_data_type('is_free') -> 3;
%% 是否有月卡
property_data_type('is_month_card') -> 3;
%% 是否当天创角
property_data_type('is_new_register') -> 3;
%% 是否模拟器
property_data_type('is_simulator') -> 3;
%% 是否成功
property_data_type('is_success') -> 3;
%% 是否有周卡
property_data_type('is_weekly_card') -> 3;
%% 竞技场次数
property_data_type('jjc') -> 2;
%% 上次登录时间
property_data_type('last_login') -> 2;
%% 最后登出时间
property_data_type('latest_logout_time') -> 4;
%% 剩余次数
property_data_type('left_count') -> 2;
%% 等级活动子类型
property_data_type('level_act_subtype') -> 2;
%% 等级活动类型
property_data_type('level_act_type') -> 2;
%% 登录IP
property_data_type('login_ip') -> 1;
%% 登录类型
property_data_type('login_type') -> 1;
%% 登出类型
property_data_type('logout_type') -> 1;
%% 幸运值
property_data_type('lucky_value') -> 2;
%% 等级
property_data_type('lv') -> 2;
%% 类型
property_data_type('marriage_type') -> 1;
%% 侍魂战力
property_data_type('mate_power') -> 2;
%% 午间派对次数
property_data_type('mid_party') -> 2;
%% 蜃妖战力
property_data_type('mirage_power') -> 2;
%% 模块id
property_data_type('module_id') -> 2;
%% 模块子id
property_data_type('module_subid') -> 2;
%% 坐骑副本次数
property_data_type('mount_dungeon') -> 2;
%% 坐骑战力
property_data_type('mount_power') -> 2;
%% 昵称
property_data_type('name') -> 1;
%% 网络类型
property_data_type('network_type') -> 1;
%% 百鬼夜行次数
property_data_type('night_ghost') -> 2;
%% 九魂妖塔次数
property_data_type('nine_battle') -> 2;
%% 御守战力
property_data_type('omori_power') -> 2;
%% 在线时间
property_data_type('online_time') -> 2;
%% 操作
property_data_type('op') -> 1;
%% 操作类型
property_data_type('op_type') -> 2;
%% 订单id
property_data_type('order_id') -> 1;
%% 初始区服
property_data_type('origin_server') -> 1;
%% 神巫副本次数
property_data_type('partner_new_dungeon') -> 2;
%% 支付金额
property_data_type('pay_amount') -> 2;
%% 商品名称
property_data_type('pay_item') -> 1;
%% 商品id
property_data_type('pay_item_id') -> 1;
%% 商品大类
property_data_type('pay_item_type') -> 1;
%% 商品子类
property_data_type('pay_sub_type') -> 1;
%% 排名
property_data_type('rank') -> 2;
%% 排名次序
property_data_type('rank_order') -> 2;
%% 注册时间
property_data_type('register_time') -> 4;
%% 注册IP
property_data_type('reg_ip') -> 1;
%% 共鸣战力
property_data_type('resonance_power') -> 2;
%% 资源副本次数
property_data_type('resource_dungeon') -> 2;
%% 返利钻石
property_data_type('return_gold') -> 2;
%% 返利类型
property_data_type('return_type') -> 2;
%% 奖励
property_data_type('reward') -> 5;
%% 奖励id
property_data_type('reward_id') -> 2;
%% 当前角色等级
property_data_type('role_level') -> 2;
%% 领取背包等级
property_data_type('rush_gift_lv') -> 2;
%% 已领取礼包数量
property_data_type('rush_gift_num') -> 2;
%% 榜单类型
property_data_type('rush_rank_type') -> 2;
%% 玩家数值
property_data_type('rush_rank_value') -> 2;
%% 场景Id
property_data_type('scene_id') -> 2;
%% 影装战力
property_data_type('seal_power') -> 2;
%% 当前封印次数
property_data_type('seal_times') -> 2;
%% 降神战力
property_data_type('seance_power') -> 2;
%% 区服ID
property_data_type('server_id') -> 1;
%% 开服时间
property_data_type('server_open_time') -> 4;
%% 服类型
property_data_type('server_type') -> 1;
%% 玩家性别
property_data_type('sex') -> 2;
%% 商城类型
property_data_type('shop_type') -> 1;
%% 砸蛋类型
property_data_type('smashed_type') -> 2;
%% 御魂战力
property_data_type('soul_rune') -> 2;
%% 侍魂副本次数
property_data_type('spirit_dungeon') -> 2;
%% 进入层级
property_data_type('stage') -> 2;
%% 停留时间（秒）
property_data_type('stay_time') -> 2;
%% 至尊VIP阶段
property_data_type('supvip_stage') -> 2;
%% 至尊VIP子阶段
property_data_type('supvip_sub_stage') -> 2;
%% 至尊vip类型
property_data_type('supvip_type') -> 2;
%% 扫荡次数
property_data_type('swap_count') -> 2;
%% 任务ID
property_data_type('task_id') -> 2;
%% 任务名称
property_data_type('task_name') -> 1;
%% 任务类型
property_data_type('task_type') -> 1;
%% 队伍Id
property_data_type('team_id') -> 2;
%% 巅峰竞技次数
property_data_type('top_pk') -> 2;
%% 今日总在线时长
property_data_type('total_online_time') -> 2;
%% 累计充值金额
property_data_type('total_pay_amount') -> 2;
%% 鉴宝数量类型
property_data_type('treasure_eval_type') -> 2;
%% 轮数
property_data_type('turn') -> 2;
%% 类型
property_data_type('type') -> 1;
%% 购买后有效期
property_data_type('valid_days') -> 2;
%% 专属大妖次数
property_data_type('vip_dungeon') -> 2;
%% 当前vip等级
property_data_type('vip_level') -> 2;
%% vip购买类型
property_data_type('vip_type') -> 1;
%% 神兵副本次数
property_data_type('weapon_dungeon') -> 2;
%% 周卡等级
property_data_type('weekly_card_lv') -> 2;
%% 福利卡类型
property_data_type('welfare_type') -> 2;
%% 羽翼副本次数
property_data_type('wing_dungeon') -> 2;
%% 羽翼战力
property_data_type('wing_power') -> 2;
%% 世界大妖次数
property_data_type('world_boss') -> 2;
%% X坐标
property_data_type('x') -> 2;
%% Y坐标
property_data_type('y') -> 2;
%% error property
property_data_type(_) -> undefined.


get_ver_currency(1) ->
<<"人民币"/utf8>>;


get_ver_currency(2) ->
<<"美元"/utf8>>;


get_ver_currency(3) ->
<<"美元"/utf8>>;


get_ver_currency(4) ->
<<"韩元"/utf8>>;


get_ver_currency(5) ->
<<"日元"/utf8>>;


get_ver_currency(6) ->
<<"泰铢"/utf8>>;


get_ver_currency(7) ->
<<"美元"/utf8>>;


get_ver_currency(8) ->
<<"卢布"/utf8>>;


get_ver_currency(9) ->
<<"石油"/utf8>>;


get_ver_currency(10) ->
<<"美元"/utf8>>;


get_ver_currency(11) ->
<<"越南盾"/utf8>>;

get_ver_currency(_Verid) ->
	[].

