%%-----------------------------------------------------------------------------
%% @Module  :       lib_lucky_turntable.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-31
%% @Description:    幸运转盘
%%-----------------------------------------------------------------------------
-module (lib_lucky_turntable).
-include ("server.hrl").
-include ("custom_act.hrl").
-include ("def_module.hrl").
-include ("errcode.hrl").
-include ("goods.hrl").
-include ("figure.hrl").
-include ("common.hrl").
-include ("def_fun.hrl").
-include("predefine.hrl").

-compile(export_all).

%% 充值
handle_recharge(Player, Product, Gold) ->
    TypeList = [?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE],
    F = fun(Type, List) ->
        [{Type, SubType}||SubType<-lib_custom_act_util:get_subtype_list(Type)] ++ List
    end,
    KeyList = lists:foldl(F, [], TypeList),
    F2 = fun({Type, SubType}, TmpPlayer) ->
        handle_recharge(TmpPlayer, Product, Gold, Type, SubType)
    end,
    lists:foldl(F2, Player, KeyList).

handle_recharge(Player, _Product, Gold, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            Key = {Type, SubType},
            TurntableData = #custom_act_turntable{
                gold = TotalGold
            } = get_turntable_data(Player, Type, SubType),
            NewTurntableData = TurntableData#custom_act_turntable{
                gold = TotalGold + Gold, utime = utime:unixtime()
            },
            ActData = #custom_act_data{
                id = Key, type = Type, subtype = SubType
                ,data = NewTurntableData
            },
            PSAfSave = lib_custom_act:save_act_data_to_player(Player, ActData),
            pp_custom_act:handle(33130, PSAfSave, [Type, SubType]),
            PSAfSave;
        false ->
            Player
    end.

%% 获得转盘的数据
% 临时修复
% get_turntable_data(#player_status{id = RoleId} = Player, Type, SubType) when Type == ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE ->
%     case lib_custom_act:act_data(Player, Type, SubType) of
%         #custom_act_data{data = Data} -> 
%             NewData = case Data of
%                 #custom_act_turntable{utime = UTime} = Data -> Data;
%                 _ -> 
%                     UTime = utime:unixtime(),
%                     #custom_act_turntable{utime = UTime}
%             end, 
%             case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
%                 #act_info{stime = Stime, etime = Etime} when UTime >= Stime, UTime =< Etime ->
%                     case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), UTime) of
%                         true -> 
%                             Gold = lib_recharge_data:get_today_pay_gold(RoleId),
%                             NewData#custom_act_turntable{gold = Gold};
%                         false -> 
%                             Gold = lib_recharge_data:get_today_pay_gold(RoleId),
%                             #custom_act_turntable{gold = Gold}
%                     end;
%                 _ ->
%                     Gold = lib_recharge_data:get_today_pay_gold(RoleId),
%                     #custom_act_turntable{gold = Gold}
%             end;
%         _ -> 
%             Gold = lib_recharge_data:get_today_pay_gold(RoleId),
%             #custom_act_turntable{gold = Gold}
%     end;
get_turntable_data(Player, Type, SubType) ->
    case lib_custom_act:act_data(Player, Type, SubType) of
        #custom_act_data{data = Data} ->
            NewData = case Data of
                #custom_act_turntable{utime = UTime} = Data -> Data;
                _ ->
                    UTime = utime:unixtime(),
                    #custom_act_turntable{utime = UTime}
            end,
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                #act_info{stime = Stime, etime = Etime} when UTime >= Stime, UTime =< Etime ->
                    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), UTime) of
                        true -> NewData;
                        false -> #custom_act_turntable{}
                    end;
                _ ->
                    #custom_act_turntable{}
            end;
        _ ->
            #custom_act_turntable{}
    end.

