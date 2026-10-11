%%-----------------------------------------------------------------------------
%% @Module  :       lib_eudemons_attack_field.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-05
%% @Description:    幻兽入侵活动战场
%%-----------------------------------------------------------------------------

-module (lib_eudemons_attack_field).
-include ("battle_field.hrl").
-include ("errcode.hrl").
-include ("scene.hrl").
-include ("eudemons_act.hrl").
-include ("server.hrl").
-include ("attr.hrl").
-include ("battle.hrl").
-include ("predefine.hrl").
-include ("custom_act.hrl").
-include ("goods.hrl").
-include ("common.hrl").
-include ("def_module.hrl").

-define (FIELD_STAGE_BEFORE, 1).
-define (FIELD_STAGE_START, 2).
-define (FIELD_STAGE_END, 3).
-define (SECONDS_BEFORE_START, 30).
-define (SECONDS_BEFORE_QUIT, 10).
-define (MON_GROUP, 1).


%% 战场行为接口
-export ([
    %% 战场进程
    init/2
    ,player_enter/3
    ,player_quit/3
    ,player_logout/3
    ,player_finish_change_scene/3
    ,player_die/3
    ,player_revive/3
    ,mon_hp_change/3
    ,mon_die/3
    ,pack_enter_args/2
    ,terminate/2
    %% 玩家进程
    ,evt_out_of_battle/2
    ,evt_enter_scene_begin/2
    ,evt_enter_scene_finish/2
    ,pack_quit_args/2
    ]).

%% 本功能接口 玩家进程或者其他进程
-export ([
    handle_boss_hp_change/4 %% 怪物进程调用
    ,handle_boss_born/3 %% 怪物进程调用
    ,handle_boss_die/5 %% 怪物进程调用
    ,collect_num_check/3
    ,collected_handler/3
    ,mon_was_collected/2
    ,player_collect_something/3
    ,send_step_reward/5
    ]).

%% 本功能接口 战场进程
-export ([
    battle_start/2
    ,battle_end/2
    ,get_hurt_ranks/2
    ,send_field_time/2
    ,send_hurt_step_info/2
    ,init_boss_hp_lim/2
    ]).

init(State, [RoomId, EndTime, ActInfo]) ->
    SceneId = data_eudemons_act:get_kv(?KV_SCENE),
    CopyId = RoomId,
    ScenePoolId = 0,
    RoleMap = #{},
    Ref = erlang:send_after(max(EndTime - utime:unixtime(), 1) * 1000, State#battle_state.self, {apply, ?MODULE, battle_end, time_out}),
    Data = #{battle_end_time => EndTime, end_ref => Ref, act_info => ActInfo},
    NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, roles = RoleMap, data = Data},
    {ok, NewState}.

