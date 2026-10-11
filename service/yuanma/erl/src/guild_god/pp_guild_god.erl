%%%-----------------------------------
%%% @Module      : pp_guild_god
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十二月 2019 16:34
%%% @Description : 
%%%-----------------------------------
-module(pp_guild_god).

-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("guild_god.hrl").
-include("figure.hrl").
%% API
-compile(export_all).

handle(CMD, PS, Data) ->
	#player_status{figure = F} = PS,
	OpenDay = util:get_open_day(),
	NeedOpenDay = data_guild_god:get_kv(open_day),
	NeedLv = data_guild_god:get_kv(lv_limit),
	if
		OpenDay < NeedOpenDay ->
			send_error(PS#player_status.id, ?ERRCODE(err405_open_day_limit));
		F#figure.lv < NeedLv ->
			send_error(PS#player_status.id, ?ERRCODE(err405_lv_limit));
		true ->
			case do_handle(CMD, PS, Data) of
				#player_status{} = NewPS ->
					{ok, NewPS};
				{ok, NewPS} when is_record(NewPS, player_status) ->
					{ok, NewPS};
				_ ->
					{ok, PS}
			end
	end.

%% 神像信息
do_handle(40501, PS, _) ->
	lib_guild_god:get_info(PS),
	{ok, PS};

%% 铭文信息
do_handle(40502, PS, [GodId]) ->
	lib_guild_god:get_god_rune_info(GodId, PS),
	{ok, PS};

%% 神像升品
do_handle(40503, PS, [GodId]) ->
	NewPs = lib_guild_god:update_color(GodId, PS),
	{ok, NewPs};

%% 神像觉醒
do_handle(40504, PS, [GodId]) ->
	NewPs = lib_guild_god:update_awake_lv(GodId, PS),
	{ok, NewPs};

%% 穿戴
do_handle(40505, PS, [GodId, Pos, GoodsAutoId]) ->
	Ids = data_guild_god:get_all_god_ids(),
	?PRINT("GodId, Pos, GoodsAutoId ~p~n", [{GodId, Pos, GoodsAutoId}]),
	case lists:member(GodId, Ids) of
		true ->
			case lists:member(Pos, ?pos_list) of
				true ->
					NewPs = lib_guild_god:wear(PS, GodId, Pos, GoodsAutoId),
					{ok, NewPs};
				_ ->
					send_error(PS#player_status.id, ?ERRCODE(err405_error_pos))
			end;
		_ ->
			send_error(PS#player_status.id, ?ERRCODE(err405_error_god_id))
	end;

%% 激活组合
do_handle(40506, PS, [GodId, ComboId]) ->
	Ids = data_guild_god:get_all_god_ids(),
	case lists:member(GodId, Ids) of
		true ->
			NewPs = lib_guild_god:awake_combo(PS, GodId, ComboId),
			{ok, NewPs};
		_ ->
			send_error(PS#player_status.id, ?ERRCODE(err405_error_god_id))
	end;

%% 脱铭文
do_handle(40507, PS, [GodId, Pos]) ->
	Ids = data_guild_god:get_all_god_ids(),
	case lists:member(GodId, Ids) of
		true ->
			case lists:member(Pos, ?pos_list) of
				true ->
					NewPs = lib_guild_god:take_off(PS, GodId, Pos),
					{ok, NewPs};
				_ ->
					send_error(PS#player_status.id, ?ERRCODE(err405_error_pos))
			end;
		_ ->
			send_error(PS#player_status.id, ?ERRCODE(err405_error_god_id))
	end;

%% 升级铭文
do_handle(40508, PS, [GodId, Pos]) ->
	Ids = data_guild_god:get_all_god_ids(),
	case lists:member(GodId, Ids) of
		true ->
			case lists:member(Pos, ?pos_list) of
				true ->
					NewPs = lib_guild_god:rune_upgrade(PS, GodId, Pos),
					{ok, NewPs};
				_ ->
					send_error(PS#player_status.id, ?ERRCODE(err405_error_pos))
			end;
		_ ->
			send_error(PS#player_status.id, ?ERRCODE(err405_error_god_id))
	end;

%% 激活铭文大师等级
do_handle(40509, PS, [GodId, Lv]) ->
	Ids = data_guild_god:get_all_god_ids(),
	case lists:member(GodId, Ids) of
		true ->
			NewPS = lib_guild_god:awake_achievement(GodId, Lv, PS),
			NewPS;
		_ ->
			send_error(PS#player_status.id, ?ERRCODE(err405_error_god_id))
	end;

do_handle(_, PS, []) ->
	{ok, PS}.

send_error(RoleId, Error) ->
	{ok, Bin} = pt_405:write(40500, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).