%% 获得活动信息
send_act_info(PS, #act_info{key = {Type, SubType}} = ActInfo) ->
    % ?PRINT("send_act_info ~p~n", [ActInfo]),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lib_custom_act_check:check_act_condtion([ticket_price, ticket_max], Condition) of
                [Price, MaxCount] ->
                    #custom_act_turntable{gold = Gold, times = UsedCount} = get_turntable_data(PS, Type, SubType),
                    TotalCount = min(Gold div Price, MaxCount),
                    NeedGold
                    = if
                        TotalCount == MaxCount ->
                            0;
                        true ->
                            case Gold rem Price of
                                0 ->
                                    Price;
                                G ->
                                    Price - G
                            end
                    end,
                    LeftCount = max(TotalCount - UsedCount, 0),
                    TotalLeftCount = max(MaxCount - UsedCount, 0),
                    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
                    F = fun(GradeId, {Infos, Ns}) ->
                        #custom_act_reward_cfg{condition = RConditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                        case lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg) of
                            [{_, GoodsId, Num}|_] ->
                                N
                                = case lists:keyfind(n_times, 1, RConditions) of
                                    {n_times, V} ->
                                        V;
                                    _ ->
                                        1
                                end,
                                NewInfos
                                = case lists:member({GoodsId, Num}, Infos) of
                                    false ->
                                        [{GoodsId, Num}|Infos];
                                    _ ->
                                        Infos
                                end,
                                NewNs
                                = case lists:member(N, Ns) of
                                    false ->
                                        [N|Ns];
                                    _ ->
                                        Ns
                                end,
                                {NewInfos, NewNs};
                            _ ->
                                {Infos, Ns}
                        end
                    end,
                    {RewardInfos, NTimes} = lists:foldl(F, {[], []}, Ids),
                    % ?PRINT("send_act_info ~p~n", [[Price, LeftCount, TotalCount, TotalLeftCount, Gold, NeedGold, NTimes]]),
                    {ok, BinData} = pt_331:write(33130, [Type, SubType, LeftCount, TotalCount, TotalLeftCount, Gold, NeedGold, NTimes, lists:reverse(RewardInfos)]),
                    lib_server_send:send_to_sid(PS#player_status.sid, BinData);
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

%% 转盘
turntable(#player_status{id = RoleId, sid = Sid} = PS, #act_info{key = {Type, SubType}} = ActInfo) when
        Type == ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE ->
    case check_turntable(PS, ActInfo) of
        {false, ErrorCode} ->
            lib_custom_act:send_error_code(RoleId, ErrorCode),
            {ok, PS};
        {true, LeftCount, TotalLeftCount, TurntableData, RewardCfg, NTimes, Rewards, GoodsId, Num} ->
            % 存储
            #custom_act_turntable{times = UsedCount} = TurntableData,
            NewTurntableData = TurntableData#custom_act_turntable{times = UsedCount+1, utime = utime:unixtime()},
            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewTurntableData},
            PSAfSave = lib_custom_act:save_act_data_to_player(PS, ActData),
            % 发送奖励
            #custom_act_reward_cfg{grade = GradeId} = RewardCfg,
            Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId, "NTimes:", NTimes]),
            Produce = #produce{type = lucky_turntable_rewards, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_1},
            PSAfReward = lib_goods_api:send_reward(PSAfSave, Produce),
            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Rewards),
            % 协议
            {ok, BinData} = pt_331:write(33131, [Type, SubType, GoodsId, Num, NTimes, LeftCount - 1, TotalLeftCount - 1]),
            lib_server_send:send_to_sid(Sid, BinData),
            mod_lucky_turntable:add_record(Type, SubType, RoleId, PS#player_status.figure#figure.name, GoodsId, Num, NTimes),
            send_tv(PSAfReward, RewardCfg, NTimes),
            {ok, PSAfReward}
    end;
turntable(#player_status{id = RoleId} = PS, _ActInfo) ->
    lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed)),
    {ok, PS}.

