-- 2022/4/29 19:07:48 -- 

alter table log_role_retain MODIFY `source` varchar(100) NOT NULL COMMENT '渠道标识';

CREATE TABLE IF NOT EXISTS `task_bag_content_clear` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
    `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务id',
    `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务类型（方便清理）',
    `stage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务阶段',
    `cid` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '内容id',
    `ctype` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务内容类型',
    `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '配置id',
    `need_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '完成所需数量',
    `desc` varchar(500) NOT NULL DEFAULT '0' COMMENT '文字描述',
    `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景id',
    `x` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景坐标x',
    `y` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景坐标y',
    `path_find` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否需要寻路',
    `display_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '显示完成数量，0显示need_num',
    `is_guide` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否需要引导',
    `fin` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否已经完成',
    `now_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '当前数量',
    PRIMARY KEY (`role_id`,`task_id`,`stage`,`cid`),
    KEY `task_id` (`task_id`,`stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色日清任务列表(合服合并)';

CREATE TABLE IF NOT EXISTS `task_bag_clear` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
    `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务id',
    `trigger_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '触发时间',
    `stage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '当前阶段',
    `edstage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '结束阶段',
    `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '任务类型',
    `lv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务等级',
    PRIMARY KEY (`role_id`,`task_id`),
    KEY `task_id` (`task_id`),
    KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色日清任务列表(合服合并)';

insert into `task_bag_clear`(`role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv`) 
    select `role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv` from `task_bag` where `type` in (6,7,8,9);

insert into `task_bag_content_clear`(`role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`,
 `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num`) 
    select `role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`,
 `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num` from `task_bag_content` where `type` in (6,7,8,9);


delete from `task_bag` where `type` in (6,7,8,9);

delete from `task_bag_content` where `type` in (6,7,8,9);
CREATE TABLE IF NOT EXISTS `role_wx_subscribe` (
  `role_id` bigint unsigned NOT NULL COMMENT '玩家Id', 
  `temp_id` int(11) unsigned NOT NULL COMMENT '订阅模板id',
  `utime` bigint unsigned NOT NULL COMMENT '订阅时间', 
  PRIMARY KEY(`role_id`, `temp_id`)  
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信订阅推送';

ALTER TABLE `role_wx_subscribe` ADD COLUMN `sh_uid` int(11) unsigned NOT NULL COMMENT '深海uid' AFTER `role_id`;
ALTER TABLE `role_wx_subscribe` ADD COLUMN `package_code` text NOT NULL COMMENT '包代码' AFTER `sh_uid`;
ALTER TABLE `role_wx_subscribe` DROP `role_id`;
ALTER TABLE `role_wx_subscribe` DROP primary key;
ALTER TABLE `role_wx_subscribe` ADD primary key(`sh_uid`, `temp_id`);
ALTER TABLE `player_state` MODIFY hp BIGINT(20) unsigned NOT NULL DEFAULT '0' COMMENT '气血';

CREATE TABLE IF NOT EXISTS `role_dungeon_rune_daily_reward`(
    `role_id` bigint unsigned NOT NULL COMMENT '玩家Id',
    `last_receive_time` bigint unsigned NOT NULL DEFAULT 0 COMMENT '领取时间',
    `update_time` bigint unsigned NOT NULL DEFAULT 0 COMMENT '更新时间',
    `store_list` VARCHAR(1024) NOT NULL DEFAULT '[]' COMMENT '未领取存储',
    PRIMARY KEY(`role_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文本每日奖励状态';

CREATE TABLE IF NOT EXISTS `log_dungeon_rune_daily_reward`(
  `role_id` bigint unsigned NOT NULL COMMENT '玩家Id',
  `level` int unsigned NOT NULL COMMENT '当前层级',
  `level_list` text COMMENT '领取的层级',
  `reward_list` text COMMENT '奖励列表',
  `time` bigint unsigned NOT NULL COMMENT '领取时间',
  PRIMARY KEY(`role_id`), 
  INDEX(`time`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文本每日奖励状态';


DROP TABLE IF EXISTS `log_dungeon_rune_daily_reward`;
CREATE TABLE IF NOT EXISTS `log_dungeon_rune_daily_reward`(
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `role_id` bigint unsigned NOT NULL COMMENT '玩家Id',
  `level` int unsigned NOT NULL COMMENT '当前层级',
  `level_list` text COMMENT '领取的层级',
  `reward_list` text COMMENT '奖励列表',
  `time` bigint unsigned NOT NULL COMMENT '领取时间',
  PRIMARY KEY(`id`), 
  INDEX(`role_id`),
  INDEX(`time`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='符文本每日奖励日志';
create table if not exists `fiesta` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    fiesta_id smallint unsigned not null default 0 comment '祭典唯一id',
    act_id tinyint unsigned not null default 0 comment '活动id',
    type tinyint unsigned not null default 0 comment '祭典开通类型',
    lv smallint unsigned not null default 0 comment '当前祭典等级',
    exp int unsigned not null default 0 comment '当前累计经验',
    begin_time int unsigned not null default 0 comment '开始时间戳',
    expired_time int unsigned not null default 0 comment '过期时间戳',
    primary key (role_id)
) engine=InnoDB default charset=utf8 comment='玩家祭典信息表(合服合并)';

create table if not exists `fiesta_reward` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    lv smallint unsigned not null default 0 comment '祭典等级',
    status1 tinyint unsigned not null default 0 comment '普通奖励领取状态',
    status2 tinyint unsigned not null default 0 comment '高级奖励领取状态',
    primary key (role_id, lv)
) engine=InnoDB default charset=utf8 comment='玩家祭典奖励信息表(合服合并)';

create table if not exists `fiesta_task` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    type tinyint unsigned not null default 0 comment '任务类型',
    task_id smallint unsigned not null default 0 comment '任务id',
    finish_times tinyint unsigned not null default 0 comment '已完成次数',
    cur_num int unsigned not null default 0 comment '当前单任务进度',
    status tinyint unsigned not null default 0 comment '经验奖励状态',
    acc_times tinyint unsigned not null default 0 comment '累积未领取次数',
    primary key (role_id, type, task_id)
) engine=InnoDB default charset=utf8 comment='玩家祭典任务信息表(合服合并)';

create table if not exists `log_fiesta` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    reg_day smallint unsigned not null default 0 comment '注册天数',
    role_lv smallint unsigned not null default 0 comment '玩家等级',
    fiesta_id smallint unsigned not null default 0 comment '祭典id',
    act_id tinyint unsigned not null default 0 comment '活动id',
    type tinyint unsigned not null default 0 comment '开通类型',
    begin_time int unsigned not null default 0 comment '开始时间',
    expired_time int unsigned not null default 0 comment '过期时间',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id)
) engine=InnoDB default charset=utf8 comment='(高级)祭典开启日志(偏移量)';

