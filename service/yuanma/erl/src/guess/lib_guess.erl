%%-----------------------------------------------------------------------------
%% @Module  :       lib_guess
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-06
%% @Description:    竞猜
%%-----------------------------------------------------------------------------

-module(lib_guess).

-compile(export_all).

-export([]).

-include("server.hrl").
-include("guess.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("def_goods.hrl").

%% 获得基本消耗
count_cost(?GAME_TYPE_WORLD_CUP, Times) -> [{0, 38180010, Times}];
count_cost(_, _) -> [].

get_cost_price(?GAME_TYPE_WORLD_CUP) ->
    case data_goods:get_goods_buy_price(38180010) of
        {_, Price} -> Price;
        _ -> 0
    end;
get_cost_price(_) -> 0.

get_open_lv(GameType) ->
    case data_extra_guess:get_guess_info(GameType) of
        #guess_info_config{
            open_lv = OpenLv
        } ->
            OpenLv;
        _ ->
            999999999999999999
    end.

%% @return GuessEt
%% 默认十分钟前
get_default_single_guess_end_time(?GAME_TYPE_WORLD_CUP, GameSt) ->
    Diff = 300,
    max(0, GameSt-Diff);
get_default_single_guess_end_time(_GameType, GameSt) ->
    GameSt.

%% @return {St, Et}
%% 比赛类型(1:欧洲杯)
get_default_group_guess_time_range(?GAME_TYPE_WORLD_CUP) ->
    % 每天11：00-20：50为冠军竞猜开放时间
    {H1, M1, S1} = {11, 0, 0},
    {H2, M2, S2} = {20, 50, 0},
    NowDate = util:unixdate(),
    StartTime = NowDate + H1*3600 + M1*60 + S1,
    EndTime = NowDate + H2*3600 + M2*60 + S2,
    {StartTime, EndTime};
get_default_group_guess_time_range(_GameType) ->
    {0, 0}.

make_record(guess_single, [RoleId, GameType, SubType, CfgId, Times, OddsList, RewardStatus, IsTimeOut, Time]) ->
    #guess_single{
        key = {GameType, SubType, CfgId},
        role_id = RoleId,
        times = Times,
        odds_list = OddsList,
        reward_status = RewardStatus,
        is_timeout = IsTimeOut,
        time = Time
    };
make_record(guess_group, [RoleId, GameType, CfgId, Times, OddsList, RewardStatus, IsTimeOut, Time]) ->
    #guess_group{
        key = {GameType, CfgId},
        role_id = RoleId,
        times = Times,
        odds_list = OddsList,
        reward_status = RewardStatus,
        is_timeout = IsTimeOut,
        time = Time
    };
make_record(bet_record, [Type, GameType, SubType, CfgId, Times, Odds, SelResult, Time]) ->
    #bet_record{
        key = {Type, GameType, SubType, CfgId, Odds},
        type = Type,
        game_type = GameType,
        subtype = SubType,
        cfg_id = CfgId,
        times = Times,
        odds = Odds,
        sel_result = SelResult,
        time = Time
    }.

