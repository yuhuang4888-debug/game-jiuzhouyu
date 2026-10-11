%%-----------------------------------------------------------------------------
%% @Module  :       lib_void_fam
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-14
%% @Description:    虚空秘境
%%-----------------------------------------------------------------------------
-module(lib_void_fam).

-include("void_fam.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("activitycalen.hrl").
-include("errcode.hrl").
-include("common.hrl").

-export([
    get_role_map/0
    , save_role_map/1
    , get_achieve_floor_map/0
    , save_achieve_floor_map/1
    , get_room_map/0
    , save_room_map/1
    , get_act_cls_type/0
    , act_close/1
    , send_to_uid/3
    , is_in_void_fam/1
    , sel_room_id/1
    , count_scene_pool_id/1
    , update_role_hp/3
    , kill_player/5
    , kill_mon/4
    , is_pass/1
    , give_floor_reward/5
    , pass_all_floor/3
    , get_scene_born_xy/1
    , init_act/0
    , act_start/1
    , act_start_by_time/1
    , sync_data/2
    , request_sync_data/2
    , add_log/4
    , enter_room/2
    , exit_room/2
    ]).

get_role_map() ->
    case get(?P_ROLE_MAP) of
        undefined -> #{};
        Val -> Val
    end.

save_role_map(RoleMap) ->
    put(?P_ROLE_MAP, RoleMap).

get_achieve_floor_map() ->
    case get(?P_ACHIEVE_FLOOR_RECORD_MAP) of
        undefined -> #{};
        Val -> Val
    end.

save_achieve_floor_map(AchieveFloorMap) ->
    put(?P_ACHIEVE_FLOOR_RECORD_MAP, AchieveFloorMap).

get_room_map() ->
    case get(?P_ROOM_MAP) of
        undefined ->
            % ?ERR("get_room_map:~p", [#{}]),
            #{};
        Val ->
            % ?ERR("get_room_map:~p", [Val]),
            Val
    end.

save_room_map(RoomMap) ->
    % ?ERR("save_room_map:~p", [RoomMap]),
    put(?P_ROOM_MAP, RoomMap).

init_act() ->
    IsCls = util:is_cls(),
    case IsCls of
        false ->
            case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_VOID_FAM, 0) of
                {ok, ActId} ->
                    act_start(ActId);
                _ ->
                    #status_void_fam{}
            end;
        _ -> #status_void_fam{} %% 跨服中心不检查
    end.

act_start(ActId) ->
    Act = data_activitycalen:get_ac(?MOD_VOID_FAM, 0, ActId),
    #base_ac{time_region = TimeRegion} = Act,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    Now = NowH * 60 + NowM,
    ZeroAclock = utime:unixdate(),
    case ulists:find(fun
        ({{SH, SM}, {EH, EM}}) ->
            SH * 60 + SM =< Now andalso Now =< EH * 60 + EM
    end, TimeRegion) of
        {ok, {{_SH, _SM}, {EH, EM}}} ->
            Etime = ZeroAclock + EH * 3600 + EM * 60,
            IsCls = util:is_cls(),
            case IsCls of
                true -> %% 在跨服中心检测到开启要通知各个服务器开启活动
                    Args = [{?SYNC_TYPE_ACT_STATUS, ?ACT_STATUS_OPEN, Etime}],
                    mod_clusters_center:apply_to_all_node(mod_void_fam_local, sync_data, [Args]),
                    NowTime = utime:unixtime(),
                    EndDelay = max(Etime - NowTime, 1),
                    Ref = erlang:send_after(EndDelay * 1000, self(), {'act_end'}),
                    %% 删除进程字典数据
                    erase(?P_ROLE_MAP),
                    erase(?P_ACHIEVE_FLOOR_RECORD_MAP),
                    erase(?P_ROOM_MAP),
                    #status_void_fam{
                        status = ?ACT_STATUS_OPEN,
                        etime = Etime,
                        ref = Ref
                    };
                false ->
                    ActClsType = lib_void_fam:get_act_cls_type(),
                    case ActClsType of
                        ?ACT_TYPE_BF ->
                            act_start_by_time(Etime);
                        _ ->
                            #status_void_fam{}
                    end
            end;
        _ ->
            #status_void_fam{}
    end.

act_start_by_time(Etime) ->
    ActClsType = lib_void_fam:get_act_cls_type(),
    case ActClsType of
        ?ACT_TYPE_BF ->
            NowTime = utime:unixtime(),
            EndDelay = max(Etime - NowTime, 1),
            Ref = erlang:send_after(EndDelay * 1000, self(), {'act_end'});
        _ ->
            Ref = []
    end,

    NeedRoleLv = data_void_fam:get_cfg(need_role_lv),
    spawn(fun() ->
        lists:foreach(fun(_) ->
            lib_chat:send_TV({all}, ?MOD_VOID_FAM, 1, [NeedRoleLv]),
            timer:sleep(20)
        end, [1, 2])
    end),

    broadcast_act_info(NeedRoleLv, ?ACT_STATUS_OPEN, Etime),

    %% 通知活动日历
    lib_activitycalen_api:success_start_activity(?MOD_VOID_FAM),

    %% 删除进程字典数据
    erase(?P_ROLE_MAP),
    erase(?P_ACHIEVE_FLOOR_RECORD_MAP),
    erase(?P_ROOM_MAP),
    #status_void_fam{
        status = ?ACT_STATUS_OPEN,
        cls_type = ActClsType,
        etime = Etime,
        ref = Ref
    }.

