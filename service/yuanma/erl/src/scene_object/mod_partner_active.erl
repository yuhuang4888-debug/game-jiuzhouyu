%% ---------------------------------------------------------------------------
%% @doc mod_partner_active
%% @author ming_up@foxmail.com
%% @since  2017-02-06
%% @deprecated 伙伴行为
%% ---------------------------------------------------------------------------
-module(mod_partner_active).
-behaviour(gen_fsm).

%% 消息处理
-export([stop/2, ripple/6, follow/3, master_be_atted/3, master_att/3]).
%% 怪物状态
-export([
         idle/2, sleep/2, follow/2, trace/2, dead/2, find_target/2, escape/2, thorough_sleep/2
        ]).
-export([start/1]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("server.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("battle.hrl").
-include("partner.hrl").

%% 开启一个场景对象进程
start(M)->
    gen_fsm:start(?MODULE, M, []).

%% 清理场景对象
stop(Aid, Broadcast) ->
    Aid ! {'stop', Broadcast}.

%% 通知此对象有其他对象进入其警戒区
ripple(Aid, Id, Pid, Sign, X, Y) ->
    Aid ! {'ripple', Id, Pid, Sign, X, Y}.

%% 主人移动
follow(Aid, X, Y) ->
    Aid ! {'follow', X, Y}.

%% 主人受到攻击
master_be_atted(Aid, AtterSign, AtterId) ->
    Aid ! {'handle_personlity', {AtterSign, AtterId}}.

%% 主人攻击
master_att(Aid, DerSign, DerId) ->
    Aid ! {'handle_personlity', {DerSign, DerId}}.

%% 怪物属性和初始状态初始化
init([Id, ConfigId, Scene, ScenePoolId, Xpx, Ypx, Type, CopyId, BroadCast, Args]) ->
    case data_partner:get_partner_by_id(ConfigId) of
        [] ->
            {stop, normal};
        P ->
            %% Personality = 1,
            #base_partner{name=Name, career=Career, model_id=ModelId, weapon_id=WeaPonId, attack_skill=AttackSkill,
                          talent_skill=TalentSkill, personality=Personality, chartlet_id=ChartletId} = P,
            Figure = #figure{name=Name, career=Career, lv_model=[{1, ModelId},{2, WeaPonId}]},
            SceneObject = #scene_object{sign=?BATTLE_SIGN_PARTNER, id=Id, config_id=ConfigId,
                                        scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=Xpx, y=Ypx,
                                        icon_texture = ChartletId, type=Type, figure=Figure, aid=self(),
                                        warning_range = 600, att_time=1200, skill=[{AttackSkill,1},{TalentSkill,1}], partner=Personality},

            {State, _, _} = lib_scene_object:set_args(Args, #ob_act{object = SceneObject, follow={Xpx, Ypx}}, null, 0, []),

            Obj = State#ob_act.object,
            BA1 = Obj#scene_object.battle_attr,
            Attr = BA1#battle_attr.attr,

            Attr1 = case Personality of
                        %% 2  -> Attr#attr{crit_del = Attr#attr.crit_del+400};
                        %% 6  -> erlang:send_after(3000, self(), 'timer_handle_personlity'), Attr;
                        %% 8  -> Attr#attr{all_resis = round(Attr#attr.all_resis*1.1)};
                        %% 9  -> erlang:send_after(3000, self(), 'timer_handle_personlity'), Attr;
                        %% 10 -> Attr#attr{hp_resume_add = round(Attr#attr.hp_resume_add*1.1)};
                        %% 14 -> Attr#attr{effect_resis = round(Attr#attr.effect_resis*1.45)};
                        _  -> Attr
                    end,

            Obj1 = Obj#scene_object{battle_attr=BA1#battle_attr{attr=Attr1}},
            State1 = State#ob_act{object = Obj1, handle_time=utime:unixtime() },

            lib_scene_object:insert(Obj1),

            %% 广播
            case BroadCast of
                0 -> skip;
                _ -> lib_scene_object:broadcast_object(Obj1)
            end,

            %% ?PRINT("objct create sign ~w, id ~w, ~s~n", [?BATTLE_SIGN_PARTNER, Id, ulists:list_to_bin(State1#ob_act.object#scene_object.figure#figure.name)]),

            erlang:send_after(2000, self(), 'set_scene_partner'),

            {ok, idle, State1}
    end.

handle_event(_Event, StateName, Status) ->
    {next_state, StateName, Status}.

handle_sync_event(_Event, _From, StateName, Status) ->
    {reply, ok, StateName, Status}.


-define(LEAVE_MAX_SQUARE, 1690000). %% 离开主人最远距离像素的平方
-define(LEAVE_MIN_SQUARE, 160000).  %% 离开主人最近距离像素的平方，小于这个距离不移动
%% ===================================================进程消息处理====================================================
handle_info(_, dead, State) ->
    {next_state, dead, State};

%% handle_info({'ripple', Id, Pid, Sign, X, Y}, StateName, State) ->
%%    #ob_act{att=Att} = State,
%%    case Att of
%%        undefined -> %% 新目标
%%            NewAtt = #{id=>Id, pid=>Pid, sign=>Sign, x=>X, y=>Y},
%%            Ref = lib_scene_object:send_event_after(State#ob_act.ref, 100, repeat),
%%            {next_state, trace, State#ob_act{att=NewAtt, ref=Ref}};
%%        %#{id:=Id, sign:=Sign} = AttMaps -> %% 旧目标，更新必要信息
%%        %    AttMaps#{pid:=Pid, x:=X, y:=y};
%%        _ -> %% 其他目标
%%            {next_state, StateName, State}
%%    end;

handle_info({'stop', Broadcast}, _StateName, State) ->
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, Broadcast),
    lib_scene_object_event:be_stop(State#ob_act.object),
    {stop, normal, State};

handle_info(_, thorough_sleep, State) ->
    {next_state, thorough_sleep, State};

%% 被锁定
handle_info({'locked',Id, Pid, Sign, X, Y}, StateName, State) ->
    #ob_act{att=Att, object=#scene_object{x=ObjX, y=ObjY}} = State,
    case Att of
        undefined -> %% 新目标
            NewAtt = #{id=>Id, pid=>Pid, sign=>Sign, x=>X, y=>Y},
            Ref = lib_scene_object:send_event_after(State#ob_act.ref, 0, repeat),
            {next_state, trace, State#ob_act{att=NewAtt, ref=Ref}};
        #{x:=TX, y:=TY} when abs(ObjX-TX)+abs(ObjY-TY) > abs(ObjX-X)+abs(ObjY-Y) ->
            NewAtt = #{id=>Id, pid=>Pid, sign=>Sign, x=>X, y=>Y},
            {next_state, StateName, State#ob_act{att=NewAtt}};
        _ -> %% 已经有其他目标
            {next_state, StateName, State}
    end;

%% 主人移动
handle_info({'follow', X, Y}, StateName, State) ->
    #ob_act{object=Object, ref=Ref} = State,
    #scene_object{id=Id, scene=SceneId, scene_pool_id=ScenePoolId, copy_id = CopyId, x=ObX, y=ObY} = Object,
    RealDisSquare = math:pow(ObX-X, 2) + math:pow(ObY-Y, 2),
    if
        RealDisSquare < ?LEAVE_MIN_SQUARE -> {next_state, StateName, State#ob_act{follow={X, Y}} };
        RealDisSquare > ?LEAVE_MAX_SQUARE ->
            NewObject = Object#scene_object{x=X, y=Y},
            lib_scene_object:change_xy(NewObject),
            {ok, BinData1} = pt_120:write(12006, Id),
            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, ObX, ObY, BinData1),
            {ok, BinData2} = pt_120:write(12013, NewObject),
            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, X, Y, BinData2),
            Ref1 = lib_scene_object:send_event_after(Ref, 100, repeat),
            {next_state, follow, State#ob_act{att=undefined, follow={X, Y}, object=NewObject, ref=Ref1}};
        true ->
            Ref1 = case StateName of
                       idle -> lib_scene_object:send_event_after(Ref, 0, repeat);
                       _ -> Ref
                   end,
            {next_state, StateName, State#ob_act{follow={X, Y}, ref=Ref1}}
    end;

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
    #battle_return_atter{x=Xatt, y=Yatt, real_id=RealId, real_sign=RealSign, att_type=AttType, hide=AtterHide} = Atter,
    #ob_act{att=OldAtt, object = Object, ref=Ref, handle_time=HandleTime, die_handler = DieHandler} = State,
    #scene_object{battle_attr=BA=#battle_attr{hp_lim=Hplim, attr=Attr}, partner=Personality, x=Xnow, y=Ynow, pos=Pos} = Object,

    Hurt = min(FullHurt, Object#scene_object.battle_attr#battle_attr.hp),

    Attr1 = case Hp / Hplim =< 0.3 of
                %% true when Personality == 12 -> Attr#attr{all_resis=round(Attr#attr.all_resis*1.75)};
                true when Personality == 12 -> Attr#attr{att=round(Attr#attr.att*1.45)};
                true when Personality == 15 -> Attr#attr{att=round(Attr#attr.att*1.3)};
                _ -> Attr
            end,

    Object1 = Object#scene_object{
                battle_attr = BA#battle_attr{hp=max(0,Hp), attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList, attr=Attr1},
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
            {next_state, dead, State1#ob_act{ref=Ref1}};
        true ->
            IsEscape = case Personality of
                           10 when AttType == 0 ->
                               Now = utime:unixtime(),
                               HandleTime + 10 < Now;
                           _ -> false
                       end,
            {IsEscapeSucess, StateEscape}
                = case IsEscape of
                      true ->
                          #scene_object{scene=OScene, copy_id=OCopyId, x=OX, y=OY} = Object1,
                          Radian = math:atan2(OY-Yatt, OX-Xatt),
                          EscapeX = max(0, round(OX+math:cos(Radian)*500)),
                          EscapeY = max(0, round(OY+math:sin(Radian)*250)),
                          case lib_scene:is_blocked(OScene, OCopyId, EscapeX, EscapeY) of
                              false ->
                                  RefEscape = lib_scene_object:send_event_after(Ref, 0, {EscapeX, EscapeY}),
                                  {true, State1#ob_act{ref=RefEscape, handle_time=utime:unixtime()}};
                              true ->
                                  {false, State1#ob_act{handle_time=utime:unixtime()}}
                          end;
                      false -> {false, State1}
                  end,

            if
                IsEscapeSucess -> {next_state, escape, StateEscape};
                true ->
                    NewAttTarget
                        = if
                              AtterHide == 1 -> OldAtt;
                              OldAtt == undefined -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>AtterSign};
                              Taunt == {0, 0} ->
                                  case OldAtt of
                                      #{x:=Xtr, y:=Ytr} when Pos == 0 andalso  %% Pos > 0 则表示要按照阵法来，不能随意更改目标
                                                             ((abs(Xtr-Xnow) > 300 andalso abs(Xtr-Xnow) > abs(Xatt-Xnow))
                                                              orelse (abs(Ytr-Ynow) > 150 andalso abs(Ytr-Ynow) > abs(Yatt-Ynow))) ->
                                          #{id=>RealId, x=>Xatt, y=>Yatt, sign=>RealSign};
                                      _ ->
                                          OldAtt
                                  end;
                              true -> #{id=>RealId, x=>Xatt, y=>Yatt, sign=>AtterSign}
                          end,
                    if
                        StateName == sleep orelse StateName == idle ->
                            Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                            {next_state, trace, StateEscape#ob_act{att=NewAttTarget, ref=Ref1}};
                        true ->
                            {next_state, StateName, StateEscape#ob_act{att=NewAttTarget}}
                    end
            end
    end;

%% 设置战斗状态
handle_info({'battle_attr', BA}, StateName, State) ->
    #ob_act{object=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA}}};

%% 设置buff
handle_info({'buff', AttrBuffL, OtherBuffL}, StateName, State) ->
    #ob_act{object=#scene_object{battle_attr=BA}=Object} = State,
    {next_state, StateName, State#ob_act{object=Object#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL, other_buff_list=OtherBuffL}}}};

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


%% 更改属性
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

handle_info({'handle_personlity', Value}, StateName, State) ->
    #ob_act{att=Att, object = #scene_object{partner=Personality, pos=Pos}, handle_time=HandleTime, ref=Ref} = State,
                                                %?PRINT("handle_personlity ~p~n", [{Personality, Value}]),
    NewState = if
                   Personality == 1 orelse Personality == 3 ->
                       {AtterSign, AtterId} = Value,
                       Now = utime:unixtime(),
                       case Now > HandleTime + 10 of
                           true  -> State#ob_act{handle_time=Now, att=#{id=>AtterId, sign=>AtterSign}};
                           false -> State
                       end;
                   Personality == 11 ->
                       {DerSign, DerId} = Value,
                       Now = utime:unixtime(),
                       case Now > HandleTime + 10 of
                           true  -> State#ob_act{handle_time=Now, att=#{id=>DerId, sign=>DerSign}};
                           false -> State
                       end;
                   Att==undefined->
                       {DerSign, DerId} = Value,
                       State#ob_act{att=#{id=>DerId, sign=>DerSign}};
                   true ->
                       State
               end,
    case NewState#ob_act.att of
        #{id:=_, sign:=_} when (StateName == sleep orelse StateName == idle) andalso Pos == 0 ->
            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
            {next_state, trace, NewState#ob_act{ref=Ref1}};
        _ ->
            {next_state, StateName, State}
    end;

handle_info('timer_handle_personlity', StateName, State) ->
    #ob_act{
            object = #scene_object{
                sign=ObjSign, id=ObjId, battle_attr=ObjBA=#battle_attr{combat_power=CombatPower},
                scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y,
                partner=Personality, skill_owner=SkillOwner} = Object,
            handle_ref = HandleRef
           } = State,
    util:cancel_timer(HandleRef),
    %% ?PRINT("handle_personlity ~s, ~p~n", [ulists:list_to_bin(State#ob_act.object#scene_object.figure#figure.name), Personality]),
    {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),
    Args = #scene_calc_args{
        group = ObjBA#battle_attr.group, sign = ObjSign, id = ObjId, owner_sign = OwnerSign, owner_id = OwnerId,
        guild_id = lib_scene_object_ai:get_guild_id(Object),
        pk_status = lib_scene_object_ai:get_pk_status(Object)
        },
    case Personality of
        6 ->
            F = fun(Elem) ->
                case Elem of
                    #ets_scene_user{battle_attr=BA} ->
                        AttrBuffL = lib_skill_buff:add_buff(BA#battle_attr.attr_buff_list, ?ATT, 0, 0, 0, 0, 0, -0.1, 10000, 0, 0, utime:longunixtime()),
                        lib_scene_agent:put_user(Elem#ets_scene_user{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL}}),
                        ok;
                    #scene_object{sign=ESign, battle_attr=BA} when ESign/=?BATTLE_SIGN_MON ->
                        AttrBuffL = lib_skill_buff:add_buff(BA#battle_attr.attr_buff_list, ?ATT, 0, 0, 0, 0, 0, -0.1, 10000, 0, 0, utime:longunixtime()),
                        lib_scene_object_agent:put_object(Elem#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL}}),
                        %% ?PRINT("handle_personlity 666 ~s, ~p~n", [ulists:list_to_bin(Elem#scene_object.figure#figure.name), AttrBuffL]),
                        ok;
                    _ ->
                        ok
                end
            end,
            mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, lib_scene_calc, partner_do_for_area, [CopyId, X, Y, Args, F]);
        9 ->
            F = fun(Elem) ->
                case Elem of
                    #ets_scene_user{battle_attr= #battle_attr{combat_power=ECP} = BA} when ECP < CombatPower ->
                        AttrBuffL = lib_skill_buff:add_buff(BA#battle_attr.attr_buff_list, ?ATT, 0, 0, 0, 0, 0, -0.1, 10000, 0, 0, utime:longunixtime()),
                        lib_scene_agent:put_user(Elem#ets_scene_user{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL}}),
                        ok;
                    #scene_object{sign=ESign, battle_attr= #battle_attr{combat_power=ECP} = BA} when ESign/=?BATTLE_SIGN_MON, ECP < CombatPower ->
                        AttrBuffL = lib_skill_buff:add_buff(BA#battle_attr.attr_buff_list, ?ATT, 0, 0, 0, 0, 0, -0.1, 10000, 0, 0, utime:longunixtime()),
                        lib_scene_object_agent:put_object(Elem#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffL}}),
                        %?PRINT("handle_personlity 999 ~s, ~p~n", [ulists:list_to_bin(Elem#scene_object.figure#figure.name), AttrBuffL]),
                        ok;
                    _ ->
                        ok
                end
            end,
            mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, lib_scene_calc, partner_do_for_area, [CopyId, X, Y, Args, F]);
        _ -> skip
    end,
    Ref1 = erlang:send_after(10000, self(), 'timer_handle_personlity'),
    {next_state, StateName, State#ob_act{handle_ref=Ref1}};

%% 寻找新目标
handle_info('find_target', _StateName, State) ->
    Ref1 = lib_scene_object:send_event_after(State#ob_act.ref, 0, repeat),
    {next_state, find_target, State#ob_act{ref=Ref1}};

%% 设置所属方的
handle_info('set_scene_partner', StateName, State) ->
    #ob_act{object=Object} = State,
    #scene_object{scene=Scene, scene_pool_id=ScenePoolId, id=Id, skill_owner=SkillOwner, partner=Personality} = Object,
    case SkillOwner of
        #skill_owner{sign=?BATTLE_SIGN_PLAYER, id=OwnerId} ->
            mod_scene_agent:update(Scene, ScenePoolId, OwnerId, [{add_partner, {Id, self(), Personality}}]);
        #skill_owner{sign=?BATTLE_SIGN_DUMMY, id=OwnerId} ->
            lib_scene_object:change_attr_by_ids(Scene, ScenePoolId, [OwnerId], [{add_partner, {Id, self(), Personality}}]);
        _ ->
            skip
    end,
    {next_state, StateName, State};

handle_info('sleep', _StateName, State) ->
    {next_state, sleep, State};


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

sleep(_, State) ->
    {next_state, sleep, State}.

%% 彻底休眠状态，只接受死亡信息
thorough_sleep(_R, State) ->
    {next_state, thorough_sleep, State}.

idle(_R, #ob_act{ref=Ref} = State) ->
    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
    {next_state, follow, State#ob_act{ref=Ref1}}.

%% 跟随主人状态
follow(_R, #ob_act{follow={TargetX, TargetY}, object=Object, ref=Ref} = State) ->
    #scene_object{scene=SceneId, copy_id=CopyId, x=ObX, y=ObY, battle_attr=BA} = Object,
    case lib_scene_object_ai:get_next_step(ObX, ObY, 150, SceneId, CopyId, TargetX, TargetY, false) of
        attack ->
            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
            {next_state, find_target, State#ob_act{ref=Ref1}};
        {NextX, NextY} ->
            #battle_attr{speed=Speed} = BA,
            case lib_scene_object_ai:move(NextX, NextY, Object, Speed, false) of
                block ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 3000, repeat),
                    {next_state, follow, State#ob_act{ref=Ref1}};
                {true, NewObject, Time} ->
                    Ref1 = lib_scene_object:send_event_after(Ref, Time, repeat),
                    {next_state, follow, State#ob_act{object=NewObject, ref=Ref1}}
            end
    end;
follow(_, State) ->
    {next_state, idle, State}.

%% 逃离
escape({EscX, EscY}, #ob_act{object=Object, ref=Ref} = State) ->
    #scene_object{scene=SceneId, copy_id=CopyId, x=ObX, y=ObY, battle_attr=BA} = Object,
    case lib_scene_object_ai:get_next_step(ObX, ObY, 150, SceneId, CopyId, EscX, EscY, false) of
        attack ->
            Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
            {next_state, trace, State#ob_act{ref=Ref1}};
        {NextX, NextY} ->
            #battle_attr{speed=Speed} = BA,
            case lib_scene_object_ai:move(NextX, NextY, Object, Speed, false) of
                block ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 3000, repeat),
                    {next_state, trace, State#ob_act{ref=Ref1}};
                {true, NewObject, Time} ->
                    Ref1 = lib_scene_object:send_event_after(Ref, Time, {EscX, EscY}),
                    {next_state, escape, State#ob_act{object=NewObject, ref=Ref1}}
            end
    end.

%% 死亡
dead(_R, State) ->
    util:cancel_timer(State#ob_act.ref),
    lib_scene_object:stop(State#ob_act.object, 1),
    {stop, normal, State}.

%% 追踪
trace(_R, State) ->
    #ob_act{att=Att, object=Object, skill_link_info=SkillLinkInfo, next_att_time=NextAttTime, ref=Ref, check_block = CheckBlock, release_skill = ReleaseSkill} = State,
    #scene_object{scene=SceneId, scene_pool_id=ScenePoolId} = Object,
    case Att of
        undefined -> %% 没有目标，继续跟踪
            Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
            {next_state, follow, State#ob_act{ref=Ref1}};
        #{id:=Id, sign:=Sign}-> %% 有目标
            case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_trace_info, [Sign, Id]) of
                {_Hp, X, Y} ->
                    NowTime = utime:longunixtime(),
                    {Next, Args}  = lib_scene_object_ai:trace_to_att(Object, X, Y, {target, Sign, Id}, Ref, NextAttTime, 0, NowTime, SkillLinkInfo, CheckBlock, ReleaseSkill),
                    AfBattleState = lib_scene_object_ai:set_ac_state(Args, State#ob_act{att=Att#{x=>X, y=>Y}}),
                    %% case Next /= trace of
                    %%    true ->
                    %%        ?PRINT("================== next ~s, ~p~n", [ulists:list_to_bin(Object#scene_object.figure#figure.name),
                    %%                {Next, Object#scene_object.sign, Object#scene_object.id, Object#scene_object.battle_attr#battle_attr.attr#attr.speed}]);
                    %%    _ -> skip
                    %% end,
                    case Next of
                        trace -> {next_state, trace, AfBattleState};
                        back  -> {next_state, find_target, AfBattleState};
                        error -> {next_state, idle, AfBattleState};
                        _     -> {next_state, follow, AfBattleState}
                    end;
                _ ->
                    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                    {next_state, find_target, State#ob_act{att=undefined, ref=Ref1}}
            end
    end.

%% 查找target
find_target(_, State) ->
    #ob_act{att=Att, object=Object, handle_time=HandleTime, ref=Ref} = State,
    #scene_object{
        id=ObjectId, sign=ObjectSign, type=Type, x=ObjectX, y=ObjectY, scene=SceneId, scene_pool_id=ScenePoolId, copy_id=CopyId,
        battle_attr=BA, skill_owner=SkillOwner, partner=Personality, pos=Pos} = Object,

    case Att of
        undefined ->
            IsPersonlity = HandleTime + 10 > utime:unixtime(),
            {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),
            Args = #scene_calc_args{
                group = BA#battle_attr.group, sign = ObjectSign, id = ObjectId, owner_sign = OwnerSign, owner_id = OwnerId,
                guild_id = lib_scene_object_ai:get_guild_id(Object),
                pk_status = lib_scene_object_ai:get_pk_status(Object)
                },
            % Args = {BA#battle_attr.group, ObjectSign, ObjectId, OwnerSign, OwnerId},
            % Args = #scene_calc_args{group = BA#battle_attr.group, sign = ObjectSign, id = ObjectId, owner_sign = OwnerSign, owner_id = OwnerId},
            case mod_scene_agent:apply_call_with_state(SceneId, ScenePoolId, lib_scene_calc, partner_find_target,
                    [CopyId, ObjectX, ObjectY, 10000, Args, Personality, Pos, IsPersonlity]) of
                {TgSign, TgId, TgPid, TgX, TgY} ->
                    %% ?PRINT("partner target ~s, myid=~w, mypos=~w, tid=~w ~n", [ulists:list_to_bin(Object#scene_object.figure#figure.name), ObjectId, Pos, TgId]),
                    Ref1 = lib_scene_object:send_event_after(Ref, 0, repeat),
                    {next_state, trace, State#ob_act{att=#{id=>TgId, sign=>TgSign, pid=>TgPid, x=>TgX, y=>TgY}, ref=Ref1}};
                _O ->
                    %% ?PRINT("partner no target ~s, ~w ~n", [ulists:list_to_bin(Object#scene_object.figure#figure.name), _O]),
                    case Type of
                        0 ->
                            Ref1 = lib_scene_object:send_event_after(Ref, 2000, repeat),
                            {next_state, follow, State#ob_act{ref=Ref1}};
                        1 ->
                            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
                            {next_state, find_target, State#ob_act{att=undefined, ref=Ref1}}
                    end
            end;
        _ -> %% 被handle_info设置了攻击目标
            Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
            {next_state, trace, State#ob_act{ref=Ref1}}
    end.
