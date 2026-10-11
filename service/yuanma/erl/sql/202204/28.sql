alter table marriage_personals_player add column `vip_exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '特权卡经验';

create table if not exists `guild_setting` (
    id bigint unsigned not null default 0 comment '公会id',
    type int unsigned not null default 0 comment '设置类型',
    setting varchar(255) not null default '' comment '设置值',
    primary key (id, type)
) engine=InnoDB default charset=utf8 comment='公会设置项(合服合并)';