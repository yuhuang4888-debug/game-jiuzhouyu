%% ---------------------------------------------------------------------------
%% @doc lib_territory_treasure_mod.erl
%% @author  xlh
%% @email   
%% @since   2019.3.6
%% @deprecated 领地夺宝进程
%% ---------------------------------------------------------------------------

-module(lib_territory_treasure_mod).

-include("territory_treasure.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("auction_module.hrl").
-include("rec_auction.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
% mod_territory_treasure:start_act().
-export([ 
		send_reward_end/5
		,mon_hurt/7
		,drop_thing/4
		,enter/8
		,send_rank_reward/4
		,init_data/1
		,mon_create/2
		,mon_killed/7
		,gm_start/1
		,handle_out/2
		,reconnect/9
		,start_act/1
		,gm_close_act/1
		,calc_guild_auction/3
		,calc_produce_num/3
		,get_act_time/4
	]).
% %%活动日历lib_activitycalen_api:success_end_activity(?MOD_BOSS, ?BOSS_TYPE_WORLD),
% lib_activitycalen_api:success_start_activity(?MOD_BOSS, ?BOSS_TYPE_WORLD),
init_data(State) ->
	NowTime = utime:unixtime(),
	case data_territory_treasure:get_all_dunid() of
		DunIds when is_list(DunIds) andalso DunIds =/= [] ->
			case lib_territory_treasure:calc_time() of
				{true, StartTime} -> 
					erlang:send_after(StartTime*1000, self(), {'act_start'}),
					Fun = fun(DunId, TemMap) ->
						case data_territory_treasure:get_base_cfg(DunId) of
							#base_cfg{end_time = TimeCfg, scene = Scene} ->
								case data_territory_treasure:get_wave_cfg(DunId,1) of
									#base_wave{etime = ETime} -> ETime;
									_ -> ETime = 0
								end,
								StartRef = erlang:send_after((StartTime+ETime)*1000, self(), {'mon_create', DunId}),
								EndRef = erlang:send_after((StartTime+TimeCfg)*1000, self(), {'send_reward_end', Scene, 0, DunId, DunId}),
								Dun = #dun{mon_map = #{},nextopen_time = NowTime+StartTime,create_ref = StartRef, end_time = NowTime+StartTime+TimeCfg,
								 	end_ref = EndRef, refresh_time = NowTime+StartTime+ETime, wave = 1, num = 0, is_end = 1},
								NewMap = maps:put(DunId, Dun, TemMap);
							_ -> NewMap = TemMap
						end,
						NewMap
					end,
					DunState = lists:foldl(Fun, #{}, DunIds),
					DunState;
				_ -> 
					DunState = #{}
			end;
		_ ->
			DunState = #{}
	end,
	State#territory_state{dun_state = DunState}.

start_act(State) ->
	NowTime = utime:unixtime(),
	lib_activitycalen_api:success_start_activity(?MOD_TERRITORY, 31),
	#territory_state{dun_state = OldDunState} = State,
	case data_territory_treasure:get_all_dunid() of
		DunIds when is_list(DunIds) andalso DunIds =/= [] ->
			Fun = fun(DunId, TemMap) ->
				case maps:get(DunId, TemMap, []) of
					#dun{is_end = _IsEnd, create_ref = SRef, end_ref = ERef} ->
						util:cancel_timer(SRef),
						util:cancel_timer(ERef);
		    		_ ->

						skip
				end,
				case data_territory_treasure:get_base_cfg(DunId) of
					#base_cfg{end_time = TimeCfg, scene = Scene} ->
						lib_mon:clear_scene_mon(Scene, 0, DunId, 1),
						case data_territory_treasure:get_wave_cfg(DunId,1) of
							#base_wave{etime = ETime} -> ETime;
							_ -> ETime = 0
						end,
						StartRef = erlang:send_after(ETime*1000, self(), {'mon_create', DunId}),
						EndRef = erlang:send_after(TimeCfg*1000, self(), {'send_reward_end', Scene, 0, DunId, DunId}),
						Dun = #dun{mon_map = #{},nextopen_time = NowTime,create_ref = StartRef, end_time = NowTime+TimeCfg,
						 	end_ref = EndRef, refresh_time = NowTime+ETime, wave = 1, num = 0, is_end = 0};
					_ -> 
						Dun = #dun{is_end = 0}
				end,
				maps:put(DunId, Dun, TemMap)
			end,
			DunState = lists:foldl(Fun, OldDunState, DunIds),
			DunState;
		_ ->
			DunState = OldDunState
	end,
	% ?PRINT("@@@@@@ DunState:~p~n",[DunState]),
	State#territory_state{dun_state = DunState, other_map = #{}, reward_map = #{}, guild_info = #{}, rank_map = #{}}.

%% 生成一波怪物
mon_create(State, DunId) ->
	#territory_state{dun_state = DunState} = State,
	case maps:get(DunId, DunState, []) of
		#dun{wave = Wave, mon_map = MonMap, num = Num} = Dun ->
			case data_territory_treasure:get_wave_cfg(DunId, Wave) of
				#base_wave{mon_info = Moninfo} ->
					case data_territory_treasure:get_base_cfg(DunId) of
						#base_cfg{scene = Scene} ->
							%% 先清怪物
							lib_mon:clear_scene_mon(Scene, 0, DunId, 1),
							Fun = fun({Monid, X, Y}, {TemMap, Sum}) ->
								% %% 先清怪物
								% lib_mon:clear_scene_mon_by_mids(Scene, 0, DunId, 1, [Monid]),
								%% 生成怪物
								lib_scene_object:async_create_object(?BATTLE_SIGN_MON, Monid, Scene, 0, X, Y, 1, DunId, 1, []),
								{maps:put(Monid, 1, TemMap), Sum+1}
							end,
							{NewMap, RealNum} = lists:foldl(Fun, {MonMap, 0}, Moninfo);
						_ ->
							NewMap = MonMap, RealNum = Num
					end;
				_ ->
					NewMap = MonMap, RealNum = Num
			end,
			NewDunState = maps:put(DunId, Dun#dun{mon_map = NewMap, num = RealNum}, DunState);
		_ ->
			NewDunState = DunState
	end,
	State#territory_state{dun_state = NewDunState}.

%% 怪物map更新,计算波数
mon_killed(State, Scene, PoolId, CopyId, Monid, DX, DY) ->
	NowTime = utime:unixtime(),
	#territory_state{dun_state = DunState, rank_map = RankMap} = State,
	case maps:get(CopyId, DunState, []) of  %% copyid == dunid
		#dun{wave = Wave, mon_map = MonMap, num = Num, create_ref = Ref, end_ref = Eref} = Dun ->
			NewMap = maps:put(Monid, 0, MonMap),
			if
				Num - 1 =< 0 ->
				    case data_territory_treasure:get_wave_cfg(CopyId, Wave+1) of
				    	#base_wave{etime = ETime} -> 
				    		util:cancel_timer(Ref),
				    		StartRef = erlang:send_after(ETime*1000, self(), {'mon_create', CopyId}),
				    		NewDun = Dun#dun{wave = Wave+1, mon_map = NewMap, num = 0,
				    			 create_ref = StartRef, refresh_time = NowTime + ETime};
				    	_ ->
				    		util:cancel_timer(Ref),
				    		util:cancel_timer(Eref),
				    		% ?ERR("CopyId:~p，Wave:~p~n", [CopyId, Wave+1]),
				    		case data_territory_treasure:get_value(4) of
								DunCfg when is_integer(DunCfg) andalso DunCfg >= 0 -> DunCfg;
								_E ->  DunCfg = 10
							end,
				    		NewRef = erlang:send_after(DunCfg*1000, self(), {'send_reward_end', Scene, PoolId, CopyId, CopyId}),
				    		NewDun = Dun#dun{mon_map = #{}, num = 0, create_ref = undefined, 
				    			end_ref = NewRef, end_time = NowTime+DunCfg, refresh_time = 0, is_end = 1}
				    end;
				true ->
					NewDun = Dun#dun{mon_map = NewMap, num = Num - 1}
			end,
			NewDunState = maps:put(CopyId, NewDun, DunState);
		_ ->
			?ERR("CopyId:~p,DunState:~p,Scene:~p~n",[CopyId,DunState,Scene]),
			NewDunState = DunState
	end,
	RankList = maps:get({Scene, PoolId, CopyId}, RankMap, []),%%伤害由小到大的列表
    NewRankA = lists:reverse(RankList),        %%伤害由大到小的列表
    NeedSendL = lists:sublist(NewRankA, 10),
    Fun1 = fun({N,_,H}, Acc) ->
        [{N, H}|Acc]
    end,
    NeedSendList = lists:foldl(Fun1, [], NeedSendL),
    RealSendL = lists:reverse(NeedSendList),
	erlang:send_after(500, self(), {'send_rank', Scene, PoolId, CopyId, RealSendL}),
	%% 怪物消失
	{ok, Bin} = pt_652:write(65209, [Monid, DX, DY]),
	lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin),
	State#territory_state{dun_state = NewDunState}.

