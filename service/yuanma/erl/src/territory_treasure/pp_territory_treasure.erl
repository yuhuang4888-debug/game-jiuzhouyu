%% ---------------------------------------------------------------------------
%% @doc lib_territory_treasure.erl
%% @author  xlh
%% @email   
%% @since   2019.3.6
%% @deprecated 领地夺宝 652
%% ---------------------------------------------------------------------------
-module(pp_territory_treasure).

-include("territory_treasure.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("activitycalen.hrl").
-include("scene.hrl").

-export([
		handle/3,
		check_act_cfg/1
	]).


handle(65201, Player, []) ->
	#player_status{id = RoleId,  
		guild = #status_guild{id = GuildId}} = Player,
	mod_sanctuary:get_score(RoleId, GuildId);

handle(65202, Player, []) ->
    #player_status{id = RoleId, scene = ObjectScene,
        figure = #figure{name = RoleName}, 
        guild = #status_guild{id = GuildId, name = GuildName}} = Player,
    IsInScene = lib_territory_treasure:is_on_territory_treasure(ObjectScene),
    if
        IsInScene == true ->
            {ok, BinData} = pt_652:write(65202, [?ERRCODE(err651_in_scene), 0, 0, 0, 0, 0, 0]),
            lib_server_send:send_to_uid(Player#player_status.id, BinData);
        true ->
            case check_act_cfg(Player) of
                true ->
                    mod_sanctuary:enter_territory_treasure(RoleId, RoleName, GuildId, GuildName);
                {false, Code} ->    
                    {ok, BinData} = pt_652:write(65202, [Code, 0, 0, 0, 0, 0, 0]),
                    lib_server_send:send_to_uid(Player#player_status.id, BinData)
            end
    end,
    {ok, Player};

%% 退出
handle(65206, Player, []) ->
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Player),
    case IsOut of
        true ->
            case data_scene:get(Player#player_status.scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_TERRITORY ->
                    #player_status{id = RoleId} = Player, %% 可以切换pk状态的场景在退出时都需要将pk状态设置为和平模式
                    NewPs = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
                    mod_territory_treasure:handle_out(RoleId);
                _ ->
                    NewPs = Player
            end;
        false ->
            NewPs = Player
    end,
    {ok, BinData} = pt_652:write(65206, [ErrCode]),
    lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
    {ok, NewPs};

handle(65208, Player, []) ->
    #player_status{id = RoleId,  
        guild = #status_guild{id = GuildId}} = Player,
    mod_sanctuary:get_act_time(RoleId, GuildId);

handle(_Comd, Player, _Data) ->{ok, Player}.

check_act_cfg(Ps) ->
    case lib_player_check:check_list(Ps, [action_free, is_transferable]) of
        {false, Code} ->
            {false, Code};
        _ ->
        	case data_activitycalen:get_ac(?MOD_TERRITORY,31,0) of
                #base_ac{start_lv = StartLv, end_lv = EndLv, time_region = OpenTime, open_day = ServerOpenDay} ->
                	CheckList = [{gm_stop_act}, {lv, StartLv, EndLv}],
                	check(Ps, CheckList);
                _ -> {false, ?ERRCODE(missing_config)}
            end
    end.

check(_, []) -> true;
check(Ps, [{gm_stop_act}|T]) ->
    case lib_gm_stop:check_gm_close_act(?MOD_TERRITORY, 0) of
        true -> check(Ps, T);
        _ -> {false, ?ERR_GM_STOP}
    end;
check(Ps, [{lv, StartLv, EndLv}|T]) ->
	#player_status{figure = #figure{lv = RoleLv}} = Ps,
	if
		RoleLv >= StartLv andalso RoleLv =< EndLv ->
			check(Ps, T);
		true ->
			{false, ?ERRCODE(err652_lv_not_enough)}
	end;
check(Ps, [{time, OpenTime}|T]) ->
	NowTime = utime:unixtime(),
	{_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
	[{{Shcfg, Smcfg},{Ehcfg, Emcfg}}|_] = OpenTime,
	Now = NowSH *60 + NowSM,
	Start = Shcfg *60 + Smcfg,
	End = Ehcfg *60 + Emcfg,
	if
		Now >= Start andalso Now < End ->
			check(Ps, T);
		true ->
			{false, ?ERRCODE(err652_time_out_of_rang)}
	end;
check(Ps, [{open_day, ServerOpenDay}|T]) ->
	OpenDay = util:get_open_day(),
	[{Day1, Day2}|_] = ServerOpenDay,
	if
		OpenDay >= Day1 andalso OpenDay =< Day2 ->
			check(Ps, T);
		true ->
			{false, ?ERRCODE(err652_open_day_limit)}
	end.