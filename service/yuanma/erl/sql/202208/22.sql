ALTER TABLE `marriage_personals_player` 
ADD COLUMN `vip_hide` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'vip隐藏|0显示，1隐藏' AFTER `vip_exp`;

ALTER TABLE `marriage_personals_player` 
ADD COLUMN `is_supvip` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否有至尊vip标识' AFTER `vip_hide`;

CREATE TABLE IF NOT EXISTS `log_level_act_open` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
    `role_id` bigint unsigned not null default 0 COMMENT '玩家id',
    `type` smallint unsigned not null default 0 COMMENT '活动类型',
    `subtype` smallint unsigned not null default 0 COMMENT '活动子类型',
    `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间戳',
    `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间戳',
    PRIMARY KEY (`id`),
    index(`role_id`),
    index(`type`, `subtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='等级抢购活动开启日志(偏移量)';