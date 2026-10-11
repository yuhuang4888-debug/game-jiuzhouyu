%% ---------------------------------------------------------------------------
%% @doc lib_companion_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/28 0028
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_companion_api).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("dungeon.hrl").
-include("rec_event.hrl").
-include("companion.hrl").

%% 进入副本
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_id=DunId}}) when is_record(Player, player_status) ->
    case DunId == ?TMPACTIVEDUNID of
        true ->
            lib_companion:active_default_companion_tmp(Player, ?TMPACTIVEDUNID);
        _ -> {ok, Player}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = #callback_dungeon_succ{dun_id=DunId}}) when is_record(Player, player_status) ->
    case DunId == ?TMPACTIVEDUNID of
        true ->
            lib_companion:cancel_default_companion_tmp(Player);
        _ -> {ok, Player}
    end;
%% 副本失败
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_FAIL, data = #callback_dungeon_fail{dun_id=DunId}}) ->
    case DunId == ?TMPACTIVEDUNID of
        true ->
            lib_companion:cancel_default_companion_tmp(Player);
        _ -> {ok, Player}
    end;
%% 登陆延后事件，判断默认伙伴激活与否
%% 一个客户端容错，防止客户端完成激活伙伴的任务之后，断线无法激活初始伙伴
handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = Player,
    case lists:keyfind(?DEFAULT_COMPANION_ID, #companion_item.companion_id, CompanionList) of
        #companion_item{} -> {ok, Player};
        _ ->
            case lib_companion:active_default_companion(Player) of
                {true, NewPlayer} -> LastPlayer = NewPlayer;
                _ -> LastPlayer = Player
            end,
            {ok, LastPlayer}
    end;
handle_event(Player, _) ->
    {ok, Player}.

