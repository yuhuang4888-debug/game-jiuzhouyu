%%-----------------------------------------------------------------------------
%% @Module  :       lib_treasure_hunt_data
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-15
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_treasure_hunt_data).

-include("treasure_hunt.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").

-export([
    login/2
    , login/1
    , logout/1
    , get_open_lv/1
    , get_cost_gtype_id/1
    , get_cost_num/2
    , get_treasure_hunt_score_plus/1
    , update_statistics_map/8
    , count_reward_list/6
    , add_treasure_hunt_record/6
    , add_treasure_hunt_record/7
    , get_name_by_htype/1
    , get_times_point_goods/5
    , count_rune_reward_list/7
    , count_ex_rune_hunt_goods/2
    , merge_duplicate_rune_list/2
    , get_free_hunt_time/1
    , handle_event/2
    , exchang_score/2
    , get_hunt_discount/1
    , get_null_cell_num/2
    , get_hunt_task_by_type/2
    , trigger_hunt_task/4
    , get_hunt_task_reward/3
    , daily_clear/0
    ]).

-export([
    get_produce_type/1
    , get_consume_type/1
    , get_cfg_data/2
    , notify_client_luckey_value/3
    , get_show_percent/1
    , do_notify_lucky_val/2
    , do_notify_lucky_val/3
    , do_notify_lucky_val/4
    ]).

-export([
    can_sel_reward/3,
    get_special_type_draw_times/5,
    get_real_weight/10,
    calc_is_remove_obj/2
]).

