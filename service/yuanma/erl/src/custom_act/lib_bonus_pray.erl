%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_pray
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-7-08
%% @Description:    神佑祈愿
%%-----------------------------------------------------------------------------
-module(lib_bonus_pray).

-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("figure.hrl").

-export([
        login/1,
        updata_info/4,
        day_clear_act_data/2,
        do_pray/5,
        send_pray_info/3,
        init_data_after_act_open/1,
        get_stage_reward/4
    ]).

-record(pray_status, {
        pray_data_map = #{}     %% {type, subtype} => #pray_data
    }).

-record(pray_data, {
        type = 0,
        subtype = 0,
        total_times = 0,        %% 总抽奖次数
        draw_times = 0,         %% 本轮抽奖次数
        turn = 1,               %% 轮数
        free_times = 0,         %% 免费次数
        rare_draw = 0,          %% 未抽中超稀有累计次数（普通必中没有抽中超稀有（3）加一，抽中清0）
        stage = [],
        stime = 0               %% 操作时间
    }).

-define(SQL_SELECT,   <<"select `type`, `subtype`, `total_times`, `draw_times`, `turn`, `free_times`, `rare_draw`, `stage`, `stime` from `player_bonus_pray` where role_id = ~p">>).
-define(SQL_REPLACE,  <<"replace into player_bonus_pray (`type`, `subtype`, `role_id`, `total_times`, `draw_times`, `turn`, `free_times`, `rare_draw`, `stage`, `stime`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(SQL_DELETE,   <<"delete from player_bonus_pray where `type` = ~p and `subtype` = ~p and `role_id` = ~p">>).

login(Player) ->
    #player_status{id = RoleId} = Player,
    Now = utime:unixtime(),
    List = db:get_all(io_lib:format(?SQL_SELECT, [RoleId])),
    Fun = fun([Type, Subtype, TotalTimes, DrawTimes, Turn, FreeTimes, RareDraw, StageStr, Stime], TemMap) ->
        IsOpen = lib_custom_act_api:is_open_act(Type, Subtype),
        ?PRINT(Subtype == 1,"============ IsOpen:~p~n", [IsOpen]),
        Stage = util:bitstring_to_term(StageStr),
        if
            IsOpen == false ->
                db:execute(io_lib:format(?SQL_DELETE, [Type, Subtype, RoleId])),
                TemMap;
            true ->
                #custom_act_cfg{clear_type = ClearType, condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
                ClearCfg = get_conditions(clear_type, Conditions),
                if
                    ClearType == ?CUSTOM_ACT_CLEAR_ZERO andalso ClearCfg == day ->
                        IsSameDay = utime:is_same_day(Now, Stime);
                    ClearType == ?CUSTOM_ACT_CLEAR_FOUR andalso ClearCfg == day ->
                        IsSameDay = utime_logic:is_logic_same_day(Now, Stime);
                    true ->
                        IsSameDay = true
                end,
                if
                    IsSameDay == false ->
                        FreeTimes1 = get_conditions(free_times, Conditions),
                        DefaultStage = calc_default_stage(Type, Subtype),
                        Sql = io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, 0, 0, 0, FreeTimes1, 0, util:term_to_string(DefaultStage), Now]),
                        db:execute(Sql),
                        Data = #pray_data{type = Type, subtype = Subtype, total_times = 0, draw_times = 0, turn = 1, free_times = FreeTimes1, 
                            rare_draw = 0, stage = DefaultStage, stime = Now};
                    true ->
                        Data = #pray_data{type = Type, subtype = Subtype, total_times = TotalTimes, draw_times = DrawTimes, turn = Turn, 
                            free_times = FreeTimes, rare_draw = RareDraw, stage = Stage, stime = Stime}
                end,
                maps:put({Type, Subtype}, Data, TemMap)
        end
    end,
    PrayMap = lists:foldl(Fun, #{}, List),
    PrayStatus = #pray_status{pray_data_map = PrayMap},
    init_data_after_act_open(Player#player_status{pray_status = PrayStatus}).
    

%% 活动开启
updata_info(Player, Type, Subtype, open) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, pray_status = PrayStatus} = Player,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
    case lists:keyfind(wlv, 1, Conditions) of
        {_, [{Min, Max}]} -> skip;
        _ -> Min = 1, Max = 99999
    end,
    #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
    LimitLv = get_conditions(role_lv, Conditions),
    if
        RoleLv >= LimitLv andalso Min =< Wlv andalso Wlv =< Max ->
            #pray_status{pray_data_map = PrayMap} = PrayStatus,
            FreeTimes = get_conditions(free_times, Conditions),
            Now = utime:unixtime(),
            DefaultStage = calc_default_stage(Type, Subtype),
            Data = #pray_data{type = Type, subtype = Subtype, total_times = 0, draw_times = 0, turn = 1, free_times = FreeTimes, stage = DefaultStage, stime = Now},
            db:execute(io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, 0, 0, 0, FreeTimes, 0, util:term_to_string(DefaultStage), Now])),
            NewMap = maps:put({Type, Subtype}, Data, PrayMap),
            NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},
            {ok, Player#player_status{pray_status = NewPrayStatus}};
        true ->
            {ok, Player}
    end;
%% 活动关闭
updata_info(Player, Type, Subtype, close) ->
    #player_status{id = RoleId, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    case maps:get({Type, Subtype}, PrayMap, []) of
        [] ->
            {ok, Player};
        _ ->
            NewMap = maps:remove({Type, Subtype}, PrayMap),
            db:execute(io_lib:format(?SQL_DELETE, [Type, Subtype, RoleId])),
            NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},
            {ok, Player#player_status{pray_status = NewPrayStatus}}
    end;
%% 每日清理/ 满足条件{clear_type, day} andalso 0点清理或者4点清理
updata_info(Player, Type, Subtype, day_clear) ->
    #player_status{id = RoleId, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    case maps:get({Type, Subtype}, PrayMap, []) of
        [] ->
            {ok, Player};
        #pray_data{} = Data ->
            Now = utime:unixtime(),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
            FreeTimes = get_conditions(free_times, Conditions),
            DefaultStage = calc_default_stage(Type, Subtype),
            NewData = Data#pray_data{total_times = 0, draw_times = 0, turn = 1, free_times = FreeTimes, stage = DefaultStage, stime = Now},
            db:execute(io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, 0, 0, 0, FreeTimes, 0, util:term_to_string(DefaultStage), Now])),
            NewMap = maps:put({Type, Subtype}, NewData, PrayMap),
            NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},
            {ok, Player#player_status{pray_status = NewPrayStatus}}
    end;
updata_info(Player, _,_,_) -> {ok, Player}.
            
%% 0/4点清理数据
day_clear_act_data(Type, Subtype) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
    ClearCfg = get_conditions(clear_type, Conditions),
    if
        ClearCfg == day ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pray, updata_info, [Type, Subtype, day_clear]) || E <- OnlineRoles];
        true ->
            skip
    end.

