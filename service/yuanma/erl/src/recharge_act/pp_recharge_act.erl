%%%------------------------------------
%%% @Module  : pp_recharge_act
%%% @Author  :  xiaoxiang
%%% @Created :  2017-04-06
%%% @Description: 充值活动
%%%------------------------------------


-module (pp_recharge_act).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("def_fun.hrl").
-include("daily.hrl").
-include("custom_act.hrl").
-include("recharge_act.hrl").
-include("def_module.hrl").
-include("def_counter.hrl").
-export ([handle/3]).

%% 查看福利卡
handle(15901, Player, _Data) ->
    lib_recharge_act:get_welfare(Player);

%% 领取福利卡福利
handle(15902, Player, [ProductId]) ->
    NewPlayer = lib_recharge_act:get_welfare_reward(Player, ProductId),
    {ok, NewPlayer};

%% 查看成长基金
handle(15903, Player, _Data) ->
    NewPlayer = lib_recharge_act:get_growup(Player),
    {ok, NewPlayer};

%% 领取成长基金福利
handle(15904, Player, [ProductId, Rank]) ->
    NewPlayer = lib_recharge_act:get_growup_reward(Player, ProductId, Rank),
    {ok, NewPlayer};

%% 查看首充奖励状态
handle(15905, Player, []) ->
    lib_recharge_first:send_first_state_to_client(Player);

