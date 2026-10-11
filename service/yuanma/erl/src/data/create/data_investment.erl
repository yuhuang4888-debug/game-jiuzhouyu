%%%---------------------------------------
%%% module      : data_investment
%%% description : 投资活动配置
%%%
%%%---------------------------------------
-module(data_investment).
-compile(export_all).
-include("investment.hrl").



get_type(1,1) ->
	#base_investment_type{type = 1,level = 1,price = 688,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 1,first_tv_id = 0};

get_type(1,3) ->
	#base_investment_type{type = 1,level = 3,price = 1888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 1,first_tv_id = 0};

get_type(2,1) ->
	#base_investment_type{type = 2,level = 1,price = 0,price_type = 1,condition = [{buy_reward,[{2,0,250},{0,5902018,1},{1,0,250}]},{show_reward,[{0,5902018,1}]}],is_up = 0,any_tv_id = 0,first_tv_id = 2};

get_type(4,1) ->
	#base_investment_type{type = 4,level = 1,price = 888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 0,first_tv_id = 3};

get_type(4,2) ->
	#base_investment_type{type = 4,level = 2,price = 1880,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 0,first_tv_id = 3};

get_type(4,3) ->
	#base_investment_type{type = 4,level = 3,price = 2880,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 0,first_tv_id = 3};

get_type(5,1) ->
	#base_investment_type{type = 5,level = 1,price = 688,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 4,first_tv_id = 0};

get_type(5,2) ->
	#base_investment_type{type = 5,level = 2,price = 1888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 4,first_tv_id = 0};

get_type(6,1) ->
	#base_investment_type{type = 6,level = 1,price = 1288,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 6,first_tv_id = 0};

get_type(6,2) ->
	#base_investment_type{type = 6,level = 2,price = 2888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 6,first_tv_id = 0};

get_type(7,1) ->
	#base_investment_type{type = 7,level = 1,price = 1288,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 7,first_tv_id = 0};

get_type(7,2) ->
	#base_investment_type{type = 7,level = 2,price = 2888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 7,first_tv_id = 0};

get_type(8,1) ->
	#base_investment_type{type = 8,level = 1,price = 1888,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 8,first_tv_id = 0};

get_type(8,2) ->
	#base_investment_type{type = 8,level = 2,price = 3688,price_type = 1,condition = [{vip, 4}],is_up = 0,any_tv_id = 8,first_tv_id = 0};

get_type(_Type,_Level) ->
	[].

get_reward(1,1,1) ->
	#base_investment_reward{type = 1,level = 1,id = 1,rewards = [{2,0,688}],condition = []};

get_reward(1,1,2) ->
	#base_investment_reward{type = 1,level = 1,id = 2,rewards = [{2,0,137}],condition = [{lv,150}]};

get_reward(1,1,3) ->
	#base_investment_reward{type = 1,level = 1,id = 3,rewards = [{2,0,206}],condition = [{lv,180}]};

get_reward(1,1,4) ->
	#base_investment_reward{type = 1,level = 1,id = 4,rewards = [{2,0,274}],condition = [{lv,210}]};

get_reward(1,1,5) ->
	#base_investment_reward{type = 1,level = 1,id = 5,rewards = [{2,0,343}],condition = [{lv,230}]};

get_reward(1,1,6) ->
	#base_investment_reward{type = 1,level = 1,id = 6,rewards = [{2,0,411}],condition = [{lv,250}]};

get_reward(1,1,7) ->
	#base_investment_reward{type = 1,level = 1,id = 7,rewards = [{2,0,480}],condition = [{lv,270}]};

get_reward(1,1,8) ->
	#base_investment_reward{type = 1,level = 1,id = 8,rewards = [{2,0,548}],condition = [{lv,290}]};

get_reward(1,1,9) ->
	#base_investment_reward{type = 1,level = 1,id = 9,rewards = [{2,0,617}],condition = [{lv,310}]};

get_reward(1,1,10) ->
	#base_investment_reward{type = 1,level = 1,id = 10,rewards = [{2,0,685}],condition = [{lv,330}]};

get_reward(1,1,11) ->
	#base_investment_reward{type = 1,level = 1,id = 11,rewards = [{2,0,754}],condition = [{lv,350}]};

get_reward(1,1,12) ->
	#base_investment_reward{type = 1,level = 1,id = 12,rewards = [{2,0,822}],condition = [{lv,370}]};

get_reward(1,1,13) ->
	#base_investment_reward{type = 1,level = 1,id = 13,rewards = [{2,0,915}],condition = [{lv,390}]};

