%%-----------------------------------------------------------------------------
%% @Module  :       pp_sea_treasure
%% @Author  :       xlh
%% @Email   :
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）协议管理
%%-----------------------------------------------------------------------------

-module(pp_sea_treasure).


-include("figure.hrl").
-include("sea_treasure.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("hero_halo.hrl").
-include("guild.hrl").
-include("def_vip.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-export([
        handle/3,
        do_assist_player/6,
        send_error/3
    ]).

handle(Cmd, Player, Args) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    List = [{open_lv, Lv}, {open_day, util:get_open_day()}],
    case lib_sea_treasure:check(List) of
        true ->
            case do_handle(Cmd, Player, Args) of
                {ok, NewPlayer} when is_record(NewPlayer, player_status) ->
                    {ok, NewPlayer};
                _ -> {ok, Player}
            end;
        {false, _Code} ->
            {ok, Player}
    end.

send_error(RoleId, Code, Cmd) when is_integer(Code) ->
    {ok, BinData} = pt_189:write(Cmd, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData);
send_error(RoleId, Code, Cmd) when is_list(Code) ->
    {ok, BinData} = pt_189:write(Cmd, Code),
    lib_server_send:send_to_uid(RoleId, BinData);
send_error(_, Code, Cmd) -> ?ERR("ERROR ARGS :~p~n",[{Code, Cmd}]), ok.


%% 界面协议
do_handle(18900, Player, []) ->
    #player_status{
        id = RoleId,
        figure = #figure{sex = _Sex, picture = Pic, picture_ver = PicVer, vip = VipLv, vip_type = VipType},
        server_id = ServerId
    } = Player,
    VipAddRobCount = lib_vip_api:get_vip_privilege(?MOD_SEA_TREASURE, ?VIP_SEA_TREASURE_ROB, VipType, VipLv),
    DayRewardTimes = ?day_reward_times,
    DayRobTimes = ?day_rob_reward_times,
    TreasureTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    RobTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_ROB_TIMES),
    Args = [Pic, PicVer, TreasureTimes, DayRewardTimes, RobTimes, DayRobTimes + VipAddRobCount],
    mod_sea_treasure_local:get_all_shipping_info(Args, ServerId, RoleId),
    {ok, Player};

%% 获取所有掠夺记录
do_handle(18901, Player, []) ->
    #player_status{
        id = RoleId
    } = Player,
    mod_sea_treasure_local:get_all_log_info(RoleId),
    {ok, Player};

%% 巡航界面，船只
do_handle(Cmd = 18902, Player, []) ->
    #player_status{id = RoleId, figure = #figure{vip = VipLv, vip_type = VipType}} = Player,
    VipAddUpCount = lib_vip_api:get_vip_privilege(?MOD_SEA_TREASURE, ?VIP_SEA_TREASURE_UP, VipType, VipLv),
    % MaxShippingCost = ?one_step_max_ship_cost,
    DayRewardTimes = ?day_reward_times,
    DayUpTimes = ?day_up_reward_times_base,
    HaloTimes = lib_hero_halo:get_halo_extra_times(Player, ?HALO_SEA_TIMES),
    TreasureTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    UpTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_UP),
    NowValue = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE),
    ShippingType = max(1, mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL)),
    Args = [ShippingType, NowValue, TreasureTimes, DayRewardTimes, UpTimes, DayUpTimes + VipAddUpCount + HaloTimes],
    send_error(RoleId, Args, Cmd),
    {ok, Player};

