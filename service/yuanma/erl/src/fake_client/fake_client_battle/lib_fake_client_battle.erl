%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_battle.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 战斗挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_battle).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("guild.hrl").
-include("battle.hrl").
-include("drop.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("fake_client.hrl").

-compile(export_all).

-define(battle_msg(Method, Args), {'mod', ?MODULE, Method, Args}).
-define(get_skill_cd(AttSkillData),
		case AttSkillData of 
			undefined -> []; _ -> AttSkillData#att_skill_data.skill_cd
		end).
-define(get_last_skill_id(AttSkillData),
		case AttSkillData of 
			undefined -> 0; _ -> AttSkillData#att_skill_data.last_skill_id
		end).
-define(get_skill_link(AttSkillData),
		case AttSkillData of 
			undefined -> []; _ -> AttSkillData#att_skill_data.skill_link
		end).
-define(key_to_sign(Key),
		case Key == user orelse Key == module_user of 
			true -> ?BATTLE_SIGN_PLAYER; _ -> ?BATTLE_SIGN_MON
		end).

-define(is_clt_mon(MonId), 
		case data_mon:get(MonId) of 
			#mon{kind = K} ->
				lists:member(K, [?MON_KIND_COLLECT, ?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT, ?MON_KIND_COUNT_COLLECT]);
			_ -> false
		end).

try_start_timer(FakeClient, Timeout, Pid, Msg) ->
	#fake_client{behaviour = BehaviourName, behaviour_ref = OldRef} = FakeClient,
	if
		BehaviourName == ?BEHAVIOUR_IN_REVIVE -> OldRef;
		BehaviourName == ?BEHAVIOUR_WAIT -> OldRef;
		true ->
			util:send_after(OldRef, Timeout, Pid, Msg)
	end.

%% 每次加载场景后执行
start_battle(PS) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	{BehaviourName, Timeout} = lib_fake_client_api:get_init_behaviour(PS),
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	Ref = util:send_after(OldRef, Timeout, Pid, ?battle_msg(behaviour, [start_battle])),
	%?PRINT("start_battle start_battle ##### ~n", []),
	PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref, att_target = false}}.

%% 关闭
close_fake_client(PS, _Msg) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{behaviour = OldBehaviour, behaviour_ref = OldRef, att_target = AttTarget} = FakeClient,
	util:cancel_timer(OldRef),
	if
	 	OldBehaviour == ?BEHAVIOUR_IN_COLLECT andalso is_record(AttTarget, att_target) -> %% 取消采集
			#att_target{id = Id, mon_id = MonId} = AttTarget,
			pp_battle:handle(20008, PS, [Id, MonId, ?COLLECT_CANCEL]);
		true -> ok
	end,
	PS#player_status{fake_client = FakeClient#fake_client{
		behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = undefined, 
		att_target = false, scene_object_data = #{}, drop_goods_data = #{}}
		}.

%% 复活消息
behaviour(PS, {revive, ReviveType}) ->
	go_revive(PS, ReviveType);
