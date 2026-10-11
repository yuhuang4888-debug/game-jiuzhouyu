%%-----------------------------------------------------------------------------
%% @Module  :       mod_void_fam
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-14
%% @Description:    虚空秘籍(跨服)
%%-----------------------------------------------------------------------------
-module(mod_void_fam).

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

sync_act_status(Node) ->
    gen_server:cast(?MODULE, {'sync_act_status', Node}).

request_sync_data(Args) ->
    gen_server:cast(?MODULE, {'request_sync_data', Args}).

%% 本服通知跨服中心开启活动
%% 跨服中心检测是否符合开启条件
act_start(ActId) ->
    gen_server:cast(?MODULE, {'act_start', ActId}).

send_act_info(Node, RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', Node, RoleId}).

enter_scene(Node, SerId, RoleId, HpLim) ->
    gen_server:cast(?MODULE, {'enter_scene', Node, SerId, RoleId, HpLim}).

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
do_handle_cast({'send_act_info', Node, RoleId}, State) ->
    #status_void_fam{status = Status, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            RoleMap = lib_void_fam:get_role_map(),
            DefRoleInfo = #role_info{role_id = RoleId, floor = ?MIN_FLOOR},
            RoleInfo = maps:get(RoleId, RoleMap, DefRoleInfo),
            IsPass = case lib_void_fam:is_pass(RoleInfo) of
                false -> 0;
                true -> 1
            end,
            {ok, BinData} = pt_600:write(60001, [Status, Etime, IsPass]),
            lib_void_fam:send_to_uid(Node, RoleId, BinData);
        false ->
            {ok, BinData} = pt_600:write(60001, [Status, Etime, 0]),
            lib_void_fam:send_to_uid(Node, RoleId, BinData)
    end,
    {ok, State};

do_handle_cast({'sync_act_status', Node}, State) ->
    NewState = lib_void_fam:request_sync_data([{?SYNC_TYPE_ACT_STATUS, Node}], State),
    {ok, NewState};

%% 请求同步数据到本服
do_handle_cast({'request_sync_data', Args}, State) ->
    NewState = lib_void_fam:request_sync_data(Args, State),
    {ok, NewState};

%% 开始活动
do_handle_cast({'act_start', ActId}, State) ->
    #status_void_fam{ref = Ref, status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus =/= ?ACT_STATUS_OPEN orelse NowTime > Etime of
        true ->
            util:cancel_timer(Ref),
            NewState = lib_void_fam:act_start(ActId);
        false -> %% 已经开启不用重复开启
            NewState = State
    end,
    {ok, NewState};

%% 进入场景
do_handle_cast({'enter_scene', Node, SerId, RoleId, HpLim}, State) ->
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            RoleMap = lib_void_fam:get_role_map(),
            DefRoleInfo = #role_info{node = Node, ser_id = SerId, role_id = RoleId, floor = ?MIN_FLOOR, hp = HpLim},
            #role_info{
                node = Node,
                floor = Floor,
                score = Score,
                scene = OldScene,
                hp = _Hp
            } = RoleInfo = maps:get(RoleId, RoleMap, DefRoleInfo),
            case data_void_fam:get_floor_cfg(Floor) of
                #void_fam_floor_cfg{kf_scene = Scene} ->
                    case OldScene =/= Scene of
                        true ->
                            case lib_void_fam:is_pass(RoleInfo) of
                                false ->
                                    {ok, SelRoomId} = lib_void_fam:enter_room(Floor, Scene),

                                    NewRoleInfo = RoleInfo#role_info{scene = Scene, room_id = SelRoomId},
                                    NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                                    lib_void_fam:save_role_map(NewRoleMap),

                                    %% 增加活跃度
                                    mod_clusters_center:apply_cast(Node, lib_activitycalen_api, role_success_end_activity, [RoleId, ?MOD_VOID_FAM, 0]),
                                    % mod_clusters_center:apply_cast(Node, mod_hi_point, success_end, [RoleId, ?MOD_VOID_FAM, 0]),
                                    %% 日志
                                    mod_clusters_center:apply_cast(Node, lib_void_fam, add_log, [RoleId, 1, Floor, Score]),
                                    %% 切换场景
                                    KeyValueList = [
                                        {group, 0},
                                        {hp, HpLim},
                                        {pk, {?PK_ALL, true}},
                                        {action_lock, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}
                                        ],
                                    {X, Y} = lib_void_fam:get_scene_born_xy(Scene),
                                    ScenePoolId = lib_void_fam:count_scene_pool_id(SelRoomId),
                                    Args = [RoleId, Scene, ScenePoolId, SelRoomId, X, Y, true, KeyValueList],
                                    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args);
                                true ->
                                    {ok, BinData} = pt_600:write(60000, [?ERRCODE(err600_is_pass)]),
                                    lib_void_fam:send_to_uid(Node, RoleId, BinData)
                            end;
                        _ -> skip
                    end;
                _ -> skip
            end;
        _ ->
            {ok, BinData} = pt_600:write(60000, [?ERRCODE(err402_act_close)]),
            lib_void_fam:send_to_uid(Node, RoleId, BinData)
    end,
    {ok, State};

