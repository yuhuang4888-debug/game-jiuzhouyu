-record(base_seacraft_rank_reward, {
        act_type = 0,           %% 活动类型
        min = 0,                %% 排名下限
        max = 0,                %% 排名上限
        reward = []             %% 奖励
}).

-record(base_seacraft_reward, {
        act_type = 0,           %% 活动类型
        success_reward = [],    %% 胜利奖励
        fail_reward = []        %% 失败奖励
        ,auction_reward = []    %% 拍卖产出
}).

-record(base_seacraft_daily_reward, {
        level = 0,              %% 职位id
        name = "",              %% 职位
        limit = 0,              %% 人数限制
        normal = [],            %% 每日奖励
        special = []            %% 霸主每日奖励
        ,dsgt_id = 0            %% 称号id
}).

-record(base_seacraft_win_reward, {
        min = 0,                %% 胜利次数下限
        max = 0,                %% 胜利次数上限
        reward = []             %% 霸主连胜奖励
}).

-record(base_seacraft_construction, {
        id = 0,                 %% 怪物id/建筑id
        scene = 0,              %% 场景id
        type = 0,               %% 怪物类型
        name = "",              %% 怪物名字
        x = 0,                  %% X坐标
        y = 0,                  %% Y坐标
        list = []               %% 死亡列表内的怪物才可被攻击[monid]
        ,is_be_att = 0          %% 复活后可被攻击0 需要被触发才能攻击1
        ,conlect_mon = 0        %% 死亡采集怪id
        ,areamark_id = 0        %% 动态障碍区id
        ,skill = 0              %% 技能
}).

-record(base_seacraft_scene, {  %% 复活点配置 
        scene = 0,              %% 场景id
        point = 0,              %% 复活点id
        x = 0,                  %% X坐标
        y = 0                   %% Y坐标      
}).

-record(base_seacraft_auction, {
        type = 0                %% 活动类型  
        ,wlv_min = 0            %% 世界等级下限
        ,wlv_max = 0            %% 世界等级上限
        ,win_gproduce = []      %% 获胜拍卖钻石产出
        ,win_gworth = 0         %% 获胜拍卖钻石产出价值
        ,win_bgproduce = []     %% 获胜拍卖绑钻产出
        ,win_bgworth = 0        %% 获胜拍卖绑钻产出价值
        ,fail_gproduce = []     %% 失败拍卖钻石产出
        ,fail_gworth = 0        %% 失败拍卖钻石产出价值
        ,fail_bgproduce = []    %% 失败拍卖绑钻产出
        ,fail_bgworth = 0       %% 失败拍卖绑钻产出价值
    }).

-record(base_sea_exploit, {
        military_id = 0,
        military_name = "",
        need_exploit = [0,0],
        attr = [],
        passive_skill = []
}).

-record(base_sea_privilege,{
        privilege_id = 0,
        privilege_name = "",
        un_privilege_name = "",
        privilege_desc = "",
        un_privilege_desc = "",
        need_job = [],
        duration = 0,
        day_times = 0
}).


-define(ATTACKER, 1).           %% 进攻方
-define(DEFENDER, 2).           %% 防守方

-define(ACT_TYPE_SEA_PART, 1).  %% 海域争夺
-define(ACT_TYPE_SEA,      2).  %% 海域争霸

-define(START_INIT, 1).         %% 开始初始化
-define(MERGE_END,  2).         %% 重新划分小跨服

-define(CAN_BE_ATT_REBORN, 0).  %% 可被攻击
-define(KILL_OTHER_BE_ATT, 1).  %% 击杀别的怪物后可被攻击

-define(SHIP_TYPE_BATTLESHIP,    1).   %% 战列舰
-define(SHIP_TYPE_CONSTRUCTION,  2).   %% 攻城舰

-define(SEA_MASTER,     1).     %% 海王
-define(SEA_COMMANDER,  2).     %% 统领
-define(SEA_MARSHAL,    3).     %% 元帅
-define(SEA_CONTROL,    4).     %% 指挥
-define(SEA_SOLDIER,    5).     %% 禁卫
-define(SEA_MEMBER,     6).     %% 平民

-define(PRIVILEGE_OPEN, 1). %% 特权开启
-define(PRIVILEGE_CLOSE,0). %% 特权关闭

-define(PRI_SEA_MUTED,  1).     %% 禁言状态
-define(PRI_SEA_RETREAT,2).     %% 封边状态

-define(UPDATE_TIME_LIMIT, data_seacraft:get_value(update_role_info_time)).   %% 更新成员信息时间间隔min
-define(SYNC_SIZE, 100).          %% 每次同步成员信息数组大小

