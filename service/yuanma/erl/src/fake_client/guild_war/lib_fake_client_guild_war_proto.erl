%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_guild_war_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 公会争霸挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_guild_war_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(50603, PS, [Code, Type]) ->
	lib_fake_client_guild_war:enter_activity_result(PS, Code, Type);

%% 
handle_proto(50604, PS, [TerritoryId, _EndTime, _RoleScore, _GuildList, _StageList, MonList]) ->
	lib_fake_client_guild_war:guild_war_msg(PS, TerritoryId, MonList);

handle_proto(50607, PS, [MonList]) ->
	lib_fake_client_guild_war:mon_list(PS, MonList);

handle_proto(50611, PS, [TerritoryId, _ModeNum, GuildList]) ->
	lib_fake_client_guild_war:war_settlement(PS, TerritoryId, GuildList);

handle_proto(50620, PS, [Round, RoundStartTime, RoundEndTime]) ->
	lib_fake_client_guild_war:next_round_fight(PS, Round, RoundStartTime, RoundEndTime);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.