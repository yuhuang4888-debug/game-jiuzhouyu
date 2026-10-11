% %%-----------------------------------------------------------------------------
% %% @Module  :       mod_void_fam_local
% %% @Author  :       Czc
% %% @Email   :       389853407@qq.com
% %% @Created :       2017-11-14
% %% @Description:    虚空秘籍(本服)
% %%-----------------------------------------------------------------------------
-module(mod_void_fam_local).

-include("void_fam.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("predefine.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).

%% 定时器启动
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

is_act_open() ->
    case catch gen_server:call(?MODULE, {'is_act_open'}) of
        IsOpen when is_boolean(IsOpen) ->
            IsOpen;
        _Err ->
            ?ERR("get_act_status err:~p", [_Err]),
            false
    end.

sync_data(Data) ->
    gen_server:cast(?MODULE, {'sync_data', Data}).

send_act_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId}).

act_start(ActId) ->
    gen_server:cast(?MODULE, {'act_start', ActId}).

kf_act_start(Stime, Etime) ->
    gen_server:cast(?MODULE, {'kf_act_start', Stime, Etime}).

kf_act_end() ->
    gen_server:cast(?MODULE, {'kf_act_end'}).

enter_scene(RoleId, HpLim) ->
    gen_server:cast(?MODULE, {'enter_scene', RoleId, HpLim}).

exit_scene(RoleId, HpLim) ->
    gen_server:cast(?MODULE, {'exit_scene', RoleId, HpLim}).

send_floor_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_floor_info', RoleId}).

% update_role_hp(RoleId, Scene, Hp) ->
%     gen_server:cast(?MODULE, {'update_role_hp', RoleId, Scene, Hp}).

kill_player(AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId) ->
    gen_server:cast(?MODULE, {'kill_player', AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId}).

kill_mon(AttackerId, AttackerName, MonId, BattleSceneId) ->
    gen_server:cast(?MODULE, {'kill_mon', AttackerId, AttackerName, MonId, BattleSceneId}).

gm_start(Duration) ->
    gen_server:cast(?MODULE, {'gm_start', Duration}).

