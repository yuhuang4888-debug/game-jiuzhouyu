%%---------------------------------------------------------------------------
%% @doc:        lib_treasure_hunt_imitate
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-5月-09. 19:56
%% @deprecated: 
%%---------------------------------------------------------------------------
-module(lib_treasure_hunt_imitate).

-include("def_fun.hrl").
-include("common.hrl").
-include("treasure_hunt.hrl").

%% API
-export([
    treasure_hunt_draw/7
]).

-compile(export_all).

%% -----------------------------------------------------------------
%% @desc    功能描述  装备寻宝模拟抽奖 ProRef 定时器是否在重置保护期中
%% -----------------------------------------------------------------
treasure_hunt_draw(HType, InitTimes, DrawTimes, InitLuckyValue, ProRef, RoleLevel, RoundTimes) ->
    case lists:member(HType, ?TREASURE_HUNT_TYPE_LIST) of
        true ->
            case RoundTimes * DrawTimes < 20000 andalso RoundTimes >= 1 of
                true ->
                    MaxNumber = get_max_simulation_number(),
                    IsFirstEquipHunt = ?IF(HType == ?TREASURE_HUNT_TYPE_EUQIP, InitTimes == 0, false),
                    InitLuckyMap = maps:put(HType, InitLuckyValue, #{}),
                    InitRewardMap = #{},
                    InitTimesMap = maps:put({HType, 0}, InitTimes, #{}),
                    if
                        HType == ?TREASURE_HUNT_TYPE_BABY -> CanUpdateLuckeyValue = false;
                        ProRef == 1 -> CanUpdateLuckeyValue = true;
                        true -> CanUpdateLuckeyValue = false
                    end,

                    Fun = fun(Round) ->
                        SeriesNumber = MaxNumber + Round,
                        RewardL = do_treasure_hunt_draw(HType, IsFirstEquipHunt, InitLuckyMap, 0, DrawTimes, InitRewardMap,
                            InitTimesMap, CanUpdateLuckeyValue, SeriesNumber, [], RoleLevel),
                        case RewardL of
                            [] -> skip;
                            _ -> db_batch_insert_data(lists:reverse(RewardL))
                        end
                    end,
                    lists:foreach(Fun, lists:seq(1, RoundTimes));
                _ ->
                    error_round_times
            end;
        _ ->
            ok
    end.

%% LuKeyMap = #{HType => Value}
do_treasure_hunt_draw(_HType, _IsFirstEquipHunt, _InitLuckyValue, InitTimes, InitTimes, _StatisticsRewardMap,
_StatisticsTimesMap, _CanUpdateLuckyValue, _MaxNumber, AllRewardL, _RoleLevel) ->
    AllRewardL;
do_treasure_hunt_draw(HType, IsFirstEquipHunt, LuckeyMap, CurTimes, InitTimes, StatisticsRewardMap,
StatisticsTimesMap, CanUpdateLuckyValue, MaxNumber, AllRewardL, RoleLevel) ->
    UseTimes = maps:get({HType, 0}, StatisticsTimesMap, 0),
    case IsFirstEquipHunt andalso CurTimes == 0 of
        true ->
            case data_treasure_hunt:get_cfg(first_draw_reward) of
                RandList when is_list(RandList) -> RandList;
                _ -> RandList = [1108, 1109, 1110, 1111]
            end,
            RewardId = urand:list_rand(RandList),
            case data_treasure_hunt:get_reward(RewardId) of
                RewardCfg when is_record(RewardCfg, treasure_hunt_reward_cfg) ->
                    FixNewStatisticsRewardMap = StatisticsRewardMap;
                _ ->
                    {RewardCfg, FixNewStatisticsRewardMap} = get_fake_reward_cfg(StatisticsRewardMap, LuckeyMap, 0, RoleLevel, HType, UseTimes)
            end;
        _ ->
            {RewardCfg, FixNewStatisticsRewardMap} = get_fake_reward_cfg(StatisticsRewardMap, LuckeyMap, 0, RoleLevel, HType, UseTimes)
    end,
    case RewardCfg of
        #treasure_hunt_reward_cfg{
            id = DrawId, goods_id = GoodsId, goods_num = GoodsNum, stype = SType, is_rare = IsRare
        } ->
            %% 更新次数
            NewStatisticsTimesMap = maps:put({HType, 0}, UseTimes + 1, StatisticsTimesMap),
            %% 更新幸运值
            if
                CanUpdateLuckyValue ->
                    Limit = lib_treasure_hunt_data:get_cfg_data(kf_equip_hunt_max_luckey_value, 0),
                    CList = lib_treasure_hunt_data:get_cfg_data(treasure_hunt_add_luckey_value, []),
                    {_, AddValuePer} = ulists:keyfind(HType, 1, CList, {HType, 1}),
                    PreValue = maps:get(HType, LuckeyMap, 0),
                    if
                        IsRare == 1 ->
                            NewValue = AddValuePer;
                        true ->
                            NewValue = min(PreValue + AddValuePer, Limit)
                    end,
                    NewLuckeyMap = maps:put(HType, NewValue, LuckeyMap);
                true ->
                    NewLuckeyMap = LuckeyMap
            end,
            %% 更新奖励的获得次数
            UpdateLimList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
            AllLimList = data_treasure_hunt:get_reward_limit_by_htype(HType),
            NewStatisticsRewardMap = update_reward_map(AllLimList, UpdateLimList, NewStatisticsTimesMap, FixNewStatisticsRewardMap),
            NewRewardL = [
                MaxNumber, HType, UseTimes + 1, maps:get(HType, LuckeyMap, 0), DrawId,
                util:term_to_bitstring([{0, GoodsId, GoodsNum}]), utime:unixtime(), SType, IsRare
            ],
            NewAllRewardL = [NewRewardL|AllRewardL],
            do_treasure_hunt_draw(HType, IsFirstEquipHunt, NewLuckeyMap, CurTimes + 1, InitTimes, NewStatisticsRewardMap, NewStatisticsTimesMap, CanUpdateLuckyValue, MaxNumber, NewAllRewardL, RoleLevel);
        _ ->
            do_treasure_hunt_draw(HType, IsFirstEquipHunt, LuckeyMap, CurTimes + 1, InitTimes, StatisticsRewardMap, StatisticsTimesMap, CanUpdateLuckyValue, MaxNumber, AllRewardL, RoleLevel)
    end.

get_fake_reward_cfg(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes) ->
    {AlternativeList, SpecialReward, _HasNext, NewStatisticsRewardMap} = do_get_fake_reward_cfg(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes),
    %% ?MYLOG("lhh_hunt", "Args:~p", [{AlternativeList, SpecialReward}]),
    RealSpecialReward = urand:list_rand(SpecialReward),
    if
        is_record(RealSpecialReward, treasure_hunt_reward_cfg) ->
            RewardCfg = RealSpecialReward;
        true ->
            case urand:rand_with_weight(AlternativeList) of
                RewardCfg when is_record(RewardCfg, treasure_hunt_reward_cfg) ->
                    skip;
                _ ->
                    RewardCfg = false
            end
    end,
    {RewardCfg, NewStatisticsRewardMap}.

do_get_fake_reward_cfg(BaseStatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes) ->
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
                case lib_treasure_hunt_data:can_sel_reward(RoleId, RewardCfg, NewStatisticsRewardMap) of
                    {true, HasDrawIt} ->
                        FixCurrentTimes = lib_treasure_hunt_data:get_special_type_draw_times(HType, SType, RoleId, CurrentTimes, StatisticsRewardMap),
                        {NewAcc, NewSpeAcc, NewHasNext} = lib_treasure_hunt_data:get_real_weight(FixCurrentTimes, Weight, RewardCfg, HasDrawIt, LuckeyValue, Special, Acc, SpeAcc, HasNext, lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE)),
                        {NewAcc, NewSpeAcc, NewHasNext, NewStatisticsRewardMap};
                    false ->
                        {Acc, SpeAcc, HasNext, NewStatisticsRewardMap}
                end;
            _ ->
                {Acc, SpeAcc, HasNext, StatisticsRewardMap}
        end
        end,
    lists:foldl(F, {[], [], false, BaseStatisticsRewardMap}, List1).

