%% ---------------------------------------------------------------------------
%% @doc lib_custom_act_liveness_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-03-04
%% @deprecated 节日活跃奖励进程
%% ---------------------------------------------------------------------------
-module(lib_custom_act_liveness_mod).

-compile(export_all).

-include("custom_act.hrl").
-include("custom_act_liveness.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("boss.hrl").
-include("def_module.hrl").

make_record(sql_sub_custom_act_liveness, [Type, SubType, LivenessNum, MergeTime, Times, UTime, TriggerListBin]) ->
    TriggerList = util:bitstring_to_term(TriggerListBin),
    #sub_custom_act_liveness{
        type = Type, subtype = SubType, liveness_num = LivenessNum, merge_time = MergeTime, times = Times, utime = UTime,
        trigger_list = TriggerList
        }.

%% 初始化
init() ->
    % 计算合服的数据
    DbList = db_custom_act_liveness_select(),
    F = fun(T) ->
        #sub_custom_act_liveness{type = Type, subtype = SubType} = SubLiveness = make_record(sql_sub_custom_act_liveness, T),
        {{Type, SubType}, SubLiveness}
    end,
    LivenessMap = maps:from_list(lists:map(F, DbList)),
    NewLivenessMap = recalc_liveness_map(LivenessMap),
    State = #custom_act_liveness_state{liveness_map = NewLivenessMap},
    recalc_server_reward(State).