%% 祈愿
do_pray(Player, Type, Subtype, Times, AutoBuy) -> %% 33176
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    IsOpen = lib_custom_act_api:is_open_act(Type, Subtype),
    if
        IsOpen == false ->
            {ok, NewPlayer} = updata_info(Player, Type, Subtype, close),
            lib_server_send:send_to_uid(RoleId, pt_331, 33176, [Type, Subtype, ?ERRCODE(err331_act_closed), [], 0, 0, []]),
            NewPlayer;
        true ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
            case maps:get({Type, Subtype}, PrayMap, []) of
                #pray_data{} = Data ->
                    do_pray_helper(Player, Data, Times, AutoBuy, Conditions);
                _ ->
                    case lists:keyfind(wlv, 1, Conditions) of
                        {_, [{Min, Max}]} -> skip;
                        _ -> Min = 1, Max = 99999
                    end,
                    #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
                    LimitLv = get_conditions(role_lv, Conditions),
                    if
                        RoleLv >= LimitLv andalso Min =< Wlv andalso Wlv =< Max ->
                            FreeTimes = get_conditions(free_times, Conditions),
                            Now = utime:unixtime(),
                            DefaultStage = calc_default_stage(Type, Subtype),
                            Data = #pray_data{type = Type, subtype = Subtype, total_times = 0, draw_times = 0, turn = 1, free_times = FreeTimes, stage = DefaultStage, stime = Now},
                            do_pray_helper(Player, Data, Times, AutoBuy, Conditions);
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33176, [Type, Subtype, ?ERRCODE(err331_lv_not_enougth), [], 0, 0, []]),
                            Player
                    end
            end
    end.

