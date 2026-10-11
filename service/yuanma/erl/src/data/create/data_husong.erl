%%%---------------------------------------
%%% module      : data_husong
%%% description : 护送配置
%%%
%%%---------------------------------------
-module(data_husong).
-compile(export_all).
-include("husong.hrl").



get_husong_angel_con(1) ->
	#husong_angel_con{angel_id = 1,name = "夕颜公主",rand_list = [],other_reward_list = [],coin = 150000,exp = 250,cost = []};

get_husong_angel_con(2) ->
	#husong_angel_con{angel_id = 2,name = "郁金公主",rand_list = [],other_reward_list = [],coin = 200000,exp = 375,cost = [{0,39510012,1}]};

get_husong_angel_con(3) ->
	#husong_angel_con{angel_id = 3,name = "玫瑰公主",rand_list = [],other_reward_list = [],coin = 250000,exp = 500,cost = [{0,39510012,2}]};

get_husong_angel_con(4) ->
	#husong_angel_con{angel_id = 4,name = "妖姬公主",rand_list = [],other_reward_list = [],coin = 300000,exp = 750,cost = [{0,39510012,3}]};

get_husong_angel_con(_Angelid) ->
	[].

get_angel_id_list() ->
[1,2,3,4].

get_husong_position_con(1) ->
	#husong_position_con{id = 1,x = 456,y = 2500};

get_husong_position_con(2) ->
	#husong_position_con{id = 2,x = 4569,y = 819};

get_husong_position_con(_Id) ->
	[].

get_position_id_list() ->
[1,2].

