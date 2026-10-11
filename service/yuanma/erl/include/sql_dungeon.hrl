%%------------------------------------------------------------------------------
%% @Module  : sql_dungeon.hrl
%% @Author  : HHL
%% @Email   : 
%% @Created : 2014.6.5
%% @Description: 副本系统sql文件
%%------------------------------------------------------------------------------

%%==================================================大闹天空：天空奇缘======================================================

%%--------------------------------所有副本日志数据------------------------------------
%% 查询全部副本日志.
-define(sql_dungeon_log_sel_all, 
        <<"SELECT `role_id`, `dungeon_id`, `total_count`, `pass_count`, `record_level`, `pass_time`, `gift`, `diff_level`,
        `coin`, `beat` FROM `dungeon_log` WHERE role_id=~p">>).

%% 查询副本日志表.
-define(sql_select_dungeon_log, <<"select log from dungeon_log where role_id =~p">>).

%% 代替副本日志表.
-define(sql_replace_dungeon_log, <<"replace into dungeon_log (role_id, log) values (~p, '~s')">>).

%% 更新副本日志表.
-define(sql_update_dungeon_log, <<"update dungeon_log set log='~s' where role_id=~p">>).


%% 查询指定副本id副本日志.
-define(sql_dungeon_log_sel_type, 
        <<"SELECT `role_id`, `dungeon_id`, `total_count`, `pass_count`, `record_level`, `pass_time`, `gift`,
        `diff_level` FROM `dungeon_log` WHERE `role_id` =~p AND `dungeon_id` =~p">>).

-define(sql_dungeon_log_sel_type2, 
        <<"SELECT `dungeon_id`, `record_level`, `pass_time` FROM `dungeon_log` WHERE `role_id` =~p AND `dungeon_id` =~p">>).

%% 增加全部副本日志.
-define(sql_dungeon_log_add, 
        <<"INSERT INTO `dungeon_log` (`role_id`, `dungeon_id`, `total_count`, `pass_count`, `record_level`, `pass_time`,
         `gift`, `diff_level`, `coin`, `beat`) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p,  ~p);">>).

%% 更新全部副本日志.
-define(sql_dungeon_log_upd_count, 
        <<"UPDATE `dungeon_log` SET `total_count`=~p, `pass_count`=~p, `record_level`=~p, `pass_time`=~p, `gift` =~p,
        `coin` =~p, `beat` =~p WHERE `role_id` =~p AND `dungeon_id` =~p">>).

%% 替换全部副本日志.
-define(sql_dungeon_log_upd, 
        <<"REPLACE INTO `dungeon_log` (`role_id`, `dungeon_id`, `total_count`, `pass_count`, `record_level`, `pass_time`,
        `gift`, `diff_level`, `coin`, `beat`) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).

%% 清空副本日志.
-define(sql_dungeon_log_clear,<<"truncate table `dungeon_log`">>).

%%------------------------------体力副本挂机表----------------------------------

%% 查询装备副本挂机表.
-define(sql_dun_sweep_sel, 
        <<"SELECT `id`, `dungeon_id`, `begin_time`, `exp`, `wuhun`, `finish`, `auto_num`, `shake_type`, `bgold`, `coin` FROM `dungeon_sweep` WHERE `id` =~p">>).

%% 替换装备副本挂机表.
-define(sql_dun_sweep_rep, 
        <<"REPLACE INTO `dungeon_sweep` (`id`, `dungeon_id`, `begin_time`, `exp`, `wuhun`, `finish`, `auto_num`, `shake_type`, `bgold`, `coin` ) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).



%%--------------------------------多人副本-------------------------------------
%% 更新难度
-define(sql_up_dungeon_diff_lv, 
        <<"UPDATE dungeon_log SET diff_level='~s' WHERE role_id=~p AND dungeon_id=~p">>).

%% 玩家多人副本的积分记录
-define(sql_in_mp_dun_score, 
        <<"INSERT INTO dungeon_mp_score_exchange (role_id, total_score, temp_score,  is_get_score, time)VALUES(~p, ~p, ~p, ~p, ~p)">>).

%% 多人副本更新整个数据
-define(sql_up_mp_score_goods,
        <<"UPDATE dungeon_mp_score_exchange SET total_score=~p, temp_score=~p, is_get_score=~p, time=~p WHERE role_id=~p">>).

%% 多人副本同过id获取玩家的数据
-define(sql_se_mp_dun_score, 
        <<"SELECT role_id, total_score, temp_score, is_get_score, time FROM dungeon_mp_score_exchange WHERE role_id=~p">>).

%% 多人副本所有记录
-define(sql_se_all_mp_dun_score, 
        <<"SELECt role_id, total_score, temp_score, is_get_score, time FROM dungeon_mp_score_exchange">>).



%% 宠物副本
%% 测试数据库操作
% 显示信息
-define(SQL_DUNGEON_PET_MAP_SELECT, 
    <<"select levels_info, boxes_found, mon1_level_found, mon2_level_found, traps_found, steps_used, steps_total, buff, trap, map_path, steps_add_time from dungeon_pet_map where dungeon_id=~p and player_id=~p">>).

-define(SQL_DUNGEON_PET_MAP_CHECK,
    <<"select id from dungeon_pet_map where dungeon_id=~p and player_id=~p">>).

% 插入信息(13个参数)
-define(SQL_DUNGEON_PET_MAP_INSERT,
    <<"insert into dungeon_pet_map (dungeon_id, player_id, levels_info, boxes_found, mon1_level_found, mon2_level_found, traps_found, steps_used, steps_total, buff, trap, map_path, steps_add_time) values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

% 删除信息
-define(SQL_DUNGEON_PET_MAP_DELETE, 
    <<"delete from dungeon_pet_map where dungeon_id=~p and player_id=~p">>).




%% 铜币副本的排行榜

%% 查找
-define(SQL_SELECT_COINDUN_RANK_ALL,
    <<"SELECT dun_type_id, dun_id, dun_lv, role_id, role_name, coin, time FROM dungeon_coin_rank where dun_type_id = ~p">>).

%% 更新
-define(SQL_REPLACE_COINDUN_RANK_BY_DUNID,
    <<"REPLACE INTO dungeon_coin_rank (dun_type_id, dun_id, dun_lv, role_id, role_name, coin, time) VALUES (~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).

%% 装备副本章节礼包日志
%% 查找
-define(SQL_SELECT_DUN_CHAPTER_GIFT,
    <<"SELECT role_id, chapter_id, star_num, is_get, time FROM dungeon_equip_chapter_gift where role_id = ~p">>).

%% 更新
-define(SQL_REPLACE_DUN_CHAPTER_GIFT,
    <<"REPLACE INTO dungeon_equip_chapter_gift (role_id, chapter_id, star_num, is_get, time) VALUES (~p, ~p, ~p, ~p, ~p)">>).


%% 闯关之路状态
-define(SQL_SELECT_PASS_FLOOR_BY_ID,
    <<"SELECT role_id, floor_id, is_pass, finish_list, score, less_hp, last_mon_floor_id, mon_id, mon_hp,
        mon_rule, master_career, master_name, master_content, time FROM dungeon_pass_floor WHERE role_id = ~p;">>).


%% 更新玩家闯关之路状态
-define(SQL_REPLACE_PASS_FLOOR_BY_ID,
    <<"REPLACE INTO dungeon_pass_floor(role_id, floor_id, is_pass, finish_list, score, less_hp, last_mon_floor_id,
    mon_id, mon_hp, mon_rule, master_career, master_name, master_content, time) VALUES
    (~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p);">>).


%% 更新玩家闯关之路的裁判状态
-define(SQL_UPDATE_PASS_FLOOR_BY_ID,
    <<"UPDATE dungeon_pass_floor SET last_mon_floor_id=~p, mon_id=~p, mon_hp=~p, time=~p WHERE role_id=~p">>).


%% 更新玩家闯关之路的裁判状态
-define(SQL_UPDATE_RESET_PASS_FLOOR_BY_ID,
    <<"UPDATE dungeon_pass_floor SET floor_id=~p, is_pass=~p, score=~p, less_hp=~p, last_mon_floor_id=~p,
    mon_id=~p, mon_hp=~p, mon_rule=~p, master_career=~p, master_name='~s', master_content='~s', time=~p WHERE role_id=~p">>).


%% 闯关之路排行榜floor_rank init_all
-define(SQL_SELECT_FLOOR_RANK,
    <<"SELECT role_id, name, career, power, vip, lv, picture_addr, guild_name, high_floor_id, content, time FROM dungeon_floor_rank;">>).


%% floor_rank 更新
-define(SQL_REPLACE_FLOOR_RANK,
    <<"REPLACE INTO dungeon_floor_rank(role_id, name, career, power, vip, lv, picture_addr, guild_name, high_floor_id, content, time)
    VALUES(~p, '~s', ~p, ~p, ~p, ~p, '~s', '~s', ~p, '~s', ~p);">>).


%% 神兵副本
%% 获取玩家的神兵副本数据
-define(SQL_SELECT_DUNGEON_GADARMS,
    <<"SELECT dun_lv, role_id, revive_time, role_hp, dun_time, count, is_pass, time FROM dungeon_god_arms WHERE role_id = ~p">>).


%% 神兵副本
%% 获取所有玩家的神兵副本数据
-define(SQL_SELECT_DUNGEON_GADARMS_ALL,
    <<"SELECT dun_lv, role_id, revive_time, role_hp, dun_time, count, is_pass, time FROM dungeon_god_arms">>).


%% 更新玩家的神兵副本数据
-define(SQL_REPLACE_DUNGEON_GADARMS,
    <<"REPLACE INTO dungeon_god_arms(dun_lv, role_id, revive_time, role_hp, dun_time, count, is_pass, time) VALUES
    (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p);">>).


%% 更新玩家的神兵副本的复活次数和血量
-define(SQL_UPDATE_DUNGEON_GADARMS_REVIVETIME,
    <<"UPDATE dungeon_god_arms SET revive_time=~p, role_hp=~p, time=~p WHERE dun_lv=~p AND role_id=~p">>).


%% 波数
-define(sql_role_dungeon_wave_select, <<"SELECT dun_id, cur_wave, history_wave, get_list, pass_time_list FROM role_dungeon_wave WHERE role_id = ~p">>).
-define(sql_role_dungeon_wave_select_by_dunid, <<"SELECT dun_id, cur_wave, history_wave, get_list, pass_time_list FROM role_dungeon_wave WHERE role_id = ~p and dun_id = ~p">>).
-define(sql_role_dungeon_wave_replace, <<"REPLACE INTO role_dungeon_wave(role_id, dun_id, cur_wave, history_wave, get_list, pass_time_list) VALUES(~p, ~p, ~p, ~p, '~s', '~s')">>).
-define(sql_role_dungeon_wave_clear, <<"UPDATE role_dungeon_wave SET cur_wave = 0 WHERE cur_wave > 0">>).
-define(sql_role_dungeon_wave_clear_by_role_id, <<"UPDATE role_dungeon_wave SET cur_wave = 0 WHERE role_id = ~p">>).
-define(sql_role_dungeon_wave_delete_by_role_id, <<"DELETE FROM role_dungeon_wave WHERE role_id = ~p">>).

%% 副本设置
-define(sql_role_dungeon_setting_select, <<"SELECT dun_key, type, select_type, is_open, count, other_data FROM role_dungeon_setting WHERE role_id = ~p">>).
-define(sql_role_dungeon_setting_replace, <<"REPLACE INTO role_dungeon_setting(role_id, dun_key, type, select_type, is_open, count, other_data) VALUES(~p, ~p, ~p, ~p, ~p, ~p, '~s')">>).