load_data_from_db(State) ->
    List = db:get_all(?sql_guess_single_select),
    F = fun([RoleId, GameType, SubType, CfgId, Times, OddsListBin, RewardStatus, IsTimeOut, Time], Map) ->
        case lib_guess:get_act_time(GameType) of
            {Stime, Etime} when Time >= Stime andalso Time =< Etime ->
                OddsList = util:bitstring_to_term(OddsListBin),
                Record = lib_guess:make_record(guess_single, [RoleId, GameType, SubType, CfgId, Times, OddsList, RewardStatus, IsTimeOut, Time]),
                RoleMap = maps:get({GameType, SubType, CfgId}, Map, #{}),
                NewRoleMap = maps:put(RoleId, Record, RoleMap),
                maps:put({GameType, SubType, CfgId}, NewRoleMap, Map);
            _ -> Map
        end
    end,
    SingleMap = lists:foldl(F, #{}, List),
    List1 = db:get_all(?sql_guess_group_select),
    F1 = fun([RoleId, GameType, CfgId, Times, OddsListBin, RewardStatus, IsTimeOut, Time], Map) ->
        case lib_guess:get_act_time(GameType) of
            {Stime, Etime} when Time >= Stime andalso Time =< Etime ->
                OddsList = util:bitstring_to_term(OddsListBin),
                Record = lib_guess:make_record(guess_group, [RoleId, GameType, CfgId, Times, OddsList, RewardStatus, IsTimeOut, Time]),
                RoleMap = maps:get({GameType, CfgId}, Map, #{}),
                NewRoleMap = maps:put(RoleId, Record, RoleMap),
                maps:put({GameType, CfgId}, NewRoleMap, Map);
            _ -> Map
        end
    end,
    GroupMap = lists:foldl(F1, #{}, List1),
    List2 = db:get_all(?sql_select_guess_bet_record),
    F2 = fun([RoleId, Type, GameType, SubType, CfgId, Times, Odds, SelResult, Time], Map) ->
        Record = lib_guess:make_record(bet_record, [Type, GameType, SubType, CfgId, Times, Odds, SelResult, Time]),
        RecordL = maps:get(RoleId, Map, []),
        maps:put(RoleId, [Record|RecordL], Map)
    end,
    RecordMap = lists:foldl(F2, #{}, List2),
    State#guess_state{single_map = SingleMap, group_map = GroupMap, record_map = RecordMap}.
count_single_status(State, RoleId, Cfg, NowTime) ->
    #guess_state{single_map = SingleMap} = State,
    #guess_single_config{id = CfgId, game_type = GameType, subtype = SubType, game_start_time = GameSt, guess_end_time = GuessEt, result = Result} = Cfg,
    Key = {GameType, SubType, CfgId},
    {Stime, Etime} = get_act_time(GameType),
    RoleMap = maps:get(Key, SingleMap, #{}),
    case maps:get(RoleId, RoleMap, false) of
        #guess_single{
            reward_status = RewardStatus,
            odds_list = OddsList,
            is_timeout = IsTimeOut,
            time = Time
        } when Time >= Stime, Time < Etime ->
            IsHasBet = 1;
        _ ->
            IsHasBet = 0,
            IsTimeOut = 0,
            RewardStatus = ?NO_REWARD,
            OddsList = []
    end,
    % 是否中奖
    case lists:keyfind(Result, 3, OddsList) of
        false -> IsWin = 0;
        _ -> IsWin = 1
    end,
    RealGuessEt = count_single_guess_end_time(GameType, GameSt, GuessEt),
    Status = if
        % 4:已经领取
        RewardStatus == ?HAS_RECEIVE -> ?GUESS_HAVE_GET;
        IsTimeOut == 1 andalso IsWin == 1 -> ?GUESS_HAVE_GET;
        % 2:可以领取
        Result =/= ?RESULT_NO andalso IsWin == 1 -> ?GUESS_CAN_GET;
        % 3:未中奖
        Result =/= ?RESULT_NO andalso IsWin == 0 -> ?GUESS_CAN_NOT_GET;
        % 0:押注期间
        Result == ?RESULT_NO andalso NowTime < RealGuessEt -> ?GUESS_BUY;
        % 1:等待开奖(停止押注)
        true -> ?GUESS_STOP
    end,
    {IsHasBet, Status}.

%% 计算单场竞猜的结束时间
count_single_guess_end_time(GameType, GameSt, 0) ->
    get_default_single_guess_end_time(GameType, GameSt);
count_single_guess_end_time(GameType, GameSt, GuessEt) ->
    % 开始时间一定比当前时间大
    case GameSt > GuessEt of
        true -> GuessEt;
        false -> get_default_single_guess_end_time(GameType, GameSt)
    end.

count_single_guess_reward([], _Result, _Price, RewardNum) -> round(RewardNum);
count_single_guess_reward([T|L], Result, Price, RewardNum) ->
    case T of
        {Odds, Times, Result} ->
            count_single_guess_reward(L, Result, Price, RewardNum + util:ceil(Price * Odds / 100 * Times));
        _ ->
            count_single_guess_reward(L, Result, Price, RewardNum)
    end.

count_group_status(State, RoleId, Cfg, NowTime) ->
    #guess_state{group_map = GroupMap} = State,
    #guess_group_config{id = CfgId, game_type = GameType, guess_start_time = GuessSt, guess_end_time = GuessEt, result = Result} = Cfg,
    Key = {GameType, CfgId},
    {Stime, Etime} = get_act_time(GameType),
    RoleMap = maps:get(Key, GroupMap, #{}),
    case maps:get(RoleId, RoleMap, false) of
        #guess_group{
            reward_status = RewardStatus,
            odds_list = _OddsList,
            is_timeout = IsTimeOut,
            time = Time
        } when Time >= Stime, Time < Etime ->
            IsHasBet = 1;
        _ ->
            IsTimeOut = 0,
            IsHasBet = 0,
            RewardStatus = ?NO_REWARD,
            _OddsList = []
    end,
    {RealGuessSt, RealGuessEt} = count_group_guess_time_range(GameType, GuessSt, GuessEt),
    Status = if
        % 4:已经领取
        RewardStatus == ?HAS_RECEIVE -> ?GUESS_HAVE_GET;
        IsTimeOut == 1 andalso IsHasBet == 1 -> ?GUESS_HAVE_GET;
        % 2:可以领取
        Result == ?RESULT_WIN andalso IsHasBet == 1 -> ?GUESS_CAN_GET;
        % 3:未中奖
        Result == ?RESULT_WIN andalso IsHasBet == 0 -> ?GUESS_CAN_NOT_GET;
        % 5:被淘汰
        Result == ?RESULT_LOSE -> ?GUESS_OBSOLETE;
        % 0:押注期间
        Result == ?RESULT_NO andalso NowTime >= RealGuessSt andalso NowTime < RealGuessEt -> ?GUESS_BUY;
        % 1:等待开奖(停止押注)
        true -> ?GUESS_STOP
    end,
    {IsHasBet, Status}.

%% 计算竞猜的时间范围
count_group_guess_time_range(GameType, 0, 0) -> get_default_group_guess_time_range(GameType);
count_group_guess_time_range(_GameType, GuessSt, GuessEt) -> {GuessSt, GuessEt}.

count_group_guess_reward([], _Price, RewardNum) -> round(RewardNum);
count_group_guess_reward([T|L], Price, RewardNum) ->
    case T of
        {Odds, Times} ->
            count_group_guess_reward(L, Price, RewardNum + util:ceil(Price * Odds / 100 * Times));
        _ ->
            count_group_guess_reward(L, Price, RewardNum)
    end.

get_open_act_list() ->
    GameTypeList = data_extra_guess:get_guess_game_type_list(),
    do_get_open_act_list(GameTypeList, utime:unixtime(), []).

do_get_open_act_list([], _UnixTime, List) -> List;
do_get_open_act_list([GameType|GameTypeList], UnixTime, List) ->
    Cfg = data_extra_guess:get_guess_info(GameType),
    #guess_info_config{
        open_lv = OpenLv,
        start_time = StartTime,
        end_time = EndTime
    } = Cfg,
    case UnixTime >= StartTime andalso UnixTime < EndTime of
        true -> NewList = [{GameType, OpenLv, StartTime, EndTime}|List];
        false -> NewList = List
    end,
    do_get_open_act_list(GameTypeList, UnixTime, NewList).

get_open_act_subtype_list(GameType) ->
    SubTypeList = data_extra_guess:get_guess_subtype_list(GameType),
    SubTypeList.

pack_record_list(_, _NowTime, _Stime, _Etime, _CostPrice, Len, Acc) when Len >= 50 -> lists:reverse(Acc);
pack_record_list([], _NowTime, _Stime, _Etime, _CostPrice, _Len, Acc) -> lists:reverse(Acc);
pack_record_list([T|L], NowTime, Stime, Etime, CostPrice, Len, Acc) ->
    case T of
        #bet_record{
            type = Type,
            game_type = GameType,
            subtype = SubType,
            cfg_id = CfgId,
            times = Times,
            odds = Odds,
            sel_result = SelResult,
            time = Time
        } ->
            case Time >= Stime andalso Time =< Etime of
                true ->
                    case Type of
                        ?GUESS_TYPE_SINGLE -> %% 单场竞猜
                            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                                #guess_single_config{
                                    cfg_desc = CfgDesc,
                                    result = Result
                                } ->
                                    case Result == ?RESULT_NO orelse NowTime - Time < 7 * 86400 of
                                        true -> %% 未出结果直接显示
                                            NewLen = Len + 1,
                                            RewardNum = lib_guess:count_single_guess_reward([{Odds, Times, SelResult}], SelResult, CostPrice, 0),
                                            NewAcc = [{Type, CfgDesc, Times, Odds, SelResult, RewardNum, Time}|Acc];
                                        _ ->
                                            NewLen = Len,
                                            NewAcc = Acc
                                    end;
                                _ ->
                                    NewLen = Len,
                                    NewAcc = Acc
                            end;
                        ?GUESS_TYPE_GROUP ->
                            case data_extra_guess:get_guess_group(GameType, CfgId) of
                                #guess_group_config{
                                    name = CfgName,
                                    result = Result
                                } ->
                                    case Result == ?RESULT_NO orelse NowTime - Time < 7 * 86400 of
                                        true ->
                                            NewLen = Len + 1,
                                            RewardNum = lib_guess:count_group_guess_reward([{Odds, Times}], CostPrice, 0),
                                            NewAcc = [{Type, CfgName, Times, Odds, SelResult, RewardNum, Time}|Acc];
                                        _ ->
                                            NewLen = Len,
                                            NewAcc = Acc
                                    end;
                                _ ->
                                    NewLen = Len,
                                    NewAcc = Acc
                            end;
                        _ ->
                            NewLen = Len,
                            NewAcc = Acc
                    end;
                _ ->
                    NewLen = Len,
                    NewAcc = Acc
            end;
        _ ->
            NewLen = Len,
            NewAcc = Acc
    end,
    pack_record_list(L, NowTime, Stime, Etime, CostPrice, NewLen, NewAcc).

auto_send_reward_bf_reload(SingleMap, NowTime) ->
    %% 先统一更新数据库的领取状态，在处理内存数据
    %% 如果加载前是没有出结果的表示这次加载时更新比赛结果
    %% 如果加载前是已经出了结果的表示这次加载时更新赛事
    F = fun(T, Acc) ->
        case T of
            {{GameType, SubType, CfgId}, _} ->
                case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                    #guess_single_config{result = Result, is_show = 1} when Result =/= ?RESULT_NO ->
                        case Acc == "" of
                            true ->
                                lists:concat(["(", GameType, ",", SubType, ",", CfgId, ")"]);
                            _ ->
                                lists:concat([Acc, ", (", GameType, ",", SubType, ",", CfgId, ")"])
                        end;
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
    end,
    SingleL = maps:to_list(SingleMap),
    UpdateL = lists:foldl(F, "", SingleL),
    case UpdateL =/= "" of
        true ->
            db:execute(io_lib:format(?sql_guess_single_auto_send_reward_bf_reload, [1, UpdateL])),
            case catch count_auto_send_reward(SingleL, NowTime, []) of
                {ok, RewardL} ->
                    spawn(fun() -> util:multiserver_delay(5, lib_guess, auto_send_reward, [RewardL, NowTime, 1]) end);
                _Err ->
                    ?ERR("auto_send_reward_bf_reload err:~p single_map:~p", [_Err, SingleL])
            end;
        _ -> skip
    end.

count_auto_send_reward([], _, Acc) -> {ok, Acc};
count_auto_send_reward([{{GameType, _SubType, _CfgId}, RoleMap}|L], NowTime, Acc) ->
    {Stime, Etime} = get_act_time(GameType),
    NewAcc = do_count_auto_send_reward(maps:values(RoleMap), NowTime, Stime, Etime, Acc),
    count_auto_send_reward(L, NowTime, NewAcc).

do_count_auto_send_reward([], _, _, _,  Acc) -> Acc;
do_count_auto_send_reward([T|L], NowTime, Stime, Etime, Acc) ->
    case T of
        #guess_single{
            key = {GameType, SubType, CfgId},
            role_id = RoleId,
            reward_status = RewardStatus,
            odds_list = OddsList,
            is_timeout = 0, %% TimeOut为1表示奖励已经被系统自动发送了
            time = Time
        } when RewardStatus =/= ?HAS_RECEIVE, Time >= Stime, Time =< Etime ->
            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                #guess_single_config{result = Result, is_show = 1, cfg_desc = CfgDesc} when Result =/= ?RESULT_NO ->
                    CostPrice = lib_guess:get_cost_price(GameType),
                    RewardNum = lib_guess:count_single_guess_reward(OddsList, Result, CostPrice, 0),
                    case RewardNum > 0 of
                        true ->
                            Reward = [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, RewardNum}],
                            do_count_auto_send_reward(L, NowTime, Stime, Etime, [{RoleId, GameType, CfgId, CfgDesc, Reward}|Acc]);
                        _ ->
                            do_count_auto_send_reward(L, NowTime, Stime, Etime, Acc)
                    end;
                _ ->
                    do_count_auto_send_reward(L, NowTime, Stime, Etime, Acc)
            end;
        _ ->
            do_count_auto_send_reward(L, NowTime, Stime, Etime, Acc)
    end.
