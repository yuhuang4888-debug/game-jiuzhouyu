CREATE TABLE IF NOT EXISTS `player_limit_tower` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
    `round` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '轮次',
    `over_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
    `pass_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '用过关卡',
    `reward_mode` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大奖状态',
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家限时爬塔数据(合服合并)';
