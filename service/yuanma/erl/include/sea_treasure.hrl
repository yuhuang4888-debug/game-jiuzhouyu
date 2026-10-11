%%-----------------------------------------------------------------------------
%% @Author  :       xlh
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）头文件
%%-----------------------------------------------------------------------------


%% -------------------------- 记录 --------------------------
-record(base_sea_treasure_mod, {
        id = 0              %% 模式id
        ,ser_num = 0        %% 服数
        ,name = ""          %% 模式名字
        ,day_min = 0        %% 开服天数下限
        ,day_max = 0        %% 开服天数上限
        ,wlv_min = 0        %% 世界等级下限
        ,wlv_max = 0        %% 世界等级上限
    }).

-record(base_sea_treasure_reward, {
        id = 0              %% 档次id
        ,name = ""          %% 模式名字
        ,need_time = 0      %% 巡航持续时间
        ,reward = 0         %% 巡航奖励
        ,rob_reward = 0     %% 掠夺奖励
        ,exp_ratio = 0      %% 经验系数
        ,value = 0          %% 升档所需幸运值
        ,cost = []          %% 升档消耗
        ,add_value = 0      %% 升级增加幸运值
        ,ratio = 0          %% 升级概率（万分比）
    }).

-record(base_sea_treasure_robot, {
        lv_min = 0,         %% 世界等级下限
        lv_max = 0,         %% 世界等级上限
        power_range = [],   %% 战力范围
        rmount = [],        %% 坐骑资源
        attr_value = [],    %% 属性系数
        skill = [],         %% 技能列表
        rfly = [],          %% 翅膀资源
        rweapon = []        %% 武器资源
        ,rfashion = []      %% 时装资源
    }).

-record(shipping_info, {
        id = 0                  %% 船只id
        ,auto_id = 0            %% 船只唯一id
        ,ser_id = 0             %% 服id       机器人为对战服务器中随机
        ,ser_num = 0            %% 服数       机器人为对战服务器中随机
        ,guild_id = 0           %% 公会id     机器人为0
        ,guild_name = <<"">>    %% 公会名     机器人为空
        ,role_id = 0            %% 玩家id     机器人为0
        ,role_name = <<"">>     %% 玩家名
        ,role_lv = 0            %% 玩家等级
        ,power = 0              %% 玩家战力
        ,career = 0             %% 职业
        ,sex = 0                %% 性别
        ,turn = 0               %% 转生
        ,pic = ""               %% 头像
        ,pic_ver = 0            %% 头像版本号
        ,end_time = 0           %% 结束时间
        ,rob_times = 0          %% 被掠夺次数 0可掠夺/1正在被掠夺/2已被掠夺
        ,has_recieve = 0        %% 0未完成/1已完成未领取/2已领取
        ,end_ref = undefined    %% 结束定时器
        ,wlv = 0                %% 创建机器人时的世界等级
    }).

-record(treasure_log, {
        id = 0                  %% 船只档次id
        ,auto_id = 0            %% 船只唯一id
        ,role_id = 0            %% 玩家id
        ,type = 0               %% 0掠夺1被掠夺2正常结束
        ,rober_serid = 0        %% （被）掠夺服id
        ,rober_sernum = 0       %% （被）掠夺服数
        ,rober_gid = 0          %% 掠夺者公会id
        ,rober_gname = <<"">>   %% 掠夺者公会名
        ,rober_id = 0           %% （被）掠夺玩家id
        ,rober_name = <<"">>    %% （被）掠夺玩家名
        ,rober_power = 0        %% （被）掠夺玩家战力
        ,reward = []            %% (被)掠夺奖励
        ,rober_hp = 0           %% 上次追回奖励掠夺者血量百分比 0-100
        ,back_reward = []       %% 已追回奖励
        ,recieve_reward = []    %% 可领取追回奖励
        ,back_times = 0         %% 挑战次数
        ,time = 0               %% （被）掠夺/结束时间
        ,rback_status = 0       %% 复仇战斗状态
    }).

-record(role_shipping_info, {
        guild_id = null             %% 公会id
        ,guild_name = null          %% 公会名
        ,role_id = null             %% 玩家id
        ,role_name = null           %% 玩家名
        ,power = null               %% 玩家战力
        ,role_lv = null             %% 玩家等级
    }).

