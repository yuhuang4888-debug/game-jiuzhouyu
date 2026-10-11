%%-----------------------------------------------------------------------------
%% @Module  :       lib_top_pk_battle.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-06
%% @Description:    巅峰竞技战斗
%%-----------------------------------------------------------------------------

-module (lib_top_pk_battle).
-include ("battle_field.hrl").
-include ("def_fun.hrl").
-include ("predefine.hrl").
-include ("server.hrl").
-include ("top_pk.hrl").
-include ("scene.hrl").
-include ("attr.hrl").
-include ("common.hrl").
-include ("errcode.hrl").

%% 行为接口
-export ([
    %% 战场进程
    init/2
    ,player_enter/3
    ,player_quit/3
    ,player_logout/3
    ,player_finish_change_scene/3
    ,player_die/3
    ,player_revive/3
    ,player_reconnect/3
    ,player_disconnect/3
    ,terminate/2
    %% 玩家进程
    ,evt_out_of_battle/2
    % % ,mon_hp_change/3
    ,mon_die/3
    ]).

%% 其它接口
-export ([
    fake_man_die_handler/5
    ,battle_time_out/2
    ,adjudge_battle/2
    ,get_scene_obj_hp/2
    ,battle_start/2
    ,dummy_start_battle/2
    ,late_force_end/2
    ]).

-define (COPY (Id), {?MODULE, Id}).


% -record (battle_state, {
%     lib = lib_battle_field,
%     cur_scene = 0,
%     scene_pool_id = 0,
%     copy_id = 0,
%     data = #{},
%     roles = #{}
%     }).

