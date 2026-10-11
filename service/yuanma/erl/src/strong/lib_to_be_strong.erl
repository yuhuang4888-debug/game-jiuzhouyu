%% ---------------------------------------------------------------------------
%% @doc 我要变强
%% @author xlh
%% @since  2019-01-12
%% @deprecated 基础函数
%% ---------------------------------------------------------------------------
-module(lib_to_be_strong).

-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("strong.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("def_vip.hrl").
-include("jjc.hrl").
-include("boss.hrl").
-include("task.hrl").
-include("pray.hrl").
-include("sea_treasure.hrl").
-include("daily.hrl").

-export([
	daily_reset/2
	,update_data/4
	,update_data/3
	,get_limit_ids/0
	,login/3
	,handle_event/2
	,test/0
	]).

-export([
	update_data_boss/2
	,update_data_guild_act/1
	,update_data_task/4
	,update_data_pray/2
	,update_data_guild_war/1
	,update_data_sea_treasure_gold/2
	,update_data_sea_treasure_exp/2
	,update_data_diamond/1
	,update_data_jjc/1
	,update_data_nine/1
	,update_data_by_duntype/5
	]).

login(RoleId, LoginTime, RoleLv) ->
	OpenLv = lib_module:get_open_lv(?MOD_TO_BE_STRONG, 1),
	if
		OpenLv =< RoleLv ->
			List = db_select(RoleId),
			Ids = get_limit_ids(),
			Fun = fun([Id, State, Time], {MapAcc, Acc}) ->
				Clock = get_clear_time(Id),
				if
					Clock == ?FOUR ->
						IsSameDay = utime_logic:is_logic_same_day(LoginTime, Time);
					true ->
						IsSameDay = utime:is_same_day(LoginTime, Time)
				end,
				case lists:keyfind(Id, 1, Ids) of
					{Id, Type, Lv} when IsSameDay == true ->
						StrongState = #strong_state{id = Id, state = State, time = Time, type = Type, lv = Lv},
						{maps:put(Id, StrongState, MapAcc), Acc};
					_ ->
						{MapAcc, [Id|Acc]}
				end
			end,
			{NewMap, DeleteList} = lists:foldl(Fun, {#{}, []}, List),
			DeleteList =/= [] andalso db:execute(
		        io_lib:format(
		            list_to_binary(
		                "delete from `to_be_strong` " ++ usql:condition({id, in, DeleteList}) ++ " and `role_id` = ~p"
		            ), 
		        [RoleId])
		    ),
			#to_strong_status{state_map = NewMap};
		true ->
			#to_strong_status{state_map = #{}}
	end.
	

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Player, player_status) ->
    {ok, Player};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 0点清理在线玩家数据
daily_reset(Player, ClearType) ->
	#player_status{id = RoleId, strong_status = StrongStatus} = Player,
	#to_strong_status{state_map = StateMap} = StrongStatus,
	NewMap = daily_reset_core(ClearType, StateMap, RoleId),
	NewStrongStatus = StrongStatus#to_strong_status{state_map = NewMap},
	Player#player_status{strong_status = NewStrongStatus}.

daily_reset_core(ClearType, StateMap, RoleId) -> 
	LimitIdList = get_limit_ids(),
	Fun = fun({StrongId, _, _}, {AccMap, Acc}) ->
		Clock = get_clear_time(StrongId),
		if
			Clock == ClearType ->
				Map = maps:remove(StrongId, AccMap),
				AccN = [StrongId|Acc],
				{Map, AccN};
			true -> {AccMap, Acc}
		end	
	end,
	{NewMap, DeleteList} = lists:foldl(Fun, {StateMap, []}, LimitIdList),
	DeleteList =/= [] andalso db:execute(
        io_lib:format(
            list_to_binary(
                "delete from `to_be_strong` " ++ usql:condition({id, in, DeleteList}) ++ " and `role_id` = ~p"
            ), 
        [RoleId])
    ),
    NewMap.

test() ->
	LimitIdList = get_limit_ids(),
	[begin Clock = get_clear_time(StrongId), {StrongId, Clock} end ||{StrongId, _, _} <- LimitIdList].


%% 更新内存及数据库
update_data(Player, RoleId, [StrongId|T], State) when is_record(Player, player_status) ->
	#player_status{strong_status = StrongStatus, figure = Figure} = Player,
	#figure{lv = RoleLv} = Figure,
	OpenLv = lib_module:get_open_lv(?MOD_TO_BE_STRONG, 1),
	if
		RoleLv >= OpenLv ->
			Time = utime:unixtime(),
			%% 因为要处理离线情况，又不想加载离线玩家数据到内存所以在这里判断下record是否存在，
			%% 登陆时一定会有该record，没有表示离线可以直接写入数据库
			case StrongStatus of 
				#to_strong_status{state_map = Map} ->
					List = maps:to_list(Map),
					case lists:keyfind(StrongId, 1, List) of
						#strong_state{id = StrongId} ->
							NewPs = Player;
						_ ->
							Ids = get_limit_ids(),
							case lists:keyfind(StrongId, 1, Ids) of
								{StrongId, Type, Lv} when RoleLv >= Lv ->
									StrongState = #strong_state{id = StrongId, state = State, time = Time, type = Type, lv = Lv},
									NewMap = maps:put(StrongId, StrongState, Map);
								_ ->
									NewMap = StrongStatus#to_strong_status.state_map
							end,
							db_update(RoleId, StrongId, State, Time),
							NewStrongStatus = StrongStatus#to_strong_status{state_map = NewMap},
							NewPs = Player#player_status{strong_status = NewStrongStatus}
					end,
					update_data(NewPs, RoleId, T, State);
				_ ->
					update_data(RoleId, [StrongId|T], State),
					{ok, Player}
			end;
		true ->
			{ok, Player}
	end;
update_data(Player,_,[],_) -> {ok, Player}.

update_data(RoleId, [StrongId|T], State) when is_integer(RoleId) ->
	Time = utime:unixtime(),
	db_update(RoleId, StrongId, State, Time),
	update_data(RoleId, T, State);
update_data(_RoleId, [], _State) -> skip.

%% 我要变强  ===  副本
update_data_by_duntype(#player_status{id = RoleId} = Player, DunType, MaxNum, Num, CountType) ->
	% CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
	% Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType),
	VipFreeCount = lib_vip_api:get_vip_privilege(Player, ?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType)),
	if
		DunType == ?DUNGEON_TYPE_EXP_SINGLE andalso Num >= MaxNum + VipFreeCount->
			update_data(Player, RoleId, [?DUN_EXP_ID], 1);
		DunType == ?DUNGEON_TYPE_VIP_PER_BOSS andalso Num >= MaxNum + VipFreeCount->
			update_data(Player, RoleId, [?PER_BOSS_EQUIP_ID], 1);
		true ->
			skip
	end.

%% 我要变强  ===  boss
update_data_boss(Player, BossType) ->
	#player_status{id = RoleId, figure = #figure{lv = _RoleLv, vip = VipLv, vip_type = VipType}} = Player,
	case data_boss:get_boss_type(BossType) of
        #boss_type{count = Count} when BossType == ?BOSS_TYPE_FORBIDDEN ->
 			VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(BossType), VipType, VipLv),
            ACount = Count + VipAddCount,
            Num = mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType),

            if
            	Num >= ACount ->
            		{ok, NewPlayer} = update_data(Player, RoleId, [?FBD_BOSS_EQUIP_ID], 1);
            	true ->
            		NewPlayer = Player
            end;
        _ ->
        	NewPlayer = Player
    end,
    NewPlayer.

