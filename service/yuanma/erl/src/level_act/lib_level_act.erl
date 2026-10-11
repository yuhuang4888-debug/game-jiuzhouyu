%%-----------------------------------------------------------------------------
%% @Module  :       lib_level_act
%% @Author  :       xlh
%% @Email   :
%% @Created :       2019-5-26
%% @Description:    等级抢购商城
%%-----------------------------------------------------------------------------
-module(lib_level_act).

-include("level_rush_act.hrl").
-include("def_event.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("vip.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").

-export([
        handle_event/2,
        init_data/4,
        init_data/1,
        db_replace/2,
        calc_real_cost/2,
        act_open/4,
        act_open/5,
        act_end/2,
        act_end/3,
        day_clear/0,
        day_clear/1,
        refresh_recharge/2,
        get_produce_type/1,
        logout/1
        ,login/2
        ,test_ref/0
        ,gm_reset/1
        ,get_gift_grade/5
        ,get_gift_grade_helper/5
        , gm_fix_open_times/0
    ]).

-export([gm_restore_role_level_act_data/0]).

test_ref() ->
    case misc:get_player_process(4294967300) of
        Pid when is_pid(Pid) ->
            util:send_after([], 500, Pid,  {'mod', lib_level_act, init_data, []});
        _ -> false
    end.

gm_reset(Player) ->
    #player_status{id = RoleId, lv_act = OldLvActState, figure = #figure{lv = RoleLv}} = Player,
    #lv_act_state{record_map = JoinMap} = OldLvActState,
    Sql = io_lib:format(<<"TRUNCATE TABLE `lv_act_grade_data`">>, []),
    db:execute(Sql),
    {RewardMap, ActMap, CdList, CdRefList} = db_select_grade_rec(RoleId, #{}),
    LvActState = OldLvActState#lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, record_map = JoinMap, cd_list = CdList, cd_ref_list = CdRefList},
    NewActState = init_data(Player, LvActState, RoleId, RoleLv),
    #lv_act_state{act_map = Map} = NewActState,
    SendList = pp_level_act:make_data_for_client(Map),
    lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]),
    % ?PRINT("@@@@@@@@ SendList:~p~n",[SendList]),
    Player#player_status{lv_act = NewActState}.

%% 活动数据表（会清理）
db_select(RoleId, LoginTime) ->
    List = db:get_all(io_lib:format(?SQL_SELECT, [RoleId])),
    Fun = fun([Type, SubType, OpenTime, EndTime, StatusS, Stime, OpenTimes, OldStatusS], TemMap) ->
        Status = util:bitstring_to_term(StatusS),
        OldStatus = util:bitstring_to_term(OldStatusS),
        RealOldStatus = ?IF(OldStatus == [], Status, OldStatus),
        case data_level_act:get_act_cfg(Type, SubType) of
            #base_lv_act_open{clear_type = ClearType, circuit = Circuit} when Circuit == ?ACT_OPEN ->
                calc_act_data(TemMap, RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, ClearType, LoginTime, OpenTimes, RealOldStatus);
            _ ->
                TemMap
        end
    end,
    lists:foldl(Fun, #{}, List).

db_replace(LvActData, RoleId) ->
    #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus} = LvActData,
    db_replace(RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, OpenTimes, OldStatus).

db_replace(RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, OpenTimes, OldStatus) ->
    Sql = io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, OpenTime, EndTime, util:term_to_string(Status), Stime, OpenTimes, util:term_to_string(OldStatus)]),
    db:execute(Sql).

db_delete(RoleId, Type, SubType) ->
    db:execute(io_lib:format(?SQL_DELETE, [RoleId, Type, SubType])).

db_delete(Type, SubType) ->
    db:execute(io_lib:format(?SQL_DELETE_ACT, [Type, SubType])).

%% 活动参与记录表（不清理）(定制活动可能清理（0/4点清理表示清掉该活动参与记录）)
db_select_rec(RoleId) ->
    List = db:get_all(io_lib:format(?SQL_SELECT_REC, [RoleId])),
    Fun = fun([Type, SubType, _], TemMap) ->
        maps:put({Type, SubType}, ?HAS_JOIN, TemMap)
    end,
    lists:foldl(Fun, #{}, List).

db_replace_rec(RoleId, Type, SubType) ->
    Now = utime:unixtime(),
    db:execute(io_lib:format(?SQL_REPLACE_REC,[RoleId, Type, SubType, Now])).

% db_delete_rec(Type, SubType, RoleId) ->
%     db:execute(io_lib:format(<<"DELETE FROM `lv_act_join_data` WHERE `act_type` = ~p AND `act_subtype` = ~p AND `role_id` = ~p">>, [Type, SubType, RoleId])).

db_delete_rec(Type, SubType) ->
    db:execute(io_lib:format(<<"DELETE FROM `lv_act_join_data` WHERE `act_type` = ~p AND `act_subtype` = ~p">>, [Type, SubType])).

%% 获取玩家活动奖励获取情况
%% @return RewardMap :: #{{Type, SubType} => [{Grade, HasBuy, Circle, EndTime, EndOpenDay}]}
%% @return NewActMap :: #{{Type, SubType} => #lv_act_data{}}
%% @return NewCdList :: [{{Type, SubType}, STime}]
%% @return CdRefList :: [{{Type, SubType}, tref() = TRef}]
db_select_grade_rec(RoleId, ActMap) ->
    NowTime = utime:unixtime(),
    List = db:get_all(io_lib:format(?SQL_SELECT_GRADE, [RoleId])),
    Fun = fun([Type, SubType, Grade, HasBuy, Stime], {TemMap, TemMap1, Acc}) ->
        case data_level_act:get_gift_reward_cfg(Type, SubType, Grade) of
            #base_lv_gift_reward{circle = Circle} when is_integer(Circle) ->
                MapList = maps:get({Type, SubType}, TemMap, []),
                if
                    HasBuy == ?HAS_BUY orelse HasBuy == ?TIME_END ->
                        case lists:keyfind({Type, SubType}, 1, Acc) of
                            {{Type, _}, TemTime} ->
                                % 取玩家在本活动({Type, SubType})最后一次购买礼包或最后过期时间作为礼包下次开启时间
                                NewTemTime = ?IF(Stime >= TemTime, Stime, TemTime),
                                NewAcc = lists:keystore({Type, SubType}, 1, Acc, {{Type, SubType}, NewTemTime});
                            _ ->
                                NewAcc = lists:keystore({Type, SubType}, 1, Acc, {{Type, SubType}, Stime})
                        end,
                        % 对于已买礼包或过期礼包结束时间即为下次开启时间
                        EndTime = Stime;
                    true ->
                        NewAcc = Acc,
                        % 对于未购买礼包根据玩家开启时间+配置时间算结束时间
                        EndTime = calc_end_time(Type, SubType, Stime)
                end,

                NewList = lists:keystore(Grade, 1, MapList, {Grade, HasBuy, Circle, EndTime, util:get_open_day(EndTime)}),
                if
                    EndTime > NowTime ->    % 针对未购买礼包重新计算对应的活动数据状态
                        LvActData = #lv_act_data{key = {Type,SubType}, end_time = EndTime, status = [{Grade, ?NOT_BUY}], stime = NowTime, open_time = Stime},
                        NewMap = maps:put({Type, SubType}, LvActData, TemMap1);
                    true ->
                        NewMap = TemMap1
                end,

                {maps:put({Type, SubType}, NewList, TemMap), NewMap, NewAcc};
            _ ->
                {TemMap, TemMap1, Acc}
        end
    end,
    {RewardMap,NewActMap,CdList} = lists:foldl(Fun, {#{}, ActMap, []}, List),
    NewCdList = calc_cd_list(NewActMap, CdList),
    CdRefList = calc_cd_ref(CdList, [], ?LEVEL_HELP_GIFT),
    {RewardMap,NewActMap,NewCdList,CdRefList}.

%% 针对已购买或过期的可循环礼包（助力礼包）要重新计算购买CD
%% @param ActMap :: #{{Type, SubType} => #lv_act_data{}}
%% @param CdList :: [{{Type, SubType}, STime}]
calc_cd_list(ActMap, CdList) ->
    Fun = fun({{Type, SubType} = Key, Stime}, Acc) ->
        case maps:get(Key, ActMap, []) of
            [] ->
                case data_level_act:get_act_cfg(Type, SubType) of
                    #base_lv_act_open{conditions = Conditions} ->
                        case lists:keyfind(cd, 1, Conditions) of
                            {_, CdCFG} ->
                                Cd = Stime + CdCFG*60;
                            _ ->
                                Cd = Stime
                        end;
                    _ ->
                        Cd = Stime
                end,
                lists:keystore(Key, 1, Acc, {Key, Cd});
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], CdList).

%% 针对已购买或过期的可循环礼包（助力礼包）设置计时器以初始化数据
%% @return CdRefList :: [{{Type, SubType}, tref() = TRef}]
calc_cd_ref(CdList, CdRefList, Type) ->
    NowTime = utime:unixtime(),
    Fun = fun({{Tem, _} = Key, Cd}, Acc) when Tem == Type ->
        case lists:keyfind(Key, 1, Acc) of
            {Key, Ref} ->
                util:cancel_timer(Ref),
                if
                    NowTime > Cd ->
                        lists:keydelete(Key, 1, Acc);
                    true ->
                        NewRef = util:send_after([], max((Cd - NowTime)*1000, 500), self(),  {'mod', lib_level_act, init_data, []}),
                        lists:keystore(Key, 1, Acc, {Key, NewRef})
                end;
            _ ->
                if
                    NowTime >= Cd ->
                        Acc;
                    true ->
                        NewRef = util:send_after([], max((Cd - NowTime)*1000, 500), self(),  {'mod', lib_level_act, init_data, []}),
                        lists:keystore(Key, 1, Acc, {Key, NewRef})
                end
        end;
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, CdRefList, CdList).
% db_replace_grade_rec(LvActData, RoleId) ->
%     #lv_act_data{key = {Type,SubType}, status = [{Grade, State}|_], open_time = Opentime} = LvActData,
%     db_replace_grade_rec(RoleId, Type, SubType, Grade, State, Opentime).

