%%%-----------------------------------
%%% @Module      : pp_enchantment_guard
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 八月 2018 17:23
%%% @Description : 结界守护
%%%-----------------------------------
-module(pp_enchantment_guard).
-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("faker.hrl").
-author("chenyiming").

%% API
-export([
	handle/3

]).


%% -----------------------------------------------------------------
%% @desc     功能描述  命名133路由前处理事项
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle(Cmd, Ps, Data) ->
	do_handle(Cmd, Ps, Data).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取进入结界守护信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13300, #player_status{sid = Sid} = Ps, _Data) ->
	case lib_enchantment_guard:get_enter_data(Ps) of
		{true, CurrentWave, NeedWave, SendAssistId, AssisterInfo, NewPs} ->  %%当前波数，所需波数
%%			?DEBUG("CurrentWave ~p, NeedWave ~p~n", [CurrentWave, NeedWave]),
			case AssisterInfo of
				#faker_info{role_id = AssisterId} -> ok;
				_ -> AssisterId = 0
			end,
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [?SUCCESS, CurrentWave, NeedWave, SendAssistId, AssisterId]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?ERR("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, 0, 0, 0, 0]),
			{ok, NewPs}
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述  获取进入结界守护排行版信息
%% @param    参数     Type:: 3|20   获取排行榜玩家数量。
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(13301, PS, []) ->
	lib_enchantment_guard:send_rank_list(PS);


%% -----------------------------------------------------------------
%% @desc     功能描述  获取封印之力信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13302, #player_status{sid = Sid} = Ps, _DATA) ->
	case lib_enchantment_guard:get_seal_data(Ps) of
		{true, MaxTimes, CurrentTimes, Cost, RewardList, NewPs} ->  %%最大领取次数，当前领取次数，精魄消耗，奖励列表
%%			?DEBUG("~p,~p,~p,~p~n", [MaxTimes, CurrentTimes, Cost, RewardList]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [?SUCCESS, MaxTimes, CurrentTimes, Cost, RewardList]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?DEBUG("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, 0, 0, 0, []]),
			{ok, NewPs}
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述  获取扫荡结界信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13303, #player_status{sid = Sid} = Ps, _DATA) ->
	case lib_enchantment_guard:get_sweep_data(Ps) of
		%%最大扫荡次数，当前扫荡次数，钻石消耗，所得金币，所得经验，所得装备数量，物品奖励列表，下一个vip等级，下一个vip等级可扫荡次数
		{true, _MaxTimes, CurrentTimes, _Cost, _Coin, _Exp, EquipNum, _RewardNum, NewPs} ->
%%			?DEBUG("MaxTimes ~p,CurrentTimes ~p,Cost ~p,Coin ~p,Exp ~p,EquipNum ~p,RewardNum ~p,NextVip ~p,NextVipTimes ~p~n",
%%				[MaxTimes, CurrentTimes, Cost, Coin, Exp, EquipNum, RewardNum, NextVip, NextVipTimes]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd,
				[?SUCCESS, CurrentTimes, EquipNum]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?DEBUG("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, 0, 0]),
			{ok, NewPs}
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述  扫荡    扫荡后要重置Ps扫荡信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13304, #player_status{sid = Sid} = Ps, _DATA) ->
	case lib_enchantment_guard:do_sweep(Ps) of
		%%   所得金币，所得经验，装备数量，固定奖励列表
		{true, Coin, Exp, EquipNum, RewardList, NewPs} ->
%%			?DEBUG("Coin, Exp, EquipNum, RewardList ~p,~p,~p,~p~n", [Coin, Exp, EquipNum, RewardList]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd,
				[?SUCCESS, Coin, Exp, EquipNum, RewardList]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?DEBUG("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, 0, 0, 0, []]),
			{ok, NewPs}
	end;


%% -----------------------------------------------------------------
%% @desc     功能描述   进入副本
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13305, #player_status{sid = Sid} = Ps, [Type]) ->
	case lib_enchantment_guard:enter_or_leave(Ps, Type) of
		{true, NewPs} ->
			{ok, NewPs};
		{false, Res, NewPs} ->
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res]),
			{ok, NewPs};
		_ -> skip
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述    自动开启挑战。
%% @param    参数        type:integer     //0:开启     1：关闭
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13307, #player_status{sid = Sid} = Ps, [Type]) ->
	case lib_enchantment_guard:auto_battle(Ps, Type) of
		{true, NewPs} ->
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [?SUCCESS, Type]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?PRINT("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, 1]),
			{ok, NewPs}
	end;


%% -----------------------------------------------------------------
%% @desc     功能描述    封印
%% @param    参数        Times:integer     第n次封印
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(Cmd = 13308, #player_status{sid = Sid} = Ps, []) ->
	case lib_enchantment_guard:seal(Ps, 0) of
		{true, NewPs, ResList} ->
%%			?DEBUG("~p~n", [ResList]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [?SUCCESS, ResList]),
			{ok, NewPs};
		{false, Res, NewPs} ->
%%			?DEBUG("~p~n", [Res]),
			lib_server_send:send_to_sid(Sid, pt_133, Cmd, [Res, []]),
			{ok, NewPs}
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述    下一个的阶段奖励关卡
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle(13309, Ps, []) ->
	lib_enchantment_guard:get_next_stage_reward_gate(Ps),
	ok;

%%领取阶段奖励
do_handle(13310, Ps, [Gate]) ->
	NewPs = lib_enchantment_guard:get_stage_reward(Ps, Gate),
	{ok, NewPs};
%%下一关的收益
%%do_handle(13311, Ps, []) ->
%%	lib_enchantment_guard:send_next_gate_earnings(Ps),
%%	ok;

%% 发送古宝信息
do_handle(13320, PS, _) ->
	lib_enchantment_guard:send_soap_info(PS);

%% 激活古宝碎片
do_handle(13321, PS, [SoapId, DebrisId]) ->
	lib_enchantment_guard:active_soap_debris(PS, SoapId, DebrisId);

do_handle(13322, PS, [NodeId]) ->
	lib_enchantment_guard:set_new_process_node(PS, NodeId);

do_handle(13323, PS, []) ->
	lib_enchantment_guard:get_new_process_node(PS);

% 请求协助次数信息
do_handle(13324, PS, []) ->
	lib_enchantment_guard:get_assist_times_info(PS);

%% 发起协助

%%容错
do_handle(_Cmd, Ps, _Data) ->
	{ok, Ps}.