%%-----------------------------------------------------------------------------
%% @Module  :       lib_treasure_hunt_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-22
%% @Description:    寻宝逻辑模块
%%-----------------------------------------------------------------------------
-module(lib_treasure_hunt_mod).

-include("treasure_hunt.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("counter.hrl").
-include("def_fun.hrl").

-export([
    init/0
    , make_record/2
    , pack_record_list/1
    , treasure_hunt/11
    , handle_treasure_hunt_reward/3
    , get_htype_record/2
    , get_free_treasure_hunt/4
    , get_common_map/2
    , init_common_funcation_map/2
    ,init_statistics_reward_map/2
    ,init_statistics_times_map/2
    ,get_rewardcfg/6
    ]).

make_record(reward_status, [HType, Stype, ObjId, ObtainTimes, LastDrawTimes]) ->
    #reward_status{
        htype = HType,
        stype = Stype,
        obj_id = ObjId,
        obtain_times = ObtainTimes,
        last_draw_times = LastDrawTimes
    };
make_record(reward_record, [RoleId, RoleName, RoleLv, FigArgs, HType, GTypeId, GoodsNum, Time, Rare]) ->
    [Sex, Career, Pic, PicVer] = FigArgs,
    #reward_record{
        role_id = RoleId,
        role_name = RoleName,
        role_lv = RoleLv,
        sex = Sex,
        career = Career,
        picture = Pic,
        picture_ver = PicVer,
        htype = HType,
        gtype_id = GTypeId,
        goods_num = GoodsNum,
        time = Time,
        is_rare = Rare
    };
make_record(common_funcation, [Times, NextFreeTime]) ->
    #common_funcation{
        free_times = Times,
        next_free_time = NextFreeTime
    }.