check_turntable(PS, #act_info{key = {Type, SubType}} = ActInfo) ->
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lib_custom_act_check:check_act_condtion([ticket_price, ticket_max], Condition) of
                [Price, MaxCount] -> CheckCfg = true;
                _ -> Price = 0, MaxCount = 0, CheckCfg = {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end;
        _ ->
            Price = 0, MaxCount = 0, CheckCfg = {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end,
    #custom_act_turntable{gold = Gold, times = UsedCount} = TurntableData = get_turntable_data(PS, Type, SubType),
    % 是否够门票
    case CheckCfg andalso Price > 0 of
        true -> TotalCount = min(Gold div Price, MaxCount);
        _ -> TotalCount = 0
    end,
    LeftCount = TotalCount - UsedCount,
    TotalLeftCount = max(MaxCount - UsedCount, 0),
    if
        IsOpen == false -> {false, ?ERRCODE(err331_act_closed)};
        % 配置
        CheckCfg =/= true -> CheckCfg;
        % 是否够门票
        LeftCount =< 0 -> {false, ?ERRCODE(err331_ticket_limit)};
        true ->
            % 抽奖
            Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            F = fun(GradeId) ->
                #custom_act_reward_cfg{condition = RConditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                case lists:keyfind(weight, 1, RConditions) of
                    {weight, Weight} -> ok;
                    _ -> Weight = 0
                end,
                case lists:keyfind(n_times, 1, RConditions) of
                    {n_times, N} -> ok;
                    _ -> N = 1
                end,
                {Weight, [RewardCfg, N]}
            end,
            Weightlist = lists:map(F, Ids),
            case urand:rand_with_weight(Weightlist) of
                [RewardCfg, NTimes] ->
                     case lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg) of
                        [{_, GoodsId, Num} = Hd|_] ->
                            Rewards = lib_goods_util:goods_object_multiply_by([Hd], NTimes),
                            case lib_goods_api:can_give_goods(PS, Rewards) of
                                true -> {true, LeftCount, TotalLeftCount, TurntableData, RewardCfg, NTimes, Rewards, GoodsId, Num};
                                {false, ErrorCode} -> {false, ErrorCode}
                            end;
                        _ ->
                            {false, ?ERRCODE(err331_no_act_reward_cfg)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end
    end.

%% 发送传闻
send_tv(#player_status{id = Id, figure = #figure{name = Name}}, RewardCfg, NTimes) ->
    #custom_act_reward_cfg{type = Type, subtype = SubType, condition = RConditions} = RewardCfg,
    case lists:keyfind(tv, 1, RConditions) of
        {tv, {ModuleId, TvId}} ->
            lib_chat:send_TV({all}, ModuleId, TvId, [Name, Id, NTimes, Type, SubType]);
        _ -> skip
    end,
    ok.

%% 发送转盘记录
send_turntable_records(RoleId, Type, SubType) ->
    mod_lucky_turntable:send_records(RoleId, Type, SubType).

%% 活动结束
act_end(Type, SubType) ->
    % 根据时间来判断是否过期活动,可以无需清理
    spawn(fun() ->
        % 1.减少无用数据
        % 2.防止复用子类型,活动记录更新时间在开始时间和结束时间之间导致数据不清理
        lib_custom_act:db_delete_custom_act_data(Type, SubType)
    end),
    % OnlineRoles = ets:tab2list(?ETS_ONLINE),
    % [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, act_end, [Type, SubType]) || E <- OnlineRoles],
    ok.

% 可以不需要,每次获取data数据的时候,会判断更新时间是否在活动期间
% act_end(Player, Type, SubType) ->
%     PlayerAfData = lib_custom_act:delete_act_data_to_player_without_db(Player, Type, SubType),
%     {ok, PlayerAfData}.

%% 次数重置
gm_reset(Player, Type, SubType) ->
    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = #custom_act_turntable{}},
    PSAfSave = lib_custom_act:save_act_data_to_player(Player, ActData),
    pp_custom_act:handle(33130, PSAfSave, [Type, SubType]),
    PSAfSave.

% -export ([
%     send_act_info/2
%     ,send_act_infos/2
%     ,turntable/2
%     ,send_turntable_records/2
%     ]).


% send_act_infos(PS, List) ->
%     [send_act_info(PS, Act) || Act <- List], 
%     ok.

% send_act_info(#player_status{id = RoleId} = PS, #act_info{key = {_, SubType}} = ActInfo) ->
%     case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType) of
%         #custom_act_cfg{condition = Condition} ->
%             case lib_custom_act_check:check_act_condtion([ticket_price, ticket_max], Condition) of
%                 [Price, MaxCount] ->
%                     TodayRecharge = lib_recharge_data:get_today_pay_gold(RoleId),
%                     UsedCount = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType),
%                     TotalCount = min(TodayRecharge div Price, MaxCount),
%                     NeedGold
%                     = if
%                         TotalCount == MaxCount ->
%                             0;
%                         true ->
%                             case TodayRecharge rem Price of
%                                 0 ->
%                                     Price;
%                                 G ->
%                                     Price - G
%                             end
%                     end,
%                     LeftCount = max(TotalCount - UsedCount, 0),
%                     Ids = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType),
%                     {RewardInfos, NTimes} = lists:foldl(fun
%                         (GradeId, {Infos, Ns}) ->
%                             case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType, GradeId) of
%                                 #custom_act_reward_cfg{condition = RConditions} = RewardCfg ->
%                                     case lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg) of
%                                         [{_, GoodsId, Num}|_] ->
%                                             N
%                                             = case lists:keyfind(n_times, 1, RConditions) of
%                                                 {n_times, V} ->
%                                                     V;
%                                                 _ ->
%                                                     1
%                                             end,
%                                             NewInfos
%                                             = case lists:member({GoodsId, Num}, Infos) of
%                                                 false ->
%                                                     [{GoodsId, Num}|Infos];
%                                                 _ ->
%                                                     Infos
%                                             end,
%                                             NewNs
%                                             = case lists:member(N, Ns) of
%                                                 false ->
%                                                     [N|Ns];
%                                                 _ ->
%                                                     Ns
%                                             end,
%                                             {NewInfos, NewNs};
%                                         _ ->
%                                             {Infos, Ns}
%                                     end;
%                                 _ ->
%                                     {Infos, Ns}
%                             end
%                     end, {[], []}, Ids),
%                     % ?PRINT("send_act_info ~p~n", [[Price, LeftCount, TotalCount, TodayRecharge, NeedGold, NTimes]]),
%                     {ok, BinData} = pt_331:write(33130, [SubType, LeftCount, TotalCount, TodayRecharge, NeedGold, NTimes, lists:reverse(RewardInfos)]),
%                     lib_server_send:send_to_sid(PS#player_status.sid, BinData);
%                 _ ->
%                     skip
%             end;
%         _ ->
%             skip
%     end.

% turntable(#player_status{id = RoleId, sid = Sid} = PS, #act_info{key = {_, SubType}} = ActInfo) ->
%     case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType) of
%         #custom_act_cfg{condition = Condition} ->
%             case lib_custom_act_check:check_act_condtion([ticket_price, ticket_max], Condition) of
%                 [Price, MaxCount] ->
%                     TodayRecharge = lib_recharge_data:get_today_pay_gold(RoleId),
%                     UsedCount = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType),
%                     TotalCount = min(TodayRecharge div Price, MaxCount),
%                     case TotalCount - UsedCount of
%                         LeftCount when LeftCount > 0 ->
%                             Ids = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType),
%                             Weightlist = lists:map(fun
%                                 (GradeId) ->
%                                     case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType, GradeId) of
%                                         #custom_act_reward_cfg{condition = RConditions} = RewardCfg ->
%                                             case lists:keyfind(weight, 1, RConditions) of
%                                                 {weight, Weight} -> ok;
%                                                 _ -> Weight = 0
%                                             end,
%                                             case lists:keyfind(n_times, 1, RConditions) of
%                                                 {n_times, N} -> ok;
%                                                 _ -> N = 1
%                                             end,
%                                             {Weight, [RewardCfg, N]};
%                                         _ ->
%                                             {0, undefined}
%                                     end
%                             end, Ids),
%                             case urand:rand_with_weight(Weightlist) of
%                                 [RewardCfg, N] ->
%                                     case lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg) of
%                                         [{_, GoodsId, Num} = Hd|_] ->
%                                             Rewards = lib_goods_util:goods_object_multiply_by([Hd], N),
%                                             case lib_goods_api:can_give_goods(PS, Rewards) of
%                                                 true ->
%                                                     mod_daily:increment(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType),
%                                                     Produce = #produce{type = lucky_turntable_rewards, subtype = SubType, reward = Rewards, remark = integer_to_list(N), show_tips = ?SHOW_TIPS_1},
%                                                     NewPS = lib_goods_api:send_reward(PS, Produce),
%                                                     % ?PRINT("reward ~p~n", [[RewardCfg#custom_act_reward_cfg.grade, GoodsId, Num, N]]),
%                                                     {ok, BinData} = pt_331:write(33131, [SubType, GoodsId, Num, N, LeftCount - 1]),
%                                                     lib_server_send:send_to_sid(Sid, BinData),
%                                                     mod_lucky_turntable:add_record(SubType, RoleId, PS#player_status.figure#figure.name, GoodsId, Num, N),
%                                                     {ok, NewPS};
%                                                 {false, ErrorCode} ->
%                                                     lib_custom_act:send_error_code(RoleId, ErrorCode)
%                                             end;
%                                         _ ->
%                                             lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_no_act_reward_cfg))
%                                     end;
%                                 _ ->
%                                     lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_no_act_reward_cfg))
%                             end;
%                         _ ->
%                             lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_ticket_limit))
%                     end;
%                 _ ->
%                     lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_no_act_reward_cfg))
%             end;
%         _ ->
%             lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_no_act_reward_cfg))
%     end.

