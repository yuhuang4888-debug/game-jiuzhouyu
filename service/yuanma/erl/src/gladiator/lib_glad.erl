%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 02. 一月 2019 14:29
%%%-------------------------------------------------------------------
-module(lib_glad).
-author("whao").



-include("gladiator.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("counter.hrl").
-include("role.hrl").
-include("server.hrl").
-include("battle_field.hrl").

-compile(export_all).
%% API


%%  从数据库获取数据
get_db_real_role(RoleId) ->
    case lib_glad_battle:db_role_glad_get_by_id(RoleId) of
        List when is_list(List) andalso List =/= [] ->
            GladRank = lib_glad_battle:make_record(glad_rank, List),
            GladRank;
        _ -> #glad_rank{role_id = RoleId}
    end.


%% 增加挑战次数
plus_challenge_num(RoleId, AddCount) ->
    {Count, RefreshTime} = get_challenge_num(RoleId),
    NewCount = Count + AddCount,
    mod_counter:set_count(RoleId, ?MOD_GLADITOR, ?DEFAULT_SUB_MODULE, ?GLAD_CHALLENGE_NUM, NewCount, RefreshTime),
    ok.


%% 获得剩余的次数
%% @return {当前次数, 刷新时间}
get_challenge_num(RoleId) ->
    MaxNum = ?GLAD_KV_NUM_MAX,
    ResumeTime = ?GLAD_KV_RESUME_TIME,
    {Count, RefreshTime} =
        case mod_counter:get(RoleId, ?MOD_GLADITOR, ?DEFAULT_SUB_MODULE, ?GLAD_CHALLENGE_NUM) of
            false -> {0, 0};
            #ets_counter{count = Count1, refresh_time = RefreshTime1} -> {Count1, RefreshTime1}
        end,
    NowTime = utime:unixtime(),
    Elapse = NowTime - RefreshTime,
    if
        Count >= MaxNum -> {Count, NowTime};
        Elapse < ResumeTime -> {Count, RefreshTime};
        true ->
            ResumeCount = Elapse div ResumeTime,
            Count2 = min(Count + ResumeCount, MaxNum),
            RefreshTime2 = RefreshTime + ResumeCount * ResumeTime,
            case Count2 >= MaxNum of
                true -> {Count2, NowTime};
                false -> {Count2, RefreshTime2}
            end
    end.


%% 挑战对手 ChallengeType:0 (进入场景)
challenge_image_role(Player, RivalId, RivCombat, _ChallengeType) ->
    #player_status{sid = Sid, id = RoleId, combat_power = Combat, figure = Figure} = Player,
    #figure{lv = Lv, name = _RoleName} = Figure,
    case do_check_challenge_lv(Player) of
        true ->
            ChallengeRole = #glad_challenge_role{
                role_id = RoleId, %% 角色id
                %%                role_name = RoleName,   %% 角色名称
                role_lv = Lv, %% 角色等级
                self_figure = Figure, %% 自己形象
                self_combat = Combat, %% 自己的战力
                rival_id = RivalId, %% 对手id
                rival_combat = RivCombat    %% 对手战力
            },
            if
                RivalId == RoleId ->
                    NewPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_653, 65399, [?ERRCODE(err280_not_battle_myslef)]);
                true ->
                    case lib_player_check:check_all(Player) of
                        true ->
                            NewPlayer = lib_player:soft_action_lock(Player, ?ERRCODE(err280_on_battle_state)),
                            GladRank = lib_glad_battle:make_record(new_glad_rank, Player),
                            mod_glad_local:create_glad_battle(ChallengeRole, Figure#figure.medal_id, GladRank);
                        {false, ErrCode} ->
                            NewPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_653, 65399, [ErrCode])
                    end
            end;
        {false, ErrCode} ->
            NewPlayer = Player,
            lib_server_send:send_to_sid(Sid, pt_653, 65399, [ErrCode])
    end,
    {ok, NewPlayer}.


