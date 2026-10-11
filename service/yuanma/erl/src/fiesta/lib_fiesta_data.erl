%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_fiesta_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-03
%%% @modified
%%% @description    祭典数据处理库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_fiesta_data).

-include("common.hrl").
-include("def_fun.hrl").
-include("fiesta.hrl").
-include("goods.hrl").

% -export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(fiesta, [FiestaId, ActId, Type, Lv, Exp, BeginTime, ExpiredTime]) ->
    #fiesta{
        fiesta_id = FiestaId, act_id = ActId, type = Type, lv = Lv, exp = Exp,
        begin_time = BeginTime, expired_time = ExpiredTime
    };

make_record(fiesta_reward, [Lv, Status1, Status2]) ->
    #fiesta_reward{
        lv = Lv, status1 = Status1, status2 = Status2
    };

make_record(fiesta_task, [TaskId, FinishTimes, CurNum, Status, AccTimes]) ->
    #fiesta_task{
        task_id = TaskId, finish_times = FinishTimes,
        cur_num = CurNum, status = Status, acc_times = AccTimes
    };

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================

%% 清除玩家的旧祭典数据
clear_player_fiesta(RoleId) ->
    F = fun() ->
        db_delete_fiesta(RoleId),
        db_delete_fiesta_reward(RoleId),
        db_delete_fiesta_task(RoleId)
    end,
    db:transaction(F).

%% 获取创角天数(当前时间和创角时间相差天数+1)
get_reg_days(RegTime) ->
    utime:diff_days(RegTime) + 1.

%% 获取购买高级祭典消耗内容(钻石通道)
get_premium_cost_gold(Type, FiestaId) ->
    Content = get_premium_fiesta_content(Type, FiestaId),
    case lists:keyfind(cost1, 1, Content) of
        {cost1, [{product_id, _}|_]} -> []; % 已配置直购通道,钻石通道消耗为空
        _ ->
            case lists:keyfind(cost2, 1, Content) of
                {cost2, [{_, _, _}|_] = CostList} -> CostList;
                _ -> []
            end
    end.

%% 获取高级祭典购后内容
get_premium_fiesta_content(?NORMAL_FIESTA, _) -> [];
get_premium_fiesta_content(Type, FiestaId) ->
    #base_fiesta_act{
        content1 = Content1,
        content2 = Content2
    } = data_fiesta:get_base_fiesta_act(FiestaId),
    case Type of
        ?PREMIUM_FIESTA -> Content1;
        ?PREMIUM_FIESTA2 -> Content2;
        _ -> []
    end.

%% 根据商品id判断开通的祭典类型
get_premium_type_buy(FiestaId, ProductId) ->
    #base_fiesta_act{
        content1 = Content1,
        content2 = Content2
    } = data_fiesta:get_base_fiesta_act(FiestaId),
    {cost1, Cost1} = ulists:keyfind(cost1, 1, Content1, {cost1, []}),
    {cost1, Cost2} = ulists:keyfind(cost1, 1, Content2, {cost1, []}),
    {_, ProductId1} = ulists:keyfind(product_id, 1, Cost1, {product_id, -1}),
    {_, ProductId2} = ulists:keyfind(product_id, 1, Cost2, {product_id, -1}),
    case ProductId of
        ProductId1 -> ?PREMIUM_FIESTA;
        ProductId2 -> ?PREMIUM_FIESTA2;
        _ -> ?NORMAL_FIESTA
    end.

%% 获取高级祭典购后效果
get_premium_fiesta_effects(Type, FiestaId) ->
    Content = get_premium_fiesta_content(Type, FiestaId),
    {reward, EffectL} = ulists:keyfind(reward, 1, Content, {reward, []}),
    case lists:keyfind(lv, 1, EffectL) of
        {lv, _} -> EffectL;
        false -> [{lv, 0} | EffectL] % 添加升级效果用来触发修改高级奖励状态
    end.

%% 邮件发送过期祭典奖励
send_fiesta_reward_mail(RoleId, RewardList) ->
    {Title, Content} = {utext:get(?UNRECEIVE_REWARD_TITLE), utext:get(?UNRECEIVE_REWARD_CONTENT)},
    RewardList /= [] andalso lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList).

