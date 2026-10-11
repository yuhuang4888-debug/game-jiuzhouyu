%% ---------------------------------------------------------------------------
%% @doc mod_recharge_limit

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/23
%% @deprecated  该功能提供给运营设置指定平台指定账号玩家的所有角色的充值
%%          计算不参与指定活动的充值榜单 （比如不让内玩的充值记录参与到头号玩家的充值榜单）
%% ---------------------------------------------------------------------------
-module(mod_recharge_limit).

%% API
-export([init/0, php_update_all/0, php_update_one/1, php_delete_one/2]).

-include("recharge_limit.hrl").
-include("common.hrl").

init() ->
    ets:new(?ETS_RECHARGE_LIMIT, [{keypos, #ets_recharge_limit.key}, named_table, public, set]),
    LimitInfo = get_limit_acc_db(),
    ets:delete_all_objects(?ETS_RECHARGE_LIMIT),
    ets_init(LimitInfo),
    ok.

%% php 更新所有
php_update_all() ->
    LimitInfo = get_limit_acc_db(),
    ets:delete_all_objects(?ETS_RECHARGE_LIMIT),
    F = fun([AccId, AccName], GrandRoleIds) ->
        timer:sleep(100),
        FRoleIds = load_acc_role_ids(AccId, AccName),
        Key = {AccId, util:make_sure_list(AccName)},
        ets:insert(?ETS_RECHARGE_LIMIT, #ets_recharge_limit{key = Key, role_ids = FRoleIds}),
        [FRoleIds|GrandRoleIds]
        end,
    spawn(fun() ->
            RoleIdsTmp = lists:foldl(F, [], LimitInfo),
            RoleIds = lists:flatten(RoleIdsTmp),
            lib_recharge_limit_event:reload_event(RoleIds)
          end),
    ok.

%% php 更新指定
php_update_one(Id) ->
    Sql = io_lib:format(<<"Select `accid`, `accname` From `config_recharge_account` where `id` = ~p">>, [Id]),
    case db:get_row(Sql) of
        [AccId, AccName] ->
            RoleIds = load_acc_role_ids(AccId, AccName),
            Key = {AccId, util:make_sure_list(AccName)},
            ets:insert(?ETS_RECHARGE_LIMIT, #ets_recharge_limit{key = Key, role_ids = RoleIds}),
            lib_recharge_limit_event:add_event(RoleIds);
        _ -> skip
    end,
    ok.

%% php 删除
php_delete_one(AccIdStr, AccName) ->
    AccId = list_to_integer(AccIdStr),
    Key = {AccId, util:make_sure_list(AccName)},
    ets:delete(?ETS_RECHARGE_LIMIT, Key),
    RoleIds = load_acc_role_ids(AccId, AccName),
    lib_recharge_limit_event:delete_event(RoleIds),
    ok.


%%===================================inner func===========================================


ets_init([]) -> ok;
ets_init([[AccId, AccName]|T]) ->
    RoleIds = load_acc_role_ids(AccId, AccName),
    Key = {AccId, util:make_sure_list(AccName)},
    EtsItem = #ets_recharge_limit{key = Key, role_ids = RoleIds},
    ets:insert(?ETS_RECHARGE_LIMIT, EtsItem),
    ets_init(T).


%% 获取指定账号的所有玩家
load_acc_role_ids(AccId, AccName) ->
    RSql = io_lib:format(<<"select `id` from `player_login` where `accid` = ~p and `accname` = '~s' ">>, [AccId, AccName]),
    RoleIds = db:get_all(RSql),
    lists:flatten(RoleIds).

get_limit_acc_db() ->
    Sql = <<"Select `accid`, `accname` From `config_recharge_account`">>,
    db:get_all(Sql).
