%%%-----------------------------------
%%% @Module      : lib_custom_act_lv_gift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 二月 2021 14:15
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_custom_act_lv_gift).
-author("carlos").

-include("custom_act.hrl").
-include("server.hrl").
-include("figure.hrl").

%% API
-export([]).


init_data_lv_up(Ps) ->
	case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_LV_GIFT, 1) of  %% 只有一个活动， 写死了
		true ->
			#player_status{status_custom_act = CustomAct, figure = Figure} = Ps,
			#figure{lv = RoleLv} = Figure,
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_LV_GIFT, 1) of
				#custom_act_cfg{condition = Condition} ->
					MinRoleLv = case lists:keyfind(min_lv, 1, Condition) of
						            {min_lv, Value1} ->
							            Value1;
						            _ ->
							            9999
					            end,
					MaxRoleLv = case lists:keyfind(max_lv, 1, Condition) of
						            {max_lv, Value2} ->
							            Value2;
						            _ ->
							            9999
					            end,
					#status_custom_act{data_map = DataMap} = CustomAct,
					DefaultData =
						#custom_act_data{id = {?CUSTOM_ACT_TYPE_LV_GIFT, 1},
							type = ?CUSTOM_ACT_TYPE_LV_GIFT,
							subtype = 1,
							data = []
						},
					%% 更新等级所对应的时间戳
					if
						RoleLv == MinRoleLv ->  %% 最低等级
							ActData = maps:get({?CUSTOM_ACT_TYPE_LV_GIFT, 1}, DataMap, DefaultData),
							#custom_act_data{data = DataList} = ActData,
							NewDataList = lists:keystore(min_lv, 1, DataList, {min_lv, utime:unixtime()}),
							NewPs = lib_custom_act:save_act_data_to_player(Ps, ActData#custom_act_data{data = NewDataList}),
							%% 推送协议
							pp_custom_act_list:handle(NewPs, 33248, []),
							NewPs;
						RoleLv == MaxRoleLv -> %% 最大等级
							ActData = maps:get({?CUSTOM_ACT_TYPE_LV_GIFT, 1}, DataMap, DefaultData),
							#custom_act_data{data = DataList} = ActData,
							NewDataList = lists:keystore(max_lv, 1, DataList, {max_lv, utime:unixtime()}),
							NewPs = lib_custom_act:save_act_data_to_player(Ps, ActData#custom_act_data{data = NewDataList}),
							%% 推送协议
							lib_custom_act:reward_status(NewPs, ?CUSTOM_ACT_TYPE_LV_GIFT, 1),
							NewPs;
						true ->
							Ps
					end;
				_ ->
					Ps
			end;
		_ ->
			Ps
	end.