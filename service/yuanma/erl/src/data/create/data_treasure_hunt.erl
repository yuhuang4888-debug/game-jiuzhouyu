%%%---------------------------------------
%%% module      : data_treasure_hunt
%%% description : 寻宝配置
%%%
%%%---------------------------------------
-module(data_treasure_hunt).
-compile(export_all).
-include("treasure_hunt.hrl").




get_cfg(equip_treasure_hunt_open_lv) ->
30;


get_cfg(peak_treasure_hunt_open_lv) ->
371;


get_cfg(extreme_treasure_hunt_open_lv) ->
500;


get_cfg(equip_treasure_hunt_cost) ->
36255007;


get_cfg(peak_treasure_hunt_cost) ->
36255008;


get_cfg(extreme_treasure_hunt_cost) ->
36255009;


get_cfg(equip_treasure_hunt_score) ->
1;


get_cfg(peak_treasure_hunt_score) ->
3;


get_cfg(extreme_treasure_hunt_score) ->
5;


get_cfg(person_treasure_hunt_record_len) ->
30;


get_cfg(qf_treasure_hunt_record_len) ->
20;


get_cfg(rune_treasure_hunt_open_lv) ->
47;


get_cfg(rune_treasure_hunt_cost) ->
36255006;


get_cfg(rune_treasure_hunt_super_chip) ->
[];


get_cfg(rune_treasure_hunt_chip) ->
[{15,0,[8,12]}];


get_cfg(rune_treasure_hunt_free_time) ->
86400;


get_cfg(equip_treasure_hunt_model) ->
416001;


get_cfg(peak_treasure_hunt_model) ->
416002;


get_cfg(extreme_treasure_hunt_model) ->
416003;


get_cfg(box_num) ->
5;


get_cfg(equip_treasure_hunt_free_time) ->
28800;


get_cfg(peak_treasure_hunt_free_time) ->
28800;


get_cfg(extreme_treasure_hunt_free_time) ->
28800;


get_cfg(equip_treasure_hunt_discount) ->
[{1,0},{10,9},{50,9}];


get_cfg(peak_treasure_hunt_discount) ->
[{1,0},{10,9},{50,9}];


get_cfg(extreme_treasure_hunt_discount) ->
[{1,0},{10,9},{50,9}];


get_cfg(rune_treasure_hunt_first) ->
{26020003,0,0};


get_cfg(rune_treasure_hunt_second_filter) ->
[26010003];


get_cfg(equip_hunt_max_luckey_value) ->
500;


get_cfg(equip_hunt_luckey_value_display) ->
[{1,29,10},{30,49,30},{50,99,50},{100,199,100},{200,299,200},{300,399,300},{400,499,400},{500,99999,500}];


get_cfg(rune_treasure_rare) ->
[{0,26260005,1},{0,26270005,1}];


get_cfg(luckey_value_clear_time) ->
2;


get_cfg(equip_treasure_luckey_value) ->
[{htype, [1,2]},{time, 30},{add_value, 1}];


get_cfg(kf_equip_hunt_max_luckey_value) ->
500;


get_cfg(kf_luckey_value_clear_time) ->
2;


get_cfg(kf_equip_hunt_luckey_value_display) ->
[{1,29,10},{30,49,30},{50,99,50},{100,199,100},{200,299,200},{300,399,300},{400,499,400},{500,99999,500}];


get_cfg(kf_equip_treasure_luckey_value) ->
[{htype, [1,2,3]},{time, 30},{add_value, 1}];


get_cfg(kf_use_kf_luckey_value) ->
8;


get_cfg(equip_client_round_count) ->
10;


get_cfg(kf_treasure_hunt_record_len) ->
30;


get_cfg(baby_treasure_hunt_open_lv) ->
305;


get_cfg(baby_treasure_hunt_cost) ->
36255037;


get_cfg(baby_treasure_hunt_discount) ->
[{1,0},{10,9}];


get_cfg(baby_treasure_hunt_free_time) ->
0;


get_cfg(treasure_hunt_add_luckey_value) ->
[{2,2},{3,2},{4,1}];


get_cfg(first_draw_reward) ->
[1121,1123];


get_cfg(rune_treasure_hunt_discount) ->
[{1,0},{10,9}];


get_cfg(rune_hunt_luckey_value_display) ->
[{1,4,1},{5,9,7},{10,14,13},{15,19,20},{20,24,27},{25,29,34},{30,34,41},{35,39,48},{40,44,55},{45,49,62},{50,54,69},{55,59,76},{60,64,83},{65,69,90},{70,74,100},{75,79,107},{80,84,114},{85,89,121},{90,94,128},{95,99,136},{100,104,144},{105,109,152},{110,114,160},{115,119,168},{120,124,176},{125,129,184},{130,134,192},{135,99999,200}];


get_cfg(rune_hunt_max_luckey_value) ->
135;


get_cfg(rune_hunt_ten_draw_item_id) ->
36255000;

get_cfg(_Key) ->
	0.

