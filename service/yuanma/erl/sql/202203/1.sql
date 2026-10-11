alter table log_login add column module_power text comment '模块战力' after combat_power;
alter table log_offline add column module_power text comment '模块战力' after power;