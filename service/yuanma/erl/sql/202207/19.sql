CREATE TABLE IF NOT EXISTS `ta_agent_wait_upload` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据键',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '数据类型[1-normal/2-delay]',
  `data` text COMMENT '数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ta_agent关服时临时存储未及时上报的数据';