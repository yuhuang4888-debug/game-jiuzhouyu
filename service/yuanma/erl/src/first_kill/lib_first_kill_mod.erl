%%%-----------------------------------
%%% @Module      : lib_first_kill_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 15. 十月 2019 14:45
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_first_kill_mod).
-author("chenyiming").

-include("custom_act.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("first_kill.hrl").
%% API
-export([]).


init() ->
%%	OpenAct = lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_FIRST_KILL),
	List = db:get_all(io_lib:format(?sql_select_first_kill, [])),
	F = fun([SubType, SceneId, BossId, Status, KillerId, _KillerName], AccList) ->
		[#first_kill_act{boss_id = BossId, scene_id = SceneId,
			sub_type = SubType, status = Status, killer_id = KillerId, killer_name = binary_to_list(_KillerName)} | AccList]
	    end,
	ActList = lists:foldl(F, [], List),
	#first_kill_state{act_list = ActList}.

%%boss被杀
boss_be_killed(SubType, MonInfo, SceneId, _AtterId, Klist, State) ->
%%	?MYLOG("cym", "SceneId ~p~n", [SceneId]),
	%% 来到这个分支， 这个活动是一定开启中的
	#scene_mon{mid = MonCfgId} = MonInfo,
	#first_kill_state{act_list = ActList} = State,
	case lists:keyfind(SubType, #first_kill_act.sub_type, ActList) of
		#first_kill_act{status = ?yet_be_kill} ->  %%已经被击杀了
			State;
		#first_kill_act{status = ?not_be_kill, scene_id = SceneId, boss_id = MonCfgId} = Act -> %%没有被击杀，且场景和id都对的上
			{KillId, KillName} = get_kill(Klist),
			NewAct = Act#first_kill_act{status = ?yet_be_kill, scene_id = SceneId, boss_id = MonCfgId, sub_type = SubType,
				killer_id = KillId, killer_name = KillName},
			handle_first_kill(NewAct),
			NewActList = lists:keystore(SubType, #first_kill_act.sub_type, ActList, NewAct),
			State#first_kill_state{act_list = NewActList};
		#first_kill_act{} -> %% 容错分支
			State;
		_ -> %%没有保存活动的数据，从配置中获取数据
%%			?MYLOG("cym", "SceneId ~p~n", [SceneId]),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FIRST_KILL, SubType) of
				#custom_act_cfg{condition = Condition} ->  %%和配置一致
					{IsKill, Reward} = check_kill_boss(Condition, SceneId, MonCfgId),
					if
						IsKill == true ->
							{KillId, KillName} = get_kill(Klist),
							NewAct = #first_kill_act{status = ?yet_be_kill, scene_id = SceneId, boss_id = MonCfgId, sub_type = SubType,
								killer_id = KillId, killer_name = KillName, reward = Reward},
							handle_first_kill(NewAct),
							NewActList = lists:keystore(SubType, #first_kill_act.sub_type, ActList, NewAct),
							State#first_kill_state{act_list = NewActList};
						true ->
							State
					end;
				_ -> %% 不一致
					State
			end
	end.


get_kill([]) -> %% 容错
	{0, ""};
get_kill(KList) ->
	SortF = fun(A, B) ->
		A#mon_atter.hurt > B#mon_atter.hurt
	        end,
	SortList = lists:sort(SortF, KList),
	#mon_atter{id = RoleId, name = Name} = hd(SortList),
	{RoleId, Name}.


handle_first_kill(Act) ->
	#first_kill_act{sub_type = SubType, killer_id = RoleId, boss_id = BossId, reward = Reward, killer_name = Name} = Act,
	save_to_db(Act),
	%% 发送邮件
	Title = utext:get(3310069),
	Content = utext:get(3310070),
	lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
	%% 发送传闻
	lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 51, [Name]),
	%% 日志
	lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_FIRST_KILL, SubType, BossId, Reward).


get_info(SubType, RoleId, State) ->
%%	?MYLOG("cym", "State ~p~n", [State]),
	#first_kill_state{act_list = ActList} = State,
	case lists:keyfind(SubType, #first_kill_act.sub_type, ActList) of
		#first_kill_act{killer_id = KillId, killer_name = Name, status = Status} ->
%%			?MYLOG("cym", "State 33223 ~p~n", [{?SUCCESS, Status, KillId, Name}]),
			{ok, Bin} = pt_332:write(33223, [?SUCCESS, Status, KillId, Name]),
			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
%%			?MYLOG("cym", "State 33223 ~p~n", [{?SUCCESS, ?not_be_kill, 0, ""}]),
			{ok, Bin} = pt_332:write(33223, [?SUCCESS, ?not_be_kill, 0, ""]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end.


check_kill_boss(Condition, SceneId, MonCfgId) ->
	case lists:keyfind(kill_msg, 1, Condition) of
		{kill_msg, SceneId, MonCfgId, Reward} ->
			{true, Reward};
		_ ->
			false
	end.


clear_act(SubType, State) ->
	#first_kill_state{act_list = ActList} = State,
	NewActList = lists:keydelete(SubType, #first_kill_act.sub_type, ActList),
	delete_act(SubType),
	#first_kill_state{act_list = NewActList}.


save_to_db(Act) ->
	#first_kill_act{sub_type = SubType, boss_id = BossId, killer_id = KillId, killer_name = KillName, status = Status, scene_id = SceneId} = Act,
	Sql = io_lib:format(?sql_save_first_kill, [SubType, SceneId, BossId, Status, KillId, util:fix_sql_str(KillName)]),
	db:execute(Sql).


delete_act(SubType) ->
	Sql = io_lib:format(?sql_delete_first_kill, [SubType]),
	db:execute(Sql).




























































