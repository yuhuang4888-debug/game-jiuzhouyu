-module(pp_territory_war).

-export([handle/3]).

-include("server.hrl").
-include("territory_war.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").


%% 活动状态信息
handle(50600, PlayerStatus, []) ->
	mod_territory_war:send_territory_war_state(PlayerStatus#player_status.sid), 
	{ok, PlayerStatus};

%% 活动主界面
handle(50601, PlayerStatus, []) ->
	lib_territory_war:send_territory_war_show(PlayerStatus), 
	{ok, PlayerStatus};

%% 领取每日奖励
handle(50602, PlayerStatus, []) ->
	#player_status{sid = Sid, guild= #status_guild{id = GuildId}} = PlayerStatus,
	case GuildId > 0 of
		true ->
			lib_territory_war:get_daily_reward(PlayerStatus);
		false-> 
            {ok, BinData} = pt_506:write(50602, [?ERRCODE(err505Errcode_no_guild)]),
            lib_server_send:send_to_sid(Sid, BinData)
	end;

%% 进入，退出场景
handle(50603, PlayerStatus, [Type]) ->
	?PRINT("50603  ~n",[]),
	#player_status{sid = Sid} = PlayerStatus,
    Result = case Type of
        1 -> lib_territory_war:enter_war(PlayerStatus);
        2 -> lib_territory_war:leave_war(PlayerStatus)
    end,
    case Result of 
        {true, NewPS} ->
            StrongPs = lib_to_be_strong:update_data_guild_war(NewPS),     
            {ok, StrongPs};
        {false, Res} ->
            ?PRINT("50603 Res ~p~n", [Res]),
            {ok, BinData} = pt_506:write(50503, [Res, Type]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, PlayerStatus}
    end;

handle(50604, PlayerStatus, []) ->
	#player_status{scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case lib_territory_war:is_in_territory_war(SceneId) andalso is_pid(CopyId) of 
        true -> 
        	lib_territory_war:send_war_info(PlayerStatus),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

%%据点加积分
% handle(50608, PlayerStatus, [MonId,Type]) ->
% 	?PRINT("50608  ~p~n",[Type]),
% 	#player_status{guild= #status_guild{id = GuildId}} = PlayerStatus,
% 	case GuildId> 0 of
% 		true->
%     		lib_territory_war:step_own_change(PlayerStatus,MonId,Type);
% 		false-> skip
% 	end;


handle(50617, PlayerStatus, [MonId]) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, guild = #status_guild{id = GuildId, position = Position}} = PlayerStatus,  
    case lib_territory_war:is_in_territory_war(SceneId) andalso is_pid(CopyId) andalso Position == ?POS_CHIEF of 
        true -> 
        	lib_territory_war:convene_guild_member(SceneId, CopyId, GuildId, RoleId, MonId),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

%%分配奖励
handle(50618, PlayerStatus, [RoleId]) ->
	#player_status{id = ChiefId, sid = Sid, guild = #status_guild{id = GuildId, name = GuildName, position = Position}} = PlayerStatus,
	case Position /= ?POS_CHIEF of 
		true -> Errcode = ?ERRCODE(err506_not_chief_alloc);
		_ ->
			#figure{guild_id = RoleGuildId, name = RoleName} = lib_role:get_role_figure(RoleId),
			case GuildId /= RoleGuildId of 
				true -> Errcode = ?ERRCODE(err506_not_same_guild_alloc);
				_ -> 
					mod_territory_war:allocate_reward([ChiefId, Sid, GuildId, GuildName, RoleId, RoleName]),
					Errcode = none
			end
	end,
	case Errcode /= none of 
		true ->
			{ok, Bin} = pt_506:write(50618, [Errcode]),
			lib_server_send:send_to_sid(Sid, Bin);
		_ -> ok
	end;

handle(50620, PlayerStatus, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = _GuildId}} = PlayerStatus,
	ServerId = config:get_server_id(),
	Node = mod_disperse:get_clusters_node(),
    mod_territory_war:send_round_time_info([ServerId, Node, RoleId, Sid]),
    {ok, PlayerStatus};

handle(50621, PlayerStatus, []) ->
    #player_status{id = RoleId, sid = Sid} = PlayerStatus,
	ServerId = config:get_server_id(),
	Node = mod_disperse:get_clusters_node(),
    mod_territory_war:send_territory_war_list([ServerId, Node, RoleId, Sid]),
    {ok, PlayerStatus};

handle(50622, PlayerStatus, []) ->
    #player_status{id = RoleId, sid = Sid}= PlayerStatus,
	ServerId = config:get_server_id(),
	Node = mod_disperse:get_clusters_node(),
    mod_territory_war:send_server_divide_info([ServerId, Node, RoleId, Sid]),
    {ok, PlayerStatus};

handle(50623, PlayerStatus, [TerritoryId]) ->
	lib_territory_war:choose_terri_id(PlayerStatus, TerritoryId),
    {ok, PlayerStatus};

handle(50624, PlayerStatus, []) ->
	#player_status{id = RoleId, sid = Sid, server_id = ServerId, guild = #status_guild{id = GuildId}} = PlayerStatus,
	case GuildId > 0 of 
		true ->
			Node = mod_disperse:get_clusters_node(),
			Msg = [RoleId, Sid, GuildId, ServerId, Node],
			mod_territory_war:guild_qualification(Msg);
		_ ->
			lib_server_send:send_to_sid(Sid, pt_506, 50624, [0, 0])
	end;

handle(_Cmd, _Player, _Data) ->
    ?PRINT(" Data:~p ~n", [ _Data]),
    {error, "pp_territory_war no match~n"}.