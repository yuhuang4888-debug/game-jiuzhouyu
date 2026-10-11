alter table sanctuary_kf_construction add column `mon_ids` varchar(1023) DEFAULT '[]' NOT NULL COMMENT '未击杀的怪物ID列表';
alter table sanctuary_kf_construction add column `last_stop_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上次持久化怪物ID的时间';
alter table sanctuary_kf_construction add column `server_score_list` varchar(1023) DEFAULT '[]' NOT NULL COMMENT '区服占领值列表';
alter table sanctuary_kf_construction add column `role_receives` varchar(2048) DEFAULT '[]' NOT NULL COMMENT '占领礼包的领取情况';
alter table sanctuary_kf_construction add column `last_bl_server` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上次的归属服务器ID';