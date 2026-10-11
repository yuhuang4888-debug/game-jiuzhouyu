%% ---------------------------------------------------------------------------
%% @doc custom_act_liveness.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-03-04
%% @deprecated 节日活跃奖励记录
%% ---------------------------------------------------------------------------

%% trigger_type=1 param=结束时间戳
%% trigger_type=2 param=结束时间戳
-record(role_liveness, {
        type = 0            % 类型
        , subtype = 0       % 子类型
        , grade_id = 0      % 奖励id
        , trigger_type = 0  % 触发类型
        , param = undefined % 奖励参数
    }).

%% 定制活动节日活动效果状态
-record(status_ca_liveness, {
        liveness_map = #{}  % Key:{Type, SubType, GradeId},Value:#role_liveness{}
    }).

%% 活跃度记录[玩家]
%% 存储在 #status_custom_act.data_map 中的 #custom_act_data{}
-record(custom_act_liveness, {
        times = 0           % 抽奖次数
        , grade_state = []  % 奖励档次对应的抽中次数[{GradeId,Times}]
        , utime = 0         % 更新时间##判断是否需要清理
    }).

%% 类型
-define(CA_LIVENESS_EXP_DUN_DOUBLE, 1).             % 经验本双倍收益##触发参数:持续时间
-define(CA_LIVENESS_MATERIALS_DUN_DOUBLE, 2).       % 材料本双倍收益##触发参数:持续时间
-define(CA_LIVENESS_BOSS_REFRESH, 3).               % 全服boss立即刷新
-define(CA_LIVENESS_SER_REWARD, 4).                 % 全服获得指定道具
-define(CA_LIVENESS_TREASURE_HUNT_LUCKEY, 5).       % 最大幸运值值在寻宝配置/寻宝配置中
-define(CA_LIVENESS_MATERIALS_DUN_EXTRA, 6).        % 材料副本额外收益:持续时间 0.15倍

-record(sub_custom_act_liveness, {
        type = 0                % 主类型
        , subtype = 0           % 次类型
        , liveness_num = 0      % 活跃人数
        , merge_time = 0        % 合服时间
        , times = 0             % 全服抽奖次数
        , utime = 0             % 更新时间
        , trigger_list = []     % 触发列表##[{GradeId,TriggerType,参数}]
    }).

%% 活跃度记录[进程]
-record(custom_act_liveness_state, {
        liveness_map = #{}  
    }).

%% 合服保留最大的liveness,times,清掉trigger_list,其他跟主服一样
-define(sql_custom_act_liveness_select, <<"SELECT type, subtype, liveness_num, merge_time, times, utime, trigger_list FROM custom_act_liveness">>).
-define(sql_custom_act_liveness_replace, <<"
        REPLACE INTO custom_act_liveness(type, subtype, liveness_num, merge_time, times, utime, trigger_list) VALUES(~p, ~p, ~p, ~p, ~p, ~p, '~s')"
    >>).
-define(sql_custom_act_liveness_delete, <<"DELETE FROM custom_act_liveness WHERE type=~p and subtype=~p">>).

%% 其他sql
%% 查询活跃度人数
-define(sql_player_login_num, <<"SELECT count(*) FROM player_login, player_low WHERE player_login.id = player_low.id AND last_login_time>=~p AND last_login_time<=~p AND lv >= ~p">>).