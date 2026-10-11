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