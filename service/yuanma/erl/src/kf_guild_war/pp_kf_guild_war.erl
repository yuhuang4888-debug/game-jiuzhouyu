%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------
-module(pp_kf_guild_war).

-include("kf_guild_war.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("scene.hrl").

-export([handle/3]).

handle(Cmd, Player, Data) ->
    #player_status{sid = Sid, figure = Figure} = Player,
    OpenLv = data_kf_guild_war:get_cfg(?CFG_ID_OPEN_LV),
    case Figure#figure.lv >= OpenLv of
        true ->
            NeedFilterCmd = [43709, 43711, 43719, 43728, 43729],
            case lib_kf_guild_war:is_kf_guild_war_server() of
                true ->
                    do_handle(Cmd, Player, Data);
                _ ->
                    case lists:member(Cmd, NeedFilterCmd) of
                        true ->
                            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err437_not_act_server));
                        _ ->
                            do_handle(Cmd, Player, Data)
                    end
            end;
        false -> skip
    end.

%% 活动状态
do_handle(43701, Player, _) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_act_info, [Node, RoleId]);

%% 海域总览信息
do_handle(43702, Player, _) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    MergeSerIds = config:get_merge_server_ids(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_seas_overview_info, [Node, RoleId, MergeSerIds]);

%% 各个海域信息
do_handle(43703, Player, _) ->
    #player_status{id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    Node = mod_disperse:get_clusters_node(),
    MergeSerIds = config:get_merge_server_ids(),
    case catch mod_daily:lessthan_limit(RoleId, ?MOD_KF_GUILD_WAR, ?DAILY_REWARD_COUNTER_ID) of
        true -> DailyRewardStatus = 1;
        _ -> DailyRewardStatus = 0
    end,
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_seas_info, [Node, GuildId, RoleId, 1, 1, MergeSerIds, DailyRewardStatus]);

%% 本服奖励界面
do_handle(43704, Player, _) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    MergeSerIds = config:get_merge_server_ids(),
    case catch mod_daily:lessthan_limit(RoleId, ?MOD_KF_GUILD_WAR, ?DAILY_REWARD_COUNTER_ID) of
        true -> DailyRewardStatus = 1;
        _ -> DailyRewardStatus = 0
    end,
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_occupy_reward_info, [Node, RoleId, MergeSerIds, DailyRewardStatus]);

%% 一键领取本服奖励
do_handle(43705, Player, _) ->
    #player_status{sid = Sid, id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId, position = Position} = Guild,
    Node = mod_disperse:get_clusters_node(),
    MergeSerIds = config:get_merge_server_ids(),
    case catch mod_daily:lessthan_limit(RoleId, ?MOD_KF_GUILD_WAR, ?DAILY_REWARD_COUNTER_ID) of
        true ->
            mod_clusters_node:apply_cast(mod_kf_guild_war, receive_daily_reward, [Node, RoleId, GuildId, Position, MergeSerIds]);
        false ->
            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err437_has_receive_daily_reward));
        Err ->
            ?ERR("receive daily reward err:~p", [Err]),
            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(system_busy))
    end;

%% 赛季奖励
do_handle(43706, Player, _) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_season_reward_info, [Node, RoleId]);

%% 海域霸王界面
do_handle(43707, Player, _) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_seas_dominator_info, [Node, RoleId]);

%% 物资捐献界面
do_handle(43708, Player, _) ->
    #player_status{id = RoleId} = Player,
    mod_kf_guild_war_local:send_donate_view_info(RoleId);

