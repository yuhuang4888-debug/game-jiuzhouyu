%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_common_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本通用事件处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_common_event).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("common.hrl").
-include("rec_event.hrl").

%% 描述:
%%  副本流程是根据事件来驱动
%%  (1)首先读取配置,获得配置中怪物、剧情、场景、结果事件字段,
%%      构造出通用事件结构 common_event_map = #{ {BelongType, CommonEventId}=#dungeon_common_event{} }
%%  (2)建立事件的分组  #{ {EventTypeId, EventId} => [{BelongType, CommonEventId, EventId}] }

%% -------------------------------------------------------------
%% 构造
%% -------------------------------------------------------------

%% 构造通用的Map
make_common_event_map(#dungeon{id = DunId, level_change_type = LevelChangeType}, NowSceneId) when
        LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_RAND orelse
        LevelChangeType == ?DUN_LEVEL_CHANGE_TYPE_ORDER ->
    case data_dungeon_level:get_dungeon_level(DunId, NowSceneId) of
        [] -> #{};
        #dungeon_level{
                mon_event = MonEvent
                , story_event = StoryEvent
                , zone_event = ZoneEvent
                , scene_event = SceneEvent
                , success_event = SuccessEvent
                , fail_event = FailEvent
                } ->
            MonEventList = [{NowSceneId, MonEvent}],
            StoryEventList = [{NowSceneId, StoryEvent}], 
            ZoneEventList = [{NowSceneId, ZoneEvent}],
            SceneEventList = [{NowSceneId, SceneEvent}], 
            SuccessEventList = [{NowSceneId, SuccessEvent}], 
            FailEventList = [{NowSceneId, FailEvent}],
            make_common_event_map(MonEventList, StoryEventList, ZoneEventList, SceneEventList, SuccessEventList, FailEventList)
    end;
make_common_event_map(Dun, _NowSceneId) ->
    make_common_event_map(Dun).

make_common_event_map(Dun) ->
    #dungeon{mon_event = MonEventList, story_event = StoryEventList, zone_event = ZoneEventList,
             scene_event = SceneEventList, success_event = SuccessEventList, fail_event = FailEventList} = Dun,
    make_common_event_map(MonEventList, StoryEventList, ZoneEventList, SceneEventList, SuccessEventList, FailEventList).

%% #{{BelongType, CommonEventId} => CommonEvent}
make_common_event_map(MonEventList, StoryEventList, ZoneEventList, SceneEventList, SuccessEventList, FailEventList) ->
    MakeMonEventList = make_common_event_list(MonEventList, ?DUN_EVENT_BELONG_TYPE_MON, []),
    MakeStoryEventList = make_common_event_list(StoryEventList, ?DUN_EVENT_BELONG_TYPE_STORY, []),
    MakeZoneEventList = make_common_event_list(ZoneEventList, ?DUN_EVENT_BELONG_TYPE_ZONE, []),
    MakeSceneEventList = make_common_event_list(SceneEventList, ?DUN_EVENT_BELONG_TYPE_SCENE, []),
    MakeResultEventList = make_common_event_list(SuccessEventList, {?DUN_EVENT_BELONG_TYPE_RESULT, ?DUN_RESULT_TYPE_SUCCESS, 1}, []),
    MakeResultEventList2 = make_common_event_list(FailEventList, {?DUN_EVENT_BELONG_TYPE_RESULT, ?DUN_RESULT_TYPE_FAIL, length(MakeResultEventList)+1}, []),
    F = fun(#dungeon_common_event{id = CommonEventId, belong_type = BelongType} = CommonEvent, Map) ->
        maps:put({BelongType, CommonEventId}, CommonEvent, Map)
    end,
    lists:foldl(F, #{}, MakeMonEventList++MakeStoryEventList++MakeZoneEventList++MakeSceneEventList++MakeResultEventList++MakeResultEventList2).

make_common_event_list([], _BelongType, CommonEventList) -> CommonEventList;
make_common_event_list([{SceneId, List}|Tail], BelongType, CommonEventList) ->
    NewCommonEventList = make_common_event_list(List, SceneId, BelongType, CommonEventList),
    make_common_event_list(Tail, BelongType, NewCommonEventList).

make_common_event_list([], _SceneId, _BelongType, CommonEventList) -> CommonEventList;
% 怪物事件
make_common_event_list([{Id, WaveType, Args, EventList}|L], SceneId, BelongType, CommonEventList) 
        when BelongType == ?DUN_EVENT_BELONG_TYPE_MON ->
    CommonEvent = #dungeon_common_event{
        id = Id
        , scene_id = SceneId
        , belong_type = BelongType
        , event_list = make_event_list(EventList, 1, [])
        , args = Args
        , wave_type = WaveType
        , wave_subtype_map = #{}
        , create_ref = none
        , allow_type = ?DUN_ALLOW_TYPE_YES
        },
    make_common_event_list(L, SceneId, BelongType, [CommonEvent|CommonEventList]);
% 剧情事件
make_common_event_list([{Id, StoryData, Args, EventList}|L], SceneId, BelongType, CommonEventList)
        when BelongType == ?DUN_EVENT_BELONG_TYPE_STORY ->
    CommonEvent = #dungeon_common_event{
        id = Id
        , scene_id = SceneId
        , belong_type = BelongType
        , args = Args
        , event_list = make_event_list(EventList, 1, [])
        , story_data = StoryData
        , allow_type = ?DUN_ALLOW_TYPE_YES
        },
    make_common_event_list(L, SceneId, BelongType, [CommonEvent|CommonEventList]);
