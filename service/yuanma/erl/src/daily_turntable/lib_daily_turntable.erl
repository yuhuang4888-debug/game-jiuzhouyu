%%-----------------------------------------------------------------------------
%% @Module  :       lib_daily_turntable.erl
%% @Author  :       Fwx
%% @Created :       2018-07-2
%% @Description:    每日活跃转盘
%%-----------------------------------------------------------------------------
-module(lib_daily_turntable).
-include("server.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("daily_turntable.hrl").
-include("def_fun.hrl").

-compile(export_all).


login(RoleId) ->
    F = fun
            ([SubType, UseNum, Utime], Acc) ->
                GradeInfoL =
                    case db:get_all(io_lib:format(<<"select grade_id, num from daily_turntable_info where sub_type = ~p and role_id = ~p">>, [SubType, RoleId])) of
                        [] -> [];
                        List ->
                            F1 = fun
                                     ([GradeId, Num], Acc1) ->
                                         [#turn_reward_info{grade_id = GradeId, num = Num} | Acc1]
                                 end,
                            lists:foldl(F1, [], List)
                    end,
                DbActInfo = #turn_act_info{use_num = UseNum, grade_info = GradeInfoL, utime = Utime},
                case lib_custom_act_util:get_act_time_range_by_type(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
                    {STime, ETime} ->
                        case Utime >= STime andalso Utime =< ETime of
                            true ->
                                ActInfo = DbActInfo;
                            false ->
                                db:execute(io_lib:format(<<"delete from daily_turntable_info where sub_type = ~p and role_id = ~p ">>, [SubType, RoleId])),
                                db:execute(io_lib:format(<<"delete from daily_turntable where sub_type = ~p and role_id = ~p ">>, [SubType, RoleId])),
                                ActInfo = #turn_act_info{}
                        end;
                    _ ->
                        ActInfo = DbActInfo
                end,
                maps:put(SubType, ActInfo, Acc)
        end,
    lists:foldl(F, #{}, db:get_all(io_lib:format(<<"select sub_type, use_num, utime from daily_turntable where role_id = ~p">>, [RoleId]))).


turn(SubType, Player, 0) -> %% 抽一次
    #player_status{id = RoleId, figure = #figure{name = RoleName}, daily_turntable = ActMap} = Player,
    ActInfo = maps:get(SubType, ActMap, #turn_act_info{}),
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
        #custom_act_cfg{condition = Condition} ->
            [Cost] = lib_custom_act_check:check_act_condtion([one_cost], Condition),
            case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, daily_turntable, "") of
                {true, TmpPs, NewCost} ->
                    {NewActInfo, GradeL, Reward }= count_reward_list(SubType, RoleId, RoleName, ActInfo, 1),
                    NewActMap = maps:put(SubType, NewActInfo, ActMap),
                    NewTmpPs = TmpPs#player_status{daily_turntable = NewActMap},
                    IsAuto = ?IF(Cost =:= NewCost, 0, 1),
                    lib_log_api:log_daily_turntable(RoleId, SubType, 0, IsAuto, NewCost, Reward),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33153, [?SUCCESS, SubType, 0, GradeL]),
                    Produce = #produce{title = utext:get(203), content = utext:get(204), type = daily_turntable, reward = Reward, show_tips = 1},
                    lib_goods_api:send_reward_with_mail(NewTmpPs, Produce);
                {false, ErrCode, _TmpPs} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33153, [ErrCode, SubType, 0, []])
            end
    end;

turn(SubType, Player, 1) -> %% 抽十次
    #player_status{id = RoleId,  figure = #figure{name = RoleName}, daily_turntable = ActMap} = Player,
    ActInfo = maps:get(SubType, ActMap, #turn_act_info{}),
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
        #custom_act_cfg{condition = Condition} ->
            [Cost] = lib_custom_act_check:check_act_condtion([ten_cost], Condition),
            case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, daily_turntable, "") of
                {true, TmpPs, NewCost} ->
                    {NewActInfo, GradeL, Reward } = count_reward_list(SubType, RoleId, RoleName, ActInfo, 10),
                    NewActMap = maps:put(SubType, NewActInfo, ActMap),
                    NewTmpPs = TmpPs#player_status{daily_turntable = NewActMap},
                    IsAuto = ?IF(Cost =:= NewCost, 0, 1),
                    lib_log_api:log_daily_turntable(RoleId, SubType, 1, IsAuto, NewCost, Reward),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33153, [?SUCCESS, SubType, 1, GradeL]),
                    Produce = #produce{title = utext:get(203), content = utext:get(204), type = daily_turntable, reward = Reward, show_tips = 1},
                    lib_goods_api:send_reward_with_mail(NewTmpPs, Produce);
                {false, ErrCode, _TmpPs} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33153, [ErrCode, SubType, 1, []])
            end
    end.

