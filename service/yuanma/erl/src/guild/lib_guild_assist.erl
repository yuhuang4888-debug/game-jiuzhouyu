% %% ---------------------------------------------------------------------------
% %% @doc lib_guild_assist
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(lib_guild_assist).


-compile(export_all).
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("rec_assist.hrl").
-include("def_id_create.hrl").
-include("scene.hrl").
-include("boss.hrl").
-include("eudemons_land.hrl").
-include("decoration_boss.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("team.hrl").
-include("guild.hrl").
-include("dungeon.hrl").
-include("figure.hrl").
-include("supreme_vip.hrl").
-include("goods.hrl").
-include("sea_treasure.hrl").
-include("battle.hrl").
-include("enchantment_guard.hrl").

login(RoleId) ->
	case db:get_row(io_lib:format(?sql_select_role_assist, [RoleId])) of
		[AssistId, AskId, Type, SubType, CfgId, TId, AssistProcess, Extra, Stime] ->
			#{AssistId => #status_assist{
				assist_id = AssistId, ask_id = AskId, type = Type, sub_type = SubType, target_cfg_id = CfgId, target_id = TId,
				assist_process = AssistProcess, extra = util:bitstring_to_term(Extra), stime = Stime
			}};
		_ -> #{}
	end.

get_assist_id(PS) ->
	#player_status{guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId, assist_process = AssistProcess} = StatusAssist,
	case AssistProcess == 1 andalso AssistId > 0 of
		true -> AssistId; _ -> 0
	end.

