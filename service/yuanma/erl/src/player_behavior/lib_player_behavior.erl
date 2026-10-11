%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior).

%% API
-export([
     relogin/1
    , online_start/2
    , online_end/1
    , start/2
    , start_in_fake_client/1
    , start_behavior/1
    , start_behavior_no_check/1
    , suspend_behavior/2
    , stop_behavior/1
    , tick_behavior/1
    , behavior_msg/2
    , behavior_msg/3
]).

-export([
    player_die/1,
    try_revive/2,
    player_revive/1
]).

-export([
    get_collect_att/1,
    remove_collect_att/1,
    get_drop_att/2,
    remove_drop_att/1,
    start_collect/4,
    start_pick_drop/4,
    get_walk_path/2,
    start_walk/3
]).

-export([
      is_in_fake_client/1
    , is_in_behavior/1
    , get_battle_obj_map/1
    , get_collect_map/1
    , set_collect_map/2
    , get_drop_map/1
    , set_drop_map/2
]).

%% API
-export([
      collect_mon_result/2
    , interrupt_collect_mon/1
    , pick_up_result/5
]).

%% GM
-export([
      gm_start/2
    , gm_tick/1
    , gm_end/1
    , gm_go_to_onhook/3
    , gm_many_onhook/0
    , test_times_set/1
    , test_times_add/1
    , test_times_add/2
]).

-include("predefine.hrl").
-include("common.hrl").
-include("server.hrl").
-include("player_behavior.hrl").
-include("scene_object_btree.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("team.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("errcode.hrl").
-include("activity_onhook.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("fake_client.hrl").
-include("rec_onhook.hrl").
-include("game.hrl").
-include("login.hrl").

-define(BEHAVIOR_KEY, '$behavior_player').
-define(BEHAVIOR_TICK_TIME, 150).

%% ==========================================
%% 重连
relogin(PS) ->
    IsInDungeon = lib_scene:is_dungeon_scene(PS#player_status.scene),
    InInBehavior = is_in_behavior(PS),
    case IsInDungeon andalso InInBehavior of
        true ->
            #player_status{sid = Sid, pid = Pid} = PS,
            ObserverPid = spawn(fun() -> lib_player_behavior_send:send_msg(Pid) end ),
            Sid ! {observer_pid, ObserverPid},
            PS;
        _ ->
            stop_behavior(PS)
    end.

%% ==========================================
%% 开始在线托管#由于客户端性能卡顿问题，某些功能需要服务端进行托管战斗
online_start(PS, _Type) ->
    #player_status{sid = Sid, pid = Pid} = PS,
    ObserverPid = spawn(fun() -> lib_player_behavior_send:send_msg(Pid) end ),
    Sid ! {observer_pid, ObserverPid},
    PlayerBehavior = init_player_behavior(PS, onhook),
    NewPS = PS#player_status{behavior_status = PlayerBehavior},
    {ok, LastPS} = pp_scene:handle(12002, NewPS, server),
    pp_player:handle(13017, LastPS, []),
    LastPS.
%% ==========================================
%% 结束在线托管#由于客户端性能卡顿问题，某些功能需要服务端进行托管战斗
online_end(PS) ->
    #player_status{sid = Sid} = PS,
    Sid ! {observer_pid, none},
    StopPS = stop_behavior(PS),
    pp_player:handle(13017, StopPS, []),
    StopPS.


%% ==========================================
%% 开始一个行为
start(RoleId, BTreeId) when is_integer(RoleId) ->
    Sql = io_lib:format("select accid, accname, accname_sdk, last_login_ip from player_login where id=~p ", [RoleId]),
    case db:get_row(Sql) of
        [AccId, AccName, AccNameSDK, Ip] ->
            % case catch mod_server:start([RoleId, Ip, behavior_tree, AccId, AccName, AccNameSDK, util:get_server_name(), [RoleId], 1, none, gsrv_tcp, reader_ws, ?ONHOOK_AGENT_LOGIN]) of
            LoginParams = #login_params{
                id = RoleId, ip = Ip, socket = behavior_tree, accid = AccId, accname = AccName, accname_sdk = AccNameSDK, server_name = util:get_server_name(), ids = [RoleId], reg_server_id = 1, 
                c_source = none, trans_mod = gsrv_tcp, proto_mod = reader_ws
            },
            case catch mod_server:start([LoginParams, ?ONHOOK_AGENT_LOGIN]) of
                {ok, Pid} ->
                    %% 走完正的流程
                    erlang:unlink(Pid),
                    lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, start, [BTreeId]);
                _R ->
                    ?ERR("start login:~p~n", [_R])
            end;
        _R ->
            ?ERR("start login:~p~n", [_R])
    end;
%% 在线开始自动行为
start(PS, BTreeId) when is_record(PS, player_status) ->
    PlayerBehavior = init_player_behavior(PS, BTreeId),
    PS#player_status{behavior_status = PlayerBehavior}.

%% 伪客户端挂机启动
start_in_fake_client(PS) ->
    #player_status{fake_client = #fake_client{in_module = ModuleId, in_sub_module = SubModuleId}} = PS,
    BTreeId = fake_client_tree_id(ModuleId, SubModuleId),
    PlayerBehavior = init_player_behavior(PS, BTreeId),
    PS#player_status{behavior_status = PlayerBehavior}.

init_player_behavior(PS, BTreeId) ->
    Auto = lib_game:setting_is_open(PS, ?SYS_SETTING, ?AUTO_GOD_SETTING),
    #player_behavior{tree_id = BTreeId, is_stop = 0,
        battle = #player_behavior_battle{
            god_status = #behavior_battle_god{is_auto = ?IF(Auto, 1, 0)}
        },
        pet_battle = #pet_behavior_battle{}
    }.

