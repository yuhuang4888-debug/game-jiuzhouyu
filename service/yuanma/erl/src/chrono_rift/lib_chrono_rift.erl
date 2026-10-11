%%%-----------------------------------
%%% @Module      : lib_kf_chrono_rift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 27. 十一月 2019 15:20
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_chrono_rift).
-author("carlos").
-include("chrono_rift.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
%% API

-export([]).


add_scramble_value(RoleId, RoleName, CastleId, AddValue, NewScrambelValue, TodayValue, Mod, SubMod, Count, NewCount) ->
	Role =
		#rank_role_msg{
			role_id = RoleId
			, role_name = RoleName
			, server_id = config:get_server_id()
			, server_num = config:get_server_num()
			, server_name = util:get_server_name()
			, scramble_value = NewScrambelValue
		},
	mod_common_rank:add_scramble_value(RoleId, RoleName, CastleId, AddValue, NewScrambelValue - AddValue, TodayValue, Mod, SubMod, Count, NewCount),
	mod_clusters_node:apply_cast(mod_kf_chrono_rift_scramble_rank, set_role_scramble_value, [Role, NewScrambelValue]).


get_scramble_value_with_ratio(Value, Rank) ->
	Ratio = data_chrono_rift:get_rank_ratio(Rank),
%%	?MYLOG("chrono", "Ratio ~p  Value ~p, Rank ~p ~n", [Ratio, Value, Rank]),
	trunc(Value * Ratio / 100).



update_local_role_castle_id(RoleId, CastleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_chrono_rift, update_local_role_castle_id2, [CastleId]).




update_local_role_castle_id2(PS, CastleId) ->
	#player_status{chrono_rift = ChronoRift, id = RoleId} = PS,
	case ChronoRift of
		#chrono_rift_in_ps{} ->
			NewChronoRift = ChronoRift#chrono_rift_in_ps{castle_id = CastleId},
            lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
			PS#player_status{chrono_rift = NewChronoRift};
		_ ->
			PS
	end.



finish_goal(RoleId, GoalId, Type) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_chrono_rift, finish_goal2, [GoalId, Type]).




finish_goal2(PS, GoalId, Type) ->
	?MYLOG("chrono", "GoalId ~p, Type ~p~n", [GoalId, Type]),
	#player_status{chrono_rift = ChronoRift, id = RoleId} = PS,
	#chrono_rift_in_ps{season_reward = List} = ChronoRift,
	Reward = data_chrono_rift:get_goal_reward(GoalId),
	lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = chrono_rift_goal_reward}),
	NewList = lists:keystore(Type, 1, List, {Type, 2}),
	NewChronoRift = ChronoRift#chrono_rift_in_ps{season_reward = NewList},
	%% log
	lib_log_api:log_chrono_rift_goal_reward(RoleId, GoalId, Reward),
    lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
	{ok, Bin} = pt_204:write(20408, [GoalId, ?SUCCESS]),
	lib_server_send:send_to_uid(RoleId, Bin),
	PS#player_status{chrono_rift = NewChronoRift}.






send_occupy_castle_reward(Lv1N, Lv2N, Lv3N, Lv4N, Lv5N, Reward) ->
%%	?PRINT("send_occupy_castle_reward ~p~n", [Reward]),
	LvLimit = ?CR_ROLE_LV,
	Sql = io_lib:format(<<"select  a.id from  player_low a  LEFT JOIN player_login b on a.id = b.id where a.lv > ~p   and   b.last_login_time + ~p >unix_timestamp(now())">>, [LvLimit, 60 * 60 * 24 * 30]),
	RoleIds = db:get_all(Sql),
	Title = utext:get(2040001),
	Content = utext:get(2040002, [Lv1N, Lv2N, Lv3N, Lv4N, Lv5N]),
	[begin
%%		 timer:sleep(100),
	     util:multiserver_delay(1),
		 lib_log_api:log_chrono_rift_castle_reward(RoleId, [Lv1N, Lv2N, Lv3N, Lv4N, Lv5N], Reward),
		 lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
	 end
		|| [RoleId] <- RoleIds].



