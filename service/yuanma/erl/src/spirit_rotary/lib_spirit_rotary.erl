
-module(lib_spirit_rotary).

-compile(export_all).
-include("spirit_rotary.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("goods.hrl").

%%%%%%%% 登陆
login(PS) -> 
	#player_status{id = RoleId} = PS,
    case db_select_spirit_rotary(RoleId) of 
        [] -> 
            InitBlessValue = data_spirit_rotary:get_key(?ROTARY_KEY_7),
            SpiritRotarySt = #spirit_rotary_status{bless_value = InitBlessValue};
        [BlessValue, AccCount] ->
            SpiritRotarySt = #spirit_rotary_status{bless_value = BlessValue, acc_count = AccCount}
    end,
    PS#player_status{spirit_rotary_status = SpiritRotarySt}.

%% 抽奖 RotaryId：1普通 2高级
get_reward(PS, RotaryId, Count) ->
    #player_status{id = RoleId, spirit_rotary_status = SpiritRotarySt} = PS,
    #spirit_rotary_status{bless_value = BlessValue, acc_count = AccCount} = SpiritRotarySt,
    %% 获取抽奖消耗
    CostList = get_cost(RotaryId, Count),
    case draw_reward_core(1, Count, RotaryId, BlessValue, []) of 
        {NewBlessValue, RewardList} ->
            case lib_goods_api:cost_object_list_with_check(PS, CostList, spirit_rotary, lists:concat([RotaryId, "_", Count])) of 
                {true, PSCost} ->
                    lib_log_api:log_spirit_rotary(RoleId, RotaryId, Count, BlessValue, NewBlessValue, CostList, RewardList),
                    NewAccCount = AccCount + Count,
                    db_replace_spirit_rotary(RoleId, NewBlessValue, NewAccCount),
                    NewSpiritRotarySt = SpiritRotarySt#spirit_rotary_status{bless_value = NewBlessValue, acc_count = NewAccCount},
                    PSRotary = PSCost#player_status{spirit_rotary_status = NewSpiritRotarySt},
                    Produce = #produce{type = spirit_rotary, reward = RewardList},
                    {ok, PSReward} = lib_goods_api:send_reward_with_mail(PSRotary, Produce),
                    {ok, NewBlessValue, RewardList, PSReward};
                {false, Res, _} ->
                    {false, Res}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

draw_reward_core(Count, CountMax, _RotaryId, BlessValue, RewardList) when Count > CountMax ->
    {BlessValue, RewardList};
draw_reward_core(Count, CountMax, RotaryId, BlessValue, RewardList) ->
    case get_rotary_reward(RotaryId, BlessValue) of
        none ->
            none;
        Rewards ->
            BlessValueAdd = get_bless_value_add(RotaryId),
            NewBlessValue = BlessValue + BlessValueAdd,
            draw_reward_core(Count+1, CountMax, RotaryId, NewBlessValue, Rewards ++ RewardList)
    end.

get_cost(RotaryId, Count) ->
    if
        Count == 1 andalso RotaryId == 1 -> Key = ?ROTARY_KEY_1;
        Count == 1 -> Key = ?ROTARY_KEY_2;
        RotaryId == 1 -> Key = ?ROTARY_KEY_3;
        true -> Key = ?ROTARY_KEY_4
    end,
    data_spirit_rotary:get_key(Key).

get_rotary_reward(1, BlessValue) ->
    MaxBlessValue = data_spirit_rotary:get_max_bless_value(),
    Pool = data_spirit_rotary:get_common_reward_pool(min(BlessValue, MaxBlessValue)),
    get_rotary_reward_do(Pool);
get_rotary_reward(_, BlessValue) ->
    MaxBlessValue = data_spirit_rotary:get_max_bless_value(),
    Pool = data_spirit_rotary:get_high_reward_pool(min(BlessValue, MaxBlessValue)),
    get_rotary_reward_do(Pool).

get_rotary_reward_do(Pool) ->
    case util:find_ratio(Pool, 4) of 
        {GType, GTypeId, Num, _} ->
            [{GType, GTypeId, Num}];
        _ -> 
            none
    end.

set_bless_value(PS, BlessValue) ->
    #player_status{id = RoleId, spirit_rotary_status = SpiritRotarySt} = PS,
    #spirit_rotary_status{acc_count = AccCount} = SpiritRotarySt,
    db_replace_spirit_rotary(RoleId, BlessValue, AccCount),
    NewSpiritRotarySt = SpiritRotarySt#spirit_rotary_status{bless_value = BlessValue},
    PS#player_status{spirit_rotary_status = NewSpiritRotarySt}.

get_bless_value_add(2) ->
    data_spirit_rotary:get_key(?ROTARY_KEY_6);
get_bless_value_add(_) ->
    data_spirit_rotary:get_key(?ROTARY_KEY_5).


db_select_spirit_rotary(RoleId) ->
    db:get_row(io_lib:format(<<"select bless_value, acc_count from `spirit_rotary` where role_id=~p">>, [RoleId])).

db_replace_spirit_rotary(RoleId, BlessValue, AccCount) ->
    db:execute(io_lib:format(<<"replace into `spirit_rotary` set role_id=~p, bless_value=~p, acc_count=~p ">>, [RoleId, BlessValue, AccCount])).

%% lib_spirit_rotary:gm_cost_bless_value(0, "", "", 1).
gm_cost_bless_value(StartTime, Title, Content, Opr) ->
    case Opr of 
        1 ->
            StaticList = gm_get_cost_bless_value(StartTime),
            F = fun({RoleId, Value}, List) ->
                Str = lists:concat([RoleId, "_", Value]),
                List ++ Str ++ ","
            end,
            InfoStr = lists:foldl(F, "", StaticList),
            InfoStr;
            %util:term_to_string(StaticList);
        _ ->
            StaticList = gm_get_cost_bless_value(StartTime),
            gm_cost_bless_value_do(StaticList, Title, Content),
            ok
    end.

gm_get_cost_bless_value(StartTime) ->
    StaticList = lib_week_dungeon:gm_static_product_do(StartTime),
    F = fun({RoleId, RewardList}, {Acc, List}) ->
        F2 = fun({_, GTypeId, Num}, Acc1) ->
            case GTypeId == 21040001 of 
                true -> Acc1 + Num;
                _ -> Acc1
            end
        end,
        AccNum = lists:foldl(F2, 0, RewardList),
        Value = AccNum * data_spirit_rotary:get_key(?ROTARY_KEY_5),
        %TotalNum = lists:sum([Num || {_, GTypeId, Num} <- RewardList, GTypeId == 21040001]),
        case Value > 0 of 
            true ->
                {Acc+1, [{RoleId, Value}|List]};
            _ ->
                {Acc+1, List}
        end
    end,
    {_, StaticList2} = lists:foldl(F, {1, []}, StaticList),
    StaticList2.

gm_cost_bless_value_do(StaticList, Title, Content) ->
    F = fun({RoleId, Value}, {Acc, List}) ->
        case Value > 200 of 
            true ->
                NewValue = Value - 200,
                %?PRINT("gm_cost_bless_value_do : ~p~n", [{RoleId, Value}]),
                case lib_player:get_alive_pid(RoleId) of 
                    false ->
                        case db_select_spirit_rotary(RoleId) of 
                            [BlessValue, _AccCount] ->
                                lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
                                db:execute(io_lib:format(<<"update `spirit_rotary` set bless_value = ~p where role_id=~p ">>, [max(100, BlessValue-NewValue), RoleId]));
                            _ ->
                                ok
                        end;
                    Pid -> 
                        lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, gm_cost_bless_value_ps, [NewValue, Title, Content])
                end,
                {Acc+1, [{RoleId, NewValue}|List]};
            _ ->
                {Acc+1, List}
        end
    end,
    {_, _StaticList2} = lists:foldl(F, {1, []}, StaticList),
    ok.

gm_cost_bless_value_ps(PS, Value, Title, Content) ->
    #player_status{id = RoleId, spirit_rotary_status = SpiritRotarySt} = PS,
    #spirit_rotary_status{bless_value = BlessValue, acc_count = AccCount} = SpiritRotarySt,
    NewBlessValue = max(100, BlessValue-Value),
    db_replace_spirit_rotary(RoleId, NewBlessValue, AccCount),
    %?PRINT("gm_cost_bless_value_ps : ~p~n", [{BlessValue, NewBlessValue}]),
    NewSpiritRotarySt = SpiritRotarySt#spirit_rotary_status{bless_value = NewBlessValue},
    lib_server_send:send_to_sid(PS#player_status.sid, pt_509, 50901, [NewBlessValue]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
    PS#player_status{spirit_rotary_status = NewSpiritRotarySt}.