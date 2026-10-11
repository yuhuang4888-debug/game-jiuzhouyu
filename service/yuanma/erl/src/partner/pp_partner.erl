-module(pp_partner).

% -export([handle/3]).

% -include("server.hrl").
% -include("partner.hrl").
% -include("attr.hrl").
% -include("figure.hrl").
% -include("goods.hrl").
% -include("common.hrl").
% -include ("errcode.hrl").
% -include ("skill.hrl").
% -include ("def_daily.hrl").
% -include ("def_module.hrl").
% -include ("daily.hrl").
% -include ("rec_event.hrl").
% -include ("def_event.hrl").
% -include ("def_fun.hrl").

% % 招募状态
% handle(41200, PlayerStatus, []) ->
% 	NowTime = utime:unixtime(),
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	{CoinTms, CoinEt} = PartnerSt#partner_status.recruit_type1,
% 	{GoldTms, GoldEt} = PartnerSt#partner_status.recruit_type2,
% 	#base_partner_recruit{guaran_num = CoinNum} = data_partner:get_recuit(?RECRUIT_TYPE1),
% 	#base_partner_recruit{guaran_num = GoldNum} = data_partner:get_recuit(?RECRUIT_TYPE2),
% 	CoinRest = max(0, CoinEt-NowTime),
% 	GoldRest = max(0, GoldEt-NowTime),
% 	Rsp = [CoinRest, CoinNum-CoinTms, GoldRest, GoldNum-GoldTms],
% 	%?PRINT("41200 Rsp:~p~n", [Rsp]),
% 	{ok, BinData} = pt_412:write(41200, Rsp),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % 获取玩家伙伴列表
% handle(41201, PlayerStatus, []) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	RspList = lib_partner_do:get_player_partners(PartnerSt),
% 	%?PRINT("41201 ~p~n",[RspList]),
% 	{ok, BinData} = pt_412:write(41201, [RspList]),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % 获取伙伴基础信息
% handle(41202, PlayerStatus, [Id]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	Rsp = lib_partner_do:get_partner_base_info(PartnerSt, Id),
% 	%?PRINT("41202 Rsp: ~p~n", [Rsp]),
% 	{ok, BinData} = pt_412:write(41202, Rsp),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % 获取伙伴二级属性信息
% handle(41203, PlayerStatus, [Id]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	Rsp = case maps:find(Id, PartnerSt#partner_status.partners) of
% 		{ok, Partner} -> 
% 			Attr = Partner#partner.battle_attr,
% 			Attr_L = maps:to_list(Attr),
% 			[1, Partner#partner.id, Attr_L];
% 		_ -> [0, 0, []]
% 	end,
% 	{ok, BinData} = pt_412:write(41203, Rsp),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % % 赠与伙伴
% % handle(41208, PlayerStatus, [PartnerId]) ->
% % 	#player_status{sid = Sid} = PlayerStatus,
% % 	case lib_partner:give_partner(PlayerStatus, PartnerId, "", 0) of 
% % 		{true, Partner, NewPS} ->
% % 			#partner{id=Id, partner_id=PartnerId, state=State, pos=Pos, lv=Lv, combat_power=CombatPower, prodigy=Prodigy, equip = #partner_equip{weapon_st = WeaponSt}} = Partner,
% % 			{ok, BinData} = pt_412:write(41208, [1, Id, PartnerId, Lv, State, Pos, round(CombatPower), Prodigy, WeaponSt]),
% % 			lib_server_send:send_to_sid(Sid, BinData),
% % 			{ok, NewPS};
% % 		{false, Res, NewPS} ->
% % 			?ERR_MSG(41208, Res),
% % 			{ok, BinData} = pt_412:write(41208, [Res, 0, 0, 0, 0, 0, 0, 0, 0]),
% % 			lib_server_send:send_to_sid(Sid, BinData),
% % 			{ok, NewPS}
% % 	end;

% % 招募伙伴
% handle(41209, PlayerStatus, [TenRecruit, CostType]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:recruit(PlayerStatus, TenRecruit, CostType) of 
% 		{true, NewPS, PartnerList, RewardList} ->
% 			%lib_partner_do:send_daily_recruit_times(NewPS, TenRecruit),		
% 			lib_partner_do:send_msg_41209(Sid, TenRecruit, CostType, PartnerList, RewardList, 1),
% 			handle(41200, NewPS, []),
%             case CostType of
%                 2 -> lib_task_api:partner_recruit(NewPS); %% 触发钻石招募任务
%                 _ -> skip
%             end,
%             PartnerSt = lib_partner_do:get_partner_status(),
%             PartnerCollect = length(PartnerSt#partner_status.recruit_list),
%             CostTimes = ?IF(TenRecruit==1,10,1),
%             Data = #callback_partner_recruit{recruit_type=CostType, recruit_times=CostTimes, recruited_num=PartnerCollect},
%             %% {ok, NewPS1} = lib_player_event:dispatch(NewPS, ?EVENT_PARTNER_RECRUIT, Data),
%             % 物品获得提示
%             lib_partner:send_goods_notice_msg(Sid, RewardList),
% 			% {ok, BinData1} = pt_110:write(11060, [1, RewardList]),
% 			% lib_server_send:send_to_sid(Sid, BinData1),
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41209, Res),
% 			lib_partner_do:send_msg_41209(Sid, TenRecruit, CostType, [], [], Res),
% 			{ok, NewPS}
% 	end;

% % 伙伴 上下阵
% handle(41210, PlayerStatus, [Id, Opra]) ->
% 	%?PRINT("41210 41210 41210 ~n", []),
% 	#player_status{sid = Sid} = PlayerStatus,
% 	Result = case Opra of
% 		1 -> 
% 			lib_partner:partner_battle(PlayerStatus, Id);
% 		2 -> 
% 			lib_partner:partner_sleep(PlayerStatus, Id);
% 		_ -> {ok, 2, PlayerStatus}
% 	end,
% 	case Result of 
% 		{true, Pos, NewPS} ->
% 			{ok, BinData} = pt_412:write(41210, [1, Pos]),
% 			lib_server_send:send_to_sid(Sid, BinData),
%             case Opra of
%                 1 -> lib_task_api:partner_battle(NewPS);
%                 _ -> skip
%             end,
% 			{ok, battle_attr, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41210, Res),
% 			{ok, BinData} = pt_412:write(41210, [Res, 0]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 使用升级药品
% handle(41212, PlayerStatus, [Id, GoodsId, Num]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_goods_do:check_num([{GoodsId, Num}]) of
% 		0 -> 
% 			Res = ?ERRCODE(goods_not_enough),
% 			?PRINT("41212 fail Res: ~p~n", [Res]),
%             {ok, BinData} = pt_412:write(41212, [Res, 0, 0, 0, 0]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, PlayerStatus};
% 		1 ->
% 			case data_partner:get_exp_book(GoodsId) of
% 				#base_exp_book{exp = Exp} -> 
% 					{_, NewPS} = lib_partner:partner_add_exp(PlayerStatus, Id, Exp, GoodsId, Num),
% 					{ok, NewPS};
% 				_ ->
% 					{ok, BinData} = pt_412:write(41212, [?ERRCODE(err412_cfg_not_exist), 0, 0, 0, 0]),
% 					lib_server_send:send_to_sid(Sid, BinData),
% 					{ok, PlayerStatus}
% 			end
% 	end;

% % 突破
% handle(41214, PlayerStatus, [Id]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:partner_break(PlayerStatus, Id) of 
% 		{true, Partner, NewPS} ->
% 			AttrL = lib_partner_do:get_rsp_attr_list(Partner),
% 			Rsp = [1, Id, Partner#partner.break_st, AttrL],
% 			{ok, BinData} = pt_412:write(41214, Rsp),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41214, Res),
% 			{ok, BinData} = pt_412:write(41214, [Res, 0, 0, []]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 洗髓
% handle(41215, PlayerStatus, [Id]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:wash_partner(PlayerStatus, Id) of 
% 		{true, OldPartner, WashPartner, NewPS} ->
% 			Rsp = lib_partner_do:wash_partner_rsp(OldPartner, WashPartner),
% 			{ok, BinData} = pt_412:write(41215, Rsp),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			%% {ok, NewPS1} = lib_player_event:dispatch(NewPS, ?EVENT_PARTNER_WASH),
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41215, Res),
% 			{ok, BinData} = pt_412:write(41215, [Res, []]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;
	
% % 洗髓 替换
% handle(41216, PlayerStatus, [Op, _Id]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case Op of
% 		0 -> 
% 			NewPS = lib_partner:wash_keep(PlayerStatus),
% 			{ok, NewPS};
% 		1 ->
% 			case lib_partner:wash_replace(PlayerStatus) of
% 				{true, WashPartner, NewPS} ->
% 					#partner{id= PartId, combat_power = CombatPower, prodigy = Prodigy} = WashPartner,
% 					{ok, BinData1} = pt_412:write(41216, [PartId, round(CombatPower), Prodigy]),
% 					lib_server_send:send_to_sid(Sid, BinData1),
% 					Rsp = lib_partner_do:get_partner_base_info(WashPartner),
% 					{ok, BinData} = pt_412:write(41202, Rsp),
% 					lib_server_send:send_to_sid(Sid, BinData),
% 					lib_partner:send_attr_list(Sid, WashPartner),
% 					{ok, NewPS};
% 				{false, Res, NewPS} ->
% 					?ERR_MSG(41216, Res),
% 					{ok, NewPS}
% 			end;
% 		_ -> 
% 			{ok, PlayerStatus}
% 	end;

% % 获取布阵
% handle(41218, PlayerStatus, []) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	Embattle = PartnerSt#partner_status.embattle,
% 	EmbattleList = lib_partner_util:conver_to_embattle_list(Embattle, []),
% 	%?PRINT("41218 41218 ~p~n", [EmbattleList]),
% 	{ok, BinData} = pt_412:write(41218, [EmbattleList]),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % 改变 布阵
% handle(41219, PlayerStatus, [SrcPos, DesPos]) ->
% 	{_, NewPS} = lib_partner:change_embattle(PlayerStatus, [SrcPos, DesPos]),
% 	handle(41218, NewPS, []);

% % 资质提升
% handle(41221, PlayerStatus, [Id, Type, GoodsList]) ->
% 	case lib_partner:partner_promote(PlayerStatus, [Id, Type, GoodsList]) of
% 		{true, UpdateAttr, NewPS} ->
%             lib_task_api:partner_promote(NewPS),
%             case UpdateAttr == 0 of 
%             	true -> {ok, NewPS};
%             	false -> {ok, battle_attr, NewPS}
%             end;
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41221, Res),
% 			{ok, BinData} = pt_412:write(41221, [Res, 0, 0, [], 0, 0]),
% 			lib_server_send:send_to_sid(NewPS#player_status.sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 学习/替换的技能
% handle(41223, PlayerStatus, [Id, GoodId, Pos, Op]) ->
% 	Result = case Op of 
% 		1 ->
% 			lib_partner:partner_learn_skill(PlayerStatus, [Id, GoodId]);
% 		2 ->
% 			lib_partner:partner_skill_replace(PlayerStatus, [Id, GoodId, Pos]);
% 		_ ->
% 			{false, 2, PlayerStatus}
% 	end,
% 	case Result of 
% 		{true, UpdateAttr, NewPos, Partner, NewPS} ->
% 			#partner{id=Id, skill=Skill, combat_power=CombatPower} = Partner, 
% 			{SkId, SkLv, NewPos} = lists:keyfind(NewPos, 3, Skill#partner_skill.skill_list),
% 			[{SkBookId, Color, _, _}|_T] = data_partner:get_skill_by_skid(SkId),
% 			{ok, BinData} = pt_412:write(41223, [1, Id, SkBookId, SkId, SkLv, NewPos, round(CombatPower)]),
% 			lib_server_send:send_to_sid(NewPS#player_status.sid, BinData),
% 			lib_partner:send_attr_list(NewPS#player_status.sid, Partner),
% 			%% {ok, NewPS1} = lib_player_event:dispatch(NewPS, ?EVENT_PARTNER_LEARN_SK, {SkId, Color}),
%             lib_task_api:partner_skill(NewPS),
% 			case UpdateAttr == 0 of 
% 				true -> {ok, NewPS};
% 				false -> {ok, battle_attr, NewPS}
% 			end;
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41223, Res),
% 			{ok, BinData} = pt_412:write(41223, [Res, 0, 0, 0, 0, 0, 0]),
% 			lib_server_send:send_to_sid(NewPS#player_status.sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 预览所有伙伴
% handle(41224, PlayerStatus, []) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	Rsp = PartnerSt#partner_status.recruit_list,
% 	{ok, BinData} = pt_412:write(41224, [Rsp]),
% 	lib_server_send:send_to_sid(Sid, BinData),
% 	{ok, PlayerStatus};

% % 遣散
% handle(41225, PlayerStatus, [IdList]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:partner_disband(PlayerStatus, IdList) of 
% 		{true, NewPS, AwardList} ->
% 			{ok, BinData} = pt_412:write(41225, [1, AwardList]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			% 物品获得提示
% 			lib_partner:send_goods_notice_msg(Sid, AwardList),
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41225, Res),
% 			{ok, BinData} = pt_412:write(41225, [Res]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;
	
% % 召回
% handle(41226, PlayerStatus, [PartnerId]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:partner_callback(PlayerStatus, PartnerId) of 
% 		{true, NewPS} ->
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41226, Res),
% 			{ok, BinData} = pt_412:write(41226, [Res, 0, 0, 0, 0, 0, 0, 0, 0]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 更改上阵位置	
% handle(41227, PlayerStatus, [Src, Dst]) ->
% 	#player_status{sid = Sid} = PlayerStatus,
% 	case lib_partner:change_battle_pos(PlayerStatus, Src, Dst) of 
% 		{true, BattlePos, NewPS} -> 
% 			{ok, BinData} = pt_412:write(41227, [1, BattlePos]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS};
% 		{false, Res, NewPS} ->
% 			?ERR_MSG(41227, Res),
% 			{ok, BinData} = pt_412:write(41227, [Res]),
% 			lib_server_send:send_to_sid(Sid, BinData),
% 			{ok, NewPS}
% 	end;

% % 翻牌	
% handle(41230, PlayerStatus, [RecruitType, Id]) ->
% 	?PRINT("41230 41230 41230 ~p~n", [{RecruitType, Id}]),
% 	#player_status{figure = #figure{name = PlayerName}} = PlayerStatus,
% 	PartnerSt = lib_partner_do:get_partner_status(),
% 	case maps:get(Id, PartnerSt#partner_status.partners, none) of
% 		#partner{quality = Quality} = Partner when RecruitType == ?RECRUIT_TYPE1, Quality>=3 ->
% 			% 卢币招募 得到A级以上伙伴发传闻
% 			lib_partner:send_tv_recruit(PlayerName, [Partner], recruit_type1, 3),
% 			{ok, PlayerStatus};
% 		#partner{quality = Quality} = Partner when RecruitType == ?RECRUIT_TYPE2, Quality>=4 ->
% 			% 钻石招募 得到S级以上伙伴发传闻
% 			lib_partner:send_tv_recruit(PlayerName, [Partner], recruit_type2, 4),
% 			{ok, PlayerStatus};
% 		_ -> {ok, PlayerStatus}
% 	end;

% % 查询上阵伙伴状态(客户端用于显示红点)	
% handle(41231, PlayerStatus, []) ->
% 	PartnerList = lib_partner_api:get_battle_partners(PlayerStatus),
% 	F = fun(Partner, List) ->
% 		#partner{id = Id, partner_id = PartnerId, break_st = BreakSt, skill = PartnerSk} = Partner,
% 		ClientAttrL = lib_partner_do:get_rsp_attr_list(Partner),
% 		ClientSkL = lib_partner_do:get_rsp_sk_list(PartnerSk#partner_skill.skill_list, []),
% 		[{Id, PartnerId, BreakSt, ClientAttrL, ClientSkL}|List]
% 	end,
% 	Rsp = lists:foldl(F, [], PartnerList),
% 	{ok, BinData} = pt_412:write(41231, [Rsp]),
% 	lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData),
% 	{ok, PlayerStatus};
	
% handle(_CMD, PlayerStatus, _R) ->
% 	%?PRINT("412xx   ~p~n", [CMD]),
% 	{ok, PlayerStatus}.

