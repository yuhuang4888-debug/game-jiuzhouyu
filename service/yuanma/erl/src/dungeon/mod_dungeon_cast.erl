%% ---------------------------------------------------------------------------
%% @doc mod_dungeon_cast.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本进程
%% ---------------------------------------------------------------------------
-module(mod_dungeon_cast).
-export([handle_cast/2]).

-include("dungeon.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").

%% ====================
%% 玩家请求数据
%% ====================

%% 副本信息
handle_cast({'send_dungeon_info', Sid}, State) ->
    #dungeon_state{dun_type = DunType, start_time = StartTime, start_time_ms = StartTimeMs, end_time = EndTime, wave_num = WaveNum, owner_id = OwnerId, level = Level, level_end_time = LevelEndTime, wave_mon_map = WaveMonMap} = State,
    {ok, BinData} = pt_610:write(61004, [StartTime, StartTimeMs, EndTime, Level, LevelEndTime, OwnerId, WaveNum]),
    lib_server_send:send_to_sid(Sid, BinData),
    {GenerateMonList, DeadMonList} = maps:get(WaveNum, WaveMonMap, {[], []}),
    {ok, BinDataA} = pt_610:write(61066, [WaveNum, length(DeadMonList), length(GenerateMonList)]),
    DunType =:= ?DUNGEON_TYPE_BEINGS_GATE andalso lib_dungeon_mod:send_msg(State, BinDataA),
    {noreply, State};

% %% 伙伴列表
% handle_cast({'send_partner_list', RoleId}, State) ->
%     lib_dungeon_mod:send_partner_list(State, RoleId),
%     {noreply, State};

%% 伙伴出战
% handle_cast({'choose_partner_group', RoleId, PartnerGroup, X, Y}, State) ->
%     {ok, NewState} = lib_dungeon_mod:choose_partner_group(State, RoleId, PartnerGroup, X, Y),
%     {noreply, NewState};

