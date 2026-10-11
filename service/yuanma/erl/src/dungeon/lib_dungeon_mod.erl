%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本处理:副本进程
%% ---------------------------------------------------------------------------
-module(lib_dungeon_mod).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("partner.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("battle.hrl").
-include("errcode.hrl").
-include("partner_battle.hrl").
-include("relationship.hrl").
-include("goods.hrl").
-include("team.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("game.hrl").
-include("def_goods.hrl").
-include("weekly_card.hrl").

%% 说明
%%  1.副本结算流程
%%  (1)首先是通过 dungeon_result/? 函数,里面接着执行 dungeon_direct_end/?, dungeon_direct_end/? 函数会回调到玩家进程 handle_dungeon_direct_end/?
%%  (2)玩家离开的时候会执行 handle_role_out/? 函数, 处理玩家离开场景等等, 会回调到玩家进程 handle_role_out/?
%%  2.副本进入
%%  (1)普通进入:
%%  (2)重新进入:在副本中请求再进入副本,先把玩家传出去场景(玩家进程 handle_role_out/?),再进入副本
%%  3.副本退出操作
%%  (1)离线时退出,如果需要特别处理数据或者日志,则需要在 lib_dungeon:handle_role_out/3 进行操作
%%  yy3d 新加逻辑，如果是延迟的加载的副本先不初始化，
%%      1 玩家进入场景，加载副本
%%%%    2 定时器时间到了，加载副本

init(DunId, TeamId, RoleList, Args) ->
    IsDelayLoad = is_need_delay_load_dun(DunId),
    if
        IsDelayLoad == true ->
            dun_pre_load(DunId, TeamId, RoleList, Args);
        true ->
            % 设置副本关闭的时间.
            Dun = data_dungeon:get(DunId),
            #dungeon{type = DunType, level_change_type = LevelChangeType, scene_list = SceneList, time = Time} = Dun,
            Unixtime = utime:unixtime(),
            EndTime = Unixtime + Time,
            % 场景进程id
            ScenePoolId = 0,
            EnterLv = lib_dungeon:calc_enter_lv(RoleList, DunType),
            % 副本数据.
            OwnerId
                = case RoleList of
                      [First|_] ->
                          First#dungeon_role.id;
                      _ ->
                          0
                  end,
            % 基本数据初始化
            State = #dungeon_state{
                dun_id = DunId
                , scene_list = SceneList
                , dun_type = DunType
                , level_change_type = LevelChangeType
                , scene_pool_id = ScenePoolId
                , team_id = TeamId
                , enter_lv = EnterLv
                , start_time = Unixtime
                , start_time_ms = utime:longunixtime()
                , role_list = RoleList
                , wave_num = 0
                , end_time = EndTime
                , owner_id = OwnerId
            },
            % 设置副本记录
            StateAfSet = set_dun_state(Args, State),
            % 根据类型做特殊处理
            StateAfTypeInit = init_by_dun_type(StateAfSet, Dun, Args),
            % 分组
            StateAfGroup = lib_dungeon_common_event:make_group_map(StateAfTypeInit),
            % 处理触发事件
            StateAfEvent = lib_dungeon_common_event:check_and_execute(StateAfGroup),
            % 构造副本场景辅助信息
            StateAfSceneHelper = lib_dungeon_common_event:make_dungeon_scene_helper(StateAfEvent),
            % 同步到各个场景(根据类型同步数据)
            % #dungeon_state{scene_helper = #dungeon_scene_helper{hp_rate_list = HpRateList} } = StateAfSceneHelper,
            % if
            %     % DunType == ?DUNGEON_TYPE_OBLIVION -> mod_scene_agent:cast_to_scene(NowSceneId, ScenePoolId, {'update_dungeon_hp_rate', self(), HpRateList});
            %     true ->
            %         [mod_scene_agent:cast_to_scene(TmpSceneId, ScenePoolId, {'update_dungeon_hp_rate', self(), HpRateList})||TmpSceneId<-SceneList]
            % end,
            % 构造怪物辅助信息
            StateAfMonHelper = lib_dungeon_common_event:make_mon_scene_helper(StateAfSceneHelper),
            % ?PRINT("lib_dungeon_mod mon_helper:~w scene_helper:~w ~n", [StateAfMonHelper#dungeon_state.mon_helper, StateAfMonHelper#dungeon_state.scene_helper]),
            % 定时器处理
            TimeList = calc_static_time_list(StateAfMonHelper),
            StateAfRef = calc_ref(StateAfMonHelper#dungeon_state{time_list = TimeList}),
            % 同步数据到其他进程
            SetDunRecord = fun(RoleId) ->
                DunRecoed = #dungeon_record{
                    role_id = RoleId,
                    dun_pid = self(),
                    dun_id = DunId,
                    end_time = EndTime
                },
                mod_dungeon_agent:set_dungeon_record(DunRecoed)
                           end,
            % ?PRINT("dungeon: NowSceneId:~p DunId:~p ~n", [NowSceneId, DunId]),
            #dungeon_state{role_list = NewRoleList, wave_num = WaveNum} = StateAfRef,
            NextTime = get_next_wave_time(StateAfRef),
            [SetDunRecord(DunRole#dungeon_role.id) || DunRole <- NewRoleList],
            RoleIdList = [DungeonRole#dungeon_role.id||DungeonRole<-NewRoleList],
            [begin
                 pull_player_into_dungeon(StateAfRef, DungeonRole)
             end||DungeonRole<-NewRoleList],
            % 组队大厅的处理
            case TeamId > 0 of
                true -> mod_team:cast_to_team(TeamId, {'someone_enter_dungeon', RoleIdList, DunId});
                false -> skip
            end,
            FinalState = StateAfRef#dungeon_state{next_wave_time = [WaveNum, NextTime]},
            log_dungeon(FinalState, ?DUN_LOG_TYPE_ENTER, []),
            {ok, FinalState}
    end.


change_next_dungeon_id(#dungeon_state{level_change_type = ?DUN_LEVEL_CHANGE_TYPE_NO, result_type = ?DUN_RESULT_TYPE_SUCCESS} = State, Args) ->
    #dungeon_state{role_list = RoleList, dun_id = DunId} = State,
    case lists:any(fun
        (#dungeon_role{is_end_out = IsEndOut, online = Online}) ->
            IsEndOut =/= ?DUN_IS_END_OUT_NO orelse Online =/= ?DUN_ONLINE_YES
    end, RoleList) of
        true -> %% 有任何不在线或者已经出去的，不能下一关
            skip;
        false ->
            case lib_dungeon_api:get_next_dungeon_id(DunId) of
                0 ->
                    skip;
                NextDunId ->
                    case data_dungeon:get(NextDunId) of
                        #dungeon{count_cond = [], cost = []} -> %% 先处理没有次数和消耗的
                            change_to_next_dungeon(State, NextDunId, Args);
                        _ -> %% 有次数条件和消耗的要去玩家进程多判断一遍 暂时先不支持
                            todo
                    end
            end
    end;
change_next_dungeon_id(_, _) ->
    skip.

change_to_next_dungeon(State, NextDunId, Args) ->
    #dungeon_state{role_list = RoleList, team_id = TeamId} = finish_last_dungeon(State),
    F = fun
        (R) ->
            R#dungeon_role{
                dead_time = 0,
                revive_count = 0,
                revive_ref = [],
                is_end_out = 0,
                is_reward = 0,
                drop_list = [],
                drop_reward_list = [],
                calc_reward_list = [],
                level_list = [],
                drop_times_args = [],
                typical_data = #{}
            }
    end,
    RoleList1 = [F(R) || R <- RoleList],
    {ok, NewState} = init(NextDunId, TeamId, RoleList1, Args),
    NewState.

%% 根据类型特殊初始化
%% 龙纹副本
init_by_dun_type(#dungeon_state{dun_type = ?DUNGEON_TYPE_DRAGON, role_list = RoleList, dun_id = DunId, typical_data = DataMap} = State, Dun, StartArg) ->
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun),
    CurWave = lib_dun_dragon:get_enter_wave(RoleList, DunId, StartArg),
%%    ?MYLOG("cym", "Wave ~p~n", [CurWave]),
    NewCommonEventMap = calc_common_event_map_by_cur_wave(CommonEventMap, CurWave, ?dragon_dun_preparation_time),
    #dungeon{scene_id = SceneId} = Dun,
    #dungeon_state{end_time = EndTime, start_time = StartTime} = State,
    Time = EndTime - StartTime,
    CloseRef = erlang:send_after(Time*1000, self(), {'dungeon_timeout'}),
    % ?INFO("SceneId:~p ~n", [SceneId]),
    lib_dun_dragon:handle_wave_reward(RoleList, CurWave, DunId),
    NewDataMap = maps:put(?DUN_STATE_SPECIAL_KEY_DRAGON_JUMP_WAVE, CurWave, DataMap),
    State#dungeon_state{
        begin_scene_id = SceneId
        , now_scene_id = SceneId
        , open_scene_list = [SceneId]
        , common_event_map = NewCommonEventMap
        , level = 0
        , wave_num = CurWave
        , finish_wave_list = [CurWave]
        , close_ref = CloseRef
        , typical_data = NewDataMap
    };
%% 使魔副本
init_by_dun_type(#dungeon_state{dun_type = ?DUNGEON_TYPE_PET2} = State, Dun, _StartArg)->
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun),
    #dungeon{scene_id = SceneId} = Dun,
    #dungeon_state{end_time = EndTime, start_time = StartTime} = State,
    Time = EndTime - StartTime,
    CloseRef = erlang:send_after(Time*1000, self(), {'dungeon_timeout'}),
    % ?MYLOG("cym", "SceneId:~p ~n", [SceneId]),
    NewState =
        State#dungeon_state{
            begin_scene_id = SceneId
            , now_scene_id = SceneId
            , open_scene_list = [SceneId]
            , common_event_map = CommonEventMap
            , level = 0
            , close_ref = CloseRef
        },
    lib_dun_demon:create_demon(NewState, Dun),
    NewState;
%% 高级经验副本
init_by_dun_type(#dungeon_state{dun_type = ?DUNGEON_TYPE_HIGH_EXP, role_list = RoleList} = State, Dun, _StartArg) ->
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun),
    CurWave = lib_dungeon_high_exp:get_enter_wave(CommonEventMap, RoleList),
    ?MYLOG("hjhhigh", "CurWave:~p ~n", [CurWave]),
    NewCommonEventMap = lib_dungeon_level_mod:calc_common_event_map_by_cur_wave(CommonEventMap, CurWave),
    #dungeon{scene_id = SceneId} = Dun,
    #dungeon_state{end_time = EndTime, start_time = StartTime} = State,
    Time = EndTime - StartTime,
    CloseRef = erlang:send_after(Time*1000, self(), {'dungeon_timeout'}),
    State#dungeon_state{
        begin_scene_id = SceneId
        , now_scene_id = SceneId
        , open_scene_list = [SceneId]
        , common_event_map = NewCommonEventMap
        , level = 0
        , wave_num = CurWave
        , finish_wave_list = [CurWave]
        , close_ref = CloseRef
    };
init_by_dun_type(#dungeon_state{level_change_type = ?DUN_LEVEL_CHANGE_TYPE_NO} = State, Dun, _StartArg) ->
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun),
    #dungeon{scene_id = SceneId} = Dun,
    #dungeon_state{end_time = EndTime, start_time = StartTime} = State,
    Time = EndTime - StartTime,
    CloseRef = erlang:send_after(Time*1000, self(), {'dungeon_timeout'}),
    % ?INFO("SceneId:~p ~n", [SceneId]),
    State#dungeon_state{
        begin_scene_id = SceneId
        , now_scene_id = SceneId
        , open_scene_list = [SceneId]
        , common_event_map = CommonEventMap
        , level = 0
        , close_ref = CloseRef
        };
init_by_dun_type(#dungeon_state{level_change_type = LevelChangeType} = State, Dun, _StartArg) when
        LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_RAND orelse
        LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_ORDER ->
    #dungeon_state{dun_id = DunId, level = Level0} = State,
    Level = ?IF(Level0 > 0, Level0, 1),
    OpenSceneList = [],
    SceneId = get_next_scene_id(State, Level),
    % ?INFO("SceneId:~p ~n", [SceneId]),
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun, SceneId),
    NewOpenSceneList = [SceneId|OpenSceneList],
    #dungeon_level{time = Time} = data_dungeon_level:get_dungeon_level(DunId, SceneId),
    Unixtime = utime:unixtime(),
    LevelEndTime = Unixtime + Time,
    LevelResult = #dungeon_level_result{level = Level, scene_id = SceneId, start_time = Unixtime, end_time = LevelEndTime},
    LevelCloseRef = erlang:send_after(Time*1000, self(), {'dungeon_level_timeout'}),
    State#dungeon_state{
        begin_scene_id = SceneId
        , now_scene_id = SceneId
        , open_scene_list = NewOpenSceneList
        , common_event_map = CommonEventMap
        , level = Level
        , level_result_list = [LevelResult]
        , level_close_ref = LevelCloseRef
        , level_start_time = Unixtime
        , level_end_time = LevelEndTime
        }.

% 获得下一个场景的id
% get_next_scene_id(
%         #dungeon_state{
%             dun_id = DunId
%             , dun_type = ?DUNGEON_TYPE_OBLIVION
%             , level_change_type = ?DUN_LEVEL_CHANGE_TYPE_RAND
%             , open_scene_list = OpenSceneList
%             }
%         , NextLevel) ->
%     lib_dungeon_oblivion_mod:rand_scene_id(DunId, NextLevel, OpenSceneList);
get_next_scene_id(#dungeon_state{dun_id = DunId}, NextLevel) ->
    data_dungeon_level:get_scene_by_lv(DunId, NextLevel).
    % lib_dungeon_level_mod:get_order_scene_id(DunId, NextLevel).

set_dun_state([], State) -> State;
set_dun_state([T|L], State) ->
    NewState = case T of
        {level, Lv} -> State#dungeon_state{level = Lv};
        {typical_data, Datas} ->
            TypicalData = setup_typical_data(State#dungeon_state.typical_data, Datas),
            State#dungeon_state{typical_data = TypicalData};
        {start_time, StartTime} -> State#dungeon_state{start_time = StartTime};
        {end_time, EndTime} -> State#dungeon_state{end_time = EndTime};
        {enter_lv, EnterLv} -> State#dungeon_state{enter_lv = EnterLv};
        {do_sth, {M, F, A}} -> M:F(State, A);
        {scene_pool_id, ScenePoolId} -> State#dungeon_state{scene_pool_id = ScenePoolId};
        {wave_num, WaveNum} -> State#dungeon_state{wave_num = WaveNum};
        _ -> State
    end,
    set_dun_state(L, NewState).

%% 计算定时器
calc_ref(State) ->
    #dungeon_state{time_list = TimeList, ref = OldRef} = State,
    util:cancel_timer(OldRef),
    case TimeList == [] of
        true -> NewTimeList = TimeList, Ref = none;
        false ->
            EventTime = lists:min(TimeList),
            NewTimeList = [Tmp||Tmp<-TimeList, Tmp>EventTime],
            Diff = EventTime - utime:unixtime(),
            % 最小都要100毫秒
            TimeGap = max(Diff*1000, 100),
            Ref = erlang:send_after(TimeGap, self(), {'dispatch_event_time', EventTime})
    end,
    State#dungeon_state{time_list = NewTimeList, ref = Ref}.

%% 计算静态的时间列表
calc_static_time_list(State) ->
    #dungeon_state{start_time = StartTime, level_start_time = LevelStartTime, common_event_map = CommonEventMap} = State,
    F = fun(#dungeon_common_event{event_list = EventList}, TmpList) -> EventList ++ TmpList end,
    CommonEventList = maps:values(CommonEventMap),
    EventList = lists:foldl(F, [], CommonEventList),
    TimeList = do_calc_static_time_list(EventList, StartTime, LevelStartTime, []),
    TimeList.

do_calc_static_time_list([], _StartTime, _LevelStartTime, TimeList) -> TimeList;
do_calc_static_time_list([#dungeon_event{type = Type}|EventList], StartTime, LevelStartTime, TimeList) ->
    case Type of
        {dungeon_time, Time} -> NewTimeList = [StartTime+Time|TimeList];
        {level_time, Time} -> NewTimeList = [LevelStartTime+Time|TimeList];
        _ -> NewTimeList = TimeList
    end,
    do_calc_static_time_list(EventList, StartTime, LevelStartTime, NewTimeList).

%% 清理副本的定时器(副本流程定时器关闭)
clear_ref(State) ->
    #dungeon_state{
        role_list = RoleList, common_event_map = CommonEventMap, ref = Ref, close_ref = CloseRef,
        level_close_ref = LevelCloseRef, level_change_ref = LevelChangeRef, wave_close_ref = WaveCloseRef
        } = State,
    F = fun(#dungeon_common_event{create_ref = CreateRef}) -> util:cancel_timer(CreateRef) end,
    CommonEventList = maps:values(CommonEventMap),
    lists:foreach(F, CommonEventList),
    F2 = fun(#dungeon_role{revive_ref = ReviveRef}) ->
        util:cancel_timer(ReviveRef)
        % util:cancel_timer(DelayLogoutRef)
    end,
    lists:foreach(F2, RoleList),
    util:cancel_timer(Ref),
    util:cancel_timer(CloseRef),
    util:cancel_timer(LevelCloseRef),
    util:cancel_timer(LevelChangeRef),
    util:cancel_timer(WaveCloseRef),
    ok.

%% 更新玩家信息
update_dungeon_role(State, RoleId, AttrList) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {ok, State};
        DungeonRole ->
            NewDungeonRole = do_update_dungeon_role(AttrList, DungeonRole),
            NewRoleList = lists:keyreplace(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            {ok, NewState}
    end.

do_update_dungeon_role([], DungeonRole) -> DungeonRole;
do_update_dungeon_role([H|T], DungeonRole) ->
    case H of
        {figure, Figure} -> NewDungeonRole = DungeonRole#dungeon_role{figure = Figure};
        {pid, Pid} -> NewDungeonRole = DungeonRole#dungeon_role{pid = Pid};
%%        {sid, Sid} -> NewDungeonRole = DungeonRole#dungeon_role{sid = Sid};
        {dead_time, DeadTime} -> NewDungeonRole = DungeonRole#dungeon_role{dead_time = DeadTime};
        {revive_count, ReviveCount} -> NewDungeonRole = DungeonRole#dungeon_role{revive_count = ReviveCount};
        {team_position, TeamPosition} -> NewDungeonRole = DungeonRole#dungeon_role{team_position = TeamPosition};
        {lv, Lv} ->
            #dungeon_role{figure = Figure} = DungeonRole,
            NewDungeonRole = DungeonRole#dungeon_role{figure = Figure#figure{lv = Lv}};
        {setting_list, SettingList} -> NewDungeonRole = DungeonRole#dungeon_role{setting_list = SettingList};
        {count, Count} -> NewDungeonRole = DungeonRole#dungeon_role{count = Count};
        _ ->
            NewDungeonRole = DungeonRole
    end,
    do_update_dungeon_role(T, NewDungeonRole).

%% 玩家升级
role_lv_up(State, RoleId, Lv) ->
    {ok, NewState} = update_dungeon_role(State, RoleId, [{lv, Lv}]),
    #dungeon_state{dun_type = DunType, role_list = RoleList, end_time = EndTime} = NewState,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> skip;
        #dungeon_role{node = RoleNode} ->
            lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon_api, role_lv_up, [DunType, Lv, EndTime])
    end,
    {ok, NewState}.


%% -----------------------------------------------------------------
%% 副本结算退出
%% -----------------------------------------------------------------

%% 副本结算:退出副本,副本超时,副本通关或失败这三个地方拦截对应的副本处理,不然全部默认和处理
%% 延迟登出(必须触发事件才走登出)
delay_logout(State, RoleId, Hp, HpLim) ->
    % ?PRINT("delay_logout:~p ~n", [RoleId]),
    % 更新玩家在线状态
    #dungeon_state{dun_type = DunType, role_list = RoleList, story_map = StoryMap, team_id = TeamId, result_type = ResultType} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        DungeonRole ->
            % DelayLogoutTime = utime:unixtime(),
            NewDungeonRole = DungeonRole#dungeon_role{hp = Hp, hp_lim = HpLim, online = ?DUN_ONLINE_DELAY},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            if
                TeamId > 0 ->
                    lib_dungeon_util:quit_dungeon(DunType, TeamId, RoleId, ResultType);
                true ->
                    skip
            end,
            %% 剧情处理
            case lib_dungeon_mod:is_all_role_not_on_online(NewState) of
                true ->
                    F = fun({StoryId, SubStoryId}, #story_player_record{is_end = IsEnd}, Acc) ->
                        case IsEnd == ?STORY_NOT_FINISH of
                            true ->
                                StoryEventData = #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId},
                                mod_dungeon:dispatch_dungeon_event(self(), ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, StoryEventData);
                            false ->
                                skip
                        end,
                        Acc
                    end,
                    maps:fold(F, ok, StoryMap);
                false ->
                    skip
            end,

            % NewState2 = lib_dungeon_event:handle_delay_logout(NewState, RoleId, DelayLogoutTime),
            %% 检查事件,触发结算,就退出
            % case lib_dungeon_event:handle_callback(NewState) of
            %     nothing ->
            %         quit_dungeon(NewState, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_DELAY_LOGOUT);
            %     {noreply, NewState3} ->
            %         quit_dungeon(NewState3, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_DELAY_LOGOUT)
            % end
            quit_dungeon(NewState, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_DELAY_LOGOUT)
    end.

%% 玩家登出(触发事件,登出)
logout(State, RoleId, Hp, HpLim, OffMap) ->
    % ?PRINT("logout:~p ~n", [RoleId]),
    % 更新玩家在线状态
    #dungeon_state{role_list = RoleList, dun_type = DunType} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewState = State;
        DungeonRole ->
            lib_dungeon_api:invoke(DunType, dunex_handle_logout, [DungeonRole], ok),
            NewDungeonRole = DungeonRole#dungeon_role{hp = Hp, hp_lim = HpLim, online = ?DUN_ONLINE_NO},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList}
    end,
    NewState2 = lib_dungeon_event:handle_logout(NewState),
    % 检查事件,触发结算,就退出
    case lib_dungeon_event:handle_callback(NewState2) of
        nothing -> NewState3 = NewState2;
        {noreply, NewState3} -> ok
    end,
    #dungeon_state{result_type = ResultType} = NewState3,
    % 退出默认是失败
    % ?PRINT("quit_dungeon ResultType:~p ~n", [ResultType]),
    % if
    %     ResultType == ?DUN_RESULT_TYPE_NO -> NewResultType = ?DUN_RESULT_TYPE_FAIL;
    %     true -> NewResultType = ResultType
    % end,
    quit_dungeon(NewState3, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_LOGOUT, OffMap).

%% 跳过副本(必须触发事件才走登出)
skip_dungeon(State, RoleId) ->
    % ?PRINT("skip_dungeon:~p ~n", [RoleId]),
    % ?INFO("skip_dungeon:~p common_event_map:~w ~n", [RoleId, State#dungeon_state.common_event_map]),
    NewState = lib_dungeon_event:handle_skip_dungeon(State),
    % 检查事件,触发结算,就退出
    case lib_dungeon_event:handle_callback(NewState) of
        nothing -> {noreply, NewState};
        {noreply, NewState2} ->
            #dungeon_state{result_type = ResultType} = NewState2,
            % 退出默认是失败
            % ?PRINT("skip_dungeon ResultType:~p ~n", [ResultType]),
            if
                ResultType == ?DUN_RESULT_TYPE_NO -> {noreply, NewState2};
                true -> quit_dungeon(NewState2, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_SKIP_DUNGEON)
            end
    end.

%% 主动退出(触发事件,登出)
active_quit(State, RoleId) ->
    % ?PRINT("active_quit:~p ~n", [RoleId]),
    NewState = lib_dungeon_event:handle_active_quit(State),
    % 检查事件,触发结算,就退出
    case lib_dungeon_event:handle_callback(NewState) of
        nothing -> NewState2 = NewState;
        {noreply, NewState2} -> ok
    end,
    #dungeon_state{result_type = ResultType} = NewState2,
    % 退出默认是失败
    % ?PRINT("quit_dungeon ResultType:~p ~n", [ResultType]),
    % if
    %     ResultType == ?DUN_RESULT_TYPE_NO -> NewResultType = ?DUN_RESULT_TYPE_FAIL;
    %     true -> NewResultType = ResultType
    % end,
    quit_dungeon(NewState2, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT).

%% 被动强制退出
passive_force_quit(State, RoleId) ->
    % ?PRINT("passive_force_quit:~p ~n", [RoleId]),
    #dungeon_state{result_type = ResultType} = State,
    quit_dungeon(State, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_PASSIVE_FORCE_QUIT).

%% 被动流程退出
passive_flow_quit(State, RoleId) ->
    % ?PRINT("passive_flow_quit:~p ~n", [RoleId]),
    #dungeon_state{result_type = ResultType} = State,
    quit_dungeon(State, RoleId, ResultType, ?DUN_RESULT_SUBTYPE_PASSIVE_FLOW_QUIT).

%% 退出副本
quit_dungeon(State, RoleId, ResultType, ResultSubtype) ->
    quit_dungeon(State, RoleId, ResultType, ResultSubtype, #{}).

%% @return {noreply, State} | {stop, normal, State}
quit_dungeon(State, RoleId, ResultType, ResultSubtype, OffMap) ->
    #dungeon_state{dun_type = _DunType} = State,
    % 检查是否能退出副本
    case check_quit_dungeon(State, RoleId, ResultType, ResultSubtype) of
        {stay} ->
            {noreply, State};
        {false, ErrorCode} ->
            case ResultSubtype == ?DUN_RESULT_SUBTYPE_LOGOUT of
                true -> kick_role(State, RoleId, ResultType, ResultSubtype);
                false ->
                    {ok, BinData} = pt_610:write(61002, [ErrorCode]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {noreply, State}
            end;
        {all_leave, RoleList} ->
            ?PRINT("quit dungeon all leave ~n", []),
            if
                ResultType =:= ?DUN_RESULT_TYPE_NO ->
                    ResultType1 = ?DUN_RESULT_TYPE_FAIL;
                true ->
                    ResultType1 = ResultType
            end,
            RoleList2 = [Role#dungeon_role{is_push_settle_in_ps = ?DUNGEON_FORCE_PUSH_SETTLE_YES} || Role <- RoleList],
            {noreply, State2} = dungeon_result(State#dungeon_state{role_list = RoleList2}, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ResultType1, ResultSubtype),
            F = fun(#dungeon_role{id = RId}, AccState) ->
                case AccState of
                    {noreply, TState} -> skip;
                    {stop, normal, TState} -> skip;
                    _ -> TState = AccState
                end,
                handle_role_out(TState, RId, ?DUN_LOG_TYPE_QUIT, ResultSubtype, false, OffMap)
            end,
            lists:foldl(F, State2, RoleList2);
        {only_leave, RoleList, DungeonRole} ->
            case length(RoleList)>1 orelse stop_dungeon_when_no_role(State, DungeonRole, ResultType, ResultSubtype) =:= false of
                true ->
                    if
                        ResultSubtype == ?DUN_RESULT_SUBTYPE_LOGOUT ->
                            kick_role(State, RoleId, ResultType, ResultSubtype);
                        true ->
                            if
                                State#dungeon_state.is_end =/= ?DUN_IS_END_YES ->
                                    LogType = ?DUN_LOG_TYPE_HALFWAY_QUIT;
                                true ->
                                    LogType = ?DUN_LOG_TYPE_QUIT
                            end,
                            handle_role_out(State, RoleId, LogType, ResultSubtype, false, OffMap)
                    end;
                _ ->
                    if
                        ResultType =:= ?DUN_RESULT_TYPE_NO ->
                            ResultType1 = ?DUN_RESULT_TYPE_FAIL;
                        true ->
                            ResultType1 = ResultType
                    end,
                    DungeonRole1 = DungeonRole#dungeon_role{is_push_settle_in_ps = ?DUNGEON_FORCE_PUSH_SETTLE_YES},
                    NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, DungeonRole1),
                    {noreply, NewState2} = dungeon_result(State#dungeon_state{role_list = NewRoleList}, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ResultType1, ResultSubtype),
                    handle_role_out(NewState2, RoleId, ?DUN_LOG_TYPE_QUIT, ResultSubtype, false, OffMap)
            end
    end.

%% 检查副本是否能退出
%% @return {only_leave, RoleList, DungeonRole} | {false, ErrorCode} | stay
check_quit_dungeon(State, RoleId, ResultType, ResultSubtype) ->
    #dungeon_state{dun_type = DunType, role_list = RoleList, is_end = IsEnd} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false ->
            {false, ?ERRCODE(err610_dungeon_role_not_exist)};
        DungeonRole ->
            if
                DunType == ?DUNGEON_TYPE_EXP_SINGLE ->
                    % 副本没有结束和处于登出操作,不退出副本
                    case IsEnd == ?DUN_IS_END_NO andalso ResultSubtype == ?DUN_RESULT_SUBTYPE_LOGOUT of
                        true -> {stay};
                        false -> {only_leave, RoleList, DungeonRole}
                    end;
                DunType == ?DUNGEON_TYPE_BEINGS_GATE
                    andalso DungeonRole#dungeon_role.team_position == ?TEAM_LEADER
                    andalso ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
                    % 副本完成时后队长退出众生之门副本时，其它成员也要退出
                    {all_leave, RoleList};
                true ->
                    {only_leave, RoleList, DungeonRole}
            end
    end.

%% 处理登出情况
%% @return {noreply, State} | {stop, normal, State}
kick_role(State, RoleId, ResultType, ResultSubtype) ->
    #dungeon_state{role_list = RoleList, enter_lv = EnterLv, dun_type = DunType} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{revive_ref = ReviveRef} = DungeonRole ->
            log_dungeon(State, DungeonRole, ?DUN_LOG_TYPE_HALFWAY_QUIT, [{result_type, ResultType}, {result_subtype, ResultSubtype}]),
            % util:cancel_timer(DelayLogoutRef),
            util:cancel_timer(ReviveRef),
            NewRoleList = lists:keydelete(RoleId, #dungeon_role.id, RoleList),
            mod_dungeon_agent:remove_dungeon_record(RoleId, self()),
            OnLineRoles = [R || R <- RoleList, R#dungeon_role.online =/= ?DUN_ONLINE_NO],
            NewEnterLv = lib_dungeon_api:invoke(DunType, dunex_change_lv_when_role_out, [OnLineRoles, DunType], EnterLv),
            NewState = State#dungeon_state{enter_lv = NewEnterLv, role_list = NewRoleList},
            case nobody_in_dungeon(NewState) andalso stop_dungeon_when_no_role(State, DungeonRole, ResultType, ResultSubtype) of
                true ->
                    {stop, normal, NewState};
                _ ->
                    {noreply, NewState}
            end
    end.

%% 副本超时
dungeon_timeout(State) ->
    lib_dungeon_event:dispatch_dungeon_event(State, ?DUN_EVENT_TYPE_ID_DUNGEON_TIMEOUT, undefined).

%% 波数超时
wave_timeout(State) ->
    lib_dungeon_event:dispatch_dungeon_event(State, ?DUN_EVENT_TYPE_ID_WAVE_TIMEOUT, undefined).

%% 副本关卡超时
dungeon_level_timeout(State) ->
    lib_dungeon_event:dispatch_dungeon_event(State, ?DUN_EVENT_TYPE_ID_LEVEL_TIMEOUT, undefined).

%% 副本结算:副本结束/关卡结算
%% 已经结算不会再次结算
%% @return {noreply, State}
dungeon_result(State, CommonEvent) ->
    #dungeon_state{level = ResultLevel} = State,
    #dungeon_common_event{result_type = ResultType, result_subtype = ResultSubtype, args = Args, settlement_type = SettlementType} = CommonEvent,
    % ?PRINT("dungeon_result ResultLevel:~p CommonEvent:~w~n", [ResultLevel, CommonEvent]),
    dungeon_result(State, SettlementType, ResultType, ResultSubtype, ResultLevel, Args).

dungeon_result(State, SettlementType, ResultType, ResultSubtype) ->
    #dungeon_state{level = ResultLevel} = State,
    dungeon_result(State, SettlementType, ResultType, ResultSubtype, ResultLevel, []).

dungeon_result(State, SettlementType, ResultType, ResultSubtype, Args) ->
    #dungeon_state{level = ResultLevel} = State,
    dungeon_result(State, SettlementType, ResultType, ResultSubtype, ResultLevel, Args).

%% @param ResultType:
%% @param ResultLevel
%% @param ResultSubtype
dungeon_result(#dungeon_state{is_end = ?DUN_IS_END_YES} = State, _SettlementType, _ResultType, _ResultSubtype, _ResultLevel, _Args) ->
    {noreply, State};
% 情缘副本，结算时做些处理
dungeon_result(
        #dungeon_state{dun_type = DunType, role_list = RoleList, typical_data = #{couple_dun_data := [IsEnd|_]}} = State,
        SettlementType, ResultType, ResultSubtype, _ResultLevel, Args
    ) when DunType == ?DUNGEON_TYPE_COUPLE andalso IsEnd == 0 ->
    case length(RoleList) > 1 of
        true ->
            lib_dungeon_couple:dungeon_result(State, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args);
        false ->
            #dungeon_state{typical_data = TypicalData} = State,
            NewTypicalData = maps:put(couple_dun_data, [1, 0, [], none, []], TypicalData),
            lib_dungeon_mod:dungeon_result(State#dungeon_state{typical_data = NewTypicalData}, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args)
    end;
% 副本直接结束
dungeon_result(State, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ResultType, ResultSubtype, _ResultLevel, Args) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
    Dun = data_dungeon:get(DunId),
    increment(RoleList, Dun, ResultType),
    ArgsMap = #{dun_id => DunId, dun_type => DunType, result_type => ResultType, out => #dungeon_out{} },
    NewState = dungeon_direct_end(State, ResultType, ResultSubtype, Args, ArgsMap),
    push_flow_quit_info(NewState),
    %% log_dungeon(NewState, ?DUN_LOG_TYPE_RESULT, []),
    NewState2 = handle_dungeon_result(NewState),
    case nobody_in_dungeon(NewState2) of
        true ->
            self() ! stop;
        _ ->
            ok
    end,
    {noreply, NewState2};
% 关卡完成关闭
dungeon_result(
        #dungeon_state{level_change_type = LevelChangeType} = State0
        , ?DUN_SETTLEMENT_TYPE_LEVEL_END
        , ResultType
        , _ResultSubtype
        , ResultLevel
        , Args) when LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_RAND orelse
            LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_ORDER ->
    % ?PRINT("dungeon_result DUNGEON_TYPE_OBLIVION @@@@@@@@@@@@@@@@~n", []),
    #dungeon_state{
        now_scene_id = SceneId
        , scene_pool_id = ScenePoolId
        , level = NowLevelId
        , level_result_list = LevelResultList
        , level_change_ref = OldLevelChangeRef
        } = State0,
    case lists:keyfind(ResultLevel, #dungeon_level_result.level, LevelResultList) of
        #dungeon_level_result{is_level_end = IsLevelEnd} = LevelResult when IsLevelEnd =/= ?DUN_IS_LEVEL_END_YES ->
            NewLevelResult = LevelResult#dungeon_level_result{
                result_time = utime:unixtime(), result_type = ResultType, is_level_end = ?DUN_IS_LEVEL_END_YES
                },
            State = calc_level_reward_list(State0, NewLevelResult),
            if
                % 不是当前场景且没有结算
                NowLevelId =/= ResultLevel ->
                    NewLevelResultList = lists:keystore(ResultLevel, #dungeon_level_result.level, LevelResultList, NewLevelResult),
                    NewState = State#dungeon_state{level_result_list = NewLevelResultList},
                    NewState2 = handle_level_send_reward(NewState, NewLevelResult),
                    {noreply, NewState2};
                true ->
                    % 清理
                    close_level_ref(State),
                    Pid = self(),
                    lib_mon:clear_scene_mon(SceneId, ScenePoolId, self(), 1),
                    % 因为是异步创建怪物,可能清理场景的时候怪物还在创建,导致结算的时候还生成怪物
                    spawn(fun() -> timer:sleep(1500), lib_mon:clear_scene_mon(SceneId, ScenePoolId, Pid, 1) end),
                    NewLevelResultList = lists:keystore(ResultLevel, #dungeon_level_result.level, LevelResultList, NewLevelResult),
                    NewState = State#dungeon_state{level_result_list = NewLevelResultList, callback_type = ?DUN_CALLBACK_TYPE_NORAML
                        , callback_args = undefined, level_close_ref = none, is_level_end = ?DUN_IS_LEVEL_END_YES},
                    % 奖励
                    NewState2 = handle_level_send_reward(NewState, NewLevelResult),
                    push_level_settlement(NewState2, ResultType),
                    case is_finish_all_level(NewState2) of
                        true ->
                            % ?INFO("dungeon_result!!!!!!!NewLevelResultList:~w~n", [NewLevelResultList]),
                            dungeon_result(NewState2, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ?DUN_RESULT_TYPE_SUCCESS, ResultLevel, Args);
                        false ->
                            % ?INFO("dungeon_result!!!!!!!NewLevelResultList:~w~n", [NewLevelResultList]),
                            case lists:keyfind(level_change_time, 1, Args) of
                                false -> LevelChangeTime = data_dungeon_m:get_config(level_change_time);
                                {level_change_time, LevelChangeTime} -> ok
                            end,
                            LevelChangeRef = util:send_after(OldLevelChangeRef, LevelChangeTime*1000, self(), {'change_next_level'}),
                            NewState3 = NewState2#dungeon_state{level_change_ref = LevelChangeRef},
                            {noreply, NewState3}
                    end
            end;
        _ -> {noreply, State0}
    end;
dungeon_result(State, _SettlementType, _ResultType, _ResultSubtype, _ResultLevel, _Args) ->
    {noreply, State}.

%% 增加次数
increment(RoleList, Dun, ResultType) ->
    if
        ResultType == ?DUN_RESULT_TYPE_SUCCESS -> DeductTypeList = [?DUN_COUNT_DEDUCT_SUCCESS, ?DUN_COUNT_DEDUCT_END];
        ResultType == ?DUN_RESULT_TYPE_FAIL -> DeductTypeList = [?DUN_COUNT_DEDUCT_FAIL, ?DUN_COUNT_DEDUCT_END];
        true -> DeductTypeList = []
    end,
    F = fun(DeductType) ->
        [begin
            #dungeon_role{id = RoleId, help_type = HelpType, node = RoleNode, count = Count} = DungeonRole,
            unode:apply(RoleNode, lib_dungeon, dungeon_count_increment_multi, [Dun, RoleId, HelpType, DeductType, Count])
        end||DungeonRole<-RoleList]
    end,
    lists:foreach(F, DeductTypeList),
    ok.

%% 是否完成所有的关卡
% is_finish_all_level(#dungeon_state{dun_id = DunId, dun_type = ?DUNGEON_TYPE_OBLIVION, level_result_list = LevelResultList}) ->
%     LevelList = data_dungeon_oblivion:get_level_list(DunId),
%     F = fun(TmpLevel) ->
%         case lists:keyfind(TmpLevel, #dungeon_level_result.level, LevelResultList) of
%             false -> false;
%             #dungeon_level_result{is_level_end = TmpIsLevelEnd} -> TmpIsLevelEnd == ?DUN_IS_LEVEL_END_YES
%         end
%     end,
%     lists:all(F, LevelList);
is_finish_all_level(#dungeon_state{dun_id = DunId, level_change_type = ?DUN_LEVEL_CHANGE_TYPE_ORDER, level_result_list = LevelResultList}) ->
    SceneIdList = data_dungeon_level:get_scene_id_list(DunId),
    LevelList = lists:seq(1, length(SceneIdList)),
    F = fun(TmpLevel) ->
        case lists:keyfind(TmpLevel, #dungeon_level_result.level, LevelResultList) of
            false -> false;
            #dungeon_level_result{is_level_end = TmpIsLevelEnd} -> TmpIsLevelEnd == ?DUN_IS_LEVEL_END_YES
        end
    end,
    lists:all(F, LevelList);

is_finish_all_level(_State) -> false.

%% ----------------------------------------
%% 副本结算推送
%% ----------------------------------------

%% 副本结算推送
push_settlement(#dungeon_state{role_list = RoleList} = State) ->
    F = fun(DungeonRole) -> push_settlement(State, DungeonRole) end,
    lists:foreach(F, RoleList),
    ok.

push_settlement(_State, #dungeon_role{is_push_settle = ?DUNGEON_PUSH_SETTLE_YES}) ->
    skip;
push_settlement(#dungeon_state{dun_type = DunType} = State, #dungeon_role{reward_map = RewardMap, count = Count, help_type = HelpType} = DungeonRole) ->
    case lib_dungeon_api:get_special_api_mod(DunType, dunex_push_settlement, 2) of
        undefined ->
            #dungeon_state{
                result_type = ResultType,
                dun_id = DunId,
                now_scene_id = SceneId,
                result_subtype = ResultSubtype,
                start_time = StartTime,
                result_time = EndTime
            } = State,
            Grade
                = if
                ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
                    0;
                true ->
                    Score = lib_dungeon:calc_score(State, DungeonRole#dungeon_role.id),
                    case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
                        #dungeon_grade{grade = Value} ->
                            Value;
                        _ ->
                            0
                    end
            end,
            RewardList = lib_dungeon:get_source_list(RewardMap),
            MultipleReward = maps:get(?REWARD_SOURCE_DUNGEON_MULTIPLE, RewardMap, []),
            WeeklyCardReward = maps:get(?REWARD_SOURCE_WEEKLY_CARD, RewardMap, []),
            %% 特殊处理资源副本 ，在发送结算协议之前通知客户端最新的次数
            lib_dungeon_resource:send_resource_count_info(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, DunType),
            case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                true ->
                    %% FixEndTime = ?IF( ResType == ?DUN_RESULT_SUBTYPE_NO, utime:unixtime(), EndTime),
                    SendExData = [{9, HelpType}, {10, EndTime - StartTime}];
                false ->
                    SendExData = [{9, HelpType}]
            end,
            Args = [ResultType, ResultSubtype, DunId, Grade, SceneId, RewardList, [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, MultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardReward}], SendExData, Count],
            {ok, BinData} = pt_610:write(61003, Args),
            DungeonRole#dungeon_role.help_type =/= ?HELP_TYPE_ASSIST andalso send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData);
        Mod ->
            Mod:dunex_push_settlement(State, DungeonRole)
    end.

%% 推送关卡结算
push_level_settlement(State, ResultType) ->
    #dungeon_state{dun_id = DunId, now_scene_id = NowSceneId, role_list = RoleList, level = Level} = State,
    LevelList = data_dungeon_oblivion:get_level_list(DunId),
    case Level >= length(LevelList) of
        true -> IsLastLevel = 1;
        false -> IsLastLevel = 0
    end,
    F = fun(#dungeon_role{id = RoleId, level_list = RoleLevelList, node = Node}) ->
        case lists:keyfind(Level, #dungeon_role_level.level, RoleLevelList) of
            false -> RewardList = [];
            #dungeon_role_level{reward_list = RewardList} -> ok
        end,
        {ok, BinData} = pt_610:write(61015, [DunId, NowSceneId, Level, IsLastLevel, ResultType, RewardList]),
        send_to_uid(Node, RoleId, BinData)
    end,
    lists:foreach(F, RoleList),
    ok.

%% 推流程退出时间
push_flow_quit_info(State) ->
    #dungeon_state{role_list = RoleList, flow_quit_ref = FlowQuitRef, force_quit_ref = ForceQuitRef} = State,
    if
        is_reference(FlowQuitRef) ->
            Type = 1,
            case erlang:read_timer(FlowQuitRef) of
                N when is_integer(N) -> EndTime = utime:unixtime() + N div 1000;
                _ -> EndTime = 0
            end;
        is_reference(ForceQuitRef) ->
            Type = 1,
            case erlang:read_timer(ForceQuitRef) of
                N when is_integer(N) -> EndTime = utime:unixtime() + N div 1000;
                _ -> EndTime = 0
            end;
        true ->
            Type = 0, EndTime = 0
    end,
    {ok, BinData} = pt_610:write(61018, [Type, EndTime]),
    [send_to_uid(Node, RoleId, BinData)||#dungeon_role{id = RoleId, node = Node}<-RoleList],
    ok.

%% ----------------------------------------
%% 副本结束特殊
%% ----------------------------------------

%% 副本直接结束
%% @return NewState
dungeon_direct_end(State0, ResultType, ResultSubtype, Args, ArgsMap) ->
    #dungeon_state{dun_id = DunId, start_time = StartTime, start_time_ms = StartTimeMs, team_id = TeamId, dun_type = DunType, role_list = RoleList, force_quit_ref = OldForceQuitRef,
        flow_quit_ref = OldFlowQuitRef, level_close_ref = LevelCloseRef, level_change_ref = LevelChangeRef, open_scene_list = OpenSceneList,
        wave_num = BattleWave, finish_wave_list = FinishWaveList, story_play_time_mi = StoryPlayMs} = State0,
    ResultTime = utime:unixtime(),
    ResultTimeMs = utime:longunixtime(),
    PassTime   = ResultTime - StartTime,
    State = revive_dead_man(State0),
    FinishWave = ?IF(FinishWaveList==[], 0, lists:max(FinishWaveList)),
    % State      = State0, %%副本结束后不在复活
    % 副本通关触发任务
    case ResultType == ?DUN_RESULT_TYPE_SUCCESS of
        true ->
            update_relationship(RoleList, DunId),
            [
                begin
                    #dungeon_role{id = RoleId, help_type = HelpType, node = Node, team_position = _Position, history_wave = HistoryWave,
                        pass_time_list = PassTimeList, count = Count} = Role,
                    %DataMap = #{dun_id=>DunId, dun_type=>DunType, help_type=>HelpType,achv_data=>#achv_data{subdata=#{dun_id=>DunId, dun_type=>DunType, start_time=>StartTime}}},
                    Other = lib_dungeon_api:invoke(DunType, dunex_get_other_success_data, [State, Role], []),
                    if
                        % 副本结算保留队伍,直到玩家退出
                        % TeamId > 0 andalso Position =/= ?TEAM_LEADER ->
                        %     mod_team:cast_to_team(Node, TeamId, {'quit_team', RoleId, 1});
                        % TeamId > 0 ->
                        %     TeamerList = [{SId, Id} || #dungeon_role{id = Id, server_id = SId} <- RoleList, Id =/= RoleId],
                        %     lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_dungeon_team, check_continue_dungeon, [DunId, TeamerList]);
                        true ->
                            ok
                    end,
                    DunegonEndInfo = #dungeon_end_info{
	                    help_type = HelpType, dun_pid = self(), dun_id = DunId, dun_type = DunType
	                    , team_id = TeamId, result_type = ResultType, result_subtype = ResultSubtype, battle_wave = BattleWave
	                    , history_wave = HistoryWave, pass_time_list= PassTimeList, finish_wave = FinishWave, start_time = StartTime
                    },
                    apply_cast_to_local(State, Role, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_dungeon, replace_dungeon_wave, [DunegonEndInfo]]),
                    apply_cast_to_local(State, Role, lib_dungeon, replace_dungeon_wave_db, [RoleId, DunegonEndInfo]),
                    Data = #callback_dungeon_succ{
                        dun_id=DunId, dun_type=DunType, help_type=HelpType,start_time=StartTime, start_time_ms = StartTimeMs,
                        story_play_time_mi = StoryPlayMs, result_time_ms = ResultTimeMs, pass_time = PassTime, count = Count, other = Other
                    },
                    unode:apply(Node, lib_player_event, async_dispatch, [RoleId, ?EVENT_DUNGEON_SUCCESS, Data])
                    % lib_player_event:async_dispatch(RoleId, ?EVENT_DUNGEON_SUCCESS, Data)
                end || Role<-RoleList];
        false ->
            [
                begin
                    #dungeon_role{id = RoleId, help_type = HelpType, node = Node, team_position = _Position, history_wave = HistoryWave,
                        pass_time_list = PassTimeList, count = Count} = Role,
                    Other = lib_dungeon_api:invoke(DunType, dunex_get_other_fail_data, [State, Role], []),
                    DunegonEndInfo = #dungeon_end_info{
                        help_type = HelpType, dun_pid = self(), dun_id = DunId, dun_type = DunType
                        , team_id = TeamId, result_type = ResultType, result_subtype = ResultSubtype, battle_wave = BattleWave
                        , history_wave = HistoryWave, pass_time_list= PassTimeList, finish_wave = FinishWave, start_time = StartTime
                    },
%%                    ?MYLOG("dundragon", "PassTimeList ~p~n", [PassTimeList]),
                    apply_cast_to_local(State, Role, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_dungeon, replace_dungeon_wave, [DunegonEndInfo]]),
                    apply_cast_to_local(State, Role, lib_dungeon, replace_dungeon_wave_db, [RoleId, DunegonEndInfo]),
                    Data = #callback_dungeon_fail{
                        dun_id=DunId, dun_type=DunType, help_type=HelpType,start_time=StartTime, start_time_ms = StartTimeMs, result_time_ms = ResultTimeMs,
                        story_play_time_mi = StoryPlayMs, pass_time = PassTime, count = Count, other = Other
                    },
                    unode:apply(Node, lib_player_event, async_dispatch, [RoleId, ?EVENT_DUNGEON_FAIL, Data])
                end || Role<-RoleList]
    end,
    % 通知玩家副本结束
    NewArgsMap = ArgsMap#{result_type => ResultType},
    notice_dungeon_direct_end_to_all(State, ResultType, ResultSubtype, NewArgsMap),
    % 通知队伍进程
    mod_team:cast_to_team(TeamId, {'dungeon_direct_end', self()}),
    % 清理数据:清理定时器,清理副本记录,清理场景怪物
    #dungeon_state{scene_list = SceneList, scene_pool_id = ScenePoolId} = State,
    clear_ref(State),
    % 清理关卡结束定时器
    util:cancel_timer(LevelCloseRef),
    % 清理关卡切换定时器
    util:cancel_timer(LevelChangeRef),
    [lib_mon:clear_scene_mon(SceneId, ScenePoolId, self(), 1)|| SceneId<- (SceneList ++ OpenSceneList) ],
    % 流程登出定时器
    case lists:keyfind(quit_time, 1, Args) of
        false ->
            % 强制登出定时器
            DefQuitTime =
            case ResultType of
                ?DUN_RESULT_TYPE_SUCCESS -> data_dungeon_m:get_config(force_quit_time) * 1000;
                _ -> 100
            end,
            ForceQuitTime = lib_dungeon_api:invoke(DunType, dunex_get_force_quit_time, [ResultType], DefQuitTime),
            ForceQuitRef = util:send_after(OldForceQuitRef, ForceQuitTime, self(), {'force_quit_ref'}),
            util:cancel_timer(OldFlowQuitRef),
            FlowQuitRef = none;
        {quit_time, FlowQuitTime} ->
            util:cancel_timer(OldForceQuitRef),
            ForceQuitRef = none,
            FlowQuitRef = util:send_after(OldFlowQuitRef, max(FlowQuitTime*1000, 10), self(), {'flow_quit_ref'})
    end,
    % 副本数据更新
    NewState = State#dungeon_state{
        is_end = ?DUN_IS_END_YES, result_type = ResultType, result_subtype = ResultSubtype,
        result_time = ResultTime, force_quit_ref = ForceQuitRef, flow_quit_ref = FlowQuitRef
        },
    NewState1
    = case lib_dungeon_api:get_special_api_mod(DunType, dunex_handle_dungeon_direct_end, 1) of
        undefined ->
            calc_role_rewards(NewState);
        Mod2 ->
            case Mod2:dunex_handle_dungeon_direct_end(NewState) of
                NewState2 when is_record(NewState2, dungeon_state) ->
                    calc_role_rewards(NewState2);
                _ ->
                    calc_role_rewards(NewState)
            end
    end,
%%    case get_push_settlement_type(DunId) of  %%在发奖励的时候，会判断，如果是可以推送，则在玩家进程发完奖励则立即推送
%%        ?PUSH_SETTLEMENT_TYPE_WHEN_FINISH ->
%%            push_settlement(NewState1);
%%        _ ->
%%            ok
%%    end,
    NewState1.

%% 通知副本结束
%% 根据退出类型,处理一些副本事件
%% @param ArgsMap #{dun_id = DunId, dun_type = DunType, result_type = ResultType, out = #dungeon_out{} }
notice_dungeon_direct_end_to_all(State, ResultType, ResultSubtype, ArgsMap) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
    F = fun(DungeonRole) ->
        #dungeon_role{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y} = DungeonRole,
        OldOut = maps:get(out, ArgsMap, #dungeon_out{}),
        NewOut = OldOut#dungeon_out{scene  = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y},
        NewOut2 = get_dungeon_out(ResultType, DunId, NewOut),
        NewArgsMap = ArgsMap#{dun_id => DunId, dun_type => DunType, out => NewOut2},
        lib_player:apply_cast(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE,
            lib_dungeon, handle_dungeon_direct_end, [ResultType, ResultSubtype, NewArgsMap])
    end,
    lists:foreach(F, RoleList).

%% 重新获取副本结束
get_dungeon_out(ResultType, DunId, Out) ->
    #dungeon{condition = Condition} = data_dungeon:get(DunId),
    case traverse_condition_for_out(Condition, ResultType) of
        [] -> Out;
        {SceneId, X, Y} -> Out#dungeon_out{scene  = SceneId, scene_pool_id = 0, copy_id = 0, x = X, y = Y}
    end.

%% 遍历条件获得退出场景和坐标
traverse_condition_for_out([], _ResultType) -> [];
traverse_condition_for_out([{any_out_scene, ScneId, X, Y}|_T], _ResultType) -> {ScneId, X, Y};
traverse_condition_for_out([{success_out_scene, SceneId, X, Y}|_T], ?DUN_RESULT_TYPE_SUCCESS) -> {SceneId, X, Y};
traverse_condition_for_out([_H|T], ResultType) -> traverse_condition_for_out(T, ResultType).

%% 副本结束的回调函数
handle_dungeon_result(#dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_handle_dungeon_result, [State], State) of
        NewState when is_record(NewState, dungeon_state) -> NewState;
        _ -> State
    end.

%% ----------------------------------------
%% 副本结束其他
%% ----------------------------------------

%% 副本结束后,处理玩家退出
%% @param OffMap 离线的map
%% @return {noreply, State} | {stop, normal, State}
%% 玩家延迟退出和手动退出采用同样操作，都当作在线操作
handle_role_out(
        #dungeon_state{
            is_end = ?DUN_IS_END_YES
            , dun_id = DunId
            , dun_type = _DunType
            , result_type = ResultType
            , team_id = TeamId
            } = State
        , RoleId, LogType, ResultSubtype, IsAagin, OffMap) ->
    #dungeon_state{role_list = RoleList, dun_type = DunType} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{is_end_out = ?DUN_IS_END_OUT_NO, online = OL, node = RoleNode, is_reward = IsReward} = DungeonRole when OL =:= ?DUN_ONLINE_YES orelse OL =:= ?DUN_ONLINE_DELAY ->
            NewState = State,
            DungeonRoleAfReissue = reissue_drop_reward(NewState, DungeonRole),
            PushSettlementType = get_push_settlement_type(DunId),
            if
                PushSettlementType == ?PUSH_SETTLEMENT_TYPE_WHEN_OUT andalso IsReward == ?DUN_IS_REWARD_YES ->  %%只有领了奖励的，且是退出结算的才能推
                    push_settlement(NewState, DungeonRoleAfReissue);
                true ->
                    ok
            end,
            % 清理记录
            mod_dungeon_agent:remove_dungeon_record(RoleId, self()),
            % 记录清理的标志位
            NewDungeonRole = DungeonRoleAfReissue#dungeon_role{is_end_out = ?DUN_IS_END_OUT_YES},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState2 = NewState#dungeon_state{role_list = NewRoleList},
            log_dungeon(NewState2, RoleId, LogType, []),
            Score = lib_dungeon:calc_score(NewState, RoleId),
            case IsAagin of
                true -> Args = [again, [ResultType, ResultSubtype, Score]];
                false -> Args = [out, [ResultType, ResultSubtype, Score]]
            end,
            lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, handle_role_out, Args),
            if
                TeamId > 0 ->
                    lib_dungeon_util:quit_team(DunType, RoleNode, TeamId, RoleId);
                true ->
                    skip
            end,
            F = fun(#dungeon_role{is_end_out = IsEndOut, online = Online}) -> IsEndOut == ?DUN_IS_END_OUT_NO andalso Online =/= ?DUN_ONLINE_NO  end,
            case lists:any(F, NewRoleList) of
                false -> {stop, normal, NewState2};
                true -> {noreply, NewState2}
            end;
        #dungeon_role{is_end_out = ?DUN_IS_END_OUT_NO, node = RoleNode} = DungeonRole when is_record(DungeonRole, dungeon_role) -> %% 已经离线的,但是没有退出
            %%            NewState = handle_send_reward(State, RoleId),  %% 这里是肯定不发了,在dungeon_direct_end 里发送奖励
            NewState =  State,
            DungeonRoleAfReissue = reissue_drop_reward(NewState, DungeonRole),
            % 清理记录
            mod_dungeon_agent:remove_dungeon_record(RoleId, self()),
            % 记录清理的标志位
            NewDungeonRole = DungeonRoleAfReissue#dungeon_role{is_end_out = ?DUN_IS_END_OUT_YES},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState2 = NewState#dungeon_state{role_list = NewRoleList},
            log_dungeon(NewState2, RoleId, LogType, []),
            % 离线要处理部分逻辑 lib_dungeon:handle_role_out
            Score = lib_dungeon:calc_score(NewState, RoleId),
            case IsAagin of
                true -> OffArgs = [RoleId, again, [DunId, ResultType, ResultSubtype, Score, OffMap]];
                false -> OffArgs = [RoleId, out, [DunId, ResultType, ResultSubtype, Score, OffMap]]
            end,
            % % lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, handle_role_out, Args),
            unode:apply(RoleNode, lib_dungeon, handle_role_out, OffArgs),
            if
                TeamId > 0 ->
                    lib_dungeon_util:quit_team(DunType, RoleNode, TeamId, RoleId);
                true ->
                    skip
            end,
            F = fun(#dungeon_role{is_end_out = IsEndOut, online = Online}) -> IsEndOut == ?DUN_IS_END_OUT_NO andalso Online =/= ?DUN_ONLINE_NO  end,
            case lists:any(F, NewRoleList) of
                false -> {stop, normal, NewState2};
                true -> {noreply, NewState2}
            end;
        #dungeon_role{node = RoleNode} -> %% 已经离线的
            mod_dungeon_agent:remove_dungeon_record(RoleId, self()),
            NewRoleList = lists:keydelete(RoleId, #dungeon_role.id, RoleList),
            NewState2 = State#dungeon_state{role_list = NewRoleList},
            if
                TeamId > 0 ->
                    lib_dungeon_util:quit_team(DunType, RoleNode, TeamId, RoleId);
                true ->
                    skip
            end,
            F = fun(#dungeon_role{is_end_out = IsEndOut, online = Online}) -> IsEndOut == ?DUN_IS_END_OUT_NO andalso Online =/= ?DUN_ONLINE_NO  end,
            case lists:any(F, NewRoleList) of
                false -> {stop, normal, NewState2};
                true -> {noreply, NewState2}
            end;
        _ ->
            {noreply, State}
    end;

%% 未结算就退出
handle_role_out(State, RoleId, LogType, ResultSubtype, IsAagin, OffMap) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList, team_id = TeamId, enter_lv = EnterLv, start_time = StartTime, wave_num = BattleWave,
        start_time_ms = StartTimeMs, dun_type = DunType, result_type = ResultType, finish_wave_list = FinishWaveList, story_play_time_mi = StoryPlayMs} = State,
    FinishWave = ?IF(FinishWaveList==[], 0, lists:max(FinishWaveList)),
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{online = OL, node = RoleNode} = DungeonRole ->
            DungeonRoleAfReissue = reissue_drop_reward(State, DungeonRole),
            case lib_dungeon_api:get_special_api_mod(DunType, dunex_is_calc_result_before_finish, 0) of
                undefined ->
                    NewState = State, %handle_send_reward(State, RoleId),
                    push_settlement(State, DungeonRoleAfReissue);
                Mod ->
                    case Mod:dunex_is_calc_result_before_finish() of
                        true ->
                            #dungeon_role{id = RoleId, help_type = HelpType, node = _Node, team_position = _Position, history_wave = HistoryWave,
                                pass_time_list = PassTimeList} = DungeonRole,
                            DunegonEndInfo = #dungeon_end_info{
                                help_type = HelpType, dun_pid = self(), dun_id = DunId, dun_type = DunType
                                , team_id = TeamId, result_type = ResultType, result_subtype = ResultSubtype, battle_wave = BattleWave
                                , history_wave = HistoryWave, pass_time_list= PassTimeList, finish_wave = FinishWave, start_time = StartTime
                            },
                            apply_cast_to_local(State, DungeonRole, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_dungeon, replace_dungeon_wave, [DunegonEndInfo]]),
                            apply_cast_to_local(State, DungeonRole, lib_dungeon, replace_dungeon_wave_db, [RoleId, DunegonEndInfo]),
                            %% 失败事件
                            Other = lib_dungeon_api:invoke(DunType, dunex_get_other_fail_data, [State, DungeonRole], []),
                            ResultTime = utime:unixtime(),
                            ResultTimeMs = utime:longunixtime(),
                            PassTime   = ResultTime - StartTime,
                            Data = #callback_dungeon_fail{
                                dun_id=DunId, dun_type=DunType, help_type=HelpType,start_time=StartTime, start_time_ms = StartTimeMs, result_time_ms = ResultTimeMs,
                                story_play_time_mi = StoryPlayMs, pass_time = PassTime, other = Other
                            },
                            unode:apply(RoleNode, lib_player_event, async_dispatch, [RoleId, ?EVENT_DUNGEON_FAIL, Data]),
                            Rewards = get_send_reward(State, DungeonRole),
                            NewDungeonRole = DungeonRole#dungeon_role{calc_reward_list = Rewards,
                                is_push_settle_in_ps = ?DUNGEON_FORCE_PUSH_SETTLE_YES},
                            NewRoleList1 = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
                            NewState = handle_send_reward(State#dungeon_state{role_list = NewRoleList1}, RoleId);
                        _ ->
                            NewState = State
                    end
            end,
            mod_dungeon_agent:remove_dungeon_record(RoleId, self()),
            NewRoleList = lists:keydelete(RoleId, #dungeon_role.id, RoleList),
            log_dungeon(NewState, RoleId, LogType, []),
            NewEnterLv = lib_dungeon_api:invoke(DunType, dunex_change_lv_when_role_out, [NewRoleList, DunType], EnterLv),
            NewState1 = NewState#dungeon_state{role_list = NewRoleList, enter_lv = NewEnterLv},
            Score = lib_dungeon:calc_score(State, RoleId),
            case OL =:= ?DUN_ONLINE_YES orelse OL =:= ?DUN_ONLINE_DELAY of
                true ->
                    case IsAagin of
                        true -> Args = [again, [ResultType, ResultSubtype, Score]];
                        false -> Args = [out, [ResultType, ResultSubtype, Score]]
                    end,
                    lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, handle_role_out, Args);
                false ->
                    % 离线要处理部分逻辑 lib_dungeon:handle_role_out
                    case IsAagin of
                        true -> OffArgs = [RoleId, again, [DunId, ResultType, ResultSubtype, Score, OffMap]];
                        false -> OffArgs = [RoleId, out, [DunId, ResultType, ResultSubtype, Score, OffMap]]
                    end,
                    unode:apply(RoleNode, lib_dungeon, handle_role_out, OffArgs)
            end,
            if
                TeamId > 0 ->
                    lib_dungeon_util:quit_team(DunType, RoleNode, TeamId, RoleId);
                true ->
                    skip
            end,
            {noreply, NewState1};
        _ ->
            {noreply, State}
    end.

%% 发送奖励
handle_send_reward(State) ->
    #dungeon_state{role_list = RoleList} = State,
    RoleIdList = [RoleId||#dungeon_role{id = RoleId}<-RoleList],
    F = fun(RoleId, TmpState) -> handle_send_reward(TmpState, RoleId) end,
    lists:foldl(F, State, RoleIdList).

%% 发送奖励[发过的不会再发]
%% 注意:发奖励的时候注意防止多发
handle_send_reward(#dungeon_state{role_list = RoleList, dun_id = _DunId} = State, RoleId) ->
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> State;
        DungeonRole ->
            #dungeon_state{now_scene_id = _SceneId, scene_pool_id = _ScenePoolId} = State,
            #dungeon_role{
                id = RoleId, is_reward = IsReward, calc_reward_list = CalcRewards,
                drop_list = _DropList, node = _RoleNode
            } = DungeonRole,
            case IsReward == ?DUN_IS_REWARD_YES of
                true -> State;
                false ->
%%                    DropGoods = lib_goods_api:make_reward_unique(lib_dungeon:pick_all(DropList)),
                    % ?PRINT("DropList = ~p~n", [DropList]),
%%                    case CalcRewards of
%%                        [] -> ResRewards = [];
%%                        % {msg, Code, []} ->
%%                        %     lib_dungeon:send_dungeon_msg(DungeonRole, Code),
%%                        %     ResRewards = [];
%%                        {msg, Code, ResRewards} ->
%%                            lib_dungeon:send_dungeon_msg(DungeonRole, Code);
%%                        [{base, _}|_] ->
%%                            Reward = lists:flatten([X || {_, X} <- CalcRewards]),
%%                            ResRewards = lib_goods_api:make_reward_unique(Reward);
%%                        Reward ->
%%                            ResRewards = lib_goods_api:make_reward_unique(Reward)
%%                    end,
                    send_reward(State, DungeonRole, CalcRewards),  %%实际发奖励
                    NewDungeonRole = DungeonRole,
                    NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
                    State#dungeon_state{role_list = NewRoleList}
            end
    end.

%% 获取发送到奖励
% 成长试炼(只有成功才能发奖励)
% get_send_reward(
%         #dungeon_state{dun_type = ?DUNGEON_TYPE_GROW, result_type = ?DUN_RESULT_TYPE_SUCCESS} = State
%         , _DungeonRole) ->
%     #dungeon_state{dun_id = DunId} = State,
%     case data_dungeon_grow:get_dungeon_grow(DunId) of
%         #dungeon_grow{reward = Reward} when Reward =/= [] -> Reward;
%         _ -> []
%     end;
% % 五芒星副本
% %   1:助战没有奖励
% %   2:胜利获得全部奖励,失败只有一半
% get_send_reward(
%         #dungeon_state{dun_type = ?DUNGEON_TYPE_PENTACLE, result_type = ResultType}
%         , #dungeon_role{help_type = ?HELP_TYPE_NO} = DungeonRole) ->
%     #dungeon_role{figure = #figure{lv = Lv} } = DungeonRole,
%     Exp = 22500,
%     case ResultType == ?DUN_RESULT_TYPE_SUCCESS of
%         true -> AddExp = Exp;
%         false -> AddExp = round(Exp/2)
%     end,
%     calc_reward_add([{?TYPE_EXP, 0, AddExp}], Lv);

% 默认
%   2:走评分
%   return  [{来源, 奖励列表}]  eg: [{?REWARD_SOURCE_DUNGEON, BaseRewards}]
get_send_reward(
        #dungeon_state{dun_type = DunType, dun_id = DunId, result_type = ResultType} = State
        , #dungeon_role{id = RoleId, figure = Figure, drop_times_args = DropTimeArgs, is_first_reward = IsFirstReward, reward_ratio = RewardRatio, weekly_card_status = WeeklyCardStatus} = DungeonRole
        ) ->
    case lib_dungeon_api:get_special_api_mod(DunType, dunex_get_send_reward, 2) of
        undefined ->
            if
                ResultType =:= ?DUN_RESULT_TYPE_SUCCESS andalso DungeonRole#dungeon_role.help_type =:= ?HELP_TYPE_NO ->
                    case IsFirstReward == 1 of
                        true -> FirstReward = lib_dungeon:get_extra_reward(Figure, DunId, ?DUN_EXTRA_REWARD_TYPE_FIRST);
                        false -> FirstReward = []
                    end,
                    Score = lib_dungeon:calc_score(State, RoleId),
                    BaseRewards = lib_dungeon_api:get_dungeon_grade(DungeonRole, DunId, Score),
                    N = case get_drop_times(Figure, DunType, DropTimeArgs) of
                        N0 when N0 > 1 -> RewardRatio+N0-1;
                        _ -> RewardRatio
                    end,
                    case N > 0 of
                        true ->
                            MultiRewards =
                                case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                                    false ->
                                        lib_goods_util:goods_object_multiply_by(BaseRewards, N);
                                    true ->
                                        lib_dungeon_resource:mod_calc_resource_dungeon_reward(BaseRewards, N)
                                end;
                        false ->
                            MultiRewards = []
                    end,
%%                    ?MYLOG("cym", "MultiRewards ~p~n", [MultiRewards]),
                    IsAddDunType = lib_dungeon_resource:is_resource_dungeon_type(DunType),
                    WeeklyCardRewards = ?IF(WeeklyCardStatus#weekly_card_status.is_activity =:= ?ACTIVATION_OPEN andalso IsAddDunType ,
                        lib_dungeon_sweep:do_calc_weekly_card_reward(BaseRewards), []),
                    [{?REWARD_SOURCE_DUNGEON, BaseRewards}] ++ [{?REWARD_SOURCE_DUNGEON_MULTIPLE, MultiRewards}] ++
                        [{?REWARD_SOURCE_FIRST, FirstReward}] ++ [{?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardRewards}];
%%                    case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
%%                        #dungeon_grade{reward = Rewards} ->
%%                            BaseRewards
%%                                = case lib_goods_util:is_random_rewards(Rewards) of
%%                                      false ->
%%                                          Rewards;
%%                                      _ ->
%%                                          lib_goods_util:calc_random_rewards(Rewards)
%%                                  end,
%%                            case get_drop_times(DunType, DropTimeArgs) of
%%                                N when N > 1 ->
%%                                    lib_goods_util:goods_object_multiply_by(BaseRewards, N);
%%                                _ ->
%%                                    BaseRewards
%%                            end;
%%                        _ -> []
%%                        % #dungeon_grade{reward = Reward} -> calc_reward_add(Reward, Lv)
%%                    end;
                ResultType =:= ?DUN_RESULT_TYPE_SUCCESS andalso DungeonRole#dungeon_role.help_type =:= ?HELP_TYPE_YES ->
                    % 助战分副本发奖励
                    lib_dungeon_api:invoke(DunType, send_reward_help_type_yes, [State, DungeonRole], []);
                true -> []
            end;
        Mod -> %% 自己的get_send_reward 自己决定副本失败是否要发奖
            Mod:dunex_get_send_reward(State, DungeonRole)
    end.
% get_send_reward(_State, _) -> [].
% % 冒险之旅副本
% handle_send_reward_help(
%         #dungeon_state{dun_type = ?DUNGEON_TYPE_ADVENTURE_TRIP, result_type = ResultType} = State
%         , DungeonRole) ->
%     #dungeon_state{dun_id = DunId, role_list = RoleList} = State,
%     #dungeon_role{id = RoleId} = DungeonRole,
%     lib_adventure_tour_api:send_reward({RoleId, DunId, ResultType}),
%     NewDungeonRole = DungeonRole#dungeon_role{is_reward = ?DUN_IS_REWARD_YES},
%     NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%     State#dungeon_state{role_list = NewRoleList};
% 其他

%% 计算奖励加成
%%  只有部分副本需要加成
calc_reward_add(Reward, Lv) ->
    [begin
        case GoodsType == ?TYPE_EXP of
            true -> {GoodsType, GoodsTypeId, GoodsNum*erlang:trunc(Lv/10+1)};
            false -> {GoodsType, GoodsTypeId, GoodsNum}
        end
    end||{GoodsType, GoodsTypeId, GoodsNum}<-Reward].

%% 计算客户端奖励展示
%%  经验需要一个世界等级的加成
calc_client_reward_show(Reward, Lv) ->
    WorldLv = util:get_world_lv(),
    WorldLvRatio = data_exp_add:get_add(WorldLv, Lv)/100,
    [begin
        case GoodsType == ?TYPE_EXP of
            true -> {GoodsType, GoodsTypeId, round(GoodsNum*(1+WorldLvRatio))};
            false -> {GoodsType, GoodsTypeId, GoodsNum}
        end
    end||{GoodsType, GoodsTypeId, GoodsNum}<-Reward].

%% 发送奖励
%% @param Reward not_send | [{来源, 奖励列表}] |
send_reward(_State, _DungeonRole, not_send) -> skip; %不发了
%%send_reward(_State, _DungeonRole, []) -> skip; %%%空也要发
send_reward(State, DungeonRole, Reward) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType} = State,
    #dungeon_role{id = RoleId, help_type = HelpType, node = Node, is_first_reward = IsFirstReward, count = Count} = DungeonRole,
    {Produce, BaseReward, FirstReward, MultipleReward, WeeklyCardReward} = get_dungeon_produce(Reward, State, DungeonRole),
    IsPushSettlement = is_push_settlement(State, DungeonRole),
    DungeonTransportMsg = #dungeon_transport_msg{
        produce             = Produce,
        base_reward         = BaseReward,
        first_reward        = FirstReward,
        multiple_reward     = MultipleReward,
        weekly_card_reward  = WeeklyCardReward,
        is_push_settle      = IsPushSettlement,
        dun_id              = State#dungeon_state.dun_id,
        dun_type            = State#dungeon_state.dun_type,
        now_scene_id        = State#dungeon_state.now_scene_id,
        result_type         = State#dungeon_state.result_type,
        result_subtype      = State#dungeon_state.result_subtype,
        role_list           = State#dungeon_state.role_list,
        start_time          = State#dungeon_state.start_time,
        end_time            = State#dungeon_state.end_time,
        result_time         = State#dungeon_state.result_time,
        mon_score           = State#dungeon_state.mon_score,
        level_result_list   = State#dungeon_state.level_result_list,
        finish_wave_list    = State#dungeon_state.finish_wave_list
        },
    unode:apply(Node, lib_dungeon, dungeon_count_increment_multi, [DunId, RoleId, HelpType, ?DUN_COUNT_DEDUCT_REWARD, Count]),
    unode:apply(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_dungeon, handle_send_reward,
        [Reward, util:is_cls(), self(), DungeonTransportMsg, DungeonRole]]),
    case IsFirstReward == 1 of
        true -> unode:apply(Node, lib_dungeon, increment_af_send_first_reward, [RoleId, DunType, DunId]);
        false -> skip
    end,
    ok.

%% -----------------------------------------------------------------
%% 关卡处理
%% -----------------------------------------------------------------

%% 关闭关卡相关定时器
close_level_ref(State) ->
    #dungeon_state{role_list = RoleList, common_event_map = CommonEventMap, ref = Ref, level_close_ref = LevelCloseRef, wave_close_ref = WaveCloseRef} = State,
    F = fun(#dungeon_common_event{create_ref = CreateRef}) -> util:cancel_timer(CreateRef) end,
    CommonEventList = maps:values(CommonEventMap),
    lists:foreach(F, CommonEventList),
    F2 = fun(#dungeon_role{revive_ref = ReviveRef}) -> util:cancel_timer(ReviveRef) end,
    lists:foreach(F2, RoleList),
    util:cancel_timer(Ref),
    util:cancel_timer(LevelCloseRef),
    util:cancel_timer(WaveCloseRef),
    ok.

%% 发送关卡奖励
handle_level_send_reward(State, LevelResult) ->
    #dungeon_state{role_list = RoleList} = State,
    RoleIdList = [RoleId||#dungeon_role{id = RoleId}<-RoleList],
    F = fun(RoleId, TmpState) -> handle_level_send_reward(TmpState, LevelResult, RoleId) end,
    lists:foldl(F, State, RoleIdList).

%% 发送奖励[发过的不会再发]
handle_level_send_reward(#dungeon_state{role_list = RoleList} = State, #dungeon_level_result{level = ResultLevel} = LevelResult, RoleId) ->
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> State;
        DungeonRole ->
            #dungeon_role{id = RoleId, level_list = LevelList} = DungeonRole,
            case lists:keyfind(ResultLevel, #dungeon_role_level.level, LevelList) of
                false -> IsReward = ?DUN_IS_REWARD_NO;
                #dungeon_role_level{is_reward = IsReward} -> ok
            end,
            case IsReward == ?DUN_IS_REWARD_YES of
                true -> State;
                false -> handle_level_send_reward_help(State, DungeonRole, LevelResult)
            end
    end.

% handle_level_send_reward_help(
%         #dungeon_state{dun_type = ?DUNGEON_TYPE_OBLIVION} = State
%         , #dungeon_role{help_type = ?HELP_TYPE_NO} = DungeonRole
%         , #dungeon_level_result{level = ResultLevel, scene_id = ResultSceneId, result_type = ?DUN_RESULT_TYPE_SUCCESS}) ->
%     #dungeon_state{dun_id = DunId, role_list = RoleList} = State,
%     #dungeon_role{id = RoleId, level_list = LevelList} = DungeonRole,
%     Reward = data_dungeon_oblivion:get_reward(DunId, ResultSceneId, ResultLevel),
%     NewReward = lib_dungeon_oblivion_mod:calc_reward(Reward),
%     send_reward(State, RoleId, NewReward, 0),
%     case lists:keyfind(ResultLevel, #dungeon_role_level.level, LevelList) of
%         false -> RoleLevel = #dungeon_role_level{level = ResultLevel, is_reward = ?DUN_IS_REWARD_YES, reward_list = NewReward};
%         OldRoleLevel -> RoleLevel = OldRoleLevel#dungeon_role_level{is_reward = ?DUN_IS_REWARD_YES, reward_list = NewReward}
%     end,
%     NewLevelList = lists:keystore(ResultLevel, #dungeon_role_level.level, LevelList, RoleLevel),
%     NewDungeonRole = DungeonRole#dungeon_role{level_list = NewLevelList},
%     NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%     % ?INFO("RoleLevel:~w ~n", [RoleLevel]),
%     State#dungeon_state{role_list = NewRoleList};
handle_level_send_reward_help(State, _DungeonRole, _LevelResult) ->
    State.

calc_level_reward_list(State, LevelResult) ->
    #dungeon_state{role_list = RoleList, dun_id = DunId} = State,
    #dungeon_level_result{result_type = ResultType, level = Level} = LevelResult,
    if
        ResultType =:= ?DUN_RESULT_TYPE_SUCCESS ->
            {_Level, _StartTime, _EndTime, _ResultTime, Score} = lib_dungeon:calc_level_score(DunId, LevelResult),
            case data_dungeon_grade:get_level_rewards(DunId, Score) of
                #dungeon_level_grade{rewards = Rewards} ->
                    ok;
                _ ->
                    Rewards = []
            end;
        true ->
            Rewards = []
    end,
    NewRoleList
    = [begin
        #dungeon_role{level_list = LevelList} = Role,
        case lists:keyfind(Level, #dungeon_role_level.level, LevelList) of
            false ->
                GotRewards = lib_goods_util:calc_random_rewards(Rewards),
                L = #dungeon_role_level{level = Level, reward_list = GotRewards},
                NewLevelList = [L | LevelList],
                Role#dungeon_role{level_list = NewLevelList};
            _ ->
                Role
        end
    end || Role <- RoleList],
    State#dungeon_state{role_list = NewRoleList}.

%% 切换下一个关卡
change_next_level(State) ->
    #dungeon_state{
        dun_id = DunId
        , dun_type  = DunType
        , role_list = RoleList
        , scene_pool_id = ScenePoolId
        , level = Level
        , open_scene_list = OpenSceneList
        , level_result_list = LevelResultList
        , level_change_ref = LevelChangeRef
        } = State,
    util:cancel_timer(LevelChangeRef),
    NewLevel = Level+1,
    SceneId = get_next_scene_id(State, NewLevel),
    Dun = data_dungeon:get(DunId),
    CommonEventMap = lib_dungeon_common_event:make_common_event_map(Dun, SceneId),
    % ?PRINT("CommonEventMap:~w ~n", [CommonEventMap]),
    NewOpenSceneList = [SceneId|OpenSceneList],
    #dungeon_level{time = Time} = data_dungeon_level:get_dungeon_level(DunId, SceneId),
    Unixtime = utime:unixtime(),
    LevelEndTime = Unixtime + Time,
    LevelResult = #dungeon_level_result{level = NewLevel, scene_id = SceneId, start_time = Unixtime, end_time = LevelEndTime},
    NewLevelResultList = lists:keystore(NewLevel, #dungeon_level_result.level, LevelResultList, LevelResult),
    LevelCloseRef = erlang:send_after(Time*1000, self(), {'dungeon_level_timeout'}),
    NewState = State#dungeon_state{
        now_scene_id = SceneId
        , open_scene_list = NewOpenSceneList
        , wave_num = 0
        , common_event_map = CommonEventMap
        , level = NewLevel
        , level_result_list = NewLevelResultList
        , level_close_ref = LevelCloseRef
        , level_change_ref = none
        , level_start_time = Unixtime
        , level_end_time = LevelEndTime
        , is_level_end = ?DUN_IS_LEVEL_END_NO
        },
    % 分组
    StateAfGroup = lib_dungeon_common_event:make_group_map(NewState),
    % 处理触发事件
    StateAfEvent = lib_dungeon_common_event:check_and_execute(StateAfGroup),
    % 构造副本场景辅助信息
    StateAfSceneHelper = lib_dungeon_common_event:make_dungeon_scene_helper(StateAfEvent),
    % 同步到各个场景(根据类型同步数据)
    % #dungeon_state{scene_helper = #dungeon_scene_helper{hp_rate_list = HpRateList} } = StateAfSceneHelper,
    % mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'update_dungeon_hp_rate', self(), HpRateList}),
    % 构造怪物辅助信息
    StateAfMonHelper = lib_dungeon_common_event:make_mon_scene_helper(StateAfSceneHelper),
    % 定时器处理
    TimeList = calc_static_time_list(StateAfMonHelper),
    StateAfRef = calc_ref(StateAfMonHelper#dungeon_state{time_list = TimeList}),
    % 同步数据
    [begin
        #dungeon_role{id = RoleId, node = Node} = DungeonRole,
        lib_dungeon:change_next_level(Node, RoleId, self(), DunId, DunType, NewLevel, SceneId, ScenePoolId)
    end||DungeonRole<-RoleList],
    % ?PRINT("########################change_next_level:~p @@@@@@@@@@@@@@@@~n", [SceneId]),
    {noreply, StateAfRef}.

%% -----------------------------------------------------------------
%% 其他功能函数
%% -----------------------------------------------------------------

%% 伙伴列表
% send_partner_list(State, RoleId) ->
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> PartnerGroup = 0, NextChoiceTime = 0, PartnerList = [];
%         #dungeon_role{node = Node, partner_group = PartnerGroup, partner_choice_time = ChoiceTime, partner_map = PartnerMap} ->
%             Cd = data_dungeon_m:get_partner_choice_cd(),
%             NextChoiceTime = ChoiceTime+Cd,
%             F = fun(_K, DunPartnerList, List) ->
%                 TmpList = [
%                     begin
%                         #dungeon_partner{
%                             auto_id = AutoId
%                             , partner_id = PartnerId
%                             , pos = Pos
%                             , hp = Hp
%                             , hp_lim = HpLim
%                             , partner = #partner{lv = Lv}
%                             } = DunPartner,
%                         {AutoId, PartnerId, Pos, Lv, Hp, HpLim}
%                     end||DunPartner<-DunPartnerList],
%                 TmpList++List
%             end,
%             PartnerList = maps:fold(F, [], PartnerMap)
%     end,
%     {ok, BinData} = pt_201:write(20101, [PartnerGroup, NextChoiceTime, PartnerList]),
%     send_to_uid(Node, RoleId, BinData),
%     ok.

%% 伙伴出战
% choose_partner_group(State, RoleId, PartnerGroup, X, Y) ->
%     case check_choose_partner_group(State, RoleId, PartnerGroup) of
%         {false, ErrorCode} -> NewState = State, NextChoiceTime = 0;
%         true ->
%             ErrorCode = ?SUCCESS,
%             {ok, NewState, ChoiceTime} = do_choose_partner_group(State, RoleId, PartnerGroup, X, Y),
%             Cd = data_dungeon_m:get_partner_choice_cd(),
%             NextChoiceTime = ChoiceTime+Cd
%     end,
%     % ?PRINT("20102 ErrorCode:~p ~n", [ErrorCode]),
%     {ok, BinData} = pt_201:write(20102, [ErrorCode, PartnerGroup, NextChoiceTime]),
%     lib_server_send:send_to_uid(RoleId, BinData),
%     {ok, NewState}.

% check_choose_partner_group(State, RoleId, PartnerGroup) ->
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> {false, ?ERRCODE(err610_dungeon_role_not_exist)};
%         DungeonRole ->
%             #dungeon_role{partner_group = OldGroupId, partner_choice_time = ChoiceTime} = DungeonRole,
%             IsRightGroupId = lists:member(PartnerGroup, [?PARTNER_GROUP_1, ?PARTNER_GROUP_2]),
%             ChoiceCd = data_dungeon_m:get_partner_choice_cd(),
%             Unixtime = utime:unixtime(),
%             if
%                 OldGroupId == ?PARTNER_GROUP_BAN -> {false, ?ERRCODE(err610_can_not_choose_partner_group)};
%                 IsRightGroupId == false -> {false, ?ERRCODE(err610_not_right_group_id)};
%                 Unixtime < ChoiceCd+ChoiceTime -> {false, ?ERRCODE(err610_on_choose_partner_group_cd)};
%                 OldGroupId == PartnerGroup -> {false, ?ERRCODE(err610_choose_same_partner_group_id)};
%                 true -> true
%             end
%     end.

% do_choose_partner_group(State, RoleId, PartnerGroup, X, Y) ->
%     % 清理分组的伙伴
%     {ok, NewState, DungeonRole} = clear_partner(State, RoleId),
%     #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
%     ChoiceTime = utime:unixtime(),
%     NewDungeonRole = DungeonRole#dungeon_role{partner_group = PartnerGroup, partner_choice_time = ChoiceTime},
%     PosMap = lib_dungeon_util:get_create_partner_pos_map(SceneId, ScenePoolId, self(), X, Y),
%     NewState2 = create_partner(NewState, NewDungeonRole, PosMap),
%     {ok, NewState2, ChoiceTime}.

%% 清理分组的伙伴
% clear_partner(State, RoleId) ->
%     #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId, role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> {false, State};
%         DungeonRole ->
%             #dungeon_role{partner_map = DunPartnerMap} = DungeonRole,
%             % 伙伴的数据赋值
%             F = fun(_K, DunPartnerList) ->
%                 [begin
%                     #dungeon_partner{auto_id = AutoId, hp = Hp} = DunPartner,
%                     case AutoId == 0 orelse Hp == 0 of
%                         true -> DunPartner#dungeon_partner{auto_id = 0};
%                         false ->
%                             case lib_scene_object:get_scene_object_battle_attr_by_ids(SceneId, ScenePoolId, [AutoId], [#battle_attr.hp]) of
%                                 [[NewHp]] -> DunPartner#dungeon_partner{auto_id = 0, hp = NewHp};
%                                 _ -> DunPartner#dungeon_partner{auto_id = 0, hp = Hp}
%                             end
%                     end
%                 end||DunPartner<-DunPartnerList]
%             end,
%             NewDunPartnerMap = maps:map(F, DunPartnerMap),
%             NewDungeonRole = DungeonRole#dungeon_role{partner_map = NewDunPartnerMap},
%             NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%             NewState = State#dungeon_state{role_list = NewRoleList},
%             % 清理伙伴
%             F2 = fun(_K, DunPartnerList, List) ->
%                 F3 = fun(DunPartner, IdList) ->
%                     #dungeon_partner{auto_id = AutoId} = DunPartner,
%                     case AutoId > 0 of
%                         true -> [AutoId|IdList];
%                         false -> IdList
%                     end
%                 end,
%                 IdList = lists:foldl(F3, [], DunPartnerList),
%                 IdList++List
%             end,
%             IdList = maps:fold(F2, [], DunPartnerMap),
%             lib_scene_object:clear_scene_object_by_ids(SceneId, ScenePoolId, 1, IdList),
%             {ok, NewState, NewDungeonRole}
%     end.

%% 生成当前分组的伙伴
%% @param 位置信息 #{Pos:={X, Y, AttrList}} Key值必须含有1和2
% create_partner(State, RoleId, PosMap) when is_integer(RoleId) ->
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> State;
%         DungeonRole -> create_partner(State, DungeonRole, PosMap)
%     end;
% create_partner(State, DungeonRole, PosMap) ->
%     #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId, team_id = TeamId, role_list = RoleList} = State,
%     #dungeon_role{
%         id = RoleId
%         , figure = #figure{guild_id = GuildId, guild_name = GuildName}
%         , pid = Pid
%         , partner_group = PartnerGroup
%         , partner_map = DunPartnerMap
%         } = DungeonRole,
%     DunPartnerList = maps:get(PartnerGroup, DunPartnerMap, []),
%     % ?INFO("PosMap:~w ~n", [PosMap]),
%     F = fun(DunPartner) ->
%         #dungeon_partner{auto_id = AutoId, partner = Partner, hp = Hp, pos = Pos} = DunPartner,
%         case AutoId == 0 andalso Hp > 0 of
%             true ->
%                 SkillOwner = #skill_owner{
%                     id = RoleId
%                     , pid = Pid
%                     , team_id = TeamId
%                     , guild_id = GuildId
%                     , guild_name = GuildName
%                     , sign = ?BATTLE_SIGN_PLAYER
%                     },
%                 case Pos rem 2 == 0 of
%                     true -> {X, Y, AttrList} = maps:get(?DUN_CREATE_PARTNER_POS_2, PosMap);
%                     false -> {X, Y, AttrList} = maps:get(?DUN_CREATE_PARTNER_POS_1, PosMap)
%                 end,
%                 Args = AttrList++[{skill_owner, SkillOwner}, {hp, Hp}, {group, ?DUN_DEF_GROUP}],
%                 NewAutoId = lib_scene_object:sync_create_a_partner(SceneId, ScenePoolId, X, Y, 0, self(), 1, Partner, Args);
%             false ->
%                 NewAutoId = AutoId
%         end,
%         DunPartner#dungeon_partner{auto_id = NewAutoId}
%     end,
%     NewDunPartnerList = lists:map(F, DunPartnerList),
%     NewDunPartnerMap = maps:put(PartnerGroup, NewDunPartnerList, DunPartnerMap),
%     NewDungeonRole = DungeonRole#dungeon_role{partner_map = NewDunPartnerMap},
%     NewRoleList = lists:keyreplace(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%     State#dungeon_state{role_list = NewRoleList}.

% %% 停止伙伴
% stop_partner(State, AutoId, OwnId, Hp) when AutoId > 0, OwnId > 0 ->
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(OwnId, #dungeon_role.id, RoleList) of
%         false -> State;
%         DungeonRole ->
%             #dungeon_role{partner_map = DunPartnerMap} = DungeonRole,
%             F = fun(_K, DunPartnerList) ->
%                 case lists:keyfind(AutoId, #dungeon_partner.auto_id, DunPartnerList) of
%                     false -> DunPartnerList;
%                     DunPartner ->
%                         NewDunPartner = DunPartner#dungeon_partner{auto_id = 0, hp = Hp},
%                         [NewDunPartner|lists:delete(DunPartner, DunPartnerList)]
%                 end
%             end,
%             NewDunPartnerMap = maps:map(F, DunPartnerMap),
%             NewDungeonRole = DungeonRole#dungeon_role{partner_map = NewDunPartnerMap},
%             NewRoleList = lists:keyreplace(OwnId, #dungeon_role.id, RoleList, NewDungeonRole),
%             State#dungeon_state{role_list = NewRoleList}
%     end;
% stop_partner(State, _AutoId, _OwnId, _Hp) ->
%     State.

%% -----------------------------------------------------------------
%% 通用函数:发送消息,获取基础数据,日志
%% -----------------------------------------------------------------

%% 发送消息
send_msg(State, BinData) ->
    #dungeon_state{role_list = RoleList} = State,
    [send_to_uid(Node, RoleId, BinData)||#dungeon_role{id = RoleId, node = Node}<-RoleList].

%% 是否所有玩家下线
is_all_role_not_on_online(State) ->
    #dungeon_state{role_list = RoleList} = State,
    F = fun(#dungeon_role{online = Online}) -> Online =/= ?DUN_ONLINE_YES end,
    lists:all(F, RoleList).

%% 副本日志
%% @param LogType 记录类型
%% @param Args 参数 [{result_type, ResultType}, {result_subtype, }]
log_dungeon(State, LogType, Args) ->
    % ?PRINT("log_dungeon LogType:~w~n", [LogType]),
    #dungeon_state{dun_id = DunId} = State,
    Dun = data_dungeon:get(DunId),
    case lib_dungeon:is_dungeon_single(Dun#dungeon.condition) of
        true -> log_single_dungeon(State, LogType, Args);
        false -> log_multi_dungeon(State, LogType, Args)
    end.

log_dungeon(State, RoleId, LogType, Args) when is_integer(RoleId) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> skip;
        DungeonRole -> log_dungeon(State, DungeonRole, LogType, Args)
    end;
log_dungeon(State, DungeonRole, LogType, Args) ->
    #dungeon_state{dun_id = DunId} = State,
    Dun = data_dungeon:get(DunId),
    case lib_dungeon:is_dungeon_single(Dun#dungeon.condition) of
        true -> log_single_dungeon(State, DungeonRole, LogType, Args);
        false -> log_multi_dungeon(State, DungeonRole, LogType, Args)
    end.

%% 单人副本
log_single_dungeon(State, LogType, Args) ->
    #dungeon_state{role_list = RoleList} = State,
    F = fun(DungeonRole) -> log_single_dungeon(State, DungeonRole, LogType, Args) end,
    lists:foreach(F, RoleList).

log_single_dungeon(State, DungeonRole, LogType, Args) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, result_type = OldResultType, result_subtype = OldResultSubtype} = State,
    [ResultType, ResultSubtype] = log_update(Args, [OldResultType, OldResultSubtype]),
    #dungeon_role{id = RoleId, figure = #figure{lv = Lv}, combat_power = CombatPower, reward_map = RewardMap, count = Count, typical_data = TypicalData} = DungeonRole,
    RewardList = get_log_reward_from_source_map(RewardMap),
    KillMonNum = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_DIE, TypicalData, 0),
    mod_log:add_log(log_single_dungeon, [RoleId, Lv, CombatPower, DunId, DunType, util:term_to_string(RewardList), ResultType, ResultSubtype, Count, KillMonNum, LogType, utime:unixtime()]),
    ok.

%% 多人副本
log_multi_dungeon(State, LogType, Args) ->
    #dungeon_state{role_list = RoleList} = State,
    F = fun(DungeonRole) -> log_multi_dungeon(State, DungeonRole, LogType, Args) end,
    lists:foreach(F, RoleList).

log_multi_dungeon(State, DungeonRole, LogType, Args) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, team_id = TeamId, role_list = RoleList, result_type = OldResultType, result_subtype = OldResultSubtype} = State,
    [ResultType, ResultSubtype] = log_update(Args, [OldResultType, OldResultSubtype]),
    #dungeon{diff_lv = DiffLv} = data_dungeon:get(DunId),
    #dungeon_role{id = RoleId, figure = #figure{lv = Lv, guild_id = GuildId}, combat_power = CombatPower, reward_map = RewardMap, help_type = HelpType, count = Count} = DungeonRole,
    RewardList = get_log_reward_from_source_map(RewardMap),
    LeftRoleIdList = [TmpRoleId||#dungeon_role{id = TmpRoleId}<-RoleList, RoleId=/=TmpRoleId],
    case LeftRoleIdList of
        [] -> RoleId1 = 0, RoleId2 = 0, RoleId3 = 0;
        [RoleId1] -> RoleId2 = 0, RoleId3 = 0;
        [RoleId1, RoleId2] -> RoleId3 = 0;
        [RoleId1, RoleId2, RoleId3|_] -> ok
    end,
    Score = lib_dungeon:calc_score(State, RoleId),
    {LevelScoreList, IntimacyScoreList, RelaScoreList, GuildScoreList, TimeScoreList, MonScore} = lib_dungeon:calc_score_help(State, RoleId),
    case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
        [] -> Grade = 0;
        #dungeon_grade{grade = Grade} -> ok
    end,
    mod_log:add_log(log_multi_dungeon, [RoleId, Lv, CombatPower, GuildId, DunId, DunType, DiffLv, TeamId, HelpType, RoleId1, RoleId2, RoleId3, util:term_to_string(RewardList),
        Grade, Score, util:term_to_string(LevelScoreList), util:term_to_string(IntimacyScoreList), util:term_to_string(RelaScoreList),
        util:term_to_string(GuildScoreList), util:term_to_string(TimeScoreList), MonScore, ResultType, ResultSubtype, Count, LogType, utime:unixtime()]),
    ok.

%% 日志更新
log_update([], Result) -> Result;
log_update([H|T], [OldResultType, OldResultSubtype]) ->
    case H of
        {result_type, ResultType} -> log_update(T, [ResultType, OldResultSubtype]);
        {result_subtype, ResultSubtype} -> log_update(T, [OldResultType, ResultSubtype])
    end.

setup_typical_data(TypicalData, [{Key, Value}|Datas]) ->
    setup_typical_data(TypicalData#{Key => Value}, Datas);
setup_typical_data(TypicalData, []) -> TypicalData.

stop_dungeon_when_no_role(State, DungeonRole, ResultType, ResultSubtype) ->
    #dungeon_state{dun_type = DunType} = State,
    lib_dungeon_api:invoke(DunType, dunex_stop_dungeon_when_no_role, [State, DungeonRole, ResultType, ResultSubtype], true).

calc_role_rewards(State) ->
    #dungeon_state{role_list = RoleList} = State,
    NewRoleList = [
        begin
%%            #dungeon_role{reward_map = Map} = State,
            Rewards = get_send_reward(State, DungeonRole),
            %% 现在是真掉落了，不用模拟掉落
%%            TempReward1 = lib_dungeon:get_source_list_all(Map) ,
%%            TempReward2 =lists:flatten([R  || {_, R} <- Rewards]),
%%            ShowDropReward =
            %%不再是副本退出才发送奖励，计算好好奖励就发送奖励
%%            case Rewards of
%%                {msg, _, [_|_] = Rs} -> ok;
%%                [{base, _}|_] ->
%%                    Rs = lists:flatten([X || {_, X} <- Rewards]),
%%                    {ok, BinData} = pt_610:write(61029, [Rs]),
%%                    send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData);
%%                [_|_] ->
%%                    Rs = Rewards,
%%                    {ok, BinData} = pt_610:write(61029, [Rewards]),  %%
%%                    send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData);
%%                not_send ->
%%                    Rs = Rewards;
%%                _ ->
%%                    Rs = [],
%%                    ok
%%            end,
            send_reward(State, DungeonRole, Rewards),  %%实际发奖励
            DungeonRole
%%            DungeonRole#dungeon_role{calc_reward_list = Rewards}
        end
    || DungeonRole <- RoleList
    ],
    State#dungeon_state{role_list = NewRoleList}.

get_next_wave_time(State) ->
    #dungeon_state{now_scene_id = SceneId} = State,
    F2 = fun
        (#dungeon_event{type = Type, is_trigger = IsTrigger}) ->
            if
                IsTrigger =/= ?DUN_EVENT_TRIGGER_NO ->
                    false;
                true ->
                    case Type of
                        {dungeon_time, _} ->
                            true;
                        {level_time, _} ->
                            true;
                        _ ->
                            false
                    end
            end
    end,
    F = fun
        (#dungeon_common_event{allow_type = Allow, event_list = EventList, scene_id = Sid} = Evt) ->
            if
                Sid =/= SceneId ->
                    false;
                Allow =/= ?DUN_ALLOW_TYPE_YES ->
                    false;
                true ->
                    lib_dungeon_mon_event:is_calc_wave_num(Evt) andalso lists:any(F2, EventList)
            end
    end,
    case lib_dungeon_common_event:get_common_event(State, ?DUN_EVENT_BELONG_TYPE_MON, F) of
        [] ->
            Time = 0;
        CommonEventList ->
            #dungeon_state{start_time = StartTime, level_start_time = LevelTime} = State,
            TimeList = lists:foldl(fun
                (#dungeon_common_event{event_list = EventList}, Acc) ->
                    case ulists:find(F2, EventList) of
                        {ok, #dungeon_event{type = Type}} ->
                            [Type|Acc];
                        _ ->
                            Acc
                    end
            end, [], CommonEventList),
            Time = calc_min_time(StartTime, LevelTime, TimeList, 16#FFFFFFFF, 16#FFFFFFFF)
    end,
    Time.

calc_min_time(StartTime, LevelTime, [{dungeon_time, T}|TimeList], DunTime, LTime) ->
    Time = StartTime + T,
    if
        Time < DunTime ->
            calc_min_time(StartTime, LevelTime, TimeList, Time, LTime);
        true ->
            calc_min_time(StartTime, LevelTime, TimeList, DunTime, LTime)
    end;

calc_min_time(StartTime, LevelTime, [{level_time, T}|TimeList], DunTime, LTime) ->
    Time = LevelTime + T,
    if
        Time < LTime ->
            calc_min_time(StartTime, LevelTime, TimeList, DunTime, Time);
        true ->
            calc_min_time(StartTime, LevelTime, TimeList, DunTime, LTime)
    end;

calc_min_time(_StartTime, _LevelTime, [], DunTime, LTime) ->
    min(DunTime, LTime).

revive_dead_man(#dungeon_state{dun_type = ?DUNGEON_TYPE_EQUIP} = State) ->
    #dungeon_state{role_list = RoleList} = State,
    NewRoleList
    = [
        begin
            case DungeonRole of
                #dungeon_role{id = RoleId, hp = 0, revive_ref = OldRef, hp_lim = HpLim, node = RoleNode} ->
                    util:cancel_timer(OldRef),
                    lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_DUNGEON, []]),
                    DungeonRole#dungeon_role{hp = HpLim, revive_ref = none};
                _ ->
                    DungeonRole
            end
        end || DungeonRole <- RoleList
    ],
    State#dungeon_state{role_list = NewRoleList};
revive_dead_man(State) ->
    State.

nobody_in_dungeon(State) ->
    case State#dungeon_state.role_list of
        [] ->
            true;
        _ ->
            false
    end.

pull_player_into_dungeon(State, DungeonRole) ->
    #dungeon_state{
        dun_id = DunId, dun_type = DunType, now_scene_id = NowSceneId, scene_pool_id = ScenePoolId, revive_map = ReviveMap,
        wave_num = WaveNum, is_end = IsEnd} = State,
    #dungeon_role{pid = RolePid, node = Node,
        scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY,
        dead_time = DeadTime, revive_count = ReviveCount, hp = Hp, hp_lim = HpLim, location = Location,
        help_type = HelpType, data_before_enter = DataBfEnter, setting_list = SettingList,
        count = Count} = DungeonRole,
    Out = #dungeon_out{scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY},
    CopyId = self(),
    case DunType of
        ?DUNGEON_TYPE_ENCHANTMENT_GUARD -> NewRoleX = OutX, NewRoleY = OutY;
	    ?DUNGEON_TYPE_MAIN -> NewRoleX = OutX, NewRoleY = OutY;
	    ?DUNGEON_TYPE_DAILY -> NewRoleX = OutX, NewRoleY = OutY;
        _ -> #ets_scene{x = NewRoleX, y = NewRoleY} = data_scene:get(NowSceneId)
    end,
    Reply = [DunId, DunType, NowSceneId, ScenePoolId, CopyId, NewRoleX, NewRoleY, Hp, HpLim, DeadTime, ReviveCount, Out, ReviveMap, IsEnd,
        HelpType, DataBfEnter, Location, SettingList, WaveNum, Count],
    lib_player:apply_cast(Node, RolePid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, pull_player_into_dungeon, [Reply]).

send_to_uid(Node, RoleId, BinData) ->
    case node() of
        Node ->
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            rpc:cast(Node, lib_server_send, send_to_uid, [RoleId, BinData])
    end.

calc_mon_score(#dungeon_state{dun_type = ?DUNGEON_TYPE_EVIL, enter_lv = Lv}, Score) ->
    max(1, Lv - 370) * Score;

calc_mon_score(_, Score) -> Score.

update_relationship(RoleList, DunId) ->
    F = fun
        (#dungeon_role{node = Node, team_id = TeamId, id = RoleId}, Map) ->
            NodeMap = maps:get(Node, Map, #{}),
            RoleL = maps:get(TeamId, NodeMap, []),
            NewNodeMap = NodeMap#{TeamId => [RoleId|RoleL]},
            Map#{Node => NewNodeMap}
    end,
    PartByNode = lists:foldl(F, #{}, RoleList),
    maps:map(fun
        (Node, TeamMap) ->
            SlimTeam = maps:filter(fun(_, RoleIds) -> length(RoleIds) > 1 end, TeamMap),
            case maps:size(SlimTeam) of
                0 ->
                    skip;
                _ ->
                    unode:apply(Node, lib_relationship_api, event_trigger, [{pass_dun, DunId, SlimTeam}])
            end
    end, PartByNode).

get_drop_times(Figure, DunType, DropTimeArgs) ->
    CheckDungeonDrop = lib_dungeon_api:check_custom_act_drop_times(Figure),
    case lib_dungeon_api:get_custom_act_drop_times(DunType) of
        N when N > 1, CheckDungeonDrop ->
            N;
        _ ->
            calc_drop_times_args(DunType, DropTimeArgs)
    end.

calc_drop_times_args(DunType, [{collect_drop_end, DropEndTime}|T]) ->
    case lib_collect:get_custom_act_drop_times(DunType, DropEndTime) of
        N when N > 1 ->
            N;
        _ ->
            calc_drop_times_args(DunType, T)
    end;

calc_drop_times_args(_, _) -> 1.

%% 获得推送结算的类型
get_push_settlement_type(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{push_settlement_type = PushSettlementType} -> PushSettlementType;
        _ -> ?PUSH_SETTLEMENT_TYPE_WHEN_OUT
    end.

finish_last_dungeon(State) ->
%%    NewState = handle_send_reward(State),  %%cym  切换副本的时候不再发送奖励，而是在计算奖励的时候发送
    NewState = State,
    #dungeon_state{
        scene_list = SceneList, open_scene_list = OpenSceneList,
        scene_pool_id = ScenePoolId, force_quit_ref = ForceQuitRef,
        flow_quit_ref = FlowQuitRef
        } = NewState,
    ClearSceneList = util:ulist(OpenSceneList++SceneList),
    Pid = self(),
    [lib_scene:clear_scene_room(SceneId, ScenePoolId, Pid)||SceneId<-ClearSceneList],
    % 清理定时器
    lib_dungeon_mod:clear_ref(State),
    % 清理强制登出定时器
    util:cancel_timer(ForceQuitRef),
    % 清理流程登出定时器
    util:cancel_timer(FlowQuitRef),
    NewState.

%% -----------------------------------------------------------------
%% @desc     功能描述  设置奖励，用于推结算的客户端显示，  设置奖励， 检查是否要推送结算奖励给客户端
%% @param    参数      SourceRewardList::[{来源, 奖励列表}]  奖励列表:: [{GoodType, GoodId, Num, AutoId}]
%%                    IsPushSettlement::boolean() 是否已经推送了 防止重复推送
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
set_reward(RoleId, SourceRewardList, _IsPushSettlement, State) ->
%%    ?MYLOG("cym", "set_reward  SourceRewardList ~p~n", [SourceRewardList]),
    #dungeon_state{role_list = DungeonRoleList, is_end = _IsEnd} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, DungeonRoleList) of
        #dungeon_role{} = DungeonRole ->
            LastDungeonRole = set_reward_help(State, DungeonRole, SourceRewardList),
            NewDungeonRoleList = lists:keystore(RoleId, #dungeon_role.id, DungeonRoleList, LastDungeonRole),
            NewState = State#dungeon_state{role_list = NewDungeonRoleList},
            NewState;
        _ ->%%可能已经退出了
            State
    end.

set_reward_help(State, DungeonRole, SourceRewardList) ->
    #dungeon_state{dun_id = DunId} = State,
    #dungeon_role{id = RoleId, reward_map = RewardMap, is_push_settle = IsHadPushSettle} = DungeonRole,
    F = fun({Source, RewardList}, AccMap) ->
        OldRewardList = maps:get(Source, AccMap, []),
        CombineRewardL = lib_goods_api:combine_object_with_auto_goods_id(RewardList ++ OldRewardList),
        maps:put(Source, CombineRewardL, AccMap)
    end,
    NewRewardMap        = lists:foldl(F, RewardMap, SourceRewardList),  %%新的奖励列表
    Flag                = maps:is_key(?REWARD_SOURCE_DUNGEON, NewRewardMap), %%是否有副本的通关奖励,有则设置已经领取奖励
    NewDungeonRole      = DungeonRole#dungeon_role{
        is_reward = ?IF(Flag == true, ?DUN_IS_REWARD_YES, ?DUN_IS_REWARD_NO),
        reward_map = NewRewardMap
        }, %%设置推送状态
%%            ,is_push_settle = ?IF(IsPushSettlement == true, ?DUNGEON_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_NO)

    %%检查是否立刻推送
    IsPushSettlement = is_push_settlement(State, NewDungeonRole),
    %%是否满足条件推送
    % IsAllRewardSet      = is_all_reward_set(NewRewardMap),
    % ?MYLOG("cym", "IsPushSettlement:~p, Flag:~p IsHadPushSettle:~p NewRewardMap:~p~n",
    %     [IsPushSettlement, Flag, IsHadPushSettle, NewRewardMap]),
%%    ?MYLOG("cym", "IsHadPushSettle ~p~n", [IsHadPushSettle]),
    if
        % 已经推送过的话追加
        IsHadPushSettle == ?DUNGEON_PUSH_SETTLE_YES ->
%%            ?MYLOG("cym", "set_reward  SourceRewardList ~p~n", [SourceRewardList]),
            {ok, BinData} = pt_610:write(61049, [DunId, SourceRewardList]),
            send_to_uid(DungeonRole#dungeon_role.node, RoleId, BinData),
            LastDungeonRole = NewDungeonRole;
        % 主奖励直接推送结算
        IsPushSettlement andalso Flag -> % andalso IsAllRewardSet ->
            LastDungeonRole = NewDungeonRole#dungeon_role{is_push_settle = ?DUNGEON_PUSH_SETTLE_YES},
            lib_dungeon_mod:push_settlement(State, NewDungeonRole);
        true ->
            LastDungeonRole = NewDungeonRole#dungeon_role{is_push_settle = ?DUNGEON_PUSH_SETTLE_NO}
    end,
    LastDungeonRole.

%%获取log所需奖励格式
get_log_reward_from_source_map(RewardMap) ->
    RewardList1 = lib_dungeon:get_source_list_all(RewardMap),
    RewardList2 = [{GoodsType, GoodsId, Num} || {GoodsType, GoodsId, Num, _} <- RewardList1],
    RewardList  = ulists:object_list_plus([RewardList2, []]),
    RewardList.

is_all_reward_set(RewardMap) ->
    %%    HaveDrop = maps:is_key(?REWARD_SOURCE_DROP, RewardMap),       %%普通掉落
    HaveOtherDrop = maps:is_key(?REWARD_SOURCE_OTHER_DROP, RewardMap), %%额外掉落
    HaveDungeonReward = maps:is_key(?REWARD_SOURCE_DUNGEON, RewardMap),
    if
        HaveOtherDrop andalso HaveDungeonReward ->
            true;
        true ->
            false
    end.

%% 玩家回答副本题目
answer_dun_question(State, RoleId, Answer) ->
    #dungeon_state{dun_type = DunType, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {ok, State};
        #dungeon_role{} ->
            NewState = lib_dungeon_api:invoke(DunType, dunex_answer_dun_question, [State, RoleId, Answer], State),
            {ok, NewState}
    end.

%%是否在玩家进程中直接推送， 除了几种情况之外都要推送，
is_push_settlement(#dungeon_state{result_type = Type, result_subtype = SubType, dun_id = DunId} = _State, _DungeonRole) ->
    PushType = lib_dungeon_mod:get_push_settlement_type(DunId),
%%    ?MYLOG("cym", "Type ~p SubType ~p PushType ~p~n", [Type, SubType, PushType]),
    if
        Type == ?DUN_RESULT_TYPE_SUCCESS andalso SubType == ?DUN_RESULT_SUBTYPE_NO-> %%副本挑战成功
            if
                PushType == ?PUSH_SETTLEMENT_TYPE_WHEN_FINISH -> %%副本结束就推结算， 则立刻推送结算
                    true;
                true ->  %%退出副本才推结算的，
                    false
            end;
        Type == ?DUN_RESULT_TYPE_FAIL andalso SubType == ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT -> %%主动退出，只能是立刻推结算
            true;
        Type == ?DUN_RESULT_TYPE_FAIL andalso SubType == ?DUN_RESULT_SUBTYPE_LOGOUT -> %%强制退出的，推结算客户也看不了，但是这里还是设置为推结算
            true;
        true ->
            true
    end.

%%解析Reward,且返回produce
get_dungeon_produce(Reward, State, _DungeonRole) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, team_id = TeamId} = State,
    Name = lib_dungeon_api:get_dungeon_name(DunId),
    case TeamId > 0 of
        true -> OffContent = utext:get(91, [Name]);
        false -> OffContent = utext:get(90, [Name])
    end,
    BaseReward      = lib_dungeon:get_reward_by_source(Reward, ?REWARD_SOURCE_DUNGEON),
    FirstReward     = lib_dungeon:get_reward_by_source(Reward, ?REWARD_SOURCE_FIRST),
    MultipleReward  = lib_dungeon:get_reward_by_source(Reward, ?REWARD_SOURCE_DUNGEON_MULTIPLE),
    WeeklyCardReward  = lib_dungeon:get_reward_by_source(Reward, ?REWARD_SOURCE_WEEKLY_CARD),
    Produce = #produce{
        type = dungeon, subtype = DunId, title = utext:get(89, [Name]), content = utext:get(92, [Name]),
        off_title = utext:get(89, [Name]), off_content = OffContent,
        reward = BaseReward ++ FirstReward ++ MultipleReward ++ WeeklyCardReward, remark = lists:concat(["dungeon DunId:", DunId, ",DunType:", DunType]),
        show_tips = ?SHOW_TIPS_3
    },

    {Produce, BaseReward, FirstReward, MultipleReward, WeeklyCardReward}.

get_exp_got(State, [RoleId, Sid, LvBefore, ExpBefore, NewLv, NewExp]) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType} = State,
    NewState = case lib_dungeon_api:get_special_api_mod(DunType, dunex_get_exp_got, 2) of
        undefined ->
            AccExp = lib_dungeon:calc_got_exp(NewLv, NewExp, LvBefore, ExpBefore),
            {ok, BinData} = pt_610:write(61041, [DunId, AccExp]),
            lib_server_send:send_to_sid(Sid, BinData),
            State;
        Mod ->
            Mod:dunex_get_exp_got(State, [RoleId, Sid, LvBefore, ExpBefore, NewLv, NewExp])
    end,
    {ok, NewState}.


set_dungeon_start_wave_num(State, StartWaveNum) ->
    #dungeon_state{dun_id = _DunId, common_event_map = CommonEventMap} = State,
    BelongType1 = ?DUN_EVENT_BELONG_TYPE_MON,
    F = fun({BelongType, CommonEventId}, CommonEvent, CommonEventMapTmp) ->
        #dungeon_common_event{wave_type = _WaveType, args = Args, event_list = EventList} = CommonEvent,
        case BelongType1 =/= BelongType of
            true ->
               CommonEventMapTmp;
            _ ->
                {_, WaveNum} = ulists:keyfind(wvn, 1, Args, {wvn, 0}),
                if
                    WaveNum < 1 ->
                        CommonEventMapTmp;
                    WaveNum < StartWaveNum ->
                        NewCommonEventMapTmp = maps:remove({BelongType, CommonEventId}, CommonEventMapTmp),
                        NewCommonEventMapTmp;
                    WaveNum == StartWaveNum ->
                        MaxEventId = lists:max([Id||#dungeon_event{id = Id} <- EventList] ++ [0]),
                        NewEventList = lib_dungeon_common_event:make_event_list([{dungeon_time, 0}], MaxEventId+1, []),
                        NewCommonEvent = CommonEvent#dungeon_common_event{event_list = NewEventList},
                        NewCommonEventMapTmp = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMapTmp),
                        NewCommonEventMapTmp;
                    true ->
                        CommonEventMapTmp
                end
        end
    end,
    NewCommonEventMap = maps:fold(F, CommonEventMap, CommonEventMap),
    NewState = State#dungeon_state{common_event_map = NewCommonEventMap, group_map = #{}, wave_num = StartWaveNum-1},
    StateAfGroup = lib_dungeon_common_event:make_group_map(NewState),
    TimeList = calc_static_time_list(StateAfGroup),
    %?PRINT("TimeList:~p~n", [[Time-utime:unixtime() ||Time <- TimeList]]),
    StateAfRef = calc_ref(StateAfGroup#dungeon_state{time_list = TimeList}),
    {ok, StateAfRef}.

%% 补发奖励
reissue_drop_reward(State, DungeonRole) ->
    #dungeon_state{dun_id = DunId, now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
    #dungeon_role{id = RoleId, node = RoleNode, drop_list = DropList, setting = SettingMap} = DungeonRole,
    DropGoods = lib_goods_api:make_reward_unique(lib_dungeon:pick_all(DropList)),
    LastDropGoods = filter_drop_reward(DropGoods, SettingMap),
    if
       LastDropGoods =/= [] ->
            Name = lib_dungeon_api:get_dungeon_name(DunId),
            Title = utext:get(89, [Name]),
            Content = utext:get(6100001, [Name]),
            unode:apply(RoleNode, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, LastDropGoods]),
            mod_drop:pick_all(RoleId, SceneId, ScenePoolId, self(), auto_pick);
       true ->
           ok
    end,
    SeeRewardList = lib_goods_api:make_see_reward_list(LastDropGoods, []),
    SourceRewardList = [{?REWARD_SOURCE_DROP, SeeRewardList}],
    NewDungeonRole = set_reward_help(State, DungeonRole, SourceRewardList),
    NewDungeonRole.

%% 发送之前过滤未拾取物品
filter_drop_reward(DropGoods, SettingMap) ->
    SettingType = ?SYS_SETTING,
    BlueSetting = maps:get({SettingType, ?PICK_UP_BLUE}, SettingMap, #setting{}), %% 蓝色及以下开关
    PurpleSetting = maps:get({SettingType, ?PICK_UP_PURPLE}, SettingMap, #setting{}), %% 紫色开关
    OrangeSetting = maps:get({SettingType, ?PICK_UP_ORANGE}, SettingMap, #setting{}), %% 橙色以上开关
    F = fun({_, GoodsTypeId, _}) ->
        case data_goods_type:get(GoodsTypeId) of
            #ets_goods_type{type = Type, color = Color} ->
                case Type == ?GOODS_TYPE_EQUIP of
                    true -> %% 装备，没开启全部过滤掉
                        %% 星数
                        #equip_attr_cfg{star = Star} = data_equip:get_equip_attr_cfg(GoodsTypeId),
                        if
                            Color =< ?BLUE andalso BlueSetting#setting.is_open == 0 -> false;
                            Color == ?PURPLE andalso PurpleSetting#setting.is_open == 0 -> false;
                            Color >= ?ORANGE andalso Star == 1 andalso OrangeSetting#setting.is_open == 0 -> false;
                            true -> true
                        end;
                    false -> true
                end;
            _ ->
                false
        end
    end,
    lists:filter(F, DropGoods).

% %% 活动结束后处理复活定时器
% handle_revive_ref_af_end(RoleList) ->
%     F = fun(#dungeon_role{id = RoleId, hp_lim = HpLim, revive_ref = OldRef, node = Node} = DungeonRole) ->
%         case catch erlang:read_timer(OldRef) of
%             N when is_integer(N) ->
%                 lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_DUNGEON, []]),
%                 DungeonRole#dungeon_role{hp = HpLim, revive_ref = none};
%             _ ->
%                 DungeonRole
%         end
%     end,
%     lists:foreach(F, RoleList).

%% 快速出怪
quick_create_mon(State, RoleId, ServerId) ->
    case check_quick_create_mon(State, RoleId) of
        {false, ErrorCode} -> StateAfRef = State;
        true ->
            ErrorCode = ?SUCCESS,
            StateAfQuick = do_quick_create_mon(State, RoleId),
            % 定时器处理
            TimeList = calc_static_time_list(StateAfQuick),
            StateAfRef = calc_ref(StateAfQuick#dungeon_state{time_list = TimeList})
    end,
    %?MYLOG("dundragon", "quick_create_mon ~p~n", [ErrorCode]),
    {ok, BinData} = pt_610:write(61052, [ErrorCode]),
    apply_cast_to_local(StateAfRef, ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    send_quick_create_mon_info(StateAfRef),
    StateAfRef.

check_quick_create_mon(#dungeon_state{dun_type = DunType, dun_id = DunId} = State, RoleId) ->
    case lib_dungeon_api:can_quick_create_mon(DunType, DunId) of
        {MaxQuickCount, QuickCd} ->
            #dungeon_state{role_list = RoleList, last_quick_time = LastQuickTime} = State,
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                false -> QuickCount = 0;
                #dungeon_role{quick_count = QuickCount} -> ok
            end,
            NowTime = utime:unixtime(),
            if
                QuickCount >= MaxQuickCount -> {false, ?ERRCODE(err610_not_enough_quick_create_mon_count)};
            % 稍微减少几秒,防止网络延迟
                NowTime < LastQuickTime + QuickCd - 2 -> {false, ?ERRCODE(err610_on_quick_create_mon_cd)};
                true -> true
            end;
        _ ->
            {false, ?FAIL}
    end.


do_quick_create_mon(State, RoleId) ->
    #dungeon_state{role_list = RoleList, common_event_map = CommonEventMap, quick_count = SumQuickCount, dun_type = DunType, dun_id = DunId} = State,
    QuickTime = lib_dungeon_api:get_quick_time(DunType, DunId),
    F = fun(
        _Key
        , #dungeon_common_event{
            belong_type = BelongType, event_list = EventList,
            first_time = FirstTime
        } = CommonEvent) ->
        case BelongType == ?DUN_EVENT_BELONG_TYPE_MON andalso FirstTime == 0 of
            true ->
                NewEventList = do_quick_create_mon(EventList, QuickTime, []),
                CommonEvent#dungeon_common_event{event_list = NewEventList};
            false ->
                CommonEvent
        end
    end,
    NewCommonEventMap = maps:map(F, CommonEventMap),
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewRoleList = RoleList;
        #dungeon_role{quick_count = QuickCount} = DungeonRole ->
            NewDungeonRole = DungeonRole#dungeon_role{quick_count = QuickCount+1},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole)
    end,
    State#dungeon_state{
        role_list = NewRoleList, common_event_map = NewCommonEventMap,
        quick_count = SumQuickCount+1, last_quick_time = utime:unixtime()
    }.

do_quick_create_mon([], _QuickTime, EventList) -> lists:reverse(EventList);
do_quick_create_mon([#dungeon_event{type = Type}=H|T], QuickTime, EventList) ->
    case Type of
        {dungeon_time, Time} -> NewType = {dungeon_time, Time-QuickTime};
        _ -> NewType = Type
    end,
    NewH = H#dungeon_event{type = NewType},
    do_quick_create_mon(T, QuickTime, [NewH|EventList]).

%% 快速出怪信息
send_quick_create_mon_info(State, RoleId, ServerId) ->
    {QuickCount, SumQuickCount, NextQuickTime} = get_quick_create_mon_info(State, RoleId),
    %?MYLOG("dundragon", "send_quick_create_mon_info ~p~n", [{QuickCount, SumQuickCount, NextQuickTime}]),
    {ok, BinData} = pt_610:write(61053, [QuickCount, SumQuickCount, NextQuickTime]),
    apply_cast_to_local(State, ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    ok.

%% 获得快速出怪信息
get_quick_create_mon_info(State, RoleId) ->
    #dungeon_state{role_list = RoleList, quick_count = SumQuickCount, last_quick_time = LastQuickTime, dun_type = DunType, dun_id = DunId} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> QuickCount = 0;
        #dungeon_role{quick_count = QuickCount} -> ok
    end,
    case lib_dungeon_api:can_quick_create_mon(DunType, DunId) of
        {_MaxQuickCount, QuickCd} ->
            {QuickCount, SumQuickCount, LastQuickTime+QuickCd};
        _ ->
            {0, 0, 0}
    end.

%% 快速出怪信息
send_quick_create_mon_info(State) ->
    #dungeon_state{role_list = RoleList} = State,
    [send_quick_create_mon_info(State, RoleId, ServerId)||#dungeon_role{id = RoleId, server_id = ServerId}<-RoleList],
    ok.

%% 同步到本服
apply_cast_to_local(State, DungeonRole, Module, Method, Args) when is_record(State, dungeon_state), is_record(DungeonRole, dungeon_role) ->
    #dungeon_state{now_scene_id = Scene} = State,
    #dungeon_role{server_id = ServerId} = DungeonRole,
    apply_cast_to_local(Scene, ServerId, Module, Method, Args);
apply_cast_to_local(State, ServerId, Module, Method, Args) when is_record(State, dungeon_state) ->
    #dungeon_state{now_scene_id = Scene} = State,
    apply_cast_to_local(Scene, ServerId, Module, Method, Args);
%% @param ServerId node() | integer()
apply_cast_to_local(Scene, ServerId, Module, Method, Args) ->
    case lib_scene:is_clusters_scene(Scene) of
        true -> mod_clusters_center:apply_cast(ServerId, Module, Method, Args);
        false -> erlang:apply(Module, Method, Args)
    end.

%% 拾取怪物
pick_mon(#dungeon_state{dun_id = _DunId, dun_type = DunType, role_list = RoleList} = State, DungeonRole, _Mid,
    _Coord, [{SkillId, _SkillLv}|_]) when DunType == ?DUNGEON_TYPE_DRAGON ->
    % 测试id
    % SkillId = 2800205,
    #dungeon_role{id = RoleId, skill_list = SkillList} = DungeonRole,
    SkillRes = lists:keyfind(SkillId, 1, SkillList),
    {SkillId, SkillNum} = ?IF(SkillRes == false, {SkillId, 0}, SkillRes),
    NewSkillList = lists:keystore(SkillId, 1, SkillList, {SkillId, SkillNum + 1}),
    NewDungeonRole = DungeonRole#dungeon_role{skill_list = NewSkillList},
    NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
    NewState = State#dungeon_state{role_list = NewRoleList},
%%    {ok, BinData1} = pt_609:write(60910, [Mid, X, Y]),
    {ok, BinData} = pt_610:write(61055, [NewSkillList]),
    apply_cast_to_local(NewState, DungeonRole, lib_server_send, send_to_uid, [RoleId, BinData]),
    NewState;
%% 拾取怪物
pick_mon(#dungeon_state{dun_type = DunType} = State, DungeonRole, Mid, _Coord, SkillList) when DunType == ?DUNGEON_TYPE_WEEK_DUNGEON ->
    NewState = lib_week_dungeon:pick_mon(State, DungeonRole, Mid, SkillList),
    NewState;
pick_mon(State, _DungeonRole, _Mid, _Coord, _Skill) -> State.


%% 释放技能
casting_skill(#dungeon_state{dun_id = _DunId, dun_type = DunType, role_list = RoleList} = State, DungeonRole, SkillId) when
    DunType == ?DUNGEON_TYPE_DRAGON ->
    #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
    %% 给场景内的队友，或者防守怪物加buff技能
    #dungeon_role{id = RoleId, skill_list = SkillList} = DungeonRole,
    case lists:keyfind(SkillId, 1, SkillList) of
        {SkillId, SkillNum} when SkillNum >0 ->
            NewSkillList = lists:keystore(SkillId, 1, SkillList, {SkillId, max(SkillNum - 1, 0)}),
            NewDungeonRole = DungeonRole#dungeon_role{skill_list = NewSkillList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_dungeon_mod, casting_skill_in_scene, [DunType, self(), RoleId, SkillId]),
            {ok, BinData1} = pt_610:write(61056, {?SUCCESS}),
            {ok, BinData2} = pt_610:write(61055, [NewSkillList]),
            apply_cast_to_local(NewState, DungeonRole, lib_server_send, send_to_uid, [RoleId, BinData1]),
            apply_cast_to_local(NewState, DungeonRole, lib_server_send, send_to_uid, [RoleId, BinData2]);
%%            send_skill_tv(NewState, DungeonRole, ?MOD_DUN_DRAGON, SkillId);
        _ ->
            {ok, BinData} = pt_610:write(61056, {?ERRCODE(err217_not_enough_skill)}),
            apply_cast_to_local(State, DungeonRole, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewState = State
    end,
    NewState;
casting_skill(State, _DungeonRole, _SkillId) ->
    State.

casting_skill_in_scene(?DUNGEON_TYPE_DRAGON, CopyId, RoleId, SkillId) ->
    F = fun(#ets_scene_user{} = EtsSceneUser) ->
        #ets_scene_user{id = PlayerId, scene = SceneId, scene_pool_id = ScenePoolId} = EtsSceneUser,
        lib_battle_api:assist_anything(SceneId, ScenePoolId, ?BATTLE_SIGN_PLAYER, RoleId,
            ?BATTLE_SIGN_PLAYER, PlayerId, SkillId, 1)
    end,
    lists:foreach(F, lib_scene_agent:get_scene_user(CopyId));
%%    if
%%    %% 给场景内队友加buff
%%        SkillId == 2800203 orelse SkillId == 2800204 ->
%%            F = fun(#ets_scene_user{} = EtsSceneUser) ->
%%                #ets_scene_user{id = PlayerId, scene = SceneId, scene_pool_id = ScenePoolId} = EtsSceneUser,
%%                lib_battle_api:assist_anything(SceneId, ScenePoolId, ?BATTLE_SIGN_PLAYER, RoleId,
%%                    ?BATTLE_SIGN_PLAYER, PlayerId, SkillId, 1)
%%            end,
%%            lists:foreach(F, lib_scene_agent:get_scene_user(CopyId));
%%    %% 给守护怪加buff
%%        SkillId == 2800205 ->
%%            % Mids = [2901001, 2901002, 2901003],
%%            Mids = lists:seq(2901001, 2901015),
%%            F = fun(#scene_object{} = EtsSceneObject) ->
%%                #scene_object{id = MonAutoId, scene = SceneId, scene_pool_id = ScenePoolId} = EtsSceneObject,
%%                lib_battle_api:assist_anything(SceneId, ScenePoolId, ?BATTLE_SIGN_PLAYER, RoleId,
%%                    ?BATTLE_SIGN_MON, MonAutoId, SkillId, 1)
%%            end,
%%            SceneObjectList = lib_scene_object_agent:get_scene_mon_by_mids(CopyId, Mids, all),
%%            lists:foreach(F, SceneObjectList);
%%        true -> skip
%%    end;
casting_skill_in_scene(_DunType, _CopyId, _RoleId, _SkillId) ->
    skip.

%%send_skill_tv(#dungeon_state{role_list = RoleList} = State, DungeonRole, ModuleId, SkillId) ->
%%    #dungeon_role{server_num = ServerNum, figure = #figure{name = RoleName}} = DungeonRole,
%%    if
%%        SkillId == 2800203 -> LanId = 4;
%%        SkillId == 2800204 -> LanId = 3;
%%        SkillId == 2800205 -> LanId = 5;
%%        true -> LanId = 0
%%    end,
%%    if
%%        LanId>0 ->
%%            [
%%                apply_cast_to_local(State, DunRole, lib_chat, send_TV, [{player, Id},
%%                    ModuleId, LanId, [ServerNum, RoleName]])
%%                ||#dungeon_role{id = Id} = DunRole<-RoleList
%%            ];
%%        true -> skip
%%    end,
%%    ok.

%% 技能信息
send_skill_info(State, DungeonRole) ->
    #dungeon_state{dun_id = DunId} = State,
    case data_dungeon:get(DunId) of
        #dungeon{type = Type} ->
            if
                Type == ?DUNGEON_TYPE_DRAGON ->  %%暂时只有龙纹副本有用
                    #dungeon_role{id = RoleId, skill_list = SkillList} = DungeonRole,
                    {ok, BinData} = pt_610:write(61055, [SkillList]),
                    apply_cast_to_local(State, DungeonRole, lib_server_send, send_to_uid, [RoleId, BinData]);
                true ->
                    skip
            end;
        _ -> skip
    end.

%% 完成一波 更新最佳通关时间
finish_wave(#dungeon_state{dun_type = ?DUNGEON_TYPE_DRAGON} = _State, Wave, WavePassTime) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList, finish_wave_list = FinishWaveList} = _State,
    State = _State#dungeon_state{finish_wave_list = lists:usort([Wave|FinishWaveList])},
    NewRoleList = case data_dungeon_wave:get_wave_helper(DunId, Wave) of
        #dungeon_wave_helper{stage_reward = StageReward} when StageReward=/=[] ->
            F = fun(#dungeon_role{id = RoleId} = DungeonRole, AccRoleList) ->
                NewDungeonRole = update_pass_time_list(DungeonRole, Wave, WavePassTime, State),
                lists:keystore(RoleId, #dungeon_role.id, AccRoleList, NewDungeonRole)
            end,
            lists:foldl(F, RoleList, RoleList);
        _ -> RoleList
    end,
    State#dungeon_state{role_list = NewRoleList};
finish_wave(State, _Wave, _WavePassTime) -> State.

update_pass_time_list(DungeonRole, Wave, WavePassTime, _State) when WavePassTime>0 ->
    #dungeon_role{id = RoleId, pass_time_list = PassTimeList, help_type = _HelpType, team_id = _TeamId,
        history_wave = _HistoryWave} = DungeonRole,
    NewPassTimeList = case lists:keyfind(Wave, 1, PassTimeList) of
        false ->
            lists:keystore(Wave, 1, PassTimeList, {Wave, WavePassTime});
        {Wave, Time} when WavePassTime<Time ->
            lists:keystore(Wave, 1, PassTimeList, {Wave, WavePassTime});
        _ -> PassTimeList
    end,
%%	?MYLOG("dundragon", "NewPassTimeList ~p~n", [NewPassTimeList]),
    %%更新个人状态
%%    #dungeon_state{dun_type = DunType, dun_id = DunId, wave_num = BattleWave, start_time = StartTime, finish_wave_list = FinishWaveList} = State,
%%    FinishWave = ?IF(FinishWaveList==[], 0, lists:max(FinishWaveList)),
%%    DunegonEndInfo = #dungeon_end_info{
%%        help_type = HelpType, dun_pid = self(), dun_id = DunId, dun_type = DunType
%%        , team_id = TeamId, battle_wave = BattleWave
%%        , history_wave = HistoryWave, pass_time_list= NewPassTimeList, finish_wave = FinishWave, start_time = StartTime
%%    },
%%%%                    ?MYLOG("dundragon", "PassTimeList ~p~n", [PassTimeList]),
%%    apply_cast_to_local(State, DungeonRole, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_dungeon, replace_dungeon_wave, [DunegonEndInfo]]),
%%    apply_cast_to_local(State, DungeonRole, lib_dungeon, replace_dungeon_wave_db, [RoleId, DunegonEndInfo]),
    DungeonRole#dungeon_role{id = RoleId, pass_time_list = NewPassTimeList};
update_pass_time_list(DungeonRole, _Wave, _WavePassTime, _State) ->
    DungeonRole.

%% 发送消息
send_info(#dungeon_state{role_list = RoleList} = State) ->
    [send_info(State, DungeonRole)||DungeonRole<-RoleList],
    ok.

send_info(#dungeon_state{start_time = StartTime, start_time_ms = StartTimeMs, end_time = EndTime, wave_num = WaveNum, dun_type = DunType,
    owner_id = OwnerId, level = Level, level_end_time = LevelEndTime} = State
    , DungeonRole) when
    DunType == ?DUNGEON_TYPE_DRAGON->
    #dungeon_role{id = RoleId} = DungeonRole,
    apply_cast_to_local(State, DungeonRole, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_dungeon, send_info,
        [StartTime, StartTimeMs, EndTime, Level, LevelEndTime, OwnerId, WaveNum]]),
    % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_dungeon, send_info, [DunId, DunType, LevelEndTime, BattleWave]),
    ok;
send_info(_State, _RoleId) ->
    ok.

%% 发送面板信息
send_wave_panel_info(#dungeon_state{role_list = RoleList} = State) ->
    F = fun(#dungeon_role{id = RoleId}, TmpState) ->
        NewTmpState = send_wave_panel_info(TmpState, RoleId),
        NewTmpState
    end,
    lists:foldl(F, State, RoleList).

send_wave_panel_info(State, RoleId) ->
    #dungeon_state{dun_type = DunType} = State,
    case lib_dungeon_api:invoke(DunType, dunex_send_wave_panel_info, [State, RoleId], State) of
        NewState when is_record(NewState, dungeon_state) -> NewState;
        _ -> State
    end.

%% 根据当前波数重新计算事件Map[注意:特殊副本才需要重新计算]
%% PreparationTime 副本准备时间
calc_common_event_map_by_cur_wave(CommonEventMap, CurWave, PreparationTime) ->
    DiffTime = get_wave_refresh_time(CurWave + 1, CommonEventMap) - PreparationTime,
    F = fun({BelongType, CommonEventId}, CommonEvent, TmpMap) ->
        #dungeon_common_event{args = Args, event_list = EventList} = CommonEvent,
        case lists:keyfind(wave_no, 1, Args) of
            false -> TmpMap;
            {wave_no, WaveNo} ->
                if
                    BelongType == ?DUN_EVENT_BELONG_TYPE_MON andalso CurWave >= WaveNo ->
                        maps:remove({BelongType, CommonEventId}, TmpMap);
                    CurWave == 0 -> TmpMap;
                    CurWave+1 == WaveNo ->
                        NewEventList = do_quick_create_mon(EventList, DiffTime, []),
                        NewCommonEvent = CommonEvent#dungeon_common_event{event_list = NewEventList},
                        maps:put({BelongType, CommonEventId}, NewCommonEvent, TmpMap);
                    true ->
                        NewEventList = do_quick_create_mon(EventList, DiffTime, []),
                        NewCommonEvent = CommonEvent#dungeon_common_event{event_list = NewEventList},
                        maps:put({BelongType, CommonEventId}, NewCommonEvent, TmpMap)
                end
        end
    end,
    maps:fold(F, CommonEventMap, CommonEventMap).

%% -----------------------------------------------------------------
%% @desc     功能描述  获取Wave波数刷新的时间
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_wave_refresh_time(Wave, CommonEventMap) ->
    case maps:get({?DUN_EVENT_BELONG_TYPE_MON, Wave}, CommonEventMap, []) of
        #dungeon_common_event{event_list = EventList} ->
            get_wave_refresh_time2(EventList);
        _ ->
            0
    end.

get_wave_refresh_time2([]) ->
    0;
get_wave_refresh_time2([#dungeon_event{type = Type} | T]) ->
    case Type of
        {dungeon_time, Time} ->
            Time;
        _ ->
            get_wave_refresh_time2(T)
    end.

%% 副本中玩家是否已经全部阵亡并且没有复活次数
player_die_without_revive(State) ->
    #dungeon_state{dun_type = DunType, role_list = RoleList} = State,
    LeftReviveCount = lib_dungeon_api:invoke(DunType, dunex_get_revive_left_count, [State], 0),
    NotAllRoleDie = ([1 ||#dungeon_role{hp = Hp, online = OnLine} <- RoleList, Hp =/= 0, OnLine == ?DUN_ONLINE_YES] =/= []),
    case LeftReviveCount == 0 andalso NotAllRoleDie =/= true of
        true -> true;
        _ -> false
    end.



%%
%% -----------------------------------------------------------------
%% @desc     功能描述  是否做延时加载功能，  由于u3d 的加载进入场景时延迟几秒
%%           1 玩家进入场景，加载副本
%%           2 定时器时间到了，加载副本
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_need_delay_load_dun(_DunId) -> false.
    % case data_dungeon:get(DunId) of
    %     #dungeon{type = Type} ->
    %         ok;
    %     _ ->
    %         Type = 0
    % end,
    % case lists:member(Type, ?DELAY_DUN_LIST) of
    %     true ->
    %         true;
    %     _ ->
    %         false
    % end.


%% 副本预加载
dun_pre_load(DunId, TeamId, RoleList, Args) ->
    % 设置副本关闭的时间.
    Dun = data_dungeon:get(DunId),
    #dungeon{type = DunType, level_change_type = LevelChangeType, scene_list = SceneList, time = _Time, scene_id = SceneId} = Dun,
    Unixtime = utime:unixtime(),
%%    EndTime = Unixtime + Time,
    % 场景进程id
    ScenePoolId = 0,
    EnterLv = lib_dungeon:calc_enter_lv(RoleList, DunType),
    % 副本数据.
    OwnerId
        = case RoleList of
              [First|_] ->
                  First#dungeon_role.id;
              _ ->
                  0
          end,
    LoadRef = util:send_after([], ?DELAY_LOAD_MAX_TIME * 1000, self(), {delay_load_dun}),
    % 基本数据初始化
    State = #dungeon_state{
        dun_id = DunId
        , scene_list = SceneList
        , dun_type = DunType
        , level_change_type = LevelChangeType
        , scene_pool_id = ScenePoolId
        , team_id = TeamId
        , enter_lv = EnterLv
%%      , start_time = Unixtime
%%      , start_time_ms = utime:longunixtime()
        , role_list = RoleList
        , wave_num = 0
%%      , end_time = EndTime
        , owner_id = OwnerId
        , begin_scene_id = SceneId
        , now_scene_id = SceneId
        , open_scene_list = [SceneId]
        %%延迟加载信息
        , load_status = ?DUN_NOT_LOAD   %
        , load_ref = LoadRef                 % 定时加载定时定时器
        , load_time = Unixtime + ?DELAY_LOAD_MAX_TIME
        , load_args = Args
    },

    %%%%%%%%%%%%%%%%%%%%%%  加载信息  %%%%%%%%%%%%%%%%%%%%%%%%%
%%    % 设置副本记录
%%    StateAfSet = set_dun_state(Args, State),  %% 考虑一下，要不要在副本预加载添加
%%    % 根据类型做特殊处理
%%    StateAfTypeInit = init_by_dun_type(StateAfSet, Dun),
%%    % 分组
%%    StateAfGroup = lib_dungeon_common_event:make_group_map(StateAfTypeInit),
%%    % 处理触发事件
%%    StateAfEvent = lib_dungeon_common_event:check_and_execute(StateAfGroup),
%%    % 构造副本场景辅助信息
%%    StateAfSceneHelper = lib_dungeon_common_event:make_dungeon_scene_helper(StateAfEvent),
%%    StateAfMonHelper = lib_dungeon_common_event:make_mon_scene_helper(StateAfSceneHelper),
%%    TimeList = calc_static_time_list(StateAfMonHelper),
%%    StateAfRef = calc_ref(StateAfMonHelper#dungeon_state{time_list = TimeList}),
%%    % 同步数据到其他进程
%%    SetDunRecord = fun(RoleId) ->
%%        DunRecoed = #dungeon_record{
%%            role_id = RoleId,
%%            dun_pid = self(),
%%            dun_id = DunId,
%%            end_time = EndTime
%%        },
%%        mod_dungeon_agent:set_dungeon_record(DunRecoed)
%%                   end,
%%    #dungeon_state{role_list = NewRoleList} = StateAfRef,
%%    [SetDunRecord(DunRole#dungeon_role.id) || DunRole <- NewRoleList],
    %%%%%%%%%%%%%%%%%%%%%%  加载信息  %%%%%%%%%%%%%%%%%%%%%%%%%
    RoleIdList = [DungeonRole#dungeon_role.id||DungeonRole<- RoleList],
    [begin
         pull_player_into_dungeon(State, DungeonRole)  %% 数据 波数， 复活时间可能有点问题，后面再仔细看看
     end||DungeonRole<-RoleList],
    % 组队大厅的处理
    case TeamId > 0 of
        true -> mod_team:cast_to_team(TeamId, {'someone_enter_dungeon', RoleIdList, DunId});
        false -> skip
    end,
    FinalState = State,
    log_dungeon(FinalState, ?DUN_LOG_TYPE_ENTER, []),
    {ok, FinalState}.


delay_load_dun(#dungeon_state{load_status = ?DUN_HAD_LOAD} = State) ->
    State;
delay_load_dun(OldState) ->
    %%
%%    ?MYLOG("dungeon", "delay_load_dun+++++++++++++++++++~n", []),
    #dungeon_state{load_args = Args, dun_id = DunId, load_ref = LoadRef, dummy_args_list = DummyArgsList} = OldState,
    Dun = data_dungeon:get(DunId),
    #dungeon{time = Time, scene_id = _SceneId} = Dun,
    Unixtime = utime:unixtime(),
    EndTime = Unixtime + Time,
    % 基本数据初始化
    State = OldState#dungeon_state{
        start_time = Unixtime
        , start_time_ms = utime:longunixtime()
        , end_time = EndTime
        %%延迟加载信息
        , load_status = ?DUN_HAD_LOAD
        , load_ref = []
        , load_args = Args
    },
    %% 取消超时加载
    util:cancel_timer(LoadRef),
    %%%%%%%%%%%%%%%%%%%%%%  加载信息  %%%%%%%%%%%%%%%%%%%%%%%%%
    % 设置副本记录
    StateAfSet = set_dun_state(Args, State),  %% 考虑一下，要不要在副本预加载添加
    % 根据类型做特殊处理
    StateAfTypeInit = init_by_dun_type(StateAfSet, Dun, Args),
    % 分组
    StateAfGroup = lib_dungeon_common_event:make_group_map(StateAfTypeInit),
    % 处理触发事件
    StateAfEvent = lib_dungeon_common_event:check_and_execute(StateAfGroup),
    % 构造副本场景辅助信息
    StateAfSceneHelper = lib_dungeon_common_event:make_dungeon_scene_helper(StateAfEvent),
    StateAfMonHelper = lib_dungeon_common_event:make_mon_scene_helper(StateAfSceneHelper),
    TimeList = calc_static_time_list(StateAfMonHelper),
    StateAfRef = calc_ref(StateAfMonHelper#dungeon_state{time_list = TimeList}),
    % 同步数据到其他进程
    SetDunRecord = fun(RoleId) ->
        DunRecoed = #dungeon_record{
            role_id = RoleId,
            dun_pid = self(),
            dun_id = DunId,
            end_time = EndTime
        },
        mod_dungeon_agent:set_dungeon_record(DunRecoed)
                   end,
    #dungeon_state{role_list = NewRoleList, wave_num = WaveNum} = StateAfRef,
    %% 初始化，下个波数
    NextTime = get_next_wave_time(StateAfRef),
%%    ?MYLOG("dun", "~p~n", [{WaveNum, NextTime}]),
    [SetDunRecord(DunRole#dungeon_role.id) || DunRole <- NewRoleList],
    %% 加载假人
    F = fun(DummyArgs) ->
        lib_team_dungeon_mod:create_dummy(StateAfRef, DummyArgs)
        end,
    lists:foreach(F, DummyArgsList),
    %%%%%%%%%%%%%%%%%%%%%%  加载信息  %%%%%%%%%%%%%%%%%%%%%%%%%
    %% todo  是否需要推送信息 之类的
    %% 推送波数信息
    {ok, BinData2} = pt_610:write(61030, [WaveNum, NextTime]),
    lib_dungeon_mod:send_msg(StateAfRef, BinData2),
    StateAfRef#dungeon_state{dummy_args_list = [], next_wave_time = [WaveNum, NextTime]}.