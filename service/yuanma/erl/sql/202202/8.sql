create table if not exists `fiesta` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    fiesta_id smallint unsigned not null default 0 comment '祭典唯一id',
    act_id tinyint unsigned not null default 0 comment '活动id',
    type tinyint unsigned not null default 0 comment '祭典开通类型',
    lv smallint unsigned not null default 0 comment '当前祭典等级',
    exp int unsigned not null default 0 comment '当前累计经验',
    begin_time int unsigned not null default 0 comment '开始时间戳',
    expired_time int unsigned not null default 0 comment '过期时间戳',
    primary key (role_id)
) engine=InnoDB default charset=utf8 comment='玩家祭典信息表(合服合并)';

create table if not exists `fiesta_reward` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    lv smallint unsigned not null default 0 comment '祭典等级',
    status1 tinyint unsigned not null default 0 comment '普通奖励领取状态',
    status2 tinyint unsigned not null default 0 comment '高级奖励领取状态',
    primary key (role_id, lv)
) engine=InnoDB default charset=utf8 comment='玩家祭典奖励信息表(合服合并)';

create table if not exists `fiesta_task` (
    role_id bigint unsigned not null default 0 comment '玩家id',
    type tinyint unsigned not null default 0 comment '任务类型',
    task_id smallint unsigned not null default 0 comment '任务id',
    finish_times tinyint unsigned not null default 0 comment '已完成次数',
    cur_num int unsigned not null default 0 comment '当前单任务进度',
    status tinyint unsigned not null default 0 comment '经验奖励状态',
    acc_times tinyint unsigned not null default 0 comment '累积未领取次数',
    primary key (role_id, type, task_id)
) engine=InnoDB default charset=utf8 comment='玩家祭典任务信息表(合服合并)';

create table if not exists `log_fiesta` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    reg_day smallint unsigned not null default 0 comment '注册天数',
    role_lv smallint unsigned not null default 0 comment '玩家等级',
    fiesta_id smallint unsigned not null default 0 comment '祭典id',
    act_id tinyint unsigned not null default 0 comment '活动id',
    type tinyint unsigned not null default 0 comment '开通类型',
    begin_time int unsigned not null default 0 comment '开始时间',
    expired_time int unsigned not null default 0 comment '过期时间',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id)
) engine=InnoDB default charset=utf8 comment='(高级)祭典开启日志(偏移量)';

create table if not exists `log_fiesta_task_progress` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    task_type tinyint unsigned not null default 0 comment '任务类型',
    task_id smallint unsigned not null default 0 comment '任务id',
    progress int unsigned not null default 0 comment '任务进度',
    status tinyint unsigned not null default 0 comment '领取状态',
    acc_times tinyint unsigned not null default 0 comment '累积未领取次数',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, task_id)
) engine=InnoDB default charset=utf8 comment='祭典任务日志(偏移量)';

create table if not exists `log_fiesta_task_reward` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    task_id smallint unsigned not null default 0 comment '任务id',
    oexp int unsigned not null default 0 comment '领取前经验',
    nexp int unsigned not null default 0 comment '领取后经验',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, task_id)
) engine=InnoDB default charset=utf8 comment='祭典任务奖励日志(偏移量)';

create table if not exists `log_fiesta_reward` (
    id int unsigned not null auto_increment comment '序号',
    role_id bigint unsigned not null default 0 comment '玩家id',
    fiesta_id smallint unsigned not null default 0 comment '祭典id',
    lv smallint unsigned not null default 0 comment '祭典等级',
    rewards varchar(100) not null default '[]' comment '奖励列表',
    time int unsigned not null default 0 comment '时间',
    primary key (id) using btree,
    index(role_id),
    index(role_id, fiesta_id)
) engine=InnoDB default charset=utf8 comment='祭典奖励日志(偏移量)';

alter table log_fiesta_task_progress add column finish_times tinyint unsigned not null default 0 comment '完成次数' after progress;

alter table log_fiesta add index(time);
alter table log_fiesta_task_progress add index(time);
alter table log_fiesta_task_reward add index(time);
alter table log_fiesta_reward add index(time);