db_replace_grade_rec(RoleId, Type, SubType, Grade, State, Opentime) ->
    db:execute(io_lib:format(?SQL_REPLACE_GRADE, [RoleId, Type, SubType, Grade, State, Opentime])).

logout(Player) ->
    #player_status{id = _RoleId, lv_act = LvActState} = Player,
    #lv_act_state{act_map = ActMap, cd_ref_list = CdRefList} = LvActState,
    ActList = maps:to_list(ActMap),
    F = fun({_, OldRef1}) ->
        util:cancel_timer(OldRef1)
    end,
    lists:foreach(F, CdRefList),
    Fun = fun({_, #lv_act_data{ref = OldRef}}) ->
        util:cancel_timer(OldRef)
    end,
    lists:foreach(Fun, ActList),
    Player.

login(Player, LoginType) ->
    #player_status{last_login_time = LoginTime, id = RoleId, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    Map = db_select(RoleId, LoginTime),
    JoinMap = db_select_rec(RoleId),
    {RewardMap, ActMap, CdList, CdRefList} = db_select_grade_rec(RoleId, Map),
    LvActState = #lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, record_map = JoinMap, cd_list = CdList, cd_ref_list = CdRefList},
    NewActState = init_data(Player, LvActState, RoleId, RoleLv, LoginType),
    Player#player_status{lv_act = NewActState}.

handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    NewActState = init_data(Player, LvActState, RoleId, RoleLv),
    if
        LvActState =/= NewActState ->
            #lv_act_state{act_map = Map} = NewActState,
            SendList = pp_level_act:make_data_for_client(Map),
            lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]);
        true ->
            skip
    end,
    NewPlayer = Player#player_status{lv_act = NewActState},
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    NewActState = init_data(Player, LvActState, RoleId, RoleLv),
    if
        LvActState =/= NewActState ->
            #lv_act_state{act_map = Map} = NewActState,
            SendList = pp_level_act:make_data_for_client(Map),
            lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]);
        true ->
            skip
    end,
    NewPlayer = Player#player_status{lv_act = NewActState},
    {ok, NewPlayer};