% 区域事件
make_common_event_list([{Id, ZoneData, EventList}|L], SceneId, BelongType, CommonEventList) 
        when BelongType == ?DUN_EVENT_BELONG_TYPE_ZONE ->
    CommonEvent = #dungeon_common_event{
        id = Id
        , scene_id = SceneId
        , belong_type = BelongType
        , event_list = make_event_list(EventList, 1, [])
        , zone_data = ZoneData
        , allow_type = ?DUN_ALLOW_TYPE_YES
        },
    make_common_event_list(L, SceneId, BelongType, [CommonEvent|CommonEventList]);
% 场景事件
make_common_event_list([{Id, Args, EventList}|L], SceneId, BelongType, CommonEventList) 
        when BelongType == ?DUN_EVENT_BELONG_TYPE_SCENE ->
    CommonEvent = #dungeon_common_event{
        id = Id
        , scene_id = SceneId
        , belong_type = BelongType
        , event_list = make_event_list(EventList, 1, [])
        , args = Args
        , allow_type = ?DUN_ALLOW_TYPE_YES
        },
    make_common_event_list(L, SceneId, BelongType, [CommonEvent|CommonEventList]);
% 结果事件
make_common_event_list([{SettlementType, Args, EventList}|L], SceneId, {BelongType, ResultType, Id}, CommonEventList) 
        when BelongType == ?DUN_EVENT_BELONG_TYPE_RESULT ->
    CommonEvent = #dungeon_common_event{
        id = Id
        , scene_id = SceneId
        , belong_type = BelongType
        , event_list = make_event_list(EventList, 1, [])
        , args = Args
        , result_type = ResultType
        , settlement_type = SettlementType
        , allow_type = ?DUN_ALLOW_TYPE_YES
        },
    make_common_event_list(L, SceneId, {BelongType, ResultType, Id+1}, [CommonEvent|CommonEventList]);

make_common_event_list([_T|L], SceneId, BelongType, CommonEventList) ->
    % ?PRINT("make_common_event_list :~w ~n", [_T]),
    make_common_event_list(L, SceneId, BelongType, CommonEventList).

%% 构造触发元素
make_event(Id, Type, Args, IsTrigger) ->
    #dungeon_event{id = Id, type = Type, args = Args, is_trigger = IsTrigger}.

make_event_list([], _Id, EventList) -> lists:reverse(EventList);
make_event_list([Type|L], Id, EventList) ->
    Event = make_event(Id, Type, [], ?DUN_EVENT_TRIGGER_NO),
    make_event_list(L, Id+1, [Event|EventList]).


%% 建立分组Map #{{EventTypeId, EventId} => [{BelongType, CommonEventId, EventId}]}
make_group_map(State) ->
    #dungeon_state{common_event_map = CommonEventMap, group_map = GroupMap} = State,
    F = fun({BelongType, CommonEventId}, CommonEvent, TmpGroupMap) ->
        #dungeon_common_event{scene_id = SceneId, event_list = EventList} = CommonEvent,
        List = make_group_map_help(EventList, []),
        F2 = fun({EventTypeId, EventId}, TmpGroupMap2) ->
            GroupList = maps:get({SceneId, EventTypeId}, TmpGroupMap2, []),
            NewGroupList = [{BelongType, CommonEventId, EventId}|lists:delete({BelongType, CommonEventId, EventId}, GroupList)],
            maps:put({SceneId, EventTypeId}, NewGroupList, TmpGroupMap2)
        end,
        lists:foldl(F2, TmpGroupMap, lists:reverse(List))
    end,
    NewGroupMap = maps:fold(F, GroupMap, CommonEventMap),
    State#dungeon_state{group_map = NewGroupMap}.

