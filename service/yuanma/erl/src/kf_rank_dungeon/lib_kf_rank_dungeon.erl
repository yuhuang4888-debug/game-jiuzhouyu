% %% ---------------------------------------------------------------------------
% %% @doc lib_kf_rank_dungeon
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(lib_kf_rank_dungeon).

-compile(export_all).
-include("kf_rank_dungeon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("guild.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("goods.hrl").

%% 进入副本检查
dunex_check_extra(PS, #dungeon{id = DunId, type = DunType} = _Dun) ->
    case DunType == ?DUNGEON_TYPE_RANK_KF of
        true -> %% 
        	Level = trans_to_dun_level(DunId),
        	case Level > 0 of 
        		true ->
        			case rank_dungeon_open(PS) of 
        				true ->
				            case mod_kf_rank_dungeon_local:enter_dungeon_check([PS#player_status.id, Level]) of 
				            	true -> true;
				            	{false, Res} -> {false, Res}
				            end;
				        _ ->
				        	{false, ?FAIL}
				    end;
		        _ ->
		        	{false, ?MISSING_CONFIG}
		    end;
        _ ->
            true
    end.

%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
	#player_status{
		id = RoleId, server_id = ServerId, server_num = ServerNum,
		figure = #figure{name = RoleName, lv = Lv, career = Career, sex = Sex, turn = Turn, picture = Pic, picture_ver = PicVer}
	} = PS,
    #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, start_time_ms = StartTimeMs, story_play_time_mi = StoryPlayMs, result_time_ms = ResultTimeMs} = Data,
    Level = trans_to_dun_level(DunId),
    case DunType == ?DUNGEON_TYPE_RANK_KF andalso Level > 0 of 
    	true ->
    		RoleArgs = [RoleId, ServerId, ServerNum, RoleName, Lv, Career, Sex, Turn, Pic, PicVer],
    		NewPassTime = max(ResultTimeMs - StartTimeMs - StoryPlayMs, 100),
    		?PRINT("EVENT_DUNGEON_SUCCESS StartTimeMs:~p~n", [{StartTimeMs}]),
    		?PRINT("EVENT_DUNGEON_SUCCESS ResultTimeMs:~p~n", [{ResultTimeMs}]),
    		?PRINT("EVENT_DUNGEON_SUCCESS NewPassTime:~p~n", [{NewPassTime, StoryPlayMs}]),
    		mod_kf_rank_dungeon_local:dungeon_succ([RoleArgs, Level, NewPassTime]);
    	_ ->
    		skip
    end,
    {ok, PS};
%% 副本失败
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_FAIL, data = Data}) ->
	#player_status{
		id = RoleId
	} = PS,
    #callback_dungeon_fail{dun_id = DunId, dun_type = DunType, start_time_ms = StartTimeMs, story_play_time_mi = StoryPlayMs, result_time_ms = ResultTimeMs} = Data,
    Level = trans_to_dun_level(DunId),
    case DunType == ?DUNGEON_TYPE_RANK_KF andalso Level > 0 of 
    	true ->
    		NewPassTime = max(ResultTimeMs - StartTimeMs - StoryPlayMs, 100),
    		send_dungeon_settlement(0, RoleId, Level, NewPassTime, 0, 0);
    	_ ->
    		skip
    end,
    {ok, PS};
%% 玩家改名
handle_event(PS, #event_callback{type_id = ?EVENT_RENAME}) ->
	#player_status{
		id = RoleId, figure = #figure{name = RoleName}
	} = PS,
    mod_kf_rank_dungeon_local:rename([RoleId, RoleName]),
    {ok, PS};
%% 更改头像
handle_event(PS, #event_callback{type_id = ?EVENT_PICTURE_CHANGE}) when is_record(PS, player_status) ->
    #player_status{id = RoleId, figure = #figure{picture = Picture, picture_ver = PictureVer}} = PS,
    mod_kf_rank_dungeon_local:role_attr_change({RoleId, [{picture, Picture, PictureVer}]}),
    {ok, PS};
%% 转生
handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) when is_record(PS, player_status) ->
    #player_status{id = RoleId, figure = #figure{turn = Turn}} = PS,
    mod_kf_rank_dungeon_local:role_attr_change({RoleId, [{turn, Turn}]}),
    {ok, PS};
handle_event(PS, _) ->
	{ok, PS}.


