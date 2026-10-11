%%%---------------------------------------
%%% module      : data_bonus_draw
%%% description : 赛博夺宝配置
%%%
%%%---------------------------------------
-module(data_bonus_draw).
-compile(export_all).
-include("bonus_draw.hrl").



get_bonus_grade(58,1,1,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,1,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,1,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,1,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,1,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,1,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,1,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,1,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,1,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,1,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,1,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,1,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,1,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,1,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,1,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,1,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,1,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,1,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,1,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,1,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,1,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,1,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,1,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,1,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,1,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,1,1,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,1,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,2,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,2,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,2,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,2,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,2,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,2,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,2,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,2,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,2,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,2,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,2,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,2,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,2,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,2,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,2,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,2,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,2,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,2,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,2,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,2,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,2,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,2,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,2,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,2,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,2,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,3,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,3,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,3,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,3,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,3,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,3,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,3,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,3,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,3,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,3,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,3,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,3,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,3,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,3,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,3,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,3,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,3,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,3,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,3,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,3,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,3,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,3,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,3,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,3,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,3,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,4,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,4,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,4,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,4,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,4,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,4,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,4,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,4,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,4,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,4,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,4,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,4,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,4,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,4,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,4,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,4,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,4,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,4,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,4,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,4,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,4,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,4,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,4,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,4,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,4,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,5,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,5,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,5,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,5,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,5,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,5,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,5,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,5,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,5,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,5,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,5,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,5,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,5,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,5,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,5,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,5,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,5,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,5,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,5,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,5,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,5,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,5,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,5,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,5,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,5,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,6,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,6,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,6,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,6,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,6,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,6,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,6,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,6,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,6,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,6,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,6,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,6,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,6,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,6,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,6,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,6,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,6,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,6,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,6,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,6,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,6,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,6,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,6,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,6,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,6,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,7,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,7,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,7,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,7,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,7,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,7,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,7,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,7,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,7,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,7,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,7,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,7,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,7,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,7,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,7,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,7,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,7,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,7,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,7,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,7,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,7,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,7,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,7,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,7,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,7,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,8,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,8,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,8,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,8,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,8,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,8,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,8,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,8,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,8,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,8,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,8,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,8,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,8,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,8,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,8,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,8,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,8,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,8,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,8,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,8,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,8,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,8,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,8,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,8,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,8,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,1) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,1,9,2) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,1,9,3) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,1,9,4) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,1,9,5) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,1,9,6) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,1,9,7) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,1,9,8) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,1,9,9) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,1,9,10) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,1,9,11) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,1,9,12) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,1,9,13) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,1,9,14) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,1,9,15) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,1,9,16) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,1,9,17) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,1,9,18) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,1,9,19) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,1,9,20) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,1,9,21) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,1,9,22) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,1,9,23) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,24) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,25) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,26) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,1,9,27) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,1,9,28) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,29) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,30) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,1,9,31) ->
	#base_draw_pool{type = 58,subtype = 1,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,1,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,1,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,1,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,1,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,1,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,1,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,1,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,1,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,1,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,1,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,1,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,1,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,1,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,1,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,1,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,1,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,1,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,1,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,1,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,1,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,1,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,1,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,1,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,1,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,1,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,2,1,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,1,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,2,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,2,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,2,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,2,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,2,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,2,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,2,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,2,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,2,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,2,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,2,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,2,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,2,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,2,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,2,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,2,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,2,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,2,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,2,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,2,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,2,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,2,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,2,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,2,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,2,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,3,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,3,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,3,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,3,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,3,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,3,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,3,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,3,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,3,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,3,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,3,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,3,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,3,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,3,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,3,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,3,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,3,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,3,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,3,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,3,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,3,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,3,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,3,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,3,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,3,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,4,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,4,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,4,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,4,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,4,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,4,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,4,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,4,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,4,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,4,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,4,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,4,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,4,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,4,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,4,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,4,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,4,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,4,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,4,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,4,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,4,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,4,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,4,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,4,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,4,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,5,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,5,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,5,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,5,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,5,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,5,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,5,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,5,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,5,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,5,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,5,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,5,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,5,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,5,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,5,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,5,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,5,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,5,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,5,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,5,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,5,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,5,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,5,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,5,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,5,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,6,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,6,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,6,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,6,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,6,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,6,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,6,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,6,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,6,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,6,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,6,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,6,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,6,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,6,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,6,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,6,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,6,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,6,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,6,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,6,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,6,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,6,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,6,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,6,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,6,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,7,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,7,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,7,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,7,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,7,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,7,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,7,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,7,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,7,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,7,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,7,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,7,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,7,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,7,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,7,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,7,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,7,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,7,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,7,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,7,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,7,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,7,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,7,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,7,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,7,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,8,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,8,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,8,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,8,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,8,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,8,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,8,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,8,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,8,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,8,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,8,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,8,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,8,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,8,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,8,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,8,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,8,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,8,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,8,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,8,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,8,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,8,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,8,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,8,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,8,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,1) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,2,9,2) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,2,9,3) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,2,9,4) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,2,9,5) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,2,9,6) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,2,9,7) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,2,9,8) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,2,9,9) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,2,9,10) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,2,9,11) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,2,9,12) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,2,9,13) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,2,9,14) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,2,9,15) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,2,9,16) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,2,9,17) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,2,9,18) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,2,9,19) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,2,9,20) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,2,9,21) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,2,9,22) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,2,9,23) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,24) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,25) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,26) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,2,9,27) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,2,9,28) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,29) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,30) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,2,9,31) ->
	#base_draw_pool{type = 58,subtype = 2,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,1,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,1,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,1,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,1,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,1,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,1,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,1,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,1,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,1,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,1,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,1,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,1,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,1,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,1,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,1,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,1,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,1,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,1,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,1,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,1,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,1,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,1,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,1,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,1,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,1,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,3,1,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,1,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,2,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,2,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,2,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,2,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,2,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,2,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,2,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,2,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,2,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,2,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,2,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,2,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,2,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,2,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,2,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,2,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,2,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,2,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,2,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,2,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,2,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,2,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,2,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,2,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,2,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,3,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,3,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,3,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,3,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,3,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,3,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,3,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,3,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,3,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,3,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,3,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,3,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,3,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,3,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,3,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,3,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,3,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,3,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,3,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,3,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,3,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,3,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,3,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,3,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,3,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,4,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,4,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,4,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,4,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,4,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,4,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,4,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,4,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,4,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,4,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,4,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,4,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,4,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,4,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,4,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,4,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,4,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,4,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,4,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,4,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,4,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,4,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,4,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,4,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,4,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,5,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,5,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,5,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,5,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,5,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,5,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,5,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,5,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,5,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,5,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,5,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,5,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,5,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,5,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,5,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,5,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,5,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,5,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,5,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,5,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,5,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,5,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,5,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,5,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,5,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,6,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,6,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,6,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,6,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,6,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,6,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,6,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,6,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,6,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,6,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,6,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,6,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,6,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,6,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,6,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,6,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,6,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,6,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,6,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,6,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,6,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,6,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,6,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,6,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,6,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,7,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,7,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,7,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,7,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,7,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,7,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,7,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,7,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,7,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,7,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,7,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,7,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,7,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,7,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,7,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,7,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,7,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,7,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,7,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,7,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,7,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,7,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,7,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,7,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,7,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,8,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,8,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,8,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,8,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,8,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,8,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,8,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,8,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,8,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,8,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,8,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,8,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,8,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,8,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,8,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,8,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,8,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,8,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,8,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,8,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,8,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,8,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,8,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,8,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,8,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,1) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,3,9,2) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,3,9,3) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,3,9,4) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,3,9,5) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,3,9,6) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,3,9,7) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,3,9,8) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,3,9,9) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,3,9,10) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,3,9,11) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,3,9,12) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,3,9,13) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,3,9,14) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,3,9,15) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,3,9,16) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,3,9,17) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,3,9,18) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,3,9,19) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,3,9,20) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,3,9,21) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,3,9,22) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,3,9,23) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,24) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,25) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,26) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,3,9,27) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,3,9,28) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,29) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,30) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,3,9,31) ->
	#base_draw_pool{type = 58,subtype = 3,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,1,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,1,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,1,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,1,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,1,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,1,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,1,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,1,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,1,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,1,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,1,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,1,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,1,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,1,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,1,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,1,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,1,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,1,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,1,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,1,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,1,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,1,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,1,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,1,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,1,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,4,1,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,1,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,2,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,2,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,2,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,2,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,2,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,2,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,2,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,2,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,2,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,2,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,2,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,2,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,2,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,2,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,2,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,2,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,2,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,2,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,2,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,2,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,2,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,2,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,2,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,2,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,2,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,3,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,3,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,3,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,3,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,3,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,3,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,3,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,3,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,3,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,3,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,3,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,3,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,3,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,3,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,3,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,3,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,3,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,3,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,3,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,3,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,3,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,3,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,3,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,3,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,3,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,4,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,4,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,4,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,4,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,4,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,4,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,4,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,4,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,4,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,4,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,4,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,4,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,4,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,4,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,4,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,4,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,4,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,4,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,4,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,4,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,4,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,4,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,4,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,4,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,4,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,5,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,5,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,5,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,5,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,5,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,5,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,5,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,5,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,5,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,5,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,5,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,5,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,5,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,5,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,5,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,5,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,5,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,5,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,5,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,5,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,5,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,5,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,5,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,5,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,5,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,6,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,6,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,6,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,6,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,6,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,6,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,6,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,6,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,6,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,6,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,6,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,6,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,6,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,6,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,6,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,6,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,6,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,6,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,6,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,6,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,6,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,6,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,6,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,6,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,6,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,7,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,7,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,7,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,7,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,7,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,7,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,7,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,7,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,7,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,7,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,7,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,7,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,7,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,7,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,7,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,7,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,7,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,7,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,7,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,7,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,7,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,7,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,7,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,7,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,7,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,8,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,8,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,8,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,8,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,8,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,8,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,8,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,8,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,8,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,8,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,8,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,8,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,8,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,8,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,8,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,8,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,8,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,8,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,8,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,8,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,8,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,8,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,8,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,8,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,8,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,1) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,4,9,2) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,4,9,3) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,4,9,4) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,4,9,5) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,4,9,6) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,4,9,7) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,4,9,8) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,4,9,9) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,4,9,10) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,4,9,11) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,4,9,12) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,4,9,13) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,4,9,14) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,4,9,15) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,4,9,16) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,4,9,17) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,4,9,18) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,4,9,19) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,4,9,20) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,4,9,21) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,4,9,22) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,4,9,23) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,24) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,25) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,26) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,4,9,27) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,4,9,28) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,29) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,30) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,4,9,31) ->
	#base_draw_pool{type = 58,subtype = 4,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,1,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,1,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,1,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,1,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,1,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,1,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,1,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,1,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,1,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,1,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,1,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,1,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,1,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,1,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,1,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,1,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,1,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,1,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,1,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,1,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,1,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,1,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,1,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,1,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,1,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,5,1,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,1,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,2,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,2,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,2,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,2,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,2,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,2,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,2,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,2,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,2,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,2,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,2,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,2,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,2,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,2,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,2,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,2,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,2,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,2,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,2,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,2,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,2,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,2,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,2,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,2,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,2,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,3,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,3,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,3,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,3,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,3,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,3,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,3,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,3,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,3,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,3,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,3,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,3,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,3,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,3,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,3,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,3,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,3,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,3,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,3,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,3,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,3,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,3,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,3,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,3,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,3,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,4,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,4,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,4,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,4,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,4,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,4,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,4,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,4,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,4,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,4,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,4,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,4,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,4,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,4,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,4,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,4,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,4,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,4,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,4,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,4,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,4,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,4,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,4,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,4,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,4,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,5,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,5,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,5,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,5,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,5,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,5,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,5,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,5,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,5,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,5,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,5,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,5,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,5,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,5,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,5,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,5,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,5,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,5,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,5,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,5,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,5,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,5,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,5,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,5,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,5,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,6,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,6,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,6,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,6,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,6,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,6,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,6,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,6,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,6,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,6,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,6,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,6,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,6,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,6,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,6,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,6,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,6,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,6,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,6,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,6,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,6,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,6,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,6,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,6,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,6,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,7,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,7,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,7,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,7,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,7,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,7,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,7,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,7,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,7,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,7,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,7,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,7,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,7,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,7,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,7,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,7,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,7,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,7,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,7,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,7,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,7,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,7,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,7,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,7,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,7,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,8,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,8,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,8,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,8,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,8,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,8,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,8,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,8,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,8,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,8,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,8,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,8,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,8,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,8,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,8,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,8,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,8,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,8,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,8,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,8,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,8,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,8,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,8,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,8,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,8,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,1) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,5,9,2) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,5,9,3) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,5,9,4) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,5,9,5) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,5,9,6) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,5,9,7) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,5,9,8) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,5,9,9) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,5,9,10) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,5,9,11) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,5,9,12) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,5,9,13) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,5,9,14) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,5,9,15) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,5,9,16) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,5,9,17) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,5,9,18) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,5,9,19) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,5,9,20) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,5,9,21) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,5,9,22) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,5,9,23) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,24) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,25) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,26) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,5,9,27) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,5,9,28) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,29) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,30) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,5,9,31) ->
	#base_draw_pool{type = 58,subtype = 5,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,1,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,1,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,1,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,1,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,1,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,1,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,1,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,1,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,1,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,1,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,1,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,1,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,1,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,1,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,1,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,1,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,1,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,1,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,1,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,1,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,1,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,1,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,1,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,1,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,1,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,6,1,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,1,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,2,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,2,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,2,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,2,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,2,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,2,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,2,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,2,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,2,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,2,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,2,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,2,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,2,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,2,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,2,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,2,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,2,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,2,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,2,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,2,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,2,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,2,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,2,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,2,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,2,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,3,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,3,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,3,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,3,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,3,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,3,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,3,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,3,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,3,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,3,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,3,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,3,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,3,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,3,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,3,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,3,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,3,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,3,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,3,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,3,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,3,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,3,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,3,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,3,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,3,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,4,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,4,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,4,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,4,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,4,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,4,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,4,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,4,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,4,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,4,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,4,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,4,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,4,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,4,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,4,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,4,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,4,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,4,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,4,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,4,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,4,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,4,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,4,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,4,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,4,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,5,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,5,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,5,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,5,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,5,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,5,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,5,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,5,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,5,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,5,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,5,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,5,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,5,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,5,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,5,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,5,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,5,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,5,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,5,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,5,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,5,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,5,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,5,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,5,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,5,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,6,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,6,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,6,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,6,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,6,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,6,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,6,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,6,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,6,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,6,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,6,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,6,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,6,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,6,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,6,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,6,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,6,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,6,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,6,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,6,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,6,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,6,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,6,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,6,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,6,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,7,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,7,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,7,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,7,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,7,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,7,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,7,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,7,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,7,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,7,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,7,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,7,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,7,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,7,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,7,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,7,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,7,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,7,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,7,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,7,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,7,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,7,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,7,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,7,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,7,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,8,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,8,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,8,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,8,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,8,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,8,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,8,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,8,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,8,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,8,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,8,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,8,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,8,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,8,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,8,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,8,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,8,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,8,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,8,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,8,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,8,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,8,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,8,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,8,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,8,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,1) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,6,9,2) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,6,9,3) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,6,9,4) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,6,9,5) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,6,9,6) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,6,9,7) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,6,9,8) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,6,9,9) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,6,9,10) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,6,9,11) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,6,9,12) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,6,9,13) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,6,9,14) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,6,9,15) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,6,9,16) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,6,9,17) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,6,9,18) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,6,9,19) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,6,9,20) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,6,9,21) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,6,9,22) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,6,9,23) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,24) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,25) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,26) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,6,9,27) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,6,9,28) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,29) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,30) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,6,9,31) ->
	#base_draw_pool{type = 58,subtype = 6,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,1,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,1,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,1,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,1,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,1,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,1,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,1,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,1,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,1,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,1,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,1,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,1,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,1,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,1,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,1,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,1,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,1,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,1,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,1,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,1,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,1,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,1,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,1,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,1,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,1,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,7,1,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,1,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,2,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,2,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,2,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,2,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,2,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,2,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,2,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,2,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,2,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,2,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,2,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,2,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,2,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,2,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,2,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,2,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,2,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,2,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,2,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,2,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,2,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,2,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,2,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,2,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,2,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,3,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,3,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,3,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,3,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,3,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,3,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,3,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,3,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,3,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,3,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,3,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,3,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,3,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,3,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,3,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,3,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,3,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,3,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,3,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,3,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,3,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,3,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,3,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,3,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,3,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,4,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,4,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,4,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,4,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,4,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,4,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,4,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,4,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,4,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,4,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,4,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,4,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,4,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,4,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,4,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,4,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,4,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,4,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,4,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,4,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,4,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,4,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,4,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,4,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,4,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,5,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,5,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,5,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,5,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,5,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,5,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,5,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,5,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,5,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,5,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,5,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,5,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,5,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,5,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,5,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,5,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,5,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,5,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,5,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,5,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,5,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,5,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,5,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,5,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,5,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,6,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,6,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,6,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,6,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,6,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,6,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,6,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,6,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,6,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,6,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,6,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,6,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,6,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,6,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,6,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,6,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,6,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,6,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,6,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,6,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,6,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,6,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,6,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,6,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,6,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,7,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,7,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,7,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,7,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,7,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,7,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,7,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,7,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,7,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,7,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,7,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,7,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,7,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,7,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,7,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,7,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,7,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,7,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,7,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,7,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,7,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,7,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,7,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,7,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,7,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,8,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,8,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,8,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,8,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,8,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,8,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,8,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,8,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,8,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,8,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,8,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,8,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,8,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,8,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,8,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,8,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,8,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,8,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,8,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,8,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,8,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,8,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,8,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,8,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,8,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,1) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,7,9,2) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,7,9,3) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,7,9,4) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,7,9,5) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,7,9,6) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,7,9,7) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,7,9,8) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,7,9,9) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,7,9,10) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,7,9,11) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,7,9,12) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,7,9,13) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,7,9,14) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,7,9,15) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,7,9,16) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,7,9,17) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,7,9,18) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,7,9,19) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,7,9,20) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,7,9,21) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,7,9,22) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,7,9,23) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,24) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,25) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,26) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,7,9,27) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,7,9,28) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,29) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,30) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,7,9,31) ->
	#base_draw_pool{type = 58,subtype = 7,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,1,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,1,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,1,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,1,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,1,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,1,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,1,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,1,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,1,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,1,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,1,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,1,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,1,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,1,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,1,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,1,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,1,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,1,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,1,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,1,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,1,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,1,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,1,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 23,rare = 1,conditions = [{draw,1500},{weight,100}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,1,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 24,rare = 1,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,1,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 25,rare = 1,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,6420805,10}],tv = [{331, 32}]};

