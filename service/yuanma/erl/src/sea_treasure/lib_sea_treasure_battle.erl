%%-----------------------------------------------------------------------------
%% @Module  :       lib_sea_treasure_battle.erl
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2020/6/30
%% @Description:    璀璨之海战斗
%%-----------------------------------------------------------------------------

-module(lib_sea_treasure_battle).
-include("battle_field.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("sea_treasure.hrl").
-include("figure.hrl").

%% 行为接口
-export([
    %% 战场进程
    init/2
    , player_enter/3
    , player_quit/3
    , player_logout/3
    , player_disconnect/3
    , player_finish_change_scene/3
    , player_die/3
    , player_revive/3
    , player_reconnect/3
    %% 玩家进程
    , evt_out_of_battle/2
    % % ,mon_hp_change/3
    , mon_die/3
    , terminate/2
]).

%% 其它接口
-export([
    fake_man_die_handler/5
    , battle_time_out/2
    , create_dummy/2
    , enter_battle_field/2
    , enter_battle_field/7
    , enter_battle_field_with_fake/14
    , dummy_start_battle/2
    , adjudge_battle/2
    , battle_start/2
    , get_scene_obj_hp/3
    , late_force_end/2 
    , stop_all/1
    , stop_process/2
    , role_request_out/1
    , role_request_out/2
    , role_request_out_do/2
]).
    
%% ShippingType 船只档次
%% SeaTreasureMod 本服/2/4/8服模式
%% BackTimes 复仇挑战次数
init(State, [BeHelperId, AutoId, ShippingType, SeaTreasureMod, BatType, BackTimes, RoleA, RoleB, SceneId, ScenePoolId]) ->
    {role, RoleId, SerId, BGoldNum} = RoleA, %% BGoldNum 协助获得绑钻数量
    {enemy, EnemyRoleId, EnemySerId, EnemySerNum, FakePower, 
        FakeLv, FakeName, FakeWlv, FakeGuildId, FakeGuildName, Career, Sex, Turn
    } = RoleB,
    PosList = ?born_point_list,
    [{X1, Y1}, {X2, Y2}|_] = ?IF(urand:rand(1,2) == 1, PosList, lists:reverse(PosList)),
    % ScenePoolId = EnemyRoleId,
    CopyId = RoleId,
    RoleMap = #{
        RoleId => #battle_role{key = RoleId, in_info = #{x => X1, y => Y1}, data = #{server_id => SerId, bgold_num => BGoldNum}}
    },
    Data = #{
        shipping_type => ShippingType, help_id => RoleId, be_help_id => BeHelperId, stop_ref => undefined,
        auto_id => AutoId, battle_type => BatType, enemy_guild => {FakeGuildId, FakeGuildName}
    },
    NewState = State#battle_state{
        cur_scene = SceneId, scene_pool_id = ScenePoolId, 
        copy_id = CopyId, roles = RoleMap, data = Data
    },
    if
        EnemyRoleId == 0 ->
            lib_sea_treasure:player_apply_cast_from_center(SeaTreasureMod, SerId, RoleId, 
                ?MODULE, enter_battle_field_with_fake, [State#battle_state.self, EnemySerId, EnemySerNum, 
                EnemyRoleId, FakeWlv, X2, Y2, FakePower, FakeLv, FakeName, Career, Sex, Turn]);
        true ->
            lib_sea_treasure:player_apply_cast_from_center(SeaTreasureMod, SerId, RoleId, 
                ?MODULE, enter_battle_field, [State#battle_state.self]),
            lib_sea_treasure:player_apply_cast_from_center(SeaTreasureMod, EnemySerId, EnemyRoleId, 
                ?MODULE, enter_battle_field, [State#battle_state.self, BackTimes, X2, Y2, SerId, RoleId])
    end,
    {ok, NewState};
init(State, _E) -> {ok, State}.

enter_battle_field(Player, BattlePid) ->
    #player_status{
        id                    = RoleId,
        battle_attr           = #battle_attr{hp = Hp, hp_lim = HpLim},
        scene                 = OSceneId,
        scene_pool_id         = OPoolId,
        copy_id               = OCopyId,
        x                     = X,
        y                     = Y
    } = Player,
    % {ok, BinData} = pt_189:write(18906, [1, utime:unixtime()]),
    % lib_server_send:send_to_sid(Sid, BinData),
    Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim],
    mod_battle_field:player_enter(BattlePid, RoleId, Args),
    {ok, Player}.

enter_battle_field(Player, BattlePid, BackTimes, X, Y, AttrSerId, AtterRoleId) ->
    #player_status{
        id                    = RoleId,
        battle_attr           = BattleAttr,
        figure                = #figure{picture = Picture} = Figure,
        server_num            = SerNum,
        combat_power          = Power,
        server_id             = SerId
    } = Player,
    DummyFigure = lib_sea_treasure:convert_figure(Figure),
    SkillList = lib_sea_treasure:get_skill_list(Player),
    NewBattleAttr = lib_sea_treasure:calc_battle_attr(BattleAttr, BackTimes),
    FakeInfo = lib_sea_treasure:get_fake_info_for_client(SerId, SerNum, DummyFigure, RoleId, Power, Picture),
    % ?PRINT("=============== :~p~n",[NewBattleAttr]),
    mod_battle_field:apply_cast(BattlePid, ?MODULE, create_dummy, [DummyFigure, NewBattleAttr, SkillList, X, Y, FakeInfo, Power, AtterRoleId, AttrSerId]),
    {ok, Player}.

enter_battle_field_with_fake(Player, BattlePid, FakeSerId, FakeSerNum, FakeId, Wlv, X, Y, Power, Lv, Name, Career, Sex, Turn) ->
    {Figure, SkillList, BattleAttr} = lib_sea_treasure:get_fake_man_figure(Wlv, Power, Lv, Name, Career, Sex, Turn),
    FakeInfo = lib_sea_treasure:get_fake_info_for_client(FakeSerId, FakeSerNum, Figure, FakeId, Power, <<"">>),
    #player_status{id = RoleId, server_id = SerId} = Player,
    mod_battle_field:apply_cast(BattlePid, ?MODULE, create_dummy, [Figure, BattleAttr, SkillList, X, Y, FakeInfo, Power, RoleId, SerId]),
    enter_battle_field(Player, BattlePid).

create_dummy(State, [Figure, BattleAttr, SkillList, X, Y, FakeInfo, FakePower, AtterRoleId, AttrSerId]) ->
    ?PRINT("FakePower:~p~n",[FakePower]),
    lib_sea_treasure:apply_cast(AttrSerId, lib_sea_treasure, send_stage_time, [AtterRoleId, 0, utime:unixtime(), FakePower]),
    if
        State#battle_state.is_end =:= false ->
            #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, data = StateData} = State,
                MyArgs = [
                    {figure, Figure}, {battle_attr, BattleAttr}, {skill, SkillList}, 
                    {die_handler, {?MODULE, fake_man_die_handler, [State#battle_state.self]}}, 
                    {group, 1}, {warning_range, 5000}
                ],
                MonId = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, 
                    ScenePoolId, X, Y, 1, CopyId, 1, MyArgs),
                State#battle_state{roles = RoleMap, data = StateData#{fake_id => MonId, fake_info => FakeInfo}};
        true ->
            % ?PRINT("=============== ~n",[]),
            ok
    end.

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
            {ok, Role, State}
    end.

player_disconnect(Role, Args, State) ->
    player_logout(Role, Args, State).

%% 掉线算输
player_logout(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    % ?PRINT("player_logout res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, self = Self, data = Data} = State,
    NewRoleMap
    = maps:map(fun
        (_K, #battle_role{data = D} = R) ->
            R#battle_role{data = D#{res => 0}}   %%己方失败
    end, RoleMap),

    Id = maps:get(fake_id, Data, 0), 
    HelperId = maps:get(help_id, Data, 0),
    lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),

    NewRole = maps:get(RoleKey, NewRoleMap),
    {ok, NewRole, State#battle_state{roles = NewRoleMap}};

player_logout(_Role, _Args, _State) ->
    skip.

player_die(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    % ?PRINT("player_die res = ~p~n", [ok]),
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, roles = RoleMap, data = Data, self = Self} = State,
    NewRoleMap
    = maps:map(fun
        (_K, #battle_role{data = D} = R) ->
            R#battle_role{data = D#{res => 0}}
    end, RoleMap),

    Id = maps:get(fake_id, Data, 0), 
    HelperId = maps:get(help_id, Data, 0),
    lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),

    NewRole = maps:get(RoleKey, NewRoleMap),
    #battle_role{out_info = #{hp := Hp} = OutInfo} = NewRole,
    SceneAttr = maps:get(scene_args, OutInfo, []),
    ReviveSceneAttr
    = case lists:keyfind(change_scene_hp, 1, SceneAttr) of
        false->
            [{change_scene_hp, Hp}|SceneAttr];
        _ ->
            SceneAttr
    end,
    {ok, State#battle_state{roles = NewRoleMap#{RoleKey => NewRole#battle_role{out_info = OutInfo#{scene_args => ReviveSceneAttr}}}}};

player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.

player_reconnect(#battle_role{key = RoleId, data = RoleData}, _, #battle_state{data = #{battle_end_time := BattleEndTime}}) ->
    SerId = maps:get(server_id, RoleData, 0),
    lib_sea_treasure:apply_cast(SerId, lib_sea_treasure, send_stage_time, [RoleId, 2, BattleEndTime]),
    skip;

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
            BeforeStartTime = ?before_start_time,
            BatleTime = ?rob_time,
            BattleStartTime = utime:unixtime() + BeforeStartTime,
            lists:map(fun
                ({RoleId, #battle_role{data = RoleData}}) ->
                    SerId = maps:get(server_id, RoleData, 0),
                    lib_sea_treasure:apply_cast(SerId, lib_sea_treasure, send_stage_time, [RoleId, 1, BattleStartTime])
            end, RoleList),
            erlang:send_after(BeforeStartTime * 1000, Self, {apply, ?MODULE, battle_start, [BattleStartTime + BatleTime]}),
            erlang:send_after((BeforeStartTime + BatleTime) * 1000, Self, {apply, ?MODULE, battle_time_out, []}),
            case maps:get(fake_id, Data, 0) of
                DummyId when is_integer(DummyId) andalso DummyId =/= 0 ->
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
    #battle_state{roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, self = Self, data = Data} = State,
    NewRoleMap = maps:map(fun
        (_, #battle_role{data = D} = R) ->
            R#battle_role{data = D#{res => 1}}
    end, RoleMap),

    Id = maps:get(fake_id, Data, 0), 
    HelperId = maps:get(help_id, Data, 0),
    lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),

    {ok, State#battle_state{roles = NewRoleMap}};

mon_die(_, _, _) -> ok.

terminate(_Reason, State) ->
    #battle_state{
        cur_scene = SceneId, scene_pool_id = ScenePoolId, 
        copy_id = CopyId, roles = RoleMap, data = Data
    } = State,
    #{
        help_id := HelperId, be_help_id := BeHelperId, 
        auto_id := AutoId, battle_type := BatType
    } = Data,
    %% 这个未必初始化成功，单独处理
    FakeInfo = maps:get(fake_info, Data, #{}),
    if
        BatType == ?BATTLE_TYPE_ROBER ->
            FakeSerId = maps:get(server_id, FakeInfo, 0),
            RoleList = maps:to_list(RoleMap), 
            % ?PRINT("RoleList:~p~n",[RoleList]),
            [begin
                lib_sea_treasure:apply_cast(SerId, lib_sea_treasure, do_after_terminate, [RoleId, FakeSerId, AutoId])
            end || {RoleId, #battle_role{data = #{res := Res, server_id := SerId}}} <- RoleList, Res =:= 0],
            lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId);
        true ->
            lib_scene:clear_scene(SceneId, ScenePoolId)
    end,
    lib_sea_treasure:notfied_delete_pid(BeHelperId, BatType, HelperId).

battle_start(#battle_state{roles = RoleMap, data = Data} = State, [BattleEndTime]) ->
    RoleList = maps:to_list(RoleMap),
    lists:map(fun
                ({RoleId, #battle_role{data = RoleData}}) ->
                    SerId = maps:get(server_id, RoleData, 0),
                    lib_sea_treasure:apply_cast(SerId, lib_sea_treasure, send_stage_time, [RoleId, 2, BattleEndTime])
            end, RoleList),
    State#battle_state{data = Data#{battle_end_time => BattleEndTime}}.

late_force_end(#battle_state{roles = RoleMap, data = StateData} = State, RoleId) ->
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, self = Self, data = Data} = State,
    case StateData of
        #{late_force_end := false} ->
            skip;
        _ ->
            NewRoleMap = maps:map(fun
                (_, #battle_role{data = RData} = Role) ->
                    Role#battle_role{data = RData#{res => 0}}
            end, RoleMap),
            pp_sea_treasure:send_error(RoleId, ?ERRCODE(err281_enemy_is_late), 18920),
            Id = maps:get(fake_id, Data, 0), 
            HelperId = maps:get(help_id, Data, 0),
            lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),

            State#battle_state{roles = NewRoleMap}
    end.


battle_time_out(#battle_state{is_end = false} = State, []) ->
    % ?PRINT("battle_time_out res = ~p~n", [ok]),
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, roles = RoleMap, self = Self, data = Data} = State,
    NewRoleMap = maps:map(fun
        (_Key, #battle_role{data = D} = R) ->
            R#battle_role{data = D#{res => 0}}
    end, RoleMap),
    Id = maps:get(fake_id, Data, 0), 
    HelperId = maps:get(help_id, Data, 0),
    lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),
    State#battle_state{roles = NewRoleMap};

battle_time_out(_State, _) -> ok.

get_scene_obj_hp(ReqPid, Id, HelperId) ->
    {MHp, MHpLimit} = 
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{battle_attr = #battle_attr{hp = Hp1, hp_lim = HpLimit1}} ->
            {Hp1, HpLimit1};
        _ ->
            {1, 1}
    end,
    {RHp, RHpLimit} = 
    case lib_scene_agent:get_user(HelperId) of
        #ets_scene_user{battle_attr = #battle_attr{hp = Hp2, hp_lim = HpLimit2}} ->
            {Hp2, HpLimit2};
        _ ->
            {1, 1}
    end,
    mod_battle_field:apply_cast(ReqPid, ?MODULE, adjudge_battle, {MHp, MHpLimit, RHp, RHpLimit}).

dummy_start_battle(Id, Time) ->
    case lib_scene_object_agent:get_object(Id) of
        #scene_object{aid = Aid} ->
            Aid ! {'change_attr', [{find_target, Time*1000}]};
        _ ->
            skip
    end.

adjudge_battle(#battle_state{is_end = false} = State, {MHp, MHpLimit, RHp, RHpLimit}) ->
    #battle_state{data = D} = State,
    MHpPer = erlang:round(MHp / MHpLimit * 100),
    RHpPer = erlang:round(RHp / RHpLimit * 100),
    Data = D#{fake_hp_per => MHpPer, helper_hp_per => RHpPer},
    handle_result(State#battle_state{data = Data});

adjudge_battle(_, _) ->
    ok.



handle_result(#battle_state{roles = RoleMap, self = Self, data = Data, is_end = IsEnd} = State) ->
    RoleList = maps:to_list(RoleMap), 
    QuitTime = utime:unixtime() + 8,
    #{
        shipping_type := ShippingType, be_help_id := BeHelperId, fake_hp_per := MHpPer, 
        helper_hp_per := RHpPer, auto_id := AutoId, battle_type := BatType, 
        enemy_guild := {FakeGuildId, FakeGuildName}, stop_ref := Oldref
    } = Data,
    FakeInfo = calc_enemy_info(Data, MHpPer),
    % ?PRINT("============ EnemySerNum:~p~n",[maps:get(fake_info, Data, [])]),
    BattleArgs = #battle_field_args{
        be_help_id = BeHelperId, shipping_type = ShippingType, 
        auto_id = AutoId, battle_type = BatType, role_hp_per = RHpPer, 
        fake_guild = {FakeGuildId, FakeGuildName},
        quit_time = QuitTime, fake_info = FakeInfo
    },
    [begin
        if
            BatType =/= ?BATTLE_TYPE_ROBER andalso MHpPer == 0 -> %% 怪物没血了都算成功，防止同归于尽导致复仇失败
                NewRes = 1;
            true ->
                NewRes = Res
        end,
        lib_sea_treasure:apply_cast(SerId, lib_sea_treasure, calc_battle_result, [RoleId, BGoldNum, NewRes, BattleArgs])
     end || {RoleId, #battle_role{data = #{res := Res, server_id := SerId, bgold_num := BGoldNum}}} <- RoleList],
    % mod_battle_field:stop(Self),
    util:cancel_timer(Oldref),
    case maps:get(stop_time, Data, []) of
        [] when IsEnd == false -> 
            StopRef = erlang:send_after(15000, Self, stop); %%15s后停止进程
        _ ->
            StopRef = undefined,
            mod_battle_field:stop(Self) %% 协议退出立即关闭进程
    end,
    % 强制清除场景对象
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId),
    State#battle_state{is_end = true, data = Data#{stop_ref => StopRef}}.

evt_out_of_battle(Player, _Reason) ->
    lib_player:break_action_lock(Player, ?ERRCODE(err189_on_sea_treasure_scene)).


%% 计算敌人信息
calc_enemy_info(Data, MHpPer) ->
    case maps:get(fake_info, Data, []) of
        #{role_id := RoleId, role_name := Name, server_id := SerId, server_num := SerNum, power := Power,
        sex := Sex, career := Career, pic := Picture, pic_ver := PictureVer, turn := Turn} ->
            #fake_info{
                ser_id = SerId, ser_num = SerNum, turn = Turn,
                role_id = RoleId, role_name = Name,
                power = Power, sex = Sex, hp_per = MHpPer,
                career = Career, pic = Picture, pic_ver = PictureVer
            };
        _ -> 
            ?ERR("ERROR CREATE Dummy FAIL! Data:~p~n", [Data]),
            #fake_info{}
    end.

fake_man_die_handler(#scene_object{id = Id}, _Klist, _Atter, _AtterSign, [BattleFieldPid]) ->
    mod_battle_field:mon_die(BattleFieldPid, Id, []).

stop_all(PidList) ->
    [mod_battle_field:apply_cast(Pid, ?MODULE, stop_process, _RoleId)|| {_RoleId, Pid} <- PidList],
    ok.

stop_process(State, _RoleId) ->
    #battle_state{self = Self, roles = RoleMap} = State,
    RoleList = maps:to_list(RoleMap),
    lists:map(fun
                ({RId, #battle_role{data = RoleData}}) ->
                    SerId = maps:get(server_id, RoleData, 0),
                    %% 通知玩家协助成功
                    lib_sea_treasure:apply_cast(SerId, pp_sea_treasure, send_error, [RId, 1, 18912])
            end, RoleList),
    % erlang:send_after(1000, Self, stop), %%1s后停止进程
    mod_battle_field:stop(Self),
    State#battle_state{is_end = true}.

role_request_out(RoleId, Pid) ->
    mod_battle_field:apply_cast(Pid, ?MODULE, role_request_out_do, RoleId),
    ok.

role_request_out_do(State, _RoleId) ->
    #battle_state{
        cur_scene = SceneId, scene_pool_id = ScenePoolId, 
        roles = RoleMap, self = Self, data = Data, is_end = IsEnd
    } = State,
    NewRoleMap = maps:map(fun
        (_Key, #battle_role{} = R) ->
            R#battle_role{state = ?ROLE_STATE_OUT}
    end, RoleMap),
    if
        IsEnd == true ->
            Oldref = maps:get(stop_ref, Data, undefined), 
            util:cancel_timer(Oldref),
            mod_battle_field:stop(Self), %% 协议退出立即关闭进程
            State#battle_state{roles = NewRoleMap};
        true ->
            Id = maps:get(fake_id, Data, 0), 
            HelperId = maps:get(help_id, Data, 0),
            lib_scene_agent:thorough_sleep(SceneId, ScenePoolId, Id),
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id, HelperId]),
            State#battle_state{roles = NewRoleMap, data = Data#{stop_time => 0}}
    end.

%% 玩家主动退出  
role_request_out(Player) ->
    lib_battle_field:remove_listener_in_ps(),
    TmpPlayer = lib_player:break_action_lock(Player, ?ERRCODE(err189_on_sea_treasure_scene)),
    NewPS = lib_scene:change_scene(TmpPlayer, 0, 0, 0, 0, 0, false, [{group, 0}, {ghost, 0}, 
        {change_scene_hp_lim, 100}, {pk, {?PK_PEACE, true}}]),
    {ok, NewPS#player_status{battle_field = undefined, sea_treasure_pid = undefined}}.