%%%------------------------------------
%%% @Module  : lib_consume_rank_act
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 充值消费榜活动
%%%------------------------------------

-module(lib_consume_rank_act).

-include("server.hrl").
-include("def_fun.hrl").
-include("consume_rank_act.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

-compile(export_all).

make_record(RankType, SubType, RoleId, Value) ->
    #rank_role{
        role_key  = {RankType, RoleId},           %% 键
        rank_type = RankType,                     %% 榜单类型
        sub_type  = SubType,                      %% 活动子类型
        role_id   = RoleId,                       %% 玩家id
        value     = Value,                        %% 魅力值
        time      = utime:unixtime()              %% 时间
    }.

gm_refresh(PS, SubType, AddType, Num) ->
    case AddType of 
        1 -> 
            refresh_recharge(SubType, PS, Num);
        _ ->
            refresh_consume(SubType, PS, Num)
    end.

gm_end_act(Type, SubType) ->
    case Type of 
        ?CUSTOM_ACT_TYPE_RECHARGE_RANK ->
            mod_consume_rank_act:clear_recharge_rank_act(0, SubType, util:get_world_lv());
        ?CUSTOM_ACT_TYPE_CONSUME_RANK ->
            mod_consume_rank_act:clear_consume_rank_act(0, SubType, util:get_world_lv())
    end.

%% 函数回调结构
do_fun(act, [Fun, Type]) ->
    case lib_custom_act_api:get_open_custom_act_infos(Type) of
        [_|_] = ActInfos ->
            [
                Fun(ActInfo) 
                || ActInfo <- ActInfos
            ];
        _ -> ok
    end;
do_fun(_, _) ->
    skip.

%% 解除冲榜限制刷新榜单
break_limit_refresh_recharge([]) -> skip;
break_limit_refresh_recharge(RoleIds) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_consume_rank_act, break_limit_refresh_recharge_help, []) || RoleId <- RoleIds],
    ok.