get_reward(1101) ->
	#treasure_hunt_reward_cfg{id = 1101,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 101,weight = {[{{1,85},0},{{86,348},40}],0},special = [{200,299,15},{300,399,15},{400,499,25},{500,9999,30}],goods_id = 20030001,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1102) ->
	#treasure_hunt_reward_cfg{id = 1102,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 101,weight = {[{{1,85},0},{{86,348},40}],0},special = [{200,299,15},{300,399,15},{400,499,25},{500,9999,30}],goods_id = 101074071,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1103) ->
	#treasure_hunt_reward_cfg{id = 1103,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 101,weight = {[{{1,85},0},{{86,348},25}],0},special = [{200,299,15},{300,399,15},{400,499,25},{500,9999,30}],goods_id = 101094071,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1104) ->
	#treasure_hunt_reward_cfg{id = 1104,min_rlv = 1,max_rlv = 219,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070008,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1105) ->
	#treasure_hunt_reward_cfg{id = 1105,min_rlv = 220,max_rlv = 269,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070009,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1106) ->
	#treasure_hunt_reward_cfg{id = 1106,min_rlv = 270,max_rlv = 319,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070010,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1107) ->
	#treasure_hunt_reward_cfg{id = 1107,min_rlv = 320,max_rlv = 369,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070011,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1108) ->
	#treasure_hunt_reward_cfg{id = 1108,min_rlv = 370,max_rlv = 419,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070012,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1109) ->
	#treasure_hunt_reward_cfg{id = 1109,min_rlv = 420,max_rlv = 469,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070013,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1110) ->
	#treasure_hunt_reward_cfg{id = 1110,min_rlv = 470,max_rlv = 519,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070014,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1111) ->
	#treasure_hunt_reward_cfg{id = 1111,min_rlv = 520,max_rlv = 569,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070015,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1112) ->
	#treasure_hunt_reward_cfg{id = 1112,min_rlv = 570,max_rlv = 619,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070016,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1113) ->
	#treasure_hunt_reward_cfg{id = 1113,min_rlv = 620,max_rlv = 669,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070017,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1114) ->
	#treasure_hunt_reward_cfg{id = 1114,min_rlv = 670,max_rlv = 719,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070018,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1115) ->
	#treasure_hunt_reward_cfg{id = 1115,min_rlv = 720,max_rlv = 9999,htype = 1,stype = 1,weight = 500,special = [],goods_id = 32070018,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1116) ->
	#treasure_hunt_reward_cfg{id = 1116,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = {30, 999999, 0, 400},special = [],goods_id = 12010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1117) ->
	#treasure_hunt_reward_cfg{id = 1117,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 500,special = [],goods_id = 5902004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1118) ->
	#treasure_hunt_reward_cfg{id = 1118,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 500,special = [],goods_id = 20010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1119) ->
	#treasure_hunt_reward_cfg{id = 1119,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 500,special = [],goods_id = 17010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1120) ->
	#treasure_hunt_reward_cfg{id = 1120,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 3000,special = [],goods_id = 20010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1121) ->
	#treasure_hunt_reward_cfg{id = 1121,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 3000,special = [],goods_id = 20010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1122) ->
	#treasure_hunt_reward_cfg{id = 1122,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 3000,special = [],goods_id = 17010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1123) ->
	#treasure_hunt_reward_cfg{id = 1123,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 3000,special = [],goods_id = 17010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1124) ->
	#treasure_hunt_reward_cfg{id = 1124,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 3000,special = [],goods_id = 37020002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1125) ->
	#treasure_hunt_reward_cfg{id = 1125,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 10000,special = [],goods_id = 16020002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1126) ->
	#treasure_hunt_reward_cfg{id = 1126,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 18000,special = [],goods_id = 16020001,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1127) ->
	#treasure_hunt_reward_cfg{id = 1127,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 10000,special = [],goods_id = 17020002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1128) ->
	#treasure_hunt_reward_cfg{id = 1128,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 18000,special = [],goods_id = 17020001,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1129) ->
	#treasure_hunt_reward_cfg{id = 1129,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 7,special = [],goods_id = 14010005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1130) ->
	#treasure_hunt_reward_cfg{id = 1130,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 7,special = [],goods_id = 14020005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1131) ->
	#treasure_hunt_reward_cfg{id = 1131,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 67,special = [],goods_id = 14010004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1132) ->
	#treasure_hunt_reward_cfg{id = 1132,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 67,special = [],goods_id = 14020004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1133) ->
	#treasure_hunt_reward_cfg{id = 1133,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 2433,special = [],goods_id = 14010003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1134) ->
	#treasure_hunt_reward_cfg{id = 1134,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 2433,special = [],goods_id = 14020003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1135) ->
	#treasure_hunt_reward_cfg{id = 1135,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 4388,special = [],goods_id = 14010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1136) ->
	#treasure_hunt_reward_cfg{id = 1136,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 4388,special = [],goods_id = 14020002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1137) ->
	#treasure_hunt_reward_cfg{id = 1137,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 2633,special = [],goods_id = 14010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1138) ->
	#treasure_hunt_reward_cfg{id = 1138,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 2633,special = [],goods_id = 14020001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1139) ->
	#treasure_hunt_reward_cfg{id = 1139,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 7276,special = [],goods_id = 32010096,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1140) ->
	#treasure_hunt_reward_cfg{id = 1140,min_rlv = 1,max_rlv = 9999,htype = 1,stype = 1,weight = 148,special = [],goods_id = 38040002,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1141) ->
	#treasure_hunt_reward_cfg{id = 1141,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 220,weight = {86, 999999, 0, 40},special = [{200,499,80},{500,9999,160}],goods_id = 20030003,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1142) ->
	#treasure_hunt_reward_cfg{id = 1142,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 220,weight = {[{{1,85},0},{{86,300},100}],0},special = [{200,499,200},{500,9999,400}],goods_id = 38040025,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1143) ->
	#treasure_hunt_reward_cfg{id = 1143,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 220,weight = {[{{1,85},0},{{86,300},100}],0},special = [{200,499,200},{500,9999,400}],goods_id = 38040026,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1144) ->
	#treasure_hunt_reward_cfg{id = 1144,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 220,weight = {86, 999999, 0, 60},special = [{200,499,120},{500,9999,240}],goods_id = 20030008,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1145) ->
	#treasure_hunt_reward_cfg{id = 1145,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 6000,special = [],goods_id = 14110001,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1146) ->
	#treasure_hunt_reward_cfg{id = 1146,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 5050,special = [],goods_id = 14110002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1147) ->
	#treasure_hunt_reward_cfg{id = 1147,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 2500,special = [],goods_id = 14110003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1148) ->
	#treasure_hunt_reward_cfg{id = 1148,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 6000,special = [],goods_id = 14110004,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1149) ->
	#treasure_hunt_reward_cfg{id = 1149,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 5050,special = [],goods_id = 14110005,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1150) ->
	#treasure_hunt_reward_cfg{id = 1150,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 2500,special = [],goods_id = 14110006,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1151) ->
	#treasure_hunt_reward_cfg{id = 1151,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 4000,special = [],goods_id = 16010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1152) ->
	#treasure_hunt_reward_cfg{id = 1152,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 4000,special = [],goods_id = 16010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1153) ->
	#treasure_hunt_reward_cfg{id = 1153,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 4000,special = [],goods_id = 19010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1154) ->
	#treasure_hunt_reward_cfg{id = 1154,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 4000,special = [],goods_id = 19010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1155) ->
	#treasure_hunt_reward_cfg{id = 1155,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 500,special = [],goods_id = 16010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1156) ->
	#treasure_hunt_reward_cfg{id = 1156,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 500,special = [],goods_id = 19010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1157) ->
	#treasure_hunt_reward_cfg{id = 1157,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 8000,special = [],goods_id = 38040005,goods_num = 50,is_tv = 0,is_rare = 0};

