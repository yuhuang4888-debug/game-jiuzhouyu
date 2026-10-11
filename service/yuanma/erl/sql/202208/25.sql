CREATE TABLE IF NOT EXISTS  `player_fairy_buy` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `fairy_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '仙灵类型',
  `node_list` varchar(255) NOT NULL DEFAULT '[]' COMMENT '已激活节点列表',
  PRIMARY KEY (`role_id`,`fairy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仙灵直购系统';