%% 发送结算: 成功
send_dungeon_settlement(1, RoleId, Level, GoTime, IsChallenger, IsFirstSucc) ->
    case IsFirstSucc of 
        1 -> %% 今天第一次通关
            case data_rank_dungeon:get_rank_dungeon_cfg(Level) of 
                #base_rank_dungeon{reward = Reward} -> Reward;
                _ -> Reward = []
            end;
        _ ->
            Reward = []
    end,
    case Reward == [] of 
    	true -> skip;
    	_ ->
    		Produce = #produce{type = kf_rank_dungeon, reward = Reward, show_tips = ?SHOW_TIPS_4},
            lib_goods_api:send_reward_with_mail(RoleId, Produce)
    end,
    {ok, Bin} = pt_507:write(50705, [1, Level, GoTime, IsChallenger, Reward]),
	lib_server_send:send_to_uid(RoleId, Bin);
%% 发送结算: 失败
send_dungeon_settlement(_, RoleId, Level, GoTime, _IsChallenger, _IsFirstSucc) ->
	{ok, Bin} = pt_507:write(50705, [0, Level, GoTime, 0, []]),
	lib_server_send:send_to_uid(RoleId, Bin).

send_challenger_reward(RoleList) ->
	spawn(fun() ->
		F = fun({RoleId, Level}) ->
			Title = utext:get(5070001),
			Content = utext:get(5070002, [Level]),
			Reward = get_challenger_reward(Level),
			lib_log_api:log_rdungeon_challengers_reward(RoleId, Level, Reward),
			lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
			timer:sleep(20)
		end,
		lists:foreach(F, RoleList)
	end),
	ok.

%% 单人排行本最高层数
get_dungeon_max_level() ->
	data_rank_dungeon:get_max_level().

%% 层数所属的区间
get_area_by_level(0) -> 0;
get_area_by_level(Level) ->
	(Level - 1) div ?LEVEL_NUM_ONE_AREA + 1.

%% 获取一个区间的层数列表
get_level_list_by_area(Area) ->
	{LevelLow, LevelUp} = get_level_range(Area),
	lists:reverse(lists:seq(LevelLow, LevelUp)).

%% 获取一个区间的层数范围
get_level_range(Area) ->
	{Area * ?LEVEL_NUM_ONE_AREA - 9, Area * ?LEVEL_NUM_ONE_AREA}.

%% 是否是同一个区间
is_same_area(Level1, Level2) ->
	get_area_by_level(Level1) == get_area_by_level(Level2).

%% 玩家是否是某个层数段的擂主
is_challengers_in_high_level(RoleId, Level, AreaLevelMax, ChallengerMap) when Level =< AreaLevelMax ->
	case maps:get(Level, ChallengerMap, 0) of 
		#level_challenger{role_id = RoleId1} when RoleId == RoleId1 ->
			true;
		_ ->
			is_challengers_in_high_level(RoleId, Level + 1, AreaLevelMax, ChallengerMap)
	end;
is_challengers_in_high_level(_RoleId, _Level, _AreaLevelMax, _ChallengerMap) ->
	false.

%% 获取每日奖励
get_daily_reward(Level) ->
	case data_rank_dungeon:get_rank_dungeon_daily(Level) of 
		#base_rank_dungeon_daily{reward = Reward} -> Reward;
		_ -> 
			?ERR("get_daily_reward miss config Level : ~p~n", [Level]),
			none
	end.

%% 获取擂主奖励
get_challenger_reward(Level) ->
	case data_rank_dungeon:get_rank_dungeon_cfg(Level) of 
		#base_rank_dungeon{challenger_reward = ChallengerReward} -> 
			ChallengerReward;
		_ -> []
	end.

%% 副本id对应的层数
trans_to_dun_level(DunId) ->
	Level = data_rank_dungeon:get_rank_dungeon_level(DunId),
	Level.

%% 每天重置时的开始层数
get_start_level(0) -> 1;
get_start_level(MaxLevel) ->
	((MaxLevel - 1) div ?LEVEL_NUM_ONE_AREA) * ?LEVEL_NUM_ONE_AREA + 1.

%% 获取当前最高通关层数
get_max_level(LDungeonList) ->
	case LDungeonList of 
		[{MaxLevel, _, _}|_] -> MaxLevel;
		_ -> 1
	end.

