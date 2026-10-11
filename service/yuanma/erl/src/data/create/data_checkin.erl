%%%---------------------------------------
%%% module      : data_checkin
%%% description : 签到配置
%%%
%%%---------------------------------------
-module(data_checkin).
-compile(export_all).
-include("checkin.hrl").



get_checkin_type(_PlayerLv,1) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=1,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,2) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=2,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,3) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=3,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,4) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=4,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,5) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=5,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,6) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=6,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,7) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=7,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,8) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=8,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,9) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=9,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,10) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=10,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,11) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=11,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,12) when _PlayerLv >= 1, _PlayerLv =< 9999 ->
	#base_checkin_type{lv_limmit=1,lv_upper=9999,month=12,daily_type=1,total_type=1};
get_checkin_type(_PlayerLv,_Month) ->
	[].

get_daily_rewards(1,1) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 1,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,2) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 2,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,3) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 3,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,4) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 4,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,5) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 5,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,6) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 6,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,7) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 7,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,8) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 8,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,9) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 9,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,10) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 10,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,11) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 11,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,12) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 12,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,13) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 13,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,14) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 14,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,15) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 15,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,16) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 16,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,17) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 17,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,18) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 18,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,19) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 19,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,20) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 20,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,21) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 21,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,22) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 22,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,23) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 23,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,24) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 24,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,25) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 25,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,26) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 26,rewards = [{3,0,200000}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,27) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 27,rewards = [{2,0,50}],vip_lv = [{vip_lv, 2},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,28) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 28,rewards = [{0,22030010,15}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(1,29) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 29,rewards = [{2,0,50}],vip_lv = [{vip_lv, 4},{vip_type, 1}],vip_multiple = 2};

get_daily_rewards(1,30) ->
	#base_checkin_daily_rewards{daily_type = 1,day = 30,rewards = [{0,32010188,4}],vip_lv = [{vip_lv, 0},{vip_type, 0}],vip_multiple = 0};

get_daily_rewards(_Dailytype,_Day) ->
	[].


get_daily_list(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];

get_daily_list(_Dailytype) ->
	[].

get_total_rewards(1,2) ->
	#base_checkin_total_rewards{total_type = 1,days = 2,rewards = [{0,19020002 ,1}]};

get_total_rewards(1,5) ->
	#base_checkin_total_rewards{total_type = 1,days = 5,rewards = [{0,22030010,15}]};

get_total_rewards(1,7) ->
	#base_checkin_total_rewards{total_type = 1,days = 7,rewards = [{0,19020002,2}]};

get_total_rewards(1,14) ->
	#base_checkin_total_rewards{total_type = 1,days = 14,rewards = [{0,22030010,15}]};

get_total_rewards(1,28) ->
	#base_checkin_total_rewards{total_type = 1,days = 28,rewards = [{0,22030010,30}]};

get_total_rewards(_Totaltype,_Days) ->
	[].


get_total_list(1) ->
[2,5,7,14,28];

get_total_list(_Totaltype) ->
	[].

get_retro_cost(1) ->
	#base_checkin_daily_retroactive{retro_times = 1,money_type = 2,price = 5};

get_retro_cost(2) ->
	#base_checkin_daily_retroactive{retro_times = 2,money_type = 2,price = 10};

get_retro_cost(3) ->
	#base_checkin_daily_retroactive{retro_times = 3,money_type = 2,price = 15};

get_retro_cost(4) ->
	#base_checkin_daily_retroactive{retro_times = 4,money_type = 2,price = 20};

get_retro_cost(5) ->
	#base_checkin_daily_retroactive{retro_times = 5,money_type = 2,price = 30};

get_retro_cost(6) ->
	#base_checkin_daily_retroactive{retro_times = 6,money_type = 2,price = 30};

get_retro_cost(7) ->
	#base_checkin_daily_retroactive{retro_times = 7,money_type = 2,price = 30};

get_retro_cost(8) ->
	#base_checkin_daily_retroactive{retro_times = 8,money_type = 2,price = 30};

get_retro_cost(9) ->
	#base_checkin_daily_retroactive{retro_times = 9,money_type = 2,price = 30};

get_retro_cost(10) ->
	#base_checkin_daily_retroactive{retro_times = 10,money_type = 2,price = 30};

get_retro_cost(11) ->
	#base_checkin_daily_retroactive{retro_times = 11,money_type = 2,price = 30};

get_retro_cost(12) ->
	#base_checkin_daily_retroactive{retro_times = 12,money_type = 2,price = 30};

get_retro_cost(13) ->
	#base_checkin_daily_retroactive{retro_times = 13,money_type = 2,price = 30};

get_retro_cost(14) ->
	#base_checkin_daily_retroactive{retro_times = 14,money_type = 2,price = 30};

get_retro_cost(15) ->
	#base_checkin_daily_retroactive{retro_times = 15,money_type = 2,price = 30};

get_retro_cost(16) ->
	#base_checkin_daily_retroactive{retro_times = 16,money_type = 2,price = 30};

get_retro_cost(17) ->
	#base_checkin_daily_retroactive{retro_times = 17,money_type = 2,price = 30};

get_retro_cost(18) ->
	#base_checkin_daily_retroactive{retro_times = 18,money_type = 2,price = 30};

get_retro_cost(19) ->
	#base_checkin_daily_retroactive{retro_times = 19,money_type = 2,price = 30};

get_retro_cost(20) ->
	#base_checkin_daily_retroactive{retro_times = 20,money_type = 2,price = 30};

get_retro_cost(21) ->
	#base_checkin_daily_retroactive{retro_times = 21,money_type = 2,price = 30};

get_retro_cost(22) ->
	#base_checkin_daily_retroactive{retro_times = 22,money_type = 2,price = 30};

get_retro_cost(23) ->
	#base_checkin_daily_retroactive{retro_times = 23,money_type = 2,price = 30};

get_retro_cost(24) ->
	#base_checkin_daily_retroactive{retro_times = 24,money_type = 2,price = 30};

get_retro_cost(25) ->
	#base_checkin_daily_retroactive{retro_times = 25,money_type = 2,price = 30};

get_retro_cost(26) ->
	#base_checkin_daily_retroactive{retro_times = 26,money_type = 2,price = 30};

get_retro_cost(27) ->
	#base_checkin_daily_retroactive{retro_times = 27,money_type = 2,price = 30};

get_retro_cost(28) ->
	#base_checkin_daily_retroactive{retro_times = 28,money_type = 2,price = 30};

get_retro_cost(29) ->
	#base_checkin_daily_retroactive{retro_times = 29,money_type = 2,price = 30};

get_retro_cost(30) ->
	#base_checkin_daily_retroactive{retro_times = 30,money_type = 2,price = 30};

get_retro_cost(31) ->
	#base_checkin_daily_retroactive{retro_times = 31,money_type = 2,price = 30};

get_retro_cost(_Retrotimes) ->
	[].


get_checkin_value(checkin_open_lv) ->
[40];


get_checkin_value(chekin_retro_times) ->
[0];


get_checkin_value(liveness_add_retro_times) ->
[1];


get_checkin_value(liveness_retro_times) ->
[100];


get_checkin_value(max_retro_time) ->
[5];

get_checkin_value(_Key) ->
	[].

