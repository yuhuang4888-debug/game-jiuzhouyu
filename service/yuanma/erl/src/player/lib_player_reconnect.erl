%% ---------------------------------------------------------------------------
%% @doc 玩家活动玩法中重连
%% @author hek
%% @since  2016-09-09
%% @deprecated 本模块提供-活动玩法中重连操作逻辑
%% ---------------------------------------------------------------------------
-module (lib_player_reconnect).
-include("server.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("jjc.hrl").
-include("predefine.hrl").
-include("relationship.hrl").
-include("def_module.hrl").
-include("guild.hrl").
-include("dungeon.hrl").

-export ([
        login/1
        , reconnect/2
    ]).

%% 登录
login(Status) ->
    case lib_player_reconnect:reconnect(Status, ?NORMAL_LOGIN) of
        {ok, NewStatus} -> NewStatus#player_status{reconnect = ?RECONNECT_DEAL};
        {no, NewStatus} -> NewStatus#player_status{reconnect = ?RECONNECT_DEAL};
        _ -> Status
    end.

%% 重连


%%%---------------------------------------------------------------------------
%%% 对于需要重连的活动玩法重连如下
%%% 重连条件：上线时的场景是需要处理重连场景（不需要重连的，走lib_scene:repair_xy/4修复位置规则）
%%% 具体步骤：
%%% 1.活动进程存在，且活动未结束，cast到活动进程，先执行玩家上线逻辑（如在线活动人数+1，设置动态分组等）
%%%   然后切换场景，将玩家传送到活动规则最新场景

%%% 2. 如果活动进程不存在（即misc:is_process_alive/1为false）或者活动已结束的，使用
%%%    lib_scene:change_default_scene/2将玩家切换到默认场景即可
%%%---------------------------------------------------------------------------

reconnect(PS, LoginType) when LoginType>0 andalso LoginType =<?RE_LOGIN ->
    SetList = [
               {in_common, [?RE_LOGIN]},
               {in_dungeon, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_wedding, [?RE_LOGIN]},
               {in_diamond_battle,   [?RE_LOGIN]},
               {in_3v3,   [?RE_LOGIN, ?RE_LOGIN]},
               {in_husong, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_house, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_world_boss,[?NORMAL_LOGIN, ?RE_LOGIN]},
               %{in_guild_battle, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_territory_war, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_guild_dun_battle, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_drumwar, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_new_outside, [?RE_LOGIN]},
               {in_sanctuary, [?RE_LOGIN]},
               {in_nine, [?RE_LOGIN]},
               {in_beings_gate, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_eudemons_boss, [?RE_LOGIN]},
               {in_territory, [?RE_LOGIN]},
               {in_kf_sanctuary, [?RE_LOGIN]},
               {in_kf_sanctum, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_kf_escort, [?RE_LOGIN]},
               {in_kf_seacraft, [?RE_LOGIN]},
               {in_night_ghost, [?NORMAL_LOGIN, ?RE_LOGIN]},
               {in_kf_great_demon, [?NORMAL_LOGIN, ?RE_LOGIN]}
              ],
    case do_reconnect(SetList, PS, LoginType) of
        %% 不需要重连，修复坐标
        {no, NewPS} ->
            #player_status{figure=#figure{lv=Lv}, scene = OldSceneId, x = OldX, y = OldY, battle_attr = BA = #battle_attr{pk = Pk}} = NewPS,
            if
                LoginType == ?RE_LOGIN andalso OldSceneId == ?BORN_SCENE -> %% 重连在新手场景
                    if
                        Lv < 2 ->
                            {RX, RY} = ?BORN_SCENE_COORD,
                            {no, NewPS#player_status{scene = ?BORN_SCENE, x = RX, y = RY}};
                        true ->
                            {no, NewPS} %% 重连直接进入原来的坐标
                    end;
                LoginType == ?RE_LOGIN ->
                    %% 神殿觉醒退一下
                    case data_scene:get(OldSceneId) of
                        #ets_scene{type = ?SCENE_TYPE_TEMPLE_AWAKEN} ->
                            [NewSceneId, NewX, NewY] = lib_scene:get_outside_scene_by_lv(Lv),
                            PSAfSave = NewPS#player_status{scene = NewSceneId, x = NewX, y = NewY},
                            PSAfSupVip = lib_protect:change_scene(PSAfSave, OldSceneId, NewSceneId),
                            {no, PSAfSupVip};
                        _ ->
                            %% 重连直接进入原来的坐标
                            {no, NewPS}
                    end;
                true ->
                    [NewSceneId, NewX, NewY] = lib_scene:repair_xy(NewPS, OldSceneId, OldX, OldY),
                    %% pk状态强制切换
                    NewPk = case data_scene:get(NewSceneId) of
                        #ets_scene{subtype=Subtype, requirement=Requirement} when
                                Subtype == ?SCENE_SUBTYPE_KILL_MON;
                                Subtype == ?SCENE_SUBTYPE_SAFE ->
                            case lists:keyfind(pkstate, 1, Requirement) of
                                {_, PkType} when PkType /= BA#battle_attr.pk#pk.pk_status -> Pk#pk{pk_status = PkType};
                                _ -> Pk#pk{pk_status = BA#battle_attr.pk#pk.pk_status}
                            end;
                        _ ->
                            Pk
                    end,
                    PSAfSave = NewPS#player_status{scene = NewSceneId, x = NewX, y = NewY, battle_attr = BA#battle_attr{pk=NewPk}},
                    PSAfSupVip = lib_protect:change_scene(PSAfSave, OldSceneId, NewSceneId),
                    {no, PSAfSupVip}
            end;
        %% 活动中重连
        {ok, NewPS} -> {ok, NewPS}
    end.

%% 重连数据处理
do_reconnect([], #player_status{action_lock = Lock, scene = Scene} = PS, _LoginType) ->
    if
        Lock =:= free ->
            {no, PS};
        true ->
            case lib_scene:is_in_normal_and_outside(Scene) of
                true ->
                    {no, PS#player_status{action_lock = free}};
                _ ->
                    {no, PS}
            end
    end;
do_reconnect([H|T], PS, LoginType) ->
    {InMod, LoginList} = H,
    case lists:member(LoginType, LoginList) of
        true ->
            case reconnect_set_data(InMod, PS, LoginType) of
                {ok, NewPS} -> {ok, NewPS};
                {next, NewPS} -> do_reconnect(T, NewPS, LoginType)
            end;
        false -> do_reconnect(T, PS, LoginType)
    end.

%% 副本
reconnect_set_data(in_dungeon, PS, LoginType) ->
    case lib_dungeon:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 婚礼
reconnect_set_data(in_wedding, PS, LoginType) ->
    case lib_marriage_wedding:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 护送
reconnect_set_data(in_husong, PS, LoginType) ->
    case lib_husong:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 家园
reconnect_set_data(in_house, PS, LoginType) ->
    case lib_house:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_diamond_battle, PS, ?RE_LOGIN) ->
    case lib_diamond_league:reconnect(PS) of
        {ok, NewPS} ->
            {ok, NewPS};
        {next, NewPS} ->
            {next, NewPS};
        _ ->
            {next, PS}
    end;

%% 3v3
reconnect_set_data(in_3v3, PS, LoginType) ->
    case lib_3v3_local:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 世界boss
reconnect_set_data(in_world_boss, PS, LoginType) ->
    case lib_boss:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 公会战
reconnect_set_data(in_guild_battle, PS, LoginType) ->
    case lib_guild_battle:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 公会领地战
reconnect_set_data(in_territory_war, PS, LoginType) ->
    case lib_territory_war:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 公会战
reconnect_set_data(in_guild_dun_battle, PS, LoginType) ->
    case lib_guild_dun:reconnect(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

%% 钻石大战
reconnect_set_data(in_drumwar, PS, _LoginType) ->
    case lib_role_drum:re_login(PS) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_new_outside, PS, LoginType) ->
    case lib_boss:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_eudemons_boss, PS, LoginType) ->
    case lib_eudemons_land:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_nine, PS, LoginType) ->
    case lib_nine:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_beings_gate, PS, LoginType) ->
    case lib_beings_gate:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_sanctuary, PS, LoginType) ->
    case lib_sanctuary:re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_territory, PS, LoginType) ->
    #player_status{id = RoleId, scene = Scene} = PS,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_TERRITORY ->
            case lib_gm_stop:check_gm_close_act(?MOD_TERRITORY, 0) of
                true ->
                    case lib_territory_treasure:re_login(PS, LoginType) of
                        {ok, NewPS} -> {ok, NewPS};
                        {next, NewPS} -> {next, NewPS}
                    end;
                _ ->
                    lib_scene:player_change_default_scene(RoleId,
                        [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
                    {ok, PS}
            end;
        _ ->
            {next, PS}
    end;

reconnect_set_data(in_common, PS, LoginType) ->
    case re_login(PS, LoginType) of
        {ok, NewPS} -> {ok, NewPS};
        {next, NewPS} -> {next, NewPS}
    end;

reconnect_set_data(in_kf_sanctuary, PS, _LoginType) ->
    #player_status{scene = SceneId} = PS,
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            % case lib_gm_stop:check_gm_close_act(?MOD_C_SANCTUARY, 0) of
            %     true ->
            %         case lib_c_sanctuary:re_login(PS) of
            %             {ok, NewPS} -> {ok, NewPS};
            %             {next, NewPS} -> {next, NewPS}
            %         end;
            %     _ ->
            %         lib_scene:player_change_default_scene(RoleId,
            %             [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
            %         mod_c_sanctuary:exit(ServerId, RoleId, Scene),
            %         {ok, PS}
            % end;
            lib_sanctuary_cluster:re_login(PS);
        _ ->
            {next, PS}
    end;

reconnect_set_data(in_kf_sanctum, PS, LoginType) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = PS,
    case lib_kf_sanctum:is_in_kf_sanctum(Scene) of
        true ->
            case lib_gm_stop:check_gm_close_act(?MOD_KF_SANCTUM, 0) of
                true ->
                    case lib_kf_sanctum:re_login(PS, LoginType) of
                        {ok, NewPS} -> {ok, NewPS};
                        {next, NewPS} -> {next, NewPS}
                    end;
                _ ->
                    lib_scene:player_change_default_scene(RoleId,
                        [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
                    mod_kf_sanctum:exit(ServerId, RoleId, Scene),
                    {ok, PS}
            end;
        _ ->
            {next, PS}
    end;
reconnect_set_data(in_kf_escort, PS, _LoginType) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId, guild = #status_guild{id = GuildId}} = PS,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_ESCORT ->
            case lib_gm_stop:check_gm_close_act(?MOD_ESCORT, 0) of
                true ->
                    case lib_escort:re_login(PS) of
                        {ok, NewPS} -> {ok, NewPS};
                        {next, NewPS} -> {next, NewPS}
                    end;
                _ ->
                    lib_scene:player_change_default_scene(RoleId,
                        [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
                    mod_escort_kf:exit(ServerId, GuildId, RoleId),
                    {ok, PS}
            end;
        _ ->
            {next, PS}
    end;

reconnect_set_data(in_kf_seacraft, PS, _LoginType) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId, guild = #status_guild{id = GuildId}} = PS,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEACRAFT ->
            case lib_gm_stop:check_gm_close_act(?MOD_SEACRAFT, 0) of
                true ->
                    case lib_seacraft:re_login(PS) of
                        {ok, NewPS} -> {ok, NewPS};
                        {next, NewPS} -> {next, NewPS}
                    end;
                _ ->
                    lib_scene:player_change_default_scene(RoleId,
                        [{group, 0}, {camp, 0}, {change_scene_hp_lim, 100}, {pk, {?PK_PEACE, true}}]),
                    {ok, PS}
            end;
        _ ->
            {next, PS}
    end;

%% 百鬼夜行
%% @return {ok, PS} | {next, PS}
reconnect_set_data(in_night_ghost, PS, LoginType) ->
    lib_night_ghost:reconnect(PS, LoginType);

%% 跨服秘境大妖
reconnect_set_data(in_kf_great_demon, PS, LoginType) ->
    lib_great_demon_local:reconnect(PS, LoginType);

reconnect_set_data(_Unkown, PS, _LoginType) ->
    {next, PS}.

%% 只处理重连必须执行的操作，当玩家处于离线挂机期间登陆都属于重连不会去到登陆过程
re_login(#player_status{scene_pool_id = PoolId, scene = Scene, id = RoleId} = PS, _LoginType) ->
    mod_scene_agent:apply_cast(Scene, PoolId, lib_scene_agent, clear_collect_mon_msg, [RoleId]), %%清除采集怪的信息
    PkPlayer = lib_pk_log:relogin(PS),
    {next, PkPlayer}.