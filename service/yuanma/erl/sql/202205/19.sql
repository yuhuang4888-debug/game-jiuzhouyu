CREATE TABLE if NOT EXISTS `beings_gate_activity` (
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Id',
  `yesterday` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '前一天活跃度',
  `today` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活跃度',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活跃度更新时间',
  PRIMARY KEY (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='众生之门活跃度信息（合服合并）';

CREATE TABLE if NOT EXISTS `beings_gate_activity_cls` (
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Id',
  `yesterday` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '前一天活跃度',
  `today` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活跃度',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活跃度更新时间',
  PRIMARY KEY (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='众生之门活跃度跨服信息';

CREATE TABLE if NOT EXISTS `log_beings_gate_activity_cls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `zone_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '区Id',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '组Id',
  `mod` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模式',
  `yesterday_activity` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '昨日活跃度',
  `activity_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `portal_list` varchar(1023) NOT NULL DEFAULT '' COMMENT '传送门',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `log_beings_gate_activity_cls_zone_id_IDX` (`zone_id`) USING BTREE,
  KEY `log_beings_gate_activity_cls_group_id_IDX` (`group_id`) USING BTREE,
  KEY `log_beings_gate_activity_cls_mod_IDX` (`mod`) USING BTREE,
  KEY `log_beings_gate_activity_cls_time_IDX` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='众生之门活动跨服日志（偏移量）';

CREATE TABLE if NOT EXISTS `log_beings_gate_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `server_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务器Id',
  `yesterday_activity` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '昨日的活跃度',
  `portal_list` varchar(1023) NOT NULL DEFAULT '' COMMENT '传送门',
  `activity_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `log_beings_gate_activity_time_IDX` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='众生之门活动本服日志（偏移量）';

create table if not exists `log_night_ghost_boss` (
    id int unsigned not null auto_increment comment '自增id',
    zone_id tinyint not null default 0 comment '区域id',
    group_id smallint not null default 0 comment '分组id',
    scene_id int not null default 0 comment '场景id',
    boss_id int not null default 0 comment 'bossid',
    x int not null default 0 comment '坐标x',
    y int not null default 0 comment '坐标y',
    type tinyint not null default 0 comment '事件类型',
    time int unsigned not null default 0 comment '时间戳',
    primary key (id)
) engine=InnoDB default charset=utf8 comment='百鬼夜行boss生成死亡日志(偏移量)';

create table if not exists `log_night_ghost_rank` (
    id int unsigned not null auto_increment comment '自增id',
    zone_id tinyint not null default 0 comment '区域id',
    group_id smallint not null default 0 comment '分组id',
    scene_id int not null default 0 comment '场景id',
    boss_id int not null default 0 comment 'bossid',
    sign tinyint not null default 0 comment '参与形式',
    sign_id bigint not null default 0 comment '参与id(队伍id/个人id)',
    ser_id int not null default 0 comment '服务器id',
    role_id bigint not null default 0 comment '玩家id',
    rank smallint not null default 0 comment '排名',
    hurt bigint not null default 0 comment '伤害值',
    time int unsigned not null default 0 comment '时间戳',
    primary key (id)
) engine=InnoDB default charset=utf8 comment='百鬼夜行boss排名日志(偏移量)';

create table if not exists `log_night_ghost_killer` (
    id int unsigned not null auto_increment comment '自增id',
    zone_id tinyint not null default 0 comment '区域id',
    group_id smallint not null default 0 comment '分组id',
    scene_id int not null default 0 comment '场景id',
    boss_id int not null default 0 comment 'bossid',
    ser_id int not null default 0 comment '服务器id',
    team_id bigint not null default 0 comment '队伍id',
    role_id bigint not null default 0 comment '玩家id',
    time int unsigned not null default 0 comment '时间戳',
    primary key (id)
) engine=InnoDB default charset=utf8 comment='百鬼夜行boss尾刀日志(偏移量)';

create table if not exists `log_night_ghost_reward` (
    id int unsigned not null auto_increment comment '自增id',
    role_id bigint not null default 0 comment '玩家id',
    type tinyint not null default 0 comment '奖励类型',
    rank smallint not null default 0 comment '排名',
    rewards varchar(100) not null default '[]' comment '奖励列表',
    time int unsigned not null default 0 comment '时间戳',
    primary key (id)
) engine=InnoDB default charset=utf8 comment='百鬼夜行奖励日志(偏移量)';

alter table log_night_ghost_boss add index(zone_id, group_id, scene_id);
alter table log_night_ghost_boss add index(`time`);

alter table log_night_ghost_rank add index(zone_id, group_id, scene_id);
alter table log_night_ghost_rank add index(role_id);
alter table log_night_ghost_rank add index(`time`);

alter table log_night_ghost_killer add index(zone_id, group_id, scene_id);
alter table log_night_ghost_killer add index(role_id);
alter table log_night_ghost_killer add index(`time`);

alter table log_night_ghost_reward add index(role_id);
alter table log_night_ghost_reward add index(`time`);

alter table `role_afk` add column `all_afk_utime` int(11) unsigned not null default 0 comment '挂机总时间';
alter table role_afk add column `back_time` int(11) unsigned not null default 0 comment '能找回的时间';
alter table role_afk add column `back_exp` BIGINT(20) unsigned not null default 0 comment '能找回的经验';
alter table role_afk add column `had_back_time` int(11) unsigned not null default 0 comment '已找回的经验';

alter table role_boss add column vit_add_today int unsigned not null default 0 comment '当天恢复的体力值数' after vit;
alter table role_boss add column vit_can_back int unsigned not null default 0 comment '当天可找回的体力值数' after vit_add_today;