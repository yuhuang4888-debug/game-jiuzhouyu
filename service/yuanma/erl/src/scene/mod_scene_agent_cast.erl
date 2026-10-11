%%%------------------------------------
%%% @Module  : mod_scene_agent_cast
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.05.18
%%% @Description: 场景管理cast处理
%%%------------------------------------
-module(mod_scene_agent_cast).
-export([handle_cast/2]).
-include("scene.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("eudemons_land.hrl").
-include("def_fun.hrl").
-include("team.hrl").
-include("seacraft.hrl").

%% 更新场景玩家数据
handle_cast({'update', Key, KeyValueList}, State) ->
    case lib_scene_agent:get_user(Key) of
        [] ->
            {noreply, State};
        SceneUser ->
            NewSceneUser = lib_scene_user:set_data_sub(KeyValueList, SceneUser),
            lib_scene_agent:put_user(NewSceneUser),
            {noreply, State}
    end;

%% 移动
%% F  1, 8:怒海争霸传送门
%% TX, TY  目标坐标像素
%% OX, OY  原坐标像素
handle_cast({'move', [CopyId, TX, TY, F, OX, OY, BX, BY, FX, FY, Key]}, #ets_scene{id = _Id, type = SceneType} = State) ->
    case lib_scene_agent:get_user(Key) of
        #ets_scene_user{camp_id = Camp} when SceneType == ?SCENE_TYPE_SEACRAFT andalso F == 8 andalso Camp =/= ?DEFENDER -> 
            {noreply, State};
        #ets_scene_user{
                id = RoleId, copy_id=CopyId, pid = RolePid, scene = Scene, dun_type = DunType,
                battle_attr=#battle_attr{hide = Hide, ghost = Ghost, group = Group},
                team = #status_team{team_id = TeamId}, figure = Figure
                } = SceneUser ->
            if
                Hide == 1 orelse Ghost == 1 ->
                    skip;
                DunType == ?DUNGEON_TYPE_EQUIP ->
                    [ E#scene_object.aid ! {'ripple', RoleId, RolePid, ?BATTLE_SIGN_PLAYER, TX, TY, Group} || E <- lib_scene_object_agent:get_scene_object(CopyId)];
                SceneType == ?SCENE_TYPE_DUNGEON orelse SceneType == ?SCENE_TYPE_MAIN_DUN ->
                    {Xlg, Ylg} = lib_scene_calc:pixel_to_logic_coordinate(TX, TY),
                    [ Aid ! {'ripple', RoleId, RolePid, ?BATTLE_SIGN_PLAYER, TX, TY, Group}
                      || Aid <- lib_scene_object_agent:get_trace(CopyId, Xlg, Ylg)];
                true ->
                    %% 走路广播给怪物
                    case lib_boss:check_need_ai_scene(Scene) of
                        false -> skip;
                        true ->
                            {X, Y} = lib_scene_calc:pixel_to_logic_coordinate(TX, TY),
                            #figure{guild_id = GuildId} = Figure,
                            Msg =
                                #move_transport_to_mon{
                                    ob_id = RoleId,
                                    ob_pid = RolePid,
                                    target_x = TX,
                                    target_y = TY,
                                    sign = ?BATTLE_SIGN_PLAYER,
                                    team_id = TeamId,
                                    group_id = Group,
                                    guild_id = GuildId
                                },
                            [ Aid ! {'ai', Msg}
                                || Aid <- lib_scene_object_agent:get_trace(CopyId, X, Y)]
                    end
            end,
            %% 走路广播
            lib_scene:user_move(TX, TY, OX, OY, BX, BY, F, FX, FY, SceneUser, State),
            lib_scene_agent:put_user(SceneUser#ets_scene_user{x=TX, y=TY}),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

%% 移动
%% TX, TY  目标坐标像素
handle_cast({'scene_object_move', CopyId, TX, TY, Id}, State) ->
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{sign=Sign, x=X, y=Y, aid=AId, battle_attr = #battle_attr{group = Group}} = Object->

            case Sign of
                ?BATTLE_SIGN_PARTNER when State#ets_scene.type == ?SCENE_TYPE_DUNGEON orelse State#ets_scene.type == ?SCENE_TYPE_MAIN_DUN ->
                    {Xlg, Ylg} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
                    [ Aid ! {'ripple', Id, AId, Sign, X, Y, Group}
                      || Aid <- lib_scene_object_agent:get_trace(CopyId, Xlg, Ylg)];
                _ -> skip
            end,
            lib_scene_object_agent:put_object(Object#scene_object{x=TX, y=TY}),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

%% 玩家加入场景
handle_cast({'join', SceneUser}, State) ->
    #ets_scene_user{
        id = RoleId, pid = RolePid,  sid = Sid,
        scene = SceneId, scene_pool_id = _PoolId, copy_id = CopyId,
        x = X, y = Y, hide_type = HideType, battle_attr = BA,
        team = #status_team{team_id = TeamId}
        } = SceneUser,
    #battle_attr{
        hp = Hp, hp_resume_add = HpResumeAdd,
        hp_lim = HpLim, hp_resume_time = HpResumeTime} = BA,
    %% 通知所有玩家你进入
    %% #ets_scene{type = SceneType} = State,
    {ok, BinData} = pt_120:write(12003, SceneUser),
    if
        HideType =:= ?HIDE_TYPE_VISITOR -> lib_server_send:send_to_sid(Sid, BinData);
        %% SceneType == ?SCENE_TYPE_OUTSIDE -> lib_server_send:send_to_sid(Sid, BinData); %% 野外挂机不显示其他人
        true ->
            case lib_scene:is_broadcast_scene(SceneId) of
                true -> lib_scene_agent:send_to_local_scene(CopyId, BinData);
                false -> lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BinData)
            end
    end,
    %% 血量恢复
    HpRef = ?IF(HpResumeAdd =< 0, undefined,
                lib_battle:add_resume_timer(undefined, Hp, HpLim, RoleId,
                                            utime:longunixtime(), HpResumeTime*1000)),
    %% cd保存
    {NewSkillCd, NewSkillCdMap} = case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{scene = OSceneId, skill_cd = SCd, skill_cd_map = SkillCdMap} when 
                SceneId == OSceneId -> 
            {SCd, SkillCdMap};
        _ -> {[], #{}}
    end,
    % ?PRINT("NewSkillCd:~p SkillCdMap:~p ~n", [NewSkillCd, SkillCdMap]),
    %% 场景线路发送
    % #ets_scene{type = MType} = State,
    % if
    %     MType == ?SCENE_TYPE_OUTSIDE orelse MType == ?SCENE_MASK_NORMAL ->
    %         case is_integer(CopyId) of
    %             false -> skip;
    %             true -> MyLine = CopyId+PoolId*?MAX_ONE_ROOM+1,
    %                     lib_server_send:send_to_sid(Sid, pt_120, 12042, [MyLine])
    %         end;
    %     true ->
    %         skip
    % end,
    %% 场景玩家监控
    %% RoleMRef = if
    %%                ClsType =/= ?SCENE_CLS_TYPE_CENTER ->
    %%                    undefined;
    %%                true ->
    %%                    MonitorRef = erlang:monitor(process, RolePid),
    %%                    put(MonitorRef, RoleId),
    %%                    MonitorRef
    %%            end,
    %% 数据保存
    NewSceneUser = SceneUser#ets_scene_user{
        hp_resume_ref = HpRef,
        skill_cd = NewSkillCd, skill_cd_map = NewSkillCdMap},
    lib_scene_agent:put_user(NewSceneUser),
    %% 进入广播给怪物boss
    case lib_boss:check_need_ai_scene(SceneId) of
        false -> skip;
        true ->
            {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
            [ Aid ! {'enter', RoleId, RolePid, ?BATTLE_SIGN_PLAYER, TeamId} ||
                Aid <- lib_scene_object_agent:get_trace(CopyId, TX, TY)]
    end,
    {noreply, State};

%% 玩家离开场景
%% 校验是否离开场景,玩家最新ps和ets_scene_user一致则不离开场景
handle_cast({'vaild_leave', CopyId, X, Y, Id} , State) ->
    case lib_scene_agent:get_user(Id) of
        #ets_scene_user{x = X, y = Y, copy_id = CopyId} -> {noreply, State};
        _ -> handle_cast({'leave', CopyId, Id} , State)
    end;

%% 玩家离开场景
handle_cast({'leave', CopyId, Id}, State) ->
    leave_this(State, CopyId, Id, true);

%% 玩家原地复活
handle_cast({'revive', CopyId, Id} , State) ->
    case lib_scene_agent:get_user(Id) of
        [] -> skip;
        #ets_scene_user{pid = RolePid, scene = Scene, copy_id = CopyId, x = X, y = Y, team = #status_team{team_id = TeamId}}->
            %% 复活广播给怪物boss
            case lib_boss:check_need_ai_scene(Scene) of
                false -> skip;
                true ->
                    {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
                    [ Aid ! {'enter', Id, RolePid, ?BATTLE_SIGN_PLAYER, TeamId} ||
                        Aid <- lib_scene_object_agent:get_trace(CopyId, TX, TY)]
            end
    end,
    {noreply, State};

%% 玩家复活到指定坐标
handle_cast({'revive_to_target', CopyId, Id}, State) ->
    leave_this(State, CopyId, Id, false);

%% 玩家死亡
handle_cast({'player_die', CopyId, Id, AtterSign, AtterId}, State) ->
    User = lib_scene_agent:get_user(Id),
    AtterUser = lib_scene_agent:get_user(AtterId),
    if
        is_record(User, ets_scene_user) == false -> skip;
        true ->
            #ets_scene_user{scene = Scene, x = X, y = Y} = User,
            %% 复活广播给怪物boss
            case lib_boss:check_need_ai_scene(Scene) of
                true when AtterSign =/= ?BATTLE_SIGN_PLAYER ->
                    {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
                    [Aid ! {'player_die', Id, undefined, 0, 0, 0, 1} ||
                        Aid <- lib_scene_object_agent:get_trace(CopyId, TX, TY)];
                true when is_record(AtterUser, ets_scene_user) -> 
                    #ets_scene_user{
                        pid = Pid, node = Node, team = #status_team{team_id = TeamId}, server_num = ServerNum,
                        figure = #figure{lv = Lv, vip_type = VipType, vip = VipLv, name = Name, mask_id = MaskId}, server_id = ServerId, 
                        world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, camp_id = Camp, assist_id = AssistId,
                        battle_attr = #battle_attr{is_hurt_mon = IsHurtMon}
                        } = AtterUser,
                    MonAtter = #mon_atter{
                        id = AtterId, pid = Pid, node = Node, team_id = TeamId, camp_id = Camp,
                        att_sign = ?BATTLE_SIGN_PLAYER, att_lv = Lv, server_id = ServerId, name = Name, 
                        server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, mask_id = MaskId,
                        assist_id = AssistId
                        },
                    SceneBossTired = lib_battle_util:get_boss_tired(AtterUser),
                    {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
                    [Aid ! {'player_die', Id, MonAtter, SceneBossTired, VipType, VipLv, IsHurtMon} ||
                        Aid <- lib_scene_object_agent:get_trace(CopyId, TX, TY)];
                _ ->
                    skip
            end
    end,
    {noreply, State};

%% 发送怪物的归属
handle_cast({'send_mon_own_info', Node, Sid, MonId} , State) ->
    case lib_scene_object_agent:get_object(MonId) of
        #scene_object{aid = Aid, sign = ?BATTLE_SIGN_MON} ->
            Aid ! {'send_mon_own_info', Node, Sid};
        _ ->
            skip
    end,
    {noreply, State};

%% 给场景所有玩家发送信息
handle_cast({'send_to_scene', CopyId, Bin} , State) ->
    lib_scene_agent:send_to_local_scene(CopyId, Bin),
    {noreply, State};

%% 给场景所有玩家发送信息
handle_cast({'send_to_scene', Bin} , State) ->
    lib_scene_agent:send_to_local_scene(Bin),
    {noreply, State};

%% 给场景九宫格玩家发送信息
handle_cast({'send_to_area_scene', CopyId, X, Y, Bin} , State) ->
    lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, Bin),
    {noreply, State};

%% 给场景九宫格玩家发送信息[尽量以玩家为中心]
handle_cast({'send_to_role_area_scene', RoleId, CopyId, X, Y, Bin} , State) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{copy_id = CopyId, x = RoleX, y = RoleY} ->
            lib_scene_agent:send_to_local_area_scene(CopyId, RoleX, RoleY, Bin);
        _ ->
            lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, Bin)
    end,
    {noreply, State};

handle_cast({'send_to_scene_group', CopyId, Group, Bin}, State) ->
    lib_scene_agent:send_to_group(CopyId, Group, Bin),
    {noreply, State};

%% 加载场景
handle_cast({'load_scene', SceneUser} , State) ->
    handle_cast({'join', SceneUser} , State),
    handle_cast({'send_scene_info_to_uid', SceneUser#ets_scene_user.id, SceneUser#ets_scene_user.copy_id, SceneUser#ets_scene_user.x, SceneUser#ets_scene_user.y}, State),
    {noreply, State};

%% 把场景信息发送给玩家
handle_cast({'send_scene_info_to_uid', Id, CopyId, X, Y}, State) ->
    case lib_scene_agent:get_user(Id) of
        [] -> {noreply, State};
        User ->
            if 
                %State#ets_scene.type == ?SCENE_TYPE_OUTSIDE -> 
                %     SceneUser = [User],
                %     SceneObject = lib_scene_object_agent:get_scene_object(CopyId);
                true -> 
                    case lib_scene:is_broadcast_scene(State#ets_scene.id) of
                        true ->
                            SceneUser = lib_scene_agent:get_scene_user(CopyId),
                            SceneObject = lib_scene_object_agent:get_scene_object(CopyId);
                        false ->
                            SceneUser = lib_scene_calc:get_broadcast_user(CopyId, X, Y, State),
                            SceneObject = lib_scene_calc:get_broadcast_object(CopyId, X, Y, State)
                    end
            end,
            AreaMark = lib_scene_mark:mark_s2c(lib_scene_agent:get_area_mark(CopyId)),
            {ok, BinData} = pt_120:write(12002, [SceneUser, SceneObject, AreaMark]),
            % {ok, BinData} = pt_120:write(12002, [SceneUser, SceneObject, []]),
            lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, BinData),
            {noreply, State}
    end;

%% 派发副本事件
handle_cast({'dispatch_dungeon_event', RoleId, EventTypeId}, State) ->
    case lib_scene_agent:get_user(RoleId) of
        [] -> skip;
        User ->
            #ets_scene_user{scene = SceneId, copy_id = CopyId, x = X, y = Y, battle_attr = BattleAttr} = User,
            #battle_attr{hp = _Hp, hp_lim = _HpLim} = BattleAttr,
            if
                is_pid(CopyId) == false -> skip;
                EventTypeId == ?DUN_EVENT_TYPE_ID_ROLE_XY ->
                    mod_dungeon:dispatch_dungeon_event(CopyId, EventTypeId, #dun_callback_role_xy{scene_id = SceneId, x = X, y = Y});
                true ->
                    skip
            end
    end,
    {noreply, State};

%% 更新副本辅助信息
%% handle_cast({'update_dungeon_hp_rate', CopyId, HpRateList}, State) ->
%%     put({update_dungeon_hp_rate, CopyId}, HpRateList),
%%     {noreply, State};

%% 关闭场景
handle_cast({'close_scene'} , State) ->
    catch lib_mon:clear_scene_mon(State#ets_scene.id, State#ets_scene.pool_id, [], 0),
    {stop, normal, State};

%% 清理场景
handle_cast({'clear_scene'} , State) ->
    lib_scene_object_agent:clear_scene_object(0, [], 0),
    lib_scene_agent:clear_all_process_dict(),
    {noreply, State};

%% 统一模块+过程调用(cast)
handle_cast({'apply_cast', Module, Method, Args} , State) ->
    apply(Module, Method, Args),
    {noreply, State};

%% 统一模块+过程调用(cast)
handle_cast({'apply_cast_with_state', Module, Method, Args} , State) ->
    apply(Module, Method, Args++[State]),
    {noreply, State};

%% 定时器返回
handle_cast({'timer_call_back', TimeoutEvl}, State) ->
    lib_scene_agent:timer_call_back(TimeoutEvl, State),
    {noreply, State};

%% 更新玩家在线状态
handle_cast({'online_flag', PlayerId, Online}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{collect_pid = CollectPid, figure = Figure, scene = SceneId, copy_id = CopyId, x = X, y = Y} = User->
            if
                Online == ?ONLINE_ON -> %% 重连登录
                    NewUser = User#ets_scene_user{
                        online = ?ONLINE_ON, onhook_path = [],
                        onhook_target = undefined, collect_pid = {0, 0},
                        follow_target_xy = {0, 0}, onhook_sxy = {0, 0, 0, 0},
                        figure = Figure#figure{is_collecting = 0}
                    },
                    lib_scene_user:broadcast_user_collect(SceneId, CopyId, X, Y, PlayerId, 0),
                    case CollectPid of
                        {Aid, _} when is_pid(Aid) ->
                            mod_mon_active:collect_mon(Aid, User, ?COLLECT_CANCEL);
                        _ -> skip
                    end,
                    lib_scene_agent:put_user(NewUser);
                Online == ?ONLINE_OFF ->
                    %% 采集怪物处理
                    case CollectPid of
                        {Aid, _} when is_pid(Aid) ->
                            mod_mon_active:collect_mon(Aid, User, ?COLLECT_CANCEL),
                            NewCollectPid = {0, 0};
                        _ -> NewCollectPid = CollectPid
                    end,
                    NewUser = User#ets_scene_user{
                        online = Online, collect_pid = NewCollectPid,
                        figure = Figure#figure{is_collecting = 0},
                        onhook_path = [], onhook_target = undefined},
                    lib_scene_user:broadcast_user_collect(SceneId, CopyId, X, Y, PlayerId, 0),
                    lib_scene_agent:put_user(NewUser);
                true ->
                    NewUser = User#ets_scene_user{online = Online, onhook_path = [], onhook_target = undefined},
                    lib_scene_agent:put_user(NewUser)
            end;
        _ ->
            skip
    end,
    {noreply, State};

%% 挂机循环(离线挂机状态才能执行)
%% (1)离线挂机状态
%% (2)离线状态触发战斗
handle_cast({'go_to_onhook_place', PlayerId}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{online = Online} = User when 
                Online == ?ONLINE_OFF_ONHOOK;
                Online == ?ONLINE_OFF ->
            OOnhookRef = get({onhook_ref, PlayerId}),
            util:cancel_timer(OOnhookRef),
            OnhookRef = lib_onhook_offline:go_to_onhook_place(User, State),
            put({onhook_ref, PlayerId}, OnhookRef);
        _ ->
            skip
    end,
    {noreply, State};

%% 幻兽之域，采集扣血
handle_cast({'client_del_hp', PlayerId}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{node = Node, copy_id=CopyId, x=X, y=Y, battle_attr=BA, collect_pid = ColloectPid}=User ->
            case ColloectPid of
                {0, 0} -> skip;
                {_ClPid, _ClMonId} ->
                    #battle_attr{hp = Hp, hp_lim = HpLim} = BA,
                    NewHp = max(1, Hp - round(Hp * 0.04)),
                    {ok, BinData} = pt_120:write(12009, [PlayerId, NewHp, HpLim]),
                    lib_battle:send_to_scene(CopyId, X, Y, State#ets_scene.broadcast, BinData),
                    lib_battle:rpc_cast_to_node(Node, lib_player, update_player_info, [PlayerId, [{hp, NewHp}]]),
                    lib_scene_agent:put_user(User#ets_scene_user{battle_attr=BA#battle_attr{hp=NewHp}})
            end;
        _ -> skip
    end,
    {noreply, State};

%% 发送场景人数
handle_cast({'send_number_info', CopyId, Sid}, State) ->
    SceneUserList = lib_scene_agent:get_scene_user(CopyId),
    Num = length(SceneUserList),
    {ok, BinData} = pt_120:write(12087, [State#ets_scene.id, Num]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

%% 发送场景人物简要信息
handle_cast({'send_user_info', CopyId, Sid}, State) ->
    SceneUserList = lib_scene_agent:get_scene_user(CopyId),
    {ok, BinData} = pt_120:write(12088, [[U || U <- SceneUserList, U#ets_scene_user.sid =/= Sid]]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

%% 同步房间人数
handle_cast({'sync_scene_user_num', SceneId, PoolId, CopyId, Value}, State)->
    SceneUserList = lib_scene_agent:get_scene_user(CopyId),
    Ids = [U#ets_scene_user.id || U <- SceneUserList],
    mod_scene_line:set_scene_user_num(SceneId, PoolId, CopyId, Value, Ids),
    {noreply, State};

handle_cast({'get_outside_online_user', RoleId, CopyId, Sid}, State) -> 
    SceneUserList = lib_scene_agent:get_scene_user(CopyId),
    F = fun(#ets_scene_user{combat_power=CP1}, #ets_scene_user{combat_power=CP2}) -> 
        CP1 > CP2
    end,
    case lists:sort(F, lists:keydelete(RoleId, #ets_scene_user.id, SceneUserList)) of
        [No1, No2, No3|Left] -> 
            {ok, BinData} = pt_120:write(12089, [[No1, No2, No3], lists:sublist(Left, 7)]),
            lib_server_send:send_to_sid(Sid, BinData);
        SortList -> 
            {ok, BinData} = pt_120:write(12089, [SortList, []]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};

%% 删除玩家遗忘神庙旧数据
handle_cast({'delete_temple_scene_user', RoleId}, State) ->
    lib_scene_agent:del_user(RoleId),
    {noreply, State};

handle_cast({'add_mon_create_delay', CopyId, Time, MFA}, State) ->
    RefL = lib_scene_agent:get_mon_create_delay(CopyId),
    Ref = erlang:start_timer(Time, self(), {'add_mon_create_delay', CopyId, MFA}),
    lib_scene_agent:set_mon_create_delay(CopyId, [Ref|RefL]),
    {noreply, State};

handle_cast({'send_scene_boss_hp', SceneId, CopyId, Sid}, State) ->
    Mids = data_hp_show:get_scene_mon_ids(SceneId),
    case Mids of
        [] ->
            {ok, BinData} = pt_460:write(46040, [[]]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            SceneObjectList = lib_scene_object_agent:get_scene_mon_by_mids(CopyId, Mids, all),
            SendList = [{MonId, AutoId, Hp, HpLim}|| 
                #scene_object{
                    id = AutoId, 
                    battle_attr = #battle_attr{hp=Hp, hp_lim=HpLim},
                    mon = #scene_mon{mid = MonId}
                } <- SceneObjectList],
            {ok, BinData} = pt_460:write(46040, [SendList]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};
    
%% 场景特效改变
handle_cast({'send_dynamic_eff', Scene, CopyId, Sid, Node}, State) ->
    EffValues = lib_scene_agent:get_dynamic_eff(CopyId),
    {ok, BinData} = pt_120:write(12032, [Scene, EffValues]),
    lib_server_send:send_to_sid(Node, Sid, BinData),
    {noreply, State};

%% 查询对象的buff列表
handle_cast({'send_object_buff_list', Node, RoleId, IdList}, State) ->
    NowTime = utime:longunixtime(),
    F = fun(Id, List) ->
        case lib_scene_object_agent:get_object(Id) of
            #scene_object{battle_attr = #battle_attr{other_buff_list=OtherBuffList}} ->
                AerBuffList = lib_skill_buff:pack_buff(OtherBuffList, NowTime, []),
                [{Id, AerBuffList}|List];
            _ ->
                List
        end
    end,
    List = lists:foldl(F, [], IdList),
    {ok, BinData} = pt_120:write(12092, [List]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

%% 更新场景数据
handle_cast({'update_scene', AttrList}, State) ->
    NewState = lib_scene_agent:update_scene(AttrList, State),
    {noreply, NewState};

%% 玩家进入场景的辅助信息(目前只用到共享技能，如果后续有其他字段，那么 update_skill_passive_share 要相应修改，增加多一个协议专门处理共享技能)
handle_cast({'send_role_assist_info', Node, RoleId, MyShareSkillL}, State) ->
    case lib_scene_agent:get_user(RoleId) of
        [] -> skip;
        #ets_scene_user{skill_passive_share = SkillPassivShare} = User ->
            ShareSkillL = ?IF(lib_scene_user:is_ban_passive_skill(User), [], MyShareSkillL++SkillPassivShare),
            % ?PRINT("send_role_assist_info ShareSkillL:~p ~n", [ShareSkillL]),
            {ok, BinData} = pt_120:write(12093, [ShareSkillL]),
            lib_server_send:send_to_uid(Node, RoleId, BinData)
    end,
    {noreply, State};

%% 更新共享被动技能
handle_cast({'update_skill_passive_share', Node, RoleId, MyShareSkillL, SceneShareSkillL}, State) ->
    {noreply, NewState} = handle_cast({'update', RoleId, [{skill_passive_share, SceneShareSkillL}]}, State),
    {noreply, NewState2} = handle_cast({'send_role_assist_info', Node, RoleId, MyShareSkillL}, NewState),
    {noreply, NewState2};

%% 默认匹配
handle_cast(Event, Status) ->
    catch ?ERR("mod_scene_agent_cast:handle_cast not match: ~p", [Event]),
    {noreply, Status}.


%% 离开
%% @param IsLeaveScene 是否离开场景
%%  true:离开
%%  false:只是离开当前九宫格,重新切换场景
leave_this(State, CopyId, Id, IsLeaveScene) ->
    case lib_scene_agent:get_user(Id) of
        [] ->
            {noreply, State};
        #ets_scene_user{
                node = Node, pid = RolePid, scene = Scene,
                server_id = ServerId, scene_pool_id = ScenePoolId,
                x = X, y = Y, copy_id = OCopyId, collect_pid = CollectPid,
                bl_who_list = BlWhoL, figure = #figure{name = RoleName}} = SceneUser ->
            {ok, BinData} = pt_120:write(12004, Id),
            % #ets_scene{type = SceneType} = State,
            if 
                % SceneType == ?SCENE_TYPE_OUTSIDE -> lib_server_send:send_to_sid(Sid, BinData);
                true -> 
                    case lib_scene:is_broadcast_scene(Scene) of
                        true -> lib_scene_agent:send_to_local_scene(CopyId, BinData);
                        false -> lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BinData)
                    end
            end,
            lib_battle:interrupt_collect_force(SceneUser),
            % 是否离开场景
            case IsLeaveScene of
                true ->
                    % 清理对象,删除
                    lib_scene_agent:del_user(Id),
                    mod_scene_line:reduce_user_num(Id, Scene, ScenePoolId, OCopyId, -1);
                false ->
                    skip
            end,
            lib_battle:remove_resume_timer(Id),
            %% 离开场景广播给怪物boss和沧海遗珠的采集怪物处理
            case lib_boss:check_need_ai_scene(Scene) orelse
                lib_treasure_chest:is_act_scene(Scene) of
                false ->
                    case CollectPid of
                        {Aid, _} when is_pid(Aid) ->
                            Aid ! {'stop_collect', Id, Node, 0};
                        _ ->
                            ok
                    end;
                true ->
                    {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
                    AidL = lib_scene_object_agent:get_trace(OCopyId, TX, TY),
                    % 九宫格
                    [ Aid ! {'leave', Id, RolePid, ?BATTLE_SIGN_PLAYER} || Aid <- AidL],
                    % 玩家离开九宫格没有及时清理归属
                    F = fun(ObjectId) ->
                        case lib_scene_object_agent:get_object(ObjectId) of
                            #scene_object{aid = Aid} ->
                                case lists:member(Aid, AidL) of
                                    true -> skip;
                                    false -> Aid ! {'leave', Id, RolePid, ?BATTLE_SIGN_PLAYER}
                                end;
                            _ ->
                                skip
                        end
                    end,
                    lists:foreach(F, BlWhoL),
                    case CollectPid of
                        {Aid, _} when is_pid(Aid) ->
                            mod_mon_active:collect_mon(Aid, SceneUser, ?COLLECT_CANCEL);
                        _ ->
                            ok
                    end
            end,
            %% 去掉监控
            %% case erlang:is_reference(ClsMonitorRef) of
            %%     true  ->
            %%         erase(ClsMonitorRef),
            %%         erlang:demonitor(ClsMonitorRef);
            %%     false -> skip
            %% end,
            {noreply, State}
    end.