get_bonus_grade(58,8,1,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 26,rare = 1,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,16010002,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,1,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 1,grade = 27,rare = 1,conditions = [{draw,3000},{weight,100}],reward_type = 0,reward = [{0,32010205,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,2,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,2,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,2,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,2,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,2,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,2,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,2,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,2,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,2,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,2,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,2,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,2,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,2,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,2,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,2,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,2,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,2,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,2,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,2,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,2,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,2,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,2,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,2,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,2,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,2,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 2,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,3,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,3,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,3,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,3,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,3,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,3,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,3,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,3,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,3,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,3,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,3,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,3,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,3,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,3,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,3,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,3,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,3,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,3,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,3,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,3,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,3,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,3,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,3,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,3,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,3,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 3,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,4,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,4,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,4,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,4,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,4,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,4,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,4,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,4,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,4,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,4,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,4,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,4,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,4,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,4,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,4,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,4,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,4,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,4,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,4,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,4,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,4,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,4,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,4,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,4,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,4,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 4,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,5,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,5,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,5,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,5,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,5,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,5,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,5,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,5,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,5,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,5,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,5,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,5,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,5,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,5,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,5,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,5,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,5,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,5,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,5,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,5,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,5,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,5,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,5,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,5,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,5,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 5,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,6,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,6,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,6,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,6,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,6,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,6,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,6,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,6,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,6,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,6,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,6,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,6,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,6,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,6,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,6,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,6,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,6,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,6,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,6,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,6,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,6,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,6,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,6,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,6,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,6,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 6,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,7,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,7,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,7,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,7,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,7,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,7,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,7,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,7,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,7,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,7,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,7,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,7,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,7,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,7,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,7,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,7,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,7,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,7,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,7,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,7,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,7,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,7,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,7,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,7,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,7,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 7,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,8,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,8,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,8,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,8,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,8,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,8,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,8,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,8,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,8,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,8,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,8,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,8,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,8,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,8,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,8,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,8,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,8,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,8,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,8,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,8,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,8,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,8,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,8,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,8,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,8,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 8,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,1) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 1,rare = 0,conditions = [{draw,1},{weight,100}],reward_type = 0,reward = [{0,19030109,10}],tv = []};

get_bonus_grade(58,8,9,2) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 2,rare = 0,conditions = [{draw,2},{weight,100}],reward_type = 0,reward = [{0,19030109,5}],tv = []};

