%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_mon_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本怪物事件处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_mon_event).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("enchantment_guard.hrl").
-include("rec_event.hrl").
-include("scene.hrl").
-include("def_fun.hrl").

%% 创建怪物波数
create_dungeon_wave(State, CommonEvent) ->
    #dungeon_state{dun_id = DunId, common_event_map = CommonEventMap, wave_num = _WaveNum, rand_mon_map = RandMonMap0} = State,
    #dungeon_common_event{id = CommonEventId, scene_id = SceneId, belong_type = BelongType, wave_type = WaveType} = CommonEvent,
    SubtypeList = data_dungeon_wave:get_wave_subtype_list(DunId, SceneId, WaveType),
    NowTime = utime:longunixtime(),
    F = fun(WaveSubtype, {SubTypeMap, RandMonMap}) ->
        #dungeon_wave{refresh_time = RefreshTime, rand_num = RandNum} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
        WaveSubtypeRecord = #dungeon_wave_subtype{type = WaveType, subtype = WaveSubtype, mon_map = #{}, cycle_num = 0, create_time = NowTime+RefreshTime},
        NewRandMonMap
        = case RandNum of
            {extra_rand, RandKey} ->
                case maps:find(RandKey, RandMonMap) of
                    {ok, _} ->
                        RandMonMap;
                    _ ->
                        RandIdList = ulists:list_shuffle(data_dungeon_wave:get_all_rand_wave(DunId, RandKey)),
                        RandMonMap#{RandKey => RandIdList}
                end;
            _ ->
                RandMonMap
        end,
        {SubTypeMap#{WaveSubtype => WaveSubtypeRecord}, NewRandMonMap}
        % {WaveSubtype, WaveSubtypeRecord}
    end,
    {WaveSubtypeMap, NewRandMonMap} = lists:foldl(F, {#{}, RandMonMap0}, SubtypeList),
    % WaveSubtypeMap = maps:from_list(lists:map(F, SubtypeList)),
    % ?DEBUG("#####create_dungeon_wave WaveSubtypeMap:~w ~n", [WaveSubtypeMap]),
    NewCommonEvent = CommonEvent#dungeon_common_event{wave_subtype_map = WaveSubtypeMap, allow_type = ?DUN_ALLOW_TYPE_NO},
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    State1 = State#dungeon_state{common_event_map = NewCommonEventMap, rand_mon_map = NewRandMonMap},
    handle_battle_wave(State1, NewCommonEvent).


handle_battle_wave(State, #dungeon_common_event{args = Args} = CommonEvent) ->
    #dungeon_state{
        dun_id = DunId, dun_type = DunType, wave_close_ref = OldWaveCloseRef, level_close_ref = _OldRef,
        wave_num = OldBattleWave, role_list = _RoleList
        } = State,
    case lists:keyfind(wave_no, 1, Args) of
        {wave_no, NewBattleWave} ->
            % 每一波都需要时间判断
            case data_dungeon_wave:get_wave_helper(DunId, NewBattleWave) of
                #dungeon_wave_helper{time = Time} ->
%%                    LevelCloseRef = util:send_after(OldRef, Time*1000, self(), {'dungeon_level_timeout'}),
                    % 波数结束定时器
                    WaveCloseRef = util:send_after(OldWaveCloseRef, Time*1000, self(), {'wave_timeout'}),
                    NowTime = utime:unixtime(),
                    NewState = State#dungeon_state{
%%                        level_start_time = NowTime, level_end_time = NowTime+Time, level_close_ref = LevelCloseRef,
                        wave_start_time = NowTime, wave_end_time = NowTime+Time, wave_close_ref = WaveCloseRef,
                        wave_num = NewBattleWave
                    };
                _ ->
                    if
                    % 使魔试炼、龙纹试炼 波数不能倒退
                        DunType == ?DUNGEON_TYPE_DRAGON -> NewBattleWave2 = max(OldBattleWave, NewBattleWave);
                        true -> NewBattleWave2 = NewBattleWave
                    end,
                    NewState = State#dungeon_state{wave_num = NewBattleWave2}
            end,
            lib_dungeon_mod:send_info(NewState),
            NewState;
        _ ->
            % 波数
            case is_calc_wave_num(CommonEvent) of
                true -> NewBattleWave = OldBattleWave + 1;
                false ->
                    NewBattleWave = OldBattleWave
            end,
            NewState = State#dungeon_state{wave_num = NewBattleWave},
            NewState
    end.


%% 是否计算波数
is_calc_wave_num(#dungeon_common_event{args = Args}) ->
    case lists:keyfind(is_calc_wave_num, 1, Args) of
        {is_calc_wave_num, 0} -> false;
        _ -> true
    end.

%% 创建怪物
create_dungeon_mon(State, CommonEventId) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    #dungeon_state{dun_id = DunId, mon_auto_id = MonAutoId, common_event_map = CommonEventMap} = State,
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
    #dungeon_common_event{wave_type = WaveType, scene_id = SceneId, wave_subtype_map = WaveSubtypeMap, create_ref = OldRef} = CommonEvent,
    NowTime = utime:longunixtime(),
    % 获得刷出怪物的子波数
    F = fun(_Key, WaveSubtypeRecord, {Satisfying, NotSatisfying}) ->
        #dungeon_wave_subtype{subtype = WaveSubtype, mon_map = WaveMonMap, cycle_num = CycleNum, create_time = CreateTime} = WaveSubtypeRecord,
        #dungeon_wave{create_type = CreateType, cycle_num = MaxCycleNum, cycle_gap = CycleGap, die_gap = DieGap} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
        % 修改的时候,注意 get_create_time_list
        if
            MaxCycleNum == 0 -> {Satisfying, NotSatisfying};  %%{满足列表， 不满足列表}
            CycleNum == 0 andalso NowTime >= CreateTime -> {[WaveSubtypeRecord|Satisfying], NotSatisfying};
            CycleNum == 0 -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]};
            CycleNum >= MaxCycleNum -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]};
            CreateType == ?DUN_WAVE_CREATE_TYPE_CYCLE ->
                #dungeon_wave_mon{refresh_time = RefreshTime} = maps:get(CycleNum, WaveMonMap),
                case NowTime>=(RefreshTime+CycleGap) of
                    true -> {[WaveSubtypeRecord|Satisfying], NotSatisfying};
                    false -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]}
                end;
            CreateType == ?DUN_WAVE_CREATE_TYPE_MON_DIE ->
                #dungeon_wave_mon{mon_list = MonList, die_time = DieTime} = maps:get(CycleNum, WaveMonMap),
                F = fun({_TmpAutoId, _TmpMonId, IdDie}) -> IdDie == 1 end,
                case lists:all(F, MonList) of
                    true ->
                        case NowTime>=(DieTime+DieGap) of
                            true -> {[WaveSubtypeRecord|Satisfying], NotSatisfying};
                            false -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]}
                        end;
                    false ->
                        {Satisfying, [WaveSubtypeRecord|NotSatisfying]}
                end;
            CreateType == ?DUN_WAVE_CREATE_TYPE_MAX_CYCLE_GAP ->
                #dungeon_wave_mon{mon_list = MonList, refresh_time = RefreshTime, die_time = DieTime} = maps:get(CycleNum, WaveMonMap),
                F = fun({_TmpAutoId, _TmpMonId, IdDie}) -> IdDie == 1 end,
                case lists:all(F, MonList) of
                    true ->
                        NextCreateTime = min(DieTime+DieGap, RefreshTime+CycleGap),
                        case NowTime>=NextCreateTime of
                            true -> {[WaveSubtypeRecord|Satisfying], NotSatisfying};
                            false -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]}
                        end;
                    false ->
                        case NowTime>=(RefreshTime+CycleGap) of
                            true -> {[WaveSubtypeRecord|Satisfying], NotSatisfying};
                            false -> {Satisfying, [WaveSubtypeRecord|NotSatisfying]}
                        end
                end;
            true ->
                {Satisfying, NotSatisfying}
        end
    end,
    {Satisfying, NotSatisfying} = maps:fold(F, {[], []}, WaveSubtypeMap),
    %?PRINT("Satisfying ~p~n", [{WaveSubtypeMap, Satisfying, NotSatisfying}]),
    % 清理怪物
    clear_mon(State, SceneId, Satisfying),
    % 产生怪物
    {NewSatisfying, NewMonAutoId, MonState} = create_dungeon_mon_help(Satisfying, State, CommonEventId, SceneId, MonAutoId, []),
    RecordList = NewSatisfying++NotSatisfying,
    RecordKvList = [{WaveSubtype, Record}||#dungeon_wave_subtype{subtype = WaveSubtype}=Record<-RecordList],
    NewWaveSubtypeMap = maps:from_list(RecordKvList),
    util:cancel_timer(OldRef),
    CreateTimeList = get_create_time_list(DunId, SceneId, WaveType, NewWaveSubtypeMap),
    case CreateTimeList == [] of
        true -> Ref = none;
        false ->
            NextRefreshTime = hd(CreateTimeList),
            TimeGap = max(NextRefreshTime - NowTime, 500),
            Ref = erlang:send_after(TimeGap, self(), {'create_dungeon_mon_on_mon_event', CommonEventId})
    end,
    % ?INFO("#####create_dungeon_mon MonAutoId:~p NewMonAutoId:~p NowTime:~p ~n", [MonAutoId, NewMonAutoId, NowTime]),
    % ?INFO("#####create_dungeon_mon CommonEventId:~p CreateTimeList:~w Satisfying:~w NotSatisfying:~w ~n", [CommonEventId, CreateTimeList, Satisfying, NotSatisfying]),
    NewCommonEvent = CommonEvent#dungeon_common_event{wave_subtype_map = NewWaveSubtypeMap, create_ref = Ref},
    % ?INFO("#####create_dungeon_mon NewWaveSubtypeMap:~w ~n", [NewWaveSubtypeMap]),
    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
    NewState = MonState#dungeon_state{mon_auto_id = NewMonAutoId, common_event_map = NewCommonEventMap},
    NewState2 = handle_wave_subtype_refresh(NewSatisfying, CommonEventId, NewState),
    LastState = set_typical_data(NewState2,  CommonEventId),  %%刷怪时，设置typical_data数据
    LastStateA = deal_empty_mon_list(LastState, NewCommonEvent, NewSatisfying),
    LastStateB = lib_dungeon_util:send_mon_num(LastStateA, NewCommonEvent),
    LastStateB.

create_dungeon_mon_help([], State, _CommonEventId, _SceneId, MonAutoId, List) -> {List, MonAutoId, State};
create_dungeon_mon_help([WaveSubtypeRecord|L], State, CommonEventId, SceneId, MonAutoId, List) ->
    #dungeon_state{
        dun_id = DunId, scene_pool_id = ScenePoolId, role_list = RoleList, mon_helper = MonHelper, enter_lv = EnterLv, level = Level,
        typical_data = TypicalData, rand_mon_map = RandMonMap, dun_type = DunType, wave_num = WaveNum
    } = State,
    #dungeon_wave_subtype{type = WaveType, subtype = WaveSubtype, mon_map = WaveMonMap, cycle_num = CycleNum} = WaveSubtypeRecord,
    #dungeon_wave{
        scene_id = SceneId, rand_num = RandNum, mon_list = WaveMonList, group_mon_list = WaveGroupMonList, xy_range = XyRange
        } = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
    MonIdReplace = maps:get(?DUN_STATE_SPCIAL_KEY_REPLACE_MON, TypicalData, []),
    case RandNum of
        [] ->
            NewWaveMonList = WaveMonList, NewRandMonMap = RandMonMap;
        {extra_rand, RandKey} ->
            case maps:find(RandKey, RandMonMap) of
                {ok, [WaveId|T]} ->
                    NewWaveMonList = data_dungeon_wave:get_rand_mons(DunId, RandKey, WaveId),
                    NewRandMonMap = RandMonMap#{RandKey => T};
                _ ->
                    NewWaveMonList = [], NewRandMonMap = RandMonMap
            end;
        _ ->
            NewRandMonMap = RandMonMap,
            {Num, _, Type} = util:find_ratio(RandNum, 2),
            if
                Type == ?DUN_RAND_TYPE_NORMAL andalso WaveMonList =/= [] ->
                    F = fun(_No) -> util:find_ratio(WaveMonList, 4) end,
                    NewWaveMonList = lists:map(F, lists:seq(1, Num));
                Type == ?DUN_RAND_TYPE_SAME andalso WaveMonList =/= []  ->
                    NewWaveMonList = lists:duplicate(Num, util:find_ratio(WaveMonList, 4));
                Type == ?DUN_RAND_TYPE_SAME_CYCLE_XY andalso WaveMonList =/= []  ->
                    WaveMonListAfRand = lists:duplicate(Num, util:find_ratio(WaveMonList, 4)),
                    Len = length(WaveMonList),
                    F = fun({MonId, _X, _Y, _Weight, _Attrlist}, {No, TmpWaveMonList}) ->
                        case No rem Len of
                            0 -> NewNo = Len;
                            NewNo -> ok
                        end,
                        {_NeMonId, NewX, NewY, NewWeight, NewAttrlist} = lists:nth(NewNo, WaveMonList),
                        NewTmpWaveMonList = [{MonId, NewX, NewY, NewWeight, NewAttrlist}|TmpWaveMonList],
                        {No+1, NewTmpWaveMonList}
                    end,
                    {_, NewWaveMonList} = lists:foldl(F, {1, []}, WaveMonListAfRand);
                % 获得顺序的怪物列表
                Type == ?DUN_RAND_TYPE_SEQUENCE andalso WaveMonList =/= [] ->
                    Len = length(WaveMonList),
                    F = fun(No) ->
                        case No rem Len of
                            0 -> NewNo = Len;
                            NewNo -> ok
                        end,
                        lists:nth(NewNo, WaveMonList)
                    end,
                    NewWaveMonList = lists:map(F, lists:seq(1, Num));
                % 随机出相同组的怪物
                Type == ?DUN_RAND_TYPE_GROUP andalso WaveGroupMonList =/= [] ->
                    F = fun(_No, TmpSumList) ->
                        {_Weight, TmpMonList} = util:find_ratio(WaveGroupMonList, 1),
                        TmpMonList++TmpSumList
                    end,
                    NewWaveMonList = lists:foldl(F, [], lists:seq(1, Num)),
                    NewWaveMonList;
                true ->
                    NewWaveMonList = []
            end
    end,
    #dungeon{dynamic_attr = DynamicAttr, power_crush_type = PowerCrushType, recommend_power = RecommendPower} = data_dungeon:get(DunId),
	%%判断是否主线副本，是则取主线副本对应的怪物信息, 战力碾压也会用主线副本的战力碾压
    if
        DunType == ?DUNGEON_TYPE_ENCHANTMENT_GUARD ->
            {GuardBoss, CrushRAttr} = lib_enchantment_guard:get_boss(State, PowerCrushType, RoleList, RecommendPower);
        true ->
            CrushRAttr = get_power_crush_attr(DunId, WaveNum, RoleList),
            GuardBoss = []
    end,
    NewCycleNum = CycleNum+1,
    DefDunR = maps:get(?DUN_STATE_SPCIAL_KEY_COMMON_DUNR, TypicalData, []),
    CommonDunR = lib_dungeon_api:invoke(DunType, dunexget_dungeon_mon_dynamic, [State], DefDunR),
    % 怪物生成
    #dungeon_mon_helper{hp_rate_map = HpRateMap} = MonHelper,
    F2 = fun({MonId, X, Y, _, Attrlist}, {TmpList, TmpMonAutoId}) ->
        {NewX, NewY} = xy_range(X, Y, XyRange),
        MonKey = {mon_event, CommonEventId, WaveSubtype, NewCycleNum, TmpMonAutoId},
        % ?PRINT("#####create_dungeon_mon SceneId:~p MonKey:~p ~n", [SceneId, MonKey]),
        case data_mon:get(MonId) of
            [] -> MonType = 1;
            #mon{type = MonType} -> ok
        end,
        case maps:get(MonId, HpRateMap, []) of
            [] -> HpRateAttr = [];
            HpRateList -> HpRateAttr = [{dungeon_hp_rate, HpRateList}]
        end,
        case data_mon_dynamic:get_dungeon_mon_dynamic(MonId, DunId, Level) of
            [] -> DunrList = CommonDunR;
            #dungeon_mon_dynamic{ratio = Dunr} -> DunrList = lists:keystore(dun_r, 1, CommonDunR, {dun_r, Dunr})
        end,
        case lists:keyfind(MonId, 1, MonIdReplace) of
            {MonId, MonId2} ->
                ReplaceAttr = [];
            {MonId, MonId2, ReplaceAttr} ->
                ok;
            _ ->
                MonId2 = MonId, ReplaceAttr = []
        end,
        AutoLv = lib_dungeon_api:invoke(DunType, dunex_calc_auto_lv, [EnterLv, State], EnterLv),
	    %%怪物战斗属性start  GuardBoss如果不为空则用GuardBoss的属性代替 cym
        {GuardAtt, GuardX, GuardY} = lib_enchantment_guard:get_guard_boss_attr(GuardBoss, MonId2, State, SceneId, self(), NewX, NewY),
	    %%GuardAtt 为主线副本的属性
        case lists:keytake(create_delay, 1, Attrlist) of
            {value, {create_delay, CreateDelayTime}, NewAttrlist} -> ok;
            _ -> CreateDelayTime = 0, NewAttrlist = Attrlist
        end,
        SumAttrList =[{attr_replace, GuardAtt}] ++ ReplaceAttr ++ CrushRAttr++[{auto_lv, AutoLv}, {create_key, MonKey}, {type, MonType}]++
            NewAttrlist++HpRateAttr++DunrList++DynamicAttr,
        case CreateDelayTime == 0 of
            true -> lib_mon:async_create_mon(MonId2, SceneId, ScenePoolId, GuardX, GuardY, MonType, self(), 1, SumAttrList);
            false ->
                Pid = self(),
                spawn(fun() ->
                    timer:sleep(CreateDelayTime),
                    lib_mon:async_create_mon(MonId2, SceneId, ScenePoolId, GuardX, GuardY, MonType, Pid, 1, SumAttrList)
                end)
        end,
        {[{MonKey, MonId2, 0}|TmpList], TmpMonAutoId+1}
    end,
    %%取出要创建的怪物信息
    {LastWaveMonList, NewTypcialMap} = get_typcial_mon_msg(NewWaveMonList, TypicalData, DunType, RoleList), %%获得TypicalData的怪物信息
    {MonList, NewMonAutoId} = lists:foldr(F2, {[], MonAutoId}, LastWaveMonList),
    NewCycleNum = CycleNum+1,
    %?DEBUG("#####create_dungeon_mon_help CommonEventId:~p CycleNum:~p MonList:~w ~n", [CommonEventId, NewCycleNum, MonList]),
    WaveMonRecord = #dungeon_wave_mon{cycle_id = NewCycleNum, mon_list = MonList, refresh_time = utime:longunixtime()},
    NewWaveMonMap = maps:put(NewCycleNum, WaveMonRecord, WaveMonMap),
    NewWaveSubtypeRecord = WaveSubtypeRecord#dungeon_wave_subtype{mon_map = NewWaveMonMap, cycle_num = NewCycleNum},
    create_dungeon_mon_help(L, State#dungeon_state{rand_mon_map = NewRandMonMap, typical_data = NewTypcialMap}, CommonEventId, SceneId, NewMonAutoId, [NewWaveSubtypeRecord|List]).

%% 坐标随机
xy_range(X, Y, XyRange) ->
    case XyRange of
        [XRange, YRange] ->
            NewX = urand:rand(X-XRange, X+XRange),
            NewY = urand:rand(Y-YRange, Y+YRange),
            {NewX, NewY};
        _ ->
            {X, Y}
    end.

%% 碾压
get_power_crush_attr(DunId, WaveNum, RoleList) ->
    #dungeon{power_crush_type = PowerCrushType, recommend_power = RecommendPower} = data_dungeon:get(DunId),
    if
        PowerCrushType == ?DUN_POWER_CRUSH_TYPE_NO -> [];
        PowerCrushType == ?DUN_POWER_CRUSH_TYPE_BASE -> get_power_crush_attr(RoleList, RecommendPower);
        % PowerCrushType == ?DUN_POWER_CRUSH_TYPE_LEVEL ->
        %     case data_dungeon_level:get_dungeon_level(DunId, SceneId, SerialNo) of
        %         [] -> [];
        %         #dungeon_level{recommend_power = LevelRecommendPower} -> get_power_crush_attr(RoleList, LevelRecommendPower)
        %     end;
        PowerCrushType == ?DUN_POWER_CRUSH_TYPE_WAVE_HELPER ->
            case data_dungeon_wave:get_wave_helper(DunId, WaveNum) of
                [] -> [];
                #dungeon_wave_helper{recommend_power = WaveRecommendPower} -> get_power_crush_attr(RoleList, WaveRecommendPower)
            end;
        true -> []
    end.

%% 获得战力碾压属性
get_power_crush_attr(_RoleList, 0) -> [];
get_power_crush_attr([], _RecommendPower) -> [];
get_power_crush_attr(RoleList, RecommendPower) ->
    CombatPowerSum = lists:sum([CombatPower||#dungeon_role{combat_power = CombatPower}<-RoleList]),
    CombatPower = CombatPowerSum/length(RoleList),
    Diff = CombatPower - RecommendPower,
    case Diff >= 0 of
        true -> [];
        false ->
            DiffRatio = (RecommendPower - CombatPower) / RecommendPower,
            case data_dungeon:get_power_crush_r(DiffRatio) of
                [] -> [];
                CrushR -> [{dun_crush_r, CrushR}]
            end
    end.

% %% 获得战力碾压属性
% get_power_crush_attr(0, _RoleList, _RecommendPower) -> [];
% get_power_crush_attr(_IsUsePowerCrush, [], _RecommendPower) -> [];
% get_power_crush_attr(_IsUsePowerCrush, RoleList, RecommendPower) ->
%     CombatPowerSum = lists:sum([CombatPower||#dungeon_role{combat_power = CombatPower}<-RoleList]),
%     CombatPower = CombatPowerSum/length(RoleList),
%     Diff = CombatPower - RecommendPower,
%     case Diff >= 0 of
%         true -> [];
%         false ->
%             DiffRatio = (RecommendPower - CombatPower) / RecommendPower,
%             case data_dungeon:get_power_crush_r(DiffRatio) of
%                 [] -> [];
%                 CrushR -> [{dun_crush_r, CrushR}]
%             end
%     end.

%% 根据类型清理怪物
%% @param Satisfying:[#dungeon_wave,...]
clear_mon(State, SceneId, Satisfying) ->
    #dungeon_state{dun_id = DunId, scene_pool_id = ScenePoolId} = State,
    case data_dungeon:get_dungeon_clear(DunId, SceneId) of
        [] -> skip;
        #dungeon_clear_cfg{wave_list = WaveList, clear_mon_list = ClearMonList} ->
            F = fun(#dungeon_wave_subtype{type = WaveType, subtype = WaveSubtype, cycle_num = CycleNum}) ->
                % 只有首次循环才判断
                case CycleNum == 0 of
                    true -> lists:member({WaveType, WaveSubtype}, WaveList);
                    false -> false
                end
            end,
            case lists:any(F, Satisfying) of
                true -> lib_mon:clear_scene_mon_by_mids(SceneId, ScenePoolId, self(), 1, ClearMonList);
                false -> skip
            end
    end.

%% 获得刷怪时间
get_create_time_list(DunId, SceneId, WaveType, WaveSubtypeMap) ->
    F = fun(_Key, WaveSubtypeRecord, List) ->
        #dungeon_wave_subtype{subtype = WaveSubtype, mon_map = WaveMonMap, cycle_num = CycleNum, create_time = CreateTime} = WaveSubtypeRecord,
        #dungeon_wave{create_type = CreateType, cycle_num = MaxCycleNum, cycle_gap = CycleGap, die_gap = DieGap} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
        if
            MaxCycleNum == 0 -> List;
            CycleNum == 0 -> [CreateTime|List];  %%如果是第一波，则取第一波的刷新时间
            CycleNum >= MaxCycleNum -> List;
            CreateType == ?DUN_WAVE_CREATE_TYPE_CYCLE ->
                #dungeon_wave_mon{refresh_time = RefreshTime} = maps:get(CycleNum, WaveMonMap),
                [RefreshTime+CycleGap|List];
            CreateType == ?DUN_WAVE_CREATE_TYPE_MON_DIE ->
                #dungeon_wave_mon{mon_list = MonList, die_time = DieTime} = maps:get(CycleNum, WaveMonMap),
                F = fun({_TmpAutoId, _TmpMonId, IdDie}) -> IdDie == 1 end,
                case lists:all(F, MonList) of
                    true -> [DieTime+DieGap|List];
                    false -> List
                end;
            CreateType == ?DUN_WAVE_CREATE_TYPE_MAX_CYCLE_GAP ->
                #dungeon_wave_mon{mon_list = MonList, refresh_time = RefreshTime, die_time = DieTime} = maps:get(CycleNum, WaveMonMap),
                F = fun({_TmpAutoId, _TmpMonId, IdDie}) -> IdDie == 1 end,
                case lists:all(F, MonList) of
                    true ->
                        NextCreateTime = min(DieTime+DieGap, RefreshTime+CycleGap),
                        [NextCreateTime|List];
                    false ->
                        [RefreshTime+CycleGap|List]
                end;
            true ->
                List
        end
    end,
    CreateTimeList = maps:fold(F, [], WaveSubtypeMap),
    lists:sort(CreateTimeList).

%% 处理波数子类型刷出的事件
handle_wave_subtype_refresh([], _CommonEventId, State) -> State;
handle_wave_subtype_refresh([WaveSubtypeRecord|L], CommonEventId, State) ->
    #dungeon_wave_subtype{subtype = WaveSubtype} = WaveSubtypeRecord,
    NewState = lib_dungeon_event:handle_wave_subtype_refresh(State, CommonEventId, WaveSubtype),
    case lib_dungeon_event:handle_callback(NewState) of
        nothing -> NewState2 = NewState;
        {noreply, NewState2} -> ok
    end,
    handle_wave_subtype_refresh(L, CommonEventId, NewState2).

%% 处理空的怪物列表(注意会有递归create_dungeon_mon/2)
deal_empty_mon_list(State, CommonEvent, WaveSubtypeRecordList) ->
    #dungeon_state{dun_id = DunId} = State,
    #dungeon_common_event{id = CommonEventId, scene_id = SceneId} = CommonEvent,
    case is_commont_event_mon_all_die(DunId, CommonEvent) of
        true ->
            % ?INFO("#####deal_empty_mon_list:~p ~n", [CommonEventId]),
            NewState = lib_dungeon_event:handle_mon_event_id_kill_all_mon(State, CommonEvent),
            case lib_dungeon_event:handle_callback(NewState) of
                nothing -> NewState;
                {noreply, NewState2} -> NewState2
            end;
        false ->
            F = fun(#dungeon_wave_subtype{cycle_num = CycleId} = WaveSubtypeRecord) ->
                is_need_create_mon_by_kill_mon(WaveSubtypeRecord, CycleId, DunId, SceneId)
            end,
            % ?INFO("#####deal_empty_mon_list:~p ~n", [lists:any(F, WaveSubtypeRecordList)]),
            case lists:any(F, WaveSubtypeRecordList) of
                true -> create_dungeon_mon(State, CommonEventId);
                false -> State
            end
    end.

%% 击杀怪物
kill_mon(State, {mon_event, CommonEventId, WaveSubtype, CycleId, _MonAutoId} = CreateKey, MonId, Reason) ->
    IsExistMon = is_exist_mon_on_common_event(State, CreateKey),
    % ?INFO("kill_mon CreateKey:~p IsExistMon:~p is_end:~p is_level_end:~p callback_type:~p ~n",
    %     [CreateKey, IsExistMon, State#dungeon_state.is_end, State#dungeon_state.is_level_end, State#dungeon_state.callback_type]),
    if
        State#dungeon_state.is_end == ?DUN_IS_END_YES -> State;
        State#dungeon_state.is_level_end == ?DUN_IS_LEVEL_END_YES -> State;
        State#dungeon_state.callback_type == ?DUN_CALLBACK_TYPE_RESULT -> State;
        IsExistMon == false -> State;
        true ->
            BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
            #dungeon_state{dun_id = DunId, common_event_map = CommonEventMap, mon_score = MonScore, typical_data = TypicalData} = State,
            CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
            #dungeon_common_event{scene_id = SceneId, wave_subtype_map = WaveSubtypeMap} = CommonEvent,
            #dungeon_wave_subtype{mon_map = WaveMonMap} = WaveSubtypeRecord = maps:get(WaveSubtype, WaveSubtypeMap),
            #dungeon_wave_mon{mon_list = MonList} = WaveMonRecord = maps:get(CycleId, WaveMonMap),
            % ?INFO("kill_mon MonId:~p ismember:~p Value:~p MonList:~p ~n",
            %     [MonId, lists:keymember(CreateKey, 1, MonList), lists:keyfind(CreateKey, 1, MonList), MonList]),
            case lists:keyfind(CreateKey, 1, MonList) of
                {CreateKey, MonId, 0} ->
                    NewMonList = lists:keyreplace(CreateKey, 1, MonList, {CreateKey, MonId, 1}),
                    NewWaveMonRecord = WaveMonRecord#dungeon_wave_mon{mon_list = NewMonList, die_time = utime:longunixtime()},
                    NewWaveSubtypeRecord = WaveSubtypeRecord#dungeon_wave_subtype{mon_map = maps:put(CycleId, NewWaveMonRecord, WaveMonMap)},
                    NewCommonEvent = CommonEvent#dungeon_common_event{wave_subtype_map = maps:put(WaveSubtype, NewWaveSubtypeRecord, WaveSubtypeMap)},
                    NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
                    SkipMonNum = maps:get(?DUN_ROLE_SPECIAL_KEY_SKIP_MON_NUM, TypicalData, 0),
                    StateA = lib_dungeon_util:send_mon_num(State, NewCommonEvent),
                    if
                        Reason =/= killed ->
                            NewSkipMonNum = SkipMonNum + 1,
                            {ok, BinData} = pt_610:write(61040, [NewSkipMonNum]),
                            lib_dungeon_mod:send_msg(StateA, BinData),
                            AddMonScore = 0;
                        true ->
                            NewSkipMonNum = SkipMonNum,
                            case data_dungeon_grade:get_dungeon_score(DunId) of
                                [] -> AddMonScore = 0;
                                #dungeon_score{mon_score_list = MonScoreList} ->
                                    case lists:keyfind(MonId, 1, MonScoreList) of
                                        false -> AddMonScore = 0;
                                        {_MonId, AddMonScore0} ->
                                            AddMonScore = lib_dungeon_mod:calc_mon_score(StateA, AddMonScore0),
                                            {ok, BinData} = pt_610:write(61036, [MonScore + AddMonScore]),
                                            lib_dungeon_mod:send_msg(StateA, BinData)
                                    end
                            end
                    end,
                    NewTypicalData = TypicalData#{?DUN_ROLE_SPECIAL_KEY_SKIP_MON_NUM => NewSkipMonNum},
                    NewState = StateA#dungeon_state{common_event_map = NewCommonEventMap, mon_score = MonScore+AddMonScore, typical_data = NewTypicalData},
                    % ?INFO("#####kill_mon is_commont_event_mon_all_die:~p CommonEventId:~p NewCommonEvent:~w ~n",
                    %     [is_commont_event_mon_all_die(DunId, NewCommonEvent), CommonEventId, NewCommonEvent]),
                    case is_commont_event_mon_all_die(DunId, NewCommonEvent) of
                        true -> lib_dungeon_event:handle_mon_event_id_kill_all_mon(NewState, NewCommonEvent);
                        false ->
                            % ?INFO("#####kill_mon is_need_create_mon_by_kill_mon:~p ~n", [is_need_create_mon_by_kill_mon(NewWaveSubtypeRecord, CycleId, DunId, SceneId)]),
                            case is_need_create_mon_by_kill_mon(NewWaveSubtypeRecord, CycleId, DunId, SceneId) of
                                true -> create_dungeon_mon(NewState, CommonEventId);
                                false -> NewState
                            end
                    end;
                _R ->
                    % ?INFO("kill_mon _R:~p ~n", [_R]),
                    State
            end
    end;
kill_mon(State, _MonKey, _MonId, _Reason) ->
    State.

revive_mon(State, {mon_event, CommonEventId, WaveSubtype, CycleId, _MonAutoId} = CreateKey, MonId) ->
    IsExistMon = is_exist_mon_on_common_event(State, CreateKey),
    if
        State#dungeon_state.is_end == ?DUN_IS_END_YES -> State;
        State#dungeon_state.is_level_end == ?DUN_IS_LEVEL_END_YES -> State;
        State#dungeon_state.callback_type == ?DUN_CALLBACK_TYPE_RESULT -> State;
        IsExistMon == false -> State;
        true ->
            BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
            #dungeon_state{dun_id = DunId, common_event_map = CommonEventMap, mon_score = MonScore} = State,
            CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
            #dungeon_common_event{scene_id = SceneId, wave_subtype_map = WaveSubtypeMap} = CommonEvent,
            #dungeon_wave_subtype{mon_map = WaveMonMap, type = WaveType} = WaveSubtypeRecord = maps:get(WaveSubtype, WaveSubtypeMap),
            #dungeon_wave_mon{mon_list = MonList} = WaveMonRecord = maps:get(CycleId, WaveMonMap),
            % ?INFO("kill_mon isfalse:~p ~n", [lists:keyfind(CreateKey, 1, MonList)]),
            case lists:keyfind(CreateKey, 1, MonList) of
                {CreateKey, MonId, 1} ->
                    case revive_dungeon_mon_help(State, MonId, CreateKey, SceneId, WaveType, WaveSubtype) of
                        ok ->
                            NewMonList = lists:keyreplace(CreateKey, 1, MonList, {CreateKey, MonId, 0}),
                            NewWaveMonRecord = WaveMonRecord#dungeon_wave_mon{mon_list = NewMonList},
                            NewWaveSubtypeRecord = WaveSubtypeRecord#dungeon_wave_subtype{mon_map = maps:put(CycleId, NewWaveMonRecord, WaveMonMap)},
                            NewCommonEvent = CommonEvent#dungeon_common_event{wave_subtype_map = maps:put(WaveSubtype, NewWaveSubtypeRecord, WaveSubtypeMap)},
                            NewCommonEventMap = maps:put({BelongType, CommonEventId}, NewCommonEvent, CommonEventMap),
                            case data_dungeon_grade:get_dungeon_score(DunId) of
                                [] -> AddMonScore = 0;
                                #dungeon_score{mon_score_list = MonScoreList} ->
                                    case lists:keyfind(MonId, 1, MonScoreList) of
                                        false -> AddMonScore = 0;
                                        {_MonId, AddMonScore} -> ok
                                    end
                            end,
                            State#dungeon_state{common_event_map = NewCommonEventMap, mon_score = MonScore-AddMonScore};
                        _ ->
                            State
                    end;
                _ ->
                    State
            end
    end;

revive_mon(State, _MonKey, _MonId) ->
    State.

revive_dungeon_mon_help(#dungeon_state{now_scene_id = SceneId} = State, MonId2, MonKey, SceneId, WaveType, WaveSubtype) ->
    #dungeon_state{
        dun_id = DunId, scene_pool_id = ScenePoolId, role_list = RoleList, mon_helper = MonHelper, enter_lv = EnterLv,
        level = Level, typical_data = TypicalData, wave_num = WaveNum
        } = State,
    #dungeon_wave{
        scene_id = SceneId, mon_list = WaveMonList, xy_range = XyRange
        } = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
    MonIdReplace = maps:get(?DUN_STATE_SPCIAL_KEY_REPLACE_MON, TypicalData, []),
    #dungeon{dynamic_attr = DynamicAttr} = data_dungeon:get(DunId),
    CrushRAttr = get_power_crush_attr(DunId, WaveNum, RoleList),
    CommonDunR = maps:get(?DUN_STATE_SPCIAL_KEY_COMMON_DUNR, TypicalData, []),
    % 怪物生成
    #dungeon_mon_helper{hp_rate_map = HpRateMap} = MonHelper,
    case lists:keyfind(MonId2, 2, MonIdReplace) of
        {MonId, MonId2, ReplaceAttr} ->
            ok;
        {MonId, MonId2} ->
            ReplaceAttr = [];
        _ ->
            ReplaceAttr = [], MonId = MonId2
    end,
    case lists:keyfind(MonId, 1, WaveMonList) of
        {_, X, Y, _, Attrlist} ->
            {NewX, NewY} = xy_range(X, Y, XyRange),
            case data_mon:get(MonId) of
                [] -> MonType = 1;
                #mon{type = MonType} -> ok
            end,
            case maps:get(MonId, HpRateMap, []) of
                [] -> HpRateAttr = [];
                HpRateList -> HpRateAttr = [{dungeon_hp_rate, HpRateList}]
            end,
            case data_mon_dynamic:get_dungeon_mon_dynamic(MonId, DunId, Level) of
                [] -> DunrList = CommonDunR;
                #dungeon_mon_dynamic{ratio = Dunr} -> DunrList = [{dun_r, Dunr}]
            end,
            SumAttrList = ReplaceAttr ++ CrushRAttr++[{auto_lv, EnterLv}, {create_key, MonKey}, {type, MonType}]++Attrlist++HpRateAttr++DunrList++DynamicAttr,
            ?PRINT("guaiwu gen,~n", []),
            lib_mon:async_create_mon(MonId2, SceneId, ScenePoolId, NewX, NewY, MonType, self(), 1, SumAttrList),
            ok;
        _ ->
            error
    end.


%% 是否存在怪物在事件中.因为事件可能会被清理,重置了怪物属性
is_exist_mon_on_common_event(State, {mon_event, CommonEventId, WaveSubtype, CycleId, _MonAutoId} = CreateKey) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    case maps:get({?DUN_EVENT_BELONG_TYPE_MON, CommonEventId}, CommonEventMap, []) of
        [] -> false;
        #dungeon_common_event{wave_subtype_map = WaveSubtypeMap} ->
            case maps:get(WaveSubtype, WaveSubtypeMap, []) of
                [] -> false;
                #dungeon_wave_subtype{mon_map = WaveMonMap} ->
                    case maps:get(CycleId, WaveMonMap, []) of
                        [] -> false;
                        #dungeon_wave_mon{mon_list = MonList} -> lists:keymember(CreateKey, 1, MonList)
                    end
            end
    end.

%% 是否还存活的怪物
is_alive_mon_on_common_event(State, {mon_event, CommonEventId, WaveSubtype, CycleId, _MonAutoId} = CreateKey) ->
    #dungeon_state{common_event_map = CommonEventMap} = State,
    case maps:get({?DUN_EVENT_BELONG_TYPE_MON, CommonEventId}, CommonEventMap, []) of
        [] -> false;
        #dungeon_common_event{wave_subtype_map = WaveSubtypeMap} ->
            case maps:get(WaveSubtype, WaveSubtypeMap, []) of
                [] -> false;
                #dungeon_wave_subtype{mon_map = WaveMonMap} ->
                    case maps:get(CycleId, WaveMonMap, []) of
                        [] -> false;
                        #dungeon_wave_mon{mon_list = MonList} ->
                            case lists:keyfind(CreateKey, 1, MonList) of
                                {_, _, 0} ->
                                    true;
                                _ ->
                                    false
                            end
                    end
            end
    end.

%% 根据击杀怪物,是否需要重新刷一次怪物
is_need_create_mon_by_kill_mon(WaveSubtypeRecord, CycleId, DunId, SceneId) ->
    #dungeon_wave_subtype{type = WaveType, subtype = WaveSubtype, mon_map = WaveMonMap, cycle_num = CycleNum} = WaveSubtypeRecord,
    #dungeon_wave{create_type = CreateType, cycle_num = MaxCycleNum} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
    % ?INFO("#####is_need_create_mon_by_kill_mon CreateType:~p CycleNum:~p MaxCycleNum:~p ~n", [CreateType, CycleNum, MaxCycleNum]),
    if
        MaxCycleNum == 0 -> false;
        CycleId =/= CycleNum -> false;
        CycleNum >= MaxCycleNum -> false;
        CreateType == ?DUN_WAVE_CREATE_TYPE_MON_DIE orelse CreateType == ?DUN_WAVE_CREATE_TYPE_MAX_CYCLE_GAP ->
            WaveMonRecord = maps:get(CycleId, WaveMonMap),
            is_commont_event_mon_all_die_2([WaveMonRecord]);
        true -> false
    end.

%% 是否该事件的所有怪物都死亡(包括循环)
is_commont_event_mon_all_die(DunId, CommonEvent) ->
    #dungeon_common_event{scene_id = SceneId, wave_subtype_map = WaveSubtypeMap} = CommonEvent,
    RecordList = maps:values(WaveSubtypeMap),
    is_commont_event_mon_all_die_1(RecordList, DunId, SceneId).

%% @param [#dungeon_wave_subtype{},...]
is_commont_event_mon_all_die_1([], _DunId, _SceneId) -> true;
is_commont_event_mon_all_die_1([Record|L], DunId, SceneId) ->
    #dungeon_wave_subtype{type = WaveType, subtype = WaveSubtype, mon_map = WaveMonMap, cycle_num = CycleNum} = Record,
    #dungeon_wave{cycle_num = MaxCycleNum} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
    case CycleNum < MaxCycleNum of
        true -> false;
        false ->
            case is_commont_event_mon_all_die_2(maps:values(WaveMonMap)) of
                true -> is_commont_event_mon_all_die_1(L, DunId, SceneId);
                false -> false
            end
    end.

%% @param [#dungeon_wave_mon{},...]
is_commont_event_mon_all_die_2([]) -> true;
is_commont_event_mon_all_die_2([Record|L]) ->
    #dungeon_wave_mon{mon_list = MonList} = Record,
    F = fun({_TmpAutoId, _TmpMonId, IdDie}) -> IdDie == 1 end,
    case lists:all(F, MonList) of
        true -> is_commont_event_mon_all_die_2(L);
        false -> false
    end.

%% 每波已杀怪物数
get_already_dead_mon(_DunId, CommonEvent) ->
    #dungeon_common_event{wave_subtype_map = WaveSubtypeMap} = CommonEvent,
    RecordList = maps:values(WaveSubtypeMap),
    FA = fun(RecordA, DeadMonListA) ->
        #dungeon_wave_subtype{mon_map = WaveMonMap} = RecordA,
        FB = fun(RecordB, DeadMonListB) ->
            #dungeon_wave_mon{mon_list = MonList} = RecordB,
            FC = fun({TmpAutoId, TmpMonId, IdDie}, DeadMonListC) ->
                ?IF(IdDie =:= 1, [{TmpAutoId, TmpMonId, IdDie}] ++ DeadMonListC, DeadMonListC)
            end,
            lists:foldl(FC, DeadMonListB, MonList)
        end,
        lists:foldl(FB, DeadMonListA, maps:values(WaveMonMap))
    end,
    lists:foldl(FA, [], RecordList).

%% 怪物生成列表
get_generate_mon(_DunId, CommonEvent) ->
    #dungeon_common_event{wave_subtype_map = WaveSubtypeMap} = CommonEvent,
    RecordList = maps:values(WaveSubtypeMap),
    FA = fun(RecordA, GenerateMonListA) ->
        #dungeon_wave_subtype{mon_map = WaveMonMap} = RecordA,
        FB = fun(RecordB, _GenerateMonListB) ->
            #dungeon_wave_mon{mon_list = MonList} = RecordB,
            MonList
             end,
        lists:foldl(FB, GenerateMonListA, maps:values(WaveMonMap))
         end,
    lists:foldl(FA, [], RecordList).

handle_who_kill_mon(#dungeon_state{dun_type = DunType} = State, _MonId, DieDatas) ->
    case lists:keyfind(title, 1, DieDatas) of
        {title, Title} ->
            case data_dungeon:get_kill_eff(DunType, Title) of
                #dungeon_killeff_cfg{kill_count = TargetCount,is_serial = IsSerial,skill_id = SkillId,skill_lv = SkillLv,skill_way = SkillWay} ->
                    case lists:keyfind(killer, 1, DieDatas) of
                        {killer, PlayerId} ->
                            #dungeon_state{role_list = RoleList} = State,
                            case lists:keyfind(PlayerId, #dungeon_role.id, RoleList) of
                                #dungeon_role{typical_data = TypicalData} = R ->
                                    Key
                                    = if
                                        IsSerial =:= 1 ->
                                            last_kill_mon_title;
                                        true ->
                                            {last_kill_mon_title, Title}
                                    end,
                                    case maps:find(Key, TypicalData) of
                                        {ok, {Title, Count}} ->
                                            if
                                                Count + 1 >= TargetCount ->
                                                    #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
                                                    trigger_flag_skill(SceneId, ScenePoolId, PlayerId, SkillId, SkillLv, SkillWay),
                                                    NewTypicalData = maps:remove(Key, TypicalData);
                                                true ->
                                                    NewTypicalData = maps:put(Key, {Title, Count + 1}, TypicalData)
                                            end;
                                        _ ->
                                            NewTypicalData = maps:put(Key, {Title, 1}, TypicalData)
                                    end,
                                    R2 = R#dungeon_role{typical_data = NewTypicalData},
                                    RoleList2 = lists:keystore(PlayerId, #dungeon_role.id, RoleList, R2),
                                    State#dungeon_state{role_list = RoleList2};
                                _ ->
                                    State
                            end
                    end;
                _ ->
                    State
            end;
        _ ->
            State
    end.

trigger_flag_skill(SceneId, ScenePoolId, Id, SkillId, SkillLv, 1) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_skill_buff, add_buff, [Id, SkillId, SkillLv]);

trigger_flag_skill(SceneId, ScenePoolId, Id, SkillId, SkillLv, 2) ->
    % TargetArgs = [],
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_start_battle,
                                                                             [?BATTLE_SIGN_PLAYER, Id, find_target, SkillId, SkillLv, 0]).




%% -----------------------------------------------------------------
%% @desc     功能描述  设置刷怪事件的typical_data
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
set_typical_data(#dungeon_state{dun_type = DunType} = State,  CommonEventId) ->
    lib_dungeon_api:invoke(DunType,  dunex_set_typical_data, [State, CommonEventId], State).

%% -----------------------------------------------------------------
%% @desc     功能描述  特殊刷怪事件的消耗处理
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_create_mon_special_cost(DunType, RoleList) ->
    lib_dungeon_api:invoke(DunType,  dunex_handle_create_mon_special_cost, [RoleList], skip).

get_typcial_mon_msg(NewWaveMonList, TypicalData, DunType, RoleList) ->
    case maps:find(?DUN_ROLE_SPECIAL_KEY_CREATE_MON, TypicalData) of
        error ->
            {NewWaveMonList, TypicalData};
        {ok, _Mon} ->
%%            ?MYLOG("cym", "NewWaveMonList ~p~n", [NewWaveMonList]),
            _Map =  maps:remove(?DUN_ROLE_SPECIAL_KEY_CREATE_MON, TypicalData),
            case  NewWaveMonList of
                [] ->
                    {NewWaveMonList, TypicalData};
                _ ->
%%                    ?MYLOG("cym2", "NewWaveMonList ~p TypicalData ~p~n",  [NewWaveMonList, TypicalData]),
                    handle_create_mon_special_cost(DunType, RoleList),
                    {[_Mon | NewWaveMonList], _Map}
            end
    end.

%% 拾取怪物
pick_mon(State, DungeonRole, Mid, Coord, Skill) ->
    lib_dungeon_mod:pick_mon(State, DungeonRole, Mid, Coord, Skill).