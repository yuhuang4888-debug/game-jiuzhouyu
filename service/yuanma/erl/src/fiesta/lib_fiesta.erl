%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_fiesta.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-03
%%% @modified
%%% @description    祭典玩家进程库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_fiesta).

% -include("common.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("fiesta.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("server.hrl").

-export([login/1, daily_refresh/0, daily_refresh_fiesta/1, init_fiesta/2]).

-export([send_fiesta_info/1, receive_fiesta_reward/2, send_task_info/2, receive_task_reward/3,
         buy_premium_fiesta/2, activate_premium_fiesta_prop/2, activate_premium_fiesta/2]).

-export([add_fiesta_exp/2, send_msg/2]).

-export([log_fiesta/2, log_fiesta_task_progress/3, log_fiesta_task_reward/4, log_fiesta_reward/4]).

-export([get_fiesta/1, set_fiesta/2, get_begin_time/1, get_expired_time/1, get_fiesta_id/1,
         get_act_id/1, set_reward_map/2, gex_task_map/1, get_task_map/1, set_task_map/3,
         set_lv_reward/3, gex_task_list/2, set_task_list/5, gex_task/3, set_task/6, set_task/3]).

% -compile(export_all).

%%% ======================================== init/load/clear =======================================

%% 登录
login(PS) ->
    #player_status{id = RoleId} = PS,
    Fiesta0 = lib_fiesta_data:db_select_fiesta(RoleId),
    % 数据是否为空或过期
    %   N - 直接赋值返回
    %   Y - 清理旧数据
    %       计算玩家当前新的祭典活动
    %       入库,赋值返回
    Fiesta = init_fiesta(Fiesta0, PS),
    PS#player_status{fiesta = Fiesta}.

%% 0点刷新
daily_refresh() ->
    spawn(fun() -> daily_refresh_fiesta() end).

%% 每日刷新祭典数据
daily_refresh_fiesta() ->
    % % 发放未领取奖励(离线玩家处理) - 现在统一等玩家登录再处理
    % spawn(fun() ->
    %     NowTime = utime:unixtime(),
    %     ExpiredFiesta = lib_fiesta_data:db_select_fiesta_expired(NowTime),
    %     auto_send_expired_reward(ExpiredFiesta, [])
    % end),
    % 在线玩家刷新
    [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, ?MODULE, daily_refresh_fiesta, []) || Id <- lib_online:get_online_ids()],
    ok.

