%% ---------------------------------------------------------------------------
%% @doc 玩家事件管理器
%% @author hek
%% @since  2016-09-09
%% @deprecated 本模块管理玩家进程事件监听，移除，派发具体事件
%%
%% Note:
%% 每次都会触发的回调事件，不能进行移除操作
%% 添加暂时触发的事件，触发后可以移除
%% ---------------------------------------------------------------------------

-module(lib_player_event).
-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-define(EVENT_LISNENER, {?MODULE, event_listener}).

-export([
	add_listener/3			%% 添加事件监听，不指定监听参数
	,add_listener/4			%% 添加事件监听，指定监听参数
	,remove_listener/1		%% 移除某一类型事件监听
	,remove_listener/3		%% 移除某一类型中的指定“回调模块，回调函数”的事件监听
	,dispatch/2 			%% 派发某个类型的事件，不带事件数据
	,dispatch/3 			%% 派发某个类型的事件，带事件数据
	]).

-export([
	async_add_listener/4	%% 异步添加事件监听，不指定监听参数
	,async_add_listener/5	%% 异步添加事件监听，指定监听参数
	,async_remove_listener/2%% 异步移除某一类型事件监听
	,async_remove_listener/4%% 异步移除某一类型中的指定“回调模块，回调函数”的事件监听
	,async_dispatch/2 		%% 异步派发某个类型的事件，不带事件数据
	,async_dispatch/3 		%% 异步派发某个类型的事件，带事件数据
	,async_dispatch/4 		%% 异步派发某个类型的事件，带是否处理处理离线情况参数，带事件数据
	]).

%% 添加事件监听，不指定监听参数
add_listener(EventTypeId, M, F) ->
	add_listener(EventTypeId, M, F, []).

%%--------------------------------------------------------------------
%% Descrip : 添加事件监听
%% Function: add_listener(EventTypeId, M, F, A)
%% 			EventTypeId = integer(), 事件类型Id
%% 			M = atom(), 事件回调模块
%% 			F = atom(), 事件回调函数
%% 						!!!回调函数第一个参数为#player_status
%%						!!!回调函数第二个参数使用#event_callback{}封装
%% 						!!!回调函数返回值为{ok,#player_status}
%% 			A = atom(), 事件监听带入参数
%% 						此参数函数回调时赋值给#event_callback.param
%% Returns: ok
%%--------------------------------------------------------------------
add_listener(EventTypeId, M, F, A) ->
	do_add_listener(EventTypeId, {M, F}, {M, F, A}).

async_add_listener(PlayerId, EventTypeId, M, F) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_player_event, add_listener, [EventTypeId, M, F]).

async_add_listener(PlayerId, EventTypeId, M, F, A) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_player_event, add_listener, [EventTypeId, M, F, A]).

%% 移除某一类型事件监听
remove_listener(EventTypeId) ->
	do_remove_listener(EventTypeId, {}).

%%--------------------------------------------------------------------
%% Descrip : 移除事件监听
%% Function: remove_listener(EventTypeId, M, F)
%% 			EventTypeId = integer(), 事件类型Id
%% 			M = atom(), 事件回调模块
%% 			F = atom(), 事件回调函数
%% Returns: ok
%%--------------------------------------------------------------------
remove_listener(EventTypeId, M, F) ->
	do_remove_listener(EventTypeId, {M, F}).

async_remove_listener(PlayerId, EventTypeId) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_player_event, remove_listener, [EventTypeId]).

async_remove_listener(PlayerId, EventTypeId, M, F) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST, lib_player_event, remove_listener, [EventTypeId, M, F]).

%%--------------------------------------------------------------------
%% Descrip : 派发某个类型的事件，不带事件数据
%% Returns: {ok, #player_status{}}
%%--------------------------------------------------------------------
dispatch(PS, EventTypeId) ->
	dispatch(PS, EventTypeId, []).

%%--------------------------------------------------------------------
%% Descrip : 派发某个类型的事件
%% Function: dispatch(PS, EventTypeId, Data)
%% 			PS 				= #player_status{},   	玩家状态
%% 			EventTypeId 	= integer(), 			事件类型Id
%% 			Data 			= #event_callback.data, 事件数据
%% Returns: {ok, #player_status{}}
%%--------------------------------------------------------------------
dispatch(PS, EventTypeId, Data) when is_record(PS, player_status)->
	do_dispatch(PS, EventTypeId, Data);
dispatch(PlayerId, EventTypeId, Data) when is_integer(PlayerId)->
	do_dispatch(PlayerId, EventTypeId, Data).

async_dispatch(PlayerId, EventTypeId) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_player_event, dispatch, [EventTypeId]).

async_dispatch(PlayerId, EventTypeId, Data) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_player_event, dispatch, [EventTypeId, Data]).