%% 推送结算
handle_cast({'push_settlement', RoleId}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> skip;
        DungeonRole -> lib_dungeon_mod:push_settlement(State, DungeonRole)
    end,
    {noreply, State};

%% 剧情播放通知
handle_cast({'send_story_list', RoleId}, State) ->
    #dungeon_state{role_list = RoleList, story_map = StoryMap} = State,
    % ?PRINT("send_story_list:~w ~n", [StoryMap]),
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            F = fun({StoryId, SubStoryId}, #story_player_record{is_end = IsEnd}, TmpList) -> [{StoryId, SubStoryId, IsEnd}|TmpList] end,
            StoryList = maps:fold(F, [], StoryMap),
            {ok, BinData} = pt_610:write(61014, [StoryList]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        false ->
            skip
    end,
    {noreply, State};

%% 更新剧情
handle_cast({'update_story', StoryId, SubStoryId, IsEnd}, State) ->
    #dungeon_state{story_map = StoryMap, story_play_time_mi = OldStoryPlayTimeAll} = State,
    case maps:get({StoryId, SubStoryId}, StoryMap, []) of
        [] ->
            OldIsEnd = ?STORY_NOT_FINISH,
            StoryStartTime = utime:longunixtime(),
            NewStoryMap = maps:put({StoryId, SubStoryId}, #story_player_record{is_end = IsEnd, start_time = StoryStartTime}, StoryMap);
        #story_player_record{is_end = OldIsEnd, start_time = StoryStartTime} = OldRecord ->
            case OldIsEnd == ?STORY_FINISH of
                true -> NewStoryMap = StoryMap;
                false -> NewStoryMap = maps:put({StoryId, SubStoryId}, OldRecord#story_player_record{is_end = IsEnd}, StoryMap)
            end
    end,
    case maps:size(NewStoryMap) >= 1000 of
        true ->
            ?ERR("dungeon.story_map:client send much error story", []),
            NewStoryMap2 = #{};
        false ->
            NewStoryMap2 = NewStoryMap
    end,
    NewState = State#dungeon_state{story_map = NewStoryMap2},
    case IsEnd == ?STORY_FINISH  andalso OldIsEnd == ?STORY_NOT_FINISH of
        true ->
            AddTimeMI = max(utime:longunixtime() - StoryStartTime, 0),
%%            ?PRINT("AddTimeMI ~p~n", [AddTimeMI]),
            StoryEventData = #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId, start_time = StoryStartTime},
            lib_dungeon_event:dispatch_dungeon_event(NewState#dungeon_state{story_play_time_mi = OldStoryPlayTimeAll + AddTimeMI}, ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, StoryEventData);
        false ->
            {noreply, NewState}
    end;

%% 跳过副本
handle_cast({'skip_dungeon', RoleId}, State) ->
    lib_dungeon_mod:skip_dungeon(State, RoleId);

%% 退出副本时间
handle_cast({'send_flow_quit_time', RoleId}, State) ->
    #dungeon_state{flow_quit_ref = FowQuitRef, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            case catch erlang:read_timer(FowQuitRef) of
                N when is_integer(N) -> Type = 1, EndTime = utime:unixtime() + N div 1000;
                _ -> Type = 0, EndTime = 0
            end,
            {ok, BinData} = pt_610:write(61018, [Type, EndTime]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

%% 发送坐标事件的触发情况
handle_cast({'send_xy_list', RoleId, SceneId}, State) ->
    #dungeon_state{xy_map = XyMap, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            XyList = maps:get(SceneId, XyMap, []),
            {ok, BinData} = pt_610:write(61019, [XyList]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast({'get_time_score_step', RoleId}, State) ->
    #dungeon_state{dun_id = DunId, start_time = StartTime, end_time = EndTime,
        result_time = ResultTime, dun_type = DunType, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            case lib_dungeon_api:get_special_api_mod(DunType, dunex_get_time_score_step, 1) of
                undefined ->
                    case data_dungeon_grade:get_dungeon_score(DunId) of
                        #dungeon_score{time_score_list = CfgTimeScoreList} ->
                            UseTime
                                = if
                                      ResultTime > 0 ->
                                          max(ResultTime - StartTime, 0);
                                      true ->
                                          min(utime:unixtime() - StartTime, EndTime - StartTime)
                                  end,
                            SortTimeScireList = lists:keysort(1, CfgTimeScoreList),
                            case lib_dungeon:get_time_score_step(SortTimeScireList, UseTime) of
                                {Score, NextTime, NextScore} ->
                                    NextTimeStamp = StartTime + NextTime;
                                Score ->
                                    NextTimeStamp = 0, NextScore = Score
                            end,
                            {ok, BinData} = pt_610:write(61023, [Score, NextScore, NextTimeStamp]),
                            lib_server_send:send_to_uid(Node, RoleId, BinData);
                        _ ->
                            skip
                    end;
                Mod ->
                    {Score, NextScore, NextTimeStamp} = Mod:dunex_get_time_score_step(State),
                    {ok, BinData} = pt_610:write(61023, [Score, NextScore, NextTimeStamp]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData)
            end;
        _ ->
            skip
    end,
    {noreply, State};

handle_cast({'encourage', RoleId, CostType}, State) ->
    case lib_dungeon_api:invoke(State#dungeon_state.dun_type, dunex_encourage, [State, RoleId, CostType], skip) of
        {ok, NewState} -> {noreply, NewState};
        _ -> {noreply, State}
    end;

handle_cast({'setup_encourage_count', RoleId, CostType, Count}, State) ->
    case lib_dungeon_api:invoke(State#dungeon_state.dun_type, dunex_setup_encourage_count, [State, RoleId, CostType, Count], skip) of
        {ok, NewState} -> {noreply, NewState};
        _ -> {noreply, State}
    end;

handle_cast({'get_encourage_count', RoleId}, State) ->
    case lib_dungeon_api:invoke(State#dungeon_state.dun_type, dunex_get_encourage_count, [State, RoleId], skip) of
        {ok, NewState} -> {noreply, NewState};
        _ -> {noreply, State}
    end;

handle_cast({'get_next_wave_time', RoleId}, #dungeon_state{wave_num = WaveNum, next_wave_time = [WaveNum, Time]} = State) ->
    case lists:keyfind(RoleId, #dungeon_role.id, State#dungeon_state.role_list) of
        #dungeon_role{node = Node} -> ok;
        _ ->
            Node = none
    end,
    {ok, BinData} = pt_610:write(61030, [WaveNum, Time]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

handle_cast({'get_next_wave_time', RoleId}, State) ->
    #dungeon_state{wave_num = WaveNum, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} -> ok;
        _ ->
            Node = none
    end,
    Time = lib_dungeon_mod:get_next_wave_time(State),
    {ok, BinData} = pt_610:write(61030, [WaveNum, Time]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State#dungeon_state{next_wave_time = [WaveNum, Time]}};

handle_cast({'get_die_mon_count', RoleId}, State) ->
    #dungeon_state{typical_data = TypicalData, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            DieMonCount = maps:get(?DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT, TypicalData, 0),
            {ok, BinData} = pt_610:write(61031, [DieMonCount]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast({'get_hurt_rank', RoleId}, State) ->
    #dungeon_state{typical_data = TypicalData, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            HurtRankList = maps:get(?DUN_STATE_SPCIAL_KEY_HURT_RANK, TypicalData, []),
            SendList = lists:sublist(HurtRankList, 3),
            MyRank = ulists:find_index(fun({Id, _, _}) -> Id =:= RoleId end, HurtRankList),
            {_, _, MyHurt} = ulists:keyfind(RoleId, 1, HurtRankList, {RoleId, "", 0}),
            {ok, BinData} = pt_610:write(61032, [MyRank, MyHurt, SendList]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast({'get_hp_list', RoleId}, State) ->
    #dungeon_state{typical_data = TypicalData, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node} ->
            HpList = maps:get(?DUN_STATE_SPCIAL_KEY_HP_LIST, TypicalData, []),
            {ok, BinData} = pt_610:write(61034, [HpList]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

%% ====================
%% 进程处理
%% ====================

%% 切换到副本场景
handle_cast({'change_to_dungeon_scene', _RoleId, _X, _Y}, State) ->
    % NewState = lib_dungeon_mod:create_partner(State, RoleId, X, Y),
    % lib_dungeon_mod:send_partner_list(NewState, RoleId),
    {noreply, State};

%% 完成切入到副本场景
handle_cast({'fin_change_scene', RoleId, X, Y}, State) ->
    #dungeon_state{dun_type = DunType} = State,
    % Dun = data_dungeon:get(DunId),
    % PosMap = lib_dungeon_util:get_first_create_partner_pos_map(Dun, SceneId, ScenePoolId, self(), X, Y),
    % NewState = lib_dungeon_mod:create_partner(State, RoleId, PosMap),
    case lib_dungeon_api:invoke(DunType, dunex_fin_change_scene, [State, RoleId, X, Y], skip) of
        NewState when is_record(NewState, dungeon_state) -> ok;
        _ -> NewState = State
    end,
    % lib_dungeon_mod:send_partner_list(NewState, RoleId),
    {noreply, NewState};

%% 派发副本事件
handle_cast({'dispatch_dungeon_event', EventTypeId = ?DUN_EVENT_TYPE_ID_STORY_ID_FINISH, EventData}, State) ->
    #dungeon_state{story_map = StoryMap} = State,
    #dun_callback_story_id_finish{story_id = StoryId, sub_story_id = SubStoryId} = EventData,
    case maps:get({StoryId, SubStoryId}, StoryMap, #story_player_record{start_time =  utime:longunixtime()}) of
        #story_player_record{is_end = ?STORY_FINISH} -> %% 已经完成剧情
            {noreply, State};
        #story_player_record{ref = Ref, start_time = StoryStartTime} = OldRecord ->
            util:cancel_timer(Ref),
            NewStoryMap = maps:put({StoryId, SubStoryId}, OldRecord#story_player_record{is_end = ?STORY_FINISH}, StoryMap),
            NewState = State#dungeon_state{story_map = NewStoryMap},
            lib_dungeon_event:dispatch_dungeon_event(NewState, EventTypeId, EventData#dun_callback_story_id_finish{start_time = StoryStartTime});
        _ ->
            {noreply, State}
    end;

handle_cast({'dispatch_dungeon_event', EventTypeId, EventData}, State) ->
    lib_dungeon_event:dispatch_dungeon_event(State, EventTypeId, EventData);

%% 击杀怪物
handle_cast({'kill_mon', AutoId, Mid, DieSign, CreateKey, OwnId, DieDatas}, State) ->
    lib_dungeon_event:kill_mon(State, AutoId, Mid, DieSign, CreateKey, OwnId, DieDatas);

%% 停止怪物
handle_cast({'stop_mon', AutoId, Mid, DieSign, CreateKey, OwnId, Hp, HpLim}, State) ->
    lib_dungeon_event:stop_mon(State, AutoId, Mid, DieSign, CreateKey, OwnId, Hp, HpLim);

%% 对象死亡
% handle_cast({'object_die', AutoId, OwnId}, State) ->
%     NewState = lib_dungeon_mod:stop_partner(State, AutoId, OwnId, 0),
%     {noreply, NewState};

%% 对象停止
% handle_cast({'object_stop', AutoId, OwnId, Hp, _HpLim}, State) ->
%     NewState = lib_dungeon_mod:stop_partner(State, AutoId, OwnId, Hp),
%     {noreply, NewState};

%% 玩家死亡
handle_cast({'player_die', RoleId, HpLim, AttrList}, State) ->
    {ok, NewState} = lib_dungeon_mod:update_dungeon_role(State, RoleId, AttrList),
    #dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList, result_type = ResultType} = NewState,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewState2 = NewState;
        #dungeon_role{dead_time = DeadTime, revive_count = ReviveCount, revive_ref = OldRef} = DungeonRole ->
            util:cancel_timer(OldRef),
            DefRet = lib_dungeon:get_revive_info(DunId, DeadTime, ReviveCount),
            Return = lib_dungeon_api:invoke(DunType, dunex_get_revive_info, [State, RoleId], DefRet),
            ?PRINT("player_die get_revive_info Return ~p ~n", [Return]),
            case Return of
                {false, _ErrorCode} -> Ref = none;
                {true, NextReiveTime} ->
                    if
                        ResultType =/= ?DUN_RESULT_TYPE_NO ->
                            Diff = 0;
                        true ->
                            Diff = NextReiveTime - utime:unixtime()
                    end,
                    Ref = erlang:send_after(max(Diff*1000, 10), self(), {'revive_ref', RoleId})
            end,
            NewDungeonRole = DungeonRole#dungeon_role{hp = 0, hp_lim = HpLim, revive_ref = Ref},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState2 = NewState#dungeon_state{role_list = NewRoleList}
    end,
    lib_dungeon_event:player_die(NewState2, RoleId, HpLim);

%% 玩家复活
handle_cast({'player_revive', RoleId}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewState = State;
        #dungeon_role{revive_ref = OldRef} = DungeonRole ->
            util:cancel_timer(OldRef),
            NewDungeonRole = DungeonRole#dungeon_role{revive_ref = none},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList}
    end,
    {noreply, NewState};

%% 玩家选择复活
handle_cast({'async_revive', RoleId, Node}, State) ->
    #dungeon_state{dun_type = DunType, role_list = RoleList} = State,
    ?PRINT("async_revive start  ~n", []),
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> NewState = State;
        #dungeon_role{hp_lim = HpLim, revive_ref = OldRef} = DungeonRole ->
            util:cancel_timer(OldRef),
            ?PRINT("async_revive OldRef ~p ~n", [OldRef]),
            case lib_dungeon_api:get_special_api_mod(DunType, dunex_async_revive, 3) of
                undefined ->
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_DUNGEON, []]),
                    NewDungeonRole = DungeonRole#dungeon_role{hp = HpLim, revive_ref = none},
                    NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
                    NewState = State#dungeon_state{role_list = NewRoleList};
                Mod ->
                    NewState = Mod:dunex_async_revive(State, RoleId, Node)
            end
    end,
    {noreply, NewState};

%% 更新玩家数据
handle_cast({'update_dungeon_role', RoleId, AttrList}, State) ->
    {ok, NewState} = lib_dungeon_mod:update_dungeon_role(State, RoleId, AttrList),
    {noreply, NewState};

%% 更新玩家的关系数据
handle_cast({'update_rela_list', RoleId, OriginRelaList}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{rela_list = RelaList} = DungeonRole ->
            F = fun({TmpRoleId, RelaType, Intimacy}, TmpRelaList) ->
                case lists:keymember(TmpRoleId, #dungeon_role.id, RoleList) of
                    true ->
                        case lists:keyfind(TmpRoleId, #dungeon_role_rela.id, RelaList) of
                            false -> IsAskAdd = 0;
                            #dungeon_role_rela{is_ask_add = IsAskAdd} -> ok
                        end,
                        Rela = #dungeon_role_rela{
                            id = TmpRoleId
                            , rela_type = RelaType
                            , intimacy = Intimacy
                            , is_ask_add = IsAskAdd
                            },
                        [Rela|TmpRelaList];
                    false ->
                        TmpRelaList
                end
            end,
            NewRelaList = lists:foldl(F, [], OriginRelaList),
            NewDungeonRole = DungeonRole#dungeon_role{rela_list = NewRelaList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            {noreply, NewState}
    end;

%% 添加好友请求
handle_cast({'ask_add_friend', RoleId, IdList}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{rela_list = RelaList} = DungeonRole ->
            F = fun(TmpRoleId, TmpRelaList) ->
                case lists:keyfind(TmpRoleId, #dungeon_role_rela.id, TmpRelaList) of
                    false -> TmpRelaList;
                    Rela ->
                        NewRela = Rela#dungeon_role_rela{is_ask_add = 1},
                        lists:keystore(TmpRoleId, #dungeon_role_rela.id, TmpRelaList, NewRela)
                end
            end,
            NewRelaList = lists:foldl(F, RelaList, IdList),
            NewDungeonRole = DungeonRole#dungeon_role{rela_list = NewRelaList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            lib_dungeon_mod:push_settlement(NewState, NewDungeonRole),
            {noreply, NewState}
    end;

% 发送公会邀请
handle_cast({'send_guild_invite', RoleId, InviteeId}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{rela_list = RelaList} = DungeonRole ->
            case lists:keyfind(InviteeId, #dungeon_role_rela.id, RelaList) of
                false -> NewRelaList = RelaList;
                Rela ->
                    NewRela = Rela#dungeon_role_rela{is_invite_guild = 1},
                    NewRelaList = lists:keystore(InviteeId, #dungeon_role_rela.id, RelaList, NewRela)
            end,
            NewDungeonRole = DungeonRole#dungeon_role{rela_list = NewRelaList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            lib_dungeon_mod:push_settlement(NewState, NewDungeonRole),
            {noreply, NewState}
    end;

%% 登录
handle_cast({'login', RoleId, AttrList}, State) ->
    #dungeon_state{
        dun_id = DunId, dun_type = DunType, is_end = IsEnd, role_list = RoleList, now_scene_id = NowSceneId, scene_pool_id = ScenePoolId,
        revive_map = ReviveMap
        } = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false ->
            % ?PRINT(":login no found ~p~n", [RoleId]),
            lib_scene:player_change_default_scene(RoleId, [{change_scene_hp_lim, 0}]),
            {noreply, State};
        #dungeon_role{node = Node} = DungeonRole ->
            % ?PRINT(":login found ~p~n", [RoleId]),
            #dungeon_role{
                scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY,
                dead_time = DeadTime, revive_count = ReviveCount, hp = Hp, hp_lim = HpLim, count = Count
                } = DungeonRole,
            % 定时器取消
            % util:cancel_timer(DelayLogoutRef),
            NewDungeonRole = DungeonRole#dungeon_role{online = ?DUN_ONLINE_YES},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            {ok, NewState2} = lib_dungeon_mod:update_dungeon_role(NewState, RoleId, AttrList),
            % 玩家传送
            case maps:get(NowSceneId, ReviveMap, []) of
                [] -> #ets_scene{x = RoleX, y = RoleY} = data_scene:get(NowSceneId);
                {RoleX, RoleY} -> ok
            end,
            case Hp == 0 of
                true -> Ghost = 1;
                false -> Ghost = 0
            end,
            Out = #dungeon_out{scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY},
            StatusDungeonAttrList = [
                {dun_id, DunId}, {dun_type, DunType}, {is_end, IsEnd}, {dead_time, DeadTime}, {revive_count, ReviveCount}, {out, Out},
                {revive_map, ReviveMap}, {count, Count}],
            RoleAttrList = [{hp, Hp}, {hp_lim, HpLim}, {ghost, Ghost}, {status_dungeon, StatusDungeonAttrList}],
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, login_back_to_scene,
                [NowSceneId, ScenePoolId, self(), RoleX, RoleY, RoleAttrList]),
            % lib_scene:player_change_scene(RoleId, NowSceneId, ScenePoolId, self(), RoleX, RoleY ,false, RoleAttrList),
            {noreply, NewState2}
    end;

%% 重新登录
% handle_cast({'relogin', RoleId}, State) ->
%     #dungeon_state{role_list = RoleList} = State,
%     case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
%         false -> {noreply, State};
%         #dungeon_role{} = DungeonRole ->
%             NewDungeonRole = DungeonRole#dungeon_role{online = ?ONLINE_ON},
%             NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
%             NewState = State#dungeon_state{role_list = NewRoleList},
%             {noreply, NewState}
%     end;

%% 玩家延迟退出副本
handle_cast({'delay_logout', RoleId, Hp, HpLim, OffMap}, State) ->
    % ?MYLOG("hjhlogout", "delay_logout RoleId:~p ~n", [RoleId]),
    case config:get_cls_type() of
        ?NODE_GAME ->
            lib_dungeon_mod:delay_logout(State, RoleId, Hp, HpLim);
        _ ->
            lib_dungeon_mod:logout(State, RoleId, Hp, HpLim, OffMap)
    end;
    % lib_dungeon_mod:delay_logout(State, RoleId, Hp, HpLim);

%% 玩家退出副本
handle_cast({'logout', RoleId, Hp, HpLim, OffMap}, State) ->
    lib_dungeon_mod:logout(State, RoleId, Hp, HpLim, OffMap);

%% 被动强制退出
handle_cast({'passive_force_quit', RoleId}, State) ->
    lib_dungeon_mod:passive_force_quit(State, RoleId);

%% 被动流程退出
handle_cast({'passive_flow_quit', RoleId}, State) ->
    lib_dungeon_mod:passive_flow_quit(State, RoleId);

%% 退出副本
handle_cast({'active_quit', RoleId}, State) ->
    lib_dungeon_mod:active_quit(State, RoleId);

%% 直接副本结束(不结算)
handle_cast({'close_dungeon'}, State) ->
    #dungeon_state{role_list = RoleList, scene_list = SceneList, result_type = ResultType} = State,
    F = fun(#dungeon_role{id = RoleId, is_end_out = IsEndOut, node = Node}) ->
        case IsEndOut == ?DUN_IS_END_OUT_NO of
            true ->
                Score = lib_dungeon:calc_score(State, RoleId),
                lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, close_dungeon, [ResultType, SceneList, self(), Score]);
            false -> skip
        end
    end,
    lists:foreach(F, RoleList),
    {stop, normal, State};

%% 再次进入副本的处理
handle_cast({'again_enter_dungeon', RoleId, RoleNode, NewDunId, NewDunType}, State) ->
    #dungeon_state{dun_type = DunType, role_list = RoleList, is_end = IsEnd} = State,
    IsAnyOut = lists:any(
        fun(#dungeon_role{is_end_out = IsEndOut, online = Online}) ->
            IsEndOut =/= ?DUN_IS_END_OUT_NO orelse Online =/= ?DUN_ONLINE_YES
        end
        , RoleList),
    DungeonRole = lists:keyfind(RoleId, #dungeon_role.id, RoleList),
    IsAgainDun = ?IS_AGAIN_DUN(DunType),
    Result = if
        % 必须是同一类型的副本才能再次进入
        DunType =/= NewDunType -> {false, ?ERRCODE(err610_can_not_again_enter_dungeon)};
        % 任意玩家离开都不能再进入副本
        IsAnyOut -> {false, ?ERRCODE(err610_can_not_again_enter_dungeon)};
        DungeonRole == false -> {false, ?ERRCODE(err610_can_not_again_enter_dungeon)};
        IsEnd == ?DUN_IS_END_YES andalso IsAgainDun ->
            F = fun(#dungeon_role{id = TmpRoleId, is_end_out = IsEndOut}, TmpState) ->
                case IsEndOut == ?DUN_IS_END_OUT_NO of
                    true ->
                        % lib_dungeon_mod:log_dungeon(TmpState, TmpRoleId, ?DUN_LOG_TYPE_AGAIN_OUT, []),
                        case lib_dungeon_mod:handle_role_out(TmpState, TmpRoleId, ?DUN_LOG_TYPE_AGAIN_OUT, ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT, true, #{}) of
                            {noreply, NewTmpState} -> NewTmpState;
                            {stop, normal, NewTmpState} -> NewTmpState
                        end;
                    false ->
                        TmpState
                end
            end,
            NewState = lists:foldl(F, State, RoleList),
            #dungeon_role{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y} = DungeonRole,
            Out = #dungeon_out{scene  = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, is_again = 1},
            lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_dungeon, again_enter_dungeon, [NewDunId, Out]),
            {stop, normal, NewState};
        true ->
            {false, ?ERRCODE(err610_can_not_again_enter_dungeon)}
    end,
    case Result of
        {false, ErrorCode} ->
            {ok, BinData} = pt_610:write(61001, [NewDunId, 0, ErrorCode, ""]),
            lib_server_send:send_to_uid(RoleNode, RoleId, BinData),
            {noreply, State};
        _ ->
            Result
    end;

%% 篝火死亡
% handle_cast({'bonfire_die'}, State) ->
%     #dungeon_state{role_list = RoleList} = State,
%     F = fun(#dungeon_role{id = RoleId, is_end_out = IsEndOut}) ->
%         case IsEndOut == ?DUN_IS_END_OUT_NO of
%             true ->
%                 {ok, BinData} = pt_610:write(61012, []),
%                 lib_server_send:send_to_uid(RoleId, BinData);
%             false ->
%                 skip
%         end
%     end,
%     lists:foreach(F, RoleList),
%     {noreply, State};

%% 掉落处理
handle_cast({'drop_choose', RoleId, #{goods := ObjectList, id := DropId} = Data}, State) ->
    % ?PRINT("drop_choose ~p~n", [[RoleId, Data]]),
    #dungeon_state{role_list = RoleList, dun_id = DunId, dun_type = DunType, now_scene_id = SceneId} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{drop_reward_list = RewardList, drop_list = DropList,
            id = RoleId, figure = #figure{name = RoleName}, node = Node
        } = DungeonRole ->
            NewRewardList = lib_goods_api:make_reward_unique(ObjectList ++ RewardList),
            Rating = maps:get(rating, Data, 0),
            ExtraAttr = maps:get(extra_attr, Data, []),
            GoodsId = maps:get(goods_id, Data, 0),
            MonId = maps:get(mon_id, Data, 0),
            if
                DunType =:= ?DUNGEON_TYPE_VIP_PER_BOSS orelse DunType =:= ?DUNGEON_TYPE_PER_BOSS ->
                    BossType = lib_boss_api:get_boss_type_by_dun_type(DunType),
                    mod_boss:boss_add_drop_log(RoleId, RoleName, SceneId, BossType, MonId, [{GoodsId, 1, Rating, ExtraAttr}]);
                true ->
                    skip
            end,
            case maps:find(notice, Data) of
                {ok, [_|_] = Notice} ->
                    DunName = lib_dungeon_api:get_dungeon_name(DunId),
                    [unode:apply(Node, lib_chat, send_TV, [{all}, ModId, Id, [RoleName, RoleId, DunName, GoodsId, Rating, util:term_to_string(ExtraAttr)]])
                        || {?MOD_DUNGEON=ModId, Id} <- Notice];
                _ ->
                    skip
            end,
            NewDropList = lists:keydelete(DropId, #ets_drop.id, DropList),
            NewDungeonRole = DungeonRole#dungeon_role{drop_reward_list = NewRewardList, drop_list = NewDropList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            {noreply, NewState}
    end;

handle_cast({'goods_drop', RoleId, DropInfo}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{drop_list = DropList} = DungeonRole ->
            NewDropList = [DropInfo|DropList],
            NewDungeonRole = DungeonRole#dungeon_role{drop_list = NewDropList},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            {noreply, NewState}
    end;

handle_cast({update_mon_hp, Id, Mid, Hp, HpLim}, State) ->
    #dungeon_state{typical_data = TypicalData} = State,
    HpList = maps:get(?DUN_STATE_SPCIAL_KEY_HP_LIST, TypicalData, []),
    NewHpList = lists:keystore(Id, 1, HpList, {Id, Mid, Hp, HpLim}),
    {ok, BinData} = pt_610:write(61033, [Id, Mid, Hp, HpLim]),
    NewState = State#dungeon_state{typical_data = TypicalData#{?DUN_STATE_SPCIAL_KEY_HP_LIST => NewHpList}},
    lib_dungeon_mod:send_msg(NewState, BinData),
    {noreply, NewState};

handle_cast({update_role_lv, RoleId, Lv}, State) ->
    #dungeon_state{role_list = RoleList, dun_type = DunType} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{figure = Figure} = DungeonRole ->
            NewFigure = Figure#figure{lv = Lv},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, DungeonRole#dungeon_role{figure = NewFigure}),
            EnterLv = lib_dungeon:calc_enter_lv(NewRoleList, DunType),
            {noreply, State#dungeon_state{role_list = NewRoleList, enter_lv = EnterLv}};
        _ ->
            {noreply, State}
    end;

handle_cast({handle_special, Sid, Cmd, Args}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_special_pp_handle, [State, Sid, Cmd, Args], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

%% 秘籍结束副本
handle_cast({'gm_close_dungeon', RoleId, ResultType}, State) ->
    if
        ResultType == ?DUN_RESULT_TYPE_FAIL orelse ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
            lib_dungeon_mod:dungeon_result(State, ?DUN_SETTLEMENT_TYPE_DIRECT_END, ResultType, ?DUN_RESULT_SUBTYPE_NO);
        true ->
            lib_dungeon_mod:quit_dungeon(State, RoleId)
    end;

%% 秘籍结束关卡
handle_cast({'gm_close_dungeon_level', RoleId, ResultType}, State) ->
    if
        ResultType == ?DUN_RESULT_TYPE_FAIL orelse ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
            lib_dungeon_mod:dungeon_result(State, ?DUN_SETTLEMENT_TYPE_LEVEL_END, ResultType, ?DUN_RESULT_SUBTYPE_NO);
        true ->
            lib_dungeon_mod:quit_dungeon(State, RoleId)
    end;

%% 秘籍:怪物事件
handle_cast({'gm_common_event', BelongTypeList, CommonEventId}, State) ->
    if
        is_list(BelongTypeList) == false -> NewState = State;
        CommonEventId == 0 ->
            NewState = lib_dungeon_common_event:gm_check_and_execute(State, BelongTypeList);
        true ->
            F = fun(BelongType, TmpState) ->
                lib_dungeon_common_event:gm_check_and_execute(TmpState, BelongType, CommonEventId)
            end,
            NewState = lists:foldl(F, State, BelongTypeList)
    end,
    % ?PRINT("gm_common_event BelongTypeList:~w CommonEventId:~p ~n", [BelongTypeList, CommonEventId]),
    case lib_dungeon_event:handle_callback(NewState) of
        nothing -> {noreply, NewState};
        {noreply, NewState2} -> {noreply, NewState2}
    end;

handle_cast({handle_enter_fail, RoleId, _Why}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    NewRoleList = lists:keydelete(RoleId, #dungeon_role.id, RoleList),
    case lists:keytake(RoleId, #dungeon_role.id, RoleList) of
        {value, #dungeon_role{team_id = TeamId, node = Node}, NewRoleList} ->
            if
                TeamId > 0 ->
                    mod_team:cast_to_team(Node, TeamId, {'quit_dungeon', RoleId, ?DUN_RESULT_TYPE_NO});
                true ->
                    ok
            end;
        _ ->
            NewRoleList = RoleList
    end,
    NewState = State#dungeon_state{role_list = NewRoleList},
    case lib_dungeon_mod:nobody_in_dungeon(NewState) of
        true ->
            {stop, normal, NewState};
        _ ->
            {noreply, NewState}
    end;

handle_cast({ask_for_enter, DungeonRole}, #dungeon_state{is_end = ?DUN_IS_END_YES, dun_id = DunId} = State) ->
    {ok, BinData} = pt_610:write(61001, [DunId, 0, ?ERRCODE(err610_dungeon_is_end), ""]),
    case DungeonRole of
        #dungeon_role{node = Node, id = RoleId} ->
            unode:apply(Node, lib_server_send, send_to_uid, [RoleId, BinData]);
        {RoleId, Node} ->
            unode:apply(Node, lib_server_send, send_to_uid, [RoleId, BinData]);
        _ ->
            ok
    end,
    {noreply, State};

handle_cast({ask_for_enter, DungeonRole}, State) when is_record(DungeonRole, dungeon_role) ->
    #dungeon_state{role_list = RoleList} = State,
    NewRoleList = lists:keystore(DungeonRole#dungeon_role.id, #dungeon_role.id, RoleList, DungeonRole),
    NewState = State#dungeon_state{role_list = NewRoleList},
    lib_dungeon_mod:pull_player_into_dungeon(NewState, DungeonRole),
    {noreply, NewState};

handle_cast({ask_for_enter, {RoleId, _}}, State) when is_integer(RoleId) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        DungeonRole when is_record(DungeonRole, dungeon_role) ->
            % NewRoleList = lists:keystore(DungeonRole#dungeon_role.id, #dungeon_role.id, RoleList, DungeonRole),
            % NewState = State#dungeon_state{role_list = NewRoleList},
            lib_dungeon_mod:pull_player_into_dungeon(State, DungeonRole),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

handle_cast({enter_next_dungeon, RoleId, Args}, State) ->
    if
        State#dungeon_state.owner_id =:= RoleId ->
            case lib_dungeon_mod:change_next_dungeon_id(State, Args) of
                NewState when is_record(NewState, dungeon_state) ->
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end;
        true ->
            {noreply, State}
    end;

handle_cast({get_skip_mon_num, Sid}, #dungeon_state{typical_data = TypicalData} = State) ->
    Num = maps:get(?DUN_ROLE_SPECIAL_KEY_SKIP_MON_NUM, TypicalData, 0),
    {ok, BinData} = pt_610:write(61040, [Num]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

handle_cast({apply, Mod, Fun, Args}, State) ->
    case catch Mod:Fun(State, Args) of
        NewState when is_record(NewState, dungeon_state) ->
            {noreply, NewState};
        {'EXIT', Error} ->
            ?ERR("mod_dungeon_cast:~p~napply error: ~p~n", [[Mod, Fun, Args, Error]]),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

%%立即刷怪
handle_cast({'quik_create_mon_cast', RoleId}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_quik_create_mon, [RoleId, State], State),
    {noreply, NewState};

%%在副本中独立创建怪物
handle_cast({'create_mon', RoleId, MonId, X, Y}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_create_mon, [RoleId, MonId, X, Y, State], State),
    {noreply, NewState};

%%获取下一波刷新时间
handle_cast({'get_refresh_time'}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_get_refresh_time, [State], State),
    {noreply, NewState};

%% 增加经验
handle_cast({'add_exp', RoleId, AddExp}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_add_exp, [State, RoleId, AddExp], State),
    {noreply, NewState};

%% 增加经验
handle_cast({'add_exp', RoleId, AddExp, BaseExp, GoodsExpRatio}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_add_exp, [State, RoleId, AddExp, BaseExp, GoodsExpRatio], State),
    {noreply, NewState};

%% 使用了物品buff
handle_cast({'add_goods_buff', RoleId, GoodsExpRatio}, #dungeon_state{dun_type = DunType} = State) ->
    NewState = lib_dungeon_api:invoke(DunType, dunex_add_goods_buff, [State, RoleId, GoodsExpRatio], State),
    {noreply, NewState};

%% 面板信息
handle_cast({'send_panel_info', RoleId}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_send_panel_info, [State, RoleId], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

%% 触发经验信息
handle_cast({'trigger_add_exp', RoleId}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_trigger_add_exp, [State, RoleId], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

%% 面板信息
handle_cast({'send_wave_panel_info', RoleId}, State) ->
    NewState = lib_dungeon_mod:send_wave_panel_info(State, RoleId),
    {noreply, NewState};

%% 发送跳关信息
handle_cast({'send_jump_wave_info', RoleId, WaveNum}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_send_jump_wave_info, [State, RoleId, WaveNum], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

%% 复位
handle_cast({'reset_xy', RoleId}, #dungeon_state{dun_type = DunType} = State) ->
    case lib_dungeon_api:invoke(DunType, dunex_reset_xy, [State, RoleId], skip) of
        NewState when is_record(NewState, dungeon_state) -> {noreply, NewState};
        _ -> {noreply, State}
    end;

%% 玩家升级
handle_cast({'role_lv_up', RoleId, Lv}, State) ->
    {ok, NewState} = lib_dungeon_mod:role_lv_up(State, RoleId, Lv),
    {noreply, NewState};

%%设置奖励
handle_cast({'set_reward', RoleId, SourceRewardList, IsPushSettlement}, State) ->
    NewState = lib_dungeon_mod:set_reward(RoleId, SourceRewardList, IsPushSettlement, State),
    {noreply, NewState};

%% 提交答案
handle_cast({'answer_dun_question', RoleId, Answer}, State) ->
    {ok, NewState} = lib_dungeon_mod:answer_dun_question(State, RoleId, Answer),
    {noreply, NewState};

%% 设置副本开始波数
handle_cast({'set_dungeon_start_wave_num', StartWaveNum}, State) ->
    {ok, NewState} = lib_dungeon_mod:set_dungeon_start_wave_num(State, StartWaveNum),
    {noreply, NewState};

%% 获取累积经验
handle_cast({'get_exp_got', Args}, State) ->
    {ok, NewState} = lib_dungeon_mod:get_exp_got(State, Args),
    {noreply, NewState};

%% 快速出怪
handle_cast({'quick_create_mon', RoleId, ServerId}, State) ->
    NewState = lib_dungeon_mod:quick_create_mon(State, RoleId, ServerId),
    {noreply, NewState};

%% 快速出怪信息
handle_cast({'send_quick_create_mon_info', RoleId, ServerId}, State) ->
    lib_dungeon_mod:send_quick_create_mon_info(State, RoleId, ServerId),
    {noreply, State};

%% 拾取怪
handle_cast({'pick_mon', Mid, Coord, Skill, CollectorId}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(CollectorId, #dungeon_role.id, RoleList) of
        false ->
            {noreply, State};
        #dungeon_role{} = DungeonRole ->
            lib_dungeon_event:pick_mon(State, DungeonRole, Mid, Coord, Skill)
    end;

%% 技能信息
handle_cast({'send_skill_info', RoleId}, State) ->
    case lists:keyfind(RoleId, #dungeon_role.id, State#dungeon_state.role_list) of
        false -> skip;
        DungeonRole -> lib_dungeon_mod:send_skill_info(State, DungeonRole)
    end,
    {noreply, State};

%% 释放技能
handle_cast({'casting_skill', RoleId, SkillId}, State) ->
    NewState = case lists:keyfind(RoleId, #dungeon_role.id, State#dungeon_state.role_list) of
        false -> State;
        DungeonRole -> lib_dungeon_mod:casting_skill(State, DungeonRole, SkillId)
    end,
    {noreply, NewState};

%% 使魔副本，使魔被杀
handle_cast({'demon_die', DemonId}, State) ->
    lib_dun_demon:demon_die(State, DemonId);


handle_cast({'send_dungeon_special_info', RoleId}, State) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {noreply, State};
        #dungeon_role{node = Node} ->
            case lib_dungeon_api:get_special_api_mod(DunType, dunex_get_dungeon_special_info, 2) of
                undefined ->
                    {noreply, State};
                Mod ->
                    Msg = Mod:dunex_get_dungeon_special_info(State, RoleId),
                    {ok, BinData} = pt_610:write(61088, [DunId, DunType, 1, util:term_to_string(Msg)]),
                    lib_dungeon_mod:send_to_uid(Node, RoleId, BinData),
                    {noreply, State}
            end
    end;

handle_cast({'set_dun_role_setting', RoleId, SettingMap}, State) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{} = DunRole ->
            NewDunRole = DunRole#dungeon_role{setting = SettingMap},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDunRole),
            {noreply, State#dungeon_state{role_list = NewRoleList}};
        _ ->
           {noreply, State}
    end;

%% 默认匹配
handle_cast(Event, State) ->
    catch ?ERR("mod_dungeon_cast:handle_cast not match: ~p", [Event]),
    {noreply, State}.
