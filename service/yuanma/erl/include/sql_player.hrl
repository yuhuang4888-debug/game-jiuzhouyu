%%%------------------------------------------------
%%% File    : sql_player.hrl
%%% Author  : xyao
%%% @Email  : jiexiaowen@gmail.com
%%% Created : 2011-12-07
%%% Description: 角色系统sql文件
%%%------------------------------------------------

%% 根据角色名称查找ID
-define(sql_role_id_by_name,<<"select id from player_low where nickname = '~s' limit 1">>).

%% 根据角色Id来查询角色Id是否存在
-define(sql_role_id_exist,<<"select id from player_low where id = '~p' limit 1">>).

%% 根据角色ID查找角色名称
-define(sql_role_name_by_id,<<"select nickname from player_low where id = '~w' limit 1">>).

%% 根据角色ID查看角色性别
-define(sql_role_sex_by_id,<<"select sex from player_low where id = '~w' limit 1">>).

%% 根据id查找账户名称
-define(sql_role_accname_by_id,<<"select accname from player_login where id = ~w limit 1">>).

%% 根据账户名称查找最后创建的角色Id
-define(SQL_ROLE_LAST_ID, <<"select id from player_login where accid='~w' and accname = '~s' order by reg_time desc">>).

%% 根据账户名称查找角色个数
-define(sql_role_any_id_by_accname,<<"select id from player_login where accname = '~s'">>).

%% 获取玩家最高等级
-define(sql_role_max_lv,<<"select max(lv) from player_low">>).

%% 根据角色ID查找角色创建时间
-define(sql_role_reg_time_by_id,<<"select reg_time from player_login where id = '~w' limit 1">>).

%% --------------------------------------- 登录 ----------------------------------------------------------------------------------------------
%% 获取player_login登陆所需数据
-define(sql_player_login_data,<<"select `gm`, `talk_lim`, `talk_lim_time`, `last_logout_time`, `talk_lim_right`, `reg_time`, `source`, `last_login_time`,`come_back_state`, `mark`, `accname_sdk`, `first_state` from `player_login` where id=~w limit 1">>).

%% 获取player_high登陆所需数据
-define(sql_player_high_data,<<"select `gold`, `bgold`, `coin`, `gcoin`, `exp`, `hightest_combat_power` from `player_high` where id=~w limit 1">>).

%% 获取player_low登陆所需数据
-define(sql_player_low_data,<<"select `nickname`, `sex`, `lv`, `career`, `realm`, `picture`, `picture_lim`, `picture_ver`, `c_rename`, `c_rename_time`, `c_recareer_time` from `player_low` where id=~w  limit 1">>).

%% 获取player_state登陆所需数据
-define(sql_player_state_data,<<"select `scene`, `x`, `y`, `hp`, `quickbar`, `pk_value`, `pk_status`, `pk_status_change_time`, `skill_extra_point`, `pk_value_change_time`, `last_task_id`, `last_be_kill` from `player_state` where id=~w limit 1">>).

%% 获取player_attr登陆所需数据
-define(sql_player_attr_data,<<"select `cell_num`, `storage_num`, `god_bag_num` from player_attr where id=~p limit 1">>).

%%更新高频数据
-define(sql_update_player_high,<<"update `player_high` set `gold`=~p, `bgold`=~p, `coin`=~p, `gcoin`=~p, `exp`=~p where id=~p">>).
-define(sql_update_player_exp, <<"update `player_high` set `exp`=~p where id=~p">>).
%%更新货币
-define(sql_update_player_money, <<"update `player_high` set `gold`=~p, `bgold`=~p, `coin`=~p, `gcoin`=~p where id=~w">>).

%% 获取玩家货币
-define(sql_player_money_data,   <<"select `gold`, `bgold`, `coin`, `gcoin` from `player_high` where id=~w limit 1 ">>).

%% 玩家的状态
-define(sql_update_player_state,<<"update `player_state` set `scene`=~p, `x`=~p, `y`=~p, `hp`=~p, `quickbar`='~s', `pk_value` = ~p, `pk_status` = ~p, `pk_status_change_time` = ~p, `pk_value_change_time` = ~p, `last_combat_power` = ~p, `last_be_kill` = ~p, last_task_id=~w where id=~w">>).

%% 更新快捷栏
-define(sql_update_player_quickbar, <<"update `player_state` set `quickbar`='~s' where id=~p">>).

