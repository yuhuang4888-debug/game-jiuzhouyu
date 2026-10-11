%%-----------------------------------------------------------------------------
%% @Module  :       lib_train_act
%% @Author  :       lxl
%% @Email   :       
%% @Created :       2019-06-17
%% @Description:    培养活动
%%-----------------------------------------------------------------------------
-module(lib_train_act).
-include("server.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-compile(export_all).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 增加新类型升战升阶活动 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. get_train_stage_with_type、get_train_power_with_type 增加自己功能的战力信息
%% 2. 增加 xxx_train_power_up函数，用于功能战力变化后，推送客户端刷新红点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ---------------------------------------- 活动结束
act_close(_Type, _SubType) ->
	%spawn(fun() -> db_delete_train_init_state(Type, SubType) end),
	ok.

%% 奖励状态
send_reward_status(PS, ActInfo) ->
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	TrainInitState = get_initial_train_info(PS, Type, SubType, STime, ETime),
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format
            } = RewardCfg ->
            	case can_show_in_this_act(TrainInitState, ActInfo, RewardCfg) of 
            		true ->
		                %% 计算奖励的领取状态
		                Status = lib_custom_act:count_reward_status(PS, ActInfo, RewardCfg),
		                ReceiveTimes = 0,
		                RealInfo = get_real_info(PS, ActInfo, RewardCfg),
		                ConditionStr = util:term_to_string(Condition++RealInfo),
		                Reward = get_normal_reward(PS, ActInfo, RewardCfg),
		                ExtraReward = get_extra_reward(TrainInitState, ActInfo, RewardCfg),
		                RewardStr = util:term_to_string(Reward++ExtraReward),
		                [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
		            _ ->
		            	Acc
		        end;
            _ -> Acc
        end
        end,
    PackList = lists:foldl(F, [], GradeIds),
    %?PRINT(Type==65 andalso SubType==1, "reward status ~p~n", [PackList]),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData).

get_normal_reward(PS, ActInfo, RewardCfg) ->
	RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg),
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	TrainInitState = get_initial_train_info(PS, Type, SubType, STime, ETime),
	case Type == ?CUSTOM_ACT_TYPE_TRAIN_STAGE of 
		true -> %% 
			#custom_act_reward_cfg{condition = Condition} = RewardCfg,
			#train_init_state{infos = Infos} = TrainInitState,
			{_, _TrainType, TypeId} = lists:keyfind(train_type, 1, Condition),
			{_, [StageInit, StarInit, _FirstRewardId]} = ulists:keyfind(TypeId, 1, Infos, {TypeId, [0, 0, 0]}),
			case is_achieve_max_stage(Type, SubType, StageInit, StarInit) of 
				true ->
					NewRewardList = [{GType, GTypeId, umath:ceil(GNum/5)} ||{GType, GTypeId, GNum} <- RewardList],
					NewRewardList;
				_ ->
					RewardList
			end;
		_ ->
			RewardList
	end.


get_extra_reward(PS, ActInfo, RewardCfg) when is_record(PS, player_status) ->
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	TrainInitState = get_initial_train_info(PS, Type, SubType, STime, ETime),
	get_extra_reward(TrainInitState, ActInfo, RewardCfg);
get_extra_reward(TrainInitState, ActInfo, RewardCfg) ->
	#act_info{key = {Type, SubType}} = ActInfo,
	case Type == ?CUSTOM_ACT_TYPE_TRAIN_STAGE of 
		true -> %% 
			#custom_act_reward_cfg{condition = Condition} = RewardCfg,
			#train_init_state{infos = Infos} = TrainInitState,
			{_, _TrainType, TypeId} = lists:keyfind(train_type, 1, Condition),
			{_, [_StageInit, _StarInit, FirstRewardId]} = ulists:keyfind(TypeId, 1, Infos, {TypeId, [0, 0, 0]}),
			ShowNum = get_reward_show_num(FirstRewardId, Type, SubType, RewardCfg),
			ExtraReward = get_train_show_level_reward(Type, SubType, ShowNum),
			ExtraReward;
		_ ->
			[]
	end.

