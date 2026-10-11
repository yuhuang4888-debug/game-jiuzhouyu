%% ---------------------------------------------------------------------------
%% @doc lib_guild_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-28
%% @deprecated 公会接口
%% ---------------------------------------------------------------------------
-module(lib_guild_api).
-export([

    ]).

-compile(export_all).

-include("guild.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("common.hrl").
-include("activitycalen.hrl").
-include("rec_offline.hrl").

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv, guild_id = GuildId} } = Player,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{lv, Lv}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{guild_id = GuildId}, combat_power = CombatPower} = Player,
    case GuildId > 0 of
        true ->
            mod_guild:update_guild_member_power(RoleId, CombatPower);
        false ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{picture = Picture, picture_ver = PictureVer, guild_id = GuildId} } = Player,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{picture, Picture}, {picture_ver, PictureVer}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = OnlineFlag}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{guild_id = GuildId}, online = OldOnlineFlag} = Player,
    case GuildId > 0 of
        true ->
            NowTime = utime:unixtime(),
            if
                OnlineFlag == ?ONLINE_ON -> %% 这里顺序不要改 时间要在online_flag前面
                    mod_guild:update_guild_member_attr(RoleId, [{last_login_time, NowTime}, {online_flag, ?ONLINE_ON}]);
                OldOnlineFlag == ?ONLINE_ON andalso OnlineFlag == ?ONLINE_OFF ->
                    mod_guild:update_guild_member_attr(RoleId, [{last_logout_time, NowTime}, {online_flag, ?ONLINE_OFF}]);
                true -> skip
            end;
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{guild_id = GuildId, vip = Vip} } = Player,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{vip, Vip}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_GUILD_QUIT, data = [_LeaveGuildId, _LeaveDonate]}) when is_record(Player, player_status) ->
    AttrList = [
        {guild_id, 0}
        , {guild_name, <<>>}
        , {guild_lv, 0}
        , {position, 0}
        , {position_name, <<>>}
        , {create_time, 0}
        , {realm, 0}
        ],
    {ok, NewPlayer} = lib_guild:update_and_send_guild_info(Player, AttrList),
    lib_guild:send_out_from_guild_station_scene(NewPlayer),
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_GUILD_DISBAND, data = _LeaveGuildId}) when is_record(Player, player_status) ->
    AttrList = [
        {guild_id, 0}
        , {guild_name, <<>>}
        , {guild_lv, 0}
        , {position, 0}
        , {position_name, <<>>}
        , {create_time, 0}
        , {realm, 0}
        ],
    {ok, NewPlayer} = lib_guild:update_and_send_guild_info(Player, AttrList),
    lib_guild:send_out_from_guild_station_scene(NewPlayer),
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_RENAME, data = Name}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{guild_id = GuildId}} = Player,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{name, Name}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TURN_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{guild_id = GuildId, turn = Turn}} = Player,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{turn, Turn}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TRANSFER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{guild_id = GuildId} = Figure,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{figure, Figure}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_SUPVIP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{guild_id = GuildId} = Figure,
    case GuildId > 0 of
        true -> mod_guild:update_guild_member_attr(RoleId, [{figure, Figure}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, _Event) ->
    {ok, Player}.

handle_event(_Event) ->
    ok.

%% ------------- mod_guild进程内部调用,不要导致报错 ------------------

%% 创建公会
create_guild(Guild, GuildMember) ->
    lib_guild_util:log_guild_member(Guild, ?GLOG_CREATE, [GuildMember]),
    %lib_guild_battle_api:create_guild(Guild),
    ok.

%% 加入公会
join_guild(?GEVENT_JOIN_GUILD, Guild, ChiefMember, GuildMember) ->
    common_join_guild(Guild, GuildMember),
    #guild_member{id = ChiefId, figure = ChiefFigure} = ChiefMember,
    #guild_member{id = GuildMemberId, figure = #figure{name = RoleName}, guild_id = GuildId} = GuildMember,
    lib_chat:send_TV({guild, GuildId}, ChiefId, ChiefFigure, ?MOD_GUILD, 5, [RoleName, GuildMemberId]),
    ok.

join_guild(?GEVENT_CREATE_GUILD, Guild, GuildMember) ->
    common_join_guild(Guild, GuildMember),
    ok.

common_join_guild(Guild, GuildMember) ->
    #guild_member{id = RoleId, guild_id = GuildId, guild_name = GuildName, position = Position, create_time = CreateTime, figure = Figure, combat_power = CombatPower} = GuildMember,
    PositionNameMap = lib_guild_data:get_position_name_map(GuildId),
    PositionName = maps:get(Position, PositionNameMap, ""),
    List = [
        {guild_id, GuildId}
        , {guild_name, GuildName}
        , {guild_lv, Guild#guild.lv}
        , {position, Position}
        , {position_name, PositionName}
        , {create_time, CreateTime}
        , {realm, Guild#guild.realm}
        ],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    mod_chat_agent:update(RoleId, [{guild_id, GuildId}, {guild_name, GuildName}, {camp, Guild#guild.realm}]),
    % lib_relationship:update_rela_role_info(RoleId,
    %                                        [{guild_id, GuildId}, {guild_name, GuildName}, {position, Position}, {position_name, PositionName}]),
    lib_player_event:async_dispatch(RoleId, ?HAND_OFFLINE, ?EVENT_JOIN_GUILD, GuildId),
    %lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_common_rank_api, reflash_role_info, []),
    lib_role:update_role_show(
        RoleId
        , [{guild_id, GuildId}, {guild_name, GuildName}, {position, Position}, {position_name, PositionName}, {camp, Guild#guild.realm}]
    ),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild, update_guild_name, [GuildId, util:make_sure_binary(GuildName)]),
    lib_guild_util:log_guild_member(Guild, ?GLOG_JOIN, [GuildMember]),
    lib_mail_api:send_sys_mail([RoleId], utext:get(4000006), utext:get(4000007, [GuildName]), []),
    % position_name
    GuildMember1 = GuildMember#guild_member{figure = Figure#figure{position_name = PositionName}},
    lib_guild_data:update_guild_member(GuildMember1),
    %% 刷新榜单
    lib_common_rank_api:reflash_rank_by_guild(Guild),
    %% 触发任务
    lib_task_api:join_guild(RoleId),
    %% 公会副本信息更新
    lib_guild_dun:join_guild(RoleId, GuildId),
    %% 触发成就在 data_static_event中处理
    % lib_achievement_api:join_guild_event(RoleId, GuildId),
    %% 公会争霸运营活动
    %mod_custom_act_gwar:join_guild(RoleId, GuildId),
    %% 公会红包
    mod_red_envelopes:join_guild(RoleId, GuildId),
    %% 推送新的公会权限给客户端
    lib_guild:send_permission_list_to_role(RoleId, GuildId, Position),
    mod_guild_prestige:join_guild([RoleId, GuildId]),
    %% 海域内政更新
    #figure{vip = Vip, lv = Lv, name = RName, exploit = Exploit} = Figure,
    Arg = {Guild#guild.realm, GuildId, GuildName, Vip, RoleId, RName, Lv, Exploit, CombatPower},
    mod_seacraft_local:member_join_guild(RoleId, Arg),
    mod_sea_treasure_local:update_role_info({guild, RoleId, GuildId, GuildName}),
    ok.

%% 退出公会
% 主动退出公会
quit_guild(?GEVENT_QUIT, Guild, GuildMember) ->
    common_quit_guild(?GEVENT_QUIT, Guild, GuildMember),
    lib_guild_util:log_guild_member(Guild, ?GLOG_QUIT, [GuildMember]),
    ok;
% 被踢出公会
quit_guild(?GEVENT_KICK_OUT, Guild, GuildMember) ->
    common_quit_guild(?GEVENT_KICK_OUT, Guild, GuildMember),
    lib_guild_util:log_guild_member(Guild, ?GLOG_KICK_OUT, [GuildMember]),
    lib_mail_api:send_sys_mail([GuildMember#guild_member.id], utext:get(4000013), utext:get(4000014), []),
    ok.

common_quit_guild(QuitType, Guild, GuildMember) ->
    #guild_member{id = RoleId, guild_id = GuildId, donate = Donate} = GuildMember,
    % spawn(fun() -> lib_guild:db_player_guild_replace(RoleId, Donate, GuildId) end),
    lib_player_event:async_dispatch(RoleId, ?EVENT_GUILD_QUIT, [GuildId, Donate]),
    mod_chat_agent:update(RoleId, [{guild_id, 0}, {guild_name, <<>>}, {position, 0}, {position_name, <<>>}, {realm, 0}]),
    % lib_relationship:update_rela_role_info(RoleId, [{guild_id, 0}, {guild_name, <<>>}]),
    lib_auction_api:quit_guild(RoleId),
    lib_act_join_api:quit_guild(RoleId),
    % lib_tsmap:quit_guild(RoleId),
    mod_red_envelopes:quit_guild(RoleId, GuildId),
    lib_offline_api:update_offline_ps(RoleId, [{guild_id, 0}, {guild_name, <<>>}, {camp, 0}]),
    %lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_common_rank_api, reflash_role_info, []),
    lib_role:update_role_show(
        RoleId, [{guild_id, 0}, {guild_name, <<>>}, {position, 0}, {position_name, <<>>}, {camp, 0}]
        ),
    %% 移除第一公会称号
    DesignationId = lib_common_rank_api:get_guild_title_id(),
    case DesignationId > 0 of
        true ->
            lib_designation_api:cancel_dsgt(RoleId, DesignationId);
        false -> skip
    end,
    %% 刷新榜单
    lib_common_rank_api:reflash_rank_by_guild(Guild),
    lib_guild_create_act:update_act_reward_status(Guild),
    lib_guild_dun:quit_guild(RoleId, GuildId),
    %% 公会争霸运营活动
    %%mod_custom_act_gwar:quit_guild(RoleId, GuildId),
    %% 推送新的公会权限给客户端
    lib_guild:send_permission_list_to_role(RoleId, GuildId, 0),
    mod_guild_prestige:leave_guild([QuitType, RoleId, GuildId]),
    mod_seacraft_local:exit_guild(config:get_server_id(), [RoleId], Guild#guild.realm, [{num, GuildId, Guild#guild.member_num}]),
    mod_seacraft_local:member_quit_guild(Guild#guild.realm, [RoleId]),
    mod_sea_treasure_local:update_role_info({guild_quit, RoleId}),
    ok.

%% 解散公会
%% @param ChiefGuildMember #guild_member{} | []
disband_guild(Guild, ChiefGuildMember, GuildMemberList) ->
    #guild{id = GuildId, realm = Camp} = Guild,
    F = fun(GuildMember) -> guild_member_af_disband_guild(GuildMember) end,
    lists:foreach(F, GuildMemberList),
    lib_guild_util:log_guild_member(Guild, ?GLOG_DISBAND, [ChiefGuildMember]),
    lib_common_rank_api:disband_guild(GuildId),
    mod_red_envelopes:disband_guild(GuildId),
    ServerId = config:get_server_id(),
    RoleIdIdList = [RoleId || #guild_member{id = RoleId} <- GuildMemberList],
    mod_seacraft_local:exit_guild(ServerId, RoleIdIdList, Camp, [{delete, GuildId}]),
    mod_seacraft_local:member_quit_guild(Guild#guild.realm, RoleIdIdList),
    mod_sea_treasure_local:update_role_info({guild_disband, RoleIdIdList}),
    ok.

guild_member_af_disband_guild(GuildMember) ->
    #guild_member{id = RoleId, guild_id = GuildId} = GuildMember,
    % spawn(fun() -> lib_guild:db_player_guild_replace(RoleId, Donate, GuildId) end),
    lib_player_event:async_dispatch(RoleId, ?HAND_OFFLINE, ?EVENT_GUILD_DISBAND, GuildId),
    mod_chat_agent:update(RoleId, [{guild_id, 0}, {guild_name, <<>>}, {camp, 0}]),
    % lib_relationship:update_rela_role_info(RoleId, [{guild_id, 0}, {guild_name, <<>>}, {position, 0}, {position_name, <<>>}]),
    lib_auction_api:quit_guild(RoleId),
    lib_act_join_api:quit_guild(RoleId),
    % lib_tsmap:quit_guild(RoleId),
    lib_offline_api:update_offline_ps(RoleId, [{guild_id, 0}, {guild_name, <<>>}, {camp, 0}]),
    %lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_common_rank_api, reflash_role_info, []),
    lib_sanctuary:guild_member_af_disband_guild(GuildMember),
    lib_role:update_role_show(
        RoleId
        , [{guild_id, 0}, {guild_name, <<>>}, {position, 0}, {position_name, <<>>}, {camp, 0}]
    ),
    ok.

%% 更改公会玩家信息
%% @param Type: 1-10

%% 变成会长
change_guild_member(EventType, [Guild, OldChiefMember, OldGuildMember, GuildMember, AppointType]) when
        EventType == ?GEVENT_APPOINT_POSITION_TO_CHIEF ->
    #guild_member{id = RoleId, figure = Figure, guild_id = GuildId, position = Position, combat_power = Power} = GuildMember,
    #figure{name = RoleName, lv = RoleLv, picture = Picture, picture_ver = PictureVer} = Figure,
    PositionNameMap = lib_guild_data:get_position_name_map(GuildId),
    PositionName = maps:get(Position, PositionNameMap, ""),
    List = [{position, Position}, {position_name, PositionName}],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    % 邮件
    OldChiefName = OldChiefMember#guild_member.figure#figure.name,
    GuildName = Guild#guild.name,
    case AppointType of
        ?MANUAL_APPOINT ->
            LogType = ?GLOG_POS_CHANGE,
            lib_mail_api:send_sys_mail([RoleId], utext:get(4000008), utext:get(4000010, [OldChiefName, GuildName]), []);
        _ ->
            LogType = ?GLOG_AUTO_CHIEF,
            lib_mail_api:send_sys_mail([RoleId], utext:get(4000008), utext:get(4000009, [GuildName]), [])
    end,
    % 传闻
    lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD, 2, [RoleName]),
    lib_role:update_role_show(RoleId, [{position, Position}, {position_name, PositionName}]),
    %lib_guild_battle_api:update_guild_info(GuildId, [{chief_id, [RoleId, RoleName]}]),
    mod_territory_war:change_chief(GuildId, OldChiefMember#guild_member.id, RoleId, RoleName),
    lib_guild_util:log_guild_member(Guild, LogType, [OldGuildMember, GuildMember]),
    %% 公会争霸运营活动
    %mod_custom_act_gwar:change_guild_position(RoleId, GuildId),
    %% 推送新的公会权限给客户端
    lib_guild:send_permission_list_to_role(RoleId, GuildId, Position),
    mod_seacraft_local:change_guild_info(config:get_server_id(), Guild#guild.realm, [{cheif, GuildId, RoleId, RoleName, RoleLv, Power, Picture, PictureVer}]),
    ok;

%% 其他职位(除了会长)
change_guild_member(EventType, [Guild, _OperatorGuildMember, OldGuildMember, GuildMember]) when
        EventType == ?GEVENT_APPOINT_POSITION_TO_OTHER ->
    #guild_member{id = RoleId, figure = Figure, guild_id = GuildId, position = Position} = GuildMember,
    #figure{name = _RoleName} = Figure,
    PositionNameMap = lib_guild_data:get_position_name_map(GuildId),
    PositionName = maps:get(Position, PositionNameMap, ""),
    List = [{position, Position}, {position_name, PositionName}],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    % 邮件
    % OperatorName = OperatorGuildMember#guild_member.figure#figure.name,
    % GuildName = Guild#guild.name,
    lib_mail_api:send_sys_mail([RoleId], utext:get(4000001), utext:get(4000002, [PositionName]), []),
    lib_role:update_role_show(RoleId, [{position, Position}, {position_name, PositionName}]),
    lib_guild_util:log_guild_member(Guild, ?GLOG_POS_CHANGE, [OldGuildMember, GuildMember]),
    %% 推送新的公会权限给客户端
    lib_guild:send_permission_list_to_role(RoleId, GuildId, Position),
    ok;

%% 重新命名职位
change_guild_member(EventType, GuildMember) when
        EventType == ?GEVENT_RENAME_POSITION ->
    #guild_member{id = RoleId, guild_id = GuildId, position = Position} = GuildMember,
    PositionNameMap = lib_guild_data:get_position_name_map(GuildId),
    PositionName = maps:get(Position, PositionNameMap, ""),
    List = [
        {position, Position}
        , {position_name, PositionName}
        ],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    lib_role:update_role_show(RoleId, [{position, Position}, {position_name, PositionName}]),
    ok;

%% 提升公会等级
change_guild_member(EventType, [GuildMember, NewGuildLv]) when
        EventType == ?GEVENT_UPGRADE_GUILD ->
    #guild_member{id = RoleId} = GuildMember,
    List = [{guild_lv, NewGuildLv}],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    MailContent = data_guild_m:get_upgrade_mail_content(NewGuildLv),
    lib_mail_api:send_sys_mail([RoleId], utext:get(4000011), MailContent, []),
    ok;

change_guild_member(EventType, [Guild, OldGuildMember, GuildMember]) when
        EventType == ?GEVENT_BECOME_NORAML_AF_APPOINT_OTHER_TO_CHIEF ->
    #guild_member{id = RoleId, guild_id = GuildId, position = Position} = GuildMember,
    PositionNameMap = lib_guild_data:get_position_name_map(GuildId),
    PositionName = maps:get(Position, PositionNameMap, ""),
    List = [
        {position, Position}
        , {position_name, PositionName}
        ],
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild, update_and_send_guild_info, [List]),
    lib_role:update_role_show(RoleId, [{position, Position}, {position_name, PositionName}]),
    lib_guild_util:log_guild_member(Guild, ?GLOG_POS_CHANGE, [OldGuildMember, GuildMember]),
    %% 公会争霸运营活动
    %mod_custom_act_gwar:change_guild_position(RoleId, GuildId),
    %% 推送新的公会权限给客户端
    lib_guild:send_permission_list_to_role(RoleId, GuildId, Position),
    ok.

%% 更新公会成员之后的公会处理
guild_af_update_member_attr(Guild, GuildMember, AttrList) ->
    do_guild_af_update_guild_member_attr(AttrList, GuildMember, Guild),
    ok.

do_guild_af_update_guild_member_attr([], _GuildMember, _Guild) -> ok;
% do_guild_af_update_guild_member_attr([{name, _Name}|L], GuildMember, Guild) ->
%     #guild_member{id = RoleId} = GuildMember,
%     #guild{chief_id = ChiefId} = Guild,
%     case RoleId == ChiefId of
%         true -> lib_common_rank_api:reflash_rank_by_guild(Guild);
%         false -> skip
%     end,
%     do_guild_af_update_guild_member_attr(L, GuildMember, Guild);
do_guild_af_update_guild_member_attr([_T|L], GuildMember, Guild) ->
    do_guild_af_update_guild_member_attr(L, GuildMember, Guild).

%% 在跨服中心的接口
send_chief_figure_info_in_center(Node, RoleId, GuildId, ArgsMap) ->
    #{ser_id := SerId} = ArgsMap,
    mod_clusters_center:apply_cast(SerId, mod_guild, send_chief_figure_info, [Node, RoleId, GuildId, ArgsMap]).

guild_power_change(Guild) ->
    #guild{id = GuildId, realm = Camp, combat_power_ten = CombatPowerTen} = Guild,
    mod_seacraft_local:change_guild_info(config:get_server_id(), Camp, [{power, GuildId, CombatPowerTen}, {num, GuildId, Guild#guild.member_num}]),
    ok.

%% ------------------------------- 后台秘籍 ------------------------------------

%% 秘籍修改公会公告
modify_announce_by_gm(GuildId, Announce) ->
    case catch mod_guild:modify_announce_by_gm(GuildId, Announce) of
        {ok, Reply} ->
            ?ERR("modify_announce_by_gm code:~p", [Reply]),
            Reply;
        _Err ->
            ?ERR("modify_announce_by_gm err:~p", [_Err]),
            time_out
    end.

%% 秘籍修改公会名字
modify_guild_name_by_gm(GuildId, GuildName) ->
    case catch mod_guild:modify_name_by_gm(GuildId, GuildName) of
        {ok, Reply} ->
            ?ERR("modify_guild_name_by_gm code:~p", [Reply]),
            Reply;
        _Err ->
            ?ERR("modify_guild_name_by_gm err:~p", [_Err]),
            time_out
    end.

%% 秘籍解散公会
disband_guild_by_gm(GuildId) ->
    case lib_mutex_check:check_disband_guild(GuildId) of
        true ->
            case mod_guild:disband_guild_by_gm(GuildId) of
                {ok, Reply} ->
                    ?ERR("disband_guild_by_gm code:~p", [Reply]),
                    Reply;
                _Err ->
                    ?ERR("modify_announce_by_gm err:~p", [_Err]),
                    time_out
            end;
        {false, ErrorCode} -> ErrorCode
    end.
