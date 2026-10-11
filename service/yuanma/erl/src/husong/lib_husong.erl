%%%--------------------------------------
%%% @Module  : lib_husong
%%% @Author  : huyihao
%%% @Created : 2018.01.06
%%% @Description:  护送
%%%--------------------------------------
-module(lib_husong).

-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("husong.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("attr.hrl").
-include("counter.hrl").
-include("activitycalen.hrl").

-export([
    husong_login/1,
    husong_logout_before_hook/1,
    husong_reflesh_once/4,
    do_husong_reflesh_all/5,
    husong_fail/2,
    husong_die/2,
    husong_send_reward/4,
    husong_sql/1,
    husogn_help/3,
    is_husong/1,
    reconnect/2,
    get_husong_reward/4,
    double_change/1,
    take_success_send_info/1,
    get_double_end_time/1,
    get_husong_daily/1
]).

%% 登录
%%husong_login(Ps) ->
%%    #player_status{id = RoleId, figure = Figure} = Ps,
%%    #figure{lv = Lv} = Figure,
%%    ReSql = io_lib:format(?SelectHuSongPlayerSql, [RoleId]),
%%    case db:get_all(ReSql) of
%%        [] ->
%%            NewHuSong = #husong{role_id = RoleId},
%%            NewPs = Ps#player_status{husong = NewHuSong};
%%        [PlayerInfoList|_] ->
%%            [_RoleId, AngelId, Stage, RewardStage, StartTime, InvincibleSkill, AskHelpTime] = PlayerInfoList,
%%            NowTime = utime:unixtime(),
%%            case NowTime >= StartTime + ?HuSongTime of
%%                true ->  %  已经超时
%%                    case StartTime > 0 of
%%                        true -> % 护送开始的时间有效
%%                            NewHuSong = #husong{
%%                                role_id = RoleId,
%%                                ask_help_time = AskHelpTime
%%                            },
%%                            RewardList = get_husong_reward(AngelId, Stage, 0, Lv),
%%%%                          发邮件
%%                            Title = ?LAN_MSG(?LAN_TITLE_HUSONG_TIME_OUT_OFFLINE),
%%                            Content = ?LAN_MSG(?LAN_CONTENT_HUSONG_TIME_OUT_OFFLINE),
%%                            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
%%                            case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
%%                                {ok, _ActId1} ->
%%                                    IfDouble = 1;
%%                                _ ->
%%                                    IfDouble = 0
%%                            end,
%%                            lib_log_api:log_husong_end(RoleId, AngelId, StartTime, Stage, 2, IfDouble, RewardList),
%%                            ReSql1 = io_lib:format(?ReplaceHuSongPlayerSql, [RoleId, 0, 0, 0, 0, 0, AskHelpTime]),
%%                            db:execute(ReSql1);
%%                        false ->
%%                            NewHuSong = #husong{
%%                                role_id = RoleId,
%%                                angel_id = AngelId,
%%                                stage = Stage,
%%                                reward_stage = RewardStage,
%%                                start_time = StartTime,
%%                                invincible_skill = InvincibleSkill,
%%                                ask_help_time = AskHelpTime
%%                            }
%%                    end,
%%                    NewPs = Ps#player_status{
%%                        husong = NewHuSong
%%                    };
%%                false -> %  没有超时接着送
%%                    EndTime = StartTime + ?HuSongTime - NowTime,
%%                    EndTimer = erlang:send_after(EndTime*1000, self(), {mod, lib_husong, husong_fail, [1]}),
%%                    NewHuSong = #husong{
%%                        role_id = RoleId,
%%                        angel_id = AngelId,
%%                        stage = Stage,
%%                        reward_stage = RewardStage,
%%                        start_time = StartTime,
%%                        end_timer = EndTimer,
%%                        invincible_skill = InvincibleSkill,
%%                        ask_help_time = AskHelpTime
%%                    },
%%                    NewFigure = Figure#figure{
%%                        husong_angel_id = AngelId
%%                    },
%%                    NewPs1 = lib_player:setup_action_lock(Ps, ?ERRCODE(err500_husong_cant_change_scene)),
%%                    lib_player_event:add_listener(?EVENT_PLAYER_DIE, lib_husong, husong_die, []),
%%                    NewPs = NewPs1#player_status{
%%                        husong = NewHuSong,
%%                        figure = NewFigure
%%                    }
%%            end
%%    end,
%%    NewPs.