%% 收集玩家获得掉落得物品
drop_thing(State, Monid, RoleId, Reward) ->
	#territory_state{reward_map = RewardMap} = State,
	case get_role_info(RoleId, State) of
		[] -> 
			?ERR("no user data role_id:~p~n",[RoleId]),
			State;
		#role_info{dunid = DunId} -> 
			case maps:get({DunId, RoleId, Monid}, RewardMap, []) of
				OldReward when is_list(OldReward) ->
					NewReward = OldReward ++ Reward;
				_ -> 
					NewReward = Reward
			end,
			NewMap = maps:put({DunId, RoleId, Monid}, NewReward, RewardMap),
			State#territory_state{reward_map = NewMap}
	end.

%% 伤害统计，计算排名
mon_hurt(State, Scene, PoolId, CopyId, RoleId, Name, Hurt) ->
    #territory_state{rank_map = RankMap} = State,
    RankList = maps:get({Scene, PoolId, CopyId}, RankMap, []),
    NewRankList = rank_damage(Name, RoleId, Hurt, RankList),%%伤害由小到大的列表
    NewRankmap = maps:put({Scene, PoolId, CopyId}, NewRankList, RankMap),
    NewState = State#territory_state{rank_map = NewRankmap},
    NewRankA = lists:reverse(NewRankList),        %%伤害由大到小的列表
    NeedSendL = lists:sublist(NewRankA, 10),
    Fun1 = fun({N,_,H}, Acc) ->
        [{N, H}|Acc]
    end,
    NeedSendList = lists:foldl(Fun1, [], NeedSendL),
    RealSendL = lists:reverse(NeedSendList),
    %%PerHurt:上一名玩家的伤害
    Fun = fun({N, _,  H}, {Sum, HurtN, PerHurt, PerHurtBefore, Rank}) ->
        case N =/= Name of
            true ->
                {Sum + 1, HurtN, PerHurt, H, Rank};
            false ->
                {Sum + 1, H, PerHurtBefore, PerHurtBefore, Sum + 1}
        end
    end,
    {_Count, RHurt, PHurt, _, RealRank} = lists:foldl(Fun, {0,0,0,0,0}, NewRankA),
    Distance = max(PHurt-RHurt, 0),
    % ?PRINT(Distance == 0,"PerHurt:~p,RHurt:~p~n",[PHurt,RHurt]),
    % ?PRINT("46022   #### RealRank:~p, RHurt:~p, Name:~p, Distance:~p~n, RealSendL:~p~n",[RealRank, RHurt, Name, Distance, RealSendL]),
    lib_server_send:send_to_uid(RoleId, pt_652, 65203, [RealRank, RHurt, Name, Distance]),
    erlang:send_after(500, self(), {'send_rank', Scene, PoolId, CopyId, RealSendL}),
    NewState.

