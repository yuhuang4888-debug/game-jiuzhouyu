%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%    秘境领域
%%% @end
%%% Created : 05. 六月 2019 17:55
%%%-------------------------------------------------------------------
-author("whao").



%% 秘境领域累计击杀奖励
-record(domain_kill_reward_cfg, {
    reward_id = 0,          %% 奖励id
    stage = 0,              %% 奖励阶段
    kill_boss_num = 0,      %% 击杀boss数量
    limit_down = 0,         %% 等级下限
    limit_up = 0,           %% 等级上限
    reward_list = []        %% 奖励列表
}).


%% 秘境领域特殊boss配置
-record(domain_special_boss_cfg, {
    boss_id = 0 ,         %% boss_id
    sp_boss_list = [] ,   %% 对应的所有特殊怪的汇总
    sp_boss_weight = []   %% 特殊boss权重
}).