%% 根据创角时间和角色等级计算当前祭典活动数据
%% 注:如果要关闭祭典功能,可以把祭典的两个活动配置创角天数改为一个极大值
%%    如:[{1,99999,7}]
%% @return {当前祭典活动配置, 开始时间, 过期/结束时间} | null
calc_fiesta_act(RegTime, Lv) ->
    RegDays = get_reg_days(RegTime),
    {_, HdDay, _} = hd(?CYCLE_ACTS),
    {_, TlDay, TlDur} = hd(lists:reverse(?CYCLE_ACTS)),
    case RegDays-HdDay < 0 of
        true ->
            calc_fiesta_act(RegDays, Lv, ?UNCYCLE_ACTS);
        false ->
            CycleRange = TlDay + TlDur - HdDay, % 活动循环一次天数
            N = (RegDays - HdDay) rem CycleRange + HdDay, % 计算当前应落在哪个活动天数区间
            calc_fiesta_act(N, Lv, ?CYCLE_ACTS)
    end.

calc_fiesta_act(RegDays, Lv, ActList) ->
    F = fun({_, ADays, ADur}) -> RegDays >= ADays andalso RegDays < ADays + ADur end,
    case ulists:find(F, lists:reverse(ActList)) of
        error -> null;
        {ok, {ActId, ActDays, ActDur}} ->
            BaseFiestaAct = data_fiesta:get_base_fiesta_act(ActId, Lv),
            BeginTime = utime:unixdate() - (RegDays-ActDays) * ?ONE_DAY_SECONDS,
            ExpiredTime = BeginTime + ActDur * ?ONE_DAY_SECONDS,
            {BaseFiestaAct, BeginTime, ExpiredTime}
    end.

%% 计算任务刷新时间
%% @return {每日任务刷新时间,每周任务刷新时间}
calc_task_refresh_time(Fiesta) ->
    #fiesta{begin_time = BeginTime, expired_time = _ExpiredTime} = Fiesta,
    DRefreshTime = utime:get_next_unixdate(),
    DiffWeeks = utime:diff_weeks(BeginTime),
    WRefreshTime = BeginTime + (DiffWeeks+1) * ?ONE_WEEK_SECONDS,
    {DRefreshTime, WRefreshTime}.

%% 通过触发值更新任务信息
update_task_by_trigger(_TaskType, Task, Arg) ->
    #fiesta_task{
        task_id = TaskId, finish_times = FinishTimes, cur_num = CurNum,
        status = Status, acc_times = AccTimes
    } = Task,
    #base_fiesta_task{
        content = CType, times = TotalTimes, target_num = TargetNum
    } = data_fiesta:get_base_fiesta_task(TaskId),
    case lists:member(CType, ?DIRECT_SET_TASKS) of
        true ->
            case Arg >= TargetNum of
                true ->
                    % NewFinishTimes = FinishTimes + 1,
                    NewAccTimes = AccTimes + 1,
                    NewStatus = ?NOT_RECEIVE,
                    NewCurNum = ?IF(FinishTimes+NewAccTimes == TotalTimes, TargetNum, Arg);
                false ->
                    % NewFinishTimes = FinishTimes,
                    NewAccTimes = AccTimes,
                    NewStatus = Status,
                    NewCurNum = Arg
            end;
        false ->
            case CurNum + Arg >= TargetNum of
                true ->
                    % NewFinishTimes = FinishTimes + 1,
                    NewAccTimes = AccTimes + 1,
                    NewStatus = ?NOT_RECEIVE,
                    NewCurNum = ?IF(FinishTimes+NewAccTimes == TotalTimes, TargetNum, CurNum+Arg-TargetNum);
                false ->
                    % NewFinishTimes = FinishTimes,
                    NewAccTimes = AccTimes,
                    NewStatus = Status,
                    NewCurNum = CurNum + Arg
            end
    end,
    Task#fiesta_task{
        acc_times = NewAccTimes,
        status = NewStatus, cur_num = NewCurNum
    }.

%% 判断是否可以接任务
%% %% @return boolean()
is_task_can_received(Lv, RegTime, TaskId) ->
    #base_fiesta_task{open_day = OpenDay, open_lv = OpenLv} = data_fiesta:get_base_fiesta_task(TaskId),
    Lv >= OpenLv andalso get_reg_days(RegTime) >= OpenDay.

%% 判断任务是否全部完成
%% @return boolean()
is_task_finish_total(Task) ->
    #fiesta_task{task_id = TaskId, finish_times = FinishTimes, acc_times = AccTimes} = Task,
    #base_fiesta_task{times = TotalTimes} = data_fiesta:get_base_fiesta_task(TaskId),
    FinishTimes+AccTimes >= TotalTimes.

