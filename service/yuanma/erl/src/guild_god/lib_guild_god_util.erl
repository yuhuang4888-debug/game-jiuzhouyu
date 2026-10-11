%%%-----------------------------------
%%% @Module      : lib_guild_god_util
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十二月 2019 16:33
%%% @Description : 
%%%-----------------------------------

-module(lib_guild_god_util).
-include("def_goods.hrl").
-include("goods.hrl").
-include("guild_god.hrl").
-author("carlos").
-include("server.hrl").
-include("predefine.hrl").
%% API
-compile(export_all).

is_open(Lv) ->
	NeedOpenDay = data_guild_god:get_kv(open_day),
	NeedLv = data_guild_god:get_kv(lv_limit),
	OpenDay = util:get_open_day(),
	Lv >= NeedLv andalso OpenDay >= NeedOpenDay.

%% 公会神像other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_GUILD_GOD, other = Other}) ->
	#goods_other{optional_data = T} = Other,
	[?GOODS_OTHER_KEY_GUILD_GOD | T];

format_other_data(_) ->
	[].

%% 公会神像将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, Data) ->
	Other#goods_other{optional_data = Data}.

%% -----------------------------------------------------------------
%% @desc     功能描述  更新降神装备的额外数据到数据库中
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
change_goods_other(#goods{id = Id} = GoodsInfo) ->
	lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

check_equip(_GodId, _TakeOnGoodsInfo) ->
	true.

calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
	%% {Position, GoodsAutoId, _GoodsTypeId}
	F = fun
		    (#guild_god_rune{pos = Position, auto_id = GoodsAutoId, goods_type_id = _GoodsTypeId} = X, {TakeoffGoods, NewEquipList}) ->
			    if
				    Position =:= Pos -> %%orelse Pos =:= 0
					    case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
						    GoodsInfo when is_record(GoodsInfo, goods) ->
							    {[GoodsInfo | TakeoffGoods], NewEquipList};
						    _ ->
							    {TakeoffGoods, NewEquipList}
					    end;
				    true ->
					    {TakeoffGoods, [X | NewEquipList]}
			    end
	    end,
	{TakeoffGoods, NewEquipList} = lists:foldl(F, {[], []}, EquipList),
	{TakeoffGoods, lists:reverse(NewEquipList)}.

%% 穿戴，脱下铭文后的处理
update_god_power(NewPS) ->
	PS2 = lib_player:count_player_attribute(NewPS),
	lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),     %%主动推送信息
	mod_scene_agent:update(PS2, [{battle_attr, PS2#player_status.battle_attr}]),
	PS2.

takeoff_equips(EquipGoodsList) ->
	[GoodsInfo#goods{other = Other#goods_other{optional_data = []}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].

%% -----------------------------------------------------------------
%% @desc     功能描述  检查组合是否满足条件激活
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
check_combo(GodId, ComboId, RuneList) ->
	Length = length(RuneList),
	if
		Length < 6 ->
			false;
		true ->
			case data_guild_god:get_combo_cfg(GodId, ComboId) of
				#guild_god_combo_cfg{condition = Condition} ->
					ColorList = get_color_num(RuneList),
					F = fun({Color1, _}, {Color2, _}) ->  %% 升序
						Color1 < Color2
					    end,
					NewCondition = lists:sort(F, Condition),
					check_combo_help(NewCondition, ColorList);
				_ ->
					false
			end
	end.

check_combo_help([], _ColorList) ->
	true;
check_combo_help([{Color, Num} | Condition], ColorList) ->
	ColorNum = length(ColorList),
	if
		ColorNum >= Num ->
			SubList = lists:sublist(ColorList, Num),
			MinColor = hd(SubList),
			if
				MinColor >= Color ->
					check_combo_help(Condition, ColorList -- SubList);
				true ->
					false
			end;
		true ->
			false
	end.

%%%% 铭文 品质  >=  Color 的数量
%%get_color_num(Color, RuneList) ->
%%	F = fun(#guild_god_rune{goods_type_id = TypeId}, Num) ->
%%		case data_goods_type:get(TypeId) of
%%			#ets_goods_type{color = GoodsColor} ->
%%				if
%%					GoodsColor >= Color ->
%%						Num + 1;
%%					true ->
%%						Num
%%				end;
%%			_ ->
%%				Num
%%		end
%%	    end,
%%	lists:foldl(F, 0, RuneList).

%% 返回颜色列表 列表升序  eg: [1, 1, 2, 3, 4, 5]
get_color_num(RuneList) ->
	F = fun(#guild_god_rune{goods_type_id = TypeId}, AccList) ->
		case data_goods_type:get(TypeId) of
			#ets_goods_type{color = GoodsColor} ->
				[GoodsColor | AccList];
			_ ->
				AccList
		end
	    end,
	ColorList = lists:foldl(F, [], RuneList),
	Sort = fun(A, B) ->
		A < B
	       end,
	lists:sort(Sort, ColorList).
