%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_draw
%% @Author  :       xlh
%% @Email   :
%% @Created :       2018-12-08
%% @Description:    赛博夺宝
%%-----------------------------------------------------------------------------
-module(lib_bonus_draw).

-include("common.hrl").
-include("server.hrl").
-include("bonus_draw.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").

-export([
        init_data/1,
        get_bonus/5,
        stage_reward_get/6
        ,send_info/3
        ,midnight_update/3
        ,act_end/2
        ,midnight_update_helper/3
        ,act_end_helper/6
        ,check_role_lv/3
        ,init_data_lv_up/1
        ,gm_reset_bonus_draw/1
        ,gm_set_wave/4
        ,gm_refill_data/0
        ,gm_refill_data_refresh/3
        ,calc_pool/4
        ,get_conditions/2
        ,get_normal_pool_total_weight/3
        ,do_draw_core/7
        ,calc_normal_reward/4
        ,calc_reward/4
        ,calc_default_pool/4
        ,calc_pool/5
    ]).

select_from_db(RoleId, RoleName, Type, SubType, ClearType, Clear) ->
    List = db:get_row(io_lib:format(?SQL_SELECT, [RoleId, Type, SubType])),
    case List of
        [Wave, PoolS, DrawTimes, TodayDrawTimes, StageS, Utime] ->
            Pool = util:bitstring_to_term(PoolS),
            StageState = util:bitstring_to_term(StageS),
            ActArgs = [Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime],
            clear_act_core(RoleId, RoleName, Type, SubType, ClearType, Clear, ActArgs);
        _ ->
            false
    end.

clear_act_core(RoleId, RoleName, Type, SubType, ClearType, Clear, ActArgs) ->
    [Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime] = ActArgs,
    Now = utime:unixtime(),
    if
        ClearType == ?CUSTOM_ACT_CLEAR_ZERO ->
            IsSameDay = utime:is_same_day(Now, Utime),
            if
                IsSameDay ->
                    {Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime};
                true ->
                    NewStageState = send_reward_data_clear(Type, SubType, RoleId, RoleName, DrawTimes, Wave, StageState, []),
                    {NewDT, NewTDT, NewSS, NewWave} = calc_real_times(Clear,DrawTimes,TodayDrawTimes,NewStageState,Wave),
                    replace_db_data(RoleId, Type, SubType, NewWave, Pool, NewDT, NewTDT, NewSS, Now),
                    {Wave, Pool, NewDT, NewTDT, NewSS, Now}
            end;
        ClearType == ?CUSTOM_ACT_CLEAR_FOUR ->
            IsSameDay = utime_logic:is_logic_same_day(Now, Utime),
            if
                IsSameDay ->
                    {Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime};
                true ->
                    NewStageState = send_reward_data_clear(Type, SubType, RoleId, RoleName, DrawTimes, Wave, StageState, []),
                    {NewDT, NewTDT, NewSS, NewWave} = calc_real_times(Clear,DrawTimes,TodayDrawTimes,NewStageState,Wave),
                    replace_db_data(RoleId, Type, SubType, NewWave, Pool, NewDT, NewTDT, NewSS, Now),
                    {Wave, Pool, NewDT, NewTDT, NewSS, Now}
            end;
        true ->
            {Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime}
    end.

calc_real_times(Clear,DrawTimes,TodayDrawTimes,StageState,Wave) ->
    case Clear of
        [_, _, _] ->
            {0,0,[],1};
        [sum, day] ->
            {0, 0, [], Wave};
        [sum, wave] ->
            {0, TodayDrawTimes, [], 1};
        [day, wave] ->
            {DrawTimes, 0, StageState, 1};
        [sum] ->
            {0, TodayDrawTimes, []};
        [day] ->
            {DrawTimes, 0, StageState, Wave};
        [wave] ->
            {DrawTimes, TodayDrawTimes, StageState, 1};
        _ ->
            {DrawTimes, TodayDrawTimes, StageState, Wave}
    end.

replace_db_data(RoleId, Type, SubType, Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime) ->
    db:execute(io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, Wave, util:term_to_string(Pool),
            DrawTimes, TodayDrawTimes, util:term_to_string(StageState), Utime])).
replace_db_data(RoleId, DrawData) ->
    case DrawData of
        #draw_data{key = {Type, SubType}, wave = Wave, pool = Pool, draw_times = DrawTimes, today_draw_times = TodayDrawTimes,
                stage_reward = StageState, utime = Utime} ->
            db:execute(io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, Wave, util:term_to_string(Pool),
                    DrawTimes, TodayDrawTimes, util:term_to_string(StageState), Utime]));
        _ ->
            skip
    end.

% delete_data_db(Type, SubType) ->
%     Nowtime = utime:unixtime(),
%     ClearTime = lib_custom_act_util:calc_clear_time(Type, SubType, Nowtime),
%     if
%         ClearTime > 0 ->
%             db:execute(io_lib:format(?SQL_DELETE, [Type, SubType,ClearTime]));
%         true ->
%             skip
%     end.

init_data(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName}} = Player,
    TypeList = [?CUSTOM_ACT_TYPE_DRAW_REWARD],
    Fun = fun(Type, TemMap) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, TemMap1) ->
            case init_data_helper(Type, SubType, RoleLv, RoleId, RoleName) of
                DrawData when is_record(DrawData, draw_data) ->
                    maps:put({Type, SubType}, DrawData, TemMap1);
                _ ->
                    TemMap1
            end
        end,
        lists:foldl(Fun2, TemMap, SubTypes)
    end,
    ActData = lists:foldl(Fun, #{}, TypeList),
    Player#player_status{draw_reward = #draw_reward_status{act_data = ActData}}.

init_data_helper(Type, SubType, RoleLv, RoleId, RoleName) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #custom_act_cfg{condition = Conditions, clear_type = ClearType} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            LimitLv = get_conditions(role_lv, Conditions),
            WaveCfg = get_conditions(wave, Conditions),
            Clear = get_conditions(clear, Conditions),
            if
                RoleLv >= LimitLv andalso RoleLv > 0->
                    case select_from_db(RoleId, RoleName, Type, SubType, ClearType, Clear) of
                        {Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime} ->
                            % ?PRINT("Pool:~p~n",[Pool]),
                            DrawData = #draw_data{
                                key = {Type, SubType},
                                wave = Wave,
                                pool = Pool,
                                draw_times = DrawTimes,
                                today_draw_times = TodayDrawTimes,
                                stage_reward = StageState,
                                utime = Utime};
                        false ->
                            if
                                is_integer(WaveCfg) andalso WaveCfg >= 0 ->
                                    RealWave = 1;
                                true ->
                                    RealWave = 0
                            end,
                            % ?PRINT("@@@@ Pool:~p~n",[calc_default_pool(Type, SubType, Conditions, RealWave)]),
                            DrawData = #draw_data{
                                key = {Type, SubType},
                                wave = RealWave,
                                pool = calc_default_pool(Type, SubType, Conditions, RealWave),
                                draw_times = 0,
                                today_draw_times = 0,
                                stage_reward = calc_default_stage_state(Type, SubType, 0),
                                utime = 0}
                    end;
                true -> DrawData = []
            end;
        false -> DrawData = []
    end,
    DrawData.