get_real_info(PS, ActInfo, RewardCfg) ->
	#act_info{key = {Type, _Subtype}} = ActInfo,
	#custom_act_reward_cfg{condition = Conditions} = RewardCfg,
	case lists:keyfind(train_type, 1, Conditions) of
        {train_type, TrainType, Value} ->
            case Type of 
            	?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
            		{Stage, Star} = lib_train_act:get_train_stage_with_type(PS, TrainType, Value),
            		[{real_stage, Stage, Star}];
            	?CUSTOM_ACT_TYPE_TRAIN_POWER ->
            		Power = lib_train_act:get_train_power_with_type(PS, TrainType, Value),
            		[{real_power, Power}];
            	_ ->
            		[]
            end;
        _ ->
            []
    end.

%% 过滤不显示的奖励
can_show_in_this_act(TrainInitState, ActInfo, RewardCfg) ->
	#custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
	#act_info{key = {Type, Subtype}} = ActInfo,
	#train_init_state{infos = Infos} = TrainInitState,
	ShowNumMax = get_train_act_max_show_num(Type, Subtype),
	case lists:keyfind(train_type, 1, Condition) of 
		{_, _TrainType, TypeId} ->
			case Type of 
				?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
					case is_fix_reward(RewardCfg) of 
						true -> true;
						_ ->
							%{_, Stage, Star} = ulists:keyfind(stage, 1, Condition, {stage, 0, 0}),
							{_, [_StageInit, _StarInit, FirstRewardId]} = ulists:keyfind(TypeId, 1, Infos, {TypeId, [0, 0, 0]}),
							%CanShow = (Stage > StageInit orelse (Stage == StageInit andalso Star > StarInit)),
							case GradeId >= FirstRewardId of 
								true ->
									ShowNum = get_reward_show_num(FirstRewardId, Type, Subtype, RewardCfg),
									case ShowNum =< ShowNumMax of 
										true -> true;
										_ -> false
									end;
								_ ->
									false
							end
					end;
				?CUSTOM_ACT_TYPE_TRAIN_POWER ->
					{_, PowerMin, PowerMax} = ulists:keyfind(power_show, 1, Condition, {power_show, 0, 0}),
					{_, [PowerInit]} = ulists:keyfind(TypeId, 1, Infos, {TypeId, [0]}),
					case PowerInit >= PowerMin andalso PowerInit < PowerMax of 
						true -> true; 
						_ -> false
					end;
				_ ->
					false
			end;
		_ ->
			false
	end.

get_reward_show_num(FirstRewardId, Type, SubType, RewardCfg) ->
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	#custom_act_reward_cfg{grade = RewardId} = RewardCfg,
	NewGradeIds = [Id || Id <- GradeIds, Id >= FirstRewardId],
	F = fun(Id) ->
		Id == RewardId
	end,
	ulists:find_index(F, NewGradeIds).

is_achieve_max_stage(Type, SubType, StageInit, StarInit) ->
	#custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
	case lists:keyfind(max_stage, 1, ActCondition) of 
		{max_stage, MaxStage, MaxStar} ->
			case (StageInit > MaxStage) orelse (StageInit == MaxStage andalso StarInit >= MaxStar) of 
				true -> true;
				_ -> false
			end;
		_ ->
			false
	end.

%% ==================================== 获取培养物的阶数信息
get_train_stage_with_type(PS, mount, MountType) ->
	Value = lib_mount:get_train_stage_star(MountType, PS),
	%?PRINT("get_train_stage_with_type##MountType: ~p~n", [{MountType, Value}]),
	Value;
get_train_stage_with_type(_PS, _, _MountType) ->
	{0, 0}.

%% ==================================== 获取培养物的战力信息
get_train_power_with_type(PS, mount, MountType) ->
	Value = lib_mount:get_train_combat(MountType, PS),
	%?PRINT("get_train_power_with_type##MountType: ~p~n", [{MountType, Value}]),
	Value;
get_train_power_with_type(PS, stone, _) ->
	Value = lib_equip:get_equip_sub_mod_power(PS, ?EQUIP_STONE_POWER),
	%?PRINT("get_train_power_with_type##MountType: ~p~n", [{stone, Value}]),
	Value;
get_train_power_with_type(PS, dragon, _) ->
	Value = lib_dragon_api:get_dragon_power(PS),
	%?PRINT("get_train_power_with_type##MountType: ~p~n", [{dragon, Value}]),
	Value;
