create table if not exists `guild_merge` (
    id int unsigned not null auto_increment comment '自增id',
    apply_gid bigint unsigned not null default 0 comment '提出公会id',
    target_gid bigint unsigned not null default 0 comment '目标公会id',
    master_gid bigint unsigned not null default 0 comment '主公会',
    status tinyint unsigned not null default 0 comment '申请状态',
    apply_time int unsigned not null default 0 comment '申请时间',
    agree_time int unsigned not null default 0 comment '同意时间',
    primary key (id),
    index (apply_gid),
    index (target_gid)
) engine=InnoDB default charset=utf8 comment='公会合并申请(合服合并)';