get_reward(1,3,1) ->
	#base_investment_reward{type = 1,level = 3,id = 1,rewards = [{2,0,1888}],condition = []};

get_reward(1,3,2) ->
	#base_investment_reward{type = 1,level = 3,id = 2,rewards = [{2,0,376}],condition = [{lv,150}]};

get_reward(1,3,3) ->
	#base_investment_reward{type = 1,level = 3,id = 3,rewards = [{2,0,564}],condition = [{lv,180}]};

get_reward(1,3,4) ->
	#base_investment_reward{type = 1,level = 3,id = 4,rewards = [{2,0,752}],condition = [{lv,210}]};

get_reward(1,3,5) ->
	#base_investment_reward{type = 1,level = 3,id = 5,rewards = [{2,0,940}],condition = [{lv,230}]};

get_reward(1,3,6) ->
	#base_investment_reward{type = 1,level = 3,id = 6,rewards = [{2,0,1128}],condition = [{lv,250}]};

get_reward(1,3,7) ->
	#base_investment_reward{type = 1,level = 3,id = 7,rewards = [{2,0,1316}],condition = [{lv,270}]};

get_reward(1,3,8) ->
	#base_investment_reward{type = 1,level = 3,id = 8,rewards = [{2,0,1504}],condition = [{lv,290}]};

get_reward(1,3,9) ->
	#base_investment_reward{type = 1,level = 3,id = 9,rewards = [{2,0,1692}],condition = [{lv,310}]};

get_reward(1,3,10) ->
	#base_investment_reward{type = 1,level = 3,id = 10,rewards = [{2,0,1880}],condition = [{lv,330}]};

get_reward(1,3,11) ->
	#base_investment_reward{type = 1,level = 3,id = 11,rewards = [{2,0,2068}],condition = [{lv,350}]};

get_reward(1,3,12) ->
	#base_investment_reward{type = 1,level = 3,id = 12,rewards = [{2,0,2256}],condition = [{lv,370}]};

get_reward(1,3,13) ->
	#base_investment_reward{type = 1,level = 3,id = 13,rewards = [{2,0,2516}],condition = [{lv,390}]};

get_reward(2,1,1) ->
	#base_investment_reward{type = 2,level = 1,id = 1,rewards = [{2,0,50},{2,0,50}],condition = []};

get_reward(2,1,2) ->
	#base_investment_reward{type = 2,level = 1,id = 2,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,1}]};

get_reward(2,1,3) ->
	#base_investment_reward{type = 2,level = 1,id = 3,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,2}]};

get_reward(2,1,4) ->
	#base_investment_reward{type = 2,level = 1,id = 4,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,3}]};

get_reward(2,1,5) ->
	#base_investment_reward{type = 2,level = 1,id = 5,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,4}]};

get_reward(2,1,6) ->
	#base_investment_reward{type = 2,level = 1,id = 6,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,5}]};

get_reward(2,1,7) ->
	#base_investment_reward{type = 2,level = 1,id = 7,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,6}]};

get_reward(2,1,8) ->
	#base_investment_reward{type = 2,level = 1,id = 8,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,7}]};

get_reward(2,1,9) ->
	#base_investment_reward{type = 2,level = 1,id = 9,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,8}]};

get_reward(2,1,10) ->
	#base_investment_reward{type = 2,level = 1,id = 10,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,9}]};

get_reward(2,1,11) ->
	#base_investment_reward{type = 2,level = 1,id = 11,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,10}]};

get_reward(2,1,12) ->
	#base_investment_reward{type = 2,level = 1,id = 12,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,11}]};

get_reward(2,1,13) ->
	#base_investment_reward{type = 2,level = 1,id = 13,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,12}]};

get_reward(2,1,14) ->
	#base_investment_reward{type = 2,level = 1,id = 14,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,13}]};

get_reward(2,1,15) ->
	#base_investment_reward{type = 2,level = 1,id = 15,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,14}]};

get_reward(2,1,16) ->
	#base_investment_reward{type = 2,level = 1,id = 16,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,15}]};

get_reward(2,1,17) ->
	#base_investment_reward{type = 2,level = 1,id = 17,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,16}]};

get_reward(2,1,18) ->
	#base_investment_reward{type = 2,level = 1,id = 18,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,17}]};

get_reward(2,1,19) ->
	#base_investment_reward{type = 2,level = 1,id = 19,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,18}]};

get_reward(2,1,20) ->
	#base_investment_reward{type = 2,level = 1,id = 20,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,19}]};

get_reward(2,1,21) ->
	#base_investment_reward{type = 2,level = 1,id = 21,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,20}]};

get_reward(2,1,22) ->
	#base_investment_reward{type = 2,level = 1,id = 22,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,21}]};