get_train_power_with_type(PS, rune, _) ->
	Value = lib_rune:get_power(PS),
	%?PRINT("get_train_power_with_type##MountType: ~p~n", [{rune, Value}]),
	Value;
get_train_power_with_type(_PS, _, _MountType) ->
	0.

%% ==================================== 获取培养物活动开始时的初始信息
get_initial_train_info(PS, Type, SubType, STime, ETime) ->
	case get({?MODULE, Type, SubType}) of 
		#train_init_state{infos = Infos, utime = UTime} = TrainInitState when UTime >= STime andalso UTime < ETime andalso length(Infos) > 0 ->
			%?PRINT("get_initial_train_info 111 ~p~n", [TrainInitState]),
			TrainInitState;
		_ ->
			TrainInitState = init_train_state(PS, Type, SubType, STime, ETime),
			put({?MODULE, Type, SubType}, TrainInitState),
			%?PRINT("get_initial_train_info 222 ~p~n", [TrainInitState]),
			TrainInitState
	end.

init_train_state(PS, Type, SubType, STime, ETime) ->
	#player_status{id = RoleId} = PS,
	case db_select_train_init_state(RoleId, Type, SubType) of 
		[InfosStr, UTime] when UTime>=STime andalso UTime<ETime ->
			Infos = util:bitstring_to_term(InfosStr),
			case is_valid_info(Type, Infos) of 
				true -> 
					NeedNewItem = false, IsFirst = false,
					TrainInitState = #train_init_state{key = {Type, SubType}, type = Type, subtype = SubType, infos = Infos, utime = UTime};
				_ -> 
					NeedNewItem = true, IsFirst = false,
					TrainInitState = #train_init_state{key = {Type, SubType}, type = Type, subtype = SubType, infos = Infos, utime = UTime}
			end;
		[_InfosStr, _UTime] ->
			NeedNewItem = true, IsFirst = false,
			TrainInitState = #train_init_state{key = {Type, SubType}, type = Type, subtype = SubType};
		_ ->
			NeedNewItem = true, IsFirst = true, %% 数据库没记录，表示玩家第一次开启这个活动
			TrainInitState = #train_init_state{key = {Type, SubType}, type = Type, subtype = SubType}
	end,
	case NeedNewItem of 
		true ->
			case lib_custom_act_util:keyfind_act_condition(Type, SubType, train_type) of 
				{train_type, TrainType, TypeList} ->
					NewInfos = get_train_init_infos(PS, TrainType, Type, SubType, TypeList, IsFirst),
					NewTrainInitState = #train_init_state{key = {Type, SubType}, type = Type, subtype = SubType, infos = NewInfos, utime = STime},
					db_replace_train_init_state(RoleId, NewTrainInitState),
					?PRINT("init_train ~p~n", [NewTrainInitState]),
					NewTrainInitState;
				_ -> 
					#train_init_state{key = {Type, SubType}, type = Type, subtype = SubType}
			end;
		_ ->
			TrainInitState
	end.

get_train_init_infos(PS, TrainType, ActType, ActSubType, TypeList, IsFirst) ->
	F = fun(TypeId, List) ->
		case ActType of 
			?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
				{InitStage, InitStar} = get_train_stage_with_type(PS, TrainType, TypeId),
				FirstRewardId = get_first_reward_id(InitStage, InitStar, ActType, ActSubType, IsFirst),
				[{TypeId, [InitStage, InitStar, FirstRewardId]}|List];
			?CUSTOM_ACT_TYPE_TRAIN_POWER ->
				InitPower = get_train_power_with_type(PS, TrainType, TypeId),
				[{TypeId, [InitPower]}|List];
			_ ->
				[]
		end
	end,
	lists:foldl(F, [], TypeList).

is_valid_info(Type, Infos) ->
	case length(Infos) > 0 of 
		true ->
			case Type of 
				?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
					F = fun({_TypeId, List}) ->
						case List of 
							[_InitStage, _InitStar, FirstRewardId] when FirstRewardId>0 -> true;
							_ -> false
						end
					end,
					lists:all(F, Infos);
				?CUSTOM_ACT_TYPE_TRAIN_POWER ->
					F = fun({_TypeId, List}) ->
						case List of 
							[InitPower] when InitPower>0 -> true;
							_ -> false
						end
					end,
					lists:all(F, Infos);
				_ ->
					false
			end;
		_ ->
			false
	end.

