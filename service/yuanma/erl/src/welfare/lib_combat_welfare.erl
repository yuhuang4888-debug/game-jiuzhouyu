%%---------------------------------------------------------------------------
%% @doc:        lib_combat_welfare
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-2月-16. 19:51
%% @deprecated: 战力福利
%%---------------------------------------------------------------------------
-module(lib_combat_welfare).

-include("common.hrl").
-include("welfare.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("errcode.hrl").

%% API
-export([
    login/1,
    handle_event/2,
    combat_welfare_draw/1,
    send_panel_info/1,
    get_data/1
]).

-export([
    gm_reset_rewardL/1
]).


login(Player) ->
    CombatData = get_combat_welfare_data(Player, none),
    case CombatData of
        #status_combat_welfare{} ->
            Player#player_status{ combat_welfare = CombatData };
        _ ->
            Player
    end.

%% 升级或战力变化时触发
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{ id = PlayerId, figure = #figure{lv = Lv, name = PlayerName}, combat_power = Power, combat_welfare = CombatWelfareData } = Player,
    OpenLevel = data_welfare:get_cfg(combat_welfare_open_lv),
    case Lv >= OpenLevel of
        true ->
            case CombatWelfareData of
                #status_combat_welfare{} ->
                    {ok, Player};
                _ ->
                    InitData = init_combat_welfare_data(PlayerId, PlayerName, Power),
                    case InitData of
                        #status_combat_welfare{} ->
                            NewPlayer = Player#player_status{combat_welfare = InitData},
                            {ok, NewPlayer};
                        _ ->
                            {ok, Player}
                    end
            end;
        false ->
            {ok, Player}
    end;
%% 每次战力升级是触发，增加相关次数
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER, data = Data}) ->
    #callback_combat_power_data{combat_power = CombatPower, hightest_combat_pwer = HighCombatPower} = Data,
    case CombatPower > HighCombatPower of
        true ->
            NewPlayer = do_handle_event(Player, CombatPower);
        false ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};
handle_event(Player, _) ->
    {ok, Player}.