%% 我要变强  ===  公会篝火/公会boss
update_data_guild_act(#player_status{id = RoleId} = Player) ->
	{ok, NewPlayer} = update_data(Player, RoleId, [?GUILD_FIR_EXP_ID, ?GUILD_FIR_EQUIP_ID], 1),
	NewPlayer.

%% 我要变强  ===  日常任务
update_data_task(RoleId, TaskType, FinishCount, Count) when FinishCount >= Count ->
	case TaskType of
		?TASK_TYPE_DAILY ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_to_be_strong, update_data, [RoleId, [?TASK_GOLD_EXP_ID], 1]);
		?TASK_TYPE_GUILD ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_to_be_strong, update_data, [RoleId, [?TASK_GUILD_EXP_ID], 1]);
		_ ->
			skip
	end,
	ok;
update_data_task(_, _, _, _) -> ok.

%% 我要变强  ===  祈愿
update_data_pray(#player_status{id = RoleId} = Player, 0) ->
	{ok, NewPlayer} = update_data(Player, RoleId, [?PRAY_FOR_EXP_ID], 1),
	NewPlayer;
update_data_pray(Player, _) -> Player.

%% 我要变强  ===  竞技场
update_data_jjc(Player) ->
	#player_status{id = RoleId, figure = #figure{vip_type = VipType, vip = Vip}} = Player,
	MaxBuyNum = lib_vip_api:get_vip_privilege(?MOD_JJC, 1, VipType, Vip),
    BuyNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_BUY_NUM),
	[MaxNum] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
    ChallengeNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_CHALLENGE_NUM),
    if 
    	MaxNum - ChallengeNum == 0 andalso MaxBuyNum == BuyNum ->
    		{ok, NewPlayer} = update_data(Player, RoleId, [?JJC_BGOLD_ID, ?JJC_EXP_ID], 1);
    	true ->
    		NewPlayer = Player
    end,
    {ok, NewPlayer}.