%% 本服请求跨服中心同步数据
request_sync_data([], State) -> State;
request_sync_data([{?SYNC_TYPE_ACT_STATUS, Node}|L], State) ->
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    Args = [{?SYNC_TYPE_ACT_STATUS, ActStatus, Etime}],
    mod_clusters_center:apply_cast(Node, mod_void_fam_local, sync_data, [Args]),
    request_sync_data(L, State);
request_sync_data([_|L], State) ->
    request_sync_data(L, State).

%% 跨服中心同步数据到本服
sync_data([], State) -> State;
sync_data([{?SYNC_TYPE_ACT_STATUS, ?ACT_STATUS_OPEN, Etime}|L], _State) ->
    NewState = act_start_by_time(Etime),
    sync_data(L, NewState);
sync_data([{?SYNC_TYPE_ACT_STATUS, ?ACT_STATUS_CLOSE, _Etime}|L], State) ->
    NewState = act_close(State),
    sync_data(L, NewState);
sync_data([_|L], State) ->
    sync_data(L, State).

%% 判断活动是本服的还是跨服的
get_act_cls_type() ->
    NeedDay = data_void_fam:get_cfg(kf_act_min_opday),
    Opday = util:get_open_day(),
    case Opday >= NeedDay of
        true -> ?ACT_TYPE_KF;
        false -> ?ACT_TYPE_BF
    end.

%% 活动结束
act_close(State) ->
    #status_void_fam{status = ActStatus, ref = ORef} = State,
    case ActStatus == ?ACT_STATUS_OPEN of
        true ->
            util:cancel_timer(ORef),

            lib_chat:send_TV({all}, ?MOD_VOID_FAM, 2, []),
            lib_activitycalen_api:success_end_activity(?MOD_VOID_FAM),

            RoleMap = get_role_map(),
            RoleList = maps:values(RoleMap),
            F = fun(RoleInfo) ->
                case RoleInfo of
                    #role_info{
                        role_id = RoleId,
                        scene = Scene,
                        ref = Ref,
                        floor = Floor,
                        score = Score
                    } when Scene > 0 ->
                        util:cancel_timer(Ref),
                        %% 日志
                        QuitType = case lib_void_fam:is_pass(RoleInfo) of
                            true -> 3;
                            _ -> 4
                        end,
                        lib_void_fam:add_log(RoleId, QuitType, Floor, Score),
                        lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]);
                    _ -> skip
                end
            end,
            lists:foreach(F, RoleList),

            NeedRoleLv = data_void_fam:get_cfg(need_role_lv),
            broadcast_act_info(NeedRoleLv, ?ACT_STATUS_CLOSE, 0),

            %% 删除进程字典数据
            erase(?P_ROLE_MAP),
            erase(?P_ACHIEVE_FLOOR_RECORD_MAP),
            erase(?P_ROOM_MAP),

            #status_void_fam{status = ?ACT_STATUS_CLOSE};
        false -> State
    end.