% send_turntable_records(RoleId, SubType) ->
%     mod_lucky_turntable:send_records(RoleId, SubType).

%% 秘籍:修正幸运转盘充值数据(计算当天充值数值作为活动数据)
gm_recalc_turntable_data() ->
    Type = ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE,
    case lib_custom_act_util:get_open_subtype_list(Type) of
        [] -> skip;
        [ActInfo|_] ->  % 默认只有一个子活动开启
            #act_info{key = {_, SubType}} = ActInfo,
            Sql = io_lib:format(
                "select player_id, data_list
                from custom_act_data
                where type=~p and subtype=~p", [Type, SubType]),
            PlayerInfos = db:get_all(Sql),
            AccList = gm_recalc_turntable_data(Type, SubType, PlayerInfos, []),
            USql = usql:replace(custom_act_data,
                [player_id, type, subtype, data_list], AccList),
            ?IF(USql =/= [], db:execute(USql), skip),
            [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, gm_refresh_turntable_data, [Type, SubType]) || Id <- lib_online:get_online_ids()],
            ok
    end.

gm_recalc_turntable_data(_, _, [], AccList) -> AccList;
gm_recalc_turntable_data(Type, SubType, [[PlayerId, DataBin]|T], AccList) ->
    CustomActData = lib_custom_act:make_record(custom_act_data, [Type, SubType, DataBin]),
    #custom_act_data{data = TurnTableData} = CustomActData,
    #custom_act_turntable{gold = OGold} = TurnTableData,
    Gold = lib_recharge_data:get_today_pay_gold(PlayerId),
    case Gold =:= OGold of
        true ->
            gm_recalc_turntable_data(Type, SubType, T, AccList);
        false ->
            NewTurnTableData = TurnTableData#custom_act_turntable{gold = Gold},
            NewDataBin = util:term_to_bitstring(NewTurnTableData),
            gm_recalc_turntable_data(Type, SubType, T, [[PlayerId, Type, SubType, NewDataBin]|AccList])
    end.