%% 副本结束推送奖励界面
send_reward_end(State, Scene, PoolId, CopyId, DunId) ->
	% NowTime = utime:unixtime(),
	#territory_state{reward_map = RewardMap, dun_state = DunState, other_map = OtherMap} = State,
	RewardMapList = maps:to_list(RewardMap),
	F1 = fun({{TDunId, RoleId, Monid}, Reward}, {Acc,TemMap}) when DunId == TDunId ->
		case get_role_info(RoleId, State) of
			[] -> ?ERR("error data RoleId:~p,OtherMap:~p~n",[RoleId,OtherMap]),skip;
			#role_info{role_name = RoleName, dunid = DunId} ->
				RewardList1  = ulists:object_list_plus([Reward, []]),
				%% TODO 日志
				lib_log_api:log_territory_reward(RoleId, RoleName, DunId, Monid, RewardList1)
		end,
		case lists:keyfind(RoleId, 1, Acc) of
			{_, Re} -> NewR = Reward ++ Re;
			_ -> NewR = Reward
		end,
		F2 = fun({Type, GoodsId, Num} = H, {TAcc, Accs}) when Type == 3 andalso GoodsId == 0 ->
			case lists:keyfind(3, 1, Accs) of
				{3, 0, Number} -> {[H|TAcc], [{Type, GoodsId, Number+Num}]};
				_ -> {[H|TAcc], [H|Accs]}
			end;
			(_, {TAcc, Accs}) -> {TAcc, Accs}
		end,
		{CoinList, RealCoins} = lists:foldl(F2, {[],[]}, NewR),
		RealReward = lists:subtract(NewR, CoinList),
		NewTemMap = maps:remove({TDunId, RoleId, Monid}, TemMap),
		NewAcc = lists:keystore(RoleId, 1, Acc, {RoleId, RealCoins ++ RealReward}),
		{NewAcc, NewTemMap};
	(_, {Acc, TemMap}) ->
		{Acc, TemMap}
	end,
	{RoleRewardList, NewRMap} = lists:foldl(F1, {[], RewardMap}, RewardMapList),
	Fun = fun({RoleId, Reward}) ->
		Pid = misc:get_player_process(RoleId),
		IsAlive = misc:is_process_alive(Pid),
		if
			IsAlive == true ->
				% ?PRINT("Reward:~p~n",[Reward]),
				lib_server_send:send_to_uid(RoleId, pt_652, 65205, [Reward]);
			true ->
				% ?PRINT("####### Reward:~p~n",[Reward]),
				skip
		end
	end,
	lists:foreach(Fun, RoleRewardList),
	%% 计算下次刷怪时间 清除相关数据
	case maps:get(DunId, DunState, []) of
		#dun{create_ref = CreateRef, end_ref = EndRef} ->
			util:cancel_timer(CreateRef),util:cancel_timer(EndRef);
		_ -> 
			skip			
	end,
	Dun = #dun{mon_map = #{},nextopen_time = 0,create_ref = undefined, end_ref = undefined, end_time = 0, refresh_time = 0, wave = 1, num = 0, is_end = 1},	
	NewMap = maps:put(DunId, Dun, DunState),
	%% 暂时屏蔽公会拍卖产出	
	% mod_guild:get_guild_rank_info(CopyId),
	mod_scene_agent:apply_cast(Scene, 0, lib_territory_treasure, clear_scene_palyer, [CopyId]),
	erlang:send_after(100, self(), {'send_rank_reward', Scene, PoolId, CopyId}),
	State#territory_state{dun_state = NewMap, reward_map = NewRMap}.

