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