auto_send_reward([], _NowTime, _Acc) -> skip;
auto_send_reward([{RoleId, GameType, CfgId, CfgDesc, RewardL}|L], NowTime, Acc) ->
    case Acc rem 15 of
        0 ->
            timer:sleep(100);
        _ -> skip
    end,
    lib_mail_api:send_sys_mail([RoleId], utext:get(3420001), utext:get(3420002, [CfgDesc]), RewardL),
    %% 日志
    lib_log_api:log_guess_reward(RoleId, GameType, 1, CfgId, 2, RewardL, NowTime),
    auto_send_reward(L, NowTime, Acc + 1).

auto_send_unreceive_reward(_, _, []) -> skip;
auto_send_unreceive_reward(SingleMap, GroupMap, EndTypeL) when EndTypeL =/= [] ->
    NowTime = utime:unixtime(),
    db:execute(io_lib:format(?sql_guess_single_auto_send_reward, [1, util:link_list(EndTypeL)])),
    db:execute(io_lib:format(?sql_guess_group_auto_send_reward, [1, util:link_list(EndTypeL)])),
    Acc = auto_send_single_guess_reward(maps:values(SingleMap), EndTypeL, NowTime, 1),
    auto_send_group_guess_reward(maps:values(GroupMap), EndTypeL, NowTime, Acc).

