%% ---------------------------------------------------------------------------
%% @doc lib_custom_act_liveness.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-03-04
%% @deprecated 节日活跃奖励
%% ---------------------------------------------------------------------------
-module(lib_custom_act_liveness).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("custom_act_liveness.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").

%% 登录
login(Player) ->
    mod_custom_act_liveness:login(Player#player_status.id),
    Player#player_status{ca_liveness = #status_ca_liveness{}}.

%% 获得节日任务的数据
get_liveness_data(Player, Type, SubType) ->
    case lib_custom_act:act_data(Player, Type, SubType) of
        #custom_act_data{data = Data} -> 
            NewData = case Data of
                #custom_act_liveness{utime = UTime, times = OldTimes} = Data -> Data;
                _ -> 
                    OldTimes = 0,
                    UTime = utime:unixtime(),
                    #custom_act_liveness{utime = UTime}
            end, 
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                #act_info{stime = Stime, etime = Etime} when UTime >= Stime, UTime =< Etime ->
                    % 是否通用清理
                    case lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), UTime) of
                        true -> NewData;
                        false ->
                            %% 是否需要清理抽奖次数
                            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                                #custom_act_cfg{condition = Conditions} ->
                                    case lib_custom_act_check:check_act_condtion([is_clear_count], Conditions) of
                                        [0] -> #custom_act_liveness{times = OldTimes};
                                        _ -> #custom_act_liveness{}
                                    end;
                                _ ->
                                    #custom_act_liveness{}
                            end
                    end;
                _ ->
                    #custom_act_liveness{}
            end;
        _ -> 
            #custom_act_liveness{}
    end.

%% 奖励列表
send_reward_status(Player, ActInfo) ->
    #act_info{key = {Type, SubType}, stime = Stime} = ActInfo,
    Day = calc_day(Stime),
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                ShowBool1 = lists:keymember(weight, 1, Condition) orelse lists:keymember(total, 1, Condition),
                case lib_custom_act_check:check_act_condtion([day, ser_reward_type, liveness], Condition) of
                    [CfgDay, {_TriggerType, _Param}, _LivenessL] when CfgDay==0 orelse CfgDay==Day -> ShowBool2 = true;
                    _ -> ShowBool2 = false
                end,
                % 筛选奖励
                case ShowBool1 orelse ShowBool2 of
                    true ->
                        %% 计算奖励的领取状态
                        Status = lib_custom_act:count_reward_status(Player, ActInfo, RewardCfg),
                        %% 计算奖励的已领取次数
                        ReceiveTimes = lib_custom_act:count_receive_times(Player, ActInfo, RewardCfg),
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    false ->
                        Acc
                end;
            _ -> 
                Acc
        end
    end,
    PackList = lists:foldl(F, [], GradeIds),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 节日活跃界面