init([]) ->
    State = lib_void_fam:init_act(),
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, status_void_fam)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 活动信息
do_handle_cast({'send_act_info', RoleId}, State) ->
    #status_void_fam{status = Status, cls_type = ClsType, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            case ClsType of
                ?ACT_TYPE_BF ->
                    RoleMap = lib_void_fam:get_role_map(),
                    DefRoleInfo = #role_info{role_id = RoleId, floor = ?MIN_FLOOR},
                    RoleInfo = maps:get(RoleId, RoleMap, DefRoleInfo),
                    IsPass = case lib_void_fam:is_pass(RoleInfo) of
                        false -> 0;
                        true -> 1
                    end,
                    {ok, BinData} = pt_600:write(60001, [Status, Etime, IsPass]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                ?ACT_TYPE_KF ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_void_fam, send_act_info, [Node, RoleId]);
                _ -> skip
            end;
        false ->
            {ok, BinData} = pt_600:write(60001, [Status, Etime, 0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {ok, State};

%% 跨服中心同步数据到本服
do_handle_cast({'sync_data', Data}, State) ->
    ActClsType = lib_void_fam:get_act_cls_type(),
    case ActClsType of
        ?ACT_TYPE_KF ->
            NewState = lib_void_fam:sync_data(Data, State),
            {ok, NewState};
        _ ->
            {ok, State}
    end;

%% 开启活动
do_handle_cast({'act_start', ActId}, State) ->
    #status_void_fam{ref = Ref, status = Status, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status =/= ?ACT_STATUS_OPEN orelse NowTime > Etime of
        true ->
            ActClsType = lib_void_fam:get_act_cls_type(),
            case ActClsType of
                ?ACT_TYPE_KF -> %% 跨服的活动通知跨服中心开启
                    mod_clusters_node:apply_cast(mod_void_fam, act_start, [ActId]),
                    {ok, State};
                _ ->
                    util:cancel_timer(Ref),
                    NewState = lib_void_fam:act_start(ActId),
                    {ok, NewState}
            end;
        _ -> {ok, State}
    end;

%% 进入场景
do_handle_cast({'enter_scene', RoleId, HpLim}, State) ->
    #status_void_fam{cls_type = ClsType, status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            case ClsType of
                ?ACT_TYPE_BF ->
                    RoleMap = lib_void_fam:get_role_map(),
                    DefRoleInfo = #role_info{role_id = RoleId, floor = ?MIN_FLOOR, hp = HpLim},
                    #role_info{
                        floor = Floor,
                        score = Score,
                        scene = OldScene,
                        hp = _Hp
                    } = RoleInfo = maps:get(RoleId, RoleMap, DefRoleInfo),
                    case data_void_fam:get_floor_cfg(Floor) of
                        #void_fam_floor_cfg{scene = Scene} ->
                            case OldScene =/= Scene of
                                true ->
                                    case lib_void_fam:is_pass(RoleInfo) of
                                        false ->
                                            {ok, SelRoomId} = lib_void_fam:enter_room(Floor, Scene),

                                            NewRoleInfo = RoleInfo#role_info{scene = Scene, room_id = SelRoomId},
                                            NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                                            lib_void_fam:save_role_map(NewRoleMap),

                                            %% 增加活跃度
                                            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_VOID_FAM, 0),

                                            %% 日志
                                            lib_void_fam:add_log(RoleId, 1, Floor, Score),
                                            %% 切换场景
                                            KeyValueList = [
                                                {group, 0},
                                                {hp, HpLim},
                                                {pk, {?PK_ALL, true}},
                                                {action_lock, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}
                                                ],
                                            {X, Y} = lib_void_fam:get_scene_born_xy(Scene),
                                            ScenePoolId = lib_void_fam:count_scene_pool_id(SelRoomId),
                                            lib_scene:player_change_scene(RoleId, Scene, ScenePoolId, SelRoomId, X, Y, true, KeyValueList);
                                        true ->
                                            {ok, BinData} = pt_600:write(60000, [?ERRCODE(err600_is_pass)]),
                                            lib_server_send:send_to_uid(RoleId, BinData)
                                    end;
                                _ ->
                                    skip
                            end;
                        _ ->
                            skip
                    end;
                ?ACT_TYPE_KF ->
                    Node = mod_disperse:get_clusters_node(),
                    SerId = config:get_server_id(),
                    mod_clusters_node:apply_cast(mod_void_fam, enter_scene, [Node, SerId, RoleId, HpLim]);
                _ ->
                    skip
            end;
        false ->
            {ok, BinData} = pt_600:write(60000, [?ERRCODE(err402_act_close)]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {ok, State};

%% 退出场景
do_handle_cast({'exit_scene', RoleId, HpLim}, State) ->
    #status_void_fam{cls_type = ClsType} = State,
    case ClsType of
        ?ACT_TYPE_BF ->
            RoleMap = lib_void_fam:get_role_map(),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{
                    scene = Scene,
                    room_id = RoomId,
                    ref = Ref,
                    floor = Floor,
                    score = Score
                } = RoleInfo when Scene > 0 ->
                    util:cancel_timer(Ref),
                    %% 日志
                    QuitType = case lib_void_fam:is_pass(RoleInfo) of
                        true -> 3;
                        _ -> 2
                    end,
                    lib_void_fam:add_log(RoleId, QuitType, Floor, Score),
                    NewRoleMap = maps:put(RoleId, RoleInfo#role_info{scene = 0 , ref = []}, RoleMap),
                    lib_void_fam:save_role_map(NewRoleMap),

                    lib_void_fam:exit_room(Floor, RoomId);
                _ -> skip
            end,
            lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]);
        ?ACT_TYPE_KF ->
            mod_clusters_node:apply_cast(mod_void_fam, exit_scene, [RoleId, HpLim]);
        _ -> skip
    end,
    {ok, State};

