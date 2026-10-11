%% ---------------------------------------------------------------------------
%% @doc lib_fortune_cat

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/5
%% @deprecated  招财猫
%% ---------------------------------------------------------------------------
-module(lib_fortune_cat).

-include("custom_act.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").

%% API
-compile([export_all]).

%% 转盘动画时间（一些数据需要转盘结束后才能发送）
-define(TURNTABLE_DELAY, 7000).

%% 发送活动信息
send_act_info(PS, #act_info{key = {Type, SubType}} = ActInfo, _IsNext) ->
    ?PRINT("send_act_info ~p~n", [ActInfo]),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = CustomCondition} ->
            #custom_act_cat{turn = Turn} = get_cat_data(PS, Type, SubType),
            %% 获取抽奖消耗信息
%%            Turn = ?IF(IsNext==1, OldTurn + 1, OldTurn),
            case lib_custom_act_check:check_act_condtion([turn], CustomCondition) of
                [CostList] ->
                    {NewTurn, CostInfo, Flag} =
                        case lists:keyfind(Turn, 1, CostList) of
                            {Turn, {_,CGoodsTypeId,CNum}} -> {Turn, {CGoodsTypeId,CNum}, true};
                            _ ->
                                MaxTurn = get_max_turn(CostList),
%%                                Res = lists:keyfind(MaxTurn, 1, CostList),
                                {MaxT, {_,MGoodsTypeId,MNum}} = MaxTurn,
                                {MaxT, {MGoodsTypeId,MNum}, false}
                        end,
                    ?PRINT("NewTurn ~p ~n", [NewTurn]),
                    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
                    F = fun(GradeId, ResList) ->
                        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                            #custom_act_reward_cfg{condition = Condition} = RewardCfg ->
                                case lists:keyfind(turn, 1, Condition) of
                                    {turn, NewTurn} -> [RewardCfg|ResList];
                                    _ ->
                                        ResList
                                end;
                            _ -> ResList
                        end
                        end,
                    RealRewardCfgs = lists:foldl(F, [], Ids),
                    RewardList = [begin
                                      #custom_act_reward_cfg{condition = RCondition, grade = Grade} = RealRewardCfg,
                                      case lib_custom_act_util:count_act_reward(PS, ActInfo, RealRewardCfg) of
                                          [{_, GoodsId, Num}|_] ->
                                              case lists:keyfind(is_rare, 1, RCondition) of
                                                  {is_rare, 1} -> {Grade, GoodsId, Num, 1};
                                                  _ -> {Grade, GoodsId, Num, 0}
                                              end;
                                          _ -> []
                                      end
                                  end|| RealRewardCfg <- RealRewardCfgs],
                    LastRewardList = lists:filter(fun(Item) -> Item =/= [] end, RewardList),
                    {CGoodsId, CGoodsNum} = CostInfo,
                    RoundsList = get_round_list(Type, SubType, Ids),
                    %% 当抽奖轮次用光是 turn 为 0，前面使用了Flag作为标识
%%                    ?PRINT("@@@@@@ ~p ~n", [[Type, SubType, ?IF(Flag, NewTurn, 0), CGoodsId, CGoodsNum,RoundsList, LastRewardList]]),
                    lib_server_send:send_to_uid(PS#player_status.id, pt_332, 33224, [Type, SubType, ?IF(Flag, NewTurn, 0), CGoodsId, CGoodsNum,RoundsList, LastRewardList]),
                    ok;
                _ -> skip
            end;
        _ ->
            skip
    end.

%% 求出每个轮次最大和最低的奖励数量
%% return [{turn, maxNum, minNum}|_]
get_round_list(Type, SubType, GradeIds) ->
    RewardCfgs = [lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId)|| GradeId <- GradeIds],
    F = fun(RewardCfg, List) ->
        #custom_act_reward_cfg{condition = Condition, reward = Reward} = RewardCfg,
        {turn, Turn} = lists:keyfind(turn, 1, Condition),
        [{_,GoodsId,Num}|_] = Reward,
        case lists:keyfind(Turn, 1, List) of
            false -> lists:keystore(Turn, 1, List, {Turn, Num, Num, GoodsId});
            {Turn, OldMax, OldMin, _} ->
                NewMax = ?IF(Num>OldMax, Num, OldMax),
                NewMin = ?IF(Num<OldMin, Num, OldMin),
                lists:keystore(Turn, 1, List, {Turn, NewMax, NewMin, GoodsId})
        end
     end,
    lists:foldl(F, [], RewardCfgs).

