-- 头像其他表数据修改
update champion_kf_team_3v3_role set picture = 90 where picture < 90;
update champion_kf_team_3v3_role set picture = picture % 10 + 90 where picture >= 90;

update drumwar_result set picture = 90 where picture < 90;
update drumwar_result set picture = picture % 10 + 90 where picture >= 90;

update drumwar_sign set picture = 90 where picture < 90;
update drumwar_sign set picture = picture % 100 + 90 where picture >= 100;

update kf_3v3_bf_rank_info set picture = 90 where picture < 90;
update kf_3v3_bf_rank_info set picture = picture % 100 + 90 where picture >= 100;

update kf_draw_log set picture = 90 where picture < 90;
update kf_draw_log set picture = picture % 100 + 90 where picture >= 100;

update marriage_personals_player set picture = 90 where picture < 100;
update marriage_personals_player set picture = picture % 100 + 90 where picture >= 100;

update monday_draw_record set picture = 90 where picture < 90;
update monday_draw_record set picture = picture % 100 + 90 where picture >= 100;

update seacraft_apply set picture = 90 where picture < 90;
update seacraft_apply set picture = picture % 100 + 90 where picture >= 100;

update seacraft_guild set picture = 90 where picture < 90;
update seacraft_guild set picture = picture % 100 + 90 where picture >= 100;

update seacraft_job set picture = 90 where picture < 90;
update seacraft_job set picture = picture % 100 + 90 where picture >= 100;

update team_3v3_role set picture = 90 where picture < 90;
update team_3v3_role set picture = picture % 100 + 90 where picture >= 100;

-- 补丁管理进程kv表
CREATE TABLE IF NOT EXISTS `fix_var_kv` (
  `key` int(11) unsigned NOT NULL COMMENT '键',
  `value` varchar(1024) NOT NULL DEFAULT '0' COMMENT '值',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='补丁修复键值表';