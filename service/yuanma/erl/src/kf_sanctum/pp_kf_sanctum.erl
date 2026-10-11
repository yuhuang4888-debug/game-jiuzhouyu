-module(pp_kf_sanctum).

-export([handle/3, check_before_enter_help/2]).

-include("server.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("common.hrl").

handle(Cmd, PS, Data) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    OpenDay = util:get_open_day(),
    case data_sanctum:get_value(open_day_limit) of
        OpenDayLimit when is_integer(OpenDayLimit) andalso OpenDay >= OpenDayLimit ->
            case data_sanctum:get_value(open_lv) of
                OpenLv when is_integer(OpenLv) andalso RoleLv >= OpenLv ->
                    do_handle(Cmd, PS, Data);
                _ ->
                    if
                        Cmd == 27902 ->
                            send_pt_data(RoleId, 27909, [?ERRCODE(err279_lv_limit)]);
                        true ->
                            skip
                    end,
                    {ok, PS}
            end;
        _ ->
            if
                Cmd == 27902 ->
                    send_pt_data(RoleId, 27909, [?ERRCODE(err279_openday_limit)]);
                true ->
                    skip
            end,
            {ok, PS}
    end.

%% 永恒圣殿开启时间
do_handle(27900, PS, []) ->
    #player_status{id = RoleId} = PS,
    mod_kf_sanctum_local:get_act_time(RoleId),
    {ok, PS};

%% 永恒圣殿参与人数
do_handle(27901, PS, []) ->
    #player_status{id = RoleId, server_id = ServerId} = PS,
    mod_kf_sanctum_local:get_act_join_num(RoleId, ServerId),
    {ok, PS};

%% 进入
do_handle(27902, PS, [Scene]) ->
    #player_status{id = RoleId, server_id = ServerId, scene = SceneId} = PS,
    case check_before_enter(PS, Scene) of
        {false, Code} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_279, 27902, [Code]);
        true->
            Node = node(),
            mod_kf_sanctum_local:enter(ServerId, Node, RoleId, Scene, SceneId)
    end,
    {ok, PS};

%% 退出
do_handle(27903, PS, []) ->
    {IsOut, ErrCode} = lib_scene:is_transferable_out(PS),
    case IsOut of
        true ->
            #player_status{id = RoleId, server_id = ServerId, scene = Scene} = PS, %% 可以切换pk状态的场景在退出时都需要将pk状态设置为和平模式
            case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
                    NewPs = lib_scene:change_scene(PS, 0, 0, 0, 0, 0, true, [{group, 0}, {recalc_attr, 0}, {change_scene_hp_lim, 100}, 
                        {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
                    mod_kf_sanctum_local:exit(ServerId, RoleId, Scene);
                _ -> 
                    NewPs = PS
            end;
        false ->
            NewPs = PS
    end,
    {ok, BinData} = pt_284:write(27903, [ErrCode]),
    lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
    {ok, NewPs};

%% 怪物信息
do_handle(27904, PS, [Scene]) ->
    #player_status{id = RoleId} = PS,
    mod_kf_sanctum_local:get_mon_info(RoleId, Scene),
    {ok, PS};

%% 怪物伤害统计
do_handle(27905, PS, [Scene, MonId]) ->
    #player_status{id = RoleId} = PS,
    mod_kf_sanctum_local:get_mon_hurt_rank(RoleId, Scene, MonId),
    {ok, PS};

%% 死亡疲劳
do_handle(27906, PS, []) ->
    #player_status{id = RoleId, player_die = PlayerDieInfo} = PS,
    ModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    case ModDieInfo of
        [] ->
            DieList = [], DieTime = 0;
        _ ->
            #mod_player_die{die_time_list = DieList, die_time = DieTime} = ModDieInfo
    end,
    case data_sanctum:get_value(player_die_times) of
        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
        _ -> TimeCfg = 300
    end,
    case data_cluster_sanctuary:get_san_value(revive_point_gost) of
        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
        _ -> TimeCfg2 = 20
    end,
    DieTimes = erlang:length([DieList]),
    {RebornTime, MinTimes} = lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
    if
        DieTimes > MinTimes ->
            lib_server_send:send_to_uid(RoleId, pt_279, 27906, [DieTimes, RebornTime, DieTime + TimeCfg, DieTime + TimeCfg2]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_279, 27906, [DieTimes, RebornTime, DieTime + TimeCfg, 0])
    end,
    {ok, PS};

do_handle(_, PS, _) -> {ok, PS}.

send_pt_data(RoleId, Cmd, Arg) ->
    lib_server_send:send_to_uid(RoleId, pt_279, Cmd, Arg).

check_before_enter(Player, Scene) ->
    List = [{gm_close}, {action_lock}, {scene, Scene}, {scene_type, Scene}],
    check_before_enter_help(Player, List).

check_before_enter_help(Player, [{gm_close}|T]) ->
    case lib_gm_stop:check_gm_close_act(?MOD_KF_SANCTUM, 0) of
        true -> check_before_enter_help(Player, T);
        _ -> {false, ?ERR_GM_STOP}
    end;
check_before_enter_help(Player, [{action_lock}|T]) ->
    #player_status{scene = RoleSceneId} = Player,
    IsInActScene = lib_kf_sanctum:is_in_kf_sanctum(RoleSceneId),
    if
        IsInActScene == true -> check_before_enter_help(Player, T);
        true ->
            case lib_player_check:check_list(Player, [action_free, is_transferable]) of
                {false, Code} ->
                    {false, Code};
                _ ->
                    check_before_enter_help(Player, T)
            end
    end;    
check_before_enter_help(Player, [{scene, Scene}|T]) ->
    #player_status{scene = SceneId} = Player,
    if
        SceneId == Scene ->
            {false, ?ERRCODE(err418_has_in_scene)};
        true ->
            check_before_enter_help(Player, T)
    end;
check_before_enter_help(Player, [{scene_type, Scene}|T]) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
            check_before_enter_help(Player, T);
        _ -> 
            {false, ?ERRCODE(err186_error_data)}
    end;
check_before_enter_help(_Player, []) -> true.