%% 开始战斗
behaviour(PS, start_battle) ->
	#player_status{fake_client = FakeClient} = PS,
	NewFakeClient = ?IF(FakeClient#fake_client.behaviour == ?BEHAVIOUR_WAIT, FakeClient#fake_client{behaviour=?BEHAVIOUR_IDEL}, FakeClient),
	NewPS = PS#player_status{fake_client = NewFakeClient},
	behaviour(NewPS, trace);
behaviour(PS, Msg) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	NeedFind = need_find_target(PS, FakeClient),
	NewAttTarget = find_target(NeedFind, FakeClient, PS),
	IsStartClient = FakeClient#fake_client.start_client > 0,
	%?PRINT("behaviour NewAttTarget: ~p~n", [{IsStartClient, FakeClient#fake_client.att_target, NewAttTarget}]),
	if
		IsStartClient ->
			case NewAttTarget of 
				#att_target{key = drop, id = Id} when Id > 0 -> %% 拾取逻辑
					NPS = PS#player_status{fake_client = FakeClient#fake_client{att_target = NewAttTarget}},
					go_pick(NPS, NewAttTarget, Msg);
				#att_target{id = Id, mon_id = MonId} when Id > 0 orelse MonId > 0 ->
					NPS = PS#player_status{fake_client = FakeClient#fake_client{att_target = NewAttTarget}},
					case ?is_clt_mon(MonId) of 
						false ->
							go_battle(NPS, NewAttTarget);
						_ ->
							go_collect(NPS, NewAttTarget, Msg)
					end;
				#att_target{id = 0, mon_id = 0, x = X, y = Y} when X > 0 andalso Y > 0 -> %% 这时没有目标，走到目标坐标
					NPS = PS#player_status{fake_client = FakeClient#fake_client{att_target = NewAttTarget}},
					go_move(NPS, NewAttTarget);
				_ ->
					try_go_to_obhook(PS),
					Ref = try_start_timer(FakeClient, 5000, Pid, ?battle_msg(behaviour, [trace])),
					PS#player_status{fake_client = FakeClient#fake_client{behaviour_ref = Ref}}
			end;
		true ->
			%?PRINT("behaviour close client ~n", []),
			PS
	end.
	

%% 移动到目标坐标(如果移动过程中有怪物进入视野，会重新选择目标)
go_move(PS, AttTarget) ->
	#player_status{
		id = RoleId, pid = Pid, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, fake_client = FakeClient,
		battle_attr = BA
	} = PS,
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	#att_target{ x = TX, y = TY} = AttTarget,
	NowTime = utime:longunixtime(),
	case lib_scene_object_ai:get_next_step(X, Y, 200, SceneId, CopyId, TX, TY, true) of
        attack -> %% 移到目标位置，1s后重新选择目标
            Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
            NewFakeClient = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false},
            PS#player_status{fake_client = NewFakeClient};
        {Xnext, Ynext} ->
            #battle_attr{speed=Speed} = BA,
            BehaviourName = ?BEHAVIOUR_MOVE,
            IsCanMove = lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime),
            case IsCanMove of
                {false, MoveWaitMs} ->
                    Ref = util:send_after(OldRef, MoveWaitMs, Pid, ?battle_msg(behaviour, [trace])),
                    PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
                false ->
                    Ref = util:send_after(OldRef, ?DEFAULT_IDLE_TIME, Pid, ?battle_msg(behaviour, [trace])),
                    PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
                true ->
                	case fix_loop_block(FakeClient, SceneId, CopyId, Xnext, Ynext) of 
                		{false, NewX, NewY, FakeClient1} ->
                			NewFakeClient = FakeClient1;
                		{true, NewX, NewY, FakeClient1} ->
                			NewFakeClient = FakeClient1#fake_client{att_target = false}
                	end,
                    mod_scene_agent:cast_to_scene(SceneId, PoolId, {'move', [CopyId, NewX, NewY, 0, X, Y, NewX, NewY, 0, 0, RoleId]}),
                    SleepTime = util:ceil(umath:distance({X,Y},{NewX,NewY})*1000/max(Speed, 1)),
                    Ref = util:send_after(OldRef, SleepTime+100, Pid, ?battle_msg(behaviour, [trace])),
                    PS#player_status{x = NewX, y = NewY, fake_client = NewFakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}}
            end
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 攻击
go_battle(PS, AttTarget) ->
	#player_status{
		id = RoleId, pid = Pid, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, fake_client = FakeClient,
		battle_attr = BA
	} = PS,
	#fake_client{behaviour_ref = OldRef, att_skill_data = AttSkillData} = FakeClient,
	#att_target{key = Key, id = TId, x = TX, y = TY} = AttTarget,
	NowTime = utime:longunixtime(),
	SkillCd = ?get_skill_cd(AttSkillData),
	LastSkillId = ?get_last_skill_id(AttSkillData),
	SkillLink = ?get_skill_link(AttSkillData),
	case lib_fake_client_api:select_a_skill(PS) of 
		false ->
			Quickbar = lib_skill:make_scene_quickbar(PS),
    		Res = lib_scene_object_ai:select_a_skill(Quickbar, SkillCd, [], [], LastSkillId, 0, SkillLink, NowTime);
    	{SkillId1, SkillLv1} -> 
    		case data_skill:get(SkillId1, SkillLv1) of 
    			#skill{type = SkillType, lv_data = #skill_lv{area = Area}} ->
    				Res = {SkillId1, SkillLv1, Area, SkillType, false, 100, [], 0};
    			_ ->
    				Res = false
    		end
    end,
    %?PRINT("go_battle TId: ~p ~n", [TId]),
    case Res of 
    	{false, NextSelectTime} ->
    		Ref = util:send_after(OldRef, NextSelectTime+1200, Pid, ?battle_msg(behaviour, [trace])),
    		PS#player_status{fake_client = FakeClient#fake_client{behaviour_ref = Ref}};
    	{SkillId, SkillLv, _, ?SKILL_TYPE_ASSIST, IsReFindT, SpellTime, _, _} ->
    		%?PRINT("go_battle assist: ~p ~n", [{SkillId, SkillLv}]),
		    #skill{is_combo = IsCombo} = data_skill:get(SkillId, SkillLv),
		    CallBackArgs = lib_skill:make_skill_use_call_back(PS, SkillId, SkillLv),
		    Ref = util:send_after(OldRef, SpellTime+700, Pid, ?battle_msg(behaviour, [trace])),
		    %% cast到场景出释放技能
		    %% 默认给自己施放
		    mod_scene_agent:apply_cast_with_state(SceneId, PoolId, ?MODULE, assist_skill, [RoleId, X, Y, IsCombo, IsReFindT, SkillId, SkillLv, CallBackArgs]),
		    PS#player_status{fake_client = FakeClient#fake_client{behaviour = ?BEHAVIOUR_BATTLE, behaviour_ref = Ref}};
    	{SkillId, SkillLv, SkillDistance, ?SKILL_TYPE_ACTIVE, IsReFindT, SpellTime, SkillLinkInfo, IsNormal} ->
            TSign = ?key_to_sign(Key),
            case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, true) of
                attack ->
                    case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                        {false, _K, AttWaitMs} ->
                        	BehaviourName = ?BEHAVIOUR_BATTLE,
                            Ref = util:send_after(OldRef, AttWaitMs+700, Pid, ?battle_msg(behaviour, [trace])),
                            NewFakeClient = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref},
                            PS#player_status{fake_client = NewFakeClient};
                        true ->
                        	%?PRINT("go_battle battle: ~p ~n", [{TId, AttTarget#att_target.mon_id, TX, TY}]),
                        	%?MYLOG("lxl_activity", "go_battle battle: ~p~n", [{TId, AttTarget#att_target.mon_id}]),
                            %% 发起攻击
                            BehaviourName = ?BEHAVIOUR_BATTLE,
                            %% cast到场景出释放技能
		    				mod_scene_agent:apply_cast_with_state(SceneId, PoolId, ?MODULE, object_start_battle, [RoleId, TSign, TId, IsReFindT, SkillId, SkillLv, IsNormal]),
                            NSpellTime = SpellTime+200,
                            Ref = util:send_after(OldRef, NSpellTime, Pid, ?battle_msg(behaviour, [trace])),
                            #skill{lv_data = #skill_lv{cd = Cd}} = data_skill:get(SkillId, SkillLv),
                            NewAttSkillData = set_att_skill_data(AttSkillData, [{last_skill_id, SkillId}, {skill_link, SkillLinkInfo}, {skill_cd, SkillId, NowTime + Cd}]),
                            NewFakeClient = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref, att_skill_data = NewAttSkillData},
                            PS1 = PS#player_status{fake_client = NewFakeClient},
                            PS2 = lib_fake_client_api:use_skill_succ(PS1, SkillId),
                            PS2
                    end; 
                {Xnext, Ynext} ->
                    #battle_attr{speed=Speed} = BA,
                    BehaviourName = ?BEHAVIOUR_MOVE,
                    IsCanMove = lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime),
                    case IsCanMove of
                        {false, MoveWaitMs} ->
                            Ref = util:send_after(OldRef, MoveWaitMs, Pid, ?battle_msg(behaviour, [trace])),
                            PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
                        false ->
                            Ref = util:send_after(OldRef, ?DEFAULT_IDLE_TIME, Pid, ?battle_msg(behaviour, [trace])),
                            PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
                        true ->
                        	case fix_loop_block(FakeClient, SceneId, CopyId, Xnext, Ynext) of 
                        		{false, NewX, NewY, FakeClient1} ->
                        			NewFakeClient = FakeClient1;
                        		{true, NewX, NewY, FakeClient1} ->
                        			%?PRINT("fix_loop_block {NewX, NewY}: ~p ~n", [{NewX, NewY}]),
                        			%?MYLOG("lxl_activity", "fix_loop_block {NewX, NewY}: ~p~n", [{NewX, NewY}]),
                        			NewFakeClient = FakeClient1#fake_client{att_target = false}
                        	end,
                            mod_scene_agent:cast_to_scene(SceneId, PoolId, {'move', [CopyId, NewX, NewY, 0, X, Y, NewX, NewY, 0, 0, RoleId]}),
                            SleepTime = util:ceil(umath:distance({X,Y},{NewX,NewY})*1000/max(Speed, 1)),
                            Ref = util:send_after(OldRef, SleepTime+100, Pid, ?battle_msg(behaviour, [trace])),
                            %?PRINT("move {NewX, NewY}: ~p ~n", [{{X, Y}, {NewX, NewY}, AttTarget}]),
                            PS#player_status{x = NewX, y = NewY, fake_client = NewFakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}}
                    end 
            end;
    	_ ->
    		Ref = try_start_timer(FakeClient, 5000, Pid, ?battle_msg(behaviour, [trace])),
			PS#player_status{fake_client = FakeClient#fake_client{behaviour_ref = Ref}}
    end.

break_battle(PS) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour = BehaviourName, behaviour_ref = OldRef, att_target = AttTarget} = FakeClient,
	case AttTarget of 
		#att_target{key = Key, mon_id = MonId} ->
			case can_interrupt_target(BehaviourName, Key, MonId) of 
				true ->
					Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
                    PS#player_status{fake_client = FakeClient#fake_client{behaviour_ref = Ref, att_target = false}};
				_ ->
					PS
			end;
		_ ->
			PS
	end.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 采集
go_collect(PS, AttTarget, fin_collect) ->
	#player_status{
		pid = Pid, fake_client = FakeClient
	} = PS,
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	#att_target{id = TId, mon_id = MonId} = AttTarget,
	BehaviourName = ?BEHAVIOUR_IDEL,
	Ref = util:send_after(OldRef, 2000, Pid, ?battle_msg(behaviour, [trace])),
	%?MYLOG("lxl_battle", "go_collect fin_collect: ~p~n", [{TId, MonId}]),
	%?PRINT("go_collect fin_collect: ~p~n", [{TId, MonId}]),
	pp_battle:handle(20008, PS, [TId, MonId, ?COLLECT_FINISH]),
	PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
go_collect(PS, AttTarget, _) ->
	#player_status{
		id = RoleId, pid = Pid, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, fake_client = FakeClient,
		battle_attr = BA
	} = PS,
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	#att_target{id = TId, x = TX, y = TY, mon_id = MonId} = AttTarget,
	#mon{collect_time = CltTime} = data_mon:get(MonId),
	CollectDis = 2 * ?LENGTH_UNIT,
	NowTime = utime:longunixtime(),
	case lib_scene_object_ai:get_next_step(X, Y, CollectDis, SceneId, CopyId, TX, TY, true) of
		attack ->
			%?MYLOG("lxl_battle", "go_collect: ~p~n", [{TId, MonId, TX, TY, X, Y}]),
			%?PRINT("go_collect: ~p~n", [{TId, MonId, TX, TY}]),
			BehaviourName = ?BEHAVIOUR_IN_COLLECT,
			Ref = util:send_after(OldRef, max(1000, CltTime*1000), Pid, ?battle_msg(behaviour, [fin_collect])),
			pp_battle:handle(20008, PS, [TId, MonId, ?COLLECT_STATR]),
			PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
		{Xnext, Ynext} ->
            #battle_attr{speed=Speed} = BA,
            BehaviourName = ?BEHAVIOUR_MOVE_COLLECT,
            IsCanMove = lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime),
            case IsCanMove of
                {false, MoveWaitMs} ->
                    Ref = util:send_after(OldRef, MoveWaitMs+500, Pid, ?battle_msg(behaviour, [trace]));
                false ->
                    Ref = util:send_after(OldRef, ?DEFAULT_IDLE_TIME, Pid, ?battle_msg(behaviour, [trace]));
                true ->
                    mod_scene_agent:cast_to_scene(SceneId, PoolId, {'move', [CopyId, Xnext, Ynext, 0, X, Y, Xnext, Ynext, 0, 0, RoleId]}),
                    SleepTime = util:ceil(umath:distance({X,Y},{Xnext,Ynext})*1000/max(Speed, 1)),
                    Ref = util:send_after(OldRef, SleepTime+200, Pid, ?battle_msg(behaviour, [trace]))
            end,
            {NewX, NewY} = ?IF(IsCanMove == true, {Xnext, Ynext}, {X, Y}),
            PS#player_status{x = NewX, y = NewY, fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}}
	end.

