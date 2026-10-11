CREATE TABLE IF NOT EXISTS `sanctuary_kf_role_rank_info` (
  `player_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id',
  `zone_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分区id',
  `copy_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '房间id',
  `scene_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '场景id',
  `player_name` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家名称',
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '游戏服务器ID',
  `score` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家总积分',
  `kill_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '击杀敌对玩家的数量',
  `last_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`player_id`, `zone_id`,`copy_id`,`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='建筑玩家积分排行数据(合服清空)';

alter table sanctuary_kf_role add column `kill_score` varchar(1023) DEFAULT '[]' NOT NULL COMMENT '击杀积分列表';

alter table sanctuary_kf_role add column `is_task` int(8) unsigned not null default 0 comment '阶段任务标志位';