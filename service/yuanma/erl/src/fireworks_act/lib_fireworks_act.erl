%%%--------------------------------------
%%% @Module  : lib_fireworks_act
%%% @Author  : fwx
%%% @Created : 2018-03-06
%%% @Description:  烟花盛典活动
%%%--------------------------------------
-module(lib_fireworks_act).
-export([
]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("fireworks_act.hrl").
-include("custom_act.hrl").
-include("goods.hrl").
-include("def_goods.hrl").

login(RoleId) ->
    InfoL = [#reward_info{id = Id, num = Num, limit_num = LimitNum, utime = Utime}
        || [Id, Num, LimitNum, Utime] <- db:get_all(io_lib:format(?select_fireworks_reward_info, [RoleId]))],
    Fireworks = case db:get_row(io_lib:format(?select_fireworks_act, [RoleId])) of
                    [UseNum, Wlv, Utime] -> #fireworks{infoL = InfoL, wlv = Wlv, use_num = UseNum, utime = Utime};
                    _ -> #fireworks{}
                end,
    Fireworks.

%% 购买烟花
buy_fireworks(PS, Num) ->
    GoodsId = data_fireworks_act:get_key(fireworks_id),
    case data_goods:get_goods_buy_price(GoodsId) of
        {0, 0} -> {?ERRCODE(err_config), PS};
        {PriceType, PriceValue} ->
            Cost = [{PriceType, 0, PriceValue * Num}],
            Goods = [{?TYPE_GOODS, data_fireworks_act:get_key(fireworks_id), Num}],
            case lib_goods_api:can_give_goods(PS, Goods) of
                true ->
                    case lib_goods_api:cost_object_list_with_check(PS, Cost, fireworks_act, "") of
                        {true, NewPSTmp} ->
                            Produce = #produce{type = fireworks_act, reward = Goods, show_tips = 1},
                            NewPS = lib_goods_api:send_reward(NewPSTmp, Produce),
                            {true, NewPS};
                        {false, ErrCode, NewPSTmp} ->
                            {ErrCode, NewPSTmp}
                    end;
                {false, ErrorCode} -> {ErrorCode, PS}
            end
    end.

%% 使用烟花
use_fireworks(PS, GS, GoodsInfo, Num) ->
    case GoodsInfo#goods.goods_id =:= data_fireworks_act:get_key(fireworks_id) of
        true ->
            #player_status{id = RoleId, fireworks = TmpFireWorks} = PS,
            FireWorks = init_act_time(RoleId, TmpFireWorks, utime:unixtime()),    % 根据活动开启时间处理数据
            case count_reward_list(PS, GS, RoleId, FireWorks, Num) of
                {false, Err} -> {fail, Err};
                {RewardL, NewFireworks} ->
                    [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [GS, Num]),
                    Produce = #produce{title = utext:get(203), content = utext:get(204), type = fireworks_act, reward = RewardL},
                    case data_fireworks_act:get_key(fireworks_effect) of
                        0 -> ?ERR("fireworks config error: fireworks_effect!!~n", []);
                        EffAtom ->
                            Effect = atom_to_list(EffAtom),
                            {ok, FXBinData} = pt_110:write(11063, [Effect]),
                            lib_server_send:send_to_uid(PS#player_status.id, FXBinData)
                    end,
                    DisGiveL = [{0, TType, TId, TNum}  || {TType, TId, TNum} <- RewardL ],
                    {fireworks, PS#player_status{fireworks = NewFireworks}, NewStatus, DisGiveL, Produce}
            end;
        false ->
            {fail, ?ERRCODE(err150_type_err)}
    end.

%% 返回抽中奖励列表
count_reward_list(PS, GS, RoleId, FireWorks, Times) ->
    NowTime = utime:unixtime(),
    AllUseNum = mod_global_counter:get_count(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ALL_SERVER),
    CounterL = get_counter_list(FireWorks#fireworks.wlv),
    NeedNum = lib_gift_util:get_one_gifts_cell(get_rand_reward_list(FireWorks#fireworks.wlv), 0) * Times,
    HaveCell = lib_goods_util:get_null_cell_num(GS,  ?GOODS_LOC_BAG),
    case HaveCell < NeedNum of
        true ->
            {false, ?ERRCODE(err150_no_cell)};
        _ ->
            {NewCounterL, RewardL, IdL, NewFireWorks} = do_count_reward_list(RoleId, FireWorks, Times, AllUseNum, CounterL, [], [], NowTime),
            spawn(fun() ->
                send_tv(PS#player_status.figure#figure.name, IdL),
                mod_global_counter:set_count(NewCounterL),
                db:execute(io_lib:format(?replace_fireworks_act, [RoleId, NewFireWorks#fireworks.use_num, NewFireWorks#fireworks.wlv, NowTime])),
                F = fun([Id, Num, LimNum, UTime], Acc) ->
                    case Acc rem 20 of
                        0 -> timer:sleep(100);
                        _ -> skip
                    end,
                    db:execute(io_lib:format(?replace_fireworks_reward_info, [RoleId, Id, Num, LimNum, UTime])),
                    Acc + 1
                    end,
                lists:foldl(F, 1, db_refresh_list(NewFireWorks#fireworks.infoL))
                  end),
            lib_log_api:log_fireworks(RoleId, Times, ulists:object_list_merge(RewardL), NewFireWorks#fireworks.use_num),
            %mod_hi_point:success_end(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, Times),
            {RewardL, NewFireWorks}
    end.


%% 多次使用 返回新的计数器列表一次call
do_count_reward_list(_, FireWorks, 0, _, CounterL, RewardL, IdL, _) -> {CounterL, RewardL, IdL, FireWorks};
do_count_reward_list(RoleId, FireWorks, Times, AllUseNum, CounterL, OldRewardL, OldIdL, NowTime) ->
    #fireworks{infoL = InfoL, use_num = OldUseNum} = FireWorks,
    F = fun(Id, AccL) ->
        case lists:keyfind({?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD + Id}, 1, CounterL) of
            {_, AllCount} -> skip;
            _ -> AllCount = 0
        end,
        case lists:keyfind({?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD_CLEAR + Id}, 1, CounterL) of
            {_, Count} -> skip;
            _ -> Count = 0
        end,
        case data_fireworks_act:get_info_cfg(Id) of
            #base_fireworks_act{all_server_num = AllLimNum, weight = Weight, limit_num = CfgLimNum} ->
                case lists:keyfind(Id, #reward_info.id, InfoL) of
                    false ->
                        if
                            Count >= AllLimNum andalso AllLimNum /= 0 -> AccL;
                            true ->  [{Weight + get_plus_weight_cfg(Id, AllUseNum, AllCount), Id} | AccL]
                        end;
                    #reward_info{id = Id, limit_num = LimNum, num = GotNum} ->
                        if
                        % 次数限制的话 不放进权重列表
                            GotNum >= LimNum andalso CfgLimNum /= 0 -> AccL;
                            Count >= AllLimNum andalso AllLimNum /= 0 -> AccL;
                            true -> [{Weight + get_plus_weight_cfg(Id, AllUseNum, AllCount), Id} | AccL]
                        end
                end;
            _ -> AccL
        end
        end,
    %% 权重列表
    WeightList = lists:foldl(F, [], get_ids_with_wlv(FireWorks#fireworks.wlv)),
    %?PRINT("~p~n", [WeightList]),
    case urand:rand_with_weight(WeightList) of
        false ->
            NewCounterL = CounterL, RewardL = [], IdL = [], NewFireWorks = FireWorks, ?ERR("weight rand null~n", []);
        Id ->
            case data_fireworks_act:get_info_cfg(Id) of
                #base_fireworks_act{goods = RewardL, limit_num = CfgLimNum} ->
                    %update_global_counter(Id, AllUseNum, AllLimNum),
                    NewCounterL = update_counter_list(Id, AllUseNum, CounterL),
                    case (OldUseNum + 1) rem data_fireworks_act:get_key(num_period) == 0 of  % 使用烟花次数达到配置次数周期
                        true ->
                            NewInfoL = [begin
                                            #base_fireworks_act{limit_num = CfgLimNum2} = data_fireworks_act:get_info_cfg(TmpId),
                                            TmpInfo = #reward_info{id = TmpId, num = 0, utime = NowTime},
                                            case lists:keyfind(TmpId, #reward_info.id, InfoL) of
                                                false ->
                                                    TmpInfo#reward_info{limit_num = 2 * CfgLimNum2};
                                                #reward_info{limit_num = OldLimNum, num = 0} ->
                                                    TmpInfo#reward_info{limit_num = OldLimNum + CfgLimNum2};
                                                #reward_info{} ->
                                                    TmpInfo#reward_info{limit_num = CfgLimNum2}
                                            end
                                        end || TmpId <- get_ids_with_wlv(FireWorks#fireworks.wlv)];
                        false ->
                            case lists:keyfind(Id, #reward_info.id, InfoL) of
                                false ->
                                    NewInfoL = [#reward_info{id = Id, num = 1, limit_num = CfgLimNum, utime = NowTime} | InfoL];
                                OldInfo ->
                                    #reward_info{num = GotNum} = OldInfo,
                                    NewInfoL = lists:keystore(Id, #reward_info.id, InfoL, OldInfo#reward_info{num = GotNum + 1, utime = NowTime})
                            end
                    end,
                    IdL = [Id],
                    NewFireWorks = FireWorks#fireworks{infoL = NewInfoL, use_num = OldUseNum + 1};
                _ -> RewardL = [],IdL = [], NewFireWorks = FireWorks, NewCounterL = CounterL
            end
    end,
    do_count_reward_list(RoleId, NewFireWorks, Times - 1, AllUseNum + 1, NewCounterL, RewardL ++ OldRewardL, IdL ++ OldIdL, NowTime).

%% 根据时间戳判断为新的活动 新的数据
init_act_time(RoleId, FireWorks, NowTime) ->
    #fireworks{utime = Utime} = FireWorks,
    case lib_custom_act_util:get_act_time_range_by_type(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, 1) of
        {STime, _ETime} ->
            case Utime >= STime of  %活动结束新的活动开始前还有效
                true ->
                    FireWorks#fireworks{utime = NowTime};
                false ->
                    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, 1) of
                        true ->
                            db:execute(io_lib:format(?delete_fireworks_reward_info_role_id, [RoleId])),
                            #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, 1),
                            #fireworks{wlv = Wlv, utime = NowTime};
                        _ -> FireWorks#fireworks{utime = NowTime}
                    end
            end;
        _ -> #fireworks{}
    end.

%% 新活动开始 清全服计数器数据 玩家身上的数据根据时间戳更新处理
act_start(_SubType) ->
    F = fun(Id, AccL) ->
        [{{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD + Id}, 0},
            {{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD_CLEAR + Id}, 0} | AccL]
        end,
    CountL = lists:foldl(F, [{{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ALL_SERVER}, 0}], data_fireworks_act:get_id_list()),
    spawn(fun() -> mod_global_counter:set_count(CountL) end).

get_counter_list(Wlv) ->
    F = fun(Id, AccL) ->
        L1 = [{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD_CLEAR + Id} | AccL],
        case data_fireworks_act:get_plus_weight_count(Id) of
            [] -> L1;
            _ -> [{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ADD + Id} | L1]
        end
        end,
    CounterL = [{?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_ACT_FIREWORKS, ?CONVERT_ALL_SERVER}] ++ lists:foldl(F, [], get_ids_with_wlv(Wlv)),
    mod_global_counter:get_count(CounterL, normal).

update_counter_list(Id, AllUseNum, CounterL) ->
    Mod = ?MOD_AC_CUSTOM, Sub = ?CUSTOM_ACT_TYPE_ACT_FIREWORKS,
    case data_fireworks_act:get_key(global_num_period) of
        0 -> GloPeriod = 1;
        GloPeriod -> skip
    end,
    case (AllUseNum + 1) rem GloPeriod == 0 of
        true ->
            L1 = [?IF(TmpId >= 1000 andalso TmpId < 10000, {{Mod, Sub, TmpId}, 0}, {{Mod, Sub, TmpId}, Count})
                || {{_, _, TmpId}, Count} <- CounterL];
        false ->
            case lists:keyfind({Mod, Sub, ?CONVERT_ADD_CLEAR + Id}, 1, CounterL) of
                false ->
                    L1 = [{{Mod, Sub, ?CONVERT_ADD_CLEAR + Id}, 1} | CounterL];
                {_, OldCount} ->
                    L1 = lists:keystore({Mod, Sub, ?CONVERT_ADD_CLEAR + Id}, 1, CounterL, {{Mod, Sub, ?CONVERT_ADD_CLEAR + Id}, OldCount + 1})
            end
    end,
    % 不配动态增加权重时 不算CONVERT_ADD的
    case data_fireworks_act:get_plus_weight_count(Id) of
        [] -> L2 = L1;
        _ ->
            case lists:keyfind({Mod, Sub, ?CONVERT_ADD + Id}, 1, L1) of
                false ->
                    L2 = [{{Mod, Sub, ?CONVERT_ADD + Id}, 1} | L1];
                {_, OldCount2} ->
                    L2 = lists:keystore({Mod, Sub, ?CONVERT_ADD + Id}, 1, L1, {{Mod, Sub, ?CONVERT_ADD + Id}, OldCount2 + 1})
            end
    end,
    lists:keystore({Mod, Sub, ?CONVERT_ALL_SERVER}, 1, L2, {{Mod, Sub, ?CONVERT_ALL_SERVER}, AllUseNum + 1}).

%% 计算动态概率增加的权重
get_plus_weight_cfg(Id, Num, Count) ->
    case Count =< 0 of
        true ->
            CountList = data_fireworks_act:get_plus_weight_count(Id),
            case data_fireworks_act:get_plus_weight_cfg(Id, do_get_plus_weight_count(Num, CountList)) of
                #base_fireworks_plus_weight{plus_weight = Weight} -> Weight;
                _ -> 0
            end;
        _ -> 0
    end.

do_get_plus_weight_count(_, []) -> 0;
do_get_plus_weight_count(Num, [H | T]) ->
    case Num >= H of
        true -> H;
        false -> do_get_plus_weight_count(Num, T)
    end;
do_get_plus_weight_count(_, _) -> 0.

%% 更新的id列表
db_refresh_list(InfoL) ->
    [[Id, Num, LimNum, Utime] || #reward_info{id = Id, num = Num, limit_num = LimNum, utime = Utime} <- InfoL].

get_cfg_limit_num(Id) ->
    case data_fireworks_act:get_info_cfg(Id) of
        #base_fireworks_act{limit_num = LimNum} -> LimNum;
        _ -> 0
    end.

%% 根据世界等级返回奖励id列表
get_ids_with_wlv(Wlv) ->
    WlvList = data_fireworks_act:get_wlv_list(),
    CfgWlv = get_cfg_wlv(WlvList, Wlv),
    data_fireworks_act:get_ids_by_wlv(CfgWlv).

get_cfg_wlv([], _) -> 0;
get_cfg_wlv([H | T], Wlv) ->
    case Wlv >= H of
        true -> H;
        false -> get_cfg_wlv(T, Wlv)
    end.

get_rand_reward_list(Wlv) ->
    F = fun(Id, RewardL) ->
        case data_fireworks_act:get_info_cfg(Id) of
            #base_fireworks_act{goods = [{Type, GId, Num}]} -> [{{Type, GId, Num}, 0} | RewardL];
            _ -> RewardL
        end
        end,
    lists:foldl(F, [], get_ids_with_wlv(Wlv)).

send_tv(Name, IdL) ->
    F = fun(Id) ->
                case data_fireworks_act:get_info_cfg(Id) of
                    #base_fireworks_act{goods = [{_, GoodsId, _} | _], is_tv = 1} ->
                        lib_chat:send_TV({all}, ?MOD_GOODS, 5, [Name, data_fireworks_act:get_key(fireworks_id), GoodsId]);
                    _ -> skip
                end
        end,
    [F(Id)  || Id <- IdL ].