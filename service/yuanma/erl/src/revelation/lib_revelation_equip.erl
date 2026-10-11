%%%-----------------------------------
%%% @Module      : lib_revelation_equip
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 六月 2019 10:11
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_revelation_equip).
-author("chenyiming").

%% API
-compile(export_all).

-include("server.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("rec_offline.hrl").
-include("revelation_equip.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("guild.hrl").

%% -----------------------------------------------------------------
%% @desc     功能描述  登录初始化
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
login(PS) ->
	#player_status{figure = Figure} = PS,
	Sql = io_lib:format(?select_sql, [PS#player_status.id]),
	case db:get_row(Sql) of
		[MaxFigureId, CurrentFigure, Gathering, Skill] ->
			Revelation = #role_revelation_equip{max_figure_id = MaxFigureId,
				current_figure = CurrentFigure, gathering = util:bitstring_to_term(Gathering), skill = util:bitstring_to_term(Skill)},
			NewPS = PS#player_status{revelation_equip = Revelation},
			{Attr, SkillPower} = count_all_attr(NewPS),
			NewRevelation = Revelation#role_revelation_equip{attr = Attr, skill_power = SkillPower},
			RevelationFigure = get_figure_id(CurrentFigure, Figure#figure.sex),
			NewPS#player_status{revelation_equip = NewRevelation, figure = Figure#figure{revelation_suit = RevelationFigure}};
		_ ->
%%			?MYLOG("cym", "login +++++++++~n", []),
			NewPs = PS#player_status{revelation_equip = #role_revelation_equip{}},
			{Attr, SkillPower} = count_all_attr(NewPs),
			NewPs#player_status{revelation_equip = #role_revelation_equip{attr = Attr, skill_power = SkillPower}}
	end.

off_login(PS) ->
	Sql = io_lib:format(?select_sql, [PS#player_status.id]),
	#player_status{figure = Figure} = PS,
	case db:get_row(Sql) of
		[MaxFigureId, CurrentFigure, Gathering, Skill] ->
			Revelation = #role_revelation_equip{max_figure_id = MaxFigureId,
				current_figure = CurrentFigure, gathering = util:bitstring_to_term(Gathering), skill = util:bitstring_to_term(Skill)},
			NewPS = PS#player_status{revelation_equip = Revelation},
			NewRevelation = Revelation#role_revelation_equip{},
			RevelationFigure = get_figure_id(CurrentFigure, Figure#figure.sex),
			NewPS#player_status{revelation_equip = NewRevelation, figure = Figure#figure{revelation_suit = RevelationFigure}};
		_ ->
%%			?MYLOG("cym", "login +++++++++~n", []),
			PS#player_status{revelation_equip = #role_revelation_equip{}}
	end.

%%玩家重登
re_login(PS) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	RevelationEquipList = lib_goods_util:get_revelation_equip_list(PS#player_status.id, GoodsStatus#goods_status.dict),
	{_SuitAttr, SuitList} = count_suit_attribute(RevelationEquipList),  %%新的套装属性
	handle_af_equip(PS, SuitList).

equip(PS, GoodsId) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	case lib_revelation_equip_check:equip(PS, GoodsStatus, GoodsId) of
		{true, GoodsInfo} ->
			do_equip(PS, GoodsStatus, GoodsInfo);
		{false, Res} ->
			{false, Res, PS}
	end.


do_equip(PS, GoodsStatus, GoodsInfo) ->
	OldRevelationEquipList = lib_goods_util:get_revelation_equip_list(PS#player_status.id, GoodsStatus#goods_status.dict),
	Location = ?GOODS_LOC_REVELATION,
	PlayerId = PS#player_status.id,
	GoodDict = GoodsStatus#goods_status.dict,
	Cell = data_goods:get_equip_cell(GoodsInfo#goods.subtype),
	TempOldGoodsInfo = lib_goods_util:get_goods_by_cell(PlayerId, Location, Cell, GoodDict),
	F = fun() ->
		ok = lib_goods_dict:start_dict(),
		do_equip_core(PS, GoodsStatus, GoodsInfo)
	    end,
	case lib_goods_util:transaction(F) of
		{ok, NewGoodsStatus, OldGoodsInfo, NewGoodsInfo, GoodsL, Cell, _RemoveStoneL, _ReturnGoodsL, NewPS} ->
			lib_goods_do:set_goods_status(NewGoodsStatus),
			%% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
			if
				TempOldGoodsInfo =/= [] ->
					lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, [GoodsInfo#goods{num = 0}, TempOldGoodsInfo#goods{num = 0}]);
				true ->
					lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, [GoodsInfo#goods{num = 0}])
			end,
			lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, GoodsL),
			RevelationEquipList = lib_goods_util:get_revelation_equip_list(NewPS#player_status.id, NewGoodsStatus#goods_status.dict),
			Attr = count_attribute(RevelationEquipList),                       %%新的装备属性
			{SuitAttr, SuitList} = count_suit_attribute(RevelationEquipList),  %%新的套装属性
%%			?MYLOG("cym", "Attr ~p SuitAttr ~p~n", [Attr, SuitAttr]),
			#player_status{goods = StatusGoods} = NewPS,
			NewStatusGoods = StatusGoods#status_goods{revelation_equip_attr = Attr, revelation_equip_suit_attr = SuitAttr},
			NewPS1 = handle_af_equip(NewPS, SuitList),
			LastPS = hand_attr_and_power(NewPS1#player_status{goods = NewStatusGoods}),
			handle_skill(RevelationEquipList, OldRevelationEquipList, LastPS),
			pp_revelation_equip:handle(28606, LastPS, []),
			{true, ?SUCCESS, OldGoodsInfo, NewGoodsInfo, Cell, LastPS};
		Error ->
			?ERR("equip error:~p", [Error]),
			{false, ?FAIL, PS}
	end.


do_equip_core(PS, GoodsStatus, GoodsInfo) ->
	Location = ?GOODS_LOC_REVELATION,
	PlayerId = PS#player_status.id,
	GoodDict = GoodsStatus#goods_status.dict,
	OldEquipLocation = GoodsStatus#goods_status.revelation_equip_location,
	Cell = data_goods:get_equip_cell(GoodsInfo#goods.subtype),
	OldGoodsInfo = lib_goods_util:get_goods_by_cell(PlayerId, Location, Cell, GoodDict),
	{NewOldGoodsInfo, NewGoodsInfo, NewGoodsStatus, RemoveStoneL, ReturnGoodsL} =
		case is_record(OldGoodsInfo, goods) of
			true -> %% 存在已装备的物品，则替换装备
				%% 阶数变化需要更新套装信息
%%				EquipPos = OldGoodsInfo#goods.subtype,
%%				{GoodsStatusTmp, SuitReturn} = update_suit(PS, GoodsStatus, OldGoodsInfo, GoodsInfo, EquipPos),
				OriginalCell = 0, %%现在没有格子位置的概念，全部置为0
				GoodsTypeTemp = data_goods_type:get(OldGoodsInfo#goods.goods_id),
				OriginalLocation = GoodsTypeTemp#ets_goods_type.bag_location,
				[OldGoodsInfo1, GoodsStatus1] =
					lib_goods:change_goods_cell_and_use(OldGoodsInfo, OriginalLocation, OriginalCell, GoodsStatus),
				[GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus1),
				%% 更新部位的装备id
				EquipLocation = lists:keystore(Cell, 1, OldEquipLocation, {Cell, GoodsInfo1#goods.id}),
				GoodsStatus3 = GoodsStatus2#goods_status{revelation_equip_location = EquipLocation},
				RL = [{stone_list, []}, {suit_return, []}],
				OldGoodsTypeId = OldGoodsInfo#goods.goods_id,
				OldGoodsAutoId = OldGoodsInfo#goods.id,
				{OldGoodsInfo1, GoodsInfo1, GoodsStatus3, [], RL};
			%% 不存在，直接穿戴
			false ->
				[GoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus),
				%% 更新部位的装备id
				EquipLocation = lists:keystore(Cell, 1, OldEquipLocation, {Cell, GoodsInfo1#goods.id}),
				RL = [],
				OldGoodsTypeId = 0,
				OldGoodsAutoId = 0,
				{OldGoodsInfo, GoodsInfo1, GoodsStatus1#goods_status{revelation_equip_location = EquipLocation}, [], RL}
		end,
	#goods_status{dict = OldGoodsDict} = NewGoodsStatus,
	lib_log_api:log_revelation_equip_goods(PlayerId, Cell, OldGoodsAutoId, OldGoodsTypeId, GoodsInfo#goods.id, GoodsInfo#goods.goods_id),
	{GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
%%	#player_status{goods = StatusGoods} = PS,
	NewStatus = NewGoodsStatus#goods_status{
		dict = GoodsDict,
		revelation_equip_location = EquipLocation
	},
%%	NewStatusGoods = update_suit(PlayerId, NewStatus, StatusGoods),
	{ok, NewStatus, NewOldGoodsInfo, NewGoodsInfo, GoodsL, Cell, RemoveStoneL, ReturnGoodsL, PS}.


%% ------------------------------- 卸载装备 %% -------------------------------
unequip(PS, GoodsId) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	case lib_revelation_equip_check:unequip(GoodsStatus, GoodsId) of
		{true, GoodsInfo} ->
			do_unequip(PS, GoodsStatus, GoodsInfo);
		{false, Res} ->
			{false, Res, PS}
	end.


do_unequip(PS, GoodsStatus, GoodsInfo) ->
	OldRevelationEquipList = lib_goods_util:get_revelation_equip_list(PS#player_status.id, GoodsStatus#goods_status.dict),
	F = fun() ->
		ok = lib_goods_dict:start_dict(),
		do_unequip_core(PS, GoodsStatus, GoodsInfo)
	    end,
	case lib_goods_util:transaction(F) of
		{ok, NewGoodsStatus, NewGoodsInfo, GoodsL, Cell, _RemoveStoneL, _ReturnGoodsL, NewPS} ->
			lib_goods_do:set_goods_status(NewGoodsStatus),
			lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, [GoodsInfo#goods{num = 0}]),
			lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, GoodsL),
			RevelationEquipList = lib_goods_util:get_revelation_equip_list(NewPS#player_status.id, NewGoodsStatus#goods_status.dict),
			Attr = count_attribute(RevelationEquipList),
			{SuitAttr, _SuitList} = count_suit_attribute(RevelationEquipList),
			#player_status{goods = StatusGoods} = NewPS,
			NewStatusGoods = StatusGoods#status_goods{revelation_equip_attr = Attr, revelation_equip_suit_attr = SuitAttr},
			LastPS = hand_attr_and_power(NewPS#player_status{goods = NewStatusGoods}),
			handle_skill(RevelationEquipList, OldRevelationEquipList, LastPS),
			pp_revelation_equip:handle(28606, LastPS, []),
			{true, ?SUCCESS, NewGoodsInfo, Cell, LastPS};
		Error ->
			?ERR("equip error:~p", [Error]),
			{false, ?FAIL, PS}
	end.

do_unequip_core(PS, GoodsStatus, GoodsInfo) ->
	GoodsType = data_goods_type:get(GoodsInfo#goods.goods_id),
	Location = GoodsType#ets_goods_type.bag_location,
	Cell = 0, %% 背包没有具体的格子位置
	%% 卸下该件装备镶嵌的所有宝石
	EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.subtype),
%%	{GoodsStatusTmp, _SuitReturn} = update_suit(PS, GoodsStatus, GoodsInfo, undefined, EquipPos),
	[NewGoodsInfo, GoodsStatus1] =
		lib_goods:change_goods_cell_and_use(GoodsInfo, Location, Cell, GoodsStatus),
	#goods_status{revelation_equip_location = OldEquipLocation, dict = OldGoodsDict} = GoodsStatus1,
	EquipLocation = lists:keydelete(EquipPos, 1, OldEquipLocation),
	{Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
	GoodsStatus2 = GoodsStatus1#goods_status{
		dict = Dict,
		revelation_equip_location = EquipLocation
	},
	lib_log_api:log_revelation_equip_goods(PS#player_status.id, EquipPos, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, 0, 0),
	ReturnGoodsL = [{stone_list, []}, {suit_return, []}],
	{ok, GoodsStatus2, NewGoodsInfo, GoodsL, Cell, [], ReturnGoodsL, PS}.


update_suit(PlayerId, GoodsStatus, StatusGoods) ->
	RevelationEquipList = lib_goods_util:get_revelation_equip_list(PlayerId, GoodsStatus#goods_status.dict),
	{Attr, _} = count_suit_attribute(RevelationEquipList),
	StatusGoods#status_goods{revelation_equip_suit_attr = Attr}.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
update_suit(_PS, GoodsStatus, _OldGoodsInfo, _GoodsInfo, _EquipPos) ->
	{GoodsStatus, []}.

%% -----------------------------------------------------------------
%% @desc     功能描述    %计算装备的属性
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
count_attribute(RevelationEquipList) ->
%%	?MYLOG("cym", "Revelation ~p~n", [RevelationEquipList]),
	F = fun(#goods{goods_id = GoodsTypeId}, AccAttrList) ->
		BaseAttr =
			case data_goods_type:get(GoodsTypeId) of
				#ets_goods_type{base_attrlist = V} ->
					V;
				_ ->
					[]
			end,
		OtherAttr =
			case data_revelation_equip:get_equip(GoodsTypeId) of
				#revelation_equip_cfg{other_attr = V2, recommend_attr = RecommendAttr} ->
					V2 ++ RecommendAttr;
				_ ->
					[]
			end,
		AccAttrList ++ BaseAttr ++ OtherAttr
	    end,
	AttrList = util:combine_list(lists:foldl(F, [], RevelationEquipList)),
%%	?MYLOG("cym", "AttrList ~p~n", [AttrList]),
	AttrList.

%%计算套装属性 RevelationEquipList : [#goods{}]
%%return    {属性列表， [{星数， 数量}]}
count_suit_attribute(RevelationEquipList) ->
	List = lists:reverse(data_revelation_equip:get_suit_list()),
	F = fun({Star, Num}, {AccAttr, SuitList}) ->
		case is_enough(Star, Num, RevelationEquipList) of
			true ->
				Attr = data_revelation_equip:get_suit_attr(Star, Num),
				case lists:keyfind(Num, 2, SuitList) of
					{_TempStar, Num} ->  %%如果有则，取高星的
						{AccAttr, SuitList};
					_ ->
						{Attr ++ AccAttr, [{Star, Num} | SuitList]}
				end;
			_ ->
				{AccAttr, SuitList}
		end
	    end,
	{AttrList, SuitList} = lists:foldl(F, {[], []}, List),
	AttrList1 = util:combine_list(AttrList),
	{AttrList1, SuitList}.



%%计算套装属性 RevelationEquipList : [#goods{}]
%%return    [{星数， 数量}]  %% 重复件数， 包含低星套装  eg:  [{0, 5}, {1, 5}]
count_suit(RevelationEquipList) ->
	List = data_revelation_equip:get_suit_list(),  %% 从低星到高星， 从少件到多件，后面满足的替换前面满足的
	F = fun({Star, Num}, SuitList) ->
		case is_enough(Star, Num, RevelationEquipList) of
			true ->
				lists:keystore(Star, 1, SuitList, {Star, Num});
			_ ->
				SuitList
		end
	    end,
	lists:foldl(F, [], List).

%%是否满足这个套装
is_enough(_Star, 0, _RevelationEquipList) ->
	true;
is_enough(_Star, _Num, []) ->
	false;
is_enough(Star, Num, [G | RevelationEquipList]) ->
	#goods{goods_id = GoodsTypeId} = G,
	case data_revelation_equip:get_equip(GoodsTypeId) of
		#revelation_equip_cfg{star = EquipStar} ->
			if
				EquipStar >= Star ->
					is_enough(Star, Num - 1, RevelationEquipList);
				true ->
					is_enough(Star, Num, RevelationEquipList)
			end;
		_ ->
			is_enough(Star, Num, RevelationEquipList)
	end.


%%穿戴装备后，更新聚灵属性， 技能属性
handle_af_equip(PS, SuitList) ->
	#player_status{revelation_equip = RevelationEquip, guild = Guild, id = RoleId, figure = F} = PS,
    #status_guild{id = GuildId} = Guild,
	#role_revelation_equip{max_figure_id = MaxId, current_figure = _CurrentId} = RevelationEquip,
	case get_max_suit_figure_id(SuitList) of
		{Id, Star, Num} ->
			if
				Id > MaxId ->  %%会触发传闻,且更新最新的传闻
					SuitName = get_suit_name(Star, Num),
%%					if
%%						Id > 1 ->  %%资源不够，特殊判断
%%							NewRevelationEquip = RevelationEquip#role_revelation_equip{max_figure_id = Id},
%%							save_to_db(RoleId, NewRevelationEquip),
%%							NewPS = PS#player_status{revelation_equip = NewRevelationEquip},
%%							NewPS;
%%						true ->
%%							lib_chat:send_TV({all}, ?MOD_REVELATION_EQUIP, 1, [F#figure.name, Star, SuitName]),
%%							lib_log_api:log_revelation_equip_suit(RoleId, Id),
%%							SuitFigure = get_figure_id(Id, F#figure.sex),
%%							NewRevelationEquip = RevelationEquip#role_revelation_equip{max_figure_id = Id, current_figure = Id},
%%							NewF = F#figure{revelation_suit = SuitFigure},
%%							save_to_db(RoleId, NewRevelationEquip),
%%							NewPS = PS#player_status{figure = NewF, revelation_equip = NewRevelationEquip},
%%							lib_scene:broadcast_player_attr(NewPS, [{7, SuitFigure}]),  %%
%%							lib_role:update_role_show(RoleId, [{figure, NewF}]),
%%							mod_scene_agent:update(NewPS, [{revelation_suit_figure_id, SuitFigure}]),
%%							NewPS
%%					end;
					lib_chat:send_TV({all}, ?MOD_REVELATION_EQUIP, 1, [F#figure.name, Star, SuitName]),
					lib_log_api:log_revelation_equip_suit(RoleId, Id),
					SuitFigure = get_figure_id(Id, F#figure.sex),
					NewRevelationEquip = RevelationEquip#role_revelation_equip{max_figure_id = Id, current_figure = Id},
					NewF = F#figure{revelation_suit = SuitFigure},
					save_to_db(RoleId, NewRevelationEquip),
					LastPS = PS#player_status{figure = NewF, revelation_equip = NewRevelationEquip},
					{ok, NewPS} = lib_fashion_api:take_off_other(revelation, LastPS),    % 脱掉其它时装（时装、神殿、套装）
					lib_scene:broadcast_player_attr(NewPS, [{7, SuitFigure}]),  %%
					lib_role:update_role_show(RoleId, [{figure, NewF}]),
					mod_scene_agent:update(NewPS, [{revelation_suit_figure_id, SuitFigure}]),
                    GuildId > 0 andalso mod_guild:update_guild_member_attr(RoleId, [{figure, NewF}]),
					NewPS;
				true ->
					PS
			end;
		_ ->
			PS
	end.


%%
handle_af_un_equip(PS, _SuitList) ->
	PS.

%% 保存数据库
save_to_db(RoleId, RevelationEquip) when is_record(RevelationEquip, role_revelation_equip) ->
	#role_revelation_equip{skill = Skill, gathering = Gathering, max_figure_id = MaxId, current_figure = CurrentId} = RevelationEquip,
	Sql = io_lib:format(?replace_sql, [RoleId, MaxId, CurrentId, util:term_to_string(Gathering), util:term_to_string(Skill)]),
	db:execute(Sql);
save_to_db(_RoleId, _RevelationEquip) ->
	ok.

get_max_suit([]) ->
	[];
get_max_suit(SuitList) ->
	F = fun(A, B) ->
		{Star1, Num1} = A,
		{Star2, Num2} = B,
		if
			Star1 > Star2 ->
				true;
			Star1 == Star2 andalso Num1 >= Num2 ->
				true;
			true ->
				false
		end
	    end,
	{Star, Num} = hd(lists:sort(F, SuitList)),
	{Star, Num}.


%%获得当前的套装形象最大值
get_max_suit_figure_id([]) ->
	{0, 0, 0};
get_max_suit_figure_id(SuitList) ->
	F = fun({Star, Num}, {MaxId, OldStar, OldNum}) ->
		case data_revelation_equip:get_suit_figure(Star, Num) of
			[] ->
				{MaxId, OldStar, OldNum};
			Id ->
				if
					Id > MaxId ->
						{Id, Star, Num};
					true ->
						{MaxId, OldStar, OldNum}
				end
		end
	    end,
	lists:foldl(F, {0, 0, 0}, SuitList).



get_figure_id(Id, _Sex) ->
	Id.
%%	case data_revelation_equip:get_figure(Id) of
%%		[] ->
%%			0;
%%		List ->
%%			case lists:keyfind(Sex, 1, List) of
%%				{Sex, Figure} ->
%%					Figure;
%%				_ ->
%%					0
%%			end
%%	end.




get_suit_name(Star, Num) ->
	case data_revelation_equip:get_suit_name(Star, Num) of
		[] ->
			<<>>;
		Name ->
			Name
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  吞噬
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
swallow(PS, Pos, GoodsInfoList, _GoodIdList) ->
	#player_status{sid = Sid, revelation_equip = RevelationEquip, id = RoleId} = PS,
	IdList = [{AutoId, Num} || #goods{id = AutoId, num = Num} <- GoodsInfoList],
	case lib_goods_api:delete_more_by_list(PS, IdList, revelation_equip_swallow) of
		1 -> %%成功
			AddExp = get_add_exp_by_goods(GoodsInfoList),
			#role_revelation_equip{gathering = Gathering} = RevelationEquip,
			case lists:keyfind(Pos, 1, Gathering) of
				{Pos, Lv, Exp} ->
					NewGathering = lists:keystore(Pos, 1, Gathering, {Pos, Lv, AddExp + Exp}),
					LastExp = AddExp + Exp,
					{ok, Bin} = pt_286:write(28603, [Pos, Lv, AddExp + Exp]);
				_ ->
					NewGathering = lists:keystore(Pos, 1, Gathering, {Pos, 0, AddExp}),
					LastExp = AddExp,
					{ok, Bin} = pt_286:write(28603, [Pos, 0, AddExp])
			end,
			lib_server_send:send_to_sid(Sid, Bin),
			lib_log_api:log_revelation_equip_swallow(RoleId, Pos,
				[{?TYPE_GOODS, GoodsId, Num} || #goods{goods_id = GoodsId, num = Num} <- GoodsInfoList], AddExp, LastExp),
			NewRevelationEquip = RevelationEquip#role_revelation_equip{gathering = NewGathering},
			save_to_db(RoleId, NewRevelationEquip),
			PS#player_status{revelation_equip = NewRevelationEquip};
		Err ->
			send_error(Sid, Err),
			PS
	end.


send_error(Sid, Err) ->
	{ok, Bin} = pt_286:write(28600, [Err]),
	lib_server_send:send_to_sid(Sid, Bin).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取吞噬的装备的经验
%% @param    参数      GoodsInfoList:: [#goods]
%% @return   返回值    Exp::integer()
%% @history  修改历史
%% -----------------------------------------------------------------
get_add_exp_by_goods(GoodsInfoList) ->
	F = fun(#goods{goods_id = GoodsTypeId, num = Num}, AccExp) ->
%%		?MYLOG("cym", "GoodsTypeId ~p Num ~p~n", [GoodsTypeId, Num]),
		AddExp = data_revelation_equip:get_exp_by_goods_id(GoodsTypeId) * Num,
		AccExp + AddExp
	    end,
	lists:foldl(F, 0, GoodsInfoList).

%% -----------------------------------------------------------------
%% @desc     功能描述  聚灵升级
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
up_lv(PS, Pos) ->
	#player_status{revelation_equip = RevelationEquip, sid = Sid, id = RoleId} = PS,
	#role_revelation_equip{gathering = Gathering} = RevelationEquip,
	case lists:keyfind(Pos, 1, Gathering) of
		{Pos, Lv, Exp} ->
			case get_next_lv_exp(Pos, Lv) of
				0 ->
					{false, ?ERRCODE(err286_err_max_lv)};
				NeedExp ->
					if
						Exp - NeedExp >= 0 ->
							NewGathering = lists:keystore(Pos, 1, Gathering, {Pos, Lv + 1, Exp - NeedExp}),
							{ok, Bin} = pt_286:write(28604, [Pos, Lv + 1, Exp - NeedExp]),
							lib_server_send:send_to_sid(Sid, Bin),
							NewRevelationEquip = RevelationEquip#role_revelation_equip{gathering = NewGathering},
							save_to_db(RoleId, NewRevelationEquip),
							NewPS1 = PS#player_status{revelation_equip = NewRevelationEquip},
							LastPS = hand_attr_and_power(NewPS1),
							lib_log_api:log_revelation_equip_gathering(RoleId, Lv, Lv + 1, NeedExp, Exp - NeedExp),
							{true, LastPS};
						true ->
							{false, ?ERRCODE(err286_err_exp_not_enough)}
					end
			end;
		_ ->
			{false, ?ERRCODE(err286_err_exp_not_enough)}
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获得下一个聚灵等级所需的经验
%% @param    参数     Pos::integer() 位置
%%                    Lv::integer() 当强等级
%% @return   返回值   NeedExp::integer()
%% @history  修改历史
%% -----------------------------------------------------------------
get_next_lv_exp(Pos, Lv) ->
	data_revelation_equip:get_next_lv_exp(Pos, Lv).

%% -----------------------------------------------------------------
%% @desc     功能描述 升级技能等级
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
up_skill(PS, SkillId) ->
	#player_status{revelation_equip = Revelation, id = RoleId, sid = Sid} = PS,
	#role_revelation_equip{skill = MySkill} = Revelation,
	MinLv = get_min_gathering_lv(Revelation, RoleId),
	?MYLOG("cym", "MinLv ~p~n", [MinLv]),
	case data_revelation_equip:get_skill(MinLv) of
		[_ | _] = SkillList ->
			case lists:keyfind(SkillId, 1, SkillList) of
				{SkillId, Lv} ->
					case lists:keyfind(SkillId, 1, MySkill) of
						{SkillId, MyLv} ->
							if
								MyLv < Lv ->
									NewMySKill = lists:keystore(SkillId, 1, MySkill, {SkillId, MyLv + 1}),
									NewRevelation = Revelation#role_revelation_equip{skill = NewMySKill},
									{ok, Bin} = pt_286:write(28605, [SkillId, MyLv + 1]),
									lib_server_send:send_to_sid(Sid, Bin),
									save_to_db(RoleId, NewRevelation),
									NewPS = PS#player_status{revelation_equip = NewRevelation},
									LastPS = hand_attr_and_power(NewPS),
									mod_scene_agent:update(LastPS, [{delete_passive_skill, [{SkillId, MyLv}]}]),
									mod_scene_agent:update(LastPS, [{passive_skill, [{SkillId, MyLv + 1}]}]),
									{true, LastPS};
								true ->
									{false, ?ERRCODE(err_286_max_skill_lv)}
							end;
						_ ->
							NewMySKill = lists:keystore(SkillId, 1, MySkill, {SkillId, 1}),

							NewRevelation = Revelation#role_revelation_equip{skill = NewMySKill},
							{ok, Bin} = pt_286:write(28605, [SkillId, 1]),
							lib_server_send:send_to_sid(Sid, Bin),
							save_to_db(RoleId, NewRevelation),
							NewPS = PS#player_status{revelation_equip = NewRevelation},
							LastPS = hand_attr_and_power(NewPS),
							mod_scene_agent:update(LastPS, [{passive_skill, [{SkillId, 1}]}]),
							{true, LastPS}
					end;
				_ ->
					{false, ?ERRCODE(err_286_err_skill_id)}
			end;
		_ ->
			{false, ?ERRCODE(err_286_err_gathering)}
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取聚灵最小等级 如果是位置不满, 还要考虑到孔位有没有效
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_min_gathering_lv(RevelationEquip, RoleId) ->
	#role_revelation_equip{gathering = Gathering} = RevelationEquip,
	WearEquipList = get_wear_equip_list(RoleId),
	EnablePosList = get_enable_pos(WearEquipList),
	Length = length(Gathering),
	EnablePosListLength = length(EnablePosList),
	if
		Length < ?pos_length orelse EnablePosListLength < ?pos_length ->
			0;
		true ->
			F = fun({_Pos, Lv, _Exp}, MinLv) ->
				if
					Lv < MinLv ->
						Lv;
					true ->
						MinLv
				end
			    end,
			MyMinLv = lists:foldl(F, 9999, Gathering),
			LvList = data_revelation_equip:get_skill_lv_list(),
			TempLvList = [TempLv || TempLv <- LvList, MyMinLv >= TempLv],
			case TempLvList of
				[LastLv | _] ->
					LastLv;
				_ ->
					0
			end
	end.




info(PS) ->
	#player_status{revelation_equip = Revelation, sid = Sid, id = RoleId} = PS,
	#role_revelation_equip{max_figure_id = MaxFigureId, current_figure = CurrentFigureId, gathering = Gathering, skill = SkillList} = Revelation,
	{Power, NewPS} = get_power(PS),
	SuitMsg = get_suit_msg(PS),
	WearEquipList = get_wear_equip_list(RoleId),
	PosList = get_enable_pos(WearEquipList),
	InfoGathering = get_info_gathering_list(Gathering, PosList),
	{ok, Bin} = pt_286:write(28606, [MaxFigureId, CurrentFigureId, Power, InfoGathering, SuitMsg, SkillList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{ok, NewPS}.

%%
get_power(PS) ->
%%	#player_status{revelation_equip = Revelation} = PS,
%%	#role_revelation_equip{power = Power} = Revelation,
	NewPS = update_power(PS),
	#player_status{revelation_equip = NewRevelation} = NewPS,
	#role_revelation_equip{power = NewPower} = NewRevelation,
	{NewPower, NewPS}.
%%	if
%%		Power == 0 ->
%%			NewPS = update_power(PS),
%%			#player_status{revelation_equip = NewRevelation} = NewPS,
%%			#role_revelation_equip{power = NewPower} = NewRevelation,
%%			{NewPower, NewPS};
%%		true ->
%%			{Power, PS}
%%	end.



%% 战力 = 装备本身属性 + 套装属性 + 聚灵属性 + 技能属性战力 + 技能本身的战力  要考虑属性是否失效了
%% 这个方法要在计算了全身战力后才能用
update_power(PS) ->
	#player_status{revelation_equip = Revelation, goods = _GoodsStatus, id = _RoleId} = PS,
	#role_revelation_equip{gathering = _Gathering, skill = _Skill, attr = AllAttr, skill_power = SkillPower} = Revelation,
%%	#status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
%%	WearEquipList = get_wear_equip_list(PS#player_status.id),
%%	EnablePosList = get_enable_pos(WearEquipList),  %%有效的聚灵孔位
%%	EnablePosListLength = length(EnablePosList),
%%	if
%%		EnablePosListLength >= ?pos_length ->
%%			{SkillAttr, SkillPower} = get_skill_attr(Skill);
%%		true ->
%%			SkillAttr = [], SkillPower = 0
%%	end,
%%	AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
%%	?MYLOG("cym", "RevelationEquipAttr ~p ~n SuitAttr ~p gathering ~p ~n SkillAttr ~p~n",
%%		[RevelationEquipAttr, SuitAttr, get_gathering_attr(Gathering, EnablePosList), SkillAttr]),
	AllPower = lib_player:calc_partial_power(PS#player_status.original_attr, SkillPower, AllAttr),
	NewRevelation = Revelation#role_revelation_equip{power = AllPower},
	PS#player_status{revelation_equip = NewRevelation}.



%% -----------------------------------------------------------------
%% @desc     功能描述   可以离线登录使用使用
%% @param    参数
%% @return   返回值    [{星数, 数量}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_suit_msg(PS) ->
	#player_status{off = Off, id = RoleId} = PS,
	case lib_goods_do:get_goods_status() of
		#goods_status{dict = Dict} ->
			RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, Dict);
		_ ->%%离线登录的情况
			case Off of
				#status_off{goods_status = GoodsStatus} ->
					RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, GoodsStatus#goods_status.dict);
				_ ->
					RevelationEquipList = []
			end
	end,
	{_, SuitList} = count_suit_attribute(RevelationEquipList),
%%	?MYLOG("cym", "AttrList ~p~n", [SuitList]),
	SuitList.


get_suit_msg_for_super_vip(PS) ->
	#player_status{off = Off, id = RoleId} = PS,
	case lib_goods_do:get_goods_status() of
		#goods_status{dict = Dict} ->
			RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, Dict);
		_ ->%%离线登录的情况
			case Off of
				#status_off{goods_status = GoodsStatus} ->
					RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, GoodsStatus#goods_status.dict);
				_ ->
					RevelationEquipList = []
			end
	end,
	count_suit(RevelationEquipList).




change_figure_id(PS, FigureId) ->
	?MYLOG("cym", "change figure  ~p~n", [FigureId]),
	#player_status{revelation_equip = Revelation, figure = Figure, guild = Guild, id = RoleId, sid = Sid} = PS,
    #status_guild{id = GuildId} = Guild,
	#role_revelation_equip{max_figure_id = MaxFigureId, current_figure = CurrId} = Revelation,
	if
		FigureId > MaxFigureId ->
%%			?MYLOG("cym", "change figure  ~n", []),
			{false, ?ERRCODE(err286_not_have_figure)};
		FigureId == CurrId ->
%%			?MYLOG("cym", "change figure  ~n", []),
			{false, ?ERRCODE(err286_same_figure_id)};
		true ->
%%			?MYLOG("cym", "change figure ~p~n", [Figure]),
			FigureSourceId = get_figure_id(FigureId, Figure#figure.sex),
			NewFigure = Figure#figure{revelation_suit = FigureSourceId},
			NewRevelation = Revelation#role_revelation_equip{current_figure = FigureId},
			save_to_db(RoleId, NewRevelation),
					NewPS = PS#player_status{revelation_equip = NewRevelation, figure = NewFigure},
			mod_scene_agent:update(NewPS, [{revelation_suit_figure_id, FigureSourceId}]),
			{ok, Bin} = pt_286:write(28607, [MaxFigureId, FigureId]),
			lib_server_send:send_to_sid(Sid, Bin),
			lib_scene:broadcast_player_attr(NewPS, [{7, FigureSourceId}]),  %%
			lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
            GuildId > 0 andalso mod_guild:update_guild_member_attr(RoleId, [{figure, NewFigure}]),
			{true, NewPS}
	end.

%% 只能在线使用
get_wear_equip_list(RoleId) ->
	#goods_status{dict = Dict} =
		lib_goods_do:get_goods_status(),
	RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, Dict),
	RevelationEquipList.

%% 离线使用
get_wear_equip_list(RoleId, Off) ->
	#goods_status{dict = Dict} = Off#status_off.goods_status,
	RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, Dict),
	RevelationEquipList.


%%
%%get_equip_list_attr(WearEquipList) ->
%%	F = fun(#goods{goods_id = GoodsTypeId}, AccList) ->
%%		BaseAttr
%%	    end,
%%	ok.


%%聚灵属性
%% param  EnablePosList:: [Pos]   有效的孔位
get_gathering_attr(Gathering, EnablePosList) ->
%%	?MYLOG("cym", "Gathering ~p  EnablePosList ~p~n", [Gathering, EnablePosList]),
	F = fun({Pos, Lv, _Exp}, AccList) ->
		case data_revelation_equip:get_gathering_attr(Pos, Lv) of
			[_ | _] = Attr ->
				case lists:member(Pos, EnablePosList) of  %%有效的孔位才能使聚灵属性生效
					true ->
						Attr ++ AccList;
					_ ->
						AccList
				end;
			_ ->
				AccList
		end
	    end,
	lists:foldl(F, [], Gathering).

%%获得技能和固定战力
%% param   [{SkillId, Lv}]
%% return  {AttrList, Power}
get_skill_attr(Skill) ->
	F = fun({SkillId, Lv}, {AccAttrList, AccPower}) ->
		case data_skill:get(SkillId, Lv) of
			#skill{lv_data = LvData} ->
				{[{AttrId, Attr} || {_, AttrId, Attr} <- LvData#skill_lv.base_attr] ++ AccAttrList, LvData#skill_lv.power + AccPower};
			_ ->
				{AccAttrList, AccPower}
		end

	    end,
	lists:foldl(F, {[], 0}, Skill).


%%返回有效的聚灵位置  只有穿戴了装备才能有效
%%WearEquipList:: [#goods{}]
%% return  [Pos]  有效的孔位
get_enable_pos(WearEquipList) ->
	F = fun(#goods{cell = Cell, goods_id = GoodsTypeId}, AccList) ->
		case data_revelation_equip:get_equip(GoodsTypeId) of
			#revelation_equip_cfg{star = Star} when Star >= ?gathering_star ->
%%				?MYLOG("cym", "Cell ~p~n", [Cell]),
				[Cell | AccList];
			_ ->
				AccList
		end
	    end,
	lists:foldl(F, [], WearEquipList).

hand_attr_and_power(_PS) ->
	PS = update_attr(_PS),
	NewPS1 = lib_player:count_player_attribute(PS),
	LastPs = update_power(NewPS1),
	lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
	mod_scene_agent:update(LastPs, [{battle_attr, LastPs#player_status.battle_attr}]),
	LastPs.


%%获取全部属性和战力
get_total_attr_and_power(#player_status{pid = Pid, id = _RoleId} = PS) when is_pid(Pid) ->  %%在线版
	#player_status{revelation_equip = Revelation, goods = _GoodsStatus, id = _RoleId} = PS,
	case Revelation of
		#role_revelation_equip{} ->
			#role_revelation_equip{skill = _Skill, attr = AllAttr, skill_power = SkillPower} = Revelation,
%%			#status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
%%			WearEquipList = get_wear_equip_list(PS#player_status.id),
%%%%			?MYLOG("cym", "WearEquipList ~p~n", [WearEquipList]),
%%			EnablePosList = get_enable_pos(WearEquipList),  %%有效的聚灵孔位
%%			EnablePosListLength = length(EnablePosList),
%%			if
%%				EnablePosListLength >= ?pos_length ->
%%					{SkillAttr, SkillPower} = get_skill_attr(Skill);
%%				true ->
%%					SkillAttr = [], SkillPower = 0
%%			end,
%%			AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
%%			?MYLOG("cym", "AllAttr ~p ~n SkillPower ~p ~n", [AllAttr, SkillPower]),
			{AllAttr, SkillPower};
		_ ->
%%			?MYLOG("cym", "total +++++++ ~n", []),
			{[], 0}
	end;
get_total_attr_and_power(PS) ->  %%离线版的
	#player_status{revelation_equip = Revelation, goods = GoodsStatus, off = Off, id = _RoleId} = PS,
	case Revelation of
		#role_revelation_equip{} ->
			#role_revelation_equip{gathering = Gathering, skill = Skill} = Revelation,
			#status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
			WearEquipList = get_wear_equip_list(PS#player_status.id, Off),
%%			?MYLOG("cym", "WearEquipList ~p~n", [WearEquipList]),
			EnablePosList = get_enable_pos(WearEquipList),  %%有效的聚灵孔位
			EnablePosListLength = length(EnablePosList),
			if
				EnablePosListLength >= ?pos_length ->
					{SkillAttr, SkillPower} = get_skill_attr(Skill);
				true ->
					SkillAttr = [], SkillPower = 0
			end,
%%			?MYLOG("cym", "~p ~n", [{RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr}]),
			AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
%%			?MYLOG("cym", "RoleId ~p ~n total ~p  SkillPower ~p~n", [RoleId, AttrList, SkillPower]),
			{AttrList, SkillPower};
		_ ->
			?MYLOG("cym", "total +++++++ ~n", []),
			{[], 0}
	end.

%%发送给客户端的聚灵信息
%%param  PosList::[pos] 有效的位置  Gathering:: [{Pos, Lv, Exp}]
%%return [{Pos, lv, exp, 0 | 1}]  1有效 0无效
get_info_gathering_list(Gathering, PosList) ->
	F = fun(Pos, AccList) ->
		case lists:keyfind(Pos, 1, Gathering) of
			{Pos, Lv, Exp} ->
				case lists:member(Pos, PosList) of
					true ->
						[{Pos, Lv, Exp, ?gathering_enable} | AccList];
					_ ->
						[{Pos, Lv, Exp, ?gathering_unable} | AccList]
				end;
			_ ->
				[{Pos, 0, 0, 0} | AccList]
		end
	    end,
	lists:foldl(F, [], ?pos_list).




calc_over_all_rating(GoodsInfo) ->
	Attr =
		case data_revelation_equip:get_equip(GoodsInfo#goods.goods_id) of
			#revelation_equip_cfg{other_attr = V} ->
				V;
			_ ->
				[]
		end,
	TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
	Rating = lib_equip:cal_attr_rating(Attr, TempInfo),
	?MYLOG("cym", "Ratting ~p~n", [Rating]),
	Rating.


%%处理穿戴后的技能
handle_skill(RevelationEquipList, OldRevelationEquipList, PS) ->
	EnablePosListLength = length(get_enable_pos(RevelationEquipList)),
	OldEnablePosListLength = length(get_enable_pos(OldRevelationEquipList)),
	#player_status{revelation_equip = Revelation} = PS,
	#role_revelation_equip{skill = PassiveSkill} = Revelation,
	if
		EnablePosListLength >= ?pos_length andalso OldEnablePosListLength < ?pos_length -> %% 从无效到有效
			mod_scene_agent:update(PS, [{passive_skill, PassiveSkill}]);  %%更新被动技能
		EnablePosListLength < ?pos_length andalso OldEnablePosListLength >= ?pos_length -> %% 从有效到无效
			mod_scene_agent:update(PS, [{delete_passive_skill, PassiveSkill}]);
		EnablePosListLength >= ?pos_length andalso OldEnablePosListLength >= ?pos_length -> %% 从有效到有效
			ok;
		EnablePosListLength < ?pos_length andalso OldEnablePosListLength < ?pos_length -> %% 从无效到无效
			ok;
		true ->
			ok
	end.

%%获得被动技能
get_skill(PS) ->
	#player_status{revelation_equip = Revelation} = PS,
	#role_revelation_equip{skill = Skill} = Revelation,
	WearEquipList = get_wear_equip_list(PS#player_status.id),
	Length = length(get_enable_pos(WearEquipList)),
	if
		Length >= ?pos_length ->
			Skill;
		true ->
			[]
	end.



get_other_attr(GTypeId) ->
	case data_revelation_equip:get_equip(GTypeId) of
		#revelation_equip_cfg{other_attr = OtherAttr, recommend_attr = V1} ->
			OtherAttr ++ V1;
		_ ->
			[]
	end.




gen_equip_dynamic_attr(GoodsTypeInfo, GoodsOther) ->
	BaseRating = lib_equip_api:cal_equip_rating(GoodsTypeInfo, []),
%%	?MYLOG("cym", "BaseRating ~p~n", [BaseRating]),
	GoodsOther#goods_other{rating = BaseRating}.


%%获取全部套装   同星数的， 发高数量的
get_suit_msg_all(PS) ->
	#player_status{off = Off, id = RoleId} = PS,
	case lib_goods_do:get_goods_status() of
		#goods_status{dict = Dict} ->
			RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, Dict);
		_ ->%%离线登录的情况
			case Off of
				#status_off{goods_status = GoodsStatus} ->
					RevelationEquipList = lib_goods_util:get_revelation_equip_list(RoleId, GoodsStatus#goods_status.dict);
				_ ->
					RevelationEquipList = []
			end
	end,
	count_suit_all_list(RevelationEquipList).


%%计算套装属性 RevelationEquipList : [#goods{}]
%%return    [{星数， 数量}]    满足的所有列表
count_suit_all_list(RevelationEquipList) ->
	List = lists:reverse(data_revelation_equip:get_suit_list()),
	F = fun({Star, Num}, SuitList) ->
		case is_enough(Star, Num, RevelationEquipList) of
			true ->
				case lists:keyfind(Star, 1, SuitList) of
					{Star, Num1} ->
						if
							Num > Num1 ->  %%取高数量的
								[{Star, Num} | SuitList];
							true ->
								SuitList
						end;
					_ ->
						[{Star, Num} | SuitList]
				end;
			_ ->
				SuitList
		end
	    end,
	lists:foldl(F, [], List).


%%处理特殊合成后的装备处理
up_equip_list_af_compose(PlayerStatus, OldRevelationEquipList) ->
	NewGoodsStatus = lib_goods_do:get_goods_status(),
	RevelationEquipList = lib_goods_util:get_revelation_equip_list(PlayerStatus#player_status.id, NewGoodsStatus#goods_status.dict),
	Attr = count_attribute(RevelationEquipList),
	{SuitAttr, _SuitList} = count_suit_attribute(RevelationEquipList),
	#player_status{goods = StatusGoods} = PlayerStatus,
	NewStatusGoods = StatusGoods#status_goods{revelation_equip_attr = Attr, revelation_equip_suit_attr = SuitAttr},
	LastPS = hand_attr_and_power(PlayerStatus#player_status{goods = NewStatusGoods}),
	handle_skill(RevelationEquipList, OldRevelationEquipList, LastPS),
	pp_revelation_equip:handle(28606, LastPS, []),
	LastPS.

%%所有属性 玩家进程中
count_all_attr(PS) ->
	#player_status{revelation_equip = Revelation, goods = GoodsStatus, id = _RoleId} = PS,
	case Revelation of
		#role_revelation_equip{} ->
			#role_revelation_equip{skill = Skill, gathering = Gathering} = Revelation,
			#status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
%%			?MYLOG("cym", "RevelationEquipAttr ~p, SuitAttr ~p~n", [RevelationEquipAttr, SuitAttr]),
			WearEquipList = get_wear_equip_list(PS#player_status.id),
			EnablePosList = get_enable_pos(WearEquipList),  %%有效的聚灵孔位
			EnablePosListLength = length(EnablePosList),
			if
				EnablePosListLength >= ?pos_length ->
					{SkillAttr, SkillPower} = get_skill_attr(Skill);
				true ->
					SkillAttr = [], SkillPower = 0
			end,
			AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
%%			?MYLOG("cym", "RevelationEquipAttr ~p ~n SuitAttr ~p gathering ~p ~n SkillAttr ~p~n",
%%				[RevelationEquipAttr, SuitAttr, get_gathering_attr(Gathering, EnablePosList), SkillAttr]),
			{AttrList, SkillPower};
		_ ->
%%			?MYLOG("cym", "total +++++++ ~n", []),
			{[], 0}
	end.


update_attr(PS) ->
	#player_status{revelation_equip = Revelation, goods = GoodsStatus, id = _RoleId} = PS,
	#role_revelation_equip{gathering = Gathering, skill = Skill} = Revelation,
	#status_goods{revelation_equip_attr = RevelationEquipAttr, revelation_equip_suit_attr = SuitAttr} = GoodsStatus,
	WearEquipList = get_wear_equip_list(PS#player_status.id),
	EnablePosList = get_enable_pos(WearEquipList),  %%有效的聚灵孔位
	EnablePosListLength = length(EnablePosList),
	if
		EnablePosListLength >= ?pos_length ->
			{SkillAttr, SkillPower} = get_skill_attr(Skill);
		true ->
			SkillAttr = [], SkillPower = 0
	end,
	AttrList = util:combine_list(RevelationEquipAttr ++ SuitAttr ++ get_gathering_attr(Gathering, EnablePosList) ++ SkillAttr),
%%	?MYLOG("cym", "RevelationEquipAttr ~p ~n SuitAttr ~p gathering ~p ~n SkillAttr ~p~n",
%%		[RevelationEquipAttr, SuitAttr, get_gathering_attr(Gathering, EnablePosList), SkillAttr]),
	NewRevelation = Revelation#role_revelation_equip{attr = AttrList, skill_power = SkillPower},
	PS#player_status{revelation_equip = NewRevelation}.




get_figure(Id, Sex) ->
	Sql = io_lib:format(?select_sql, [Id]),
	case db:get_row(Sql) of
		[_MaxFigureId, CurrentFigure, _Gathering, _Skill] ->
			RevelationFigure = get_figure_id(CurrentFigure, Sex),
			RevelationFigure;
		_ ->
			0
	end.

%% 刷新天启套装形象
refresh_revelation_figure(PS) ->
	#player_status{revelation_equip = Revelation, figure = Figure} = PS,
	#role_revelation_equip{current_figure = CurrentFigure} = Revelation,
	RevelationFigure = get_figure_id(CurrentFigure, Figure#figure.sex),
	PS#player_status{figure = Figure#figure{revelation_suit = RevelationFigure}}.



gm_add_equip(Status, Num) ->
	case data_revelation_equip:get_all_equip_ids() of
		GoodsTypeIds when is_list(GoodsTypeIds) andalso GoodsTypeIds =/= [] ->
			Fun = fun(GoodsTypeId, Acc) ->
				[{?TYPE_GOODS, GoodsTypeId, Num}|Acc]
			      end,
			Reward = lists:foldl(Fun, [], GoodsTypeIds),
%%			?PRINT("Reward ~p~n", [Reward]),
			lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id);
		_->
			skip
	end.
