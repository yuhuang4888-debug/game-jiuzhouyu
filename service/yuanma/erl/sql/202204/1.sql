CREATE TABLE IF NOT EXISTS `cycle_rank_role_info` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '次类型',
  `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服id',
  `platform` varchar(50) NOT NULL DEFAULT '[]' COMMENT '平台',
  `server_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服数',
  `name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '名字',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分数',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上榜时间',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜榜单(合服合并)';

CREATE TABLE IF NOT EXISTS `player_cycle_rank_role` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  `subtype` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `score` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `reward_list` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已达成目标的奖励Id',
  `score_reward` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '已领取目标奖励ID',
  `other` varchar(2048) NOT NULL DEFAULT '[]' COMMENT '扩展数据',
  PRIMARY KEY (`role_id`,`type`,`subtype`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='循环冲榜玩家表(合服合并)';

alter table `player_cycle_rank_role` add column `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动结束时间';