update sanctuary_kf_role set paied = 0 ,clear_time =  1646596800;

alter table role_wx_subscribe add column role_id bigint(20) unsigned not null default 0 comment '玩家id' after temp_id;
alter table role_wx_subscribe drop primary key;
alter table role_wx_subscribe modify sh_uid varchar(100);
alter table role_wx_subscribe add primary key (sh_uid, temp_id);