send_info(#player_status{id = RoleId}, Type, SubType) ->
    mod_custom_act_liveness:send_info(RoleId, Type, SubType),
    ok.

send_info(Player, Type, SubType, SerTimes, LivenessNum) ->
    #custom_act_liveness{times = PersonTimes} = get_liveness_data(Player, Type, SubType),
    SerRewardList = get_server_reward_status(Player, Type, SubType, SerTimes, LivenessNum),
    % ?MYLOG("hjhliveness", "Type:~p, SubType:~p  PersonTimes:~p, SerTimes:~p, SerRewardList:~p ~n", 
    %     [Type, SubType, PersonTimes, SerTimes, SerRewardList]),
    % tool:back_trace_to_file(),
    {ok, BinData} = pt_331:write(33193, [Type, SubType, PersonTimes, SerTimes, SerRewardList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 获得服奖励的状态
get_server_reward_status(Player, Type, SubType, SerTimes, LivenessNum) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime = Stime} = ActInfo ->
            #custom_act_liveness{grade_state = GradeState} = get_liveness_data(Player, Type, SubType),
            GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            Day = calc_day(Stime),
            % ?MYLOG("hjhliveness", "Stime:~p, Day:~p ~n", [Stime, Day]),
            F = fun(GradeId, List) ->
                case get_server_reward_status(Player, Type, SubType, GradeId, SerTimes, LivenessNum, ActInfo, GradeState, Day) of
                    false -> List;
                    {GradeId, TriggerType, ParamStr, TotalSerTimes, Reward, Status} -> [{GradeId, TriggerType, ParamStr, TotalSerTimes, Reward, Status}|List]
                end
            end,
            lists:foldl(F, [], GradeIds);
        _ ->
            []
    end.

%% 开始时间默认加四个小时
%% 活动开始+四个小时算是第一天
calc_day(Stime) ->
    LogicStime = Stime+3600*4,
    Now = max(LogicStime, utime:unixtime()),
    DayStartTime = utime_logic:get_logic_day_start_time(LogicStime),
    NowStartTime = utime_logic:get_logic_day_start_time(Now),
    (NowStartTime - DayStartTime) div 86400 + 1.

get_server_reward_status(Player, Type, SubType, GradeId, SerTimes, LivenessNum, ActInfo, GradeState, Day) ->
    #player_status{ca_liveness = #status_ca_liveness{liveness_map = LivenessMap}} = Player,
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        #custom_act_reward_cfg{condition = Conditions} = RewardCfg ->
            case lib_custom_act_check:check_act_condtion([day, ser_reward_type, liveness], Conditions) of
                [CfgDay, {?CA_LIVENESS_SER_REWARD=TriggerType, _}, LivenessL] when CfgDay==0 orelse CfgDay==Day -> % {MinLiveness, MaxLiveness, LivenessRatio}] ->
                    TotalSerTimes = calc_ser_times(LivenessL, LivenessNum), % min(max(MinLiveness, umath:floor(LivenessNum*LivenessRatio)), MaxLiveness),
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    IsGet = lists:keymember(GradeId, 1, GradeState),
                    if
                        IsGet -> Status = ?ACT_REWARD_HAS_GET; 
                        SerTimes >= TotalSerTimes -> Status = ?ACT_REWARD_CAN_GET; 
                        true -> Status = ?ACT_REWARD_CAN_NOT_GET
                    end,
                    {GradeId, TriggerType, util:term_to_string(undefined), TotalSerTimes, Reward, Status};
                [CfgDay, {TriggerType, _}, LivenessL] when CfgDay==0 orelse CfgDay==Day ->
                    TotalSerTimes = calc_ser_times(LivenessL, LivenessNum), % min(max(MinLiveness, umath:floor(LivenessNum*LivenessRatio)), MaxLiveness),
                    #role_liveness{param = Param} = maps:get({Type, SubType, GradeId}, LivenessMap, #role_liveness{}),
                    if
                        SerTimes >= TotalSerTimes -> Status = ?ACT_REWARD_HAS_GET; 
                        true -> Status = ?ACT_REWARD_CAN_NOT_GET
                    end,
                    {GradeId, TriggerType, util:term_to_string(Param), TotalSerTimes, [], Status};
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 计算服奖励次数
calc_ser_times([], _LivenessNum) -> 9999;
calc_ser_times([{Min, Max, Count}|T], LivenessNum) ->
    case LivenessNum >= Min andalso LivenessNum =< Max of
        true -> Count;
        false -> calc_ser_times(T, LivenessNum)
    end;
calc_ser_times(_LivenessL, _LivenessNum) -> 9999.

%% 节日活跃提交
commit(Player, Type, SubType, CostType) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            CostKey = get_cost_type_key(CostType),
            %% cost2 会根据group尽量提交
            case lib_custom_act_check:check_act_condtion([CostKey, group], Conditions) of
                [Cost, Group] when CostKey == cost2 ->
                    MaxNum = lib_goods_api:get_cost_max_num(Player, Cost),
                    % ?PRINT("Type:~p, SubType:~p, CostType:~p, Cost:~p, Group:~p MaxNum:~p ~n", [Type, SubType, CostType, Cost, Group, MaxNum]),
                    commit(Player, Type, SubType, CostType, max(min(MaxNum, Group), 1));
                _ -> 
                    commit(Player, Type, SubType, CostType, 1)
            end;
        _ ->
            commit(Player, Type, SubType, CostType, 1)
    end.

%% 节日活跃提交
commit(Player, Type, SubType, CostType, Times) when Type == ?CUSTOM_ACT_TYPE_LIVENESS ->
    case check_commit(Player, Type, SubType, CostType, Times) of
        {false, ErrCode} -> NewPlayer2 = Player, Rewards = [], NewAllTimes = 0;
        {true, CostKey, CostList} ->
            About = lists:concat(["Type:", Type, ",SubType:", SubType, ",CostType:", CostType]),
            % ?MYLOG("hjhliveness", "CostType:~p CostList:~p ~n", [CostType, CostList]),
            case lib_goods_api:cost_object_list_with_check(Player, CostList, custom_act_liveness_commit, About) of
                {false, ErrCode, NewPlayer2} -> Rewards = [], NewAllTimes = 0;
                {true, NewPlayer} ->
                    ErrCode = ?SUCCESS,
                    {ok, NewPlayer2, GradeIds, NewAllTimes} = do_commit(NewPlayer, Type, SubType, CostKey, CostList, Times),
                    Rewards = lib_custom_act_draw:construct_reward_list_for_client(Type, SubType, GradeIds)
            end
    end,
    {ok, BinData} = pt_331:write(33194, [ErrCode, Type, SubType, CostType, Rewards, NewAllTimes]),
    lib_server_send:send_to_sid(NewPlayer2#player_status.sid, BinData),
    {ok, NewPlayer2};
commit(Player, _Type, _SubType, _CostType, _Times) ->
    {ok, Player}.

%% 检查提交
check_commit(_Player, Type, SubType, CostType, Times) ->
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, open_hour_list) of
        {open_hour_list, HourList} -> 
            {_, {H, _M, _S}} = utime:localtime(),
            CheckTime = lists:any(fun({SHour, EHour}) -> H>=SHour andalso (H=<EHour orelse EHour==0) end, HourList);
        _ -> 
            CheckTime = true
    end,
    if
        IsOpen == false -> {false, ?ERRCODE(err331_act_closed)};
        CheckTime == false -> {false, ?ERRCODE(err331_not_open_hour_list)};
        true ->
            case get_cost(Type, SubType, CostType, Times) of
                {false, ErrCode} -> {false, ErrCode};
                {true, CostKey, CostList} -> {true, CostKey, CostList}
            end
    end.

%% 获得消耗
get_cost(Type, SubType, CostType, Times) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            CostKey = get_cost_type_key(CostType),
            case lists:keyfind(CostKey, 1, Conditions) of
                {_, Cost} -> 
                    SumCost = [{TmpType, GoodsTypeId, Num*Times}||{TmpType, GoodsTypeId, Num}<-Cost],
                    {true, CostKey, SumCost};
                _ -> 
                    {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

get_cost_type_key(1) -> cost1;
get_cost_type_key(2) -> cost2;
get_cost_type_key(_) -> false.

%% 检查时间

%% 目前的规则:后续如果变动可以改成通用字段控制
% %% cost1: 只增加抽奖次数和全服次数
% do_commit(Player, Type, SubType, cost1, CostList, Times) ->
%     #player_status{id = RoleId} = Player,
%     % 获得奖励
%     #custom_act_liveness{times = AllTimes} = LivenessData = get_liveness_data(Player, Type, SubType),
%     % 存储
%     NewAllTimes = AllTimes+Times,
%     NewLivenessData = LivenessData#custom_act_liveness{times = AllTimes+Times, utime = utime:unixtime()},
%     ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewLivenessData},
%     NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
%     % 日志
%     GradeIds = [], Rewards = [],
%     lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards),
%     lib_log_api:log_custom_act_liveness(RoleId, Type, SubType, Times, CostList, GradeIds, Rewards),
%     % 触发全服
%     mod_custom_act_liveness:add_commit_count(Type, SubType, Times),
%     {ok, NewPlayer, GradeIds, NewAllTimes};
do_commit(Player, Type, SubType, _CostType, CostList, Times) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Player,
    % 获得奖励
    #custom_act_liveness{times = AllTimes, grade_state = GradeState} = LivenessData = get_liveness_data(Player, Type, SubType),
    Pool = lib_custom_act_draw:get_pool(Type, SubType),
    {NewAllTimes, NewGradeState, GradeIds} = do_commit_help(RoleId, AllTimes, Pool, GradeState, Type, SubType, Times, []),
    % 传闻处理
    Rewards = send_tv(GradeIds, Type, SubType, [], RoleName, RoleId),
    % 存储
    NewLivenessData = LivenessData#custom_act_liveness{times = NewAllTimes, grade_state = NewGradeState, utime = utime:unixtime()},
    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewLivenessData},
    NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
    % 发送奖励
    Remark = lists:concat(["SubType:", SubType]),
    Produce = #produce{type = custom_act_liveness_commit, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards),
    lib_log_api:log_custom_act_liveness(RoleId, Type, SubType, Times, CostList, GradeIds, Rewards),
    % 触发全服
    mod_custom_act_liveness:add_commit_count(Type, SubType, Times),
    {ok, NewPlayer2, GradeIds, NewAllTimes}.

