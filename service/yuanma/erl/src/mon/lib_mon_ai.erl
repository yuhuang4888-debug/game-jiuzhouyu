%% ---------------------------------------------------------------------------
%% @doc lib_mon_ai
%% @author ming_up@foxmail.com
%% @since  2016-09-10
%% @deprecated 怪物ai库函数
%% ---------------------------------------------------------------------------
-module(lib_mon_ai).

-include("scene.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("def_fun.hrl").
-include("figure.hrl").

-compile(export_all).

%% Atter:#battle_return_atter{}|none
born(State, StateName) ->
    Now = utime:longunixtime(),
    AiList = data_mon_ai_born:get(State#ob_act.object#scene_object.config_id),
    do_ai_list(AiList, State, Now, StateName, null).

die(State, Killer, StateName) ->
    Now = utime:longunixtime(),
    AiList = data_mon_ai_die:get(State#ob_act.object#scene_object.config_id),
    do_ai_list(AiList, State, Now, StateName, Killer).

walk_end(State, StateName) ->
    Now = utime:longunixtime(),
    AiList = data_mon_ai_walk_end:get(State#ob_act.object#scene_object.config_id, State#ob_act.path_ai_no),
    do_ai_list(AiList, State, Now, StateName, null).

%% 血量变化ai
hp_change(Hp1, Hp2, State, StateName) ->
    #ob_act{object=Object} = State,
    case data_mon_ai_hp:get(Object#scene_object.config_id) of
        [] -> {State, StateName};
        HpList ->
            #battle_attr{hp_lim=HpLim} = Object#scene_object.battle_attr,
            HpR1 = Hp1/HpLim,
            HpR2 = Hp2/HpLim,
            case hp_event_help(HpList, HpR1, HpR2) of
                false -> {State, StateName};
                {true, V} ->
                    case data_mon_ai_hp:get(Object#scene_object.config_id, V) of
                        [] -> {State, StateName};
                        AiList ->
                            do_ai_list(AiList, State, utime:longunixtime(), StateName, null)
                    end
            end
    end.

%% 判断血量变化
hp_event_help([], _HpR1, _HpR2) -> false;
hp_event_help([V|T], HpR1, HpR2) ->
    if
        HpR1 > V andalso HpR2 =< V -> {true, V};
        true -> hp_event_help(T, HpR1, HpR2)
    end.


%% 状态改变效果
wake_up(State, StateName) ->
    Object = State#ob_act.object,
    case data_mon_ai_state:get(Object#scene_object.config_id) of
        [] -> {State, StateName};
        AiList ->
            do_ai_list(AiList, State, utime:longunixtime(), StateName, null)
    end.

%% 状态回复变化
resume(State) ->
    util:cancel_timer(State#ob_act.eref),
    % ?MYLOG(State#ob_act.object#scene_object.config_id==4, "monai", "resume ~n", []),
    Object = State#ob_act.object,
    case data_mon_ai_resume:get(Object#scene_object.config_id) of
        [] -> {State#ob_act{eref = []}, sleep};
        AiList -> do_ai_list(AiList, State#ob_act{eref = []}, utime:longunixtime(), sleep, null)
    end.

%% 处理AI列表
do_ai_list([], ActState, _Now, StateName, _Killer) ->
    {ActState, StateName};
do_ai_list([{Type, Args, Time}|EffList], ActState, _Now, StateName, Killer) ->
    #ob_act{object = Minfo} = ActState,
    #scene_object{id = Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y, config_id=CfgId} = Minfo,

    Res = case Type of
        msg ->  %% 怪物头上冒泡泡说话
            lib_scene_object_ai:mon_speak(Minfo, Args),
            % [_Mid, _Msg] = Args,
            ok;

        %% create_bonfire -> %% 创建篝火
        %%     [PreMil, BonfireId] = Args,
        %%     case PreMil ==0 orelse PreMil >= 1000 orelse urand:rand(1, 1000) < PreMil of
        %%         true ->
        %%             case data_bonfire:get(BonfireId) of
        %%                 #bonfire{lifetime=LifeTime} ->
        %%                     EndTime = utime:unixtime() + LifeTime,
        %%                     #battle_return_atter{sign=Sign, id=PlayerId, team_id=TeamId, node=Node} = Killer,
        %%                     case TeamId > 0 of
        %%                         true ->
        %%                             SkillOwner = #skill_owner{id=PlayerId, team_id=TeamId, sign=Sign},
        %%                             mod_team:cast_to_team(TeamId, {'create_bonfire', BonfireId, Scene, ScenePoolId, CopyId, X, Y, EndTime, [{skill_owner, SkillOwner}]});
        %%                         _ ->
        %%                             lib_battle:rpc_cast_to_node(Node, lib_player, update_player_info, [PlayerId, [{create_bonfire, {BonfireId, X, Y, EndTime}}]])
        %%                     end;
        %%                 _ -> skip
        %%             end;
        %%         false -> skip
        %%     end,
        %%     ok;

        create_mon -> %% 创建怪物
            [PreMil, Mid, Xmin, Xmax, Ymin, Ymax, IsActive, OtherArgs] = Args,
            % ?MYLOG("hjhai", "create_mon:~p ~n", [create_mon]),
            case PreMil == 0 orelse PreMil >= 10000 orelse urand:rand(1, 10000) < PreMil of
                true ->
                    case create_mon_xy(Xmin, Xmax, Ymin, Ymax, {Scene, CopyId, X, Y}) of
                        %% 在玩家脚下创建N只
                        {user_pos, N} ->
                            Data = [X, Y, Minfo#scene_object.tracing_distance, N],
                            case lists:keytake(create_delay, 1, OtherArgs) of
                                false -> lib_mon:create_mon_on_user(Scene, ScenePoolId, CopyId, Data, Mid, IsActive, OtherArgs);
                                {value, {create_delay, DelayTime}, OtherArgs2} ->
                                    % 防止延迟期间清理了场景导致产出怪物,所以无法用进程处理,只能去场景进程处理
                                    mod_scene_agent:add_mon_create_delay(Scene, ScenePoolId, CopyId, DelayTime, 
                                        {lib_mon, create_mon_on_user, [Scene, ScenePoolId, CopyId, Data, Mid, IsActive, OtherArgs2]})
                            end;
                        {Xzero, Yzero} ->
                            case lists:keytake(create_delay, 1, OtherArgs) of
                                false -> lib_mon:async_create_mon(Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs);
                                {value, {create_delay, DelayTime}, OtherArgs2} ->
                                    % 防止延迟期间清理了场景导致产出怪物,所以无法用进程处理,只能去场景进程处理
                                    mod_scene_agent:add_mon_create_delay(Scene, ScenePoolId, CopyId, DelayTime, 
                                        {lib_mon, async_create_mon, [Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs2]})
                            end;     
                        _ ->
                            skip
                    end;
                false -> skip
            end,
            ok;

        create_mon_with_xy_type -> %% 带坐标类型创建怪物
            [PreMil, Mid, Xmin, Xmax, Ymin, Ymax, XyType, IsActive, SpArgs, OtherArgs] = Args,
            case PreMil ==0 orelse PreMil >= 10000 orelse urand:rand(1, 10000) < PreMil of
                true ->
                    case lists:keyfind(create_delay, 1, SpArgs) of
                        {create_delay, CreateDelayTime} when CreateDelayTime > 0 -> ok;
                        _ -> CreateDelayTime = 0
                    end,
                    case lists:keyfind(num, 1, SpArgs) of
                        {num, MonNum} when MonNum > 0 -> ok;
                        _ -> MonNum = 1
                    end,
                    if
                        CreateDelayTime == 0 ->
                            F = fun(_Seq) ->
                                {Xzero, Yzero} = create_mon_with_xy_type(Xmin, Xmax, Ymin, Ymax, XyType, Minfo),
                                lib_mon:async_create_mon(Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs)
                            end,
                            lists:foreach(F, lists:seq(1, MonNum));
                        true ->
                            F = fun(_Seq) ->
                                {Xzero, Yzero} = create_mon_with_xy_type(Xmin, Xmax, Ymin, Ymax, XyType, Minfo),
                                % 防止延迟期间清理了场景导致产出怪物,所以无法用进程处理,只能去场景进程处理
                                mod_scene_agent:add_mon_create_delay(Scene, ScenePoolId, CopyId, CreateDelayTime, 
                                    {lib_mon, async_create_mon, [Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs]})
                            end,
                            lists:foreach(F, lists:seq(1, MonNum))
                    end;      
                false -> 
                    skip
            end,
            ok;

        create_mon_extra -> %% 根据权重，创建怪物
            ArgsElem = urand:rand_with_weight(Args),
            case ArgsElem of
                [PreMil, Mid, Xmin, Xmax, Ymin, Ymax, IsActive, OtherArgs] ->
                    case PreMil ==0 orelse PreMil >= 10000 orelse urand:rand(1, 10000) < PreMil of
                        true -> 
                            % OtherArgs2 = OtherArgs,
                            {Xzero, Yzero} = create_mon_xy(Xmin, Xmax, Ymin, Ymax, {Scene, CopyId, X, Y}),
                            % lib_mon:async_create_mon(Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs2);
                            case lists:keytake(create_delay, 1, OtherArgs) of
                                false -> lib_mon:async_create_mon(Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs);
                                {value, {create_delay, DelayTime}, OtherArgs2} ->
                                    % 防止延迟期间清理了场景导致产出怪物,所以无法用进程处理,只能去场景进程处理
                                    mod_scene_agent:add_mon_create_delay(Scene, ScenePoolId, CopyId, DelayTime, 
                                        {lib_mon, async_create_mon, [Mid, Scene, ScenePoolId, Xzero, Yzero, IsActive, CopyId, 1, OtherArgs2]})
                            end;              
                        false -> skip
                    end;
                _ -> skip
            end,
            ok;

        remove ->
            erlang:send_after(Args, Minfo#scene_object.aid, {'stop', 1}),
            ok;
        die ->
            erlang:send_after(Args, Minfo#scene_object.aid, 'die'),
            ok;

        clear_scene_mon when is_list(Args) ->
            lib_mon:clear_scene_mon_by_mids(Scene, ScenePoolId, CopyId, 1, Args),
            ok;

        skill ->
            % ?MYLOG("hjhai", "skill Args:~p ~n", [Args]),
            {EffList, Minfo#scene_object{skill=Args}, StateName, ActState};

        % 技能公共cd配置
        pub_skill_cd_cfg ->
            % ?MYLOG("hjhai", "pub_skill_cd_cfg Args:~p ~n", [Args]),
            lib_scene_object:update(Minfo, [{pub_skill_cd_cfg, Args}]),
            {EffList, Minfo#scene_object{pub_skill_cd_cfg=Args}, StateName, ActState};

        signed -> %% 标记
            #ob_act{ai_event=AiEvent} = ActState,
            case lists:member({signed, Args}, AiEvent) of
                true -> ok;
                false ->
                    AiEvent1 = [{signed, Args}|AiEvent],
                    {EffList, Minfo, StateName, ActState#ob_act{ai_event=AiEvent1}}
          end;

        del_sign -> %% 移除标记值
            #ob_act{ai_event=AiEvent} = ActState,
            case lists:member({signed, Args}, AiEvent) of
                true  -> ok;
                false ->
                    {EffList, Minfo, StateName, ActState#ob_act{ai_event=lists:delete({signed, Args}, AiEvent)}}
            end;

        is_signed -> %% 判断有该值则执行后面的事件
            [Value, N] = Args,
            #ob_act{ai_event=AiEvent} = ActState,
            {_, LeftEffList} = case N < length(EffList) of
                                 true -> lists:split(N, EffList);
                                 false -> {EffList, []}
                             end,
            NewEffList = case lists:member({signed, Value}, AiEvent) of  %% 怪物ai事件
                           false -> LeftEffList;
                           true  -> EffList
                       end,
            {NewEffList, Minfo, StateName, ActState};

        rand -> %% 随机执行后面的语句
            [PercentageList, NList] = Args,
            NewEffList = handle_rand_list(PercentageList, NList, EffList),
            {NewEffList, Minfo, StateName, ActState};

        nochange -> %%不作任何改变
            ok;

        eff_other_mon -> %% 影响同场景的怪物
            [Mids, N] = Args,
            {OtherMonEfflist, LeftEffList} = case N < length(EffList) of
                                               true -> lists:split(N, EffList);
                                               false -> {EffList, []}
                                           end,
            case lib_mon:get_scene_mon_by_mids(Scene, ScenePoolId, CopyId, Mids, #scene_object.aid) of
                [] -> ok;
                skip -> ok;
                EffectML -> 
                    [Aid ! {'special_event', OtherMonEfflist} || Aid <- EffectML]
            end,
            {LeftEffList, Minfo, StateName, ActState};

        state -> %% 状态转变
            NewStateName = Args,
            {EffList, Minfo, NewStateName, ActState};

        ac_skill -> %% 释放技能
            case Args of
                {act_now, SkillId, SkillLv} ->
                    NewActState = lib_scene_object_ai:object_ac_skill(ActState, SkillId, SkillLv),
                    {EffList, Minfo, StateName, NewActState};
                _ ->
                    TempSkill = Minfo#scene_object.temp_skill,
                    {EffList, Minfo#scene_object{temp_skill=TempSkill++Args}, StateName, ActState}
            end;
        walk -> %% 走到目标位置
            [TX, TY, PathNo] = Args,
            Path = lib_scene_object_ai:dest_path(X, Y, TX, TY, Scene),
            {EffList, Minfo, walk, ActState#ob_act{path=Path, path_ai_no=PathNo}};
        path -> %% 23:设定怪物路径
            [Path, PathNo] = Args, %% 格式为[{scene_id, x, y}, ....]
            {EffList, Minfo, walk, ActState#ob_act{path=Path, path_ai_no=PathNo}};

        ai_id -> %% 获取ai库并且执行
            EffList1 = case data_ai:get(Minfo#scene_object.id) of
                [] -> EffList;
                AIContentL -> AIContentL++EffList
            end,
            {EffList1, Minfo, StateName, ActState};

        %% 彻底睡眠
        %% @param [下一个状态,睡眠毫秒数]
        thorough_sleep ->
            [NextStateName, SleepTime] = Args,
            util:send_after(none, SleepTime, Minfo#scene_object.aid, {'remove_thorough_sleep', NextStateName}),
            % ?MYLOG("hjh", "thorough_sleep Id:~p ~n", [Minfo#scene_object.id]),
            {EffList, Minfo, thorough_sleep, ActState};

        %% 狂暴 
        %% @param [是否要狂暴,进入狂暴时间(秒),接取后续ai的数量]
        frenzy ->
            #ob_act{frenzy_ref = OldFrenzyRef} = ActState,
            #scene_object{frenzy_enter_time = OldFrenzyEnterTime} = Minfo,
            case Args of
                [0, _EnterTime, _N] when OldFrenzyEnterTime > 0 ->
                    util:cancel_timer(OldFrenzyRef),
                    lib_scene_object_ai:mon_frenzy(Minfo, 0),
                    {EffList, Minfo#scene_object{frenzy_enter_time = 0}, StateName, ActState#ob_act{frenzy_ref=[]}};
                [1, EnterTime, N] -> 
                    {FrenzyEfflist, LeftEffList} = case N < length(EffList) of
                        true -> lists:split(N, EffList);
                        false -> {EffList, []}
                    end,
                    FrenzyRef = util:send_after(OldFrenzyRef, EnterTime*1000, Minfo#scene_object.aid, {'frenzy', FrenzyEfflist}),
                    EndTime = utime:unixtime()+EnterTime,
                    lib_scene_object_ai:mon_frenzy(Minfo, EndTime),
                    {LeftEffList, Minfo#scene_object{frenzy_enter_time = EndTime}, StateName, ActState#ob_act{frenzy_ref=FrenzyRef}};
                _ -> 
                    ok
            end;

        %% 血量关联
        %% @param {hp_relate, [[怪物id,...],[{类型,{数值下限,数值上限},{执行开始数量，执行结束数量}},...],总数量], Time}
        hp_relate ->
            [MonIdL, RangeL, N] = Args,
            {HpEfflist, LeftEffList} = case N < length(EffList) of
                true -> lists:split(N, EffList);
                false -> {EffList, []}
            end,
            mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_mon_ai, mon_hp_relate, [Id, MonIdL, RangeL, HpEfflist]),
            {LeftEffList, Minfo, StateName, ActState};

        %% 目标技能释放
        %% @param {target_ac_skill, [Type,Num,[{SkillId,Lv},...]], Time}
        target_ac_skill ->
            [ReleaseType, Num, SkillL] = Args,
            target_ac_skill(ActState, ReleaseType, Num, SkillL),
            ok;

        %% 走路检查
        %% @param {check_walk, [是否可以走路(true|false), WalkType(1:公会), WalkTime(每次检查时间)], Time}
        check_walk ->
            [CanWalk, WalkType, WalkTime] = Args,
            #ob_act{walk_ref = OldWalkRef} = ActState,
            NewActState = ActState#ob_act{can_walk = CanWalk, walk_type = WalkType, walk_time = WalkTime},
            if
                WalkType == ?WALK_TYPE_GUILD ->
                    WalkRef = util:send_after(OldWalkRef, 200, Minfo#scene_object.aid, {'check_walk'});
                true ->
                    util:cancel_timer(OldWalkRef),
                    WalkRef = []
            end,
            {EffList, Minfo, StateName, NewActState#ob_act{walk_ref = WalkRef}};
        _ ->
            ok
    end,

    case Res of
        {LastEffList, LastMinfo, LastStateName, ActState1} ->  LastActState = ActState1#ob_act{object = LastMinfo};
        _ -> LastEffList = EffList, LastStateName = StateName, LastActState = ActState
    end,
    case Time of
        0     -> do_ai_list(LastEffList, LastActState, utime:longunixtime(), LastStateName, Killer);
        cycle ->
            case data_mon_ai_cycle:get(CfgId, 0) of
                [] -> {LastActState, LastStateName};
                CycleAiL ->
                    do_ai_list(CycleAiL, LastActState, utime:longunixtime(), LastStateName, Killer)
            end;
        {cycle, CycleType} ->
            case data_mon_ai_cycle:get(CfgId, CycleType) of
                [] -> {LastActState, LastStateName};
                CycleAiL ->
                    do_ai_list(CycleAiL, LastActState, utime:longunixtime(), LastStateName, Killer)
            end;
        _ ->
            ERef = send_after(Time, Minfo#scene_object.aid, {'special_event', LastEffList}, LastActState#ob_act.eref),
            {LastActState#ob_act{eref = ERef}, LastStateName}
    end.

%% =========================== 私有函数 ========================================================================================
%% 怪物招怪的坐标选取
create_mon_xy(N, N, N, N, _) when N < 0 ->
    {user_pos, -N};
create_mon_xy(Xmin, Xmax, Ymin, Ymax, {SceneId, CopyId, MonX, MonY})->
    X = if
            % Xmin < 0 orelse Xmax < 0        -> MonX;                          %% 在目标位置召唤
            Xmin < Xmax                     -> MonX + urand:rand(Xmin, Xmax); %% 在Xmin-Xmax直接随机偏移
            Xmin == Xmax andalso Xmin == 0  -> MonX;                          %% 当Xmin=Xmax=0，直接取父辈值
            Xmin == Xmax                    -> Xmin;                          %% 当Xmin=Xmax/=0，直接取Xmin值
            Xmin > Xmax                     -> MonX + Xmin                    %% 取固定偏移值
        end,
    Y = if
            % Ymin < 0 orelse Ymax < 0        -> MonY;                          %% 同X的取值规则
            Ymin < Ymax                     -> MonY + urand:rand(Ymin, Ymax);
            Ymin == Ymax andalso Ymin == 0  -> MonY;
            Ymin == Ymax                    -> Ymin;
            Ymin > Ymax                     -> MonY + Ymin
        end,
    Xzero = case X > 0 of true -> X; false -> 0 end,
    Yzero = case Y > 0 of true -> Y; false -> 0 end,
    case lib_scene:is_blocked(SceneId, CopyId, Xzero, Yzero) of
        false ->
            {Xzero, Yzero};
        true ->
            {MonX, MonY}
    end.

%% @param XyType
%%  1 => 矩环形 只要Xmin到Xmax之间随机长度加上怪物坐标X,Ymin到Ymax之间随机加上怪物坐标Y,中间的矩形不生成怪物
%%      lib_mon_ai:create_mon_with_xy_type(100, 120, 100, 120, 1, {1, 1, 100, 100}).
%%  2 => 怪物出生点复活
create_mon_with_xy_type(Xmin, Xmax, Ymin, Ymax, 1, #scene_object{scene=SceneId, copy_id=CopyId, x=MonX, y=MonY}) ->
    RightX = urand:rand(Xmin, Xmax),
    TopY = urand:rand(Ymin, Ymax),
    % 随机出左右
    case urand:rand(1, 10000) =< 5000 of
        true -> X = MonX+RightX;
        false -> X = MonX-RightX
    end,
    % 随机出上下
    case urand:rand(1, 10000) =< 5000 of
        true -> Y = MonY+TopY;
        false -> Y = MonY-TopY
    end,
    Xzero = case X > 0 of true -> X; false -> 0 end,
    Yzero = case Y > 0 of true -> Y; false -> 0 end,
    case lib_scene:is_blocked(SceneId, CopyId, Xzero, Yzero) of
        true -> {MonX, MonY};
        false -> {Xzero, Yzero}   
    end;
create_mon_with_xy_type(_Xmin, _Xmax, _Ymin, _Ymax, 2, #scene_object{d_x = DX, d_y = DY}) ->
    {DX, DY};
create_mon_with_xy_type(_Xmin, _Xmax, _Ymin, _Ymax, _XyType, #scene_object{x=MonX, y=MonY}) ->
    {MonX, MonY}.

%% 获取随机列表
handle_rand_list(PercentageList, NList, EffList) ->
    TotalN = lists:sum(NList),
    {RandL, LeftL} = lists:split(TotalN, EffList),
    RandR = urand:rand(1, ?RATIO_COEFFICIENT),
    ExcL = handle_rand_list_helper(PercentageList, NList, RandR, 0, 0, RandL),
    ExcL ++ LeftL.

handle_rand_list_helper([], _, _, _, _, _) -> [];
handle_rand_list_helper([Percent|TPercentageList], [N|TNList], RandR, LastPerCentPoint, LastN, EffList) ->
    case RandR =< Percent + LastPerCentPoint of
        true  ->
            {_, LeftEffList} = lists:split(LastN, EffList),
            {RandList, _} = lists:split(N, LeftEffList),
            RandList;
        false ->
            handle_rand_list_helper(TPercentageList, TNList, RandR, Percent + LastPerCentPoint, LastN + N, EffList)
    end.

%% 发送事件定时器
send_after(Time, Pid, Msg, ERef) ->
    util:cancel_timer(ERef),
    erlang:send_after(Time, Pid, Msg).

%% 怪物血量关联(场景进程)
%% @param [{关联boss列表},[{类型,{数值下限,数值上限},{执行开始数量，执行结束数量}},...],总数量]
%%  类型 
%%      1:整数计算, abs(主Hp-关联Hp) >= 数值下限 and abs(主Hp-关联Hp) =< 数值上限
%%      2:小数计算, abs(主Hp/主上限-关联Hp/关联上限) >= 数值下限 and aabs(主Hp/主上限-关联Hp/关联上限) =< 数值上限
mon_hp_relate(MyId, MonIdL, RangeL, HpEfflist) ->
    case lib_scene_object_agent:get_object(MyId) of
        #scene_object{aid = Aid, copy_id = CopyId, battle_attr = BA} ->
            BAReL = [TmpBA||{TmpId, TmpBA}<-
                lib_scene_object_agent:get_scene_mon_by_mids(CopyId, MonIdL, {#scene_object.id, #scene_object.battle_attr}), TmpId =/= MyId],
            EffList = mon_hp_relate_help(RangeL, HpEfflist,  MyId, BA, BAReL),
            ?IF(EffList =/= [], Aid ! {'special_event', EffList}, skip);
        _ ->
            skip
    end.

mon_hp_relate_help([], _HpEfflist, _MyId, _BA, _BAReL) -> [];
mon_hp_relate_help([{Type, {Min, Max}, {Start, End}}|T], HpEfflist, MyId, BA, BAReL) ->
    #battle_attr{hp = Hp, hp_lim = HpLim} = BA,
    if
        Type == 1 ->
            F = fun(#battle_attr{hp = TmpHp}) ->
                Diff = abs(Hp - TmpHp),
                Diff >= Min andalso Diff =< Max
            end,
            case lists:all(F, BAReL) of
                true -> 
                    case length(BAReL) >= Start andalso Start =< End of
                        true -> lists:sublist(HpEfflist, Start, End - Start + 1);
                        false -> []
                    end;
                false ->
                    mon_hp_relate_help(T, HpEfflist, MyId, BA, BAReL)
            end;
        true ->
            NewHpLim = max(1, HpLim),
            F = fun(#battle_attr{hp = TmpHp, hp_lim = TmpHpLim}) ->
                Diff = abs(Hp/NewHpLim - TmpHp/max(1, TmpHpLim)),
                Diff >= Min andalso Diff =< Max
            end,
            Res =
                if
                    BAReL == [] ->
                        Diff = Hp/NewHpLim,
                        Diff >= Min andalso Diff =< Max;
                    true ->
                        lists:all(F, BAReL)
            end,
            case Res of
                true -> 
                    case length(HpEfflist) >= Start andalso Start =< End of
                        true -> lists:sublist(HpEfflist, Start, End - Start + 1);
                        false -> []
                    end;
                false ->
                    mon_hp_relate_help(T, HpEfflist,  MyId, BA, BAReL)
            end
    end.

%% 目标技能释放（不能有副技能）
%% {target_ac_skill, [Type,Num,[{SkillId,Lv},...]], Time}
%%  Type=1 九宫格内随机刷选Num个玩家释放从技能池中抽取的技能,抽取过不会再抽取
target_ac_skill(ActState, ReleaseType, Num, SkillL) ->
    #ob_act{object = Minfo} = ActState,
    #scene_object{id = Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y} = Minfo,
    if
        ReleaseType == 1 ->
            ReleaseSkillL = lists:sublist(ulists:list_shuffle(SkillL), Num),
            mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, lib_mon_ai, target_ac_skill_on_scene, [Id, CopyId, X, Y, ReleaseSkillL]);
        true ->
            skip
    end,
    ok.

target_ac_skill_on_scene(Id, CopyId, X, Y, SkillL, EtsScene) ->
    AllArea = lib_scene_calc:get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    AllUser = lib_scene_agent:get_all_area_user(AllArea, CopyId),
    target_ac_skill_on_scene_help(SkillL, ulists:list_shuffle(AllUser), Id, EtsScene),
    ok.

target_ac_skill_on_scene_help([], _UserL, _Id, _EtsScene) -> skip;
target_ac_skill_on_scene_help(_SkillL, [], _Id, _EtsScene) -> skip;
target_ac_skill_on_scene_help([{SkillId, SkillLv}|SkillL], [#ets_scene_user{id = RoleId}|UserL], Id, EtsScene) ->
    lib_battle:assist_anything(?BATTLE_SIGN_MON, Id, ?BATTLE_SIGN_PLAYER, RoleId, SkillId, SkillLv, EtsScene),
    target_ac_skill_on_scene_help(SkillL, UserL, Id, EtsScene);
target_ac_skill_on_scene_help(_, _, _Id, _EtsScene) ->
    skip.

%% 检查走路
check_walk(ObjectId, WalkType, EtsScene) ->
    case lib_scene_object_agent:get_object(ObjectId) of
        #scene_object{aid = Aid, figure = #figure{guild_id = GuildId}, copy_id = CopyId, x = X, y = Y, striking_distance = Area} = Minfo ->
            if
                WalkType == ?WALK_TYPE_GUILD andalso GuildId > 0 ->
                    AllArea = lib_scene_calc:get_the_area(EtsScene#ets_scene.origin_type, X, Y),
                    AllUsers = lib_scene_agent:get_all_area_user(AllArea, CopyId),
                    Xmax = X + Area,
                    Xmin = X - Area,
                    Ymax = Y + Area,
                    Ymin = Y - Area,
                    F = fun(User, Acc) -> 
                        #ets_scene_user{id = Uid, server_id = USerId, figure = #figure{name = Uname, position = Upos, guild_id = UserGuildId}} = User,
                        if
                            GuildId == UserGuildId andalso not (X > Xmax orelse X < Xmin orelse Y > Ymax orelse Y < Ymin) ->
                                [{Uid, USerId, Uname, Upos}|Acc];
                            true ->
                                Acc
                        end                         
                    end,
                    GuildUser = lists:foldl(F, [], AllUsers),
                    Result = length(GuildUser) > 0,
                    lib_escort:walk_check_back(Minfo, GuildUser),
                    Aid ! {'check_walk_back', WalkType, Result};
                true ->
                    skip
            end;
        _ ->
            skip
    end.
            