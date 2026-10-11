%% ---------------------------------------------------------------------------
%% @doc lib_grow_welfare

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/2/16 0016
%% @desc    成长福利
%% ---------------------------------------------------------------------------
-module(lib_grow_welfare).

-export([
    login/1                             % 登录
    , send_grow_welfare_process/1       % 发送成长福利信息
    , receive_grow_welfare/2            % 领取成长福利奖励
    , auto_trigger/1                    % 登录后自动触发，防止策划改动和兼容和兼容老号任务进度问题
    , trigger_task/2                    % 任务进度触发
    , gm_finish_all/1                   % 秘籍快速完成任务
]).

-include("common.hrl").
-include("server.hrl").
-include("welfare.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("equip_suit.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("seal.hrl").

%% 登录
login(RoleId) ->
    TaskList = init_task_list(RoleId),
    #status_grow_welfare{task_list = TaskList}.

init_task_list(RoleId) ->
    Sql = io_lib:format(?sql_select_grow_welfare, [RoleId]),
    DbTaskL = db:get_all(Sql),
    TaskIds = data_welfare:list_grow_welfare_task(),
    DefaultTaskL = [#grow_welfare_task{task_id = TaskId}||TaskId<-TaskIds],
    F = fun([TaskId, Process, Status], AccL) ->
        TaskItem = #grow_welfare_task{task_id = TaskId, process = Process, status = Status},
        lists:keystore(TaskId, #grow_welfare_task.task_id, AccL, TaskItem)
    end,
    lists:foldl(F, DefaultTaskL, DbTaskL).

%% 发送任务进度
send_grow_welfare_process(PS) ->
    #player_status{grow_welfare = StatusGrowWelfare, id = RoleId} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    F = fun(TaskItem, AccL) ->
        #grow_welfare_task{task_id = TaskId, process = Process, status = Status} = TaskItem,
        if
            % 没进度的数据没必要发给客户端，节省网络包
            Status == ?GROW_WELFARE_CANT_RECEIVE, Process == 0 ->
                AccL;
            true ->
                [{TaskId, Process, Status}|AccL]
        end
    end,
    SendL = lists:foldl(F, [], TaskList),
    %?PRINT("=======41720 TaskList ~p ~n", [TaskList]),
    %?PRINT("=======41720 SendL ~p ~n", [SendL]),
    lib_server_send:send_to_uid(RoleId, pt_417, 41720, [SendL]).

%% 领取奖励
receive_grow_welfare(PS, TaskId) ->
    case check_receive_grow_welfare(PS, TaskId) of
        {true, TaskItem} ->
            do_receive_grow_welfare(PS, TaskItem);
        ErrResult ->
            ErrResult
    end.

check_receive_grow_welfare(PS, TaskId) ->
    #player_status{grow_welfare = StatusGrowWelfare} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    case lists:keyfind(TaskId, #grow_welfare_task.task_id, TaskList) of
        #grow_welfare_task{status = ?GROW_WELFARE_CAN_RECEIVE} = TaskItem ->
            % LogDay = lib_player_login_day:get_player_login_days(PS),
            case data_welfare:get_grow_welfare(TaskId) of
                #base_grow_welfare_info{} ->
                    {true, TaskItem};
                _ ->
                    {false, ?MISSING_CONFIG}
            end;
        #grow_welfare_task{status = ?GROW_WELFARE_HAD_RECEIVE} ->
            {false, ?ERRCODE(err138_had_reward)};
        _ ->
            {false, ?ERRCODE(err175_can_not_get)}
    end.

do_receive_grow_welfare(PS, TaskItem) ->
    #player_status{grow_welfare = StatusGrowWelfare, id = RoleId, figure = #figure{ name = PlayerName }} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    #grow_welfare_task{task_id = TaskId} = TaskItem,
    NewTaskItem = TaskItem#grow_welfare_task{status = ?GROW_WELFARE_HAD_RECEIVE},
    NewTaskList = lists:keystore(TaskId, #grow_welfare_task.task_id, TaskList, NewTaskItem),
    NewStatusGrowWelfare = StatusGrowWelfare#status_grow_welfare{task_list = NewTaskList},
    NewPS = PS#player_status{grow_welfare = NewStatusGrowWelfare},
    db_save_task_info(RoleId, NewTaskItem),
    log_grow_welfare_task_process(RoleId, NewTaskItem),
    #base_grow_welfare_info{reward = Reward} = data_welfare:get_grow_welfare(TaskId),
    Produce = #produce{type = grow_welfare, reward = Reward, show_tips = ?SHOW_TIPS_1},
    LastPS = lib_goods_api:send_reward(NewPS, Produce),
    lib_log_api:log_combat_welfare_reward_info(RoleId, PlayerName, 0, TaskId, Reward),
    {true, LastPS}.

%% 自动触发
auto_trigger(PS) ->
    #player_status{grow_welfare = StatusGrowWelfare, id = RoleId} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    ChangeTaskL = auto_trigger_task_core(PS, TaskList),
    notify_client_change(RoleId, ChangeTaskL),
    db_save_task_change(RoleId, ChangeTaskL),
    F = fun(TaskItem, AccTaskL) ->
        #grow_welfare_task{task_id = TaskId} = TaskItem,
        log_grow_welfare_task_process(RoleId, TaskItem),
        lists:keystore(TaskId, #grow_welfare_task.task_id, AccTaskL, TaskItem)
    end,
    NewTaskList = lists:foldl(F, TaskList, ChangeTaskL),
    NewStatusGrowWelfare = StatusGrowWelfare#status_grow_welfare{task_list = NewTaskList},
    PS#player_status{grow_welfare = NewStatusGrowWelfare}.

auto_trigger_task_core(PS, TaskList) ->
    F = fun(TaskItem, AccChangeL) ->
        #grow_welfare_task{status = Status, task_id = TaskId} = TaskItem,
        case data_welfare:get_grow_welfare(TaskId) of
            #base_grow_welfare_info{condition = Condition} when Status == ?GROW_WELFARE_CANT_RECEIVE ->
                {NewTaskItem, IsChange} = do_trigger(PS, TaskItem, Condition, auto_trigger),
                ?IF(IsChange, [NewTaskItem|AccChangeL], AccChangeL);
            _ ->
                AccChangeL
        end
    end,
    lists:foldl(F, [], TaskList).

%% 触发任务进度
trigger_task(PS, Args) ->
    #player_status{grow_welfare = StatusGrowWelfare, id = RoleId} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    ChangeTaskL = trigger_task_core(PS, TaskList, Args),
    notify_client_change(RoleId, ChangeTaskL),
    db_save_task_change(RoleId, ChangeTaskL),
    F = fun(TaskItem, AccTaskL) ->
        #grow_welfare_task{task_id = TaskId} = TaskItem,
        log_grow_welfare_task_process(RoleId, TaskItem),
        lists:keystore(TaskId, #grow_welfare_task.task_id, AccTaskL, TaskItem)
    end,
    NewTaskList = lists:foldl(F, TaskList, ChangeTaskL),
    NewStatusGrowWelfare = StatusGrowWelfare#status_grow_welfare{task_list = NewTaskList},
    PS#player_status{grow_welfare = NewStatusGrowWelfare}.

trigger_task_core(PS, TaskList, Args) ->
    F = fun(TaskItem, AccChangeL) ->
        #grow_welfare_task{status = Status, task_id = TaskId} = TaskItem,
        case data_welfare:get_grow_welfare(TaskId) of
            #base_grow_welfare_info{condition = Condition} when Status == ?GROW_WELFARE_CANT_RECEIVE ->
                {NewTaskItem, IsChange} = do_trigger(PS, TaskItem, Condition, Args),
                ?IF(IsChange, [NewTaskItem|AccChangeL], AccChangeL);
            _ ->
                AccChangeL
        end
    end,
    lists:foldl(F, [], TaskList).

%% 通知客户端任务进度更改
notify_client_change(_RoleId, []) -> skip;
notify_client_change(RoleId, TaskList) ->
    SendL = [{TaskId, Process, Status}||#grow_welfare_task{task_id = TaskId, process = Process, status = Status} <- TaskList],
    lib_server_send:send_to_uid(RoleId, pt_417, 41721, [SendL]).

%% 持久化任务进度数据
db_save_task_change(_RoleId, []) -> skip;
db_save_task_change(RoleId, TaskList) ->
    F = fun(#grow_welfare_task{task_id = TaskId, process = Process, status = Status}, AccParams) ->
        [[RoleId, TaskId, Process, Status]|AccParams]
    end,
    ReplaceParams = lists:foldl(F, [], TaskList),
    Sql = usql:replace(role_grow_welfare_task, [role_id, task_id, process, status], ReplaceParams),
    db:execute(Sql).

%% 触发逻辑
%% 完成N转
do_trigger(PS, TaskItem, {turn, NeedTurn}, auto_trigger) ->
    #player_status{figure = #figure{turn = Turn}} = PS,
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedTurn, Turn),
    {NewTaskItem, true};
do_trigger(_PS, TaskItem, {turn, NeedTurn}, {turn, Turn}) ->
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedTurn, Turn),
    {NewTaskItem, true};
%% 加入公会
do_trigger(#player_status{guild = #status_guild{id = GuildId}}, TaskItem,
        {join_guild, 1}, auto_trigger) when GuildId =/= 0 ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, 1, 1),
    {NewTaskItem, true};
do_trigger(_PS, TaskItem, {join_guild, NeedNum}, {join_guild, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 完成XX类型副本
do_trigger(_PS, TaskItem, {dun_type, DunType, NeedNum}, {dun_type, DunType, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};

%% 完成XX副本
do_trigger(PS, TaskItem, {dun_id, DunId, 1}, auto_trigger) ->
    case lib_dungeon_api:check_ever_finish(PS, DunId) of
        true ->
            NewTaskItem = do_trigger_calc_cum_process(TaskItem, 1, 1),
            {NewTaskItem, true};
        _ ->
            {TaskItem, false}
    end;
do_trigger(_PS, TaskItem, {dun_id, DunId, NeedNum}, {dun_id, DunId, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参加午间派对
do_trigger(_PS, TaskItem, {enter_midday_party, NeedNum}, {enter_midday_party, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参加结社晚宴
do_trigger(_PS, TaskItem, {enter_guild_feast, NeedNum}, {enter_guild_feast, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参与圣域夺宝(领地夺宝)
do_trigger(_PS, TaskItem, {enter_territory, NeedNum}, {enter_territory, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参与九魂妖塔
do_trigger(_PS, TaskItem, {enter_nine, NeedNum}, {enter_nine, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参与尊神战场(圣灵战场)
do_trigger(_PS, TaskItem, {enter_holy_spirit, NeedNum}, {enter_holy_spirit, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 参与巅峰竞技
do_trigger(_PS, TaskItem, {enter_top_pk, NeedNum}, {enter_top_pk, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 击杀XX类型大妖
do_trigger(_PS, TaskItem, {boss_type, BossType, NeedNum}, {boss_type, BossType, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 登录天数
do_trigger(PS, TaskItem, {login_day, NeedNum}, auto_trigger) ->
    Day = lib_player_login_day:get_player_login_days(PS),
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedNum, Day),
    {NewTaskItem, true};
do_trigger(_PS, TaskItem, {login_day, NeedNum}, {login_day, Num}) ->
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 进行分享
do_trigger(_PS, TaskItem, {share_game, NeedNum}, {share_game, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 发布征婚
do_trigger(_PS, TaskItem, {release_dating, NeedNum}, {release_dating, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 升级船只
do_trigger(_PS, TaskItem, {level_up_ship, NeedNum}, {level_up_ship, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 领取巡航奖励
do_trigger(_PS, TaskItem, {receive_ship_reward, NeedNum}, {receive_ship_reward, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 进行洗练
do_trigger(_PS, TaskItem, {equip_wash, NeedNum}, {equip_wash, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 协助玩家
do_trigger(_PS, TaskItem, {assist_role, NeedNum}, {assist_role, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};
%% 激活了X类型套装的N阶M件套
do_trigger(_PS, TaskItem, {equip_suit, SuitType, NeedStage, NeedNum}, auto_trigger) ->
    #goods_status{equip_suit_state = EquipSuitState} = lib_goods_do:get_goods_status(),
    do_trigger(_PS, TaskItem, {equip_suit, SuitType, NeedStage, NeedNum}, {equip_suit, EquipSuitState});
do_trigger(_PS, TaskItem, {equip_suit, SuitType, NeedStage, NeedNum}, {equip_suit, EquipSuitState}) ->
    % 过滤特定类型的套装状态
    Num = lists:foldl(
        fun(State, AccNum) -> #suit_state{key = {Type, _, Stage}, count = Count} = State,
            case Type =:= SuitType andalso Stage >= NeedStage of
                true -> AccNum + Count;
                _ -> AccNum
            end
        end, 0, EquipSuitState),
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};

%% 装备合成，合成A件W阶S颜色L星数的装备
do_trigger(_PS, TaskItem, {compose_equip, NeedStage, NeedColor, NeedStar, NeedNum}, {compose_equip, GoodsInfoList}) ->
    F = fun(GoodsInfo, GrandNum) ->
        #goods{color = Color, goods_id = GoodsTypeId} = GoodsInfo,
        EquipStage = lib_equip:get_equip_stage(GoodsTypeId),
        EquipStar = lib_equip:get_equip_star(GoodsTypeId),
        IsSatisfy = Color >= NeedColor andalso EquipStage >= NeedStage andalso EquipStar >= NeedStar,
        ?IF(IsSatisfy, GrandNum + 1, GrandNum)
    end,
    Num = lists:foldl(F, 0, GoodsInfoList),
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};

%% 圣印情况
do_trigger(PS, TaskItem, {seal_status, _NeedColor, _NeedStage, _NeedNum} = C, auto_trigger) ->
    SealEquipList = PS#player_status.seal_status#seal_status.equip_list,
    GoodsStatus = lib_goods_do:get_goods_status(),
    SealList = [lib_goods_api:get_goods_info(EqSealId, GoodsStatus)||{_, EqSealId, _}<-SealEquipList],
    do_trigger(PS, TaskItem, C, {seal_status, SealList});
do_trigger(_PS, TaskItem, {seal_status, NeedColor, NeedStage, NeedNum}, {seal_status, SealList}) ->
    F = fun(GoodsInfo, GrandNum) ->
        case GoodsInfo of
            #goods{goods_id = SealId} ->
                case data_seal:get_seal_equip_info(SealId) of
                    #base_seal_equip{stage = Stage, color = Color} when Stage >= NeedStage andalso Color >= NeedColor ->
                        GrandNum + 1;
                    _ -> GrandNum
                end;
            _ -> GrandNum
        end
        end,
    RealNum = lists:foldl(F, 0, SealList),
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedNum, RealNum),
    {NewTaskItem, true};

%% 参与周一大奖
do_trigger(_PS, TaskItem, {bonus_monday, NeedNum}, {bonus_monday, Num}) ->
    NewTaskItem = do_trigger_calc_cum_process(TaskItem, NeedNum, Num),
    {NewTaskItem, true};

%% 寻找一名伴侣完成结婚
do_trigger(PS, TaskItem, {is_marriage, NeedValue}, auto_trigger) ->
    PsValue = ?IF( lib_marriage:is_marriage(PS), 1, 0),
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedValue, PsValue),
    {NewTaskItem, true};
do_trigger(_PS, TaskItem, {is_marriage, NeedValue}, {marriage, Marriage}) ->
    NewTaskItem = do_trigger_calc_need_process(TaskItem, NeedValue, Marriage),
    {NewTaskItem, true};

do_trigger(_PS, TaskItem, _Condition, _) ->
    {TaskItem, false}.

do_trigger_calc_cum_process(TaskItem, NeedNum, Num) ->
    #grow_welfare_task{process = Process, status = OldStatus} = TaskItem,
    NewProcess = Process + Num,
    Status = ?IF(NewProcess >= NeedNum, ?GROW_WELFARE_CAN_RECEIVE, OldStatus),
    TaskItem#grow_welfare_task{process = NewProcess, status = Status}.

do_trigger_calc_need_process(TaskItem, NeedNum, Num) ->
    #grow_welfare_task{status = OldStatus} = TaskItem,
    Status = ?IF(Num >= NeedNum, ?GROW_WELFARE_CAN_RECEIVE, OldStatus),
    TaskItem#grow_welfare_task{process = Num, status = Status}.

gm_finish_all(PS) ->
    #player_status{grow_welfare = StatusGrowWelfare, id = RoleId} = PS,
    #status_grow_welfare{task_list = TaskList} = StatusGrowWelfare,
    F = fun(TaskItem) ->
        case TaskItem of
            #grow_welfare_task{status = ?GROW_WELFARE_CANT_RECEIVE} ->
                TaskItem#grow_welfare_task{status = ?GROW_WELFARE_CAN_RECEIVE, process = 1};
            _ ->
                TaskItem
        end
    end,
    NewTaskList = lists:map(F, TaskList),
    notify_client_change(RoleId, NewTaskList),
    db_save_task_change(RoleId, NewTaskList),
    NewStatusGrowWelfare = StatusGrowWelfare#status_grow_welfare{task_list = NewTaskList},
    PS#player_status{grow_welfare = NewStatusGrowWelfare}.

%% =========================== Inner =================================

db_save_task_info(RoleId, TaskItem) ->
    #grow_welfare_task{task_id = TaskId, process = Process, status = Status} = TaskItem,
    Sql = io_lib:format(?sql_replace_grow_welfare, [RoleId, TaskId, Process, Status]),
    db:execute(Sql).

log_grow_welfare_task_process(RoleId, TaskItem) ->
    #grow_welfare_task{task_id = TaskId, process = Process, status = Status} = TaskItem,
    lib_log_api:log_grow_welfare_task_process(RoleId, TaskId, Process, Status).