-record(battle_field_args,{
        be_help_id = 0,             %% 求助玩家id/掠夺时为0
        shipping_type = 0           %% 船只档次id
        ,auto_id = 0                %% 船只唯一id
        ,battle_type = 0            %% 战斗类型 1 掠夺战 2 复仇/协助
        ,role_hp_per = 0            %% 掠夺者/协助者/复仇方血量百分比
        ,fake_guild = {0, <<"">>}   %% 镜像公会数据{公会id,公会名}
        ,quit_time = 0              %% 离开时间
        ,fake_info = undefined      %% 假人/镜像数据
    }).

-record(fake_info, {
        ser_id = 0,                 %% 镜像/假人服id
        ser_num = 0,                %% 镜像/假人服数
        role_id = 0,                %% 镜像玩家id / 假人id为0
        role_name = <<"">>,         %% 镜像/假人名
        power = 0,                  %% 镜像/假人战力
        sex = 0,                    %% 镜像/假人性别
        career = 0,                 %% 镜像/假人职业
        turn = 0,                   %% 镜像/假人转生
        pic = ""                    %% 头像
        ,pic_ver = 0                %% 头像版本号
        ,hp_per = 0                 %% 假人/镜像剩余血量百分比
    }).

-record(role_info, {
        ser_id = 0,                 %% 服id
        ser_num = 0,                %% 服数
        role_id = 0,                %% 玩家id
        role_name = <<"">>,         %% 玩家名
        power = 0,                  %% 战力
        pic = ""                    %% 头像
        ,pic_ver = 0                %% 头像版本号
        ,hp_per = 0                 %% 剩余血量百分比
    }).


