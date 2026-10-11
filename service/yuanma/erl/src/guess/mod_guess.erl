%%-----------------------------------------------------------------------------
%% @Module  :       mod_guess
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-06
%% @Description:    竞猜
%%-----------------------------------------------------------------------------

-module(mod_guess).

-include("guess.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-export([
    send_single_guess_info_list/3
    , send_single_guess_bet_info/5
    , single_guess_bet/5
    , send_group_guess_info_list/2
    , send_group_guess_bet_info/3
    , group_guess_bet/4
    , receive_single_guess_reward/4
    , receive_group_guess_reward/3
    , send_guess_bet_record/2
    ]).

-export([
    check_single_guess_bet/5
    , check_group_guess_bet/4
    , auto_send_reward_bf_reload/0
    ]).

-export([
    daily_trigger/0
    , clear_guess_data/1
    , reload/0
    ]).

send_single_guess_info_list(RoleId, GameType, SubType) ->
    gen_server:cast(?MODULE, {'send_single_guess_info_list', RoleId, GameType, SubType}).

send_single_guess_bet_info(RoleId, GameType, SubType, CfgId, SelResult) ->
    gen_server:cast(?MODULE, {'send_single_guess_bet_info', RoleId, GameType, SubType, CfgId, SelResult}).

single_guess_bet(RoleId, Cfg, NeedBetTimes, SelResult, Cost) ->
    gen_server:cast(?MODULE, {'single_guess_bet', RoleId, Cfg, NeedBetTimes, SelResult, Cost}).

send_group_guess_info_list(RoleId, GameType) ->
    gen_server:cast(?MODULE, {'send_group_guess_info_list', RoleId, GameType}).

send_group_guess_bet_info(RoleId, GameType, CfgId) ->
    gen_server:cast(?MODULE, {'send_group_guess_bet_info', RoleId, GameType, CfgId}).

group_guess_bet(RoleId, Cfg, NeedBetTimes, Cost) ->
    gen_server:cast(?MODULE, {'group_guess_bet', RoleId, Cfg, NeedBetTimes, Cost}).

receive_single_guess_reward(RoleId, GameType, SubType, CfgId) ->
    gen_server:cast(?MODULE, {'receive_single_guess_reward', RoleId, GameType, SubType, CfgId}).

receive_group_guess_reward(RoleId, GameType, CfgId) ->
    gen_server:cast(?MODULE, {'receive_group_guess_reward', RoleId, GameType, CfgId}).

send_guess_bet_record(RoleId, GameType) ->
    gen_server:cast(?MODULE, {'send_guess_bet_record', RoleId, GameType}).

daily_trigger() ->
    gen_server:cast(?MODULE, {'daily_trigger'}).

clear_guess_data(ClearTypeL) ->
    gen_server:cast(?MODULE, {'clear_guess_data', ClearTypeL}).

reload() ->
    gen_server:cast(?MODULE, {'reload'}).

check_single_guess_bet(RoleId, GameType, SubType, CfgId, NeedBetTimes) ->
    gen_server:call(?MODULE, {'check_single_guess_bet', RoleId, GameType, SubType, CfgId, NeedBetTimes}, 500).

check_group_guess_bet(RoleId, GameType, CfgId, NeedBetTimes) ->
    gen_server:call(?MODULE, {'check_group_guess_bet', RoleId, GameType, CfgId, NeedBetTimes}, 500).