get_reward(2,1,23) ->
	#base_investment_reward{type = 2,level = 1,id = 23,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,22}]};

get_reward(2,1,24) ->
	#base_investment_reward{type = 2,level = 1,id = 24,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,23}]};

get_reward(2,1,25) ->
	#base_investment_reward{type = 2,level = 1,id = 25,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,24}]};

get_reward(2,1,26) ->
	#base_investment_reward{type = 2,level = 1,id = 26,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,25}]};

get_reward(2,1,27) ->
	#base_investment_reward{type = 2,level = 1,id = 27,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,26}]};

get_reward(2,1,28) ->
	#base_investment_reward{type = 2,level = 1,id = 28,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,27}]};

get_reward(2,1,29) ->
	#base_investment_reward{type = 2,level = 1,id = 29,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,28}]};

get_reward(2,1,30) ->
	#base_investment_reward{type = 2,level = 1,id = 30,rewards = [{2,0,50},{2,0,50}],condition = [{daily},{finish_reward_id,29}]};

get_reward(4,1,1) ->
	#base_investment_reward{type = 4,level = 1,id = 1,rewards = [{2,0,880}],condition = []};

get_reward(4,1,2) ->
	#base_investment_reward{type = 4,level = 1,id = 2,rewards = [{2,0,264}],condition = [{lv,380}]};

get_reward(4,1,3) ->
	#base_investment_reward{type = 4,level = 1,id = 3,rewards = [{2,0,396}],condition = [{lv,400}]};

get_reward(4,1,4) ->
	#base_investment_reward{type = 4,level = 1,id = 4,rewards = [{2,0,572}],condition = [{lv,420}]};

get_reward(4,1,5) ->
	#base_investment_reward{type = 4,level = 1,id = 5,rewards = [{2,0,704}],condition = [{lv,430}]};

get_reward(4,1,6) ->
	#base_investment_reward{type = 4,level = 1,id = 6,rewards = [{2,0,836}],condition = [{lv,440}]};

get_reward(4,1,7) ->
	#base_investment_reward{type = 4,level = 1,id = 7,rewards = [{2,0,968}],condition = [{lv,450}]};

get_reward(4,1,8) ->
	#base_investment_reward{type = 4,level = 1,id = 8,rewards = [{2,0,1100}],condition = [{lv,460}]};

get_reward(4,1,9) ->
	#base_investment_reward{type = 4,level = 1,id = 9,rewards = [{2,0,1232}],condition = [{lv,470}]};

get_reward(4,1,10) ->
	#base_investment_reward{type = 4,level = 1,id = 10,rewards = [{2,0,1364}],condition = [{lv,480}]};

get_reward(4,1,11) ->
	#base_investment_reward{type = 4,level = 1,id = 11,rewards = [{2,0,1496}],condition = [{lv,490}]};

get_reward(4,1,12) ->
	#base_investment_reward{type = 4,level = 1,id = 12,rewards = [{2,0,1628}],condition = [{lv,500}]};

get_reward(4,1,13) ->
	#base_investment_reward{type = 4,level = 1,id = 13,rewards = [{2,0,1760}],condition = [{lv,510}]};

get_reward(4,2,1) ->
	#base_investment_reward{type = 4,level = 2,id = 1,rewards = [{2,0,1880}],condition = []};

get_reward(4,2,2) ->
	#base_investment_reward{type = 4,level = 2,id = 2,rewards = [{2,0,564}],condition = [{lv,380}]};

get_reward(4,2,3) ->
	#base_investment_reward{type = 4,level = 2,id = 3,rewards = [{2,0,846}],condition = [{lv,400}]};

get_reward(4,2,4) ->
	#base_investment_reward{type = 4,level = 2,id = 4,rewards = [{2,0,1222}],condition = [{lv,420}]};

get_reward(4,2,5) ->
	#base_investment_reward{type = 4,level = 2,id = 5,rewards = [{2,0,1504}],condition = [{lv,430}]};

get_reward(4,2,6) ->
	#base_investment_reward{type = 4,level = 2,id = 6,rewards = [{2,0,1786}],condition = [{lv,440}]};

get_reward(4,2,7) ->
	#base_investment_reward{type = 4,level = 2,id = 7,rewards = [{2,0,2068}],condition = [{lv,450}]};

get_reward(4,2,8) ->
	#base_investment_reward{type = 4,level = 2,id = 8,rewards = [{2,0,2350}],condition = [{lv,460}]};

get_reward(4,2,9) ->
	#base_investment_reward{type = 4,level = 2,id = 9,rewards = [{2,0,2632}],condition = [{lv,470}]};

