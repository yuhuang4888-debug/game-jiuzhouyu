%%-----------------------------------------------------------------------------
%% @Module  :       boss_first_blood_plus
%% @Author  :       cxd
%% @Created :       2020-04-25
%% @Description:    新版boss首杀
%%-----------------------------------------------------------------------------

%% ================= 常量定义 =================


%% 奖励领取状态
-define(NOT_RECEIVE, 0).            %% 未领取
-define(IS_RECEIVE, 1).             %% 已领取
-define(CAN_NOT_RECEIVE, 2).        %% 不可领取

-define(WHOLE_FIRST_BLOOD, 1).      %% 完成首杀
-define(NOT_WHOLE_FIRST_BLOOD, 0).  %% 没完成首杀

%% ets，记录#ets_first_blood
-define(ETS_FIRST_BLOOD, ets_first_blood).           

%% boss_info中data字段的数据类型
-define(PASS_RANK, 1).              %% 排行榜


%% 奖励类型
-define(FIRST_BLOOD_REWARD_TYPE_SHARED, 0).           %% 全服归属奖励
-define(FIRST_BLOOD_REWARD_TYPE_PERSONAL, 1).         %% 个人奖励

-define(FIRST_BLOOD_ACT_LIST, 
        [
            ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS
            , ?CUSTOM_ACT_TYPE_DUN_FIRST_KILL
            , ?CUSTOM_ACT_TYPE_PASS_DUN
        ]
        ).                          %% 首杀活动列表

%% ================= record定义 =================

%% 玩家奖励记录
-record(role_info, {
    boss_id = 0,                    %% BossId
    reward_state = 2,               %% 个人奖励领取状态
    shared_state = 2                %% 全服归属奖励领取状态      
    }).

%% 全服首杀记录
-record(boss_info, {
    object_id = 0,                  %% 全服首杀BossId或副本id
    role_id = 0,                    %% 全服首杀玩家Id
    reward_state = 0,               %% 奖励状态
    data = []                       %% 记录相关数据，[{主键(如:?PASS_RANK), []}, ...]
}).

%% 副本通关角色记录
-record(pass_dun_role, {
    role_id = 0,                    %% 角色id
    rank = 0,                       %% 排名
    pass_time = 0,                  %% 通关时间
    interval_time = 0               %% 间隔时间
}).

%% ets记录，记录对应boss的击杀玩家id列表
-record(ets_first_blood, {
    key = {0, 0, 0},                %% {类型，子类型，boss id}
    role_ids = []                   %% 玩家击杀记录
}).

%% 活动数据
-record(boss_first_blood_plus, {
    boss_map = #{}                  %% #{{Type, SubType} => [#boss_info{}]}
}).

-record(base_first_blood_plus_boss, {
    type = 0,                       %% 活动类型
    sub_type = 0,                   %% 活动子类型
    object_id = 0,                  %% boss id
    boss_scene_name = <<""/utf8>>,  %% boss场景名称
    desc = <<""/utf8>>,             %% 首杀描述
    boss_link = 0,                  %% boss跳转链接
    boss_picture = 0,               %% boss头像
    boss_model = 0,                 %% boss模型
    whole_first_blood_reward = [],  %% 全服首杀奖励  击杀玩家可领
    shared_reward = [],             %% 全服归属奖励  全服玩家可领    
    own_reward = [],                %% 个人奖励
    client_pos = 0                  %% 界面展示顺序，客户端显示使用
}).


%% ================= sql =================

%% =========== boss_first_blood_plus_role 表操作 ========
-define(sql_select_role_by_role_id, <<"select * from boss_first_blood_plus_role where role_id = ~p">>).
-define(sql_replace_boss_first_blood_plus_role, <<"replace into boss_first_blood_plus_role(`type`, `sub_type`, `role_id`, `boss_id`, `reward_state`, `shared_state`) values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_truncate_boss_first_blood_plus_role, <<"truncate table boss_first_blood_plus_role">>).
-define(sql_update_boss_first_blood_plus_role_reward_state, <<"update boss_first_blood_plus_role set `reward_state` = ~p where `role_id` = ~p and `type` = ~p and `sub_type` = ~p and `boss_id` = ~p">>).

%% =========== boss_first_blood_plus_boss 表操作 =========
-define(sql_select_boss, <<"select * from boss_first_blood_plus_boss">>).
-define(sql_replace_boss_first_blood_plus_boss, <<"replace into boss_first_blood_plus_boss(`type`, `sub_type`, `object_id`, `role_id`, `reward_state`) values(~p, ~p, ~p, ~p, ~p)">>).
-define(sql_truncate_boss_first_blood_plus_boss, <<"truncate table boss_first_blood_plus_boss">>).


%% =========== boss_first_blood_plus_boss_merge 表操作 =========
-define(sql_select_boss_first_blood_plus_boss_merge, <<"select type, object_id, role_id from `boss_first_blood_plus_boss_merge` where reward_state = ~p">>).
-define(sql_replace_boss_first_blood_plus_boss_merge, <<"replace into boss_first_blood_plus_boss_merge(`type`, `sub_type`, `object_id`, `role_id`, `reward_state`) values(~p, ~p, ~p, ~p, ~p)">>).
-define(sql_truncate_boss_first_blood_plus_boss_merge, <<"truncate table boss_first_blood_plus_boss_merge">>).
-define(sql_delete_boss_first_blood_plus_boss_merge, <<"delete from boss_first_blood_plus_boss_merge where type = ~p and sub_type = ~p">>).

%% =========== boss_first_blood_plus_data 表操作 =========
-define(sql_select_boss_first_blood_plus_data, <<"select * from `boss_first_blood_plus_data`">>).
-define(sql_replace_boss_first_blood_plus_data, <<"replace into boss_first_blood_plus_data(`type`, `sub_type`, `object_id`, `data`) values(~p, ~p, ~p, '~s')">>).
-define(sql_truncate_boss_first_blood_plus_data, <<"truncate table boss_first_blood_plus_data">>).