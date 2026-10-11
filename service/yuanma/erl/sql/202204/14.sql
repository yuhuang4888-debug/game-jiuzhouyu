CREATE TABLE IF NOT EXISTS `log_draw_simulation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `simulation_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模拟序号',
  `draw_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '抽奖次数',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主类型',
  `subtype` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '子类型',
  `reward_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '奖励Id',
  `rewards` varchar(1024) NOT NULL DEFAULT '' COMMENT '具体奖励内容',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间戳',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖模拟日志（偏移量）';