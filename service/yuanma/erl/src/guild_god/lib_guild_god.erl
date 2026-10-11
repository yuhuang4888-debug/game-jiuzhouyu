%%%-----------------------------------
%%% @Module      : lib_guild_god
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十二月 2019 16:34
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_guild_god).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("guild_god.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("rec_offline.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").


login(PS) ->
	#player_status{id = RoleId, pid = Pid, off = Off} = PS,
	case is_pid(Pid) of
		true ->
			GoodsStatus = lib_goods_do:get_goods_status(),
			#goods_status{dict = GoodsDict} = GoodsStatus;
		_ ->
			#goods_status{dict = GoodsDict} = Off#status_off.goods_status
	end,
	AllRuneList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_GOD_GUILD_GOD_EQUIP, GoodsDict),
	Sql = io_lib:format(?select_guild_god_role, [RoleId]),
	GodsList = db:get_all(Sql),
	F = fun([GodId, ComboId, Achievement, Color, Lv], AccGodList) ->
		RuneList = calc_equip_list(GodId, AllRuneList),
		God = #guild_god{id = GodId, combo_id = ComboId, achievement = util:bitstring_to_term(Achievement),
			lv = Lv, color = Color, rune_list = RuneList},
		[God | AccGodList]
	    end,
	NewGodsList = lists:foldl(F, [], GodsList),
	PS#player_status{guild_god = #guild_god_in_ps{god_list = NewGodsList}}.



