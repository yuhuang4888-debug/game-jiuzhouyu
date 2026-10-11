-module(lib_luckey_wheel_mod).

-include("custom_act.hrl").
-include("luckey_wheel.hrl").
-include("common.hrl").
-include("def_module.hrl").

-compile(export_all).

init_helper(Type, SubType) ->
    % Now = utime:unixtime(),
    List = db:get_all(io_lib:format(?SELECT_ROLR_DATA, [Type, SubType])),
    RoleData = [{RoleId, DrawTimes}||[RoleId, DrawTimes] <- List],
    [PoolReward, DrawTimes] = case db:get_row(io_lib:format(?SELECT_ACT_DATA, [Type, SubType])) of
                                    [Value, Value1] -> [util:bitstring_to_term(Value), Value1];
                                    _ ->
                                        #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                                        case lists:keyfind(base_pool_reward, 1, Conditions) of
                                            {_, PReward} -> skip;
                                            _ -> PReward = [{1, 0, 3000}]
                                        end,
                                        [PReward, 0]
                              end,
    List2 = db:get_all(io_lib:format(?SELECT_ACT_RECORD, [Type, SubType])),
    RecordList = [
        #wheel_record{
            key = {Type, SubType},
            server = config:get_server_id(),
            server_num = config:get_server_num(),
            role_id = RoleId,
            role_name = RoleName,
            reward = util:bitstring_to_term(Reward),
            stime = Stime}
    ||[RoleId, RoleName, Reward, Stime] <- List2],

    List3 = db:get_all(io_lib:format(?SELECT_ACT_GRADE_DATA, [Type, SubType])),
    Fun = fun([RoleId, Grade, Num, Time], Acc) ->
        Key = {Type, SubType},
        TemList = maps:get(Key, Acc, []),
        NewTemList =
        case lists:keyfind(RoleId, 1, TemList) of
            {_, TemList1} ->
                NewTemList1 = lists:keystore(Grade, 1, TemList1, {Grade, Num, Time}),
                lists:keystore(RoleId, 1, TemList, {RoleId, NewTemList1});
            _ ->
                lists:keystore(RoleId, 1, TemList, {RoleId, [{Grade, Num, Time}]})
        end,
        maps:put(Key, NewTemList, Acc)
    end,
    Map = lists:foldl(Fun, #{}, List3),

    ActData = #act_data{key = {Type, SubType}, pool_reward = PoolReward,
            draw_times = DrawTimes, role_data = RoleData, role_counter = Map},
    {ActData, RecordList}.

do_draw_reward(_, _, _, DrawTimes, RoleDrawTimes, 0, RoleCounterList, GradeIdList) ->
    {DrawTimes, RoleDrawTimes, RoleCounterList, GradeIdList};
do_draw_reward(Type, SubType, RoleId, DrawTimes, RoleDrawTimes, Times, RoleCounterList, GradeIdList) ->
    {Pool, SpeList} = calc_pool(Type, SubType, RoleDrawTimes+1, RoleCounterList),
    GradeId = urand:rand_with_weight(Pool),
    case lists:member(GradeId, SpeList) of
        true ->
            Now = utime:unixtime(),
            case lists:keyfind(GradeId, 1, RoleCounterList) of
                {_, Num, _} -> NewNum = Num+1;
                _ -> NewNum = 1
            end,
            NewList = lists:keystore(GradeId, 1, RoleCounterList, {GradeId, NewNum, Now}),
            db:execute(io_lib:format(?UPDATE_ACT_GRADE_DATA, [RoleId, Type, SubType, GradeId, NewNum, Now]));
        _ ->
            NewList = RoleCounterList
    end,
    do_draw_reward(Type, SubType, RoleId, DrawTimes+1, RoleDrawTimes+1, Times-1, NewList, [GradeId|GradeIdList]).


calc_pool(Type, SubType, RoleDrawTimes, RoleCounterList) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    % #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    Fun = fun(GradeId, {Acc, SpeList}) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{condition = Conditions} ->
                case lists:keyfind(weight, 1, Conditions) of
                    {weight, SpecialList, BaseWeight} ->
                        Weight = calc_weight(RoleDrawTimes, SpecialList, BaseWeight),
                        {[{Weight, GradeId}|Acc], SpeList};
                    {weight, SpecialList, BaseWeight, NeedCounter} ->
                        case lists:keyfind(GradeId, 1, RoleCounterList) of
                            {_, Num, _} when Num > 0 andalso NeedCounter == 1 ->
                                Weight = BaseWeight;
                            _ ->
                                Weight = calc_weight(RoleDrawTimes, SpecialList, BaseWeight)
                        end,
                        NewSpeList = [GradeId|SpeList],
                        {[{Weight, GradeId}|Acc], NewSpeList};
                    _ -> {Acc, SpeList}
                end;
            _ ->
                ?ERR("custom_act, condition:weight miss! Type:~p SubType:~p, GradeId:~p~n",[Type,SubType,GradeId]),
                {Acc, SpeList}
        end
    end,
    lists:foldl(Fun, {[], []}, GradeIdList).

