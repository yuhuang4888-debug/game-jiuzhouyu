%%-----------------------------------------------------------------------------
%% @Module  :       pp_level_act
%% @Author  :       xlh
%% @Email   :
%% @Created :       2019-5-26
%% @Description:    等级抢购商城
%%-----------------------------------------------------------------------------
-module(pp_level_act).

-include("level_rush_act.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").

-export([
        handle/3,
        make_data_for_client/1
    ]).

handle(61200, Player, []) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{lv = RoleLv}} = Player,
    NewActState = lib_level_act:init_data(Player, LvActState, RoleId, RoleLv),
    #lv_act_state{act_map = Map} = NewActState,
    SendList = make_data_for_client(Map),
    lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]),
    {ok, Player#player_status{lv_act = NewActState}};

handle(61201, Player, [Type, SubType, Grade]) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{lv = RoleLv, name = RoleName}} = Player,
    case check_condition(Player, LvActState, Type, SubType, Grade) of
        true ->
            if
                Type == ?LEVEL_HELP_GIFT ->
                    #base_lv_gift_reward{cost = CostCfg, reward_name = RewardName, reward = RewardL, condition = Conditions} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade);
                true ->
                    #base_lv_act_reward{cost = CostCfg, reward_name = RewardName, reward = RewardL, condition = Conditions} = data_level_act:get_act_reward_cfg(Type, SubType, Grade)
            end,
            #base_lv_act_open{open_lv = OpenLv, act_name = ActName, conditions = ActConditions} = data_level_act:get_act_cfg(Type, SubType),
            RealCost = lib_level_act:calc_real_cost(CostCfg, Conditions),
            ProduceCostType = lib_level_act:get_produce_type(Type),
            case lib_goods_api:cost_objects_with_auto_buy(Player, RealCost, ProduceCostType, [Type, SubType, Grade]) of
                {false, ErrorCode, NewPlayer} ->
                    lib_server_send:send_to_uid(RoleId, pt_612, 61201, [Type, SubType, Grade, ErrorCode]),
                    {ok, NewPlayer};
                {true, NewPlayer, CostList} ->
                    case lists:keyfind(tv, 1, Conditions) of
                        {tv, Mod, TvId} ->
                            if
                                Type == ?LEVEL_HELP_GIFT ->
                                    Data = [RoleName, RoleId, ActName, RewardName];
                                true ->
                                    case lists:keyfind(pic, 1, ActConditions) of
                                        {_, JumpId} -> skip;
                                        _ -> JumpId = 0
                                    end,
                                    Data = [RoleName, RoleId, ActName, RewardName, JumpId]
                            end,
                            lib_chat:send_TV({all_lv, OpenLv, 999}, Mod, TvId, Data);
                        _ ->
                            skip
                    end,
                    Produce = #produce{type = ProduceCostType, subtype = 0, reward = RewardL, remark = "",  show_tips = 1},
                    NewPS = lib_goods_api:send_reward(NewPlayer, Produce),
                    lib_log_api:log_level_act(NewPS, RoleName, Type, SubType, Grade, CostList, RewardL),
                    #lv_act_state{act_map = Map} = LvActState,
                    #lv_act_data{status = GradeStatus, ref = OldRef} = OldData = maps:get({Type, SubType}, Map, []),
                    util:cancel_timer(OldRef),
                    NewGradeStatus = lists:keystore(Grade, 1, GradeStatus, {Grade, ?HAS_BUY}),
                    LvActData = OldData#lv_act_data{status = NewGradeStatus, stime = utime:unixtime()},
                    lib_level_act:db_replace(LvActData, RoleId),
                    NewMap = maps:put({Type, SubType}, LvActData, Map),
                    NewActState = LvActState#lv_act_state{act_map = NewMap},
                    lib_server_send:send_to_uid(RoleId, pt_612, 61201, [Type, SubType, Grade, 1]),

                    RealNewActState = lib_level_act:init_data(NewPlayer, NewActState, RoleId, RoleLv),
                    if
                        Type == ?LEVEL_HELP_GIFT ->
                            SendList = pp_level_act:make_data_for_client(RealNewActState#lv_act_state.act_map),
                            lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]);
                        true ->
                            skip
                    end,
                    {ok, NewPS#player_status{lv_act = RealNewActState}}
            end;
        {false, Code} ->
            lib_server_send:send_to_uid(RoleId, pt_612, 61201, [Type, SubType, Grade, Code]),
            {ok, Player}
    end;

handle(61202, Player, [Type, SubType]) ->
    #player_status{id = RoleId} = Player,
    case data_level_act:get_act_cfg(Type, SubType) of
        #base_lv_act_open{act_name = ActName, open_lv = OpenLv, continue_time = ContinueTime,
                conditions = Conditions, circuit = Circuit, clear_type = ClearType} ->
            lib_server_send:send_to_uid(RoleId, pt_612, 61202, [Type, SubType, ActName, OpenLv, ContinueTime,
                util:term_to_string(Conditions), Circuit, ClearType]);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_612, 61202, [Type, SubType, <<>>, 0, 0,
                util:term_to_string([]), 0, 0])
    end,
    {ok, Player};