update_bl_state(RoleId) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, update_bl_state, []);
update_bl_state(PS) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{
		assist_id = AssistId, ask_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId, assist_process = AssistProcess
	} = StatusAssist,
	case AssistId > 0 andalso AssistProcess == 1 of
		true ->
			NewBlState = get_bl_state(PS, Type, SubType, TargetCfgId),
			case AskId =/= RoleId of
				true -> % 协助者
					mod_guild_assist:update_bl_state([AssistId, RoleId, NewBlState]),
					{ok, PS};
				_ -> %% 请求者
					%%如果请求者打别的boss把体力用完了，取消协助
					case NewBlState == false of
						true ->
							{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
							{ok, NewPS};
						_ ->
							{ok, PS}
					end
			end;
		_ ->
			{ok, PS}
	end.

is_in_assist(PS) ->
	#player_status{id = _RoleId, guild_assist = StatusAssist, lunch_assist = LunchAssist} = PS,
	F = fun(#status_assist{assist_id = AssistId, assist_process = AssistProcess, stime = STime}) ->
		is_valid_assist(AssistId, AssistProcess, STime)
	end,
	case lists:any(F, [StatusAssist|maps:values(LunchAssist)]) of
		true -> true;
		_ -> false
	end.

is_in_lock_team_assist(PS) ->
	#player_status{id = _RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId, type = AssistType, ask_id = _AskId, assist_process = AssistProcess, stime = STime} = StatusAssist,
	IsValid = is_valid_assist(AssistId, AssistProcess, STime),
	case IsValid andalso (AssistType == ?ASSIST_TYPE_1 orelse AssistType == ?ASSIST_TYPE_2) of
		true -> true;
		_ -> false
	end.

is_assist_dungeon(PS, DunId) ->
	#player_status{guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId, type = Type, target_cfg_id= TargetCfgId, assist_process = AssistProcess, stime = STime} = StatusAssist,
	IsValid = is_valid_assist(AssistId, AssistProcess, STime),
	case IsValid andalso Type == ?ASSIST_TYPE_2 andalso TargetCfgId == DunId of
		true -> true;
		_ -> false
	end.

is_valid_assist(AssistId, AssistProcess, STime) ->
	case (AssistId > 0 andalso AssistProcess == 1) orelse
		(AssistId > 0 andalso AssistProcess == 0 andalso utime:unixtime() - STime < 5)
	of
		true -> true;
		_ -> false
	end.

logout(PS) ->
	PS1 = logout_cancel_normal_assist(PS),
	PS2 = logout_cancel_special_assist(PS1),
	PS2.

logout_cancel_normal_assist(PS) ->
	#player_status{guild_assist = StatusAssist} = PS,
	#status_assist{ assist_id = AssistId, assist_process = AssistProcess } = StatusAssist,
	case AssistId > 0 andalso AssistProcess == 1 of
		true ->
			{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
			NewPS;
		_ ->
			PS
	end.

logout_cancel_special_assist(PS) ->
	#player_status{id = RoleId} = PS,
	Type4AssistL = get_assist_4(PS),
	F_partition = fun(#status_assist{assist_id = AssistId, assist_process = Process, assister_info = AssisterInfo}) -> AssisterInfo == undefined andalso AssistId > 0 andalso Process == 1 end,
	{InDbAssistL, CancelAssistL} =
		lists:partition(F_partition, Type4AssistL),
	case InDbAssistL of
		[#status_assist{} = InDbAssist|_] ->
			db_replace_status_assist(RoleId, InDbAssist);
		_ -> skip
	end,
	lists:foldl(
		fun(#status_assist{assist_id = AssistId}, AccPS) ->
			{_, _, NewAccPS} = cancel_assist_do(AccPS, AssistId, 1),
			NewAccPS
		end,
		PS, CancelAssistL).

get_assist_4(PS) ->
	#player_status{lunch_assist = StatusAssistMap} = PS,
	lists:filter(fun(#status_assist{type = Type}) -> Type == ?ASSIST_TYPE_4 end, maps:values(StatusAssistMap)).

db_replace_status_assist(RoleId, StatusAssist) ->
	#status_assist{
		assist_id = AssistId, ask_id = AskId, type = Type, sub_type = SubType, target_cfg_id = CfgId, target_id = TId,
		assist_process = AssistProcess, extra = Extra, stime = Stime
	} = StatusAssist,
	NewExtra = util:fix_sql_str(Extra),
	Sql = io_lib:format(?sql_replace_role_assist, [RoleId, AssistId, AskId, Type, SubType, CfgId, TId, AssistProcess, NewExtra, Stime]),
	db:execute(Sql).

%% 离开场景，自动取消协助
change_scene(PS, EnterSceneId, LeaveSceneId) ->
	#player_status{id = _RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{
		assist_id = AssistId, ask_id = _AskId, assist_process = AssistProcess,
		type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
	} = StatusAssist,
	%% 3 4 类型在离开场景时不会取消协助
	IsAllowLeave = Type == ?ASSIST_TYPE_3 orelse Type == ?ASSIST_TYPE_4,
	case AssistId > 0 andalso AssistProcess == 1 andalso not IsAllowLeave of
		true ->
			%% 只要离开场景，都取消协助
            {AssistScene, _, _} = get_assist_scene(Type, SubType, TargetCfgId),
			case LeaveSceneId == AssistScene andalso EnterSceneId =/= AssistScene of
				true ->
					{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
					NewPS;
				_ ->
					PS
			end;
		_ ->
			PS
	end.

%% 离开队伍，自动取消协助
quit_team(PS, OldTeamId) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{
		assist_id = AssistId, ask_id = AskId, assist_process = AssistProcess,
		type = Type, extra = Extra
	} = StatusAssist,
	TeamId = maps:get(team_id, Extra, 0),
	IsLeave = TeamId == OldTeamId,
	case AssistId > 0 andalso AssistProcess == 1 andalso Type == ?ASSIST_TYPE_2 andalso IsLeave of
		true ->
			IsMyAssist = AskId == RoleId,
			?PRINT("quit_team#1 IsMyAssist:~p~n", [IsMyAssist]),
			case IsMyAssist of
				true -> %% 如果是求助者离开队伍，走通用流程
					{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
					NewPS;
				_ -> %% 如果是协助者，由于已经离开了队伍，这时直接删掉数据就可以
					mod_guild_assist:cancel_dungeon_assist(AssistId, RoleId, 1),
					PS
			end;
		_ ->
			PS
	end.

%% 离开副本
quit_dungeon(PS, DunId, DunType) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
    #status_assist{
    	assist_id = AssistId, assist_process = AssistProcess,
    	type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
    } = StatusAssist,
	IsSameDun = lists:member(TargetCfgId, lib_dungeon_util:list_special_share_dungeon(DunId)),
    case Type == ?ASSIST_TYPE_2 andalso AssistId > 0 andalso AssistProcess == 1 andalso SubType == DunType andalso IsSameDun of
    	true ->
    		?PRINT("quit_dungeon#1 start ~n", []),
    		mod_guild_assist:cancel_dungeon_assist(AssistId, RoleId, 1);
    	_ -> skip
    end,
    PS.

%% boss被击杀，发放协助奖励
boss_be_kill(_Minfo, BLWhos, AssistDataList) ->
	F = fun(AssistData) ->
		#assist_data{assist_id = AssistId, mon_atter = #mon_atter{node = Node}} = AssistData,
		unode:apply(Node, mod_guild_assist, boss_be_kill, [AssistId, BLWhos])
	end,
	lists:foreach(F, AssistDataList).

boss_be_hurt(MonAtter, _Klist, Hurt) ->
	#mon_atter{id = AtterId, node = Node, assist_id = AssistId, assist_ex_id = AssistExId} = MonAtter,
	% #mon_atter{hurt = OldHurt, assist_id = OldAssistId, assist_ex_id = OldAssistExId} =
	% 	ulists:keyfind(AtterId, #mon_atter.id, Klist, #mon_atter{}),
	case AssistId > 0 andalso AssistExId > 0 andalso AssistExId =/= AtterId of
		true ->
			%?PRINT("boss_be_hurt ##### AssistId, AtterId, Hurt : ~p~n", [{AssistId, AtterId, Hurt}]),
			unode:apply(Node, mod_guild_assist, boss_be_hurt, [AssistId, AtterId, Hurt]);
		_ ->
			skip
	end.

player_be_kill(Killer, BeKiller) ->
	#battle_return_atter{id = KillerId, guild_id = GuildId, assist_id = AssistId, node = Node} = Killer,
	case BeKiller#player_status.guild#status_guild.id =/= GuildId andalso AssistId =/= 0 of
		true ->
			mod_clusters_node:apply_cast(unode, apply, [Node, mod_guild_assist, player_be_kill, [AssistId, KillerId]]);
%%			unode:apply(Node, mod_guild_assist, player_be_kill, [AssistId, KillerId]);
		false -> skip
	end.

rback_resoult(PS, AutoId, Res, Reward, Rober) ->
    #player_status{id = RoleId, guild_assist = StatusAssist} = PS,
    #status_assist{
        assist_id = AssistId, assist_process = AssistProcess,
        type = Type, target_id = TargetId
    } = StatusAssist,
    case Type == ?ASSIST_TYPE_3 andalso AssistId > 0 andalso AssistProcess == 1 andalso TargetId == AutoId of
        true ->
            if
                Res == 1 -> %% 协助成功
                    mod_guild_assist:rback_resoult(RoleId, AssistId, 1, Rober, Reward);
                true ->
                    mod_guild_assist:rback_resoult(RoleId, AssistId, 2, Rober, Reward)
            end;
        _ -> skip
    end,
    {ok, PS}.

%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
    #status_assist{
    	assist_id = AssistId, assist_process = AssistProcess, ask_id = AskId,
    	type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
    } = StatusAssist,
    #callback_dungeon_succ{dun_id = DunId, dun_type = DunType} = Data,
	IsSameDun = lists:member(TargetCfgId, lib_dungeon_util:list_special_share_dungeon(DunId)),
    case Type == ?ASSIST_TYPE_2 andalso AssistId > 0 andalso AssistProcess == 1 andalso SubType == DunType andalso IsSameDun of
    	true ->
    		%?PRINT("EVENT_DUNGEON_SUCCESS#1 RoleId == AskId:~p~n", [RoleId == AskId]),
    		case RoleId == AskId of
    			true ->
    				mod_guild_assist:dungeon_end(AssistId, 1);
    			_ -> skip
    		end;
    	_ -> skip
    end,
    {ok, PS};
%% 副本失败
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_FAIL, data = Data}) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
    #status_assist{
    	assist_id = AssistId, assist_process = AssistProcess, ask_id = AskId,
    	type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
    } = StatusAssist,
    #callback_dungeon_fail{dun_id = DunId, dun_type = DunType} = Data,
	IsSameDun = lists:member(TargetCfgId, lib_dungeon_util:list_special_share_dungeon(DunId)),
    case Type == ?ASSIST_TYPE_2 andalso AssistId > 0 andalso AssistProcess == 1 andalso SubType == DunType andalso IsSameDun of
    	true ->
    		%?PRINT("EVENT_DUNGEON_FAIL#1 RoleId == AskId:~p~n", [RoleId == AskId]),
    		case RoleId == AskId of
    			true ->
    				mod_guild_assist:dungeon_end(AssistId, 2);
    			_ -> skip
    		end;
    	_ -> skip
    end,
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
	#player_status{id = RoleId} = PS,
	Assist4List = get_assist_4(PS),
	F = fun(Assist, AccPlayer) ->
		#player_status{lunch_assist = StatusAssistMap} = AccPlayer,
		case Assist of
			#status_assist{assister_info = undefined, type = ?ASSIST_TYPE_4, assist_id = AssistId} ->
				case mod_guild_assist:get_launch_assist(AssistId) of
					{ok, #launch_assist{assister_list = [#assister{role_id = AssisterId}]}} ->
						RoleInfo = lib_faker:create_faker_by_role(AssisterId),
						NewAssist = Assist#status_assist{assister_info = RoleInfo},
						AccPlayer#player_status{lunch_assist = StatusAssistMap#{AssistId => NewAssist}};
					_E ->
						mod_guild_assist:del_assist_by_id(AssistId),
						db:execute(io_lib:format(?sql_delete_role_assist, [RoleId])),
						AccPlayer#player_status{lunch_assist = maps:remove(AssistId, StatusAssistMap)}
				end;
			_ ->
				AccPlayer
		end
	end,
	NewPS = lists:foldl(F, PS, Assist4List),
	{ok, NewPS};
handle_event(PS, _) ->
	{ok, PS}.

%% 广播刷新协助列表
broadcast_refresh_assist() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, lib_guild_assist, broadcast_refresh_assist_ps, []) || E <- OnlineRoles].

broadcast_refresh_assist_ps(Ps) ->
	pp_guild_assist:handle(40405, Ps, []).

%% 秘籍取消
gm_cancel_assist(PS) ->
	#player_status{id = _RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{
		assist_id = AssistId, assist_process = AssistProcess
	} = StatusAssist,
	case AssistId > 0 andalso AssistProcess == 1 of
		true ->
			{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
			NewPS;
		_ ->
			PS
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 发起协助 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
launch_assist(PS, Type, SubType, TargetCfgId, TargetId) ->
	AssistCfg = data_guild_assist:get_assist_cfg(Type, SubType),
	CheckList = [
		{check_cfg, PS, AssistCfg},
		{check_lv, PS, Type},
		{check_had_assist_other, PS},
		{check_launch_conditon, PS, AssistCfg, TargetCfgId},
		{check_target_cfg, PS, AssistCfg, TargetCfgId, TargetId},
        {check_has_lunch, PS, Type, TargetId},
		{check_enchantment_guard, PS, Type, TargetCfgId}
	],
	case check_list(CheckList) of
		true ->
			case AssistCfg#base_guild_assist.type of
				?ASSIST_TYPE_1 -> %% boss
					launch_boss_assist(PS, AssistCfg, TargetCfgId, TargetId);
				?ASSIST_TYPE_2 -> %% 副本
					launch_dungeon_assist(PS, AssistCfg, TargetCfgId, TargetId);
                ?ASSIST_TYPE_3 ->
                    Args = [AssistCfg],
                    mod_sea_treasure_local:launch_sea_treasure_assist(PS#player_status.id, Args, TargetId),
                    {ok, PS};
				?ASSIST_TYPE_4 ->
					launch_enchantment_guard_assist(PS, AssistCfg, TargetCfgId, TargetId);
                _ -> {ok, PS}
			end;
		Res ->
			Res
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 发起boss协助
launch_boss_assist(PS, AssistCfg, TargetCfgId, TargetId) ->
	#player_status{id = RoleId, scene = Scene, scene_pool_id = ScenePoolId, copy_id = _CopyId} = PS,
	#base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
	AssistId = mod_id_create:get_new_id(?ASSIST_ID_CREATE),
	AssistData = make_assist_data(PS, AssistId),
	Args = [Type, SubType, TargetCfgId, TargetId, AssistData],
	mod_scene_agent:apply_cast(Scene, ScenePoolId, ?MODULE, launch_boss_assist_in_scene, Args),
	StatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, 0, make_extra_data(PS, Type, [])),
	?PRINT("launch_boss_assist##1 AssistId:~p~n", [AssistId]),
	{ok, PS#player_status{guild_assist = StatusAssist}}.

launch_boss_assist_in_scene(Type, SubType, TargetCfgId, TargetId, AssistData) ->
	case lib_scene_object_agent:get_object(TargetId) of
        #scene_object{config_id = TargetCfgId, aid = Aid} ->
        	Aid ! {'change_attr', [{add_assist, AssistData}]},
        	#assist_data{assist_id = AssistId, mon_atter = #mon_atter{id = RoleId, node = Node}} = AssistData,
        	unode:apply(Node, ?MODULE, launch_boss_assist_result, [RoleId, 1, AssistId, Type, SubType, TargetCfgId, TargetId]);
        _ ->
        	#assist_data{assist_id = AssistId, mon_atter = #mon_atter{id = RoleId, node = Node}} = AssistData,
        	unode:apply(Node, ?MODULE, launch_boss_assist_result, [RoleId, ?ERRCODE(err404_no_target), AssistId, Type, SubType, TargetCfgId, TargetId])
    end.

launch_boss_assist_result(RoleId, Code, AssistId, Type, SubType, TargetCfgId, TargetId) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, launch_boss_assist_result, [Code, AssistId, Type, SubType, TargetCfgId, TargetId]);
launch_boss_assist_result(PS, Code, AssistId, Type, SubType, TargetCfgId, TargetId) ->
	#player_status{id = RoleId, sid = Sid, scene = Scene, scene_pool_id = ScenePoolId, guild_assist = StatusAssist, guild = #status_guild{id = GuildId}} = PS,
	#status_assist{assist_id = MyAssistId, assist_process = AssistProcess} = StatusAssist,
	lib_server_send:send_to_sid(Sid, pt_404, 40401, [Code, AssistId, Type, SubType, TargetCfgId, TargetId]),
	IsSameAssist = (AssistId == MyAssistId andalso AssistProcess == 0),
	?PRINT("launch_boss_assist##2 {Code, IsSameAssist}:~p~n", [{Code, IsSameAssist}]),
	if
	 	Code == 1 andalso IsSameAssist == true ->
			LaunchAssist = make_launch_assist(PS, AssistId, Type, SubType, TargetCfgId, TargetId, []),
			NewStatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, LaunchAssist#launch_assist.extra),
			case mod_guild_assist:add_new_assist(LaunchAssist) of
				ok ->
					lib_log_api:log_launch_guild_assist(AssistId, RoleId, Type, SubType, TargetCfgId),
					%% 更新场景玩家的协助id
					mod_scene_agent:update(PS, [{assist_id, AssistId}]),
					%% 更新怪物进程中，玩家伤害列表的信息
					MonMsg = {'assist_change', AssistId, [{RoleId, true}]},
					lib_mon:send_msg_to_mon_by_id(Scene, ScenePoolId, TargetId, MonMsg),
					%% 公会广播新协助
					broadcast_new_assist(GuildId, RoleId, LaunchAssist),
					?PRINT("launch_boss_assist##3 succ~n", []),
					{ok, PS#player_status{guild_assist = NewStatusAssist}};
				_ ->
					{ok, PS#player_status{guild_assist = #status_assist{}}}
			end;
		Code == 1 -> %% 已经不是同一个协助，不处理
			{ok, PS};
		true ->
			{ok, PS#player_status{guild_assist = #status_assist{}}}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 发起副本协助
launch_dungeon_assist(PS, AssistCfg, TargetCfgId, TargetId) ->
	%% 到组队进程判断组队的状态，看能不能发起协助
	#player_status{id = RoleId, team = #status_team{team_id = TeamId}} = PS,
	#base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
	AssistId = mod_id_create:get_new_id(?ASSIST_ID_CREATE),
	StatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, 0, make_extra_data(PS, Type, [0, 0])),
	Args = [RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, node()],
	Msg = {'apply_cast', ?MODULE, launch_assist_in_team, Args},
	mod_team:cast_to_team(TeamId, Msg),
	?PRINT("launch_dungeon_assist#1 AssistId:~p ~n", [AssistId]),
	{ok, PS#player_status{guild_assist = StatusAssist}}.

launch_assist_in_team(TeamState, RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, Node) ->
	#team{
        id = _TeamId,
        free_location = FreeLocation,
        member = Members,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubActivityId, dun_id = DunId}
    } = TeamState,
    IsOnDungeon = lib_team_mod:is_on_dungeon(TeamState),
    Mb = lists:keyfind(RoleId, #mb.id, Members),
    MbFlag = ?IF(is_record(Mb, mb), ?IF(Mb#mb.help_type == ?HELP_TYPE_NO, 1, 2), 3),
    if
		% 众生之门特殊处理下
     	DunId =/= TargetCfgId, SubType =/= ?DUNGEON_TYPE_BEINGS_GATE ->
     		Code = ?ERRCODE(err404_param_err);
     	FreeLocation == [] ->
     		Code = ?ERRCODE(err240_max_member);
     	IsOnDungeon ->
     		Code = ?ERRCODE(err240_this_team_on_dungeon);
     	MbFlag == 2 ->
     		Code = ?ERRCODE(err404_cannt_assist_type);
     	MbFlag == 3 ->
     		Code = ?ERRCODE(err240_not_on_team);
    	true ->
    		Code = 1
    end,
    Args = [Code, AssistId, Type, SubType, TargetCfgId, TargetId, ActivityId, SubActivityId],
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, launch_team_assist_result, Args),
    TeamState.

launch_team_assist_result(PS, Code, AssistId, Type, SubType, TargetCfgId, TargetId, ActivityId, SubActivityId) ->
	#player_status{id = RoleId, sid = Sid, guild_assist = StatusAssist, guild = #status_guild{id = GuildId}} = PS,
	#status_assist{assist_id = MyAssistId, assist_process = AssistProcess} = StatusAssist,
	lib_server_send:send_to_sid(Sid, pt_404, 40401, [Code, AssistId, Type, SubType, TargetCfgId, TargetId]),
	IsSameAssist = (AssistId == MyAssistId andalso AssistProcess == 0),
	?PRINT("launch_team_assist_result#3 {IsSameAssist, Code} :~p~n", [{IsSameAssist, Code}]),
	if
		Code == 1 andalso IsSameAssist == true ->
			LaunchAssist = make_launch_assist(PS, AssistId, Type, SubType, TargetCfgId, TargetId, [ActivityId, SubActivityId]),
			NewStatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, LaunchAssist#launch_assist.extra),
			case mod_guild_assist:add_new_assist(LaunchAssist) of
				ok ->
					lib_log_api:log_launch_guild_assist(AssistId, RoleId, Type, SubType, TargetCfgId),
					%% 公会广播新协助
					broadcast_new_assist(GuildId, RoleId, LaunchAssist),
					?PRINT("launch_team_assist_result#3 succ ~n", []),
					{ok, PS#player_status{guild_assist = NewStatusAssist}};
				_ ->
					{ok, PS#player_status{guild_assist = #status_assist{}}}
			end;
		Code == 1 ->
			{ok, PS};
		true ->
			{ok, PS#player_status{guild_assist = #status_assist{}}}
	end.

%%=================================== 璀璨之星协助 =========================================================
launch_sea_treasure_assist(PS, AssistCfg, TargetCfgId, TargetId, Args) ->
    #player_status{
        id = RoleId, sid = Sid, guild = #status_guild{id = GuildId},
        guild_assist = OldStatusAssist, lunch_assist = LunchMap
    } = PS,
    #base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
    AssistId = mod_id_create:get_new_id(?ASSIST_ID_CREATE),
    lib_server_send:send_to_sid(Sid, pt_404, 40401, [1, AssistId, Type, SubType, TargetCfgId, TargetId]),
    LaunchAssist = make_launch_assist(PS, AssistId, Type, SubType, TargetCfgId, TargetId, Args),
    StatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId,
        TargetId, 1, LaunchAssist#launch_assist.extra),
    if
        is_record(OldStatusAssist, status_assist) ->
            NewStatusAssist = OldStatusAssist;
        true ->
            NewStatusAssist = #status_assist{}
    end,
    case mod_guild_assist:add_new_assist(LaunchAssist) of
        ok ->
            lib_log_api:log_launch_guild_assist(AssistId, RoleId, Type, SubType, TargetCfgId),
            %% 公会广播新协助
            broadcast_new_assist(GuildId, RoleId, LaunchAssist),
            ?PRINT("launch_sea_treasure_assist#3 succ ~n", []),
            NewLunchMap = maps:put(AssistId, StatusAssist, LunchMap),
            {ok, PS#player_status{guild_assist = NewStatusAssist, lunch_assist = NewLunchMap}};
        _ ->
            ?PRINT("launch_sea_treasure_assist#3 fail ~n", []),
            {ok, PS#player_status{guild_assist = NewStatusAssist, lunch_assist = LunchMap}}
    end.

%%=================================== 主线本协助 =========================================================
launch_enchantment_guard_assist(PS, AssistCfg, TargetCfgId, TargetId) ->
	#player_status{id = RoleId, guild = #status_guild{id = GuildId}, enchantment_guard = EnchGuard, figure = Figure, lunch_assist = LunchMap} = PS,
	#base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
	AssistId = mod_id_create:get_new_id(?ASSIST_ID_CREATE),
	LaunchAssist = make_launch_assist(PS, AssistId, Type, SubType, TargetCfgId, TargetId, []),
	NewStatusAssist = make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, LaunchAssist#launch_assist.extra),
	?PRINT("launch_enchantment_guard_assist AssistId ~p ~n", [AssistId]),
	case mod_guild_assist:add_new_assist(LaunchAssist) of
		ok ->
			lib_log_api:log_launch_guild_assist(AssistId, RoleId, Type, SubType, TargetCfgId),
			%% 公会广播新协助
			broadcast_new_assist(GuildId, RoleId, LaunchAssist),
			?PRINT("launch_enchantment_guard_assist##4 succ~n", []),
			%% 传闻
			lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_GUILD_ASSIST, 5, ["", TargetCfgId]),
			[CD] = data_enchantment_guard:get_value_by_key(3),
			NewEnchGuard = EnchGuard#enchantment_guard{next_assist_time = utime:unixtime() + CD},
			NewPS = PS#player_status{enchantment_guard = NewEnchGuard, lunch_assist = LunchMap#{AssistId => NewStatusAssist}},
			pp_enchantment_guard:handle(13300, NewPS, []),
			pp_enchantment_guard:handle(13324, NewPS, []),
			{ok, NewPS};
		_ ->
			{ok, PS}
	end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 协助玩家 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assist_player(PS, AssistId) ->
	case catch mod_guild_assist:get_launch_assist(AssistId) of
		{ok, LaunchAssist} ->
			#status_assist{type = OldAssistType, assist_id = OldAssistId} = PS#player_status.guild_assist,
			%% 璀璨之海有个Bug未发现临时处理
			case OldAssistId =/= 0 andalso OldAssistType == ?ASSIST_TYPE_3 of
				true -> {NewPS, _} = cancel_assist_do_core(PS, LaunchAssist, 1);
				_ -> NewPS = PS
			end,
			CheckList = [
				{check_had_assist_other, NewPS},
				{check_lv, NewPS, LaunchAssist#launch_assist.type},
				{assist_base_check, NewPS, LaunchAssist}
			],
			case check_list(CheckList) of
				true ->
					do_assist_player(NewPS, LaunchAssist);
				{false, Res} ->
					{false, Res, NewPS}
			end;
		false ->
			{false, ?ERRCODE(err404_no_launch_assist), PS};
		_Err ->
			?ERR("check_boss_target_cfg : Err : ~p~n", [_Err]),
			{false, ?ERRCODE(system_busy), PS}
	end.

do_assist_player(PS, LaunchAssist) ->
	case LaunchAssist#launch_assist.type of
		?ASSIST_TYPE_1 -> %% boss
			assist_player_boss(PS, LaunchAssist);
		?ASSIST_TYPE_2 -> %% 副本
			assist_player_dungeon(PS, LaunchAssist);
		?ASSIST_TYPE_3 -> %% 璀璨之星
			assist_player_sea_treasure(PS, LaunchAssist);
		?ASSIST_TYPE_4 -> %% 主线本
			assist_player_enchantment_guard(PS, LaunchAssist)
	end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% boss协助
assist_player_boss(PS, LaunchAssist) ->
	#player_status{id = RoleId, sid = Sid, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId, figure = #figure{name = Name}} = PS,
	#launch_assist{
		assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId,
		target_id = TargetId, extra = Extra
	} = LaunchAssist,
	[TarScene, TarScenePoolId, TarCopyId] = maps:get(scene, Extra, [0,0,0]),
	IsInScene = (TarScene == Scene andalso ScenePoolId == TarScenePoolId andalso TarCopyId == CopyId),
	case IsInScene of
		true -> %% 已经在boss场景里
			case SubType of
				?BOSS_TYPE_DECORATION_BOSS -> %% 幻饰boss
					%% 已经通过正常途径进入幻饰boss，不能进行协助
					{false, ?ERRCODE(err404_cannt_assist_in_decoration_boss), PS};
				_ -> %% 世界boss和圣兽领
					BlState = get_bl_state(PS, Type, SubType, TargetCfgId),
					Assister = make_assister(PS, AssistId, BlState, 0),
					case mod_guild_assist:add_assister(Assister) of
						ok ->
							lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, ?IF(BlState, 1, 0), 0, utime:unixtime()]]),
							%% 更新场景玩家的协助id
							mod_scene_agent:update(PS, [{assist_id, AssistId}]),
							%% 更新怪物进程中，玩家伤害列表的信息
							MonMsg = {'assist_change', AssistId, [{RoleId, BlState}]},
							lib_mon:send_msg_to_mon_by_id(TarScene, TarScenePoolId, TargetId, MonMsg),
							StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, Extra),
							%?PRINT("assist_player_boss#1 StatusAssist ~p ~n", [StatusAssist]),
							lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
							lib_server_send:send_to_uid(AskId, pt_404, 40410, [AssistId, RoleId, Name]),
							{ok, PS#player_status{guild_assist = StatusAssist}};
						_ ->
							{false, ?FAIL, PS#player_status{guild_assist = #status_assist{}}}
					end
			end;
		_ ->
			case enter_boss(PS, SubType, TargetCfgId) of
				{ok, NewPS} ->
					StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 0, Extra),
					InputParam = #{launch_assist => LaunchAssist},
					lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, assist_player_boss_next, InputParam),
					{ok, NewPS#player_status{guild_assist = StatusAssist}};
				_ ->
					{false, ?ERRCODE(err404_assist_fail), PS}
			end
	end.

assist_player_boss_next(PS, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE, param = Param}) ->
	#player_status{
		id = RoleId, sid = Sid, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId, guild_assist = StatusAssist,
		figure = #figure{name = Name}, team = #status_team{team_id = TeamId}
	} = PS,
	#status_assist{assist_id = MyAssistId, assist_process = AssistProcess} = StatusAssist,
	lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, assist_player_boss_next),
	case maps:get(launch_assist, Param, 0) of
		#launch_assist{assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId, extra = Extra} ->
			[TarScene, TarScenePoolId, TarCopyId] = maps:get(scene, Extra, [0, 0, 0]),
			IsInScene = (TarScene == Scene andalso ScenePoolId == TarScenePoolId andalso TarCopyId == CopyId),
			IsSameAssist = (AssistId == MyAssistId),
			?PRINT("assist_player_boss_next#2 {IsInScene, IsSameAssist} ~p~n", [{IsInScene, IsSameAssist}]),
			case IsInScene andalso IsSameAssist of
				true when AssistProcess == 0 andalso TeamId == 0 -> %% 成功进入boss场景,协助成功
					BlState = get_bl_state(PS, Type, SubType, TargetCfgId),
					Assister = make_assister(PS, AssistId, BlState, 0),
					case mod_guild_assist:add_assister(Assister) of
						ok ->
							lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, ?IF(BlState, 1, 0), 0, utime:unixtime()]]),
							NewStatusAssist = StatusAssist#status_assist{assist_process = 1},
							%% 更新场景玩家的协助id
							mod_scene_agent:update(PS, [{assist_id, AssistId}]),
							%?PRINT("assist_player_boss_next#2 succ ~p~n", [NewStatusAssist]),
							lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
							lib_server_send:send_to_uid(AskId, pt_404, 40410, [AssistId, RoleId, Name]),
							{ok, PS#player_status{guild_assist = NewStatusAssist}};
						_ ->
							{ok, PS#player_status{guild_assist = #status_assist{}}}
					end;
				true when TeamId > 0 -> %% 加载期间加入了队伍
					lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_please_leave_team), AssistId, Type]),
					{ok, PS#player_status{guild_assist = #status_assist{}}};
				true ->
					{ok, PS};
				_ -> %% 在切场景和加载场景期间，发起了其他协助，有可能导致加载场景前后是不同的协助，这个时候掉取消协助
					lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_please_assist_again), AssistId, Type]),
					NewPS = assist_player_boss_fail(PS),
					{ok, NewPS}
			end;
		_ -> %% 不处理,应该不会走这个分支，如果出现，直接取消协助
			NewPS = assist_player_boss_fail(PS),
			{ok, NewPS}
	end.

