%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-18
%% @Description:    星钻联盟
%%-----------------------------------------------------------------------------

-module (lib_diamond_league).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("figure.hrl").
-include ("rec_event.hrl").
-include ("def_event.hrl").
-include("def_module.hrl").

-export ([
    calc_cur_state/1
    ,player_cost_apply/3
    ,launch/0
    ,get_mod_by_state/1
    ,player_apply_cast_from_center/4
    ,apply_cast_from_center/4
    ,convert_figure/2
    ,apply_fail_return/1
    ,apply_cancel_return/1
    ,cost_buy_life/2
    ,player_quit_after_fail/1
    ,get_round_name/1
    ,cost_guess_price/2
    ,get_cur_guess_show_rewards/2
    ,give_guess_rewards/2
    ,reconnect/1
    ,local_launch/0
    ,local_update_state/4
    ,local_setup_state/4
    ,handle_event/2
    ]).



calc_cur_state(Offset) ->
    NowTime = utime:unixtime() + Offset,
    WeekDay = utime:day_of_week(NowTime),
    StateIds = data_diamond_league:get_state_ids(),
    ZeroTime = utime:unixdate(NowTime),
    {Id, STime, ETime} = calc_cur_state(StateIds, WeekDay, NowTime - ZeroTime),
    {Id, STime + ZeroTime - Offset, ETime + ZeroTime - Offset}.

calc_cur_state([Id|T], WeekDay, SecondsFromZeroTime) ->
    case data_diamond_league:get_time_ctrl(Id) of
        #diamond_time_ctrl{time = {H, M, S}, next_id = NextId, week_day = WeekDay0} when WeekDay0 < WeekDay orelse (WeekDay0 == WeekDay andalso H * 3600 + M * 60 + S =< SecondsFromZeroTime) ->
            STime = H * 3600 + M * 60 + S - (WeekDay - WeekDay0) * ?ONE_DAY_SECONDS,
            case data_diamond_league:get_time_ctrl(NextId) of
                #diamond_time_ctrl{week_day = NextWeekDay, time = {NH, NM, NS}} when NextWeekDay > WeekDay ->
                    {Id, STime, ?ONE_DAY_SECONDS * (NextWeekDay - WeekDay) + NH * 3600 + NM * 60 + NS};
                #diamond_time_ctrl{week_day = WeekDay, time = {NH, NM, NS}} when SecondsFromZeroTime < (NH * 3600 + NM * 60 + NS) ->
                    {Id, STime, NH * 3600 + NM * 60 + NS};
                _ ->
                    calc_cur_state(T, WeekDay, SecondsFromZeroTime)
            end;
        _ ->
            calc_cur_state(T, WeekDay, SecondsFromZeroTime)
    end;

calc_cur_state([], WeekDay, SecondsFromZeroTime) ->
    case data_diamond_league:get_time_ctrl(1) of
        #diamond_time_ctrl{time = {H, M, S}, week_day = WD} when WeekDay < WD ->
            {0, SecondsFromZeroTime, ?ONE_DAY_SECONDS * (WD - WeekDay) + H * 3600 + M * 60 + S};
        #diamond_time_ctrl{time = {H, M, S}, week_day = WD} when WeekDay >= WD ->
            {0, SecondsFromZeroTime, ?ONE_DAY_SECONDS * (WD + 7 - WeekDay) + H * 3600 + M * 60 + S};
        _ ->
            {0, SecondsFromZeroTime, ?ONE_DAY_SECONDS}
    end.

player_cost_apply(Player, MyIndex, MinPower) ->
    #player_status{id = RoleId, sid = Sid, hightest_combat_power = Power} = Player,
    case data_diamond_league:get_kv(?CFG_KEY_APPLY_COST) of
        [_|_] = Cost ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, diamond_league_apply_cost, integer_to_list(MyIndex)) of
                {true, NewPlayer} ->
                    mod_diamond_league_local:mark_player_applied(RoleId, MyIndex),
                    {ok, BinData} = pt_604:write(60403, [MyIndex, Power, MinPower]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPlayer};
                {false, Code, _} ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(lib_diamond_league_apply, delete_apply, [Node, RoleId]),
                    {ok, BinData} = pt_604:write(60400, [Code, []]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(lib_diamond_league_apply, delete_apply, [Node, RoleId]),
            {ok, BinData} = pt_604:write(60400, [?FAIL, []]),
            lib_server_send:send_to_sid(Sid, BinData)
    end.

launch() ->
    mod_diamond_league_schedule:start_link(),
    mod_diamond_league_ctrl:start_link().

local_launch() ->
    mod_diamond_league_guess:start_link(),
    mod_diamond_league_local:start_link().

local_update_state(CycleIndex, StateId, StartTime, EndTime) ->
    if
        StateId =:= ?STATE_ENTER ->
            lib_activitycalen_api:success_start_activity(?MOD_DIAMOND_LEAGUE);
        StateId =:= ?STATE_CLOSED ->
            lib_activitycalen_api:success_end_activity(?MOD_DIAMOND_LEAGUE);
        true ->
            ok
    end,
    mod_diamond_league_guess:update_state(CycleIndex, StateId, StartTime, EndTime),
    mod_diamond_league_local:update_state(CycleIndex, StateId, StartTime, EndTime).

local_setup_state(CycleIndex, StateId, StartTime, EndTime) ->
    if
        StateId =:= ?STATE_ENTER ->
            lib_activitycalen_api:success_start_activity(?MOD_DIAMOND_LEAGUE);
        true ->
            ok
    end,
    mod_diamond_league_guess:setup_state(CycleIndex, StateId, StartTime, EndTime),
    mod_diamond_league_local:setup_state(CycleIndex, StateId, StartTime, EndTime).

get_mod_by_state(?STATE_APPLY) ->
    lib_diamond_league_apply;

get_mod_by_state(?STATE_ENTER) ->
    lib_diamond_league_enter;

get_mod_by_state(?STATE_MELEE) ->
    lib_diamond_league_melee;

get_mod_by_state(?STATE_KING_CHOOSE) ->
    lib_diamond_league_king_fight;

get_mod_by_state(?STATE_CLOSED) ->
    lib_diamond_league_closed;

get_mod_by_state(_) ->
    undefined.

convert_figure(Figure, LFigure) when is_record(Figure, figure), is_record(LFigure, league_figure) ->
    #figure{
        name = Name, 
        sex = Sex, 
        career = Career,
        picture = Pic,
        picture_ver = PicVer,
        turn = Turn,
        lv_model = LvModel,
        fashion_model = FashionModel,
        god_equip_model = GodWeaponModel,
        wing_figure = WingFigure
    } = Figure,
    LFigure#league_figure{
        name = Name,
        sex = Sex,
        career = Career,
        turn = Turn,
        pic = Pic,
        picvsn = PicVer,
        lv_model = LvModel,
        fashion_model = FashionModel,
        god_weapon_model = GodWeaponModel,
        wing = WingFigure
    };

