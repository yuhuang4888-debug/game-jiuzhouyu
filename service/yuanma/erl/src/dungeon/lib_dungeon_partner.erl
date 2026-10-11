%%%-----------------------------------
%%% @Module      : lib_dungeon_partner
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 24. 四月 2020 16:44
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_dungeon_partner).
-author("carlos").

-include("server.hrl").
-include("dungeon.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").
-include("team.hrl").
-include("figure.hrl").
%% API
-export([]).

dunex_check_extra(PS, Dun) ->
    #player_status{dungeon_record = DunRecord} = PS,
    #dungeon{id = DunId} = Dun,
    Record = maps:get(DunId, DunRecord, []),
    case lists:keyfind(?DUNGEON_REC_SCORE, 1, Record) of
        {_, Score} when Score >= 3 ->
            {false, ?ERRCODE(err610_partner_max_score)};
        _ ->
            true
    end.

%%更新副本记录，用于副本通关时的调用
dunex_update_dungeon_record(PS, ResultData) ->
	#player_status{id = RoleId, dungeon_record = Record} = PS,
	#callback_dungeon_succ{
		dun_id = DunId,
		pass_time = PassTime
	} = ResultData,
%%    ?DEBUG("DunId  ~p~n PassTimes ~p~n ResData ~p~n", [DunId, PassTime, ResultData]),
	if
		PassTime >= 0 ->
			BestRecordList = maps:get(DunId, Record, []),
			if
				BestRecordList == [] ->
					Score = lib_dungeon:get_time_score(DunId, PassTime),
					update_dungeon_record_help(PS, Score, DunId, RoleId, Record, PassTime);
				true ->
					case lists:keyfind(?DUNGEON_REC_SCORE, 1, BestRecordList) of
						{?DUNGEON_REC_SCORE, OldScore} ->
							Score = lib_dungeon:get_time_score(DunId, PassTime),
							if
								Score > OldScore ->
									update_dungeon_record_help(PS, Score, DunId, RoleId, Record, PassTime);
								true ->
									PS
							end;
						_ ->
							PS
					end
			end;
		true ->
			PS
	end.

update_dungeon_record_help(PS, Score, DunId, RoleId, Record, PassTime) ->
	if
		Score >= 3->
			%% 副本首杀
			mod_boss_first_blood_plus:boss_be_killed_for_partner_dun(?CUSTOM_ACT_TYPE_DUN_FIRST_KILL,
				1, DunId, RoleId);
		true ->
			ok
	end,
	Data = [{?DUNGEON_REC_PASSTIME, PassTime}, {?DUNGEON_REC_SCORE, Score}],
	NewRecord = maps:put(DunId, Data, Record),
	lib_dungeon:save_dungeon_record(RoleId, DunId, Data),  %%同步到数据库
	PS#player_status{dungeon_record = NewRecord}.


login(PS) ->
	#player_status{id = RoleId} = PS,
	Sql = io_lib:format(<<"select  chapter_id,  stage_reward  from  partner_dun_chapter  where role_id = ~p">>,
		[RoleId]),
	List = db:get_all(Sql),
	F = fun([ChapterId, DbStageReward], AccList) ->
			Chapter = #partner_dun_chapter{chapter = ChapterId,
				stage_reward = util:bitstring_to_term(DbStageReward)},
			[Chapter |AccList]
		end,
	ChapterList = lists:foldl(F, [], List),
	PS#player_status{partner_dun = ChapterList}.


save_to_db(RoleId, ChapterList) ->
	[begin
		 timer:sleep(100),
		 Sql = io_lib:format(<<"replace into partner_dun_chapter(role_id,
		 chapter_id, stage_reward) VALUES(~p, ~p, '~s')">>, [RoleId, ChapterId, util:term_to_string(StageReward)]),
		 db:execute(Sql)
	 end || #partner_dun_chapter{chapter = ChapterId,
		stage_reward = StageReward} <- ChapterList].




%% 获取伙伴副本层数信息
get_level_info(Player, Level) ->
	case data_dungeon:get_partner_dun_list(Level) of
		DunList when DunList =/= [] ->
			#player_status{dungeon_record = DungeonRecord} = Player,
			F = fun(DunId, AccList) ->
					DunMsg = maps:get(DunId, DungeonRecord, []),
					case lists:keyfind(?DUNGEON_REC_SCORE, 1, DunMsg) of
						{_, Score} ->
							[{DunId, Score} | AccList];
						_ ->
							[{DunId, 0} | AccList]
					end
				end,
			PackList = lists:reverse(lists:foldl(F, [], DunList)),