%% 开启一次巡航
do_handle(Cmd = 18903, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, combat_power = Power,
        figure = #figure{
            name = RoleName, lv = RoleLv, sex = Sex, career = Career,
            picture = Pic, picture_ver = PicVer, turn = Turn
        },
        guild = #status_guild{id = GuildId, name = GuildName}
    } = Player,
    DayMaxTimes = ?day_reward_times,
    ShippingType = max(1, mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL)),
    Times = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    List = [{shipping_cfg, ShippingType}, {day_times, Times, DayMaxTimes}],
    case lib_sea_treasure:check(List) of
        true ->
            CheckList = [{is_gm_stop, ?MOD_SEA_TREASURE, ?MOD_SEA_TREASURE_SHIP}],
            case lib_player_check:check_list(Player, CheckList) of
                true ->
                    Args = [ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName, RoleLv, Power, Career, Sex, Turn, Pic, PicVer],
                    mod_sea_treasure_local:start_new_ship(RoleId, ShippingType, Args),
                    CallbackData = #callback_join_act{type = ?MOD_SEA_TREASURE},
                    lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData);
                {false, Code} ->
                    ?PRINT("Code:~p~n",[Code]),
                    send_error(RoleId, [ShippingType, Code], Cmd)
            end;
        {false, Code} ->?PRINT("Code:~p~n",[Code]),
            send_error(RoleId, [ShippingType, Code], Cmd)
    end,
    {ok, Player};

%% 巡航数据
do_handle(18904, Player, [AutoId]) ->
    #player_status{
        id = RoleId, server_id = ServerId
    } = Player,
    mod_sea_treasure_local:get_shipping_info(AutoId, ServerId, RoleId),
    {ok, Player};

%% 掠夺/复仇
do_handle(Cmd = 18905, Player, [AutoId, ShipSerId, ShipRoleId, BatType]) ->
    #player_status{id = RoleId} = Player,
    case BatType == ?BATTLE_TYPE_RBACK andalso RoleId =/= ShipRoleId of
        true -> %% 不能通过这个分支来帮别人复仇，只能通过工会协助
            send_error(RoleId, [?FAIL, AutoId, ShipSerId, ShipRoleId, BatType], Cmd),
            {ok, Player};
        _ ->
            case do_assist_player(Player, AutoId, ShipSerId, ShipRoleId, BatType, 0) of
                {ok, NewPlayer} -> {ok, NewPlayer};
                {false, Code} ->
                    send_error(RoleId, [Code, AutoId, ShipSerId, ShipRoleId, BatType], Cmd),
                    {ok, Player}
            end
    end;

%% 领取巡航奖励/追回奖励
do_handle(Cmd = 18909, Player, [AutoId, RewardType]) ->
    #player_status{
        figure = #figure{lv = RoleLv},
        id = RoleId, server_id = ServerId
    } = Player,
    case RewardType == 1 orelse RewardType == 2 of
        true ->
            mod_sea_treasure_local:recieve_reward(ServerId, RoleId, RoleLv, AutoId, RewardType);
        _ ->
            send_error(RoleId, [AutoId, RewardType, 0, ?ERRCODE(error_data), []], Cmd)
    end,
    {ok, Player};