handle_event(Player, #event_callback{ type_id = ?EVENT_RECHARGE, data = Data }) when is_record(Player, player_status) ->
    #callback_recharge_data{recharge_product = #base_recharge_product{product_id = ProductId, product_type = ProductType, money = Money}} = Data,
    %% 到达此处表示充值到账, 不在判断相应的开启或者领取状态条件等
    case ProductId == 0 orelse ProductType =/= ?PRODUCT_TYPE_DIRECT_GIFT of
        true ->
            NewPlayer = Player;
        false ->
            NewPlayer = recharge_lv_act(Player, ProductId, Money)
    end,
    {ok, NewPlayer};
handle_event(PS, #event_callback{}) ->
    {ok, PS}.

init_data(Player) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    NewActState = init_data(Player, LvActState, RoleId, RoleLv),
    #lv_act_state{act_map = Map} = NewActState,
    SendList = pp_level_act:make_data_for_client(Map),
    % ?PRINT("========== SendList:~p~n",[SendList]),
    lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]),
    {ok, Player#player_status{lv_act = NewActState}}.

init_data(PS, LvActState, RoleId, RoleLv) ->
    init_data(PS, LvActState, RoleId, RoleLv, normal).

%% 登录或定期对活动数据状态进行初始化
init_data(PS, LvActState, RoleId, RoleLv, LoginType) ->
    Now = utime:unixtime(),
    case LvActState of
        #lv_act_state{act_map = OMap, record_map = JoinMap, act_reward_rec = RewardMap, cd_list = OCdList, cd_ref_list = OCdRefList, level_act_ref = LevelActRef} = ActState ->
            {Map, CdList, CdRefList} = clear_act_timeout(RoleId, OMap, OCdList, OCdRefList);
        _ ->
            LevelActRef = undefined,
            % 获取玩家各活动映射数据表
            Map = db_select(RoleId, Now),       % #{{Type, SubType} => #lv_act_data{}}
            % 获取玩家活动参与记录表
            JoinMap = db_select_rec(RoleId),    % #{{Type, SubType} => IsJoin}
            % 获取玩家活动奖励获取情况
            {RewardMap, ActMap, CdList, CdRefList} = db_select_grade_rec(RoleId, Map),
            ActState = #lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, record_map = JoinMap, cd_list = CdList, cd_ref_list = CdRefList}
    end,
    % 获取玩家等级满足的各类活动
    LevelList = data_level_act:get_all_lv_limit(),
    LevelList1 = [Level || Level <- LevelList, Level =< RoleLv],
    ActList0 = lists:flatten([data_level_act:get_act_info(Level) || Level <- LevelList1]),
    % 活动判断排序（主要针对类型1的活动）
    %   1. 未开启过的活动优先级更高
    %   2. 都未开启过，则按活动类型更小的优先级更高
    %   3. 都开启过，则上次开启时间更早的活动优先级更高
    SortF = fun(Act1, Act2) -> % ({Type1, SubType1}, {Type2, SubType2})
        HasJoin1 = maps:get(Act1, JoinMap, 0),
        HasJoin2 = maps:get(Act2, JoinMap, 0),
        if
            HasJoin1 /= ?HAS_JOIN, HasJoin2 == ?HAS_JOIN -> true;
            HasJoin1 == ?HAS_JOIN, HasJoin2 /= ?HAS_JOIN -> false;
            HasJoin1 /= ?HAS_JOIN, HasJoin2 /= ?HAS_JOIN -> Act1 =< Act2;
            HasJoin1 == ?HAS_JOIN, HasJoin2 == ?HAS_JOIN ->
                #lv_act_data{open_time = OpTime1} = maps:get(Act1, Map, #lv_act_data{}),
                #lv_act_data{open_time = OpTime2} = maps:get(Act2, Map, #lv_act_data{}),
                OpTime1 =< OpTime2
        end
    end,
    ActList = lists:sort(SortF, ActList0), % 确保活动类型和子类型按顺序检查开启

    Fun = fun
        ({Type, _SubType}, {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}) when Type == ?LEVEL_HELP_GIFT ->
            {TemActMap, TemJoinMap, AccL1, AccL2, TRef2};
        ({Type, SubType}, {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}) ->
            case check_base_can_open(Type, SubType, ActState) of
                true ->
                    case data_level_act:get_act_cfg(Type, SubType) of
                        #base_lv_act_open{clear_type = _ClearType, circuit = Circuit, continue_time = ContinueTime, conditions = Conditions} when Circuit == ?ACT_OPEN ->
                            case lists:keyfind(open_day, 1, Conditions) of
                                {open_day, MinOpenDay} -> skip;
                                _ -> MinOpenDay = 0
                            end,
                            OpenDay = util:get_open_day(),
                            if
                                OpenDay >= MinOpenDay ->
                                    case lists:keyfind(act_type, 1, Conditions) of
                                        {_, ?LEVEL_ACT_TYPE_CUSTOM_ACT} ->
                                            IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
                                            #custom_act_cfg{clear_type = ClearType, condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                                            IsWlvEnougth = case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                                                #act_info{wlv = Wlv} ->
                                                    case lists:keyfind(wlv, 1, ActConditions) of
                                                        {_, [{Min, Max}|_]} when Max >= Wlv andalso Min =< Wlv -> true;
                                                        {_, _} -> false;
                                                        _ -> true
                                                    end;
                                                _ ->
                                                    false
                                            end,
                                            if
                                                IsOpen == true andalso IsWlvEnougth == true ->
                                                    {Stime, EndTime} = calc_end_time(Type, SubType, ContinueTime, Now),
                                                    GradeStatus = calc_default_state(Type, SubType),
                                                    #lv_act_data{status = OldGradeStatus, open_times = OpenTimes} = maps:get({Type, SubType}, TemActMap, #lv_act_data{status = GradeStatus}),
                                                    LvActData = #lv_act_data{key = {Type,SubType}, open_time = Now, end_time = EndTime, status = GradeStatus, stime = Stime},
                                                    NewAccL1 = [[RoleId, Type, SubType, Now, EndTime, util:term_to_string(GradeStatus), Now, OpenTimes, util:term_to_string(OldGradeStatus)]|AccL1],
                                                    NewAccL2 = [[RoleId, Type, SubType, Now]|AccL2],
                                                    {maps:put({Type, SubType}, LvActData, TemActMap), maps:put({Type, SubType}, ?HAS_JOIN, TemJoinMap), NewAccL1, NewAccL2, TRef2};
                                                true ->
                                                    case ClearType == ?CUSTOM_ACT_CLEAR_ZERO orelse ClearType == ?CUSTOM_ACT_CLEAR_FOUR of
                                                        true ->
                                                            NewMap = maps:remove({Type, SubType}, TemJoinMap);
                                                        _ ->
                                                            NewMap = TemJoinMap
                                                    end,
                                                    {maps:remove({Type, SubType}, TemActMap), NewMap, AccL1, AccL2, TRef2}
                                            end;
                                        {_, ?LEVEL_ACT_TYPE_ROLE_LEVEL} ->
                                            {_, GapTime} = ulists:keyfind(gap, 1, Conditions, {gap, 0}),
                                            {_, CycleContinueTime} = ulists:keyfind(cycle_time, 1, Conditions, {cycle_time, 0}), % 循环开启的活动持续时间
                                            {_, PushTimes} = ulists:keyfind(push_times, 1, Conditions, {push_times, 0}), % 循环开启次数上限
                                            HasJoin = maps:get({Type, SubType}, JoinMap, 0),
                                            GradeStatus0 = calc_default_state(Type, SubType),
                                            #lv_act_data{status = GradeStatus, open_times = OpenTimes} = maps:get({Type, SubType}, TemActMap, #lv_act_data{status = GradeStatus0}),
                                            case PushTimes == 0 orelse PushTimes > OpenTimes of
                                                true ->
                                                    case {is_enough_gap_time(maps:values(TemActMap), GapTime, HasJoin), is_enough_cycle_gap_time(TemActMap, Type, SubType)} of
                                                        {true, true} ->
                                                            ContinueTime1 = ?IF(CycleContinueTime > 0 andalso HasJoin == ?HAS_JOIN, CycleContinueTime, ContinueTime),
                                                            EndTime = calc_end_time(ContinueTime1, Now),
                                                            LvActData = #lv_act_data{key = {Type,SubType}, open_time = Now, end_time = EndTime, status = GradeStatus, stime = Now, open_times = OpenTimes + 1, old_status = GradeStatus},
                                                            NewAccL1 = [[RoleId, Type, SubType, Now, EndTime, util:term_to_string(GradeStatus), Now, OpenTimes + 1, util:term_to_string(GradeStatus)]|AccL1],
                                                            NewAccL2 = [[RoleId, Type, SubType, Now]|AccL2],
                                                            lib_log_api:log_level_act_open(RoleId, Type, SubType, Now, EndTime),
                                                            {maps:put({Type, SubType}, LvActData, TemActMap), maps:put({Type, SubType}, ?HAS_JOIN, TemJoinMap), NewAccL1, NewAccL2, TRef2};
                                                        {{false, LeastTime}, _} -> % 活动间间隔时间不足
                                                            TRef = util:send_after(TRef2, timer:seconds(LeastTime-Now), self(), {'mod', ?MODULE, init_data, []}),
                                                            {TemActMap, TemJoinMap, AccL1, AccL2, TRef};
                                                        {_, {false, LeastTime}} -> % 本活动开启间隔时间不足
                                                            TRef = util:send_after(TRef2, timer:seconds(LeastTime-Now), self(), {'mod', ?MODULE, init_data, []}),
                                                            {TemActMap, TemJoinMap, AccL1, AccL2, TRef}
                                                    end;
                                                _ ->
                                                    {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}
                                            end;
                                        _ ->
                                            {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}
                                    end;
                                true ->
                                    {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}
                            end;
                        _ ->
                            {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}
                    end;
                _ ->
                    {TemActMap, TemJoinMap, AccL1, AccL2, TRef2}
            end
    end,
    % 对各符合条件的活动进行参加及初始化数据
    {NewActMap, NewJoinMap, DbList1, DbList2, LevelActRef1} = lists:foldl(Fun, {Map, JoinMap, [], [], LevelActRef}, ActList),
    DbF = fun() ->
        Sql1 = usql:replace(role_lv_act_data, [role_id,type,sub_type,open_time,end_time,status,utime, open_times, old_status], DbList1),
        DbList1 =/= [] andalso db:execute(Sql1),
        Sql2 = usql:replace(lv_act_join_data, [role_id,act_type,act_subtype,stime], DbList2),
        DbList2 =/= [] andalso db:execute(Sql2),
        ok
    end,
    case catch db:transaction(DbF) of
        ok ->
            {AMap, RMap, NewCdList, NewCdRefL} = init_help_gift([?LEVEL_HELP_GIFT], PS, NewActMap, RewardMap, CdList, CdRefList, LoginType),
            ActState#lv_act_state{act_map = AMap, record_map = NewJoinMap, act_reward_rec = RMap, cd_list = NewCdList, cd_ref_list = NewCdRefL, level_act_ref = LevelActRef1};
        Error ->
            ?ERR("level act db error:~p", [Error]),
            ActState
    end.

%% 判断活动是否可以参与判断开启
%% @return boolean()
check_base_can_open(Type, SubType, ActState) ->
    #lv_act_state{act_map = ActMap, record_map = JoinMap} = ActState,
    #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
    #lv_act_data{status = GradeStatus} = maps:get({Type, SubType}, ActMap, #lv_act_data{}),

    HasJoined = maps:get({Type, SubType}, JoinMap, false),
    {_, ActType} = ulists:keyfind(act_type, 1, Conditions, {act_type, 0}),

    if
        HasJoined == false -> true;
        ActType == ?LEVEL_ACT_TYPE_ROLE_LEVEL ->
            GradeIdL = data_level_act:get_all_grade(Type, SubType),
            F = fun(GradeId) ->
                {_, BuyStatus} = ulists:keyfind(GradeId, 1, GradeStatus, {GradeId, ?NOT_BUY}),
                BuyStatus == ?HAS_BUY
            end,
            not lists:all(F, GradeIdL); % 是否没有全部购买完,不能用calc_is_all_buy/1,GradeStatus有可能是空的
        true ->
            false
    end.

act_open(Type, SubType, Stime, Etime) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        Fun = fun(E) ->
            timer:sleep(20),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_level_act, act_open, [Type, SubType, Stime, Etime])
        end,
        lists:foreach(Fun, OnlineRoles)
        end).

