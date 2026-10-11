CREATE TABLE IF NOT EXISTS `role_guild_assist` (
    `role_id` BIGINT(20) unsigned NOT NULL COMMENT '角色ID',
    `assist_id` BIGINT(20) unsigned NOT NULL DEFAULT '0' COMMENT '协助ID',
    `ask_id` BIGINT(20) unsigned NOT NULL DEFAULT '0' COMMENT '发起者ID',
    `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
    `sub_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
    `target_cfg_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '配置ID',
    `target_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '目标ID',
    `assist_process` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '进度',
    `extra` varchar(1024) NOT NULL DEFAULT '' COMMENT '额外数据',
    `stime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间戳',
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家协助信息（合服合并）';