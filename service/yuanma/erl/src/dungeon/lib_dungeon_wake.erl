%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_wake.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-19
%% @Description:    觉醒副本
%%-----------------------------------------------------------------------------

-module (lib_dungeon_wake).
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("dungeon.hrl").
-include ("common.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("server.hrl").
-include ("scene.hrl").
-export ([
    dunex_handle_quit_dungeon/2
    ,dunex_encourage/3
%%    ,do_encourage_ps/7
    ,dunex_setup_encourage_count/4
    ,dunex_get_encourage_count/2
    ,slow_mons_down/2
    ,cost_slowdown_mons/6
    ,setup_slowdown/2
    ,slow_down_timeout/2
    ,setup_mons_slowdown/2
    ,dunex_special_pp_handle/4
    % ,get_force_quit_time/1
    % ,change_lv_when_role_out/1
    % ,dunex_handle_enter_dungeon/2
    ]).

-export ([
    clean_buff/2
    % , handle_lv_up/2
    ]).

dunex_handle_quit_dungeon(Player, #dungeon{id = DunId}) ->
    case data_dungeon_special:get(DunId, encourage_data) of
        {SkillId,_,_,_,_} ->
            lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff, SkillId),
            Player;
        _ ->
            Player
    end.

clean_buff(Player, #event_callback{param = SkillId}) ->
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff),
    NewPlayer = lib_goods_buff:remove_skill_buff(Player, SkillId),
    {ok, NewPlayer}.

dunex_encourage(State, RoleId, CostType) ->
    lib_dungeon_exp:dunex_encourage(State, RoleId, CostType).

%%do_encourage_ps(Player, DunId, CostType, Cost, SkillId, CoinCount, GoldCount) ->
%%    #player_status{dungeon = #status_dungeon{dun_id = DunId0}, id = RoleId, sid = Sid, copy_id = CopyId} = Player,
%%    IsOnDungeon = lib_dungeon:is_on_dungeon_ongoing(Player),
%%    if
%%        DunId0 == DunId andalso IsOnDungeon->
%%            case lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_encourage, "") of
%%                {true, NewPlayer} ->
%%                    if
%%                        CostType =:= ?ENCOURAGE_COST_TYPE_COIN ->
%%                            NewCoinCount = CoinCount + 1, NewGoldCount = GoldCount;
%%                        true ->
%%                            NewCoinCount = CoinCount, NewGoldCount = GoldCount + 1
%%                    end,
%%                    NewPlayer1 = lib_goods_buff:add_skill_buff(NewPlayer, SkillId, NewCoinCount + NewGoldCount),
%%                    mod_dungeon:setup_encourage_count(CopyId, RoleId, CostType, 1),
%%                    {ok, BinData} = pt_610:write(61025, [?SUCCESS, NewCoinCount, NewGoldCount]),
%%                    lib_server_send:send_to_sid(Sid, BinData),
%%                    {ok, NewPlayer1};
%%                {false, Code, _} ->
%%                    mod_dungeon:setup_encourage_count(CopyId, RoleId, CostType, 0),
%%                    {ok, BinData} = pt_610:write(61025, [Code, CoinCount, GoldCount]),
%%                    lib_server_send:send_to_sid(Sid, BinData)
%%            end;
%%        true ->
%%            skip
%%    end.

dunex_setup_encourage_count(State, RoleId, CostType, AddCount) ->
    lib_dungeon_exp:dunex_setup_encourage_count(State, RoleId, CostType, AddCount).

dunex_get_encourage_count(State, RoleId) ->
    lib_dungeon_exp:dunex_get_encourage_count(State, RoleId).

slow_mons_down(#dungeon_state{result_type = ResultType, dun_type = DunType, typical_data = TypicalData, dun_id = DunId} = State, RoleId) ->
    if
        DunType =/= ?DUNGEON_TYPE_WAKE ->
            skip;
        ResultType =/= ?DUN_RESULT_TYPE_NO ->
            skip;
        true ->
            case data_dungeon_special:get(DunId, slow_down_cfg) of
                {Price, Seconds, R} when R < 1 ->
                    LastSlowDownTime = maps:get(?DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME, TypicalData, 0),
                    NowTime = utime:unixtime(),
                    if
                        NowTime - LastSlowDownTime - 1 < Seconds ->
                            {ok, BinData} = pt_610:write(61000, [?ERRCODE(err610_slowdown_cd), []]),
                            lib_server_send:send_to_uid(RoleId, BinData);
                        true ->
                            NewTypicalData = TypicalData#{?DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME => NowTime},
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, cost_slowdown_mons, [Price, DunId, self(), NowTime, LastSlowDownTime]),
                            State#dungeon_state{typical_data = NewTypicalData}
                    end;
                _ ->
                    skip
            end
    end.