assist_player_boss_fail(PS) ->
	#player_status{guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId, assist_process = AssistProcess} = StatusAssist,
	case AssistId > 0 andalso AssistProcess == 1 of
		true ->
			{_, _, NewPS} = cancel_assist_do(PS, AssistId, 1),
			NewPS;
		_ ->
			PS#player_status{guild_assist = #status_assist{}}
	end.

enter_boss(PS, ?BOSS_TYPE_NEW_OUTSIDE, TargetCfgId) ->
	case pp_boss:handle(46003, PS, [?BOSS_TYPE_NEW_OUTSIDE, TargetCfgId]) of
		{ok, NewPS} -> {ok, NewPS};
		_ -> false
	end;
enter_boss(PS, ?BOSS_TYPE_PHANTOM, TargetCfgId) ->
	pp_eudemons_land:handle(47003, PS, [?BOSS_TYPE_EUDEMONS, TargetCfgId]),
	{ok, PS};
enter_boss(PS, ?BOSS_TYPE_DECORATION_BOSS, TargetCfgId) ->
	#player_status{id = RoleId, server_id = ServerId} = PS,
	case lib_decoration_boss_api:is_sboss_id(TargetCfgId) of
		false ->
    		mod_decoration_boss_local:check_and_enter_boss(RoleId, ServerId, TargetCfgId, ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST);
    	_ ->
    		mod_decoration_boss_center:cast_center([{'check_and_enter_sboss', RoleId, ServerId, ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST}])
    end,
    {ok, PS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 副本协助
assist_player_dungeon(PS, LaunchAssist) ->
	#player_status{
		id = RoleId, sid = Sid, scene = Scene, copy_id = CopyId, x = X, y = Y,
		team = #status_team{team_id = TeamId}
	} = PS,
	#launch_assist{
		assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId,
		target_id = TargetId, extra = Extra
	} = LaunchAssist,
	AssistTeamId = maps:get(team_id, Extra, 0),
	IsInTeam = AssistTeamId == TeamId,
	case IsInTeam of
		true -> %% 已经在队伍中
			OHelpType = lib_dungeon_team:get_help_type(PS, TargetCfgId),
			Assister = make_assister(PS, AssistId, true, OHelpType),
			case mod_guild_assist:add_assister(Assister) of
				ok ->
					lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, OHelpType, 0, utime:unixtime()]]),
					%% 更新一下助战标志
					{ok, PS1} = lib_team:set_help_type(PS, TargetCfgId, ?HELP_TYPE_ASSIST),
					StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, Extra),
					%?PRINT("assist_player_dungeon#1 in_team succ ~n", []),
					lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
					{ok, PS1#player_status{guild_assist = StatusAssist}};
				_ ->
					{false, ?FAIL, PS#player_status{guild_assist = #status_assist{}}}
			end;
		_ -> %% 不在队伍中，入队
			MbInfo = lib_team_api:thing_to_mb(PS),
			Node = node(),
			Args = [Scene, CopyId, X, Y, {mfa, {?MODULE, assist_player_dungeon_result, [Node, RoleId, LaunchAssist]}}],
			case mod_team:cast_to_team(AssistTeamId,  {'invite_response', 1, MbInfo, Args}) of
                false ->
                	{false, ?ERRCODE(err240_team_disappear), PS};
                _ ->
                	StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 0, Extra),
                	{ok, PS#player_status{guild_assist = StatusAssist}}
            end
	end.

assist_player_dungeon_result(Code, Node, RoleId, LaunchAssist) ->
	lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, assist_player_dungeon_result, [Code, LaunchAssist]).

assist_player_dungeon_result(PS, Code, LaunchAssist) ->
	#player_status{id = RoleId, sid = Sid, guild_assist = StatusAssist, team = #status_team{team_id = MyTeamId}} = PS,
	#launch_assist{type = Type, assist_id = AssistId, role_id = AskId, target_cfg_id = TargetCfgId, extra = Extra} = LaunchAssist,
	#status_assist{assist_id = MyAssistId, assist_process = AssistProcess} = StatusAssist,
	lib_server_send:send_to_sid(Sid, pt_404, 40402, [Code, AssistId, Type]),
	IsSameAssist = (AssistId == MyAssistId andalso AssistProcess == 0),
	IsSameTeam = (MyTeamId == maps:get(team_id, Extra, 0)),
	?PRINT("assist_player_dungeon_result#3 {IsSameAssist, IsSameTeam, Code} ~p~n", [{IsSameAssist, IsSameTeam, Code}]),
	if
	 	Code == 1 andalso IsSameAssist == true andalso IsSameTeam == true ->
			OHelpType = lib_dungeon_team:get_help_type(PS, TargetCfgId),
			Assister = make_assister(PS, AssistId, true, OHelpType),
			case mod_guild_assist:add_assister(Assister) of
				ok ->
					lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, OHelpType, 0, utime:unixtime()]]),
					{ok, PS1} = lib_team:set_help_type(PS, TargetCfgId, ?HELP_TYPE_ASSIST),
					NewStatusAssist = StatusAssist#status_assist{assist_process = 1},
					?PRINT("assist_player_dungeon_result#3 succ ~n", []),
					%lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
					{ok, PS1#player_status{guild_assist = NewStatusAssist}};
				_ ->
					{ok, PS#player_status{guild_assist = #status_assist{}}}
			end;
		Code == 1 andalso IsSameAssist -> %% 入队失败
			lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_enter_team_fail), AssistId, Type]),
			{ok, PS#player_status{guild_assist = #status_assist{}}};
		Code == 1 -> %% 不是同一个协助
			lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_please_assist_again), AssistId, Type]),
			{ok, PS#player_status{guild_assist = #status_assist{}}};
		true ->
			case Code == ?ERRCODE(err240_team_disappear) of
				true -> %% 队伍消失掉，取消整个协助
					mod_guild_assist:cancel_dungeon_assist(AssistId, AskId, 1);
				_ ->
					skip
			end,
			{ok, PS#player_status{guild_assist = #status_assist{}}}
	end.

%%================================== 璀璨之星协助 ==============================================
assist_player_sea_treasure(PS, LaunchAssist) ->
    #player_status{scene = Scene} = PS,
    #launch_assist{
        assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId,
        target_id = TargetId, extra = Extra, figure = #figure{lv = Lv}
    } = LaunchAssist,
    IsInScene = (Scene == ?local_battle_scene orelse Scene == ?cluster_mod_battle_scene),
    List = [{open_lv, Lv}, {open_day, util:get_open_day()}],
    case lib_sea_treasure:check(List) of
        true when IsInScene == false ->
            [AutoId, ShipSerId, ShipRoleId|_] = maps:get(ship_info, Extra, [0,0,0,0]),
            %% 协助
            case pp_sea_treasure:do_assist_player(PS, AutoId, ShipSerId, ShipRoleId, ?BATTLE_TYPE_RBACK, AssistId) of
                {ok, NewPS} ->
                    InputParam = #{launch_assist => LaunchAssist},
                    lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, assist_player_sea_treasure_next, InputParam),
                    StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 0, Extra),
                    {ok, NewPS#player_status{guild_assist = StatusAssist}};
                {false, ECode} ->
                    {false, ECode, PS}
            end;
        _ when IsInScene == true ->
            {false, ?ERRCODE(err189_already_in_scene), PS};
        {false, Code} ->
            {false, Code, PS}
    end.

assist_player_sea_treasure_next(PS, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE, param = Param}) ->
    #player_status{
        id = RoleId, sid = Sid, scene = Scene, scene_pool_id = _ScenePoolId, copy_id = CopyId, guild_assist = StatusAssist,
        figure = #figure{name = Name}, team = #status_team{team_id = TeamId}
    } = PS,
    #status_assist{type = Type, assist_id = MyAssistId, assist_process = AssistProcess} = StatusAssist,
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, assist_player_sea_treasure_next),
    case maps:get(launch_assist, Param, 0) of
        #launch_assist{assist_id = AssistId, role_id = AskId, extra = Extra} ->
            [_AutoId, _ShipSerId, _ShipRoleId, TarScene|_] = maps:get(ship_info, Extra, [0,0,0,0]),
            IsInScene = (TarScene == Scene andalso CopyId == RoleId),
            IsSameAssist = (AssistId == MyAssistId),
            case IsInScene andalso IsSameAssist of
                true when AssistProcess == 0 andalso TeamId == 0 ->
                    Assister = make_assister(PS, AssistId, true, 0),
                    case mod_guild_assist:add_assister(Assister) of
                        ok ->
                            lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, 0, 0, utime:unixtime()]]),
                            NewStatusAssist = StatusAssist#status_assist{assist_process = 1},
                            lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
                            lib_server_send:send_to_uid(AskId, pt_404, 40410, [AssistId, RoleId, Name]),
                            {ok, PS#player_status{guild_assist = NewStatusAssist}};
                        _ ->
                            {ok, PS#player_status{guild_assist = #status_assist{}}}
                    end;
                true when TeamId > 0 -> %% 加载期间加入了队伍
                    lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_please_leave_team), AssistId, Type]),
                    {ok, PS#player_status{guild_assist = #status_assist{}}};
                true ->
                    {ok, PS};
                _ -> %% 在切场景和加载场景期间，发起了其他协助，有可能导致加载场景前后是不同的协助，这个时候掉取消协助
                    lib_server_send:send_to_sid(Sid, pt_404, 40402, [?ERRCODE(err404_please_assist_again), AssistId, Type]),
                    NewPS = assist_player_boss_fail(PS),
                    {ok, NewPS}
            end;
        _ -> %% 不处理,应该不会走这个分支，如果出现，直接取消协助
            NewPS = assist_player_boss_fail(PS),
            {ok, NewPS}
    end.

%%================================== 主线本协助 ==============================================
assist_player_enchantment_guard(PS, LaunchAssist) ->
	#player_status{id = RoleId, sid = Sid, figure = #figure{name = Name} = SelfFigure, guild = #status_guild{id = GuildId}} = PS,
	#launch_assist{
		assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = _TargetCfgId,
		target_id = _TargetId, extra = _Extra, figure = #figure{name = AskName}
	} = LaunchAssist,
	Assister = make_assister(PS, AssistId, true, 0),
	RoleInfo = lib_faker:create_faker_by_role(PS),
	NewAssister = Assister#assister{role_info = RoleInfo},
	case mod_guild_assist:add_assister(NewAssister) of
		ok ->
			lib_log_api:log_guild_assist_operation([[RoleId, AssistId, 1, 1, 0, utime:unixtime()]]),
			%StatusAssist = make_status_assist(AskId, AssistId, Type, SubType, TargetCfgId, TargetId, 1, Extra),
			lib_server_send:send_to_sid(Sid, pt_404, 40402, [?SUCCESS, AssistId, Type]),
			lib_server_send:send_to_uid(AskId, pt_404, 40410, [AssistId, RoleId, Name]),
			lib_chat:send_TV({guild, GuildId}, RoleId, SelfFigure, ?MOD_GUILD_ASSIST, 6, [AskName]),
			%% 直接发奖励了
			#base_guild_assist{rewards = Rewards} = data_guild_assist:get_assist_cfg(Type, SubType),
			lib_guild_assist:send_assist_reward([RoleId], Rewards),
			{ok, PS#player_status{guild_assist = #status_assist{}}};
		{false, Errcode} ->
			?PRINT("Errcode ~p ~n", [Errcode]),
			{false, Errcode, PS#player_status{guild_assist = #status_assist{}}};
		_E ->
			?PRINT("_E ~p ~n", [_E]),
			{false, ?FAIL, PS#player_status{guild_assist = #status_assist{}}}
	end.

%% 有人协助之后，回调到发起协助者进程身上，保存信息，用于创建镜像假人
add_assister_enchantment_guard_back(PS, AssistId, AssisterRoleInfo) ->
	#player_status{lunch_assist = AssistStatusMap} = PS,
	StatusAssist = maps:get(AssistId, AssistStatusMap, #status_assist{}),
	case StatusAssist of
		#status_assist{assist_id = AssistId} when AssistId =/= 0 ->
			NewStatusAssist = StatusAssist#status_assist{assister_info = AssisterRoleInfo};
		_ ->
			NewStatusAssist = StatusAssist
	end,
	NewPS = PS#player_status{lunch_assist = AssistStatusMap#{AssistId => NewStatusAssist}},
	pp_enchantment_guard:handle(13300, NewPS, []),
	NewPS.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 取消协助
cancel_sea_assist(PS) ->
	#player_status{id = RoleId, guild_assist = #status_assist{type = Type, assist_id = AssistId}} = PS,
	if
		Type == ?ASSIST_TYPE_3 -> %% 不管怎样，直接取消协助
			lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, assist_player_sea_treasure_next),
			mod_guild_assist:cancel_sea_treasure_assist(AssistId, RoleId, 2),
		    lib_server_send:send_to_sid(PS#player_status.sid, pt_404, 40403, [1, 2, AssistId, 0]),
		    PS#player_status{guild_assist = #status_assist{}};
		true ->
			PS
	end.


cancel_assist(PS, AssistId) ->
	CheckList = [
		{check_had_assist, PS, AssistId},
		{check_cancel_assist, PS}
	],
	case check_list(CheckList) of
		true ->
			cancel_assist_do(PS, AssistId, 1);
		{false, Res} ->
			{ok, Res, PS}
	end.

cancel_assist_do(PS, AssistId, CancelType) ->
	#player_status{guild_assist = _StatusAssist} = PS,
	case catch mod_guild_assist:get_launch_assist(AssistId) of
		{ok, LaunchAssist} ->
			{NewPS, Code} = cancel_assist_do_core(PS, LaunchAssist, CancelType);
		false ->
			NewPS = PS#player_status{guild_assist = #status_assist{}},
			Code = ?SUCCESS;
		_Err ->
			NewPS = PS,
			Code = ?ERRCODE(system_busy)
	end,
	{ok, Code, NewPS}.

cancel_assist_do_core(PS, LaunchAssist, CancelType) ->
	#player_status{id = RoleId} = PS,
	#launch_assist{role_id = AskId, type = Type, assister_list = AssisterList} = LaunchAssist,
	#assister{assist_st = AssistSt} = ulists:keyfind(RoleId, #assister.role_id, AssisterList, #assister{}),
	case AskId == RoleId orelse AssistSt == 1 of
		true ->
			case Type of
				?ASSIST_TYPE_1 ->
					NewPS = cancel_boss_assist(PS, LaunchAssist, CancelType),
					{NewPS, ?SUCCESS};
				?ASSIST_TYPE_2 ->
					NewPS = cancel_dungeon_assist(PS, LaunchAssist, CancelType),
					{NewPS, ?SUCCESS};
				?ASSIST_TYPE_3 ->
					NewPS = cancel_sea_treasure_assist(PS, LaunchAssist, CancelType),
					{NewPS, ?SUCCESS};
				?ASSIST_TYPE_4 ->
					NewPS = cancel_enchantment_guard_assist(PS, LaunchAssist, CancelType),
					{NewPS, ?SUCCESS}
			end;
		_ ->
			{PS, ?ERRCODE(err404_no_assist)}
	end.

%% 取消boss协助
cancel_boss_assist(PS, LaunchAssist, CancelType) ->
	#player_status{id = RoleId, sid = Sid, guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId} = StatusAssist,
	#launch_assist{
		role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
	} = LaunchAssist,
	BlState = get_bl_state(PS, Type, SubType, TargetCfgId),
	mod_guild_assist:cancel_boss_assist(AssistId, RoleId, BlState, CancelType),
	%% 此时玩家可能已经不在boss场景，也更新一下当前场景的协助id
	mod_scene_agent:update(PS, [{assist_id, 0}]),
	lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
	PS#player_status{guild_assist = #status_assist{}}.

%% 场景进程处理，取消协助
cancel_boss_assist_in_scene(AssistId, SubType, TargetCfgId, TargetId, RoleList, CancelAll, _State) ->
	case lib_scene_object_agent:get_object(TargetId) of
        #scene_object{aid = Aid} ->
        	case CancelAll of
        		true ->
		        	%% 删除怪物的协助列表
		        	Aid ! {'change_attr', [{del_assist_id, AssistId}]};
		        _ ->
		        	skip
		    end,
        	%% 更新场景玩家的协助id
        	case SubType of
        		?BOSS_TYPE_DECORATION_BOSS -> %% 幻饰boss
        			IsSBoss = lib_decoration_boss_api:is_sboss_id(TargetCfgId);
        		_ ->
        			IsSBoss = false
        	end,
        	F = fun({RoleId, BlState}) ->
        		case lib_scene_agent:get_user(RoleId) of
			        [] -> skip;
			        SceneUser ->
			        	ValueList = ?IF(SubType == ?BOSS_TYPE_DECORATION_BOSS andalso IsSBoss == false andalso BlState == false, [{is_hurt_mon, 0}], []),
			            NewSceneUser = lib_scene_user:set_data_sub([{assist_id, 0}|ValueList], SceneUser),
			            lib_scene_agent:put_user(NewSceneUser)
			    end
        	end,
        	lists:foreach(F, RoleList),
        	%% 更新怪物进程中，玩家伤害列表的信息
            Aid ! {'assist_change', 0, RoleList},
            ok;
        _ -> %% 怪物已经死亡或不存在, 不处理
        	ok
    end.

cancel_boss_assist_succ(PS, AssistId, AskId, CancelType) ->
	#player_status{id = _RoleId, sid = Sid, guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = MyAssistId} = StatusAssist,
	case MyAssistId == AssistId of
		true ->
			%?PRINT("cancel_boss_assist_succ succ ~n", []),
			lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
			{ok, PS#player_status{guild_assist = #status_assist{}}};
		_ ->
			{ok, PS}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 取消副本协助
cancel_dungeon_assist(PS, LaunchAssist, CancelType) ->
	#player_status{id = RoleId, guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = AssistId} = StatusAssist,
	#launch_assist{
		role_id = AskId, type = _Type, sub_type = _SubType, target_cfg_id = _TargetCfgId, assister_list = AssisterList,
		extra = Extra
	} = LaunchAssist,
	IsMyAssist = AskId == RoleId,
	AssistTeamId = maps:get(team_id, Extra, 0),
	Assister = ulists:keyfind(RoleId, #assister.role_id, AssisterList, #assister{assist_st = 0}),
	?PRINT("cancel_dungeon_assist {AssistTeamId,IsMyAssist}: ~p~n", [{AssistTeamId, IsMyAssist}]),
	case IsMyAssist orelse Assister#assister.assist_st == 1 of
		true ->
			case IsMyAssist of
				true ->
					DelRoleList = [AssisterRoleId ||#assister{role_id = AssisterRoleId, assist_st = 1} <- AssisterList];
				_ ->
					DelRoleList = [RoleId]
			end,
			Node = node(),
			Args = [{mfa, {?MODULE, cancel_dungeon_assist_result, [RoleId, Node, AssistTeamId, AssistId, AskId, CancelType]}}],
			mod_team:cast_to_team(AssistTeamId, {'batch_quit_team', DelRoleList, 0, Args}),
			PS;
		_ ->
			PS
	end.

cancel_dungeon_assist_result(Code, RoleId, Node, TeamId, AssistId, AskId, CancelType) ->
	unode:apply(Node, ?MODULE, cancel_dungeon_assist_result, [Code, RoleId, TeamId, AssistId, AskId, CancelType]).

cancel_dungeon_assist_result(Code, RoleId, _TeamId, AssistId, AskId, CancelType) ->
	case Code == ?SUCCESS of
		true ->
			mod_guild_assist:cancel_dungeon_assist(AssistId, RoleId, CancelType);
		_ ->
			lib_server_send:send_to_uid(RoleId, pt_404, 40403, [Code, CancelType, AssistId, AskId])
	end.

cancel_dungeon_assist_succ(PS, AssistId, AskId, TargetCfgId, ResetHelpType, CancelType) ->
	#player_status{sid = Sid, guild_assist = StatusAssist} = PS,
	#status_assist{assist_id = MyAssistId} = StatusAssist,
	case MyAssistId == AssistId of
		true ->
			{ok, PS1} = lib_team:set_help_type(PS, TargetCfgId, ResetHelpType),
			%% 通知客户端协助取消了
			lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
			{ok, PS1#player_status{guild_assist = #status_assist{}}};
		_ ->
			{ok, PS}
	end.

%%======================================= 取消璀璨之星协助 ==============================================
cancel_sea_treasure_assist(PS, LaunchAssist, CancelType) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    % #status_assist{assist_id = AssistId} = StatusAssist,
    #launch_assist{
        assist_id = AssistId,
        role_id = AskId
    } = LaunchAssist,
    mod_guild_assist:cancel_sea_treasure_assist(AssistId, RoleId, CancelType),
    lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
    PS#player_status{guild_assist = #status_assist{}}.

cancel_sea_treasure_assist_succ(PS, AssistId, AskId, CancelType) ->
    #player_status{id = RoleId, sid = Sid, guild_assist = StatusAssist, lunch_assist = LunchMap} = PS,
    #status_assist{assist_id = MyAssistId} = StatusAssist,
    case MyAssistId == AssistId of
        true ->
            %% 通知客户端协助取消了
            lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
            if
                AskId == RoleId ->
                    {ok, PS#player_status{guild_assist = #status_assist{}, lunch_assist = maps:remove(AssistId, LunchMap)}};
                true ->
                    {ok, PS#player_status{guild_assist = #status_assist{}}}
            end;
        _ ->
            #status_assist{assist_id = MyAssistId1} = maps:get(AssistId, LunchMap, #status_assist{}),
            case MyAssistId1 == AssistId of
                true ->
                     %% 通知客户端协助取消了
                    lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
                    {ok, PS#player_status{lunch_assist = maps:remove(AssistId, LunchMap)}};
                _ ->
                    {ok, PS}
            end
    end.

%%======================================= 取消主线本协助 ==============================================
cancel_enchantment_guard_assist(PS, LaunchAssist, CancelType) ->
	#player_status{id = RoleId, sid = Sid, lunch_assist = LunchAssist} = PS,
	% #status_assist{assist_id = AssistId} = StatusAssist,
	#launch_assist{
		assist_id = AssistId,
		role_id = AskId
	} = LaunchAssist,
	mod_guild_assist:cancel_enchantment_guard_assist(AssistId, RoleId, CancelType),
	lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
	NewPS = PS#player_status{lunch_assist = maps:remove(AssistId, LunchAssist)},
	pp_enchantment_guard:handle(13300, NewPS, []),
	NewPS.

cancel_enchantment_guard_assist_succ(PS, AssistId, AskId, _TargetCfgId, CancelType) ->
	#player_status{sid = Sid, guild_assist = StatusAssist, id = RoleId} = PS,
	#status_assist{assist_id = MyAssistId} = StatusAssist,
	case MyAssistId == AssistId of
		true ->
			lib_server_send:send_to_sid(Sid, pt_404, 40403, [1, CancelType, AssistId, AskId]),
			NewPS = PS#player_status{guild_assist = #status_assist{}},
			RoleId == AskId andalso pp_enchantment_guard:handle(13300, NewPS, []),
			{ok, NewPS};
		_ ->
			{ok, PS}
	end.

%%%%%%%%%%%%% clear
clear_assist(RoleId, AskId, AssistId, Name, Args) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, clear_assist, [AskId, AssistId, Name, Args]);
clear_assist(PS, AskId, AssistId, Name, Args) ->
	#player_status{
        id = RoleId, sid = Sid, guild_assist = StatusAssist,
        figure = #figure{name = HelperName, guild_id = GuildId}} = PS,
	#status_assist{assist_id = MyAssistId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId} = StatusAssist,
	case MyAssistId == AssistId of
		true ->
			case Type of
				?ASSIST_TYPE_1 ->
					%% 此时玩家可能已经不在boss场景，也更新一下当前场景的协助id
					mod_scene_agent:update(PS, [{assist_id, 0}]),
					[EndType] = Args,
					case EndType == 1 andalso RoleId =/= AskId of
						true ->
							lib_task_api:boss_assist(PS),
							{ok, PS0} = lib_grow_welfare_api:assist_role(PS),
							lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
							%% 传闻
							#mon{name = MonName} = data_mon:get(TargetCfgId),
							lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ASSIST, 1, [HelperName, Name, util:make_sure_binary(MonName)]);
						_ ->
							PS0 = PS
					end,
					PS1 = PS0;
				?ASSIST_TYPE_2 ->
					[EndType, TargetCfgId, OHelpType] = Args,
					case EndType == 1 andalso RoleId =/= AskId of
						true ->
							lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
							%% 传闻
							#dungeon{name = DungeonName} = data_dungeon:get(TargetCfgId),
							lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ASSIST, 2, [HelperName, Name, util:make_sure_binary(DungeonName)]);
						_ ->
							skip
					end,
					case RoleId =/= AskId of
						true ->
							{ok, PS1} = lib_team:set_help_type(PS, TargetCfgId, OHelpType),
							%% 众生之门退队伍
							?IF(SubType == ?DUNGEON_TYPE_BEINGS_GATE, pp_team:handle(24005, PS1, []), skip);
						_ ->
							PS1 = PS
					end;
                ?ASSIST_TYPE_3 ->
                    [EndType, Rober, Reward] = Args,
                    [RoberServerNum, RoberName] = Rober,
                    case EndType == 1 andalso RoleId =/= AskId of
                        true ->
                            lib_task_api:boss_assist(PS),
							{ok, PS0} = lib_grow_welfare_api:assist_role(PS),
                            lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
                            %% 传闻
                            lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ASSIST, 3,
                                [HelperName, RoberServerNum, RoberName, Name]);
                        _ when RoleId =/= AskId andalso Reward =/= [] ->
                            lib_task_api:boss_assist(PS),
							{ok, PS0} = lib_grow_welfare_api:assist_role(PS),
                            lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
                            %% 传闻
                            lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ASSIST, 4,
                                [HelperName, RoberServerNum, RoberName, Name]);
                        _ ->
							PS0 = PS
                    end,
                    PS1 = PS0;
				% 后续改了需求，一般不会走到这里， 4类型协助者一协助就会完成获取奖励；发起人的请求状态保存到#player_status.lunch_assist
				% 走自己的结算
				?ASSIST_TYPE_4 ->
					[EndType, TargetCfgId, _] = Args,
					if
						EndType == 1, RoleId =/= AskId ->
							lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
							PS1 = PS;
						EndType == 1, RoleId == AskId ->
							mod_daily:increment(RoleId, ?MOD_ENCHANTMENT_GUARD, 3),
							db:execute(io_lib:format(?sql_delete_role_assist, [RoleId])),
							PS1 = PS,
							pp_enchantment_guard:handle(13324, PS1, []);
						true -> PS1 = PS
					end;
                _ ->
                    PS1 = PS
			end,
			{ok, PS1#player_status{guild_assist = #status_assist{}}};
		_ ->
			{ok, PS}
	end.


clear_assist_type3(RoleId, AskId, EndType, ?ASSIST_TYPE_3, AssistId, Name, Args) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, clear_assist_type3, [AskId, EndType, AssistId, Name, Args]);
clear_assist_type3(_, _, _, _, _, _, _) -> skip.

clear_assist_type3(PS, AskId, EndType, AssistId, Name, Args) ->
    #player_status{
        id = RoleId, sid = Sid, lunch_assist = LunchMap
    } = PS,
    if
        AskId =/= RoleId ->
            % ?PRINT("========= ~n",[]);
            clear_assist(PS, AskId, AssistId, Name, Args);
        true ->
            #status_assist{assist_id = MyAssistId1} = maps:get(AssistId, LunchMap, #status_assist{}),
            case MyAssistId1 == AssistId of
                true ->
                    if
                        EndType == 1 ->
                            lib_server_send:send_to_sid(Sid, pt_404, 40409, [AssistId]),
                            NewPS =
                            PS#player_status{
                                lunch_assist = maps:remove(AssistId, LunchMap),
                                guild_assist = #status_assist{}
                            };
                        true ->
                            NewPS = PS#player_status{guild_assist = #status_assist{}}
                    end,
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end
    end.

