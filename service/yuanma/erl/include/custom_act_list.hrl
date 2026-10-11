%% ===================================================
%% 一些定制活动的具体内容
%% ===================================================

%% =================================================== 神器租用活动
%% 活动类型 

-define(HIRE_STATE_NOT_ENOUGH, 0).  %% 未满足永久租用条件
-define(HIRE_STATE_ENOUGH, 1).  %% 已满足永久租用条件
-define(HIRE_TIME, 10*3600).  %% 10小时
-record(hire_status, {
	hire_list = [],
	ref = []
    }).

-record(hire_info, {
	key = 0, 							%% {主类，子类}
    type = 0,                           %% 活动主类型
    subtype = 0,                        %% 活动子类型 
    hire_times = 0, 	%% 租用次数
    acc_hire_times = 0, %% 累积租用次数
    hire_time = 0,      %% 租借时间
    time = 0, 			%% 过期时间
    hire_state = 0      %% 租用状态 0 租用 1 永久
    }).

-define(sql_hire_act_select_all, <<"select type, subtype, hire_times, acc_hire_times, hire_time, time from `hire_act_info` where role_id = ~p">>).  
-define(sql_hire_act_replace, <<"replace into `hire_act_info` set role_id=~p, type=~p, subtype=~p, hire_times=~p, acc_hire_times=~p, hire_time=~p, time=~p ">>). 
-define(sql_hire_act_delete, <<"delete from `hire_act_info` where role_id=~p and type=~p and subtype=~p ">>).

%% =================================================== 神器租用活动(end)


%% =================================================== 节日投资活动

-record(fest_investment, {
    key = 0,                            %% {主类，子类, 投资档次}
    type = 0,                           %% 活动主类型
    subtype = 0,                        %% 活动子类型 
    lv = 0,     %% 投资档次
    buy_time = 0, %% 购买时间
    get_time = 0,      %% 领奖时间
    days_utime = 0,     %% 登陆当天0点时间戳
    login_days = 0,    %% 登陆天数
    rewards = []       %% 已领奖励id
    }).

%% =================================================== 节日投资活动(end)

%% =================================================== 等级抽奖

-record(level_draw, {
    subtype = 0,                        %% 活动子类型 
    draw_time = 0,                      %% 抽奖时间
    participant = [],                   %% 参与者 [{role_id,是否得奖}]
    ref = none                          %% 定时器
    }).

%% =================================================== 等级抽奖(end)

%% =================================================== 红包雨

-record(rer_state, {
    custom_act_rain = #{}              %% 定制活动的红包雨
    }).

-record(red_envelopes_rain, {
    subtype = 0,                        %% 活动子类型 
    act_value = 0,
    start_time = 0,                     %% 红包发放时间
    wave = 0,                           %% 第几波
    is_openning = true,                 %% 是否开启中
    receivers = [],                     %% 红包得主 [{波数, 玩家列表}]
    not_receivers = [],                 %% 开过红包但不是得主 [{波数, 玩家列表}]
    ref = none                          %% 红包定时器
    }).

-record(envelopes_receiver, {
    role_id = 0,
    role_name = 0,
    server_id = 0,
    server_num = 0,
    lv = 0,
    career = 0,
    sex = 0,
    picture = "",
    picture_ver = 0,
    rewards = []
    }).

%% =================================================== 红包雨(end)


%% =================================================== 跨服团购

-record(gpbuy_state, {
    act_list = [],             %% [#act_info{}]
    role_map = #{},
    shout_time_map = #{}       %% 喊话时间 #{ {Type, SubType, player_id} => last_shout_time}
    }).

-record(gpbuy_role, {
    key = 0,          %% {RoleId, Type, SubType}
    role_id = 0,
    role_name = 0,
    server_id = 0,
    server_num = 0,
    buy_list = [],      %% [#gp_goods{}]
    end_time = 0
    }).

-record(gp_goods, {
    gp_goods_id = 0,    %% 商品id
    first_buy = [],        %% 购买次数列表
    first_buy_time = 0,
    tail_buy = [],          %% 尾款购买次数列表
    tail_buy_time = 0
    }).

%% =================================================== 红包雨(end)