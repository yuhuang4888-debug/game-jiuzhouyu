%%%---------------------------------------
%%% module      : data_guild_skill
%%% description : 公会技能配置
%%%
%%%---------------------------------------
-module(data_guild_skill).
-compile(export_all).
-include("guild.hrl").



get(1) ->
	#guild_skill_cfg{skill_id = 1,skill_name = "命中",type = 1,unlock_lv = 1};

get(2) ->
	#guild_skill_cfg{skill_id = 2,skill_name = "闪避",type = 1,unlock_lv = 1};

get(3) ->
	#guild_skill_cfg{skill_id = 3,skill_name = "暴击",type = 1,unlock_lv = 2};

get(4) ->
	#guild_skill_cfg{skill_id = 4,skill_name = "坚韧",type = 1,unlock_lv = 2};

get(5) ->
	#guild_skill_cfg{skill_id = 5,skill_name = "基础破甲",type = 1,unlock_lv = 3};

get(6) ->
	#guild_skill_cfg{skill_id = 6,skill_name = "基础防御",type = 1,unlock_lv = 3};

get(7) ->
	#guild_skill_cfg{skill_id = 7,skill_name = "基础攻击",type = 1,unlock_lv = 4};

get(8) ->
	#guild_skill_cfg{skill_id = 8,skill_name = "基础生命",type = 1,unlock_lv = 4};

get(_Skillid) ->
	[].

get_all_ids() ->
[1,2,3,4,5,6,7,8].


get_ids_by_unlock_lv(1) ->
[1,2];


get_ids_by_unlock_lv(2) ->
[3,4];


get_ids_by_unlock_lv(3) ->
[5,6];


get_ids_by_unlock_lv(4) ->
[7,8];

get_ids_by_unlock_lv(_Unlocklv) ->
	[].

get_research_cfg(1,0) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{5,0}]};

get_research_cfg(1,1) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{5,45}]};

get_research_cfg(1,2) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{5,90}]};

get_research_cfg(1,3) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{5,135}]};

get_research_cfg(1,4) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{5,180}]};

get_research_cfg(1,5) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{5,225}]};

get_research_cfg(1,6) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{5,270}]};

get_research_cfg(1,7) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{5,315}]};

get_research_cfg(1,8) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{5,360}]};

get_research_cfg(1,9) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{5,405}]};

get_research_cfg(1,10) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{5,450}]};

get_research_cfg(1,11) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{5,495}]};

get_research_cfg(1,12) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{5,540}]};

get_research_cfg(1,13) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{5,585}]};

get_research_cfg(1,14) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{5,630}]};

get_research_cfg(1,15) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{5,675}]};

get_research_cfg(1,16) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{5,720}]};

get_research_cfg(1,17) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{5,765}]};

get_research_cfg(1,18) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{5,810}]};

get_research_cfg(1,19) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{5,855}]};

get_research_cfg(1,20) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{5,900}]};

get_research_cfg(1,21) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{5,945}]};

get_research_cfg(1,22) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{5,990}]};

get_research_cfg(1,23) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{5,1035}]};

get_research_cfg(1,24) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{5,1080}]};

get_research_cfg(1,25) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{5,1125}]};

get_research_cfg(1,26) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{5,1170}]};

get_research_cfg(1,27) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{5,1215}]};

get_research_cfg(1,28) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{5,1260}]};

get_research_cfg(1,29) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{5,1305}]};

get_research_cfg(1,30) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{5,1350}]};

get_research_cfg(1,31) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{5,1395}]};

get_research_cfg(1,32) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{5,1440}]};

get_research_cfg(1,33) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{5,1485}]};

get_research_cfg(1,34) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{5,1530}]};

get_research_cfg(1,35) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{5,1575}]};

get_research_cfg(1,36) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{5,1620}]};

get_research_cfg(1,37) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{5,1665}]};

get_research_cfg(1,38) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{5,1710}]};

get_research_cfg(1,39) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{5,1755}]};

get_research_cfg(1,40) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{5,1800}]};

get_research_cfg(1,41) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{5,1845}]};

get_research_cfg(1,42) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{5,1890}]};

get_research_cfg(1,43) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{5,1935}]};

get_research_cfg(1,44) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{5,1980}]};

get_research_cfg(1,45) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{5,2025}]};

get_research_cfg(1,46) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{5,2070}]};

get_research_cfg(1,47) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{5,2115}]};

get_research_cfg(1,48) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{5,2160}]};

get_research_cfg(1,49) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{5,2205}]};

get_research_cfg(1,50) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{5,2250}]};

get_research_cfg(1,51) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{5,2295}]};

get_research_cfg(1,52) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{5,2340}]};

get_research_cfg(1,53) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{5,2385}]};

get_research_cfg(1,54) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{5,2430}]};

get_research_cfg(1,55) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{5,2475}]};

get_research_cfg(1,56) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{5,2520}]};

get_research_cfg(1,57) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{5,2565}]};

get_research_cfg(1,58) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{5,2610}]};

get_research_cfg(1,59) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{5,2655}]};

get_research_cfg(1,60) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{5,2700}]};

get_research_cfg(1,61) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{5,2745}]};

get_research_cfg(1,62) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{5,2790}]};

get_research_cfg(1,63) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{5,2835}]};

get_research_cfg(1,64) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{5,2880}]};

get_research_cfg(1,65) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{5,2925}]};

get_research_cfg(1,66) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{5,2970}]};

get_research_cfg(1,67) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{5,3015}]};

get_research_cfg(1,68) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{5,3060}]};

get_research_cfg(1,69) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{5,3105}]};

get_research_cfg(1,70) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{5,3150}]};

get_research_cfg(1,71) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{5,3195}]};

get_research_cfg(1,72) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{5,3240}]};

get_research_cfg(1,73) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{5,3285}]};

get_research_cfg(1,74) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{5,3330}]};

get_research_cfg(1,75) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{5,3375}]};

get_research_cfg(1,76) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{5,3420}]};

get_research_cfg(1,77) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{5,3465}]};

get_research_cfg(1,78) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{5,3510}]};

get_research_cfg(1,79) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{5,3555}]};

get_research_cfg(1,80) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{5,3600}]};

get_research_cfg(1,81) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{5,3645}]};

get_research_cfg(1,82) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{5,3690}]};

get_research_cfg(1,83) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{5,3735}]};

get_research_cfg(1,84) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{5,3780}]};

get_research_cfg(1,85) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{5,3825}]};

get_research_cfg(1,86) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{5,3870}]};

get_research_cfg(1,87) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{5,3915}]};

get_research_cfg(1,88) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{5,3960}]};

get_research_cfg(1,89) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{5,4005}]};

get_research_cfg(1,90) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{5,4050}]};

get_research_cfg(1,91) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{5,4095}]};

get_research_cfg(1,92) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{5,4140}]};

get_research_cfg(1,93) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{5,4185}]};

get_research_cfg(1,94) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{5,4230}]};

get_research_cfg(1,95) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{5,4275}]};

get_research_cfg(1,96) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{5,4320}]};

get_research_cfg(1,97) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{5,4365}]};

get_research_cfg(1,98) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{5,4410}]};

get_research_cfg(1,99) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{5,4455}]};

get_research_cfg(1,100) ->
	#guild_skill_research_cfg{skill_id = 1,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{5,4500}]};

get_research_cfg(2,0) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{6,0}]};

get_research_cfg(2,1) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{6,45}]};

get_research_cfg(2,2) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{6,90}]};

get_research_cfg(2,3) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{6,135}]};

get_research_cfg(2,4) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{6,180}]};

get_research_cfg(2,5) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{6,225}]};

get_research_cfg(2,6) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{6,270}]};

get_research_cfg(2,7) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{6,315}]};

