%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_monday
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-4-26
%% @Description:    周一大奖
%%-----------------------------------------------------------------------------
-module(lib_bonus_monday).

-include("bonus_monday.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("def_daily.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("daily.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

-export([
        draw_reward/2, 
        handle_event/2, 
        get_produce_type/1, 
        get_default_pool/0, 
        daily_timer/1, 
        daily_clear/2,
        send_info_midday/1
    ]).

draw_reward(Player, Mod)->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, server_name = ServerName, 
        figure = #figure{name = RoleName, picture = Picture, picture_ver = PictureVer, career = Creer, turn = Turn},
        monday_bonus = MondayBonus
    } = Player,
    #monday_bonus_data{record = PersonRecord, draw_times = DrawTimes, now_pool = Pool, task_state = TaskState} = MondayBonus,
    {RealPool, RewardPool} = get_real_pool(Pool, DrawTimes+1),
    if
        RewardPool =/= [] ->
            {Type, GoodsPool} = urand:rand_with_weight(RewardPool);
        true ->
            {Type, GoodsPool} = urand:rand_with_weight(RealPool)
    end,
    case data_monday_bonus:get_bonus_type(Type) of
        #base_monday_bonus{tv_id = TvList} ->skip;
        _ -> TvList = []
    end,
    % ?PRINT("DrawTimes:~p,RealPool:~w~n, RewardPool:~w~n",[DrawTimes+1, RealPool, RewardPool]),
    case urand:list_rand(GoodsPool) of
        GoodsPoolid when is_integer(GoodsPoolid) -> 
            case data_monday_bonus:get_reward(GoodsPoolid) of
                [{Gtype, GoodsTypeId, GoodsNum}] = Reward -> 
                    case data_monday_bonus:get_value(draw_cost) of
                        CostList when is_list(CostList) andalso CostList =/= [] ->
                            About = [],
                            ConsumeType = get_consume_type(Mod),
                            case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
                                {true, TmpNewPlayer} ->
                                    ProduceType = get_produce_type(Mod),
                                    Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                    NewPlayer = lib_goods_api:send_reward(TmpNewPlayer, Produce),
                                    %% 日志 
                                    lib_log_api:log_monday_draw(RoleId, RoleName, CostList, Reward, DrawTimes+1),
                                    Now = utime:unixtime(),
                                    case data_monday_bonus:get_value(kf_log_num) of
                                        LogNum when is_integer(LogNum) ->skip;
                                        _ -> LogNum = 20
                                    end,
                                    NewPersonLog = [{RoleId, RoleName, Type, GoodsPoolid, Now, Picture, PictureVer, Creer}|PersonRecord],
                                    RealPersonLog = lists:sublist(NewPersonLog, LogNum),
                                    NewMondayBonus = MondayBonus#monday_bonus_data{record = RealPersonLog, draw_times = DrawTimes + 1},
                                    db:execute(io_lib:format(?SQL_PERSON_INSERT, [RoleId, Type, GoodsPoolid, Now, Picture, PictureVer, Creer])),
                                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes + 1, 
                                        util:term_to_string(TaskState), util:term_to_string(Pool), Now])),
                                    lib_server_send:send_to_uid(RoleId, pt_179, 17903, [Type, GoodsPoolid, DrawTimes+1]),
                                    lib_server_send:send_to_uid(RoleId, pt_179, 17902, [[{RoleId, RoleName, Type, GoodsPoolid, Now, Picture, PictureVer, Creer}]]),
                                    handle_reward(Type, ServerId, ServerNum, ServerName, RoleId, RoleName, GoodsPoolid, 
                                            Now, TvList, GoodsTypeId, Gtype, Picture, PictureVer, Creer, Turn, GoodsNum),
                                    {ok, LastPlayer} = lib_grow_welfare_api:draw_bonus_monday(NewPlayer#player_status{monday_bonus = NewMondayBonus}, 1),
                                    {true, LastPlayer};
                                {false, ErrorCode, _PS} ->
                                    % ?PRINT("ErrorCode:~p~n",[ErrorCode]),
                                    lib_server_send:send_to_uid(RoleId, pt_179, 17900, [ErrorCode])
                            end;
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_miss_config)])
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_miss_config)])
            end;
        _ -> lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_pool_is_null)])
    end.