do_pray_helper(Player, Data, Times, AutoBuy, Conditions) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    #pray_data{type = Type, subtype = Subtype, total_times = TotalTimes, draw_times = DrawTimes, turn = Turn, 
            free_times = FreeTimes, rare_draw = RareDraw, stage = Stage} = Data,
    Now = utime:unixtime(),
    if
        FreeTimes >= Times andalso Times == 1 ->
            NewFreeTimes = FreeTimes - 1,
            Cost = [];
        Times == 1 ->
            NewFreeTimes = FreeTimes,
            case lists:keyfind(one_cost, 1, Conditions) of
                {_, Cost} -> skip;
                _ -> Cost = []
            end;
        true ->
            NewFreeTimes = FreeTimes,
            case lists:keyfind(ten_cost, 1, Conditions) of
                {_, Cost} -> skip;
                _ -> Cost = []
            end
    end,
    ConsumeType = get_consume_type(Type),
    About = [Type, Subtype, Times],
    Res = if
        Cost == [] ->
            {true, Player, Cost};
        AutoBuy == 1 ->
            lib_goods_api:cost_objects_with_auto_buy(Player, Cost, ConsumeType, About);
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, ConsumeType, About) of
                {true, TmpNewPlayer} ->
                    {true, TmpNewPlayer, Cost};
                Other ->
                    Other
            end
    end,
    case Res of
        {true, NewPlayer, CostList} ->
            {NewTotalTimes, NewDrawTimes, NewTurn, NewRareDraw, RewardList, SendList} = 
                    pray_core(NewPlayer, Type, Subtype, Times, TotalTimes, DrawTimes, Turn, RareDraw, [], []),
            ProduceType = get_produce_type(Type),
            Produce = #produce{type = ProduceType, subtype = Type, reward = RewardList, show_tips = ?SHOW_TIPS_0},
            NewPlayer1 = lib_goods_api:send_reward(NewPlayer, Produce),
            case lists:keyfind(add_score, 1, Conditions) of
                {_, AddScore} -> Score = NewTotalTimes*AddScore;
                _ -> Score = 0
            end,
            NewStage = calc_stage(Score, Stage),
            SendStage = send_stage(Player, Type, Subtype, Stage),
            lib_server_send:send_to_uid(RoleId, pt_331, 33176, [Type, Subtype, ?SUCCESS, SendList, NewFreeTimes, Score, SendStage]),
            Sql = io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, NewTotalTimes, NewDrawTimes, NewTurn, NewFreeTimes, NewRareDraw, util:term_to_string(NewStage), Now]),
            db:execute(Sql),
            % ?PRINT("Sql:~s~n",[Sql]),
            %% 日志
            lib_log_api:log_custom_act_reward(RoleId, Type, Subtype, 0, RewardList),
            lib_log_api:log_act_pray(RoleId, RoleName, Type, Subtype, Times, CostList, RewardList),

            NewData = Data#pray_data{total_times = NewTotalTimes, draw_times = NewDrawTimes, turn = NewTurn, 
                    free_times = NewFreeTimes, rare_draw = NewRareDraw, stage = NewStage, stime = Now},
            NewMap = maps:put({Type, Subtype}, NewData, PrayMap),
            NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},
            NewPlayer1#player_status{pray_status = NewPrayStatus};      
        {false, Error, NewPlayer} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33176, [Type, Subtype, Error, [], FreeTimes, 0, []]),
            NewPlayer
    end.
            
calc_default_stage(Type, Subtype) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, Subtype),
    Fun = fun(GradeId, Acc) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId),
        case lists:keyfind(total, 1, Conditions) of
            {_, Score} -> [{GradeId, Score, 0}|Acc];
            _ -> Acc
        end
    end,
    lists:foldl(Fun, [], AllIds).

calc_stage(Score, Stage) ->
    Fun = fun({GradeId, TemScore, Status}, Acc) ->
        if
            Status >= 1 ->
                [{GradeId, TemScore, Status}|Acc];
            true ->
                if
                    TemScore =< Score ->
                        [{GradeId, TemScore, 1}|Acc];
                    true ->
                        [{GradeId, TemScore, 0}|Acc]
                end
        end
    end,
    lists:foldl(Fun, [], Stage).

