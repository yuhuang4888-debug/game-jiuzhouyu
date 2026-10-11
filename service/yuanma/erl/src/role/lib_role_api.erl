%% ---------------------------------------------------------------------------
%% @doc lib_role.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-26
%% @deprecated 角色辅助信息接口
%% ---------------------------------------------------------------------------
-module(lib_role_api).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_module.hrl").

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) when is_record(Player, player_status) ->
    #callback_recharge_data{
        recharge_product = ProductCfg, gold = Gold,
        money = Money, pay_no = PayNo, is_pay = IsPay
    } = CallBackData,
    ta_agent_fire:order_finish(Player, [PayNo, Money, Gold, ProductCfg, IsPay]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, combat_power = Combat, hightest_combat_power = HCombatPower} = Player,
    lib_role:update_role_show(RoleId, [{combat_power, Combat}, {h_combat_power, max(Combat, HCombatPower)}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TURN_UP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = OnlineFlag}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, online = OldOnlineFlag} = Player,
    NowTime = utime:unixtime(),
    if
        OnlineFlag == ?ONLINE_ON ->
            lib_role:update_role_show(RoleId, [{last_login_time, NowTime}, {online_flag, ?ONLINE_ON}]);
        OldOnlineFlag == ?ONLINE_ON andalso OnlineFlag == ?ONLINE_OFF ->
            lib_role:update_role_show(RoleId, [{last_logout_time, NowTime}, {online_flag, ?ONLINE_OFF}]);
        true -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TRANSFER}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_SUPVIP}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure } = Player,
    lib_role:update_role_show(RoleId, [{figure, Figure}]),
    {ok, Player};

handle_event(Player, _) ->
    {ok, Player}.

%% 计数器增加玩家在线时长
add_role_daily_online_time(#player_status{id = RoleId, last_login_time = LastLoginTime}) ->
    UnixDate = utime:unixdate(),
    NowTime = utime:unixtime(),
    StartTime = max(LastLoginTime, UnixDate),
    OnlineTime = NowTime - StartTime,
    mod_daily:plus_count_offline(RoleId, ?MOD_BASE, ?MOD_BASE_DAILY_ONLINE_TIME, OnlineTime).

%% 玩家当天首次登录战力
update_role_first_combat() ->
    [
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_role, update_role_first_combat, [])
     || RoleId <- lib_online:get_online_ids()
    ],
    ok.

%% TA数据上报
ta_daily_refresh() ->
    lib_player:cast_online_role_apply(?APPLY_CAST_STATUS, ?MODULE, ta_daily_refresh, []),
    ok.

ta_daily_refresh(PS) ->
    add_role_daily_online_time(PS),         % 玩家在线时长
    ta_agent_fire:role_daily_attr(PS),      % 玩家每日状态
    ta_agent_fire:role_simu_logout(PS),     % 上报虚拟登出信息

    ok.

ta_daily_refresh_four() ->
    lib_player:cast_online_role_apply(?APPLY_CAST_STATUS, ?MODULE, ta_daily_refresh_four, []),
    ok.

ta_daily_refresh_four(PS) ->
    ta_agent_fire:role_daily_active(PS),    % 玩家每日活跃

    ok.