init() ->
    List = db:get_all(io_lib:format(?sql_select_treasure_hunt_reward, [])),
    List1 = db:get_all(io_lib:format(?sql_select_treasure_hunt_times, [])),
    List2 = db:get_all(io_lib:format(?sql_select_treasure_hunt_luckey_value, [])),
    StatisticsRewardMap = init_statistics_reward_map(List, #{}),
    StatisticsTimesMap = init_statistics_times_map(List1, #{}),
    LuckeyMap = init_luckey_map(List2, #{}),
    case data_treasure_hunt:get_cfg(equip_treasure_luckey_value) of
        [_,{time, Time},_]  ->skip;
        _ ->
            Time = 300
    end,
    Ref = erlang:send_after(Time*1000, self(), 'timer_add_value'),
    % Ref = undefined,
    #treasure_hunt_state{
        statistics_reward_map = StatisticsRewardMap,
        statistics_times_map = StatisticsTimesMap,
        luckey_map = LuckeyMap,
        luckey_val_ref = Ref
    }.

init_statistics_reward_map([], Map) -> Map;
init_statistics_reward_map([T|L], Map) ->
    RewardStatus = make_record(reward_status, T),
    #reward_status{
        htype = HType,
        stype = Stype,
        obj_id = ObjId
    } = RewardStatus,
    NewMap = maps:put({HType, Stype, ObjId}, RewardStatus, Map),
    init_statistics_reward_map(L, NewMap).

init_statistics_times_map([], Map) -> Map;
init_statistics_times_map([[HType, ObjId, HTimes]|L], Map) ->
    NewMap = maps:put({HType, ObjId}, HTimes, Map),
    init_statistics_times_map(L, NewMap).

init_common_funcation_map([],Map) ->Map;
init_common_funcation_map([[RoleId, HType, Times, NextFreeTime]|T], Map) ->
    ComFun = make_record(common_funcation, [Times, NextFreeTime]),
    NewMap = maps:put({RoleId, HType}, ComFun, Map),
    init_common_funcation_map(T, NewMap).

init_luckey_map([], Map) -> Map;
init_luckey_map([[HType, Value]|T], Map) ->
    NewMap = maps:put(HType, Value, Map),
    init_luckey_map(T, NewMap).

get_common_map(RoleId, OldMap) ->
    Fun = fun(HType, Map) ->
        List = db:get_all(io_lib:format(?sql_select_treasure_hunt_extra, [RoleId, HType])),
        init_common_funcation_map(List, Map)
    end,
    NewMap = lists:foldl(Fun, OldMap, ?TREASURE_HUNT_TYPE_LIST),
    NewMap.

treasure_hunt(State, ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, FigArgs, HType, Times, _AutoBuy) ->
    #treasure_hunt_state{
        statistics_reward_map = StatisticsRewardMap,
        statistics_times_map = StatisticsTimesMap,
        record_map = RecordMap,
        luckey_map = LuckeyMap,
        old_luckey_map = OldLuckeyMap,
        protect_ref = ProtectRef,
        luckey_val_protect_ref = ProRef
    } = State,
    case HType of
        ?TREASURE_HUNT_TYPE_EUQIP ->
            EquipHTimes = mod_counter:get_count(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_TIMES),
            case EquipHTimes > 0 of
                true -> IsFirstEquipHunt = false;
                _ -> IsFirstEquipHunt = true
            end;
        _ -> IsFirstEquipHunt = false
    end,           %%yyhx暂时没有这个需求
    CanUpdateLuckeyValue = if
        HType == ?TREASURE_HUNT_TYPE_BABY -> false;
        ProRef == undefined -> true;
        true -> false 
    end,
    OpenDay = util:get_open_day(),
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    F = fun() ->
        {RewardList, NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, NewOldLuckeyMap, NewProtectRef}
            = do_treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, HType, 0, Times, [], StatisticsRewardMap, 
                    StatisticsTimesMap, LuckeyMap, IsFirstEquipHunt, OldLuckeyMap, CanUpdateLuckeyValue, ProtectRef),
        {ok, RewardList, NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, NewOldLuckeyMap, NewProtectRef}
    end,
    case catch db:transaction(F) of
        {ok, RewardList, NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, NewOldLuckeyMap, NewProtectRef} ->
            case IsFirstEquipHunt of
                true ->
                    {ok, Bin} = pt_416:write(41611, [1]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    mod_counter:increment(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_TIMES);
                false -> skip
            end,
            IsMember = lists:member(HType, ?LUCKEY_TREASURE_HUNT_TYPE_LIST),
            if
                (OpenDay < OpenDayLimit orelse CanUpdateLuckeyValue == false) andalso IsMember == true ->
                    lib_treasure_hunt_data:notify_client_luckey_value(HType, NewOldLuckeyMap, NewLuckeyMap);
                true ->
                    if
                        IsMember == true ->
                            mod_cluster_luckey_value:cast_center([{'notify_client_luckey_value', ServerId, HType}]);
                        true ->
                            skip
                    end
            end,
            OldLuckeyVal = maps:get(HType, LuckeyMap, 0),
            NewLuckeyVal = maps:get(HType, NewLuckeyMap, 0),
            NewRecordMap = lib_treasure_hunt_data:add_treasure_hunt_record(RecordMap, RewardList, RoleId, RoleName, RoleLv, FigArgs, HType),
            NewState = State#treasure_hunt_state{
                statistics_reward_map = NewStatisticsRewardMap,
                statistics_times_map = NewStatisticsTimesMap,
                record_map = NewRecordMap,
                luckey_map = NewLuckeyMap,
                old_luckey_map = NewOldLuckeyMap,
                protect_ref = NewProtectRef
            },
            [{ok, RewardList, CanUpdateLuckeyValue, OldLuckeyVal, NewLuckeyVal}, NewState];
        _Err ->
            ?PRINT("_Err:~p~n",[_Err]),
            [?ERRCODE(fail), State]
    end.

do_treasure_hunt(_, _, _, _, _, _, _, TotalTimes, TotalTimes, RewardList, StatisticsRewardMap, StatisticsTimesMap, 
LuckeyMap, _IsFirstEquipHunt, OldLuckeyMap, _CanUpdateLuckeyValue, ProtectRef) ->
    {RewardList, StatisticsRewardMap, StatisticsTimesMap, LuckeyMap, OldLuckeyMap, ProtectRef};