get_real_pool(Pool, DrawTimes) ->
    Fun = fun({Type, Goods}, {Acc, Acc1}) ->
        case data_monday_bonus:get_bonus_type(Type) of
            #base_monday_bonus{weight = Weight} ->
                case Weight of
                    Weight when is_integer(Weight) ->
                        {[{Weight, {Type, Goods}}|Acc], Acc1};
                    {NormalWeight, {SpecialWeight, RewardTimeList}} ->
                        case lists:member(DrawTimes, RewardTimeList) of
                            true -> {Acc, [{SpecialWeight, {Type, Goods}}|Acc1]};
                            _ ->
                                {[{NormalWeight, {Type, Goods}}|Acc], Acc1}
                        end;
                    {RoundTimes, TemWeight, SpecialWeight} ->
                        if
                            DrawTimes rem RoundTimes == 0 ->
                                if
                                    SpecialWeight == 0 ->
                                        {Acc, Acc1};
                                    true ->
                                        {[{SpecialWeight, {Type, Goods}}|Acc], Acc1}
                                end;
                            true ->
                                {[{TemWeight, {Type, Goods}}|Acc], Acc1}
                        end;
                    {Min, Max, TemWeight, SpecialWeight} ->
                        if
                            DrawTimes >= Min andalso DrawTimes =< Max ->
                                if
                                    SpecialWeight == 0 ->
                                        {Acc, Acc1};
                                    true ->
                                        {[{SpecialWeight, {Type, Goods}}|Acc], Acc1}
                                end;
                            true ->
                                {[{TemWeight, {Type, Goods}}|Acc], Acc1}
                        end;
                    {Min, Max, TemWeight, SpecialWeight, {RewardWeight, RewardTimeList}} ->
                        if
                            DrawTimes >= Min andalso DrawTimes =< Max ->
                                if
                                    SpecialWeight == 0 ->
                                        {Acc, Acc1};
                                    true ->
                                        {[{SpecialWeight, {Type, Goods}}|Acc], Acc1}
                                end;
                            true ->
                                case lists:member(DrawTimes, RewardTimeList) of
                                    true -> {Acc, [{RewardWeight, {Type, Goods}}|Acc1]};
                                    _ ->
                                        {[{TemWeight, {Type, Goods}}|Acc], Acc1}
                                end
                        end;
                    _E -> {Acc, Acc1}
                end;
            _ -> {Acc, Acc1}
        end
    end,
    lists:foldl(Fun, {[], []}, Pool).

handle_reward(Type, ServerId, ServerNum, ServerName, RoleId, RoleName, GoodsPoolid, Now, TvList, GoodsTypeId, Gtype, 
    Picture, PictureVer, Creer, Turn, GoodsNum) ->
    if
        TvList == [] ->
            skip;
        true ->
            OpenDay = util:get_open_day(),
            CfgOpenDay = data_monday_bonus:get_value(open_day),
            {Mod, TvId} = ?IF(OpenDay > CfgOpenDay, urand:list_rand(TvList), {?MOD_BONUS_MONDAY, 2}),
            mod_kf_draw_record:cast_center([{'save_draw_log', ?MOD_BONUS_MONDAY, ?MOD_BONUS_MONDAY_FIRST,
                            ServerId, ServerNum, ServerName, RoleId, RoleName, Type, GoodsPoolid, Now, Picture, PictureVer, Creer, Turn}]),
            RGtypeid = get_real_goodstypeid(GoodsTypeId, Gtype),
            lib_chat:send_TV({all}, Mod, TvId, [RoleName, RoleId, get_type_name(Type), RGtypeid, GoodsNum])
    end.

get_produce_type(Mod) when Mod == ?MOD_BONUS_MONDAY ->
    monday_draw;
get_produce_type(_) -> unkown.

get_consume_type(Mod) when Mod == ?MOD_BONUS_MONDAY ->
    monday_draw;
get_consume_type(_) -> unkown.

get_type_name(Type) ->
    if
        Type == 0 ->
            utext:get(1790001);
        Type == 1 ->
            utext:get(1790002);
        true -> 
            <<>>
    end.

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