%%--------------------------------------------------------------------
%% Descrip : 异步派发某个类型的事件
%% Function: dispatch(PlayerId, EventTypeId, Data)
%% 			PlayerId 		= integer(),   			玩家状态
%%  		HandleOffline   = ?NOT_HAND_OFFLINE | ?HAND_OFFLINE
%% 			EventTypeId 	= integer(), 			事件类型Id
%% 			Data 			= #event_callback.data, 事件数据
%% Returns: ok | skip.
%%
%% HandleOffline为?HAND_OFFLINE且玩家离线时，只有data_static_event
%% MFA中的A设置了{handle_offline, 1}时，才会处理回调模块
%%--------------------------------------------------------------------
async_dispatch(PlayerId, HandleOffline, EventTypeId, Data) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, HandleOffline, lib_player_event, dispatch, [EventTypeId, Data]).

%% -------------------------------------------------------------------
%%  local function
%% -------------------------------------------------------------------

do_add_listener(EventTypeId, Id, MFA) ->
	{Events, Dict} = get_dynamic_event(EventTypeId),
	NewEvents = lists:keystore(Id, 1, Events, {Id, MFA}),
	set_dynamic_event(EventTypeId, NewEvents, Dict).

do_remove_listener(EventTypeId, Id) ->
	{Events, Dict} = get_dynamic_event(EventTypeId),
	NewEvents = case Id of
		{} -> [];
		_ -> lists:keydelete(Id, 1, Events)
	end,
	set_dynamic_event(EventTypeId, NewEvents, Dict).

do_dispatch(PS, EventTypeId, Data) when is_record(PS, player_status) ->
	{DynamicEvents, _Dict} = get_dynamic_event(EventTypeId),
	StaticEvents = data_static_event:get_static_event(EventTypeId),
	NewPS = do_dispatch_fun(PS, DynamicEvents, EventTypeId, Data),
	LastPS = do_dispatch_fun(NewPS, StaticEvents, EventTypeId, Data),
	{ok, LastPS};
do_dispatch(PlayerId, EventTypeId, Data) when is_integer(PlayerId) ->
	StaticEvents = data_static_event:get_static_event(EventTypeId),
	do_dispatch_fun(PlayerId, StaticEvents, EventTypeId, Data),
	ok.

do_dispatch_fun(PS, [], _EventTypeId, _Data) when is_record(PS, player_status) -> PS;
do_dispatch_fun(PS, [N|T], EventTypeId, Data) when is_record(PS, player_status) ->
	do_dispatch_fun_core(PS, [N|T], EventTypeId, Data);

do_dispatch_fun(PlayerId, [], _EventTypeId, _Data)  when is_integer(PlayerId) -> ok;
do_dispatch_fun(PlayerId, [N|T], EventTypeId, Data) when is_integer(PlayerId) ->
	case N of
		{_Id, {_M, _F, A}} -> skip;
		{_M, _F, A} -> skip
	end,
	V = lists:keyfind(handle_offline, 1, A),
	HandleCallBack = ?IF({handle_offline, 1}==V, true, false),
	case HandleCallBack of
		true -> do_dispatch_fun_core(PlayerId, [N|T], EventTypeId, Data);
		false -> do_dispatch_fun(PlayerId, T, EventTypeId, Data)
	end.

do_dispatch_fun_core(PS, [N|T], EventTypeId, Data) when is_record(PS, player_status) ->
	case N of
		{_Id, {M, F, A}} -> skip;
		{M, F, A} -> skip
	end,
	Ec = #event_callback{
		id = {M, F}
		,type_id = EventTypeId
		,param = A
		,data = Data
	},
	case catch M:F(PS, Ec) of
		{ok, NewPS} when is_record(NewPS, player_status) ->
			do_dispatch_fun(NewPS, T, EventTypeId, Data);
		Err ->
			?ERR("dispatch EventTypeId:~p Data:~p CallBack:{~p, ~p, ~p} Error:~p", [EventTypeId, Data, M, F, A, Err]),
			do_dispatch_fun(PS, T, EventTypeId, Data)
	end;
do_dispatch_fun_core(PlayerId, [N|T], EventTypeId, Data) when is_integer(PlayerId) ->
	case N of
		{_Id, {M, F, A}} -> skip;
		{M, F, A} -> skip
	end,
	Ec = #event_callback{
		id = {M, F}
		,type_id = EventTypeId
		,param = A
		,data = Data
	},
	case catch M:F(PlayerId, Ec) of
		{'EXIT', Reason} ->
			?ERR("dispatch EventTypeId:~p Data:~p CallBack:{~p, ~p, ~p} Error:~p", [EventTypeId, Data, M, F, A, Reason]),
			do_dispatch_fun(PlayerId, T, EventTypeId, Data);
		_ ->
			do_dispatch_fun(PlayerId, T, EventTypeId, Data)
	end.

get_dynamic_event() ->
	case erlang:get(?EVENT_LISNENER) of
		undefined -> dict:new();
		Dict -> Dict
	end.

get_dynamic_event(EventTypeId) ->
	Dict = get_dynamic_event(),
	case dict:find(EventTypeId, Dict) of
		error -> {[], Dict};
		{ok, Events} -> {Events, Dict}
	end.

set_dynamic_event(EventTypeId, Events, Dict) ->
	NewDict = dict:store(EventTypeId, Events, Dict),
	erlang:put(?EVENT_LISNENER, NewDict),
	ok.

