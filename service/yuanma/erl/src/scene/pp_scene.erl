%%%--------------------------------------
%%% @Module  : pp_scene
%%% @Author  : zhenghehe
%%% @Created : 2010.12.23
%%% @Description:  场景
%%%--------------------------------------
-module(pp_scene).
-export([handle/3]).
-include("server.hrl").
-include("scene.hrl").
-include("task.hrl").
-include("skill.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("dungeon.hrl").
-include("team.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("def_goods.hrl").

%% 移动信息
handle(12001, Status, [_S, TargetX, TargetY, Fly, BX, BY, FlyX, FlyY])
  when Status#player_status.fin_change_scene==1 ->
    if
        %% 飞行不限制
        Fly /= 0 ->
            X = TargetX,
            Y = TargetY;
        %% 走路大于240像素为非法
        %% abs(Status#player_status.x - TargetX) > 300 orelse abs(Status#player_status.y - TargetY) > 240 ->
        %%      X = Status#player_status.x,
        %%      Y = Status#player_status.y;
        %%  跨场景移动
        %% S = Status#player_status.scene ->
        %% X = Status#player_status.x,
        %% Y = Status#player_status.y;
        %% 其余合法
        true ->
            X = TargetX,
            Y = TargetY
    end,
    % 托管中不接受客户端的移动信息
    IsInBehavior = lib_player_behavior_api:is_in_behavior(Status),
    if
        IsInBehavior -> {ok, Status};
        true ->
            mod_scene_agent:move(X, Y, BX, BY, Fly, FlyX, FlyY, Status),
            % case Status#player_status.team#status_team.team_id > 0 of %%  andalso Status#player_status.follows /= [] of
            %     true ->
            %         mod_team:cast_to_team(Status#player_status.team#status_team.team_id,
            %                               {'change_location', Status#player_status.id, Status#player_status.scene,
            %                                Status#player_status.scene_pool_id, Status#player_status.copy_id, X, Y, BX, BY});
            %     false ->
            %         skip
            % end,
            %% 写入走路坐标
            %% input_move_pos(Status, TargetX, TargetY, Fly, FlyX, FlyY),

            {ok, Status#player_status{x = X, y = Y}}
    end;

%% 屏蔽切换场景期间的移动信息
handle(12001, Status, _) ->
    {ok, Status};

%%加载场景
handle(12002, Status, _) ->
    {ok, PreStatus} = lib_player_event:dispatch(Status, ?EVENT_PREPARE_CHANGE_SCENE),

    % ?MYLOG("hjhscene", "========================12002 Id:~p ~n", [Status#player_status.id]),
    mod_scene_agent:load_scene(PreStatus),
    %% 更新公共线的场景
    mod_chat_agent:update(PreStatus#player_status.id, [{scene, PreStatus#player_status.scene},
                                                    {scene_pool_id, PreStatus#player_status.scene_pool_id},
                                                    {copy_id, PreStatus#player_status.copy_id}]),
    LogStatus = lib_scene:log_change_scene_and_return(PreStatus),
    {ok, EvtStatus} = lib_player_event:dispatch(LogStatus, ?EVENT_FIN_CHANGE_SCENE),
    {ok, EvtStatus#player_status{fin_change_scene = 1}};

%% @doc 切换场景
%% DunId:非副本场景切换=0；副本场景：副本id
%% ChangeSceneId:切换的场景id
%% @end
%% 说明：reconnect默认为1，首次切换场景后，会将reconnect置为0
handle(12005, Status, [DunId, ChangeSceneId, CallBackValue, TransType, TX, TY]) ->
    %% 采集走路坐标
    %% get_move_pos(Status),
    %% 删除定时器
    lib_client:delete_a_player_timer(Status#player_status.id),
    {ok, NewStatus} = change_scene(Status, DunId, ChangeSceneId, CallBackValue, TransType, TX, TY),
    {ok, NewStatus};

%% 12017 掉落包信息

%% 上线请求玩家周围的掉落包
handle(12018, Status, []) ->
    #player_status{id = RoleId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y} = Status,
    case lib_scene:is_clusters_scene(Scene) of
        false ->
            mod_drop:get_drops_info(none, RoleId, Scene, PoolId, CopyId, X, Y);
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_drop, get_drops_info, [Node, RoleId, Scene, PoolId, CopyId, X, Y])
    end;

%% 请求刷新npc状态
handle(12020, Status, []) ->
    mod_task:refresh_npc_ico(Status#player_status.tid, lib_task_api:ps2task_args(Status)),
    ok;

%% 怪物伤害列表
handle(12025, Status, [MonId]) ->
    #player_status{id = RoleId, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_scene, send_hurt_info, [node(), RoleId, MonId]),
    ok;

%% 场景特效改变
handle(12032, Status, []) ->
    #player_status{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, sid=Sid} = Status,
    Node = mod_disperse:get_clusters_node(),
    mod_scene_agent:send_dynamic_eff(Scene, ScenePoolId, CopyId, Sid, Node),
    ok;

%% 小飞鞋
handle(12033, Status, _) ->
    #player_status{id = _RoleId, sid = Sid} = Status,
    case check_fly_shoes(Status) of
        {false, ErrorRes} ->
            {ok, BinData} = pt_120:write(12033, [ErrorRes]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            {ok, BinData} = pt_120:write(12033, [?SUCCESS]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, Status#player_status{fly_state = 1}}
    end;

%% 超链接场景传送
handle(12034, Status, [TargetSceneId, TargetLine, TargetX, TargetY]) ->
    #player_status{sid = Sid, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId} = Status,
    {Code, NewPs} = case data_scene:get(TargetSceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_NORMAL; Type == ?SCENE_TYPE_OUTSIDE->
            case is_integer(CopyId) of %% 非整数不能切换
                false ->
                    {?ERRCODE(err120_cannot_transfer_to_target_scene), Status};
                true ->
                    %% 客户端线路转化成服务端线路
                    {RealPoolId, RealLine} = mod_scene_line:client_line_no_to_server(TargetLine),
                    if
                        SceneId == TargetSceneId andalso PoolId == RealPoolId andalso CopyId == RealLine ->
                            %% 同线路不能切换
                            {?ERRCODE(err120_already_in_scene), Status};
                        true ->
                            %% 检查键入场景
                            case lib_scene:check_enter(Status, 0, TargetSceneId) of
                                {false, ErrorCode} -> {ErrorCode, Status};
                                {true, TSceneId, _PoolId, _TCopyId, X, Y, Status1} ->
                                    Status2 = lib_scene:change_scene(Status1, TSceneId, RealPoolId, RealLine,
                                                                     X, Y, false, false, 0, []),
                                    NewStatus = Status2#player_status{pre_scene_time = 0, reconnect = 0},
                                    {?SUCCESS, NewStatus}
                            end
                    end
            end;
        _ ->
            {?ERRCODE(err120_cannot_transfer_to_target_scene), Status}
    end,
    lib_server_send:send_to_sid(Sid, pt_120, 12034, [Code, TargetX, TargetY]),
    {ok, NewPs};

%% 跨服服战场景传送
handle(12035, Status, [_X, _Y]) ->
    #player_status{id = _RoleId, sid = Sid, scene = _SceneId, fin_change_scene = FinChangeScene} = Status,
    case FinChangeScene == 0 of
        true ->
            ErrCode = ?ERRCODE(err120_scene_loading),
            EndX = 0, EndY = 0;
        _ ->
            ErrCode = ?ERRCODE(err601_not_in_act_scene),
            EndX = 0, EndY = 0
    end,
    {ok, BinData} = pt_120:write(12035, [ErrCode, EndX, EndY]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(12040, Status, _)->
    #player_status{id = RoleId, scene = SceneId,
                   scene_pool_id = PoolId, copy_id = CopyId} = Status,
    mod_scene_line:get_scene_lines_info(RoleId, SceneId, PoolId, CopyId);

handle(12041, Status, LineNo) when LineNo > 0 ->
    #player_status{scene = Scene, scene_pool_id = ScenePooldId,
                   copy_id = CopyId, x = X, y = Y, sid = Sid} = Status,
    LineSpan  = ?MAX_ONE_ROOM,
    NewLine   = LineNo - 1,
    NewPoolId = NewLine div LineSpan,
    RealLine  = max(0, NewLine - NewPoolId*LineSpan),
    %% {RealPoolId, RealLine} = mod_scene_line:client_line_no_to_server(LineNo),
    {IsChangeLine, ErrCode} = if
        NewLine == CopyId andalso ScenePooldId == NewPoolId ->
            {false, ?ERRCODE(err120_same_line)};
        true ->
            case data_scene:get(Scene) of
                #ets_scene{type = Type}
                  when Type == ?SCENE_TYPE_OUTSIDE; Type == ?SCENE_TYPE_NORMAL ->
                    NowTime = utime:unixtime(),
                    case catch mod_scene_line:check_can_enter_line(Scene, NewPoolId, RealLine, NowTime) of
                        true -> {true, ?SUCCESS};
                        _ -> {false, ?FAIL}
                    end;
                _ -> {false, ?FAIL}
            end
    end,
    {ok, BinData} = pt_120:write(12041, ErrCode),
    lib_server_send:send_to_sid(Sid, BinData),
    case IsChangeLine of
        false -> skip;
        true ->
            NewStatus = lib_scene:change_scene(Status, Scene, NewPoolId, RealLine, X, Y, false, false, []),
            {ok, NewStatus}
    end;

%% 怪物求助列表
handle(12043, Status, [MonId]) ->
    #player_status{sid = Sid, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    Node = node(),
    MonMsg = {'send_assist_data_list', Node, Sid},
    lib_mon:send_msg_to_mon_by_id(Scene, ScenePoolId, MonId, MonMsg),
    ok;

%% 客户端切换区域类型
handle(12085, Status, Type) ->
    {ok, BinData} = pt_120:write(12085, [Status#player_status.id, Type]),
    lib_server_send:send_to_area_scene(Status#player_status.scene, Status#player_status.scene_pool_id,
                                       Status#player_status.copy_id, Status#player_status.x, Status#player_status.y, BinData);

%% 玩家当前场景人数
handle(12087, Status, [0]) ->
    #player_status{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, sid=Sid} = Status,
    mod_scene_agent:send_number_info(Scene, ScenePoolId, CopyId, Sid);

handle(12087, Status, [SceneId]) ->
    #player_status{sid=Sid} = Status,
    case lib_scene:get_scene_type(SceneId) of
        ?SCENE_TYPE_KF_GREAT_DEMON ->
            ZoneId = lib_clusters_node_api:get_zone_id(),
            {PoolId, CopyId} =
                case ZoneId == 0 of
                    true -> {0, 0};
                    _ -> {ZoneId rem 12 + 1, ZoneId}
                end;
        _ ->
            PoolId = 0, CopyId = 0
    end,
    mod_scene_agent:send_number_info(SceneId, PoolId, CopyId, Sid);

handle(12088, Status, []) ->
    #player_status{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, sid=Sid} = Status,
    mod_scene_agent:send_user_info(Scene, ScenePoolId, CopyId, Sid);

% handle(12089, Status, _) ->
%     #player_status{id=RoleId, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, sid=Sid} = Status,
%     case lib_scene:is_outside_scene(Scene) of
%         true  -> mod_scene_agent:get_outside_online_user(Scene, ScenePoolId, CopyId, RoleId, Sid);
%         false -> skip
%     end,
%     ok;

%% 查询对象的buff列表
handle(12092, Status, [IdList]) ->
    #player_status{id=RoleId, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    Node = mod_disperse:get_clusters_node(),
    mod_scene_agent:send_object_buff_list(Scene, ScenePoolId, Node, RoleId, IdList);

%% 玩家进入场景的辅助信息
handle(12093, Status, []) ->
    #player_status{id=RoleId, scene=Scene, scene_pool_id=ScenePoolId} = Status,
    Node = mod_disperse:get_clusters_node(),
    PassivShareSkillL = lib_skill:get_passive_share_skill_list(Status),
    mod_scene_agent:send_role_assist_info(Scene, ScenePoolId, Node, RoleId, PassivShareSkillL);

handle(_Cmd, _Status, _Data) ->
    ?PRINT("no handle math ~p, ~p~n",  [_Cmd, _Data]),
    {error, "pp_scene no match"}.

%% ================================= private fun =================================
%% @doc 切换场景
%% DunId:非副本场景切换=0；副本场景：副本id
%% ChangeSceneId:切换的场景id
%% @end
%% 说明：reconnect默认为0，登录置为1，relogin置为2，首次切换场景后，会将reconnect置为0
change_scene(#player_status{sid = Sid, scene = OldSceneId, reconnect = Reconnect, fly_state = FlyState} = Status,
             DunId, ChangeSceneId, BackValue, TransType, TX, TY) ->
    if
        Reconnect == ?RECONNECT_NO ->
            if
                % FlyState == 0 andalso TransType =/= 0 -> %% 服务端不是小飞鞋状态，客户端请求飞鞋状态
                %     DataArgs = [0, 0, 0, ?ERRCODE(err120_transtype), 0, BackValue, TransType],
                %     lib_server_send:send_to_sid(Sid, pt_120, 12005, DataArgs),
                %     {ok, Status};
                true ->
                    {ok, NewStatus} = do_change_scene(Status, DunId, ChangeSceneId, BackValue, TransType, TX, TY),
                    {ok, NewStatus#player_status{fly_state = 0}}
            end;
        % 处于重连处理后的状态,则沿用旧场景信息
        Reconnect == ?RECONNECT_DEAL ->
            #player_status{scene = RoleSceneId, x = RoleX, y = RoleY} = Status,
            % case ChangeSceneId =/= RoleSceneId of
            %     true ->
            %         ?MYLOG("hjhscene", "12005 ChangeSceneId:~p OldSceneId:~p ~n",
            %             [ChangeSceneId, Status#player_status.scene]),
            %     false -> skip
            % end,
            DataArgs = [RoleSceneId, RoleX, RoleY, ?SUCCESS, DunId, BackValue, TransType],
            lib_server_send:send_to_sid(Sid, pt_120, 12005, DataArgs),
            {ok, Status#player_status{reconnect = ?RECONNECT_NO}};
        true -> %% 重连
            case lib_player_reconnect:reconnect(Status, Reconnect) of
                {ok, NewStatus} ->
                    {ok, NewStatus#player_status{reconnect = ?RECONNECT_NO}};
                {no, #player_status{scene = NewSceneId} = NewStatus} when NewSceneId=/=OldSceneId ->
                    {ok, NewStatus3} = do_change_scene(NewStatus, 0, NewSceneId, BackValue, TransType, TX, TY),
                    {ok, NewStatus3};
                {no, NewStatus} ->
                    {ok, NewStatus3} = do_change_scene(NewStatus, DunId, ChangeSceneId, BackValue, TransType, TX, TY),
                    {ok, NewStatus3};
                _ ->
                    {ok, NewStatus3} = do_change_scene(Status, DunId, ChangeSceneId, BackValue, TransType, TX, TY),
                    {ok, NewStatus3}
            end
    end.

do_change_scene(Status, DunId, ChangeSceneId, CallBackValue, TransType, TX, TY) ->
    #player_status{
       scene = RoleSceneId, x = RoleX, y = RoleY, sid = Sid,
       fin_change_scene = FinChangeScene, reconnect = Reconnect
    } = Status,
    if
        %% 已加载完成场景后，同场景切同场景的处理
        ChangeSceneId == RoleSceneId andalso (Reconnect == ?RE_LOGIN orelse FinChangeScene == 1) andalso TransType == 0 ->
            %% 重连的情况下都默认进入原来的场景
            DataArgs = [ChangeSceneId, RoleX, RoleY, ?SUCCESS, DunId, CallBackValue, TransType],
            lib_server_send:send_to_sid(Sid, pt_120, 12005, DataArgs),
            {ok, Status#player_status{reconnect = ?RECONNECT_NO}};
        true ->
            case lib_scene:check_enter(Status, DunId, ChangeSceneId) of
                {false, ErrorCode} ->
                    %% ?PRINT("~p ~p ErrorCode:~w~n", [?MODULE, ?LINE, [ErrorCode]]),
                    {ok, BinData} = pt_120:write(12005, [0, 0, 0, ErrorCode, 0, CallBackValue, TransType]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, Status#player_status{reconnect = ?RECONNECT_NO}};
                %% TransferType类型:1小飞鞋的，切换场景坐标使用客户端请求过来的坐标
                {true, TSceneId, _PoolId, _TCopyId, _TX, _TY, Status1} when TransType == 1->
                    NewStatus = lib_scene:change_scene(Status1, TSceneId, 0, 0,
                                                       TX, TY, false, true, TransType, []),
                    {ok, NewStatus#player_status{pre_scene_time = 0, reconnect = ?RECONNECT_NO}};
                {true, TSceneId, _PoolId, _TCopyId, TargetX, TargetY, Status1} ->
                    NewStatus = lib_scene:change_scene(Status1, TSceneId, 0, 0,
                                                       TargetX, TargetY, false, true, 0, []),
                    {ok, NewStatus#player_status{pre_scene_time = 0, reconnect = ?RECONNECT_NO}}
            end
    end.

%% 小飞鞋检查
check_fly_shoes(Status)->
    #player_status{scene = SceneId, fin_change_scene = FinChangeScene, vip = Vip} = Status,
%%    #role_vip{vip_lv = VipLv, endtime = EndTime} = Vip,
    #role_vip{vip_lv = VipLv} = Vip,
    if
        FinChangeScene == 0 -> {false, ?ERRCODE(err120_scene_loading)}; %% 场景还没有加载完
        true ->
            #ets_scene{type = Type} = data_scene:get(SceneId),
%%            NowTime = utime:unixtime(),
            if
                Type =/= ?SCENE_TYPE_NORMAL andalso Type =/= ?SCENE_TYPE_OUTSIDE -> %% 小飞鞋只能切主城和野外
                    {false, ?ERRCODE(err120_cannot_transfer_scene)};
                VipLv > 0 -> true;
%%                VipLv == 0 andalso EndTime > NowTime -> true;  %% vip体验卡
                true ->
                    case lib_goods_api:cost_object_list_with_check(Status, [{?TYPE_GOODS, ?GOODS_ID_SHOES, 1}], fly_shoes, "") of
                        {true, _} -> true;
                        {false, Res, _} -> {false, Res}
                    end
            end
    end.

%% ================================= 采集坐标 =================================

% %% 写入走路坐标
% input_move_pos(Status, TargetX, TargetY, Fly, FlyX, FlyY) ->
%     case get({move, Status#player_status.id, Status#player_status.scene}) of
%         undefined ->
%             put({move, Status#player_status.id, Status#player_status.scene}, {1, [{{TargetX, TargetY}, Fly, FlyX, FlyY, 1}]});
%         {Index, MoveList} ->
%             case lists:keyfind({TargetX, TargetY}, 1, MoveList) of
%                 false ->
%                     NewMoveList = [{{TargetX, TargetY}, Fly, FlyX, FlyY, Index+1}|MoveList],
%                     put({move, Status#player_status.id, Status#player_status.scene}, {Index + 1, NewMoveList});
%                 _ ->
%                     MoveList
%             end
%     end.

% %% 走路坐标采集
% get_move_pos(Status)->
%     %% 走路采集
%     case get({move, Status#player_status.id, Status#player_status.scene}) of
%         undefined ->
%             skip;
%         {Index, MoveList} ->
%             LogPath = config:get_log_path(),
%             FileName = lists:concat([LogPath, "/", "data_pos_", Status#player_status.scene, ".erl"]),
%             file:delete(FileName),
%             {ok, IoDevice} = file:open(FileName, [write, append]), %% {encoding, utf8}
%             F = "-module (data_pos_~p). ~n~n-compile(export_all).~n",
%             io:format(IoDevice, F, [Status#player_status.scene]),
%             Sort = lists:keysort(5, MoveList), %% 从前往后推
%             format_next_pos(Sort, Index, IoDevice),
%             file:close(IoDevice)
%     end.

% %% %% 从前往后推
% format_next_pos([{{X, Y}, Fly, FlyX, FlyY, I}|NextMoveList], Index, IoDevice)->
%     if
%         NextMoveList == [] ->
%             F = "get_next_pos(~p, ~p, ~p) -> {~p, ~p, ~p, ~p, ~p}; ~n get_next_pos(_, _, _) -> []. ~n~nget_max_index()-> ~p.",
%             io:format(IoDevice, F, [X, Y, I,  X, Y, Fly, FlyX, FlyY, Index]);
%         true ->
%             [{{NX, NY}, NFly, NFlyX, NFlyY, _NI}|_NNextMoveList] = NextMoveList,
%             if
%                 I == 1 ->
%                     F1 = "get_first_pos() -> {~p, ~p}.~n",
%                     io:format(IoDevice, F1, [X, Y]);
%                 true -> skip
%             end,
%             F = "get_next_pos(~p, ~p, ~p) -> {~p, ~p, ~p, ~p, ~p};~n",
%             io:format(IoDevice, F, [X, Y, I, NX, NY, NFly, NFlyX, NFlyY]),
%             format_next_pos(NextMoveList, Index, IoDevice)
%     end.
