%%%--------------------------------------
%%% @Module  : 
%%% @Author  : 
%%% @Created : 
%%% @Description:  
%%%--------------------------------------
-module(lib_mask_role).
-compile(export_all).
-include("server.hrl").
-include("mask_role.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_event.hrl").

login(PS) ->
	#player_status{id = RoleId, figure = Figure} = PS,
	case db_select_mask_list(RoleId) of 
		[MaskId, EndTime] ->
			NowTime = utime:unixtime(),
			case NowTime < EndTime of 
				true ->
					Ref = util:send_after([], (EndTime - NowTime)*1000, self(), {'mod', ?MODULE, mask_end, []}),
					NewMaskId = MaskId, NewEndTime = EndTime;
				_ ->
					Ref = [], NewMaskId = 0, NewEndTime = 0
			end,
			%% 是否是登陆过期
			case NewMaskId == 0 andalso MaskId > 0 of 
				true ->
					lib_player_event:async_dispatch(RoleId, ?EVENT_EQUIP_MASK);
				_ -> ok
			end,
			PS#player_status{
				figure = Figure#figure{mask_id = NewMaskId},
				mask_status = #mask_status{mask_id = NewMaskId, end_time = NewEndTime, ref = Ref}
			};
		_ -> PS#player_status{mask_status = #mask_status{}}
	end.

get_mask_on_db(RoleId) ->
	case db_select_mask_list(RoleId) of 
		[MaskId, EndTime] ->
			NowTime = utime:unixtime(),
			case NowTime < EndTime of 
				true ->
					MaskId;
				_ ->
					0
			end;
		_ -> 
			0
	end.

send_mask_info(PS) ->
	#player_status{sid = Sid, mask_status = MaskStatus} = PS,
	#mask_status{mask_id = MaskId, end_time = EndTime} = MaskStatus,
	lib_server_send:send_to_sid(Sid, pt_511, 51101, [MaskId, EndTime]).


use(PS, _GS, GoodsInfo, GoodsNum) ->
	NowTime = utime:unixtime(),
	#player_status{id = RoleId, figure = Figure, mask_status = MaskStatus} = PS,
	#mask_status{mask_id = OldMaskId, end_time = EndTime, ref = OldRef} = MaskStatus,
	#goods{goods_id = GoodsTypeId} = GoodsInfo,
	case data_mask_role:get_duration(GoodsTypeId) of 
		{MaskId, Duration} ->
			AddDuration = Duration * GoodsNum,
			case NowTime < EndTime of 
				true ->
					NewEndTime = EndTime + AddDuration;
				_ -> 
					NewEndTime = NowTime + AddDuration
			end,
			Ref = util:send_after(OldRef, (NewEndTime - NowTime)* 1000, self(), {'mod', ?MODULE, mask_end, []}),
			case OldMaskId == 0 of 
				true -> %% 更新场景，广播蒙面信息
					mod_scene_agent:update(PS, [{mask_id, MaskId}]),
					%% 广播
					lib_scene:broadcast_player_attr(PS, [{13, MaskId}]),
					NewMaskId = MaskId;
				_ ->
					NewMaskId = OldMaskId
			end,
			NewMaskStatus = #mask_status{mask_id = NewMaskId, end_time = NewEndTime, ref = Ref},
			NewFigure = Figure#figure{mask_id = NewMaskId},
			db_replace_mask_role(RoleId, NewMaskStatus),
			NewPS = PS#player_status{figure = NewFigure, mask_status = NewMaskStatus},
			send_mask_info(NewPS),
			%% 
			case OldMaskId == NewMaskId of 
				false ->
					lib_role:update_role_show(RoleId, [{mask_id, NewMaskId}]),
					{_, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_EQUIP_MASK);
				_ ->
					LastPS = NewPS
			end,
			?PRINT("use ####### NewMaskStatus: ~p~n", [NewMaskStatus]),
			{ok, LastPS};
		_ ->
			{fail, ?MISSING_CONFIG}
	end.

cancel_mask(PS) ->
	#player_status{id = RoleId, sid = Sid, figure = Figure, mask_status = MaskStatus} = PS,
	#mask_status{ref = OldRef} = MaskStatus,
	util:cancel_timer(OldRef),
	NewMaskStatus = #mask_status{},
	db_replace_mask_role(RoleId, NewMaskStatus),
	NewFigure = Figure#figure{mask_id = 0},
	NewPS = PS#player_status{figure = NewFigure, mask_status = NewMaskStatus},
	%% 更新场景
	mod_scene_agent:update(NewPS, [{mask_id, 0}]),
	%% 广播
	lib_scene:broadcast_player_attr(NewPS, [{13, 0}]),
	lib_role:update_role_show(RoleId, [{mask_id, 0}]),
	%% 
	{_, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_EQUIP_MASK),
	lib_server_send:send_to_sid(Sid, pt_511, 51102, [0, 0]),
	{ok, LastPS}.

mask_end(PS) ->
	NowTime = utime:unixtime(),
	#player_status{id = RoleId, figure = Figure, mask_status = MaskStatus} = PS,
	#mask_status{end_time = EndTime, ref = OldRef} = MaskStatus,
	util:cancel_timer(OldRef),
	case NowTime < EndTime of 
		true ->
			Ref = util:send_after(OldRef, (EndTime - NowTime)* 1000, self(), {'mod', ?MODULE, mask_end, []}),
			NewPS = PS#player_status{mask_status = MaskStatus#mask_status{ref = Ref}},
			{ok, NewPS};
		_ ->
			NewMaskStatus = #mask_status{},
			db_replace_mask_role(RoleId, NewMaskStatus),
			NewFigure = Figure#figure{mask_id = 0},
			NewPS = PS#player_status{figure = NewFigure, mask_status = NewMaskStatus},
			%% 更新场景
			mod_scene_agent:update(NewPS, [{mask_id, 0}]),
			%% 广播
			lib_scene:broadcast_player_attr(NewPS, [{13, 0}]),
			lib_role:update_role_show(RoleId, [{mask_id, 0}]),
			%% 
			{_, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_EQUIP_MASK),
			send_mask_info(LastPS),
			{ok, LastPS}
	end.

%% 获取包装后的玩家名
get_mask_name(PS) when is_record(PS, player_status) ->
	#player_status{figure = Figure, mask_status = MaskStatus} = PS,
	#mask_status{mask_id = MaskId} = MaskStatus,
	case MaskId > 0 of 
		true ->
			get_mask_name(MaskId);
		_ ->
			Figure#figure.name
	end;
get_mask_name(MaskId) ->
	MaskName = data_mask_role:get_mask_name(MaskId),
	util:make_sure_binary(MaskName).

db_replace_mask_role(RoleId, MaskStatus) ->
	#mask_status{mask_id = MaskId, end_time = EndTime} = MaskStatus,
	db:execute(io_lib:format(<<"replace into `mask_role` set role_id=~p, mask_id=~p, end_time=~p">>, [RoleId, MaskId, EndTime])).

db_select_mask_list(RoleId) ->
	db:get_row(io_lib:format(<<"select mask_id, end_time from `mask_role` where role_id = ~p">>, [RoleId])).

%% -----------------------------------------------------------------
%% @desc    功能描述 是否处于蒙面时刻
%% -----------------------------------------------------------------
is_in_mask_time(Ps) ->
	#player_status{ mask_status = StatusMask } = Ps,
	case StatusMask of
		#mask_status{ end_time = EndTime } ->
			NowSec = utime:unixtime(),
			EndTime > NowSec;
		_ ->
			false
	end.