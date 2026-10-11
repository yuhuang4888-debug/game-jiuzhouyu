%%%------------------------------------
%%% @Module  : lib_common_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(lib_rush_rank).

-include("server.hrl").
-include("rush_rank.hrl").
-include("figure.hrl").
-include("title.hrl").
-include("rec_recharge.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("common.hrl").
-include("kv.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").
-include("push_gift.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-compile(export_all).

%% record基础数据
make_record([{RankType, SubType}, Player]) ->
    #player_status{id = RoleId,
        accid = AccId,
        accname = AccName
    } = Player,
    Value = get_sel_value(Player, RankType),
    %?PRINT("~p, ~p~n", [RankType, Value]),
    #rush_rank_role{
        role_key = {RankType, SubType, RoleId},
        accid = AccId,
        accname = AccName,
        rank_type = RankType,
        sub_type = SubType,
        role_id = RoleId,
        value = Value,
        time = utime:unixtime(),
        get_reward_status = ?NOT_REWARD
    }.

%% 请求榜单信息
send_rank_list(PS, {RankType, SubType}) ->
    #player_status{sid = Sid} = PS,
    case lists:member(RankType, ?RANK_TYPE_LIST) of
        true ->
            case have_start(RankType) of
                true ->
                    SelValue = lib_rush_rank:get_sel_value(PS, RankType),  %%对应的排序值
                    mod_rush_rank:send_rank_list(RankType, SubType, PS#player_status.id, SelValue, ?IS_SHOW_COMBAT);
                {false, Err} ->
                    {ok, Bin} = pt_225:write(22500, [Err]),
                    lib_server_send:send_to_sid(Sid, Bin)
            end;
        false -> skip
    end.

%% 榜单
refresh_rush_rank({RankType, SubType}, Player) ->
    RushRank = make_record([{RankType, SubType}, Player]),  %%根据类型形成榜单
    ?PRINT("refresh rush rank ~p~n", [{RankType, SubType, RushRank}]),
    mod_rush_rank:refresh_rush_rank(RankType, SubType, RushRank),
    ok.

%% 过滤可以上榜的条件
check(_RankType, _Player) ->
    true.

%% 根据榜单类型解析对应排序值 （获取自己的）
get_sel_value(Player, RankType) ->
    #player_status{figure = #figure{lv = Lv}, status_mount = StatusMountList, status_pet = _StatusPet, combat_power = Combat, id = RoleId} = Player,
    case RankType of
        ?RANK_TYPE_SOUL_RUSH ->
            lib_soul:get_all_power(Player);
        ?RANK_TYPE_LV_RUSH ->
            Lv;
        ?RANK_TYPE_STONE_RUSH ->
            lib_goods_api:count_stone_total_lv(Player);
        ?RANK_TYPE_EQUIPMENT_STRENGTHEN_RUSH ->
            lib_goods_api:count_stren_total_lv(Player);
        ?RANK_TYPE_AIRCRAFT_RUSH ->
            lib_mount:get_all_lv_by_type_id(Player, ?PET_ID);
        ?RANK_TYPE_MOUNT_RUSH ->
            get_mount_rank_value_by_type(StatusMountList, ?MOUNT_ID, RankType);
        ?RANK_TYPE_PET_RUSH ->
            get_mount_rank_value_by_type(StatusMountList, ?PET_ID, RankType);
        ?RANK_TYPE_SPIRIT_RUSH ->
            get_mount_rank_value_by_type(StatusMountList, ?MATE_ID, RankType);
        ?RANK_TYPE_WING_RUSH -> %%翅膀
            get_mount_rank_value_by_type(StatusMountList, ?FLY_ID, RankType);
        ?RANK_TYPE_SUIT_RUSH ->
            lib_equip:get_suit_all_lv(Player);
        ?RANK_TYPE_DRAGON ->
            lib_dragon_equip:get_dragon_lv(Player);
        ?RANK_TYPE_RECHARGE_RUSH ->
            lib_recharge_data:get_today_pay_gold(RoleId);
        ?RANK_TYPE_COMBAT_RUSH ->
            Combat;
        ?RANK_TYPE_RUNE ->
            lib_rune:get_power(Player);
%%            lib_rune:add_rune_chip(),
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
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{max_len = MaxLen} ->
            MaxLen;
        _ ->
            20
    end.

%% 获取配置上榜阈值
get_rank_limit(RankType) ->
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{limit = OldLimit, new_limit = NewLimit, open_day_list = OldOpenDayList} ->

            OpenTime = util:get_open_time(),
            ChangeOpenTime = data_key_value:get(?KEY_RUSH_CHANGE_OPEN_TIME),
            OpenDay = util:get_open_day(ChangeOpenTime),

            case lib_rush_rank_mod:check_is_change(OpenDay, OpenTime, ChangeOpenTime, OldOpenDayList) of
                true ->
                    Limit = NewLimit;
                _ ->
                    Limit = OldLimit
            end,
            case Limit of
                [{_, TmpValue}] ->
                    IsSpecialRush = lists:member(RankType, ?RUSH_RANK_SPECIAL_STAR),
                    if
                        IsSpecialRush ->
                            case TmpValue of
                                {Stage, Star} -> Stage * ?STAGE_ADD + Star;
                                _ -> 0
                            end;
                        is_integer(TmpValue) -> TmpValue;
                        true -> 0
                    end;
                ERR ->
                    ?ERR("rush rank limit config error: ~p~n", [ERR]),
                    0
            end;
        _ ->
            0
    end.

%% 根据开服天数获取要结算榜单id
get_id_by_clear_day() ->
    OpenDay = util:get_open_day(),
    OpenTime = util:get_open_time(),
    IdList = data_rush_rank:get_id_list(),
    do_get_id_by_clear_day(OpenDay, OpenTime, IdList).

do_get_id_by_clear_day(_OpenDay, _OpenTime, []) ->
    0;
do_get_id_by_clear_day(OpenDay, OpenTime, [H | T]) ->
    case data_rush_rank:get_rush_rank_cfg(H) of
        #base_rush_rank{clear_day = CfgDay, open_start_time = OpenStartTime, open_end_time = OpenEndTime} ->
            case OpenDay =:= CfgDay andalso OpenStartTime =< OpenTime andalso OpenTime =< OpenEndTime of
                true ->
                    H;
                _ ->
                    do_get_id_by_clear_day(OpenDay, OpenTime, T)
            end;
        _ ->
            do_get_id_by_clear_day(OpenDay, OpenTime, T)
    end.
%%%%今日充值，必须要今天当天充值的才能进榜，和其他榜单有点区别
%%get_refresh_limit(?RANK_TYPE_RECHARGE_RUSH) ->
%%	case data_rush_rank:get_rush_rank_cfg(?RANK_TYPE_RECHARGE_RUSH) of
%%		#base_rush_rank{clear_day = ClDay, start_day = StartDay} ->
%%			OpenDay = util:get_open_day(),
%%			if
%%				OpenDay >= StartDay andalso OpenDay < ClDay  ->
%%					true;
%%				true ->
%%					false
%%			end;
%%		_ ->
%%			?ERR("rush rank config err:~p~n", [?RANK_TYPE_RECHARGE_RUSH]),
%%			false
%%	end;

%% 充值榜只统计当天的
get_refresh_limit(?RANK_TYPE_RECHARGE_RUSH) ->
	case data_rush_rank:get_rush_rank_cfg(?RANK_TYPE_RECHARGE_RUSH) of
		#base_rush_rank{clear_day = ClDay, start_day = SDay} ->
			OpenDay = util:get_open_day(),
			OpenDay >= SDay andalso OpenDay < ClDay;
		_ ->
			?ERR("rush rank config err:~p~n", [?RANK_TYPE_RECHARGE_RUSH]), false
	end;
get_refresh_limit(RankType) ->
    OpenTime = util:get_open_time(),
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{clear_day = ClDay, open_end_time = OpenEndTime, open_start_time = OpenStartTime} ->
            util:get_open_day() < ClDay andalso OpenStartTime =< OpenTime andalso OpenTime =< OpenEndTime;
        _ ->
            ?ERR("rush rank config err:~p~n", [RankType]), false
    end.

%% 获取配置奖励
get_rank_reward(RankType, Rank, Career) ->
	IdList = data_rush_rank:get_rank_reward_ids(RankType),
	do_get_rank_reward(RankType, Rank, IdList, Career, []).

do_get_rank_reward(_RankType, _Rank, [], _Career, TmpL) ->
	TmpL;
do_get_rank_reward(RankType, Rank, [H | T], Career, TmpL) ->
	case data_rush_rank:get_rank_reward_cfg(RankType, H) of
		#base_rush_rank_reward{rank_min = Min, rank_max = Max, reward = TmpReward} ->
			ok;
		_ ->
			Max = Min = 0, TmpReward = []
	end,
	case Max >= Rank andalso Rank >= Min of
		true ->
			Reward = case TmpReward of
				[{_, _} | _] ->
					case lists:keyfind(Career, 1, TmpReward) of
						{_, RewardL} when is_list(RewardL) ->
							RewardL;
						_ ->
							[]
					end;
				_ ->
					[]
			end,
			do_get_rank_reward(RankType, Rank, T, Career, Reward ++ TmpL);
		_ ->
			do_get_rank_reward(RankType, Rank, T, Career, TmpL)
	end.

%% 获取配置的目标奖励
get_cfg_goal_reward(RankType, GoalId) ->
	case data_rush_rank:get_goal_reward_cfg(RankType, GoalId) of
		#base_rush_goal_reward{reward = Reward} ->
			ok;
		_ ->
			Reward = []
	end,
	Reward.

get_new_reward_state(RankType, SelValue, GoalId) ->
	case data_rush_rank:get_goal_reward_cfg(RankType, GoalId) of
		#base_rush_goal_reward{goal_value = GoalCfg} ->
%%			?PRINT("RankType ~p ~n SelValue ~p ~n, GoalCfg ~p ~n", [RankType, SelValue, GoalCfg]),
            case GoalCfg of
                [{_, TmpValue}] ->
                    CfgValue = if
                                   %% RankType == ?RANK_TYPE_PET_RUSH orelse RankType == ?RANK_TYPE_MOUNT_RUSH
                                   %%     orelse RankType == ?RANK_TYPE_SPIRIT_RUSH orelse RankType == ?RANK_TYPE_WING_RUSH ->
                                   %%     case TmpValue of
                                   %%         {Stage, Star} ->
                                   %%             Stage * ?STAGE_ADD + Star;
                                   %%         _ ->
                                   %%             0
                                   %%  %%    end;
                                   is_integer(TmpValue) -> TmpValue;
                                   true -> 0
                               end,
                    if
                        SelValue >= CfgValue andalso CfgValue =/= 0 ->
                            ?HAVE_REWARD;
                        true ->
                            ?NOT_REWARD
                    end;
                _ ->
                    ?NOT_REWARD
            end;
        _ ->
            ?NOT_REWARD
    end.

get_open_lv(ActType, SubType) ->
	case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
		#custom_act_cfg{condition = Condition} when is_list(Condition) ->
			case lists:keyfind(role_lv, 1, Condition) of
				{_, Lv} when is_integer(Lv) ->
					Lv;
				_ ->
					99999
			end;
		_ ->
			99999
	end.

%% 根据培养类型来获得排序值
%% 20220505根据运营要求，满足阀值时读取的是对应的战力，否则读取的是起星级阶数
%% 20220519运营要求吗，不再进行区分，只读取战力
get_mount_rank_value_by_type(MountList, Type, _RankType) ->
    case lists:keyfind(Type, #status_mount.type_id, MountList) of
        #status_mount{stage = _Stage, star = _Star, combat = Combat} ->
            %% State = Stage * ?STAGE_ADD + Star,
            %% Limit = lib_rush_rank:get_rank_limit(RankType),    %%阀值
            %% ?IF(State >= Limit, Combat, State);
            %% ?INFO("Combat:~p", [Combat]),
            Combat;
        _ -> 0
    end.

repair_stone_rush() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_rush_rank, repair_stone_rush2, []) || E <- OnlineRoles].


