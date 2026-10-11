%% ---------------------------------------------------------------------------
%% @doc lib_revive

%% @author zzm
%% @since  2015-04-23
%% @deprecated  复活模块库函数
%% ---------------------------------------------------------------------------
-module(lib_revive).
-export([revive/2, revive/3, revive_without_check/3, send_revive/10]).

-include("server.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("soul_dungeon.hrl").
-include("dungeon.hrl").
-include("role_nine.hrl").
-include("errcode.hrl").
-include("guild.hrl").

-define(GOLD, 20).
-define(DEFAULT_COST_TUPLE, {true, 0, 0, 0}).
-define(DEFAULT_GOLD_COST_TUPLE, {true, bgold_and_gold, ?GOLD, revive}).

-define(KF3V3_REVIVE_UNATT_TIME, 3).      %% 跨服3v3复活保护时间

%%复活方法
%%@param Status #player_status
%%@param Type   1元宝原地复活 2绑定元宝原地复活 3回城复活 4根据参数Status的血量复活
%%              5原地满血复活 6客户端请求变成幽灵状 8挂机自动复活 9通用副本复活
%%              10 新回合复活 11 3v3复活 12跨服公会战  13 世界boss场景, 18 聚魂本付费复活 20本服boss复活，安全区变幽灵/尸体
%%              21 圣灵战场回城复活 22 海战日常回城复活
revive(Status, Type) ->
    revive(Status, Type, []).

revive(Status, Type, PlayerArgs) ->
    #player_status{battle_attr = _BA} = Status,
    % ?MYLOG("revive", "Time:~p Type  ~p id ~p  group ~p~n", [utime:unixtime(),Type, Status#player_status.id, BA#battle_attr.group]),
    Result = case check_revive(Status, Type) of
        {false, Res} ->
            {Res, Status};
        {true, Cost} ->
            Comment = lists:concat(["scene:", Status#player_status.scene, " revive_type:", Type]),
            BgoldErrCode = ?BGOLD_NOT_ENOUGH,
            case lib_goods_api:cost_object_list_with_check(Status, Cost, revive, Comment) of
                {true, Status0} -> {1, Status0};
                {false, BgoldErrCode, Status0} -> {2, Status0};
                {false, _ErrCode, Status0} -> {0, Status0}
            end;
        {true, MoneyType, Money, ConsumeType} ->
            Comment = lists:concat(["scene:", Status#player_status.scene, " revive_type:", Type]),
            revive_cost_money(Status, MoneyType, Money, ConsumeType, Comment)
    end,
    %% 处理血量
    case Result of
        {1, CostStatus} ->
            {1, revive_set_data(CostStatus, Type, PlayerArgs)};
        {LastRes, CostStatus} when is_record(CostStatus, player_status) ->
            {LastRes, CostStatus};
        {LastRes, _}    ->
            {LastRes, Status}
    end.

%% 直接复活
revive_without_check(Status, Type, PlayerArgs) ->
    Status1 = revive_set_data(Status, Type, PlayerArgs),
    %% 告诉客户端复活成功
    {ok, BinData} = pt_200:write(20004, [Type, 1]),
    lib_server_send:send_to_uid(Status1#player_status.id, BinData),
    mod_scene_agent:update(Status, [{battle_attr, Status1#player_status.battle_attr}]),
    Status2 = case Status1#player_status.online == ?ONLINE_ON of
        true -> Status1;
        false ->
            case data_scene:get(Status1#player_status.scene) of
                #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
                   {ok, TmpStatus} = pp_scene:handle(12002, Status1, ok), TmpStatus;
                _ -> Status1
            end
    end,
    {ok, Status2}.

%% 检查除货币外的复活条件
check_revive(Status, Type) ->
    CheckReviveOnDun = lib_dungeon:check_revive_on_dungeon(Status, Type),
%%    CheckRevive3v3 = lib_3v3_api:check_revive(Status, Type),
    CheckReviveBoss = lib_boss:check_revive(Status, Type),
    CheckNine = lib_nine:check_revive(Status, Type),
    CheckSoulDungeon = lib_soul_dungeon_check:check_revive(Status, Type),
    CheckDrumwar = lib_role_drum:check_revive(Status, Type),
    %CheckGuildBattle = lib_guild_battle:check_revive(Status, Type),
    CheckTerriWar = lib_territory_war:check_revive(Status, Type),
    CheckDecoratBoss = lib_decoration_boss:check_revive(Status, Type),
    Result = if
        CheckReviveOnDun =/= true -> CheckReviveOnDun;
%%        CheckRevive3v3 =/= true ->  CheckRevive3v3;
        CheckReviveBoss =/= true -> CheckReviveBoss;
        CheckNine =/= true ->   CheckNine;
        CheckSoulDungeon =/= true ->  CheckSoulDungeon;
        CheckDrumwar =/= true -> CheckDrumwar;
        %CheckGuildBattle =/= true -> CheckGuildBattle;
        CheckTerriWar =/= true -> CheckTerriWar;
        CheckDecoratBoss =/= true -> CheckDecoratBoss;
        true ->
            check_revive_on_normal(Status, Type)
    end,
    if
        % 重新选择消耗
        Type == ?REVIVE_GOLD orelse Type == ?REVIVE_INPLACE ->
            auto_select_cost(Status, Result);
        true ->
            Result
    end.

check_revive_on_normal(Status, Type) ->
    Result = if
        Type == ?REVIVE_GOLD -> ?DEFAULT_GOLD_COST_TUPLE; %% 元宝复活
        Type == 2 -> ?DEFAULT_COST_TUPLE;             %% 绑定元宝复活已经不用花费（注：登录复活用到此类型）
        Type == ?REVIVE_ONHOOK -> {true, []};        %% 离线挂机复活操作
        Type == ?REVIVE_NINE_GOLD -> {true, ?NINE_KV_REVIVE_COST};
        Type == ?REVIVE_SOUL_DUNGEON ->
            Cost =
                case data_soul_dungeon:get_value_by_key(revive_cost) of
                [_V] ->
                    _V;
                _ ->
                    []
                end,
            ?MYLOG("cym", "revive_cost ~p~n", [Cost]),
            {true, Cost};
        Type == ?REVIVE_INPLACE ->
            #player_status{scene = Scene} = Status,
            case data_scene:get(Scene) of
                #ets_scene{type = SceneType} -> true;
                _ -> SceneType = false
            end,
            if
                SceneType == ?SCENE_TYPE_KF_SANCTUARY ->
                    %Cost = lib_c_sanctuary:get_revive_cost();
                    Cost = lib_sanctuary_cluster_util:get_revive_cost();
                SceneType == ?SCENE_TYPE_SANCTUM ->
                    Cost = lib_kf_sanctum:get_revive_cost();
                SceneType == ?SCENE_TYPE_ESCORT ->
                    Cost = lib_escort:get_revive_cost();
                SceneType == ?SCENE_TYPE_SEACRAFT ->
                    Cost = lib_seacraft:get_revive_cost();
                true ->
                    Cost = []
            end,
            {true, Cost};
        true -> ?DEFAULT_COST_TUPLE
    end,
    Result.

auto_select_cost(Status, Return) ->
    #player_status{scene = Scene} = Status,
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} -> true;
        _ -> SceneType = false
    end,
    Cost = data_revive:get_scene_revive_cost(SceneType),
    if
        Cost == false -> Return;
        true -> 
            case lib_goods_api:check_object_list(Status, Cost) of
                {false, _ErrCode} -> Return;
                true -> {true, Cost}
            end
    end.

%% 复活扣费
revive_cost_money(Status, coin, Money, ConsumeType, Comment) ->
    case lib_goods_api:cost_money(Status, coin, Money, ConsumeType, Comment) of
        {1, NewStatus} -> {1, NewStatus};
        _              -> {6, Status}
    end;
revive_cost_money(Status, gold, Money, ConsumeType, Comment) ->
    case lib_goods_api:cost_money(Status, gold, Money, ConsumeType, Comment) of
        {1, NewStatus} -> {1, NewStatus};
        _              -> {0, Status}
    end;
revive_cost_money(Status, bgold_and_gold, Money, ConsumeType, Comment) ->
    case lib_goods_api:cost_money(Status, bgold_and_gold, Money, ConsumeType, Comment) of
        {1, NewStatus} -> {1, NewStatus};
        _              -> {0, Status}
    end;

revive_cost_money(Status, _, _, _, _) -> {1, Status}.

%% 复活数据处理
revive_set_data(Status, Type, PlayerArgs) ->
    #player_status{scene=PlayerSceneId, scene_pool_id=ScenePoolId, copy_id=CopyId, battle_attr=BA, revive_status = _ReviveStatus, dungeon = StatusDungeon} = Status,
    #battle_attr{hp=OldHp, hp_lim=HpLim, group = GroupId} = BA,
    Scene = data_scene:get(PlayerSceneId),
    #status_dungeon{dun_id = DunId, revive_count = ReviveCount} = StatusDungeon,
    %%聚魂本提前复活， 取消复活定时器
    lib_soul_dungeon:cancel_revive_timer(Status, Type),
%%    NowTime = utime:unixtime(),
    %% 特殊放前面
    if
        DunId > 0 andalso (Type =:= ?REVIVE_DUNGEON  orelse Type == ?REVIVE_SOUL_DUNGEON) ->   %% 通用副本复活 + 聚魂本复活
            Hp          = HpLim,
            {X, Y, ReviveType} = lib_dungeon:get_review_xy(Status),
            Args        = [{hp, Hp}, {x,X}, {y,Y}, {ghost, 0}, {status_dungeon, [{revive_count, ReviveCount+1}]}];

        OldHp > HpLim * 3 div 100 ->
            Hp          = OldHp,
            Args        = [{hp, Hp}],
            ReviveType  = 1;

        %% 前面这4个判断选项顺序不能变，如有添加，请从第5个判断开始添加
        Scene =:= []->  %% 找不到场景数据(10%原地站起)
            Hp          = HpLim*10 div 100,
            Args        = [{hp, Hp}],
            ReviveType  = 2;

        Type =:= 1 -> %% 元宝复活
            Hp          = HpLim,
            Args        = [{hp, Hp}, {ghost, 0}],
            ReviveType  = 1;

        %% Type =:= 2 -> %% 绑定元宝复活
        %%     Hp          = HpLim *30 div 100,
        %%     Args        = [{hp, Hp}],
        %%     ReviveType  = 1;

        %% Type =:= 3 -> %% 条件在判断Type之后
        %% Type =:= 4 -> %% 原血量复活
        %%     Args        = [],
        %%     ReviveType  = 1;

        %% Type =:= 5 -> %% 原地满血复活
        %%     Hp          = HpLim,
        %%     Args        = [{hp, Hp}],
        %%     ReviveType  = 1;

        Type =:= ?REVIVE_GHOST -> %% 复活成幽灵状态
            Args        = [{hp, 1}, {ghost, 1}],
            ReviveType  = 1;

        Type =:= ?REVIVE_ONHOOK -> %% 挂机主动复活 服务端触发
            Hp          = HpLim,
            Args        = [{hp, Hp}],
            ReviveType  = 1;

        Type =:= ?REVIVE_ROUND -> %% 服务端触发
            Hp          = HpLim,
            Args        = [{hp, Hp}],
            ReviveType  = 2;

        Type =:= ?REVIVE_KF_3V3 ->
            Hp          = HpLim,
%%            [{x, X}, {y, Y}] = lib_3v3_center:revive(GroupId),
            Args        = lib_3v3_center:revive(GroupId) ++ [{hp, Hp}, {ghost, 0}],
            ReviveType  = 2;
        Type =:= ?REVIVE_HOLY_SPIRIT_BATTLE ->
            Hp          = HpLim,
            Args        = lib_holy_spirit_battlefield:revive(GroupId) ++ [{hp, Hp}, {ghost, 0}],
            ReviveType  = 2;
        Type =:= ?REVIVE_HOLY_SEA_CRAFT_DAILY ->
            Hp          = HpLim,
            Args        = lib_seacraft_daily:revive(Status) ++ [{hp, Hp}, {ghost, 0}],
            ReviveType  = 2;
        Type =:= ?REVIVE_KF_GWAR ->
            Hp          = HpLim,
            Args        = lib_kf_guild_war_api:get_reborn_point(GroupId) ++ [{hp, Hp}],
            ReviveType  = 2;

        Type =:= ?REVIVE_GUILD_BATTLE ->
            {X, Y}       = lib_territory_war:revive(Status, ?REVIVE_GUILD_BATTLE),
            Hp          = HpLim,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_WORLD_BOSS ->
            Hp          = HpLim,
            Args        = [{hp, Hp},{ghost, 0}],
            ReviveType  = 1;

        Type =:= ?REVIVE_WLDBOSS_POINT ->
            {X, Y}      = lib_boss:revive(Status, ?REVIVE_WLDBOSS_POINT),
            Hp          = HpLim,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_NINE_GOLD ->
            Args        = [{hp, HpLim}],
            ReviveType  = 2;

        Type =:= ?REVIVE_DRUMWAR ->
            {X,Y}       = lib_role_drum:revive(Status),
            Hp          = HpLim,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_BOSS ->
            {X, Y}      = lib_boss:revive(Status, ?REVIVE_BOSS),
            Hp          = 0,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_ASHES ->
            {X, Y}      = get_origin_point(Status),
            Hp          = 0,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_ORIGIN ->
            {X, Y}      = get_origin_point(Status),
            Hp          = HpLim,
            Args        = [{hp, Hp},{x,X},{y,Y},{ghost, 0}],
            ReviveType  = 2;

        Type =:= ?REVIVE_INPLACE ->
            Hp          = HpLim,
            Args        = [{hp, Hp},{ghost, 0}],
            ReviveType  = 1;

        Status#player_status.figure#figure.lv =< 20 -> %% 新手挂掉(100%原地站起)
            Hp          = HpLim,
            Args        = [{hp, Hp}],
            ReviveType  = 1;
        Type =:= ?REVIVE_NINE ->
	        case lib_nine:get_revive_kv(Status) of
		        {false, LayerId} -> %% 掉层， 通知进程那边掉层
                    ReviveType  = 3,
                    %% 掉层
%%                    ?PRINT("++++++++++++   LayerId ~p~n", [LayerId]),
                    NineRank = lib_nine:make_record(nine_rank, Status),
                    case lib_nine_api:is_nine_scene(PlayerSceneId) of
                        true ->
                            mod_nine_local:apply_war(NineRank, LayerId, true);
                        _ ->
                            skip
                    end,
                    Args= [];
                {true, Args} ->
                    ReviveType = 2
	        end;
        true-> %% 正常死亡(默认复活方式)
            Hp = HpLim,
            ReviveType = 2,
            #ets_scene{fuhuoscene=RebornScene} = Scene,
            Args = case data_scene:get(RebornScene) of
                #ets_scene{x=Xrb, y=Yrb, reborn_xys=[]} ->
                    [{hp, Hp}, {scene, RebornScene}, {x, Xrb}, {y, Yrb}, {ghost, 0}];
                #ets_scene{reborn_xys=RebornXYs} when is_list(RebornXYs) ->
                    [{Xrb, Yrb}|_] = ulists:list_shuffle(RebornXYs),
                    [{hp, Hp}, {scene, RebornScene}, {x, Xrb}, {y, Yrb}, {ghost, 0}];
                _ ->
                    [{hp, Hp}, {x, Scene#ets_scene.x}, {y, Scene#ets_scene.y}, {ghost, 0}]
            end
    end,
    AfterHpStatus = revive_set_data_hepler(PlayerArgs++Args, Status),
    %%判断是否要离开场景
    #player_status{x=NewX, y=NewY, scene=NewSceneId, scene_pool_id=NewScenePoolId} = AfterHpStatus,

    case ReviveType of
        1 -> %% 原地复活
            {ok, Bin} = pt_120:write(12003, AfterHpStatus),
            lib_server_send:send_to_area_scene(PlayerSceneId, ScenePoolId, CopyId, NewX, NewY, Bin),
            mod_scene_agent:update(AfterHpStatus, [{battle_attr, AfterHpStatus#player_status.battle_attr}]),
            mod_scene_agent:revive(Status);
        % 如果是同场景的话则重新进入
        2 when {PlayerSceneId, ScenePoolId} == {NewSceneId, NewScenePoolId} -> 
            mod_scene_agent:revive_to_target(Status),
            % 重新加载
            mod_scene_agent:join(AfterHpStatus);
        2 ->
            %% 通知离开场景
            %mod_scene_agent:update(AfterHpStatus, [{battle_attr, AfterHpStatus#player_status.battle_attr}]),
            lib_scene:leave_scene(Status);
        _ ->
            lib_scene:leave_scene(Status)
    end,
    case NewSceneId=/=PlayerSceneId of
        true  -> SceneName = lib_scene:get_scene_name(NewSceneId);
        false -> SceneName = Scene#ets_scene.name
    end,

    %% 复活保护时间
    ProtectTime = if
        Type =:= ?REVIVE_KF_3V3 ->
            ?KF3V3_REVIVE_UNATT_TIME;
        true -> 0
    end,
    %%加载场景
    if
        ReviveType == 3 ->
            skip;
        true ->
            send_revive(
                Status#player_status.sid, ReviveType,
                AfterHpStatus#player_status.scene, AfterHpStatus#player_status.x, AfterHpStatus#player_status.y,
                SceneName, AfterHpStatus#player_status.battle_attr#battle_attr.hp,
                AfterHpStatus#player_status.gold, AfterHpStatus#player_status.bgold,
                ProtectTime)
    end,
    %% 触发怪物ai
    mod_scene_agent:move(NewX, NewY, NewX, NewY, 0, 0, 0, AfterHpStatus),

    %% 派发复活事件
    {ok, AfEventStatus} = lib_player_event:dispatch(AfterHpStatus, ?EVENT_REVIVE, Type),

    %% 玩家复活疲劳值添加
    add_revive_tired(Type, Status),
    % 是否正在复活
    case ReviveType of
        1 -> IsReviving = 0;
        _ -> IsReviving = 1
    end,
    AfEventStatus#player_status{last_att_time = 0, last_beatt_time = 0, is_reviving = IsReviving}.

%% 数据载入
revive_set_data_hepler([H|T], Status) ->
    BA = Status#player_status.battle_attr,
    PK = BA#battle_attr.pk,
    NewStatus = case H of
        {hp, V}     -> Status#player_status{battle_attr=BA#battle_attr{hp=V}};
        {scene, V}  -> Status#player_status{scene=V};
        {copy_id, V}-> Status#player_status{copy_id=V};
        {x, V}      -> Status#player_status{x=V};
        {y, V}      -> Status#player_status{y=V};
        {ghost, V}  -> Status#player_status{battle_attr=BA#battle_attr{ghost=V}};
        {hide, V}   -> Status#player_status{battle_attr=BA#battle_attr{hide=V}};
        {pk_protect_time, V} ->Status#player_status{battle_attr=BA#battle_attr{pk=PK#pk{pk_protect_time=V}}};
        %% 恢复速度
        {speed, restore} -> lib_player:count_player_speed(Status);
        {status_dungeon, V} -> lib_dungeon:update_status_dungeon(V, Status);
        _           -> Status
    end,
    revive_set_data_hepler(T, NewStatus);
revive_set_data_hepler([], #player_status{battle_attr=BA} = Status) -> Status#player_status{battle_attr=BA#battle_attr{attr_buff_list=[], other_buff_list=[]}}.

send_revive(Sid, ReviveType, SceneId, X, Y, SceneName, Hp, Gold, BGold, AttProtected) ->
    {ok, BinData} = pt_120:write(12083, [ReviveType, SceneId, X, Y, SceneName, Hp, Gold, BGold, AttProtected]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 玩家复活疲劳值
add_revive_tired(_Type, Status)->
    #player_status{id = Id, scene = Scene} = Status,
    IsBossScene = lib_boss:is_in_boss(Scene),
    IsEudemonsBoss = lib_eudemons_land:is_in_eudemons_boss(Scene),
    if
        IsBossScene orelse IsEudemonsBoss ->
            NowTime = utime:unixtime(),
            case get({Id, revive_tired}) of
                {LastTime, Num} when NowTime - LastTime < 300 ->
                    NewReviveTired = Num + 1,
                    LTime = NowTime + 300,
                    put({Id, revive_tired}, {NowTime, NewReviveTired});
                _ ->
                    NewReviveTired = 1,
                    LTime = NowTime,
                    put({Id, revive_tired}, {NowTime, NewReviveTired})
            end,
            {ok, BinData} = pt_200:write(20017, [NewReviveTired, LTime]),
            lib_server_send:send_to_uid(Id, BinData);
        true ->
            ok
    end.

get_origin_point(PS) ->
    #player_status{scene = Scene, guild = #status_guild{realm = Camp, id = GuildId}} = PS,
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_SEACRAFT -> 
            {X, Y} = lib_seacraft:get_revive_point(Scene, Camp, GuildId);
        #ets_scene{type = SceneType, x = X1, y = Y1} when SceneType == ?SCENE_TYPE_SANCTUM -> 
            case catch mod_kf_sanctum_local:get_reborn_point() of 
                {X, Y} when is_integer(X) andalso is_integer(Y) -> ok; _ -> X = X1, Y = Y1
            end;
        #ets_scene{x = X, y = Y} -> ok;
        _ ->
            ?ERR("revive miss scene cfg, Scene:~p~n ", [Scene]),
            X = 0,
            Y = 0
    end,
    {X,Y}.