get_bonus_grade(58,8,9,3) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 3,rare = 0,conditions = [{draw,7},{weight,100}],reward_type = 0,reward = [{0,19030109,2}],tv = []};

get_bonus_grade(58,8,9,4) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 4,rare = 0,conditions = [{draw,20},{weight,100}],reward_type = 0,reward = [{0,19030109,1}],tv = []};

get_bonus_grade(58,8,9,5) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 5,rare = 0,conditions = [{draw,10},{weight,100}],reward_type = 0,reward = [{0,34010376,3}],tv = []};

get_bonus_grade(58,8,9,6) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 6,rare = 0,conditions = [{draw,60},{weight,100}],reward_type = 0,reward = [{0,34010376,1}],tv = []};

get_bonus_grade(58,8,9,7) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 7,rare = 0,conditions = [{draw,100},{weight,100}],reward_type = 0,reward = [{0,38240027,1}],tv = []};

get_bonus_grade(58,8,9,8) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 8,rare = 0,conditions = [{draw,150},{weight,100}],reward_type = 0,reward = [{0,38240201,1}],tv = []};

get_bonus_grade(58,8,9,9) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 9,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,38040030,3}],tv = []};

get_bonus_grade(58,8,9,10) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 10,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,38040030,5}],tv = []};

get_bonus_grade(58,8,9,11) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 11,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,16020001,2}],tv = []};

