%%%-----------------------------------
%%% @Module      : lib_up_power
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 04. 六月 2020 17:12
%%% @Description :
%%%-----------------------------------
%%
%%
%% API
-compile(export_all).

-module(lib_up_power).
-author("carlos").

%% API
-export([]).



-include("server.hrl").
-include("up_power_rank.hrl").
-include("figure.hrl").
-include("title.hrl").
-include("rec_recharge.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-compile(export_all).



%% 等级排行榜
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
	%?PRINT("~p~n", [util:get_open_day()]),
	refresh_rush_rank_pre(Player, ?up_power_person),
	{ok, Player};


handle_event(Player, _Ec) ->
	?ERR("unkown event_callback:~p", [_Ec]),
	{ok, Player}.



%%图鉴战力刷榜
%%return   无返回
refresh_mon_pic(Ps) ->
	refresh_rush_rank_pre(Ps, ?up_power_mon_pic).



%% 刷新榜单,最好在里面统一处理,修改方便
refresh_rush_rank_pre(Player, SubType) ->
	case lists:member(SubType, ?up_power_rank_list) of
		true ->
			case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
				true ->
					refresh_rush_rank(SubType, Player),
					send_client_stage_list(Player, ?up_power_partner_stage),
					send_client_stage_list(Player, ?up_power_mon_pic_stage);
				false ->
					skip
			end;
		false -> skip
	end.

%% record基础数据
make_record([SubType, Player]) ->
	#player_status{id = RoleId,
		figure = #figure{lv = _Lv},
		status_pet = _StatusPet,
		combat_power =_Combat
%%		status_mount = MountList
	} = Player,
	Value = case SubType of
		        ?up_power_person ->
			        _Combat;
				?up_power_partner ->
					lib_companion_util:get_companion_status_power(Player);
		        ?up_power_mon_pic -> %%  图鉴战力获取
			        lib_mon_pic:get_power(Player);
		        _ ->
			        0
	        end,
	%?PRINT("~p, ~p~n", [RankType, Value]),
	#up_power_rush_rank_role{
		role_key = {SubType, RoleId},
		rank_type = SubType,
		sub_type = SubType,
		role_id = RoleId,
		value = Value,
		time = utime:unixtime()
	}.

%% 榜单
refresh_rush_rank(SubType, Player) ->
	RushRank = make_record([SubType, Player]),  %%根据类型形成榜单
	mod_up_power_rank:refresh_rush_rank(SubType, RushRank),
	ok.

%% 过滤可以上榜的条件
check(_RankType, _Player) ->
	true.

%% 根据榜单类型解析对应排序值 （获取自己的）
get_sel_value(Player, RankType) ->
	#player_status{combat_power = Combat} = Player,
	case RankType of
		?up_power_person ->
			Combat;
		?up_power_partner_stage ->
			lib_companion_util:get_companion_status_power(Player);
		?up_power_partner ->
			lib_companion_util:get_companion_status_power(Player);
		?up_power_mon_pic ->  %%    图鉴战力
			lib_mon_pic:get_power(Player);
		?up_power_mon_pic_stage ->  %%    图鉴战力
			lib_mon_pic:get_power(Player);
		_ ->
			0
	end.


is_exist(_I, []) ->
	false;
is_exist(I, [H | T]) ->
	case I == H of
		true ->
			true;
		false ->
			is_exist(I, T)
	end.