calc_guild_auction(State, GuildListSort, CopyId) ->
	#territory_state{guild_info = GuildInfoMap} = State,
	GuildInfoList = maps:get(CopyId, GuildInfoMap, []),
	% ?PRINT("============ GuildInfoList:~p,GuildListSort:~p~n",[GuildInfoList, GuildListSort]),
	Fun = fun({GuildId, RoleIdList}) ->
		case lists:keyfind(GuildId, 1, GuildListSort) of
			{GuildId, Rank} ->
				case data_territory_treasure:get_auction_produce_info(Rank) of
					#base_territory_auction{gold_base=Worth,gold_add=Ratio,gold=Produce,bgold_base=BWorth,bgold_add=BRatio,bgold=BProduce,produce=NormarProduceL} ->
						Sum = calc_all_weight(Produce, 0),
			            BSum = calc_all_weight(BProduce, 0),
			            Length = erlang:length(RoleIdList),
			            BonusPlayerList = [{RoleId, GuildId}|| RoleId <- RoleIdList],
			            GoldProduceList = calc_produce_num(Produce, Sum, Worth+Length*Ratio),
			            BGoldProduceList = calc_produce_num(BProduce, BSum, BWorth+Length*BRatio),
			            AuctionList = GoldProduceList ++ BGoldProduceList ++ NormarProduceL,
			            % ?PRINT("=========== AuctionList:~p~n",[AuctionList]),
			            Wlv = util:get_world_lv(),
			            Fun = fun({AuctionId, Num}, Acc) ->
					        case data_auction:get_goods(AuctionId, Wlv) of
					            #base_auction_goods{gtype_id = GtypeId, goods_num = GoodsNum, base_price = Price, gold_type = GoldType} ->
					                Fun = fun(_, TemAcc) ->
					                    [{GtypeId, GoodsNum, GoldType, Price}|TemAcc]
					                end,
					                lists:foldl(Fun, Acc, lists:seq(1, Num));
					            _ ->
					                Acc
					        end
					    end,
					    GtypeIdL = lists:foldl(Fun, [], AuctionList),
					    % ?PRINT("=========== RoleIdList:~p,GtypeIdL:~p~n",[RoleIdList, GtypeIdL]),
					    if
					    	GtypeIdL =/= [] ->
					    		{ok, BinData} = pt_652:write(65207, [erlang:length(RoleIdList), GtypeIdL]),
		    					lib_server_send:send_to_all(all_include, RoleIdList, BinData),

					            lib_auction_api:start_guild_auction_with_bonus_players(?AUCTION_MOD_TERRITORY, [{GuildId, AuctionList}], BonusPlayerList);
					        true ->
					        	skip
					    end;
			        _ ->
			        	skip
			    end;
			_ ->
				skip
		end
	end,
	lists:foreach(Fun, GuildInfoList),
	State#territory_state{guild_info = maps:remove(CopyId, GuildInfoMap)}.