send_info(Player0, Type, SubType) ->
    #player_status{sid = Sid, id = _RoleId, draw_reward = DrawReward} = Player0,
    case DrawReward of
        #draw_reward_status{act_data = ActData} ->Player = Player0;
        _ ->
            Player = init_data(Player0),
            #player_status{draw_reward = #draw_reward_status{act_data = ActData}} = Player
    end,
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            case maps:get({Type, SubType}, ActData, []) of
                #draw_data{wave = Wave, pool = Pool, draw_times = DrawTimes, today_draw_times = TodayDrawTimes, stage_reward = StageState} ->
                    {SendPool, SendStage} = package_data(Type, SubType, Wave, Pool, StageState),
                    % ?PRINT("Length:~p,SendPool:~p~n",[erlang:length(SendPool),SendPool]),
                    lib_server_send:send_to_sid(Sid, pt_331, 33165, [Type, SubType, Wave, DrawTimes, TodayDrawTimes, SendPool, SendStage]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33165, [Type, SubType, 0, 0, 0, [], []])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33165, [Type, SubType, 0, 0, 0, [], []])
    end,
    {ok, Player}.

get_conditions(Key,Conditions) ->
    case lists:keyfind(Key, 1, Conditions) of
        {Key, Times} ->skip;
        _ -> Times = 0
    end,
    Times.

calc_default_pool(Type, SubType, ActConditions, Wave) ->
    GradeIdS = calc_default_pool_helper(Type,SubType,Wave,ActConditions),
    % ?PRINT("================== ~n",[]),
    % GradeIdS = ulists:list_shuffle(GradeIdS1),
    Fun = fun(GradeId, {Sum, Acc}) ->
        {Sum+1,[{GradeId, Sum+1, ?HAVE}|Acc]}
    end,
    {_, Pool} = lists:foldl(Fun, {0,[]}, GradeIdS),
    Pool.

calc_default_pool_helper(Type,SubType,Wave,Conditions) ->
    NormalLength = get_conditions(normal, Conditions),
    SpecialLength = get_conditions(special, Conditions),
    Dis = NormalLength div SpecialLength,
    RarePoolCfg = data_bonus_draw:get_pool(Type,SubType,Wave,?RARE),
    NormalPoolCfg = data_bonus_draw:get_pool(Type,SubType,Wave,?UNRARE),
    RarePool = calc_default_pool_core(Type, SubType, Wave, RarePoolCfg, SpecialLength),
    NormalPool = calc_default_pool_core(Type, SubType, Wave, NormalPoolCfg, NormalLength),
    % ?PRINT("@@@@@@ RarePool:~p,NormalPool:~p~n",[RarePool,NormalPool]),
    sort_pool(Dis, NormalPool, RarePool, []).

calc_default_pool_core(Type, SubType, Wave, PoolCfg, Length) ->
    Fun = fun(GradeId, Acc) ->
        case data_bonus_draw:get_bonus_grade(Type, SubType, Wave, GradeId) of
            #base_draw_pool{conditions = Conditions} ->
                case lists:keyfind(weight, 1, Conditions) of
                    {_, Weight} when is_integer(Weight) ->
                        [{Weight, GradeId}|Acc];
                    _ ->
                        [{100, GradeId}|Acc]
                end;
            _ ->
                Acc
        end
    end,
    WeightList = lists:foldl(Fun, [], PoolCfg),
    urand:list_rand_by_weight(WeightList, Length).

sort_pool(_, [], RarePool, NewAcc) ->
    NewAcc++RarePool;
sort_pool(_, NormalPool, [], NewAcc) ->
    NewAcc++NormalPool;
sort_pool(Dis, NormalPool, RarePool, Acc) ->
    if
        Dis > 1 ->
            RealDis = urand:list_rand([Dis, Dis+1, Dis-1]);
        true ->
            RealDis = urand:list_rand([Dis, Dis+1])
    end,

    Fun = fun
        (E , {NormalList, RareList, TemAcc}) when E == RealDis ->
            if
                RareList == [] ->
                    {[], [], TemAcc ++ NormalList};
                NormalList == [] ->
                    {[], [], TemAcc ++ RareList};
                true ->
                    [NH|T] = NormalList,[RH|T1] = RareList,
                    {T, T1, [NH, RH|TemAcc]}
            end;
        (_, {NormalList, RareList, TemAcc}) ->
            if
                NormalList == [] ->
                    {[], [], TemAcc ++ RareList};
                true ->
                    [NH|T] = NormalList,
                    {T, RareList, [NH|TemAcc]}
            end
    end,

    {NewNormalPool, NewRarePool, NewAcc} = lists:foldl(Fun, {NormalPool, RarePool, Acc}, lists:seq(1, RealDis)),
    sort_pool(Dis, NewNormalPool, NewRarePool, NewAcc).



get_normal_pool_total_weight(Type, SubType, Wave) ->
    NormalPoolCfg = data_bonus_draw:get_pool(Type, SubType, Wave, ?UNRARE),
    Fun = fun(GradeId, Sum) ->
        case data_bonus_draw:get_bonus_grade(Type, SubType, Wave, GradeId) of
            #base_draw_pool{conditions = Conditions} ->
                case lists:keyfind(draw, 1, Conditions) of
                    {_, Weight} when is_integer(Weight) ->
                        Weight+Sum;
                    _ ->
                        Sum
                end;
            _ ->
                Sum
        end
    end,
    lists:foldl(Fun, 0, NormalPoolCfg).

