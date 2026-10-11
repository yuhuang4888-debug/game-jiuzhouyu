%%-----------------------------------------------------------------------------
%% @Module  :       rec_achievement
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-23
%% @Description:    成就
%%-----------------------------------------------------------------------------

%% 由于成就数据可能比较庞大,所以成就数据保存在字典
-define(P_ACHIEVEMENT,      "P_ACHIEVEMENT").

-define(UNFINISH,           0).         %% 未完成
-define(FINISH,             1).         %% 已完成未领取奖励
-define(HAS_RECEIVE,        2).         %% 已领取奖励

-define(WSTATUS_SUCCESS,    1).
-define(WSTATUS_WAIT,       2).

-define(SAVE_DB_CD,         10).        %% 写入数据库CD时间

-define(NOTIFY_TYPE_STAR_NUM, 1).

-record(achievement_cfg, {
    id = 0,                 %成就id
    category = 0,           %成就分类 6大类 依据这个排序
    desc = "",              %成就描述   
    condition = 0,          %完成条件                        
    reward = [],            %奖励
    star = 0,               %成就点
    next_id = 0,            %下一个成就id
    is_inherit = 0,         %继承进度0不继承，1继承
    show_progress = 0,      %展示完成过程
    ways = 0                %前往途径
    % sub_category = 0,       %成就大类的子类
    % type = 0,               %成就类型（最小的分类）  
    % name = "",              %成就名称
    % is_hide = 0,            %隐藏成就
    % designation = 0         %称号
    }).
%%yyhx成就星数改为成就点
-record(star_reward_cfg, {   
    stage = 0,              % 阶数                    
    star = 0,               % 成就点
    reward = []             % [{hp,10},{}]属性奖励

    % name = "",              %名字
    % desc = "",       
    % designation = 0
    }).


-record(status_achievement, {
    star_map = #{},             %% #{category => star}
    star_reward_list = [],      %% [{star, status}]
    finish_list = [],           %% [#achievement{}] 已经领取完奖励的成就列表
    achievement_list = [],      %% [#achievement{}] 保存有进度数据的成就
    stage = 0                   %% 当前等阶
    ,type_list = []             %% 成就类型状态(type, nowstar, totalstar)
    ,type_star_list = []        %% 成就类型星数配置 {type, totalstar}
    }).

% -record(star_reward, {
%     star = 0,
%     status = 0
%     }).

-record(achievement, {
    id = 0,                     %% 成就id
    progress = 0,               %% 进度
    status = 0,                 %% 奖励状态 0: 未达成 1: 已达成 2: 已领取
    wtime = 0,                  %% 最近一次更新写入数据库的时间
    wstatus = 0                 %% 写入状态 1: 写入成功 2: 待写入
    }).




-define(SELECT_ACHV_BYID,
    <<"SELECT `progress`, `status` FROM `achievement` WHERE `role_id` = ~p AND `id` = ~p ">>).

-define(select_achievement,
    <<"select `id`, `progress`, `status` from `achievement` where `role_id` = ~p">>).
-define(select_achievement_star_reward,
    <<"select `star`, `status` from `achievement_star_reward` where `role_id` = ~p">>).

-define(insert_achievement,
    <<"replace into `achievement`(`role_id`, `id`, `progress`, `status`, `time`) values(~p, ~p, ~p, ~p, ~p)">>).
-define(insert_achievement_star_reward,
    <<"replace into `achievement_star_reward`(`role_id`, `star`, `status`, `time`) values(~p, ~p, ~p, ~p)">>).

-define(update_achievement_progress,
    <<"update `achievement` set `progress` = ~p, `status` = ~p, `time` = ~p where `role_id` = ~p and `id` = ~p">>).
-define(update_achievement_status,
    <<"update `achievement` set `status` = ~p, `time` = ~p where `role_id` = ~p and `id` = ~p">>).