husong_login(Ps) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    #figure{lv = Lv} = Figure,
    ReSql = io_lib:format(?SelectHuSongPlayerSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            NewHuSong = #husong{role_id = RoleId},
            NewPs = Ps#player_status{husong = NewHuSong};
        [PlayerInfoList | _] ->
            [_RoleId, AngelId, Stage, RewardStage, StartTime, InvincibleSkill, AskHelpTime] = PlayerInfoList,
            case StartTime > 0 of
                true -> % 护送开始的时间有效
                    NewHuSong = #husong{
                        role_id = RoleId,
                        start_time = 0
                    },
                    RewardList = get_husong_reward(AngelId, Stage, 1, Lv),
                    %%                          发邮件
                    Title = ?LAN_MSG(?LAN_TITLE_HUSONG_TIME_OUT_OFFLINE),
                    Content = ?LAN_MSG(?LAN_CONTENT_HUSONG_TIME_OUT_OFFLINE),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
                    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
                        {ok, _ActId1} ->
                            IfDouble = 1;
                        _ ->
                            IfDouble = 0
                    end,
                    lib_log_api:log_husong_end(RoleId, AngelId, StartTime, Stage, 1, IfDouble, RewardList),
                    ReSql1 = io_lib:format(?ReplaceHuSongPlayerSql, [RoleId, 0, 0, 0, 0, 0, AskHelpTime]),
                    db:execute(ReSql1);
                false ->
                    NewHuSong = #husong{
                        role_id = RoleId,
                        angel_id = AngelId,
                        stage = Stage,
                        reward_stage = RewardStage,
                        start_time = StartTime,
                        invincible_skill = InvincibleSkill,
                        ask_help_time = AskHelpTime
                    }
            end,
            ?PRINT("login  NewHuSong :~p~n",[NewHuSong]),
            NewPs = Ps#player_status{
                husong = NewHuSong
            }
    end,
    NewPs.







%% 离线挂机前若离线挂机未超时执行超时操作
husong_logout_before_hook(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        husong = HuSong,
        battle_attr = BattleAttr
    } = Ps,
    #battle_attr{
        pk = #pk{pk_status = _PkType}
    } = BattleAttr,
    #husong{
        angel_id = AngelId,
        stage = Stage,
        start_time = StartTime,
        end_timer = EndTimer
    } = HuSong,
    ?PRINT("logoout StartTime :~p~n" ,[StartTime]),
    case StartTime of
        0 ->
            false;
        _ ->
            #figure{
                lv = Lv
            } = Figure,
            util:cancel_timer(EndTimer),
            NewHuSong = #husong{
                role_id = RoleId
            },
            NewFigure = Figure#figure{
                husong_angel_id = 0
            },
            RewardList = get_husong_reward(AngelId, Stage, 1, Lv),
            %%                          发邮件
            Title = ?LAN_MSG(?LAN_TITLE_HUSONG_TIME_OUT_OFFLINE),
            Content = ?LAN_MSG(?LAN_CONTENT_HUSONG_TIME_OUT_OFFLINE),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
            case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
                {ok, _ActId1} ->
                    IfDouble = 1;
                _ ->
                    IfDouble = 0
            end,
            NewPs1 = Ps#player_status{
                husong = NewHuSong,
                figure = NewFigure
            },
%%            NewPs2 = lib_player:break_action_lock(NewPs1, ?ERRCODE(err500_husong_cant_change_scene)),
%%            {ok, NewPs3} = lib_skill_buff:clean_buff(NewPs2, ?HuSongInvincibleSkillId),
%%            case PkType =:= ?PK_PEACE_ULTIMATE of
%%                true ->
%%                    case lib_player:change_pkstatus(NewPs3, ?PK_PEACE, true) of
%%                        {ok, NewPs4} ->
%%                            skip;
%%                        _ ->
%%                            NewPs4 = NewPs3
%%                    end;
%%                false ->
%%                    NewPs4 = NewPs3
%%            end,
            {NewPs, RewardList} = husong_send_reward(NewPs1, AngelId, Stage, 1),
            mod_scene_agent:update(NewPs, [{husong_angle_id, 0}]),