% -record (battle_role, {
%     key,
%     out_info,
%     in_info,
%     state = ?ROLE_STATE_OUT,
%     data = #{}
%     }).
init(State, Args) ->
%%    SceneId = data_top_pk:get_kv(battle_scene_local, local),
    PosList = data_top_pk:get_kv(born_pos, global),
    ScenePoolId = 0,
    [{X1, Y1}, {X2, Y2}|_] = ?IF(urand:rand(1,2) == 1, PosList, lists:reverse(PosList)),
    case Args of
        [{RoleKey1, [Platform1, Serv1, RoleName1, GradeNum1, RankLv1, Point1]}, {RoleKey2, [Platform2, Serv2, RoleName2, GradeNum2, RankLv2, Point2]}] ->
            RoleMap = #{
                RoleKey1 => #battle_role{key = RoleKey1, in_info = #{x => X1, y => Y1}, data = #{platform => Platform1, server => Serv1, name => RoleName1,
                    grade_num => GradeNum1, rank_lv => RankLv1, point => Point1}},
                RoleKey2 => #battle_role{key = RoleKey2, in_info = #{x => X2, y => Y2}, data = #{platform => Platform2, server => Serv2, name => RoleName2,
                    grade_num => GradeNum2, rank_lv => RankLv2, point => Point2}}
            },
            {MinDay, MaxDay} = data_top_pk:get_kv(local_match_day,default),
            OpenDay = util:get_open_day(),
            if
                OpenDay >= MinDay andalso OpenDay =< MaxDay ->%%本服匹配
                    SceneId = data_top_pk:get_kv(battle_scene_local, local);
                true ->
                    SceneId = data_top_pk:get_kv(battle_scene, global)
            end,
            Data = #{};
        [RoleKey1, fake_man, FakeMan] ->
            % {_, RoleIdAsCopyId} = RoleKey1,
            RoleMap = #{
                RoleKey1 => #battle_role{key = RoleKey1, in_info = #{x => X1, y => Y1}}
            },
            SceneId = data_top_pk:get_kv(battle_scene_local, local),
            [Figure, BattleAttr, Skills, _GradeNum, _RankLv, _RankPoint] = FakeMan,
            MyArgs = [{figure, Figure}, {battle_attr, BattleAttr}, {skill, Skills},{die_handler, {?MODULE, fake_man_die_handler, [State#battle_state.self]}}, {group, 2}],
            Id = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X2, Y2, 1, ?COPY(State#battle_state.self), 1, MyArgs),
%%            ?MYLOG("cym", "fakeMonId ~p~n", [Id]),
            Data = #{fake_man => #{data => FakeMan, id => Id}}
    end,
    NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = ?COPY(State#battle_state.self), roles = RoleMap, data = Data},
    {ok, NewState}.

player_enter(RoleKey, Args, State) ->
    #battle_state{roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{out_info = OutInfo, in_info = InInfo} = Role} ->
            [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim] = Args,
            NewOutInfo 
            = OutInfo#{
                scene => OSceneId, 
                scene_pool_id => OPoolId, 
                copy_id => OCopyId, 
                x => X, 
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => [{last_battle_time, 0}]
            },
            if
                Hp > 0 ->
                    InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}];
                true ->
                    InSceneArgs = [{change_scene_hp, 1}]
            end,
            {ok, Role#battle_role{out_info = NewOutInfo, in_info = InInfo#{scene_args => InSceneArgs}}, State};
        _ ->
            skip
    end.

%% 退出算输
player_quit(Role, Args, State) ->
    if
        State#battle_state.is_end =:= false ->
            player_logout(Role, Args, State);
        true ->
            % case lists:any(fun
            %     ({_, #battle_role{state = S} = R}) ->
            %         R =/= Role andalso S =/= ?ROLE_STATE_OUT
            % end, maps:to_list(State#battle_state.roles)) of
            %     false ->
            %         {stop, State};
            %     _ ->
            %         {ok, Role, State}
            % end
            {ok, Role, State}
    end.

player_disconnect(Role, Args, State) ->
    player_logout(Role, Args, State).

%% 掉线算输
player_logout(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    % ?PRINT("player_logout res = ~p~n", [ok]),
    #battle_state{roles = RoleMap} = State,
    NewRoleMap
    = maps:map(fun
        (K, #battle_role{data = D} = R) ->
            if
                K =/= RoleKey ->
                    R#battle_role{data = D#{res => 1}};  %%敌方胜利
                true ->
                    R#battle_role{data = D#{res => 0}}   %%己方失败
            end
    end, RoleMap),
    #battle_state{roles = NewRoleMap2} = NewState = handle_result(State#battle_state{roles = NewRoleMap}),
    NewRole = maps:get(RoleKey, NewRoleMap2),
    {ok, NewRole, NewState};

player_logout(_Role, _Args, _State) ->
    skip.

player_die(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    % ?PRINT("player_die res = ~p~n", [ok]),
    ?MYLOG("cym", "player_die ~p~n", [RoleKey]),
    #battle_state{roles = RoleMap} = State,
    NewRoleMap
    = maps:map(fun
        (K, #battle_role{data = D} = R) ->
            if
                K =/= RoleKey ->
                    R#battle_role{data = D#{res => 1}};
                true ->
                    R#battle_role{data = D#{res => 0}}
            end
    end, RoleMap),
    #battle_state{roles = NewRoleMap2} = NewState = handle_result(State#battle_state{roles = NewRoleMap}),
    NewRole = maps:get(RoleKey, NewRoleMap2),
    #battle_role{out_info = #{hp := Hp} = OutInfo} = NewRole,
    SceneAttr = maps:get(scene_args, OutInfo, []),
    ReviveSceneAttr
    = case lists:keyfind(change_scene_hp, 1, SceneAttr) of
        false->
            [{change_scene_hp, Hp}|SceneAttr];
        _ ->
            SceneAttr
    end,
    {ok, NewState#battle_state{roles = NewRoleMap2#{RoleKey => NewRole#battle_role{out_info = OutInfo#{scene_args => ReviveSceneAttr}}}}};

player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.

player_reconnect(#battle_role{key = {Node, RoleId}}, _, #battle_state{data = #{battle_end_time := BattleEndTime}}) ->
    {ok, BinData} = pt_281:write(28112, [2, BattleEndTime]),
    lib_top_pk:apply_cast(Node, lib_server_send, send_to_uid, [RoleId, BinData]);

player_reconnect(_, _, _) ->
    skip.



player_finish_change_scene(Role, _Args, State) ->
    % ?PRINT("player_finish_change_scene res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State,
    RoleList = maps:to_list(RoleMap),
    case lists:all(fun
        ({_key, R}) ->
            R#battle_role.state =:= ?ROLE_STATE_IN orelse R#battle_role.key =:= Role#battle_role.key
    end, RoleList) of
        true ->
            BeforeStartTime = data_top_pk:get_kv(default, before_start_time),
            BatleTime = data_top_pk:get_kv(default, battle_time),
            BattleStartTime = utime:unixtime() + BeforeStartTime,
            lists:map(fun
                ({{Node, RoleId}, _}) ->
                    lib_top_pk:apply_cast(Node, lib_top_pk, send_stage_time, [RoleId, ?top_pk_stage_wait, BattleStartTime])
            end, RoleList),
            erlang:send_after(BeforeStartTime * 1000, Self, {apply, ?MODULE, battle_start, [BattleStartTime + BatleTime]}),
            erlang:send_after((BeforeStartTime + BatleTime) * 1000, Self, {apply, ?MODULE, battle_time_out, []}),
            case Data of
                #{fake_man := #{id := DummyId}} ->
                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, dummy_start_battle, [DummyId, BeforeStartTime]);
                _ ->
                    ok
            end,
            {ok, Role, State#battle_state{data = Data#{late_force_end => false}}};
        _ ->
            erlang:send_after(30 * 1000, Self, {apply, ?MODULE, late_force_end, Role#battle_role.key}),
            {ok, Role, State}
     end.

mon_die(_MonKey, _Args, #battle_state{is_end = false} = State) ->
%%    ?MYLOG("cym", "mon die ++++++++++++", []),
    #battle_state{roles = RoleMap} = State,
    NewRoleMap = maps:map(fun
        (_, #battle_role{data = D} = R) ->
            R#battle_role{data = D#{res => 1}}
    end, RoleMap),
    NewState = handle_result(State#battle_state{roles = NewRoleMap}),
    {ok, NewState};

mon_die(_, _, _) -> ok.

terminate(_Reason, #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId}) ->
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId).

battle_start(#battle_state{roles = RoleMap, data = Data} = State, [BattleEndTime]) ->
    maps:map(fun
                ({Node, RoleId}, _) ->
                    lib_top_pk:apply_cast(Node, lib_top_pk, send_stage_time, [RoleId, ?top_pk_stage_pk, BattleEndTime])
            end, RoleMap),

    State#battle_state{data = Data#{battle_end_time => BattleEndTime}}.

late_force_end(#battle_state{roles = RoleMap, data = StateData} = State, {Node, RoleId}) ->
    ?MYLOG("cym", "late_force_end ++++++++++++", []),
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
            {ok, BinData} = pt_281:write(28100, [?ERRCODE(err281_enemy_is_late), []]),
            lib_top_pk:apply_cast(Node, lib_server_send, send_to_uid, [RoleId, BinData]),
            handle_result(State#battle_state{roles = NewRoleMap})
    end.


battle_time_out(#battle_state{is_end = false} = State, []) ->
    % ?PRINT("battle_time_out res = ~p~n", [ok]),
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, roles = RoleMap, self = Self} = State,
    case maps:to_list(RoleMap) of
        [{RoleKey1, _}, {RoleKey2, _}] ->
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, [RoleKey1, RoleKey2]]);
        [{RoleKey1, _}] ->
            #battle_state{data = #{fake_man := #{id := Id}}} = State,
            lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, [RoleKey1, {obj, Id}]]);
        _ ->
            ok
    end;


battle_time_out(_State, _) -> ok.

get_scene_obj_hp(ReqPid, List) ->
    RespondList
    = [
        case Item of
            {obj, Id} ->
                case lib_scene_object_agent:get_object(Id) of
                    #scene_object{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLimit}} ->
%%                        ?MYLOG("cym", "Item~p  Hp ~p  HpLimit ~p~n", [Item, Hp, HpLimit]),
                        {Item, trunc(Hp / HpLimit * ?top_pk_hp_ratio)};
                    _ ->
%%                        ?MYLOG("cym", "Item ~p  Hp ~p", [Item, 0]),
                        {Item, 0}
                end;
            {_, RoleId} ->
                case lib_scene_agent:get_user(RoleId) of
                    #ets_scene_user{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLimit}} ->
%%                        ?MYLOG("cym", "Item~p  Hp ~p  Limit ~p~n", [Item, Hp, HpLimit]),
                        {Item, trunc(Hp / HpLimit * ?top_pk_hp_ratio)};
                    _User ->
%%                        ?MYLOG("cym", "_User ~p  Hp ~p", [_User, 0]),
                        {Item, 0}
                end
        end
    || Item <- List],
    mod_battle_field:apply_cast(ReqPid, ?MODULE, adjudge_battle, RespondList).

dummy_start_battle(Id, Time) ->
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{aid = Aid} ->
            Aid ! {'change_attr', [{find_target, Time*1000}]};
        _ ->
            skip
    end.

adjudge_battle(#battle_state{is_end = false} = State, RespondList) ->
    #battle_state{roles = RoleMap} = State,
    Res = lists:reverse(lists:keysort(2, RespondList)),
    ?MYLOG("cym", "adjudge_battle Res = ~p~n", [Res]),
    case Res of
        [{RoleKey, _}|_] ->
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



handle_result(#battle_state{roles = RoleMap, self = Self, data = Data} = State) ->
%%    ?MYLOG("cym", "handle_result ++++++++++++++++~n", []),
    RoleList = maps:to_list(RoleMap),
    erlang:send_after(10000, Self, stop), %%10后停止进程
    QuitTime = utime:unixtime() + 10,
    [begin
        EnemyInfo = calc_enemy_info({Node, RoleId}, RoleList, Data),
        lib_top_pk:apply_cast(Node, lib_top_pk, calc_battle_result, [RoleId, Res, [EnemyInfo, QuitTime]])
     end || {{Node, RoleId}, #battle_role{data = #{res := Res}}} <- RoleList],
    State#battle_state{is_end = true}.

evt_out_of_battle(Player, _Reason) ->
    #player_status{top_pk = PKStatus} = Player,
    lib_player:break_action_lock(Player#player_status{top_pk = PKStatus#top_pk_status{pk_state = []}}, ?ERRCODE(err281_on_battle_state)).


%% 计算敌人信息
calc_enemy_info(RoleKey, [{RoleKey, _}|T], Data) ->
    calc_enemy_info(RoleKey, T, Data);

calc_enemy_info(_, [{{_, RoleId}, #battle_role{data = #{platform := Platform, server := Serv, name := RoleName,
    grade_num := GradeNum, rank_lv := RankLv, point := Point}}}|_], _) ->
    [RoleId, Platform, Serv, RoleName, GradeNum, RankLv, Point];

calc_enemy_info(_, [], _) ->
    [].

fake_man_die_handler(#scene_object{id = Id}, _Klist, _Atter, _AtterSign, [BattleFieldPid]) ->
    mod_battle_field:mon_die(BattleFieldPid, Id, []).

