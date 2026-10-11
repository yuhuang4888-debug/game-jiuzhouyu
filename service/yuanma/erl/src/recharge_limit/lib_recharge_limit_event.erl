%% ---------------------------------------------------------------------------
%% @doc lib_recharge_limit_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/24
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_recharge_limit_event).

%% API
-export([
    reload_event/1,
    delete_event/1,
    add_event/1
]).

-include("rush_rank.hrl").
-include("recharge_limit.hrl").
-include("consume_rank_act.hrl").

% 重载时事件
reload_event(RoleIds) ->
    LimitRoles = ets:tab2list(?ETS_RECHARGE_LIMIT),
    OldRoleIdsTmp = [ERoleIds||#ets_recharge_limit{role_ids = ERoleIds}<-LimitRoles],
    OldRoleIds = lists:flatten(OldRoleIdsTmp),
    %% 新增的玩家列表
    AddRoleIds = RoleIds -- OldRoleIds,
    %% 减少的玩家列表
    DelRoleIds = OldRoleIds -- RoleIds,
%%    io:format("LimitRoles ~p ~n", [LimitRoles]),
%%    io:format("OldRoleIds ~p ~n", [OldRoleIds]),
%%    io:format("AddRoleIds ~p DelRoleIds ~p ~n", [AddRoleIds, DelRoleIds]),
    delete_event(DelRoleIds),
    add_event(AddRoleIds),
    ok.

%% 移除 玩家充值限制事件
delete_event(RoleIds) ->
    lib_rush_rank_api:fresh_role_rank(?RANK_TYPE_RECHARGE_RUSH, RoleIds),
    lib_consume_rank_act:break_limit_refresh_recharge(RoleIds).

%% 添加 玩家充值限制事件
add_event(RoleIds) ->
    lib_rush_rank_api:remove_role_rank(?RANK_TYPE_RECHARGE_RUSH, RoleIds),
    lib_consume_rank_act:limit_shield_recharge(RoleIds, ?RANK_TYPE_RECHARGE).