update_reward_map([], _UpdateLim, _StatisticsTimesMap, StatisticsRewardMap) ->
    StatisticsRewardMap;
update_reward_map([{HType, SType, LimObj} = H|Tail], UpdateLim, StatisticsTimesMap, StatisticsRewardMap) ->
    #treasure_hunt_limit_cfg{reset_times = ResetTimes} = data_treasure_hunt:get_reward_limit(HType, SType, LimObj),
    ObjId = 0,
    case maps:get({HType, SType, ObjId}, StatisticsRewardMap, false) of
        #reward_status{
            obtain_times = ObtainTimes
        } = RewardStatus when ResetTimes =/= 0 ->
            NewObtainTimes = ObtainTimes + 1,
            HTimes = maps:get({HType, ObjId}, StatisticsTimesMap, 0),
            %?PRINT(SType == 101,"@@@@@@@@@@@@@@@@ HTimes:~p~n",[HTimes]),
            case HTimes > 0 andalso HTimes rem ResetTimes == 0 andalso lists:member(HType, ?NEW_TREASURE_HUNT_TYPE_RULE) =/= true of
                true ->
                    NewStatisticsRewardMap = maps:remove({HType, SType, ObjId}, StatisticsRewardMap);
                false ->
                    case lists:member(H, UpdateLim) of
                        true ->
                            NewRewardStatus = RewardStatus#reward_status{obtain_times = NewObtainTimes, last_draw_times = HTimes},
                            NewStatisticsRewardMap = maps:put({HType, SType, ObjId}, NewRewardStatus, StatisticsRewardMap);
                        false ->
                            NewStatisticsRewardMap = StatisticsRewardMap
                    end
            end;
        _ ->
            HTimes = maps:get({HType, ObjId}, StatisticsTimesMap, 0),
            case lists:member(H, UpdateLim) of
                true when HTimes > 0 andalso HTimes rem ResetTimes == 0 ->
                    NewStatisticsRewardMap = StatisticsRewardMap;
                true  ->
                    NewObtainTimes = 1,
                    NewRewardStatus = #reward_status{htype = HType, stype = SType, obj_id = ObjId, obtain_times = NewObtainTimes, last_draw_times = HTimes},
                    NewStatisticsRewardMap = maps:put({HType, SType, ObjId}, NewRewardStatus, StatisticsRewardMap);
                false ->
                    NewStatisticsRewardMap = StatisticsRewardMap
            end
    end,
    update_reward_map(Tail, UpdateLim, StatisticsTimesMap, NewStatisticsRewardMap).

