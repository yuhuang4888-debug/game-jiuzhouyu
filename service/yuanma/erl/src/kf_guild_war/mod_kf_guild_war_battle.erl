%%-----------------------------------------------------------------------------
%% @Module  :       mod_kf_guild_war_battle
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-26
%% @Description:    跨服公会战战斗进程
%%-----------------------------------------------------------------------------
-module(mod_kf_guild_war_battle).

-include("kf_guild_war.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("scene.hrl").

-export([start/1]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

-export([
    send_personal_score_info/3
    , send_scene_info/3
    , send_guild_score_info/3
    , send_building_info/3
    , send_exchange_ship_info/3
    , exchange_ship/5
    , use_props/5
    , drum_up/4
    , reply_drum_up/5
    , enter_scene/7
    , exit_scene/4
    , attack_mon/2
    , kill_mon/2
    , kill_player/2
    , auto_add_score/1
    , battle_end/1
    ]).

-define(COPY_ID, self()).

start(Args) ->
    gen_statem:start(?MODULE, Args, []).

callback_mode()->
    handle_event_function.

init([GuildMap, OccupierGroup, OccupierGuildId, RoomId, Round, IslandId, NowTime, ForbidPkEtime, Etime]) ->
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
    BuildingMap = init_building(SceneId, PoolId, ?COPY_ID, OccupierGroup, OccupierGuildId),
    init_normal_mon(SceneId, PoolId, ?COPY_ID),
    %% 延迟120s关闭房间
    CloseRef = erlang:send_after(max(1, Etime - NowTime + 120) * 1000, self(), {'stop'}),
    LastState = #kf_guild_war_battle{
        room_id = RoomId,
        round = Round,
        island_id = IslandId,
        ref = CloseRef,
        forbid_pk_etime = ForbidPkEtime,
        guild_map = GuildMap,
        building_map = BuildingMap,
        etime = Etime
    },
    {ok, battle, LastState}.

enter_scene(Pid, Node, SerId, SerName, GuildId, RoleId, RoleName) ->
    gen_statem:cast(Pid, {'enter_scene', Node, SerId, SerName, GuildId, RoleId, RoleName}).

exit_scene(Pid, Node, GuildId, RoleId) ->
    gen_statem:cast(Pid, {'exit_scene', Node, GuildId, RoleId}).

send_personal_score_info(Pid, Node, RoleId) ->
    gen_statem:cast(Pid, {'send_personal_score_info', Node, RoleId}).

send_guild_score_info(Pid, Node, RoleId) ->
    gen_statem:cast(Pid, {'send_guild_score_info', Node, RoleId}).

send_building_info(Pid, Node, RoleId) ->
    gen_statem:cast(Pid, {'send_building_info', Node, RoleId}).

send_scene_info(Pid, Node, RoleId) ->
    gen_statem:cast(Pid, {'send_scene_info', Node, RoleId}).

send_exchange_ship_info(Pid, Node, RoleId) ->
    gen_statem:cast(Pid, {'send_exchange_ship_info', Node, RoleId}).

exchange_ship(Pid, Node, RoleId, ShipId, ArgsMap) ->
    gen_statem:cast(Pid, {'exchange_ship', Node, RoleId, ShipId, ArgsMap}).

use_props(Pid, Node, RoleId, PropsId, ArgsMap) ->
    gen_statem:cast(Pid, {'use_props', Node, RoleId, PropsId, ArgsMap}).

drum_up(Pid, UserGuildId, UserId, ArgsMap) ->
    gen_statem:cast(Pid, {'drum_up', UserGuildId, UserId, ArgsMap}).

reply_drum_up(Pid, Node, GuildId, RoleId, ArgsMap) ->
    gen_statem:cast(Pid, {'reply_drum_up', Node, GuildId, RoleId, ArgsMap}).

attack_mon(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

kill_mon(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

kill_player(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

auto_add_score(Pid) ->
    gen_statem:cast(Pid, {'auto_add_score'}).

battle_end(Pid) ->
    gen_statem:cast(Pid, {'battle_end'}).

handle_event(Type, Msg, StateName, State) ->
    case catch do_handle_event(Type, Msg, StateName, State) of
        {keep_state, NewState} ->
            {keep_state, NewState};
        {next_state, NewStateName, NewState} ->
            {next_state, NewStateName, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _Err ->
            ?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _Err]]),
            {keep_state, State}
    end.

do_handle_event(cast, {'enter_scene', Node, SerId, SerName, GuildId, RoleId, RoleName}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        forbid_pk_etime = ForbidPkEtime,
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    case maps:get(GuildId, GuildMap, false) of
        #guild_battle_info{
            group = GroupId,
            role_num = RoleNum,
            born_point = {BornPointX, BornPointY}
        } = GuildInfo ->
            SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
            case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
                OldRoleInfo when is_record(OldRoleInfo, role_battle_info) -> skip;
                _ ->
                    OldRoleInfo = #role_battle_info{
                                    node = Node,
                                    server_id = SerId,
                                    server_name = SerName,
                                    role_id = RoleId,
                                    role_name = RoleName,
                                    guild_id = GuildId,
                                    ship_id = ?DEFAULT_SHIP_ID,
                                    ship_ids = [?DEFAULT_SHIP_ID]
                                }
            end,
            case OldRoleInfo#role_battle_info.scene =/= SceneId of
                true ->
                    GroupPeopleNumLim = data_kf_guild_war:get_cfg(?CFG_ID_GUILD_PARTICIPANTS_NUM_LIM),
                    case RoleNum < GroupPeopleNumLim of
                        true ->
                            NewRoleInfo = OldRoleInfo#role_battle_info{scene = SceneId, group = GroupId},
                            NewRoleList = [NewRoleInfo|lists:keydelete(RoleId, #role_battle_info.role_id, RoleList)],

                            NewGuildInfo = GuildInfo#guild_battle_info{role_num = RoleNum + 1},
                            NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap),

                            %% 切场景
                            KeyValueList = [
                                {group, GroupId},
                                {forbid_pk_etime, ForbidPkEtime},
                                {change_scene_hp_lim, 1},
                                {pk, {?PK_FORCE, true}},
                                {action_lock, ?ERRCODE(err437_cant_change_scene_in_kf_gwar)},
                                {in_sea, 0},
                                {ship_id, OldRoleInfo#role_battle_info.ship_id}
                            ],
                            PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
                            Args = [RoleId, SceneId, PoolId, ?COPY_ID, BornPointX, BornPointY, true, KeyValueList],
                            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args),

                            lib_kf_guild_war:send_to_uid(Node, RoleId, 43719, [?SUCCESS, ?ENTER_SCENE]),

                            NewState = State#kf_guild_war_battle{guild_map = NewGuildMap, role_list = NewRoleList};
                        _ ->
                            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_kf_gwar_role_num_lim)),
                            NewState = State
                    end;
                _ ->
                    NewState = State
            end;
        _ ->
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_no_qualifications)),
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'exit_scene', Node, GuildId, RoleId}, _, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{scene = SceneId} = OldRoleInfo ->
            NewRoleInfo = OldRoleInfo#role_battle_info{scene = 0},
            NewRoleList = [NewRoleInfo|lists:keydelete(RoleId, #role_battle_info.role_id, RoleList)],

            case maps:get(GuildId, GuildMap, false) of
                #guild_battle_info{
                    role_num = RoleNum
                } = GuildInfo ->
                    NewGuildInfo = GuildInfo#guild_battle_info{role_num = max(0, RoleNum - 1)},
                    NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap);
                _ ->
                    NewGuildMap = GuildMap
            end,

            %% 切场景
            KeyValueList = [
                {group, 0},
                {forbid_pk_etime, 0},
                {change_scene_hp_lim, 1},
                {action_free, ?ERRCODE(err437_cant_change_scene_in_kf_gwar)},
                {in_sea, 0},
                {ship_id, 1024}
            ],
            Args = [RoleId, 0, 0, 0, 0, 0, true, KeyValueList],
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene_queue, Args),

            % %% 移除buff
            % SkillId = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_3_SKILL_ID),
            % mod_clusters_center:apply_cast(Node, lib_goods_buff, remove_skill_buff, [RoleId, SkillId]),

            NewState = State#kf_guild_war_battle{guild_map = NewGuildMap, role_list = NewRoleList};
        _ ->
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_no_in_act_scene)),
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'send_personal_score_info', Node, RoleId}, battle, State) ->
    #kf_guild_war_battle{
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            scene = SceneId,
            group = GroupId,
            score = Score
        } ->
            F = fun(RewardId) ->
                case data_kf_guild_war:get_stage_reward(RewardId) of
                    #kf_gwar_stage_reward_cfg{
                        score = NeedScore
                    } when Score >= NeedScore ->
                        {RewardId, ?REWARD_HAS_RECEIVE};
                    _ ->
                        {RewardId, ?REWARD_NO_FINISH}
                end
            end,
            StageRewardList = lists:map(F, data_kf_guild_war:get_all_stage_reward_ids()),
            Args = [GroupId, Score, StageRewardList],
            lib_kf_guild_war:send_to_uid(Node, RoleId, 43712, Args);
        _ -> skip
    end,
    {keep_state, State};