get_research_cfg(2,8) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{6,360}]};

get_research_cfg(2,9) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{6,405}]};

get_research_cfg(2,10) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{6,450}]};

get_research_cfg(2,11) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{6,495}]};

get_research_cfg(2,12) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{6,540}]};

get_research_cfg(2,13) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{6,585}]};

get_research_cfg(2,14) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{6,630}]};

get_research_cfg(2,15) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{6,675}]};

get_research_cfg(2,16) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{6,720}]};

get_research_cfg(2,17) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{6,765}]};

get_research_cfg(2,18) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{6,810}]};

get_research_cfg(2,19) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{6,855}]};

get_research_cfg(2,20) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{6,900}]};

get_research_cfg(2,21) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{6,945}]};

get_research_cfg(2,22) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{6,990}]};

get_research_cfg(2,23) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{6,1035}]};

get_research_cfg(2,24) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{6,1080}]};

get_research_cfg(2,25) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{6,1125}]};

get_research_cfg(2,26) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{6,1170}]};

get_research_cfg(2,27) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{6,1215}]};

get_research_cfg(2,28) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{6,1260}]};

get_research_cfg(2,29) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{6,1305}]};

get_research_cfg(2,30) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{6,1350}]};

get_research_cfg(2,31) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{6,1395}]};

get_research_cfg(2,32) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{6,1440}]};

get_research_cfg(2,33) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{6,1485}]};

get_research_cfg(2,34) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{6,1530}]};

get_research_cfg(2,35) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{6,1575}]};

get_research_cfg(2,36) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{6,1620}]};

get_research_cfg(2,37) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{6,1665}]};

get_research_cfg(2,38) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{6,1710}]};

get_research_cfg(2,39) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{6,1755}]};

get_research_cfg(2,40) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{6,1800}]};

get_research_cfg(2,41) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{6,1845}]};

get_research_cfg(2,42) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{6,1890}]};

get_research_cfg(2,43) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{6,1935}]};

get_research_cfg(2,44) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{6,1980}]};

get_research_cfg(2,45) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{6,2025}]};

get_research_cfg(2,46) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{6,2070}]};

get_research_cfg(2,47) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{6,2115}]};

get_research_cfg(2,48) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{6,2160}]};

get_research_cfg(2,49) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{6,2205}]};

get_research_cfg(2,50) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{6,2250}]};

get_research_cfg(2,51) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{6,2295}]};

get_research_cfg(2,52) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{6,2340}]};

get_research_cfg(2,53) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{6,2385}]};

get_research_cfg(2,54) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{6,2430}]};

get_research_cfg(2,55) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{6,2475}]};

get_research_cfg(2,56) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{6,2520}]};

get_research_cfg(2,57) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{6,2565}]};

get_research_cfg(2,58) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{6,2610}]};

get_research_cfg(2,59) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{6,2655}]};

get_research_cfg(2,60) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{6,2700}]};

get_research_cfg(2,61) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{6,2745}]};

get_research_cfg(2,62) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{6,2790}]};

get_research_cfg(2,63) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{6,2835}]};

get_research_cfg(2,64) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{6,2880}]};

get_research_cfg(2,65) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{6,2925}]};

get_research_cfg(2,66) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{6,2970}]};

get_research_cfg(2,67) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{6,3015}]};

get_research_cfg(2,68) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{6,3060}]};

get_research_cfg(2,69) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{6,3105}]};

get_research_cfg(2,70) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{6,3150}]};

get_research_cfg(2,71) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{6,3195}]};

get_research_cfg(2,72) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{6,3240}]};

get_research_cfg(2,73) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{6,3285}]};

get_research_cfg(2,74) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{6,3330}]};

get_research_cfg(2,75) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{6,3375}]};

get_research_cfg(2,76) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{6,3420}]};

get_research_cfg(2,77) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{6,3465}]};

get_research_cfg(2,78) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{6,3510}]};

get_research_cfg(2,79) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{6,3555}]};

get_research_cfg(2,80) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{6,3600}]};

get_research_cfg(2,81) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{6,3645}]};

get_research_cfg(2,82) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{6,3690}]};

get_research_cfg(2,83) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{6,3735}]};

get_research_cfg(2,84) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{6,3780}]};

get_research_cfg(2,85) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{6,3825}]};

get_research_cfg(2,86) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{6,3870}]};

get_research_cfg(2,87) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{6,3915}]};

get_research_cfg(2,88) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{6,3960}]};

get_research_cfg(2,89) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{6,4005}]};

get_research_cfg(2,90) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{6,4050}]};

get_research_cfg(2,91) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{6,4095}]};

get_research_cfg(2,92) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{6,4140}]};

get_research_cfg(2,93) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{6,4185}]};

get_research_cfg(2,94) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{6,4230}]};

get_research_cfg(2,95) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{6,4275}]};

get_research_cfg(2,96) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{6,4320}]};

get_research_cfg(2,97) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{6,4365}]};

get_research_cfg(2,98) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{6,4410}]};

get_research_cfg(2,99) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{6,4455}]};

get_research_cfg(2,100) ->
	#guild_skill_research_cfg{skill_id = 2,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{6,4500}]};

get_research_cfg(3,0) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{7,0}]};

get_research_cfg(3,1) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{7,45}]};

get_research_cfg(3,2) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{7,90}]};

get_research_cfg(3,3) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{7,135}]};

get_research_cfg(3,4) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{7,180}]};

get_research_cfg(3,5) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{7,225}]};

get_research_cfg(3,6) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{7,270}]};

get_research_cfg(3,7) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{7,315}]};

get_research_cfg(3,8) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{7,360}]};

get_research_cfg(3,9) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{7,405}]};

get_research_cfg(3,10) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{7,450}]};

get_research_cfg(3,11) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{7,495}]};

get_research_cfg(3,12) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{7,540}]};

get_research_cfg(3,13) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{7,585}]};

get_research_cfg(3,14) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{7,630}]};

get_research_cfg(3,15) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{7,675}]};

get_research_cfg(3,16) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{7,720}]};

get_research_cfg(3,17) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{7,765}]};

get_research_cfg(3,18) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{7,810}]};

get_research_cfg(3,19) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{7,855}]};

get_research_cfg(3,20) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{7,900}]};

get_research_cfg(3,21) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{7,945}]};

get_research_cfg(3,22) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{7,990}]};

get_research_cfg(3,23) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{7,1035}]};

get_research_cfg(3,24) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{7,1080}]};

get_research_cfg(3,25) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{7,1125}]};

get_research_cfg(3,26) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{7,1170}]};

get_research_cfg(3,27) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{7,1215}]};

get_research_cfg(3,28) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{7,1260}]};

get_research_cfg(3,29) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{7,1305}]};

get_research_cfg(3,30) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{7,1350}]};

get_research_cfg(3,31) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{7,1395}]};

get_research_cfg(3,32) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{7,1440}]};

get_research_cfg(3,33) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{7,1485}]};

get_research_cfg(3,34) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{7,1530}]};

get_research_cfg(3,35) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{7,1575}]};

get_research_cfg(3,36) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{7,1620}]};

get_research_cfg(3,37) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{7,1665}]};

get_research_cfg(3,38) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{7,1710}]};

get_research_cfg(3,39) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{7,1755}]};

get_research_cfg(3,40) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{7,1800}]};

get_research_cfg(3,41) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{7,1845}]};

get_research_cfg(3,42) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{7,1890}]};

get_research_cfg(3,43) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{7,1935}]};

get_research_cfg(3,44) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{7,1980}]};

get_research_cfg(3,45) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{7,2025}]};

get_research_cfg(3,46) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{7,2070}]};

get_research_cfg(3,47) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{7,2115}]};

get_research_cfg(3,48) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{7,2160}]};

