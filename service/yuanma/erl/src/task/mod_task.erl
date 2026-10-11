%% ---------------------------------------------------------------------------
%% @doc mod_task
%% @author ming_up@foxmail.com
%% @since  2016-11-19
%% @deprecated  玩家任务进程
%% ---------------------------------------------------------------------------
-module(mod_task).
-export([start_link/1, stop/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("def_module.hrl").
-include("daily.hrl").
-include("def_fun.hrl").

%% 开启任务进程
start_link(TaskArgs) ->
    gen_server:start_link(?MODULE, [TaskArgs], []).

%% ================================= call =================================
%% 获取任务的是否完成
get_task_finish_state(Tid, TaskId, TaskArgs) ->
    gen_server:call(Tid, {get_task_finish_state, [TaskId, TaskArgs]}).

%% 强制触发任务
force_trigger(Tid, TaskId, TaskArgs) ->
    gen_server:call(Tid, {force_trigger, [TaskId, TaskArgs]}).

%% 强制移除任务
del_task(Tid, TaskId, TaskArgs) ->
    gen_server:call(Tid, {del_task, [TaskId, TaskArgs]}).

%% 完成对应等级的任务
finish_lv_task(Tid, TaskArgs, Type, MainTaskId) ->
    gen_server:call(Tid, {finish_lv_task, TaskArgs, Type, MainTaskId}).

%% npc任务状态
get_npc_state(NpcId, PS) ->
    gen_server:call(PS#player_status.tid, {get_npc_state, [NpcId, PS]}).

%% 获取npc任务
get_npc_task_list(Tid, NpcId, TaskArgs)->
    gen_server:call(Tid, {get_npc_task_list, [NpcId, TaskArgs]}).

%% 获取当前npc任务对话
get_npc_task_talk_id(Tid, TaskId, NpcId, TaskArgs) ->
    gen_server:call(Tid, {get_npc_task_talk_id, [TaskId, NpcId, TaskArgs]}).

%% 检查物品是否为任务需要
can_gain_item(Tid) ->
    gen_server:call(Tid, {can_gain_item, []}).

%% 触发任务
trigger(Tid, TaskId, TaskArgs) ->
    gen_server:call(Tid, {trigger, [TaskId, TaskArgs]}).

%% 放弃任务
abnegate(Tid, TaskId, TaskArgs) ->
    gen_server:call(Tid, {abnegate, [TaskId, TaskArgs]}).

%% 完成任务并且获得奖励
finish(Tid, TaskId, ParamList, TaskArgs) ->
    gen_server:call(Tid, {finish, [TaskId, ParamList, TaskArgs]}).

%% 秘籍完成任务并且获得奖励
gm_finish(Tid, TaskId, ParamList, TaskArgs) ->
    gen_server:call(Tid, {gm_finish, [TaskId, ParamList, TaskArgs]}).

%% 是否完成某个任务
is_finish_task_id(Tid, TaskId) ->
    gen_server:call(Tid, {is_finish_task_id, [TaskId]}, 500).

%% 是否完成某些任务
is_finish_task_ids(Tid, TaskIds) ->
    gen_server:call(Tid, {is_finish_task_ids, [TaskIds]}, 500).

%% 根据任务ID列表,获得已经完成的任务id列表
%% @return [TaskId,..]
get_finish_task_id_list(Tid, TaskIdL) ->
    gen_server:call(Tid, {get_finish_task_id_list, [TaskIdL]}, 500).

%% 根据任务ID列表,获得已经完成的任务id列表
%% @return [TaskId,..]
get_finish_task_id_list(RoleId, Tid, TaskIdL) ->
    % List = lib_task:get_finish_task_id_list_on_db(RoleId, TaskIdL),
    % ?INFO("List:~p ~n", [List]),
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> get_finish_task_id_list(Tid, TaskIdL);
        _ -> lib_task:get_finish_task_id_list_on_db(RoleId, TaskIdL)
    end.

%% 是否领取了指定的任务ID:是:true 否:false
is_trigger_task_id(Tid, TaskId) ->
    gen_server:call(Tid, {is_trigger_task_id, [TaskId]}, 500).

%% 根据任务ID列表,获得在领取的任务列表
%% @return [TaskId,..]
get_trigger_task_id_list(Tid, TaskIdL) ->
    gen_server:call(Tid, {get_trigger_task_id_list, [TaskIdL]}, 500).

%% 根据任务阶段列表,获得在领取的任务列表
%% @return [{TaskId, Stage},..]
get_trigger_task_stage_list(Tid, TaskStageL) ->
    gen_server:call(Tid, {get_trigger_task_stage_list, [TaskStageL]}, 500).

%% 检查是否能消耗
check_cost_stuff(Tid, TaskId, GoodsTypeId, Num) ->
    gen_server:call(Tid, {check_cost_stuff, [TaskId, GoodsTypeId, Num]}, 500).

finish_eudemonstask(Tid, TaskId, ParamList, TaskArgs) ->
    gen_server:call(Tid, {finish_eudemonstask, [TaskId, ParamList, TaskArgs]}).

%% ================================= cast =================================
%% 停止任务进程
stop(Pid) when is_pid(Pid) ->
    gen_server:cast(Pid, stop).

%% 重连
relogin(#player_status{tid = Tid} = Player) ->
    gen_server:cast(Tid, {'relogin', lib_task_api:ps2task_args(Player)}).

%% 获取玩家自己的任务列表
get_my_task_list(Tid, TaskArgs) ->
    gen_server:cast(Tid, {get_my_task_list, [TaskArgs]}).

%% 刷线npc
refresh_npc_ico(Tid, TaskArgs) ->
    gen_server:cast(Tid, {refresh_npc_ico, [TaskArgs]}).

%% 完成任务过程
event(Event, Params, Id)->
    case lib_player:get_online_info(Id) of
        [] ->
            RolePid = misc:get_player_process(Id),
            gen_server:cast(RolePid, {'trigger_task_special', Event, Params, Id}),
            [];
        P  ->
            gen_server:cast(P#ets_online.tid, {action, [Id, Event, Params]})
    end.
event(Tid, Event, Params, Id) ->
    gen_server:cast(Tid, {action, [Id, Event, Params]}).

event(Tid, TaskId, Event, Params, Id) ->
    gen_server:cast(Tid, {action, [TaskId, Id, Event, Params]}).

%% 玩家升级触发任务
lv_up(Tid, TaskArgs) ->
    gen_server:cast(Tid, {lv_up, [TaskArgs]}).

%% 清理可接任务
gm_refresh_task(Tid, GmType, TaskArgs) ->
    gen_server:cast(Tid, {gm_refresh_task, [GmType, TaskArgs]}).

%% 每日清理
each_daily_clear(Tid, TaskArgs, Time) ->
    gen_server:cast(Tid, {'each_daily_clear', TaskArgs, Time}).

%% 任务物品掉落
send_drop_goods(Tid, Goods, TaskArgs)->
    gen_server:cast(Tid, {'send_drop_goods', Goods, TaskArgs}).

%% 获取任务奖励
get_special_task_reward(Tid, TaskId, RoleId, Type)->
    gen_server:cast(Tid, {get_special_task_reward, [TaskId, Type, RoleId]}).

%% 触发赏金任务和公会周任务
trigger_type_task(Tid, TaskType, TaskArgs) ->
    gen_server:cast(Tid, {'trigger_type_task', TaskType, TaskArgs}).

%% 扫荡公会任务和赏金任务
sweep_get_special_task_reward(Tid, TaskType, RoleId, Lv, Ps) ->
    gen_server:cast(Tid, {sweep_get_special_task_reward, [TaskType, RoleId, Lv, Ps]}).

test_error(Tid, A, B) ->
    gen_server:cast(Tid, {test, A, B}).

test_error_call(Tid, A, B) ->
    gen_server:call(Tid, {test, A, B}).

%% 清理跨服异域的任务数据
clear_kf_sanctuary_task(Tid) ->
    gen_server:cast(Tid, {'clear_kf_sanctuary_task'}).

gm_finish_current_task(Tid, TaskId, CellNum, TaskArgs) ->
    gen_server:cast(Tid, {gm_finish_current_task, [TaskId, CellNum, TaskArgs]}).

%% ================================= moduel api =================================
init([TaskArgs]) ->
    %% process_flag(priority, high),
    lib_task:load_role_task(TaskArgs),
    {ok, 0}.

%% ================================= private fun =================================

handle_call({test, A, B}, _FROM, State) ->
    {reply, A/B, State};

%% call
handle_call({finish_lv_task, TaskArgs, Type, MainTaskId}, _From, State) ->
    LastTaskId = lib_task:finish_lv_task(TaskArgs, Type, MainTaskId),
    {reply, LastTaskId, State};

handle_call({Fun, Args}, _FROM, State) ->
    {reply, apply(lib_task, Fun, Args), State};

%% 默认匹配
handle_call(Event, _From, Status) ->
    ?ERR("handle_call not match: ~p", [Event]),
    {reply, ok, Status}.

%% cast
%% 停止任务进程
handle_cast(stop, State) ->
    {stop, normal, State};

%% 刷新日常任务
handle_cast({'each_daily_clear', TaskArgs, _Clock}, State) ->
    Data = get(),
    [erase(Key)|| {Key, Value} <- Data, is_record(Value, role_task_log) andalso
        Value#role_task_log.type == ?TASK_TYPE_DAILY orelse Value#role_task_log.type == ?TASK_TYPE_GUILD 
        orelse Value#role_task_log.type == ?TASK_TYPE_DAY orelse Value#role_task_log.type == ?TASK_TYPE_DAILY_EUDEMONS],
    %% 圣兽领的采集任务，没完成也要重置
    EudemonsCltTaskId = lib_eudemons_land:get_eudemons_clt_task(),
    lib_task:delete_task_bag_list(EudemonsCltTaskId),
    lib_task:delete_task_log_list(EudemonsCltTaskId),
    lib_task:refresh_active(TaskArgs),
    case lib_task:auto_trigger(TaskArgs) of
        true -> 
            lib_task:refresh_npc_ico(TaskArgs),
            lib_task:get_my_task_list(TaskArgs);
        false -> skip
    end,
    {ok, Bin} = pt_300:write(30009, []),
    lib_server_send:send_to_sid(TaskArgs#task_args.sid, Bin),
    {noreply, State};

%% 发送任务物品
handle_cast({'send_drop_goods', RoleId, Goods}, State) ->
    TaskGoods = lib_task:can_gain_item(),
    spawn(lib_goods_drop, filter_task_goods, [RoleId, TaskGoods, Goods]),
    {noreply, State};

%% 触发特殊任务任务
handle_cast({'trigger_type_task', TaskType, TaskArgs}, State) ->
    {_, ErrCode} = lib_task:trigger_type_task(0, TaskType, TaskArgs),
    {ok, Bin} = pt_300:write(30011, [ErrCode, TaskType]),
    lib_server_send:send_to_uid(TaskArgs#task_args.id, Bin),
    {noreply, State};

%% 清理跨服异域任务数据
handle_cast({'clear_kf_sanctuary_task'}, State) ->
    Data = lib_task:get_task_bag_id_list_type(?TASK_TYPE_SANCTUARY_KF),
    Fun = fun(Value) ->
        case Value of
            #role_task{type = ?TASK_TYPE_SANCTUARY_KF, task_id = TaskId} ->
                lib_task:delete_task_bag_list(TaskId),
                lib_task:delete_task_log_list(TaskId);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, Data),
    {noreply, State};

%% 重连
handle_cast({'relogin', TaskArgs}, State) ->
    lib_task:relogin(TaskArgs),
    {noreply, State};

% %% 执行函数
% handle_cast({test, A, B}, State) ->
%     _V = A/B,
%     ?PRINT("A:~p B:~p V:~p ~n", [A, B, _V]),
%     {noreply, State};

%% 执行函数
handle_cast({Fun, Arg}, State) ->
    apply(lib_task, Fun, Arg),
    {noreply, State};

%% 默认匹配
handle_cast(_Event, State) ->
    ?PRINT("handle_cast not match: ~p", [_Event]),
    {noreply, State}.

%% 默认匹配
handle_info(_Info, State) ->
    ?PRINT("handle_info not match: ~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    lib_task:task_offline_up(),
    ok.

code_change(_oldvsn, State, _extra) ->
    {ok, State}.