daily_refresh_fiesta(#player_status{fiesta = undefined} = PS) -> PS;
daily_refresh_fiesta(PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, fiesta = Fiesta} = PS,
    #fiesta{fiesta_id = FiestaId, expired_time = ExpiredTime, task_m = TaskM, wrefresh_time = WRefreshTime} = Fiesta,
    case ExpiredTime > NowTime of
        true ->
            % 每日任务
            DailyM = get_fiesta_task_map(RoleId, FiestaId, ?DAILY_TASK),
            NTaskM1 = maps:merge(TaskM, DailyM),
            % 每周任务
            case NowTime >= WRefreshTime of
                true -> WeeklyM = get_fiesta_task_map(RoleId, FiestaId, ?WEEKLY_TASK);
                false -> WeeklyM = maps:with([?WEEKLY_TASK], NTaskM1)
            end,
            NTaskM2 = maps:merge(NTaskM1, WeeklyM),
            % 刷新时间更新
            {NDRefreshTime, NWRefreshTime} = lib_fiesta_data:calc_task_refresh_time(Fiesta),
            NewFiesta = Fiesta#fiesta{task_m = NTaskM2, drefresh_time = NDRefreshTime, wrefresh_time = NWRefreshTime},
            NewPS = PS#player_status{fiesta = NewFiesta};
        false ->
            % 发放未领取奖励
            NewPS0 = auto_send_expired_reward(PS),
            % 清理;重置祭典
            lib_fiesta_data:clear_player_fiesta(RoleId),
            NewFiesta = init_fiesta([], NewPS0),
            NewPS = NewPS0#player_status{fiesta = NewFiesta},
            send_fiesta_info(NewPS)
    end,
    send_task_info(0, NewPS),
    % 登录任务立即处理
    {ok, NewPS1} = lib_fiesta_api:handle_event(NewPS, #event_callback{type_id = ?EVENT_LOGIN_CAST}),
    NewPS1.

%%% ======================================= protocol related =======================================

%% -----------------------------------------------
%% @doc 发送祭典信息
-spec
send_fiesta_info(PS) -> ok when
    PS :: #player_status{}.
%% -----------------------------------------------
send_fiesta_info(#player_status{sid = SId, fiesta = undefined}) ->
    Args = [0, 0, 0, 0, 0, 0, []],
    lib_server_send:send_to_sid(SId, pt_194, 19401, Args),
    ok;
send_fiesta_info(#player_status{sid = SId, fiesta = Fiesta}) ->
    #fiesta{
        fiesta_id = FiestaId, act_id = ActId, type = Type, lv = Lv, exp = Exp,
        expired_time = ExpiredTime, reward_m = RewardM
    } = Fiesta,
    % IsPremium = ?IF(Type == ?NORMAL_FIESTA, 0, 1),
    RewardL = [{FLv, Status1, Status2} ||
        #fiesta_reward{lv = FLv, status1 = Status1, status2 = Status2} <- maps:values(RewardM)],
    Args = [FiestaId, ActId, Type, Lv, Exp, ExpiredTime, RewardL],
    lib_server_send:send_to_sid(SId, pt_194, 19401, Args),
    ok.

%% -----------------------------------------------
%% @doc 领取祭典奖励
-spec
receive_fiesta_reward(Lv, PS) -> NewPS when
    Lv :: integer(),
    PS :: #player_status{},
    NewPS :: #player_status{}.
%% -----------------------------------------------
receive_fiesta_reward(0, PS) ->
    Lvs = get_can_receive_fiesta_lvs(PS),
    do_receive_fiesta_reward(Lvs, PS);
receive_fiesta_reward(Lv, PS) ->
    case lib_fiesta_check:receive_fiesta_reward(Lv, PS) of
        true ->
            do_receive_fiesta_reward([Lv], PS);
        {false, ErrCode} ->
            send_msg(PS, ErrCode),
            PS
    end.

do_receive_fiesta_reward([], PS) -> PS;
do_receive_fiesta_reward(Lvs, PS) ->
    #player_status{sid = SId} = PS,
    {TotalReward, DbParam, NewPS1} = lists:foldl(fun get_can_receive_fiesta_rewards/2, {[], [], PS}, Lvs),
    lib_fiesta_data:db_replace_fiesta_reward_multi(DbParam),
    case TotalReward of
        [] -> NewPS1;
        _ ->
            % 发放奖励
            Produce = #produce{type = fiesta, reward = TotalReward},
            NewPS2 = ?IF(TotalReward == [], NewPS1, lib_goods_api:send_reward(NewPS1, Produce)),
            % 反馈
            send_fiesta_info(NewPS2),
            lib_server_send:send_to_sid(SId, pt_194, 19402, [TotalReward]),
            NewPS2
    end.

%% 获取对应等级可领取的奖励
get_can_receive_fiesta_rewards(Lv, {AccReward, AccDbParam, AccPS}) ->
    #player_status{id = RoleId, fiesta = Fiesta} = AccPS,
    #fiesta{
        fiesta_id = FiestaId, type = Type, reward_m = RewardM
    } = Fiesta,
    #base_fiesta_lv_exp{
        reward = NormalReward,
        premium_reward = PremiumReward
    } = data_fiesta:get_base_fiesta_lv_exp(FiestaId, Lv),
    % 计算奖励,更新奖励状态
    case is_premium_type(Type) of
        true ->
            #fiesta_reward{status1 = Status1} = maps:get(Lv, RewardM),
            Reward = ?IF(Status1 == ?NOT_RECEIVE, NormalReward ++ PremiumReward, PremiumReward),
            FiestaReward = #fiesta_reward{lv = Lv, status1 = ?HAS_RECEIVE, status2 = ?HAS_RECEIVE};
        false ->
            Reward = NormalReward,
            FiestaReward = #fiesta_reward{lv = Lv, status1 = ?HAS_RECEIVE, status2 = ?NOT_ACHIEVE}
    end,
    % 日志,入库参数
    log_fiesta_reward(RoleId, FiestaId, Lv, Reward),
    DbParam = [RoleId, Lv, FiestaReward#fiesta_reward.status1, FiestaReward#fiesta_reward.status2],
    NewAccPS = set_lv_reward(Lv, FiestaReward, AccPS),
    {AccReward ++ Reward, [DbParam | AccDbParam], NewAccPS}.

%% -----------------------------------------------
%% @doc 发送祭典任务信息
-spec
send_task_info(TaskType, PS) -> ok when
    TaskType :: integer(),
    PS :: #player_status{}.
%% -----------------------------------------------
send_task_info(_, #player_status{sid = SId, fiesta = undefined}) ->
    lib_server_send:send_to_sid(SId, pt_194, 19403, [[]]),
    ok;
send_task_info(0, PS) ->
    #player_status{sid = SId} = PS,
    TaskInfo = [get_task_info(TaskType, PS) || TaskType <- [?DAILY_TASK, ?WEEKLY_TASK, ?SEASON_TASK]],
    lib_server_send:send_to_sid(SId, pt_194, 19403, [TaskInfo]),
    ok;
send_task_info(TaskType, PS) ->
    #player_status{sid = SId} = PS,
    TaskInfo = get_task_info(TaskType, PS),
    lib_server_send:send_to_sid(SId, pt_194, 19403, [[TaskInfo]]),
    ok.

get_task_info(TaskType, PS) ->
    #player_status{fiesta = Fiesta, figure = #figure{lv = Lv}, reg_time = RegTime} = PS,
    #fiesta{
        task_m = TaskM, expired_time = ExpiredTime,
        drefresh_time = DRefreshTime, wrefresh_time = WRefreshTime
    } = Fiesta,
    TaskL = maps:get(TaskType, TaskM, []),
    TaskLData = [
        begin
            #fiesta_task{task_id = TaskId, finish_times = FinishTimes,
                        cur_num = TCurNum, status = Status
            } = FiestaTask,
            #base_fiesta_task{target_num = TargetNum} = data_fiesta:get_base_fiesta_task(TaskId),
            CurNum = ?IF(Status == ?NOT_ACHIEVE, TCurNum, TargetNum),
            {TaskId, FinishTimes, CurNum, Status}
        end || FiestaTask <- TaskL, lib_fiesta_data:is_task_can_received(Lv, RegTime, FiestaTask#fiesta_task.task_id)
    ],
    RefreshTime =
    case TaskType of
        ?DAILY_TASK -> DRefreshTime;
        ?WEEKLY_TASK -> WRefreshTime;
        ?SEASON_TASK -> ExpiredTime;
        _ -> 0
    end,
    {TaskType, TaskLData, RefreshTime}.

%% -----------------------------------------------
%% @doc 领取任务经验奖励
-spec receive_task_reward(TaskType, TaskId, PS) -> NewPS when
    TaskType :: 0 | ?DAILY_TASK | ?WEEKLY_TASK | ?SEASON_TASK,
    TaskId :: integer(),
    PS :: #player_status{},
    NewPS :: #player_status{}.
%% -----------------------------------------------
receive_task_reward(0, 0, PS) -> % 领取全部类型任务奖励
    F = fun(TaskType, AccPS) -> receive_task_reward(TaskType, 0, AccPS) end,
    lists:foldl(F, PS, [?DAILY_TASK, ?WEEKLY_TASK, ?SEASON_TASK]);
receive_task_reward(TaskType, 0, PS) -> % 领取单类型全部任务奖励
    TaskIds = get_can_receive_fiesta_task_ids(TaskType, PS),
    do_receive_task_reward(TaskType, TaskIds, PS);
receive_task_reward(TaskType, TaskId, PS) ->
    case lib_fiesta_check:receive_task_reward(TaskType, TaskId, PS) of
        true ->
            do_receive_task_reward(TaskType, [TaskId], PS);
        {false, ErrCode} ->
            send_msg(PS, ErrCode),
            PS
    end.

do_receive_task_reward(TaskType, TaskIds, #player_status{sid = SId} = PS) ->
    {_, TotalAdd, NewPS} = lists:foldl(fun do_receive_one_task_reward/2, {TaskType, 0, PS}, TaskIds),
    % 反馈
    send_fiesta_info(NewPS),
    send_task_info(TaskType, NewPS),
    lib_server_send:send_to_sid(SId, pt_194, 19404, [TotalAdd]),
    NewPS.

do_receive_one_task_reward(TaskId, {TaskType, AccExp, PS}) -> % 单个任务处理
    #player_status{id = RoleId} = PS,
    {Task, TaskL, TaskM, OldFiesta} = gex_task(TaskType, TaskId, PS),
    % 经验增加处理
    #fiesta_task{acc_times = AccTimes, finish_times = FinishTimes} = Task,
    #base_fiesta_task{exp = ExpAdd, times = TotalTimes} = data_fiesta:get_base_fiesta_task(TaskId),
    TotalAdd = ExpAdd * AccTimes,
    NewPS1 = add_fiesta_exp(TotalAdd, PS),
    NewFiesta = get_fiesta(NewPS1),
    % 日志,更新祭典数据
    NewFinishTimes = FinishTimes + AccTimes,
    NewStatus = ?IF(NewFinishTimes == TotalTimes, ?HAS_RECEIVE, ?NOT_ACHIEVE),
    NewTask = Task#fiesta_task{finish_times = NewFinishTimes, status = NewStatus, acc_times = 0},
    NewPS2 = set_task(NewTask, TaskL, TaskType, TaskM, NewFiesta, NewPS1),
    log_fiesta_task_reward(RoleId, NewTask, OldFiesta, NewFiesta),
    lib_fiesta_data:db_replace_fiesta_task(RoleId, TaskType, NewTask),
    {TaskType, AccExp+TotalAdd, NewPS2}.

%% -----------------------------------------------
%% @doc 购买高级祭典
-spec
buy_premium_fiesta(Type, PS) -> NewPS when
    Type :: ?PREMIUM_FIESTA | ?PREMIUM_FIESTA2,
    PS :: #player_status{},
    NewPS :: #player_status{}.
%% -----------------------------------------------
buy_premium_fiesta(Type, PS) ->
    case lib_fiesta_check:buy_premium_fiesta(Type, PS) of
        true ->
            CostList = lib_fiesta_data:get_premium_cost_gold(Type, get_fiesta_id(PS)),
            {true, NewPS1} = lib_goods_api:cost_object_list(PS, CostList, fiesta, ""),
            activate_premium_fiesta(Type, NewPS1);
        {false, ErrCode} ->
            send_msg(PS, ErrCode),
            PS
    end.

%% 道具激活高级祭典
activate_premium_fiesta_prop(PS, Type) when is_record(PS, player_status) ->
    activate_premium_fiesta_prop(Type, PS);
activate_premium_fiesta_prop(Type, #player_status{fiesta = Fiesta} = PS) ->
    case lib_fiesta_check:have_not_got_premium(Fiesta) of % 检查是否已购买高级祭典，防止重复购买激活
        true ->
            activate_premium_fiesta(Type, PS);
        false ->
            send_msg(PS, ?ERRCODE(err194_fiesta_activated)),
            PS
    end.

%% 激活高级祭典
activate_premium_fiesta(Type, PS) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, fiesta = Fiesta} = PS,
    % 更新玩家祭典类型
    NewFiesta = Fiesta#fiesta{type = Type},
    NewPS1 = PS#player_status{fiesta = NewFiesta},
    lib_fiesta_data:db_replace_fiesta(RoleId, NewFiesta),
    % 激活高级效果(要先更新类型)
    EffectL = lib_fiesta_data:get_premium_fiesta_effects(Type, get_fiesta_id(NewPS1)),
    NewPS2 = activate_premium_fiesta_effect(EffectL, NewPS1),
    % 日志;反馈
    log_fiesta(NewPS2, NewFiesta),
    send_fiesta_info(NewPS2),
    % 传闻
    FiestaId = get_fiesta_id(PS),
    #base_fiesta_act{link_id = LinkId} = data_fiesta:get_base_fiesta_act(FiestaId),
    lib_chat:send_TV({all}, ?MOD_FIESTA, ?ACTIVATE_PREMIUM_LAN, [RoleName, RoleId, LinkId]),
    NewPS2.

%% 激活高级祭典效果
activate_premium_fiesta_effect([], PS) -> PS;
activate_premium_fiesta_effect([{buff, GTypeId} | T], PS) ->
    EndTime = get_expired_time(PS),
    {ok, NewPS} = lib_goods_buff:add_goods_buff(PS, GTypeId, 1, [{etime, EndTime}]),
    activate_premium_fiesta_effect(T, NewPS);
activate_premium_fiesta_effect([{exp, ExpAdd} | T], PS) ->
    NewPS = add_fiesta_exp(ExpAdd, PS),
    activate_premium_fiesta_effect(T, NewPS);
activate_premium_fiesta_effect([{lv, LvAdd} | T], PS) ->
    #player_status{id = RoleId, fiesta = Fiesta} = PS,
    #fiesta{fiesta_id = FiestaId, lv = CurLv, reward_m = RewardM} = Fiesta,
    MaxLv = data_fiesta:get_fiesta_max_lv(FiestaId),
    NewLv = min(MaxLv, CurLv+LvAdd),
    F = fun
        (0, AccM) -> AccM;
        (Lv, AccM) ->
        FiestaReward = maps:get(Lv, AccM, #fiesta_reward{lv = Lv, status1 = ?NOT_RECEIVE}),
        NewFiestaReward = FiestaReward#fiesta_reward{status2 = ?NOT_RECEIVE},
        lib_fiesta_data:db_replace_fiesta_reward(RoleId, NewFiestaReward),
        AccM#{Lv => NewFiestaReward}
    end,
    NewRewardM = lists:foldl(F, RewardM, lists:seq(0, NewLv)),
    NewFiesta = Fiesta#fiesta{reward_m = NewRewardM},
    NewPS = PS#player_status{fiesta = NewFiesta},
    activate_premium_fiesta_effect(T, NewPS).

%%% ======================================= utility functions ======================================

%% 判断开通的祭典是否为高级类型
is_premium_type(Type) -> Type > ?NORMAL_FIESTA.

%% 增加祭典经验
%% @return NewPS :: #player_status{}
add_fiesta_exp(ExpAdd, PS) ->
    #player_status{id = RoleId, fiesta = Fiesta} = PS,
    #fiesta{
        fiesta_id = FiestaId, lv = CurLv, type = Type,
        exp = CurExp, reward_m = RewardM
    } = Fiesta,
    % 新总经验值
    NewExp = CurExp + ExpAdd,
    % 新祭典等级
    case data_fiesta:get_base_fiesta_lv_exp(FiestaId, CurLv+1) of
        #base_fiesta_lv_exp{exp = NextExp} when NewExp >= NextExp ->
            NewLv = CurLv + 1;
        _ ->
            NewLv = CurLv
    end,
    % 更新奖励状态
    case NewLv /= CurLv of
        true ->
            ?IF(is_premium_type(Type),
                FiestaReward = #fiesta_reward{lv = NewLv, status1 = ?NOT_RECEIVE, status2 = ?NOT_RECEIVE},
                FiestaReward = #fiesta_reward{lv = NewLv, status1 = ?NOT_RECEIVE, status2 = ?NOT_ACHIEVE}
            ),
            NewRewardM = RewardM#{NewLv => FiestaReward},
            lib_fiesta_data:db_replace_fiesta_reward(RoleId, FiestaReward);
        false ->
            NewRewardM = RewardM
    end,
    % 更新祭典数据
    NewFiesta = Fiesta#fiesta{exp = NewExp, lv = NewLv, reward_m = NewRewardM},
    NewPS = PS#player_status{fiesta = NewFiesta},
    lib_fiesta_data:db_replace_fiesta(RoleId, NewFiesta),
    % 判断经验是否溢出至达到下一级
    case data_fiesta:get_base_fiesta_lv_exp(FiestaId, NewLv+1) of
        #base_fiesta_lv_exp{exp = NextExp1} when NewExp >= NextExp1 ->
            add_fiesta_exp(0, NewPS);
        _ ->
            NewPS
    end.

%% 返回码信息
send_msg(#player_status{sid = SId}, Code) ->
    send_msg(SId, Code);
send_msg(SId, Code) when is_pid(SId) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    lib_server_send:send_to_sid(SId, pt_194, 19400, [CodeInt, CodeArgs]);
send_msg(UId, Code) when is_integer(UId) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    lib_server_send:send_to_uid(UId, pt_194, 19400, [CodeInt, CodeArgs]).

%%% ========================================= log functions ========================================

%% 日志:玩家(高级)祭典开启
log_fiesta(PS, Fiesta) ->
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{lv = RoleLv}} = PS,
    RegDay = lib_fiesta_data:get_reg_days(RegTime),
    #fiesta{
        fiesta_id = FiestaId, act_id = ActId, type = Type,
        begin_time = BeginTime, expired_time = ExpiredTime
    } = Fiesta,
    lib_log_api:log_fiesta(RoleId, RegDay, RoleLv, FiestaId, ActId, Type, BeginTime, ExpiredTime).

%% 日志:玩家任务完成进度
log_fiesta_task_progress(RoleId, TaskType, Task) ->
    #fiesta_task{
        task_id = TaskId,
        finish_times = FinishTimes, cur_num = Progress,
        status = Status, acc_times = AccTimes
    } = Task,
    lib_log_api:log_fiesta_task_progress(RoleId, TaskType, TaskId, Progress, FinishTimes, Status, AccTimes).

%% 日志:玩家任务奖励领取
log_fiesta_task_reward(RoleId, Task, OFiesta, NFiesta) ->
    #fiesta{exp = OExp} = OFiesta,
    #fiesta{exp = NExp} = NFiesta,
    #fiesta_task{task_id = TaskId} = Task,
    lib_log_api:log_fiesta_task_reward(RoleId, TaskId, OExp, NExp).

%% 日志:玩家祭典奖励领取
log_fiesta_reward(RoleId, FiestaId, Lv, RewardL) ->
    lib_log_api:log_fiesta_reward(RoleId, FiestaId, Lv, RewardL).

%%% ======================================= private functions ======================================

%% 初始化玩家祭典数据
%% @return #fiesta{}
init_fiesta([], PS) ->
    #player_status{id = RoleId} = PS,
    case init_fiesta(PS) of
        undefined -> undefined;
        Fiesta1 when is_record(Fiesta1, fiesta)->
            FiestaRewardM = init_fiesta_reward(Fiesta1),
            FiestaTaskM = init_fiesta_task_cfg(RoleId, Fiesta1),
            {DRefreshTime, WRefreshTime} = lib_fiesta_data:calc_task_refresh_time(Fiesta1),
            Fiesta1#fiesta{
                reward_m = FiestaRewardM, task_m = FiestaTaskM,
                drefresh_time = DRefreshTime, wrefresh_time = WRefreshTime
            }
    end;
init_fiesta(Fiesta0, PS) ->
    #fiesta{expired_time = ExpiredTime} = Fiesta1 = lib_fiesta_data:make_record(fiesta, Fiesta0),
    #player_status{id = RoleId} = PS,
    case ExpiredTime > utime:unixtime() of
        true ->
            FiestaRewardM = init_fiesta_reward(RoleId),
            FiestaTaskM = init_fiesta_task_db(RoleId, Fiesta1),
            Fiesta2 = fix_fiesta_begin_time(Fiesta1, PS),
            {DRefreshTime, WRefreshTime} = lib_fiesta_data:calc_task_refresh_time(Fiesta2),
            Fiesta2#fiesta{
                reward_m = FiestaRewardM, task_m = FiestaTaskM,
                drefresh_time = DRefreshTime, wrefresh_time = WRefreshTime
            };
        false -> % 已过期,发放未领取奖励并重置祭典
            #fiesta{fiesta_id = FiestaId, type = Type} = Fiesta1,
            FiestaRewards = lib_fiesta_data:db_select_fiesta_reward(RoleId),
            RewardInfos = [[RoleId, FiestaId, Type, Lv, Status1, Status2] || [Lv, Status1, Status2] <- FiestaRewards],
            auto_send_expired_reward(RewardInfos, []),
            lib_fiesta_data:clear_player_fiesta(RoleId),
            init_fiesta([], PS)
    end.