%% 我要变强  ===  公会战
update_data_guild_war(#player_status{id = RoleId} = Player) ->
 	{ok, NewPlayer} = update_data(Player, RoleId, [?GUILD_WAR_EXP_ID, ?GUILD_WAR_BGOLD_ID], 1),
	NewPlayer.

%% 我要变强  ===  九魂圣殿
update_data_nine(#player_status{id = RoleId} = Player) ->
 	{ok, NewPlayer} = update_data(Player, RoleId, [?NINE_BAT_EXP_ID, ?NINE_BAT_BGOLD_ID], 1),
	NewPlayer.

%% 我要变强  ===  璀璨之海
update_data_sea_treasure_exp(#player_status{id = RoleId} = Player, 0) ->
 	{ok, NewPlayer} = update_data(Player, RoleId, [?SEA_TS_EXP_ID], 1),
	NewPlayer;
update_data_sea_treasure_exp(Player, _) -> Player.

update_data_sea_treasure_gold(#player_status{id = RoleId} = Player, 0) ->
	{ok, NewPlayer} = update_data(Player, RoleId, [?SEA_TS_BGOLD_ID], 1),
	NewPlayer;
update_data_sea_treasure_gold(Player, _) -> Player.

%% 我要变强  ===  钻石大战
update_data_diamond(#player_status{id = RoleId} = Player) ->
	{ok, NewPlayer} = update_data(Player, RoleId, [?DIAMOND_BGOLD_ID], 1),
	NewPlayer.

%% 返回所有需要处理（day_limit 为1）的数据
get_limit_ids() ->
	AllIds = data_to_be_strong:get_all_id(),
	Fun = fun(Id, Acc) ->
		case data_to_be_strong:get_cfg(Id) of
			#to_be_strong_cfg{type = Type, lv = Lv, day_limit = DayLimit} when DayLimit == 1 ->
				[{Id, Type, Lv}|Acc];
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, [], AllIds).

db_update(RoleId, Id, State, Time) -> %% replace 刷新数据库状态
	db:execute(io_lib:format(?SQL_UPDATE, [RoleId, Id, State, Time])).

db_select(RoleId) ->
	db:get_all(io_lib:format(?SQL_SELECT, [RoleId])).

% db_clear(RoleId) ->
% 	db:execute(io_lib:format("delete from to_be_strong where role_id = ~p", [RoleId])).


get_clear_time(StrongId) ->
	Res = case StrongId of
		?DUN_EXP_ID -> 
			ModuleId = ?MOD_DUNGEON, SubModId = ?MOD_DUNGEON_ENTER, Type = ?DUNGEON_TYPE_EXP_SINGLE,
			{ModuleId, SubModId, Type};
		?TASK_GOLD_EXP_ID ->
			case data_task_lv_dynamic:get_task_type(?TASK_TYPE_DAILY) of
        		#task_type{module_id = ModuleId, counter_id = CounterId} -> 
        			SubModId = 0, Type = CounterId,
        			{ModuleId, SubModId, Type};
        		_ -> 0
        	end;
		?TASK_GUILD_EXP_ID ->
			case data_task_lv_dynamic:get_task_type(?TASK_TYPE_GUILD) of
        		#task_type{module_id = ModuleId, counter_id = CounterId} -> 
        			SubModId = 0, Type = CounterId,
        			{ModuleId, SubModId, Type};
        		_ -> 0
        	end;
        ?PRAY_FOR_EXP_ID ->
        	ModuleId = ?MOD_PRAY, SubModId = 0, Type = ?PRAY_TYPE_EXP,
        	{ModuleId, SubModId, Type};
        ?PER_BOSS_EQUIP_ID ->
        	ModuleId = ?MOD_DUNGEON, SubModId = ?MOD_DUNGEON_ENTER, Type = ?DUNGEON_TYPE_VIP_PER_BOSS,
        	{ModuleId, SubModId, Type};
        ?FBD_BOSS_EQUIP_ID ->
        	ModuleId = ?MOD_BOSS, SubModId = ?MOD_BOSS_ENTER, Type = ?BOSS_TYPE_FORBIDDEN,
        	{ModuleId, SubModId, Type};
        _ when StrongId == ?JJC_EXP_ID; StrongId == ?JJC_BGOLD_ID -> 
        	ModuleId = ?MOD_JJC, SubModId = 0, Type = ?JJC_CHALLENGE_NUM,
        	{ModuleId, SubModId, Type};
        _ when StrongId == ?SEA_TS_EXP_ID; StrongId == ?SEA_TS_BGOLD_ID ->
        	ModuleId = ?MOD_SEA_TREASURE, SubModId = 0, Type = ?DAILY_TREASURE_TIMES,
        	{ModuleId, SubModId, Type};
        _ ->
        	0
	end,
	case Res of
		{MId, SMId, T} ->
			case lib_daily:get_config(MId, SMId, T) of
				#base_daily{clock = Clock} -> Clock;
				_ -> ?TWELVE
			end;
		_ -> ?TWELVE
	end.