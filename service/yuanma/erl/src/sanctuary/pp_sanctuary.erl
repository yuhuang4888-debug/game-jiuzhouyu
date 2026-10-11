%%%-----------------------------------
%%% @Module      : pp_sanctuary
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 01. 三月 2019 15:07
%%% @Description : 文件摘要
%%%-----------------------------------
-module(pp_sanctuary).
-author("chenyiming").


-include("figure.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("boss.hrl").
-include("sanctuary.hrl").

%% API
-compile(export_all).



handle(CMD, PS, Args) ->
	#player_status{figure = #figure{lv = Lv}, id = RoleId} = PS,
	OpenLv = data_sanctuary:get_kv(limit_lv),
	if
		Lv >= OpenLv ->
			case do_handle(CMD, PS, Args) of
				{ok, NewPS1} ->
					{ok, NewPS1};
				_ ->
					{ok, PS}
			end;
		true ->
			send_error(RoleId, ?ERRCODE(lv_limit))
	end.


send_error(RoleId, ErrCode) ->
%%	?MYLOG("cym", "ErrCode ~p ~n", [ErrCode]),
	{ok, Bin} = pt_283:write(28300, [ErrCode]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%圣域信息
do_handle(28301, #player_status{id = RoleId} = PS, [SanctuaryId]) ->
%%	?MYLOG("cym", "28301 +++++++++++++SanctuaryId ~p ~n", [SanctuaryId]),
	mod_sanctuary:get_info(SanctuaryId, RoleId),
	{ok, PS};

%%进入领地
do_handle(28303, #player_status{id = RoleId, guild = Guild, status_boss = #status_boss{boss_map = Map}, scene = OldScene} = PS, [SanctuaryId]) ->
	IsInFeastBoss = lib_boss:is_in_feast_boss(OldScene),
	if
		IsInFeastBoss == true ->
			send_error(RoleId, ?ERRCODE(cannot_transferable_scene));
		true ->
			PKStatus =
				case get(?sanctuary_pk) of
					undefined ->
						{?PK_GUILD, true};
					Value1 ->
						{Value1, true}
				end,
			GuildId =
				case Guild of
					#status_guild{id = Value} ->
						Value;
					_ ->
						0
				end,
			case maps:get(?BOSS_TYPE_SANCTUARY, Map, []) of
				#role_boss{die_time = LastDieTime, die_times = DieCount, next_enter_time = _NextEnterTime} ->
					mod_sanctuary:enter(SanctuaryId, RoleId, GuildId, LastDieTime, DieCount, OldScene, PKStatus);
				_ ->
					mod_sanctuary:enter(SanctuaryId, RoleId, GuildId, 0, 0, OldScene, PKStatus)
			end
	end,
	{ok, PS};

%%退出
do_handle(28304, #player_status{id = RoleId} = PS, []) ->
	case lib_scene:is_transferable_out(PS) of
		{true, _} ->
			mod_sanctuary:quit(RoleId);
		{false, Error} ->
			send_error(RoleId, Error)
	end,
	{ok, PS};


do_handle(28305, #player_status{id = RoleId} = PS, [SanctuaryId, BossId, Remind]) ->
	mod_sanctuary:remind(RoleId, SanctuaryId, BossId, Remind),
	{ok, PS};

%%公会排行榜
do_handle(28302, #player_status{id = RoleId, figure = Figure} = PS, []) ->
	mod_common_rank:send_guild_rank_list_for_sanctuary(RoleId, Figure#figure.guild_id),
	{ok, PS};

%%疲劳信息
do_handle(28308, #player_status{id = RoleId} = PS, []) ->
	#player_status{id = RoleId, status_boss = #status_boss{boss_map = TmpMap}} = PS,
	FatigueBuffTime = lib_sanctuary_mod:get_fatigue_buff_time(),
	ReviveGhostTime  = lib_sanctuary_mod:get_revive_ghost_time(),
	case data_sanctuary:get_kv(die_wait_time) of
		[{min_times, MinTimes},_,_]  -> skip;
		_ -> MinTimes = 0
	end,
	case maps:get(?BOSS_TYPE_SANCTUARY, TmpMap, []) of
		#role_boss{die_time = DieTime, die_times = DieTimes, next_enter_time = NextEnterTime} ->
			if
				DieTimes > MinTimes ->
					lib_server_send:send_to_uid(RoleId, pt_283, 28308, [DieTimes, NextEnterTime, DieTime + FatigueBuffTime, DieTime + ReviveGhostTime]);
				true ->
					lib_server_send:send_to_uid(RoleId, pt_283, 28308, [DieTimes, NextEnterTime, DieTime + FatigueBuffTime, 0])
			end;
		_ ->
			lib_server_send:send_to_uid(RoleId, pt_460, 28308, [0, 0, 0, 0])
	end,
	{ok, PS};

%%公会成员排行榜
do_handle(28310, #player_status{id = RoleId, guild = Guild} = PS, []) ->
	mod_sanctuary:get_guild_rank_info_with_guild_id(RoleId, Guild#status_guild.id),
	{ok, PS};

%%公会成员排行榜
do_handle(28312, #player_status{id = RoleId} = PS, [SanctuaryId]) ->
	mod_sanctuary:get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId),
	{ok, PS};

%%击杀记录
do_handle(28311, #player_status{id = RoleId} = PS, [SanctuaryId, BossId]) ->
	?MYLOG("cym", "SanctuaryId ~p, BossId ~p  28311+++++++++++++++~n", [SanctuaryId, BossId]),
	mod_sanctuary:get_mon_kill_info(RoleId, SanctuaryId, BossId),
	{ok, PS};

%%上一次结算信息
do_handle(28314, #player_status{id = RoleId, guild = Guild, sanctuary_role_in_ps = RoleSanctuary} = PS, []) ->
	case RoleSanctuary of
		#sanctuary_role_in_ps{person_rank = PersonRank, guild_rank = GuildIdRank} ->
			mod_sanctuary:get_last_settlement_msg(RoleId, Guild#status_guild.id, PersonRank, GuildIdRank);
		_ ->
%%			?MYLOG("cym", "28314++++++++++++ 0000", []),
			{ok, Bin} = pt_283:write(28314, [0, 0, 0, 0]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end,
	{ok, PS};

%%打开圣域界面
do_handle(28315, PS, []) ->
	mod_daily:increment_offline(PS#player_status.id, 283, 1),
	{ok, PS};

%%打开是否第一次登录
do_handle(28316, PS, []) ->
	OpenCount = mod_daily:get_count(PS#player_status.id, 283, 1), %% 打开圣域次数
	OpenDay = util:get_open_day(),
	if
		OpenDay =/= 2 -> %%除了第二天都是打开过
			{ok, Bin} = pt_283:write(28316, [1]);
		OpenCount == 0 -> %% 没打开过
			{ok, Bin} = pt_283:write(28316, [0]);
		OpenCount > 0 ->  %% 打开过
			{ok, Bin} = pt_283:write(28316, [1]);
		true ->
			{ok, Bin} = pt_283:write(28316, [1])
	end,
	lib_server_send:send_to_uid(PS#player_status.id, Bin),
	{ok, PS};

%%打开是否第一次登录
do_handle(28318, PS, []) ->
	TiredNum = mod_daily:get_count(PS#player_status.id, 283, ?sanctuary_boss_tired_daily_id), %% 打开圣域次数
	{ok, Bin} = pt_283:write(28318, [TiredNum]),
	lib_server_send:send_to_uid(PS#player_status.id, Bin),
	{ok, PS};

do_handle(_CMD, PS, _Args) ->
	{ok, PS}.