do_handle_event(cast, {'send_guild_score_info', Node, RoleId}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap
    } = State,
    F = fun(GuildInfo) ->
        #guild_battle_info{
            group = GroupId,
            guild_name = GuildName,
            score = Score,
            utime = Utime
        } = GuildInfo,
        {GroupId, GuildName, Score, Utime}
    end,
    GuildList = lists:map(F, maps:values(GuildMap)),
    Args = [GuildList],
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43713, Args),
    {keep_state, State};

do_handle_event(cast, {'send_guild_score_info', _Node, _RoleId}, _, State) ->
    {keep_state, State};

do_handle_event(cast, {'send_scene_info', Node, RoleId}, battle, State) ->
    #kf_guild_war_battle{
        etime = Etime,
        forbid_pk_etime = ForbidPkEtime
    } = State,
    Args = [Etime, ForbidPkEtime],
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43731, Args),
    {keep_state, State};

do_handle_event(cast, {'send_building_info', Node, RoleId}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        building_map = BuildingMap
    } = State,
    F = fun(BuildingInfo) ->
        #building_info{
            id = BuildingId,
            guild_id = GuildId,
            hp = Hp
        } = BuildingInfo,
        #guild_battle_info{
            group = GroupId,
            guild_name = GuildName
        } = maps:get(GuildId, GuildMap, #guild_battle_info{}),
        {BuildingId, GroupId, GuildId, GuildName, Hp}
    end,
    BuildingList = lists:map(F, maps:values(BuildingMap)),
    Args = [BuildingList],
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43714, Args),
    {keep_state, State};

do_handle_event(cast, {'send_exchange_ship_info', Node, RoleId}, battle, State) ->
    #kf_guild_war_battle{
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            scene = SceneId,
            score = Score,
            ship_ids = ShipIds
        } ->
            lib_kf_guild_war:send_to_uid(Node, RoleId, 43715, [Score, ShipIds]);
        _ -> skip
    end,
    {keep_state, State};

do_handle_event(cast, {'exchange_ship', Node, RoleId, ShipId, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            scene = SceneId,
            score = Score,
            ship_ids = ShipIds
        } = RoleInfo ->
            case data_kf_guild_war:get_ship_cfg(ShipId) of
                #kf_gwar_ship_cfg{
                    condition = Condition
                } ->
                    %% 已经拥有的可以直接兑换
                    case lists:member(ShipId, ShipIds) of
                        true ->
                            NewRoleInfo = RoleInfo#role_battle_info{ship_id = ShipId},
                            NewRoleList = lists:keyreplace(RoleId, #role_battle_info.role_id, RoleList, NewRoleInfo),
                            %% 广播给场景玩家
                            #{x := X, y := Y} = ArgsMap,
                            mod_scene_agent:update(SceneId, PoolId, RoleId, [{ship_id, ShipId}]),
                            lib_scene:broadcast_player_ship_id(RoleId, SceneId, PoolId, ?COPY_ID, X, Y, ShipId),
                            Args = {?MSG_TYPE_EXCHANGE_SHIP_SUCCESS, RoleId, ShipId},
                            mod_clusters_center:apply_cast(Node, mod_kf_guild_war_local, msg_center2local, [Args]),
                            NewState = State#kf_guild_war_battle{role_list = NewRoleList};
                        _ ->
                            case check_list(Condition, ArgsMap#{score => Score}) of
                                true ->
                                    NewRoleInfo = RoleInfo#role_battle_info{ship_id = ShipId, ship_ids = [ShipId|ShipIds]},
                                    NewRoleList = lists:keyreplace(RoleId, #role_battle_info.role_id, RoleList, NewRoleInfo),
                                    %% 广播给场景玩家
                                    #{x := X, y := Y} = ArgsMap,
                                    mod_scene_agent:update(SceneId, PoolId, RoleId, [{ship_id, ShipId}]),
                                    lib_scene:broadcast_player_ship_id(RoleId, SceneId, PoolId, ?COPY_ID, X, Y, ShipId),
                                    Args = {?MSG_TYPE_EXCHANGE_SHIP_SUCCESS, RoleId, ShipId},
                                    mod_clusters_center:apply_cast(Node, mod_kf_guild_war_local, msg_center2local, [Args]),
                                    NewState = State#kf_guild_war_battle{role_list = NewRoleList};
                                {false, ErrorCode} ->
                                    NewState = State,
                                    lib_kf_guild_war:send_error_code(Node, RoleId, ErrorCode)
                            end
                    end;
                _ ->
                    NewState = State,
                    lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(missing_config))
            end;
        _ ->
            NewState = State,
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_no_in_act_scene))
    end,
    {keep_state, NewState};