pray_core(_Player, _Type, _Subtype, 0, TotalTimes, DrawTimes, Turn, RareDraw, RewardList, SendList) ->
    {TotalTimes, DrawTimes, Turn, RareDraw, RewardList, SendList};
pray_core(Player, Type, Subtype, Times, TotalTimes, DrawTimes, Turn, RareDraw, RewardList, SendList) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Player,
    {NewTotalTimes, NewDrawTimes, NewTurn, Pool, NewRareDraw} = calc_act_pool(Type, Subtype, TotalTimes+1, DrawTimes+1, Turn, RareDraw),
    ?PRINT("======== NewDrawTimes:~p,NewTotalTimes:~p~n",[NewDrawTimes, NewTotalTimes]),
    if
        Turn =/= NewTurn ->
            case calc_real_pool(Pool, [], []) of
                {true, RealPool} ->
                    
                    GradeId = urand:rand_with_weight(RealPool);
                {false, RealPool} ->
                    GradeId = urand:list_rand(RealPool)
            end;
        true ->
            GradeId = urand:rand_with_weight(Pool)
    end,
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId),
    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
    Rare = get_conditions(rare, Conditions),
    TvId = get_conditions(tv_id, Conditions),
    Record = get_conditions(record, Conditions),
    ?PRINT(Rare == 2,"======== Rare:~p~n",[Rare]),
    if
        Rare == 3 ->
            RealRareDraw = 0;
        true ->
            RealRareDraw = NewRareDraw
    end,
    if
        Turn == NewTurn andalso Rare >= 2 -> %% 普通抽奖抽中超稀有重置次数
            RealDrawTimes = 0, RealTurn = NewTurn + 1;
        true ->
            RealDrawTimes = NewDrawTimes, RealTurn = NewTurn
    end,
    if
        TvId > 0 andalso Reward =/= [] ->
            [{Gtype, GoodsTypeId, GNum}|_] = Reward,
            RealGtypeId = get_real_goodstypeid(GoodsTypeId, Gtype),
            case data_goods_type:get(RealGtypeId) of
                #ets_goods_type{color = Color} -> Color;
                _ -> Color = 0
            end,
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, TvId, [RoleName, RoleId, data_color:get_name(Color), RealGtypeId, GNum, Type, Subtype]);
        true ->
            skip
    end,
    if
        Record == 1 ->
            mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, Subtype, RoleName, Reward});
        true ->
            skip
    end,
    pray_core(Player, Type, Subtype, Times - 1, NewTotalTimes, RealDrawTimes, RealTurn, RealRareDraw, RewardList++Reward, [{Rare, Reward}|SendList]).

%% 界面
send_pray_info(Player, Type, Subtype) -> %% 33177
    #player_status{id = RoleId, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    case maps:get({Type, Subtype}, PrayMap, []) of
        #pray_data{free_times = FreeTimes, stage = Stage, total_times = TotalTimes} ->
            SendList = get_config_reward_list(Type, Subtype),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
            case lists:keyfind(add_score, 1, Conditions) of
                {_, AddScore} -> Score = TotalTimes*AddScore;
                _ -> Score = 0
            end,
            SendStage = send_stage(Player, Type, Subtype, Stage),
            ?PRINT("FreeTimes:~p, SendStage:~p~n",[FreeTimes, SendStage]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33177, [Type, Subtype, FreeTimes, Score, SendList, SendStage]);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33177, [Type, Subtype, 0, 0, [], []])
    end,
    Player.

get_config_reward_list(Type, Subtype) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, Subtype),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId) of
            #custom_act_reward_cfg{name = Name, desc = Desc, condition = Conditions, format = Format, reward = Reward} ->
                ConditionStr = util:term_to_string(Conditions),
                RewardStr = util:term_to_string(Reward),
                [{GradeId, Format, 0, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
            _ ->
                Acc
        end
    end,
    PackList = lists:foldl(F, [], AllIds),
    PackList.

send_stage(Player, Type, Subtype, Stage) ->
    Fun = fun({GradeId, Score, Status}, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId) of
            #custom_act_reward_cfg{} = RewardCfg ->
                ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
                Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                [{GradeId, Score, Reward, Status} | Acc];
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], Stage).