make_group_map_help([], L) -> lists:reverse(L);
make_group_map_help([H|T], L) ->
    #dungeon_event{id = EventId, type = Type} = H,
    NewL = case Type of
        % 时间相关
        {dungeon_time, _DungtonTime} -> [{?DUN_EVENT_TYPE_ID_TIME, EventId}|L];
        {level_time, _LevelTime} -> [{?DUN_EVENT_TYPE_ID_TIME, EventId}|L];
        {kill_mon_num, _MonId, _Num} -> [{?DUN_EVENT_TYPE_ID_KILL_MON, EventId}|L];
        {mon_event_id_kill_all_mon, _MonEventId} -> [{?DUN_EVENT_TYPE_ID_MON_EVENT_ID_KILL_ALL_MON, EventId}|L]; 
        {mon_event_id_finish, _MonEventId} -> [{?DUN_EVENT_TYPE_ID_MON_EVENT_ID_FINISH, EventId}|L];
        {role_hp_rate, _HpRate} ->  [{?DUN_EVENT_TYPE_ID_ROLE_HP, EventId}|L];
        {role_pos, _X, _Y, _XRange, _YRange, _Order} -> [{?DUN_EVENT_TYPE_ID_ROLE_XY, EventId}|L];
        {mon_hp_rate, _MonId, _HpRate} -> [{?DUN_EVENT_TYPE_ID_MON_HP, EventId}|L];
        {story_finish, _StoryId, _SubStoryId} -> [{?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, EventId}|L];
        {skip_dungeon} -> [{?DUN_EVENT_TYPE_ID_SKIP_DUNGEON, EventId}|L];
        {active_quit} -> [{?DUN_EVENT_TYPE_ID_ACTIVE_QUIT, EventId}|L];
        {logout} -> [{?DUN_EVENT_TYPE_ID_LOGOUT, EventId}|L];
        {delay_logout, _ReserveTime} -> [{?DUN_EVENT_TYPE_ID_DELAY_LOGOUT, EventId}|L];
        {dungeon_timeout} -> [{?DUN_EVENT_TYPE_ID_DUNGEON_TIMEOUT, EventId}|L];
        {level_timeout} -> [{?DUN_EVENT_TYPE_ID_LEVEL_TIMEOUT, EventId}|L];
        {wave_subtype_refresh, _MonEventId, _WaveSubtype} -> [{?DUN_EVENT_TYPE_ID_WAVE_SUBTYPE_REFRESH, EventId}|L];
        {die_count, _DieCount} -> [{?DUN_EVENT_TYPE_ID_DIE_COUNT, EventId}|L];
        {wave_timeout} -> [{?DUN_EVENT_TYPE_ID_WAVE_TIMEOUT, EventId}|L];
        {die_without_revive} -> [{?DUN_EVENT_TYPE_ID_DIE_WITHOUT_REVIVE, EventId}|L]
    end,
    make_group_map_help(T, NewL).

%% 构造场景辅助信息
make_dungeon_scene_helper(State) ->
    #dungeon_state{common_event_map = CommonEventMap, scene_helper = SceneHelper} = State,
    F = fun(_Key, CommonEvent, TmpSceneHelper) ->
        #dungeon_common_event{event_list = EventList} = CommonEvent,
        do_make_dungeon_scene_helper(EventList, TmpSceneHelper)
    end,
    NewSceneHelper = maps:fold(F, SceneHelper, CommonEventMap),
    State#dungeon_state{scene_helper = NewSceneHelper}.

