%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior_send

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_send).

%% API
-export([
    send_msg/1
]).

-include("common.hrl").
-include("server.hrl").

%% 默认接受处理的协议号
-define(DefaultProtoL, [
    12001, 12002, 12003, 12004, 12005, 12006, 12007, 12008, 12011, 12012, 12013, 12014, 12015,
    12016, 12017, 12018, 12019, 12024, 15053, 12070, 12071, 12072, 12083, 15053, 20001, 20008, 20026
]).

send_msg(PlayerPid) ->
    send_msg_do(PlayerPid, true).

send_msg_do(PlayerPid, IsSend) ->
    receive
        {send, Bin} when is_binary(Bin) andalso IsSend == true ->
            handle_send_binary(Bin, PlayerPid),
            send_msg_do(PlayerPid, IsSend);
        {is_send, IsSendNew} ->
            send_msg_do(PlayerPid, IsSendNew);
        relogin_close ->
            ok;
        close ->
            ok;
        _ ->
            send_msg_do(PlayerPid, IsSend)
    end.

handle_send_binary(Bin, PlayerPid) ->
    {ProtoId, DataBin, LeftBin} = pt_server:unpack(Bin),
    case lists:member(ProtoId, ?DefaultProtoL) of
        true ->
            PlayerPid ! {'player_btree_router', ProtoId, DataBin};
        _ ->
            ok
    end,
    case LeftBin of
        <<>> -> ok;
        _ -> handle_send_binary(LeftBin, PlayerPid)
    end.