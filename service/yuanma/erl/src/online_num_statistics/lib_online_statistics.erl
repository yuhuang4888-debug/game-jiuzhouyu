-module(lib_online_statistics).

-include("def_event.hrl").
-include("server.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("common.hrl").

-export([
			handle_event/2
			,logout/1
		]).

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{id = RoleId, server_id = ServerId, figure = #figure{lv = RoleLv}} = Player,
    mod_online_statistics:cast_center([{'user_lv_up', RoleId, RoleLv, ServerId}]),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
	#player_status{id = RoleId, server_id = ServerId, 
		figure = #figure{lv = RoleLv}, 
		login_time_before_last = LastLoginTime, 
		last_login_time = LoginTime} = Player,
	IsSameDay = utime:is_same_day(LastLoginTime, LoginTime),
	if
		LastLoginTime < LoginTime andalso IsSameDay == false ->
			FirstLogin = true;
		true ->
			FirstLogin = false
	end,
	mod_online_statistics:cast_center([{'user_login', RoleId, RoleLv, ServerId, FirstLogin}]),
	{ok, Player};

handle_event(Player, _) ->
    {ok, Player}.

logout(Player) ->
	#player_status{id = RoleId, server_id = ServerId, figure = #figure{lv = RoleLv}} = Player,
	mod_online_statistics:cast_center([{'user_logout', RoleId, RoleLv, ServerId}]),
	ok.