%%            lib_player_event:remove_listener(?EVENT_PLAYER_DIE, lib_husong, husong_die),
            lib_log_api:log_husong_end(RoleId, AngelId, StartTime, Stage, 4, IfDouble, RewardList),
            ReSql1 = io_lib:format(?ReplaceHuSongPlayerSql, [RoleId, 0, 0, 0, 0, 0, 0]),
            db:execute(ReSql1),
            {true, NewPs}
    end.

husong_reflesh_once(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, Type) ->
    {Code, NewAngelId, CostList} = do_husong_reflesh(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, Type, [], Ps#player_status.husong#husong.angel_id),
    {Code1, Code2, AngelName, GoodsNum, BGoldNum, GoldNum, NewPs} = husong_cost(Code, NewAngelId, CostList, Ps),
    {Code1, Code2, NewAngelId, AngelName, GoodsNum, BGoldNum, GoldNum, NewPs}.

husong_cost(Code, NewAngelId, CostList, Ps) ->
    #player_status{
        id = RoleId,
        husong = HuSong
    } = Ps,
    #husong{
        angel_id = OldAngelId
    } = HuSong,
    case Code =:= ?SUCCESS of
        true ->
            [{HuSongGoodsType, HuSongGoodsTypeId, _GoodsNum} | _] = ?HuSongRefleshCost,
            F = fun({Type, Num}, {AddDailyNum1, GoodsCostList1}) ->
                case Type of
                    1 ->
                        {AddDailyNum1 + Num, GoodsCostList1};
                    2 ->
                        NewGoodsCostList1 = husong_add_cost_value(HuSongGoodsType, HuSongGoodsTypeId, Num, GoodsCostList1),
                        {AddDailyNum1, NewGoodsCostList1};
                    3 ->
                        NewGoodsCostList1 = husong_add_cost_value(?TYPE_BGOLD, ?GOODS_ID_BGOLD, Num, GoodsCostList1),
                        {AddDailyNum1, NewGoodsCostList1};
                    _ ->
                        NewGoodsCostList1 = husong_add_cost_value(?TYPE_GOLD, ?GOODS_ID_GOLD, Num, GoodsCostList1),
                        {AddDailyNum1, NewGoodsCostList1}
                end
                end,
            {AddDailyNum, GoodsCostList} = lists:foldl(F, {0, []}, CostList),
            case AddDailyNum of %% 扣除免费次数
                0 ->
                    skip;
                _ ->
                    mod_daily:plus_count(RoleId, ?MOD_HUSONG, ?HuSongFreeDailyId, AddDailyNum)
            end,
            case GoodsCostList of %% 扣除物品货币等
                [] ->
                    Code3 = 1,
                    NewPs1 = Ps;
                _ ->
                    case lib_goods_api:cost_object_list_with_check(Ps, GoodsCostList, husong_reflesh, "") of
                        {true, NewPs1} ->
                            Code3 = 1;
                        {false, Code3, NewPs1} ->
                            skip
                    end
            end,
            case Code3 of
                1 ->
                    case NewAngelId of
                        OldAngelId ->
                            Code1 = ?ERRCODE(err500_husong_reflesh_fail),
                            AngelName = "";
                        _ ->
                            Code1 = ?ERRCODE(err500_husong_reflesh_success),
                            AngelCon = data_husong:get_husong_angel_con(NewAngelId),
                            #husong_angel_con{
                                name = AngelName
                            } = AngelCon
                    end,
                    Code2 = ?ERRCODE(err500_husong_cost),
                    case lists:keyfind(HuSongGoodsType, 1, GoodsCostList) of
                        false ->
                            GoodsNum = 0;
                        {_, _, GoodsNum} ->
                            skip
                    end,
                    case lists:keyfind(?TYPE_BGOLD, 1, GoodsCostList) of
                        false ->
                            BGoldNum = 0;
                        {_, _, BGoldNum} ->
                            skip
                    end,
                    case lists:keyfind(?TYPE_GOLD, 1, GoodsCostList) of
                        false ->
                            GoldNum = 0;
                        {_, _, GoldNum} ->
                            skip
                    end,
                    NewHuSong = HuSong#husong{
                        angel_id = NewAngelId
                    },
                    husong_sql(NewHuSong),
                    NewPs = NewPs1#player_status{
                        husong = NewHuSong
                    },
                    lib_log_api:log_husong_reflesh(RoleId, OldAngelId, NewAngelId, CostList);
                _ ->
                    Code1 = Code3,
                    Code2 = 0,
                    AngelName = "",
                    GoodsNum = 0,
                    BGoldNum = 0,
                    GoldNum = 0,
                    NewPs = Ps
            end;
        false ->
            Code1 = Code,
            Code2 = 0,
            AngelName = "",
            GoodsNum = 0,
            BGoldNum = 0,
            GoldNum = 0,
            NewPs = Ps
    end,
    {Code1, Code2, AngelName, GoodsNum, BGoldNum, GoldNum, NewPs}.

