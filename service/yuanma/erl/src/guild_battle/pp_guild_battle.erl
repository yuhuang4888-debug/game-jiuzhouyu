-module(pp_guild_battle).

-export([handle/3]).

-include("server.hrl").
-include("guild_battle.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").

%% 红点信息
handle(50500, PlayerStatus, []) ->
	?PRINT("50500  ~n",[]),
	lib_guild_battle:send_guild_battle_red_hot(PlayerStatus), 
	{ok, PlayerStatus};

%% 活动主界面
handle(50501, PlayerStatus, []) ->
	?PRINT("50501  ~n",[]),
	lib_guild_battle:send_guild_battle_show(PlayerStatus), 
	{ok, PlayerStatus};

%% 领取每日奖励
handle(50502, PlayerStatus, []) ->
	?PRINT("50502  ~n",[]),
	#player_status{guild= #status_guild{id = GuildId},sid = Sid} = PlayerStatus,
	case GuildId> 0 of
		true->
			NewPs = lib_guild_battle:get_daily_reward(PlayerStatus),
			{ok, NewPs};
		false-> 
            {ok, BinData} = pt_505:write(50502, [?ERRCODE(err505_no_guild)]),
            lib_server_send:send_to_sid(Sid, BinData)
	end;

%% 进入，退出场景
handle(50503, PlayerStatus, [Type]) ->
	?PRINT("50503  ~n",[]),
	#player_status{sid = Sid} = PlayerStatus,
    Result = case Type of
        1 -> lib_guild_battle:enter(PlayerStatus);
        2 -> lib_guild_battle:quit(PlayerStatus)
    end,
    case Result of 
        {true, NewPS} ->
            lib_player:apply_cast(NewPS#player_status.id, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, 
                        lib_to_be_strong, update_data, [NewPS#player_status.id, [1009,2002], 1]),     
            {ok, NewPS};
        {false, Res} ->
            ?PRINT("50503 Res ~p~n", [Res]),
            {ok, BinData} = pt_505:write(50503, [Res, Type]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, PlayerStatus}
    end;

handle(50504, PlayerStatus, []) ->
	#player_status{sid = Sid, scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
        	mod_guild_battle_fight:apply_cast(CopyId, {mod, send_war_endtime, [Sid]}),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

handle(50505, PlayerStatus, []) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
            mod_guild_battle_fight:apply_cast(CopyId, {mod, send_reward_list, [RoleId]}),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

handle(50506, PlayerStatus, []) ->
	#player_status{id = RoleId, sid = Sid, scene = SceneId, copy_id = CopyId, guild = #status_guild{id = GuildId}} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
        	mod_guild_battle_fight:apply_cast(CopyId, {mod, send_guild_rank, [RoleId]}),
            {ok, PlayerStatus};
        _ ->
            mod_guild_battle:send_guild_rank(RoleId, GuildId, Sid),
            {ok, PlayerStatus}
    end;

handle(50507, PlayerStatus, []) ->
	#player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
        	mod_guild_battle_fight:apply_cast(CopyId, {mod, send_own_list, [RoleId]}),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

%%据点加积分
handle(50508, PlayerStatus, [MonId,Type]) ->
	?PRINT("50508  ~p~n",[Type]),
	#player_status{guild= #status_guild{id = GuildId}} = PlayerStatus,
	case GuildId> 0 of
		true->
    		lib_guild_battle:step_own_change(PlayerStatus,MonId,Type);
		false-> skip
	end;

%战场领取个人积分奖励
handle(50509, PlayerStatus, [StageId]) ->
	?PRINT("50509  ~n",[]),
	#player_status{guild= #status_guild{id = GuildId}} = PlayerStatus,
	case GuildId> 0 of
		true->
    		lib_guild_battle:send_stage_reward(PlayerStatus,StageId);
		false-> skip
	end;

%%使用战场技能
% handle(50510, PlayerStatus, []) ->
% 	?PRINT("50510  ~n",[]),
% 	#player_status{guild= #status_guild{id = GuildId}} = PlayerStatus,
% 	case GuildId> 0 of
% 		true->
%     		lib_guild_battle:use_battle_skill(PlayerStatus);
% 		false-> skip
% 	end;

%%请求积分
handle(50512, PlayerStatus, []) ->
	#player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
        	mod_guild_battle_fight:apply_cast(CopyId, {mod, send_score, [RoleId]}),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

%%玩家排行
handle(50514, PlayerStatus, []) ->
	#player_status{id = RoleId, sid = Sid, scene = SceneId, copy_id = CopyId} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) of 
        true -> 
        	mod_guild_battle_fight:apply_cast(CopyId, {mod, send_role_rank, [RoleId, Sid]}),
            {ok, PlayerStatus};
        _ ->
            mod_guild_battle:send_role_rank(RoleId, Sid),
            {ok, PlayerStatus}
    end;

handle(50517, PlayerStatus, [MonId]) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, guild = #status_guild{id = GuildId, position = Position}} = PlayerStatus,  
    case SceneId == ?GUILD_BATTLE_ID andalso misc:is_process_alive(CopyId) andalso Position == ?POS_CHIEF of 
        true -> 
            mod_guild_battle_fight:apply_cast(CopyId, {mod, convene_guild_member, [GuildId, RoleId, MonId]}),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

%%分配奖励
handle(50518, PlayerStatus, [RoleId]) ->
	#player_status{id = ChiefId, sid = Sid, guild = #status_guild{id = GuildId, name = GuildName, position = Position}} = PlayerStatus,
	case Position /= ?POS_CHIEF of 
		true -> Errcode = ?ERRCODE(err505_not_chief_alloc);
		_ ->
			#figure{guild_id = RoleGuildId, name = RoleName} = lib_role:get_role_figure(RoleId),
			case GuildId /= RoleGuildId of 
				true -> Errcode = ?ERRCODE(err505_not_same_guild_alloc);
				_ -> 
					mod_guild_battle:allocate_reward(ChiefId, GuildId, GuildName, RoleId, RoleName),
					Errcode = none
			end
	end,
	case Errcode /= none of 
		true ->
			{ok, Bin} = pt_505:write(50518, [Errcode]),
			lib_server_send:send_to_sid(Sid, Bin);
		_ -> ok
	end;

handle(50520, PlayerStatus, []) ->
    #player_status{sid = Sid, guild = #status_guild{id = GuildId}} = PlayerStatus,
    case GuildId /= 0 of 
        true -> 
            mod_guild_battle:send_war_state(Sid),
            {ok, PlayerStatus};
        _ ->
            {ok, PlayerStatus}
    end;

handle(_Cmd, _Player, _Data) ->
    ?PRINT(" Data:~p ~n", [ _Data]),
    {error, "pp_guild_battle no match~n"}.