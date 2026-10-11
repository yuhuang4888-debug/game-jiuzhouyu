%%-----------------------------------------------------------------------------
%% @Module  :       eternal_valley
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-11
%% @Description:    永恒碑谷(契约之书)
%%-----------------------------------------------------------------------------

-define(UNFINISH,           0).     %% 未完成
-define(FINISH,             1).     %% 已完成
-define(HAS_RECEIVE,        2).     %% 已收到

-define(WSTATUS_SUCCESS,    1).     %% 写入成功
-define(WSTATUS_WAIT,       2).     %% 待写入

-define(SAVE_DB_CD,         10).        %% 写入数据库CD时间

-record(chapter_cfg, {
    id = 0,                             %% 章节id
    name = <<>>,                        %% 名字
    desc = <<>>,                        %% 描述
    skill_list = [],                    %% 解锁技能id
    condition = []                      %% 解锁条件[前置章节id]
    }).

-record(stage_cfg, {
    chapter = 0,                        %% 章节id
    stage = 0,                          %% 阶段
    desc = <<>>,                        %% 描述
    reward = [],                        %% 奖励
    condition = [],                     %% 达成条件 {条件格式类型,值} 目前只能单个条件
    recommended_list = [],              %% 推荐列表 [对应的值]
    cli_desc =[]                        %% 客户端显示
    }).

-record(chapter_status, {
    chapter = 0,
    status = 0,                         %% 奖励状态 0: 未达成 1: 已达成 2: 已领取
    stage_list = []
    }).

-record(stage_status, {
    chapter = 0,
    stage = 0,
    progress = 0,                       %% 可能是数字也可能是列表 根据条件区分
    status = 0,                         %% 奖励状态 0: 未达成 1: 已达成 2: 已领取
    extra = [],
    wtime = 0,                          %% 最近一次更新写入数据库的时间
    wstatus = 0                         %% 写入状态 1: 写入成功 2: 待写入
    }).

-define(select_eternal_valley_chapter,
    <<"select `chapter`, `status` from `eternal_valley_chapter` where `role_id` = ~p">>).
-define(select_eternal_valley_stage,
    <<"select `chapter`, `stage`, `progress`, `status`, `extra` from `eternal_valley_stage` where `role_id` = ~p">>).

-define(insert_eternal_valley_stage,
    <<"insert into `eternal_valley_stage`(`role_id`, `chapter`, `stage`, `progress`, `status`, `extra`) values(~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(update_eternal_valley_chapter,
    <<"replace into `eternal_valley_chapter`(`role_id`, `chapter`, `status`) values(~p, ~p, ~p)">>).
-define(update_eternal_valley_stage,
    <<"update `eternal_valley_stage` set `progress` = ~p, `status` = ~p, `extra` = '~s' where `role_id` = ~p and `chapter` = ~p and `stage` = ~p">>).
-define(update_eternal_valley_stage_status,
    <<"update `eternal_valley_stage` set `status` = ~p where `role_id` = ~p and `chapter` = ~p and `stage` = ~p">>).

-define(replace_eternal_valley_stage,
    <<"replace into `eternal_valley_stage`(`role_id`, `chapter`, `stage`, `progress`, `status`, `extra`) values(~p, ~p, ~p, ~p, ~p, ~p)">>).