husong_add_cost_value(GoodsType, GoodsTypeId, Num, GoodsCostList) ->
    case lists:keyfind(GoodsType, 1, GoodsCostList) of
        false ->
            NewGoodsCostList = [{GoodsType, GoodsTypeId, Num} | GoodsCostList];
        {_, _, OldNum} ->
            NewGoodsCostList = lists:keyreplace(GoodsTypeId, 2, GoodsCostList, {GoodsType, GoodsTypeId, OldNum + Num})
    end,
    NewGoodsCostList.

do_husong_reflesh(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, Type, CostList, OldAngelId) ->
    #player_status{
        id = RoleId
    } = Ps,
    case lists:keyfind(1, 1, CostList) of
        false ->
            OldFreeNum = 0;
        {_, OldFreeNum} ->
            skip
    end,
    case (TodayHuSongFreeNum + OldFreeNum) < TodayHuSongFreeNumMax of
        true ->
            Code = ?SUCCESS,
            case lists:keyfind(1, 1, CostList) of
                false ->
                    NewCostList = [{1, 1} | CostList];
                {_, Num} ->
                    NewCostList = lists:keyreplace(1, 1, CostList, {1, Num + 1})
            end;
        false ->
            [{GoodsType, GoodsTypeId, GoodsNum} | _] = ?HuSongRefleshCost,
            case lists:keyfind(2, 1, CostList) of
                false ->
                    OldGoodsNum = 0;
                {_, OldGoodsNum} ->
                    skip
            end,
            case lib_goods_api:check_object_list(Ps, [{GoodsType, GoodsTypeId, GoodsNum + OldGoodsNum}]) of
                true ->
                    Code = ?SUCCESS,
                    NewCostList = lists:keystore(2, 1, CostList, {2, GoodsNum + OldGoodsNum});
                {false, Code1} ->
                    case Type of
                        1 ->
                            Code = Code1,
                            NewCostList = CostList;
                        _ ->
                            {_PriceType, SellPrice} = data_goods:get_goods_buy_price(GoodsTypeId),
                            Price = SellPrice * GoodsNum,
                            case lists:keyfind(3, 1, CostList) of
                                false ->
                                    OldBGoldNum = 0;
                                {_, OldBGoldNum} ->
                                    skip
                            end,
                            case Ps#player_status.bgold >= (Price + OldBGoldNum) of
                                true ->
                                    Code = ?SUCCESS,
                                    NewCostList = lists:keystore(3, 1, CostList, {3, Price + OldBGoldNum});
                                false ->
                                    case lists:keyfind(4, 1, CostList) of
                                        false ->
                                            OldGoldNum = 0;
                                        {_, OldGoldNum} ->
                                            skip
                                    end,
                                    case Ps#player_status.gold >= (Price + OldGoldNum) of
                                        true ->
                                            Code = ?SUCCESS,
                                            NewCostList = lists:keystore(4, 1, CostList, {4, Price + OldGoldNum});
                                        false ->
                                            Code = ?GOLD_NOT_ENOUGH,
                                            NewCostList = CostList
                                    end
                            end
                    end
            end
    end,
    case Code =:= ?SUCCESS of
        true ->
            NewAngelId = husong_reflesh(OldAngelId, RoleId);
        false ->
            NewAngelId = OldAngelId
    end,
    {Code, NewAngelId, NewCostList}.