do_make_dungeon_scene_helper([], SceneHelper) -> SceneHelper;
do_make_dungeon_scene_helper([#dungeon_event{type = Type}|T], SceneHelper) ->
    #dungeon_scene_helper{hp_rate_list = HpRateList} = SceneHelper,
    case Type of
        {role_hp_rate, HpRate} -> NewSceneHelper = SceneHelper#dungeon_scene_helper{hp_rate_list = [HpRate|HpRateList]};
        _ -> NewSceneHelper = SceneHelper
    end,
    do_make_dungeon_scene_helper(T, NewSceneHelper).

%% 构造怪物血量辅助信息
make_mon_scene_helper(State) ->
    #dungeon_state{common_event_map = CommonEventMap, mon_helper = MonHelper} = State,
    F = fun(_Key, CommonEvent, TmpMonHelper) ->
        #dungeon_common_event{event_list = EventList} = CommonEvent,
        do_make_mon_scene_helper(EventList, TmpMonHelper)
    end,
    NewMonHelper = maps:fold(F, MonHelper, CommonEventMap),
    State#dungeon_state{mon_helper = NewMonHelper}.

do_make_mon_scene_helper([], MonHelper) -> MonHelper;
do_make_mon_scene_helper([#dungeon_event{type = Type}|T], MonHelper) ->
    #dungeon_mon_helper{hp_rate_map = HpRateMap} = MonHelper,
    case Type of
        {mon_hp_rate, MonId, HpRate} -> 
            HpRateList = maps:get(MonId, HpRateMap, []),
            NewMonHelper = MonHelper#dungeon_mon_helper{hp_rate_map = maps:put(MonId, [HpRate|HpRateList], HpRateMap)};
        _ -> NewMonHelper = MonHelper
    end,
    do_make_mon_scene_helper(T, NewMonHelper).

%% -------------------------------------------------------------
%% 检查触发元素是否全部触发
%% -------------------------------------------------------------

%% 检查和执行(遍历所有)
check_and_execute(State) ->
    % 按一定顺序
    BelongTypeList = [?DUN_EVENT_BELONG_TYPE_RESULT, ?DUN_EVENT_BELONG_TYPE_STORY, ?DUN_EVENT_BELONG_TYPE_ZONE, ?DUN_EVENT_BELONG_TYPE_SCENE, ?DUN_EVENT_BELONG_TYPE_MON],
    check_and_execute(State, BelongTypeList).

%% 根据归属分类,检查和执行触发元素
check_and_execute(State, BelongTypeList) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    F = fun({BelongType, CommonEventId}, _CommonEvent, TmpState) ->
        case lists:member(BelongType, BelongTypeList) of
            true -> check_and_execute(TmpState, BelongType, CommonEventId);
            false -> TmpState
        end
    end,
    maps:fold(F, State, CommonEventMap).

%% 检查触发元素
check_and_execute(State, BelongType, CommonEventId) ->
    case check_trigger(State, BelongType, CommonEventId) of
        false -> State;
        {true, CommonEvent} -> 
%%            NewState = handle_allow_type_by_execute(State, CommonEvent),
            {NewState, NewCommonEvent} = handle_common_event_af_execute(State, CommonEvent),
            execute(NewState, BelongType, NewCommonEvent)
    end.

execute(State, ?DUN_EVENT_BELONG_TYPE_MON, #dungeon_common_event{id = CommonEventId, scene_id = SceneId, wave_type = WaveType} = CommonEvent) ->
    NewState = lib_dungeon_mon_event:create_dungeon_wave(State, CommonEvent),
    NewState2 = lib_dungeon_mon_event:create_dungeon_mon(NewState, CommonEventId),
    NewState3 = lib_dungeon_api:invoke(State#dungeon_state.dun_type, dunex_begin_create_mon, [NewState2], NewState2),
    #dungeon_state{dun_id = DunId, wave_num = WaveNum} = NewState3,
    StateAfWave
    = if
        State#dungeon_state.wave_num =/= WaveNum ->
            {ok, BinData} = pt_610:write(61005, [DunId, SceneId, WaveType, utime:unixtime(), WaveNum]),
            lib_dungeon_mod:send_msg(NewState3, BinData),
            NextTime = lib_dungeon_mod:get_next_wave_time(NewState3),
            {ok, BinData2} = pt_610:write(61030, [WaveNum, NextTime]),
            lib_dungeon_mod:send_msg(NewState3, BinData2),
            StateAfNext = NewState3#dungeon_state{next_wave_time = [WaveNum, NextTime]},
            StateAfPanel = lib_dungeon_mod:send_wave_panel_info(StateAfNext),
            StateAfPanel;
        true ->
            NewState3
    end,
    StateAfFinish = lib_dungeon_event:handle_mon_event_id_finish(StateAfWave, CommonEventId),
    StateAfFinish;

execute(State, ?DUN_EVENT_BELONG_TYPE_STORY, #dungeon_common_event{story_data = [StoryId, SubStoryId], args = Args}) ->
    % ?PRINT("execute DUN_EVENT_BELONG_TYPE_STORY StoryId:~p SubStoryId:~p ~n", [StoryId, SubStoryId]),
    {ok, BinData} = pt_610:write(61009, [StoryId, SubStoryId]),
    lib_dungeon_mod:send_msg(State, BinData),
    % 储存剧情和判断是否要结束剧情
    #dungeon_state{story_map = StoryMap} = State,
    StoryEventData = #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId, start_time = utime:longunixtime()},
    case lib_dungeon_mod:is_all_role_not_on_online(State) of
        true ->
            NewStoryMap = maps:put({StoryId, SubStoryId}, #story_player_record{is_end = ?STORY_NOT_FINISH, ref = [], start_time = utime:longunixtime()}, StoryMap),
            mod_dungeon:dispatch_dungeon_event(self(), ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, StoryEventData);
        false ->
            StoryTime = get_story_time(Args), %% 获取副本剧情的超时时间
            if
                StoryTime > 0 -> %% 超时时间
                    Ref = util:send_after([], StoryTime * 1000, self(),  {'dispatch_dungeon_event', ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, StoryEventData});
                true ->
                    Ref = []
            end,
            NewStoryMap = maps:put({StoryId, SubStoryId}, #story_player_record{is_end = ?STORY_NOT_FINISH, ref = Ref, start_time = utime:longunixtime()}, StoryMap)
    end,
    NewState = State#dungeon_state{story_map = NewStoryMap},
    NewState;

execute(State, ?DUN_EVENT_BELONG_TYPE_ZONE, #dungeon_common_event{scene_id = SceneId, zone_data = {AreaMarkL, EffChangeValues} }) ->
    % ?PRINT("execute DUN_EVENT_BELONG_TYPE_ZONE self():~p, AreaMarkL:~p EffChangeValues:~p ~n", [self(), AreaMarkL, EffChangeValues]),
    #dungeon_state{scene_pool_id = ScenePoolId} = State,
    lib_scene:change_area_mark(SceneId, ScenePoolId, self(), AreaMarkL),
    lib_scene:change_dynamic_eff(SceneId, ScenePoolId, self(), EffChangeValues),
    State;

execute(State, ?DUN_EVENT_BELONG_TYPE_SCENE, CommonEvent) ->
    lib_dungeon_scene_event:execute(State, CommonEvent);

execute(State, ?DUN_EVENT_BELONG_TYPE_RESULT, CommonEvent) ->
    CallbackArgs = {'dungeon_result', CommonEvent}, 
    State#dungeon_state{callback_type = ?DUN_CALLBACK_TYPE_RESULT, callback_args = CallbackArgs};

execute(State, _BelongType, _CommonEvent) ->
    % ?PRINT("execute _BelongType:~p _CommonEvent:~w ~n", [_BelongType, _CommonEvent]),
    State.

check_trigger(State, BelongType, CommonEventId) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,    
    case maps:get({BelongType, CommonEventId}, CommonEventMap, false) of
        false -> false;
        #dungeon_common_event{allow_type = ?DUN_ALLOW_TYPE_NO} -> false;
        #dungeon_common_event{event_list = EventList} = CommonEvent ->
            F = fun(#dungeon_event{is_trigger = IsTrigger}) -> IsTrigger == ?DUN_EVENT_TRIGGER_YES end,
            case lists:all(F, EventList) of
                true -> {true, CommonEvent};
                false -> false
            end
    end.

%% 设置允许触发类型
handle_allow_type_by_execute(State, CommonEvent) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    #dungeon_common_event{id = CommonEventId, belong_type = BelongType} = CommonEvent,
    NewCommonEvent = CommonEvent#dungeon_common_event{allow_type = ?DUN_ALLOW_TYPE_NO},
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    State#dungeon_state{common_event_map = NewCommonEventMap}.

%% 执行秘籍
%% 根据归属分类,检查和执行触发元素
gm_check_and_execute(State, BelongTypeList) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    F = fun({BelongType, CommonEventId}, _CommonEvent, TmpState) ->
        case lists:member(BelongType, BelongTypeList) of
            true -> gm_check_and_execute(TmpState, BelongType, CommonEventId);
            false -> TmpState
        end
    end,
    maps:fold(F, State, CommonEventMap).

%% 检查触发元素
gm_check_and_execute(State, BelongType, CommonEventId) ->
    case gm_check_trigger(State, BelongType, CommonEventId) of
        false -> State;
        {true, CommonEvent} -> 
%%            NewState = handle_allow_type_by_execute(State, CommonEvent),
            {NewState, NewCommonEvent} = handle_common_event_af_execute(State, CommonEvent),
            execute(NewState, BelongType, NewCommonEvent)
    end.

gm_check_trigger(State, BelongType, CommonEventId) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    case maps:get({BelongType, CommonEventId}, CommonEventMap, false) of
        false -> false;
        #dungeon_common_event{allow_type = ?DUN_ALLOW_TYPE_NO} -> false;
        CommonEvent -> {true, CommonEvent}
    end.

%% -------------------------------------------------------------
%% 处理事件
%% -------------------------------------------------------------

%% 处理事件
%% @return #dungeon_state{}
handle_event(State, BelongType, CommonEventId, EventId, #event_callback{type_id = EventTypeId} = EventCallback) when 
        EventTypeId == ?DUN_EVENT_TYPE_ID_KILL_MON;             % 击杀怪物
        EventTypeId == ?DUN_EVENT_TYPE_ID_TIME;                 % 时间事件
        EventTypeId == ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_KILL_ALL_MON; % 对应刷怪事件配置ID的怪全部被杀死
        EventTypeId == ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_FINISH;  % 对应刷怪事件配置ID的触发元素全部触发
        EventTypeId == ?DUN_EVENT_TYPE_ID_ROLE_HP;              % 玩家血量事件
        EventTypeId == ?DUN_EVENT_TYPE_ID_ROLE_XY;              % 玩家坐标事件
        EventTypeId == ?DUN_EVENT_TYPE_ID_MON_HP;               % 怪物血量事件
        EventTypeId == ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH;      % 完成剧情id事件
        EventTypeId == ?DUN_EVENT_TYPE_ID_SKIP_DUNGEON;         % 跳过副本
        EventTypeId == ?DUN_EVENT_TYPE_ID_ACTIVE_QUIT;          % 主动退出
        EventTypeId == ?DUN_EVENT_TYPE_ID_LOGOUT;               % 登出
        EventTypeId == ?DUN_EVENT_TYPE_ID_DELAY_LOGOUT;         % 延迟登出
        EventTypeId == ?DUN_EVENT_TYPE_ID_DUNGEON_TIMEOUT;      % 副本超时
        EventTypeId == ?DUN_EVENT_TYPE_ID_LEVEL_TIMEOUT;        % 关卡超时
        EventTypeId == ?DUN_EVENT_TYPE_ID_WAVE_SUBTYPE_REFRESH; % 波数子类型刷新
        EventTypeId == ?DUN_EVENT_TYPE_ID_DIE_COUNT;            % 死亡次数
        EventTypeId == ?DUN_EVENT_TYPE_ID_WAVE_TIMEOUT;        % 波数超时
        EventTypeId == ?DUN_EVENT_TYPE_ID_DIE_WITHOUT_REVIVE ->  % 没有复活并且全部玩家都死亡
	handle_event2(State, BelongType, CommonEventId, EventId, EventCallback);

handle_event(State, _BelongType, _CommonEventId, _EventId, _EventCallback) ->
    State.

%% 处理事件的辅助函数
handle_event2(State, BelongType, CommonEventId, EventId, EventCallback) ->
    {CommonEvent, Event} = get_common_event(State, BelongType, CommonEventId, EventId),
    #dungeon_event{is_trigger = IsTrigger} = Event,
    if
        IsTrigger == ?DUN_EVENT_TRIGGER_NO -> do_handle_event2(State, EventCallback, CommonEvent, Event);
        true -> State
    end.

%% 处理事件中的触发元素
%% 副本第几秒能触发
do_handle_event2(State,
                 #event_callback{type_id = ?DUN_EVENT_TYPE_ID_TIME, data = #dun_callback_time{event_time = EventTime} },
                 CommonEvent,
                 #dungeon_event{type = {dungeon_time, DungeonTime} } = Event) ->
    #dungeon_state{start_time = StartTime} = State,
    case EventTime >= StartTime+DungeonTime of
        true -> trigger(State, CommonEvent, Event);
        false -> State
    end;

% 关卡第几秒能触发
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_TIME, data = #dun_callback_time{event_time = EventTime} }
        , CommonEvent
        , #dungeon_event{type = {level_time, LevelTime} } = Event) ->
    #dungeon_state{level_start_time = LevelStartTime} = State,
    % ?PRINT("@@@@@dungeon_time EventTime:~p, LevelTime:~p, LevelStartTime:~p ~n", [EventTime, LevelTime, LevelStartTime]),
    case EventTime >= LevelStartTime+LevelTime of
        true ->  trigger(State, CommonEvent, Event);
        false -> State
    end;

% 击杀某种怪物类型的数量
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_KILL_MON
            , data = #dun_callback_kill_mon{mon_id = MonId}
            }
        , CommonEvent
        , #dungeon_event{type = {kill_mon_num, MonId, NeedNum}, args = Num} = Event) ->
    case is_integer(Num) of
        true -> NewNum = Num;
        false -> NewNum = 0
    end,
    NewNum2 = NewNum+1,
    NewEvent = Event#dungeon_event{args = NewNum2},
    % ?PRINT("NewNum2:~p NeedNum:~p ~n", [NewNum2, NeedNum]),
    case NewNum2 == NeedNum of
        true -> trigger(State, CommonEvent, NewEvent);
        false -> update(State, CommonEvent, NewEvent)
    end;

% 对应刷怪事件配置ID的怪全部被杀死
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_KILL_ALL_MON
            , data = #dun_callback_mon_event_id_kill_all_mon{kill_mon_event_id = KillMonEventId}
            }
        , CommonEvent
        , #dungeon_event{type = {mon_event_id_kill_all_mon, KillMonEventId} } = Event) ->
    trigger(State, CommonEvent, Event);

% 对应刷怪事件配置ID的触发元素全部触发
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_MON_EVENT_ID_FINISH
            , data = #dun_callback_mon_event_id_finish{mon_event_id = TargetMonEventId}
            }
        , CommonEvent
        , #dungeon_event{type = {mon_event_id_finish, TargetMonEventId} } = Event) ->
    % ?PRINT("mon_event_id_finish ~n", []),
    trigger(State, CommonEvent, Event);

% 玩家血量百分比达到HpRate(Hp/HpLim)
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_ROLE_HP, data = #dun_callback_role_hp{hp_rate_list = HpRateList} }
        , CommonEvent
        , #dungeon_event{type = {role_hp_rate, HpRate} } = Event) ->
    case lists:member(HpRate, HpRateList) of
        true -> trigger(State, CommonEvent, Event);
        false -> State
    end;

% 到达位置
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_ROLE_XY
            , data = #dun_callback_role_xy{scene_id = SceneId, x = X, y = Y}
            }
        , #dungeon_common_event{scene_id = SceneId} = CommonEvent
        , #dungeon_event{type = {role_pos, TargetX, TargetY, XRange, YRange, _Order} } = Event) when 
            X >= TargetX-XRange andalso X =< TargetX+XRange andalso Y >= TargetY-YRange andalso Y =< TargetY+YRange ->
    % ?PRINT("role_pos SceneId:~p, X:~p, Y:~p TargetX:~p, TargetY:~p, XRange:~p, YRange:~p, Value:~p ~n", 
        % [SceneId, X, Y, TargetX, TargetY, XRange, YRange, X >= TargetX-XRange andalso X =< TargetX+XRange andalso Y >= TargetX-YRange andalso Y =< TargetY+YRange]),
    #dungeon_state{xy_map = XyMap} = State,
    XyList = maps:get(SceneId, XyMap, []),
    NewXyList = [{TargetX, TargetY}|lists:delete({TargetX, TargetY}, XyList)],
    NewXyMap = maps:put(SceneId, NewXyList, XyMap),
    NewState = State#dungeon_state{xy_map = NewXyMap},
    {ok, BinData} = pt_610:write(61007, [X, Y]),
    lib_dungeon_mod:send_msg(NewState, BinData),
    trigger(NewState, CommonEvent, Event);

% 某种类型怪物的血量百分比达到HpRate(Hp/HpLim)
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_MON_HP
            , data = #dun_callback_mon_hp_rate{mon_id = MonId, hp_rate_list = HpRateList}
            }
        , CommonEvent
        , #dungeon_event{type = {mon_hp_rate, MonId, HpRate} } = Event) ->
    % ?PRINT("mon_hp_rate ~n", []),
    case lists:member(HpRate, HpRateList) of
        true -> trigger(State, CommonEvent, Event);
        false -> State
    end;

% 剧情结束
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH
            , data = #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId, start_time = StoryStartTime}
            }
        , CommonEvent
        , #dungeon_event{type = {story_finish, StoryId, SubStoryId} , args = OldArgs} = Event) ->
    % ?PRINT("story_id_finish ~n", []),
%%    ?MYLOG("dun", "story_id_finish  ++++++++++ ~p ~n", [Event]),
    trigger(State, CommonEvent, Event#dungeon_event{args = [{story_start_time, StoryStartTime} | OldArgs] });

%% 跳过副本
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_SKIP_DUNGEON}
        , CommonEvent
        , #dungeon_event{type = {skip_dungeon} } = Event) ->
    % ?PRINT("DUN_EVENT_TYPE_ID_SKIP_DUNGEON ~n", []),
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_SKIP_DUNGEON},
    trigger(State, NewCommonEvent, Event);

%% 主动退出
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_ACTIVE_QUIT}
        , CommonEvent
        , #dungeon_event{type = {active_quit} } = Event) ->
    % ?PRINT("DUN_EVENT_TYPE_ID_ACTIVE_QUIT ~n", []),
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT},
    trigger(State, NewCommonEvent, Event);

%% 登出
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_LOGOUT}
        , CommonEvent
        , #dungeon_event{type = {logout} } = Event) ->
    % ?PRINT("DUN_EVENT_TYPE_ID_LOGOUT ~n", []),
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_LOGOUT},
    trigger(State, NewCommonEvent, Event);

% 延迟登出触发
% do_handle_event2(
%         State
%         , #event_callback{
%             type_id = ?DUN_EVENT_TYPE_ID_DELAY_LOGOUT
%             , data = #dun_callback_delay_logout{role_id = RoleId, delay_logout_time = DelayLogoutTime}
%             }
%         , CommonEvent
%         , #dungeon_event{type = {delay_logout, LevelTime} } = Event) ->
%     case DelayLogoutTime >= DelayLogoutTime+LevelTime of
%         true -> 
%             NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_DELAY_LOGOUT},
%             trigger(State, NewCommonEvent, Event);
%         false -> 
%             #dungeon_state{role_list = RoleList} = State,
%             case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%                 false -> {noreply, State};
%                 #dungeon_role{delay_logout_ref = OldRef} = DungeonRole ->
%                     EventTime = DelayLogoutTime+LevelTime,
%                     Ref = util:send_after(OldRef, max(LevelTime, 1)*1000, self(), {'delay_logout_ref', RoleId, DelayLogoutTime, EventTime}),
%                     NewDungeonRole = DungeonRole#dungeon_role{delay_logout_ref = Ref},
%                     NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%                     State#dungeon_state{role_list = NewRoleList}
%             end
%     end;

% 延迟登出触发(延迟登出定时器)
% do_handle_event2(
%         State
%         , #event_callback{
%             type_id = ?DUN_EVENT_TYPE_ID_DELAY_LOGOUT
%             , data = #dun_callback_delay_logout_ref{}
%             }
%         , CommonEvent
%         , #dungeon_event{type = {delay_logout, _LevelTime} } = Event) ->
%     NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_DELAY_LOGOUT},
%     trigger(State, NewCommonEvent, Event);

