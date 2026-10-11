%% ---------------------------------------------------------------------------
%% @doc lib_mon_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-08-21
%% @deprecated 怪物进程
%% ---------------------------------------------------------------------------
-module(lib_mon_mod).

-export([
      find_target/6                             %% 尝试寻找目标
    , find_target_cast/1                        %% 寻找目标
    , player_die/8                              %% 玩家死亡
    , battle_to_clear_bl_who_die_ref/3          %% 战斗即清理死亡定时器
    , bl_who_die_ref/3                          %% 归属玩家死亡定时器
    , rob_mon_bl/4                              %% 抢夺怪物的归属
    , rob_mon_bl_success/6                      %% 成功抢夺
    , get_mon_own_info/1                        %% 获得怪物归属信息
    , is_need_hurt_notice/3                     %% 是否需要伤害通知
]).

%% 处理函数
-export([
      born_handler/1
    , revive_handler/1
    , collect_handler/6
    , hp_change_handler/3
    , die_handler/4
]).

-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("drop.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

%% =============================
%% 尝试寻找目标
find_target(Mon, Scene, ScenePoolId, CopyId, Xpx, Ypx) ->
    case Mon#scene_object.type == 1 of
        true  ->
            lib_scene_object:put_ai(Mon#scene_object.aid, Scene, ScenePoolId, CopyId, Xpx, Ypx, Mon#scene_object.warning_range),
            erlang:send_after(50, self(), 'find_target');
        false ->
            skip
    end.

%% =============================
%% 寻找目标
find_target_cast(Object) ->
    #scene_object{
        aid = Aid, scene = SceneId, scene_pool_id = ScenePoolId,
        copy_id = CopyId, x=ObjectX, y=ObjectY,
        warning_range=WarningRange
    } = Object,
    % Args = {BA#battle_attr.group, ObjectSign, ObjectId, OwnerSign, OwnerId, MonKind},
    Args = lib_scene_calc:make_scene_calc_args(Object),
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
        [Aid, CopyId, ObjectX, ObjectY, WarningRange, Args, undefined]).

%% =============================
%% 玩家死亡
% (1)被非玩家打死
player_die(State, StateName, RoleId, undefined, _SceneBossTired, _VipType, _VipLv, _IsHurtMon) ->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_die_ref = BlWhoDieRefL} = State,
    #scene_object{mon = Mon, scene = Scene} = Object,
    % ?PRINT("bl_who_die_ref_help BlWhoDieRefL:~p ~n", [BlWhoDieRefL]),
    case Object#scene_object.type == 1 of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            IsDecorNorBossScene = lib_decoration_boss_api:is_normal_boss_scene(Scene),
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
            if
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, State};
                % 立刻清理归属:目前暂时只处理幻饰boss,后续看看怎么调整
                BlType == ?DROP_FIRST_ATT andalso IsDecorNorBossScene ->
                    bl_who_die_ref(State, StateName, RoleId);
                % 保留一定时间的归属
                true ->
                    case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false -> NewBlWhoDieRefL = BlWhoDieRefL;
                        _ ->
                            case lists:keyfind(RoleId, 1, BlWhoDieRefL) of
                                {RoleId, OldDieRef} -> ok;
                                _ -> OldDieRef = []
                            end,
                            DieRef = lib_scene_object:send_event_after(OldDieRef, 10*1000, {'bl_who_die_ref', RoleId}),
                            NewBlWhoDieRefL = lists:keystore(RoleId, 1, BlWhoDieRefL, {RoleId, DieRef})
                    end,
                    NewState = State#ob_act{bl_who_die_ref = NewBlWhoDieRefL},
                    {next_state, StateName, NewState}
            end;
        false ->
            {next_state, sleep, State}
    end;
