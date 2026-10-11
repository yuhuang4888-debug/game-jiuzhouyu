%%%---------------------------------------
%%% module      : data_ranking
%%% description : 排行榜配置
%%%
%%%---------------------------------------
-module(data_ranking).
-compile(export_all).
-include("common_rank.hrl").



get_rank_config(100) ->
	#rank_config{type = 100,rank_name = <<"圣域结社排行榜"/utf8>>,rank_max = 20,rank_limit = 0,title_id = 0,sortid = 14,show = 0};

get_rank_config(200) ->
	#rank_config{type = 200,rank_name = <<"战力榜"/utf8>>,rank_max = 100,rank_limit = 300000,title_id = 0,sortid = 1,show = 1};

get_rank_config(300) ->
	#rank_config{type = 300,rank_name = <<"等级榜"/utf8>>,rank_max = 50,rank_limit = 150,title_id = 0,sortid = 2,show = 1};

get_rank_config(400) ->
	#rank_config{type = 400,rank_name = <<"成就榜"/utf8>>,rank_max = 50,rank_limit = 2,title_id = 0,sortid = 3,show = 1};

get_rank_config(500) ->
	#rank_config{type = 500,rank_name = <<"竞技榜"/utf8>>,rank_max = 50,rank_limit = 3000,title_id = 0,sortid = 10,show = 1};

get_rank_config(601) ->
	#rank_config{type = 601,rank_name = <<"坐骑榜"/utf8>>,rank_max = 50,rank_limit = 10000,title_id = 0,sortid = 5,show = 1};

get_rank_config(602) ->
	#rank_config{type = 602,rank_name = <<"飞骑榜"/utf8>>,rank_max = 50,rank_limit = 10000,title_id = 0,sortid = 9,show = 0};

get_rank_config(603) ->
	#rank_config{type = 603,rank_name = <<"羽翼榜"/utf8>>,rank_max = 50,rank_limit = 2000,title_id = 0,sortid = 7,show = 1};

get_rank_config(604) ->
	#rank_config{type = 604,rank_name = <<"侍魂榜"/utf8>>,rank_max = 50,rank_limit = 10000,title_id = 0,sortid = 6,show = 1};

get_rank_config(605) ->
	#rank_config{type = 605,rank_name = <<"侍魂榜"/utf8>>,rank_max = 50,rank_limit = 2000,title_id = 0,sortid = 8,show = 0};

get_rank_config(606) ->
	#rank_config{type = 606,rank_name = <<"御守榜"/utf8>>,rank_max = 50,rank_limit = 2000,title_id = 0,sortid = 12,show = 1};

get_rank_config(607) ->
	#rank_config{type = 607,rank_name = <<"神兵榜"/utf8>>,rank_max = 50,rank_limit = 2000,title_id = 0,sortid = 11,show = 1};

get_rank_config(608) ->
	#rank_config{type = 608,rank_name = <<"装备榜"/utf8>>,rank_max = 50,rank_limit = 10000,title_id = 0,sortid = 4,show = 1};

get_rank_config(609) ->
	#rank_config{type = 609,rank_name = <<"爬塔榜"/utf8>>,rank_max = 50,rank_limit = 1,title_id = 0,sortid = 13,show = 0};

get_rank_config(700) ->
	#rank_config{type = 700,rank_name = <<"挂机收益榜"/utf8>>,rank_max = 50,rank_limit = 1000000,title_id = 0,sortid = 15,show = 1};

get_rank_config(_Type) ->
	#rank_config{}.

get_reward(1) ->
	#base_charm_week_reward{id = 1,rank_min = 1,rank_max = 1,reward = [{7,0,800}],fame_reward = [{7,0,150}]};

get_reward(2) ->
	#base_charm_week_reward{id = 2,rank_min = 2,rank_max = 3,reward = [{7,0,600}],fame_reward = []};

get_reward(3) ->
	#base_charm_week_reward{id = 3,rank_min = 4,rank_max = 10,reward = [{7,0,400}],fame_reward = []};

get_reward(4) ->
	#base_charm_week_reward{id = 4,rank_min = 11,rank_max = 20,reward = [{7,0,200}],fame_reward = []};

get_reward(_Id) ->
	[].

