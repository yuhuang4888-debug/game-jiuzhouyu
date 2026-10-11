create table if not exists role_dragon_ball_status (
    role_id bigint unsigned not null comment '玩家id',
    statue tinyint unsigned not null comment '雕像激活状态',
    figure_id int unsigned not null default 0 comment '神龙附体形象id',
    figure_list varchar(255) not null default '[]' comment '神龙附体形象激活列表',
    primary key (role_id)
) engine=InnoDB default charset=utf8 comment='玩家龙珠综合状态';

alter table role_dragon_ball_status change figure_id figure_type int unsigned not null default 0 comment '神龙附体形象id';

ALTER TABLE `role_dragon_ball_status`
ADD COLUMN `nuclear_buy`  varchar(255) NOT NULL DEFAULT '[]' COMMENT '星核直购' AFTER `figure_list`;
