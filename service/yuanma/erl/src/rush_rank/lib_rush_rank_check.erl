%%%-----------------------------------
%%% @Module      : lib_rush_rank_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 十月 2018 14:07
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_rush_rank_check).
-author("chenyiming").

-include("server.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("rush_rank.hrl").
%% API
-compile(export_all).

%% -----------------------------------------------------------------
%% @desc     功能描述  领取排行榜奖励
%% @param    参数      RankType::integer() 排行榜类型
%%                     SubType::integer()  活动子类型
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_rank_reward(#player_status{figure = F}, RankType, SubType, _RewardId) ->
	#figure{lv = Lv} = F,
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_RUSH_RANK, SubType) of
		#custom_act_cfg{opday_lim = OpenDayLimit} ->
			CheckList = [
				{check_lv, Lv, SubType},   %%等级是否满足
				{check_rank_type, RankType}, %%榜单类型
				{check_rank_type_end, RankType}, %%是否已经结算
				{check_open_day, OpenDayLimit}  %% 开放天数
				],
			check_list(CheckList);
		false ->
			{false, ?MISSING_CONFIG}
	end.





check_list([]) ->
	true;
check_list([H | CheckList]) ->
	case check(H) of
		true ->
			check_list(CheckList);
		{false, Res} ->
			{false, Res}
	end.

check({check_lv, Lv, SubType}) ->
	case Lv  >= lib_rush_rank:get_open_lv(?CUSTOM_ACT_TYPE_RUSH_RANK, SubType) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err331_act_can_not_get)}
	end;

check({check_open_day, OpenDayLimit}) ->
	case  OpenDayLimit of
		[] ->
			true;
		[{DayMin, DayMax}] ->
			OpenDay = util:get_open_day(),
			case  OpenDay >= DayMin andalso   OpenDay =< DayMax of
				true ->
					true;
				false  ->
					{false, ?ERRCODE(err331_act_closed)}
			end
	end;
check({check_rank_type, RankType}) ->
	case lists:member(RankType, ?RANK_TYPE_LIST) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err255_err_rank_type)}
	end;
check(_H) ->
	true.