do_treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, HType, CurTimes, TotalTimes, 
RewardList, StatisticsRewardMap, StatisticsTimesMap, LuckeyMap, IsFirstEquipHunt, OldLuckeyMap, CanUpdateLuckeyValue, ProtectRef) ->
    UseTimes = maps:get({HType, RoleId}, StatisticsTimesMap, 0),
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
                    {RewardCfg, FixNewStatisticsRewardMap} = get_rewardcfg(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes)
            end;
        _ ->
            {RewardCfg, FixNewStatisticsRewardMap} = get_rewardcfg(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes)
    end,
    case RewardCfg of
        #treasure_hunt_reward_cfg{
            goods_id = GTypeId,
            goods_num = GoodsNum,
            stype = Stype,
            is_rare = Rare
        } ->
            OpenDay = util:get_open_day(),
            OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
            IsMember = lists:member(HType, ?LUCKEY_TREASURE_HUNT_TYPE_LIST),
            if
                OpenDay < OpenDayLimit orelse CanUpdateLuckeyValue == false orelse IsMember == false ->
                    if
                        Rare == 1 andalso CanUpdateLuckeyValue ->
                            TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
                            case data_goods_type:get(GTypeId) of
                                #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                                _ -> GoodsName = "", Color = 0
                            end,
                            lib_chat:send_TV({all}, ?MOD_TREASURE_HUNT, 5, [RoleName, TreasureHuntName, Color, GoodsName]);
                        Rare == 1 ->
                            TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
                            case data_goods_type:get(GTypeId) of
                                #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                                _ -> GoodsName = "", Color = 0
                            end,
                            case HType of 
                                ?TREASURE_HUNT_TYPE_BABY ->
                                    lib_chat:send_TV({all}, ?MOD_TREASURE_HUNT, 8, [RoleName, TreasureHuntName, Color, GoodsName]);
                                _ ->
                                    lib_chat:send_TV({all}, ?MOD_TREASURE_HUNT, 6, [RoleName, TreasureHuntName, Color, GoodsName])
                            end;
                        true ->
                            skip
                    end;
                true ->
                    if
                        IsMember == true ->
                            %% 跨服幸运值系统
                            RecordArgs = [ServerId, ServerNum, RoleId, RoleName, MaskId, HType, GTypeId, GoodsNum, utime:unixtime(), Rare],
                            mod_cluster_luckey_value:cast_center([{'update_luckey_value_map', ServerId, HType, Rare, RecordArgs}]);
                        true ->
                            skip
                    end
            end,

            if
                Stype == 240 ->
                    OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
                    {ok, BinData} = pt_416:write(41615, [HType]),
                    lib_server_send:send_to_all(all_lv, {OpenLv, 99999}, BinData);
                true ->
                    skip
            end,

            {NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, NewOldLuckeyMap, NewProtectRef}
                = lib_treasure_hunt_data:update_statistics_map(RoleId, RewardCfg, FixNewStatisticsRewardMap, StatisticsTimesMap,
                    LuckeyMap, OldLuckeyMap, CanUpdateLuckeyValue, ProtectRef),

            do_treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, HType, CurTimes + 1, TotalTimes, [RewardCfg|RewardList],
                NewStatisticsRewardMap, NewStatisticsTimesMap, NewLuckeyMap, IsFirstEquipHunt, NewOldLuckeyMap, CanUpdateLuckeyValue, NewProtectRef);
        _ ->
            do_treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, HType, CurTimes + 1, TotalTimes, RewardList,
                FixNewStatisticsRewardMap, StatisticsTimesMap, LuckeyMap, IsFirstEquipHunt, OldLuckeyMap, CanUpdateLuckeyValue, ProtectRef)
    end.

