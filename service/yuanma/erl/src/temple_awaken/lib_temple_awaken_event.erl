%% ---------------------------------------------------------------------------
%% @doc lib_temple_awaken_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/8
%% @deprecated      神殿觉醒事件函数
%% ---------------------------------------------------------------------------
-module(lib_temple_awaken_event).

%% API
-compile([export_all]).

-include("common.hrl").
-include("temple_awaken.hrl").
-include("def_fun.hrl").
-include("mount.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("activitycalen.hrl").

%% 穿戴或脱取事件
%%ware_model_event(Ps, ChapterInfo, IsWare) ->
%%    #chapter_status{chapter_id = Chapter} = ChapterInfo,
%%    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(Chapter),
%%    Fun = ?IF(IsWare == ?IS_WARE, cancel_illusion, illusion_default),
%%    Mod = ?IF(lists:member(Chapter, ?TFASHION_MODELS), lib_fashion_api, lib_mount_api),
%%    ?PRINT("Fun Mod ~p ~n", [[Fun, Mod]]),
%%    case catch Mod:Fun(Ps, TypeId) of
%%        {ok, NewPs} -> skip;
%%        _Error ->
%%            ?ERR("temple_awkaen ware_model_event error : Chapter ~p IsWare ~p Mod ~p Fun ~p ~n", [Chapter, IsWare, Mod, Fun]),
%%            ?ERR("_Error ~p ~n", [_Error]),
%%            NewPs = Ps
%%    end,
%%    NewPs.

%% 脱下时装后还原下坐骑Figure值
restore_mount_status(Ps, ChapterId) ->
    #player_status{figure = Figure, status_mount = StatusMount} = Ps,
    #figure{mount_figure_ride = MFigureRide, mount_figure = MFigure} = Figure,
    case lists:keyfind(ChapterId, 1, ?ILLUSION_CHAPTERS) of
        {_, TypeId} ->
            case lists:keyfind(TypeId, #status_mount.type_id, StatusMount) of
                false ->
                    NewMFigure = lists:keydelete(TypeId, 1, MFigure),
                    NewMFigureRide = lists:keydelete(TypeId, 1, MFigureRide);
                #status_mount{figure_id = FigureId} ->
                    NewMFigure = lists:keystore(TypeId, 1, MFigure, {TypeId, FigureId}),
                    NewMFigureRide = lists:keystore(TypeId, 1, MFigureRide, {TypeId, 1})
            end,
            Figure#figure{mount_figure = NewMFigure, mount_figure_ride = NewMFigureRide};
            _ -> Figure
    end.

%% 完成主线任务事件
%% 确保老号或者异常的号完成一些卡流程的任务
%% 上线一定之间后，把对应的无需再次触发的任务类型注释掉吧
finish_main_task(Ps) ->
%%    #player_status{tid = Tid} = Ps,
    F_dun = fun(DunId, GrandArgs) ->
        case lib_dungeon_api:check_ever_finish(Ps, DunId) of
            true -> [{dun_id, DunId, 1}|GrandArgs];
            _ -> GrandArgs
        end
        end,
    DunArgs = lists:foldl(F_dun, [], ?NEED_CHECK_DUN_ID),
%%    F_task = fun(TaskId, GrandArgs2) ->
%%        case mod_task:is_finish_task_id(Tid, TaskId) of
%%            true -> [{finish_task, TaskId}|GrandArgs2];
%%            _ -> GrandArgs2
%%        end
%%        end,
%%    TaskArgs = lists:foldl(F_task, [], ?NEED_CHECK_TASK_ID),
%%    ?MYLOG("zhtemple", "Args ~p ~n", [DunArgs ++ TaskArg1s]),
    %% 老号需要处理的任务类型：等级、转生状态、活跃度等级、勋章等级
    %% 上线一段时间后记得把一下的触发任务注释掉，否则就是没意义的执行
    OldRoleNeedArgs = [
        {lv, Ps#player_status.figure#figure.lv},
        {turn, Ps#player_status.figure#figure.turn},
        {active_lv, Ps#player_status.st_liveness#st_liveness.lv},
        {medal_lv, Ps#player_status.figure#figure.medal_id}
    ],
    lib_temple_awaken_api:trigger(Ps, DunArgs  ++ OldRoleNeedArgs).
