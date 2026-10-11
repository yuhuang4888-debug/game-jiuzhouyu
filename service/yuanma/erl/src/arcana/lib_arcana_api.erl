%% ---------------------------------------------------------------------------
%% @doc lib_arcana_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-10-22
%% @deprecated 远古奥术
%% ---------------------------------------------------------------------------
-module(lib_arcana_api).
-compile(export_all).

-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    NewPlayer = lib_arcana:auto_up_lv(Player),
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_TURN_UP}) when is_record(Player, player_status) ->
    NewPlayer = lib_arcana:auto_up_lv(Player),
    {ok, NewPlayer};

handle_event(Player, _EventCallback) ->
    {ok, Player}.