login(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    login(RoleId, Lv),
    case db_select_treasure_hunt_task(RoleId) of 
        [] -> PS;
        DbList ->
            HuntTaskList = init_hunt_task_list(DbList, []),
            ?PRINT("HuntTaskList### ~p~n", [HuntTaskList]),
            PS#player_status{hunt_task_list = HuntTaskList}
    end.

init_hunt_task_list([], Return) -> Return;
init_hunt_task_list([[HType, TaskId, Num, State, Time]|DbList], Return) ->
    OldTreasureHuntTask = ulists:keyfind(HType, #treasure_hunt_task.htype, Return, #treasure_hunt_task{htype = HType}),
    OldTaskList = OldTreasureHuntTask#treasure_hunt_task.task_list,
    TaskInfo = #task_info{id = TaskId, num = Num, state = State},
    NewTreasureHuntTask = OldTreasureHuntTask#treasure_hunt_task{task_list = [TaskInfo|OldTaskList], time = Time},
    init_hunt_task_list(DbList, lists:keystore(HType, #treasure_hunt_task.htype, Return, NewTreasureHuntTask)).

login(RoleId, Lv) ->
    Fun = fun(HType, Acc) ->
        OpenLv = get_open_lv(HType),
        if
            Acc =< 0 ->
                OpenLv;
            OpenLv < Acc->
                OpenLv;
            true ->
                Acc
        end
    end,
    RealOpenLv = lists:foldl(Fun, 0, ?TREASURE_HUNT_TYPE_LIST),
    if
        Lv >= RealOpenLv ->
            mod_treasure_hunt:init_common_map(RoleId);
        true ->
            skip
    end.
    

logout(RoleId) ->
    mod_treasure_hunt:remove_from_common_map(RoleId).

get_open_lv(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            data_treasure_hunt:get_cfg(equip_treasure_hunt_open_lv);
        ?TREASURE_HUNT_TYPE_PEAK ->
            data_treasure_hunt:get_cfg(peak_treasure_hunt_open_lv);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            data_treasure_hunt:get_cfg(extreme_treasure_hunt_open_lv);
        ?TREASURE_HUNT_TYPE_RUNE ->
            data_treasure_hunt:get_cfg(rune_treasure_hunt_open_lv);
        ?TREASURE_HUNT_TYPE_BABY ->
            data_treasure_hunt:get_cfg(baby_treasure_hunt_open_lv);
        _ -> 99999
    end.

get_cost_gtype_id(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            data_treasure_hunt:get_cfg(equip_treasure_hunt_cost);
        ?TREASURE_HUNT_TYPE_PEAK ->
            data_treasure_hunt:get_cfg(peak_treasure_hunt_cost);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            data_treasure_hunt:get_cfg(extreme_treasure_hunt_cost);
        ?TREASURE_HUNT_TYPE_RUNE ->
            data_treasure_hunt:get_cfg(rune_treasure_hunt_cost);
        ?TREASURE_HUNT_TYPE_BABY ->
            data_treasure_hunt:get_cfg(baby_treasure_hunt_cost);
        _ -> 0
    end.

get_cost_num(HType, Times) ->
    DiscountL = get_hunt_discount(HType),
    Res = lists:keyfind(Times, 1, DiscountL),
    case Res of
        {Times, Discount} ->
            RealDis = if
                Discount == 0 orelse Discount == 10 ->
                    10;
                is_integer(Discount) ->
                    Discount;
                true ->
                    10
            end,
            round(Times * RealDis div 10);
        false ->
            Times
    end.
    % case Times of
    %     50 -> 45;
    %     10 -> 9;
    %     _ -> Times
    % end.

get_treasure_hunt_score_plus(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            data_treasure_hunt:get_cfg(equip_treasure_hunt_score);
        ?TREASURE_HUNT_TYPE_PEAK ->
            data_treasure_hunt:get_cfg(peak_treasure_hunt_score);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            data_treasure_hunt:get_cfg(extreme_treasure_hunt_score);
        _ -> 0
    end.

get_name_by_htype(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            utext:get(252);
        ?TREASURE_HUNT_TYPE_PEAK ->
            utext:get(253);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            utext:get(254);
        ?TREASURE_HUNT_TYPE_RUNE ->
            utext:get(304);
        ?TREASURE_HUNT_TYPE_BABY ->
            utext:get(4160001);
        _ -> ""
    end.

get_produce_type(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            treasure_hunt;
        ?TREASURE_HUNT_TYPE_PEAK ->
            peak_treasure_hunt;
        ?TREASURE_HUNT_TYPE_EXTREME ->
            extreme_treasure_hunt;
        ?TREASURE_HUNT_TYPE_RUNE ->
            rune_treasure_hunt;
        ?TREASURE_HUNT_TYPE_BABY ->
            baby_treasure_hunt;
        _ -> unkown
    end.

get_consume_type(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            treasure_hunt;
        ?TREASURE_HUNT_TYPE_PEAK ->
            peak_treasure_hunt;
        ?TREASURE_HUNT_TYPE_EXTREME ->
            extreme_treasure_hunt;
        ?TREASURE_HUNT_TYPE_RUNE ->
            rune_treasure_hunt;
        ?TREASURE_HUNT_TYPE_BABY ->
            baby_treasure_hunt;
        _ -> unkown
    end.

get_free_hunt_time(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            data_treasure_hunt:get_cfg(equip_treasure_hunt_free_time);
        ?TREASURE_HUNT_TYPE_PEAK ->
            data_treasure_hunt:get_cfg(peak_treasure_hunt_free_time);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            data_treasure_hunt:get_cfg(extreme_treasure_hunt_free_time);
        ?TREASURE_HUNT_TYPE_BABY ->
            data_treasure_hunt:get_cfg(baby_treasure_hunt_free_time);
        _ -> 0
    end.

get_hunt_discount(HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP -> 
            data_treasure_hunt:get_cfg(equip_treasure_hunt_discount);
        ?TREASURE_HUNT_TYPE_PEAK ->
            data_treasure_hunt:get_cfg(peak_treasure_hunt_discount);
        ?TREASURE_HUNT_TYPE_EXTREME ->
            data_treasure_hunt:get_cfg(extreme_treasure_hunt_discount);
        ?TREASURE_HUNT_TYPE_BABY -> 
            data_treasure_hunt:get_cfg(baby_treasure_hunt_discount);
        ?TREASURE_HUNT_TYPE_RUNE ->
            data_treasure_hunt:get_cfg(rune_treasure_hunt_discount);
        _ -> 0
    end.

get_null_cell_num(GoodsStatus, HType) ->
    case HType of
        ?TREASURE_HUNT_TYPE_BABY -> 
            lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_BAG);
        _ -> 
            lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_TREASURE)
    end.

%% 抽中了一个奖励要更新寻宝抽奖情况Map
update_statistics_map(RoleId, RewardCfg, StatisticsRewardMap, StatisticsTimesMap, LuckeyMap, OldLuckeyMap, CanUpdateLuckeyValue, ProtectRef) ->
    #treasure_hunt_reward_cfg{
        htype = HType,
        stype = SType,
        is_rare = IsRare
    } = RewardCfg,
    %% 更新全服以及玩家个人的抽奖次数
    NewStatisticsTimesMap = update_statistics_times_map([{HType, 0}, {HType, RoleId}], StatisticsTimesMap),
    %% 更新幸运值
    if
        CanUpdateLuckeyValue ->
            {NewLuckeyMap, NewOldLuckeyMap, NewProtectRef} = 
            update_luckey_value_map(HType, LuckeyMap, OldLuckeyMap, ProtectRef, IsRare);
        true ->
            NewLuckeyMap = LuckeyMap, NewOldLuckeyMap = OldLuckeyMap, NewProtectRef = ProtectRef
    end,
    %% 更新奖励的获得次数
    UpdateLimList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
    AllLimList = data_treasure_hunt:get_reward_limit_by_htype(HType),
    NewStatisticsRewardMap = update_statistics_reward_map(AllLimList, UpdateLimList, RoleId, NewStatisticsTimesMap, StatisticsRewardMap),
    {NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, NewOldLuckeyMap, NewProtectRef}.

update_statistics_reward_map([], _UpdateLim, _RoleId, _StatisticsTimesMap, StatisticsRewardMap) ->
    StatisticsRewardMap;
update_statistics_reward_map([{HType, SType, LimObj} = T|L], UpdateLim, RoleId, StatisticsTimesMap, StatisticsRewardMap) ->
    #treasure_hunt_limit_cfg{reset_times = ResetTimes} = data_treasure_hunt:get_reward_limit(HType, SType, LimObj),
    ObjId = ?IF(LimObj == ?OBJECT_TYPE_ALL, 0, RoleId),
    case maps:get({HType, SType, ObjId}, StatisticsRewardMap, false) of
        #reward_status{
            obtain_times = ObtainTimes
        } = RewardStatus when ResetTimes =/= 0 ->
            NewObtainTimes = ObtainTimes + 1,
            HTimes = maps:get({HType, ObjId}, StatisticsTimesMap, 0),
            %?PRINT(SType == 101,"@@@@@@@@@@@@@@@@ HTimes:~p~n",[HTimes]),
            case HTimes > 0 andalso HTimes rem ResetTimes == 0 andalso lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE) =/= true of
                true ->
                    NewStatisticsRewardMap = maps:remove({HType, SType, ObjId}, StatisticsRewardMap),
                    db:execute(io_lib:format(?sql_delete_treasure_hunt_reward, [HType, SType, ObjId]));
                false ->
                    case lists:member(T, UpdateLim) of
                        true ->
                            NewRewardStatus = RewardStatus#reward_status{obtain_times = NewObtainTimes, last_draw_times = HTimes},
                            NewStatisticsRewardMap = maps:put({HType, SType, ObjId}, NewRewardStatus, StatisticsRewardMap),
                            db:execute(io_lib:format(?sql_update_treasure_hunt_reward, [NewObtainTimes, HTimes, HType, SType, ObjId]));
                        false ->
                            NewStatisticsRewardMap = StatisticsRewardMap
                    end
            end;
        _ ->
            HTimes = maps:get({HType, ObjId}, StatisticsTimesMap, 0),
            case lists:member(T, UpdateLim) of
                true when HTimes > 0 andalso HTimes rem ResetTimes == 0 ->
                    NewStatisticsRewardMap = StatisticsRewardMap;
                true  ->
                    NewObtainTimes = 1,
                    NewRewardStatus = #reward_status{htype = HType, stype = SType, obj_id = ObjId, obtain_times = NewObtainTimes, last_draw_times = HTimes},
                    NewStatisticsRewardMap = maps:put({HType, SType, ObjId}, NewRewardStatus, StatisticsRewardMap),
                    db:execute(io_lib:format(?sql_insert_treasure_hunt_reward, [HType, SType, ObjId, 1, HTimes]));
                false ->
                    NewStatisticsRewardMap = StatisticsRewardMap
            end
    end,
    update_statistics_reward_map(L, UpdateLim, RoleId, StatisticsTimesMap, NewStatisticsRewardMap).

update_statistics_times_map([], StatisticsTimesMap) -> StatisticsTimesMap;
update_statistics_times_map([{HType, ObjId}|L], StatisticsTimesMap) ->
    case maps:get({HType, ObjId}, StatisticsTimesMap, false) of
        false ->
            NewTimes = 1,
            db:execute(io_lib:format(?sql_insert_treasure_hunt_times, [HType, ObjId, NewTimes]));
        PreTimes ->
            NewTimes = PreTimes + 1,
            db:execute(io_lib:format(?sql_update_treasure_hunt_times, [NewTimes, HType, ObjId]))
    end,
    NewStatisticsTimesMap = maps:put({HType, ObjId}, NewTimes, StatisticsTimesMap),
    update_statistics_times_map(L, NewStatisticsTimesMap).

update_luckey_value_map(HType, LuckeyMap, OldLuckeyMap, ProtectRef, IsRare) ->
    Limit = lib_treasure_hunt_data:get_cfg_data(kf_equip_hunt_max_luckey_value, 0),
    ClearTime = lib_treasure_hunt_data:get_cfg_data(kf_luckey_value_clear_time, 2),
    CList = lib_treasure_hunt_data:get_cfg_data(treasure_hunt_add_luckey_value, []),
    {_, AddValuePer} = ulists:keyfind(HType, 1, CList, {HType, 1}),
    PreValue = maps:get(HType, LuckeyMap, 0),
    if
        IsRare == 1 ->
            %% 这块代码被事务包裹，事务会开启进程
            NewProtectRef = util:send_after(ProtectRef, ClearTime*60*1000, misc:whereis_name(local, mod_treasure_hunt), {'refresh_old_luckey_map', HType}),
            NewValue = AddValuePer, NewOldLuckeyMap = maps:put(HType, Limit, OldLuckeyMap);
        true -> 
            NewProtectRef = ProtectRef,
            NewOldLuckeyMap = OldLuckeyMap,
            NewValue = min(PreValue + AddValuePer, Limit)
    end,
    db:execute(io_lib:format(?sql_replace_treasure_hunt_luckey_value, [HType, NewValue])),
    NewLuckeyMap = maps:put(HType, NewValue, LuckeyMap),
    {NewLuckeyMap, NewOldLuckeyMap, NewProtectRef}.

count_reward_list(BaseStatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes) ->
    List = data_treasure_hunt:get_reward_by_htype(HType),
    LuckeyValue = maps:get(HType, LuckeyMap, 0),
    List1 = [TId||{TId, TMinRoleLv, TMaxRoleLv} <- List, RoleLv >= TMinRoleLv, TMaxRoleLv >= RoleLv],
    CurrentTimes = UseTimes + 1,
    F = fun(TId, {Acc, SpeAcc, HasNext, StatisticsRewardMap}) -> %% HasNext :已经有权重格式为{next, _, _}
        case data_treasure_hunt:get_reward(TId) of
            #treasure_hunt_reward_cfg{
                weight = Weight,
                special = Special,
                stype = SType
            } = RewardCfg ->
                NewStatisticsRewardMap = correct_statistics_reward(CurrentTimes, lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE), SType, StatisticsRewardMap, RewardCfg, RoleId),
                % #treasure_hunt_limit_cfg{reset_times = ResetTimes} = data_treasure_hunt:get_reward_limit(HType, Stype, 2),
                case can_sel_reward(RoleId, RewardCfg, NewStatisticsRewardMap) of
                    {true, HasDrawIt} ->
                        FixCurrentTimes = get_special_type_draw_times(HType, SType, RoleId, CurrentTimes, StatisticsRewardMap),
                        {NewAcc, NewSpeAcc, NewHasNext} = get_real_weight(FixCurrentTimes, Weight, RewardCfg, HasDrawIt, LuckeyValue, Special, Acc, SpeAcc, HasNext, lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE)),
                        {NewAcc, NewSpeAcc, NewHasNext, NewStatisticsRewardMap};
                    false ->
                        {Acc, SpeAcc, HasNext, NewStatisticsRewardMap}
                end;
            _ ->
                {Acc, SpeAcc, HasNext, StatisticsRewardMap}
        end
    end,
    lists:foldl(F, {[], [], false, BaseStatisticsRewardMap}, List1).

%% 权重格式
% 1.{MinTimes, MaxTimes, NormalWeight, SpecialWeight} 在最小与最大次数之间使用 SpecialWeight，否则使用NormalWeight，
%    如果次数达到MaxTimes，则必中该物品;
% 2. 直接填写数字即表示权重;
% 3.{[{{Times1, Times2}, SpecialWeight},...], NormalWeight} 支持多段次数区间控制eg:[{{5,10},1200},{{12,16},1000},500]，
%    5到10次数区间内（不等于10）使用该区间的特殊权重，只要不在次数区间都是使用NormalWeight。当次数达到16时必中该物品 
% 4.当在同一抽奖次数有多个物品必中时，会在这几个物品中随机出一个
%
% 否则默认权重1000zz
get_real_weight(CurrentTimes, WeightCfg, RewardCfg, HasDrawIt, LuckeyValue, Special, Acc, SpeAcc, HasNext, IsNewRuleHType) when IsNewRuleHType->
    Fun1 = fun({Min, Max, AddWeight}, TemAcc) ->
        if
            Min =< LuckeyValue andalso Max >= LuckeyValue ->
                AddWeight;
            true ->
                TemAcc
        end
    end,
    Add = lists:foldl(Fun1, 0, Special),
    case WeightCfg of
        {SpecialList, NormalWeight} ->
            FunMax = fun({{_, Max1}, _}, MaxAcc) ->
                if
                    Max1 >= MaxAcc -> Max1;
                    true -> MaxAcc
                end
            end,
            ResetTimes = lists:foldl(FunMax, 1, SpecialList),
            Realtimes = CurrentTimes rem max(1, ResetTimes),
            FunRate = fun({{Min2, Max2}, SRate}, Rate) ->
                case Realtimes >= Min2 andalso Realtimes =< Max2 of
                    true -> SRate;
                    false -> Rate
                end
            end,
            SpecialRate = lists:foldl(FunRate, 0, SpecialList),
            %% 根据策划要求，special的权重为0时,不再计算幸运值的加成
            FixAdd = ?IF( SpecialRate == 0, 0, Add),
            if
                Realtimes == 0 andalso CurrentTimes =/= 0 ->
                    %% 日文渠道特殊处理
                    RealWeight = ?IF(lib_vsn:is_jp() andalso NormalWeight == 0, 0, NormalWeight + FixAdd),
                    {[{RealWeight, RewardCfg}|Acc], [RewardCfg|SpeAcc], HasNext};
                true ->
                    Fun = fun({{MinT1, MaxT1},_}) ->
                        Realtimes >= MinT1 andalso Realtimes < MaxT1
                    end,
                    case ulists:find(Fun, SpecialList) of
                        {ok, {_, Weight}} ->
                            RealWeight = ?IF(lib_vsn:is_jp() andalso Weight == 0, 0, Weight + FixAdd),
                            {[{RealWeight, RewardCfg}|Acc], SpeAcc, HasNext};
                        _ ->
                            RealWeight = ?IF(lib_vsn:is_jp() andalso NormalWeight == 0, 0, NormalWeight + FixAdd),
                            {[{RealWeight, RewardCfg}|Acc], SpeAcc, HasNext}
                    end
            end;
        {MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            Realtimes = CurrentTimes rem MaxTimes,
            if
                MinTimes == MaxTimes ->
                    FixAdd = ?IF(NormalWeight == 0, 0, Add),
                    {[{NormalWeight + FixAdd, RewardCfg}|Acc], SpeAcc, HasNext};
                Realtimes >= MinTimes andalso Realtimes < MaxTimes ->
                    % ?PRINT("===CurrentTimes:~p ~n",[CurrentTimes]),
                    FixAdd = ?IF(SpecialWeight == 0, 0, Add),
                    {[{SpecialWeight + FixAdd, RewardCfg}|Acc], SpeAcc, HasNext};
                Realtimes == 0 andalso CurrentTimes =/= 0 ->
                    % ?PRINT("================= ~n",[]),
                    FixAdd = ?IF(SpecialWeight == 0, 0, Add),
                    {[{SpecialWeight + FixAdd, RewardCfg}|Acc], [RewardCfg|SpeAcc], HasNext};
                true ->
                    FixAdd = ?IF(NormalWeight == 0, 0, Add),
                    {[{NormalWeight + FixAdd, RewardCfg}|Acc], SpeAcc, HasNext}
            end;
        {limit, BeginWeight, AfterDrawWeight} ->
            if
                HasDrawIt == false ->
                    {[{BeginWeight, RewardCfg}|Acc], SpeAcc, HasNext};
                true ->
                    {[{AfterDrawWeight, RewardCfg}|Acc], SpeAcc, HasNext}
            end;
        {limit_one, MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            if
                HasNext == false ->
                    Realtimes = CurrentTimes rem MaxTimes,
                    if
                        MinTimes == MaxTimes ->
                            FixAdd = ?IF(NormalWeight == 0, 0, Add),
                            {[{NormalWeight + FixAdd, RewardCfg}|Acc], SpeAcc, true};
                        Realtimes  >= MinTimes andalso Realtimes < MaxTimes ->
                            % ?PRINT("===CurrentTimes:~p ~n",[CurrentTimes]),
                            FixAdd = ?IF(SpecialWeight == 0, 0, Add),
                            {[{SpecialWeight + FixAdd, RewardCfg}|Acc], SpeAcc, true};
                        Realtimes == 0 andalso CurrentTimes =/= 0 ->
                            % ?PRINT("================= ~n",[]),
                            FixAdd = ?IF(SpecialWeight == 0, 0, Add),
                            {[{SpecialWeight + FixAdd, RewardCfg}|Acc], [RewardCfg|SpeAcc], true};
                        true ->
                            FixAdd = ?IF(NormalWeight == 0, 0, Add),
                            {[{NormalWeight + FixAdd, RewardCfg}|Acc], SpeAcc, true}
                    end;
                true ->
                    {Acc, SpeAcc, HasNext}
            end;
        _ ->
        if
            is_integer(WeightCfg) == true ->
                {[{WeightCfg+Add, RewardCfg}|Acc], SpeAcc, HasNext};
            true ->
                ?ERR("error cfg in treasure_hunt reward weight:~p", [WeightCfg]),
                {[{1, RewardCfg}|Acc], SpeAcc, HasNext}
        end
    end;
get_real_weight(CurrentTimes, WeightCfg, RewardCfg, HasDrawIt, LuckeyValue, Special, Acc, SpeAcc, HasNext, _HType) ->
    Fun1 = fun({Min, Max, AddWeight}, TemAcc) ->
        if
            Min =< LuckeyValue andalso Max >= LuckeyValue ->
                AddWeight;
            true ->
                TemAcc
        end
    end,
    Add = lists:foldl(Fun1, 0, Special),
    case WeightCfg of
        {SpecialList, NormalWeight} ->
            FunMax = fun({{_, Max1}, _}, MaxAcc) ->
                if
                    Max1 >= MaxAcc -> Max1;
                    true -> MaxAcc
                end
            end,
            ResetTimes = lists:foldl(FunMax, 1, SpecialList),
            Realtimes = CurrentTimes rem max(1, ResetTimes),
            if
                Realtimes == 0 andalso CurrentTimes =/= 0 ->
                    %% 日文渠道特殊处理
                    RealWeight = ?IF(lib_vsn:is_jp() andalso NormalWeight == 0, 0, NormalWeight+Add),
                    {[{RealWeight, RewardCfg}|Acc], [RewardCfg|SpeAcc], HasNext};
                true ->
                    Fun = fun({{MinT1, MaxT1},_}) ->
                        Realtimes >= MinT1 andalso Realtimes < MaxT1
                    end,
                    case ulists:find(Fun, SpecialList) of
                        {ok, {_, Weight}} ->
                            RealWeight = ?IF(lib_vsn:is_jp() andalso Weight == 0, 0, Weight+Add),
                            {[{RealWeight, RewardCfg}|Acc], SpeAcc, HasNext};
                        _ ->
                            RealWeight = ?IF(lib_vsn:is_jp() andalso NormalWeight == 0, 0, NormalWeight+Add),
                            {[{RealWeight, RewardCfg}|Acc], SpeAcc, HasNext}
                    end
            end;
        {MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            Realtimes = CurrentTimes rem MaxTimes,
            if
                MinTimes == MaxTimes ->
                    {[{NormalWeight+Add, RewardCfg}|Acc], SpeAcc, HasNext};
                Realtimes  >= MinTimes andalso Realtimes < MaxTimes ->
                    % ?PRINT("===CurrentTimes:~p ~n",[CurrentTimes]),
                    {[{SpecialWeight+Add, RewardCfg}|Acc], SpeAcc, HasNext};
                Realtimes == 0 andalso CurrentTimes =/= 0 ->
                    % ?PRINT("================= ~n",[]),
                    {[{SpecialWeight+Add, RewardCfg}|Acc], [RewardCfg|SpeAcc], HasNext};
                true ->
                    {[{NormalWeight+Add, RewardCfg}|Acc], SpeAcc, HasNext}
            end;
        {limit, BeginWeight, AfterDrawWeight} ->
            if
                HasDrawIt == false ->
                    {[{BeginWeight, RewardCfg}|Acc], SpeAcc, HasNext};
                true ->
                    {[{AfterDrawWeight, RewardCfg}|Acc], SpeAcc, HasNext}
            end;
        {limit_one, MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            if
                HasNext == false ->
                    Realtimes = CurrentTimes rem MaxTimes,
                    if
                        MinTimes == MaxTimes ->
                            {[{NormalWeight+Add, RewardCfg}|Acc], SpeAcc, true};
                        Realtimes  >= MinTimes andalso Realtimes < MaxTimes ->
                            % ?PRINT("===CurrentTimes:~p ~n",[CurrentTimes]),
                            {[{SpecialWeight+Add, RewardCfg}|Acc], SpeAcc, true};
                        Realtimes == 0 andalso CurrentTimes =/= 0 ->
                            % ?PRINT("================= ~n",[]),
                            {[{SpecialWeight+Add, RewardCfg}|Acc], [RewardCfg|SpeAcc], true};
                        true ->
                            {[{NormalWeight+Add, RewardCfg}|Acc], SpeAcc, true}
                    end;
                true ->
                    {Acc, SpeAcc, HasNext}
            end;
        _ ->
            if
                is_integer(WeightCfg) == true ->
                    {[{WeightCfg+Add, RewardCfg}|Acc], SpeAcc, HasNext};
                true ->
                    ?ERR("error cfg in treasure_hunt reward weight:~p", [WeightCfg]),
                    {[{1, RewardCfg}|Acc], SpeAcc, HasNext}
            end
    end.
    

%% 检测奖励是否能进入奖池
can_sel_reward(RoleId, RewardCfg, StatisticsRewardMap) ->
    #treasure_hunt_reward_cfg{
        htype = HType,
        stype = SType
    } = RewardCfg,
    ObjList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
    do_can_sel_reward(ObjList, RoleId, StatisticsRewardMap, false).

do_can_sel_reward([], _, _, HasDrawIt) -> {true, HasDrawIt};
do_can_sel_reward([{HType, SType, LimObj}|L], RoleId, StatisticsRewardMap, HasDrawIt) ->
    case data_treasure_hunt:get_reward_limit(HType, SType, LimObj) of
        #treasure_hunt_limit_cfg{lim_times = LimTimes} ->
            ObjId = ?IF(LimObj == ?OBJECT_TYPE_ALL, 0, RoleId),
            IsHType = lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE),
            %% 达到获得次数的奖励再次重置之前不能再次获得
            case maps:get({HType, SType, ObjId}, StatisticsRewardMap, false) of
                #reward_status{obtain_times = ObtainTimes} when ObtainTimes >= LimTimes andalso LimTimes =/= 0 ->
                    % ?PRINT(SType == 101, "ObtainTimes:~p~n",[ObtainTimes]),
                    false;
                #reward_status{obtain_times = ObtainTimes} when ObtainTimes >= 1 ->
                    % ?PRINT(SType == 101, "ObtainTimes:~p~n",[ObtainTimes]),
                    %% 该奖品无抽奖限制，这次抽奖还有抽中几率
                    do_can_sel_reward(L, RoleId, StatisticsRewardMap, true);
                #reward_status{obtain_times = ObtainTimes} when ObtainTimes == 0 andalso IsHType->
                    do_can_sel_reward(L, RoleId, StatisticsRewardMap, true);
                _ ->
                    do_can_sel_reward(L, RoleId, StatisticsRewardMap, HasDrawIt)
            end;
        _ -> do_can_sel_reward(L, RoleId, StatisticsRewardMap, HasDrawIt)
    end.

add_treasure_hunt_record(RecordMap, RewardList, RoleId, RoleName, RoleLv, FigArgs) ->
    Time = utime:unixtime(),
    do_add_treasure_hunt_record(?OBJECT_TYPE_ALL, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, ?TREASURE_HUNT_TYPE_RUNE, RecordMap).
add_treasure_hunt_record(RecordMap, RewardList, RoleId, RoleName, RoleLv, FigArgs, HType) ->
    Time = utime:unixtime(),
    NewRecordMap = do_add_treasure_hunt_record(?OBJECT_TYPE_ALL, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, HType, RecordMap),
    do_add_treasure_hunt_record(?OBJECT_TYPE_PERSION, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, HType, NewRecordMap).

do_add_treasure_hunt_record(?OBJECT_TYPE_ALL, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, HType, RecordMap) ->
    Acc = make_treasure_hunt_record(?OBJECT_TYPE_ALL, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, []),
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    OpenDay = util:get_open_day(),
    if
        OpenDay >= OpenDayLimit ->
            skip;
        true ->
            PackList = lib_treasure_hunt_mod:pack_record_list(Acc),
            {ok, BinData} = pt_416:write(41603, [?OBJECT_TYPE_ALL, RoleId, PackList]),
            OpenLv = lib_treasure_hunt_data:get_open_lv(?TREASURE_HUNT_TYPE_EUQIP),
            %% 开启了寻宝功能的玩家才能收到广播，减少广播的数量
            lib_server_send:send_to_all(all_lv, {OpenLv, 99999999}, BinData)
    end,
    
    QFRecordList = maps:get({HType, 0}, RecordMap, []),
    QFRecordLen = data_treasure_hunt:get_cfg(qf_treasure_hunt_record_len),
    NewQFRecordList = lists:sublist(Acc ++ QFRecordList, QFRecordLen),
    RecordMap#{{HType,0} => NewQFRecordList};
do_add_treasure_hunt_record(?OBJECT_TYPE_PERSION, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, HType, RecordMap) ->
    Acc = make_treasure_hunt_record(?OBJECT_TYPE_PERSION, RewardList, RoleId, RoleName, RoleLv, FigArgs, Time, []),

    % PackList = lib_treasure_hunt_mod:pack_record_list(Acc),
    % {ok, BinData} = pt_416:write(41603, [?OBJECT_TYPE_PERSION, RoleId, PackList]),
    % lib_server_send:send_to_uid(RoleId, BinData),

    PersonRecordList = maps:get({HType, RoleId}, RecordMap, []),
    PersonRecordLen = data_treasure_hunt:get_cfg(person_treasure_hunt_record_len),
    NewPersonRecordList = lists:sublist(Acc ++ PersonRecordList, PersonRecordLen),
    RecordMap#{{HType, RoleId} => NewPersonRecordList};
do_add_treasure_hunt_record(_, _RewardList, _RoleId, _RoleName, _RoleLv, _FigArgs, _Time, _HType, RecordMap) ->
    RecordMap.
make_treasure_hunt_record(_Type, [], _RoleId, _RoleName, _RoleLv, _FigArgs, _Time, Acc) -> Acc;
make_treasure_hunt_record(Type, [{HType, GTypeId, IsTv}|L], RoleId, RoleName, RoleLv, FigArgs, Time, Acc) ->
    case Type == ?OBJECT_TYPE_PERSION orelse IsTv > 0 of
        true ->
            T = lib_treasure_hunt_mod:make_record(reward_record, [RoleId, RoleName, RoleLv, FigArgs, HType, GTypeId, 1, Time, 0]),
            NewAcc = [T|Acc];
        false -> NewAcc = Acc
    end,
    make_treasure_hunt_record(Type, L, RoleId, RoleName, RoleLv, FigArgs, Time, NewAcc);
make_treasure_hunt_record(Type, [RewardCfg|L], RoleId, RoleName, RoleLv, FigArgs, Time, Acc) ->
    #treasure_hunt_reward_cfg{
        htype = HType,
        goods_id = GTypeId,
        goods_num = GoodsNum,
        is_tv = IsTv,
        is_rare = Rare
    } = RewardCfg,
    case Type == ?OBJECT_TYPE_PERSION orelse IsTv > 0 of
        true ->
            T = lib_treasure_hunt_mod:make_record(reward_record, [RoleId, RoleName, RoleLv, FigArgs, HType, GTypeId, GoodsNum, Time, Rare]),
            NewAcc = [T|Acc];
        false -> NewAcc = Acc
    end,
    make_treasure_hunt_record(Type, L, RoleId, RoleName, RoleLv, FigArgs, Time, NewAcc).

%% 获取符文寻宝节点奖励
%% return [] | #treasure_hunt_reward_cfg{}
get_times_point_goods(DunLv, Times, RoleId, RuneHunt, IsFloors) when Times > 0 ->
    case data_treasure_hunt:get_all_rune_points() of
        [Cycle|_] ->
            TempPoint = Times rem Cycle,
            Point = ?IF(IsFloors orelse TempPoint =:= 0, Cycle, TempPoint),
            case data_treasure_hunt:get_rune_points(Point) of
                [] -> [];
                List ->
                    RewardCfgList = get_reward_cfg_list(),
                    F = fun({GoodsId, LvMin, LvMax, Weight}, TempAvailableList) ->
                        RewardCfg = lists:keyfind(GoodsId, #treasure_hunt_reward_cfg.goods_id, RewardCfgList),
                        case can_sel_reward(RoleId, RewardCfg, RuneHunt#rune_hunt.statistics_reward_map) of
                            {true, _HasDrawIt} -> ?IF(DunLv =< LvMax andalso DunLv >= LvMin,  [{Weight, RewardCfg} | TempAvailableList], TempAvailableList);
                            false -> TempAvailableList
                        end
                        end,
                    AvailableList = lists:foldl(F, [], List),
                    ?IF(AvailableList == [], [], urand:rand_with_weight(AvailableList))
            end;
        _ -> []
    end.

%% 获得所有奖品记录
get_reward_cfg_list() ->
    List = data_treasure_hunt:get_reward_by_htype(?TREASURE_HUNT_TYPE_RUNE),
    [data_treasure_hunt:get_reward(Id) || {Id, _LvMin, _LvMax} <- List].

%% 第一次做特殊处理
count_rune_reward_list(_RoleId, RuneHunt, _DunLv, Times, MaxTimes, Acc, _IsFloors) when Times > MaxTimes ->
    {Acc, RuneHunt};
count_rune_reward_list(RoleId, RuneHunt, DunLv, 1, MaxTimes, Acc, FloorsTimes) ->
    {GoodId, IsTv, IsRare} = data_treasure_hunt:get_cfg(rune_treasure_hunt_first),
    Add = #treasure_hunt_reward_cfg{htype = ?TREASURE_HUNT_TYPE_RUNE, stype = 1, goods_id = GoodId, goods_num = 1, is_tv = IsTv, is_rare = IsRare},
    NewRuneHunt = update_rune_hunt(RoleId, RuneHunt, Add),
    count_rune_reward_list(RoleId, NewRuneHunt, DunLv, 2, MaxTimes, [Add | Acc], FloorsTimes);
%% 第二次次做特殊处理
count_rune_reward_list(RoleId, RuneHunt, DunLv, 2, MaxTimes, Acc, FloorsTimes) ->
    case count_rune_reward_normal_list_second(RoleId, RuneHunt,DunLv) of
        [] -> count_rune_reward_list(RoleId, RuneHunt, DunLv, 2 + 1, MaxTimes, Acc, FloorsTimes);
        Add ->
            NewRuneHunt = update_rune_hunt(RoleId, RuneHunt, Add),
            count_rune_reward_list(RoleId, NewRuneHunt, DunLv, 2 + 1, MaxTimes, [Add|Acc], FloorsTimes)
    end;
%% -----------------------------------------------------------------
%% @desc  获得符文抽奖奖励
%% @param DunLv  副本等级
%% @param Times  历史抽奖次数
%% @param MaxTimes 应该到达的抽奖次数
%% @param Acc 奖品
%% @return {Acc, LuckValue} {[#treasure_hunt_reward_cfg{},...], LuckValue}
%% -----------------------------------------------------------------
count_rune_reward_list(RoleId, RuneHunt, DunLv, Times, MaxTimes, Acc, FloorsTimes) ->
    case FloorsTimes == Times of
        true ->
            case get_times_point_goods(DunLv, Times, RoleId, RuneHunt, true) of
                %% 普通奖励
                [] ->
                    case count_rune_reward_normal_list(RoleId, RuneHunt,DunLv) of
                        [] -> count_rune_reward_list(RoleId, RuneHunt, DunLv, Times + 1, MaxTimes, Acc, FloorsTimes);
                        Add ->
                            NewRuneHunt = update_rune_hunt(RoleId, RuneHunt, Add),
                            count_rune_reward_list(RoleId, NewRuneHunt, DunLv, Times + 1, MaxTimes, [Add|Acc], FloorsTimes)
                    end;
                %% 10连奖励
                Add ->
                    NewRuneHunt = update_rune_hunt(RoleId, RuneHunt, Add),
                    count_rune_reward_list(RoleId, NewRuneHunt, DunLv, Times + 1, MaxTimes, [Add|Acc], FloorsTimes)
            end;
        _ ->
            case count_rune_reward_normal_list(RoleId, RuneHunt,DunLv) of
                [] -> count_rune_reward_list(RoleId, RuneHunt, DunLv, Times + 1, MaxTimes, Acc, FloorsTimes);
                Add ->
                    NewRuneHunt = update_rune_hunt(RoleId, RuneHunt, Add),
                    count_rune_reward_list(RoleId, NewRuneHunt, DunLv, Times + 1, MaxTimes, [Add|Acc], FloorsTimes)
            end
    end.



%% -----------------------------------------------------------------
%% @desc  抽到一个奖品后更新符文抽奖状态
%% @param RoleId 角色id
%% @param RuneHunt 符文抽奖记录
%% @param RewardCfg 奖品记录
%% @return NewRuneHunt
%% -----------------------------------------------------------------
update_rune_hunt(RoleId, RuneHunt, RewardCfg) ->
    #rune_hunt{statistics_reward_map = StatisticsRewardMap, statistics_times_map = StatisticsTimesMap, luck_value = OldLuckValue} = RuneHunt,
    #treasure_hunt_reward_cfg{
        htype = HType,
        stype = SType,
        goods_id = GTypeId
    } = RewardCfg,
    #ets_goods_type{color = Color} = data_goods_type:get(GTypeId),
    %% 红色重置幸运值和抽奖限制
    if
        Color =:= ?RED ->
            NewLuckyValue = 0,
            NewStatisticsTimesMap = maps:put({HType, RoleId}, 0, StatisticsTimesMap),
            db:execute(io_lib:format(?sql_update_treasure_hunt_times, [HType, RoleId, 0]));
        true ->
            NewLuckyValue =  updata_lucky_value(?TREASURE_HUNT_TYPE_RUNE, OldLuckValue),
            NewStatisticsTimesMap = update_statistics_times_map([{HType, RoleId}], StatisticsTimesMap)
    end,
    AllLimList = data_treasure_hunt:get_reward_limit_by_htype(?TREASURE_HUNT_TYPE_RUNE),
    %% 更新奖励的获得次数
    UpdateLimList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
    NewStatisticsRewardMap= update_statistics_reward_map(AllLimList, UpdateLimList, RoleId, NewStatisticsTimesMap, StatisticsRewardMap),
    RuneHunt#rune_hunt{luck_value = NewLuckyValue, statistics_reward_map = NewStatisticsRewardMap, statistics_times_map = NewStatisticsTimesMap}.


%% -----------------------------------------------------------------
%% @desc  更新幸运值
%% @param HType  寻宝类型
%% @param OldLuckyValue  旧的幸运值
%% @return NewLuckyValue
%% -----------------------------------------------------------------
updata_lucky_value(HType, OldLuckyValue) ->
    Limit = lib_treasure_hunt_data:get_cfg_data(rune_hunt_max_luckey_value, 0),
    CList = lib_treasure_hunt_data:get_cfg_data(treasure_hunt_add_luckey_value, []),
    {_, AddValuePer} = ulists:keyfind(HType, 1, CList, {HType, 1}),
    min(OldLuckyValue + AddValuePer, Limit).

%% -----------------------------------------------------------------
%% @desc  根据权重获得奖励
%% @param RoleId 角色id
%% @param RuneHunt 符文夺宝状态信息
%% @param DunLv 副本等级
%% @param OldLuckyValue 旧的幸运值
%% @return  #treasure_hunt_reward_cfg{}
%% -----------------------------------------------------------------
count_rune_reward_normal_list(RoleId, RuneHunt, DunLv) ->
    #rune_hunt{statistics_reward_map = StatisticsRewardMap, statistics_times_map = StatisticsTimesMap, luck_value = LuckyValue} = RuneHunt,
    UseTimes = maps:get({?TREASURE_HUNT_TYPE_RUNE, RoleId}, StatisticsTimesMap, 0),
    {RewardCfg, _} = lib_treasure_hunt_mod:get_rewardcfg(StatisticsRewardMap, #{?TREASURE_HUNT_TYPE_RUNE => LuckyValue}, RoleId, DunLv, ?TREASURE_HUNT_TYPE_RUNE, UseTimes),
    ?IF(RewardCfg==false, [], RewardCfg).

%% 符文寻宝第二次的特殊处理,过滤一些特殊id
count_rune_reward_normal_list_second(RoleId, RuneHunt,DunLv) ->
    _List = data_treasure_hunt:get_reward_by_htype(?TREASURE_HUNT_TYPE_RUNE),
    List  = lib_rune_hunt:get_right_second_list(_List),
    List1 = [TId||{TId, TMinRoleLv, TMaxRoleLv} <- List, DunLv =< TMaxRoleLv orelse DunLv >= TMinRoleLv],
    #rune_hunt{statistics_reward_map = StatisticsRewardMap, statistics_times_map = StatisticsTimesMap, luck_value = LuckyValue} = RuneHunt,
    UseTimes = maps:get({?TREASURE_HUNT_TYPE_RUNE, RoleId}, StatisticsTimesMap, 0),
    CurrentTimes = UseTimes + 1,
    %% HasNext :已经有权重格式为{next, _, _}
    F = fun(TId, {Acc, SpeAcc, HasNext}) ->
        case data_treasure_hunt:get_reward(TId) of
            #treasure_hunt_reward_cfg{weight = Weight, special = Special} = RewardCfg ->
                case can_sel_reward(RoleId, RewardCfg, StatisticsRewardMap) of
                    {true, HasDrawIt} -> get_real_weight(CurrentTimes, Weight, RewardCfg, HasDrawIt, LuckyValue, Special, Acc, SpeAcc, HasNext, false);
                    false -> {Acc, SpeAcc, HasNext}
                end;
            _ -> {Acc, SpeAcc, HasNext}
        end
        end,
    {AlternativeList, SpecialReward, _} = lists:foldl(F, {[], [], false}, List1),
    RealSpecialReward = urand:list_rand(SpecialReward),
    if
        is_record(RealSpecialReward, treasure_hunt_reward_cfg) -> RewardCfg = RealSpecialReward;
        true ->
            case urand:rand_with_weight(AlternativeList) of
                RewardCfg when is_record(RewardCfg, treasure_hunt_reward_cfg) -> skip;
                _ -> RewardCfg = []
            end
    end,
    RewardCfg.

count_ex_rune_hunt_goods(RoleLv, Times) ->
    Goods1 = data_treasure_hunt:get_cfg(rune_treasure_hunt_chip),
    Goods2 = get_max_lv_data(RoleLv, {0, []}, data_treasure_hunt:get_cfg(rune_treasure_hunt_super_chip)),
    GoodsList = [lib_goods_util:calc_random_rewards(Goods2 ++ Goods1) || _ <- lists:seq(1, Times)],
    lib_goods_api:make_reward_unique(lists:flatten(GoodsList)).

get_max_lv_data(RoleLv, {Lv0, Item0}, [{Lv, Item}|T]) ->
    if
        RoleLv >= Lv andalso Lv > Lv0 ->
            get_max_lv_data(RoleLv, {Lv, Item}, T);
        true ->
            get_max_lv_data(RoleLv, {Lv0, Item0}, T)
    end;

get_max_lv_data(_RoleLv, {_, Item}, []) -> Item.

merge_duplicate_rune_list([{GoodsId, _}|T], Acc) ->
    case lists:keyfind(GoodsId, 3, Acc) of
        {A, B, GoodsId, Num} ->
            NewAcc = lists:keystore(GoodsId, 3, Acc, {A, B, GoodsId, Num + 1});
        _ ->
            NewAcc = [{location, ?GOODS_LOC_RUNE_BAG, GoodsId, 1}|Acc]
    end,
    merge_duplicate_rune_list(T, NewAcc);

merge_duplicate_rune_list([], Acc) -> Acc.

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    Fun = fun(HType) ->
        OpenLv = get_open_lv(HType),
        if
            RoleLv >= OpenLv ->
                AddTime = get_free_hunt_time(HType),
                if
                    AddTime > 0 ->
                        mod_treasure_hunt:add_common_map(RoleId, HType, 1, 0);
                    true ->
                        skip
                end;
            true ->
                skip
        end
    end,
    lists:foreach(Fun, ?TREASURE_HUNT_TYPE_LIST),
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_ADD_LIVENESS}) when is_record(Player, player_status) ->
    Liveness = mod_daily:get_count(Player#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度
    NewPlayer = trigger_hunt_task(Player, ?MOD_ACTIVITY, 0, {gteq, Liveness}),
    {ok, NewPlayer};
handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

exchang_score(Player, ShopId) ->
    Sid = Player#player_status.sid,
    RoleLv = Player#player_status.figure#figure.lv,
    OldScore = lib_goods_api:get_currency(Player, ?GOODS_ID_THSCORE),
    case data_treasure_hunt:get_shop_cfg(ShopId) of
        #score_shop_cfg{lv = LimitLv, score = Cost, reward = RewardL} when RoleLv >= LimitLv ->
            CostList = [{?TYPE_CURRENCY, ?GOODS_ID_THSCORE, Cost}],
            case lib_goods_api:cost_object_list_with_check(Player, CostList, ?TREASURE_SCORE_SHOP, "") of
                {false, Code, NewPs} ->
                    Score = lib_goods_api:get_currency(NewPs, ?GOODS_ID_THSCORE),
                    {ok, BinData} = pt_416:write(41609, [Code, Score]),
                    NewPlayer = NewPs;
                {true, NewPs} ->
                    Score = lib_goods_api:get_currency(NewPs, ?GOODS_ID_THSCORE),
                    Produce = #produce{type = ?TREASURE_SCORE_SHOP, subtype = 0, reward = RewardL, show_tips = 0},
                    NewPlayer = lib_goods_api:send_reward(NewPs, Produce),
                    {ok, BinData} = pt_416:write(41609, [1, Score])
            end;
        #score_shop_cfg{} ->
            Code = ?ERRCODE(err416_lv_not_enougth),
            {ok, BinData} = pt_416:write(41609, [Code, OldScore]),
            NewPlayer = Player;
        _ ->
            Code = ?ERRCODE(err412_goods_not_exist),
            {ok, BinData} = pt_416:write(41609, [Code, OldScore]),
            NewPlayer = Player
    end,
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.


%% 触发任务
trigger_hunt_task(PS, ModId, SubMod, Data) ->
    ?PRINT("trigger_hunt_task### ~p~n", [{ModId, SubMod, Data}]),
    F = fun(HType, PSTmp) ->
        case get_hunt_task_by_type(HType, PSTmp) of 
            {ok, TreasureHuntTask, PS1} ->
                #player_status{hunt_task_list = HuntTaskList} = PS1,
                NewTreasureHuntTask = trigger_hunt_task_do(PS1, TreasureHuntTask, ModId, SubMod, Data),
                NewHuntTaskList = lists:keystore(HType, #treasure_hunt_task.htype, HuntTaskList, NewTreasureHuntTask),
                PS1#player_status{hunt_task_list = NewHuntTaskList};
            _ ->
                PSTmp
        end
    end,
    lists:foldl(F, PS, ?TREASURE_HUNT_TYPE_TASK).

trigger_hunt_task_do(PS, TreasureHuntTask, ModId, SubMod, Data) ->
    #player_status{id = RoleId} = PS,
    #treasure_hunt_task{htype = HType, task_list = TaskList, time = Time} = TreasureHuntTask,
    ModTaskList = data_treasure_hunt:get_task_by_mod(HType, ModId, SubMod),
    F = fun(TaskId, {List, UList}) ->
        case lists:keyfind(TaskId, #task_info.id, List) of 
            #task_info{state = 0} = TaskInfo ->
                NewTaskInfo = update_task_info(HType, TaskInfo, Data),
                {lists:keystore(TaskId, #task_info.id, List, NewTaskInfo), [NewTaskInfo|UList]};
            _ ->
                {List, UList}
        end
    end,
    {NewTaskList, UpTaskList} = lists:foldl(F, {TaskList, []}, ModTaskList),
    db_replace_hunt_task(RoleId, HType, UpTaskList, Time),
    %% 协议告诉客户端任务更新
    task_update_to_client(PS, HType, UpTaskList),
    ?PRINT("trigger_hunt_task_do### ~p~n", [UpTaskList]),
    TreasureHuntTask#treasure_hunt_task{task_list = NewTaskList}.

update_task_info(HType, TaskInfo, Data) ->
    #task_info{id = TaskId, num = OldNum} = TaskInfo,
    #base_treasure_hunt_task{num = NumCon} = data_treasure_hunt:get_hunt_task_cfg(HType, TaskId),
    case Data of 
        {add, AddNum} -> 
            {NewNum, NewState} = ?IF(AddNum+OldNum>=NumCon, {NumCon, 1}, {AddNum+OldNum, 0}),
            TaskInfo#task_info{num = NewNum, state = NewState};
        {gteq, GtEqNum} ->
            {NewNum, NewState} = ?IF(GtEqNum>=NumCon, {NumCon, 1}, {GtEqNum, 0}),
            TaskInfo#task_info{num = NewNum, state = NewState};
        {lteq, LtEqNum} ->
            {NewNum, NewState} = ?IF(LtEqNum=<NumCon, {NumCon, 1}, {LtEqNum, 0}),
            TaskInfo#task_info{num = NewNum, state = NewState};
        _ ->
            TaskInfo
    end.

%% 每日清理
daily_clear() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [daily_clear_helper(E#ets_online.id) || E <- OnlineRoles].
daily_clear_helper(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, daily_clear_helper, []);
daily_clear_helper(PS) ->
    F = fun(HType, PSTmp) ->
        #player_status{hunt_task_list = HuntTaskList} = PSTmp, 
        case lists:keyfind(HType, #treasure_hunt_task.htype, HuntTaskList) of 
            #treasure_hunt_task{} = TreasureHuntTask ->
                NewTreasureHuntTask = TreasureHuntTask#treasure_hunt_task{task_list = [], time = 0},
                NewHuntTaskList = lists:keystore(HType, #treasure_hunt_task.htype, HuntTaskList, NewTreasureHuntTask),
                PSTmp#player_status{hunt_task_list = NewHuntTaskList};
            _ ->
                PSTmp
        end
    end,
    lists:foldl(F, PS, ?TREASURE_HUNT_TYPE_TASK).

%% 获取寻宝任务信息
get_hunt_task_by_type(HType, PS) ->
    #player_status{id = _RoleId, figure = #figure{lv = RoleLv}, hunt_task_list = HuntTaskList} = PS,
    case RoleLv >= get_open_lv(HType) of 
        true ->
            case lists:keyfind(HType, #treasure_hunt_task.htype, HuntTaskList) of 
                #treasure_hunt_task{} = TreasureHuntTask -> ok;
                _ -> TreasureHuntTask = #treasure_hunt_task{htype = HType}
            end,
            case need_new_hunt_task(TreasureHuntTask) of 
                false -> {ok, TreasureHuntTask, PS};
                _ ->
                    NewTreasureHuntTask = new_treasure_hunt_task(PS, HType),
                    NewHuntTaskList = lists:keystore(HType, #treasure_hunt_task.htype, HuntTaskList, NewTreasureHuntTask),
                    {ok, NewTreasureHuntTask, PS#player_status{hunt_task_list = NewHuntTaskList}}
            end;
        _ ->
            {false, ?LEVEL_LIMIT}
    end.

%% 领取任务奖励
get_hunt_task_reward(PS, HType, TaskId) ->
    case get_hunt_task_by_type(HType, PS) of 
        {ok, TreasureHuntTask, #player_status{hunt_task_list = HuntTaskList} = PS1} ->
            #treasure_hunt_task{task_list = TaskList, time = Time} = TreasureHuntTask,
            case lists:keyfind(TaskId, #task_info.id, TaskList) of 
                #task_info{state = 1} = TaskInfo ->
                    #base_treasure_hunt_task{rewards = RewardList} = data_treasure_hunt:get_hunt_task_cfg(HType, TaskId),
                    NewTaskInfo = TaskInfo#task_info{state = 2},
                    db_replace_hunt_task(PS#player_status.id, HType, [NewTaskInfo], Time),
                    NewTaskList = lists:keystore(TaskId, #task_info.id, TaskList, NewTaskInfo),
                    NewTreasureHuntTask = TreasureHuntTask#treasure_hunt_task{task_list = NewTaskList},
                    NewHuntTaskList = lists:keystore(HType, #treasure_hunt_task.htype, HuntTaskList, NewTreasureHuntTask),
                    PS2 = PS1#player_status{hunt_task_list = NewHuntTaskList},
                    NewPS = lib_goods_api:send_reward(PS2, #produce{type = get_produce_type(HType), reward = RewardList}),
                    ?PRINT("get_hunt_task_reward### ~p~n", [NewTaskInfo]),
                    {ok, NewPS, [NewTaskInfo, RewardList]};
                #task_info{state = 0} ->
                    {false, ?ERRCODE(err416_hunt_task_not_finish)};
                #task_info{state = 2} ->
                    {false, ?ERRCODE(err416_hunt_task_is_got)};
                _ ->
                    {false, ?MISSING_CONFIG}
            end;
        {false, Res} ->
            {false, Res}
    end.

get_cfg_data(Key, Default) ->
    case data_treasure_hunt:get_cfg(Key) of
        0 -> Default;
        Val -> Val
    end.

notify_client_luckey_value(HType, LuckeyMap, NewLuckeyMap) ->
    OldValue = maps:get(HType, LuckeyMap, 0),
    Value = maps:get(HType, NewLuckeyMap, 0),
    NewValue = max(OldValue, Value),
    ?PRINT("HType, OldValue:~p, Value:~p, NewValue:~p~n",[OldValue, Value, NewValue]),
    do_notify_lucky_val(HType, NewValue).

do_notify_lucky_val(ServerId, RoleId, HType, Value) ->
    mod_clusters_center:apply_cast(ServerId, ?MODULE, do_notify_lucky_val, [HType, Value, RoleId]).

do_notify_lucky_val(HType, Value) ->
    do_notify_lucky_val(HType, Value, all).

do_notify_lucky_val(HType, Value, Type) ->
    Pers = get_show_percent(Value),
    {ok, BinData} = pt_416:write(41610, [HType, Value, Pers]),
    send_bin_data(HType, BinData, Type).

send_bin_data(_HType, BinData, RoleId) when is_integer(RoleId) ->
    lib_server_send:send_to_uid(RoleId, BinData);
send_bin_data(HType, BinData, _) ->
    OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
    lib_server_send:send_to_all(all_lv, {OpenLv, 99999}, BinData).

get_show_percent(Value) ->
    List = data_treasure_hunt:get_cfg(kf_equip_hunt_luckey_value_display),
    Fun1 = fun({Min, Max, _Percent}) ->
        Value >= Min andalso Value =< Max
    end,
    case ulists:find(Fun1, List) of
        {ok, {_Min, _Max, Pers}} -> Pers;
        _ -> 0
    end.

%% 新建任务
new_treasure_hunt_task(PS, HType) ->
    #player_status{id = RoleId} = PS,
    db_delete_hunt_task_by_type(RoleId, HType),
    Time = utime_logic:get_logic_day_start_time(),
    TaskIdList = data_treasure_hunt:get_all_hunt_task_by_type(HType),
    F = fun(TaskId, Acc) ->
        [#task_info{id = TaskId}|Acc]
    end,
    TaskList = lists:foldl(F, [], TaskIdList),
    TreasureHuntTask = #treasure_hunt_task{htype = HType, task_list = TaskList, time = Time},
    ?PRINT("new_treasure_hunt_task### ~p~n", [TreasureHuntTask]),
    db_replace_hunt_task_all(RoleId, TreasureHuntTask),
    TreasureHuntTask.

%% 是否需要新创建任务
need_new_hunt_task(TreasureHuntTask) -> 
    #treasure_hunt_task{task_list = TaskList, time = Time} = TreasureHuntTask,
    case length(TaskList) > 0 andalso utime_logic:is_logic_same_day(Time) of 
        true -> false;
        _ -> true
    end.

%% 任务状态更新通知
task_update_to_client(PS, HType, UpTaskList) ->
    SendTaskList = [{TaskId, Num, State} ||#task_info{id = TaskId, num = Num, state = State} <- UpTaskList],
    lib_server_send:send_to_sid(PS#player_status.sid, pt_416, 41621, [HType, SendTaskList]).

db_select_treasure_hunt_task(RoleId) ->
    Sql = usql:select(treasure_hunt_task, [htype, id, num, state, time], [{role_id, RoleId}]),
    db:get_all(Sql).

%% 任务db函数
db_replace_hunt_task_all(RoleId, TreasureHuntTask) ->
    #treasure_hunt_task{htype = HType, task_list = TaskList, time = Time} = TreasureHuntTask,
    ValuesList = [
        [RoleId, HType, TaskId, Num, State, Time] 
        || #task_info{id = TaskId, num = Num, state = State} <- TaskList],
    Sql = usql:replace(treasure_hunt_task, [role_id, htype, id, num, state, time], ValuesList),
    db:execute(Sql).

db_replace_hunt_task(_RoleId, _HType, [], _Time) -> ok;
db_replace_hunt_task(RoleId, HType, UpTaskList, Time) ->
    ValuesList = [
        [RoleId, HType, TaskId, Num, State, Time] 
        || #task_info{id = TaskId, num = Num, state = State} <- UpTaskList],
    Sql = usql:replace(treasure_hunt_task, [role_id, htype, id, num, state, time], ValuesList),
    db:execute(Sql).

db_delete_hunt_task_by_type(RoleId, HType) ->
    Sql = usql:delete(treasure_hunt_task, [{role_id, RoleId}, {htype, HType}]),
    db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc    功能描述
%% -----------------------------------------------------------------
correct_statistics_reward(CurrentTimes, IsNewRule, _SType, StatisticsRewardMap, RewardCfg, RoleId) when IsNewRule == true ->
    #treasure_hunt_reward_cfg{htype = HType, stype = SType} = RewardCfg,
    ObjList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
    Fun = fun
              ({HType2, SType2, LimObj}, CorrectData) when HType2 == HType andalso SType2 == SType->
                  case data_treasure_hunt:get_reward_limit(HType, SType, LimObj) of
                      #treasure_hunt_limit_cfg{ lim_times = LimTimes } ->
                          do_correct_data({HType, SType, LimObj}, LimTimes, CurrentTimes, RewardCfg, RoleId, CorrectData);
                      _ ->
                          CorrectData
                  end;
              (_, CorrectData) ->
                  CorrectData
    end,
    lists:foldl(Fun, StatisticsRewardMap, ObjList);
correct_statistics_reward(_, _, _, StatisticsRewardMap, _, _) ->
    StatisticsRewardMap.

do_correct_data({HType, SType, LimObj}, LimTimes, CurrentTimes, RewardCfg, RoleId, StatisticsRewardMap) ->
    ObjId = ?IF(LimObj == ?OBJECT_TYPE_ALL, 0, RoleId),
    %% 当目前次数对应的概率从0变到大于0时候，删除该条大奖记录，让这个大奖重新进行到循环中
    case maps:get({HType, SType, ObjId}, StatisticsRewardMap, false) of
        #reward_status{obtain_times = ObtainTimes, last_draw_times = LastTimes} = RewardStatus when ObtainTimes >= LimTimes andalso LimTimes =/= 0 ->
            RealTimes = CurrentTimes - LastTimes,
            IsRemoveObj = calc_is_remove_obj(RealTimes, RewardCfg),
            case IsRemoveObj of
                true ->
                    %% db:execute(io_lib:format(?sql_delete_treasure_hunt_reward, [HType, SType, ObjId])),
                    %% maps:remove({HType, SType, ObjId}, StatisticsRewardMap);
                    db:execute(io_lib:format(?sql_update_treasure_hunt_reward, [0, LastTimes, HType, SType, ObjId])),
                    NewRewardStatus = RewardStatus#reward_status{ obtain_times = 0 },
                    maps:put({HType, SType, ObjId}, NewRewardStatus, StatisticsRewardMap);
                false ->
                    StatisticsRewardMap
            end;
        #reward_status{obtain_times = ObtainTimes} when ObtainTimes >= 1 ->
            %% 该奖品无抽奖限制，这次抽奖还有抽中几率
            StatisticsRewardMap;
        _ ->
            StatisticsRewardMap
    end.

calc_is_remove_obj(RealTimes, _RewardCdg) when RealTimes =< 0 ->
    false;
calc_is_remove_obj(RealTimes, RewardCfg) ->
    #treasure_hunt_reward_cfg{ weight = WeightCfg } = RewardCfg,
    case WeightCfg of
        {SpecialList, NormalWeight} ->
            LastTimesRate = get_rate_by_times(SpecialList, RealTimes - 1, NormalWeight),
            NowTimesRate = get_rate_by_times(SpecialList, RealTimes, NormalWeight);
        {MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            LastTimes = RealTimes - 1,
            LastTimesRate = ?IF( LastTimes >= MinTimes andalso LastTimes =< MaxTimes, SpecialWeight, NormalWeight),
            NowTimesRate = ?IF( RealTimes >= MinTimes andalso RealTimes =< MaxTimes, SpecialWeight, NormalWeight);
        {limit_one, MinTimes, MaxTimes, NormalWeight, SpecialWeight} ->
            LastTimes = RealTimes - 1,
            LastTimesRate = ?IF( LastTimes >= MinTimes andalso LastTimes =< MaxTimes, SpecialWeight, NormalWeight),
            NowTimesRate = ?IF( RealTimes >= MinTimes andalso RealTimes =< MaxTimes, SpecialWeight, NormalWeight);
    _ ->
            LastTimesRate = 0, NowTimesRate = 0
    end,
    %% ?PRINT("LastRate:~p//NowRate:~p~n", [LastTimesRate, NowTimesRate]),
    LastTimesRate == 0 andalso NowTimesRate > 0.

get_rate_by_times([], _RealTimes, CalcRate) ->
    CalcRate;
get_rate_by_times([{{Min2, Max2}, SRate}|Tail], RealTimes, CalcRate) ->
    case RealTimes >= Min2 andalso RealTimes =< Max2 of
        true ->
            SRate;
        false ->
            get_rate_by_times(Tail, RealTimes, CalcRate)
    end.

get_special_type_draw_times(HType, SType, RoleId, CurTimes, StatisticsRewardMap) ->
    case lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE) of
        true ->
            AllObj = data_treasure_hunt:get_reward_limit_obj(HType, SType),
            Fun = fun
                      ({HType2, SType2, LimObj}, Times) when HType2 == HType andalso SType2 == SType ->
                          ObjId = ?IF(LimObj == ?OBJECT_TYPE_ALL, 0, RoleId),
                          case maps:get({HType, SType, ObjId}, StatisticsRewardMap, false) of
                              #reward_status{ last_draw_times = LastTimes } ->
                                  CurTimes - LastTimes;
                              _ ->
                                  Times
                          end;
                      (_, Times) ->
                          Times
            end,
            lists:foldl(Fun, CurTimes, AllObj);
        _ ->
            CurTimes
    end.