%% 跨服中心给玩家发协议
send_to_uid(Node, RoleId, BinData) when BinData =/= [] ->
    case Node =:= none of
        true ->
            lib_server_send:send_to_uid(RoleId, BinData);
        false ->
            lib_clusters_center:send_to_uid(Node, RoleId, BinData)
    end;
send_to_uid(_Node, _RoleId, _Bin) -> skip.

%% 检测玩家是否在虚空秘境
is_in_void_fam(Scene) ->
    SceneIds = data_void_fam:get_scene(),
    KFSceneIds = data_void_fam:get_kf_scene(),
    case lists:member(Scene, SceneIds) of
        false ->
            lists:member(Scene, KFSceneIds);
        true -> true
    end.

-define(ONE_ROOM_PERSON_NUM_LIM, 30).
sel_room_id([]) -> false;
sel_room_id([{RoomId, PersonNum}|L]) ->
    case PersonNum < ?ONE_ROOM_PERSON_NUM_LIM of
        true ->
            {RoomId, PersonNum + 1};
        _ ->
            sel_room_id(L)
    end.

count_scene_pool_id(RoomId) ->
    RoomId div 15.

update_role_hp(RoleId, Scene, Hp) ->
    RoleMap = lib_void_fam:get_role_map(),
    NewRoleMap = case maps:get(RoleId, RoleMap, false) of
        #role_info{scene = Scene} = RoleInfo ->
            maps:put(RoleId, RoleInfo#role_info{hp = Hp}, RoleMap);
        _ -> RoleMap
    end,
    lib_void_fam:save_role_map(NewRoleMap).

kill_player(AttackerId, AttackerName, DefenderId, DefenderName, DefenderScene) ->
    RoleMap = get_role_map(),
    case maps:get(DefenderId, RoleMap, false) of
        #role_info{
            scene = DefenderScene,
            die_num = DefenderDieNum
        } = DRoleInfo when DefenderScene > 0 ->
            NewDRoleInfo = DRoleInfo#role_info{combo = 0, die_num = DefenderDieNum + 1, hp = 0},
            NewRoleMapTmp = maps:put(DefenderId, NewDRoleInfo, RoleMap);
        _ -> DRoleInfo = false, NewRoleMapTmp = RoleMap
    end,
    case maps:get(AttackerId, NewRoleMapTmp, false) of
        #role_info{
            node = AttackerNode,
            scene = AttackerScene,
            score = Score,
            combo = AttackerCombo
        } = ARoleInfo when AttackerScene > 0 andalso AttackerScene == DefenderScene ->
            %% 触发成就
            case util:is_cls() of
                true ->
                    mod_clusters_center:apply_cast(AttackerNode, lib_achievement_api, async_event, [AttackerId, lib_achievement_api, void_fam_kill_event, []]);
                false ->
                    lib_achievement_api:async_event(AttackerId, lib_achievement_api, void_fam_kill_event, [])
            end,
            ScorePlus = data_void_fam:get_cfg(kill_player_score),
            %% 已经通关了积分不变
            case is_pass(ARoleInfo) of
                false ->
                    NewScore = Score + ScorePlus,
                    UpdateScore = true;
                _ ->
                    NewScore = Score,
                    UpdateScore = false
            end,
            NewARoleInfo = ARoleInfo#role_info{combo = AttackerCombo + 1, score = NewScore},
            NewRoleMap = maps:put(AttackerId, NewARoleInfo, NewRoleMapTmp);
        _ -> UpdateScore = false, NewARoleInfo = false, NewRoleMap = NewRoleMapTmp
    end,
    save_role_map(NewRoleMap),
    send_battle_tv(NewARoleInfo, AttackerName, DRoleInfo, DefenderName),
    case UpdateScore of
        true ->
            score_plus(AttackerId, AttackerName);
        _ -> skip
    end.