-define(AUTO_JOIN_CAMP_LIMIT, 4).   %% 排名前4工会自动加入阵营

-define(NO_INIT,        0).     %% 游戏服进程未成功初始化（跨服中心数据未同步）
-define(IS_INIT,        1).     %% 初始化跨服进程数据已同步/压根不用同步

-record(join_member, { 
        server_id = 0,              %% 服务器id
        server_num = 0,             %% 服数
        guild_id = 0,               %% 公会id
        role_id = 0,                %% 玩家id
        role_name = "",             %% 玩家名字
        role_lv = 0,                %% 玩家等级
        combat_power = 0,           %% 玩家战力
        picture = "",               %% 玩家头像
        picture_ver = 0,            %% 头像版本
        camp = 0                    %% 玩家阵营
    }).

-record(sea_guild, {
        server_id = 0,              %% 服务器id
        server_num = 0,             %% 服数
        guild_id = 0,               %% 公会id
        guild_name = "",            %% 公会名
        guild_power = 0,            %% 公会战力
        role_id = 0,                %% 会长id
        role_name = "",             %% 会长名字
        member_num = 0,             %% 公会总人数
        role_lv = 0,                %% 会长等级
        combat_power = 0,           %% 会长战力
        picture = "",               %% 玩家头像
        picture_ver = 0             %% 玩家头像版本
    }).

-record(sea_job, {
        server_id = 0,              %% 服务器id
        server_num = 0,             %% 服数
        role_id = 0,                %% 玩家id
        role_name = "",             %% 名字
        role_lv = 0,                %% 等级
        job_id = 0,                 %% 职位id
        combat_power = 0,           %% 战力
        picture = "",               %% 玩家头像
        picture_ver = 0             %% 玩家头像版本
    }).

-record(sea_apply, {
        server_id = 0,              %% 服务器id
        server_num = 0,             %% 服数
        role_id = 0,                %% 玩家id
        role_name = "",             %% 名字
        role_lv = 0,                %% 等级
        combat_power = 0,           %% 战力
        picture = "",               %% 玩家头像
        picture_ver = 0             %% 头像版本号
    }).

-record(sea_score, {
        server_id = 0,              %% 服务器id
        server_num = 0,             %% 服数
        role_id = 0,                %% 玩家id
        role_name = "",             %% 名字
        kill_num = 0,               %% 击杀数量
        score = 0,                  %% 个人总积分
        time = 0                    %% 时间
    }).

-record(kf_seacraft_state, {
        zone_map = #{}              %% 服务器分区 zone => [server_id, ...]
        ,server_info = []           %% 服务器信息 {ServerId, Optime, WorldLv, ServerNum, ServerName}
        ,guild_camp = #{}           %% 工会阵营 serverid => [{guildid, camp}]
        ,camp_map = #{}             %% 阵营势力 {zone, camp} => #camp_info{}
        ,zone_data = #{}            %% 区数据 zone => #zone_data{}
        ,start_time = 0             %% 开启时间
        ,end_time = 0               %% 结束时间
        ,act_ref = undefined        %% 活动开启关闭计时器
        ,join_map = #{}             %% {serverid, guild} => [#join_member{}]
        ,update_time = #{}          %% zone => time 更新时间戳
        ,act_info = #{}             %% zone => {活动类型:1海域之王争夺/2海域霸主争夺, 次数, 赛季重置标识 0/1已重置}
        % ,act_type = {0, 0}          %% {活动类型:1海域之王争夺/2海域霸主争夺, 次数}
        % ,is_reset = 0                %% 赛季重置标识 0  1已重置
}).