recalc_liveness_map(LivenessMap) ->
    ActIds = [?CUSTOM_ACT_TYPE_LIVENESS],
    InfoList = lib_custom_act_api:get_custom_act_open_info_by_actids(ActIds),
    NewLivenessMap = recalc_liveness_map_help(InfoList, LivenessMap),
    F = fun({Type, SubType}, _SubLiveness, Map) ->
        case lists:keymember({Type, SubType}, #act_info.key, InfoList) of
            true -> Map;
            false ->
                % 清理
                db_custom_act_liveness_delete(Type, SubType),
                maps:remove({Type, SubType}, Map)
        end
    end,
    % ?PRINT("InfoList:~p NewLivenessMap:~p ~n", [InfoList, NewLivenessMap]),
    maps:fold(F, NewLivenessMap, NewLivenessMap).

%% 是否需要初始化
recalc_liveness_map_help([], LivenessMap) -> LivenessMap;
recalc_liveness_map_help([#act_info{key = {Type, SubType}}|T], LivenessMap) ->
    case maps:is_key({Type, SubType}, LivenessMap) of
        true -> recalc_liveness_map_help(T, LivenessMap);
        false ->
            SubLiveness = act_start_help(Type, SubType),
            NewLivenessMap = maps:put({Type, SubType}, SubLiveness, LivenessMap),
            recalc_liveness_map_help(T, NewLivenessMap)
    end.

%% 重新计算服奖励
recalc_server_reward(#custom_act_liveness_state{liveness_map = LivenessMap} = State) ->
    F = fun({Type, SubType}, _SubLiveness, {TmpState, SumRoleLivenessList}) ->
        % #sub_custom_act_liveness{merge_time = MergeTime} = get_sub_liveness(State, Type, SubType),
        % 全部检查再次触发
        {ok, NewTmpState, _NewTriggerList, RoleLivenessList, _TotalSerTimes} = trigger_help(TmpState, Type, SubType),
        {NewTmpState, RoleLivenessList++SumRoleLivenessList}
    end,
    {NewState, RoleLivenessList} = maps:fold(F, {State, []}, LivenessMap),
    case RoleLivenessList == [] of
        true -> skip;
        false -> util:cast_event_to_players({'apply_cast', ?APPLY_CAST_STATUS, lib_custom_act_liveness, trigger, [RoleLivenessList]})
    end,
    NewState.

%% 触发##同步到玩家
trigger(State, Type, SubType) ->
    {ok, NewState, NewTriggerList, RoleLivenessList, TotalSerTimes} = trigger_help(State, Type, SubType),
    case RoleLivenessList == [] of
        true -> skip;
        false -> util:cast_event_to_players({'apply_cast', ?APPLY_CAST_STATUS, lib_custom_act_liveness, trigger, [RoleLivenessList]})
    end,
    case NewTriggerList =/= [] orelse RoleLivenessList =/= [] of
        true -> IsAsk = 1;
        false -> IsAsk = 0
    end,
    ClientTriggerL = [TriggerType||{_GradeId, TriggerType, _Param}<-NewTriggerList],
    % ?MYLOG("hjhliveness", "NewTriggerList:~p ~n", [NewTriggerList]),
    {ok, BinData} = pt_331:write(33196, [Type, SubType, TotalSerTimes, IsAsk, ClientTriggerL]),
    lib_server_send:send_to_all(BinData),
    NewState.

%% 触发效果##不同步玩家
trigger_help(#custom_act_liveness_state{liveness_map = LivenessMap} = State, Type, SubType) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} = ActInfo ->
            #sub_custom_act_liveness{trigger_list = TriggerList, times = Times} = SubLiveness = get_sub_liveness(State, Type, SubType),
            InfoList = get_next_trigger_info_list(SubLiveness, Type, SubType, Times),
            % ?MYLOG("hjhliveness1", "InfoList:~p ~n", [InfoList]),
            {NewTriggerList, RoleLivenessList} = do_trigger_help(InfoList, ActInfo, TriggerList, []),
            NewSubLiveness = SubLiveness#sub_custom_act_liveness{trigger_list = NewTriggerList, utime = utime:unixtime()},
            db_custom_act_liveness_replace(NewSubLiveness),
            NewLivenessMap = maps:put({Type, SubType}, NewSubLiveness, LivenessMap),
            NewState = State#custom_act_liveness_state{liveness_map = NewLivenessMap},
            {ok, NewState, NewTriggerList, RoleLivenessList, Times};
        _ ->
            {ok, State, [], [], 0}
    end.

%% TODO: 需求改动导致触发事件耦合太多, 可以把触发点和触发时效分开
do_trigger_help([], _ActInfo, TriggerList, RoleLivenessList) -> {TriggerList, RoleLivenessList};
do_trigger_help([{GradeId, TriggerType, Param}|InfoList], #act_info{key = {Type, SubType}, etime = Etime} = ActInfo, TriggerList, RoleLivenessList) ->
    if
        TriggerType == ?CA_LIVENESS_EXP_DUN_DOUBLE orelse
        TriggerType == ?CA_LIVENESS_MATERIALS_DUN_DOUBLE orelse
        TriggerType == ?CA_LIVENESS_MATERIALS_DUN_EXTRA ->
            case [TmpTriggerParam||{_, TmpTriggerType, TmpTriggerParam}<-TriggerList, TmpTriggerType == TriggerType, is_integer(TmpTriggerParam)] of
                [] -> MaxTriggerParam = 0;
                TriggerParamL -> MaxTriggerParam = lists:max(TriggerParamL)
            end,
            {_, _, LogicEndTime} = utime_logic:get_logic_day_time_info(),
            TriggerParam = max(utime:unixtime()+Param, MaxTriggerParam+Param),
            TriggerParamAfEtime = min(TriggerParam, Etime),
            NewTriggerParam = min(TriggerParamAfEtime, LogicEndTime),
            NewTriggerList = [{GradeId, TriggerType, NewTriggerParam}|TriggerList],
            RoleLiveness = #role_liveness{type = Type, subtype = SubType, grade_id = GradeId, trigger_type = TriggerType, param = NewTriggerParam},
            NewRoleLivenessList = [RoleLiveness|RoleLivenessList],
            % ?MYLOG("hjhliveness1", "LogicEndTime:~p NewTriggerParam:~p ~n", [LogicEndTime, NewTriggerParam]),
            lib_log_api:log_custom_act_liveness_ser_reward(Type, SubType, GradeId, TriggerType, NewTriggerParam),
            if
                TriggerType == ?CA_LIVENESS_MATERIALS_DUN_DOUBLE ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 42, []);
                TriggerType == ?CA_LIVENESS_EXP_DUN_DOUBLE ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 43, []);
                TriggerType == ?CA_LIVENESS_MATERIALS_DUN_EXTRA ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 71, []);
                true ->
                    skip
            end,
            do_trigger_help(InfoList, ActInfo, NewTriggerList, NewRoleLivenessList);
        TriggerType == ?CA_LIVENESS_BOSS_REFRESH ->
            NewTriggerList = [{GradeId, TriggerType, Param}|TriggerList],
            mod_boss:refresh_killed_forb_boss(),
            mod_boss:refresh_boss(?BOSS_TYPE_SPECIAL),
            mod_boss:refresh_boss(?BOSS_TYPE_PHANTOM_PER),
            mod_boss:refresh_boss(?BOSS_TYPE_WORLD_PER),
            mod_boss:refresh_boss(?BOSS_TYPE_NEW_OUTSIDE),
            mod_boss:refresh_boss(?BOSS_TYPE_ABYSS),
            mod_boss:refresh_boss(?BOSS_TYPE_DOMAIN),
            mod_boss:refresh_boss(?BOSS_TYPE_FORBIDDEN),
            lib_log_api:log_custom_act_liveness_ser_reward(Type, SubType, GradeId, TriggerType, Param),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 45, []),
            do_trigger_help(InfoList, ActInfo, NewTriggerList, RoleLivenessList);
        TriggerType == ?CA_LIVENESS_SER_REWARD ->
            NewTriggerList = [{GradeId, TriggerType, Param}|TriggerList],
            lib_log_api:log_custom_act_liveness_ser_reward(Type, SubType, GradeId, TriggerType, Param),
            do_trigger_help(InfoList, ActInfo, NewTriggerList, RoleLivenessList);
        TriggerType == ?CA_LIVENESS_TREASURE_HUNT_LUCKEY ->
            % NewTriggerList = [{GradeId, TriggerType, Param}|TriggerList],
            case [TmpTriggerParam||{_, TmpTriggerType, TmpTriggerParam}<-TriggerList, TmpTriggerType == TriggerType, is_integer(TmpTriggerParam)] of
                [] -> MaxTriggerParam = 0;
                TriggerParamL -> MaxTriggerParam = lists:max(TriggerParamL)
            end,
            {_, _, LogicEndTime} = utime_logic:get_logic_day_time_info(),
            TriggerParam = max(utime:unixtime()+Param, MaxTriggerParam+Param),
            TriggerParamAfEtime = min(TriggerParam, Etime),
            NewTriggerParam = min(TriggerParamAfEtime, LogicEndTime),
            NewTriggerList = [{GradeId, TriggerType, NewTriggerParam}|TriggerList],
            RoleLiveness = #role_liveness{type = Type, subtype = SubType, grade_id = GradeId, trigger_type = TriggerType, param = NewTriggerParam},
            NewRoleLivenessList = [RoleLiveness|RoleLivenessList],
            case is_integer(NewTriggerParam) of
                true -> mod_treasure_hunt:set_luckey_value(NewTriggerParam);
                false -> skip
            end,
            lib_log_api:log_custom_act_liveness_ser_reward(Type, SubType, GradeId, TriggerType, NewTriggerParam),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 44, []),
            do_trigger_help(InfoList, ActInfo, NewTriggerList, NewRoleLivenessList);
        true ->
            do_trigger_help(InfoList, ActInfo, TriggerList, RoleLivenessList)
    end.

%% 获得下一个阶段触发信息
get_next_trigger_info_list(SubLiveness, Type, SubType, Times) ->
    #sub_custom_act_liveness{liveness_num = LivenessNum, trigger_list = TriggerList} = SubLiveness,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime = Stime} ->
            GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            Day = lib_custom_act_liveness:calc_day(Stime),
            F = fun(GradeId, List) ->
                case get_server_reward_info(Type, SubType, GradeId, LivenessNum, Day) of
                    false -> List;
                    {GradeId, TriggerType, Param, TotalSerTimes} ->
                        % ?MYLOG("hjhliveness", "{GradeId, TriggerType, Param, TotalSerTimes}:~p TriggerList:~p Times:~p ~n",
                        %     [{GradeId, TriggerType, Param, TotalSerTimes}, TriggerList, Times]),
                        IsMember = lists:keymember(GradeId, 1, TriggerList),
                        case IsMember == false andalso TotalSerTimes =< Times of
                            true -> [{GradeId, TriggerType, Param}|List];
                            false -> List
                        end
                end
            end,
            lists:foldl(F, [], GradeIds);
        _ ->
            []
    end.

get_server_reward_info(Type, SubType, GradeId, LivenessNum, Day) ->
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case lib_custom_act_check:check_act_condtion([day, ser_reward_type, liveness], Conditions) of
        [CfgDay, {TriggerType, Param}, LivenessL] when CfgDay==0 orelse CfgDay==Day ->
            TotalSerTimes = lib_custom_act_liveness:calc_ser_times(LivenessL, LivenessNum),% min(max(MinLiveness, umath:floor(LivenessNum*LivenessRatio)), MaxLiveness),
            {GradeId, TriggerType, Param, TotalSerTimes};
        _ ->
            false
    end.

%% 启动
act_start(State, Type, SubType) ->
    #custom_act_liveness_state{liveness_map = LivenessMap} = State,
    case maps:is_key({Type, SubType}, LivenessMap) of
        true -> {ok, State};
        false ->
            SubLiveness = act_start_help(Type, SubType),
            NewLivenessMap = maps:put({Type, SubType}, SubLiveness, LivenessMap),
            NewState = State#custom_act_liveness_state{liveness_map = NewLivenessMap},
            {ok, NewState}
    end.

act_start_help(Type, SubType) ->
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {limit_lv, LimitLv} = ulists:keyfind(limit_lv, 1, Condition, {limit_lv, 1}),
    {liveness_day, Day} = ulists:keyfind(liveness_day, 1, Condition, {liveness_day, 1}),
    NowTime = utime:unixtime(),
    case db_player_login_num(NowTime-?ONE_DAY_SECONDS*Day, NowTime, LimitLv) of
        [] ->
            LivenessNum = 0;
        [BaseLivenessNum] ->
            %% LivenessNum =  erlang:round(BaseLivenessNum / Day) 根据运营要求，去除求平均值的操作
            LivenessNum = BaseLivenessNum
    end,
    SubLiveness = #sub_custom_act_liveness{
        type = Type, subtype = SubType, liveness_num = LivenessNum, merge_time = util:get_merge_time(),
        times = 0, utime = NowTime, trigger_list = []
        },
    db_custom_act_liveness_replace(SubLiveness),
    SubLiveness.

