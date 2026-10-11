%%-----------------------------------------------------------------------------
%% @Module  :       lib_smashed_egg
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-02
%% @Description:    砸蛋
%%-----------------------------------------------------------------------------
-module(lib_smashed_egg).

-include("smashed_egg.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

-export([
    init/1
    , check_act/4
    , make_role_info/2
    , save_role_info/1
    , smashed_egg/7
    , send_tv/5
    , filter_unreceive_reward/6
    , auto_send_unreceive_reward/2
    , get_act_role_info/3
    , init_egg_list/2
    , get_smashed_egg_cost/2
    ]).

-export([
    pack_show_list/1
    , pack_eggs_list/1
    , pack_record_list/1
    , pack_cumulate_reward_list/6
    ]).

init(State) ->
    Sql = io_lib:format(?sql_select_smashed_egg, []),
    List = db:get_all(Sql),
    F = fun([RoleId, SubType, SmashedStart, RefreshTimes, FreeSmashedTimes, SmashedTimes, EggsStr, CumulateRewardStr, GainListStr, ShowIdsStr, Utime], AccMap) ->
        ShowIds = util:bitstring_to_term(ShowIdsStr),
        CumulateRewardL = util:bitstring_to_term(CumulateRewardStr),
        EggsL = util:bitstring_to_term(EggsStr),
        GainList = util:bitstring_to_term(GainListStr),
        RoleInfo = #role_info{
            key = {?CUSTOM_ACT_TYPE_SMASHED_EGG, SubType},
            role_id = RoleId,
            smashed_start = SmashedStart,
            refresh_times = RefreshTimes,
            free_smashed_times = FreeSmashedTimes,
            smashed_times = SmashedTimes,
            eggs = [#egg_info{id = Id, etype = EType, status = Status, goods_list = GoodsList, effect = Effect} || {Id, EType, Status, GoodsList, Effect} <- EggsL],
            cumulate_reward = CumulateRewardL,
            gain_list = GainList,
            show_ids = ShowIds,
            utime = Utime
        },
        RoleInfoL = maps:get(RoleId, AccMap, []),
        NewRoleInfoL = lists:keystore({?CUSTOM_ACT_TYPE_SMASHED_EGG, SubType}, #role_info.key, RoleInfoL, RoleInfo),
        maps:put(RoleId, NewRoleInfoL, AccMap)
    end,
    RoleMap = lists:foldl(F, #{}, List),
    State#act_state{role_map = RoleMap}.

check_act(Type, SubType, RoleLv, NowTime) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{
                    condition = Condition
                } ->
                    case lib_custom_act_check:check_act_condtion([role_lv, free_time, free_times, free_max], Condition) of
                        [OpenLv, FreeTime, FreeTimes, FreeMax] when RoleLv >= OpenLv ->
                            {true, ActInfo, [FreeTime, FreeTimes, FreeMax]};
                        [_OpenLv, _FreeTime, _FreeTimes, _FreeMax] -> {false, ?ERRCODE(lv_limit)};
                        _ -> {false, ?ERRCODE(err_config)}
                    end;
                _ -> {false, ?ERRCODE(err_config)}
            end;
        _ -> {false, ?ERRCODE(err331_act_closed)}
    end.

get_act_role_info(ActInfo, RoleInfoL, RoleArgs) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    case lists:keyfind({Type, SubType}, #role_info.key, RoleInfoL) of
        #role_info{eggs = EggList} = RoleInfo -> 
            [_RoleId, _RoleName, Lv, Sex, Career, _RegTime] = RoleArgs,
            NewEggList = ?IF(EggList == [], init_egg_list(Type, SubType), EggList),
            RoleInfo#role_info{lv = Lv, sex = Sex, career = Career, eggs = NewEggList};
        _ ->
            lib_smashed_egg:make_role_info(ActInfo, RoleArgs)
    end.

make_role_info(ActInfo, RoleArgs) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    EggList = init_egg_list(Type, SubType),
    [RoleId, RoleName, Lv, Sex, Career, RegTime] = RoleArgs,
    SmashedStart = lib_custom_act_util:get_act_logic_stime(ActInfo),
    NSmashedStart = ?IF(RegTime > SmashedStart, RegTime, SmashedStart),
    RoleInfo = #role_info{
        key = {Type, SubType},
        role_id = RoleId,
        role_name = RoleName,
        lv = Lv, 
        sex = Sex,
        career = Career,
        smashed_start = NSmashedStart,
        eggs = EggList,
        show_ids = [],
        utime = utime:unixtime()
    },
    %save_role_info(RoleInfo),
    RoleInfo.

init_egg_list(Type, SubType) ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, coloregg) of 
        {coloregg, Rate1} -> Rate = Rate1 * 100;
        _ -> Rate = 0
    end,
    EggList = [begin
        case urand:rand(0, 100) =< Rate of 
            true -> #egg_info{id = Index, etype = ?EGG_TYPE_1};
            _ -> #egg_info{id = Index, etype = ?EGG_TYPE_0}
        end
    end|| Index <- lists:seq(1, ?EGG_NUM)],
    EggList.

save_role_info(RoleInfo) ->
    #role_info{
        key = {_Type, SubType},
        role_id = RoleId,
        smashed_start = SmashedStart,
        refresh_times = RefreshTimes,
        free_smashed_times = FreeSmashedTimes,
        smashed_times = SmashedTimes,
        eggs = EggsL,
        cumulate_reward = CumulateRewardL,
        gain_list = GainList,
        show_ids = ShowIds,
        utime = Utime
    } = RoleInfo,
    EggArgs = [{Id, EType, Status, GoodsList, Effect} || #egg_info{id = Id, etype = EType, status = Status, goods_list = GoodsList, effect = Effect} <- EggsL],
    SqlArgs = [
        RoleId, SubType, SmashedStart, RefreshTimes, FreeSmashedTimes, SmashedTimes, util:term_to_string(EggArgs), 
        util:term_to_string(CumulateRewardL), util:term_to_string(GainList), util:term_to_string(ShowIds), Utime
    ],
    Sql = io_lib:format(?sql_save_smashed_egg, SqlArgs),
    db:execute(Sql).

smashed_egg(Type, SubType, RoleInfo, RoleArgs, WorldLv, Index, IsFree) ->
    #role_info{
        free_smashed_times = FreeSmashedTimes,
        smashed_times = SmashedTimes,
        eggs = EggList,
        gain_list = GainList
    } = RoleInfo,
    NowTime = utime:unixtime(),
    case Index > 0 of 
        true -> SmashedList = [Index];
        _ -> SmashedList = [EggInfo#egg_info.id || EggInfo <- EggList, EggInfo#egg_info.status == ?NOT_SMASHED]
    end,
    ?PRINT("smashed_core SmashedList ~p~n", [SmashedList]),
    {NewEggList, NewGainList, NewSmashedTimes, RecordList, ResultList, RewardList, TVList} = 
        smashed_core(SmashedList, NowTime, Type, SubType, WorldLv, RoleArgs, EggList, GainList, SmashedTimes),
    SmashedEggNum = length(SmashedList),
    NewFreeSmashedTimes = ?IF(IsFree == 1, FreeSmashedTimes + SmashedEggNum, FreeSmashedTimes),
    NewRoleInfo = RoleInfo#role_info{
        free_smashed_times = NewFreeSmashedTimes,
        smashed_times = NewSmashedTimes,
        eggs = NewEggList,
        gain_list = NewGainList,
        utime = NowTime
    },  
    {NewRoleInfo, RecordList, RewardList, ResultList, TVList}.

smashed_core(SmashedList, NowTime, Type, SubType, WorldLv, RoleArgs, EggList, GainList, SmashedTimes) ->
    RewardIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    smashed_core(SmashedList, NowTime, Type, SubType, RewardIdList, WorldLv, RoleArgs, EggList, GainList, SmashedTimes, [], [], [], []).

smashed_core([], _NowTime, _Type, _SubType, _RewardIdList, _WorldLv, _RoleArgs, EggList, GainList, SmashedTimes, RecordList, ResultList, RewardList, TVList) ->
    {EggList, GainList, SmashedTimes, RecordList, ResultList, ulists:object_list_plus_extra(RewardList), TVList};
smashed_core([Id|SmashedList], NowTime, Type, SubType, RewardIdList, WorldLv, RoleArgs, EggList, GainList, SmashedTimes, RecordList, ResultList, RewardList, TVList) ->
    [_RoleId, RoleName|_] = RoleArgs,
    NewSmashedTimes = SmashedTimes + 1,
    #egg_info{etype = EType} = EggInfo = lists:keyfind(Id, #egg_info.id, EggList),
    {NewGainList, GradeId, Reward} = rand_reward(Type, SubType, RewardIdList, WorldLv, RoleArgs, EType, NewSmashedTimes, GainList),
    NewEggInfo = EggInfo#egg_info{status = ?HAS_SMASHED, goods_list = Reward},
    NewEggList = [NewEggInfo|lists:keydelete(Id, #egg_info.id, EggList)],
    NewRecordList = [{RoleName, Reward, NowTime}|RecordList],
    NewResultList = [{Id, Reward}|ResultList],
    NewRewardList = Reward ++ RewardList,
    NewTVList = [{GradeId, Reward}|TVList],
    smashed_core(SmashedList, NowTime, Type, SubType, RewardIdList, WorldLv, RoleArgs, NewEggList, NewGainList, NewSmashedTimes, NewRecordList, NewResultList, NewRewardList, NewTVList).

rand_reward(Type, SubType, RewardIdList, WorldLv, RoleArgs, EType, SmashedTimes, GainList) ->
    [_RoleId, _RoleName, Lv, Sex, Career|_] = RoleArgs,
    RewardParam = lib_custom_act:make_rwparam(Lv, Sex, WorldLv, Career),
    EggType = ?IF(EType == ?EGG_TYPE_1, coloregg, egg),
    F = fun(GradeId, {Acc, IsFind}) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                case lists:keyfind(crazy_egg, 1, Conditions) of 
                    {crazy_egg, AtomEgg, Times1, Times2, Weight, WeightAdd} when AtomEgg == EggType -> 
                        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                        if
                            Times1 == 1 andalso Times2 == 1 -> {[{Weight, GradeId, Reward}|Acc], IsFind};
                            SmashedTimes < Times1 -> {Acc, IsFind};
                            SmashedTimes > Times2 -> {[{Weight, GradeId, Reward}|Acc], IsFind};
                            true ->
                                case lists:member(GradeId, GainList) of 
                                    true -> {[{Weight, GradeId, Reward}|Acc], IsFind};
                                    _ -> 
                                        case Times2 == SmashedTimes of 
                                            true ->
                                                {Acc, {GradeId, Reward}};
                                            _ ->
                                                {[{Weight+WeightAdd, GradeId, Reward}|Acc], IsFind}
                                        end
                                end
                        end;
                    _ -> {Acc, IsFind}
                end;
            _ -> {Acc, IsFind}
        end
    end,
    {WeightRewardList, {FindGradeId, FindReward}} = lists:foldl(F, {[], {0, []}}, RewardIdList),
    %?PRINT("rand_reward ~p~n", [{SmashedTimes, FindGradeId}]),
    case FindGradeId > 0 andalso length(FindReward) > 0 of 
        true -> GradeId = FindGradeId, Reward = FindReward;
        _ -> {_, GradeId, Reward} = util:find_ratio(WeightRewardList, 1)
    end,
    {[GradeId|lists:delete(GradeId, GainList)], GradeId, Reward}.

get_smashed_egg_cost(_Type, _SubType) -> 
    [{?TYPE_GOODS, 36255031, 20}].

% get_smashed_egg_refresh_time(Type, SubType) ->
%     case lib_custom_act_util:keyfind_act_condition(Type, SubType, free_time) of
%         {free_time, Time} -> Time;
%         _ -> 1800
%     end.

send_tv([], _Type, _SubType, _RoleId, _RoleName) -> skip;
send_tv([T|TvArgs], Type, SubType, RoleId, RoleName) ->
    case T of
        {GradeId, Reward} ->
            #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId), 
            case lists:keyfind(is_tv, 1, Conditions) of   
                {is_tv, 1} ->
                    case [ {GType, GId, GNum} || {GType, GId, GNum} <- Reward, GType == ?TYPE_GOODS] of
                        [{_, GoodsId, GoodsNum}|_] ->
                            GoodsColor = data_goods:get_goods_color(GoodsId),
                            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, urand:rand(1, 2), [RoleName, GoodsColor, GoodsId, GoodsNum, Type, SubType]);
                        [] -> skip
                    end;
                _ -> skip
            end;
        _ -> skip
    end,
    send_tv(TvArgs, Type, SubType, RoleId, RoleName).

pack_show_list(_ShowIds) -> [].

pack_eggs_list(EggsL) ->
    pack_eggs_list(EggsL, []).

pack_eggs_list([], Result) -> Result;
pack_eggs_list([T|L], Result) ->
    case T of
        #egg_info{
            id = Id,
            etype = EType,
            status = Status,
            goods_list = GoodsList,
            effect = _Effect
        } ->
            pack_eggs_list(L, [{Id, EType, Status, GoodsList}|Result]);
        _ ->
            pack_eggs_list(L, Result)
    end.

pack_record_list(RecordL) -> RecordL.

pack_cumulate_reward_list(Type, SubType, RoleArgs, WorldLv, SmashedTimes, CumulateRewardL) ->
    [_RoleId, _RoleName, RoleLv, Sex, Career|_] = RoleArgs,
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WorldLv, Career),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                case lists:keyfind(crazy_egg, 1, Conditions) of 
                    {crazy_egg, total, Times} -> 
                        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                        case lists:member(GradeId, CumulateRewardL) of 
                            true -> ReceiveStatus = 2;
                            _ ->
                                ReceiveStatus = ?IF(SmashedTimes>=Times, 1, 0)
                        end,
                        [{GradeId, Times, Reward, ReceiveStatus}|Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    lists:foldl(F, [], AllIds).

%% 筛选出未领取的累计奖励
filter_unreceive_reward(Type, SubType, RoleArgs, WorldLv, SmashedTimes, CumulateRewardL) ->
    [_RoleId, _RoleName, RoleLv, Sex, Career|_] = RoleArgs,
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WorldLv, Career),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                case lists:keyfind(crazy_egg, 1, Conditions) of 
                    {crazy_egg, total, Times} -> 
                        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                        case lists:member(GradeId, CumulateRewardL) of 
                            true -> Acc;
                            _ ->
                                ?IF(SmashedTimes>=Times, [Reward|Acc], Acc)
                        end;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    lists:foldl(F, [], AllIds).

