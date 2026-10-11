%%-----------------------------------------------------------------------------
%% @Module  :       reincarnation
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-07
%% @Description:    转生
%%-----------------------------------------------------------------------------

%% 四转等级
-define(DEF_TURN_4_LV, 370).

%% 转生数
-define(DEF_TURN_0, 0).
-define(DEF_TURN_1, 1).
-define(DEF_TURN_3, 3).
-define(DEF_TURN_4, 4).
-define(DEF_TURN_5, 5).

%% 最大转生数
-define(MAX_TURN,   4).

-record(reincarnation_cfg, {
    career = 0,                     %% 职业
    sex = 0,                        %% 性别
    turn = 0,                       %% 转生次数
    full_lv = 0,                    %% 满级
    icon = "",
    name = 0,
    model_id = 0,                   %% 模型id 1101（1职业+1（1男2女）+00（转生次数，未转生之前是00，之后01···）
    attr = [],                      %% 属性提升
    unlock_skill = [],              %% 解锁技能
    replace_skill = [],             %% 替换技能
    turn_skill = [],                %% 转生等级##客户端显示[{Skillid, Lv}]
    turn_cost = []                  %% 转生消耗(可直接跳过任务完成)
    }).

-record(reincarnation_task_cfg, {
    task_id = 0,                    %% 任务id
    turn = 0,                       %% 几转
    stage = 0,                      %% 阶段
    finish_lv = 0,                  %% 完成任务等级
    attr = []                       %% 任务属性奖励
    }).

-record(reincarnation, {
    role_id = 0,                    %% 玩家id
    turn = 0,                       %% 转生次数
    turn_stage = 0,                 %% 转生阶段
    stage_tasks = [],               %% 完成的阶段任务id
    attr = []                       %% 转生的属性奖励
    }).

-define(sql_get_reincarnation_data, <<"select turn, stage, stage_tasks, attr from reincarnation where role_id = ~p">>).
-define(sql_save_reincarnation_data, <<"replace reincarnation(role_id, turn, stage, stage_tasks, attr) values(~p, ~p, ~p, '~s', '~s')">>).
-define(sql_get_reincarnation_turn, <<"select turn from reincarnation where role_id = ~p">>).