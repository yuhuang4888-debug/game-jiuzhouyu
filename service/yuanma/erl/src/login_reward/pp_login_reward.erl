%%%--------------------------------------
%%% @Module  : pp_login_reward
%%% @Author  : hyh
%%% @Created : 2018.01.12
%%% @Description:  七天登录
%%%--------------------------------------
-module(pp_login_reward).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("login_reward.hrl").

%%  打开七天登录
handle(17500, Ps, []) ->
	#player_status{
		sid = Sid,
		login_reward = LoginReward
	} = Ps,
	#login_reward{
		create_time = _CreateTime,
		reward_list = RewardStatus,
		login_day = LoginDay
	} = LoginReward,
%%	LoginDay = lib_login_reward:get_login_day(CreateTime),
%%	?DEBUG("LoginDay:~p, RewardStatus ~p ~n",  [LoginDay, RewardStatus]),
	{ok, Bin} = pt_175:write(17500, [?SUCCESS, LoginDay, RewardStatus]),
	lib_server_send:send_to_sid(Sid, Bin);


%%  领取七天登录
handle(17501, Ps, [DayId]) ->
	#player_status{
		sid = Sid,
		id = RoleId,
		figure = F,
		login_reward = LoginReward
	} = Ps,
	#figure{sex = _Sex, career = Career} = F,
	#login_reward{
		reward_list = OldRewardStatus
	} = LoginReward,
	RewardList = lib_login_reward:get_reward_by_career(Career, DayId),
	case RewardList of
		[] ->  %%缺失配置
			{ok, Bin} = pt_175:write(17501, [?MISSING_CONFIG, DayId, []]),
			lib_server_send:send_to_sid(Sid, Bin),
			{ok, Ps};
		_ ->
			case lists:keyfind(DayId, 1, OldRewardStatus) of
				false ->  %%天数错误
					{ok, Bin} = pt_175:write(17501, [?FAIL, DayId, []]),
					lib_server_send:send_to_sid(Sid, Bin),
					{ok, Ps};
				{_Day, _Status} ->
					case _Status of
						0 ->  %%不可领取   -- 再登录X天即可领取 这个让客户端做吧  也可以用11017
%%							?DEBUG("Log0 ~n",  []),
							{ok, Bin} = pt_175:write(17501, [?ERRCODE(err175_can_not_get), DayId, []]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, Ps};
						1 ->  %%可领取
%%							?DEBUG("Log1 rewardlist ~p ~n",  [RewardList]),
							%%发送日志
							lib_log_api:log_login_reward_day(RoleId, DayId, utime:unixdate(), RewardList),
							%%任务
							lib_task_api:award_7day(Ps, 1),
							%%发送奖励
							case lib_goods_api:send_reward_with_mail_return_goods(Ps, #produce{reward = RewardList, type = login_reward}) of
								{ok, bag, NewPs1, UpGoodsList} ->
									SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList);
								{ok, mail, NewPs1, []} ->
									SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, [])
							end,
							%%修改领取状态
							NewRewardStatus = lists:keystore(DayId, 1, OldRewardStatus, {_Day, 2}),
							NewLoginReward = LoginReward#login_reward{reward_list = NewRewardStatus},
							%%同步数据库；
							lib_login_reward:save_to_db(NewLoginReward, RoleId),
							%%推送客户端
%%							?MYLOG("cym", "SeeRewardList ~p~n", [SeeRewardList]),
							{ok, Bin} = pt_175:write(17501, [?SUCCESS, DayId, SeeRewardList]),
							lib_server_send:send_to_sid(Sid, Bin),
							%%修正ps
							LastPs = NewPs1#player_status{login_reward = NewLoginReward},
							{ok, LastPs};
						2 ->  %%已经领取
%%							?DEBUG("Log2 ~n",  []),
							{ok, Bin} = pt_175:write(17501, [?ERRCODE(err175_the_day_already_get), DayId, []]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, Ps}
					end
			end
	end;