get_reward(1158) ->
	#treasure_hunt_reward_cfg{id = 1158,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 5000,special = [],goods_id = 14010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1159) ->
	#treasure_hunt_reward_cfg{id = 1159,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 5000,special = [],goods_id = 14020002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1160) ->
	#treasure_hunt_reward_cfg{id = 1160,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 1000,special = [],goods_id = 38100003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1161) ->
	#treasure_hunt_reward_cfg{id = 1161,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 3000,special = [],goods_id = 18010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1162) ->
	#treasure_hunt_reward_cfg{id = 1162,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 3000,special = [],goods_id = 18010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1163) ->
	#treasure_hunt_reward_cfg{id = 1163,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 10000,special = [],goods_id = 16020001,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1164) ->
	#treasure_hunt_reward_cfg{id = 1164,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 10000,special = [],goods_id = 17020001,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1165) ->
	#treasure_hunt_reward_cfg{id = 1165,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 2000,special = [],goods_id = 32010141,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1166) ->
	#treasure_hunt_reward_cfg{id = 1166,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 230,weight = 300,special = [],goods_id = 32010227,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1167) ->
	#treasure_hunt_reward_cfg{id = 1167,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 1,weight = 8000,special = [],goods_id = 38040041,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1168) ->
	#treasure_hunt_reward_cfg{id = 1168,min_rlv = 1,max_rlv = 9999,htype = 2,stype = 230,weight = 300,special = [],goods_id = 32070043,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1170) ->
	#treasure_hunt_reward_cfg{id = 1170,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 251,weight = 5,special = [{50,134,5},{135,9999,11}],goods_id = 26260005,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1171) ->
	#treasure_hunt_reward_cfg{id = 1171,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 251,weight = 5,special = [{50,134,5},{135,9999,11}],goods_id = 26270005,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1172) ->
	#treasure_hunt_reward_cfg{id = 1172,min_rlv = 28,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26100005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1174) ->
	#treasure_hunt_reward_cfg{id = 1174,min_rlv = 36,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26110005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1175) ->
	#treasure_hunt_reward_cfg{id = 1175,min_rlv = 44,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26120005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1176) ->
	#treasure_hunt_reward_cfg{id = 1176,min_rlv = 52,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26130005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1178) ->
	#treasure_hunt_reward_cfg{id = 1178,min_rlv = 60,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26140005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1179) ->
	#treasure_hunt_reward_cfg{id = 1179,min_rlv = 68,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26150005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1180) ->
	#treasure_hunt_reward_cfg{id = 1180,min_rlv = 76,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26160005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1182) ->
	#treasure_hunt_reward_cfg{id = 1182,min_rlv = 84,max_rlv = 9999,htype = 4,stype = 251,weight = 70,special = [{50,134,20},{135,9999,40}],goods_id = 26170005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1183) ->
	#treasure_hunt_reward_cfg{id = 1183,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26020005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1184) ->
	#treasure_hunt_reward_cfg{id = 1184,min_rlv = 1,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26030005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1186) ->
	#treasure_hunt_reward_cfg{id = 1186,min_rlv = 3,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26040005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1187) ->
	#treasure_hunt_reward_cfg{id = 1187,min_rlv = 5,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26050005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1188) ->
	#treasure_hunt_reward_cfg{id = 1188,min_rlv = 8,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26060005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1190) ->
	#treasure_hunt_reward_cfg{id = 1190,min_rlv = 12,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26070005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1191) ->
	#treasure_hunt_reward_cfg{id = 1191,min_rlv = 16,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26080005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1192) ->
	#treasure_hunt_reward_cfg{id = 1192,min_rlv = 20,max_rlv = 9999,htype = 4,stype = 251,weight = 150,special = [{50,134,25},{135,9999,55}],goods_id = 26090005,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1194) ->
	#treasure_hunt_reward_cfg{id = 1194,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 0,special = [],goods_id = 26260004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1195) ->
	#treasure_hunt_reward_cfg{id = 1195,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 0,special = [],goods_id = 26270004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1196) ->
	#treasure_hunt_reward_cfg{id = 1196,min_rlv = 28,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26100004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1198) ->
	#treasure_hunt_reward_cfg{id = 1198,min_rlv = 36,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26110004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1199) ->
	#treasure_hunt_reward_cfg{id = 1199,min_rlv = 44,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26120004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1200) ->
	#treasure_hunt_reward_cfg{id = 1200,min_rlv = 52,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26130004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1201) ->
	#treasure_hunt_reward_cfg{id = 1201,min_rlv = 60,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26140004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1202) ->
	#treasure_hunt_reward_cfg{id = 1202,min_rlv = 68,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26150004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1203) ->
	#treasure_hunt_reward_cfg{id = 1203,min_rlv = 76,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26160004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1204) ->
	#treasure_hunt_reward_cfg{id = 1204,min_rlv = 84,max_rlv = 9999,htype = 4,stype = 1,weight = 400,special = [{50,134,40},{135,9999,90}],goods_id = 26170004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1205) ->
	#treasure_hunt_reward_cfg{id = 1205,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26020004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1206) ->
	#treasure_hunt_reward_cfg{id = 1206,min_rlv = 1,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26030004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1207) ->
	#treasure_hunt_reward_cfg{id = 1207,min_rlv = 3,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26040004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1208) ->
	#treasure_hunt_reward_cfg{id = 1208,min_rlv = 4,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26050004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1209) ->
	#treasure_hunt_reward_cfg{id = 1209,min_rlv = 8,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26060004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1210) ->
	#treasure_hunt_reward_cfg{id = 1210,min_rlv = 12,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26070004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1211) ->
	#treasure_hunt_reward_cfg{id = 1211,min_rlv = 16,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26080004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1212) ->
	#treasure_hunt_reward_cfg{id = 1212,min_rlv = 20,max_rlv = 9999,htype = 4,stype = 1,weight = 760,special = [{50,134,50},{135,9999,110}],goods_id = 26090004,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1213) ->
	#treasure_hunt_reward_cfg{id = 1213,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 0,special = [],goods_id = 26260003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1214) ->
	#treasure_hunt_reward_cfg{id = 1214,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 0,special = [],goods_id = 26270003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1215) ->
	#treasure_hunt_reward_cfg{id = 1215,min_rlv = 28,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26100003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1216) ->
	#treasure_hunt_reward_cfg{id = 1216,min_rlv = 36,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26110003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1217) ->
	#treasure_hunt_reward_cfg{id = 1217,min_rlv = 44,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26120003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1218) ->
	#treasure_hunt_reward_cfg{id = 1218,min_rlv = 52,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26130003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1219) ->
	#treasure_hunt_reward_cfg{id = 1219,min_rlv = 60,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26140003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1220) ->
	#treasure_hunt_reward_cfg{id = 1220,min_rlv = 68,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26150003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1221) ->
	#treasure_hunt_reward_cfg{id = 1221,min_rlv = 76,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26160003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1222) ->
	#treasure_hunt_reward_cfg{id = 1222,min_rlv = 84,max_rlv = 9999,htype = 4,stype = 1,weight = 6470,special = [],goods_id = 26170003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1223) ->
	#treasure_hunt_reward_cfg{id = 1223,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26020003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1224) ->
	#treasure_hunt_reward_cfg{id = 1224,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26030003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1225) ->
	#treasure_hunt_reward_cfg{id = 1225,min_rlv = 0,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26040003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1226) ->
	#treasure_hunt_reward_cfg{id = 1226,min_rlv = 4,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26050003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1227) ->
	#treasure_hunt_reward_cfg{id = 1227,min_rlv = 8,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26060003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1228) ->
	#treasure_hunt_reward_cfg{id = 1228,min_rlv = 12,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26070003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1229) ->
	#treasure_hunt_reward_cfg{id = 1229,min_rlv = 16,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26080003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1230) ->
	#treasure_hunt_reward_cfg{id = 1230,min_rlv = 20,max_rlv = 9999,htype = 4,stype = 1,weight = 9015,special = [],goods_id = 26090003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1231) ->
	#treasure_hunt_reward_cfg{id = 1231,min_rlv = 28,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26100002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1232) ->
	#treasure_hunt_reward_cfg{id = 1232,min_rlv = 36,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26110002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1234) ->
	#treasure_hunt_reward_cfg{id = 1234,min_rlv = 44,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26120002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1235) ->
	#treasure_hunt_reward_cfg{id = 1235,min_rlv = 52,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26130002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1236) ->
	#treasure_hunt_reward_cfg{id = 1236,min_rlv = 60,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26140002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1238) ->
	#treasure_hunt_reward_cfg{id = 1238,min_rlv = 68,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26150002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1239) ->
	#treasure_hunt_reward_cfg{id = 1239,min_rlv = 76,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26160002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1240) ->
	#treasure_hunt_reward_cfg{id = 1240,min_rlv = 84,max_rlv = 9999,htype = 4,stype = 1,weight = 3000,special = [],goods_id = 26170002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1241) ->
	#treasure_hunt_reward_cfg{id = 1241,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {[{{1,85},0},{{86,300},80}],0},special = [{200,499,200},{500,9999,400}],goods_id = 38040021,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1242) ->
	#treasure_hunt_reward_cfg{id = 1242,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {[{{1,85},0},{{86,300},80}],0},special = [{200,499,200},{500,9999,400}],goods_id = 38040022,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1243) ->
	#treasure_hunt_reward_cfg{id = 1243,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {86, 999999, 0, 20},special = [{200,499,40},{500,9999,80}],goods_id = 38040026,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1244) ->
	#treasure_hunt_reward_cfg{id = 1244,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {86, 999999, 0, 60},special = [{200,499,120},{500,9999,240}],goods_id = 20030004,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1245) ->
	#treasure_hunt_reward_cfg{id = 1245,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {86, 999999, 0, 40},special = [{200,499,80},{500,9999,160}],goods_id = 20030005,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1246) ->
	#treasure_hunt_reward_cfg{id = 1246,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 2,weight = {86, 999999, 0, 20},special = [{200,499,40},{500,9999,80}],goods_id = 38040025,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1247) ->
	#treasure_hunt_reward_cfg{id = 1247,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 60,special = [],goods_id = 39010502,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1248) ->
	#treasure_hunt_reward_cfg{id = 1248,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 60,special = [],goods_id = 39020502,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1249) ->
	#treasure_hunt_reward_cfg{id = 1249,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 60,special = [],goods_id = 39030502,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1250) ->
	#treasure_hunt_reward_cfg{id = 1250,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 60,special = [],goods_id = 39040502,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1251) ->
	#treasure_hunt_reward_cfg{id = 1251,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 60,special = [],goods_id = 39050502,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1252) ->
	#treasure_hunt_reward_cfg{id = 1252,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 200,special = [],goods_id = 7130101,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1253) ->
	#treasure_hunt_reward_cfg{id = 1253,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 50,special = [],goods_id = 68010004,goods_num = 10,is_tv = 1,is_rare = 0};

