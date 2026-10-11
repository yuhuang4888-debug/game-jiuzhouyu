%% ---------------------------------------------------------------------------
%% @doc lib_guild_dun.erl

%% @author  lxl
%% @email  
%% @since  2018-10-17
%% @deprecated 玩家进程
%% ---------------------------------------------------------------------------
-module(lib_guild_dun).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("guild_dun.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("attr.hrl").

%% 死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
    #player_status{scene = SceneId, copy_id = CopyId}=Player,
    case in_guild_dun_scene(SceneId) andalso misc:is_process_alive(CopyId) of
        true -> 
            mod_guild_dun_fight:apply_cast(CopyId, {player_die, []}),
            {ok, Player};
        false -> 
            {ok, Player}
    end;

handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 秘境中重连
reconnect(PS, _) ->
	#player_status{id = RoleId, scene = SceneId}=PS,
    case in_guild_dun_scene(SceneId) of
        true -> 
            mod_guild_dun_mgr:apply_cast({mod, reconnect, [RoleId]}),
            {ok, PS};
        false -> 
            {next, PS}
    end.

%% 离开公会
quit_guild(RoleId, _GuildId) -> 
	mod_guild_dun_mgr:apply_cast({mod, quit_guild, [RoleId]}).
%% 加入公会
join_guild(RoleId, GuildId) ->
	mod_guild_dun_mgr:apply_cast({mod, join_guild, [RoleId, GuildId]}).

%% 查询秘境结束时间
send_guild_dun_endtime(PS) ->
	#player_status{id = RoleId, sid = Sid, scene = SceneId, copy_id = CopyId} = PS,
	case in_guild_dun_scene(SceneId) andalso misc:is_process_alive(CopyId) of 
		true -> 
			mod_guild_dun_fight:apply_cast(CopyId, {send_guild_dun_endtime, [RoleId, Sid]});
		_ -> ok
	end.

%% 挑战
enter_challenge(PS, Door) ->
	#player_status{id = RoleId, sid = Sid, figure = Figure, guild = #status_guild{id = GuildId}} = PS,
	case lib_player_check:check_list(PS, [action_free, is_transferable]) of
        true ->
            mod_guild_dun_mgr:apply_cast({mod, enter_challenge, [RoleId, GuildId, Sid, Figure, Door]}),
            none;
        {false, ErrCode} -> ErrCode
    end.

%% 离开挑战
leave_challenge(PS) ->
	#player_status{id = _RoleId, sid = _Sid, scene = SceneId, copy_id = CopyId} = PS,
	case in_guild_dun_scene(SceneId) andalso misc:is_process_alive(CopyId) of 
		true -> 
			mod_guild_dun_fight:apply_cast(CopyId, {player_leave, []});
		_ -> ok
	end.

handle_result_win(RoleId, Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, Reward) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		Pid when is_pid(Pid) ->
			lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, handle_result_win, [Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, Reward]);
		_ ->
			Produce = #produce{type = guild_dun_challenge, reward = Reward, title = utext:get(203), content = utext:get(204)},
			lib_goods_api:send_reward_with_mail(RoleId, Produce)
	end;
