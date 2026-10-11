%% ---------------------------------------------------------------------------
%% @doc lib_task_map_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-05-20
%% @deprecated 特殊任务存储Map
%% ---------------------------------------------------------------------------

-module(lib_task_map_api).
-compile(export_all).

-include("server.hrl").
-include("common.hrl").
-include("task.hrl").
-include("team.hrl").

%% 任务触发或者完成是否要触发
is_do_task_map(TaskId) ->
    TaskIdL = lib_task_map:get_cfg_trigger_task_id_list(),
    lists:member(TaskId, TaskIdL).

%% 完成任务
finish_task(#player_status{id = RoleId, task_map = TaskMap, team = #status_team{team_id=TeamId}} = Player, TaskId) ->
    % 触发的完成后删除数据
    TriTaskIdL = lib_task_map:get_cfg_trigger_task_id_list(),
    case lists:member(TaskId, TriTaskIdL) of
        true -> 
            if
                TeamId > 0 -> mod_team:cast_to_team(TeamId, {'update_team_mb', RoleId, [{task_id, TaskId, ?TASK_STATE_FIN}]});
                true -> skip
            end,
            NewTaskMap = maps:remove(TaskId, TaskMap);
        false -> 
            NewTaskMap = TaskMap
    end,
    Player#player_status{task_map = NewTaskMap}.

%% 触发任务
trigger_task(#player_status{id = RoleId, task_map = TaskMap, team = #status_team{team_id=TeamId}} = Player, TaskId) ->
    TriTaskIdL = lib_task_map:get_cfg_trigger_task_id_list(),
    case lists:member(TaskId, TriTaskIdL) of
        true -> 
            if
                TeamId >0 -> mod_team:cast_to_team(TeamId, {'update_team_mb', RoleId, [{task_id, TaskId, ?TASK_STATE_TRIGGER}]});
                true -> skip
            end,
            NewTaskMap = maps:put(TaskId, ?TASK_STATE_TRIGGER, TaskMap);
        false -> 
            NewTaskMap = TaskMap
    end,
    Player#player_status{task_map = NewTaskMap}.
