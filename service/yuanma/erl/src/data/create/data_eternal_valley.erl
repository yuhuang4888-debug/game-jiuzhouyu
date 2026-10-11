%%%---------------------------------------
%%% module      : data_eternal_valley
%%% description : 永恒碑谷配置
%%%
%%%---------------------------------------
-module(data_eternal_valley).
-compile(export_all).
-include("eternal_valley.hrl").



get_chapter_cfg(1) ->
	#chapter_cfg{id = 1,skill_list = [300201],condition = []};

get_chapter_cfg(2) ->
	#chapter_cfg{id = 2,skill_list = [300202],condition = [1]};

get_chapter_cfg(3) ->
	#chapter_cfg{id = 3,skill_list = [300207],condition = [2]};

get_chapter_cfg(4) ->
	#chapter_cfg{id = 4,skill_list = [300204],condition = [3]};

get_chapter_cfg(5) ->
	#chapter_cfg{id = 5,skill_list = [300205],condition = [4]};

get_chapter_cfg(6) ->
	#chapter_cfg{id = 6,skill_list = [300206],condition = [5]};

get_chapter_cfg(7) ->
	#chapter_cfg{id = 7,skill_list = [300203],condition = []};

get_chapter_cfg(_Id) ->
	[].

get_all_chapter() ->
[1,2,3,4,5,6,7].

get_stage_cfg(1,1) ->
	#stage_cfg{chapter = 1,stage = 1,condition = [{combat,10000}],reward = [{3,0,50000}],recommended_list = 82};

get_stage_cfg(1,2) ->
	#stage_cfg{chapter = 1,stage = 2,condition = [{combat,40000}],reward = [{3,0,100000}],recommended_list = 82};

get_stage_cfg(1,3) ->
	#stage_cfg{chapter = 1,stage = 3,condition = [{combat,60000}],reward = [{3,0,150000}],recommended_list = 82};

get_stage_cfg(1,4) ->
	#stage_cfg{chapter = 1,stage = 4,condition = [{combat,80000}],reward = [{3,0,200000}],recommended_list = 82};

get_stage_cfg(1,5) ->
	#stage_cfg{chapter = 1,stage = 5,condition = [{combat,100000}],reward = [{3,0,250000}],recommended_list = 82};

get_stage_cfg(1,6) ->
	#stage_cfg{chapter = 1,stage = 6,condition = [{combat,120000}],reward = [{3,0,300000}],recommended_list = 82};

get_stage_cfg(1,7) ->
	#stage_cfg{chapter = 1,stage = 7,condition = [{combat,150000}],reward = [{3,0,400000}],recommended_list = 82};

get_stage_cfg(1,8) ->
	#stage_cfg{chapter = 1,stage = 8,condition = [{combat,200000}],reward = [{3,0,500000}],recommended_list = 82};

get_stage_cfg(2,1) ->
	#stage_cfg{chapter = 2,stage = 1,condition = [{lv,200}],reward = [{2,0,20}],recommended_list = 7};

get_stage_cfg(2,2) ->
	#stage_cfg{chapter = 2,stage = 2,condition = [{boss,12,3}],reward = [{100,32010474,1}],recommended_list = 26};

get_stage_cfg(2,3) ->
	#stage_cfg{chapter = 2,stage = 3,condition = [{dun,18,2}],reward = [{2,0,20}],recommended_list = 53};

get_stage_cfg(2,4) ->
	#stage_cfg{chapter = 2,stage = 4,condition = [{jjc,10}],reward = [{2,0,20}],recommended_list = 48};

get_stage_cfg(2,5) ->
	#stage_cfg{chapter = 2,stage = 5,condition = [{combat,500000}],reward = [{2,0,20}],recommended_list = 82};

get_stage_cfg(2,6) ->
	#stage_cfg{chapter = 2,stage = 6,condition = [{boss,99,3}],reward = [{2,0,20}],recommended_list = 104};

get_stage_cfg(2,7) ->
	#stage_cfg{chapter = 2,stage = 7,condition = [{turn,1}],reward = [{2,0,20}],recommended_list = 18};

get_stage_cfg(2,8) ->
	#stage_cfg{chapter = 2,stage = 8,condition = [{rune_dun,14}],reward = [{2,0,20}],recommended_list = 6};

get_stage_cfg(3,1) ->
	#stage_cfg{chapter = 3,stage = 1,condition = [{lv,230}],reward = [{2,0,20}],recommended_list = 7};

get_stage_cfg(3,2) ->
	#stage_cfg{chapter = 3,stage = 2,condition = [{boss,12,6}],reward = [{100,32010474,1}],recommended_list = 26};

get_stage_cfg(3,3) ->
	#stage_cfg{chapter = 3,stage = 3,condition = [{wear_equip_status,6,5,1,3}],reward = [{2,0,20}],recommended_list = 119};

get_stage_cfg(3,4) ->
	#stage_cfg{chapter = 3,stage = 4,condition = [{combat,800000}],reward = [{2,0,20}],recommended_list = 82};

get_stage_cfg(3,5) ->
	#stage_cfg{chapter = 3,stage = 5,condition = [{turn,2}],reward = [{2,0,20}],recommended_list = 18};

get_stage_cfg(3,6) ->
	#stage_cfg{chapter = 3,stage = 6,condition = [{seal_status,4,4,4}],reward = [{2,0,20}],recommended_list = 84};

get_stage_cfg(3,7) ->
	#stage_cfg{chapter = 3,stage = 7,condition = [{compose,2}],reward = [{2,0,20}],recommended_list = 96};

