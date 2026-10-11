CREATE TABLE IF NOT EXISTS `player_weekly_card` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `is_activity` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否激活',
  `gift_bag_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `can_receive_gift` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '可领取数量',
  `expired_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡玩家信息（合服合并）';

CREATE TABLE IF NOT EXISTS `log_weekly_card_open` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `open_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开启等级',
  `expired_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `open_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开启时间',
  PRIMARY KEY (`id`),
  KEY `log_weekly_card_open_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_weekly_card_open_open_time_IDX` (`open_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡开启日志（偏移量）';

CREATE TABLE IF NOT EXISTS `log_weekly_card_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色Id',
  `old_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧等级',
  `new_lv` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新等级',
  `old_exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧经验',
  `new_exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新经验',
  `old_can_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧可以领取数量',
  `new_can_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新可以领取数量',
  `old_sum_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '旧已领取数量',
  `new_sum_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新已领取数量',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`),
  KEY `log_weekly_card_info_role_id_IDX` (`role_id`) USING BTREE,
  KEY `log_weekly_card_info_time_IDX` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='周卡玩家信息日志（偏移量）';