get_player_cur_max_level(PS) ->
	case catch mod_kf_rank_dungeon_local:get_player_cur_max_level([PS#player_status.id]) of 
		{ok, MaxLevel} ->
			{ok, MaxLevel};
		_Err ->
			{false, ?ERRCODE(system_busy)}
	end.

%% 查找role_id作为擂主的层数
get_challenger_level_by_role(ChallengerMap, RoleId) ->
	get_challenger_level_by_role_do(maps:values(ChallengerMap), RoleId).

get_challenger_level_by_role_do([], _RoleId) -> 0;
get_challenger_level_by_role_do([#level_challenger{level = Level, role_id = RoleId}|_LevelChallengerList], RoleId) ->
	Level;
get_challenger_level_by_role_do([_|LevelChallengerList], RoleId) ->	
	get_challenger_level_by_role_do(LevelChallengerList, RoleId).


make(rdungeon_role, [RoleId, StartLevel, RwState, Time, LDungeonList]) ->
	#rdungeon_role{
        role_id = RoleId
        , start_level = StartLevel
        , rw_state = RwState
        , time = Time 
        , ldungeon_list = LDungeonList         
    };
make(kf_rdungeon_role, [RoleId, Name, ServerId, ServerNum, RoleLv, Career, Sex, Turn, Pic, PicVer, LDungeonList]) ->
	#kf_rdungeon_role{
        role_id = RoleId        % 擂主id
        , name = Name
        , server_id = ServerId
        , server_num = ServerNum
        , lv = RoleLv
        , career = Career
        , sex = Sex
        , turn = Turn
        , pic = Pic
        , pic_ver = PicVer
        , ldungeon_list = LDungeonList
    };
make(_, _) ->
	error.

rank_dungeon_open(PS) ->
	case PS#player_status.figure#figure.lv >= 420 of
		true -> util:get_open_day() >= 28;
		_ -> false
	end.

%% 根据联立rank_dun_role表与player_state
fix_kf_rank_dun_role() ->
	Sql = <<"select rank_dun_role.role_id, rank_dun_role.start_level, player_state.last_combat_power from rank_dun_role left join player_state on (rank_dun_role.role_id = player_state.id)">>,
	List = db:get_all(Sql),
	case List of
		[] ->
			skip;
		_ ->
			SqlTime = utime:unixdate() + 3600 * 4,
			Fun = fun([RoleId, StartLevel, MaxPower], AccList) ->
				PowerDunId = get_dun_id(MaxPower),
				CalcNum = ?IF(PowerDunId == 0, PowerDunId, PowerDunId rem 35000),
				FixStartLevel = lib_kf_rank_dungeon:get_start_level(CalcNum),
				case FixStartLevel =< StartLevel of
					true ->
						[[RoleId, FixStartLevel, 0, SqlTime, util:term_to_bitstring([])]|AccList];
					false ->
						AccList
				end
			end,
			UpDbList = lists:foldl(Fun, [], List),
			UpdLen = length(UpDbList),
			fix_db_data(UpDbList, UpdLen),
			supervisor:terminate_child(gsrv_sup, {mod_kf_rank_dungeon_local, start_link, []}),
			supervisor:restart_child(gsrv_sup, {mod_kf_rank_dungeon_local, start_link, []})
	end.



fix_db_data(UpDbList, UpLen) when UpLen > 200 ->
	{DealArgs, LeftArgs} = lists:split(200, UpDbList),
	db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], DealArgs)),
	timer:sleep(200),
	fix_db_data(LeftArgs, length(LeftArgs));
fix_db_data(UpDbList, _) when UpDbList =/= [] ->
	db:execute(usql:replace(rank_dun_role, [role_id, start_level, rw_state, time, ldungeon_list], UpDbList));
fix_db_data(_, _) ->
	skip.