repair_stone_rush2(PS) ->
%%	lib_rush_rank_api:reflash_rank_by_stone_rush(PS),
	PS.


refresh_data() ->
	OpenDay = util:get_open_day(),
%%	?PRINT("OpenDay ~p~n", [OpenDay]),
	if
		OpenDay > 8 ->
%%			?PRINT("OpenDay ~p~n", [OpenDay]),
			skip;
		true ->
			Sql = io_lib:format(<<"select   id  from   player_low  where   lv > 240">>, []),
			List = db:get_all(Sql),
%%			?PRINT("List ~p~n", [List]),
			[lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_rush_rank, refresh_data2, []) || [RoleId] <-List]
	end.


refresh_data2(PS) ->
	?MYLOG("rush", "id ~p~n", [PS#player_status.id]),
	lib_rush_rank_api:reflash_rank_by_aircraft_rush(PS),
	lib_rush_rank_api:reflash_rank_by_suit_rush(PS),
	PS.

%% 发送冲榜途径
send_rush_approach(Player, RushId) ->
	Sid = Player#player_status.sid,
	ResList = case data_rush_rank_approach:get_all_jump(RushId) of
		[] -> [];
		ApproachList ->
			F = fun(JumpId, Res) ->
				get_rush_approach_info(Player, JumpId) ++ Res
			end,
			lists:foldl(F, [], ApproachList)
	end,
	{ok, Bin} = pt_225:write(22505, [RushId, ResList]),
	lib_server_send:send_to_sid(Sid, Bin).


get_rush_approach_info(Player, JumpId) ->
	case data_rush_rank:get_jump_info(JumpId) of
		#base_rush_rank_jump{label = Label} = JumpInfo when Label =:= 2->
			get_rush_approach_info_help(Player, JumpInfo);
		#base_rush_rank_jump{jump_id = JumpId, label = Label} ->
			[{JumpId, Label, 0}];
		_ -> []
 	end.

%% 定制活动
get_rush_approach_info_help(Player, #base_rush_rank_jump{jump_id = JumpId, module_id = ModuleId, type_id = Type, sub_id = SubId, label = Label})
  when ModuleId =:= ?MOD_AC_CUSTOM ->
	NowTime = utime:unixtime(),
    Mspec =
		case SubId =:= 0 of   % 全部活动
			true ->
				ets:fun2ms(fun(#act_info{etime = Etime, key = {CType, _SubType}} = T) when CType =:= Type andalso NowTime < Etime ->
				T
				end);
			_ ->
				ets:fun2ms(fun(#act_info{etime = Etime, key = {CType, CSubType}} = T) when CType =:= Type andalso CSubType =:= SubId andalso NowTime < Etime ->
				T
				end)
		end,
    AllList = ets:select(?ETS_CUSTOM_ACT, Mspec),
	F = fun(#act_info{etime = ETime} = ActInfo , EndTime) ->
		case Type of
			?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
				?PRINT("here:~p~n",[lib_special_gift:custom_act_reward_is_all_deactive(ActInfo, Player)]),
				?IF(lib_special_gift:custom_act_reward_is_all_deactive(ActInfo, Player), 0, max(ETime, EndTime));
			?CUSTOM_ACT_TYPE_SHOP_REWARD ->
				?IF(lib_custom_act:custom_act_reward_is_all_deactive(ActInfo, Player), 0, max(ETime, EndTime));
			_ ->
				max(ETime, EndTime)
		end
	end,

	EndTime1 = lists:foldl(F, 0, AllList),
	FinalEndTime = case Type of
		36 ->  % 0元豪礼特殊处理
			NowOpenDay = util:get_open_day(),
			ExpireTime = ?IF(NowOpenDay > 3, 0, (4 - NowOpenDay) * ?ONE_DAY_SECONDS + utime:unixdate()),
			min(ExpireTime, EndTime1);
		_ ->
	 		EndTime1
	end,
	case FinalEndTime > utime:unixtime() of
		true -> [{JumpId, Label, FinalEndTime}];
		_ -> []
	end;

%% 推送礼包
get_rush_approach_info_help(Player, #base_rush_rank_jump{jump_id = JumpId, module_id = ModuleId, type_id = TypeId, sub_id = SubId, label = Label})
  when ModuleId =:= 191 ->
	#player_status{push_gift_status = #push_gift_status{active_list = ActiveList}} = Player,
	F = fun(#p_g_info{key = {PType, PSubType}, end_time = ETime, expire_time = ExpireTime, grade_list = GradeList}, EndTime) ->
		GradeAll = data_push_gift:get_grade_list(PType, PSubType),
		IsAllBuyList = [push_gift_is_all_buy({PType, PSubType}, GradeList, GradeId) || GradeId <- GradeAll],
		% 所有奖励都已领取的情况下不计算时间
		case lists:member(false, IsAllBuyList) of
			false -> EndTime;
			_ -> max(max(ETime, ExpireTime), EndTime)
		end
	end,
	MatchList = case TypeId =:= 0 of
		true ->  % 所有的推送礼包都有效
			ActiveList;
		_ ->
			case SubId =:= 0 of
				true ->   % 所有子类型都有效
					lib_push_gift_api:get_push_gift_by_type(Player, TypeId);
				_ ->
					lib_push_gift_api:get_push_gift(Player, TypeId, SubId)
			end
	end,
	EndTime = lists:foldl(F, 0, MatchList),
	case EndTime > utime:unixtime() of
		true -> [{JumpId, Label, EndTime}];
		_ -> []
	end;

get_rush_approach_info_help(_Player, _JumpInfo) -> [].


push_gift_is_all_buy({Type, SubType}, GradeList, GradeId) ->
	BuyCnt = case data_push_gift:get_push_gift_reward(Type, SubType, GradeId) of
		#base_push_gift_reward{condition = Cond} ->
			{_, BuyLimit} = ulists:keyfind(buy_cnt, 1, Cond, 1),
			BuyLimit;
		_ -> 1
	end,
	#p_g_reward{buy_cnt = NowBuyCnt} = ulists:keyfind(GradeId, #p_g_reward.grade_id, GradeList, #p_g_reward{grade_id=GradeId}),
	% ?MYLOG("ml_test_push_gift", "NowBuy: ~p~n", [{NowBuyCnt, BuyCnt}]),
	NowBuyCnt =:= BuyCnt.

have_start(RankType)  ->
    OpenTime = util:get_open_time(),
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{start_day =  StartDay, open_start_time = OpenStartTime, open_end_time = OpenEndTime} ->
            case  util:get_open_day() >= StartDay  andalso OpenStartTime =< OpenTime andalso OpenTime =< OpenEndTime of
                true ->
                    true;
                false ->
                    {false, ?ERRCODE(err225_the_rank_not_start)}
            end;
        _ ->
            {false,  ?MISSING_CONFIG}
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 判断显示的是战力还是阶数
%% @return  返回值 0 - 表示显示战力 1 - 表示正常不修正
%% -----------------------------------------------------------------
is_show_combat(Player, RankType) ->
    #player_status{status_mount = MountList} = Player,
    case RankType of
        ?RANK_TYPE_MOUNT_RUSH ->  %%坐骑
            do_is_show_combat(MountList, ?MOUNT_ID, RankType);  %% 骑宠换算 阶*1000+星
        ?RANK_TYPE_PET_RUSH ->    %%宠物
            do_is_show_combat(MountList, ?PET_ID, RankType);
        ?RANK_TYPE_SPIRIT_RUSH -> %%精灵
            do_is_show_combat(MountList, ?MATE_ID, RankType);
        ?RANK_TYPE_WING_RUSH -> %%翅膀
            do_is_show_combat(MountList, ?FLY_ID, RankType);
        _ ->
            ?IS_SHOW_COMBAT
    end.

do_is_show_combat(MountList, Type, RankType) ->
    case lists:keyfind(Type, #status_mount.type_id, MountList) of
        #status_mount{stage = Stage, star = Star} ->
            State = Stage * ?STAGE_ADD + Star,
            Limit = lib_rush_rank:get_rank_limit(RankType),    %%阀值
            ?IF(State >= Limit, ?IS_SHOW_COMBAT, ?IS_SHOW_COMBAT);
        _ ->
            ?IS_SHOW_COMBAT
    end.