husong_reflesh(OldAngelId, RoleId) ->
    case mod_counter:get_count(RoleId, ?MOD_HUSONG, ?HuSongFirstRefleshCounterId) of
        0 ->
            AngelIdList = data_husong:get_angel_id_list(),
            NewAngelId = lists:max(AngelIdList),
            mod_counter:increment(RoleId, ?MOD_HUSONG, ?HuSongFirstRefleshCounterId);
        _ ->
            AngelCon = data_husong:get_husong_angel_con(OldAngelId),
            #husong_angel_con{
                rand_list = RandList
            } = AngelCon,
            NewAngelId = urand:rand_with_weight(RandList)
    end,
    NewAngelId.

do_husong_reflesh_all(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, TargetAngelId, Type) ->
    {Code, NewAngelId, CostList} = do_husong_reflesh_all_1(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, TargetAngelId, Type, [], 0, Ps#player_status.husong#husong.angel_id),
    {Code1, Code2, AngelName, GoodsNum, BGoldNum, GoldNum, NewPs} = husong_cost(Code, NewAngelId, CostList, Ps),
    {Code1, Code2, NewAngelId, AngelName, GoodsNum, BGoldNum, GoldNum, NewPs}.

do_husong_reflesh_all_1(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, TargetAngelId, Type, CostList, Code, OldAngelId) ->
    {Code1, NewAngelId, NewCostList} = do_husong_reflesh(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, Type, CostList, OldAngelId),
    if
        NewAngelId >= TargetAngelId -> %% 成功刷新
            {?SUCCESS, NewAngelId, NewCostList};
        true ->
            case Code1 =:= ?SUCCESS orelse Code =:= ?SUCCESS of
                true ->
                    NewCode = ?SUCCESS;
                false ->
                    NewCode = Code1
            end,
            case lists:keyfind(1, 1, NewCostList) of
                false ->
                    OldFreeNum = 0;
                {_, OldFreeNum} ->
                    skip
            end,
            case TodayHuSongFreeNum + OldFreeNum >= TodayHuSongFreeNumMax andalso Code1 =/= ?SUCCESS of
                true ->
                    {NewCode, NewAngelId, NewCostList};
                false ->
                    do_husong_reflesh_all_1(Ps, TodayHuSongFreeNum, TodayHuSongFreeNumMax, TargetAngelId, Type, NewCostList, NewCode, NewAngelId)
            end
    end.

%% 护送失败：Type：1超时 2被杀死
husong_fail(Ps, Type) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        scene_pool_id = SPId,
        copy_id = CopyId,
        x = X,
        y = Y,
        husong = HuSong,
        figure = Figure,
        battle_attr = BattleAttr
    } = Ps,
    #husong{
        end_timer = EndTimer,
        angel_id = AngelId,
        start_time = StartTime,
        stage = Stage
    } = HuSong,
    #battle_attr{
        pk = #pk{pk_status = _PkType}
    } = BattleAttr,
    util:cancel_timer(EndTimer),
    NewHuSong = HuSong#husong{
        angel_id = 0,
        stage = 0,
        reward_stage = 0,
        start_time = 0,
        end_timer = 0,
        invincible_skill = 0,
        ask_help_time = 0
    },
    husong_sql(NewHuSong),
    NewFigure = Figure#figure{
        husong_angel_id = 0
    },
    NewPs1 = Ps#player_status{
        husong = NewHuSong,
        figure = NewFigure
    },
    NewPs2 = lib_player:break_action_lock(NewPs1, ?ERRCODE(err500_husong_cant_change_scene)),
    {ok, NewPs3} = lib_skill_buff:clean_buff(NewPs2, ?HuSongInvincibleSkillId),
    % case PkType =:= ?PK_PEACE_ULTIMATE of
    %     true ->
    %         case lib_player:change_pkstatus(NewPs3, ?PK_PEACE, true) of
    %             {ok, NewPs4} ->
    %                 skip;
    %             _ ->
    %                 NewPs4 = NewPs3
    %         end;
    %     false ->
    %         NewPs4 = NewPs3
    % end,
    NewPs4 = NewPs3,
    {NewPs, RewardList} = husong_send_reward(NewPs4, AngelId, Stage, 0),
    mod_scene_agent:update(NewPs, [{husong_angle_id, 0}]),

    lib_player_event:remove_listener(?EVENT_PLAYER_DIE, lib_husong, husong_die),
    %% 通知场景玩家护送结束
    {ok, BinData1} = pt_500:write(50006, [RoleId, 0]),
    lib_server_send:send_to_area_scene(SceneId, SPId, CopyId, X, Y, BinData1),
    %% 通知玩家护送失败
    {ok, BinData2} = pt_500:write(50008, [Type, RewardList]),
    lib_server_send:send_to_uid(RoleId, BinData2),
    case Type of
        1 ->
            EndType = 2;
        _ ->
            EndType = 3
    end,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
        {ok, _ActId1} ->
            IfDouble = 1;
        _ ->
            IfDouble = 0
    end,
    lib_log_api:log_husong_end(RoleId, AngelId, StartTime, Stage, EndType, IfDouble, RewardList),
    NewPs.

