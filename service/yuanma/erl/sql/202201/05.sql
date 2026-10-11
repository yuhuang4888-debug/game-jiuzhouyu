
CREATE TABLE IF NOT EXISTS `task_bag_content_clear` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
    `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务id',
    `type` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务类型（方便清理）',
    `stage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务阶段',
    `cid` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '内容id',
    `ctype` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '任务内容类型',
    `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '配置id',
    `need_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '完成所需数量',
    `desc` varchar(500) NOT NULL DEFAULT '0' COMMENT '文字描述',
    `scene_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景id',
    `x` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景坐标x',
    `y` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景坐标y',
    `path_find` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否需要寻路',
    `display_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '显示完成数量，0显示need_num',
    `is_guide` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否需要引导',
    `fin` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '是否已经完成',
    `now_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '当前数量',
    PRIMARY KEY (`role_id`,`task_id`,`stage`,`cid`),
    KEY `task_id` (`task_id`,`stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色日清任务列表(合服合并)';

CREATE TABLE IF NOT EXISTS `task_bag_clear` (
    `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
    `task_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务id',
    `trigger_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '触发时间',
    `stage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '当前阶段',
    `edstage` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '结束阶段',
    `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '任务类型',
    `lv` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '任务等级',
    PRIMARY KEY (`role_id`,`task_id`),
    KEY `task_id` (`task_id`),
    KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色日清任务列表(合服合并)';

insert into `task_bag_clear`(`role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv`) 
    select `role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv` from `task_bag` where `type` in (6,7,8,9);

insert into `task_bag_content_clear`(`role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`,
 `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num`) 
    select `role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`,
 `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num` from `task_bag_content` where `type` in (6,7,8,9);


delete from `task_bag` where `type` in (6,7,8,9);

delete from `task_bag_content` where `type` in (6,7,8,9);