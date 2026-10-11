%%-----------------------------------------------------------------------------
%% @Module  :       lib_create_role_act
%% @Author  :       cxd
%% @Created :       2020-11-11
%% @Description:    回归登录活动
%%-----------------------------------------------------------------------------
-module(lib_create_role_act).
-include("common.hrl").
-include("custom_act.hrl").
-include("sql_player.hrl").
-include("timer.hrl").
-include("create_role_act.hrl").

-export([
	midnight_do/1
	, send_reward/1
	, get_cfg/2
	, act_end/2
	, gm_repair_role/5
]).

%% -------------------------- 数据处理 --------------------------
%% 零点处理
midnight_do(#timer{delay_sec = DelaySec}) ->
	spawn(fun() -> 
		timer:sleep(DelaySec),
		Type = ?CUSTOM_ACT_TYPE_CREATE_ROLE,
		SubIds = lib_custom_act_api:get_open_subtype_ids(Type),
		F = fun(SubId) ->
			case db_select(role_info, [Type, SubId]) of 
				[] ->
					skip;
				RolesInfo ->
					F2 = fun([RoleId, RegTime, DataList], {FunDbList, FunRewardList}) ->
						{day, RecordDay} = ulists:keyfind(day, 1, util:bitstring_to_term(DataList), {day, 999}), %% 已经领取奖励的天数
						CreateRoleDay = utime:diff_days(utime:unixtime(), RegTime) + 1,  %% 创角第几天
						IsToday = utime:is_today(RegTime),
						if
							IsToday -> %% 筛选掉今天零点到结算这段时间注册的角色
								{FunDbList, FunRewardList};
							RecordDay >= CreateRoleDay -> %% 已领取当天奖励
								{FunDbList, FunRewardList};
							true ->
								{[[RoleId, Type, SubId, util:term_to_string([{day, CreateRoleDay}])] | FunDbList], [{CreateRoleDay, RoleId} | FunRewardList]}
						end
					end,
					{DbList, RewardInfoList} = lists:foldl(F2, {[], []}, RolesInfo),
					%% 批量插入后再发奖励
				    db_replace(batch_custom_act_data, [custom_act_data, [player_id, type, subtype, data_list], DbList]),
				    F3 = fun({CreateRoleDay, RoleId}) ->
				    	timer:sleep(100),
						send_reward(Type, SubId, CreateRoleDay, RoleId, ?BAT_INSERT)
				    end,
				    lists:foreach(F3, RewardInfoList)
			end
		end,
		lists:foreach(F, SubIds)
	end).

%% 发奖励
send_reward(RoleId) ->
	case db_select(role_reg_time, [RoleId]) of 
		[] ->
			skip;
		RegTime ->
			CreateRoleDay = utime:diff_days(utime:unixtime(), RegTime) + 1,  %% 创角第几天
			send_reward(CreateRoleDay, RoleId)
	end.
send_reward(CreateRoleDay, RoleId) -> 
	Type = ?CUSTOM_ACT_TYPE_CREATE_ROLE,
    SubIds = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubId) ->
    	send_reward_core(Type, SubId, RoleId, CreateRoleDay, ?ONE_INSERT)
    end,
    lists:foreach(F, SubIds).
send_reward(Type, SubType, CreateRoleDay, RoleId, DbType) -> 
	send_reward_core(Type, SubType, RoleId, CreateRoleDay, DbType).

%% 发送邮件核心代码
send_reward_core(Type, SubType, RoleId, CreateRoleDay, DbType) ->
	case get_cfg(reward_cfg, [Type, SubType, CreateRoleDay]) of 
		{0, []} ->
			skip;
		{GradeId, RewardList} ->
			%% 记录日志
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList),
			case DbType of 
				?ONE_INSERT ->
					DataList = [{day, CreateRoleDay}],
					db_replace(custom_act_data, [RoleId, Type, SubType, DataList]);
				_ -> 
					skip
			end,
			lib_mail_api:send_sys_mail([RoleId], utext:get(3310095, [CreateRoleDay]), utext:get(3310096, [CreateRoleDay]), RewardList)
	end.

%% 活动结束
act_end(Type, SubType) ->
	lib_custom_act:db_delete_custom_act_data(Type, SubType).