%% 取得指定帐号的角色列表
-define(sql_role_list,<<"select n.id, n.status, w.nickname, w.sex, w.lv, w.career, w.realm, coalesce(t.turn, 0), w.picture, w.picture_ver from player_login as n left join player_low as w on n.accid=~p and n.accname='~s' left join reincarnation as t on t.role_id = w.id where w.id = n.id ">>).

%% 取得指定账号的角色数
-define(sql_role_count, <<"select count(id) from player_login where accid=~p and accname='~s'">>).

%% 根据id查找登陆所需信息
-define(sql_player_login_by_id,<<"select `accname`, `status` from `player_login` where `id` = ~p limit 1">>).

%% 更新登陆需要的记录
-define(sql_update_login_data, <<"update `player_login` set `last_login_time`= ~w, `last_login_ip`  = '~s', `online_flag`=1 where id = ~w">>).
-define(sql_update_login_offline, <<"update `player_login` set `last_logout_time`= ~w, `online_flag`=0 where id = ~w">>).
-define(sql_update_coin_offline, <<"update `player_high` set `coin`= ~w where id = ~w">>).
-define(sql_update_reg_time, <<"update `player_login` set `reg_time`=~w where id=~w">>).

%% 更新成离线挂机状态
-define(sql_update_line_flag, <<"update `player_login` set `online_flag`=~p where id = ~w">>).

%% 注册角色
%% 更新登陆需要的记录
-define(sql_insert_player_login_one,<<"insert into `player_login` (id, accid, accname, accname_sdk, reg_time, reg_ip, source, server_id) values (~w, ~w,'~s','~s',~w,'~s','~s','~w')">>).
-define(sql_insert_player_high_one, <<"insert into `player_high` (id) values (~w)">>).
-define(sql_insert_player_low_one,  <<"insert into `player_low` (id, `nickname`, `sex`, `lv`, `career`, `realm`, `picture`) values (~w, '~s', ~w, ~w, ~w, ~w, '~s')">>).
-define(sql_insert_player_state_one,<<"insert into `player_state` (id, scene, x, y, hp, mp) values (~w, ~w, ~w, ~w, ~w, ~w)">>).
-define(sql_insert_player_attr_one, <<"insert into `player_attr` (`id`, `cell_num`, `storage_num`) values (~p, ~p, ~p)">>).

%% 同帐号信息
-define(sql_insert_acc_share_data,
        <<"replace into `acc_share_data` (`accid`, `accname`) values (~w, '~s')">>).
-define(sql_select_acc_share_data,
        <<"select `come_back_state` from `acc_share_data` where `accid`=~w and `accname`='~s'">>).
-define(sql_update_come_back_acc_share_data,
        <<"update `come_back_state` set `come_back_state`=~p where `accid`=~w and `accname`='~s'">>).
-define(sql_replace_acc_share_data,
        <<"replace into `acc_share_data` set `accid`=~w, `accname`='~s', `come_back_state`=~p">>).

%% 登录时间
-define(sql_player_last_login_time, <<"select last_login_time from player_login  where id=~p limit 1">>).
-define(sql_update_hightest_combat_power,<<"update `player_high` set `hightest_combat_power`= ~p where `id`= ~p">>).

-define(sql_update_picture_lim, <<"update `player_low` set `picture_lim`=~p where `id`=~p ">>).
%% 更新玩家头像的信息
-define(sql_update_picture_info, <<"update `player_low` set `picture`='~s', `picture_ver`=~p where id = ~p">>).
%% 查找玩家的图片信息
-define(sql_player_picture_by_role_id, <<"select `picture`, `picture_ver` from `player_low` where `id`=~p limit 1">>).

%% ----------------------------------------------------------------
%% pk状态保留
%% ----------------------------------------------------------------

-define(sql_role_pk_status_select, <<"SELECT scene_id, pk_status FROM role_pk_status WHERE role_id = ~p">>).
-define(sql_role_pk_status_replace, <<"REPLACE INTO role_pk_status(role_id, scene_id, pk_status) VALUES(~p, ~p, ~p)">>).

%% ----------------------------------------------------------------
%% 离线事件
%% ----------------------------------------------------------------
-define(sql_offline_event_select, <<"SELECT module_id, event_id, data_list, time FROM offline_event_data WHERE player_id = ~p">>).
-define(sql_offline_event_replace, <<"REPLACE INTO offline_event_data(player_id, module_id, event_id, data_list, time) VALUES(~p, ~p, ~p, '~s', ~p)">>).
-define(sql_offline_event_delete, <<"delete FROM offline_event_data WHERE player_id = ~p">>).