%% ==========================================
%% 是否在行为中
is_in_behavior(PS) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    case BehaviorStatus of
        #player_behavior{is_stop = 0} -> true;
        _ -> false
    end.

%% ==========================================
%% 开启行为
start_behavior(PS) ->
    #player_status{behavior_status = PlayerBehaviorStatus, scene = SceneId} = PS,
    case lib_scene:is_outside_scene(SceneId) of
        true ->
            PS;
        _ ->
            #player_behavior{tree_id = BTreeId} = PlayerBehaviorStatus,
            case is_in_fake_client(PS) of
                true ->
                    {_, WaitMS} = lib_fake_client_api:get_init_behaviour(PS),
                    BTree = lib_object_btree:init_btree(BTreeId),
                    Ref = erlang:send_after(WaitMS, self(), 'tick_behavior'),
                    put(?BEHAVIOR_KEY, {BTree, Ref}),
                    NewPlayerBehaviorStatus = PlayerBehaviorStatus#player_behavior{is_stop = 0},
                    PS#player_status{behavior_status = NewPlayerBehaviorStatus};
                _ ->
                    BTree = lib_object_btree:init_btree(BTreeId),
                    case lib_object_btree:tick_tree(PS, behavior, BTree) of
                        {NewPS, NewStateName, NewBTree} -> NextGapTime = ?BEHAVIOR_TICK_TIME;
                        {NewPS, NewStateName, NewBTree, NextGapTime} -> ok
                    end,
                    Ref = erlang:send_after(NextGapTime, self(), 'tick_behavior'),
                    put(?BEHAVIOR_KEY, {NewBTree, Ref}),
                    NewPlayerBehaviorStatus = PlayerBehaviorStatus#player_behavior{state = NewStateName, is_stop = 0},
                    NewPS#player_status{behavior_status = NewPlayerBehaviorStatus}
            end
    end.