%% 检查竞技所需等级
do_check_challenge_lv(Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    MinLv = ?GLAD_KV_OPEN_LV,
    if
        Lv < MinLv -> {false, ?ERRCODE(err280_lv_not_enough)};
        true -> true
    end.


%%------------check--------------

%% check 挑战资格
check_challenge(State, _ChallengeRole, []) -> {true, State};
check_challenge(State, ChallengeRole, [H | T]) ->
    case do_check_challenge(State, ChallengeRole, H) of
        {true, NewState} ->
            check_challenge(NewState, ChallengeRole, T);
        {false, Errcode, NewState} ->
            {false, Errcode, NewState}
    end.

%% 挑战次数
%%do_check_challenge(State, ChallengeRole, challenge_num) ->
%%    ?PRINT("challenge_num:~n",[]),
%%    #glad_challenge_role{role_id = RoleId} = ChallengeRole,
%%    {JJCNum, _RefreshTime} = get_challenge_num(RoleId),
%%    case JJCNum > 0 of
%%        true ->
%%            ?PRINT("check_challenge1~n",[]),
%%            {true, State};
%%        false ->
%%            ?PRINT("d1~n", []),
%%            {false, ?ERRCODE(err280_jjc_num_not_enough), State}
%%    end;
%% 对手是否在战斗中
do_check_challenge(State, ChallengeRole, rival_battle_status) ->
    #glad_state{battle_status_maps = BStatusMaps} = State,
    #glad_challenge_role{rival_id = RRoleId} = ChallengeRole,
    case RRoleId == 0 of
        true ->
            {true, State};
        false ->
            case maps:get(RRoleId, BStatusMaps, ?GLAD_NOT_BATTLE_STATUS) of
                ?GLAD_NOT_BATTLE_STATUS ->
                    {true, State};
                ?GLAD_BATTLE_STATUS ->
                    {false, ?ERRCODE(err280_on_battle_state), State}
            end
    end;
%% 自己是否在战斗中
do_check_challenge(State, ChallengeRole, self_battle_status) ->
    #glad_state{battle_status_maps = BStatusMaps} = State,
    #glad_challenge_role{role_id = RoleId} = ChallengeRole,
    case RoleId == 0 of
        true ->
            {true, State};
        false ->
            case maps:get(RoleId, BStatusMaps, ?GLAD_NOT_BATTLE_STATUS) of
                ?GLAD_NOT_BATTLE_STATUS ->
                    {true, State};
                ?GLAD_BATTLE_STATUS ->
                    {false, ?ERRCODE(err280_on_battle_state), State}
            end
    end;

%% 容错
do_check_challenge(State, _ChallengeRole, _Msg) ->
    {false, ?FAIL, State}.


%%  创建战场
create_glad_fake_battle(RoleId, RivalId, RivalCombat, RivalFigure) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_glad, create_glad_fake_battle, [RivalId, RivalCombat, RivalFigure]);
create_glad_fake_battle(Player, RivalId, RivalCombat, RivalFigure) ->
    #player_status{id = RoleId, figure = RoleFigure, glad_battle_pid = OldBattlePid, battle_attr = RoleBattleAttr} = Player,
    case misc:is_process_alive(OldBattlePid) of
        true ->
            BattlePid = undefined,
            NewPlayer = Player;
        false ->
            %% 根据战力来计算所属性
            RoleSkills = data_skill:get_ids(RoleFigure#figure.career, RoleFigure#figure.sex),
            RivalAttr = get_robot_attr(RivalCombat),
            RivalBattleAttr = #battle_attr{hp = RivalAttr#attr.hp, hp_lim = RivalAttr#attr.hp, attr = RivalAttr},
            if
                RivalId == 0 ->
                    #figure{career = Career, sex = Sex} = RivalFigure,
                    RivalSkills = data_skill:get_ids(Career, Sex);
                true ->
                    #figure{career = Career, sex = Sex} = RivalFigure,
                    RivalSkills = data_skill:get_ids(Career, Sex)
            end,
            RoleHp = RoleBattleAttr#battle_attr.hp_lim,
            NewRoleBattleAttr = RoleBattleAttr#battle_attr{hp = RoleHp},
            RoleFakeData = [RoleFigure, NewRoleBattleAttr, RoleSkills],
            RivalFakeData = [RivalFigure, RivalBattleAttr, RivalSkills],
            case catch mod_battle_field:start(lib_glad, [RoleId, RivalId, fake_man, RoleFakeData, RivalFakeData]) of
                BattlePid when is_pid(BattlePid) ->
                    NewPlayer = battle_field_create_done(Player, BattlePid, RoleId);
                _ ->
                    BattlePid = undefined,
                    NewPlayer = battle_field_close(Player, init_error)
            end
    end,
    {ok, NewPlayer#player_status{glad_battle_pid = BattlePid}}.



battle_field_create_done(Player, BattlePid, RoleId) ->
    #player_status{
        sid = _Sid,
        scene = OSceneId,
        scene_pool_id = OPoolId,
        copy_id = OCopyId,
        x = X,
        y = Y,
        battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}
    } = Player,
    ?PRINT("OCopyId :~p~n",[OCopyId]),
    NewPlayer = lib_player:setup_action_lock(Player, ?ERRCODE(err280_on_battle_state)),
    Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim],
    mod_battle_field:player_enter(BattlePid, RoleId, Args),
    NewPlayer.