do_login(Player) ->
    #player_status{last_login_time = LoginTime, 
        id = RoleId, monday_bonus = MondayBonus, figure = #figure{name = RoleName, lv = RoleLv}} = Player,
    case data_monday_bonus:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 0
    end,
    Now = utime:unixtime(),
    case MondayBonus of
        #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, task_state = TaskState, utime = TUtime} = NewMondayBonus -> skip;
        _S when RoleLv >= OpenLv ->
            SQL = io_lib:format(?SQL_SELECT_DATA, [RoleId]),
            List = db:get_row(SQL),
            case List of
                [DrawTimes, TaskStateL, PoolL, TUtime] ->
                    TaskState = util:bitstring_to_term(TaskStateL),
                    Pool = util:bitstring_to_term(PoolL);
                _ ->
                    TaskState = [],DrawTimes = 0, Pool = get_default_pool(), TUtime = 0
            end,
            List2 = db:get_all(io_lib:format(?SQL_PERSON_SELECT, [RoleId])),
            Fun = fun([_, Type, GoodsPoolid, Utime, Picture, PictureVer, Creer], Acc) ->
                [{RoleId, RoleName,Type,GoodsPoolid,Utime, Picture, PictureVer, Creer}|Acc]
            end,
            Record = lists:foldl(Fun, [], List2),
            case data_monday_bonus:get_value(kf_log_num) of
                LogNum when is_integer(LogNum) ->skip;
                _ -> LogNum = 20
            end,
            SortRecord = lists:keysort(4, Record),
            if
                SortRecord =/= [] ->
                    [{_, _,_,_,Utime,_,_,_}|_] = SortRecord,
                    %% 清理多余数据
                    db:execute(io_lib:format(?SQL_PERSON_DELETE, [Utime, RoleId])),
                    RealPersonLog = lists:sublist(SortRecord, LogNum);
                true ->
                    RealPersonLog = SortRecord
            end,
            NewMondayBonus = #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, task_state = TaskState, 
                record = RealPersonLog, utime = TUtime};
        _ ->
            DrawTimes = 0, Pool = [], TaskState = [], TUtime = Now,
            NewMondayBonus = MondayBonus
    end,
    IsSameDay = utime_logic:is_logic_same_day(TUtime, LoginTime),
    IsSameDay1 = utime:is_same_day(TUtime, LoginTime),
    case data_monday_bonus:get_task_info(?LOGIN_TASK) of
        #base_monday_bonus_task{reward = _Reward} when RoleLv >= OpenLv ->
            if
                IsSameDay == false ->
                    % ProduceType = get_produce_type(?MOD_BONUS_MONDAY),
                    % Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
                    % NewPs = lib_goods_api:send_reward(Player, Produce),
                    case lists:keyfind(?RECHARGE_TASK, 1, TaskState) of
                        {?RECHARGE_TASK, State} ->
                            if
                                IsSameDay1 == false ->
                                    NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}];
                                true ->
                                    NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}, {?RECHARGE_TASK, State}]
                            end;
                        _ ->
                            NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}]
                    end,
                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                            util:term_to_string(NewTaskState), util:term_to_string(Pool), Now]));
                IsSameDay1 == false ->
                    NewTaskState = lists:keydelete(?RECHARGE_TASK, 1, TaskState),
                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                            util:term_to_string(NewTaskState), util:term_to_string(Pool), Now]));
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [TaskState]),
                    NewTaskState = TaskState
            end,
            NewMondayBonus#monday_bonus_data{task_state = NewTaskState, utime = Now};
        _ ->
            NewMondayBonus
    end.

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    NewMondayBonus = do_login(Player),
    NewPlayer = Player#player_status{monday_bonus = NewMondayBonus},
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE}) when is_record(Player, player_status) ->
    #player_status{id = RoleId,monday_bonus = NMondayBonus, figure = #figure{lv = RoleLv}} = Player,
    mod_daily:increment(RoleId, ?MOD_BONUS_MONDAY, ?COUNTER_RECHARGE),
    case data_monday_bonus:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 0
    end,
    if
        RoleLv >= OpenLv ->
            if
                is_record(NMondayBonus, monday_bonus_data) ->
                    MondayBonus = NMondayBonus;
                true -> %% 先触发充值再触发登陆
                    MondayBonus = do_login(Player)
            end,
            #monday_bonus_data{draw_times = DrawTimes,now_pool = Pool, task_state = TaskState, utime = TUtime} = MondayBonus,
            case data_monday_bonus:get_task_info(?RECHARGE_TASK) of
                #base_monday_bonus_task{reward = _Reward} ->
                    Now = utime:unixtime(),
                    IsSameDay = utime_logic:is_logic_same_day(TUtime, Now),
                    if
                        IsSameDay == true ->
                            case lists:keyfind(?RECHARGE_TASK, 1, TaskState) of
                                {_, State} when State == ?HAS_ACHIEVE orelse State == ?HAS_RECIEVE ->
                                    NewPlayer = Player;
                                _ ->
                                    % ProduceType = get_produce_type(?MOD_BONUS_MONDAY),
                                    % Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                    % NewPs = lib_goods_api:send_reward(Player, Produce),
                                    NewTaskState = lists:keystore(?RECHARGE_TASK, 1, TaskState, {?RECHARGE_TASK, ?HAS_ACHIEVE}),
                                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                                        util:term_to_string(NewTaskState), util:term_to_string(Pool), Now])),
                                    NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState, utime = Now}}
                            end;
                        true ->
                            NewTaskState = [{?RECHARGE_TASK, ?HAS_ACHIEVE},{?LOGIN_TASK, ?HAS_ACHIEVE}],
                            lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                            db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                                    util:term_to_string(NewTaskState), util:term_to_string(Pool), Now])),
                            NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState, utime = Now}}
                    end;
                _ ->
                    NewPlayer = Player
            end;
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_ADD_LIVENESS}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, monday_bonus = NMondayBonus, figure = #figure{lv = RoleLv}} = Player,
    case data_monday_bonus:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 0
    end,
    if
        RoleLv >= OpenLv ->
            if
                is_record(NMondayBonus, monday_bonus_data) ->
                    MondayBonus = NMondayBonus;
                true -> %% 先触发充值再触发登陆
                    MondayBonus = do_login(Player)
            end,
            #monday_bonus_data{draw_times = DrawTimes,now_pool = Pool,task_state = TaskState, utime = TUtime} = MondayBonus,
            Liveness = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度
            case data_monday_bonus:get_task_info(?LIVNESS_TASK) of
                #base_monday_bonus_task{reward = _Reward, condition = Condition} ->
                    case lists:keyfind(livness, 1, Condition) of
                        Limit when is_integer(Limit) ->skip;
                        _ -> Limit = 140
                    end,
                    case lists:keyfind(?LIVNESS_TASK, 1, TaskState) of
                        {_, State} when State == ?HAS_ACHIEVE orelse State == ?HAS_RECIEVE ->
                            NewPlayer = Player;
                        _ ->
                            if
                                Liveness >= Limit ->
                                    % ProduceType = get_produce_type(?MOD_BONUS_MONDAY),
                                    % Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
                                    % NewPs = lib_goods_api:send_reward(Player, Produce),
                                    NewTaskState = lists:keystore(?LIVNESS_TASK, 1, TaskState, {?LIVNESS_TASK, ?HAS_ACHIEVE}),
                                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                                            util:term_to_string(NewTaskState), util:term_to_string(Pool), TUtime])),
                                    NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState}};
                                true ->
                                    NewPlayer = Player
                            end
                    end;
                _ ->
                    NewPlayer = Player
            end;
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus, figure = #figure{name = RoleName, lv = RoleLv}} = Player,
    case data_monday_bonus:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 0
    end,
    if
        RoleLv == OpenLv ->
            case MondayBonus of
                #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, task_state = TaskState} = NewMondayBonus -> skip;
                    _ ->
                        SQL = io_lib:format(?SQL_SELECT_DATA, [RoleId]),
                        List = db:get_row(SQL),
                        case List of
                            [DrawTimes, TaskStateL, PoolL, TUtime] ->
                                TaskState = util:bitstring_to_term(TaskStateL),
                                Pool = util:bitstring_to_term(PoolL);
                            _ ->
                                TaskState = [],DrawTimes = 0, Pool = get_default_pool(), TUtime = 0
                        end,
                        List2 = db:get_all(io_lib:format(?SQL_PERSON_SELECT, [RoleId])),
                        Fun = fun([_, Type, GoodsPoolid, Utime, Picture, PictureVer, Creer], Acc) ->
                            [{RoleId, RoleName,Type,GoodsPoolid,Utime,Picture,PictureVer, Creer}|Acc]
                        end,
                        Record = lists:foldl(Fun, [], List2),
                        case data_monday_bonus:get_value(kf_log_num) of
                            LogNum when is_integer(LogNum) ->skip;
                            _ -> LogNum = 20
                        end,
                        SortRecord = lists:keysort(4, Record),
                        if
                            SortRecord =/= [] ->
                                [{_, _,_,_,Utime,_,_,_}|_] = SortRecord,
                                %% 清理多余数据
                                db:execute(io_lib:format(?SQL_PERSON_DELETE, [Utime, RoleId])),
                                RealPersonLog = lists:sublist(SortRecord, LogNum);
                            true ->
                                RealPersonLog = SortRecord
                        end,
                        NewMondayBonus = #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, task_state = TaskState, record = RealPersonLog, utime = TUtime}
            end,
            case data_monday_bonus:get_task_info(?LOGIN_TASK) of
                #base_monday_bonus_task{reward = _Reward} when RoleLv >= OpenLv ->
                    RechargeCount = mod_daily:get_count(RoleId, ?MOD_BONUS_MONDAY, ?COUNTER_RECHARGE),
                    case lists:keyfind(?RECHARGE_TASK, 1, TaskState) of
                        {_, State} when State == ?HAS_ACHIEVE orelse State == ?HAS_RECIEVE ->
                            NTaskState = TaskState;
                        _ ->
                            if
                                RechargeCount >= 1 ->
                                    NTaskState = lists:keystore(?RECHARGE_TASK, 1, TaskState, {?RECHARGE_TASK, ?HAS_ACHIEVE});
                                true ->
                                    NTaskState = TaskState
                            end
                    end,
                    NewTaskState = lists:keystore(?LOGIN_TASK, 1, NTaskState, {?LOGIN_TASK, ?HAS_ACHIEVE}),
                    % NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}],
                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                    db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                            util:term_to_string(NewTaskState), util:term_to_string(Pool), utime:unixtime()])),
                    NewPlayer = Player#player_status{monday_bonus = NewMondayBonus#monday_bonus_data{task_state = NewTaskState, utime = utime:unixtime()}};
                _ ->
                    NewPlayer = Player#player_status{monday_bonus = NewMondayBonus}
            end;
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