get_reward(1254) ->
	#treasure_hunt_reward_cfg{id = 1254,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 150,special = [],goods_id = 53050523,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1255) ->
	#treasure_hunt_reward_cfg{id = 1255,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 4,weight = 150,special = [],goods_id = 53050524,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1256) ->
	#treasure_hunt_reward_cfg{id = 1256,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 7500,special = [],goods_id = 7301001,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1257) ->
	#treasure_hunt_reward_cfg{id = 1257,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 5000,special = [],goods_id = 7301003,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1258) ->
	#treasure_hunt_reward_cfg{id = 1258,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 2000,special = [],goods_id = 7301005,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1259) ->
	#treasure_hunt_reward_cfg{id = 1259,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 7500,special = [],goods_id = 14110001,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1260) ->
	#treasure_hunt_reward_cfg{id = 1260,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 5000,special = [],goods_id = 14110002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1261) ->
	#treasure_hunt_reward_cfg{id = 1261,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 2000,special = [],goods_id = 14110003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1262) ->
	#treasure_hunt_reward_cfg{id = 1262,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3750,special = [],goods_id = 14110004,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1263) ->
	#treasure_hunt_reward_cfg{id = 1263,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 2500,special = [],goods_id = 14110005,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1264) ->
	#treasure_hunt_reward_cfg{id = 1264,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 1000,special = [],goods_id = 14110006,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1265) ->
	#treasure_hunt_reward_cfg{id = 1265,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 16010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1266) ->
	#treasure_hunt_reward_cfg{id = 1266,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 16010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1267) ->
	#treasure_hunt_reward_cfg{id = 1267,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 19010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1268) ->
	#treasure_hunt_reward_cfg{id = 1268,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 19010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1269) ->
	#treasure_hunt_reward_cfg{id = 1269,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 500,special = [],goods_id = 16010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1270) ->
	#treasure_hunt_reward_cfg{id = 1270,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 500,special = [],goods_id = 19010003,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1271) ->
	#treasure_hunt_reward_cfg{id = 1271,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 5000,special = [],goods_id = 38040027,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1272) ->
	#treasure_hunt_reward_cfg{id = 1272,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 6410,special = [],goods_id = 7110001,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1273) ->
	#treasure_hunt_reward_cfg{id = 1273,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 8000,special = [],goods_id = 7110002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1274) ->
	#treasure_hunt_reward_cfg{id = 1274,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 2000,special = [],goods_id = 38100003,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1275) ->
	#treasure_hunt_reward_cfg{id = 1275,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 20010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1276) ->
	#treasure_hunt_reward_cfg{id = 1276,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 3000,special = [],goods_id = 20010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1277) ->
	#treasure_hunt_reward_cfg{id = 1277,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 8000,special = [],goods_id = 38040041,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1278) ->
	#treasure_hunt_reward_cfg{id = 1278,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 400,special = [],goods_id = 39010402,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1279) ->
	#treasure_hunt_reward_cfg{id = 1279,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 400,special = [],goods_id = 39020402,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1280) ->
	#treasure_hunt_reward_cfg{id = 1280,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 400,special = [],goods_id = 39030402,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1281) ->
	#treasure_hunt_reward_cfg{id = 1281,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 400,special = [],goods_id = 39040402,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1282) ->
	#treasure_hunt_reward_cfg{id = 1282,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 400,special = [],goods_id = 39050402,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1283) ->
	#treasure_hunt_reward_cfg{id = 1283,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 5000,special = [],goods_id = 18010001,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1284) ->
	#treasure_hunt_reward_cfg{id = 1284,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 5000,special = [],goods_id = 18010002,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1285) ->
	#treasure_hunt_reward_cfg{id = 1285,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 2000,special = [],goods_id = 68010004,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1286) ->
	#treasure_hunt_reward_cfg{id = 1286,min_rlv = 1,max_rlv = 9999,htype = 3,stype = 1,weight = 150,special = [],goods_id = 68010004,goods_num = 5,is_tv = 1,is_rare = 0};