get_stage_reward(Player, Type, Subtype, GradeId) ->
    #player_status{id = RoleId, pray_status = PrayStatus} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    case maps:get({Type, Subtype}, PrayMap, []) of
        #pray_data{total_times = TotalTimes, draw_times = DrawTimes, turn = Turn, 
                free_times = FreeTimes, rare_draw = RareDraw, stage = Stage} = Data ->
            case lists:keyfind(GradeId, 1, Stage) of
                {GradeId, Score, Status} when Status == 1 ->
                    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId),
                    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    ProduceType = get_produce_type(Type),
                    Now = utime:unixtime(),
                    NewStage = lists:keystore(Score, 2, Stage, {GradeId, Score, 2}),
                    db:execute(io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, TotalTimes, DrawTimes, Turn, FreeTimes,
                         RareDraw, util:term_to_string(NewStage), Now])),

                    NewData = Data#pray_data{stage = NewStage, stime = Now},
                    NewMap = maps:put({Type, Subtype}, NewData, PrayMap),
                    NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},     
                    Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                    NewPlayer1 = lib_goods_api:send_reward(Player, Produce),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33178, [Type, Subtype, GradeId, ?SUCCESS, Reward]),
                    NewPlayer1#player_status{pray_status = NewPrayStatus};
                {_, _, Status} ->
                    if
                        Status == 0 ->
                            Code = ?ERRCODE(err331_act_can_not_get);
                        true ->
                            Code = ?ERRCODE(err331_already_get_reward)
                    end,
                    lib_server_send:send_to_uid(RoleId, pt_331, 33178, [Type, Subtype, GradeId, Code, []]),
                    Player;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33178, [Type, Subtype, GradeId, ?ERRCODE(err331_act_data_err), []]),
                    Player
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33178, [Type, Subtype, GradeId, ?FAIL, []]),
            Player
    end.

get_conditions(Key, Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} ->skip;
        _ -> Times = 0
    end,
    Times.

init_data_after_act_open(Player) ->
    #player_status{id = RoleId, pray_status = PrayStatus, figure = #figure{lv = RoleLv}} = Player,
    #pray_status{pray_data_map = PrayMap} = PrayStatus,
    Type = ?CUSTOM_ACT_TYPE_PRAY,
    SubtypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(Subtype, Map) ->
        case maps:get({Type, Subtype}, Map, []) of
            [] ->
                #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
                case lists:keyfind(wlv, 1, Conditions) of
                    {_, [{Min, Max}]} -> skip;
                    _ -> Min = 1, Max = 99999
                end,
                #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, Subtype),
                LimitLv = get_conditions(role_lv, Conditions),
                if
                    RoleLv >= LimitLv andalso Min =< Wlv andalso Wlv =< Max ->
                        FreeTimes = get_conditions(free_times, Conditions),
                        Now = utime:unixtime(),
                        DefaultStage = calc_default_stage(Type, Subtype),
                        Data = #pray_data{type = Type, subtype = Subtype, total_times = 0, draw_times = 0, turn = 1, free_times = FreeTimes, stage = DefaultStage, stime = Now},
                        db:execute(io_lib:format(?SQL_REPLACE, [Type, Subtype, RoleId, 0, 0, 0, FreeTimes, 0, util:term_to_string(DefaultStage), Now])),
                        maps:put({Type, Subtype}, Data, Map);
                    true ->
                        Map
                end;
            _ ->
                Map
        end
    end,
    NewMap = lists:foldl(Fun, PrayMap, SubtypeList),
    NewPrayStatus = PrayStatus#pray_status{pray_data_map = NewMap},
    Player#player_status{pray_status = NewPrayStatus}.

get_produce_type(_Type) ->
    custom_act_pray. %% ?CUSTOM_ACT_TYPE_PRAY
get_consume_type(_Type) ->
    custom_act_pray. %% ?CUSTOM_ACT_TYPE_PRAY

get_real_goodstypeid(GoodsTypeId, Gtype) ->
    if
        GoodsTypeId =/= 0 ->
            GoodsTypeId;
        true ->
            if
                Gtype == 1 ->
                    ?GOODS_ID_GOLD;
                Gtype == 2 ->
                    ?GOODS_ID_BGOLD;
                Gtype == 3 ->
                    ?GOODS_ID_COIN;
                true ->
                    0
            end
    end. 

