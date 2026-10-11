%%-----------------------------------------------------------------------------
%% @Module  :       pp_boss_first_blood_plus
%% @Author  :       cxd
%% @Created :       2020-04-25
%% @Description:    新版boss首杀
%%-----------------------------------------------------------------------------
-module(pp_boss_first_blood_plus).
-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("boss_first_blood_plus.hrl").

%% 界面数据
handle(18801, Ps, [Type, SubType]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			mod_boss_first_blood_plus:act_info(Type, SubType, RoleId, RoleMap);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

%% 获取副本首杀奖励
handle(18802, Ps, [Type, SubType, DunId]) when Type == ?CUSTOM_ACT_TYPE_DUN_FIRST_KILL ->
	#player_status{id = RoleId} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			mod_boss_first_blood_plus:receive_reward(Type, SubType, RoleId, DunId);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

%% 获取boss首杀奖励
handle(18802, Ps, [Type, SubType, BossId]) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 1 ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			mod_boss_first_blood_plus:receive_reward(Type, SubType, RoleId, BossId);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

% %% 获取boss首杀奖励（新活动）
% handle(18802, Ps, [Type, SubType, BossId]) when Type == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS andalso SubType == 2 ->
% 	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
% 	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
% 		true ->
% 			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
% 			lib_boss_first_blood_plus:new_act_receive_reward(Type, SubType, RoleInfoList, BossId, RoleId);
% 		{false, ErrCode} ->
% 			send_error(RoleId, ErrCode)
% 	end;

%% 获取boss首杀奖励（新活动）
handle(18802, Ps, [Type, SubType, DunId]) when Type == ?CUSTOM_ACT_TYPE_PASS_DUN  ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
			lib_boss_first_blood_plus:new_act_receive_reward(Type, SubType, RoleInfoList, DunId, RoleId);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

%% 首杀奖励领取提醒
handle(18803, Ps, [Type, SubType]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
			lib_boss_first_blood_plus:login_notice(Type, SubType, RoleId, RoleInfoList);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

%% 副本首通界面
handle(18804, Ps, [Type, SubType, DunId]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			mod_boss_first_blood_plus:act_info(Type, SubType, RoleId, RoleMap, DunId);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;

%% 副本首通界面红点
handle(18805, Ps, [Type, SubType]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
			mod_boss_first_blood_plus:red_point(Type, SubType, RoleId, RoleInfoList);
		{false, ErrCode} ->
			send_error(RoleId, ErrCode)
	end;


%%% 18806和18807是在boss首杀比副本类多出一个全服归属奖励的条件下建立的，
%%% 副本若增加类似字段，可考虑将18806和18807合并到18801和18802

%% 查询BOSS首杀全服归属奖励领取状态
handle(18806, Ps, [Type, SubType, BossId]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
			lib_boss_first_blood_plus:shared_info(Type, SubType, RoleInfoList, BossId, RoleId);
		{false, _} ->
			{ok, BinData} = pt_188:write(18806, [Type, SubType, BossId, ?CAN_NOT_RECEIVE]),
    		lib_server_send:send_to_uid(RoleId, BinData)
	end;

%% 领取BOSS首杀全服归属奖励
handle(18807, Ps, [Type, SubType, BossId]) ->
	#player_status{id = RoleId, role_boss_first_blood = RoleMap} = Ps,
	case lib_boss_first_blood_plus:base_check(Type, SubType, Ps) of
		true ->
			RoleInfoList = maps:get({Type, SubType}, RoleMap, []),
			lib_boss_first_blood_plus:new_act_receive_shared(Ps, Type, SubType, RoleInfoList, BossId);
		{false, Errcode} ->
			send_error(RoleId, Errcode)
	end;


handle(_Cmd, _Ps, _O) ->
	?PRINT("Cmd: ~p~n, O: ~p~n", [_Cmd, _O]),
	?ERR("no cmd: ~p", [_Cmd]).

%% 发送错误码
send_error(RoleId, Error) ->
	case Error == ?ERRCODE(lv_limit) orelse Error == ?ERRCODE(err204_goal_not_finish) of 
		true -> %% 等级不足或者任务没完成不发错误码
			skip;
		_ ->
			{ok, Bin} = pt_188:write(18800, [Error]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end.