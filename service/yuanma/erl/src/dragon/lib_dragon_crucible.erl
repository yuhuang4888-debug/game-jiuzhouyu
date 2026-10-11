%% ---------------------------------------------------------------------------
%% @doc lib_dragon_crucible.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-12-18
%% @deprecated 龍紋熔爐
%% ---------------------------------------------------------------------------
-module(lib_dragon_crucible).

-export([
        login/1
    ]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("dragon.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("def_module.hrl").

%% 登入
login(#player_status{id = RoleId} = Player) ->
    case db_role_dragon_crucible_select(RoleId) of
        [] -> StatusDragonCb = #status_dragon_cb{};
        [CrucibleId, Count, CountAwardBin, RewardIdListBin, Freetimes, NextFreetime, UTime] ->
            CountAward = util:bitstring_to_term(CountAwardBin),
            RewardIdList = util:bitstring_to_term(RewardIdListBin),
            StatusDragonCb = #status_dragon_cb{
                crucible_id = CrucibleId, count = Count, count_award = CountAward, 
                reward_id_list = RewardIdList, free_times = Freetimes, next_free_time = NextFreetime, utime = UTime}
    end,
    Player#player_status{dragon_cb = StatusDragonCb}.

delay_stop(#player_status{dragon_cb = StatusDragonCb, id = RoleId} = Player) ->
    db_role_dragon_crucible_replace(RoleId, StatusDragonCb),
    Player.

%% 熔爐信息
get_crucible_info(#player_status{dragon_cb = StatusDragonCb, figure = #figure{career = Career}}) ->
    #status_dragon_cb{count = Count, count_award = CountAward, free_times = Freetimes, next_free_time = NextFreetime} = StatusDragonCb,
    {NewFreeTimes, NewNextFreeTime} = calc_free_times(Freetimes, NextFreetime),
    % ?PRINT("NewFreeTimes:~p,NewNextFreeTime:~p~n",[NewFreeTimes, NewNextFreeTime]),
    case get_open_crucible(Career) of
        false ->
            {[0, 0, 0, Count, [], 0, 0], {Freetimes, NextFreetime}};
        {BaseDragonCb, StartTime, EndTime} ->
            #base_dragon_crucible{crucible_id = CrucibleId, count_award = CountAwardCfg} = BaseDragonCb,
            F = fun({CountCfg, _Reward}) ->
                Status = calc_count_award_status(Count, CountAward, CountCfg),
                {CountCfg, Status}
            end,
            StatusL = [F(T)||T<-CountAwardCfg],
            {[CrucibleId, StartTime, EndTime, Count, StatusL, NewFreeTimes, NewNextFreeTime],{NewFreeTimes, NewNextFreeTime}}
    end.

calc_free_times(Freetimes, NextFreetime) ->
    NowTime = utime:unixtime(),
    MaxCount = case data_dragon:get_value(max_free_times) of
            Count when is_integer(Count) -> Count;
            _ -> 0
    end,
    Sptime = case data_dragon:get_value(free_time_sp) of
            [{H,M,S}] when is_integer(H) andalso is_integer(M) andalso is_integer(S) -> H*3600+M*60+S;
            _ -> 0
    end,
    if
        Sptime == 0 ->
            {0,0};
        NextFreetime == 0 ->
        if
            Freetimes >= MaxCount ->
                {MaxCount, 0};
            true ->
                {Freetimes, NowTime+Sptime}
        end;
        NextFreetime =< NowTime ->
            PassTime = NowTime - NextFreetime,
            AddCount = PassTime div Sptime + 1,
            AddTime = PassTime rem Sptime,
            % ?PRINT("PassTime:~p,AddCount:~p,Sptime:~p,AddTime:~p~n",[PassTime,AddCount,Sptime,AddTime]),
            NewFreeTime = NowTime - AddTime + Sptime,
            if
                Freetimes + AddCount >= MaxCount ->
                    {MaxCount, 0};
                true ->
                    {Freetimes + AddCount, NewFreeTime}
            end;
        true ->
            {Freetimes, NextFreetime}
    end.

%% 計算次數獎勵狀態
calc_count_award_status(Count, CountAward, CountCfg) ->
    case lists:member(CountCfg, CountAward) of
        true -> ?DRAGON_CAN_HAVE_GET;
        false ->
            case Count >= CountCfg of
                true -> ?DRAGON_CAN_GET;
                false -> ?DRAGON_CAN_NOT_GET
            end
    end.

%% 召喚次數
%% @param Times 召喚次數
beckon(Player, Times, AutoBuy) ->
    case check_beckon(Player, Times, AutoBuy) of
        {false, ErrorCode} -> {false, ErrorCode, Player};
        {true, BaseDragonCb, StartTime, EndTime, [], Freetimes, NextFreetime} ->
            {ok, NewPlayer2, RewardL} = do_beckon(Player, BaseDragonCb, StartTime, EndTime, [], Times, Freetimes, NextFreetime),
            {true, NewPlayer2, RewardL};
        {true, BaseDragonCb, StartTime, EndTime, Cost, Freetimes, NextFreetime} ->
            #base_dragon_crucible{crucible_id = CrucibleId} = BaseDragonCb,
            About = lists:concat(["CrucibleId:", CrucibleId, "Times:", Times]),
            Res = if
                AutoBuy == 1 ->
                    lib_goods_api:cost_objects_with_auto_buy(Player, Cost, dragon_beckon, About);
                true ->
                    case lib_goods_api:cost_object_list(Player, Cost, dragon_beckon, About) of
                        {true, TmpNewPlayer} ->
                            {true, TmpNewPlayer, Cost};
                        Other ->
                            Other
                    end
            end,
            case Res of
                {false, ErrorCode, NewPlayer} -> {false, ErrorCode, NewPlayer};
                {true, NewPlayer, CostList} -> 
                    {ok, NewPlayer2, RewardL} = do_beckon(NewPlayer, BaseDragonCb, StartTime, EndTime, CostList, Times, Freetimes, NextFreetime),
                    {true, NewPlayer2, RewardL}
            end
    end.

check_beckon(#player_status{figure = #figure{career = Career}, dragon_cb = StatusDragonCb} = Player, Times, AutoBuy) ->
    NowTime = utime:unixtime(),
    #status_dragon_cb{free_times = Freetimes, next_free_time = NextFreetime} = StatusDragonCb,
    {NewFreeTimes, NewNextFreeTime} = calc_free_times(Freetimes, NextFreetime),
    case get_open_crucible(Career) of
        % 是否在活動期間
        {BaseDragonCb, StartTime, EndTime} when NowTime >= StartTime, NowTime =< EndTime ->
            #base_dragon_crucible{cost_list = CostList} = BaseDragonCb,
            case lists:keyfind(Times, 1, CostList) of
                false -> IsConfig = false, Cost = [];
                {Times, Cost} when Cost =/= [] -> IsConfig = true;
                _ -> IsConfig = false, Cost = []
            end,
            if
                IsConfig == false -> {false, ?ERRCODE(err181_not_beckon_cfg)};
                Times =< 0 -> {false, ?ERRCODE(err181_not_beckon_cfg)};
                Times == 1 andalso NewFreeTimes >= 1 ->
                    {true, BaseDragonCb, StartTime, EndTime, [], NewFreeTimes-1, NewNextFreeTime};
                true -> 
                    if
                        AutoBuy == 1 ->
                            case lib_goods_api:check_object_list_with_auto_buy(Player, Cost) of
                                {false, ErrorCode} -> {false, ErrorCode};
                                true -> {true, BaseDragonCb, StartTime, EndTime, Cost, NewFreeTimes, NewNextFreeTime}
                            end;
                        true ->
                            case lib_goods_api:check_object_list(Player, Cost) of
                                {false, ErrorCode} -> {false, ErrorCode};
                                true -> {true, BaseDragonCb, StartTime, EndTime, Cost, NewFreeTimes, NewNextFreeTime}
                            end
                    end
            end;
        _ ->
            {false, ?ERRCODE(err181_crucible_not_open)}
    end.

do_beckon(Player, BaseDragonCb, StartTime, EndTime, Cost, Times, Freetimes, NextFreetime) ->
    #player_status{id = RoleId, figure = #figure{career = Career}, dragon_cb = StatusDragonCb} = Player,
    #status_dragon_cb{count = Count, reward_id_list = RewardIdList} = StatusDragonCb,
    #base_dragon_crucible{crucible_id = CrucibleId, tv_list = TvList} = BaseDragonCb,
    NewCount = Count+Times,
    {NewRewardIdList, RewardIdT} = do_beckon_core(CrucibleId, Career, RewardIdList, Count+1, NewCount, []),
    NewStatusDragonCb = StatusDragonCb#status_dragon_cb{free_times = Freetimes, next_free_time = NextFreetime,
        crucible_id = CrucibleId, count = NewCount, reward_id_list = NewRewardIdList, utime = utime:unixtime()},
    db_role_dragon_crucible_replace(RoleId, NewStatusDragonCb),
    NewPlayer = Player#player_status{dragon_cb = NewStatusDragonCb},
    F = fun({TmpCount, RewardId}) -> 
        case data_dragon:get_dragon_crucible_reward(CrucibleId, RewardId) of
            [] -> {TmpCount, RewardId, []};
            #base_dragon_crucible_reward{reward = Reward} -> {TmpCount, RewardId, Reward}
        end
    end,
    RewardT = lists:map(F, RewardIdT),
    RewardL = lists:flatten([Reward||{_TmpCount, _RewardId, Reward}<-RewardT]),
    UqRewardL = lib_goods_api:make_reward_unique(RewardL),
    Remark = lists:concat(["CrucibleId:", CrucibleId, "Times:", Times]),
    Produce = #produce{type = dragon_beckon, reward = UqRewardL, show_tips = ?SHOW_TIPS_0, remark = Remark},
    NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
    lib_log_api:log_dragon_crucible_beckon(RoleId, StartTime, EndTime, CrucibleId, Cost, RewardT, Count, NewCount),
    send_crucible_tv(NewPlayer2, TvList, RewardL),
    {ok, NewPlayer2, RewardL}.

do_beckon_core(_CrucibleId, _Career, RewardIdList, Count, MaxCount, RewardIdT) when Count > MaxCount -> 
    {RewardIdList, RewardIdT};
do_beckon_core(CrucibleId, Career, RewardIdList, Count, MaxCount, RewardIdT) ->
    CfgRewardIdList = data_dragon:get_dragon_crucible_reward_id_list(CrucibleId),
    AssureWeightL = get_assure_weight_list(CfgRewardIdList, CrucibleId, Career, RewardIdList, Count, []),
    case urand:rand_with_weight(AssureWeightL) of
        false ->
            WeightL = get_weight_list(CfgRewardIdList, CrucibleId, Career, RewardIdList, Count, []),
            case urand:rand_with_weight(WeightL) of
                false -> do_beckon_core(CrucibleId, Career, RewardIdList, Count+1, MaxCount, [{Count, 0}|RewardIdT]);
                RewardId ->
                    NewRewardIdList = [RewardId|lists:delete(RewardId, RewardIdList)],
                    do_beckon_core(CrucibleId, Career, NewRewardIdList, Count+1, MaxCount, [{Count, RewardId}|RewardIdT])
            end;
        RewardId ->
            NewRewardIdList = [RewardId|lists:delete(RewardId, RewardIdList)],
            do_beckon_core(CrucibleId, Career, NewRewardIdList, Count+1, MaxCount, [{Count, RewardId}|RewardIdT])
    end.

%% 獲得權重列表
get_weight_list([], _CrucibleId, _Career, _RewardIdList, _Count, R) -> R;
get_weight_list([RewardId|T], CrucibleId, Career, RewardIdList, Count, R) ->
    #base_dragon_crucible_reward{
        career = RewardCareer, count_st = CountSt, count_et = CountEt, weight = Weight, weight_add = WeightAdd
    } = data_dragon:get_dragon_crucible_reward(CrucibleId, RewardId),
    % 職業會過濾
    case RewardCareer == 0 orelse RewardCareer == Career of
        true ->
            case lists:member(RewardId, RewardIdList) of
                true when Count >= CountSt andalso Count =< CountEt -> 
                    NewR = R;
                false when Count < CountSt -> 
                    NewR = R;
                false when Count >= CountSt andalso Count =< CountEt -> 
                    NewR = [{Weight+WeightAdd, RewardId}|R];
                _ ->
                    NewR = [{Weight, RewardId}|R]
            end;
        false ->
            NewR = R
    end,
    get_weight_list(T, CrucibleId, Career, RewardIdList, Count, NewR).

%% 獲得保底權重列表
get_assure_weight_list([], _CrucibleId, _Career, _RewardIdList, _CountSt, R) -> R;
get_assure_weight_list([RewardId|T], CrucibleId, Career, RewardIdList, Count, R) ->
    #base_dragon_crucible_reward{
        career = RewardCareer, count_et = CountEt, is_assure = IsAssure, weight = Weight
    } = data_dragon:get_dragon_crucible_reward(CrucibleId, RewardId),
    % 職業會過濾
    case RewardCareer == 0 orelse RewardCareer == Career of
        true ->
            case lists:member(RewardId, RewardIdList) of
                true -> NewR = R;
                % 是否需要保底
                false when Count >= CountEt andalso IsAssure == 1 -> NewR = [{Weight, RewardId}|R];
                _ -> NewR = R
            end;
        false ->
            NewR = R
    end,
    get_assure_weight_list(T, CrucibleId, Career, RewardIdList, Count, NewR).

send_crucible_tv(_Player, _TvList, []) -> ok;
send_crucible_tv(Player, TvList, [{_Type, GoodsTypeId, _Num}|RewardL]) ->
    #player_status{id = RoleId, figure = #figure{name = _RealName}} = Player,
    Name = lib_player:get_wrap_role_name(Player),
    % ?INFO("TvList:~p IS:~p GoodsTypeId:~p ~n", [TvList, lists:member(GoodsTypeId, TvList), GoodsTypeId]),
    case lists:member(GoodsTypeId, TvList) of
        true ->
            Attr = lib_dragon_equip:get_equip_attr(GoodsTypeId),
            lib_chat:send_TV({all}, ?MOD_DRAGON, 1, [Name,RoleId, GoodsTypeId, 0, Attr, _Num]);
        false -> skip
    end,
    send_crucible_tv(Player, TvList, RewardL);
send_crucible_tv(Player, TvList, [_|RewardL]) ->
    send_crucible_tv(Player, TvList, RewardL).

%% 熔爐召喚獎勵領取
handle_count_reward(Player, CountCfg) ->
    case check_handle_count_reward(Player, CountCfg) of
        {false, ErrorCode} -> {false, ErrorCode};
        {true, CrucibleId, Reward, StartTime, EndTime} ->
            #player_status{id = RoleId, dragon_cb = StatusDragonCb} = Player,
            #status_dragon_cb{count = Count, count_award = CountAward} = StatusDragonCb,
            NewCountAward = [CountCfg|CountAward],
            NewStatusDragonCb = StatusDragonCb#status_dragon_cb{
                crucible_id = CrucibleId, count_award = NewCountAward, utime = utime:unixtime()},
            db_role_dragon_crucible_replace(RoleId, NewStatusDragonCb),
            NewPlayer = Player#player_status{dragon_cb = NewStatusDragonCb},
            Remark = lists:concat(["CrucibleId:", CrucibleId, "CountCfg:", CountCfg]),
            Produce = #produce{type = dragon_count_award, reward = Reward, show_tips = ?SHOW_TIPS_3, remark = Remark},
            NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
            lib_log_api:log_dragon_crucible_reward(RoleId, StartTime, EndTime, Count, CrucibleId, CountCfg, Reward),
            {true, NewPlayer2, Reward}
    end.
            
check_handle_count_reward(#player_status{figure = #figure{career = Career}} = Player, CountCfg) ->
    NowTime = utime:unixtime(),
    case get_open_crucible(Career) of
        % 是否在活動期間
        {BaseDragonCb, StartTime, EndTime} when NowTime >= StartTime, NowTime =< EndTime ->
            #player_status{dragon_cb = StatusDragonCb} = Player,
            #status_dragon_cb{count = Count, count_award = CountAward} = StatusDragonCb,
            #base_dragon_crucible{crucible_id = CrucibleId, count_award = CountAwardCfg} = BaseDragonCb,
            case lists:keyfind(CountCfg, 1, CountAwardCfg) of
                {CountCfg, Reward} when Reward =/= [] -> IsConfig = true;
                _ -> IsConfig = false, Reward = []
            end,
            Status = calc_count_award_status(Count, CountAward, CountCfg),
            if
                IsConfig == false -> {false, ?ERRCODE(err181_not_count_reward_cfg)};
                Status == ?DRAGON_CAN_HAVE_GET -> {false, ?ERRCODE(err181_can_have_get)};
                Status == ?DRAGON_CAN_NOT_GET -> {false, ?ERRCODE(err181_can_not_get)};
                true -> {true, CrucibleId, Reward, StartTime, EndTime}
            end;
        _ ->
            {false, ?ERRCODE(err181_crucible_not_open)}
    end.

%% 計算熔爐狀態:發未領取的獎勵,重置狀態
calc_status_dragon_cb(#player_status{dragon_cb = StatusDragonCb, figure = #figure{career = Career}} = Player) ->
    #status_dragon_cb{crucible_id = CrucibleId, utime = UTime} = StatusDragonCb,
    % TODO:未領取也發獎勵
    NewStatusDragonCb = case get_open_crucible(Career) of
        false -> reset_status_dragon_cb(StatusDragonCb);
        {#base_dragon_crucible{crucible_id = CrucibleId}, StartTime, EndTime} when UTime >= StartTime, UTime =< EndTime ->
            StatusDragonCb;
        _ -> reset_status_dragon_cb(StatusDragonCb)
    end,
    Player#player_status{dragon_cb = NewStatusDragonCb}.

%% 重置熔爐狀態
reset_status_dragon_cb(StatusDragonCb) ->
    StatusDragonCb#status_dragon_cb{
        crucible_id = 0
        , count = 0
        , count_award = []
        , reward_id_list = []
        , utime = 0
    }.

%% 獲得當前熔爐活動
%% @return false | {#base_dragon_crucible{}, StartTime, EndTime}
get_open_crucible(Career) ->
    % Now = utime:unixtime(),
    % case Now >= 1516118400 andalso Now =< 1516204800 of
    %     true -> false;
    %     false ->
            OpenDay = util:get_open_day(),
            OpenTime = util:get_open_time(),
            get_open_crucible(Career, OpenDay, OpenTime).
    % end.

get_open_crucible(Career, OpenDay, OpenTime) ->
    ActIdList = data_dragon:get_dragon_crucible_act_id_list(),
    case do_open_crucible(ActIdList, OpenDay) of
        false -> false;
        {CrucibleId, OpenBegin, OpenEnd} ->
            case data_dragon:get_dragon_crucible(CrucibleId, Career) of
                [] -> false;
                BaseDragonCb -> 
                    StartTime = OpenTime+OpenBegin*86400,
                    EndTime = OpenTime+OpenEnd*86400,
                    {BaseDragonCb, StartTime, EndTime}
            end
    end.
do_open_crucible([], _OpenDay) -> false;
do_open_crucible([ActId|T], OpenDay) ->
    #base_dragon_crucible_act{
        open_begin = OpenBegin, open_end = OpenEnd, crucible_list = CrucibleList,
        start_time = StartTime, end_time = EndTime
    } = data_dragon:get_dragon_crucible_act(ActId),
    NowSec = utime:unixtime(),
    case OpenDay >= OpenBegin andalso OpenDay =< OpenEnd andalso NowSec >= StartTime andalso NowSec < EndTime of
        true -> 
            Sum = lists:sum([CycleDay||{_CrucibleId, CycleDay}<-CrucibleList]),
            Rem = (OpenDay-OpenBegin+1) rem Sum,
            TargetDay = ?IF(Rem == 0, Sum, Rem),
            case do_open_crucible_2(CrucibleList, 0, TargetDay) of
                false -> false;
                {CrucibleId, StDay, EtDay} ->
                    % 每輪結束當天,求余會變成下一輪,需要減一處理
                    case (OpenDay-OpenBegin+1) rem Sum == 0 of
                        true -> Multi = (OpenDay-OpenBegin+1) div Sum - 1;
                        false -> Multi = (OpenDay-OpenBegin+1) div Sum
                    end,
                    {CrucibleId, (OpenBegin-1)+Multi*Sum+StDay, (OpenBegin-1)+Multi*Sum+EtDay}
            end;
        false ->
            do_open_crucible(T, OpenDay)
    end.

get_next_open_time() ->
    ActIdList = data_dragon:get_dragon_crucible_act_id_list(),
    Fun = fun(ActId, Acc) ->
        #base_dragon_crucible_act{
            open_begin = OpenBegin, open_end = OpenEnd, crucible_list = CrucibleList, start_time = TemStartTime, end_time = TemEndTime
            } = data_dragon:get_dragon_crucible_act(ActId),
        [{ActId, OpenBegin, OpenEnd, CrucibleList, TemStartTime, TemEndTime}|Acc]
    end,
    List = lists:keysort(2, lists:foldl(Fun, [], ActIdList)),
    OpenDay = util:get_open_day(),
    OpenTime = util:get_open_time(),
    NowSec = utime:unixtime(),
    F1 = fun({_TemActId, TemOpenBegin, TemOpenEnd, _, TemStartTime, TemEndTime}) ->
        TemOpenBegin =< OpenDay andalso OpenDay =< TemOpenEnd andalso NowSec >= TemStartTime andalso NowSec < TemEndTime
    end,
    case ulists:find(F1, List) of
        {ok, {_TActId, TOpenBegin, _TOpenEnd, TCrucibleList, _, _}} ->
            Sum = lists:sum([CycleDay||{_CrucibleId, CycleDay}<-TCrucibleList]),
            Rem = (OpenDay-TOpenBegin+1) rem Sum,
            TargetDay = ?IF(Rem == 0, Sum, Rem),
            case do_open_crucible_2(TCrucibleList, 0, TargetDay) of
                false -> false;
                {CrucibleId, _StDay, EtDay} ->
                    % 每輪結束當天,求余會變成下一輪,需要減一處理
                    case (OpenDay-TOpenBegin+1) rem Sum == 0 of
                        true -> Multi = (OpenDay-TOpenBegin+1) div Sum - 1;
                        false -> Multi = (OpenDay-TOpenBegin+1) div Sum
                    end,
                    % StartTime = OpenTime+((TOpenBegin-1)+Multi*Sum+StDay)*86400,
                    EndTime = OpenTime+((TOpenBegin-1)+Multi*Sum+EtDay)*86400,
                    case lists:member(CrucibleId, ActIdList) of
                        true ->
                            {CrucibleId, 0};
                        _ ->
                            {0, EndTime}
                    end
            end;
        _ ->
            F2 = fun({_TemActId, _TemOpenBegin, _TemOpenEnd, _, TemStartTime, _TemEndTime}) ->
                OpenDay < _TemOpenBegin orelse NowSec < TemStartTime
            end,
            case ulists:find(F2, List) of
                {ok, {TActId1, TOpenBegin1, _, _, ActStartTime, _}} ->
                    StartTime1 = ?IF(ActStartTime == 0, OpenTime+TOpenBegin1*86400, ActStartTime),
                    ?PRINT("OpenTime:~p,TOpenBegin1:~p~n",[OpenTime,TOpenBegin1]),
                    {TActId1, StartTime1};
                _ ->
                    false
            end
    end.

do_open_crucible_2([], _SumDay, _TargetDay) -> false;
do_open_crucible_2([{CrucibleId, CycleDay}|T], SumDay, TargetDay) ->
    NewSumDay = SumDay+CycleDay,
    case TargetDay =< NewSumDay of
        true -> {CrucibleId, SumDay, NewSumDay};
        false -> do_open_crucible_2(T, NewSumDay, TargetDay)
    end.

db_role_dragon_crucible_select(RoleId) ->
    Sql = io_lib:format(?sql_role_dragon_crucible_select, [RoleId]),
    db:get_row(Sql).

db_role_dragon_crucible_replace(RoleId, StatusDragonCb) ->
    #status_dragon_cb{crucible_id = CrucibleId, count = Count, count_award = CountAward, reward_id_list = RewardIdList,
free_times = Freetimes, next_free_time = NextFreetime, utime = UTime} = StatusDragonCb,
    Sql = io_lib:format(?sql_role_dragon_crucible_replace, 
        [RoleId, CrucibleId, Count, util:term_to_bitstring(CountAward), util:term_to_bitstring(RewardIdList), Freetimes, NextFreetime, UTime]),
    db:execute(Sql).