kill_mon(AttackerId, AttackerName, _MonId, BattleSceneId) ->
    RoleMap = get_role_map(),
    case maps:get(AttackerId, RoleMap, false) of
        #role_info{
            scene = Scene,
            score = Score
        } = ARoleInfo when Scene > 0 andalso Scene == BattleSceneId ->
            case is_pass(ARoleInfo) of
                false ->
                    ScorePlus = data_void_fam:get_cfg(kill_mon_score),
                    NewARoleInfo = ARoleInfo#role_info{score = Score + ScorePlus},
                    NewRoleMap = maps:put(AttackerId, NewARoleInfo, RoleMap),
                    save_role_map(NewRoleMap),
                    score_plus(AttackerId, AttackerName);
                true -> skip
            end;
        _ -> skip
    end.

%% 玩家积分增加
score_plus(RoleId, RoleName) ->
    RoleMap = get_role_map(),
    case maps:get(RoleId, RoleMap, false) of
        #role_info{
            node = Node,
            score = Score,
            floor = Floor
        } = RoleInfo ->
            case data_void_fam:get_floor_cfg(Floor) of
                #void_fam_floor_cfg{score = NeedScore} = FloorCfg ->
                    %% 通知客户端更新积分
                    {ok, BinData} = pt_600:write(60005, [min(Score, NeedScore)]),
                    send_to_uid(Node, RoleId, BinData),
                    case Score >= NeedScore of
                        true ->
                            pass_floor(RoleInfo, RoleName, FloorCfg, RoleMap);
                        false -> skip
                    end;
                _ -> skip
            end;
        _ -> skip
    end.

enter_room(Floor, SceneId) ->
    RoomMap = lib_void_fam:get_room_map(),
    #room_info{
        max_room_id = MaxRoomId,
        room_list = RoomList
    } = RoomInfo = maps:get(Floor, RoomMap, #room_info{}),
    SortRoomList = lists:keysort(2, RoomList),
    case lib_void_fam:sel_room_id(SortRoomList) of
        false ->
            SelRoomId = MaxRoomId,
            NewMaxRoomId = MaxRoomId + 1,
            NewRoomList = [{MaxRoomId, 1}|RoomList],
            PoolId = count_scene_pool_id(SelRoomId),
            init_scene_mon(SceneId, PoolId, SelRoomId);
        {SelRoomId, NewRoomPersonNum} ->
            NewMaxRoomId = MaxRoomId,
            NewRoomList = lists:keystore(SelRoomId, 1, SortRoomList, {SelRoomId, NewRoomPersonNum})
    end,
    NewRoomInfo = RoomInfo#room_info{max_room_id = NewMaxRoomId, room_list = NewRoomList},
    NewRoomMap = maps:put(Floor, NewRoomInfo, RoomMap),
    lib_void_fam:save_room_map(NewRoomMap),
    {ok, SelRoomId}.

exit_room(Floor, RoomId) ->
    RoomMap = lib_void_fam:get_room_map(),
    case maps:get(Floor, RoomMap, false) of
        #room_info{
            room_list = RoomList
        } = RoomInfo ->
            case lists:keyfind(RoomId, 1, RoomList) of
                {RoomId, RoomPersonNum} when RoomPersonNum > 0 ->
                    NewRoomList = lists:keystore(RoomId, 1, RoomList, {RoomId, RoomPersonNum - 1});
                _ ->
                    NewRoomList = RoomList
            end,
            NewRoomInfo = RoomInfo#room_info{room_list = NewRoomList},
            NewRoomMap = maps:put(Floor, NewRoomInfo, RoomMap);
        _ -> NewRoomMap = RoomMap
    end,
    lib_void_fam:save_room_map(NewRoomMap).

