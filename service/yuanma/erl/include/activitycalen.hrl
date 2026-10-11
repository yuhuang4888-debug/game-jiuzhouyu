%% ---------------------------------------------------------------------------
%% @doc activitycalen.hrl

%% @author xiaoxiang
%% @since  2017-03-06
%% @deprecated 活动日历
%% ---------------------------------------------------------------------------

%% ----------------------- 活动状态 -----------------------

-define(AC_WAIT, 0).    %% 活动等待
-define(AC_OPEN, 1).    %% 活动开启
-define(AC_END, 2).     %% 活动结束
-define(AC_LV_LIMIT, 3). %% 活动等级限制
-define(AC_FINISH, 4).   %% 活动完成
-define(AC_OPEN_DAY_LIMIT , 5). %%开服天数限制

%% ----------------------- 次数类型 -----------------------
-define(ACTIVITY_COUNT_TYPE_NORMAL, 1).        % 通用次数(活动进入次数等等)
-define(ACTIVITY_COUNT_TYPE_HELP_COUNT, 2).    % 助战次数(目前用于副本助战)


-define(ACTIVITY_TYPE_DAILY, 1).        % 1-非限时活动
-define(ACTIVITY_TYPE_TIME, 2).         % 2-限时活动

-define(ACTIVITY_LIVENESS, 1).         % 日计数器 活跃度次数Id

-define(AC_LIVE_ADD,        1000).
-define(AC_LIVE_ADD_EACH,   10000).

-define(LOG_TYPE_AC_START_BY_CALEN,  1).            %% 活动日历拉起活动
-define(LOG_TYPE_AC_START_BY_AC,  2).               %% 活动启动
-define(LOG_TYPE_AC_END_BY_AC,  3).                 %% 活动结束
-define(LOG_TYPE_AC_ADVANCE_BY_CALEN,  4).          %% 活动预告

-define(NOT_REWARD,           0).   %% 不可领
-define(HAVE_REWARD,          1).   %% 可领
-define(FINISH_REWARD,        2).   %% 已领


-define(STATE_NOT_FIND_LIVE, 0).        % 未找回
-define(STATE_FIND_LIVE, 	1).        % 已找回
-define(STATE_FINISHED_LIVE, 2).    % 已完成

-define(TODAY_LIVE, 		0).        % 今天
-define(YESTERDAY_LIVE, 	1).        % 昨天
-define(B_YESTERDAY_LIVE, 2).        % 前天

-define(week_task,  2). % 周任务

-define(AC_COUNTER_TYPE(ModId, SubId), ModId*?AC_LIVE_ADD+SubId). % 日常计数器类型转换

%% -------------------------------------------后台配置-----------------------------------------------------------------
%% 活动日历
-record(base_ac, {
    module = 0,
    module_sub = 0,     %%  功能id和子功能ID确定唯一活动
    ac_sub = 0,         %%  活动子类用于区分同一活动的不同配置
    ac_name = "",
    ac_icon = 0,
    num = 0,            %%  活动单位：1-单人2-组队3-公会4-对战5-竞技
    start_lv = 0,       %%  玩家到达等级才看到“日常”标签页的图标，才能参加活动
    end_lv = 0,         %%  玩家到达等级，活动消失，“日常”标签页的图标消失
    ac_type = 0,        %%  活动类型：1-非限时活动；2-限时活动
    week = [],          %%  格式：[1,2,3,4,5,6,7] ，7表示星期天 []默认为每天都开
    month = [],         %%  格式：[1,2,28], 勿填>28的数字（程序容错，>28时不开启） []默认为每天都开
    time = [],          %%  格式：[{2017,3,11}]，[] 默认为每天都开
    time_region = [],   %%  格式：[{{开始时间},{结束时间}},{{}}]；如[{{20,0},{20,30}}] 非定时活动固定填[]
    open_day = 0,       %%  格式：[{开服开始天数，结束天数},{}];如[{1,20},{50,100}],[]默认每天都开
    merge_day = 0,      %%  和开服格式一样,注：[]为单服，合服必须填具体内容
    about = "",
    reward = [],        %% 格式:[{等级,[{类型，道具id，数量},{类型，道具id，数量}]}]
    ask = 0,
    look = 0,
    other = [],
    start_timestamp = 0,  %% 开始时间戳
    end_timestamp = 0,   %% 结束时间戳
    timestamp = [],     %% 时间范围有效 [{start_timestamp, end_timestamp}|...] 开始时间戳，结束时间戳  时间戳属于区间则生效 []默认满足
    type = 0            %% 默认为0 merge_day使用的为活动日历规则（[]为单服，合服必须填具体内容 ）1为merge_day使用充值活动规则（[]为满足）
    ,sign_up_reward = []
    ,sign_up_mail = []
    }).