act_open(Player, Type, SubType, Stime, Etime) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    Now = utime:unixtime(),
    case LvActState of
        #lv_act_state{act_map = OMap, record_map = JoinMap, cd_list = OCdList, cd_ref_list = OCdRefList} = ActState ->
            {Map, CdList, CdRefList} = clear_act_timeout(RoleId, OMap, OCdList, OCdRefList);
        _ ->
            Map = db_select(RoleId, Now),
            JoinMap = db_select_rec(RoleId),
            {RewardMap, ActMap, CdList, CdRefList} = db_select_grade_rec(RoleId, Map),
            ActState = #lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, record_map = JoinMap, cd_list = CdList, cd_ref_list = CdRefList}
    end,
    case maps:get({Type, SubType}, JoinMap, []) of
        [] ->
            case data_level_act:get_act_cfg(Type, SubType) of
                #base_lv_act_open{clear_type = _ClearType, circuit = Circuit, continue_time = _ContinueTime, open_lv = OpenLv, conditions = Conditions}
                when Circuit == ?ACT_OPEN andalso OpenLv =< RoleLv ->
                    % EndTime = calc_end_time(ContinueTime, Now),
                    case lists:keyfind(open_day, 1, Conditions) of
                        {open_day, MinOpenDay} -> skip;
                        _ -> MinOpenDay = 0
                    end,
                    OpenDay = util:get_open_day(),
                    if
                        OpenDay >= MinOpenDay ->
                            EndTime = Etime,
                            GradeStatus = calc_default_state(Type, SubType),
                            LvActData = #lv_act_data{key = {Type,SubType}, end_time = EndTime, status = GradeStatus, stime = Stime},
                            db_replace(LvActData, RoleId),
                            db_replace_rec(RoleId, Type, SubType),
                            % SendList = [{Type, SubType, EndTime, GradeStatus}],
                            % lib_server_send:send_to_uid(RoleId, pt_612, 61202, [SendList]),
                            NewJoinMap = maps:put({Type, SubType}, ?HAS_JOIN, JoinMap),
                            NewMap = maps:put({Type, SubType}, LvActData, Map);
                        true ->
                            NewJoinMap = JoinMap,
                            NewMap = Map
                    end;
                _ ->
                    NewJoinMap = JoinMap,
                    NewMap = Map
            end;
        _ ->
            NewJoinMap = JoinMap,
            NewMap = Map
    end,
    NewActState = ActState#lv_act_state{act_map = NewMap, record_map = NewJoinMap, cd_list = CdList, cd_ref_list = CdRefList},
    if
        NewMap =/= Map ->
            SendList = pp_level_act:make_data_for_client(NewMap),
            lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]);
        true ->
            skip
    end,
    {ok, Player#player_status{lv_act = NewActState}}.

act_end(Type, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    db_delete(Type, SubType),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{clear_type = ClearType} when ClearType == ?CUSTOM_ACT_CLEAR_ZERO orelse ClearType == ?CUSTOM_ACT_CLEAR_FOUR ->
            db_delete_rec(Type, SubType);
        _ ->
            skip
    end,
    spawn(fun() ->
        Fun = fun(E) ->
            timer:sleep(20),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_level_act, act_end, [Type, SubType])
        end,
        lists:foreach(Fun, OnlineRoles)
        end).

act_end(Player, Type, SubType) ->
    #player_status{id = RoleId, lv_act = LvActState} = Player,
    Now = utime:unixtime(),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{clear_type = ClearType} when ClearType == ?CUSTOM_ACT_CLEAR_ZERO orelse ClearType == ?CUSTOM_ACT_CLEAR_FOUR ->
            NeedClearRec = true;
        _ ->
            NeedClearRec = false
    end,
    case LvActState of
        #lv_act_state{act_map = OMap, record_map = OJoinMap} = ActState ->
            if
                NeedClearRec == true ->
                    JoinMap = maps:remove({Type, SubType}, OJoinMap);
                true ->
                    JoinMap = OJoinMap
            end,
            Map = maps:remove({Type, SubType}, OMap),
            NewActState = ActState#lv_act_state{act_map = Map, record_map = JoinMap};
        _ ->
            Map = db_select(RoleId, Now),
            JoinMap = db_select_rec(RoleId),
            {RewardMap, ActMap, CdList, CdRefList} = db_select_grade_rec(RoleId, Map),
            NewActState = #lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, record_map = JoinMap, cd_list = CdList, cd_ref_list = CdRefList}
    end,
    {ok, Player#player_status{lv_act = NewActState}}.

%% 清理过期活动数据及更新助力礼包计时状态
clear_act_timeout(RoleId, ActMap, CdList, CdRefList) ->
    ActList = maps:to_list(ActMap),
    Now = utime:unixtime(),
    Fun = fun
        % 已购买的助力礼包
        ({_Key, #lv_act_data{key = {Type,SubType}, status = [{Grade, ?HAS_BUY}|_], ref = OldRef, stime = Optime}}, {TemMap, AccCd, AccRef}) when Type == ?LEVEL_HELP_GIFT ->
            db_replace_grade_rec(RoleId, Type, SubType, Grade, ?HAS_BUY, Now),
            case data_level_act:get_act_cfg(Type, SubType) of
                #base_lv_act_open{conditions = Conditions} ->
                    case lists:keyfind(cd, 1, Conditions) of
                        {_, CdCFG} ->
                            Cd = Optime + CdCFG*60;
                        _ ->
                            Cd = Optime
                    end;
                _ ->
                    Cd = Optime
            end,
            NewCdL = lists:keystore({Type, SubType}, 1, AccCd, {{Type, SubType}, Cd}),
            NewCdRefL = calc_cd_ref(NewCdL, AccRef, Type),
            util:cancel_timer(OldRef),
            {TemMap, NewCdL, NewCdRefL};
        % 未过期的礼包
        ({Key, #lv_act_data{end_time = EndTime} = LvActData}, {TemMap, AccCd, AccRef}) when EndTime > Now ->
            {maps:put(Key, LvActData, TemMap), AccCd, AccRef};
        % 已过期的助力礼包
        ({_Key, #lv_act_data{key = {Type,SubType}, status = [{Grade, _}|_], end_time = EndTime, ref = OldRef}}, {TemMap, AccCd, AccRef}) when Type == ?LEVEL_HELP_GIFT ->
            db_replace_grade_rec(RoleId, Type, SubType, Grade, ?TIME_END, EndTime),
            case data_level_act:get_act_cfg(Type, SubType) of
                #base_lv_act_open{conditions = Conditions} ->
                    case lists:keyfind(cd, 1, Conditions) of
                        {_, CdCFG} ->
                            Cd = EndTime + CdCFG*60;
                        _ ->
                            Cd = EndTime
                    end;
                _ ->
                    Cd = EndTime
            end,
            NewCdL = lists:keystore({Type, SubType}, 1, AccCd, {{Type, SubType}, Cd}),
            NewCdRefL = calc_cd_ref(NewCdL, AccRef, Type),
            util:cancel_timer(OldRef),
            {TemMap, NewCdL, NewCdRefL};
        % 其他过期礼包
        ({_Key, #lv_act_data{key = {Type,SubType}} = LvActData}, {TemMap, AccCd, AccRef}) ->
            #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
            case ulists:keyfind(act_type, 1, Conditions, {act_type, 0}) of
                {act_type, ?LEVEL_ACT_TYPE_ROLE_LEVEL} ->
                    {maps:put({Type,SubType}, LvActData, TemMap), AccCd, AccRef};
                _ ->
                    db_delete(RoleId, Type, SubType),
                    {TemMap, AccCd, AccRef}
            end
    end,
    lists:foldl(Fun, {#{}, CdList, CdRefList}, ActList).

is_enough_gap_time(_, _, 0) -> true; % 策划要求：首次开启不判断活动间间隔时间
is_enough_gap_time(LevelActDatas, GapTime, _HasJoin) ->
    IsLevelType = fun(#lv_act_data{key = {Type, SubType}}) ->
        #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
        {_, ActType} = ulists:keyfind(act_type, 1, Conditions, {act_type, -1}),
        ActType == ?LEVEL_ACT_TYPE_ROLE_LEVEL % 目前gap配置只有等级控制类型适用
    end,
    NowTime = utime:unixtime(),
    StartTime = lists:max([OpenTime || #lv_act_data{open_time = OpenTime} = LevelActData <- LevelActDatas, IsLevelType(LevelActData)] ++ [0]), % 空列表容错
    LeastTime = StartTime + GapTime, % 最早可以开启下个等级控制类型活动的时间
    case NowTime >= LeastTime of
        true ->
            true;
        false ->
            {false, LeastTime}
    end.

%% 活动循环间隔时间判断(以结束时间作判断)
is_enough_cycle_gap_time(ActMap, Type, SubType) ->
    NowTime = utime:unixtime(),
    #lv_act_data{end_time = EndTime} = maps:get({Type, SubType}, ActMap, #lv_act_data{end_time = 0}),
    #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
    {_, CycleGapTime} = ulists:keyfind(cycle_gap, 1, Conditions, {cycle_gap, 0}),
    case NowTime >= EndTime + CycleGapTime of
        true -> true;
        false -> {false, EndTime + CycleGapTime}
    end.

%% 获取活动默认状态（所有礼包为购买状态）
calc_default_state(Type, SubType) ->
    GradeList = data_level_act:get_all_grade(Type, SubType),
    Fun = fun(Grade, Acc) ->
        lists:keystore(Grade, 1, Acc, {Grade, ?NOT_BUY})
    end,
    lists:foldl(Fun, [], GradeList).

%% 获取活动起始时间
calc_end_time(Type, SubType, ContinueTime, Now) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime = Stime, etime = Etime} -> {Stime, Etime};
        _ ->
            Etime = calc_end_time(ContinueTime, Now),
            {Now, Etime}
    end.

calc_end_time(Type, SubType, OpenTime) when Type == ?LEVEL_HELP_GIFT ->
    case data_level_act:get_act_cfg(Type, SubType) of
        #base_lv_act_open{circuit = Circuit, continue_time = ContinueTime} when Circuit == ?ACT_OPEN ->
            % OpenTime + ContinueTime*3600;
            OpenTime + ContinueTime*60;
        _ ->
            OpenTime
    end;
calc_end_time(_,_,_) -> 0.

calc_end_time(ContinueTime, Now) when is_integer(ContinueTime) ->
    UnixData = utime:unixdate(Now),
    ContinueTime*86400+UnixData;
calc_end_time(ContinueTime, Now) when is_list(ContinueTime) ->
    UnixData = utime:unixdate(Now),
    Time1 = case lists:keyfind(day, 1, ContinueTime) of
        {day, Day} ->
            Day*86400+UnixData;
        _ ->
            UnixData
    end,
    case lists:keyfind(hour, 1, ContinueTime) of
        {hour, Hour} ->
            Hour*3600+Time1;
        _ ->
            Time1
    end;
calc_end_time(_, Now) -> Now.

% calc_start_time(#lv_act_data{key = {Type, SubType}, end_time = EndTime}) ->
%     #base_lv_act_open{continue_time = ContinueTime, conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
%     Duration =
%     case is_integer(ContinueTime) of
%         true -> ContinueTime * 86400;
%         false ->
%             {_, Day} = ulists:keyfind(day, 1, Conditions, {day, 0}),
%             {_, Hour} = ulists:keyfind(hour, 1, Conditions, {hour, 0}),
%             Day * 86400 + Hour * 3600
%     end,
%     EndTime - Duration.

% 按活动时间刷新活动数据
calc_act_data(Map, RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, ClearType, LoginTime, OpenTimes, OldStatus) when ClearType == ?CLEAR_TYPE_ACT_END ->
    #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
    {_, ActType} = ulists:keyfind(act_type, 1, Conditions, {act_type, 0}),
    if
        ActType == ?LEVEL_ACT_TYPE_ROLE_LEVEL -> % 等级限制活动不清理
            LvActData = #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus},
            maps:put({Type, SubType}, LvActData, Map);
        EndTime =< LoginTime ->
            db_delete(RoleId, Type, SubType),
            Map;
        true ->
            IsSameDay = utime:is_same_day(LoginTime, Stime),
            if
                IsSameDay == true ->
                    LvActData = #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus},
                    maps:put({Type, SubType}, LvActData, Map);
                true ->
                    case calc_is_all_buy(Status) of
                        true ->
                            db_delete(RoleId, Type, SubType),
                            Map;
                        _ ->
                            LvActData = #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus},
                            maps:put({Type, SubType}, LvActData, Map)
                    end
            end

    end;
% 按游戏自然日刷新活动数据
calc_act_data(Map, RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, ClearType, LoginTime, OpenTimes, OldStatus) when ClearType == ?CLEAR_TYPE_ZERO ->
    IsSameDay = utime:is_same_day(LoginTime, Stime),
    if
        IsSameDay == true ->
            LvActData = #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus},
            maps:put({Type, SubType}, LvActData, Map);
        true ->
            db_delete(RoleId, Type, SubType),
            Map
    end;
% 按游戏刷新日刷新活动数据
calc_act_data(Map, RoleId, Type, SubType, OpenTime, EndTime, Status, Stime, ClearType, LoginTime, OpenTimes, OldStatus) when ClearType == ?CLEAR_TYPE_FOUR ->
    IsSameDay = utime_logic:is_logic_same_day(LoginTime, Stime),
    if
        IsSameDay == true ->
            LvActData = #lv_act_data{key = {Type,SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = Stime, open_times = OpenTimes, old_status = OldStatus},
            maps:put({Type, SubType}, LvActData, Map);
        true ->
            db_delete(RoleId, Type, SubType),
            Map
    end;
calc_act_data(Map, _, _, _, _, _, _, _, _, _, _, _) -> Map.

calc_real_cost(CostCfg, _Conditions) when is_list(CostCfg) ->
    CostCfg;
calc_real_cost(CostCfg, Conditions) when is_integer(CostCfg) ->
    case lists:keyfind(cost_type, 1, Conditions) of
        {_, CostType} -> CostType;
        _ -> CostType = 1
    end,
    [{CostType, 0, CostCfg}];
calc_real_cost(_, _) -> [].

day_clear() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_level_act, day_clear, []) || E <- OnlineRoles].

day_clear(Player) ->
    #player_status{lv_act = OldActState, id = RoleId, figure = #figure{name = _RoleName, lv = RoleLv}} = Player,
    % NowTime = utime:unixtime(),
    NewActState = init_data(Player, OldActState, RoleId, RoleLv),
    SendList = pp_level_act:make_data_for_client(NewActState#lv_act_state.act_map),
    lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]),
    NewPlayer = Player#player_status{lv_act = NewActState},
    {ok, NewPlayer}.

calc_is_all_buy(Status) ->
    Fun = fun({_, State}) ->
        State == ?NOT_BUY
    end,
    case ulists:find(Fun, Status) of
        {ok, _} ->
            false;
        _ -> true
    end.

judge_pay_limit(Type, SubType, Paid) ->
    #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
    % ?PRINT("========= Conditions:~p,Paid:~p~n",[Conditions,Paid]),
    case lists:keyfind(need_paid, 1, Conditions) of
        {_, 1} when Paid == true ->
            true;
        {_, 0} ->
            true;
        _ ->
            false
    end.

%% 初始化或更新助力礼包活动数据
init_help_gift([], _PS, ActMap, RewardMap, CdList, CdRefList, _LoginType) -> {ActMap, RewardMap, CdList, CdRefList};
init_help_gift([Type|T], PS, ActMap, RewardMap, CdList, CdRefList, LoginType) when Type == ?LEVEL_HELP_GIFT ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName}, vip = #role_vip{vip_exp = Exp}, is_pay = Paid, online = _Online} = PS,
    SubTypeList = data_level_act:get_act_subtype(Type),
    Fun = fun(SubType, {TemMap, TemMapRec, TemcdList}) ->
        case maps:get({Type, SubType}, TemMap, []) of
            % 未参与
            [] ->
                List = maps:get({Type, SubType}, TemMapRec, []),
                case lists:keyfind({Type, SubType}, 1, TemcdList) of
                    {_, Cd} when NowTime < Cd -> IsCDpass = false;
                    _ -> IsCDpass = true
                end,
                case get_gift_grade(Type, SubType, util:floor(Exp / ?VIP_CONVERT), List) of
                    Grade when is_integer(Grade) andalso Grade > 0 andalso IsCDpass == true ->
                        CanSend = judge_pay_limit(Type, SubType, Paid),
                        if
                            CanSend == true ->
                                EndTime = calc_end_time(Type, SubType, NowTime),
                                NewRef = util:send_after([], max((EndTime - NowTime)*1000, 500), self(),  {'mod', lib_level_act, init_data, []}),
                                LvActData = #lv_act_data{key = {Type,SubType}, end_time = EndTime, status = [{Grade, ?NOT_BUY}], stime = NowTime,
                                    open_time = NowTime, ref = NewRef},
                                #base_lv_gift_reward{reward = Reward, circle = Circle} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
                                lib_log_api:log_level_gift_send(Type, SubType, Grade, RoleId, RoleName, RoleLv, util:floor(Exp / ?VIP_CONVERT), Reward),
                                NewMap = maps:put({Type, SubType}, LvActData, TemMap),
                                db_replace_grade_rec(RoleId, Type, SubType, Grade, ?NOT_BUY, NowTime),
                                NewList = lists:keystore(Grade, 1, List, {Grade, ?NOT_BUY, Circle, EndTime, util:get_open_day(EndTime)}),
                                {NewMap, maps:put({Type, SubType}, NewList, TemMapRec), TemcdList};
                            true ->
                                {TemMap, TemMapRec, TemcdList}
                        end;
                    _E ->
                        {TemMap, TemMapRec, TemcdList}
                end;
            % 已购买
            #lv_act_data{status = [{OldGrade, ?HAS_BUY}|_], stime = Optime, end_time = _OldEndTime, ref = OldRef} ->
                util:cancel_timer(OldRef),
                List = maps:get({Type, SubType}, TemMapRec, []),
                case data_level_act:get_act_cfg(Type, SubType) of
                    #base_lv_act_open{conditions = Conditions} ->
                        case lists:keyfind(cd, 1, Conditions) of
                            {_, CdCFG} ->
                                Cd = Optime + CdCFG*60;
                            _ ->
                                Cd = Optime
                        end;
                    _ ->
                        Cd = Optime
                end,
                NewTemCdL = lists:keystore({Type, SubType}, 1, TemcdList, {{Type, SubType}, Cd}),
                IsCDpass = ?IF(Cd > NowTime, false, true),
                case get_gift_grade(Type, SubType, util:floor(Exp / ?VIP_CONVERT), List) of
                    Grade when is_integer(Grade) andalso Grade > 0 andalso Grade =/= OldGrade andalso IsCDpass == true ->
                        CanSend = judge_pay_limit(Type, SubType, Paid),
                        if
                            CanSend == true ->
                                EndTime = calc_end_time(Type, SubType, NowTime),
                                NewRef = util:send_after([], max((EndTime - NowTime)*1000, 500), self(),  {'mod', lib_level_act, init_data, []}),
                                LvActData = #lv_act_data{key = {Type,SubType}, end_time = EndTime, status = [{Grade, ?NOT_BUY}], stime = NowTime, open_time = NowTime, ref = NewRef},
                                NewMap = maps:put({Type, SubType}, LvActData, TemMap),
                                #base_lv_gift_reward{reward = Reward, circle = Circle} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
                                lib_log_api:log_level_gift_send(Type, SubType, Grade, RoleId, RoleName, RoleLv, util:floor(Exp / ?VIP_CONVERT), Reward),
                                db_replace_grade_rec(RoleId, Type, SubType, Grade, ?NOT_BUY, NowTime),
                                NewList = lists:keystore(Grade, 1, List, {Grade, ?NOT_BUY, Circle, EndTime, util:get_open_day(EndTime)}),
                                {NewMap, maps:put({Type, SubType}, NewList, TemMapRec), NewTemCdL};
                            true ->
                                {TemMap, TemMapRec, NewTemCdL}
                        end;
                    OldGrade ->
                        NewList = lists:keystore(OldGrade, 1, List, {OldGrade, ?HAS_BUY, Optime}),
                        db_replace_grade_rec(RoleId, Type, SubType, OldGrade, ?HAS_BUY, Optime),
                        {maps:remove({Type, SubType}, TemMap), maps:put({Type, SubType}, NewList, TemMapRec), NewTemCdL};
                    _ ->
                        {TemMap, TemMapRec, NewTemCdL}
                end;
            _E ->
                {TemMap, TemMapRec, TemcdList}
        end
    end,
    if
        LoginType == ?ONHOOK_AGENT_LOGIN orelse _Online =/= ?ONLINE_ON ->
            NewactMap = ActMap, NewRewardMap = RewardMap, NewCdList = CdList;
        true ->
            % ?PRINT("=========== RoleId:~p~n",[RoleId]),
            {NewactMap, NewRewardMap, NewCdList} = lists:foldl(Fun, {ActMap, RewardMap, CdList}, SubTypeList)
    end,
    NewCdRefL = calc_cd_ref(NewCdList, CdRefList, Type),
    init_help_gift(T, PS, NewactMap, NewRewardMap, NewCdList, NewCdRefL, LoginType);

init_help_gift([_|T], PS, ActMap, RewardMap, CdList, CdRefList, LoginType) ->
    init_help_gift(T, PS, ActMap, RewardMap, CdList, CdRefList, LoginType).

get_produce_type(Type) when Type == ?LEVEL_HELP_GIFT ->
    level_act_help_gift;
get_produce_type(_) ->
    level_act_shop.

refresh_recharge(Player, ProductId) ->
    #player_status{id = RoleId, lv_act = LvActState, figure = #figure{lv = RoleLv, name = RoleName}} = Player,
    case data_level_act:get_act_information(ProductId) of
        [{Type, SubType, Grade}|_] ->
            #lv_act_state{act_map = ActMap, act_reward_rec = RewardMap, cd_list = CdList} = LvActState,
            case maps:get({Type, SubType}, ActMap, []) of
                #lv_act_data{status = [{Grade, ?NOT_BUY}|_], end_time = _OldEndTime, ref = OldRef} ->
                    util:cancel_timer(OldRef),
                    NewActMap = maps:remove({Type, SubType}, ActMap),
                    #base_lv_gift_reward{cost = CostCfg, reward_name = RewardName, circle = Circle, reward = RewardL, condition = Conditions} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
                    List = maps:get({Type, SubType}, RewardMap, []),
                    NewList = lists:keystore(Grade, 1, List, {Grade, ?HAS_BUY, Circle, utime:unixtime(), util:get_open_day()}),
                    db_replace_grade_rec(RoleId, Type, SubType, Grade, ?HAS_BUY, utime:unixtime()),
                    NewRewardMap = maps:put({Type, SubType}, NewList, RewardMap),
                    #base_lv_act_open{open_lv = OpenLv, act_name = ActName, conditions = ActConditions} = data_level_act:get_act_cfg(Type, SubType),


                    case lists:keyfind(cd, 1, ActConditions) of
                        {_, CdCFG} ->
                            Cd = utime:unixtime() + CdCFG*60;
                        _ ->
                            Cd = utime:unixtime()
                    end,
                    NewCdList = lists:keystore({Type, SubType}, 1, CdList, {{Type, SubType}, Cd}),

                    NewActState = LvActState#lv_act_state{act_map = NewActMap, act_reward_rec = NewRewardMap, cd_list = NewCdList},
                    lib_server_send:send_to_uid(RoleId, pt_612, 61201, [Type, SubType, Grade, 1]),
                    case lists:keyfind(tv, 1, Conditions) of
                        {tv, Mod, TvId} ->
                            Data = [RoleName, RoleId, ActName, RewardName],
                            lib_chat:send_TV({all_lv, OpenLv, 999}, Mod, TvId, Data);
                        _ ->
                            skip
                    end,
                    ProduceCostType = get_produce_type(Type),
                    RealCost = lib_level_act:calc_real_cost(CostCfg, Conditions),
                    Produce = #produce{type = ProduceCostType, subtype = 0, reward = RewardL, remark = "",  show_tips = 1},
                    RealNewActState = init_data(Player, NewActState, RoleId, RoleLv),
                    % ?PRINT("ActMap:~p,NewActMap:~p~n,RewardMap:~p,NewRewardMap:~p,NewCdList:~p~n",[ActMap, RealNewActState#lv_act_state.act_map,RewardMap,RealNewActState#lv_act_state.act_reward_rec,NewCdList]),
                    SendList = pp_level_act:make_data_for_client(RealNewActState#lv_act_state.act_map),
                    lib_server_send:send_to_uid(RoleId, pt_612, 61200, [SendList]),
                    NewPlayer = Player#player_status{lv_act = RealNewActState},
                    NewPS = lib_goods_api:send_reward(NewPlayer, Produce),
                    lib_log_api:log_level_act(NewPS, RoleName, Type, SubType, Grade, RealCost, RewardL),
                    NewPS;
                _Res ->
                    Player
            end;
        _ ->
            Player
    end.

get_gift_grade(Type, SubType, VipExp, RewardRecList) ->
    OpenDay = util:get_open_day(),
    get_gift_grade(Type, SubType, VipExp, RewardRecList, OpenDay).

get_gift_grade(Type, SubType, VipExp, RewardRecList, OpenDay) ->
    DayList = data_level_act:get_gift_day_limit(),
    Fun = fun({DayMin, DayMax}) ->
        OpenDay >= DayMin andalso OpenDay =< DayMax
    end,
    case ulists:find(Fun, lists:reverse(DayList)) of
        {_, {Min, Max}} ->
            GradeList = data_level_act:get_grade_by_day(Min, Max),
            Fun1 = fun({TemGrade, _, _, _, _}, Acc) ->
                case lists:member(TemGrade, GradeList) of
                    true ->
                        [TemGrade|Acc];
                    _ ->
                        Acc
                end
            end,
            case lists:foldl(Fun1, [], RewardRecList) of
                [GradeSort|_] = SendGradeList ->
                    [OldSort] = data_level_act:get_grade_sort(Type, SubType, GradeSort),
                    GradeCfgList = data_level_act:get_act_info_by_sort(OldSort, Min, Max),
                    get_gift_grade_helper(Type, SubType, SendGradeList, GradeCfgList, VipExp);
                _ ->
                    get_gift_grade_helper1(Type, SubType, GradeList, VipExp)
            end;
        _ ->
            get_circle_type_by_record(Type, SubType, VipExp, RewardRecList, OpenDay)
    end.


get_gift_grade_helper1(_Type, _SubType, [], _VipExp) -> 0;
get_gift_grade_helper1(Type, SubType, [Grade|T], VipExp) ->
    #base_lv_gift_reward{vip_min = VipMin, vip_max = VipMax, open_day_min = OpenDayMin, circle = Circle} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
    OpenDay = util:get_open_day(),
    if
        Circle =/= 0 andalso OpenDay >= OpenDayMin andalso ((OpenDay - OpenDayMin) rem Circle == 0) ->
            if
                VipExp >= VipMin andalso VipExp =< VipMax ->
                    Grade;
                true ->
                    get_gift_grade_helper1(Type, SubType, T, VipExp)
            end;
        Circle == 0 andalso VipExp >= VipMin andalso VipExp =< VipMax ->
            Grade;
        true ->
            get_gift_grade_helper1(Type, SubType, T, VipExp)
    end.

get_gift_grade_helper2(_Type, _SubType, [], _VipExp) -> 0;
get_gift_grade_helper2(Type, SubType, [Grade|T], VipExp) ->
    #base_lv_gift_reward{vip_min = VipMin, vip_max = VipMax} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
    if
        VipExp >= VipMin andalso VipExp =< VipMax ->
            Grade;
        true ->
            get_gift_grade_helper2(Type, SubType, T, VipExp)
    end.

get_gift_grade_helper(_Type, _SubType, _SendGradeList, [], _VipExp) -> 0;
get_gift_grade_helper(Type, SubType, SendGradeList, [{TemType, TemSubType, Grade}|T], VipExp) when Type == TemType andalso SubType == TemSubType ->
    case lists:member(Grade, SendGradeList) of
        true ->
            get_gift_grade_helper(Type, SubType, SendGradeList, T, VipExp);
        _ ->
            #base_lv_gift_reward{vip_min = VipMin, vip_max = VipMax} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
            if
                VipExp >= VipMin andalso VipExp =< VipMax ->
                    Grade;
                true ->
                    get_gift_grade_helper(Type, SubType, SendGradeList, T, VipExp)
            end
    end;
get_gift_grade_helper(Type, SubType, SendGradeList, [{_, _, _}|T], VipExp) -> get_gift_grade_helper(Type, SubType, SendGradeList, T, VipExp).

handle_record(_, _, [], NeedCalcRecord, _DayList) -> NeedCalcRecord;
handle_record(Type, SubType, [{Grade, State, Circle, EndTime, SOpenDay}|T], NeedCalcRecord, DayList) when Circle > 0 ->
    #base_lv_gift_reward{open_day_min = OpenDayMin, open_day_max = OpenDayMax} = data_level_act:get_gift_reward_cfg(Type, SubType, Grade),
    case lists:keyfind({OpenDayMin, OpenDayMax}, 1, DayList) of
        {_, TemGrade} ->
            case lists:keyfind(TemGrade, 1, NeedCalcRecord) of
                {TemGrade, _, _, TemEndTime, _} when TemEndTime > EndTime ->
                    NewNeedCalcRecord = NeedCalcRecord,
                    NewDayList = DayList;
                _ ->
                    TemList = lists:keydelete(TemGrade, 1, NeedCalcRecord),
                    NewNeedCalcRecord = lists:keystore(Grade, 1, TemList, {Grade, State, Circle, EndTime, SOpenDay}),
                    NewDayList = lists:keystore({OpenDayMin, OpenDayMax}, 1, DayList, {{OpenDayMin, OpenDayMax}, Grade})
            end;
        _ ->
            NewNeedCalcRecord = lists:keystore(Grade, 1, NeedCalcRecord, {Grade, State, Circle, EndTime, SOpenDay}),
            NewDayList = lists:keystore({OpenDayMin, OpenDayMax}, 1, DayList, {{OpenDayMin, OpenDayMax}, Grade})
    end,
    handle_record(Type, SubType, T, NewNeedCalcRecord, NewDayList);
handle_record(Type, SubType, [{_, _, _, _, _}|T], NeedCalcRecord, DayList) ->
    handle_record(Type, SubType, T, NeedCalcRecord, DayList).

get_circle_type_by_record(Type, SubType, VipExp, RewardRecList, OpenDay) ->
    CircleList = data_level_act:get_circle_type(),
    Fun = fun(Circle, AccList) when Circle > 0 ->
        GradeList = data_level_act:get_circle_grade(Circle),
        GradeList ++ AccList;
        (_, AccList) -> AccList
    end,
    Grades = lists:foldl(Fun, [], CircleList),
    NewRecordList = handle_record(Type, SubType, RewardRecList, [], []),
    Fun1 = fun
        ({OldGrade, _, Circle, _, SOpenDay}, {Acc, Acc1}) when Circle > 0 ->
            #base_lv_gift_reward{open_day_min = OpenDayMin, open_day_max = OpenDayMax}
            = data_level_act:get_gift_reward_cfg(Type, SubType, OldGrade),
            SameDayGradeL = data_level_act:get_grade_by_day(OpenDayMin, OpenDayMax),
            NewAcc = if
                SOpenDay =/= OpenDay andalso (OpenDay - OpenDayMin > 0) andalso ((OpenDay - OpenDayMin) rem Circle == 0) ->
                    case get_gift_grade_helper2(Type, SubType, SameDayGradeL, VipExp) of
                        0 -> Acc;
                        Grade ->
                            case lists:keyfind(Circle, 1, Acc) of
                                {Circle, [{_, TOpenDay}|_]} when TOpenDay > SOpenDay ->
                                    lists:keystore(Circle, 1, Acc, {Circle, [{Grade, SOpenDay}]});
                                {Circle, _} ->
                                    Acc;
                                _ ->
                                    lists:keystore(Circle, 1, Acc, {Circle, [{Grade, SOpenDay}]})
                            end
                    end;
                true ->
                    Acc
            end,
            {NewAcc, Acc1 -- SameDayGradeL};
        (_, Acc) -> Acc
    end,
    {List, OtherGradeList} = lists:foldl(Fun1, {[], Grades}, NewRecordList),
    if
        List == [] ->
            get_gift_grade_helper1(Type, SubType, OtherGradeList, VipExp);
        true ->
            [{_Circle, [{Grade, _}]}|_] = lists:reverse(lists:keysort(1, List)),
            Grade
    end.

%% 新增等级抢购礼包支持直购功能
recharge_lv_act(Player, ProductId, Money) ->
    #player_status{ id = PlayerId, lv_act = LvActState, figure = #figure{ lv = PlayerLv, name = PlayerName}} = Player,
    case data_level_act:get_act_info_by_recharge(ProductId) of
        [{Type, SubType, Grade}|_] ->
            #lv_act_state{ act_map = LvActMap} = LvActState,
            OldData = maps:get({Type, SubType}, LvActMap, []),
            case OldData of
                [] ->
                    BuyStatus = none,
                    GradeStatus = [],
                    OldRef = [];
                _ ->
                    #lv_act_data{status = GradeStatus, ref = OldRef} = OldData,
                    BuyStatus = proplists:get_value(Grade, GradeStatus, none)
            end,
            case BuyStatus =/= none of
                true ->
                    #base_lv_act_reward{
                        reward_name = RewardName, reward = RewardL, condition = Conditions
                    } = data_level_act:get_act_reward_cfg(Type, SubType, Grade),
                    #base_lv_act_open{
                        open_lv = OpenLv, act_name = ActName, conditions = ActConditions
                    } = data_level_act:get_act_cfg(Type, SubType),
                    %% 传闻处理
                    case lists:keyfind(tv, 1, Conditions) of
                        {tv, Mod, TvId} ->
                            case lists:keyfind(pic, 1, ActConditions) of
                                {_, JumpId} -> skip;
                                _ -> JumpId = 0
                            end,
                            Data = [PlayerName, PlayerId, ActName, RewardName, JumpId],
                            lib_chat:send_TV({all_lv, OpenLv, 999}, Mod, TvId, Data);
                        _ ->
                            skip
                    end,
                    ProduceRewardType = lib_level_act:get_produce_type(Type),
                    Produce = #produce{type = ProduceRewardType, subtype = 0, reward = RewardL, remark = "",  show_tips = 1},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    RealCost = [{?MONEY_TYPE_MONEY, 0, Money}],
                    lib_log_api:log_level_act(NewPlayer, PlayerName, Type, SubType, Grade, RealCost, RewardL),
                    util:cancel_timer(OldRef),
                    NewGradeStatus = lists:keystore(Grade, 1, GradeStatus, {Grade, ?HAS_BUY}),
                    LvActData = OldData#lv_act_data{status = NewGradeStatus, stime = utime:unixtime()},
                    lib_level_act:db_replace(LvActData, PlayerId),
                    NewMap = maps:put({Type, SubType}, LvActData, LvActMap),
                    NewActState = LvActState#lv_act_state{act_map = NewMap},
                    lib_server_send:send_to_uid(PlayerId, pt_612, 61201, [Type, SubType, Grade, 1]),
                    RealNewActState = lib_level_act:init_data(NewPlayer, NewActState, PlayerId, PlayerLv),
                    SendList = pp_level_act:make_data_for_client(RealNewActState#lv_act_state.act_map),
                    lib_server_send:send_to_uid(PlayerId, pt_612, 61200, [SendList]),
                    NewPlayer#player_status{lv_act = RealNewActState};
                _ ->
                    Player
            end;
        _ ->
            Player
    end.

%% 秘籍：恢复玩家等级控制活动数据
%% @return {被恢复的数据数, 被恢复的玩家数, 前10个被恢复的玩家}
gm_restore_role_level_act_data() ->
    % 获取所有玩家等级控制活动类型（包括配置circuit中关闭的）
    LevelList = data_level_act:get_all_lv_limit(),
    ActList = lists:merge([data_level_act:get_act_info(Level) || Level <- LevelList]),
    F0 = fun({Type, SubType}, AccL) ->
        #base_lv_act_open{conditions = Conditions} = data_level_act:get_act_cfg(Type, SubType),
        case lists:keyfind(act_type, 1, Conditions) of
            {_, ?LEVEL_ACT_TYPE_ROLE_LEVEL} -> [Type | AccL];
            _ -> AccL
        end
    end,
    LevelActL = lists:foldl(F0, [], ActList),
    LevelActTypeStr = ulists:to_sql_list(LevelActL),
    ?PRINT("level act type str ~p~n", [LevelActTypeStr]),

    % 玩家当前活动数据
    %  #{{RoleId, Type, SubType} => #lv_act_data{}}
    Sql1 = <<"select role_id, type, sub_type, open_time, end_time, status, utime from role_lv_act_data where type in (~s)">>,
    RoleActDbData = db:get_all(io_lib:format(Sql1, [LevelActTypeStr])),
    F1 = fun([RoleId, Type, SubType, OpenTime, EndTime, StatusBin, UTime], AccM) ->
        Status = util:bitstring_to_term(StatusBin),
        LvActData = #lv_act_data{key = {Type, SubType}, open_time = OpenTime, end_time = EndTime, status = Status, stime = UTime},
        AccM#{{RoleId, Type, SubType} => LvActData}
    end,
    RoleActMap = lists:foldl(F1, #{}, RoleActDbData),

    % 玩家参与记录数据
    % {#{{RoleId, Type, SubType} => StartTime}, #{{RoleId, Type, SubType} => #lv_act_data{}}}
    Sql2 = <<"select role_id, act_type, act_subtype, stime from lv_act_join_data where act_type in (~s)">>,
    RoleJoinDbData = db:get_all(io_lib:format(Sql2, [LevelActTypeStr])),
    F2 = fun([RoleId, Type, SubType, STime], AccM) ->
        #base_lv_act_open{continue_time = ContinueTime} = data_level_act:get_act_cfg(Type, SubType),
        EndTime = calc_end_time(ContinueTime, STime),
        DefGradeStatus = calc_default_state(Type, SubType),
        RoleData = #lv_act_data{key = {Type, SubType}, open_time = STime, end_time = EndTime, status = DefGradeStatus, stime = EndTime},
        case maps:get({RoleId, Type, SubType}, RoleActMap, []) of
            #lv_act_data{} -> AccM;
            _ -> AccM#{{RoleId, Type, SubType} => RoleData}
        end
    end,
    RestoreDataMap = lists:foldl(F2, #{}, RoleJoinDbData),

    % 玩家奖励购买记录处理,恢复活动过期数据
    Sql3 = <<"select rold_id, type, subtype, grade, stime from log_level_act where type in (~s)">>,
    RoleLogDbData = db:get_all(io_lib:format(Sql3, [LevelActTypeStr])),
    F3 = fun([RoleId, Type, SubType, Grade, _Time], AccM) ->
        case maps:get({RoleId, Type, SubType}, AccM, []) of
            #lv_act_data{status = GradeStatus0} = RoleData ->
                GradeItem = {Grade, ?HAS_BUY},
                GradeStatus = lists:keyreplace(Grade, 1, GradeStatus0, GradeItem),
                RoleData1 = RoleData#lv_act_data{status = GradeStatus},
                AccM#{{RoleId, Type, SubType} => RoleData1};
            _ -> % 数据没被清理，不需恢复
                AccM
        end
    end,
    UpdateRoleM = lists:foldl(F3, RestoreDataMap, RoleLogDbData), % #{{RoleId, Type, SubType} => #lv_act_data{}}

    % [[RoleId, Type, SubType, OpenTime, EndTime, Status, Utime]]
    F4 = fun({RoleId, Type, SubType}, #lv_act_data{open_time = OpenTime, end_time = EndTime, status = GradeStatus, stime = STime}, AccL) ->
        GradeStatusBin = util:term_to_bitstring(GradeStatus),
        [[RoleId, Type, SubType, OpenTime, EndTime, GradeStatusBin, STime] | AccL]
    end,
    UpdateL = maps:fold(F4, [], UpdateRoleM),

    % 恢复玩家过期活动数据
    UpdateSql = usql:replace(role_lv_act_data, [role_id, type, sub_type, open_time, end_time, status, utime], UpdateL),
    UpdateL =/= [] andalso db:execute(UpdateSql),

    % 返回受恢复的玩家个数10个被恢复的玩家数据
    RoleIdL = [RoleId || [RoleId | _] <- UpdateL],
    RoleIdL1 = ulists:removal_duplicate(RoleIdL),
    {length(UpdateL), length(RoleIdL1), lists:sublist(RoleIdL1, 10)}.



gm_fix_open_times() ->
    Sql = <<"select role_id, type, subtype from log_level_act_open">>,
    FxiDataList = db:get_all(Sql),
    F = fun([RoleId, Type, SubType], Acc) ->
        {_, OldTimes} = ulists:keyfind({RoleId, Type, SubType}, 1, Acc, {{RoleId, Type, SubType}, 0}),
        lists:keystore({RoleId, Type, SubType}, 1, Acc, {{RoleId, Type, SubType}, OldTimes + 1})
        end,
    CountList = lists:foldl(F, [], FxiDataList),

    Sql1 = <<"SELECT `role_id`, `type`,`sub_type`,`open_time`,`end_time`,`status`,`utime` FROM `role_lv_act_data`">>,
    RoleDataList = db:get_all(Sql1),


    F2 = fun([RoleId, Type, SubType, OpenTime, EndTime, Status, Utime], Acc) ->
        {_, OpenTimes} = ulists:keyfind({RoleId, Type, SubType}, 1, CountList, {{RoleId, Type, SubType}, 0}),
        [[RoleId, Type, SubType, OpenTime, EndTime, Status, Utime, OpenTimes] | Acc]
         end,
    DbList = lists:foldl(F2, [], RoleDataList),


    Sql2 = usql:replace(role_lv_act_data, [role_id,type,sub_type,open_time,end_time,status,utime,open_times], DbList),
    DbList =/= [] andalso db:execute(Sql2).