%% 通关楼层
pass_floor(RoleInfo, RoleName, FloorCfg, RoleMap) ->
    #role_info{node = Node, ser_id = SerId, role_id = RoleId, floor = Floor, scene = Scene, room_id = RoomId} = RoleInfo,
    #void_fam_floor_cfg{reward = PassFloorReward} = FloorCfg,
    IsClsScene = lib_scene:is_clusters_scene(Scene),
    [MaxFloor|_] = data_void_fam:get_all_floor(),
    case Floor < MaxFloor of
        true ->
            NextFloor = Floor + 1,
            case data_void_fam:get_floor_cfg(NextFloor) of
                #void_fam_floor_cfg{scene = NextFloorScene, kf_scene = NextFloorKFScene} ->
                    RealNextScene = ?IF(IsClsScene == true, NextFloorKFScene, NextFloorScene),

                    exit_room(Floor, RoomId),
                    {ok, SelRoomId} = enter_room(NextFloor, RealNextScene),

                    NewRoleInfo = RoleInfo#role_info{floor = NextFloor, score = 0, scene = RealNextScene, room_id = SelRoomId},
                    NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                    save_role_map(NewRoleMap),

                    achieve_floor(SerId, RoleId, RoleName, NextFloor, MaxFloor),
                    case IsClsScene of
                        true ->
                            Args = [RoleId, NextFloor, RealNextScene, SelRoomId, PassFloorReward],
                            mod_clusters_center:apply_cast(Node, lib_void_fam, give_floor_reward, Args);
                        false ->
                            lib_void_fam:give_floor_reward(RoleId, NextFloor, RealNextScene, SelRoomId, PassFloorReward)
                    end;
                _ -> skip
            end;
        false -> %% 通关了, 延迟10s把玩家传送出去
            case IsClsScene of
                true ->
                    Args = [RoleId, MaxFloor, PassFloorReward],
                    mod_clusters_center:apply_cast(Node, lib_void_fam, pass_all_floor, Args);
                false ->
                    lib_void_fam:pass_all_floor(RoleId, MaxFloor, PassFloorReward)
            end
            % CountDownTime = data_void_fam:get_cfg(pass_exit_count_down),
            % Ref = erlang:send_after(CountDownTime * 1000, self(), {'pass_exit_scene', RoleId}),
            % NewRoleInfo = RoleInfo#role_info{ref = Ref},
            % NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
            % save_role_map(NewRoleMap)
    end.

achieve_floor(SerId, RoleId, RoleName, AchieveFloor, MaxFloor) ->
    send_floor_tv(SerId, RoleId, RoleName, AchieveFloor, MaxFloor),
    %% 增加到达本层的玩家数量
    AchieveFloorMap = get_achieve_floor_map(),
    HasAchieveNum = maps:get(AchieveFloor, AchieveFloorMap, 0),
    NewAchieveFloorMap = maps:put(AchieveFloor, HasAchieveNum + 1, AchieveFloorMap),
    save_achieve_floor_map(NewAchieveFloorMap).

%% 通关楼层
give_floor_reward(RoleId, NextFloor, NextFloorScene, SelRoomId, Reward) ->
    %% 发本层奖励给玩家
    case Reward =/= [] of
        true ->
            Produce = #produce{title = utext:get(6000001), content = utext:get(204), reward = Reward, type = void_fam, show_tips = 1, remark = lists:concat(["floor_reward:", NextFloor - 1])},
            lib_goods_api:send_reward_with_mail(RoleId, Produce);
        false -> skip
    end,
    [MaxFloor|_] = data_void_fam:get_all_floor(),
    case NextFloor == MaxFloor of
        true -> %% 达到最高楼层，发通关奖励给玩家
            give_pass_reward(RoleId, MaxFloor);
        false -> skip
    end,
    case NextFloorScene > 0 of
        true ->
            %% 推送到达新楼层协议
            lib_server_send:send_to_uid(RoleId, pt_600, 60007, []),
            %% 进入下层场景
            {X, Y} = get_scene_born_xy(NextFloorScene),
            ScenePoolId = count_scene_pool_id(SelRoomId),
            lib_scene:player_change_scene(RoleId, NextFloorScene, ScenePoolId, SelRoomId, X, Y, false, []);
        false -> skip
    end.

