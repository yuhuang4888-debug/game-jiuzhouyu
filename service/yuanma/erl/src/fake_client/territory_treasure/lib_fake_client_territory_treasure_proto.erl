%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_territory_treasure_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 领地夺宝挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_territory_treasure_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(65202, PS, [Code, Dunid, _TotalWave, _FirstWaveTime, _Wave, _Num, _EndTime]) ->
	lib_fake_client_territory_treasure:enter_activity_result(PS, Code, Dunid);

%% 波数刷新
handle_proto(65204, PS, [_Rank, Wave, Num, Time]) ->
	lib_fake_client_territory_treasure:refresh_wave(PS, Wave, Num, Time);

%% 怪物死亡
handle_proto(65209, PS, [MonId, X, Y]) ->
	lib_fake_client_territory_treasure:mon_die(PS, MonId, X, Y);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.