auto_send_unreceive_reward([], _) -> skip;
auto_send_unreceive_reward([{RoleId, RoleInfoL}|L], ActInfoL) ->
    F = fun(T, Acc) ->
        case T of
            #role_info{key = Key, role_id = RoleId, role_name = RoleName, lv = Lv, sex = Sex, career = Career, smashed_times = SmashedTimes, cumulate_reward = CumulateRewardL} ->
                case lists:keyfind(Key, #act_info.key, ActInfoL) of
                    #act_info{wlv = WorldLv} ->
                        {Type, SubType} = Key,
                        RewardL = filter_unreceive_reward(Type, SubType, [RoleId, RoleName, Lv, Sex, Career, 0], WorldLv, SmashedTimes, CumulateRewardL),
                        RewardL ++ Acc;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    AllRewardL = lists:foldl(F, [], RoleInfoL),
    %?PRINT("auto_send_unreceive_reward ~p~n", [{RoleId, AllRewardL}]),
    case AllRewardL =/= [] of
        true ->
            LastAllRewardL = ulists:object_list_plus(AllRewardL),
            lib_mail_api:send_sys_mail([RoleId], utext:get(3310006), utext:get(3310007), LastAllRewardL),
            timer:sleep(100);
        false -> skip
    end,
    auto_send_unreceive_reward(L, ActInfoL).


