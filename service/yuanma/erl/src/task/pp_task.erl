%%%--------------------------------------
%%% @Module  : pp_task
%%% @Author  : xyao
%%% @Created : 2010.09.24
%%% @Description:  任务模块
%%%--------------------------------------
-module(pp_task).
-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").

%% 获取任务列表
handle(30000, PS, _) ->
    mod_task:get_my_task_list(PS#player_status.tid, lib_task_api:ps2task_args(PS));

%% 触发任务
handle(30003, PS, TaskId) ->
    case mod_task:trigger(PS#player_status.tid, TaskId, lib_task_api:ps2task_args(PS)) of
        true -> Code = 1;
        {false, Code} -> skip
    end,
    {ok, BinData} = pt_300:write(30003, [TaskId, Code]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);

%% 完成任务
handle(30004, PS, TaskId) ->
    {IsCheck, ErrCode} = lib_reincarnation:check_finish_task(PS, TaskId),
    if
        IsCheck == false ->
            {ok, BinData} = pt_300:write(30004, [0, ErrCode, []]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        true ->
            finish(PS, TaskId)
    end;

%% 上一次完成的主线id
handle(30005, PS, _) ->
    #player_status{sid = Sid, last_task_id = LastTaskId} = PS,
    lib_server_send:send_to_sid(Sid, pt_300, 30005, [LastTaskId]);

%% 放弃任务
% handle(30005, PS, [TaskId]) ->
%     mod_task:abnegate(PS#player_status.tid, TaskId, lib_task_api:ps2task_args(PS));

%% 任务对话事件
handle(30007, PS, NpcId) ->
     mod_task:event(PS#player_status.tid, ?TASK_CONTENT_TALK, {id, NpcId}, PS#player_status.id);

%% 任务加入帮派事件
handle(30008, PS, _) ->
    lib_task_api:join_guild(PS);

%% 消耗
handle(30006, PS, [TaskId, GoodsTypeId, Num]) ->
    case mod_task:check_cost_stuff(PS#player_status.tid, TaskId, GoodsTypeId, Num) of
        false -> ErrCode = ?FAIL, NewPS = PS;
        {true, LeftNum} ->
            About = lists:concat(["TaskId:", TaskId]),
            {PriceType, Price} = data_goods:get_goods_buy_price(GoodsTypeId),
            [{GoodsTypeId, GoodsNum}] = lib_goods_api:get_goods_num(PS, [GoodsTypeId]),
            DiffNum = max(LeftNum - GoodsNum, 0),
            % 是否不够物品
            case PriceType > 0 andalso Price > 0 andalso DiffNum > 0 of
                true -> 
                    % 没有该物品
                    case GoodsNum == 0 of
                        true -> Cost = [{PriceType, 0, Price*DiffNum}];
                        false -> Cost = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}, {PriceType, 0, Price*DiffNum}]
                    end;
                false -> 
                    Cost = [{?TYPE_GOODS, GoodsTypeId, LeftNum}]
            end,
            case lib_goods_api:cost_object_list_with_check(PS, Cost, task_stuff, About) of
                {false, ErrCode, NewPS} -> ok;
                {true, NewPS} ->
                    ErrCode = ?SUCCESS,
                    lib_task_api:cost_stuff(NewPS, TaskId, GoodsTypeId, Num)
            end
    end,
    % ?PRINT("ErrCode:~p TaskId:~p GoodsTypeId:~p, Num:~p~n", [ErrCode, TaskId, GoodsTypeId, Num]),
    {ok, BinData} = pt_300:write(30006, [ErrCode, TaskId]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    {ok, NewPS};


%% 任务类型的显示
handle(30010, Ps, TaskType) when TaskType == ?TASK_TYPE_DAILY; TaskType == ?TASK_TYPE_GUILD; TaskType == ?TASK_TYPE_DAILY_EUDEMONS ->
    #player_status{id = RoleId, sid = Sid} = Ps,
    case data_task_lv_dynamic:get_task_type(TaskType) of
        #task_type{count = Count, module_id = ModuleId, counter_id = CounterId} ->
            FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId),
            {ok, BinData} = pt_300:write(30010, [TaskType, FinishCount, Count]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            skip
    end;

%% 触发赏金任务和联盟周任务和悬赏任务
handle(30011, Ps, TaskType) when TaskType == ?TASK_TYPE_DAILY; TaskType == ?TASK_TYPE_GUILD; TaskType == ?TASK_TYPE_DAILY_EUDEMONS ->
    #player_status{id = RoleId, sid = Sid, tid = Tid, figure = #figure{guild_id = GuildId, lv = RoleLv}} = Ps,
    case data_task_lv_dynamic:get_task_type(TaskType) of
        #task_type{count = Count, module_id = ModuleId, counter_id = CounterId} ->
            FinishCount = ?IF(TaskType==?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_DAILY_EUDEMONS orelse TaskType == ?TASK_TYPE_GUILD,
                              mod_daily:get_count(RoleId, ModuleId, CounterId),
                              mod_week:get_count(RoleId, ModuleId, CounterId)),
            ErrCode = if
                FinishCount >= Count ->
                    ?IF(TaskType==?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_DAILY_EUDEMONS orelse TaskType == ?TASK_TYPE_GUILD,
                        ?ERRCODE(err300_daily_task_finished), ?ERRCODE(err300_guild_task_finished));
                TaskType == ?TASK_TYPE_GUILD andalso GuildId == 0 -> ?ERRCODE(err300_not_guild);
                TaskType == ?TASK_TYPE_DAILY andalso RoleLv < 65 -> ?ERRCODE(err300_lv_not_enough);
                TaskType == ?TASK_TYPE_GUILD andalso RoleLv < 130 -> ?ERRCODE(err300_lv_not_enough);
                TaskType == ?TASK_TYPE_DAILY_EUDEMONS andalso RoleLv < 320 -> ?ERRCODE(err300_lv_not_enough);
                true -> mod_task:trigger_type_task(Tid, TaskType, lib_task_api:ps2task_args(Ps)), ok
            end,
            if
                ErrCode == ok -> skip;
                true ->
                    {ok, BinData} = pt_300:write(30011, [ErrCode, TaskType]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            skip
    end;

handle(30011, Ps, TaskType) when TaskType == ?TASK_TYPE_SANCTUARY_KF ->
    NewPs = lib_sanctuary_cluster:trigger_type_task(Ps, TaskType),
    {ok, NewPs};

%% 赏金和公会周任务任务奖励内容
handle(30012, Ps, TaskId) ->
    #player_status{id = RoleId, tid = Tid} = Ps,
    case data_task:get(TaskId) of
        #task{type = Type} when Type == ?TASK_TYPE_DAILY; Type == ?TASK_TYPE_GUILD ->
            mod_task:get_special_task_reward(Tid, TaskId, RoleId, Type);
        _ -> skip
    end;

%% 扫荡公会任务和赏金任务
handle(30013, Ps, TaskType) ->
    #player_status{id = RoleId, tid = Tid, figure = #figure{lv = Lv, vip = VipLv}} = Ps,
    [{SweepLevelLimit, SweepVipLvLimit}] = data_task_sweep:get_sweep_level(TaskType),
    if 
        TaskType == ?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_GUILD ->
            if 
                Lv >=  SweepLevelLimit andalso VipLv >=SweepVipLvLimit ->
                    mod_task:sweep_get_special_task_reward(Tid, TaskType, RoleId, Lv, Ps);
                true -> skip
            end;
        true ->
            skip
    end;


handle(_Cmd, _PS, _Data) ->
    {error, bad_request}.

%% 完成任务
finish(PS, TaskId) ->
    CellNum = lib_goods_api:get_cell_num(PS),
    %% 判断消耗，注：如果是被其他进程异步扣除，可能会有问题
    IsCostEnough = case data_task:get(TaskId) of
        #task{end_item=EndItem} when is_list(EndItem) andalso EndItem /= [] -> 
            case lib_goods_api:check_object_list(PS, EndItem) of
                true -> true;
                _ -> {false, ?ERRCODE(err300_task_cost_not_enough)}
            end;
        #task{} -> true;
        _ -> {false, ?ERRCODE(err300_task_config_null)}
    end,
    case IsCostEnough of 
        true -> 
            case mod_task:finish(PS#player_status.tid, TaskId, [CellNum], lib_task_api:ps2task_args(PS)) of
                true ->
                    #task{type = TaskType} = data_task:get(TaskId),
                    case TaskType of
                        ?TASK_TYPE_DAILY -> 
                            lib_baby_api:finish_task(PS, ?TASK_TYPE_DAILY),
                            lib_task_api:fin_task_daily(PS, 1),
                            lib_hi_point_api:hi_point_task_daliy(PS#player_status.id, PS#player_status.figure#figure.lv);
                        ?TASK_TYPE_GUILD -> 
                            lib_task_api:fin_task_guild(PS, 1);
                        ?TASK_TYPE_DAY ->
                            lib_hi_point_api:hi_point_task_daliy(PS#player_status.id, PS#player_status.figure#figure.lv);
                            _ -> skip
                    end,
                    NewPS = lib_task_event:finish(PS, TaskId),
                    {ok, NewPS};
                false -> %% 注:完成任务后,自动接取其它任务有可能会返回false,但是本身TaskId是完成了
                    %lib_artifact_api:mod_activate_artifact(PS, {task, TaskId}),
                    %next_task_cue(TaskId, PS),%% 显示npc的默认对话
                    NewPS = lib_task_event:finish(PS, TaskId),
                    {ok, NewPS};
                {false, Reason} ->
                    {ok, BinData} = pt_300:write(30004, [0, Reason, []]),
                    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
                    ok
            end;
        {false, ErrCode} -> 
            {ok, BinData} = pt_300:write(30004, [0, ErrCode, []]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData),
            ok
    end.