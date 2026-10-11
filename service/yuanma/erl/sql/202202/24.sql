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