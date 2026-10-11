%% ---------------------------------------------------------------------------
%% @doc 任务map.

%% @author hjh
%% @since  2020-05-20
%% @deprecated  特殊任务存储Map
%% ---------------------------------------------------------------------------
-module(lib_task_map).

-compile(export_all).

-include("task.hrl").
-include("server.hrl").

%% 触发任务id列表
get_cfg_trigger_task_id_list() -> 
    data_team_m:get_trigger_task_id_list().

%% 任务关键map, #{task_id => 0,1,2}
%% 0:无;1:触发;2完成
login(#player_status{tid = TaskPid} = Player) ->
    TaskIdL = get_cfg_trigger_task_id_list(),
    TriTaskIdL = mod_task:get_trigger_task_id_list(TaskPid, TaskIdL),
    F = fun(TaskId, TaskMap) -> maps:put(TaskId, ?TASK_STATE_TRIGGER, TaskMap) end,
    TaskMap = lists:foldl(F, #{}, TriTaskIdL),
    Player#player_status{task_map = TaskMap}.
