%%-----------------------------------------------------------------------------
%% @Module  :       treasure_hunt
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-22
%% @Description:    寻宝头文件
%%-----------------------------------------------------------------------------

%% 寻宝类型
-define(TREASURE_HUNT_TYPE_EUQIP, 1).                       %% 装备寻宝
-define(TREASURE_HUNT_TYPE_PEAK, 2).                        %% 巅峰寻宝
-define(TREASURE_HUNT_TYPE_EXTREME, 3).                     %% 至尊寻宝
-define(TREASURE_HUNT_TYPE_RUNE, 4).                        %% 符文寻宝
-define(TREASURE_HUNT_TYPE_BABY, 5).                        %% 宝宝寻宝

-define(TREASURE_SCORE_SHOP, treasure_score_shop).          %% 积分商城消耗类型

%% 新的寻宝规则
-define(NEW_TREASURE_HUNT_TYPE_RULE, [
    ?TREASURE_HUNT_TYPE_EUQIP, ?TREASURE_HUNT_TYPE_PEAK, ?TREASURE_HUNT_TYPE_EXTREME
]).

-define(TREASURE_HUNT_TYPE_LIST, [
    ?TREASURE_HUNT_TYPE_EUQIP,
    ?TREASURE_HUNT_TYPE_PEAK,
    ?TREASURE_HUNT_TYPE_EXTREME,
    ?TREASURE_HUNT_TYPE_BABY
    ]).

-define(LUCKEY_TREASURE_HUNT_TYPE_LIST, [
    ?TREASURE_HUNT_TYPE_EUQIP,
    ?TREASURE_HUNT_TYPE_PEAK,
    ?TREASURE_HUNT_TYPE_EXTREME
    ]).

-define(OBJECT_TYPE_ALL,        1).            %% 类型 全服
-define(OBJECT_TYPE_PERSION,    2).            %% 类型 玩家个人

-record(treasure_hunt_cfg, {
    id = 0,
    key = "",
    val = 0,
    desc = ""
    }).

-record(treasure_hunt_reward_cfg, {
    id = 0,
    min_rlv = 0,                        %% 玩家等级下限
    max_rlv = 0,                        %% 玩家等级上限
    htype = 0,                          %% 寻宝类型 具体参考：TREASURE_HUNT_TYPE
    stype = 0,                          %% 宝物分类 同类物品共享抽中的次数
    weight = 0,                         %% 抽中的权重
    special = [],                       %% 特殊处理（幸运值与特殊权重关系）
    goods_id = 0,                       %% 奖励物品id
    goods_num = 0,                      %% 奖励物品数量
    is_tv = 0,                          %% 是否发送传闻
    is_rare = 0                         %% 是否稀有
    }).

-record(treasure_hunt_limit_cfg, {
    htype = 0,                          %% 寻宝类型 具体参考：TREASURE_HUNT_TYPE
    stype = 0,                          %% 宝物分类
    lim_obj = 0,                        %% 限制对象
    reset_times = 0,                    %% 寻宝次数达到此值，重置这类物品的获得次数
    lim_times = 0                       %% 这类宝物每次重置后能抽中的次数
    }).

-record(reward_status, {
    htype = 0,
    stype = 0,
    obj_id = 0,                         %% 限制的对象id 限制个人的话为玩家id 全服限制的话为0
    obtain_times = 0,                   %% 获得次数
    last_draw_times = 0                 %% 上一次抽到该类型大奖所消耗的次数
    }).

%% 寻宝记录
-record(reward_record, {
    role_id = 0,                        %% 玩家id
    role_name = 0,                      %% 玩家名字
    role_lv = 0,
    sex = 0,
    career = 0,
    picture = "",
    picture_ver = 0,
    htype = 0,                          %% 寻宝类型 具体参考：TREASURE_HUNT_TYPE
    gtype_id = 0,                       %% 物品类型id
    goods_num = 0,                      %% 物品数量
    time = 0,                           %% 时间
    is_rare = 0                         %% 是否稀有
    }).