do_handle_event(cast, {'use_props', _Node, _RoleId, ?PROPS_CFD_ID_1, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        guild_map = GuildMap
    } = State,
    #{pos := {X, Y}, guild_id := GuildId, role_lv := RoleLv} = ArgsMap,
    case maps:get(GuildId, GuildMap, false) of
        #guild_battle_info{
            group = GroupId
        } ->
            MonId = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_1_MON_ID),
            TextureL = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_1_MON_TEXTURE),
            SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
            PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
            case lists:keyfind(GroupId, 1, TextureL) of
                {GroupId, TextureId} when TextureId > 0 ->
                    TextureArgs = [{icon_texture, TextureId}];
                _ ->
                    TextureArgs = []
            end,
            F = fun(Index) ->
                BornPointX = round(X + 250 * math:cos(Index * 120 * 3.14 / 180)),
                BornPointY = round(Y + 250 * math:sin(Index * 120 * 3.14 / 180)),
                lib_mon:async_create_mon(MonId, SceneId, PoolId, BornPointX, BornPointY, 1, ?COPY_ID, 1, [{auto_lv, RoleLv}, {group, GroupId}|TextureArgs])
            end,
            lists:foreach(F, lists:seq(0, 2));
        _ -> skip
    end,
    {keep_state, State};

do_handle_event(cast, {'use_props', _Node, _RoleId, ?PROPS_CFD_ID_2, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        guild_map = GuildMap
    } = State,
    #{pos := {X, Y}, guild_id := GuildId, role_lv := RoleLv} = ArgsMap,
    case maps:get(GuildId, GuildMap, false) of
        #guild_battle_info{
            group = GroupId
        } ->
            MonId = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_2_MON_ID),
            TextureL = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_2_MON_TEXTURE),
            SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
            PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
            case lists:keyfind(GroupId, 1, TextureL) of
                {GroupId, TextureId} when TextureId > 0 ->
                    TextureArgs = [{icon_texture, TextureId}];
                _ ->
                    TextureArgs = []
            end,
            F = fun(Index) ->
                BornPointX = round(X + 85 * math:cos(Index * 72 * 3.14 / 180)),
                BornPointY = round(Y + 85 * math:sin(Index * 72 * 3.14 / 180)),
                lib_mon:async_create_mon(MonId, SceneId, PoolId, BornPointX, BornPointY, 1, ?COPY_ID, 1, [{auto_lv, RoleLv}, {group, GroupId}|TextureArgs])
            end,
            lists:foreach(F, lists:seq(0, 2));
        _ -> skip
    end,
    {keep_state, State};

do_handle_event(cast, {'use_props', Node, _RoleId, ?PROPS_CFD_ID_3, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        role_list = RoleList
    } = State,
    #{guild_id := GuildId} = ArgsMap,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    SkillId = data_kf_guild_war:get_cfg(?CFG_ID_PROPS_ID_3_SKILL_ID),
    RoleIds = [RoleInfo#role_battle_info.role_id || RoleInfo <- RoleList, RoleInfo#role_battle_info.scene == SceneId, RoleInfo#role_battle_info.guild_id == GuildId],
    mod_clusters_center:apply_cast(Node, lib_goods_buff, add_skill_buff_to_mul_role, [RoleIds, SkillId, 1]),
    {keep_state, State};

do_handle_event(cast, {'use_props', Node, RoleId, ?PROPS_CFD_ID_4, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        role_list = RoleList
    } = State,
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            ship_ids = ShipIds
        } = RoleInfo->
            AllShipIds = data_kf_guild_war:get_all_ship_ids(),
            MaxShipId = lists:last(AllShipIds),
            case lists:member(MaxShipId, ShipIds) of
                false ->
                    NewRoleInfo = RoleInfo#role_battle_info{ship_id = MaxShipId, ship_ids = [MaxShipId|ShipIds]},
                    NewRoleList = lists:keyreplace(RoleId, #role_battle_info.role_id, RoleList, NewRoleInfo),

                    %% 广播给场景玩家
                    #{pos := {X, Y}} = ArgsMap,
                    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
                    PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
                    mod_scene_agent:update(SceneId, PoolId, RoleId, [{ship_id, MaxShipId}]),
                    lib_scene:broadcast_player_ship_id(RoleId, SceneId, PoolId, ?COPY_ID, X, Y, MaxShipId),
                    Args = {?MSG_TYPE_EXCHANGE_SHIP_SUCCESS, RoleId, MaxShipId},
                    mod_clusters_center:apply_cast(Node, mod_kf_guild_war_local, msg_center2local, [Args]),

                    NewState = State#kf_guild_war_battle{role_list = NewRoleList};
                _ ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'drum_up', UserGuildId, UserId, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    #{pos := {X, Y}} = ArgsMap,
    case maps:get(UserGuildId, GuildMap, false) of
        GuildInfo when is_record(GuildInfo, guild_battle_info) ->
            F = fun(RoleInfo) ->
                case RoleInfo of
                    #role_battle_info{
                        node = Node,
                        role_id = RoleId,
                        guild_id = GuildId,
                        scene = SceneId
                    } when SceneId > 0, RoleId =/= UserId, GuildId == UserGuildId ->
                        Args = [X, Y],
                        lib_kf_guild_war:send_to_uid(Node, RoleId, 43732, Args);
                    _ -> skip
                end
            end,
            lists:foreach(F, RoleList),
            NewGuildInfo = GuildInfo#guild_battle_info{dump_up_point = {X, Y}},
            NewGuildMap = maps:put(UserGuildId, NewGuildInfo, GuildMap),
            NewState = State#kf_guild_war_battle{guild_map = NewGuildMap};
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'reply_drum_up', Node, GuildId, RoleId, ArgsMap}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        guild_map = GuildMap
    } = State,
    #{pos := {X, Y}} = ArgsMap,
    case maps:get(GuildId, GuildMap, false) of
        #guild_battle_info{
            dump_up_point = {X, Y}
        } ->
            XChange = X + urand:rand(-200, 200),
            YChange = Y + urand:rand(-200, 200),
            SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
            PoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
            Args = [RoleId, SceneId, PoolId, ?COPY_ID, XChange, YChange, false, []],
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, Args),

            lib_kf_guild_war:send_to_uid(Node, RoleId, 43733, [?SUCCESS]);
        _ -> skip
    end,
    {keep_state, State};