%% 抽中普通奖励要从普通奖池随机出一件
calc_normal_reward(Type,SubType,Wave,AllTimes) ->
    NormalPoolCfg = data_bonus_draw:get_pool(Type,SubType,Wave,?UNRARE),
    Fun = fun(TemGradeId, Acc) ->
        case data_bonus_draw:get_bonus_grade(Type, SubType, Wave, TemGradeId) of
            #base_draw_pool{conditions = Conditions} ->
                case lists:keyfind(draw, 1, Conditions) of
                    {_, {Min, Max, NormalWeight, AddWeight}} ->
                        if
                            Min == 1 andalso Max == 1 ->
                                [{NormalWeight, TemGradeId}|Acc];
                            Min =< AllTimes andalso AllTimes =< Max ->
                                [{NormalWeight+AddWeight, TemGradeId}|Acc];
                            true ->
                                [{NormalWeight, TemGradeId}|Acc]
                        end;
                    {_, Weight} when is_integer(Weight) ->
                        [{Weight, TemGradeId}|Acc];
                    _ ->
                        [{100, TemGradeId}|Acc]
                end;
            _ ->
                Acc
        end
    end,
    NormalPool = lists:foldl(Fun, [], NormalPoolCfg),
    GradeId = urand:rand_with_weight(NormalPool),
    data_bonus_draw:get_bonus_grade(Type, SubType, Wave, GradeId).


get_bonus(Player, Type, SubType, Times, AutoBuy) when Type =:= ?CUSTOM_ACT_TYPE_DRAW_REWARD ->
    #player_status{sid = Sid, id = _RoleId, draw_reward = #draw_reward_status{act_data = ActData}} = Player,
    case maps:get({Type, SubType}, ActData, []) of
        #draw_data{wave = Wave, pool = Pool, today_draw_times = TodayDrawTimes, stage_reward = StageState} = DrawData ->
            case check_times(Times, Wave, Pool, StageState, Type, SubType) of
                true ->
                    CostList = get_cost(Times, TodayDrawTimes, []),
                    About = [Type, SubType, Times],
                    ConsumeType = get_consume_type(Type),
                    Res = if
                        AutoBuy == 1 ->
                            lib_goods_api:cost_objects_with_auto_buy(Player, CostList, ConsumeType, About);
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
                                {true, TmpNewPlayer} ->
                                    {true, TmpNewPlayer, CostList};
                                Other ->
                                    Other
                            end
                    end,
                    case Res of
                        {true, NewPlayer, Cost} ->
                            {ok, NewPS, GradeCfgList, AllTimes, NewWave} = do_get_bonus(NewPlayer, Type, SubType, Cost, Times, AutoBuy, DrawData),
                            SendList = construct_reward_list_for_client(Player, Type, SubType, GradeCfgList),
                            lib_server_send:send_to_sid(Sid, pt_331, 33167, [?SUCCESS, Type, SubType, AllTimes, TodayDrawTimes+Times, SendList]),
                            if
                                Wave =/= NewWave ->
                                    send_info(NewPS, Type, SubType);
                                true ->
                                    skip
                            end,
                            {ok, NewPS};
                        {false, Error, NewPlayer} ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33167, [Error, Type, SubType, 0, TodayDrawTimes, []]),
                            {ok, NewPlayer}
                    end;
                {false, Code} ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33167, [Code, Type, SubType, 0, 0, []])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33167, [?ERRCODE(err331_error_data), Type, SubType, 0, 0, []])
    end;
get_bonus(Player, _, _, _, _) ->{ok, Player}.

do_get_bonus(Player, Type, SubType, CostList, Times, _AutoBuy, DrawData) ->
    #player_status{id = RoleId, figure = #figure{name = RealRoleName}, draw_reward = #draw_reward_status{act_data = ActData}} = Player,
    #draw_data{wave = Wave, pool = Pool, draw_times = DrawTimes, today_draw_times = TodayDrawTimes, stage_reward = StageState} = DrawData,
    RoleName = lib_player:get_wrap_role_name(Player),
    case calc_pool(Pool, Wave, Type, SubType) of
        {true, NewPool1, NewWave1} -> skip;
        _ -> NewPool1 = Pool, NewWave1 = Wave
    end,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    SpecialLength = get_conditions(special, ActConditions),
    TotalWeight = get_normal_pool_total_weight(Type, SubType, Wave),
    {NewAllTimes,GradeCfgList,NewWave,NewPool}=do_get_bonus_help(RoleId, DrawTimes, NewPool1, NewWave1, Type, SubType, Times, [], TotalWeight, SpecialLength),
    NewStageState = calc_stage_state(Type, SubType, NewAllTimes, StageState),

    Rewards = handle_reward(GradeCfgList, Type, SubType, [], RoleName, RoleId), %%传闻处理
    % ?PRINT(Wave =/= NewWave,"&&&&&&&&&&&&&********* Wave:~p,NewWave:~p,NewPool:~p~n",[Wave,NewWave,NewPool]),
    NewDrawData = DrawData#draw_data{wave = NewWave, pool = NewPool, draw_times = NewAllTimes, today_draw_times = TodayDrawTimes+Times,
        stage_reward = NewStageState, utime = utime:unixtime()},

    replace_db_data(RoleId, NewDrawData),
    NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
    NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}},

    ProduceType = get_produce_type(Type),
    Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    NewPlayer1 = lib_goods_api:send_reward(NewPlayer, Produce),
    %% 日志
    lib_log_api:log_custom_act_reward(NewPlayer1, Type, SubType, 0, Rewards),
    lib_log_api:log_bonus_draw(Type, SubType, RoleId, RealRoleName, NewWave, NewAllTimes, CostList, ?DRAW_REWARD_NORMAL, Rewards),

    {ok, NewPlayer1, GradeCfgList, NewAllTimes, NewWave}.


do_get_bonus_help(_RoleId, AllTimes, Pool, Wave, _Type, _SubType, 0, GradeList, _TotalWeight, _SpecialLength) ->
    {AllTimes,GradeList,Wave,Pool};
do_get_bonus_help(RoleId, AllTimes, Pool, Wave, Type, SubType, Times, GradeList, TotalWeight, SpecialLength) ->

    RealPool = do_draw_core(Pool, Wave, Type, SubType, AllTimes+1, TotalWeight, SpecialLength),
    {GradeCfg, Sortid} = urand:rand_with_weight(RealPool),
    NewGradeCfg = case GradeCfg of
        #base_draw_pool{rare = ?RARE} ->
            GradeCfg;
        _ ->
            calc_normal_reward(Type,SubType,Wave,AllTimes)
    end,
    {NewWave, NewPool} = calc_pool(GradeCfg, Pool, Wave, Type, SubType),
    do_get_bonus_help(RoleId, AllTimes + 1, NewPool, NewWave, Type, SubType, Times-1, [{NewGradeCfg, Sortid}|GradeList], TotalWeight, SpecialLength).

