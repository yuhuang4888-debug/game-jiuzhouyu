-module(pp_treasure_hunt).

-export([handle/3]).

-include("server.hrl").
-include("figure.hrl").
-include("treasure_hunt.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("counter.hrl").
-include("language.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

handle(Cmd, Player, Data) ->
	#player_status{figure = Figure} = Player,
	F = fun(T) ->
		lib_treasure_hunt_data:get_open_lv(T) end,
	List = lists:map(F, [?TREASURE_HUNT_TYPE_EUQIP, ?TREASURE_HUNT_TYPE_PEAK, ?TREASURE_HUNT_TYPE_EXTREME, ?TREASURE_HUNT_TYPE_RUNE, ?TREASURE_HUNT_TYPE_BABY]),
	OpenLv = lists:min(List),
	case Figure#figure.lv >= OpenLv of
		true ->
			do_handle(Cmd, Player, Data);
		false ->
			skip
	end.

%% 寻宝界面
do_handle(41601, Player, [Type]) ->
%%    Score = maps:get(?GOODS_ID_THSCORE, Player#player_status.currency_map, 0),  %%暂时不需要积分
%%    NextFreeTime = mod_counter:get_count(Player#player_status.id,  ?MOD_TREASURE_HUNT,  ?COUNT_ID_416_FREE_RUNE_TIME),
%%    {ok, BinData} = pt_416:write(Cmd, [Score, NextFreeTime]),
%%    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
%%	?DEBUG("++++++++++++++++++++++++++++++++++++++++++41601~n", []),
	case Type of
		?TREASURE_HUNT_TYPE_RUNE ->
			NewPs = lib_rune_hunt:get_info(Player),
			{ok, NewPs};
		_ ->
			{ok, Player}
	end;

%% 寻宝记录
do_handle(_Cmd = 41602, Player, [HType,RType]) ->
	#player_status{id = RoleId} = Player,
    mod_treasure_hunt:get_treasure_hunt_record(RoleId, HType, RType),
    {ok, Player};



%% 符文寻宝 特殊处理
do_handle(41604, Player, [HType, Times, AutoBuy]) when HType =:= ?TREASURE_HUNT_TYPE_RUNE ->
    lib_task_api:fin_rune_hurt(Player, Times),
	lib_rune_hunt:hunt(HType, Times, AutoBuy, Player);



%% 寻宝
do_handle(_Cmd = 41604, Player, [HType, Times, AutoBuy]) ->
    Nowtime = utime:unixtime(),
	#player_status{sid = Sid, server_num = ServerNum, id = RoleId, figure = Figure, server_id = ServerId} = Player,
	VaildTimes = ?IF(Times == 1 orelse Times == 10 orelse Times == 50, true, false),
	VaildHType = lists:member(HType, ?TREASURE_HUNT_TYPE_LIST),
	OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
	if
		VaildTimes == false ->
			{ok, Player};
		VaildHType == false ->
			{ok, Player};
		Figure#figure.lv < OpenLv ->
			{ok, Player};
		true ->
			CostGTypeId = lib_treasure_hunt_data:get_cost_gtype_id(HType),
			CostNum = lib_treasure_hunt_data:get_cost_num(HType, Times),
			GoodsStatus = lib_goods_do:get_goods_status(),
			NullCellNum = lib_treasure_hunt_data:get_null_cell_num(GoodsStatus, HType),
			if
				CostGTypeId == 0 ->
					{ok, BinData} = pt_416:write(41604, [?ERRCODE(err_config), HType, Times, 0, []]),
					lib_server_send:send_to_sid(Sid, BinData),
					{ok, Player};
				NullCellNum < Times ->
					{ok, BinData} = pt_416:write(41604, [?ERRCODE(err416_no_null_cell), HType, Times, 0, []]),
					lib_server_send:send_to_sid(Sid, BinData),
					{ok, Player};
				true ->
                    UseTimes = mod_daily:get_count(RoleId, ?MOD_TREASURE_HUNT, HType, HType),
					LimTimes = mod_daily:get_limit_by_sub_module(?MOD_TREASURE_HUNT, HType),
					case UseTimes + Times =< LimTimes of
						true ->
                            if
                                Times == 1 ->
                                    Reply = mod_treasure_hunt:get_free_treasure_hunt(RoleId, HType, Nowtime),
                                    case Reply of
                                        {true, FreeTimes,0} ->
                                            CostList = [],
                                            CdDebuffRatio = lib_module_buff:get_treasure_hunt_cd_buff(Player),
                                            mod_treasure_hunt:set_free_treasure_hunt(RoleId, HType, FreeTimes - 1, Nowtime, CdDebuffRatio);
                                        _ ->
                                            CostList = [{?TYPE_GOODS, CostGTypeId, CostNum}]
                                    end;
                                true ->
                                    CostList = [{?TYPE_GOODS, CostGTypeId, CostNum}]
                            end,
							ConsumeType = lib_treasure_hunt_data:get_consume_type(HType),
							Res = if
								AutoBuy == 1 ->
									lib_goods_api:cost_objects_with_auto_buy(Player, CostList, ConsumeType, HType);
								true ->
									case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, HType) of
										{true, TmpNewPlayer} ->
											{true, TmpNewPlayer, CostList};
										Other ->
											Other
									end
							end,
							case Res of
								{true, NewPlayer, RealCostList} ->
									lib_rune_hunt:handle_act(NewPlayer, RealCostList),
									#figure{name = _RoleRealName, lv = RoleLv, sex = Sex, career = Career, picture = Pic, picture_ver = PicVer, mask_id = MaskId} = Figure,
									RoleName = lib_player:get_wrap_role_name(NewPlayer),
                                    case catch mod_treasure_hunt:treasure_hunt(ServerId, ServerNum, RoleId, RoleName, RoleLv, MaskId, [Sex, Career, Pic, PicVer], HType, Times, AutoBuy) of
										{ok, RewardList, CanUpdate, LuckeyVal, NewLuckeyVal} ->
											%% 日志
											LogReward = [{?TYPE_GOODS, GTypeId, GoodsNum} || #treasure_hunt_reward_cfg{goods_id = GTypeId, goods_num = GoodsNum} <- RewardList],
											LogType = case Times of
												1 ->
													1;
												10 ->
													2;
												50 ->
													3
											end,
											lib_log_api:log_treasure_hunt(RoleId, HType, LogType, AutoBuy, RealCostList, ulists:object_list_merge(LogReward), LuckeyVal, NewLuckeyVal),

											mod_daily:plus_count(RoleId, ?MOD_TREASURE_HUNT, HType, HType, Times),

											RealGiveList = lib_treasure_hunt_mod:handle_treasure_hunt_reward(RoleName, HType, RewardList),
											%% 寻宝获得的物品直接发到玩家的寻宝背包
											ProduceType = lib_treasure_hunt_data:get_produce_type(HType),
											case lib_goods_api:give_goods_to_specify_loc(NewPlayer, ?GOODS_LOC_TREASURE, RealGiveList, ProduceType, 0) of
												{1, GoodsInfoList, _} ->
													F = fun(T) ->
                                                        #treasure_hunt_reward_cfg{goods_id = GTypeId, goods_num = GoodsNum, is_rare = Rare, is_tv = IsTv} = T,
                                                        case lists:keyfind(GTypeId, #goods.goods_id, GoodsInfoList) of
                                                            #goods{id = GoodsId} ->
                                                                {GoodsId, GTypeId, GoodsNum, Rare, IsTv};
                                                            _ ->
                                                                {0, GTypeId, GoodsNum, Rare, IsTv}
                                                        end
                                                    end,
                                                    RewardShowList = [F(T) || T <- RewardList, is_record(T, treasure_hunt_reward_cfg)],
                                                    {ok, BinDataR} = pt_416:write(41604, [?SUCCESS, HType, Times, 0, RewardShowList]),
                                                    lib_server_send:send_to_sid(Sid, BinDataR),
                                                    %% 更新玩家的积分
                                                    ScorePlus = lib_treasure_hunt_data:get_treasure_hunt_score_plus(HType),
                                                    LastPlayer1 = lib_goods_api:send_reward(NewPlayer, [{?TYPE_CURRENCY, ?GOODS_ID_THSCORE, ScorePlus * Times}], ProduceType, 0),
													if
                                                        CanUpdate == false ->
                                                            do_handle(41608, LastPlayer1, [HType, ?OBJECT_TYPE_ALL]);%%默认显示全服记录
                                                        true ->
                                                            skip
                                                    end,
                                                    CallbackData = #callback_join_act{type = ?MOD_TREASURE_HUNT, subtype = HType, times = Times},
                                                    {ok, LastPlayer2} = lib_player_event:dispatch(LastPlayer1, ?EVENT_JOIN_ACT, CallbackData),
                                                    lib_guild_daily:treasure_hunt(HType, RoleId),
													lib_hi_point_api:hi_point_treasure_hunt(RoleId,Figure#figure.lv, HType, Times),
                                                    lib_custom_act_task:trigger(treasure_hunt, RoleId, Figure#figure.lv, HType, Times),
													lib_achievement_api:async_event(RoleId, lib_achievement_api, treasure_hunt_event, {HType,Times}),
													{ok, LastPlayer2};
												_ ->
                                                    ErrorCode = if
                                                        AutoBuy == 1 ->
                                                            ?ERRCODE(err416_gold_not_enougth);
                                                        true ->
                                                            ?ERRCODE(err416_goods_not_enougth)
                                                    end,
													{ok, BinData} = pt_416:write(41604, [ErrorCode, HType, Times, 0, []]),
													lib_server_send:send_to_sid(Sid, BinData),
													{ok, NewPlayer}
											end;
										_Error ->
											?ERR("_Error:~p", [_Error]),
                                            Title = utext:get(4160002),Content = utext:get(4160003),
                                            lib_mail_api:send_sys_mail([RoleId], Title, Content, CostList),
											{ok, BinData} = pt_416:write(41604, [?ERRCODE(system_busy), HType, Times, 0, []]),
											lib_server_send:send_to_sid(Sid, BinData),
											{ok, NewPlayer}
									end;
								{false, ErrorCode, NewPlayer} ->
									{ok, BinData} = pt_416:write(41604, [ErrorCode, HType, Times, 0, []]),
									lib_server_send:send_to_sid(Sid, BinData),
									{ok, NewPlayer}
							end;
						_ ->
							ErrorCode = case HType of
								?TREASURE_HUNT_TYPE_EUQIP ->
									?ERRCODE(err416_equip_htimes_lim);
								?TREASURE_HUNT_TYPE_PEAK ->
									?ERRCODE(err416_peak_htimes_lim);
								?TREASURE_HUNT_TYPE_BABY ->
									?ERRCODE(err416_baby_htimes_lim);
								_ ->
									?ERRCODE(err416_extreme_htimes_lim)
							end,
							{ok, BinData} = pt_416:write(41604, [ErrorCode, HType, Times, 0, []]),
							lib_server_send:send_to_sid(Sid, BinData)
					end
			end
	end;


%% 符文寻宝阶段奖励
do_handle(41607, Player, [BoxId]) ->
	lib_rune_hunt:get_box_reward(Player, BoxId);

%% 取出
do_handle(41605, Ps, [GoodId, FromPos, ToPos])->
	case lib_goods_api:get_goods_info(GoodId) of
		#goods{goods_id = GoodsTypeId, num = Num} ->skip;
		_ ->
			GoodsTypeId = 0,Num = 0
	end,
    {ResCode, NewPs} = lib_goods_do:change_pos(Ps, GoodId, FromPos, ToPos),
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_416, 41605, [ResCode, Num, GoodsTypeId]),
    {ok, NewPs};
do_handle(41606, Ps, _) ->
 	case lib_goods_api:move_goods_from_loc(Ps, ?GOODS_LOC_TREASURE) of
 		{ok, NewPs, GoodsInfoList} ->
 			Fun = fun(GoodsInfo, Acc) ->
		 		#goods{goods_id = GoodsTypeId, num = Num} = GoodsInfo,
		 		% {ResCode, NewPs} = lib_goods_do:change_pos(TemPs, GoodsId, Location, BagLogcation),
		 		[{Num, GoodsTypeId}|Acc]
		 	end,
		 	SendList = lists:foldl(Fun, [], GoodsInfoList),
 			lib_server_send:send_to_sid(NewPs#player_status.sid, pt_416, 41606, [1,SendList]);
 		{false, ResCode} ->
 			NewPs = Ps,
 			lib_server_send:send_to_sid(NewPs#player_status.sid, pt_416, 41606, [ResCode,[]])
 	end,
 	{ok, NewPs};

%%装备寻宝界面展示
do_handle(41608, Player, [HType, Type]) ->
    Score = lib_goods_api:get_currency(Player, ?GOODS_ID_THSCORE),
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
    if
    	OpenLv =< RoleLv ->
    		mod_treasure_hunt:equip_hunt_show(RoleId, RoleLv, HType, Type, Score);
    	true ->
    		skip
    end,
    {ok, Player};

%% 积分商城兑换
do_handle(41609, Player, [ShopId]) ->
    {ok, NewPs} = lib_treasure_hunt_data:exchang_score(Player, ShopId),
    {ok,NewPs};

%% 符文夺宝获取幸运值
do_handle(41610, Player, [HType]) when HType =:= ?TREASURE_HUNT_TYPE_RUNE->
	#player_status{rune_hunt = RuneHunt, sid = Sid} = Player,
	#rune_hunt{luck_value = LuckyValue} = RuneHunt,
	Pers = lib_rune_hunt:get_rune_show_percent(LuckyValue),
	{ok, BinTwo} = pt_416:write(41610, [?TREASURE_HUNT_TYPE_RUNE, LuckyValue, Pers]),
	lib_server_send:send_to_sid(Sid, BinTwo);

do_handle(41610, Player, [HType]) ->
	mod_treasure_hunt:get_luckey_value(Player#player_status.server_id, HType, Player#player_status.id),
	{ok, Player};

%% 跨服抽奖记录
do_handle(41612, Player, [HType]) ->
    OpenDayLimit = case data_treasure_hunt:get_cfg(kf_use_kf_luckey_value) of
                        OpenDayCfg when is_integer(OpenDayCfg) -> OpenDayCfg;
                        _ -> 8
                   end,
    OpenDay = util:get_open_day(),
    if
        OpenDay >= OpenDayLimit ->
            mod_cluster_luckey_value:cast_center([{'get_treasure_hunt_record', Player#player_status.server_id, HType, Player#player_status.id}]);
        true ->
            lib_server_send:send_to_uid(Player#player_status.id, pt_416, 41612, [HType, []])
    end,

    {ok, Player};

do_handle(41613, Player, [HType]) ->
    #player_status{id = RoleId} = Player,
    Num = mod_counter:get_count(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_CHOOSE),
    Res = get_resoult_from_conter(Num, HType),
    lib_server_send:send_to_uid(RoleId, pt_416, 41613, [HType, Res]),
    {ok, Player};

do_handle(41614, Player, [HType]) ->
    #player_status{id = RoleId} = Player,
    Num = mod_counter:get_count(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_CHOOSE),
    RealNum = calc_num_from_conter(Num, HType),
    mod_counter:set_count(RoleId, ?MOD_TREASURE_HUNT, ?COUNT_ID_416_EQUIP_CHOOSE, RealNum),
    {ok, Player};



%% 获取任务列表
do_handle(41620, #player_status{sid = Sid} = Player, [HType]) ->
    case lib_treasure_hunt_data:get_hunt_task_by_type(HType, Player) of
    	{ok, TreasureHuntTask, NewPS} ->
    		#treasure_hunt_task{task_list = TaskList} = TreasureHuntTask,
    		SendTaskList = [{TaskId, Num, State} ||#task_info{id = TaskId, num = Num, state = State} <- TaskList],
    		?PRINT("41620 41620### SendTaskList ~p~n", [SendTaskList]),
    		lib_server_send:send_to_sid(Sid, pt_416, 41620, [?SUCCESS, HType, SendTaskList]),
    		{ok, NewPS};
    	{false, Res} ->
    		lib_server_send:send_to_sid(Sid, pt_416, 41620, [Res, HType, []])
    end;

%% 领取任务奖励
do_handle(41622, #player_status{sid = Sid} = Player, [HType, TaskId]) ->
    case lib_treasure_hunt_data:get_hunt_task_reward(Player, HType, TaskId) of
    	{ok, NewPS, ReturnArgs} ->
    		[TaskInfo, RewardList] = ReturnArgs,
    		#task_info{num = Num, state = State} = TaskInfo,
    		lib_server_send:send_to_sid(Sid, pt_416, 41622, [?SUCCESS, HType, TaskId, Num, State, RewardList]),
    		{ok, NewPS};
    	{false, Res} ->
    		lib_server_send:send_to_sid(Sid, pt_416, 41622, [Res, HType, TaskId, 0, 0, []])
    end;

do_handle(_Cmd, _Player, _Data) ->
	{error, "pp_treasure_hunt no match~n"}.

get_resoult_from_conter(Num, HType) ->
    case Num of
        0 -> % 000 3位2进制表示寻宝类型是否第一次打开界面
            0;
        1 -> % 001
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    1;
                true ->
                    0
            end;
        2 -> % 010
            if
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    1;
                true ->
                    0
            end;
        3 -> % 011
            if
                HType == ?TREASURE_HUNT_TYPE_EXTREME ->
                    0;
                true ->
                    1
            end;
        4 -> % 100
            if
                HType == ?TREASURE_HUNT_TYPE_EXTREME ->
                    1;
                true ->
                    0
            end;
        5 -> % 101
            if
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    0;
                true ->
                    1
            end;
        6 -> % 110
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    0;
                true ->
                    1
            end;
        true -> % 111
            1
    end.

calc_num_from_conter(Num, HType) ->
    case Num of
        0 -> % 000 3位2进制表示寻宝类型是否第一次打开界面
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    1;
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    2;
                true ->
                    4
            end;
        1 -> % 001
            if
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    3;
                HType == ?TREASURE_HUNT_TYPE_EXTREME ->
                    5;
                true ->
                    1
            end;
        2 -> % 010
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    3;
                HType == ?TREASURE_HUNT_TYPE_EXTREME ->
                    6;
                true ->
                    2
            end;
        3 -> % 011
            if
                HType == ?TREASURE_HUNT_TYPE_EXTREME ->
                    7;
                true ->
                    3
            end;
        4 -> % 100
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    5;
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    6;
                true ->
                    4
            end;
        5 -> % 101
            if
                HType == ?TREASURE_HUNT_TYPE_PEAK ->
                    7;
                true ->
                    5
            end;
        6 -> % 110
            if
                HType == ?TREASURE_HUNT_TYPE_EUQIP ->
                    7;
                true ->
                    6
            end;
        true -> % 111
            7
    end.
% %% 发送错误码
% send_error_code(Sid, ErrorCode) ->
% 	{ok, BinData} = pt_416:write(41600, [ErrorCode]),
% 	lib_server_send:send_to_sid(Sid, BinData).

%%send_tv([{GTypeId, 1} | T], GoodsInfoList, HType, RoleName) ->
%%	case lists:keyfind(GTypeId, #goods.goods_id, GoodsInfoList) of
%%		false ->
%%			skip;
%%		_ ->
%%			TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
%%			case data_goods_type:get(GTypeId) of
%%				#ets_goods_type{goods_name = GoodsName, color = Color} ->
%%					skip;
%%				_ ->
%%					GoodsName = "", Color = 0
%%			end,
%%			lib_chat:send_TV({all}, ?MOD_TREASURE_HUNT, HType, [RoleName, TreasureHuntName, Color, GoodsName])
%%	end,
%%	send_tv(T, GoodsInfoList, HType, RoleName);
%%
%%send_tv([_ | T], GoodsInfoList, HType, RoleName) ->
%%	send_tv(T, GoodsInfoList, HType, RoleName);
%%
%%send_tv([], _, _, _) ->
%%	ok.