get_research_cfg(3,49) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{7,2205}]};

get_research_cfg(3,50) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{7,2250}]};

get_research_cfg(3,51) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{7,2295}]};

get_research_cfg(3,52) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{7,2340}]};

get_research_cfg(3,53) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{7,2385}]};

get_research_cfg(3,54) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{7,2430}]};

get_research_cfg(3,55) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{7,2475}]};

get_research_cfg(3,56) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{7,2520}]};

get_research_cfg(3,57) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{7,2565}]};

get_research_cfg(3,58) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{7,2610}]};

get_research_cfg(3,59) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{7,2655}]};

get_research_cfg(3,60) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{7,2700}]};

get_research_cfg(3,61) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{7,2745}]};

get_research_cfg(3,62) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{7,2790}]};

get_research_cfg(3,63) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{7,2835}]};

get_research_cfg(3,64) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{7,2880}]};

get_research_cfg(3,65) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{7,2925}]};

get_research_cfg(3,66) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{7,2970}]};

get_research_cfg(3,67) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{7,3015}]};

get_research_cfg(3,68) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{7,3060}]};

get_research_cfg(3,69) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{7,3105}]};

get_research_cfg(3,70) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{7,3150}]};

get_research_cfg(3,71) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{7,3195}]};

get_research_cfg(3,72) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{7,3240}]};

get_research_cfg(3,73) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{7,3285}]};

get_research_cfg(3,74) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{7,3330}]};

get_research_cfg(3,75) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{7,3375}]};

get_research_cfg(3,76) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{7,3420}]};

get_research_cfg(3,77) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{7,3465}]};

get_research_cfg(3,78) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{7,3510}]};

get_research_cfg(3,79) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{7,3555}]};

get_research_cfg(3,80) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{7,3600}]};

get_research_cfg(3,81) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{7,3645}]};

get_research_cfg(3,82) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{7,3690}]};

get_research_cfg(3,83) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{7,3735}]};

get_research_cfg(3,84) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{7,3780}]};

get_research_cfg(3,85) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{7,3825}]};

get_research_cfg(3,86) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{7,3870}]};

get_research_cfg(3,87) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{7,3915}]};

get_research_cfg(3,88) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{7,3960}]};

get_research_cfg(3,89) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{7,4005}]};

get_research_cfg(3,90) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{7,4050}]};

get_research_cfg(3,91) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{7,4095}]};

get_research_cfg(3,92) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{7,4140}]};

get_research_cfg(3,93) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{7,4185}]};

get_research_cfg(3,94) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{7,4230}]};

get_research_cfg(3,95) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{7,4275}]};

get_research_cfg(3,96) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{7,4320}]};

get_research_cfg(3,97) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{7,4365}]};

get_research_cfg(3,98) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{7,4410}]};

get_research_cfg(3,99) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{7,4455}]};

get_research_cfg(3,100) ->
	#guild_skill_research_cfg{skill_id = 3,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{7,4500}]};

get_research_cfg(4,0) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{8,0}]};

get_research_cfg(4,1) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{8,45}]};

get_research_cfg(4,2) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{8,90}]};

get_research_cfg(4,3) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{8,135}]};

get_research_cfg(4,4) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{8,180}]};

get_research_cfg(4,5) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{8,225}]};

get_research_cfg(4,6) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{8,270}]};

get_research_cfg(4,7) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{8,315}]};

get_research_cfg(4,8) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{8,360}]};

get_research_cfg(4,9) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{8,405}]};

get_research_cfg(4,10) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{8,450}]};

get_research_cfg(4,11) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{8,495}]};

get_research_cfg(4,12) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{8,540}]};

get_research_cfg(4,13) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{8,585}]};

get_research_cfg(4,14) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{8,630}]};

get_research_cfg(4,15) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{8,675}]};

get_research_cfg(4,16) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{8,720}]};

get_research_cfg(4,17) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{8,765}]};

get_research_cfg(4,18) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{8,810}]};

get_research_cfg(4,19) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{8,855}]};

get_research_cfg(4,20) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{8,900}]};

get_research_cfg(4,21) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{8,945}]};

get_research_cfg(4,22) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{8,990}]};

get_research_cfg(4,23) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{8,1035}]};

get_research_cfg(4,24) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{8,1080}]};

get_research_cfg(4,25) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{8,1125}]};

get_research_cfg(4,26) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{8,1170}]};

get_research_cfg(4,27) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{8,1215}]};

get_research_cfg(4,28) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{8,1260}]};

get_research_cfg(4,29) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{8,1305}]};

get_research_cfg(4,30) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{8,1350}]};

get_research_cfg(4,31) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{8,1395}]};

get_research_cfg(4,32) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{8,1440}]};

get_research_cfg(4,33) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{8,1485}]};

get_research_cfg(4,34) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{8,1530}]};

get_research_cfg(4,35) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{8,1575}]};

get_research_cfg(4,36) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{8,1620}]};

get_research_cfg(4,37) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{8,1665}]};

get_research_cfg(4,38) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{8,1710}]};

get_research_cfg(4,39) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{8,1755}]};

get_research_cfg(4,40) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{8,1800}]};

get_research_cfg(4,41) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{8,1845}]};

get_research_cfg(4,42) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{8,1890}]};

get_research_cfg(4,43) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{8,1935}]};

get_research_cfg(4,44) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{8,1980}]};

get_research_cfg(4,45) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{8,2025}]};

get_research_cfg(4,46) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{8,2070}]};

get_research_cfg(4,47) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{8,2115}]};

get_research_cfg(4,48) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{8,2160}]};

get_research_cfg(4,49) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{8,2205}]};

get_research_cfg(4,50) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{8,2250}]};

get_research_cfg(4,51) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{8,2295}]};

get_research_cfg(4,52) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{8,2340}]};

get_research_cfg(4,53) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{8,2385}]};

get_research_cfg(4,54) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{8,2430}]};

get_research_cfg(4,55) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{8,2475}]};

get_research_cfg(4,56) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{8,2520}]};

get_research_cfg(4,57) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{8,2565}]};

get_research_cfg(4,58) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{8,2610}]};

get_research_cfg(4,59) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{8,2655}]};

get_research_cfg(4,60) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{8,2700}]};

get_research_cfg(4,61) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{8,2745}]};

get_research_cfg(4,62) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{8,2790}]};

get_research_cfg(4,63) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{8,2835}]};

get_research_cfg(4,64) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{8,2880}]};

get_research_cfg(4,65) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{8,2925}]};

get_research_cfg(4,66) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{8,2970}]};

get_research_cfg(4,67) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{8,3015}]};

get_research_cfg(4,68) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{8,3060}]};

get_research_cfg(4,69) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{8,3105}]};

get_research_cfg(4,70) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{8,3150}]};

get_research_cfg(4,71) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{8,3195}]};

get_research_cfg(4,72) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{8,3240}]};

get_research_cfg(4,73) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{8,3285}]};

get_research_cfg(4,74) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{8,3330}]};

get_research_cfg(4,75) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{8,3375}]};

get_research_cfg(4,76) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{8,3420}]};

get_research_cfg(4,77) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{8,3465}]};

get_research_cfg(4,78) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{8,3510}]};

get_research_cfg(4,79) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{8,3555}]};

get_research_cfg(4,80) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{8,3600}]};

get_research_cfg(4,81) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{8,3645}]};

get_research_cfg(4,82) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{8,3690}]};

get_research_cfg(4,83) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{8,3735}]};

get_research_cfg(4,84) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{8,3780}]};

get_research_cfg(4,85) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{8,3825}]};

get_research_cfg(4,86) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{8,3870}]};

get_research_cfg(4,87) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{8,3915}]};

get_research_cfg(4,88) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{8,3960}]};

