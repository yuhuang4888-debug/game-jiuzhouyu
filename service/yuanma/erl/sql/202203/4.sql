CREATE TABLE  if NOT EXISTS `rush_treasure_role` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `today_score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '今日积分',
  `times` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '累积次数',
  `reward_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已获奖励',
  `score_reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取阶段奖励',
  `last_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='冲榜夺宝玩家表(合服合并)';