%% ---------------------------------------------------------------------------
%% @doc 玩家事件管理器
%% @author hek
%% @since  2016-09-09
%% @deprecated 派发具体事件
%% ---------------------------------------------------------------------------

-module(lib_event).
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").

-export([
    dispatch/1             %% 派发某个类型的事件，不带事件数据
    , dispatch/2             %% 派发某个类型的事件，带事件数据
    ]).

%% 派发某个类型的事件，不带事件数据
dispatch(EventTypeId) ->
    dispatch(EventTypeId, []).

%%--------------------------------------------------------------------
%% Descrip : 派发某个类型的事件
%% Function: dispatch(PS, EventTypeId, Data)
%%          EventTypeId = integer(),    事件类型Id
%%          Data = #event_callback.data,事件数据 
%% Returns: {ok, #player_status{}}
%%--------------------------------------------------------------------
dispatch(EventTypeId, Data) ->
    do_dispatch(EventTypeId, Data).

%% -------------------------------------------------------------------
%%  local function 
%% -------------------------------------------------------------------

do_dispatch(EventTypeId, Data) ->
    StaticEvents = data_event:get_static_event(EventTypeId),
    do_dispatch_fun(StaticEvents, EventTypeId, Data),
    ok.

do_dispatch_fun([], _EventTypeId, _Data) -> ok;
do_dispatch_fun([N|T], EventTypeId, Data) ->
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
    case catch M:F(Ec) of
        ok -> do_dispatch_fun(T, EventTypeId, Data);
        Err ->
            ?ERR("dispatch EventTypeId:~w Data:~w CallBack:{~w, ~w, ~w} Error:~w", [EventTypeId, Data, M, F, A, Err]),
            do_dispatch_fun(T, EventTypeId, Data) 
    end.