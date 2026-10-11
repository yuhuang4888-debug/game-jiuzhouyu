alter table treasure_hunt_reward add column `last_draw_times` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上一次抽到大奖时的次数';

CREATE TABLE IF NOT EXISTS `log_treasure_hunt_imitate` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
    `simulation_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模拟序号',
    `hunt_type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '寻宝类型',
    `times` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中奖时的次数',
    `lucky_value` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '中奖时的幸运值',
    `reward_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '抽中的奖励ID',
    `rewards` varchar(1024) NOT NULL DEFAULT '' COMMENT '具体奖励内容',
    `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '时间戳',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='装备寻宝抽奖模拟日志（偏移量）';

alter table log_treasure_hunt_imitate add column `reward_type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '奖励分类';
alter table log_treasure_hunt_imitate add column `is_rare` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '是否稀有';