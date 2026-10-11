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