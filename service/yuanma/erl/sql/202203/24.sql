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