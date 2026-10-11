%% ---------------------------------------------------------------------------
%% @doc pp_decoration_boss.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss
%% ---------------------------------------------------------------------------
-module(pp_decoration_boss).
-export([handle/3]).

-include("server.hrl").
-include("decoration_boss.hrl").
-include("common.hrl").
-include("def_daily.hrl").
-include("def_vip.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("figure.hrl").

%% 幻饰boss信息
handle(47101, Player, []) ->
    lib_decoration_boss:send_info(Player),
    ok;

%% 进入boss
handle(47102, Player, [BossId, Type]) when Type == ?DECORATION_BOSS_ENTER_TYPE_NORMAL orelse Type == ?DECORATION_BOSS_ENTER_TYPE_ASSIST ->
    case util:get_open_day() >= ?DECORATION_BOSS_KV_OPEN_DAY of
        true -> 
            #player_status{id = RoleId, server_id = ServerId} = Player,
            mod_decoration_boss_local:check_and_enter_boss(RoleId, ServerId, BossId, Type);
        false -> 
            skip
    end,
    ok;

%% 退出
handle(47103, Player, []) ->
    {ok, NewPlayer} = lib_decoration_boss:quit(Player),
    {ok, NewPlayer};

%% 购买次数
handle(47104, Player, []) ->
    {ok, NewPlayer} = lib_decoration_boss:buy(Player),
    {ok, NewPlayer};

%% 取消关注列表
handle(47105, Player, []) ->
    #player_status{status_decoration_boss = StatusDecorationBoss} = Player,
    #status_decoration_boss{unfollow_list = UnfollowList} = StatusDecorationBoss,
    {ok, BinData} = pt_471:write(47105, [UnfollowList]),
    lib_server_send:send_to_uid(Player#player_status.id, BinData),
    ok;

%% 关注
handle(47106, Player, [BossId, IsFollow]) ->
    {ok, NewPlayer} = lib_decoration_boss:follow(Player, BossId, IsFollow),
    {ok, NewPlayer};

%% boss掉落记录
handle(47108, #player_status{id = RoleId}, []) ->
    mod_decoration_boss_local:send_log_list(RoleId),
    ok;

%% 特殊boss的个人伤害记录
handle(47109, #player_status{id = RoleId, server_id = ServerId}, []) ->
    case util:get_open_day() >= ?DECORATION_BOSS_KV_OPEN_DAY of
        true -> mod_decoration_boss_center:cast_center([{'send_role_sboss_hurt_info', RoleId, ServerId}]);
        false -> skip
    end,
    ok;

%% 进入特殊boss
handle(47110, Player, []) ->
    case util:get_open_day() >= ?DECORATION_BOSS_KV_OPEN_DAY of
        true -> 
            #player_status{id = RoleId, server_id = ServerId} = Player,
            mod_decoration_boss_center:cast_center([{'check_and_enter_sboss', RoleId, ServerId, ?DECORATION_BOSS_ENTER_TYPE_NORMAL}]);
        false -> 
            skip
    end,
    ok;

%% 公会求助
handle(47111, Player, []) ->
    #player_status{id = RoleId, figure = Figure = #figure{guild_id = GuildId}, scene = SceneId, copy_id = CopyId} = Player,
    IsBossScene = lib_decoration_boss_api:is_normal_boss_scene(SceneId),
    Mon = data_mon:get(CopyId),
    if
        IsBossScene == false -> ErrCode = ?ERRCODE(err471_not_decoration_boss_scene);
        GuildId == 0 -> ErrCode = ?ERRCODE(err471_no_guild_to_ask_help);
        is_record(Mon, mon) == false -> ErrCode = ?ERRCODE(err471_not_decoration_boss_scene);
        true ->
            ErrCode = ?SUCCESS,
            #mon{name = Name} = Mon,
            lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_DECORATION_BOSS, 1, [Name, CopyId])
    end,
    % ?PRINT("47111 ErrCode:~p~n", [ErrCode]),
    {ok, BinData} = pt_471:write(47111, [ErrCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok;

%% 战斗信息
handle(47114, #player_status{id = RoleId, server_id = ServerId}, []) ->
    mod_decoration_boss_local:send_battle_info(RoleId, ServerId);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.