get_reward(4,2,10) ->
	#base_investment_reward{type = 4,level = 2,id = 10,rewards = [{2,0,2914}],condition = [{lv,480}]};

get_reward(4,2,11) ->
	#base_investment_reward{type = 4,level = 2,id = 11,rewards = [{2,0,3196}],condition = [{lv,490}]};

get_reward(4,2,12) ->
	#base_investment_reward{type = 4,level = 2,id = 12,rewards = [{2,0,3478}],condition = [{lv,500}]};

get_reward(4,2,13) ->
	#base_investment_reward{type = 4,level = 2,id = 13,rewards = [{2,0,3760}],condition = [{lv,510}]};

get_reward(4,3,1) ->
	#base_investment_reward{type = 4,level = 3,id = 1,rewards = [{2,0,2880}],condition = []};

get_reward(4,3,2) ->
	#base_investment_reward{type = 4,level = 3,id = 2,rewards = [{2,0,864}],condition = [{lv,380}]};

get_reward(4,3,3) ->
	#base_investment_reward{type = 4,level = 3,id = 3,rewards = [{2,0,1296}],condition = [{lv,400}]};

get_reward(4,3,4) ->
	#base_investment_reward{type = 4,level = 3,id = 4,rewards = [{2,0,1872}],condition = [{lv,420}]};

get_reward(4,3,5) ->
	#base_investment_reward{type = 4,level = 3,id = 5,rewards = [{2,0,2304}],condition = [{lv,430}]};

get_reward(4,3,6) ->
	#base_investment_reward{type = 4,level = 3,id = 6,rewards = [{2,0,2736}],condition = [{lv,440}]};

get_reward(4,3,7) ->
	#base_investment_reward{type = 4,level = 3,id = 7,rewards = [{2,0,3168}],condition = [{lv,450}]};

get_reward(4,3,8) ->
	#base_investment_reward{type = 4,level = 3,id = 8,rewards = [{2,0,3600}],condition = [{lv,460}]};

get_reward(4,3,9) ->
	#base_investment_reward{type = 4,level = 3,id = 9,rewards = [{2,0,4032}],condition = [{lv,470}]};

get_reward(4,3,10) ->
	#base_investment_reward{type = 4,level = 3,id = 10,rewards = [{2,0,4464}],condition = [{lv,480}]};

get_reward(4,3,11) ->
	#base_investment_reward{type = 4,level = 3,id = 11,rewards = [{2,0,4896}],condition = [{lv,490}]};

get_reward(4,3,12) ->
	#base_investment_reward{type = 4,level = 3,id = 12,rewards = [{2,0,5328}],condition = [{lv,500}]};

get_reward(4,3,13) ->
	#base_investment_reward{type = 4,level = 3,id = 13,rewards = [{2,0,5760}],condition = [{lv,510}]};

get_reward(5,1,1) ->
	#base_investment_reward{type = 5,level = 1,id = 1,rewards = [{2,0,688}],condition = []};

get_reward(5,1,2) ->
	#base_investment_reward{type = 5,level = 1,id = 2,rewards = [{2,0,341}],condition = [{lv,375}]};

get_reward(5,1,3) ->
	#base_investment_reward{type = 5,level = 1,id = 3,rewards = [{2,0,372}],condition = [{lv,380}]};

get_reward(5,1,4) ->
	#base_investment_reward{type = 5,level = 1,id = 4,rewards = [{2,0,403}],condition = [{lv,385}]};

get_reward(5,1,5) ->
	#base_investment_reward{type = 5,level = 1,id = 5,rewards = [{2,0,403}],condition = [{lv,404}]};

get_reward(5,1,6) ->
	#base_investment_reward{type = 5,level = 1,id = 6,rewards = [{2,0,434}],condition = [{lv,410}]};

get_reward(5,1,7) ->
	#base_investment_reward{type = 5,level = 1,id = 7,rewards = [{2,0,434}],condition = [{lv,423}]};

get_reward(5,1,8) ->
	#base_investment_reward{type = 5,level = 1,id = 8,rewards = [{2,0,465}],condition = [{lv,435}]};

get_reward(5,1,9) ->
	#base_investment_reward{type = 5,level = 1,id = 9,rewards = [{2,0,496}],condition = [{lv,447}]};

get_reward(5,1,10) ->
	#base_investment_reward{type = 5,level = 1,id = 10,rewards = [{2,0,527}],condition = [{lv,465}]};

get_reward(5,1,11) ->
	#base_investment_reward{type = 5,level = 1,id = 11,rewards = [{2,0,558}],condition = [{lv,474}]};

