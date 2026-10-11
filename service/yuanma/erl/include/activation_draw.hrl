



-record(activation_draw_state, {
        day_log = #{},          %% {type,subtype} => [{GradeId, [{{Range1, Range2}, Num}]}...] 
        role_log = #{},         %% {type,subtype} => [{RoleId, [{GradeId, Num}...]}...] 
        log = #{}               %% {type,subtype} => [{RoleId, [#log{}...]}...] 玩家抽奖记录
        ,grade_draw_map = #{}   %% {type,subtype} => [{Grade, Num}...]
        ,kf_record = #{}        %% {type,subtype} => SendList
        ,role_activation = #{}  %% {type,subtype} => [{roleid, state}]
    }).

%% 保存数据库请往后加
-record(log, {
        name = <<>>,
        reward = [],
        stime = 0
    }).

-define(NOT_ACHIEVE_CONDITION,  0). %% 未达成
-define(NOT_RECIEVE_ACHIEVED,   1). %% 已达成未领取
-define(HAS_RECIEVE_REWARD,     2). %% 已领取

%% 每日清理
-define(SQL_SELECT_GRADE_RECORD, <<"SELECT `type`, `subtype`, `grade`, `role_list` from `activation_grade`">>).
-define(SQL_UPDATE_GRADE_RECORD, <<"UPDATE `activation_grade` SET `role_list` = '~s' WHERE `type` = ~p AND `subtype` = ~p AND `grade` = ~p">>).
-define(SQL_REPLACE_GRADE_RECORD,<<"REPLACE INTO `activation_grade`(`type`, `subtype`, `grade`, `role_list`) VALUES (~p, ~p, ~p, '~s')">>).
-define(SQL_DELETE_GRADE_RECORD, <<"DELETE FROM `activation_grade` WHERE type = ~p and subtype = ~p">>).

%% 活动结束清理
-define(SQL_SELECT_RARE_GRADE_RECORD, <<"SELECT `type`, `subtype`, `role_id`, `recore_list` from `activation_rare_grade`">>).
-define(SQL_UPDATE_RARE_GRADE_RECORD, <<"UPDATE `activation_rare_grade` SET `recore_list` = '~s' WHERE `type` = ~p AND `subtype` = ~p AND `role_id` = ~p">>).
-define(SQL_REPLACE_RARE_GRADE_RECORD,<<"REPLACE INTO `activation_rare_grade`(`type`, `subtype`, `role_id`, `recore_list`) VALUES (~p, ~p, ~p, '~s')">>).
-define(SQL_DELETE_RARE_GRADE_RECORD, <<"DELETE FROM `activation_rare_grade` WHERE type = ~p and subtype = ~p">>).

%% 活动结束清理
-define(SQL_SELECT_ROLE_RECORD, <<"SELECT `type`, `subtype`, `role_id`, `recore_list` from `activation_role_record`">>).
-define(SQL_UPDATE_ROLE_RECORD, <<"UPDATE `activation_role_record` SET `recore_list` = '~s' WHERE `type` = ~p AND `subtype` = ~p AND `role_id` = ~p">>).
-define(SQL_REPLACE_ROLE_RECORD,<<"REPLACE INTO `activation_role_record`(`type`, `subtype`, `role_id`, `recore_list`) VALUES (~p, ~p, ~p, '~s')">>).
-define(SQL_DELETE_ROLE_RECORD, <<"DELETE FROM `activation_role_record` WHERE type = ~p and subtype = ~p">>).

%% 玩家活跃度奖励领取状态 role_activation_recieve
-define(SQL_SELECT_RECIEVE_RECORD, <<"SELECT `type`, `subtype`, `role_id`, `state`, `stime` from `role_activation_recieve`">>).
-define(SQL_UPDATE_RECIEVE_RECORD, <<"UPDATE `role_activation_recieve` SET `state` = '~s', `stime` = ~p WHERE `type` = ~p AND `subtype` = ~p AND `role_id` = ~p">>).
-define(SQL_REPLACE_RECIEVE_RECORD,<<"REPLACE INTO `role_activation_recieve`(`type`, `subtype`, `role_id`, `state`, `stime`) VALUES (~p, ~p, ~p, '~s', ~p)">>).
-define(SQL_DELETE_RECIEVE_RECORD, <<"DELETE FROM `role_activation_recieve` WHERE type = ~p and subtype = ~p">>).