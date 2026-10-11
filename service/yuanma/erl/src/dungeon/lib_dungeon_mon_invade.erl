%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_mon_invade.erl

%% @author  xlh
%% @email   
%% @since   2018.12.22
%% @deprecated 异兽入侵
%% ---------------------------------------------------------------------------
-module(lib_dungeon_mon_invade).

%% 暂时屏蔽，定制活动配置开服天数限制，pp_dungeon: 61001 

-include("dungeon.hrl").
-include("language.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").

-export([
	dunex_get_send_reward/2
	, dunex_update_dungeon_record/2
	, handle_daily_reward/1
	, dunex_check_extra/2
	, gm_refresh/2
    , get_value_reward/2
    , gm_set_value/3
	]).


-define(PASSTIME,      1).
-define(VALUE,         2).
-define(NEXT_BORNTIME, 3).
-define(STATE,         4).
-define(DAY,           5).
%% [{1,_},{2,_},{3,_},{4,_},{5,_}]  玩家副本数据存放的数据为
%% 1.通关时间戳，
%% 2.守护值，
%% 3.异兽下次刷新时间0或者时间戳，
%% 4.阶段奖励领取状态（0未完成，1已完成未领取，2已领取）
%% 5.保存完成守护值当天的开服天数

dunex_get_send_reward(#dungeon_state{result_type = ResultType}, _) when ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
    [];

dunex_get_send_reward(_State, DunRole) ->
    #dungeon_role{figure = #figure{lv = RoleLv}} = DunRole,
    AllLv = data_mon_invade:get_all_lv_cfg(),
    case get_lv_cfg(RoleLv, AllLv) of
        {ok, LvCfg} -> 
            % ?PRINT("LvCfg:~p~n",[LvCfg]),
            case data_mon_invade:get_reward_cfg(LvCfg) of
                {StableReward, RandReward, RandReward2} ->
                    _RandReward = get_rand_reward(RandReward, []),
                    _RandReward2 = get_rand_reward(RandReward2, []),
                    WinReward = StableReward ++ _RandReward ++ _RandReward2;
                _ ->
                    % ?PRINT("LvCfg#########:~p~n",[LvCfg]),
                    WinReward = []
            end;
        _ -> 
            WinReward = []
    end,
    % ?PRINT("WinReward:~p~n",[WinReward]),
    [{?REWARD_SOURCE_DUNGEON, WinReward}].

get_lv_cfg(RoleLv,AllLv) ->
    F = fun(A, B) ->
        A > B
    end,
    NallLv = lists:sort(F, AllLv),
    % ?PRINT("NallLv:~p~n",[NallLv]),
    Fun = fun(TemLv) ->
        RoleLv >= TemLv
    end,
    ulists:find(Fun, NallLv).

% RandReward: [{reward_num, [{weight, goodstype, goodstypeid, num},...]}...]
get_rand_reward([], RewardList) -> RewardList;
get_rand_reward([{RewardNum, RandList}|T], TemRewardList) ->
	F = fun(_I, {NewRandList, List}) ->
		{W, GType, GTypeId, GNum} = util:find_ratio(NewRandList, 1),
		LastRandList = NewRandList -- [{W, GType, GTypeId, GNum}],
        if
            {GType, GTypeId, GNum} == {0,0,0} ->
                {LastRandList, List};
            true ->
                {LastRandList, [{GType, GTypeId, GNum}|List]}
        end
	end,
	{_, RewardList} = lists:foldl(F, {RandList, []}, lists:seq(1, RewardNum)),
	get_rand_reward(T, TemRewardList ++ RewardList).

dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = DunId
    } = ResultData,
   	NowTime =utime:unixtime(),
    OpenDay = util:get_open_day(NowTime),
	case data_mon_invade:get_value(born_time) of
		BornTime when is_integer(BornTime) andalso BornTime > 0 ->
			NextBossBornTime = utime:unixtime() + BornTime*60;
		_ ->
			NextBossBornTime = utime:unixtime() + 600
	end,
	NeedValue = get_value_cfg(need_value),
	AddValue = get_value_cfg(add_value_step),
    case maps:get(DunId, Record, []) of
        [{?PASSTIME, _OldPassTime}|_] = List ->
        	% ?PRINT("@#@#@$@#$@#$@$@$  List:~p~n",[List]),
        	
        			case lists:keyfind(2, 1, List) of
                		{2, Value} -> skip;
                		_ ->Value = 0
                	end,
                	case lists:keyfind(4, 1, List) of
                		{4, OldState} -> skip;
                		_ -> OldState = 0
                	end;
            
        _ ->
            Value = 0,OldState = 0
    end,
    if
    	Value + AddValue >= NeedValue andalso OldState =/= 2 ->
    		RealBornTime = utime:unixdate() + 100801, %%4点在线会重置为0,隔天第二次登陆也会重置为0
    		State = 1;
    	true -> 
    		RealBornTime = NextBossBornTime,
    	    State = OldState
    end,
    NewValue = Value + AddValue,
    Data = [{?PASSTIME, NowTime}, {?VALUE, NewValue}, {?NEXT_BORNTIME, RealBornTime}, {?STATE, State}, {?DAY, OpenDay}], %%
    % ?PRINT("Data:~p~n",[Data]),
    NewRecord = maps:put(DunId, Data, Record),
    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
    NewPlayer = PS#player_status{dungeon_record = NewRecord},
    % ?PRINT("#$@#!!#@!#@!#@!#,:~p~n",[1]), 
    pp_dungeon:handle(61093, NewPlayer, [?DUNGEON_TYPE_MON_INVADE, DunId]),
    NewPlayer.

