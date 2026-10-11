%% ---------------------------------------------------------------------------
%% @doc lib_guild.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 玩家进程
%% ---------------------------------------------------------------------------
-module(lib_guild).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("sql_guild.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("scene.hrl").
% -include("def_daily.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("def_fun.hrl").

%% 获取公会status
load_status_guild(RoleId) ->
    MemberSql = io_lib:format(?sql_guild_member_select_login, [RoleId]),
    case db:get_row(MemberSql) of
        [GuildId, Position, CreateTime] ->
            GuildSql = io_lib:format(?sql_guild_select_login, [GuildId]),
            case db:get_row(GuildSql) of
                [GuildName, GuildLv, Realm] -> ok;
                [] -> GuildName = <<>>, GuildLv = 0, Realm = 0
            end,
            % 第一职位
            case db_position_name_select_by_position(GuildId, Position) of
                [] ->
                    case data_guild:get_guild_pos_cfg(Position) of
                        [] -> UnkPositionName = "";
                        #guild_pos_cfg{name = UnkPositionName} -> ok
                    end;
                [UnkPositionName] ->
                    ok
            end,
            PositionName = util:make_sure_binary(UnkPositionName);
        [] ->
            GuildId = 0, Position = 0, CreateTime = 0, Realm = 0,
            PositionName = <<>>, GuildName = <<>>, GuildLv = 0
    end,
    % case db:get_row(io_lib:format(?sql_guild_select_player_guild, [RoleId])) of
    %     [ReceiveSalaryTime] -> skip;
    %     _ ->
    %         case GuildId > 0 of
    %             true ->
    %                 db:execute(io_lib:format(?sql_insert_null_player_guild, [RoleId]));
    %             false -> skip
    %         end,
    %         ReceiveSalaryTime = 0
    % end,
    #status_guild{
        id = GuildId
        , name = GuildName
        , lv = GuildLv
        , position = Position
        , position_name = PositionName
        , create_time = CreateTime
        , realm = Realm
    }.

%% 创建公会
create_guild(Player, CfgId, GuildName) ->
    case check_create_guild(Player, CfgId, GuildName) of
        {false, ErrorCode} -> NewPlayer2 = Player;
        {true, Cost} ->
            case lib_goods_api:cost_object_list(Player, Cost, create_guild, "") of
                {false, ErrorCode, _} -> NewPlayer2 = Player;
                {true, NewPlayer} ->
                    case do_create_guild(NewPlayer, GuildName, "") of
                        {false, ErrorCode} -> NewPlayer2 = NewPlayer;
                        {ok, NewPlayer2} -> ErrorCode = ?SUCCESS
                    end
            end
    end,
    case ErrorCode == ?SUCCESS of
        true ->
            #player_status{figure = #figure{name = Name, guild_id = GuildId, vip = Vip}} = NewPlayer2,
            case Vip > 0 of
                true -> lib_chat:send_TV({all}, ?MOD_GUILD, 7, [Name, GuildName, GuildId]);
                false -> skip
            end,
            {ok, BinData} = pt_400:write(40004, [ErrorCode, GuildId]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false ->
            ?PRINT("create_guild  ErrorCode ~p~n", [ErrorCode]),
            send_error_code(Player#player_status.sid, ErrorCode)
    end,
    {ok, NewPlayer2}.

%% 检查创建公会
check_create_guild(Player, CfgId, GuildName) ->
    #player_status{figure = #figure{lv = Lv}, guild = StatusGuild} = Player,
    #status_guild{id = GuildId} = StatusGuild,
    % 放一些基础的判断,特别是call进程的,防止一开始就call数据.fun()性能较差
    CheckList = [
        % 校验字符串
        {fun() -> GuildName =/= "" end, ?ERRCODE(err400_guild_name_null)},
        {fun() -> util:check_length_without_code(GuildName, data_guild_m:get_config(guild_name_len)) == true end, ?ERRCODE(err400_guild_name_len)},
        {fun() -> lib_word:check_keyword_name(GuildName) == false end, ?ERRCODE(err400_guild_name_sensitive)},
        {fun() -> lib_player:judge_char_len(GuildName) end, ?ERRCODE(err400_guild_name_sensitive)},
        % 是否没有拥有公会
        {fun() -> GuildId == 0 end, ?ERRCODE(err400_on_guild_not_to_create)},
        % 是否有足够的消耗
        fun() ->
            Result = case data_guild_m:get_create_guild_cost(CfgId) of
                false -> {false, ?ERRCODE(err400_create_guild_cfg)};
                Cost -> lib_goods_api:check_object_list(Player, Cost)
            end,
            Result
        end,
        % 等级够不够
        fun() ->
            NeedLv = data_guild_m:get_config(create_guild_lv),
            case Lv >= NeedLv of
                true ->
                    case CfgId == 1 orelse (CfgId == 2 andalso Lv >= 160) of
                        true ->
                            true;
                        _ ->
                            {false, ?ERRCODE(err400_not_enough_lv_to_create_guild)}
                    end;
                false -> {false, ?ERRCODE(err400_not_enough_lv_to_create_guild)}
            end
        end,
        % 是否没有同名
        {fun() ->
            NewGuildName = string:to_upper(util:make_sure_list(GuildName)),
            GuildUpperMap = mod_guild:search_guild_by_name_upper(NewGuildName),
            is_map(GuildUpperMap) andalso GuildUpperMap == #{}
        end, ?ERRCODE(err400_guild_name_same_not_to_create)}
    ],
    case util:check_list(CheckList) of
        {false, ErrorCode} -> {false, ErrorCode};
        true ->
            Cost = data_guild_m:get_create_guild_cost(CfgId),
            {true, Cost}
    end.

%% 创建公会
do_create_guild(Player, GuildName, _Tenet) ->
    #player_status{
        id = RoleId, figure = Figure, hightest_combat_power = HCombatPower, combat_power = CombatPower, last_login_time = LastLoginTime, last_logout_time = LastLogoutTime,
        guild = GuildStatus} = Player,
    #figure{realm = _Realm, name = Name} = Figure,
    % 默认等级
    GuildLv = data_guild_m:get_config(guild_default_lv),
    DefaultAnnounce = utext:get(4000003),
    Time = utime:unixtime(),
    GuildNameBin = util:make_sure_binary(GuildName),
    Guild = #guild{
        name = GuildNameBin
        , name_upper = string:to_upper(util:make_sure_list(GuildName))
        , announce = DefaultAnnounce
        , lv = GuildLv
        , chief_id = RoleId
        , chief_name = Name
        , realm = 0
        , member_num = 0
        , create_time = Time
        , disband_warnning_time = 0
    },
    Position = ?POS_CHIEF,
    GuildMember = lib_guild_mod:make_record(guild_member, [RoleId, 0, GuildNameBin, Position, 0, Time, Figure, 1, LastLoginTime, LastLogoutTime, CombatPower, max(HCombatPower, CombatPower)]),
    case mod_guild:create_guild(Guild, GuildMember) of
        {false, ErrorCode} -> {false, ErrorCode};
        {ok, NewGuild} ->
            % lib_mail_api:send_sys_mail([RoleId], utext:get(173), utext:get(174), []),
            {ok, Player1} = lib_player_event:dispatch(Player, ?EVENT_CREATE_GUILD),
            #guild{id = GuildId} = NewGuild,
            NewGuildStatus = GuildStatus#status_guild{
                id = GuildId, name = GuildNameBin, lv = GuildLv, position = Position
            },
            NewFigure = Figure#figure{
                guild_id = GuildId,
                guild_name = GuildNameBin,
                position = Position},
            NewPlayer = Player1#player_status{guild = NewGuildStatus, figure = NewFigure},
            {ok, NewPlayer}
    end.

