%% ---------------------------------------------------------------------------
%% @doc lib_custom_act_draw.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-03-04
%% @deprecated 抽奖
%% ---------------------------------------------------------------------------
-module(lib_custom_act_draw).

-compile(export_all).

-export([
    recalc_pool/2
    , get_pool/2
    , can_give_grade/4
    , construct_reward_list_for_client/3
    ]).

-include("custom_act.hrl").

%%--------------------------------------------------
%% 抽奖
%%--------------------------------------------------

%% 重新计算奖池
%% 奖池，{StartTimes, EndTimes, Weight, SpecialWeight} 在StartTimes 与 EndTimes 之间权重增加（Weight+SpecialWeight）
%% 若抽奖次数没达到StartTimes,该大奖不会入奖池， 抽奖次数大于EndTimes使用Weight来抽奖
recalc_pool(Pool, AllTimes) ->
    Fun = fun({{StartTimes, EndTimes, Weight, SpecialWeight}, GradeId}, RealPool) ->
        if
            StartTimes =:= EndTimes ->
                [{Weight, GradeId}|RealPool];
            AllTimes < StartTimes ->
                RealPool;
            AllTimes > StartTimes andalso AllTimes =< EndTimes ->
                [{Weight+SpecialWeight, GradeId}|RealPool];
            true ->
                [{Weight, GradeId}|RealPool]
        end
    end,
    lists:foldl(Fun, [], Pool).

%% 获取可被抽取的奖励的配置
get_pool(Type, SubType) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:keyfind(weight, 1, Conditions) of 
            {weight, Weight} -> [{Weight, GradeId}|Acc];
            _ -> Acc
        end
    end,
    lists:foldl(Fun, [], GradeIdList).

%% 判断该档次奖励是否满足发放给玩家的条件
can_give_grade(Conditions, GradeId, GradeState, AllTimes) -> %%用于抽奖时判断能否給与玩家该奖励
    Times = get_conditions(GradeId, GradeState),
    LimitNum = get_conditions(limit_num, Conditions),
    RefreshNum = get_conditions(refresh_num, Conditions),
    if
        RefreshNum =:= 0 ->
            AddTimes = 0;
        true ->
            AddTimes = AllTimes div RefreshNum + 1  %%只有总次数能够整除该值时加一
    end,
    if
        Times < LimitNum orelse LimitNum =:= 0 -> %%限制次数在某个值内
            if 
                Times < AddTimes orelse AddTimes =:= 0 -> 
                    true;
                true ->
                    false
            end;
        true ->
            false
    end.

%% 组装抽中奖励数据发送给客户端
construct_reward_list_for_client(Type, SubType, GradeIds) ->
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions, reward = Reward} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        IsRare = get_conditions(is_rare, Conditions),
        [{GradeId, IsRare, Reward}|Acc]
    end,
    lists:foldl(Fun, [], GradeIds).

%% 获得值
get_conditions(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} ->skip;
        _ -> Times = 0
    end,
    Times.