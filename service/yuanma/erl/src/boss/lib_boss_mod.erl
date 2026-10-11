%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 25 Nov 2017 by root <root@localhost.localdomain>

-module(lib_boss_mod).

-compile(export_all).

-include("boss.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("custom_act.hrl").
-include("drop.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% 添加boss
add_boss(StatusMap, BossType, Boss) ->
    case maps:get(BossType, StatusMap, []) of
        [] -> ComStatus = #boss_common_status{boss_type = BossType, boss_map = #{Boss#boss_status.boss_id => Boss}};
        #boss_common_status{boss_map = BossMap} = OldComStatus ->
            ComStatus = OldComStatus#boss_common_status{boss_map = BossMap#{Boss#boss_status.boss_id => Boss}}
    end,
    maps:put(BossType, ComStatus, StatusMap).

%% 添加初始boss通用状态:定时器等等
%% 第一次初始化只初始了怪物,需要添加初始
append_init(State) ->
    #boss_state{common_status_map = ComStatusMap} = State,
    List = maps:to_list(ComStatusMap),
    ComStatusL = append_init_common_status(List, []),
    NewComStatusMap = maps:from_list(ComStatusL),
    State#boss_state{common_status_map = NewComStatusMap}.

%% 添加初始通用状态
append_init_common_status([], ComStatusL) -> ComStatusL;
append_init_common_status([{BossType, ComStatus}|T], ComStatusL) when
        BossType == ?BOSS_TYPE_OUTSIDE orelse BossType == ?BOSS_TYPE_ABYSS orelse
        BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE->
    NewComStatus = calc_fever(ComStatus),
    append_init_common_status(T, [{BossType, NewComStatus}|ComStatusL]);
append_init_common_status([H|T], ComStatusL) ->
    append_init_common_status(T, [H|ComStatusL]).

%% -----------------------------------------------------------------
%% 狂热处理
%% -----------------------------------------------------------------

%% 计算预热时间
calc_fever(State, BossType) ->
    #boss_state{common_status_map = ComStatusMap} = State,
    ComStatus = maps:get(BossType, ComStatusMap),
    NewComStatus = calc_fever(ComStatus),
    NewComStatusMap = maps:put(BossType, NewComStatus, ComStatusMap),
    NewState = State#boss_state{common_status_map = NewComStatusMap},
    {noreply, NewState}.

calc_fever(ComStatus) ->
    #boss_common_status{boss_type = BossType, fever_ref = OldFeverRef} = ComStatus,
    NowTime = utime:unixtime(),
    %% 计算下一个狂欢定时器的时间戳
    case calc_fever_ref_time(BossType, NowTime) of
        false ->
            % 凌晨重新计算
            Remain = max(86400-utime:get_seconds_from_midnight(), 30),
            Ref = util:send_after(OldFeverRef, Remain*1000, self(), {calc_fever, BossType});
        NextTime ->
            Ref = util:send_after(OldFeverRef, (NextTime-NowTime+2)*1000, self(), {fever_ref, BossType})
    end,
    ComStatus#boss_common_status{fever_ref = Ref}.

%% 计算下一个狂欢定时器的时间戳
calc_fever_ref_time(BossType, Time) ->
    TimeRange = ?BOSS_TYPE_KV_FEVER_TIME_RANGE(BossType),
    TimePre = ?BOSS_TYPE_KV_FEVER_TIME_PRE(BossType),
    do_calc_fever_ref_time(TimeRange, TimePre, Time).

do_calc_fever_ref_time([], _TimePre, _Time) -> false;
do_calc_fever_ref_time([{{H1, M1}, {_H2, _M2}}|T], TimePre, Time) ->
    {Date, _Time} = utime:unixtime_to_localtime(Time),
    StartTime = utime:unixtime({Date, {H1, M1, 0}}),
    NextTime = StartTime - TimePre,
    case Time < NextTime of
        true -> NextTime;
        false -> do_calc_fever_ref_time(T, TimePre, Time)
    end.

%% 是否在狂欢时间内
is_on_fever(BossType, Time) ->
    case calc_fever_time_range(BossType, Time) of
        {PreFeverSt, _StartTime, EndTime} -> Time >= PreFeverSt andalso Time =< EndTime;
        _ -> false
    end.

%% 计算最近的狂欢时间段
%% @return {狂热预热开始时间戳, 狂热开始时间戳, 狂热结束时间戳}
calc_fever_time_range(BossType, Time) ->
    TimeRange = ?BOSS_TYPE_KV_FEVER_TIME_RANGE(BossType),
    TimePre = ?BOSS_TYPE_KV_FEVER_TIME_PRE(BossType),
    do_calc_fever_time_range(TimeRange, TimePre, Time).

do_calc_fever_time_range([], _TimePre, _Time) -> false;
do_calc_fever_time_range([{{H1, M1}, {H2, M2}}|T], TimePre, Time) ->
    {Date, _Time} = utime:unixtime_to_localtime(Time),
    StartTime = utime:unixtime({Date, {H1, M1, 0}}),
    EndTime = utime:unixtime({Date, {H2, M2, 0}}),
    case Time =< EndTime of
        true -> {StartTime-TimePre, StartTime, EndTime};
        false -> do_calc_fever_time_range(T, TimePre, Time)
    end.

%% 狂热定时器
fever_ref(State, BossType) ->
    {noreply, NewState} = calc_fever(State, BossType),
    NewState2 = do_fever_ref(NewState, BossType),
    {noreply, NewState2}.

do_fever_ref(State, BossType) ->
    #boss_state{common_status_map = ComStatusMap} = State,
    ComStatus = maps:get(BossType, ComStatusMap),
    #boss_common_status{boss_map = BossMap} = ComStatus,
    NowTime = utime:unixtime(),
    {PreFeverSt, FeverSt, _FeverEt} = calc_fever_time_range(BossType, NowTime),
    F = fun(_BossId, Boss) ->
        #boss_status{reborn_time = RebornTime} = Boss,
        if
            RebornTime == 0 -> NewRebornTime = RebornTime;
            % 复活时间大于狂热时间 并且当前时间小于狂热开始时间大于狂热预热开始时间,把复活时间调整到狂热时间
            RebornTime > FeverSt andalso NowTime =< FeverSt andalso NowTime >= PreFeverSt -> NewRebornTime = FeverSt;
            true -> NewRebornTime = RebornTime
        end,
        NewBoss = Boss#boss_status{reborn_time = NewRebornTime},
        BossAfRemind = calc_boss_remind_ref(BossType, NewBoss),
        BossAfReborn = calc_boss_reborn_ref(BossType, BossAfRemind),
        case NewRebornTime =/= RebornTime of
            true -> send_boss_info(BossAfReborn);
            false -> skip
        end,
        BossAfReborn
    end,
    NewBossMap = maps:map(F, BossMap),
    NewComStatus = ComStatus#boss_common_status{boss_map = NewBossMap},
    NewComStatusMap = maps:put(BossType, NewComStatus, ComStatusMap),
    State#boss_state{common_status_map = NewComStatusMap}.

%% 计算怪物提醒定时器
calc_boss_remind_ref(_BossType, #boss_status{reborn_time = 0, remind_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#boss_status{remind_ref = undefined};
calc_boss_remind_ref(BossType, Boss) ->
    #boss_status{boss_id = BossId, reborn_time = RebornTime, remind_ref = OldRef} = Boss,
    RebornSpanTime = RebornTime - utime:unixtime(),
    util:cancel_timer(OldRef),
    RemindTime = calc_remind_time(BossType, RebornSpanTime),
    RemindRef = ?IF(RemindTime == undefined, undefined,
        util:send_after(OldRef, RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
    Boss#boss_status{remind_ref = RemindRef}.

%% 计算提醒的时间
calc_remind_time(BossType, RebornSpanTime) ->
    do_calc_remind_time(?BOSS_TYPE_KV_REVIVE_TV_LIST(BossType), RebornSpanTime).

do_calc_remind_time([], _RebornSpanTime) -> undefined;
do_calc_remind_time([{PreRemindTime, _TvId}|T], RebornSpanTime) ->
    RemindTime = max(0, RebornSpanTime - PreRemindTime),
    case RemindTime == 0 of
        true -> do_calc_remind_time(T, RebornSpanTime);
        false -> RemindTime
    end.

%% 计算怪物重生定时器
calc_boss_reborn_ref(_BossType, #boss_status{reborn_time = 0, reborn_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#boss_status{reborn_ref = undefined};
calc_boss_reborn_ref(BossType, Boss) ->
    #boss_status{boss_id = BossId, reborn_time = RebornTime, reborn_ref = OldRef} = Boss,
    RebornSpanTime = max(1, RebornTime - utime:unixtime()),
    RebornRef = util:send_after(OldRef, RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId}),
    Boss#boss_status{reborn_ref = RebornRef}.

%% -----------------------------------------------------------------
%% 复活/提示
%% -----------------------------------------------------------------

%% boss信息
send_boss_info(#boss_status{boss_id = BossId, reborn_time = RebornTime, num = Num}) ->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{type = BossType, scene = SceneId} ->
            {ok, BinData} = pt_460:write(46009, [BossType, BossId, RebornTime, Num]),
            lib_server_send:send_to_scene(SceneId, 0, BinData),
            ok;
        _ ->
            skip
    end.

%% (1)boss提醒:发传闻 (2)boss重生:发提示

%% boss提醒
boss_remind(State, BossType, BossId) ->
    {ok, ComStatusMap, ComStatus, BossMap, Boss} = get_status_map_info(State, BossType, BossId),
    #boss_status{remind_list = RemindList} = Boss,
    BossAfRemind = calc_boss_remind_ref(BossType, Boss),
    NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, BossAfRemind),
    MonName = lib_mon:get_name_by_mon_id(BossId),
    MonLv = lib_mon:get_lv_by_mon_id(BossId),
    #boss_cfg{scene = Scene, x = X, y = Y} = data_boss:get_boss_cfg(BossId),
    Args = [MonLv, MonName, Scene, X, Y, BossType],
    spawn(fun() -> send_boss_remind_tv(RemindList, Args) end),
    {noreply, NewState}.

send_boss_remind_tv([], _Args) -> skip;
send_boss_remind_tv([RoleId|RemindList], Args) ->
    lib_chat:send_TV({player, RoleId}, ?MOD_BOSS, 7, Args),
    send_boss_remind_tv(RemindList, Args).

%% boss重生
boss_reborn(State, ?BOSS_TYPE_FEAST, _BossId, CopyId) ->
    NewState = feast_boss_refresh(State, CopyId),
    {noreply, NewState};
boss_reborn(State, _BossType, _BossId, _CopyId) ->
    {noreply, State}.

%% boss重生
boss_reborn(State, BossType, BossId) ->
    {ok, ComStatusMap, ComStatus, BossMap, Boss} = get_status_map_info(State, BossType, BossId),
    #boss_status{remind_ref = RemindRef, reborn_ref = RebornRef, remind_list = RemindList} = Boss,
    % 重生把提醒定时器也关了
    util:cancel_timer(RemindRef),
    util:cancel_timer(RebornRef),
    #boss_cfg{scene = Scene, x = X, y = Y} = data_boss:get_boss_cfg(BossId),
    %% 先清怪物
    lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
    %% 再重新创建
    spawn(fun() ->
        send_boss_reborn_msg(RemindList, BossType, BossId)
    end),
    if
        BossType == ?BOSS_TYPE_FAIRYLAND ->
            Data = #fairyland_boss_data{times = 0, role_id = 0, time = 0},
            NewOtherMap = maps:put(fairyland_boss, Data, Boss#boss_status.other_map);
        true ->
            NewOtherMap = Boss#boss_status.other_map
    end,
    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
    NewBoss = Boss#boss_status{reborn_ref = undefined, reborn_time = 0, remind_ref = undefined, other_map = NewOtherMap},
    NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss),
    {noreply, NewState}.

send_boss_reborn_msg([], _BossType, _BossId) -> ok;
send_boss_reborn_msg([RoleId|RemindList], BossType, BossId) ->
    lib_server_send:send_to_uid(RoleId, pt_460, 46016, [BossType, BossId]),
    send_boss_reborn_msg(RemindList, BossType, BossId).

%% 获得StatusMap 信息
%% @return false | {ok, ComStatusMap, ComStatus, BossMap, Boss}
get_status_map_info(State, BossType, BossId) ->
    #boss_state{common_status_map = ComStatusMap} = State,
    case maps:get(BossType, ComStatusMap, []) of
        [] -> {false, ?ERRCODE(err460_no_boss_type)};
        #boss_common_status{boss_map = BossMap} = ComStatus ->
            case maps:get(BossId, BossMap, []) of
                [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
                Boss -> {ok, ComStatusMap, ComStatus, BossMap, Boss}
            end
    end.

%% 更新 status_map
update_status_map(State, ComStatusMap, #boss_common_status{boss_type = BossType} = ComStatus, BossMap, #boss_status{boss_id = BossId} = Boss) ->
    NewBossMap = maps:put(BossId, Boss, BossMap),
    NewComStatus = ComStatus#boss_common_status{boss_map = NewBossMap},
    NewComStatusMap = maps:put(BossType, NewComStatus, ComStatusMap),
    State#boss_state{common_status_map = NewComStatusMap}.

%% -----------------------------------------------------------------
%% 死亡/击杀
%% -----------------------------------------------------------------

%% 伤害
be_hurted(State, BossType, BossId, Hp, HpLim, RoleId, Hurt) when
        BossType == ?BOSS_TYPE_OUTSIDE;
        BossType == ?BOSS_TYPE_ABYSS ->
    case get_status_map_info(State, BossType, BossId) of
        {false, _ErrCode} -> {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, Boss} ->
            NewBoss = Boss#boss_status{hp = Hp, hp_lim = HpLim},
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss),
            #boss_state{boss_role_anger = RoleList} = NewState,
            case lists:keyfind(RoleId, #boss_role_anger.role_id, RoleList) of
                false -> NewRoleList = RoleList;
                #boss_role_anger{hurt = AddHurt} = Role ->
                    NewRole = Role#boss_role_anger{hurt = AddHurt+Hurt},
                    NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, NewRole)
            end,
            StateAfHurt = NewState#boss_state{boss_role_anger = NewRoleList},
            {noreply, StateAfHurt}
    end;
be_hurted(State, _BossType, _BossId, _Hp, _HpLim, _RoleId, _Hurt) ->
    {noreply, State}.


%% boss被击杀
boss_be_kill(#boss_state{common_status_map = CommMap} = State, ScenePoolId, BossType, _BossId, _AttrId, _AttrName, _BLWhos, _DX, _DY, _FirstAttr, MonArgs) when BossType == ?BOSS_TYPE_FEAST ->
%%  ?MYLOG("cym", "bekill ~p~n", [_BossId]),
    IsCrystal = lists:member(_BossId, lib_boss:get_feast_boss_crystal_mon_list()),
    if
        IsCrystal ->  %%水晶被打爆了 %%所有玩家离场->清理数据-> 不能再进入(用玩家黑名单)
            % ?MYLOG("cym", "Crystal ~p~n", [_BossId]),
            NewState = lib_boss_mod:feast_boss_crystal_die(MonArgs#mon_args.copy_id, State),
            {noreply, NewState};
        true ->
            #mon_args{copy_id = CopyId, id = AutoId, mid = MonCfgId, scene = Scene} = MonArgs,
            case maps:find(?BOSS_TYPE_FEAST, CommMap) of
                {ok, BossCommStatus} ->
                    NewBossCommStatus = create_feast_boss_box(BossCommStatus, Scene, ScenePoolId, CopyId, MonArgs#mon_args.x, MonArgs#mon_args.y, AutoId, MonCfgId),  %%生成宝箱
                    NewCommMap = maps:put(?BOSS_TYPE_FEAST, NewBossCommStatus, CommMap),
                    {noreply, State#boss_state{common_status_map = NewCommMap}};
                _ ->
                    {noreply, State}
            end
    end;

boss_be_kill(State, ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, FirstAttr, MonArgs) when BossType == ?BOSS_TYPE_FAIRYLAND ->
    #boss_state{online_num_map = OnlineNumMap} = State,
    case get_status_map_info(State, BossType, BossId) of
        {false, _ErrCode} -> {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, Boss} ->
            mod_boss_first_blood:boss_be_killed(BossId, BLWhos),
            NewBoss = boss_be_kill_help(OnlineNumMap, Boss, BossType, AttrId, AttrName, BLWhos, MonArgs),
            case data_boss:get_boss_extra_cfg(BossId) of
                {_,Condition} ->
                    case lists:keyfind(end_time, 1, Condition) of
                        {end_time, EndTime} -> skip;
                        _ -> EndTime = 0
                    end;
                _ ->EndTime = 0
            end,
            NowTime = utime:unixtime(),
            Data = #fairyland_boss_data{times = 0, role_id = FirstAttr#mon_atter.id, time = EndTime+NowTime},
            NewBoss1 = update_boss_data(NewBoss, Data),
            spawn(fun() -> db:execute(io_lib:format(?sql_fairyland_draw_replace, [BossId, FirstAttr#mon_atter.id, 0, EndTime+NowTime])) end),
            lib_player:apply_cast(FirstAttr#mon_atter.id, ?APPLY_CAST_SAVE, ?HAND_OFFLINE,
                            lib_boss, send_draw_data, [FirstAttr#mon_atter.id, BossId, EndTime+NowTime, 0, scene]),
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss1),
            % 掉落通知
            #boss_state{boss_role_anger = RoleList} = NewState,
            RoleIdL = [RoleId||#boss_role_anger{role_id = RoleId, boss_type = TmpBossType}<-RoleList,
                TmpBossType == BossType],
            MaxTired = lib_boss:get_entertimes_limit(BossType),
            BossTired = mod_daily:get_count(FirstAttr#mon_atter.id, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS, BossType),
            if
                BossTired < MaxTired ->
                    case data_boss:get_boss_cfg(BossId) of
                        #boss_cfg{scene = SceneId} ->
                            mod_daily:increment(FirstAttr#mon_atter.id, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS, BossType),
                            mod_scene_agent:update(SceneId, ScenePoolId, FirstAttr#mon_atter.id, [{fairyland_tired, BossTired + 1}]),
                            mon_drop(RoleIdL, FirstAttr, MonArgs, BossType, BossId),
                            NewBossTired = BossTired + 1;
                        _ ->
                            NewBossTired = MaxTired
                    end;
                true ->
                    NewBossTired = MaxTired
            end,
            lib_server_send:send_to_uid(FirstAttr#mon_atter.id, pt_460, 46011, [NewBossTired]),
            {noreply, NewState}
    end;

boss_be_kill(State, _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, _FirstAttr, MonArgs) when BossType == ?BOSS_TYPE_NEW_OUTSIDE->
    #boss_state{online_num_map = OnlineNumMap} = State,
    case get_status_map_info(State, BossType, BossId) of
        {false, _ErrCode} -> {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, Boss} ->
            mod_boss_first_blood:boss_be_killed(BossId, BLWhos),
            mod_boss:handle_activitycalen_kill([], AttrId, BLWhos, BossType),
            NewBoss = boss_be_kill_help(OnlineNumMap, Boss, BossType, AttrId, AttrName, BLWhos, MonArgs),
            RemindSql = <<"replace into boss_remind set role_id = ~p, boss_id = ~p">>,
            spawn(fun() -> db:execute(io_lib:format(RemindSql, [AttrId, BossId])) end),
            #boss_status{remind_list = RemindList} = NewBoss,
            RemindListAfLv = ?IF(lists:member(AttrId, RemindList), RemindList, [AttrId | RemindList]),
            RealNewBoss = NewBoss#boss_status{remind_list = RemindListAfLv},
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, RealNewBoss),
            % 掉落通知
            #boss_state{boss_role_anger = _RoleList} = NewState,
            % RoleIdL = [RoleId||#boss_role_anger{role_id = RoleId, boss_type = TmpBossType}<-RoleList,
            %     TmpBossType == BossType],
            %%%% 拾取归属未必是FirstAttr, 疲劳更新不在这里处理 : -> update_role_bosstired
            % BossTired = mod_daily:get_count(FirstAttr#mon_atter.id, ?MOD_BOSS, 0, BossType),
            % case data_boss:get_boss_cfg(BossId) of
            %     #boss_cfg{scene = _SceneId, drop_lv = _DropLv} ->
            %         mod_daily:increment(FirstAttr#mon_atter.id, ?MOD_BOSS, 0, BossType),
            %         % MonLv = lib_mon:get_lv_by_mon_id(BossId),
            %         % DisLv = FirstAttr#mon_atter.att_lv - MonLv,
            %         % %%走掉落流程，掉落等级在掉落里面有控制
            %         % if
            %         %     DisLv > 0 andalso DisLv > DropLv ->
            %         %         skip;
            %         %     true ->
            %         %         mon_drop(RoleIdL, FirstAttr, MonArgs, BossType, BossId)
            %         % end,
            %         lib_player:apply_cast(FirstAttr#mon_atter.id, ?APPLY_CAST_STATUS, lib_boss, try_to_updata_senen_data, [BossType]),
            %         NewBossTired = BossTired + 1;
            %     _ ->
            %         NewBossTired = BossTired
            % end,
            % lib_server_send:send_to_uid(FirstAttr#mon_atter.id, pt_460, 46011, [NewBossTired]),
            {noreply, NewState}
    end;

boss_be_kill(State, _ScenePoolId, BossType, BossId, AttrId, AttrName, BLWhos, _DX, _DY, FirstAttr, MonArgs) ->
    #boss_state{online_num_map = OnlineNumMap} = State,
    case get_status_map_info(State, BossType, BossId) of
        {false, _ErrCode} -> {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, Boss} ->
            mod_boss_first_blood:boss_be_killed(BossId, BLWhos),
            NewBoss = boss_be_kill_help(OnlineNumMap, Boss, BossType, AttrId, AttrName, BLWhos, MonArgs),
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss),
            % 掉落通知
            #boss_state{boss_role_anger = RoleList} = NewState,
            FilterRoleL = [TmpRole||#boss_role_anger{boss_type = TmpBossType, boss_id = TmpBossId} = TmpRole<-RoleList,
                TmpBossType == BossType, TmpBossId == BossId],
            if
                BossType == ?BOSS_TYPE_OUTSIDE ->
                    RoleIdL = [TmpRoleId||#boss_role_anger{role_id = TmpRoleId, hurt = Hurt, rob_count = RobCount, robbed_count = RobbedCount}<-FilterRoleL,
                        Hurt > 0 orelse RobCount > 0 orelse RobbedCount > 0];
                BossType == ?BOSS_TYPE_ABYSS ->
                    RoleIdL = [TmpRoleId||#boss_role_anger{role_id = TmpRoleId, boss_type = TmpBossType}<-RoleList,
                        TmpBossType == BossType];
                true ->
                    RoleIdL = [TmpRoleId||#boss_role_anger{role_id = TmpRoleId}<-FilterRoleL]
            end,
            mod_boss:handle_activitycalen_kill(RoleIdL, AttrId, BLWhos, BossType),
            #boss_cfg{drop_lv = DropLv} = data_boss:get_boss_cfg(BossId),
            MonLv = lib_mon:get_lv_by_mon_id(BossId),
            DisLv = FirstAttr#mon_atter.att_lv - MonLv,
            if
                DisLv > 0 andalso DisLv > DropLv ->
                    skip;
                true ->
                    mon_drop(RoleIdL, FirstAttr, MonArgs, BossType, BossId)
            end,
            % mon_drop(RoleIdL, FirstAttr, MonArgs, BossType, BossId),
            % 玩家定时器处理
            if
                BossType == ?BOSS_TYPE_ABYSS ->
                    NewRoleList = RoleList;
                true ->
                    F = fun(#boss_role_anger{role_id = TmpRoleId}, TmpRoleList) ->
                        Role = #boss_role_anger{anger_ref = OldRef} = lists:keyfind(TmpRoleId, #boss_role_anger.role_id, TmpRoleList),
                        Ref = util:send_after(OldRef, ?BOSS_TYPE_KV_END_OUT_TIME(BossType)*1000, self(), {leave_ref, TmpRoleId, BossType, BossId}),
                        NewRole = Role#boss_role_anger{anger_ref = Ref},
                        lists:keystore(TmpRoleId, #boss_role_anger.role_id, TmpRoleList, NewRole)
                    end,
                    NewRoleList = lists:foldl(F, RoleList, FilterRoleL)
            end,
            NewState2 = NewState#boss_state{boss_role_anger = NewRoleList},
            {noreply, NewState2}
    end.


boss_be_kill_help(OnlineNumMap, Boss, BossType, AttrId, AttrName, BLWhos, _MonArgs) ->
    #boss_status{boss_id = BossId, kill_log = KillLog, num = Num} = Boss,
    NowTime = utime:unixtime(),
    NewKillLog = [{NowTime, AttrId, AttrName} | KillLog],
    %% 计算重生时间和提醒时间
    #boss_cfg{reborn_time = RebornTimes} = data_boss:get_boss_cfg(BossId),
    TemRebornTime = mod_boss:get_reborn_time(RebornTimes),
    % Discount = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
    % RebornTime = TemRebornTime * Discount div 100,
    RebornTime_2 = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
    if
        RebornTime_2 == 0 ->
            RebornTime = TemRebornTime;
        true ->
            RebornTime = RebornTime_2
    end,
    % ?MYLOG("xlh", "boss_be_kill OnlineNumMap:~p, {BossType,BossId}:~p, Discount:~p,TemRebornTime:~p,
    %                 RebornTime:~p ~n",[OnlineNumMap,{BossType,BossId},Discount,TemRebornTime,RebornTime]),
    %% 是否处于狂热时间内
    case is_on_fever(BossType, NowTime) of
        true -> NewRebornTime = max(round(RebornTime * ?BOSS_TYPE_KV_FEVER_REVIVE_RATIO(BossType)), 1);
        false -> NewRebornTime = RebornTime
    end,
    RebornEndTime = NowTime + NewRebornTime,
    spawn(fun() -> mod_boss:update_boss_reborn_time(BossId, RebornEndTime) end),
    NewBoss = Boss#boss_status{reborn_time = RebornEndTime, kill_log = NewKillLog},
    BossAfRemind = calc_boss_remind_ref(BossType, NewBoss),
    BossAfReborn = calc_boss_reborn_ref(BossType, BossAfRemind),
    % 自动关注处理
    AutoRemindTypes = [?BOSS_TYPE_ABYSS],
    #boss_status{remind_list = RemindList, no_auto_remind_list = NoAutoList} = BossAfReborn,
    case {lists:member(AttrId, NoAutoList), lists:member(BossType, AutoRemindTypes)} of
        {false, true} ->
            % 入库
            RemindSql = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p, auto_remind = ~p">>,
            spawn(fun() -> db:execute(io_lib:format(RemindSql, [AttrId, BossId, ?REMIND, ?AUTO_REMIND])) end),
            % boss状态更新
            RemindListAfLv = ?IF(lists:member(AttrId, RemindList), RemindList, [AttrId | RemindList]),
            AutoRemindBoss = BossAfReborn#boss_status{remind_list = RemindListAfLv},
            % 反馈
            lib_server_send:send_to_uid(AttrId, pt_460, 46007, [?SUCCESS, BossType, BossId, ?REMIND, 1]);
        _ ->
            AutoRemindBoss = BossAfReborn
    end,
    %% 广播boss死亡信息
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, max(0, Num - 1)]),
    lib_server_send:send_to_all(Bin),
    %% 事件触发
    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
    [lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
    %% 成就触发
    lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
    [begin
        case P#mon_atter.hurt > 0 of
            true ->
                %% Boss转盘
                lib_boss_rotary:boss_be_kill(P#mon_atter.id, BossType, BossId);
            _ ->
                ok
        end
    end || P <- BLWhos],
    %% 玩家击杀和日志
    case [P#mon_atter.id || P <- BLWhos] of
        [] -> lib_log_api:log_boss(BossType, BossId, AttrId, "[]", NowTime);
        BLIds ->
            StrBLIds = util:term_to_string(BLIds),
            lib_log_api:log_boss(BossType, BossId, AttrId, StrBLIds, NowTime),
            if
                % BossType == ?BOSS_TYPE_OUTSIDE ->
                %     [begin
                %         %% 成就触发
                %         lib_player:apply_cast(BlId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId])
                %     end || BlId <- BLIds];
                BossType == ?BOSS_TYPE_ABYSS orelse BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_OUTSIDE->
                    [begin
                        lib_demons_api:boss_be_kill(BlId, BossType, BossId)
                    end || BlId <- BLIds];
                true ->
                    [begin
                        %% 宝宝任务
                        lib_baby_api:boss_be_kill(BlId, BossType, BossId),
                        lib_demons_api:boss_be_kill(BlId, BossType, BossId)
                    end || BlId <- BLIds]
            end
    end,
    AutoRemindBoss.

%% 掉落处理
mon_drop(RoleIdL, FirstAttr, MonArgs, BossType, BossId) ->
    case FirstAttr of
        #mon_atter{id = FirstId} -> ok;
        _ -> FirstId = 0
    end,
    [lib_player:apply_cast(TmpRoleId, ?APPLY_CAST_SAVE, lib_boss, mon_drop, [FirstId, MonArgs, BossType, BossId])
        || TmpRoleId <- RoleIdL],
    ok.

%% 离开定时器
leave_ref(State, RoleId, BossType, BossId) ->
    #boss_state{boss_role_anger = BossRoleAnger, other_map = OtherMap} = State,
    NowTime =utime:unixtime(),
    BossCfg = data_boss:get_boss_cfg(BossId),
    case BossCfg of
        #boss_cfg{scene = Scene} ->skip;
        _ ->
            ?ERR("MISS BossCfg BossType:~p,BossId:~p~n",[BossType,BossId]),
            Scene = 0
    end,
    StayTime = case maps:get({enter_time, BossType, Scene, RoleId}, OtherMap) of
        EnterTime when is_integer(EnterTime) andalso EnterTime > 0 -> NowTime - EnterTime;
        _ErrCode -> ?ERR("_ErrCode:~p ,in boss_state other_map~n",[_ErrCode]), 0
    end,
    NewOtherMap = maps:remove({enter_time, BossType, Scene, RoleId}, OtherMap),
    NewState = State#boss_state{other_map = NewOtherMap},
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, leave_ref, [BossType, BossId, StayTime]),
            {noreply, NewState};
        #boss_role_anger{anger_ref = AngerTickoutRef} ->
            util:cancel_timer(AngerTickoutRef),
            NewBossRoleAnger = lists:keydelete(RoleId, #boss_role_anger.role_id, BossRoleAnger),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, leave_ref, [BossType, BossId, StayTime]),
            {noreply, NewState#boss_state{boss_role_anger = NewBossRoleAnger}}
    end.

%% 等级提升
lv_up(State, RoleId, Lv) ->
    #boss_state{common_status_map = ComStatusMap} = State,
    F = fun
        (BossType, ComStatus) when
                BossType == ?BOSS_TYPE_OUTSIDE ->
                % orelse BossType == ?BOSS_TYPE_ABYSS  ->
            #boss_common_status{boss_map = BossMap} = ComStatus,
            KeyList = maps:keys(BossMap),
            F2 = fun(BossId, {TemMap, Acc, Acc1}) ->
                case maps:get(BossId, TemMap, []) of
                    #boss_status{remind_list = RemindList} = Boss ->
                        #boss_cfg{condition = Condition} = data_boss:get_boss_cfg(BossId),
                        % UnRemindSql = <<"delete from boss_remind where role_id = ~p and boss_id = ~p">>,
                        % 取消关注的等级
                        UnRemindLv = Lv - 100,
                        case lists:keyfind(lv, 1, Condition) of
                            {lv, Lv} when Lv >= 120 ->  % 只有大于等于120级才会自动关注
                                case lists:member(RoleId, RemindList) of
                                    true ->
                                        NewAcc1 = Acc1,
                                        NewAcc = Acc, RemindListAfLv = RemindList;
                                    false ->
                                        NewAcc = [[RoleId, BossId]|Acc],
                                        NewAcc1 = Acc1,
                                        RemindListAfLv = [RoleId | RemindList]
                                end;
                            {lv, UnRemindLv} ->
                                case lists:member(RoleId, RemindList) of
                                    true ->
                                        % spawn(fun() -> db:execute(io_lib:format(UnRemindSql, [RoleId, BossId])) end),
                                        NewAcc1 = [BossId|lists:delete(BossId, Acc1)],
                                        NewAcc = Acc, RemindListAfLv = lists:delete(RoleId, RemindList);
                                    false ->
                                        NewAcc1 = Acc1,
                                        NewAcc = Acc, RemindListAfLv = RemindList
                                end;
                            _ ->
                                NewAcc1 = Acc1,
                                NewAcc = Acc, RemindListAfLv = RemindList
                        end,
                        % 最大等级也取消关注
                        case lists:keyfind(max_lv, 1, Condition) of
                            {max_lv, MaxLv} when Lv > MaxLv ->
                                case lists:member(RoleId, RemindListAfLv) of
                                    true ->
                                        % spawn(fun() -> db:execute(io_lib:format(UnRemindSql, [RoleId, BossId])) end),
                                        NAcc1 = [BossId|lists:delete(BossId, NewAcc1)],
                                        RemindListAfMaxLv = lists:delete(RoleId, RemindListAfLv);
                                    false ->
                                        NAcc1 = NewAcc1,
                                        RemindListAfMaxLv = RemindListAfLv
                                end;
                            _ ->
                                NAcc1 = NewAcc1,
                                RemindListAfMaxLv = RemindListAfLv
                        end,
                        NewBoss = Boss#boss_status{remind_list = RemindListAfMaxLv},
                        {maps:put(BossId, NewBoss, TemMap), NewAcc, NAcc1};
                    _ ->
                        {TemMap, Acc, Acc1}
                end
            end,
            {NewBossMap, ReplaceList, BossIdL} = lists:foldl(F2, {BossMap, [], []}, KeyList),
            ReplaceList =/= [] andalso db:execute(usql:replace(boss_remind, [role_id, boss_id], ReplaceList)),
            if
                BossIdL =/= [] ->
                    Sql1 = list_to_binary(
                        "delete from `boss_remind` " ++ usql:condition({boss_id, in, BossIdL}) ++ " and `role_id` = ~p"
                    ),
                    Sql = io_lib:format(Sql1, [RoleId]),
                    db:execute(Sql);
                true ->
                    skip
            end,
            ComStatus#boss_common_status{boss_map = NewBossMap};
        (BossType, ComStatus) when BossType == ?BOSS_TYPE_NEW_OUTSIDE->
            Layers = data_boss:get_all_layers_by_type(BossType),
            #boss_common_status{boss_map = BossMap} = ComStatus,
            NewLayers = lists:sort(Layers),
            Fun = fun(Layer, Acc) ->
                Condition = data_boss:get_enter_lv(BossType, Layer),
                % case lists:keyfind(lv, 1, Acc) of
                %     {lv, PreLv, _Layer} -> skip;
                %     _ -> PreLv = 0
                % end,
                case lists:keyfind(lv, 1, Condition) of
                    % {lv, LimitLv} when Lv > LimitLv andalso Lv > PreLv  ->
                    {lv, LimitLv} when Lv == LimitLv ->
                        [{lv, LimitLv, Layer}];
                    _ -> Acc
                end
            end,
            List = lists:foldl(Fun, [], NewLayers),
            case List of
                [{lv, _LimitLv, Layer}|_] ->
                    BossIds = data_boss:get_boss_same_layers(BossType, Layer);
                _ ->
                    BossIds = []
            end,
            Fun1 = fun(TemBossId, Acc) ->
                MonLv = lib_mon:get_lv_by_mon_id(TemBossId),
                [{TemBossId, MonLv}|Acc]
            end,
            Infos = lists:foldl(Fun1, [], BossIds),
            NewInfos = lists:keysort(2, Infos),
            KeyList = maps:keys(BossMap),
            F2 = fun(BossId, {TemMap, Acc, Acc1}) when BossIds =/= [] ->
                case maps:get(BossId, TemMap, []) of
                    #boss_status{remind_list = RemindList} = Boss ->
                        case lists:member(BossId, BossIds) of
                            false ->
                                % UnRemindSql = <<"delete from boss_remind where role_id = ~p and boss_id = ~p">>,
                                % spawn(fun() -> db:execute(io_lib:format(UnRemindSql, [RoleId, BossId])) end),
                                case lists:member(RoleId, RemindList) of
                                    true ->
                                        NewAcc1 = [BossId|Acc1];
                                    _ ->
                                        NewAcc1 = Acc1
                                end,
                                NewAcc = Acc, RemindListAfLv = lists:delete(RoleId, RemindList);
                            true ->
                                RemindBossids = lists:sublist(NewInfos, 3),
                                case lists:keyfind(BossId, 1, RemindBossids) of
                                    {BossId, _} ->
                                        % RemindSql = <<"replace into boss_remind set role_id = ~p, boss_id = ~p">>,
                                        % spawn(fun() -> db:execute(io_lib:format(RemindSql, [RoleId, BossId])) end),
                                        NewAcc1 = Acc1,
                                        NewAcc = [[RoleId, BossId]|Acc], RemindListAfLv = [RoleId | RemindList];
                                    _ ->
                                        NewAcc1 = Acc1,
                                        NewAcc = Acc, RemindListAfLv = RemindList
                                end
                        end,
                        NewBoss = Boss#boss_status{remind_list = RemindListAfLv},
                        {maps:put(BossId, NewBoss, TemMap), NewAcc, NewAcc1};
                    _E ->
                        {TemMap, Acc, Acc1}
                end;
                (_BossId, Acc) -> Acc
            end,
            {NewBossMap, ReplaceList, BossIdList} = lists:foldl(F2, {BossMap, [], []}, KeyList),
            % ?PRINT("============= ReplaceList:~p, DeleteList:~p~n",[ReplaceList, DeleteList]),
            ReplaceList =/= [] andalso db:execute(usql:replace(boss_remind, [role_id, boss_id], ReplaceList)),
            if
                BossIdList =/= [] ->
                    Sql1 = list_to_binary(
                        "delete from `boss_remind` " ++ usql:condition({boss_id, in, BossIdList}) ++ " and `role_id` = ~p"
                    ),
                    Sql = io_lib:format(Sql1, [RoleId]),
                    db:execute(Sql);
                true ->
                    skip
            end,
            ComStatus#boss_common_status{boss_map = NewBossMap};
        (_BossType, ComStatus) ->
            ComStatus
    end,
    NewState = State#boss_state{common_status_map = maps:map(F, ComStatusMap)},
    {noreply, NewState}.

%% 玩家死亡
player_die(State, SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, DerGuildId, DerName, DerMaskId, X, Y) ->
    NowTime = utime:unixtime(),
    #boss_state{boss_role_anger = RoleList} = State,
    case lists:keyfind(AtterId, #boss_role_anger.role_id, RoleList) of
        #boss_role_anger{boss_type = BossType, dkill = Dkill} = AtterRole when
                BossType == ?BOSS_TYPE_OUTSIDE;
                BossType == ?BOSS_TYPE_ABYSS ->
            NewDkill = Dkill+1,
            NewAtterRole = AtterRole#boss_role_anger{dkill = NewDkill},
            NewRoleList = lists:keystore(AtterId, #boss_role_anger.role_id, RoleList, NewAtterRole),
            mod_scene_agent:apply_cast(SceneId, 0, ?MODULE, dkill_notice, [AtterId, NewDkill]);
        _ ->
            NewRoleList = RoleList
    end,
    case lists:keyfind(DieId, #boss_role_anger.role_id, NewRoleList) of
        #boss_role_anger{boss_type = BossType2, bekill_count = BeKillTime} = DieRole when
        BossType2 == ?BOSS_TYPE_OUTSIDE; BossType2 == ?BOSS_TYPE_ABYSS; BossType2 == ?BOSS_TYPE_NEW_OUTSIDE;
        BossType2 == ?BOSS_TYPE_SPECIAL ->
            if
                BossType2 == ?BOSS_TYPE_NEW_OUTSIDE; BossType2 == ?BOSS_TYPE_SPECIAL ->
                    lib_player:apply_cast(DieId, ?APPLY_CAST_SAVE, lib_boss,
                                update_role_boss, [?BOSS_TYPE_NEW_OUTSIDE,NowTime]),
                    NewDieRole = DieRole#boss_role_anger{dkill = 0, bekill_count = [NowTime|BeKillTime]};
                true ->
                    NewDieRole = DieRole#boss_role_anger{dkill = 0}
            end,
            NewRoleList2 = lists:keystore(DieId, #boss_role_anger.role_id, NewRoleList, NewDieRole);
        _ ->
            case data_scene:get(SceneId) of%% 特殊boss特殊处理死亡debuff 只有第一次进入的是特殊层才会执行
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_SPECIAL_BOSS-> %% 特殊boss特殊处理
                    lib_player:apply_cast(DieId, ?APPLY_CAST_SAVE, lib_boss,
                            update_role_boss, [?BOSS_TYPE_NEW_OUTSIDE, NowTime]),
                    NewDieRole = #boss_role_anger{role_id = DieId, boss_type = ?BOSS_TYPE_NEW_OUTSIDE, dkill = 0, bekill_count = [NowTime]},
                    NewRoleList2 = lists:keystore(DieId, #boss_role_anger.role_id, NewRoleList, NewDieRole);
                _ ->
                    NewRoleList2 = NewRoleList
            end
    end,
    EnterBossType = lib_boss:get_boss_type_by_scene(SceneId),
    case AtterSign == ?BATTLE_SIGN_PLAYER andalso lists:member(EnterBossType, [?BOSS_TYPE_ABYSS, ?BOSS_TYPE_NEW_OUTSIDE]) of
        true ->
            BossTypeName = data_boss:get_boss_type_name(EnterBossType),
            case data_boss:get_boss_by_scene(EnterBossType, SceneId) of
                [{BossId, Layer}|_] when DerGuildId > 0 andalso DerMaskId == 0 ->
                    %% 被杀时没有进行蒙面，发传闻
                    WrapAtterName = lib_player:get_wrap_role_name(AtterName, [AttMaskId]),
                    if
                        Layer == 0 andalso EnterBossType == ?BOSS_TYPE_ABYSS ->
                            lib_chat:send_TV({guild, DerGuildId}, ?MOD_BOSS, 21, [DerName, util:make_sure_binary(BossTypeName), WrapAtterName, EnterBossType, BossId, SceneId, X, Y]);
                        true ->
                            lib_chat:send_TV({guild, DerGuildId}, ?MOD_BOSS, 14, [DerName, util:make_sure_binary(BossTypeName), Layer, WrapAtterName, EnterBossType, BossId, SceneId, X, Y])
                    end;
                _ -> skip
            end,
            case AtterGuildId > 0 andalso AttMaskId == 0 of
                true -> %% 自己没有蒙面，广播一下击杀传闻
                    WrapDerName = lib_player:get_wrap_role_name(DerName, [DerMaskId]),
                    lib_chat:send_TV({guild, AtterGuildId}, ?MOD_BOSS, 16, [AtterName, util:make_sure_binary(BossTypeName), WrapDerName]);
                _ -> skip
            end;
        _ -> skip
    end,
    NewState = State#boss_state{boss_role_anger = NewRoleList2},
    {noreply, NewState}.

%% 依据死亡次数以及当前时间计算死亡等待时间
count_die_wait_time(DieTimes, NowTime) ->
    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, die_wait_time) of
        [{min_times, MinTimes},{special, SpecialList},{extra, WaitTime}]  ->
            RebornTime = if
                DieTimes =< MinTimes ->
                    NowTime;
                true ->
                    case lists:keyfind(DieTimes, 1, SpecialList) of
                        {DieTimes, WaitTime1} ->
                            NowTime + WaitTime1;
                        _ ->
                            NowTime + WaitTime
                    end
            end,
            RebornTime;
        _ -> MinTimes = 0, RebornTime = NowTime
    end,
    {RebornTime, MinTimes}.

%% 连杀通知
dkill_notice(RoleId, Dkill) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{figure = Figure, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId} ->
            {ok, BinData} = pt_460:write(46024, [RoleId, Figure, Dkill]),
            lib_server_send:send_to_scene(SceneId, PoolId, CopyId, BinData);
        _ ->
            skip
    end.

%% 增加抢夺次数
add_rob_count(State, _BossType, _BossId, RoleId) ->
    #boss_state{boss_role_anger = RoleList} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, RoleList) of
        false -> NewRoleList = RoleList;
        #boss_role_anger{rob_count = RobCount} = OldRole ->
            Role = OldRole#boss_role_anger{rob_count = RobCount+1},
            NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, Role)
    end,
    State#boss_state{boss_role_anger = NewRoleList}.

%% 增加抢夺次数
add_robbed_count(State, _BossType, _BossId, RoleId) ->
    #boss_state{boss_role_anger = RoleList} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, RoleList) of
        false -> NewRoleList = RoleList;
        #boss_role_anger{robbed_count = RobbedCount} = OldRole ->
            Role = OldRole#boss_role_anger{robbed_count = RobbedCount+1},
            NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, Role)
    end,
    State#boss_state{boss_role_anger = NewRoleList}.

%% -----------------------------------------------------------------
%% 玩家操作 : 关注/取消关注
%% -----------------------------------------------------------------

%% 发送boss信息
get_boss_info(State, RoleId, Sid, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes) ->
    case maps:get(BossType, State#boss_state.common_status_map, null) of
        null -> skip;
        #boss_common_status{boss_map = BossMap} ->
            Fun = fun
                (BossId, _, TL) when BossType == ?BOSS_TYPE_PERSONAL ->
                    [{BossId, 0, 0, 0, ?AUTO_REMIND} | TL];
                (BossId, #boss_status{reborn_time = RebornTime, remind_list = RemindList, no_auto_remind_list = NoAutoList, num = Num}, TL) ->
                    AutoRemind = ?IF(lists:member(RoleId, NoAutoList), ?NO_AUTO_REMIND, ?AUTO_REMIND),
                    [{BossId, Num, RebornTime, ?IF(lists:member(RoleId, RemindList), 1, 0), AutoRemind} | TL]
            end,
            BossInfos = maps:fold(Fun, [], BossMap),
            lib_server_send:send_to_sid(Sid, pt_460, 46000, [BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes, BossInfos])
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述 进入节日boss
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
enter(State, RoleId, ?BOSS_TYPE_FEAST, _) ->
%%  ?MYLOG("cym", "enter ~n", []),
    #boss_state{common_status_map = CommonStatusMap, boss_role_anger = RoleList} = State,
    BossCommonStatus = maps:get(?BOSS_TYPE_FEAST, CommonStatusMap, #boss_common_status{boss_type = ?BOSS_TYPE_FEAST, other_map = #{?feast_boss_max_copy_id =>0}}),
    #boss_common_status{other_map = OtherMap, copy_msg = CopyMsg} = BossCommonStatus,
    OverRoleList = maps:get(?feast_boss_over_role, OtherMap, []),
    RoleCopy = maps:get(role_copy, OtherMap, #{}),  %%玩家和房间的绑定
%%    ?MYLOG("cym",  "RoleCopy ~p~n",  [RoleCopy]),
    OldCopyId = maps:get(RoleId, RoleCopy, -1),
    case  lists:member(RoleId, OverRoleList) of
        true -> %%已经参加过活动了
%%            ?MYLOG("cym",  "u over ~p overlist ~p~n",  [RoleId,  OverRoleList]),
            lib_server_send:send_to_uid(RoleId, pt_460, 46003, [?ERRCODE(feast_boss_box_game_over)]),
            {noreply, State};
        false ->
            {NewCopyMsg, MaxCopyId, NewCopyId} = handle_feast_boss_enter(RoleId, CopyMsg, maps:get(?feast_boss_max_copy_id, OtherMap, 0), OldCopyId),  %%进入房间 ，获取新的房间信息，和最大房间id
            NewRoleCopy = maps:put(RoleId, NewCopyId, RoleCopy),
            OtherMap1 = maps:put(?feast_boss_max_copy_id, MaxCopyId, OtherMap),
            OtherMap2 = maps:put(role_copy, NewRoleCopy, OtherMap1),
            NewBossCommonStatus = BossCommonStatus#boss_common_status{other_map = OtherMap2, copy_msg = NewCopyMsg},
            NewCommonStatusMap = maps:put(?BOSS_TYPE_FEAST, NewBossCommonStatus, CommonStatusMap),
            Role = #boss_role_anger{boss_type = ?BOSS_TYPE_FEAST, role_id = RoleId},  %%玩家信息
            NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, Role),
            {noreply, State#boss_state{common_status_map = NewCommonStatusMap, boss_role_anger = NewRoleList}}  %%组装数据
    end;



%% 进入
enter(State, RoleId, BossType, BossId) ->
    #boss_state{boss_role_anger = BossRoleAnger} = State,
    % ?PRINT("###RoleId:~p,####,BossRoleAnger:~p~n",[RoleId,BossRoleAnger]),
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false -> Role = #boss_role_anger{role_id = RoleId, boss_type = BossType, boss_id = BossId};
        #boss_role_anger{anger_ref = OldRef} = OldRole ->
            util:cancel_timer(OldRef),
            Role = OldRole#boss_role_anger{boss_type = BossType, boss_id = BossId, anger = 0, step = 0,
                time = 0, anger_ref = undefined}
    end,
    NewBossRoleAnger = lists:keystore(RoleId, #boss_role_anger.role_id, BossRoleAnger, Role),
    % ?PRINT("NewBossRoleAnger:~p~n",[NewBossRoleAnger]),
    {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger}}.

%% 发送击杀日志
get_boss_kill_log(State, Sid, BossType, BossId) ->
    case get_status_map_info(State, BossType, BossId) of
        {false, _ErrCode} -> KillLog = [];
        {ok, _ComStatusMap, _ComStatus, _BossMap, #boss_status{kill_log = KillLog}} -> ok
    end,
    lib_server_send:send_to_sid(Sid, pt_460, 46001, [KillLog]),
    {noreply, State}.

%% boss关注/取消关注
boss_remind_op(State, RoleId, BossType, BossId, Remind, IsAuto) when BossType == ?BOSS_TYPE_FAIRYLAND ->
    RemindNum = mod_counter:get_count(RoleId, ?MOD_BOSS, BossType),
    case get_status_map_info(State, BossType, BossId) of
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [ErrCode, BossType, BossId, Remind, IsAuto]),
            {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, #boss_status{remind_list = RemindList} = Boss} ->
            IsInRemind = lists:member(RoleId, RemindList),
            {Code, NewRemindList}
                = if
                      Remind == ?REMIND andalso IsInRemind == true ->
                          {?ERRCODE(err460_no_remind), RemindList};
                      Remind =/= ?REMIND andalso IsInRemind == false ->
                          {?ERRCODE(err460_no_unremind), RemindList};
                      Remind == ?REMIND -> %% replace
                          MaxNum = data_boss:get_boss_type_kv(BossType, fairy_max_remind),
                          if
                              is_integer(MaxNum) == true ->
                                  NewMaxNum = MaxNum;
                              true ->
                                  NewMaxNum = 0
                          end,
                          if
                              RemindNum < NewMaxNum ->
                                  SQL = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p">>,
                                  db:execute(io_lib:format(SQL, [RoleId, BossId, Remind])),
                                  mod_counter:increment(RoleId, ?MOD_BOSS, BossType),
                                  {?SUCCESS, [RoleId | RemindList]};
                              true ->
                                  mod_counter:set_count(RoleId, ?MOD_BOSS, BossType, NewMaxNum),
                                  {?ERRCODE(err460_remind_max), RemindList}
                          end;
                      true -> %% delete
                          if
                               RemindNum > 0->
                                  mod_counter:decrement(RoleId, ?MOD_BOSS, BossType);
                               true ->
                                  mod_counter:set_count(RoleId, ?MOD_BOSS, BossType, 0)
                          end,
                          SQL = <<"delete from boss_remind where role_id = ~p and boss_id = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId])),
                          {?SUCCESS, lists:delete(RoleId, RemindList)}
                  end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, Remind, IsAuto]),
            NewBoss = Boss#boss_status{remind_list = NewRemindList},
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss),
            {noreply, NewState}
    end;
boss_remind_op(State, RoleId, BossType, BossId, Remind, IsAuto) ->
    case get_status_map_info(State, BossType, BossId) of
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [ErrCode, BossType, BossId, Remind, IsAuto]),
            {noreply, State};
        {ok, ComStatusMap, ComStatus, BossMap, #boss_status{remind_list = RemindList, no_auto_remind_list = NoAutoList} = Boss} ->
            IsInRemind = lists:member(RoleId, RemindList),
            {Code, NewRemindList, NewNoAutoList}
                = if
                      Remind == ?REMIND andalso IsInRemind == true ->
                          {?ERRCODE(err460_no_remind), RemindList, NoAutoList};
                      Remind =/= ?REMIND andalso IsInRemind == false ->
                          {?ERRCODE(err460_no_unremind), RemindList, NoAutoList};
                      Remind == ?REMIND -> %% replace
                          SQL = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p, auto_remind = ~p">>,
                          db:execute(io_lib:format(SQL, [RoleId, BossId, Remind, ?AUTO_REMIND])),
                          {?SUCCESS, [RoleId | RemindList], lists:delete(RoleId, NoAutoList)};
                      true -> %% delete
                          SQL = <<"replace into boss_remind set role_id = ~p, boss_id = ~p, remind = ~p, auto_remind = ~p">>,
                          AutoRemind = ?IF(IsAuto == 1, ?AUTO_REMIND, ?NO_AUTO_REMIND), % 如果是手动取关则添加到不可自动关注列表(状态由客户端处理)
                          db:execute(io_lib:format(SQL, [RoleId, BossId, Remind, AutoRemind])),
                          NNoAutoList = ?IF(AutoRemind == ?NO_AUTO_REMIND, [RoleId | NoAutoList], NoAutoList),
                          {?SUCCESS, lists:delete(RoleId, RemindList), NNoAutoList}
                  end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, Remind, IsAuto]),
            NewBoss = Boss#boss_status{remind_list = NewRemindList, no_auto_remind_list = NewNoAutoList},
            NewState = update_status_map(State, ComStatusMap, ComStatus, BossMap, NewBoss),
            {noreply, NewState}
    end.

%% 离开
quit(State, RoleId, BossType, CopyId) ->
    #boss_state{boss_role_anger = BossRoleAnger, common_status_map = CommonStatusMap} = State,
    case lists:keyfind(RoleId, #boss_role_anger.role_id, BossRoleAnger) of
        false ->
            NewBossRoleAnger = BossRoleAnger;
        #boss_role_anger{anger_ref = AngerRef, bekill_count = _BeKillTime} ->
            util:cancel_timer(AngerRef),
            NewBossRoleAnger = lists:keydelete(RoleId, #boss_role_anger.role_id, BossRoleAnger)
    end,
    NewCommonStatusMap = handle_quit_common_status_map(CommonStatusMap, BossType, CopyId, RoleId),
    {noreply, State#boss_state{boss_role_anger = NewBossRoleAnger, common_status_map = NewCommonStatusMap}}.


%%处理通用common_status_map 的退出逻辑
handle_quit_common_status_map(CommonStatusMap, BossType, CopyId, RoleId) ->
    case maps:find(BossType, CommonStatusMap) of
        {ok, BossCommonStatus} ->
            #boss_common_status{copy_msg = CopyList} = BossCommonStatus,
            NewCopyList = handle_quit_copy_msg(CopyList, RoleId, CopyId),
            NewBossCommonStatus = BossCommonStatus#boss_common_status{copy_msg = NewCopyList},
            NewCommonStatusMap = maps:put(BossType, NewBossCommonStatus, CommonStatusMap),
            NewCommonStatusMap;
        _ ->
            CommonStatusMap
    end.

%%处理房间里的玩家信息
handle_quit_copy_msg([], _RoleId, _CopyId) ->
    [];
handle_quit_copy_msg(CopyList, RoleId, CopyId) ->
    % ?MYLOG("cym", "CopyId ~p~n", [CopyId]),
    case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
        #copy_msg{role_list = RoleList, collect_map = CollectMap, other_map = OtherMap} = CopyMsg ->
%%          ?MYLOG("cym", "RoleList ~p RoleId ~p~n", [RoleList, RoleId]),
            NewRoleList = lists:delete(RoleId, RoleList),
%%          ?MYLOG("cym", "NewRoleList ~p~n", [NewRoleList]),
            NewNum = length(NewRoleList),
            NewCopyMsg = CopyMsg#copy_msg{role_list = NewRoleList, role_num = NewNum},
            handle_feast_boss_push_settlement(OtherMap, CollectMap, RoleId),
            lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg);
        _ ->
            CopyList
    end.

%% -----------------------------------------------------------------
%% 世界boss，伤害排名
%% -----------------------------------------------------------------
rank_damage(Name, Pid, RoleId, Hurt, RankList) ->
    NewList = case lists:keyfind(Name, 1, RankList) of
        {Name, _Pid, RoleId, OldHurt} ->
            lists:keystore(Name, 1, RankList, {Name, Pid, RoleId, OldHurt+Hurt});
        false ->
            lists:keystore(Name, 1, RankList, {Name, Pid, RoleId, Hurt})
    end,
    lists:keysort(4, NewList).

send_reward_byrank(State, BossId, AttrName) ->
    #boss_state{world_boss_rankmap = RankMap} = State,
    MonName = lib_mon:get_name_by_mon_id(BossId),
    Time = utime:unixtime(),
    case maps:get(BossId, RankMap, null) of
        null ->
            skip;
        RankList ->
            NRankList = lists:reverse(RankList),
            Fun = fun({N, P, Id, H}, {APid, ARid, Sum,Acc}) ->
                {AtPid, AtId} = case N =/= AttrName of
                    true ->
                        {APid,ARid};
                    false ->
                        {P,Id}
                end,
                {AtPid, AtId, Sum+1,[{N, P, Id, H, Sum + 1}|Acc]}
            end,
            {_AttrPid, AttrRoleid, _, NewRankList} = lists:foldl(Fun, {0, 0, 0, []}, NRankList),
            % ?PRINT("NewRankList:~p~n,RankList:~p~n",[NewRankList, RankList]),
            [{FirstName, _, _, FirstHurt}|_T] = NRankList,
            F = fun({RoleName, Pid, Rid, _H, Rank}) ->
                RankStageList = data_boss:get_rank(BossId),
                {Min,Max} = get_rank_stage(Rank, RankStageList),
                RewardList = case data_boss:get_reward_list(BossId, Min, Max) of
                    [] -> [];
                    [RewardL] ->RewardL
                end,
                Title = utext:get(?WLDBOSS_RANKREWARD_MAIL_TITLE),
                Content = utext:get(?WLDBOSS_RANKREWARD_MAIL_CONTENT, [MonName, Rank]),
                Produce = #produce{type = world_boss_reward, subtype = 0, reward = RewardList, remark = "", show_tips = 1},
                lib_log_api:log_wldboss_kill(Rid, RoleName, BossId, 1, Rank, RewardList, Time),%%1 表示排名奖励
                case misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_boss, send_reward_byrank,
                            [Produce,FirstName, FirstHurt, AttrName, Rank, RewardList,BossId,Content,Title]);
                    false ->
                        lib_mail_api:send_sys_mail([Rid], Title, Content, RewardList)
                end
                % {ok, Bin} = pt_460:write(46021, [FirstName, FirstHurt, AttrName, Rank, RewardList]),
                % lib_server_send:send_to_uid(Rid, Bin)
            end,
            lists:foreach(F, NewRankList),
            %%尾刀奖励（最后一击）现在改为固定奖励
            KillRL = case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{kill_award = RL} ->
                    RL;
                _ ->[]
            end,
            % {Reward,_} = util:find_ratio(KillRL,2),%%随机奖励
            % ?PRINT("KillRL:~p,AttrRoleid:~p~n",[AttrRoleid, KillRL]),
            if
                AttrRoleid =/= 0 ->
                    lib_log_api:log_wldboss_kill(AttrRoleid, AttrName, BossId, 2, 0, KillRL, Time), %%2表示击杀奖励
                    Titles = utext:get(?WLDBOSS_KILLREWARD_MAIL_TITLE),
                    Contents = utext:get(?WLDBOSS_KILLREWARD_MAIL_CONTENT, [MonName]),
                    lib_mail_api:send_sys_mail([AttrRoleid], Titles, Contents, KillRL);
                true ->
                    skip
            end
    end.


get_rank_stage(Rank, RankStageList) ->
    Fun = fun({Min,Max}, Acc) ->
        case Rank >= Min andalso Rank =< Max of
            true -> {Min,Max};
            false ->Acc
        end
    end,
    lists:foldl(Fun,{0,0},RankStageList).

world_boss_be_kill(State, BossType, BossId, AttrId, AttrName, BLWho, _DX, _DY, _FirstAttr, _MonArgs) ->
    case mod_boss:get_boss_type_boss_info(State, BossType, BossId) of
        {false, _Code} ->
            {noreply, State};
        {ok, BossMap, Boss} ->
            mod_boss_first_blood:boss_be_killed(BossId, BLWho),
            NewBossMap =lib_boss_mod:do_wldboss_be_kill(BossType, BossMap, Boss, AttrId, AttrName, BLWho),
            lib_boss_mod:send_reward_byrank(State, BossId, AttrName),
            #boss_state{world_boss_rankmap = RankMap} = State,
            NewRankMap = maps:remove(BossId, RankMap),
            NewState = State#boss_state{world_boss_rankmap = NewRankMap},
            {noreply, mod_boss:update_boss_state(BossType, NewBossMap, NewState)}
    end.
%世界boss
do_wldboss_be_kill(BossType, BossMap, Boss, AttrId, AttrName, BLWhos) when BossType == ?BOSS_TYPE_WORLD ->
    #boss_status{boss_id = BossId, kill_log = KillLog, remind_ref = RemindRef, reborn_ref = RebornRef, num = Num, timeout_ref = TimeOutRef} = Boss,
    %% 取消旧的定时器
    util:cancel_timer(RemindRef),
    util:cancel_timer(RebornRef),
    util:cancel_timer(TimeOutRef),
    %% 计算重生时间和提醒时间
    NowTime = utime:unixtime(),
    {_, NextBornTime} = lib_boss:get_wldboss_borntime(NowTime),%%一定会返回一个boss复活时间
    %% 更新击杀记录
    NewKillLog = [{NowTime, AttrId, AttrName} | KillLog],
    NRemindRef = undefined,
    % ?PRINT("NextBornTime:~p~n",[NextBornTime]),
    RebornEndTime = NextBornTime,
    NRebornRef = erlang:send_after(NextBornTime * 1000, self(), {'boss_reborn', BossType, BossId}),
    NewBoss = Boss#boss_status{reborn_time = RebornEndTime, kill_log = NewKillLog, remind_ref = NRemindRef, reborn_ref = NRebornRef, timeout_ref = undefined},
    NewBossMap = maps:update(BossId, NewBoss, BossMap),
    %% 广播boss死亡信息
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, max(0, Num - 1)]),
    lib_server_send:send_to_all(Bin),
    %% 事件触发
    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
    [lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
    %% 成就触发
    lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
    %% 活动日历
    % lib_activitycalen_api:success_end_activity(?MOD_BOSS, ?BOSS_TYPE_WORLD),
    %% 玩家击杀和日志
    case [P#mon_atter.id || P <- BLWhos] of
        [] -> lib_log_api:log_boss(BossType, BossId, AttrId, "[]", NowTime);
        BLIds ->
            StrBLIds = util:term_to_string(BLIds),
            lib_log_api:log_boss(BossType, BossId, AttrId, StrBLIds, NowTime)
    end,
    NewBossMap.

wldboss_init(BossType, BossId, NowTime) ->
    Boss = #boss_status{boss_id = BossId},
    ShowBoss = lib_boss:get_wldBoss_need_show(),
    IsOpen = lib_boss:is_open_hour(NowTime),
    if
        IsOpen == false ->
            {_, RebornSpanTime} = lib_boss:get_wldboss_borntime(NowTime);%%一定会返回一个boss复活时间
        true ->
            RebornSpanTime = 1
    end,
    %?PRINT("RebornSpanTime:~p,ShowBoss:~p~n",[RebornSpanTime, ShowBoss]),
    case lists:member(BossId, ShowBoss) of
        true ->
            RebornRef = erlang:send_after(RebornSpanTime* 1000, self(), {'boss_reborn', BossType, BossId});
        false ->
            RebornRef = undefined
    end,
    Boss#boss_status{reborn_time = RebornSpanTime, reborn_ref = RebornRef}.

%%------------------------------------
%% 幻兽领 怪物(boss和采集怪)初始化
%%--------------------------------------
phantom_boss_init(BossCfg, RebornTime, OptionalData, NowTime) ->
    #boss_cfg{
        boss_id = BossId, type = BossType, scene = Scene, x = X, y = Y, reborn_time = RebornTimes
    } = BossCfg,
    RebornSpanTime = max(0, RebornTime - NowTime),
    PhatomBossType = lib_boss:get_phatom_boss_type(BossType, BossId),
    if
        PhatomBossType == cl_mon -> %% 采集怪
            case RebornSpanTime > 0 of
                true ->
                    NewRebornTime = RebornTime,
                    NewReBornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId}),
                    case lists:keyfind({BossType, BossId}, 1, OptionalData) of
                        {_, CollectTimes} -> ClMonArgs = [{collect_times, CollectTimes}], NewOptionalData = OptionalData;
                        _ -> ClMonArgs = [], NewOptionalData = []
                    end;
                _ ->
                    RebornSpan = mod_boss:get_reborn_time(RebornTimes),
                    NewRebornTime = NowTime+RebornSpan,
                    NewReBornRef = erlang:send_after(RebornSpan * 1000, self(), {'boss_reborn', BossType, BossId}),
                    ClMonArgs = [], NewOptionalData = []
            end,
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, ClMonArgs),
            _Boss = #boss_status{boss_id = BossId, reborn_time = NewRebornTime, reborn_ref = NewReBornRef, optional_data = NewOptionalData};
        PhatomBossType == boss -> %% boss
            if
                RebornSpanTime > 0 ->
                    RemindTime = max(0, RebornSpanTime - ?REMIND_TIME),
                    RemindRef = ?IF(RemindTime =< 0, undefined,
                        erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
                    RebornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId}),
                    _Boss = #boss_status{boss_id = BossId, reborn_time = RebornTime, remind_ref = RemindRef, reborn_ref = RebornRef};
                true ->
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                    _Boss = #boss_status{boss_id = BossId}
            end;
        true -> _Boss = #boss_status{boss_id = BossId}
    end.




%% -----------------------------------------------------------------
%% @desc     功能描述  推送奖励   只有满足 普通掉落来源和额外掉落才推送奖励
%% @param    参数      RoleMsg::#boss_role_anger{}
%% @return   返回值    #boss_role_anger{}
%% @history  修改历史
%% -----------------------------------------------------------------
push_settlement(RoleMsg) ->
    #boss_role_anger{reward = RewardMap, role_id = RoleId, reward_type = RewardType} = RoleMsg,
    ?PRINT("push_settlement:~p~n",[RewardMap]),
    HaveOtherDrop = maps:is_key(?REWARD_SOURCE_OTHER_DROP, RewardMap), %%额外掉落
    HaveDrop = maps:is_key(?REWARD_SOURCE_DROP, RewardMap),            %%普通掉落
    HaveFirst = maps:is_key(?REWARD_SOURCE_FIRST, RewardMap),
    if
        HaveOtherDrop andalso HaveDrop andalso HaveFirst ->  %%满足条件，则推送
            % ?PRINT("RewardMap:~p ~n", [RewardMap]),
            RewardList = maps:get(?REWARD_SOURCE_FIRST, RewardMap) ++ maps:get(?REWARD_SOURCE_OTHER_DROP, RewardMap) ++
                maps:get(?REWARD_SOURCE_DROP, RewardMap) ++ maps:get(?REWARD_SOURCE_TASK_DROP, RewardMap, []),
%%            ?MYLOG("cym", "push_reward ~p~n ",  [RewardList]),
            {ok, BinData} = pt_460:write(46015, [RewardType, RewardList]),
            lib_server_send:send_to_uid(RoleId, BinData),
            RoleMsg#boss_role_anger{reward = #{}};
        true ->
            RoleMsg
    end.


set_reward(State, RoleId, SourceReward) ->
    F = fun
        % 设置奖励的参数
        ({RewardType, SourceType, RewardList}, TmpState) ->
            #boss_state{boss_role_anger = RoleList} = TmpState,
            case lists:keyfind(RoleId, #boss_role_anger.role_id, RoleList) of
                #boss_role_anger{reward = RewardMap} = RoleMsg ->
                    NewRewardMap = maps:put(SourceType, RewardList, RewardMap),
                    % 设置奖励类型
                    NewRoleMsg  = RoleMsg#boss_role_anger{reward = NewRewardMap, reward_type = RewardType},
                    LastRoleMsg = push_settlement(NewRoleMsg),
                    NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, LastRoleMsg),
                    TmpState#boss_state{boss_role_anger = NewRoleList};
                _ ->
                    TmpState
            end;
        ({SourceType, RewardList}, TmpState) ->
            #boss_state{boss_role_anger = RoleList} = TmpState,
            case lists:keyfind(RoleId, #boss_role_anger.role_id, RoleList) of
                #boss_role_anger{reward = RewardMap} = RoleMsg ->
                    NewRewardMap = maps:put(SourceType, RewardList, RewardMap),
                    NewRoleMsg  = RoleMsg#boss_role_anger{reward = NewRewardMap},
                    LastRoleMsg = push_settlement(NewRoleMsg),
                    NewRoleList = lists:keystore(RoleId, #boss_role_anger.role_id, RoleList, LastRoleMsg),
                    TmpState#boss_state{boss_role_anger = NewRoleList};
                _ ->
                    TmpState
            end
    end,
    lists:foldl(F, State, SourceReward).


%%玩家强制登出的时候，根据boss类型特殊处理
logout_by_boss_type(State, RoleId, CopyId) ->
    logout_by_boss_type_help(State, RoleId, CopyId, ?LOGOUT_BOSS_TYPE).
logout_by_boss_type_help(State, _RoleId, _CopyId, []) ->
    State;
logout_by_boss_type_help(State, RoleId, CopyId, [BossType | T]) ->
    #boss_state{common_status_map = CommonStatusMap} = State,
    NewCommonStatusMap = handle_quit_common_status_map(CommonStatusMap, BossType, CopyId, RoleId),
    logout_by_boss_type_help(State#boss_state{common_status_map = NewCommonStatusMap}, RoleId, CopyId, T).


%%被采集
be_collected(#boss_state{common_status_map = CommMap} = State, _ScenePoolId, ?BOSS_TYPE_FEAST, _BossId,
    AttrId, _AttrName, _BLWhos, _DX, _DY, FirstAttr, #mon_args{copy_id = CopyId, id = AutoMonId} = _MonArgs) ->
    #mon_atter{att_lv = RoleLv} = FirstAttr,
    case maps:find(?BOSS_TYPE_FEAST, CommMap) of
        {ok, BossCommStatus} ->
            #boss_common_status{copy_msg = CopyList} = BossCommStatus,
            case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
                #copy_msg{other_map = OtherMap, collect_map = CollectMap} = CopyMsg ->
                    case maps:find(?feast_boss_box, OtherMap) of
                        {ok, BoxList} ->
                            case lists:keyfind(AutoMonId, #feast_boss_box.auto_id, BoxList) of
                                #feast_boss_box{refresh_direct = Direct, wave = Wave, collect_limit = Limit} = _Box ->
                                    %% 发送奖励
                                    Reward = lib_boss:send_feast_boss_box_reward(AttrId, RoleLv),
                                    %%日志
                                    case lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_BOSS) of
                                        [] ->
                                            skip;
                                        [SubType |_ ] ->
                                            lib_log_api:log_custom_act_reward(AttrId, ?CUSTOM_ACT_TYPE_FEAST_BOSS, SubType,
                                                0, Reward)
                                    end,
                                    send_feast_boss_drop_reward(Reward, CopyId, AttrId, _MonArgs#mon_args.x,
                                        _MonArgs#mon_args.y, _MonArgs#mon_args.mid),
                                    OldCollectList = maps:get(?feast_boss_role_collection, OtherMap, []),
                                    case lists:keyfind({Direct, Wave, AttrId}, #feast_boss_role_collection.key, OldCollectList) of
                                        #feast_boss_role_collection{collect_count = Count} = Collection ->
                                            NewCollection = Collection#feast_boss_role_collection{collect_count = Count + 1};
%%                                          if
%%                                              Count + 1 >= Limit ->
%%                                                    send_client_hide_box(AttrId, BoxList, )
%%                                              true ->
%%                                                  skip
%%                                          end;
                                        _ ->
                                            NewCollection = #feast_boss_role_collection{key = {Direct, Wave, AttrId}, refresh_direct = Direct,
                                                wave = Wave, role_id = AttrId, collect_count = 1, collect_limit = Limit}
                                    end,
                                    %%组装数据
                                    NewCollectionList = lists:keystore({Direct, Wave, AttrId}, #feast_boss_role_collection.key, OldCollectList, NewCollection),
                                    if
                                        NewCollection#feast_boss_role_collection.collect_count >= Limit ->
                                            send_client_feast_boss_hide_box(AttrId, BoxList, NewCollectionList);
                                        true ->
                                            skip
                                    end,
                                    %%更新玩家采集奖励
                                    CollectMap1 = lib_boss:update_feast_boss_collect_reward(CollectMap, Reward, AttrId),
                                    NewOtherMap = maps:put(?feast_boss_role_collection, NewCollectionList, OtherMap),
                                    NewCopyMsg  = CopyMsg#copy_msg{other_map = NewOtherMap, collect_map = CollectMap1},
                                    NewCopyList = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
                                    NewBossCommStatus = BossCommStatus#boss_common_status{copy_msg = NewCopyList},
                                    NewCommMap  = maps:put(?BOSS_TYPE_FEAST, NewBossCommStatus, CommMap),
                                    {noreply, State#boss_state{common_status_map = NewCommMap}};
                                _ ->
                                    {noreply, State}
                            end;
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;
be_collected(State, _ScenePoolId, _BossType, _BossId, _AttrId, _AttrName, _BLWhos, _DX, _DY, _FirstAttr, _MonArgs) ->
    {noreply, State}.


%%======================================================================================================================
%%                          节日bossStart
%%======================================================================================================================

%%节日boss初始化
feast_boss_init(StatusMap) ->
    ComStatus = #boss_common_status{boss_type = ?BOSS_TYPE_FEAST,
        other_map = #{?feast_boss_max_copy_id =>0}},
    maps:put(?BOSS_TYPE_FEAST, ComStatus, StatusMap).

%%节日boss活动开启，
feast_boss_act_start(#boss_state{common_status_map = CommonMap} = State) ->
    case maps:find(?BOSS_TYPE_FEAST, CommonMap) of
        {ok, BossCommonStatus} ->
            NewBossCommonStatus = BossCommonStatus#boss_common_status{other_map = #{?feast_boss_max_copy_id  => 0}, copy_msg = []},
            NewCommonMap = maps:put(?BOSS_TYPE_FEAST, NewBossCommonStatus, CommonMap),
            State#boss_state{common_status_map = NewCommonMap};
        error ->
            State
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述   节日boss活动结束  主要是要将定时器取消，所有玩家退出场景，  清理场景，  然后数据重置
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
feast_boss_act_end(#boss_state{common_status_map = CommonMap} = State) ->
    OldBossCommStatus = maps:get(?BOSS_TYPE_FEAST, CommonMap, #boss_common_status{}),
    #boss_common_status{copy_msg = CopyList} = OldBossCommStatus,
    push_feast_boss_settlement(CopyList, 1),
    cancel_copy_timer_and_role_quit(CopyList),        %% 取消定时器， 且将玩家退出场景
    %%清理场景
    % lib_scene:clear_scene(?FEAST_BOSS_SCENE, 0),
    F = fun(CopyMsg) ->
        #copy_msg{copy_id = CopyId, scene_id = SceneId, scene_pool_id = PoolId} = CopyMsg,
        lib_mon:clear_scene_mon(SceneId, PoolId, CopyId, 1)
    end,
    lists:foreach(F, CopyList),
    ComStatus = #boss_common_status{boss_type = ?BOSS_TYPE_FEAST,
        other_map = #{?feast_boss_max_copy_id  =>  0}},
    NewCommMap = maps:put(?BOSS_TYPE_FEAST, ComStatus, CommonMap),
    State#boss_state{common_status_map = NewCommMap}.

%% ------------------------------------------------------------------------------------------------------
%% @desc     功能描述  处理玩家进入boss场景   创建水晶 ->如果是第一个进入房间则，创建房间，刷怪，
%%                    如果房间满了，创建新的房间，且刷怪 ->设置房间信息 ->玩家切换场景-返回
%% @param    参数     RoleId ::玩家id
%%                    CopyMsg::[#copy_msg{}]
%%                    OtherMap::map()
%% @return   返回值   {{#copy_msg}, MaxCopyId, now_copy_id}
%% @history  修改历史
%% ------------------------------------------------------------------------------------------------------
handle_feast_boss_enter(RoleId, CopyMsgList, MaxCopyId, EnterCopyId) when EnterCopyId =/= -1 -> %% 进入过旧的房间
    case lists:keyfind(EnterCopyId, #copy_msg.copy_id, CopyMsgList) of
        #copy_msg{status = Status} = CopyMsg ->
            if
                Status == ?BOSS_COPY_CLOSE ->  %% 房间已经关闭
                    %% 已经参加过活动
                    lib_server_send:send_to_uid(RoleId, pt_460, 46003, [?ERRCODE(feast_boss_box_game_over)]),
                    {CopyMsgList, MaxCopyId, EnterCopyId};
                true ->
                    #copy_msg{other_map = OtherMap} = CopyMsg,
                    RefreshTime = maps:get(?feast_boss_wave_refresh_time, OtherMap, 0),
                    NextWave    = maps:get(?feast_boss_wave, OtherMap, 0),
                    {ok, Bin}   = pt_460:write(46033, [NextWave + 1, RefreshTime]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    %% 修改玩家信息
                    NewCopyMsg = CopyMsg#copy_msg{role_list = [RoleId | CopyMsg#copy_msg.role_list], role_num = CopyMsg#copy_msg.role_num + 1},  %%修改玩家信息
                    lib_boss:feast_boss_change_scene(RoleId, EnterCopyId),
                    FeastBoxList   = maps:get(?feast_boss_box, CopyMsg#copy_msg.other_map, []),
                    CollectionList = maps:get(?feast_boss_role_collection, CopyMsg#copy_msg.other_map, []),
                    send_client_feast_boss_hide_box(RoleId, FeastBoxList, CollectionList), %%发送隐藏宝箱
                    {lists:keystore(EnterCopyId, #copy_msg.copy_id, CopyMsgList, NewCopyMsg), MaxCopyId, EnterCopyId}
            end;
        _ ->
            {CopyMsgList, MaxCopyId, EnterCopyId}
    end;
handle_feast_boss_enter(RoleId, [], _MaxCopyId, -1) ->  %%进入的时候，一个房间都没有
    CopyMsg = create_new_feast_boss_copy(1, RoleId),
    send_client_feast_boss_hide_box(RoleId, [], []),
    {[CopyMsg], 1, 1};

handle_feast_boss_enter(RoleId, CopyMsgList, MaxCopyId, -1) ->
%%  ?MYLOG("cym", "enter CopyMsgList ~p ~n", [CopyMsgList]),
    case lib_boss:is_max_role_num(CopyMsgList, MaxCopyId) of
        true -> %%房间满了， 或者是第一个去的玩家, 或者是已经是超时的房间
            %%创建新房间  第一个进入的玩家RoleId, Copy =  MaxCopyId + 1 ,
            CopyMsg = create_new_feast_boss_copy(MaxCopyId + 1, RoleId),
            send_client_feast_boss_hide_box(RoleId, [], []), %%发送隐藏宝箱
            {[CopyMsg | CopyMsgList], MaxCopyId + 1, MaxCopyId + 1};
        {false, EnterCopyId} -> %%房间没满，肯定不是第一个进去， 则简单地修改人数，role_list 和切换场景
            CopyMsg = lists:keyfind(EnterCopyId, #copy_msg.copy_id, CopyMsgList),
            #copy_msg{other_map = OtherMap} = CopyMsg,
            RefreshTime = maps:get(?feast_boss_wave_refresh_time, OtherMap, 0),
            NextWave    = maps:get(?feast_boss_wave, OtherMap, 0),
%%            ?MYLOG("cym", "RefreshTime ~p NextWave ~p~n", [RefreshTime, NextWave + 1]),
            {ok, Bin}   = pt_460:write(46033, [NextWave + 1, RefreshTime]),
            lib_server_send:send_to_uid(RoleId, Bin),
            %% 修改玩家信息
            NewCopyMsg = CopyMsg#copy_msg{role_list = [RoleId | CopyMsg#copy_msg.role_list], role_num = CopyMsg#copy_msg.role_num + 1},  %%修改玩家信息
            lib_boss:feast_boss_change_scene(RoleId, EnterCopyId),
            FeastBoxList   = maps:get(?feast_boss_box, CopyMsg#copy_msg.other_map, []),
            CollectionList = maps:get(?feast_boss_role_collection, CopyMsg#copy_msg.other_map, []),
            send_client_feast_boss_hide_box(RoleId, FeastBoxList, CollectionList), %%发送隐藏宝箱
            {lists:keystore(EnterCopyId, #copy_msg.copy_id, CopyMsgList, NewCopyMsg), MaxCopyId, EnterCopyId}
    end.


%%根据房间id 刷新房间里的boss
feast_boss_refresh(#boss_state{common_status_map = CommonMap} = State, CopyId) ->
    OldBossCommonStatus = maps:get(?BOSS_TYPE_FEAST, CommonMap),
    #boss_common_status{copy_msg = CopyList} = OldBossCommonStatus,
    case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
        #copy_msg{other_map = CopyOtherMap, boss_list = BossList, ref = Ref} = OldCopyMsg ->
            NowWave = maps:get(?feast_boss_wave, CopyOtherMap, 0),
            {AddBossList, NextWave} = feast_boss_refresh(CopyId, NowWave),  %%刷新怪物
            NewRef      = get_feast_boss_ref(AddBossList, Ref, CopyId),
            OtherMap1   = maps:put(?feast_boss_wave, NextWave, CopyOtherMap),
            RefreshTime = get_next_feast_boss_wave_refresh_time(NextWave),
            send_feast_boss_next_wave_to_client(RefreshTime, NextWave, CopyId),
            OtherMap2   = maps:put(?feast_boss_wave_refresh_time, RefreshTime, OtherMap1),
            NewCopyMsg  = OldCopyMsg#copy_msg{boss_list = AddBossList ++ BossList, ref = NewRef,
                other_map = OtherMap2},
            %%组装回去
            NewCopyList = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
            NewBossCommonStatus = OldBossCommonStatus#boss_common_status{copy_msg = NewCopyList},
            NewCommonMap = maps:put(?BOSS_TYPE_FEAST, NewBossCommonStatus, CommonMap),
            State#boss_state{common_status_map = NewCommonMap};
        _ ->
            State
    end;
%% -----------------------------------------------------------------
%% @desc     功能描述   刷新节日boss
%% @param    参数      CopyId::integer() 房间id    NowWave::integer() 当前波数
%% @return   返回值    {[#boss_status{}],  刷新后的波数}
%% @history  修改历史
%% -----------------------------------------------------------------
feast_boss_refresh(CopyId, NowWave) ->
    NextWave = NowWave + 1,
    F = fun(Direction, AccList) ->
        {TempMonIdcfg, {_X, _Y}} = get_feast_boss_id_and_coord(Direction, NextWave),
        case TempMonIdcfg of
            0 ->
                AccList;
            _ ->
                AutoMonId = lib_mon:sync_create_mon(TempMonIdcfg, ?FEAST_BOSS_SCENE, 0, _X, _Y, 0, CopyId, 1, []),
%%              ?MYLOG("cym", "create mon  ~p~n", [CopyId]),
                TempBossStatus = #boss_status{boss_id = TempMonIdcfg, copy = CopyId,
                    boss_auto_id = AutoMonId, other_map = #{?feast_boss_from => {Direction, NextWave}}},
                [TempBossStatus | AccList]
        end
    end,
    AddBossList = lists:foldl(F, [], ?FEAST_BOSS_DIRECTION_LIST),
%%  ?MYLOG("cym", "create mon  ~p~n", [AddBossList]),
    {AddBossList, NextWave}.

%%创建基地水晶
create_feast_boss_crystal(CopyId) ->
    {X, Y} = ?FEAST_BOSS_CRYSTAL_COORD,
    lib_mon:async_create_mon(?FEAST_BOSS_CRYSTAL_MON_ID, ?FEAST_BOSS_SCENE, 0, X, Y, 0, CopyId, 1, [{group, ?DEF_ROLE_BATTLE_GROUP}]). %%战斗分组设置为99, 玩家的默认分组也是99

%% -----------------------------------------------------------------
%% @desc     功能描述    获取节日boss的怪物id，和坐标
%% @param    参数       Direction::integer  方位(1,2,3,4)
%%                      Wave::波数
%% @return   返回值     {怪物id, {X, Y}}
%% @history  修改历史
%% -----------------------------------------------------------------
get_feast_boss_id_and_coord(Direction, Wave) ->
    case data_boss:get_feast_boss(Direction, Wave) of
        {MonList, Coord} ->
            MonId = hd(ulists:list_shuffle(MonList)),
            {MonId, Coord};
        _ ->
            {0, {0, 0}}
    end.

get_feast_boss_ref([], OldRef, _) ->  %%当前boss刷新是空，则定时刷新下一波怪物
    util:cancel_timer(OldRef),
    [];
get_feast_boss_ref(_, OldRef, CopyId) ->
    util:send_after(OldRef, ?feast_boss_refresh_time * 1000, self(), {'boss_reborn', ?BOSS_TYPE_FEAST, 0, CopyId}).


%%创建新的房间, 且第一个玩家切换场景
create_new_feast_boss_copy(CopyId, RoleId) ->
    create_feast_boss_crystal(CopyId),
    NowWave = 0,
    {AddBossList, NewWave} = feast_boss_refresh(CopyId, NowWave),
    RefreshTime = get_next_feast_boss_wave_refresh_time(NewWave),
    Ref = get_feast_boss_ref(AddBossList, [], CopyId),
    MaxFeastBossNum        = lib_boss:get_max_feast_boss_num(),
    CopyMsg = #copy_msg{copy_id = CopyId, scene_id = ?FEAST_BOSS_SCENE, scene_pool_id = 0, role_list = [RoleId],
        role_num = 1, boss_list = AddBossList, other_map = #{wave => NewWave, ?max_feast_boss_num =>MaxFeastBossNum,
            ?kill_feast_boss_num => 0, ?feast_boss_wave_refresh_time => RefreshTime}, ref = Ref, start_time = utime:unixtime()},
    NewCopyMsg = feast_boss_refresh_other_mon(CopyMsg),  %%小野怪刷新
    %%玩家切换场景
    lib_boss:feast_boss_change_scene(RoleId, CopyId),
    spawn(fun() ->
        timer:sleep(500),
        send_feast_boss_next_wave_to_client(RefreshTime, NewWave, CopyId)
    end),
    NewCopyMsg.

%% -----------------------------------------------------------------
%% @desc     功能描述  生成宝箱采集怪 并且检查是否击杀最后一个怪物,如果是，将房间关闭，且房间内的所有玩家都设置为黑名单
%% @param    参数     BossCommStatus::##boss_common_status{}
%%                   Scene::integer() 场景id
%%                   ScenePoolId 场景进程id
%%                   CopyId 房间id
%%                   X, Y ::boss死亡坐标
%%                   AutoId::boss唯一id,
%%                   MonCfgId::boss配置id
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
create_feast_boss_box(#boss_common_status{copy_msg = CopyList, other_map = CommOtherMap} = BossCommStatus, _Scene, _ScenePoolId, CopyId, X, Y, AutoId, MonCfgId) ->
%%  ?MYLOG("cym", "Arg ~p~n", [{BossCommStatus, Scene, ScenePoolId, CopyId, X, Y, AutoId, MonCfgId}]),
    case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
        #copy_msg{role_num = Num, boss_list = BossList, other_map = OtherMap, role_list = RoleList} = CopyMsg ->
            {Direction, Wave} = lib_boss:get_feast_boss_from(BossList, AutoId),                  %%boss来源
%%          ?MYLOG("cym", "Autoid ~p from ~p~n", [AutoId, {Direction, Wave}]),
            OldBoxList  = maps:get(?feast_boss_box, OtherMap, []),
            MaxBossNum  = maps:get(?max_feast_boss_num, OtherMap, 0),
            KillBossNum = maps:get(?kill_feast_boss_num, OtherMap, 0),
            {CopyStatus, NewCommOtherMap, PushSettle}  = check_last_feast_boss(MaxBossNum, KillBossNum + 1, CommOtherMap, RoleList, CopyId),
            {BoxList, CollectTimesMax} = lib_boss:get_feast_boss_box_create_list(MonCfgId, Num), %%获得要生成的宝箱怪物信息
            {AddBoxList, BoxMsgList}   = do_create_feast_boss_box(BoxList, CollectTimesMax, Direction, Wave, X, Y, CopyId, [], []),          %%新增的宝箱
            %%组装信息
            lib_boss:broadCast_feast_box(AutoId, X, Y, BoxMsgList, CopyId),  %%广播宝箱信息
            OtherMap1    = maps:put(?feast_boss_box, OldBoxList ++ AddBoxList, OtherMap),
            OtherMap2    = maps:put(?kill_feast_boss_num, KillBossNum + 1, OtherMap1), %%击杀数量加 + 1
            NewOtherMap  = maps:put(?feast_boss_push_settle, PushSettle, OtherMap2),   %%离开房间是否要推送结算
            NewCopyMsg   = CopyMsg#copy_msg{other_map = NewOtherMap, status = CopyStatus},
            NewCopyList  = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
%%          ?MYLOG("cym", "NewCopyList ~p~n", [NewCopyList]),
            BossCommStatus#boss_common_status{copy_msg = NewCopyList, other_map = NewCommOtherMap};
        _ ->
            BossCommStatus
    end.
%%生成宝箱怪物
do_create_feast_boss_box([], _CollectTimesMax, _Direction, _Wave, _X, _Y, _CopyId, _XYList, AddBoxList) ->
    {AddBoxList, _XYList};
do_create_feast_boss_box([{_MonCfgId, 0} | BoxList], CollectTimesMax, Direction, Wave, X, Y, CopyId, XYList, AddBoxList) ->
    do_create_feast_boss_box(BoxList, CollectTimesMax, Direction, Wave, X, Y, CopyId, XYList, AddBoxList);
do_create_feast_boss_box([{MonCfgId, Num} | BoxList], CollectTimesMax, Direction, Wave, X, Y, CopyId, XYList, AddBoxList) ->
    {MX, MY} = get_box_xy(X, Y),
    AutoId = lib_mon:sync_create_mon(MonCfgId, ?FEAST_BOSS_SCENE, 0, MX, MY, 0, CopyId, 0, []),  %%不广播
    Box = #feast_boss_box{auto_id = AutoId, refresh_direct = Direction, wave = Wave, mon_cfg_id = MonCfgId, collect_limit = CollectTimesMax},
    do_create_feast_boss_box([{MonCfgId, Num - 1} | BoxList], CollectTimesMax, Direction, Wave, X, Y, CopyId, [{AutoId, MonCfgId, MX, MY} | XYList], [Box | AddBoxList]).

%%获得坐标
get_box_xy(X, Y) ->
    %%获得范围内的有效点
    RightXy = get_right_xy(X, Y),
    %打乱
    RightXy1 = ulists:list_shuffle(RightXy),
    case RightXy1 of
        [] ->
            {X, Y};
        [H | _] ->
            H
    end.

%% 在一定范围内的坐标
get_right_xy(X, Y) ->
    List = data_boss:get_feast_box_coord(1),
    {LimitX, LimitY} =
        case data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_box_area) of
            {_x, _y} ->
                {_x, _y};
            _ ->
                {0, 0}
        end,
    MinX = X - LimitX,
    MinY = Y - LimitY,
    MaxX = X + LimitX,
    MaxY = Y + LimitY,
    [{XX, YY} || {XX, YY} <- List, XX >= MinX, XX =< MaxX, YY >= MinY, YY =< MaxY].


%%取消房间内的定时器
cancel_copy_timer_and_role_quit([]) ->
    ok;
cancel_copy_timer_and_role_quit([#copy_msg{ref = Ref, role_list = RoleList} | T]) ->
    %%被动退出场景，有倒数
    util:cancel_timer(Ref),
    Time = data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_boss_quit_time) * 1000,

%%    util:send_after(Time),
    [   begin
        Pid = misc:get_player_process(RoleId),
        erlang:send_after(Time, Pid, {'mod', lib_boss, quit_feast_boss, []})
    end
        || RoleId <- RoleList],
    cancel_copy_timer_and_role_quit(T).


send_client_feast_boss_hide_box(RoleId, BoxList, CollectionList) ->
    List = get_hide_box(RoleId, BoxList, CollectionList, []),
    {ok, Bin} = pt_460:write(46026, [List]),
    lib_server_send:send_to_uid(RoleId, Bin).

get_hide_box(_RoleId, [], _CollectionList, Res) ->
    Res;
get_hide_box(RoleId, [#feast_boss_box{refresh_direct = Direct, wave = Wave, collect_limit = LimitCount, auto_id = AutoId} |BoxList], CollectionList, Res) ->
    case lists:keyfind({Direct, Wave, RoleId}, #feast_boss_role_collection.key, CollectionList) of
        #feast_boss_role_collection{collect_count = NowCount} ->
            if
                NowCount >= LimitCount -> %%进入隐藏名单
                    get_hide_box(RoleId, BoxList, CollectionList, [AutoId |Res]);
                true ->
                    get_hide_box(RoleId, BoxList, CollectionList, Res)
            end;
        _ ->%%没有采集信息
            get_hide_box(RoleId, BoxList, CollectionList, Res)
    end.
%%水晶爆炸 %%水晶被打爆了 %%所有玩家离场->清理数据->设置房间状态-> 不能再进入(用玩家黑名单)
feast_boss_crystal_die(CopyId, #boss_state{common_status_map = CommMap} = State) ->
    case maps:find(?BOSS_TYPE_FEAST, CommMap) of
        {ok, BossComm} ->
            #boss_common_status{copy_msg = CopyList, other_map = BossCommOtherMap} = BossComm,
            case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
                #copy_msg{role_list = RoleList} = CopyMsg ->
                    push_feast_boss_settlement([CopyMsg], 0),          %%推送结算信息
                    cancel_copy_timer_and_role_quit([CopyMsg]),        %% 取消定时器， 且将玩家退出场景
                    %%清理场景
%%                    lib_scene:clear_scene_room(?FEAST_BOSS_SCENE, 0, CopyId),
                    lib_mon:clear_scene_mon(?FEAST_BOSS_SCENE, 0, CopyId, 1),
                    NewCopyMsg  = CopyMsg#copy_msg{role_list = [], role_num = 0, other_map = #{}, status = ?BOSS_COPY_CLOSE}, %%设置房间状态
                    NewCopyList = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
                    OverRoleList= maps:get(?feast_boss_over_role, BossCommOtherMap, []),
                    NewBossCommOtherMap = maps:put(?feast_boss_over_role, OverRoleList ++ RoleList, BossCommOtherMap), %%黑名单
                    %%组装数据
                    NewBossComm = BossComm#boss_common_status{copy_msg = NewCopyList, other_map = NewBossCommOtherMap},
                    NewCommMap  = maps:put(?BOSS_TYPE_FEAST, NewBossComm, CommMap),
                    State#boss_state{common_status_map = NewCommMap};
                _ ->
                    State
            end;
        _ ->
            State
    end.
%% -----------------------------------------------------------------
%% @desc     功能描述  推送信息
%% @param    参数      Code::ingeter()  0 失败， 1：成功
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
push_feast_boss_settlement([],  _Code) ->
    ok;
push_feast_boss_settlement([#copy_msg{collect_map = CollectMap, role_list = RoleList} | CopyList],  Code) ->
    push_feast_boss_settlement(maps:get(?feast_boss_collect_reward, CollectMap, #{}),  Code, RoleList),
    push_feast_boss_settlement(CopyList,  Code).
%%推送结算信息
push_feast_boss_settlement(_CollectMap,  _Code, []) ->
    ok;
push_feast_boss_settlement(CollectMap,  Code, [RoleId | RoleList]) ->
    RewardList   = maps:get(RoleId, CollectMap, []),
    RewardList1  = ulists:object_list_plus([RewardList, []]),
    % ?MYLOG("cym",  "code ~p Rewalist ~p~n", [Code, RewardList1]),
    {ok, Bin}    = pt_460:write(46028, [Code, RewardList1]),
    lib_server_send:send_to_uid(RoleId, Bin),
    push_feast_boss_settlement(CollectMap,  Code, RoleList).

%% -----------------------------------------------------------------
%% @desc     功能描述  检查是否为最后一只boss,若是，则房间内的所有玩家进入活动黑名单，不能再进入活动，且房间关闭，告诉客户单，全部击杀了
%% @param    参数      MaxBossNum::boss总数量， KillBossNulibm::击杀总数量   RoleList::[RoleId]
%% @return   返回值    {房间状态, NewCommOtherMap}
%% @history  修改历史
%% -----------------------------------------------------------------
check_last_feast_boss(MaxBossNum, KillBossNum, CommOtherMap, RoleList, CopyId) ->
    case  KillBossNum >= MaxBossNum of
        true ->
            %%boss全挂了
            %%房间的人全部设置为黑名单，且房间关闭，
            OverRoleList    = maps:get(?feast_boss_over_role, CommOtherMap, []),
            NewCommOtherMap = maps:put(?feast_boss_over_role, OverRoleList ++ RoleList, CommOtherMap),
            {ok, Bin}       = pt_460:write(46029, []),
            lib_server_send:send_to_scene(?FEAST_BOSS_SCENE, 0, CopyId, Bin),
            {?BOSS_COPY_CLOSE, NewCommOtherMap, ?feast_boss_push_settle_yes};
        false ->
            {?BOSS_COPY_OPEN, CommOtherMap, ?feast_boss_push_settle_no}
    end.

handle_feast_boss_push_settlement(OtherMap, CollectMap, RoleId) ->
    case  maps:get(?feast_boss_push_settle, OtherMap, ?feast_boss_push_settle_no) of
        ?feast_boss_push_settle_yes ->
            FeastBossCollectMap = maps:get(?feast_boss_collect_reward, CollectMap, #{}),
            RewardList          = maps:get(RoleId, FeastBossCollectMap, []),
            {ok, Bin}           = pt_460:write(46028, [1, RewardList]),
            lib_server_send:send_to_uid(RoleId, Bin);
        _ ->
            skip
    end.
%%刷新节日boss其他野怪
feast_boss_refresh_other_mon(#copy_msg{copy_id = CopyId, other_map = Map, status = ?BOSS_COPY_OPEN} = CopyMsg) ->
    OtherMonList = ?feast_boss_other_mon_list ,
    case OtherMonList of
        [] ->
            CopyMsg;
        _ ->
            {X1, Y1} = get_feast_boss_other_mon_coord(1),
            {X2, Y2} = get_feast_boss_other_mon_coord(2),
            {X3, Y3} = get_feast_boss_other_mon_coord(3),
            {X4, Y4} = get_feast_boss_other_mon_coord(4),
            OldRef   = maps:get(feast_boss_other_mon_ref, Map, []),
            NewRef   = util:send_after(OldRef, ?feast_boss_other_mon_wave_refresh_time * 1000, self(), {'feast_boss_small_mon_refresh', CopyId}),
            NewMap   = maps:put(feast_boss_other_mon_ref, NewRef, Map),
            spawn(fun() ->
                [ begin
                    MonId1 = hd(ulists:list_shuffle(?feast_boss_other_mon_list)),
                    MonId2 = hd(ulists:list_shuffle(?feast_boss_other_mon_list)),
                    MonId3 = hd(ulists:list_shuffle(?feast_boss_other_mon_list)),
                    MonId4 = hd(ulists:list_shuffle(?feast_boss_other_mon_list)),
                    lib_mon:async_create_mon(MonId1, ?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, X1, Y1, 1, CopyId, 1, []),
                    lib_mon:async_create_mon(MonId2, ?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, X2, Y2, 1, CopyId, 1, []),
                    lib_mon:async_create_mon(MonId3, ?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, X3, Y3, 1, CopyId, 1, []),
                    lib_mon:async_create_mon(MonId4, ?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, X4, Y4, 1, CopyId, 1, []),
                    timer:sleep(trunc(?feast_boss_other_mon_refresh_time * 1000))
                end
                    || _ <- lists:seq(1, ?feast_boss_other_mon_num)]
            end),
            CopyMsg#copy_msg{other_map = NewMap}
    end;

feast_boss_refresh_other_mon(CopyMsg) ->
    CopyMsg.

%%根据方位，获得刷新坐标
get_feast_boss_other_mon_coord(Direct) ->
    case data_boss:get_feast_boss(Direct, 1) of
        {_, {X, Y}} ->
            {X, Y};
        _ ->
            {0, 0}
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述 节日boss小野怪刷新
%% @param    参数     CopyId::integer()  房间id  Stage::#boss_state{}
%% @return   返回值   #boss_state{}
%% @history  修改历史
%% -----------------------------------------------------------------
handle_feast_boss_refresh_small_mon(CopyId, #boss_state{common_status_map = CommMap} = State) ->
    case maps:find(?BOSS_TYPE_FEAST, CommMap) of
        {ok, FeastBossState} ->
            #boss_common_status{copy_msg = CopyList} = FeastBossState,
            case lists:keyfind(CopyId, #copy_msg.copy_id, CopyList) of
                #copy_msg{status = ?BOSS_COPY_OPEN} = CopyMsg ->
                    NewCopyMsg        = feast_boss_refresh_other_mon(CopyMsg),
                    %%组装数据
                    NewCopyList       = lists:keystore(CopyId, #copy_msg.copy_id, CopyList, NewCopyMsg),
                    NewFeastBossState = FeastBossState#boss_common_status{copy_msg = NewCopyList},
                    NewCommMap        = maps:put(?BOSS_TYPE_FEAST, NewFeastBossState, CommMap),
                    NewState          = State#boss_state{common_status_map = NewCommMap},
                    NewState;
                _ ->
                    State
            end;
        _ ->
            State
    end.
%% 节日boss掉落通知
send_feast_boss_drop_reward(RewardList, _CopyId, PlayerId, Mx, My, Mid) ->
    Scene = ?FEAST_BOSS_SCENE,
%%    StartXys  = lib_goods_drop:calc_goods_drop_xy(Scene, ?feast_def_scene_pool_id, CopyId, Mx, My, length(RewardList)),
    ExpireTime = utime:unixtime()+?DROP_ALIVE_TIME,
    F1 = fun({DTType, GoodId, GoodNum}, AccList) ->
        DX = urand:rand(max(Mx-100, 0), Mx+100),
        DY = urand:rand(max(My-100, 0), My+100),
        DropId = mod_drop:get_drop_id(),
        PickTime = data_drop_m:get_pick_time(Scene, DTType, GoodId),
        Bin = lib_goods_drop:make_drop_item_bin(DropId, DTType, GoodId, GoodNum, PlayerId, 0, 0, 0, 0, DX, DY,
            "", "", PickTime, ExpireTime, ?DROP_WAY_BAG_SIMULATE, ?ALLOC_BLONG),
        [Bin | AccList]
    end,
    BinList = lists:foldl(F1, [], RewardList),
    {ok, BinData} = pt_120:write(12017, [Mid, ?DROP_ALIVE_TIME, Scene, BinList, Mx, My, 0]),
    lib_server_send:send_to_uid(PlayerId, BinData).

get_next_feast_boss_wave_refresh_time(NowWave) ->
    case data_boss:get_feast_boss(1, NowWave + 1) of
        [] ->
            0;
        _ ->
            utime:unixtime() +  ?feast_boss_refresh_time
    end.

send_feast_boss_next_wave_to_client(RefreshTime, NewWave, CopyId) ->
    {ok, Bin} = pt_460:write(46033, [NewWave + 1, RefreshTime]),
    % ?MYLOG("cym", "RefreshTime ~p NextWave ~p~n", [RefreshTime, NewWave + 1]),
    lib_server_send:send_to_scene(?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, CopyId, Bin).
%%======================================================================================================================
%%                          节日bossEnd
%%======================================================================================================================

%% 秘境boss宝箱抽奖
draw(State, BossId, CurTimes, RoleId) ->
    OldData = get_boss_map_data(State, BossId),
    #fairyland_boss_data{time = EndTime} = OldData,
    Data = OldData#fairyland_boss_data{times = CurTimes},
    spawn(fun() -> db:execute(io_lib:format(?sql_fairyland_draw_replace, [BossId, RoleId, CurTimes, EndTime])) end),
    update_boss_map_data(State, BossId, Data).

draw_data(State, BossId, ToRoleId) ->
    OldData = get_boss_map_data(State, BossId),
    #fairyland_boss_data{times = CurTimes, role_id = BlId, time = EndTime} = OldData,
    % NowTime = utime:unixtime(),
    if
        BlId == 0 ->
            skip;
        true ->
            lib_player:apply_cast(BlId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE,
                    lib_boss, send_draw_data, [ToRoleId, BossId, EndTime, CurTimes])
    end.

update_boss_data(Boss, Data) ->
    #boss_status{other_map = OtherMap} = Boss,
    NewOtherMap = maps:put(fairyland_boss, Data, OtherMap),
    NewBoss = Boss#boss_status{other_map = NewOtherMap},
    NewBoss.

update_boss_map_data(BossId, OtherMap) ->
    Data = case db:get_row(io_lib:format(?sql_fairyland_draw_select, [BossId])) of
        [RoleId, Times, EndTime] ->
            #fairyland_boss_data{times = Times, role_id = RoleId, time = EndTime};
        _ ->
            #fairyland_boss_data{times = 0, role_id = 0, time = 0}
    end,
    maps:put(fairyland_boss, Data, OtherMap).

update_boss_map_data(State, BossId, Data) ->
    #boss_state{common_status_map = CommonMap} = State,
    OldBossCommonStatus = maps:get(?BOSS_TYPE_FAIRYLAND, CommonMap),
    #boss_common_status{boss_map = BossMap} = OldBossCommonStatus,
    Boss = maps:get(BossId, BossMap),
    #boss_status{other_map = OtherMap} = Boss,
    NewOtherMap = maps:put(fairyland_boss, Data, OtherMap),
    NewBoss = Boss#boss_status{other_map = NewOtherMap},
    NewBossMap = maps:put(BossId, NewBoss, BossMap),
    BossCommonStatus = OldBossCommonStatus#boss_common_status{boss_map = NewBossMap},
    NewCommMap = maps:put(?BOSS_TYPE_FAIRYLAND, BossCommonStatus, CommonMap),
    State#boss_state{common_status_map = NewCommMap}.

get_boss_map_data(State, BossId) ->
    #boss_state{common_status_map = CommonMap} = State,
    OldBossCommonStatus = maps:get(?BOSS_TYPE_FAIRYLAND, CommonMap),
    #boss_common_status{boss_map = BossMap} = OldBossCommonStatus,
    Boss = maps:get(BossId, BossMap),
    #boss_status{other_map = OtherMap} = Boss,
    OldData = maps:get(fairyland_boss, OtherMap),
    case OldData of
        #fairyland_boss_data{time = _EndTime} -> OldData;
        _ ->
            case db:get_row(io_lib:format(?sql_fairyland_draw_select, [BossId])) of
                [RoleId, Times, EndTime] ->
                    #fairyland_boss_data{times = Times, role_id = RoleId, time = EndTime};
                _ ->
                    #fairyland_boss_data{times = 0, role_id = 0, time = 0}
            end
    end.

%% 新野外boss玩家一定时间内死亡次数统计
%DieTimeList:[Time1,Time2...]
%Time:时长(分)
%% 计算规则1：每一次死亡都会将Time秒前面的数据清了，弹性计算死亡等待时间
get_real_die_time_list(DieTimeList, Time, NowTime) ->
    NewList = lists:sort(DieTimeList),
    MinTime = NowTime - Time,
    F = fun(TemTime) ->
        TemTime >= MinTime
    end,
    Index = ulists:find_index(F, NewList), %%在由小到大的列表查找第一个Time分钟的数据的索引
    NewDieTimeList = if
        Index =/= 0 ->
            Length = erlang:length(NewList),
            lists:sublist(NewList, Index, Length); %% 删除Time秒之外的数据
        true ->
            NewList
    end,
    NewDieTimeList.

%%计算规则2：只要玩家在Time秒内死亡，数据不会清理，直到某次玩家死亡间隔超过5分钟
get_real_die_time_list_2([], _, _) -> [];
get_real_die_time_list_2(DieTimeList, Time, NowTime) when is_list(DieTimeList) ->
    MaxDieTime = lists:max(DieTimeList),
    MinTime = NowTime - Time,
    NewDieTimeList = if
        MaxDieTime >= MinTime -> %% 连续死亡
            DieTimeList;
        true ->  %% 死亡间隔超过Time秒，清理数据
            []
    end,
    NewDieTimeList;
get_real_die_time_list_2(_, _, _) -> [].

cost_reborn(State, RoleId, BossType, BossId) ->
    case check_cost_reborn(State, RoleId, BossType, BossId) of
        {false, ErrCode} -> NewState = State;
        {true, common, _Cost} ->
            ErrCode = ?SUCCESS,
            {noreply, NewState} = boss_reborn(State, BossType, BossId);
        {true, old, _Cost} ->
            ErrCode = ?SUCCESS,
            {noreply, NewState} = mod_boss:do_handle_info({'boss_reborn', BossType, BossId}, State)
    end,
    {ok, BinData} = pt_460:write(46041, [ErrCode, BossType, BossId]),
    ?PRINT("46041 ErrCode:~p BossType:~p BossId:~p ~n", [ErrCode, BossType, BossId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    case ErrCode == ?SUCCESS of
        true ->
            %% 广播刷新信息
            {ok, BinData2} = pt_460:write(46042, [BossType, BossId]),
            lib_server_send:send_to_all(BinData2);
        false ->
            skip
    end,
    {noreply, NewState}.

check_cost_reborn(State, RoleId, BossType, BossId) ->
    BaseBossType = data_boss:get_boss_type(BossType),
    Result = if
        is_record(BaseBossType, boss_type) == false -> {false, ?MISSING_CONFIG};
        BaseBossType#boss_type.reborn_cost == [] -> {false, ?ERRCODE(err460_no_cost_reborn)};
        true ->
            #boss_type{reborn_cost = Cost} = BaseBossType,
            case mod_boss:get_boss_type_boss_info(State, BossType, BossId) of
                {false, _OldCode} ->
                    case get_status_map_info(State, BossType, BossId) of
                        {false, _CommonCode} -> {false, ?ERRCODE(err460_no_cfg)};
                        {ok, _ComStatusMap, _ComStatus, _BossMap, Boss} ->
                            #boss_status{reborn_time = RebornTime} = Boss,
                            if
                                RebornTime == 0 -> {false, ?ERRCODE(err460_no_die_to_cost_reborn)};
                                true -> {true, common, Cost}
                            end
                    end;
                {ok, _BossMap, Boss} ->
                    #boss_status{reborn_time = RebornTime} = Boss,
                    if
                        RebornTime == 0 -> {false, ?ERRCODE(err460_no_die_to_cost_reborn)};
                        true -> {true, old, Cost}
                    end
            end
    end,
    case Result of
        {false, ErrCode} -> {false, ErrCode};
        {true, _, NewCost} ->
            case lib_player:apply_call(RoleId, ?APPLY_CAST_SAVE, lib_boss, cost_reborn, [BossType, BossId, NewCost]) of
                {false, ErrCode} -> {false, ErrCode};
                true -> Result;
                _ -> {false, ?FAIL}
            end
    end.

%% -----------------------------------------------------
%% 秘境boss
%% -----------------------------------------------------

%% 加载秘境boss击杀
load_domain_kill() ->
    List = db_role_domain_boss_kill_select(),
    F = fun([RoleId, KillNum, GetListBin]) ->
        GetList = util:bitstring_to_term(GetListBin),
        #domain_boss_kill{role_id = RoleId, kill_num = KillNum, get_list = GetList}
    end,
    lists:map(F, List).

%% 获取秘境boss击杀
db_role_domain_boss_kill_select() ->
    Sql = io_lib:format(<<"SELECT role_id, kill_num, get_list FROM role_domain_boss_kill">>, []),
    db:get_all(Sql).

%% 插入秘境boss数据
db_role_domain_boss_kill_replace(BossKill) ->
    #domain_boss_kill{role_id = RoleId, kill_num = KillNum, get_list = GetList} = BossKill,
    GetListBin = util:term_to_bitstring(GetList),
    Sql = io_lib:format(<<"REPLACE INTO role_domain_boss_kill(role_id, kill_num, get_list) VALUES(~p, ~p, '~s')">>, [RoleId, KillNum, GetListBin]),
    db:execute(Sql).

%% 清理数据
db_role_domain_boss_kill_truncate() ->
    Sql = io_lib:format(<<"TRUNCATE TABLE role_domain_boss_kill">>, []),
    db:execute(Sql).