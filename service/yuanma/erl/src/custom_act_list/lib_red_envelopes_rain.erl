% %% ---------------------------------------------------------------------------
% %% @doc lib_red_envelopes_rain
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(lib_red_envelopes_rain).

-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("counter_global.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE,data = #callback_recharge_data{gold = AddGold}}) ->
    mod_red_envelopes_rain:server_add_recharge(AddGold),
    {ok, Player};

handle_event(Player, _) ->
	{ok, Player}. 

add_liveness(_RoleId, Add) ->
	mod_red_envelopes_rain:server_add_activity(Add),
	ok.

get_start_time(Type, SubType, NowTime) ->
    case get_red_envelopes_rain_time(Type, SubType) of 
        {StartTimeSec, TotalWave, TimeGap} ->
            FirstWaveStartTime = utime:unixdate(NowTime) + StartTimeSec,
            LastWaveStartTime = FirstWaveStartTime + (TotalWave - 1) * TimeGap,
            {Wave, StartTime} = if
                NowTime < FirstWaveStartTime -> {1, FirstWaveStartTime};
                NowTime >= LastWaveStartTime -> {1, FirstWaveStartTime + ?ONE_DAY_SECONDS};
                true ->
                    DeviationWave = (NowTime - FirstWaveStartTime) div TimeGap + 1, %% 偏移波数
                    RealWave = 1 + DeviationWave,
                    StartTimeWave = FirstWaveStartTime + DeviationWave * TimeGap,
                    {RealWave, StartTimeWave}
            end,
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
		        #act_info{etime = Etime} when StartTime < Etime ->
		            {Wave, StartTime};
		        _ ->
		            {0, 0}
		    end;
        _ ->
            {0, 0}
    end.

get_next_start_time(OldWave, OldStartTime, Type, SubType, NowTime) ->
	case get_red_envelopes_rain_time(Type, SubType) of 
        {_StartTimeSec, TotalWave, TimeGap} ->
            case OldWave < TotalWave of 
            	true ->
            		{OldWave+1, OldStartTime+TimeGap};
            	_ ->
            		get_start_time(Type, SubType, NowTime)
            end;
        _ ->
            {0, 0}
    end.

get_next_day_start_time(Type, SubType, NowTime) ->
	{Wave, NewStartTime} = get_start_time(Type, SubType, NowTime),
	case Wave == 1 of 
		true -> %% 除非用秘籍提前开红包雨，不然一般获取的都不是第一波
			{Wave, NewStartTime};
		_ -> %% 正常流程，获取下一天的第一波
			get_start_time(Type, SubType, utime:unixdate(NowTime) + ?ONE_DAY_SECONDS)
	end.

get_red_envelopes_rain_time(Type, SubType) ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, rain_time) of 
        {rain_time, StartTimeSec, TotalWave, TimeGap} ->
            {StartTimeSec, TotalWave, TimeGap};
        _ ->
            false
    end.

get_notify_time(_SubType) ->
    15.

get_clear_type(Type, SubType) ->
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of 
		#custom_act_cfg{clear_type = ClearType} -> ok;
		_ -> ClearType = ?CUSTOM_ACT_CLEAR_ZERO
	end,
	ClearType.

is_same_day(Type, SubType, StartTime, NowTime) ->
	ClearType = get_clear_type(Type, SubType),
	case ClearType == ?CUSTOM_ACT_CLEAR_FOUR of 
		true ->
			utime_logic:is_logic_same_day(StartTime, NowTime);
		_ ->
			utime:is_same_day(StartTime, NowTime)
	end.


get_wave_red_envelopse_num(SubType, ReceiveWave) ->
	case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, wave_envelopes_num) of 
		{wave_envelopes_num, NumList} ->
			case lists:keyfind(ReceiveWave, 1, NumList) of 
				{_, _, _, Num} -> Num;
				_ -> 0
			end;
		_ ->
			0
	end.