-record(treasure_hunt_state, {
    statistics_reward_map = #{},        %% 寻宝抽奖情况Map #{{htype, stype, obj_id} => #reward_status{}}
    statistics_times_map = #{},         %% 寻宝次数Map #{{htype, obj_id} => 次数}
    record_map = #{},                   %% 寻宝记录 #{{htype, 玩家id} => [#reward_record{}]} 玩家id为0存的是全服
    common_map = #{}                    %% 寻宝其他功能map，#{{role_id,htype} => #common_funcation{}}
    ,luckey_map = #{}                   %% 幸运值 htype => luckey_value
    ,old_luckey_map = #{}               %% 重置幸运值前的幸运值状态 htype => luckey_value
    ,protect_ref = undefined            %% 重置幸运值定时器,界面显示的幸运值有可能是假的。定时更新old_luckey_map
    ,luckey_val_ref = undefined         %% 幸运值更新定时器
    ,luckey_val_protect_ref = undefined %% 幸运值保护定时器，在该定时器生效时间内幸运值不重置，时间到了幸运值设置为0
    }).

-record(common_funcation, {             %% 有额外功能往这里添加
    free_times = 1,                     %% 免费次数
    next_free_time = 0                  %% 免费次数刷新时间戳
    }).

-record(rune_hunt, {
    turn = 1                            %% 轮次
    ,free_times = 0                     %% 免费次数
    ,free_flush_time = 0                %% 免费次数刷新时间戳。
    ,next_turn = 1                      %% 下一个轮次
    ,next_turn_flush_time = 0           %% 下个轮次刷新时间， 就是本轮次结束时间
    ,get_reward_list = []               %% 获得奖励状态 [{宝箱id, 领取状态}]   0:不可领取， 1：可领取， 2：已经领取
    ,luck_value = 0                     %% 幸运值
    ,statistics_reward_map = #{}        %% 寻宝抽奖情况Map #{{htype, stype, obj_id} => #reward_status{}}
    ,statistics_times_map = #{}         %% 寻宝次数Map #{{htype, obj_id} => 次数}
}).

-record(score_shop_cfg,{
    id = 0,                             
    lv = 0,                             %% 兑换等级限制
    score = 0,                          %% 寻宝积分消耗
    reward = [],                        %% 兑换物品[{Type, GoodsTypeId, Num}]
    rare = 0                            %% 0非稀有，1稀有
    }).

-record(luckey_value_state, {
        luckey_map = #{}                %% {ZoneId,Htype} => luckey_value
        ,old_luckey_map = #{}           %% {ZoneId,Htype} => luckey_value
        ,protect_ref = undefined        %% 旧幸运值同步定时器
        ,act_map = #{}                  %% Serverid => [{Htype, End_time}......]
        ,zone_map = #{}                 %% 分区map zone_id => [serverid:开服天数大于8天的服id...]
        ,timer_map = #{}                %% 定时器map   zone_id => ref
        ,server_info = []               %% 服务器信息 {ServerId, Optime, ServerNum, ServerName}
        ,record_map = #{}               %% 寻宝记录 #{{zoneid, htype} => [#kf_reward_record{}]} 玩家id为0存的是全服
        ,z2s_map = #{}
    }).

-record(kf_reward_record, {
        server_id = 0,                      %% 服务器id
        server_num = 0,                     %% 服数
        role_id = 0,                        %% 玩家id
        role_name = 0,                      %% 玩家名字
        htype = 0,                          %% 寻宝类型 具体参考：TREASURE_HUNT_TYPE
        gtype_id = 0,                       %% 物品类型id
        goods_num = 0,                      %% 物品数量
        time = 0,                           %% 时间
        is_rare = 0                         %% 是否稀有
    }).