get_reward(1287) ->
	#treasure_hunt_reward_cfg{id = 1287,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 2000,special = [],goods_id = 32010224,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1288) ->
	#treasure_hunt_reward_cfg{id = 1288,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 600,special = [],goods_id = 32010225,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1289) ->
	#treasure_hunt_reward_cfg{id = 1289,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 250,special = [],goods_id = 32010226,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1290) ->
	#treasure_hunt_reward_cfg{id = 1290,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 1000,special = [],goods_id = 38040037,goods_num = 3,is_tv = 0,is_rare = 0};

get_reward(1291) ->
	#treasure_hunt_reward_cfg{id = 1291,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 300,special = [],goods_id = 38040038,goods_num = 2,is_tv = 1,is_rare = 0};

get_reward(1292) ->
	#treasure_hunt_reward_cfg{id = 1292,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 100,special = [],goods_id = 38040039,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1293) ->
	#treasure_hunt_reward_cfg{id = 1293,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 100,special = [],goods_id = 38040040,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1294) ->
	#treasure_hunt_reward_cfg{id = 1294,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 2000,special = [],goods_id = 38040041,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1295) ->
	#treasure_hunt_reward_cfg{id = 1295,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 1500,special = [],goods_id = 38040042,goods_num = 2,is_tv = 0,is_rare = 0};

