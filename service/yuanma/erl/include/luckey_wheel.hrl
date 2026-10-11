


-record(local_wheel_state, {
        act_data = #{},               %% 活动数据{Type, Subtype} => [#act_data]
        record = #{}                  %% 记录{Type, Subtype} => [#wheel_record] 跨服模式保留跨服记录
    }).

-record(wheel_record, {  %% 活动记录
        key = {0,0},        %%键
        server = 0,         %%本服记录发0
        server_num = 0,     %%本服记录发0
        role_id = 0,
        role_name = <<>>,
        reward = 0,
        stime = 0
    }).

-record(act_data, {
        key = {0,0},
        pool_reward = [],
        draw_times = 0,
        role_data = []          %% [{RoleId, DrawTimes}] 本服数据
        ,role_counter = #{}     %% {Type, Subtype} => [{RoleId, [{Grade, Num, Time}]}]
    }).


-record(kf_wheel_state, {
        kf_act_data = #{},      %% 活动数据{Type, Subtype} => #kf_act_data
        kf_record = #{}         %% 记录{Type, Subtype} => [#wheel_record]
    }). 

-record(kf_act_data, {
        key = {0,0},
        pool_reward = [],
        draw_times = 0,
        end_time = 0,
        end_ref = undefined
    }).

-define(SELECT_ROLR_DATA, <<"SELECT `role_id`, `draw_times` FROM `role_luckey_wheel` where `type` = ~p and `subtype` = ~p">>).
-define(UPDATE_ROLE_DATA, <<"REPLACE INTO `role_luckey_wheel`(`type`, `subtype`, `role_id`, `draw_times`) VALUES (~p, ~p, ~p, ~p)">>).
-define(DELETE_ROLE_DATA, <<"DELETE FROM `role_luckey_wheel` WHERE `type` = ~p AND `subtype` = ~p">>).

-define(SELECT_ACT_DATA,  <<"SELECT `pool_reward`, `draw_times` FROM `luckey_wheel` where `type` = ~p and `subtype` = ~p">>).
-define(UPDATE_ACT_DATA,  <<"REPLACE INTO `luckey_wheel`(`type`, `subtype`, `pool_reward`, `draw_times`) VALUES (~p, ~p, '~s', ~p)">>).
-define(DELETE_ACT_DATA,  <<"DELETE FROM `luckey_wheel` WHERE `type` = ~p AND `subtype` = ~p">>).

-define(SELECT_ACT_RECORD,  <<"SELECT `role_id`, `role_name`, `reward`, `stime` FROM `luckey_wheel_record` where `type` = ~p and `subtype` = ~p">>).
-define(UPDATE_ACT_RECORD,  <<"INSERT INTO `luckey_wheel_record`(`type`, `subtype`, `role_id`, `role_name`, `reward`, `stime`) VALUES (~p, ~p, ~p, '~s', '~s', ~p)">>).
-define(DELETE_ACT_RECORD,  <<"DELETE FROM `luckey_wheel_record` WHERE `type` = ~p AND `subtype` = ~p">>).
-define(TRUNCATE_ACT_RECORD,  <<"truncate `luckey_wheel_record`">>).

-define(SELECT_ACT_DATA_KF,  <<"SELECT `type`, `subtype`, `pool_reward`, `draw_times`, `end_time` FROM `luckey_wheel_kf`">>).
-define(UPDATE_ACT_DATA_KF,  <<"REPLACE INTO `luckey_wheel_kf`(`type`, `subtype`, `pool_reward`, `draw_times`, `end_time`) VALUES (~p, ~p, '~s', ~p, ~p)">>).
-define(DELETE_ACT_DATA_KF,  <<"DELETE FROM `luckey_wheel_kf` WHERE `type` = ~p AND `subtype` = ~p">>).

-define(SELECT_ACT_RECORD_KF,  <<"SELECT `server`, `server_num`, `type`, `subtype`, `role_id`, `role_name`, `reward`, `stime` FROM `luckey_wheel_record_kf`">>).
-define(UPDATE_ACT_RECORD_KF,  <<"INSERT INTO `luckey_wheel_record_kf`(`server`, `server_num`, `type`, `subtype`, `role_id`, 
        `role_name`, `reward`, `stime`) VALUES (~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p)">>).
-define(DELETE_ACT_RECORD_KF,  <<"DELETE FROM `luckey_wheel_record_kf` WHERE `type` = ~p AND `subtype` = ~p">>).
-define(TRUNCATE_ACT_RECORD_KF,  <<"truncate `luckey_wheel_record_kf`">>).

-define(SELECT_ACT_GRADE_DATA,  <<"SELECT `role_id`, `grade`, `num`, `time` FROM `role_luckey_wheel_draw` where `type` = ~p and `subtype` = ~p">>).
-define(UPDATE_ACT_GRADE_DATA,  <<"REPLACE INTO `role_luckey_wheel_draw`(`role_id`, `type`, `subtype`, `grade`, `num`, `time`) VALUES (~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(DELETE_ACT_GRADE_DATA,  <<"DELETE FROM `role_luckey_wheel_draw` WHERE `type` = ~p AND `subtype` = ~p">>).
