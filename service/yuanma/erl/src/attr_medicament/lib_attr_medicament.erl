%%%-----------------------------------
%%% @Module      : lib_attr_medicament
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 02. 一月 2019 17:34
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_attr_medicament).
-author("chenyiming").

%% API
-compile(export_all).
-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("attr_medicament.hrl").


login(Ps) ->
	Sql1 = io_lib:format(?select_attr_medicament, [Ps#player_status.id]),
	case db:get_row(Sql1) of
		[_AttrList] ->
			AttrList = util:bitstring_to_term(_AttrList);
		_ ->
			AttrList = []
	end,
	Sql2 = io_lib:format(?select_attr_medicament_count, [Ps#player_status.id]),
	List = db:get_all(Sql2),
	CountList = [{GoodTypeId, DayCount, AllCount} || [GoodTypeId, DayCount, AllCount] <- List],
	RoleAttrMedicament = #role_attr_medicament{attr_list = AttrList, count_list = CountList},
	Ps#player_status{attr_medicament = RoleAttrMedicament}.


%%获取当前次数
get_count(#player_status{attr_medicament = AttrMedicament, id = RoleId}, Lv) ->
	#role_attr_medicament{count_list = CountList} = AttrMedicament,
	ResList = get_count_helper(CountList, Lv),
	?PRINT("RESLIST:~p~n", [ResList]),
%%	?MYLOG("cym", "ResList ~p~n", [ResList]),
	{ok, Bin} = pt_217:write(21701, [ResList]),
	lib_server_send:send_to_uid(RoleId, Bin).

get_count_helper(CountList, Lv) ->
	GoodTypeIdList = data_attr_medicament:get_good_id_list_by_lv(Lv),
	F = fun(GoodTypeId, AccList) ->
		case lists:keyfind(GoodTypeId, 1, CountList) of
			{GoodTypeId, TempDayCount, TempAllCount} ->
				{GoodTypeId, TempDayCount, TempAllCount};
			_ ->
				TempDayCount = 0,
				TempAllCount = 0
		end,
		[{GoodTypeId, Lv, TempDayCount, TempAllCount} | AccList]
	end,
	ResList = lists:foldl(F, [], GoodTypeIdList),
	ResList.


%% -----------------------------------------------------------------
%% @desc     功能描述  使用属性药剂   GoodAutoId::物品唯一id  检查 =》更新属性(修改属性变化)，修改次数=》通知客户端属性变化=》同步数据库=》返回
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
use_attr_medicament(#player_status{attr_medicament = AttrMedicament, id = RoleId} = Ps, GoodId, Num, Lv) ->
%%	?MYLOG("cym", "GoodId ~p Num ~p  Lv ~p ~n", [GoodId, Num, Lv]),
	case check_use_medicament(GoodId, Ps, Num) of
		true ->
			%%使用物品
			case lib_goods_api:cost_object_list_with_check(Ps, [{?TYPE_GOODS, GoodId, Num}], attr_medicament, "attr_medicament") of
				{true, _Ps} ->
					%%日志
					lib_log_api:log_role_attr_medicament(RoleId, [{?TYPE_GOODS, GoodId, Num}], Lv),
					%%更改属性
					AddAttrList = get_attr_by_goods_type_id(GoodId, Num),
					#role_attr_medicament{attr_list = AttrList, count_list = CountList} = AttrMedicament,
					NewAttrList = ulists:kv_list_plus_extra([AddAttrList, AttrList]),
					NewCountList = add_count_list(GoodId, CountList, Num),  %%修改次数
					NewAttrMedicament = AttrMedicament#role_attr_medicament{attr_list = NewAttrList, count_list = NewCountList},
					NewPS = _Ps#player_status{attr_medicament = NewAttrMedicament},
					%%属性变化，通知客户端
%%					?MYLOG("cym", "NewAttrMedicament ~p ~n NewAttrList ~p, AttrList ~p, AddAttrList~p~n", [NewAttrMedicament, NewAttrList, AttrList, AddAttrList]),
					LastPs = lib_player:count_player_attribute(NewPS),
					lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
					%%通知场景
					mod_scene_agent:update(LastPs, [{battle_attr, LastPs#player_status.battle_attr}]),
					get_count(LastPs, Lv),
					%%同步数据库
					save_to_db(LastPs#player_status.id, NewAttrMedicament),
					LastPs;
				{false, ErrorCode, Ps} ->
					send_error_code(RoleId, ErrorCode)
			end;
		{false, ErrorCode} ->
			send_error_code(Ps#player_status.id, ErrorCode)
	end.


send_error_code(RoleId, Code) ->
	{ok, Bin} = pt_217:write(21700, [Code]),
	lib_server_send:send_to_uid(RoleId, Bin).





get_count_by_goods_type_id(CountList, GoodTypeId) ->
	case lists:keyfind(GoodTypeId, 1, CountList) of
		{GoodTypeId, DayCount, AllCount} ->
			{DayCount, AllCount};
		_ ->
			{0, 0}
	end.

get_cfg_count_by_goods_id_and_lv(GoodsTypeId, Lv) ->
	case data_attr_medicament:get_count_by_goodid_and_lv(GoodsTypeId, Lv) of
		[DayCount, AllCount] ->
			{DayCount, AllCount};
		_ ->
			{0, 0}
	end.

get_attr_by_goods_type_id(GoodsTypeId, Num) ->
	AttrList = data_attr_medicament:get_attr_by_good_id(GoodsTypeId),
	case AttrList of
		[] ->
			[];
		_ ->
			F = fun({AttrId, Value}, AccAttrList) ->
				[{AttrId, Value * Num} | AccAttrList]
			end,
			ResList = lists:foldl(F, [], AttrList),
			ResList
	end.



add_count_list(GoodTypeId, CountList, Num) ->
	case lists:keyfind(GoodTypeId, 1, CountList) of
		{GoodTypeId, DayCount, AllCount} ->
			lists:keystore(GoodTypeId, 1, CountList, {GoodTypeId, DayCount + Num, AllCount + Num});
		_ ->
			lists:keystore(GoodTypeId, 1, CountList, {GoodTypeId, Num, Num})
	end.

get_attr(#player_status{attr_medicament = AttrMedicament}) ->
	case AttrMedicament of
		#role_attr_medicament{attr_list = AttrList} ->
			AttrList;
		_ ->
			[]
	end.
%%0点清0
daily_clear(#player_status{attr_medicament = AttrMedicament} = Ps) ->
	#role_attr_medicament{count_list = CountList} = AttrMedicament,
	NewCountList = [{GoodTypeId, 0, AllCount} || {GoodTypeId, _DayCount, AllCount} <- CountList],
	NewAttrMedicament = AttrMedicament#role_attr_medicament{count_list = NewCountList},
	NewPs = Ps#player_status{attr_medicament = NewAttrMedicament},
	% 通知客户端
	get_all_count(NewPs),	
	NewPs.

%%0点清0
timer_0_clock() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_attr_medicament, daily_clear, []) || E <- OnlineRoles],
	Sql = io_lib:format(?set_attr_medicament_day_count, [0]),
%%	?MYLOG("cym", "~s~n", [Sql]),
	db:execute(Sql).


get_all_count(#player_status{attr_medicament = AttrMedicament, id = RoleId}) ->
	#role_attr_medicament{count_list = CountList} = AttrMedicament,
	F = fun(Lv, AccList) ->
		get_count_helper(CountList, Lv) ++ AccList
	end,
	ResList = lists:foldl(F, [], ?attr_medicament_lv_list),
%%	?MYLOG("cym", "ResList ~p~n", [ResList]),
	{ok, Bin} = pt_217:write(21703, [ResList]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%================check================================================================================
check_use_medicament(GoodsTypeId, #player_status{attr_medicament = AttrMedicament, figure = F}, Num) ->
	GoodEts = data_goods_type:get(GoodsTypeId),
	#role_attr_medicament{count_list = CountList} = AttrMedicament,
	{DayCount, AllCount} = get_count_by_goods_type_id(CountList, GoodsTypeId),
	{CfgDayCount, CfgAllCount} = get_cfg_count_by_goods_id_and_lv(GoodsTypeId, F#figure.lv),
	if
		GoodEts == [] ->
			{false, ?ERRCODE(err150_no_goods)};
		DayCount + Num > CfgDayCount -> %%日常没了
			{false, ?ERRCODE(err217_max_day_used_times)};
		AllCount + Num > CfgAllCount -> %%终生没了
			{false, ?ERRCODE(err217_max_used_times)};
		true ->
			true
	end.
%%================check=================================================================================

%%===========================================db=========================================================
save_to_db(RoleId, #role_attr_medicament{attr_list = AttrList, count_list = CountList}) ->
	save_to_db1(RoleId, AttrList),
	save_to_db2(RoleId, CountList).
save_to_db1(RoleId, AttrList) ->
	Sql = io_lib:format(?replace_attr_medicament, [RoleId, util:term_to_string(AttrList)]),
	db:execute(Sql).

save_to_db2(_RoleId, []) ->
	ok;
save_to_db2(RoleId, [{GoodTypeId, DayCount, AllCount} | CountList]) ->
	NewSql = io_lib:format(?replace_attr_medicament_count, [RoleId, GoodTypeId, DayCount, AllCount]),
	db:execute(NewSql),
	save_to_db2(RoleId, CountList).

%%===========================================db=========================================================
	
	
	
	
	
	
	
	
	
	