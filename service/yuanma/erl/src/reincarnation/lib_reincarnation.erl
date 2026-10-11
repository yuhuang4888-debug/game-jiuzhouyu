%%-----------------------------------------------------------------------------
%% @Module  :       lib_reincarnation
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-07
%% @Description:    转生
%%-----------------------------------------------------------------------------
-module(lib_reincarnation).

-include("server.hrl").
-include("reincarnation.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("task.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("def_fun.hrl").

-export([
    login/3
    , repair/1
    , trigger_task/2
    , finish_task/3
    , get_reincarnation_attr/1
    , save_reincarnation_data/1
    , turn_up/1
    , get_turn_from_db/1
    , get_turn_model_id/3
    , is_suit_skill/4
    , trigger_task_offline/4
    , is_can_lv/4
    , calc_turn_attr/4
    , get_turn_skill_list/3
    ]).

-compile(export_all).

login(RoleId, Career, Sex) ->
    case db:get_row(io_lib:format(?sql_get_reincarnation_data, [RoleId])) of
        [Turn, Stage, StageTasksStr, _AttrStr] ->
            StageTasks = util:bitstring_to_term(StageTasksStr),
            #reincarnation{
                role_id = RoleId,
                turn = Turn,
                turn_stage = Stage,
                stage_tasks = StageTasks,
                attr = calc_turn_attr(Career, Sex, Turn, StageTasks)};
        _ -> #reincarnation{role_id = RoleId}
    end.

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    %% 修复转生
    TurnPS = lib_reincarnation:repair(Player),
    {ok, TurnPS};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 修复转生
