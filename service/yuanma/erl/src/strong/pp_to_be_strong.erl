-module(pp_to_be_strong).

-include("server.hrl").
-include("strong.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("figure.hrl").

-export([handle/3]).

handle(61801, Player, []) ->
	#player_status{sid = Sid, strong_status = StrongStatus, figure = Figure} = Player,
	#figure{lv = RoleLv} = Figure,
	OpenLv = lib_module:get_open_lv(?MOD_TO_BE_STRONG, 1),
	if
		RoleLv >= OpenLv ->
			StrongMap = StrongStatus#to_strong_status.state_map,
			Ids = lib_to_be_strong:get_limit_ids(),
			StrongMapList = maps:to_list(StrongMap),
			Fun = fun({K, V}, Acc) ->
				case lists:keyfind(K, 1, Ids) of
					{K, _, _} -> 
						#strong_state{id = K, state = State, time = Time, type = _Type, lv = _Lv} = V,
						[{K, State, Time}|Acc];
					_ ->
						Acc
				end
			end,
			SendList = lists:foldl(Fun, [], StrongMapList),
			% ?PRINT("SendList:~p,StrongMap:~p~n",[SendList,StrongMap]),
			{ok, Bin} = pt_618:write(61801, [SendList]),
			lib_server_send:send_to_sid(Sid, Bin);
		true ->
			{ok, Player}
	end;
	
handle(Cmd, _, Data) ->?ERR("MOD_TO_BE_STRONG Cmd:~p,Data:~p~n",[Cmd,Data]), skip.