%%%-----------------------------------
%%% @Module  : pp_god
%%% @Author  : zengzy
%%% @Email   : 
%%% @Created : 2018-02-27
%%% @Description: 变身系统
%%%-----------------------------------
-module(pp_god).

-export([handle/3]).

-include("common.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("god.hrl").

%% 元神列表
handle(44000, PlayerStatus, []) ->
	#player_status{figure = #figure{lv = _Lv}} = PlayerStatus,
	% ?PRINT("44000  ~n",[]),
	lib_god:show_god_list(PlayerStatus);

%% 元神信息
handle(44001, PlayerStatus, [GodId]) ->
	#player_status{figure = #figure{lv = _Lv}} = PlayerStatus,
	% ?PRINT("44001  ~n",[]),
	lib_god:show_god_info(PlayerStatus, GodId);

% 激活元神
handle(44002, PlayerStatus, [GodId]) ->
    #player_status{sid = Sid} = PlayerStatus,
    case lib_god:active_god(PlayerStatus, GodId) of
        {true, NewPS} ->
            lib_task_api:active_god(PlayerStatus, 1),
            {ok, SupVipPS} = lib_supreme_vip_api:active_god(NewPS),
			{ok, TemplePs} = lib_temple_awaken_api:trigger_active_god(SupVipPS, GodId),
            {ok, TemplePs};
        {false, Errcode} ->
%%          ?MYLOG("cym", "44002 err~p~n", [Errcode]),
            {ok, BinData} = pt_440:write(44002, [Errcode, 0, GodId]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

% 升级
handle(44003, PlayerStatus, [GodId]) ->
	#player_status{sid = Sid} = PlayerStatus,
	% ?PRINT("44003  ~n",[]),
	GoodsList = data_god:get_kv(update_lv_goods),
	case lib_god:feed(PlayerStatus, GodId, GoodsList) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Errcode} ->
			?PRINT("44003 err  ~p~n", [Errcode]),
			{ok, BinData} = pt_440:write(44003, [Errcode, GodId, 0, 0, 0]),
			lib_server_send:send_to_sid(Sid, BinData)
	end;

%% 升阶
handle(44004, PlayerStatus, [GodId]) ->
	#player_status{sid = Sid} = PlayerStatus,
	% ?PRINT("44004  ~n",[]),
	case lib_god:up_grade(PlayerStatus, GodId) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, ErrCode} ->
			{ok, BinData} = pt_440:write(44004, [ErrCode, GodId, 0, 0]),
			lib_server_send:send_to_sid(Sid, BinData)
	end;

%% 升星
handle(44005, PlayerStatus, [GodId]) ->
	#player_status{sid = Sid} = PlayerStatus,
	% ?PRINT("44004  ~n",[]),
	case lib_god:up_star(PlayerStatus, GodId) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Errcode} ->
			{ok, BinData} = pt_440:write(44005, [Errcode, GodId, 0, 0]),
			lib_server_send:send_to_sid(Sid, BinData)
	end;


%%元神出战
handle(44006, PlayerStatus, [Pos, GodId]) ->
	#player_status{sid = Sid} = PlayerStatus,
	% ?PRINT("44006  ~n",[]),
	case lib_god:enter_battle(PlayerStatus, Pos, GodId) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Errcode} ->
			?PRINT("44006 err~p~n", [Errcode]),
			{ok, BinData} = pt_440:write(44006, [Errcode, GodId]),
			lib_server_send:send_to_sid(Sid, BinData)
	end;