init_fiesta(PS) ->
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{lv = Lv}} = PS,
    case lib_fiesta_data:calc_fiesta_act(RegTime, Lv) of
        {#base_fiesta_act{id = FiestaId, act_id = ActId }, BeginTime, ExpiredTime} ->
            Fiesta = #fiesta{
                fiesta_id = FiestaId, act_id = ActId, type = ?NORMAL_FIESTA,
                begin_time = BeginTime, expired_time = ExpiredTime
            },
            lib_fiesta_data:db_replace_fiesta(RoleId, Fiesta),
            log_fiesta(PS, Fiesta),
            Fiesta;
        _ ->
            undefined
    end.

%% 初始化祭典奖励数据
init_fiesta_reward(RoleId) when is_integer(RoleId) ->
    FiestaRewards = lib_fiesta_data:db_select_fiesta_reward(RoleId),
    lists:foldl(fun init_fiesta_reward/2, #{}, FiestaRewards);
init_fiesta_reward(Fiesta) when is_record(Fiesta, fiesta) -> #{}. % 动态添加,初始化时不需加载

init_fiesta_reward([Lv | _] = FiestaReward0, AccM) ->
    FiestaReward = lib_fiesta_data:make_record(fiesta_reward, FiestaReward0),
    AccM#{Lv => FiestaReward}.

%% 初始化祭典任务数据(登录时期调用)
init_fiesta_task_db(RoleId, Fiesta) -> % 优先走db,过期走配置
    #fiesta{fiesta_id = FiestaId, begin_time = BeginTime} = Fiesta,
    % 判断上次离线是否同一天/同一周
    %   Y - 从数据库取数据加载
    %   N - 清理db,重新取配置加载
    LastLogoutTime = lib_role:get_role_offline_timestamp(RoleId),
    FiestaTask0 = lib_fiesta_data:db_select_fiesta_task(RoleId),
    % 每日任务
    IsSameDay = utime:is_same_date(utime:unixtime(), LastLogoutTime),
    case IsSameDay of
        true ->
            DailyTaskData = [Data || [?DAILY_TASK|_] = Data <- FiestaTask0],
            DailyM = lists:foldl(fun init_fiesta_task/2, #{}, DailyTaskData);
        false ->
            DailyM = get_fiesta_task_map(RoleId, FiestaId, ?DAILY_TASK)
    end,
    % 每周任务
    case lib_fiesta_data:is_new_week(BeginTime, LastLogoutTime) of
        false ->
            WeeklyTaskData = [Data || [?WEEKLY_TASK|_] = Data <- FiestaTask0],
            WeeklyM = lists:foldl(fun init_fiesta_task/2, #{}, WeeklyTaskData);
        true ->
            WeeklyM = get_fiesta_task_map(RoleId, FiestaId, ?WEEKLY_TASK)
    end,
    % 赛季任务
    SeasonTaskData = [Data || [?SEASON_TASK|_] = Data <- FiestaTask0],
    SeasonM = lists:foldl(fun init_fiesta_task/2, #{}, SeasonTaskData),

    maps:merge(maps:merge(DailyM, WeeklyM), SeasonM).

init_fiesta_task_cfg(RoleId, Fiesta) -> % 走配置
    #fiesta{fiesta_id = FiestaId} = Fiesta,
    {_, TaskM} = lists:foldl(fun init_fiesta_task_type/2, {FiestaId, #{}}, [?DAILY_TASK, ?WEEKLY_TASK, ?SEASON_TASK]),
    lib_fiesta_data:db_replace_fiesta_task(RoleId, TaskM),
    TaskM.

init_fiesta_task([Type | FiestaTask0], AccM) -> % 根据数据库数据初始化
    FiestaTask = lib_fiesta_data:make_record(fiesta_task, FiestaTask0),
    FiestaTaskL = maps:get(Type, AccM, []),
    AccM#{Type => [FiestaTask | FiestaTaskL]};

init_fiesta_task(TaskId, AccL) -> % 根据配置数据初始化
    FiestaTask = lib_fiesta_data:make_record(fiesta_task, [TaskId, 0, 0, ?NOT_ACHIEVE, 0]),
    [FiestaTask | AccL].

init_fiesta_task_type(TaskType, {FiestaId, AccM}) ->
    case data_fiesta:get_base_fiesta_act_task(FiestaId, TaskType) of
        #base_fiesta_act_task{task_list = TaskIds} ->
            TaskL = lists:foldl(fun init_fiesta_task/2, [], TaskIds);
        _ ->
            TaskL = []
    end,
    {FiestaId, AccM#{TaskType => TaskL}}.

%% 修正因离线登录造成的祭典时间计算错误
%% return #fiesta{}
fix_fiesta_begin_time(Fiesta, PS) ->
    #fiesta{begin_time = BeginTime0, expired_time = ExpiredTime0} = Fiesta,
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{lv = Lv}} = PS,
    case lib_fiesta_data:calc_fiesta_act(RegTime, Lv) of
        {_, BeginTime0, ExpiredTime0} ->
            Fiesta;
        {_, BeginTime, ExpiredTime} ->
            Fiesta1 = Fiesta#fiesta{
                begin_time = BeginTime, expired_time = ExpiredTime
            },
            lib_fiesta_data:db_replace_fiesta(RoleId, Fiesta1),
            log_fiesta(PS, Fiesta1),
            Fiesta1;
        _ ->
            Fiesta
    end.

%% 获取可领取的祭典等级
get_can_receive_fiesta_lvs(PS) ->
    #player_status{fiesta = Fiesta} = PS,
    #fiesta{lv = CurLv} = Fiesta,
    F = fun(Lv, AccL) ->
        case lib_fiesta_check:have_received_reward(Lv, Fiesta) of
            false -> AccL;
            true -> [Lv | AccL]
        end
    end,
    Lvs = lists:foldl(F, [], lists:seq(0, CurLv)), % 兼容当前等级为0
    Lvs -- [0].

%% 获取可领取的祭典任务id
get_can_receive_fiesta_task_ids(TaskType, PS) ->
    {TaskL, _, Fiesta} = gex_task_list(TaskType, PS),
    F = fun(#fiesta_task{task_id = TaskId}, AccL) ->
        case lib_fiesta_check:is_task_reward_can_received(TaskType, TaskId, Fiesta) of
            false -> AccL;
            true -> [TaskId | AccL]
        end
    end,
    lists:foldl(F, [], TaskL).

%% 获取新的祭典任务
%% @return map()
get_fiesta_task_map(RoleId, FiestaId, TaskType) ->
    lib_fiesta_data:db_delete_fiesta_task_type(RoleId, TaskType),
    {_, TaskM} = init_fiesta_task_type(TaskType, {FiestaId, #{}}),
    lib_fiesta_data:db_replace_fiesta_task(RoleId, TaskM),
    TaskM.

%% 过期奖励发放
%% @return #player_status{}
auto_send_expired_reward(PS) ->
    #player_status{id = RoleId} = PS,
    Lvs = get_can_receive_fiesta_lvs(PS),
    {TotalReward, _, NewPS} = lists:foldl(fun get_can_receive_fiesta_rewards/2, {[], [], PS}, Lvs),
    lib_fiesta_data:send_fiesta_reward_mail(RoleId, TotalReward),
    NewPS.

%% 过期奖励数据发放
auto_send_expired_reward([], AccL) -> % 发奖励
    % 按玩家id汇总
    F0 = fun({RoleId, RewardL}, AccM) ->
        ORewardL = maps:get(RoleId, AccM, []),
        AccM#{RoleId => ORewardL++RewardL}
    end,
    UnReceivedM = lists:foldl(F0, #{}, AccL),
    % 清理数据并邮件发放奖励
    F1 = fun({RoleId, RewardL}, C) ->
        ?IF(C rem 20 == 0, timer:sleep(100), skip), % 每20个休眠一下
        lib_fiesta_data:send_fiesta_reward_mail(RoleId, RewardL),
        C+1
    end,
    lists:foldl(F1, 0, maps:to_list(UnReceivedM));
auto_send_expired_reward([[_, _, ?NORMAL_FIESTA, _, ?HAS_RECEIVE, _]|T], Acc) -> auto_send_expired_reward(T, Acc); % 普通祭典当前等级普通奖励已领取
auto_send_expired_reward([[_, _, _, _, ?HAS_RECEIVE, ?HAS_RECEIVE]|T], Acc) -> auto_send_expired_reward(T, Acc); % 高级祭典当前等级所有奖励已领取
auto_send_expired_reward([[RoleId, FiestaId, Type, Lv, Status1, _Status2]|T], Acc) ->
    #base_fiesta_lv_exp{
        reward = NormalReward,
        premium_reward = PremiumReward
    } = data_fiesta:get_base_fiesta_lv_exp(FiestaId, Lv),
    case is_premium_type(Type) of
        true ->
            Reward = ?IF(Status1 == ?NOT_RECEIVE, NormalReward++PremiumReward, PremiumReward);
        false ->
            Reward = NormalReward
    end,
    log_fiesta_reward(RoleId, FiestaId, Lv, Reward),
    auto_send_expired_reward(T, [{RoleId, Reward}|Acc]).

%%% ====================================== general memory data =====================================
%%% gex_... 在获取相关数据后为方便后续的数据更新,返回多个相关结果
%%% get_... 仅获取相关数据
%%% set_... 设置相关数据,返回新的状态数据

%% 一级数据

get_fiesta(PS) ->
    PS#player_status.fiesta.

set_fiesta(Fiesta, PS) ->
    PS#player_status{fiesta = Fiesta}.

%% 二级数据

get_begin_time(#player_status{fiesta = undefined}) -> 0;
get_begin_time(PS) -> PS#player_status.fiesta#fiesta.begin_time.

get_expired_time(#player_status{fiesta = undefined}) -> 0;
get_expired_time(PS) -> PS#player_status.fiesta#fiesta.expired_time.

get_fiesta_id(#player_status{fiesta = undefined}) -> 0;
get_fiesta_id(PS) -> PS#player_status.fiesta#fiesta.fiesta_id.

get_act_id(#player_status{fiesta = undefined}) -> 0;
get_act_id(PS) -> PS#player_status.fiesta#fiesta.act_id.

set_reward_map(RewardM, PS) ->
    #player_status{fiesta = Fiesta} = PS,
    NewFiesta = Fiesta#fiesta{reward_m = RewardM},
    set_fiesta(NewFiesta, PS).

gex_task_map(PS) ->
    #fiesta{task_m = TaskM} = Fiesta = get_fiesta(PS),
    {TaskM, Fiesta}.

get_task_map(PS) ->
    {TaskM, _} = gex_task_map(PS),
    TaskM.

set_task_map(TaskM, Fiesta, PS) ->
    NewFiesta = Fiesta#fiesta{task_m = TaskM},
    set_fiesta(NewFiesta, PS).

%% 三级数据

set_lv_reward(Lv, FiestaReward, PS) ->
    #player_status{fiesta = Fiesta} = PS,
    #fiesta{reward_m = RewardM} = Fiesta,
    NewRewardM = RewardM#{Lv => FiestaReward},
    set_reward_map(NewRewardM, PS).

gex_task_list(TaskType, PS) ->
    {TaskM, Fiesta} = gex_task_map(PS),
    TaskL = maps:get(TaskType, TaskM, []),
    {TaskL, TaskM, Fiesta}.

% get_task_list(TaskType, PS) ->
%     {TaskL, _, _} = gex_task_list(TaskType, PS),
%     TaskL.

set_task_list(TaskL, TaskType, TaskM, Fiesta, PS) ->
    NewTaskM = TaskM#{TaskType := TaskL},
    set_task_map(NewTaskM, Fiesta, PS).

%% 四级数据

gex_task(TaskType, TaskId, PS) ->
    {TaskL, TaskM, Fiesta} = gex_task_list(TaskType, PS),
    Task = ulists:keyfind(TaskId, #fiesta_task.task_id, TaskL, #fiesta_task{}),
    {Task, TaskL, TaskM, Fiesta}.

set_task(Task, TaskL, TaskType, TaskM, Fiesta, PS) ->
    NewTaskL = lists:keyreplace(Task#fiesta_task.task_id, #fiesta_task.task_id, TaskL, Task),
    set_task_list(NewTaskL, TaskType, TaskM, Fiesta, PS).

set_task(Task, TaskType, PS) ->
    {TaskL, TaskM, Fiesta} = gex_task_list(TaskType, PS),
    NewTaskL = lists:keyreplace(Task#fiesta_task.task_id, #fiesta_task.task_id, TaskL, Task),
    set_task_list(NewTaskL, TaskType, TaskM, Fiesta, PS).