%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_battle.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-24
%% @Description:    星钻联赛战斗
%%-----------------------------------------------------------------------------

-module(lib_diamond_league_battle).
-include("battle_field.hrl").
-include("diamond_league.hrl").
-include("common.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("def_event.hrl").

-define(BEFORE_START_TIME, 4). %% 倒计时 3秒
-define(BATTLE_TIME, 120).     %% 比赛时间 3分钟
-define(FORCE_END_TIME, 30).   %% 强制结算时间 有一方30秒还没加载完
-define(VISITOR_MAX_NUM, 100).

%% 行为接口
-export([
    %% 战场进程
    init/2
    , player_enter/3
    , player_quit/3
    , player_logout/3
    , player_finish_change_scene/3
    , player_die/3
    , player_revive/3
    , player_reconnect/3
    % ,player_disconnect/3
    , terminate/2
    %% 玩家进程
    , evt_out_of_battle/2
    , evt_enter_scene_finish/2
    
    , pack_reconnect_args/1
    , pack_enter_args/2
]).

-export([
    create_dummy/2
    , battle_time_out/2
    , battle_start/2
    , late_force_end/2
    , adjudge_battle/2
    , player_use_skill/2
    , add_life/2
    , visit_battle/2
    , visit_leave/2
    , get_60415_msg/2
    , revive_player/2
    , visit_reconnect/2
]).

-export([
    enter_battle_field/2
    , enter_battle_field_with_fake/3
    , fake_man_die_handler/5
    , dummy_start_battle/2
    , get_scene_obj_hp/2
    , player_handle_result/4
    , log_battle/2
    , visitor_enter_callback/2
    , visitor_disconnect/2
    , visitor_reconnect/2
    , battle_ready/2
]).

init(State, [A, B, [StopDelay, CurRound]]) ->
    #league_role{role_id = IdA, index = Index} = A,
    #league_role{role_id = IdB} = B,
    SceneId = data_diamond_league:get_kv(?CFG_KEY_BATTLE_SCENE),
    PosList = data_diamond_league:get_kv(?CFG_KEY_BATTLE_BORN_POS),
    PoolId = Index rem ?POOL_NUM,
    CopyId = {lib_diamond_league_battle, State#battle_state.self},
    [{X1, Y1}, {X2, Y2} | _] = ?IF(urand:rand(1, 2) == 1, PosList, lists:reverse(PosList)),
    RoleMap = #{
        IdA => #battle_role{key = IdA, in_info = #{x => X1, y => Y1}, data = #{league_role => A}},
        IdB => #battle_role{key = IdB, in_info = #{x => X2, y => Y2}, data = #{league_role => B}}
    },
    Ref = erlang:send_after(StopDelay * 2, State#battle_state.self, stop),
    NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, roles = RoleMap, data = #{stop_ref => Ref, round => CurRound}},
    if
        IdA > 16#FFFFFFFF andalso IdB > 16#FFFFFFF -> %% 两个都是真人
            lib_diamond_league:player_apply_cast_from_center(IdA, ?MODULE, enter_battle_field, [State#battle_state.self]),
            lib_diamond_league:player_apply_cast_from_center(IdB, ?MODULE, enter_battle_field, [State#battle_state.self]),
            {ok, NewState};
        IdA =< 16#FFFFFFFF andalso IdB =< 16#FFFFFFF -> %% 两个都是假人
            ?ERR("lib_diamond_league_battle 2 fakeman~n", []),
            {stop, normal};
        true ->
            {Real, Fake}
                = if
                      IdA > 16#FFFFFFFF ->
                          {A, B};
                      true ->
                          {B, A}
                  end,
            lib_diamond_league:player_apply_cast_from_center(Real#league_role.role_id, ?MODULE, enter_battle_field_with_fake, [State#battle_state.self, Fake#league_role.role_id]),
            {ok, NewState}
    end.

player_enter(RoleKey, Args, State) ->
    % ?PRINT("player_enter ~p~n", [RoleKey]),
    #battle_state{roles = RoleMap, data = StateData} = State,
    CurRound = maps:get(round, StateData, 1),
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{out_info = OutInfo, in_info = InInfo, data = Data} = Role} ->
            [_OSceneId, _OPoolId, OCopyId, X, Y, Hp, HpLim, LeagueFigure] = Args,
            CopyId
                = if
                      CurRound >= ?MELEE_ROUND_NUM ->
                          0;
                      is_integer(OCopyId) andalso OCopyId >= 0 ->
                          urand:rand(0, OCopyId);
                      true ->
                          urand:rand(0, 15 - CurRound * 2)
                  end,
            NewOutInfo
                = OutInfo#{
                scene => data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
                scene_pool_id => 0,  %% 出去重新适配房间
                copy_id => CopyId,
                x => X,
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => [{change_scene_hp, max(1, Hp)}]
            },
            InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}],
            {ok, Role#battle_role{out_info = NewOutInfo, in_info = InInfo#{scene_args => InSceneArgs}, data = Data#{figure => LeagueFigure}}, State};
        _ ->
            skip
    end.
player_quit(Role, _Args, #battle_state{is_end = true} = State) ->
    {ok, Role, State};
%% 未结算不许退出
player_quit(Role, Args, State) ->
    player_logout(Role, Args, State).

% player_disconnect(Role, Args, State) ->
%     player_logout(Role, Args, State).

%% 掉线算输
player_logout(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    #battle_state{roles = RoleMap, data = Data} = State,
    NewRoleMap
        = maps:map(fun
                       (K, #battle_role{data = D} = R) ->
                           if
                               K =/= RoleKey ->
                                   R#battle_role{data = D#{res => 1}};
                               true ->
                                   R#battle_role{data = D#{res => 0}, out_info = #{}}
                           end
                   end, RoleMap),
    #battle_state{roles = NewRoleMap2} = NewState = handle_result(State#battle_state{roles = NewRoleMap, data = Data#{res_code => ?RES_REASON_QUIT}}),
    NewRole = maps:get(RoleKey, NewRoleMap2),
    {ok, NewRole, NewState};

player_logout(_Role, _Args, _State) ->
    skip.


player_die(#battle_role{key = RoleId, data = Data} = Role, _Args, #battle_state{is_end = false} = State) ->
%%    ?ERR("player_die res = ~p~n", [RoleId]),
    #battle_state{roles = RoleMap, self = Self} = State,
    DieCount = maps:get(die_count, Data, 0),
    case Data of
        #{league_role := #league_role{life = Life}} when Life > 0 ->
            erlang:send_after(3000, Self, {apply, ?MODULE, revive_player, [RoleId, Self]}),
            NewRole = Role#battle_role{data = Data#{die_count => DieCount + 1}},
            NewState = State#battle_state{roles = RoleMap#{RoleId => NewRole}},
            {ok, NewState};
        _ ->
            NewRoleMap
                = maps:map(fun
                               (K, #battle_role{data = D} = R) ->
                                   if
                                       K =/= RoleId ->
                                           R#battle_role{data = D#{res => 1}};
                                       true ->
                                           R#battle_role{data = D#{res => 0, die_count => DieCount + 1}}
                                   end
                           end, RoleMap),
            NewState = handle_result(State#battle_state{roles = NewRoleMap}),
            {ok, NewState}
    end;

player_die(_Role, _Args, _State) ->
    skip.


%%player_revive(#battle_role{
%%        key = RoleId,
%%        data = #{league_role := #league_role{life = Life} = LRole} = Data
%%    } = Role,
%%    _Args,
%%    #battle_state{is_end = false} = State) ->
%%    #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
%%    if
%%        Life > 0 ->
%%            NewLRole = LRole#league_role{life = Life - 1},
%%            NewRole = Role#battle_role{data = Data#{league_role => NewLRole}},
%%        %%            lib_diamond_league:player_apply_cast_from_center(RoleId, lib_revive, revive_without_check, [?REVIVE_ROUND, [{x, X}, {y, Y}]]),
%%            NewState = State#battle_state{roles = RoleMap#{RoleId => NewRole}},
%%            BinData = pack_battle_info(NewState),
%%            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
%%            {ok, NewState};
%%        true ->
%%            NewRoleMap
%%                = maps:map(fun
%%                               (K, #battle_role{data = D} = R) ->
%%                                   if
%%                                       K =/= RoleId ->
%%                                           R#battle_role{data = D#{res => 1}};
%%                                       true ->
%%                                           R#battle_role{data = D#{res => 0}}
%%                                   end
%%                           end, RoleMap),
%%            NewState = handle_result(State#battle_state{roles = NewRoleMap}),
%%            ?ERR("battle_adjudge_without player_die ~p~n", [RoleId]),
%%            {ok, NewState}
%%    end;
player_revive(_Role, _Args, _State) ->
    skip.

player_reconnect(Role, Node, State) ->
    BinData = pack_battle_info(State),
    lib_clusters_center:send_to_uid(Role#battle_role.key, BinData),
    get_60415_msg(State, [Node, Role#battle_role.key]).

player_finish_change_scene(Role, _Args, State) ->
    % ?PRINT("player_finish_change_scene res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    RoleList = maps:to_list(RoleMap),
    case lists:all(fun
                       ({_key, R}) ->
                           R#battle_role.state =:= ?ROLE_STATE_IN orelse R#battle_role.key =:= Role#battle_role.key
                   end, RoleList) of
        true ->
            BattleStartTime = utime:unixtime() + ?BEFORE_START_TIME,
            NewState = State#battle_state{data = Data#{late_force_end => false, stage_end_time => {1, BattleStartTime}}},
            BinData = pack_battle_info(NewState),
            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
            %% 上面发到全场景的玩家中可能不包括刚刚进入的这个玩家
            lib_clusters_center:send_to_uid(Role#battle_role.key, BinData),
            lists:map(fun
                          ({RoleId, _}) ->
                              ServId = mod_player_create:get_serid_by_id(RoleId),
                              mod_clusters_center:apply_cast(ServId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?MODULE, battle_ready, [BattleStartTime]])
                      end, RoleList),
            erlang:send_after(?BEFORE_START_TIME * 1000, Self, {apply, ?MODULE, battle_start, [BattleStartTime + ?BATTLE_TIME]}),
            erlang:send_after((?BEFORE_START_TIME + ?BATTLE_TIME) * 1000, Self, {apply, ?MODULE, battle_time_out, []}),
            case Data of
                #{fake_id := MonId} ->
                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, dummy_start_battle, [MonId, ?BEFORE_START_TIME]);
                _ ->
                    ok
            end,
            {ok, Role, NewState};
        _ ->
            erlang:send_after(?FORCE_END_TIME * 1000, Self, {apply, ?MODULE, late_force_end, Role#battle_role.key}),
            {ok, Role, State}
    end.

terminate(_Reason, #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, data = Data}) ->
    Visitors = maps:get(visitors, Data, []),
    util:cancel_timer(maps:get(stop_ref, Data, undefined)),
    KeyValueList = [
        {scene_hide_type, 0},
        {battle_field, undefined}
    ],
    [lib_diamond_league:apply_cast_from_center(RoleId, lib_scene, player_change_scene, [RoleId, OSceneId, OPoolId, OCopyId, X, Y, false, KeyValueList]) || {RoleId, [OSceneId, OPoolId, OCopyId, X, Y]} <- Visitors],
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId).

% player_apply_cast(RoleId, Fun, Args) ->
%     ServId = mod_player_create:get_serid_by_id(RoleId),
%     mod_clusters_center:apply_cast(ServId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?MODULE, Fun, Args]).

enter_battle_field(Player, BattlePid) ->
    #player_status{
        id                    = RoleId,
        guild                 = #status_guild{
            name = GuildName
        },
        figure                = Figure,
        battle_attr           = #battle_attr{hp = Hp, hp_lim = HpLim},
        scene                 = OSceneId,
        scene_pool_id         = OPoolId,
        copy_id               = OCopyId,
        x                     = X,
        y                     = Y,
        hightest_combat_power = Power,
        server_name           = ServName,
        sid                   = Sid
    } = Player,
    % ?PRINT("enter_battle_field ~p ~s~n", [RoleId, ServName]),
    {ok, BinData} = pt_604:write(60415, [2, utime:unixtime()]),
    lib_server_send:send_to_sid(Sid, BinData),
    LeagueFigure = #league_figure{guild_name = GuildName, power = Power, server_name = ServName},
    Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim, lib_diamond_league:convert_figure(Figure, LeagueFigure)],
    mod_battle_field:player_enter(BattlePid, RoleId, Args).

enter_battle_field_with_fake(Player, BattlePid, FakeId) ->
    #player_status{
        figure                = Figure,
        battle_attr           = BattleAttr,
        hightest_combat_power = Power,
        server_name           = ServName
    } = Player,
    ChangeFigure = lib_dummy_api:change_figure(Figure, [rand_wing, create_name, rand_fashion]),
    SkillList = lib_dummy_api:get_skill_list(Player),
    mod_battle_field:apply_cast(BattlePid, ?MODULE, create_dummy, [FakeId, ChangeFigure, BattleAttr, SkillList, Power, ServName]),
    enter_battle_field(Player, BattlePid).

create_dummy(State, [FakeId, Figure, BattleAttr, SkillList, Power, ServName]) ->
    if
        State#battle_state.is_end =:= false ->
            #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, data = StateData} = State,
            case maps:find(FakeId, RoleMap) of
                {ok, #battle_role{data = Data, in_info = #{x := X, y := Y}} = FakeRole} ->
                    % ?PRINT("create_dummy ~p~n", [FakeId]),
                    LeagueFigure = lib_diamond_league:convert_figure(Figure, #league_figure{power = Power, server_name = ServName}),
                    MyArgs = [{figure, Figure}, {battle_attr, BattleAttr}, {skill, SkillList}, {die_handler, {?MODULE, fake_man_die_handler, [State#battle_state.self, FakeId]}}, {group, 1}, {warning_range, 5000}],
                    MonId = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X, Y, 1, CopyId, 1, MyArgs),
                    FilledRole = FakeRole#battle_role{data = Data#{figure => LeagueFigure, mon_id => MonId}, state = ?ROLE_STATE_IN},
                    NewRoleMap = RoleMap#{FakeId => FilledRole},
                    State#battle_state{roles = NewRoleMap, data = StateData#{fake_id => MonId}};
                _ ->
                    ok
            end;
        true ->
            ok
    end.

fake_man_die_handler(_, _Klist, _Atter, _AtterSign, [BattlePid, RoleId]) ->
    mod_battle_field:player_die(BattlePid, RoleId, []).

dummy_start_battle(Id, Time) ->
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{aid = Aid} ->
            Aid ! {'change_attr', [{find_target, Time * 1000}]};
        _ ->
            skip
    end.

battle_start(#battle_state{roles = RoleMap, data = Data} = State, [BattleEndTime]) ->
    NewState = State#battle_state{data = Data#{stage_end_time => {2, BattleEndTime}}},
    {ok, BinData} = pt_604:write(60415, [6, BattleEndTime]),
    % BinData = pack_battle_info(NewState),
    maps:map(fun
                 (_, #battle_role{data = #{mon_id := _Id}}) ->
                     skip;
                 (Id, _) ->
                     lib_clusters_center:send_to_uid(Id, BinData)
             end, RoleMap),
    
    {ok, BinData1} = pt_604:write(60415, [7, BattleEndTime]),
    Visitors = maps:get(visitors, Data, []),
    [lib_clusters_center:send_to_uid(VisitorId, BinData1) || {VisitorId, _} <- Visitors],
    NewState.

battle_time_out(#battle_state{is_end = false} = State, []) ->
    % ?PRINT("battle_time_out res = ~p~n", [ok]),
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, roles = RoleMap, self = Self} = State,
    case [{RoleId, Life} || {RoleId, #battle_role{data = #{league_role := #league_role{life = Life}}}} <- maps:to_list(RoleMap)] of
        [{_, L}, {_, L}] -> %% 命数相同
            SceneKeys
                = maps:fold(fun
                                (RoleId, #battle_role{data = #{mon_id := Id}}, Acc) ->
                                    [{RoleId, {obj, Id}} | Acc];
                                (RoleId, _, Acc) ->
                                    [{RoleId, {user, RoleId}} | Acc]
                            end, [], RoleMap),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, SceneKeys]);
        LifeList ->
            adjudge_battle(State, LifeList)
    end;

battle_time_out(_State, _) -> ok.

late_force_end(#battle_state{roles = RoleMap, data = StateData} = State, RoleId) ->
    case StateData of
        #{late_force_end := false} ->
            skip;
        _ ->
            NewRoleMap = maps:map(fun
                                      (_, #battle_role{state = S, data = Data} = Role) ->
                                          case S of
                                              ?ROLE_STATE_IN ->
                                                  Role#battle_role{data = Data#{res => 1}};
                                              _ ->
                                                  Role#battle_role{data = Data#{res => 0}}
                                          end
                                  end, RoleMap),
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err281_enemy_is_late), []]),
            lib_clusters_center:send_to_uid(RoleId, BinData),
            handle_result(State#battle_state{roles = NewRoleMap, data = StateData#{res_code => ?RES_REASON_LATE}})
    end.

get_scene_obj_hp(ReqPid, List) ->
    RespondList
        = [
        case Item of
            {Key, {obj, Id}} ->
                case lib_scene_object_agent:get_object(Id) of
                    #scene_object{battle_attr = #battle_attr{hp = Hp}} ->
                        {Key, Hp};
                    _ ->
                        {Key, 0}
                end;
            {Key, {user, RoleId}} ->
                case lib_scene_agent:get_user(RoleId) of
                    #ets_scene_user{battle_attr = #battle_attr{hp = Hp}} ->
                        {Key, Hp};
                    _ ->
                        {Key, 0}
                end
        end
        || Item <- List],
    mod_battle_field:apply_cast(ReqPid, ?MODULE, adjudge_battle, RespondList).

adjudge_battle(#battle_state{is_end = false} = State, RespondList) ->
    % ?PRINT("adjudge_battle res = ~p~n", [ok]),
    #battle_state{roles = RoleMap} = State,
    case lists:reverse(lists:keysort(2, RespondList)) of
        [{RoleKey, _} | _] ->
            NewRoleMap = maps:map(fun
                                      (Key, #battle_role{data = D} = R) ->
                                          if
                                              RoleKey =:= Key ->
                                                  R#battle_role{data = D#{res => 1}};
                                              true ->
                                                  R#battle_role{data = D#{res => 0}}
                                          end
                                  end, RoleMap);
        _ ->
            NewRoleMap = maps:map(fun
                                      (_, #battle_role{data = D} = R) ->
                                          R#battle_role{data = D#{res => 0}}
                                  end, RoleMap)
    end,
    handle_result(State#battle_state{roles = NewRoleMap});

adjudge_battle(_, _) ->
    ok.


handle_result(#battle_state{roles = RoleMap, self = Self, data = #{round := CurRound} = Data} = State) ->
    % ?PRINT("handle_result res = ~p~n", [ok]),
    RoleList = maps:to_list(RoleMap),
    Reason = maps:get(res_code, Data, ?RES_REASON_NORMAL),
    ResInfos
        = [begin
               lib_diamond_league:apply_cast_from_center(RoleId, ?MODULE, player_handle_result, [RoleId, Res, CurRound, Reason]),
               DieCount = maps:get(die_count, D, 0),
               {RoleId, Res, Life, Figure, DieCount}
           end || {RoleId, #battle_role{data = #{res := Res, league_role := #league_role{life = Life}, figure := Figure} = D}} <- RoleList],
    % mod_battle_field:stop(Self),
    log_battle(CurRound, ResInfos),
    
    mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
    Visitors = maps:get(visitors, Data, []),
    erlang:send_after(20000, Self, stop),
    WinRoleName
        = case lists:keyfind(1, 2, ResInfos) of
              {_, _, _, #league_figure{name = Name}, _} ->
                  Name;
              _ ->
                  <<"">>
          end,
    {ok, BinData} = pt_604:write(60426, [WinRoleName]),
    [lib_clusters_center:send_to_uid(VisitorId, BinData) || {VisitorId, _} <- Visitors],
    State#battle_state{is_end = true}.

pack_battle_info(#battle_state{roles = RoleMap}) ->
    RoleInfos = maps:fold(fun
                              (_, #battle_role{data = #{mon_id := Id, league_role := #league_role{life = Life}}}, Acc) ->
                                  [{Id, Life} | Acc];
                              (Id, #battle_role{data = #{league_role := #league_role{life = Life}}}, Acc) ->
                                  [{Id, Life} | Acc];
                              (_, _, Acc) ->
                                  Acc
                          end, [], RoleMap),
    {ok, BinData} = pt_604:write(60407, [RoleInfos]),
    BinData.

player_handle_result(RoleId, Res, CurRound, Reason) ->
    if
        Res =:= 1 ->
            {ok, BinData} = pt_604:write(60409, [Res, CurRound, Reason]),
            lib_server_send:send_to_uid(RoleId, BinData),
            Rewards = data_diamond_league:get_win_rewards(CurRound),
            lib_goods_api:send_reward_by_id(Rewards, diamond_league_result, Res, RoleId);
        true ->
            Rewards = data_diamond_league:get_lose_rewards(CurRound),
            if
                Reason =:= ?RES_REASON_NORMAL ->
                    {ok, BinData} = pt_604:write(60409, [Res, CurRound, Reason]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    lib_goods_api:send_reward_by_id(Rewards, diamond_league_result, Res, RoleId);
                true ->
                    Title = utext:get(6040005),
                    Content = utext:get(6040006, [lib_diamond_league:get_round_name(CurRound)]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards)
            end
    end,
    
    if
        Res =/= 1 ->
            % spawn(fun
            %     () ->
            %         timer:sleep(60000),
            %         lib_player:apply_cast(RoleId, lib_diamond_league, player_quit_after_fail, [])
            % end),
            mod_diamond_league_local:mark_player_lose(RoleId, CurRound);
        true ->
            ok
    end,
    todo.

evt_enter_scene_finish(Player, [ForbidTime]) ->
    case Player#player_status.battle_field of
        #{mod_lib := ?MODULE} = BattleField ->
            SkillList = maps:get(support_skills, BattleField, []),
            SkillIds = data_diamond_league:get_skill_ids(),
            FormatList
                = lists:foldl(fun
                                  (Id, Acc) ->
                                      case lists:keyfind(Id, 1, SkillList) of
                                          {Id, C, Time} ->
                                              NextUseCount = C + 1;
                                          _ ->
                                              NextUseCount = 1, Time = 0
                                      end,
                                      case data_diamond_league:get_skill_cfg(Id, NextUseCount) of
                                          [{[{_, _, Price} | _], Cd} | _] -> ok;
                                          _ -> Price = 0, Cd = 0
                                      end,
                                      UseTime = Time + Cd,
                                      [{Id, Price, UseTime} | Acc]
                              end, [], SkillIds),
            {ok, BinData} = pt_604:write(60408, [FormatList]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            NewPlayer = lists:foldl(fun
                                        (SkillId, PS) ->
                                            {ok, NewPS} = lib_skill:add_tmp_skill_list(PS, SkillId, 1),
                                            NewPS
                                    end, Player, SkillIds),
            NewPlayer#player_status{forbid_pk_etime = ForbidTime};
        _ ->
            ok
    end.

evt_out_of_battle(Player, _) ->
    SkillIds = data_diamond_league:get_skill_ids(),
    NewPlayer = lists:foldl(fun
                                (SkillId, PS) ->
                                    {ok, PS2} = lib_skill:del_tmp_skill_list(PS, SkillId),
                                    PS2
                            end, Player, SkillIds),
    NewPlayer.

player_use_skill(State, [RoleName, SkillId]) ->
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    {ok, BinData} = pt_604:write(60414, [RoleName, SkillId]),
    lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData).

add_life(State, RoleId) ->
    #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, is_end = IsEnd} = State,
    case maps:find(RoleId, RoleMap) of
        {ok, #battle_role{data = #{league_role := LRole} = Data} = Role} when not IsEnd ->
            #league_role{life = Life} = LRole,
            NewRole = Role#battle_state{data = Data#{league_role => LRole#league_role{life = Life + 1}}},
            NewRoleMap = RoleMap#{RoleId => NewRole},
            NewState = State#battle_state{roles = NewRoleMap},
            BinData = pack_battle_info(NewState),
            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
            NewState;
        _ ->
            skip
    end.

visit_battle(#battle_state{is_end = false, data = Data, cur_scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, self = Self} = State, {Node, RoleId, Args}) ->
    Visitors = maps:get(visitors, Data, []),
    #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
    Num = length(Visitors),
    if
        Num < ?VISITOR_MAX_NUM ->
            KeyValueList = [
                {scene_hide_type, ?HIDE_TYPE_VISITOR},
                {battle_field, {?MODULE, visit, Self}}
            ],
            NewVisitors = lists:keystore(RoleId, 1, Visitors, {RoleId, Args}),
            BinData = pack_battle_info(State),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            case maps:find(stage_end_time, Data) of
                {ok, {2, BattleEndTime}} ->
                    {ok, BinData1} = pt_604:write(60415, [7, BattleEndTime]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData1);
                _ ->
                    skip
            end,
            EnterMFA = {?MODULE, visitor_enter_callback, []},
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_scene, change_scene_with_callback, [SceneId, PoolId, CopyId, X, Y, false, false, KeyValueList, EnterMFA]),
            % mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [RoleId, SceneId, PoolId, CopyId, 943, 673, false, KeyValueList]),
            State#battle_state{data = Data#{visitors => NewVisitors}};
        true ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_visitor_num_limit), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData)
    end;

visit_battle(_, {Node, RoleId, _}) ->
    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_battle_end), []]),
    lib_server_send:send_to_uid(Node, RoleId, BinData).

visit_leave(#battle_state{data = Data} = State, {Node, RoleId}) ->
    KeyValueList = [
        {scene_hide_type, 0},
        {battle_field, undefined}
    ],
    Visitors = maps:get(visitors, Data, []),
    case lists:keyfind(RoleId, 1, Visitors) of
        {RoleId, [SceneId, PoolId, CopyId, X, Y]} ->
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [RoleId, SceneId, PoolId, CopyId, X, Y, false, KeyValueList]),
            NewVisitors = lists:keydelete(RoleId, 1, Visitors),
            State#battle_state{data = Data#{visitors => NewVisitors}};
        _ ->
            skip
    end.

get_60415_msg(State, [Node, RoleId]) ->
    case State of
        #battle_state{data = #{stage_end_time := {2, BattleEndTime}} = Data, roles = RoleMap} ->
            case maps:find(RoleId, RoleMap) of
                {ok, _} ->
                    {ok, BinData} = pt_604:write(60415, [6, BattleEndTime]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData);
                _ ->
                    case lists:keyfind(RoleId, 1, maps:get(visitors, Data, [])) of
                        {RoleId, _} ->
                            {ok, BinData} = pt_604:write(60415, [7, BattleEndTime]),
                            lib_server_send:send_to_uid(Node, RoleId, BinData);
                        _ ->
                            skip
                    end
            end;
        _ ->
            skip
    end.

revive_player(#battle_state{self = Self} = State, [RoleId, Self]) ->
    #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    case maps:find(RoleId, RoleMap) of
        {ok, #battle_role{key = RoleId, data = #{league_role := #league_role{life = Life} = LRole} = Data, in_info = #{x := X, y := Y}} = Role} when Life > 0 ->
            NewLRole = LRole#league_role{life = Life - 1},
            NewRole = Role#battle_role{data = Data#{league_role => NewLRole}},
            lib_diamond_league:player_apply_cast_from_center(RoleId, lib_revive, revive_without_check, [?REVIVE_ROUND, [{x, X}, {y, Y}]]),
            NewState = State#battle_state{roles = RoleMap#{RoleId => NewRole}},
            BinData = pack_battle_info(NewState),
            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
            NewState;
        _ ->
            skip
    end;

revive_player(_, _) -> skip.

log_battle(CurRound, Infos) ->
    case lists:keyfind(1, 2, Infos) of
        {WinId, 1, WinLife, WinFigure, WinDieCount} ->
            ok;
        _ ->
            WinId = 0, WinLife = 0, WinFigure = #league_figure{}, WinDieCount = 0
    end,
    case lists:keyfind(0, 2, Infos) of
        {LoseId, 0, _LoseLife, LoseFigure, LoseDieCount} ->
            ok;
        _ ->
            LoseId = 0, LoseFigure = #league_figure{}, LoseDieCount = 0
    end,
    #league_figure{name = WinName, server_name = WinServ} = WinFigure,
    #league_figure{name = LoseName, server_name = LoseServ} = LoseFigure,
    RoundName = lib_diamond_league:get_round_name(CurRound),
    lib_log_api:log_diamond_league_battle(RoundName, WinId, WinName, WinServ, WinDieCount, WinLife, LoseId, LoseName, LoseServ, LoseDieCount, utime:unixtime()).

pack_reconnect_args(_Player) ->
    mod_disperse:get_clusters_node().

visitor_enter_callback(Player, _) ->
    {ok, BinData} = pt_604:write(60425, []),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    lib_player_event:add_listener(?EVENT_DISCONNECT, ?MODULE, visitor_disconnect),
    lib_player_event:add_listener(?EVENT_RECONNECT, ?MODULE, visitor_reconnect). %% 顶号

visitor_disconnect(#player_status{id = RoleId, battle_field = BattleField} = Player, _) ->
    lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, visitor_disconnect),
    lib_player_event:remove_listener(?EVENT_RECONNECT, ?MODULE, visitor_reconnect),
    case BattleField of
        {?MODULE, visit, BattlePid} ->
            Node = mod_disperse:get_clusters_node(),
            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, visit_leave, {Node, RoleId});
        _ ->
            ok
    end,
    {ok, Player}.

visitor_reconnect(#player_status{id = RoleId, battle_field = BattleField} = Player, _) ->
    case BattleField of
        {?MODULE, visit, BattlePid} ->
            Node = mod_disperse:get_clusters_node(),
            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, visit_reconnect, {Node, RoleId});
        _ ->
            ok
    end,
    {ok, Player}.

visit_reconnect(State, {Node, RoleId}) ->
    {ok, BinData0} = pt_604:write(60425, []),
    lib_server_send:send_to_uid(Node, RoleId, BinData0),
    BinData = pack_battle_info(State),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    get_60415_msg(State, [Node, RoleId]).

pack_enter_args(_Role, State) ->
    ForbidTime
        = case State of
              #battle_state{data = #{stage_end_time := {1, BattleStartTime}}} ->
                  BattleStartTime;
              _ ->
                  utime:unixtime() + ?BEFORE_START_TIME
          end,
    [ForbidTime].

battle_ready(Player, BattleStartTime) ->
    {ok, BinData} = pt_604:write(60415, [3, BattleStartTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    Player#player_status{forbid_pk_etime = BattleStartTime}.