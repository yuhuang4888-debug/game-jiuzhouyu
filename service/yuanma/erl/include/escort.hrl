
-record(base_escort_reward, {
        type = 0,           %% 矿车类型
        hp_min = 0,         %% 矿车剩余血量下限
        hp_max = 0,         %% 矿车剩余血量上限
        score = 0,          %% 公会水晶积分奖励
        guild_reward = [],  %% 公会奖励
        person_reward = []  %% 个人奖励
        ,escort_name = ""   %% 护送名字：普通/完美护送
        ,escort_type = 0    %% 护送类型
    }).

-record(base_escort_rob_reward, {
        type = 0,           %% 矿车类型
        kill_score = 0,     %% 击杀者奖励积分
        score = 0,          %% 公会水晶积分奖励
        guild_reward = [],  %% 公会奖励
        person_reward = []  %% 个人奖励
    }).

-record(base_escort_rank_reward, {
        rank_min = 0,       %% 排名下限就有
        rank_max = 0,       %% 排名上限
        guild_reward = [],  %% 公会奖励
        person_reward = []  %% 个人奖励
    }).

-record(base_escort_mon, {
        type = 0,           %% 水晶类型
        name = "",          %% 名字
        star = 0,           %% 星数
        cost = [],          %% 消耗
        scene = 0,          %% 场景
        monid = 0,          %% 怪物id
        x = 0,              %% 怪物复活点X坐标
        y = 0               %% 怪物复活点Y坐标
    }).


-record(kf_escort_state, {
        start_time = 0,         %% 开始时间
        end_time = 0,           %% 结束时间
        act_ref = undefined,    %% 活动定时器
        zone_map = #{},         %% 分区数据
        server_info = [],       %% {ServerId, Optime, WorldLv, ServerNum, ServerName} 服世界等级
        first_guild = #{},      %% 公会积分排行榜第一名 ZoneId => [{ServerId, ServerNum, GuildId, GuildName}]
        server_guild = #{}      %% 参加活动公会 zoneid => [{serverid, [{ServerNum, guildid, GuildName}...]}]
        ,score_rank = #{}       %% 积分排行榜 ZoneId => [{ServerId, ServerNum, GuildId, GuildName, Score}]
        ,role_rank = #{}        %% 公会内部积分排名 {ServerId, GuildId} -> [{Postion, name, RoleId, RobScore, EscortScore}]
        ,rob_map = #{}          %% 掠夺次数统计 {ServerId, RoleId} -> Times 掠夺次数（获得掠夺奖励）
        ,guild_mon = #{}        %% 公会怪物 {ServerId, GuildId} => {MonId, Montype, Res, Scene, x, y} 矿车类型 唯一id
        ,join_list = []         %% 参与统计 {{ZoneId, ServerId, GuildId}, Num}
        ,mon_hurt = #{}         %% 怪物伤害 ZoneId => [#mon_hurt_info{}]
        ,escort_map = #{}       %% 护送时长统计  monid => [{serverid, RoleId, Position, RoleName, time}]
        ,update_time = #{}      %% 更新护送时间间隔 ServerId => time
        ,move_time = #{}        %% 更新怪物坐标 ServerId => time
        ,custom_time_list = []  %% 定制活动开启时间段
    }).

-record(mon_hurt_info, {
        mon_id = 0,             %% 怪物自增id
        hurt_list = []          %% 伤害 {TemServerNum, TemServerId, GuildName, GuildId, Position, RoleId, RoleName, Hurt}       
    }).

-record(local_escort_state, {
        start_time = 0,         %% 开始时间
        end_time = 0,           %% 结束时间
        first_guild = {0,0,0,""},    %% 公会积分排行榜第一名 {ServerId, ServerNum, GuildId, GuildName}
        server_id_list = [],    %% 对战服务器id列表
        score_rank = []         %% 积分排行榜 [{ServerId, ServerNum, GuildId, GuildName, Score, Rank}]
        ,role_rank = #{}        %% 公会内部积分排名 {ServerId, GuildId} -> [{Postion, name, RoleId, RobScore, EscortScore}]
        ,guild_mon = #{}        %% 公会怪物 {ServerId, GuildId} => {MonId, Montype, Res, Scene, x, y} 矿车类型 唯一id
        ,join_list = []         %% 参与统计 {{ZoneId, ServerId, GuildId}, Num}
        ,escort_map = #{}       %% 护送时长统计  monid => [{serverid, RoleId, Position, RoleName, time}]
        ,guild_info = []        %% 公会信息数据 {ServerNum, guildid, GuildName}
        ,rob_map = #{}          %% 掠夺次数统计 {serverid,RoleId} -> Times 掠夺次数（获得掠夺奖励）
    }).


-define(NOT_ESCORT,     0).     %% 护送中
-define(HAS_ESCORT,     1).     %% 护送完毕

-define(NORMAL_ESCORT,  1).     %% 普通护送
-define(PERFECT_ESCORT, 2).     %% 完美护送

-define(RES_ESCORT,     1).     %% 护送中
-define(RES_FAIL,       2).     %% 失败
-define(RES_NORMAL,     3).     %% 普通护送
-define(RES_PERFECT,    4).     %% 完美护送

-define(UPDATE_TIME,        data_escort:get_escort_value(update_time)).             %% 更新护送时间间隔
-define(UP_POSITION_TIME,   data_escort:get_escort_value(update_position_time)).    %% 更新怪物坐标时间间隔

-define(SQL_SELECE_ESCORT,   <<"SELECT `zone`, `server_id`, `server_num`, `guild`, `guild_name` from `escort_guild_data`">>).
-define(SQL_REPLACE_ESCORT,  <<"REPLACE INTO `escort_guild_data` (`zone`, `server_id`, `server_num`, `guild`, `guild_name`) VALUES (~p, ~p, ~p, ~p, '~s')">>).
-define(SQL_DELETE_ESCORT,  <<"DELETE FROM `escort_guild_data` WHERE `zone` = ~p">>).
-define(SQL_TRUNCATE_ESCORT, <<"TRUNCATE TABLE `escort_guild_data`">>).