%% 退出场景
do_handle_cast({'exit_scene', RoleId, _HpLim}, State) ->
    RoleMap = lib_void_fam:get_role_map(),
    case maps:get(RoleId, RoleMap, false) of
        #role_info{
            node = Node,
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
            mod_clusters_center:apply_cast(Node, lib_void_fam, add_log, [RoleId, QuitType, Floor, Score]),

            lib_void_fam:exit_room(Floor, RoomId),

            NewRoleMap = maps:put(RoleId, RoleInfo#role_info{scene = 0, ref = []}, RoleMap),
            lib_void_fam:save_role_map(NewRoleMap),

            Args = [RoleId, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]],
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args);
        _ -> skip
    end,
    {ok, State};

%% 楼层信息
do_handle_cast({'send_floor_info', RoleId}, State) ->
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            #status_void_fam{etime = Etime} = State,
            RoleMap = lib_void_fam:get_role_map(),
            case maps:get(RoleId, RoleMap, false) of
                #role_info{node = Node, floor = Floor, score = Score} ->
                    #void_fam_floor_cfg{
                        score = NeedScore,
                        reward = FloorReward
                        } = data_void_fam:get_floor_cfg(Floor),
                    {ok, BinData} = pt_600:write(60004, [Etime, Floor, Score, NeedScore, FloorReward]),
                    lib_void_fam:send_to_uid(Node, RoleId, BinData);
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
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            %% 如果攻击者不在场景不做处理
            lib_void_fam:kill_player(AttackerId, AttackerName, DefenderId, DefenderName, BattleSceneId);
        false -> skip
    end,
    {ok, State};

%% 击杀怪物
do_handle_cast({'kill_mon', AttackerId, AttackerName, MonId, BattleSceneId}, State) ->
    #status_void_fam{status = ActStatus, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case ActStatus == ?ACT_STATUS_OPEN andalso NowTime < Etime of
        true ->
            lib_void_fam:kill_mon(AttackerId, AttackerName, MonId, BattleSceneId);
        false -> skip
    end,
    {ok, State};

%% 秘籍开启活动
do_handle_cast({'gm_start', Duration}, State) ->
    #status_void_fam{ref = Ref, status = Status, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status =/= ?ACT_STATUS_OPEN orelse NowTime > Etime of
        true ->
            util:cancel_timer(Ref),
            NewEtime = NowTime + Duration,
            Args = [{?SYNC_TYPE_ACT_STATUS, ?ACT_STATUS_OPEN, NewEtime}],
            mod_clusters_center:apply_to_all_node(mod_void_fam_local, sync_data, [Args]),
            NewRef = erlang:send_after(Duration * 1000, self(), {'act_end'}),
            NewState = #status_void_fam{
                status = ?ACT_STATUS_OPEN,
                etime = NewEtime,
                ref = NewRef
            },
            {ok, NewState};
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
            node = Node,
            scene = Scene,
            room_id = RoomId,
            ref = Ref,
            floor = Floor,
            score = Score
        } = RoleInfo when Scene > 0 ->
            util:cancel_timer(Ref),

            %% 日志
            mod_clusters_center:apply_cast(Node, lib_void_fam, add_log, [RoleId, 3, Floor, Score]),

            lib_void_fam:exit_room(Floor, RoomId),

            NewRoleMap = maps:put(RoleId, RoleInfo#role_info{scene = 0, ref = []}, RoleMap),
            lib_void_fam:save_role_map(NewRoleMap),

            Args = [RoleId, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]],
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args);
        _ -> skip
    end,
    {ok, State};

%% 活动结束
do_handle_info({'act_end'}, State) ->
    #status_void_fam{ref = ORef} = State,
    util:cancel_timer(ORef),

    RoleMap = lib_void_fam:get_role_map(),
    RoleList = maps:values(RoleMap),
    F = fun(RoleInfo) ->
        case RoleInfo of
            #role_info{
                node = Node,
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
                mod_clusters_center:apply_cast(Node, lib_void_fam, add_log, [RoleId, QuitType, Floor, Score]),

                Args = [RoleId, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim, 1}, {action_free, ?ERRCODE(err600_can_not_change_scene_in_void_fam)}]],
                mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args);
            _ -> skip
        end
    end,
    lists:foreach(F, RoleList),

    Args = [{?SYNC_TYPE_ACT_STATUS, ?ACT_STATUS_CLOSE, 0}],
    mod_clusters_center:apply_to_all_node(mod_void_fam_local, sync_data, [Args]),

    %% 删除进程字典数据
    erase(?P_ROLE_MAP),
    erase(?P_ACHIEVE_FLOOR_RECORD_MAP),
    erase(?P_ROOM_MAP),

    NewState = #status_void_fam{
        status = ?ACT_STATUS_CLOSE
        },
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

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.