get_research_cfg(4,89) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{8,4005}]};

get_research_cfg(4,90) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{8,4050}]};

get_research_cfg(4,91) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{8,4095}]};

get_research_cfg(4,92) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{8,4140}]};

get_research_cfg(4,93) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{8,4185}]};

get_research_cfg(4,94) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{8,4230}]};

get_research_cfg(4,95) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{8,4275}]};

get_research_cfg(4,96) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{8,4320}]};

get_research_cfg(4,97) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{8,4365}]};

get_research_cfg(4,98) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{8,4410}]};

get_research_cfg(4,99) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{8,4455}]};

get_research_cfg(4,100) ->
	#guild_skill_research_cfg{skill_id = 4,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{8,4500}]};

get_research_cfg(5,0) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{71,0}]};

get_research_cfg(5,1) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{71,1500}]};

get_research_cfg(5,2) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{71,3000}]};

get_research_cfg(5,3) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{71,4500}]};

get_research_cfg(5,4) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{71,6000}]};

get_research_cfg(5,5) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{71,7500}]};

get_research_cfg(5,6) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{71,9000}]};

get_research_cfg(5,7) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{71,10500}]};

get_research_cfg(5,8) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{71,12000}]};

get_research_cfg(5,9) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{71,13500}]};

get_research_cfg(5,10) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{71,15000}]};

get_research_cfg(5,11) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{71,16500}]};

get_research_cfg(5,12) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{71,18000}]};

get_research_cfg(5,13) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{71,19500}]};

get_research_cfg(5,14) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{71,21000}]};

get_research_cfg(5,15) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{71,22500}]};

get_research_cfg(5,16) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{71,24000}]};

get_research_cfg(5,17) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{71,25500}]};

get_research_cfg(5,18) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{71,27000}]};

get_research_cfg(5,19) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{71,28500}]};

get_research_cfg(5,20) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{71,30000}]};

get_research_cfg(5,21) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{71,31500}]};

get_research_cfg(5,22) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{71,33000}]};

get_research_cfg(5,23) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{71,34500}]};

get_research_cfg(5,24) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{71,36000}]};

get_research_cfg(5,25) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{71,37500}]};

get_research_cfg(5,26) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{71,39000}]};

get_research_cfg(5,27) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{71,40500}]};

get_research_cfg(5,28) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{71,42000}]};

get_research_cfg(5,29) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{71,43500}]};

get_research_cfg(5,30) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{71,45000}]};

get_research_cfg(5,31) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{71,46500}]};

get_research_cfg(5,32) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{71,48000}]};

get_research_cfg(5,33) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{71,49500}]};

get_research_cfg(5,34) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{71,51000}]};

get_research_cfg(5,35) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{71,52500}]};

get_research_cfg(5,36) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{71,54000}]};

get_research_cfg(5,37) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{71,55500}]};

get_research_cfg(5,38) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{71,57000}]};

get_research_cfg(5,39) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{71,58500}]};

get_research_cfg(5,40) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{71,60000}]};

get_research_cfg(5,41) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{71,61500}]};

get_research_cfg(5,42) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{71,63000}]};

get_research_cfg(5,43) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{71,64500}]};

get_research_cfg(5,44) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{71,66000}]};

get_research_cfg(5,45) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{71,67500}]};

get_research_cfg(5,46) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{71,69000}]};

get_research_cfg(5,47) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{71,70500}]};

get_research_cfg(5,48) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{71,72000}]};

get_research_cfg(5,49) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{71,73500}]};

get_research_cfg(5,50) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{71,75000}]};

get_research_cfg(5,51) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{71,76500}]};

get_research_cfg(5,52) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{71,78000}]};

get_research_cfg(5,53) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{71,79500}]};

get_research_cfg(5,54) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{71,81000}]};

get_research_cfg(5,55) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{71,82500}]};

get_research_cfg(5,56) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{71,84000}]};

get_research_cfg(5,57) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{71,85500}]};

get_research_cfg(5,58) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{71,87000}]};

get_research_cfg(5,59) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{71,88500}]};

get_research_cfg(5,60) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{71,90000}]};

get_research_cfg(5,61) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{71,91500}]};

get_research_cfg(5,62) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{71,93000}]};

get_research_cfg(5,63) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{71,94500}]};

get_research_cfg(5,64) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{71,96000}]};

get_research_cfg(5,65) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{71,97500}]};

get_research_cfg(5,66) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{71,99000}]};

get_research_cfg(5,67) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{71,100500}]};

get_research_cfg(5,68) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{71,102000}]};

get_research_cfg(5,69) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{71,103500}]};

get_research_cfg(5,70) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{71,105000}]};

get_research_cfg(5,71) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{71,106500}]};

get_research_cfg(5,72) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{71,108000}]};

get_research_cfg(5,73) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{71,109500}]};

get_research_cfg(5,74) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{71,111000}]};

get_research_cfg(5,75) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{71,112500}]};

get_research_cfg(5,76) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{71,114000}]};

get_research_cfg(5,77) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{71,115500}]};

get_research_cfg(5,78) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{71,117000}]};

get_research_cfg(5,79) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{71,118500}]};

get_research_cfg(5,80) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{71,120000}]};

get_research_cfg(5,81) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{71,121500}]};

get_research_cfg(5,82) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{71,123000}]};

get_research_cfg(5,83) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{71,124500}]};

get_research_cfg(5,84) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{71,126000}]};

get_research_cfg(5,85) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{71,127500}]};

get_research_cfg(5,86) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{71,129000}]};

get_research_cfg(5,87) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{71,130500}]};

get_research_cfg(5,88) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{71,132000}]};

get_research_cfg(5,89) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{71,133500}]};

get_research_cfg(5,90) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{71,135000}]};

get_research_cfg(5,91) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{71,136500}]};

get_research_cfg(5,92) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{71,138000}]};

get_research_cfg(5,93) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{71,139500}]};

get_research_cfg(5,94) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{71,141000}]};

get_research_cfg(5,95) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{71,142500}]};

get_research_cfg(5,96) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{71,144000}]};

get_research_cfg(5,97) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{71,145500}]};

get_research_cfg(5,98) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{71,147000}]};

get_research_cfg(5,99) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{71,148500}]};

get_research_cfg(5,100) ->
	#guild_skill_research_cfg{skill_id = 5,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{71,150000}]};

get_research_cfg(6,0) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{72,0}]};

get_research_cfg(6,1) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,500}],attr_list = [{72,1500}]};

get_research_cfg(6,2) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,525}],attr_list = [{72,3000}]};

get_research_cfg(6,3) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,550}],attr_list = [{72,4500}]};

get_research_cfg(6,4) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,580}],attr_list = [{72,6000}]};

get_research_cfg(6,5) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,610}],attr_list = [{72,7500}]};

get_research_cfg(6,6) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,640}],attr_list = [{72,9000}]};

get_research_cfg(6,7) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,670}],attr_list = [{72,10500}]};

get_research_cfg(6,8) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,705}],attr_list = [{72,12000}]};

get_research_cfg(6,9) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,740}],attr_list = [{72,13500}]};

get_research_cfg(6,10) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,775}],attr_list = [{72,15000}]};

get_research_cfg(6,11) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,815}],attr_list = [{72,16500}]};

get_research_cfg(6,12) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,855}],attr_list = [{72,18000}]};

get_research_cfg(6,13) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,900}],attr_list = [{72,19500}]};

get_research_cfg(6,14) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,945}],attr_list = [{72,21000}]};

get_research_cfg(6,15) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,990}],attr_list = [{72,22500}]};

get_research_cfg(6,16) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,1040}],attr_list = [{72,24000}]};

get_research_cfg(6,17) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,1090}],attr_list = [{72,25500}]};