collect_mon_result(PS, Code) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{behaviour = BehaviourName, att_target = AttTarget} = FakeClient,
	case AttTarget of 
		#att_target{mon_id = MonId} ->
			BehaviourInCollect = behaviour_in_collect(BehaviourName, MonId);
		_ -> BehaviourInCollect = false
	end,
	if
		BehaviourInCollect == false -> %% 当前不是采集状态，不做处理
			PS;	
		Code == 1  -> %% 开始采集成功, 不做处理
			PS;
		Code == 2 -> %% 采集成功, 如果状态还是采集，取消采集, 重新找目标
			cancel_collect(PS, 1);
		%% 采集失败，重新寻找目标
		Code == 3 orelse Code == 4 orelse Code == 5 orelse Code == 14 ->
			cancel_collect(PS, 1);
		%% 采集失败，重新寻找目标(要排除旧目标)
		Code == 6 orelse Code == 8 orelse Code == 13 orelse Code == 18 orelse Code == 19 orelse Code == 20 orelse Code == 25 ->
			cancel_collect(PS, 2);
		true -> %% 没有采集次数，停止采集相同的采集怪
			cancel_collect(PS, 3)
	end.

interrupt_collect(PS) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{behaviour = BehaviourName, att_target = AttTarget} = FakeClient,
	case AttTarget of 
		#att_target{mon_id = MonId} ->
			BehaviourInCollect = behaviour_in_collect(BehaviourName, MonId);
		_ -> BehaviourInCollect = false
	end,
	if
		BehaviourInCollect == false -> %% 当前不是采集状态，不做处理
			PS;	
		true -> %% 被中断，重新寻找
			cancel_collect(PS, 1)
	end.

cancel_collect(PS, 1) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	PS#player_status{fake_client = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false}};
cancel_collect(PS, 2) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef, forbid_clt_mon = ForbidCltMon, att_target = AttTarget} = FakeClient,
	#att_target{id = TId} = AttTarget,
	NewForbidCltMon = update_forbid_clt_list(ForbidCltMon, id, TId),
	Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	NewFakeClient = FakeClient#fake_client{
		behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false, forbid_clt_mon = NewForbidCltMon
	},
	PS#player_status{fake_client = NewFakeClient};
cancel_collect(PS, 3) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef, forbid_clt_mon = ForbidCltMon, att_target = AttTarget} = FakeClient,
	#att_target{mon_id = MId} = AttTarget,
	NewForbidCltMon = update_forbid_clt_list(ForbidCltMon, mid, MId),
	Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	NewFakeClient = FakeClient#fake_client{
		behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false, forbid_clt_mon = NewForbidCltMon
	},
	PS#player_status{fake_client = NewFakeClient};