auto_send_reward_bf_reload() ->
    gen_server:call(?MODULE, {'auto_send_reward_bf_reload'}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_guess:load_data_from_db(#guess_state{}),
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, guess_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'send_single_guess_info_list', RoleId, GameType, SubType}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            IdList = data_extra_guess:get_guess_single_id_list(GameType, SubType),
            F = fun(CfgId, Acc) ->
                case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                    #guess_single_config{
                        cfg_name = CfgName
                        , game_start_time = GameSt
                        , is_show = 1
                        , a_name = AName
                        , a_icon = AIcon
                        , b_name = BName
                        , b_icon = BIcon
                        , a_odds = AOdds
                        , b_odds = BOdds
                        , draw_odds = DrawOdds
                        , result = Result
                        , result_desc = ResultDesc
                    } = Cfg ->
                        {IsHasBet, RewardStatus} = lib_guess:count_single_status(State, RoleId, Cfg, NowTime),
                        [{CfgId, CfgName, GameSt, AName, AIcon, BName, BIcon, AOdds, BOdds, DrawOdds, IsHasBet, Result, ResultDesc, RewardStatus}|Acc];
                    _ ->
                        Acc
                end
            end,
            PackL = lists:foldl(F, [], IdList),
            {ok, BinData} = pt_342:write(34203, [GameType, SubType, Stime, Etime, PackL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, State};

do_handle_cast({'send_single_guess_bet_info', RoleId, GameType, SubType, CfgId, SelResult}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                #guess_single_config{
                    a_name = AName, a_icon = AIcon, a_odds = AOdds,
                    b_name = BName, b_icon = BIcon, b_odds = BOdds,
                    draw_odds = DrawOdds, max_times = MaxBetTimes, result = ?RESULT_NO
                } ->
                    #guess_state{single_map = SingleMap} = State,
                    Key = {GameType, SubType, CfgId},
                    RoleMap = maps:get(Key, SingleMap, #{}),
                    case maps:get(RoleId, RoleMap, false) of
                        #guess_single{times = BetTimes} -> ok;
                        false -> BetTimes = 0
                    end,
                    case SelResult of
                        ?RESULT_WIN ->
                            Odds = AOdds;
                        ?RESULT_LOSE ->
                            Odds = BOdds;
                        _ ->
                            Odds = DrawOdds
                    end,
                    {ok, BinData} = pt_342:write(34204, [GameType, SubType, CfgId, AName, AIcon, BName, BIcon, BetTimes, MaxBetTimes, SelResult, Odds]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                #guess_single_config{} ->
                    lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_has_result));
                _ ->
                    lib_guess:send_error_code(RoleId, ?ERRCODE(missing_config))
            end;
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, State};

