%% ---------------------------------------------------------------------------
%% @doc onhook.hrl
%% @author ming_up@foxmail.com
%% @since  2018-08-06
%% @deprecated  主线挂机配置
%% ---------------------------------------------------------------------------

-record(onhook_drop, {
      chapter = 0,              %% 主线关卡
      origin_chapter = 0,       %% 基础对比关卡
      coin = 0,                 %% 每小时铜币
      coin_add = 0,             %% 每关卡铜币增益
      exp = 0,                  %% 每小时经验
      exp_add = 0,              %% 每关卡经验增益
      mon_soul = 0,             %% 兽魂
      sdrop_num = 0,            %% 静态掉落每小时计算次数
      static_award = [],        %% 静态奖励列表
      edrop_num = 0,            %% 装备每小时掉落计算次数
      equip_award_rule = [],    %% 装备掉落规则
      equip_award = []          %% 装备奖励列表
    }).

% -record(status_onhook, {
%         last_calc_time = 0,             %% 上次计算铜币，经验，兽魂时间
%         last_static_drop_time = 0,      %% 上次计算静态掉落时间
%         last_equip_drop_time = 0,       %% 上次计算装备掉落时间
%         last_task_drop_time = 0,        %% 上次计算任务掉落时间
%         buff_ratio=0,                   %% 经验符倍数
%         buff_end_time=0,                %% 经验符结束时间
%         coin_drop = 0,                  %% 在线挂机时，单独存放一个金币掉落
%         goods_drop_list = [],           %% 上次计算的掉落列表
%         exp_item_time = 0,              %% 掉落门票时间
%         count = 0,                      %% 掉落计数器
%         offline_onhook_time = 0         %% 离线挂机时间
%     }).