get_reward(5,1,12) ->
	#base_investment_reward{type = 5,level = 1,id = 12,rewards = [{2,0,574}],condition = [{lv,482}]};

get_reward(5,1,13) ->
	#base_investment_reward{type = 5,level = 1,id = 13,rewards = [{2,0,589}],condition = [{lv,490}]};

get_reward(5,1,14) ->
	#base_investment_reward{type = 5,level = 1,id = 14,rewards = [{2,0,604}],condition = [{lv,498}]};

get_reward(5,2,1) ->
	#base_investment_reward{type = 5,level = 2,id = 1,rewards = [{2,0,1888}],condition = []};

get_reward(5,2,2) ->
	#base_investment_reward{type = 5,level = 2,id = 2,rewards = [{2,0,935}],condition = [{lv,375}]};

get_reward(5,2,3) ->
	#base_investment_reward{type = 5,level = 2,id = 3,rewards = [{2,0,1020}],condition = [{lv,380}]};

get_reward(5,2,4) ->
	#base_investment_reward{type = 5,level = 2,id = 4,rewards = [{2,0,1105}],condition = [{lv,385}]};

get_reward(5,2,5) ->
	#base_investment_reward{type = 5,level = 2,id = 5,rewards = [{2,0,1105}],condition = [{lv,404}]};

get_reward(5,2,6) ->
	#base_investment_reward{type = 5,level = 2,id = 6,rewards = [{2,0,1190}],condition = [{lv,410}]};

get_reward(5,2,7) ->
	#base_investment_reward{type = 5,level = 2,id = 7,rewards = [{2,0,1190}],condition = [{lv,423}]};

get_reward(5,2,8) ->
	#base_investment_reward{type = 5,level = 2,id = 8,rewards = [{2,0,1275}],condition = [{lv,435}]};

get_reward(5,2,9) ->
	#base_investment_reward{type = 5,level = 2,id = 9,rewards = [{2,0,1360}],condition = [{lv,447}]};

get_reward(5,2,10) ->
	#base_investment_reward{type = 5,level = 2,id = 10,rewards = [{2,0,1445}],condition = [{lv,465}]};

get_reward(5,2,11) ->
	#base_investment_reward{type = 5,level = 2,id = 11,rewards = [{2,0,1530}],condition = [{lv,474}]};

get_reward(5,2,12) ->
	#base_investment_reward{type = 5,level = 2,id = 12,rewards = [{2,0,1573}],condition = [{lv,482}]};

get_reward(5,2,13) ->
	#base_investment_reward{type = 5,level = 2,id = 13,rewards = [{2,0,1615}],condition = [{lv,490}]};

get_reward(5,2,14) ->
	#base_investment_reward{type = 5,level = 2,id = 14,rewards = [{2,0,1657}],condition = [{lv,498}]};

get_reward(6,1,1) ->
	#base_investment_reward{type = 6,level = 1,id = 1,rewards = [{2,0,1288}],condition = []};

get_reward(6,1,2) ->
	#base_investment_reward{type = 6,level = 1,id = 2,rewards = [{2,0,638}],condition = [{lv,474}]};

get_reward(6,1,3) ->
	#base_investment_reward{type = 6,level = 1,id = 3,rewards = [{2,0,696}],condition = [{lv,480}]};

get_reward(6,1,4) ->
	#base_investment_reward{type = 6,level = 1,id = 4,rewards = [{2,0,754}],condition = [{lv,485}]};

get_reward(6,1,5) ->
	#base_investment_reward{type = 6,level = 1,id = 5,rewards = [{2,0,754}],condition = [{lv,498}]};

get_reward(6,1,6) ->
	#base_investment_reward{type = 6,level = 1,id = 6,rewards = [{2,0,812}],condition = [{lv,506}]};

get_reward(6,1,7) ->
	#base_investment_reward{type = 6,level = 1,id = 7,rewards = [{2,0,812}],condition = [{lv,515}]};

get_reward(6,1,8) ->
	#base_investment_reward{type = 6,level = 1,id = 8,rewards = [{2,0,870}],condition = [{lv,520}]};

get_reward(6,1,9) ->
	#base_investment_reward{type = 6,level = 1,id = 9,rewards = [{2,0,928}],condition = [{lv,525}]};

get_reward(6,1,10) ->
	#base_investment_reward{type = 6,level = 1,id = 10,rewards = [{2,0,986}],condition = [{lv,529}]};

get_reward(6,1,11) ->
	#base_investment_reward{type = 6,level = 1,id = 11,rewards = [{2,0,1044}],condition = [{lv,534}]};