%% 开启行为不检查，一般用于测试在野外
start_behavior_no_check(PS) ->
    #player_status{behavior_status = PlayerBehaviorStatus} = PS,
    #player_behavior{tree_id = BTreeId} = PlayerBehaviorStatus,
    BTree = lib_object_btree:init_btree(BTreeId),
    case lib_object_btree:tick_tree(PS, behavior, BTree) of
        {NewPS, NewStateName, NewBTree} -> NextGapTime = ?BEHAVIOR_TICK_TIME;
        {NewPS, NewStateName, NewBTree, NextGapTime} -> ok
    end,
    Ref = erlang:send_after(NextGapTime, self(), 'tick_behavior'),
    put(?BEHAVIOR_KEY, {NewBTree, Ref}),
    NewPlayerBehaviorStatus = PlayerBehaviorStatus#player_behavior{state = NewStateName},
    NewPS#player_status{behavior_status = NewPlayerBehaviorStatus}.


%% ==========================================
%% 暂停行为
suspend_behavior(PS, State) ->
    #player_status{behavior_status = PlayerBehaviorStatus} = PS,
    case get(?BEHAVIOR_KEY) of
        {_BTree, Ref} ->
            util:cancel_timer(Ref);
        _ ->
            skip
    end,
    NewPlayerBehaviorStatus = PlayerBehaviorStatus#player_behavior{state = State},
    PS#player_status{behavior_status = NewPlayerBehaviorStatus}.

%% ==========================================
%% 结束行为
stop_behavior(PS) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    case erase(?BEHAVIOR_KEY) of
        {_BTree, Ref} ->
            util:cancel_timer(Ref);
        _ ->
            skip
    end,
    NewBehaviorStatus =
        case BehaviorStatus of
            #player_behavior{} -> BehaviorStatus#player_behavior{is_stop = 1};
            _ -> BehaviorStatus
        end,
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% ==========================================
%% 行为Tick
tick_behavior(PS) ->
    case get(?BEHAVIOR_KEY) of
        {BTree, Ref} ->
            case lib_object_btree:tick_tree(PS, behavior, BTree) of
                {NewPS, _, NewBTree} -> NextGapTime = ?BEHAVIOR_TICK_TIME;
                {NewPS, _, NewBTree, NextGapTime} -> ok
            end,
            NewRef = util:send_after(Ref, NextGapTime, self(), 'tick_behavior'),
            put(?BEHAVIOR_KEY, {NewBTree, NewRef}),
            NewPS;
        _ ->
            PS
    end.

%% ==========================================
%% 执行行为时，相关消息处理
behavior_msg(Time, Pid, Msg) when is_pid(Pid) ->
    erlang:send_after(Time, Pid, {'behavior_msg', Msg}).
behavior_msg(Pid, Msg) when is_pid(Pid) ->
    Pid ! {'behavior_msg', Msg};
behavior_msg(Status, Msg) ->
    case get(?BEHAVIOR_KEY) of
        {Tree, Ref} ->
            case lib_object_btree:handle_info(Status, behavior, Tree, Msg) of
                {NewStatus, _NewStateName, NewBTree} ->
                    put(?BEHAVIOR_KEY, {NewBTree, Ref});
                {NewStatus, _NewStateName, NewBTree, NextTickTime} ->
                    NewTickRef = util:send_after(Ref, NextTickTime, self(), 'tick_behavior'),
                    put(?BEHAVIOR_KEY, {NewBTree, NewTickRef})
            end,
            NewStatus;
        _ -> Status
    end.

%% ===================================== For BTree Login Fun =========================================
%% 玩家死亡处理
player_die(PS) ->
    case is_in_behavior(PS) of
        true ->
            InterruptPS = behavior_msg(PS, 'collect_failure_4'),
            SuspendPS = suspend_behavior(InterruptPS, dead),
            case get_revive_time(SuspendPS) of
                {ReviveType, Time} ->
                    erlang:send_after(Time, self(), {'mod', ?MODULE, try_revive, [ReviveType]});
                _ ->% 啥都不干等被切出场景
                    skip
            end,
            SuspendPS;
        _ -> PS
    end.

