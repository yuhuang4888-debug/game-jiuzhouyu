%%-----------------------------------------------------------------------------
%% @Module  :       bonus_tree.hrl
%% @Author  :       lwc
%% @Email   :
%% @Created :
%% @Description:    摇钱树
%%-----------------------------------------------------------------------------
-record(bonus_tree_status, {
        times = 0,       %% 抽奖总次数
        pool = [],       %% 奖池[{{StartTimes, EndTimes, Weight, SpecialWeight}, GradeId}]
        rare_pool = [],  %% 达到必中次数使用的奖池[{Weight, GradeId}...]
        grade_state = [] %% 奖励档次对应的抽中次数[{GradeId,Times}]
        , doomed_times = 0 %% 必中次数（达到多少次可以抽中大奖）
        , max_doomed = 0    %% 最大必中次数
        , utime = 0
        , score = 0      %% 积分
        , shop_list = [] %% 积分商城兑换记录
        , grade_list =[] %% 每轮抽中的奖品
}).

-define(HAS_RECIEVE,  2).  %已领取
-define(HAS_ACHIEVE,  1).  %已完成未领取
-define(CANT_RECIEVE, 0).  %未完成