get_reward(6,1,12) ->
	#base_investment_reward{type = 6,level = 1,id = 12,rewards = [{2,0,1073}],condition = [{lv,541}]};

get_reward(6,1,13) ->
	#base_investment_reward{type = 6,level = 1,id = 13,rewards = [{2,0,1102}],condition = [{lv,548}]};

get_reward(6,1,14) ->
	#base_investment_reward{type = 6,level = 1,id = 14,rewards = [{2,0,1131}],condition = [{lv,562}]};

get_reward(6,2,1) ->
	#base_investment_reward{type = 6,level = 2,id = 1,rewards = [{2,0,2888}],condition = []};

get_reward(6,2,2) ->
	#base_investment_reward{type = 6,level = 2,id = 2,rewards = [{2,0,1430}],condition = [{lv,474}]};

get_reward(6,2,3) ->
	#base_investment_reward{type = 6,level = 2,id = 3,rewards = [{2,0,1560}],condition = [{lv,480}]};

get_reward(6,2,4) ->
	#base_investment_reward{type = 6,level = 2,id = 4,rewards = [{2,0,1690}],condition = [{lv,485}]};

get_reward(6,2,5) ->
	#base_investment_reward{type = 6,level = 2,id = 5,rewards = [{2,0,1690}],condition = [{lv,498}]};

get_reward(6,2,6) ->
	#base_investment_reward{type = 6,level = 2,id = 6,rewards = [{2,0,1820}],condition = [{lv,506}]};

get_reward(6,2,7) ->
	#base_investment_reward{type = 6,level = 2,id = 7,rewards = [{2,0,1820}],condition = [{lv,515}]};

get_reward(6,2,8) ->
	#base_investment_reward{type = 6,level = 2,id = 8,rewards = [{2,0,1950}],condition = [{lv,520}]};

get_reward(6,2,9) ->
	#base_investment_reward{type = 6,level = 2,id = 9,rewards = [{2,0,2080}],condition = [{lv,525}]};

get_reward(6,2,10) ->
	#base_investment_reward{type = 6,level = 2,id = 10,rewards = [{2,0,2210}],condition = [{lv,529}]};

get_reward(6,2,11) ->
	#base_investment_reward{type = 6,level = 2,id = 11,rewards = [{2,0,2340}],condition = [{lv,534}]};

get_reward(6,2,12) ->
	#base_investment_reward{type = 6,level = 2,id = 12,rewards = [{2,0,2405}],condition = [{lv,541}]};

get_reward(6,2,13) ->
	#base_investment_reward{type = 6,level = 2,id = 13,rewards = [{2,0,2470}],condition = [{lv,548}]};

get_reward(6,2,14) ->
	#base_investment_reward{type = 6,level = 2,id = 14,rewards = [{2,0,2535}],condition = [{lv,562}]};

get_reward(7,1,1) ->
	#base_investment_reward{type = 7,level = 1,id = 1,rewards = [{2,0,1288}],condition = []};

get_reward(7,1,2) ->
	#base_investment_reward{type = 7,level = 1,id = 2,rewards = [{2,0,638}],condition = [{lv,542}]};

get_reward(7,1,3) ->
	#base_investment_reward{type = 7,level = 1,id = 3,rewards = [{2,0,696}],condition = [{lv,545}]};

get_reward(7,1,4) ->
	#base_investment_reward{type = 7,level = 1,id = 4,rewards = [{2,0,754}],condition = [{lv,548}]};

get_reward(7,1,5) ->
	#base_investment_reward{type = 7,level = 1,id = 5,rewards = [{2,0,754}],condition = [{lv,555}]};

get_reward(7,1,6) ->
	#base_investment_reward{type = 7,level = 1,id = 6,rewards = [{2,0,812}],condition = [{lv,558}]};

get_reward(7,1,7) ->
	#base_investment_reward{type = 7,level = 1,id = 7,rewards = [{2,0,812}],condition = [{lv,563}]};

get_reward(7,1,8) ->
	#base_investment_reward{type = 7,level = 1,id = 8,rewards = [{2,0,870}],condition = [{lv,568}]};

get_reward(7,1,9) ->
	#base_investment_reward{type = 7,level = 1,id = 9,rewards = [{2,0,928}],condition = [{lv,573}]};

get_reward(7,1,10) ->
	#base_investment_reward{type = 7,level = 1,id = 10,rewards = [{2,0,986}],condition = [{lv,577}]};

get_reward(7,1,11) ->
	#base_investment_reward{type = 7,level = 1,id = 11,rewards = [{2,0,1044}],condition = [{lv,583}]};