%%变身cd信息
handle(44010, #player_status{sid = Sid} = PlayerStatus, []) ->
	#player_status{god = StatusGod} = PlayerStatus,
	#status_god{trans = _Trans, summon = Summon} = StatusGod,
	CdTime =
		case Summon#god_summon.start_time of
			0 ->
				Summon#god_summon.end_time + lib_god_summon:get_summon_cd_by_god_id(Summon#god_summon.god_id);
			_ ->
				Summon#god_summon.start_time
		end,
	{ok, BinData} = pt_440:write(44010, [CdTime, Summon#god_summon.end_time]),
	lib_server_send:send_to_sid(Sid, BinData),
	ok;

%%切换变身
handle(44011, #player_status{sid = Sid} = PlayerStatus, []) ->
	%IsInBehavior = lib_player_behavior_api:is_in_behavior(PlayerStatus),
	if
		%IsInBehavior -> skip;
		true ->
			case lib_god_summon:switch_god(PlayerStatus) of
				{false, Res} ->
					NewPS = PlayerStatus, NewGodId = 0;
				NewPS ->
					Res = ?SUCCESS,
					#player_status{god = #status_god{summon = Summon}} = NewPS,
					NewGodId = Summon#god_summon.god_id
			end,
			{ok, BinData} = pt_440:write(44011, [Res, NewGodId]),
			lib_server_send:send_to_sid(Sid, BinData),
			{ok, NewPS}
	end;

%% 穿戴装备
handle(44012, #player_status{sid = Sid} = PS, [GoodsAutoId, GodId]) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	#player_status{god = StatusGod, id = RoleId, sid = Sid} = PS,
	#status_god{god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
%%			?MYLOG("cym", "+++++++++++  err440_not_active  GodId ~p  GodList ~p ~n ", [GodId, GodList ]),
			{ok, Bin} = pt_440:write(44012, [?ERRCODE(err440_not_active)]),
			lib_server_send:send_to_sid(Sid, Bin);
		#god{equip_list = EquipList} = Item ->
			case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
				#goods{location = _Location} when _Location =/= ?GOODS_LOC_GOD2_EQUIP_BAG ->  %%要穿戴的装备
					{ok, Bin} = pt_440:write(44012, [?FAIL]),
					lib_server_send:send_to_sid(Sid, Bin);
				#goods{location = _Location, type = ?GOODS_TYPE_GOD_EQUIP, subtype = Pos, cell = _BagCell, other = Other} = TakeOnGoodsInfo ->  %%要穿戴的装备
					case lib_god_util:check_equip(GodId, TakeOnGoodsInfo) of
						true ->
							{TakeoffGoods, NewEquipList1} =
								lib_god:calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),  %%计算脱下的装备
							F = fun
								() ->
									ok = lib_goods_dict:start_dict(),
									TakeOffGoodsInfo
										= case lists:keyfind(Pos, 1, EquipList) of
										{Pos, AutoId, _GoodTypeId} ->
											OGoodsInfo = lib_goods_util:get_goods(AutoId, GoodsStatus#goods_status.dict),
											#goods{other = _other} = OGoodsInfo,
											OGoodsInfo#goods{other = _other#goods_other{optional_data = []}};
										_ ->
											[]
									end,
%%									% 脱下原来的装备,更新内存中的数据
%%									if
%%										TakeoffGoods =/= [] ->
%%											F2 = fun
%%												(GoodsInfo1, GoodsStatusAcc) ->
%%													[_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo1, ?GOODS_LOC_GOD2_EQUIP_BAG, 0, GoodsStatusAcc),
%%													NewGoodsStatusAcc
%%											end,
%%											TakeoffEndGoods = lib_god:takeoff_equips(TakeoffGoods),
%%											GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods);
%%										true ->
%%											GoodsStatusTmp = GoodsStatus
%%									end,
									%%更新脱下装备到数据库
									if
										is_record(TakeOffGoodsInfo, goods) ->
											lib_god_util:change_goods_other(TakeOffGoodsInfo),
											[_, GoodsStatus1] = lib_goods:change_goods_cell(TakeOffGoodsInfo, ?GOODS_LOC_GOD2_EQUIP_BAG, 0, GoodsStatus);
										true ->
											GoodsStatus1 = GoodsStatus
									end,
									%%更新要穿戴装备关于降神的数据
									TakeOnGoodsInfo1 = TakeOnGoodsInfo#goods{other = Other#goods_other{optional_data = [GodId]}},
									lib_god_util:change_goods_other(TakeOnGoodsInfo1),
									[TakeOnGoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(TakeOnGoodsInfo1, ?GOODS_LOC_GOD2_EQUIP, Pos, GoodsStatus1),
									#goods_status{dict = OldGoodsDict} = GoodsStatus2,
									{GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
									NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},
									{ok, GoodsL, NewGoodsStatus, TakeOnGoodsInfo2}
							end,
							case lib_goods_util:transaction(F) of
								{ok, GoodsL, NewGoodsStatus, #goods{goods_id = GoodsTypeId}} ->
									NewEquipList = lists:keystore(Pos, 1, NewEquipList1, {Pos, GoodsAutoId, GoodsTypeId}),
									lib_goods_do:set_goods_status(NewGoodsStatus),
									% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
									if
										TakeoffGoods =/= [] ->
											#goods{id = LogGoodAutoId, goods_id = LogGoodsTypeId} = hd(TakeoffGoods),
											lib_log_api:log_god_equip_goods(RoleId, GodId, Pos, LogGoodAutoId, LogGoodsTypeId, GoodsAutoId, GoodsTypeId),
											[lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num = 0}]) || GoodsInfo1 <- TakeoffGoods];
										true ->
											lib_log_api:log_god_equip_goods(RoleId, GodId, Pos, 0, 0, GoodsAutoId, GoodsTypeId),
											skip
									end,
									lib_goods_api:notify_client_num(RoleId, [TakeOnGoodsInfo#goods{num = 0}]),
									lib_goods_api:notify_client(RoleId, GoodsL),
									EquipAttr = lib_god:calc_equip_list_attr(NewEquipList),
									NewItem = Item#god{equip_list = NewEquipList, equip_attr = EquipAttr},
									NewGodList = lists:keystore(GodId, #god.id, GodList, NewItem),
									NewStatusGod = StatusGod#status_god{god_list = NewGodList},
									NewPS = PS#player_status{god = NewStatusGod},
									LastPS = lib_god:update_god_power(NewPS), %%重新计算战力
									pp_god:handle(44001, LastPS, [GodId]), %% 推送44001
									{ok, LastPS};
								_Err ->
									{ok, Bin} = pt_440:write(44012, [?FAIL]),
									lib_server_send:send_to_sid(Sid, Bin)
							end;
						{false, ErrCode} ->
							{ok, Bin} = pt_440:write(44012, [ErrCode]),
							lib_server_send:send_to_sid(Sid, Bin)
					end;
				_ ->
					{ok, Bin} = pt_440:write(44012, [?ERRCODE(err440_not_god_equip)]),
					lib_server_send:send_to_sid(Sid, Bin)
			end
	end;

%% 卸下装备
handle(44013, #player_status{sid = Sid} = PS, [GodId, Pos]) ->
%%	?MYLOG("cym", "44013 +++++++++++ GodId ~p   , Pos ~p~n", [GodId, Pos]),
	#player_status{god = StatusGod, id = RoleId, sid = Sid} = PS,
	#status_god{god_list = GodList} = StatusGod,
	GoodsStatus = lib_goods_do:get_goods_status(),
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
			{ok, Bin} = pt_440:write(44013, [?ERRCODE(err440_not_active)]),
			lib_server_send:send_to_sid(Sid, Bin);
		#god{equip_list = EquipList} = God ->
			{TakeoffGoods, NewEquipList} = lib_god:calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
			if
				TakeoffGoods =:= [] ->
					{ok, Bin} = pt_440:write(44013, [?FAIL]),
					lib_server_send:send_to_sid(Sid, Bin);
				true ->
					F = fun
						() ->
							ok = lib_goods_dict:start_dict(),
							F2 = fun
								(GoodsInfo, GoodsStatusAcc) ->
									[_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_GOD2_EQUIP_BAG, 0, GoodsStatusAcc),
									NewGoodsStatusAcc
							end,
							TakeoffEndGoods = lib_god:takeoff_equips(TakeoffGoods),
							GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods),
							#goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
							{GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
							NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
							[lib_god_util:change_goods_other(G) || G <- TakeoffEndGoods],
							[lib_log_api:log_god_equip_goods(RoleId, GodId, Pos, LogGoodsAutoId, LogGoodsTypeId, 0, 0)
								|| #goods{id = LogGoodsAutoId, goods_id = LogGoodsTypeId} <- TakeoffEndGoods],
							{ok, GoodsL, NewGoodsStatus}
					end,
					case lib_goods_util:transaction(F) of
						{ok, GoodsL, NewGoodsStatus} ->
							lib_goods_do:set_goods_status(NewGoodsStatus),
							%% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
							[lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num = 0}]) || GoodsInfo <- TakeoffGoods],
							lib_goods_api:notify_client(RoleId, GoodsL),
							EquipAttr = lib_god:calc_equip_list_attr(NewEquipList),
							NewGod = God#god{equip_list = NewEquipList, equip_attr = EquipAttr},
							NewGodList = lists:keystore(GodId, #god.id, GodList, NewGod),
							NewStatusGod = StatusGod#status_god{god_list = NewGodList},
							NewPS = PS#player_status{god = NewStatusGod},
							LastPS = lib_god:update_god_power(NewPS), %%重新计算战力
							{ok, Bin} = pt_440:write(44013, [?SUCCESS]),
							lib_server_send:send_to_sid(Sid, Bin),
							pp_god:handle(44001, LastPS, [GodId]), %% 推送44001
							{ok, LastPS};
						Error ->
							?ERR("stren error:~p", [Error]),
							{ok, Bin} = pt_440:write(44013, [?FAIL]),
							lib_server_send:send_to_sid(Sid, Bin)
					end %% lib_goods_util:transaction(F)
			end %% case lists:keyfind(EudemonsId, ...)
	end;


%%快速合成
handle(44014, #player_status{sid = Sid} = PS, [RuleId, GoodsAutoId]) ->
	case lib_god:check_compose(PS, RuleId, GoodsAutoId) of
		{true, RightCostList, OldTargetGoodsInfo, TargetGoods} ->
%%			?MYLOG("cym", "goods_not_enough ++++++ RightCostList ~p~n", [RightCostList]),
			lib_god:do_compose(PS, RightCostList, OldTargetGoodsInfo, TargetGoods, RuleId, GoodsAutoId);
		{false, Error} ->
			{ok, Bin} = pt_440:write(44014, [Error, RuleId, GoodsAutoId]),
			lib_server_send:send_to_sid(Sid, Bin),
			{ok, PS}
	end;


%%期望战力
handle(44015, #player_status{} = PS, [GodId]) ->
	God = #god{id = GodId},
	lib_god:calc_expect_power(PS, God),
	{ok, PS};

%% 智能合成
handle(44016, Ps, [ComposeList]) ->
    lib_god:intelligent_compose(Ps, ComposeList, [], [], [], [], []);


%%神格界面
handle(44017, #player_status{sid = Sid, god = StatusGod} = PS, [GodType]) ->
    #status_god{god_stren = #god_stren{stren_list = StrenList}} = StatusGod,
    ?PRINT(" 44017 StrenList:~p ~n", [StrenList]),
    #god_stren_item{level = Level, exp = Exp} = ulists:keyfind(GodType, #god_stren_item.god_type, StrenList, #god_stren_item{}),
    lib_server_send:send_to_sid(Sid, pt_440, 44017, [GodType, Level, Exp]),
    {ok, PS};

%%神格强化
handle(44018, #player_status{sid = Sid}=PS, [GodType, GoodsList, IsDivide]) ->
    ?PRINT(" 44018 NewGoodsList:~p ~n", [{GodType, GoodsList}]),
    case lib_god:god_stren(PS, GodType, GoodsList) of 
        {ok, NewPS, NewGodStrenItem} ->
            #god_stren_item{level = Level, exp = Exp} = NewGodStrenItem,
            ?PRINT(" 44018 NewGodStrenItem:~p ~n", [NewGodStrenItem]),
            {Code, ErrorCodeArgs} = util:parse_error_code(?SUCCESS),
            lib_server_send:send_to_sid(Sid, pt_440, 44018, [Code, ErrorCodeArgs, GodType, Level, Exp, IsDivide]),
            {ok, battle_attr, NewPS};
        {false, Res} ->
            ?PRINT(" 44018 Res:~p ~n", [Res]),
            {Code, ErrorCodeArgs} = util:parse_error_code(Res),
            lib_server_send:send_to_sid(Sid, pt_440, 44018, [Code, ErrorCodeArgs, GodType, 0, 0, IsDivide])
    end;

handle(_Cmd, _Player, _Data) ->
	?PRINT(" Data:~p ~n", [_Data]),
	{error, "pp_god no match~n"}.
