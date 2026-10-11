%%%-----------------------------------
%%% @Module      : pp_advertisement
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 四月 2021 10:43
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_advertisement).
-author("carlos").
-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("advertisement.hrl").
-include("errcode.hrl").
-include("def_module.hrl").

%% API
-export([]).



%% 穿戴
handle(CMD,  PS, Args) ->
	%% 可以过滤一些东西
	case do_handle(CMD,  PS, Args) of
		NewPs when is_record(NewPs, player_status) ->
			ok;
		{ok, NewPs} when is_record(NewPs, player_status) ->
			{ok, NewPs};
		_ ->
			{ok, PS}
	end.


do_handle(19302,  PS, []) ->
	#player_status{advertisement = Status, id = RoleId} = PS,
	#advertisement_status{lists = List}  = Status,
	PackList = [{ModId, SubId, Count} ||#advertisement{mod_id = ModId, sub_id = SubId, count = Count} <- List],
	{ok, Bin} = pt_193:write(19302, [PackList]),
	lib_server_send:send_to_uid(RoleId, Bin),
	{ok, PS};

do_handle(19303,  PS, [?MOD_AC_CUSTOM, SubId, GradeId]) ->
	#player_status{advertisement = Ad, id = RoleId,  status_custom_act = StatusCustom} = PS,
%%	#advertisement{mod_id = ModId, sub_id = SubId} = Ad,
	{ok, DefBin} = pt_193:write(19303, [0, 0, 0, ?MISSING_CONFIG]),
	case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId, GradeId) of
		#custom_act_reward_cfg{} ->
%%			?PRINT("Ad  +++++++++++++++++++++++++ ~n", []),
			#status_custom_act{data_map = Map} = StatusCustom,
			#custom_act_data{data = DataList} = maps:get({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId}, Map, #custom_act_data{}),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubId) of
				#custom_act_cfg{condition = Condition} ->
					?PRINT("Ad  +++++++++++++++++++++++++ ~n", []),
					case lists:keyfind(cd, 1, Condition) of
						{_, CdTime} ->
							Now = utime:unixtime(),
							case lists:keyfind(GradeId, 1, DataList) of
								{_, _, SeeTime} when Now > SeeTime + CdTime ->
									NewAd = Ad#advertisement_status{mod_id = ?MOD_AC_CUSTOM, sub_id = SubId, grade = GradeId},
									{ok, Bin} = pt_193:write(19303, [?MOD_AC_CUSTOM, SubId, GradeId, ?SUCCESS]),
									lib_server_send:send_to_uid(RoleId, Bin),
									{ok, PS#player_status{advertisement = NewAd}};
								{_, _, SeeTime} ->
									lib_server_send:send_to_uid(RoleId, DefBin),
									{ok, PS};
								_ ->
									NewAd = Ad#advertisement_status{mod_id = ?MOD_AC_CUSTOM, sub_id = SubId, grade = GradeId},
									{ok, Bin} = pt_193:write(19303, [?MOD_AC_CUSTOM, SubId, GradeId, ?SUCCESS]),
									lib_server_send:send_to_uid(RoleId, Bin),
									{ok, PS#player_status{advertisement = NewAd}}
							end;
						_ ->
							lib_server_send:send_to_uid(RoleId, DefBin),
							{ok, PS}
					end;
				_ ->
%%					?PRINT("Ad  +++++++++++++++++++++++++ ~n", []),
					lib_server_send:send_to_uid(RoleId, DefBin),
					{ok, PS}
			end;
		_ ->
%%			?PRINT("Ad  +++++++++++++++++++++++++ ~n", []),
			lib_server_send:send_to_uid(RoleId, DefBin),
			{ok, PS}
	end;
	

do_handle(19303,  PS, [ModId, SubId, GradeId]) ->
	#player_status{advertisement = Ad} = PS,
%%	#advertisement{mod_id = ModId, sub_id = SubId} = Ad,
	%%要检查有么有这个档位
	?PRINT("Ad ~p~n", [Ad]),
	NewAd = Ad#advertisement_status{mod_id = ModId, sub_id = SubId, grade = GradeId},
	?PRINT("NewAd ~p~n", [NewAd]),
	{ok, PS#player_status{advertisement = NewAd}};

do_handle(_CMD,  PS, _Args) ->
	{ok, PS}.
