%%%-----------------------------------
%%% @Module      : lib_up_power_rank_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 04. 六月 2020 17:55
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_up_power_rank_mod).
-author("carlos").

%% API
-export([]).


-include("errcode.hrl").
-include("language.hrl").
-include("up_power_rank.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("record.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("def_fun.hrl").

make_record(up_power_rank, [SubType, RoleId, Value, Time]) ->
	#up_power_rush_rank_role{
		role_key = {SubType, RoleId},
		rank_type = SubType,
		sub_type = SubType,
		role_id = RoleId,
		value = Value,
		time = Time
	}.

init() ->
	%% 个人榜单
	List = db_rush_rank_role_select(),
	RoleList = [make_record(up_power_rank, T) || T <- List],
	RankMaps = get_standard_sort_rank_maps(up_power_rank, RoleList),  %%排好序，长度也截取了
	#up_power_rush_rank_state{rank_maps = RankMaps}.

%% -----------------------------------------------------------------
%% @desc     功能描述    获得标准排序Maps(被截取了长度) Key:{RankType,subType}  Value:[#rush_rank_role{}]
%% @param    参数       RoleList::lists   [#rush_rank_role]
%% @return   返回值     #{{RankType, SubType} => [#rush_rank_role]}
%% @history  修改历史
%% -----------------------------------------------------------------
get_standard_sort_rank_maps(up_power_rank, RoleList) ->
	MapsKeyList = get_sort_rank_maps(up_power_rank, RoleList), %%排序后的list
	F = fun({SubType, RankList}) ->
		MaxRankLen = lib_up_power:get_max_len(SubType),
		NewRankList = lists:sublist(RankList, MaxRankLen),
		{SubType, NewRankList}
	    end,
	NewKeyList = lists:map(F, MapsKeyList),   %%截取了长度的list
	NewMaps = maps:from_list(NewKeyList),     %%从list变为了map
	NewMaps.

%% 分类到Maps,然后对Maps的Value排序 Key:RankType Value:[#rush_rank_role{}] 返回  [{SubType, [#run_rank_role]}]
get_sort_rank_maps(up_power_rank, RoleList) ->
	F = fun(#up_power_rush_rank_role{rank_type = _RankType, sub_type = SubType} = RankRole, Maps) ->
		case maps:get(SubType, Maps, false) of
			false ->
				NewList = [RankRole];
			List ->
				NewList = [RankRole | List]
		end,
		maps:put(SubType, NewList, Maps)
	    end,
	Maps = lists:foldl(F, maps:new(), RoleList),  %%  根据#{SubType => RoleList}
	NewKeyList = sort_rank_maps(Maps),            %%
	NewKeyList.

%% 对Maps的Value排序 结果 [{SubType, [#run_rank_role]}]
sort_rank_maps(Maps) ->
	MapsKeyList = maps:to_list(Maps),
	F = fun({SubType, List}) ->
		RankList = sort_rank_list(List, SubType),
		{SubType, RankList}
	    end,
	NewKeyList = lists:map(F, MapsKeyList),
	NewKeyList.
%%列表里的排序
sort_rank_list(List, SubType) ->
	F = fun(A, B) ->
		if
			is_record(A, up_power_rush_rank_role) ->
				if
					A#up_power_rush_rank_role.value > B#up_power_rush_rank_role.value ->
						true;
					A#up_power_rush_rank_role.value == B#up_power_rush_rank_role.value ->
						A#up_power_rush_rank_role.time =< B#up_power_rush_rank_role.time;
					true ->
						false
				end;
			true ->
				false
		end
	    end,
	NewList = lists:sort(F, List),
	%%
	RankStageList = lib_up_power:get_rank_stage_list(SubType),
	F1 = fun(Member, {TempList, Value}) ->
		if
			is_record(Member, up_power_rush_rank_role) ->
				NewRank = lib_up_power:get_right_rank(RankStageList, Value, Member#up_power_rush_rank_role.value),
				NewMember = Member#up_power_rush_rank_role{rank = NewRank},
				NewTempList = [NewMember | TempList],
				{NewTempList, NewRank};
			true ->
				{TempList, Value}
		end
	     end,
	{TmpRankList, _} = lists:foldl(F1, {[], 0}, NewList),
	lists:reverse(TmpRankList).

%%%% 清理数据库的冗余数据,防止数据过多, 更新Limit值
%%clean_redundant_rank_data_from_db(RankMaps) ->
%%	MapsKeyList = maps:to_list(RankMaps),
%%	F = fun({{RankType, SubType}, []}) ->
%%		Limit = lib_rush_rank:get_rank_limit(RankType),
%%		{{RankType, SubType}, Limit};   %%这种格式
%%	       ({{RankType, SubType}, RankList}) ->
%%		       Limit = lib_rush_rank:get_rank_limit(RankType),
%%		       RankMax = lib_rush_rank:get_max_len(RankType),
%%		       case length(RankList) >= RankMax of
%%			       true ->
%%				       #rush_rank_role{value = Value} = lists:last(RankList),
%%				       db_rush_rank_delete_by_value(RankType, SubType, Value),
%%				       {{RankType, SubType}, max(Value, Limit)};
%%			       false ->
%%				       {{RankType, SubType}, Limit}
%%		       end
%%	    end,
%%	lists:map(F, MapsKeyList).

%%%% @param [{RankType, RushRankRole}]
%%refresh_rush_rank_by_list(State, List) ->
%%	%?PRINT("~p~n", [List]),
%%	F = fun({{RankType, SubType}, CommonRank}, TmpState) ->
%%		{ok, NewTmpState} = refresh_rush_rank(TmpState, RankType, SubType, CommonRank),
%%		NewTmpState
%%	    end,
%%	NewState = lists:foldl(F, State, List),
%%	{ok, NewState}.

%% 刷新榜单
refresh_rush_rank(State, SubType, RushRankRole) ->
	#up_power_rush_rank_state{
		rank_maps = RankMaps
	} = State,
%%	#up_power_rush_rank_role{
%%		role_id = _RoleId,
%%		value = _Value
%%	} = RushRankRole,
	RankList = maps:get(SubType, RankMaps, []),
	NewRankList = do_refresh_rush_rank_help(RankList, SubType, RushRankRole),
	%%修正状态
	NewRankMaps = maps:put(SubType, NewRankList, RankMaps),
	NewState = State#up_power_rush_rank_state{rank_maps = NewRankMaps},
	{ok, NewState}.


%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送、
do_refresh_rush_rank_help(RankList, SubType, RushRankRole) ->
	#up_power_rush_rank_role{role_key = RoleKey, value = Value} = RushRankRole,
	case lists:keyfind(RoleKey, #up_power_rush_rank_role.role_key, RankList) of
		#up_power_rush_rank_role{value = OldValue} when Value =< OldValue ->  %%更新后，值比原来的还小，保留最大值
			RankList;
		_ ->
			do_refresh_rush_rank_help2(RankList, SubType, RushRankRole)
	end.

do_refresh_rush_rank_help2(RankList, SubType, RushRankRole) ->
	MaxRankLen = lib_up_power:get_max_len(SubType),  %%最大长度
	Limit = lib_up_power:get_rank_limit(SubType),    %%上榜阀值
	LastValue = Limit,
	case RankList == [] of
		true ->
			if
				RushRankRole#up_power_rush_rank_role.value >= LastValue ->  %%即使是空榜，也要达到阀值才能上榜
					db_rush_rank_role_save(RushRankRole),
					NewRankList2 = [RushRankRole#up_power_rush_rank_role{rank = 1}],  %%上榜且第一
					NewRankList2;
				true ->  %%未达到阀值，未能上榜
					NewRankList2 = [],
					NewRankList2
			end;
		false ->
			IsExistKey = lists:keymember(RushRankRole#up_power_rush_rank_role.role_key, #up_power_rush_rank_role.role_key, RankList),
			#up_power_rush_rank_role{role_key = RoleKey, value = Value} = RushRankRole,
			%% 是否需要排序
			case Value < LastValue andalso (not IsExistKey) of
				true ->  %%未能上榜
					NewRankList2 = RankList,
					NewRankList2;
				false -> %%可以上榜，重新排序， 修正内存数据，同步数据库
					%% 内存和数据库存储
					NewRankList = lists:keystore(RoleKey, #up_power_rush_rank_role.role_key, RankList, RushRankRole),
					db_rush_rank_role_save(RushRankRole),
					%% 排序
					NewRankList2 = sort_rank_list(NewRankList, SubType),
					case length(NewRankList2) > MaxRankLen of
						true ->
							LeftRankList = lists:nthtail(MaxRankLen, NewRankList2); %%后面的元素
						false ->
							LeftRankList = []
					end,
					%% 清理冗余数据,这样修改插入数据效率会提高-----就是删除被挤下来的数据
					TmpRoleIds = [TmpRoleId || #up_power_rush_rank_role{role_id = TmpRoleId} <- LeftRankList],
					db_rush_rank_delete_by_ids(SubType, TmpRoleIds),  %% todo 记得测试
					%% 返回数据
					LastList = lists:sublist(NewRankList2, MaxRankLen),  %%截取长度
					LastList
			end
	end.




%% 发送排行榜
send_rank_list(State, SubType, RoleId, SelValue) ->
	#up_power_rush_rank_state{rank_maps = RankMaps} = State,
	RankList = maps:get(SubType, RankMaps, []),
	MaxRankLen = lib_up_power:get_max_len(SubType), %%榜单长度
	Limit = lib_up_power:get_rank_limit(SubType),   %%阀值
	SubRankList = lists:sublist(RankList, MaxRankLen),%%截取
	List1 = [RushRole || RushRole <- SubRankList, RushRole#up_power_rush_rank_role.value >= Limit],
	F = fun(#up_power_rush_rank_role{role_id = TmpRoleId, value = Value, rank = Rank}) ->
		case lib_role:get_role_show(TmpRoleId) of
			[] ->
				Figure = #figure{};
			#ets_role_show{figure = Figure} ->
				skip
		end,
		{TmpRoleId, Figure#figure.name, Value, Rank}
	    end,
	List = lists:map(F, List1),
	%%结算时间
	Sum = length(List),
	if
		Sum == 0 ->  %%空榜
			{ok, BinData} = pt_226:write(22601, [SubType, 0, SelValue, []]),
			lib_server_send:send_to_uid(RoleId, BinData);
		true ->
			case lists:keyfind({SubType, RoleId}, #up_power_rush_rank_role.role_key, List1) of
				#up_power_rush_rank_role{rank = RoleRank} ->
					skip;  %%玩家在榜
				_ ->
					RoleRank = 0
			end,
			?PRINT("List ~p~n", [List]),
			{ok, BinData} = pt_226:write(22601, [SubType, RoleRank, SelValue, List]),
			lib_server_send:send_to_uid(RoleId, BinData)
	end.


apply_cast(State, M, F, A) ->
	M:F(State, A).




%%	#rush_rank_state{rank_maps = RankMaps} = State,
%%	#base_rush_rank{name = RankTypeName} = data_rush_rank:get_rush_rank_cfg(RankType),
%%	SubType = 1,  %%开服冲榜就一个子类型
%%	NewRankList =
%%		case maps:get({RankType, SubType}, RankMaps, []) of
%%			[] ->
%%%%				?DEBUG("log1 ~n", []),
%%				[];
%%			RankList ->
%%%%				?DEBUG("log2 ~n", []),
%%
%%				Title = uio:format(?LAN_MSG(279), [RankTypeName]),  %%
%%				do_send_reward(RankList, RankType, RankTypeName, Title, 1),
%%				[X#rush_rank_role{get_reward_status = ?FINISH} || X <- RankList]
%%		end,
%%%%	[send_goal_list(State, SubType, OnlineRole#ets_online.id) || OnlineRole <- ets:tab2list(?ETS_ONLINE)],
%%	NewRankMap = maps:put({RankType, SubType}, NewRankList, RankMaps),
%%	%%同步数据库
%%%%	Sql = io_lib:format(?slq_rush_rank_role_update_rewardStatus, [?FINISH, RankType, SubType]),
%%%%	db:execute(Sql),
%%	{ok, State#rush_rank_state{rank_maps = NewRankMap}}.




%%
%%do_send_reward([], _RankType, _RankTypeName, _Title, _Count) ->
%%	skip;
%%do_send_reward([#rush_rank_role{role_id = RoleId, rank = Rank, value = Value, get_reward_status = ?HAVE_REWARD} | RankList], RankType, Name, Title, Count) ->  %%只有可领取的才能发送邮件
%%	?DEBUG("RankType ~p ~n", [RankType]),
%%	case lib_role:get_role_show(RoleId) of
%%		[] ->
%%			?ERR("rush rank can not find role info :~p~n", [RoleId]),
%%			do_send_reward(RankList, RankType, Name, Title, Count);
%%		#ets_role_show{figure = #figure{sex = Sex, name = _RoleName}} ->
%%			case lib_rush_rank:get_rank_reward(RankType, Rank, Sex) of %% 奖励根据性别有区别
%%				[] ->
%%					?ERR("rush rank can not find reward :~p~n", [[RankType, Rank, Sex]]),
%%					do_send_reward(RankList, RankType, Name, Title, Count);
%%				Reward ->
%%					if
%%						Count rem 20 == 0 ->
%%							timer:sleep(500);
%%						true ->
%%							skip
%%					end,
%%%%					if
%%%%						Rank =/= 1 ->
%%%%							skip;
%%%%						true ->
%%%%							lib_chat:send_TV({all}, ?MOD_RUSH_RANK, 1, [RoleName, Name])
%%%%					end,
%%					Content = uio:format(?LAN_MSG(280), [Name, Rank]),
%%					?DEBUG("RoleId ~p ~n Reward ~p ~n", [RoleId, Reward]),
%%					lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
%%					%% 日志
%%					lib_log_api:log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward),
%%					do_send_reward(RankList, RankType, Name, Title, Count + 1)
%%			end
%%	end;
%%do_send_reward([_ | RankList], RankType, Name, Title, Count) ->
%%	do_send_reward(RankList, RankType, Name, Title, Count).



%%set_reward([], _RankType, _RankTypeName, _Title, _Count) ->
%%	skip;
%%set_reward([#rush_rank_role{role_id = RoleId, rank = Rank, value = Value} | RankList], RankType, Name, Title, Count) ->
%%	case lib_role:get_role_show(RoleId) of
%%		[] ->
%%			?ERR("rush rank can not find role info :~p~n", [RoleId]),
%%			do_send_reward(RankList, RankType, Name, Title, Count);
%%		#ets_role_show{figure = #figure{sex = Sex, name = RoleName}} ->
%%			case lib_rush_rank:get_rank_reward(RankType, Rank, Sex) of %% 奖励根据性别有区别
%%				[] ->
%%					?ERR("rush rank can not find reward :~p~n", [[RankType, Rank, Sex]]),
%%					do_send_reward(RankList, RankType, Name, Title, Count);
%%				Reward ->
%%					if
%%						Count rem 20 == 0 ->
%%							timer:sleep(500);
%%						true ->
%%							skip
%%					end,
%%					if
%%						Rank =/= 1 ->
%%							skip;
%%						true ->
%%							lib_chat:send_TV({all}, ?MOD_RUSH_RANK, 1, [RoleName, Name])
%%					end,
%%					Content = uio:format(?LAN_MSG(280), [Name, Rank]),
%%					lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
%%					%% 日志
%%					lib_log_api:log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward),
%%					do_send_reward(RankList, RankType, Name, Title, Count + 1)
%%			end
%%	end;
%%set_reward([R | _RankList], RankType, _Name, _Title, _Count) ->
%%	?ERR("rush rank back data:~p,~nrank_type:~p~n", [R, RankType]),
%%	skip.


%%----------------db-----------------------%%
db_rush_rank_role_select() ->
	Sql = io_lib:format(?sql_up_power_role_select, []),
	db:get_all(Sql).

%%db_rush_rank_goal_select() ->
%%	Sql = io_lib:format(?sql_rush_rank_goal_select, []),
%%	db:get_all(Sql).



%%
db_rush_rank_role_save(RankRole) ->
	#up_power_rush_rank_role{
		sub_type = SubType,
		role_id = RoleId,
		value = Value,
		time = Time
	} = RankRole,
	Sql = io_lib:format(?sql_up_power_role_save, [SubType, RoleId, Value, Time]),
	db:execute(Sql).



db_rush_rank_delete_by_id(RankType, SubType, RoleId) ->
	Sql = io_lib:format(?sql_up_power_role_delete_by_role_id, [RankType, SubType, RoleId]),
	db:execute(Sql).

db_rush_rank_delete_by_ids(_SubType, []) -> skip;
db_rush_rank_delete_by_ids(SubType, RoleIds) ->
	Condition = usql:condition({player_id, in, RoleIds}),
	Sql = io_lib:format(?sql_up_power_role_delete_by_role_ids, [Condition, SubType]),
	db:execute(Sql).

%%db_rush_rank_delete_by_value(RankType, SubType, Value) ->
%%	Sql = io_lib:format(?sql_rush_rank_role_delete_by_value, [RankType, SubType, Value]),
%%	db:execute(Sql).

%%gm_send_rewards(State, SubType) ->
%%	#rush_rank_state{rank_maps = RankMaps} = State,
%%	F = fun(RankType) ->
%%		case maps:get({RankType, SubType}, RankMaps, []) of
%%			[] ->
%%				?ERR("rushrank_gm_rewards nothing ~n", []);
%%			RankList ->
%%				case lists:keyfind(1, #rush_rank_role.rank, RankList) of
%%					#rush_rank_role{role_id = RoleId} ->
%%						Title = "开服冲榜补偿",
%%						Content = "亲爱的骑士大人，公主阁下决定提高开服冲榜的奖励力度，经查阅资料确认，可以给您补发以下奖励，敬请查收！",
%%						RewardList = get_gm_rewards(RankType),
%%						lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
%%						?ERR("rush_rank_gm_rewards done role_id = ~p, ~p~n", [RoleId, RankType]);
%%					_ ->
%%						?ERR("rushrank_gm_rewards nothing ~n", [])
%%				end
%%		end
%%	    end,
%%	[F(Id) || Id <- get_ids_by_day(util:get_open_day())].




%%get_gm_rewards(1) ->
%%	[{100, 38060024, 1}];
%%get_gm_rewards(2) ->
%%	[{100, 16030002, 1}];
%%get_gm_rewards(3) ->
%%	[{100, 18040002, 1}];
%%get_gm_rewards(4) ->
%%	[{100, 38140003, 1}];
%%get_gm_rewards(5) ->
%%	[{100, 38150003, 1}, {100, 14010003, 1}];
%%get_gm_rewards(6) ->
%%	[{100, 12040002, 1}].




%%%% -----------------------------------------------------------------
%%%% @desc     功能描述  获取排行榜对应的值
%%%% @param    参数     RankType::排行榜类型 SubType::活动子类型  RoleId 玩家id，
%%%%                    RankMap::{RankType,SubType} => [#rush_rank_role{}|...]
%%%% @return   返回值   SelVale::integer()  排位榜对应的值
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%get_sel_value(SubType, RoleId, RankMap) ->
%%	case maps:find(SubType, RankMap) of
%%		{ok, List} ->
%%			case lists:keyfind(SubType, RoleId, #up_power_rush_rank_role.role_key, List) of
%%				#up_power_rush_rank_role{value = SelValue} ->
%%					SelValue;
%%				_ ->
%%					0
%%			end;
%%		_ ->
%%			0
%%	end.

%%%%获取排行榜结算时间
%%get_end_time(RankType) ->
%%	case data_rush_rank:get_rush_rank_cfg(RankType) of
%%		#base_rush_rank{start_day = _StartDay, clear_day = EndDay} ->
%%			OpenDay = util:get_open_day(),
%%			if
%%				OpenDay >= EndDay ->  %%已经结算了
%%					0;
%%				OpenDay < EndDay -> %% 当天结算0点了，直接返回0
%%					utime:unixdate() + (EndDay - OpenDay) * 86400;   %%当天0点时间戳 + （结算天数 - 开服天数） * 86400
%%				true ->
%%					0
%%			end;
%%		_ ->
%%			0
%%	end.



%%get_rush_rank_all_role() ->
%%	Sql = io_lib:format(?sql_rush_rank_all_role, []),
%%	List = db:get_all(Sql),
%%	List1 = [{{RankType, SubType, RoleId}, Value} || [RankType, SubType, RoleId, Value] <- List],
%%	maps:from_list(List1).



%%活动结算，清理数据
act_end(State, SubType) ->
	spawn(fun()->
		Sql = io_lib:format(<<"DELETE  from   up_power_rush_rank_role_in_ps where  sub_type = ~p">>, [SubType]),
		db:execute(Sql),
		Sql2 = io_lib:format(<<"DELETE  from   up_power_rush_rank_role_in_ps where  sub_type = ~p">>, [SubType + 1]),  %% 绑定的也要
		db:execute(Sql2),
		Sql3 = io_lib:format(<<"DELETE   from    up_power_rush_rank_role  where   sub_type = ~p">>, [SubType]),  %% 绑定的也要
		db:execute(Sql3),
		OnlineRoles = ets:tab2list(?ETS_ONLINE),
		[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_up_power, clear_act, [SubType + 1]) || E <- OnlineRoles] %% 玩家内存数据处理
	      end),
	%% 发送奖励
	#up_power_rush_rank_state{rank_maps = RankMap} = State,
	RankList = maps:get(SubType, RankMap, []),
	spawn(fun() ->
		send_reward(SubType, RankList)
	    end
	),
%%	?PRINT("SubType ~p~n", [SubType]),
	RankMapNew = maps:remove(SubType, RankMap),
	State#up_power_rush_rank_state{rank_maps = RankMapNew}.
%%	%%清理数据库
%%	Sql1 = io_lib:format(?del_rush_rank_role, []),
%%	Sql2 = io_lib:format(?del_rush_rank_all_role, []),
%%	Sql3 = io_lib:format(?del_rush_rank_goal, []),
%%	db:execute(Sql1),
%%	db:execute(Sql2),
%%	db:execute(Sql3),lib_dungeon_partner
%%	{ok, #rush_rank_state{}}.

%%%%用于数据修复
%%get_reward2(Rank, RankType, RoleId) ->
%%	case lib_role:get_role_show(RoleId) of
%%		#ets_role_show{figure = Figure} ->
%%			lib_rush_rank:get_rank_reward(RankType, Rank, Figure#figure.sex);   %% 奖励根据性别有区别，这里是一定有的，检查过了
%%		_ ->
%%			[]
%%	end.
%%


send_reward(SubType, RankList) ->
	RankList2 = sort_rank_list(RankList, SubType),
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
		#custom_act_cfg{name = ActName} ->
			ok;
		_ ->
			ActName = <<>>
	end,
	[
		begin
			timer:sleep(200),
			case lib_up_power:get_up_power_rank_reward(SubType, Role) of
				{Reward, RewardId}when Reward =/= [] ->
					%%log
					lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType, RewardId, Reward),
					Title = utext:get(3310087, [ActName]),
					Content = utext:get(3310088, [Rank]),
					lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
				_ ->
					skip
			end
		end
		||#up_power_rush_rank_role{rank = Rank, role_id = RoleId} = Role <- RankList2].
	