%% 判断任务是否阶段性完成
%% @return boolean()
is_task_finish(Task) ->
    #fiesta_task{task_id = TaskId, cur_num = CurNum} = Task,
    #base_fiesta_task{target_num = TargetNum} = data_fiesta:get_base_fiesta_task(TaskId),
    CurNum >= TargetNum.

%% 是否到祭典新的一周
%% @return boolean()
is_new_week(BeginTime, LastLogoutTime) ->
    NowTime = utime:unixtime(),
    DiffWeeks1 = utime:diff_weeks(BeginTime, LastLogoutTime),
    DiffWeeks2 = utime:diff_weeks(BeginTime, NowTime),
    if
        DiffWeeks1 == DiffWeeks2; DiffWeeks2 < 1 -> false; % 上次登出时是当前周或当前周是第一周
        true -> true
    end.

%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).

%% fiesta

db_select_fiesta(RoleId) ->
    sql(get_row, ?SELECT_FIESTA, [RoleId]).

db_delete_fiesta(RoleId) ->
    sql(execute, ?DELETE_FIESTA, [RoleId]).

db_replace_fiesta(RoleId, Fiesta) ->
    #fiesta{
        fiesta_id = FiestaId, act_id = ActId,
        type = Type, lv = Lv, exp = Exp,
        begin_time = BeginTime, expired_time = ExpireTime
    } = Fiesta,
    Args = [RoleId, FiestaId, ActId, Type, Lv, Exp, BeginTime, ExpireTime],
    sql(execute, ?REPLACE_FIESTA, Args).

db_select_fiesta_expired(NowTime) ->
    sql(get_all, ?SELECT_FIESTA_EXPIRED, [NowTime, ?NOT_RECEIVE, ?NOT_RECEIVE]).

%% fiesta_reward

db_select_fiesta_reward(RoleId) ->
    sql(get_all, ?SELECT_FIESTA_REWARD, [RoleId]).

db_delete_fiesta_reward(RoleId) ->
    sql(execute, ?DELETE_FIESTA_REWARD, [RoleId]).

db_replace_fiesta_reward(RoleId, FiestaReward) ->
    #fiesta_reward{
        lv = Lv, status1 = Status1, status2 = Status2
    } = FiestaReward,
    Args = [RoleId, Lv, Status1, Status2],
    sql(execute, ?REPLACE_FIESTA_REWARD, Args).

%% @param Params :: [[RoleId, Lv, Status1, Status2],...]
db_replace_fiesta_reward_multi(Params) ->
    Sql = usql:replace(fiesta_reward, [role_id, lv, status1, status2], Params),
    Sql /= [] andalso db:execute(Sql).

%% fiesta_task

db_select_fiesta_task(RoleId) ->
    sql(get_all, ?SELECT_FIESTA_TASK, [RoleId]).

db_delete_fiesta_task(RoleId) ->
    sql(execute, ?DELETE_FIESTA_TASK, [RoleId]).

db_delete_fiesta_task_type(RoleId, Type) ->
    sql(execute, ?DELETE_FIESTA_TASK_TYPE, [RoleId, Type]).

db_replace_fiesta_task(RoleId, TaskType, FiestaTask) ->
    #fiesta_task{
        task_id = TaskId, finish_times = FinishTimes,
        cur_num = CurNum, status = Status, acc_times = AccTimes
    } = FiestaTask,
    Args = [RoleId, TaskType, TaskId, FinishTimes, CurNum, Status, AccTimes],
    sql(execute, ?REPLACE_FIESTA_TASK, Args).

db_replace_fiesta_task(RoleId, FiestaTaskM) ->
    F = fun({TaskType, TaskL}, AccParams) ->
        Params = [db_replace_fiesta_task_params(RoleId, TaskType, FiestaTask) || FiestaTask <- TaskL],
        Params ++ AccParams
    end,
    AllParams = lists:foldl(F, [], maps:to_list(FiestaTaskM)),
    db_replace_fiesta_task_multi(AllParams).

db_replace_fiesta_task_multi(Params) ->
    [begin
        Sql = usql:replace(fiesta_task, [role_id, type, task_id, finish_times, cur_num, status, acc_times], Item),
        Sql =/= [] andalso db:execute(Sql)
    end || Item <- ulists:split_stable_num_list(Params, 200)].

db_replace_fiesta_task_params(RoleId, TaskType, FiestaTask) ->
    #fiesta_task{
        task_id = TaskId, finish_times = FinishTimes,
        cur_num = CurNum, status = Status, acc_times = AccTimes
    } = FiestaTask,
    [RoleId, TaskType, TaskId, FinishTimes, CurNum, Status, AccTimes].
