-module(mod_activation_draw).

-behaviour(gen_server).

-include("common.hrl").
-include("activation_draw.hrl").
-include("custom_act.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        draw_reward/3
        ,draw_reward/5
        ,act_end/2
        ,day_clear/2
        ,save_log/6
        ,get_log/4
        ,update_record/3
        ,get_record/3
        ,get_role_activation_state/4
        ,update_role_activation_state/4
        ,update_role_activation_state/5
        ,timer_clear/2
    ]).

        % day_log = #{},          %% {type,subtype} => [{GradeId, [{{Range1, Range2}, Num}]}...] 
        % role_log = #{},         %% {type,subtype} => [{RoleId, [{GradeId, Num}...]}...] 
        % log = #{}               %% {type,subtype} => [{RoleId, [#log{}...]}...] 玩家抽奖记录
        % ,grade_draw_map = #{}   %% {type,subtype} => [{Grade, Num}...]
        % ,kf_record = #{}        %% {type,subtype} => SendList
        % ,role_activation = #{}  %% {type,subtype} => [{roleid, state}]

% -record(activation_draw_state, {
%         day_log = #{},          %% {type,subtype} => [{GradeId, [{{Range1, Range2}, Num}]}...] 
%         role_log = #{},         %% {type,subtype} => [{RoleId, [{GradeId, Num}...]}...] 只记录稀有度1以上的记录
%         log = #{}               %% {type,subtype} => [{RoleId, [#log{}...]}...] 玩家抽奖记录
%         role_activation = #{}   %% {type,subtype} => [{roleid, state}]
%     }).
day_clear(Type, SubType) ->
    gen_server:cast(?MODULE, {'day_clear', Type, SubType}).

act_end(Type, SubType) ->
    gen_server:cast(?MODULE, {'act_end', Type, SubType}).

draw_reward(Type, SubType, RoleId) ->
    gen_server:call(?MODULE, {'draw_reward', Type, SubType, RoleId}).

draw_reward(Type, SubType, RoleId, Times, RechargeNum) ->
    gen_server:call(?MODULE, {'draw_reward', Type, SubType, RoleId, Times, RechargeNum}).

save_log(Type, SubType, GradeId, RoleId, Name, Reward) ->
    gen_server:cast(?MODULE, {'save_log', Type, SubType, GradeId, RoleId, Name, Reward}).
    
get_log(Type, SubType, RoleId, Activation) ->
    gen_server:cast(?MODULE, {'get_log', Type, SubType, RoleId, Activation}).

update_record(Type, SubType, RecordList) ->
    gen_server:cast(?MODULE, {'update_record', Type, SubType, RecordList}).

get_record(Type, SubType, RoleId) ->
    gen_server:cast(?MODULE, {'get_record', Type, SubType, RoleId}).

get_role_activation_state(Type, SubType, RoleId, Id) ->
    gen_server:call(?MODULE, {'activation_state', Type, SubType, RoleId, Id}).

update_role_activation_state(Type, SubType, RoleId, ActivStateList) ->
    gen_server:cast(?MODULE, {'update_activation_state', Type, SubType, RoleId, ActivStateList}).

update_role_activation_state(Type, SubType, RoleId, RoleData, ActConditions) ->
    gen_server:cast(?MODULE, {'update_activation_state', Type, SubType, RoleId, RoleData, ActConditions}).

