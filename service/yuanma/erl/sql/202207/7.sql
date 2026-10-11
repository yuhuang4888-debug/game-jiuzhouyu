alter table player_enchantment_guard_rank add column `rank_combat` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '战力（非实时）';

delete from `counter_global` WHERE module = 133 and sub_module = 0 and type = 1;
truncate table `player_enchantment_guard_rank`;