do_handle_event(cast, {'attack_mon', AttackerId, MonAid, #scene_mon{mid = Mid, create_key = {kf_gwar_building, BuildingId}} = _MonInfo, CurHp}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        building_map = BuildingMap,
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    case lists:keyfind(AttackerId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            scene = SceneId
        } = RoleInfo ->
            case maps:get(BuildingId, BuildingMap, false) of
                #building_info{
                    hp_ref = OHpRef
                } = BuildingInfo ->
                    %% 船坞一定时间内未受到攻击自动回满血量
                    util:cancel_timer(OHpRef),
                    Time = data_kf_guild_war:get_cfg(?CFG_ID_BUILDING_AUTO_RESTORE_CD),
                    NHpRef = erlang:send_after(max(1, Time) * 1000, self(), {'building_restore_hp', BuildingId, MonAid, Mid}),
                    NewBuildingInfo = BuildingInfo#building_info{hp = CurHp, hp_ref = NHpRef},
                    NewBuildingMap = maps:put(BuildingId, NewBuildingInfo, BuildingMap),
                    case data_kf_guild_war:get_building_cfg(BuildingId) of
                        #kf_gwar_building_cfg{att_score = AttackAddScore} -> skip;
                        _ -> AttackAddScore = 0
                    end,
                    NowTime = utime:unixtime(),
                    case AttackAddScore > 0 of
                        true ->
                            {NewRoleList, NewGuildMap} = handle_add_score(RoleInfo, AttackAddScore, RoleList, GuildMap, NowTime);
                        _ ->
                            NewRoleList = RoleList,
                            NewGuildMap = GuildMap
                    end,
                    %% 广播给当前场景玩家
                    send_to_scene(NewRoleList, 43723, [BuildingId, CurHp]),

                    NewState = State#kf_guild_war_battle{guild_map = NewGuildMap, building_map = NewBuildingMap, role_list = NewRoleList};
                _ ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'kill_mon', AttackerId, #scene_object{mon = #scene_mon{create_key = {kf_gwar_building, BuildingId}}} = SceneObject}, battle, State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        guild_map = GuildMap,
        building_map = BuildingMap,
        role_list = RoleList
    } = State,
    #scene_object{scene = SceneId, copy_id = CopyId, x = X, y = Y, type = Type, mon = MonInfo} = SceneObject,
    #scene_mon{mid = Mid} = MonInfo,
    case lists:keyfind(AttackerId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            guild_id = GuildId,
            group = GroupId
        } = RoleInfo ->
            case maps:get(BuildingId, BuildingMap, false) of
                #building_info{
                    guild_id = OldOccupyGuildId,
                    hp_ref = OHpRef,
                    occupy_times = OccupyTimesMap
                } = BuildingInfo ->

                    util:cancel_timer(OHpRef),
                    HpLim = lib_mon:get_hplim_by_mon_id(Mid),

                    OccupyTimes = maps:get(GuildId, OccupyTimesMap, 0),
                    case data_kf_guild_war:get_building_cfg(BuildingId) of
                        #kf_gwar_building_cfg{occupy_score = KillAddScore, texture = Texture} -> skip;
                        _ -> KillAddScore = 0, Texture = []
                    end,
                    case OccupyTimes == 0 of
                        true -> RealKillAddScore = KillAddScore;
                        _ -> RealKillAddScore = 0
                    end,

                    NewOccupyTimesMap = maps:put(GuildId, OccupyTimes + 1, OccupyTimesMap),

                    NewBuildingInfo = BuildingInfo#building_info{guild_id = GuildId, hp = HpLim, hp_ref = [], occupy_times = NewOccupyTimesMap},
                    NewBuildingMap = maps:put(BuildingId, NewBuildingInfo, BuildingMap),

                    NowTime = utime:unixtime(),
                    case RealKillAddScore > 0 of
                        true ->
                            {NewRoleList, NewGuildMap} = handle_add_score(RoleInfo, RealKillAddScore, RoleList, GuildMap, NowTime);
                        _ ->
                            NewRoleList = RoleList,
                            NewGuildMap = GuildMap
                    end,

                    LastGuildMap = handle_update_building_guild_info(OldOccupyGuildId, GuildId, NewGuildMap),

                    %% 广播给当前场景玩家
                    #guild_battle_info{guild_name = GuildName} = maps:get(GuildId, LastGuildMap, #guild_battle_info{}),
                    send_to_scene(NewRoleList, 43724, [BuildingId, GroupId, GuildId, GuildName, HpLim]),
                    %% 传闻
                    case data_kf_guild_war:get_building_cfg(BuildingId) of
                        #kf_gwar_building_cfg{
                            name = BuildingName
                        } -> skip;
                        _ -> BuildingName = <<>>
                    end,
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 3, [GuildName, BuildingName]),
                    spawn(fun() -> send_battle_tv(NewRoleList, [TvBin]) end),

                    ScenePoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
                    Args = [{group, GroupId}, {create_key, {kf_gwar_building, BuildingId}}],
                    % TextureId = lib_kf_guild_war:get_building_texture(GroupId, Texture),
                    % Args = [{group, GroupId}, {icon_texture, TextureId}, {create_key, {kf_gwar_building, BuildingId}}],
                    lib_mon:async_create_mon(Mid, SceneId, ScenePoolId, X, Y, Type, CopyId, 1, Args),

                    NewState = State#kf_guild_war_battle{guild_map = LastGuildMap, building_map = NewBuildingMap, role_list = NewRoleList};
                _ ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'kill_mon', AttackerId, #scene_object{mon = #scene_mon{create_key = {kf_gwar_normal_mon, _}}} = _SceneObject}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    case lists:keyfind(AttackerId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{
            scene = SceneId
        } = RoleInfo ->
            NowTime = utime:unixtime(),
            AddScore = data_kf_guild_war:get_cfg(?CFG_ID_KILL_MON_ADD_SCORE),
            case AddScore > 0 of
                true ->
                    {NewRoleList, NewGuildMap} = handle_add_score(RoleInfo, AddScore, RoleList, GuildMap, NowTime);
                _ ->
                    NewRoleList = RoleList,
                    NewGuildMap = GuildMap
            end,
            NewState = State#kf_guild_war_battle{guild_map = NewGuildMap, role_list = NewRoleList};
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'kill_player', RoleId, RoleName, LastAttackerId, LastAttackerName, HitList}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    case lists:keyfind(LastAttackerId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{server_name = LastAttackerSerName} -> skip;
        _ -> LastAttackerSerName = <<>>
    end,
    {NewRoleList, TvBin} = handle_be_killer(RoleList, RoleId, RoleName, LastAttackerSerName, LastAttackerName),
    {LastRoleList, NewGuildMap, TvBin1} = handle_killer(NewRoleList, HitList, GuildMap, LastAttackerId, LastAttackerSerName, LastAttackerName),
    %% 发送战斗传闻
    spawn(fun() -> send_battle_tv(LastRoleList, [TvBin, TvBin1]) end),
    NewState = State#kf_guild_war_battle{role_list = LastRoleList, guild_map = NewGuildMap},
    {keep_state, NewState};

do_handle_event(cast, {'auto_add_score'}, battle, State) ->
    #kf_guild_war_battle{
        guild_map = GuildMap,
        role_list = RoleList
    } = State,
    NowTime = utime:unixtime(),
    AddScore = data_kf_guild_war:get_cfg(?CFG_ID_SCORE_AUTO_PLUS),
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    F = fun(RoleInfo, {TmpRoleList, TmpGuildMap}) ->
        case RoleInfo of
            #role_battle_info{
                scene = SceneId,
                guild_id = GuildId
            } ->
                case maps:get(GuildId, GuildMap, false) of
                    #guild_battle_info{
                        building_num = BuildingNum
                    } ->
                        handle_add_score(RoleInfo, AddScore * BuildingNum, TmpRoleList, TmpGuildMap, NowTime);
                    _ ->
                        {TmpRoleList, TmpGuildMap}
                end;
            _ ->
                {TmpRoleList, TmpGuildMap}
        end
    end,
    {NewRoleList, NewGuildMap} = lists:foldl(F, {RoleList, GuildMap}, RoleList),
    NewState = State#kf_guild_war_battle{role_list = NewRoleList, guild_map = NewGuildMap},
    {keep_state, NewState};