%% @param Cost :: [{priority, GoodsList},...]
check_rename_guild_pass(#player_status{guild = #status_guild{id = GuildId}} = Player, Cost, GuildId, GuildName) ->
    if
        Cost =:= [] ->
            mod_guild:rename_guild(GuildId, Player#player_status.id, [GuildName, Cost]),
            {ok, Player};
        true ->
            OrderCost0 = lists:keysort(1, Cost),
            OrderCostL = [GoodsList || {_, GoodsList} <- OrderCost0],
            F = fun(GoodsList) -> lib_goods_api:check_object_list(Player, GoodsList) == true end,
            case ulists:find(F, OrderCostL) of
                {ok, CostList} ->
                    {true, CostPlayer} = lib_goods_api:cost_object_list(Player, CostList, guild_rename, GuildName),
                    mod_guild:rename_guild(GuildId, Player#player_status.id, [GuildName, Cost]),
                    {ok, CostPlayer};
                _ -> % 错误码默认返回物品不足
                    send_error_code(Player#player_status.sid, ?GOODS_NOT_ENOUGH)
            end
    end;

check_rename_guild_pass(_PS, _Cost, _GuildId, _GuildName) -> skip.

update_guild_name(Player, GuildId, GuildName) ->
    case Player#player_status.guild of
        #status_guild{id = GuildId, position = Position, position_name = PositionName} = StatusGuild ->
            Figure = Player#player_status.figure,
            mod_scene_agent:update(Player, [{guild, {GuildId, GuildName, Position, PositionName}}]),
            % 同步场景
            {ok, BinData} = pt_400:write(40017, [Player#player_status.id, GuildId, GuildName, Position, PositionName]),
            lib_server_send:send_to_area_scene(Player#player_status.scene, Player#player_status.scene_pool_id,
            Player#player_status.copy_id, Player#player_status.x, Player#player_status.y, BinData),
            {ok, Player#player_status{guild = StatusGuild#status_guild{name = GuildName}, figure = Figure#figure{guild_name = GuildName}}};
        _ ->
            skip
    end.

update_guild_realm(#player_status{figure = Figure} =Player, Realm) ->
    case Player#player_status.guild of
        #status_guild{} = StatusGuild ->
            {ok, Player#player_status{guild = StatusGuild#status_guild{realm = Realm}, figure = Figure#figure{camp = Realm}}};
        _ ->
            skip
    end.

rename_guild_fail(Player, Cost, ErrorCode) ->
    Msg
    = case data_errorcode_msg:get(ErrorCode) of
        #errorcode_msg{about = About} ->
            About;
        _ ->
            util:term_to_string(ErrorCode)
    end,
    if
        Cost =:= [] ->
            NewPlayer = Player;
        true ->
            Produce = #produce{type = guild_rename_fail, reward = Cost, remark= Msg},
            NewPlayer = lib_goods_api:send_reward(Player, Produce)
    end,
    send_error_code(Player#player_status.sid, ErrorCode),
    {ok, NewPlayer}.

%% 发送公会信息
send_info(Player) ->
    #player_status{sid = Sid, guild = Guild} = Player,
    #status_guild{
        id = GuildId, name = GuildName, lv = GuildLv, position = Position, position_name = PositionName
    } = Guild,
    {ok, BinData} = pt_400:write(40015, [GuildId, GuildName, GuildLv, Position, PositionName]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 更新和发送公会信息
update_and_send_guild_info(Player, AttrList) ->
    {ok, NewPlayer} = update_status_guild(Player, AttrList),
    {ok, NewPlayer2} = update_other_by_status_guild_change(NewPlayer, AttrList),
    send_to_area_scene(Player, NewPlayer2),
    send_info(NewPlayer2),
    {ok, NewPlayer2}.

send_to_area_scene(OldPlayer, Player) ->
    #player_status{
        guild = #status_guild{
            id = OldGuildId
            , name = OldGuildName
            , position = OldPosition
            , position_name = OldPositionName
            }
        } = OldPlayer,
    #player_status{
        guild = #status_guild{
            id = GuildId
            , name = GuildName
            , position = Position
            , position_name = PositionName}
        } = Player,
    Old = [OldGuildId, OldGuildName, OldPosition, OldPositionName],
    New = [GuildId, GuildName, Position, PositionName],
    case Old =/= New of
        true ->
            mod_scene_agent:update(Player, [{guild, {GuildId, GuildName, Position, PositionName}}]),
            % 同步场景
            {ok, BinData} = pt_400:write(40017, [Player#player_status.id, GuildId, GuildName, Position, PositionName]),
            lib_server_send:send_to_area_scene(Player#player_status.scene, Player#player_status.scene_pool_id,
                Player#player_status.copy_id, Player#player_status.x, Player#player_status.y, BinData);
        false ->
            skip
    end.

%% 从公会场景送出去
send_out_from_guild_station_scene(#player_status{id = RoleId, scene = SceneId}) ->
    StationSceneId = data_guild_m:get_config(guild_station_scene_id),
    if
        SceneId =/= StationSceneId -> skip;
        true -> lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, [])
    end.

%% ----------------------------------------------------
%% 函数
%% ----------------------------------------------------

update_status_guild(Player, []) -> {ok, Player};
update_status_guild(Player, [T|L]) ->
    #player_status{guild = StatusGuild} = Player,
    case T of
        {guild_id, GuildId} -> NewStatusGuild = StatusGuild#status_guild{id = GuildId};
        {guild_name, GuildName} -> NewStatusGuild = StatusGuild#status_guild{name = GuildName};
        {guild_lv, GuildLv} -> NewStatusGuild = StatusGuild#status_guild{lv = GuildLv};
        {position, Position} -> NewStatusGuild = StatusGuild#status_guild{position = Position};
        {position_name, PositionName} -> NewStatusGuild = StatusGuild#status_guild{position_name = PositionName};
        {create_time, CreateTime} -> NewStatusGuild = StatusGuild#status_guild{create_time = CreateTime};
        {realm, Realm} -> NewStatusGuild = StatusGuild#status_guild{realm = Realm};
        _ ->
            % ?ERR("ignore attr:~p~n", [T]),
            NewStatusGuild = StatusGuild
    end,
    NewPlayer = Player#player_status{guild = NewStatusGuild},
    update_status_guild(NewPlayer, L).

%% 根据StatusGuild来更新玩家其他数据
update_other_by_status_guild_change(Player, []) -> {ok, Player};
update_other_by_status_guild_change(Player, [T|L]) ->
    #player_status{figure = Figure} = Player,
    case T of
        {guild_id, GuildId} ->
            NewPlayer = Player#player_status{ figure = Figure#figure{guild_id = GuildId} };
        {guild_name, GuildName} ->
            NewPlayer = Player#player_status{ figure = Figure#figure{guild_name = GuildName} };
        {position, Position} ->
            NewPlayer = Player#player_status{ figure = Figure#figure{position = Position} };
        {position_name, PositionName} ->
            NewPlayer = Player#player_status{ figure = Figure#figure{position_name = PositionName} };
        _ ->
            % ?ERR("ignore attr:~p~n", [T]),
            NewPlayer  = Player
    end,
    update_other_by_status_guild_change(NewPlayer, L).

%% 发送公会职位权限列表给玩家
%% 需在公会进程调用
send_permission_list_to_role(RoleId, GuildId, Position) ->
    PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
    {ok, BinData} = pt_400:write(40021, [PermissionList]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ok, BinData} = pt_400:write(40000, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 是否公会场景
is_guild_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_GUILD} -> true;
        _ -> false
    end.

%% 构造RoleMap
% 玩家在线
make_role_map(Player) when is_record(Player, player_status) ->
    #player_status{figure = Figure, hightest_combat_power = HCombatPower, combat_power = CombatPower, last_login_time = LastLoginTime, last_logout_time = LastLogoutTime} = Player,
    #{figure=>Figure, combat_power=>CombatPower, hcombat_power=>HCombatPower, last_login_time=>LastLoginTime, online_flag=>?ONLINE_ON, last_logout_time=>LastLogoutTime};
make_role_map(RoleShow) ->
    #ets_role_show{figure = Figure, h_combat_power = HCombatPower, combat_power = CombatPower, online_flag = OnlineFlag, last_login_time = LastLoginTime, last_logout_time = LastLogoutTime} = RoleShow,
    LastCombatPower = ?IF(CombatPower > 0, CombatPower, HCombatPower),
    #{figure=>Figure, combat_power=>LastCombatPower, hcombat_power=>HCombatPower, last_login_time=>LastLoginTime, online_flag=>OnlineFlag, last_logout_time=>LastLogoutTime}.

%% 检查公会探索是否开启
check_guild_dun_open(PS) ->
    #player_status{figure = #figure{lv = RoleLv}, guild = #status_guild{id = GuildId, lv = GuildLv}} = PS,
    OpenLv = data_guild_m:get_config(guild_dun_open_lv),
    RoleOpenLv = data_guild_m:get_config(guild_dun_role_lv),
    if
        GuildId == 0 -> {false, ?ERRCODE(err400_not_join_guild)};
        GuildLv < OpenLv -> {false, ?ERRCODE(err400_guild_lv_dun)};
        RoleLv < RoleOpenLv -> {false, ?LEVEL_LIMIT};
        true ->
            true
    end.

%% ----------------------------------------------------
%% 数据库操作
%% ----------------------------------------------------

db_position_name_select_by_position(GuildId, Position) ->
    Sql = io_lib:format(?sql_position_name_select_by_position, [GuildId, Position]),
    db:get_row(Sql).

db_announce_forbid_by_gm(GuildId) ->
    case db:get_row(io_lib:format("select announce_forbid from guild where id=~p limit 1", [GuildId])) of
        [0] -> false;
        _ -> true
    end.