get_reward(7,1,12) ->
	#base_investment_reward{type = 7,level = 1,id = 12,rewards = [{2,0,1073}],condition = [{lv,601}]};

get_reward(7,1,13) ->
	#base_investment_reward{type = 7,level = 1,id = 13,rewards = [{2,0,1102}],condition = [{lv,608}]};

get_reward(7,1,14) ->
	#base_investment_reward{type = 7,level = 1,id = 14,rewards = [{2,0,1131}],condition = [{lv,615}]};

get_reward(7,2,1) ->
	#base_investment_reward{type = 7,level = 2,id = 1,rewards = [{2,0,2888}],condition = []};

get_reward(7,2,2) ->
	#base_investment_reward{type = 7,level = 2,id = 2,rewards = [{2,0,1430}],condition = [{lv,542}]};

get_reward(7,2,3) ->
	#base_investment_reward{type = 7,level = 2,id = 3,rewards = [{2,0,1560}],condition = [{lv,545}]};

get_reward(7,2,4) ->
	#base_investment_reward{type = 7,level = 2,id = 4,rewards = [{2,0,1690}],condition = [{lv,548}]};

get_reward(7,2,5) ->
	#base_investment_reward{type = 7,level = 2,id = 5,rewards = [{2,0,1690}],condition = [{lv,555}]};

get_reward(7,2,6) ->
	#base_investment_reward{type = 7,level = 2,id = 6,rewards = [{2,0,1820}],condition = [{lv,558}]};

get_reward(7,2,7) ->
	#base_investment_reward{type = 7,level = 2,id = 7,rewards = [{2,0,1820}],condition = [{lv,563}]};

get_reward(7,2,8) ->
	#base_investment_reward{type = 7,level = 2,id = 8,rewards = [{2,0,1950}],condition = [{lv,568}]};

get_reward(7,2,9) ->
	#base_investment_reward{type = 7,level = 2,id = 9,rewards = [{2,0,2080}],condition = [{lv,573}]};

get_reward(7,2,10) ->
	#base_investment_reward{type = 7,level = 2,id = 10,rewards = [{2,0,2210}],condition = [{lv,577}]};

get_reward(7,2,11) ->
	#base_investment_reward{type = 7,level = 2,id = 11,rewards = [{2,0,2340}],condition = [{lv,583}]};

get_reward(7,2,12) ->
	#base_investment_reward{type = 7,level = 2,id = 12,rewards = [{2,0,2405}],condition = [{lv,601}]};

get_reward(7,2,13) ->
	#base_investment_reward{type = 7,level = 2,id = 13,rewards = [{2,0,2470}],condition = [{lv,608}]};

get_reward(7,2,14) ->
	#base_investment_reward{type = 7,level = 2,id = 14,rewards = [{2,0,2535}],condition = [{lv,615}]};

get_reward(8,1,1) ->
	#base_investment_reward{type = 8,level = 1,id = 1,rewards = [{2,0,1888}],condition = []};

get_reward(8,1,2) ->
	#base_investment_reward{type = 8,level = 1,id = 2,rewards = [{2,0,935}],condition = [{lv,621}]};

get_reward(8,1,3) ->
	#base_investment_reward{type = 8,level = 1,id = 3,rewards = [{2,0,1020}],condition = [{lv,622}]};

get_reward(8,1,4) ->
	#base_investment_reward{type = 8,level = 1,id = 4,rewards = [{2,0,1105}],condition = [{lv,624}]};

get_reward(8,1,5) ->
	#base_investment_reward{type = 8,level = 1,id = 5,rewards = [{2,0,1105}],condition = [{lv,626}]};

get_reward(8,1,6) ->
	#base_investment_reward{type = 8,level = 1,id = 6,rewards = [{2,0,1190}],condition = [{lv,628}]};

get_reward(8,1,7) ->
	#base_investment_reward{type = 8,level = 1,id = 7,rewards = [{2,0,1190}],condition = [{lv,631}]};

get_reward(8,1,8) ->
	#base_investment_reward{type = 8,level = 1,id = 8,rewards = [{2,0,1275}],condition = [{lv,634}]};

get_reward(8,1,9) ->
	#base_investment_reward{type = 8,level = 1,id = 9,rewards = [{2,0,1360}],condition = [{lv,639}]};

get_reward(8,1,10) ->
	#base_investment_reward{type = 8,level = 1,id = 10,rewards = [{2,0,1445}],condition = [{lv,644}]};

get_reward(8,1,11) ->
	#base_investment_reward{type = 8,level = 1,id = 11,rewards = [{2,0,1530}],condition = [{lv,650}]};

