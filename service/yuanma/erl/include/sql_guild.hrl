%% ---------------------------------------------------------------------------
%% @doc sql_guild.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-27
%% @deprecated 公会数据库
%% ---------------------------------------------------------------------------

%% ---------------------------
%% status_guild 所需
%% ---------------------------

-define(sql_guild_member_select_login, <<"select guild_id, position, create_time from guild_member where id = ~p">>).
-define(sql_guild_select_login, <<"select name, lv, realm from guild where id = ~p">>).
% -define(sql_guild_select_player_guild, <<"select receive_salary_time from player_guild where id = ~p">>).
% -define(sql_guild_update_receive_salary_time, <<"update player_guild set receive_salary_time = ~p where id = ~p">>).
-define(sql_insert_null_player_guild, <<"insert into player_guild(id) values(~p)">>).

%% ---------------------------
%% 公会记录所需sql
%% ---------------------------

-define(sql_guild_select_all, <<"
    select
        id, name, tenet, announce, modify_times, modify_time, chief_id, chief_name, lv, realm, gfunds, growth_val, gactivity, dun_score,
        create_time, approve_type, auto_approve_lv, auto_approve_power, disband_warnning_time, c_rename, guild_c_rename_time
    from guild">>).

-define(sql_guild_insert, <<"
    insert into
        guild(id, name, tenet, announce, chief_id, chief_name, lv, realm, create_time,
        approve_type, auto_approve_lv, auto_approve_power, disband_warnning_time)
    values(~p, '~s', '~s', '~s', ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_guild_update_tenet, <<"update guild set tenet='~s' where id=~p">>).
-define(sql_guild_update_announce, <<"update guild set announce='~s' where id=~p">>).
-define(sql_guild_update_approve, <<"update guild set approve_type=~p, auto_approve_lv=~p, auto_approve_power=~p where id=~p">>).
-define(sql_guild_update_chief, <<"update guild set chief_id=~p, chief_name='~s' where id=~p">>).
-define(sql_guild_update_gfunds, <<"update guild set gfunds=~p where id=~p">>).
-define(sql_guild_update_gactivity, <<"update guild set gactivity=~p where id=~p">>).
-define(sql_guild_update_guild_dun_score, <<"update guild set dun_score=~p where id=~p">>).
-define(sql_guild_update_gfunds_activity, <<"update guild set gfunds=~p, gactivity=~p where id=~p">>).
-define(sql_guild_update_create_time, <<"update guild set create_time=~p where id = ~p">>).
-define(sql_guild_update_realm, <<"update guild set realm=~p where id = ~p">>).

-define(sql_guild_delete_by_guild_id, <<"delete from guild where id = ~p">>).
-define(sql_guild_update_lv_and_funds, <<"update guild set lv = ~p, gfunds = ~p where id = ~p">>).
-define(sql_guild_update_growth_val, <<"update guild set growth_val = ~p where id = ~p">>).
-define(sql_guild_update_lv_and_growth_val, <<"update guild set lv = ~p, growth_val = ~p where id = ~p">>).
-define(sql_guild_reset_announce_modify_times, <<"update guild set modify_times = 0">>).
-define(sql_guild_update_announce_modify_times, <<"update guild set modify_times = ~p where id = ~p">>).
-define(sql_guild_update_announce_and_modify_times, <<"update guild set announce='~s', modify_times = ~p where id = ~p">>).
-define(sql_guild_update_announce_and_modify_times_and_time, <<"update guild set announce='~s', modify_times = ~p, modify_time=~p where id = ~p">>).
-define(sql_guild_update_disband_warnning_time, <<"update guild set disband_warnning_time = ~p where id = ~p">>).
-define(sql_guild_reset_activity, <<"update guild set gactivity = 0, dun_score = 0">>).

%% ---------------------------
%% 公会成员记录所需sql
%% ---------------------------

-define(sql_guild_member_select_by_guild_id, <<"
    select
        id, guild_name, position, donate, historical_donate, depot_score, create_time
    from guild_member where guild_id = ~p">>).

-define(sql_guild_member_select_by_role_id, <<"
    select donate, historical_donate, depot_score
    from guild_member
    where id = ~p
">>).

-define(sql_guild_member_insert, <<"
    insert into
        guild_member(id, guild_id, guild_name, position, donate, create_time)
    values(~p, ~p, '~s', ~p, ~p, ~p)">>).

-define(sql_guild_member_replace, <<"
    replace into guild_member
    (id, guild_id, guild_name, position, donate, historical_donate, depot_score, create_time)
    values(~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p)
">>).

-define(sql_guild_member_delete, <<"delete from guild_member where id = ~p">>).
-define(sql_guild_member_delete_by_guild_id, <<"delete from guild_member where guild_id = ~p">>).

%% 常规退出公会(个人贡献不清理)
-define(sql_guild_member_clear_by_guild_id, <<"
    update guild_member
    set guild_id = 0, position = 0, depot_score = 0, create_time = 0
    where guild_id = ~p
">>).

-define(sql_guild_member_clear_by_role_id, <<"
    update guild_member
    set guild_id = 0, position = 0, depot_score = 0, create_time = 0
    where id = ~p
">>).

%% 公会合并导致退出公会(个人贡献和仓库积分不清理)
-define(sql_guild_member_clear_by_guild_merge, <<"
    update guild_member
    set guild_id = 0, position = 0
    where guild_id = ~p
">>).

-define(sql_guild_member_update_position, <<"update guild_member set position = ~p where id = ~p">>).
-define(sql_guild_member_update_donate,
    <<"update guild_member set donate = ~p, historical_donate = ~p where id = ~p">>).
-define(sql_guild_member_update_depot_score,
    <<"update guild_member set depot_score = ~p where id = ~p">>).

%% ---------------------------
%% 公会设置
%% ---------------------------

-define(sql_guild_setting_select, <<"select id, setting from guild_setting where type=~p">>).
-define(sql_guild_setting_replace, <<"replace into guild_setting (id, type, setting) values (~p, ~p, '~s')">>).
-define(sql_guild_setting_update, <<"update guild_setting set setting='~s' where id=~p and type=~p">>).

%% ---------------------------
%% 公会申请
%% ---------------------------

-define(sql_guild_apply_replace, <<"insert into guild_apply(role_id, guild_id, create_time) values(~p, ~p, ~p)">>).
-define(sql_guild_apply_select, <<"select role_id, guild_id, create_time from guild_apply">>).

-define(sql_guild_apply_delete_by_guild_id, <<"delete from guild_apply where guild_id = ~p">>).
-define(sql_guild_apply_delete_by_role_id, <<"delete from guild_apply where role_id = ~p">>).
-define(sql_guild_apply_delete_by_key, <<"delete from guild_apply where role_id = ~p and guild_id = ~p">>).
-define(sql_guild_apply_delete_by_create_time, <<"delete from guild_apply where create_time <= ~p">>).

%% ---------------------------
%% 公会职位名字
%% ---------------------------
-define(sql_position_name_select, <<"select position, position_name from guild_position_name where guild_id = ~p">>).
-define(sql_position_name_select_by_position, <<"select position_name from guild_position_name where guild_id = ~p AND position = ~p">>).
-define(sql_position_name_delete, <<"delete from guild_position_name where guild_id = ~p">>).
-define(sql_position_name_delete_by_key, <<"delete from guild_position_name where guild_id = ~p and position = ~p">>).
-define(sql_position_name_replace, <<"replace into guild_position_name(guild_id, position, position_name) values(~p, ~p, '~s')">>).

-define(sql_position_name_delete_by_guild_id, <<"delete from guild_position_name where guild_id = ~p">>).

%% ---------------------------
%% 公会职位权限
%% ---------------------------
-define(sql_position_permission_select, <<"select position, permission_type, is_allow from guild_position_permission where guild_id = ~p">>).
-define(sql_position_permission_delete, <<"delete from guild_position_permission where guild_id = ~p">>).
-define(sql_position_permission_replace, <<"
    replace into guild_position_permission(guild_id, position, permission_type, is_allow) values(~p, ~p, ~p, ~p)"
    >>).

-define(sql_position_permission_by_guild_id, <<"delete from guild_position_permission where guild_id = ~p">>).

%%--------------------------------------------------
%% 公会仓库
%%--------------------------------------------------
-define(sql_guild_depot_goods_select,
    <<"select id, guild_id, goods_id, num, color, addition, extra_attr, create_time from guild_depot_goods">>).
-define(sql_guild_depot_insert,
    <<"insert into guild_depot_goods(id, guild_id, goods_id, num, color, addition, extra_attr, create_time)
    values(~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p)">>).
-define(sql_update_guild_depot_goods_num,
    <<"update guild_depot_goods set num = ~p where id = ~p">>).
-define(sql_delete_guild_depot_goods,
    <<"delete from guild_depot_goods where id = ~p">>).
-define(sql_delete_guild_depot_more,
    <<"delete from guild_depot_goods where id in (~s)">>).
-define(sql_delete_guild_depot_by_guild_id,
    <<"delete from guild_depot_goods where guild_id = ~p">>).

%%--------------------------------------------------
%% 公会技能
%%--------------------------------------------------
-define(sql_player_guild_skill_select,
    <<"select skill_id, lv from player_guild_skill where role_id = ~p">>).
-define(sql_guild_skill_select,
    <<"select guild_id, skill_id, lv from guild_skill">>).
-define(sql_guild_skill_insert,
    <<"insert into guild_skill(guild_id, skill_id, lv) values(~p, ~p, ~p)">>).
-define(sql_update_guild_skill_lv,
    <<"update guild_skill set lv = ~p where guild_id = ~p and skill_id = ~p">>).
-define(sql_delete_guild_skill_by_guild_id,
    <<"delete from guild_skill where guild_id = ~p">>).
-define(sql_update_player_guild_skill_lv,
    <<"replace into player_guild_skill(role_id, skill_id, lv) values(~p, ~p, ~p)">>).

%%--------------------------------------------------
%% 公会合并
%%--------------------------------------------------
-define(sql_guild_merge_select, <<"
    select apply_gid, target_gid, master_gid, status, apply_time, agree_time
    from guild_merge
">>).

-define(sql_guild_merge_insert, <<"
    insert into guild_merge
    (apply_gid, target_gid, master_gid, status, apply_time)
    values (~p, ~p, ~p, ~p, ~p)
">>).

-define(sql_guild_merge_delete, <<"
    delete from guild_merge
    where apply_gid = ~p and target_gid = ~p
">>).

-define(sql_guild_merge_delete2, <<"
    delete from guild_merge
    where apply_gid = ~p or target_gid = ~p
">>).

-define(sql_guild_merge_update_status, <<"
    update guild_merge
    set status = ~p, agree_time = ~p
    where apply_gid = ~p and target_gid = ~p
">>).