%% 关闭
act_end(State, Type, SubType) ->
    #custom_act_liveness_state{liveness_map = LivenessMap} = State,
    NewLivenessMap = maps:remove({Type, SubType}, LivenessMap),
    spawn(fun() ->
        db_custom_act_liveness_delete(Type, SubType),
        lib_custom_act:db_delete_custom_act_data(Type, SubType)
    end),
    NewState = State#custom_act_liveness_state{liveness_map = NewLivenessMap},
    util:cast_event_to_players({'apply_cast', ?APPLY_CAST_STATUS, lib_custom_act_liveness, act_end, [Type, SubType]}),
    {ok, NewState}.

%% 获得活跃度记录
get_sub_liveness(#custom_act_liveness_state{liveness_map = LivenessMap}, Type, SubType) ->
    #sub_custom_act_liveness{
        utime = UTime, liveness_num = LivenessNum, merge_time = MergeTime
    } = SubLiveness = maps:get({Type, SubType}, LivenessMap, #sub_custom_act_liveness{type = Type, subtype = SubType}),
    % 是否通用清理
    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), UTime) of
        true -> SubLiveness;
        false -> #sub_custom_act_liveness{type = Type, subtype = SubType, liveness_num = LivenessNum, merge_time = MergeTime}
    end.

%% 登录
login(State, RoleId) ->
    #custom_act_liveness_state{liveness_map = LivenessMap} = State,
    F = fun({Type, SubType}, _, RoleLivenessList) ->
        #sub_custom_act_liveness{trigger_list = TriggerList} = get_sub_liveness(State, Type, SubType),
        F2 = fun({GradeId, TriggerType, TriggerParam}) ->
            #role_liveness{type = Type, subtype = SubType, grade_id = GradeId, trigger_type = TriggerType, param = TriggerParam}
        end,
        lists:map(F2, TriggerList) ++ RoleLivenessList
    end,
    RoleLivenessList = maps:fold(F, [], LivenessMap),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_custom_act_liveness, update, [RoleLivenessList]),
    {ok, State}.

