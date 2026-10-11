-module(lib_player_info_report).

-compile(export_all).
-include("common.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("php.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-define(ReportURL, "https://ad-center.hnguangyi.cn"). %% 战力上报
-define(KEY, "rgLe1LSUUF0tW7Sz"). %% 
-define(GAMEID, 10020). %% 

-define(PowerCountId, 1). %% 

login(Player) ->
	#player_status{figure = #figure{lv = Lv}} = Player,
	if
	 	Lv == 1 ->
	 		level_report(Player);
	 	true -> ok
	end.

%% 战力排行榜、 职业排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    power_report(Player),
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status)  ->
    level_report(Player),
    {ok, Player};
handle_event(Player, _Ec) ->
    {ok, Player}.

power_report(Player) ->
	case is_need_report_player_info(Player#player_status.source) of 
		false -> ok;
		true ->
			case mod_counter:get_other_data(Player#player_status.id, ?MOD_PLAYER, 1, ?PowerCountId) of 
				[{power, OldPowerReport}|_] -> ok;
				_ -> OldPowerReport = 0
			end,
			NewPower = Player#player_status.combat_power,
			case OldPowerReport =< NewPower - 1000 of 
				false -> ok;
				_ ->
					NowTime = utime:unixtime(),
					mod_counter:set_count(Player#player_status.id, [{{?MOD_PLAYER, 1, ?PowerCountId}, {1, [{power, NewPower}]}}]),
					#player_status{
						id = RoleId, accname_sdk = AccName, reg_time = RegTime, reg_server_id = ServerId,
						figure = #figure{name = RoleName}
					} = Player,
					% AuthStr = calc_auth(NowTime),
				 %    Data = [
				 %    	[
					%     	{user_id, AccName}, {role_id, RoleId},
					%     	{role_name, RoleName}, {server_id, ServerId},
					%     	{power, NewPower}, {game_time, NowTime}, {create_time, RegTime}
					% 	]
					% ],
					% JsonPostData = iolist_to_binary(mochijson2:encode(Data)),
					% PostData = [{method, 'game.powerReport'}, {time, NowTime}, {cp_id, ?GAMEID}, {data, JsonPostData}, {sign, AuthStr}],
					% StrBody = mochiweb_util:urlencode(PostData),
				 %    ?PRINT("JsonPostData:~s~n", [JsonPostData]),
				 %    ?PRINT("StrBody:~s~n", [StrBody]),
				 %    mod_php:request(?ReportURL, StrBody, #php_request{})
				Data = [{user_id, util:make_sure_binary(AccName)}, {role_id, RoleId}, {role_name, util:make_sure_binary(RoleName)}, {server_id, ServerId}, {power, NewPower}, {game_time, NowTime}, {create_time, RegTime}],
				mod_player_info_report:add_report(power, Data)
			end
	end.

level_report(Player) ->
	case is_need_report_player_info(Player#player_status.source) of 
		false -> ok;
		true ->
			Level = Player#player_status.figure#figure.lv,
			NeedReport = if
				Level =< 0 -> false;
				Level == 1 -> true;
				Level > 160 -> true;
				true ->
					Level rem 10 == 0
			end,
			case NeedReport of 
				false -> ok;
				_ ->
					NowTime = utime:unixtime(),
					#player_status{
						id = RoleId, accname_sdk = AccName, reg_time = RegTime, reg_server_id = ServerId,
						figure = #figure{name = RoleName}
					} = Player,
					% AuthStr = calc_auth(NowTime),
				 %    Data = [
				 %    	[
					%     	{user_id, AccName}, {role_id, RoleId},
					%     	{role_name, RoleName}, {server_id, ServerId},
					%     	{level, Level}, {game_time, NowTime}, {create_time, RegTime}
					% 	]
					% ],
					% JsonPostData = iolist_to_binary(mochijson2:encode(Data)),
					% PostData = [{method, 'game.levelReport'}, {time, NowTime}, {cp_id, ?GAMEID}, {data, JsonPostData}, {sign, AuthStr}],
					% StrBody = mochiweb_util:urlencode(PostData),
				 %    ?PRINT("JsonPostData:~s~n", [JsonPostData]),
				 %    ?PRINT("StrBody:~s~n", [StrBody]),
				 %    mod_php:request(?ReportURL, StrBody, #php_request{})
				 	Data = [
					     	{user_id, util:make_sure_binary(AccName)}, {role_id, RoleId},
					     	{role_name, util:make_sure_binary(RoleName)}, {server_id, ServerId},
					     	{level, Level}, {game_time, NowTime}, {create_time, RegTime}
					],
				    mod_player_info_report:add_report(level, Data)
			end
	end.

chat_report(Player, ChatType, Msg, ChatTime, Args, ChatTimeLineArgs) when Msg =/= <<>> andalso Msg =/= "" ->
	case is_need_report_player_info(Player#player_status.source) of 
		false -> ok;
		true ->
		    #player_status{accname_sdk = AccName, id = RoleId, figure = Figure,
		                   source = _Source, server_id = _ServerId, 
		                   reg_server_id = RegServerId,
		                   platform = _Platform, server_name = ServerName,
		                   server_num = _ServerNum, ip = _IP} = Player,
		    #figure{name = Name, lv = Lv, vip = Vip,
		            guild_id = _GuildId, guild_name = _GuildName} = Figure,
		    SyChatTime = round(ChatTime/1000),
		    case ChatTimeLineArgs of 
		    	[_, _, _, _, RId, ReceiveVip, ReceiveLv] -> 
		    		ReceiveAccName = get_receiver_accname(RId);
		    	_ -> ReceiveAccName = "0", ReceiveVip = 0, ReceiveLv = 0
		    end,
		    {_, ReceiveId} = ulists:keyfind(chat_to_id, 1, Args, {chat_to_id, 0}),
		    {_, ReceiveName} = ulists:keyfind(chat_to_name, 1, Args, {chat_to_name, ""}),
		 %    AuthStr = calc_auth(SyChatTime),
		 %    Data = [
		 %    	[
			%     	{server_id, RegServerId}, {server_name, ServerName}, {chat_channel, ChatType}, {chat_content, util:make_sure_binary(Msg)},
			%     	{sender_uid, AccName}, {sender_rid, RoleId}, {sender_name, Name}, {sender_level, Lv}, {sender_vip_level, Vip},
			%     	{receiver_uid, ReceiveAccName}, {receiver_rid, ReceiveId}, {receiver_name, ReceiveName}, {receiver_level, ReceiveLv}, {receiver_vip_level, ReceiveVip},
			%     	{sender_timestamp, SyChatTime}
			% 	]
			% ],
			% JsonPostData = iolist_to_binary(mochijson2:encode(Data)),
			% PostData = [{method, 'game.chatReport'}, {time, SyChatTime}, {cp_id, ?GAMEID}, {data, JsonPostData}, {sign, AuthStr}],
			% StrBody = mochiweb_util:urlencode(PostData),
		 %    ?PRINT("JsonPostData:~s~n", [JsonPostData]),
		 %    ?PRINT("StrBody:~s~n", [StrBody]),
		 %    mod_php:request(?ReportURL, StrBody, #php_request{})
		    Data = [
			    	{server_id, RegServerId}, {server_name, util:make_sure_binary(ServerName)}, {chat_channel, ChatType}, {chat_content, util:make_sure_binary(Msg)},
			    	{sender_uid, util:make_sure_binary(AccName)}, {sender_rid, RoleId}, {sender_name, util:make_sure_binary(Name)}, {sender_level, Lv}, {sender_vip_level, Vip},
			    	{receiver_uid, util:make_sure_binary(ReceiveAccName)}, {receiver_rid, ReceiveId}, {receiver_name, util:make_sure_binary(ReceiveName)}, {receiver_level, ReceiveLv}, {receiver_vip_level, ReceiveVip},
			    	{sender_timestamp, SyChatTime}
				],
			mod_player_info_report:add_report(chat, Data)
	end;
chat_report(_Ps, _ChatType, _Msg, _ChatTime, _Args, _ChatTimeLineArgs) ->
	ok.

calc_auth(NowTime) ->
	List = lists:keysort(1, [{"time", NowTime}, {"cp_id", ?GAMEID}, {"key", ?KEY}]),
	Md5Str = mochiweb_util:urlencode(List),
    AuthStr = util:md5(Md5Str),
    AuthStr.

get_receiver_accname(RId) ->
	case mod_cache:get({?MODULE, accname, RId}) of
		undefined ->
			RAccName = db:get_one(io_lib:format("select accname_sdk from player_login where id=~p limit 1", [RId])),
			mod_cache:put({?MODULE, accname, RId}, RAccName),
			RAccName;
		RAccName -> RAccName
	end.

get_url() ->
	?ReportURL.

get_game_id() ->
	?GAMEID.


is_need_report_player_info(Source) ->
    case string:str(util:make_sure_list(Source), "_keyi") > 0 of 
    	true -> true;
    	_ -> false
    end.

reply_request_role_report(_Request, JsonData, Type) ->
	case catch mochijson2:decode(JsonData) of
        {'EXIT', Error} -> ?ERR("Error:~p,Type:~p, JsonData:~p ~n", [Error, Type, JsonData]);
        JsonTuple ->
            [Code] = lib_gift_card:extract_mochijson2([<<"code">>], JsonTuple),
            case Code of
                0 -> 
                	ok;
                _ ->
                    [Msg] = lib_gift_card:extract_mochijson2([<<"msg">>], JsonTuple),
                    ?INFO("reply_request_role_report fali ~p~n", [Msg])
            end
    end,
	ok.