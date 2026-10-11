%%%-----------------------------------
%%% @Module      : up_power_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 04. 六月 2020 15:15
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-author("carlos").


%%(冲榜)
%% --------------------#common_rank_role.rank_type 类型---------------------
-define(up_power_partner,           1).                      %% 伙伴排行榜
-define(up_power_partner_stage,     2).                      %% 伙伴排行榜阶段子类型
-define(up_power_mon_pic,           3).                      %% 图鉴排行榜
-define(up_power_mon_pic_stage,     4).                      %% 图鉴排行榜子类型
-define(up_power_person,            5).                      %% 个人战力排行榜

-define(up_power_rank_list,              [?up_power_person
	,?up_power_partner
	,?up_power_mon_pic
]).

-define(up_power_stage_list, [
	?up_power_partner_stage
]).


-define(NOT_REWARD,                   0).           %% 不可领状态
-define(HAVE_REWARD,                  1).           %% 可领奖励状态
-define(FINISH,                       2).           %% 完成状态







%%榜单的角色信息
-record(up_power_rush_rank_role, {
	role_key        = undefined,    % 玩家的唯一键 {SubType, RoleId},
	rank_type       = 0,            % 榜单类型
	sub_type        = 0,            % 在定制活动里配置，一般都会是1
	role_id         = 0,            % 角色Id
	value           = 0,            % 值
	time            = 0,            % 时间
	rank            = 0             % 名次
%%	get_reward_status= ?NOT_REWARD  % 排行榜获取状态
}).

%% 通用榜单的进程状态
-record(up_power_rush_rank_state, {
	rank_maps = maps:new()         % SubType  => [#up_power_rush_rank_role{}|...]
%%	goal_maps = maps:new()          %% 目标奖励信息 {RankType, SubType, RoleId} => [{GoalId, RewardState}]
}).

-define(sql_up_power_role_select, <<"
    SELECT
        sub_type, player_id, value, time
    FROM up_power_rush_rank_role">>).


-define(sql_up_power_role_save, <<"
    replace into up_power_rush_rank_role(
        sub_type, player_id, value, time
    ) values(~p, ~p, ~p, ~p)">>).


-define(sql_up_power_role_delete_by_role_id, <<"delete from up_power_rush_rank_role
            where  sub_type = ~p and player_id = ~p">>).

-define(sql_up_power_role_delete_by_role_ids, <<"delete from up_power_rush_rank_role
             ~s and sub_type = ~p ">>).

%%-define(sql_rush_rank_role_delete_by_value, <<"delete from rush_rank_role
%%             where rank_type = ~p and sub_type = ~p and value < ~p ">>).
%%-define(slq_rush_rank_role_update_rewardStatus,
%%	<<"UPDATE   rush_rank_role  set  get_reward_status  = ~p  where rank_type = ~p and  sub_type = ~p">>).

%%-define(sql_rush_rank_all_role, <<"
%%    SELECT
%%        rank_type, sub_type, player_id, value
%%    FROM rush_rank_all_role">>).
%%
%%-define(sql_rush_rank_all_role_save, <<"
%%    replace into rush_rank_all_role(
%%        rank_type, sub_type, player_id, value
%%    ) values(~p, ~p, ~p, ~p)">>).


-define(del_rush_rank_role, <<"TRUNCATE TABLE  `rush_rank_role`">>).

-define(sql_up_power_role_in_ps_save, <<"replace into up_power_rush_rank_role_in_ps(sub_type, player_id, stage_status) values(~p, ~p, ~p)">>).