get_max_draw_times(_Turn, []) -> 0;
get_max_draw_times(Turn, [{Min, Max, MaxDrawTimes}|T]) ->
    if      %[{1,2,20},{3,999,50}]
        Turn >= Min andalso Turn =< Max ->
            MaxDrawTimes;
        true ->
            get_max_draw_times(Turn, T)
    end.

calc_act_pool(Type, Subtype, TotalTimes, DrawTimes, Turn, RareDraw) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
    SpecialRule = get_conditions(total_num, ActConditions),
    RareDrawCfg = get_conditions(spc_total, ActConditions),
    MaxDrawTimes = get_max_draw_times(Turn, SpecialRule),
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, Subtype),
    if
        DrawTimes >= MaxDrawTimes andalso MaxDrawTimes =/= 0 andalso RareDraw >= RareDrawCfg ->
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId) of
                    #custom_act_reward_cfg{condition = Conditions} ->
                        Rare = get_conditions(rare, Conditions),
                        if
                            Rare == 3 ->
                                case lists:keyfind(spc_weight, 1, Conditions) of
                                    {spc_weight, Weight} ->skip;
                                    _ -> 
                                        case lists:keyfind(weight, 1, Conditions) of
                                            {weight, {_, _, NorWeight, _}} -> Weight = NorWeight;
                                            _ -> Weight = 0
                                        end
                                end,
                                [{Weight, GradeId}|Acc];
                            true ->
                                Acc
                        end;                        
                    _ ->
                        Acc
                end
            end,
            Pool = lists:foldl(F, [], AllIds),
            {TotalTimes, 0, Turn+1, Pool, 0};
        DrawTimes >= MaxDrawTimes andalso MaxDrawTimes =/= 0 ->
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId) of
                    #custom_act_reward_cfg{condition = Conditions} ->
                        Rare = get_conditions(rare, Conditions),
                        if
                            Rare == 2 orelse Rare == 3 ->
                                case lists:keyfind(spc_weight, 1, Conditions) of
                                    {spc_weight, Weight} ->skip;
                                    _ -> 
                                        case lists:keyfind(weight, 1, Conditions) of
                                            {weight, {_, _, NorWeight, _}} -> Weight = NorWeight;
                                            _ -> Weight = 0
                                        end
                                end,
                                [{Weight, GradeId}|Acc];
                            true ->
                                Acc
                        end;                        
                    _ ->
                        Acc
                end
            end,
            Pool = lists:foldl(F, [], AllIds),
            {TotalTimes, 0, Turn+1, Pool, RareDraw+1};
        true ->
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, Subtype, GradeId) of
                    #custom_act_reward_cfg{condition = Conditions} ->
                        case lists:keyfind(weight, 1, Conditions) of
                            {weight, {Min, Max, NorWeight, AddWeight}} ->skip;
                            _ -> Min = 0, Max = 0, NorWeight = 0, AddWeight = 0
                        end,
                        if
                            TotalTimes < Min ->
                                Acc;
                            TotalTimes >= Min andalso TotalTimes =< Max ->
                                [{NorWeight+AddWeight, GradeId}|Acc];
                            true ->
                                [{NorWeight, GradeId}|Acc]
                        end;                     
                    _ ->
                        Acc
                end
            end,
            Pool = lists:foldl(F, [], AllIds),
            {TotalTimes, DrawTimes, Turn, Pool, RareDraw}
    end.

calc_real_pool([], NewAcc, NewPool) -> 
    if
        NewPool == [] ->
            if
                NewAcc =/= [] ->
                    {false, NewAcc};
                true ->
                    {false, [1]}
            end;
        true ->
            {true, NewPool}
    end;
calc_real_pool([{Weight, GradeId}|T], Weight0Acc, RealPool) ->
    if
        Weight == 0 ->
            NewAcc = [GradeId|Weight0Acc], NewPool = RealPool;
        true ->
            NewAcc = Weight0Acc, NewPool = [{Weight, GradeId}|RealPool]
    end,
    calc_real_pool(T, NewAcc, NewPool).    