do_handle_event(cast, {'auto_add_score'}, _, State) ->
    {keep_state, State};

do_handle_event(cast, {'battle_end'}, battle, State) ->
    NewState = handle_battle_end(State),
    {next_state, close, NewState};

do_handle_event(info, {'building_restore_hp', BuildingId, MonAid, Mid}, battle, State) ->
    #kf_guild_war_battle{
        building_map = BuildingMap,
        role_list = RoleList
    } = State,
    case maps:get(BuildingId, BuildingMap, false) of
        #building_info{
            hp_ref = OHpRef
        } = BuildingInfo ->
            util:cancel_timer(OHpRef),
            %% 通知怪物进程回血
            erlang:send_after(100, MonAid, {'change_attr', [{restore_hp}]}),
            HpLim = lib_mon:get_hplim_by_mon_id(Mid),
            NewBuildingInfo = BuildingInfo#building_info{hp = HpLim, hp_ref = []},
            NewBuildingMap = maps:put(BuildingId, NewBuildingInfo, BuildingMap),
            %% 广播给当前场景玩家
            send_to_scene(RoleList, 43723, [BuildingId, HpLim]),
            NewState = State#kf_guild_war_battle{building_map = NewBuildingMap};
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(info, {'close'}, _, State) ->
    #kf_guild_war_battle{
        role_list = RoleList
    } = State,
    F = fun(RoleInfo) ->
        case RoleInfo of
            #role_battle_info{server_id = SerId, role_id = RoleId, scene = SceneId} when SceneId > 0 ->
                %% 踢玩家出场景
                KeyValueList = [
                    {group, 0},
                    {forbid_pk_etime, 0},
                    {change_scene_hp_lim, 1},
                    {action_free, ?ERRCODE(err437_cant_change_scene_in_kf_gwar)}
                ],
                Args = [RoleId, 0, 0, 0, 0, 0, true, KeyValueList],
                mod_clusters_center:apply_cast(SerId, lib_scene, player_change_scene_queue, Args);
            _ -> skip
        end
    end,
    lists:foreach(F, RoleList),
    NewState = State#kf_guild_war_battle{role_list = []},
    {keep_state, NewState};

do_handle_event(info, {'stop'}, _, State) ->
    #kf_guild_war_battle{ref = Ref} = State,
    util:cancel_timer(Ref),
    {stop, normal, State};

do_handle_event(_Type, _Msg, StateName, State) ->
    ?ERR("no match :~p~n", [[_Type, _Msg, StateName]]),
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.

init_building(SceneId, PoolId, CopyId, OccupierGroup, OccupierGuildId) ->
    BuildingIds = data_kf_guild_war:get_all_building_ids(),
    CodeBuildingId = lib_kf_guild_war:get_code_building_id(),
    do_init_building(BuildingIds, SceneId, PoolId, CopyId, OccupierGroup, OccupierGuildId, CodeBuildingId, 0, #{}).

do_init_building([BuildingId|T], SceneId, PoolId, CopyId, OccupierGroup, OccupierGuildId, CodeBuildingId, Broadcast, BuildingMap) ->
    #kf_gwar_building_cfg{
        mid = MonId,
        pos = {X, Y},
        texture = Texture
    } = data_kf_guild_war:get_building_cfg(BuildingId),
    % case OccupierGroup > 0 of
    %     true ->
    %         TextureId = lib_kf_guild_war:get_building_texture(OccupierGroup, Texture),
    %         TextureArgs = [{icon_texture, TextureId}];
    %     _ ->
    %         TextureArgs = []
    % end,
    TextureArgs = [],
    case BuildingId == CodeBuildingId of
        true ->
            HurtCheckArgs = [{hurt_check, {lib_kf_guild_war_api, check_attack_code_building, []}}];
        _ ->
            HurtCheckArgs = []
    end,
    lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, 0, CopyId, Broadcast, HurtCheckArgs ++ [{group, OccupierGroup}, {create_key, {kf_gwar_building, BuildingId}}|TextureArgs]),
    BuildingInfo = #building_info{
        id = BuildingId,
        guild_id = OccupierGuildId,
        hp = lib_mon:get_hplim_by_mon_id(MonId)
    },
    NewBuildingMap = maps:put(BuildingId, BuildingInfo, BuildingMap),
    do_init_building(T, SceneId, PoolId, CopyId, OccupierGroup, OccupierGuildId, CodeBuildingId, Broadcast, NewBuildingMap);