get_dun_id(Power) when Power >= 1128800000	->35100;
get_dun_id(Power) when Power >= 1066064516	->35099;
get_dun_id(Power) when Power >= 1032750000	->35098;
get_dun_id(Power) when Power >= 976727273		->35097;
get_dun_id(Power) when Power >= 948000000		->35096;
get_dun_id(Power) when Power >= 897600000		->35095;
get_dun_id(Power) when Power >= 850000000		->35094;
get_dun_id(Power) when Power >= 827027027		->35093;
get_dun_id(Power) when Power >= 783789474		->35092;
get_dun_id(Power) when Power >= 763692308		->35091;
get_dun_id(Power) when Power >= 724200000		->35090;
get_dun_id(Power) when Power >= 686634146		->35089;
get_dun_id(Power) when Power >= 670285714		->35088;
get_dun_id(Power) when Power >= 635720930		->35087;
get_dun_id(Power) when Power >= 621272727		->35086;
get_dun_id(Power) when Power >= 589333333		->35085;
get_dun_id(Power) when Power >= 558782609		->35084;
get_dun_id(Power) when Power >= 546893617		->35083;
get_dun_id(Power) when Power >= 518500000		->35082;
get_dun_id(Power) when Power >= 507918367		->35081;
get_dun_id(Power) when Power >= 481440000		->35080;
get_dun_id(Power) when Power >= 456000000		->35079;
get_dun_id(Power) when Power >= 447230769		->35078;
get_dun_id(Power) when Power >= 423396226		->35077;
get_dun_id(Power) when Power >= 415555556		->35076;
get_dun_id(Power) when Power >= 393163636		->35075;
get_dun_id(Power) when Power >= 371571429		->35074;
get_dun_id(Power) when Power >= 365052632		->35073;
get_dun_id(Power) when Power >= 344689655		->35072;
get_dun_id(Power) when Power >= 333200000		->35071;
get_dun_id(Power) when Power >= 309290323		->35070;
get_dun_id(Power) when Power >= 286875000		->35069;
get_dun_id(Power) when Power >= 278181818		->35068;
get_dun_id(Power) when Power >= 264000000		->35067;
get_dun_id(Power) when Power >= 256457143		->35066;
get_dun_id(Power) when Power >= 243666667		->35065;
get_dun_id(Power) when Power >= 231567568		->35064;
get_dun_id(Power) when Power >= 225473684		->35063;
get_dun_id(Power) when Power >= 214461538		->35062;
get_dun_id(Power) when Power >= 209100000		->35061;
get_dun_id(Power) when Power >= 199024390		->35060;
get_dun_id(Power) when Power >= 189428571		->35059;
get_dun_id(Power) when Power >= 185023256		->35058;
get_dun_id(Power) when Power >= 176181818		->35057;
get_dun_id(Power) when Power >= 172266667		->35056;
get_dun_id(Power) when Power >= 164086957		->35055;
get_dun_id(Power) when Power >= 156255319		->35054;
get_dun_id(Power) when Power >= 153000000		->35053;
get_dun_id(Power) when Power >= 145714286		->35052;
get_dun_id(Power) when Power >= 142800000		->35051;
get_dun_id(Power) when Power >= 133384615		->35050;
get_dun_id(Power) when Power >= 124666667		->35049;
get_dun_id(Power) when Power >= 120214286		->35048;
get_dun_id(Power) when Power >= 112551724		->35047;
get_dun_id(Power) when Power >= 108800000		->35046;
get_dun_id(Power) when Power >= 102000000		->35045;
get_dun_id(Power) when Power >= 95625000		->35044;
get_dun_id(Power) when Power >= 92727273		->35043;
get_dun_id(Power) when Power >= 87000000		->35042;
get_dun_id(Power) when Power >= 84514286		->35041;
get_dun_id(Power) when Power >= 79333333		->35040;
get_dun_id(Power) when Power >= 74432432		->35039;
get_dun_id(Power) when Power >= 72473684		->35038;
get_dun_id(Power) when Power >= 68000000		->35037;
get_dun_id(Power) when Power >= 66300000		->35036;
get_dun_id(Power) when Power >= 62195122		->35035;
get_dun_id(Power) when Power >= 58285714		->35034;
get_dun_id(Power) when Power >= 56930233		->35033;
get_dun_id(Power) when Power >= 53318182		->35032;
get_dun_id(Power) when Power >= 52133333		->35031;
get_dun_id(Power) when Power >= 48782609		->35030;
get_dun_id(Power) when Power >= 45574468		->35029;
get_dun_id(Power) when Power >= 44625000		->35028;
get_dun_id(Power) when Power >= 42673469		->35027;
get_dun_id(Power) when Power >= 41820000		->35026;
get_dun_id(Power) when Power >= 40000000		->35025;
get_dun_id(Power) when Power >= 38250000		->35024;
get_dun_id(Power) when Power >= 37528302		->35023;
get_dun_id(Power) when Power >= 35888889		->35022;
get_dun_id(Power) when Power >= 35236364		->35021;
get_dun_id(Power) when Power >= 33696429		->35020;
get_dun_id(Power) when Power >= 32210526		->35019;
get_dun_id(Power) when Power >= 31655172		->35018;
get_dun_id(Power) when Power >= 30254237		->35017;
get_dun_id(Power) when Power >= 29750000		->35016;
get_dun_id(Power) when Power >= 28426230		->35015;
get_dun_id(Power) when Power >= 27145161		->35014;
get_dun_id(Power) when Power >= 26714286		->35013;
get_dun_id(Power) when Power >= 25500000		->35012;
get_dun_id(Power) when Power >= 25107692		->35011;
get_dun_id(Power) when Power >= 23954545		->35010;
get_dun_id(Power) when Power >= 22835821		->35009;
get_dun_id(Power) when Power >= 22500000		->35008;
get_dun_id(Power) when Power >= 21434783		->35007;
get_dun_id(Power) when Power >= 21128571		->35006;
get_dun_id(Power) when Power >= 20112676		->35005;
get_dun_id(Power) when Power >= 19125000		->35004;
get_dun_id(Power) when Power >= 18863014		->35003;
get_dun_id(Power) when Power >= 17918919		->35002;
get_dun_id(Power) when Power >= 17680000		->35001;
get_dun_id(_)	-> 0.