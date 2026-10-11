%%%-----------------------------------
%%% @Module      : pp_medal
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 八月 2018 15:32
%%% @Description : 文件摘要
%%%-----------------------------------
-module(pp_medal).
-include("server.hrl").
-include("medal.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-author("chenyiming").

%% API
-compile(export_all).





%% -----------------------------------------------------------------
%% @desc     功能描述  命名134路由前处理事项
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle(Cmd, Ps, Data) ->
	do_handle(Cmd, Ps, Data).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取勋章信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13401, #player_status{sid = Sid, medal = Medal, original_attr = SumOAttr} = Ps, _Data) ->
	case lib_medal:get_medal(Ps) of
		{ok, MedalId, Honour, NewPs} ->  %%当前勋章Id，当前声望值
%%			?DEBUG("MedalId ~p, Honour ~p~n", [MedalId, Honour]),
			#medal{stren_lv = StrenLv, stren_exp = StrenExp} = Medal,
			Power = lib_player:calc_partial_power(SumOAttr, 0, lib_medal:get_stren_attr(Ps)),
			PassLayers= lib_dungeon_rune:get_dungeon_level(Ps),
			%% ?INFO("PassLayer:~p", [PassLayers]),
			lib_server_send:send_to_sid(Sid, pt_134, Cmd, [MedalId, StrenLv, StrenExp, Honour, Power, PassLayers]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?ERR("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_134, 13400, [Res]),
			{ok, NewPs}
	end;



%% -----------------------------------------------------------------
%% @desc     功能描述  勋章晋升
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13402, #player_status{sid = Sid} = Ps, _Data) ->
	case lib_medal:upgrade(Ps) of
		{ok, MedalId, Honour, NewPs} ->  %%当前勋章Id，当前声望值
			% ?INFO("MedalId ~p, Honour ~p~n", [MedalId, Honour]),
			lib_server_send:send_to_sid(Sid, pt_134, Cmd, [MedalId, Honour]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?ERR("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_134, 13400, [Res]),
			{ok, NewPs}
	end;

do_handle(_Cmd = 13403, Ps, [TitleId]) ->
	lib_title:title_operation(Ps, TitleId);

do_handle(_Cmd = 13404, Ps, [TitleId]) ->
	lib_title:title_equip(Ps, TitleId);

do_handle(_Cmd = 13405, Ps, []) ->
	lib_title:title_info(Ps);

do_handle(_Cmd = 13406, Ps, []) ->
	lib_title:title_unequip(Ps);


do_handle(_Cmd = 13407, Ps, [GoodsList]) ->
	lib_medal:lv_stren(Ps, GoodsList);


%%容错
do_handle(_Cmd, Ps, _Data) ->
	{ok, Ps}.