get_revive_time(PS) ->
    #player_status{fake_client = FakeClient} = PS,
    case FakeClient of
        #fake_client{start_client = 1} ->
            lib_fake_client_api:get_revive_type_and_time(PS);
        _ ->
            {?REVIVE_INPLACE, 20000}
            %{?REVIVE_ORIGIN, 20000}
    end.

try_revive(PS, ReviveType) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    case BehaviorStatus of
        #player_behavior{state = dead} ->
            {_, NewPS} = lib_revive:revive_without_check(PS, ReviveType, []),
            NewPS;
        _ ->
            PS
    end.

%% 玩家复活处理
player_revive(PS) ->
    case is_in_behavior(PS) of
        true ->
            #player_status{behavior_status = BehaviorStatus} = PS,
            NewBehaviorStatus = BehaviorStatus#player_behavior{state = idle},
            start_behavior(PS#player_status{behavior_status = NewBehaviorStatus});
        _ -> PS
    end.

%% 获取采集目标
get_collect_att(PS) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{collect_att = Att} = BehaviorStatus,
    ObjectMap = get_collect_map(PS),
    NeedFindTar =
        case Att of
            #{id:=TargetId} -> not maps:is_key(TargetId, ObjectMap);
            _ -> true
        end,
    get_collect_att_core(PS, ObjectMap, NeedFindTar).

get_collect_att_core(#player_status{behavior_status = BehaviorStatus} = PS, ObjectMap, false) ->
    #player_behavior{collect_att = Att} = BehaviorStatus,
    NewAtt =
        case Att of
            #{id:=TargetId} -> maps:get(TargetId, ObjectMap, false);
            _ -> false
        end,
    ?IF(is_map(NewAtt), NewAtt, get_collect_att_core(PS, ObjectMap, true));
get_collect_att_core(PS, ObjectMap, _) ->
    #player_status{x = X, y = Y, scene = SceneId, id = RoleId} = PS,
    Args = lib_scene_calc:make_scene_calc_args(PS),
    ObjList = [Obj||#scene_object{bl_role_id = BlRoleId} = Obj<-maps:values(ObjectMap), BlRoleId == 0 orelse BlRoleId == RoleId],
    EtsScene = data_scene:get(SceneId),
    case lib_scene_calc:get_object_for_collect(ObjList, EtsScene, X, Y, Args, {closest, X, Y}) of
        #scene_object{id = Id, x = TX, y = TY, sign = Sign, config_id = MonId} ->
            #{id=>Id, x=>TX, y=>TY, sign=>Sign, config_id=> MonId};
        _ -> false
    end.

remove_collect_att(PS) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    NewBehaviorStatus = BehaviorStatus#player_behavior{collect_att = undefined},
    PS#player_status{ behavior_status = NewBehaviorStatus }.

%% 获取拾取宝箱目标
get_drop_att(PS, LongTime) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{drop_att = Att} = BehaviorStatus,
    DropMap = get_drop_map(PS),
    NeedFindTar =
        case Att of
            #{id:=DropId} -> not maps:is_key(DropId, DropMap);
            _ -> true
        end,
    get_drop_att_core(PS, DropMap, LongTime, NeedFindTar).

get_drop_att_core(#player_status{behavior_status = BehaviorStatus} = PS, DropMap, LongTime, false) ->
    #player_behavior{collect_att = Att} = BehaviorStatus,
    NewAtt =
        case Att of
            #{id:=DropId} -> maps:get(DropId, DropMap, false);
            _ -> false
        end,
    ?IF(is_record(NewAtt, ets_drop), {PS, NewAtt}, get_drop_att_core(PS, DropMap, LongTime, true));
get_drop_att_core(PS, DropMap, LongTime, _) ->
    #player_status{
        id = RoleId, x = X, y = Y, team = #status_team{team_id = TeamId}
    } = PS,
    DropList = maps:values(DropMap),
    NowTime = LongTime div 1000,
    F = fun(DropGoods, {AccMap, SelDrop}) ->
        #ets_drop{
            id = DropId, expire_time = ExpireTime, player_id = BelongId,
            team_id = BelongTeamId, x = DropX, y = DropY
        } = DropGoods,
        IsSatisfy =
            if
                ExpireTime < NowTime -> false;
                BelongId > 0, BelongId =/= RoleId, (ExpireTime - NowTime) > ?DROP_SAVE_TIME -> false;
                BelongTeamId > 0, BelongTeamId =/= TeamId, (ExpireTime - NowTime > ?DROP_SAVE_TIME) -> false;
                true -> true
            end,
        if
            not IsSatisfy ->
                {maps:remove(DropId, AccMap), SelDrop};
            not is_record(SelDrop, ets_drop) ->
                {AccMap, DropGoods};
            true ->
                #ets_drop{x = RefX, y = RefY} = SelDrop,
                DistancePow1 = umath:distance_pow({DropX, DropY}, {X, Y}),
                DistancePow2 = umath:distance_pow({RefX, RefY}, {X, Y}),
                if
                    % 超过2000像素，直接移除信息
                    DistancePow1 > 4000000 -> {maps:remove(DropId, AccMap), SelDrop};
                    % 超过1000像素，暂时不捡了
                    DistancePow1 > 1000000 -> {AccMap, SelDrop};
                    % 捡最近
                    DistancePow1 < DistancePow2 -> {AccMap, DropGoods};
                    true -> {AccMap, SelDrop}
                end
        end
    end,
    {NewDropMap, DropAtt} = lists:foldl(F, {DropMap, false}, DropList),
    NewPS = set_drop_map(PS, NewDropMap),
    {NewPS, DropAtt}.

remove_drop_att(PS) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    NewBehaviorStatus = BehaviorStatus#player_behavior{drop_att = undefined},
    PS#player_status{ behavior_status = NewBehaviorStatus }.

%% 开始采集
start_collect(PS, NowTime, GapAttTime, CollectAtt) ->
    #player_status{
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BA, id = RoleId
    } = PS,
    #{id:=TId, x:=TX, y:= TY, config_id:= MonId} = CollectAtt,
    case lib_scene_object_ai:get_next_step(X, Y, 150, SceneId, CopyId, TX, TY, true) of
        attack ->
            #mon{collect_time = CltTime} = data_mon:get(MonId),
            pp_battle:handle(20008, PS, [TId, MonId, ?COLLECT_STATR]),
            {re_action, (CltTime + 1) * 1000};
        {NextX, NextY} ->
            #battle_attr{speed = Speed} = BA,
            case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
                    {re_action, MoveWaitMs};
                {false, _} ->
                    failure;
                true ->
                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'move', [CopyId, NextX, NextY, 0, X, Y, NextX, NextY, 0, 0, RoleId]}),
                    Dis = umath:distance({X, Y}, {NextX, NextY}),
                    MoveWaitMs = case Dis == 0 of
                        true  -> GapAttTime;
                        false -> round(Dis * 1000 / max(1,Speed))
                    end,
                    {re_action, MoveWaitMs, PS#player_status{x = NextX, y = NextY}}
            end
    end.

%% 开始拾取
start_pick_drop(PS, NowTime, GapAttTime, DropGoods) ->
    #player_status{
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BA, id = RoleId
    } = PS,
    #ets_drop{x = TX, y = TY, id = DropId} = DropGoods,
    case lib_scene_object_ai:get_next_step(X, Y, 150, SceneId, CopyId, TX, TY, true) of
        attack ->
            pp_goods:handle(15053, PS, [DropId]),
            wait_call_back;
        {NextX, NextY} ->
            #battle_attr{speed = Speed} = BA,
            case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
                    {re_action, MoveWaitMs};
                {false, _} ->
                    failure;
                true ->
                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'move', [CopyId, NextX, NextY, 0, X, Y, NextX, NextY, 0, 0, RoleId]}),
                    Dis = umath:distance({X, Y}, {NextX, NextY}),
                    MoveWaitMs = case Dis == 0 of
                        true  -> GapAttTime;
                        false -> round(Dis * 1000 / max(1,Speed))
                    end,
                    {re_action, MoveWaitMs, PS#player_status{x = NextX, y = NextY}}
            end
    end.

get_walk_path(PS, WalkPoint) ->
    case WalkPoint of
        {TargetX, TargetY} ->
            {TargetX, TargetY};
        Path when is_list(WalkPoint) -> Path;
        _ ->
            % 托管特殊处理下
            case is_in_fake_client(PS) of
                true ->
                    case lib_fake_client_api:find_target_in_module(PS, module_object) of
                        #att_target{x = OtherX, y = OtherY} ->
                            {OtherX, OtherY};
                        _ ->
                            false
                    end;
                _ -> false
            end
    end.

start_walk(PS, NowTime, GapAttTime) ->
    #player_status{
        behavior_status = BehaviorStatus, x = X, y = Y, battle_attr = BA = #battle_attr{speed = Speed},
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, id = RoleId
    } = PS,
    % case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, true) of
    #player_behavior{walk_path = WalkPath, walk_point = WalkPoint} = BehaviorStatus,
    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
        {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
            {re_action, MoveWaitMs};
        {false, _} ->
            failure;
        true ->
            case WalkPath of
                [{NextX, NextY}|T] ->
                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'move', [CopyId, NextX, NextY, 0, X, Y, NextX, NextY, 0, 0, RoleId]}),
                    Dis = umath:distance({X, Y}, {NextX, NextY}),
                    MoveWaitMs = case Dis == 0 of
                        true  -> GapAttTime;
                        false -> round(Dis * 1000 / max(1,Speed))
                    end,
                    NewBehaviorStatus = BehaviorStatus#player_behavior{walk_path = T},
                    {re_action, MoveWaitMs, PS#player_status{x = NextX, y = NextY, behavior_status = NewBehaviorStatus}};
                [] ->
                    case WalkPoint of
                        {0, 0} -> success;
                        {TargetX, TargetY} ->
                            case lib_scene_object_ai:get_next_step(X, Y, 500, SceneId, CopyId, TargetX, TargetY, true) of
                                attack ->
                                    NewBehaviorStatus = BehaviorStatus#player_behavior{walk_point = {0, 0}},
                                    {success, PS#player_status{behavior_status = NewBehaviorStatus}};
                                {NextX, NextY} ->
                                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'move', [CopyId, NextX, NextY, 0, X, Y, NextX, NextY, 0, 0, RoleId]}),
                                    Dis = umath:distance({X, Y}, {NextX, NextY}),
                                    MoveWaitMs = case Dis == 0 of
                                        true  -> GapAttTime;
                                        false -> round(Dis * 1000 / max(1,Speed))
                                    end,
                                    {re_action, MoveWaitMs, PS#player_status{x = NextX, y = NextY}};
                                _ -> failure
                            end
                    end;
                _ ->
                    failure
            end
   end.

%% 是否在托管
is_in_fake_client(PS) ->
    #player_status{fake_client = FakeClient} = PS,
    case FakeClient of
        #fake_client{start_client = 1} -> true;
        _ -> false
    end.

%% 获取战斗对象map||托管挂机时使用托管挂机数据
get_battle_obj_map(PS) ->
    #player_status{fake_client = FakeClient, behavior_status = BehaviorStatus} = PS,
    case FakeClient of
        #fake_client{start_client = 1, scene_object_data = SceneObjectData} ->
            {maps:get(user, SceneObjectData, #{}), maps:get(object, SceneObjectData, #{})};
        _ ->
            #player_behavior{user_map = UserMap, object_map = ObjectMap} = BehaviorStatus,
            {UserMap, ObjectMap}
    end.

%% 获取采集map||托管挂机时使用托管挂机数据
get_collect_map(PS) ->
    #player_status{fake_client = FakeClient, behavior_status = BehaviorStatus} = PS,
    case FakeClient of
        #fake_client{start_client = 1, scene_object_data = SceneObjectData} ->
            ObjectMap = maps:get(object, SceneObjectData, #{});
        _ ->
            #player_behavior{object_map = ObjectMap} = BehaviorStatus
    end,
    ObjectMap.

%% 设置采集map||托管挂机时设置托管挂机数据
set_collect_map(PS, ObjectMap) ->
    #player_status{fake_client = FakeClient, behavior_status = BehaviorStatus} = PS,
    case FakeClient of
        #fake_client{start_client = 1, scene_object_data = SceneObjectData} ->
            NewSceneObjectData = SceneObjectData#{object => ObjectMap},
            PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}};
        _ ->
            NewBehaviorStatus = BehaviorStatus#player_behavior{object_map = ObjectMap},
            PS#player_status{behavior_status = NewBehaviorStatus}
    end.

%% 获取掉落map||托管挂机时使用托管挂机数据
get_drop_map(PS) ->
    #player_status{fake_client = FakeClient, behavior_status = BehaviorStatus} = PS,
    case FakeClient of
        #fake_client{start_client = 1, drop_goods_data = DropGoodsData} ->
            DropGoodsData;
        _ ->
            #player_behavior{drop_map = DropGoodsData} = BehaviorStatus,
            DropGoodsData
    end.

%% 设置掉落map||托管挂机时设置托管挂机数据
set_drop_map(PS, DropMap) ->
    #player_status{fake_client = FakeClient, behavior_status = BehaviorStatus} = PS,
    case FakeClient of
        #fake_client{start_client = 1} ->
            PS#player_status{fake_client = FakeClient#fake_client{drop_goods_data = DropMap}};
        _ ->
            NewBehaviorStatus = BehaviorStatus#player_behavior{drop_map = DropMap},
            PS#player_status{behavior_status = NewBehaviorStatus}
    end.

%% ===================================== Proto Call Back About =========================================
%% 采集怪物结果处理
collect_mon_result(PS, Code) ->
    if
        Code == 1  -> %% 开始采集成功
            behavior_msg(PS, 'start_collect_success');
        Code == 2 -> %% 采集成功
            behavior_msg(PS, 'end_collect_success');
        %% 采集失败，重新寻找目标
        Code == 3 orelse Code == 5 orelse Code == 14 ->
            behavior_msg(PS, 'collect_failure_1');
        %% 采集失败，重新寻找目标(要排除旧目标)
        Code == 6 orelse Code == 4 orelse Code == 8 orelse Code == 13 orelse Code == 18 orelse Code == 19 orelse Code == 20 orelse Code == 25 ->
            behavior_msg(PS, 'collect_failure_2');
        true -> %% 没有采集次数，停止采集相同的采集怪
            behavior_msg(PS, 'collect_failure_3')
    end.

%% 采集被打断
interrupt_collect_mon(PS) ->
    behavior_msg(PS, 'collect_failure_4').

pick_up_result(PS, Res, _Args, _Status, DropId) ->
    PickSuccess = ?SUCCESS,
    PickStart = ?ERRCODE(err150_start_pick_drop),
    case Res of
        % 拾取成功了
        PickSuccess ->
            behavior_msg(PS, {'pick_up_end', DropId});
        % 开始拾取（需要拾取时间）
        PickStart ->
            behavior_msg(PS, {'pick_up_start', DropId});
        _ ->
            behavior_msg(PS, {'pick_up_fail', DropId})
    end.

fake_client_tree_id(ModuleId, SubMod) ->
    %% 各个托管功能对应的行为
    case ModuleId of
        ?MOD_NINE ->
            onhook;
        ?MOD_MIDDAY_PARTY ->
            onhook;
        ?MOD_DRUMWAR ->
            onhook;
        ?MOD_GUILD_ACT when SubMod == ?MOD_GUILD_ACT_PARTY ->
            onhook;
        ?MOD_TOPPK ->
            onhook;
        ?MOD_TERRITORY ->
            onhook;
        ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
            onhook;
        ?MOD_TERRITORY_WAR ->
            onhook;
        ?MOD_KF_1VN ->
            onhook;
        _ ->
            onhook
    end.

%% ==================== About GM =========================
%% 测试行为树#客户端上线，同时能收到消息
gm_start(RoleId, OnHookInfo) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_start, [OnHookInfo]);
gm_start(PS, OnHookInfo) ->
    #player_status{sid = Sid, pid = Pid} = PS,
    ObserverPid = spawn(fun() -> lib_player_behavior_send:send_msg(Pid) end ),
    Sid ! {observer_pid, ObserverPid},
    PlayerBehavior = init_player_behavior(PS, OnHookInfo),
    NewPS = PS#player_status{behavior_status = PlayerBehavior},
    {ok, LastPS} = pp_scene:handle(12002, NewPS, server),
    pp_player:handle(13017, LastPS, []),
    LastPS.

gm_tick(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_tick, []);
gm_tick(PS) ->
    case get(?BEHAVIOR_KEY) of
        {BTree, Ref} ->
            util:cancel_timer(Ref),
            case lib_object_btree:tick_tree(PS, behavior, BTree) of
                {NewPS, _, NewBTree} -> ok;
                {NewPS, _, NewBTree, _} -> ok
            end,
            %NewRef = util:send_after(Ref, ?BEHAVIOR_TICK_TIME, self(), 'tick_behavior'),
            NewRef = undefined,
            put(?BEHAVIOR_KEY, {NewBTree, NewRef}),
            NewPS;
        _ ->
            PS
    end.

gm_end(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_end, []);
gm_end(PS) ->
    PS#player_status.sid ! {observer_pid, none},
    stop_behavior(PS).

gm_go_to_onhook(RoleId, SceneId, Id) when is_integer(RoleId) ->
    case lib_player:get_alive_pid(RoleId) of
        false ->
            start(RoleId, onhook),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, gm_go_to_onhook, [SceneId, Id]);
        _ ->
            is_alive
    end;