do_init_building([], _, _, _, _, _, _, _, BuildingMap) -> BuildingMap.

init_normal_mon(SceneId, PoolId, CopyId) ->
    #ets_scene{mon = Mon} = Scene = data_scene:get(SceneId),
    do_init_normal_mon(Mon, Scene, PoolId, CopyId, 0).

do_init_normal_mon([[MonId, X, Y, Type, Group] | T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast) ->
    case data_mon:get(MonId) of
        #mon{kind = Kind, lv = Lv} ->
            lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, Type, CopyId, Broadcast, [{group, Group}, {create_key, {kf_gwar_normal_mon, 0}}]),
            mod_scene_mon:insert(#ets_scene_mon{id = MonId, x = X, y = Y, scene = SceneId, kind = Kind, lv = Lv});
        _ -> skip
    end,
    do_init_normal_mon(T, Scene, PoolId, CopyId, Broadcast);
do_init_normal_mon([H|T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast) ->
    ?ERR("scene mon format error scene_id = ~p mon = ~p~n", [SceneId, H]),
    do_init_normal_mon(T, Scene, PoolId, CopyId, Broadcast);
do_init_normal_mon([], _, _, _, _) -> ok.

check_list([], _) -> true;
check_list([T|L], ArgsMap) ->
    case check(T, ArgsMap) of
        true -> check_list(L, ArgsMap);
        Res -> Res
    end.

check({score, NeedScore}, ArgsMap) ->
    #{score := Score} = ArgsMap,
    case Score >= NeedScore of
        true -> true;
        _ -> {false, ?ERRCODE(err437_no_enough_score_to_exchange_ship)}
    end;
check({pos, NeedGuildPos}, ArgsMap) ->
    #{guild_pos := GuildPos} = ArgsMap,
    %% GuildPos越小表示公会职位越高
    case GuildPos =< NeedGuildPos of
        true -> true;
        _ -> {false, ?ERRCODE(err437_guild_pos_lim_to_exchange_ship)}
    end;
check(_, _) ->
    {false, ?ERRCODE(err_config)}.

% handle_add_score(RoleId, AddScore, RoleList, GuildMap, SceneId, NowTime) ->
%     case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
%         #role_battle_info{
%             scene = SceneId
%         } = RoleInfo ->
%             handle_add_score(RoleInfo, AddScore, RoleList, GuildMap, NowTime);
%         _ -> skip
%     end.

handle_update_building_guild_info(OldOccupyGuildId, NewOccupyGuildId, GuildMap) ->
    case maps:get(OldOccupyGuildId, GuildMap, false) of
        #guild_battle_info{
            building_num = BuildingNum
        } = GuildInfo ->
            NewGuildMap = maps:put(OldOccupyGuildId, GuildInfo#guild_battle_info{building_num = max(0, BuildingNum - 1)}, GuildMap);
        _ -> NewGuildMap = GuildMap
    end,
    case maps:get(NewOccupyGuildId, NewGuildMap, false) of
        #guild_battle_info{
            building_num = BuildingNum1
        } = GuildInfo1 ->
            LastGuildMap = maps:put(NewOccupyGuildId, GuildInfo1#guild_battle_info{building_num = min(5, BuildingNum1 + 1)}, NewGuildMap);
        _ -> LastGuildMap = NewGuildMap
    end,
    LastGuildMap.

handle_add_score(RoleId, AddScore, RoleList, GuildMap, NowTime) when is_integer(RoleId) ->
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{} = RoleInfo ->
            handle_add_score(RoleInfo, AddScore, RoleList, GuildMap, NowTime);
        _ -> {RoleList, GuildMap}
    end;
handle_add_score(RoleInfo, AddScore, RoleList, GuildMap, NowTime) ->
    #role_battle_info{
        server_id = SerId,
        role_id = RoleId,
        guild_id = GuildId,
        score = PersonalScore,
        group = GroupId
    } = RoleInfo,
    NewRoleInfo = RoleInfo#role_battle_info{score = PersonalScore + AddScore},
    NewRoleList = [NewRoleInfo|lists:keydelete(RoleId, #role_battle_info.role_id, RoleList)],
    %% 计算能达到的阶段奖励
    F = fun(RewardId, {Acc1, Acc2}) ->
        case data_kf_guild_war:get_stage_reward(RewardId) of
            #kf_gwar_stage_reward_cfg{
                score = NeedScore,
                reward = OneStageReward
            } when PersonalScore < NeedScore, PersonalScore + AddScore >= NeedScore ->
                {OneStageReward ++ Acc1, [{RewardId, ?REWARD_HAS_RECEIVE}|Acc2]};
            #kf_gwar_stage_reward_cfg{
                score = NeedScore
            } when PersonalScore >= NeedScore ->
                {Acc1, [{RewardId, ?REWARD_HAS_RECEIVE}|Acc2]};
            #kf_gwar_stage_reward_cfg{} ->
                {Acc1, [{RewardId, ?REWARD_NO_FINISH}|Acc2]};
            _ ->
                {Acc1, Acc2}
        end
    end,
    {ObtainStageReward, PackStageRewardL} = lists:foldl(F, {[], []}, data_kf_guild_war:get_all_stage_reward_ids()),
    case ObtainStageReward =/= [] of
        true -> %% 达成阶段奖励
            Args = [GroupId, PersonalScore + AddScore, PackStageRewardL],
            lib_kf_guild_war:send_to_uid(SerId, RoleId, 43712, Args),
            Produce = lib_goods_api:make_produce(kf_gwar_stage_reward, 0, utext:get(203), utext:get(204), ulists:object_list_merge(ObtainStageReward), 1),
            mod_clusters_center:apply_cast(SerId, lib_goods_api, send_reward_with_mail, [RoleId, Produce]);
        _ -> %% 没有达成阶段奖励
            Args = [PersonalScore + AddScore],
            lib_kf_guild_war:send_to_uid(SerId, RoleId, 43725, Args)
    end,
    case maps:get(GuildId, GuildMap, false) of
        #guild_battle_info{
            score = GuildScore
        } = GuildInfo ->
            NewGuildInfo = GuildInfo#guild_battle_info{score = GuildScore + AddScore, utime = NowTime},
            NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap),
            {NewRoleList, NewGuildMap};
        _ -> {NewRoleList, GuildMap}
    end.

