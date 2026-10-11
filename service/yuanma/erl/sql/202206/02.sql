alter table mail_attr change column `cm_attachment` `cm_attachment` varchar(20000) NOT NULL DEFAULT '[]' COMMENT '普通附件';

replace into counter (`role_id`, `module`, `sub_module`, `type`, `count`, `other`, `refresh_time`) select role_id, 300, 1, 1, 1, '[]', UNIX_TIMESTAMP() from task_log where task_id = 100980 and role_id in (select id from player_low where lv > 73);