%%%------------------------------------
%%% @Module  : pp_rush_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(pp_rush_rank).

-compile(export_all).

-include("def_module.hrl").
-include("rush_rank.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("custom_act.hrl").

%% 榜单信息
handle(22501, Player, [RankType, SubType]) ->
    lib_rush_rank:send_rank_list(Player, {RankType, SubType});

%% 目标奖励列表
handle(22502, Player, [SubType]) ->
    #player_status{id = RoleId} = Player,
    mod_rush_rank:send_goal_list(SubType, RoleId);

%% 领取目标奖励
handle(22503, Player, [RankType, SubType, GoalId]) ->
    case lists:member(RankType, ?RANK_TYPE_LIST) of
        true ->
            #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
            case Lv >= lib_rush_rank:get_open_lv(?CUSTOM_ACT_TYPE_RUSH_RANK, SubType) of
                true ->
                    Reward = lib_rush_rank:get_cfg_goal_reward(RankType, GoalId),
                    %% 检查背包
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        true ->
                            SelValue = lib_rush_rank:get_sel_value(Player,  RankType),
                            mod_rush_rank:get_goal_reward(RoleId, RankType, SubType, GoalId, SelValue);
                        {false, ErrorCode} ->
                            lib_server_send:send_to_uid(RoleId, pt_225, 22503, [ErrorCode,  RankType,   GoalId,  SubType])
                    end;
                _ -> skip
            end;
        false -> skip
    end;

%% 领取排行榜奖励
handle(22504, #player_status{sid =  Sid, id = RoleId, figure = F} = Player, [RankType, SubType, RewardId]) ->
    #figure{career = Career} = F,
    case  lib_rush_rank_check:get_rank_reward(Player, RankType, SubType, RewardId) of
        true ->
            mod_rush_rank:get_rank_reward(RoleId, RankType, SubType, RewardId, Career);
        {false, Err} ->
            ?DEBUG("Err ~p~n", [Err]),
            {ok, Bin} = pt_225:write(22500, [Err]),
            lib_server_send:send_to_sid(Sid, Bin)
    end;

%% 获取冲榜途径
handle(22505, Player, [RushId]) ->
    lib_rush_rank:send_rush_approach(Player, RushId);


handle(_Cmd, _Player, _Data) ->
    ?PRINT(" Data:~p ~n", [_Data]),
    {error, "pp_common_rank no match~n"}.