auto_send_single_guess_reward([], _EndTypeL, _NowTime, Acc) -> Acc;
auto_send_single_guess_reward([RoleMap|L], EndTypeL, NowTime, Acc) ->
    NewAcc = do_auto_send_single_guess_reward(maps:values(RoleMap), EndTypeL, NowTime, Acc),
    auto_send_single_guess_reward(L, EndTypeL, NowTime, NewAcc).
do_auto_send_single_guess_reward([], _EndTypeL, _NowTime, Acc) -> Acc;
do_auto_send_single_guess_reward([RoleData|L], EndTypeL, NowTime, Acc) ->
    case Acc rem 15 of
        true ->
            timer:sleep(100);
        _ -> skip
    end,
    case RoleData of
        #guess_single{
            key = {GameType, SubType, CfgId},
            role_id = RoleId,
            odds_list = OddsList,
            is_timeout = 0,
            reward_status = RewardStatus
        } when RewardStatus =/= ?HAS_RECEIVE ->
            case data_extra_guess:get_guess_single(GameType, SubType, CfgId) of
                #guess_single_config{result = Result, is_show = 1} when Result =/= ?RESULT_NO ->
                    case lists:member(GameType, EndTypeL) of
                        true ->
                            CostPrice = lib_guess:get_cost_price(GameType),
                            RewardNum = lib_guess:count_single_guess_reward(OddsList, Result, CostPrice, 0),
                            case RewardNum > 0 of
                                true ->
                                    Reward = [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, RewardNum}],
                                    lib_mail_api:send_sys_mail([RoleId], utext:get(3420001), utext:get(3420002), Reward),
                                    %% 日志
                                    lib_log_api:log_guess_reward(RoleId, GameType, 1, CfgId, 2, Reward, NowTime),
                                    do_auto_send_single_guess_reward(L, EndTypeL, NowTime, Acc + 1);
                                _ ->
                                    do_auto_send_single_guess_reward(L, EndTypeL, NowTime, Acc)
                            end;
                        _ ->
                            do_auto_send_single_guess_reward(L, EndTypeL, NowTime, Acc)
                    end;
                _ ->
                    do_auto_send_single_guess_reward(L, EndTypeL, NowTime, Acc)
            end;
        _ ->
            do_auto_send_single_guess_reward(L, EndTypeL, NowTime, Acc)
    end.

