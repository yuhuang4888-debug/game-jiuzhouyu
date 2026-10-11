%% ---------------------------------------------------------------------------
%% @doc lib_task_event
%% @author ming_up@foxmail.com
%% @since  2017-03-02
%% @deprecated lib_task_event
%% ---------------------------------------------------------------------------
-module(lib_task_event).

-include("common.hrl").
-include("task.hrl").
-include("predefine.hrl").
-include("boss.hrl").
-include("server.hrl").

-export([
        finish/2
        , finish/3
        , after_finish/3
        , after_finish_help/2
        , after_trigger/2
        , after_trigger_help/2
    ]).



finish(PS, TaskId) ->
    case data_magic_circle:get_value_by_key(task_id) of
        [MagicTaskId] ->
            ok;
        _ ->
            MagicTaskId = 0
    end,
    if
        TaskId == MagicTaskId ->
            NewPs = lib_magic_circle:finish(PS);  %%魔法阵特殊处理;
        true ->
            NewPs = PS
    end,
    lib_task_api:fin_task(NewPs, TaskId),
    lib_eudemons_land:fin_task(NewPs, TaskId),
    lib_boss_first_blood_plus:fin_task(NewPs, TaskId),
    PS1 = lib_module_open:fin_task(NewPs, TaskId),
    {ok, PS2} = lib_skill:auto_learn_skill(PS1, {task_id, TaskId}),
    {ok, LastPs} = lib_temple_awaken_api:trigger_finish_task(PS2, TaskId),
    LastPs.
finish(PS, _TaskId, _Kind) ->
    PS.