count_reward_list(Subtype, RoleId, RoleName, ActInfo, Times) ->
    {NewActInfo, GradeL} = do_count_grade_list(Subtype, RoleId, ActInfo, Times, []),
    NowTime = utime:unixtime(),
    F = fun(GradeId, AccL) ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, Subtype, GradeId) of
                #custom_act_reward_cfg{condition = Condition, reward = [{_, GTypeId, GNum}] = Reward} ->
                    [IsTv] = lib_custom_act_check:check_act_condtion([is_tv], Condition),
                    case IsTv of
                        1 ->
                            ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, Subtype),
                            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 20, [RoleName, ActName, GTypeId, GNum]);
                        0 ->
                            skip
                    end,
                    mod_daily_turntable:add_record(Subtype, RoleId, RoleName, GradeId, NowTime),
                    Reward ++ AccL;
                _ ->
                    AccL
            end
        end,
    RewardL = lists:foldl(F, [], GradeL),
    {NewActInfo, GradeL, RewardL}.

do_count_grade_list(_Subtype, _RoleId, ActInfo, 0, L) -> {ActInfo, L};
do_count_grade_list(Subtype, RoleId, ActInfo, Times, L) ->
    #turn_act_info{grade_info = GradeInfoL, use_num = UseNum} = ActInfo,
    NowTime = utime:unixtime(),
    NewUseNum = UseNum + 1,
    %% 处理重置次数的
    F1 = fun
             (#turn_reward_info{grade_id = GradeId} = GradeInfo, AccL) ->
                 case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, Subtype, GradeId) of
                     #custom_act_reward_cfg{condition = Condition} ->
                         [RefreshNum] = lib_custom_act_check:check_act_condtion([refresh_num], Condition),
                         case RefreshNum /= 0 andalso (NewUseNum rem RefreshNum == 0) of
                             true ->
                                 db:execute(io_lib:format(<<"delete from daily_turntable_info where sub_type = ~p and role_id = ~p and grade_id = ~p ">>, [Subtype, RoleId, GradeId])),
                                 AccL;
                             false ->
                                 [GradeInfo | AccL]
                         end;
                     _ ->
                         ?ERR("daily turntable cfg err ~p~n", [GradeId]),
                         [GradeInfo | AccL]
                 end
         end,
    TmpGradeInfoL = lists:foldl(F1, [], GradeInfoL),
    F = fun
            (GradeId, AccL) ->
                case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, Subtype, GradeId) of
                    #custom_act_reward_cfg{condition = Condition} ->
                        [Weight, LimitNum] = lib_custom_act_check:check_act_condtion([weight, limit_num], Condition),
                        case lists:keyfind(GradeId, #turn_reward_info.grade_id, TmpGradeInfoL) of
                            #turn_reward_info{num = Num} when Num >= LimitNum andalso LimitNum /= 0 ->
                                AccL;
                            _ ->
                                [{Weight, GradeId} | AccL]
                        end;
                    _ ->
                        AccL
                end
        end,
    WeightL = lists:foldl(F, [], get_turn_reward_list(Subtype)),
    case urand:rand_with_weight(WeightL) of
        false ->
            ?ERR("weight rand list null~n", []), GradeId = 0, NewActInfo = ActInfo;
        GradeId ->
            ?PRINT("~p~n", [GradeId]),
            NewGradeInfoL =
                case lists:keyfind(GradeId, #turn_reward_info.grade_id, TmpGradeInfoL) of
                    false ->
                        [#turn_reward_info{grade_id = GradeId, num = NewNum = 1} | TmpGradeInfoL];
                    #turn_reward_info{num = OldNum} = OldRInfo ->
                        lists:keystore(GradeId, #turn_reward_info.grade_id, TmpGradeInfoL, OldRInfo#turn_reward_info{num = NewNum = OldNum + 1})
                end,
            db:execute(io_lib:format(<<"replace into daily_turntable_info(sub_type, role_id, grade_id, num)
             values(~p, ~p, ~p, ~p)">>, [Subtype, RoleId, GradeId, NewNum])),
            db:execute(io_lib:format(<<"replace into daily_turntable(sub_type, role_id, use_num, utime)
             values(~p, ~p, ~p, ~p)">>, [Subtype, RoleId, NewUseNum, NowTime])),
            NewActInfo = ActInfo#turn_act_info{
                grade_info = NewGradeInfoL,
                utime      = NowTime,
                use_num    = NewUseNum
            }
    end,
    do_count_grade_list(Subtype, RoleId, NewActInfo, Times - 1, [GradeId | L]).

get_turn_reward_list(SubType) ->
    [GradeId || GradeId <- lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType), GradeId < 100].

get_liveness_reward_list(SubType) ->
    [GradeId || GradeId <- lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType), GradeId >= 100].

%% 活跃增加通知客户端
refresh_daily_turntable_liveness(Player) ->
    [ pp_custom_act:handle(33104, Player, [?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType])
        || SubType <- lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE)].

