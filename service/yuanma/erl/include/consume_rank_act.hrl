%%%------------------------------------
%%% @Module  : consume_rank_act.hrl
%%% @Author  : fwx
%%% @Created : 2018-1-5
%%% @Description: 充值消费榜活动
%%%------------------------------------

-define(RANK_TYPE_RECHARGE, 381).     %% 充值
-define(RANK_TYPE_CONSUME,  382).     %% 消费

%% 榜单的角色信息
%% 注意:需要排序的话,使用value、second_value、third_value,不要用其他字段
-record(rank_role, {
        role_key        = undefined,              % 玩家唯一键 {RankType, Roleid}
        rank_type       = 0,                      % 榜单类型
        sub_type        = 0,                      % 活动子类型
        role_id         = 0,                      % 角色id
        value           = 0,                      % 值 (排序值)
        second_value    = 0,                      % 保留值
        third_value     = 0,                      % 保留值
        time            = 0,                      % 时间
        rank            = 0                       % 排名
    }).

%% 进程状态
-record(rank_state, {
        rank_maps  = maps:new(),                  % {RankType, SubType} => [#rank_role{}|...]
        role_maps  = maps:new(),                  % {RankType, SubType} => [#rank_role{}|...]
        rank_limit = maps:new(),                   % {RankType, SubType} => Limit
        champion_list = []                         % [{RankType, RoleId, GoodsTypeId, Time}]
    }).


%%-----------------select--------------------%%
-define(sql_rank_role_select, <<"
    SELECT
        rank_type, sub_type, player_id, value, second_value, third_value, time
    FROM consume_rank_act">>).

%--------------replace-----------%
-define(sql_rank_role_save, <<"
    replace into consume_rank_act(
        rank_type, sub_type, player_id, value,second_value, third_value, time
    ) values(~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

%--------------delete--------------%
-define(sql_rank_role_delete_by_role_id, <<"delete from consume_rank_act
                    where rank_type = ~p and sub_type = ~p and player_id = ~p">>).

%---------删除活动子类对应数据-----------%
-define(sql_rank_role_clear,
       <<"delete from `consume_rank_act` where rank_type = ~p and sub_type = ~p">>).