%% 玩家死亡
husong_die(Ps, #event_callback{data = Data}) ->
    #player_status{
        id = RoleId,
        husong = HuSong,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #husong{
        angel_id = AngelId,
        stage = Stage,
        start_time = StartTime
    } = HuSong,
    case StartTime of
        0 ->
            NewPs = Ps;
        _ ->
            NewPs = husong_fail(Ps, 2),
            case maps:get(atter, Data, []) of
                #battle_return_atter{sign = ?BATTLE_SIGN_PLAYER, id = AttRoleId} ->
                    TodayHuSongTakeNumMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongTakeDailyId),
                    TodayHuSongTakeNum = mod_daily:get_count_offline(AttRoleId, ?MOD_HUSONG, ?HuSongTakeDailyId),
                    case TodayHuSongTakeNum < TodayHuSongTakeNumMax of
                        false ->
                            Code1 = ?ERRCODE(err500_husong_take_num_max);
                        true ->
                            Code1 = ?ERRCODE(err500_husong_take_success),
                            mod_daily:increment_offline(AttRoleId, ?MOD_HUSONG, ?HuSongTakeDailyId)
                    end,
                    lib_game:send_error_to_uid(AttRoleId, Code1),
                    case Code1 =:= ?ERRCODE(err500_husong_take_success) of
                        true ->
                            Title = ?LAN_MSG(?LAN_TITLE_HUSONG_TAKE),
                            Content = utext:get(?LAN_CONTENT_HUSONG_TAKE, [TodayHuSongTakeNum + 1, max(0, (TodayHuSongTakeNumMax - TodayHuSongTakeNum - 1))]),
                            TakeRewardList = get_husong_reward(AngelId, Stage, 2, Lv),
                            {_, _, AddExp} = lists:keyfind(?TYPE_EXP, 1, TakeRewardList),
                            {_, _, AddCoin} = lists:keyfind(?TYPE_COIN, 1, TakeRewardList),
                            mod_daily:plus_count_offline(AttRoleId, ?MOD_HUSONG, ?HuSongTakeExpDailyId, AddExp),
                            mod_daily:plus_count_offline(AttRoleId, ?MOD_HUSONG, ?HuSongTakeCoinDailyId, AddCoin),
                            lib_player:apply_cast(AttRoleId, ?APPLY_CALL_STATUS, ?NOT_HAND_OFFLINE, lib_husong, take_success_send_info, []),
                            lib_mail_api:send_sys_mail([AttRoleId], Title, Content, TakeRewardList),
                            lib_log_api:log_husong_take(AttRoleId, RoleId);
                        false ->
                            skip
                    end;
                _ ->
                    skip
            end
    end,
    {ok, NewPs}.

take_success_send_info(Ps) ->
    pp_husong:handle(50009, Ps, []).