handle_result_win(PS, Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, Reward) when is_record(PS, player_status) ->
	F = fun(Value, L) ->
		case Value of 
			{?TYPE_GOODS, GoodsId, Num} ->
				case data_goods_type:get(GoodsId) of 
					#ets_goods_type{type = ?GOODS_TYPE_GIFT} ->
						case lib_gift_new:get_gift_goods(PS, GoodsId, Num) of 
							{true, GiftList, _} -> GiftList ++ L;
							_ -> [Value|L]
						end;
					_ -> [Value|L]
				end;
			_ -> [Value|L]
		end
	end,
	RewardList = lists:foldl(F, [], Reward),
	Produce = #produce{type = guild_dun_challenge, reward = RewardList},
	NewPS = lib_goods_api:send_reward(PS, Produce),
	{ok, Bin} = pt_400:write(40055, [Type, Level, Door, NotifyTimes, IsWin, ScoreAdd, RewardList]),
	lib_server_send:send_to_sid(PS#player_status.sid, Bin),
	{ok, NewPS}.


%% 是否在秘境场景
in_guild_dun_scene(SceneId) ->
	_SceneList = data_guild_dun:get_scene_list(),
	SceneList = [ Scene || Scene <- _SceneList, Scene > 0],
	lists:member(SceneId, SceneList).

%% 获取秘境场景id
get_challenge_scene(_RoleId, Type, _Door, _LevelInfo) ->
	[{SceneId, _}] = data_guild_dun:get_born_info(Type),
	case Type of 
		2 -> {SceneId, 0};
		_ -> {SceneId, 0}
	end.

%% 获取秘境场景挑战对象
create_challenge_mon(_RoleId, Type, _Door, LevelInfo, SceneId, PoolId, CopyId) ->
	case Type of 
		2 -> CreateMonId = create_mon(SceneId, PoolId, CopyId, LevelInfo, Type);
		_ -> CreateMonId = create_dummy(SceneId, PoolId, CopyId, LevelInfo, Type)
	end,
	CreateMonId.

create_mon(SceneId, PoolId, CopyId, LevelInfo, Type) ->
	#level_info{level = Level} = LevelInfo,
	OpenDay = util:get_open_day(),
	[{_, Location}] = data_guild_dun:get_born_info(Type),
	[_, {X, Y}] = Location,
	[{MonId, _}] = data_guild_dun:get_challenge_target(Level),
	AttrCoef = data_guild_dun:get_mon_attr_coef(OpenDay),
	MonAttr = case data_mon:get(MonId) of
		[] -> [];
		#mon{
			hp_lim = HpLim, att = Att, hit = Hit, dodge = Dodge, crit = Crit, def = Def, ten = Ten, wreck = Wreck, 
			speed = Speed
		} ->
			_Attr = #attr{
				hp = round(HpLim*(AttrCoef/100)),
				att = round(Att*(AttrCoef/100)), hit = round(Hit*(AttrCoef/100)), 
				dodge = round(Dodge*(AttrCoef/100)), crit = round(Crit*(AttrCoef/100)), 
				def = round(Def*(AttrCoef/100)), ten = round(Ten*(AttrCoef/100)), wreck = round(Wreck*(AttrCoef/100)), 
				speed = Speed
			}		
	end,
	Args = [{group, 2}, {attr_replace, MonAttr}, {die_handler, {?MODULE, mon_die, []}}],
	CreateMonId = lib_mon:sync_create_mon(MonId, SceneId, PoolId, X, Y, 1, CopyId, 1, Args),
	CreateMonId.

create_dummy(SceneId, PoolId, CopyId, LevelInfo, Type) ->
	#level_info{level = _Level, challenge_info = ChallengeInfo} = LevelInfo,
	#{target_id := _TargetId, figure := Figure, battle_attr := BattleAttr, skill := Skill, combat_power := CombatPower} = ChallengeInfo,
	[{_, Location}] = data_guild_dun:get_born_info(Type),
	[_, {X, Y}] = Location,
	DummyArgs = [{figure, Figure}, {battle_attr, BattleAttr#battle_attr{combat_power = CombatPower}}, {skill, Skill}, {die_handler, {?MODULE, dummy_die, []}},
        {group, 2}, {warning_range, 1000}, {find_target, 2500}],
    CreateMonId = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, PoolId, X, Y, 1, CopyId, 1, DummyArgs),
    CreateMonId.

mon_die(Minfo, _Klist, _Atter, _AtterSign, _DArgs) ->
	#scene_object{scene = SceneId, copy_id = CopyId} = Minfo,
	case in_guild_dun_scene(SceneId) andalso misc:is_process_alive(CopyId) of 
		true ->
			mod_guild_dun_fight:apply_cast(CopyId, {target_die, []});
		_ -> ok
	end.

dummy_die(SceneObject, _Klist, _Atter, _AtterSign, []) ->
	#scene_object{scene = SceneId, copy_id = CopyId} = SceneObject,
	case in_guild_dun_scene(SceneId) andalso misc:is_process_alive(CopyId) of 
		true ->
			mod_guild_dun_fight:apply_cast(CopyId, {target_die, []});
		_ -> ok
	end.