%% 进入保存玩家相关数据	
enter(State, Scene, RoleId, RoleName, GuildId, GuildName, DunId, Code) ->
	#territory_state{other_map = OtherMap, dun_state = DunState, rank_map = RankMap, guild_info = GuildInfoMap} = State,
	case maps:get(RoleId, OtherMap, false) of
		#role_info{guild_id = OldGuildId} when OldGuildId =/= GuildId ->
			{ok, BinData} = pt_652:write(65202, [?ERRCODE(err652_dunid_wrong), DunId, 0, 0, 0, 0, 0]),
			lib_server_send:send_to_uid(RoleId, BinData),
			State;
		Res ->
			GuildInfoList = maps:get(DunId, GuildInfoMap, []),
			case Res of
				false ->
					case lists:keyfind(GuildId, 1, GuildInfoList) of
						{GuildId, RoleList} ->
							NewGuildInfoList = lists:keystore(GuildId, 1, GuildInfoList, {GuildId, [RoleId|RoleList]});
						_ ->
							NewGuildInfoList = lists:keystore(GuildId, 1, GuildInfoList, {GuildId, [RoleId]})
					end;
				_ ->
					NewGuildInfoList = GuildInfoList
			end,
			NewMap = maps:put(DunId, NewGuildInfoList, GuildInfoMap),
			NewRole = #role_info{role_id = RoleId, role_name = RoleName, guild_id = GuildId, guild_name = GuildName, dunid = DunId},
			NewOtherMap = maps:put(RoleId, NewRole, OtherMap),
			WaveList = data_territory_treasure:get_all_wave(DunId),
			TotalWave = erlang:length(WaveList),
			case maps:get(DunId, DunState, []) of
				#dun{refresh_time = RefreshTime, end_time = EndTime, is_end = IsEnd, wave = Wave, num = Num} ->
					if
						IsEnd == 1 -> %%活动结束
							{ok, BinData} = pt_652:write(65202, [?ERRCODE(act_end), DunId, TotalWave, 0, 0, 0, 0]);
						true ->
							lib_scene:player_change_scene(RoleId, Scene, 0, DunId, true, [{group, 0}]),
							{ok, BinData} = pt_652:write(65202, [Code, DunId, TotalWave, RefreshTime, Wave, Num, EndTime]),
							RankList = maps:get({Scene, 0, DunId}, RankMap, []),%%伤害由小到大的列表
						    NewRankA = lists:reverse(RankList),        %%伤害由大到小的列表
						    NeedSendL = lists:sublist(NewRankA, 10),
						    Fun1 = fun({N,_,H}, Acc) ->
						        [{N, H}|Acc]
						    end,
						    NeedSendList = lists:foldl(Fun1, [], NeedSendL),
						    RealSendL = lists:reverse(NeedSendList),
						    %%PerHurt:上一名玩家的伤害
						    Fun = fun({N, _,  H}, {Sum, HurtN, PerHurt, PerHurtBefore, Rank}) ->
						        case N =/= RoleName of
						            true ->
						                {Sum + 1, HurtN, PerHurt, H, Rank};
						            false ->
						                {Sum + 1, H, PerHurtBefore, PerHurtBefore, Sum + 1}
						        end
						    end,
						    {_Count, RHurt, PHurt, _, RealRank} = lists:foldl(Fun, {0,0,0,0,0}, NewRankA),
						    Distance = max(PHurt-RHurt, 0),
						    lib_activitycalen_api:role_success_end_activity(RoleId, 652, 31),
							CallbackData = #callback_join_act{type = ?MOD_TERRITORY},
							lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData),

						    % ?PRINT(Distance == 0,"PerHurt:~p,RHurt:~p~n",[PHurt,RHurt]),
						    % ?PRINT("46022   #### RealRank:~p, RHurt:~p, Name:~p, Distance:~p~n, RealSendL:~p~n",[RealRank, RHurt, Name, Distance, RealSendL]),
						    lib_server_send:send_to_uid(RoleId, pt_652, 65203, [RealRank, RHurt, RoleName, Distance]),
						    {ok, Bin} = pt_652:write(65204, [RealSendL, Wave, Num, RefreshTime]),
							lib_server_send:send_to_uid(RoleId, BinData),
							lib_server_send:send_to_uid(RoleId, Bin)
					end;		
				_ -> 
					{ok, BinData} = pt_652:write(65202, [Code, DunId, TotalWave, 0, 0, 0, 0])
			end,
			lib_server_send:send_to_uid(RoleId, BinData),
			State#territory_state{other_map = NewOtherMap, guild_info = NewMap}
	end.
	

