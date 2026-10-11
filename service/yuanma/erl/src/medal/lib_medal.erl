%%%-----------------------------------
%%% @Module      : lib_medal
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 八月 2018 15:32
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_medal).
-include("server.hrl").
-include("medal.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-author("chenyiming").


%% API
-compile(export_all).

%%登录初始化
login(#player_status{id = Id, figure = Figure, pid = Pid} = Ps) ->
	Sql = io_lib:format(<<"select  medal_id, is_repair, stren_lv, stren_exp from  player_medal  where  player_id = ~p">>, [Id]),
	case db:get_row(Sql) of
		[] ->
			MedelId = 1,
			StrenLv = 0,
			StrenExp = 0,
			IsRepair = 0;
		[MedelId, IsRepair, StrenLv, StrenExp] ->
			ok
	end,
	case data_medal:get_medal(MedelId) of
		[] ->
			NewPs = Ps#player_status{medal = #medal{is_repair = IsRepair}, figure = Figure#figure{medal_id = MedelId}};
		_TempMedal ->
			TempMedal = _TempMedal#medal{stren_lv = StrenLv, stren_exp = StrenExp},
			IsPid = is_pid(Pid),
			if
				IsRepair == 0 andalso IsPid == true ->  %%未修复
					case data_medal:get_new_medal_id(MedelId) of
						{NewId, Reward} ->
							NewMedal = TempMedal#medal{is_repair = 1, id = NewId},
							%%清掉物品
							case lib_goods_api:get_goods_num(Ps, [38040024]) of
								[{GoodsTypeId, Num} | _] when Num > 0 ->
									case lib_goods_api:cost_object_list_with_check(Ps, [{?TYPE_GOODS, GoodsTypeId, Num}], medal_clear, "") of
										{true, Ps1} ->
											ok;
										_ ->
											Ps1 = Ps
									end;
								_ ->
									Ps1 = Ps
							end,
							save_to_db(Id, NewMedal),
							case Reward of
								[] ->
									ok;
								_ ->
									Title = utext:get(1340001),
									Content = utext:get(1340002),
									lib_mail_api:send_sys_mail([Id], Title, Content, Reward)
							end,
							NewPs = Ps1#player_status{medal = NewMedal, figure = Figure#figure{medal_id = NewId}};
						_Res ->
							NewMedal = TempMedal#medal{is_repair = 1},
							save_to_db(Id, NewMedal),
							NewPs = Ps#player_status{medal = NewMedal}
					end;
				true ->
					NewPs = Ps#player_status{medal = TempMedal#medal{is_repair = IsRepair}, figure = Figure#figure{medal_id = MedelId}}
			end
	end,
	NewPs.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取勋章信息  要检查是否开启，不开启要返回错误码
%% @param    参数      Ps::#player_status{}
%% @return   返回值    {ok, OldMedalId, Honour, LastPs}   {ok, 勋章id, 荣誉值，NewPs}
%% @history  修改历史
%% -----------------------------------------------------------------
get_medal(#player_status{medal = Medal, jjc_honour = Honour} = Ps) ->
	#medal{id = MedalId} = Medal,
	{ok, MedalId, Honour, Ps}.

get_medal_offline(RoleId) ->
	Sql = io_lib:format(<<"select  medal_id  from  player_medal  where  player_id = ~p">>, [RoleId]),
	case db:get_row(Sql) of
		[] ->
			MedalId = 1;
		[MedalId] ->
			ok
	end,
	MedalId.

save_to_db(RoleId, #medal{id = MedalId, is_repair = IsRepair, stren_lv = StrenLv, stren_exp = StrenExp}) ->
	%%同步数据库
	Sql = io_lib:format(<<"replace into player_medal(player_id, medal_id, is_repair, stren_lv, stren_exp) values(~p, ~p, ~p, ~p, ~p)">>,
		[RoleId, MedalId, IsRepair, StrenLv, StrenExp]),
	db:execute(Sql).

%% -----------------------------------------------------------------
%% @desc     功能描述  升级勋章  %%检查-获取下一级勋章信息 ->消耗 ->修改Ps->同步数据库 ->返回勋章id,声望值给上一层
%% @param    参数     PS::#player_status{}
%% @return   返回值   {false, Res, Ps} |
%%                   {ok, OldMedalId, Honour, LastPs}   {ok, 勋章id, 荣誉值，NewPs}
%% @history  修改历史
%% -----------------------------------------------------------------
upgrade(#player_status{medal = Medal, id = PlayerId, figure = Figure} = Ps) ->
	case lib_medal_check:upgrade(Ps) of
		true ->
			%%下一级勋章信息
%%			?DEBUG("log1",[]),
			#medal{id = OldMedalId, cost = Cost, is_repair = IsRepair, title = OldTitle} = Medal,
			NewMedalId = OldMedalId + 1,
			NewMedalCfg = data_medal:get_medal(NewMedalId),  %%必然有，已检查
%%			?MYLOG("cym", "Medal ~p~n", [Medal]),
			NewMedal = NewMedalCfg#medal{is_repair = IsRepair, stren_lv = Medal#medal.stren_lv, stren_exp = Medal#medal.stren_exp},
%%			?MYLOG("cym", "NewMedal ~p~n", [NewMedal]),
			case lib_goods_api:cost_object_list(Ps, Cost, medal_upgrade_lv, "medal_upgrade_lv") of  %%消耗
				{false, Res, NewPs} ->
					{false, Res, NewPs};
				{true, NewPs} ->
					#figure{name = RoleName} = Figure,
					_LastPs = NewPs#player_status{medal = NewMedal, figure = Figure#figure{medal_id = NewMedalId}},  %%修改Ps
					lib_role:update_role_show(PlayerId, [{figure, Figure#figure{medal_id = NewMedalId}}]),
					mod_scene_agent:update(_LastPs, [{figure, Figure#figure{medal_id = NewMedalId}}]),
					lib_scene:broadcast_player_attr(NewPs, [{9, NewMedalId}]),  %%
					lib_log_api:log_role_medal(PlayerId, Cost, OldMedalId, NewMedalId),
					LastPsTmp = upgrade_event(_LastPs, OldMedalId, NewMedalId),

					TitleName = data_medal:get_title_name(list_to_integer(NewMedal#medal.title)),
					OldTitle =/= NewMedalCfg#medal.title andalso lib_chat:send_TV({all}, ?MOD_MEDAL, 2, [RoleName, PlayerId, TitleName]),

					%%计算属性
					LastPs = lib_player:count_player_attribute(LastPsTmp),
					lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
					%%同步数据库
					save_to_db(PlayerId, NewMedal),
					#player_status{jjc_honour = Honour} = LastPs,
%%					?DEBUG("log3",[]),
					{ok, SupvipPs} = lib_supreme_vip_api:upgrade_medal(LastPs, NewMedalId),
					{ok, NewMedalId, Honour, SupvipPs}
			end;
		{false, Res} ->
%%			?DEBUG("log2 ~p~n", [Res]),
			{false, Res, Ps}
	end.

upgrade_event(PS, OldMedalId, NewMedalId) ->
	lib_task_api:upgrade_medal(PS, NewMedalId),
	%%成就
	lib_achievement_api:medal_lv_event(PS, NewMedalId),
	%%推送礼包
	LastPs1 = lib_push_gift_api:medal_level_up(PS, NewMedalId),
	% ?PRINT("HERE: ~p~n", [is_record(LastPs1, player_status)]),
	{ok, LastPsTmp} = lib_temple_awaken_api:trigger_medal_lv(LastPs1, OldMedalId),
	{ok, LastPsTmp1} = lib_custom_the_carnival:upgrade_medal(LastPsTmp, NewMedalId),
	LastPsTmp1.


get_need_power_and_dun_id(MedalId) ->
	case data_medal:get_medal(MedalId) of
		#medal{upgrade_power = Power, other_condition = Condition} ->
			DunId = ulists:keyfind(dungeon, 1, Condition, 0),
			NeedPassLayers = ulists:keyfind(dun_id, 1, Condition, 0),
			{Power, DunId, NeedPassLayers};
		_ ->
			{0, 0, 0}
	end.

lv_stren(Ps, GoodsList) ->
%%	?MYLOG("medel", "GoodsList ~p~n", [GoodsList]),
%%	#player_status{original_attr = OldAttr} = Ps,
	DeleteList = get_stren_delete_list(GoodsList),
%%	?MYLOG("medel", "DeleteList ~p~n", [DeleteList]),
	ok = lib_goods_dict:start_dict(),
	GoodsStatus = lib_goods_do:get_goods_status(),
	#player_status{id = RoleId, medal = Medal} = Ps,
	#medal{id = MedalId, stren_lv = PreStrenLv, stren_exp = PreStrenExp} = Medal,
%%	lib_goods_util:delete_goods(),
	F = fun({Type, GoodsInfo, Exp}, {AccExp, AccGoodsStatus}) ->
		case Type of
			change_num ->  %%改变数量
				[_, NewAccGoodsStatus] = lib_goods:change_goods_num(GoodsInfo, GoodsInfo#goods.num, AccGoodsStatus);
			delete ->   %% 直接删除物品
				NewAccGoodsStatus = lib_goods:delete_goods(GoodsInfo, AccGoodsStatus)
		end,
		{AccExp + Exp, NewAccGoodsStatus}
	    end,
	{AllExp, NewGoodsStatus} = lists:foldl(F, {0, GoodsStatus}, DeleteList),
	{Dict1, UpGoods1} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
	LastGoodsStatus = NewGoodsStatus#goods_status{dict = Dict1},
	lib_goods_do:set_goods_status(LastGoodsStatus),
	lib_goods_api:notify_client_num(RoleId, UpGoods1),
	NewMedal = up_stren_lv(Medal, AllExp),
	#medal{stren_lv = StrenLv, stren_exp = Exp} = NewMedal,
	
	%%同步数据库
	save_to_db(RoleId, NewMedal),
	NewPS = Ps#player_status{medal = NewMedal},
	LastPS = lib_player:count_player_attribute(NewPS),
	lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
	mod_scene_agent:update(LastPS, [{battle_attr, LastPS#player_status.battle_attr}]),
	
	
	MedalAttr = get_stren_attr(LastPS),
	#player_status{original_attr = OldAttr} = LastPS,
	Power = lib_player:calc_partial_power(OldAttr, 0, MedalAttr),
	{ok, Bin} = pt_134:write(13407, [StrenLv, Exp, Power]),
%%	?MYLOG("medel", "StrenLv, Exp, Power ~p~n", [{StrenLv, Exp, Power}]),
	
	#medal{stren_lv = AfStrenLv, stren_exp = AfStrenExp} = NewMedal,
	F1 = fun(Item, AccList) ->
%%			?MYLOG("medel", "Item ~p~n", [Item]),
		{_, #goods{goods_id = GoodsTypeId, id = AutoId}, FunExp} = Item,
		case data_medal:get_goods_exp(GoodsTypeId) of
			GoodsExp when GoodsExp > 0 ->
				GoodsCostNum = trunc(FunExp / GoodsExp),
				[{AutoId, GoodsTypeId, GoodsCostNum} | AccList];
			_ ->
				AccList
		end
	     end,
	CostList = lists:foldl(F1, [], DeleteList),
	lib_log_api:log_medal_stren(RoleId, MedalId, PreStrenLv, PreStrenExp, AfStrenLv, AfStrenExp, CostList),
	lib_server_send:send_to_uid(RoleId, Bin),
	{ok, LastPS}.




%% -----------------------------------------------------------------
%% @desc     功能描述   获得要删除的经验
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_stren_delete_list(GoodsList) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	F = fun({GoodsAutoId, Num}, AccList) ->
		case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
			#goods{goods_id = GoodsTypeId, num = GoodsNum} = GoodsInfo when GoodsNum > Num ->
				Exp = data_medal:get_goods_exp(GoodsTypeId),
				[{change_num, GoodsInfo#goods{num = GoodsNum - Num}, Exp * Num} | AccList];
			#goods{goods_id = GoodsTypeId, num = GoodsNum} = GoodsInfo when GoodsNum == Num ->
				Exp = data_medal:get_goods_exp(GoodsTypeId),
				[{delete, GoodsInfo, Exp * Num} | AccList];
			_ ->
				AccList
		end
	    end,
	lists:foldl(F, [], GoodsList).


%% 强化
up_stren_lv(Medal, AllExp) ->
%%	?MYLOG("medel", "AllExp ~p~n", [AllExp]),
	#medal{stren_lv = Lv, stren_exp = OldExp} = Medal,
	NeedExp = data_medal:get_need_exp(Lv + 1),
	if
		NeedExp == 0 -> %% 满级了
			Medal#medal{stren_exp = OldExp + AllExp};
		AllExp + OldExp >= NeedExp ->
			up_stren_lv(Medal#medal{stren_lv = Lv + 1, stren_exp = 0}, AllExp + OldExp - NeedExp);
		true ->
			Medal#medal{stren_exp = OldExp + AllExp}
	end.


get_attr(PlayerStatus) ->
	#player_status{medal = Medal} = PlayerStatus,
	case Medal of
		#medal{add_attr = Attr, stren_lv = StrenLv} ->
			Attr ++ data_medal:get_attr(StrenLv);
		_ ->
			[]
	end.


get_stren_attr(PlayerStatus) ->
	#player_status{medal = Medal} = PlayerStatus,
	case Medal of
		#medal{stren_lv = StrenLv} ->
			data_medal:get_attr(StrenLv);
		_ ->
			[]
	end.



gm_repair_stren_lv() ->
	Sql1 = io_lib:format(<<"select player_id from  player_medal">>, []),
	AllRoleIds = db:get_all(Sql1),
	[
		begin
			Sql = io_lib:format(<<"select  af_stren_lv, af_stren_exp from  log_medal_stren where role_id =  ~p">>, [RoleId]),
			List = db:get_all(Sql),
			if
				List == [] ->
					skip;
				true ->
					{MaxLv, MaxExp} = get_max_msg(List),
					lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_medal, gm_repair_stren_lv, [MaxLv, MaxExp])
			end
		end
		||
		[RoleId] <- AllRoleIds].

gm_repair_stren_lv(PS, MaxLv, MaxExp) ->
	#player_status{medal = Medal, id = RoleId} = PS,
	NewMedal = Medal#medal{stren_exp = MaxExp, stren_lv = MaxLv},
	save_to_db(RoleId, NewMedal),
	PS#player_status{medal = NewMedal}.




%% 补偿
gm_repair_stren_lv_compensate() ->
	Sql1 = io_lib:format(<<"select player_id from  player_medal">>, []),
	AllRoleIds = db:get_all(Sql1),
	[
		begin
			Sql = io_lib:format(<<"select  af_stren_lv, af_stren_exp, cost, time from  log_medal_stren where role_id = ~p">>, [RoleId]),
			List = db:get_all(Sql),
			if
				List == [] ->
					skip;
				true ->
					{MaxLv, _MaxExp, _, MaxTime} = get_max_msg(List),
					Title = "勋章强化异常处理补偿",
					Content = "因功能异常导致强化等级重置的问题已经修复完毕,为你恢复至历史最高等级,并返还异常期间消耗的强化材料\r给您造成的不便我们深表歉意,感谢您对我们游戏的支持",
					Fun = fun([ItemLv, _, ItemCost, ItemTime], AccList) ->
							if
								ItemLv < MaxLv andalso  ItemTime > MaxTime ->
									RealCostList = [{?TYPE_GOODS, GoodsId, Num} || {_, GoodsId, Num}<- util:bitstring_to_term(ItemCost)],
									RealCostList ++ AccList;
								true ->
									AccList
							end
						end,
					ListReward = lists:foldl(Fun, [], List),
					if
						ListReward == [] ->
							skip;
						true ->
							lib_mail_api:send_sys_mail([RoleId], Title, Content, ListReward)
					end
			end
		end
		||
		[RoleId] <- AllRoleIds].






get_max_msg(List) ->
	F = fun([StrenLv1, StrenExp1, _Cost1, _Time1], [StrenLv2, StrenExp2, _Cost2, _Time2]) ->
		if
			StrenLv1 > StrenLv2 ->
				true;
			StrenLv1 == StrenLv2 ->
				StrenExp1 >= StrenExp2;
			true ->
				false
		end
	    end,
	[Lv, Exp, Cost, Time] = hd(lists:sort(F, List)),
	{Lv, Exp, Cost, Time}.


