handle(61203, Player, [Type, SubType, Grade]) ->
    #player_status{id = RoleId} = Player,
    if
        Type == ?LEVEL_HELP_GIFT ->
            case data_level_act:get_gift_reward_cfg(Type, SubType, Grade) of
                #base_lv_gift_reward{recharge_id = Recharg,discount = Discount,cost = Cost,show = Show,reward = Reward,string = String,condition = Conditions} ->
                    lib_server_send:send_to_uid(RoleId, pt_612, 61203, [Type, SubType, [{Grade, util:term_to_string([]), util:term_to_string(Cost),
                        util:term_to_string(Show), String, util:term_to_string(Reward), util:term_to_string(Conditions), Recharg, Discount}]]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_612, 61203, [Type, SubType, []])
            end;
        true ->
            case data_level_act:get_act_reward_cfg(Type, SubType, Grade) of
                #base_lv_act_reward{
                    normal_cost = NormalCost, cost = Cost, show = Show, reward = Reward,
                    string = String, condition = Conditions, recharge_id = RechargeId
                } ->
                    lib_server_send:send_to_uid(RoleId, pt_612, 61203, [Type, SubType, [{Grade, util:term_to_string(NormalCost), util:term_to_string(Cost),
                        util:term_to_string(Show), String, util:term_to_string(Reward), util:term_to_string(Conditions), RechargeId, 0}]]);
                _ when Grade == 0 ->
                    GradeList = data_level_act:get_all_grade(Type, SubType),
                    Fun = fun(TemGrade, Acc) ->
                        #base_lv_act_reward{
                            normal_cost = NormalCost, cost = Cost, show = Show, reward = Reward,
                            string = String, condition = Conditions, recharge_id = RechargeId
                        }= data_level_act:get_act_reward_cfg(Type, SubType, TemGrade),
                        [{TemGrade, util:term_to_string(NormalCost), util:term_to_string(Cost), util:term_to_string(Show), String,
                                util:term_to_string(Reward), util:term_to_string(Conditions), RechargeId, 0}|Acc]
                    end,
                    SendList = lists:foldl(Fun, [], lists:reverse(GradeList)),
                    % ?PRINT("============= ~n",[]),
                    % SendList== [] andalso ?PRINT("@@@@@@@@@@@ Grade:~p,GradeList:~p,~p~n",[Grade, GradeList,{Type, SubType}]),
                    lib_server_send:send_to_uid(RoleId, pt_612, 61203, [Type, SubType, SendList]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_612, 61203, [Type, SubType, []])
            end
    end,
    {ok, Player};


handle(_Cmd, Player, _) -> {ok, Player}.



check_condition(Player, LvActState, Type, SubType, Grade) ->
    Now = utime:unixtime(),
    case LvActState of
        #lv_act_state{act_map = Map} ->
            case maps:get({Type, SubType}, Map, []) of
                #lv_act_data{end_time = EndTime, status = GradeStatus} ->
                    KeyvalueList = [
                        {is_enougth, Player, Type, SubType, Grade},
                        {open_time, Now, EndTime},
                        {grade_status, Grade, GradeStatus}],
                    check_list(KeyvalueList);
                _ ->
                    {false, ?ERRCODE(err612_time_out)}
            end
    end.


check_list([]) -> true;
check_list([KeyVal | Rest]) ->
    case check(KeyVal) of
        true ->
            check_list(Rest);
        Reason ->
            Reason
    end.

check({is_enougth, PS, Type, SubType, Grade}) ->
    case data_level_act:get_act_cfg(Type, SubType) of
        #base_lv_act_open{} when Type == ?LEVEL_HELP_GIFT ->
            case data_level_act:get_gift_reward_cfg(Type, SubType, Grade) of
                #base_lv_gift_reward{cost = CostCfg, condition = Conditions} ->
                    case lists:keyfind(cost_type, 1, Conditions) of
                        {_, CostType} when CostType == ?MONEY_TYPE_MONEY -> true;
                        _ ->
                            RealCost = lib_level_act:calc_real_cost(CostCfg, Conditions),
                            lib_goods_api:check_object_list_with_auto_buy(PS, RealCost)
                    end;
                _ ->
                    {false, ?ERRCODE(missing_config)}
            end;
        #base_lv_act_open{} ->
            case data_level_act:get_act_reward_cfg(Type, SubType, Grade) of
                #base_lv_act_reward{cost = CostCfg, condition = Conditions} ->
                    RealCost = lib_level_act:calc_real_cost(CostCfg, Conditions),
                    lib_goods_api:check_object_list_with_auto_buy(PS, RealCost);
                _ ->
                    {false, ?ERRCODE(missing_config)}
            end;
        _ ->
            {false, ?ERRCODE(missing_config)}
    end;
check({open_time, Now, EndTime}) ->
    if
        Now < EndTime ->
            true;
        true ->
            {false, ?ERRCODE(err612_time_out)}
    end;
check({grade_status, Grade, GradeStatus}) ->
    case lists:keyfind(Grade, 1, GradeStatus) of
        {Grade, ?NOT_BUY} ->
            true;
        _ ->
            {false, ?ERRCODE(err612_goods_null)}
    end;
check(_) -> {false, ?FAIL}.

make_data_for_client(ActMap) ->
    NowTime = utime:unixtime(),
    ActList = maps:to_list(ActMap),
    Fun = fun({_, #lv_act_data{end_time = EndTime, key = {Type, SubType}, status = GradeStatus, open_times = OpenTimes, old_status = OldStatus}}, Acc) ->
        #base_lv_act_open{conditions = ActConditions} = data_level_act:get_act_cfg(Type, SubType),
%%        {_, PushTimes} = ulists:keyfind(push_times, 1, ActConditions, {push_times, 0}), % 循环开启次数上限
        case EndTime > NowTime of
            true ->
                [{Type, SubType, EndTime, GradeStatus, OldStatus, util:term_to_string(ActConditions), OpenTimes}|Acc];
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], ActList).