clear_assist_4(RoleId, AskId, AssistId, Name, Args) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, clear_assist_4, [AskId, AssistId, Name, Args]);
clear_assist_4(PS, AskId, AssistId, _Name, Args) ->
	#player_status{ id = RoleId, lunch_assist = LunchMap } = PS,
	IsExist = maps:is_key(AssistId, LunchMap),
	[EndType, _TargetCfgId, _] = Args,
	if
		IsExist, EndType == 1, AskId == RoleId ->
			mod_daily:increment(RoleId, ?MOD_ENCHANTMENT_GUARD, 3),
			db:execute(io_lib:format(?sql_delete_role_assist, [RoleId])),
			pp_enchantment_guard:handle(13324, PS, []),
			NewPS = PS#player_status{lunch_assist = maps:remove(AssistId, LunchMap)},
			{ok, NewPS};
		true ->
			{ok, PS}
	end.

send_assist_reward([], _Rewards) -> ok;
send_assist_reward([RoleId|RewardSendList], Rewards) ->
    MaxCount = data_guild_m:get_config(day_assist_count),
    case mod_daily:get_count(RoleId, ?MOD_GUILD_ASSIST, 1) of
        Count when Count < MaxCount ->
        	NewRewardList = Rewards ++ data_guild_m:get_config(day_assist_extra_reward),
            Produce = #produce{type = guild_assist, reward = NewRewardList},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            mod_daily:increment(RoleId, ?MOD_GUILD_ASSIST, 1),
            lib_server_send:send_to_uid(RoleId, pt_404, 40404, [Count+1]),
            %?PRINT("send_assist_reward ##### NewRewardList : ~p~n", [NewRewardList]),
            send_assist_reward(RewardSendList, Rewards);
        _ ->
        	Produce = #produce{type = guild_assist, reward = Rewards},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            %?PRINT("send_assist_reward ##### Rewards : ~p~n", [Rewards]),
            send_assist_reward(RewardSendList, Rewards)
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% data
get_assist_scene(Type, SubType, TargetCfgId) ->
	case Type of
		?ASSIST_TYPE_1 -> %% boss
			get_boss_scene(SubType, TargetCfgId);
		?ASSIST_TYPE_2 -> %% 副本
			get_dungeon_scene(SubType, TargetCfgId);
        _ ->
            {0,0,0}
	end.

