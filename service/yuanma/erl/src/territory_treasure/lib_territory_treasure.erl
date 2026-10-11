%% ---------------------------------------------------------------------------
%% @doc lib_territory_treasure.erl
%% @author  xlh
%% @email
%% @since   2019.3.6
%% @deprecated 领地夺宝
%% ---------------------------------------------------------------------------

-module(lib_territory_treasure).

-include("territory_treasure.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("activitycalen.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("goods.hrl").

-export([
		drop_thing/5
		,mon_be_hurt/4
		,judge_dunid/1
		,calc_time/0
		,mon_be_killed/2
		,clear_scene_palyer/1
		,quit_timeout/1
		,gm_start/1
		,get_player_score/4
		,enter_territory/5
		,gm_start/5
		,re_login/2
		,is_on_territory_treasure/1
        ,get_copyid_dunid/1
        ,get_copyid_dunid_helper/1
        ,get_act_time/3
	]).

%% 判断是否在领地夺宝场景
is_on_territory_treasure(Scene) ->
	case data_territory_treasure:get_all_scene() of
		SceneIds when is_list(SceneIds) ->
			case lists:member(Scene, SceneIds) of
				true -> true;
				_ -> false
			end;
		_ ->
			false
	end.

get_copyid_dunid(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_territory_treasure, get_copyid_dunid_helper, []).

get_copyid_dunid_helper(PS) ->
    #player_status{scene = Scene, copy_id = CopyId} = PS,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_TERRITORY} ->
            MonInfo = lib_mon:get_scene_mon(Scene, 0,CopyId, all),
            ?PRINT("copy_id:~p, Scene:~p~n",[CopyId, Scene]),
            ?PRINT("MonInfo:~p~n",[MonInfo]),
            {ok, PS};
        _ ->
            {ok, PS}
    end.

%% 统计伤害
mon_be_hurt(Object, RoleId, Name, Hurt) ->
	#scene_object{scene = ObjectScene, scene_pool_id = PoolId, copy_id = CopyId} = Object,
	IsOn = is_on_territory_treasure(ObjectScene),
	if
		IsOn ->
			mod_territory_treasure:mon_be_hurt(ObjectScene, PoolId, CopyId, RoleId, Name, Hurt);
		true ->
			skip
	end.

mon_be_killed(Object, Monid) ->
	#scene_object{scene = ObjectScene, scene_pool_id = PoolId, copy_id = CopyId, d_x = DX, d_y = DY} = Object,
	IsOn = is_on_territory_treasure(ObjectScene),
	if
		IsOn ->
			mod_territory_treasure:mon_killed(ObjectScene, PoolId, CopyId, Monid, DX, DY);
		true ->
			skip
	end.


%% 统计奖励
drop_thing(Scene, Monid, RoleId, _RoleName, Reward) ->
	IsOn = is_on_territory_treasure(Scene),
	if
		IsOn ->
			mod_territory_treasure:drop_thing(Monid, RoleId, Reward);
		true ->
			skip
	end.

judge_dunid(Score) when is_integer(Score) andalso Score =/= 0 ->
	case data_territory_treasure:get_value(?KEY_DUN_DUNID_1) of
		[{_, _, _}|_] = List -> List;
		_ -> List = []
	end,
	Fun = fun({Min, Max, DunId}, TemDunId) ->
		if
			Score >= Min andalso Score =< Max ->
				DunId;
			true ->
				TemDunId
		end
	end,
	NewDunId = lists:foldl(Fun, 0, List),
	if
		NewDunId == 0 ->
			case data_territory_treasure:get_value(?KEY_DUN_DUNID_2) of
				DunCfg when is_integer(DunCfg) andalso DunCfg >= 0 -> DunCfg;
				_E -> ?ERR("miss cfg kv table, DunId error. _E:~p~n",[_E]), DunCfg = 0
			end;
		true ->
			DunCfg = NewDunId
	end,
	DunCfg;
judge_dunid(_) ->
	case data_territory_treasure:get_value(?KEY_DUN_DUNID_2) of
		DunCfg when is_integer(DunCfg) andalso DunCfg >= 0 -> DunCfg;
		_E -> ?ERR("miss cfg kv table, DunId error. _E:~p~n",[_E]), DunCfg = 0
	end,
	DunCfg.

calc_reborn_time_helper(OpenTime, NowTime) ->
	{_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
	Fun = fun({{Shcfg, Smcfg},_}) ->
		NowSH*60 +NowSM < Shcfg *60 + Smcfg
	end,
	ulists:find(Fun, OpenTime).

get_next_open_time(Day, TempTime,OpenDayList) ->%%距离下一个开放日的时间差距（s）
    case OpenDayList of
        [{Start, End}] when Day + 1 >= Start andalso Day + 1 =< End ->
            TempTime+86400;
        _ ->
        	TempTime
    end.

calc_time() ->
	case data_activitycalen:get_ac(?MOD_TERRITORY,31,0) of
        #base_ac{time_region = OpenTime, open_day = ServerOpenDay} ->
        	OpenDay = util:get_open_day(),
        	case ServerOpenDay of
        		[{Start, End}] when OpenDay >= Start andalso OpenDay =< End ->
        			NowTime = utime:unixtime(),
        			{Date, _Time} = utime:unixtime_to_localtime(NowTime),
        			[{{Sh, Sm},_}|_] = OpenTime,
        			DisTime = get_next_open_time(OpenDay,0,ServerOpenDay),
        			case calc_reborn_time_helper(OpenTime, NowTime) of
        				{ok, {{Shcfg, Smcfg}, _}} ->
        					TemStartT = utime:unixtime({Date, {Shcfg, Smcfg,0}}),
        					{true, TemStartT - NowTime};
        				_ ->
        					if
        						DisTime =/= 0 ->
        							{Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
		        					TemStartT = utime:unixtime({Date1, {Sh, Sm,0}}),
		        					{true, TemStartT - NowTime};
		        				true ->
		        					false
        					end

        			end;
        		_ ->
        			false
        	end;
        _ -> false
    end.

%% 场景进程处理
clear_scene_palyer(CopyId) ->
    UserList = lib_scene_agent:get_scene_user(CopyId),
    [begin
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_territory_treasure, quit_timeout, [])
    end|| #ets_scene_user{id = RoleId}<-UserList].

quit_timeout(Ps)->
    case is_on_territory_treasure(Ps#player_status.scene) of
        false -> skip;
        true ->
        	NewPs = lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
            {ok, NewPs}
    end.


get_player_score(BelongL, Score, IsHave, RoleId) ->
	{ok, BinData} = pt_652:write(65201, [BelongL, Score, IsHave]),
    lib_server_send:send_to_uid(RoleId, BinData).

gm_start(Player) ->
 	#player_status{id = RoleId,
		figure = #figure{name = RoleName},
		guild = #status_guild{id = GuildId, name = GuildName}} = Player,
	mod_sanctuary:gm_start_territory_treasure(RoleId, RoleName, GuildId, GuildName).

gm_start(RoleId, RoleName, GuildId, GuildName, Score) ->
	DunId = lib_territory_treasure:judge_dunid(Score),
	mod_territory_treasure:gm_start(),
	spawn(fun() ->
		timer:sleep(1000),
		case data_territory_treasure:get_base_cfg(DunId) of
			#base_cfg{scene = Scene} ->
				mod_territory_treasure:enter(Scene, RoleId, RoleName, GuildId, GuildName, DunId, 1);
				% lib_scene:player_change_scene(RoleId, Scene, 0, DunId, true, [{group, 0}]);
			_ ->
				Code = ?ERRCODE(err652_error_cfg),
				{ok, BinData} = pt_652:write(65202, [Code, DunId, 0, 0, 0, 0, 0]),
    			lib_server_send:send_to_uid(RoleId, BinData)
		end
	end).

enter_territory(RoleId, RoleName, GuildId, GuildName, Score) ->
	DunId = lib_territory_treasure:judge_dunid(Score),
	% ?PRINT("DunId:~p~n",[DunId]),
	case data_territory_treasure:get_base_cfg(DunId) of
		#base_cfg{scene = Scene} ->
			mod_territory_treasure:enter(Scene, RoleId, RoleName, GuildId, GuildName, DunId, 1);
		_ ->
			Code = ?ERRCODE(err652_error_cfg),
			{ok, BinData} = pt_652:write(65202, [Code, 0, 0, 0, 0, 0, 0]),
			lib_server_send:send_to_uid(RoleId, BinData)
	end.

get_act_time(RoleId, GuildId, Score) ->
    DunId = lib_territory_treasure:judge_dunid(Score),
    % ?PRINT("DunId:~p~n",[DunId]),
    case data_territory_treasure:get_base_cfg(DunId) of
        #base_cfg{scene = Scene} ->
            mod_territory_treasure:get_act_time(RoleId, GuildId, DunId);
        _ ->
            {ok, BinData} = pt_652:write(65208, [0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

re_login(PS, _LoginType) ->
	#player_status{id = RoleId,
		figure = #figure{name = RoleName, lv = RoleLv},
		guild = #status_guild{id = GuildId, name = GuildName},
        scene = Scene,
        scene_pool_id = PoolId,
        copy_id = CopyId} = PS,
	IsInScene = is_on_territory_treasure(Scene),
	if
		IsInScene == true ->
			case pp_territory_treasure:check_act_cfg(PS) of
				true ->
					NewPlayer = lib_scene:change_relogin_scene(PS, [{change_scene_hp_lim, 100},{ghost, 0}]),
					mod_territory_treasure:reconnect_territory_treasure(RoleId, RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId),
					{ok, NewPlayer};
				{false, Code} ->
					{ok, BinData} = pt_652:write(65202, [Code, 0, 0, 0, 0, 0, 0]),
		    		lib_server_send:send_to_uid(PS#player_status.id, BinData),
		    		NewPlayer = lib_scene:change_default_scene(PS, [{change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
                    {ok, NewPlayer}
		    end;
		true ->
			{next, PS}
	end.