auto_send_group_guess_reward([], _EndTypeL, _NowTime, Acc) -> Acc;
auto_send_group_guess_reward([RoleMap|L], EndTypeL, NowTime, Acc) ->
    NewAcc = do_auto_send_group_guess_reward(maps:values(RoleMap), EndTypeL, NowTime, Acc),
    auto_send_group_guess_reward(L, EndTypeL, NowTime, NewAcc).
do_auto_send_group_guess_reward([], _EndTypeL, _NowTime, _Acc) -> ok;
do_auto_send_group_guess_reward([RoleData|L], EndTypeL, NowTime, Acc) ->
    case Acc rem 15 of
        true ->
            timer:sleep(100);
        _ -> skip
    end,
    case RoleData of
        #guess_group{
            key = {GameType, CfgId},
            role_id = RoleId,
            odds_list = OddsList,
            is_timeout = 0,
            reward_status = RewardStatus
        } when RewardStatus =/= ?HAS_RECEIVE ->
            case data_extra_guess:get_guess_group(GameType, CfgId) of
                #guess_group_config{result = Result} when Result =/= ?RESULT_NO ->
                    case lists:member(GameType, EndTypeL) of
                        true ->
                            CostPrice = lib_guess:get_cost_price(GameType),
                            RewardNum = lib_guess:count_single_guess_reward(OddsList, Result, CostPrice, 0),
                            case RewardNum > 0 of
                                true ->
                                    Reward = [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, RewardNum}],
                                    lib_mail_api:send_sys_mail([RoleId], utext:get(3420003), utext:get(3420004), Reward),
                                    %% 日志
                                    lib_log_api:log_guess_reward(RoleId, GameType, 2, CfgId, 2, Reward, NowTime),
                                    do_auto_send_group_guess_reward(L, EndTypeL, NowTime, Acc + 1);
                                _ ->
                                    do_auto_send_group_guess_reward(L, EndTypeL, NowTime, Acc)
                            end;
                        _ ->
                            do_auto_send_group_guess_reward(L, EndTypeL, NowTime, Acc)
                    end;
                _ ->
                    do_auto_send_group_guess_reward(L, EndTypeL, NowTime, Acc)
            end;
        _ ->
            do_auto_send_group_guess_reward(L, EndTypeL, NowTime, Acc)
    end.

