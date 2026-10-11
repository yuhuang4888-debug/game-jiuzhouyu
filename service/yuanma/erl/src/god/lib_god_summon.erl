%% ---------------------------------------------------------------------------
%% @doc 变身系统
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_god_summon).
-include("god.hrl").
-include("attr.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("kf_guild_war.hrl").
-include("dungeon.hrl").
%%-export([
%%	%% 事件回调处理
%%	handle_event/2,
%%	%% 变身切换
%%	switch_god/1,
%%	do_switch_god/1,
%%	player_die/1,
%%	get_max_dot/1
%%]).

-compile(export_all).


%% 完成场景切换时不中断变身的场景类型列表
%%-define(NOT_INTERRUPT_SCENE, [?SCENE_TYPE_KFSUR]).

%% ---------------------------------------------------------------------------
%% @doc 事件回调处理
-spec handle_event(PS, EC) ->
	{ok, NewPS} when
	PS :: #player_status{},
	EC :: #event_callback{},
	NewPS :: #player_status{}.
%% ---------------------------------------------------------------------------
%%handle_event(PS, #event_callback{type_id = ?EVENT_PREPARE_CHANGE_SCENE}) ->
%%	#player_status{god = StatusGod, figure = Figure, scene = _SceneId, id = RoleId, old_scene_info = Info} = PS,
%%	#status_god{summon = Summon} = StatusGod,
%%	#god_summon{seq = Seq, ref = OldRef, god_id = _GodId, passive_skill = OldPassiveSkill} = Summon,
%%%%    [SceneType|_] = lib_scene:get_scene_type(SceneId),
%%%%    IsForbidScene = lib_god_util:is_forbid_scene(SceneId),
%%	?MYLOG("cym", "EVENT_PREPARE_CHANGE_SCENE ~p~n", [Info]),
%%	if
%%	%% 切换场景，不能变身的场景，带入降神
%%		Seq > 0 ->
%%%%			?MYLOG("cym", "EVENT_PREPARE_CHANGE_SCENE ~n", []),
%%			mod_scene_agent:update(PS, [{delete_passive_skill, OldPassiveSkill}]),  %%删除被动技能
%%			clear_buff(RoleId, Summon),
%%%%			Cd = get_summon_cd_by_god_id(GodId),
%%			util:cancel_timer(OldRef),
%%%%			Cd = get_summon_cd_by_god_id(GodId),
%%			NewSummon = #god_summon{start_time = utime:unixtime()},
%%			NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%			NewGodId = NewSummon#god_summon.god_id,
%%			NewFigure = Figure#figure{god_id = NewGodId},
%%			NewPS = PS#player_status{god = NewStatusGod, figure = NewFigure},
%%			pp_god:handle(44010, NewPS, []),
%%			{ok, NewPS};
%%		true ->
%%			NewSummon = #god_summon{start_time = utime:unixtime()},
%%			NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%			NewPs = PS#player_status{god = NewStatusGod},
%%			pp_god:handle(44010, NewPs, []),
%%			{ok, NewPs}
%%	end;
handle_event(PS, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) ->
	#player_status{god = StatusGod, figure = Figure, id = RoleId} = PS,
	#status_god{summon = Summon} = StatusGod,
	#god_summon{seq = Seq, ref = OldRef, god_id = GodId, passive_skill = OldPassiveSkill} = Summon,
	if
	%% 死亡处理，结束变身，更新场景进程形象
		Seq > 0 ->
			mod_scene_agent:update(PS, [{delete_passive_skill, OldPassiveSkill}]),  %%删除被动技能
			clear_buff(RoleId, Summon),
			Cd = get_summon_cd_by_god_id(GodId),
			util:cancel_timer(OldRef),
			Cd = get_summon_cd_by_god_id(GodId),
			NewSummon = #god_summon{start_time = utime:unixtime() + Cd},
			NewStatusGod = StatusGod#status_god{summon = NewSummon},
			NewGodId = NewSummon#god_summon.god_id,
			NewFigure = Figure#figure{god_id = NewGodId},
			NewPS = PS#player_status{god = NewStatusGod, figure = NewFigure},
			mod_scene_agent:update(NewPS, [{god_id, NewGodId}]),
			pp_god:handle(44010, NewPS, []),
			lib_scene:broadcast_player_attr(NewPS, [{?scene_god_id, NewGodId}]),  %%
			{ok, NewPS};
		true ->
			{ok, PS}
	end;
%%handle_event(PS, #event_callback{type_id = ?EVENT_GOD_BATTLE, data = {OldBattle, Battle}}) ->
%%    #player_status{god = StatusGod} = PS,
%%    #status_god{summon = #god_summon{start_time = StartTime, ref=OldRef} = Summon} = StatusGod,
%%    OldBattle2 = lib_god_api:get_enter_battle(OldBattle),
%%    Battle2 = lib_god_api:get_enter_battle(Battle),
%%    if
%%        %% 出战第一个元神，开始累计能量槽点数
%%        StartTime ==0 andalso length(OldBattle2)==0 andalso length(Battle2)>0 ->
%%            NewSummon = Summon#god_summon{start_time = utime:unixtime()},
%%            NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%            NewPS = PS#player_status{god = NewStatusGod},
%%            {ok, NewPS};
%%        %% 主战位元神都放到助战位
%%        length(OldBattle2)>0 andalso length(Battle2) == 0 ->
%%            util:cancel_timer(OldRef),
%%            NewSummon = #god_summon{start_time = utime:unixtime()},
%%            NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%            NewPS = PS#player_status{god = NewStatusGod},
%%            {ok, NewPS};
%%        true -> {ok, PS}
%%    end;
handle_event(PS, _EC) ->
	{ok, PS}.

%% ---------------------------------------------------------------------------
%% @doc 变身切换
-spec switch_god(PS) ->
	NewPS when
	PS :: #player_status{},
	NewPS :: #player_status{}.
%% ---------------------------------------------------------------------------
switch_god(PS) ->
	#player_status{god = StatusGod} = PS,
	case check_switch_god(PS, StatusGod, [is_enter, is_cd, is_ban_status, is_last_seq, scnen_type]) of
		true ->
			do_switch_god(PS);
		{false, Res} ->
			{false, Res}
	end.

do_switch_god(PS) ->
%%	?MYLOG("cym", "do_switch_god ++++++++++++ ~n", []),
	#player_status{god = StatusGod, figure = Figure, id = RoleId, scene = Scene, scene_pool_id = ScenePoolId} = PS,
	#status_god{summon = #god_summon{seq = Seq, ref = OldRef, passive_skill = OldPassiveSkill, god_id = OldGodId} = Summon, god_list = GodList} = StatusGod,
	util:cancel_timer(OldRef),
	Battle = lib_god_api:get_enter_battle(StatusGod),
	NewSummon = if
	%% 变身结束
		Seq >= length(Battle) ->
			mod_scene_agent:update(PS, [{delete_passive_skill, OldPassiveSkill}, {tmp_attr_skill, OldPassiveSkill}]),  %%删除被动技能
			clear_buff(RoleId, Summon),
			Cd = get_summon_cd_by_god_id(OldGodId),
			#god_summon{start_time = utime:unixtime() + Cd};
	%% 切换到下一个变身
		true ->
			NewSeq = Seq + 1,
			NewBattle = lists:keysort(1, Battle),
			{_Pos, GodId} = lists:nth(NewSeq, NewBattle),
			Time = get_summon_time(StatusGod),  %%变身时长
			Ref = erlang:send_after(Time * 1000, self(), {mod, ?MODULE, do_switch_god, []}),
			EndTime = Time + utime:unixtime(),
			{InitiativeTransFormSkill, PassiveSkill, AssistSkill} = get_trans_form_skill(GodId, GodList),
%%			?MYLOG("cym", "endTime ~p, InitiativeTransFormSkill  ~p, PassiveSkill ~p~n  AssistSkill ~p~n",
%%				[EndTime, InitiativeTransFormSkill, PassiveSkill, AssistSkill]),
			[lib_battle_api:assist_anything(Scene, ScenePoolId, ?BATTLE_SIGN_PLAYER, RoleId, ?BATTLE_SIGN_PLAYER, RoleId, AssistSkillId, AssistSkillLv)
			|| {AssistSkillId, AssistSkillLv} <- AssistSkill],
			mod_scene_agent:update(PS, [{passive_skill, PassiveSkill}, {tmp_attr_skill, PassiveSkill}]),  %%更新被动技能
			Summon#god_summon{seq = NewSeq, god_id = GodId, start_time = 0, ref = Ref, end_time = EndTime,
				initiative_skill = InitiativeTransFormSkill, passive_skill = PassiveSkill, assist_skill = AssistSkill}
	end,
	NewGodId = NewSummon#god_summon.god_id,
	NewStatusGod = StatusGod#status_god{summon = NewSummon},
	NewFigure = Figure#figure{god_id = NewGodId},
	NewPS = PS#player_status{god = NewStatusGod, figure = NewFigure},
	mod_scene_agent:update(NewPS, [{god_id, NewGodId}]),
	lib_scene:broadcast_player_attr(NewPS, [{?scene_god_id, NewGodId}]),  %%
	NewPS.


%%%%获取降神Cd
%%get_summon_cd(GodId) ->
%%	#status_god{battle = Battle} = StatusGod,
%%	case Battle of
%%		[{_Pos, GodId} | _] ->
%%			case data_god:get_god(GodId) of
%%				#base_god{cd = CD} ->
%%					CD;
%%				_ ->
%%					?SWITCH_CD
%%			end;
%%		_ ->
%%			?SWITCH_CD
%%	end.

%%获取降神Cd
get_summon_cd_by_god_id(GodId) ->
	case data_god:get_god(GodId) of
		#base_god{cd = CD} ->
			CD;
		_ ->
			?SWITCH_CD
	end.





get_summon_time(StatusGod) ->
	#status_god{battle = Battle, god_list = GodList} = StatusGod,
	case Battle of
		[{_Pos, GodId} | _] ->
			case data_god:get_god(GodId) of
				#base_god{trans_form_time = Time, talent = Talent} ->
					case lists:keyfind(GodId, #god.id, GodList) of
						#god{grade = Grade} ->
							AddTime = get_skill_add_time(Talent, Grade),
%%							?PRINT("Talent ~p~n", [Talent]),
%%							?PRINT("Grade ~p~n", [Grade]),
%%							?PRINT("AddTime ~p~n", [AddTime]),
							AddTime + Time;
						_ ->
							Time
					end;
				_ ->
					?SWITCH_CD
			end;
		_ ->
			?SWITCH_CD
	end.

get_max_dot(Trans) ->
	case data_god:get_trans(Trans) of
		#base_trans{trans_open = TransOpen} ->
			case lists:keyfind(max_dot, 1, TransOpen) of
				false ->
					?MAX_DOT;
				{_, Dot} ->
					Dot
			end;
		_ ->
			?MAX_DOT
	end.

%% --------------------------- check_build function --------------------------
check_switch_god(_PS, _StatusGod, []) ->
	true;
check_switch_god(PS, StatusGod, [H | T]) ->
	case do_check_switch_god(PS, StatusGod, H) of
		true ->
			check_switch_god(PS, StatusGod, T);
		{false, Res} ->
			{false, Res}
	end.

do_check_switch_god(_PS, StatusGod, is_enter) ->
	Battle = lib_god_api:get_enter_battle(StatusGod),
	case length(Battle) > 0 of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err440_empty_battle_god)}
	end;
do_check_switch_god(_PS, StatusGod, is_cd) ->
	NowTime = utime:unixtime(),
%%	SummonCd = get_summon_cd(StatusGod),
	#status_god{summon = Summon} = StatusGod,
	#god_summon{seq = Seq, start_time = StartTime} = Summon,
%%	?MYLOG("cym", "Now  ~p StartTime ~p, cd ~p~n", [NowTime, StartTime, SummonCd]),
	if
		Seq > 0 ->
			true;
		StartTime > 0 andalso NowTime >= StartTime ->
			true;
		true ->
			{false, ?ERRCODE(err440_cd_not_end)}
	end;
do_check_switch_god(PS, _StatusGod, is_ban_status) ->
%%    Status = PS#player_status.status,
	BattleAttr = PS#player_status.battle_attr,
%%    BanStatusList = [?P_STATUS_BUTTERFLY, ?P_STATUS_HOTWELL],
%%    IsBanStatus = lists:member(Status, BanStatusList),

%%	IsKfGuildShip = lib_kf_guild_war_api:is_in_ship_model(PS),
	if
%%        IsBanStatus ->
%%            {false, ?ERRCODE(err440_cannot_switch_status)};
		BattleAttr#battle_attr.hp =< 0 orelse
			BattleAttr#battle_attr.ghost == 1 ->
			{false, ?ERRCODE(err440_cannot_switch_status)};
%%		IsKfGuildShip ->
%%			{false, ?ERRCODE(err440_cannot_switch_status)};
		true ->
			true
	end;
do_check_switch_god(_PS, StatusGod, is_last_seq) ->
	#status_god{summon = #god_summon{seq = Seq}} = StatusGod,
	Battle = lib_god_api:get_enter_battle(StatusGod),
	if
		Seq >= length(Battle) ->
			{false, ?ERRCODE(err440_last_seq)};
		true ->
			true
	end;
do_check_switch_god(PS, _StatusGod, scnen_type) ->
	#player_status{scene = Scene} = PS,
	IsForbidScene = lib_god_util:is_forbid_scene(Scene),
	if
		IsForbidScene == true ->
			{false, ?ERRCODE(err440_forbid_scene_type)};
		true ->
			true
	
	end;
do_check_switch_god(_PS, _StatusGod, _T) ->
	?ERR("do_check_switch_god:~p~n", [_T]),
	{false, ?FAIL}.

%%死亡处理
player_die(PS) ->
	PS.
% #player_status{god = StatusGod} = PS,
% #status_god{summon = Summon} = StatusGod,
% #god_summon{ref = OldRef} = Summon,
% util:cancel_timer(OldRef),
% NewSummon = #god_summon{start_time = utime:unixtime()},
% NewStatusGod = StatusGod#status_god{summon = NewSummon},
% NewPS = PS#player_status{god = NewStatusGod},
% NewPS.

%% -----------------------------------------------------------------
%% @desc     功能描述  获得变身后的技能，且技能的职业为降神的技能Id
%% @param    参数      GodId :降神id   GodList::[#god{}]
%% @return   返回值    SkillIdList :: {[{SkillId, lv}], {id, lv}}
%% @history  修改历史
%% -----------------------------------------------------------------
get_trans_form_skill(GodId, GodList) ->
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{grade = Grade} ->
			case data_god:get_god(GodId) of
				#base_god{skill = SkillIdListCfg, talent = TalentList, transform_skill = TransFormSkill} ->
					TalentIdList = [{TempSkillId, TempLv} || {TempSkillId, NeedGrade, TempLv} <- TalentList, Grade >= NeedGrade],
					{PassiveSkill, AssistSkill} = get_god_skill(lists:reverse(TalentIdList)),
					case lists:keyfind(Grade, 1, SkillIdListCfg) of
						{_, SkillIdList} ->
							ok;
						_ ->
							SkillIdList = []
					end,
					{[{TempID, 1} || TempID <- SkillIdList], PassiveSkill,
					AssistSkill ++ [{TempSkillId1, 1} || TempSkillId1 <-TransFormSkill]};
				_ ->
					[]
			end;
		_ ->
			[]
	end.


%%{[{skill_id, 1}], [{skill_id, 1}]}  {被动技能, 辅助技能}
get_god_skill(Lists) ->
	get_god_skill(Lists, {[], []}).

get_god_skill([], Res) ->
	Res;
get_god_skill([{Id, Lv}| List], {PassiveSkill, AssistSkill}) ->
	case data_skill:get(Id, Lv) of  %%都是默认一级
		#skill{career = ?SKILL_CAREER_GOD, type = ?SKILL_TYPE_PASSIVE} ->
			case lists:keyfind(Id, 1, PassiveSkill) of
				{Id, OldLv} ->
					if
						Lv > OldLv ->
							PassiveSkill1 = lists:keydelete(Id, 1, PassiveSkill),
							get_god_skill(List, {[{Id, Lv}| PassiveSkill1], AssistSkill});
						true ->  %%去重，只是取最高等级的
							get_god_skill(List, {PassiveSkill, AssistSkill})
					end;
				_ ->
					get_god_skill(List, {[{Id, Lv}| PassiveSkill], AssistSkill})
			end;
		#skill{career = ?SKILL_CAREER_GOD, type = ?SKILL_TYPE_ASSIST} ->
			case lists:keyfind(Id, 1, AssistSkill) of
				{Id, OldLv} ->
					if
						Lv > OldLv ->
							AssistSkill1 = lists:keydelete(Id, 1, AssistSkill),
							get_god_skill(List, {PassiveSkill, [{Id, Lv} | AssistSkill1]});
						true ->  %%去重，只是取最高等级的
							get_god_skill(List, {PassiveSkill, AssistSkill})
					end;
				_ ->
					get_god_skill(List, {PassiveSkill, [{Id, Lv} | AssistSkill]})
			end;
		_ ->
			get_god_skill(List, {PassiveSkill, AssistSkill})
	end.

clear_buff(RoleId, Summon) ->
	#god_summon{initiative_skill = Skill1, passive_skill = Skill2, assist_skill = AssistSkill} = Summon,
	SkillIdList = [SkillId ||{SkillId, _} <- Skill1 ++ Skill2 ++ AssistSkill],
	lib_skill_api:clean_buff(RoleId, SkillIdList).
%%将神切换场景的处理
change_scene(PS, EnterScene, _) ->  %%场景一样则不改变cd
	#player_status{god = StatusGod, figure = Figure, id = RoleId, dungeon = StatusDungeon} = PS,
	DunType = ?IF(is_record(StatusDungeon, status_dungeon), StatusDungeon#status_dungeon.dun_type, 0),
	IsForbidScene = lib_god_util:is_forbid_scene(EnterScene),
	case DunType == ?DUNGEON_TYPE_RANK_KF orelse IsForbidScene == true of
		true ->
			case StatusGod of
				#status_god{summon = Summon} ->
					#god_summon{seq = Seq, ref = OldRef, god_id = _GodId, passive_skill = OldPassiveSkill} = Summon,
					if
						Seq > 0 ->
							mod_scene_agent:update(PS, [{delete_passive_skill, OldPassiveSkill}]),  %%删除被动技能
							clear_buff(RoleId, Summon),
							util:cancel_timer(OldRef),
							NewSummon = #god_summon{start_time = utime:unixtime()},
							NewStatusGod = StatusGod#status_god{summon = NewSummon},
							NewGodId = NewSummon#god_summon.god_id,
							NewFigure = Figure#figure{god_id = NewGodId},
							NewPS = PS#player_status{god = NewStatusGod, figure = NewFigure},
%%							pp_god:handle(44010, NewPS, []),
							mod_scene_agent:update(NewPS, [{god_id, NewGodId}]),
							lib_scene:broadcast_player_attr(NewPS, [{?scene_god_id, NewGodId}]),  %%
							NewPS;
						true ->
							NewSummon = #god_summon{start_time = utime:unixtime()},
							NewStatusGod = StatusGod#status_god{summon = NewSummon},
							NewPs = PS#player_status{god = NewStatusGod},
%%							pp_god:handle(44010, NewPs, []),
							NewPs
					end;
				_ ->
					PS
			end;
		_ ->
			PS
	end.
%%change_scene(PS, _SceneId, _NowSceneId) ->
%%	#player_status{god = StatusGod, figure = Figure, id = RoleId} = PS,
%%	case StatusGod of
%%		#status_god{summon = Summon} ->
%%			#god_summon{seq = Seq, ref = OldRef, god_id = _GodId, passive_skill = OldPassiveSkill} = Summon,
%%			if
%%				Seq > 0 ->
%%					mod_scene_agent:update(PS, [{delete_passive_skill, OldPassiveSkill}]),  %%删除被动技能
%%					clear_buff(RoleId, Summon),
%%					util:cancel_timer(OldRef),
%%					NewSummon = #god_summon{start_time = utime:unixtime()},
%%					NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%					NewGodId = NewSummon#god_summon.god_id,
%%					NewFigure = Figure#figure{god_id = NewGodId},
%%					NewPS = PS#player_status{god = NewStatusGod, figure = NewFigure},
%%%%					pp_god:handle(44010, NewPS, []),
%%					NewPS;
%%				true ->
%%					NewSummon = #god_summon{start_time = utime:unixtime()},
%%					NewStatusGod = StatusGod#status_god{summon = NewSummon},
%%					NewPs = PS#player_status{god = NewStatusGod},
%%%%					pp_god:handle(44010, NewPs, []),
%%					NewPs
%%			end;
%%		_ ->
%%			PS
%%	end.


get_skill_add_time(TalentCfg, Grade) ->
	TalentList = [SkillId || {SkillId, GradeCfg, _} <-TalentCfg, Grade >= GradeCfg],
	TimeList = data_god:get_kv(god_skill_add_time),
	F = fun(Id, AccTime) ->
			case lists:keyfind(Id, 1, TimeList) of
				{_, Time} ->
					AccTime + Time;
				_ ->
					AccTime
			end
		end,
	lists:foldl(F, 0, TalentList).