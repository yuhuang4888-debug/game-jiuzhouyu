alter table player_companion add column biography varchar(255) not null default '[]' comment '当前伙伴传记解锁等级列表' after star;

alter table role_activity_onhook_modules_behaviour add column `times` int(11) unsigned default 0 comment '次数';
