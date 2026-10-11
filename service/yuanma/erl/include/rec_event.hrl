%%%---------------------------------------------------------------------
%%% 事件回调相关record定义
%%%---------------------------------------------------------------------


%%% @doc 事件回调参数
-record(event_callback, {
          id = 0,                    %% 事件id{M, F}
          type_id = 0,               %% 事件类型
          param = undefined,         %% 事件监听带入参数 term()
          data = undefined           %% 事件派发带出参数 term()
         }).

%%---------------------------------------------------------------------
%%% 以下定义用于派发事件的#event_callback.data参数
%%---------------------------------------------------------------------

-record(callback_combat_power_data, {
          type = none,                %% 战力变化类型 normal|other
          old_combat_power = 0,       %% 变化前战力
          combat_power = 0,           %% 变化后战力
          hightest_combat_pwer = 0    %% 变化前的历史最高战力
         }).

-record(callback_use_buff_goods_data, {
          goods = none               %% #goods{}
         }).

-record(callback_recharge_data, {
          recharge_product = none,   %% 充值商品配置 #base_recharge_product{}
          associate_ids = [],        %% 关联商品id [{product_type, product_id|...]  注：不包含当前使用自身
          money = 0,                 %% 充值金额数
          gold = 0                   %% 充值元宝数
          , pay_no = "0"             %% 订单号
          , is_pay = 0               %% 之前是否已经充值过
         }).

-record(achv_data, {
          subdata       = 0,         %% 触发事件的子数据(存放事件派发参数,如果没有更新值默认为num)
          num           = 1          %% 事件触发更新数值，默认等于1
         }).

-record(act_data, {
          act_id = 0,                %%
          act_sub = 0,               %%
          num  = 1                   %%
         }).

-record(callback_give_goods_data, {
          type  = 0,                 %% 类型：1获得立即使用物品
          goods = none               %% #goods{}
         }).

-record(callback_give_goods_list, {
          type  = 0,                 %% 类型：2 获得吞噬装备的物品
          goods_list = []               %% [#goods{}]
         }).

-record(callback_equip_stren, {
          equip_pos = 0,             %% 装备类型
          stren = 0,                 %% 强化等级
          whole_level = 0,           %% 全身强化等级
          whole_num = 0              %% 全身数量
         }).

-record(callback_equip_wash, {
          total_num_list = []        %%装备洗练属性数量列表 [{color,num}]
         }).

-record(callback_equip_stone, {
          total_num_list = [],       %% 已穿戴装备镶嵌数量列表 [{color,num}]
          num_list = []              %% 本次操作装备镶嵌数量列表 [{color,num}]
         }).

%% 副本进入
-record(callback_dungeon_enter, {
    dun_id = 0,                %% 副本id
    dun_type = 0,              %% 副本类型
    count = 0                  %% 次数
}).

%% 副本通关
-record(callback_dungeon_succ, {
          dun_id = 0,                %% 副本id
          dun_type = 0,              %% 副本类型
          help_type = 0,             %%
          start_time = 0,            %% 副本开始时间
          start_time_ms = 0,         %% 副本开始时间(毫秒)
          story_play_time_mi = 0,    %% 剧情播放时长(毫秒)
          result_time_ms = 0,        %% 副本结算时间(毫秒)
          pass_time = 0,             %% 通关所花时间
          count = 0,                 %% 次数
          other = []
         }).

%% 副本失败
-record(callback_dungeon_fail, {
          dun_id = 0,                %% 副本id
          dun_type = 0,              %% 副本类型
          help_type = 0,             %%
          start_time = 0,            %% 副本开始时间
          start_time_ms = 0,         %% 副本开始时间(毫秒)
          story_play_time_mi = 0,    %% 剧情播放时长(毫秒)
          result_time_ms = 0,        %% 副本结算时间(毫秒)
          pass_time = 0,             %% 通关所花时间
          count = 0,
          other = []
         }).

%% 副本扫荡
-record(callback_dungeon_sweep, {
    dun_id = 0,                %% 副本id
    dun_type = 0,              %% 副本类型
    count = 0                  %% 次数
}).

%% %% 天空战场
%% -record(callback_sky_war, {
%%           win = 0,                       %% 是否胜利 1 胜利
%%           kill_num = 0                   %% 杀人数
%%          }).

                                                % 夺旗战场
%% -record(callback_flag_war, {
%%           win = 0,                       %% 是否胜利
%%           flag_num = 0                   %% 夺旗数
%%          }).

%% 参加竞技场
-record(callback_jjc, {
          win = 0,                   %% 是否胜利
          win_num = 0,               %% 连胜数
          rank = 0                   %% 排名
         }).

%% 金钱消耗
-record(callback_money_cost, {
          consume_type = 0,          %% 消费类型
          money_type = 0,            %% 金钱类型
          cost = 0                   %% 消耗数量
         }).

%% 特殊货币消耗
-record(callback_currency_cost, {
          consume_type = 0,          %% 消费类型
          currency_id = 0,            %% 货币id
          cost = 0                   %% 消耗数量
         }).

%% 伙伴招募
-record(callback_partner_recruit, {
          recruit_type = 0,          %% 招募类型
          recruit_times = 0,         %% 招募次数
          recruited_num = 0          %% 已收集伙伴数量
         }).

%% 活跃度
-record(callback_activity_live, {
          activity_live = 0,         %% 活跃度
          add_value = 0
         }).

%% 公会邀请
-record(callback_guild_invite, {
          invitee_id = 0             %% 被邀请者的id
         }).

%% 头像
-record(callback_picture, {
          role_id = 0,               %% 玩家id
          picture = "",              %% 头像
          picture_ver = 0            %% 头像版本号
         }).

%% 物品掉落[汇总的]
-record(callback_goods_drop, {
        mon_args = []               %% #mon_args{}
        , alloc = 0                 %% 分配方式
        , goods_list = []           %% [{Type, GoodsTypeId, Num},...]
        , up_goods_list = []        %% [#goods{},...]
    }).

%% 任务掉落
-record(callback_task_drop, {
        reward = []                 %% 奖励
        , see_reward_list = []      %% [{Type, GoodsTypeId, Num, 唯一id},...]
        , scene_id = 0              %% 场景id
    }).

%% 送花
-record(callback_flower, {
        to_id=0,
        goods_id=0,
        intimacy=0,
        sender=1
    }).

%% vip变更
-record(callback_vip_change, {
    old_vip_type  = 0,
    new_vip_type = 0,
    old_vip_lv = 0,
    new_vip_lv = 0
}).

%% 托管
-record(callback_fake_client, {
    module_id = 0
    , sub_module = 0
}).

%% 击杀boss
-record(callback_boss_kill, {
    boss_type = 0,
    boss_id = 0
}).

%% 进入boss副本
-record(callback_boss_dungeon_enter, {
    boss_type = 0
}).

%% 装备合成
-record(callback_equip_compose, {
    goods_list = []
}).

%% 参与活动
-record(callback_join_act, {
    type = 0,
    subtype = 0,
    times = 0
}).