%% 任务进程
after_finish(TaskArgs, RT, TaskId) when is_record(TaskArgs, task_args) ->
    lib_player:apply_cast(TaskArgs#task_args.id, ?APPLY_CAST_SAVE, ?MODULE, after_finish, [RT, TaskId]);
after_finish(PS, RT, TaskId) ->
    IsDoTaskDrop = lib_task_drop_api:is_do_task_drop(TaskId),
    IsDoDunLearn = lib_dungeon_learn_skill:is_do_dungeon_learn_skill(TaskId),
    IsDoTaskMap = lib_task_map_api:is_do_task_map(TaskId),
    PSTmp = cost_special(PS, TaskId),
    #role_task{trigger_time = TriggerTime} = RT,
    NowTime = utime:unixtime(),
    ta_agent_fire:task_completed(PSTmp, NowTime, [TaskId, 2, max(NowTime - TriggerTime, 0), 0]),
    case IsDoTaskDrop orelse IsDoDunLearn orelse IsDoTaskMap of
        true -> after_finish_help(PSTmp, TaskId);
        _ -> {ok, PSTmp}
    end.

%% 玩家进程(只有部分任务id才触发)
after_finish_help(Player, TaskId) ->
    DropPlayer = case lib_task_drop_api:is_do_task_drop(TaskId) of
        true -> lib_task_drop_api:finish_task(Player, TaskId);
        false -> Player
    end,
    {ok, DunPlayer} = case lib_dungeon_learn_skill:is_do_dungeon_learn_skill(TaskId) of
        true -> lib_dungeon_learn_skill:finish_task(DropPlayer, TaskId);
        false -> {ok, DropPlayer}
    end,
    TaskMapPlayer = case lib_task_map_api:is_do_task_map(TaskId) of
        true -> lib_task_map_api:finish_task(DunPlayer, TaskId);
        false -> DunPlayer
    end,
    {ok, TaskMapPlayer}.

%% 任务进程
after_trigger(TaskArgs, Task) when is_record(TaskArgs, task_args) ->
    lib_player:apply_cast(TaskArgs#task_args.id, ?APPLY_CAST_SAVE, ?MODULE, after_trigger, [Task]);
after_trigger(PS, Task) ->
    IsDoTaskDrop = lib_task_drop_api:is_do_task_drop(Task#task.id),
    IsDoTaskMap = lib_task_map_api:is_do_task_map(Task#task.id),
    IsSuitCltTask = lib_suit_collect_api:is_suit_clt_task(Task),
    IsSpecialTask = is_special_task_id(Task#task.id),
    ta_agent_fire:task_completed(PS, 0, [Task#task.id, 1, 0, 0]),
    case IsDoTaskDrop orelse IsDoTaskMap orelse IsSuitCltTask orelse IsSpecialTask of
        true -> after_trigger_help(PS, Task);
        false -> {ok, PS}
    end.

%% 玩家进程(只有部分任务id才触发)
after_trigger_help(Player, Task) ->
    TaskId = Task#task.id,
    DropPlayer = case lib_task_drop_api:is_do_task_drop(TaskId) of
        true -> lib_task_drop_api:trigger_task(Player, TaskId);
        false -> Player
    end,
    TaskMapPlayer = case lib_task_map_api:is_do_task_map(TaskId) of
        true -> lib_task_map_api:trigger_task(DropPlayer, TaskId);
        false -> DropPlayer
    end,
    IsSuitCltTask = lib_suit_collect_api:is_suit_clt_task(Task),
    SuitCltPlayer = case IsSuitCltTask of
        true -> lib_suit_collect_api:trigger_task(TaskMapPlayer);
        _ -> TaskMapPlayer
    end,
    IsSpecialTask = is_special_task_id(TaskId),
    case IsSpecialTask of
        _ when TaskId == 101211 ->
            LastPlayer = lib_afk:after_trigger_main_task(SuitCltPlayer);
        true ->
            {BossType, BossId, Scene} = get_special_task_boss_info(TaskId),
            %catch whereis(mod_special_boss) ! {'boss_reborn_on_scene', Player#player_status.id, BossType, BossId},
            %catch whereis(mod_special_boss) ! {'boss_remind', Player#player_status.id, BossType, BossId}
            mod_special_boss:refresh_boss_one(BossType, BossId, Player#player_status.id, Scene),
            pp_boss:handle(46000, SuitCltPlayer, [?BOSS_TYPE_WORLD_PER]),
            LastPlayer = SuitCltPlayer;
        _ ->
            LastPlayer = SuitCltPlayer
    end,
    {ok, LastPlayer}.

%% 特殊任务ID接到该任务之后触发复活某个Boss(防止卡进度流程)
is_special_task_id(TaskId) ->
    TaskId == 101485 orelse TaskId == 101705 orelse TaskId == 101211.

get_special_task_boss_info(101485) ->
    {?BOSS_TYPE_WORLD_PER, 5600102, 56001};
get_special_task_boss_info(101705) ->
    {?BOSS_TYPE_WORLD_PER, 5600105, 56001}.

% 客户端没空处理新增类型，临时处理
cost_special(PS, TaskId) ->
    case is_cost_special(TaskId) of
        {true, GoodsTypeId, NeedNum} ->
            [{GoodsTypeId, GoodsNum}] = lib_goods_api:get_goods_num(PS, [GoodsTypeId]),
            case GoodsNum == 0 of
                true -> PS;
                _ ->
                    Cost = [{?TYPE_GOODS, GoodsTypeId, min(NeedNum, GoodsNum)}],
                    case lib_goods_api:cost_object_list_with_check(PS, Cost, task_stuff, lists:concat(["TaskId:", TaskId])) of
                        {true, NewPS} -> NewPS;
                        _ -> PS
                    end
            end;
        _ ->
            PS
    end.

is_cost_special(TaskId) ->
    case data_task:get(TaskId) of
        #task{content = TaskContent} ->
            is_cost_special_core(TaskId, TaskContent);
        _ ->
            false
    end.

is_cost_special_core(_TaskId, []) -> false;
is_cost_special_core(TaskId, [{C, T}|H]) ->
    case data_task:get_content(TaskId, C, T) of
        #task_content{ctype = ?TASK_CONTENT_ITEM2, id = CostId, need_num = NeedNum} -> {true, CostId, NeedNum};
        _ -> is_cost_special_core(TaskId, H)
    end.
