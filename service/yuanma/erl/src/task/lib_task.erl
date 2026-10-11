%%%-----------------------------------
%%% @Module  : lib_task
%%% @Author  : xyao
%%% @Created : 2010.05.05
%%% @Description: 任务
%%%-----------------------------------
-module(lib_task).
-compile(export_all).

-include("scene.hrl").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("enchantment_guard.hrl").
-include("cluster_sanctuary.hrl").


%% ================================= 登录加载数据 =================================
load_role_task(TaskArgs) ->
    #task_args{id = Id} = TaskArgs,

    RoleTaskList = db_get_task_list(Id),
    RoleTaskContent = db_get_task_content(Id),

    TaskMarkMaps = make_mark(RoleTaskContent, #{}, Id),
    %% 所有已经触发的任务列表
    FunTirgger = fun([TaskId, BTime, NowStage, EdStage, TaskType, Lv], AllTask) ->
        case data_task:get(TaskId) of
            #task{type=TaskType, kind=Kind, state=State} when NowStage =< State ->
                case maps:find(TaskId, TaskMarkMaps) of
                    {ok, OMark} ->
                        Mark = sort_mark(OMark),
                        RT = #role_task{role_id=Id, lv = Lv, task_id=TaskId, trigger_time = BTime,
                            state = NowStage, end_state = EdStage, mark = Mark, type=TaskType, kind = Kind},
                        [RT|AllTask];
                    _ ->
                        AllTask
                end;
            _ ->
                del_trigger_from_sql(Id, TaskId, TaskType), %% 移除无效的已接任务
                AllTask
        end
    end,
    RoleTaskListRed = lists:foldl(FunTirgger, [], RoleTaskList),


    %% 所有已经完成的任务列表
    FunLog = fun([Tid2, Ty2, Tt2, Ft2]) ->
            put_task_log_list(#role_task_log{role_id=Id, task_id=Tid2, type=Ty2, trigger_time = Tt2, finish_time = Ft2})
    end,
    RoleTaskLogList = db:get_all(io_lib:format("select task_id, type, trigger_time, finish_time from task_log where role_id=~w", [Id])),
    RoleTaskLogClearList = db:get_all(io_lib:format("select task_id, type, trigger_time, finish_time from task_log_clear where role_id=~w and type=~w", [Id, ?TASK_TYPE_DAY])),
    lists:foreach(FunLog,  RoleTaskLogClearList++RoleTaskLogList),

    set_task_bag_list(login_check_is_finish(RoleTaskListRed, TaskArgs)),

    refresh_active(TaskArgs),
    %% 自动接取任务
    auto_trigger(TaskArgs).

db_get_task_list(Id) ->
    db:get_all(io_lib:format("select `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv` from `task_bag_clear` where role_id=~w", [Id])) ++
    db:get_all(io_lib:format("select `task_id`, `trigger_time`, `stage`, `edstage`, `type`, `lv` from `task_bag` where role_id=~w", [Id])).

db_get_task_content(Id) ->
    db:get_all(io_lib:format("select `task_id`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`, `y`, `path_find`,
            `display_num`, `is_guide`, `fin`, `now_num` from `task_bag_content_clear` where `role_id`=~w", [Id])) ++
    db:get_all(io_lib:format("select `task_id`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`, `scene_id`, `x`, `y`, `path_find`,
            `display_num`, `is_guide`, `fin`, `now_num` from `task_bag_content` where `role_id`=~w", [Id])).

%% 离线登录重新修复数据
relogin(TaskArgs) ->
    RoleTaskList = get_task_bag_id_list(),
    CheckTaskList = login_check_is_finish(RoleTaskList, TaskArgs),
    set_task_bag_list(CheckTaskList).

make_mark([[TaskId, Stage, Cid, CType, Id, NeedNum, Desc, SceneId, X, Y, PathFind, DisPlayNum, IsGuide, Fin, NowNum]|T], TaskMarkMap, RoleId) ->
    TC = #task_content{stage=Stage, cid=Cid, ctype=CType, id=Id, need_num=NeedNum, desc=Desc, scene_id=SceneId, x=X, y=Y,
        path_find=PathFind, display_num=DisPlayNum, is_guide=IsGuide, fin=Fin, now_num=NowNum},
    TaskMarkMap1 = case TaskMarkMap of
        #{TaskId := Contents} -> TaskMarkMap#{TaskId := [TC|Contents]};
        _ -> TaskMarkMap#{TaskId => [TC]}
    end,
    make_mark(T, TaskMarkMap1, RoleId);
make_mark([], TaskMarkMap, _) -> TaskMarkMap.

sort_mark(Marks) ->
    F = fun(#task_content{stage=Stage1, cid=Cid1}, #task_content{stage=Stage2, cid=Cid2}) ->
        if
            Stage1 < Stage2 -> true;
            Stage1 == Stage2 andalso Cid1 =< Cid2 -> true;
            true -> false
        end
    end,
    lists:sort(F, Marks).

%% 登陆时加载任务属性
load_attr(RoleId) ->
    TaskIds = db:get_all(io_lib:format("select task_id from task_log where role_id=~w", [RoleId])),
    F = fun([TaskId], TmpAttrList) ->
        case data_task:get(TaskId) of
            #task{type=?TASK_TYPE_AWAKE, attr_reward=AttrReward} ->
                [AttrReward|TmpAttrList];
            _ -> TmpAttrList
        end
    end,
    lib_player_attr:add_attr(record, lists:foldl(F, [], TaskIds)).

login_check_is_finish(TaskBagL, TaskArgs) ->
    F = fun(RT) ->
        login_check_one_is_finish(RT, TaskArgs)
    end,
    lists:map(F, TaskBagL).
login_check_one_is_finish(RT, TaskArgs) ->
    F = fun(MarkItem) ->
        login_check_mark_finish(MarkItem, TaskArgs)
    end,
    NewMark = lists:map(F, RT#role_task.mark),
    NoFinishStage = [EachStage || #task_content{stage=EachStage, fin=0} <- NewMark],
    NewState = if
        NoFinishStage == [] -> RT#role_task.end_state; %% 全部完成
        true -> lists:min(NoFinishStage)
    end,
    RT#role_task{state=NewState, mark = NewMark}.

login_check_mark_finish(#task_content{fin=1}=M, _) -> M;
login_check_mark_finish(#task_content{ctype=CType, id=Id, need_num=NeedNum}=TC, _) when CType == ?TASK_CONTENT_FIN_TASK orelse CType == ?TASK_CONTENT_FIN_MAIN_TASK ->
    case find_task_log_exits(Id) of
        true  -> TC#task_content{fin=1, now_num=NeedNum};
        false -> TC
    end;
login_check_mark_finish(#task_content{ctype=?TASK_CONTENT_LV, need_num=NeedNum}=TC, #task_args{figure=#figure{lv=Lv}} ) ->
    case Lv >= NeedNum of
        true  -> TC#task_content{fin=1, now_num=NeedNum};
        false -> TC#task_content{now_num=Lv}
    end;
login_check_mark_finish(#task_content{ctype=?TASK_CONTENT_STREN_SUM, need_num=NeedNum}=TC, #task_args{stren_award_list = StrenAwardList} ) ->
    case check_equip_sum(StrenAwardList, NeedNum, 0) of
        {false, Sum} ->
            TC#task_content{now_num=Sum};
        {true, _Sum}->
            TC#task_content{fin=1, now_num=NeedNum}
    end;
login_check_mark_finish(M, _) -> M.

%% 获取我的任务列表
get_my_task_list(#task_args{sid=Sid, last_task_id=LastTaskId}=TaskArgs) ->
    % 可接任务
    F = fun(TD, AList) ->
            if
                TD#task.type == ?TASK_TYPE_MAIN andalso LastTaskId > TD#task.id ->
                    AList;
                true ->
                    [{TD#task.id, get_tip(active, TD#task.id, TaskArgs)}|AList]
            end
    end,
    ActiveList  = lists:foldl(F, [], get_active()),
    %% 已接任务
    F1 = fun(RT, TL) ->
            #role_task{task_id = TaskId} = RT,
            TipList = get_tip(trigger, TaskId, TaskArgs),
            [{TaskId, TipList}|TL]
    end,
    TriggerList = lists:foldl(F1, [], get_trigger()),
    {ok, BinData} = pt_300:write(30000, [ActiveList, TriggerList]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 获取任务是否完成
get_task_finish_state(TaskId, TaskArgs)->
    case get_one_trigger(TaskId) of
        false -> ?ERRCODE(err300_no_task_trigger); %% 没接这个任务
        RT -> ?IF(is_finish(RT, TaskArgs), true, ?ERRCODE(err300_task_no_finish))
    end.

%% 获取任务类型
get_task_type(TaskId) ->
    TD = get_data(TaskId),
    ?IF(TD == null, 0, TD#task.type).

%% 升级自动触发任务
lv_up(TaskArgs) ->
    %% 刷新缓存可以优化一下
    refresh_active(TaskArgs),
    case auto_trigger(TaskArgs) of
        true -> skip;
        _ ->
            get_my_task_list(TaskArgs),
            refresh_npc_ico(TaskArgs)
    end.

%% 刷新任务并发送更新列表
refresh_task(#task_args{id=Id}=TaskArgs) ->
    refresh_active(TaskArgs),
    refresh_npc_ico(Id),
    {ok, BinData} = pt_300:write(30006, []),
    lib_server_send:send_to_uid(Id, BinData).

%% 遍历所有任务看是否可接任务
refresh_active(TaskArgs) ->
    #task_args{figure=#figure{lv=Lv}} = TaskArgs,
    Tids = data_task_lv:get_ids(Lv),
    F = fun(Tid) -> get_data(Tid) end,
    QueryCacheListRed = [F(Tid) || Tid <- Tids, check_task_type(Tid), can_trigger(Tid, TaskArgs) == true],
    set_query_cache_list(QueryCacheListRed).

%% 日常和公会任务不会进入可接缓存
check_task_type(Tid)->
    #task{type = TaskType} = get_data(Tid),
    ?IF(TaskType == ?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_GUILD orelse TaskType == ?TASK_TYPE_DAILY_EUDEMONS orelse TaskType == ?TASK_TYPE_SANCTUARY_KF, false, true).

%% 刷新悬赏任务和公会周任务
refresh_trigger_by_type(_TaskArgs, TaskType) ->
    TriggerTasks = get_trigger(),
    F1 = fun(RT, L) -> ?IF(RT#role_task.type =/= TaskType, [RT|L], L) end,
    NewTriggerList = lists:foldl(F1, [], TriggerTasks),
    set_task_bag_list(NewTriggerList).

%% 获取任务详细数据
get_data(TaskId) ->
    TD = data_task:get(TaskId),
    ?IF(TD == null, #task{}, TD).

%% 获取玩家能在该Npc接任务或者交任务
get_npc_task_list(NpcId, TaskArgs) ->
    {CanTrigger, Link, UnFinish, Finish} = get_npc_task(NpcId, TaskArgs),
    refresh_active(TaskArgs),
    F1 = fun(Tid, NS) -> TD = get_data(Tid), {Tid, NS, TD#task.name, TD#task.type} end,
    F2 = fun(TD, NS) -> {TD#task.id, NS, TD#task.name, TD#task.type} end,
    L1 = [F2(T1, 1) || T1 <- CanTrigger, T1#task.level =< TaskArgs#task_args.figure#figure.lv],
    L2 = [F1(T2, 4) || T2 <- Link],
    L3 = [F1(T3, 2) || T3 <- UnFinish],
    L4 = [F1(T4, 3) || T4 <- Finish],
    L1++L2++L3++L4.

%% 动态控制npc
do_dynamic_npc(TaskArgs, []) -> TaskArgs;
do_dynamic_npc(#task_args{id=Id, npc_info=NpcInfo}=TaskArgs, NpcShow) ->
    NewNpcInfo = lib_npc:change_role_npc_info(Id, NpcInfo, NpcShow),
    lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, lib_npc, update_role_npc_info, [NewNpcInfo]),
    TaskArgs#task_args{npc_info=NewNpcInfo}.

%% 更新场景上npc的任务图标
refresh_npc_ico(#task_args{scene=Scene, sid=Sid, npc_info=NpcInfo}=TaskArgs) ->
    NpcList = lib_npc:get_scene_npc(Scene, NpcInfo),
    F = fun({Id, _, _, _, _, _}) ->
            S = ?IF(Id == 0, 0, get_npc_state(Id, TaskArgs)),
            [Id, S]
    end,
    L = lists:map(F, NpcList),
    {ok, BinData} = pt_120:write(12020, [L]),
    lib_server_send:send_to_sid(Sid, BinData);
refresh_npc_ico(#player_status{tid=Tid} = PS) ->
    TaskArgs = lib_task_api:ps2task_args(PS),
    mod_task:refresh_npc_ico(Tid, TaskArgs);
refresh_npc_ico(PlayerId) ->
    case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) -> lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_task, refresh_npc_ico, []);
        _ -> skip
    end.

% 获取npc任务状态
get_npc_state(NpcId, TaskArgs) ->
    {CanTrigger, Link, UnFinish, Finish} = get_npc_task(NpcId, TaskArgs),
    %% 0表示什么都没有，1表示有可接任务，2表示已接受任务但未完成，3表示有完成任务，4表示有任务相关
    case length(Finish) > 0 of
        true -> 3;
        false ->
            case length(Link)>0 of
                true-> 4;
                false->
                    case length([0 || RT <- CanTrigger, RT#task.level =< TaskArgs#task_args.figure#figure.lv])>0 of
                        true  ->  1;
                        false ->
                            case length(UnFinish)>0 of
                                true -> 2;
                                false -> 0
                            end
                    end
            end
    end.

% 获取npc任务关联
%{可接任务，关联，任务未完成，完成任务}
get_npc_task(NpcId, TaskArgs)->
    CanTrigger = [ TS || TS <- get_query_cache_list(), TS#task.start_npc =:= NpcId],
    % ?PRINT("get_npc_task ~p~n", [get_task_bag_id_list()]),
    %% 已经接了的任务处理
    {Link, Unfinish, Finish} = get_npc_other_link_task(NpcId, TaskArgs),
    {CanTrigger, Link, Unfinish, Finish}.

% 获取已触发任务
get_npc_other_link_task(NpcId, TaskArgs) ->
    get_npc_other_link_task(get_task_bag_id_list(), {[], [], []}, NpcId, TaskArgs).

get_npc_other_link_task([], Result, _, _) -> Result;
get_npc_other_link_task([RT | T], {Link, Unfinish, Finish}, NpcId, TaskArgs) ->
    TD = get_data(RT#role_task.task_id),
    case is_finish(RT, TaskArgs) andalso get_end_npc_id(RT) =:= NpcId of  %% 判断是否完成
        true -> get_npc_other_link_task(T, {Link, Unfinish, Finish++[RT#role_task.task_id]}, NpcId, TaskArgs);
        false ->
            case task_talk_to_npc(RT, NpcId) of %% 判断是否和NPC对话
                true -> get_npc_other_link_task(T, {Link++[RT#role_task.task_id], Unfinish, Finish}, NpcId, TaskArgs);
                false ->
                    %% 获取npc未完成
                    case get_start_npc(TD#task.start_npc, TaskArgs#task_args.figure#figure.career) =:= NpcId of %% 判断是否接任务NPC
                        true -> get_npc_other_link_task(T, {Link, Unfinish++[RT#role_task.task_id], Finish}, NpcId, TaskArgs);
                        false -> get_npc_other_link_task(T, {Link, Unfinish, Finish}, NpcId, TaskArgs)
                    end
            end
    end.

%%检查任务的下一内容是否为与某npc的对话
task_talk_to_npc(RT, NpcId)->
    Temp =  [0 || #task_content{ctype=?TASK_CONTENT_TALK, id=Nid, stage=Stage, fin=Fin} <- RT#role_task.mark, Stage =:= RT#role_task.state, Fin =:= 0, Nid =:= NpcId],
    length(Temp)>0.

%% 获取任务对话id
get_npc_task_talk_id(TaskId, NpcId, TaskArgs) ->
    case get_data(TaskId) of
        null -> {none, 0};
        TD ->
            {CanTrigger, Link, UnFinish, Finish} = get_npc_task(NpcId, TaskArgs),
            case {lists:keymember(TaskId, #task.id, CanTrigger), lists:member(TaskId, Link),
                    lists:member(TaskId, UnFinish), lists:member(TaskId, Finish) } of
                {true, _, _, _} -> {start_talk, TD#task.start_talk};    %% 任务触发对话
                {_, true, _, _} ->    %% 关联对话
                    case get_one_trigger(TaskId) of
                        false ->
                            {none, 0};
                        RT ->
                            [Fir|_] = [TalkId || #task_content{ctype=?TASK_CONTENT_TALK, id=Nid, need_num=TalkId, stage=Stage, fin=Fin} <- RT#role_task.mark,
                                Stage=:= RT#role_task.state, Fin=:=0, Nid =:= NpcId],
                            % [Fir|_] = [TalkId || [State,Fin,?TASK_CONTENT_TALK,Nid,TalkId|_] <- RT#role_task.mark,
                            %     State=:= RT#role_task.state, Fin=:=0, Nid =:= NpcId],
                            {link_talk, Fir}
                    end;
                {_, _, true, _} -> {unfinished_talk, TD#task.unfinished_talk};  %% 未完成对话
                {_, _, _, true} ->   %% 提交任务对话
                    case get_one_trigger(TaskId) of
                        false ->
                            {none, 0};
                        RT ->
                            [Fir|_] = [TalkId || #task_content{ctype=?TASK_CONTENT_END_TALK, id=Nid, need_num=TalkId} <- RT#role_task.mark,
                                Nid =:= NpcId],
                            % [Fir|_] = [TalkId || [_,_,?TASK_CONTENT_END_TALK,Nid,TalkId|_] <- RT#role_task.mark, Nid == NpcId],
                            {end_talk, Fir}
                    end;
                _ -> {none, 0}
            end
    end.

%% 获取提示信息
%% 可接任务会有开始npc对话
get_tip(active, TaskId, #task_args{figure=#figure{career=Career}}=TaskArgs) ->
    TD = get_data(TaskId),
    case get_start_npc(TD#task.start_npc, Career) of
        0 -> [];
        StartNpcId ->
            TC = #task_content{ctype=?TASK_CONTENT_START_TALK, id=StartNpcId, need_num=TD#task.start_talk, path_find=TD#task.trigger_pathfind, is_guide=TD#task.start_guide},
            content_to_mark([init_mark(TC, TaskId, TaskArgs)], TaskArgs, TaskId, [])
    end;
get_tip(trigger, TaskId, _TaskArgs) ->
    RT = get_one_trigger(TaskId),
    [TaskMark || TaskMark <- RT#role_task.mark, TaskMark#task_content.stage == RT#role_task.state].

content_to_mark([{Stage, Cid}|T], TaskArgs, TaskId, Result) ->
    Result1 = case data_task:get_content(TaskId, Stage, Cid) of
        TC when is_record(TC, task_content) -> [init_mark(TC, TaskId, TaskArgs)|Result];
        _ -> Result
    end,
    content_to_mark(T, TaskArgs, TaskId, Result1);
content_to_mark([TC|T], TaskArgs, TaskId, Result) when is_record(TC, task_content) ->
    content_to_mark(T, TaskArgs, TaskId, [init_mark(TC, TaskId, TaskArgs)|Result]);
content_to_mark([], _TaskArgs, _TaskId, Result) -> lists:reverse(Result).


%% 初始化任务内容，如:接的时候已经完成
init_mark(#task_content{ctype=ContentType, id=Id, need_num=NeedNum, talk_id=TalkId}=TC, TaskId, TaskArgs) ->
    case ContentType of
        ?TASK_CONTENT_WELCOME ->
            TC#task_content{fin=1, now_num=NeedNum};
        ?TASK_CONTENT_COIN ->
            TC#task_content{fin=1, now_num=NeedNum};
        ?TASK_CONTENT_START_TALK ->
            {RealSceneId, RealX, RealY} = get_npc_info(Id, TaskArgs#task_args.npc_info),
            TC#task_content{scene_id=RealSceneId, x=RealX, y=RealY};
        ?TASK_CONTENT_END_TALK ->
            {RealSceneId, RealX, RealY} = get_npc_info(Id, TaskArgs#task_args.npc_info),
            TC#task_content{scene_id=RealSceneId, x=RealX, y=RealY, fin=1};
        ?TASK_CONTENT_TALK ->
            {RealSceneId, RealX, RealY} = get_npc_info(Id, TaskArgs#task_args.npc_info),
            TC#task_content{scene_id=RealSceneId, x=RealX, y=RealY, need_num=TalkId};
        ?TASK_CONTENT_ITEM ->
            #task_args{id = RoleId, gs_dict = GsDict} = TaskArgs,
            case data_goods_type:get(Id) of
                #ets_goods_type{bag_location = BagLocation} ->
                    GoodsList = lib_goods_util:get_type_goods_list(RoleId, Id, BagLocation, GsDict),
                    TotalNum = lib_goods_util:get_goods_totalnum(GoodsList);
                _ ->
                    ?ERR("goods_num err: goods_type_id = ~p err_config", [Id]),
                    TotalNum = 0
            end,
            {Finish, NowNum} = ?IF(TotalNum >= NeedNum, {1, NeedNum}, {0, TotalNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_EQUIP ->
            #task_args{equip_info = EquipInfo} = TaskArgs,
            EquipNum = length(EquipInfo),
            {Finish, NowNum} = ?IF(EquipNum >= NeedNum, {1, NeedNum}, {0, EquipNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_EQUIP_ORANGE ->
            #task_args{equip_info = EquipInfo} = TaskArgs,
            EquipNum = length([1||{EquipColor, EquipStage, _EquipStar}<-EquipInfo, EquipColor >= ?ORANGE, EquipStage >= Id]),
            {Finish, NowNum} = ?IF(EquipNum >= NeedNum, {1, NeedNum}, {0, EquipNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_STREN ->
            #task_args{stren_award_list = StrenAwardList} = TaskArgs,
            case check_equip_pre_num(StrenAwardList, NeedNum, Id, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                {true, _Count} ->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_STREN_SUM ->
            #task_args{stren_award_list = StrenAwardList} = TaskArgs,
            case check_equip_sum(StrenAwardList, NeedNum, 0) of
                {false, Sum} ->
                    TC#task_content{now_num=Sum};
                {true, _Sum}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_REFINE_EQUIP ->
            #task_args{refine_award_list = RefineAwardList} = TaskArgs,
            case check_equip_pre_num(RefineAwardList, NeedNum, Id, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                {true, _Count}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_EQUIP_STAGE ->
            #task_args{stage_award_list = StageAwardList} = TaskArgs,
            case check_equip_pre_num(StageAwardList, NeedNum, Id, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                {true, _Count}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_REFINE_SUM ->
            #task_args{refine_award_list = RefineAwardList} = TaskArgs,
            case check_equip_sum(RefineAwardList, NeedNum, 0) of
                {false, Sum} ->
                    TC#task_content{now_num=Sum};
                {true, _Sum}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_EQUIP_COLOR ->
            #task_args{color_award_list = ColorAwardList} = TaskArgs,
            case check_equip_pre_num(ColorAwardList, NeedNum, Id, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                {true, _Count}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_FUSION_EQUIP ->
            #task_args{fusion_lv = FusionLv} = TaskArgs,
            {Finish, NowNum} = ?IF(FusionLv >= NeedNum, {1, NeedNum}, {0, FusionLv}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_RAD_SUIT ->
            #task_args{re_red_equip_award_list = ReRedEquipAwardList} = TaskArgs,
            case check_equip_num(ReRedEquipAwardList, NeedNum, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                true->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_ACTIVE_SUIT ->
            #task_args{suit_num_list = SuitNumList} = TaskArgs,
            case check_equip_num(SuitNumList, NeedNum, 0) of
                {false, Count} ->
                    TC#task_content{now_num=Count};
                true->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_FIN_TASK ->
            case find_task_log_exits(Id) of
                true  -> TC#task_content{fin=1, now_num=NeedNum};
                false -> TC
            end;
        ?TASK_CONTENT_FIN_TASK_DAILY ->
            case data_task_lv_dynamic:get_task_type(?TASK_TYPE_DAILY) of
                #task_type{module_id = ModuleId, counter_id = CounterId} ->
                    FinishCount = mod_daily:get_count(TaskArgs#task_args.id, ModuleId, CounterId),
                    {Finish, NowNum} = ?IF(FinishCount >= NeedNum, {1, NeedNum}, {0, FinishCount}),
                    TC#task_content{fin=Finish, now_num=NowNum};
                _ -> TC
            end;
        ?TASK_CONTENT_FIN_TASK_GUILD ->
            case data_task_lv_dynamic:get_task_type(?TASK_TYPE_GUILD) of
                #task_type{module_id = ModuleId, counter_id = CounterId} ->
                    %FinishCount = mod_week:get_count(TaskArgs#task_args.id, ModuleId, CounterId),
                    FinishCount = mod_daily:get_count(TaskArgs#task_args.id, ModuleId, CounterId),
                    {Finish, NowNum} = ?IF(FinishCount >= NeedNum, {1, NeedNum}, {0, FinishCount}),
                    TC#task_content{fin=Finish, now_num=NowNum};
                _ -> TC
            end;
        ?TASK_CONTENT_FIN_MAIN_TASK ->
            case find_task_log_exits(Id) of
                true  -> TC#task_content{fin=1, now_num=NeedNum};
                false -> TC
            end;
        ?TASK_CONTENT_UPGRADE_MEDAL ->
            #task_args{medal_lv = MedalLv} = TaskArgs,
            {Finish, NowNum} = ?IF(MedalLv >= NeedNum, {1, NeedNum}, {0, MedalLv}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_TRAIN_MOUNT ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?MOUNT_ID, 1, TrainStarList) of
                 {_, Stage, Star, _} -> ?IF(Stage > Id orelse (Stage==Id andalso Star>=NeedNum), {1, NeedNum}, {0, Star});
                 _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_TRAIN_WING ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?FLY_ID, 1, TrainStarList) of
                  {_, Stage, Star, _} -> ?IF(Stage > Id orelse (Stage==Id andalso Star>=NeedNum), {1, NeedNum}, {0, Star});
                 _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_TRAIN_PARTNER ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?MATE_ID, 1, TrainStarList) of
                  {_, Stage, Star, _} -> ?IF(Stage > Id orelse (Stage==Id andalso Star>=NeedNum), {1, NeedNum}, {0, Star});
                 _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_TRAIN_HOLYORGAN ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?HOLYORGAN_ID, 1, TrainStarList) of
                  {_, Stage, Star, _} -> ?IF(Stage > Id orelse (Stage==Id andalso Star>=NeedNum), {1, NeedNum}, {0, Star});
                 _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_TRAIN_ARTIFACT ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?ARTIFACT_ID, 1, TrainStarList) of
                {_, Stage, Star, _} -> ?IF(Stage > Id orelse (Stage==Id andalso Star>=NeedNum), {1, NeedNum}, {0, Star});
                _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_MOUNT ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?MOUNT_ID, 1, TrainStarList) of
                 false -> {0, 0};
                 _ -> {1, NeedNum}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_WING ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?FLY_ID, 1, TrainStarList) of
                 false -> {0, 0};
                 _ -> {1, NeedNum}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_PARTNER ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?MATE_ID, 1, TrainStarList) of
                 false -> {0, 0};
                 _ -> {1, NeedNum}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_HOLYORGAN ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} = case lists:keyfind(?HOLYORGAN_ID, 1, TrainStarList) of
                 false -> {0, 0};
                 _ -> {1, NeedNum}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_MAIN_DUNGEON ->
            #task_args{chapter = Chapter} = TaskArgs,
            {Finish, NowNum} = ?IF(Chapter >= NeedNum, {1, NeedNum}, {0, Chapter}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_LV ->
            #task_args{figure = #figure{lv = TotalNum}} = TaskArgs,
            {Finish, NowNum} = ?IF(TotalNum >= NeedNum, {1, NeedNum}, {0, TotalNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACHV_AWARD ->
            #task_args{achv_ids = AchvIds} = TaskArgs,
            {Finish, NowNum} = case lists:member(Id, AchvIds) of
                true -> {1, NeedNum};
                false -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACHV_LV ->
            #task_args{figure = #figure{achiv_stage=AchvStage}} = TaskArgs,
            {Finish, NowNum} = ?IF(AchvStage >= NeedNum, {1, NeedNum}, {0, AchvStage}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_DSG ->
            #task_args{dsg_num = DsgNum} = TaskArgs,
            {Finish, NowNum} = ?IF(DsgNum >= NeedNum, {1, NeedNum}, {0, DsgNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_DSG_ID ->
            #task_args{dsg_map = DsgMap} = TaskArgs,
            {Finish, NowNum} = case maps:find(Id, DsgMap) of
                error -> {0, 0};
                _ -> {1, NeedNum}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_RUNE_NUM ->
            #task_args{rune_num = RuneNum} = TaskArgs,
            {Finish, NowNum} = ?IF(RuneNum >= NeedNum, {1, NeedNum}, {0, RuneNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_JOIN_JJC ->
            #task_args{jjc_daily_num = JjcDailyNum} = TaskArgs,
            {Finish, NowNum} = ?IF(JjcDailyNum >= NeedNum, {1, NeedNum}, {0, JjcDailyNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_COMBATPOWER ->
            #task_args{combat_power = CombatPower} = TaskArgs,
            {Finish, NowNum} = ?IF(CombatPower >= NeedNum, {1, NeedNum}, {0, CombatPower}),
            TC#task_content{fin=Finish, now_num=NowNum};
        TaskType when
                TaskType == ?TASK_CONTENT_DUNGEON_TYPE;
                TaskType == ?TASK_CONTENT_DUNGEON ->
            #task_args{id = RoleId} = TaskArgs,
            {Finish, NowNum} = case lib_dungeon_api:get_task_dungeon_num(TaskType, RoleId, Id) of
                DunEnterNum when is_integer(DunEnterNum) -> ?IF(DunEnterNum >= NeedNum, {1, NeedNum}, {0, DunEnterNum});
                _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_JOIN_GUILD ->
            #task_args{figure = #figure{guild_id=GuildId}} = TaskArgs,
            {Finish, NowNum} = ?IF(GuildId > 0, {1, NeedNum}, {0, 0}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_SKILL_STREN_SUM ->
            #task_args{skill_stren_sum=SkillStrenSum} = TaskArgs,
            {Finish, NowNum} = ?IF(SkillStrenSum >= NeedNum, {1, NeedNum}, {0, SkillStrenSum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_RUNE_LV ->
            #task_args{rune_lv_list = RuneLvList} = TaskArgs,
            RuneNum = length([E || E <- RuneLvList, E >= Id]),
            {Finish, NowNum} = ?IF(RuneNum >= NeedNum, {1, NeedNum}, {0, RuneNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_RUNE_LV_SUM ->
            #task_args{rune_lv_list = RuneLvList} = TaskArgs,
            RuneLvSum = lists:sum(RuneLvList),
            {Finish, NowNum} = ?IF(RuneLvSum >= NeedNum, {1, NeedNum}, {0, RuneLvSum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_EQUIP_STONE_SUM ->
            #task_args{stone_award_list = StoneAwardList} = TaskArgs,
            case check_equip_sum(StoneAwardList, NeedNum, 0) of
                {false, Sum} ->
                    TC#task_content{now_num=Sum};
                {true, _Sum}->
                    TC#task_content{fin=1, now_num=NeedNum}
            end;
        ?TASK_CONTENT_ACTIVITY_LV ->
            #task_args{activity_lv = ActivityLv} = TaskArgs,
            {Finish, NowNum} = ?IF(ActivityLv >= NeedNum, {1, NeedNum}, {0, ActivityLv}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVITY_ACC ->
            #task_args{activity_liveness = Liveness} = TaskArgs,
            {Finish, NowNum} = ?IF(Liveness >= NeedNum, {1, NeedNum}, {0, Liveness}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_DUNGEON_LEVEL ->
            #task_args{dun_level_map = DunLevelMap} = TaskArgs,
            Level = maps:get(Id, DunLevelMap, 0),
            {Finish, NowNum} = ?IF(Level >= NeedNum, {1, NeedNum}, {0, Level}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_AWAKENING ->
            #task_args{awakening_active_ids = ActiveIds} = TaskArgs,
            Num = lib_awakening:calc_cell_num(TaskId, ActiveIds),
            % NowNum = min(Num, NeedNum),
            {Finish, NowNum} = ?IF(Num >= NeedNum, {1, NeedNum}, {0, Num}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_COST_STUFF ->
            #task_args{id = RoleId, gs_dict = GsDict} = TaskArgs,
            case data_goods_type:get(Id) of
                #ets_goods_type{bag_location = BagLocation} ->
                    GoodsList = lib_goods_util:get_type_goods_list(RoleId, Id, BagLocation, GsDict),
                    TotalNum = lib_goods_util:get_goods_totalnum(GoodsList);
                _ ->
                    ?ERR("goods_num err: goods_type_id = ~p err_config", [Id]),
                    TotalNum = 0
            end,
            % ?MYLOG("hjhtask", "TASK_CONTENT_COST_STUFF TotalNum:~p~n", [TotalNum]),
            {Finish, NowNum} = ?IF(TotalNum >= NeedNum, {0, NeedNum}, {0, TotalNum}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_AWARD_LV_GIFT ->
            #task_args{rush_bag_lv_list = RushBagLvL} = TaskArgs,
            {Finish, NowNum} = case lists:member(Id, RushBagLvL) of
                true  -> {1, NeedNum};
                false -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_KILL_BOSS_ID ->
            #task_args{id = RoleId} = TaskArgs,
            {Finish, NowNum} = case mod_counter:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_OUTSID_KILL, Id) of
                Num when is_integer(Num) andalso Num >= NeedNum ->
                    {1, NeedNum};
                Num when is_integer(Num) -> {0, Num};
                _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_LOGIN_DAY ->
            #task_args{login_days=LoginDays} = TaskArgs,
            {Finish, NowNum} = ?IF(LoginDays >= NeedNum, {1, NeedNum}, {0, LoginDays}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_SEAL_SET_NUM ->
            #task_args{seal_equip_list = SealEquipL} = TaskArgs,
            Num = length(SealEquipL),
            {Finish, NowNum} = ?IF(Num >= NeedNum, {1, NeedNum}, {0, Num}),
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ACTIVE_SOAP ->
            #task_args{soap_map = SoapStatus} = TaskArgs,
            {Finish, NowNum} =
                case maps:get(Id, SoapStatus, false) of
                    false -> {0, 0};
                    Item -> ?IF(lib_enchantment_guard_check:is_active_whole_soap(Item), {1, NeedNum}, {0, 0})
                end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_MOUNT_LEVEL ->
            #task_args{train_star_list = TrainStarList} = TaskArgs,
            {Finish, NowNum} =  case lists:keyfind(Id, 1, TrainStarList) of
                {_, _, _, SysLv} -> ?IF(SysLv >= NeedNum, {1, NeedNum}, {0, SysLv});
                _ -> {0, 0}
            end,
            TC#task_content{fin=Finish, now_num=NowNum};
        ?TASK_CONTENT_ADD_FRIEND ->
            #task_args{friend_num = HasNum} = TaskArgs,
            {Finish, NowNum} = ?IF(HasNum >= NeedNum, {1, NeedNum}, {0, HasNum}),
            TC#task_content{fin = Finish, now_num = NowNum};
        _ ->
            TC
    end.

%% 获取奖励
get_award_item(TD, TaskArgs) ->
    SL = get_special_reward_item(TD#task.special_goods_list,  TaskArgs, []),
    F = fun(E, LL) ->
            case E of
                {?TYPE_GOODS, GoodsTypeId, Num} -> [{?TYPE_BIND_GOODS, GoodsTypeId, Num}|LL];
                _ -> [E|LL]
            end
    end,
    lists:foldl(F, SL, TD#task.award_list).

%% 获取特殊奖励
get_special_reward_item([], _TaskArgs, Rewards) -> Rewards;
get_special_reward_item([{Career, Sex, GoodsTypeId, Num}|SpecialGoods],  TaskArgs, Rewards) ->
    if
        Career == 0 andalso Sex == 0 ->
            get_special_reward_item(SpecialGoods, TaskArgs, [{?TYPE_BIND_GOODS, GoodsTypeId, Num}|Rewards]);
        Career == TaskArgs#task_args.figure#figure.career andalso Sex == 0->
            get_special_reward_item(SpecialGoods, TaskArgs, [{?TYPE_BIND_GOODS, GoodsTypeId, Num}|Rewards]);
        Sex == TaskArgs#task_args.figure#figure.sex andalso Career == 0 ->
            get_special_reward_item(SpecialGoods, TaskArgs, [{?TYPE_BIND_GOODS, GoodsTypeId, Num}|Rewards]);
        Career == TaskArgs#task_args.figure#figure.career andalso Sex == TaskArgs#task_args.figure#figure.sex ->
            get_special_reward_item(SpecialGoods, TaskArgs, [{?TYPE_BIND_GOODS, GoodsTypeId, Num}|Rewards]);
        true ->
            get_special_reward_item(SpecialGoods, TaskArgs, Rewards)
    end;
get_special_reward_item([_|SpecialGoods], TaskArgs, Rewards) ->
    get_special_reward_item(SpecialGoods, TaskArgs, Rewards).



%% 获取开始npc的id
%% 如果需要判断职业才匹配第2,3
get_start_npc(StartNpc, _) when is_integer(StartNpc) -> StartNpc;
get_start_npc([], _) -> 0;
get_start_npc([{career, Career, NpcId}|T], RoleCareer) ->
    case Career =:= RoleCareer of
        false -> get_start_npc(T, RoleCareer);
        true -> NpcId
    end.

%%获取当前NPC所在的场景（自动寻路用）
get_npc_info(NpcId, NpcInfo) ->
    case lists:keyfind(NpcId, 1, NpcInfo) of
        {_, _IsShow, Scene, X, Y, _} -> {Scene, X, Y};
        false ->
            case lib_npc:get_npc_info_by_id(NpcId) of
                [] ->
                    case data_scene:get_npc(NpcId) of
                        #ets_scene_npc{scene_id=Scene, x=X, y=Y} -> {Scene, X, Y};
                        _ -> {0, 0, 0}
                    end;
                Npc -> {Npc#ets_npc.scene, Npc#ets_npc.x, Npc#ets_npc.y}
            end
    end.

%%获取当前怪物所在的场景
get_mon_info(MonId) ->
    case mod_scene_mon:lookup(MonId) of
        [] -> {0, 0, 0};
        D -> {D#ets_scene_mon.scene, D#ets_scene_mon.x, D#ets_scene_mon.y}
    end.

%% 指定id任务是否可接
in_active(TaskId) ->
    find_query_cache_exits(TaskId).

get_active() ->
    get_query_cache_list().

get_active(type, Type) ->
    get_query_cache_list_type(Type).

%% 获取已触发任务列表
get_trigger() ->
    get_task_bag_id_list().

%% 获取该阶段任务内容
get_phase(RT) ->
    [[State | T] || [State | T] <- RT#role_task.mark, RT#role_task.state =:= State].

%% 获取任务阶段的未完成内容:改成这个任务没有最终完成的
%% get_phase_unfinish(RT)->
%%     [[State, Fin | T] || [State, Fin |T] <- RT#role_task.mark].

get_one_trigger(TaskId) ->
    find_task_bag_list(TaskId).

%% 玩家是否已经领取过指定的某些任务之一
is_trigger_specify_task_ids(TaskIds) ->
    F = fun(Task) ->
            lists:member(Task#role_task.task_id, TaskIds)
    end,
    lists:any(F, get_task_bag_id_list()).

%% 查看是否领取了指定的任务ID:是:true 否:false
is_trigger_task_id(TaskId) ->
    case find_task_bag_list(TaskId) of
        false -> false;
        _ -> true
    end.

%% 根据任务ID列表,获得在领取的任务列表
get_trigger_task_id_list(TaskIdL) ->
    F = fun(TaskId) -> is_trigger_task_id(TaskId) end,
    lists:filter(F, TaskIdL).

%%根据任务阶段列表,获得在领取的任务列表
get_trigger_task_stage_list(TaskStageL) ->
    F = fun({TaskId, Stage}) ->
        case find_task_bag_list(TaskId) of
            #role_task{state = Stage, mark = Mark} ->
                NoFinishState = [EachStage || #task_content{stage=EachStage, fin=0} <- Mark],
                NoFinishState =/= [];
            _ ->
                false
        end
    end,
    lists:filter(F, TaskStageL).

%% 只能在任务进程调用
%% 查看是否完成了指定的任务ID:是:true 否:false
is_finish_task_id(TaskId) ->
    case find_task_log_list(TaskId) of
        false -> false;
        _ -> true
    end.

is_finish_task_ids([]) -> true;
is_finish_task_ids([TaskId|T]) ->
    case find_task_log_list(TaskId) of
        false -> false;
        _ -> is_finish_task_ids(T)
    end.

%% 根据任务ID列表,获得已经完成的任务id列表
%% @return [TaskId,..]
get_finish_task_id_list(TaskIdL) ->
    [TaskId||TaskId<-TaskIdL, is_finish_task_id(TaskId)].

%% 获取结束任务的npcid
get_end_npc_id(RT) when is_record(RT, role_task)->
    get_end_npc_id(RT#role_task.mark);

get_end_npc_id(TaskId) when is_integer(TaskId) ->
    case get_one_trigger(TaskId) of
        false -> 0;
        RT -> get_end_npc_id(RT)
    end;
get_end_npc_id([]) -> 0;
get_end_npc_id(Mark) ->
    case lists:last(sort_mark(Mark)) of
        #task_content{ctype=?TASK_CONTENT_END_TALK, id=NpcId} -> NpcId;
        _ -> 0  %% 这里是异常
    end.

%% ================================= 任务触发检查 =================================
%% 检查是否可以触发任务
can_trigger(TaskId, TaskArgs) ->
    #figure{lv = PlayerLv, career = PlayerCareer, realm = PlayerRealm,
        turn = PlayerTurn, guild_id = PlayerGuilId} = TaskArgs#task_args.figure,
    case find_task_bag_exits(TaskId) of
        true ->
            {false, ?ERRCODE(err300_task_trigger)}; %%已经触发过了
        false ->
            case data_task_condition:get(TaskId) of
                null ->
                    {false, ?ERRCODE(err300_task_config_null)};
                #task_condition{type = TaskType, level = Level, level_max = MaxLevel, realm = Realm,
                    career = Career, turn = Turn, prev = Prev, repeat = Repeat, condition = Condition} = _TD ->
                    if
                        TaskType == ?TASK_TYPE_MAIN andalso TaskId =< TaskArgs#task_args.last_task_id ->
                            {false, ?ERRCODE(err300_task_trigger)};
                        TaskType == ?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_GUILD orelse TaskType == ?TASK_TYPE_DAILY_EUDEMONS
                            orelse TaskType == ?TASK_TYPE_SANCTUARY_KF ->
                            {false, ?ERRCODE(err300_condition_err)};
                        %TaskType == ?TASK_TYPE_DAILY andalso PlayerLv < ?DAILY_TASK_LV -> {false, ?ERRCODE(err300_lv_not_enough)};
                        %TaskType == ?TASK_TYPE_GUILD andalso PlayerLv < ?GUILD_TASK_LV -> {false, ?ERRCODE(err300_lv_not_enough)};
                        (PlayerLv > MaxLevel orelse PlayerLv < Level) ->
                            {false, ?ERRCODE(err300_lv_not_enough)}; %% 等级不足
                        PlayerLv < Level ->
                            {false, ?ERRCODE(err300_lv_not_enough)}; %% 等级不足
                        TaskType == ?TASK_TYPE_GUILD andalso PlayerGuilId == 0 -> %% 没有帮派
                            {false, ?ERRCODE(err300_not_guild)};
                        Realm /=0 andalso PlayerRealm /= Realm ->
                            {false, ?ERRCODE(err300_realm_diff)};  %% 阵营不符合
                        Career /= 0 andalso PlayerCareer /= Career ->
                            {false, ?ERRCODE(err300_career_diff)}; %% 阵营不符合
                        Turn /= 0 andalso PlayerTurn < Turn ->
                            {false, ?ERRCODE(err300_turn_diff)};   %% 转生次数不符合(向下兼容)
                        TaskType == ?TASK_TYPE_TURN andalso PlayerTurn > Turn andalso PlayerTurn > 0 ->
                            {false, ?ERRCODE(err300_turn_diff)};   %% 如果是转生任务 但是玩家的转生次数已经超过了任务的转生次数则不能重复触发
                        true ->
                            case check_prev_task(Prev) of
                                false -> {false, ?ERRCODE(err300_prev_not_fin)}; %% 前置任务未完成
                                true  ->
                                    case check_repeat(TaskId, Repeat) of
                                        false -> {false, ?ERRCODE(err300_fin)};
                                        true ->
                                            case length([1||ConditionItem <- Condition, check_condition(ConditionItem, TaskId, TaskArgs)=:=false]) =:= 0 of
                                                true  -> true;
                                                false -> {false, ?ERRCODE(err300_condition_err)}
                                            end
                                    end
                            end
                    end
            end
    end.

%% 获取下一等级的任务
next_lev_list(PS) ->
    Tids = data_task:get_ids(),
    F = fun(Tid) -> TD = get_data(Tid), (PS#player_status.figure#figure.lv + 1) =:= TD#task.level end,
    [XTid || XTid<-Tids, F(XTid)].

%% 是否重复可以接
check_repeat(TaskId, Repeat) ->
    case Repeat =:= 0 of
        true -> find_task_log_exits(TaskId) =/= true;
        false -> true
    end.

%% 前置任务
check_prev_task(PrevId) ->
    case PrevId =:= 0 of
        true  -> true;
        false -> find_task_log_exits(PrevId)
    end.

%% 任务条件建检查
%% 是否完成任务
check_condition({task, TaskId}, _, _) -> find_task_log_exits(TaskId);
%% 是否完成其中之一的任务
check_condition({task_one, TaskList}, _, _) -> lists:any(fun(Tid)-> find_task_log_exits(Tid) end, TaskList);
%% 今天的任务次数是否过多
check_condition({daily_limit, Num}, TaskId, _) ->
    case find_task_log_list(TaskId) of
        false -> true;
        RTL   -> RTL#role_task_log.count < Num
    end;
check_condition({open_day, OpDay}, _TaskId, _) ->
    util:get_open_day() >= OpDay;
%% 容错
check_condition(_Other, _, _TaskArgs) -> false.

%% ================================= 触发任务 =================================
%% 自动触发任务
auto_trigger(TaskArgs) ->
    ActiveTasks = get_active(), %% 获取可以接的任务
    F = fun(TD, Bool) ->
            case TD#task.start_npc == 0 andalso TD#task.start_talk == 0 of
                true  ->
                    case trigger_no_notify(TD#task.id, TaskArgs) of
                        true -> true;
                        _ -> Bool
                    end;
                false -> Bool
            end
    end,
    IsTrigger = lists:foldl(F, false, ActiveTasks),
    case IsTrigger of
        true ->
            get_my_task_list(TaskArgs),
            refresh_npc_ico(TaskArgs);
        false -> skip
    end,
    IsTrigger.


%% 触发（分离广播，避免每次触发任务都触发一次刷新任务列表）
trigger_no_notify(TaskId, TaskArgs) ->
    case can_trigger(TaskId, TaskArgs) of
        {false, ErrCode} ->
            {false, ErrCode};
        true ->
            TD = get_data(TaskId),
            TaskMark = content_to_mark(TD#task.content, TaskArgs, TaskId, []),
            {EndStage, FinTCList} = case TD#task.end_talk of
                0 -> {TD#task.state, []}; %% end_talk = 0则直接提交任务
                _ ->
                    TmpEndStage = case TaskMark of
                        [] -> TD#task.state; %% 没有其他前置，则最后这个对话就是默认0阶段
                        _ -> TD#task.state+1
                    end,
                    TC = #task_content{stage=TmpEndStage, ctype=?TASK_CONTENT_END_TALK, id=TD#task.end_npc,
                        need_num=TD#task.end_talk, display_num=1, path_find=TD#task.finish_pathfind,
                        talk_id=TD#task.end_talk, is_guide=TD#task.end_guide},
                    {TmpEndStage, [init_mark(TC, TaskId, TaskArgs)]}
            end,
            add_trigger(TaskArgs#task_args.id, TaskId, utime:unixtime(), 0, EndStage,
                TaskMark++FinTCList, TD#task.type, TD#task.kind, TaskArgs#task_args.figure#figure.lv),
            after_trigger(TD, TaskArgs),
            true
    end.

%% 手动触发任务
%% return true | {false, Code}
trigger(TaskId, TaskArgs) ->
    case trigger_no_notify(TaskId, TaskArgs) of
        {false, ErrCode} ->
            {false, ErrCode};
        true ->
            get_my_task_list(TaskArgs),
            refresh_npc_ico(TaskArgs),
            true
    end.

%% 触发后派发的事件
after_trigger(TD, #task_args{figure = #figure{career = Career, sex = Sex}} = TaskArgs) ->
    % IsDoTaskDrop = lib_task_drop_api:is_do_task_drop(TD#task.id),
    % if
    %     IsDoTaskDrop ->
    %         lib_player:apply_cast(TaskArgs#task_args.id, ?APPLY_CAST_SAVE, lib_task_drop_api, trigger_task, [TD#task.id]);
    %     true ->
    %         skip
    % end,
    lib_task_event:after_trigger(TaskArgs, TD),
    %% 转生任务接取了要通知其他模块
    if
        TD#task.type == ?TASK_TYPE_TURN ->
            case misc:is_process_alive(misc:get_player_process(TaskArgs#task_args.id)) of
                true ->
                    lib_player:apply_cast(TaskArgs#task_args.id, ?APPLY_CAST_SAVE, lib_reincarnation, trigger_task, [TD#task.id]);
                _ ->
                    %% 玩家登陆的时候刷新任务Pid是未注册的,所以要离线修改玩家转生阶段
                    lib_reincarnation:trigger_task_offline(TaskArgs#task_args.id, Career, Sex, TD#task.id)
            end;
        true -> skip
    end.
%% ================================= 完成任务 =================================
%% return true | {false, Code} | {ok, 1}
finish(TaskId, ParamList, TaskArgs) ->
    case is_finish(TaskId, TaskArgs) of
        false ->
            {false, ?ERRCODE(err300_task_no_finish)};
        true ->
            do_normal_finish(TaskId, ParamList, TaskArgs)
    end.

do_normal_finish(TaskId, _ParamList, TaskArgs) ->
    #task_args{id = Id, last_task_id=OldLastTaskId} = TaskArgs,
    TD = get_data(TaskId),
    RT = get_one_trigger(TaskId),
    %% 奖励物品
    TmpItems =
        if
            TD#task.type == ?TASK_TYPE_DAILY orelse TD#task.type == ?TASK_TYPE_GUILD orelse TD#task.type == ?TASK_TYPE_DAILY_EUDEMONS ->
                calc_task_type_reward(TD#task.type, RT#role_task.lv);
            % TD#task.type == ?TASK_TYPE_TREASURE ->
            %     Items = lib_treasure_map:calc_task_reward(Id, TD#task.id);
            TD#task.type == ?TASK_TYPE_SANCTUARY_KF ->
                ServerType = lib_clusters_node_api:get_zone_mod(?MOD_C_SANCTUARY),
                SanType = case ServerType  of 2 ->?SANTYPE_1; 4 -> ?SANTYPE_2; 8 -> ?SANTYPE_3 end,
                proplists:get_value(SanType , TD#task.award_list, []);
            true ->
                get_award_item(TD, TaskArgs)
    end,
    Items = lv_up_to_100(TmpItems, TaskArgs, TaskId),
    Produce=#produce{type=task, title=data_language:get(145), content=data_language:get(146), reward=Items, show_tips=3},
    lib_goods_api:send_reward_with_mail(Id, Produce),
    {ok, BinData} = pt_300:write(30004, [TaskId, 1, Items]),
    lib_server_send:send_to_sid(TaskArgs#task_args.sid, BinData),

    %% 扣除相关物品，注意：已经在pp_task检查过数量了
    case TD#task.end_item of
        EndItem when is_list(EndItem) andalso EndItem /= [] ->
            lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, lib_task, cost_object_list, [EndItem, fin_task_cost, lists:concat(["finish_task_", TaskId])]);
        _ -> skip
    end,

    if
        TD#task.type == ?TASK_TYPE_DAILY orelse TD#task.type == ?TASK_TYPE_GUILD orelse TD#task.type == ?TASK_TYPE_DAILY_EUDEMONS ->
            case finish_task_type(TaskArgs, RT, TD) of
                {ok, _} -> true;
                {fail, ErrCode} -> {false, ErrCode};
                {false, _} -> false
            end;
        true ->
            %% 判断特殊类型的任务完成
            after_finish(TD, TaskArgs, RT),

            %% 数据库回写
            Time = utime:unixtime(),
            add_log(Id, TaskId, TD#task.type, RT#role_task.trigger_time, Time, 0, OldLastTaskId),
            %% 刷新任务
            refresh_active(TaskArgs),
            case TD#task.type of ?TASK_TYPE_AWAKE -> calc_task_attr(Id); _ -> skip end,
            case auto_trigger(TaskArgs) of
                true ->
                    true;
                _    ->
                    get_my_task_list(TaskArgs),
                    refresh_npc_ico(TaskArgs),
                    true
            end
    end.

cost_object_list(PS, ObjectList, Type, About) ->
    case lib_goods_api:cost_object_list(PS, ObjectList, Type, About) of
        {true, PS1} -> {ok, PS1};
        _ -> {ok, PS}
    end.

%% 完成任务后触发的事件
after_finish(TD, TaskArgs, RT) ->
    #task{id = TaskId, type=TaskType} = TD,
    #task_args{id = Id, last_task_id=OLastTaskId} = TaskArgs,
    lib_task_event:after_finish(TaskArgs, RT, TaskId),
    if
        TaskType == ?TASK_TYPE_MAIN andalso OLastTaskId < TaskId -> %% 主线任务
            lib_player:update_player_info(Id, [{last_task_id, TaskId}]);
        TaskType == ?TASK_TYPE_TURN -> %% 转生任务
            lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, lib_reincarnation, finish_task, [TaskId, TD#task.next]);
        true -> skip
    end,
    if
        TaskType == ?TASK_TYPE_MAIN ->
            lib_mount:task_active_base(Id, TaskId);
        TaskType == ?TASK_TYPE_SIDE ->
            lib_mount:task_active_base(Id, TaskId);
        true ->
            skip
    end.

%% 计算任务属性
calc_task_attr(RoleId) ->
    LogIdList = get_task_log_id_list(),
    F = fun(TaskId, TmpAttrList) ->
        case data_task:get(TaskId) of
            #task{type=?TASK_TYPE_AWAKE, attr_reward=AttrReward} ->
                [AttrReward|TmpAttrList];
            _ -> TmpAttrList
        end
    end,
    Attr = lib_player_attr:add_attr(record, lists:foldl(F, [], LogIdList)),
    lib_player:update_player_info(RoleId, [{task_attr, Attr}]).

%% 完成悬赏和公会周任务
finish_task_type(TaskArgs, RT, TD) ->
    #task_args{id=RoleId, last_task_id=OLastTaskId} = TaskArgs,
    #role_task{task_id=TaskId, type=TaskType} = RT,
    case data_task_lv_dynamic:get_task_type(TaskType) of
        #task_type{count = Count, module_id = ModuleId, counter_id = CounterId} ->
            case TaskType of
                ?TASK_TYPE_DAILY ->
                    FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId)+1,
                    ProduceType = finish_daily_task,
                    ActivityModSub = 1,
                    lib_achievement_api:async_event(RoleId, lib_achievement_api, bounty_fin_event, 1),
                    mod_daily:increment(RoleId, ModuleId, CounterId);
                ?TASK_TYPE_DAILY_EUDEMONS ->
                    FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId)+1,
                    ProduceType = finish_daily_task,
                    ActivityModSub = 0,
                    % lib_achievement_api:async_event(RoleId, lib_achievement_api, bounty_fin_event, 1),
                    mod_daily:increment(RoleId, ModuleId, CounterId);
                _ ->
                    %#task_args{figure = Figure} = TaskArgs,
                    %mod_guild:add_gfunds(RoleId, Figure#figure.guild_id, 10, finish_guild_task),
                    %mod_guild:add_growth(RoleId, Figure#figure.guild_id, 1,  finish_guild_task, {task_type, TaskType}),
                    %FinishCount = mod_week:get_count(RoleId, ModuleId, CounterId)+1,
                    FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId)+1,
                    ProduceType = finish_guild_task,
                    ActivityModSub = 2,
                    lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_task_fin_event, 1),
                    %mod_week:increment(RoleId, ModuleId, CounterId)
                    mod_daily:increment(RoleId, ModuleId, CounterId)
            end,

            %% 数据库回写
            add_log(RoleId, TaskId, TaskType, RT#role_task.trigger_time, utime:unixtime(), FinishCount, OLastTaskId),
            after_finish(TD, TaskArgs, RT),
            %% 特定次数给以特殊奖励
            AddRatioReward = case calc_extra_task_type_reward(TaskType, FinishCount, RT#role_task.lv) of
                [] -> []; % calc_extra_raio_item(TaskType, 1);
                Reward -> Reward % ++calc_extra_raio_item(TaskType, 1)
            end,
            lib_goods_api:send_reward_by_id(AddRatioReward, ProduceType, 0, TaskArgs#task_args.id, 3),
            {ok, BinData} = pt_300:write(30010, [TaskType, FinishCount, Count]),
            lib_server_send:send_to_uid(RoleId, BinData),
            %% 我要变强
            lib_to_be_strong:update_data_task(RoleId, TaskType, FinishCount, Count),
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_TASK, ActivityModSub),
            if
                FinishCount >= Count ->
                    %% ?ERR("finish task type:~p~n FinishCount:~p~n", [TaskType, FinishCount]),
                    get_my_task_list(TaskArgs),
                    refresh_npc_ico(TaskArgs),
                    if
                        TaskType == ?TASK_TYPE_DAILY -> {ok, ?ERRCODE(err300_daily_task_finished)};
                        TaskType == ?TASK_TYPE_DAILY_EUDEMONS -> {ok, ?ERRCODE(err300_daily_task_finished)};
                        true -> {ok, ?ERRCODE(err300_guild_task_finished)}
                    end;
                true ->
                    trigger_type_task(TaskId, TaskType, TaskArgs)
            end;
        _R ->
            ?ERR("error task type:~p~n _R:~p~n", [TaskType, _R]),
            {fail, ?FAIL}
    end.

%% 检查扣除物品
% check_task_cost_goods(TD, RT, ParamList, TaskArgs) ->
%     #task_args{id = Id, gs_dict = GsDict} = TaskArgs,
%     %% 删除回收物品
%     if
%         TD#task.end_item == [] -> ok;
%         ParamList == cost_finish -> ok;    %% 特殊任务消耗直接完成不需要扣除物品
%         true ->
%             case get_task_cost_goods(TD, RT) of
%                 [] -> ok;
%                 [{GoodsId, Num}|_] ->
%                     case data_goods_type:get(GoodsId) of
%                         #ets_goods_type{bag_location = BagLocation} ->
%                             GoodsList = lib_goods_util:get_type_goods_list(Id, GoodsId, BagLocation, GsDict),
%                             TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
%                             if
%                                 TotalNum >= Num ->
%                                     lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, lib_goods_api, goods_delete_type_list, [[{GoodsId, Num}], finish_task]),
%                                     ok;
%                                 true ->
%                                     {false, ?ERRCODE(goods_not_enough)}
%                             end;
%                         _ ->
%                             {false, ?ERRCODE(err150_no_goods)}
%                     end
%             end
%     end.

% %% 根据任务内容去扣除物品
% get_task_cost_goods(TD, RT) ->
%     if
%         TD#task.type == ?TASK_TYPE_DAILY orelse TD#task.type == ?TASK_TYPE_GUILD ->
%             #role_task{mark = Mark, kind = _Kind} = RT,
%             case lists:keyfind(?TASK_CONTENT_ITEM, 3, Mark) of
%                 false -> [];
%                 {_State, _, _CType, Id, Num, _SceneId, _X, _Y, _Num, _FindPath} ->
%                     [{Id, Num}]
%             end;
%         true ->
%             TD#task.end_item
%     end.

%% 放弃任务
abnegate(TaskId, TaskArgs) ->
    case get_one_trigger(TaskId) of
        false -> Code = 0;
        _RT ->
            %% 删除缓存
            delete_task_bag_list(TaskId),
            %% 删除数据库
            TD = get_data(TaskId),
            del_trigger_from_sql(TaskArgs#task_args.id, TaskId, TD#task.type),
            %% 刷新
            refresh_active(TaskArgs),
            refresh_npc_ico(TaskArgs),
            Code = 1
    end,
    {ok, BinData} = pt_300:write(30005, [Code]),
    lib_server_send:send_to_sid(TaskArgs#task_args.sid, BinData).


%% 检测任务是否完成
is_finish(TaskId, TaskArgs) when is_integer(TaskId) ->
    case get_one_trigger(TaskId) of
        false -> false;
        RT -> is_finish(RT, TaskArgs)
    end;

is_finish(RT, TaskArgs) when is_record(RT, role_task) ->
    is_finish_mark(RT#role_task.mark, TaskArgs);

is_finish(Mark, TaskArgs) when is_list(Mark) ->
    is_finish_mark(Mark, TaskArgs).

is_finish_mark([], _) -> true;
is_finish_mark([#task_content{fin=1} | T], TaskArgs) -> is_finish_mark(T, TaskArgs);
is_finish_mark([TC|_T], _TaskArgs) when is_record(TC, task_content) -> false;
is_finish_mark([TC|_T], _TaskArgs) -> ?ERR("error task mark:~p~n", [TC]), false.


%% ================================= 任务进度更新 =================================
%% 已接所有任务更新判断
action(Rid, Event, ParamList) ->
    case get_task_bag_id_list() of
        []  -> false;
        RTL ->
            Result = [action_one(RT, Rid, Event, ParamList)|| RT<- RTL],
            lists:member(true, Result)
    end.

%% 单个任务更新判断
action(TaskId, Rid, Event, ParamList)->
    case get_one_trigger(TaskId) of
        false -> false;
        RT -> action_one(RT, Rid, Event, ParamList)
    end.

%% 触发任务
%% 如果是减少：
%% 判断：阶段：后退，保持，前进；
%% 变成没有完成状态
action_one(RT, Rid, Event, ParamList) ->

    F = fun(MarkItem, Update) ->
            {NewMarkItem, NewUpdate} = content(MarkItem, RT#role_task.state, Event, ParamList),
            case NewUpdate of
                true  -> {NewMarkItem, true};
                false -> {NewMarkItem, Update}
            end
    end,
    {NewMark, UpdateAble} = lists:mapfoldl(F, false, RT#role_task.mark),
    case UpdateAble of
        false ->
            false;
        true ->
            NoFinishState = [EachStage || #task_content{stage=EachStage, fin=0} <- NewMark],
            NewState = if
                NoFinishState == [] -> RT#role_task.end_state; %% 全部完成
                true -> lists:min(NoFinishState)
            end,
            %% 更新任务记录和任务状态
            %% 更新数据，但是不更新步骤状态，先缓存,下线的时候再记录数据库
            NewRT = if
                RT#role_task.type == ?TASK_TYPE_TURN -> %% 转生任务比较难，默认保存数据
                    upd_trigger(RT#role_task.role_id, RT#role_task.task_id, RT#role_task.type, NewState, NewMark),
                    RT#role_task{write_db = 0, state = NewState, mark = NewMark};
                RT#role_task.state == NewState andalso NoFinishState /= [] ->
                    RT#role_task{write_db = 1, mark = NewMark};
                true ->
                    upd_trigger(RT#role_task.role_id, RT#role_task.task_id, RT#role_task.type, NewState, NewMark),
                    RT#role_task{write_db = 0, state = NewState, mark = NewMark}
            end,
            put_task_bag_list(NewRT),
            case NewState == RT#role_task.state of
                true -> skip;
                false -> refresh_npc_ico(Rid)
            end,
            case NewState =/= RT#role_task.state orelse NoFinishState == [] of
                true -> after_action_one(NewRT, NoFinishState);
                false -> skip
            end,
            notify_client_new_mark(RT#role_task.task_id, Rid, NewState, NewMark),
            true
            % case NewState == RT#role_task.end_state of
            %     true ->
            %         case lists:last(NewMark) of
            %             [_, 1, ?TASK_CONTENT_END_TALK|_] ->
            %                 notify_client_new_mark(RT#role_task.task_id, Rid, NewState, NewMark);
            %             _R ->
            %                 auto_finish_task(Rid, RT#role_task.task_id)
            %         end,
            %         true;
            %     _ ->
            %         notify_client_new_mark(RT#role_task.task_id, Rid, NewState, NewMark),
            %         true
            % end
    end.

%% 触发阶段
after_action_one(#role_task{role_id = RoleId, task_id = TaskId, state = Stage}, NoFinishState) ->
    IsDoTaskDrop = lib_task_drop_api:is_do_task_stage_drop(TaskId, Stage),
    if
        NoFinishState == [] ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_task_drop_api, action_one_finish, [TaskId, Stage]);
        IsDoTaskDrop ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_task_drop_api, action_one, [TaskId, Stage]);
        true ->
            skip
    end.

%% 通知客户端刷新任务栏
notify_client_new_mark(TaskId, Rid, NowStage, Mark) ->
    F = fun(#task_content{stage=EStage}) -> EStage == NowStage end,
    FilterMark = lists:filter(F, Mark),
    {ok, BinData} = pt_300:write(30001, [TaskId, FilterMark]),
    lib_server_send:send_to_uid(Rid, BinData).

% %% 自动完成任务
% auto_finish_task(Player, TaskId) when is_record(Player, player_status) ->
%     TaskArgs = lib_task_api:ps2task_args(Player),
%     %% CellNum  = lib_goods_api:get_cell_num(Player),
%     mod_task:finish(Player#player_status.tid, TaskId, [], TaskArgs),
%     ok;
% auto_finish_task(PlayerId, TaskId) ->
%     case misc:get_player_process(PlayerId) of
%         Pid when is_pid(Pid) -> lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_task, auto_finish_task, [TaskId]);
%         _ -> skip
%     end.

%% 检查物品是否为任务需要 返回所需要的物品ID列表
can_gain_item() ->
    case get_task_bag_id_list() of
        []  -> [];
        RTL ->
            F = fun(RT) ->
                %% MarkList = get_phase_unfinish(RT),
                % [Id || [_, _, ?TASK_CONTENT_ITEM, _, Id, Num, _SceneId, _X, _Y, NowNum | _T] <- RT#role_task.mark, NowNum =< Num]
                [TC#task_content.id || TC <- RT#role_task.mark, can_gain_item_help(TC)]
            end,
            List = lists:flatmap(F, RTL),
            TurnDropGoods = get_turn_task_drop_goods(RTL),
            TurnDropGoods ++ List
    end.

can_gain_item_help(#task_content{ctype = ?TASK_CONTENT_COST_GOODS, now_num = NowNum, need_num = NeedNum}) when NowNum=<NeedNum -> true;
can_gain_item_help(#task_content{ctype = ?TASK_CONTENT_ITEM, now_num = NowNum, need_num = NeedNum}) when NowNum=<NeedNum -> true;
can_gain_item_help(#task_content{ctype = ?TASK_CONTENT_ITEM2, now_num = NowNum, need_num = NeedNum}) when NowNum=<NeedNum -> true;
can_gain_item_help(#task_content{fin = 0, ctype = ?TASK_CONTENT_COST_STUFF}) -> true;
can_gain_item_help(_) -> false.

get_turn_task_drop_goods(RTL) ->
    F = fun(Task, Acc) ->
        case maps:get(Task#role_task.task_id, ?AWAKENING_TASK_TASK_GOODS, false) of
            false -> Acc;
            GoodsTypeId -> [GoodsTypeId|Acc]
        end
    end,
    lists:foldl(F, [], RTL).

%% after_event(Rid) ->
%%     %% TODO 后续事件提前完成检测
%%     case preact_finish(Rid) of
%%         true -> ok;
%%         false ->
%%             %% TODO 通知角色数据更新
%%             refresh_npc_ico(Rid),
%%             {ok, BinData} = pt_300:write(30006, []),
%%             lib_server_send:send_to_uid(Rid, BinData)
%%     end.

%% 兼容可以从完成状态变成没有完成状态
content([#task_content{fin=1}|_]=C, _State, _, _) -> {C, false};
%% 装备前缀(强化，精炼等)中id是+N, NeedNum是多少件, EqPreList = [{+N, 件数}]
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {equip_pre_check, EqPreList}) ->
    case check_equip_pre_num(EqPreList, NeedNum, Id, 0) of
        {false, NowNum} ->
            {TC#task_content{now_num=NowNum}, false};
        {false, Count} ->
            {TC#task_content{now_num=Count}, true};
        {true, _Count}->
            {TC#task_content{fin=1, now_num=NeedNum}, true}
    end;
%% 装备前缀(强化，精炼等)中全身强化数目NeedNum是多少件, EqPreList = [{+N, 件数}]
content(#task_content{stage=Stage, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {equip_sum, EqPreList}) ->
    case check_equip_sum(EqPreList, NeedNum, 0) of
        {false, NowNum} ->
            {TC#task_content{now_num=NowNum}, false};
        {false, Count} ->
            {TC#task_content{now_num=Count}, true};
        {true, _Count}->
            {TC#task_content{fin=1, now_num=NeedNum}, true}
    end;

%% 检查装备列表中的是否有大于NeedNum的数量
content(#task_content{stage=Stage, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {equip_num, EqList}) ->
    case check_equip_num(EqList, NeedNum, NowNum) of
        {false, NowNum} ->
            {TC#task_content{now_num=NowNum}, false};
        {false, Count} ->
            {TC#task_content{now_num=Count}, true};
        true->
            {TC#task_content{fin=1, now_num=NeedNum}, true}
    end;
%% {more, Value}
content(#task_content{stage=Stage, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {more, Value}) ->
    case Value >= NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        false when Value /= NowNum -> {TC#task_content{now_num=Value}, true};
        false -> {TC, false}
    end;
%% {less, Value}
content(#task_content{stage=Stage, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {less, Value}) ->
    case Value =< NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        false when Value /= NowNum -> {TC#task_content{now_num=Value}, true};
        false -> {TC, false}
    end;
%% {id_more, Id, Value}
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {id_more, Id, Value}) ->
    case Value >= NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        false when Value /= NowNum -> {TC#task_content{now_num=Value}, true};
        false -> {TC, false}
    end;

content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum}=TC, Stage, ContentType, {id, Id}) ->
    {TC#task_content{fin=1, now_num=NeedNum}, true};

content(#task_content{stage=Stage, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {num, Num}) ->
    case NowNum + Num >=  NeedNum of
        true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _    -> {TC#task_content{now_num=NowNum + Num}, true}
    end;

content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {num, Id, Num}) ->
    case NowNum + Num >=  NeedNum of
        true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _    -> {TC#task_content{now_num=NowNum + Num}, true}
    end;

content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum}=TC, Stage, ContentType, {equip_stage, EquipList}) ->
    Num = length([1||{_Color, EquipStage, _Star}<-EquipList, EquipStage >= Id]),
    case Num >=  NeedNum of
        true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _    -> {TC#task_content{now_num=Num}, true}
    end;

content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {id_num_more, IdV, Num}) ->
    case IdV >= Id of
        false -> {TC, false};
        true  ->
            case NowNum + Num >=  NeedNum of
                true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
                _    -> {TC#task_content{now_num=NowNum + Num}, true}
            end
    end;

content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {id_num_list, IdNumList}) ->
    case lists:keyfind(Id, 1, IdNumList) of
        false -> {TC, false};
        {Id, Num} ->
            case NowNum + Num >=  NeedNum of
                true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
                _    -> {TC#task_content{now_num=NowNum + Num}, true}
            end
    end;
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum}=TC, Stage, ContentType, {set_num_list, IdNumList}) ->
    case lists:keyfind(Id, 1, IdNumList) of
        false -> {TC, false};
        {Id, _Num, NowNum} ->
            case NowNum >=  NeedNum of
                true -> {TC#task_content{fin=1, now_num=NeedNum}, true};
                _    -> {TC#task_content{now_num=NowNum}, true}
            end
    end;
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {id_more_list, IdNumList}) ->
    Value1 = case Id  of
        0 ->
            case lists:reverse(lists:keysort(2, IdNumList)) of
                [{_, Value}|_] -> Value;
                _ -> 0
            end;
        _ ->
            case lists:keyfind(Id, 1, IdNumList) of
                false -> 0;
                {_, Value} -> Value
            end
    end,
    case Value1 >= NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _ when Value1 > NowNum -> {TC#task_content{now_num=Value1}, true};
        _ -> {TC, false}
    end;
%% 数字列表中大于等于Id的数量N， N大于等于NeedNum则完成
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum}=TC, Stage, ContentType, {num_more_list, NumList}) ->
    Len = length([E ||E <- NumList, E >= Id]),
    case Len >= NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _     -> {TC#task_content{now_num=Len}, true}
    end;

%% 培养物
content(#task_content{stage=Stage, ctype=ContentType, id=Id, need_num=NeedNum}=TC, Stage, ContentType, {train_something, TStage, TStar}) ->
    %% 转生点亮命格的任务是3转之后才出现的，这里判断玩家等级>=4转等级对于4转后转生点亮命格任务也是满足的
    case TStage > Id orelse (TStage == Id andalso TStar >= NeedNum) of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _     -> {TC#task_content{now_num=0}, true}
    end;

%% 天命觉醒
content(#task_content{stage=Stage, ctype=?TASK_CONTENT_AWAKENING, need_num=NeedNum, now_num=NowNum}=TC, Stage, ?TASK_CONTENT_AWAKENING, {awakening, _RoleLv, Num}) ->
    case NowNum + Num >= NeedNum of % andalso RoleLv >= ?DEF_TURN_4_LV of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _     -> {TC#task_content{now_num=NowNum + Num}, true}
    end;

%% 增加材料
content(#task_content{stage=Stage, id=Id, ctype=ContentType, need_num=NeedNum, now_num=NowNum}=TC, Stage, ContentType, {add_stuff, IdNumList}) ->
    % ?MYLOG("hjhtask", "add_stuff:~n", []),
    case lists:keyfind(Id, 1, IdNumList) of
        false -> {TC, false};
        {Id, Num} ->
            case NowNum + Num >= NeedNum of
                true -> {TC#task_content{now_num=NeedNum}, true};
                _    -> {TC#task_content{now_num=NowNum + Num}, true}
            end
    end;

%% 设置材料
content(#task_content{stage=Stage, id=Id, ctype=ContentType, need_num=NeedNum}=TC, Stage, ContentType, {set_stuff, IdNumList}) ->
    % ?MYLOG("hjhtask", "set_stuff IdNumList:~p ~n", [IdNumList]),
    case lists:keyfind(Id, 1, IdNumList) of
        false -> {TC, false};
        {Id, _Num, NowNum} ->
            NewNowNum = min(NowNum, NeedNum),
            {TC#task_content{now_num=NewNowNum}, true}
    end;

%% 消耗
content(#task_content{stage=Stage, id=Id, ctype=ContentType, need_num=NeedNum}=TC, Stage, ContentType, {cost_stuff, Id, Num}) ->
    % ?MYLOG("hjhtask", "TASK_CONTENT_COST_STUFF:~n", []),
    case Num >= NeedNum of
        true  -> {TC#task_content{fin=1, now_num=NeedNum}, true};
        _     -> {TC, true}
    end;

%% 套装收集
content(#task_content{stage=Stage, id=Id, ctype=ContentType, need_num=NeedNum}=TC, Stage, ContentType, {suit_clt, SuitStatus}) ->
    case lists:keyfind(Id, 1, SuitStatus) of
        false -> {TC, true};
        {_, Num} ->
            if
                Num >= NeedNum -> {TC#task_content{fin=1, now_num = NeedNum}, true};
                true -> {TC#task_content{now_num = Num}, true}
            end
    end;

%% 容错
content(MarkItem, _Stage, _Event, _Args) ->
    {MarkItem, false}.

%% 检查装备（强化，精炼...）大于等于StrenNum有多少件
check_equip_pre_num(_EqPreList, Num, _StrenNum, Count) when Count >= Num -> {true, Num};
check_equip_pre_num([{StrNum, N}|T], Num, StrenNum, Count)->
    if
        StrNum >= StrenNum andalso N >= Num -> {true, Num};
        StrNum >= StrenNum -> check_equip_pre_num(T, Num, StrenNum, Count+N);
        true -> check_equip_pre_num(T, Num, StrenNum, Count)
    end;
check_equip_pre_num([], _Num, _StrenNum, Count) -> {false, Count}.

%% 检查装备总（强化，精炼...）数
check_equip_sum(_EqPreList, Num, Sum) when Sum >= Num -> {true, Num};
check_equip_sum([{StrNum, N}|T], Num, Sum) ->
    if
        Sum+StrNum*N >= Num -> {true, Num};
        true -> check_equip_sum(T, Num, Sum+StrNum*N)
    end;
check_equip_sum([], _Num, Sum) -> {false, Sum}.

%% 检查装备列表里面数量是否大于某个值
check_equip_num([{_, Num}|_], NeedNum, _) when Num>=NeedNum -> true;
check_equip_num([{_, Num}|T], NeedNum, Max) ->
    case Num > Max of
        true -> check_equip_num(T, NeedNum, Num);
        false -> check_equip_num(T, NeedNum, Max)
    end;
check_equip_num([], _, Max) -> {false, Max}.

%% 任务失败,算完成了任务一次(超时或者放弃)
task_fail(PS, RT) ->
    add_log(PS#player_status.id, RT#role_task.task_id, RT#role_task.type, RT#role_task.trigger_time, utime:unixtime(), 0, PS#player_status.last_task_id),
    refresh_active(PS).

%% 检查消耗
check_cost_stuff(TaskId, GoodsTypeId, Num) ->
    case get_one_trigger(TaskId) of
        false -> false;
        RT -> do_check_cost_stuff(RT#role_task.mark, GoodsTypeId, Num)
    end.

do_check_cost_stuff([], _Id, _NeedNum) -> false;
do_check_cost_stuff([#task_content{fin=0, ctype=?TASK_CONTENT_COST_STUFF, id=Id, need_num=NeedNum, now_num=_NowNum}|_T], Id, NeedNum) ->
    {true, NeedNum};
do_check_cost_stuff([_|T], Id, NeedNum) ->
    do_check_cost_stuff(T, Id, NeedNum).

%% ================================= 进程字段记录 =================================
put_task_log_list(TaskInfo) ->
    LogIdList = get_task_log_id_list(),
    case find_task_log_list(TaskInfo#role_task_log.task_id) of
        false ->
            put(log_id_list,LogIdList++[TaskInfo#role_task_log.task_id]),
            put({log, TaskInfo#role_task_log.task_id}, TaskInfo);
        Data ->
            C = Data#role_task_log.count + 1,
            put({log, TaskInfo#role_task_log.task_id}, TaskInfo#role_task_log{count = C})
    end.

find_task_log_list(TaskId) ->
    case get({log, TaskId}) of
        undefined -> false;
        Data -> Data
    end.

%% 已经完成任务的ID列表
get_task_log_id_list() ->
    case get(log_id_list) of
        undefined -> [];
        Data -> Data
    end.

find_task_log_exits(TaskId) ->
    ?IF(find_task_log_list(TaskId) == false, false, true).

delete_task_log_list(TaskId) ->
    erase({log, TaskId}).

get_task_bag_id_list() ->
    get("lib_task_task_bag_id_list").

set_task_bag_list(Data) ->
    put("lib_task_task_bag_id_list", Data).

%% 按type类型
get_task_bag_id_list_type(Type)->
    L = get_task_bag_id_list(),
    [ T || T <- L, T#role_task.type =:= Type].

%% 按TaskId类型
get_task_bag_id_list_task_id(TaskId)->
    L = get_task_bag_id_list(),
    [ T || T <- L, T#role_task.task_id =:= TaskId].

%% 按kind类型
get_task_bag_id_list_kind(Kind)->
    L = get_task_bag_id_list(),
    [ T || T <- L, T#role_task.kind =:= Kind].

put_task_bag_list(TaskInfo) ->
    List = lists:keydelete(TaskInfo#role_task.task_id, #role_task.task_id, get_task_bag_id_list()),
    put("lib_task_task_bag_id_list", [TaskInfo|List]).

find_task_bag_list(TaskId) ->
    lists:keyfind(TaskId, #role_task.task_id, get_task_bag_id_list()).

find_task_bag_exits(TaskId) ->
    ?IF(find_task_bag_list(TaskId) == false, false, true).

%% 获取任务接取时间
get_trigger_time(TaskId) ->
    case find_task_bag_list(TaskId) of
        false -> false;
        RT -> RT#role_task.trigger_time
    end.

delete_task_bag_list(TaskId) ->
    put("lib_task_task_bag_id_list", lists:keydelete(TaskId, #role_task.task_id, get_task_bag_id_list())).

get_query_cache_list() ->
    get("lib_task_query_cache_list").

set_query_cache_list(Data) ->
    put("lib_task_query_cache_list", Data).

%% 按类型
get_query_cache_list_type(Type)->
    [ T || T <- get_query_cache_list(), T#task.type =:= Type].

put_query_cache_list(TaskInfo) ->
    List = lists:keydelete(TaskInfo#task.id, 2, get_query_cache_list()),
    List1 = List ++ [TaskInfo],
    put("lib_task_query_cache_list", List1).

find_query_cache_list(TaskId) ->
    lists:keyfind(TaskId, 2, get_query_cache_list()).

find_query_cache_exits(TaskId) ->
    ?IF(find_query_cache_list(TaskId) == false, false, true).

delete_query_cache_list(TaskId) ->
    put("lib_task_query_cache_list", lists:keydelete(TaskId, #task.id, get_query_cache_list())).

%% ================================= db op =================================
%% Type:1 2 3 4需要永久保存的,事物执行task 删除和记录日志操作
add_log(Rid, Tid, Type, TriggerTime, FinishTime, Count, OLastTaskId) ->
    %% 删除已触发的任务缓存
    delete_task_bag_list(Tid),
    %% 记录任务日志缓存
    put_task_log_list(#role_task_log{role_id=Rid, task_id=Tid, type = Type, trigger_time = TriggerTime, finish_time = FinishTime}),
    %% db操作
    F = fun() ->
        if
            Type == ?TASK_TYPE_MAIN andalso OLastTaskId < Tid ->
                db:execute(io_lib:format(<<"update player_state set last_task_id = ~p where id= ~p">>, [Tid, Rid]));
            true -> skip
        end,
        if
            Type == ?TASK_TYPE_MAIN; Type == ?TASK_TYPE_AWAKE; Type == ?TASK_TYPE_TURN; Type == ?TASK_TYPE_CHAPTER; Type == ?TASK_TYPE_SIDE ->
                db:execute(lists:concat(["insert into `task_log`(`role_id`,`task_id`,`type`,`trigger_time`,`finish_time`)
                    values(",Rid,",",Tid,",",Type,",",TriggerTime,",",FinishTime,")"]));
            true ->
                db:execute(lists:concat(["insert into `task_log_clear`(`role_id`, `task_id`, `type`, `trigger_time`, `finish_time`, `count`)
                            values(",Rid,",",Tid,",",Type,",",TriggerTime,",",FinishTime,",",Count,")"]))
        end,
        del_trigger_from_sql(Rid, Tid, Type)
    end,
    db:transaction(F).

%% 删除完成日志
del_log(Rid, Tid, Type) when Type == ?TASK_TYPE_DAILY; Type == ?TASK_TYPE_GUILD; Type == ?TASK_TYPE_DAY; Type == ?TASK_TYPE_DAILY_EUDEMONS ->
    db:execute(lists:concat(["delete from `task_log_clear` where role_id=",Rid," and task_id=",Tid]));
del_log(Rid, Tid, _Type) ->
    db:execute(lists:concat(["delete from `task_log` where role_id=",Rid," and task_id=",Tid])).


%% 添加触发，新+到任务背包
add_trigger(Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark, Type, Kind, RoleLv) ->
    put_task_bag_list(#role_task{role_id = Rid, task_id = Tid, trigger_time = TriggerTime, lv = RoleLv,
            state=TaskState, type=Type, kind=Kind, end_state=TaskEndState, mark = TaskMark}),
    delete_query_cache_list(Tid),
    TaskContentSql = db_save_mark_sql(TaskMark, Rid, Tid, Type, []),
    F = fun() ->
        db_insert_task_bag(Rid, Tid, TriggerTime, TaskState, TaskEndState, Type, RoleLv),
        db:execute(TaskContentSql)
    end,
    db:transaction(F).

db_insert_task_bag(Rid, Tid, TriggerTime, TaskState, TaskEndState, Type, RoleLv) when Type == ?TASK_TYPE_DAILY;
    Type == ?TASK_TYPE_GUILD; Type == ?TASK_TYPE_DAY; Type == ?TASK_TYPE_DAILY_EUDEMONS ->
    db:execute(io_lib:format(<<"insert into `task_bag_clear`(`role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`,
     `lv`) values (~w,~w,~w,~w,~w,~w,~w)">>, [Rid, Tid, TriggerTime, TaskState, TaskEndState, Type, RoleLv]));
db_insert_task_bag(Rid, Tid, TriggerTime, TaskState, TaskEndState, Type, RoleLv) ->
    db:execute(io_lib:format(<<"insert into `task_bag`(`role_id`, `task_id`, `trigger_time`, `stage`, `edstage`, `type`,
     `lv`) values (~w,~w,~w,~w,~w,~w,~w)">>, [Rid, Tid, TriggerTime, TaskState, TaskEndState, Type, RoleLv])).

%% 更新任务记录器
upd_trigger(Rid, Tid, TaskType, TaskState, TaskMark)  when TaskType == ?TASK_TYPE_DAILY;
    TaskType == ?TASK_TYPE_GUILD; TaskType == ?TASK_TYPE_DAY; TaskType == ?TASK_TYPE_DAILY_EUDEMONS ->
    db:execute(io_lib:format(<<"update `task_bag_clear` set stage=~p where role_id=~p and task_id=~p">>, [TaskState, Rid, Tid])),
    db_save_mark(Rid, Tid, TaskType, TaskMark);
upd_trigger(Rid, Tid, TaskType, TaskState, TaskMark) ->
    db:execute(io_lib:format(<<"update `task_bag` set stage=~p where role_id=~p and task_id=~p">>, [TaskState, Rid, Tid])),
    db_save_mark(Rid, Tid, TaskType, TaskMark).

db_save_mark(Rid, Tid, TaskType, TaskMark) ->
    Sql = db_save_mark_sql(TaskMark, Rid, Tid, TaskType, []),
    db:execute(Sql).


db_save_mark_sql([#task_content{stage=Stage, cid=Cid, ctype=CType, id=Id, need_num=NeedNum, desc=Desc,
    scene_id=SceneId, x=X, y=Y, path_find=PathFind, display_num=DisPlayNum, is_guide=IsGuide, fin=Fin, now_num=NowNum}], RoleId, TaskId, TaskType, Str) ->
    Desc1 = util:fix_sql_str(Desc),
    Str1 = io_lib:format("(~w,~w,~w,~w,~w,~w,~w,~w,'~s',~w,~w,~w,~w,~w,~w,~w,~w)",
        [RoleId, TaskId, TaskType, Stage, Cid, CType, Id, NeedNum, Desc1, SceneId, X, Y, PathFind, DisPlayNum, IsGuide, Fin, NowNum]) ++ Str,
    case lists:member(TaskType, [?TASK_TYPE_DAILY, ?TASK_TYPE_GUILD, ?TASK_TYPE_DAY, ?TASK_TYPE_DAILY_EUDEMONS]) of
        true ->
            "replace into task_bag_content_clear (`role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`,
             `desc`, `scene_id`, `x`, `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num`) values "++Str1;
        _ ->
            "replace into task_bag_content (`role_id`, `task_id`, `type`, `stage`, `cid`, `ctype`, `id`, `need_num`, `desc`,
             `scene_id`, `x`, `y`, `path_find`, `display_num`, `is_guide`, `fin`, `now_num`) values "++Str1
    end;
db_save_mark_sql([#task_content{stage=Stage, cid=Cid, ctype=CType, id=Id, need_num=NeedNum, desc=Desc,
    scene_id=SceneId, x=X, y=Y, path_find=PathFind, display_num=DisPlayNum, is_guide=IsGuide, fin=Fin, now_num=NowNum}|T], RoleId, TaskId, TaskType, Str) ->
    Desc1 = util:fix_sql_str(Desc),
    Str1 = io_lib:format(", (~w,~w,~w,~w,~w,~w,~w,~w,'~s',~w,~w,~w,~w,~w,~w,~w,~w)",
        [RoleId, TaskId, TaskType, Stage, Cid, CType, Id, NeedNum, Desc1, SceneId, X, Y, PathFind, DisPlayNum, IsGuide, Fin, NowNum]) ++ Str,
    db_save_mark_sql(T, RoleId, TaskId, TaskType, Str1);
db_save_mark_sql([], _, _, _, _) -> ok.

%% 玩家下线更新需要保存数据库的操作
task_offline_up() ->
    RoleTaskList = get_task_bag_id_list(),
    F = fun(TaskInfo) ->
            if
                TaskInfo#role_task.write_db == 0 -> skip;
                true ->
                    upd_trigger(TaskInfo#role_task.role_id, TaskInfo#role_task.task_id, TaskInfo#role_task.type,
                        TaskInfo#role_task.state, TaskInfo#role_task.mark)
            end
    end,
    lists:map(F, RoleTaskList).

%% 删除触发任务
del_trigger_from_sql(Rid, Tid, TaskType) when TaskType == ?TASK_TYPE_GUILD; TaskType == ?TASK_TYPE_DAILY;
    TaskType == ?TASK_TYPE_DAY; TaskType == ?TASK_TYPE_DAILY_EUDEMONS ->
    db:execute(lists:concat(["delete from `task_bag_clear` where `role_id`=", Rid, " and `task_id`=", Tid])),
    db:execute(lists:concat(["delete from `task_bag_content_clear` where `role_id`=", Rid, " and `task_id`=", Tid]));
del_trigger_from_sql(Rid, Tid, _TaskType) ->
    db:execute(lists:concat(["delete from `task_bag` where `role_id`=", Rid, " and `task_id`=", Tid])),
    db:execute(lists:concat(["delete from `task_bag_content` where `role_id`=", Rid, " and `task_id`=", Tid])).

%% 日常任务清理
daily_clear(Clock, DelaySec)->
    spawn(fun() -> util:multiserver_delay(DelaySec, lib_task, daily_clear, [Clock]) end),
    ok.

%% 每日清理
daily_clear(Clock) ->
    db:execute("truncate table task_bag_clear"),
    db:execute("truncate table task_bag_content_clear"),
    db:execute(io_lib:format("delete from `task_log_clear` where `type` = ~w or `type` = ~w or `type` = ~w", [?TASK_TYPE_DAILY, ?TASK_TYPE_DAY, ?TASK_TYPE_DAILY_EUDEMONS])),
    [gen_server:cast(D#ets_online.pid, {'refresh_and_clear_task', Clock}) || D <- ets:tab2list(?ETS_ONLINE)],
    ?ERR("task_clear_daily ~n", []),
    ok.


%% ================================= 特殊的任务类型触发：悬赏任务和公会任务 =================================
%% return {false, ErrorCode} | {ok, ?SUCCESS}
trigger_type_task(PreTaskId, TaskType, TaskArgs)->
    %% 是否已经接取了同类型任务
    case get_task_bag_id_list_type(TaskType) of
        [] ->
            %% 过滤出响应等级的任务
            case filter_task_type_ids(PreTaskId, TaskType, TaskArgs) of
                false ->
                    {false, ?ERRCODE(err300_lv_no_task)};
                TD ->
                    TaskMark = content_to_mark(TD#task.content, TaskArgs, TD#task.id, []),
                    {EndStage, FinTCList} = case TD#task.end_talk of
                        0 -> {TD#task.state, []}; %% end_talk = 0则直接提交任务
                        _ ->
                            TmpEndStage = case TaskMark of
                                [] -> 0;
                                _ -> TD#task.state+1
                            end,
                            TC = #task_content{stage=TmpEndStage, ctype=?TASK_CONTENT_END_TALK, id=TD#task.end_npc,
                                need_num=TD#task.end_talk, display_num=1, path_find=TD#task.finish_pathfind},

                            {TmpEndStage, [init_mark(TC, TD#task.id, TaskArgs)]}
                    end,
                    add_trigger(TaskArgs#task_args.id, TD#task.id, utime:unixtime(), 0, EndStage,
                        TaskMark++FinTCList, TD#task.type, TD#task.kind, TaskArgs#task_args.figure#figure.lv),
                    get_my_task_list(TaskArgs),
                    refresh_npc_ico(TaskArgs),
                    {ok, ?SUCCESS}
            end;
        _R ->
            ?ERR("[ERROR] already trigger task type:~p~n _R:~p~n", [TaskType, _R]),
            {false, ?ERRCODE(err300_task_trigger)}
    end.

%% 过滤类型
filter_task_type_ids(PreTaskId, TaskType, TaskArgs) ->
    DynamicParam = get_dynamic_param(TaskType, TaskArgs),
    case data_task_lv_dynamic:get_type_task_id(TaskType, DynamicParam) of
        #task_lv_dynamic_id{task_ids = TaskIds} when TaskIds /= []->
            case get_a_type_task(PreTaskId, TaskType, TaskArgs#task_args.figure#figure.lv, TaskArgs#task_args.last_task_id, TaskIds) of
                false  -> ?ERR("error dynamic task_type :~p~n", [TaskType]), false;
                TaskId ->
                    case data_task_lv_dynamic:get_type_task_dynamic(TaskId, DynamicParam) of
                        #task_lv_dynamic_content{start_npc = StartNpc, end_npc = EndNpc, scene = SceneId,
                                                x = X, y = Y, content_type = ContentType, id = Id, num = NeedNum} ->
                            case data_task:get(TaskId) of
                                #task{ type = ?TASK_TYPE_SANCTUARY_KF } = TD ->
                                    TD;
                                #task{} = TD ->
                                    format_task_dynamic_content(TD, StartNpc, EndNpc, SceneId, X, Y, ContentType, Id, NeedNum);
                                _ ->
                                    ?ERR("error dynamic task_id :~p~n", [TaskId]),
                                    false
                            end;
                        _ ->
                            ?ERR("error dynamic content :~p~n", [[TaskIds, TaskId, DynamicParam]]),
                            false
                    end
                end;
        _ ->
            ?ERR("error dynamic task content :~p~n", [[TaskType, DynamicParam]]),
            false
    end.

%% 根据规则获取随机任务
%% 日常赏金和公会为5个一个循环，循环内随机只出现一次副本，节省数据库，上下线重置
get_a_type_task(_PreTaskId, TaskType, Lv, LastMainTaskId, TaskIds) when TaskType == ?TASK_TYPE_DAILY orelse TaskType == ?TASK_TYPE_GUILD ->
    IsRand = case get({"type_task_rank_list", TaskType}) of
        [TaskId|T] ->
            case data_task_lv_dynamic:get_type_task_dynamic(TaskId, Lv) of
                #task_lv_dynamic_content{} -> put({"type_task_rank_list", TaskType}, T), {true, TaskId};
                _ -> false
            end;
        _ -> false
    end,
    case IsRand of
        {true, TmpTaskId} -> TmpTaskId;
        false ->
            case rand_a_type_task(ulists:list_shuffle(TaskIds), Lv, false, []) of
                [TmpTaskId|TmpT] ->
                    put({"type_task_rank_list", TaskType}, TmpT),
                    %% 写死第一个赏金任务是400100
                    case LastMainTaskId < 100940 andalso Lv < 99 andalso TaskType == ?TASK_TYPE_DAILY of
                        true  -> 400100;
                        false -> TmpTaskId
                    end;
                _ -> false
            end
    end;
get_a_type_task(PreTaskId, _TaskType, _Lv, _LastMainTaskId, TaskIds) ->
    [TaskId|_] = ulists:list_shuffle(lists:delete(PreTaskId, TaskIds)),
    TaskId.

rand_a_type_task([TaskId|T], Lv, SeedTaskId, OtherTaskIds) ->
    case data_task_lv_dynamic:get_type_task_dynamic(TaskId, Lv) of
        #task_lv_dynamic_content{content_type=?TASK_CONTENT_DUNGEON} -> rand_a_type_task(T, Lv, TaskId, OtherTaskIds);
        #task_lv_dynamic_content{} -> rand_a_type_task(T, Lv, SeedTaskId, [TaskId|OtherTaskIds]);
        _ -> rand_a_type_task(T, Lv, SeedTaskId, [TaskId|OtherTaskIds])
    end;
rand_a_type_task([], _Lv, SeedTaskId, OtherTaskids) ->
    case SeedTaskId of
        false -> lists:sublist(OtherTaskids, 5);
        _ -> ulists:list_shuffle([SeedTaskId|lists:sublist(OtherTaskids, 4)])
    end.

%% 组装动态任务内容
format_task_dynamic_content(TD, StartNpcId, EndNpcId, SceneId, X, Y, ContentType, Id, NeedNum)->
    Content = if
        StartNpcId == 0 -> [];
        true -> [#task_content{ctype=?TASK_CONTENT_TALK, id=StartNpcId, talk_id=TD#task.start_talk, path_find=1}]
    end,
    % ?PRINT("format_task_dynamic_content ~p~n", [Content]),
    {EdStage, NewContent} = if
        ContentType == 0 orelse Id == 0 -> {0, []};
        Content == [] -> {0, [#task_content{ctype=ContentType, id=Id, need_num=NeedNum, scene_id=SceneId, x=X, y=Y}]};
        true -> {1, Content ++ [#task_content{stage=1, ctype=ContentType, id=Id, need_num=NeedNum, scene_id=SceneId, x=X, y=Y}]}
    end,
    if
        EndNpcId == 0 -> EndTalk = 0;
        true -> EndTalk = TD#task.end_talk
    end,
    TD#task{start_npc = StartNpcId, content = NewContent, end_npc = EndNpcId, state = EdStage, end_talk = EndTalk}.

%% 获取赏金(日常)和公会周任务奖励
get_special_task_reward(TaskId, Type, RoleId) ->
    case get_one_trigger(TaskId) of
        false -> Goods = [], ExtraReward = [];
        RT ->
            Goods = calc_task_type_reward(Type, RT#role_task.lv),
            case data_task_lv_dynamic:get_task_type(Type) of
                #task_type{module_id = ModuleId, counter_id = CounterId} ->
                    case Type of
                        ?TASK_TYPE_DAILY -> FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId)+1;
                        ?TASK_TYPE_GUILD -> FinishCount = mod_daily:get_count(RoleId, ModuleId, CounterId)+1;
                        _ -> FinishCount = mod_week:get_count(RoleId, ModuleId, CounterId)+1
                    end,
                    ExtraReward = calc_extra_task_type_reward(Type, FinishCount, RT#role_task.lv);
                _ ->
                    ExtraReward = []
            end
    end,
    lib_server_send:send_to_uid(RoleId, pt_300, 30012, [TaskId, Goods, ExtraReward]).

%% 根据任务类型获取动态参数
get_dynamic_param(TaskType, TaskArgs) ->
    case TaskType of
        ?TASK_TYPE_DAILY_EUDEMONS ->
            TaskArgs#task_args.scene;
        ?TASK_TYPE_SANCTUARY_KF ->
            lib_clusters_node_api:get_avg_world_lv(?MOD_C_SANCTUARY);
        _ ->
            TaskArgs#task_args.figure#figure.lv
    end.

%% 赏金任务
calc_task_type_reward(Type, Lv) ->
    calc_task_type_reward(Type, Lv, 1).

%% @param Count 任务奖励次数
calc_task_type_reward(_Type, _Lv, Count) when Count =< 0 -> [];
calc_task_type_reward(?TASK_TYPE_DAILY, Lv, Count) ->
    Exp  = round(50000000 * math:pow(1.5, (Lv-60)/120)),
    Coin = 20000, %60000+max((Lv-140)*100,0),
    [{?TYPE_EXP, ?GOODS_ID_EXP, Exp*Count}, {?TYPE_COIN, ?GOODS_ID_COIN, Coin*Count}];
%% 公会周任务
calc_task_type_reward(?TASK_TYPE_GUILD, Lv, Count) ->
    Exp = round(28000000 * math:pow(1.5, (Lv-60)/120)),
    case lib_guild_god_util:is_open(Lv) of
        true ->
            Fun = fun(_) ->  urand:rand(1, 1000) >= 400 end,
            PresNum = length(lists:filter(Fun, lists:seq(1, Count))),
            PresRewards = ?IF(PresNum =/= 0, [{?TYPE_GOODS, ?GOODS_ID_GUILD_PRESTIGE_GOOD, PresNum}], [])
                ++ [{?TYPE_GUILD_PRESTIGE, ?GOODS_ID_GUILD_PRESTIGE, 20*Count}];
        _ -> PresRewards = []
    end,
    PresRewards ++
        [
            {?TYPE_EXP, ?GOODS_ID_EXP, Exp*Count}, {?TYPE_GDONATE, ?GOODS_ID_GDONATE, 1000*Count},
            {?TYPE_GFUNDS, 0, 1*Count}, {?TYPE_GUILD_DRAGON_MAT, 36255046, 100*Count},
            {?TYPE_COIN, ?GOODS_ID_COIN, 20000*Count}
        ];
%% 帝国悬赏任务
calc_task_type_reward(?TASK_TYPE_DAILY_EUDEMONS, Lv, Count) ->
    Exp = round(21000000 * math:pow(1.5, (Lv-60)/120)),
    [{?TYPE_EXP, ?GOODS_ID_EXP, Exp*Count}, {?TYPE_CURRENCY, ?GOODS_ID_EUDEMONS_SCORE, 20*Count}];
calc_task_type_reward(_, _, _) -> [].

calc_extra_raio_item(?TASK_TYPE_GUILD, Num) ->
    calc_guild_extra_raito_item(Num);
calc_extra_raio_item(_, _) -> [].
%% 计算公会任务额外50%掉落
calc_guild_extra_raito_item(Max) -> calc_guild_extra_raito_item(0, Max, []).
calc_guild_extra_raito_item(Max, Max, Result) -> Result;
calc_guild_extra_raito_item(Min, Max, Result) ->
    Rand = urand:rand(1, 10000),
    case Rand < 5000 of
        false -> calc_guild_extra_raito_item(Min+1, Max, Result);
        true  ->
            case lists:keyfind(?GOODS_ID_GUILD_PRESTIGE_GOOD, 2, Result) of
                {_, _, Num} -> calc_guild_extra_raito_item(Min+1, Max, lists:keyreplace(?GOODS_ID_GUILD_PRESTIGE_GOOD, 2, Result, {?TYPE_GOODS, ?GOODS_ID_GUILD_PRESTIGE_GOOD, Num+1}));
                _ -> calc_guild_extra_raito_item(Min+1, Max, [{?TYPE_GOODS, ?GOODS_ID_GUILD_PRESTIGE_GOOD, 1}|Result])
            end
    end.


%% 计算赏金和公会周任务额外奖励
calc_extra_task_type_reward(_, 0, _) -> [];
calc_extra_task_type_reward(Type, FinishCount, Lv) ->
    case FinishCount rem 10 of %% 每十次一个
        % 0 when Type == ?TASK_TYPE_DAILY andalso FinishCount == 20 ->
        %     [{?TYPE_EXP, ?GOODS_ID_EXP, round(1200000 * math:pow(1.5, (Lv-170)/50))}, {?TYPE_COIN, ?GOODS_ID_COIN, 100000}];%, {?TYPE_GOODS, 32010300, 3}];
        0 when Type == ?TASK_TYPE_DAILY ->
            [{?TYPE_EXP, ?GOODS_ID_EXP, round(200000000 * math:pow(1.5, (Lv-60)/120))}, {?TYPE_COIN, ?GOODS_ID_COIN, 100000}];
        0 when Type == ?TASK_TYPE_GUILD ->
            [
                {?TYPE_EXP, ?GOODS_ID_EXP, round(100000000 * math:pow(1.5, (Lv-60)/120))},
                {?TYPE_GDONATE, ?GOODS_ID_GDONATE, 2000}, {?TYPE_GUILD_DRAGON_MAT, 36255046, 200},
                {?TYPE_GOODS, ?GOODS_ID_GUILD_PRESTIGE_GOOD, 4}, {?TYPE_COIN, ?GOODS_ID_COIN, 80000}
            ];%, {?TYPE_GOODS, 32010458, 1}];
        _ -> []
    end.

%% 扫荡公会任务和赏金任务
sweep_get_special_task_reward(TaskType, RoleId, Lv, Ps) ->
    case data_task_lv_dynamic:get_task_type(TaskType) of
        #task_type{module_id = ModuleId, count=MaxCount, counter_id = CounterId} ->
            case TaskType of
                ?TASK_TYPE_DAILY ->
                    ActivityModSub = 1,
                    LeftTaskCount = MaxCount - mod_daily:get_count(RoleId, ModuleId, CounterId);
                ?TASK_TYPE_GUILD ->
                    ActivityModSub = 2,
                    LeftTaskCount = MaxCount - mod_daily:get_count(RoleId, ModuleId, CounterId);
                _ -> ActivityModSub = -1, LeftTaskCount = -1
            end,
            if
                ActivityModSub < 0 orelse LeftTaskCount =< 0 ->
                    lib_server_send:send_to_uid(RoleId, pt_300, 30013, [?FAIL, TaskType, [], []]);
                true ->
                    Reward = calc_task_type_reward(TaskType, Lv, LeftTaskCount),% ++ calc_extra_raio_item(TaskType, LeftTaskCount),
                    ExtraReward = sweep_calc_extra_task_type_reward(TaskType, LeftTaskCount, Lv),
                    %% 发放奖励
                    Produce = #produce{type = task, title = data_language:get(145), content = data_language:get(146), reward = Reward ++ ExtraReward, show_tips=3},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    %% 更新任务数据
                    update_task_list(TaskType),
                    F = fun() ->
                            db:execute(io_lib:format("delete from `task_bag_clear` where `type` = ~w", [TaskType])),
                            db:execute(io_lib:format("delete from `task_bag_content_clear` where `type` = ~w", [TaskType])),
                            db:execute(io_lib:format("insert into `task_log_clear`(`role_id`, `task_id`, `type`, `trigger_time`, `finish_time`, `count`) values(~w, ~w, ~w, ~w, ~w, ~w)", [RoleId, 0, TaskType, utime:unixtime(), utime:unixtime(), LeftTaskCount]))
                    end,
                    db:transaction(F),
                    %% 更新日次数（赏金）或日次数（公会）
                    update_task_finish_count(RoleId, TaskType),
                    %% 扫荡任务触发成就
                    update_sweep_task_achivement(RoleId, TaskType, LeftTaskCount),
                    %% 我要变强
                    lib_to_be_strong:update_data_task(RoleId, TaskType, LeftTaskCount, LeftTaskCount),
                    %% 增加活跃度
                    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_TASK, ActivityModSub, LeftTaskCount),
                    %% 记录日志，如果是扫荡日常任务，还要增加宝宝养育值，增加嗨点
                    if
                        TaskType == ?TASK_TYPE_DAILY ->
                            lib_baby_api:finish_sweep_bounty_task(Ps, ?TASK_TYPE_DAILY, LeftTaskCount),
                            lib_hi_point_api:hi_point_task_daliy(RoleId, Ps#player_status.figure#figure.lv, LeftTaskCount),
                            lib_log_api:log_sweep_bounty_task(RoleId, Reward, ExtraReward, LeftTaskCount),
                            lib_task_api:fin_task_daily(Ps, LeftTaskCount);
                        TaskType == ?TASK_TYPE_GUILD ->
                            lib_log_api:log_sweep_guild_task(RoleId, Reward, ExtraReward, LeftTaskCount),
                            lib_task_api:fin_task_guild(Ps, LeftTaskCount);
                        true ->
                            lib_log_api:log_sweep_guild_task(RoleId, Reward, ExtraReward, LeftTaskCount)
                    end,
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ta_agent_fire, task_completed_swap, [[TaskType, LeftTaskCount]]),
                    lib_server_send:send_to_uid(RoleId, pt_300, 30013, [?SUCCESS, TaskType, Reward, ExtraReward])
            end;
        _ ->
            skip
    end.

% %% 计算扫荡赏金任务全部奖励
% sweep_calc_task_type_reward(?TASK_TYPE_DAILY, LeftTaskCount, Lv) ->
%     % F = fun(_I, RewardListAcc) ->
%     %         RewardListAcc ++ calc_task_type_reward(?TASK_TYPE_DAILY, Lv)
%     % end,
%     % RewardList = lists:foldl(F, [], lists:seq(1, LeftTaskCount)),
%     % lib_goods_api:make_reward_unique(RewardList);
%     calc_task_type_reward(?TASK_TYPE_DAILY, Lv, LeftTaskCount);
% %% 计算扫荡公会任务全部奖励
% sweep_calc_task_type_reward(?TASK_TYPE_GUILD, LeftTaskCount, Lv) ->
%     % F = fun(_I, RewardListAcc) ->
%     %         RewardListAcc ++ calc_task_type_reward(?TASK_TYPE_GUILD, Lv)
%     % end,
%     % RewardList = lists:foldl(F, [], lists:seq(1, LeftTaskCount)),
%     % lib_goods_api:make_reward_unique(RewardList);
%     calc_task_type_reward(?TASK_TYPE_GUILD, Lv, LeftTaskCount);
% sweep_calc_task_type_reward(_, _, _) -> [].

%% 计算扫荡赏金任务额外奖励
sweep_calc_extra_task_type_reward(?TASK_TYPE_DAILY, LeftTaskCount, Lv) ->
    if
        LeftTaskCount > ?EXTRA_REWARD_COUNT ->
            RewardList1= calc_extra_task_type_reward(?TASK_TYPE_DAILY, ?EXTRA_REWARD_COUNT, Lv);
        true ->
            RewardList1 = []
    end,
    RewardList2 = calc_extra_task_type_reward(?TASK_TYPE_DAILY, 2 * ?EXTRA_REWARD_COUNT, Lv),
    lib_goods_api:make_reward_unique(RewardList1 ++ RewardList2);
%% 计算扫荡公会任务额外奖励
sweep_calc_extra_task_type_reward(?TASK_TYPE_GUILD, _LeftTaskCount, Lv) ->
    calc_extra_task_type_reward(?TASK_TYPE_GUILD, ?EXTRA_REWARD_COUNT, Lv);
sweep_calc_extra_task_type_reward(_, _, _) -> [].

%% 移除任务，更新任务列表
update_task_list(TaskType) ->
    List = lists:keydelete(TaskType, #role_task.type, get_task_bag_id_list()),
    put("lib_task_task_bag_id_list", List).

%% 更新日次数（赏金）或周次数（公会）
update_task_finish_count(RoleId, TaskType) ->
    case data_task_lv_dynamic:get_task_type(TaskType) of
        #task_type{module_id = ModuleId, counter_id = CounterId, count=MaxCount} ->
            ?IF(TaskType == ?TASK_TYPE_DAILY,
                mod_daily:set_count(RoleId, ModuleId, CounterId, MaxCount),
                %mod_week:set_count(RoleId, ModuleId, CounterId, Count
                mod_daily:set_count(RoleId, ModuleId, CounterId, MaxCount
            ));
        _ -> skip
    end.

%% 扫荡任务触发成就
update_sweep_task_achivement(RoleId, TaskType, LeftTaskCount) ->
    ?IF(TaskType == ?TASK_TYPE_DAILY,
        lib_achievement_api:async_event(RoleId, lib_achievement_api, sweep_bounty_fin_event, LeftTaskCount),
        lib_achievement_api:async_event(RoleId, lib_achievement_api, sweep_guild_task_fin_event, LeftTaskCount)).


%% ================================= 任务秘籍 =================================
%% 强制接取某个任务（秘籍使用）
force_trigger(TaskId, TaskArgs) ->
    %% 删除缓存
    delete_task_bag_list(TaskId),
    delete_task_log_list(TaskId),
    %% 删除db
    TD = get_data(TaskId),
    F = fun() ->
            del_trigger_from_sql(TaskArgs#task_args.id, TaskId, TD#task.type),
            del_log(TaskArgs#task_args.id, TaskId, TD#task.type)
    end,
    db:transaction(F),
    %% 刷新
    refresh_active(TaskArgs),
    TaskArgs1 = do_dynamic_npc(TaskArgs, TD#task.npc_show),
    TaskMark = content_to_mark(TD#task.content, TaskArgs1, TaskId, []),
    {EndStage, FinTCList} = case TD#task.end_talk of
        0 ->
            {TD#task.state, []}; %% end_talk = 0则直接提交任务
        _ ->
            TmpEndStage = case TaskMark of
                [] -> TD#task.state; %% 没有其他前置，则最后这个对话就是默认0阶段
                _ -> TD#task.state+1
            end,
            TC = #task_content{stage=TmpEndStage, ctype=?TASK_CONTENT_END_TALK, id=TD#task.end_npc,
                need_num=TD#task.end_talk, display_num=1, path_find=TD#task.finish_pathfind},
            {TD#task.state+1, [init_mark(TC, TaskId, TaskArgs1)]}
    end,
    add_trigger(TaskArgs#task_args.id, TaskId, utime:unixtime(), 0, EndStage,
        TaskMark++FinTCList, TD#task.type, TD#task.kind, TaskArgs1#task_args.figure#figure.lv),
    % %% 转生任务接取了要通知其他模块
    % if
    %     TD#task.type == ?TASK_TYPE_TURN ->
    %         lib_player:apply_cast(TaskArgs#task_args.id, ?APPLY_CAST_SAVE, lib_reincarnation, trigger_task, [TD#task.id]);
    %     true -> skip
    % end,
    after_trigger(TD, TaskArgs1),
    get_my_task_list(TaskArgs1),
    refresh_npc_ico(TaskArgs1),
    ok.

%% 清理自身触发的任务
gm_refresh_task(GmType, TaskArgs) ->
    put("lib_task_task_bag_id_list", []),
    db:execute(io_lib:format("delete from task_log_clear where role_id=~w", [TaskArgs#task_args.id])),
    if
        GmType == 0 -> %% 当前已接
            db:execute(io_lib:format("delete from task_bag where role_id=~w", [TaskArgs#task_args.id])),
            db:execute(io_lib:format("delete from task_bag_content where role_id=~w", [TaskArgs#task_args.id]));
        true -> %% 删除所有的任务,从0开始
            [delete_task_log_list(Tid) || Tid <- data_task_lv:get_ids(TaskArgs#task_args.figure#figure.lv)],
            db:execute(io_lib:format("delete from task_log where role_id=~w", [TaskArgs#task_args.id])),
            db:execute(io_lib:format("delete from task_bag where role_id=~w", [TaskArgs#task_args.id])),
            db:execute(io_lib:format("delete from task_bag_content where role_id=~w", [TaskArgs#task_args.id]))
    end,
    load_role_task(TaskArgs),
    get_my_task_list(TaskArgs),
    refresh_npc_ico(TaskArgs).

gm_finish_current_task(TaskId, CellNum, TaskArgs) ->
    do_normal_finish(TaskId, CellNum, TaskArgs).


%% 直接移除某个任务（秘籍使用）
del_task(TaskId, TaskArgs) ->
    %% 删除缓存
    delete_task_bag_list(TaskId),
    delete_task_log_list(TaskId),
    TD = get_data(TaskId),
    F = fun() ->
            db:execute(io_lib:format("delete from task_bag where role_id=~w and task_id=~p",
                    [TaskArgs#task_args.id, TaskId])),
            db:execute(io_lib:format("delete from task_bag_content where role_id=~w and task_id=~p",
                    [TaskArgs#task_args.id, TaskId])),
            db:execute(io_lib:format("delete from task_bag_clear where role_id=~w and task_id=~p",
                [TaskArgs#task_args.id, TaskId])),
            db:execute(io_lib:format("delete from task_bag_content_clear where role_id=~w and task_id=~p",
                [TaskArgs#task_args.id, TaskId])),
            del_log(TaskArgs#task_args.id, TaskId, TD#task.type)
    end,
    db:transaction(F),
    %% 刷新
    refresh_active(TaskArgs),
    get_my_task_list(TaskArgs),
    refresh_npc_ico(TaskArgs),
    ok.

%% 完成该等级前的所有任务
finish_lv_task(#task_args{id=RoleId, figure=#figure{lv=Lv}} = TaskArgs, Type, LastMainTaskId) ->
    %% 删除背包任务
    db:execute(io_lib:format("delete t1 from task_bag_content t1,task_bag t2 where t1.task_id=t2.task_id and t2.role_id=~w and t2.type=~w",
        [TaskArgs#task_args.id, ?TASK_TYPE_MAIN])),
    db:execute(io_lib:format(<<"delete from `task_bag` where role_id=~p and type=~p">>, [RoleId, ?TASK_TYPE_MAIN])),
    %% 所有相应等级的任务id
    %% F = fun(EachLv, AccList) ->
    %%             TaskIds = data_task_lv:get_ids(EachLv),
    %%             lists:umerge(TaskIds, AccList)
    %%     end,
    %% AllIdList = lists:foldl(F, [], max(1, lists:seq(1, Lv-1))),
    AllLvIds = data_task_lv:get_ids(Lv-1),
    SelectIds = case Type of
        0 -> [ E|| E <- AllLvIds, E < LastMainTaskId];
        1 -> [ E|| E <- AllLvIds, E =< 100130 orelse (E < 300001 andalso E > 200001)];
        _ -> AllLvIds
    end,
    %% 任务日志
    case db:get_all(io_lib:format(<<"select task_id from task_log WHERE role_id=~p">>, [RoleId])) of
        LogIds when is_list(LogIds) -> LogIds2 = lists:umerge(LogIds);
        _ -> LogIds2 = []
    end,
    NowTime = utime:unixtime(),
    SQL3 = <<"INSERT INTO `task_log` set `role_id`=~p,`task_id`=~p,`type`=~p,`trigger_time`=~p,`finish_time`=~p">>,
    F1 = fun(TaskId, TmpList) ->
            TD = data_task:get(TaskId),
            case TD =/= null andalso  TD =/= [] andalso lists:member(TaskId, LogIds2) == false of
                true ->
                    Sql3 = io_lib:format(SQL3, [RoleId, TaskId, TD#task.type, NowTime, NowTime]),
                    db:execute(Sql3),
                    after_finish(TD, TaskArgs, #role_task{trigger_time = NowTime}),
                    case TD#task.type of
                        ?TASK_TYPE_MAIN -> [TaskId|TmpList];
                        _ -> TmpList
                    end;
                false ->
                    TmpList
            end
    end,
    MainTaskIds = lists:foldl(F1, [], SelectIds),
    %% 刷新
    load_role_task(TaskArgs),
    refresh_active(TaskArgs),
    get_my_task_list(TaskArgs),
    refresh_npc_ico(TaskArgs),
    case MainTaskIds of
        [] -> false;
        _  -> lists:last(lists:sort(MainTaskIds))
    end.

%% 获得完成的任务id
get_finish_task_id_list_on_db(_RoleId, []) -> [];
get_finish_task_id_list_on_db(RoleId, TaskIdL) ->
    db:get_all(io_lib:format(<<"select task_id from task_log where role_id=~w and task_id in (~s)">>, [RoleId, util:link_list(TaskIdL)])).

finish_eudemonstask(TaskId, ParamList, TaskArgs) ->
    do_normal_finish(TaskId, ParamList, TaskArgs).

gm_finish(TaskId, ParamList, TaskArgs) -> do_normal_finish(TaskId, ParamList, TaskArgs).


lv_up_to_100(Items, TaskArgs, TaskId) ->
    case TaskArgs#task_args.figure#figure.lv < 100 andalso TaskId == 101160 of
        true ->
            case lists:keyfind(?TYPE_EXP, 1, Items) of
                {?TYPE_EXP, GoodsTypeId, _Num} ->
                    {ok, ExpAdd} = util:for(TaskArgs#task_args.figure#figure.lv, 99, fun(I, Sum)-> Tmp=data_exp:get(I), {ok, Sum+Tmp} end, 0),
                    lists:keyreplace(?TYPE_EXP, 1, Items, {?TYPE_EXP, GoodsTypeId, ExpAdd});
                _ -> Items
            end;
        false -> Items
    end.

%% ================================= 玩家进程 =================================
