%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/12/8 0008
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_api).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% 玩家死亡
handle_event(PS, #event_callback{type_id = ?EVENT_PLAYER_DIE}) ->
    case lib_fake_client:in_fake_client(PS) of
        true -> NewPS = PS;
        _ -> NewPS = lib_player_behavior:player_die(PS)
    end,
    {ok, NewPS};
%% 复活完成
handle_event(PS, #event_callback{type_id = ?EVENT_REVIVE, data = _Data}) when is_record(PS, player_status) ->
    case lib_fake_client:in_fake_client(PS) of
        true -> NewPS = PS;
        _ -> NewPS = lib_player_behavior:player_revive(PS)
    end,
    {ok, NewPS};
handle_event(PS, _) ->
    {ok, PS}.

%% 是否在行为中
is_in_behavior(PS) -> lib_player_behavior:is_in_behavior(PS).
