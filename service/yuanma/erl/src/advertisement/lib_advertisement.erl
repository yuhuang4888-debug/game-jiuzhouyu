%%%-----------------------------------
%%% @Module      : lib_advertisement
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 四月 2021 10:29
%%% @Description :
%%%-----------------------------------


%% 配置， 产出消耗类型

%% API
-compile(export_all).

-module(lib_advertisement).
-include("advertisement.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("def_daily.hrl").
-include("checkin.hrl").
-include("timer.hrl").
-include("custom_act.hrl").

-author("carlos").

%% API
-export([]).



login(PS) ->
	Sql = io_lib:format(?sql_select_by_id, [PS#player_status.id]),
	DbList = db:get_all(Sql),
	List = [#advertisement{
		key = {ModId, SubId},
		mod_id = ModId,
		sub_id = SubId,
		count = Count,
		time = Time,
		ad_id = AdvertisementId
	} || [ModId, AdvertisementId, SubId, Time, Count] <- DbList],
	PS#player_status{advertisement = #advertisement_status{lists = List}}.


gm_clear() ->
	midnight_do(#timer{delay_sec = 0}),
	four_do().
%%gm
midnight_do() ->
	midnight_do(#timer{delay_sec = 1}).

%% 0点处理
midnight_do(#timer{delay_sec = DelaySec}) ->
	List = data_advertisement:get_ad_list_by_ver(?GAME_VER),
	F = fun({Id, SubId}, AccList) ->
			case data_advertisement:get_cfg_by_id(?GAME_VER, Id, SubId) of
				#advertisement_cfg{clear_type = Type, mod_id = ModId, mod_sub_id = SubId} when Type == 0 ->
					[{ModId, SubId} | AccList];
				_ ->
					AccList
			end
		end,
	HandleList = lists:foldl(F, [], List),
	[begin
		 Sql = io_lib:format(?sql_delete_by_id, [Id, SubId]),
		 db:execute(Sql)
	 end || {Id,  SubId} <- HandleList],
	spawn(fun() ->
		timer:sleep(DelaySec),
		OnlineList = ets:tab2list(?ETS_ONLINE),
		IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
		[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_advertisement, clear_do_in_ps, [HandleList]) || RoleId <- IdList]
	      end).

%% 0点处理
four_do() ->
	List = data_advertisement:get_ad_list_by_ver(?GAME_VER),
	F = fun({Id, SubId}, AccList) ->
		case data_advertisement:get_cfg_by_id(?GAME_VER, Id, SubId) of
			#advertisement_cfg{clear_type = Type, mod_id = ModId, mod_sub_id = SubId} when Type == 1 ->
				[{ModId, SubId} | AccList];
			_ ->
				AccList
		end
	    end,
	HandleList = lists:foldl(F, [], List),
	[begin
		 Sql = io_lib:format(?sql_delete_by_id, [Id, SubId]),
		 db:execute(Sql)
	 end || {Id,  SubId} <- HandleList],
	spawn(fun() ->
		OnlineList = ets:tab2list(?ETS_ONLINE),
		IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
		[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_advertisement, clear_do_in_ps, [HandleList]) || RoleId <- IdList]
	      end).


%% todo 需要在处理一次数据库麻
clear_do_in_ps(PS, HandleList) ->
	#player_status{advertisement = AdStatus} = PS,
	#advertisement_status{lists = Ad} = AdStatus,
	F = fun({Id, SubId}, AccAd) ->
			NewAccAd = lists:keydelete({Id, SubId}, #advertisement.key, AccAd),
			NewAccAd
		end,
	NewAd = lists:foldl(F, Ad, HandleList),
	NewPS = PS#player_status{advertisement = AdStatus#advertisement_status{lists = NewAd}},
	pp_advertisement:handle(19302, NewPS, []),
	NewPS.



notify_ads(RoleId, _AdvertisementId) ->
	notify(RoleId).
%%	case check_advertisement(AdvertisementId) of
%%		#advertisement_cfg{mod_id = ModId, mod_sub_id = SubId, max_count = MaxCount} ->
%%			notify(RoleId, AdvertisementId, ModId, SubId, 1, MaxCount);
%%		_ ->
%%			?ERR("miss cfg ~p~n", [AdvertisementId])
%%	end.



check_advertisement(_AdvertisementId) ->
	true.
%%	case data_advertisement:get_cfg_by_id(AdvertisementId) of
%%		#advertisement_cfg{version_id = VerId} = Cfg when VerId == ? GAME_VER-> %% 同一个版本才有用
%%			Cfg;
%%		_ ->
%%			false
%%	end.



notify(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_advertisement,
		notify_in_ps, []).

%%通知ps 看了广告
notify_in_ps(PS) ->
	#player_status{advertisement = Adstatus, id = RoleId, status_custom_act = CustomAct} = PS,
	#advertisement_status{lists = List, mod_id = Mod, sub_id = SubId, grade = GradeId} = Adstatus,
%%	?PRINT("Mod ++++++++++++++++ ~p ~n", [Mod]),
	if
		Mod == ?MOD_AC_CUSTOM -> %% 定制活动逻辑
%%			?PRINT("notify_in_ps ++++++++++++++++ ~n", []),
			#status_custom_act{reward_map = RewardMap, data_map = DataMap} = CustomAct,
%%			RewardStatus = maps:get({Mod, SubId, GradeId}, RewardMap, #reward_status{}) ,
			DataStatus = maps:get({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId}, DataMap,
				#custom_act_data{id = {?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId}, type = ?CUSTOM_ACT_TYPE_ADVERTISEMENT, subtype = SubId}),
			#custom_act_data{data = DataList} = DataStatus,
			case lists:keyfind(GradeId, 1, DataList) of %%将看广告次数存到定制活动的信息里
				{GradeId, Count} ->
					case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId, GradeId) of
						#custom_act_reward_cfg{condition = Condition} ->
							case lists:keyfind(count_limit, 1, Condition) of
								{_, MaxCount} when Count < MaxCount ->
									NewDataList = lists:keystore(GradeId, 1, DataList, {GradeId, Count + 1, utime:unixtime()}),
									DataStatusNew = DataStatus#custom_act_data{data = NewDataList},
									NewDataMap = maps:put({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId}, DataStatusNew, DataMap),
									NewCustomAct = CustomAct#status_custom_act{data_map = NewDataMap},
%%									?MYLOG("cym", "DataStatusNew ++++++++++++++++ ~p ~n", [DataStatusNew]),
									lib_custom_act:db_save_custom_act_data(RoleId, DataStatusNew),
									NewPS = PS#player_status{status_custom_act = NewCustomAct},
									pp_custom_act_list:handle(33250, NewPS, [?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId]),
									lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_AC_CUSTOM, SubId, 1, [], GradeId),
                                    {ok, Bin1} = pt_193:write(19304, [Mod, SubId, GradeId]),
									lib_server_send:send_to_uid(RoleId, Bin1),
									pp_custom_act:handle(33104, NewPS, [?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId]),
									{ok, NewPS};
								_ ->
									{ok, PS}
							end;
						_ ->
							{ok, PS}
					end;
				_ ->
					NewDataList = lists:keystore(GradeId, 1, DataList, {GradeId, 1, utime:unixtime()}),
					DataStatusNew = DataStatus#custom_act_data{data = NewDataList},
					lib_custom_act:db_save_custom_act_data(RoleId, DataStatusNew),
%%					?MYLOG("cym", "DataStatusNew ++++++++++++++++ ~p ~n", [DataStatusNew]),
					NewDataMap = maps:put({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId}, DataStatusNew, DataMap),
					NewCustomAct = CustomAct#status_custom_act{data_map = NewDataMap},
					NewPS = PS#player_status{status_custom_act = NewCustomAct},
					pp_custom_act_list:handle(33250, NewPS, [?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId]),
					lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_AC_CUSTOM, SubId, 1, [], GradeId),
                    {ok, Bin1} = pt_193:write(19304, [Mod, SubId, GradeId]),
					lib_server_send:send_to_uid(RoleId, Bin1),
					pp_custom_act:handle(33104, NewPS, [?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId]),
					{ok, NewPS}
			end;
		true ->%% 普通广告逻辑
%%			?MYLOG("cym", "Adstatus ++++++++++++++++ ~p ~n", [Adstatus]),
			case data_advertisement:get_cfg_by_id(?GAME_VER, Mod, SubId) of
				#advertisement_cfg{max_count = MaxCount} ->
					case lists:keyfind({Mod, SubId}, #advertisement.key, List) of
						#advertisement{count = Count} = Ad when Count < MaxCount ->
							NewCount = min(Ad + 1, MaxCount),
							AdNew = Ad#advertisement{count = NewCount, time = utime:unixtime()},
							lib_advertisement_util:save_db(RoleId, AdNew),
							NewAdList = lists:keystore({Mod, SubId}, #advertisement.key, List, AdNew),
							NewPs = notify_in_ps_do(PS#player_status{advertisement = Adstatus#advertisement_status{lists = NewAdList}},
								Mod, SubId, 1, 0),
                            {ok, Bin1} = pt_193:write(19304, [Mod, SubId, GradeId]),
							lib_server_send:send_to_uid(RoleId, Bin1),
							pp_advertisement:handle(19302, NewPs, []),
							{ok, NewPs};
						#advertisement{} -> %%已经超过次数
							{ok, PS};
						_ ->
							NewCount = min(1, MaxCount),
							AdNew = #advertisement{count = NewCount, mod_id = Mod, sub_id = SubId,
								ad_id = 0, time = utime:unixtime(),key = {Mod, SubId}},
							lib_advertisement_util:save_db(RoleId, AdNew),
							NewAdList = lists:keystore({Mod, SubId}, #advertisement.key, List, AdNew),
%%							?PRINT("notify_in_ps ++++++++++++++++ NewAdList ~p~n", [NewAdList]),
							NewPs = notify_in_ps_do(PS#player_status{advertisement = Adstatus#advertisement_status{lists = NewAdList}}, Mod, SubId, 1, 0),
                            {ok, Bin1} = pt_193:write(19304, [Mod, SubId, GradeId]),
							lib_server_send:send_to_uid(RoleId, Bin1),
							pp_advertisement:handle(19302, NewPs, []),
							{ok, NewPs}
					end;
				_ ->
					{ok, PS}
			end
	end.



%% 实际触发逻辑
%% 副本
notify_in_ps_do(PS, ?MOD_DUNGEON, DunType, Count, _AdvertisementId) ->
	NewPS = lib_dungeon:add_dungeon_type_count(PS, DunType, Count),
	lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_DUNGEON, DunType, Count, [], 0),
	%% 处理通知逻辑
	pp_dungeon:handle(61020, NewPS, [DunType]),
	NewPS;
%% 寻宝增加免费次数
notify_in_ps_do(PS, ?MOD_TREASURE_HUNT, Type, Count, _AdvertisementId) ->
	#player_status{id = RoleId} = PS,
	%% 增加次数
	mod_treasure_hunt:add_free_treasure_hunt(RoleId, Type, Count),
	lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_TREASURE_HUNT, Type, Count, [], 0),
	%% 处理通知逻辑
	case pp_treasure_hunt:handle(41604, PS, [Type, Count, 0]) of
		{ok , NewPs} ->
			NewPs;
		_ ->
			PS
	end;
%% 周一大奖
notify_in_ps_do(PS, ?MOD_BONUS_MONDAY, Type, Count, _AdvertisementId) ->
	#player_status{id = RoleId} = PS,
	case data_advertisement:get_cfg_by_id(?GAME_VER, ?MOD_BONUS_MONDAY, Type) of
		#advertisement_cfg{reward = Reward} when  Reward =/= [] ->
			lib_advertisement_util:save_log(PS#player_status.id, ?MOD_BONUS_MONDAY, Type, Count),
			{ok, Bin} = pt_193:write(19301, [Reward]),
			lib_server_send:send_to_uid(RoleId, Bin),
			lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_BONUS_MONDAY, Type, Count, Reward, 0),
			lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = advertisement_reward});
		_ ->
			skip
	end,
	PS;
%% 每日签到
notify_in_ps_do(PS, ?MOD_WELFARE, Type, Count, _AdvertisementId) ->
	#player_status{id = RoleId} = PS,
	mod_daily:set_count(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED, 0),
	#player_status{check_in = CheckIn} = PS,
	#checkin_status{daily_state = DailyState} = CheckIn,
	TotalCheckDays = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
	DailyStateNew = lists:keystore(TotalCheckDays, 1, DailyState, {TotalCheckDays, ?DAILY_CHECK_CAN_CHECK}),
	NewCheckIn = CheckIn#checkin_status{daily_state = DailyStateNew},
	NewPS = PS#player_status{check_in = NewCheckIn},
	lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_WELFARE, Type, Count, [], 0),
	case pp_welfare:handle(41704, NewPS, [TotalCheckDays, 2]) of  %% 签到
		{ok, LastPS} ->
			LastPS;
		_ ->
			NewPS
	end;
%% 天天冒险(遗迹探宝)
notify_in_ps_do(PS, ?MOD_ADVENTURE, Type, Count, _AdvertisementId) ->
    lib_adventure:add_extra_free_throw_times(PS, Count),
    lib_log_api:log_role_advertisement(PS#player_status.id, ?MOD_ADVENTURE, Type, Count, [], 0),
    pp_adventure:handle(42701, PS, []),
    PS;
notify_in_ps_do(PS, _, _,  _Count, _AdvertisementId) ->
	PS.


act_reset_help(PS, Type, SubType) ->
	#player_status{status_custom_act = ActStatus} = PS,
	case  ActStatus of
		#status_custom_act{reward_map = RewardMap, data_map = DataMap} ->
			TempList = maps:to_list(RewardMap),
			TempList1 = [{{Type1, SubType1, GradeId}, V}  || {{Type1, SubType1, GradeId}, V} <- TempList, Type1 =/= Type],
			RewardMapNew = maps:from_list(TempList1),
			NewDataMap = maps:remove({Type, SubType}, DataMap),
			PS#player_status{status_custom_act = ActStatus#status_custom_act{reward_map = RewardMapNew, data_map = NewDataMap}};
		_ ->
			PS
	end.
