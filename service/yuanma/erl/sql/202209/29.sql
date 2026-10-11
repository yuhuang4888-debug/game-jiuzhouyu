ALTER TABLE `role_lv_act_data` 
ADD COLUMN `open_times` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动开启次数' AFTER `utime`;

ALTER TABLE `role_lv_act_data` 
ADD COLUMN `old_status` varchar(1024) NOT NULL DEFAULT '[]' COMMENT '上一轮结束时的活动状态' AFTER `open_times`;