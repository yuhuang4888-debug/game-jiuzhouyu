%% ---------------------------------------------------------------------------
%% @doc data_fake_client_m.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(data_fake_client_m).
-include("fake_client.hrl").
-include("def_module.hrl").

-compile(export_all).

get_regis_proto(0, 0) ->
	[12001, 12002, 12003, 12004, 12005, 12006, 12007, 12008, 12011, 12012, 12013, 12014, 12015, 12017,
	 12018, 12019, 12024, 15053, 12070, 12071, 12072, 12083, 20001, 20008, 20026];

get_regis_proto(?MOD_NINE, _) ->
	[13502];

get_regis_proto(?MOD_MIDDAY_PARTY, _) ->
	[28501];

get_regis_proto(?MOD_DRUMWAR, _) ->
	[13704, 13708, 13710];

get_regis_proto(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY) ->
	[40212];

get_regis_proto(?MOD_TOPPK, _) ->
	[28110, 28113];

get_regis_proto(?MOD_HOLY_SPIRIT_BATTLEFIELD, _) ->
	[21802, 21813, 21809];

get_regis_proto(?MOD_TERRITORY, _) ->
	[65202, 65204, 65209];

get_regis_proto(?MOD_TERRITORY_WAR, _) ->
	[50603, 50604, 50607, 50611, 50620];

get_regis_proto(?MOD_KF_1VN, _) ->
	[62103, 62101];

get_regis_proto(_, _) ->
	[].