%% 刷新在线玩家内存数据
gm_refresh_turntable_data(PS, Type, SubType) ->
    #player_status{id = PlayerId, status_custom_act = StatusCustomAct} = PS,
    Sql = io_lib:format(
        "select data_list
        from custom_act_data
        where player_id=~p and type=~p and subtype=~p", [PlayerId, Type, SubType]),
    case db:get_row(Sql) of
        [] -> {ok, PS};
        [PlayerInfo] ->
            ActData = lib_custom_act:make_record(custom_act_data, [Type, SubType, PlayerInfo]),
            #status_custom_act{data_map = DataMap} = StatusCustomAct,
            Key = ActData#custom_act_data.id,
            NewDataMap = maps:put(Key, ActData, DataMap),
            NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
            NewPS = PS#player_status{status_custom_act = NewStatusCustomAct},
            {ok, NewPS}
    end.

%% 修复元宝数据（时间配置错误）
gm_fix_turntable_gold(_Type, _SubType) ->
    Type = list_to_integer(_Type),
    SubType = list_to_integer(_SubType),
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #custom_act_cfg{clear_type =  ClearType, start_time = STime,
                end_time = ETime}= data_custom_act:get_act_info(Type, SubType),
            if
                %% 0点清零
                ClearType == 2 ->
                    StartTime = utime:unixdate(),
                    EndTime = StartTime + ?ONE_DAY_SECONDS,
                    fix_turntable_gold(StartTime, EndTime, Type, SubType);
                %% 4点清零
                ClearType == 3 ->
                    StartTime = utime:unixdate() + ?ONE_HOUR_SECONDS*4,
                    EndTime  = StartTime + ?ONE_DAY_SECONDS + ?ONE_HOUR_SECONDS*4,
                    fix_turntable_gold(StartTime, EndTime, Type, SubType);
              %% 不清理
                true ->  fix_turntable_gold(STime, ETime, Type, SubType)
            end,
            ok;
        false ->
            skip
    end.