get_reward(1296) ->
	#treasure_hunt_reward_cfg{id = 1296,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 800,special = [],goods_id = 38040043,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1297) ->
	#treasure_hunt_reward_cfg{id = 1297,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 2000,special = [],goods_id = 38040031,goods_num = 5,is_tv = 0,is_rare = 0};

get_reward(1298) ->
	#treasure_hunt_reward_cfg{id = 1298,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 250,special = [],goods_id = 38040034,goods_num = 1,is_tv = 0,is_rare = 0};

get_reward(1299) ->
	#treasure_hunt_reward_cfg{id = 1299,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 100,special = [],goods_id = 38040035,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1300) ->
	#treasure_hunt_reward_cfg{id = 1300,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 50,special = [],goods_id = 38040036,goods_num = 1,is_tv = 1,is_rare = 0};

get_reward(1301) ->
	#treasure_hunt_reward_cfg{id = 1301,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 125,special = [],goods_id = 32010223,goods_num = 1,is_tv = 1,is_rare = 1};

get_reward(1302) ->
	#treasure_hunt_reward_cfg{id = 1302,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 600,special = [],goods_id = 38040037,goods_num = 4,is_tv = 0,is_rare = 0};

get_reward(1303) ->
	#treasure_hunt_reward_cfg{id = 1303,min_rlv = 1,max_rlv = 9999,htype = 5,stype = 1,weight = 1000,special = [],goods_id = 38040041,goods_num = 6,is_tv = 0,is_rare = 0};

get_reward(_Id) ->
	[].


get_reward_by_htype(1) ->
[{1101,1,9999},{1102,1,9999},{1103,1,9999},{1104,1,219},{1105,220,269},{1106,270,319},{1107,320,369},{1108,370,419},{1109,420,469},{1110,470,519},{1111,520,569},{1112,570,619},{1113,620,669},{1114,670,719},{1115,720,9999},{1116,1,9999},{1117,1,9999},{1118,1,9999},{1119,1,9999},{1120,1,9999},{1121,1,9999},{1122,1,9999},{1123,1,9999},{1124,1,9999},{1125,1,9999},{1126,1,9999},{1127,1,9999},{1128,1,9999},{1129,1,9999},{1130,1,9999},{1131,1,9999},{1132,1,9999},{1133,1,9999},{1134,1,9999},{1135,1,9999},{1136,1,9999},{1137,1,9999},{1138,1,9999},{1139,1,9999},{1140,1,9999}];


get_reward_by_htype(2) ->
[{1141,1,9999},{1142,1,9999},{1143,1,9999},{1144,1,9999},{1145,1,9999},{1146,1,9999},{1147,1,9999},{1148,1,9999},{1149,1,9999},{1150,1,9999},{1151,1,9999},{1152,1,9999},{1153,1,9999},{1154,1,9999},{1155,1,9999},{1156,1,9999},{1157,1,9999},{1158,1,9999},{1159,1,9999},{1160,1,9999},{1161,1,9999},{1162,1,9999},{1163,1,9999},{1164,1,9999},{1165,1,9999},{1166,1,9999},{1167,1,9999},{1168,1,9999}];


get_reward_by_htype(4) ->
[{1170,0,9999},{1171,0,9999},{1172,28,9999},{1174,36,9999},{1175,44,9999},{1176,52,9999},{1178,60,9999},{1179,68,9999},{1180,76,9999},{1182,84,9999},{1183,0,9999},{1184,1,9999},{1186,3,9999},{1187,5,9999},{1188,8,9999},{1190,12,9999},{1191,16,9999},{1192,20,9999},{1194,0,9999},{1195,0,9999},{1196,28,9999},{1198,36,9999},{1199,44,9999},{1200,52,9999},{1201,60,9999},{1202,68,9999},{1203,76,9999},{1204,84,9999},{1205,0,9999},{1206,1,9999},{1207,3,9999},{1208,4,9999},{1209,8,9999},{1210,12,9999},{1211,16,9999},{1212,20,9999},{1213,0,9999},{1214,0,9999},{1215,28,9999},{1216,36,9999},{1217,44,9999},{1218,52,9999},{1219,60,9999},{1220,68,9999},{1221,76,9999},{1222,84,9999},{1223,0,9999},{1224,0,9999},{1225,0,9999},{1226,4,9999},{1227,8,9999},{1228,12,9999},{1229,16,9999},{1230,20,9999},{1231,28,9999},{1232,36,9999},{1234,44,9999},{1235,52,9999},{1236,60,9999},{1238,68,9999},{1239,76,9999},{1240,84,9999}];


get_reward_by_htype(3) ->
[{1241,1,9999},{1242,1,9999},{1243,1,9999},{1244,1,9999},{1245,1,9999},{1246,1,9999},{1247,1,9999},{1248,1,9999},{1249,1,9999},{1250,1,9999},{1251,1,9999},{1252,1,9999},{1253,1,9999},{1254,1,9999},{1255,1,9999},{1256,1,9999},{1257,1,9999},{1258,1,9999},{1259,1,9999},{1260,1,9999},{1261,1,9999},{1262,1,9999},{1263,1,9999},{1264,1,9999},{1265,1,9999},{1266,1,9999},{1267,1,9999},{1268,1,9999},{1269,1,9999},{1270,1,9999},{1271,1,9999},{1272,1,9999},{1273,1,9999},{1274,1,9999},{1275,1,9999},{1276,1,9999},{1277,1,9999},{1278,1,9999},{1279,1,9999},{1280,1,9999},{1281,1,9999},{1282,1,9999},{1283,1,9999},{1284,1,9999},{1285,1,9999},{1286,1,9999}];