%% 战力福利抽奖
combat_welfare_draw(Player) ->
    #player_status{ combat_welfare = CombatWelfareData, id = PlayerId, figure = #figure{ name = PlayerName } } = Player,
    case CombatWelfareData of
        #status_combat_welfare{ round = Round, times = Times, reward_list = RewardL, index = Index} ->
            case catch check_can_draw(Player, Round, Times, RewardL) of
                {ok, RewardList, RandRewardId, IsNewRound} ->
                    case IsNewRound of
                        true ->
                            {NewRound, IsLastRound} = get_next_round(Round),
                            %% 最后一轮最后一次抽完后不清空已抽中的信息
                            NewRewardL = ?IF(IsLastRound, [RandRewardId|RewardL], []);
                        false ->
                            NewRound = Round,
                            NewRewardL = [RandRewardId|RewardL]
                    end,
                    NewTimes = Times - 1,
                    NewCombatWelfareData = CombatWelfareData#status_combat_welfare{ round = NewRound, times = NewTimes, reward_list = NewRewardL},
                    save_module_data_in_db(PlayerId, NewCombatWelfareData),
                    NP = Player#player_status{ combat_welfare = NewCombatWelfareData },
                    Produce = #produce{type = combat_welfare_reward, reward = RewardList, show_tips = ?SHOW_TIPS_0},
                    NewPlayer = lib_goods_api:send_reward(NP, Produce),
                    NextPower = get_next_combat_condition(NewTimes, Index),
                    lib_log_api:log_combat_welfare_reward_info(PlayerId, PlayerName, Round, RandRewardId, RewardList),
                    lib_server_send:send_to_uid(PlayerId, pt_417, 41724, [1, NewRound, NewTimes, RandRewardId, NextPower]),
                    NewPlayer;
                {error, Code} ->
                    lib_server_send:send_to_uid(Player#player_status.id, pt_417, 41724, [Code, Round, 0, 0, 0]),
                    Player
            end;
        _ ->
            lib_server_send:send_to_uid(Player#player_status.id, pt_417, 41724, [?LEVEL_LIMIT, 0, 0, 0, 0]),
            Player
    end.

%% 发送面板信息
send_panel_info(Player) ->
    #player_status{ combat_welfare = CombatWelfareData, hightest_combat_power = CombatPower } = Player,
    case CombatWelfareData of
        #status_combat_welfare{ round = Round, times = Times, reward_list = RewardL, index = Index } ->
            NextPower = get_next_combat_condition(Times, Index),
            lib_server_send:send_to_uid(Player#player_status.id, pt_417, 41723, [Round, Times, CombatPower, NextPower, RewardL]);
        _ ->
            %%?INFO("ncombat_welfare_not_init. RoleId:~p//RoleLevle:~p//OpenLevel:~p", [Player#player_status.id, Player#player_status.figure#figure.lv, data_welfare:get_cfg(combat_welfare_open_lv)]),
            skip
    end.

%% get_data
get_data(Player) ->
    #player_status{ combat_welfare = CombatWelfareData } = Player,
    CombatWelfareData.

%% ========================================
%% gm_function
%% ========================================
%% 重置数据
gm_reset_rewardL(Player) ->
    #player_status{ combat_welfare = Data, id = PlayerId, combat_power = Power, figure = #figure{name = PlayerName} } = Player,
    case Data of
        #status_combat_welfare{ } ->
            case init_combat_welfare_data(PlayerId, PlayerName, Power) of
                #status_combat_welfare{} = NewData ->
                    save_module_data_in_db(PlayerId, NewData),
                    Player#player_status{ combat_welfare = NewData };
                _ ->
                    Player
            end;
        _ ->
            Player
    end.

%% ========================================
%% inner_function
%% ========================================
%% 获取战力福利的相关数据
%% 当功能未开放时返回undefined,其余情况返回#status_combat_welfare{}
get_combat_welfare_data(Player, ExternalPower) ->
    #player_status{ id = PlayerId, figure = #figure{ lv = PlayerLv, name = PlayerName}, hightest_combat_power = MaxCombatPower} = Player,
    case data_welfare:get_cfg(combat_welfare_open_lv) of
        OpenLevel when is_integer(OpenLevel) ->
            case PlayerLv >= OpenLevel of
                true ->
                    case get_data_from_db(PlayerId) of
                        [Round, LessTimes, LastIndex, DrawRewardIds] ->
                            DrawList = util:bitstring_to_term(DrawRewardIds),
                            make_record(Round, LessTimes, LastIndex, DrawList);
                        _ ->
                            FixInitPower = ?IF(ExternalPower == none, MaxCombatPower, ExternalPower),
                            init_combat_welfare_data(PlayerId, PlayerName, FixInitPower)
                    end;
                false -> undefined
            end;
        _ -> undefined
    end.

get_data_from_db(PlayerId) ->
    Sql = io_lib:format(?SQL_GET_COMBAT_WELFARE, [PlayerId]),
    db:get_row(Sql).

make_record(Round, LessTimes, LastIndex, DrawList) ->
    #status_combat_welfare{ round = Round, times = LessTimes, index = LastIndex, reward_list = DrawList }.

%% 根据玩家战力初始化次数等相关数据
init_combat_welfare_data(PlayerId, PlayerName, Power) ->
    AllRound = data_welfare:get_combat_reward_round(),
    case AllRound of
        [] ->
            undefined;
        _ ->
            InitRound = lists:min(AllRound),
            {NewIndex, AddTimes, FromList} = get_combat_welfare_times(Power, 0),
            InitData = make_record(InitRound, AddTimes, NewIndex, []),
            %% 入库保存数据
            save_module_data_in_db(PlayerId, InitData),
            log_times_info(PlayerId, PlayerName, Power, FromList),
            InitData
    end.

%% 根据战力与上一次的下标获取符合战力要求的数据
%% 返回{最新的下标, 增加的抽奖次数, 增加次数的来源}
get_combat_welfare_times(Power, LastIndex) ->
    case data_welfare:list_combat_welfare_times() of
        TimesList when is_list(TimesList) ->
            FixTimesList = lists:nthtail(LastIndex, TimesList),
            Filter = [ I || {CombatCfg, _AddTimes} = I <- FixTimesList, Power >= CombatCfg ],
            case Filter of
                [] ->
                    {LastIndex, 0, []};
                _ ->
                    MaxElem = lists:max(Filter),
                    NewIndex = util:get_list_elem_index(MaxElem, TimesList),
                    SumAddTimes = accumulation_times(Filter, 0),
                    {NewIndex, SumAddTimes, Filter}
            end;
        _ ->
            {LastIndex, 0, []}
    end.

%% 累加器
accumulation_times([], SumTimes) ->
    SumTimes;
accumulation_times([{_CombatCfg, Times}|Tail], SumTimes) ->
    case Times > 0 of
        true ->
            accumulation_times(Tail, SumTimes + Times);
        false ->
            accumulation_times(Tail, SumTimes)
    end.

%% 数据入库
save_module_data_in_db(PlayerId, CombatWelfareData) ->
    #status_combat_welfare{ round = Round, index = Index, times = Times, reward_list = RewardL } = CombatWelfareData,
    Args = [PlayerId, Round, Times, Index, util:term_to_string(RewardL)],
    db:execute(io_lib:format(?SAVE_COMBAT_WELFARE_DATA, Args)).

do_handle_event(Player, CombatPower) ->
    #player_status{id = PlayerId, figure = #figure{name = PlayerName }, combat_welfare = CombatWelfareData } = Player,
    case CombatWelfareData of
        #status_combat_welfare{ times = LessTimes, index = LastIndex } ->
            {NewIndex, AddTimes, FromList} = get_combat_welfare_times(CombatPower, LastIndex),
            case AddTimes > 0 of
                true -> %% 只有次数增加变化时才写库
                    NewCombatWelfareData = CombatWelfareData#status_combat_welfare{ index = NewIndex, times = LessTimes + AddTimes },
                    save_module_data_in_db(PlayerId, NewCombatWelfareData),
                    log_times_info(PlayerId, PlayerName, CombatPower, FromList),
                    NewPlayer = Player#player_status{ combat_welfare = NewCombatWelfareData };
                false ->
                    NewPlayer = Player
            end,
            send_panel_info(NewPlayer),
            NewPlayer;
        _ ->
            Player
    end.

%% 抽奖相关检测
check_can_draw(PS, Round, Times, RewardL) ->
    ?IF( Times > 0, ok, throw({error, ?ERRCODE(err417_not_enough_combat)})),   %% 战力不足
    AllRewardIdL = data_welfare:get_combat_reward_id(Round),
    LastRewardIdL = lists:subtract(AllRewardIdL, RewardL),
    RoundTimes = erlang:length(RewardL),
    Fun = fun(RewardId, AccL) ->
        case data_welfare:get_combat_welfare_round(Round, RewardId) of
            #base_combat_welfare_reward{ weight = WeightInfoL, reward = AwardList, tv_id = TvInfo} ->
                case lists:keyfind(weight, 1, WeightInfoL) of
                    {weight, {Min, Max, BaseRate, AddRate}} ->
                        Rate = ?IF( RoundTimes >= Min andalso RoundTimes =< Max, BaseRate + AddRate, BaseRate),
                        [{Rate, {RewardId, AwardList, TvInfo}}|AccL];
                    _ ->
                        AccL
                end;
            _ -> AccL
        end
    end,
    RandomPool = lists:foldl(Fun, [], LastRewardIdL),
    {RandRewardId, RandRewardList, _RandTvInfo} = urand:rand_with_weight(RandomPool),
    %% 判断背包空间是否足够
    case lib_goods_api:can_give_goods(PS, RandRewardList) of
        true ->
            %% 判断该次是否为该轮最后一次抽奖
            NewRewardL = [RandRewardId|RewardL],
            LastRewardIdL2 = lists:subtract(AllRewardIdL, NewRewardL),
            IsNewRound = LastRewardIdL2 == [],
            {ok, RandRewardList, RandRewardId, IsNewRound};
        _ ->
            {error, ?ERRCODE(err150_no_cell)}  %% 背包空间不足
    end.

%% 获取下一轮数，没有则返回当前轮数
get_next_round(Round) ->
    AllRound = data_welfare:get_combat_reward_round(),
    Filter = [ I || I <- AllRound, I > Round],
    case Filter of
        [] -> {Round, true};
        _ -> {lists:min(Filter), false}
    end.

%% 抽奖次数产出日志
log_times_info(PlayerId, PlayerName, PlayerPower, FromList) ->
    Fun = fun({_Power, AddTimes}) ->
        lib_log_api:log_combat_welfare_times(PlayerId, PlayerName, PlayerPower, AddTimes)
    end,
    lists:foreach(Fun, FromList).

%% 获取下一级达标战力
get_next_combat_condition(Times, Index) ->
    AllTimesCfgL = data_welfare:list_combat_welfare_times(),
    HasDraw = Index - Times,
    Nx = HasDraw + 1,
    case Nx > length(AllTimesCfgL) of
        true ->
            {ConditionPower, _Times} = lists:nth(HasDraw, AllTimesCfgL);
        false ->
            {ConditionPower, _Times} = ?IF(HasDraw == 0, lists:nth(1, AllTimesCfgL), lists:nth(Nx, AllTimesCfgL))
    end,
    ConditionPower.