%% 船只升级
do_handle(Cmd = 18914, Player, [ShippingType, AutoUp]) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName, vip = VipLv, vip_type = VipType}} = Player,
    NowShipLevel = max(1, mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL)),
    NowValue = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE),

    DayMaxTimes = ?day_reward_times,
    Times = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),

    VipAddUpCount = lib_vip_api:get_vip_privilege(?MOD_SEA_TREASURE, ?VIP_SEA_TREASURE_UP, VipType, VipLv),
    DayUpTimes = ?day_up_reward_times_base,
    UpTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_UP),
    MaxLevel = data_sea_treasure:get_max_shipping_level(),
    HaloTimes = lib_hero_halo:get_halo_extra_times(Player, ?HALO_SEA_TIMES),
    case data_sea_treasure:get_reward_info(NowShipLevel) of
        #base_sea_treasure_reward{cost = UpCost, value = NeedVal, add_value = AddVal, ratio = Ratio} ->
            if
                Times >= DayMaxTimes ->
                    NewPlayer = Player, NewUpTimes = UpTimes,
                    Code = ?ERRCODE(err189_day_times_max),
                    NewVal = NowValue, NewShippingLevel = NowShipLevel;
                NowShipLevel == MaxLevel ->
                    NewPlayer = Player, NewUpTimes = UpTimes,
                    Code = ?ERRCODE(err189_shipping_type_max),
                    NewVal = NowValue, NewShippingLevel = NowShipLevel;
                NowValue >= NeedVal ->
                    NewShippingLevel = NowShipLevel+1, NewVal = 0, Code = ?SUCCESS, NewPlayer = Player, NewUpTimes = UpTimes,
                    lib_log_api:log_sea_treasure_up(RoleId, RoleName, NowShipLevel, NowValue, NewShippingLevel,
                        NewVal, NewUpTimes, 0, []),
                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, NewShippingLevel),
                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, NewVal);
                AutoUp == 1 ->
                    MaxShippingCost = ?one_step_max_ship_cost,
                    About = lists:concat(["OldLevel:", NowShipLevel, ",NewLevel:", MaxLevel]),
                    NewUpTimes = UpTimes,
                    case lib_goods_api:cost_object_list_with_check(Player, MaxShippingCost, sea_shipping_up_level, About) of
                        {true, NewPlayer} ->
                            mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, MaxLevel),
                            mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, 0),
                            lib_log_api:log_sea_treasure_up(RoleId, RoleName, NowShipLevel, NowValue,
                                MaxLevel, 0, NewUpTimes, AutoUp, MaxShippingCost),
                            NewVal = 0, NewShippingLevel = MaxLevel, Code = ?SUCCESS;
                        {false, Code, NewPlayer} ->
                            NewVal = NowValue, NewShippingLevel = NowShipLevel
                    end;
                ShippingType =/= NowShipLevel ->
                    NewPlayer = Player, NewUpTimes = UpTimes,
                    Code = ?ERRCODE(err189_shipping_type_wrong),
                    NewVal = NowValue, NewShippingLevel = NowShipLevel;
                UpTimes < VipAddUpCount + DayUpTimes + HaloTimes ->
                    case urand:ge_rand(1, 10000, Ratio) of
                        true ->
                            NewShippingLevel = NowShipLevel+1, NewVal = 0, Code = ?SUCCESS,
                            mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, NewShippingLevel);
                        _ when NowValue + AddVal >= NeedVal ->
                            NewShippingLevel = NowShipLevel+1, NewVal = 0, Code = ?SUCCESS,
                            mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, NewShippingLevel);
                        _ ->
                            NewShippingLevel = NowShipLevel, NewVal = NowValue + AddVal, Code = ?SUCCESS
                    end,
                    NewUpTimes = UpTimes + 1, NewPlayer = Player,
                    lib_log_api:log_sea_treasure_up(RoleId, RoleName, NowShipLevel, NowValue,
                                NewShippingLevel, NewVal, NewUpTimes, AutoUp, []),
                    mod_daily:increment(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_UP),
                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, NewVal);
                true ->
                    NewUpTimes = UpTimes,
                    case lib_goods_api:cost_object_list_with_check(Player, UpCost, sea_shipping_up_level, "") of
                        {true, NewPlayer} ->
                            case urand:ge_rand(1, 10000, Ratio) of
                                true ->
                                    NewShippingLevel = NowShipLevel+1, NewVal = 0, Code = ?SUCCESS,
                                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, NewShippingLevel),
                                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, NewVal);
                                _ when NowValue + AddVal >= NeedVal ->
                                    NewShippingLevel = NowShipLevel+1, NewVal = 0, Code = ?SUCCESS,
                                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_SHIPPING_LEVEL, NewShippingLevel),
                                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, NewVal);
                                _ ->
                                    NewShippingLevel = NowShipLevel, NewVal = NowValue + AddVal, Code = ?SUCCESS,
                                    mod_daily:set_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_UP_LUCKEY_VALUE, NewVal)
                            end,
                            lib_log_api:log_sea_treasure_up(RoleId, RoleName, NowShipLevel, NowValue,
                                NewShippingLevel, NewVal, NewUpTimes, AutoUp, UpCost);
                        {false, Code, NewPlayer} ->
                            NewVal = NowValue, NewShippingLevel = NowShipLevel
                    end

            end;
        _ ->
            Code = ?MISSING_CONFIG, NewPlayer = Player, NewUpTimes = UpTimes,
            NewVal = NowValue, NewShippingLevel = NowShipLevel
    end,
    Args = [Code, NewShippingLevel, NewVal, NewUpTimes, DayUpTimes + VipAddUpCount + HaloTimes],
    send_error(RoleId, Args, Cmd),
    case Code == ?SUCCESS of
        true -> lib_grow_welfare_api:level_up_ship(NewPlayer);
        _ -> {ok, NewPlayer}
    end;

