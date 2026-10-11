%%%-----------------------------------
%%% @Module      : pp_midday_party
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 22. 四月 2019 14:07
%%% @Description : 文件摘要
%%%-----------------------------------
-module(pp_midday_party).
-author("chenyiming").

-include("common.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("midday_party.hrl").
-include("figure.hrl").

%% API
-compile(export_all).


handle(CMD, PS, Args) ->
	#player_status{figure = #figure{lv = Lv}, id = RoleId} = PS,
	OpenLv = data_midday_party:get_kv(lv_limit),
	if
		Lv >= OpenLv ->
			case do_handle(CMD, PS, Args) of
				{ok, NewPS1} ->
					{ok, NewPS1};
				_ ->
					?MYLOG("midday", "enter +++++++~n", []),
					{ok, PS}
			end;
		true ->
			send_error(RoleId, ?ERRCODE(lv_limit))
	end.


send_error(RoleId, ErrCode) ->
	?MYLOG("cym", "ErrCode ~p ~n", [ErrCode]),
	{ok, Bin} = pt_285:write(28500, [ErrCode]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%进入晚间派对
do_handle(28501, #player_status{id = RoleId, sid = Sid, figure = F, scene = Scene} = PS, []) ->
	%%t
	case lib_player_check:check_all(PS) of
		true ->
			IsOutSide = lib_scene:is_outside_scene(Scene),
			if
				IsOutSide == true ->
					mod_midday_party:enter(RoleId, F#figure.lv);
				true ->
					lib_server_send:send_to_sid(Sid, pt_285, 28501, [?ERRCODE(cannot_transferable_scene)]),
					send_error(RoleId, ?ERRCODE(cannot_transferable_scene))
			end;
		{false, Code} ->
			lib_server_send:send_to_sid(Sid, pt_285, 28501, [Code]),
			send_error(RoleId, Code)
	end,
	{ok, PS};


%%退出晚间派对
do_handle(28502, #player_status{id = RoleId, scene = Scene} = PS, []) ->
	InMiddayPart = lib_midday_party:is_in_midday_party(Scene),
	if
		InMiddayPart == true ->
			mod_midday_party:quit(RoleId);
		true ->
			skip
	end,
	{ok, PS};

%%经验信息
do_handle(28503, #player_status{id = RoleId, scene = SceneId} = PS, []) ->
	case lib_midday_party:is_in_midday_party(SceneId) of
		true ->
			mod_midday_party:get_exp(RoleId);
		_ ->
			ok
	end,
	{ok, PS};

%%采集信息
do_handle(28504, #player_status{id = RoleId} = PS, []) ->
	lib_midday_party:send_collect_msg_to_client(RoleId),
	{ok, PS};

%%怪物复活倒计时
do_handle(28505, #player_status{id = RoleId, scene = SceneId} = PS, []) ->
	case lib_midday_party:is_in_midday_party(SceneId) of
		true ->
			mod_midday_party:get_mon_reborn_time(RoleId);
		_ ->
			ok
	end,
	{ok, PS};

%%活动结束时间
do_handle(28506, #player_status{id = RoleId} = PS, []) ->
	mod_midday_party:get_end_time(RoleId),
	{ok, PS};



do_handle(_CMD, PS, _Args) ->
	?MYLOG("midday", "no match +++++++~n", []),
	{ok, PS}.