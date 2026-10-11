%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 摇摇乐
%%% @end
%%% Created : 26. 十一月 2018 10:32
%%%-------------------------------------------------------------------
-author("whao").


-record(status_shake, {
    shake = #{}         % type => #shake{}
}).


-record(shake, {
    draw_times = 0          % 摇摇乐抽奖次数
    ,shake_record = []      % 抽中记录
    ,time = 0               % 时间
}).



%% 寻宝记录
-record(shake_reward_record, {
    role_id = 0,                        %% 玩家id
    role_name = "",                     %% 玩家名字
    gtype_id = 0,                       %% 物品类型id
    goods_num = 0,                      %% 物品数量
    time = 0                            %% 时间
}).



%%  mod_shake  state
-record(shake_state, {
    record_list = []       % 抽奖记录 [#shake_reward_record{}] 玩家id为0存的是全服
}).


-define(Shake_Record_Len, 20).   %% 全服显示记录数量
-define(Shake_Lv, 20).           %% 全服可显示记录等级

%% 获取数据库
-define(sql_select_shake,
    <<"select subtype, draw_times, shake_record, time from player_shake where role_id = ~p">>).
%% 更新数据库
-define(sql_replace_shake,
    <<"replace into `player_shake`(role_id, subtype, draw_times, shake_record, time) values(~p, ~p, ~p,'~ts', ~p)">>).
%% 清理数据库
-define(sql_clear_shake,
    <<"delete from `player_shake` where role_id=~p and subtype=~p">>).
%% 清理类型的数据库
-define(sql_clear_subtype_shake,
    <<"delete from `player_shake` where subtype=~p">>).


%%  加载日志数据库
-define(sql_select_shake_reward_record,
    <<"select role_id, role_name, gtype_id, goods_num, time from shake_reward_record">>).

%%  插入日志数据
-define(sql_insert_shake_reward_record,
    <<"insert into shake_reward_record(role_id, role_name, gtype_id, goods_num, time) values(~p, '~s', ~p, ~p, ~p )">>).

%% 清空日志数据
-define(sql_truncate_shake_reward_record,
    <<"TRUNCATE TABLE shake_reward_record">>).






