cancel_collect(PS, _) ->
	PS.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 拾取逻辑
go_pick(PS, AttTarget, {end_pick, OldTId}) ->
	#att_target{id = TId} = AttTarget,
	%?MYLOG("lxl_pick", "go_pick end_pick: ~p~n", [{OldTId, TId}]),
	case TId =/= OldTId of 
		true -> go_pick(PS, AttTarget, trace);
		_ -> %% 拾取结果协议没返回，停止拾取，重新选择目标
			#player_status{
				pid = Pid, fake_client = FakeClient
			} = PS,
			#fake_client{behaviour_ref = OldRef} = FakeClient,
			BehaviourName = ?BEHAVIOUR_IDEL,
			Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
			PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref, att_target = false}}
	end;
go_pick(PS, AttTarget, _) ->
	#player_status{
		id = RoleId, pid = Pid, scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, fake_client = FakeClient,
		battle_attr = BA
	} = PS,
	#fake_client{behaviour_ref = OldRef, drop_goods_data = DropGoodsData} = FakeClient,
	#att_target{id = TId, x = TX, y = TY} = AttTarget,
	#ets_drop{pick_time = PickTime} = maps:get(TId, DropGoodsData, #ets_drop{}),
	CollectDis = ?LENGTH_UNIT,
	NowTime = utime:longunixtime(),
	case lib_scene_object_ai:get_next_step(X, Y, CollectDis, SceneId, CopyId, TX, TY, true) of
		attack -> 
			%?MYLOG("lxl_activity", "go_pick start: ~p~n", [TId]),
			%% 2s后检查有没有拾取成功
			%% 正常情况拾取返回成功或失败后，会在协议中处理拾取结果，这里开定时检查，防止拾取没有返回结果的情况
			BehaviourName = ?BEHAVIOUR_IN_PICK,
			Ref = util:send_after(OldRef, PickTime + 2000, Pid, ?battle_msg(behaviour, [{end_pick, TId}])),
			pp_goods:handle(15053, PS, [TId]),
			PS#player_status{fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}};
		{Xnext, Ynext} ->
            #battle_attr{speed=Speed} = BA,
            BehaviourName = ?BEHAVIOUR_MOVE_COLLECT,
            IsCanMove = lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime),
            case IsCanMove of
                {false, MoveWaitMs} ->
                    Ref = util:send_after(OldRef, MoveWaitMs+500, Pid, ?battle_msg(behaviour, [trace]));
                false ->
                    Ref = util:send_after(OldRef, ?DEFAULT_IDLE_TIME, Pid, ?battle_msg(behaviour, [trace]));
                true ->
                    mod_scene_agent:cast_to_scene(SceneId, PoolId, {'move', [CopyId, Xnext, Ynext, 0, X, Y, Xnext, Ynext, 0, 0, RoleId]}),
                    SleepTime = util:ceil(umath:distance({X,Y},{Xnext,Ynext})*1000/max(Speed, 1)),
                    Ref = util:send_after(OldRef, SleepTime+100, Pid, ?battle_msg(behaviour, [trace]))
            end,
            {NewX, NewY} = ?IF(IsCanMove == true, {Xnext, Ynext}, {X, Y}),
            PS#player_status{x = NewX, y = NewY, fake_client = FakeClient#fake_client{behaviour = BehaviourName, behaviour_ref = Ref}}
	end.
%% 拾取结果返回
pick_result(PS, Code, _Args, Status, DropId) ->
	%?MYLOG("lxl_pick", "pick_result Code: ~p~n", [Code]),
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{behaviour = BehaviourName, att_target = AttTarget} = FakeClient,
	case AttTarget of 
		#att_target{key = Key, id = TId} ->
			BehaviourInPick = behaviour_in_pick(BehaviourName, Key);
		_ -> BehaviourInPick = false, TId = 0
	end,
	IsPickSucc = lists:member(Code, [?SUCCESS, ?ERRCODE(err150_start_pick_drop)]),
	if
		BehaviourInPick == false -> %% 当前不是拾取状态，不做处理
			PS;	
		TId =/= DropId -> %%不是同一个拾取包，不做处理
			PS;
		IsPickSucc  -> %% 拾取成功
			pick_succ(PS, Code, Status);
		true -> %% 拾取失败
			pick_fail(PS)
	end.

pick_succ(PS, Code, _Status) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef, att_target = AttTarget, drop_goods_data = DropGoodsData} = FakeClient,
	if
	 	Code == 1 -> %% 拾取完成，结束拾取, 不开定时器, 马上执行下一个拾取，提高拾取效率
	 		%Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	 		util:cancel_timer(OldRef),
			NewFakeClient = FakeClient#fake_client{
				behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = undefined, att_target = false
			},
			PS1 = PS#player_status{fake_client = NewFakeClient},
			behaviour(PS1, trace);
	 	true -> %% PickTime之后再发一次拾取协议
	 		#att_target{id = TId} = AttTarget,
	 		case maps:get(TId, DropGoodsData, 0) of 
	 			0 -> pick_fail(PS);
	 			#ets_drop{pick_time = PickTime} ->
	 				%?MYLOG("lxl_pick", "pick_succ PickTime: ~p ~n", [PickTime]),
	 				Ref = util:send_after(OldRef, PickTime, Pid, ?battle_msg(behaviour, [trace])),
					NewFakeClient = FakeClient#fake_client{behaviour_ref = Ref},
					PS#player_status{fake_client = NewFakeClient}
	 		end
	end.

pick_fail(PS) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef, att_target = AttTarget, forbid_pick = ForbidPick} = FakeClient,
	#att_target{id = TId} = AttTarget,
	NewForbidPick = update_forbid_pick_list(ForbidPick, id, TId),
	Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	NewFakeClient = FakeClient#fake_client{
		behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false, forbid_pick = NewForbidPick
	},
	PS#player_status{fake_client = NewFakeClient}.
	
update_forbid_clt_list(ForbidCltMon, Key, Id) ->
	{_, O} = ulists:keyfind(Key, 1, ForbidCltMon, {Key, []}),
	lists:keystore(Key, 1, ForbidCltMon, {Key, [Id|O]}).

update_forbid_pick_list(ForbidPick, Key, Id) ->
	{_, O} = ulists:keyfind(Key, 1, ForbidPick, {Key, []}),
	lists:keystore(Key, 1, ForbidPick, {Key, [Id|O]}).