break_limit_refresh_recharge_help(PS) ->
    F = fun(ActInfo) ->
        #act_info{key = {_, RSubType}, stime = RSTime, etime = RETime} = ActInfo,
        lib_consume_rank_act:refresh_recharge(RSubType, PS, lib_recharge_data:get_my_recharge_between(PS#player_status.id, RSTime, RETime))
    end,
    do_fun(act, [F, ?CUSTOM_ACT_TYPE_RECHARGE_RANK]).

%% 充值冲榜限制
limit_shield_recharge([], _) -> skip;
limit_shield_recharge(RoleIds, RankType) -> 
    F = fun(ActInfo) ->
        #act_info{key = {_, SubType}} = ActInfo,
        [
            mod_consume_rank_act:apply_cast(lib_consume_rank_act_mod, limit_shield_recharge, [RankType, SubType, RoleId])
            || RoleId <- RoleIds
        ]
    end,
    do_fun(act, [F, ?CUSTOM_ACT_TYPE_RECHARGE_RANK]).

%% 刷新充值榜
refresh_recharge(SubType, #player_status{id = RoleId, source = Source, mark = 0}, Num) ->
    case check_open_source(?CUSTOM_ACT_TYPE_RECHARGE_RANK, SubType, list_to_atom(util:make_sure_list(Source))) of 
        true ->
            refresh_common_rank(?RANK_TYPE_RECHARGE, SubType, RoleId, Num);
        _ ->
            skip
    end;
refresh_recharge(_,_,_) ->skip.

%% 刷新消费榜
refresh_consume(PS) ->
    F = fun(ActInfo) ->
        #act_info{key = {_, SubType}, stime = STime, etime = ETime} = ActInfo,
        refresh_consume(SubType, PS, lib_consume_data:get_consume_gold_between(PS#player_status.id, STime, ETime))
    end,
    do_fun(act, [F, ?CUSTOM_ACT_TYPE_CONSUME_RANK]).
    
refresh_consume(SubType, #player_status{id = RoleId, source = Source, mark = 0}, Num) ->
    case check_open_source(?CUSTOM_ACT_TYPE_CONSUME_RANK, SubType, list_to_atom(util:make_sure_list(Source))) of 
        true ->
            refresh_common_rank(?RANK_TYPE_CONSUME, SubType, RoleId, Num);
        _ ->
            skip
    end;
refresh_consume(_, _, _) -> skip.

%% 刷新榜单
refresh_common_rank(RankType, SubType, RoleId, Num) ->
    RankRole = make_record(RankType, SubType, RoleId, Num),
    mod_consume_rank_act:refresh_common_rank(RankType, SubType, RankRole).

is_exist(_I, []) -> false;
is_exist(I, [H | T]) ->
    case I == H of
        true ->
            true;
        false ->
            is_exist(I, T)
    end.

%% 转换定制活动类型
change_act_type(RankType) ->
    case RankType of
        ?RANK_TYPE_RECHARGE -> ?CUSTOM_ACT_TYPE_RECHARGE_RANK;
        ?RANK_TYPE_CONSUME -> ?CUSTOM_ACT_TYPE_CONSUME_RANK;
        _ -> 0
    end.

change_rank_type(ActType) ->
    case ActType of 
        ?CUSTOM_ACT_TYPE_RECHARGE_RANK -> ?RANK_TYPE_RECHARGE;
        ?CUSTOM_ACT_TYPE_CONSUME_RANK -> ?RANK_TYPE_CONSUME;
        _ -> 0
    end.

%% 配置榜单最大长度
get_max_len(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(rank_len, 1, Condition) of
                {_, MaxLen} when is_integer(MaxLen) -> MaxLen;
                _ -> 0
            end;
        _ -> 0
    end.

%% 配置上榜阈值
get_rank_limit(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(rank_limit, 1, Condition) of
                {_, Limit} when is_integer(Limit) -> Limit;
                _ -> 0
            end;
        _ -> 0
    end.

%% 最低奖励阈值
get_reward_num(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(reward_num, 1, Condition) of
                {_, RNum} when is_integer(RNum) -> RNum;
                _ -> 9999999
            end;
        _ -> 9999999
    end.

get_score_rank_condition(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
        #custom_act_cfg{condition = Condition} when is_list(Condition) ->
            case lists:keyfind(score_rank, 1, Condition) of
                {_, ScoreRank} -> ScoreRank;
                _ -> []
            end;
        _ -> []
    end.

%% 榜单奖励
get_rank_reward(RankType, SubType, Rank, Args) ->
    ActType = change_act_type(RankType),
    GradeList = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    do_get_rank_reward(ActType, SubType, Rank, Args, GradeList, []).

do_get_rank_reward(_, _, _, _, [], TmpL) -> TmpL;
do_get_rank_reward(ActType, SubType, Rank, Args, [H | T], TmpL) ->
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, H) of
        #custom_act_reward_cfg{condition = Condition} = RewardCfg when is_list(Condition) ->
            case lists:keyfind(rank, 1, Condition) of
                {_, {Min, Max}} ->
                    case Max >= Rank andalso Rank >= Min of
                        true ->
                            [Wlv, Lv, Career, Sex] = Args,
                            RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
                            RewardList = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                            ?PRINT("get_rank_reward:~p~n", [RewardList]),
                            case length(RewardList) > 0 of
                                true -> RewardList;
                                _ -> 
                                    ?ERR("do_get_rank_reward ActType:~p, SubType:~p, Rank:~p, GradeId:~p, Args:~p ~n", [ActType, SubType, Rank, H, Args]),
                                    []
                            end;
                        _ ->
                            do_get_rank_reward(ActType, SubType, Rank, Args, T, TmpL)
                    end;
                _ -> 
                    do_get_rank_reward(ActType, SubType, Rank, Args, T, TmpL)
            end;
        _ -> 
            do_get_rank_reward(ActType, SubType, Rank, Args, T, TmpL)
    end.
    
get_partake_reward(RankType, SubType) ->
    ActType = change_act_type(RankType),
    GradeList = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    F = fun(RewardId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId) of
            #custom_act_reward_cfg{condition = Condition, format = RewardFormat, reward = RewardList} ->
                case lists:keyfind(rank, 1, Condition) of
                    {_, {0, 0}} when RewardFormat == ?REWARD_FORMAT_TYPE_COMMON ->
                        RewardList ++ Acc;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    lists:foldl(F, [], GradeList).

get_dual_champion(RankType, SubType) ->
    ActType = change_act_type(RankType),
    case lib_custom_act_util:keyfind_act_condition(ActType, SubType, dual_champion) of 
        {dual_champion, GoodsTypeId} ->
            {dual_champion, GoodsTypeId};
        _ -> none
    end.

check_open_source(_Type, _SubType, _Source) -> true.
    % case lib_custom_act_util:keyfind_act_condition(Type, SubType, source_list) of 
    %     {source_list, OpenSourceList} ->
    %         case lists:member(Source, OpenSourceList) of 
    %             true -> true;
    %             _ -> false
    %         end;
    %     _ ->
    %         false
    % end.
