%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client_proto).


-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

-export([
	msg_routing/3
	]).

msg_routing(PS, Cmd, DataBin) ->
	{ok, Data} = pt_server:read(Cmd, DataBin),
	[H1, H2, H3, _, _] = integer_to_list(Cmd),
    case [H1, H2, H3] of
        "120" -> 
        	lib_fake_client_scene_proto:handle_proto(Cmd, PS, Data);
        "200" ->
            lib_fake_client_battle_proto:handle_proto(Cmd, PS, Data);
        "135" ->
            lib_fake_client_nine_proto:handle_proto(Cmd, PS, Data);
        "137" ->
            lib_fake_client_drumwar_proto:handle_proto(Cmd, PS, Data);
        "150" ->
            lib_fake_client_goods_proto:handle_proto(Cmd, PS, Data);
        "218" ->
            lib_fake_client_holy_spirit_proto:handle_proto(Cmd, PS, Data);
        "281" ->
            lib_fake_client_toppk_proto:handle_proto(Cmd, PS, Data);
        "285" ->
            lib_fake_client_midday_party_proto:handle_proto(Cmd, PS, Data);
        "402" ->
            lib_fake_client_gactivity_proto:handle_proto(Cmd, PS, Data);
        "506" ->
            lib_fake_client_guild_war_proto:handle_proto(Cmd, PS, Data);
        "621" ->
            lib_fake_client_kf_1vN_proto:handle_proto(Cmd, PS, Data);
        "652" ->
            lib_fake_client_territory_treasure_proto:handle_proto(Cmd, PS, Data);
        _ ->
        	PS
    end.    