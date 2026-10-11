CREATE TABLE IF NOT EXISTS `role_wx_subscribe` (
  `role_id` bigint unsigned NOT NULL COMMENT '玩家Id', 
  `temp_id` int(11) unsigned NOT NULL COMMENT '订阅模板id',
  `utime` bigint unsigned NOT NULL COMMENT '订阅时间', 
  PRIMARY KEY(`role_id`, `temp_id`)  
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信订阅推送';

ALTER TABLE `role_wx_subscribe` ADD COLUMN `sh_uid` int(11) unsigned NOT NULL COMMENT '深海uid' AFTER `role_id`;
ALTER TABLE `role_wx_subscribe` ADD COLUMN `package_code` text NOT NULL COMMENT '包代码' AFTER `sh_uid`;
ALTER TABLE `role_wx_subscribe` DROP `role_id`;
ALTER TABLE `role_wx_subscribe` DROP primary key;
ALTER TABLE `role_wx_subscribe` ADD primary key(`sh_uid`, `temp_id`);