
-module(lib_territory_war).

-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("guild.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("buff.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("battle.hrl").

%%%%%%%% 登陆
login(PS) ->
	#player_status{id = RoleId, guild = #status_guild{id = GuildId, position = Position}} = PS,
    case GuildId > 0 of
        true ->
            case Position == ?POS_CHIEF of
                true ->
                    mod_territory_war:role_login(RoleId, GuildId);
                _ ->
                    %% 旧版会长buff有可能没清除，先在登录时清理一次buff，留几个版本后后面再删掉处理
                    lib_goods_buff:remove_goods_buff_by_type(RoleId, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE)
            end,
            PS#player_status{terri_status = #terri_status{}};
        _ ->
            PS#player_status{terri_status = #terri_status{}}
    end.

%%%%%%%% 登出
quit(PS) ->
    case is_in_territory_war(PS#player_status.scene) of
        true-> leave_war(PS);
        _ -> PS
    end.

%%断线重连
re_login(PS, ?NORMAL_LOGIN) ->
    case is_in_territory_war(PS#player_status.scene) of
        true->
            lib_scene:player_change_default_scene(PS#player_status.id, []),
            {ok, PS};
        _ -> {next, PS}
    end;
re_login(PS, ?RE_LOGIN) ->
    case is_in_territory_war(PS#player_status.scene) of
        true->
            #player_status{scene = SceneId, copy_id = CopyId, x = X, y = Y} = PS,
			TerriRole = trans_to_terri_role(PS),
			case lib_scene:is_clusters_scene(SceneId) of
				true ->
					mod_clusters_node:apply_cast(?MODULE, re_login_do, [CopyId, 1, [TerriRole, X, Y]]);
				_ ->
					re_login_do(CopyId, 0, [TerriRole, X, Y])
			end,
            {ok, PS};
        _ -> {next, PS}
    end;
re_login(PS,_) ->  {next, PS}.


re_login_do(FightPid, IsCls, Msg) ->
	case misc:is_process_alive(FightPid) of
		true ->
			?PRINT("re_login_do:~p~n", [FightPid]),
			mod_territory_war_fight:re_login(FightPid, Msg);
		_ ->
            [TerriRole, _X, _Y] = Msg,
            lib_territory_war:apply_cast(IsCls, TerriRole#tfight_role.server_id, lib_scene, player_change_default_scene, [TerriRole#tfight_role.role_id, [{terri_status, #terri_status{}}]])
	end.

%% 检查复活
check_revive(PS, Type) ->
    case Type == ?REVIVE_GUILD_BATTLE of
        true ->
            case is_in_territory_war(PS#player_status.scene) of
                true -> true;
                _ -> {false, 10}
            end;
        false ->
            true
    end.

%%安全复活
revive(PS, ?REVIVE_GUILD_BATTLE)->
    #player_status{terri_status = TerriWarStatus, x = _RoleX, y = _RoleY} = PS,
    #terri_status{territory_id = TerritoryId, camp = Camp, own = OwnList} = TerriWarStatus,
    ReviveRef = get({terri_war_revive_ref}),
    util:cancel_timer(ReviveRef),
    {X, Y} = lib_territory_war_data:get_role_born(TerritoryId, Camp, OwnList),
    {X, Y}.

revive_auto(PS) ->
    put({terri_war_revive_ref}, none),
    {_Code, NewPS} = lib_revive:revive(PS, ?REVIVE_GUILD_BATTLE),
    NewPS.

handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId}=Player,
    #{attersign := AtterSign, atter := Atter} = Data,
    #battle_return_atter{real_id = AtterId} = Atter,
    % 被玩家打死有效
    case is_in_territory_war(SceneId) andalso AtterSign == ?BATTLE_SIGN_PLAYER of
        true ->
        	Ref = util:send_after([], 17000, self(), {'mod', lib_territory_war, revive_auto, []}),
            put({terri_war_revive_ref}, Ref),
			case lib_scene:is_clusters_scene(SceneId) of
				true ->
					mod_clusters_node:apply_cast(?MODULE, kill_player, [CopyId, AtterId, RoleId]);
				_ ->
					kill_player(CopyId, AtterId, RoleId)
			end,
            {ok, Player};
        _ ->
            {ok, Player}
    end;
handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = Type}) when is_record(Player, player_status) ->
    #player_status{id = _RoleId, terri_status = TerriWarStatus} = Player,
    case Type == ?REVIVE_GUILD_BATTLE andalso is_in_territory_war(Player#player_status.scene) == true of
        true ->
            ?PRINT("terri war revive ~n", []),
            NewTerriWarStatus = TerriWarStatus#terri_status{revive_state = 1},
            {ok, Player#player_status{guild_battle = NewTerriWarStatus}};
        _ -> {ok, Player}
    end;
handle_event(Player, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE}) when is_record(Player, player_status) ->
    #player_status{id = _RoleId, terri_status = TerriWarStatus} = Player,
    case is_in_territory_war(Player#player_status.scene) of
        true ->
            case TerriWarStatus of
                #terri_status{revive_state = ReviveState} when ReviveState == 1 ->
                    ?PRINT("add buff ~n", []),
                    {_, NewPlayer} = lib_skill_buff:add_buff(Player, 28000001, 1),
                    {ok, NewPlayer#player_status{terri_status = TerriWarStatus#terri_status{revive_state = 2}}};
                _ -> {ok, Player}
            end;
        _ -> {ok, Player}
    end;
handle_event(PS, _) ->
	{ok, PS}.

%%杀死玩家
kill_player(FightPid, AttId, RoleId) ->
	case misc:is_process_alive(FightPid) of
		true ->
    		mod_territory_war_fight:kill_player(FightPid, AttId, RoleId);
    	_ ->
    		skip
    end.

handle_af_battle_success(PS) ->
    case is_in_territory_war(PS#player_status.scene) of
        true ->
            #player_status{terri_status = TerriWarStatus} = PS,
            case TerriWarStatus of
                #terri_status{revive_state = ReviveState} when ReviveState == 2 ->
                    {_, NPS} = lib_skill_buff:clean_buff(PS, 28000001),
                    ?PRINT("clean buff ~n", []),
                    NPS#player_status{terri_status = TerriWarStatus#terri_status{revive_state = 0}};
                _ -> PS
            end;
        _ -> PS
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 选择领地
choose_terri_id(PS, TerritoryId) ->
	#player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId, position = Position}} = PS,
	case Position == ?POS_CHIEF of
		true ->
			Node = mod_disperse:get_clusters_node(),
			mod_territory_war:choose_terri_id([RoleId, Sid, GuildId, TerritoryId, Node]);
		_ ->
			lib_server_send:send_to_sid(Sid, pt_506, 50623, [?ERRCODE(err506_only_chief_choose), TerritoryId])
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 领取每日奖励
get_daily_reward(PS) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId, create_time = CreateTime}} = PS,
    Now = utime:unixtime(),
    NeedTime = data_territory_war:get_cfg(?TERRI_KEY_7),
    case catch mod_territory_war:is_winner(GuildId) of
        true when Now - CreateTime >= NeedTime ->
            case mod_daily:get_count(RoleId, ?MOD_TERRITORY_WAR, 1) of
                0 ->
                    mod_daily:increment(RoleId, ?MOD_TERRITORY_WAR, 1),
                    Errcode = ?SUCCESS,
                    %% 每日福利奖励
                    [_, DailyReward] = lib_territory_war_data:get_battle_reward(),
                    %%发送奖励
                    Produce = #produce{type=terri_war,reward=DailyReward,show_tips=3},
                    {_, NewPS} = lib_goods_api:send_reward_with_mail(PS, Produce);
                _ ->
                    Errcode = ?ERRCODE(err506_reward_is_got), NewPS = PS
            end;
        true ->
            Errcode = ?ERRCODE(err506_join_in_guild_not_enough_time_can_not_receive), NewPS = PS;
        _ ->
            Errcode = ?ERRCODE(err506_not_winner), NewPS = PS
    end,
    {ok, BinData} = pt_506:write(50602, [Errcode]),
    %?PRINT("get_daily_reward Errcode : ~p~n", [Errcode]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进入战场
enter_war(PS) ->
	case check_enter(PS) of
		true ->
			TerriRole = trans_to_terri_role(PS),
			mod_territory_war:enter_war(TerriRole),
			{true, PS};
		Res ->
			Res
	end.

%% 检测参加条件
check_enter(PS) ->
    case lib_player_check:check_list(PS, [action_free, is_transferable]) of
        true ->
            true;
        {false, ErrCode} ->
            {false, ErrCode}
    end.

role_first_in(RoleId) ->
	?PRINT("role_first_in role_first_in ######################### ~n", []),
    % 事件触发
    CallbackData = #callback_join_act{type = ?MOD_TERRITORY_WAR},
    lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData),
	%% 参与了活动
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_TERRITORY_WAR,  0),
    %% 触发成就
    lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_war_join_event, 1),
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 离开战场
leave_war(PS) ->
	case is_in_territory_war(PS#player_status.scene) of
		true ->
			case lib_scene:is_transferable_out(PS) of
                {true, _} ->
					#player_status{
						id = RoleId, guild= #status_guild{id = GuildId}
					} = PS,
					Node = mod_disperse:get_clusters_node(),
					mod_territory_war:leave_war([RoleId, GuildId, Node]),
					{true, PS};
				{false, Res} ->
					{false, Res}
			end;
		_ ->
			{false, ?ERRCODE(err506_not_in_battle)}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 活动主界面
send_territory_war_show(PS) ->
    #player_status{id = RoleId, sid = Sid, guild= #status_guild{id = GuildId, create_time = CreateTime}} = PS,
    mod_territory_war:send_territory_war_show([GuildId, CreateTime, RoleId, Sid]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 查询战场信息
send_war_info(PS) ->
	#player_status{id = RoleId, sid = Sid, scene = SceneId, copy_id = CopyId, guild = #status_guild{id = GuildId}} = PS,
	Node = mod_disperse:get_clusters_node(),
	case lib_scene:is_clusters_scene(SceneId) of
		true ->
			mod_clusters_node:apply_cast(?MODULE, send_war_info_do, [CopyId, [RoleId, Sid, GuildId, Node]]);
		_ ->
			send_war_info_do(CopyId, [RoleId, Sid, GuildId, Node])
	end.

send_war_info_do(FightPid, Msg) ->
	case misc:is_process_alive(FightPid) of
		true ->
			?PRINT("send_war_info_do:~p~n", [FightPid]),
			mod_territory_war_fight:send_war_info(FightPid, Msg);
		_ -> skip
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 召集会员
convene_guild_member(SceneId, CopyId, GuildId, RoleId, MonId) ->
	Node = mod_disperse:get_clusters_node(),
	case lib_scene:is_clusters_scene(SceneId) of
		true ->
			mod_clusters_node:apply_cast(?MODULE, convene_guild_member_do, [CopyId, [GuildId, RoleId, MonId, Node]]);
		_ ->
			convene_guild_member_do(CopyId, [GuildId, RoleId, MonId, Node])
	end.

convene_guild_member_do(FightPid, Msg) ->
	case misc:is_process_alive(FightPid) of
		true ->
			mod_territory_war_fight:convene_guild_member(FightPid, Msg);
		_ -> skip
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进入战斗
enter_fight_scene(PS, SceneId, PoolId, CopyId, TerritoryId, Camp, Own, BuffId) ->
	#player_status{terri_status = TerriWarStatus, guild = #status_guild{id = GuildId}} = PS,
	%% 玩家出生点
	{X, Y} = lib_territory_war_data:get_role_born(TerritoryId, Camp, Own),
	NewPS = PS#player_status{terri_status = TerriWarStatus#terri_status{territory_id = TerritoryId, camp = Camp, own = Own, buff_id = BuffId}},
	%% 切场景
	NeedOut = true,
	KeyValueList = [{action_lock, ?ERRCODE(err506_in_battle)}, {group, GuildId}, {recalc_attr, 0}, {change_scene_hp_lim, 0}],
	LastPS = lib_scene:change_scene(NewPS, SceneId, PoolId, CopyId, X, Y, NeedOut, KeyValueList),
	{ok, LastPS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 重连进入战斗
relogin_fight(PS, SceneId, PoolId, CopyId, X, Y, TerritoryId, Camp, Own) ->
	#player_status{terri_status = TerriWarStatus, guild = #status_guild{id = GuildId}} = PS,
	NewPS = PS#player_status{terri_status = TerriWarStatus#terri_status{territory_id = TerritoryId, camp = Camp, own = Own}},
	%% 切场景
	% 由于是重新登录是异步操作，这期间有可能活动关闭，所以需要先同步确认下活动状态
	case mod_territory_war:check_open(GuildId) of
		true ->
			NeedOut = false,
			KeyValueList = [{action_lock, ?ERRCODE(err506_in_battle)}, {group, GuildId}, {recalc_attr, 0}, {change_scene_hp_lim, 0}],
			LastPS = lib_scene:change_scene(NewPS, SceneId, PoolId, CopyId, X, Y, NeedOut, KeyValueList);
		false ->
			LastPS = PS
	end,
	{ok, LastPS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 切换到主城
leave_scene(RoleIdList) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, leave_fight_scene, []) || RoleId <- RoleIdList].

leave_fight_scene(PS) ->
    case is_in_territory_war(PS#player_status.scene) of
        true ->
            SceneId = 0,
            ScenePoolId = 0,
            CopyId = 0,
            NeedOut = true,
            KeyValueList = [{group, 0}, {action_free, ?ERRCODE(err506_in_battle)}, {pk, {?PK_PEACE, true}}, {recalc_attr, 0}, {change_scene_hp_lim, 0}],
            PS1 = PS#player_status{terri_status = #terri_status{}},
            NewPS = lib_scene:change_scene(PS1, SceneId, ScenePoolId, CopyId, 0, 0, NeedOut, KeyValueList),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 根据活动是否处于开启状态，判断公会的一些操作
can_guild_operating(GuildId) ->
	case catch mod_territory_war:check_open(GuildId) of
        true -> false;
        false -> true;
        _Err ->
            ?ERR("can_guild_operating err:~p", [_Err]),
            false
    end.

is_dominator_guild(GuildId) ->
	case catch mod_territory_war:is_winner(GuildId) of
        true -> true;
        _ -> false
    end.

check_start_war_local(NowTime) ->
	{StartTime, _} = lib_territory_war_data:get_territory_war_time_local(NowTime),
	StartTime.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 发放个人积分奖励
send_score_reward(TerritoryId, List) ->
	spawn(
		fun() ->
			send_score_reward_do(TerritoryId, List, 1)
		end
	).

send_score_reward_do(_TerritoryId, [], _Num) -> ok;
send_score_reward_do(TerritoryId, [{RoleId, Score, RewardStageList}|List], Num) ->
	case Num rem 20 == 0 of
		true -> timer:sleep(200);
		_ -> skip
	end,
	{ok, Bin} = pt_506:write(50600, [Score]),
	lib_server_send:send_to_uid(RoleId, Bin),
	case RewardStageList of
		[] -> send_score_reward_do(TerritoryId, List, Num);
		_ ->
			RewardList = [lib_territory_war_data:get_role_reward_cfg(TerritoryId, StageId) ||StageId <- RewardStageList],
			NewRewardList = lists:flatten(RewardList),
			%%加日志
            %add_role_log(RoleId, Score, NewRewardList, utime:unixtime()),
            Produce = #produce{type=terri_war, reward=NewRewardList, show_tips=3},
            %%发送奖励
            lib_goods_api:send_reward_by_id(Produce, RoleId),
            %% 推送新增的积分奖励列表
            lib_server_send:send_to_uid(RoleId, pt_506, 50605, [Score, RewardStageList]),
            send_score_reward_do(TerritoryId, List, Num+1)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 推送玩家积分信息
send_role_score(List) ->
	F = fun({_RoleId, Sid, Score}) ->
		{ok, Bin} = pt_506:write(50612, [Score]),
    	lib_server_send:send_to_sid(Sid, Bin)
	end,
	lists:foreach(F, List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 更改玩家的出生点
change_role_revive(TerritoryId, Camp, OwnList, RoleList) ->
	Msg = [TerritoryId, Camp, OwnList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, change_role_revive, [Msg]) || {RoleId, _} <- RoleList],
	ok.

change_role_revive(PS, [TerritoryId, Camp, OwnList]) ->
	#player_status{terri_status = TerriWarStatus} = PS,
	?PRINT("change_role_revive : ~p~n", [{TerritoryId, Camp, OwnList}]),
	NewPS = PS#player_status{terri_status = TerriWarStatus#terri_status{territory_id = TerritoryId, camp = Camp, own = OwnList}},
	{ok, NewPS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 消息广播
send_to_all(RoleList, Bin) ->
	[
		lib_server_send:send_to_sid(Sid, Bin) ||{_RoleId, Sid} <- RoleList
	],
	ok.

%% 广播轮次的时间信息
broadcast_round_time_info(IsCls, Round, RoundStartTime, RoundEndTime) ->
	{ok, Bin} = pt_506:write(50620, [Round, RoundStartTime, RoundEndTime]),
	?PRINT("broadcast_round_time_info : ~p~n", [{utime:unixtime(), Round, RoundStartTime, RoundEndTime}]),
	case IsCls == 1 of
		true ->
			mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [Bin]);
		_ ->
			lib_server_send:send_to_all(Bin)
	end.


%%加个人积分奖励日志
% add_role_log(RoleId, Score, Reward, Now) ->
%     lib_log_api:log_terri_war_score_reward(RoleId, Score, Reward, Now).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 日志
log_terri_war_result(Group, WarId, TerritoryId, Round, WinnerGuildId, GuildList) ->
	case GuildList of
		[GuildA, GuildB] ->
			#tfight_guild{guild_id = AGuildId, guild_name = AGuildName, server_id = AServerId, server_num = AServerNum, score = AScore, own = ACamp} = GuildA,
			#tfight_guild{guild_id = BGuildId, guild_name = BGuildName, server_id = BServerId, server_num = BServerNum, score = BScore, own = BCamp} = GuildB;
		[GuildA] ->
			#tfight_guild{guild_id = AGuildId, guild_name = AGuildName, server_id = AServerId, server_num = AServerNum, score = AScore, own = ACamp} = GuildA,
			BGuildId = 0, BGuildName = <<>>, BServerId = 0, BServerNum = 0, BScore = 0, BCamp = [];
		_ ->
			AGuildId = 0, AGuildName = <<>>, AServerId = 0, AServerNum = 0, AScore = 0, ACamp = [],
			BGuildId = 0, BGuildName = <<>>, BServerId = 0, BServerNum = 0, BScore = 0, BCamp = []
	end,
	lib_log_api:log_terri_war_result(
		Group, WarId, TerritoryId, Round, WinnerGuildId, AGuildId, AGuildName, AServerId, AServerNum, AScore, ACamp,
		BGuildId, BGuildName, BServerId, BServerNum, BScore, BCamp).

trans_to_terri_role(PS) ->
	#player_status{
		id = RoleId, sid = Sid, server_id = ServerId, server_num = _ServerNum,
		figure = #figure{name = RoleName, sex = Sex, career = Career, lv = Lv, realm = Realm, picture = Pic, picture_ver = PicVer, turn = Turn},
		guild= #status_guild{id = GuildId}
	} = PS,
	Node = mod_disperse:get_clusters_node(),
	TWarFigure = #twar_figure{
		sex = Sex,
		realm = Realm,
		career = Career,
		lv = Lv,
		picture = Pic,
		picture_ver = PicVer,
        turn = Turn
	},
	#tfight_role{
		role_id = RoleId,
		sid = Sid,
		guild_id = GuildId,
		name = RoleName,
		twar_figure = TWarFigure,
	    node = Node,
	    server_id = ServerId,
	    enter_time = utime:unixtime()
	}.

get_date_id() ->
    {{Y, M, D}, _} = calendar:local_time(),
    Y*10000+M*100+D.

get_role_buff(WinNum) ->
	data_territory_war:get_buff_id(WinNum).

count_terri_war_attr(PS) ->
    #player_status{terri_status = TerriWarStatus} = PS,
    case TerriWarStatus of
        #terri_status{buff_id = BuffId} ->
            Attr = data_territory_war:get_buff_attr(BuffId),
            Attr;
        _ -> []
    end.

is_in_territory_war(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = ?SCENE_TYPE_GWAR} -> true;
		_ -> false
	end.

add_guild_chief_buff(GuildId) ->
    ChiefId = mod_guild:get_guild_chief(GuildId),
    add_chief_buff(ChiefId).

delete_guild_chief_buff(GuildId) ->
    ChiefId = mod_guild:get_guild_chief(GuildId),
    delete_chief_buff(ChiefId).

add_chief_buff(RoleId) ->
	SkillBuffId = data_territory_war:get_cfg(?TERRI_KEY_8),
    lib_goods_buff:add_goods_buff(RoleId, SkillBuffId, 1, []).

delete_chief_buff(RoleId) ->
    lib_mail_api:send_sys_mail([RoleId], utext:get(5060016), utext:get(5060017), []),
    lib_goods_buff:remove_goods_buff_by_type(RoleId, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE).


apply_cast(IsCls, Node, M, F, A) ->
	case IsCls == 1 of
		true ->
			mod_clusters_center:apply_cast(Node, M, F, A);
		_ ->
			apply(M, F, A)
	end.

gm_quit(QuitType, RoleIdListStr) ->
    case QuitType of
        0 -> RoleIdList = [OnlineRole#ets_online.id ||OnlineRole <- ets:tab2list(?ETS_ONLINE)];
        _ -> RoleIdList = util:string_to_term(RoleIdListStr)
    end,
    [
      lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_quit, [])  || RoleId <- RoleIdList
    ].

gm_quit(PS) ->
    case is_in_territory_war(PS#player_status.scene) of
        true ->
            #player_status{
                id = RoleId, guild= #status_guild{id = GuildId}
            } = PS,
            Node = mod_disperse:get_clusters_node(),
            mod_territory_war:leave_war([RoleId, GuildId, Node]),
            PS;
        _ ->
            PS
    end.