timer_clear(Type, SubType) ->
    gen_server:cast(?MODULE, {'timer_clear', Type, SubType}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    DayRecord = db:get_all(?SQL_SELECT_GRADE_RECORD),
    RareRecord = db:get_all(?SQL_SELECT_RARE_GRADE_RECORD),
    RoleRecord = db:get_all(?SQL_SELECT_ROLE_RECORD),
    ActivationRecord = db:get_all(?SQL_SELECT_RECIEVE_RECORD),
    Fun = fun([Type, SubType, GradeId, RoleIdLStr], TemMap) ->
        List = maps:get({Type, SubType}, TemMap, []),
        NewList = lists:keystore(GradeId, 1, List, {GradeId, util:bitstring_to_term(RoleIdLStr)}),
        maps:put({Type, SubType}, NewList, TemMap)
    end,
    DayLogMap = lists:foldl(Fun, #{}, DayRecord),
    RareLogMap = lists:foldl(Fun, #{}, RareRecord),
    RoleLogMap = lists:foldl(Fun, #{}, RoleRecord),
    Fun1 = fun([Type, SubType, RoleId, GradeLStr, Stime], TemMap) ->
        if
            Type == ?CUSTOM_ACT_TYPE_ACTIVATION ->
                IsSameDay = utime_logic:is_logic_same_day(Stime);
            true ->
                IsSameDay = utime:is_today(Stime)
        end,
        List = maps:get({Type, SubType}, TemMap, []),
        if
            IsSameDay == true ->
                NewList = lists:keystore(RoleId, 1, List, {RoleId, util:bitstring_to_term(GradeLStr)});
            true ->
                NewList = lists:keystore(RoleId, 1, List, {RoleId, calc_default_status(Type, SubType)})
        end,
        maps:put({Type, SubType}, NewList, TemMap)
    end,
    ActivationMap = lists:foldl(Fun1, #{}, ActivationRecord),
    GradeIdDrawMap = calc_grade_total_draw_map(RareLogMap),
    ActTypeList = [?CUSTOM_ACT_TYPE_ACTIVATION, ?CUSTOM_ACT_TYPE_RECHARGE],
    F = fun(ActType) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(ActType),
        Fun2 = fun(ActSubType) ->
            mod_activation_draw_kf:cast_center([{send_record_info, config:get_server_id(), ActType, ActSubType}])
        end,
        lists:foreach(Fun2, SubTypes)
    end,
    lists:foreach(F, ActTypeList),
    % ?PRINT("ActivationMap:~p~n",[ActivationMap]),
    {ok, #activation_draw_state{day_log = DayLogMap, role_log = RareLogMap, 
        log = RoleLogMap, grade_draw_map = GradeIdDrawMap, role_activation = ActivationMap}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'day_clear', Type, SubType}, State) ->
    #activation_draw_state{day_log = DayLogMap} = State,
    db:execute(io_lib:format(?SQL_DELETE_GRADE_RECORD, [Type, SubType])),
    NewDayLogMap = maps:remove({Type, SubType}, DayLogMap),
    NewState = State#activation_draw_state{day_log = NewDayLogMap},
    {noreply, NewState};

do_handle_cast({'four_clear', Type, SubType}, State) ->
    #activation_draw_state{role_activation = RoleActivState} = State,
    NewMap = maps:remove({Type, SubType}, RoleActivState),
    db:execute(io_lib:format(?SQL_DELETE_RECIEVE_RECORD, [Type, SubType])),
    {noreply, State#activation_draw_state{role_activation = NewMap}};

do_handle_cast({'act_end', Type, SubType}, State) ->
    % ?MYLOG("XLH","act_end ================= ~n",[]),
    #activation_draw_state{day_log = DayLogMap, role_log = RareLogMap, grade_draw_map = GradeIdDrawMap, 
            log = RoleLogMap, role_activation = RoleActivState, kf_record = KfMap} = State,
    db:execute(io_lib:format(?SQL_DELETE_GRADE_RECORD, [Type, SubType])),
    NewDayLogMap = maps:remove({Type, SubType}, DayLogMap),

    db:execute(io_lib:format(?SQL_DELETE_RARE_GRADE_RECORD, [Type, SubType])),
    NewRareLogMap = maps:remove({Type, SubType}, RareLogMap),

    NewGradeIdDrawMap = maps:remove({Type, SubType}, GradeIdDrawMap),

    db:execute(io_lib:format(?SQL_DELETE_ROLE_RECORD, [Type, SubType])),
    NewRoleLogMap = maps:remove({Type, SubType}, RoleLogMap),

    NewMap = maps:remove({Type, SubType}, RoleActivState),
    db:execute(io_lib:format(?SQL_DELETE_RECIEVE_RECORD, [Type, SubType])),

    NewState = State#activation_draw_state{day_log = NewDayLogMap, role_log = NewRareLogMap, grade_draw_map = NewGradeIdDrawMap,
            log = NewRoleLogMap, role_activation = NewMap, kf_record = maps:remove({Type, SubType}, KfMap)},
    {noreply, NewState};

do_handle_cast({'save_log', Type, SubType, GradeId, RoleId, Name, Reward}, State) ->
    #activation_draw_state{log = RoleLogMap} = State,
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    %% RoleLogMap {type,subtype} => [{RoleId, [#log{}...]}...] 玩家抽奖记录
    RoleLogList = maps:get({Type, SubType}, RoleLogMap, []),
    LogList = get_condition(RoleId, RoleLogList, []),
    Length = get_condition(log_length, Conditions, 20),
    Log = #log{name = Name, reward = Reward, stime = utime:unixtime()},
    NewLogList = lists:sublist([Log|LogList], Length),
    NewRoleLogList = lists:keystore(RoleId, 1, RoleLogList, {RoleId, NewLogList}),
    NewRoleLogMap = maps:put({Type, SubType}, NewRoleLogList, RoleLogMap),
    % ?PRINT("NewRoleLogMap:~p,NewLogList:~p, Length:~p~n",[NewRoleLogMap, NewLogList,Length]),
    db:execute(io_lib:format(?SQL_REPLACE_ROLE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewLogList)])),
    NewState = State#activation_draw_state{log = NewRoleLogMap},
    {noreply, NewState};

do_handle_cast({'get_log', Type, SubType, RoleId, Activation}, State) ->
    #activation_draw_state{log = RoleLogMap, role_activation = RoleActivState} = State,
    RoleActivList = maps:get({Type, SubType}, RoleActivState, []),
    ActivState = get_condition(RoleId, RoleActivList, []),
    % ?PRINT("RoleActivList:~p~n",[RoleActivList]),
    if
        ActivState == [] ->
            NewActivState = calc_default_status(Type, SubType);
        true ->
            NewActivState = ActivState
    end,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NewActivStateList = 
        if
            Type == ?CUSTOM_ACT_TYPE_RECHARGE ->
                calc_recharge_status(recharge, ActConditions, Activation, NewActivState);
            true ->
                calc_activation_status(activation, ActConditions, Activation, NewActivState)
        end,
    LogList = maps:get({Type, SubType}, RoleLogMap, []),
    RoleLogList = get_condition(RoleId, LogList, []),
    SendList = [{Name, Reward}||#log{name = Name, reward = Reward} <- RoleLogList],
    {ok, BinData} = pt_332:write(33218, [Type, SubType, round(Activation), NewActivStateList, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'timer_clear', Type, SubType}, State) ->
    #activation_draw_state{role_activation = RoleActivState} = State,
    RoleActivList = maps:get({Type, SubType}, RoleActivState, []),
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    F = fun({RoleId, ActivState}) ->
        % ?PRINT("RoleActivList:~p~n",[RoleActivList]),
        Fun = fun({Id, Status}, Acc) -> 
            if
                Status == ?NOT_RECIEVE_ACHIEVED ->
                    TemReward = lib_activation_draw:get_stage_reward(Type, Id, ActConditions),
                    TemReward++Acc;
                true ->
                    Acc
            end
        end,
        Reward = lists:foldl(Fun, [], ActivState),
        if
            Reward =/= [] ->
                Title = utext:get(3310073),Content = utext:get(3310074),
                lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
            true ->
                skip
        end
    end,
    lists:foreach(F, RoleActivList),
    NewMap = maps:remove({Type, SubType}, RoleActivState),
    NewState = State#activation_draw_state{role_activation = NewMap},
    {noreply, NewState};

do_handle_cast({'update_record', Type, SubType, RecordList}, State) ->
    #activation_draw_state{kf_record = KfMap} = State,
    NewMap = maps:put({Type,SubType}, RecordList, KfMap),
    % ?PRINT("RecordList:~p~n",[RecordList]),
    {ok, BinData} = pt_331:write(33197, [Type, SubType, RecordList, []]),
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    MinLv = get_condition(role_lv, ActConditions, 1),
    lib_server_send:send_to_all(all_lv, {MinLv, 9999}, BinData),
    {noreply, State#activation_draw_state{kf_record = NewMap}};

do_handle_cast({'get_record', Type, SubType, RoleId}, State) ->
    #activation_draw_state{kf_record = KfMap} = State,
    RecordList = maps:get({Type,SubType}, KfMap, []),
    % ?PRINT("RecordList:~p~n",[RecordList]),
    {ok, BinData} = pt_331:write(33197, [Type, SubType, RecordList, []]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'update_activation_state', Type, SubType, RoleId, ActivStateList}, State) ->
    #activation_draw_state{role_activation = RoleActivState} = State,
    RoleActivList = maps:get({Type, SubType}, RoleActivState, []),
    OldActivStateList = get_condition(RoleId, RoleActivList, []),
    Fun = fun({Id, Status}, Acc) ->
        case lists:keyfind(Id, 1, Acc) of
            {Id, OldStatus} when OldStatus < Status ->
                lists:keystore(Id, 1, Acc, {Id, Status});
            {_, _} -> 
                Acc;
            _ ->
                lists:keystore(Id, 1, Acc, {Id, Status})
        end
    end,
    NewActivStateList = lists:foldl(Fun, OldActivStateList, ActivStateList),
    if
        NewActivStateList =/= OldActivStateList ->
            % ?PRINT("======= NewActivStateList:~p~n",[NewActivStateList]),
            db:execute(io_lib:format(?SQL_REPLACE_RECIEVE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewActivStateList), utime:unixtime()])),
            NewList = lists:keystore(RoleId, 1, RoleActivList, {RoleId, NewActivStateList}),
            NewMap = maps:put({Type, SubType}, NewList, RoleActivState),
            NewState = State#activation_draw_state{role_activation = NewMap};
        true ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_cast({'update_activation_state', Type, SubType, RoleId, RoleData, ActConditions}, State) ->
    #activation_draw_state{log = RoleLogMap, role_activation = RoleActivState} = State,
    RoleActivList = maps:get({Type, SubType}, RoleActivState, []),
    OldActivStateList = get_condition(RoleId, RoleActivList, []),
    NewActivStateList = 
        if
            Type == ?CUSTOM_ACT_TYPE_RECHARGE ->
                calc_recharge_status(recharge, ActConditions, RoleData, OldActivStateList);
            true ->
                calc_activation_status(activation, ActConditions, RoleData, OldActivStateList)
        end,
    % ?PRINT("===NewActivStateList:~p, OldActivStateList:~p~n",[NewActivStateList, OldActivStateList]),

    db:execute(io_lib:format(?SQL_REPLACE_RECIEVE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewActivStateList), utime:unixtime()])),
    NewList = lists:keystore(RoleId, 1, RoleActivList, {RoleId, NewActivStateList}),
    NewMap = maps:put({Type, SubType}, NewList, RoleActivState),
    NewState = State#activation_draw_state{role_activation = NewMap},

    LogList = maps:get({Type, SubType}, RoleLogMap, []),
    RoleLogList = get_condition(RoleId, LogList, []),
    SendList = [{Name, Reward}||#log{name = Name, reward = Reward} <- RoleLogList],
    % ?PRINT("RoleData:~p~n,NewActivStateList:~p~n",[RoleData, NewActivStateList]),
    {ok, BinData} = pt_332:write(33218, [Type, SubType, round(RoleData), NewActivStateList, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call({'draw_reward', Type, SubType, RoleId}, State) ->
    #activation_draw_state{day_log = DayLogMap, grade_draw_map = GradeIdDrawMap, role_log = RareLogMap} = State,
    DayLogList = maps:get({Type, SubType}, DayLogMap, []),
    GradeIdDrawList = maps:get({Type, SubType}, GradeIdDrawMap, []),
    Rmb = lib_recharge_data:get_total_rmb(RoleId),
    RoleGradeIdDrawList = maps:get({Type, SubType}, RareLogMap, []),
    % ?PRINT("=========Rmb:~p~n",[Rmb]),
    GradeIdDrawNumList = get_condition(RoleId, RoleGradeIdDrawList, []),
    Pool = calc_pool(Type, SubType, Rmb, DayLogList, GradeIdDrawList, GradeIdDrawNumList),
    % ?PRINT("=========Pool:~p~n",[Pool]),
    GradeId = urand:rand_with_weight(Pool),
    % ?PRINT("GradeId:~p~n",[GradeId]),
    NewState = calc_new_state(Type, SubType, RoleId, Rmb, GradeId, State),
    % ?MYLOG("XLH","RareLogMap:~p,NewRareLogMap:~p~n",[RareLogMap,NewState#activation_draw_state.role_log]),
    Reply = {ok, GradeId},
    {reply, Reply, NewState};

do_handle_call({'draw_reward', Type, SubType, RoleId, Times, RechargeNum}, State) ->
    #activation_draw_state{day_log = DayLogMap, grade_draw_map = GradeIdDrawMap, role_log = RareLogMap} = State,
    DayLogList = maps:get({Type, SubType}, DayLogMap, []),
    GradeIdDrawList = maps:get({Type, SubType}, GradeIdDrawMap, []),
    % Rmb = lib_recharge_data:get_total_rmb(RoleId),
    Rmb = RechargeNum,
    RoleGradeIdDrawList = maps:get({Type, SubType}, RareLogMap, []),
    {NewDayLogList, NewGradeIdDrawList, NewRoleGradeIdDrawList, GradeIdList} 
        = draw_reward_helper(Type, SubType, Rmb, RoleId, DayLogList, GradeIdDrawList, RoleGradeIdDrawList, Times, []),
    NewDayLogMap = maps:put({Type, SubType}, NewDayLogList, DayLogMap),
    NewRareLogMap = maps:put({Type, SubType}, NewRoleGradeIdDrawList, RareLogMap),
    NewGradeIdDrawMap = maps:put({Type, SubType}, NewGradeIdDrawList, GradeIdDrawMap),
    NewState = State#activation_draw_state{day_log = NewDayLogMap, role_log = NewRareLogMap, grade_draw_map = NewGradeIdDrawMap},
    Reply = {ok, GradeIdList},
    {reply, Reply, NewState};

do_handle_call({'activation_state', Type, SubType, RoleId, Id}, State) ->
    #activation_draw_state{role_activation = RoleActivState} = State,
    RoleActivList = maps:get({Type, SubType}, RoleActivState, []),
    ActivStateList = get_condition(RoleId, RoleActivList, []),
    % ?PRINT("========== ActivStateList:~p~n",[ActivStateList]),
    ActivState = get_condition(Id, ActivStateList, 0),
    if
        ActivState =< 1 ->
            NewActivStateList = lists:keystore(Id, 1, ActivStateList, {Id, ?HAS_RECIEVE_REWARD}),
            db:execute(io_lib:format(?SQL_REPLACE_RECIEVE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewActivStateList), utime:unixtime()])),
            NewList = lists:keystore(RoleId, 1, RoleActivList, {RoleId, NewActivStateList}),
            NewMap = maps:put({Type, SubType}, NewList, RoleActivState),
            NewState = State#activation_draw_state{role_activation = NewMap};
        true ->
            NewActivStateList = ActivStateList,
            NewState = State
    end,
    Reply = {ok, ActivState, NewActivStateList},
    {reply, Reply, NewState};

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.


calc_pool(Type, SubType, Rmb, DayLogList, GradeIdDrawList, GradeIdDrawNumList) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    % #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    Fun = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} -> 
                Rare = get_condition(rare, Conditions, 0),
                GradeIdDrawNum = get_condition(GradeId, GradeIdDrawNumList, 0),
                if
                    (Rare >= 2 andalso GradeIdDrawNum < 1) orelse Rare < 2  ->
                        ActDrawTotalNum = get_condition(GradeId, GradeIdDrawList, 0),
                        MaxDrawNum = get_condition(max_num, Conditions, null),
                        SpecialList = get_condition(num, Conditions, []),
                        DayRangeList = get_condition(GradeId, DayLogList, []),
                        if
                            (MaxDrawNum =/= null andalso ActDrawTotalNum < MaxDrawNum) andalso SpecialList =/= [] ->
                                calc_pool_helper(Rmb, SpecialList, DayRangeList, Conditions, GradeId, Acc);
                            MaxDrawNum == null andalso SpecialList =/= [] ->
                                calc_pool_helper(Rmb, SpecialList, DayRangeList, Conditions, GradeId, Acc);
                            SpecialList == [] ->
                                Weight = get_condition(weight, Conditions, 0),
                                [{Weight, GradeId}|Acc];
                            true ->
                                Acc
                        end;
                    true ->
                        Acc
                end;                                
            _ ->
                ?ERR("custom_act, condition:weight miss! Type:~p SubType:~p, GradeId:~p~n",[Type,SubType,GradeId]), 
                Acc
        end
    end,
    Pool = lists:foldl(Fun, [], GradeIdList),
    Pool.

calc_pool_helper(Rmb, SpecialList, DayRangeList, Conditions, GradeId, Acc) ->
    Fun = fun({_, TemNum}, Sum) ->
        TemNum + Sum;
        (_, Sum) -> Sum
    end,
    TodayDrawNum = lists:foldl(Fun, 0, DayRangeList),
    DayMaxNum = get_condition(day_max, Conditions, null),
    if
        DayMaxNum =/= null andalso TodayDrawNum >= DayMaxNum ->
            Acc;
        true ->
            F1 = fun({{Min, Max}, _Num}) ->
                Rmb >= Min andalso Rmb =< Max
            end,
            case ulists:find(F1, SpecialList) of
                {ok, {Key, SpeMaxNum}} -> 
                    RangeDraw = get_condition(Key, DayRangeList, 0),
                    if
                        RangeDraw < SpeMaxNum ->
                            Weight = get_condition(weight, Conditions, 0),
                            [{Weight, GradeId}|Acc];
                        true ->
                            Acc
                    end;
                _ -> 
                    Acc
            end
    end.

calc_new_state(Type, SubType, RoleId, Rmb, GradeId, State) ->
    #activation_draw_state{day_log = DayLogMap, role_log = RareLogMap, grade_draw_map = GradeIdDrawMap} = State,
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    DayLogList = maps:get({Type, SubType}, DayLogMap, []),

    %% DayLogMap {type,subtype} => [{GradeId, [{{Range1, Range2}, Num}]}...] 
    SpecialList = get_condition(num, Conditions, []),
    F1 = fun({{Min, Max}, _}) ->
        Rmb >= Min andalso Rmb =< Max
    end,
    case ulists:find(F1, SpecialList) of
        {ok, {Key, _}} -> 
            DayRangeList = get_condition(GradeId, DayLogList, []),
            RangeDraw = get_condition(Key, DayRangeList, 0),
            NewDayRangeList = lists:keystore(Key, 1, DayRangeList, {Key, RangeDraw+1}),
            NewDayLogList = lists:keystore(GradeId, 1, DayLogList, {GradeId, NewDayRangeList}),
            db:execute(io_lib:format(?SQL_REPLACE_GRADE_RECORD, [Type, SubType, GradeId, util:term_to_string(NewDayRangeList)])),
            NewDayLogMap = maps:put({Type, SubType}, NewDayLogList, DayLogMap);
        _ -> 
            NewDayLogMap = DayLogMap
    end,
    %% RareLogMap {type,subtype} => [{RoleId, [{GradeId, Num}...]}...]
    RoleGradeIdDrawList = maps:get({Type, SubType}, RareLogMap, []),
    GradeIdDrawNumList = get_condition(RoleId, RoleGradeIdDrawList, []),
    GradeIdDrawNum = get_condition(GradeId, GradeIdDrawNumList, 0),
    NewGradeIdDrawNumList = lists:keystore(GradeId, 1, GradeIdDrawNumList, {GradeId, GradeIdDrawNum+1}),
    NewRoleGradeIdDrawList = lists:keystore(RoleId, 1, RoleGradeIdDrawList, {RoleId, NewGradeIdDrawNumList}),
    db:execute(io_lib:format(?SQL_REPLACE_RARE_GRADE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewGradeIdDrawNumList)])),
    NewRareLogMap = maps:put({Type, SubType}, NewRoleGradeIdDrawList, RareLogMap),
    %% GradeIdDrawMap {type,subtype} => [{GradeId, Num}...]
    GradeIdDrawList = maps:get({Type, SubType}, GradeIdDrawMap, []),
    ActDrawTotalNum = get_condition(GradeId, GradeIdDrawList, 0),
    NewGradeIdDrawList = lists:keystore(GradeId, 1, GradeIdDrawList, {GradeId, ActDrawTotalNum+1}),
    NewGradeIdDrawMap = maps:put({Type, SubType}, NewGradeIdDrawList, GradeIdDrawMap),
    State#activation_draw_state{day_log = NewDayLogMap, role_log = NewRareLogMap, grade_draw_map = NewGradeIdDrawMap}.

calc_grade_total_draw_map(RareLogMap) ->
    Fun = fun(_, Value) ->
        calc_grade_total_draw_times(Value)
    end,
    maps:map(Fun, RareLogMap).

calc_grade_total_draw_times(RareLogList) ->
    Fun = fun({_, GradeIdList}, Acc) ->
        ulists:kv_list_plus_extra([GradeIdList, Acc])
    end,
    lists:foldl(Fun, [], RareLogList).

get_condition(Key, List, Default) ->
    case lists:keyfind(Key, 1, List) of
        {_, Value} -> Value;
        _ -> Default
    end.

calc_default_status(Type, SubType) when Type == ?CUSTOM_ACT_TYPE_RECHARGE ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    List = get_condition(recharge, ActConditions, []),
    Fun = fun({Id, _}, Acc) ->
        [{Id, ?NOT_ACHIEVE_CONDITION}|Acc]
    end,
    lists:foldl(Fun, [], List);
calc_default_status(_, _) -> [{1, ?NOT_ACHIEVE_CONDITION}].

calc_recharge_status(Key, ActConditions, RoleData, RoleActivList) ->
    List = get_condition(Key, ActConditions, []),
    Fun = fun({Id, NeedData}, Acc) ->
        case lists:keyfind(Id, 1, Acc) of
            {Id, Status} ->
                NewStatus = calc_new_status(Status, RoleData, NeedData),
                lists:keystore(Id, 1, Acc, {Id, NewStatus});
            _ ->
                NewStatus = calc_new_status(?NOT_ACHIEVE_CONDITION, RoleData, NeedData),
                lists:keystore(Id, 1, Acc, {Id, NewStatus})
        end
    end,
    lists:foldl(Fun, RoleActivList, List).

calc_activation_status(Key, ActConditions, RoleData, RoleActivList) ->
    NeedData = get_condition(Key, ActConditions, 0),
    case lists:keyfind(1, 1, RoleActivList) of
        {1, Status} ->
            NewStatus = calc_new_status(Status, RoleData, NeedData),
            lists:keystore(1, 1, RoleActivList, {1, NewStatus});
        _ ->
            NewStatus = calc_new_status(?NOT_ACHIEVE_CONDITION, RoleData, NeedData),
            lists:keystore(1, 1, RoleActivList, {1, NewStatus})
    end.

calc_new_status(Status, RoleData, NeedData) ->
    if
        Status >= ?NOT_RECIEVE_ACHIEVED ->
            Status;
        true ->
            if
                RoleData >= NeedData ->
                    ?NOT_RECIEVE_ACHIEVED;
                true ->
                    ?NOT_ACHIEVE_CONDITION
            end
    end.

draw_reward_helper(_, _, _, _, DayLogList, GradeIdDrawList, RoleGradeIdDrawList, 0, GradeIdList) ->
    {DayLogList, GradeIdDrawList, RoleGradeIdDrawList, GradeIdList};
draw_reward_helper(Type, SubType, Rmb, RoleId, DayLogList, GradeIdDrawList, RoleGradeIdDrawList, Times, GradeIdList) ->
    GradeIdDrawNumList = get_condition(RoleId, RoleGradeIdDrawList, []),
    Pool = calc_pool(Type, SubType, Rmb, DayLogList, GradeIdDrawList, GradeIdDrawNumList),
    GradeId = urand:rand_with_weight(Pool),
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    SpecialList = get_condition(num, Conditions, []),
    F1 = fun({{Min, Max}, _}) ->
        Rmb >= Min andalso Rmb =< Max
    end,
    case ulists:find(F1, SpecialList) of
        {ok, {Key, _}} -> 
            DayRangeList = get_condition(GradeId, DayLogList, []),
            RangeDraw = get_condition(Key, DayRangeList, 0),
            NewDayRangeList = lists:keystore(Key, 1, DayRangeList, {Key, RangeDraw+1}),
            NewDayLogList = lists:keystore(GradeId, 1, DayLogList, {GradeId, NewDayRangeList}),
            db:execute(io_lib:format(?SQL_REPLACE_GRADE_RECORD, [Type, SubType, GradeId, util:term_to_string(NewDayRangeList)]));
        _ -> 
            NewDayLogList = DayLogList
    end,

    ActDrawTotalNum = get_condition(GradeId, GradeIdDrawList, 0),
    NewGradeIdDrawList = lists:keystore(GradeId, 1, GradeIdDrawList, {GradeId, ActDrawTotalNum+1}),

    GradeIdDrawNum = get_condition(GradeId, GradeIdDrawNumList, 0),
    NewGradeIdDrawNumList = lists:keystore(GradeId, 1, GradeIdDrawNumList, {GradeId, GradeIdDrawNum+1}),
    NewRoleGradeIdDrawList = lists:keystore(RoleId, 1, RoleGradeIdDrawList, {RoleId, NewGradeIdDrawNumList}),
    db:execute(io_lib:format(?SQL_REPLACE_RARE_GRADE_RECORD, [Type, SubType, RoleId, util:term_to_string(NewGradeIdDrawNumList)])),
    draw_reward_helper(Type, SubType, Rmb, RoleId, NewDayLogList, NewGradeIdDrawList,
             NewRoleGradeIdDrawList, Times-1, [GradeId|GradeIdList]).