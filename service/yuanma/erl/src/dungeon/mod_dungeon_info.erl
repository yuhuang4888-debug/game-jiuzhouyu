%% ---------------------------------------------------------------------------
%% @doc mod_dungeon_info.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本进程
%% ---------------------------------------------------------------------------
-module(mod_dungeon_info).
-export([handle_info/2]).

-include("dungeon.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("scene.hrl").

%% 副本结束
handle_info({'dungeon_timeout'}, State) ->
    lib_dungeon_mod:dungeon_timeout(State);

%% 波数结束
handle_info({'wave_timeout'}, State) ->
    lib_dungeon_mod:wave_timeout(State);

%% 关卡结束
handle_info({'dungeon_level_timeout'}, State) ->
    lib_dungeon_mod:dungeon_level_timeout(State);

%% 关卡切换
handle_info({'change_next_level'}, State) ->
    lib_dungeon_mod:change_next_level(State);

%% 时间触发
handle_info({'dispatch_event_time', EventTime}, State) ->
    % ?PRINT("handle_event_time~n", []),
    lib_dungeon_event:dispatch_event_time(State, EventTime);

%% 产出怪物
handle_info({'create_dungeon_mon_on_mon_event', CommonEventId}, State) ->
    NewState = lib_dungeon_mon_event:create_dungeon_mon(State, CommonEventId),
    {noreply, NewState};

%% 延迟登出定时器
% handle_info({'delay_logout_ref', RoleId, DelayLogoutTime, EventTime}, State) ->
%     % ?PRINT("DUN_EVENT_TYPE_ID_DELAY_LOGOUT RoleId:~p ~n", [RoleId]),
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> {noreply, State};
%         #dungeon_role{delay_logout_ref = DelayLogoutRef} = DungeonRole ->
%             util:cancel_timer(DelayLogoutRef),
%             NewDungeonRole = DungeonRole#dungeon_role{delay_logout_ref = none},
%             NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%             NewState = State#dungeon_state{role_list = NewRoleList},
%             NewState2 = lib_dungeon_event:handle_delay_logout_ref(NewState, RoleId, DelayLogoutTime, EventTime),
%             case lib_dungeon_event:handle_callback(NewState) of
%                 nothing -> {noreply, NewState2};
%                 Result -> Result
%             end
%     end;

%% 强制退出定时器 副本里没人，直接关闭
handle_info({'force_quit_ref'}, #dungeon_state{role_list = []} = State) ->
    {stop, normal, State};

%% 强制退出定时器 已经进入下一副本
handle_info({'force_quit_ref'}, #dungeon_state{result_type = ?DUN_RESULT_TYPE_NO} = State) ->
    {noreply, State};

%% 强制退出定时器
handle_info({'force_quit_ref'}, State)  ->
    #dungeon_state{role_list = RoleList} = State,
    F = fun(#dungeon_role{id = RoleId, is_end_out = IsEndOut}) ->
        case IsEndOut == ?DUN_IS_END_OUT_NO of
            true -> mod_dungeon:passive_force_quit(self(), RoleId);
            false -> skip
        end
    end,
    lists:foreach(F, RoleList),
    {noreply, State};


%% 流程退出定时器 已经进入下一副本
handle_info({'flow_quit_ref'}, #dungeon_state{result_type = ?DUN_RESULT_TYPE_NO} = State) ->
    {noreply, State};
%% 流程退出定时器
handle_info({'flow_quit_ref'}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    F = fun(#dungeon_role{id = RoleId, is_end_out = IsEndOut}) ->
        case IsEndOut == ?DUN_IS_END_OUT_NO of
            true -> mod_dungeon:passive_flow_quit(self(), RoleId);
            false -> skip
        end
    end,
    lists:foreach(F, RoleList),
    {noreply, State};

%% 复活定时器
handle_info({'revive_ref', RoleId}, State) ->
    #dungeon_state{dun_type = _DunType, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewState = State;
        #dungeon_role{hp_lim = HpLim, revive_ref = OldRef, node = Node} = DungeonRole ->
            util:cancel_timer(OldRef),
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_DUNGEON, []]),
            NewDungeonRole = DungeonRole#dungeon_role{hp = HpLim, revive_ref = none},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList}
    end,        
    {noreply, NewState};

handle_info({revive_mon, MonId, CreateKey}, State) ->
    #dungeon_state{typical_data = TypicalData} = State,
    case maps:find({?DUN_STATE_SPCIAL_KEY_MON_REVIVE, MonId}, TypicalData) of
        {ok, _ReviveRef} ->
            TmpState = lib_dungeon_mon_event:revive_mon(State, CreateKey, MonId),
            NewTypicalData = maps:remove({?DUN_STATE_SPCIAL_KEY_MON_REVIVE, MonId}, TypicalData),
            {noreply, TmpState#dungeon_state{typical_data = NewTypicalData}};
        _ ->
            {noreply, State}
    end;

handle_info({apply, Mod, Fun, Args}, State) ->
    case Mod:Fun(State, Args) of
        NewState when is_record(NewState, dungeon_state) ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_info({get_partner_mon_msg, RoleId}, State) ->
    lib_dungeon_partner:get_partner_mon_msg(RoleId, State),
    {noreply, State};


handle_info({delay_load_dun}, State) ->
    NewState = lib_dungeon_mod:delay_load_dun(State),
    {noreply, NewState};

handle_info({role_finish_enter_dun, _RoleId}, State) ->
    NewState = lib_dungeon_mod:delay_load_dun(State),
    {noreply, NewState};

handle_info({'dispatch_dungeon_event', EventTypeId = ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, EventData}, State) ->
    #dungeon_state{story_map = StoryMap, story_play_time_mi = StoryPlayTimeMIOld} = State,
    #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId} = EventData,
    case maps:get({StoryId, SubStoryId}, StoryMap, #story_player_record{start_time =  utime:longunixtime()}) of
        #story_player_record{is_end = ?STORY_FINISH} -> %% 已经完成剧情
            {noreply, State};
        #story_player_record{ref = Ref, start_time = StoryStartTime} = OldRecord ->
            util:cancel_timer(Ref),
            NewStoryMap = maps:put({StoryId, SubStoryId}, OldRecord#story_player_record{is_end = ?STORY_FINISH}, StoryMap),
            %%  计算播放时间
            AddTime = max(utime:longunixtime() - StoryStartTime, 0),
            NewState = State#dungeon_state{story_map = NewStoryMap},
            lib_dungeon_event:dispatch_dungeon_event(NewState#dungeon_state{story_play_time_mi = StoryPlayTimeMIOld + AddTime}, EventTypeId, EventData);
        _ ->
            {noreply, State}
    end;



handle_info({'dispatch_dungeon_event', EventTypeId, EventData}, State) ->
    lib_dungeon_event:dispatch_dungeon_event(State, EventTypeId, EventData);



handle_info({'exp_dungeon_trigger', RoleId}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_trigger_add_exp, [State, RoleId], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

handle_info(stop, State) ->
    {stop, normal, State};

%% 默认匹配
handle_info(Info, State) ->
    catch ?ERR("mod_dungeon_info:handle_info not match: ~p", [Info]),
    {noreply, State}.
