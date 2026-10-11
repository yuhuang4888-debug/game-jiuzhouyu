CREATE TABLE IF NOT EXISTS `role_delay_reward` (
   `role_id` bigint(20) unsigned NOT NULL COMMENT '角色id',
  `proto_id` int(11) unsigned NOT NULL COMMENT '抽奖协议号',
  `reward` varchar(255) NOT NULL DEFAULT '[]' COMMENT '待领取奖励',
  PRIMARY KEY (`role_id`, `proto_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='延迟发放奖励';

ALTER TABLE `rune_player` 
ADD COLUMN `awake_skill` varchar(255) NOT NULL DEFAULT '[]' COMMENT '觉醒技能列表' AFTER `skill_lv`;