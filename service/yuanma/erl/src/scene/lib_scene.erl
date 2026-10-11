%%%-----------------------------------
%%% @Module  : lib_scene
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.08
%%% @Description: 场景信息
%%%-----------------------------------
-module(lib_scene).
-export([
        user_move/11,
        change_scene/8,
        change_scene/9,
        change_scene/10,
        player_change_scene/8,
        player_change_scene/6,
        change_scene_queue/8,
        player_change_scene_queue/8,
        player_change_default_scene/2,
        player_change_relogin_scene/2,
        change_default_scene/2,
        change_relogin_scene/2,
        change_speed/8,
        leave_scene/1,
        leave_scene/3,
        enter_scene/1,
        del_all_area/3,
        send_scene_info_to_uid/6,
        revive_to_scene/2,
        get_data/1,
        change_area_mark/4,
        change_dynamic_eff/4,
        get_unblocked_xy/4,
        is_blocked/4,
        is_blocked_logic/4,
        can_be_moved/4,
        is_safe/4,
        is_safe_scene/1,
        is_outside_scene/1,
        is_clusters_scene/1,
        is_dynamic_scene/1,
        check_enter/3,
        check_requirement/2,
        is_enough_lv_enter/2,
        is_dungeon_scene/1,
        is_transferable/1,                 %% 是否可以传送.
        is_transferable_out/1,             %% 是否可以传送出去
        is_on_battle_status/1,
        get_on_battle_status_time/1,
        get_scene_name/1,
        get_born_xy/1,
        get_scene_type/1,
        get_origin_type/1,
        repair_xy/4,
        get_outside_scene_by_lv/1,
        is_broadcast_scene/1,
        change_scene_handler/4,
        get_main_city_x_y/0,
        is_in_main_city_scene/1,
        is_in_normal_and_outside/1,
        is_can_join_common_act/4,
        is_need_to_remove_hurt/1,
        is_dungeon_id/1,                   %% 掉线前是不是在副本里
        return_scene_user_tps/1,
        clear_scene_room/3,
        clear_scene/2,
        broadcast_player_attr/2,           %% 广播主角属性变化
        broadcast_player_attr/7,
        broadcast_player_figure/1,
        broadcast_player_ship_id/7,
        get_room_max_people/1,
        is_guild_scene/1,
        is_in_normal_and_outside_and_guild/1,
        is_near/6,                         %% 是否在附近
        check_enter_on_normal/2,           %%
        cls_enter_autoline_scene/8,           %% 跨服上自动选线进入场景
        change_scene_with_callback/10,         %% 进入某个场景并且调用一个函数
        get_room_list/2,
        send_hurt_info/3,
        get_mod_level/1
        , log_change_scene_and_return/1
        ]).

-export([gm_find_nearest_mon_auto_id/5]).