get_reward_by_htype(5) ->
[{1287,1,9999},{1288,1,9999},{1289,1,9999},{1290,1,9999},{1291,1,9999},{1292,1,9999},{1293,1,9999},{1294,1,9999},{1295,1,9999},{1296,1,9999},{1297,1,9999},{1298,1,9999},{1299,1,9999},{1300,1,9999},{1301,1,9999},{1302,1,9999},{1303,1,9999}];

get_reward_by_htype(_Htype) ->
	[].

get_reward_limit(1,101,2) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 101,lim_obj = 2,reset_times = 348,lim_times = 1};

get_reward_limit(1,201,2) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 201,lim_obj = 2,reset_times = 100,lim_times = 1};

get_reward_limit(1,202,2) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 202,lim_obj = 2,reset_times = 100,lim_times = 1};

get_reward_limit(1,230,2) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 230,lim_obj = 2,reset_times = 150,lim_times = 1};

get_reward_limit(1,240,1) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 240,lim_obj = 1,reset_times = 0,lim_times = 1};

get_reward_limit(1,241,1) ->
	#treasure_hunt_limit_cfg{htype = 1,stype = 241,lim_obj = 1,reset_times = 300,lim_times = 1};

get_reward_limit(2,211,2) ->
	#treasure_hunt_limit_cfg{htype = 2,stype = 211,lim_obj = 2,reset_times = 50,lim_times = 1};

get_reward_limit(2,220,2) ->
	#treasure_hunt_limit_cfg{htype = 2,stype = 220,lim_obj = 2,reset_times = 200,lim_times = 1};

get_reward_limit(2,230,2) ->
	#treasure_hunt_limit_cfg{htype = 2,stype = 230,lim_obj = 2,reset_times = 150,lim_times = 1};

get_reward_limit(2,240,1) ->
	#treasure_hunt_limit_cfg{htype = 2,stype = 240,lim_obj = 1,reset_times = 0,lim_times = 1};

get_reward_limit(2,241,1) ->
	#treasure_hunt_limit_cfg{htype = 2,stype = 241,lim_obj = 1,reset_times = 300,lim_times = 1};

get_reward_limit(3,2,2) ->
	#treasure_hunt_limit_cfg{htype = 3,stype = 2,lim_obj = 2,reset_times = 200,lim_times = 1};

get_reward_limit(3,3,2) ->
	#treasure_hunt_limit_cfg{htype = 3,stype = 3,lim_obj = 2,reset_times = 50,lim_times = 1};

get_reward_limit(3,4,2) ->
	#treasure_hunt_limit_cfg{htype = 3,stype = 4,lim_obj = 2,reset_times = 150,lim_times = 1};

get_reward_limit(4,251,2) ->
	#treasure_hunt_limit_cfg{htype = 4,stype = 251,lim_obj = 2,reset_times = 10,lim_times = 1};

get_reward_limit(_Htype,_Stype,_Limobj) ->
	#treasure_hunt_limit_cfg{}.

get_reward_limit_obj(1,101) ->
[{1,101,2}];

get_reward_limit_obj(1,201) ->
[{1,201,2}];

get_reward_limit_obj(1,202) ->
[{1,202,2}];

get_reward_limit_obj(1,230) ->
[{1,230,2}];

get_reward_limit_obj(1,240) ->
[{1,240,1}];

get_reward_limit_obj(1,241) ->
[{1,241,1}];

get_reward_limit_obj(2,211) ->
[{2,211,2}];

get_reward_limit_obj(2,220) ->
[{2,220,2}];

get_reward_limit_obj(2,230) ->
[{2,230,2}];

get_reward_limit_obj(2,240) ->
[{2,240,1}];

get_reward_limit_obj(2,241) ->
[{2,241,1}];

get_reward_limit_obj(3,2) ->
[{3,2,2}];

get_reward_limit_obj(3,3) ->
[{3,3,2}];

get_reward_limit_obj(3,4) ->
[{3,4,2}];

get_reward_limit_obj(4,251) ->
[{4,251,2}];

get_reward_limit_obj(_Htype,_Stype) ->
	[].


get_reward_limit_by_htype(1) ->
[{1,101,2},{1,201,2},{1,202,2},{1,230,2},{1,240,1},{1,241,1}];


get_reward_limit_by_htype(2) ->
[{2,211,2},{2,220,2},{2,230,2},{2,240,1},{2,241,1}];


get_reward_limit_by_htype(3) ->
[{3,2,2},{3,3,2},{3,4,2}];


get_reward_limit_by_htype(4) ->
[{4,251,2}];

get_reward_limit_by_htype(_Htype) ->
	[].

get_all_rune_points() ->
[10].


get_rune_points(10) ->
[{26020004,0,9999,760},{26020005,0,9999,150},{26030004,0,9999,760},{26030005,0,9999,150},{26040004,0,9999,760},{26040005,0,9999,150},{26050004,2,9999,760},{26050005,2,9999,150},{26060004,8,9999,760},{26060005,8,9999,150},{26070004,12,9999,760},{26070005,12,9999,150},{26080004,16,9999,760},{26080005,16,9999,150},{26090004,20,9999,760},{26090005,20,9999,150},{26100004,28,9999,400},{26100005,28,9999,70},{26110004,36,9999,400},{26110005,36,9999,70},{26120004,44,9999,400},{26120005,44,9999,70},{26130004,52,9999,400},{26130005,52,9999,70},{26140004,60,9999,400},{26140005,60,9999,70},{26150004,68,9999,400},{26150005,68,9999,70},{26160004,76,9999,400},{26160005,76,9999,70},{26170004,84,9999,400},{26170005,84,9999,70}];

get_rune_points(_Timespoint) ->
	[].