get_red_envelopes_reward(SubType, ReceiveWave, _Wlv, _RerReceiver, OldWaveReceiverList) ->
	Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, wave_envelopes_num) of 
		{wave_envelopes_num, NumList} ->
			case lists:keyfind(ReceiveWave, 1, NumList) of 
				{_, GoldType, GoldNum, TotalNum} -> 
					F = fun(#envelopes_receiver{rewards = RewardsList}, Acc) ->
						Sum = lists:sum([GNum ||{GType, _, GNum} <- RewardsList, GType == ?TYPE_GOLD orelse GType == ?TYPE_BGOLD orelse GType == ?TYPE_COIN]),
						Sum + Acc 
					end,
					HasReceiveMoney = lists:foldl(F, 0, OldWaveReceiverList),
					RemainNum = TotalNum - length(OldWaveReceiverList),
					GoodsType = get_goods_type(GoldType),
					if
				        RemainNum > 1 ->
				            Max = (GoldNum - HasReceiveMoney)/RemainNum * 2,
				            GoldSend = max(1, util:floor(urand:rand(1, 99) / 100 * Max)),
				            [{GoodsType, 0, GoldSend}];
				        RemainNum == 1 ->
				            GoldSend = max(0, GoldNum - HasReceiveMoney),
				            [{GoodsType, 0, GoldSend}];
				        true -> []
				    end;
				_ -> []
			end;
		_ ->
			[]
	end.

get_goods_type(gold) -> ?TYPE_GOLD;
get_goods_type(bgold) -> ?TYPE_BGOLD;
get_goods_type(_) -> ?TYPE_COIN.

% get_red_envelopes_reward(SubType, ReceiveWave, Wlv, RerReceiver, _OldWaveReceiverList) ->
% 	Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
% 	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
% 	F = fun(RewardId, Acc) ->
% 		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
% 			#custom_act_reward_cfg{condition = Condition} = RewardCfg ->
%             	case lists:keyfind(wave, 1, Condition) of 
%             		{_, ReceiveWave} ->
%             			case lists:keyfind(weight, 1, Condition) of 
%             				{_, Weight} -> [{Weight, RewardCfg}|Acc];
%             				_ -> Acc
%             			end;
%             		_ -> Acc
%             	end;
% 			_ -> Acc
% 		end
% 	end,
% 	case lists:foldl(F, [], RewardIdAll) of 
% 		[] -> [];
% 		List ->
% 			{_, RewardCfg} = util:find_ratio(List, 1),
% 			#envelopes_receiver{lv = Lv, career = Career, sex = Sex} = RerReceiver,
% 			RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
% 			RewardList = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
% 			{RewardList, RewardCfg}
% 	end.

get_act_value(Type, SubType) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, rain_value) of 
		{rain_value, activity, _Value} ->
			mod_global_counter:get_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_ACTIVITY);
		{rain_value, recharge, _Value} ->
			mod_global_counter:get_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_RECHARGE);
		_ ->
			0
	end.

clear_act_value(Type, SubType) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, rain_value) of 
		{rain_value, activity, _Value} ->
			mod_global_counter:set_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_ACTIVITY, 0);
		{rain_value, recharge, _Value} ->
			mod_global_counter:set_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_RECHARGE, 0);
		_ ->
			0
	end.

is_recharge_red_rain(SubType) ->
	case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, rain_value) of 
		{rain_value, recharge, _Value} ->
			true;
		_ ->
			false
	end.

is_activity_red_rain(SubType) ->
	case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, rain_value) of 
		{rain_value, activity, _Value} ->
			true;
		_ ->
			false
	end.

get_act_value(SubType) ->
	case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, rain_value) of 
		{rain_value, _, Value} -> Value;
		_ ->
			0
	end.

check_can_send_rain(Type, SubType, RedEnvelopseRain) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, rain_value) of 
		{rain_value, _ValueType, Value} ->
			#red_envelopes_rain{act_value = ActValue} = RedEnvelopseRain,
			case ActValue >= Value of 
				true -> true;
				_ -> ?PRINT("check_can_send_rain false ~p~n", [{Type, SubType}]), false
			end;
		_ ->
			true
	end.
	

make_envelopes_receiver(PS) ->
	#player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = Figure} = PS,
	#figure{lv = Lv, name = RoleName, career = Career, sex = Sex, picture = Pic, picture_ver = PicVer} = Figure,
	#envelopes_receiver{
	    role_id = RoleId,
	    role_name = RoleName,
	    server_id = ServerId,
	    server_num = ServerNum,
	    lv = Lv,
	    career = Career,
	    sex = Sex,
	    picture = Pic,
	    picture_ver = PicVer
	}.

