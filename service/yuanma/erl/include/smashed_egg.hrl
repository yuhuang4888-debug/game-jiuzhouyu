%%-----------------------------------------------------------------------------
%% @Module  :       smashed_egg
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-01
%% @Description:    砸蛋
%%-----------------------------------------------------------------------------

-define(RECORD_LEN, 20).            %% 砸蛋记录长度
-define(SHOW_BEST_COUNT, 5).        %% 显示奖励最好物品的数量
-define(EGG_NUM, 4).                %% 金蛋的数量

-define(SMASHED_TYPE_ONE, 1).       %% 单个砸
-define(SMASHED_TYPE_ALL, 2).       %% 全部砸

-define(NOT_SMASHED, 0).   %% 未砸
-define(HAS_SMASHED, 1).   %% 已砸

-define(EGG_TYPE_0, 0).   %% 
-define(EGG_TYPE_1, 1).   %% 

-record(role_info, {
    key = {0, 0},               %% {活动主类型，活动子类型}
    role_id = 0,                %% 玩家id
    role_name = "",
    lv = 0,
    sex = 0,
    career = 0,
    smashed_start = 0,           %% 砸蛋开始时间(活动开始时间或者每日清理时间)
    refresh_times = 0,          %% 今日刷新次数(手动刷)
    %add_refresh_times = 0,      %% 全砸附赠的刷新次数
    free_smashed_times = 0,     %% 今日使用的免费砸蛋次数
    smashed_times = 0,          %% 累计砸蛋次数
    eggs = [],                  %% 金蛋状态
    cumulate_reward = [],       %% 累计奖励的领取情况 已经领取的奖励id
    gain_list = [],             %% 获得过的奖励id
    show_ids = [],              %% 展示的奖励id列表
    utime = 0                   %% 数据更新时间
    }).

-record(egg_info, {
    id = 0,
    etype = 0,                  %% 蛋类型 0 普通 1 金蛋
    status = 0,
    goods_list = [],
    effect = 0
    }).

-record(act_state, {
    role_map = #{},             %% #{role_id => [#role_info{}]}
    record_map = #{}            %% 抽奖记录 #{{活动主类型,活动子类型} => [{role_name, goods_id, num, time}]}
    }).

-define(sql_select_smashed_egg,
    <<"select role_id, subtype, smashed_start, refresh_times, free_smashed_times, smashed_times, eggs, cumulate_reward, gain_list, show_ids, utime from player_smashed_egg">>).
-define(sql_save_smashed_egg,
    <<"replace into player_smashed_egg(role_id, subtype, smashed_start, refresh_times, free_smashed_times, smashed_times, eggs, cumulate_reward, gain_list, show_ids, utime)
    values(~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', '~s', '~s', ~p)">>).
-define(sql_delete_smashed_egg,
    <<"delete from player_smashed_egg where subtype = ~p">>).
-define(sql_clear_smashed_egg,
    <<"truncate table player_smashed_egg">>).
-define(sql_reset_smashed_egg,
    <<"update player_smashed_egg set smashed_start = ~p, refresh_times = 0, free_smashed_times = 0, smashed_times = 0, eggs = '~s', cumulate_reward = '~s', gain_list = '~s', utime = ~p where subtype = ~p">>).


%%-----------------------------------------------------------------------------
%% @Module  :       luckey_egg
%% @Author  :       
%% @Email   :       
%% @Created :       2018-03-01
%% @Description:    幸运砸蛋
%%-----------------------------------------------------------------------------

-define(RARE_REWARD, 1).       %% 珍惜
-define(NORMAL_REWARD, 0).       %% 普通
-define(HIGH_REWARD, 2).       %% 高级

-record(luckey_role, {
    key = {0, 0},               %% {活动主类型，活动子类型}
    role_id = 0,                %% 玩家id
    free_times_use = 0,
    total_times_use = 0,
    cumulate_reward = [],       %% 累计奖励的领取情况 已经领取的奖励id
    sp_times_list = [],         %% 特殊次数记录器
    utime = 0                   %% 数据更新时间
    }).

-record(luckey_info, {
    key = {0, 0},               %% {活动主类型，活动子类型}
    luckey_val = 0,
    add_luckey_time = 0,
    last_luckey_val = 0,
    last_luckey_time = 0
    }).

-record(luckey_state, {
    luckey_map = #{},          %% #{{Type, Subtype} => #luckey_info{}}
    role_map = #{}             %% #{role_id => [#role_info{}]}
    }).

-define(sql_select_luckey_egg,
    <<"select role_id, type, subtype, free_times_use, total_times_use, cumulate_reward, sp_times_list, utime from player_luckey_egg">>).
-define(sql_select_luckey_info,
    <<"select type, subtype, luckey_val, add_luckey_time, last_luckey_val, last_luckey_time from act_luckey_info">>).

-define(sql_replace_luckey_egg,
    <<"replace into player_luckey_egg (role_id, type, subtype, free_times_use, total_times_use, cumulate_reward, sp_times_list, utime) values (~p,~p,~p,~p,~p,'~s','~s',~p) ">>).

-define(sql_replace_luckey_info,
    <<"replace into act_luckey_info (type, subtype, luckey_val, add_luckey_time, last_luckey_val, last_luckey_time) values (~p,~p,~p,~p,~p,~p) ">>).

-define(sql_reset_luckey_egg,
    <<"update player_luckey_egg set free_times_use = 0, total_times_use = 0, cumulate_reward = '~s', utime = ~p where type = ~p and subtype = ~p">>).

-define(sql_delete_luckey_egg,
    <<"delete from player_luckey_egg where type=~p and subtype = ~p">>).

-define(sql_delete_luckey_info,
    <<"delete from act_luckey_info where type=~p and subtype = ~p">>).
