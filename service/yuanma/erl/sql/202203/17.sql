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