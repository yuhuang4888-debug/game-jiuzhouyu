CREATE TABLE IF NOT EXISTS `log_gm_use` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '角色名称',
  `content` text NOT NULL COMMENT '秘籍内容',
  `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  INDEX (`role_id`, `time`),
  INDEX (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='秘籍使用日志';