handle_be_killer(RoleList, RoleId, RoleName, AttackerSerName, AttackerName) ->
    case lists:keyfind(RoleId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{combo = Combo, die_num = DieNum} = OldRoleInfo ->
            %% 被终结连杀传闻
            if
                Combo >= 5 andalso Combo < 10 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 8, [AttackerSerName, AttackerName, RoleName]);
                Combo >= 10 andalso Combo < 20 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 8, [AttackerSerName, AttackerName, RoleName]);
                Combo >= 20 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 8, [AttackerSerName, AttackerName, RoleName]);
                true ->
                    TvBin = []
            end,
            NewRoleInfo = OldRoleInfo#role_battle_info{combo = 0, die_num = DieNum + 1},
            NewRoleList = [NewRoleInfo|lists:keydelete(RoleId, #role_battle_info.role_id, RoleList)],
            {NewRoleList, TvBin};
        _ -> {RoleList, []}
    end.

handle_killer(RoleList, HitList, GuildMap, AttackerId, _AttackerSerName, AttackerName) ->
    case lists:keyfind(AttackerId, #role_battle_info.role_id, RoleList) of
        #role_battle_info{role_name = _RoleName, kill_num = KillNum, combo = Combo} = OldRoleInfo ->
            NewCombo = Combo + 1,
            %% 连杀传闻
            if
                NewCombo == 5 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 4, [AttackerName]);
                NewCombo == 10 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 5, [AttackerName]);
                NewCombo == 20 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_GUILD_WAR, 6, [AttackerName]);
                true ->
                    TvBin = []
            end,
            NewRoleInfo = OldRoleInfo#role_battle_info{kill_num = KillNum + 1, combo = NewCombo},
            KillAddScore = data_kf_guild_war:get_cfg(?CFG_ID_KILL_PLAYER_ADD_SCORE),
            AssistsAddScore = data_kf_guild_war:get_cfg(?CFG_ID_ASSISTS_ADD_SCORE),
            NowTime = utime:unixtime(),
            {NewRoleList, NewGuildMap} = handle_add_score(NewRoleInfo, KillAddScore, RoleList, GuildMap, NowTime),
            F = fun(AssisterId, {TmpList, TmpMap}) ->
                handle_add_score(AssisterId, AssistsAddScore, TmpList, TmpMap, NowTime)
            end,
            {LastRoleList, LastGuildMap} = lists:foldl(F, {NewRoleList, NewGuildMap}, HitList),
            {LastRoleList, LastGuildMap, TvBin};
        _ -> {RoleList, GuildMap, []}
    end.

send_battle_tv([], _) -> skip;
send_battle_tv([RoleInfo|L], TvBinL) ->
    case RoleInfo of
        #role_battle_info{node = Node, role_id = RoleId, scene = Scene} when Scene > 0 ->
            F = fun(BinData) ->
                lib_clusters_center:send_to_uid(Node, RoleId, BinData)
            end,
            lists:foreach(F, TvBinL);
        _ -> skip
    end,
    send_battle_tv(L, TvBinL).

send_to_scene(RoleList, Cmd = 43721, [OwnerShipId, GuildList]) ->
    case lists:keyfind(1, #guild_battle_info.ranking, GuildList) of
        #guild_battle_info{
            ser_id = WinnerSId,
            guild_id = WinnerId
        } -> skip;
        _ -> WinnerSId = 0, WinnerId = 0
    end,
    F = fun(GuildInfo, Acc) ->
        case GuildInfo of
            #guild_battle_info{
                ranking = Ranking,
                guild_id = GuildId,
                guild_name = GuildName,
                score = Score
            } ->
                case data_kf_guild_war:get_ranking_reward(Ranking) of
                    #kf_gwar_ranking_reward_cfg{
                        score_plus = ScorePlus,
                        reward = Reward
                    } -> skip;
                    _ -> ScorePlus = 0, Reward = []
                end,
                [{Ranking, GuildId, GuildName, Score, ScorePlus, Reward}|Acc];
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], GuildList),
    spawn(fun() ->
        do_send_to_scene(RoleList, 1, Cmd, [OwnerShipId, WinnerSId, WinnerId, PackList])
    end);
send_to_scene(RoleList, Cmd = 43722, [KillRankingL]) ->
    F = fun(RoleInfo, Acc) ->
        case RoleInfo of
            #role_battle_info{
                ranking = Ranking,
                server_id = SerId,
                role_id = RoleId,
                role_name = RoleName,
                kill_num = KillNum,
                combo = Combo
            } ->
                Reward = data_kf_guild_war:get_kill_ranking_reward(Ranking),
                [{Ranking, SerId, RoleId, RoleName, KillNum, Combo, Reward}|Acc];
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], KillRankingL),
    spawn(fun() ->
        do_send_to_scene(RoleList, 1, Cmd, [PackList])
    end);
send_to_scene(RoleList, Cmd = 43723, Args) ->
    spawn(fun() ->
        do_send_to_scene(RoleList, 1, Cmd, Args)
    end);
send_to_scene(RoleList, Cmd = 43724, Args) ->
    spawn(fun() ->
        do_send_to_scene(RoleList, 1, Cmd, Args)
    end);
send_to_scene(_, _, _) -> skip.

do_send_to_scene([], _, _, _) -> ok;
do_send_to_scene([RoleInfo|L], Acc, Cmd, Data) ->
    case Acc rem 20 of
        0 -> timer:sleep(200);
        _ -> skip
    end,
    case RoleInfo of
        #role_battle_info{
            server_id = SerId,
            role_id = RoleId,
            scene = SceneId
        } when SceneId > 0 ->
            lib_kf_guild_war:send_to_uid(SerId, RoleId, Cmd, Data),
            do_send_to_scene(L, Acc + 1, Cmd, Data);
        _ ->
            do_send_to_scene(L, Acc, Cmd, Data)
    end.