%% -------------------------- 配置相关 --------------------------
get_cfg(reward_cfg, [Type, SubType, CreateRoleDay]) -> 
	case lib_custom_act_util:get_act_reward_grade_list(Type, SubType) of 
		GradeIds when is_list(GradeIds) ->
			F = fun(GradeId) ->
				case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
					#custom_act_reward_cfg{condition = Condition} ->
						case lists:keyfind(day, 1, Condition) of 
							{day, CreateRoleDay} ->
								true;
							_ ->
								false
						end;
					_ ->
						false
				end 
			end,
			case ulists:find(F, GradeIds) of 
				error -> 
					{0, []};
				{ok, GradeId} ->
					#custom_act_reward_cfg{reward = RewardList} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
					{GradeId, RewardList}
			end;
		_ ->
			?ERR("create role act reward cfg miss, Type:~p SubType:~p CreateRoleDay:~p", [Type, SubType, CreateRoleDay]),
			[]
	end;
get_cfg(act_time, [Type, SubType]) -> 
	case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of 
		false -> 
			false;
		#act_info{stime = STime, etime = ETime} -> 
			{STime, ETime}
	end;
get_cfg(Tag, Args) -> 
	?ERR("create role act get_cfg err, Tag:~p Args:~p", [Tag, Args]),
	[].

%% -------------------------- db相关 --------------------------
%% 数据库查询
db_select(role_reg_time, [RoleId]) -> %% 根据玩家id查询玩家的注册时间
	RegTimeSql = io_lib:format(?sql_role_reg_time_by_id, [RoleId]),
	case db:get_row(RegTimeSql) of 
		[RegTime] ->
			RegTime;
		Err ->
			?ERR("role_id:~p db err: ~p", [RoleId, Err]),
			[]
	end;
db_select(role_info, [Type, SubType]) -> %% 查询活动要用到的角色数据
	case get_cfg(act_time, [Type, SubType]) of 
		false ->
			[];
		{ActSTime, ActETime} ->
			Sql = io_lib:format(?sql_role_info, [Type, SubType, ActSTime, ActETime]),
			case db:get_all(Sql) of 
				RoleInfo when is_list(RoleInfo) ->
					RoleInfo;
				Err ->
					?ERR("db err: ~p", [Err]),
					[]
			end
	end;
db_select(_, _) -> [].

%% 数据库插入
db_replace(batch_custom_act_data, [TableName, Cols, DbList]) -> 
	case DbList =/= [] of 
        true ->
        	%% usql:replace(表名, [列], 列数据),
            Sql = usql:replace(TableName, Cols, DbList),
            db:execute(Sql);
        false -> skip
    end;
db_replace(custom_act_data, [PlayerId, Type, SubType, DataList]) -> 
	Sql = io_lib:format(?SQL_SAVE_CUSTOM_ACT_DATA, [PlayerId, Type, SubType, util:term_to_string(DataList)]),
    db:execute(Sql);
db_replace(Tag, Args) -> 
	?ERR("db_replace error Tag:~p Args:~p", [Tag, Args]),
	skip.


%% -------------------------- 秘籍 --------------------------
%% 修复数据库并发送奖励
gm_repair_role(Type, SubType, Day, STime, ETime) ->
	spawn(fun() ->
		PLSql = io_lib:format(<<"select a.id from player_login a where a.reg_time >= ~p and a.reg_time <= ~p">>, [STime, ETime]),
		LogSql = io_lib:format(<<"select a.player_id from log_custom_act_reward a where a.type = ~p and a.subtype = ~p and a.reward_id = ~p and a.time >= ~p and a.time <= ~p">>, [Type, SubType, Day, STime, ETime]),
		case db:get_all(PLSql) of 
			[] -> skip;
			RegIdList ->
				case db:get_all(LogSql) of 
					[] -> RewardIdList = [];
					LogSqlData -> 
						RewardIdList = [LogSqlRoleId || [LogSqlRoleId] <- LogSqlData]
				end,
				F = fun([RoleId], {FDbList, FRewardList}) ->
					case lists:member(RoleId, RewardIdList) of
						true -> %% 已经领过了，跳过
							{FDbList, FRewardList};
						false ->
							{[[RoleId, Type, SubType, util:term_to_string([{day, Day}])] | FDbList], [{Day, RoleId} | FRewardList]}
					end
				end,
				{DbList, RewardInfoList} = lists:foldl(F, {[], []}, RegIdList),
				%% 批量插入后再发奖励
			    db_replace(batch_custom_act_data, [custom_act_data, [player_id, type, subtype, data_list], DbList]),
			    F3 = fun({CreateRoleDay, RoleId}) ->
			    	timer:sleep(100),
					send_reward(Type, SubType, CreateRoleDay, RoleId, ?BAT_INSERT)
			    end,
			    lists:foreach(F3, RewardInfoList)
		end
	end),
	happy_new_year.
