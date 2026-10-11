%%-----------------------------------------------------------------------------
%% @Module  :       bonus_draw.hrl
%% @Author  :       xlh
%% @Email   :
%% @Created :
%% @Description:    赛博夺宝 头文件
%%-----------------------------------------------------------------------------
-record(base_draw_pool, {
        type = 0                    %% 活动类型
        ,subtype = 0                %% 活动子类型
        ,wave = 0                   %% 波数
        ,grade = 0                  %% 档次
        ,rare = 0                   %% 0普通奖池 1高级奖池
        ,reward_type = 0            %% 0通用奖励格式 1世界等级奖励格式
        ,conditions = []            %% 奖励条件
        ,reward = []                %% 奖励
        ,tv = []                    %% 传闻
    }).

-record(base_draw_stage_reward, {
        type = 0                    %% 活动类型
        ,subtype = 0                %% 活动子类型
        ,stage = 0                  %% 阶段
        ,grade = 0                  %% 档次
        ,condition = []             %% 奖励条件
        ,reward_type = 0            %% 奖励/消耗格式 0通用奖励格式 1世界等级奖励格式
        ,reward = []                %% 奖励
        ,discount = []              %% 折扣奖励购买消耗
        ,dis_reward = []            %% 折扣奖励
    }).

-record(base_draw_cost, {
        min = 0                     %% 次数下限
        ,max = 0                    %% 次数上限
        ,cost = []                  %% 消耗
    }).

-define(NOT_ACHIEVE, 0).        %% 未达成
-define(HAS_ACHIEVE, 1).        %% 已达成未领取
-define(HAS_RECIEVE, 2).        %% 已领取

-define(HAS_BUY,     2).        %% 已购买
-define(NOT_BUY,     0).        %% 未购买

-define(RECIEVE_STAGE_REWARD,  0). %% 领取阶段奖励
-define(BUY_STAGE_REWARD,      1). %% 购买阶段大奖

-define(RARE,        1).        %% 珍稀
-define(UNRARE,      0).        %% 普通

-define(HAVE,        1).        %% 未抽中
-define(NULL,        0).        %% 抽中过

-define(DRAW_REWARD_NORMAL,   1). %% 抽奖
-define(STAGE_REWARD_NORMAL,   2). %% 阶段奖励
-define(STAGE_REWARD_BUY,   3). %% 阶段奖励购买
-define(STAGE_REWARD_BUY_AND_RECIEVE, 4).%% 阶段奖励购买及领取

-define(REWARD_TYPE_NORMAL_D, 0). %% 通用奖励格式
-define(REWARD_TYPE_WORLDLV_D,1). %% 世界等级奖励格式
%===========================数据结构========================
-record(draw_reward_status,{
        act_data = #{}%% 活动数据 key => #draw_map
    }).

%%========================== 赛博夺宝 ==========================
%% 赛博夺宝为不放回抽奖，需要保存奖池数据
-record(draw_data, {
        key = {},               %% 键值
        wave = 0,               %% 波数
        pool = [],              %% 奖池
        draw_times = 0          %% 抽奖次数
        , today_draw_times = 0  %% 今日抽奖次数
        , stage_reward = []     %% 阶段奖励状态 [{{Stage, GradeId}, GradeState, BuyState},...]
        , utime = 0             %% 操作时间
}).

%% 赛博夺宝阶段奖励状态
-record(draw_data_stage, {
        key = {},               %%{阶段id,档次id}
        reward_state = 0,       %%奖励状态     0 1 2
        discount_state = 0      %%折扣奖励状态  1 2
    }).

-define(SQL_SELECT,  "SELECT `wave`, `pool`, `draw_times`, `today_times`, `stage_state`, `utime`
        FROM `bonus_draw_role` WHERE `role_id` = ~p and `type` = ~p and subtype = ~p").
-define(SQL_REPLACE, "REPLACE INTO `bonus_draw_role`(`role_id`,`type`, `subtype`, `wave`, `pool`, `draw_times`, `today_times`,
        `stage_state`, `utime`)VALUES(~p,~p,~p,~p,'~s',~p, ~p,'~s',~p)").
-define(SQL_DELETE,  "DELETE FROM `bonus_draw_role` WHERE `type` = ~p and `subtype` = ~p and `utime` > ~p").

-define(SQL_TRUNCATE, "TRUNCATE TABLE `bonus_draw_role`").

-define(SQL_SELECT_ALL, "SELECT `role_id`, `wave`, `draw_times`, `stage_state` FROM `bonus_draw_role` WHERE `type` = ~p and subtype = ~p").