%% 获取配置榜单最大长度
get_max_len(RankType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_UP_POWER_RANK, RankType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(rank_len, 1, Condition) of
				{_, Len} ->
					Len;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 获取配置上榜阈值
get_rank_limit(RankType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_UP_POWER_RANK, RankType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(value_limit, 1, Condition) of
				{_, Value, _} ->
					Value;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 获取配置上榜阈值阶段列表[{最小排名， 最大排名， 所需战力}]
get_rank_stage_list(RankType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_UP_POWER_RANK, RankType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(value_limit, 1, Condition) of
				{_, _Value, List} ->
					List;
				_ ->
					[]
			end;
		_ ->
			[]
	end.


get_stage_list(RankType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_UP_POWER_RANK, RankType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(stage_reward, 1, Condition) of
				{_, StageList} ->
					StageList;
				_ ->
					[]
			end;
		_ ->
			[]
	end.



login(PS) ->
	%%
	[refresh_rush_rank_pre(PS, SubType) || SubType <- ?up_power_rank_list],
	#player_status{id = RoleId} = PS,
	Sql = io_lib:format(<<"select  sub_type,  stage_status from  up_power_rush_rank_role_in_ps where   player_id = ~p">>, [RoleId]),
	List = db:get_all(Sql),
	F =  fun([SubType, StageStatus], AccMap) ->
			maps:put(SubType, util:bitstring_to_term(StageStatus), AccMap)
		end,
	UpPowerMap = lists:foldl(F, #{}, List),
	PS#player_status{up_power_rank = UpPowerMap}.

refresh_rush_rank_all(PS) ->
	[refresh_rush_rank_pre(PS, SubType) || SubType <- ?up_power_rank_list].

send_err_code(RoleId, Err) ->
%%	?PRINT("err ~p ~n", [Err]),
	{ok, Bin} = pt_226:write(22600, [Err]),
	lib_server_send:send_to_uid(RoleId, Bin).





send_client_stage_list(Player, SubType) ->
	case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
		true ->
			#player_status{id = RoleId, up_power_rank = RankMap} = Player,
			StatusList = maps:get(SubType, RankMap, []),
			SelValue = get_sel_value(Player, SubType),
			StatusListCfg = get_stage_list(SubType),
%%			?IF(Player#player_status.id == 4294967558, ?MYLOG("cym", "SubType ~p, SelValue ~p StatusListCfg ~p~n", [SubType, SelValue, StatusListCfg]),
%%				skip),
			F = fun({StageId, NeedPower, _Reward}, AccList) ->
				case lists:keyfind(StageId, 1, StatusList) of
					{_, ?FINISH} ->
						[{StageId, SelValue, NeedPower, ?FINISH} | AccList];
					_ ->
						if
							SelValue >= NeedPower ->
								[{StageId, SelValue, NeedPower, ?HAVE_REWARD} | AccList];
							true ->
								[{StageId, SelValue, NeedPower, ?NOT_REWARD} | AccList]
						end
				end
			    end,
			PackList = lists:reverse(lists:foldl(F, [], StatusListCfg)),
			{ok, Bin} = pt_226:write(22602, [SubType, PackList]),
			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
			skip
	end.
	



get_stage_reward(Player, SubType, StageId) ->
	#player_status{id = RoleId, up_power_rank = RankMap} = Player,
	StatusList = maps:get(SubType, RankMap, []),
	SelValue = get_sel_value(Player, SubType),
	StatusListCfg = get_stage_list(SubType),
	case lists:keyfind(StageId, 1, StatusList) of
		{_, ?FINISH} ->
			send_err_code(RoleId, ?ERRCODE(err331_already_get_reward)),
			Player;
		_ ->
			case lists:keyfind(StageId, 1, StatusListCfg) of
				{_, NeedPower, Reward} ->
					if
						SelValue >= NeedPower ->
							lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = up_power_rank_stage_reward}),
							StatusListNew = lists:keystore(StageId, 1, StatusList, {StageId, ?FINISH}),
							db_save_stage_status(RoleId, SubType, StatusListNew), %% 保存数据库
							RankMapNew = maps:put(SubType, StatusListNew, RankMap),
							{ok, Bin} = pt_226:write(22603, [?SUCCESS, SubType, StageId, Reward]),
							lib_server_send:send_to_uid(RoleId, Bin),
							Player#player_status{up_power_rank = RankMapNew};
						true ->
							send_err_code(RoleId, ?ERRCODE(err331_act_can_not_get)),
							Player
					end;
				_ ->
					send_err_code(RoleId, ?MISSING_CONFIG),
					Player
			end
	end.



db_save_stage_status(RoleId, SubType, StatusList) ->
	Sql = io_lib:format(?sql_up_power_role_in_ps_save, [SubType, RoleId, util:term_to_string(StatusList)]),
	db:execute(Sql).



%% 战力榜奖励
get_up_power_rank_reward(SubType, RankRole) ->
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType),
	get_up_power_rank_reward(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType, RankRole, 0, GradeList, []).

get_up_power_rank_reward(_, _, _, _, [], TmpL) -> TmpL;
get_up_power_rank_reward(ActType, SubType, RankRole, Sex, [H | T], TmpL) ->
	#up_power_rush_rank_role{rank = Rank} = RankRole,
	case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, H) of
		#custom_act_reward_cfg{condition = Condition, reward = Reward } = RewardCfg when is_list(Condition) andalso is_list(Reward) ->
			case lists:keyfind(rank, 1, Condition) of
				{_, {Min, Max}} ->
					case Max >= Rank andalso Rank >= Min of
						true ->
%%							RewardParam = lib_custom_act:make_rwparam(0, Sex, 0, 0),
							RewardList = lib_custom_act_util:count_act_reward([], RewardCfg),
							case length(RewardList) > 0 of
								true -> {RewardList, H};
								_ ->
									?ERR("get_flower_rank_reward ActType:~p, SubType:~p, Rank:~p, Sex:~p, GradeId:~p ~n", [ActType, SubType, Rank, Sex, H]),
									[]
							end;
						_ ->
							get_up_power_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
					end;
				_ ->
					get_up_power_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
			end;
		_ ->
			get_up_power_rank_reward(ActType, SubType, RankRole, Sex, T, TmpL)
	end.


send_reward_status(Player, ActInfo) ->
%%	?PRINT(" ++++++++++++++ ~n", []),
	#act_info{key = {Type, SubType}} = ActInfo,
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	%% 对于额外奖励，奖励状态要额外计算
	F = fun(GradeId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
			#custom_act_reward_cfg{
				name = Name,
				desc = Desc,
				condition = Condition,
				format = Format,
				reward = Reward
			} ->
				ConditionStr = util:term_to_string(Condition),
				RewardStr = util:term_to_string(Reward),
				[{GradeId, Format, 0, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
			_ -> Acc
		end
	    end,
	PackList = lists:foldl(F, [], GradeIds),
%%	?PRINT(" ++++++++++++++ ~p ~n", [{Type, SubType, PackList}]),
	{ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
	lib_server_send:send_to_sid(Player#player_status.sid, BinData).







clear_act(PS, SubType) ->
	#player_status{up_power_rank = Map} = PS,
	NewMap = maps:remove(SubType, Map),
%%	?PRINT("SubType ~p~n", [SubType]),
	PS#player_status{up_power_rank = NewMap}.

get_right_rank([{MinRank, _MaxRank, NeedPower} | _T], PreRank, Power) when Power >= NeedPower->
	max(PreRank + 1, MinRank);
get_right_rank([{_MinRank, MaxRank, _NeedPower} | T], _PreRank, Power) ->
	get_right_rank(T, MaxRank, Power);
get_right_rank([], PreRank, _Power) ->
	PreRank + 1.