create table if not exists `log_fiesta_task_progress` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    task_type tinyint unsigned not null default 0 comment '任务类型',
    task_id smallint unsigned not null default 0 comment '任务id',
    progress int unsigned not null default 0 comment '任务进度',
    status tinyint unsigned not null default 0 comment '领取状态',
    acc_times tinyint unsigned not null default 0 comment '累积未领取次数',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, task_id)
) engine=InnoDB default charset=utf8 comment='祭典任务日志(偏移量)';

create table if not exists `log_fiesta_task_reward` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    task_id smallint unsigned not null default 0 comment '任务id',
    oexp int unsigned not null default 0 comment '领取前经验',
    nexp int unsigned not null default 0 comment '领取后经验',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, task_id)
) engine=InnoDB default charset=utf8 comment='祭典任务奖励日志(偏移量)';

create table if not exists `log_fiesta_reward` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    fiesta_id smallint unsigned not null default 0 comment '祭典id',
    lv smallint unsigned not null default 0 comment '祭典等级',
    rewards varchar(100) not null default '[]' comment '奖励列表',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, fiesta_id)
) engine=InnoDB default charset=utf8 comment='祭典奖励日志(偏移量)';

alter table log_fiesta_task_progress add column finish_times tinyint unsigned not null default 0 comment '完成次数' after progress;