%% =============================
% (2)被玩家打死##只能抢夺首次攻击的归属
player_die(State, StateName, RoleId, #mon_atter{id = AtterId, assist_id = AssistId} = MonAtter, SceneBossTired, VipType, VipLv, IsHurtMon) ->
    % ?MYLOG("hjhbl111", "player_die RoleId:~p AtterId:~p ~n", [RoleId, AtterId]),
    #ob_act{object=Object, bl_who = BLWhos, bl_who_ref = BLWhosRef, klist = KList, ref = Ref, first_att = FirstAttr,
        assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My, assist_ids = AssistIds} = Object,
    case Object#scene_object.type == 1 of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            IsBossMiss = lib_battle_util:check_boss_missing(Scene, Mon#scene_mon.mid, SceneBossTired, VipType, VipLv, [AssistId, AssistIds]),
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
            IsDecorNorBossScene = lib_decoration_boss_api:is_normal_boss_scene(Scene),
            % ?MYLOG("hjhbl111", "player_die RoleId:~p AtterId:~p ~n", [RoleId, AtterId]),
            if
                BLWhos == [] orelse not DropBoss ->
                    {next_state, StateName, State};
                % 同一个玩家
                RoleId == AtterId ->
                    {next_state, StateName, State};
                FirstAttr == [] ->
                    {next_state, StateName, State};
                % 被击杀者没有归属，无法抢夺
                FirstAttr#mon_atter.id =/= RoleId ->
                    {next_state, StateName, State};
                % 只有首次攻击,才能抢夺对应的归属
                BlType =/= ?DROP_FIRST_ATT ->
                    {next_state, StateName, State};
                % 只有部分场景有效抢夺归属:目前暂时只处理幻饰boss,后续看看怎么调整
                not IsDecorNorBossScene ->
                    {next_state, StateName, State};
                true ->
                    NewKList = lists:keydelete(RoleId, #mon_atter.id, KList),
                    % 策划要求幻饰Boss场景下打死归属者就获得归属
                    NewFirstAttr = case IsDecorNorBossScene of
                        true -> MonAtter;
                        _ ->
                            ?IF(IsBossMiss orelse IsHurtMon == 0, [], MonAtter)
                    end,
                    % 清理归属
                    OldBlWhos = case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of
                        false -> BLWhos;
                        _ -> lists:keydelete(RoleId, #mon_atter.id, BLWhos)
                    end,
                    % 清理归属检查定时器
                    NewBLWhosRef = case lists:keyfind(RoleId, 1, BLWhosRef) of
                        false -> BLWhosRef;
                        {RoleId, BlWhoRef} ->
                            util:cancel_timer(BlWhoRef),
                            lists:keydelete(RoleId, 1, BLWhosRef)
                    end,
                    %% 重新计算Boss归属
                    {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBlWhos, NewKList, NewFirstAttr, AssistDataList),
                    NewDels = case lists:keyfind(RoleId, #mon_atter.id, BLWhos) of false -> Dels; E -> [E|Dels] end,
                    % ?MYLOG("hjhbl111", "player_die Adds:~p Dels:~p, NewBLWhos:~p NewDels:~p ~n", [Adds, Dels, NewBLWhos, NewDels]),
                    lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, NewDels),
                    {AddsAssist, DelsAssist, NewBlWhosAssist} =
                        lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
                    lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                    Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                    find_target_cast(Object),
                    {next_state, StateName, State#ob_act{ref = Ref1, bl_who_ref = NewBLWhosRef,
                        bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist}}
            end;
        false ->
            {next_state, sleep, State}
    end;

player_die(State, StateName, _RoleId, _MonAtter, _SceneBossTired, _VipType, _VipLv, _IsHurtMon) ->
    ?ERR("_MonAtter:~p ~n", [_MonAtter]),
    {next_state, StateName, State}.

%% =============================
%% 战斗即清理死亡定时器
battle_to_clear_bl_who_die_ref(State, AtterSign, RoleId) ->
    #ob_act{bl_who_die_ref = BlWhoDieRefL} = State,
    F = fun({TmpRoleId, DieRef}, TmpState) ->
        util:cancel_timer(DieRef),
        case TmpRoleId == RoleId andalso AtterSign == ?BATTLE_SIGN_PLAYER of
            true -> TmpState;
            false -> bl_who_die_ref_help(TmpState, TmpRoleId)
        end
    end,
    % ?PRINT("bl_who_die_ref_help BlWhoDieRefL:~p ~n", [BlWhoDieRefL]),
    NewState = lists:foldl(F, State, BlWhoDieRefL),
    NewState#ob_act{bl_who_die_ref = []}.

%% =============================
%% 归属玩家死亡定时器
bl_who_die_ref(State, StateName, RoleId) ->
    NewState = bl_who_die_ref_help(State, RoleId),
    {next_state, StateName, NewState}.

bl_who_die_ref_help(State, RoleId) ->
    #ob_act{
        object=Object, bl_who = BLWhos, bl_who_ref = BLWhosRef, bl_who_die_ref = BlWhoDieRefL, klist = KList,
        first_att = FirstAttr, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id=ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    E = lists:keyfind(RoleId, #mon_atter.id, BLWhos),
    case lists:keyfind(RoleId, 1, BlWhoDieRefL) of
        false -> NewBlWhoDieRefL = BlWhoDieRefL;
        {RoleId, DieRef} ->
            util:cancel_timer(DieRef),
            NewBlWhoDieRefL = lists:keydelete(RoleId, 1, BlWhoDieRefL)
    end,
    % ?PRINT("bl_who_die_ref_help RoleId:~p ~n", [RoleId]),
    DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
    if
        BLWhos == [] orelse not DropBoss-> State#ob_act{bl_who_die_ref = NewBlWhoDieRefL};
        E == false -> State#ob_act{bl_who_die_ref = NewBlWhoDieRefL};
        true ->
            NewKList = lists:keydelete(RoleId, #mon_atter.id, KList),
            lib_mon_event:hurt_remove(Object, KList, NewKList, [RoleId]),
            NewFirstAttr = case FirstAttr of
                [] -> [];
                _ -> ?IF(FirstAttr#mon_atter.id == RoleId, [], FirstAttr)
            end,
            OldBlWhos = lists:keydelete(RoleId, #mon_atter.id, BLWhos),
            NewBLWhosRef = case lists:keyfind(RoleId, 1, BLWhosRef) of
                false -> BLWhosRef;
                {RoleId, BlWhoRef} ->
                    util:cancel_timer(BlWhoRef),
                    lists:keydelete(RoleId, 1, BLWhosRef)
            end,
            %% 重新计算Boss归属
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
            {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mon#scene_mon.mid, BlType, OldBlWhos, NewKList, NewFirstAttr, AssistDataList),
            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, [E|Dels]),
            {AddsAssist, DelsAssist, NewBlWhosAssist} =
                lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, NewKList, AssistDataList),
            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
            lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
            State#ob_act{bl_who_ref = NewBLWhosRef,
                bl_who = NewBLWhos, klist = NewKList, first_att = NewFirstAttr, bl_who_die_ref = NewBlWhoDieRefL, bl_who_assist = NewBlWhosAssist}
    end.

%% 抢夺怪物的归属
rob_mon_bl(State, StateName, Node, RoleId) ->
    #ob_act{object=Object, first_att=FirstAttr} = State,
    #scene_object{id = MonId, mon = Mon, scene = Scene, scene_pool_id = PoolId} = Object,
    case Object#scene_object.type == 1 of
        true ->
            DropBoss = ?IS_DROP_BOSS(Mon#scene_mon.boss),
            BlType = lib_mon_util:get_boss_drop_bltype(Mon#scene_mon.mid, Object#scene_object.figure#figure.lv),
            if
                not DropBoss -> ErrCode = ?ERRCODE(err200_not_rob_this_mon_bl);
                BlType == skip -> ErrCode = ?ERRCODE(err200_not_rob_this_mon_bl);
                FirstAttr == [] -> ErrCode = ?ERRCODE(err200_this_mon_not_bl_to_rob);
                % 不能抢夺自己
                FirstAttr#mon_atter.id == RoleId -> ErrCode = ?ERRCODE(err200_not_rob_my_mon_bl);
                true ->
                    mod_scene_agent:apply_cast(Scene, PoolId, lib_battle, rob_mon_bl_battle, [Node, RoleId, MonId, FirstAttr#mon_atter.id]),
                    ErrCode = ?SUCCESS
            end,
            case ErrCode == ?SUCCESS of
                true -> skip;
                false ->
                    {ok, BinData} = pt_200:write(20020, [ErrCode, MonId]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData)
            end;
        false ->
            skip
    end,
    {next_state, StateName, State}.

%% 成功抢夺
rob_mon_bl_success(State, StateName, #mon_atter{id = RoleId, node = Node} = MonAtter, RobbedId, WinCode, WinHp) ->
    #ob_act{object=Object, bl_who = BLWhos, bl_who_ref = BLWhosRef, klist = KList, ref = Ref, assist_list = AssistDataList, bl_who_assist = OldBlWhosAssist} = State,
    #scene_object{id = ObjectId, mon = Mon, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, x = Mx, y = My} = Object,
    #scene_mon{mid = Mid} = Mon,
    case Object#scene_object.type == 1 of
        true ->
            case check_rob_mon_bl_success(State, MonAtter, RobbedId) of
                {false, ErrCode} -> NewState = State;
                true ->
                    case WinCode of
                        1 ->
                            ErrCode = ?SUCCESS,
                            NewFirstAttr = MonAtter,
                            OldBlWhos = case lists:keyfind(RobbedId, #mon_atter.id, BLWhos) of
                                false -> BLWhos;
                                _ -> lists:keydelete(RobbedId, #mon_atter.id, BLWhos)
                            end,
                            NewBLWhosRef = case lists:keyfind(RobbedId, 1, BLWhosRef) of
                                false -> BLWhosRef;
                                {RobbedId, BlWhoRef} ->
                                    util:cancel_timer(BlWhoRef),
                                    lists:keydelete(RobbedId, 1, BLWhosRef)
                            end,
                            % KList1 =
                            %% 重新计算Boss归属
                            BlType = lib_mon_util:get_boss_drop_bltype(Mid, Object#scene_object.figure#figure.lv),
                            {Adds, Dels, NewBLWhos} = lib_mon_util:calc_boss_bl_who(Scene, Mid, BlType, OldBlWhos, KList, NewFirstAttr, AssistDataList),
                            NewDels = case lists:keyfind(RobbedId, #mon_atter.id, BLWhos) of false -> Dels; E -> [E|Dels] end,
                            lib_mon_util:update_boss_bl_whos(ObjectId, Scene, PoolId, CopyId, Mx, My, Adds, NewDels),
                            {AddsAssist, DelsAssist, NewBlWhosAssist} =
                                lib_mon_util:calc_boss_bl_who_assist(OldBlWhosAssist, NewBLWhos, KList, AssistDataList),
                            lib_mon_util:update_boss_bl_whos_assist(ObjectId, Scene, PoolId, CopyId, Mx, My, AddsAssist, DelsAssist),
                            lib_mon_util:sync_team_boss_bl_whos(BlType, NewBLWhos, Object),
                            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                            NewState = State#ob_act{ref = Ref1, bl_who_ref = NewBLWhosRef,
                                bl_who = NewBLWhos, klist = KList, first_att = NewFirstAttr, bl_who_assist = NewBlWhosAssist};
                        _ ->
                            ErrCode = ?ERRCODE(err200_rob_mon_bl_fail),
                            NewState = State
                    end,
                    mod_scene_agent:apply_cast_with_state(Scene, PoolId, lib_battle, handle_hp_af_rob_mon_bl, [RoleId, RobbedId, WinCode, WinHp, Mid])
            end,
            {ok, BinData} = pt_200:write(20020, [ErrCode, ObjectId]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            case ErrCode == ?SUCCESS of
                true ->
                    Info = get_mon_own_info(NewState),
                    {ok, BinData2} = pt_200:write(20021, Info),
                    lib_server_send:send_to_scene(Scene, PoolId, BinData2);
                false ->
                    skip
            end,
            {next_state, StateName, NewState};
        false ->
            {next_state, sleep, State}
    end.

check_rob_mon_bl_success(State, MonAtter, RobbedId) ->
    #ob_act{bl_who = BLWhos, first_att = FirstAttr} = State,
    if
        BLWhos == [] ->
            {false, ?ERRCODE(err200_not_rob_this_mon_bl)};
        FirstAttr == [] ->
           {false, ?ERRCODE(err200_this_mon_not_bl_to_rob)};
        FirstAttr#mon_atter.id =/= RobbedId ->
            {false, ?ERRCODE(err200_robbed_not_mon_bl)};
        MonAtter#mon_atter.id == FirstAttr#mon_atter.id ->
            {false, ?ERRCODE(err200_not_rob_my_mon_bl)};
        true ->
            true
    end.

%% 获得怪物归属信息
get_mon_own_info(State) ->
    #ob_act{object = Object, first_att = FirstAttr} = State,
    #scene_object{id = MonId} = Object,
    case FirstAttr of
        #mon_atter{id = FirstId} -> ok;
        _ -> FirstId = 0
    end,
    [MonId, FirstId].

%% 是否需要伤害通知
%% 注意:如果场景有其他怪不需要广播,就要根据怪物id等类型做判断
%% @param ConfigId 配置id
is_need_hurt_notice(SceneId, ConfigId, Boss) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when
                Type == ?SCENE_TYPE_FORBIDDEB_BOSS;
                Type == ?SCENE_TYPE_ABYSS_BOSS;
                Type == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
                Type == ?SCENE_TYPE_WORLD_BOSS_PER;
                Type == ?SCENE_TYPE_SPECIAL_BOSS;
                Type == ?SCENE_TYPE_SANCTUARY;
                Type == ?SCENE_TYPE_KF_SANCTUARY ;
                Type == ?SCENE_TYPE_DOMAIN_BOSS;
                Type == ?SCENE_TYPE_NIGHT_GHOST;
                Type == ?SCENE_TYPE_GUILD_FEAST;
                Type == ?SCENE_TYPE_KF_GREAT_DEMON ->
            true;
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
            DropBoss = ?IS_DROP_BOSS(Boss),
            if
                DropBoss == true ->
                    true;
                true ->
                    false
            end;
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_DUNGEON ->
            case lib_week_dungeon:is_week_dun_boss(ConfigId) of
                true -> true;
                _ ->
                    false
            end;
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_EUDEMONS_BOSS ->
            case data_eudemons_land:get_eudemons_boss_cfg(ConfigId) of
                [] -> false;
                _ -> true
            end;
        _ ->
            false
    end.

%% ================================================ Handler ================================================%%
%% 出生处理器
born_handler(State) ->
    #ob_act{born_handler = BornHandler, object = Object} = State,
    case BornHandler of
        {BornM, BornF, BornA} ->
            BornM:BornF(init, Object, BornA);
        _ -> ok
    end.

%% 复活处理
revive_handler(State) ->
    #ob_act{born_handler = BornHandler, object = Object} = State,
    case BornHandler of
        {BornM, BornF, BornA} ->
            BornM:BornF(revive, Object, BornA);
        _ ->
            ok
    end.

%% 采集处理器
collect_handler(State, CollectorNode, CollectorId, ServerId, CollectorName, FirstAttr) ->
    #ob_act{collected_handler = CollectHandler, object = Object} = State,
    case CollectHandler of
        {CM, CF, CA} ->
            CM:CF(Object, CollectorId, CA);
        _ ->
            lib_mon_event:be_collected(Object, CollectorNode, CollectorId, ServerId, CollectorName, FirstAttr)
    end.

%% 血量改变处理器
%% @return NewHpChangeHandler
hp_change_handler(State, Hp, NewKList) ->
    #ob_act{hp_change_handler = HpChangeHandler, object = Object} = State,
    case HpChangeHandler of
        {Mod, Fun, Args} ->
            case Mod:Fun(Object, Hp, NewKList, Args) of
                {ok, NewArgs} -> {Mod, Fun, NewArgs};
                {ok, NewMod, NewFun, NewArgs} -> {NewMod, NewFun, NewArgs};
                stop -> [];
                _ -> HpChangeHandler
            end;
        _ -> HpChangeHandler
    end.

%% 死亡处理器
die_handler(State, KListAfCombine, Atter, AtterSign) ->
    #ob_act{die_handler = DieHandler, object = Object} = State,
    case DieHandler of
        {DMod, DFun, DArgs} ->
            case catch DMod:DFun(Object, KListAfCombine, Atter, AtterSign, DArgs) of
                {'EXIT', Err} ->
                    ?ERR("apply ~p error ~p~n", [DieHandler, Err]);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.