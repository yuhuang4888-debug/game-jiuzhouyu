%% ---------------------------------------------------------------------------
%% @doc mod_dummy_active
%% @author ming_up@foxmail.com
%% @since  2017-04-01
%% @deprecated 假人进程
%% ---------------------------------------------------------------------------
-module(mod_dummy_active).
-behaviour(gen_fsm).


%% 消息处理
-export([stop/2]).
%% 怪物状态
-export([
        sleep/2, trace/2, find_target/2, dead/2, thorough_sleep/2, back/2, walk/2, revive/2
]).
-export([start/1]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("server.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("battle.hrl").

%%开启一个怪物活动进程
start(M)->
    gen_fsm:start(?MODULE, M, []).

%% 清理怪物
stop(Aid, BroadCast) ->
    Aid ! {'stop', BroadCast}.

%% 怪物属性和初始状态初始化
init([Id, _ConfigId, Scene, ScenePoolId, Xpx, Ypx, Type, CopyId, BroadCast, Arg]) -> 
    Dummy  = #scene_object{sign=?BATTLE_SIGN_DUMMY, id=Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx, aid=self(), type=Type, warning_range = 1200},

    {State, _, _} = lib_scene_object:set_args(Arg, #ob_act{object = Dummy}, null, 0, []),

    lib_scene_object:insert(State#ob_act.object),
    % ?DEBUG("objct create sign ~w, id ~w, ~s~n", [?BATTLE_SIGN_DUMMY, Id, ulists:list_to_bin(State#ob_act.object#scene_object.figure#figure.name)]),
    %% 广播怪物
    % ?DEBUG("State#ob_act.object:~p~n",[State#ob_act.object]),
    case BroadCast of
        0 -> skip;
        _ -> lib_scene_object:broadcast_object(State#ob_act.object)
    end,

    {ok, sleep, State}.

handle_event(_Event, StateName, Status) ->
    {next_state, StateName, Status}.

handle_sync_event(_Event, _From, StateName, Status) ->
    {reply, ok, StateName, Status}.

handle_info(_, dead, State) -> 
    {next_state, dead, State};


%% 清理怪物
handle_info({'stop', Broadcast}, _StateName, State) -> 
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, Broadcast),
    {stop, normal, State};

handle_info(_, thorough_sleep, State) -> 
    {next_state, thorough_sleep, State};

handle_info({'battle_info', BattleReturn}, StateName, State) ->
    #battle_return{
        hp = Hp,
        hurt = FullHurt,
        move_x = MoveX,
        move_y = MoveY,
        taunt = Taunt,
        attr_buff_list = AttrBuffList,
        other_buff_list = OtherBuffList,
        atter = Atter,
        sign  = AtterSign  %% 1：怪物， 2：人
    } = BattleReturn,
    #battle_return_atter{hide=AtterHide, real_id=RealId, real_sign=RealSign, x=Xatt, y=Yatt} = Atter,
    #ob_act{att=OldAtt, object = Object, ref=Ref, die_handler = DieHandler} = State,
    #scene_object{x=Xnow, y=Ynow, pos=Pos} = Object,

    Hurt = min(FullHurt, Object#scene_object.battle_attr#battle_attr.hp),
    
    Object1 = Object#scene_object{
        battle_attr = Object#scene_object.battle_attr#battle_attr{hp=max(0,Hp), attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList},
        x = case MoveX == 0 of true -> Object#scene_object.x; false -> MoveX end,
        y = case MoveY == 0 of true -> Object#scene_object.y; false -> MoveY end
    },

    State1 = State#ob_act{object = Object1},
    lib_scene_object_event:be_hurted(Object1, Atter, AtterSign, Hurt),
    if
        Hp =< 0 ->
            Ref1 = lib_scene_object:send_event_after(Ref, 2000, repeat), %% 2秒播放死亡动作
            lib_scene_object_event:be_killed(Object1, [], Atter, AtterSign),
            case DieHandler of
                {Mod, Fun, Args} ->
                    case catch Mod:Fun(Object1, [], Atter, AtterSign, Args) of
                        {'EXIT', Err} ->
                            ?ERR("apply ~p error ~p~n", [DieHandler, Err]);
                        _ ->
                            ok
                    end;
                _ ->
                    ok
            end,
            {next_state, dead, State#ob_act{att=undefined, ref=Ref1} };
        true ->
            NewAttTarget = if
                AtterHide == 1 -> OldAtt;
                OldAtt == undefined -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>AtterSign};
                Taunt == {0, 0} -> 
                    case OldAtt of
                        #{x:=Xtr, y:=Ytr} when Pos == 0 andalso  %% Pos > 0 则表示要按照阵法来，不能随意更改目标 
                                               ((abs(Xtr-Xnow) > 300 andalso abs(Xtr-Xnow) > abs(Xatt-Xnow)) orelse 
                                                (abs(Ytr-Ynow) > 150 andalso abs(Ytr-Ynow) > abs(Yatt-Ynow))) -> 
                            #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign};
                        _ -> 
                            OldAtt
                    end;
                true -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>AtterSign}
            end,
            if 
                StateName == sleep orelse StateName == find_target ->  
                    Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                    {next_state, trace, State1#ob_act{att=NewAttTarget, ref=Ref1}};
                true -> 
                    {next_state, StateName, State1#ob_act{att=NewAttTarget}}
            end
    end;

handle_info({'combo_battle_back', Res}, StateName, State) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    NewState = lib_scene_object_ai:battle_combo_res(SelectedSkillInfo, State, Res),
                    {next_state, StateName, NewState};
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    {next_state, StateName, State#ob_act{object = BackObj}}
            end;
        _ ->
            {next_state, StateName, State}
    end;

handle_info({'combo_assist_back', Res}, StateName, State) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    NewState = lib_scene_object_ai:assist_combo_res(SelectedSkillInfo, State, Res),
                    {next_state, StateName, NewState};
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    {next_state, StateName, State#ob_act{object = BackObj}}
            end;
        _ ->
            {next_state, StateName, State}
    end;


handle_info({'object_assist_back', Res}, StateName, State) ->
    #ob_act{selected_skill = SelectSkillMap, ref = Ref, object = SceneObject} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    {Next, Args} = lib_scene_object_ai:handle_assist_res(State, SelectedSkillInfo, SceneObject, Ref, Res),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State),
                    NextStateName = case Next of
                        trace -> trace;
                        _     -> back
                    end,
                    {next_state, NextStateName, AfBattleState};
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
                    {next_state, StateName, State#ob_act{ref = Ref1}}
            end;
        _ ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1}}
    end;

handle_info({'object_battle_back', Res}, StateName, State) ->
    #ob_act{selected_skill = SelectSkillMap, ref = Ref, object = SceneObject} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    {Next, Args} = lib_scene_object_ai:handle_battle_res(State, SelectedSkillInfo, SceneObject, Ref, Res),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State),
                    NextStateName = case Next of
                                        trace -> trace;
                                        _     -> back
                                    end,
                    {next_state, NextStateName, AfBattleState};
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
                    {next_state, StateName, State#ob_act{ref = Ref1}}
            end;
        _ ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            {next_state, StateName, State#ob_act{ref = Ref1}}
    end;


%% 设置战斗状态
handle_info({'battle_attr', BA}, StateName, State) ->
    #ob_act{object=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA}}};

%% 设置buff
handle_info({'buff', AttrBuffL, OtherBuffL}, StateName, State) ->
    #ob_act{object=#scene_object{battle_attr=BA}=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL, other_buff_list=OtherBuffL}}}};

handle_info({'change_attr', KeyValues}, StateName, State) -> 
    {NewState, NewStateName, UpList} = lib_scene_object:set_args(KeyValues, State, StateName, 1, []),
    lib_scene_object:update(NewState#ob_act.object, UpList),
    Ref1 = case NewStateName /= StateName of
        true  -> lib_scene_object:send_event_after(NewState#ob_act.ref, 0, repeat);
        false -> NewState#ob_act.ref
    end,
    {next_state, NewStateName, NewState#ob_act{ref = Ref1}};

%% 持续施放副技能
handle_info({'combo', Args}, StateName, State) -> 
    State1 = lib_scene_object_ai:combo(Args, State),
    {next_state, StateName, State1};

%% 持续施放特殊副技能
handle_info({'find_target_combo', Args}, StateName, State) -> 
    State1 = lib_scene_object_ai:find_target_combo(Args, State),
    {next_state, StateName, State1};

%% 寻找新目标
handle_info('find_target', _StateName, State) -> 
    Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 0, repeat),
    {next_state, find_target, State#ob_act{ref=Ref1}};

%% 睡眠
handle_info('sleep', _StateName, State) ->
    {next_state, sleep, State};

%% 走路
handle_info('walk', _StateName, State) ->
    Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 0, repeat),
    {next_state, walk, State#ob_act{ref=Ref1}};

handle_info('thorough_sleep', _StateName, State) ->
    {next_state, thorough_sleep, State};

%% debuff伤害处理
handle_info({debuff_hurt, _EventId, _Hurt, NewHp}, StateName, State) ->
    #ob_act{object = Obj} = State,
    #scene_object{battle_attr = BA} = Obj,
    #battle_attr{hp = Hp} = BA,
    if 
        Hp =/= NewHp ->
            BA1 = BA#battle_attr{hp = NewHp},
            Obj1 = Obj#scene_object{battle_attr = BA1},
            State1 = State#ob_act{object = Obj1},
            % {HpAiState, HpAiStateName} = lib_mon_ai:hp_change(Hp, NewHp, State1, StateName),
            {next_state, StateName, State1};
        true ->
            {next_state, StateName, State}
    end;

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(normal, _StateName, _Status) ->
    ok;
terminate(Reason, _StateName, _Status) ->
    Object = _Status#ob_act.object,
    ?ERR("error_terminate:SceneId:~p, CopyId:~p,~n Reason:~p~n", [Object#scene_object.scene, Object#scene_object.copy_id, Reason]),
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.

%% =========处理怪物所有状态=========

%%静止状态并回血
sleep(_R, State) ->
    {next_state, sleep, State}.

%% 彻底休眠状态，只接受死亡信息
thorough_sleep(_R, State) ->
    {next_state, thorough_sleep, State}.

%% 战斗死亡
%% 死亡
dead(_R, State) ->
    #ob_act{object=Object, ref=Ref, revive_time = ReTime} = State,
    if
        ReTime =< 0 ->
            util:cancel_timer(Ref),
            lib_scene_object:stop(Object, 1),
            {stop, normal, State};
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, ReTime, repeat),
            {next_state, revive, State#ob_act{ref=Ref1}}
    end.

%% 复活
revive(_R, State) ->
    #ob_act{object = Minfo, ref=Ref, born_handler = BornHandler} = State,
    #scene_object{battle_attr=BA} = Minfo,
    #battle_attr{hp_lim=HpLim} = BA,
    NewMinfo = Minfo#scene_object{battle_attr=BA#battle_attr{hp = HpLim}},
    case BornHandler of
        {BornM, BornF, BornA} ->
            case BornM:BornF(revive, NewMinfo, BornA) of
                NewMinfo2 when is_record(NewMinfo2, scene_object) -> ok;
                _ -> NewMinfo2 = NewMinfo
            end;
        _ ->
            NewMinfo2 = NewMinfo
    end,
    lib_scene_object:update(NewMinfo2, [{hp, HpLim}]),
    lib_scene_object:broadcast_object(NewMinfo2),
    Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
    {next_state, back, State#ob_act{object = NewMinfo2, ref = Ref1}}.

%% 追踪
trace(_R, State) ->
    #ob_act{att=Att, object=Object, next_att_time=NextAttTime, ref=Ref, skill_link_info=SkillLinkInfo, check_block = CheckBlock, release_skill = ReleaseSkill} = State,
    #scene_object{scene=SceneId, scene_pool_id=ScenePoolId} = Object,
    case Att of
        undefined -> %% 目标丢失，尝试等待
            Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 500, repeat),
            {next_state, find_target, State#ob_act{ref=Ref1}};
        #{id:=Id, sign:=Sign} -> %% 有目标
            case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_trace_info, [Sign, Id]) of
                {_Hp, X, Y} -> 
                    NowTime = utime:longunixtime(),
                    {Next, Args}  = lib_scene_object_ai:trace_to_att(Object, X, Y, {target, Sign, Id}, Ref, NextAttTime, 0, NowTime, SkillLinkInfo, CheckBlock, ReleaseSkill),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State#ob_act{att=Att#{x=>X, y=>Y}}),
                    % case Next/=trace of
                    %     true -> 
                    %         % ?PRINT("================== next ~s, ~w~n", [ulists:list_to_bin(Object#scene_object.figure#figure.name),
                    %                 % {Next, Object#scene_object.sign, Object#scene_object.id, Object#scene_object.battle_attr#battle_attr.speed}]);
                    %     _ -> skip
                    % end,
                    case Next of
                        trace -> {next_state, trace, AfBattleState};
                        back  -> {next_state, back, AfBattleState};
                        error -> {next_state, sleep, AfBattleState};
                        _     -> {next_state, sleep, AfBattleState}
                    end;
                _O -> 
                    % ?PRINT("================== target error ~s, ~w~n", [ulists:list_to_bin(Object#scene_object.figure#figure.name), {_O, Sign, Id}]),
                    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                    {next_state, find_target, State#ob_act{att=undefined, ref=Ref1}}
            end
    end.

%% 查找target
find_target(_, State) -> 
    #ob_act{object=Object, ref=Ref} = State,
    #scene_object{id=ObjectId, sign=ObjectSign, x=ObjectX, y=ObjectY, scene=SceneId, scene_pool_id=ScenePoolId, copy_id=CopyId, warning_range = WarningRange,
        battle_attr=BA, skill_owner=SkillOwner} = Object,

    {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),
    % Args = {BA#battle_attr.group, ObjectSign, ObjectId, OwnerSign, OwnerId},
    Args = #scene_calc_args{
        group = BA#battle_attr.group, sign = ObjectSign, id = ObjectId, owner_sign = OwnerSign, owner_id = OwnerId,
        guild_id = lib_scene_object_ai:get_guild_id(Object), 
        pk_status = lib_scene_object_ai:get_pk_status(Object)
        },
    case mod_scene_agent:apply_call_with_state(SceneId, ScenePoolId, lib_scene_calc, get_area_for_trace,
            [CopyId, ObjectX, ObjectY, WarningRange, Args, {closest, ObjectX, ObjectY}]) of
        {TgSign, TgId, TgPid, TgX, TgY} -> 
            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
            {next_state, trace, State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}, ref=Ref1}};
        _A -> 
            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
            {next_state, back, State#ob_act{ref=Ref1}}
    end.

back(_, State) ->
    #ob_act{object = Minfo, ref = Ref, path = Path} = State,
    #scene_object{battle_attr=BA} = Minfo,
    case BA#battle_attr.hp =< 0 of
        true ->
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, dead, State#ob_act{att = undefined, ref=Ref1, back_dest_path=null}};
        false ->
            case Path of
                [] ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 2000, repeat),
                    {next_state, find_target, State#ob_act{ref=Ref1, att = undefined}};
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                    {next_state, walk, State#ob_act{ref=Ref1, att = undefined}}
            end
    end.

walk(_R, State) ->
    #ob_act{object=Minfo, path=MonPath, ref=Ref} = State,
    #scene_object{scene = MSceneId, battle_attr= BA, x = X, y = Y} = Minfo,
    case MonPath of
        [] ->
            Ref1 = lib_scene_object:send_event_after(Ref, 2000, repeat),
            {next_state, find_target, State#ob_act{ref=Ref1}};
        [WPoint|RemainPath] ->
            case WPoint of
                {SceneId, NextX, NextY} ->
                    ok;
                {NextX, NextY} ->
                    SceneId = MSceneId
            end,
            case SceneId =/= MSceneId of
                true ->
                    %% 切换怪物场景
                    NewMinfo = Minfo#scene_object{scene = SceneId, x = NextX, y = NextY},
                    %% 消失
                    lib_scene_object:stop(Minfo, 1),
                    %% 有怪物进入
                    lib_scene_object:insert(NewMinfo),
                    lib_scene_object:broadcast_object(NewMinfo),

                    Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
                    {next_state, find_target, State#ob_act{object=NewMinfo, ref=Ref1, path=RemainPath, w_point = {NextX, NextY}}};
                false -> %% 继续走
                    #battle_attr{speed=Speed} = BA,
                    NowTime = utime:longunixtime(),
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        {false, MoveWaitMs} ->
                            Ref1 = lib_scene_object:send_event_after(Ref, MoveWaitMs, repeat),
                            {next_state, find_target, State#ob_act{ref=Ref1}};
                        false ->
                            {next_state, sleep, State#ob_act{att=undefined}};
                        true ->
                            case lib_scene_object_ai:move(NextX, NextY, Minfo, Speed, false) of
                                block ->
                                    Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                                    {next_state, sleep, State#ob_act{ref=Ref1, path=[]}};
                                {true, NewMinfo, Time} ->
                                    lib_mon_event:move(NewMinfo),
                                    Ref1 = lib_scene_object:send_event_after(Ref, Time, repeat),
                                    {next_state, find_target, State#ob_act{object=NewMinfo, ref=Ref1, path=RemainPath, o_point = {X, Y}, w_point = {NextX, NextY}}}
                            end
                    end
            end
    end.

