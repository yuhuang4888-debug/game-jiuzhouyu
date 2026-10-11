%%%-----------------------------------
%%% @Module      : pp_revelation_equip
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 六月 2019 10:11
%%% @Description : 文件摘要
%%%-----------------------------------
-module(pp_revelation_equip).
-author("chenyiming").

%% API
-compile(export_all).


-include("common.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("goods.hrl").
-include("def_goods.hrl").




%% 穿戴装备
handle(Cmd = 28601, #player_status{sid = Sid} = PS, [GoodsId]) ->
%%	?MYLOG("cym", "28601+++++++++++++ ~n", []),
	case lib_revelation_equip:equip(PS, GoodsId) of
		{true, Res, OldGoodsInfo, NewGoodsInfo, Cell, NewPS} ->
			OldGoodsId = case is_record(OldGoodsInfo, goods) of
				true -> OldGoodsInfo#goods.id;
				false -> 0
			end,
			lib_server_send:send_to_sid(Sid, pt_286, Cmd, [Res, GoodsId, OldGoodsId, NewGoodsInfo#goods.goods_id, Cell]),
			{ok, SupVipPS} = lib_supreme_vip_api:revelation_equip(NewPS),
			{ok, equip, SupVipPS};
		{false, Res, NewPS} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, NewPS};
		_ ->
			{ok, PS}
	end;

%% 卸下装备
handle(Cmd = 28602, #player_status{sid = Sid} = PS, [GoodsId]) ->
	case lib_revelation_equip:unequip(PS, GoodsId) of
		{true, Res, _NewGoodsInfo, Cell, NewPS} ->
			lib_server_send:send_to_sid(Sid, pt_286, Cmd, [Res, GoodsId, Cell]),
			{ok, equip, NewPS};
		{false, Res, NewPS} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, NewPS};
		_ ->
			{ok, PS}
	end;


%% 吞噬
handle(28603, #player_status{sid = Sid} = PS, [Pos, GoodsIdList]) ->
	case lib_revelation_equip_check:swallow(PS, Pos, GoodsIdList) of
		{true, GoodsInfoList} ->
			NewPS = lib_revelation_equip:swallow(PS, Pos, GoodsInfoList, GoodsIdList),
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, PS};
		_ ->
			{ok, PS}
	end;


%% 升级
handle(28604, #player_status{sid = Sid} = PS, [Pos]) ->
	case lib_revelation_equip:up_lv(PS, Pos) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, PS};
		_ ->
			{ok, PS}
	end;


%% 技能升级
handle(28605, #player_status{sid = Sid} = PS, [SkillId]) ->
	case lib_revelation_equip:up_skill(PS, SkillId) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, PS};
		_ ->
			{ok, PS}
	end;

%% 天启装备信息
handle(28606, #player_status{sid = _Sid} = PS, []) ->
	lib_revelation_equip:info(PS);


%% 更改形象
handle(28607, #player_status{sid = Sid} = PS, [FigureId]) ->
	case lib_revelation_equip:change_figure_id(PS, FigureId) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(Sid, pt_286, 28600, [Res]),
			{ok, PS};
		_ ->
			{ok, PS}
	end;

%% 客户端要求另起一个战力协议
handle(28609, #player_status{id = RoleId} = PS, []) ->
	{Power, NewPs} = lib_revelation_equip:get_power(PS),
	{ok, Bin} = pt_286:write(28609, [Power]),
	lib_server_send:send_to_uid(RoleId, Bin),
	{ok, NewPs};


%%
handle(_Cmd , _PS, _) ->
	?MYLOG("cym", "not match ~n", []),
	{ok, _PS}.