-record(camp_info, {
        guild_map = #{}         %% 阵营公会 serverid => [#sea_guild{}]
        ,job_list = []          %% 官员 [#sea_job{}]
        ,application_list = []  %% 申请加入禁军列表 [#sea_apply{}]
        ,join_limit = {0,0,0}   %% 申请限制{role_lv, power, auto}
        ,camp_master = [{0,0}]  %% 海王公会 [{serverid, guild_id}]
        ,score_list = []        %% 公会积分数据 [{serverid, guild_id, score}, ...]
        ,role_score_map = #{}   %% 公会内部积分排名 {serverid, guild_id} => [#sea_score{},...]
        ,camp_mon = []          %% 海域争夺 怪物信息 [{mon_id, hp, hp_max, can_be_att, next_mon}]
        ,att_def = []           %% 攻守方信息 [{?ATTACKER, [{serverid, guild_id}...]}, {?DEFENDER, {serverid, guild_id}]
        ,hurt_list = []         %% 神像伤害统计 [{guild, hurt}]
        ,divide_point = []      %% 复活点分配[{GuildId, PonitId}...]
        ,win_reward = []        %% 连胜奖励分配 [{Num, {serverid, roleid}}]
        ,collect_mon = []       %% 采集怪 [{monid, is_alive}]
        ,member_list = []       %% [#camp_member_info{}|_]
        ,privilege_status = []  %% [#privilege_item{}|_]
}).

-record(zone_data, {
        sea_master = {0, 0}     %% 海域霸主 {camp, times(连胜次数)}
        ,sea_mon = []           %% 海域争霸 [{mon_id, hp, hp_max, can_be_att, next_mon}]
        ,att_def = []           %% 攻守方信息 [{?ATTACKER, [camp...]}, {?DEFENDER, camp}]
        ,score_list = []        %% 霸主战总积分排名 [{camp, score}, ...]
        ,hurt_list = []         %% 神像伤害统计 [{cmap, hurt}]
        ,role_score_map = #{}   %% camp => [{serverid, server_num, role_id, role_name, kill_num, score},...]
        ,divide_point = []      %% 复活点分配[{camp, PonitId}...]
        ,collect_mon = []       %% 采集怪 [{monid, is_alive}]
}).

-record(local_seacraft_state, {
        init_ref = undefined
        ,is_init = ?NO_INIT
        ,local_camp = #{}           %% camp => #camp_info{}
        ,start_time = 0             %% 开启时间
        ,end_time = 0               %% 结束时间
        ,act_type = {0, 0}          %% {活动类型:1海域之王争夺/2海域霸主争夺, 次数}
        ,local_zone = #{}           %% #zone_data
        ,update_time = 0            %% 更新时间戳
        ,role_info = #{}            %% camp => {role_id, role_name, role_lv, power, picture}
        ,role_group = []            %% 玩家切换战舰记录  {role, group, time}
        ,next_act_time = []         %% 下次活动时间 [{ActType, StartTime, EndTime}]
        ,wlv = 0                    %% 小跨服平均世界等级
        ,day_job = []               %% role_id, old_job_id
        ,upd_ref = undefined        %% 更新member_info定时器
        ,change_info = #{}          %% camp => {[{vip, role_id, role_name, lv, exploit, combat}|_], [#camp_member_info{}|_], [退出工会的role_id|_]}
        ,brick_num_map = #{}        %% #{camp => Num}
}).

-record(camp_member_info, {
        server_id = 0,                  %% 服务器id
        guild_id = 0,                   %% 工会id
        guild_name = [],                %% 工会名
        vip = 0,                        %% vip
        role_id = 0,                    %% 角色Id
        role_name = [],                 %% 角色名
        lv = 0,                         %% 等级
        job_id = 6,                     %% 职位
        exploit = 0,                    %% 功勋
        fright = 0                      %% 战力
}).

-record(privilege_item, {
        privilege_id = 0,               %% 特权Id
        times = 0,                      %% 剩余次数
        status = 0,                     %% 状态
        end_time = 0,                   %% 结束时间
        ref = undefined                 %% 结束定时器
}).



-define(SELECT_SEA_GUILD,   <<"SELECT `zone`, `camp`, `server_id`, `server_num`, `guild_id`, `guild_name`, 
            `guild_power`, `role_id`, `role_name`, `num`, `role_lv`, `power`, `picture`, `picture_ver` FROM `seacraft_guild`">>).
-define(REPLACE_SEA_GUILD,  <<"REPLACE INTO `seacraft_guild`(`zone`, `camp`, `server_id`, `server_num`, `guild_id`, `guild_name`, 
            `guild_power`, `role_id`, `role_name`, `num`, `role_lv`, `power`, `picture`, `picture_ver`) VALUES (~p,~p,~p,~p,~p,'~s',~p,~p,'~s',~p,~p,~p,'~s',~p)">>).
-define(DELETE_SEA_GUILD,   <<"DELETE FROM `seacraft_guild` where `guild_id` = ~p">>).
-define(DELETE_SEA_GUILD_CAMP, <<"DELETE FROM `seacraft_guild` where `zone` = ~p and `camp` = ~p">>).
-define(DELETE_SEA_GUILD_ZONE, <<"DELETE FROM `seacraft_guild` where `zone` = ~p">>).
-define(TRUNCATE_SEA_GUILD, <<"TRUNCATE TABLE `seacraft_guild`">>).

-define(SELECT_SEA_CAMP,    <<"SELECT `zone`, `camp`, `join_limit`, `master`, `win_reward` FROM `seacraft_camp`">>).
-define(REPLACE_SEA_CAMP,   <<"REPLACE INTO `seacraft_camp`(`zone`, `camp`, `join_limit`, `master`, `win_reward`) VALUES (~p,~p,'~s','~s','~s')">>).
-define(DELETE_SEA_CAMP,   <<"DELETE FROM `seacraft_camp` where `zone` = ~p and `camp` = ~p">>).
-define(DELETE_SEA_CAMP_ZONE,   <<"DELETE FROM `seacraft_camp` where `zone` = ~p">>).
-define(TRUNCATE_SEA_CAMP,  <<"TRUNCATE TABLE `seacraft_camp`">>).

-define(SELECT_SEA_JOB,     <<"SELECT `zone`, `camp`,`server_id`, `server_num`, `role_power`, 
                `role_id`, `role_name`, `role_lv`, `job_id`, `picture`, `picture_ver` FROM `seacraft_job`">>).
-define(REPLACE_SEA_JOB,    <<"REPLACE INTO `seacraft_job`(`zone`, `camp`,`server_id`, `server_num`, `role_power`, 
                `role_id`, `role_name`, `role_lv`, `job_id`, `picture`, `picture_ver`) VALUES (~p,~p,~p,~p,~p,~p,'~s',~p,~p,'~s',~p)">>).
-define(DELETE_SEA_JOB_ROLE,   <<"DELETE FROM `seacraft_job` where `role_id` = ~p">>).
-define(DELETE_SEA_JOB,   <<"DELETE FROM `seacraft_job` where `zone` = ~p and `camp` = ~p">>).
-define(DELETE_SEA_JOB_ZONE,   <<"DELETE FROM `seacraft_job` where `zone` = ~p">>).
-define(TRUNCATE_SEA_JOB,   <<"TRUNCATE TABLE `seacraft_job`">>).

-define(SELECT_SEA_APPLY,   <<"SELECT `zone`, `camp`, `server_id`, `server_num`, `role_power`, `role_id`, 
                `role_name`, `role_lv`, `picture`, `picture_ver` FROM `seacraft_apply`">>).
-define(REPLACE_SEA_APPLY,  <<"REPLACE INTO `seacraft_apply`(`zone`, `camp`, `server_id`, `server_num`, `role_power`, `role_id`, 
                `role_name`, `role_lv`, `picture`, `picture_ver`) VALUES (~p,~p,~p,~p,~p,~p,'~s',~p,'~s', ~p)">>).
-define(DELETE_SEA_APPY,    <<"DELETE FROM `seacraft_apply` WHERE `role_id` = ~p">>).
-define(DELETE_SEA_APPY_CAMP, <<"DELETE FROM `seacraft_apply` where `zone` = ~p and `camp` = ~p">>).
-define(DELETE_SEA_APPY_ZONE, <<"DELETE FROM `seacraft_apply` where `zone` = ~p">>).
-define(TRUNCATE_SEA_APPLY, <<"TRUNCATE TABLE `seacraft_apply`">>).

-define(SELECT_SEA_INFO,    <<"SELECT `zone`, `camp`, `times` FROM `seacraft_sea_master`">>).
-define(REPLACE_SEA_INFO,   <<"REPLACE INTO `seacraft_sea_master`(`zone`, `camp`, `times`) VALUES (~p,~p,~p)">>).
-define(DELETE_SEA_INFO,   <<"DELETE FROM `seacraft_sea_master` where `zone` = ~p and `camp` = ~p">>).
-define(DELETE_SEA_INFO_ZONE, <<"DELETE FROM `seacraft_sea_master` where `zone` = ~p">>).
-define(TRUNCATE_SEA_INFO,  <<"TRUNCATE TABLE `seacraft_sea_master`">>).

-define(SELECT_SEA_ACT,     <<"SELECT `id`, `act_type`, `times`, `is_rest` FROM `seacraft_act`">>).
-define(REPLACE_SEA_ACT,    <<"REPLACE INTO `seacraft_act`(`id`, `act_type`, `times`, `is_rest`) VALUES (~p,~p,~p,~p)">>).
-define(UPDATE_SEA_ACT,     <<"update seacraft_act set is_rest= ~p where id= ~p">>).
-define(TRUNCATE_SEA_ACT,   <<"TRUNCATE TABLE `seacraft_act`">>).

-define(SELECT_DAILY_JOB,   <<"SELECT `role_id`, `job_id` FROM `seacraft_daliy_reward`">>).
-define(REPLACE_DAILY_JOB,  <<"REPLACE INTO `seacraft_daliy_reward`(`role_id`, `job_id`) VALUES (~p, ~p)">>).
-define(TRUNCATE_DAILY_JOB, <<"TRUNCATE TABLE `seacraft_daliy_reward`">>).

-define(SELECT_SEA_MEMBER_INFO, <<"select `vip`, `role_id`, `role_name`, `lv`, `job_id`, `exploit`,
 `combat_power` from `seacraft_member_info` where `zone` = ~p and `server_id` = ~p and `guild_id` = ~p">>).
-define(DELETE_SEA_MEMBER_INFO, <<"delete from `seacraft_member_info` where `zone` = ~p and `server_id` = ~p and `guild_id` = ~p">>).
-define(DELETE_SEA_MEMBER_ZONE, <<"delete from `seacraft_member_info` where `zone` = ~p">>).
-define(DELETE_SEA_MEMBER_ZONE_SERVER, <<"delete from `seacraft_member_info` where `zone` = ~p and `server_id` = ~p">>).
-define(TRUNCATE_SEA_MEMBER_INFO, <<"TRUNCATE TABLE `seacraft_member_info`">>).
-define(REPLACE_SEA_MEMBER_INFO, <<"replace into `seacraft_member_info` (`zone`,`camp`,`server_id`,`guild_id`,`vip`,
`role_id`, `role_name`, `lv`, `job_id`, `exploit`, `combat_power`) values (~p,~p,~p,~p,~p,~p,'~s',~p,~p,~p,~p)">>).
-define(DELETE_SEA_MEMBER_ROLEID, <<"delete from `seacraft_member_info` where `role_id` = ~p">>).

-define(SELECT_PRIVILEGE_STATUS, <<"select `privilege_id`,`times`,`status`,`end_time` from `seacraft_camp_privilege`
    where `zone`=~p and `camp` = ~p">>).
-define(REPLACE_PRIVILEGE_ITEM, <<"replace into `seacraft_camp_privilege` (`zone`,`camp`,`privilege_id`,
    `times`,`status`,`end_time`) values (~p,~p,~p,~p,~p,~p)">>).

-define(SELECT_ROLE_EXPLOIT, <<"select `exploit` from `role_sea_exploit` where `role_id` = ~p">>).
-define(REPLACE_ROLE_EXPLOIT,<<"replace into `role_sea_exploit` (`role_id`, `exploit`) values (~p, ~p)">>).

-define(SELECT_LOCAL_CHANGEINFO, <<"select `camp`, `vip`, `role_id`, `role_name`, `lv`, `exploit`, `combat_power` from `seacraft_local_change`">>).
-define(TRUNCATE_LOCAL_CHANGEINFO, <<"truncate table `seacraft_local_change`">>).
-define(REPLACE_LOCAL_CHANGEINFO, <<"replace into `seacraft_local_change` (`camp`, `vip`, `role_id`, `role_name`, `lv`, `exploit`, `combat_power`) values (~p,~p,~p,'~s', ~p,~p,~p)">>).

-define(SELECT_LOCAL_JOIN, <<"select `camp`, `server_id`, `guild_id`, `guild_name`, `vip`, `role_id`, `role_name`, `lv`, `job_id`, `exploit`, `combat_power` from `seacraft_local_join`">>).
-define(TRUNCATE_LOCAL_JOIN, <<"truncate table `seacraft_local_join`">>).
-define(REPLACE_LOCAL_JOIN, <<"replace into `seacraft_local_join` (`camp`, `server_id`, `guild_id`, `guild_name`, `vip`, `role_id`, `role_name`, `lv`, `job_id`, `exploit`, `combat_power`)
    values (~p,~p,~p,'~s', ~p,~p,'~s',~p,~p,~p,~p)">>).
-define(DELETE_LOCAL_JOIN, <<"delete from `seacraft_local_join` where `role_id` = ~p">>).

-define(SELECT_LOCAL_QUIT, <<"select `camp`, `role_id` from `seacraft_local_quit`">>).
-define(TRUNCATE_LOCAL_QUIT, <<"truncate table `seacraft_local_quit`">>).
-define(REPLACE_LOCAL_QUIT, <<"replace into `seacraft_local_quit` (`camp`, `role_id`) values (~p,~p)">>).
-define(DELETE_LOCAL_QUIT, <<"delete from `seacraft_local_quit` where `role_id` = ~p">>).