handle_battle_end(State) ->
    #kf_guild_war_battle{
        room_id = RoomId,
        island_id = IslandId,
        guild_map = GuildMap,
        building_map = BuildingMap,
        role_list = RoleList
    } = State,

    %% 15s后踢玩家出场景
    erlang:send_after(15 * 1000, self(), {'close'}),

    F = fun(T) ->
        case T of
            #building_info{hp_ref = HpRef} ->
                util:cancel_timer(HpRef);
            _ -> skip
        end
    end,
    lists:foreach(F, maps:values(BuildingMap)),

    %% 移除怪物
    SceneId = data_kf_guild_war:get_cfg(?CFG_ID_SCENE_ID),
    ScenePoolId = lib_kf_guild_war:count_scene_pool_id(RoomId),
    lib_mon:clear_scene_mon(SceneId, ScenePoolId, ?COPY_ID, 0),

    {OwnerShipId, GuildRankingL} = count_winner(BuildingMap, GuildMap),
    SortRoleList = sort_kill_list(RoleList),

    send_to_scene(RoleList, 43721, [OwnerShipId, GuildRankingL]),
    send_to_scene(RoleList, 43722, [SortRoleList]),

    spawn(fun() ->
        send_role_reward(SortRoleList, GuildRankingL, utime:unixtime(), 1)
    end),

    spawn(fun() ->
        %% 随机延迟一小段时间处理结算
        timer:sleep(urand:rand(1, 300)),
        mod_kf_guild_war:island_battle_end(IslandId, GuildRankingL)
    end),

    State#kf_guild_war_battle{
        role_list = SortRoleList
    }.

sort_guild_list(GuildList, StartRanking) ->
    F = fun(AGuildInfo, BGuildInfo) ->
        if
            AGuildInfo#guild_battle_info.score == BGuildInfo#guild_battle_info.score ->
                AGuildInfo#guild_battle_info.utime < BGuildInfo#guild_battle_info.utime;
            true ->
                AGuildInfo#guild_battle_info.score > BGuildInfo#guild_battle_info.score
        end
    end,
    SortList = lists:sort(F, GuildList),
    F1 = fun(T, {Ranking, Acc}) ->
        NewT = T#guild_battle_info{ranking = Ranking},
        {Ranking + 1, [NewT|Acc]}
    end,
    {_, RankL} = lists:foldl(F1, {StartRanking, []}, SortList),
    RankL.

sort_kill_list(RoleList) ->
    F = fun(ARoleInfo, BRoleInfo) ->
        if
            ARoleInfo#role_battle_info.kill_num == BRoleInfo#role_battle_info.kill_num ->
                ARoleInfo#role_battle_info.max_combo >= BRoleInfo#role_battle_info.kill_num;
            true ->
                ARoleInfo#role_battle_info.kill_num > BRoleInfo#role_battle_info.kill_num
        end
    end,
    SortList = lists:sort(F, RoleList),
    F1 = fun(T, {Ranking, Acc}) ->
        NewT = T#role_battle_info{ranking = Ranking},
        {Ranking + 1, [NewT|Acc]}
    end,
    {_, RankL} = lists:foldl(F1, {1, []}, SortList),
    RankL.

%% 计算获胜的公会
count_winner(BuildingMap, GuildMap) ->
    %% 默认区最大的建筑id作为海神像的建筑id
    CodeBuildingId = lib_kf_guild_war:get_code_building_id(),
    case maps:get(CodeBuildingId, BuildingMap, #building_info{}) of
        #building_info{
            guild_id = OccupierGuildId
        } when OccupierGuildId > 0 ->
            case maps:get(OccupierGuildId, GuildMap, false) of
                WinnerGuildInfo when is_record(WinnerGuildInfo, guild_battle_info) ->
                    NewGuildMap = maps:remove(OccupierGuildId, GuildMap),
                    SortGuildL = sort_guild_list(maps:values(NewGuildMap), 2),
                    {OccupierGuildId, [WinnerGuildInfo#guild_battle_info{ranking = 1}|SortGuildL]};
                _ ->
                    {0, sort_guild_list(maps:values(GuildMap), 1)}
            end;
        _ ->
            {0, sort_guild_list(maps:values(GuildMap), 1)}
    end.

send_role_reward([], _GuildRankingL, _NowTime, _Acc) -> skip;
send_role_reward([RoleInfo|L], GuildRankingL, NowTime, Acc) ->
    case Acc rem 20 of
        true -> timer:sleep(100);
        _ -> skip
    end,
    case RoleInfo of
        #role_battle_info{
            node = Node,
            server_id = SerId,
            server_name = SerName,
            role_id = RoleId,
            role_name = RoleName,
            kill_num = KillNum,
            max_combo = MaxCombo,
            ranking = Ranking,
            guild_id = GuildId
        } ->
            KillRankingReward = data_kf_guild_war:get_kill_ranking_reward(Ranking),
            case lists:keyfind(GuildId, #guild_battle_info.guild_id, GuildRankingL) of
                #guild_battle_info{
                    ranking = GuildRanking
                } ->
                    case data_kf_guild_war:get_ranking_reward(GuildRanking) of
                        #kf_gwar_ranking_reward_cfg{
                            reward = GuildReward
                        } -> skip;
                        _ -> GuildReward = []
                    end;
                _ -> GuildRanking = 0, GuildReward = []
            end,
            RealRewardL = KillRankingReward ++ GuildReward,
            %% 日志
            lib_log_api:log_kf_guild_war_ranking_reward(SerId, SerName, RoleId, RoleName, KillNum, MaxCombo, Ranking, KillRankingReward, GuildRanking, GuildReward, NowTime),
            case RealRewardL =/= [] of
                true ->
                    Args = [[RoleId], utext:get(4370001), utext:get(4370002), RealRewardL],
                    mod_clusters_center:apply_cast(Node, lib_mail_api, send_sys_mail, Args),
                    send_role_reward(L, GuildRankingL, NowTime, Acc + 1);
                _ ->
                    send_role_reward(L, GuildRankingL, NowTime, Acc)
            end;
        _ ->
            send_role_reward(L, GuildRankingL, NowTime, Acc)
    end.