gm_go_to_onhook(PS, SceneId, Id) ->
    #base_onhook{xy = [{TargetX0, TargetY0}]} =data_onhook:get(SceneId, Id),
    TargetX = urand:rand(-50, 50) + TargetX0,
    TargetY = urand:rand(-50, 50) + TargetY0,
    NewPS = lib_scene:change_scene(PS, SceneId, 0, 0, TargetX, TargetY, false, []),
    erlang:send_after(1000, self(), {'mod', ?MODULE, start_behavior_no_check, []}),
    NewPS.

gm_many_onhook() ->
    AllOnhookPoint = data_onhook:get_all(),
    RoleIdL0 = db:get_all("select id from player_low order by lv desc"),
    RoleIdL = [RoleId||[RoleId]<-RoleIdL0, lib_player:get_alive_pid(RoleId) == false],
    do_gm_many_onhook(RoleIdL, AllOnhookPoint ++ AllOnhookPoint).

do_gm_many_onhook([], _) -> ok;
do_gm_many_onhook(_, []) -> ok;
do_gm_many_onhook([RId1|T1], [{SceneId, Id}|T2]) ->
    gm_go_to_onhook(RId1, SceneId, Id),
    timer:sleep(500),
    do_gm_many_onhook(T1, T2);
do_gm_many_onhook(_, _) ->
    ok.

test_times_set(Keys) ->
    [put(Key, 0)||Key <- Keys].

test_times_add(Key) ->
    case get(Key) of
        Num when is_integer(Num) ->
            put(Key, Num + 1);
        _ -> skip
    end.

test_times_add(Key, Add) ->
    case get(Key) of
        Num when is_integer(Num) ->
            put(Key, Num + Add);
        _ -> skip
    end.

test_times_info(Keys) ->
    F = fun(Key) ->
        case erase(Key) of
            Num when is_integer(Num) ->
                ?INFO("~p num ~p ~n", [Key, Num]);
            _ ->
                skip
        end
    end,
    [F(Key)||Key<-Keys].