handle_event(PS, #event_callback{}) ->
    {ok, PS}.

daily_timer(ClearType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_monday, daily_clear, [ClearType]) || E <- OnlineRoles].

daily_clear(Player, ClearType) when ClearType == ?FOUR ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    case MondayBonus of
        #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, utime = TUtime, task_state = TaskState} -> 
            case data_monday_bonus:get_task_info(?LOGIN_TASK) of
                #base_monday_bonus_task{reward = _Reward} ->
                    Now = utime:unixtime(),
                    IsSameDay = utime_logic:is_logic_same_day(TUtime, Now),
                    if
                        IsSameDay == true ->
                            NewPlayer = Player;
                        true ->
                            case lists:keyfind(?RECHARGE_TASK, 1, TaskState) of
                                {?RECHARGE_TASK, State} ->
                                    NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}, {?RECHARGE_TASK, State}];
                                _ ->
                                    NewTaskState = [{?LOGIN_TASK, ?HAS_ACHIEVE}]
                            end,
                            ?PRINT("====== NewTaskState:~p~n",[NewTaskState]),
                            lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                            db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                                    util:term_to_string(NewTaskState), util:term_to_string(Pool), Now])),
                            NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState, utime = Now}}
                    end;
                _ ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

daily_clear(Player, _) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    case MondayBonus of
        #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, utime = TUtime, task_state = TaskState} -> 
            case data_monday_bonus:get_task_info(?RECHARGE_TASK) of
                #base_monday_bonus_task{reward = _Reward} ->
                    Now = utime:unixtime(),
                    IsSameDay = utime:is_same_day(TUtime, Now),
                    ?PRINT("====== ~n",[]),
                    if
                        IsSameDay == true ->
                            NewPlayer = Player;
                        true ->
                            NewTaskState = lists:keydelete(?RECHARGE_TASK, 1, TaskState),
                            lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                            ?PRINT("====== NewTaskState:~p~n",[NewTaskState]),
                            db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                                    util:term_to_string(NewTaskState), util:term_to_string(Pool), Now])),
                            NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState, utime = Now}}
                    end;
                _ ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer}.

get_default_pool() ->
    TypeList = data_monday_bonus:get_all_type(),
    Fun = fun(Type, Acc) ->
        case data_monday_bonus:get_bonus_type(Type) of
            #base_monday_bonus{display = DisplayList} ->
                [{Type, DisplayList}|Acc];
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], TypeList).

send_info_midday(Player) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    case MondayBonus of
        #monday_bonus_data{draw_times = DrawTimes} ->
            case check_draw_time() of
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17907, [1, DrawTimes]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17907, [0, DrawTimes])
            end;
        _ ->
            skip
    end,
    Player.

check_draw_time() ->
    NowTime = utime:unixtime(),
    Day = utime:day_of_week(NowTime),
    {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
    case data_monday_bonus:get_value(draw_time) of
        [{day, DayList},{time, TimeList}] ->
            case lists:member(Day, DayList) of
                true ->
                    Fun = fun({{Sh,Sm},{Eh,Em}}) ->
                        Sh*60+Sm =< NowSH*60+NowSM andalso NowSH*60+NowSM =< Eh*60+Em
                    end,
                    case ulists:find(Fun, TimeList) of
                        {ok,_} ->
                            true;
                        _ ->
                            false
                    end;
                _ -> 
                    false
            end;
        _ ->
            false
    end.