get_research_cfg(6,18) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,1145}],attr_list = [{72,27000}]};

get_research_cfg(6,19) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,1200}],attr_list = [{72,28500}]};

get_research_cfg(6,20) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,1260}],attr_list = [{72,30000}]};

get_research_cfg(6,21) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,1325}],attr_list = [{72,31500}]};

get_research_cfg(6,22) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,1390}],attr_list = [{72,33000}]};

get_research_cfg(6,23) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,1460}],attr_list = [{72,34500}]};

get_research_cfg(6,24) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,1535}],attr_list = [{72,36000}]};

get_research_cfg(6,25) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,1610}],attr_list = [{72,37500}]};

get_research_cfg(6,26) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,1690}],attr_list = [{72,39000}]};

get_research_cfg(6,27) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,1775}],attr_list = [{72,40500}]};

get_research_cfg(6,28) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,1865}],attr_list = [{72,42000}]};

get_research_cfg(6,29) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,1960}],attr_list = [{72,43500}]};

get_research_cfg(6,30) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,2060}],attr_list = [{72,45000}]};

get_research_cfg(6,31) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,2165}],attr_list = [{72,46500}]};

get_research_cfg(6,32) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,2275}],attr_list = [{72,48000}]};

get_research_cfg(6,33) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,2390}],attr_list = [{72,49500}]};

get_research_cfg(6,34) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,2510}],attr_list = [{72,51000}]};

get_research_cfg(6,35) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,2635}],attr_list = [{72,52500}]};

get_research_cfg(6,36) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,2765}],attr_list = [{72,54000}]};

get_research_cfg(6,37) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,2905}],attr_list = [{72,55500}]};

get_research_cfg(6,38) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,3050}],attr_list = [{72,57000}]};

get_research_cfg(6,39) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,3205}],attr_list = [{72,58500}]};

get_research_cfg(6,40) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,3365}],attr_list = [{72,60000}]};

get_research_cfg(6,41) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,3535}],attr_list = [{72,61500}]};

get_research_cfg(6,42) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,3710}],attr_list = [{72,63000}]};

get_research_cfg(6,43) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,3895}],attr_list = [{72,64500}]};

get_research_cfg(6,44) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,4090}],attr_list = [{72,66000}]};

get_research_cfg(6,45) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,4295}],attr_list = [{72,67500}]};

get_research_cfg(6,46) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,4510}],attr_list = [{72,69000}]};

get_research_cfg(6,47) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,4735}],attr_list = [{72,70500}]};

get_research_cfg(6,48) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,4970}],attr_list = [{72,72000}]};

get_research_cfg(6,49) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,5220}],attr_list = [{72,73500}]};

get_research_cfg(6,50) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,5480}],attr_list = [{72,75000}]};

get_research_cfg(6,51) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,5755}],attr_list = [{72,76500}]};

get_research_cfg(6,52) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,6045}],attr_list = [{72,78000}]};

get_research_cfg(6,53) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,6345}],attr_list = [{72,79500}]};

get_research_cfg(6,54) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,6660}],attr_list = [{72,81000}]};

get_research_cfg(6,55) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,6995}],attr_list = [{72,82500}]};

get_research_cfg(6,56) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,7345}],attr_list = [{72,84000}]};

get_research_cfg(6,57) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,7710}],attr_list = [{72,85500}]};

get_research_cfg(6,58) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,8095}],attr_list = [{72,87000}]};

get_research_cfg(6,59) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,8500}],attr_list = [{72,88500}]};

get_research_cfg(6,60) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,8925}],attr_list = [{72,90000}]};

get_research_cfg(6,61) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,9370}],attr_list = [{72,91500}]};

get_research_cfg(6,62) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,9840}],attr_list = [{72,93000}]};

get_research_cfg(6,63) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,10330}],attr_list = [{72,94500}]};

get_research_cfg(6,64) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,10845}],attr_list = [{72,96000}]};

get_research_cfg(6,65) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,11385}],attr_list = [{72,97500}]};

get_research_cfg(6,66) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,11955}],attr_list = [{72,99000}]};

get_research_cfg(6,67) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,12555}],attr_list = [{72,100500}]};

get_research_cfg(6,68) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,13185}],attr_list = [{72,102000}]};

get_research_cfg(6,69) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,13845}],attr_list = [{72,103500}]};

get_research_cfg(6,70) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,14535}],attr_list = [{72,105000}]};

get_research_cfg(6,71) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,15260}],attr_list = [{72,106500}]};

get_research_cfg(6,72) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,16025}],attr_list = [{72,108000}]};

get_research_cfg(6,73) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,16825}],attr_list = [{72,109500}]};

get_research_cfg(6,74) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,17665}],attr_list = [{72,111000}]};

get_research_cfg(6,75) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,18550}],attr_list = [{72,112500}]};

get_research_cfg(6,76) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,19480}],attr_list = [{72,114000}]};

get_research_cfg(6,77) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,20455}],attr_list = [{72,115500}]};

get_research_cfg(6,78) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,21480}],attr_list = [{72,117000}]};

get_research_cfg(6,79) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,22555}],attr_list = [{72,118500}]};

get_research_cfg(6,80) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,23685}],attr_list = [{72,120000}]};

get_research_cfg(6,81) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,24870}],attr_list = [{72,121500}]};

get_research_cfg(6,82) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,26115}],attr_list = [{72,123000}]};

get_research_cfg(6,83) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,27420}],attr_list = [{72,124500}]};

get_research_cfg(6,84) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,28790}],attr_list = [{72,126000}]};

get_research_cfg(6,85) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,30230}],attr_list = [{72,127500}]};

get_research_cfg(6,86) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,31740}],attr_list = [{72,129000}]};

get_research_cfg(6,87) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,33325}],attr_list = [{72,130500}]};

get_research_cfg(6,88) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,34990}],attr_list = [{72,132000}]};

get_research_cfg(6,89) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,36740}],attr_list = [{72,133500}]};

get_research_cfg(6,90) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,38575}],attr_list = [{72,135000}]};

get_research_cfg(6,91) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,40505}],attr_list = [{72,136500}]};

get_research_cfg(6,92) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,42530}],attr_list = [{72,138000}]};

get_research_cfg(6,93) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,44655}],attr_list = [{72,139500}]};

get_research_cfg(6,94) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,46890}],attr_list = [{72,141000}]};

get_research_cfg(6,95) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,49235}],attr_list = [{72,142500}]};

get_research_cfg(6,96) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,51695}],attr_list = [{72,144000}]};

get_research_cfg(6,97) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,54280}],attr_list = [{72,145500}]};

get_research_cfg(6,98) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,56995}],attr_list = [{72,147000}]};

get_research_cfg(6,99) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,59845}],attr_list = [{72,148500}]};

get_research_cfg(6,100) ->
	#guild_skill_research_cfg{skill_id = 6,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,62835}],attr_list = [{72,150000}]};

get_research_cfg(7,0) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{69,0}]};

get_research_cfg(7,1) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,1000}],attr_list = [{69,1500}]};

get_research_cfg(7,2) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,1050}],attr_list = [{69,3000}]};

get_research_cfg(7,3) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,1100}],attr_list = [{69,4500}]};

get_research_cfg(7,4) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,1160}],attr_list = [{69,6000}]};

get_research_cfg(7,5) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,1220}],attr_list = [{69,7500}]};

get_research_cfg(7,6) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,1280}],attr_list = [{69,9000}]};

get_research_cfg(7,7) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,1340}],attr_list = [{69,10500}]};

get_research_cfg(7,8) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,1410}],attr_list = [{69,12000}]};

get_research_cfg(7,9) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,1480}],attr_list = [{69,13500}]};

get_research_cfg(7,10) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,1550}],attr_list = [{69,15000}]};