get_bonus_grade(58,8,9,12) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 12,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,17020001,2}],tv = []};

get_bonus_grade(58,8,9,13) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 13,rare = 0,conditions = [{draw,500},{weight,100}],reward_type = 0,reward = [{0,18020001,2}],tv = []};

get_bonus_grade(58,8,9,14) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 14,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14010003,1}],tv = []};

get_bonus_grade(58,8,9,15) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 15,rare = 0,conditions = [{draw,200},{weight,100}],reward_type = 0,reward = [{0,14020003,1}],tv = []};

get_bonus_grade(58,8,9,16) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 16,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14010002,1}],tv = []};

get_bonus_grade(58,8,9,17) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 17,rare = 0,conditions = [{draw,1000},{weight,100}],reward_type = 0,reward = [{0,14020002,1}],tv = []};

get_bonus_grade(58,8,9,18) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 18,rare = 0,conditions = [{draw,1200},{weight,100}],reward_type = 0,reward = [{0,36255031,20}],tv = []};

get_bonus_grade(58,8,9,19) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 19,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,36255031,30}],tv = []};

get_bonus_grade(58,8,9,20) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 20,rare = 0,conditions = [{draw,300},{weight,100}],reward_type = 0,reward = [{0,36255031,50}],tv = []};

get_bonus_grade(58,8,9,21) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 21,rare = 0,conditions = [{draw,800},{weight,100}],reward_type = 0,reward = [{0,22020001,20}],tv = []};