%% 物资捐献
do_handle(43709, Player, [GuildId, Type]) ->
    #player_status{sid = Sid, id = RoleId} = Player,
    case lists:member(Type, ?DONATE_TYPE_LIST) of
        true ->
            case catch mod_kf_guild_war_local:check_donate_resource(RoleId, GuildId, Type) of
                {ok, Cost} ->
                    Reward = data_kf_guild_war:get_cfg(?CFG_ID_DONATE_REWARD),
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, kf_gwar_donate, "") of
                                {true, NewPlayer} ->
                                    mod_kf_guild_war_local:donate_resource(RoleId, GuildId, Type, Cost),
                                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Reward, kf_gwar_donate_reward, 0, 1),
                                    {ok, BinData} = pt_437:write(43709, [?SUCCESS]),
                                    lib_server_send:send_to_sid(Sid, BinData);
                                {false, ErrorCode, LastPlayer} ->
                                    lib_kf_guild_war:send_error_code(Sid, ErrorCode)
                            end;
                        {false, ErrorCode} ->
                            LastPlayer = Player,
                            lib_kf_guild_war:send_error_code(Sid, ErrorCode)
                    end;
                {false, ErrorCode} ->
                    LastPlayer = Player,
                    lib_kf_guild_war:send_error_code(Sid, ErrorCode)
            end;
        _ ->
            LastPlayer = Player
    end,
    {ok, LastPlayer};

%% 兑换物资界面
do_handle(_Cmd = 43710, Player, _) ->
    #player_status{id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    mod_kf_guild_war_local:send_exchange_props_view_info(GuildId, RoleId);

%% 兑换物资
do_handle(_Cmd = 43711, Player, [PropsId, Num, ExchangeType]) ->
    #player_status{sid = Sid, id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId, name = GuildName, position = Position} = Guild,
    case lists:member(Position, [?POS_CHIEF, ?POS_DUPTY_CHIEF]) of
        true ->
            case mod_kf_guild_war_local:check_exchange_props(GuildId, PropsId, Num, ExchangeType) of
                {ok, CostNum} ->
                    case ExchangeType of
                        ?EXCHANGE_TYPE_GOLD ->
                            case lib_goods_api:cost_object_list_with_check(Player, [{?TYPE_BGOLD, 0, CostNum}], kf_gwar_exchange_props, PropsId) of
                                {true, NewPlayer} ->
                                    mod_kf_guild_war_local:exchange_props(GuildId, GuildName, RoleId, PropsId, Num, CostNum, ExchangeType),
                                    {ok, NewPlayer};
                                {false, ErrorCode, NewPlayer} ->
                                    lib_kf_guild_war:send_error_code(Sid, ErrorCode),
                                    {ok, NewPlayer}
                            end;
                        _ ->
                            mod_kf_guild_war_local:exchange_props(GuildId, GuildName, RoleId, PropsId, Num, CostNum, ExchangeType)
                    end;
                {false, ErrorCode} ->
                    lib_kf_guild_war:send_error_code(Sid, ErrorCode)
            end;
        _ ->
            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err437_guild_pos_lim_cant_exchange_props))
    end;

%% 个人积分
do_handle(_Cmd = 43712, Player, _) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_personal_score_info, [CopyId, Node, RoleId]);
        _ -> skip
    end;

%% 公会积分
do_handle(_Cmd = 43713, Player, _) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_guild_score_info, [CopyId, Node, RoleId]);
        _ -> skip
    end;

%% 据点占领列表
do_handle(_Cmd = 43714, Player, _) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_building_info, [CopyId, Node, RoleId]);
        _ -> skip
    end;

%% 兑换战舰界面
do_handle(_Cmd = 43715, Player, _) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_exchange_ship_info, [CopyId, Node, RoleId]);
        _ -> skip
    end;

%% 兑换战舰
do_handle(_Cmd = 43716, Player, [ShipId]) ->
    #player_status{sid = Sid, id = RoleId, scene = SceneId, copy_id = CopyId, x = X, y = Y, guild = Guild} = Player,
    #status_guild{position = Position} = Guild,
    case data_kf_guild_war:get_ship_cfg(ShipId) of
        ShipCfg when is_record(ShipCfg, kf_gwar_ship_cfg) ->
            case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
                true ->
                    Node = mod_disperse:get_clusters_node(),
                    ArgsMap = #{x => X, y => Y, guild_pos => Position},
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, exchange_ship, [CopyId, Node, RoleId, ShipId, ArgsMap]);
                _ -> skip
            end;
        _ ->
            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err_config))
    end;