dunex_check_extra(#player_status{dungeon_record = Record} = _Player, #dungeon{id = DunId, type = DunType} = _Dun)
        when DunType == ?DUNGEON_TYPE_MON_INVADE ->
    case maps:get(DunId, Record, []) of
        [_,_,{_,NextBornTime},_,_] ->
            NowTime = utime:unixtime(),
            if
                NowTime >= NextBornTime ->
                    true;
                true ->
                    {false, ?ERRCODE(err610_mon_not_refresh)}
            end;
        _ -> %% 说明是玩家活动开启后第一次登陆
            true
    end.

handle_daily_reward(Player) ->
	#player_status{login_time_before_last = LastLoginTime,
		 id = RoleId, dungeon_record = Record, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
	Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_MON_INVADE),
    case utime:is_same_day(utime:unixtime(), LastLoginTime) of
    	false ->
    		Fun = fun(DunId, Acc) ->
    			case maps:get(DunId, Acc, []) of
	        	    [{?PASSTIME, PassTime}, _, _, {?STATE, State}, {?DAY, OpenDay}] ->
	        	        IsSameDay = utime:is_same_day(utime:unixtime(), PassTime),
		        		% ?PRINT("IsSameDay:~p,PassTime:~p~n",[IsSameDay,PassTime]),
		        		if
		        		    State == 1 andalso IsSameDay == false ->
                                case get_value_reward(OpenDay, RoleLv) of
                                    TotalList when TotalList =/= [] -> skip;
                                    _ -> TotalList = data_mon_invade:get_value(stage_reward)
                                end,
	                            Title = utext:get(?LAN_TITLE_MON_INVADE_STAGE_REWARD),
	                            Content = utext:get(?LAN_CONTENT_MON_INVADE_STAGE_REWARD),
	                            lib_mail_api:send_sys_mail([RoleId], Title, Content, TotalList),
	                            Data = [{?PASSTIME, 0}, {?VALUE, 0}, {?NEXT_BORNTIME, 0}, {?STATE, 0}, {?DAY, 0}], %%
							    NewRecord = maps:put(DunId, Data, Acc),
							    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
							    NewRecord;
		                    IsSameDay == false ->
		                        Data = [{?PASSTIME, 0}, {?VALUE, 0}, {?NEXT_BORNTIME, 0}, {?STATE, 0}, {?DAY, 0}], %%
							    NewRecord = maps:put(DunId, Data, Acc),
							    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
							    NewRecord;
		                    true -> Acc
		        		end;
	                _ -> Acc
	            end
	        end,
	        NewRec = lists:foldl(Fun, Record, Ids),
            NewPlayer = Player#player_status{dungeon_record = NewRec};
        true ->
        	NewPlayer = Player
    end,
    {ok, NewPlayer}.

% push_settlement(State, DungeonRole) ->
%     #dungeon_state{
%                 result_type = ResultType, 
%                 dun_id = DunId,
%                 now_scene_id = SceneId,
%                 result_subtype = ResultSubtype
%             } = State,
%     Grade
%     = if
%         ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
%             0;
%         true ->
%             3
%     end,
%     RewardList = lib_dungeon:calc_base_reward_list(DungeonRole),
%     {ok, BinData} = pt_610:write(61003, [ResultType, ResultSubtype, DunId, Grade, SceneId, RewardList, []]),
%     lib_server_send:send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData).
		
