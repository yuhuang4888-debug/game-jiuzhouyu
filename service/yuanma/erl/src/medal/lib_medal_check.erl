%%%-----------------------------------
%%% @Module      : lib_medal_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 八月 2018 21:26
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_medal_check).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("medal.hrl").
-author("chenyiming").

%% API
-compile(export_all).


%% -----------------------------------------------------------------
%% @desc     功能描述  勋章升级后前的检查    1.是否存在下一级勋章  2.是否足够扣除， 3，是否开放
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
upgrade(#player_status{medal = Medal} =  Ps) ->
	#medal{id = MedalId, cost = Cost} = Medal,
	CheckList = [
		{check_exist_next_medal, MedalId},
		{check_cost, Ps, Cost},
		{check_power_dungeon,Ps, MedalId}
	],
	check_list(CheckList).


check_list([]) ->
	true;
check_list([H | CheckList]) ->
	case check(H) of
		true ->
			check_list(CheckList);
		{false, Res} ->
			{false, Res}
	end.

%%是否存在下一级
check({check_exist_next_medal, MedalId}) ->
	case  data_medal:get_medal(MedalId + 1) of
		 [] ->
			 {false, ?ERRCODE(err134_max_lv)};
	     _ ->
			true
	end;

%%消耗
check({check_cost, Ps, Cost}) ->
	case lib_goods_api:check_object_list(Ps, Cost) of
		true ->
			true;
		{false, Res} ->
			{false, Res}
	end;

%%战力
check({check_power_dungeon, Ps, MedalId}) ->
	{NeedPower, DunId, NeedPassLayers} = lib_medal:get_need_power_and_dun_id(MedalId),
	#player_status{combat_power = Power, id = RoleId} = Ps,
	Res = lib_dungeon_api:check_ever_finish(RoleId, DunId),
	HasPassLayers = lib_dungeon_rune:get_dungeon_level(Ps),
	%% ?INFO("HasPassLayers:~p//NeedPassLayers:~p", [HasPassLayers, NeedPassLayers]),
	if
		Power < NeedPower ->
			{false, ?ERRCODE(err134_power_not_enough)};
		DunId =/= 0 andalso Res == false ->
			{false, ?ERRCODE(err134_have_not_finish_dun)};
		NeedPassLayers =/= 0 andalso HasPassLayers < NeedPassLayers ->
			{false, ?ERRCODE(err134_have_not_finish_dun)};
		true ->
			true
	end;


check(_T) ->
	?DEBUG("log4 ~p~n", [_T]).