calc_weight(RoleDrawTimes, SpecialList, BaseWeight) ->
    F1 = fun({MinDrawtimes, MaxDrawtimes, _}) ->
        RoleDrawTimes >= MinDrawtimes andalso RoleDrawTimes =< MaxDrawtimes
    end,
    case ulists:find(F1, SpecialList) of
        {ok, {_, _, AddWeight}} -> Weight = AddWeight + BaseWeight;
        _ -> Weight = BaseWeight
    end,
    Weight.

calc_pool_reward(Times, ActConditions) ->
    case lists:keyfind(add_reward_draw, 1, ActConditions) of
        {add_reward_draw, AddList} ->
            Fun = fun({GType, Gtype, Num}, Acc) ->
                [{GType, Gtype, Num*Times}|Acc]
            end,
            lists:foldl(Fun, [], AddList);
        _ ->
            []
    end.

handle_draw_grade(_, _, _, _, _, _, _, _, [], NewRecordList, AddRecord, DeletPool) -> {NewRecordList, AddRecord, DeletPool};
handle_draw_grade(Type, SubType, PoolReward, IsKF, RoleId, RoleName, Server, ServerNum, [GradeId|GradeIdList], RecordList, AddRecord, DeletPool) ->
    #custom_act_reward_cfg{condition = Conditions, reward = CfgReward} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    if
        CfgReward == [] ->
            Reward = lib_luckey_wheel:calc_draw_pool_reward(Conditions, PoolReward),
            DeletePoolReward = ulists:object_list_plus([Reward, DeletPool]);
        true ->
            [_, Sex, Lv, Career, _, _, _, _, _, _, _|_] = lib_player:get_player_low_data(RoleId),
            #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
            RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
            DeletePoolReward = DeletPool,
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg)
    end,
    case lists:keyfind(rare, 1, Conditions) of
        {rare, Rare} when Rare >= 1 ->
            Now = utime:unixtime(),
            db:execute(io_lib:format(?UPDATE_ACT_RECORD, [Type, SubType, RoleId, RoleName, util:term_to_string(Reward), Now])),
            case lists:keyfind(tv, 1, Conditions) of
                {tv, {ModuleId, TvId}} ->
                    if
                        TvId > 0 andalso Reward =/= [] ->
                            [{Gtype, GoodsTypeId, GNum}|_] = Reward,
                            RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
                            lib_chat:send_TV({all}, ModuleId, TvId, [RoleName, RoleId, RealGtypeId, GNum, Type, SubType]);
                        true ->
                            skip
                    end;
                _ ->
                    skip
            end,
            Record = #wheel_record{
                key = {Type, SubType},
                server = Server,
                server_num = ServerNum,
                role_id = RoleId,
                role_name = RoleName,
                reward = Reward,
                stime = Now},
            NewAddList = [Record|AddRecord],
            NewRecordList = [Record|RecordList];
        _ ->
            NewAddList = AddRecord,
            NewRecordList = RecordList
    end,
    handle_draw_grade(Type, SubType, PoolReward, IsKF, RoleId, RoleName, Server, ServerNum, GradeIdList, NewRecordList, NewAddList, DeletePoolReward).

handle_record(NewRecordList) ->
    NewList = lists:reverse(lists:keysort(#wheel_record.stime, NewRecordList)),
    lists:sublist(NewList, 20).



get_conditions(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} -> skip;
        _ -> Times = 0
    end,
    Times.

%% object_list列表元素相减 list1 - list2
object_list_minus([List]) ->
    F = fun
    ({ {ObjectType, GoodsId}, Num}, AccList) ->
        [{ObjectType, GoodsId, Num}| AccList];
    ({ObjectType, GoodsId, Num}, AccList) ->
        [{ObjectType, GoodsId, Num}| AccList]
    end,
    lists:foldl(F, [], List);
object_list_minus([List1, List2|T]) ->
    NewList1 = object_list_transfer([], List1),
    SumList = object_list_minus(NewList1, List2),
    object_list_minus([SumList|T]).

object_list_transfer(List1, [{ObjectType, GoodsId2, Num2}|T]) ->
    object_list_minus([{ {ObjectType, GoodsId2}, Num2}| lists:keydelete({ObjectType, GoodsId2}, 1, List1)], T).

object_list_minus(List, []) -> List;
object_list_minus(List1, [{ObjectType, GoodsId2, Num2}|T]) ->
    NewObjectList = case lists:keyfind({ObjectType, GoodsId2}, 1, List1) of
        {_, GoodsNum} when GoodsNum > Num2 -> [{ {ObjectType, GoodsId2}, GoodsNum - Num2}| lists:keydelete({ObjectType, GoodsId2}, 1, List1)];
        {_, _} -> lists:keydelete({ObjectType, GoodsId2}, 1, List1); % GoodsNum == Num2 拿走全部奖池的大奖
        false    -> List1
    end,
    object_list_minus(NewObjectList, T);
object_list_minus(List1, [{{ObjectType, GoodsId2}, Num2}|T]) ->
    NewObjectList = case lists:keyfind({ObjectType, GoodsId2}, 1, List1) of
        {_, GoodsNum} when GoodsNum > Num2 -> [{ {ObjectType, GoodsId2}, GoodsNum - Num2}| lists:keydelete({ObjectType, GoodsId2}, 1, List1)];
        {_, _} -> lists:keydelete({ObjectType, GoodsId2}, 1, List1); % GoodsNum == Num2 拿走全部奖池的大奖
        false    -> List1
    end,
    object_list_minus(NewObjectList, T).