get_research_cfg(7,11) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,1630}],attr_list = [{69,16500}]};

get_research_cfg(7,12) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,1710}],attr_list = [{69,18000}]};

get_research_cfg(7,13) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,1800}],attr_list = [{69,19500}]};

get_research_cfg(7,14) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,1890}],attr_list = [{69,21000}]};

get_research_cfg(7,15) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,1980}],attr_list = [{69,22500}]};

get_research_cfg(7,16) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,2080}],attr_list = [{69,24000}]};

get_research_cfg(7,17) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,2180}],attr_list = [{69,25500}]};

get_research_cfg(7,18) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,2290}],attr_list = [{69,27000}]};

get_research_cfg(7,19) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,2400}],attr_list = [{69,28500}]};

get_research_cfg(7,20) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,2520}],attr_list = [{69,30000}]};

get_research_cfg(7,21) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,2650}],attr_list = [{69,31500}]};

get_research_cfg(7,22) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,2780}],attr_list = [{69,33000}]};

get_research_cfg(7,23) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,2920}],attr_list = [{69,34500}]};

get_research_cfg(7,24) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,3070}],attr_list = [{69,36000}]};

get_research_cfg(7,25) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,3220}],attr_list = [{69,37500}]};

get_research_cfg(7,26) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,3380}],attr_list = [{69,39000}]};

get_research_cfg(7,27) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,3550}],attr_list = [{69,40500}]};

get_research_cfg(7,28) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,3730}],attr_list = [{69,42000}]};

get_research_cfg(7,29) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,3920}],attr_list = [{69,43500}]};

get_research_cfg(7,30) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,4120}],attr_list = [{69,45000}]};

get_research_cfg(7,31) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,4330}],attr_list = [{69,46500}]};

get_research_cfg(7,32) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,4550}],attr_list = [{69,48000}]};

get_research_cfg(7,33) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,4780}],attr_list = [{69,49500}]};

get_research_cfg(7,34) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,5020}],attr_list = [{69,51000}]};

get_research_cfg(7,35) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,5270}],attr_list = [{69,52500}]};

get_research_cfg(7,36) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,5530}],attr_list = [{69,54000}]};

get_research_cfg(7,37) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,5810}],attr_list = [{69,55500}]};

get_research_cfg(7,38) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,6100}],attr_list = [{69,57000}]};

get_research_cfg(7,39) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,6410}],attr_list = [{69,58500}]};

get_research_cfg(7,40) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,6730}],attr_list = [{69,60000}]};

get_research_cfg(7,41) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,7070}],attr_list = [{69,61500}]};

get_research_cfg(7,42) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,7420}],attr_list = [{69,63000}]};

get_research_cfg(7,43) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,7790}],attr_list = [{69,64500}]};

get_research_cfg(7,44) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,8180}],attr_list = [{69,66000}]};

get_research_cfg(7,45) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,8590}],attr_list = [{69,67500}]};

get_research_cfg(7,46) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,9020}],attr_list = [{69,69000}]};

get_research_cfg(7,47) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,9470}],attr_list = [{69,70500}]};

get_research_cfg(7,48) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,9940}],attr_list = [{69,72000}]};

get_research_cfg(7,49) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,10440}],attr_list = [{69,73500}]};

get_research_cfg(7,50) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,10960}],attr_list = [{69,75000}]};

get_research_cfg(7,51) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,11510}],attr_list = [{69,76500}]};

get_research_cfg(7,52) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,12090}],attr_list = [{69,78000}]};

get_research_cfg(7,53) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,12690}],attr_list = [{69,79500}]};

get_research_cfg(7,54) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,13320}],attr_list = [{69,81000}]};

get_research_cfg(7,55) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,13990}],attr_list = [{69,82500}]};

get_research_cfg(7,56) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,14690}],attr_list = [{69,84000}]};

get_research_cfg(7,57) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,15420}],attr_list = [{69,85500}]};

get_research_cfg(7,58) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,16190}],attr_list = [{69,87000}]};

get_research_cfg(7,59) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,17000}],attr_list = [{69,88500}]};

get_research_cfg(7,60) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,17850}],attr_list = [{69,90000}]};

get_research_cfg(7,61) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,18740}],attr_list = [{69,91500}]};

get_research_cfg(7,62) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,19680}],attr_list = [{69,93000}]};

get_research_cfg(7,63) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,20660}],attr_list = [{69,94500}]};

get_research_cfg(7,64) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,21690}],attr_list = [{69,96000}]};

get_research_cfg(7,65) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,22770}],attr_list = [{69,97500}]};

get_research_cfg(7,66) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,23910}],attr_list = [{69,99000}]};

get_research_cfg(7,67) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,25110}],attr_list = [{69,100500}]};

get_research_cfg(7,68) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,26370}],attr_list = [{69,102000}]};

get_research_cfg(7,69) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,27690}],attr_list = [{69,103500}]};

get_research_cfg(7,70) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,29070}],attr_list = [{69,105000}]};

get_research_cfg(7,71) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,30520}],attr_list = [{69,106500}]};

get_research_cfg(7,72) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,32050}],attr_list = [{69,108000}]};

get_research_cfg(7,73) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,33650}],attr_list = [{69,109500}]};

get_research_cfg(7,74) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,35330}],attr_list = [{69,111000}]};

get_research_cfg(7,75) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,37100}],attr_list = [{69,112500}]};

get_research_cfg(7,76) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,38960}],attr_list = [{69,114000}]};

get_research_cfg(7,77) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,40910}],attr_list = [{69,115500}]};

get_research_cfg(7,78) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,42960}],attr_list = [{69,117000}]};

get_research_cfg(7,79) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,45110}],attr_list = [{69,118500}]};

get_research_cfg(7,80) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,47370}],attr_list = [{69,120000}]};

get_research_cfg(7,81) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,49740}],attr_list = [{69,121500}]};

get_research_cfg(7,82) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,52230}],attr_list = [{69,123000}]};

get_research_cfg(7,83) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,54840}],attr_list = [{69,124500}]};

get_research_cfg(7,84) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,57580}],attr_list = [{69,126000}]};

get_research_cfg(7,85) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,60460}],attr_list = [{69,127500}]};

get_research_cfg(7,86) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,63480}],attr_list = [{69,129000}]};

get_research_cfg(7,87) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,66650}],attr_list = [{69,130500}]};

get_research_cfg(7,88) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,69980}],attr_list = [{69,132000}]};

get_research_cfg(7,89) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,73480}],attr_list = [{69,133500}]};

get_research_cfg(7,90) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,77150}],attr_list = [{69,135000}]};

get_research_cfg(7,91) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,81010}],attr_list = [{69,136500}]};

get_research_cfg(7,92) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,85060}],attr_list = [{69,138000}]};

get_research_cfg(7,93) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,89310}],attr_list = [{69,139500}]};

get_research_cfg(7,94) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,93780}],attr_list = [{69,141000}]};

get_research_cfg(7,95) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,98470}],attr_list = [{69,142500}]};

get_research_cfg(7,96) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,103390}],attr_list = [{69,144000}]};

get_research_cfg(7,97) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,108560}],attr_list = [{69,145500}]};

get_research_cfg(7,98) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,113990}],attr_list = [{69,147000}]};

get_research_cfg(7,99) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,119690}],attr_list = [{69,148500}]};

get_research_cfg(7,100) ->
	#guild_skill_research_cfg{skill_id = 7,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,125670}],attr_list = [{69,150000}]};

get_research_cfg(8,0) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 0,research_cost = [{funds,0}],learn_cost = [{guild_donate,0}],attr_list = [{70,0}]};

get_research_cfg(8,1) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 1,research_cost = [{funds,0}],learn_cost = [{guild_donate,1000}],attr_list = [{70,1500}]};

