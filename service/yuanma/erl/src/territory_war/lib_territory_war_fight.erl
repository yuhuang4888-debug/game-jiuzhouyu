-module(lib_territory_war_fight).

-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("attr.hrl").

%% 战场初始化
init_war(State) ->
	#terri_fight_state{terri_war = TerriWar, is_cls = IsCls, end_time = EndTime} = State,
	#terri_war{
		group = Group, round = _Round, territory_id = TerritoryId,
		a_guild = AGuildId, 
		b_guild = BGuildId
	} = TerriWar,
	SceneId = lib_territory_war_data:get_scene_by_terrritory_id(TerritoryId, IsCls),
	PoolId = Group,
	CopyId = self(),
	RandTime = urand:rand(1, 2000),
    ?PRINT("init_war end_time : ~p~n", [EndTime - utime:unixtime()]),
	RefState = util:send_after([], (EndTime - utime:unixtime() - 1)*1000, CopyId, {end_fight}),
	RefInfo = util:send_after([], ?SYNC_INFO_TIME*1000 + RandTime, CopyId, {broadcast_war_info}),
    LangRef = util:send_after([], ?REF_LANGUAGE_TIME*1000 + RandTime, CopyId, {send_language}),
    GuildList = init_guild_list(TerriWar),
	MonList = init_mons(SceneId, PoolId, CopyId, TerritoryId, AGuildId, BGuildId),
	NewGuildList = init_guild_own(GuildList, MonList, []),
	?PRINT("init_war scene : ~p~n", [{SceneId, PoolId, CopyId}]),
    %?PRINT("init_war MonList : ~p~n", [MonList]),
    %?PRINT("init_war GuildList : ~p~n", [GuildList]),
    %% 广播公会战斗开始
    {ok, Bin} = pt_506:write(50627, [TerritoryId]),
    [lib_territory_war:apply_cast(IsCls, ServerId, lib_server_send, send_to_guild, [GuildId, Bin]) 
        ||#tfight_guild{guild_id = GuildId, server_id = ServerId} <- NewGuildList],
    State#terri_fight_state{
		scene = SceneId, pool_id = PoolId, copy_id = CopyId, guild_list = NewGuildList, mon_list = MonList, ref_state = RefState, 
        ref_info = RefInfo, ref_lan = LangRef
	}.

init_guild_list(TerriWar) ->
    #terri_war{
        a_guild = AGuildId, a_server = AServerId, a_server_num = ASerNum, a_guild_name = AGuildName,
        b_guild = BGuildId, b_server = BServerId, b_server_num = BSerNum, b_guild_name = BGuildName 
    } = TerriWar,
    case BGuildId > 0 of 
        true ->
            ATerrFightGuild = #tfight_guild{guild_id = AGuildId, guild_name = AGuildName, server_id = AServerId, server_num = ASerNum, camp = ?CAMP_1},
            BTerrFightGuild = #tfight_guild{guild_id = BGuildId, guild_name = BGuildName, server_id = BServerId, server_num = BSerNum, camp = ?CAMP_2},
            GuildList = [ATerrFightGuild, BTerrFightGuild];
        _ ->
            ATerrFightGuild = #tfight_guild{guild_id = AGuildId, guild_name = AGuildName, server_id = AServerId, server_num = ASerNum, camp = ?CAMP_1},
            GuildList = [ATerrFightGuild]
    end,
    GuildList.