%% 抽奖
do_commit_help(_RoleId, AllTimes, _Pool, GradeState, _Type, _SubType, 0, GradeIds) -> {AllTimes,GradeState,GradeIds};
do_commit_help(RoleId, AllTimes, Pool, GradeState, Type, SubType, Times, GradeIds) ->
    RealPool = lib_custom_act_draw:recalc_pool(Pool, AllTimes),
    F = fun({_Weight, GradeId}) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        lib_custom_act_draw:can_give_grade(Conditions, GradeId, GradeState, AllTimes)
    end,
    RealPool2 = lists:filter(F, RealPool),
    GradeId = urand:rand_with_weight(RealPool2),  %%奖池里面的大奖id一定是有配置的
    DrawTimes = lib_custom_act_draw:get_conditions(GradeId, GradeState),
    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, DrawTimes+1}),
    do_commit_help(RoleId, AllTimes + 1, Pool, NewGradeState, Type, SubType, Times-1, [GradeId|GradeIds]).

%% 处理需要发传闻的奖励
send_tv([], _, _, Rewards,_,_) -> Rewards;
send_tv([GradeId|GradeIds], Type, SubType, Rewards, RoleName, RoleId) ->  
    #custom_act_reward_cfg{condition = Conditions, reward = Reward} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    [{T, GoodsTypeId, N}] = Reward,
    case lib_custom_act_draw:get_conditions(is_tv, Conditions) of
        1 -> lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 30, [RoleName, RoleId, GoodsTypeId, Type, SubType]);
        _ -> skip
    end,
    send_tv(GradeIds, Type, SubType, [{T, GoodsTypeId, N}|Rewards], RoleName, RoleId).