act_end() ->
	%%
	Day = utime:day_of_month(),
	if
		Day == 16 orelse Day == 1 ->  %% 赛季清理
			spawn(fun()->
				timer:sleep(15  * 1000),  %% 15秒后清空数据，---- 跨服10秒后结算，防止报错做的本服数据处理
				Sql = io_lib:format("truncate  chrono_rift_role", []),
%%				?MYLOG("cym", "+++++++++++++++  ~n", []),
				db:execute(Sql),
				OnlineList = ets:tab2list(?ETS_ONLINE),
				IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
				[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_chrono_rift, act_end, []) || RoleId <- IdList]
			end);
		true ->
%%			?MYLOG("cym", "+++++++++++++++  ~n", []),
			skip
	end.



act_end(PS) ->
	%%
	NewPs = PS#player_status{chrono_rift = #chrono_rift_in_ps{}},
	pp_chrono_rift:handle(20410, NewPs, []),
	pp_chrono_rift:handle(20401, NewPs, []),
	pp_chrono_rift:handle(20405, NewPs, []),
	pp_chrono_rift:handle(20407, NewPs, []),
	NewPs.



update_castle_msg_to_local(CastleId) ->
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_chrono_rift, update_castle_msg_to_local, [CastleId]) || RoleId <- IdList].


update_castle_msg_to_local(PS, CastleId) ->
	#player_status{figure = F} = PS,
	#figure{lv = Lv} = F,
	LvLimit = ?CR_ROLE_LV,
	if
		Lv >= LvLimit ->
			pp_chrono_rift:handle(20402, PS, [CastleId]);
		true ->
			skip
	end,
	PS.


handle_cmd(Cmd, Arg) ->
%%	?MYLOG("chrono", "cmd ~p, Arg ~p~n", [Cmd, Arg]),
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_chrono_rift, handle_cmd, [Cmd, Arg]) || RoleId <- IdList].


handle_cmd(PS, Cmd, Arg) ->
%%	?MYLOG("chrono", "cmd ~p, Arg ~p~n", [Cmd, Arg]),
	#player_status{figure = F} = PS,
	#figure{lv = Lv} = F,
	LvLimit = ?CR_ROLE_LV,
	if
		Lv >= LvLimit ->
			pp_chrono_rift:handle(Cmd, PS, Arg);
		true ->
			skip
	end,
	PS.


handle_act_end_goal_list(GoalList, Rank) ->
	%%
%%	Sql = io_lib:format("DELETE from  chrono_rift_role", []),
%%	db:execute(Sql),
%%	?MYLOG("cym", "+++++++++++++++  ~n", []),
	F = fun({GoalType, _DefaultV}, AccList) ->
		GoalId = lib_kf_chrono_rift:get_goal_id_by_type_rank(GoalType, Rank),
		case lists:keyfind(GoalType, 1, GoalList) of
			{_, V} ->
				%%
				NeedValue = data_chrono_rift:get_goal_value(GoalId),
				[{GoalId, GoalType, ?IF(V >= NeedValue, 1, 0)} | AccList];  %% 1 可以领取  0 ， 不能领取
			_ ->
				[{GoalId, GoalType, 0} | AccList]
		end
	    end,
	NewGoalList = lists:foldl(F, [], ?goal_default_list), %% [{GoalId, Type, Value}]
	Sql1 =  io_lib:format(<<"select   role_id  from   chrono_rift_role ">>, []),
	IdList = db:get_all(Sql1),
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_chrono_rift, handle_act_end_goal_list2, [NewGoalList]) || [RoleId] <- IdList].