reconnect(State, RoleId, _RoleLv, RoleName, GuildId, GuildName, Scene, PoolId, CopyId) ->
	#territory_state{other_map = OtherMap, dun_state = DunState, rank_map = RankMap} = State,
	Code = 1,
	case maps:get(RoleId, OtherMap, false) of
		false ->
			NewRole = #role_info{role_id = RoleId, role_name = RoleName, 
				guild_id = GuildId, guild_name = GuildName, dunid = Scene},
			NewOtherMap = maps:put(RoleId, NewRole, OtherMap);
		_ ->
			NewOtherMap = OtherMap
	end,
	WaveList = data_territory_treasure:get_all_wave(Scene),
	TotalWave = erlang:length(WaveList),
	case maps:get(CopyId, DunState, []) of
		#dun{refresh_time = RefreshTime, end_time = EndTime, is_end = IsEnd, wave = Wave, num = Num} ->
			if
				IsEnd == 1 -> %%活动结束
					{ok, BinData} = pt_652:write(65202, [?ERRCODE(act_end), Scene, TotalWave, 0, 0, 0, 0]),
					lib_server_send:send_to_uid(RoleId, BinData),
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_territory_treasure, quit_timeout, []);
				true ->
					{ok, BinData} = pt_652:write(65202, [Code, Scene, TotalWave, RefreshTime, Wave, Num, EndTime]),
					RankList = maps:get({Scene, PoolId, CopyId}, RankMap, []),%%伤害由小到大的列表
				    NewRankA = lists:reverse(RankList),        %%伤害由大到小的列表
				    NeedSendL = lists:sublist(NewRankA, 10),
				    Fun1 = fun({N,_,H}, Acc) ->
				        [{N, H}|Acc]
				    end,
				    NeedSendList = lists:foldl(Fun1, [], NeedSendL),
				    RealSendL = lists:reverse(NeedSendList),
				    %%PerHurt:上一名玩家的伤害
				    Fun = fun({N, _,  H}, {Sum, HurtN, PerHurt, PerHurtBefore, Rank}) ->
				        case N =/= RoleName of
				            true ->
				                {Sum + 1, HurtN, PerHurt, H, Rank};
				            false ->
				                {Sum + 1, H, PerHurtBefore, PerHurtBefore, Sum + 1}
				        end
				    end,
				    {_Count, RHurt, PHurt, _, RealRank} = lists:foldl(Fun, {0,0,0,0,0}, NewRankA),
				    Distance = max(PHurt-RHurt, 0),
				    % ?PRINT(Distance == 0,"PerHurt:~p,RHurt:~p~n",[PHurt,RHurt]),
				    % ?PRINT("46022   #### RealRank:~p, RHurt:~p, Name:~p, Distance:~p~n, RealSendL:~p~n",[RealRank, RHurt, Name, Distance, RealSendL]),
				    lib_server_send:send_to_uid(RoleId, pt_652, 65203, [RealRank, RHurt, RoleName, Distance]),
				    {ok, Bin} = pt_652:write(65204, [RealSendL, Wave, Num, RefreshTime]),
					lib_server_send:send_to_uid(RoleId, BinData),
					lib_server_send:send_to_uid(RoleId, Bin)
			end;		
		_ -> 
			{ok, BinData} = pt_652:write(65202, [Code, Scene, TotalWave, 0, 0, 0, 0]),
			lib_server_send:send_to_uid(RoleId, BinData),
			lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_territory_treasure, quit_timeout, [])
	end,
	State#territory_state{other_map = NewOtherMap}.
%% 发放排名奖励
send_rank_reward(State, Scene, PoolId, CopyId) ->
	#territory_state{rank_map = RankMap} = State,
	RankList = maps:get({Scene, PoolId, CopyId}, RankMap, []),
	NRankList = lists:reverse(RankList),
	WorldLv = util:get_world_lv(),
    Fun = fun({N, Id, H}, {Sum,Acc}) ->
    	case data_territory_treasure:get_reward_by_rank(Sum + 1, WorldLv) of
    		Reward when is_list(Reward) andalso Reward =/= [] -> 
    			Reward;
    		_ -> 
    			?ERR("no such cfg: territory_treasure {Rank, WorldLv}:~p~n",[{Sum+1, WorldLv}]), 
    			Reward = []
    	end,
    	Title = utext:get(?MAIL_TITLE_RANK),
        Content = utext:get(?MAIL_CONTENT_RANK, [Sum + 1]),
        % Produce = #produce{type = territory_hurt, subtype = 0, reward = Reward, remark = "", show_tips = 1},
        lib_mail_api:send_sys_mail([Id], Title, Content, Reward),
        case get_role_info(Id, State) of
			[] -> ?ERR("error data ~p~n",[1]),skip;
			#role_info{guild_id = GuildId, guild_name = GuildName} ->
				%% 日志
				lib_log_api:log_territory_rank(GuildId, GuildName, Id, N, H, Sum + 1, Reward)
		end,
        {Sum+1,[{N, Id, H, Sum + 1}|Acc]}
    end,
    { _, _} = lists:foldl(Fun, {0, []}, NRankList),
    lib_activitycalen_api:success_end_activity(?MOD_TERRITORY, 31),
    NewMap = maps:remove({Scene, PoolId, CopyId}, RankMap),
    State#territory_state{rank_map = NewMap}.