player_enter(RoleId, _, #battle_state{is_end = true}) ->
    {ok, BinData} = pt_603:write(60300, [?ERRCODE(err331_act_mission_complete)]),
    lib_server_send:send_to_uid(RoleId, BinData);

player_enter(RoleKey, Args, State) ->
    #battle_state{roles = RoleMap, data = StateData} = State,
    [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim, FigureData] = Args,
    [Lv, Name, Career, Sex, Turn, Pic, Power] = FigureData,
    SimpleFigure = #simple_figure{lv = Lv, name = Name, power = Power, sex = Sex, career = Career, turn = Turn, pic = Pic},
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{out_info = OutInfo, data = D} = Role} ->
            NewOutInfo 
            = OutInfo#{
                scene => OSceneId, 
                scene_pool_id => OPoolId, 
                copy_id => OCopyId, 
                x => X, 
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => []
            },
            NewRole = Role#battle_role{out_info = NewOutInfo, data = D#{simple_figure => SimpleFigure}},
            {ok, NewRole, State};
        _ ->
            NewOutInfo 
            = #{
                scene => OSceneId, 
                scene_pool_id => OPoolId, 
                copy_id => OCopyId, 
                x => X, 
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => []
            },
            if
                Hp > 0 ->
                    InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}];
                true ->
                    InSceneArgs = [{change_scene_hp, 1}]
            end,
            HurtStepList
            = case maps:find(act_info, StateData) of
                {ok, #act_info{key = {_, ActId}, wlv = Wlv}} ->
                    MinWlv = data_eudemons_act:get_hurt_steps_min_wlv(ActId, Wlv),
                    data_eudemons_act:get_hurt_steps(ActId, MinWlv);
                _ ->
                    []
            end,
            NewRole = #battle_role{key = RoleKey, out_info = NewOutInfo, in_info = #{scene_args => InSceneArgs}, data = #{simple_figure => SimpleFigure, collect_map => #{}, hurt_steps => HurtStepList}},
            {ok, NewRole, State}
    end.

%% 退出
player_quit(Role, [Hp, HpLim, EncourageInfo], State) ->
    #battle_role{in_info = InInfo, data = Data} = Role,
    InSceneArgs = maps:get(scene_args, InInfo, []),
    NewInSceneArgs = [{hp_lim, HpLim}, {hp, Hp}|[{K, V} || {K, V} <- InSceneArgs, K =/= hp andalso K =/= hp_lim]],
    {ok, Role#battle_role{in_info = InInfo#{scene_args => NewInSceneArgs}, data = Data#{encourage => EncourageInfo}}, State}.

%% 下线
player_logout(Role, [Hp, HpLim, EncourageInfo], State) -> 
    #battle_role{in_info = InInfo, data = Data} = Role,
    InSceneArgs = maps:get(scene_args, InInfo, []),
    NewInSceneArgs = [{hp_lim, HpLim}, {hp, Hp}|[{K, V} || {K, V} <- InSceneArgs, K =/= hp andalso K =/= hp_lim]],
    {ok, Role#battle_role{in_info = InInfo#{scene_args => NewInSceneArgs}, data = Data#{encourage => EncourageInfo}}, State}.


%% 玩家进入场景
player_finish_change_scene(#battle_role{key = RoleId} = Role, _Args, State) ->
    #battle_state{data = Data, self = Self} = State,
    case Data of
        #{stage := Stage, end_time := EndTime} ->
            {ok, BinData} = pt_603:write(60302, [Stage, EndTime]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, Role, State};
        _ ->
            %% 第一个人进来
            Stage = ?FIELD_STAGE_BEFORE,
            EndTime = utime:unixtime() + ?SECONDS_BEFORE_START,
            {ok, BinData} = pt_603:write(60302, [Stage, EndTime]),
            lib_server_send:send_to_uid(RoleId, BinData),
            erlang:send_after(?SECONDS_BEFORE_START * 1000, Self, {apply, ?MODULE, battle_start, []}),
            {ok, Role, State#battle_state{data = Data#{stage => Stage, end_time => utime:unixtime() + ?SECONDS_BEFORE_START}}}
    end.

player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.

mon_hp_change(MonId, [HpLim, Hp, Klist, CollectId], #battle_state{is_end = false, data = #{boss_id := MonId}} = State) ->
    #battle_state{data = Data, roles = RoleMap, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, self = Self} = State,
    LastCollectIds = maps:get(last_collect_ids, Data, []),
    if
        CollectId > 0 ->
            if
                LastCollectIds =/= [] ->
                    lib_mon:clear_scene_mon_by_mids(SceneId, ScenePoolId, CopyId, 1, LastCollectIds);
                true ->
                    ok
            end,
            RoleNumHere = length([1 || {_, #battle_role{state = ?ROLE_STATE_IN}} <- maps:to_list(RoleMap)]),
            case data_eudemons_act:get_collect(CollectId, RoleNumHere) of
                #eudemons_act_collect{
                    base_collected_mon = BaseMons
                    ,rand_collected_mon = RandMons
                    ,rand_num = RandNum
                    ,pos_list = PosList
                } ->
                    BaseIds = [Id || {Id, Num} <- BaseMons, _ <- lists:seq(1,Num)],
                    RandIds = [urand:rand_with_weight(RandMons) || _ <- lists:seq(1, RandNum)],
                    TotalIds = BaseIds ++ RandIds, %%  ulists:list_shuffle(BaseIds ++ RandIds),
                    BornPosList = setup_born_pos(TotalIds, ulists:list_shuffle(PosList), []),
                    CollectedHandler = {?MODULE, collected_handler, [Self]},
                    MonArgs = [{group, ?MON_GROUP},{collected_handler, CollectedHandler}],
                    BornList = [[?BATTLE_SIGN_MON, CId, X, Y, 0, MonArgs] || {CId, X, Y} <- BornPosList],
                    lib_scene_object:async_create_objects(SceneId, ScenePoolId, CopyId, 1, BornList),
                    {ok, BinData} = pt_603:write(60310, []),
                    lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
                    CollectMonIds = util:ulist(TotalIds);
                _ ->
                    % ?PRINT("CREATE COLLECT ERROR ~p~n", [[CollectId, RoleNumHere]]),
                    CollectMonIds = []
            end,
            Data1 = Data#{last_collect_ids => CollectMonIds};
        true ->
            Data1 = Data
    end,
    ActInfo = maps:get(act_info, Data, []),
    NewRoleMap = try_trigger_hurt_step(Klist, RoleMap, ActInfo, HpLim),
    NewRankList = refresh_ranks_list(Klist, NewRoleMap),
    NewState = State#battle_state{data = Data1#{hurt_list => Klist, sorted_hurt_list => NewRankList, boss_hp_lim => HpLim, boss_hp => HpLim - Hp}, roles = NewRoleMap}, 
    brocast_hurt_ranks_list(NewState),
    {ok, NewState};

mon_hp_change(_, _, _) ->
    skip.

mon_die(MonId, KillerId, #battle_state{is_end = false, data = #{boss_id := MonId} = Data} = State) ->
    NewState = battle_end(State#battle_state{data = Data#{killer_id => KillerId}}, win),
    {ok, NewState};

mon_die(_, _, _) ->
    skip.

pack_enter_args(Role, State) ->
    ForbidTime
    = case State of
        #battle_state{data = #{stage := Stage, end_time := EndTime}} ->
            if
                Stage =:=?FIELD_STAGE_BEFORE ->
                    EndTime;
                true ->
                    0
            end;
        _ ->
            utime:unixtime() + ?SECONDS_BEFORE_START
    end,
    NumMap = maps:get(collect_map, Role#battle_role.data, #{}),
    EncourageInfo = maps:get(encourage, Role#battle_role.data, #{}),
    [ForbidTime, NumMap, EncourageInfo].


evt_out_of_battle(Player, _Reason) ->
    % ?PRINT("evt_out_of_battle res = ~p~n", [ok]),
    #player_status{battle_field = BattleField} = Player,
    EncourageInfo = maps:get(encourage, BattleField, #{}),
    TmpPlayer = maps:fold(fun
        (SkillId, _, P) ->
            lib_goods_buff:remove_skill_buff(P, SkillId)
    end, Player, EncourageInfo),
    lib_player:break_action_lock(TmpPlayer#player_status{collect_checker = undefined}, ?ERRCODE(err603_in_battle)).

evt_enter_scene_begin(Player, _) -> 
    % ?PRINT("evt_enter_scene_begin res = ~p~n", [ok]),
    lib_player:setup_action_lock(Player, ?ERRCODE(err603_in_battle)).

evt_enter_scene_finish(#player_status{battle_field = BattleField} = Player, [ForbidTime, NumMap, EncourageInfo]) ->
    TmpPlayer = maps:fold(fun
        (SkillId, Lv, P) ->
            lib_goods_buff:add_skill_buff(P, SkillId, Lv)
    end, Player, EncourageInfo),
    TmpPlayer#player_status{forbid_pk_etime = ForbidTime, collect_checker = {?MODULE, collect_num_check, NumMap}, battle_field = BattleField#{encourage => EncourageInfo}}.

pack_quit_args(Player, _) ->
    #player_status{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}, battle_field = BattleField} = Player,
    EncourageInfo = maps:get(encourage, BattleField, #{}),
    [Hp, HpLim, EncourageInfo].

handle_boss_hp_change(Minfo, Hp, Klist, [BattlePid, LastUpdateTime, HpRatios]) ->
    NowTime = utime:unixtime(),
    HpLim = Minfo#scene_object.battle_attr#battle_attr.hp_lim,
    CurR = Hp / HpLim * 10000,
    % ?PRINT("handle_boss_hp_change ~p~n", [Klist]),
    case HpRatios of
        [{R, CollectId}|T] when CurR < R ->
            mod_battle_field:mon_hp_change(BattlePid, Minfo#scene_object.config_id, [HpLim, Hp, Klist, CollectId]),
            {ok, [BattlePid, NowTime, T]};
        _ ->
            if
                NowTime - LastUpdateTime > 5 orelse Hp =< 0 ->
                    mod_battle_field:mon_hp_change(BattlePid, Minfo#scene_object.config_id, [HpLim, Hp, Klist, 0]),
                    {ok, [BattlePid, NowTime, HpRatios]};
                true ->
                    skip
            end
    end.

handle_boss_die(Minfo, _, Atter, _AtterSign, [BattlePid]) ->
    #battle_return_atter{id = AtterId} = Atter,
    mod_battle_field:mon_die(BattlePid, Minfo#scene_object.config_id, AtterId).

handle_boss_born(_, #scene_object{battle_attr = #battle_attr{hp_lim = HpLim}}, [BattlePid]) ->
    mod_battle_field:apply_cast(BattlePid, ?MODULE, init_boss_hp_lim, HpLim).

init_boss_hp_lim(#battle_state{data = Data} = State, HpLim) ->
    NewState = State#battle_state{data = Data#{boss_hp_lim => HpLim}},
    maps:map(fun
        (RoleId, #battle_role{state = S})  ->
            if
                S =:= ?ROLE_STATE_IN ->
                    send_hurt_step_info(NewState, RoleId);
                true ->
                    ok
            end
    end, State#battle_state.roles),
    NewState.


% get_hurt_ranks(Player) ->
%     #player_status{id = RoleId, battle_field = BattleField} = Player,
%     case BattleField of
%         #{mod_lib := ?MODULE, pid := BattlePid} ->
%             mod_battle_field:apply_cast(BattlePid, ?MODULE, get_hurt_ranks, RoleId);
%         _ ->
%             ok
%     end.

get_hurt_ranks(State, RoleId) ->
    #battle_state{data = Data, roles = RoleMap} = State,
    BossHp = maps:get(boss_hp, Data, 100000),
    case maps:get(sorted_hurt_list, Data, undefined) of
        undefined ->
            SortedKList = refresh_ranks_list(maps:get(hurt_list, Data, []), RoleMap),
            send_hurt_ranks_list(RoleId, SortedKList, BossHp),
            State#battle_state{data = Data#{sorted_hurt_list => SortedKList}};
        SortedKList ->
            send_hurt_ranks_list(RoleId, SortedKList, BossHp)
    end.

send_hurt_ranks_list(RoleId, SortedKList, BossHp) ->
    MyRank = ulists:find_index(fun
        (#hurt_rank_item{id = Id}) ->
            Id =:= RoleId
    end, SortedKList),
    MyHurt 
    = case lists:keyfind(RoleId, #hurt_rank_item.id, SortedKList) of
        #hurt_rank_item{hurt = Hurt} ->
            Hurt;
        _ ->
            0
    end,
    FormatList = [{Name, HurtV} || #hurt_rank_item{name = Name, hurt = HurtV} <- SortedKList],
    {ok, BinData} = pt_603:write(60304, [BossHp, MyRank, MyHurt, FormatList]),
    lib_server_send:send_to_uid(RoleId, BinData).

brocast_hurt_ranks_list(State) ->
    #battle_state{data = Data, roles = RoleMap} = State,
    BossHp = maps:get(boss_hp, Data, 100000),
    SortedKList = maps:get(sorted_hurt_list, Data, []),
    FormatList = [{Name, HurtV} || #hurt_rank_item{name = Name, hurt = HurtV} <- SortedKList],
    maps:map(fun
        (RoleId, _) ->
            MyRank = ulists:find_index(fun
                (#hurt_rank_item{id = Id}) ->
                    Id =:= RoleId
            end, SortedKList),
            MyHurt 
            = case lists:keyfind(RoleId, #hurt_rank_item.id, SortedKList) of
                #hurt_rank_item{hurt = Hurt} ->
                    Hurt;
                _ ->
                    0
            end,
            {ok, BinData} = pt_603:write(60304, [BossHp, MyRank, MyHurt, FormatList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end, RoleMap).

% get_field_time(Player) ->
%     case Player#player_status.battle_field of
%         #{mod_lib := ?MODULE, pid := BattlePid} ->
%             mod_battle_field:apply_cast(BattlePid, ?MODULE, send_field_time, Player#player_status.id);
%         _ ->
%             ok
%     end.

send_field_time(State, RoleId) ->
    #battle_state{data = Data} = State,
    Stage = maps:get(stage, Data, 0),
    EndTime = maps:get(end_time, Data, 0),
    {ok, BinData} = pt_603:write(60302, [Stage, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData).


battle_start(State, _) -> 
    #battle_state{data = #{battle_end_time := EndTime} = Data, is_end = IsEnd, roles = RoleMap} = State,
    if
        IsEnd =:= false ->
            Stage = ?FIELD_STAGE_START,
            {ok, BinData} = pt_603:write(60302, [Stage, EndTime]),
            maps:map(fun
                (RoleId, #battle_role{state = ?ROLE_STATE_IN}) ->
                    lib_server_send:send_to_uid(RoleId, BinData);
                (_, _) -> ok
            end, RoleMap),
            #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, self = Self} = State,
            MonId = data_eudemons_act:get_kv(?KV_BOSS_ID),
            {X, Y} = data_eudemons_act:get_kv(?KV_BORN_POS),
            HpRatios = lists:reverse(lists:keysort(1, data_eudemons_act:get_kv(?KV_BOSS_HPR))),
            HpChangeHandle = {?MODULE, handle_boss_hp_change, [Self, 0, HpRatios]},
            MonDieHandler = {?MODULE, handle_boss_die, [Self]},
            BornHandler = {?MODULE, handle_boss_born, [Self]},
            BossArgs = [
                {group, ?MON_GROUP},
                {born_handler, BornHandler},
                {hp_change_handler, HpChangeHandle},
                {die_handler, MonDieHandler}
            ],
            lib_mon:async_create_mon(MonId, SceneId, ScenePoolId, X, Y, 1, CopyId, 1, BossArgs),
            State#battle_state{data = Data#{stage => Stage, end_time => EndTime, boss_id => MonId}};
        true ->
            skip
    end.

battle_end(State, _) ->
    #battle_state{data = Data, is_end = IsEnd, roles = RoleMap, self = Self, scene_pool_id = RoomId} = State,
    if
        IsEnd ->
            State;
        true ->
            Stage = ?FIELD_STAGE_END,
            EndTime = utime:unixtime() + ?SECONDS_BEFORE_QUIT,
            SortedHurtList 
            = case maps:get(sorted_hurt_list, Data, undefined) of
                undefined ->
                    refresh_ranks_list(maps:get(hurt_list, Data, []), RoleMap);
                SortedKList ->
                    SortedKList
            end,
            KillerId = maps:get(killer_id, Data, 0),
            BossHp = maps:get(boss_hp, Data, 100000),
            #act_info{key = {_, ActSubType}, wlv = Wlv} = ActInfo = maps:get(act_info, Data),
            % Res = maps:get(res, Data, 0),
            % Last
            % {ok, BinData} = pt_331:write(33131, [Stage, EndTime]),
            NewRoleMap = maps:map(fun
                (RoleId, #battle_role{state = S, data = D} = Role) ->
                    #{simple_figure := SimpleFigure} = D,
                    Rank = ulists:find_index(fun(#hurt_rank_item{id = AerId}) -> AerId =:= RoleId end, SortedHurtList),
                    Hurt = case lists:keyfind(RoleId, #hurt_rank_item.id, SortedHurtList) of
                        #hurt_rank_item{hurt = V} ->
                            V;
                        _ ->
                            0
                    end,
                    lib_eudemons_attack:handle_battle_result(RoleId, Rank, EndTime, KillerId, S =:= ?ROLE_STATE_IN, ActInfo, SimpleFigure, RoomId, Hurt, BossHp),
                    Role#battle_role{data = D#{rank => Rank}}
            end, RoleMap),
            erlang:send_after(?SECONDS_BEFORE_QUIT * 1000, Self, stop),
            mod_eudemons_attack:upload_battle_result(Self, BossHp, KillerId, SortedHurtList),
            if
                KillerId > 0 ->
                    KillerName 
                    = case lists:keyfind(KillerId, #hurt_rank_item.id, SortedHurtList) of
                        #hurt_rank_item{name = Name} ->
                            Name;
                        _ ->
                            <<"">>
                    end,
                    case data_eudemons_act:get_killer_reward(ActSubType, Wlv) of
                        [{_, GoodsId, _}|_] ->
                            ok;
                        _ ->
                            GoodsId = 0
                    end,
                    case SortedHurtList of
                        [#hurt_rank_item{id = FirstId, name = FirstName}|_] ->
                            ok;
                        _ ->
                            FirstId = 0, FirstName = <<"">>
                    end,
                    lib_chat:send_TV({all}, ?MOD_EUDEMONS_ATTACK, 3, [RoomId, KillerName, KillerId, GoodsId]),
                    lib_chat:send_TV({all}, ?MOD_EUDEMONS_ATTACK, 4, [FirstName, FirstId]);
                true ->
                    ok
            end,
            State#battle_state{is_end = true, roles = NewRoleMap, data = Data#{stage => Stage, end_time => EndTime, sorted_hurt_list => SortedHurtList}}
    end.


refresh_ranks_list(List, RoleMap) ->
    RawList
    = [begin 
        #battle_role{data = #{simple_figure := #simple_figure{name = Name, power = Power, sex = Sex, career = Career, turn = Turn, pic = Pic}}} = maps:get(Id, RoleMap),
        #hurt_rank_item{id = Id, name = Name, hurt = Value, power = Power, sex = Sex, career = Career, turn = Turn, pic = Pic}
    end || #mon_atter{id = Id, hurt = Value, att_sign = ?BATTLE_SIGN_PLAYER} <- List, maps:is_key(Id, RoleMap)],
    lists:reverse(lists:keysort(#hurt_rank_item.hurt, RawList)).

collect_num_check(_MonId, _MonCfgId, NumMap) ->
    Num = maps:fold(fun
        (_, N, Acc) ->
            N + Acc
    end, 0, NumMap),
    % ?PRINT("NUM = ~p~n", [Num]),
    case data_eudemons_act:get_kv(?KV_COLLECT_NUM_MAX) of
        Max when is_integer(Max) andalso Max =< Num ->
            {false, 7};
        _ ->
            true
    end.

collected_handler(Minfo, RoleId, [BattlePid]) ->
    mod_battle_field:apply_cast(BattlePid, ?MODULE, mon_was_collected, [Minfo, RoleId]).

mon_was_collected(#battle_state{is_end = false} = State, [Minfo, RoleId]) ->
    #battle_state{roles = RoleMap} = State,
    case maps:find(RoleId, RoleMap) of
        {ok, #battle_role{data = Data} = Role} ->
            CollectMap = maps:get(collect_map, Data, #{}),
            CollectNum = maps:get(Minfo#scene_object.config_id, CollectMap, 0) + 1,
            NewCollectMap = CollectMap#{Minfo#scene_object.config_id => CollectNum},
            NewData = Data#{collect_map => NewCollectMap},
            NewRole = Role#battle_role{data = NewData},
            NewState = State#battle_state{roles = RoleMap#{RoleId => NewRole}},
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, player_collect_something, [NewCollectMap, Minfo]),
            NewState;
        _ ->
            skip
    end;

mon_was_collected(_, _) -> skip.

player_collect_something(#player_status{} = Player, CollectMap, Minfo) ->
    DropPs = lib_goods_drop:mon_drop(Player, Minfo, [], []),
    DropPs#player_status{collect_checker = {?MODULE, collect_num_check, CollectMap}}.

try_trigger_hurt_step([#mon_atter{id = RoleId, att_sign = ?BATTLE_SIGN_PLAYER, hurt = Hurt}|Klist], RoleMap, ActInfo, HpLim) ->
    case maps:find(RoleId, RoleMap) of
        {ok, #battle_role{data = Data} = Role} ->
            case maps:find(hurt_steps, Data) of
                {ok, [Step|_] = HurtStepList} when Step * HpLim / 10000 =< Hurt  ->
                    NewHurtStepList = handle_hurt_step_list(RoleId, HurtStepList, Hurt, ActInfo, HpLim),
                    NewRole = Role#battle_role{data = Data#{hurt_steps => NewHurtStepList}},
                    try_trigger_hurt_step(Klist, RoleMap#{RoleId => NewRole}, ActInfo, HpLim);
                _ ->
                    try_trigger_hurt_step(Klist, RoleMap, ActInfo, HpLim)
            end;
        _ ->
            try_trigger_hurt_step(Klist, RoleMap, ActInfo, HpLim)
    end;

try_trigger_hurt_step([_|Klist], RoleMap, ActInfo, HpLim) -> try_trigger_hurt_step(Klist, RoleMap, ActInfo, HpLim);

try_trigger_hurt_step([], RoleMap, _, _) -> RoleMap.

handle_hurt_step_list(_, [Step|_] = List, Hurt, _, HpLim) when Step*HpLim/10000 > Hurt ->
    List;

handle_hurt_step_list(RoleId, [Step|List], Hurt, ActInfo, HpLim) ->
    Next = case List of [V|_] -> V; _ -> 0 end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, send_step_reward, [ActInfo, Step, Next, HpLim]),
    handle_hurt_step_list(RoleId, List, Hurt, ActInfo, HpLim);

handle_hurt_step_list(_, [], _, _,_) -> [].

send_step_reward(Player, #act_info{key = {_, ActId}, wlv = Wlv}, Step, Next, HpLim) ->
    NextRewardList = data_eudemons_act:get_hurt_step_reward(ActId, Next, Wlv),
    {ok, BinData} = pt_603:write(60309, [util:ceil(Next*HpLim/10000), NextRewardList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    case data_eudemons_act:get_hurt_step_reward(ActId, Step, Wlv) of
        [_|_] = RewardList ->
            Produce = #produce{type = eudemons_attack_hurt_step, reward = RewardList, remark = integer_to_list(Step), show_tips = ?SHOW_TIPS_1, title = utext:get(203), content = utext:get(204)},
            lib_goods_api:send_reward_with_mail(Player, Produce);
        _ ->
            ?ERR("send_step_reward error ~p~n", [[ActId, Wlv, Step]])
    end.

send_hurt_step_info(State, RoleId) ->
    #battle_state{roles = RoleMap, data = Data} = State,
    case Data of
        #{act_info := #act_info{key = {_, ActId}, wlv = Wlv}, boss_hp_lim := HpLim} ->
            Next 
            = case maps:find(RoleId, RoleMap) of
                {ok, #battle_role{data = RoleData}} ->
                    case maps:find(hurt_steps, RoleData) of
                        {ok, [Step|_]} ->
                            Step;
                        _ ->
                            0
                    end;
                _ ->
                    0
            end,
            NextRewardList = data_eudemons_act:get_hurt_step_reward(ActId, Next, Wlv),
            {ok, BinData} = pt_603:write(60309, [util:ceil(Next*HpLim/10000), NextRewardList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            ok
    end.




setup_born_pos([Id|TotalIds], [{X,Y}|PosList], Acc) ->
    setup_born_pos(TotalIds, PosList, [{Id, X, Y}|Acc]);

setup_born_pos(_, _, Acc) -> Acc.

terminate(_Reason, #battle_state{is_end = IsEnd, self = Self, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId}) ->
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId),
%%    mod_scene_agent:close_scene(SceneId, ScenePoolId),
    if
        not IsEnd ->
            mod_eudemons_attack:upload_battle_result(Self, 0, 0, []);
        true ->
            ok
    end.