%% 使用物资界面
do_handle(_Cmd = 43717, Player, _) ->
    #player_status{id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    mod_kf_guild_war_local:send_props_view_info(GuildId, RoleId);

%% 使用物资
do_handle(_Cmd = 43718, Player, [PropsId]) ->
    #player_status{sid = Sid, id = RoleId, scene = SceneId, x = X, y = Y, copy_id = CopyId, figure = Figure, guild = Guild, status_kf_guild_war = StatusKfGWar} = Player,
    #figure{lv = RoleLv} = Figure,
    #status_guild{id = GuildId, name = GuildName, position = GuildPos} = Guild,
    case data_kf_guild_war:get_props_cfg(PropsId) of
        #kf_gwar_props_cfg{
            terrain = TerrainLim
        } ->
            case lists:member(GuildPos, [?POS_CHIEF, ?POS_DUPTY_CHIEF]) of
                true ->
                    #status_kf_guild_war{in_sea = InSea} = StatusKfGWar,
                    Res = if
                        TerrainLim == ?PROPS_TERRAIN_LIM_LAND andalso InSea == 1 ->
                            {false, ?ERRCODE(err437_props_can_only_use_on_land)};
                        TerrainLim == ?PROPS_TERRAIN_LIM_SEA andalso InSea == 0 ->
                            {false, ?ERRCODE(err437_props_can_only_use_on_sea)};
                        true -> ok
                    end,
                    case Res of
                        ok ->
                            case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
                                true ->
                                    case PropsId of
                                        ?PROPS_CFD_ID_1 ->
                                            ArgsMap = #{pos => {X, Y}, guild_id => GuildId, role_lv => RoleLv};
                                        ?PROPS_CFD_ID_2 ->
                                            ArgsMap = #{pos => {X, Y}, guild_id => GuildId, role_lv => RoleLv};
                                        ?PROPS_CFD_ID_3 ->
                                            ArgsMap = #{guild_id => GuildId};
                                        ?PROPS_CFD_ID_4 ->
                                            ArgsMap = #{pos => {X, Y}}
                                    end,
                                    mod_kf_guild_war_local:use_props(CopyId, GuildId, GuildName, RoleId, PropsId, ArgsMap);
                                _ ->
                                    lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err437_no_in_act_scene))
                            end;
                        {false, ErrorCode} ->
                            lib_kf_guild_war:send_error_code(Sid, ErrorCode)
                    end;
                _ ->
                    lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err437_guild_pos_lim_cant_use_props))
            end;
        _ ->
            lib_kf_guild_war:send_error_code(Sid, ?ERRCODE(err_config))
    end;

%% 进入/离开战场
do_handle(_Cmd = 43719, Player, [1]) ->
    #player_status{id = RoleId, server_id = SerId, server_name = SerName, scene = SceneId, figure = Figure, guild = Guild} = Player,
    #figure{name = Name, lv = Lv} = Figure,
    #status_guild{id = GuildId} = Guild,
    OpenLv = data_kf_guild_war:get_cfg(?CFG_ID_OPEN_LV),
    IsInScene = lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId),
    if
        IsInScene -> lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err120_already_in_scene));
        Lv < OpenLv -> lib_kf_guild_war:send_error_code(RoleId, {?ERRCODE(lv_limit), OpenLv});
        true ->
            case lib_scene:is_transferable(Player) of
                {true, _ErrCode} ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_kf_guild_war, enter_scene, [Node, SerId, SerName, GuildId, RoleId, Name]);
                {false, ErrCode} ->
                    lib_kf_guild_war:send_error_code(RoleId, ErrCode)
            end
    end;

%% 退出场景
do_handle(_Cmd = 43719, Player, [2]) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    lib_kf_guild_war_api:exit_scene(GuildId, RoleId, SceneId, CopyId);

%% 回到陆地/下海
do_handle(_Cmd = 43720, Player, [InSea]) when InSea == 0 orelse InSea == 1 ->
    #player_status{id = RoleId, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, status_kf_guild_war = StatusKfGWar} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            mod_scene_agent:update(SceneId, PoolId, RoleId, [{in_sea, InSea}]),
            NewStatusKfGWar = StatusKfGWar#status_kf_guild_war{in_sea = InSea},
            NewPlayer = Player#player_status{status_kf_guild_war = NewStatusKfGWar},
            {ok, NewPlayer};
        _ -> skip
    end;

