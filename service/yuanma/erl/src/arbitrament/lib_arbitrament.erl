%%-----------------------------------------------------------------------------
%% @Module  :       lib_arbitrament.erl
%% @Author  :       
%% @Email   :       j-som@foxmail.com
%% @Created :       2019-01-03
%% @Description:    圣裁
%%-----------------------------------------------------------------------------

-module (lib_arbitrament).
-include ("common.hrl").
-include ("errcode.hrl").
-include ("arbitrament.hrl").
-include ("predefine.hrl").
-include ("def_fun.hrl").
-include ("server.hrl").

-compile(export_all).

login(PS) ->
	{SkillFrom, ArbitramentList} = init_arbitrament(PS#player_status.id),
	LoopList = init_arbitrament_loop(PS#player_status.id),
	NPS = PS#player_status{arbitrament_status = #arbitrament_status{skill_from = SkillFrom, arbitrament_list = ArbitramentList, loop_list = LoopList}},
	LastPS = count_arbitrament_attr_do(NPS),
	%?PRINT("login ~p~n", [LastPS#player_status.arbitrament_status]),
	LastPS.

init_arbitrament(RoleId) ->
	case db_select_arbitrament_list(RoleId) of 
		[] -> 
			% WeaponIdList = data_arbitrament:get_weapon_list(),	
			% ArbitramentList = [#arbitrament{weapon_id = WeaponId} || WeaponId <- WeaponIdList],	
			{0, []};
		L ->
			F = fun([WeaponId, Lv, Score, State], {SkillFrom, List}) ->
				Arbitrament = #arbitrament{weapon_id = WeaponId, lv = Lv, score = Score, state = State},
				NSkillFrom = ?IF(State == 1, WeaponId, SkillFrom),
				{NSkillFrom, [Arbitrament|List]}
			end,
			lists:foldl(F, {0, []}, L)
	end.

init_arbitrament_loop(RoleId) ->
	case db_select_arbitrament_loop(RoleId) of 
		[] -> 
			[];
		L ->
			F = fun([WeaponId, LoopTimes, UTime, No, ScoreAdd, OpenMax], List) ->
				{NLoopTimes, NewNo, NewScoreAdd, NewOpenMax} = ?IF(utime:is_today(UTime), {LoopTimes, No, ScoreAdd, OpenMax}, {0, 0, 0, 0}),
				ArbitramentLoop = #arbitrament_loop{
					weapon_id = WeaponId, loop_times = NLoopTimes, utime = UTime, loop_no = NewNo, 
					loop_score = NewScoreAdd, open_max = NewOpenMax
				},
				[ArbitramentLoop|List]
			end,
			lists:foldl(F, [], L)
	end.

gm_clear_loop(PS) ->
	#player_status{id = RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{loop_list = LoopList} = ArbitramentSt,
	NLoopList = [
		begin
			NArbitramentLoop = ArbitramentLoop#arbitrament_loop{loop_times = 0, utime = 0, open_max = 0, loop_no = 0, loop_score = 0},
			db_replace_arbitrament_loop(RoleId, NArbitramentLoop),
			NArbitramentLoop
		end || ArbitramentLoop <- LoopList
	],
	NArbitramentSt = ArbitramentSt#arbitrament_status{loop_list = NLoopList},
	NPS = PS#player_status{arbitrament_status = NArbitramentSt},
	get_arbitrament_list(NPS),
	NPS.

%% 获取圣裁列表
get_arbitrament_list(PS) ->
	#player_status{sid = Sid, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = _SkillFrom, arbitrament_list = ArbitramentList, loop_list = LoopList} = ArbitramentSt,
	Info = [{WeaponId, Lv, Score, State} || #arbitrament{weapon_id = WeaponId, lv = Lv, score = Score, state = State} <- ArbitramentList],
	%LoopInfo = [{WeaponId, LoopTimes, UTime} || #arbitrament_loop{weapon_id = WeaponId, loop_times = LoopTimes, utime = UTime} <- LoopList],
	F = fun(#arbitrament_loop{weapon_id = WeaponId, loop_times = LoopTimes, utime = UTime}, L) ->
		LoopTimes1 = ?IF(utime:is_today(UTime), LoopTimes, 0),
		[{WeaponId, LoopTimes1, UTime}|L]
	end,
	LoopInfo = lists:foldl(F, [], LoopList),
	%?PRINT("Info ~p~n", [Info]),
	%?PRINT("LoopInfo ~p~n", [LoopInfo]),
	lib_server_send:send_to_sid(Sid, pt_139, 13901, [Info, LoopInfo]).

%% 手动使用道具激活/升级圣裁
active_arbitrament(PS, WeaponId) ->
	#player_status{id = RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = _SkillFrom, arbitrament_list = ArbitramentList} = ArbitramentSt,
	Arbitrament = ulists:keyfind(WeaponId, #arbitrament.weapon_id, ArbitramentList, #arbitrament{weapon_id = WeaponId}),
	case active_arbitrament_helper(PS, Arbitrament, manual) of 
		{true, PS1, Arbitrament1, Cost} ->
			{LastPS, NArbitrament} = upgrade_arbitrament(PS1, Arbitrament1, true),
			db_replace_arbitrament(RoleId, NArbitrament),
			log_ugrade_arbitrament(RoleId, Arbitrament, NArbitrament, Cost),
			%?PRINT("active_arbitrament st ~p~n", [LastPS#player_status.arbitrament_status]),
			{true, LastPS, NArbitrament};
		{false, Res} ->
			{false, Res}
	end.

active_arbitrament_helper(PS, Arbitrament, ActiveType) ->
	#arbitrament{weapon_id = WeaponId, lv = Lv, score = Score} = Arbitrament,
	case data_arbitrament:get(WeaponId, Lv+1) of 
		#base_arbitrament{cost_type = 0, cost = Cost} when ActiveType == manual ->
			case lib_goods_api:cost_object_list_with_check(PS, Cost, arbitrament, "active_arbitrament") of 
				{true, NPS} ->
					{true, NPS, Arbitrament#arbitrament{lv = Lv+1}, Cost};
				{false, Res, _} ->
					{false, Res}
			end;
		#base_arbitrament{cost_type = 1, cost = Cost} when ActiveType == auto ->
			case Score >= Cost of 
				true ->
					{true, PS, Arbitrament#arbitrament{lv = Lv+1, score = Score-Cost}, []};
				_ ->
					{true, PS, Arbitrament, []}
			end;	
		_ ->
			{false, ?MISSING_CONFIG}
	end.

%% 获取转盘得到的积分值
loop_arbitrament_score(PS, WeaponId) ->
	#player_status{id = RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{arbitrament_list = ArbitramentList, loop_list = LoopList} = ArbitramentSt,
	#arbitrament{lv = Lv} = 
		ulists:keyfind(WeaponId, #arbitrament.weapon_id, ArbitramentList, #arbitrament{weapon_id = WeaponId}),
	#arbitrament_loop{loop_times = LoopTimes, utime = OUtime, loop_no = No, loop_score = ScoreAdd, open_max = OpenMax} = ArbitramentLoop = 
		ulists:keyfind(WeaponId, #arbitrament_loop.weapon_id, LoopList, #arbitrament_loop{weapon_id = WeaponId}),
	IsToday = utime:is_today(OUtime),
	case LoopTimes >= ?ARBITRAMENT_LOOP_TIMES_MAX andalso IsToday of 
		true -> {false, ?ERRCODE(err139_no_loop_times)};
		_ ->
			case data_arbitrament:get(WeaponId, Lv+1) of 
				#base_arbitrament{cost_type = 1} ->
					case ScoreAdd > 0 of 
						true -> 
							NewNo = No, NewScoreAdd = ScoreAdd,
							NPS = PS;
						_ -> 
							OpenMax1 = ?IF(IsToday == true, OpenMax, 0),
							{NewNo, NewScoreAdd} = loop_score(WeaponId, LoopTimes, OpenMax1),
							NewOpenMax = ?IF(OpenMax1 == 0 andalso NewScoreAdd >= ?ARBITRAMENT_MAX_SCORE, 1, OpenMax1),
							NArbitramentLoop = ArbitramentLoop#arbitrament_loop{loop_no = NewNo, loop_score = NewScoreAdd, open_max = NewOpenMax},
							db_replace_arbitrament_loop(RoleId, NArbitramentLoop),
							NLoopList = lists:keystore(WeaponId, #arbitrament_loop.weapon_id, LoopList, NArbitramentLoop),
							NArbitramentSt = ArbitramentSt#arbitrament_status{loop_list = NLoopList},
							NPS = PS#player_status{arbitrament_status = NArbitramentSt}
					end,
					{true, NPS, NewNo, NewScoreAdd};
				_ -> {false, ?MISSING_CONFIG}
			end
	end.

%% 转盘
loop_arbitrament(PS, WeaponId) ->
	#player_status{id = RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = _SkillFrom, arbitrament_list = ArbitramentList, loop_list = LoopList} = ArbitramentSt,
	Arbitrament = ulists:keyfind(WeaponId, #arbitrament.weapon_id, ArbitramentList, #arbitrament{weapon_id = WeaponId}),
	ArbitramentLoop = ulists:keyfind(WeaponId, #arbitrament_loop.weapon_id, LoopList, #arbitrament_loop{weapon_id = WeaponId}),
	case loop_arbitrament_helper(PS, Arbitrament, ArbitramentLoop) of 
		{true, PS1, Arbitrament1, ArbitramentLoop1, IsUp, No, ScoreAdd} ->
			{PS2, NArbitrament} = upgrade_arbitrament(PS1, Arbitrament1, IsUp),
			NPS = update_arbitrament_loop(PS2, ArbitramentLoop1),
			log_ugrade_arbitrament(RoleId, Arbitrament, NArbitrament, []),
			log_loop_arbitrament(RoleId, ArbitramentLoop, ArbitramentLoop1, ScoreAdd),
			db_replace_arbitrament(RoleId, NArbitrament),
			db_replace_arbitrament_loop(RoleId, ArbitramentLoop1),
			%?PRINT("active_arbitrament st ~p~n", [NPS#player_status.arbitrament_status]),
			{true, NPS, NArbitrament, ArbitramentLoop1, No, ScoreAdd};
		{false, Res} ->
			{false, Res}
	end.

loop_arbitrament_helper(PS, Arbitrament, ArbitramentLoop) ->
	#arbitrament_loop{loop_times = LoopTimes, utime = OUtime, loop_no = No, loop_score = ScoreAdd} = ArbitramentLoop,
	IsToday = utime:is_today(OUtime),
	case LoopTimes >= ?ARBITRAMENT_LOOP_TIMES_MAX andalso IsToday of 
		true -> {false, ?ERRCODE(err139_no_loop_times)};
		_ ->		
			case ScoreAdd > 0 of 
				true ->
					{NLoopTimes, NUTime} = ?IF(IsToday, {LoopTimes + 1, utime:unixtime()}, {1, utime:unixtime()}),
					Arbitrament1 = Arbitrament#arbitrament{score = Arbitrament#arbitrament.score + ScoreAdd},
					case active_arbitrament_helper(PS, Arbitrament1, auto) of 
						{true, PS1, NArbitrament, _} ->
							IsUp = NArbitrament#arbitrament.lv =/= Arbitrament1#arbitrament.lv,
							NArbitramentLoop = ArbitramentLoop#arbitrament_loop{loop_times = NLoopTimes, utime = NUTime, loop_no = 0, loop_score = 0},
							{true, PS1, NArbitrament, NArbitramentLoop, IsUp, No, ScoreAdd};
						{false, Res} ->
							{false, Res}
					end;
				_ -> {false, ?FAIL}
			end
	end.

%% 使用圣裁技能
equip_arbitrament(PS, WeaponId) ->
	#player_status{id = RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = SkillFrom, arbitrament_list = ArbitramentList} = ArbitramentSt,
	Arbitrament = lists:keyfind(WeaponId, #arbitrament.weapon_id, ArbitramentList),
	OArbitrament = lists:keyfind(SkillFrom, #arbitrament.weapon_id, ArbitramentList),
	if
	 	WeaponId == SkillFrom -> {false, ?ERRCODE(err139_had_equip)};
	 	Arbitrament == false -> {false, ?ERRCODE(err139_not_active)};
		true ->
			NArbitrament = Arbitrament#arbitrament{state = 1},
			ArbitramentList1 = lists:keystore(WeaponId, #arbitrament.weapon_id, ArbitramentList, NArbitrament),
			db_replace_arbitrament(RoleId, NArbitrament),
			case OArbitrament == false of 
				true ->
					NArbitramentList = ArbitramentList1;
				_ ->
					db_replace_arbitrament(RoleId, OArbitrament#arbitrament{state = 0}),
					NArbitramentList = lists:keystore(SkillFrom, #arbitrament.weapon_id, ArbitramentList1, OArbitrament#arbitrament{state = 0})
			end,
			PassiveSkills = get_all_passive_skill(WeaponId, NArbitramentList),
			NArbitramentSt = ArbitramentSt#arbitrament_status{skill_from = WeaponId, arbitrament_list = NArbitramentList, passive_skills = PassiveSkills},
			NPS = PS#player_status{arbitrament_status = NArbitramentSt},
			%?PRINT("equip_arbitrament st ~p~n", [NPS#player_status.arbitrament_status]),
			mod_scene_agent:update(NPS, [{passive_skill, PassiveSkills}]),
			{true, NPS}
	end.

%% 圣裁升级
upgrade_arbitrament(PS, Arbitrament, true) ->
	#player_status{id = _RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = SkillFrom, arbitrament_list = ArbitramentList} = ArbitramentSt,
	#arbitrament{weapon_id = WeaponId} = Arbitrament,
	NSkillFrom = ?IF(SkillFrom == 0, WeaponId, SkillFrom),
	NArbitrament = ?IF(SkillFrom == 0, Arbitrament#arbitrament{state = 1}, Arbitrament),
	NArbitramentList = lists:keystore(WeaponId, #arbitrament.weapon_id, ArbitramentList, NArbitrament),
	NArbitramentSt = ArbitramentSt#arbitrament_status{skill_from = NSkillFrom, arbitrament_list = NArbitramentList},
	NPS = PS#player_status{arbitrament_status = NArbitramentSt},
	lib_achievement_api:async_event(_RoleId, lib_achievement_api, upgrade_arbitrament_event, NArbitramentList),
	LastPS = count_arbitrament_attr(NPS, SkillFrom == NSkillFrom),
	{LastPS, NArbitrament};
upgrade_arbitrament(PS, Arbitrament, _) ->
	#player_status{id = _RoleId, arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{arbitrament_list = ArbitramentList} = ArbitramentSt,
	#arbitrament{weapon_id = WeaponId} = Arbitrament,
	NArbitramentList = lists:keystore(WeaponId, #arbitrament.weapon_id, ArbitramentList, Arbitrament),
	NArbitramentSt = ArbitramentSt#arbitrament_status{arbitrament_list = NArbitramentList},
	NPS = PS#player_status{arbitrament_status = NArbitramentSt},
	{NPS, Arbitrament}.

update_arbitrament_loop(PS, ArbitramentLoop) ->
	#player_status{arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{loop_list = LoopList} = ArbitramentSt,
	#arbitrament_loop{weapon_id = WeaponId} = ArbitramentLoop,
	NLoopList = lists:keystore(WeaponId, #arbitrament_loop.weapon_id, LoopList, ArbitramentLoop),
	NArbitramentSt = ArbitramentSt#arbitrament_status{loop_list = NLoopList},
	NPS = PS#player_status{arbitrament_status = NArbitramentSt},
	NPS.

%% db
db_replace_arbitrament(RoleId, Arbitrament) ->
	#arbitrament{weapon_id = WeaponId, lv = Lv, score = Score, state = State} = Arbitrament,
	Sql = usql:replace(arbitrament, [role_id, weapon_id, lv, score, state], [[RoleId, WeaponId, Lv, Score, State]]),
	db:execute(Sql).

db_replace_arbitrament_loop(RoleId, ArbitramentLoop) ->
	#arbitrament_loop{weapon_id = WeaponId, loop_times = LoopTimes, utime = UTime, loop_no = No, loop_score = ScoreAdd, open_max = OpenMax} = ArbitramentLoop,
	Sql = usql:replace(arbitrament_loop, [role_id, weapon_id, loop_times, utime, loop_no, loop_score, open_max], [[RoleId, WeaponId, LoopTimes, UTime, No, ScoreAdd, OpenMax]]),
	db:execute(Sql).

db_select_arbitrament_list(RoleId) ->
	Sql = usql:select(arbitrament, [weapon_id, lv, score, state], [{role_id, RoleId}]),
	db:get_all(Sql).

db_select_arbitrament_loop(RoleId) ->
	Sql = usql:select(arbitrament_loop, [weapon_id, loop_times, utime, loop_no, loop_score, open_max], [{role_id, RoleId}]),
	db:get_all(Sql).

count_arbitrament_attr(PS) ->
	count_arbitrament_attr(PS, true).

count_arbitrament_attr(PS, _SkillChange) ->	
	NPS = count_arbitrament_attr_do(PS),
	LPS = lib_player:count_player_attribute(NPS),
    lib_player:send_attribute_change_notify(LPS, ?NOTIFY_ATTR),
    PassiveSkills = LPS#player_status.arbitrament_status#arbitrament_status.passive_skills,
    mod_scene_agent:update(LPS, [{battle_attr, LPS#player_status.battle_attr}, {passive_skill, PassiveSkills}]),
    LPS.

count_arbitrament_attr_do(PS) ->
	#player_status{arbitrament_status = ArbitramentSt} = PS,
	#arbitrament_status{skill_from = SkillFrom, arbitrament_list = ArbitramentList} = ArbitramentSt,
	AttrList = get_all_arbitrament_attr(ArbitramentList),
	PassiveSkills = get_all_passive_skill(SkillFrom, ArbitramentList),
	NArbitramentSt = ArbitramentSt#arbitrament_status{attr_list = AttrList, passive_skills = PassiveSkills},
	NPS = PS#player_status{arbitrament_status = NArbitramentSt},
	NPS.

get_all_arbitrament_attr(ArbitramentList) ->
	F = fun(#arbitrament{weapon_id = WeaponId, lv = Lv}, L) ->
		case data_arbitrament:get(WeaponId, Lv) of 
			#base_arbitrament{attr = Attr} -> [Attr|L];
			_ -> L
		end
	end,
	AttrL = lists:foldl(F, [], ArbitramentList),
	lib_player_attr:add_attr(list, AttrL).

get_all_passive_skill(_SkillFrom, ArbitramentList) ->
	F = fun(#arbitrament{weapon_id = WeaponId, lv = Lv}, L) ->
		case data_arbitrament:get(WeaponId, Lv) of 
			#base_arbitrament{skill = Skill} -> Skill ++ L;
			_ -> L
		end
	end,
	lists:foldl(F, [], ArbitramentList).

loop_score(WeaponId, LoopTimes, OpenMax) ->
	List = data_arbitrament:get_loop_list(WeaponId),
	if 
		OpenMax > 0 -> 
			NList = [{No, Score, W} || {No, Score, W} <- List, Score < ?ARBITRAMENT_MAX_SCORE];
		LoopTimes == ?ARBITRAMENT_LOOP_TIMES_MAX - 1 -> 
			NList = [{No, Score, W} || {No, Score, W} <- List, Score >= ?ARBITRAMENT_MAX_SCORE];
		true -> NList = List
	end,
	case util:find_ratio(NList, 3) of 
		{No, Score, _} -> {No, Score};
		_ -> {0, 0}
	end.

log_ugrade_arbitrament(RoleId, Arbitrament, NArbitrament, Cost) ->
	#arbitrament{weapon_id = WeaponId, lv = OLv, score = OScore} = Arbitrament,
	#arbitrament{lv = NLv, score = NScore} = NArbitrament,
	lib_log_api:log_ugrade_arbitrament(RoleId, WeaponId, OLv, OScore, NLv, NScore, Cost),
	ok.

log_loop_arbitrament(RoleId, ArbitramentLoop, NArbitramentLoop, ScoreAdd) ->
	#arbitrament_loop{weapon_id = WeaponId, loop_times = OLoopTimes} = ArbitramentLoop,
	#arbitrament_loop{weapon_id = WeaponId, loop_times = NLoopTimes} = NArbitramentLoop,
	lib_log_api:log_loop_arbitrament(RoleId, WeaponId, OLoopTimes, NLoopTimes, ScoreAdd),
	ok.

gm_change_loop_score_to_goods() ->
	Sql = "select role_id, score from arbitrament where score > 0",
	case db:get_all(Sql) of 
		[] -> ok;
		List ->
			spawn(fun() -> gm_change_loop_score_to_goods_do(List) end),
			ok
	end.

gm_change_loop_score_to_goods_do(List) ->
	Title = utext:get(1390001),
	Content = utext:get(1390002),
	db:execute("update arbitrament set score = 0"),
	F = fun([RoleId, Score], Acc) ->
		Acc rem 50 == 0 andalso timer:sleep(1000),
		lib_mail_api:send_sys_mail([RoleId], Title, Content, [{?TYPE_GOODS, 58010030, Score}]),
		?PRINT("change_loop_score_to_goods ~p~n", [{RoleId, Score}]),
		Acc + 1
	end,
	lists:foldl(F, 1, List).