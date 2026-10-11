%% ---------------------------------------------------------------------------
%% @doc lib_task_drop_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-01-02
%% @deprecated 任务掉落接口
%% ---------------------------------------------------------------------------

-module(lib_task_drop_api).
-compile(export_all).

-include("server.hrl").
-include("common.hrl").

%% 任务触发或者完成是否要触发[任务模块使用]
is_do_task_drop(TaskId) ->
    TaskIdL = data_task_drop:get_task_id_list(),
    FuncTaskIdL = data_task_drop:get_task_func_task_id_list(),
    TaskStageL = data_task_drop:get_task_func_task_stage_list(),
    lists:member(TaskId, TaskIdL++FuncTaskIdL) orelse lists:keymember(TaskId, 1, TaskStageL).

%% 任务触发或者完成是否要触发
is_do_task_stage_drop(TaskId, Stage) ->
    TaskStageL = data_task_drop:get_task_func_task_stage_list(),
    lists:member({TaskId, Stage}, TaskStageL).

%% 完成任务
finish_task(#player_status{drop_task_id_list = DropTaskIdL, drop_task_stage_list = TaskStageL} = Player, TaskId) ->
    NewTaskStageL = [{TmpTaskId, TmpStage}||{TmpTaskId, TmpStage}<-TaskStageL, TmpTaskId=/=TaskId],
    Player#player_status{drop_task_id_list = lists:delete(TaskId, DropTaskIdL), drop_task_stage_list = NewTaskStageL}.

%% 触发任务
trigger_task(#player_status{drop_task_id_list = DropTaskIdL, drop_task_stage_list = TaskStageL} = Player, TaskId) ->
    NewTaskStageL = [{TmpTaskId, TmpStage}||{TmpTaskId, TmpStage}<-TaskStageL, TmpTaskId=/=TaskId],
    case is_do_task_stage_drop(TaskId, 0) of
        true -> NewTaskStageL2 = [{TaskId, 0}|NewTaskStageL];
        false -> NewTaskStageL2 = NewTaskStageL
    end,
    Player#player_status{drop_task_id_list = [TaskId|lists:delete(TaskId, DropTaskIdL)], drop_task_stage_list = NewTaskStageL2}.

%% 完成
action_one_finish(#player_status{drop_task_stage_list = TaskStageL} = Player, TaskId, _Stage) ->
    % ?MYLOG("hjhdrop2", "action_one_finish  TaskId:~p, _Stage:~p ~n", [TaskId, _Stage]),
    NewTaskStageL = [{TmpTaskId, TmpStage}||{TmpTaskId, TmpStage}<-TaskStageL, TmpTaskId=/=TaskId],
    Player#player_status{drop_task_stage_list = NewTaskStageL}.

%% 触发阶段任务
action_one(#player_status{drop_task_stage_list = TaskStageL} = Player, TaskId, Stage) ->
    % ?MYLOG("hjhdrop2", "action_one  TaskId:~p, Stage:~p ~n", [TaskId, Stage]),
    Player#player_status{drop_task_stage_list = [{TaskId, Stage}|lists:delete({TaskId, Stage}, TaskStageL)]}.

%% 功能任务掉落
get_task_func_reward(Player, Type) ->
    lib_task_drop:get_task_func_reward(Player, Type).