%% -----------------------------------------------------------------
%% @desc     功能描述  处理赛季结束玩家没有领取目标奖励
%% @param    参数     GoalList [{GoalId, Type, Value}]
%% @return   返回值   NewPS
%% @history  修改历史
%% -----------------------------------------------------------------
handle_act_end_goal_list2(_PS, GoalList) ->
	PS = lib_local_chrono_rift_act:day_trigger(_PS),
	#player_status{chrono_rift = ChronoRift, id = RoleId} = PS,
	#chrono_rift_in_ps{season_reward = SeasonList} = ChronoRift,
	F = fun({GoalId, Type, GoalStatus}, AccRewardList) ->
		if
			GoalStatus == 1 ->  %%可以领取
				case lists:keyfind(Type, 1, SeasonList) of
					{_, 2} -> %已经领取了
						AccRewardList;
					_ ->
						Reward = data_chrono_rift:get_goal_reward(GoalId),
						Reward ++ AccRewardList
				end;
			true -> %% 不能领取
				AccRewardList
		end
	end,
	GoalReward = lists:foldl(F, [], GoalList),
	Title = utext:get(2040007),
	Content = utext:get(2040008),
	?IF(GoalReward =/= [], lib_mail_api:send_sys_mail([RoleId], Title, Content, GoalReward), skip),
	%%赛季结束的处理
	NewPs = PS#player_status{chrono_rift = #chrono_rift_in_ps{}},
    lib_chrono_rift_data:db_save_status_role(RoleId, NewPs#player_status.chrono_rift),
	pp_chrono_rift:handle(20410, NewPs, []),
	pp_chrono_rift:handle(20401, NewPs, []),
	pp_chrono_rift:handle(20405, NewPs, []),
	pp_chrono_rift:handle(20407, NewPs, []),
	NewPs.



gm_repair_scramble_value(Time) ->
	Sql1 =  io_lib:format(<<"select   role_id  from   chrono_rift_role ">>, []),
	Ids = db:get_all(Sql1),
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_chrono_rift, gm_repair_scramble_value, [Time])
		||[RoleId] <-Ids].



gm_repair_scramble_value(PS, Time) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift, figure = Figure} = PS,
	Sql1 =  io_lib:format(<<"select  add_value, curr_day_value from   log_chrono_rift_act  where   role_id = ~p and   time >  ~p">>, [PS#player_status.id, Time]),
	Values = db:get_all(Sql1),
	F = fun([Value, Value2], AccValue) ->
		AccValue + max((Value - Value2), 0)
		end,
	AllValue = lists:foldl(F, 0, Values),
	Role =
		#rank_role_msg{
			role_id = RoleId
			, role_name = Figure#figure.name
			, server_id = config:get_server_id()
			, server_num = config:get_server_num()
			, server_name = util:get_server_name()
			, scramble_value = AllValue
		},
	mod_clusters_node:apply_cast(mod_kf_chrono_rift_scramble_rank, set_role_scramble_value, [Role, AllValue]),
	NewChronoRift = ChronoRift#chrono_rift_in_ps{scramble_value = AllValue},
    lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
	PS#player_status{chrono_rift = NewChronoRift}.


add_scramble_value_only(RoleId, ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_chrono_rift, add_scramble_value_only2, [ValueWithoutRatio, Mod, SubMod, Count, NewCount, Ratio]).


add_scramble_value_only2(PS, AddValue, Mod, SubMod, Count, NewCount, Ratio) ->
	#player_status{chrono_rift = ChronoRift, id = RoleId} = PS,
	#chrono_rift_in_ps{act_list = ActList, today_value = OldTodayValue, scramble_value = ScrambleValue} = ChronoRift,
	%%log
	lib_log_api:log_chrono_rift_act(RoleId, Mod, SubMod, Count,  OldTodayValue + AddValue, OldTodayValue, ScrambleValue + AddValue, Ratio),
	NewActList = lists:keystore({Mod, SubMod}, 1, ActList, {{Mod, SubMod}, NewCount}),
	NewChronoRift =
	ChronoRift#chrono_rift_in_ps{act_list = NewActList,
	today_value = OldTodayValue + AddValue, scramble_value = ScrambleValue + AddValue},
	lib_task_api:chrono_value(PS, ScrambleValue + AddValue),
    lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
	%% 推送05协议
	NewPS = PS#player_status{chrono_rift = NewChronoRift},
	pp_chrono_rift:handle(20405, NewPS, []),
	NewPS.