to_filter_clt_fun([]) -> undefined;
to_filter_clt_fun(ForbidCltMon) ->
	{_, IdList} = ulists:keyfind(id, 1, ForbidCltMon, {id, false}),
	{_, MIdList} = ulists:keyfind(mid, 1, ForbidCltMon, {mid, false}),
	if
		IdList =/= false andalso MIdList =/= false ->
			Filter = fun(#scene_object{id = Id, config_id = MId}) -> lists:member(Id, IdList) orelse lists:member(MId, MIdList) end;
		IdList =/= false ->
			Filter = fun(#scene_object{id = Id}) -> lists:member(Id, IdList) end;
		MIdList =/= false ->
			Filter = fun(#scene_object{config_id = MId}) -> lists:member(MId, MIdList) end;
		true -> Filter = undefined
	end,
	Filter.

to_filter_pick_fun([]) -> undefined;
to_filter_pick_fun(ForbidPick) ->
	{_, IdList} = ulists:keyfind(id, 1, ForbidPick, {id, false}),
	if
		IdList =/= false  ->
			Filter = fun(#ets_drop{id = Id}) -> lists:member(Id, IdList) end;
		true -> Filter = undefined
	end,
	Filter.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 目标寻找
find_target(false, FakeClient, _) -> 
	FakeClient#fake_client.att_target;
find_target(true, FakeClient, PS) ->
	#fake_client{behaviour = _BehaviourName, scene_object_data = SceneObjectData, drop_goods_data = DropGoodsData} = FakeClient,
	OrderList = lib_fake_client_api:get_att_target_find_order(PS),	
	%% 现在SceneObjectData里找，找不到再从模块数据找
	ObjectMap = maps:get(object, SceneObjectData, #{}),
	UserMap = maps:get(user, SceneObjectData, #{}),
	find_target_helper(OrderList, PS, {ObjectMap, UserMap, DropGoodsData}).
			

find_target_helper([], _, _) -> false;
find_target_helper([clt_mon|OrderList], PS, {ObjectMap, _, _}=InArgs) ->
	#fake_client{forbid_clt_mon = ForbidCltMon} = PS#player_status.fake_client,
	ObjectList = maps:values(ObjectMap),
	{CltMonList, _} = filter_clt_mon(ObjectList),
	Filter = to_filter_clt_fun(ForbidCltMon),
	case find_clt_object(PS, CltMonList, Filter) of 
		false -> 
			find_target_helper(OrderList, PS, InArgs);
		NewAttTarget -> NewAttTarget
	end;
find_target_helper([drop|OrderList], PS, {_, _, DropGoodsMap}=InArgs) ->
	#fake_client{forbid_pick = ForbidPick} = PS#player_status.fake_client,
	Filter = to_filter_pick_fun(ForbidPick),
	DropGoodsList = maps:values(DropGoodsMap),
	case find_drop_pick(PS, DropGoodsList, Filter) of 
		false -> 
			find_target_helper(OrderList, PS, InArgs);
		NewAttTarget -> NewAttTarget
	end;
find_target_helper([object|OrderList], PS, {ObjectMap, _, _}=InArgs) ->
	#player_status{id = RoleId, scene = _Scene, battle_attr = BA, guild = #status_guild{id = GuildId}} = PS,
	ObjectList = maps:values(ObjectMap),
	{_, MonList} = filter_clt_mon(ObjectList),
	Args = #scene_calc_args{
	    id = RoleId, sign = ?BATTLE_SIGN_PLAYER, group = BA#battle_attr.group,
	    guild_id = GuildId, pk_status = BA#battle_attr.pk#pk.pk_status
	    },
	case find_att_object(PS, Args, MonList) of 
		false ->
			find_target_helper(OrderList, PS, InArgs);
		NewAttTarget ->
			NewAttTarget
	end;
find_target_helper([user|OrderList], PS, {_, UserMap, _}=InArgs) ->
	#player_status{id = RoleId, scene = _Scene, battle_attr = BA, guild = #status_guild{id = GuildId}} = PS,
	UserList = maps:values(UserMap),
	Args = #scene_calc_args{
	    id = RoleId, sign = ?BATTLE_SIGN_PLAYER, group = BA#battle_attr.group,
	    guild_id = GuildId, pk_status = BA#battle_attr.pk#pk.pk_status
	    },
	case find_att_user(PS, Args, UserList) of 
		false ->
			find_target_helper(OrderList, PS, InArgs);
		NewAttTarget ->
			NewAttTarget
	end;
find_target_helper([Type|OrderList], PS, InArgs) when 
		Type == module_clt_mon orelse Type == module_object orelse Type == module_user ->
	case lib_fake_client_api:find_target_in_module(PS, Type) of 
		false ->
			find_target_helper(OrderList, PS, InArgs);
		NewAttTarget ->
			NewAttTarget
	end;
find_target_helper([_|OrderList], PS, InArgs) ->
	find_target_helper(OrderList, PS, InArgs).

%% 寻找采集怪
find_clt_object(_PS, []) -> false;
find_clt_object(PS, CltMonList) ->
	find_clt_object(PS, CltMonList, undefined).

find_clt_object(PS, CltMonList, Filter) ->
	%% 找一个离自己最近的
	#player_status{x = X, y = Y} = PS,
	F = fun(SObject, {Target, Distance}) ->
		case Filter =/= undefined andalso Filter(SObject)  == true of 
			true -> {Target, Distance};
			_ ->
				#scene_object{id = TId, config_id = MonId, x = TX, y = TY} = SObject,
				SimDis = abs(TX - X) + abs(TY - Y),
				case Distance == false orelse SimDis < Distance of 
					true -> 
						NewTarget = #att_target{key=object, id = TId, mon_id=MonId, x=TX, y=TY},
						{NewTarget, SimDis};
					_ -> {Target, Distance}
				end
		end
	end,
	{AttTarget, _} = lists:foldl(F, {false, false}, CltMonList),
	AttTarget.

%% 寻找怪物攻击
find_att_object(PS, Args, ObjectList) ->
	#player_status{x = X, y = Y} = PS,
	%?PRINT("find_att_object len obj: ~p ~n", [length(ObjectList)]),
	case lib_scene_calc:get_object_for_battle(ObjectList, X, Y, Args, {closest, X, Y}) of 
		#scene_object{id = Id, config_id = MonId, x = TX, y = TY} -> #att_target{key=object, id=Id, mon_id=MonId, x=TX, y=TY};
		_ -> false
	end.
%% 寻找玩家攻击
find_att_user(PS, Args, UserList) ->
	#player_status{x = X, y = Y} = PS,
	case lib_scene_calc:get_object_for_battle(UserList, X, Y, Args, {closest, X, Y}) of 
		#ets_scene_user{id = Id, x = TX, y = TY} -> #att_target{key=user, id=Id, x=TX, y=TY};
		_ -> false
	end.

%% 寻找掉落包
find_drop_pick(PS, DropList, Filter) ->
	%% 找一个离自己最近的
	#player_status{x = X, y = Y} = PS,
	NowTimeMS = utime:longunixtime(),
	NowTime = NowTimeMS div 1000,
	F = fun(DropGoods, {Target, Distance}) ->
		case Filter =/= undefined andalso Filter(DropGoods)  == true of 
			true -> {Target, Distance};
			_ ->
				case pick_check(PS, DropGoods, NowTimeMS, NowTime) of 
					false -> {Target, Distance};
					_ ->
						#ets_drop{id = TId, x = TX, y = TY} = DropGoods,
						SimDis = abs(TX - X) + abs(TY - Y),
						case Distance == false orelse SimDis < Distance of 
							true -> 
								NewTarget = #att_target{key=drop, id = TId, x=TX, y=TY},
								{NewTarget, SimDis};
							_ -> {Target, Distance}
						end
				end
		end
	end,
	{AttTarget, _} = lists:foldl(F, {false, false}, DropList),
	AttTarget.

%% 掉落包拾取基础检查
pick_check(PS, DropGoods, NowTimeMS, NowTime) ->
	#player_status{
		id = RoleId, server_id = RoleServerId, camp_id = RoleCamp, x = RX, y = RY,
		team = #status_team{team_id = _RoleTeamId}
	} = PS,
	#ets_drop{
        player_id = BlRoleId, camp_id = Camp, server_id = ServerId, team_id = _TeamId, x = DX, y = DY,
        expire_time = ExpireTime, pick_player_id = PickPlayerId, pick_end_time = PickEndTime} = DropGoods,
    %% 拾取的基础检查，复制部分拾取那边的检查
    %% 如果拾取后，返回的错误码失败，会排除拾取包
    if
    	ExpireTime > 0 andalso ExpireTime < NowTime -> false;
    	ServerId > 0 andalso ServerId =/= RoleServerId -> false;
    	Camp > 0 andalso Camp =/= RoleCamp -> false;
    	BlRoleId > 0 andalso RoleId =/= BlRoleId andalso (ExpireTime - NowTime) > ?DROP_SAVE_TIME -> false;
    	%TeamId > 0 andalso TeamId =/= RoleTeamId andalso (ExpireTime - NowTime > ?DROP_SAVE_TIME) -> false;
    	PickPlayerId > 0 andalso PickPlayerId =/= RoleId andalso NowTimeMS =< PickEndTime -> false;
    	%% 相距太远，不去寻找
    	abs(RX-DX) > 2000 orelse abs(RY-DY) > 2000 -> false;
    	true -> true
    end.

need_find_target(PS, FakeClient) ->
	#fake_client{
		behaviour = BehaviourName, att_target = AttTarget, scene_object_data = SceneObjectData, drop_goods_data = DropGoodsData
	} = FakeClient,
	case AttTarget of 
		#att_target{key = Key, id = Id, mon_id = MonId} ->
			CanInterrupt = can_interrupt_target(BehaviourName, Key, MonId),
			BehaviourInRevive = behaviour_in_revive(BehaviourName),
			if
			 	CanInterrupt == false orelse BehaviourInRevive -> false;
				Key == user orelse Key == object ->
					case maps:get(Key, SceneObjectData, 0) of 
						0 -> true;
						ObjectMap ->
							case maps:get(Id, ObjectMap, 0) of 
								0 -> 
									true;
								_Object -> false
							end
					end;
				Key == drop ->
					case maps:get(Id, DropGoodsData, 0) of 
						0 -> true; _DropGoods -> false
					end;
				true -> 
					lib_fake_client_api:need_find_target(PS)
			end;
		_ -> 
			BehaviourInRevive = behaviour_in_revive(BehaviourName),
			if
			 	BehaviourInRevive -> false;
				true -> 
					lib_fake_client_api:need_find_target(PS)
			end
	end.
%% 更新目标
change_target(PS, EventList) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{att_target = AttTarget} = FakeClient,
	{NewAttTarget, IsChange, IsUpdate} = change_target_do(PS, AttTarget, EventList),
	case IsChange of 
		true ->
			Ref = try_start_timer(FakeClient, 500, Pid, ?battle_msg(behaviour, [trace])),
			PS#player_status{fake_client = FakeClient#fake_client{behaviour_ref = Ref, att_target = NewAttTarget}};
		_ ->
			case IsUpdate of 
				true -> 
					PS#player_status{fake_client = FakeClient#fake_client{att_target = NewAttTarget}};
				_ -> 
					PS
			end
	end.

change_target_do(PS, #att_target{id = TId} = AttTarget, EventList) when TId > 0 -> 
	#player_status{fake_client = #fake_client{behaviour = BehaviourName, forbid_clt_mon = ForbidCltMon, forbid_pick = ForbidPick}} = PS,
	#att_target{key = _Key, mon_id = MonId} = AttTarget,
	F = fun(Event, {OldTarget, IsChange, IsUpdate}) ->
		case Event of 
			{move, Id, X, Y} when Id == TId ->
				{OldTarget#att_target{x = X, y = Y}, IsChange, true};
			{enter, ObjectList} ->
				case can_interrupt_target(BehaviourName, _Key, MonId) of 
					false -> {OldTarget, IsChange, IsUpdate};
					_ ->
						{_UserList, SObjectListt} = lists:partition(fun(Item) -> is_record(Item, ets_scene_user) end, ObjectList),
						{CltMonList, _MonList} = filter_clt_mon(SObjectListt),
						case CltMonList =/= [] of 
							true ->
								Filter = to_filter_clt_fun(ForbidCltMon),
								case find_clt_object(PS, CltMonList, Filter) of 
									false -> {OldTarget, IsChange, IsUpdate};
									Target -> 
										{Target, true, IsUpdate}
								end;
							_ ->
								{OldTarget, IsChange, IsUpdate}
						end
				end;
			{drop_enter, DropList} ->
				case can_interrupt_target(BehaviourName, _Key, MonId) of 
					false -> {OldTarget, IsChange, IsUpdate};
					_ ->
						Filter = to_filter_pick_fun(ForbidPick),
						case find_drop_pick(PS, DropList, Filter) of 
							false -> {OldTarget, IsChange, IsUpdate};
							Target -> 
								{Target, true, IsUpdate}
						end
				end;
			{leave, ObjectIdList} ->
				case lists:member(TId, ObjectIdList) of 
					true -> 
						{false, true, IsUpdate};
					_ -> {OldTarget, IsChange, IsUpdate}
				end;
			{drop_leave, DropIdL} ->
				case lists:member(TId, DropIdL) of 
					true -> 
						{false, true, IsUpdate};
					_ -> {OldTarget, IsChange, IsUpdate}
				end;
			{change_attr, _Sign, Id, _AttrList} when TId == Id ->
				{OldTarget, IsChange, true};
			_ ->
				{OldTarget, IsChange, IsUpdate}
		end
	end,
	{NewAttTarget, IsChange, IsUpdate} = lists:foldl(F, {AttTarget, false, false}, EventList),
	{NewAttTarget, IsChange, IsUpdate};
change_target_do(_PS, #att_target{mon_id = MonId} = AttTarget, EventList) when MonId > 0 ->
	%% 目标的id=0, 但是monid=/=0, 可能是其他模块带寻找的目标，没生成怪物id
	%% 此时有怪物进入视野的话，更新目标
	F = fun(Event, {OldTarget, IsChange, IsUpdate}) ->
		case Event of 
			{enter, ObjectList} ->
				{_, SObjectList} = lists:partition(fun(Item) -> is_record(Item, ets_scene_user) end, ObjectList),
				case [{Id, X, Y} ||#scene_object{id = Id, config_id = ConfigId, x = X, y = Y} <- SObjectList, ConfigId == MonId, Id > 0] of 
					[{TId, TX, TY}|_] ->
						%?MYLOG("lxl_change", "change_target_do update: ~p~n", [{TId, MonId}]),
						{AttTarget#att_target{id = TId, x = TX, y = TY}, IsChange, true};
					_ -> {OldTarget, IsChange, IsUpdate}
				end;
			_ ->
				{OldTarget, IsChange, IsUpdate}
		end
	end,
	{NewAttTarget, IsChange, IsUpdate} = lists:foldl(F, {AttTarget, false, false}, EventList),
	{NewAttTarget, IsChange, IsUpdate};
change_target_do(PS, _, EventList) ->
	%% 此时没有目标，如果有怪物进入，或者采集怪进入视野，选择目标
	F = fun(Event, {OldTarget, IsChange, IsUpdate}) ->
		case Event of 
			{KeyType, _EnterList} when KeyType == enter orelse KeyType == drop_enter ->
				case need_find_target(PS, PS#player_status.fake_client) of
					true ->
						Target = find_target(true, PS#player_status.fake_client, PS),
						case Target of 
							false -> {OldTarget, IsChange, IsUpdate};
							_ -> {Target, true, IsUpdate}
						end;
					_ ->
						{OldTarget, IsChange, IsUpdate}
				end;
			_ ->
				{OldTarget, IsChange, IsUpdate}
		end
	end,
	{NewAttTarget, IsChange, IsUpdate} = lists:foldl(F, {false, false, false}, EventList),
	{NewAttTarget, IsChange, IsUpdate}.

filter_clt_mon(ObjectList) ->
	lists:partition(fun(#scene_object{config_id=MonId}) -> 
		?is_clt_mon(MonId)
	end, ObjectList).

set_att_skill_data(AttSkillData, []) -> AttSkillData;
set_att_skill_data(AttSkillData, [Item|L]) ->
	AttSkillData1 = ?IF(is_record(AttSkillData, att_skill_data), AttSkillData, #att_skill_data{}),
	case Item of 
		{last_skill_id, SkillId} ->
			set_att_skill_data(AttSkillData1#att_skill_data{last_skill_id = SkillId}, L);
		{skill_link, SkillLink} ->
			set_att_skill_data(AttSkillData1#att_skill_data{skill_link = SkillLink}, L);
		{skill_cd, SkillId, CD} ->
			SkillCd = AttSkillData1#att_skill_data.skill_cd,
			set_att_skill_data(AttSkillData1#att_skill_data{skill_cd = lists:keystore(SkillId, 1, SkillCd, {SkillId, CD})}, L);
		_ ->
			set_att_skill_data(AttSkillData1, L)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 玩家死亡和复活处理
player_die(PS) ->
	#player_status{pid = Pid, fake_client = #fake_client{behaviour = BehaviourName}} = PS,
	ReviveInfo = lib_fake_client_api:get_revive_type_and_time(PS),
	if
		BehaviourName == ?BEHAVIOUR_IN_COLLECT -> %% 正在采集, 取消采集
			PS1 = cancel_collect(PS, 1);
		true -> 
			PS1 = PS
	end,
	case ReviveInfo of 
		{ReviveType, Timeout} ->
			#player_status{fake_client = FakeClient} = PS,
			#fake_client{behaviour_ref = OldRef} = FakeClient,
			Ref = util:send_after(OldRef, Timeout, Pid, ?battle_msg(behaviour, [{revive, ReviveType}])),
			NewFakeClient = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IN_REVIVE, behaviour_ref = Ref, att_target = false},
			%?MYLOG("lxl_battle", "player_die {ReviveType, Timeout}: ~p~n", [{ReviveType, Timeout}]),
			PS1#player_status{fake_client = NewFakeClient};
		_ -> %% 不自动复活, 等活动自动切场景
			#player_status{fake_client = FakeClient} = PS,
			#fake_client{behaviour_ref = OldRef} = FakeClient,
			util:cancel_timer(OldRef),
			NewFakeClient = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IN_REVIVE, behaviour_ref = undefined, att_target = false},
			%?MYLOG("lxl_battle", "player_die ReviveInfo: ~p~n", [ReviveInfo]),
			PS1#player_status{fake_client = NewFakeClient}
	end.

go_revive(PS, ReviveType) ->
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour_ref = OldRef} = FakeClient,
	Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
	PS1 = PS#player_status{fake_client = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref}},
	{_, NewPS} = lib_revive:revive_without_check(PS1, ReviveType, []),
	%?MYLOG("lxl_battle", "go_revive ~n", []),
	NewPS.

%% 复活成功后
player_revive(PS) ->
	%?MYLOG("lxl_battle", "player_revive ~n", []),
	#player_status{pid = Pid, fake_client = FakeClient} = PS,
	#fake_client{behaviour = BehaviourName, behaviour_ref = OldRef} = FakeClient,
	case BehaviourName of 
		?BEHAVIOUR_IN_REVIVE -> %% 定时器超时，就复活完成
			Ref = util:send_after(OldRef, 1000, Pid, ?battle_msg(behaviour, [trace])),
			NewPS = PS#player_status{fake_client = FakeClient#fake_client{behaviour = ?BEHAVIOUR_IDEL, behaviour_ref = Ref, att_target = false}},
			NewPS;
		_ -> %% 不处理
			PS
	end.

%% 尝试去挂机
try_go_to_obhook(PS) ->
	#player_status{id = RoleId, scene = Scene, fake_client = #fake_client{in_module = InModule}} = PS,
	case lib_scene:is_outside_scene(Scene) andalso InModule == 0 of 
		true -> %% 野外场景
			case get({?MODULE, lost_target}) of 
				undefined -> LostCnt = 1;
				R -> LostCnt = R + 1
			end,
			put({?MODULE, lost_target}, LostCnt),
			case LostCnt rem 5 == 0 of 
				true -> %% 累积5次都没目标，到野外挂机点
					TargetPlace = lib_onhook_offline:select_a_onhook_place(PS, Scene),
					case TargetPlace of
						{_, TX, TY} -> %% 直接切场景，重新走加载场景流程
							lib_scene:player_change_scene(RoleId, Scene, 0, 0, TX, TY, false, []);
						{TScene, _, TX, TY} -> %% 直接切场景，重新走加载场景流程
							lib_scene:player_change_scene(RoleId, TScene, 0, 0, TX, TY, false, []);
						_ -> ok
					end;
				_ -> ok
			end;
		_ -> ok
	end.

can_interrupt_target(BehaviourName, Key, MonId) ->
	not (behaviour_in_collect(BehaviourName, MonId) orelse behaviour_in_pick(BehaviourName, Key)).

behaviour_in_collect(BehaviourName, MonId) ->
	IsCltMon = ?is_clt_mon(MonId),
	((BehaviourName == ?BEHAVIOUR_IN_COLLECT orelse BehaviourName == ?BEHAVIOUR_MOVE_COLLECT) andalso IsCltMon).

behaviour_in_pick(BehaviourName, Key) ->
	(BehaviourName == ?BEHAVIOUR_IN_PICK orelse BehaviourName == ?BEHAVIOUR_MOVE_COLLECT) andalso Key == drop.

behaviour_in_revive(BehaviourName) ->
	BehaviourName == ?BEHAVIOUR_IN_REVIVE.

fix_loop_block(FakeClient, _SceneId, _CopyId, Xnext, Ynext) ->
	#fake_client{in_module = ModuleId, last_ten_xy = LastTenXy} = FakeClient,
	if
		ModuleId == ?MOD_TERRITORY orelse ModuleId == ?MOD_HOLY_SPIRIT_BATTLEFIELD 
		orelse ModuleId == ?MOD_TERRITORY_WAR orelse ModuleId == ?MOD_NINE ->
			Len = length(LastTenXy),
			case Len > 9 of 
				true -> 
					[_|L] = lists:reverse(LastTenXy),
					NewLastTenXy = [{Xnext, Ynext}|lists:reverse(L)];
				_ -> NewLastTenXy = [{Xnext, Ynext}|LastTenXy]
			end,
			case length([1 ||{X,Y} <- NewLastTenXy, X == Xnext, Y == Ynext]) >= 3 of 
				true -> %% 
					{NewX, NewY} = lib_fake_client_api:get_loop_block_xy(FakeClient, _SceneId, _CopyId, Xnext, Ynext),
					?MYLOG("lxl_block", "fix_loop_block NewXy: ~p ~n", [{NewX, NewY, ModuleId}]),
					{true, NewX, NewY, FakeClient#fake_client{last_ten_xy = []}};
				_ ->
					{false, Xnext, Ynext, FakeClient#fake_client{last_ten_xy = NewLastTenXy}}
			end;
		true ->
			{false, Xnext, Ynext, FakeClient}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 场景进程
%% 释放辅助技能
assist_skill(RoleId, X, Y, IsCombo, IsReFindT, SkillId, SkillLv, CallBackArgs, EtsScene) ->
	case lib_battle:assist_to_anyone(RoleId, RoleId, IsCombo, SkillId, SkillLv, CallBackArgs, EtsScene) of
        #skill_return{aer_info = [SkillCombo|_], main_skill = MainSkillId} ->
            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                false -> ok;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} -> %% 施放combo技能
                    ComboArgs = {X, Y, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                    util:send_after([], max(NextSkillTime, 10), self(), {fake_client, ?MODULE, auto_battle_combo, [RoleId, ComboArgs]})
            end;
        _ -> ok
    end.

object_start_battle(RoleId, TSign, TId, IsReFindT, SkillId, SkillLv, _IsNormal, EtsScene) ->
	case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, RoleId, {target, TSign, TId}, SkillId, SkillLv, 0, EtsScene) of
	    #skill_return{
	        aer_info = [SkillCombo|_],
	        rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
	        main_skill = MainSkillId
	    } ->
	        case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
	            false -> skip;
	            {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
	                ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
	                erlang:send_after(NextSkillTime+500, self(), {fake_client, ?MODULE, auto_battle_combo, [RoleId, ComboArgs]})
	        end;
	    _O ->
	        ok
	end.

%% 副技能释放
auto_battle_combo(RoleId, ComboArgs, EtsScene) ->
	case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{} = User -> auto_battle_combo_do(ComboArgs, User, EtsScene);
        _ -> skip
    end.

auto_battle_combo_do({OX, OY, X, Y, SkillId, SkillLv, IsReFindT, BulletDis, Radian}, User, EtsScene) ->
    #ets_scene_user{id = Id} = User,
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = ?SKILL_TYPE_ACTIVE, is_combo = 1} ->
            Args = if
                IsReFindT -> find_target;
                BulletDis > 0 ->
                   %% Radian = math:atan2(Y-OY, X-OX),
                   {xy, round(OX+BulletDis*math:cos(Radian)), round(OY+BulletDis*math:sin(Radian)), X, Y, BulletDis};
                true -> {xy, OX, OY, X, Y}
            end,

            case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, Id, Args, SkillId, SkillLv, Radian, EtsScene) of
                {false, _ErrCode} -> skip;
                #skill_return{
                    aer_info = [SkillCombo|_],
                    rx = OX1, ry = OY1, tx = AttX, ty = AttY, radian = Radian,
                    main_skill = MainSkillId
                } ->
                    case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                        false -> skip;
                        {NextSkillId, NextSkillLv, NextSkillTime, _} ->
                            ComboArgs = {OX1, OY1, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
                            erlang:send_after(NextSkillTime+500, self(), {fake_client, ?MODULE, auto_battle_combo, [Id, ComboArgs]})
                    end,
                    skip;
                _O ->
                    skip
            end;
        #skill{type = ?SKILL_TYPE_ASSIST, is_combo = 1} ->
            CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
            case lib_battle:assist_to_anyone(Id, Id, 1, SkillId, SkillLv, CallBackArgs, EtsScene) of
                #skill_return{aer_info = [SkillCombo|_], main_skill = MainSkillId} ->
                    case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                        false -> skip;
                        {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                            ComboArgs = {OX, OY, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                            erlang:send_after(NextSkillTime+500, self(), {fake_client, ?MODULE, auto_battle_combo, [Id, ComboArgs]})
                    end,
                    skip;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