get_research_cfg(8,2) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 2,research_cost = [{funds,0}],learn_cost = [{guild_donate,1050}],attr_list = [{70,3000}]};

get_research_cfg(8,3) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 3,research_cost = [{funds,0}],learn_cost = [{guild_donate,1100}],attr_list = [{70,4500}]};

get_research_cfg(8,4) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 4,research_cost = [{funds,0}],learn_cost = [{guild_donate,1160}],attr_list = [{70,6000}]};

get_research_cfg(8,5) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 5,research_cost = [{funds,0}],learn_cost = [{guild_donate,1220}],attr_list = [{70,7500}]};

get_research_cfg(8,6) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 6,research_cost = [{funds,0}],learn_cost = [{guild_donate,1280}],attr_list = [{70,9000}]};

get_research_cfg(8,7) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 7,research_cost = [{funds,0}],learn_cost = [{guild_donate,1340}],attr_list = [{70,10500}]};

get_research_cfg(8,8) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 8,research_cost = [{funds,0}],learn_cost = [{guild_donate,1410}],attr_list = [{70,12000}]};

get_research_cfg(8,9) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 9,research_cost = [{funds,0}],learn_cost = [{guild_donate,1480}],attr_list = [{70,13500}]};

get_research_cfg(8,10) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 10,research_cost = [{funds,0}],learn_cost = [{guild_donate,1550}],attr_list = [{70,15000}]};

get_research_cfg(8,11) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 11,research_cost = [{funds,0}],learn_cost = [{guild_donate,1630}],attr_list = [{70,16500}]};

get_research_cfg(8,12) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 12,research_cost = [{funds,0}],learn_cost = [{guild_donate,1710}],attr_list = [{70,18000}]};

get_research_cfg(8,13) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 13,research_cost = [{funds,0}],learn_cost = [{guild_donate,1800}],attr_list = [{70,19500}]};

get_research_cfg(8,14) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 14,research_cost = [{funds,0}],learn_cost = [{guild_donate,1890}],attr_list = [{70,21000}]};

get_research_cfg(8,15) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 15,research_cost = [{funds,0}],learn_cost = [{guild_donate,1980}],attr_list = [{70,22500}]};

get_research_cfg(8,16) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 16,research_cost = [{funds,0}],learn_cost = [{guild_donate,2080}],attr_list = [{70,24000}]};

get_research_cfg(8,17) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 17,research_cost = [{funds,0}],learn_cost = [{guild_donate,2180}],attr_list = [{70,25500}]};

get_research_cfg(8,18) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 18,research_cost = [{funds,0}],learn_cost = [{guild_donate,2290}],attr_list = [{70,27000}]};

get_research_cfg(8,19) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 19,research_cost = [{funds,0}],learn_cost = [{guild_donate,2400}],attr_list = [{70,28500}]};

get_research_cfg(8,20) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 20,research_cost = [{funds,0}],learn_cost = [{guild_donate,2520}],attr_list = [{70,30000}]};

get_research_cfg(8,21) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 21,research_cost = [{funds,0}],learn_cost = [{guild_donate,2650}],attr_list = [{70,31500}]};

get_research_cfg(8,22) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 22,research_cost = [{funds,0}],learn_cost = [{guild_donate,2780}],attr_list = [{70,33000}]};

get_research_cfg(8,23) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 23,research_cost = [{funds,0}],learn_cost = [{guild_donate,2920}],attr_list = [{70,34500}]};

get_research_cfg(8,24) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 24,research_cost = [{funds,0}],learn_cost = [{guild_donate,3070}],attr_list = [{70,36000}]};

get_research_cfg(8,25) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 25,research_cost = [{funds,0}],learn_cost = [{guild_donate,3220}],attr_list = [{70,37500}]};

get_research_cfg(8,26) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 26,research_cost = [{funds,0}],learn_cost = [{guild_donate,3380}],attr_list = [{70,39000}]};

get_research_cfg(8,27) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 27,research_cost = [{funds,0}],learn_cost = [{guild_donate,3550}],attr_list = [{70,40500}]};

get_research_cfg(8,28) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 28,research_cost = [{funds,0}],learn_cost = [{guild_donate,3730}],attr_list = [{70,42000}]};

get_research_cfg(8,29) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 29,research_cost = [{funds,0}],learn_cost = [{guild_donate,3920}],attr_list = [{70,43500}]};

get_research_cfg(8,30) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 30,research_cost = [{funds,0}],learn_cost = [{guild_donate,4120}],attr_list = [{70,45000}]};

get_research_cfg(8,31) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 31,research_cost = [{funds,0}],learn_cost = [{guild_donate,4330}],attr_list = [{70,46500}]};

get_research_cfg(8,32) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 32,research_cost = [{funds,0}],learn_cost = [{guild_donate,4550}],attr_list = [{70,48000}]};

get_research_cfg(8,33) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 33,research_cost = [{funds,0}],learn_cost = [{guild_donate,4780}],attr_list = [{70,49500}]};

get_research_cfg(8,34) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 34,research_cost = [{funds,0}],learn_cost = [{guild_donate,5020}],attr_list = [{70,51000}]};

get_research_cfg(8,35) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 35,research_cost = [{funds,0}],learn_cost = [{guild_donate,5270}],attr_list = [{70,52500}]};

get_research_cfg(8,36) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 36,research_cost = [{funds,0}],learn_cost = [{guild_donate,5530}],attr_list = [{70,54000}]};

get_research_cfg(8,37) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 37,research_cost = [{funds,0}],learn_cost = [{guild_donate,5810}],attr_list = [{70,55500}]};

get_research_cfg(8,38) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 38,research_cost = [{funds,0}],learn_cost = [{guild_donate,6100}],attr_list = [{70,57000}]};

get_research_cfg(8,39) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 39,research_cost = [{funds,0}],learn_cost = [{guild_donate,6410}],attr_list = [{70,58500}]};

get_research_cfg(8,40) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 40,research_cost = [{funds,0}],learn_cost = [{guild_donate,6730}],attr_list = [{70,60000}]};

get_research_cfg(8,41) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 41,research_cost = [{funds,0}],learn_cost = [{guild_donate,7070}],attr_list = [{70,61500}]};

get_research_cfg(8,42) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 42,research_cost = [{funds,0}],learn_cost = [{guild_donate,7420}],attr_list = [{70,63000}]};

get_research_cfg(8,43) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 43,research_cost = [{funds,0}],learn_cost = [{guild_donate,7790}],attr_list = [{70,64500}]};

get_research_cfg(8,44) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 44,research_cost = [{funds,0}],learn_cost = [{guild_donate,8180}],attr_list = [{70,66000}]};

get_research_cfg(8,45) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 45,research_cost = [{funds,0}],learn_cost = [{guild_donate,8590}],attr_list = [{70,67500}]};

get_research_cfg(8,46) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 46,research_cost = [{funds,0}],learn_cost = [{guild_donate,9020}],attr_list = [{70,69000}]};

get_research_cfg(8,47) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 47,research_cost = [{funds,0}],learn_cost = [{guild_donate,9470}],attr_list = [{70,70500}]};

get_research_cfg(8,48) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 48,research_cost = [{funds,0}],learn_cost = [{guild_donate,9940}],attr_list = [{70,72000}]};

get_research_cfg(8,49) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 49,research_cost = [{funds,0}],learn_cost = [{guild_donate,10440}],attr_list = [{70,73500}]};

get_research_cfg(8,50) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 50,research_cost = [{funds,0}],learn_cost = [{guild_donate,10960}],attr_list = [{70,75000}]};

get_research_cfg(8,51) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 51,research_cost = [{funds,0}],learn_cost = [{guild_donate,11510}],attr_list = [{70,76500}]};

