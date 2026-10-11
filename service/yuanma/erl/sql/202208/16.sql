alter table `role_vip` add column `vip_hide` tinyint(1) default 0 comment 'vip隐藏|0显示，1隐藏' after `vip_exp`;