gm_start(State) ->
	lib_activitycalen_api:success_start_activity(?MOD_TERRITORY, 31),
	#territory_state{dun_state = OldDunState} = State,
	NowTime = utime:unixtime(),
	case data_territory_treasure:get_all_dunid() of
		DunIds when is_list(DunIds) andalso DunIds =/= [] ->
			Fun = fun(DunId, TemMap) ->
				case data_territory_treasure:get_base_cfg(DunId) of
					#base_cfg{end_time = TimeCfg, scene = Scene} ->
						case data_territory_treasure:get_wave_cfg(DunId,1) of
							#base_wave{etime = ETime} -> ETime;
							_ -> ETime = 0
						end,
						case maps:get(DunId, TemMap, []) of
							#dun{create_ref = Ref, end_ref = Eref, is_end = IsEnd} = OldDun ->
								if
									IsEnd == 1 ->
										util:cancel_timer(Ref),
						    			util:cancel_timer(Eref),
						    			lib_mon:clear_scene_mon(Scene, 0, DunId, 1),
						    			StartRef = erlang:send_after((ETime)*1000, self(), {'mon_create', DunId}),
										EndRef = erlang:send_after((TimeCfg)*1000, self(), {'send_reward_end', Scene, 0, DunId, DunId}),
										Dun = OldDun#dun{mon_map = #{},create_ref = StartRef,end_ref = EndRef, end_time = NowTime+TimeCfg,
											refresh_time = NowTime+ETime, wave = 1, num = 0, is_end = 0};
									true ->
										Dun = OldDun
								end;
				    		_ ->
				    			lib_mon:clear_scene_mon(Scene, 0, DunId, 1),
				    			StartRef = erlang:send_after((ETime)*1000, self(), {'mon_create', DunId}),
								EndRef = erlang:send_after((TimeCfg)*1000, self(), {'send_reward_end', Scene, 0, DunId, DunId}),
								Dun = #dun{mon_map = #{},nextopen_time = NowTime,create_ref = StartRef,
								 		end_ref = EndRef, end_time = NowTime+TimeCfg, refresh_time = NowTime+ETime, wave = 1, num = 0, is_end = 0}
						end,
						NewMap = maps:put(DunId, Dun, TemMap);
					_ -> NewMap = TemMap
				end,
				NewMap
			end,
			DunState = lists:foldl(Fun, OldDunState, DunIds),
			DunState;
		_ ->
			DunState = OldDunState
	end,
	State#territory_state{dun_state = DunState}.