-define(sql_select_player_treasure_hunt,
    <<"select score from player_treasure_hunt where role_id = ~p">>).

-define(sql_insert_player_treasure_hunt,
    <<"insert into player_treasure_hunt(role_id, score) values(~p, ~p)">>).

-define(sql_update_player_treasure_hunt,
    <<"update player_treasure_hunt set score = ~p where role_id = ~p">>).

-define(sql_select_treasure_hunt_reward,
    <<"select htype, stype, obj_id, obtain_times, last_draw_times from treasure_hunt_reward">>).

-define(sql_insert_treasure_hunt_reward,
    <<"replace into treasure_hunt_reward(htype, stype, obj_id, obtain_times, last_draw_times) values(~p, ~p, ~p, ~p, ~p)">>).

-define(sql_update_treasure_hunt_reward,
    <<"update treasure_hunt_reward set obtain_times = ~p, last_draw_times = ~p where htype = ~p and stype = ~p and obj_id = ~p">>).

-define(sql_delete_treasure_hunt_reward,
    <<"delete from treasure_hunt_reward where htype = ~p and stype = ~p and obj_id = ~p">>).

-define(sql_select_treasure_hunt_times,
    <<"select htype, obj_id, htimes from treasure_hunt_times">>).

-define(sql_insert_treasure_hunt_times,
    <<"insert into treasure_hunt_times(htype, obj_id, htimes) values(~p, ~p, ~p)">>).

-define(sql_update_treasure_hunt_times,
    <<"update treasure_hunt_times set htimes = ~p where htype = ~p and obj_id = ~p">>).

-define(sql_select_treasure_hunt_extra,
    <<"select role_id, htype, free_times, next_free_time from treasure_hunt_extra where role_id = ~p and htype = ~p">>).

-define(sql_replace_treasure_hunt_extra,
    <<"replace into treasure_hunt_extra(role_id, htype, free_times, next_free_time) values(~p, ~p, ~p, ~p)">>).

-define(sql_update_treasure_hunt_extra,
    <<"update treasure_hunt_extra set free_times = ~p, next_free_time = ~p where htype = ~p and role_id = ~p">>).

-define(sql_select_treasure_hunt_luckey_value,
    <<"select htype, luckey_value from treasure_hunt_luckey_value">>).

-define(sql_replace_treasure_hunt_luckey_value,
    <<"replace into treasure_hunt_luckey_value(htype, luckey_value) values(~p, ~p)">>).

-define(SQL_UPDATE_RUNE_HUNT_MSG_LUCKEY_VALUE,
    <<"replace into rune_hunt_msg(role_id, turn, free_times, free_flush_time, next_turn, next_turn_flush_time, get_reward_list, lucky_value) values (~p,~p,~p,~p,~p,~p,~p,~p)">>).

%% 跨服数据库
-define(SQL_SELECT_LUCKEY_VALUE,  <<"select zone_id, htype, luckey_value from treasure_hunt_luckey_value_kf">>).
-define(SQL_REPLACE_LUCKEY_VALUE, <<"replace into treasure_hunt_luckey_value_kf(zone_id, htype, luckey_value) values(~p, ~p, ~p)">>).


-define(TREASURE_HUNT_TYPE_TASK, [
    ?TREASURE_HUNT_TYPE_BABY
    ]).

%% 寻宝任务配置
-record(base_treasure_hunt_task, {
    htype = 0,                          %% 寻宝类型 具体参考：TREASURE_HUNT_TYPE
    id = 0,                          %% 任务id
    mod_id = 0,
    sub_mod = 0,
    rewards = 0,                        %% 奖励
    jump_id = 0,                    %% 跳转id
    num = 0                      %% 条件
    }).

-record(treasure_hunt_task, {
    htype = 0,                         
    task_list = [],
    time = 0
    }).

-record(task_info, {
    id = 0,                         
    num = 0,
    state = 0            %% 0不能领取 1可领取 2已领取
    }).