%% 抽奖
turntable(#player_status{id = RoleId, figure = #figure{name = Name}} = PS, #act_info{key = {Type, SubType}} = ActInfo) ->
    case check_turntable(PS, ActInfo) of
        {true, OldTurn, NewCatData, CostList} ->
            case lib_goods_api:cost_object_list_with_check(PS, CostList, cost_fortune_goods, "") of
                {true, NewPlayerTmp} ->
                    case do_turntable(Type, SubType, OldTurn) of
                        {false, Errcode} ->
                            lib_custom_act:send_error_code(RoleId, Errcode),
                            {ok, PS};
                        {true, Rewards, IsRare, RewardCfg, Grade} ->
                            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewCatData},
                            NewPlayerTmp1 = lib_custom_act:save_act_data_to_player(NewPlayerTmp, ActData),
                            #custom_act_reward_cfg{grade = GradeId} = RewardCfg,
                            Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId]),
                            Produce = #produce{type = fortune_cat_rewards, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_0},
                            NewPlayerTmp2 = lib_goods_api:send_reward(NewPlayerTmp1, Produce),
                            [{_, GoodsId, GoodsNum}|_] = Rewards,
                            lib_log_api:log_fortune_cat(RoleId, Name, Type, SubType, OldTurn, Rewards),
                            ?PRINT("@@@@@@@@res ~p ~n", [[?SUCCESS,Type, SubType, GoodsId, GoodsNum]]),
                            lib_server_send:send_to_uid(NewPlayerTmp2#player_status.id, pt_332, 33225, [?SUCCESS,Type, SubType,Grade, GoodsId, GoodsNum]),
                            %% 等转盘动画再完成其余逻辑
                            spawn(fun() ->
                                timer:sleep(?TURNTABLE_DELAY),
                                %% 更新客户端转盘信息
                                mod_fortune_cat:add_record(SubType, RoleId, NewPlayerTmp2#player_status.figure#figure.name, GoodsId, GoodsNum, IsRare),
                                send_tv(NewPlayerTmp2, Rewards, IsRare,Type, SubType)
                            end),
                            {ok, NewPlayerTmp2}
                    end;
                {false, ErrorCode2, NewPlayer} ->
                    lib_custom_act:send_error_code(RoleId, ErrorCode2),
                    {false, NewPlayer}
            end;
        {false, Errcode} ->
            lib_custom_act:send_error_code(RoleId, Errcode),
            {false, PS}
    end.


%% 发送抽奖记录
send_turntable_records(RoleId, ?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType) ->
    mod_fortune_cat:send_turntable_records(RoleId, SubType);
send_turntable_records(_RoleId, _Type, _SubType) -> skip.

act_end(#act_info{key = {Type, SubType}} = ActInfo) ->
    spawn(fun() ->
        % 1.减少无用数据
        % 2.防止复用子类型,活动记录更新时间在开始时间和结束时间之间导致数据不清理
        lib_custom_act:db_delete_custom_act_data(Type, SubType)
    end),
    mod_fortune_cat:act_end(ActInfo).

clear_daily(Type, SubType) ->
    lib_custom_act:db_delete_custom_act_data(Type, SubType),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_fortune_cat, day_clear_act_data, [Type, SubType]) || E <- OnlineRoles],
    ok.

day_clear_act_data(Player, Type, SubType) -> gm_reset(Player, Type, SubType).

%% 次数重置
gm_reset(Player, Type, SubType) ->
    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = #custom_act_cat{}},
    lib_custom_act:save_act_data_to_player(Player, ActData).

%%=======================================================================

get_cat_data(PS, Type, SubType) ->
    case lib_custom_act:act_data(PS, Type, SubType) of
        #custom_act_data{data = Data} ->
            NewData = case Data of
                          #custom_act_cat{utime = UTime} = Data -> Data;
                          _ ->
                              UTime = utime:unixtime(),
                              #custom_act_cat{utime = UTime}
                      end,
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                #act_info{stime = Stime, etime = Etime} when UTime >= Stime, UTime =< Etime ->
                    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), UTime) of
                        true -> NewData;
                        false -> #custom_act_cat{}
                    end;
                _ ->
                    #custom_act_cat{}
            end;
        _ ->
            #custom_act_cat{}
    end.

get_max_turn(CostList) ->
    [MaxTurn|_] = lists:reverse(lists:keysort(1, CostList)),
    MaxTurn.

check_turntable(PS, #act_info{key = {Type, SubType}}) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = CustomCondition} ->
            #custom_act_cat{turn = Turn} = CatData = get_cat_data(PS, Type, SubType),
            %% 获取抽奖消耗信息
            case lib_custom_act_check:check_act_condtion([turn], CustomCondition) of
                [CostList] ->
                    case lists:keyfind(Turn, 1, CostList) of
                        {Turn, Cost} ->
                            case lib_goods_util:check_object_list(PS, [Cost]) of
                                true -> {true, Turn, CatData#custom_act_cat{turn = Turn + 1, utime = utime:unixtime()}, [Cost]};
                                {false, Errcode} -> {false, Errcode}
                            end ;
                        _ -> {false, ?ERRCODE(err331_shake_not_enough)}
                    end;
                _ -> {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end;
        _ -> {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end.

do_turntable(Type, SubType, Turn) ->
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, ResList) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{condition = Condition} = RewardCfg ->
                case lists:keyfind(turn, 1, Condition) of
                    {turn, Turn} ->
                        {weight, Weight} = lists:keyfind(weight, 1, Condition),
                        [{Weight, RewardCfg}|ResList];
                    _ -> ResList
                end;
            _ -> ResList
        end
        end,
    Weightlist = lists:foldl(F, [], Ids),
    case urand:rand_with_weight(Weightlist) of
        #custom_act_reward_cfg{condition = Condition, reward = Reward, grade = Grade} = RRewardCfg ->
            case lists:keyfind(is_rare,1,Condition) of
                {is_rare, IsRare} ->
                    {true, Reward, IsRare, RRewardCfg, Grade};
                _ ->
                    {true, Reward, 0, RRewardCfg, Grade}
            end;
        _ -> {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end.

send_tv(_PS, _Rewards, 0,_Type, _SubType) ->
    ?PRINT("@@IsRare ~p ~n", [0]),
    skip;
send_tv(PS, Rewards, IsRare,Type, SubType) ->
    ?PRINT("@@IsRare ~p ~n", [IsRare]),
    [{_, _GoodsId, GoodsNum}|_] = Rewards,
    #player_status{figure = #figure{name = Name}, id = RoleId} = PS,
    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 54, [Name, RoleId, _GoodsId, GoodsNum, Type, SubType]).