battle_field_close(Player, _Resaon) ->
    lib_player:break_action_lock(Player, ?ERRCODE(err280_on_battle_state)).


%% 计算假人属性
get_robot_attr(Power) ->
    PowerAttrList = data_gladiator:get_glad_all_attr(),
    NewPowerAttrList = [{AttrType, round(Value * Power)} || {AttrType, Value} <- PowerAttrList],
    lib_player_attr:to_attr_record(NewPowerAttrList).


%% 创建战场
init(State, Args) ->
    SceneId = ?GLAD_KV_SCENE_ID,
    {X, Y} =
        case ?GLAD_KV_REAL_MAN_XY of
            SelfPosL when is_list(SelfPosL) ->
                [{X_1, Y_1}] = SelfPosL,
                {X_1, Y_1};
            _ -> {0, 0}
        end,
    {X1, Y1, X2, Y2} =
        case ?GLAD_KV_SCENE_XY of
            [{X11, Y11}, {X22, Y22} | _] ->
                {X11, Y11, X22, Y22};
            _ -> {0, 0, 0, 0}
        end,

    K = (Y2 - Y1) / (X2 - X1),
    B = Y1 - K * X1,
    EndX1 = (X1 + X2) div 2 - 60,
    EndX2 = (X1 + X2) div 2 + 60,
    EndY1 = round(K * EndX1 + B),
    EndY2 = round(K * EndX2 + B),

    ScenePoolId = 0,
    case Args of
        [RoleId, RivalId, fake_man, FakeManMine, FakeManRival] ->
            RoleIdAsCopyId = RoleId,
            RoleMap = #{
                RoleId => #battle_role{key = RoleId, in_info = #{x => X, y => Y}}
            },
            %% 创建假人 (假人找目标适当延迟几秒)
            [Figure, BattleAttr, Skills] = FakeManMine,
            MyArgs = [{figure, Figure}, {battle_attr, BattleAttr}, {skill, Skills}, {die_handler, {?MODULE, fake_man_die_handler, [State#battle_state.self]}},
                {group, 2}, {warning_range, 600}, {path, [{EndX1, EndY1}]}, {mod_args, RoleId}],
            Id = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X1, Y1, 1, RoleIdAsCopyId, 1, MyArgs),
            [Figure2, BattleAttr2, Skills2] = FakeManRival,
            MyArgs2 = [{figure, Figure2}, {battle_attr, BattleAttr2}, {skill, Skills2}, {die_handler, {?MODULE, fake_man_die_handler, [State#battle_state.self]}},
                {group, 1}, {warning_range, 600}, {path, [{EndX2, EndY2}]}, {mod_args, RivalId}],
            Id2 = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ScenePoolId, X2, Y2, 1, RoleIdAsCopyId, 1, MyArgs2),
            Data = #{fake_man_mine => #{data => FakeManMine, id => Id, role_id => RoleId},
                fake_man_rival => #{data => FakeManRival, id => Id2, role_id => RivalId}, copy_id => RoleIdAsCopyId},
            ?PRINT("RoleIdAsCopyId:~p~n",[RoleIdAsCopyId]),
            NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = RoleIdAsCopyId, roles = RoleMap, data = Data};
        _ ->
            NewState = State
    end,
    {ok, NewState}.


fake_man_die_handler(#scene_object{id = Id, mod_args = ModArgs}, _Klist, _Atter, _AtterSign, [BattleFieldPid]) ->
    mod_battle_field:mon_die(BattleFieldPid, Id, ModArgs).

mon_die(_MonKey, DieRoleId, #battle_state{is_end = false, roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State) ->
    #battle_state{data = Data} = State,
    case maps:get(clear_status, Data, 0) of
        0 ->
            RoleList = maps:to_list(RoleMap),
            %% 奖励显示时间
            RewardTime = case ?GLAD_KV_SHOW_LAST_TIME of
                             [] ->
                                 ?ERR("jjc cfg error:reward time!~n", []),
                                 10;
                             RewardTime1 -> RewardTime1
                         end,
            UnixTime = utime:unixtime(),
            [spawn(fun() ->
                % timer:sleep(200),
                case Data of
                    #{copy_id := CopyId} ->
                        mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, sleep_dummy, [CopyId]);
                    _ -> skip
                end,
                mod_glad_local:challenge_image_role_result(RoleId, DieRoleId =/= RoleId),
                lib_server_send:send_to_uid(RoleId, pt_653, 65309, [2, UnixTime + RewardTime])
                   end)
                || {RoleId, _} <- RoleList],
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    {ok, NewState};

mon_die(_, _, _) -> ok.



clear_dummy(CopyId) ->
    lib_scene_object_agent:clear_scene_object(0, CopyId, 1).


%%  玩家进入
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
                scene_args => [{ghost, 0}]
            },
            if
                Hp > 0 ->
                    InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}, {ghost, 1}];
                true ->
                    InSceneArgs = [{change_scene_hp, 1}, {ghost, 1}]
            end,
            {ok, Role#battle_role{out_info = NewOutInfo, in_info = InInfo#{scene_args => InSceneArgs}}, State};
        _ ->
            skip
    end.

player_quit(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    #battle_state{roles = NewRoleMap} = NewState = handle_result(State),
    NewRole = maps:get(RoleKey, NewRoleMap),
    {ok, NewRole, NewState};
player_quit(_, _, _) ->
    skip.

%% 掉线
player_logout(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    #battle_state{roles = NewRoleMap} = NewState = handle_result(State),
    NewRole = maps:get(RoleKey, NewRoleMap),
    {ok, NewRole, NewState};
player_logout(_Role, _Args, _State) ->
    skip.

%% 断开客户端
player_disconnect(#battle_role{}, _Args, #battle_state{is_end = false} = State) ->
    NewState = handle_result(State),
    {ok, NewState};
player_disconnect(_Role, _Args, _State) ->
    skip.


player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.


handle_result(#battle_state{roles = _RoleMap, self = Self, data = _Data} = State) ->
    mod_battle_field:stop(Self),
    State#battle_state{is_end = true}.


player_finish_change_scene(Role, _Args, State) ->
    #battle_state{roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State,
    RoleList = maps:to_list(RoleMap),
    case lists:all(fun
                       ({_key, R}) ->
                           R#battle_role.state =:= ?ROLE_STATE_IN orelse R#battle_role.key =:= Role#battle_role.key
                   end, RoleList) of
        true ->
            BeforeStartTime =
                case ?GLAD_KV_PARP_BATTLE_TIME of
                    BefStartTime when is_integer(BefStartTime) -> BefStartTime;
                    _ -> 3
                end,
            UnixTime = utime:unixtime(),
            [lib_server_send:send_to_uid(RoleId, pt_653, 65309, [0, UnixTime + BeforeStartTime])
                || {RoleId, _} <- RoleList],
            erlang:send_after(max((BeforeStartTime) * 1000, 100), Self, {apply, ?MODULE, ready_time_out, []}),
            case Data of
                #{fake_man_mine := #{id := DummyId1}, fake_man_rival := #{id := DummyId2}} ->
                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, dummy_start_battle,
                        [[DummyId1, DummyId2], BeforeStartTime * 1000 + 500]);
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    {ok, Role, State}.


dummy_start_battle(List, Time) ->
    [case lib_scene_object_agent:get_object(Id) of
         #scene_object{aid = Aid} ->
             Aid ! {'change_attr', [{find_target, Time}]};
         _ ->
             skip
     end || Id <- List].


send_fake_data(State, _Args) ->
    #battle_state{roles = RoleMap, data = Data} = State,
    RoleList = maps:to_list(RoleMap),
    case Data of
        #{fake_man_mine := #{id := SelfRobotId, role_id := _SelfRoleId},
            fake_man_rival := #{id := RivalRobotId, role_id := _RivalRoleId}} ->
            lists:map(fun
                          ({RoleId, _}) ->
                              lib_server_send:send_to_uid(RoleId, pt_653, 65304, [SelfRobotId, RivalRobotId])
                      end, RoleList);
        _ -> skip
    end,
    State.

ready_time_out(#battle_state{is_end = false, roles = RoleMap, self = Self}, []) ->
    RoleList = maps:to_list(RoleMap),
    BattleTime =
        case ?GLAD_KV_BATTLE_LAST_TIME of
            BatTime when is_integer(BatTime) -> BatTime;
            _ -> 30
        end,
    UnixTime = utime:unixtime(),
    [lib_server_send:send_to_uid(RoleId, pt_653, 65309, [1, UnixTime + BattleTime])
        || {RoleId, _} <- RoleList],
    erlang:send_after(BattleTime * 1000, Self, {apply, ?MODULE, battle_time_out, []});
ready_time_out(_State, _) -> ok.

battle_time_out(#battle_state{is_end = false, roles = RoleMap, self = Self, data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State, []) ->
    RewardTime =
        case ?GLAD_KV_SHOW_LAST_TIME of
            RewTime when is_integer(RewTime) -> RewTime;
            _ -> 10
        end,
    case maps:get(clear_status, Data, 0) of
        0 ->
            RoleList = maps:to_list(RoleMap),
            UnixTime = utime:unixtime(),
            [begin
                 case Data of
                     #{copy_id := CopyId} ->
                         mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, sleep_dummy, [CopyId]);
                     _ -> skip
                 end,
                 mod_glad_local:challenge_image_role_result(RoleId, false),
                 lib_server_send:send_to_uid(RoleId, pt_653, 65309, [2, UnixTime + RewardTime])
             end
                || {RoleId, _} <- RoleList],
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    erlang:send_after(RewardTime * 1000, Self, {apply, ?MODULE, reward_time_out, []}),
    NewState;
battle_time_out(_State, _) -> ok.


reward_time_out(#battle_state{is_end = false} = State, []) ->
    handle_result(State);
reward_time_out(_State, _) -> ok.


evt_out_of_battle(Player, _Reason) ->
    #player_status{sid = Sid} = Player,
    %% 通知客户端结束
    lib_server_send:send_to_sid(Sid, pt_653, 65306, [?SUCCESS]),
    lib_player:break_action_lock(Player#player_status{glad_battle_pid = undefined}, ?ERRCODE(err280_on_battle_state)).

terminate(_Reason, State) ->
    #battle_state{data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId),
    case Data of
        #{fake_man_mine := FakeMan, fake_man_rival := FakeRival} ->
            #{role_id := RoleId} = FakeMan,
            #{role_id := RoleId1} = FakeRival,
            mod_glad_local:set_battle_status(RoleId, ?GLAD_NOT_BATTLE_STATUS),
            mod_glad_local:set_battle_status(RoleId1, ?GLAD_NOT_BATTLE_STATUS);
        _ -> skip
    end.


skip_battle(#battle_state{data = Data, cur_scene = SceneId, scene_pool_id = ScenePoolId} = State, [RoleId]) ->
    case maps:get(clear_status, Data, 0) of
        0 ->
            mod_glad_local:challenge_image_role_result(RoleId, skip),
            NewState = State#battle_state{data = maps:put(clear_status, 1, Data)};
        1 -> NewState = State
    end,
    case Data of
        #{copy_id := CopyId} -> mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, clear_dummy, [CopyId]);
        _ -> skip
    end,
    NewState.


break_action_lock(RoleId, ErrCode) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [ErrCode]).


handle_decrement_challenge_num(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_decrement_challenge, []).

%% 处理减少次数的逻辑
handle_decrement_challenge(#player_status{id = RoleId}) ->
    {Count, RefreshTime} = get_challenge_num(RoleId),
    NewCount = max(Count - 1, 0),
    % 设置剩余挑战次数
    mod_counter:set_count(RoleId, ?MOD_GLADITOR, ?DEFAULT_SUB_MODULE, ?GLAD_CHALLENGE_NUM, NewCount, RefreshTime),
    mod_daily:increment(RoleId, ?MOD_GLADITOR, ?GLAD_USE_NUM),
    ok.


%% 睡眠假人
sleep_dummy(CopyId) ->
    ?PRINT("=====  mon_die  object:~p ~n", [lib_scene_object_agent:get_scene_object(CopyId)]),
    AllObject = lib_scene_object_agent:get_scene_object(CopyId),
    [begin
         Object#scene_object.aid ! 'thorough_sleep'
     end || Object <- AllObject, Object/=[]],
    ok.

