%% 对战数据
do_handle(18915, Player, []) ->
    #player_status{
        id = RoleId
    } = Player,
    mod_sea_treasure_local:get_enemy_info(RoleId),
    {ok, Player};

%% 协助获得绑钻数量
do_handle(Cmd = 18916, Player, []) ->
    #player_status{
        id = RoleId
    } = Player,
    DailyNum = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_BGOLD_NUM),
    MaxBGoldNum = ?back_reward_max_bgold_num,
    send_error(RoleId, [DailyNum, MaxBGoldNum], Cmd),
    {ok, Player};

%% 获取自己巡航状态
do_handle(18917, Player, []) ->
    #player_status{
        id = RoleId, server_id = ServerId
    } = Player,
    DayRewardTimes = ?day_reward_times,
    TreasureTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_TREASURE_TIMES),
    mod_sea_treasure_local:get_ship_status(ServerId, RoleId, TreasureTimes, DayRewardTimes),
    {ok, Player};

%% 退出战场
do_handle(Cmd = 18918, Player, []) ->
    #player_status{
        id = RoleId, scene = Scene, sea_treasure_pid = Pid
    } = Player,
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Player),
    case IsOut of
        true ->
            case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_SEA_TREASURE ->
                    Code = 1,
                    case is_pid(Pid) of
                        true ->
                            lib_sea_treasure_battle:role_request_out(RoleId, Pid);
                        _ ->
                            skip
                    end,
                    %% 处理玩家身上的一堆数据
                    {ok, NewPs} = lib_sea_treasure_battle:role_request_out(Player);
                _ ->
                    Code = ?ERRCODE(err189_not_in_sea_treasure_scene),
                    NewPs = Player
            end;
        false ->
            Code = ErrCode,
            NewPs = Player
    end,
    send_error(RoleId, [Code], Cmd),
    {ok, NewPs};

do_handle(Cmd, Player, Data) ->
    ?ERR("pp_sea_treasure  not match Cmd:~p, Data:~p~n",[Cmd, Data]),
    {ok, Player}.

do_assist_player(Player, AutoId, ShipSerId, ShipRoleId, BatType, AssistId) ->
    ?MYLOG("cxd_sea4","~p",[2222]),
    #player_status{
        id = RoleId, figure = #figure{name = RoleName, vip = VipLv, vip_type = VipType},
        scene = Scene, server_id = ServerId, server_num = ServerNum, combat_power = Power
    } = Player,
    if
        BatType == ?BATTLE_TYPE_ROBER ->
            DayRobTimes = ?day_rob_reward_times,
            VipAddRobCount = lib_vip_api:get_vip_privilege(?MOD_SEA_TREASURE, ?VIP_SEA_TREASURE_ROB, VipType, VipLv),
            RobTimes = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_ROB_TIMES),
            List = [{scene_type, Scene}, {battle_type, BatType}, {day_times, RobTimes, DayRobTimes+VipAddRobCount}];
        true ->
            List = [{scene_type, Scene}, {battle_type, BatType}]
    end,
    case lib_sea_treasure:check(List) of
        true ->
            CheckList = [alive, safe_scene, action_free, is_transferable, {is_gm_stop, ?MOD_SEA_TREASURE, ?MOD_SEA_TREASURE_ROB}],
            case lib_player_check:check_list(Player, CheckList) of
                true ->
                    ?MYLOG("cxd_sea4","~p",[333]),
                    NewPlayer = lib_sea_treasure:add_lock_to_player(Player),
                    BGoldNum = mod_daily:get_count(RoleId, ?MOD_SEA_TREASURE, ?DAILY_BGOLD_NUM),
                    Args = [ServerId, ServerNum, RoleName, Power, BGoldNum, AssistId],
                    mod_sea_treasure_local:rober_shipping(ShipSerId, ShipRoleId, AutoId, RoleId, BatType, Args),
                    {ok, NewPlayer};
                {false, Code} ->
                    {false, Code}
            end;
        {false, Code} ->
            {false, Code}
    end.