% 副本超时
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_DUNGEON_TIMEOUT}
        , CommonEvent
        , #dungeon_event{type = {dungeon_timeout} } = Event) ->
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_TIMEOUT},
    trigger(State, NewCommonEvent, Event);

% 关卡超时
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_LEVEL_TIMEOUT}
        , CommonEvent
        , #dungeon_event{type = {level_timeout} } = Event) ->
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_TIMEOUT},
    trigger(State, NewCommonEvent, Event);

% 副本波数子类型刷出
do_handle_event2(
        State
        , #event_callback{
            type_id = ?DUN_EVENT_TYPE_ID_WAVE_SUBTYPE_REFRESH
            , data = #dun_callback_wave_subtype_refresh{mon_event_id = MonEventId, wave_subtype = WaveSubtype}
            }
        , CommonEvent
        , #dungeon_event{type = {wave_subtype_refresh, MonEventId, WaveSubtype} } = Event) ->
    trigger(State, CommonEvent, Event);

% 玩家死亡次数事件
do_handle_event2(
    State
    , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_DIE_COUNT}
    , CommonEvent
    , #dungeon_event{type = {die_count, NeedDieCount}, args = _DieCount} = Event) ->
    case is_integer(_DieCount) of
        true -> ?MYLOG("cym", "_DieCount ~p ~n",  [_DieCount]), DieCount = _DieCount;
        false -> ?MYLOG("cym", "_DieCount ~p ~n",  [_DieCount]), DieCount = 0
    end,
    NewDieCount = DieCount+1,
    NewEvent = Event#dungeon_event{args = NewDieCount},
    % ?MYLOG("cym",  "NewDieCount:~p, DieCount:~p , NeedDieCount:~p~n", [NewDieCount, DieCount, NeedDieCount]),
    case NewDieCount >= NeedDieCount of
        true -> trigger(State, CommonEvent, NewEvent);
        false -> update(State, CommonEvent, NewEvent)
    end;