%% 奖池，{StartTimes, EndTimes, Weight, SpecialWeight} 在StartTimes 与 EndTimes 之间权重增加（Weight+SpecialWeight）
%% 若抽奖次数没达到StartTimes,该大奖不会入奖池， 抽奖次数大于EndTimes使用Weight来抽奖
do_draw_core(Pool, Wave, Type, SubType, AllTimes, TotalWeight, SpecialLength) ->
    Fun = fun({GradeId, Sortid, ?HAVE}, Acc) ->
        case data_bonus_draw:get_bonus_grade(Type, SubType, Wave, GradeId) of
            #base_draw_pool{conditions = Conditions, rare = ?RARE} = GradeCfg ->
                case lists:keyfind(draw, 1, Conditions) of
                    {_, {Min, Max, NormalWeight, AddWeight}} ->
                        if
                            Min == 1 andalso Max == 1 ->
                                [{NormalWeight, {GradeCfg, Sortid}}|Acc];
                            Min =< AllTimes andalso AllTimes =< Max ->
                                [{NormalWeight+AddWeight, {GradeCfg, Sortid}}|Acc];
                            true ->
                                [{NormalWeight, {GradeCfg, Sortid}}|Acc]
                        end;
                    {_, Weight} when is_integer(Weight) ->
                        [{Weight, {GradeCfg, Sortid}}|Acc];
                    _ ->
                        [{100, {GradeCfg, Sortid}}|Acc]
                end;
            #base_draw_pool{rare = ?UNRARE} = GradeCfg ->
                [{TotalWeight div SpecialLength, {GradeCfg, Sortid}}|Acc];
            _ ->
                Acc
        end;
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, [], Pool).

check_times(Times, Wave, Pool, StageState, Type, SubType) when Times == 1 ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            UnrecieveStageNum = calc_stage_unrecieve_num(StageState),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            WaveCfg = get_conditions(wave, Conditions),
            Fun = fun({_, _, ?HAVE}, Sum) ->
                        Sum+1;
                    (_, Sum) -> Sum
                end,
            Reset = lists:foldl(Fun, 0, Pool),
            if
                UnrecieveStageNum > 0 ->
                    {false, ?ERRCODE(err181_stage_reward_unrecieve)};
                Wave < WaveCfg ->
                    true;
                true ->
                    if
                        Reset >= Times andalso Wave =:= WaveCfg ->
                            true;
                        true ->
                            {false, ?ERRCODE(err331_reset_times_not_enougth)}
                    end
            end;
        false ->
            {false, ?ERRCODE(err331_act_closed)}
    end;
check_times(_,_,_,_,_,_) -> {false, ?ERRCODE(err331_error_data)}.

calc_pool([], Wave, Type, SubType) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    WaveCfg = get_conditions(wave, Conditions),
    if
        Wave < WaveCfg ->
            NewWave = Wave + 1,
            NewPool = calc_default_pool(Type, SubType, Conditions, NewWave);
        true ->
            NewWave = WaveCfg + 1,
            NewPool = calc_default_pool(Type, SubType, Conditions, WaveCfg)
    end,
    {true, NewPool, NewWave};
calc_pool([{_, _, State}|T], Wave, Type, SubType) ->
    if
        State == ?HAVE ->
            true;
        true ->
            calc_pool(T, Wave, Type, SubType)
    end.

calc_pool(GradeCfg, Pool, Wave, Type, SubType) ->
    #base_draw_pool{grade = GradeId} = GradeCfg,
    NewPool = case lists:keyfind(GradeId, 1, Pool) of
        {_, Sortid, _} ->lists:keystore(GradeId, 1, Pool, {GradeId, Sortid, ?NULL});
        _ -> Pool
    end,
    case calc_pool(NewPool, Wave, Type, SubType) of
        {true, NewPool1, NewWave} ->skip;
        _ -> NewPool1 = NewPool,NewWave = Wave
    end,
    {NewWave, NewPool1}.

calc_default_stage_state(Type, SubType, AllTimes) ->
    StageList = data_bonus_draw:get_all_stage(Type, SubType),
    Fun = fun(Stage, Acc) ->
        GradeIdList = data_bonus_draw:get_all_grade(Type, SubType, Stage),
        GradeList = lists:sort(GradeIdList),
        calc_default_stage_state_helper(Type, SubType, Stage, GradeList, Acc, AllTimes)
    end,
    lists:foldl(Fun, [], StageList).

calc_default_stage_state_helper(_Type, _SubType, _Stage, [], Acc, _AllTimes) -> Acc;
calc_default_stage_state_helper(Type, SubType, Stage, [GradeId|T], Acc, AllTimes) ->
    case lists:keyfind({Stage, GradeId}, 1, Acc) of
        {_, _, _} -> skip;
        _ ->
            case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId) of
                #base_draw_stage_reward{condition = Conditions} ->skip;
                _ -> Conditions = []
            end,
            case lists:keyfind(total, 1, Conditions) of
                {_, LimitTimes} when AllTimes >= LimitTimes ->
                    NewAcc = lists:keystore({Stage, GradeId}, 1, Acc, {{Stage, GradeId}, ?HAS_ACHIEVE, ?NOT_BUY}),
                    calc_default_stage_state_helper(Type, SubType, Stage, T, NewAcc, AllTimes);
                {_, _} ->
                    NewAcc = lists:keystore({Stage, GradeId}, 1, Acc, {{Stage, GradeId}, ?NOT_ACHIEVE, ?NOT_BUY}),
                    calc_default_stage_state_helper(Type, SubType, Stage, T, NewAcc, AllTimes);
                _ ->
                    Acc
            end
    end.

calc_stage_state(Type, SubType, AllTimes, StageState) ->
    % StageList = data_bonus_draw:get_all_stage(Type, SubType),
    % Fun = fun(Stage, Acc) ->
    %     GradeIdList = data_bonus_draw:get_all_grade(Type, SubType, Stage),
    %     GradeList = lists:sort(GradeIdList),
        calc_stage_state_helper(Type, SubType, StageState, AllTimes, StageState).
    % end,
    % lists:foldl(Fun, StageState, StageState).

calc_stage_state_helper(_Type, _SubType, [], _AllTimes, Acc) ->Acc;
calc_stage_state_helper(Type, SubType, [{{Stage, GradeId}, StageRewardS, _}|T], AllTimes, Acc) ->
    case StageRewardS of
        ?NOT_ACHIEVE ->
            case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId) of
                #base_draw_stage_reward{condition = Conditions} ->skip;
                _ -> Conditions = []
            end,
            case lists:keyfind(total, 1, Conditions) of
                {_, LimitTimes} when AllTimes >= LimitTimes ->
                    NewAcc = lists:keystore({Stage, GradeId}, 1, Acc, {{Stage, GradeId}, ?HAS_ACHIEVE, ?NOT_BUY}),
                    calc_stage_state_helper(Type, SubType, T, AllTimes, NewAcc);
                _ ->
                    calc_stage_state_helper(Type, SubType, T, AllTimes, Acc)
            end;
        _ ->
            calc_stage_state_helper(Type, SubType, T, AllTimes, Acc)
    end.