get_bonus_grade(58,8,9,22) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 22,rare = 0,conditions = [{draw,350},{weight,100}],reward_type = 0,reward = [{0,38100003,1}],tv = []};

get_bonus_grade(58,8,9,23) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 23,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,38240201,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,24) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 24,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,38240301,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,25) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 25,rare = 1,conditions = [{draw,400},{weight,5000}],reward_type = 0,reward = [{0,6420805,2}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,26) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 26,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010001,1}],tv = []};

get_bonus_grade(58,8,9,27) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 27,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,16010002,1}],tv = []};

get_bonus_grade(58,8,9,28) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 28,rare = 1,conditions = [{draw,400},{weight,2000}],reward_type = 0,reward = [{0,32010194,1}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,29) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 29,rare = 1,conditions = [{draw,400},{weight,300}],reward_type = 0,reward = [{0,34010376,5}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,30) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 30,rare = 1,conditions = [{draw,400},{weight,1000}],reward_type = 0,reward = [{0,35,288}],tv = [{331, 32}]};

get_bonus_grade(58,8,9,31) ->
	#base_draw_pool{type = 58,subtype = 8,wave = 9,grade = 31,rare = 1,conditions = [{draw,400},{weight,1500}],reward_type = 0,reward = [{0,36255006,1}],tv = [{331, 32}]};