%% 修复在线玩家元宝
fix_turntable_gold(StartTime, EndTime, Type, SubType) ->
    Sql = io_lib:format(
        "select player_id, sum(gold)
        from recharge_log
        where time between ~p and ~p group by player_id", [StartTime, EndTime]),
    GoldList = db:get_all(Sql),
    F = fun([RoleId, Gold], TempList) ->
        timer:sleep(50),
        Pid = misc:get_player_process(RoleId),
        case misc:is_process_alive(Pid) of
            %%在线玩家
            true ->
                [OnlineGold, OutGold] = TempList,
                [[{RoleId, Gold} | OnlineGold], OutGold];
            %%离线玩家
            false ->
                [OnlineGold, OutGold] = TempList,
                [OnlineGold, [{RoleId, Gold} | OutGold]]
        end
    end,
    [OnlineGoldList, OutGoldList] = lists:foldl(F, [[], []], GoldList),
    F1 = fun({RoleId, _Gold}, List) ->
        [RoleId | List]
    end,
    %% 在线角色id
    OnlineRoleList = lists:foldl(F1, [], OnlineGoldList),
    %% 离线角色id
    OutRoleList = lists:foldl(F1, [], OutGoldList),
    OnlineRoleList =/= [] andalso fix_online_gold(Type, SubType, OnlineGoldList, OnlineRoleList),
    OutRoleList =/= [] andalso fix_outline_gold(Type, SubType, OutGoldList, OutRoleList).

%% 修复在线玩家元宝
fix_online_gold(Type, SubType, OnlineGoldList, OnlineRoleList) ->
    DataList = query_role_data(Type, SubType, OnlineRoleList),
    DataList =/=[] andalso [do_fix_online_gold(PlayerId, Data, Type, SubType, OnlineGoldList) || [PlayerId, Data] <- DataList].

do_fix_online_gold(PlayerId, Data, Type, SubType, OnlineGoldList) ->
    TempDate = util:string_to_term(binary_to_list(Data)),
    ActData = bale_latest_gold(PlayerId, Type, SubType, TempDate, OnlineGoldList),
    %% 刷新在线玩家内存数据
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_custom_act, save_act_data_to_player, [ActData]).

%% 修复离线玩家元宝
fix_outline_gold(Type, SubType, OutGoldList, OutRoleList) ->
    DataList = query_role_data(Type, SubType, OutRoleList),
    DataList =/=[] andalso [do_fix_outline_gold(PlayerId, Data, Type, SubType, OutGoldList) || [PlayerId, Data] <- DataList].

do_fix_outline_gold(PlayerId, Data, Type, SubType, OutGoldList) ->
    TempDate = util:string_to_term(binary_to_list(Data)),
    ActData = bale_latest_gold(PlayerId, Type, SubType, TempDate, OutGoldList),
    %%存入数据库
    lib_custom_act:db_save_custom_act_data(PlayerId, ActData).

%% 封装最新元宝
bale_latest_gold(PlayerId, Type, SubType, TurntableData, GoldList) ->
    Gold = case lists:keyfind(PlayerId, 1, GoldList) of
               false -> 0;
               {_, TempGold} -> TempGold
           end,
    NewTurntableData = TurntableData#custom_act_turntable{
        gold = Gold, utime = utime:unixtime()
    },
    Key = {Type, SubType},
    #custom_act_data{
        id = Key, type = Type, subtype = SubType
        ,data = NewTurntableData
    }.

%% 根据角色id，主类型，子类型查找data_list
query_role_data(Type, SubType, RoleList) ->
    Condition = usql:condition({player_id, in, RoleList}),
    Sql = io_lib:format(
        "select player_id, data_list
        from custom_act_data
        ~s and type = ~p and subtype = ~p", [Condition, Type, SubType]),
    db:get_all(Sql).