%% 获取挑战胜利奖励
get_win_reward(Level, Type, RoleLv) ->
	%WorldLv = util:get_world_lv(),
	case data_guild_dun:get_level_challenge_cfg(Level) of 
		#base_guild_dun_level_challenge{score_add = ScoreAdd} -> ok;
		_ -> ScoreAdd = 0
	end,
	case data_guild_dun:get_level_challenge_reward(Level, RoleLv) of 
		[StableReward, RandReward, RandReward2] ->
			_StableReward = get_stable_reward_by_type(StableReward, Type),
			_RandReward = get_rand_reward_by_type(RandReward, Type),
			_RandReward2 = get_rand_reward_by_type(RandReward2, Type),
			WinReward = _StableReward ++ _RandReward ++ _RandReward2;
		_ -> WinReward = []
	end,
	{ScoreAdd, WinReward}.

%% StableReward: [{type, reward_list}]
get_stable_reward_by_type(StableReward, Type) ->
	case lists:keyfind(Type, 1, StableReward) of 
		{_, RewardList} when is_list(RewardList) -> RewardList;
		_ -> []
	end.
%% StableReward: [{type, reward_num, [{weight, goodstype, id, num}]}]
get_rand_reward_by_type(RandReward, Type) ->
	case lists:keyfind(Type, 1, RandReward) of 
		{_, RewardNum, RandList} ->
			F = fun(_I, {NewRandList, List}) ->
				{_W, GType, GTypeId, GNum} = util:find_ratio(NewRandList, 1),
				case GNum > 0 of 
					true -> 
						LastRandList = NewRandList,
						LastList = [{GType, GTypeId, GNum}|List];
					_ ->
						LastRandList = NewRandList,
						LastList = List
				end,
				{LastRandList, LastList}
			end,
			{_, RewardList} = lists:foldl(F, {RandList, []}, lists:seq(1, RewardNum)),
			RewardList;
		_ -> []
	end.

can_guild_operating(RoleId) ->
	case catch mod_guild_dun_mgr:apply_call({mod, get_role_state, [RoleId]}, 2000) of 
        {ok, ?ROLE_STATE_FREE} -> true;
        {ok, ?ROLE_STATE_FIGHT} -> false;
        _Err ->
            false
    end.

db_select_guild_dun_role() ->
	Sql = io_lib:format(?sql_role_info_select, []),
	db:get_all(Sql).

db_replace_guild_dun_role(RoleInfo) ->
	#role_info{
		role_id = RoleId, guild_id = GuildId, level = Level, challenge_times = ChallengeTimes, 
		notify_times = NotifyTimes, dun_score = DunScore, create_time = CreateTime
	} = RoleInfo,
	DunScoreB = util:term_to_bitstring(DunScore),
	Sql = io_lib:format(?sql_role_info_replace, [RoleId, GuildId, Level, ChallengeTimes, NotifyTimes, DunScoreB, CreateTime]),
	db:execute(Sql).

db_delete_guild_dun_role() ->
	Sql = io_lib:format(?sql_role_info_delete_all, []),
	db:execute(Sql).

db_delete_guild_dun_role_expire(Time) ->
	Sql = io_lib:format(?sql_role_info_delete_expire, [Time]),
	db:execute(Sql).

db_select_guild_dun_guild() ->
	Sql = io_lib:format(?sql_guild_info_select, []),
	db:get_all(Sql).

db_replace_guild_dun_guild(GuildInfo) ->
	#guild_info{guild_id = GuildId, dun_score = DunScore, create_time = CreateTime} = GuildInfo,
	Sql = io_lib:format(?sql_guild_info_replace, [GuildId, DunScore, CreateTime]),
	db:execute(Sql).

db_delete_guild_dun_guild() ->
	Sql = io_lib:format(?sql_guild_info_delete_all, []),
	db:execute(Sql).

db_delete_guild_dun_guild_expire(Time) ->
	Sql = io_lib:format(?sql_guild_info_delete_expire, [Time]),
	db:execute(Sql).