% get_first_reward_id(_StageInit, _StarInit, Type, SubType, true) -> %% 第一次开启活动，奖励列表统一处理
% 	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
% 	F = fun(RewardId, Acc) ->
% 		RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId),
% 		IsFix = is_fix_reward(RewardCfg),
% 		?IF(IsFix == false, [RewardId|Acc], Acc)
% 	end,
% 	FilterList = lists:foldl(F, [], GradeIds),
% 	FirstRewardId = lists:min(FilterList),
% 	FirstRewardId;
get_first_reward_id(StageInit, StarInit, Type, SubType, _IsFirst) ->
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	case GradeIds == [] of 
		true -> 1;
		_ ->
			ShowNumMax = get_train_act_max_show_num(Type, SubType),
			MaxGradeId = lists:max(GradeIds),
			%% 至少也要有ShowNumMax个奖励id，找出第一个奖励id
			F = fun(RewardId, Acc) ->
				#custom_act_reward_cfg{condition = Condition} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId),
				{_, Stage, Star} = ulists:keyfind(stage, 1, Condition, {stage, 0, 0}),
				CanShow = Stage > StageInit orelse (Stage == StageInit andalso Star > StarInit),
				IsFix = is_fix_reward(RewardCfg),
				?IF(CanShow andalso IsFix == false, [RewardId|Acc], Acc)
			end,
			FilterList = lists:foldl(F, [], GradeIds),
			case length(FilterList) >= ShowNumMax of 
				true -> 
					FirstRewardId = lists:min(FilterList),
					FirstRewardId;
				_ ->
					F2 = fun(RewardId, {Acc2, Item}) ->
						case Acc2 == ShowNumMax of 
							true -> {Acc2+1, RewardId};
							_ -> {Acc2+1, Item}
						end
					end,
					{_, FirstRewardId} = lists:foldl(F2, {1, MaxGradeId}, lists:reverse(GradeIds)),
					FirstRewardId
			end
	end.

is_fix_reward(RewardCfg) ->
	#custom_act_reward_cfg{condition = Condition} = RewardCfg,
	case lists:keyfind(fix_show, 1, Condition) of 
		{fix_show, _} -> true;
		_ -> false
	end.

get_train_act_max_show_num(Type, Subtype) ->
	#custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
	{_, ShowNumMax} = ulists:keyfind(max_show_num, 1, ActCondition, {max_show_num, 7}),
	ShowNumMax.

get_train_show_level_reward(Type, Subtype, ShowNum) ->
	#custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, Subtype),
	{_, LevelReward} = ulists:keyfind(level_reward, 1, ActCondition, {level_reward, []}),
	{_, Rewards} = ulists:keyfind(ShowNum, 1, LevelReward, {ShowNum, []}),
	Rewards.

%% ==================================== 培养升阶活动：阶数/战力变化，通知客户端
mount_train_stage_up(PS, TypeId) ->
    train_stage_up(PS, mount, TypeId).

mount_train_power_up(PS, TypeId) ->
	train_power_up(PS, mount, TypeId).

stone_train_power_up(PS) ->
	train_power_up(PS, stone).

dragon_train_power_up(PS) ->
	train_power_up(PS, dragon).

rune_train_power_up(PS) ->
	train_power_up(PS, rune).

train_power_up(PS, TrainType) ->
	train_power_up(PS, TrainType, 1).
