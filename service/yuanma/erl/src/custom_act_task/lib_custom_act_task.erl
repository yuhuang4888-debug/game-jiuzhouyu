%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act_task
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2020-05-26
%% @Description:    活动任务 -- 幸运寻宝
%%-----------------------------------------------------------------------------


-module(lib_custom_act_task).

-include("custom_act.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").

-define(ACT_TYPE_LIST, [?CUSTOM_ACT_TYPE_TASK_REWARD]).

-export([
        trigger/5,
        trigger_core/5,
        get_act_info/3,
        get_reward/4
        ,check_lv/3
    ]).

trigger(Key, RoleId, RoleLv, Arg, Times) ->
    % spawn(fun() -> timer:sleep(100), trigger_core(Key, RoleId, RoleLv, Arg, Times) end).
    trigger_core(Key, RoleId, RoleLv, Arg, Times).

trigger_core(Key, RoleId, RoleLv, Arg, Times) ->
    TypeList = ?ACT_TYPE_LIST,
    Fun = fun(Type) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        F1 = fun(SubType, Acc) ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            Res = check_lv(RoleLv, Conditions),
            {_, KeyList} = ulists:keyfind(key, 1, Conditions, {key, []}),
            case lists:member(Key, KeyList) of
                true when Res == true -> [{Type, SubType}|Acc];
                _ -> Acc
            end
        end,
        ActList = lists:foldl(F1, [], SubTypes),
        ActList =/= [] andalso mod_custom_act_task:trigger(ActList, Key, RoleId, Arg, Times)
    end,
    lists:foreach(Fun, TypeList).

get_act_info(Player, Type, SubType) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    Res = check_lv(RoleLv, Type, SubType),
    if
        Res == false -> skip;
        true ->
            mod_custom_act_task:get_act_info(Type, SubType, RoleId, RoleLv)
    end,
    {ok, Player}.

get_reward(Player, Type, SubType, Grade) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    Res = check_lv(RoleLv, Type, SubType),
    if
        Res == false -> Code = ?ERRCODE(err331_lv_not_enougth), NewPS = Player;
        true ->
            Code = mod_custom_act_task:get_reward(Type, SubType, Grade, RoleId),
            ?PRINT("Code:~p~n",[Code]),
            case Code of
                1 ->
                    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade),
                    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    ProduceType = get_produce_type(Type),
                    Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                    NewPS = lib_goods_api:send_reward(Player, Produce),
                    lib_log_api:log_custom_act_reward(Player, Type, SubType, Grade, Reward);
                _ ->
                    NewPS = Player
            end
    end,
    lib_server_send:send_to_uid(RoleId, pt_331, 33105, [Code, Type, SubType, Grade]),
    {ok, NewPS}.

check_lv(RoleLv, Type, SubType) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    check_lv(RoleLv, Conditions).

check_lv(RoleLv, Conditions) ->
    WorldLv = util:get_world_lv(),
    {_, LimitLv} = ulists:keyfind(role_lv, 1, Conditions, {role_lv, 0}),
    {_, LimitWLv} = ulists:keyfind(wlv, 1, Conditions, {wlv, 0}),
    if
        RoleLv < LimitLv -> false;
        WorldLv < LimitWLv -> false;
        true -> true
    end.

get_produce_type(Type) when Type == ?CUSTOM_ACT_TYPE_TASK_REWARD ->
    custom_act_treasure_task;
get_produce_type(_) -> unkown.