init_mons(SceneId, PoolId, CopyId, TerritoryId, Camp1GuildId, Camp2GuildId) ->
	MonCfgList = data_territory_war:get_mon_list_by_territory_id(TerritoryId),
    NewCamp1GuildId = ?IF(Camp1GuildId > 0, Camp1GuildId, ?MON_INIT_GUILD),
    NewCamp2GuildId = ?IF(Camp2GuildId > 0, Camp2GuildId, ?MON_INIT_GUILD),
	F = fun({MonId, MonType, Camp, X, Y, _Range, Condition}, List) ->
		{_, UnLockMon} = ulists:keyfind(unlock_mon, 1, Condition, {unlock_mon, 0}),
		TFightMon = #tfight_mon{
			mon_id = MonId, mon_type = MonType, guild_id = ?IF(Camp > 0, ?IF(Camp == ?CAMP_1, NewCamp1GuildId, NewCamp2GuildId), ?MON_INIT_GUILD),
			x = X, y = Y, unlock_mon = UnLockMon
		},
		[TFightMon|List]
	end,
	MonList1 = lists:foldl(F, [], MonCfgList),
	%MonAgs = [{die_handler, {mod_territory_war_fight, kill_mon, []}],
	F1 = fun(TFightMon, List) ->
		#tfight_mon{
			mon_id = MonId, mon_type = MonType, guild_id = GuildOwn, x = X, y = Y
		} = TFightMon,
		IsUnlock = [1 ||#tfight_mon{alive = Alive, unlock_mon = UnLockMon} <- MonList1, UnLockMon == MonId, Alive == 1] == [],
		IsBeAtt = ?IF(IsUnlock, 1, 0),
		MonArgs2 = [{group, GuildOwn}, {is_be_atted, IsBeAtt}],
		case MonType of 
			?KING_TYPE ->
				NewMonAgs = [{be_att_limit, []}|MonArgs2];
			_ ->
				NewMonAgs = MonArgs2
		end,
		Id = lib_mon:sync_create_mon(MonId, SceneId, PoolId, X, Y, 0, CopyId, 1, NewMonAgs),
		[TFightMon#tfight_mon{id = Id}|List]
	end,
	MonList = lists:foldl(F1, [], MonList1),
	MonList.

init_guild_own([], _MonList, Return) -> Return;
init_guild_own([TerrFightGuild|GuildList], MonList, Return) ->
	#tfight_guild{guild_id = GuildId} = TerrFightGuild,
	OwnList = [MonId || #tfight_mon{mon_id = MonId, guild_id = MGuildId} <- MonList, GuildId == MGuildId],
	init_guild_own(GuildList, MonList, [TerrFightGuild#tfight_guild{own = OwnList}|Return]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 战场结束
%% EndType=1,自然结算 EndType=2,提前结算
end_fight(State, EndType) ->
    #terri_fight_state{
        is_cls = IsCls, mode_num = ModeNum, terri_war = TerriWar, scene = SceneId, pool_id = PoolId, copy_id = CopyId,
        guild_list = GuildList, mon_list = MonList, ref_state = RefState, ref_info = RefInfo, ref_lan = LangRef
    } = State,
    %% 取消定时器
    util:cancel_timer(RefState), util:cancel_timer(RefInfo), util:cancel_timer(LangRef),
    [util:cancel_timer(RefMon) ||#tfight_mon{ref = RefMon} <- MonList],
    #terri_war{group = Group, war_id = WarId, territory_id = TerritoryId, round = Round} = TerriWar,
    WinnerGuildId = get_battle_winner(EndType, GuildList, MonList),
    lib_territory_war:log_terri_war_result(Group, WarId, TerritoryId, Round, WinnerGuildId, GuildList),
    %SortRoleList = sort_role_rank(RoleMaps),
    %% 推送结束界面
    send_over_show(IsCls, TerritoryId, ModeNum, WinnerGuildId, GuildList),
    %% 推送是否晋级
    Round =/= ?WAR_ROUND_3 andalso send_rise_info(IsCls, WinnerGuildId, GuildList),
    %% 推送全服公告
    case WinnerGuildId > 0 andalso Round == ?WAR_ROUND_3 of
        true-> %% 最后一轮结算，传闻胜者
            case lists:keyfind(WinnerGuildId, #tfight_guild.guild_id, GuildList) of 
                #tfight_guild{guild_name = GuildName, server_id = ServerId} ->
                    lib_territory_war:apply_cast(IsCls, ServerId, ?MODULE, send_chief_win_reward, [WinnerGuildId]),
                    BinData = lib_chat:make_tv(?MOD_TERRITORY_WAR, ?TERRI_WAR_LANGUAGE_9, [GuildName]),
                    [
                        lib_territory_war:apply_cast(IsCls, GServerId, lib_server_send, send_to_all, [BinData])
                        || #tfight_guild{server_id = GServerId} <- GuildList
                    ];
                _ ->
                    skip
            end;
        false->
            skip
    end, 
    %Now = utime:unixtime(),
    %% 保存公会排名排行榜
    mod_territory_war:war_fight_end(Group, WarId, WinnerGuildId),
    ?PRINT("end_fight WinnerGuildId : ~p~n", [{Group, WarId, WinnerGuildId}]),
    %% 保存个人排行榜
    %refresh_role_rank(SortRoleList),
    LeavePlayers = lists:foldl(
        fun(#tfight_guild{server_id = ServerId, role_list = RoleList}, List) -> 
            [{ServerId, [RId ||{RId, _RSid} <- RoleList]}|List]
        end, [], GuildList),
    spawn(fun() -> 
        timer:sleep(urand:rand(1000, 2000)),
        %% 领地战结算奖励
        send_battle_result_reward(IsCls, TerritoryId, ModeNum, WinnerGuildId, GuildList),
        timer:sleep(1000),
        [lib_territory_war:apply_cast(IsCls, ServerId, lib_territory_war, leave_scene, [RoleIdList]) ||{ServerId, RoleIdList} <- LeavePlayers],
        timer:sleep(5*1000),
        lib_scene:clear_scene_room(SceneId, PoolId, CopyId)
    end),   
    {stop, normal, State}.

%% 进入战场
enter_fight(State, TFRole, BuffId) ->
	#terri_fight_state{
		is_cls = IsCls, mode_num = ModeNum, terri_war = #terri_war{territory_id = TerritoryId, round = Round}, scene = SceneId, 
        pool_id = PoolId, copy_id = CopyId, role_map = RoleMap, guild_list = GuildList
	} = State,
	#tfight_role{role_id = RoleId, sid = Sid, name = RoleName, node = Node, guild_id = GuildId} = TFRole,
	case maps:get(RoleId, RoleMap, 0) of 
		#tfight_role{} = OldTFRole ->
            FirstIn = false,
			NewTFRole = OldTFRole#tfight_role{sid = Sid, name = RoleName, node = Node, guild_id = GuildId, is_leave = 0};
		_ ->
            FirstIn = true,
			UpScore = lib_territory_war_data:get_min_up_score(TerritoryId),
			NewTFRole = TFRole#tfight_role{up_score = UpScore}
	end,
	NewRoleMap = maps:put(RoleId, NewTFRole, RoleMap),
    ?PRINT("enter_fight NewTFRole : ~p~n", [NewTFRole]),
	%% 玩家的公会
	case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of 
		#tfight_guild{role_list = RoleList, camp = Camp, own = Own} = TFGuild ->
            case FirstIn == true andalso 
                ((ModeNum == ?MODE_NUM_1 andalso Round == ?WAR_ROUND_2) orelse (ModeNum =/= ?MODE_NUM_1 andalso Round == ?WAR_ROUND_1)) of 
                    %% 第一次进入
                    true ->
                        %% 参与了活动
                        lib_territory_war:apply_cast(IsCls, Node, lib_territory_war, role_first_in, [RoleId]);
                    _ ->
                        skip
            end,
            NewGuildList = lists:keystore(GuildId, #tfight_guild.guild_id, GuildList, TFGuild#tfight_guild{role_list = [{RoleId, Sid}|lists:keydelete(RoleId, 1, RoleList)]}),
			lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_territory_war, enter_fight_scene, [SceneId, PoolId, CopyId, TerritoryId, Camp, Own, BuffId]),
			State#terri_fight_state{role_map = NewRoleMap, guild_list = NewGuildList};
		_ -> 
			{ok, Bin} = pt_506:write(50600, [?ERRCODE(err506_no_qualification)]),
			lib_server_send:send_to_sid(Node, Sid, Bin),
			State
	end.

re_login(State, TFRole, X, Y) ->
    #terri_fight_state{
        is_cls = IsCls, terri_war = #terri_war{territory_id = TerritoryId}, scene = SceneId, pool_id = PoolId, copy_id = CopyId,
        role_map = RoleMap, guild_list = GuildList
    } = State,
    #tfight_role{role_id = RoleId, sid = Sid, name = RoleName, node = Node, guild_id = GuildId} = TFRole,
    %% 玩家的公会
    TFGuild = lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList),
    OldTFRole = maps:get(RoleId, RoleMap, false),
    case TFGuild == false orelse OldTFRole == false of 
        true ->
            lib_territory_war:apply_cast(IsCls, lib_scene, player_change_default_scene, [RoleId, [{terri_status, #terri_status{}}]]),
            State;
        _ ->
            #tfight_guild{role_list = RoleList, camp = Camp, own = Own} = TFGuild,
            NewGuildList = lists:keystore(GuildId, #tfight_guild.guild_id, GuildList, TFGuild#tfight_guild{role_list = [{RoleId, Sid}|lists:keydelete(RoleId, 1, RoleList)]}),
            NewRoleMap = maps:put(RoleId, OldTFRole#tfight_role{sid = Sid, name = RoleName, node = Node, is_leave = 0}, RoleMap),
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_territory_war, relogin_fight, [SceneId, PoolId, CopyId, X, Y, TerritoryId, Camp, Own]),
            State#terri_fight_state{role_map = NewRoleMap, guild_list = NewGuildList}
    end.

%% 离开战场
leave_war(State, RoleId, GuildId, Node) ->
	#terri_fight_state{is_cls = IsCls, terri_war = #terri_war{territory_id = _TerritoryId}, guild_list = GuildList, role_map = RoleMap} = State,
    TFRole = maps:get(RoleId,RoleMap,[]),
    case TFRole =/= [] of
        true->
            NewRoleMap = maps:put(RoleId, TFRole#tfight_role{is_leave = 1}, RoleMap),
            ?PRINT("quit RoleId : ~p~n", [RoleId]),
            lib_territory_war:apply_cast(IsCls, Node, lib_territory_war, leave_scene, [[RoleId]]),
            %% 玩家的公会
			case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of 
				#tfight_guild{role_list = RoleList} = TFGuild ->
					NewRoleList = lists:keydelete(RoleId, 1, RoleList),
					?PRINT("leave_war NewRoleList : ~p~n", [NewRoleList]),
                    NewGuildList = lists:keystore(GuildId, #tfight_guild.guild_id, GuildList, TFGuild#tfight_guild{role_list = NewRoleList});
				_ -> 
					NewGuildList = GuildList
			end,
            NewState = State#terri_fight_state{guild_list = NewGuildList, role_map = NewRoleMap};
        false->
            NewState = State
    end,
    NewState.

%%怪物死亡处理
kill_mon(State, MonInfo, AtterId) -> 
    #terri_fight_state{
    	is_cls = _IsCls, terri_war = #terri_war{territory_id = TerritoryId}, guild_list = GuildList,
    	role_map = RoleMap, mon_list = MonList
    } = State,
    #scene_object{mon = Mon} = MonInfo,    
    #scene_mon{mid = MonId} = Mon,    
    TFRole = maps:get(AtterId, RoleMap, []),
    TFMon = lists:keyfind(MonId, #tfight_mon.mon_id, MonList),
    case TFRole == [] orelse TFMon == false of
        true-> NewState = State;
        false->
            #tfight_role{guild_id = GuildId} = TFRole,
            #tfight_mon{mon_type = MonType} = TFMon,
            TFGuild = lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList),
            if
            	TFGuild == false -> 
            		NewState = State;
                MonType == ?KING_TYPE orelse MonType == ?NORMAL_TYPE ->
                    {AddScore, _GuildAddScore} = lib_territory_war_data:get_mon_kill_score(TerritoryId, MonId),
                    %% 玩家积分暂时不要，先屏蔽
                    %{NewRoleMap, _GuildAddScore} = add_guild_member_score(IsCls, TerritoryId, TFGuild, RoleMap, AddScore),
                    NewRoleMap = RoleMap,
                    TmpState = State#terri_fight_state{role_map = NewRoleMap},
                    TmpState1 = add_guild_score(TmpState, GuildId, AddScore),
                    NewState = own_change_belong(TmpState1, MonId, GuildId);
                true -> %% 目前没小怪了
                    % AddScore = data_territory_war:get_cfg(?TERRI_KEY_10),
                    % NewTFRole = add_score(IsCls, TerritoryId, TFRole, AddScore, false),
                    % NewRoleMap = maps:put(AtterId, NewTFRole, RoleMap),
                    % TmpState = add_guild_score(State, GuildId, AddScore),
                    NewState = State%TmpState#terri_fight_state{role_map = NewRoleMap}
            end
    end,
    NewState.

hurt_mon(State, MonInfo, AtterId) ->
    #terri_fight_state{
        is_cls = IsCls, terri_war = #terri_war{territory_id = TerritoryId},
        mon_list = MonList, role_map = RoleMap
    } = State,
    #scene_object{battle_attr = #battle_attr{hp = Hp, hp_lim=HpLim}, mon = #scene_mon{mid = MonId}} = MonInfo,
    TFRole = maps:get(AtterId, RoleMap, []),
    TFMon = lists:keyfind(MonId, #tfight_mon.mon_id, MonList),
    case TFRole == [] orelse TFMon == false of
        true-> NewState = State;
        _ ->
            #tfight_role{guild_id = GuildId} = TFRole,
            #tfight_mon{mon_type = MonType} = TFMon,
            %TFGuild = lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList),
            %增加造成伤害玩家积分
            AddScore = ?IF(
                MonType == ?KING_TYPE,
                data_territory_war:get_cfg(?TERRI_KEY_10),
                data_territory_war:get_cfg(?TERRI_KEY_11)
            ), 
            NewRole = add_score(IsCls, TerritoryId, TFRole, AddScore, false),
            NewRoleMap = maps:put(AtterId, NewRole, RoleMap),
            TmpState = add_guild_score(State, GuildId, AddScore),
            %% 更新据点血量
            NewTFMon = TFMon#tfight_mon{hp=Hp, hp_lim = HpLim},
            NewMonList = lists:keyreplace(MonId, #tfight_mon.mon_id, MonList, NewTFMon),
            %% 据点状态更改标志
            put({?MODULE, own_change}, true),
            %?PRINT("hurt_mon hurt_mon NewRole : ~p~n", [NewRole#tfight_role.score]),
            NewState = TmpState#terri_fight_state{role_map = NewRoleMap, mon_list = NewMonList}
    end,
    NewState.

%%玩家死亡处理
kill_player(State, AtterId, RoleId) ->
    #terri_fight_state{
    	is_cls = IsCls, terri_war = #terri_war{territory_id = TerritoryId},
    	role_map = RoleMap, guild_list = GuildList
    } = State,
    Role = maps:get(AtterId, RoleMap, []),
    DieRole = maps:get(RoleId, RoleMap, []),
    case Role == [] orelse DieRole == [] of
        true-> NewState = State;
        false ->
            %% 更新被杀者信息
            #tfight_role{name = DieName, be_kill_num = BeKillNum} = DieRole,
            %%判断是否存在该玩家并重置杀人数
            RoleMapTmp = maps:put(RoleId, DieRole#tfight_role{kill_num = 0, be_kill_num = BeKillNum+1}, RoleMap),
            AddScore = data_territory_war:get_cfg(?TERRI_KEY_9),
            #tfight_role{guild_id = GuildId, name = Name, kill_num = KillNum, total_kill_num = TotalNum} = Role,
            TmpRole = Role#tfight_role{kill_num = KillNum + 1, total_kill_num = TotalNum + 1},
            NewRole = add_score(IsCls, TerritoryId, TmpRole, AddScore, true),
            NewRoleMap = maps:put(AtterId, NewRole, RoleMapTmp),
            %% 连杀广播
            broadcast_killer_info(IsCls, NewRole, GuildList),    
            %%判断是否第一滴血
            case get({?MODULE, first_kill}) of
                true-> skip;
                _ -> 
                    put({?MODULE, first_kill},true),
                    %%发送第一滴血传闻
                    send_TV(IsCls, GuildList, ?TERRI_WAR_LANGUAGE_10, [Name, DieName])
            end,
            TmpState = add_guild_score(State, GuildId, AddScore),
            NewState = TmpState#terri_fight_state{role_map = NewRoleMap}
    end,
    NewState.

%%检测增加据点工会积分
own_add_guild_score(State, GuildId, MonId) ->
    #terri_fight_state{is_cls = _IsCls, terri_war = #terri_war{territory_id = TerritoryId, round = Round}, mon_list = MonList} = State,
    case lists:keyfind(MonId, #tfight_mon.mon_id, MonList) of
        false-> NewState = State;
        #tfight_mon{guild_id = TmpGuildId, ref = ORef} = TFMon ->
            {_AddScore, GuildAddScore} = lib_territory_war_data:get_mon_kill_score(TerritoryId, MonId),
            %%判断是否还属于该工会的归属权
            NewState = case TmpGuildId == GuildId of
                true->
                    GuildCampNum = length([1 ||#tfight_mon{guild_id = GuildIdCamp} <- MonList, GuildIdCamp == GuildId]),
                    AddScoreCoefList = data_territory_war:get_cfg(?TERRI_KEY_15),
                    case lists:keyfind(Round, 1, AddScoreCoefList) of 
                        {_, AddScoreCoefList2} -> 
                            {_, AddScoreCoef} = ulists:keyfind(GuildCampNum, 1, AddScoreCoefList2, {GuildCampNum, 0});
                        _ -> AddScoreCoef = 0
                    end,
                    NewGuildAddScore = round(GuildAddScore * (1 + AddScoreCoef)),
                	OwnAddTime = data_territory_war:get_cfg(?TERRI_KEY_12),
                    Ref = util:send_after(ORef, OwnAddTime*1000, self(), {own_add_guild_score, GuildId, MonId}),
                    NewMonList = lists:keyreplace(MonId, #tfight_mon.mon_id, MonList, TFMon#tfight_mon{ref = Ref}),
                    add_guild_score(State#terri_fight_state{mon_list = NewMonList}, GuildId, NewGuildAddScore);
                false->
                    State
            end
    end,
    NewState.

%%增加据点工会积分
add_guild_score(State, GuildId, AddScore) when AddScore > 0 ->
    #terri_fight_state{is_cls = IsCls, terri_war = TerriWar, guild_list = GuildList} = State,
    #terri_war{round = Round} = TerriWar,
    case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of
        false-> NewState = State;
        #tfight_guild{score = Score} = TFGuild->
            NewScore = Score + AddScore,
            NewTFGuild = TFGuild#tfight_guild{score = NewScore},
            %?PRINT("add_guild_score ~p~n",[NewTFGuild#tfight_guild.score]),
            %%增加积分变化标志
            put({?MODULE, guild_change}, true),
            NewGuildList = lists:keyreplace(GuildId, #tfight_guild.guild_id, GuildList, NewTFGuild),
            EndContion = data_territory_war:get_cfg(?TERRI_KEY_13),
            case lists:keyfind(Round, 1, EndContion) of 
                {_, EndScore} when NewScore >= EndScore ->
                    {ok, Bin} = pack_guild_score_list(NewGuildList),
                    send_to_all(IsCls, NewGuildList, Bin),
                    put({?MODULE, guild_change}, false),
                    mod_territory_war_fight:advance_end(self());
                _ -> skip
            end,
            NewState = State#terri_fight_state{guild_list = NewGuildList}
    end,    
    NewState;
add_guild_score(State, _GuildId, _AddScore) ->
    State.

%%据点归属权变更
own_change_belong(State, MonId, GuildId) ->
    #terri_fight_state{
    	is_cls = IsCls, terri_war = #terri_war{territory_id = TerritoryId}, role_map = RoleMap, 
    	guild_list = GuildList, mon_list = MonList
    } = State,
    case lists:keyfind(MonId, #tfight_mon.mon_id, MonList) of
        false-> 
            OldGuildId = 0, 
            NewMonList = MonList, 
            LastGuildList = GuildList, 
            NewState = State;
        #tfight_mon{guild_id = OldGuildId} ->
            NewMonList = create_new_own(State, MonId, GuildId, MonList),
            %%移除归属权
            NewGuildList = ?IF(OldGuildId > ?MON_INIT_GUILD, own_change_remove_belong(OldGuildId, GuildList, MonId), GuildList),
            %%增加归属权
            LastGuildList = own_change_add_belong(IsCls, RoleMap, GuildId, NewGuildList, MonId, OldGuildId),
            NewState = State#terri_fight_state{mon_list = NewMonList, guild_list = LastGuildList}
    end,
    %%切换玩家ps的复活点
    spawn(fun()-> change_revive(IsCls, TerritoryId, LastGuildList, MonId, GuildId, OldGuildId) end),
    %%推送据点列表信息
    send_own_list_do(IsCls, NewMonList, LastGuildList),
    put({?MODULE, own_change}, false),
    update_king_mon_att_limit(NewState),
    %?PRINT("own_change_belong ~p~n", [NewOwnList]),
    NewState.

%%添加据点归属权
own_change_add_belong(IsCls, _RoleMap, GuildId, GuildList, MonId, OldGuildId) ->
    case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of
        false-> NewGuildList = GuildList, GuildName = <<>>;
        #tfight_guild{guild_name = GuildName, own = OldOwn} = TFGuild-> 
            NewTFGuild = TFGuild#tfight_guild{own = [MonId|lists:delete(MonId, OldOwn)]},
            NewGuildList = lists:keyreplace(GuildId, #tfight_guild.guild_id, GuildList, NewTFGuild)
    end,
    #mon{name=MonName} = data_mon:get(MonId),
    {ok, Bin} = pt_506:write(50613, [MonId, GuildId]),
    send_to_all(IsCls, NewGuildList, Bin),
    %%判断是否第一占领
    case OldGuildId > ?MON_INIT_GUILD of
        true-> 
            %%发送传闻
            send_TV(IsCls, NewGuildList, ?TERRI_WAR_LANGUAGE_2, [GuildName, MonName]);
        _ -> 
            %%发送第一占领传闻
            send_TV(IsCls, NewGuildList, ?TERRI_WAR_LANGUAGE_11, [GuildName, MonName])
    end,
    NewGuildList.

%%移除据点归属权
own_change_remove_belong(GuildId, GuildList, MonId) ->  
    case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of
        false-> NewGuildList = GuildList;
        #tfight_guild{own = OldOwn} = TFGuild-> 
            NewTFGuild = TFGuild#tfight_guild{own = lists:delete(MonId, OldOwn)},
            NewGuildList = lists:keyreplace(GuildId, #tfight_guild.guild_id, GuildList, NewTFGuild)
    end,  
    NewGuildList.

get_battle_winner(1, GuildList, MonList) ->
    case [GuildId ||#tfight_mon{mon_type = MonType, guild_id = GuildId} <- MonList, MonType == ?KING_TYPE, GuildId > ?MON_INIT_GUILD] of 
        [WinGuildId] -> WinGuildId;
        _ ->
            case lists:reverse(lists:keysort(#tfight_guild.score, GuildList)) of 
                [#tfight_guild{guild_id = WinGuildId}|_] -> 
                    WinGuildId;
                _ -> 0
            end
    end;
get_battle_winner(_, GuildList, _MonList) ->
    case lists:reverse(lists:keysort(#tfight_guild.score, GuildList)) of 
        [#tfight_guild{guild_id = WinGuildId}|_] -> 
            WinGuildId;
        _ -> 0
    end.

%% 玩家排名
sort_role_rank(RoleMaps) ->
    RoleList = maps:values(RoleMaps),
    SortRoleList = keysort_role_rank(RoleList),
    sort_role_rank_helper(SortRoleList, 1, []).

sort_role_rank_helper([], _Rank, List) -> lists:reverse(List);
sort_role_rank_helper([Role|SortRoleList], Rank, List) ->
    sort_role_rank_helper(SortRoleList, Rank+1, [Role#tfight_role{role_rank = Rank}|List]).

keysort_role_rank(List)->
    F = fun(RoleA, RoleB)->
        if
            RoleA#tfight_role.total_kill_num > RoleB#tfight_role.total_kill_num -> true;
            RoleA#tfight_role.total_kill_num < RoleB#tfight_role.total_kill_num -> false;
            RoleA#tfight_role.score > RoleB#tfight_role.score -> true;
            true ->
                false
        end
    end,
    Result = lists:sort(F, List),
    Result.

send_over_show(IsCls, TerritoryId, ModeNum, WinnerGuildId, GuildList) ->
    {ok, Bin} = pack_war_settlement_info(TerritoryId, ModeNum, WinnerGuildId, GuildList),
    send_to_all(IsCls, GuildList, Bin).

send_rise_info(IsCls, WinnerGuildId, GuildList) ->
    F = fun(#tfight_guild{guild_id = GuildId, server_id = ServerId}) ->
        {ok, Bin} = ?IF(GuildId == WinnerGuildId, pt_506:write(50625, [1]), pt_506:write(50625, [0])),
        lib_territory_war:apply_cast(IsCls, ServerId, lib_server_send, send_to_guild, [GuildId, Bin])
    end,
    lists:foreach(F, GuildList).

send_language(State) ->
    #terri_fight_state{is_cls = IsCls, guild_list = GuildList, ref_lan = RefLan, language = Language} = State,
    if
        %Language == 0  -> NewLanguage = ?TERRI_WAR_LANGUAGE_5;
        %Language == ?TERRI_WAR_LANGUAGE_5 -> NewLanguage = ?TERRI_WAR_LANGUAGE_6;
        Language == 0  -> NewLanguage = ?TERRI_WAR_LANGUAGE_6;
        Language == ?TERRI_WAR_LANGUAGE_6 -> NewLanguage = ?TERRI_WAR_LANGUAGE_7;
        Language == ?TERRI_WAR_LANGUAGE_7 -> NewLanguage = ?TERRI_WAR_LANGUAGE_6;
        true -> NewLanguage = Language
    end,
    send_TV(IsCls, GuildList, NewLanguage, []),
    NewRefLan = util:send_after(RefLan, ?REF_LANGUAGE_TIME*1000, self(), {send_language}),
    NewState = State#terri_fight_state{ref_lan = NewRefLan, language = NewLanguage},
    NewState.

send_chief_win_reward(WinnerGuildId) ->
    ChiefId = mod_guild:get_guild_chief(WinnerGuildId),
    %% 霸主奖励
    [BattleReward, _] = lib_territory_war_data:get_battle_reward(),
    Title = utext:get(5060001),
    Content = utext:get(5060002),
    lib_mail_api:send_sys_mail([ChiefId], Title, Content, BattleReward).

send_battle_result_reward(IsCls, TerritoryId, ModeNum, WinnerGuildId, GuildList) ->
    F = fun(#tfight_guild{guild_id = GuildId, server_id = GServerId, role_list = RoleList}) ->
        IsWin = ?IF(GuildId == WinnerGuildId, 1, 0),
        case [GuildName1 ||#tfight_guild{guild_id=GuildId1, guild_name=GuildName1} <- GuildList, GuildId1 =/= GuildId] of 
            [EnemyName|_] -> ok;
            _ -> EnemyName = []
        end,
        lib_territory_war:apply_cast(IsCls, GServerId, ?MODULE, send_battle_result_reward_do, [TerritoryId, ModeNum, IsWin, RoleList, EnemyName])
    end,
    lists:foreach(F, GuildList).

send_battle_result_reward_do(TerritoryId, ModeNum, IsWin, RoleList, EnemyName) ->
    case data_territory_war:get_terri_result_reward(TerritoryId, ModeNum) of 
        [{WinReward, FailReward}] ->
            NowTime = utime:unixtime(),
            #base_territory{territory_name = TerriName} = data_territory_war:get_territory_cfg(TerritoryId),
            Title = utext:get(5060011),
            {Reward, Content} = ?IF(IsWin == 1, 
                {WinReward, ?IF(EnemyName == [], utext:get(5060018, [util:make_sure_binary(TerriName)]), utext:get(5060012, [util:make_sure_binary(TerriName), util:make_sure_binary(EnemyName)]))}, 
                {FailReward, utext:get(5060013, [util:make_sure_binary(TerriName), util:make_sure_binary(EnemyName)])}),
            RoleIdList = [RoleId ||{RoleId, _} <- RoleList],
            RewardStr = util:term_to_bitstring(Reward),
            LogList = [[RoleId, TerritoryId, IsWin, RewardStr, NowTime] || {RoleId, _} <- RoleList],
            lib_log_api:log_terri_war_battle_reward(LogList),
            lib_mail_api:send_sys_mail(RoleIdList, Title, Content, Reward);
        _ ->
            ?ERR("send_battle_result_reward err_cfg: ~p~n", [{TerritoryId, ModeNum}])
    end.

broadcast_war_info(State) ->
	#terri_fight_state{
    	is_cls = IsCls, terri_war = #terri_war{territory_id = _TerritoryId}, role_map = _RoleMap,
    	guild_list = GuildList, mon_list = MonList, ref_info = OldRefInfo
    } = State,
	case get({?MODULE, own_change}) of 
		true ->
			put({?MODULE, own_change}, false),
			{ok, Bin1} = pack_own_list(MonList, GuildList);
		_ -> Bin1 = <<>>
	end,
	case get({?MODULE, guild_change}) of 
		true ->
			put({?MODULE, guild_change}, false),
			{ok, Bin2} = pack_guild_score_list(GuildList);
		_ ->
			Bin2 = <<>>
	end,
	Bin = list_to_binary([Bin1, Bin2]),
	case size(Bin) of 
		0 -> skip;
		_ -> 
			send_to_all(IsCls, GuildList, Bin)
	end,
	%broadcast_role_score(IsCls, GuildList, RoleMap),
	RefInfo = util:send_after(OldRefInfo, ?SYNC_INFO_TIME*1000, self(), {broadcast_war_info}),
	State#terri_fight_state{ref_info = RefInfo}.

%%修改玩家复活点
change_revive(IsCls, TerritoryId, GuildList, MonId, GuildId, OldGuildId) ->
    #base_terri_mon{mon_type = MonType} = data_territory_war:get_terri_mon(TerritoryId, MonId),
    case MonType == ?KING_TYPE of
        true-> ok;
        false->
            %%修改新占据公会的玩家复活点
            case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of 
            	false ->
            		ok;
            	TFGuild ->
            		change_role_revive(IsCls, TerritoryId, TFGuild)
            end,
            %%修改旧占据公会的玩家复活点
            case lists:keyfind(OldGuildId, #tfight_guild.guild_id, GuildList) of 
            	false ->
            		ok;
            	OldTFGuild ->
            		change_role_revive(IsCls, TerritoryId, OldTFGuild)
            end        
    end.

update_king_mon_att_limit(State) ->
    #terri_fight_state{
    	scene = SceneId, pool_id = PoolId, 
    	guild_list = GuildList, mon_list = MonList
    } = State,
    F = fun(#tfight_guild{guild_id = GuildId, own = GuildCamp}, List) ->
        case GuildCamp =/= [] of 
            true -> [GuildId|List];
            _ -> List
        end
    end,
    BeAttLimit = lists:foldl(F, [], GuildList),
    F1 = fun(#tfight_mon{id = AId, mon_type = MonType}) ->
            case MonType == ?KING_TYPE of 
                true-> lib_scene_object:change_attr_by_ids(SceneId, PoolId, [AId], [{be_att_limit, BeAttLimit}]);
                false-> ok
            end
    end,
    lists:foreach(F1, MonList).


%%创建新据点
create_new_own(State, MonId, GuildId, MonList)->
    #terri_fight_state{
    	is_cls = _IsCls, terri_war = #terri_war{territory_id = TerritoryId}, scene = SceneId, pool_id = PoolId, copy_id = CopyId
    } = State,
    case lists:keyfind(MonId, #tfight_mon.mon_id, MonList) of
        false-> NewMonList = MonList;
        #tfight_mon{ref = ORef} ->
        	OwnAddTime = data_territory_war:get_cfg(?TERRI_KEY_12),
            Ref = util:send_after(ORef, OwnAddTime*1000, self(), {own_add_guild_score, GuildId, MonId}),
            #base_terri_mon{mon_type = MonType, x = X, y = Y} = data_territory_war:get_terri_mon(TerritoryId, MonId),
            case MonType == ?KING_TYPE of 
                true-> Args = [{group, GuildId}, {be_att_limit, []}];
                false-> Args = [{group, GuildId}]
            end,
            %MonAgs = [{die_handler, {mod_territory_war_fight, kill_mon, []}|Args],
            Id = lib_mon:sync_create_mon(MonId, SceneId, PoolId, X, Y, 0, CopyId, 1, Args),
            NewTFMon = #tfight_mon{id = Id, mon_id = MonId, mon_type = MonType, x = X, y = Y, guild_id = GuildId, ref = Ref},
            NewMonList = lists:keyreplace(MonId, #tfight_mon.mon_id, MonList, NewTFMon)
    end,
    NewMonList.

%%% 增加同工会所有人的积分
add_guild_member_score(IsCls, TerritoryId, TFGuild, RoleMap, AddScore) when AddScore > 0 ->
	#tfight_guild{server_id = ServerId, role_list = RoleList} = TFGuild,
	F = fun({RoleId, _}, {List, Map, GuildAddScore}) ->
		case maps:get(RoleId, Map, 0) of 
			#tfight_role{is_leave = 0} = TFRole ->
				{NewTFRole, SendStageList} = add_score_core(TerritoryId, TFRole, AddScore),
				NewMap = maps:put(RoleId, NewTFRole, Map),
				NewList = [{RoleId, NewTFRole#tfight_role.score, SendStageList}|List],
				{NewList, NewMap, GuildAddScore+AddScore};
			_ ->
				{List, Map, GuildAddScore}
		end
	end,
	{SendList, NewRoleMap, NewGuildAddScore} = lists:foldl(F, {[], RoleMap, 0}, RoleList),
	send_score_reward(IsCls, ServerId, TerritoryId, SendList),
	{NewRoleMap, NewGuildAddScore};
add_guild_member_score(_IsCls, _TerritoryId, _TFGuild, RoleMap, _AddScore) ->
	{RoleMap, 0}.

add_score(IsCls, TerritoryId, TFRole, AddScore, NeedReport) ->
	{NewTFRole, SendStageList} = add_score_core(TerritoryId, TFRole, AddScore),
	if
		SendStageList =/= [] -> %% 有奖励发放
			List = [{NewTFRole#tfight_role.role_id, NewTFRole#tfight_role.score, SendStageList}],
			send_score_reward(IsCls, NewTFRole#tfight_role.node, TerritoryId, List),
			NewTFRole;
		NeedReport ->
			List = [{NewTFRole#tfight_role.role_id, NewTFRole#tfight_role.sid, NewTFRole#tfight_role.score}],
			send_role_score(IsCls, NewTFRole#tfight_role.node, List),
			NewTFRole;
		true ->
			NewTFRole
	end.

%% 增加积分(因为是跨服的，攻击建筑积分不实时推，其他积分就实时推)
add_score_core(TerritoryId, TFRole, AddScore) when AddScore > 0 ->
    #tfight_role{score = Score, up_score = UpScore} = TFRole,
    NewScore = Score + AddScore,
    TmpRole = TFRole#tfight_role{score = NewScore},
    case NewScore >= UpScore of
        true ->
            {NewGodReward, SendStageList, NewUpScore} = get_role_reward(TerritoryId, TmpRole),
            NewTerriRole = TmpRole#tfight_role{got_reward = NewGodReward, up_score = NewUpScore};
        _ ->
    		NewTerriRole = TmpRole, SendStageList = []
    end,
    %?PRINT("add_score~p~n",[TmpRole#role.score]),
    {NewTerriRole, SendStageList};
add_score_core(_TerritoryId, TFRole, _AddScore) ->
	{TFRole, []}.

%%获取个人积分奖励
get_role_reward(TerritoryId, TFRole) ->
    #tfight_role{score = Score, got_reward = RewardGot} = TFRole,
    List = data_territory_war:get_all_role_reward(TerritoryId),
    F = fun({StageId, ScoreNeed}, {TList, RList, UpScore})->
            case lists:member(StageId, TList) of
                true-> {TList, RList, UpScore};
                false->
                	case Score >= ScoreNeed of 
                		true -> 
                			{[StageId|TList], [StageId|RList], UpScore};
                		_ ->
                			NewUpScore = ?IF(ScoreNeed < UpScore, ScoreNeed, UpScore),
                			{TList, RList, NewUpScore}
                	end
            end
    end,
    {StageList, RewardStageList, LastUpScore} = lists:foldl(F, {RewardGot, [], 999999}, List),
    {TFRole#tfight_role{got_reward = StageList}, RewardStageList, LastUpScore}.

send_score_reward(IsCls, Node, TerritoryId, List) ->
	lib_territory_war:apply_cast(IsCls, Node, lib_territory_war, send_score_reward, [TerritoryId, List]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% pp 相关
send_war_info(State, [RoleId, Sid, _RGuildId, Node]) ->
    %?PRINT("send_war_info:~p~n", [start]),
    #terri_fight_state{
        terri_war = #terri_war{territory_id = TerritoryId}, end_time = EndTime,
        role_map = RoleMap, guild_list = GuildList, mon_list = MonList
    } = State,
    #tfight_role{score = RoleScore, got_reward = GotReward} = maps:get(RoleId, RoleMap, #tfight_role{}),
    %% 公会列表
    SendGuildList = lists:foldl(fun(TFGuild, List) ->
        #tfight_guild{guild_id = GuildId, guild_name = GuildName, server_id = GServerId, server_num = GServerNum, score = GScore, own = OwnList} = TFGuild,
        [{GuildId, GuildName, GServerId, GServerNum, GScore, OwnList}|List]
    end, [], GuildList),
    %% 领地列表
    SendMonList = lists:foldl(fun(TFMon, List) ->
        #tfight_mon{mon_id = MonId, guild_id = MGuildId, hp = Hp, hp_lim = HpLim} = TFMon,
        case MGuildId > ?MON_INIT_GUILD of
            true-> 
                case lists:keyfind(MGuildId, #tfight_guild.guild_id, GuildList) of
                    false-> Type = 1, MGuildName = <<>>;
                    #tfight_guild{guild_name = MGuildName} -> Type = 2
                end;
            false-> Type = 1, MGuildName = <<>>
        end,
        [{Type, MGuildId, MGuildName, MonId, Hp, HpLim}|List]
    end, [], MonList),
    {ok, Bin} = pt_506:write(50604, [TerritoryId, EndTime, RoleScore, SendGuildList, GotReward, SendMonList]),
    ?PRINT("send_war_info:~p~n", [{TerritoryId, EndTime, SendMonList}]),
    lib_server_send:send_to_sid(Node, Sid, Bin).

convene_guild_member(State, [GuildId, _RoleId, MonId, _Node]) ->
    #terri_fight_state{is_cls = IsCls, guild_list = GuildList, mon_list = MonList} = State,
    case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of 
        #tfight_guild{} = TFGuild ->
            case lists:keyfind(MonId, #tfight_mon.mon_id, MonList) of 
                #tfight_mon{} ->
                    {ok, Bin} = pt_506:write(50617, [MonId]),
                    send_to_all(IsCls, [TFGuild], Bin);
                _ -> ok
            end;
        _ -> ok
    end.

%%%%%%% 广播连杀信息
broadcast_killer_info(IsCls, Role, GuildList) ->
    #tfight_role{role_id = RoleId, name = RoleName, twar_figure = TWarFigure, kill_num = KillNum, server_id = AtterServerId} = Role,
    #twar_figure{sex = Sex, realm = Realm, career = Career, lv = Lv, picture = Picture, picture_ver = PictureVer, turn = Turn} = TWarFigure,
    case KillNum >= ?KILL_PLAYER_LIMIT of 
        true ->
        	{ok, Bin} = pt_506:write(50619, [AtterServerId, RoleId, RoleName, Sex, Realm, Career, Turn, Lv, Picture, PictureVer, KillNum]),
            send_to_all(IsCls, GuildList, Bin);
        _ ->
            ok
    end.

%% 广播玩家积分信息
broadcast_role_score(IsCls, GuildList, RoleMap) ->
	F = fun(#tfight_guild{server_id = ServerId, role_list = RoleList}) ->
		F1 = fun({RoleId, Sid}, List) ->
			#tfight_role{score = Score} = maps:get(RoleId, RoleMap, #tfight_role{}),
			[{RoleId, Sid, Score}|List]
		end,
		SendList = lists:foldl(F1, [], RoleList),
		send_role_score(IsCls, ServerId, SendList)
	end,
	lists:foreach(F, GuildList).

%%发送个人积分
send_role_score(IsCls, Node, SendList) ->
    lib_territory_war:apply_cast(IsCls, Node, lib_territory_war, send_role_score, [SendList]).

change_role_revive(IsCls, TerritoryId, TFGuild) ->
    #tfight_guild{server_id = ServerId, camp = Camp, own = OwnList, role_list = RoleList} = TFGuild,
    lib_territory_war:apply_cast(IsCls, ServerId, lib_territory_war, change_role_revive, [TerritoryId, Camp, OwnList, RoleList]).

send_own_list_do(IsCls, MonList, GuildList)->
    {ok, Bin} = pack_own_list(MonList, GuildList),
	send_to_all(IsCls, GuildList, Bin).


send_to_all(IsCls, GuildList, Bin) ->
	F = fun(#tfight_guild{server_id = ServerId, role_list = RoleList}) ->
		lib_territory_war:apply_cast(IsCls, ServerId, lib_territory_war, send_to_all, [RoleList, Bin])
	end,
	lists:foreach(F, GuildList).

send_TV(IsCls, GuildList, Type, Msg) ->
    BinData = lib_chat:make_tv(?MOD_TERRITORY_WAR, Type, Msg),
    send_to_all(IsCls, GuildList, BinData).

pack_own_list(MonList, GuildList) ->
	F = fun(#tfight_mon{mon_id = MonId, hp=Hp, hp_lim=HpLim, guild_id = GuildId}, TList)->
        %%获取占领公会名字
        case GuildId > ?MON_INIT_GUILD of
            true-> 
                case lists:keyfind(GuildId, #tfight_guild.guild_id, GuildList) of
                    false-> Type = 1, GuildName = <<>>;
                    #tfight_guild{guild_name = GuildName} -> Type = 2
                end;
            false-> Type = 1, GuildName = <<>>
        end,
        [{Type, GuildId, GuildName, MonId, Hp, HpLim}|TList]
    end,
    SendList = lists:foldl(F, [], MonList),
    {ok, Bin} = pt_506:write(50607, [SendList]),
    {ok, Bin}.

pack_guild_score_list(GuildList) ->
	F = fun(#tfight_guild{guild_id = GuildId, score = GuildScore, own = OwnList}, TList)->
        [{GuildId, GuildScore, OwnList}|TList]
    end,
    SendList = lists:foldl(F, [], GuildList),
    %?PRINT("pack_guild_score : ~p~n", [SendList]),
    {ok, Bin} = pt_506:write(50606, [SendList]),
    {ok, Bin}.

pack_war_settlement_info(TerritoryId, ModeNum, WinnerGuildId, GuildList) ->
    F = fun(TFGuild, TList)->
        #tfight_guild{
            guild_id = GuildId, server_id = ServerId, server_num = ServerNum, guild_name = GuildName, score = GuildScore, own = OwnList
        } = TFGuild,
        IsWin = ?IF(WinnerGuildId == GuildId, 1, 0),
        [{GuildId, IsWin, GuildName, ServerId, ServerNum, GuildScore, OwnList}|TList]
    end,
    SendList = lists:foldl(F, [], GuildList),
    {ok, Bin} = pt_506:write(50611, [TerritoryId, ModeNum, SendList]),
    {ok, Bin}.