cost_slowdown_mons(Player, Price, DunId, DunPid, Time, LastTime) ->
    Cost = ?WAKE_DUNGEON_SLOWDOWN_COST(Price),
    case lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_slown_mons, integer_to_list(DunId)) of
        {true, CostPlayer} ->
            mod_dungeon:apply(DunPid, ?MODULE, setup_slowdown, {Time, ok, Player#player_status.id}),
            {ok, CostPlayer};
        {false, Res, _} ->
            mod_dungeon:apply(DunPid, ?MODULE, setup_slowdown, {Time, LastTime, Player#player_status.id}),
            {ok, BinData} = pt_610:write(61000, [Res, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end.

setup_slowdown(#dungeon_state{result_type = ResultType, typical_data = TypicalData, dun_id = DunId} = State, {Time, Res, RoleId}) ->
    if
        ResultType =/= ?DUN_RESULT_TYPE_NO ->
            skip;
        true ->
            case data_dungeon_special:get(DunId, slow_down_cfg) of
                {_Price, Seconds, R} when R < 1 ->
                    case maps:get(?DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME, TypicalData, 0) of
                        Time ->
                            if
                                Res =:= ok ->
                                    CommDunR = maps:get(?DUN_STATE_SPCIAL_KEY_COMMON_DUNR, TypicalData, []),
                                    SpeedR = 1 - R,
                                    NewCommDunR = lists:keystore(speed_r, 1, CommDunR, {speed_r, SpeedR}),
                                    #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
                                    CopyId = self(),
                                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, setup_mons_slowdown, [CopyId, SpeedR]),
                                    NowTime = utime:unixtime(),
                                    erlang:send_after(max(1, Seconds + Time - NowTime)*1000, CopyId, {apply, ?MODULE, slow_down_timeout, Time}),
                                    {ok, BinData} = pt_610:write(61095, [Time + Seconds]),
                                    lib_server_send:send_to_uid(RoleId, BinData),
                                    State#dungeon_state{typical_data = TypicalData#{?DUN_STATE_SPCIAL_KEY_COMMON_DUNR => NewCommDunR}};
                                true ->
                                    NewTypicalData = TypicalData#{?DUN_STATE_SPCIAL_KEY_COMMON_DUNR => Res},
                                    State#dungeon_state{typical_data = NewTypicalData}
                            end;
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end
    end.

slow_down_timeout(State, Time) ->
    #dungeon_state{typical_data = TypicalData} = State,
    case maps:get(?DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME, TypicalData, 0) of
        Time ->
            CommDunR = maps:get(?DUN_STATE_SPCIAL_KEY_COMMON_DUNR, TypicalData, []),
            NewCommDunR = lists:keydelete(speed_r, 1, CommDunR),
            #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
            CopyId = self(),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, setup_mons_slowdown, [CopyId, 1]),
            State#dungeon_state{typical_data = TypicalData#{?DUN_STATE_SPCIAL_KEY_COMMON_DUNR => NewCommDunR}};
        _ ->
            skip
    end.

setup_mons_slowdown(CopyId, SpeedR) ->
    Mons = lib_scene_object_agent:get_scene_object(CopyId),
    [Object#scene_object.aid !  {'change_attr', [{speed_r, SpeedR}]} || Object <- Mons, Object/=[]].

dunex_special_pp_handle(State, Sid, 61094, _) ->
    #dungeon_state{dun_id = DunId, typical_data = TypicalData} = State,
     case data_dungeon_special:get(DunId, slow_down_cfg) of
        {_Price, Seconds, _R} ->
            Time = maps:get(?DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME, TypicalData, 0),
            {ok, BinData} = pt_610:write(61094, [Time + Seconds]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            skip
    end;

dunex_special_pp_handle(_State, _, _, _) ->
    ok.