%%-----------------------------------------------------------------------------
%% @Module  :       boss_first_blood
%% @Author  :       Fwx
%% @Created :       2018-03-16
%% @Description:    boss首杀
%%-----------------------------------------------------------------------------

-define(IS_KILLED, 1).
-define(NOT_KILLED, 0).


-record(role_info, {
    key = {0 , 0},              %% {RoleId, BossId}
    bl = 0,                     %% 归属状态
    reward_state = 0,           %% 领取状态
    utime = 0                   %% 数据更新时间
    }).

-record(boss_info, {
    boss_id = 0,
    is_killed = 0,              %% 被击杀状态
    bl_ids = [],                %% 归属玩家id
    utime = 0
}).

-record(act_state, {
    boss_map = #{},             %% #{SubType => [#boss_info{}]}
    role_map = #{}              %% #{SubType => [#role_info{}]}
    }).

-define(sql_select_boss_first_blood,
    <<"select sub_type, boss_id, is_killed, bl_ids, utime from boss_first_blood">>).
-define(sql_select_boss_first_blood_reward,
    <<"select sub_type, role_id, boss_id, bl, reward_state, utime from boss_first_blood_reward">>).
-define(sql_replace_boss_first_blood_reward,
    <<"replace into boss_first_blood_reward(sub_type, role_id, boss_id, bl, reward_state, utime)
    values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_replace_boss_first_blood,
    <<"replace into boss_first_blood(sub_type, boss_id, is_killed, bl_ids, utime)
    values(~p, ~p, ~p, '~s', ~p)">>).
-define(sql_delete_boss_first_blood,
    <<"delete from boss_first_blood where sub_type = ~p">>).
-define(sql_delete_boss_first_blood_reward,
    <<"delete from boss_first_blood_reward where sub_type = ~p">>).