%%  打开合服登录奖励
handle(17502, Ps, []) ->
	#player_status{
		sid = Sid,
		login_merge_reward = LoginReward
	} = Ps,
	case LoginReward of
		#login_reward{
			reward_list = RewardStatus,
			login_day = LoginDay
		} ->
            MergeWlv = util:get_merge_wlv(),
			{ok, Bin} = pt_175:write(17502, [?SUCCESS, LoginDay, MergeWlv, RewardStatus]),
			lib_server_send:send_to_sid(Sid, Bin);
		_ ->
			{ok, Bin} = pt_175:write(17502, [?FAIL, 0, 0, []]),
			lib_server_send:send_to_sid(Sid, Bin)
	end;


%%  领取七天登录
handle(17503, Ps, [DayId]) ->
	#player_status{
		sid = Sid,
		id = RoleId,
		figure = F,
		login_merge_reward = LoginReward
	} = Ps,
	#figure{sex = _Sex, career = Career} = F,
	case LoginReward of
		#login_reward{
			reward_list = OldRewardStatus
		} = LoginReward ->
			RewardList = lib_login_reward_merge:get_reward_by_career(Career, DayId),
			case RewardList of
				[] ->  %%缺失配置
					{ok, Bin} = pt_175:write(17503, [?MISSING_CONFIG, DayId, []]),
					lib_server_send:send_to_sid(Sid, Bin),
					{ok, Ps};
				_ ->
					case lists:keyfind(DayId, 1, OldRewardStatus) of
						false ->  %%天数错误
							{ok, Bin} = pt_175:write(17503, [?FAIL, DayId, []]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, Ps};
						{_Day, _Status} ->
							case _Status of
								0 ->  %%不可领取   -- 再登录X天即可领取 这个让客户端做吧  也可以用11017
									{ok, Bin} = pt_175:write(17503, [?ERRCODE(err175_can_not_get), DayId, []]),
									lib_server_send:send_to_sid(Sid, Bin),
									{ok, Ps};
								1 ->  %%可领取
									%%发送日志
									lib_log_api:log_login_reward_day(RoleId, DayId, utime:unixdate(), RewardList),
									?MYLOG("cym", "17503 ~p~n", [RewardList]),
									%%发送奖励
									case lib_goods_api:send_reward_with_mail_return_goods(Ps, #produce{reward = RewardList, type = login_reward}) of
										{ok, bag, NewPs1, UpGoodsList} ->
											SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList);
										{ok, mail, NewPs1, []} ->
											SeeRewardList = lib_goods_api:make_see_reward_list(RewardList, [])
									end,
									%%修改领取状态
									NewRewardStatus = lists:keystore(DayId, 1, OldRewardStatus, {_Day, 2}),
									NewLoginReward = LoginReward#login_reward{reward_list = NewRewardStatus},
									%%同步数据库；
									lib_login_reward_merge:save_to_db(NewLoginReward, RoleId),
									%%推送客户端
									{ok, Bin} = pt_175:write(17503, [?SUCCESS, DayId, SeeRewardList]),
									lib_server_send:send_to_sid(Sid, Bin),
									%%修正ps
									LastPs = NewPs1#player_status{login_merge_reward = NewLoginReward},
									{ok, LastPs};
								2 ->  %%已经领取
									{ok, Bin} = pt_175:write(17503, [?ERRCODE(err175_the_day_already_get), DayId, []]),
									lib_server_send:send_to_sid(Sid, Bin),
									{ok, Ps}
							end
					end
			end;
		_ ->
			{ok, Bin} = pt_175:write(17503, [?FAIL, 0, []]),
			lib_server_send:send_to_sid(Sid, Bin)
	end;



handle(_Cmd, _Player, _Data) ->
	{error, atom_to_list(?MODULE) ++ " no match"}.