-include("server.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("language.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("kf_guild_war.hrl").
-include("eudemons_land.hrl").
-include("guild.hrl").
-include("def_event.hrl").

%% ----------------------------------------------------------------
%% @doc 玩家移动
%% @param X, Y    目标坐标像素
%% @param X2,Y2   原坐标像素
%% @param User    #ets_scene_user{}
%% ----------------------------------------------------------------
user_move(TX, TY, OX, OY, BX, BY, F, FX, FY, User, EtsScene) ->
    #ets_scene_user{
       id = Id,
       sid = Sid,
       scene = SceneId,
       copy_id = CopyId,
       hide_type = HideType
      } = User,
    {ok, BinData} = pt_120:write(12001, [BX, BY, Id, F, FX, FY]),
    if
        HideType =:= ?HIDE_TYPE_VISITOR ->
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            case lib_scene:is_broadcast_scene(SceneId) of
                true ->
                    lib_scene_agent:send_to_local_scene(User#ets_scene_user.copy_id, BinData);
                false ->
                    %% 移除
                    {ok, BinData1} = pt_120:write(12004, Id),
                    %% 有玩家进入
                    {ok, BinData2} = pt_120:write(12003, User),
                    %% 以目标区域人数来判断是否广播
                    AreaRoleCount = lib_scene_agent:get_area_num(lib_scene_calc:get_xy(TX, TY), CopyId),
                    MoveBroadCast = lib_scene_agent:check_move_broadcast(AreaRoleCount, Id),
                    lib_scene_calc:move_broadcast(MoveBroadCast, CopyId, TX, TY, OX, OY, BinData, BinData1, BinData2,
                        [User#ets_scene_user.node, User#ets_scene_user.sid], EtsScene)
            end
    end.


%% 游戏内更改玩家场景信息
%%@param Id             玩家ID
%%@param SceneId        目标场景ID
%%@param ScenePoolId    场景进程id 默认为0
%%@param CopyId         房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%%@param X              目标场景出生点X
%%@param Y              目标场景出生点Y
%%@param Need_Out       是否需要特殊处理场景   true|false（不需要）
%%@param KeyValueList   切换场景同步执行mod_sever_cast:set_data_sub/1 更新 player_status{} 的值
player_change_scene(Id, SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {'change_scene', SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList});
        _ ->
            void
    end.

player_change_scene(Id, SceneId, ScenePoolId, CopyId, NeedOut, KeyValueList) ->
    [X, Y] = get_born_xy(SceneId),
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {'change_scene', SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList});
        _ ->
            void
    end.

%%切换场景方法
%% PlayerStatus  玩家当前状态
%% TargetSceneId 目标场景ID
%% TargetScenePoolId 目标场景进程id 默认为0
%% TargetCopyId  房间号ID
%% TargetX       目标坐标X
%% TargetY       目标坐标Y
%% NeedOut       是否需要特殊处理场景   true | false（不需要）
%% AutoSeleLine  是否需要自动选择线路true|false
%% TransType     是否使用小飞鞋0|1
%% KeyValueList  切换场景同步执行mod_sever_cast:set_data_sub/1 更新 player_status{} 的值
%%@return 新玩家状态
change_scene(PlayerStatus, TargetSceneId, TargetScenePoolId,
             TargetCopyId, TargetX, TargetY, NeedOut, KeyValueList) ->
    TransType = 0, AutoSeleLine = true,
    change_scene(PlayerStatus, TargetSceneId, TargetScenePoolId, TargetCopyId,
                 TargetX, TargetY, NeedOut, AutoSeleLine, TransType, KeyValueList).

change_scene(PlayerStatus, TargetSceneId, TargetScenePoolId, TargetCopyId,
             TargetX, TargetY, NeedOut, AutoSeleLine, KeyValueList) ->
    TransType = 0,
    change_scene(PlayerStatus, TargetSceneId, TargetScenePoolId, TargetCopyId,
                 TargetX, TargetY, NeedOut, AutoSeleLine, TransType, KeyValueList).

%% 实际调用
%% 修改本函数要处理 lib_scene:change_relogin_scene 函数
change_scene(PlayerStatus, TargetSceneId, TargetScenePoolId, TargetCopyId,
    TargetX, TargetY, NeedOut, AutoSeleLine, TransType, KeyValueList) ->
    #player_status{id=Id, figure = #figure{lv = Lv, guild_id = GuildId},
        scene = NowSceneId, scene_pool_id = NowScenePoolId,
        copy_id = NowCopyId, x = NowX, y = NowY, team=Team,
        old_scene_info = OldSceneInfo, battle_attr = BA, status_kf_guild_war = StatusKfGWar, pk_map = PkMap} = PlayerStatus,

    %% 场景线路判断(修正进入的场景id,然后再随机进入相应的线路)
    {SceneId, X, Y, NSceneInfo} = if
        TargetSceneId =/= 0 andalso NeedOut == true -> %% 保留旧的场景信息，用于退出
            if
                TargetSceneId == NowSceneId ->
                    tool:back_trace_to_file(),
                    About = lists:concat(["NowSceneId:", NowSceneId, "serverId:", config:get_server_id()]),
                    lib_log_api:log_game_error(Id, 3, About);
                true ->
                    skip
            end,
            {TargetSceneId, TargetX, TargetY, {NowSceneId, NowScenePoolId, NowCopyId, NowX, NowY}};
        TargetSceneId =:= 0 andalso NeedOut == true -> %% 退出，返回到原来的场景
            case OldSceneInfo of
                {OldSceneId, _, _, Oldx, Oldy} ->
                    case GuildId == 0 andalso lib_guild:is_guild_scene(OldSceneId) of
                        false ->
                            {OldSceneId, Oldx, Oldy, undefined};
                        true ->
                            [TSceneId, TX, TY] = get_outside_scene_by_lv(Lv),
                            {TSceneId, TX, TY, undefined}
                    end;
                _ ->
                    [TSceneId, TX, TY] = get_outside_scene_by_lv(Lv),
                    {TSceneId, TX, TY, undefined}
            end;
        true ->
            case data_scene:get(TargetSceneId) of
                %#ets_scene{type=?SCENE_TYPE_OUTSIDE} -> lib_onhook:rand_a_outside_scene(Lv, {TargetSceneId, TargetX, TargetY, OldSceneInfo});
                #ets_scene{} -> {TargetSceneId, TargetX, TargetY,  OldSceneInfo};
                _ ->
                    [TSceneId, TX, TY] = get_outside_scene_by_lv(Lv),
                    {TSceneId, TX, TY, undefined}
            end
    end,
    %% 智能的选择一个酷酷的线路
    {NewPoolId, CopyId} = select_a_room(Id, AutoSeleLine, SceneId, TargetScenePoolId, TargetCopyId),
    %% pk状态强制切换
    PkArgs = case data_scene:get(SceneId) of
        #ets_scene{subtype=Subtype, requirement=Requirement} when
                Subtype == ?SCENE_SUBTYPE_KILL_MON;
                Subtype == ?SCENE_SUBTYPE_SAFE;
                Subtype == ?SCENE_SUBTYPE_PK;
                Subtype == ?SCENE_SUBTYPE_NORMAL;
                Subtype == ?SCENE_SUBTYPE_SELECT ->
            case lists:keyfind(pkstate, 1, Requirement) of
                {_, PkType} when PkType /= BA#battle_attr.pk#pk.pk_status -> [{pk, {PkType, true}}];
                _ -> []
            end;
        _ -> []
    end,
    NewPkArgs = case maps:find(SceneId, PkMap) of
        {ok, PkType1} ->
            % 是否在可切的pk列表中
            IsInPkTypeL = case data_scene:get(SceneId) of
                #ets_scene{subtype=Subtype1, requirement=Requirement1} when Subtype1 == ?SCENE_SUBTYPE_PK ->
                    case lists:keyfind(pkstate, 1, Requirement1) of
                        {_, PkType1} -> true;
                        _ -> false
                    end;
                #ets_scene{subtype=Subtype1} when Subtype1 == ?SCENE_SUBTYPE_NORMAL -> lists:member(PkType1, ?PK_NORMAL_L);
                #ets_scene{subtype=Subtype1, requirement=Requirement1} when Subtype1 == ?SCENE_SUBTYPE_SELECT ->
                    case lists:keyfind(pkstate_list, 1, Requirement1) of
                        {_, PkTypeL} -> lists:member(PkType1, PkTypeL);
                        _ -> false
                    end;
                _ ->
                    false
            end,
            case IsInPkTypeL of
                true when PkType1 /= BA#battle_attr.pk#pk.pk_status -> [{pk, {PkType1, true}}];
                true -> [];
                false -> PkArgs
            end;
        _ ->
            PkArgs
    end,
    % ?PRINT("PkArgs:~p NewPkArgs:~p Pk:~p Now:~p ~n", [PkArgs, NewPkArgs, maps:find(SceneId, PkMap), BA#battle_attr.pk#pk.pk_status]),
    %% 离开场景前，清理buff
    PlayerStatus1 = clean_scene_buff(PlayerStatus, SceneId, NowSceneId),
    %% 离线场景
    leave_scene(PlayerStatus1),
    {BfKeyValueList, AfKeyValueList} = partition_change_scene_bf_and_af_kv_list(KeyValueList),
    %% 对原场景处理
    KvPlayerStatus = mod_server_cast:set_data_sub(BfKeyValueList, PlayerStatus1),
    %% Ps赋值
    NewStatusKfGWar = StatusKfGWar#status_kf_guild_war{in_sea = 0},     %% 玩家切换场景的时候重置为陆地状态
    NewPlayerStatus = KvPlayerStatus#player_status{scene = SceneId, scene_pool_id = NewPoolId,
        copy_id = CopyId, x = X, y = Y, change_scene_sign=0,
        leave_scene_sign = 0, old_scene_info = NSceneInfo, status_kf_guild_war = NewStatusKfGWar},
    PsAfAtuoMountRide = lib_player:auto_change_ride_mount_status_slient(NewPlayerStatus),
    %% 切场景处理（清除buff,重新计算属性,Kv赋值等）
    SyncSceneStatus = change_scene_handler(PsAfAtuoMountRide, SceneId, NowSceneId, NewPkArgs++AfKeyValueList),
    #player_status{dungeon = #status_dungeon{dun_id = DunId} } = SyncSceneStatus,
    %% 通知客户端切换场景
    {ok, Bin} = pt_120:write(12005, [SceneId, X, Y, ?SUCCESS, DunId, 0, TransType]),
    lib_server_send:send_to_sid(PlayerStatus1#player_status.sid, Bin),
    %% 队员位置修改通知
    lib_team_api:where_i_am(Team#status_team.team_id, Id, SceneId, NewPoolId, CopyId),
    %% 跟随发送坐标到组队进程
    lib_team_api:change_location(SyncSceneStatus),
    case SyncSceneStatus#player_status.online of %% 离线中，服务端自动切换12002
        ?ONLINE_OFF -> lib_player:update_player_info(SyncSceneStatus#player_status.id, [{just_load_scene_auto, 0}]);
        _ -> skip
    end,
    SyncSceneStatus#player_status{fin_change_scene = 0}.

%% 选择一个线路
select_a_room(RoleId, AutoLine, SceneId, PoolId, CopyId) ->
    SceneData = data_scene:get(SceneId),
    if
        SceneData == [] -> {PoolId, CopyId};
        true ->
            #ets_scene{type = Type} = SceneData,
            case lists:member(Type, ?SCENE_TYPE_NEED_SUB_LINE) of
                false -> {PoolId, CopyId};
                true ->
                    case catch mod_scene_line:get_poolid_copyid(AutoLine, SceneId, PoolId, CopyId, RoleId) of
                        {'EXIT', _} = R ->
                            ?ERR("select_a_poolid_copyid, Args:~p, Error:~p~n",
                                 [[RoleId, AutoLine, SceneId, PoolId, CopyId], R]),
                            {PoolId, CopyId};
                        {NewPoolId, NewCopyId} ->
                            {NewPoolId, NewCopyId};
                        Other ->
                            ?ERR("select_a_poolid_copyid, Args:~p, Error:~p~n",
                                 [[AutoLine, SceneId, PoolId, CopyId], Other]),
                            {PoolId, CopyId}
                    end
            end
    end.

%% 分离切换场景之前和之后的kvlist
partition_change_scene_bf_and_af_kv_list(KvList) ->
    KvF = fun(Kv) ->
        case Kv of
            {K, _V} -> lists:member(K, [change_scene_hp_lim, change_scene_hp]);
            _ -> false
        end
    end,
    lists:partition(KvF, KvList).

%% 游戏内更改玩家场景信息(公共线调用)
%%@param Id                      玩家ID
%%@param SceneId                 目标场景ID
%%@param ScenePoolId             目标场景进程id
%%@param CopyId                  房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%%@param X                       目标场景出生点X
%%@param Y                       目标场景出生点Y
%%@param KeyValueList =  lists() 用于在换场景后的数据处理,换线后会执行mod_server_cast:set_data_sub(Value, Status)
%%                      | 0      不做处理
player_change_scene_queue(Id, SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            catch gen_server:cast(Pid, {'change_scene_sign', [SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList]});
        _ ->
            void
    end.

%%排队-切换场景方法
%%@param PlayerStatus   玩家当前状态
%%@param SceneId        目标场景ID
%%@param CopyId         房间号ID
%%@param ScenePoolId    目标场景进程id
%%@param X              目标坐标X
%%@param Y              目标坐标Y
%%@param KeyValueList   自定义结构,用于在换场景后的数据处理
%%@return
change_scene_queue(PlayerStatus, SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList) ->
    catch gen_server:cast(PlayerStatus#player_status.pid, {'change_scene_sign', [SceneId, ScenePoolId, CopyId, X, Y, NeedOut, KeyValueList]}).

%%更改玩家到默认场景
player_change_default_scene(Id, KeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {'change_default_scene', KeyValueList});
        _ ->
            void
    end.

change_default_scene(Status, KeyValueList) ->
    [SceneId, TargetX, TargetY] = get_outside_scene_by_lv(Status#player_status.figure#figure.lv),
    TargetScenePoolId = 0,
    TargetCopyId = 0,
    KeyValueList2= [{group, 0}, {ghost, 0}] ++ KeyValueList,
    change_scene(Status, SceneId, TargetScenePoolId, TargetCopyId, TargetX, TargetY, false, KeyValueList2).

%%更改玩家到relogin场景
player_change_relogin_scene(Id, KeyValueList) ->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {'change_relogin_scene', KeyValueList});
        _ ->
            void
    end.

%% 重连场景
%% 本函数跟 lib_scene:change_scene 关联, 在不影响重连机制(跟下线前的玩家数据一致)下，尽量相同，同步好数据到各个模块。
change_relogin_scene(Status, KeyValueList) ->
    #player_status{
        id = Id,
        team = Team,
        scene = SceneId,
        scene_pool_id = PoolId,
        copy_id = CopyId,
        x = X,
        y = Y
        } = Status,
    case data_scene:get(SceneId) of
        #ets_scene{} ->
            % 校验离开场景:防止ps和场景的数据不一致
            vaild_leave_scene(Status),
            %% 切场景处理（清除buff,重新计算属性,Kv赋值等）
            SyncSceneStatus = change_scene_handler(Status, SceneId, SceneId, KeyValueList),
            #player_status{dungeon = #status_dungeon{dun_id = DunId}, x = X1, y = Y1} = SyncSceneStatus,
            %% 通知客户端切换场景
            {ok, Bin} = pt_120:write(12005, [SceneId, X1, Y1, ?SUCCESS, DunId, 0, 0]),
            lib_server_send:send_to_sid(Status#player_status.sid, Bin),
            %% 队员位置修改通知
            lib_team_api:where_i_am(Team#status_team.team_id, Id, SceneId, PoolId, CopyId),
            %% 跟随发送坐标到组队进程
            lib_team_api:change_location(SyncSceneStatus),
            case SyncSceneStatus#player_status.online of %% 离线中，服务端自动切换12002
                ?ONLINE_OFF -> lib_player:update_player_info(SyncSceneStatus#player_status.id, [{just_load_scene_auto, 0}]);
                _ -> skip
            end,
            SyncSceneStatus#player_status{fin_change_scene = 0};
        _ ->
            change_scene(Status, SceneId, PoolId, CopyId, X, Y, false, KeyValueList)
    end.

%%改变速度
change_speed(Id, Scene, ScenePoolId, CopyId, X, Y, Speed, Sign)->
    {ok, BinData} = pt_120:write(12082, [Sign, Id, Speed]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData).

%%离开当前场景
%% Sid:场景id
%% player_status:记录
leave_scene(Status) ->
    mod_scene_agent:leave(Status).

%% 校验场景，玩家ps和场景ets_scene_user一致不离开场景
vaild_leave_scene(Status) ->
    mod_scene_agent:vaild_leave(Status).

%% @doc 处理离开场景操作:根据Type:做离开场景的处理(不在玩家进程时调用)
%% -spec leave_scene(Pid|Id, Type, Args) -> ok when
%%    Id          :: integer(),                %% 玩家id
%%    Pid         :: pid(),                    %% 玩家进程pid
%%    Type        :: all,                      %% all
%%    Args        :: list().                   %% 列表
%% @end
%% -----------------------------------------------------------
leave_scene(Pid, Type, Args) when is_pid(Pid)->
    gen_server:cast(Pid, {'leave_scene', Type, Args});
leave_scene(Id, Type, Args) when is_integer(Id)->
    case misc:get_player_process(Id) of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {'leave_scene', Type, Args});
        _ ->
            ok
    end;
leave_scene(_Id, _Type, _Args)->
    ok.


%%进入当前场景
%%player_status记录
enter_scene(Status) ->
    mod_scene_agent:join(Status).

%%给用户发送场景信息 - 12002内容
send_scene_info_to_uid(Key, Sid, ScenePoolId, CopyId, X, Y) ->
    mod_scene_agent:send_scene_info_to_uid(Key, Sid, ScenePoolId, CopyId, X, Y).

%% 删除怪物9宫格
del_all_area(SceneId, ScenePoolId, CopyId) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, del_all_area, [CopyId]).

%% 复活进入场景
%% status复活前的状态，status1复活后的状态
revive_to_scene(Status1, Status2) ->
    %%告诉原来场景玩家你已经离开
    leave_scene(Status1),
    %%告诉复活点的玩家你进入场景进
    enter_scene(Status2),
    send_scene_info_to_uid(Status2#player_status.id, Status2#player_status.scene, Status2#player_status.scene_pool_id,
                           Status2#player_status.copy_id, Status2#player_status.x, Status2#player_status.y).


%% 获取场景信息，唯一id，区分是不是副本
get_data(Id) -> %data_scene:get(Id).
    case ets:lookup(?ETS_SCENE, Id) of
        []  -> data_scene:get(Id);
        [S] -> S
    end.

%% @doc 进入场景条件检查并且根据副本类型做相关处理
%% DunId:副本id
%% ChangeSceneId：切换的场景id
%% @end
check_enter(Status, _DunId, ChangeSceneId) ->
    case check_enter_on_normal(Status, ChangeSceneId) of
        {false, ErrorCode} -> {false, ErrorCode};
        {ok, _Scene, TX, TY} ->
            {true, ChangeSceneId, Status#player_status.scene_pool_id,  Status#player_status.copy_id, TX, TY, Status}
    end.

%% 进入场景条件检查(处理场景的基本检查)
check_enter_on_normal(Status, ChangeSceneId) ->
    #player_status{scene = PlayerSceneId, copy_id=_CopyId, x=X, y=Y,
                  figure = #figure{lv=_Lv}} = Status,
    PlayerScene = case data_scene:get(PlayerSceneId) of   %% 玩家当前场景数据.
                      [] -> #ets_scene{};
                      SceneData -> SceneData
                  end,
    case data_scene:get(ChangeSceneId) of        %% 判断场景是否可以传送.
        Scene when is_record(Scene, ets_scene) ->
            case check_requirement(Status, Scene#ets_scene.requirement) of
                {false, Reason} -> {false, Reason};
                true ->
                    {IsTransable, ErrorCode} = is_transferable(Status),
                    IsForbid = check_forbidden_scene_id(ChangeSceneId),
                    if
                        IsTransable == false ->
                            {false, ErrorCode};
                        IsForbid == true ->
                            {false, ?ERRCODE(err120_cannot_transfer_scene)};
                        ChangeSceneId == PlayerSceneId -> %% 同场景切换,坐标不变
                            {ok, Scene, X, Y};
                        ChangeSceneId == ?BORN_SCENE ->  %% 特殊情况没有完成特殊的出生任务
                            {BornX, BornY} = ?BORN_SCENE_COORD,
                            {ok, Scene, BornX, BornY};
                        true ->
                            {_IsNearElem, ChangeSceneX, ChangeSceneY}
                            = case lists:keyfind(ChangeSceneId, 1, PlayerScene#ets_scene.elem) of
                                {_, LocX, LocY, TransX, TransY} -> {abs(X-LocX)<300 andalso abs(Y-LocY)<200, TransX, TransY};
                                _ -> {false, Scene#ets_scene.x, Scene#ets_scene.y}
                            end,
                            {ok, Scene, ChangeSceneX, ChangeSceneY}
                    end
            end;
        _ -> {false, ?ERRCODE(err120_cannot_transfer_scene_not_exist)}
    end.

%% 检查是不是禁止通过12005的协议进入
check_forbidden_scene_id(ChangeSceneId)->
    BossScene = lib_boss:is_in_all_boss(ChangeSceneId),
    EudemonsLandScene = lib_eudemons_land:is_in_eudemons_boss(ChangeSceneId),
    IsForbid = lists:member(ChangeSceneId, ?FORBID_SCENE_IDS),
    BossScene orelse EudemonsLandScene orelse IsForbid.

%% 逐个检查进入需求
check_requirement(_, []) ->
    true;
check_requirement(Status, [{K, V} | T]) ->
    case K of
        lv -> %% 等级需求
            case check_scene_worldlist(V, Status#player_status.figure#figure.lv) of
                {true, _} ->
                    check_requirement(Status, T);
                false ->
                    {false, ?ERRCODE(err120_cannot_transfer_lv_not_reach)}
            end;
        _ ->
            check_requirement(Status, T)
    end.

%% 玩家是否达到进入场景等级条件
is_enough_lv_enter(Lv, SceneId) ->
    case data_scene:get(SceneId) of
        [] -> false;
        #ets_scene{} = Scene ->
            case check_scene_lv(Scene, Lv) of
                {true, _} -> true;
                _ -> false
            end
    end.

%% 更改区域属性
%% ClientType:0可行走 1障碍区, 5安全区
%% AreaMarkL: [{AreaId, ClientMark},...]
change_area_mark(SceneId, ScenePoolId, CopyId, AreaMarkL) ->
    SerAreaMarkL = lib_scene_mark:mark_c2s(AreaMarkL),
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, change_area_mark, [CopyId, SerAreaMarkL]),
    mod_scene_mark:change_area_mark(SceneId, CopyId, SerAreaMarkL),
    {ok, BinData} = pt_120:write(12030, AreaMarkL),
    lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
    ok.

%% 更改场景特效状态
%% EffChangeValues = [{EffId, DelOrAdd},...]
%% -- EffId:特效id
%% -- DelOrAdd (0隐藏|1增加)
change_dynamic_eff(SceneId, ScenePoolId, CopyId, EffChangeValues) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, change_dynamic_eff, [CopyId, EffChangeValues]),
    {ok, BinData} = pt_120:write(12032, [SceneId, EffChangeValues]),
    lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
    ok.

%% 是否为副本场景，唯一id，会检查是否存在这个场景
is_dungeon_scene(Id) ->
    case data_scene:get(Id) of
        [] -> false;
        S -> S#ets_scene.type =:= ?SCENE_TYPE_DUNGEON orelse S#ets_scene.type == ?SCENE_TYPE_MAIN_DUN
    end.

%% 是否在副本里
is_dungeon_id(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> false;
        _Dun -> true
    end.

%% 是否可以传送
is_transferable(#player_status{
                   scene = SceneId, copy_id = CopyId, x = Xpx, y = Ypx,
                   change_scene_sign = IsChangeSceneSign,
                   last_att_time = LastAttTime, last_beatt_time = LastBeAttTime
                  } = _Status)->
    LongTime = utime:longunixtime(),
    if
        %% 排队换线中
        IsChangeSceneSign==1 ->
            {false, ?ERRCODE(err120_cannot_transfer_change_scene_sign)};
        LastAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime orelse
        %% 处于战斗状态无法传送
        LastBeAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime ->
            {false, ?ERRCODE(err120_cannot_transfer_on_battle)};
        %% ActionLock =/= free ->
        %%     {false, ActionLock};
        true ->
            is_transferable(SceneId, CopyId, Xpx, Ypx)
    end.

is_transferable(SceneId, _CopyId, _Xpx, _Ypx) ->
    case data_scene:get(SceneId) of
        [] ->
            {false, ?ERRCODE(err120_cannot_transfer_scene)};
        %% 主城场景
        #ets_scene{type = ?SCENE_TYPE_NORMAL} -> {true, 1};
        %% %% 公会场景
        %% #ets_scene{type = ?SCENE_TYPE_GUILD} -> {true, 1};
        %% 野外场景的安全区
        #ets_scene{type = ?SCENE_TYPE_OUTSIDE} -> {true, 1};
        %% 剧情场景可以传送
        #ets_scene{type = ?SCENE_TYPE_STORY} -> {true, 1};
        %% %% Boss场景
        %% #ets_scene{type = ?SCENE_TYPE_BOSS} -> {true, 1};
        %% 其他场景都不可以传送.
        %% 众生之门场景
        #ets_scene{type = ?SCENE_TYPE_BEINGS_GATE} -> {true, 1};
        % 百鬼夜行可传送
        #ets_scene{type = ?SCENE_TYPE_NIGHT_GHOST} -> {true, 1};
        _ ->
            {false, ?ERRCODE(err120_cannot_transfer_scene)}
    end.

%% 功能通用离开判断
is_transferable_out(#player_status{
                       change_scene_sign = IsChangeSceneSign,
                       last_att_time = LastAttTime, last_beatt_time = LastBeAttTime
                      } = _Status)->
    LongTime = utime:longunixtime(),
    if
        %% 排队换线中
        IsChangeSceneSign==1 ->
            {false, ?ERRCODE(err120_cannot_transfer_change_scene_sign)};
        LastAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime orelse
        % 处于战斗状态无法传送
        LastBeAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime ->
            {false, ?ERRCODE(err120_cannot_transfer_on_battle)};
        true ->
            {true, 1}
    end.

%% 是否在战斗状态内
is_on_battle_status(#player_status{last_att_time = LastAttTime, last_beatt_time = LastBeAttTime}) ->
    LongTime = utime:longunixtime(),
    if
        LastAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime orelse
        % 处于战斗状态无法传送
        LastBeAttTime + ?ESCAPE_ATT_TIME*1000 - 500 > LongTime ->
            true;
        true ->
            false
    end.

%% 获得战斗状态时间
get_on_battle_status_time(#player_status{last_att_time = LastAttTime, last_beatt_time = LastBeAttTime}) ->
    max(LastAttTime + ?ESCAPE_ATT_TIME*1000, LastBeAttTime + ?ESCAPE_ATT_TIME*1000).

%% 获得非障碍点
get_unblocked_xy([], _SceneId, _CopyId, Default) -> Default;
get_unblocked_xy([{X, Y}|T], SceneId, CopyId, Default) ->
    case is_blocked(SceneId, CopyId, X, Y) of
        true -> get_unblocked_xy(T, SceneId, CopyId, Default);
        false -> {X, Y}
    end.

%% 判断在场景SID的[X,Y]坐标是否有障碍物
%% return:ture有障碍物,false无障碍物
is_blocked(Sid, CopyId, Xpx, Ypx) ->
    OriginType = get_origin_type(Sid),
    {Xl, Yl} = lib_scene_calc:pixel_to_logic_coordinate(OriginType, Xpx, Ypx),
    mod_scene_mark:is_pos(Sid, CopyId, Xl, Yl, ?SCENE_MASK_BLOCK).

is_blocked_logic(Sid, CopyId, Xl, Yl) ->
    mod_scene_mark:is_pos(Sid, CopyId, Xl, Yl, ?SCENE_MASK_BLOCK).

%% 判断在场景Sid 的像素坐标是否在安全区
is_safe(Sid, CopyId, Xpx, Ypx) ->
    OriginType = get_origin_type(Sid),
    {Xl, Yl} = lib_scene_calc:pixel_to_logic_coordinate(OriginType, Xpx, Ypx),
    case data_scene:get(Sid) of
        [] -> false;% 非安全区
        #ets_scene{subtype=?SCENE_SUBTYPE_SAFE} -> true;
        _ ->
            case mod_scene_mark:is_pos(Sid, CopyId, Xl, Yl, ?SCENE_MASK_SAFE) of
                true -> true; % 安全区
                _    -> false
            end
    end.

%% 判断是否安全场景
is_safe_scene(Sid) ->
    case data_scene:get(Sid) of
        #ets_scene{subtype=?SCENE_SUBTYPE_SAFE} -> true;
        _ -> false
    end.

%% 判断是否野外场景
is_outside_scene(Sid) ->
    case data_scene:get(Sid) of
        #ets_scene{type=?SCENE_TYPE_OUTSIDE} -> true;
        _ -> false
    end.

%% 是否跨服场景
is_clusters_scene(SceneId) ->
    case data_scene:get(SceneId) of
        [] -> false;% 非跨服场景
        Scene -> Scene#ets_scene.cls_type == ?SCENE_CLS_TYPE_CENTER
    end.

%% 是否动态区域场景
is_dynamic_scene(SceneId) ->
    case data_dynamicarea:get(SceneId) of
        [] -> false;
        _  -> true
    end.

%% 获取场景名称
get_scene_name(SceneId) ->
    case data_scene:get(SceneId) of
        []  -> <<>>;
        S -> util:make_sure_binary(S#ets_scene.name)
    end.

%% 获取当前场景出生点
get_born_xy(Sid) ->
    case data_scene:get(Sid) of
        [] -> [1, 1];
        Scene -> [Scene#ets_scene.x, Scene#ets_scene.y]
    end.

%% 获取场景类型
get_scene_type(SceneId) ->
    case data_scene:get(SceneId) of
        []  -> ?SCENE_TYPE_NORMAL;
        S -> S#ets_scene.type
    end.

%% 获取原点类型(yy3d默认都是左下)
%% 目前含义是2d和3d类型
get_origin_type(SceneId) ->
    case data_scene:get(SceneId) of
        []  -> ?MAP_ORIGIN_LU;
        S -> S#ets_scene.origin_type
    end.

%% 玩家登录|玩家重连修复场景坐标位置
%% Ps:玩家Ps; Scene:场景Id;
%% 返回：[SceneId, X, Y]
repair_xy(Ps, SceneId, X, Y) ->
    #player_status{figure = #figure{lv = Lv}} = Ps,
    case data_scene:get(SceneId) of
        [] -> get_outside_scene_by_lv(Lv);
        #ets_scene{type = SceneType} when
              SceneType == ?SCENE_TYPE_DUNGEON orelse SceneType == ?SCENE_TYPE_GUILD orelse
              SceneType == ?SCENE_TYPE_ACTIVE orelse  SceneType == ?SCENE_TYPE_VOID_FAM orelse
              SceneType == ?SCENE_TYPE_TOPPK orelse   SceneType == ?SCENE_TYPE_BOSS orelse
              SceneType == ?SCENE_TYPE_WAITING orelse SceneType == ?SCENE_TYPE_GWAR orelse
              SceneType == ?SCENE_TYPE_KF_HEGEMONY orelse SceneType == ?SCENE_TYPE_WORLD_BOSS orelse
              SceneType == ?SCENE_TYPE_EUDEMONS_BOSS orelse SceneType == ?SCENE_TYPE_TEMPLE_BOSS orelse
              SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS orelse SceneType == ?SCENE_TYPE_SUIT_BOSS orelse
              SceneType == ?SCENE_TYPE_HOME_BOSS orelse SceneType == ?SCENE_TYPE_MAIN_DUN orelse
              SceneType == ?SCENE_TYPE_KF_TEMPLE orelse SceneType == ?SCENE_TYPE_HOUSE orelse
              SceneType == ?SCENE_TYPE_SAINT orelse SceneType == ?SCENE_TYPE_KF_1VN_BATTLE orelse
              SceneType == ?SCENE_TYPE_GUILD_FEAST orelse
              SceneType == ?SCENE_TYPE_KF_GWAR; SceneType == ?SCENE_TYPE_OUTSIDE_BOSS; SceneType == ?SCENE_TYPE_ABYSS_BOSS;
              SceneType == ?SCENE_TYPE_JJC; SceneType == ?SCENE_TYPE_NINE;
              SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS; SceneType == ?SCENE_TYPE_GUILD_DUN; SceneType == ?SCENE_TYPE_PHANTOM_BOSS;
              SceneType == ?SCENE_TYPE_FEAST_BOSS; SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;SceneType == ?SCENE_TYPE_SPECIAL_BOSS;
              SceneType == ?SCENE_TYPE_GLADIATOR; SceneType == ?SCENE_TYPE_TERRITORY ; SceneType == ?SCENE_TYPE_SANCTUARY;
              SceneType == ?SCENE_TYPE_KF_SANCTUARY;  SceneType == ?SCENE_TYPE_WEDDING;  SceneType == ?SCENE_TYPE_MIDDAY_PARTY;
              SceneType == ?SCENE_TYPE_KF_3v3; SceneType == ?SCENE_TYPE_DOMAIN_BOSS; SceneType == ?SCENE_TYPE_SANCTUM;
              SceneType == ?SCENE_TYPE_DECORATION_BOSS;  SceneType == ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS;
              SceneType == ?SCENE_TYPE_HOLY_SPIRIT_BATTLE; SceneType == ?SCENE_TYPE_ESCORT; SceneType == ?SCENE_TYPE_SEACRAFT ;
              SceneType == ?SCENE_TYPE_SEACRAFT_DAILY; SceneType == ?SCENE_TYPE_SEA_TREASURE; SceneType == ?SCENE_TYPE_TEMPLE_AWAKEN;
              SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER; SceneType == ?SCENE_TYPE_WORLD_BOSS_PER ;SceneType == ?SCENE_TYPE_KF_GREAT_DEMON->
            get_outside_scene_by_lv(Lv);
        SceneR ->
            repair_block(SceneR, SceneId, X, Y)
    end.

%% 获取到对应等级的野外场景
%% 返回：[SceneId, X, Y]
get_outside_scene_by_lv(Lv) ->
    OutSideSceneIds = data_scene:get_id_list_by_type(?SCENE_TYPE_OUTSIDE),
    {XBron, YBron} = ?BORN_SCENE_COORD,
    F = fun(TmpSceneId, {OLv, OScene, OX, OY}) ->
        case data_scene:get(TmpSceneId) of
            #ets_scene{x=TmpX, y=TmpY} = TmpSceneR ->
                case check_scene_lv(TmpSceneR, Lv) of
                    {true, MinLv} when MinLv >= OLv -> {MinLv, TmpSceneId, TmpX, TmpY};
                    _ -> {OLv, OScene, OX, OY}
                end;
            _ -> {OLv, OScene, OX, OY}
        end
    end,
    {_, Scene, X, Y} = lists:foldl(F, {0, ?BORN_SCENE, XBron, YBron}, OutSideSceneIds),
    [Scene, X, Y].

%% 修复处于障碍点或者地图边界外的坐标点
%% 返回：[SceneId, X, Y]
repair_block(SceneR, SceneId, X, Y) ->
    case is_blocked(SceneId, 0, X, Y) of
        true -> [SceneId, SceneR#ets_scene.x, SceneR#ets_scene.y];
        false ->
            case X =< 0 orelse SceneR#ets_scene.width =< X orelse
                Y =< 0 orelse SceneR#ets_scene.height =< Y of
                true  -> [SceneId, SceneR#ets_scene.x, SceneR#ets_scene.y];
                false -> [SceneId, X, Y]
            end
    end.

%% 判断改场景是否能进入
%% 返回: {true, 最低等级}|false
check_scene_lv(SceneId, Lv) when is_integer(SceneId) ->
    case data_scene:get(SceneId) of
        [] -> false;
        Scene -> check_scene_lv(Scene, Lv)
    end;
check_scene_lv(#ets_scene{requirement=Requirement}, Lv) ->
    case lists:keyfind(lv, 1, Requirement) of
        false -> {true, 0};
        {lv, WorldLvList} -> check_scene_worldlist(WorldLvList, Lv);
        _ -> false
    end.
check_scene_worldlist(WorldLvList, Lv) ->
    case WorldLvList of
        [] -> {true, 0};
        EnterLv when is_integer(EnterLv), Lv >= EnterLv -> {true, EnterLv};
        _ when is_list(WorldLvList) ->
            WorldLv = util:get_world_lv(),
            % [{世界等级,玩家等级}]
            OpenLv  = util:term_area_value(WorldLvList, 1, 2, WorldLv),
            case Lv >= OpenLv of
                true -> {true, OpenLv};
                false -> false
            end;
        _ -> false
    end.

%% 是否需要场景广播
is_broadcast_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{broadcast= ?BROADCAST_ALL} -> true;
        _ -> false
    end.

%% 是否可以移动到(X[px],Y[px])坐标
%% Sid 场景ii
can_be_moved(Sid, CopyId, X, Y) ->
    case is_blocked(Sid, CopyId, X, Y) of %% 是否障碍物
        true  -> false;
        false ->
            case data_scene:get(Sid) of
                [] -> true;
                Data ->
                    X > 0 andalso Y > 0 andalso X =< Data#ets_scene.width andalso Y =< Data#ets_scene.height %% 是否场景外
            end
    end.

%% 切换场景需要处理的操作
change_scene_handler(Status, EnterSceneId, LeaveSceneId, KeyValueList) ->
    %% 重新计算物品buff属性
    %% 如果buff属性没有变化不会重复计算战力
    {ok, NewStatus} = lib_goods_buff:check_player_buff(Status),
    EnterIsDunScene = is_dungeon_scene(EnterSceneId),
    LeaveIsDunScene = is_dungeon_scene(LeaveSceneId),
    NewPs = if
        %% 副本处理 , 天空战场体验版
        %% 新手副本额外赋予1000点命中
        % EnterSceneId == ?CREATE_ROLE_DUN_SCENE ->
        %     NewPlayer = lib_skill:create_role_full_skill(NewStatus),
        %     BattleAttr = NewPlayer#player_status.battle_attr,
        %     Attr = BattleAttr#battle_attr.attr,
        %     Hit = Attr#attr.hit,
        %     NewPlayer#player_status{battle_attr = BattleAttr#battle_attr{attr = Attr#attr{hit = Hit+1000}}};
        % LeaveSceneId == ?CREATE_ROLE_DUN_SCENE ->
        %     NewPlayer = lib_skill:clear_role_full_skill(NewStatus),
        %     lib_skill:get_my_skill_list(NewPlayer),
        %     lib_player:count_player_attribute(NewPlayer);
        EnterIsDunScene == true andalso LeaveIsDunScene == false ->
            lib_player:count_player_attribute(NewStatus);
        true ->
            NewStatus
    end,
    %%将神的处理
    NewPS2 = lib_god_summon:change_scene(NewPs, EnterSceneId, LeaveSceneId),
    %% 免战保护处理
    PsAfProtect = lib_protect:change_scene(NewPS2, EnterSceneId, LeaveSceneId),
    %% 公会协助协助处理
    PsAfAssist = lib_guild_assist:change_scene(PsAfProtect, EnterSceneId, LeaveSceneId),
    %% 挂机
    PsAfAfk = lib_afk:change_scene(PsAfAssist),
    %% Kv赋值(!!! 其他函数一般是放到前面)
    PsAfkv = mod_server_cast:set_data_sub(KeyValueList, PsAfAfk),
    %% 切换到野外场景,判断是否幽灵
    case is_outside_scene(EnterSceneId) of
        true ->
            #player_status{
                scene_hide_type = SceneHideType, battle_attr = #battle_attr{ghost = Ghost, is_hurt_mon = IsHurtMon},
                del_hp_each_time = DelHpEachTime
                } = PsAfkv,
            case Ghost == 1 orelse IsHurtMon == 0 orelse SceneHideType == ?HIDE_TYPE_VISITOR orelse DelHpEachTime =/= [] of
                true ->
                    ?ERR("battle_attr error EnterSceneId:~p LeaveSceneId:~p KeyValueList:~p Ghost:~p, IsHurtMon:~p SceneHideType:~p ~n",
                        [EnterSceneId, LeaveSceneId, KeyValueList, Ghost, IsHurtMon, SceneHideType]),
                    About = lists:concat(["EnterSceneId:", EnterSceneId, ",LeaveSceneId:", LeaveSceneId, ",Ghost:", Ghost,
                        ",IsHurtMon:", IsHurtMon, ",SceneHideType:", SceneHideType, ",DelHpEachTime:", util:term_to_string(DelHpEachTime)]),
                    lib_log_api:log_game_error(PsAfkv#player_status.id, 2, About),
                    PsAfOutside = mod_server_cast:set_data_sub([{ghost, 0}, {is_hurt_mon, 1}, {scene_hide_type, 0}, {del_hp_each_time, []}], PsAfkv);
                false ->
                    PsAfOutside = PsAfkv
            end;
        false ->
            PsAfOutside = PsAfkv
    end,
    #player_status{
        battle_attr = BA,
        guild = Guild
    } = PsAfkv,
%%    case lib_seacraft_daily:is_scene(EnterSceneId) of
%%        true ->
%%            if
%%                BA#battle_attr.group == 0 ->
%%                    About2 = lists:concat(["EnterSceneId:", EnterSceneId, ",LeaveSceneId:", LeaveSceneId, ",GuildRealm:", Guild#status_guild.realm,
%%                        ",IsHurtMon:", 0, ",group:", BA#battle_attr.group, ",DelHpEachTime:", util:term_to_string([])]),
%%                    lib_log_api:log_game_error(PsAfkv#player_status.id, 2, About2);
%%                true ->
%%                    ok
%%            end;
%%        _ ->
%%            skip
%%    end,
    PsAfOutside.

%% 获取主城随机出生地 -> {X, Y}
get_main_city_x_y() ->
    case data_scene:get(?MAIN_CITY_SCENE) of
        #ets_scene{reborn_xys=RebornXYs} when RebornXYs /= [] andalso is_list(RebornXYs) ->
            Len = length(RebornXYs),
            lists:nth(urand:rand(1, Len), RebornXYs);
        _ ->
            Len = length(?MAIN_CITY_RAND_XY),
            lists:nth(urand:rand(1, Len), ?MAIN_CITY_RAND_XY)
    end.

%% 是否在主城
is_in_main_city_scene(SceneId) when is_integer(SceneId) ->
    lists:member(SceneId, ?MAIN_CITY_SCENE_LIST);
is_in_main_city_scene(Status) when is_record(Status, player_status) ->
    lists:member(Status#player_status.scene, ?MAIN_CITY_SCENE_LIST).

%% 是否在主城和野外场景
is_in_normal_and_outside(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_NORMAL orelse Type == ?SCENE_TYPE_OUTSIDE -> true;
        _ -> false
    end.

%% 是否公会场景
is_guild_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_GUILD -> true;
        _ -> false
    end.

%% 是否在主城和野外场景和公会场景
is_in_normal_and_outside_and_guild(PS) ->
    #player_status{scene = SceneId, change_scene_sign = IsChangeSceneSign} = PS,
    if
        %% 排队换线中
        IsChangeSceneSign==1 ->
            {false, ?ERRCODE(err120_cannot_transfer_change_scene_sign)};
        true ->
            case data_scene:get(SceneId) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_NORMAL orelse Type == ?SCENE_TYPE_OUTSIDE orelse Type == ?SCENE_TYPE_GUILD ->
                    true;
                _ -> {false, ?ERRCODE(err120_cannot_transfer_not_in_safe)}
            end
    end.

%% 是否能参与普通活动[主城场景、野外场景的安全区、公会场景.]
is_can_join_common_act(SceneId, CopyId, X, Y) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when
              Type == ?SCENE_TYPE_NORMAL;
              Type == ?SCENE_TYPE_OUTSIDE;
              Type == ?SCENE_TYPE_GUILD ->
            is_safe(SceneId, CopyId, X, Y);
        _ -> false
    end.

%% 怪物是否需要清理不在设定范围内的玩家伤害记录
%% @return boolean()
is_need_to_remove_hurt(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} ->
            not lists:member(Type, ?SCENE_TYPE_NO_HURT_REMOVE);
        _ ->
            true
    end.

%% 返回场景玩家数据给玩家进程
return_scene_user_tps(SceneUser) ->
    lib_player:update_player_info(SceneUser#ets_scene_user.id,
                                  [{hp, SceneUser#ets_scene_user.battle_attr#battle_attr.hp}]),
    ok.

%% 清理场景副本
clear_scene_room(SceneId, ScenePoolId, CopyId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_OUTSIDE} ->
            %% 记录下清除野外场景怪物信息，便于查找野怪消失原因
            tool:back_trace_to_file(),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, clear_scene_room, [CopyId]);
        #ets_scene{} ->
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, clear_scene_room, [CopyId]);
        _ ->
            ?ERR("clear_scene_room scene_id error:~p~n", [{SceneId, ScenePoolId, CopyId}])
    end.

%% 清理场景(仅保留进程和障碍区和安全区数据)
clear_scene(SceneId, ScenePoolId) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, clear_scene, []).

% 1:衣服等级模型 2: 武器等级模型 3:头部等级模型 4:vip特权卡类型 5:vip等级, 6:降神id, 7 天启装备形象id
% 8:使魔id 9 勋章id，10:是否有至尊vip标识，11:免战结束时间戳
%% 广播场景主角属性更新
%% AttrKeyValues :: [{attrkey,value}|_]
broadcast_player_attr(#player_status{id=PlayerId, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx}, AttrKeyValues) ->
    broadcast_player_attr(PlayerId, Scene, ScenePoolId, CopyId, Xpx, Ypx, AttrKeyValues).

broadcast_player_attr(PlayerId, Scene, ScenePoolId, CopyId, Xpx, Ypx, AttrKeyValues) ->
    {ok, BinData} = pt_120:write(12010, [PlayerId, AttrKeyValues]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData).

broadcast_player_figure(#player_status{id=PlayerId, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx, figure = Figure}) ->
    {ok, BinData} = pt_120:write(12078, [PlayerId, Figure]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData).

broadcast_player_ship_id(PlayerId, Scene, ScenePoolId, CopyId, Xpx, Ypx, ShipId) ->
    ShipModelId = lib_kf_guild_war_api:get_ship_model_id(ShipId),
    {ok, BinData} = pt_120:write(12079, [PlayerId, ShipModelId]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, Xpx, Ypx, BinData).

%% 获取场景中房间的人数
get_room_max_people(Scene) ->
    case data_scene_other:get(Scene) of
        #ets_scene_other{room_max_people=_RoomMaxPeople} ->
            30;
        _ ->
            30
    end.

%% 是否在附近
is_near(SceneId, MX, MY, TSceneId, TX, TY)->
    if
        (SceneId =:= TSceneId andalso abs(TX - MX) =< 100 andalso abs(TY - MY) =< 100) -> true;
        true -> false
    end.

%% 获取野外场景开启房间号列表
get_room_list(SceneId, PoolId) ->
    case ets:match_object(?ETS_SCENE_LINES, #ets_scene_lines{scene=SceneId, pool_id=PoolId, _ = '_'}) of
        [] -> [];
        [#ets_scene_lines{lines = Lines}|_] -> maps:keys(Lines)
    end.

%% 跨服上获取自动分配的线，注意只有跨服节点能使用
cls_enter_autoline_scene(Node, SceneId, RoleId, X, Y, NeedOut, KeyValueList, EnterMFA) ->
    {PoolId, CopyId}
    = case catch mod_scene_line:get_poolid_copyid(true, SceneId, 0, 0, RoleId) of
        {'EXIT', _} = R ->
            ?ERR("select_a_poolid_copyid, Args:~p, Error:~p~n",
                 [[RoleId, true, SceneId, 0, 0], R]),
            {0, 0};
        {NewPoolId, NewCopyId} ->
            {NewPoolId, NewCopyId};
        Other ->
            ?ERR("select_a_poolid_copyid, Args:~p, Error:~p~n",
                 [[true, SceneId, 0, 0], Other]),
            {0, 0}
    end,
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?MODULE, change_scene_with_callback, [SceneId, PoolId, CopyId, X, Y, NeedOut, false, KeyValueList, EnterMFA]).

%% EnterMFA :: {M, F, A} M:F(#player_status{}, A) -> #player_status{}
change_scene_with_callback(Player, SceneId, PoolId, CopyId, X, Y, NeedOut, AutoSeleLine, KeyValueList, EnterMFA) ->
    EnterPlayer = change_scene(Player, SceneId, PoolId, CopyId, X, Y, NeedOut, AutoSeleLine, KeyValueList),
    case EnterMFA of
        {Mod, Fun, Args} ->
            case Mod:Fun(EnterPlayer, Args) of
                {ok, NewPlayer} ->
                    NewPlayer;
                _ ->
                    EnterPlayer
            end;
        _ ->
            EnterPlayer
    end.

%% 怪物伤害列表[场景进程]
send_hurt_info(Node, RoleId, MonId) ->
    % ?MYLOG("hjhhurt", "send_hurt_info MonId:~w ~n", [MonId]),
    Object = lib_scene_object_agent:get_object(MonId),
    if
        not is_record(Object, scene_object) -> skip;
        Object#scene_object.sign =/= ?BATTLE_SIGN_MON -> skip;
        true ->
            #scene_object{aid = Aid} = Object,
            mod_mon_active:send_hurt_info(Aid, Node, RoleId)
    end.

get_mod_level(PS) ->
    #player_status{scene = SceneId} = PS,
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    if
        SceneType == ?SCENE_TYPE_EUDEMONS_BOSS; SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER ->
            PS#player_status.eudemons_boss#eudemons_boss.lv;
        true ->
            0
    end.

%% 切场景日志(只记录部分,防止过多)
%% @return #player_status{}
log_change_scene_and_return(Player) ->
    #player_status{
        id = RoleId, scene = Scene, dungeon = #status_dungeon{dun_id = DunId, dun_type = DunType},
        battle_attr = #battle_attr{ghost = Ghost, hide = Hide}, is_change_scene_log = IsLog
        } = Player,
    IsDungeonScene = lib_scene:is_dungeon_scene(Scene),
    IsLogDunType = lists:member(DunType, [?DUNGEON_TYPE_EQUIP, ?DUNGEON_TYPE_EXP_SINGLE, ?DUNGEON_TYPE_VIP_PER_BOSS]),
%%    IsSeaDailyScene = lib_seacraft_daily:is_scene(Scene),
    if
        IsLog == 1 andalso IsDungeonScene andalso IsLogDunType ->
            Remark = lists:concat(["Ghost:", Ghost, "Hide:", Hide]),
            lib_log_api:log_change_scene(RoleId, Scene, DunId, DunType, Remark),
            % 设置不再记录
            Player#player_status{is_change_scene_log = 0};
%%        IsSeaDailyScene == true  ->
%%            Remark = lists:concat(["realm:", Guild#status_guild.realm, "Group:", Group, "to_camp:", CopyId]),
%%            lib_log_api:log_change_scene(RoleId, Scene, DunId, DunType, Remark),
%%            % 设置不再记录
%%            Player#player_status{is_change_scene_log = 0};
        true ->
            Player
    end.

%% 秘籍
%% 查找周围最近的怪物唯一id[场景进程]
gm_find_nearest_mon_auto_id(Node, RoleId, CopyId, X, Y) ->
    List = lib_scene_object_agent:get_scene_object(CopyId),
    F = fun(#scene_object{id = Id, x = TmpX, y = TmpY}) ->
        {math:pow(TmpX-X, 2) + math:pow(TmpY-Y, 2), Id}
    end,
    case lists:keysort(1, lists:map(F, List)) of
        [{_, Id}|_] ->
            ?PRINT("gm_find_nearest_mon_auto_id Id:~p ~n", [Id]),
            Msg = lists:concat(["gm_find_nearest_mon_auto_id:", Id]),
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_chat, gm_send_to_all, [Msg]);
        _ ->
            ok
    end.

clean_scene_buff(Player, EnterSceneId, LeaveSceneId) ->
    %% 生活技能buff清理
    lib_module_buff:clean_buff(Player, EnterSceneId, LeaveSceneId),
    Player.