%% 获取奖励列表
%% type: 0失败 1成功 2拦截
get_husong_reward(AngelId, _Stage, Type, Lv) ->
    AngelCon = data_husong:get_husong_angel_con(AngelId),
    #husong_angel_con{exp = Exp, coin = CoinNum} = AngelCon,
    {GetExp, GetCoin} =
        case Type of
            0 -> {0, 0};
            _ -> {?HuSongExpFun(Lv, Exp), CoinNum}
        end,
    %%    ExpNum = ?HuSongExpFun(Lv, Exp),
    %%    case Type of
    %%        2 ->
    %%            GetExp = round(ExpNum * ?HuSongTakeRewardPercent / 100),
    %%            GetCoin = round(CoinNum * ?HuSongTakeRewardPercent / 100);
    %%        _ ->
    %%            case Stage of
    %%                1 ->
    %%                    case Type of
    %%                        0 ->
    %%                            GetExp = round(ExpNum * ?HuSongFirstFailRewardPercent / 100),
    %%                            GetCoin = round(CoinNum * ?HuSongFirstFailRewardPercent / 100);
    %%                        _ ->
    %%                            GetExp = round(ExpNum * ?HuSongFirstSuccessRewardPercent / 100),
    %%                            GetCoin = round(CoinNum * ?HuSongFirstSuccessRewardPercent / 100)
    %%                    end;
    %%                _ ->
    %%                    case Type of
    %%                        0 ->
    %%                            GetExp = round(ExpNum * ?HuSongSecondFailRewardPercent / 100),
    %%                            GetCoin = round(CoinNum * ?HuSongSecondFailRewardPercent / 100);
    %%                        _ ->
    %%                            GetExp = round(ExpNum * ?HuSongSecondSuccessRewardPercent / 100),
    %%                            GetCoin = round(CoinNum * ?HuSongSecondSuccessRewardPercent / 100)
    %%                    end
    %%            end
    %%    end,
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE) of
        {ok, _ActId1} ->
            RewardList = [{?TYPE_EXP, ?GOODS_ID_EXP, GetExp * 2}, {?TYPE_COIN, ?GOODS_ID_COIN, GetCoin * 2}];
        _ ->
            RewardList = [{?TYPE_EXP, ?GOODS_ID_EXP, GetExp}, {?TYPE_COIN, ?GOODS_ID_COIN, GetCoin}]
    end,
    RewardList.

%% 护送奖励
%% Stage：阶段
%% type：0失败 1成功
husong_send_reward(Ps, AngelId, Stage, Type) ->
    RewardList = get_husong_reward(AngelId, Stage, Type, Ps#player_status.figure#figure.lv),
    AngelIdList = data_husong:get_angel_id_list(),
    AngelIdMax = lists:max(AngelIdList), % 最高级的天使类型
    case Stage =:= 2 andalso AngelId =:= AngelIdMax andalso Type =:= 1 of
        true ->
            BestHuSongTimes = mod_counter:get_count(Ps#player_status.id, ?MOD_HUSONG, ?HuSongBestCounterId),
            BestHuSongTimesMax = mod_counter:get_limit_by_type(?MOD_HUSONG, ?HuSongBestCounterId),
            case BestHuSongTimes + 1 =< BestHuSongTimesMax of
                true ->
                    mod_counter:increment(Ps#player_status.id, ?MOD_HUSONG, ?HuSongBestCounterId),
                    case BestHuSongTimes + 1 =:= BestHuSongTimesMax of
                        true ->
                            case lib_designation:active_dsgt(Ps, ?HuSongDesignationId) of
                                {true, NewPs1} ->
                                    skip;
                                {_, NewPs1, _} ->
                                    skip;
                                _ ->
                                    NewPs1 = Ps
                            end;
                        false ->
                            NewPs1 = Ps
                    end;
                false ->
                    NewPs1 = Ps
            end;
        false ->
            NewPs1 = Ps
    end,
    case Stage of
        1 ->
            NewPs = lib_goods_api:send_reward(NewPs1, RewardList, husong_finish_first, 0);
        _ ->
            NewPs = lib_goods_api:send_reward(NewPs1, RewardList, husong_finish_last, 0)
    end,
    {NewPs, RewardList}.

husong_sql(HuSong) ->
    #husong{
        role_id = RoleId,
        angel_id = AngelId,
        stage = Stage,
        reward_stage = RewardStage,
        start_time = StartTime,
        invincible_skill = InvincibleSkill,
        ask_help_time = AskHelpTime
    } = HuSong,
    ReSql = io_lib:format(?ReplaceHuSongPlayerSql, [RoleId, AngelId, Stage, RewardStage, StartTime, InvincibleSkill, AskHelpTime]),
    db:execute(ReSql).

husogn_help(Ps, HelpRoleId, HelpSceneId) ->
    #player_status{
        id = AskHelpRoleId,
        scene = SceneId,
        scene_pool_id = SPId,
        copy_id = CopyId,
        x = X,
        y = Y,
        husong = HuSong
    } = Ps,
    #husong{
        start_time = StartTime
    } = HuSong,
    case StartTime of
        0 ->
            Code = ?ERRCODE(err500_husong_help_end);
        _ ->
            case HelpSceneId of
                SceneId ->
                    Code = ?ERRCODE(err500_husong_help_same_scene);
                _ ->
                    Code = ?SUCCESS,
                    lib_scene:player_change_scene(HelpRoleId, SceneId, SPId, CopyId, X, Y, false, [])
            end
    end,
    {ok, Bin} = pt_500:write(50007, [Code, AskHelpRoleId, X, Y]),
    lib_server_send:send_to_uid(HelpRoleId, Bin).

