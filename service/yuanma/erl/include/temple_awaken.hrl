%% ---------------------------------------------------------------------------
%% @doc temple_awaken

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/1
%% @deprecated  神殿觉醒头文件
%% ---------------------------------------------------------------------------
-define(KV(Key), data_temple_awaken:get_value(Key)).
-define(MIN_SUB_CHAPTER,   ?KV(1)).         % 第一个子章节ID， 解锁新的章节默认解锁这个东东
-define(AWAKEN_TASK_INFO,  ?KV(2)).         % 开起神殿觉醒之路任务信息，{前置任务ID， 觉醒之路任务ID}
-define(FASHION_CHAPTER,   ?KV(3)).         % 时装位置对应的章节ID
-define(ILLUSION_CHAPTERS, ?KV(4)).         % 章节对应幻型子类KV List
-define(FASHION_CHAPTERS,  ?KV(5)).         % 章节对应时装部位KV List (=====弃用=====)
-define(NEED_CHECK_TASK_ID,?KV(8)).         % 需要触发开启功能任务的ID列表（主线任务ID列表）
-define(NEED_CHECK_DUN_ID, ?KV(9)).         % 只能打一次的副本ID列表
-define(TEMPLE_AWAKEN_SID, ?KV(10)).        % 过场场景ID
-define(NO_LOG_ITEM_LIST,  ?KV(11)).        % 不记录子阶段任务进度值（产生数据太多了）


%% 神殿觉醒总体章节状态
-define(NOT_ALL_UNLOCK,     0).             % 未全部解锁
-define(ALL_UNLOCK,         1).             % 已全部解锁
-define(ALL_COMPLETE,       2).             % 已全部完成


%% 章节状态
-define(TEMPLE_LOCK,        0).             % 未解锁
-define(TEMPLE_PROCESS,     1).             % 进行中
-define(TEMPLE_COMPLETE,    2).             % 已完成，可领取
-define(TEMPLE_GOT,         3).             % 已领取

%% 子章节状态
-define(SUBTEMPLE_LOCK,     0).             % 未解锁
-define(SUBTEMPLE_PROCESS,  1).             % 进行中
-define(SUBTEMPLE_COMPLETE, 2).             % 已完成

%% 阶段任务状态
-define(STAGE_PROCESS,      1).             % 进行中
-define(STAGE_COMPLETE,     2).             % 已完成，可领取
-define(STAGE_GOT,          3).             % 已领取

%% 章节幻型状态
-define(IS_WARE,            1).             % 穿戴幻型中
-define(NOT_WARE,           0).             % 未穿戴幻型


-record(status_temple_awaken, {
%%    status          = ?NOT_ALL_UNLOCK,
    temple_awaken_map = #{},                % #{ChapterId => #chapter_status{}}
    sum_attr        = []
}).

%% 每一章节神殿觉醒状态
-record(chapter_status, {
    chapter_id      = 0,                    % 章节id
    status          = ?TEMPLE_PROCESS,      % 状态 1:进行中；2：可领取; 3:已领取
    sub_chapters    = [],                   % 子章节状态 [#sub_chapter_status{}|_]
    is_ware         = ?NOT_WARE             % 是否穿戴了当前觉醒章节的指定唤醒
}).

%% 每个子章节神殿觉醒状态 (chapter -> [sub_chapter])
-record(sub_chapter_status, {
    sub_chapter     = 0,                    % 子章节id
    status          = ?SUBTEMPLE_PROCESS,   % 状态 1已解锁  2已完成
    stage_lists     = []                    % 任务阶段状态 [#stage_chapter_status{}|_]
}).

%% 每个阶段状态 (sub_chapter -> [stage])
-record(stage_chapter_status, {
    stage           = 0,                    % 阶段id
    process         = 0,                    % 进度
    status          = ?STAGE_PROCESS        % 任务状态 1:进行中；2：可领取；3已领取
}).

%% 神殿觉醒配置
-record(base_temple_awaken, {
    chapter_id      = 0,
    chapter_name    = [],
    condition       = [],
    attr            = [],
    pos_type        = 0     %% BT字段，对应时装的位置或者做起模块幻型类型
}).

%% 神殿觉醒章节配置
-record(base_temple_awaken_stage, {
    chapter_id      = 0,
    sub_chapter     = 0,
    stage           = 0,
    open_con        = [],
    complete_con    = [],
    reward          = []
}).

-record(base_temple_awaken_suit, {
    chapter_id      = 0,
    career          = 0,
    figure_id       = 0,
    reward          = []
}).

-define(sql_select_temple_awaken, <<"SELECT `chapter_id`, `status`, `is_ware` FROM `role_temple_awaken` WHERE `role_id` = ~p">>).
-define(sql_select_temple_awaken_sub, <<"SELECT `chapter_id`, `sub_chapter`, `status` FROM `role_temple_awaken_sub` WHERE `role_id` = ~p">>).
-define(sql_select_temple_awaken_stage, <<"SELECT `chapter_id`, `sub_chapter`, `stage`, `process`, `status` FROM `role_temple_awaken_stage` WHERE `role_id` = ~p">>).

-define(sql_replace_temple_awaken, <<"REPLACE INTO `role_temple_awaken` (`role_id`, `chapter_id`, `status`, `is_ware`) VALUES (~p, ~p, ~p, ~p)">>).
-define(sql_replace_temple_awaken_sub, <<"REPLACE INTO `role_temple_awaken_sub` (`role_id`, `chapter_id`, `sub_chapter`, `status`) VALUES (~p, ~p, ~p, ~p)">>).
-define(sql_replace_temple_awaken_stage, <<"REPLACE INTO `role_temple_awaken_stage` (`role_id`, `chapter_id`, `sub_chapter`, `stage`, `process`, `status`) VALUES (~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_update_temple_awaken_stage1, <<"UPDATE `role_temple_awaken_stage` SET `status` = ~p WHERE `role_id` = ~p and `chapter_id` = ~p and `sub_chapter` = ~p and `stage` = ~p">>).
-define(sql_update_temple_awaken_stage2, <<"UPDATE `role_temple_awaken_stage` SET `process` = ~p WHERE `role_id` = ~p and `chapter_id` = ~p and `sub_chapter` = ~p and `stage` = ~p">>).
-define(sql_update_temple_awaken_stage3, <<"UPDATE `role_temple_awaken_stage` SET `process` = ~p and `stage` = ~p WHERE `role_id` = ~p and `chapter_id` = ~p and `sub_chapter` = ~p and `stage` = ~p">>).