stage_reward_get(Player, Type, SubType, Stage, GradeId, BuyType) when BuyType == ?RECIEVE_STAGE_REWARD ->
    #player_status{id = RoleId, sid = Sid, figure = #figure{name = RoleName}, draw_reward = #draw_reward_status{act_data = ActData}} = Player,
    case maps:get({Type, SubType}, ActData, []) of
        #draw_data{wave = Wave, draw_times = DrawTimes, stage_reward = StageState} = DrawData ->
            case lists:keyfind({Stage, GradeId}, 1, StageState) of
                {_, ?HAS_ACHIEVE, BuyState} ->
                    case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId) of
                        #base_draw_stage_reward{reward = RewardCfg, reward_type = RewardType} ->
                            Reward = calc_reward(Type, SubType, RewardType, RewardCfg),
                            %% 日志
                            lib_log_api:log_custom_act_reward(Player, Type, SubType, GradeId, Reward),
                            lib_log_api:log_bonus_draw(Type, SubType, RoleId, RoleName, Wave, DrawTimes, [], ?STAGE_REWARD_NORMAL, Reward),

                            NewStageState = lists:keystore({Stage, GradeId}, 1, StageState, {{Stage, GradeId}, ?HAS_RECIEVE, BuyState}),
                            NewDrawData = DrawData#draw_data{stage_reward = NewStageState, utime = utime:unixtime()},
                            replace_db_data(RoleId, NewDrawData),
                            NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                            NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}},

                            ProduceType = get_produce_type(Type),
                            Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                            NewPlayer1 = lib_goods_api:send_reward(NewPlayer, Produce),
                            lib_server_send:send_to_sid(Sid, pt_331, 33166, [1, Type, SubType, Stage, GradeId, Reward, BuyType]),
                            {ok, NewPlayer1};
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(missing_config), Type, SubType, Stage, GradeId, [], BuyType])
                    end;
                {_, ?HAS_RECIEVE, _} ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_has_recieve), Type, SubType, Stage, GradeId, [], BuyType]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_draw_times_limit), Type, SubType, Stage, GradeId, [], BuyType])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_error_data), Type, SubType, Stage, GradeId, [], BuyType])
    end;
stage_reward_get(Player, Type, SubType, Stage, GradeId, BuyType) when BuyType == ?BUY_STAGE_REWARD ->
    #player_status{id = RoleId, sid = Sid, figure = #figure{name = RoleName}, draw_reward = #draw_reward_status{act_data = ActData}} = Player,
    case maps:get({Type, SubType}, ActData, []) of
        #draw_data{wave = Wave, draw_times = DrawTimes, stage_reward = StageState} = DrawData ->
            case lists:keyfind({Stage, GradeId}, 1, StageState) of
                {_, State, ?NOT_BUY} when State == ?HAS_ACHIEVE orelse State == ?HAS_RECIEVE ->
                    case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId) of
                        #base_draw_stage_reward{reward = RewardCfg, dis_reward = DisRewardCfg, discount = CostCfg, reward_type = RewardType} ->
                            if
                                DisRewardCfg == [] ->
                                    lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_reward_cfg_is_null), Type, SubType, Stage, GradeId, [], BuyType]);
                                true ->
                                    DisReward = calc_reward(Type, SubType, RewardType, DisRewardCfg),
                                    Cost = calc_reward(Type, SubType, RewardType, CostCfg),
                                    About = [Type, SubType, GradeId],
                                    ConsumeType = get_consume_type(Type),
                                    case lib_goods_api:cost_object_list_with_check(Player, Cost, ConsumeType, About) of
                                        {true, TmpNewPlayer} ->
                                            if
                                                State == ?HAS_ACHIEVE ->
                                                    StageReward = calc_reward(Type, SubType, RewardType, RewardCfg),
                                                    LogType = ?STAGE_REWARD_BUY_AND_RECIEVE,
                                                    Reward = DisReward++StageReward;
                                                true ->
                                                    LogType = ?STAGE_REWARD_BUY,
                                                    Reward = DisReward
                                            end,
                                            %% 日志
                                            lib_log_api:log_custom_act_reward(TmpNewPlayer, Type, SubType, GradeId, Reward),
                                            lib_log_api:log_bonus_draw(Type, SubType, RoleId, RoleName, Wave, DrawTimes, Cost, LogType, Reward),

                                            NewStageState = lists:keystore({Stage, GradeId}, 1, StageState, {{Stage, GradeId}, ?HAS_RECIEVE, ?HAS_BUY}),
                                            NewDrawData = DrawData#draw_data{stage_reward = NewStageState, utime = utime:unixtime()},
                                            replace_db_data(RoleId, NewDrawData),
                                            NewActData = maps:put({Type, SubType}, NewDrawData, ActData),
                                            NewPlayer = TmpNewPlayer#player_status{draw_reward = #draw_reward_status{act_data = NewActData}},

                                            ProduceType = get_produce_type(Type),
                                            Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                            NewPlayer1 = lib_goods_api:send_reward(NewPlayer, Produce),
                                            lib_server_send:send_to_sid(Sid, pt_331, 33166, [1, Type, SubType, Stage, GradeId, Reward, BuyType]),
                                            {ok, NewPlayer1};
                                        {false, Code, TmpNewPlayer} ->
                                            lib_server_send:send_to_sid(Sid, pt_331, 33166, [Code, Type, SubType, Stage, GradeId, [], BuyType]),
                                            {ok,TmpNewPlayer}
                                    end
                            end;
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(missing_config), Type, SubType, Stage, GradeId, [], BuyType])
                    end;
                {_, _, ?HAS_BUY} ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_has_buy), Type, SubType, Stage, GradeId, [], BuyType]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_draw_times_limit), Type, SubType, Stage, GradeId, [], BuyType])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33166, [?ERRCODE(err331_error_data), Type, SubType, Stage, GradeId, [], BuyType])
    end;
stage_reward_get(Player, _, _, _, _, _) -> {ok, Player}.

midnight_update(Type, SubType, ClearType) ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_draw, midnight_update_helper, [Type, SubType]) || E <- OnlineRoles];
        true ->
            skip
    end.

