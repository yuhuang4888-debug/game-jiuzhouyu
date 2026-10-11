
CREATE TABLE if not exists `log_cluster_sanctuary_occupy` (
   `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
   `zone_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分区ID',
   `server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器ID',
   `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
   `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
   PRIMARY KEY (`id`),
   index (`zone_id`, `server_id`),
   index `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跨服圣域占领日志(合服清空)';