%% 领取首充奖励
handle(Cmd = 15906, Player, [Index]) ->
    ?PRINT("Index:~p ~n", [Index]),
    case lib_recharge_first:get_recharge_gift_award(Player, Index) of
        {true, ErrCode, NewPS} ->
            {ok, Bin} = pt_159:write(Cmd, [ErrCode, Index]),
            lib_server_send:send_to_sid(NewPS#player_status.sid, Bin),
            {ok, NewPS};
        {false, ErrCode} ->
            % ?ERR_MSG(Cmd, ErrCode),
            {ok, Bin} = pt_159:write(Cmd, [ErrCode, Index]),
            lib_server_send:send_to_sid(Player#player_status.sid, Bin),
            {ok, Player}
    end;

%% 设置首充通知状态
handle(15907, Player, []) ->
    mod_counter:increment(Player#player_status.id, ?MOD_RECHARGE_ACT, ?COUNTER_RECHARGE_ACT_FIRST_NOTIFY);

%% 获取添加有礼充值状态
handle(15908, Player, []) ->
    lib_recharge_first:send_first_state_to_client2(Player);

%% 查看每日礼包状态
handle(15951, Player, []) ->
    lib_daily_gift:get_daily_gift_state(Player);

%% 购买每日礼包(检查是否能购买)
handle(15952, Player, [ProductId]) ->
    case lib_daily_gift:purchase_daily_gift(Player, ProductId) of
        {true, NewPS} ->
            {ok, Bin} = pt_159:write(15952, [?SUCCESS]),
            lib_server_send:send_to_sid(NewPS#player_status.sid, Bin),
            {ok, NewPS};
        {false, Res, NewPS} ->
            {ok, Bin} = pt_159:write(15952, [Res]),
            lib_server_send:send_to_sid(NewPS#player_status.sid, Bin),
            {ok, NewPS}
    end;

%% 领取每日礼包
handle(15953, Player, [ProductId]) ->
    case lib_daily_gift:get_daily_gift(Player, ProductId) of
        {true, NewPS} ->
            {ok, Bin} = pt_159:write(15953, [?SUCCESS]),
            lib_server_send:send_to_sid(NewPS#player_status.sid, Bin),
            {ok, NewPS};
        {false, Res, NewPS} ->
            {ok, Bin} = pt_159:write(15953, [Res]),
            lib_server_send:send_to_sid(NewPS#player_status.sid, Bin),
            {ok, NewPS}
    end;

handle(15954, Player, [ProductType]) ->
    IdList = data_recharge:get_product_id(),
    Info = [begin
        #base_recharge_product_ctrl{
            product_id=ProductId,                %% 商品id
            start_time=StartTime,                %% 开始时间
            end_time=EndTime,                    %% 结束时间
            week_time_list=Week,                 %% 周几开启
            month_time_list=Month,               %% 每月第几天开启
            open_begin=OpenBegin,                %% 开服开始天数
            open_end=OpenEnd,                    %% 开服结束天数
            merge_begin =MergeBegin,             %% 合服开始天数
            merge_end =MergeEnd,                 %% 合服结束天数
            condition=Condition                  %% 其它条件 []
        } = data_recharge:get_product_ctrl(Id),

        WeekB = util:term_to_bitstring(Week),
        MonthB = util:term_to_bitstring(Month),
        ConditionB = util:term_to_bitstring(Condition),
        {ProductId, StartTime, EndTime, WeekB, MonthB, OpenBegin, OpenEnd, MergeBegin, MergeEnd, ConditionB}
    end||Id<-IdList,
    case data_recharge:get_product(Id) of
        #base_recharge_product{product_type=ProductType} ->
            true;
        _ ->
            false
    end,
    case data_recharge:get_product_ctrl(Id) of
        #base_recharge_product_ctrl{} ->
            true;
        _ ->
            false
    end
    ],
    % ?PRINT("Info:~p ~n", [Info]),
    lib_server_send:send_to_uid(Player#player_status.id, pt_159, 15954, [Info]);

handle(15955, PS, [SubType]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            TodayGold = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
            RewardIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType),
            F = fun
                (Id, Acc) ->
                    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id) of
                        #custom_act_reward_cfg{condition = Condition, desc = Desc} = RewardCfg ->
                            case lists:keyfind(type, 1, Condition) of
                                {type, 1} ->
                                    {gold, Gold} = lists:keyfind(gold, 1, Condition),
                                    {State, _} = lib_recharge_cumulation:get_reward_state(PS, ActInfo, RewardCfg),
                                    RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg),
                                    [{Id, State, TodayGold, Gold, RewardList, util:term_to_bitstring(Condition), Desc}|Acc];
                                _ ->
                                    Acc
                            end;
                        _ ->
                            Acc
                    end
            end,
            DataList = lists:foldl(F, [], RewardIds),
            {ok, BinData} = pt_159:write(15955, [SubType, TodayGold, DataList]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
            {ok, BinData} = pt_159:write(15955, [SubType, 0, []]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData)
    end;

handle(15956, PS, [SubType]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType) of
        #act_info{
            stime = StartTime,
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            #player_status{recharge_act_status = #recharge_act_status{cumulation = Cumulation}} = PS,
            CycleTime = maps:get({cycle_time, SubType}, Cumulation, StartTime),
            % TodayGold = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
            %% 开始时间
            DiffDay = utime:diff_day(CycleTime),
%%            ?MYLOG("cym", "CycleTime  ~p  DiffDay~p~n",  [CycleTime, DiffDay]),
%%            ?MYLOG("cym", "CycleTime ~p  DiffDay ~p~n",  [CycleTime, DiffDay]),
            HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(PS#player_status.id, DiffDay),
            % HistoryListWithToday = if CycleTime > NowTime -> HistoryList; true -> [{0, {TodayGold, 0}}|HistoryList] end,
            RewardIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType),
%%            ?MYLOG("cym", "HistoryList ~p~n",  [HistoryList]),
            F = fun
                (Id, Acc) ->
                    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id) of
                        #custom_act_reward_cfg{condition = Condition, desc = Desc} = RewardCfg ->
                            case lists:keyfind(type, 1, Condition) of
                                {type, 2} ->
                                    {gold, Gold} = lists:keyfind(gold, 1, Condition),
                                    {day, Day} = lists:keyfind(day, 1, Condition),
                                    {State, OldTime} = lib_recharge_cumulation:get_reward_state(PS, ActInfo, RewardCfg),
                                    if
                                        State =:= ?ACT_REWARD_CAN_NOT_GET ->
                                            X = lists:sum([1 || {_, {G, _}} <- HistoryList, G >= Gold]),
                                            RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg);
                                        true ->
                                            X = Day,
                                            RewardList = lib_custom_act_util:count_act_reward_last_day(PS, ActInfo, RewardCfg, OldTime)
                                    end,

                                    [{Id, State, X, Day, Gold,  RewardList, util:term_to_bitstring(Condition), Desc}|Acc];
                                _ ->
                                    Acc
                            end;
                        _ ->
                            Acc
                    end
            end,
            DataList = lists:foldl(F, [], RewardIds),
%%            ?MYLOG("cym", "DataList ~p~n",  [DataList]),
            {ok, BinData} = pt_159:write(15956, [SubType, DataList]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
%%            ?MYLOG("cym", "error ~n",  []),
            {ok, BinData} = pt_159:write(15956, [SubType, []]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData)
    end;

%% 获取从某个时间0点开始到现在的充值总数
%% STime会转换成那个时刻当天的0点
handle(15957, PS, [Type, SubType, STime]) ->
    DiffDay = utime:diff_day(STime),
    HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(PS#player_status.id, DiffDay),
    % HistoryListWithToday = [{0, {TodayGold, 0}}|HistoryList],
    TotalGold = lists:sum([X || {_, {X, _}} <- HistoryList]),
%%    ?INFO("Type ~p, SubType ~p, STime ~p TotalGold ~p", [Type, SubType, STime, TotalGold]),
    {ok, BinData} = pt_159:write(15957, [Type, SubType, TotalGold]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);


%% 查看充值活动当前的充值金额
handle(15958, PS, [?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType) of
        #act_info{stime =STime} ->
            TotalGold = lib_recharge_data:get_my_recharge_between(PS#player_status.id, STime, utime:unixtime()),
%%            ?PRINT("15958 ~p~n", [TotalGold]),
            {ok, BinData} = pt_159:write(15958, [?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType, TotalGold]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
            ok
    end;

handle(15958, PS, [?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE, SubType) of
        #act_info{stime =STime} ->
            TotalGold = lib_recharge_data:get_my_recharge_between(PS#player_status.id, STime, utime:unixtime()),
            {ok, BinData} = pt_159:write(15958, [?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE, SubType, TotalGold]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
            ok
    end;

%% 查看充值活动当前的充值金额
handle(15958, PS, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} = ActInfo ->
            STime = lib_custom_act_util:get_act_logic_stime(ActInfo),
            TotalGold = lib_recharge_data:get_my_recharge_between(PS#player_status.id, STime, utime:unixtime()),
            % ?PRINT("15958 ~p~n", [TotalGold]),
            {ok, BinData} = pt_159:write(15958, [Type, SubType, TotalGold]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
            ok
    end;

%% 查看当天充值金额
handle(15959, PS, []) ->
    TodayGold = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
    {ok, BinData} = pt_159:write(15959, [TodayGold]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);


%% 查看当天充值金额
handle(15960, PS, [DiffDay]) ->
    HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(PS#player_status.id, DiffDay),
%%    ResList = [{Time, Gold} ||{Time, {Gold, _Rmb}} <- HistoryList],
%%    ?PRINT("ResList ~p~n", [ResList]),
	if
		DiffDay >= 0 -> %% 客户端说要构造数据给他.....
			DiffStartTime = utime:get_diff_day_standard_unixdate(DiffDay, 0),
			TempList = lib_recharge_data:splite_date_time(DiffStartTime, utime:unixtime(), []),
			F = fun(ZeroTime, AccList) ->
					FunGold =
						case lists:keyfind(ZeroTime, 1, HistoryList) of
							{ZeroTime, {V, _}} ->
								V;
							_ ->
								0
						end,
					[{ZeroTime, FunGold} | AccList]
				end,
			ResList = lists:foldl(F, [], TempList),
%%			?PRINT("ResList ~p~n", [ResList]),
			{ok, BinData} = pt_159:write(15960, [ResList]);
		true ->
			{ok, BinData} = pt_159:write(15960, [[]])
	end,
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);

handle(_Cmd, _PS, _Data) ->
    % ?PRINT("no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_recharge no match"}.