midnight_update_helper(Player, Type, SubType) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName}, draw_reward = DrawReward} = Player,
    case DrawReward of
        #draw_reward_status{act_data = ActData} ->
            case maps:get({Type, SubType}, ActData, []) of
                #draw_data{wave = Wave, pool = Pool, draw_times = DrawTimes, today_draw_times = TodayDrawTimes,
                stage_reward = StageState, utime = Utime} = OldDrawData ->
                    ActArgs = [Wave, Pool, DrawTimes, TodayDrawTimes, StageState, Utime],
                    #custom_act_cfg{condition = Conditions, clear_type = ClearType} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                    Clear = get_conditions(clear, Conditions),
                    {NewWave, NewPool, NewDrawTimes, NewTodayDrawTimes, NewStageState, NewUtime} =
                        clear_act_core(RoleId, RoleName, Type, SubType, ClearType, Clear, ActArgs),
                    DrawData = OldDrawData#draw_data{
                        wave = NewWave, pool = NewPool, draw_times = NewDrawTimes,
                        today_draw_times = NewTodayDrawTimes, stage_reward = NewStageState,
                        utime = NewUtime
                    },
                    NewActData = maps:put({Type, SubType}, DrawData, ActData),
                    NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}};
                _ ->
                    case init_data_helper(Type, SubType, RoleLv, RoleId, RoleName) of
                        DrawData when is_record(DrawData, draw_data) ->
                            NewActData = maps:put({Type, SubType}, DrawData, ActData),
                            NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}};
                        _ ->
                            NewPlayer = Player
                    end
            end,
            send_info(NewPlayer, Type, SubType),
            {ok, NewPlayer};
        _ ->
            {ok, Player}
    end.




act_end(Type,SubType) ->
    List = db:get_all(io_lib:format(?SQL_SELECT_ALL, [Type, SubType])),
    Fun = fun([RoleId, Wave, DrawTimes, StageS]) ->
        StageState = util:bitstring_to_term(StageS),
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_bonus_draw, act_end_helper,
                [Type, SubType, Wave, DrawTimes, StageState])
    end,
    lists:foreach(Fun, List),
    db:execute(io_lib:format(<<"DELETE FROM `bonus_draw_role` WHERE `type` = ~p and `subtype` = ~p">>, [Type, SubType])).

act_end_helper(Player, Type, SubType, Wave, DrawTimes, StageState) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, draw_reward = DrawReward} = Player,
    case DrawReward of
        #draw_reward_status{act_data = ActData} ->
            NewActData = maps:remove({Type, SubType}, ActData),
            NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}},
            send_reward_data_clear(Type, SubType, RoleId, RoleName, DrawTimes, Wave, StageState, []),
            send_info(NewPlayer, Type, SubType),
            {ok, NewPlayer};
        _ ->
            send_reward_data_clear(Type, SubType, RoleId, RoleName, DrawTimes, Wave, StageState, []),
            {ok, Player}
    end.

send_reward_data_clear(Type, SubType, RoleId, RoleName, DrawTimes, Wave, StageState, []) ->
    F1 = fun({{Stage, GradeId}, ?HAS_ACHIEVE, _S}, {Acc, Acc1}) ->
        case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId) of
            #base_draw_stage_reward{reward = RewardCfg, reward_type = RewardType} ->
                Reward = calc_reward(Type, SubType, RewardType, RewardCfg),
                %% 日志
                lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
                lib_log_api:log_bonus_draw(Type, SubType, RoleId, RoleName, Wave, DrawTimes, [], ?STAGE_REWARD_NORMAL, Reward),
                {Reward ++ Acc, [{{Stage, GradeId}, ?HAS_RECIEVE, _S}|Acc1]};
            _ -> {Acc, Acc1}
        end;
        ({{Stage, GradeId}, State, _S}, {Acc, Acc1}) ->
            {Acc, [{{Stage, GradeId}, State, _S}|Acc1]};
        (_, Acc) -> Acc
    end,
    {Rewards, NewStageState} = lists:foldl(F1, {[], []}, StageState),
    {Title, Content} = get_mail_info(Type),
    if
        Rewards =/= [] ->
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards);
        true ->
            skip
    end,
    NewStageState;

send_reward_data_clear(_, _, _, _, _,_,StageState,_) -> StageState.

get_mail_info(Type) ->
    case Type of
        ?CUSTOM_ACT_TYPE_DRAW_REWARD -> Title = utext:get(3310050),Content = utext:get(3310051);
        _ -> Title = utext:get(3310042), Content = utext:get(3310043)
    end,
    {Title, Content}.

get_cost(0, _, Cost) -> Cost;
get_cost(Times, AllTimes, Cost) ->
    case data_bonus_draw:get_draw_cost(AllTimes+1) of
        [{_,_,Num}|_] = CostList when Num =/= 0 ->NewCost = Cost++CostList;
        _ -> NewCost = Cost
    end,
    get_cost(Times-1, AllTimes+1, NewCost).

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

handle_reward([], _Type, _SubType, Rewards, _RoleName, _RoleId) -> Rewards;
handle_reward([{GradeCfg, _}|GradeCfgList], Type, SubType, Rewards, RoleName, RoleId) ->
    #base_draw_pool{reward_type = RewardType, reward = RewardCfg, tv = TvList} = GradeCfg,
    Reward = calc_reward(Type, SubType, RewardType, RewardCfg),
    case Reward of
        [{Gtype, GoodsTypeId, _}|_] ->
            case TvList of
                [{ModuleId, Id}|_] ->
                    % mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
                    RGtypeid = get_real_goodstypeid(GoodsTypeId, Gtype),
                    lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, RGtypeid, Type, SubType]);
                _ ->
                    skip
            end,
            handle_reward(GradeCfgList, Type, SubType, Reward++Rewards, RoleName, RoleId);
        _ ->
            handle_reward(GradeCfgList, Type, SubType, Rewards, RoleName, RoleId)
    end.

calc_reward(_Type, _SubType, RewardType, RewardCfg) when RewardType == ?REWARD_TYPE_NORMAL_D ->
    RewardCfg;
calc_reward(Type, SubType, RewardType, RewardCfg) when RewardType == ?REWARD_TYPE_WORLDLV_D ->
    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    #act_info{wlv = WLv} = ActInfo,
    SortL = lists:keysort(1, RewardCfg),
    filter_reward(RewardType, SortL, WLv, []);
calc_reward(_, _, _, _) -> [].

construct_reward_list_for_client(_Player, Type, SubType, GradeCfgList) ->
    Fun = fun({GradeCfg, Sortid}, Acc) ->
        #base_draw_pool{grade = GradeId, rare = Rare, reward_type = RewardType, reward = RewardCfg} = GradeCfg,
        Reward = calc_reward(Type, SubType, RewardType, RewardCfg),
        [{GradeId, Rare, Reward, Sortid}|Acc]
    end,
    lists:foldl(Fun, [], GradeCfgList).