do_handle_cast({'single_guess_bet', RoleId, Cfg, NeedBetTimes, SelResult, Cost}, State) ->
    #guess_single_config{id = CfgId, game_type = GameType, subtype = SubType, a_odds = AOdds, b_odds = BOdds, draw_odds = DrawOdds} = Cfg,
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            #guess_state{single_map = SingleMap, record_map = RecordMap} = State,
            Key = {GameType, SubType, CfgId},
            RoleMap = maps:get(Key, SingleMap, #{}),
            RoleData = maps:get(RoleId, RoleMap, #guess_single{key = Key, role_id = RoleId}),
            #guess_single{times = BetTimes, odds_list = OddsList} = RoleData,
            case SelResult of
                ?RESULT_WIN ->
                    CurOdds = AOdds,
                    NewOddsList = [{AOdds, NeedBetTimes, SelResult}|OddsList];
                ?RESULT_LOSE ->
                    CurOdds = BOdds,
                    NewOddsList = [{BOdds, NeedBetTimes, SelResult}|OddsList];
                ?RESULT_DRAW ->
                    CurOdds = DrawOdds,
                    NewOddsList = [{DrawOdds, NeedBetTimes, SelResult}|OddsList];
                _ ->
                    CurOdds = 0,
                    NewOddsList = OddsList
            end,
            NewRoleData = RoleData#guess_single{times = BetTimes + NeedBetTimes, odds_list = NewOddsList, time = NowTime},
            NewRoleMap = maps:put(RoleId, NewRoleData, RoleMap),
            NewSingleMap = maps:put(Key, NewRoleMap, SingleMap),
            BetRecordL = maps:get(RoleId, RecordMap, []),
            case lists:keyfind({?GUESS_TYPE_SINGLE, GameType, SubType, CfgId, CurOdds}, #bet_record.key, BetRecordL) of
                #bet_record{times = PreBetTimes} -> skip;
                _ -> PreBetTimes = 0
            end,
            BetRecord = lib_guess:make_record(bet_record, [?GUESS_TYPE_SINGLE, GameType, SubType, CfgId, PreBetTimes + NeedBetTimes, CurOdds, SelResult, NowTime]),
            NewBetRecordL = lists:keystore({?GUESS_TYPE_SINGLE, GameType, SubType, CfgId, CurOdds}, #bet_record.key, BetRecordL, BetRecord),
            NewRecordMap = maps:put(RoleId, NewBetRecordL, RecordMap),
            NewState = State#guess_state{single_map = NewSingleMap, record_map = NewRecordMap},

            lib_guess:save_role_single_guess_data(NewRoleData),
            catch db:execute(io_lib:format(?sql_insert_guess_bet_record, [RoleId, ?GUESS_TYPE_SINGLE, GameType, SubType, CfgId, PreBetTimes + NeedBetTimes, CurOdds, SelResult, NowTime])),
            %% 日志
            lib_log_api:log_single_guess_bet(RoleId, GameType, SubType, CfgId, BetTimes + NeedBetTimes, NeedBetTimes, CurOdds, SelResult, Cost, NowTime),

            {ok, BinData} = pt_342:write(34205, [?SUCCESS, GameType, SubType, CfgId, BetTimes + NeedBetTimes]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            NewState = State,
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, NewState};

do_handle_cast({'send_group_guess_info_list', RoleId, GameType}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            GroupType = ?GUESS_GROUP_TYPE_WINNER,
            IdList = data_extra_guess:get_guess_group_id_list_by_group_type(GameType, GroupType),
            F = fun(CfgId) ->
                Cfg = data_extra_guess:get_guess_group(GameType, CfgId),
                #guess_group_config{name = Name, icon = Icon, odds = Odds, guess_start_time = _GuessSt, guess_end_time = _GuessEt, result = Result} = Cfg,
                {IsHasBet, Status} = lib_guess:count_group_status(State, RoleId, Cfg, NowTime),
                #guess_state{group_map = GroupMap} = State,
                Key = {GameType, CfgId},
                RoleMap = maps:get(Key, GroupMap, #{}),
                % {RealGuessSt, RealGuessEt} = lib_guess:count_group_guess_time_range(GameType, GuessSt, GuessEt),
                % case maps:get(RoleId, RoleMap, false) of
                %     #guess_group{time = Time} when Time >= RealGuessSt andalso Time < RealGuessEt -> skip;
                %     _ -> Time= 0
                % end,
                {CfgId, Name, Icon, Odds, IsHasBet, Result, Status, maps:size(RoleMap)}
            end,
            PackL = lists:map(F, IdList),
            {ok, BinData} = pt_342:write(34206, [GameType, Stime, Etime, PackL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, State};

do_handle_cast({'send_group_guess_bet_info', RoleId, GameType, CfgId}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_group(GameType, CfgId) of
                #guess_group_config{
                    name = Name,
                    icon = Icon,
                    odds = Odds,
                    max_times = MaxBetTimes,
                    result = ?RESULT_NO
                } ->
                    #guess_state{group_map = GroupMap} = State,
                    Key = {GameType, CfgId},
                    RoleMap = maps:get(Key, GroupMap, #{}),
                    case maps:get(RoleId, RoleMap, false) of
                        #guess_group{times = BetTimes, odds_list = OddsList} -> ok;
                        false -> BetTimes = 0, OddsList = []
                    end,
                    {ok, BinData} = pt_342:write(34207, [GameType, CfgId, Name, Icon, BetTimes, MaxBetTimes, Odds, OddsList]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                #guess_group_config{} ->
                    lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_has_result));
                _ ->
                    lib_guess:send_error_code(RoleId, ?ERRCODE(missing_config))
            end;
        _ ->
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, State};

do_handle_cast({'group_guess_bet', RoleId, Cfg, NeedBetTimes, Cost}, State) ->
    #guess_group_config{id = CfgId, game_type = GameType, odds = Odds} = Cfg,
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            #guess_state{group_map = GroupMap, record_map = RecordMap} = State,
            Key = {GameType, CfgId},
            RoleMap = maps:get(Key, GroupMap, #{}),
            RoleData = maps:get(RoleId, RoleMap, #guess_group{key = Key, role_id = RoleId}),
            #guess_group{times = BetTimes, odds_list = OddsList} = RoleData,
            % NewOddsList = [{Odds, NeedBetTimes}|OddsList],
            case lists:keyfind(Odds, 1, OddsList) of
                {Odds, PreTimes} ->
                    NewOddsList = lists:keystore(Odds, 1, OddsList, {Odds, PreTimes + NeedBetTimes});
                _ ->
                    NewOddsList = [{Odds, NeedBetTimes}|OddsList]
            end,
            NewRoleData = RoleData#guess_group{times = BetTimes + NeedBetTimes, odds_list = NewOddsList, time = NowTime},
            NewRoleMap = maps:put(RoleId, NewRoleData, RoleMap),
            NewGroupMap = maps:put(Key, NewRoleMap, GroupMap),
            BetRecordL = maps:get(RoleId, RecordMap, []),
            case lists:keyfind({?GUESS_TYPE_GROUP, GameType, 0, CfgId, Odds}, #bet_record.key, BetRecordL) of
                #bet_record{times = PreBetTimes} -> skip;
                _ -> PreBetTimes = 0
            end,
            BetRecord = lib_guess:make_record(bet_record, [?GUESS_TYPE_GROUP, GameType, 0, CfgId, PreBetTimes + NeedBetTimes, Odds, 0, NowTime]),
            NewBetRecordL = lists:keystore({?GUESS_TYPE_GROUP, GameType, 0, CfgId, Odds}, #bet_record.key, BetRecordL, BetRecord),
            NewRecordMap = maps:put(RoleId, NewBetRecordL, RecordMap),
            NewState = State#guess_state{group_map = NewGroupMap, record_map = NewRecordMap},

            lib_guess:save_role_group_guess_data(NewRoleData),
            catch db:execute(io_lib:format(?sql_insert_guess_bet_record, [RoleId, ?GUESS_TYPE_GROUP, GameType, 0, CfgId, PreBetTimes + NeedBetTimes, Odds, 0, NowTime])),
            %% 日志
            lib_log_api:log_group_guess_bet(RoleId, GameType, CfgId, BetTimes + NeedBetTimes, NeedBetTimes, Odds, Cost, NowTime),

            {ok, BinData} = pt_342:write(34208, [?SUCCESS, GameType, CfgId, BetTimes + NeedBetTimes, maps:size(NewRoleMap)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            NewState = State,
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, NewState};

do_handle_cast({'receive_single_guess_reward', RoleId, GameType, SubType, CfgId}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                #guess_single_config{result = Result} = Cfg when Result =/= ?RESULT_NO ->
                    case lib_guess:count_single_status(State, RoleId, Cfg, NowTime) of
                        {_IsHasBet, ?GUESS_CAN_GET} ->
                            ErrCode = ?SUCCESS,
                            #guess_state{single_map = SingleMap} = State,
                            Key = {GameType, SubType, CfgId},
                            RoleMap = maps:get(Key, SingleMap, #{}),
                            #guess_single{
                                odds_list = OddsList
                            } = RoleData = maps:get(RoleId, RoleMap),

                            NewRoleData = RoleData#guess_single{reward_status = ?HAS_RECEIVE, time = NowTime},
                            NewRoleMap = maps:put(RoleId, NewRoleData, RoleMap),
                            NewSingleMap = maps:put(Key, NewRoleMap, SingleMap),
                            NewState = State#guess_state{single_map = NewSingleMap},
                            lib_guess:save_role_single_guess_data(NewRoleData),

                            CostPrice = lib_guess:get_cost_price(GameType),
                            RewardNum = lib_guess:count_single_guess_reward(OddsList, Result, CostPrice, 0),

                            Reward = [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, RewardNum}],
                            %% 日志
                            lib_log_api:log_guess_reward(RoleId, GameType, 1, CfgId, 1, Reward, NowTime),

                            Produce = lib_goods_api:make_produce(guess_reward, GameType, utext:get(203), utext:get(204), Reward, 1),
                            lib_goods_api:send_reward_with_mail(RoleId, Produce);
                        {_IsHasBet, ?GUESS_HAVE_GET} ->
                            NewState = State,
                            ErrCode = ?ERRCODE(err342_guess_reward_has_receive);
                        _ ->
                            NewState = State,
                            ErrCode = ?ERRCODE(err342_guess_cant_receive)
                    end;
                #guess_single_config{} ->
                    NewState = State,
                    ErrCode = ?ERRCODE(err342_guess_cant_receive_cuz_no_result);
                _ ->
                    NewState = State,
                    ErrCode = ?ERRCODE(missing_config)
            end,
            {ok, BinData} = pt_342:write(34209, [ErrCode, GameType, SubType, CfgId]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            NewState = State,
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, NewState};

do_handle_cast({'receive_group_guess_reward', RoleId, GameType, CfgId}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_group(GameType, CfgId) of
                #guess_group_config{result = Result} = Cfg when Result =/= ?RESULT_NO ->
                    case lib_guess:count_group_status(State, RoleId, Cfg, NowTime) of
                        {_IsHasBet, ?GUESS_CAN_GET} ->
                            ErrCode = ?SUCCESS,
                            #guess_state{group_map = GroupMap} = State,
                            Key = {GameType, CfgId},
                            RoleMap = maps:get(Key, GroupMap, #{}),
                            #guess_group{
                                odds_list = OddsList
                            } = RoleData = maps:get(RoleId, RoleMap),

                            NewRoleData = RoleData#guess_group{reward_status = ?HAS_RECEIVE, time = NowTime},
                            NewRoleMap = maps:put(RoleId, NewRoleData, RoleMap),
                            NewGroupMap = maps:put(Key, NewRoleMap, GroupMap),
                            NewState = State#guess_state{group_map = NewGroupMap},
                            lib_guess:save_role_group_guess_data(NewRoleData),

                            CostPrice = lib_guess:get_cost_price(GameType),
                            RewardNum = lib_guess:count_group_guess_reward(OddsList, CostPrice, 0),

                            Reward = [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, RewardNum}],
                            %% 日志
                            lib_log_api:log_guess_reward(RoleId, GameType, 2, CfgId, 1, Reward, NowTime),

                            Produce = lib_goods_api:make_produce(guess_reward, GameType, utext:get(203), utext:get(204), Reward, 1),
                            lib_goods_api:send_reward_with_mail(RoleId, Produce);
                        {_IsHasBet, ?GUESS_HAVE_GET} ->
                            NewState = State,
                            ErrCode = ?ERRCODE(err342_guess_reward_has_receive);
                        _ ->
                            NewState = State,
                            ErrCode = ?ERRCODE(err342_guess_cant_receive)
                    end;
                #guess_group_config{} ->
                    NewState = State,
                    ErrCode = ?ERRCODE(err342_guess_cant_receive_cuz_no_result);
                _ ->
                    NewState = State,
                    ErrCode = ?ERRCODE(missing_config)
            end,
            {ok, BinData} = pt_342:write(34210, [ErrCode, GameType, CfgId]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            NewState = State,
            lib_guess:send_error_code(RoleId, ?ERRCODE(err342_guess_act_close))
    end,
    {ok, NewState};

do_handle_cast({'send_guess_bet_record', RoleId, GameType}, State) ->
    #guess_state{record_map = RecordMap} = State,
    CostPrice = lib_guess:get_cost_price(GameType),
    {Stime, Etime} = lib_guess:get_act_time(GameType),
    NowTime = utime:unixtime(),
    RecordL = maps:get(RoleId, RecordMap, []),
    F = fun(A, B) ->
        A#bet_record.time > B#bet_record.time
    end,
    SortRecordL = lists:sort(F, RecordL),
    PackL = lib_guess:pack_record_list(SortRecordL, NowTime, Stime, Etime, CostPrice, 0, []),
    {ok, BinData} = pt_342:write(34212, [PackL]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'daily_trigger'}, State) ->
    #guess_state{single_map = SingleMap, group_map = GroupMap} = State,
    GameTypeList = data_extra_guess:get_guess_game_type_list(),
    NowTime = utime:unixtime(),
    F = fun(GameType, {EndTypeL, ClearTypeL}) ->
        case data_extra_guess:get_guess_info(GameType) of
            #guess_info_config{end_time = Etime, clear_time = ClearTime} ->
                case ClearTime =< 0 of
                    true ->
                        RealClearTime = Etime + 2 * 86400;
                    _ ->
                        RealClearTime = ClearTime
                end,
                case abs(NowTime - (utime:unixdate(Etime) + 86400)) < 600 of
                    true ->
                        NewEndTypeL = [GameType|EndTypeL];
                    _ ->
                        NewEndTypeL = EndTypeL
                end,
                case abs(NowTime - (utime:unixdate(RealClearTime) + 86400)) < 600 of
                    true ->
                        NewClearTypeL = [GameType|ClearTypeL];
                    _ ->
                        NewClearTypeL = ClearTypeL
                end,
                {NewEndTypeL, NewClearTypeL}
        end
    end,
    {EndTypeL, ClearTypeL} = lists:foldl(F, {[], []}, GameTypeList),
    case ClearTypeL =/= [] of
        true ->
            spawn(fun() -> util:multiserver_delay(1, ?MODULE, clear_guess_data, [ClearTypeL]) end);
        _ -> skip
    end,
    case EndTypeL =/= [] of
        true ->
            spawn(fun() -> util:multiserver_delay(1, lib_guess, auto_send_unreceive_reward, [SingleMap, GroupMap, EndTypeL]) end);
        _ -> skip
    end,
    {ok, State};

do_handle_cast({'clear_guess_data', ClearTypeL}, State) ->
    #guess_state{single_map = SingleMap, group_map = GroupMap} = State,
    F = fun(Key, _) ->
        case Key of
            {GameType, _, _} ->
                not lists:member(GameType, ClearTypeL);
            _ -> false
        end
    end,
    NewSingleMap = maps:filter(F, SingleMap),
    F1 = fun(Key, _) ->
        case Key of
            {GameType, _} ->
                not lists:member(GameType, ClearTypeL);
            _ -> false
        end
    end,
    NewGroupMap = maps:filter(F1, GroupMap),
    NewState = State#guess_state{single_map = NewSingleMap, group_map = NewGroupMap},
    db:execute(io_lib:format(?sql_guess_single_delete, [util:link_list(ClearTypeL)])),
    db:execute(io_lib:format(?sql_guess_group_delete, [util:link_list(ClearTypeL)])),
    db:execute(io_lib:format(?sql_delete_guess_bet_record, [util:link_list(ClearTypeL)])),
    {ok, NewState};

do_handle_cast({'reload'}, State) ->
    NewState = lib_guess:load_data_from_db(State),
    {ok, NewState};
    
do_handle_cast(_Msg, State) ->
    {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, guess_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Msg:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Msg, State) ->
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'check_single_guess_bet', RoleId, GameType, SubType, CfgId, NeedBetTimes}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                #guess_single_config{max_times = MaxBetTimes, game_start_time = GameSt, guess_end_time = GuessEt, result = Result, is_show = 1} = Cfg ->
                    #guess_state{single_map = SingleMap} = State,
                    Key = {GameType, SubType, CfgId},
                    RoleMap = maps:get(Key, SingleMap, #{}),
                    case maps:get(RoleId, RoleMap, false) of
                        #guess_single{times = BetTimes} -> ok;
                        false -> BetTimes = 0
                    end,
                    NewBetTimes = BetTimes + NeedBetTimes,
                    case NewBetTimes =< MaxBetTimes of
                        true ->
                            case Result of
                                ?RESULT_NO ->
                                    RealGuessEt = lib_guess:count_single_guess_end_time(GameType, GameSt, GuessEt),
                                    case NowTime < RealGuessEt of
                                        true ->
                                            {ok, {ok, Cfg}};
                                        _ ->
                                            {ok, {false, ?ERRCODE(err342_guess_not_in_bet_time)}}
                                    end;
                                _ ->
                                    {ok, {false, ?ERRCODE(err342_guess_not_in_bet_time)}}
                            end;
                        _ ->
                            {ok, {false, ?ERRCODE(err342_guess_bet_times_lim)}}
                    end;
                _ ->
                    {ok, {false, ?ERRCODE(missing_config)}}
            end;
        _ ->
            {ok, {false, ?ERRCODE(err342_guess_act_close)}}
    end;

do_handle_call({'check_group_guess_bet', RoleId, GameType, CfgId, NeedBetTimes}, State) ->
    NowTime = utime:unixtime(),
    case lib_guess:get_act_time(GameType) of
        {Stime, Etime} when NowTime >= Stime andalso NowTime =< Etime ->
            case data_extra_guess:get_guess_group(GameType, CfgId) of
                #guess_group_config{max_times = MaxBetTimes, guess_start_time = GuessSt, guess_end_time = GuessEt, result = Result} = Cfg ->
                    #guess_state{group_map = GroupMap} = State,
                    Key = {GameType, CfgId},
                    RoleMap = maps:get(Key, GroupMap, #{}),
                    case maps:get(RoleId, RoleMap, false) of
                        #guess_group{times = BetTimes} -> ok;
                        false -> BetTimes = 0
                    end,
                    NewBetTimes = BetTimes + NeedBetTimes,
                    case NewBetTimes =< MaxBetTimes of
                        true ->
                            case Result of
                                ?RESULT_NO ->
                                    RealGuessEt = lib_guess:count_group_guess_time_range(GameType, GuessSt, GuessEt),
                                    case NowTime < RealGuessEt of
                                        true ->
                                            {ok, {ok, Cfg}};
                                        _ ->
                                            {ok, {false, ?ERRCODE(err342_guess_not_in_bet_time)}}
                                    end;
                                ?RESULT_LOSE ->
                                    {ok, {false, ?ERRCODE(err342_guess_group_is_lose)}};
                                _ ->
                                    {ok, {false, ?ERRCODE(err342_guess_not_in_bet_time)}}
                            end;
                        _ ->
                            {ok, {false, ?ERRCODE(err342_guess_bet_times_lim)}}
                    end;
                _ ->
                    {ok, {false, ?ERRCODE(missing_config)}}
            end;
        _ ->
            {ok, {false, ?ERRCODE(err342_guess_act_close)}}
    end;

%% 在重新加载活动数据的时候要把玩家之前未领取的奖励自动发给玩家
do_handle_call({'auto_send_reward_bf_reload'}, State) ->
    #guess_state{single_map = SingleMap} = State,
    NowTime = utime:unixtime(),
    lib_guess:auto_send_reward_bf_reload(SingleMap, NowTime),
    NewState = lib_guess:load_data_from_db(State),
    % NewState = State#guess_state{single_map = NewSingleMap},
    {ok, ok, NewState};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
