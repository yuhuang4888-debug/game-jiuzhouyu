%%%-----------------------------------
%%% @Module      : lib_revelation_equip_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 六月 2019 10:49
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_revelation_equip_check).
-author("chenyiming").

%% API
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("revelation_equip.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").



equip(PS, GoodsStatus, GoodsId) ->
	GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
	if
		is_record(GoodsInfo, goods) ->
			Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
			Location = ?GOODS_LOC_REVELATION,
			OldGoodsInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, Location, Cell, GoodsStatus#goods_status.dict),
			Temp2 = data_goods_type:get(GoodsInfo#goods.goods_id),
			NewdefaultLocation = Temp2#ets_goods_type.bag_location,
			case is_record(OldGoodsInfo, goods) of
				true ->
					Temp1 = data_goods_type:get(OldGoodsInfo#goods.goods_id),
					OlddefaultLocation = Temp1#ets_goods_type.bag_location;
				false ->
					OlddefaultLocation = NewdefaultLocation  %%如果人物上没有装备
			end,
			CheckList = [
				{check_base, PS, GoodsInfo},
				{check_null_cells, GoodsStatus, OlddefaultLocation, NewdefaultLocation},
				{check_goods_type, GoodsInfo, ?GOODS_TYPE_REVELATION},
				{check_equip_type, GoodsInfo}
			],
			case checklist(CheckList) of
				true ->
					{true, GoodsInfo};
				{false, Res} ->
					{false, Res}
			end;
		true ->
			{false, ?ERRCODE(err150_no_goods)}
	end.

unequip(GoodsStatus, GoodsId) ->
	GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
	CheckList = [
		{check_exist, GoodsInfo},
		{check_null_cells, GoodsStatus, GoodsInfo#goods.goods_id},
		{check_location, GoodsInfo, [?GOODS_LOC_REVELATION]}
	],
	case checklist(CheckList) of
		true ->
			{true, GoodsInfo};
		{false, Res} ->
			{false, Res}
	end.


swallow(_PS, Pos, GoodsIdList) ->
	IsRight = lists:member(Pos, ?pos_list),
	if
		IsRight == true ->
			case get_goods_info(GoodsIdList) of
				{false, Err} ->
					{false, Err};
				GoodsInfoList ->
					{true, GoodsInfoList}
			end;
		true ->
			{false, ?ERRCODE(err286_err_pos)}
	end.



check({check_base, PS, GoodsInfo}) ->
	CheckList = [
		{check_exist, GoodsInfo},
		{check_expire, GoodsInfo},
		{check_lv, GoodsInfo, PS#player_status.figure#figure.lv}
	],
	checklist(CheckList);


check({check_exist, GoodsInfo}) ->
	case is_record(GoodsInfo, goods) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err150_no_goods)}
	end;

check({check_expire, GoodsInfo}) ->
	NowTime = utime:unixtime(),
	case GoodsInfo#goods.expire_time > 0 andalso
		GoodsInfo#goods.expire_time =< NowTime of
		true ->
			{false, ?ERRCODE(err152_expire_err)};
		false ->
			true
	end;

check({check_lv, GoodsInfo, Lv}) ->
	G = data_goods_type:get(GoodsInfo#goods.goods_id),
	case G#ets_goods_type.level =< Lv of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err152_lv_err)}
	end;


check({check_null_cells, GoodsStatus}) when is_record(GoodsStatus, goods_status) ->
	HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_REVELATION_BAG),
	if
		HaveCellNum < 1 ->
			{false, ?ERRCODE(err150_no_cell)};
		true ->
			true
	end;

%%根据物品默认的背包类型来去检查背包是否有位置	chenyiming-20180802
check({check_null_cells, GoodsStatus, GoodTypeId}) when is_record(GoodsStatus, goods_status) ->
	GoodsType = data_goods_type:get(GoodTypeId),
	Location = GoodsType#ets_goods_type.bag_location,
	HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, Location),
	if
		HaveCellNum < 1 ->
			{false, ?ERRCODE(err150_no_cell)};
		true ->
			true
	end;

check({check_null_cells, GoodsStatus, OldDefaultLocation, NewDefaultLocation}) ->
	case OldDefaultLocation == NewDefaultLocation of
		true ->  %%同背包替换，没有问题
			true;
		false -> %%不同背包替换,检查装备在身上的默认背包格子情况
			HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, OldDefaultLocation),
			if
				HaveCellNum < 1 ->
					{false, ?ERRCODE(err150_no_cell)};
				true ->
					true
			end
	end;

check({check_goods_type, GoodsInfo, Type}) ->
	case GoodsInfo#goods.type == Type of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err152_type_err)}
	end;

check({check_equip_type, GoodsInfo}) ->
	EquipNum = data_goods:get_config(revelation_equip_num),
	case GoodsInfo#goods.subtype >= 1 andalso GoodsInfo#goods.subtype =< EquipNum of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err152_equip_type_error)}
	end;

check({check_location, GoodsInfo, LocList}) when is_list(LocList) ->
	case lists:member(GoodsInfo#goods.location, LocList) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err152_location_err)}
	end;

check(_X) ->
	{false, ?FAIL}.

checklist([]) ->
	true;
checklist([H | T]) ->
	case check(H) of
		true ->
			checklist(T);
		{false, Res} ->
			{false, Res}
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  根据物品唯一id获得物品
%% @param    参数     [GoodsId]
%% @return   返回值   {false, Err} | [#goods{}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_goods_info([]) ->
	{false, ?FAIL};
get_goods_info(GoodsIdList) ->
	get_goods_info2(GoodsIdList, []).


get_goods_info2([], AccList) ->
	AccList;
get_goods_info2([Id | List], AccList) ->
	case lib_goods_api:get_goods_info(Id) of
		[] ->
			{false, ?ERRCODE(err150_no_goods)};
		GoodsInfo ->
			get_goods_info2(List, [GoodsInfo | AccList])
	end.