%% 活跃度配置
-record(ac_liveness, {
    module = 0,
    module_sub = 0,
    act_type = 0,   %%活动类型
    name = "",
    start_lv = 0,
    end_lv = 0,
    max = 0,       %%活跃度找回次数。也是完成次数
    res_max = 0,   %%资源找回次数
    live = 0
    }).

%% 奖励配置
-record(ac_reward, {
    id = 0,
    live = 0,           %% 活跃度
    reward = []
    }).

%% 活动推送配置
-record(ac_push, {
    module = 0,
    module_sub = 0,
    push = 0,
    push_msg = ""
    }).

%% 活跃度外形升级配置
-record(base_liveness_lv, {
    lv = 0,                 %% 等级
    liveness = 0,           %% 活跃度
    attr = []               %% 属性
    }).

%% 活跃度外形激活配置
-record(base_liveness_active, {
    id = 0,                 %% 外形Id
    name = "",              %% 外形名称
    lv = 0,                  %% 激活等级
    figure_id = 0           %% 资源id
    }).


%% --------------------------------------------------state---------------------------
-record(ac_mgr_state, {
    ref = none,
    ac_maps = maps:new(),            %% 活动状态记录
    %ac_start = []                   %% 活动首次开启记录
    remind_map = maps:new()          %% 活动提醒信息 #{RoleId => {IsRemind, UpdateTime}}
    }).

-record(ac_state, {
        ac_maps = maps:new(),     %% 活动状态
        ac_end_maps = maps:new(), %% role_id => [{ac_id, num}|...]
        live_maps = maps:new()    %% role_id => live
    }).


-record(st_liveness, {
    lv = 0,             %% 玩家当前活跃度等级
    liveness = 0,       %% 当前活跃度
    id = 0,             %% 玩家所选择的活跃度形象ID
    figure_id = 0,      %% 资源Id
    display_status = 0, %% 显示状态 1：显示 0：隐藏
    attr = [],          %% 活跃度形象增加的属性
    combat = 0          %% 活跃度形象增加的战力
    }).
%%活跃度找回
-record(liveness_back, {
    cleartime = 0,			%% 结算时间
    res_act_map = #{}	    %% #{?DayType => #{actid => #res_act_live{} }}
}).

-record(res_act_live, {
    act_id = 0,				     %% 模块id
    act_sub = 0,			     %% 模块子id
    lefttimes = 0,			     %% 剩余次数
    backtimes = 0,               %% 已找回次数
    max = 0,				     %% 最大次数
    state = ?STATE_NOT_FIND_LIVE %% 状态
}).
%% ----------------------------------------------------------------------------------



%% 活动报名(奖励)状态
-define(not_sign_up,        0). % 未报名
-define(have_sign_up,       1). % 已报名未领取奖励
-define(receive_sign_up,    2). % 已报名已领取奖励

-define(have_finish, 1).
-define(not_finish,  0).

-record(act_sign_up, {
    sign_up_list = []
    ,guild_war = 0           %%1是有资格 0 是没有资格
}).

-record(sign_up_msg, {
    key = undefined ,        %% {mod_id, sub_mod_id, act_id}
    mod_id = 0,
    sub_mod_id = 0
    ,act_id = 0
    ,arg = []          %% 参数
    ,ref = []          %% 活动定时器
    ,start_time = 0    %% 活动开始时间
    ,end_time = 0
    ,end_ref = []
    ,status = ?not_sign_up   %% 一般来说只有报名了才有记录
    ,is_finish = 0          %% 是否完成活动
}).

%% sign_up_msg

-define(sql_select_sign_up, <<"select  mod_id, sub_mod_id, act_id, start_time, end_time, status, is_finish  from   sign_up_msg  where role_id = ~p">>).

-define(sql_save_sign_up, <<"REPLACE  into   sign_up_msg(role_id, mod_id, sub_mod_id, act_id, start_time, end_time,  `status`,  is_finish)  VALUES(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(del_save_sign_up, <<"DELETE  from   sign_up_msg  where   role_id  = ~p and  mod_id = ~p and  sub_mod_id = ~p and act_id = ~p">>).

-define(truncate_sign_up, <<"truncate table sign_up_msg">>).

%% active_start

-define(sql_inset_ac_start, <<"insert into active_start(ac_id, ac_sub, ac_type, time) values(~p, ~p, ~p, ~p)">>).

-define(sql_select_ac_start, <<"select `ac_id`, `ac_sub`, `ac_type`, `time` from `active_start`  ">>).

-define(sql_player_liveness_select, <<"select `lv`, `liveness`, `id`, `display_status` from `player_liveness` where `role_id` = ~p">>).

-define(sql_player_liveness_replace, <<"replace into `player_liveness` (`role_id`, `lv`, `liveness`, `id`, `display_status`) values(~p, ~p, ~p, ~p, ~p)">>).