% 波数超时
do_handle_event2(
        State
        , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_WAVE_TIMEOUT}
        , CommonEvent
        , #dungeon_event{type = {wave_timeout} } = Event) ->
    NewCommonEvent = CommonEvent#dungeon_common_event{result_subtype = ?DUN_RESULT_SUBTYPE_TIMEOUT},
    trigger(State, NewCommonEvent, Event);

% 玩家全部阵亡并且没有复活
do_handle_event2(
    State
    , #event_callback{type_id = ?DUN_EVENT_TYPE_ID_DIE_WITHOUT_REVIVE}
    , CommonEvent
    , #dungeon_event{type = {die_without_revive}} = Event) ->
    trigger(State, CommonEvent, Event);

do_handle_event2(State, _EventCallback, _CommonEvent, _Event) ->
    % ?PRINT("do_handle_event2 _EventCallback:~w _CommonEvent:~w~n", [_EventCallback, _CommonEvent]),
    State.

%% -------------------------------------------------------------
%% 公共函数
%% -------------------------------------------------------------

%% 获取数据
get_common_event(State, BelongType, CommonEventId, EventId) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
    Event = lists:keyfind(EventId, #dungeon_event.id, CommonEvent#dungeon_common_event.event_list),
    {CommonEvent, Event}.

get_common_event(State, BelongType, Filter) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    maps:fold(fun
        ({Type, _}, Evt, Acc) ->
            if
                Type =:= BelongType ->
                    case Filter(Evt) of
                        true ->
                            [Evt|Acc];
                        _ ->
                            Acc
                    end;
                true ->
                    Acc
            end
    end, [], CommonEventMap).

%% 触发的统一操作:设置触发,更新数据,检查是否能触发事件
trigger(State, #dungeon_common_event{id = CommonEventId, belong_type = BelongType} = CommonEvent, Event) ->
    NewEvent = Event#dungeon_event{is_trigger = ?DUN_EVENT_TRIGGER_YES},
%%    ?MYLOG("dun", "NewEvent ~p~n", [NewEvent]),
    NewState = update(State, CommonEvent, NewEvent),
    NewState2 = check_and_execute(NewState, BelongType, CommonEventId),
    NewState2.

%% 更新数据(更新Event) --- 剧情时间特殊处理，修正副本补偿时间
update(State, #dungeon_common_event{id = CommonEventId, belong_type = BelongType, event_list = EventList, args = CommonEventArgs} = CommonEvent,
    #dungeon_event{type = {story_finish, _, _}, args = EventArgs} = Event) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    % 更新CommonEvent
    NewEventList = lists:keyreplace(Event#dungeon_event.id, #dungeon_event.id, EventList, Event),
%%    ?MYLOG("dun", "CommonEventArgs ~p~n, Event ~p~n", [CommonEventArgs, EventArgs]),
    %% 修正补偿时间
    NewCommonEventArgs = repair_dun_compensate_time(CommonEventArgs, EventArgs),
%%    ?PRINT("StoryPlayerTimeMI ~p~n", [StoryPlayerTimeMI]),
    NewCommonEvent = CommonEvent#dungeon_common_event{event_list = NewEventList, args = NewCommonEventArgs},
    % 更新Map
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    State#dungeon_state{common_event_map = NewCommonEventMap};

%% 更新数据(更新Event)
update(State, #dungeon_common_event{id = CommonEventId, belong_type = BelongType, event_list = EventList} = CommonEvent, Event) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    % 更新CommonEvent
    NewEventList = lists:keyreplace(Event#dungeon_event.id, #dungeon_event.id, EventList, Event),
    NewCommonEvent = CommonEvent#dungeon_common_event{event_list = NewEventList},
    % 更新Map
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    State#dungeon_state{common_event_map = NewCommonEventMap}.

%% 设置事件
handle_common_event_af_execute(State, CommonEvent) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    #dungeon_common_event{id = CommonEventId, belong_type = BelongType} = CommonEvent,
    NewCommonEvent = CommonEvent#dungeon_common_event{allow_type = ?DUN_ALLOW_TYPE_NO, first_time = utime:unixtime()},
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    {State#dungeon_state{common_event_map = NewCommonEventMap}, NewCommonEvent}.

%%获得剧情的播放超时时间
get_story_time(Args) ->
    case lists:keyfind(story_time_out, 1, Args) of
        {_, Time} ->
            Time;
        _ ->
            0
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述     修正剧情补偿时间
%% @param    参数        CommonEventArgs 事件原本参数  EventArgs 触发元素参数
%% @return   返回值      {CommonEventArgsNew, 剧情播放时间（毫米）}
%% @history  修改历史
%% -----------------------------------------------------------------
repair_dun_compensate_time(CommonEventArgs, EventArgs) ->
%%    ?MYLOG("dun", "CommonEventArgs ~p~n, Event ~p~n", [CommonEventArgs, EventArgs]),
    case lists:keyfind(add_dun_time, 1, CommonEventArgs) of
        {_, OldAddTime} ->
            case  lists:keyfind(story_start_time, 1, EventArgs) of
                {_, StoryStartTime} ->
                    DiffTimeMI = utime:longunixtime() - StoryStartTime, %%剧情播放时间，毫米级
                    DiffTime = max(erlang:round(DiffTimeMI / 1000), 0),
                    LastTime = min(OldAddTime, DiffTime),
                    CommonEventArgsNew = lists:keystore(add_dun_time, 1, CommonEventArgs, {add_dun_time, LastTime}),
                    CommonEventArgsNew;
                _ ->
                    CommonEventArgs
            end;
        _ -> %% 无补偿时间
            CommonEventArgs
    end.