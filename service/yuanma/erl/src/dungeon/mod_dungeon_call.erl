%% ---------------------------------------------------------------------------
%% @doc mod_dungeon_call.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本进程
%% ---------------------------------------------------------------------------
-module(mod_dungeon_call).
-export([handle_call/3]).

-include("dungeon.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("errcode.hrl").

%% 检查进入
handle_call({'check_enter', RoleId, _RoleX, _RoleY}, _From, State) ->
    #dungeon_state{dun_id = DunId, now_scene_id = NowSceneId, scene_pool_id = ScenePoolId, role_list = RoleList, revive_map = ReviveMap, is_end = IsEnd} = State,
    if
        IsEnd =:= ?DUN_IS_END_YES ->
            Reply = {false, ?ERRCODE(err610_dungeon_is_end)};
        true ->
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                false -> 
                    Reply = {false, ?ERRCODE(err610_dungeon_role_not_exist)};
                DungeonRole ->
                    #ets_scene{x = NewRoleX, y = NewRoleY} = data_scene:get(NowSceneId),
                    %% #dungeon{is_in_situ = IsInSitu} = data_dungeon:get(DunId),
                    %% %% 计算玩家进入的坐标点
                    %% case IsInSitu == 0 of
                    %%     true -> #ets_scene{x = NewRoleX, y = NewRoleY} = data_scene:get(NowSceneId);
                    %%     false -> NewRoleX = RoleX, NewRoleY = RoleY
                    %% end,
                    % 返回给玩家数据
                    #dungeon_role{
                        scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY, 
                        dead_time = DeadTime, revive_count = ReviveCount, hp = Hp, hp_lim = HpLim
                        } = DungeonRole,
                    Out = #dungeon_out{scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY},
                    Reply = {true, DunId, NowSceneId, ScenePoolId, NewRoleX, NewRoleY, Hp, HpLim, DeadTime, ReviveCount, Out, ReviveMap}
            end
    end,
    {reply, Reply, State};

handle_call({'check_enter', _RoleId, _RoleX, _RoleY, DungeonRole}, _From, State) ->
    #dungeon_state{dun_id = DunId, now_scene_id = NowSceneId, scene_pool_id = ScenePoolId, role_list = RoleList, revive_map = ReviveMap, is_end = IsEnd} = State,
    if
        IsEnd =:= ?DUN_IS_END_YES ->
            NewRoleList = RoleList,
            Reply = {false, ?ERRCODE(err610_dungeon_is_end)};
        true ->
            #ets_scene{x = NewRoleX, y = NewRoleY} = data_scene:get(NowSceneId),
            %% #dungeon{is_in_situ = IsInSitu} = data_dungeon:get(DunId),
            %% % 计算玩家进入的坐标点
            %% case IsInSitu == 0 of
            %%     true -> #ets_scene{x = NewRoleX, y = NewRoleY} = data_scene:get(NowSceneId);
            %%     false -> NewRoleX = RoleX, NewRoleY = RoleY
            %% end,
            % 返回给玩家数据
            #dungeon_role{
                scene = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY, 
                dead_time = DeadTime, revive_count = ReviveCount, hp = Hp, hp_lim = HpLim
                } = DungeonRole,
            Out = #dungeon_out{scene  = OutSceneId, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY},
            Reply = {true, DunId, NowSceneId, ScenePoolId, NewRoleX, NewRoleY, Hp, HpLim, DeadTime, ReviveCount, Out, ReviveMap},
            NewRoleList = lists:keystore(DungeonRole#dungeon_role.id, #dungeon_role.id, RoleList, DungeonRole)
    end,
    {reply, Reply, State#dungeon_state{role_list = NewRoleList}};

%% 再次进入副本的处理
% handle_call({'again_enter_dungeon', _RoleId, NewDunType}, _From, State) ->
%     #dungeon_state{dun_type = DunType, role_list = RoleList, is_end = IsEnd} = State,
%     IsAnyOut = lists:any(
%         fun(#dungeon_role{is_end_out = IsEndOut, online = Online}) -> 
%             IsEndOut =/= ?DUN_IS_END_OUT_NO orelse Online =/= ?DUN_ONLINE_YES 
%         end
%         , RoleList),
%     if
%         % 必须是同一类型的副本才能再次进入
%         DunType =/= NewDunType -> {reply, false, State};
%         % 任意玩家离开都不能再进入副本
%         IsAnyOut -> {reply, false, State};
%         IsEnd == ?DUN_IS_END_YES andalso 
%                 (DunType == ?DUNGEON_TYPE_MOUNT orelse DunType == ?DUNGEON_TYPE_PARTNER orelse 
%                     DunType == ?DUNGEON_TYPE_RUNE2) -> 
%             F = fun(#dungeon_role{id = TmpRoleId, is_end_out = IsEndOut}, TmpState) ->
%                 case IsEndOut == ?DUN_IS_END_OUT_NO of
%                     true ->
%                         lib_dungeon_mod:log_dungeon(TmpState, TmpRoleId, ?DUN_LOG_TYPE_QUIT, []),
%                         case lib_dungeon_mod:handle_role_out(TmpState, TmpRoleId, ?DUN_LOG_TYPE_QUIT, ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT, true) of
%                             {noreply, NewTmpState} -> NewTmpState;
%                             {stop, normal, NewTmpState} -> NewTmpState
%                         end;
%                     false -> 
%                         TmpState
%                 end
%             end,
%             NewState = lists:foldl(F, State, RoleList),
%             {stop, normal, true, NewState};
%         true -> 
%             {reply, false, State}
%     end;

handle_call('tsmap_dun_level', _From, State) ->
    #dungeon_state{is_end=IsEnd, level=Level, is_level_end=IsLevelEnd} = State,
    {reply, {IsEnd, Level, IsLevelEnd}, State};

%% 默认匹配
handle_call(Event, _From, State) ->
    catch ?ERR("mod_dungeon_call:handle_call not match: ~p", [Event]),
    {reply, ok, State}.
