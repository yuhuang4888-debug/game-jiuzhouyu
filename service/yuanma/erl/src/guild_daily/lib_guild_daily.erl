-module(lib_guild_daily).

-include("server.hrl").
-include("vip.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("boss.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("dungeon.hrl").
-include("treasure_hunt.hrl").

-export([
        get_info/1,
        recieve_reward/2,
        async_event/4,
        common_complete_task/2,

        handle_event/2,
        enter_forbidden_boss/2,
        kill_boss/2,
        treasure_hunt/2,
        enter_dun/2,
        day_clear/0,
        gm_commplete_task/1,
        gm_clear/1
    ]).

get_info(PS) ->
    #player_status{id = RoleId, guild = #status_guild{id = Guild, name = _GuildName, create_time = EnterTime}} = PS,
    if
        Guild == 0 ->
            {ok, Bin} = pt_403:write(40300, [?ERRCODE(err403_join_a_guild)]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            MaxNum = get_day_recieve_max_num(PS),
            DayGetNum = mod_daily:get_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
            mod_guild_daily:info(Guild, RoleId, DayGetNum, MaxNum, EnterTime)
    end,
    {ok, PS}.

day_clear() ->
    mod_guild_daily:day_clear().

recieve_reward(PS, AutoId) ->
    #player_status{id = RoleId, guild = #status_guild{id = Guild, name = GuildName, create_time = EnterTime},
        figure = #figure{name = RoleName}} = PS,
    MaxNum = get_day_recieve_max_num(PS),
    DayGetNum = mod_daily:get_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
    if
        Guild == 0 ->
            {ok, Bin} = pt_403:write(40302, [?ERRCODE(err403_join_a_guild), []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        DayGetNum >= MaxNum ->
            {ok, Bin} = pt_403:write(40302, [?ERRCODE(err403_max_recieve_num), []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            CanGetNum = MaxNum - DayGetNum,
            mod_guild_daily:recieve_reward(AutoId, Guild, GuildName, RoleId, RoleName, CanGetNum, DayGetNum, EnterTime)
    end,
    {ok, PS}.
% lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [Key]).
async_event(PlayerId, M, F, A) when is_integer(PlayerId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, M, F, A);
async_event(_PlayerId, _M, _F, _A) -> skip.

common_complete_task(PS, Key) ->
    #player_status{figure = #figure{lv = RoleLv}, guild = #status_guild{id = Guild}} = PS,
    if
        Guild == 0 ->
            skip;
        true ->
            NeedLv = data_guild_m:get_config(apply_join_guild_lv),
            case NeedLv =< RoleLv of
                true ->
                    case data_guild_daily:get_task_id(Key) of
                        TaskId when is_integer(TaskId) ->
                            #player_status{id = RoleId, guild = #status_guild{id = Guild, name = GuildName},
                                figure = #figure{name = RoleName}} = PS,
                            mod_guild_daily:complete_task(TaskId, Guild, GuildName, RoleId, RoleName);
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end
    end,
    {ok, PS}.

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product}}) when is_record(Player, player_status) ->
    lib_recharge_api:is_trigger_recharge_act(Product) andalso common_complete_task(Player, recharge_once),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_ADD_LIVENESS}) when is_record(Player, player_status) ->
    #player_status{id = RoleId} = Player,
    Liveness = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度
    if
        Liveness >= 120 ->
            common_complete_task(Player, activation_num);
        true ->
            skip
    end,
    {ok, Player};

handle_event(PS, #event_callback{}) ->
    {ok, PS}.

get_day_recieve_max_num(PS) ->
    #player_status{vip = #role_vip{vip_type = VipType, vip_lv = VipLv}} = PS,
    DefaultNum = case data_guild_daily:get_num_by_vip(VipLv) of
                    N when is_integer(N) -> N;
                    _ -> 30
                 end,
    if
        VipType >= 1 ->
            MaxVipCfg = data_guild_daily:get_max_vip(),
            case data_guild_daily:get_num_by_vip(VipLv) of
                [] when VipLv > MaxVipCfg -> MaxNum = data_guild_daily:get_max_num();
                Num when is_integer(Num) -> MaxNum = Num;
                _ -> MaxNum = DefaultNum
            end;
        true ->
            MaxNum = DefaultNum
    end,
    MaxNum.

gm_commplete_task(PS) ->
    KeyList = data_guild_daily:get_all_task_key(),
    [common_complete_task(PS, Key) || Key <- KeyList],
    PS.

gm_clear(PS) ->
    #player_status{ guild = #status_guild{id = Guild}} = PS,
    mod_guild_daily:gm_clear(Guild),
    PS.

% API
enter_forbidden_boss(BossType, RoleId) ->
    if
        BossType == ?BOSS_TYPE_FORBIDDEN ->
            lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [forbidden_boss]);
        true ->
            skip
    end.

enter_dun(Duntype, RoleId) ->
    if
        Duntype == ?DUNGEON_TYPE_VIP_PER_BOSS ->
                lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [personal_boss]);
        true ->
            skip
    end.

kill_boss(BossType, BLWho) ->
    Fun = fun(#mon_atter{id = RoleId}) ->
        if
            BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
                lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [world_boss]);
            true ->
                skip
        end
    end,
    lists:foreach(Fun, BLWho).

treasure_hunt(?TREASURE_HUNT_TYPE_RUNE, RoleId) ->
    lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [treasure_hunt_rune]);
treasure_hunt(_Htype, RoleId) ->
    lib_guild_daily:async_event(RoleId, lib_guild_daily, common_complete_task, [treasure_hunt]).