% init_dungeon_role(#player_status{id = Id, dungeon_record = Record}, #dungeon{id = DunId, type = DunType}, Role) ->
%     CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
%     HelpNum = mod_daily:get_count_offline(Id, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType),
%     Role#dungeon_role{typical_data = #{help_num => HelpNum}};

% init_dungeon_role(_, _, Role) -> Role.

get_value_cfg(Key) ->
	case data_mon_invade:get_value(Key) of
		NeedValue when is_integer(NeedValue) -> skip;
		_ -> 
			?ERR("NO config data_mon_invade KV key = ~p~n",[Key]),
			if
				Key == need_value ->
					NeedValue = 500;
				Key == add_value_step ->
					NeedValue = 50;
				Key == born_time ->
					NeedValue = 10;
				true ->
					NeedValue = 1
			end
	end,
	NeedValue.

get_value_reward(OpenDay, RoleLv) when OpenDay =/= 0 ->
    DayList = data_mon_invade:get_all_day(),
    LvList = data_mon_invade:get_all_lv(),
    case lists:member(OpenDay, DayList) of
        true ->
            case data_mon_invade:get_day_cfg(OpenDay, 0) of
                #mon_invade_cfg{reward = RewardCfg, num = Num, is_repeat = IsRepeat} ->
                    get_value_reward_cfg(RewardCfg, Num, IsRepeat);
                _ -> []
            end;
        false ->
            case get_lv_cfg(RoleLv, LvList) of
                {ok, LvCfg} -> 
                    case data_mon_invade:get_day_cfg(0, LvCfg) of
                        #mon_invade_cfg{reward = RewardCfg, num = Num, is_repeat = IsRepeat} ->
                            get_value_reward_cfg(RewardCfg, Num, IsRepeat);
                        _ -> []
                    end;
                _ ->
                    ?ERR("cfg lost role_lv:~p, Lvlist：~p~n",[RoleLv, LvList]), 
                    []
            end
    end;
get_value_reward(_OpenDay, _RoleLv) -> 
    ?ERR("Err data _OpenDay:~p, _RoleLv~p~n",[_OpenDay, _RoleLv]), 
    [].

get_value_reward_cfg(RewardCfg, Num, IsRepeat) ->
    Fun = fun({Weight, Type, GoodsTypeId, NumC}, Acc) ->
        [{Weight, {Type, GoodsTypeId, NumC}}|Acc]
    end,
    WeightList = lists:foldl(Fun, [], RewardCfg),
    get_value_reward_cfg_helper(WeightList, IsRepeat, Num, []).

get_value_reward_cfg_helper(_WeightList, _IsRepeat, 0, RealReward) -> RealReward;
get_value_reward_cfg_helper(WeightList, IsRepeat, Num, RealReward) ->
    case urand:rand_with_weight(WeightList) of
        {_, _, _} = TemReward -> 
            if
                IsRepeat == 1 -> %% 可重复
                    get_value_reward_cfg_helper(WeightList, IsRepeat, Num - 1, [TemReward|RealReward]);
                true ->
                    case lists:keytake(TemReward, 2, WeightList) of
                        {value, _, NewWeightList} -> NewWeightList;
                        _Err -> 
                            ?ERR("error cfg IsRepeat = ~p, Num =~p, WeightList = ~p~n",[IsRepeat, Num, WeightList]),
                            NewWeightList = WeightList
                    end,
                    get_value_reward_cfg_helper(NewWeightList, IsRepeat, Num - 1, [TemReward|RealReward])
            end;
        _ ->
            ?ERR("error cfg IsRepeat = ~p, Num =~p, WeightList = ~p~n",[IsRepeat, Num, WeightList]),
            []
    end.

gm_refresh(PS, DunId) ->
	#player_status{dungeon_record = Record} = PS,
	case maps:get(DunId, Record, []) of
		[_,_,_,_,_] = List ->
			NewList = lists:keystore(?NEXT_BORNTIME, 1, List, {?NEXT_BORNTIME, 0});
        _ ->
        	NewList = [{?PASSTIME, 0}, {?VALUE, 0}, {?NEXT_BORNTIME, 0}, {?STATE, 0}, {?DAY, 0}]
    end,
    NewRecord = maps:put(DunId, NewList, Record),
    NewPS = PS#player_status{dungeon_record = NewRecord},
    pp_dungeon:handle(61093, NewPS, [?DUNGEON_TYPE_MON_INVADE, DunId]),
    NewPS.

gm_set_value(PS, DunId, Value) ->
    #player_status{dungeon_record = Record} = PS,
    NeedValue = get_value_cfg(need_value),
    OpenDay = util:get_open_day(),
    case maps:get(DunId, Record, []) of
        [_,_,_,_,_] = List ->
            TemList1 = lists:keystore(?VALUE, 1, List, {?VALUE, max(0, Value)}),
            TemList = lists:keystore(?VALUE, 1, TemList1, {?DAY, OpenDay}),
            if
                Value >= NeedValue ->
                    NewList = lists:keystore(?VALUE, 1, TemList, {?STATE, 1});
                true ->
                    NewList = TemList
            end;
        _ ->
            if
                Value >= NeedValue ->
                    NewList = [{?PASSTIME, 0}, {?VALUE, Value}, {?NEXT_BORNTIME, 0}, {?STATE, 1}, {?DAY, OpenDay}];
                true ->
                    NewList = [{?PASSTIME, 0}, {?VALUE, max(0, Value)}, {?NEXT_BORNTIME, 0}, {?STATE, 0}, {?DAY, OpenDay}]
            end
    end,
    NewRecord = maps:put(DunId, NewList, Record),
    NewPS = PS#player_status{dungeon_record = NewRecord},
    pp_dungeon:handle(61093, NewPS, [?DUNGEON_TYPE_MON_INVADE, DunId]),
    NewPS.