alter table boss_remind add column remind tinyint unsigned not null default 0 comment '是否关注';
alter table boss_remind add column auto_remind tinyint unsigned not null default 1 comment '是否可以自动关注';

alter table special_boss_info add column auto_remind tinyint unsigned not null default 1 comment '是否可以自动关注';