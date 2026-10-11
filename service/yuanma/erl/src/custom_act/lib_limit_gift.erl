%%%-----------------------------------
%%% @Module      : lib_limit_gift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 18. 二月 2019 16:19
%%% @Description : 限时礼包
%%%-----------------------------------
-module(lib_limit_gift).
-author("chenyiming").

%% API
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("common.hrl").

login(#player_status{id = RoleId} = Ps) ->
	Sql = io_lib:format("select  sub_type, reward_status from  role_limit_gift where role_id = ~p", [RoleId]),
	List = db:get_all(Sql),
	LimitGift = make_limit_gift_from_db(List),
	Ps#player_status{limit_gift = LimitGift}.

%%限时礼包清理旧数据
del_limit_gift_over_data(SubType, StartTime, _EndTime) ->
	Sql = io_lib:format("DELETE from  role_limit_gift WHERE  sub_type = ~p and  time < ~p", [SubType, StartTime]),
	db:execute(Sql).

%%限时礼包购买消耗
get_limit_gift_cost(Condition) ->
	case lists:keyfind(cost, 1, Condition) of
		{cost, Cost} ->
			Cost;
		_ ->
			[]
	end.
%%更新限时礼包状态，且保存数据库
update_limit_gift_status(LimitGiftList, SubActType, GradeId, RoleId) ->
	case lists:keyfind(SubActType, #limit_gift.sub_type, LimitGiftList) of
		#limit_gift{reward_status = SubTypeRewardList} ->
			NewSubTypeRewardList = set_limit_gift_status(SubTypeRewardList, GradeId, ?limit_gift_reward_yet_get);
		_ ->
			SubTypeRewardList = init_limit_gift_reward_status(SubActType),
			NewSubTypeRewardList = set_limit_gift_status(SubTypeRewardList, GradeId, ?limit_gift_reward_yet_get)
	end,
	LimitGift = #limit_gift{sub_type = SubActType, reward_status = NewSubTypeRewardList},
	save_limit_gift_to_db(RoleId, LimitGift),
	lists:keystore(SubActType, #limit_gift.sub_type, LimitGiftList, LimitGift).


%% 更加子类型初始化限时礼包
init_limit_gift_reward_status(SubActType) ->
	Now = utime:unixtime(),
	List = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubActType),
	[{GradeId, ?limit_gift_reward_not_get, Now} || GradeId <- List].

set_limit_gift_status(SubTypeRewardList, GradeId, Status) ->
	Now = utime:unixtime(),
	lists:keystore(GradeId, 1, SubTypeRewardList, {GradeId, Status, Now}).

%%同步数据库
save_limit_gift_to_db(RoleId, #limit_gift{sub_type = SubType, reward_status = RewardList}) ->
	Now = utime:unixtime(),
	DbRewardList = util:term_to_string(RewardList),
	Sql = io_lib:format("REPLACE into    role_limit_gift (role_id, sub_type, reward_status, time)  VALUES(~p, ~p, ~p, ~p)",
		[RoleId, SubType, DbRewardList, Now]),
	db:execute(Sql).


check(#player_status{limit_gift = LimitGiftList, figure = F}, SubType, Grade) ->
%%	?MYLOG("cym", "~p~n", [LimitGiftList]),
	IsLvLimit = is_lv_limit(SubType, F#figure.lv),
	if
		IsLvLimit == true ->
			{false, ?ERRCODE(err331_lv_not_enougth)};
		true ->
			case lists:keyfind(SubType, #limit_gift.sub_type, LimitGiftList) of
				#limit_gift{reward_status = RewardList} ->
					case lists:keyfind(Grade, 1, RewardList) of
						{Grade, ?limit_gift_reward_not_get, _} ->
							true;
						{Grade, ?limit_gift_reward_yet_get, _} ->
							{false, ?ERRCODE(err331_already_get_reward)};
						_ ->
							true
					end;
				_ ->
					true
			end
	end.

send_reward_status(Player, SubType) ->
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType),
	#player_status{limit_gift = LimitGiftList} = Player,
	RewardList = get_limit_gift_reward_list(LimitGiftList, SubType),
	F = fun(GradeId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType, GradeId) of
			#custom_act_reward_cfg{
				name = Name, desc = Desc, condition = Condition, format = Format, reward = Reward
			} ->
				ConditionStr = util:term_to_string(Condition),
				RewardStr = util:term_to_string(Reward),
				{GradeId, Status, Time} = get_status_by_grade(RewardList, GradeId),
				IsOverDay = is_over_day(Time),
				if
					Status == ?limit_gift_reward_yet_get andalso IsOverDay ->  %%领取了隔天，则不发送
						Acc;
					true ->
						[{GradeId, Format, Status, 0, Name, Desc, ConditionStr, RewardStr} | Acc]
				end;
			_ ->
				Acc
		end
	end,
	PackList = lists:foldl(F, [], GradeIds),
%%	?MYLOG("cym", "PackList ~p~n", [PackList]),
	{ok, BinData} = pt_331:write(33104, [?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType, PackList]),
	lib_server_send:send_to_sid(Player#player_status.sid, BinData).


get_limit_gift_reward_list(LimitGiftList, SubType) ->
	case lists:keyfind(SubType, #limit_gift.sub_type, LimitGiftList) of
		#limit_gift{reward_status = RewardList} ->
			RewardList;
		_ ->
			[]
	end.

get_status_by_grade(RewardList, Grade) ->
	case lists:keyfind(Grade, 1, RewardList) of
		{Grade, Status, Time} ->
			{Grade, Status, Time};
		_ ->
			{Grade, ?limit_gift_reward_not_get, utime:unixtime()}
	end.

is_over_day(Time) ->
	DiffDay = utime:diff_day(Time),
	if
		DiffDay == 0 ->
			false;
		true ->
			true
	end.

make_limit_gift_from_db([]) ->
	[];
make_limit_gift_from_db(List) ->
	make_limit_gift_from_db(List, []).


make_limit_gift_from_db([], Acc) ->
	Acc;
make_limit_gift_from_db([[SubType, _RewardList] | List], Acc) ->
	RewardList = util:bitstring_to_term(_RewardList),
	LimitGift = #limit_gift{sub_type = SubType, reward_status = RewardList},
	make_limit_gift_from_db(List, [LimitGift | Acc]).

is_lv_limit(SubType, Lv) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(role_lv, 1, Condition) of
				{role_lv, LimitLv} ->
					LimitLv > Lv;
				_ ->
					false
			end;
		_ ->
			false
	end.