is_husong(HuSong) ->
    #husong{
        stage = Stage
    } = HuSong,
    case Stage of
        1 ->
            true;
        _ ->
            false
    end.

reconnect(Ps, _LoginType) ->
    #player_status{
        x = X,
        y = Y,
        husong = HuSong
    } = Ps,
    #husong{
        start_time = StartTime,
        stage = Stage
    } = HuSong,
    case StartTime of
        0 ->
            {next, Ps};
        _ ->
            case Stage of
                1 ->
                    NewPs1 = lib_scene:change_scene(Ps, 1003, 0, 0, X, Y, true, []),
                    % %% 切换为终极和平状态
                    % case lib_player:change_pkstatus(NewPs1, ?PK_PEACE_ULTIMATE, true) of
                    %     {ok, NewPs} ->
                    %         skip;
                    %     _ ->
                    %         NewPs = NewPs1
                    % end;
                    NewPs = NewPs1;
                _ ->
                    NewPs = lib_scene:change_scene(Ps, ?HuSongScene, 0, 0, X, Y, true, [])
            end,
            {ok, NewPs}
    end.

double_change(ActId) ->
    IfDouble = get_double_end_time(ActId),
    {ok, Bin} = pt_500:write(50011, [IfDouble]),
    lib_server_send:send_to_all(Bin).

%% 获取双倍护送的结束时间
get_double_end_time(ActId) ->
    #base_ac{
        time_region = TimeRegion
    } = data_activitycalen:get_ac(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE, ActId),
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(),
    get_double_end_time_1(TimeRegion, NowTime, NowDate).

get_double_end_time_1([T | G], NowTime, NowDate) ->
    {{ConStartHour, ConStartMinute}, {ConEndHour, ConEndMinute}} = T,
    StartTime = NowDate + ConStartHour * 60 * 60 + ConStartMinute * 60,
    EndTime = NowDate + ConEndHour * 60 * 60 + ConEndMinute * 60,
    case NowTime >= StartTime andalso NowTime < EndTime of
        true ->
            EndTime;
        false ->
            get_double_end_time_1(G, NowTime, NowDate)
    end;
get_double_end_time_1([], _NowTime, _NowDate) ->
    0.


%% 护送剩余次数
get_husong_daily(RoleId) ->
    %% 获取日常次数
    GetDailyCountList = [?HuSongDailyId, ?HuSongFreeDailyId],
    DailyCountList = mod_daily:get_count(RoleId, ?MOD_HUSONG, GetDailyCountList), % 获取每日计数器
    {_, TodayHuSongNum} = lists:keyfind(?HuSongDailyId, 1, DailyCountList),
    %% 限制次数
    TodayHuSongMax = mod_daily:get_limit_by_type(?MOD_HUSONG, ?HuSongDailyId),
    %% 计算剩余次数
    max(0, (TodayHuSongMax - TodayHuSongNum)).


