%%			?PRINT("Level ~p, PackList ~p~n", [Level, PackList]),
			SweepCount = mod_daily:get_count(Player#player_status.id, ?MOD_DUNGEON, 12),
			{ok, Bin} = pt_611:write(61105, [Level, SweepCount, PackList]),
			lib_server_send:send_to_uid(Player#player_status.id, Bin);
		_ ->
			skip
	end.

%% 获取伙伴副本总积分星星
get_all_dun_score(PS) ->
	#player_status{dungeon_record = DungeonRecord} = PS,
	LevelList = data_dungeon:get_partner_dun_chapter(),
	F = fun(Level, AccScore) ->
		DunList = data_dungeon:get_partner_dun_list(Level),
		Score = get_all_score(DunList, DungeonRecord),
		AccScore + Score
	end,
	lists:foldl(F, 0, LevelList).


%% -----------------------------------------------------------------
%% @desc     功能描述    阶段奖励领取信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_stage_info(Player, Level) ->
	case data_dungeon:get_partner_dun_list(Level) of
		DunList when DunList =/= [] ->
			#player_status{dungeon_record = DungeonRecord, partner_dun = PartnerDun} = Player,
			#partner_dun_chapter{stage_reward = StageReward} = get_role_dungeon_level_msg(Level, PartnerDun),
			AllScore = get_all_score(DunList, DungeonRecord),
			StageRewardCfg = data_dungeon:get_partner_stage_reward(Level),
			F = fun({NeedScore, _}, AccList) ->
				case lists:keyfind(NeedScore, 1, StageReward) of
					{_, 2} -> %% 已经领取了
						[{NeedScore, 2} | AccList];
					_ ->
						if
							AllScore >= NeedScore ->  %% 没有领取，可以领取
								[{NeedScore, 1} | AccList];
							true ->
								[{NeedScore, 0} | AccList]    %%不能领取
						end
				end
				end,
			PackList = lists:reverse(lists:foldl(F, [], StageRewardCfg)),
			{ok, Bin} = pt_611:write(61106, [Level, PackList]),
%%			?PRINT("Level ~p, PackList ~p~n", [Level, PackList]),
			lib_server_send:send_to_uid(Player#player_status.id, Bin);
		_ ->
			skip
	end.


get_all_score(DunList, DungeonRecord) ->
	F = fun(DunId, AllScore) ->
			DunMsg = maps:get(DunId, DungeonRecord, []),
			case lists:keyfind(?DUNGEON_REC_SCORE, 1, DunMsg) of
				{_, Score} ->
					AllScore + Score;
				_ ->
					AllScore
			end
		end,
	lists:foldl(F, 0, DunList).


get_role_dungeon_level_msg(Level, PartnerDun) ->
	case lists:keyfind(Level, #partner_dun_chapter.chapter, PartnerDun) of
		Chapter when is_record(Chapter, partner_dun_chapter) ->
			Chapter;
		_ ->
			#partner_dun_chapter{}
	end.





%% -----------------------------------------------------------------
%% @desc     功能描述  领取阶段奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_stage_reward(Player, Level, Score) ->
	#player_status{partner_dun = PartnerDun, id = RoleId, dungeon_record = DungeonRecord} = Player,
	DunList = data_dungeon:get_partner_dun_list(Level),
	AllScore = get_all_score(DunList, DungeonRecord),
	case lists:keyfind(Level, #partner_dun_chapter.chapter, PartnerDun) of
		#partner_dun_chapter{stage_reward = StageReward} = OldChapter->
			case lists:keyfind(Score, 1, StageReward) of
				{Score, 2} ->  %% 已经领取了
%%					?PRINT("reward ++++++++++++++++++++++~n", []),
					{ok, Bin} = pt_611:write(61108, [?ERRCODE(err610_had_receive_reward), []]),
					lib_server_send:send_to_uid(RoleId, Bin),
					Player;
				_ ->%%  没有相关信息
					if
						AllScore >=  Score ->  %% 可以领取
							%%发送奖励
							Cfg = data_dungeon:get_partner_stage_reward(Level),
							case lists:keyfind(Score, 1, Cfg) of
								{_, Reward} ->
%%									?PRINT("reward ~p~n", [Reward]),
									lib_goods_api:send_reward_with_mail(RoleId, #produce{type = dun_partner_stage_reward, reward = Reward}),
									StageRewardNew = lists:keystore(Score, 1, StageReward, {Score, 2}),
									PartnerDunNew = lists:keystore(Level, #partner_dun_chapter.chapter,
										PartnerDun, OldChapter#partner_dun_chapter{stage_reward = StageRewardNew}),
									{ok, Bin} = pt_611:write(61108, [?SUCCESS, Reward]),
									lib_server_send:send_to_uid(RoleId, Bin),
									save_to_db(RoleId, PartnerDunNew),
									Player#player_status{partner_dun = PartnerDunNew};
								_ ->
									{ok, Bin} = pt_611:write(61108, [?FAIL, []]),
									lib_server_send:send_to_uid(RoleId, Bin),
									Player
							end;
						true ->
							{ok, Bin} = pt_611:write(61108, [?FAIL, []]),
							lib_server_send:send_to_uid(RoleId, Bin),
							Player
					end
			end;
		_ ->
			if
				AllScore >=  Score ->  %% 可以领取
					%%发送奖励
					Cfg = data_dungeon:get_partner_stage_reward(Level),
					case lists:keyfind(Score, 1, Cfg) of
						{_, Reward} ->
							lib_goods_api:send_reward_with_mail(RoleId, #produce{type = dun_partner_stage_reward, reward = Reward}),
							StageRewardNew = [{Score, 2}],
							PartnerDunNew = lists:keystore(Level, #partner_dun_chapter.chapter,
								PartnerDun, #partner_dun_chapter{stage_reward = StageRewardNew, chapter = Level}),
							{ok, Bin} = pt_611:write(61108, [?SUCCESS, Reward]),
							lib_server_send:send_to_uid(RoleId, Bin),
							save_to_db(RoleId, PartnerDunNew),
							Player#player_status{partner_dun = PartnerDunNew};
						_ ->
							{ok, Bin} = pt_611:write(61108, [?FAIL, []]),
							lib_server_send:send_to_uid(RoleId, Bin),
							Player
					end;
				true ->
					{ok, Bin} = pt_611:write(61108, [?FAIL, []]),
					lib_server_send:send_to_uid(RoleId, Bin),
					Player
			end
	end.



sweep(Player, Level) ->
	#player_status{dungeon_record = DungeonRecord, id = RoleId, figure = Figure} = Player,
	%% 检查是否满足条件
	SweepCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, 12),
	Count = lib_vip_api:get_vip_privilege(Player, ?MOD_DUNGEON, 2000037),
	DunList = data_dungeon:get_partner_dun_list(Level),
	AllScore = length(DunList) * 3,
	MyScore = get_all_score(DunList, DungeonRecord),
	Mul = lib_dungeon:get_mul_drop_times(?DUNGEON_TYPE_PARTNER_NEW, Player),
	if
		SweepCount >= Count->
			{ok, Bin} = pt_611:write(61109, [?ERRCODE(err610_dungeon_count_daily), []]),
			lib_server_send:send_to_uid(RoleId, Bin),
			Player;
		true -> %% err610_sweep_never_finish
			case data_dungeon:get_partner_sweep_reward(Level) of
				Reward when  Reward =/= [] ->
					if
						MyScore =< 0 ->
							{ok, Bin} = pt_611:write(61109, [?ERRCODE(err610_sweep_never_finish), []]),
							lib_server_send:send_to_uid(RoleId, Bin),
							Player;
						true ->
							CostList = data_dungeon_special:get(?DUNGEON_TYPE_PARTNER_NEW, dun_partner_sweep_cost),
							case lists:keyfind(SweepCount + 1, 1, CostList) of
								{_, Cost} ->
									ok;
								_ ->
									Cost = []
							end,
                            %% 事件触发
                            CallbackData = #callback_dungeon_sweep{dun_type = ?DUNGEON_TYPE_PARTNER_NEW, count = 1},
                            lib_player_event:async_dispatch(RoleId, ?EVENT_DUNGEON_SWEEP, CallbackData),
							%% dun_partner_sweep_cost
							if
								Cost == [] ->
									mod_daily:increment(RoleId, ?MOD_DUNGEON, 12),
									RewardNewTemp = [{Type, GoodsId, umath:floor(Num * MyScore / AllScore)} ||{Type, GoodsId, Num} <-Reward, umath:floor(Num * MyScore / AllScore) > 0],
									if
										Mul > 1 ->
											RewardMul = [{Type, GoodsId, round(Num * (Mul -1))} || {Type, GoodsId, Num} <- RewardNewTemp];
										true ->
											RewardMul = []
									end,
									RewardAll =  RewardNewTemp ++ RewardMul,
									lib_log_api:log_single_dungeon_sweep(RoleId, Figure#figure.lv, MyScore, Level, ?DUNGEON_TYPE_PARTNER_NEW, RewardAll, 1, Cost),
									lib_hi_point_api:hi_point_task_sweep_dun(Player#player_status.id, Player#player_status.figure#figure.lv, ?DUNGEON_TYPE_PARTNER_NEW, 1),
                                    % 奖励发放
									lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardAll, type = dun_partner_sweep_reward}),
									{ok, Bin} = pt_611:write(61109, [?SUCCESS, RewardNewTemp, RewardMul, Mul]),
									lib_server_send:send_to_uid(RoleId, Bin),
									{ok, LastPs} = lib_supreme_vip_api:dun_clean(Player, ?DUNGEON_TYPE_PARTNER_NEW, 1),
									LastPs;
								true ->
									case lib_goods_api:cost_object_list_with_check(Player, Cost, dun_partner_sweep_cost, "") of
										{true,  NewPs} ->
											mod_daily:increment(RoleId, ?MOD_DUNGEON, 12),
											RewardNewTemp = [{Type, GoodsId, umath:floor(Num * MyScore / AllScore)} ||{Type, GoodsId, Num} <-Reward, umath:floor(Num * MyScore / AllScore) > 0],
											if
												Mul > 1 ->
													RewardMul = [{Type, GoodsId, round(Num * (Mul -1))} || {Type, GoodsId, Num} <- RewardNewTemp];
												true ->
													RewardMul = []
											end,
											RewardAll =  RewardNewTemp ++ RewardMul,
											case RewardNewTemp of
												[] ->
													{ok, Bin} = pt_611:write(61109, [?MISSING_CONFIG, []]),
													lib_server_send:send_to_uid(RoleId, Bin),
													NewPs;
												_ ->
													%% log
													lib_log_api:log_single_dungeon_sweep(RoleId, Figure#figure.lv, MyScore, Level, ?DUNGEON_TYPE_PARTNER_NEW, RewardAll, 1, Cost),
                                                    lib_hi_point_api:hi_point_task_sweep_dun(Player#player_status.id, Player#player_status.figure#figure.lv, ?DUNGEON_TYPE_PARTNER_NEW, 1),
													{ok, LastPs} = lib_supreme_vip_api:dun_clean(NewPs, ?DUNGEON_TYPE_PARTNER_NEW, 1),
													% 奖励发放
													lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardAll, type = dun_partner_sweep_reward}),
													{ok, Bin} = pt_611:write(61109, [?SUCCESS, RewardNewTemp, RewardMul, Mul]),
													lib_server_send:send_to_uid(RoleId, Bin),
													LastPs
											end;
										{false, ERR, _} ->
											{ok, Bin} = pt_611:write(61109, [ERR, []]),
											lib_server_send:send_to_uid(RoleId, Bin),
											Player
									end
							end


					end;
				_ ->
					{ok, Bin} = pt_611:write(61109, [?MISSING_CONFIG, []]),
					lib_server_send:send_to_uid(RoleId, Bin),
					Player
			end
	end.



dunex_handle_kill_mon(State, Mid, _CreateKey, _DieDatas) ->
	#dungeon_state{
		typical_data = TypicalData,dun_id = DunId,
		now_scene_id = SceneId,
		scene_pool_id = ScenePoolId
	} = State,
	CopyId = self(),
	MonList = maps:get(?DUN_STATE_SPECIAL_KEY_PARTNER_KILL_MSG, TypicalData, []),
	case lists:keyfind(Mid, 1, MonList) of
		{Mid, OldNum} ->
			NewMonList = lists:keystore(Mid, 1, MonList, {Mid, OldNum + 1});
		_ ->
			NewMonList = lists:keystore(Mid, 1, MonList, {Mid, 1})
	end,
	%% 发送信息给客户端
	PackList = get_mon_pack_msg(NewMonList, DunId),
	{ok, Bin} = pt_611:write(61110, [PackList]),
	mod_scene_agent:send_to_scene(SceneId, ScenePoolId, CopyId, Bin),
	NewTypicalData2 = maps:put(?DUN_STATE_SPECIAL_KEY_PARTNER_KILL_MSG, NewMonList, TypicalData),
	State#dungeon_state{typical_data = NewTypicalData2}.


get_mon_pack_msg(NewMonList, DunId) ->
	case data_dungeon:get(DunId) of
		#dungeon{mon_event = Event} ->
			case Event of
				[{Scene, WaveList}] ->
					F = fun({_Id, Wave, _, _}, AccList) ->
							case data_dungeon_wave:get_wave(DunId, Scene, Wave, 1) of
								#dungeon_wave{rand_num = RanNum, mon_list = CfgMonList} ->
									case RanNum of
										[{Num, _, _Type} | _] ->
											ok;
										_ ->
											Num = 1
									end,
									[{MonId, _X, _Y, _Weight, _AttrList} | _] = CfgMonList,
									case lists:keyfind(MonId, 1, NewMonList)  of
										{_, KillNum} ->
											ok;
										_ ->
											KillNum = 0
									end,
									[{MonId, KillNum, Num}|AccList];
								_ ->
									AccList
							end
						end,
					lists:reverse(lists:foldl(F, [], WaveList));
				_ ->
					[]
			end;
		_ ->
			[]
	end.

get_partner_mon_msg(RoleId, State) ->
	#dungeon_state{
		typical_data = TypicalData,dun_id = DunId
	} = State,
	MonList = maps:get(?DUN_STATE_SPECIAL_KEY_PARTNER_KILL_MSG, TypicalData, []),
	PackList = get_mon_pack_msg(MonList, DunId),
	{ok, Bin} = pt_611:write(61110, [PackList]),
	lib_server_send:send_to_uid(RoleId, Bin).


init_dungeon_role(Player, Dun, Role) ->
	#player_status{dungeon_record = Record} = Player,
	#dungeon{id = DunId} = Dun,
	#dungeon_role{typical_data = Data} = Role,
	DunRecord = maps:get(DunId, Record, []),
	NewData = maps:put(?DUN_ROLE_SPECIAL_PARTNER_RECORD, DunRecord, Data),
	Role#dungeon_role{typical_data = NewData}.



%   2:走评分
%   return  [{来源, 奖励列表}]  eg: [{?REWARD_SOURCE_DUNGEON, BaseRewards}]
dunex_get_send_reward(
	#dungeon_state{dun_type = _DunType, dun_id = DunId, result_type = ResultType} = State
	, #dungeon_role{id = RoleId, figure = Figure, drop_times_args = _DropTimeArgs, is_first_reward = IsFirstReward, reward_ratio = _RewardRatio, typical_data = DataMap} = DungeonRole
) ->
	if
		ResultType =:= ?DUN_RESULT_TYPE_SUCCESS andalso DungeonRole#dungeon_role.help_type =:= ?HELP_TYPE_NO ->
			case IsFirstReward == 1 of
				true -> FirstReward = lib_dungeon:get_extra_reward(Figure, DunId, ?DUN_EXTRA_REWARD_TYPE_FIRST);
				false -> FirstReward = []
			end,
			Score = lib_dungeon:calc_score(State, RoleId),
			DunRecord = maps:get(?DUN_ROLE_SPECIAL_PARTNER_RECORD, DataMap, []),
			case lists:keyfind(?DUNGEON_REC_SCORE, 1, DunRecord) of
				{_, MaxScore} ->
					ok;
				_ ->
					MaxScore = 0
			end,
			BaseRewards = get_score_reward(DungeonRole, MaxScore, Score, DunId),
%%			N = case lib_dungeon_mod:get_drop_times(Figure, DunType, DropTimeArgs) of  %% 不用多倍奖励
%%				    N0 when N0 > 1 -> RewardRatio+N0-1;
%%				    _ -> RewardRatio
%%			    end,
%%			case N > 0 of
%%				true -> MultiRewards = lib_goods_util:goods_object_multiply_by(BaseRewards, N);
%%				false -> MultiRewards = []
%%			end,
%%                    ?MYLOG("cym", "MultiRewards ~p~n", [MultiRewards]),
			[{?REWARD_SOURCE_DUNGEON, BaseRewards}] ++ [{?REWARD_SOURCE_FIRST, FirstReward}];
%%				[{?REWARD_SOURCE_DUNGEON_MULTIPLE, MultiRewards}] ++ [{?REWARD_SOURCE_FIRST, FirstReward}];
		true -> % 1:助战没有奖励
			[]
	end.

get_score_reward(_DungeonRole, OldScore, Score, _DunId) when OldScore >= Score->
	[];
get_score_reward(DungeonRole, OldScore, Score, DunId) ->
	get_score_reward2(DungeonRole, OldScore + 1, Score, DunId, []).


get_score_reward2(_DungeonRole, Score, MaxScore, _DunId, AccList)  when Score > MaxScore ->
	AccList;
get_score_reward2(DungeonRole, Score, MaxScore, DunId, AccList)   ->
	Reward = lib_dungeon_api:get_dungeon_grade(DungeonRole, DunId, Score),
	get_score_reward2(DungeonRole, Score + 1, MaxScore, DunId, Reward ++ AccList).