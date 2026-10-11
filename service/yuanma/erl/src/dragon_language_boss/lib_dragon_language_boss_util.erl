%%%-----------------------------------
%%% @Module      : lib_dragon_language_boss_util
%%% @Author      : cxd
%%% @Email       : 
%%% @Created     : 2020.8.18
%%% @Description : 龙语boss模块工具
%%%-----------------------------------
-module(lib_dragon_language_boss_util).
-include("def_module.hrl").
-include("vip.hrl").
-include("scene.hrl").
-include("dragon_language_boss.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").



-compile(export_all).

%% 获取总次数
get_all_time(RoleId, Vip) ->
	#role_vip{vip_type = VipType, vip_lv = VipLv} = Vip,
	%%进入次数
	EnterCount = lib_vip_api:get_vip_privilege(?MOD_DRAGON_LANGUAGE_BOSS, 3, VipType, VipLv),
	%% vip购买次数
	BuyCount = mod_daily:get_count_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 2),
	EnterCount + BuyCount.

%% 获取龙语boss次数数据
%% 返回{总次数，已经进入次数，剩余次数}
get_all_count(RoleId, Vip) ->
	AllCount = get_all_time(RoleId, Vip),
	EnterCountYet = mod_daily:get_count_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1),
	LastCount = max(0, AllCount - EnterCountYet),
	{AllCount, EnterCountYet, LastCount}.

%% 获取消耗
get_cost(CostList, EnterCount) ->
	case lists:keyfind(EnterCount, 1, CostList) of
		{EnterCount, Cost} ->
			Cost;
		_ ->
			[]
	end.

%% 是否在同场景中
is_in_map(MapId, SceneId) ->
	case data_dragon_language_boss:get_map(MapId) of
		#base_dragon_language_boss_map{scene = MapSceneId} ->
			MapSceneId == SceneId;
		_ ->
			true
	end.

%% 是否是龙语boss场景
is_in_dragon_language_boss(SceneId) ->
	case data_scene:get(SceneId) of
		#ets_scene{type = ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS} ->
			true;
		_ ->
			false
	end.

%% 获取玩家的区id（有可能是旧的id）
get_zone_id_by_role_id(RoleId, ZoneList) ->
	F = fun
		(ZoneData) when is_record(ZoneData, dragon_language_boss_zone) ->
			#dragon_language_boss_zone{role_list = RoleList} = ZoneData,
			case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of 
				#role_msg{} -> true;
				_ -> false
			end;
		(_) -> false
	end,
	Result = lists:filter(F, ZoneList),
	?IF(length(Result) > 0, [#dragon_language_boss_zone{zone_id = ZoneId} | _] = Result, ZoneId = 0),
	ZoneId.

%% 清除玩家数据
clear_role_msg(RoleId, ZoneList) ->
	F = fun(#dragon_language_boss_zone{zone_id = ZoneId, role_list = RoleList} = ZoneData, FunZoneList) ->
		case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
			#role_msg{ref = Ref} ->
				%% 取消定时器
				util:cancel_timer(Ref),
				NewRoleList = lists:keydelete(RoleId, #role_msg.role_id, RoleList),
				NewZoneData = ZoneData#dragon_language_boss_zone{role_list = NewRoleList},
				lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, FunZoneList, NewZoneData);
			_ ->
				FunZoneList
		end
	end,
	lists:foldl(F, ZoneList, ZoneList).

%% 特殊情况处理：玩家在场景里刚好改变分区，然后请求如加时间
%% 游戏服执行
in_scene_zone_change(add_time, [RoleId, Cost, LeftCount, AllCount, LeftTime]) ->
	%% 补发奖励给玩家并告诉玩家期间不能加时间
	mod_daily:decrement_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1),
	in_scene_zone_change_send_mail(add_time, RoleId, Cost),
	pp_dragon_language_boss:send_error(RoleId, ?ERRCODE(err651_zone_change_can_not_add_time)),
	{ok, Bin} = pt_651:write(65107, [LeftCount, AllCount, LeftTime]),
	lib_server_send:send_to_uid(RoleId, Bin);
in_scene_zone_change(_, _) -> skip.

%% 返还奖励
in_scene_zone_change_send_mail(Action, RoleId, RewardList) ->
	Code = case Action of
		add_time ->
			?ERRCODE(err651_add_time);
		_ -> <<""/utf8>>
	end,
	#errorcode_msg{about = ActionName} = data_errorcode_msg:get(Code),
	Title = utext:get(6510001),
	Content = utext:get(6510002),
	FomatContent = uio:format(Content, [ActionName]),
	lib_mail_api:send_sys_mail([RoleId], Title, FomatContent, RewardList).

%% 发送传闻
send_tv(add_drop_log, [GoodsInfoL, RoleName, RoleServerNum, ServerIds]) ->
	TvId = 1,
	ModName = data_module:get(651),
	F = fun({GTypeId, _, _, _}) ->
		Args = [RoleServerNum, RoleName, ModName, GTypeId],
		send_zone_tv(TvId, Args, ServerIds)
	end,
	lists:foreach(F, GoodsInfoL);
send_tv(_, _) -> skip.

send_zone_tv(_TvId, _Args, []) -> ok;
send_zone_tv(TvId, Args, [ServerId | ServerIds]) ->
	mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{all}, ?MOD_DRAGON_LANGUAGE_BOSS, TvId, Args]),
	send_zone_tv(TvId, Args, ServerIds).