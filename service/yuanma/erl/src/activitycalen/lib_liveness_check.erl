%%%-----------------------------------
%%% @Module      : lib_liveness_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 九月 2018 9:58
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_liveness_check).
-include("server.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("activitycalen.hrl").
-include("common.hrl").
-include("figure.hrl").
-author("chenyiming").

%% API
-compile(export_all).


%%获取活跃度找回信息检查
report_res_act(#player_status{figure = F} = _Ps) ->
	#figure{lv = Lv} = F,
	CheckList = [
		{check_open_lv, Lv}  %%活跃度找回开启等级
	],
	check_list(CheckList).

%%找回活跃度检查
liveness_back(#player_status{figure =  F} = Ps, ActId, SubId, Times) ->
	#figure{lv = Lv} = F,
	#ac_liveness{live = Live} = data_activitycalen:get_live_config(ActId, SubId),
	Cost = [{?TYPE_BGOLD,  0,  Live * Times}],
	CheckList = [
		{check_open_lv, Lv}   %% 活跃度找回开启等级
		,{check_times,  Ps, ActId, SubId, Times}   %% 次数检查
		,{check_cost, Ps,  Cost}   %% 次数检查
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

check({check_open_lv, Lv}) ->
	OpenLv = lib_module:get_open_lv(?MOD_ACTIVITY, 1),
	if
		Lv >= OpenLv ->
			true;
		true ->
			{false, ?ERRCODE(err157_open_lv)}
	end;

check({check_times,  Ps, ActId, SubId, Times}) ->
	#player_status{liveness_back = #liveness_back{res_act_map =  ResActMap}} = Ps,
		check_res_act_times(ResActMap, ActId, SubId, Times);

check({check_cost, Ps, Cost} ) ->
	case   lib_goods_api:check_object_list(Ps, Cost) of
		true ->
			true;
		{false, ErrCode} ->
			{false, ErrCode}
	end;

check(_) ->
	true.


check_res_act_times(ResActMap, Id, ActSub, Times) ->
	Yesterday = maps:get(?YESTERDAY_LIVE, ResActMap, #{}),
	BYesterday = maps:get(?B_YESTERDAY_LIVE, ResActMap, #{}),
	YResAct = maps:get({Id, ActSub}, Yesterday, none),
	BYResAct = maps:get({Id, ActSub}, BYesterday, none),
	if
		is_record(BYResAct, res_act_live), is_record(YResAct, res_act_live) ->  %%前两天都有剩余次数
			LeftTimes1 = YResAct#res_act_live.lefttimes,  %% 昨天剩余次数
			LeftTimes2 = BYResAct#res_act_live.lefttimes, %% 前天剩余次数
			case check_times_valid(LeftTimes1 + LeftTimes2, Times) of
				true ->
					true;
				Res ->
					Res
			end;
		is_record(BYResAct, res_act_live) ->
			LeftTimes1 = BYResAct#res_act_live.lefttimes,
			case check_times_valid(LeftTimes1, Times) of
				true ->
					true;
				Res ->
					Res
			end;
		is_record(YResAct, res_act_live) ->
			LeftTimes1 = YResAct#res_act_live.lefttimes,
			case check_times_valid(LeftTimes1, Times) of
				true ->
					true;
				Res -> Res
			end;
		true -> {false, ?ERRCODE(err157_no_res_act)}
	end.

check_times_valid(LeftTimes, Times) ->
	case LeftTimes of
		0 -> {false, ?ERRCODE(err157_no_res_act)};
		Num when Times > Num -> {false, ?ERRCODE(err157_no_more_times)};
		_ -> true
	end.

	
	
	