%% 领取全服奖励
receive_ser_reward(#player_status{id = RoleId} = Player, Type, SubType, GradeId, SerTimes, LivenessNum) when Type == ?CUSTOM_ACT_TYPE_LIVENESS ->
    % ?MYLOG("hjhliveness", "Type:~p, SubType:~p, GradeId:~p ~n", [Type, SubType, GradeId]),
    case check_receive_ser_reward(Player, Type, SubType, GradeId, SerTimes, LivenessNum) of
        {false, ErrCode} -> NewPlayer2 = Player, Rewards = [];
        {true, LivenessData, Rewards} -> 
            ErrCode = ?SUCCESS,
            #custom_act_liveness{grade_state = GradeState} = LivenessData,
            DrawTimes = lib_custom_act_draw:get_conditions(GradeId, GradeState),
            NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, DrawTimes+1}),
            % 存储
            NewLivenessData = LivenessData#custom_act_liveness{grade_state = NewGradeState, utime = utime:unixtime()},
            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewLivenessData},
            NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
            % 发送奖励
            Remark = lists:concat(["SubType:", SubType]),
            Produce = #produce{type = custom_act_liveness, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_0},
            NewPlayer2 = lib_goods_api:send_reward(NewPlayer, Produce),
            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Rewards),
            lib_log_api:log_custom_act_liveness(RoleId, Type, SubType, 0, [], [GradeId], Rewards)
    end,
    {ok, BinData} = pt_331:write(33195, [ErrCode, Type, SubType, GradeId, Rewards]),
    lib_server_send:send_to_sid(NewPlayer2#player_status.sid, BinData),
    {ok, NewPlayer2};
receive_ser_reward(Player, _Type, _SubType, _GradeId, _SerTimes, _LivenessNum) ->
    {ok, Player}.

check_receive_ser_reward(Player, Type, SubType, GradeId, SerTimes, LivenessNum) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true -> 
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                #act_info{stime = Stime} = ActInfo ->
                    #custom_act_liveness{grade_state = GradeState} = LivenessData = get_liveness_data(Player, Type, SubType),
                    Day = calc_day(Stime),
                    case get_server_reward_status(Player, Type, SubType, GradeId, SerTimes, LivenessNum, ActInfo, GradeState, Day) of
                        false -> {false, ?MISSING_CONFIG};
                        {_, _TriggerType, _ParamStr, _TotalSerTimes, Rewards, ?ACT_REWARD_CAN_GET} -> {true, LivenessData, Rewards};
                        {_, _TriggerType, _ParamStr, _TotalSerTimes, _Rewards, ?ACT_REWARD_HAS_GET} -> {false, ?ERRCODE(err331_already_get_reward)};
                        _ -> {false, ?ERRCODE(err331_act_can_not_get)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_act_closed)}
            end;
        false -> 
            {false, ?ERRCODE(err331_act_closed)}
    end.