get_boss_scene(?BOSS_TYPE_NEW_OUTSIDE, TargetCfgId) ->
	case data_boss:get_boss_cfg(TargetCfgId) of
		#boss_cfg{type = ?BOSS_TYPE_NEW_OUTSIDE, scene = Scene, x = X, y = Y} ->
			{Scene, X, Y};
		_ -> {0, 0, 0}
	end;
get_boss_scene(?BOSS_TYPE_PHANTOM, TargetCfgId) ->
	case data_eudemons_land:get_eudemons_boss_cfg(TargetCfgId) of
		#eudemons_boss_cfg{scene = Scene, fixed_xy = [{X, Y}|_]} ->
			{Scene, X, Y};
		_ -> {0, 0, 0}
	end;
get_boss_scene(?BOSS_TYPE_DECORATION_BOSS, TargetCfgId) ->
	IsSBoss = lib_decoration_boss_api:is_sboss_id(TargetCfgId),
	case IsSBoss of
		true ->
			{X, Y} = ?DECORATION_BOSS_KV_SBOSS_XY,
			Scene = ?DECORATION_BOSS_KV_SBOSS_SCENE,
			{Scene, X, Y};
		_ ->
			case data_decoration_boss:get_boss(TargetCfgId) of
				#base_decoration_boss{scene_id = Scene, x = X, y = Y} ->
					{Scene, X, Y};
				_ -> {0, 0, 0}
			end
	end;
