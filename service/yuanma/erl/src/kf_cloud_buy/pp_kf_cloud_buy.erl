%% ---------------------------------------------------------------------------
%% @doc pp_kf_cloud_buy.erl

%% @author  
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(pp_kf_cloud_buy).
-export([handle/3]).

-include("server.hrl").
-include("kf_cloud_buy.hrl").
-include("errcode.hrl").
-include("common.hrl").

%% 系统开关设置列表
handle(51201, PS, []) ->
	SendList = lib_kf_cloud_buy:pack_open_act_list(),
    lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51201, [SendList]);

handle(51202, PS, [Type, SubType]) ->
	case lib_kf_cloud_buy:check_act_open(Type, SubType) of 
		true ->
			lib_kf_cloud_buy:send_cld_act_info(PS, Type, SubType);
		_ ->
			Args = [?ERRCODE(err512_act_close), Type, SubType, 0, 0, 0, 0, []],
			lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51202, Args)
	end;

handle(51203, PS, [Type, SubType, StartPos, EndPos]) when StartPos > 0 andalso EndPos >= StartPos ->
	case lib_kf_cloud_buy:check_act_open(Type, SubType) of 
		true ->
			lib_kf_cloud_buy:send_cld_act_tv_records(PS, Type, SubType, StartPos, EndPos);
		_ ->
			Args = [Type, SubType, StartPos, EndPos, []],
			lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51203, Args)
	end;

handle(51204, PS, [Type, SubType]) ->
	case lib_kf_cloud_buy:check_act_open(Type, SubType) of 
		true ->
			lib_kf_cloud_buy:send_cld_act_big_records(PS, Type, SubType);
		_ ->
			Args = [Type, SubType, []],
			lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51204, Args)
	end;

handle(51205, PS, [Type, SubType, Times]) when Times == 1 orelse Times == 10 ->
	case lib_kf_cloud_buy:check_act_open(Type, SubType) of 
		true ->
			case lib_kf_cloud_buy:draw_rewards(PS, Type, SubType, Times) of
				{ok, NewPS, NewGradeCount, NewSelfCount, NewSelfTotalCount, RewardList} ->
					Args = [?SUCCESS, Type, SubType, NewGradeCount, NewSelfCount, NewSelfTotalCount, RewardList],
					lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51205, Args),
					{ok, NewPS};
				{false, Res} ->
					?PRINT("draw_rewards Res : ~p~n", [Res]),
					Args = [Res, Type, SubType, 0, 0, 0, []],
					lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51205, Args)
			end; 
		_ ->
			Args = [?ERRCODE(err512_act_close), Type, SubType, 0, 0, 0, []],
			lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51205, Args)
	end;

handle(51206, PS, [Type, SubType, StageCount]) ->
	case lib_kf_cloud_buy:check_act_open(Type, SubType) of 
		true ->
			lib_kf_cloud_buy:get_stage_reward(PS, Type, SubType, StageCount),
			ok;
		_ ->
			Args = [?ERRCODE(err512_act_close), Type, SubType, StageCount, []],
			lib_server_send:send_to_sid(PS#player_status.sid, pt_512, 51206, Args)
	end;


handle(_Cmd, _PS, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.