filter_reward(?REWARD_FORMAT_TYPE_WLV = Type, [{LimLv, T}|L], WLv, CurReward) ->
    case WLv >= LimLv of
        true ->
            filter_reward(Type, L, WLv, T);
        false -> CurReward
    end;
filter_reward(_, _, _, CurReward) -> CurReward.

check_role_lv(Type, SubType, RoleLv) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    LimitLv = get_conditions(role_lv, Conditions),
    if
        RoleLv >= LimitLv ->
            true;
        true ->
            {false, ?ERRCODE(err331_lv_not_enougth)}
    end.

init_data_lv_up(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, draw_reward = DrawReward} = Player,
    case DrawReward of
        #draw_reward_status{act_data = ActData} ->skip;
        _ ->
            ActData = #{}
    end,
    TypeList = [?CUSTOM_ACT_TYPE_DRAW_REWARD],
    Fun = fun(Type, TemMap) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, TemMap1) ->
            case maps:get({Type, SubType}, TemMap1, []) of
                #draw_data{} -> TemMap1;
                _ ->
                    case init_data_lv_up_helper(RoleId, Type, SubType, RoleLv) of
                        DrawData when is_record(DrawData, draw_data) ->
                            maps:put({Type, SubType}, DrawData, TemMap1);
                        _ ->
                            TemMap1
                    end
            end
        end,
        lists:foldl(Fun2, TemMap, SubTypes)
    end,
    NewActData = lists:foldl(Fun, ActData, TypeList),
    NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = NewActData}},
    % send_info(NewPlayer, Type, SubType),
    NewPlayer.

init_data_lv_up_helper(RoleId, Type, SubType, RoleLv) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    LimitLv = get_conditions(role_lv, Conditions),
    WaveCfg = get_conditions(wave, Conditions),
    if
        RoleLv == LimitLv ->
            if
                is_integer(WaveCfg) andalso WaveCfg >= 0 ->
                    RealWave = 1;
                true ->
                    RealWave = 0
            end,
            % ?PRINT("@@@@ Pool:~p~n",[calc_default_pool(Type, SubType, Conditions, RealWave)]),
            DrawData = #draw_data{
                            key = {Type, SubType},
                            wave = RealWave,
                            pool = calc_default_pool(Type, SubType, Conditions, RealWave),
                            draw_times = 0,
                            today_draw_times = 0,
                            stage_reward = calc_default_stage_state(Type, SubType, 0),
                            utime = 0},
            replace_db_data(RoleId, DrawData);
        true -> DrawData = []
    end,
    DrawData.

%% 获得产出类型
get_produce_type(?CUSTOM_ACT_TYPE_DRAW_REWARD) -> draw_reward_special;
get_produce_type(_) -> unkown.

%% 获得消耗类型
get_consume_type(?CUSTOM_ACT_TYPE_DRAW_REWARD) -> draw_reward_special;
get_consume_type(_) -> unkown.

gm_reset_bonus_draw(Player) ->
    #player_status{id = RoleId} = Player,
    TypeList = [?CUSTOM_ACT_TYPE_DRAW_REWARD],
    Fun = fun(Type, TemMap) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, TemMap1) ->
            case gm_reset_bonus_draw_helper(Type, SubType, RoleId) of
                DrawData when is_record(DrawData, draw_data) ->
                    maps:put({Type, SubType}, DrawData, TemMap1);
                _ ->
                    TemMap1
            end
        end,
        lists:foldl(Fun2, TemMap, SubTypes)
    end,
    ActData = lists:foldl(Fun, #{}, TypeList),
    NewPlayer = Player#player_status{draw_reward = #draw_reward_status{act_data = ActData}},
    % send_info(NewPlayer, Type, SubType),
    NewPlayer.

gm_reset_bonus_draw_helper(Type, SubType, RoleId) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    WaveCfg = get_conditions(wave, Conditions),
    if
        is_integer(WaveCfg) andalso WaveCfg >= 0 ->
            RealWave = 1;
        true ->
            RealWave = 0
    end,
    % ?PRINT("@@@@ Pool:~p~n",[calc_default_pool(Type, SubType, Conditions, RealWave)]),
    Pool = calc_default_pool(Type, SubType, Conditions, RealWave),
    StageState = calc_default_stage_state(Type, SubType, 0),
    DrawData = #draw_data{
                    key = {Type, SubType},
                    wave = RealWave,
                    pool = Pool,
                    draw_times = 0,
                    today_draw_times = 0,
                    stage_reward = StageState,
                    utime = 0},
    replace_db_data(RoleId, DrawData),
    {SendPool, SendStage} = package_data(Type, SubType, RealWave, Pool, StageState),
    % ?PRINT("Length:~p,SendPool:~p~n",[erlang:length(SendPool),SendPool]),
    lib_server_send:send_to_uid(RoleId, pt_331, 33165, [Type, SubType, RealWave, 0, 0, SendPool, SendStage]),
    DrawData.

package_data(Type, SubType, Wave, Pool, StageState) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    WaveCfg = get_conditions(wave, Conditions),
    Fun1 = fun({GradeId, Sortid, State}, Acc) ->
        if
            Wave > WaveCfg ->
                NewWave = WaveCfg;
            true ->
                NewWave = Wave
        end,
        case data_bonus_draw:get_bonus_grade(Type, SubType, NewWave, GradeId) of
            #base_draw_pool{rare = Rare, reward_type = RewardType, reward = RewardCfg} ->
                Reward = calc_reward(Type, SubType, RewardType, RewardCfg),
                [{Reward, GradeId, Rare, Sortid, State}|Acc];
            _ -> Acc
        end
    end,
    SendPool = lists:foldl(Fun1, [], Pool),
    Fun2 = fun({{Stage, GradeId1}, RecieveState, BuyState}, TAcc) ->
        case lists:keyfind(Stage, 1, TAcc) of
            {Stage, GradeState} -> skip;
            _ -> GradeState = []
        end,
        case data_bonus_draw:get_stage_reward_cfg(Type, SubType, Stage, GradeId1) of
            #base_draw_stage_reward{dis_reward = DisRewardCfg, reward = RewardCfg1, reward_type = RewardType} ->
                BuyReward = calc_reward(Type, SubType, RewardType, DisRewardCfg),
                StageReward = calc_reward(Type, SubType, RewardType, RewardCfg1);
            _ ->
                BuyReward = [],StageReward = []
        end,
        NewGradeState = lists:keystore(GradeId1,1,GradeState, {GradeId1, StageReward, BuyReward, RecieveState, BuyState}),
        lists:keystore(Stage, 1, TAcc, {Stage, lists:keysort(1, NewGradeState)})
    end,
    SendStage0 = lists:foldl(Fun2, [], StageState),
    SendStage = lists:keysort(1, SendStage0),
    {SendPool, SendStage}.