%% -----------------------------------------------------------------
%% @desc    功能描述
%% -----------------------------------------------------------------
correct_statistics_reward(CurrentTimes, IsNewRule, _SType, StatisticsRewardMap, RewardCfg, RoleId) when IsNewRule == true ->
    #treasure_hunt_reward_cfg{htype = HType, stype = SType} = RewardCfg,
    ObjList = data_treasure_hunt:get_reward_limit_obj(HType, SType),
    Fun = fun
              ({HType2, SType2, LimObj}, CorrectData) when HType2 == HType andalso SType2 == SType ->
                  case data_treasure_hunt:get_reward_limit(HType2, SType2, LimObj) of
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
            IsRemoveObj = lib_treasure_hunt_data:calc_is_remove_obj(RealTimes, RewardCfg),
            case IsRemoveObj of
                true ->
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

get_max_simulation_number() ->
    Sql = io_lib:format(<<"SELECT max(simulation_id) FROM log_treasure_hunt_imitate">>, []),
    case db:get_row(Sql) of
        [undefined] -> 0;
        [] -> 0;
        List when is_list(List) andalso length(List) > 0 ->
            hd(List);
        _ -> 0
    end.

%%db_batch_insert_data(ResultList) ->
%%    Sql = usql:replace(log_treasure_hunt_imitate,
%%        [
%%            simulation_id,
%%            hunt_type,
%%            times,
%%            lucky_value,
%%            reward_id,
%%            rewards,
%%            time,
%%            reward_type,
%%            is_rare
%%        ], ResultList),
%%    db:execute(Sql).
%% 替换成日志入库的API
db_batch_insert_data(ResultList) ->
    lib_log_api:log_treasure_hunt_imitate(ResultList).