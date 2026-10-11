%%%------------------------------------
%%% @Module  : rush_treasure
%%% @Author  : lwc
%%% @Created : 2022-02-25
%%% @Description: 冲榜夺宝
%%%------------------------------------

-define(PERSON_RANK,          1). %% 个人榜
-define(SERVER_RANK,          2). %% 区服榜
-define(AVAILABLE,            1). %% 可领取
-define(RECEIVED,             2). %% 已领取
-define(NOT_AVAILABLE,        3). %% 不可领取
-define(CUSTOM_ACT_IS_ZONE_NO,  0). %% 大跨服
-define(CUSTOM_ACT_IS_ZONE_YES, 1). %% 小跨服

-define(KV(Key), data_rush_treasure:get(Key)).
-define(RUSH_TREASURE_TYPE, ?KV(rush_treasure_type)).

%% 玩家进程结构
-record(rush_treasure, {
        data_list = []                  %% 活动需要统计保存的数据[#race_act_data{}]
}).

%% 玩家进程数据记录
-record(rush_treasure_data,{
        id = {0, 0},                    %% {主类型,次类型}
        type = 0,                       %% 主类型
        subtype = 0,                    %% 次类型
        score = 0,                      %% 积分
        today_score = 0,                %% 今日积分
        times = 0,                      %% 累积次数
        reward_list = [],               %% 已获奖励:奖励id
        score_reward = [],              %% 已领取积分奖励id
        last_time = 0                   %% 最后抽奖时间
}).

%% 榜单进程记录
-record(rank_status,{
        rush_per_rank = []          %% 冲榜夺宝个人榜单,格式[#rank_type{}]
}).

%% 指定类型排行
-record(rank_type,{
        id = {0,0},                 %% 主键，格式{type,subtype}
        type = 0,                   %% 主类型
        subtype = 0,                %% 次类型
        rank_data = []              %% 格式[#rank_data{}]
}).

%% 排行数据记录
-record(rank_data,{
        id = 0,                     %% 区id
        rank_list = [],             %% 格式 #rank_role{}
        score_limit = 0             %% 最后一名分数
}).

%% 排行榜角色记录
-record(rank_role,{
        id = 0              %%玩家id
        ,server_id = 0      %%服务器id
        ,platform = []      %%平台
        ,server_num = 0     %%
        ,node = none        %%所在节点
        ,score = 0          %%分数
        ,rank = 0           %%排名
        ,figure = undefined
        ,last_time = 0
        ,server_name = <<>>
}).

%% 排行榜区服记录
-record(rank_server,{
        server_id = 0      %%服务器id
        ,platform = []      %%平台
        ,server_num = 0     %%
        ,node = none        %%所在节点
        ,score = 0          %%分数
        ,rank = 0           %%排名
        ,role_list = []     %%玩家列表[#rank_role{},...]
        ,last_time = 0
        ,server_name = <<>>
}).

%%冲榜夺宝排名奖励
-record(base_rush_treasure_rank_reward,{
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        rank_type = 0,      %%榜单类型
        reward_id = 0,      %%奖励id
        rank_min = 0,       %%排名下限
        rank_max = 0,       %%排名上限
        limit_val = 0,      %%最低上榜值
        format = 0,         %%奖励格式
        reward = [],        %%奖励
        desc = ""           %%奖励描述
}).

%%冲榜夺宝阶段奖励
-record(base_rush_treasure_stage_reward,{
        type = 0,           %%主类型
        sub_type = 0,       %%次类型
        reward_id = 0,      %%奖励id
        need_val = 0,       %%所需值
        format = 0,         %%奖励格式
        reward = [],        %%奖励
        desc = ""           %%奖励描述
}).