gm_set_wave(Player, Type, SubType, Wave) ->
    #player_status{id = RoleId, draw_reward = #draw_reward_status{act_data = ActData}} = Player,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    WaveCfg = get_conditions(wave, Conditions),
    if
        is_integer(WaveCfg) andalso WaveCfg >= Wave ->
            RealWave = Wave;
        true ->
            RealWave = WaveCfg
    end,
    NormalLength = get_conditions(normal, Conditions),
    SpecialLength = get_conditions(special, Conditions),
    StageState = calc_default_stage_state(Type, SubType, 0),
    Pool = calc_default_pool(Type, SubType, Conditions, RealWave),
    NewDrawData = #draw_data{
            key = {Type, SubType},
            wave = Wave + 1,
            pool = Pool,
            draw_times = Wave *(NormalLength+SpecialLength),
            today_draw_times = Wave *(NormalLength+SpecialLength),
            stage_reward = StageState,
            utime = utime:unixtime()},
    NewMap = maps:put({Type, SubType}, NewDrawData, ActData),
    {SendPool, SendStage} = package_data(Type, SubType, RealWave, Pool, StageState),
    lib_server_send:send_to_uid(RoleId, pt_331, 33165, [Type, SubType, RealWave, Wave *(NormalLength+SpecialLength),
            Wave *(NormalLength+SpecialLength), SendPool, SendStage]),
    replace_db_data(RoleId, NewDrawData),
    Player#player_status{draw_reward = #draw_reward_status{act_data = NewMap}}.

%% 计算出完成当前阶段时,未领取的奖励个数(未完成当前阶段时，返回0)
calc_stage_unrecieve_num(StageState) ->
    CurList = [Stage || {{Stage, _}, GradeState ,_} <- StageState, GradeState == ?HAS_ACHIEVE orelse GradeState == ?HAS_RECIEVE],
    CurStage = ?IF(CurList == [], 0, lists:max(CurList)),
    StageList = [State || {{Stage, _}, _, _} = State <- StageState, Stage == CurStage],
    StageLen = length(StageList),
    AchievedLen = length([State || {_, GradeState, _} = State <- StageList, GradeState == ?HAS_ACHIEVE orelse GradeState == ?HAS_RECIEVE]),
    ReceivedLen = length([State || {_, ?HAS_RECIEVE, _} = State <- StageList]),
    case StageLen == AchievedLen andalso AchievedLen /= ReceivedLen of
        true -> AchievedLen - ReceivedLen;
        false -> 0
    end.

% calc_stage_unrecieve_num([], Sum) ->Sum;
% calc_stage_unrecieve_num([{_, ?HAS_ACHIEVE, _}|T], Sum) ->
%     calc_stage_unrecieve_num(T, Sum+1);
% calc_stage_unrecieve_num([_|T], Sum) ->calc_stage_unrecieve_num(T, Sum).

%% 因不小心清了数据,要根据日志进行数据回填
gm_refill_data() ->
    Type = ?CUSTOM_ACT_TYPE_DRAW_REWARD,
    ActInfos = lib_custom_act_util:get_open_subtype_list(Type),
    AccList = gm_refill_data(ActInfos, #{}),
    Sql = usql:replace(bonus_draw_role,
        [role_id, type, subtype, wave, pool, draw_times, stage_state, today_times, utime], AccList),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    % 刷新在线玩家数据
    [[lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, gm_refill_data_refresh, [Type, SubType]) || Id <- lib_online:get_online_ids()]
        || #act_info{key = {_, SubType}} <- ActInfos].

%% @return [[RoleId, Type, SubType, Wave, PoolBin, DrawTimes, StageStateBin, TodayTimes, UTime]...]
gm_refill_data([], AccMap) ->
    F = fun({RoleId, Type, SubType}, RoleData, AccList) ->
        NewAccList = [[RoleId, Type, SubType|RoleData]|AccList],
        NewAccList
    end,
    maps:fold(F, [], AccMap);
gm_refill_data([ActInfo|T], AccMap) ->
    #act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
    Sql = io_lib:format(
        "select role_id, wave, draw_times, utime
        from log_bonus_draw
        where type=~p and subtype=~p and reward_type=~p and utime>~p and utime<~p", [Type, SubType, ?DRAW_REWARD_NORMAL, STime, ETime]),
    LogList = db:get_all(Sql),
    F = fun([RoleId, Wave, _DrawTimes, Time], AccM) ->
        case maps:get({RoleId, Type, SubType}, AccM, []) of
            [OWave, PoolBin, ODrawTimes, StageStateBin, TodayTimes, UTime] ->
                NWave = ?IF(Wave > OWave, Wave, OWave),
                #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                NPoolBin = ?IF(Wave > OWave, util:term_to_bitstring(calc_default_pool(Type, SubType, Conditions, Wave)), PoolBin),
                % NDrawTimes = ?IF(DrawTimes > ODrawTimes, DrawTimes, ODrawTimes),
                StageState = util:bitstring_to_term(StageStateBin),
                NStageStateBin = util:term_to_bitstring(calc_stage_state(Type, SubType, ODrawTimes+1, StageState)),
                NTodayTimes = ?IF(utime:is_today(Time), TodayTimes+1, TodayTimes),
                NData = [NWave, NPoolBin, ODrawTimes+1, NStageStateBin, NTodayTimes, UTime],
                NAccM = maps:put({RoleId, Type, SubType}, NData, AccM),
                NAccM;
            [] ->
                #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                Pool = calc_default_pool(Type, SubType, Conditions, Wave),
                PoolBin = util:term_to_bitstring(Pool),
                StageStateBin = util:term_to_bitstring(calc_default_stage_state(Type, SubType, 0)),
                TodayTimes = ?IF(utime:is_today(Time), 1, 0),
                UTime = utime:unixtime(),
                NData = [Wave, PoolBin, 1, StageStateBin, TodayTimes, UTime],
                NAccM = maps:put({RoleId, Type, SubType}, NData, AccM),
                NAccM
        end
    end,
    NewAccMap = lists:foldl(F, AccMap, LogList),
    gm_refill_data(T, NewAccMap).

%% 刷新在线玩家数据
gm_refill_data_refresh(PS, Type, SubType) ->
	NewPS = init_data(PS),
	pp_custom_act:handle(33165, NewPS, [Type, SubType]),
	{ok, NewPS}.