get_bonus_grade(_Type,_Subtype,_Wave,_Grade) ->
	[].

	get_pool(58,1,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,1,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,1,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,1,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,2,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,2,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,2,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,3,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,3,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,3,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,4,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,4,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,4,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,5,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,5,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,5,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,6,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,6,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,6,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,7,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,7,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,7,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,1,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,1,1) ->
	[23,24,25,26,27];
	
	get_pool(58,8,2,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,2,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,3,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,3,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,4,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,4,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,5,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,5,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,6,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,6,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,7,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,7,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,8,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,8,1) ->
	[23,24,25,26,27,28,29,30,31];
	
	get_pool(58,8,9,0) ->
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
	
	get_pool(58,8,9,1) ->
	[23,24,25,26,27,28,29,30,31];
	
get_pool(_Type,_Subtype,_Wave,_Rare) ->
	[].

get_stage_reward_cfg(58,1,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,1,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,1,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,1,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,1,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 1,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,2,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,2,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,2,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,2,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,2,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 2,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,3,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,3,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,3,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,3,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,3,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 3,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,4,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,4,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,4,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,4,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,4,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 4,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,5,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,5,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,5,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,5,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,5,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 5,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,6,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,6,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,6,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,6,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,6,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 6,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,7,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,7,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,7,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,7,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,7,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 7,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(58,8,1,1) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 1,grade = 1,condition = [{total,5}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,1,2) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 1,grade = 2,condition = [{total,10}],reward_type = 0,reward = [{0,36255006,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,1,3) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 1,grade = 3,condition = [{total,20}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,1,4) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 1,grade = 4,condition = [{total,30}],reward_type = 0,reward = [{0,34010365,1}],discount = [{1,0,360}],dis_reward = [{0,38240027,5}]};

get_stage_reward_cfg(58,8,2,1) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 2,grade = 1,condition = [{total,35}],reward_type = 0,reward = [{0,32010194,2}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,2,2) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 2,grade = 2,condition = [{total,45}],reward_type = 0,reward = [{0,34010376,6}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,2,3) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 2,grade = 3,condition = [{total,55}],reward_type = 0,reward = [{0,20010003,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,2,4) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 2,grade = 4,condition = [{total,60}],reward_type = 0,reward = [{0,19030109,10}],discount = [{1,0,680}],dis_reward = [{0,34010376,10}]};

get_stage_reward_cfg(58,8,3,1) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 3,grade = 1,condition = [{total,65}],reward_type = 0,reward = [{0,38040012,50}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,3,2) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 3,grade = 2,condition = [{total,75}],reward_type = 0,reward = [{0,38240201,10}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,3,3) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 3,grade = 3,condition = [{total,85}],reward_type = 0,reward = [{0,34010376,7}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,3,4) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 3,grade = 4,condition = [{total,90}],reward_type = 0,reward = [{0,19030109,12}],discount = [{1,0,1600}],dis_reward = [{0,6420805,15}]};