get_boss_scene(_, _TargetCfgId) -> {0, 0, 0}.

get_dungeon_scene(SubType, TargetCfgId) ->
	case data_dungeon:get(TargetCfgId) of
		#dungeon{type = SubType, scene_id = SceneId} -> {SceneId, 0, 0};
		_ -> {0, 0, 0}
	end.

get_bl_state(PS, ?ASSIST_TYPE_1, SubType, TargetCfgId) ->
	if
	 	SubType == ?BOSS_TYPE_NEW_OUTSIDE ->
	 		SceneBossTiredMap = lib_boss_api:make_boss_tired_map(PS),
			case maps:get(SubType, SceneBossTiredMap, 0) of
				#scene_boss_tired{tired = HadBossTired} ->
					#boss_cfg{tired_add = TiredNeed} = data_boss:get_boss_cfg(TargetCfgId),
					case HadBossTired >= TiredNeed of
						true -> true;
						_ -> false
					end;
				_ -> false
			end;
	 	SubType == ?BOSS_TYPE_PHANTOM ->
	 		SceneBossTiredMap = lib_boss_api:make_boss_tired_map(PS),
			case maps:get(SubType, SceneBossTiredMap, 0) of
				#scene_boss_tired{tired = BossTired, max_tired = MaxTired} ->
					case BossTired < MaxTired of
						true -> true;
						_ -> false
					end;
				_ -> false
			end;
	 	SubType == ?BOSS_TYPE_DECORATION_BOSS ->
	 		case lib_decoration_boss_api:is_sboss_id(TargetCfgId) of
	 			true -> true;
	 			_ ->
			 		case lib_decoration_boss_api:can_enter_decoration_boss(PS, TargetCfgId, ?DECORATION_BOSS_ENTER_TYPE_NORMAL, guild_assist) of
						true -> true;
						_Res -> false
					end
			end;
		true -> false
	end;