calc_equip_list(GodId, AllRuneList) ->
	Fun = fun
		(#goods{id = Id, other = GOther, cell = Pos, goods_id = GoodsId}, Acc) ->
			case GOther of
				#goods_other{optional_data = [GodId]} -> [#guild_god_rune{pos = Pos, auto_id = Id, goods_type_id = GoodsId} | Acc];
				_ -> Acc
			end;
		(_, Acc) -> Acc
		end,
	lists:foldl(Fun, [], AllRuneList).



get_info(PS) ->
	#player_status{guild_god = GuildGod, id = RoleId, original_attr = OriginalAttr } = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	Ids = data_guild_god:get_all_god_ids(),
	{ok, GuildTitleLv} = mod_guild_prestige:get_high_guild_title(RoleId),
	F = fun(Id, AccList) ->
		case lists:keyfind(Id, #guild_god.id, GodList) of
			#guild_god{color = Color, lv = AwakeLv} = GodInfo ->
				GodAttrL = get_attr(GodInfo),
				GodPower = lib_player:calc_partial_power(OriginalAttr, 0, GodAttrL),
				[{Id, Color, AwakeLv, GodPower} | AccList];
			_ ->
				[{Id, 0, 0, 0} | AccList]
		end
	    end,
	PackList = lists:foldl(F, [], Ids),
	{ok, Bin} = pt_405:write(40501, [GuildTitleLv, PackList]),
	lib_server_send:send_to_uid(RoleId, Bin).


check_god_awake(RoleLv, GuildLv, Id, GuildTileLv) ->
	OpenDay = util:get_open_day(),
	case data_guild_god:get_god_awake_condition(Id) of
		[] -> true;
		[{guild_title_lv, NeedGuildTileLv}, {role_lv, NeedRoleLv}, {guild_lv, NeedGuildLv}, {open_day, NeedOpenDay}] ->
			if
				RoleLv < NeedRoleLv -> false;
				GuildLv < NeedGuildLv -> false;
				OpenDay < NeedOpenDay -> false;
				GuildTileLv < NeedGuildTileLv -> false;
				true -> true
			end;
		_ -> false
	end.



get_god_rune_info(GodId, PS) ->
	#player_status{figure = F, guild = Guild, id = RoleId, guild_god = GuildGod, original_attr = OriginalAttr} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	{ok, GuildTitleLv} = mod_guild_prestige:get_high_guild_title(RoleId),
	case check_god_awake(F#figure.lv, Guild#status_guild.lv, GodId, GuildTitleLv) of
		true ->
			case lists:keyfind(GodId, #guild_god.id, GodList) of
				#guild_god{rune_list = RuneList, combo_id = ComboId, achievement = AchLvs} = GodInfo->
					Pack = [{Pos, AutoId, TypeId} || #guild_god_rune{pos = Pos, auto_id = AutoId, goods_type_id = TypeId} <- RuneList],
					NewComboId =
						case lib_guild_god_util:check_combo(GodId, ComboId, RuneList) of
							true -> ComboId;
							_ -> 0
						end,
					NewAchLvs = get_right_achievement_lvs(RuneList, AchLvs),
					GodAttrL = get_attr(GodInfo),
					GodPower = lib_player:calc_partial_power(OriginalAttr, 0, GodAttrL),
					{ok, Bin} = pt_405:write(40502, [GodId, Pack, NewComboId, NewAchLvs, GodPower]),
					lib_server_send:send_to_uid(RoleId, Bin);
				_ ->
					{ok, Bin} = pt_405:write(40502, [GodId, [], 0, [], 0]),
					lib_server_send:send_to_uid(RoleId, Bin)
			end;
		_ -> %% 未觉醒
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_awake))
	end.




%% -----------------------------------------------------------------
%% @desc     功能描述   神像升品
%% @param    参数      GodId::神像id
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
update_color(GodId, PS) ->
	#player_status{guild_god = GuildGod, figure = F, guild = Guild, id = RoleId} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	{ok, GuildTitleLv} = mod_guild_prestige:get_high_guild_title(RoleId),
	case check_god_awake(F#figure.lv, Guild#status_guild.lv, GodId, GuildTitleLv) of
		true ->
			OldGod = ulists:keyfind(GodId, #guild_god.id, GodList, #guild_god{id = GodId, color = 0, lv = 0, combo_id = 0}),
			#guild_god{color = NowColor} = OldGod,
			case data_guild_god:get_next_color_cost(GodId, NowColor) of
				[] ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_max_color)),
					PS;
				Cost ->
					case lib_goods_api:cost_object_list_with_check(PS, Cost, guild_god_upgrade_color, "") of
						{true, NewPs} ->  %% 消耗可以
							LastPS = do_update_color(NewPs, OldGod),
							LastPS;
						{false, Error, _} ->
							pp_guild_god:send_error(RoleId, Error),
							PS
					end
			end;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_awake)),
			PS
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  升品
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_update_color(PS, OldGod) ->
	#player_status{id = RoleId, guild_god = GuildGod, figure = Figure, original_attr = OriginalAttr} = PS,
	#guild_god_in_ps{god_list = List} = GuildGod,
	#guild_god{color = OldColor, id = GodId, lv = Lv, combo_id = OldComboId, achievement = AchLvs} = OldGod,
	NewGod = OldGod#guild_god{color = OldColor + 1},
	%% 同步数据库
	save_god_to_db(RoleId, NewGod),
	NewList = lists:keystore(GodId, #guild_god.id, List, NewGod),
	NewGuildGod = GuildGod#guild_god_in_ps{god_list = NewList},
	NewPS = PS#player_status{guild_god = NewGuildGod},
	%%log
	lib_log_api:log_guild_god(RoleId, GodId, ?log_type1,
		OldColor, Lv, OldComboId, AchLvs, OldColor + 1, Lv, OldComboId, AchLvs),
	%% 传闻
	GodName = data_guild_god:get_god_name(GodId),
	SendColor = ?IF(OldColor + 1 == ?DARK_GOLD, ?PINK, OldColor + 1),
	ColorName = data_color:get_name(SendColor),
	if
		OldColor == 0 ->
			lib_chat:send_TV({all}, ?MOD_GUILD_GOD, 1, [Figure#figure.name, OldColor + 1 , GodName]);
		true ->
			lib_chat:send_TV({all}, ?MOD_GUILD_GOD, 2, [Figure#figure.name, OldColor, GodName, SendColor, ColorName])
	end,
	%% 计算属性
	PS2 = lib_player:count_player_attribute(NewPS),
	lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),     %%主动推送信息
	GodAttrL = get_attr(NewGod),
	GodPower = lib_player:calc_partial_power(OriginalAttr, 0, GodAttrL),
	{ok, Bin} = pt_405:write(40503, [GodId, OldColor + 1, Lv, GodPower]),
	lib_server_send:send_to_uid(RoleId, Bin),
	%%通知场景
	mod_scene_agent:update(PS2, [{battle_attr, PS2#player_status.battle_attr}]),
	PS2.




update_awake_lv(GodId, PS) ->
	#player_status{guild_god = GuildGod, figure = F, guild = Guild, id = RoleId} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	{ok, GuildTitleLv} = mod_guild_prestige:get_high_guild_title(RoleId),
	case check_god_awake(F#figure.lv, Guild#status_guild.lv, GodId, GuildTitleLv) of
		true ->
			OldGod = ulists:keyfind(GodId, #guild_god.id, GodList, #guild_god{id = GodId, color = 0, lv = 0, combo_id = 0}),
			#guild_god{lv = GodLv} = OldGod,
			case data_guild_god:get_next_lv_cost(GodId, GodLv) of
				[] ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_max_awake_lv)),
					PS;
				Cost ->
					case lib_goods_api:cost_object_list_with_check(PS, Cost, guild_god_upgrade_awake_lv, "") of
						{true, NewPs} ->  %% 消耗可以
							LastPS = do_update_awake(NewPs, OldGod),
							LastPS;
						{false, Error, _} ->
							pp_guild_god:send_error(RoleId, Error),
							PS
					end
			end;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_awake)),
			PS
	end.

do_update_awake(PS, OldGod) ->
	#player_status{id = RoleId, guild_god = GuildGod, figure = Figure, original_attr = OriginalAttr} = PS,
	#guild_god_in_ps{god_list = List} = GuildGod,
	#guild_god{lv = AwakeLv, id = GodId, color = Color, combo_id = ComboId, achievement = AchLvs} = OldGod,
	NewGod = OldGod#guild_god{lv = AwakeLv + 1},
	%% log
	lib_log_api:log_guild_god(RoleId, GodId, ?log_type2,
		Color, AwakeLv, ComboId, AchLvs, Color, AwakeLv + 1, ComboId, AchLvs),
	%% tv
	GodName = data_guild_god:get_god_name(GodId),
	SendColor = ?IF(Color == ?DARK_GOLD, ?PINK, Color),
	lib_chat:send_TV({all}, ?MOD_GUILD_GOD, 3, [Figure#figure.name, SendColor, GodName, AwakeLv + 1]),
	%% 同步数据库
	save_god_to_db(RoleId, NewGod),
	NewList = lists:keystore(GodId, #guild_god.id, List, NewGod),
	NewGuildGod = GuildGod#guild_god_in_ps{god_list = NewList},
	NewPS = PS#player_status{guild_god = NewGuildGod},
	%% 计算属性
	PS2 = lib_player:count_player_attribute(NewPS),
	lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),     %%主动推送信息
	GodAttrL = get_attr(NewGod),
	GodPower = lib_player:calc_partial_power(OriginalAttr, 0, GodAttrL),
	{ok, Bin} = pt_405:write(40504, [GodId, Color, AwakeLv + 1, GodPower]),
	lib_server_send:send_to_uid(RoleId, Bin),
	%%通知场景
	mod_scene_agent:update(PS2, [{battle_attr, PS2#player_status.battle_attr}]),
	PS2.



%% -----------------------------------------------------------------
%% @desc     功能描述  穿戴
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
wear(PS, GodId, Pos, GoodsAutoId) ->
	#player_status{figure = Figure, guild = Guild, id = RoleId} = PS,
	{ok, GuildTitleLv} = mod_guild_prestige:get_high_guild_title(RoleId),
	case check_god_awake(Figure#figure.lv, Guild#status_guild.lv, GodId, GuildTitleLv) of
		true ->
			GoodsStatus = lib_goods_do:get_goods_status(),
			#player_status{guild_god = GuildGod} = PS,
			#guild_god_in_ps{god_list = GodList} = GuildGod,
			case lists:keyfind(GodId, #guild_god.id, GodList) of
				false ->
					OldGod = #guild_god{id = GodId};
				#guild_god{} = OldGod ->
					ok
			end,
			#guild_god{rune_list = RuneList} = OldGod,
%%			G = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
			case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
				#goods{location = Loc} when Loc =/= ?GOODS_LOC_GOD_GUILD_GOD_BAG ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_error_loc));
				#goods{type = ?GOODS_TYPE_GUILD_GOD, cell = _BagCell, other = Other} = TakeOnGoodsInfo ->  %%要穿戴的铭文
					case lib_guild_god_util:check_equip(GodId, TakeOnGoodsInfo) of
						true ->
							{TakeoffGoods, NewEquipList1} =
								lib_guild_god_util:calc_takeoff_equips(Pos, RuneList, GoodsStatus#goods_status.dict),  %%计算脱下的铭文
							F = fun
								    () ->
									    ok = lib_goods_dict:start_dict(),
									    TakeOffGoodsInfo
										    = case lists:keyfind(Pos, #guild_god_rune.pos, RuneList) of
											      #guild_god_rune{pos = Pos, auto_id = AutoId, goods_type_id = _GoodTypeId} ->
												      OGoodsInfo = lib_goods_util:get_goods(AutoId, GoodsStatus#goods_status.dict),
												      #goods{other = _other} = OGoodsInfo,
												      OGoodsInfo#goods{other = _other#goods_other{optional_data = []}};
											      _ ->
												      []
										      end,
									    if
										    is_record(TakeOffGoodsInfo, goods) ->
											    lib_god_util:change_goods_other(TakeOffGoodsInfo),
											    [_, GoodsStatus1] = lib_goods:change_goods_cell(TakeOffGoodsInfo, ?GOODS_LOC_GOD_GUILD_GOD_BAG, 0, GoodsStatus);
										    true ->
											    GoodsStatus1 = GoodsStatus
									    end,
									    %%更新要穿戴装备关于公会神像的数据
									    TakeOnGoodsInfo1 = TakeOnGoodsInfo#goods{other = Other#goods_other{optional_data = [GodId]}},
									    lib_guild_god_util:change_goods_other(TakeOnGoodsInfo1),
									    [TakeOnGoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(TakeOnGoodsInfo1, ?GOODS_LOC_GOD_GUILD_GOD_EQUIP, Pos, GoodsStatus1),
									    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
									    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
									    NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},
									    {ok, GoodsL, NewGoodsStatus, TakeOnGoodsInfo2}
							    end,
							case lib_goods_util:transaction(F) of
								{ok, GoodsL, NewGoodsStatus, #goods{goods_id = GoodsTypeId}} ->
									%% {Pos, GoodsAutoId, GoodsTypeId}
									NewEquipList = lists:keystore(Pos, #guild_god_rune.pos, NewEquipList1,
										#guild_god_rune{pos = Pos, auto_id = GoodsAutoId, goods_type_id = GoodsTypeId}),
									lib_goods_do:set_goods_status(NewGoodsStatus),
									% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
									if
										TakeoffGoods =/= [] ->
											#goods{id = LogGoodAutoId, goods_id = LogGoodsTypeId} = hd(TakeoffGoods),
											%% 穿戴日志
											lib_log_api:log_guild_god_equip_rune(RoleId, GodId, Pos, LogGoodAutoId, LogGoodsTypeId, GoodsAutoId, GoodsTypeId),
											[lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num = 0}]) || GoodsInfo1 <- TakeoffGoods];
										true ->
											%%  穿戴日志
											lib_log_api:log_guild_god_equip_rune(RoleId, GodId, Pos, 0, 0, GoodsAutoId, GoodsTypeId),
											skip
									end,
									lib_goods_api:notify_client_num(RoleId, [TakeOnGoodsInfo#goods{num = 0}]),
									lib_goods_api:notify_client(RoleId, GoodsL),
									NewGod = OldGod#guild_god{rune_list = NewEquipList},
									save_god_to_db(RoleId, NewGod),
									NewGodList = lists:keystore(GodId, #guild_god.id, GodList, NewGod),
									NewPS = PS#player_status{guild_god = GuildGod#guild_god_in_ps{god_list = NewGodList}},
									LastPS = lib_guild_god_util:update_god_power(NewPS), %%重新计算战力
									pp_guild_god:handle(40502, LastPS, [GodId]), %% 推送40502
									LastPS;
								_Err ->
									pp_guild_god:send_error(RoleId, ?FAIL),
									PS
							end;
						{false, ErrCode} ->
							pp_guild_god:send_error(RoleId, ErrCode),
							PS
					end;
				_ ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_guilld_god_rune)),
					PS
			end;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_awake)),
			PS
	end.



take_off(PS, GodId, Pos) ->
	#player_status{guild_god = StatusGod, id = RoleId} = PS,
	#guild_god_in_ps{god_list = GodList} = StatusGod,
	GoodsStatus = lib_goods_do:get_goods_status(),
	GoodsStatus = lib_goods_do:get_goods_status(),
	#player_status{guild_god = GuildGod} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	case lists:keyfind(GodId, #guild_god.id, GodList) of
		false ->
			OldGod = #guild_god{id = GodId};
		#guild_god{} = OldGod ->
			ok
	end,
	#guild_god{rune_list = EquipList} = OldGod,
	{TakeoffGoods, NewEquipList} = lib_guild_god_util:calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
	if
		TakeoffGoods =:= [] ->
			pp_guild_god:send_error(RoleId, ?FAIL);
		true ->
			F = fun
				    () ->
					    ok = lib_goods_dict:start_dict(),
					    F2 = fun
						         (GoodsInfo, GoodsStatusAcc) ->
							         [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_GOD_GUILD_GOD_BAG, 0, GoodsStatusAcc),
							         NewGoodsStatusAcc
					         end,
					    TakeoffEndGoods = lib_guild_god_util:takeoff_equips(TakeoffGoods),
					    GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods),
					    #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
					    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
					    NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
					    [lib_guild_god_util:change_goods_other(G) || G <- TakeoffEndGoods],
					    %%  log
					    [lib_log_api:log_guild_god_equip_rune(RoleId, GodId, Pos, LogGoodsAutoId, LogGoodsTypeId, 0, 0)
						    || #goods{id = LogGoodsAutoId, goods_id = LogGoodsTypeId} <- TakeoffEndGoods],
					    {ok, GoodsL, NewGoodsStatus}
			    end,
			case lib_goods_util:transaction(F) of
				{ok, GoodsL, NewGoodsStatus} ->
					lib_goods_do:set_goods_status(NewGoodsStatus),
					%% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
					[lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num = 0}]) || GoodsInfo <- TakeoffGoods],
					lib_goods_api:notify_client(RoleId, GoodsL),
					NewGod = OldGod#guild_god{rune_list = NewEquipList},
					NewGodList = lists:keystore(GodId, #guild_god.id, GodList, NewGod),
					NewPS = PS#player_status{guild_god = GuildGod#guild_god_in_ps{god_list = NewGodList}},
					LastPS = lib_guild_god_util:update_god_power(NewPS), %%重新计算战力
					pp_guild_god:handle(40502, LastPS, [GodId]), %% 推送40502
					LastPS;
				Error ->
					pp_guild_god:send_error(RoleId, Error)
			end %% lib_goods_util:transaction(F)
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述    激活组合
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
awake_combo(PS, GodId, ComboId) ->
	#player_status{guild_god = StatusGod, id = RoleId, figure = Figure} = PS,
	#guild_god_in_ps{god_list = GodList} = StatusGod,
	GoodsStatus = lib_goods_do:get_goods_status(),
	GoodsStatus = lib_goods_do:get_goods_status(),
	#player_status{guild_god = GuildGod} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	case lists:keyfind(GodId, #guild_god.id, GodList) of
		false ->
			OldGod = #guild_god{id = GodId};
		#guild_god{} = OldGod ->
			ok
	end,
	#guild_god{rune_list = RuneList, color = Color, lv = GodLv, combo_id = OldComboId, achievement = AchLvs, last_combo_tv = LastTime} = OldGod,
	case lib_guild_god_util:check_combo(GodId, ComboId, RuneList) of
		true ->
			NewGod = OldGod#guild_god{combo_id = ComboId},
			%%  log
			lib_log_api:log_guild_god(RoleId, GodId, ?log_type3,
				Color, GodLv, OldComboId, AchLvs, Color, GodLv, ComboId, AchLvs),
			save_god_to_db(RoleId, NewGod),
			%% tv
			
			GodName = data_guild_god:get_god_name(GodId),
			ComboName = data_guild_god:get_combo_name(ComboId),
			Time = data_guild_god:get_kv(combo_tv_time),
			Now = utime:unixtime(),
			if
				Now - LastTime >= Time ->
					NewLastTime = Now,
					SendColor = ?IF(Color == ?DARK_GOLD, ?PINK, Color),
					lib_chat:send_TV({all}, ?MOD_GUILD_GOD, 5, [Figure#figure.name, SendColor, GodName, ComboName]);
				true ->
					NewLastTime = LastTime
			end,
			NewGodList = lists:keystore(GodId, #guild_god.id, GodList, NewGod#guild_god{last_combo_tv = NewLastTime}),
			NewPS = PS#player_status{guild_god = GuildGod#guild_god_in_ps{god_list = NewGodList}},
			LastPS = lib_guild_god_util:update_god_power(NewPS), %%重新计算战力
			pp_guild_god:handle(40502, LastPS, [GodId]), %% 推送40502
			LastPS;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_can_not_awake_combo))
	end.


%%
save_god_to_db(RoleId, God) ->
	#guild_god{color = Color, lv = Lv, achievement = Lvs, combo_id = ComboId, id = GodId} = God,
	Sql = io_lib:format(?save_guild_god_role, [RoleId, GodId, Color, Lv, ComboId, util:term_to_bitstring(Lvs)]),
%%	?MYLOG("cym", "~s", [Sql]),
	db:execute(Sql).



%% 获取公会神像的属性
get_attr(PS) when is_record(PS, player_status) ->
	#player_status{guild_god = GuildGod} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	F = fun(#guild_god{color = Color, id = GodId, lv = Lv, rune_list = RuneList, combo_id = ComboId, achievement = AchIds}, AccAttr) ->
		%% 品质属性
		ColorAttr = data_guild_god:get_color_attr(GodId, Color),
		%% 等级属性属性
		LvAttr = data_guild_god:get_lv_attr(GodId, Lv),
		%%符文属性
		RuneAttr = get_rune_attr(ComboId, RuneList, GodId, AchIds),
%%		?MYLOG("attr", "RuneAttr ~p~n", [{AccAttr, ColorAttr , LvAttr , RuneAttr}]),
		AccAttr ++ ColorAttr ++ LvAttr ++ RuneAttr
	end,
	Attr = lists:foldl(F, [], GodList),
	LastAttr = util:combine_list(Attr),
%%	?MYLOG("attr", "Attr ~p~n", [LastAttr]),
	LastAttr;
get_attr(GuildGodInfo) ->
	#guild_god{
		color = Color, id = GodId, lv = Lv, rune_list = RuneList, combo_id = ComboId, achievement = AchIds
	} = GuildGodInfo,
	%% 品质属性
	ColorAttr = data_guild_god:get_color_attr(GodId, Color),
	%% 等级属性属性
	LvAttr = data_guild_god:get_lv_attr(GodId, Lv),
	%%符文属性
	RuneAttr = get_rune_attr(ComboId, RuneList, GodId, AchIds),
	ColorAttr ++ LvAttr ++ RuneAttr.




get_combo_attr(0, _RuneList, _GodId) ->
	[];
get_combo_attr(ComboId, RuneList, GodId) ->
	case lib_guild_god_util:check_combo(GodId, ComboId, RuneList) of
		true ->
			case data_guild_god:get_combo_cfg(GodId, ComboId) of
				#guild_god_combo_cfg{attr_skill = List} ->
					case lists:keyfind(attr, 1, List) of
						{_, Attr} ->
							Attr;
						_ ->
							[]
					end;
				_ ->
					[]
			end;
		_ ->
			[]
	end.

get_rune_attr(ComboId, RuneList, GodId, AchIds) ->
%%	?MYLOG("cym", "ComboId, RuneList, GodId ~p~n", [{ComboId, RuneList, GodId}]),
	ComboAttr = get_combo_attr(ComboId, RuneList, GodId),  %% 组合属性
%%	?MYLOG("cym", "ComboAttr ~p~n", [ComboAttr]),
	{_RuneLv, RuneAttr} = get_only_rune_attr_and_rune_lv(RuneList),
	Ratio = get_achievement_ratio(RuneList, AchIds, GodId),
%%	?MYLOG("cym", "Ratio ~p~n", [Ratio]),
	F = fun({AttrId, Value}, AccAttr) ->
		NewValue = erlang:round(Value * Ratio),
		if
			NewValue =< 0 ->
				AccAttr;
			true ->
				[{AttrId, NewValue} | AccAttr]
		end
	    end,
%%	?MYLOG("cym", "ComboAttr ~p~n", [ComboAttr]),
	NewComboAttr = lists:foldl(F, [], ComboAttr),
%%	?MYLOG("cym", "NewComboAttr ~p~n", [NewComboAttr]),
	util:combine_list(NewComboAttr ++ RuneAttr).



%% -----------------------------------------------------------------
%% @desc     功能描述  获得符文属性(不包括combo属性和铭文大师属性)和符文总等级
%% @param    参数
%% @return   返回值   {RuneLv, Attr}
%% @history  修改历史
%% -----------------------------------------------------------------
get_only_rune_attr_and_rune_lv(RuneList) ->
	F = fun(#guild_god_rune{goods_type_id = TypeId}, {AllLv, AccAttr}) ->
		case data_guild_god:get_rune_cfg(TypeId) of
			#guild_rune_cfg{attr = Attr, lv = Lv} ->
				{AllLv + Lv, AccAttr ++ Attr};
			_ ->
				{AllLv, AccAttr}
		end
	    end,
	lists:foldl(F, {0, []}, RuneList).



get_achievement_ratio(RuneList, AchIds, GodId) ->
	F = fun(AchievementLv, SumRatio) ->
		Res = check_achievement_lv(RuneList, AchievementLv),
		if
			Res == true ->
				case data_guild_god:get_rune_achievement_attr(GodId, AchievementLv) of
					[] ->
						SumRatio;
					Ratio ->
						SumRatio + Ratio
				end;
			true ->
				SumRatio
		end
	    end,
	lists:foldl(F, 100, AchIds) / 100.



%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_right_achievement_lvs(RuneList, AchLvs) ->
%%	{RuneLv, _} = get_only_rune_attr_and_rune_lv(RuneList),
	[Lv || Lv <- AchLvs,  check_achievement_lv(RuneList, Lv) == true].

%% 铭文升级升级
rune_upgrade(PS, GodId, Pos) ->
	#player_status{guild_god = GuildGod, id = RoleId} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	case lists:keyfind(GodId, #guild_god.id, GodList) of
		#guild_god{rune_list = RuneList} = OldGod ->
			case lists:keyfind(Pos, #guild_god_rune.pos, RuneList) of
				#guild_god_rune{auto_id = GoodsAutoId, goods_type_id = OldGoodsTypeId} = OldRune ->
					case data_guild_god:get_rune_cfg(OldGoodsTypeId) of
						#guild_rune_cfg{cost = Cost, new_goods_id = TargetGoodsTypeId} when TargetGoodsTypeId > 0 ->
							case lib_goods_api:cost_object_list_with_check(PS, Cost, guild_god_rune_upgrade, "") of
								{true, NewPs} ->
									ok = lib_goods_dict:start_dict(),
									GoodsStatus = lib_goods_do:get_goods_status(),
									RuneGoodsInfo = lib_goods_api:get_goods_info(GoodsAutoId, GoodsStatus),
									#goods{id = GoodsId} = RuneGoodsInfo,
									#ets_goods_type{
										level = NewLv,
										color = NewColor,
										addition = NewAddition
									} = data_goods_type:get(TargetGoodsTypeId),
									{NewPriceType, NewPrice} = data_goods:get_goods_buy_price(TargetGoodsTypeId),
									%% 升级日志
									lib_log_api:log_guild_god_rune_upgrade(RoleId, GodId, Pos, GoodsAutoId, OldGoodsTypeId, GoodsAutoId, TargetGoodsTypeId),
									Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
										[NewPriceType, NewPrice, GoodsId]),
									db:execute(Sql),
									Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, color = ~p, bind = ~p, addition = '~s', extra_attr = '~s' where gid = ~p">>,
										[TargetGoodsTypeId, NewLv, NewColor, 0, util:term_to_string(NewAddition), [], GoodsId]),
									db:execute(Sql1),
									Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
										[TargetGoodsTypeId, GoodsId]),
									db:execute(Sql2),
									NewRuneGoodsInfo = RuneGoodsInfo#goods{
										goods_id = TargetGoodsTypeId,
										price_type = NewPriceType,
										price = NewPrice,
										level = NewLv,
										color = NewColor
									},
									NewGoodsStatus1 = lib_goods:change_goods(NewRuneGoodsInfo, ?GOODS_LOC_GOD_GUILD_GOD_EQUIP, GoodsStatus),
									{Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus1#goods_status.dict),
									NewGoodsStatus2 = NewGoodsStatus1#goods_status{
										dict = Dict
									},
									lib_goods_do:set_goods_status(NewGoodsStatus2),
									%% 更新客户端缓存
									lib_goods_api:notify_client_num(RoleId, GoodsL),
									lib_goods_api:update_client_goods_info([NewRuneGoodsInfo]),
									lib_goods_api:notify_client(NewPs, [NewRuneGoodsInfo]),
									NewRuneList = lists:keystore(Pos, #guild_god_rune.pos, RuneList,
										OldRune#guild_god_rune{goods_type_id = TargetGoodsTypeId}),
									NewGod = OldGod#guild_god{rune_list = NewRuneList},
									NewGodList = lists:keystore(GodId, #guild_god.id, GodList, NewGod),
									LastPS = NewPs#player_status{guild_god = GuildGod#guild_god_in_ps{god_list = NewGodList}},
									LastPS2 = lib_guild_god_util:update_god_power(LastPS), %%重新计算战力
									pp_guild_god:handle(40502, LastPS2, [GodId]),
									{ok, Bin} = pt_405:write(40508, [?SUCCESS]),
									lib_server_send:send_to_uid(RoleId, Bin),
									LastPS2;
								{false, Err, _} ->
									pp_guild_god:send_error(RoleId, Err),
									PS
							end;
						_ ->
							pp_guild_god:send_error(RoleId, ?ERRCODE(err405_rune_max_lv)),
							PS
					end;
				_ ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_not_ward_rune)),
					PS
			end;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_error_god_id)),
			PS
	end.




awake_achievement(GodId, Lv, PS) ->
	#player_status{guild_god = GuildGod, id = RoleId, figure = Figure} = PS,
	#guild_god_in_ps{god_list = GodList} = GuildGod,
	case lists:keyfind(GodId, #guild_god.id, GodList) of
		#guild_god{rune_list = RuneList, achievement = AchiLvs, color = Color, lv = GodLv, combo_id = ComboId} = OldGod ->
%%			{RuneLv, _} = get_only_rune_attr_and_rune_lv(38040086),
			Res = check_achievement_lv(RuneList, Lv),
			Lvs = data_guild_god:get_rune_achievement(GodId),
			Res1 = lists:member(Lv, AchiLvs),  %% 是否觉醒过
			Res2 = lists:member(Lv, Lvs),      %% 等级是否对
			if
				Res1 == true ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_yet_awake)),
					PS;
				Res2 == false ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_error_achievement_lv)),
					PS;
				Res == false ->
					pp_guild_god:send_error(RoleId, ?ERRCODE(err405_rune_lv_limit)),
					PS;
				true ->
					NewAchiLvs = [Lv | AchiLvs],
					%% log
					GodName = data_guild_god:get_god_name(GodId),
					SendColor = ?IF(Color == ?DARK_GOLD, ?PINK, Color),
					lib_chat:send_TV({all}, ?MOD_GUILD_GOD, 4, [Figure#figure.name, SendColor, GodName, Lv]),
					lib_log_api:log_guild_god(RoleId, GodId, ?log_type4,
						Color, GodLv, ComboId, AchiLvs, Color, GodLv, ComboId, NewAchiLvs),
					NewGod = OldGod#guild_god{achievement = NewAchiLvs},
					save_god_to_db(RoleId, NewGod),
					NewGodList = lists:keystore(GodId, #guild_god.id, GodList, NewGod),
					NewGuildGod = GuildGod#guild_god_in_ps{god_list = NewGodList},
					NewPS = PS#player_status{guild_god = NewGuildGod},
					LastPS = lib_guild_god_util:update_god_power(NewPS),
					pp_guild_god:handle(40502, LastPS, [GodId]),
					{ok, Bin} = pt_405:write(40509, [?SUCCESS]),
					lib_server_send:send_to_uid(RoleId, Bin),
					LastPS
			end;
		_ ->
			pp_guild_god:send_error(RoleId, ?ERRCODE(err405_error_god_id)),
			PS
	end.


check_achievement_lv(RuneList, Lv) ->
	Length = length(RuneList),
	if
		Length < 6 ->
			false;
		true ->
			check_achievement_lv2(RuneList, Lv)
	end.

check_achievement_lv2([], _Lv) ->
	true;
check_achievement_lv2([#guild_god_rune{goods_type_id = TypeId} | RuneList], Lv) ->
	case data_guild_god:get_rune_cfg(TypeId) of
		#guild_rune_cfg{lv = RuneLv} when RuneLv >= Lv ->
			check_achievement_lv2(RuneList, Lv);
		_ ->
			false
	end.