give_pass_reward(RoleId, MaxFloor) ->
    AchieveFloorMap = get_achieve_floor_map(),
    AchieveNum = maps:get(MaxFloor, AchieveFloorMap, 0),
    SpecialPassNoList = data_void_fam:get_cfg(special_pass_no),
    IsSpecialPassNo = lists:member(AchieveNum, SpecialPassNoList),
    case AchieveNum >= 1 andalso AchieveNum =< 3 of
        true ->
            PassReward = data_void_fam:get_pass_reward(AchieveNum);
        _ ->
            case IsSpecialPassNo == true of
                true ->
                    PassReward = data_void_fam:get_pass_reward(4);
                false -> PassReward = []
            end
    end,
    case PassReward =/= [] of
        true ->
            Produce = #produce{title = utext:get(6000001), content = utext:get(204), reward = PassReward, type = void_fam, show_tips = 1, remark = lists:concat(["pass_ranking:", AchieveNum])},
            lib_goods_api:send_reward_with_mail(RoleId, Produce);
        false -> skip
    end.

%% 发送通关奖励
pass_all_floor(RoleId, MaxFloor, PassFloorReward) ->
    case PassFloorReward =/= [] of
        true ->
            Produce = #produce{title = utext:get(6000001), content = utext:get(204), reward = PassFloorReward, type = void_fam, show_tips = 1, remark = lists:concat(["floor_reward:", MaxFloor])},
            lib_goods_api:send_reward_with_mail(RoleId, Produce);
        false -> skip
    end,
    %% 更新离开场景标示符
    lib_player:update_player_info(RoleId, [{leave_scene_sign, 1}]),
    lib_player:update_player_scene_info(RoleId, [{leave_scene_sign, 1}]),
    NowTime = utime:unixtime(),
    CountDownTime = data_void_fam:get_cfg(pass_exit_count_down),
    {ok, BinData} = pt_600:write(60006, [NowTime + CountDownTime]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 是否已经通关
is_pass(RoleInfo) ->
    case RoleInfo of
        #role_info{
            score = Score,
            floor = Floor
        } ->
            [MaxFloor|_] = data_void_fam:get_all_floor(),
            #void_fam_floor_cfg{score = MaxFloorScore} = data_void_fam:get_floor_cfg(MaxFloor),
            Floor == MaxFloor andalso Score >= MaxFloorScore;
        _ -> false
    end.

%% 发送到达特殊层数的传闻
send_floor_tv(SerId, RoleId, RoleName, AchieveFloor, MaxFloor) ->
    case AchieveFloor == MaxFloor of
        true ->
            AchieveFloorMap = get_achieve_floor_map(),
            HasAchieveNum = maps:get(AchieveFloor, AchieveFloorMap, 0),
            CurAchieveNum = HasAchieveNum + 1,
            SpecialPassNoList = data_void_fam:get_cfg(special_pass_no),
            IsSpecialPassNo = lists:member(CurAchieveNum, SpecialPassNoList),
            case CurAchieveNum of
                1 ->
                    BinData = lib_chat:make_tv(?MOD_VOID_FAM, 7, [RoleName, RoleId, SerId]);
                2 ->
                    BinData = lib_chat:make_tv(?MOD_VOID_FAM, 8, [RoleName, RoleId, SerId]);
                3 ->
                    BinData = lib_chat:make_tv(?MOD_VOID_FAM, 9, [RoleName, RoleId, SerId]);
                _ ->
                    case IsSpecialPassNo == true of
                        true ->
                            BinData = lib_chat:make_tv(?MOD_VOID_FAM, 10, [RoleName, RoleId, SerId, CurAchieveNum]);
                        false -> BinData = []
                    end
            end,
            case BinData =/= [] of
                true ->
                    RoleMap = get_role_map(),
                    AllRoleInfo = maps:values(RoleMap),
                    F = fun(T) ->
                        case T of
                            #role_info{node = TmpNode, role_id = TmpRoleId, scene = TmpScene} when TmpScene > 0 ->
                                send_to_uid(TmpNode, TmpRoleId, BinData);
                            _ -> skip
                        end
                    end,
                    spawn(fun() ->lists:foreach(F, AllRoleInfo) end);
                false -> skip
            end;
        false -> %% 最高层才需要发传闻
            skip
    end.