alter table log_fiesta add index(time);
alter table log_fiesta_task_progress add index(time);
alter table log_fiesta_task_reward add index(time);
alter table log_fiesta_reward add index(time);
delete from task_log where `type` in (6,7,8,9);
CREATE TABLE IF NOT EXISTS `role_grow_welfare_task` (
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `task_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务ID',
    `process` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '进度值',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
    PRIMARY KEY (`role_id`, `task_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家成长福利任务进度';

CREATE TABLE IF NOT EXISTS `log_grow_welfare_task_process` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `task_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务ID',
    `process` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '进度值',
    `status` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态',
    `time` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '时间',
    PRIMARY KEY (`id`),
    index(`role_id`, `time`),
    index(`time`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家成长福利日志';

alter table `recharge_log` add column `real_gold` int(11) unsigned not null default 0 comment '实际获取钻石' after `gold`;

CREATE TABLE IF NOT EXISTS `combat_welfare` (
    `player_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `round` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '当前轮数',
    `times` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '剩余抽奖次数',
    `index` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '战力增加次数的下标',
    `reward_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '当轮已抽到的奖励ID',
    PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战力福利(合服合并)';

CREATE TABLE IF NOT EXISTS `log_combat_welfare_times` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `role_name` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家名称',
    `power` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '触发战力',
    `times` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '增加的次数',
    `time` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '时间',
    PRIMARY KEY (`id`),
    index(`role_id`, `time`),
    index(`time`)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家战力福利次数产生日志(偏移量)';

CREATE TABLE IF NOT EXISTS `rush_treasure_rank` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
  `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服id',
  `platform` varchar(50) NOT NULL DEFAULT '[]' COMMENT '平台',
  `server_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服数',
  `name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '名字',
  `mask_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '面具id',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分数',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上榜时间',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE,
  KEY `rush_treasure_rank_server_id_IDX` (`server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜夺宝榜单表(合服合并)';

CREATE TABLE IF NOT EXISTS `log_rush_treasure_rank_reward` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `name` varchar(512) NOT NULL DEFAULT '' COMMENT '名字',
  `zone_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '区id',
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器id',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
  `subtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `rank_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '榜单类型',
  `score` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `rank` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排名',
  `reward` varchar(1000) NOT NULL DEFAULT '' COMMENT '奖励',
  `world_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '世界等级',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `log_rush_treasure_rank_reward_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_rush_treasure_rank_reward_rank_type_IDX` (`rank_type`) USING BTREE,
  KEY `log_rush_treasure_rank_reward_time_IDX` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜夺宝排名奖励日志(偏移量)';

CREATE TABLE IF NOT EXISTS `log_rush_treasure_rank` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '序号',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `name` varchar(512) NOT NULL DEFAULT '' COMMENT '名字',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
  `subtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `rank_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '榜单类型',
  `score` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `rank` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排名',
  `zone` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '区id',
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Id',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `log_rush_treasure_rank_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_rush_treasure_rank_time_IDX` (`time`) USING BTREE,
  KEY `log_rush_treasure_rank_rank_type_IDX` (`rank_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜夺宝排名日志表(偏移量)';

alter table `top_pk_rank_kf` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `role_nine` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `role_glad` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `role_baby_basic` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `player_fairy_sub` modify column `combat` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `log_talent_skill` modify column `old_power` BIGINT(20) unsigned not null default 0 comment '操作前战力' ;
alter table `log_talent_skill` modify column `power` BIGINT(20) unsigned not null default 0 comment '操作后战力' ;
alter table `log_partner_recruit` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `log_partner_promote` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `log_partner_learn_sk` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `log_partner_equip` modify column `combat_power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `log_diamond_league_apply` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `diamond_league_history` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `kf_3v3_rank` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `kf_3v3_bf_rank_info` modify column `hightest_combat_power` BIGINT(20) unsigned not null default 0 comment '历史最高战力' ;
alter table `kf_3v3_rank` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力' ;
alter table `guild` modify column `auto_approve_power` BIGINT(20) unsigned not null default 0 comment '自动加入的战力' ;
alter table `diamond_league_roles` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力';
alter table `diamond_league_apply` modify column `power` BIGINT(20) unsigned not null default 0 comment '战力';
ALTER TABLE `log_boss_kill` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_boss_kill` ADD INDEX stime( `stime`);
ALTER TABLE `log_common_rank_role` ADD INDEX sec_role_id( `sec_role_id`);
ALTER TABLE `log_daily_checkin` ADD INDEX time( `time`);
ALTER TABLE `log_decoration_stage_up` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_decoration_stage_up` ADD INDEX time( `time`);
ALTER TABLE `log_demons_shop_refresh` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_demons_shop_refresh` ADD INDEX stime( `stime`);
ALTER TABLE `log_demons_slot_skill` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_demons_slot_skill` ADD INDEX stime( `stime`);
ALTER TABLE `log_diamond_league_apply` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_diamond_league_battle` ADD INDEX winner_id( `winner_id`);
ALTER TABLE `log_diamond_league_battle` ADD INDEX loser_id( `loser_id`);
ALTER TABLE `log_dragon_crucible_beckon` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_dragon_crucible_beckon` ADD INDEX time( `time`);
ALTER TABLE `log_dragon_crucible_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_dragon_crucible_reward` ADD INDEX start_time( `start_time`);
ALTER TABLE `log_dragon_crucible_reward` ADD INDEX end_time( `end_time`);
ALTER TABLE `log_dragon_crucible_reward` ADD INDEX time( `time`);
ALTER TABLE `log_dragon_decompose` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_dragon_decompose` ADD INDEX time( `time`);
ALTER TABLE `log_dragon_language_boss` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_dsgt_order` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_dsgt_order` ADD INDEX time( `time`);
ALTER TABLE `log_enchantment_guard_battle` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_enchantment_guard_battle` ADD INDEX time( `time`);
ALTER TABLE `log_enchantment_guard_seal` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_enchantment_guard_seal` ADD INDEX time( `time`);
ALTER TABLE `log_enchantment_guard_sweep` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_enchantment_guard_sweep` ADD INDEX time( `time`);
ALTER TABLE `log_equip_casting_spirit` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_casting_spirit` ADD INDEX time( `time`);
ALTER TABLE `log_equip_refine` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_refine` ADD INDEX time( `time`);
ALTER TABLE `log_equip_stren` ADD INDEX time( `time`);
ALTER TABLE `log_equip_suit_operation` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_equip_suit_operation` ADD INDEX time( `time`);
ALTER TABLE `log_equip_upgrade_division` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_upgrade_division` ADD INDEX time( `time`);
ALTER TABLE `log_equip_upgrade_spirit` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_upgrade_spirit` ADD INDEX time( `time`);
ALTER TABLE `log_equip_upgrade_stage` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_upgrade_stage` ADD INDEX time( `time`);
ALTER TABLE `log_equip_wash` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_equip_wash` ADD INDEX time( `time`);
ALTER TABLE `log_escape_stuck` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_escape_stuck` ADD INDEX time( `time`);
ALTER TABLE `log_eternal_valley_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_eternal_valley_reward` ADD INDEX time( `time`);
ALTER TABLE `log_eudemons_compose` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_eudemons_compose` ADD INDEX utime( `utime`);
ALTER TABLE `log_eudemons_operation` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_eudemons_operation` ADD INDEX time( `time`);
ALTER TABLE `log_eudemons_strength` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_eudemons_strength` ADD INDEX time( `time`);
ALTER TABLE `log_fashion_color` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_fashion_color` ADD INDEX time( `time`);
ALTER TABLE `log_fashion_pos` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_fashion_pos` ADD INDEX time( `time`);
ALTER TABLE `log_fashion_star` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_fashion_star` ADD INDEX time( `time`);
ALTER TABLE `log_flower_act_send_kf` ADD INDEX sid( `sid`);
ALTER TABLE `log_flower_act_send_kf` ADD INDEX rid( `rid`);
ALTER TABLE `log_god_equip_level` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_god_equip_level` ADD INDEX stime( `stime`);
ALTER TABLE `log_goods_compose` ADD INDEX time( `time`);
ALTER TABLE `log_guild_daily_recieve` ADD INDEX stime( `stime`);
ALTER TABLE `log_guild_daily_send` ADD INDEX stime( `stime`);
ALTER TABLE `log_guild_god` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_holy_battle_pk_point_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_holy_battle_pk_role` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_house_add_furniture` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_house_add_furniture` ADD INDEX time( `time`);
ALTER TABLE `log_house_buy_upgrade` ADD INDEX role_id_1( `role_id_1`);
ALTER TABLE `log_house_buy_upgrade` ADD INDEX role_id_2( `role_id_2`);
ALTER TABLE `log_house_buy_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_house_choose` ADD INDEX role_id_1( `role_id_1`);
ALTER TABLE `log_house_choose` ADD INDEX role_id_2( `role_id_2`);
ALTER TABLE `log_house_choose` ADD INDEX time( `time`);
ALTER TABLE `log_house_divorce` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_house_divorce` ADD INDEX lover_role_id( `lover_role_id`);
ALTER TABLE `log_house_divorce` ADD INDEX time( `time`);
ALTER TABLE `log_house_merge` ADD INDEX return_list_2_B( `return_list_2_B`);
ALTER TABLE `log_husong_end` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_husong_end` ADD INDEX time( `time`);
ALTER TABLE `log_husong_reflesh` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_husong_reflesh` ADD INDEX time( `time`);
ALTER TABLE `log_husong_take` ADD INDEX take_role_id( `take_role_id`);
ALTER TABLE `log_husong_take` ADD INDEX be_taken_role_id( `be_taken_role_id`);
ALTER TABLE `log_husong_take` ADD INDEX time( `time`);
ALTER TABLE `log_juewei_level_up` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_juewei_level_up` ADD INDEX time( `time`);
ALTER TABLE `log_kf_1vn_auction` ADD INDEX time( `time`);
ALTER TABLE `log_kf_1vn_race_1` ADD INDEX time( `time`);
ALTER TABLE `log_kf_1vn_race_2` ADD INDEX time( `time`);
ALTER TABLE `log_kf_1vn_sign` ADD INDEX time( `time`);
ALTER TABLE `log_kf_san_construction_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_kf_san_construction_reward` ADD INDEX stime( `stime`);
ALTER TABLE `log_kf_san_medal` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_kf_san_medal` ADD INDEX stime( `stime`);
ALTER TABLE `log_kf_score_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_kf_score_reward` ADD INDEX stime( `stime`);
ALTER TABLE `log_level_act` ADD INDEX rold_id( `rold_id`);
ALTER TABLE `log_level_act` ADD INDEX stime( `stime`);
ALTER TABLE `log_level_gift_send` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_level_gift_send` ADD INDEX stime( `stime`);
ALTER TABLE `log_limit_shop_buy` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_limit_shop_buy` ADD INDEX time( `time`);
ALTER TABLE `log_login_reward_day` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_login_reward_day` ADD INDEX time( `time`);
ALTER TABLE `log_magic_circle` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_magic_circle` ADD INDEX magic_circle_id( `magic_circle_id`);
ALTER TABLE `log_magic_circle` ADD INDEX end_time( `end_time`);
ALTER TABLE `log_mail_clear` ADD INDEX effect_st( `effect_st`);
ALTER TABLE `log_marriage_answer` ADD INDEX role_id_1( `role_id_1`);
ALTER TABLE `log_marriage_answer` ADD INDEX role_id_2( `role_id_2`);
ALTER TABLE `log_marriage_baby_aptitude_upgrade` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_baby_aptitude_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_baby_image_upgrade` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_baby_image_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_baby_knowledge_upgrade` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_baby_knowledge_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_divorse` ADD INDEX role_id_m( `role_id_m`);
ALTER TABLE `log_marriage_divorse` ADD INDEX role_id_w( `role_id_w`);
ALTER TABLE `log_marriage_divorse` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_divorse` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_life_train` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_life_train` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_propose` ADD INDEX role_id_1( `role_id_1`);
ALTER TABLE `log_marriage_propose` ADD INDEX role_id_2( `role_id_2`);
ALTER TABLE `log_marriage_propose` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_ring_polish` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_ring_polish` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_ring_upgrade` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_ring_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_wedding_aura` ADD INDEX role_id_m( `role_id_m`);
ALTER TABLE `log_marriage_wedding_aura` ADD INDEX role_id_w( `role_id_w`);
ALTER TABLE `log_marriage_wedding_aura` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_marriage_wedding_aura` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_wedding_end` ADD INDEX role_id_m( `role_id_m`);
ALTER TABLE `log_marriage_wedding_end` ADD INDEX role_id_w( `role_id_w`);
ALTER TABLE `log_marriage_wedding_end` ADD INDEX time( `time`);
ALTER TABLE `log_marriage_wedding_order` ADD INDEX role_id_m( `role_id_m`);
ALTER TABLE `log_marriage_wedding_order` ADD INDEX role_id_w( `role_id_w`);
ALTER TABLE `log_marriage_wedding_order` ADD INDEX order_time( `order_time`);
ALTER TABLE `log_marriage_wedding_order` ADD INDEX time( `time`);
ALTER TABLE `log_monday_draw` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_monday_draw` ADD INDEX utime( `utime`);
ALTER TABLE `log_mon_pic_lv` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_mon_pic_lv` ADD INDEX time( `time`);
ALTER TABLE `log_mount_upgrade_star` ADD INDEX clear_time( `clear_time`);
ALTER TABLE `log_multi_dungeon` ADD INDEX role_id1( `role_id1`);
ALTER TABLE `log_multi_dungeon` ADD INDEX role_id2( `role_id2`);
ALTER TABLE `log_multi_dungeon` ADD INDEX role_id3( `role_id3`);
ALTER TABLE `log_onhook` ADD INDEX onhook_time( `onhook_time`);
ALTER TABLE `log_online_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_online_reward` ADD INDEX get_time( `get_time`);
ALTER TABLE `log_online_reward` ADD INDEX online_time( `online_time`);
ALTER TABLE `log_partner_break` ADD INDEX time( `time`);
ALTER TABLE `log_partner_equip` ADD INDEX time( `time`);
ALTER TABLE `log_pet_aircraft_stage` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_pet_aircraft_stage` ADD INDEX time( `time`);
ALTER TABLE `log_pk` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_pk` ADD INDEX enemy_id( `enemy_id`);
ALTER TABLE `log_pk` ADD INDEX stime( `stime`);
ALTER TABLE `log_produce_currency` ADD INDEX time( `time`);
ALTER TABLE `log_produce_gcoin` ADD INDEX time( `time`);
ALTER TABLE `log_rdungeon_success` ADD INDEX go_time( `go_time`);
ALTER TABLE `log_real_info` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_real_info` ADD INDEX time( `time`);
ALTER TABLE `log_reincarnation` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rela` ADD INDEX other_rid( `other_rid`);
ALTER TABLE `log_rename` ADD INDEX time( `time`);
ALTER TABLE `log_rename_guild` ADD INDEX time( `time`);
ALTER TABLE `log_role_advertisement` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_role_advertisement` ADD INDEX time( `time`);
ALTER TABLE `log_role_attr_medicament` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_awake` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_awake` ADD INDEX time( `time`);
ALTER TABLE `log_rune_compose` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_compose` ADD INDEX time( `time`);
ALTER TABLE `log_rune_dismantle_awake` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_dismantle_awake` ADD INDEX time( `time`);
ALTER TABLE `log_rune_exchange` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_exchange` ADD INDEX time( `time`);
ALTER TABLE `log_rune_level_up` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_level_up` ADD INDEX time( `time`);
ALTER TABLE `log_rune_skill_up` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_skill_up` ADD INDEX time( `time`);
ALTER TABLE `log_rune_wear` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_rune_wear` ADD INDEX time( `time`);
ALTER TABLE `log_rush_giftbag` ADD INDEX time( `time`);
ALTER TABLE `log_sanctuary_designation` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_sanctuary_designation` ADD INDEX time( `time`);
ALTER TABLE `log_sanctuary_kill` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_sanctuary_kill` ADD INDEX time( `time`);
ALTER TABLE `log_sanctuary_point` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_sanctuary_point` ADD INDEX time( `time`);
ALTER TABLE `log_sanctum_rank` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_sanctum_rank` ADD INDEX stime( `stime`);
ALTER TABLE `log_seal_pill` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_seal_pill` ADD INDEX stime( `stime`);
ALTER TABLE `log_seal_stren` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_seal_stren` ADD INDEX stime( `stime`);
ALTER TABLE `log_select_pool_rest` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_select_pool_rest` ADD INDEX stime( `stime`);
ALTER TABLE `log_sell_down` ADD INDEX time( `time`);
ALTER TABLE `log_sell_down_kf` ADD INDEX time( `time`);
ALTER TABLE `log_shop` ADD INDEX time( `time`);
ALTER TABLE `log_sign_up_msg` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_smashed_egg` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_smashed_egg` ADD INDEX time( `time`);
ALTER TABLE `log_soul_awake` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_soul_awake` ADD INDEX time( `time`);
ALTER TABLE `log_soul_compose` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_soul_compose` ADD INDEX time( `time`);
ALTER TABLE `log_soul_dismantle_awake` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_soul_dismantle_awake` ADD INDEX time( `time`);
ALTER TABLE `log_soul_level_up` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_soul_level_up` ADD INDEX time( `time`);
ALTER TABLE `log_soul_wear` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_soul_wear` ADD INDEX time( `time`);
ALTER TABLE `log_stone_inlay` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_stone_inlay` ADD INDEX time( `time`);
ALTER TABLE `log_stone_refine` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_stone_refine` ADD INDEX time( `time`);
ALTER TABLE `log_territory_rank` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_territory_rank` ADD INDEX stime( `stime`);
ALTER TABLE `log_territory_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_territory_reward` ADD INDEX stime( `stime`);
ALTER TABLE `log_title_info` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_title_info` ADD INDEX stime( `stime`);
ALTER TABLE `log_top_pk` ADD INDEX fight_role_id( `fight_role_id`);
ALTER TABLE `log_top_pk_enter_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_top_pk_enter_reward` ADD INDEX time( `time`);
ALTER TABLE `log_top_pk_season_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_top_pk_season_reward` ADD INDEX time( `time`);
ALTER TABLE `log_top_pk_stage_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_top_pk_stage_reward` ADD INDEX time( `time`);
ALTER TABLE `log_total_checkin` ADD INDEX time( `time`);
ALTER TABLE `log_treasure_chest_reward` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_treasure_chest_reward` ADD INDEX time( `time`);
ALTER TABLE `log_treasure_evaluation` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_treasure_evaluation` ADD INDEX time( `time`);
ALTER TABLE `log_treasure_map` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_treasure_map` ADD INDEX time( `time`);
ALTER TABLE `log_vip_buy` ADD INDEX end_time( `end_time`);
ALTER TABLE `log_vip_goods` ADD INDEX end_time( `end_time`);
ALTER TABLE `log_vip_status` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_vip_status` ADD INDEX time( `time`);
ALTER TABLE `log_vip_status` ADD INDEX end_time( `end_time`);
ALTER TABLE `log_vip_upgrade` ADD INDEX player_id( `player_id`);
ALTER TABLE `log_vip_upgrade` ADD INDEX time( `time`);
ALTER TABLE `log_void_fam` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_void_fam` ADD INDEX time( `time`);
ALTER TABLE `log_wed_rank` ADD INDEX book_time( `book_time`);
ALTER TABLE `log_wldboss_kill` ADD INDEX role_id( `role_id`);
ALTER TABLE `log_wldboss_kill` ADD INDEX time( `time`);
alter table log_login add column module_power text comment '模块战力' after combat_power;
alter table log_offline add column module_power text comment '模块战力' after power;
update sanctuary_kf_role set paied = 0 ,clear_time =  1646596800;

alter table role_wx_subscribe add column role_id bigint(20) unsigned not null default 0 comment '玩家id' after temp_id;
alter table role_wx_subscribe drop primary key;
alter table role_wx_subscribe modify sh_uid varchar(100);
alter table role_wx_subscribe add primary key (sh_uid, temp_id);
CREATE TABLE  if NOT EXISTS `rush_treasure_role` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `today_score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '今日积分',
  `times` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '累积次数',
  `reward_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已获奖励',
  `score_reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取阶段奖励',
  `last_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜夺宝玩家表(合服合并)';
alter table log_dungeon_exp_gain add column mon_exp bigint unsigned not null default 0 comment '杀怪经验' after exp;
alter table log_dungeon_exp_gain add column ratio1 float unsigned not null default 0 comment '初始杀怪倍率' after mon_exp;
alter table log_dungeon_exp_gain add column ratio2 float unsigned not null default 0 comment '最后杀怪倍率' after ratio1;

alter table `player_login` add column `first_state` tinyint(1) not null default 0 comment '账户首个角色|0未确定，1是，2否';

create table if not exists `role_envelope_rebate` (
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `is_quality` tinyint(1) unsigned not null default 0 comment '是否有资格参加' ,
    `start_time` int(11) unsigned not null default 0 comment '开始时间',
    `end_time` int(11) unsigned not null default 0 comment '结束时间',
    `login_day_list` varchar(1024) not null default '[]' comment '登录日列表',
    `last_login_time` int(11) unsigned not null default 0 comment '上次登录时间',
    `login_money` int(11) unsigned not null default 0 comment '累计登录红包（分）',
    `recharge_money` int(11) unsigned not null default 0 comment '累计返利红包（分）',
    `login_envelope_ids` varchar(1024) not null default '[]' comment '累计登录红包ID',
    `recharge_envelope_ids` varchar(1024) not null default '[]' comment '累计返利红包ID',
    `login_lock` tinyint(1) unsigned not null default 0 comment '登录红包提现锁' ,
    `recharge_lock` tinyint(1) unsigned not null default 0 comment '返利红包提现锁' ,
    primary key (`type`, `sub_type`, `role_id`)
) engine=InnoDB default charset=utf8 comment='红包返利玩家信息';

create table if not exists `log_envelope_rebate_withdrawal` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `envelope_type` tinyint(1) unsigned not null default 0 comment '红包类型|1登录红包，2返利红包',
    `envelope_ids` varchar(1025) not null default '[]' comment '提现的红包列表',
    `envelope_value` int(11) unsigned not null default 0 comment '提现红包金额（分）',
    `status` tinyint(1) unsigned not null default 0 comment '提现状态|0提现中，1提现成功，2提现失败',
    `time` int(11) unsigned not null default 0 comment '时间',
    primary key (`id`),
    index(`type`, `sub_type`, `role_id`, `time`),
    index(`role_id`, `time`)
)engine=InnoDB default charset=utf8 comment='红包返利提现日志';


create table if not exists `log_envelope_rebate_reward` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `envelope_type` tinyint(1) unsigned not null default 0 comment '红包类型|1登录红包，2返利红包',
    `envelope_id` smallint(6) unsigned not null default 0 comment '红包ID',
    `envelope_value` int(11) unsigned not null default 0 comment '红包增加金额（分）',
    `envelope_sum` int(11) unsigned not null default 0 comment '红包总金额（分）',
    `time` int(11) unsigned not null default 0 comment '时间',
    primary key (`id`),
    index(`type`, `sub_type`, `role_id`, `time`),
    index(`role_id`, `time`)
)engine=InnoDB default charset=utf8 comment='红包返利金额增加日志';

