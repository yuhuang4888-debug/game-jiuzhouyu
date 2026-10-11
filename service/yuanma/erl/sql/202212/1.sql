
CREATE TABLE IF NOT EXISTS `role_halo` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `end_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间戳',
  `privilege_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '特权奖励领取状态',
  `is_send` int(8) unsigned NOT NULL DEFAULT '0' COMMENT '是否补发过奖励',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='主角光环';

CREATE TABLE IF NOT EXISTS `role_great_demon_boss_kf_kill` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `kill_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '击杀数量',
  `get_list` varchar(1000) NOT NULL DEFAULT '[]' COMMENT '领取列表',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家跨服秘境领域记录杀怪(合服合并)';

CREATE TABLE IF NOT EXISTS `great_demon_boss_remind` (
  `role_id` bigint(20) NOT NULL,
  `boss_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '幻兽之域boss功能(本服关注表)',
  PRIMARY KEY (`role_id`,`boss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='(合服合并)';

CREATE TABLE IF NOT EXISTS `log_great_demon_boss_kf` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `zone_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分区id',
  `boss_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'BossId',
  `kill_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '击杀玩家id',
  `kill_name` varchar(50) NOT NULL DEFAULT '[]' COMMENT '击杀boss玩家名字',
  `kill_platform` varchar(50) NOT NULL DEFAULT '[]' COMMENT '玩家的平台',
  `kill_server_name` varchar(255) NOT NULL COMMENT '击杀者服务器名',
  `bl_who_1` varchar(500) NOT NULL DEFAULT '[]' COMMENT '归属玩家1',
  `bl_who_2` varchar(500) NOT NULL COMMENT '归属玩家2',
  `bl_who_3` varchar(500) NOT NULL COMMENT '归属玩家3',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `boss_id` (`boss_id`),
  KEY `kill_id` (`kill_id`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服秘境boss击杀归属日志(偏移量)';