ALTER TABLE player_weekly_card ADD reward_list varchar(1023) DEFAULT '[]' NOT NULL comment '奖励列表';
ALTER TABLE log_weekly_card_info ADD reward_list varchar(1023) DEFAULT '[]' NOT NULL COMMENT '奖励列表';
ALTER TABLE log_weekly_card_info CHANGE reward_list reward_list varchar(1023) DEFAULT '[]' NOT NULL COMMENT '奖励列表' AFTER new_sum_num;