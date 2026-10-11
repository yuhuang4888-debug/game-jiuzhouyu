%%%--------------------------------------
%%% @Module  : lib_collect
%%% @Author  : huyihao
%%% @Created : 2018.04.28
%%% @Description:  我爱女神
%%%--------------------------------------
-module(lib_collect).

-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("attr.hrl").
-include("counter.hrl").
-include("custom_act.hrl").
-include("collect.hrl").

-export([
    collect_login/1,
    get_custom_act_drop_times/2,
    update_collect_status/3,
    get_collect_exp_ratio/1,
    clear_collect_gm/1
]).

collect_login(Ps) ->
    CollectStatus = mod_collect:get_collect_status(),
    NewPs = Ps#player_status{
        collect = CollectStatus
    },
    NewPs.

update_collect_status(Ps, ExpEndTime, DropEndTime) ->
    #player_status{
        collect = CollectStatus
    } = Ps,
    NewCollectStatus = CollectStatus#collect_status{
        exp_end_time = ExpEndTime,
        drop_end_time = DropEndTime
    },
    NewPs = Ps#player_status{
        collect = NewCollectStatus
    },
    NewPs.

%% 获取副本的定制活动多倍掉落倍数
get_custom_act_drop_times(DunType, DropEndTime) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_COLLECT) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of 
                #custom_act_cfg{condition = Condition} ->
                    {drop_types, Types} = ulists:keyfind(drop_types, 1, Condition, {drop_types, []}),
                    {DunType, N} = ulists:keyfind(DunType, 1, Types, {DunType, 1}),
                    case utime:unixtime() < DropEndTime of
                        true ->
                            N;
                        false ->
                            1
                    end;
                _ ->
                    1
            end;
        _ -> 
            1
    end.

get_collect_exp_ratio(Ps) ->
    #player_status{
        collect = CollectStatus
    } = Ps,
    #collect_status{
        exp_end_time = ExpEndTime
    } = CollectStatus,
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_COLLECT) of
        [#act_info{key = {ActId, SubId}}|_] ->
            case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of 
                #custom_act_cfg{condition = Condition} ->
                    case lists:keyfind(exp_types, 1, Condition) of
                        {exp_types, N} ->
                            case utime:unixtime() < ExpEndTime of
                                true ->
                                    N;
                                false ->
                                    0
                            end;
                        _ ->
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.

clear_collect_gm(Type) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_COLLECT) of
        [#act_info{key = {_, SubId}}|_] ->
            case Type of
                1 ->
                    mod_collect:day_clear();
                _ ->
                    mod_collect:act_end(SubId)
            end;
        _ ->
            skip
    end.