get_research_cfg(8,52) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 52,research_cost = [{funds,0}],learn_cost = [{guild_donate,12090}],attr_list = [{70,78000}]};

get_research_cfg(8,53) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 53,research_cost = [{funds,0}],learn_cost = [{guild_donate,12690}],attr_list = [{70,79500}]};

get_research_cfg(8,54) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 54,research_cost = [{funds,0}],learn_cost = [{guild_donate,13320}],attr_list = [{70,81000}]};

get_research_cfg(8,55) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 55,research_cost = [{funds,0}],learn_cost = [{guild_donate,13990}],attr_list = [{70,82500}]};

get_research_cfg(8,56) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 56,research_cost = [{funds,0}],learn_cost = [{guild_donate,14690}],attr_list = [{70,84000}]};

get_research_cfg(8,57) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 57,research_cost = [{funds,0}],learn_cost = [{guild_donate,15420}],attr_list = [{70,85500}]};

get_research_cfg(8,58) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 58,research_cost = [{funds,0}],learn_cost = [{guild_donate,16190}],attr_list = [{70,87000}]};

get_research_cfg(8,59) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 59,research_cost = [{funds,0}],learn_cost = [{guild_donate,17000}],attr_list = [{70,88500}]};

get_research_cfg(8,60) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 60,research_cost = [{funds,0}],learn_cost = [{guild_donate,17850}],attr_list = [{70,90000}]};

get_research_cfg(8,61) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 61,research_cost = [{funds,0}],learn_cost = [{guild_donate,18740}],attr_list = [{70,91500}]};

get_research_cfg(8,62) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 62,research_cost = [{funds,0}],learn_cost = [{guild_donate,19680}],attr_list = [{70,93000}]};

get_research_cfg(8,63) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 63,research_cost = [{funds,0}],learn_cost = [{guild_donate,20660}],attr_list = [{70,94500}]};

get_research_cfg(8,64) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 64,research_cost = [{funds,0}],learn_cost = [{guild_donate,21690}],attr_list = [{70,96000}]};

get_research_cfg(8,65) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 65,research_cost = [{funds,0}],learn_cost = [{guild_donate,22770}],attr_list = [{70,97500}]};

get_research_cfg(8,66) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 66,research_cost = [{funds,0}],learn_cost = [{guild_donate,23910}],attr_list = [{70,99000}]};

get_research_cfg(8,67) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 67,research_cost = [{funds,0}],learn_cost = [{guild_donate,25110}],attr_list = [{70,100500}]};

get_research_cfg(8,68) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 68,research_cost = [{funds,0}],learn_cost = [{guild_donate,26370}],attr_list = [{70,102000}]};

get_research_cfg(8,69) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 69,research_cost = [{funds,0}],learn_cost = [{guild_donate,27690}],attr_list = [{70,103500}]};

get_research_cfg(8,70) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 70,research_cost = [{funds,0}],learn_cost = [{guild_donate,29070}],attr_list = [{70,105000}]};

get_research_cfg(8,71) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 71,research_cost = [{funds,0}],learn_cost = [{guild_donate,30520}],attr_list = [{70,106500}]};

get_research_cfg(8,72) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 72,research_cost = [{funds,0}],learn_cost = [{guild_donate,32050}],attr_list = [{70,108000}]};

get_research_cfg(8,73) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 73,research_cost = [{funds,0}],learn_cost = [{guild_donate,33650}],attr_list = [{70,109500}]};

get_research_cfg(8,74) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 74,research_cost = [{funds,0}],learn_cost = [{guild_donate,35330}],attr_list = [{70,111000}]};

get_research_cfg(8,75) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 75,research_cost = [{funds,0}],learn_cost = [{guild_donate,37100}],attr_list = [{70,112500}]};

get_research_cfg(8,76) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 76,research_cost = [{funds,0}],learn_cost = [{guild_donate,38960}],attr_list = [{70,114000}]};

get_research_cfg(8,77) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 77,research_cost = [{funds,0}],learn_cost = [{guild_donate,40910}],attr_list = [{70,115500}]};

get_research_cfg(8,78) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 78,research_cost = [{funds,0}],learn_cost = [{guild_donate,42960}],attr_list = [{70,117000}]};

get_research_cfg(8,79) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 79,research_cost = [{funds,0}],learn_cost = [{guild_donate,45110}],attr_list = [{70,118500}]};

get_research_cfg(8,80) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 80,research_cost = [{funds,0}],learn_cost = [{guild_donate,47370}],attr_list = [{70,120000}]};

get_research_cfg(8,81) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 81,research_cost = [{funds,0}],learn_cost = [{guild_donate,49740}],attr_list = [{70,121500}]};

get_research_cfg(8,82) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 82,research_cost = [{funds,0}],learn_cost = [{guild_donate,52230}],attr_list = [{70,123000}]};

get_research_cfg(8,83) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 83,research_cost = [{funds,0}],learn_cost = [{guild_donate,54840}],attr_list = [{70,124500}]};

get_research_cfg(8,84) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 84,research_cost = [{funds,0}],learn_cost = [{guild_donate,57580}],attr_list = [{70,126000}]};

get_research_cfg(8,85) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 85,research_cost = [{funds,0}],learn_cost = [{guild_donate,60460}],attr_list = [{70,127500}]};

get_research_cfg(8,86) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 86,research_cost = [{funds,0}],learn_cost = [{guild_donate,63480}],attr_list = [{70,129000}]};

get_research_cfg(8,87) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 87,research_cost = [{funds,0}],learn_cost = [{guild_donate,66650}],attr_list = [{70,130500}]};

get_research_cfg(8,88) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 88,research_cost = [{funds,0}],learn_cost = [{guild_donate,69980}],attr_list = [{70,132000}]};

get_research_cfg(8,89) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 89,research_cost = [{funds,0}],learn_cost = [{guild_donate,73480}],attr_list = [{70,133500}]};

get_research_cfg(8,90) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 90,research_cost = [{funds,0}],learn_cost = [{guild_donate,77150}],attr_list = [{70,135000}]};

get_research_cfg(8,91) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 91,research_cost = [{funds,0}],learn_cost = [{guild_donate,81010}],attr_list = [{70,136500}]};

get_research_cfg(8,92) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 92,research_cost = [{funds,0}],learn_cost = [{guild_donate,85060}],attr_list = [{70,138000}]};

get_research_cfg(8,93) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 93,research_cost = [{funds,0}],learn_cost = [{guild_donate,89310}],attr_list = [{70,139500}]};

get_research_cfg(8,94) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 94,research_cost = [{funds,0}],learn_cost = [{guild_donate,93780}],attr_list = [{70,141000}]};

get_research_cfg(8,95) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 95,research_cost = [{funds,0}],learn_cost = [{guild_donate,98470}],attr_list = [{70,142500}]};

get_research_cfg(8,96) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 96,research_cost = [{funds,0}],learn_cost = [{guild_donate,103390}],attr_list = [{70,144000}]};

get_research_cfg(8,97) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 97,research_cost = [{funds,0}],learn_cost = [{guild_donate,108560}],attr_list = [{70,145500}]};

get_research_cfg(8,98) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 98,research_cost = [{funds,0}],learn_cost = [{guild_donate,113990}],attr_list = [{70,147000}]};

get_research_cfg(8,99) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 99,research_cost = [{funds,0}],learn_cost = [{guild_donate,119690}],attr_list = [{70,148500}]};

get_research_cfg(8,100) ->
	#guild_skill_research_cfg{skill_id = 8,lv = 100,research_cost = [{funds,0}],learn_cost = [{guild_donate,125670}],attr_list = [{70,150000}]};

get_research_cfg(_Skillid,_Lv) ->
	[].