get_bl_state(_PS, _, _SubType, _TargetCfgId) -> true.


make_assist_data(PS, AssistId) ->
	#player_status{
		id = RoleId, pid = Pid, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
		team = #status_team{team_id = TeamId}, camp_id = CampId,
		figure = #figure{lv = Lv, name = Name, mask_id = MaskId}
	} = PS,
	Wlv = util:get_world_lv(),
	ModLevel = lib_scene:get_mod_level(PS),
	MonAttr = #mon_atter{
        id = RoleId, pid = Pid, node = node(), team_id = TeamId, att_sign = ?BATTLE_SIGN_PLAYER, att_lv = Lv,
        server_id = ServerId, server_num = ServerNum, name = Name, world_lv = Wlv, server_name = ServerName
        , mod_level = ModLevel, camp_id = CampId, mask_id = MaskId, assist_id = AssistId
    },
    #assist_data{assist_id = AssistId, mon_atter = MonAttr}.

make_status_assist(RoleId, AssistId, Type, SubType, TargetCfgId, TargetId, AssistProcess, Extra) ->
	#status_assist{
        assist_id = AssistId, ask_id = RoleId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId,
        target_id = TargetId, assist_process = AssistProcess, extra = Extra, stime = utime:unixtime()
    }.

make_launch_assist(PS, AssistId, Type, SubType, TargetCfgId, TargetId, Args) ->
	#player_status{
		id = RoleId, figure = Figure, team = #status_team{team_id = TeamId}
	} = PS,
	Extra = make_extra_data(PS, Type, Args),
	#launch_assist{
        assist_id = AssistId, role_id = RoleId, figure = Figure, team_id = TeamId
        , type = Type, sub_type = SubType, target_cfg_id = TargetCfgId
        , target_id = TargetId, extra = Extra
    }.

make_assister(PS, AssistId, BlState, HelpType) ->
	#assister{
        assist_id = AssistId, role_id = PS#player_status.id, assist_st = 1, bl_st = BlState, o_help_type = HelpType
    }.

make_extra_data(PS, ?ASSIST_TYPE_1, _) ->
	#player_status{
		scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId
	} = PS,
	Extra = #{scene => [Scene, ScenePoolId, CopyId]},
	Extra;
make_extra_data(PS, ?ASSIST_TYPE_2, Args) ->
	[ActivityId, SubActivityId] = Args,
	#player_status{team = #status_team{team_id = TeamId}} = PS,
	Extra = #{team_id => TeamId, activity_id => [ActivityId, SubActivityId]},
	Extra;
make_extra_data(_PS, ?ASSIST_TYPE_3, Args) ->
    [_AutoId, _ShipSerId, _ShipRoleId, TarScene, EnemyInfo] = Args,
    % [EnemySerId, EnemySerNum, EnemyId, EnemyName,EnemyPower] = EnemyInfo
    Extra = #{ship_info => [_AutoId, _ShipSerId, _ShipRoleId, TarScene], enemy_info => EnemyInfo},
    Extra;
make_extra_data(_PS, ?ASSIST_TYPE_4, _Args) ->
	#{}.

pack_launch_assist(LaunchAssist, RoleId) ->
	#launch_assist{
		assist_id = AssistId, role_id = AskId, type = Type, sub_type = SubType, target_cfg_id = TargetCfgId,
        target_id = TargetId, figure = Figure, assister_list = AssisterList, extra = Extra
	} = LaunchAssist,
    #figure{name = Name, lv = Level, career = Career, sex = Sex, picture = Pic, picture_ver = PicVer} = Figure,
    case lists:keyfind(RoleId, #assister.role_id, AssisterList) of
        #assister{assist_st = 1} -> IsAssist = 1;
        _ -> IsAssist = 0
    end,
    if
        Type == ?ASSIST_TYPE_3 ->
            [EnemySerId, EnemySerNum, EnemyId, EnemyName, EnemyPower, RoberReward, BackReward|_] =
                maps:get(enemy_info, Extra, [0,0,0,"",0, [], []]),
            ExtraL = [{EnemySerId, EnemySerNum, EnemyId, EnemyName, EnemyPower, RoberReward, BackReward}];
        true ->
            ExtraL = []
    end,
    {AssistId, Type, SubType, TargetCfgId, TargetId, AskId, Name, Level, Career, Sex, Pic, PicVer, IsAssist, ExtraL}.

broadcast_new_assist(GuildId, RoleId, LaunchAssist) ->
	{AssistId, Type, SubType, TargetCfgId, TargetId, AskId, Name, Level, Career, Sex, Pic, PicVer, _IsAssist, ExtraL} =
	 	pack_launch_assist(LaunchAssist, RoleId),
	{ok, Bin} = pt_404:write(40406, [AssistId, Type, SubType, TargetCfgId, TargetId, AskId, Name, Level, Career, Sex, Pic, PicVer, 0, ExtraL]),
	lib_server_send:send_to_guild(GuildId, Bin).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% check
check_list([]) -> true;
check_list([H|L]) ->
	case check(H) of
		true ->
			check_list(L);
		Res -> Res
	end.

check({check_cfg, PS, Cfg}) ->
	case Cfg of
		#base_guild_assist{condition = Condition, desc = Desc} ->
			{_, RoleLV} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 0}),
			{_, OpenDay} = ulists:keyfind(open_day, 1, Condition, {open_day, 0}),
			case PS#player_status.figure#figure.lv >= RoleLV andalso util:get_open_day() >= OpenDay of
				true -> true;
				_ -> {false, {?ERRCODE(err404_not_satisfy), [Desc, OpenDay, RoleLV]}}
			end;
		_ ->{false, ?MISSING_CONFIG}
	end;

check({check_launch_conditon, PS, AssistCfg, TargetCfgId}) ->
	#player_status{guild = #status_guild{id = GuildId}} = PS,
	#base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
	case GuildId > 0 of
		true ->
			case Type of
				?ASSIST_TYPE_1 -> %% boss检查
					check_launch_boss_assist(PS, Type, SubType, TargetCfgId);
				?ASSIST_TYPE_2 -> %% 副本，先不处理
					check_launch_dungeon_assist(PS, Type, SubType, TargetCfgId);
                _ ->
                    true
			end;
		_ -> {false, ?ERRCODE(err404_no_guild)}
	end;
check({check_target_cfg, PS, AssistCfg, TargetCfgId, TargetId}) ->
	#base_guild_assist{type = Type, sub_type = SubType} = AssistCfg,
	case Type of
		?ASSIST_TYPE_1 -> %% boss检查
			check_boss_target_cfg(PS, Type, SubType, TargetCfgId, TargetId);
		?ASSIST_TYPE_2 -> %% 副本，先不处理
			check_dungeon_target_cfg(PS, Type, SubType, TargetCfgId, TargetId);
        _ ->
            true
	end;
check({assist_base_check, PS, LaunchAssist}) ->
	#player_status{guild = #status_guild{id = MyGuildId}} = PS,
	#launch_assist{type = Type, figure = #figure{guild_id = GuildId}} = LaunchAssist,
	case MyGuildId == GuildId of
		true ->
			case Type of
				?ASSIST_TYPE_1 ->
					assist_base_check_boss(PS, LaunchAssist);
				?ASSIST_TYPE_2 ->
					assist_base_check_dungeon(PS, LaunchAssist);
                ?ASSIST_TYPE_3 ->
                    assist_base_check_sea_treasure(PS, LaunchAssist);
				?ASSIST_TYPE_4 ->
					assist_base_check_enchantment_guard(PS, LaunchAssist)
			end;
		_ ->
			{false, ?ERRCODE(err404_not_same_guild)}
	end;
