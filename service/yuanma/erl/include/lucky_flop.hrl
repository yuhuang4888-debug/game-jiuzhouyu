%%-----------------------------------------------------------------------------
%% @Module  :       lucky_flop
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-05-26
%% @Description:    幸运翻牌
%%-----------------------------------------------------------------------------

-record(act_state, {
    data_map = #{},         %% #{subtype => #{role_id => #role_info{}}}
    record_map = #{}        %% #{subtype => [#record_info{}]}
    }).

-record(role_info, {
    role_id = 0,
    open_status = 0,
    obtain_rewards = [],    %% 已经获得的奖励[{cell, id}]
    all_rewards = [],       %% 奖池的所有奖励[id]
    use_times = 0,          %% 已经使用的翻牌次数
    total_use_times = 0,
    refresh_times = 0,      %% 玩家刷新奖池次数
    free_times = 0,
    time = 0
    }).

-record(record_info, {
    role_name = "",
    goods_id = 0,
    num = 0,
    time = 0
    }).

-define(RECORD_LEN, 20).

-define(REWARD_NUM, 8).

-define(sql_select_lucky_flop,
    <<"select subtype, role_id, open_status, obtain_rewards, all_rewards, use_times, total_use_times, refresh_times, free_times, time from role_lucky_flop">>).
-define(sql_save_lucky_flop,
    <<"replace role_lucky_flop(subtype, role_id, open_status, obtain_rewards, all_rewards, use_times, total_use_times, refresh_times, free_times, time)
        values(~p, ~p, ~p, '~s', '~s', ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_update_refresh_times,
    <<"update role_lucky_flop set open_status = ~p, refresh_times = ~p, free_times = ~p where subtype = ~p and role_id = ~p">>).
-define(sql_update_open_status,
    <<"update role_lucky_flop set open_status = ~p where subtype = ~p and role_id = ~p">>).
-define(sql_clear_lucky_flop,
    <<"delete from role_lucky_flop where subtype = ~p">>).