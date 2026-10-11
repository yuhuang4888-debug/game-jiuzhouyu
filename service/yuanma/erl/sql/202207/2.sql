CREATE TABLE IF NOT EXISTS `log_midnight_common_rank` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
    `player_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
    `player_name` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家名称',
    `rank_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排行榜类型具体参考22101协议',
    `rank`  int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家排名',
    `value` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '对应排行榜的相应的值，战力排行榜为战力值，等级排行榜为等级',
    `second_value` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '值（保留） 阶数（骑宠榜） 等级（翅膀法宝神兵榜） 时装数量（时装榜） 鲜花数量（鲜花榜）',
    `third_value` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '值 (进阶榜形象id) ',
    `time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '入库的记录时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='排行榜快照日志(合服合并)';

alter table log_midnight_common_rank add index(`player_id`);
alter table log_midnight_common_rank add index (`rank_type`);
alter table log_midnight_common_rank add index(`time`);