is_rune_point_tv(10,26020004,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26020005,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26030004,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26030005,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26040004,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26040005,_Lv) when 0 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26050004,_Lv) when 2 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26050005,_Lv) when 2 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26060004,_Lv) when 8 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26060005,_Lv) when 8 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26070004,_Lv) when 12 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26070005,_Lv) when 12 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26080004,_Lv) when 16 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26080005,_Lv) when 16 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26090004,_Lv) when 20 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26090005,_Lv) when 20 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26100004,_Lv) when 28 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26100005,_Lv) when 28 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26110004,_Lv) when 36 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26110005,_Lv) when 36 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26120004,_Lv) when 44 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26120005,_Lv) when 44 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26130004,_Lv) when 52 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26130005,_Lv) when 52 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26140004,_Lv) when 60 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26140005,_Lv) when 60 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26150004,_Lv) when 68 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26150005,_Lv) when 68 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26160004,_Lv) when 76 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26160005,_Lv) when 76 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26170004,_Lv) when 84 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(10,26170005,_Lv) when 84 =< _Lv, _Lv =< 9999 ->
		1;
is_rune_point_tv(_Times_point,_Goods_id,_Lv) ->
	0.


get_flush_type_by_turn(1) ->
[2];

get_flush_type_by_turn(_Turntime) ->
	0.


get_flag_by_turn(1) ->
[0];

get_flag_by_turn(_Turntime) ->
	[].


get_draw_times_by_turn(1) ->
[{1,10},{2,30},{3,60},{4,100},{5,150}];

get_draw_times_by_turn(_Turntime) ->
	[].

get_box_id_by_turn_and_time(1,_DrawTimes) when _DrawTimes >= 10 ->
		1;
get_box_id_by_turn_and_time(1,_DrawTimes) when _DrawTimes >= 30 ->
		2;
get_box_id_by_turn_and_time(1,_DrawTimes) when _DrawTimes >= 60 ->
		3;
get_box_id_by_turn_and_time(1,_DrawTimes) when _DrawTimes >= 100 ->
		4;
get_box_id_by_turn_and_time(1,_DrawTimes) when _DrawTimes >= 150 ->
		5;
get_box_id_by_turn_and_time(_Turn_time,_DrawTimes) ->
	0.

get_stage_reward(1,1,_DrawTime) when _DrawTime >= 10 ->
		[[{0,32080002,1}],0];
get_stage_reward(1,2,_DrawTime) when _DrawTime >= 30 ->
		[[{0,32080003,1}],0];
get_stage_reward(1,3,_DrawTime) when _DrawTime >= 60 ->
		[[{0,32080004,1}],0];
get_stage_reward(1,4,_DrawTime) when _DrawTime >= 100 ->
		[[{0,32080005,1}],0];
get_stage_reward(1,5,_DrawTime) when _DrawTime >= 150 ->
		[[{0,32080006,1}],0];
get_stage_reward(_Turn_time,_Reward_id,_DrawTime) ->
	[].

get_shop_cfg(1) ->
	#score_shop_cfg{id = 1,lv = 500,score = 9000,reward = [{0,20030004,1}],rare = 1};

get_shop_cfg(2) ->
	#score_shop_cfg{id = 2,lv = 500,score = 3000,reward = [{0,38040021,1}],rare = 1};

get_shop_cfg(3) ->
	#score_shop_cfg{id = 3,lv = 500,score = 3000,reward = [{0,38040022,1}],rare = 1};

get_shop_cfg(4) ->
	#score_shop_cfg{id = 4,lv = 371,score = 6000,reward = [{0,20030003,1}],rare = 1};

get_shop_cfg(5) ->
	#score_shop_cfg{id = 5,lv = 371,score = 3000,reward = [{0,38040026,1}],rare = 1};

get_shop_cfg(6) ->
	#score_shop_cfg{id = 6,lv = 371,score = 3000,reward = [{0,38040025,1}],rare = 1};

get_shop_cfg(7) ->
	#score_shop_cfg{id = 7,lv = 50,score = 3000,reward = [{0,20030001,1}],rare = 1};

get_shop_cfg(8) ->
	#score_shop_cfg{id = 8,lv = 50,score = 1500,reward = [{0,101094071,1}],rare = 1};

get_shop_cfg(9) ->
	#score_shop_cfg{id = 9,lv = 50,score = 1500,reward = [{0,101074071,1}],rare = 1};

get_shop_cfg(10) ->
	#score_shop_cfg{id = 10,lv = 50,score = 250,reward = [{0,20010001,1}],rare = 0};

get_shop_cfg(11) ->
	#score_shop_cfg{id = 11,lv = 50,score = 250,reward = [{0,20010002,1}],rare = 0};

get_shop_cfg(12) ->
	#score_shop_cfg{id = 12,lv = 50,score = 20,reward = [{0,14020001,1}],rare = 0};

get_shop_cfg(13) ->
	#score_shop_cfg{id = 13,lv = 50,score = 20,reward = [{0,14010001,1}],rare = 0};

get_shop_cfg(_Id) ->
	[].

get_hunt_task_cfg(5,1) ->
	#base_treasure_hunt_task{htype = 5,id = 1,mod_id = 157,sub_mod = 0,rewards = [{0,36255037,1}],jump_id = 82,num = 50};

get_hunt_task_cfg(5,2) ->
	#base_treasure_hunt_task{htype = 5,id = 2,mod_id = 157,sub_mod = 0,rewards = [{0,36255037,1}],jump_id = 82,num = 100};

get_hunt_task_cfg(5,3) ->
	#base_treasure_hunt_task{htype = 5,id = 3,mod_id = 157,sub_mod = 0,rewards = [{0,36255037,1}],jump_id = 82,num = 150};

get_hunt_task_cfg(_Htype,_Id) ->
	[].


get_all_hunt_task_by_type(5) ->
[1,2,3];

get_all_hunt_task_by_type(_Htype) ->
	[].

get_task_by_mod(5,157,0) ->
[1,2,3];

get_task_by_mod(_Htype,_Modid,_Submod) ->
	[].