check({check_lv, PS, Type}) ->
    if
        Type == ?ASSIST_TYPE_3 -> %% 璀璨之海协助不检查等级
            true;
        true ->
            #player_status{figure = #figure{lv = Lv}} = PS,
            NeedLv = data_guild:get_cfg(guild_assist_lv),
            ?IF(Lv >= NeedLv, true, {false, ?LEVEL_LIMIT})
    end;
check({check_had_assist_other, PS}) ->
	#player_status{
		id = RoleId,
		guild_assist = #status_assist{assist_id = AssistId, ask_id = AskId, assist_process = AssistProcess, stime = STime}
	} = PS,
	NowTime = utime:unixtime(),
	if
	 	AssistId > 0 andalso AssistProcess == 1 ->
	 		case RoleId == AskId of
	 			true -> {false, ?ERRCODE(err404_had_launch_assist)};
	 			_ ->
	 				{false, ?ERRCODE(err404_had_assist)}
	 		end;
		AssistId > 0 andalso AssistProcess == 0 andalso NowTime - STime < 5 ->
			{false, ?ERRCODE(err404_please_wait_a_second)};
		true -> true
	end;

check({check_had_assist, PS, AssistId}) ->
	#player_status{guild_assist = #status_assist{assist_id = MyAssistId, assist_process = AssistProcess}, lunch_assist = LunchAssist} = PS,
	#status_assist{assist_id = MyAssistId2, assist_process = AssistProcess2} = maps:get(AssistId, LunchAssist, #status_assist{}),
	if
	 	AssistId > 0 andalso AssistProcess == 1 andalso MyAssistId == AssistId -> true;
	 	AssistId > 0 andalso AssistProcess2 == 1 andalso MyAssistId2 == AssistId -> true;
		true -> {false, ?ERRCODE(err404_no_assist)}
	end;

check({check_cancel_assist, PS}) ->
	#player_status{guild_assist = StatusAssist} = PS,
	#status_assist{type = Type} = StatusAssist,
	case Type of
		?ASSIST_TYPE_2 -> %% 副本协助
			IsOnDungeon = lib_dungeon:is_on_dungeon(PS),
			case IsOnDungeon of
				true ->
					{false, ?ERRCODE(err404_cannt_cancel_in_dungeon)};
				_ ->
					true
			end;
		_ -> %% boss协助，不检查
			true
	end;

check({check_has_lunch, PS, Type, TargetId}) when Type == ?ASSIST_TYPE_3; Type == ?ASSIST_TYPE_4 ->
    #player_status{lunch_assist = LunchMap} = PS,
    AssistList = maps:values(LunchMap),
    check_has_lunch(AssistList, TargetId);
check({check_has_lunch, _, _, _}) -> true;

check({check_enchantment_guard, PS, Type, TargetCfgId}) when Type == ?ASSIST_TYPE_4 ->
	check_enchantment_guard(PS, TargetCfgId);
check({check_enchantment_guard, _, _, _}) -> true;

check(_) ->
	{false, ?FAIL}.

check_enchantment_guard(PS, TargetCfgId) ->
	#player_status{id = RoleId, enchantment_guard = #enchantment_guard{gate = Gate, next_assist_time = NextTime}, scene = SceneId} = PS,
	[Limit] = data_enchantment_guard:get_value_by_key(2),
	DailyCount = mod_daily:get_count(RoleId, ?MOD_ENCHANTMENT_GUARD, 3),
	NowTime = utime:unixtime(),
	IsInOutSide = lib_scene:is_outside_scene(SceneId),
	if
		DailyCount >= Limit -> {false, ?ERRCODE(err404_limit_times)};
		NowTime =< NextTime -> {false, ?ERRCODE(err404_in_cd)};
		not IsInOutSide -> {false, ?ERRCODE(err404_need_outside_assist)};
		true ->
			?IF(TargetCfgId == Gate + 1, true, {false, ?FAIL})
	end.

check_has_lunch([#status_assist{target_id = OldTargetId}|T], TargetId) ->
    if
        OldTargetId == TargetId ->
            {false, ?ERRCODE(err404_had_assist)};
        true ->
            check_has_lunch(T, TargetId)
    end;
check_has_lunch([], _) -> true.

%% boss
check_launch_boss_assist(PS, Type, SubType, TargetCfgId) ->
	if
	 	SubType == ?BOSS_TYPE_NEW_OUTSIDE orelse SubType == ?BOSS_TYPE_PHANTOM ->
	 		case get_bl_state(PS, Type, SubType, TargetCfgId) of
	 			true -> true;
	 			_ -> {false, ?ERRCODE(err404_no_tired)}
	 		end;
		SubType == ?BOSS_TYPE_DECORATION_BOSS ->
			%% 进入条件不检查，在场景检查里做
			true;
		true ->
			{false, ?MISSING_CONFIG}
	end.

%% 副本
check_launch_dungeon_assist(PS, _Type, _SubType, _TargetCfgId) ->
	#player_status{team = #status_team{team_id = TeamId}} = PS,
	{True, Code} = lib_scene:is_transferable(PS),
	case True of
		true ->
			case TeamId > 0 of
				true -> true;
				_ -> %% 副本求助，要先组建队伍
					{false, ?ERRCODE(err404_please_create_team)}
			end;
		_ ->
			{false, Code}
	end.


check_boss_target_cfg(PS, _Type, SubType, TargetCfgId, _TargetId) ->
	{MScene, MX, MY} = get_boss_scene(SubType, TargetCfgId),
	Mon = data_mon:get(TargetCfgId),
	case MScene > 0 andalso is_record(Mon, mon) of
		true ->
			IsSBoss = SubType == ?BOSS_TYPE_DECORATION_BOSS andalso lib_decoration_boss_api:is_sboss_id(TargetCfgId),
			IsShareBoss = SubType == ?BOSS_TYPE_DECORATION_BOSS andalso lib_decoration_boss_api:is_share_boss(TargetCfgId),
			#player_status{id = RoleId, scene = Scene, x = X, y = Y} = PS,
			#mon{tracing_distance = TracingDistance} = Mon,
			if
				IsSBoss == true -> {false, ?ERRCODE(err404_boss_cannt_assist)};
				IsShareBoss == true -> {false, ?ERRCODE(err404_boss_cannt_assist)};
				Scene =/= MScene -> {false, ?ERRCODE(err404_move_to_boss)};
				abs(X - MX) > TracingDistance orelse abs(Y - MY) > TracingDistance -> {false, ?ERRCODE(err404_move_to_boss)};
				true ->
					if
						SubType == ?BOSS_TYPE_DECORATION_BOSS ->
							%% 幻饰boss，获取进入类型，协助进入不求助
							case catch mod_decoration_boss_local:get_role_info(RoleId) of
								{ok, ?DECORATION_BOSS_ENTER_TYPE_NORMAL} -> true;
								{ok, _} -> {false, ?ERRCODE(err404_no_tired)};
								false -> {false, ?ERRCODE(err404_move_to_boss)};
								_Err ->
									?ERR("check_boss_target_cfg : Err : ~p~n", [_Err]),
									{false, ?ERRCODE(system_busy)}
							end;
						true ->
							true
					end
			end;
		_ ->
			{false, ?ERRCODE(err404_param_err)}
	end.

check_dungeon_target_cfg(PS, _Type, SubType, TargetCfgId, _TargetId) ->
	case data_dungeon:get(TargetCfgId) of
		#dungeon{type = SubType} = Dun ->
			case lib_dungeon:get_daily_left_count(PS, Dun) of
                Num when Num > 0 ->
                    true;
                _ ->
                    {false, ?ERRCODE(err404_no_dun_times)}
            end;
		_ ->
			{false, ?MISSING_CONFIG}
	end.

assist_base_check_sea_treasure(PS, _LaunchAssist) ->
    #player_status{team = #status_team{team_id = TeamId}, figure = #figure{lv = Lv}} = PS,
    case data_sea_treasure:get_sea_treasure_value(open_lv) of
        LimitLv when is_integer(LimitLv) andalso Lv >= LimitLv ->
            {True, Code} = lib_scene:is_transferable(PS),
            case True == true of
                true ->
                    case TeamId > 0 of
                        false ->
                            true;
                        _ ->
                            {false, ?ERRCODE(err404_please_leave_team)}
                    end;
                _ ->
                    {false, Code}
            end;
        _ ->
            {false, ?ERRCODE(lv_limit)}
    end.

assist_base_check_enchantment_guard(PS, LaunchAssist) ->
	#player_status{enchantment_guard = #enchantment_guard{gate = Gate}} = PS,
	#launch_assist{target_cfg_id = TargetCfgId} = LaunchAssist,
	case Gate >= TargetCfgId of
		true -> true;
		_ -> {false, {?ERRCODE(err404_not_finish_guard), [TargetCfgId]}}
	end.

assist_base_check_boss(PS, LaunchAssist) ->
	#player_status{scene = Scene, team = #status_team{team_id = TeamId}} = PS,
	#launch_assist{type = Type, sub_type = SubType, target_cfg_id = TargetCfgId} = LaunchAssist,
	{TarScene, _, _} = get_assist_scene(Type, SubType, TargetCfgId),
	{True, Code} = lib_scene:is_transferable(PS),
	case Scene == TarScene orelse True == true of
		true ->
			case TeamId > 0 of
				false ->
					true;
				_ ->
					{false, ?ERRCODE(err404_please_leave_team)}
			end;
		_ ->
			{false, Code}
	end.

assist_base_check_dungeon(PS, LaunchAssist) ->
	#player_status{team = #status_team{team_id = TeamId}} = PS,
	#launch_assist{type = _Type, sub_type = _SubType, target_cfg_id = TargetCfgId, extra = Extra} = LaunchAssist,
	{True, Code} = lib_scene:is_transferable(PS),
	AssistTeamId = maps:get(team_id, Extra, 0),
	Dun = data_dungeon:get(TargetCfgId),
	if
	 	True =/= true -> {false, Code};
	 	AssistTeamId == 0 -> {false, ?ERRCODE(err404_no_launch_assist)};
		true ->
			if
			 	TeamId > 0 andalso TeamId == AssistTeamId ->%% 已经在队伍中
					true;
				TeamId == 0 ->
					#dungeon{condition = Condition} = Dun,
					CheckList = [
		                {fun lib_dungeon_check:is_exist_mutex/1, [PS]},
		                {fun lib_dungeon_team:check_dungeon_condition/4, [Condition, Dun, [], PS]}
		            ],
		            case lib_dungeon_team:check_all(CheckList) of
		                true ->
		                    true;
		                {false, Code1} ->
		                    {false, Code1};
		                {false, _Code, MyErrorCode} ->
		                	{false, MyErrorCode}
		            end;
				true ->
					{false, ?ERRCODE(err404_please_leave_team)}
			end
	end.