get_stage_cfg(3,8) ->
	#stage_cfg{chapter = 3,stage = 8,condition = [{rune_dun,22}],reward = [{2,0,20}],recommended_list = 6};

get_stage_cfg(4,1) ->
	#stage_cfg{chapter = 4,stage = 1,condition = [{lv,260}],reward = [{2,0,20}],recommended_list = 7};

get_stage_cfg(4,2) ->
	#stage_cfg{chapter = 4,stage = 2,condition = [{boss,12,9}],reward = [{100,32010475,1}],recommended_list = 26};

get_stage_cfg(4,3) ->
	#stage_cfg{chapter = 4,stage = 3,condition = [{wash_equip_status,1,1}],reward = [{2,0,20}],recommended_list = 45};

get_stage_cfg(4,4) ->
	#stage_cfg{chapter = 4,stage = 4,condition = [{combat,1300000}],reward = [{2,0,20}],recommended_list = 82};

get_stage_cfg(4,5) ->
	#stage_cfg{chapter = 4,stage = 5,condition = [{boss,4,3}],reward = [{2,0,20}],recommended_list = 36};

get_stage_cfg(4,6) ->
	#stage_cfg{chapter = 4,stage = 6,condition = [{wear_equip_status,7,5,2,1}],reward = [{2,0,20}],recommended_list = 119};

get_stage_cfg(4,7) ->
	#stage_cfg{chapter = 4,stage = 7,condition = [{rune_dun,26}],reward = [{2,0,20}],recommended_list = 6};

get_stage_cfg(5,1) ->
	#stage_cfg{chapter = 5,stage = 1,condition = [{lv,275}],reward = [{2,0,20}],recommended_list = 7};

get_stage_cfg(5,2) ->
	#stage_cfg{chapter = 5,stage = 2,condition = [{boss,12,12}],reward = [{100,32010475,1}],recommended_list = 26};

get_stage_cfg(5,3) ->
	#stage_cfg{chapter = 5,stage = 3,condition = [{wash_equip_status,1,2}],reward = [{2,0,20}],recommended_list = 45};

get_stage_cfg(5,4) ->
	#stage_cfg{chapter = 5,stage = 4,condition = [{active_suit,1}],reward = [{2,0,20}],recommended_list = 24};

get_stage_cfg(5,5) ->
	#stage_cfg{chapter = 5,stage = 5,condition = [{boss,4,9}],reward = [{2,0,20}],recommended_list = 36};

get_stage_cfg(5,6) ->
	#stage_cfg{chapter = 5,stage = 6,condition = [{compose,3}],reward = [{2,0,20}],recommended_list = 96};

get_stage_cfg(5,7) ->
	#stage_cfg{chapter = 5,stage = 7,condition = [{rune_dun,30}],reward = [{2,0,20}],recommended_list = 6};

get_stage_cfg(6,1) ->
	#stage_cfg{chapter = 6,stage = 1,condition = [{lv,300}],reward = [{2,0,20}],recommended_list = 7};

get_stage_cfg(6,2) ->
	#stage_cfg{chapter = 6,stage = 2,condition = [{boss,12,15}],reward = [{100,32010476,1}],recommended_list = 26};

get_stage_cfg(6,3) ->
	#stage_cfg{chapter = 6,stage = 3,condition = [{dun_dragon,32001}],reward = [{2,0,20}],recommended_list = 120};

get_stage_cfg(6,4) ->
	#stage_cfg{chapter = 6,stage = 4,condition = [{turn,3}],reward = [{2,0,20}],recommended_list = 18};

get_stage_cfg(6,5) ->
	#stage_cfg{chapter = 6,stage = 5,condition = [{boss,4,15}],reward = [{2,0,20}],recommended_list = 36};

get_stage_cfg(6,6) ->
	#stage_cfg{chapter = 6,stage = 6,condition = [{seal_status,7,4,2}],reward = [{2,0,20}],recommended_list = 84};

get_stage_cfg(6,7) ->
	#stage_cfg{chapter = 6,stage = 7,condition = [{rune_dun,36}],reward = [{2,0,20}],recommended_list = 6};

get_stage_cfg(7,1) ->
	#stage_cfg{chapter = 7,stage = 1,condition = [{diamond_investment,[]}],reward = [{2,0,50}],recommended_list = 62};

get_stage_cfg(7,2) ->
	#stage_cfg{chapter = 7,stage = 2,condition = [{first_recharge,[]}],reward = [{2,0,50}],recommended_list = 21};

get_stage_cfg(7,3) ->
	#stage_cfg{chapter = 7,stage = 3,condition = [{active_magic,[]}],reward = [{2,0,50}],recommended_list = 52};

get_stage_cfg(7,4) ->
	#stage_cfg{chapter = 7,stage = 4,condition = [{month_card,[]}],reward = [{2,0,50}],recommended_list = 61};

get_stage_cfg(7,5) ->
	#stage_cfg{chapter = 7,stage = 5,condition = [{vip,4}],reward = [{2,0,50}],recommended_list = 8};

get_stage_cfg(_Chapter,_Stage) ->
	[].


get_all_stage(1) ->
[1,2,3,4,5,6,7,8];


get_all_stage(2) ->
[1,2,3,4,5,6,7,8];


get_all_stage(3) ->
[1,2,3,4,5,6,7,8];


get_all_stage(4) ->
[1,2,3,4,5,6,7];


get_all_stage(5) ->
[1,2,3,4,5,6,7];


get_all_stage(6) ->
[1,2,3,4,5,6,7];


get_all_stage(7) ->
[1,2,3,4,5];

get_all_stage(_Chapter) ->
	[].