%% 楼层信息
do_handle_cast({'send_floor_info', RoleId}, State) ->
    #status_void_fam{cls_type = ClsType, status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            case ClsType of
                ?ACT_TYPE_BF ->
                    RoleMap = lib_void_fam:get_role_map(),
                    case maps:get(RoleId, RoleMap, false) of
                        #role_info{floor = Floor, score = Score} ->
                            #void_fam_floor_cfg{
                                score = NeedScore,
                                reward = FloorReward
                                } = data_void_fam:get_floor_cfg(Floor),
                            {ok, BinData} = pt_600:write(60004, [Etime, Floor, Score, NeedScore, FloorReward]),
                            lib_server_send:send_to_uid(RoleId, BinData);
                        _ -> skip
                    end;
                ?ACT_TYPE_KF ->
                    mod_clusters_node:apply_cast(mod_void_fam, send_floor_info, [RoleId]);
                _ -> skip
            end;
        false -> skip
    end,
    {ok, State};

% %% 更新玩家血量
% do_handle_cast({'update_role_hp', RoleId, Scene, Hp}, State) ->
%     lib_void_fam:update_role_hp(RoleId, Scene, Hp),
%     {ok, State};

%% 击杀玩家
do_handle_cast({'kill_player', AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId}, State) ->
    #status_void_fam{cls_type = ClsType, status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            case ClsType of
                ?ACT_TYPE_BF ->
                    %% 如果攻击者不在场景不做处理
                    lib_void_fam:kill_player(AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId);
                _ ->
                    mod_clusters_node:apply_cast(mod_void_fam, kill_player, [AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId])
            end;
        false -> skip
    end,
    {ok, State};

%% 击杀怪物
do_handle_cast({'kill_mon', AttackerId, AttackerName, MonId, BattleSceneId}, State) ->
    #status_void_fam{cls_type = ClsType, status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            case ClsType of
                ?ACT_TYPE_BF ->
                    %% 如果攻击者不在场景不做处理
                    lib_void_fam:kill_mon(AttackerId, AttackerName, MonId, BattleSceneId);
                _ -> skip
            end;
        false -> skip
    end,
    {ok, State};

%% 秘籍开启活动
do_handle_cast({'gm_start', Duration}, State) ->
    #status_void_fam{ref = Ref, status = Status, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status =/= ?ACT_STATUS_OPEN orelse NowTime > Etime of
        true ->
            ActClsType = lib_void_fam:get_act_cls_type(),
            case ActClsType of
                ?ACT_TYPE_KF -> %% 跨服的活动通知跨服中心开启
                    mod_clusters_node:apply_cast(mod_void_fam, gm_start, [Duration]),
                    {ok, State};
                _ ->
                    util:cancel_timer(Ref),
                    NewState = lib_void_fam:act_start_by_time(NowTime + Duration),
                    {ok, NewState}
            end;
        _ -> {ok, State}
    end;

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, status_void_fam)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% 通关退出场景
do_handle_info({'pass_exit_scene', RoleId}, State) ->
    RoleMap = lib_void_fam:get_role_map(),
    case maps:get(RoleId, RoleMap, false) of
        #role_info{
            scene = Scene,
            room_id = RoomId,
            ref = Ref,
            floor = Floor,
            score = Score
        } = RoleInfo when Scene > 0 ->
            util:cancel_timer(Ref),

            %% 日志
            lib_void_fam:add_log(RoleId, 3, Floor, Score),

            lib_void_fam:exit_room(Floor, RoomId),

            NewRoleMap = maps:put(RoleId, RoleInfo#role_info{scene = 0, ref = []}, RoleMap),
            lib_void_fam:save_role_map(NewRoleMap),

            lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]);
        _ -> skip
    end,
    {ok, State};

%% 活动结束
do_handle_info({'act_end'}, State) ->
    #status_void_fam{cls_type = ClsType} = State,
    case ClsType of
        ?ACT_TYPE_BF ->
            NewState = lib_void_fam:act_close(State);
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'is_act_open'}, State) ->
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    OpenStatus = ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime,
    {ok, OpenStatus};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.