convert_figure(_, LFigure) -> LFigure.

player_apply_cast_from_center(RoleId, Mod, Fun, Args) ->
    ServId = mod_player_create:get_serid_by_id(RoleId),
    mod_clusters_center:apply_cast(ServId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, Mod, Fun, Args]).


apply_cast_from_center(RoleId, Mod, Fun, Args) ->
    ServId = mod_player_create:get_serid_by_id(RoleId),
    mod_clusters_center:apply_cast(ServId, Mod, Fun, Args).

apply_fail_return(RoleId) ->
    case data_diamond_league:get_kv(?CFG_KEY_APPLY_COST) of
        [_|_] = Cost ->
            Title = utext:get(6040001),
            Content = utext:get(6040002),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost);
        _ ->
            ok
    end.

apply_cancel_return(RoleId) ->
    case data_diamond_league:get_kv(?CFG_KEY_APPLY_COST) of
        [_|_] = Cost ->
            Title = utext:get(6040003),
            Content = utext:get(6040004),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost);
        _ ->
            ok
    end.

cost_buy_life(#player_status{id = RoleId} = Player, BuyNum) ->
    Node = mod_disperse:get_clusters_node(),
    case data_diamond_league:get_kv(?CFG_KEY_LIFE_COST) of
        [_|_] = Cost ->
            TotalCost = lib_goods_util:goods_object_multiply_by(Cost, BuyNum),
            case lib_goods_api:cost_objects_with_auto_buy(Player, TotalCost, diamond_league_buy_life, integer_to_list(BuyNum)) of
                {true, NewPlayer, _} ->
                    mod_clusters_node:apply_cast(mod_diamond_league_schedule, buy_life_done, [Node, RoleId, {ok, BuyNum}]),
                    {ok, NewPlayer};
                _ ->
                    mod_clusters_node:apply_cast(mod_diamond_league_schedule, buy_life_done, [Node, RoleId, fail]),
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_buy_life_cost), []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
            end;
        _ ->
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, buy_life_done, [Node, RoleId, fail]),
            {ok, BinData} = pt_604:write(60400, [?FAIL, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end.

player_quit_after_fail(Player) ->
    pp_diamond_league:handle(60410, Player, []).

get_round_name(Round) ->
    util:make_sure_binary(data_diamond_league:get_round_name(Round)).

%% call
cost_guess_price(Player, PriceId) ->
    case data_diamond_league:get_guess_price(PriceId) of
        [Cost|_] ->
            case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, diamond_league_guess, "") of
                {true, NewPlayer, _} ->
                    {true, NewPlayer};
                Otherwise ->
                    CostName = lib_goods_api:get_first_object_name(Cost),
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(what_not_enough), [CostName]]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                    Otherwise
            end;
        _ ->
            {ok, BinData} = pt_604:write(60400, [?FAIL, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            false
    end.

get_cur_guess_show_rewards(AllCount, PriceId) ->
    case data_diamond_league:get_reward_counts(AllCount, PriceId) of
        [MinCount|_] ->
            {MinCount, data_diamond_league:get_guess_reward(AllCount, MinCount, PriceId)};
        _ ->
            {0, []}
    end.

give_guess_rewards(Player, Rewards) ->
    case lib_goods_api:can_give_goods(Player, Rewards) of
        true ->
            NewPlayer = lib_goods_api:send_reward(Player, Rewards, diamond_league_guess_reward, 0),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {{false, ErrorCode}}
    end.

reconnect(Player) ->
    #player_status{scene = SceneId, action_lock = ActionLock} = Player,
    WaitingScene = data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
    BattleScene = data_diamond_league:get_kv(?CFG_KEY_BATTLE_SCENE),
    if
        WaitingScene == SceneId orelse BattleScene == SceneId ->
%%            NewPlayer = lib_scene:change_default_scene(Player, []),
            skip;
        true ->
            case ?ERRCODE(err604_in_the_act) of
                ActionLock ->
                    {next, lib_player:break_action_lock(Player, ?ERRCODE(err604_in_the_act))};
                _ ->
                    skip
            end
    end.


handle_event(#player_status{id = RoleId} = Player, #event_callback{type_id = ?EVENT_COMBAT_POWER, data = Data}) ->
    #callback_combat_power_data{combat_power = CombatPower, hightest_combat_pwer = HightCombatPower} = Data,
    case CombatPower > HightCombatPower of
        true ->
            mod_diamond_league_local:update_role_power(RoleId, CombatPower);
        false ->
            skip
    end,
    {ok, Player};

handle_event(Player, _) -> {ok, Player}.