get_stage_reward_cfg(58,8,4,1) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 4,grade = 1,condition = [{total,96}],reward_type = 0,reward = [{0,34010376,5}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,4,2) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 4,grade = 2,condition = [{total,106}],reward_type = 0,reward = [{0,34010193,1}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,4,3) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 4,grade = 3,condition = [{total,116}],reward_type = 0,reward = [{0,34010376,8}],discount = [],dis_reward = []};

get_stage_reward_cfg(58,8,4,4) ->
	#base_draw_stage_reward{type = 58,subtype = 8,stage = 4,grade = 4,condition = [{total,128}],reward_type = 0,reward = [{0,19030109,15}],discount = [{1,0,1680}],dis_reward = [{0,19030109,15}]};

get_stage_reward_cfg(_Type,_Subtype,_Stage,_Grade) ->
	[].

get_all_grade(58,1,1) ->
[1,2,3,4];

get_all_grade(58,1,2) ->
[1,2,3,4];

get_all_grade(58,1,3) ->
[1,2,3,4];

get_all_grade(58,1,4) ->
[1,2,3,4];

get_all_grade(58,2,1) ->
[1,2,3,4];

get_all_grade(58,2,2) ->
[1,2,3,4];

get_all_grade(58,2,3) ->
[1,2,3,4];

