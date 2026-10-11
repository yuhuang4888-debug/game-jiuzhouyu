%%%--------------------------------------
%%% @Module  : lib_mon_pic
%%% @Author  : zengzy 
%%% @Created : 2018-04-10
%%% @Description:  怪物图鉴
%%%--------------------------------------
-module(lib_mon_pic).
-compile(export_all).
-export([

    ]).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("mon_pic.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("attr.hrl").

%% ---------------------------------- 登录加载 -----------------------------------
%%登录
login(RoleId) ->
	case lib_mon_pic_util:db_pic_select(RoleId) of
		[] -> #status_mon_pic{};
		List->
			PicList = init_pic(List,[]),
			Groups = lib_mon_pic_util:db_pic_group_select(RoleId),
			GroupList = init_pic_group(Groups, []),
			{Attr, SpecialAttr} = calc_all_attr(PicList, GroupList),
			#status_mon_pic{pic_list=PicList, group_list=GroupList, attr=Attr, special_attr = SpecialAttr}
	end.


%初始图鉴
init_pic([], List)-> List;
init_pic([[PicId,Lv]|T], List) ->
	MonPic = #mon_pic{pic_id=PicId,lv=Lv},
	NMonPic = calc_pic_attr(MonPic),
	KeyPos = #mon_pic.pic_id,
	NList = lists:keystore(PicId, KeyPos, List, NMonPic),
	init_pic(T, NList).


%%初始组合
init_pic_group([], GroupList) -> GroupList;
init_pic_group([[GroupId,Lv]|T], GroupList) ->
	case data_mon_pic:get_group(GroupId, Lv) of
		[] -> init_pic_group(T, GroupList);
		_ ->
			init_pic_group(T, [{GroupId,Lv}|GroupList])
	end.


%% ---------------------------------- 协议交互 -----------------------------------
%%打开界面
open_list(PS) ->
	#player_status{id=RoleId, sid=Sid, figure=Figure} = PS,
	#figure{lv=RoleLv} = Figure,
%%	?PRINT("44200 mod_counter:get_count~p~n",[{RoleId, ?MOD_MON_PIC,mod_counter:get_count(RoleId, ?MOD_MON_PIC, 1)}]),
    case mod_counter:get_count(RoleId, ?MOD_MON_PIC, 1) of 
        0 ->
            OpenList = data_mon_pic:get_mon_pic_open(),
            F = fun({OpenLv, Reward}, List) ->
                case OpenLv =< RoleLv of 
                    true -> Reward ++ List;
                    _ -> List
                end
            end,
            RewardList = lists:foldl(F, [], OpenList),
            mod_counter:increment(RoleId, ?MOD_MON_PIC, 1),
            Produce = #produce{type = mon_pic, reward = RewardList},
            {_, LastPS} = lib_goods_api:send_reward_with_mail(PS, Produce),
            {ok, Bin} = pt_442:write(44200, [0]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, LastPS};
        Times ->
			?PRINT("44200 Times:~p~n",[Times]),
            {ok, Bin} = pt_442:write(44200, [Times]),
            lib_server_send:send_to_sid(Sid, Bin)
    end.


%%展示列表
mon_pic_list(PS,Type) ->
	#player_status{sid=Sid, mon_pic=StatusPic, original_attr = OriginalAttr} = PS,
	#status_mon_pic{group_list=GroupList, pic_list=PicList, attr = MonPicAttr} = StatusPic,
	F1 = fun({GroupId,GroupLv}, TmpList)->
		case data_mon_pic:get_group(GroupId,GroupLv) of
			#base_group{type=Type} -> [{GroupId,GroupLv}|TmpList];
			_ -> TmpList
		end
	end,
	GList = lists:foldl(F1, [], GroupList),
	F2 = fun(#mon_pic{pic_id=PicId,lv=Lv}, TmpList)->
		case data_mon_pic:get_pic_type(PicId) of
			Type ->
				case data_mon_pic:get_lv_attr(PicId, Lv) of
					CurAttrList when CurAttrList =/= [] ->
						CurPower = lib_player:calc_partial_power(PS, OriginalAttr, 0, CurAttrList);
					_ ->
						CurPower = 0
				end,	
				case data_mon_pic:get_lv_attr(PicId, Lv + 1) of
					NextAttrList when NextAttrList =/= [] ->
						NextPower = lib_player:calc_expact_power(PS, OriginalAttr, 0, NextAttrList);
					_ ->
						NextPower = 0
				end,	
				[{PicId,Lv, CurPower, NextPower}|TmpList];
			_ -> 
				TmpList
		end
	end,
	PList = lists:foldl(F2, [], PicList),
	MonPicPower= lib_player:calc_partial_power(OriginalAttr, 0, MonPicAttr),
	{ok, BinData} = pt_442:write(44201, [Type, GList, PList, MonPicPower]),
	lib_server_send:send_to_sid(Sid, BinData).


%%激活图鉴
active(PS, PicId) ->
	CheckList = [check_cfg, check_active, check_cost, check_lv, check_open, check_other],
	case lib_mon_pic_util:check_active(PS, PicId, CheckList) of
		true-> do_active(PS, PicId);
		{false, Err} -> {false, Err}
	end.


do_active(PS, PicId) ->
	#player_status{id=RoleId,mon_pic=StatusPic, original_attr = OriginalAttr} = PS,
	#status_mon_pic{pic_list=PicList, group_list=GroupList} = StatusPic,
	#base_pic{lv=Lv, quality = Quality} = data_mon_pic:get_pic(PicId),
	Cost = data_mon_pic:get_lv_cost(PicId,Lv),
	case lib_goods_api:cost_object_list(PS, Cost, mon_pic, "mon_pic") of
		{true,NewPS} ->
			lib_mon_pic_util:db_pic_replace(RoleId,PicId,Lv),
			MonPic = calc_pic_attr(#mon_pic{pic_id=PicId,lv=Lv}),
			NPicList = lists:keystore(PicId, #mon_pic.pic_id, PicList, MonPic),
			%% 成就
			Fun = fun(#mon_pic{pic_id = TemPicId, lv = TemLv}, {Acc, Sum}) ->
				#base_pic{quality = TemQuality} = data_mon_pic:get_pic(TemPicId),
				case lists:keyfind(TemQuality, 1, Acc) of
					{_, Num} -> {lists:keystore(TemQuality, 1, Acc, {TemQuality, Num + 1}), Sum + TemLv};
					_ -> {lists:keystore(TemQuality, 1, Acc, {TemQuality, 1}), Sum + TemLv}
				end
			end,
			{AchivList, TotalLv} = lists:foldl(Fun, {[], 0}, NPicList),

			{Attr, SpecialAttr} = calc_all_attr(NPicList, GroupList),
			NStatusPic = StatusPic#status_mon_pic{pic_list=NPicList,attr=Attr, special_attr = SpecialAttr},
			% ?PRINT("~p~n",[NPicList]),
			NPS = NewPS#player_status{mon_pic=NStatusPic},
			LastPS = lib_player:count_player_attribute(NPS),
			lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),	
			lib_log_api:log_mon_pic_lv(RoleId, PicId, Lv, Cost, utime:unixtime()),
			%% 触发激活事件
			LLastPS = lib_mon_pic_event:active_event(LastPS, AchivList, TotalLv, Quality, PicId),
			CurPower = lib_player:calc_partial_power(PS,OriginalAttr, 0, MonPic#mon_pic.attr),
			case data_mon_pic:get_lv_attr(PicId, Lv + 1) of
				NextAttrList when NextAttrList =/= [] ->
					NextPower = lib_player:calc_expact_power(PS, OriginalAttr, 0, NextAttrList);
				_ ->
					NextPower = 0
			end,
			{true, LLastPS, CurPower, NextPower};
		{false, Err, _} -> {false, Err} 
	end.


%%升级
up_lv(PS, PicId) ->
	CheckList = [check_active, check_max_lv, check_cost],
	case lib_mon_pic_util:check_up_lv(PS, PicId, CheckList) of
		true-> do_up_lv(PS, PicId);
		{false, Err} -> {false, Err}
	end.


do_up_lv(PS, PicId) ->
	#player_status{id=RoleId,mon_pic=StatusPic, original_attr = OriginalAttr} = PS,
	#status_mon_pic{pic_list=PicList, group_list=GroupList} = StatusPic,
	MonPic = get_pic(PS, PicId),
	#mon_pic{lv=Lv} = MonPic,
	NewLv = Lv+1,
	Cost = data_mon_pic:get_lv_cost(PicId,NewLv),
	case lib_goods_api:cost_object_list(PS, Cost, mon_pic, "mon_pic") of
		{true,NewPS} ->
			lib_mon_pic_util:db_pic_replace(RoleId,PicId,NewLv),
			NMonPic = calc_pic_attr(MonPic#mon_pic{lv=NewLv}),
			NPicList = lists:keystore(PicId, #mon_pic.pic_id, PicList, NMonPic),
			{Attr, SpecialAttr} = calc_all_attr(NPicList, GroupList),
			NStatusPic = StatusPic#status_mon_pic{pic_list=NPicList,attr=Attr, special_attr = SpecialAttr},
			NPS = NewPS#player_status{mon_pic=NStatusPic},
			LastPS = lib_player:count_player_attribute(NPS),
			lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),	
			lib_log_api:log_mon_pic_lv(RoleId, PicId, NewLv, Cost, utime:unixtime()),
			CurPower = lib_player:calc_partial_power(PS, OriginalAttr, 0, NMonPic#mon_pic.attr),
			case data_mon_pic:get_lv_attr(PicId, NewLv + 1) of
				NextAttrList when NextAttrList =/= [] ->
					NextPower = lib_player:calc_expact_power(PS, OriginalAttr, 0, NextAttrList);
				_ ->
					NextPower = 0
			end,
			{true, LastPS, NewLv, CurPower, NextPower};
		{false, Err, _} -> {false, Err} 
	end.


%%激活组合
active_group(PS, GroupId) ->
	CheckList = [check_cfg, check_condition],
	case lib_mon_pic_util:check_active_group(PS, GroupId, CheckList) of
		true-> do_active_group(PS, GroupId);		
		{false, Err} -> {false, Err}
	end.	


do_active_group(PS, GroupId) ->
	#player_status{id=RoleId,mon_pic=StatusPic} = PS,
	#status_mon_pic{pic_list=PicList, group_list=GroupList} = StatusPic,
	case lists:keyfind(GroupId, 1, GroupList) of 
		false-> GroupLv = 1;
		{_, OLv} -> GroupLv = OLv+1
	end,	
	lib_mon_pic_util:db_pic_group_replace(RoleId,GroupId,GroupLv),
	NGroupList = lists:keystore(GroupId,1,GroupList,{GroupId,GroupLv}),
	{Attr, SpecialAttr} = calc_all_attr(PicList, NGroupList),
	NStatusPic = StatusPic#status_mon_pic{group_list=NGroupList,attr=Attr, special_attr = SpecialAttr},
	NPS = PS#player_status{mon_pic=NStatusPic},
	{ok, NPS1} = lib_goods_util:count_role_equip_attribute(NPS),
	LastPS = lib_player:count_player_attribute(NPS1),
	lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),	
	{true, LastPS, GroupLv}.	


%%展示已激活列表（用于分解展示）
mon_pic_actived_list(PS) ->
	#player_status{sid = Sid, mon_pic = StatusPic} = PS,
	#status_mon_pic{pic_list = PicList} = StatusPic,
	PList = [PicId || #mon_pic{pic_id = PicId} <- PicList],
	{ok, BinData} = pt_442:write(44205, [PList]), 
	lib_server_send:send_to_sid(Sid, BinData).


%%获取图鉴
get_pic(PS, PicId) ->
	StatusPic = PS#player_status.mon_pic,
	PicList = StatusPic#status_mon_pic.pic_list,
	case lists:keyfind(PicId,#mon_pic.pic_id,PicList) of
		false -> false;
		MonPic -> MonPic
	end.


%% ---------------------------------- 属性计算 -----------------------------------
%%计算单个图鉴属性 
calc_pic_attr(MonPic)->
	#mon_pic{pic_id=PicId,lv=Lv} = MonPic,
	Attr = data_mon_pic:get_lv_attr(PicId,Lv),
	MonPic#mon_pic{attr=Attr}.


%%计算所有图鉴属性
calc_all_pic_attr([], Attr)-> Attr;
calc_all_pic_attr([MonPic|T], Attr) ->
	#mon_pic{attr=PicAttr} = MonPic,
	NAttr = lib_player_attr:add_attr(list,[Attr,PicAttr]),
	calc_all_pic_attr(T, NAttr).


%%计算所有属性
calc_all_attr(PicList, GroupList) ->
	%%图鉴属性 
	PicAttr = calc_all_pic_attr(PicList, []),
	%%图鉴组合属性
	GroupAttr = calc_group_attr(GroupList, []),
	AllAttr = lib_player_attr:add_attr(list,[GroupAttr,PicAttr]),
	SpecialAttr = calc_special_attr(AllAttr),
	{AllAttr, SpecialAttr}.

calc_special_attr(AttrList) ->
	Fun = fun({AttrId, Value}, Acc) ->
		case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE) of
			true ->
				case lists:keyfind(AttrId, 1, Acc) of
					{AttrId, OldValue} ->
						lists:keystore(AttrId, 1, Acc, {AttrId, Value+OldValue});
					_ ->
						lists:keystore(AttrId, 1, Acc, {AttrId, Value})
				end;
			_ ->
				Acc
		end
		  end,
	lists:foldl(Fun, [], AttrList).


%%组合属性
calc_group_attr([], Attr) -> Attr;
calc_group_attr([{GroupId,GroupLv}|T],Attr) ->
	#base_group{attr=GroupAttr} = data_mon_pic:get_group(GroupId,GroupLv),
	NAttr = lib_player_attr:add_attr(list,[Attr,GroupAttr]),
	calc_group_attr(T, NAttr).


get_mon_pic_list_by_color(PS, Color) ->
	#player_status{mon_pic=StatusPic} = PS,
	#status_mon_pic{pic_list=PicList} = StatusPic,
	F = fun(#mon_pic{pic_id = PicId}, Acc) ->
		case data_mon_pic:get_pic(PicId) of 
			#base_pic{quality = Color} -> [PicId|Acc];
			_ -> Acc
		end
	end,
	lists:foldl(F, [], PicList).

%%gm激活
gm_active(PS, PicId) ->
	#player_status{id=RoleId,mon_pic=StatusPic} = PS,
	#status_mon_pic{pic_list=PicList, group_list=GroupList} = StatusPic,
	#base_pic{lv=Lv} = data_mon_pic:get_pic(PicId),
	CheckList = [check_cfg, check_active],
	case lib_mon_pic_util:check_active(PS, PicId, CheckList) of
		true-> 
			lib_mon_pic_util:db_pic_replace(RoleId,PicId,Lv),
			MonPic = calc_pic_attr(#mon_pic{pic_id=PicId,lv=Lv}),
			NPicList = lists:keystore(PicId, #mon_pic.pic_id, PicList, MonPic),
			{Attr, SpecialAttr} = calc_all_attr(NPicList, GroupList),
			NStatusPic = StatusPic#status_mon_pic{pic_list=NPicList,attr=Attr, special_attr = SpecialAttr},
			% ?PRINT("~p~n",[NPicList]),
			NPS = PS#player_status{mon_pic=NStatusPic},
			LastPS = lib_player:count_player_attribute(NPS),
			lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),	
			LastPS;
		{false, Err} -> 
			?PRINT("~p~n",[Err]),
			{false, Err}
	end.	


%% -----------------------------------------------------------------
%% @desc     功能描述  获取图鉴战力
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_power(PS) ->
	#player_status{mon_pic = MonPic, original_attr = SumAttr} = PS,
	case MonPic of
		#status_mon_pic{attr = Attr, special_attr = Attr2} ->
			lib_player:calc_partial_power(SumAttr, 0, Attr ++ Attr2);
		_ ->
			0
	end.

send_42201_by_pic(Player, PicId) ->
	case data_mon_pic:get_pic(PicId) of
		#base_pic{ type = Type} ->
			lib_mon_pic:mon_pic_list(Player,Type);
		_ ->
			?ERR_MSG("error_send_42201:~p", [PicId]),
			skip
	end.

send_42201_by_group(Player, GroupId) ->
	#player_status{ mon_pic = #status_mon_pic{ group_list = GroupList } } = Player,
	case lists:keyfind(GroupId, 1, GroupList) of
		false-> Lv = 1;
		{_, OLv} -> Lv = OLv+1
	end,
	case data_mon_pic:get_group(GroupId,Lv) of
		#base_group{ type = Type } ->
			lib_mon_pic:mon_pic_list(Player,Type);
		_ ->
			?ERR_MSG("error_send_42201_group:~p", [GroupId]),
			skip
	end.