train_power_up(PS, TrainType, TypeId) ->
	case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_TRAIN_POWER) of
        [#act_info{key = {?CUSTOM_ACT_TYPE_TRAIN_POWER, _SubType}}|_] = List -> 
        	F = fun(#act_info{key = {Type, SubType}}) ->
        		case need_report_to_client(Type, SubType, TrainType, TypeId) of 
        			true ->
        				%?PRINT("mount_train_power_up ########## MountType: ~p~n", [TypeId]),
        				lib_custom_act:reward_status(PS, Type, SubType);
        			_ -> ok
        		end
        	end,
        	lists:foreach(F, List),
        	ok;
        _ ->
        	ok
    end.

train_stage_up(PS, TrainType) ->
	train_stage_up(PS, TrainType, 1).
train_stage_up(PS, TrainType, TypeId) ->
	case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_TRAIN_STAGE) of
        [#act_info{key = {?CUSTOM_ACT_TYPE_TRAIN_STAGE, _SubType}}|_] = List -> 
        	F = fun(#act_info{key = {Type, SubType}}) ->
        		case need_report_to_client(Type, SubType, TrainType, TypeId) of 
        			true ->
        				%?PRINT("mount_train_stage_up ######### MountType: ~p~n", [TypeId]),
        				lib_custom_act:reward_status(PS, Type, SubType);
        			_ -> ok
        		end
        	end,
        	lists:foreach(F, List),
        	ok;
        _ ->
        	ok
    end.

%% 判断是否需要推送客户端奖励领取状态
need_report_to_client(Type, SubType, TrainType, TypeId) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, train_type) of 
		{train_type, TrainType, TypeList} ->
			case lists:member(TypeId, TypeList) of 
				true ->
					true;
				_ ->
					false
			end;
		_ -> false
	end.

%% 秘籍清活动状态
gm_delete_train_init_state(PS, Type, SubType) ->
	#player_status{id = RoleId} = PS,
	Sql = usql:update(train_init_state, [{utime, 0}], [{role_id, RoleId}, {type, Type}, {subtype, SubType}]),
	db:execute(Sql),
	erase({?MODULE, Type, SubType}),
	%?PRINT("gm_delete_train_init_state ########## MountType: ~p~n", [{Type, SubType}]),
	PS.

gm_send_reward(_Type, _SubType, _Title, _Content) ->
	%spawn(fun() -> gm_send_reward_do(Type, SubType, Title, Content) end),
	ok.

gm_send_reward_do(Type, SubType, Title, Content) ->
	case db:get_all(io_lib:format("select player_id, reward_id, reward from log_custom_act_reward where type = ~p and subtype = ~p", [Type, SubType])) of 
		[] -> ok;
		DbList ->
			%% 分组
			FG = fun([RoleId, RewardId, RewardStr], Map) ->
				OL = maps:get(RoleId, Map, []),
				maps:put(RoleId, [{RewardId, util:bitstring_to_term(RewardStr)}|OL], Map)
			end,
			RoleMap = lists:foldl(FG, #{}, DbList),
			FSend = fun(RoleId, RewardGetList, Acc) ->
				SortRewardGetList = lists:keysort(1, RewardGetList),
				case length(SortRewardGetList) > 1 of 
					false -> Acc;
					_ ->
						[_First|NewRewardGetList] = SortRewardGetList,
						FI = fun({_RewardId, RewardList}, {AccNum, ListReward}) ->
							case lists:keyfind(36255031, 2, RewardList) of 
								{_, 36255031, _} -> {AccNum + 1, ListReward};
								_ ->
									ExtraReward = get_train_show_level_reward(Type, SubType, AccNum),
									{AccNum+1, ExtraReward++ListReward}
							end
						end,
						{_, NewExtraReward} = lists:foldl(FI, {1, []}, NewRewardGetList),
						%?PRINT("gm_send_reward## :~p~n", [{RoleId, NewExtraReward}]),
						length(NewExtraReward) > 0 andalso lib_mail_api:send_sys_mail([RoleId], Title, Content, lib_goods_api:make_reward_unique(NewExtraReward)),
						Acc rem 30 == 0 andalso timer:sleep(1000),
						Acc + 1
				end
			end,
			maps:fold(FSend, 1, RoleMap)
	end.	

%%================================================== db函数
db_select_train_init_state(RoleId, Type, SubType) ->
	Sql = usql:select(train_init_state, [infos, utime], [{role_id, RoleId}, {type, Type}, {subtype, SubType}]),
	db:get_row(Sql).

db_replace_train_init_state(RoleId, TrainInitState) ->
	#train_init_state{key = {Type, SubType}, infos = Infos, utime = STime} = TrainInitState,
	Sql = usql:replace(train_init_state, [role_id, type, subtype, infos, utime], [[RoleId, Type, SubType, util:term_to_bitstring(Infos), STime]]),
	db:execute(Sql).

db_delete_train_init_state(Type, SubType) ->
	Sql = usql:delete(train_init_state, [{type, Type}, {subtype, SubType}]),
	db:execute(Sql).