get_all_grade(58,2,4) ->
[1,2,3,4];

get_all_grade(58,3,1) ->
[1,2,3,4];

get_all_grade(58,3,2) ->
[1,2,3,4];

get_all_grade(58,3,3) ->
[1,2,3,4];

get_all_grade(58,3,4) ->
[1,2,3,4];

get_all_grade(58,4,1) ->
[1,2,3,4];

get_all_grade(58,4,2) ->
[1,2,3,4];

get_all_grade(58,4,3) ->
[1,2,3,4];

get_all_grade(58,4,4) ->
[1,2,3,4];

get_all_grade(58,5,1) ->
[1,2,3,4];

get_all_grade(58,5,2) ->
[1,2,3,4];

get_all_grade(58,5,3) ->
[1,2,3,4];

get_all_grade(58,5,4) ->
[1,2,3,4];

get_all_grade(58,6,1) ->
[1,2,3,4];

get_all_grade(58,6,2) ->
[1,2,3,4];

get_all_grade(58,6,3) ->
[1,2,3,4];

get_all_grade(58,6,4) ->
[1,2,3,4];

get_all_grade(58,7,1) ->
[1,2,3,4];

get_all_grade(58,7,2) ->
[1,2,3,4];

get_all_grade(58,7,3) ->
[1,2,3,4];

get_all_grade(58,7,4) ->
[1,2,3,4];

get_all_grade(58,8,1) ->
[1,2,3,4];

get_all_grade(58,8,2) ->
[1,2,3,4];

get_all_grade(58,8,3) ->
[1,2,3,4];

get_all_grade(58,8,4) ->
[1,2,3,4];

get_all_grade(_Type,_Subtype,_Stage) ->
	[].

get_all_stage(58,1) ->
[1,2,3,4];

get_all_stage(58,2) ->
[1,2,3,4];

get_all_stage(58,3) ->
[1,2,3,4];

get_all_stage(58,4) ->
[1,2,3,4];

get_all_stage(58,5) ->
[1,2,3,4];

get_all_stage(58,6) ->
[1,2,3,4];

get_all_stage(58,7) ->
[1,2,3,4];

get_all_stage(58,8) ->
[1,2,3,4];

get_all_stage(_Type,_Subtype) ->
	[].

get_draw_cost(_Times) when _Times >= 1, _Times =< 1 ->
		[{0,36255021,0}];
get_draw_cost(_Times) when _Times >= 2, _Times =< 2 ->
		[{0,36255021,10}];
get_draw_cost(_Times) when _Times >= 3, _Times =< 3 ->
		[{0,36255021,20}];
get_draw_cost(_Times) when _Times >= 4, _Times =< 4 ->
		[{0,36255021,30}];
get_draw_cost(_Times) when _Times >= 5, _Times =< 5 ->
		[{0,36255021,40}];
get_draw_cost(_Times) when _Times >= 6, _Times =< 6 ->
		[{0,36255021,60}];
get_draw_cost(_Times) when _Times >= 7, _Times =< 7 ->
		[{0,36255021,80}];
get_draw_cost(_Times) when _Times >= 8, _Times =< 8 ->
		[{0,36255021,100}];
get_draw_cost(_Times) when _Times >= 9, _Times =< 9 ->
		[{0,36255021,120}];
get_draw_cost(_Times) when _Times >= 10, _Times =< 10 ->
		[{0,36255021,150}];
get_draw_cost(_Times) when _Times >= 11, _Times =< 999 ->
		[{0,36255021,200}];
get_draw_cost(_Times) ->
	[].

