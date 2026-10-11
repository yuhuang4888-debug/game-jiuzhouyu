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