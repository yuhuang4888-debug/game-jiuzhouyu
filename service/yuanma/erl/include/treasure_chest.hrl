%%-----------------------------------------------------------------------------
%% @Module  :       treasure_chest
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-25
%% @Description:    青云夺宝
%%-----------------------------------------------------------------------------

-define(DEF_ACT_COPY_ID, 0).            %% 默认活动只在1线进行

-define(ACT_STATUS_CLOSE, 0).
-define(ACT_STATUS_OPEN, 1).

-record(status_treasure_chest, {
    ref = [],
    notice_ref = [],
    refresh_ref = [],
    status = 0,
    stime = 0,
    etime = 0,
    refresh_time = 0
    }).

-record(player_treasure_chest, {
    times = 0,                      %% 累计夺宝次数
    receive_list = [],              %% 累计奖励领取列表
    etime = 0                       %% 活动结束时间
    }).

-define(sql_select_player_treasure_chest,
    <<"select times, receive_list, etime from player_treasure_chest where role_id = ~p">>).

-define(sql_update_player_treasure_chest,
    <<"replace into player_treasure_chest set role_id = ~p, times = ~p, receive_list = ~p, etime = ~p">>).