get_reward(8,1,12) ->
	#base_investment_reward{type = 8,level = 1,id = 12,rewards = [{2,0,1573}],condition = [{lv,668}]};

get_reward(8,1,13) ->
	#base_investment_reward{type = 8,level = 1,id = 13,rewards = [{2,0,1615}],condition = [{lv,677}]};

get_reward(8,1,14) ->
	#base_investment_reward{type = 8,level = 1,id = 14,rewards = [{2,0,1657}],condition = [{lv,682}]};

get_reward(8,2,1) ->
	#base_investment_reward{type = 8,level = 2,id = 1,rewards = [{2,0,3688}],condition = []};

get_reward(8,2,2) ->
	#base_investment_reward{type = 8,level = 2,id = 2,rewards = [{2,0,1826}],condition = [{lv,621}]};

get_reward(8,2,3) ->
	#base_investment_reward{type = 8,level = 2,id = 3,rewards = [{2,0,1992}],condition = [{lv,622}]};

get_reward(8,2,4) ->
	#base_investment_reward{type = 8,level = 2,id = 4,rewards = [{2,0,2158}],condition = [{lv,624}]};

get_reward(8,2,5) ->
	#base_investment_reward{type = 8,level = 2,id = 5,rewards = [{2,0,2158}],condition = [{lv,626}]};

get_reward(8,2,6) ->
	#base_investment_reward{type = 8,level = 2,id = 6,rewards = [{2,0,2324}],condition = [{lv,628}]};

get_reward(8,2,7) ->
	#base_investment_reward{type = 8,level = 2,id = 7,rewards = [{2,0,2324}],condition = [{lv,631}]};

get_reward(8,2,8) ->
	#base_investment_reward{type = 8,level = 2,id = 8,rewards = [{2,0,2490}],condition = [{lv,634}]};

get_reward(8,2,9) ->
	#base_investment_reward{type = 8,level = 2,id = 9,rewards = [{2,0,2656}],condition = [{lv,639}]};

get_reward(8,2,10) ->
	#base_investment_reward{type = 8,level = 2,id = 10,rewards = [{2,0,2822}],condition = [{lv,644}]};

get_reward(8,2,11) ->
	#base_investment_reward{type = 8,level = 2,id = 11,rewards = [{2,0,2988}],condition = [{lv,650}]};

get_reward(8,2,12) ->
	#base_investment_reward{type = 8,level = 2,id = 12,rewards = [{2,0,3071}],condition = [{lv,668}]};

get_reward(8,2,13) ->
	#base_investment_reward{type = 8,level = 2,id = 13,rewards = [{2,0,3154}],condition = [{lv,677}]};

get_reward(8,2,14) ->
	#base_investment_reward{type = 8,level = 2,id = 14,rewards = [{2,0,3237}],condition = [{lv,682}]};

get_reward(_Type,_Level,_Id) ->
	[].

get_all_reward_id(1,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_all_reward_id(1,3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_all_reward_id(2,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];

get_all_reward_id(4,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_all_reward_id(4,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_all_reward_id(4,3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_all_reward_id(5,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(5,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(6,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(6,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(7,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(7,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(8,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(8,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14];

get_all_reward_id(_Type,_Level) ->
	[].

get_item(1) ->
	#base_investment_item{type = 1,do_type = 1,show_id = 0,condition = [{min_lv,40}],reset_type = 0};

get_item(2) ->
	#base_investment_item{type = 2,do_type = 2,show_id = 0,condition = [{min_lv,40}],reset_type = 1};

get_item(4) ->
	#base_investment_item{type = 4,do_type = 1,show_id = 0,condition = [{min_lv,9999}],reset_type = 0};

get_item(5) ->
	#base_investment_item{type = 5,do_type = 1,show_id = 1,condition = [{min_lv,370}],reset_type = 0};

get_item(6) ->
	#base_investment_item{type = 6,do_type = 1,show_id = 1,condition = [{min_lv,470}],reset_type = 0};

get_item(7) ->
	#base_investment_item{type = 7,do_type = 1,show_id = 1,condition = [{min_lv,540}],reset_type = 0};

get_item(8) ->
	#base_investment_item{type = 8,do_type = 1,show_id = 1,condition = [{min_lv,620}],reset_type = 0};

get_item(_Type) ->
	[].

get_type_list() ->
[1,2,4,5,6,7,8].


get_reset_type(1) ->
0;


get_reset_type(2) ->
1;


get_reset_type(4) ->
0;


get_reset_type(5) ->
0;


get_reset_type(6) ->
0;


get_reset_type(7) ->
0;


get_reset_type(8) ->
0;

get_reset_type(_Type) ->
	0.