%% 节日活跃界面
send_info(State, RoleId, Type, SubType) ->
    #sub_custom_act_liveness{times = Times, liveness_num = LivenessNum} = get_sub_liveness(State, Type, SubType),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_custom_act_liveness, send_info, [Type, SubType, Times, LivenessNum]),
    ok.

%% 增加提交次数
add_commit_count(State, Type, SubType, Count) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #sub_custom_act_liveness{times = Times} = SubLiveness = get_sub_liveness(State, Type, SubType),
            NewSubLiveness = SubLiveness#sub_custom_act_liveness{times = Times+Count, utime = utime:unixtime()},
            db_custom_act_liveness_replace(NewSubLiveness),
            #custom_act_liveness_state{liveness_map = LivenessMap} = State,
            NewLivenessMap = maps:put({Type, SubType}, NewSubLiveness, LivenessMap),
            NewState = State#custom_act_liveness_state{liveness_map = NewLivenessMap},
            NewState2 = trigger(NewState, Type, SubType),
            {ok, NewState2};
        false ->
            {ok, State}
    end.

%% 领取奖励
receive_ser_reward(State, RoleId, Type, SubType, GradeId) ->
    #sub_custom_act_liveness{times = Times, liveness_num = LivenessNum} = get_sub_liveness(State, Type, SubType),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_custom_act_liveness, receive_ser_reward, [Type, SubType, GradeId, Times, LivenessNum]),
    {ok, State}.

%% 获得节日活跃信息
db_custom_act_liveness_select() ->
    Sql = io_lib:format(?sql_custom_act_liveness_select, []),
    db:get_all(Sql).

%% 存储节日活跃信息
db_custom_act_liveness_replace(SubLiveness) ->
    #sub_custom_act_liveness{
        type = Type, subtype = SubType, liveness_num = LivenessNum, merge_time = MergeTime, times = Times, utime = UTime,
        trigger_list = TriggerList
        } = SubLiveness,
    TriggerListBin = util:term_to_bitstring(TriggerList),
    Sql = io_lib:format(?sql_custom_act_liveness_replace, [Type, SubType, LivenessNum, MergeTime, Times, UTime, TriggerListBin]),
    db:execute(Sql).

db_custom_act_liveness_delete(Type, SubType) ->
    Sql = io_lib:format(?sql_custom_act_liveness_delete, [Type, SubType]),
    db:execute(Sql).

%% 获得活跃人数
db_player_login_num(St, Et, LimitLv) ->
    Sql = io_lib:format(?sql_player_login_num, [St, Et, LimitLv]),
    db:get_row(Sql).