%% 岛屿宣战信息
do_handle(_Cmd = 43726, Player, [IslandId]) ->
    #player_status{id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_declare_war_view_info, [Node, GuildId, RoleId, IslandId]);

%% 宣战出价界面
do_handle(_Cmd = 43727, Player, [IslandId]) ->
    #player_status{id = RoleId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    mod_kf_guild_war_local:send_bid_view_info(GuildId, RoleId, IslandId);

%% 宣战
do_handle(_Cmd = 43728, Player, [IslandId, Bid]) ->
    #player_status{id = RoleId, server_id = SerId, server_name = SerName, figure = Figure, guild = Guild} = Player,
    #figure{name = RoleName} = Figure,
    #status_guild{id = GuildId, name = GuildName, position = Position} = Guild,
    case GuildId > 0 of
        true ->
            case lists:member(Position, [?POS_CHIEF, ?POS_DUPTY_CHIEF]) of
                true ->
                    case data_kf_guild_war:get_island_cfg(IslandId) of
                        #kf_gwar_island_cfg{
                            seas_type = ?SEAS_TYPE_EDGE_SEA
                        } ->
                            mod_kf_guild_war_local:declare_war(SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid);
                        _ ->
                            lib_kf_guild_war:send_error_code(RoleId, ?FAIL)
                    end;
                _ ->
                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_guild_lim_cant_declare_war))
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_guild_lim_cant_declare_war))
    end;

%% 取消宣战
do_handle(_Cmd = 43729, Player, [IslandId]) ->
    #player_status{server_id = SerId, server_name = SerName, id = RoleId, figure = Figure, guild = Guild} = Player,
    #figure{name = RoleName} = Figure,
    #status_guild{id = GuildId, name = GuildName, position = Position} = Guild,
    case GuildId > 0 of
        true ->
            case lists:member(Position, [?POS_CHIEF, ?POS_DUPTY_CHIEF]) of
                true ->
                    case data_kf_guild_war:get_island_cfg(IslandId) of
                        #kf_gwar_island_cfg{
                            seas_type = ?SEAS_TYPE_EDGE_SEA
                        } ->
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(mod_kf_guild_war, cancel_declare_war, [Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId]);
                        _ ->
                            lib_kf_guild_war:send_error_code(RoleId, ?FAIL)
                    end;
                _ ->
                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_guild_lim_cant_cancel_declare_war))
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_guild_lim_cant_cancel_declare_war))
    end;

%% 战斗场景信息
do_handle(_Cmd = 43731, Player, _) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, send_scene_info, [CopyId, Node, RoleId]);
        _ -> skip
    end;

%% 响应召集
do_handle(_Cmd = 43733, Player, [X, Y]) when X > 0, Y > 0 ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, guild = Guild} = Player,
    #status_guild{id = GuildId} = Guild,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            ArgsMap = #{pos => {X, Y}},
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war_battle, reply_drum_up, [CopyId, Node, GuildId, RoleId, ArgsMap]);
        _ -> skip
    end;

%% 复活
do_handle(_Cmd = 43734, Player, [X, Y]) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    case lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId, CopyId) of
        true ->
            AllRebornPoints = data_kf_guild_war:get_reborn_points(),
            case lists:member({X, Y}, lists:sublist(AllRebornPoints, ?NORMAL_BUILDING_NUM)) of
                true ->
                    put("kf_guild_war_reborn_point", {X, Y}),
                    pp_battle:handle(20004, Player, ?REVIVE_KF_GWAR);
                _ ->
                    pp_battle:handle(20004, Player, ?REVIVE_KF_GWAR)
            end;
        _ ->
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_no_in_act_scene))
    end;

do_handle(_Cmd, _Player, _Data) ->
    {error, "pp_kf_guild_war no match~n"}.