truncate table `eudemons`;
delete from counter where module = 173 and sub_module = 0 and type = 1;
CREATE TABLE IF NOT EXISTS `log_combat_welfare_reward_info` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `role_name` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家名称',
    `round` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '轮次',
    `reward_id` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '奖励ID',
    `reward` varchar(128) NOT NULL DEFAULT '[]' COMMENT '奖励内容',
    `time` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '时间',
    PRIMARY KEY (`id`),
    index(`role_id`, `time`),
    index(`time`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='战力福利奖励信息日志';
CREATE TABLE IF NOT EXISTS `player_enchantment_guard_rank` (
    `zone_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分区ID',
    `role_id` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `role_name` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名',
    `group_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分组ID',
    `server_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '区服ID',
    `server_num` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '区服编号',
    `rank` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排名',
    `gate` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '通关数',
    `last_time` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后通关时间',
    PRIMARY KEY (`role_id`),
    index(`zone_id`, `group_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家结界守护排名信息';

CREATE TABLE IF NOT EXISTS `player_enchantment_guard_soap` (
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `soap_id` INT(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '古宝ID',
    `debris_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '古宝碎片ID',
    PRIMARY KEY (`role_id`, `soap_id`, `debris_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家结界守护古宝信息';

CREATE TABLE IF NOT EXISTS `log_enchantment_guard_soap_debris` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `role_id` BIGINT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家ID',
    `soap_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '古宝ID',
    `debris_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '古宝碎片ID',
    `time` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '时间',
    PRIMARY KEY (`id`),
    index(`role_id`, `time`),
    index(`time`)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结界守护古宝激活日志';
CREATE TABLE IF NOT EXISTS `player_weekly_card` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `is_activity` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否激活',
  `gift_bag_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `can_receive_gift` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '可领取数量',
  `expired_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡玩家信息（合服合并）';

CREATE TABLE IF NOT EXISTS `log_weekly_card_open` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `open_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开启等级',
  `expired_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `open_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开启时间',
  PRIMARY KEY (`id`),
  KEY `log_weekly_card_open_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_weekly_card_open_open_time_IDX` (`open_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡开启日志（偏移量）';

CREATE TABLE IF NOT EXISTS `log_weekly_card_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `old_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧等级',
  `new_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新等级',
  `old_exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧经验',
  `new_exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新经验',
  `old_can_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧可以领取数量',
  `new_can_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新可以领取数量',
  `old_sum_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧已领取数量',
  `new_sum_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新已领取数量',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `log_weekly_card_info_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_weekly_card_info_time_IDX` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡玩家信息日志（偏移量）';
CREATE TABLE IF NOT EXISTS `player_limit_tower` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `round` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '轮次',
    `over_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
    `pass_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '用过关卡',
    `reward_mode` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大奖状态',
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家限时爬塔数据(合服合并)';

alter table `player_enchantment_guard` add column `node_id` smallint(6) unsigned not null default 0 comment '新手流程节点';
CREATE TABLE IF NOT EXISTS `cycle_rank_role_info` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
  `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服id',
  `platform` varchar(50) NOT NULL DEFAULT '[]' COMMENT '平台',
  `server_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服数',
  `name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '名字',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分数',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上榜时间',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜榜单(合服合并)';

CREATE TABLE IF NOT EXISTS `player_cycle_rank_role` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `reward_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已达成目标的奖励Id',
  `score_reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取目标奖励ID',
  `other` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '扩展数据',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜玩家表(合服合并)';

alter table `player_cycle_rank_role` add column `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动结束时间';
CREATE TABLE IF NOT EXISTS `log_cycle_rank_time` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '序号',
    `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器id',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
    `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
    `open` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY `time` (`time`) USING BTREE,
    KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜开启日志表(偏移量)';

CREATE TABLE IF NOT EXISTS `log_cycle_rank_rank` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '序号',
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `name` varchar(512) NOT NULL DEFAULT '' COMMENT '名字',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
    `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
    `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
    `rank` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排名',
    `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器id',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY `role_id` (`role_id`) USING BTREE,
    KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜排名日志表(偏移量)';

CREATE TABLE IF NOT EXISTS `log_cycle_rank_rank_reward` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `name` varchar(100) NOT NULL DEFAULT '' COMMENT '玩家名字',
    `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服id',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
    `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
    `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
    `rank` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排名',
    `reward` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '奖励',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`),
    KEY `role_id` (`role_id`),
    KEY `type` (`type`),
    KEY `subtype` (`subtype`),
    KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜排名奖励日志(偏移量)';

CREATE TABLE IF NOT EXISTS `log_cycle_rank_reach` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '序号',
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `name` varchar(512) NOT NULL DEFAULT '' COMMENT '名字',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
    `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
    `reward_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '奖励ID',
    `reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '奖励',
    `ptype` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '产出类型',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY `role_id` (`role_id`) USING BTREE,
    KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜目标奖励表(偏移量)';

CREATE TABLE IF NOT EXISTS `log_cycle_rank_role_score` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '序号',
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `name` varchar(512) NOT NULL DEFAULT '' COMMENT '名字',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
    `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
    `handletype` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '操作类型',
    `cost` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '消耗',
    `oscore` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作前积分',
    `add_score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '增加积分',
    `nscore` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作后积分',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`),
    KEY `role_id` (`role_id`),
    KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜玩家积分日志(偏移量)';
CREATE TABLE IF NOT EXISTS `player_mount_level` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `type_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '外形类型',
    `dev_lv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坐骑等级',
    `dev_exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '坐骑等级经验',
    `skill` varchar(255) NOT NULL DEFAULT '[]' COMMENT '技能',
    PRIMARY KEY (`role_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='外形升级养成线(合服合并)';

CREATE TABLE IF NOT EXISTS `log_mount_upgrade_sys` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `type_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '外形类型',
    `pre_level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '升级前等级',
    `pre_exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '升级前经验值',
    `exp_plus` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '增加的经验值',
    `cur_level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '当前等级',
    `cur_exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '升级后的经验值',
    `cost` varchar(50) NOT NULL DEFAULT '[]' COMMENT '消耗物品',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
    PRIMARY KEY (`id`),
    KEY `role_id` (`role_id`),
    KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='坐骑升级养成线日志(偏移量)';
alter table boss_remind add column remind tinyint unsigned not null default 0 comment '是否关注';
alter table boss_remind add column auto_remind tinyint unsigned not null default 1 comment '是否可以自动关注';

alter table special_boss_info add column auto_remind tinyint unsigned not null default 1 comment '是否可以自动关注';
ALTER TABLE player_weekly_card ADD reward_list varchar(1023) DEFAULT '[]' NOT NULL comment '奖励列表';
ALTER TABLE log_weekly_card_info ADD reward_list varchar(1023) DEFAULT '[]' NOT NULL COMMENT '奖励列表';
ALTER TABLE log_weekly_card_info CHANGE reward_list reward_list varchar(1023) DEFAULT '[]' NOT NULL COMMENT '奖励列表' AFTER new_sum_num;
CREATE TABLE IF NOT EXISTS `log_draw_simulation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `simulation_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模拟序号',
  `draw_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '抽奖次数',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
  `subtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `reward_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '奖励Id',
  `rewards` varchar(1024) NOT NULL DEFAULT '' COMMENT '具体奖励内容',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖模拟日志（偏移量）';
