%%%--------------------------------------
%%% @Author  : calvin
%%% @Email   : calvinzhong888@gmail.com
%%% @Created : 2012.7.3
%%% @Description: 礼包头文件
%%%--------------------------------------

%% 礼包缓存key
-define(GIFT_CACHE_KEY(RoleId, GiftId), lists:concat(["fetch_gift_", RoleId, "_", GiftId])).

%% 插入一条记录到礼包表gift_list
-define(SQL_GIFT_LIST_INSERT, <<"REPLACE INTO `gift_list` SET player_id=~p, gift_id=~p, give_time=~p, get_time=~p, get_num=~p, status=~p">>).
%% 更新为已经领取礼包
-define(SQL_GIFT_LIST_UPDATE_TO_RECEIVED, <<"UPDATE `gift_list` SET get_num=get_num+1, get_time=~p, status=1 WHERE player_id=~p AND gift_id=~p">>).
%% 查询一条记录：通过玩家ID和礼包ID
-define(SQL_GIFT_LIST_FETCH_ROW, <<"SELECT player_id, gift_id, status FROM `gift_list` WHERE player_id=~p AND gift_id=~p LIMIT 1">>).
%% 查询几条记录：通过玩家ID和礼包ID
-define(SQL_GIFT_LIST_FETCH_MUTIL_ROW, <<"SELECT player_id, gift_id, status FROM `gift_list` WHERE player_id=~p AND gift_id IN(~s)">>).
%% 查询玩家所有礼包记录
-define(SQL_GIFT_FETCH_ALL, <<"SELECT gift_id, give_time, get_num, get_time, offline_time, status FROM `gift_list` WHERE player_id=~p">>).
%% 查询在线倒计时礼包数据
-define(SQL_GIFT_FETCH_ONLINE, <<"SELECT gift_id, give_time, get_num, get_time, offline_time, status FROM `gift_list` WHERE player_id=~p">>).
%% 获取已领取过的礼包
-define(SQL_GIFT_SELECT_GOT,              <<"select gift_id from `gift_list` where player_id=~p and status=1 ">>).
%% 礼包配置表
-record(ets_gift, {
          goods_id = 0,       %% 物品类型ID
          get_way = 0,        %% 领取方式，1放到背包，2直接领取
          bind = 1,           %% 绑定状态，0非绑定，1绑定
          start_time,         %% 有效开始时间
          end_time,           %% 有效结束时间
          status,             %% 是否有效:0否;1是
          condition = [],     %% 条件 [{cost(消耗),[物品列表]}, {count(每天次数),2}], 物品列表注意[{0, GId, Num}, {1|2|3(货币类), 原价, 现价}]
          filter = [],        %% 筛选内容[lv, sex, career, turn, server_lv, rune],最多只有4个, lv, server_lv, rune 互为替换,在最后的生效
          show = 0,            %% 是否显示礼包领取界面
          show_dynamics = 0
         }).

%% 礼包奖励内容配置表
-record(ets_gift_reward, {
          goods_id = 0,       %% 物品类型ID
          slv = 0,            %% 开启等级
          elv = 0,            %% 结束等级
          sex = 0,            %% 性别
          career = 0,         %% 职业
          turn = 0,           %% 转生
          rand = 0,           %% 随机次数
          fixed_gifts = [],   %% 固定物品:[{类型, 物品id, 数量}]
          rand_gifts = [],    %% 随机物品:[{{类型, 物品id, 数量}, R(权重)}]
          first_gifts = [],   %% 第一次打开物品
          tv_goods_id = [],   %% 需要传闻的物品id:打开礼包时如果开到这些物品,会发传闻
          is_back = 0         %% 是否放回随机:0:否;1:是
         }).

%% 礼包筛选参数
-record(filter_gift_data, {
          lv = 0,       %% 玩家等级
          sex = 0,      %% 性别
          career = 0,   %% 职业
          turn = 0,     %% 转生
          rune = 0,    %% 符文
          open_day = 0,
          mod_level = 0  %% 功能内部等级
         }).

%% 自选礼包配置
-record(optional_gift, {
          goods_id = 0,       %% 物品类型ID
          career = 0,         %% 职业
          slv = 0,              %% 开始等级
          elv = 0,              %% 结束等级
          sopen_day = 0,        %% 开始开服天数
          eopen_day = 0,        %% 结束开服天数
          optional_num = 1,   %% 自选数量
          list = []           %% 物品列表 [{No, {Type, GId, Num}}...] = [{序号, 物品类型, 物品id, 数量}]
         }).

%% 次数礼包配置
-record(base_count_gift, {
          goods_id = 0,       %% 物品类型ID
          sex = 0,            %% 性别
          condition = [],     %% 条件
          freeze_time = 0,     %% 冷却时间
          reward = []         %% 奖励
         }).

%% 奖池礼包配置
-record(base_pool_gift, {
    gift_id,        % 礼包id
    min_round,      % 最小轮次
    max_round,      % 最大轮次
    init_rate,      % 初始(触发高级奖励)概率
    inc_rate,       % 递增概率(失败后)
    sum_rate,       % 概率计算基数
    normal_times,   % 普通奖励抽奖次数
    normal_pool,    % 普通奖励奖池
    prem_times,     % 高级奖励抽奖次数
    prem_pool,      % 高级奖励奖池
    tv_id           % 传闻id(高级奖励)
}).