%% 广播
broadcast() ->
    List = get_open_act_list(),
    {ok, BinData} = pt_342:write(34211, [List]),
    lib_server_send:send_to_all(BinData),
    ok.

get_act_time(GameType) ->
    case data_extra_guess:get_guess_info(GameType) of
        #guess_info_config{start_time = Stime, end_time = Etime} ->
            {Stime, Etime};
        _ -> {0, 0}
    end.

save_role_single_guess_data(RoleData) ->
    #guess_single{
        key = {GameType, SubType, CfgId},
        role_id = RoleId,
        times = Times,
        odds_list = OddsList,
        reward_status = RewardStatus,
        time = Time
    } = RoleData,
    db:execute(io_lib:format(?sql_guess_single_save, [RoleId, GameType, SubType, CfgId, Times, util:term_to_bitstring(OddsList), RewardStatus, Time])).

save_role_group_guess_data(RoleData) ->
    #guess_group{
        key = {GameType, CfgId},
        role_id = RoleId,
        times = Times,
        odds_list = OddsList,
        reward_status = RewardStatus,
        time = Time
    } = RoleData,
    db:execute(io_lib:format(?sql_guess_group_save, [RoleId, GameType, CfgId, Times, util:term_to_bitstring(OddsList), RewardStatus, Time])).

%% 发送错误码
send_error_code(RoleId, ErrorCode) ->
    {ok, BinData} = pt_342:write(34200, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).