%% 发送战斗传闻(只有攻击者和防守者都是有效时才发传闻)
send_battle_tv(NewARoleInfo, AttackerName, OldDRoleInfo, DefenderName)
    when is_record(NewARoleInfo, role_info) andalso is_record(OldDRoleInfo, role_info) ->
    #role_info{ser_id = AttackerSerId, role_id = AttackerId, combo = AttackerCombo} = NewARoleInfo,
    #role_info{ser_id = DefenderSerId, role_id = DefenderId, combo = DefenderCombo} = OldDRoleInfo,
    if
        DefenderCombo >= 10 andalso DefenderCombo < 20 ->
            BreakComboBin = lib_chat:make_tv(?MOD_VOID_FAM, 5, [AttackerName, AttackerId, AttackerSerId, DefenderName, DefenderId, DefenderSerId]);
        DefenderCombo >= 20 ->
            BreakComboBin = lib_chat:make_tv(?MOD_VOID_FAM, 6, [AttackerName, AttackerId, AttackerSerId, DefenderName, DefenderId, DefenderSerId]);
        true ->
            BreakComboBin = []
    end,
    if
        AttackerCombo == 10 ->
            AttackerComboBin = lib_chat:make_tv(?MOD_VOID_FAM, 3, [AttackerName, AttackerId, AttackerSerId]);
        AttackerCombo == 20 ->
            AttackerComboBin = lib_chat:make_tv(?MOD_VOID_FAM, 4, [AttackerName, AttackerId, AttackerSerId]);
        true ->
            AttackerComboBin = []
    end,
    case AttackerComboBin =/= [] orelse DefenderCombo =/= [] of
        true ->
            RoleMap = get_role_map(),
            AllRoleInfo = maps:values(RoleMap),
            F = fun(T) ->
                case T of
                    #role_info{node = TmpNode, role_id = TmpRoleId, scene = TmpScene} when TmpScene > 0 ->
                        send_to_uid(TmpNode, TmpRoleId, BreakComboBin),
                        send_to_uid(TmpNode, TmpRoleId, AttackerComboBin);
                    _ -> skip
                end
            end,
            spawn(fun() -> lists:foreach(F, AllRoleInfo) end);
        false -> skip
    end;
send_battle_tv(_, _, _, _) -> skip.

%% 获取场景出生点
get_scene_born_xy(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{reborn_xys = RebornXYs} when RebornXYs /= [] andalso is_list(RebornXYs) ->
            Len = length(RebornXYs),
            lists:nth(urand:rand(1, Len), RebornXYs);
        _ -> {0, 0}
    end.

init_scene_mon(SceneId, PoolId, CopyId) ->
    %% 初始化场景怪物的时候先删除旧的
    lib_mon:clear_scene_mon(SceneId, PoolId, CopyId, 0),
    #ets_scene{mon = Mon} = Scene = data_scene:get(SceneId),
    do_init_scene_mon(Mon, Scene, PoolId, CopyId, 1).

do_init_scene_mon([[MonId, X, Y, _Type, _Group] | T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast) ->
    case data_mon:get(MonId) of
        #mon{type = Type} ->
            lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, Type, CopyId, Broadcast, []);
        _ -> skip
    end,
    do_init_scene_mon(T, Scene, PoolId, CopyId, Broadcast);
do_init_scene_mon([H|T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast) ->
    ?ERR("scene mon format error scene_id = ~p mon = ~p~n", [SceneId, H]),
    do_init_scene_mon(T, Scene, PoolId, CopyId, Broadcast);
do_init_scene_mon([], _, _, _, _) -> ok.

%%--------------------------------------------------
%% 添加虚空秘境日志
%% @param  RoleId 玩家id
%% @param  Type   1: 进入场景 2: 主动退出场景 3: 通关退出场景 4: 活动结束被踢出场景
%% @param  Floor  当时的楼层数
%% @param  Score  当时的积分
%% @return        description
%%--------------------------------------------------
add_log(RoleId, Type, Floor, Score) ->
    lib_log_api:log_void_fam(RoleId, Type, Floor, Score).

broadcast_act_info(OpenLv, ActStatus, Etime) ->
    {ok, BinData} = pt_600:write(60001, [ActStatus, Etime, 0]),
    lib_server_send:send_to_all(all_lv, {OpenLv, 99999999}, BinData).