%% -----------------------------------------------------------------
%% 接口
%% -----------------------------------------------------------------

%% 更新
update(Player, RoleLivenessList) ->
    #player_status{ca_liveness = StatusAcLiveness = #status_ca_liveness{liveness_map = LivenessMap}} = Player,
    F = fun(#role_liveness{type = Type, subtype = SubType, grade_id = GradeId} = RoleLiveness, Map) ->
        maps:put({Type, SubType, GradeId}, RoleLiveness, Map)
    end,
    NewLivenessMap = lists:foldl(F, LivenessMap, RoleLivenessList),
    NewStatusAcLiveness = StatusAcLiveness#status_ca_liveness{liveness_map = NewLivenessMap},
    % ?MYLOG("hjhliveness", "RoleLivenessList:~p ~n", [RoleLivenessList]),
    NewPlayer = Player#player_status{ca_liveness = NewStatusAcLiveness},
    {ok, NewPlayer}.

%% 触发
trigger(Player, RoleLivenessList) ->
    update(Player, RoleLivenessList).

%% 结束
act_end(Player, Type, SubType) ->
    #player_status{ca_liveness = StatusAcLiveness = #status_ca_liveness{liveness_map = LivenessMap}} = Player,
    F = fun({TmpType, TmpSubType, GradeId}, _Value, Map) ->
        case Type == TmpType andalso SubType == TmpSubType of
            true -> maps:remove({Type, SubType, GradeId}, Map);
            false -> Map
        end
    end,
    NewLivenessMap = maps:fold(F, LivenessMap, LivenessMap),
    NewStatusAcLiveness = StatusAcLiveness#status_ca_liveness{liveness_map = NewLivenessMap},
    NewPlayer = Player#player_status{ca_liveness = NewStatusAcLiveness},
    % 可以不需要,每次获取data数据的时候,会判断更新时间是否在活动期间
    % PlayerAfData = lib_custom_act:delete_act_data_to_player_without_db(NewPlayer, Type, SubType),
    {ok, NewPlayer}.

%% 获得全服效果
get_server_effect_by_dun_type(Player, DunType) ->
    IsMaterial = lists:member(DunType, ?dungeon_materials_list) orelse lib_dungeon_resource:is_resource_dungeon_type(DunType),
    R = if
        DunType == ?DUNGEON_TYPE_EXP_SINGLE ->
            get_server_effect(Player, ?CA_LIVENESS_EXP_DUN_DOUBLE);
        IsMaterial ->
            Add1 = get_server_effect(Player, ?CA_LIVENESS_MATERIALS_DUN_DOUBLE),
            Add2 = get_server_effect(Player, ?CA_LIVENESS_MATERIALS_DUN_EXTRA),
            Add1 + Add2;
        true ->
            0
    end,
    R.

%% 注意:经验加成需要乘以一万
get_server_effect(Player, TriggerType) ->
    #player_status{ca_liveness = #status_ca_liveness{liveness_map = LivenessMap}} = Player,
    NowTime = utime:unixtime(),
    F = fun
        ({Type, SubType, _GradeId}, #role_liveness{trigger_type = TmpTriggerType, param = Param}, {HadL, Effect}) when 
                TmpTriggerType == TriggerType andalso 
                (
                TmpTriggerType == ?CA_LIVENESS_EXP_DUN_DOUBLE orelse
                TmpTriggerType == ?CA_LIVENESS_MATERIALS_DUN_DOUBLE orelse
                TmpTriggerType == ?CA_LIVENESS_MATERIALS_DUN_EXTRA
                ) ->
            case NowTime =< Param of
                true ->
                    case lists:member({Type, SubType, TriggerType}, HadL)  of
                        true ->
                            {HadL, Effect};
                        false ->
                            AddRate = ?IF(TriggerType == ?CA_LIVENESS_MATERIALS_DUN_EXTRA, data_key_value:get(3310050), 1),
                            {[{Type, SubType, TriggerType}|HadL], Effect + AddRate}
                    end;
                false -> 
                    {HadL, Effect}
            end;
        (_K, _RoleLiveness, {HadL, Effect}) ->
            {HadL, Effect}
    end,
    {_, Effect} = maps:fold(F, {[], 0}, LivenessMap),
    % ?MYLOG("hjhliveness", "TriggerType:~p Effect:~p LivenessMap:~p ~n", [TriggerType, Effect, LivenessMap]),
    Effect.

%% 秘籍清理
gm_clean(Type, SubType) ->
    % 结束
    mod_custom_act_liveness:act_end(Type, SubType),
    mod_custom_act_liveness:act_start(Type, SubType),
    ok.

%% 秘籍清理个人数据
gm_clean_role(Player, Type, SubType) ->
    lib_custom_act:db_delete_custom_act_data(Player, Type, SubType),
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    NewDataMap = maps:remove({Type, SubType}, DataMap),
    NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
    Player#player_status{status_custom_act = NewStatusCustomAct}.

%% 秘籍-重新写入个人数据
gm_reload_person_times(Type, SubType, STime, ETime) ->
    % 汇总各玩家次数
    Sql1 = io_lib:format(
        "select role_id, draw_times
        from log_custom_act_liveness
        where type=~p and subtype=~p and time>=~p and time<=~p", [Type, SubType, STime, ETime]),
    LogList = db:get_all(Sql1),
    F1 = fun([RoleId, Times], AccM) ->
        OTimes = maps:get(RoleId, AccM, 0),
        NAccM = maps:put(RoleId, OTimes+Times, AccM),
        NAccM
    end,
    Map = lists:foldl(F1, #{}, LogList),
    % 汇总需要更新的数据
    NowTime = utime:unixtime(),
    F2 = fun(RoleId, Times, Acc) ->
        TmpSql = io_lib:format(
            "select data_list
            from custom_act_data
            where player_id=~p and type=~p and subtype=~p", [RoleId, Type, SubType]),
        case db:get_row(TmpSql) of
            [] ->
                CustomActData = #custom_act_liveness{times = Times, utime = NowTime},
                CustomActDataBin = util:term_to_bitstring(CustomActData),
                [[RoleId, Type, SubType, CustomActDataBin] | Acc];
            [OCustomActDataBin] ->
                OCustomActData = util:bitstring_to_term(OCustomActDataBin),
                #custom_act_liveness{times = OTimes} = OCustomActData,
                case OTimes == Times of
                    true -> Acc;
                    _ ->
                        CustomActData = OCustomActData#custom_act_liveness{times = Times},
                        CustomActDataBin = util:term_to_bitstring(CustomActData),
                        [[RoleId, Type, SubType, CustomActDataBin] | Acc]
                end
        end
    end,
    AccList = maps:fold(F2, [], Map),
    % 写数据库
    USql = usql:replace(custom_act_data, 
        [player_id, type, subtype, data_list], AccList),
    ?IF(USql =/= [], db:execute(USql), skip),
    % 刷新在线玩家数据
    [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, gm_refresh_liveness_data, [Type, SubType]) || Id <- lib_online:get_online_ids()],
    ok.

gm_refresh_liveness_data(PS, Type, SubType) ->
    {ok, NewPS} = lib_custom_act_api:gm_refresh_custom_act_data(PS, Type, SubType),
    pp_custom_act:handle(33193, NewPS, [Type, SubType]),
    {ok, NewPS}.
