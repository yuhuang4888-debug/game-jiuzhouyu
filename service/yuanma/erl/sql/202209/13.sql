CREATE TABLE IF NOT EXISTS `role_fashion_suit` (
  `role_id` bigint(20) unsigned NOT NULL COMMENT '角色id',
  `suit_id` int(11) unsigned NOT NULL COMMENT '套装id',
  `lv` int(11) unsigned NOT NULL COMMENT '套装阶级',
  `active_num` int(11) unsigned NOT NULL COMMENT '已激活套装数',
  PRIMARY KEY (`role_id`,`suit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='时装套装';