gm_force_change_castle_id(RoleId, CastleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_chrono_rift, gm_force_change_castle_id_help, [CastleId]).


gm_force_change_castle_id_help(PS, CastleId) ->
	#player_status{chrono_rift = ChronoRift, server_id = ServerId, id = RoleId, figure = F} = PS,
	case ChronoRift of
		#chrono_rift_in_ps{castle_id = OldCastleId} ->
			Role = #castle_role_msg{
				role_id = RoleId
				, role_name = F#figure.name
				, castle_id = OldCastleId
				, server_name = util:get_server_name()
				, server_id = config:get_server_id()
				, server_num = config:get_server_num()
				, is_occupy = 1
			},
			mod_clusters_node:apply_cast(mod_kf_chrono_rift, gm_force_change_castle_id, [ServerId, Role, OldCastleId, CastleId]),
			PS;
		_ ->
			PS
	end.



%% 秘籍，补发给没领取到排名结算奖励的玩家(跨服中心执行)
gm_send_reward(StartTime, EndTime) ->
	Sql = io_lib:format(<<"select  role_id, server_id, reward, rank  from   log_chrono_rift_rank_reward where time > ~p and time < ~p">>, [StartTime, EndTime]),
	DbData = db:get_all(Sql),
	F = fun([RoleId, ServerId, Reward, Rank], FunRoleMap) ->
		RoleList = maps:get(ServerId, FunRoleMap, []),
		NewRoleList = lists:keystore(RoleId, 1, RoleList, {RoleId, util:bitstring_to_term(Reward), Rank}),
		maps:put(ServerId, NewRoleList, FunRoleMap)
	    end,
	RoleMap = lists:foldl(F, #{}, DbData),
	F2 = fun({ServerId, FunRoleList}) ->
		mod_clusters_center:apply_cast(ServerId, ?MODULE, gm_send_reward_local, [FunRoleList, StartTime, EndTime])
	     end,
	lists:foreach(F2, maps:to_list(RoleMap)).

%% 本服发送奖励
gm_send_reward_local(RoleList, StartTime, EndTime) ->
	F = fun({RoleId, Reward, Rank}) ->
		timer:sleep(200),
		Title = utext:get(2040003),
		Content = utext:get(2040004, [Rank]),
		MailAttrSql = io_lib:format(<<"select id from mail_attr where rid = ~p and title = '~s' and timestamp > ~p and timestamp < ~p">>, [RoleId, ulists:list_to_bin(Title), StartTime * 1000000, EndTime * 1000000]),
		case db:get_all(MailAttrSql) of
			[] ->
				LogMailGetSql = io_lib:format(<<"select id from log_mail_get where rid = ~p and title = '~s' and timestamp > ~p">>, [RoleId, ulists:list_to_bin(Title), StartTime * 1000000]),
				case db:get_all(LogMailGetSql) of
					[] ->
						Send = true;
					[_Id|_] -> Send = false;
					_ -> Send = false
				end;
			[_MailId|_] -> Send = false;
			_ -> Send = false
		end,
		if
			Send =:= true ->
%%				?MYLOG("mail", "send ++++++++++++++  RoleId ~p~n", [RoleId]),
				lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
			true ->
%%				?MYLOG("mail", "not send ++++++++++++++ ~n", []),
				skip
		end
	    end,
	lists:foreach(F, RoleList).

%% -----------------------------------------------------------------
%% @desc     功能描述   发送排行榜奖励
%% @param    参数      List :: [{RoleId, Title, Content, Reward}...]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_rank_reward(List) ->
%%	mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward])
	[begin
		 util:multiserver_delay(1),
		 lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
	 end
		||{RoleId, Title, Content, Reward} <-List].