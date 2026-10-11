%% ---------------------------------------------------------------------------
%% @doc 玩家活动玩法中登出
%% @author hek
%% @since  2016-09-09
%% @deprecated 本模块提供-活动玩法中登出操作逻辑
%% ---------------------------------------------------------------------------
-module (lib_player_logout).
-include("server.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("battle.hrl").
-include("guild.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("boss.hrl").

-export ([logout/2]).

%% 延迟退出或者是正常退出
-define(LOGOUT_TYPE_LIST, [?NORMAL_LOGOUT, ?DELAY_LOGOUT]).

%% 下线退出和离线挂机退出各种活动和副本的统一处理接口
%% 因为各种情况都是互斥的，前面条件满足就认为玩家不会在其他活动
%% 任何活动和副本退出最好匹配两种退出处理
%% ========================================================
%% 延迟退出类型：是要将玩家活动数据清理，然后将玩家退出到野外或者主城 =
%% 直接退出类型：不需要将玩家切到野外或者主城，直接将玩家活动数据清理 =
%% ========================================================
logout(PS, LogOutType) when LogOutType > 0 andalso LogOutType =< ?DELAY_LOGOUT ->
    %?PRINT("lib_player_logout logout: ~p~n", [[PS#player_status.id, LogOutType]]),
    SetList = [
        common, in_dun, in_eudemons_boss, in_husong, in_boss, eternal_valley, 'kf_3v3'
        ,kf_1vn, in_saint, in_world_boss, is_in_nine, is_in_sanctuary, lib_midday_party
        ,in_decoration_boss, in_dragon_language_boss, in_holy_spirit_battle, in_sea_craft_daily
        ,in_kf_great_demon
    ],
    {ok, NewPS} = do_logout(SetList, PS, LogOutType),
    {ok, EvtStatus} = lib_player_event:dispatch(NewPS, ?EVENT_DISCONNECT_HOLD_END, LogOutType),
    {ok, EvtStatus};
logout(PS, LogOutType) ->
    ?ERR("err logout type :~p~n", [LogOutType]),
    {ok, PS}.

%% 登出数据处理
do_logout([], PS, _LogutType) -> {ok, PS};
do_logout([InMod|T], PS, LogOutType) ->
    case lists:member(LogOutType, ?LOGOUT_TYPE_LIST) of
        true ->
            case logout_set_data(InMod, PS, LogOutType) of
                {ok, NewPS} -> {ok, NewPS};
                {next, NewPS} -> do_logout(T, NewPS, LogOutType)
            end;
        false ->
            do_logout(T, PS, LogOutType)
    end.

%% 护送退出
logout_set_data(in_husong, Ps, LogOutType) ->
    case LogOutType of
        ?DELAY_LOGOUT ->
            case lib_husong:husong_logout_before_hook(Ps) of
                false ->
                    {next, Ps};
                {true, NewPs} ->
                    {ok, NewPs}
            end;
        _ ->
            {next, Ps}
    end;

%% 副本退出
logout_set_data(in_dun, PS, LogOutType) ->
    case lib_dungeon:is_on_dungeon(PS) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId,
                           battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim} } = PS,
            if
                LogOutType == ?NORMAL_LOGOUT ->
                    OffMap = lib_dungeon:make_off_map(PS),
                    mod_dungeon:logout(CopyId, RoleId, Hp, HpLim, OffMap),
                    {ok, PS};
                LogOutType == ?DELAY_LOGOUT ->
                    OffMap = lib_dungeon:make_off_map(PS),
                    mod_dungeon:delay_logout(CopyId, RoleId, Hp, HpLim, OffMap),
                    {ok, PS};
                true ->
                    {next, PS}
            end;
        false ->
            {next, PS}
    end;

%% 幻兽之域退出
logout_set_data(in_eudemons_boss, PS, LogOutType) ->
    case lib_eudemons_land:is_in_eudemons_boss(PS#player_status.scene) of
        false -> {next, PS};
        true ->
            %% 退出或者离开
            F = ?IF(LogOutType == ?NORMAL_LOGOUT, logout_eudemons_land, leave_eudemons_land),
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_eudemons_land, F, [Node, PS#player_status.id, PS#player_status.scene, PS#player_status.server_id]),
            {ok, PS}
    end;

%% 圣者殿退出
logout_set_data(in_saint, PS, LogOutType) ->
    case lib_saint:is_in_saint(PS#player_status.scene) of
        false -> {next, PS};
        true ->
            %% 退出或者离开
            F = ?IF(LogOutType == ?NORMAL_LOGOUT, logout_saint, leave_saint),
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_saint, F, [Node, PS#player_status.id, PS#player_status.server_id]),
            {ok, PS}
    end;

%% 龙语boss退出
logout_set_data(in_dragon_language_boss, PS, _LogOutType) ->
    case lib_dragon_language_boss_util:is_in_dragon_language_boss(PS#player_status.scene) of
        false -> {next, PS};
        true ->
            mod_clusters_node:apply_cast(mod_dragon_language_boss, quit,
                [config:get_server_id(), PS#player_status.id]),
            {ok, PS}
    end;

%% 本服boss退出
logout_set_data(in_boss, PS, LogOutType) ->
    case lib_boss:is_in_boss(PS#player_status.scene) of
        false -> {next, PS};
        true -> %% 退出或者离开
            #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
            mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_SPECIAL),
            mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_PHANTOM_PER),
            mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_WORLD_PER),
            mod_boss:logout_boss(PS#player_status.id, PS#player_status.scene, LogOutType,  PS#player_status.copy_id),
            {ok, PS}
    end;

%% 幻兽之域退出
logout_set_data(in_kf_great_demon, PS, LogOutType) ->
    case lib_boss:is_in_kf_great_demon_boss(PS#player_status.scene) of
        false ->
            {next, PS};
        true ->
            %% 退出或者离开
            Node = mod_disperse:get_clusters_node(),
            #player_status{ scene = Scene, id = RoleId, server_id = ServerId, x = OldX, y = OldY } = PS,
            case LogOutType == ?NORMAL_LOGOUT of
                true ->
                    mod_great_demon_local:logout_great_demon(RoleId, Scene, ServerId, OldX, OldY);
                _ ->
                    #player_status{ scene = Scene, id = RoleId, server_id = ServerId, x = OldX, y = OldY } = PS,
                    mod_great_demon_local:quit(Node, RoleId, Scene, ServerId, OldX, OldY)
            end,
            {ok, PS}
    end;

%% 通用退出
%% 注: 这个接口可能会调用多次
logout_set_data(common, PS, LogOutType) ->
    IsGFeastScene = lib_guild_feast:is_gfeast_scene(PS#player_status.scene),
    %IsGwarScene = lib_guild_battle_api:is_gwar_scene(PS),
    IsTerriWarScene = lib_territory_war:is_in_territory_war(PS#player_status.scene),
    IsVoidFamScene = lib_void_fam:is_in_void_fam(PS#player_status.scene),
    IsKfGuildWarScene = lib_kf_guild_war_api:is_kf_guild_war_scene(PS#player_status.scene),
    if
        IsGFeastScene -> %% 公会晚宴退出
            #player_status{guild = Guild} = PS,
            #status_guild{id = GuildId} = Guild,
            mod_guild_feast_mgr:exit_scene(PS#player_status.id, GuildId);
        % IsGwarScene -> %% 公会争霸退出
        %     lib_guild_battle:quit(PS);
        IsTerriWarScene -> %% 公会领地战
            lib_territory_war:quit(PS);
        IsVoidFamScene -> %% 虚空秘境退出
            mod_void_fam_local:exit_scene(PS#player_status.id, PS#player_status.battle_attr#battle_attr.hp_lim);
        IsKfGuildWarScene ->
            lib_kf_guild_war_api:exit_scene(PS#player_status.guild#status_guild.id, PS#player_status.id, PS#player_status.scene, PS#player_status.copy_id);
        true -> skip
    end,
    %% 婚礼退出
    %lib_marriage_wedding:logout_quit_wedding(PS),
    %% 成就
    ?TRY_CATCH(lib_achievement:logout(PS#player_status.id)),
    case LogOutType of
        ?NORMAL_LOGOUT ->
            skip;
            %mod_smashed_egg:update_online_time(PS#player_status.id, PS#player_status.online, PS#player_status.last_login_time);
        _ -> skip
    end,
    %% 骑宠
    ?TRY_CATCH(lib_mount:logout(PS)),
    ?TRY_CATCH(lib_pet:logout(PS)),
    %%魔法阵
    ?TRY_CATCH(lib_magic_circle:logout(PS)),
    %% 装备寻宝
    ?TRY_CATCH(lib_treasure_hunt_data:logout(PS#player_status.id)),
    % 在线玩家统计
    ?TRY_CATCH(lib_online_statistics:logout(PS)),
    % 钻石争霸退出
    ?TRY_CATCH(lib_role_drum:role_change(PS,0)),
    % 婚宴退出
    ?TRY_CATCH(lib_marriage_wedding:quit_wedding(PS)),
    % vip清除
    ?TRY_CATCH(lib_vip:logout(PS)),
    % 跨服圣域
    %?TRY_CATCH(lib_c_sanctuary:logout(PS)),
    ?TRY_CATCH(lib_sanctuary_cluster:logout(PS)),
    % 矿石护送
    ?TRY_CATCH(lib_escort:logout(PS)),
    % 怒海争霸
    ?TRY_CATCH(lib_seacraft:logout(PS)),
    % 永恒圣殿
    ?TRY_CATCH(lib_kf_sanctum:logout(PS)),
    % 无限层boss
    ?TRY_CATCH(lib_boss:special_boss_logout(PS)),
    % 使魔
    ?TRY_CATCH(lib_demons:logout(PS)),
    {next, PS};

%% 永恒碑谷 只在真实下线的时候处理
logout_set_data(eternal_valley, PS, ?NORMAL_LOGOUT) ->
    case catch lib_eternal_valley:logout(PS#player_status.id, PS#player_status.eternal_valley) of
        ok -> skip;
        Err ->
            ?ERR("eternal valley logout err:~p", [Err])
    end,
    {next, PS};





logout_set_data(in_sea_craft_daily, PS, _) ->
    lib_seacraft_daily:logout(PS),
    {next, PS};
logout_set_data(in_holy_spirit_battle, PS, _) ->
    lib_holy_spirit_battlefield:logout(PS),
    {next, PS};
logout_set_data(kf_1vn, PS, _) ->
    lib_kf_1vN:logout(PS),
    {next, PS};

logout_set_data(in_world_boss, Ps, _LogOutType) ->
    lib_boss:logout(Ps),
    {next, Ps};

logout_set_data(is_in_nine, Ps, _LogOutType) ->
    lib_nine:logout(Ps),
    {next, Ps};
%%圣域
logout_set_data(is_in_sanctuary, Ps, _LogOutType) ->
    lib_sanctuary:logout(Ps),
    {next, Ps};

%%午间派对
logout_set_data(lib_midday_party, Ps, _LogOutType) ->
    lib_midday_party:logout(Ps),
    {next, Ps};

%% 幻饰boss
logout_set_data(in_decoration_boss, Ps, LogOutType) ->
    lib_decoration_boss:logout(Ps, LogOutType);

logout_set_data(_Unkown, PS, _LogOutType) ->
    {next, PS}.