get_rewardcfg(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes) ->
    {AlternativeList, SpecialReward, _HasNext, NewStatisticsRewardMap} = lib_treasure_hunt_data:count_reward_list(StatisticsRewardMap, LuckeyMap, RoleId, RoleLv, HType, UseTimes),
    %% ?MYLOG("lhh_hunt", "Args:~p", [{AlternativeList, SpecialReward}]),
    RealSpecialReward = urand:list_rand(SpecialReward),
    if
        is_record(RealSpecialReward, treasure_hunt_reward_cfg) -> 
            RewardCfg = RealSpecialReward;
        true ->
            case urand:rand_with_weight(AlternativeList) of
                RewardCfg when is_record(RewardCfg, treasure_hunt_reward_cfg) -> skip;
                _ -> RewardCfg = false
            end
    end,
    {RewardCfg, NewStatisticsRewardMap}.

get_free_treasure_hunt(State, RoleId, HType, Nowtime) ->
    #treasure_hunt_state{common_map = ComMap} = State,
    Res = case maps:get({RoleId, HType}, ComMap, []) of
        #common_funcation{free_times= Times, next_free_time = NextFreeTime} -> 
            if
                Times =/= 0 ->
                    {true, Times, 0};
                NextFreeTime =< Nowtime andalso NextFreeTime > 0 ->
                    {true, 1, 0};
                true ->
                    {false, 0, NextFreeTime}
            end;
        _ -> {false, 0,0}
    end,
    Res.
handle_treasure_hunt_reward(RoleName, HType, List) ->
    F = fun(T, Acc) ->
        #treasure_hunt_reward_cfg{
            goods_id = GTypeId,
            goods_num = GoodsNum,
            is_rare = Rare,
            is_tv = IsTv
        } = T,
        case IsTv == 1 andalso Rare =/= 1 of %% 稀有物品传闻特殊处理
            true when HType =/= ?TREASURE_HUNT_TYPE_BABY ->
                TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
                case data_goods_type:get(GTypeId) of
                    #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                    _ -> GoodsName = "", Color = 0
                end,
                lib_chat:send_TV({all}, ?MOD_TREASURE_HUNT, HType, [RoleName, TreasureHuntName, Color, GoodsName]);
            _ -> skip
        end,
        case lists:keyfind(GTypeId, 1, Acc) of
            {GTypeId, PreNum} ->
                lists:keystore(GTypeId, 1, Acc, {GTypeId, PreNum + GoodsNum});
            _ ->
                [{GTypeId, GoodsNum}|Acc]
        end
    end,
    RewardList = lists:foldl(F, [], List),
    if
        HType == ?TREASURE_HUNT_TYPE_BABY ->
            F1 = fun({GoodsTypeId, GoodsNum}, L) ->
                case data_goods_type:get(GoodsTypeId) of 
                    #ets_goods_type{bag_location = BagLogcation} ->
                        [{location, BagLogcation, GoodsTypeId, GoodsNum}|L];
                    _ ->
                        L
                end
            end,
            NewRewardList = lists:foldl(F1, [], RewardList);
        true ->
            NewRewardList = [{location, ?GOODS_LOC_TREASURE, GoodsTypeId, GoodsNum}||{GoodsTypeId, GoodsNum} <- RewardList]
    end,
    NewRewardList.

pack_record_list(List) ->
    do_pack_record_list(List, []).

do_pack_record_list([], Acc) -> Acc;
do_pack_record_list([T|L], Acc) when is_record(T, reward_record) ->
    #reward_record{
        role_id = RoleId,
        role_name = RoleName,
        htype = HType,
        gtype_id = GTypeId,
        goods_num = Num,
        is_rare = Rare,
        time = Time
    } = T,
    do_pack_record_list(L, [{RoleId, RoleName, HType, GTypeId, Num, Time, Rare}|Acc]);
do_pack_record_list([_|L], Acc) ->
    do_pack_record_list(L, Acc).

get_htype_record(HType, PackList) -> %%PackList:[{RoleId, RoleName, HType, GTypeId, Time, Rare}|Acc]
    Fun = fun
        ({RoleId, RoleName, OHType, GTypeId, Num, Time, Rare}, Acc) when OHType == HType ->
            [{RoleId, RoleName, HType, GTypeId, Num, Time, Rare}|Acc];
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, [], PackList).