repair(#player_status{reincarnation = ReincarnationStatus} = Player) ->
    % mod_task:repair_reincarnation(RoleId),
    % 转生等级
    #player_status{figure = Figure, reincarnation = ReincarnationStatus} = Player,
    #figure{career = Career, sex = Sex} = Figure,
    #reincarnation{turn = Turn} = ReincarnationStatus,
    F = fun(TmpTurn, TmpPlayer) ->
       SkillL = get_turn_skill_list(Career, Sex, TmpTurn),
       repair_skill(SkillL, TmpPlayer)
    end,
    NewPlayer = lists:foldl(F, Player, lists:seq(1, Turn)),
    repair_task(NewPlayer).

repair_skill([], Player) -> Player;
repair_skill([{SkillId, SkillLv}|T] = L, Player) ->
    #player_status{skill = #status_skill{skill_list = SkillL}} = Player,
    % 小于本等级才触发自动升级
    case lists:keyfind(SkillId, 1, SkillL) of
        {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> repair_skill(T, Player);
        _ ->
            case lib_skill:immediate_upgrade_skill(Player, SkillId) of
                {false, NewPlayer} -> repair_skill(T, NewPlayer);
                {ok, NewPlayer} -> repair_skill(L, NewPlayer)
            end
    end.

%% 自动完成上
repair_task(#player_status{reincarnation = ReincarnationStatus} = Player) ->
    % 2019-03-31截至修复,防止任务发生变化
    case utime:unixtime() =< 1553961600 of
        true ->
            #reincarnation{turn = Turn, turn_stage = Stage} = ReincarnationStatus,
            {NowTaskId, NextTaskId} = get_trigger_task_id(Turn, Stage),
            % ?MYLOG("hjhtask", "NowTaskId:~p, NextTaskId:~p ~n", [NowTaskId, NextTaskId]),
            NewPlayer = do_repair_task(NowTaskId, NextTaskId, Player),
            NewPlayer;
        false ->
            Player
    end.


do_repair_task(false, false, Player) -> Player;
do_repair_task(NowTaskId, max, Player) ->
    #player_status{tid = TaskPid} = Player,
    case mod_task:is_finish_task_id(TaskPid, NowTaskId) of
        true ->
            % ?MYLOG("hjhtask", "is_finish_task_id NowTaskId:~p ~n", [NowTaskId]),
            {ok, NewPlayer} = finish_task(Player, NowTaskId, 0),
            NewPlayer;
        _ ->
            % 判断是否接取到本任务
            case mod_task:is_trigger_task_id(TaskPid, NowTaskId) of
                true ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id NowTaskId:~p ~n", [NowTaskId]),
                    Player;
                _ ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id false NowTaskId:~p ~n", [NowTaskId]),
                    mod_task:force_trigger(TaskPid, NowTaskId, lib_task_api:ps2task_args(Player)),
                    Player
            end
    end;
do_repair_task(NowTaskId, NextTaskId, Player) ->
    #player_status{tid = TaskPid} = Player,
    case mod_task:is_finish_task_id(TaskPid, NowTaskId) of
        true ->
            % ?MYLOG("hjhtask", "is_finish_task_id NowTaskId:~p ~n", [NowTaskId]),
            % 本任务已经接取,看看下一阶任务是否能接取
            case mod_task:is_trigger_task_id(TaskPid, NextTaskId) of
                true ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id NextTaskId:~p ~n", [NextTaskId]),
                    Player;
                false ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id false NextTaskId:~p ~n", [NextTaskId]),
                    mod_task:trigger(TaskPid, NextTaskId, lib_task_api:ps2task_args(Player)),
                    Player
            end;
        _ ->
            % 判断是否接取到本任务,没有就强制接本任务
            case mod_task:is_trigger_task_id(TaskPid, NowTaskId) of
                true ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id NowTaskId:~p ~n", [NowTaskId]),
                    Player;
                _ ->
                    % ?MYLOG("hjhtask", "is_trigger_task_id false NowTaskId:~p ~n", [NowTaskId]),
                    mod_task:force_trigger(TaskPid, NowTaskId, lib_task_api:ps2task_args(Player)),
                    Player
            end
    end.

%% 1:找到当前任务
%% 2:找到前置任务
%% 3:触发的时候判断是否完成或者触发
get_trigger_task_id(_,0) -> {false, false};
get_trigger_task_id(0,1) -> {301100, 301101};
get_trigger_task_id(0,_) -> {301101, max};
get_trigger_task_id(1,1) -> {301200, 301201};
get_trigger_task_id(1,_) -> {301201, false};
get_trigger_task_id(2,1) -> {301300, 301301};
get_trigger_task_id(2,_) -> {301301, max};

% get_trigger_task_id(1,1) -> {301100, 301101};
% get_trigger_task_id(1,_) -> {301101, max};
% get_trigger_task_id(2,1) -> {301200, 301201};
% get_trigger_task_id(2,_) -> {301201, false};
% get_trigger_task_id(3,1) -> {301300, 301301};
% get_trigger_task_id(3,_) -> {301301, max};
get_trigger_task_id(_,_) -> {false, false}.

get_trigger_task_id2(1,4) -> {301103, max};
get_trigger_task_id2(2,4) -> {301202, max};
get_trigger_task_id2(3,4) -> {301302, max};
get_trigger_task_id2(_,_) -> {false, false}.

trigger_task(Player, TaskId) ->
    #player_status{sid = Sid, figure = Figure, reincarnation = ReincarnationStatus} = Player,
    #reincarnation_task_cfg{stage = Stage} = data_reincarnation:get_reincarnation_task_cfg(TaskId),
    NewReincarnationStatus = ReincarnationStatus#reincarnation{turn_stage = Stage},
    save_reincarnation_data(NewReincarnationStatus),
    lib_server_send:send_to_sid(Sid, pt_130, 13041, [Stage]),
    NewPlayer = Player#player_status{figure = Figure#figure{turn_stage = Stage}, reincarnation = NewReincarnationStatus},
    {ok, NewPlayer}.

trigger_task_offline(RoleId, Career, Sex, TaskId) ->
    ReincarnationStatus = login(RoleId, Career, Sex),
    #reincarnation_task_cfg{stage = Stage} = data_reincarnation:get_reincarnation_task_cfg(TaskId),
    NewReincarnationStatus = ReincarnationStatus#reincarnation{turn_stage = Stage},
    save_reincarnation_data(NewReincarnationStatus).

finish_task(Player, TaskId, NextTaskId) ->
    #player_status{figure = Figure, reincarnation = ReincarnationStatus} = Player,
    #figure{career = Career, sex = Sex} = Figure,
    #reincarnation{turn = Turn, stage_tasks = StageTasks, attr = Attr} = ReincarnationStatus,
    #reincarnation_task_cfg{turn = TaskTurn, stage = Stage, attr = _TaskAttrPlus} = data_reincarnation:get_reincarnation_task_cfg(TaskId),
    % 没有下一个任务就是升转，阶段设置为0
    case NextTaskId == 0 of
        true ->
            NewTurn = TaskTurn,
            NewStage = 0;
            % TurnAttrPlus = data_reincarnation:get_reincarnation_attr(Career, Sex, NewTurn);
        false ->
            NewTurn = Turn,
            NewStage = Stage
            % TurnAttrPlus = []
    end,
    % % 目前只有一个任务完成就会触发转生任务
    % case TaskTurn > Turn of
    %     true ->
    %         NewTurn = TaskTurn,
    %         NewStage = Stage,
    %         TurnAttrPlus = data_reincarnation:get_reincarnation_attr(Career, Sex, NewTurn);
    %     false ->
    %         NewTurn = Turn,
    %         NewStage = Stage,
    %         TurnAttrPlus = []
    % end,
    AllStageTaskIds = data_reincarnation:get_task_by_stage(TaskTurn, Stage),
    case AllStageTaskIds -- StageTasks of
        [TaskId] -> %% 完成当前转生阶段的所有任务
            % RealTaskAttrPlus = TaskAttrPlus,
            NewStageTasks = [];
        _ ->
            % RealTaskAttrPlus = [],
            NewStageTasks = [TaskId|StageTasks]
    end,
    % NewAttr = util:combine_list(TurnAttrPlus ++ RealTaskAttrPlus ++ Attr),
    NewAttr = calc_turn_attr(Career, Sex, NewTurn, NewStageTasks),

    NewReincarnationStatus = ReincarnationStatus#reincarnation{
        turn = NewTurn,
        turn_stage = NewStage,
        stage_tasks = NewStageTasks,
        attr = NewAttr},
    save_reincarnation_data(NewReincarnationStatus),

    NewPlayer1 = Player#player_status{figure = Figure#figure{turn = NewTurn, turn_stage = NewStage}, reincarnation = NewReincarnationStatus},
    case NewAttr =/= Attr of
        true -> %% 属性没发生变化不用重新计算
            NewPlayer2 = lib_player:count_player_attribute(NewPlayer1),
            %% 判断进程是否存活的原因是：
            %% 使用过秘籍处理离线玩家激活
            %% 不判断的话会产生错误日志到线上日志
            Pid = misc:get_player_process(Player#player_status.id),
            case misc:is_process_alive(Pid) of
                true -> lib_player:send_attribute_change_notify(NewPlayer2, ?NOTIFY_ATTR);
                _ -> skip
            end;
        false ->
            NewPlayer2 = NewPlayer1
    end,
    % ?PRINT("TaskId:~p NextTaskId:~p NewTurn:~p TaskTurn:~p ~n", [TaskId, NextTaskId, NewTurn, TaskTurn]),
    case NewTurn == TaskTurn of %% 转生成功
        true ->
            LastPlayer = turn_up(NewPlayer2);
        false ->
            LastPlayer = NewPlayer2
    end,
    {ok, LastPlayer}.

%% 转生成功
turn_up(Player) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, skill = #status_skill{skill_list = SkillL}} = Player,
    #figure{name = Name, turn = NewTurn, career = Career, sex = Sex, lv = Lv} = Figure,

    %% 日志
    TurnType = ?IF(erase('use_turn_prop') == true, 1, 0), % 是否使用转生丹转生
    lib_log_api:log_reincarnation(RoleId, TurnType, NewTurn),

    ReSkillList = data_reincarnation:get_reincarnation_reskill(Career, Sex, NewTurn),
    NewLvModel = lib_player:get_model_list(Career, Sex, NewTurn, Lv),
    {ok, PlayerAfSkill} = lib_skill:auto_learn_skill(Player#player_status{figure = Figure#figure{lv_model = NewLvModel}}, {turn, NewTurn, ReSkillList}),
    %% 自动升级转生技能
    TurnSkillL = get_turn_skill_list(Career, Sex, NewTurn),
    F = fun({SkillId, SkillLv}, TmpPlayer) ->
        % 小于本等级才触发自动升级
        case lists:keyfind(SkillId, 1, SkillL) of
            {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> TmpPlayer;
            _ ->
                {_, NewTmpPlayer} = lib_skill:immediate_upgrade_skill(TmpPlayer, SkillId),
                NewTmpPlayer
        end
    end,
    NewPlayer = lists:foldl(F, PlayerAfSkill, TurnSkillL),
    case TurnSkillL == [] of
        true -> skip;
        false -> lib_skill:get_my_skill_list(NewPlayer)
    end,
    %% 转生成功刷新任务列表
    lib_task_api:turn_up(NewPlayer),
    lib_eternal_valley_api:async_trigger(RoleId, [{turn, NewTurn}]),
    lib_server_send:send_to_sid(Sid, pt_130, 13040, [Career, Sex, NewTurn, 0]),
    %% 4转成功增加天赋点数以及开启等级上限
    case NewTurn == ?DEF_TURN_4 of
        true ->
            NewPlayer1 = lib_skill:give_def_talent_skill_point(NewPlayer),
            NewPlayer2 = lib_player:add_exp(NewPlayer1, 1, ?ADD_EXP_NO, []);
        false ->
            NewPlayer2 = NewPlayer
    end,
    NewPlayer3 = NewPlayer2,
    {ok, NewPlayer4} = lib_achievement_api:turn_event(NewPlayer3, NewTurn),
    {ok, LastPlayer} = lib_player_event:dispatch(NewPlayer4, ?EVENT_TURN_UP),
    %% 转生传闻
    lib_chat:send_TV({all}, ?MOD_PLAYER, 2, [Name, NewTurn, get_turn_name(Career, Sex, NewTurn)]),
    %% 更新场景玩家的数据
    mod_scene_agent:update(LastPlayer, [{turn, NewTurn}, {lv_model, NewLvModel}]),
    lib_offline_api:update_offline_ps(RoleId, [{turn, NewTurn}]),
    lib_scene:broadcast_player_attr(LastPlayer, NewLvModel),
    LastPlayer.

%% 使用转生丹(跳过转生任务,相当于turn秘籍)
%% @return #player_status{}
use_turn_prop(PS, GoodsInfo, _GoodsNum) ->
    #player_status{
        figure = _Figure = #figure{career = Career, sex = Sex, turn = OldTurn},
        tid = Tid, reincarnation = _Reincarnation
    } = PS,
    #goods{goods_id = GTypeId} = GoodsInfo,

    case data_reincarnation:get_reincarnation_cfg(Career, Sex, OldTurn) of
        #reincarnation_cfg{turn_cost = [{_, GTypeId, _} | _]} -> % 物品匹配上目标转生消耗
            TurnTasks = data_reincarnation:get_task_by_turn(OldTurn+1),
            [
                begin
                    IsReceiveTask = mod_task:is_trigger_task_id(Tid, TaskId),
                    IsFinishTask = mod_task:is_finish_task_id(Tid, TaskId),
                    case IsReceiveTask andalso not IsFinishTask of
                        true ->
                            put('use_turn_prop', true), % 用进程字典存放使用转生丹状态，以给后续日志使用
                            lib_task_api:gm_finish(PS, TaskId),
                            lib_task_event:finish(PS, TaskId);
                        false ->
                            skip
                    end
                end
             || TaskId <- TurnTasks
            ],
            PS;
        _ ->
            PS
    end.

%% 检查技能是否符合当前转生阶段
is_suit_skill(Career, Sex, Turn, SkillId) when Turn > 0 ->
    F = fun(TmpTurn, Acc) ->
        data_reincarnation:get_reincarnation_reskill(Career, Sex, TmpTurn) ++ Acc
    end,
    ReSkillL = lists:foldl(F, [], lists:seq(1, Turn)),
    %% 如果技能是转生过程中需要替换掉的技能则不允许玩家使用
    case lists:keyfind(SkillId, 1, ReSkillL) of
        false -> true;
        _ -> false
    end;
is_suit_skill(_, _, _, _) -> true.


get_reincarnation_attr(ReincarnationStatus) when is_record(ReincarnationStatus, reincarnation) ->
    ReincarnationStatus#reincarnation.attr;
get_reincarnation_attr(_) -> [].

save_reincarnation_data(ReincarnationStatus) ->
    #reincarnation{
        role_id = RoleId,
        turn = Turn,
        turn_stage = Stage,
        stage_tasks = StageTasks,
        attr = Attr
    } = ReincarnationStatus,
    Args = [RoleId, Turn, Stage, util:term_to_string(StageTasks), util:term_to_string(Attr)],
    db:execute(io_lib:format(?sql_save_reincarnation_data, Args)).

get_turn_from_db(RoleId) ->
    % #reincarnation{turn = Turn} = login(RoleId),
    case db:get_row(io_lib:format(?sql_get_reincarnation_turn, [RoleId])) of
        [] -> 0;
        [Turn] -> Turn
    end.

get_turn_model_id(Career, Sex, Turn) ->
    case data_reincarnation:get_reincarnation_cfg(Career, Sex, Turn) of
        #reincarnation_cfg{model_id = ModelId} -> ModelId;
        _ -> 0
    end.

get_turn_name(Career, Sex, Turn) ->
    case data_reincarnation:get_reincarnation_cfg(Career, Sex, Turn) of
        #reincarnation_cfg{name = Name} ->
            util:make_sure_binary(Name);
        _ -> <<>>
    end.

get_turn_skill_list(Career, Sex, Turn) ->
    case data_reincarnation:get_reincarnation_cfg(Career, Sex, Turn) of
        #reincarnation_cfg{turn_skill = TurnSkill} -> TurnSkill;
        _ -> []
    end.

%% 是否能升级
is_can_lv(Career, Sex, Turn, Lv) ->
    case data_reincarnation:get_reincarnation_cfg(Career, Sex, Turn) of
        #reincarnation_cfg{full_lv = FullLv} -> Lv < FullLv;
        _ -> true
    end.

%% 计算转生属性
calc_turn_attr(Career, Sex, Turn, StageTasks) ->
    TurnList = [TmpTurn||TmpTurn<-data_reincarnation:get_turn_list(Career, Sex), TmpTurn =< Turn],
    F = fun(TmpTurn) -> data_reincarnation:get_reincarnation_attr(Career, Sex, TmpTurn) end,
    TurnAttrList = lists:map(F, TurnList),
    TaskIdL = data_reincarnation:get_all_task_ids(),
    F2 = fun(TaskId, List) ->
        #reincarnation_task_cfg{turn = TmpTurn, attr = Attr} = data_reincarnation:get_reincarnation_task_cfg(TaskId),
        IsMember = lists:member(TaskId, StageTasks),
        if
            TmpTurn < Turn -> [Attr|List];
            TmpTurn == Turn andalso IsMember -> [Attr|List];
            true -> List
        end
    end,
    TaskAttrList = lists:foldl(F2, [], TaskIdL),
    lib_player_attr:add_attr(list, TurnAttrList ++ TaskAttrList).

%% 检查是否能完成任务
check_finish_task(Player, TaskId) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case data_task:get(TaskId) of
        #task{type = ?TASK_TYPE_TURN} ->
            case data_reincarnation:get_reincarnation_task_cfg(TaskId) of
                #reincarnation_task_cfg{finish_lv = FinishLv} -> FinishLv;
                _ -> FinishLv = 0
            end,
            if
                Lv < FinishLv -> {false, ?ERRCODE(err300_task_no_finish)};
                true -> {true, ?SUCCESS}
            end;
        _ ->
            {true, ?SUCCESS}
    end.


repair_task_add() ->
    %% {转生，阶数， 任务Id}
    RepairList = [{0, 4, 301103}, {1, 4, 301202}, {2, 4, 301302}],
    [begin
         Sql = io_lib:format(<<"select role_id from reincarnation where turn = ~p and stage = ~p">>, [Turn, Stage]),
         case db:get_all(Sql) of
             [] -> skip;
             RoleIdList ->
%%                 NewTurn = Turn + 1,
                 [begin
                      lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, repair_task2, [NowTaskId])

%%                      Pid = misc:get_player_process(RoleId),
%%                      case misc:is_process_alive(Pid) of
%%                          true ->
%%                              gen_server:cast(Pid, {apply_cast, ?APPLY_CAST_SAVE, ?MODULE, repair_task2, [NowTaskId]});
%%                          _ ->
%%                              repair_task2_offline(RoleId, NewTurn, 0)
%%                      end
                  end||[RoleId]<-RoleIdList]
         end
     end||{Turn, Stage, NowTaskId}<-RepairList].


repair_task2(Player, NowTaskId) ->
    finish_task(Player, NowTaskId, 0).

repair_task2_offline(RoleId, Turn, Stage) ->
    Sql = io_lib:format(<<"select career, sex from player_low where id = ~p">>, [RoleId]),
    case db:get_row(Sql) of
        [] -> skip;
        [Career, Sex] ->
            NewAttr = calc_turn_attr(Career, Sex, Turn, []),
            NewReincarnationStatus = #reincarnation{
                role_id = RoleId,
                turn = Turn,
                turn_stage = Stage,
                stage_tasks = [],
                attr = NewAttr},
            save_reincarnation_data(NewReincarnationStatus)
    end.