%% 玩家未领取不能开启下一次巡航，领取后将玩家本次#shipping_info删除，同一时间本服的[#shipping_info]最多只存在一个玩家一条数据
%% 假人的玩家id为0
-record(sea_treasure_local, {
        treasure_mod = 0        %% 当前模式
        ,shipping_map = #{}     %% 当前模式所有巡航船只数据 ServerId => [#shipping_info]
        ,log_map = #{}          %% 巡航日志 role_id => [#treasure_log]
        ,battle_list = []       %% 对战列表 [serid, ...]
        ,unsatisfy_mod = 0      %% 开服天数满足世界等级不满足的模式
        ,unsatisfy_list = []    %% 初始分配不满足世界等级的对战列表
        ,server_info = []       %% 服务器信息
        ,update_role = []       %% [#role_shipping_info]
        ,update_ref = undefined %% 上次更新时间
        ,is_init = 0            %% 是否从跨服中心更新过对战数据
        ,wlv = 0                %% 平均世界等级
        ,init_ref = undefined   %% 更新定时器
        ,battle_field = #{}     %% 战场pid  role_id(发起协助者的玩家id) => [{BattleRoleId, pid()}] 战场进程（本服）
        ,robot_ref = undefined  %% 假人创建定时器
        ,rback_map = #{}        %% 协助成功记录 auto_id => [{role_id, DeleteHpPer}]
        ,belog_map = #{}        %% RoberSerId => {AutoId, RoleId, ServerId, RoberId} 掠夺记录所有需要更新的玩家数据
        ,belog_list = []        %% [{AutoId, RoleId, ServerId, RoberId}] 其他服的记录
        ,need_up_role = []      %% 需要同步的玩家id列表
    }).


-record(sea_treasure_kf, {
        zone_map = #{}          %% 分区数据
        ,server_info = []       %% 服务器信息
        ,battle_map = #{}       %% 对战信息 zoneid => [{Type, [[1,2],[3,4]]},...]
        ,unsatisfy_map = #{}    %% 不满足世界等级初始分配服信息 zoneid => [{Type, [[1,2],[3,4]]},...]
        ,shipping_map = #{}     %% 巡航数据 serverid => [#shipping_info]
        ,battle_field = #{}     %% 战场pid  role_id(发起协助者的玩家id) => [{BattleRoleId, pid()}] 战场进程
        ,robot_ref = undefined  %% 假人创建定时器
        ,kf_belog_map = #{}     %% RoberSerId => {AutoId, RoleId, ServerId, RoberId} 掠夺记录所有需要更新的玩家数据
        ,connect_server = []    %% 连接跨服的服务器id列表
    }).



%% -------------------------- 常量 --------------------------
-define(UNACHIEVE_SHIPPING_REWARD,  0).     %% 未完成
-define(ACHIEVE_SHIPPING_REWARD,    1).     %% 已完成未领取巡航奖励
-define(RECIEVE_SHIPPING_REWARD,    2).     %% 已领取

-define(SEND_DATA_LENGTH,   30).   %% 一次更新30条数据到跨服中心

-define(BATTLE_TYPE_ROBER,  1).     %% 掠夺战
-define(BATTLE_TYPE_RBACK,  2).     %% 复仇战

-define(CAN_ROB,        0).     %% 可掠夺
-define(BE_ROBBING,     1).     %% 正被掠夺
-define(CANT_ROB,       2).     %% 被掠夺过

%% 复仇战斗状态
-define(RBACK_PEACE,    0).     % 和平(无战斗)
-define(RBACK_BATTLE,   1).     % 战斗中

-define(DAILY_TREASURE_TIMES, 1).   %% 每日巡航次数
-define(DAILY_ROB_TIMES, 2).        %% 每日掠夺次数
-define(DAILY_SHIPPING_UP, 3).      %% 每日免费升级船只次数
-define(DAILY_BGOLD_NUM, 4).        %% 每日获取绑钻数量统计
-define(DAILY_UP_LUCKEY_VALUE, 5).  %% 每日当前档次幸运值
-define(DAILY_SHIPPING_LEVEL, 6).   %% 每日船只档次



%% -------------------------- 配置获取 --------------------------
-define(born_point_list, data_sea_treasure:get_sea_treasure_value(born_point_list)).%% 出生点坐标
-define(cluster_mod_battle_scene, data_sea_treasure:get_sea_treasure_value(cluster_mod_battle_scene)).%% 跨服战斗场景
-define(day_reward_times, data_sea_treasure:get_sea_treasure_value(day_reward_times)). %%每日基础巡航次数
-define(day_rob_reward_times, data_sea_treasure:get_sea_treasure_value(day_rob_reward_times)). %% 每日基础掠夺次数
-define(day_up_reward_times_base, data_sea_treasure:get_sea_treasure_value(day_up_reward_times_base)). %%每日基础升档奖励免费次数
-define(local_battle_scene, data_sea_treasure:get_sea_treasure_value(local_battle_scene)). %% 本服战斗场景
-define(one_server_mod, data_sea_treasure:get_sea_treasure_value(one_server_mod)). %% 单服模式
-define(revenge_rober_attr, data_sea_treasure:get_sea_treasure_value(revenge_rober_attr)). %% 复仇时掠夺者属性削减
-define(rob_time,   data_sea_treasure:get_sea_treasure_value(rob_time)).     %% 掠夺战斗时间
-define(robort_min_lv, data_sea_treasure:get_sea_treasure_value(robort_min_lv)). %% 假人最低等级=世界等级-该值
-define(before_start_time, data_sea_treasure:get_sea_treasure_value(before_start_time)).%% 切场景完成后多久开始战斗
-define(cant_rob_before_end, data_sea_treasure:get_sea_treasure_value(cant_rob_before_end)). %% 巡航结束前多少秒不能进行掠夺
-define(back_reward_with_hp, data_sea_treasure:get_sea_treasure_value(back_reward_with_hp)). %% 掠夺者剩余血量与夺回奖励关系
-define(back_reward_max_bgold_num, data_sea_treasure:get_sea_treasure_value(back_reward_max_bgold_num)). %% 每日协助获得最大绑钻数量
-define(update_role_info_time, data_sea_treasure:get_sea_treasure_value(update_role_info_time)). %% 更新玩家数据到跨服时间间隔
-define(one_step_max_ship_cost, data_sea_treasure:get_sea_treasure_value(one_step_max_ship_cost)). %% 一键神船消耗
-define(robot_num, data_sea_treasure:get_sea_treasure_value(robot_num)). %% 假人创建数量与模式关系
-define(robot_refresh, data_sea_treasure:get_sea_treasure_value(robot_refresh)). %% 假人创建刷新时间点
-define(robot_shipping_id, data_sea_treasure:get_sea_treasure_value(robot_shipping_id)). %% 假人创建船只档次随机列表
-define(treasure_log_length, data_sea_treasure:get_sea_treasure_value(treasure_log_length)). %% 个人记录长度
-define(open_lv, data_sea_treasure:get_sea_treasure_value(open_lv)). %% 开启等级



%% -------------------------- sql --------------------------
%% sea_auto_id 表sql
-define(sql_auto_id_replace, <<"replace into `sea_auto_id` (`ser_id`, `value`)values(~p, ~p)">>).


%% sea_treasure_log 表sql
-define(sql_select_treasure_log, <<"SELECT `auto_id`, `id`, `role_id`, `ser_id`, `ser_num`,
    `rober_gid`, `rober_gname`,`rober_id`, `rober_name`, `rober_power`, `rober_hp`, `type`, `reward`,
    `back_reward`, `recieve_reward`, `back_times`, `time` FROM `sea_treasure_log`">>).
-define(sql_insert_treasure_log, <<"INSERT INTO `sea_treasure_log` (`auto_id`, `id`, `role_id`, `ser_id`,
    `ser_num`, `rober_gid`, `rober_gname`, `rober_id`, `rober_name`, `rober_power`, `rober_hp`, `type`, `reward`, `back_reward`,
    `recieve_reward`, `back_times`, `time`) values (~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p, '~s', ~p, ~p, ~p, '~s', '~s', ~p, ~p)">>).
-define(sql_update_treasure_log, <<"UPDATE `sea_treasure_log` SET `rober_hp` = ~p, `recieve_reward` = '~s',
    `back_reward` = '~s', `back_times` = ~p WHERE `auto_id` = ~p">>).
-define(sql_update_treasure_log_role, <<"UPDATE `sea_treasure_log` SET `rober_gid` = ~p,
        `rober_gname` = '~s', `rober_name` = '~s', `rober_power` = ~p WHERE `auto_id` = ~p">>).
-define(sql_delete_treasure_log, <<"DELETE FROM `sea_treasure_log` WHERE `auto_id` = ~p">>).


%% sea_treasure_shipping 表sql
-define(sql_select_treasure_shipping, <<"SELECT `auto_id`, `id`, `role_id`, `role_name`, `guild_id`, `guild_name`, `role_lv`, `power`,
    `career`, `sex`, `turn`, `pic`, `pic_ver`, `rob_times`, `has_recieve`, `end_time`, `wlv` FROM `sea_treasure_shipping`">>).
-define(sql_insert_treasure_shipping, <<"INSERT INTO `sea_treasure_shipping` (`auto_id`, `id`, `role_id`, `role_name`, `guild_id`,
    `guild_name`, `role_lv`, `power`, `career`, `sex`, `turn`, `pic`, `pic_ver`,`rob_times`, `has_recieve`, `end_time`, `wlv`) values
    (~p, ~p, ~p, '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_update_shipping_role_robtimes, <<"UPDATE `sea_treasure_shipping` SET `rob_times` = ~p WHERE `auto_id` = ~p">>).
-define(sql_update_shipping_role_recieve, <<"UPDATE `sea_treasure_shipping` SET `has_recieve` = ~p WHERE `auto_id` = ~p">>).
-define(sql_delete_treasure_shipping, <<"DELETE FROM `sea_treasure_shipping` WHERE `auto_id` = ~p">>).


%% sea_treasure_rback 表sql
-define(sql_select_treasure_rback, <<"SELECT `auto_id`, `role_id`, `hp_per` FROM `sea_treasure_rback`">>).
-define(sql_insert_treasure_rback, <<"REPLACE INTO `sea_treasure_rback` (`auto_id`, `role_id`, `hp_per`) values (~p, ~p, ~p)">>).
-define(sql_delete_treasure_rback, <<"DELETE FROM `sea_treasure_rback` WHERE `auto_id` = ~p">>).
