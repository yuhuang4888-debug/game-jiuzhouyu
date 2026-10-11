alter table log_dungeon_exp_gain add column mon_exp bigint unsigned not null default 0 comment '杀怪经验' after exp;
alter table log_dungeon_exp_gain add column ratio1 float unsigned not null default 0 comment '初始杀怪倍率' after mon_exp;
alter table log_dungeon_exp_gain add column ratio2 float unsigned not null default 0 comment '最后杀怪倍率' after ratio1;

alter table `player_login` add column `first_state` tinyint(1) not null default 0 comment '账户首个角色|0未确定，1是，2否';

create table if not exists `role_envelope_rebate` (
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `is_quality` tinyint(1) unsigned not null default 0 comment '是否有资格参加' ,
    `start_time` int(11) unsigned not null default 0 comment '开始时间',
    `end_time` int(11) unsigned not null default 0 comment '结束时间',
    `login_day_list` varchar(1024) not null default '[]' comment '登录日列表',
    `last_login_time` int(11) unsigned not null default 0 comment '上次登录时间',
    `login_money` int(11) unsigned not null default 0 comment '累计登录红包（分）',
    `recharge_money` int(11) unsigned not null default 0 comment '累计返利红包（分）',
    `login_envelope_ids` varchar(1024) not null default '[]' comment '累计登录红包ID',
    `recharge_envelope_ids` varchar(1024) not null default '[]' comment '累计返利红包ID',
    `login_lock` tinyint(1) unsigned not null default 0 comment '登录红包提现锁' ,
    `recharge_lock` tinyint(1) unsigned not null default 0 comment '返利红包提现锁' ,
    primary key (`type`, `sub_type`, `role_id`)
) engine=InnoDB default charset=utf8 comment='红包返利玩家信息';

create table if not exists `log_envelope_rebate_withdrawal` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `envelope_type` tinyint(1) unsigned not null default 0 comment '红包类型|1登录红包，2返利红包',
    `envelope_ids` varchar(1025) not null default '[]' comment '提现的红包列表',
    `envelope_value` int(11) unsigned not null default 0 comment '提现红包金额（分）',
    `status` tinyint(1) unsigned not null default 0 comment '提现状态|0提现中，1提现成功，2提现失败',
    `time` int(11) unsigned not null default 0 comment '时间',
    primary key (`id`),
    index(`type`, `sub_type`, `role_id`, `time`),
    index(`role_id`, `time`)
)engine=InnoDB default charset=utf8 comment='红包返利提现日志';


create table if not exists `log_envelope_rebate_reward` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `type` smallint(6) unsigned not null default 0 comment '活动类型',
    `sub_type`smallint(6) unsigned not null default 0 comment '活动子类型',
    `role_id` bigint(20) unsigned not null default 0 comment '玩家ID',
    `envelope_type` tinyint(1) unsigned not null default 0 comment '红包类型|1登录红包，2返利红包',
    `envelope_id` smallint(6) unsigned not null default 0 comment '红包ID',
    `envelope_value` int(11) unsigned not null default 0 comment '红包增加金额（分）',
    `envelope_sum` int(11) unsigned not null default 0 comment '红包总金额（分）',
    `time` int(11) unsigned not null default 0 comment '时间',
    primary key (`id`),
    index(`type`, `sub_type`, `role_id`, `time`),
    index(`role_id`, `time`)
)engine=InnoDB default charset=utf8 comment='红包返利金额增加日志';