get_reward_ids() ->
[1,2,3,4].

get_home_reward(1) ->
	#base_home_rank_reward{id = 1,rank_min = 1,rank_max = 1,reward = [{7,0,800}]};

get_home_reward(2) ->
	#base_home_rank_reward{id = 2,rank_min = 2,rank_max = 3,reward = [{7,0,600}]};

get_home_reward(3) ->
	#base_home_rank_reward{id = 3,rank_min = 4,rank_max = 10,reward = [{7,0,400}]};

get_home_reward(4) ->
	#base_home_rank_reward{id = 4,rank_min = 11,rank_max = 20,reward = [{7,0,200}]};

get_home_reward(_Id) ->
	[].

get_home_reward_ids() ->
[1,2,3,4].

get_worship_cfg(200) ->
	#worship_award_cfg{times = 3,award = [{0,1022,5}]};

get_worship_cfg(_Id) ->
	#worship_award_cfg{}.

get_combat_power_gift(OpenDay) when OpenDay >= 2, OpenDay =< 2 ->
	#base_rank_reward_combat{day_down=2,day_up=2,base_value1=1600000,cal_percent1=0,base_value2=650000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 3, OpenDay =< 3 ->
	#base_rank_reward_combat{day_down=3,day_up=3,base_value1=2200000,cal_percent1=0,base_value2=890000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 4, OpenDay =< 4 ->
	#base_rank_reward_combat{day_down=4,day_up=4,base_value1=2700000,cal_percent1=0,base_value2=1600000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 5, OpenDay =< 5 ->
	#base_rank_reward_combat{day_down=5,day_up=5,base_value1=3300000,cal_percent1=0,base_value2=2000000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 6, OpenDay =< 6 ->
	#base_rank_reward_combat{day_down=6,day_up=6,base_value1=4000000,cal_percent1=0,base_value2=2400000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 7, OpenDay =< 7 ->
	#base_rank_reward_combat{day_down=7,day_up=7,base_value1=4700000,cal_percent1=0,base_value2=2800000,cal_percent2=0,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(OpenDay) when OpenDay >= 8, OpenDay =< 9999 ->
	#base_rank_reward_combat{day_down=8,day_up=9999,base_value1=0,cal_percent1=500,base_value2=0,cal_percent2=300,reward_pool1=[{2, [ {800, [{0, 32070021, 1}]},{200, [{0, 32070022, 1}]}]}],reward_pool2=[{3, [{500, [{0, 32070021, 1}]},{500, [{0, 32070022, 1}]}]}],reward_pool3=[{4, [{200, [{0, 32070021, 1}]},{800, [{0, 32070022, 1}]}]}]};
get_combat_power_gift(_OpenDay) ->
	[].

get_lv_power_gift(OpenDay,Lv) when OpenDay >= 2, OpenDay =< 999, Lv >= 1, Lv =< 15 ->
	#base_rank_reward_lv{day_down=2,day_up=999,lv_down=1,lv_up=15,reward_pool=[{1, [{1000, [{0, 32070019, 1}]}]}]};
get_lv_power_gift(OpenDay,Lv) when OpenDay >= 2, OpenDay =< 999, Lv >= 16, Lv =< 30 ->
	#base_rank_reward_lv{day_down=2,day_up=999,lv_down=16,lv_up=30,reward_pool=[{2, [{600, [{0, 32070019, 1}]},{400, [{0, 32070020, 1}]}]}]};
get_lv_power_gift(OpenDay,Lv) when OpenDay >= 2, OpenDay =< 999, Lv >= 31, Lv =< 60 ->
	#base_rank_reward_lv{day_down=2,day_up=999,lv_down=31,lv_up=60,reward_pool=[{3, [{200, [{0, 32070019, 1}]},{800, [{0, 32070020, 1}]}]}]};
get_lv_power_gift(OpenDay,Lv) when OpenDay >= 2, OpenDay =< 999, Lv >= 61, Lv =< 9999 ->
	#base_rank_reward_lv{day_down=2,day_up=999,lv_down=61,lv_up=9999,reward_pool=[{4, [{200, [{0, 32070019, 1}]},{800, [{0, 32070020, 1}]}]}]};
get_lv_power_gift(_OpenDay,_Lv) ->
	[].