get_act_time(State, RoleId, _GuildId, DunId) ->
	#territory_state{dun_state = DunState} = State,
	case maps:get(DunId, DunState, []) of
		#dun{end_time = EndTime} ->
			{ok, BinData} = pt_652:write(65208, [DunId, EndTime]),
            lib_server_send:send_to_uid(RoleId, BinData);
		_ ->
			{ok, BinData} = pt_652:write(65208, [0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData)
	end,
	State.

gm_close_act(State) ->
	#territory_state{dun_state = OldDunState} = State,
	DunIds = data_territory_treasure:get_all_dunid(),
	Fun = fun(DunId, TemMap) ->
		case data_territory_treasure:get_base_cfg(DunId) of
			#base_cfg{scene = Scene} ->
				case maps:get(DunId, TemMap, []) of
					#dun{create_ref = Ref, end_ref = Eref, is_end = IsEnd} = OldDun ->
						if
							IsEnd == 0 ->
								util:cancel_timer(Ref),
				    			util:cancel_timer(Eref),
								EndRef = erlang:send_after(1000, self(), {'send_reward_end', Scene, 0, DunId, DunId}),
								Dun = OldDun#dun{end_ref = EndRef};
							true ->
								Dun = OldDun
						end,
						NewMap = maps:put(DunId, Dun, TemMap);
		    		_ ->
		    			NewMap = TemMap
				end;
			_ -> NewMap = TemMap
		end,
		NewMap
	end,
	DunState = lists:foldl(Fun, OldDunState, DunIds),
	State#territory_state{dun_state = DunState}.
%% 每次退出处理日志，清理内存数据
handle_out(State, RoleId) ->
	#territory_state{reward_map = RewardMap} = State,
	RewardMapList = maps:to_list(RewardMap),
	F1 = fun({{TDunId, TRoleId, Monid}, Reward}, {Acc, TemMap}) when RoleId == TRoleId ->
		case get_role_info(RoleId, State) of
			[] -> ?ERR("error data ~p~n",[1]),skip;
			#role_info{role_name = RoleName, dunid = DunId} ->
				RewardList1  = ulists:object_list_plus([Reward, []]),
				%% TODO 日志
				lib_log_api:log_territory_reward(RoleId, RoleName, DunId, Monid, RewardList1)
		end,
		NTmap = maps:remove({TDunId, RoleId, Monid}, TemMap),
		{Reward ++ Acc, NTmap};
	(_, {Acc, TemMap}) ->
		{Acc,TemMap}
	end,
	{RoleRewardList, NewMap} = lists:foldl(F1, {[], RewardMap}, RewardMapList),
	F2 = fun({Type, GoodsId, Num} = H, {TAcc, Accs}) when Type == 3 andalso GoodsId == 0 ->
		case lists:keyfind(3, 1, Accs) of
			{3, 0, Number} -> {[H|TAcc], [{Type, GoodsId, Number+Num}]};
			_ -> {[H|TAcc], [H|Accs]}
		end;
		(_, {TAcc, Accs}) -> {TAcc, Accs}
	end,
	{CoinList, RealCoins} = lists:foldl(F2, {[],[]}, RoleRewardList),
	RealReward = lists:subtract(RoleRewardList, CoinList),
	Pid = misc:get_player_process(RoleId),
	IsAlive = misc:is_process_alive(Pid),
	if
		IsAlive == true ->
			% ?PRINT("Reward:~p~n",[Reward]),
			lib_server_send:send_to_uid(RoleId, pt_652, 65205, [RealCoins++RealReward]);
		true ->
			skip
	end,
	State#territory_state{reward_map = NewMap}.


%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

get_role_info(RoleId, State) ->
	#territory_state{other_map = OtherMap} = State,
	case maps:get(RoleId, OtherMap, []) of
		#role_info{} = Role -> Role;
		_ -> Role = []
	end,
	Role.


rank_damage(Name, RoleId, Hurt, RankList) ->
    NewList = case lists:keyfind(Name, 1, RankList) of
        {Name, RoleId, OldHurt} ->
            lists:keystore(Name, 1, RankList, {Name, RoleId, OldHurt+Hurt});
        false ->
            lists:keystore(Name, 1, RankList, {Name, RoleId, Hurt})
    end,
    lists:keysort(3, NewList).

calc_all_weight([], Sum) -> Sum;
calc_all_weight([{_, Weight, _, _}|T], Sum) ->
    calc_all_weight(T, Sum + Weight).

% %% 保留小数点后几位数字 
% %% Float：需要处理的小数 Num:保留几位小数
% handle_float(Float, Num) ->
%     N = math:pow(10, Num),
%     round(Float * N)/N.

calc_produce_num(Produce, Sum, Worth) ->
    Fun = fun({AuctionId, _Weight, PercentNum, Sort}, {Acc, Acc1, TemSum}) ->
        BefNum = (Worth * PercentNum) div Sum,
        NumWeight = (Worth * 100 * PercentNum) div Sum rem 100,
        NumWeightList = [{100 - NumWeight, BefNum}, {NumWeight, BefNum+1}],
        RealNum = urand:rand_with_weight(NumWeightList),
        if
            RealNum == 0 ->
                {Acc, Acc1, TemSum};
            Sort == ?AUCTION_RARE ->
                {Acc, [{PercentNum, AuctionId}|Acc1], TemSum+RealNum};
            true ->
                {[{AuctionId, RealNum}|Acc], Acc1, TemSum}
        end;
        (_, TemAcc) -> TemAcc
    end,
    {NormalList, RareList, RareNumSum} = lists:foldl(Fun, {[],[], 0}, Produce),
    RareNum = (RareNumSum * 100) div 100,
    RareNumWeight = (RareNumSum * 100) rem 100,
    RareNumWeightList = [{100 - RareNumWeight, RareNum}, {RareNumWeight, RareNum+1}],
    RealRareNum = urand:rand_with_weight(RareNumWeightList),
    RareAuction = urand:rand_with_weight(RareList),
    if
        RealRareNum == 0 ->
            NormalList;
        true ->
            [{RareAuction, RealRareNum}|NormalList]
    end.