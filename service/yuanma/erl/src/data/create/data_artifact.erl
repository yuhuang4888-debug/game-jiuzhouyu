%%%---------------------------------------
%%% module      : data_artifact
%%% description : 神器配置
%%%
%%%---------------------------------------
-module(data_artifact).
-compile(export_all).
-include("artifact.hrl").



get_active_cfg(101) ->
	#artifact_active_cfg{id = 101,name = <<"奇迹符石"/utf8>>,icon_id = 101,figure_id = 0,condition = [],ench_cost = [{0,44030001,10}],quality = 2};

get_active_cfg(102) ->
	#artifact_active_cfg{id = 102,name = <<"德古拉披风"/utf8>>,icon_id = 102,figure_id = 0,condition = [{artifact,101,60}],ench_cost = [{0,44030001,10}],quality = 2};

get_active_cfg(103) ->
	#artifact_active_cfg{id = 103,name = <<"美杜莎之盾"/utf8>>,icon_id = 103,figure_id = 0,condition = [{artifact,102,100}],ench_cost = [{0,44030001,10}],quality = 2};

get_active_cfg(201) ->
	#artifact_active_cfg{id = 201,name = <<"活力源泉"/utf8>>,icon_id = 201,figure_id = 0,condition = [{0,44012001,1}],ench_cost = [{0,44030002,10}],quality = 3};

get_active_cfg(202) ->
	#artifact_active_cfg{id = 202,name = <<"命运沙漏"/utf8>>,icon_id = 202,figure_id = 0,condition = [{0,44012003,1}],ench_cost = [{0,44030002,10}],quality = 3};

get_active_cfg(203) ->
	#artifact_active_cfg{id = 203,name = <<"审判天秤"/utf8>>,icon_id = 203,figure_id = 0,condition = [{0,44012005,1}],ench_cost = [{0,44030002,10}],quality = 3};

get_active_cfg(301) ->
	#artifact_active_cfg{id = 301,name = <<"雷神之锤"/utf8>>,icon_id = 301,figure_id = 0,condition = [{0,44013001,1}],ench_cost = [{0,44030003,10}],quality = 4};

get_active_cfg(302) ->
	#artifact_active_cfg{id = 302,name = <<"海神三叉戟"/utf8>>,icon_id = 302,figure_id = 0,condition = [{0,44013003,1}],ench_cost = [{0,44030003,10}],quality = 4};

get_active_cfg(303) ->
	#artifact_active_cfg{id = 303,name = <<"大力神斧"/utf8>>,icon_id = 303,figure_id = 0,condition = [{0,44013005,1}],ench_cost = [{0,44030003,10}],quality = 4};

get_active_cfg(_Id) ->
	[].

get_chance_cfg(1) ->
	#enchant_chance_cfg{time = 1,chance = 5};

get_chance_cfg(2) ->
	#enchant_chance_cfg{time = 2,chance = 10};

get_chance_cfg(3) ->
	#enchant_chance_cfg{time = 3,chance = 15};

get_chance_cfg(4) ->
	#enchant_chance_cfg{time = 4,chance = 20};

get_chance_cfg(5) ->
	#enchant_chance_cfg{time = 5,chance = 25};

get_chance_cfg(6) ->
	#enchant_chance_cfg{time = 6,chance = 30};

get_chance_cfg(7) ->
	#enchant_chance_cfg{time = 7,chance = 35};

get_chance_cfg(8) ->
	#enchant_chance_cfg{time = 8,chance = 40};

get_chance_cfg(9) ->
	#enchant_chance_cfg{time = 9,chance = 50};

get_chance_cfg(10) ->
	#enchant_chance_cfg{time = 10,chance = 100};

get_chance_cfg(_Time) ->
	[].

get_enchant_cfg(101,1) ->
	#artifact_enchant_cfg{id = 101,attr_id = 1,name = "奇迹符石",attr = [{1,8000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(101,4) ->
	#artifact_enchant_cfg{id = 101,attr_id = 4,name = "奇迹符石",attr = [{4,8000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(101,7) ->
	#artifact_enchant_cfg{id = 101,attr_id = 7,name = "奇迹符石",attr = [{7,20000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(101,68) ->
	#artifact_enchant_cfg{id = 101,attr_id = 68,name = "奇迹符石",attr = [{68,10000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(102,2) ->
	#artifact_enchant_cfg{id = 102,attr_id = 2,name = "德古拉披风",attr = [{2,160000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(102,8) ->
	#artifact_enchant_cfg{id = 102,attr_id = 8,name = "德古拉披风",attr = [{8,20000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(102,11) ->
	#artifact_enchant_cfg{id = 102,attr_id = 11,name = "德古拉披风",attr = [{11,200}],base_percent = 10,active_weight = 80};

get_enchant_cfg(102,68) ->
	#artifact_enchant_cfg{id = 102,attr_id = 68,name = "德古拉披风",attr = [{68,10000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(103,1) ->
	#artifact_enchant_cfg{id = 103,attr_id = 1,name = "美杜莎之盾",attr = [{1,8000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(103,3) ->
	#artifact_enchant_cfg{id = 103,attr_id = 3,name = "美杜莎之盾",attr = [{3,6000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(103,14) ->
	#artifact_enchant_cfg{id = 103,attr_id = 14,name = "美杜莎之盾",attr = [{14,200}],base_percent = 10,active_weight = 3};

get_enchant_cfg(103,68) ->
	#artifact_enchant_cfg{id = 103,attr_id = 68,name = "美杜莎之盾",attr = [{68,10000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(201,1) ->
	#artifact_enchant_cfg{id = 201,attr_id = 1,name = "活力源泉",attr = [{1,12000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(201,11) ->
	#artifact_enchant_cfg{id = 201,attr_id = 11,name = "活力源泉",attr = [{11,200}],base_percent = 10,active_weight = 15};

get_enchant_cfg(201,15) ->
	#artifact_enchant_cfg{id = 201,attr_id = 15,name = "活力源泉",attr = [{15,12000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(201,68) ->
	#artifact_enchant_cfg{id = 201,attr_id = 68,name = "活力源泉",attr = [{68,10000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(202,2) ->
	#artifact_enchant_cfg{id = 202,attr_id = 2,name = "命运沙漏",attr = [{2,240000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(202,14) ->
	#artifact_enchant_cfg{id = 202,attr_id = 14,name = "命运沙漏",attr = [{14,200}],base_percent = 10,active_weight = 2};

get_enchant_cfg(202,16) ->
	#artifact_enchant_cfg{id = 202,attr_id = 16,name = "命运沙漏",attr = [{16,12000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(202,68) ->
	#artifact_enchant_cfg{id = 202,attr_id = 68,name = "命运沙漏",attr = [{68,10000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(203,2) ->
	#artifact_enchant_cfg{id = 203,attr_id = 2,name = "审判天秤",attr = [{2,200000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(203,3) ->
	#artifact_enchant_cfg{id = 203,attr_id = 3,name = "审判天秤",attr = [{3,10500}],base_percent = 10,active_weight = 3};

get_enchant_cfg(203,4) ->
	#artifact_enchant_cfg{id = 203,attr_id = 4,name = "审判天秤",attr = [{4,10500}],base_percent = 10,active_weight = 80};

get_enchant_cfg(203,68) ->
	#artifact_enchant_cfg{id = 203,attr_id = 68,name = "审判天秤",attr = [{68,10000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(301,2) ->
	#artifact_enchant_cfg{id = 301,attr_id = 2,name = "雷神之锤",attr = [{2,26000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(301,15) ->
	#artifact_enchant_cfg{id = 301,attr_id = 15,name = "雷神之锤",attr = [{15,26000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(301,16) ->
	#artifact_enchant_cfg{id = 301,attr_id = 16,name = "雷神之锤",attr = [{16,26000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(301,68) ->
	#artifact_enchant_cfg{id = 301,attr_id = 68,name = "雷神之锤",attr = [{68,10000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(302,1) ->
	#artifact_enchant_cfg{id = 302,attr_id = 1,name = "海神三叉戟",attr = [{1,26000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(302,15) ->
	#artifact_enchant_cfg{id = 302,attr_id = 15,name = "海神三叉戟",attr = [{15,26000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(302,16) ->
	#artifact_enchant_cfg{id = 302,attr_id = 16,name = "海神三叉戟",attr = [{16,26000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(302,68) ->
	#artifact_enchant_cfg{id = 302,attr_id = 68,name = "海神三叉戟",attr = [{68,10000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(303,3) ->
	#artifact_enchant_cfg{id = 303,attr_id = 3,name = "大力神斧",attr = [{3,26000}],base_percent = 10,active_weight = 15};

get_enchant_cfg(303,15) ->
	#artifact_enchant_cfg{id = 303,attr_id = 15,name = "大力神斧",attr = [{15,26000}],base_percent = 10,active_weight = 80};

get_enchant_cfg(303,16) ->
	#artifact_enchant_cfg{id = 303,attr_id = 16,name = "大力神斧",attr = [{16,26000}],base_percent = 10,active_weight = 3};

get_enchant_cfg(303,68) ->
	#artifact_enchant_cfg{id = 303,attr_id = 68,name = "大力神斧",attr = [{68,10000}],base_percent = 10,active_weight = 2};

get_enchant_cfg(_Id,_Attrid) ->
	[].


get_all_ench_attr(101) ->
[[{1,8000}],[{4,8000}],[{7,20000}],[{68,10000}]];


get_all_ench_attr(102) ->
[[{2,160000}],[{8,20000}],[{11,200}],[{68,10000}]];


get_all_ench_attr(103) ->
[[{1,8000}],[{3,6000}],[{14,200}],[{68,10000}]];


get_all_ench_attr(201) ->
[[{1,12000}],[{11,200}],[{15,12000}],[{68,10000}]];


get_all_ench_attr(202) ->
[[{2,240000}],[{14,200}],[{16,12000}],[{68,10000}]];


get_all_ench_attr(203) ->
[[{2,200000}],[{3,10500}],[{4,10500}],[{68,10000}]];


get_all_ench_attr(301) ->
[[{2,26000}],[{15,26000}],[{16,26000}],[{68,10000}]];


get_all_ench_attr(302) ->
[[{1,26000}],[{15,26000}],[{16,26000}],[{68,10000}]];


get_all_ench_attr(303) ->
[[{3,26000}],[{15,26000}],[{16,26000}],[{68,10000}]];

get_all_ench_attr(_Id) ->
	[].

get_gift_cfg(10101) ->
	#artifact_gift_cfg{gift_id = 10101,gift_name = "强健",id = 101,name = "奇迹符石",need_lv = 30,attr = [{2,4920}]};

get_gift_cfg(10102) ->
	#artifact_gift_cfg{gift_id = 10102,gift_name = "敏捷",id = 101,name = "奇迹符石",need_lv = 60,attr = [{6,880}]};

get_gift_cfg(10103) ->
	#artifact_gift_cfg{gift_id = 10103,gift_name = "强攻",id = 101,name = "奇迹符石",need_lv = 100,attr = [{1,246}]};

get_gift_cfg(10104) ->
	#artifact_gift_cfg{gift_id = 10104,gift_name = "精准",id = 101,name = "奇迹符石",need_lv = 150,attr = [{5,880}]};

get_gift_cfg(10201) ->
	#artifact_gift_cfg{gift_id = 10201,gift_name = "尖锐",id = 102,name = "德古拉披风",need_lv = 30,attr = [{3,246}]};

get_gift_cfg(10202) ->
	#artifact_gift_cfg{gift_id = 10202,gift_name = "韧性",id = 102,name = "德古拉披风",need_lv = 60,attr = [{8,880}]};

get_gift_cfg(10203) ->
	#artifact_gift_cfg{gift_id = 10203,gift_name = "抵御",id = 102,name = "德古拉披风",need_lv = 100,attr = [{4,246}]};

get_gift_cfg(10204) ->
	#artifact_gift_cfg{gift_id = 10204,gift_name = "致命",id = 102,name = "德古拉披风",need_lv = 150,attr = [{7,880}]};

get_gift_cfg(10301) ->
	#artifact_gift_cfg{gift_id = 10301,gift_name = "锋利",id = 103,name = "美杜莎之盾",need_lv = 30,attr = [{1,258}]};

get_gift_cfg(10302) ->
	#artifact_gift_cfg{gift_id = 10302,gift_name = "抵御",id = 103,name = "美杜莎之盾",need_lv = 60,attr = [{4,246}]};

get_gift_cfg(10303) ->
	#artifact_gift_cfg{gift_id = 10303,gift_name = "尖锐",id = 103,name = "美杜莎之盾",need_lv = 100,attr = [{3,246}]};

get_gift_cfg(10304) ->
	#artifact_gift_cfg{gift_id = 10304,gift_name = "强健",id = 103,name = "美杜莎之盾",need_lv = 150,attr = [{2,258}]};

get_gift_cfg(20101) ->
	#artifact_gift_cfg{gift_id = 20101,gift_name = "尖锐",id = 201,name = "活力源泉",need_lv = 30,attr = [{3,325}]};

get_gift_cfg(20102) ->
	#artifact_gift_cfg{gift_id = 20102,gift_name = "精准",id = 201,name = "活力源泉",need_lv = 60,attr = [{5,1286}]};

get_gift_cfg(20103) ->
	#artifact_gift_cfg{gift_id = 20103,gift_name = "致命",id = 201,name = "活力源泉",need_lv = 100,attr = [{7,1286}]};

get_gift_cfg(20104) ->
	#artifact_gift_cfg{gift_id = 20104,gift_name = "抵御",id = 201,name = "活力源泉",need_lv = 150,attr = [{4,325}]};

get_gift_cfg(20201) ->
	#artifact_gift_cfg{gift_id = 20201,gift_name = "强健",id = 202,name = "命运沙漏",need_lv = 30,attr = [{2,6500}]};

get_gift_cfg(20202) ->
	#artifact_gift_cfg{gift_id = 20202,gift_name = "韧性",id = 202,name = "命运沙漏",need_lv = 60,attr = [{8,1286}]};

get_gift_cfg(20203) ->
	#artifact_gift_cfg{gift_id = 20203,gift_name = "敏捷",id = 202,name = "命运沙漏",need_lv = 100,attr = [{6,1286}]};

get_gift_cfg(20204) ->
	#artifact_gift_cfg{gift_id = 20204,gift_name = "锋利",id = 202,name = "命运沙漏",need_lv = 150,attr = [{1,325}]};

get_gift_cfg(20301) ->
	#artifact_gift_cfg{gift_id = 20301,gift_name = "锋利",id = 203,name = "审判天秤",need_lv = 30,attr = [{1,325}]};

get_gift_cfg(20302) ->
	#artifact_gift_cfg{gift_id = 20302,gift_name = "抵御",id = 203,name = "审判天秤",need_lv = 60,attr = [{4,343}]};

get_gift_cfg(20303) ->
	#artifact_gift_cfg{gift_id = 20303,gift_name = "强健",id = 203,name = "审判天秤",need_lv = 100,attr = [{2,6500}]};

get_gift_cfg(20304) ->
	#artifact_gift_cfg{gift_id = 20304,gift_name = "尖锐",id = 203,name = "审判天秤",need_lv = 150,attr = [{3,343}]};

get_gift_cfg(30101) ->
	#artifact_gift_cfg{gift_id = 30101,gift_name = "强攻",id = 301,name = "雷神之锤",need_lv = 30,attr = [{15,368}]};

get_gift_cfg(30102) ->
	#artifact_gift_cfg{gift_id = 30102,gift_name = "韧性",id = 301,name = "雷神之锤",need_lv = 60,attr = [{8,1674}]};

get_gift_cfg(30103) ->
	#artifact_gift_cfg{gift_id = 30103,gift_name = "尖锐",id = 301,name = "雷神之锤",need_lv = 100,attr = [{3,368}]};

get_gift_cfg(30104) ->
	#artifact_gift_cfg{gift_id = 30104,gift_name = "锋利",id = 301,name = "雷神之锤",need_lv = 150,attr = [{1,421}]};

get_gift_cfg(30201) ->
	#artifact_gift_cfg{gift_id = 30201,gift_name = "固守",id = 302,name = "海神三叉戟",need_lv = 30,attr = [{16,368}]};

get_gift_cfg(30202) ->
	#artifact_gift_cfg{gift_id = 30202,gift_name = "精准",id = 302,name = "海神三叉戟",need_lv = 60,attr = [{5,1674}]};

get_gift_cfg(30203) ->
	#artifact_gift_cfg{gift_id = 30203,gift_name = "抵御",id = 302,name = "海神三叉戟",need_lv = 100,attr = [{4,368}]};

get_gift_cfg(30204) ->
	#artifact_gift_cfg{gift_id = 30204,gift_name = "强健",id = 302,name = "海神三叉戟",need_lv = 150,attr = [{2,421}]};

get_gift_cfg(30301) ->
	#artifact_gift_cfg{gift_id = 30301,gift_name = "抵御",id = 303,name = "大力神斧",need_lv = 30,attr = [{4,368}]};

get_gift_cfg(30302) ->
	#artifact_gift_cfg{gift_id = 30302,gift_name = "锋利",id = 303,name = "大力神斧",need_lv = 60,attr = [{1,421}]};

get_gift_cfg(30303) ->
	#artifact_gift_cfg{gift_id = 30303,gift_name = "强健",id = 303,name = "大力神斧",need_lv = 100,attr = [{2,8420}]};

get_gift_cfg(30304) ->
	#artifact_gift_cfg{gift_id = 30304,gift_name = "尖锐",id = 303,name = "大力神斧",need_lv = 150,attr = [{3,368}]};

get_gift_cfg(_Giftid) ->
	[].


get_all_gift_ids(101) ->
[10101,10102,10103,10104];


get_all_gift_ids(102) ->
[10201,10202,10203,10204];


get_all_gift_ids(103) ->
[10301,10302,10303,10304];


get_all_gift_ids(201) ->
[20101,20102,20103,20104];


get_all_gift_ids(202) ->
[20201,20202,20203,20204];


get_all_gift_ids(203) ->
[20301,20302,20303,20304];


get_all_gift_ids(301) ->
[30101,30102,30103,30104];


get_all_gift_ids(302) ->
[30201,30202,30203,30204];


get_all_gift_ids(303) ->
[30301,30302,30303,30304];

get_all_gift_ids(_Id) ->
	[].

get_percent_cfg(101) ->
	#enchant_percent_cfg{id = 101,percent_range = [4,8]};

get_percent_cfg(102) ->
	#enchant_percent_cfg{id = 102,percent_range = [4,8]};

get_percent_cfg(103) ->
	#enchant_percent_cfg{id = 103,percent_range = [4,8]};

get_percent_cfg(201) ->
	#enchant_percent_cfg{id = 201,percent_range = [4,8]};

get_percent_cfg(202) ->
	#enchant_percent_cfg{id = 202,percent_range = [4,8]};

get_percent_cfg(203) ->
	#enchant_percent_cfg{id = 203,percent_range = [4,8]};

get_percent_cfg(301) ->
	#enchant_percent_cfg{id = 301,percent_range = [4,8]};

get_percent_cfg(302) ->
	#enchant_percent_cfg{id = 302,percent_range = [4,8]};

get_percent_cfg(303) ->
	#enchant_percent_cfg{id = 303,percent_range = [4,8]};

get_percent_cfg(_Id) ->
	[].

get_lv_cfg(101,1) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 1,attr = [{1,158},{2,3312},{3,83},{4,77}],cost = [{255,36120001,100}]};

get_lv_cfg(101,2) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 2,attr = [{1,180},{2,3752},{3,94},{4,88}],cost = [{255,36120001,102}]};

get_lv_cfg(101,3) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 3,attr = [{1,202},{2,4192},{3,105},{4,99}],cost = [{255,36120001,105}]};

get_lv_cfg(101,4) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 4,attr = [{1,224},{2,4632},{3,116},{4,110}],cost = [{255,36120001,108}]};

get_lv_cfg(101,5) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 5,attr = [{1,246},{2,5072},{3,127},{4,121}],cost = [{255,36120001,111}]};

get_lv_cfg(101,6) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 6,attr = [{1,268},{2,5512},{3,138},{4,132}],cost = [{255,36120001,114}]};

get_lv_cfg(101,7) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 7,attr = [{1,290},{2,5952},{3,149},{4,143}],cost = [{255,36120001,117}]};

get_lv_cfg(101,8) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 8,attr = [{1,312},{2,6392},{3,160},{4,154}],cost = [{255,36120001,121}]};

get_lv_cfg(101,9) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 9,attr = [{1,334},{2,6832},{3,171},{4,165}],cost = [{255,36120001,125}]};

get_lv_cfg(101,10) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 10,attr = [{1,356},{2,7272},{3,182},{4,176}],cost = [{255,36120001,129}]};

get_lv_cfg(101,11) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 11,attr = [{1,378},{2,7712},{3,193},{4,187}],cost = [{255,36120001,133}]};

get_lv_cfg(101,12) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 12,attr = [{1,400},{2,8152},{3,204},{4,198}],cost = [{255,36120001,137}]};

get_lv_cfg(101,13) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 13,attr = [{1,422},{2,8592},{3,215},{4,209}],cost = [{255,36120001,141}]};

get_lv_cfg(101,14) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 14,attr = [{1,444},{2,9032},{3,226},{4,220}],cost = [{255,36120001,145}]};

get_lv_cfg(101,15) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 15,attr = [{1,466},{2,9472},{3,237},{4,231}],cost = [{255,36120001,149}]};

get_lv_cfg(101,16) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 16,attr = [{1,488},{2,9912},{3,248},{4,242}],cost = [{255,36120001,153}]};

get_lv_cfg(101,17) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 17,attr = [{1,510},{2,10352},{3,259},{4,253}],cost = [{255,36120001,158}]};

get_lv_cfg(101,18) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 18,attr = [{1,532},{2,10792},{3,270},{4,264}],cost = [{255,36120001,163}]};

get_lv_cfg(101,19) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 19,attr = [{1,554},{2,11232},{3,281},{4,275}],cost = [{255,36120001,168}]};

get_lv_cfg(101,20) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 20,attr = [{1,576},{2,11672},{3,292},{4,286}],cost = [{255,36120001,173}]};

get_lv_cfg(101,21) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 21,attr = [{1,598},{2,12112},{3,303},{4,297}],cost = [{255,36120001,178}]};

get_lv_cfg(101,22) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 22,attr = [{1,620},{2,12552},{3,314},{4,308}],cost = [{255,36120001,183}]};

get_lv_cfg(101,23) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 23,attr = [{1,642},{2,12992},{3,325},{4,319}],cost = [{255,36120001,188}]};

get_lv_cfg(101,24) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 24,attr = [{1,664},{2,13432},{3,336},{4,330}],cost = [{255,36120001,194}]};

get_lv_cfg(101,25) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 25,attr = [{1,686},{2,13872},{3,347},{4,341}],cost = [{255,36120001,200}]};

get_lv_cfg(101,26) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 26,attr = [{1,708},{2,14312},{3,358},{4,352}],cost = [{255,36120001,206}]};

get_lv_cfg(101,27) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 27,attr = [{1,730},{2,14752},{3,369},{4,363}],cost = [{255,36120001,212}]};

get_lv_cfg(101,28) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 28,attr = [{1,752},{2,15192},{3,380},{4,374}],cost = [{255,36120001,218}]};

get_lv_cfg(101,29) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 29,attr = [{1,774},{2,15632},{3,391},{4,385}],cost = [{255,36120001,225}]};

get_lv_cfg(101,30) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 30,attr = [{1,796},{2,16072},{3,402},{4,396}],cost = [{255,36120001,232}]};

get_lv_cfg(101,31) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 31,attr = [{1,818},{2,16512},{3,413},{4,407}],cost = [{255,36120001,239}]};

get_lv_cfg(101,32) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 32,attr = [{1,840},{2,16952},{3,424},{4,418}],cost = [{255,36120001,246}]};

get_lv_cfg(101,33) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 33,attr = [{1,862},{2,17392},{3,435},{4,429}],cost = [{255,36120001,253}]};

get_lv_cfg(101,34) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 34,attr = [{1,884},{2,17832},{3,446},{4,440}],cost = [{255,36120001,261}]};

get_lv_cfg(101,35) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 35,attr = [{1,906},{2,18272},{3,457},{4,451}],cost = [{255,36120001,269}]};

get_lv_cfg(101,36) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 36,attr = [{1,928},{2,18712},{3,468},{4,462}],cost = [{255,36120001,277}]};

get_lv_cfg(101,37) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 37,attr = [{1,950},{2,19152},{3,479},{4,473}],cost = [{255,36120001,285}]};

get_lv_cfg(101,38) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 38,attr = [{1,972},{2,19592},{3,490},{4,484}],cost = [{255,36120001,294}]};

get_lv_cfg(101,39) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 39,attr = [{1,994},{2,20032},{3,501},{4,495}],cost = [{255,36120001,303}]};

get_lv_cfg(101,40) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 40,attr = [{1,1016},{2,20472},{3,512},{4,506}],cost = [{255,36120001,312}]};

get_lv_cfg(101,41) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 41,attr = [{1,1038},{2,20912},{3,523},{4,517}],cost = [{255,36120001,321}]};

get_lv_cfg(101,42) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 42,attr = [{1,1060},{2,21352},{3,534},{4,528}],cost = [{255,36120001,331}]};

get_lv_cfg(101,43) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 43,attr = [{1,1082},{2,21792},{3,545},{4,539}],cost = [{255,36120001,341}]};

get_lv_cfg(101,44) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 44,attr = [{1,1104},{2,22232},{3,556},{4,550}],cost = [{255,36120001,351}]};

get_lv_cfg(101,45) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 45,attr = [{1,1126},{2,22672},{3,567},{4,561}],cost = [{255,36120001,362}]};

get_lv_cfg(101,46) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 46,attr = [{1,1148},{2,23112},{3,578},{4,572}],cost = [{255,36120001,373}]};

get_lv_cfg(101,47) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 47,attr = [{1,1170},{2,23552},{3,589},{4,583}],cost = [{255,36120001,384}]};

get_lv_cfg(101,48) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 48,attr = [{1,1192},{2,23992},{3,600},{4,594}],cost = [{255,36120001,396}]};

get_lv_cfg(101,49) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 49,attr = [{1,1214},{2,24432},{3,611},{4,605}],cost = [{255,36120001,408}]};

get_lv_cfg(101,50) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 50,attr = [{1,1236},{2,24872},{3,622},{4,616}],cost = [{255,36120001,420}]};

get_lv_cfg(101,51) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 51,attr = [{1,1258},{2,25312},{3,633},{4,627}],cost = [{255,36120001,433}]};

get_lv_cfg(101,52) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 52,attr = [{1,1280},{2,25752},{3,644},{4,638}],cost = [{255,36120001,446}]};

get_lv_cfg(101,53) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 53,attr = [{1,1302},{2,26192},{3,655},{4,649}],cost = [{255,36120001,459}]};

get_lv_cfg(101,54) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 54,attr = [{1,1324},{2,26632},{3,666},{4,660}],cost = [{255,36120001,473}]};

get_lv_cfg(101,55) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 55,attr = [{1,1346},{2,27072},{3,677},{4,671}],cost = [{255,36120001,487}]};

get_lv_cfg(101,56) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 56,attr = [{1,1368},{2,27512},{3,688},{4,682}],cost = [{255,36120001,502}]};

get_lv_cfg(101,57) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 57,attr = [{1,1390},{2,27952},{3,699},{4,693}],cost = [{255,36120001,517}]};

get_lv_cfg(101,58) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 58,attr = [{1,1412},{2,28392},{3,710},{4,704}],cost = [{255,36120001,533}]};

get_lv_cfg(101,59) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 59,attr = [{1,1434},{2,28832},{3,721},{4,715}],cost = [{255,36120001,549}]};

get_lv_cfg(101,60) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 60,attr = [{1,1456},{2,29272},{3,732},{4,726}],cost = [{255,36120001,565}]};

get_lv_cfg(101,61) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 61,attr = [{1,1478},{2,29712},{3,743},{4,737}],cost = [{255,36120001,582}]};

get_lv_cfg(101,62) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 62,attr = [{1,1500},{2,30152},{3,754},{4,748}],cost = [{255,36120001,599}]};

get_lv_cfg(101,63) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 63,attr = [{1,1522},{2,30592},{3,765},{4,759}],cost = [{255,36120001,617}]};

get_lv_cfg(101,64) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 64,attr = [{1,1544},{2,31032},{3,776},{4,770}],cost = [{255,36120001,636}]};

get_lv_cfg(101,65) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 65,attr = [{1,1566},{2,31472},{3,787},{4,781}],cost = [{255,36120001,655}]};

get_lv_cfg(101,66) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 66,attr = [{1,1588},{2,31912},{3,798},{4,792}],cost = [{255,36120001,675}]};

get_lv_cfg(101,67) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 67,attr = [{1,1610},{2,32352},{3,809},{4,803}],cost = [{255,36120001,695}]};

get_lv_cfg(101,68) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 68,attr = [{1,1632},{2,32792},{3,820},{4,814}],cost = [{255,36120001,716}]};

get_lv_cfg(101,69) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 69,attr = [{1,1654},{2,33232},{3,831},{4,825}],cost = [{255,36120001,737}]};

get_lv_cfg(101,70) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 70,attr = [{1,1676},{2,33672},{3,842},{4,836}],cost = [{255,36120001,759}]};

get_lv_cfg(101,71) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 71,attr = [{1,1698},{2,34112},{3,853},{4,847}],cost = [{255,36120001,782}]};

get_lv_cfg(101,72) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 72,attr = [{1,1720},{2,34552},{3,864},{4,858}],cost = [{255,36120001,805}]};

get_lv_cfg(101,73) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 73,attr = [{1,1742},{2,34992},{3,875},{4,869}],cost = [{255,36120001,829}]};

get_lv_cfg(101,74) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 74,attr = [{1,1764},{2,35432},{3,886},{4,880}],cost = [{255,36120001,854}]};

get_lv_cfg(101,75) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 75,attr = [{1,1786},{2,35872},{3,897},{4,891}],cost = [{255,36120001,880}]};

get_lv_cfg(101,76) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 76,attr = [{1,1808},{2,36312},{3,908},{4,902}],cost = [{255,36120001,906}]};

get_lv_cfg(101,77) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 77,attr = [{1,1830},{2,36752},{3,919},{4,913}],cost = [{255,36120001,933}]};

get_lv_cfg(101,78) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 78,attr = [{1,1852},{2,37192},{3,930},{4,924}],cost = [{255,36120001,961}]};

get_lv_cfg(101,79) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 79,attr = [{1,1874},{2,37632},{3,941},{4,935}],cost = [{255,36120001,990}]};

get_lv_cfg(101,80) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 80,attr = [{1,1896},{2,38072},{3,952},{4,946}],cost = [{255,36120001,1020}]};

get_lv_cfg(101,81) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 81,attr = [{1,1918},{2,38512},{3,963},{4,957}],cost = [{255,36120001,1051}]};

get_lv_cfg(101,82) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 82,attr = [{1,1940},{2,38952},{3,974},{4,968}],cost = [{255,36120001,1083}]};

get_lv_cfg(101,83) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 83,attr = [{1,1962},{2,39392},{3,985},{4,979}],cost = [{255,36120001,1115}]};

get_lv_cfg(101,84) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 84,attr = [{1,1984},{2,39832},{3,996},{4,990}],cost = [{255,36120001,1148}]};

get_lv_cfg(101,85) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 85,attr = [{1,2006},{2,40272},{3,1007},{4,1001}],cost = [{255,36120001,1182}]};

get_lv_cfg(101,86) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 86,attr = [{1,2028},{2,40712},{3,1018},{4,1012}],cost = [{255,36120001,1217}]};

get_lv_cfg(101,87) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 87,attr = [{1,2050},{2,41152},{3,1029},{4,1023}],cost = [{255,36120001,1254}]};

get_lv_cfg(101,88) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 88,attr = [{1,2072},{2,41592},{3,1040},{4,1034}],cost = [{255,36120001,1292}]};

get_lv_cfg(101,89) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 89,attr = [{1,2094},{2,42032},{3,1051},{4,1045}],cost = [{255,36120001,1331}]};

get_lv_cfg(101,90) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 90,attr = [{1,2116},{2,42472},{3,1062},{4,1056}],cost = [{255,36120001,1371}]};

get_lv_cfg(101,91) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 91,attr = [{1,2138},{2,42912},{3,1073},{4,1067}],cost = [{255,36120001,1412}]};

get_lv_cfg(101,92) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 92,attr = [{1,2160},{2,43352},{3,1084},{4,1078}],cost = [{255,36120001,1454}]};

get_lv_cfg(101,93) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 93,attr = [{1,2182},{2,43792},{3,1095},{4,1089}],cost = [{255,36120001,1498}]};

get_lv_cfg(101,94) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 94,attr = [{1,2204},{2,44232},{3,1106},{4,1100}],cost = [{255,36120001,1543}]};

get_lv_cfg(101,95) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 95,attr = [{1,2226},{2,44672},{3,1117},{4,1111}],cost = [{255,36120001,1589}]};

get_lv_cfg(101,96) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 96,attr = [{1,2248},{2,45112},{3,1128},{4,1122}],cost = [{255,36120001,1637}]};

get_lv_cfg(101,97) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 97,attr = [{1,2270},{2,45552},{3,1139},{4,1133}],cost = [{255,36120001,1686}]};

get_lv_cfg(101,98) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 98,attr = [{1,2292},{2,45992},{3,1150},{4,1144}],cost = [{255,36120001,1737}]};

get_lv_cfg(101,99) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 99,attr = [{1,2314},{2,46432},{3,1161},{4,1155}],cost = [{255,36120001,1789}]};

get_lv_cfg(101,100) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 100,attr = [{1,2336},{2,46872},{3,1172},{4,1166}],cost = [{255,36120001,1843}]};

get_lv_cfg(101,101) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 101,attr = [{1,2358},{2,47312},{3,1183},{4,1177}],cost = [{255,36120001,1898}]};

get_lv_cfg(101,102) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 102,attr = [{1,2380},{2,47752},{3,1194},{4,1188}],cost = [{255,36120001,1955}]};

get_lv_cfg(101,103) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 103,attr = [{1,2402},{2,48192},{3,1205},{4,1199}],cost = [{255,36120001,2014}]};

get_lv_cfg(101,104) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 104,attr = [{1,2424},{2,48632},{3,1216},{4,1210}],cost = [{255,36120001,2074}]};

get_lv_cfg(101,105) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 105,attr = [{1,2446},{2,49072},{3,1227},{4,1221}],cost = [{255,36120001,2136}]};

get_lv_cfg(101,106) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 106,attr = [{1,2468},{2,49512},{3,1238},{4,1232}],cost = [{255,36120001,2200}]};

get_lv_cfg(101,107) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 107,attr = [{1,2490},{2,49952},{3,1249},{4,1243}],cost = [{255,36120001,2266}]};

get_lv_cfg(101,108) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 108,attr = [{1,2512},{2,50392},{3,1260},{4,1254}],cost = [{255,36120001,2334}]};

get_lv_cfg(101,109) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 109,attr = [{1,2534},{2,50832},{3,1271},{4,1265}],cost = [{255,36120001,2404}]};

get_lv_cfg(101,110) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 110,attr = [{1,2556},{2,51272},{3,1282},{4,1276}],cost = [{255,36120001,2476}]};

get_lv_cfg(101,111) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 111,attr = [{1,2578},{2,51712},{3,1293},{4,1287}],cost = [{255,36120001,2550}]};

get_lv_cfg(101,112) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 112,attr = [{1,2600},{2,52152},{3,1304},{4,1298}],cost = [{255,36120001,2627}]};

get_lv_cfg(101,113) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 113,attr = [{1,2622},{2,52592},{3,1315},{4,1309}],cost = [{255,36120001,2706}]};

get_lv_cfg(101,114) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 114,attr = [{1,2644},{2,53032},{3,1326},{4,1320}],cost = [{255,36120001,2787}]};

get_lv_cfg(101,115) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 115,attr = [{1,2666},{2,53472},{3,1337},{4,1331}],cost = [{255,36120001,2871}]};

get_lv_cfg(101,116) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 116,attr = [{1,2688},{2,53912},{3,1348},{4,1342}],cost = [{255,36120001,2957}]};

get_lv_cfg(101,117) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 117,attr = [{1,2710},{2,54352},{3,1359},{4,1353}],cost = [{255,36120001,3046}]};

get_lv_cfg(101,118) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 118,attr = [{1,2732},{2,54792},{3,1370},{4,1364}],cost = [{255,36120001,3137}]};

get_lv_cfg(101,119) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 119,attr = [{1,2754},{2,55232},{3,1381},{4,1375}],cost = [{255,36120001,3231}]};

get_lv_cfg(101,120) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 120,attr = [{1,2776},{2,55672},{3,1392},{4,1386}],cost = [{255,36120001,3328}]};

get_lv_cfg(101,121) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 121,attr = [{1,2798},{2,56112},{3,1403},{4,1397}],cost = [{255,36120001,3428}]};

get_lv_cfg(101,122) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 122,attr = [{1,2820},{2,56552},{3,1414},{4,1408}],cost = [{255,36120001,3531}]};

get_lv_cfg(101,123) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 123,attr = [{1,2842},{2,56992},{3,1425},{4,1419}],cost = [{255,36120001,3637}]};

get_lv_cfg(101,124) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 124,attr = [{1,2864},{2,57432},{3,1436},{4,1430}],cost = [{255,36120001,3746}]};

get_lv_cfg(101,125) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 125,attr = [{1,2886},{2,57872},{3,1447},{4,1441}],cost = [{255,36120001,3858}]};

get_lv_cfg(101,126) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 126,attr = [{1,2908},{2,58312},{3,1458},{4,1452}],cost = [{255,36120001,3974}]};

get_lv_cfg(101,127) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 127,attr = [{1,2930},{2,58752},{3,1469},{4,1463}],cost = [{255,36120001,4093}]};

get_lv_cfg(101,128) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 128,attr = [{1,2952},{2,59192},{3,1480},{4,1474}],cost = [{255,36120001,4216}]};

get_lv_cfg(101,129) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 129,attr = [{1,2974},{2,59632},{3,1491},{4,1485}],cost = [{255,36120001,4342}]};

get_lv_cfg(101,130) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 130,attr = [{1,2996},{2,60072},{3,1502},{4,1496}],cost = [{255,36120001,4472}]};

get_lv_cfg(101,131) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 131,attr = [{1,3018},{2,60512},{3,1513},{4,1507}],cost = [{255,36120001,4606}]};

get_lv_cfg(101,132) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 132,attr = [{1,3040},{2,60952},{3,1524},{4,1518}],cost = [{255,36120001,4744}]};

get_lv_cfg(101,133) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 133,attr = [{1,3062},{2,61392},{3,1535},{4,1529}],cost = [{255,36120001,4886}]};

get_lv_cfg(101,134) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 134,attr = [{1,3084},{2,61832},{3,1546},{4,1540}],cost = [{255,36120001,5033}]};

get_lv_cfg(101,135) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 135,attr = [{1,3106},{2,62272},{3,1557},{4,1551}],cost = [{255,36120001,5184}]};

get_lv_cfg(101,136) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 136,attr = [{1,3128},{2,62712},{3,1568},{4,1562}],cost = [{255,36120001,5340}]};

get_lv_cfg(101,137) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 137,attr = [{1,3150},{2,63152},{3,1579},{4,1573}],cost = [{255,36120001,5500}]};

get_lv_cfg(101,138) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 138,attr = [{1,3172},{2,63592},{3,1590},{4,1584}],cost = [{255,36120001,5665}]};

get_lv_cfg(101,139) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 139,attr = [{1,3194},{2,64032},{3,1601},{4,1595}],cost = [{255,36120001,5835}]};

get_lv_cfg(101,140) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 140,attr = [{1,3216},{2,64472},{3,1612},{4,1606}],cost = [{255,36120001,6010}]};

get_lv_cfg(101,141) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 141,attr = [{1,3238},{2,64912},{3,1623},{4,1617}],cost = [{255,36120001,6190}]};

get_lv_cfg(101,142) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 142,attr = [{1,3260},{2,65352},{3,1634},{4,1628}],cost = [{255,36120001,6376}]};

get_lv_cfg(101,143) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 143,attr = [{1,3282},{2,65792},{3,1645},{4,1639}],cost = [{255,36120001,6567}]};

get_lv_cfg(101,144) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 144,attr = [{1,3304},{2,66232},{3,1656},{4,1650}],cost = [{255,36120001,6764}]};

get_lv_cfg(101,145) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 145,attr = [{1,3326},{2,66672},{3,1667},{4,1661}],cost = [{255,36120001,6967}]};

get_lv_cfg(101,146) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 146,attr = [{1,3348},{2,67112},{3,1678},{4,1672}],cost = [{255,36120001,7176}]};

get_lv_cfg(101,147) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 147,attr = [{1,3370},{2,67552},{3,1689},{4,1683}],cost = [{255,36120001,7391}]};

get_lv_cfg(101,148) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 148,attr = [{1,3392},{2,67992},{3,1700},{4,1694}],cost = [{255,36120001,7613}]};

get_lv_cfg(101,149) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 149,attr = [{1,3414},{2,68432},{3,1711},{4,1705}],cost = [{255,36120001,7841}]};

get_lv_cfg(101,150) ->
	#artifact_upgrate_cfg{id = 101,name = "奇迹符石",lv = 150,attr = [{1,3436},{2,68872},{3,1722},{4,1716}],cost = [{255,36120001,8076}]};

get_lv_cfg(102,1) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 1,attr = [{1,166},{2,3256},{3,87},{4,83}],cost = [{255,36120001,100}]};

get_lv_cfg(102,2) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 2,attr = [{1,188},{2,3696},{3,98},{4,94}],cost = [{255,36120001,102}]};

get_lv_cfg(102,3) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 3,attr = [{1,210},{2,4136},{3,109},{4,105}],cost = [{255,36120001,105}]};

get_lv_cfg(102,4) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 4,attr = [{1,232},{2,4576},{3,120},{4,116}],cost = [{255,36120001,108}]};

get_lv_cfg(102,5) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 5,attr = [{1,254},{2,5016},{3,131},{4,127}],cost = [{255,36120001,111}]};

get_lv_cfg(102,6) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 6,attr = [{1,276},{2,5456},{3,142},{4,138}],cost = [{255,36120001,114}]};

get_lv_cfg(102,7) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 7,attr = [{1,298},{2,5896},{3,153},{4,149}],cost = [{255,36120001,117}]};

get_lv_cfg(102,8) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 8,attr = [{1,320},{2,6336},{3,164},{4,160}],cost = [{255,36120001,121}]};

get_lv_cfg(102,9) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 9,attr = [{1,342},{2,6776},{3,175},{4,171}],cost = [{255,36120001,125}]};

get_lv_cfg(102,10) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 10,attr = [{1,364},{2,7216},{3,186},{4,182}],cost = [{255,36120001,129}]};

get_lv_cfg(102,11) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 11,attr = [{1,386},{2,7656},{3,197},{4,193}],cost = [{255,36120001,133}]};

get_lv_cfg(102,12) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 12,attr = [{1,408},{2,8096},{3,208},{4,204}],cost = [{255,36120001,137}]};

get_lv_cfg(102,13) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 13,attr = [{1,430},{2,8536},{3,219},{4,215}],cost = [{255,36120001,141}]};

get_lv_cfg(102,14) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 14,attr = [{1,452},{2,8976},{3,230},{4,226}],cost = [{255,36120001,145}]};

get_lv_cfg(102,15) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 15,attr = [{1,474},{2,9416},{3,241},{4,237}],cost = [{255,36120001,149}]};

get_lv_cfg(102,16) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 16,attr = [{1,496},{2,9856},{3,252},{4,248}],cost = [{255,36120001,153}]};

get_lv_cfg(102,17) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 17,attr = [{1,518},{2,10296},{3,263},{4,259}],cost = [{255,36120001,158}]};

get_lv_cfg(102,18) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 18,attr = [{1,540},{2,10736},{3,274},{4,270}],cost = [{255,36120001,163}]};

get_lv_cfg(102,19) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 19,attr = [{1,562},{2,11176},{3,285},{4,281}],cost = [{255,36120001,168}]};

get_lv_cfg(102,20) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 20,attr = [{1,584},{2,11616},{3,296},{4,292}],cost = [{255,36120001,173}]};

get_lv_cfg(102,21) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 21,attr = [{1,606},{2,12056},{3,307},{4,303}],cost = [{255,36120001,178}]};

get_lv_cfg(102,22) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 22,attr = [{1,628},{2,12496},{3,318},{4,314}],cost = [{255,36120001,183}]};

get_lv_cfg(102,23) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 23,attr = [{1,650},{2,12936},{3,329},{4,325}],cost = [{255,36120001,188}]};

get_lv_cfg(102,24) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 24,attr = [{1,672},{2,13376},{3,340},{4,336}],cost = [{255,36120001,194}]};

get_lv_cfg(102,25) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 25,attr = [{1,694},{2,13816},{3,351},{4,347}],cost = [{255,36120001,200}]};

get_lv_cfg(102,26) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 26,attr = [{1,716},{2,14256},{3,362},{4,358}],cost = [{255,36120001,206}]};

get_lv_cfg(102,27) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 27,attr = [{1,738},{2,14696},{3,373},{4,369}],cost = [{255,36120001,212}]};

get_lv_cfg(102,28) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 28,attr = [{1,760},{2,15136},{3,384},{4,380}],cost = [{255,36120001,218}]};

get_lv_cfg(102,29) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 29,attr = [{1,782},{2,15576},{3,395},{4,391}],cost = [{255,36120001,225}]};

get_lv_cfg(102,30) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 30,attr = [{1,804},{2,16016},{3,406},{4,402}],cost = [{255,36120001,232}]};

get_lv_cfg(102,31) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 31,attr = [{1,826},{2,16456},{3,417},{4,413}],cost = [{255,36120001,239}]};

get_lv_cfg(102,32) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 32,attr = [{1,848},{2,16896},{3,428},{4,424}],cost = [{255,36120001,246}]};

get_lv_cfg(102,33) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 33,attr = [{1,870},{2,17336},{3,439},{4,435}],cost = [{255,36120001,253}]};

get_lv_cfg(102,34) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 34,attr = [{1,892},{2,17776},{3,450},{4,446}],cost = [{255,36120001,261}]};

get_lv_cfg(102,35) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 35,attr = [{1,914},{2,18216},{3,461},{4,457}],cost = [{255,36120001,269}]};

get_lv_cfg(102,36) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 36,attr = [{1,936},{2,18656},{3,472},{4,468}],cost = [{255,36120001,277}]};

get_lv_cfg(102,37) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 37,attr = [{1,958},{2,19096},{3,483},{4,479}],cost = [{255,36120001,285}]};

get_lv_cfg(102,38) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 38,attr = [{1,980},{2,19536},{3,494},{4,490}],cost = [{255,36120001,294}]};

get_lv_cfg(102,39) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 39,attr = [{1,1002},{2,19976},{3,505},{4,501}],cost = [{255,36120001,303}]};

get_lv_cfg(102,40) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 40,attr = [{1,1024},{2,20416},{3,516},{4,512}],cost = [{255,36120001,312}]};

get_lv_cfg(102,41) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 41,attr = [{1,1046},{2,20856},{3,527},{4,523}],cost = [{255,36120001,321}]};

get_lv_cfg(102,42) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 42,attr = [{1,1068},{2,21296},{3,538},{4,534}],cost = [{255,36120001,331}]};

get_lv_cfg(102,43) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 43,attr = [{1,1090},{2,21736},{3,549},{4,545}],cost = [{255,36120001,341}]};

get_lv_cfg(102,44) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 44,attr = [{1,1112},{2,22176},{3,560},{4,556}],cost = [{255,36120001,351}]};

get_lv_cfg(102,45) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 45,attr = [{1,1134},{2,22616},{3,571},{4,567}],cost = [{255,36120001,362}]};

get_lv_cfg(102,46) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 46,attr = [{1,1156},{2,23056},{3,582},{4,578}],cost = [{255,36120001,373}]};

get_lv_cfg(102,47) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 47,attr = [{1,1178},{2,23496},{3,593},{4,589}],cost = [{255,36120001,384}]};

get_lv_cfg(102,48) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 48,attr = [{1,1200},{2,23936},{3,604},{4,600}],cost = [{255,36120001,396}]};

get_lv_cfg(102,49) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 49,attr = [{1,1222},{2,24376},{3,615},{4,611}],cost = [{255,36120001,408}]};

get_lv_cfg(102,50) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 50,attr = [{1,1244},{2,24816},{3,626},{4,622}],cost = [{255,36120001,420}]};

get_lv_cfg(102,51) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 51,attr = [{1,1266},{2,25256},{3,637},{4,633}],cost = [{255,36120001,433}]};

get_lv_cfg(102,52) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 52,attr = [{1,1288},{2,25696},{3,648},{4,644}],cost = [{255,36120001,446}]};

get_lv_cfg(102,53) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 53,attr = [{1,1310},{2,26136},{3,659},{4,655}],cost = [{255,36120001,459}]};

get_lv_cfg(102,54) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 54,attr = [{1,1332},{2,26576},{3,670},{4,666}],cost = [{255,36120001,473}]};

get_lv_cfg(102,55) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 55,attr = [{1,1354},{2,27016},{3,681},{4,677}],cost = [{255,36120001,487}]};

get_lv_cfg(102,56) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 56,attr = [{1,1376},{2,27456},{3,692},{4,688}],cost = [{255,36120001,502}]};

get_lv_cfg(102,57) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 57,attr = [{1,1398},{2,27896},{3,703},{4,699}],cost = [{255,36120001,517}]};

get_lv_cfg(102,58) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 58,attr = [{1,1420},{2,28336},{3,714},{4,710}],cost = [{255,36120001,533}]};

get_lv_cfg(102,59) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 59,attr = [{1,1442},{2,28776},{3,725},{4,721}],cost = [{255,36120001,549}]};

get_lv_cfg(102,60) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 60,attr = [{1,1464},{2,29216},{3,736},{4,732}],cost = [{255,36120001,565}]};

get_lv_cfg(102,61) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 61,attr = [{1,1486},{2,29656},{3,747},{4,743}],cost = [{255,36120001,582}]};

get_lv_cfg(102,62) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 62,attr = [{1,1508},{2,30096},{3,758},{4,754}],cost = [{255,36120001,599}]};

get_lv_cfg(102,63) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 63,attr = [{1,1530},{2,30536},{3,769},{4,765}],cost = [{255,36120001,617}]};

get_lv_cfg(102,64) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 64,attr = [{1,1552},{2,30976},{3,780},{4,776}],cost = [{255,36120001,636}]};

get_lv_cfg(102,65) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 65,attr = [{1,1574},{2,31416},{3,791},{4,787}],cost = [{255,36120001,655}]};

get_lv_cfg(102,66) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 66,attr = [{1,1596},{2,31856},{3,802},{4,798}],cost = [{255,36120001,675}]};

get_lv_cfg(102,67) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 67,attr = [{1,1618},{2,32296},{3,813},{4,809}],cost = [{255,36120001,695}]};

get_lv_cfg(102,68) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 68,attr = [{1,1640},{2,32736},{3,824},{4,820}],cost = [{255,36120001,716}]};

get_lv_cfg(102,69) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 69,attr = [{1,1662},{2,33176},{3,835},{4,831}],cost = [{255,36120001,737}]};

get_lv_cfg(102,70) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 70,attr = [{1,1684},{2,33616},{3,846},{4,842}],cost = [{255,36120001,759}]};

get_lv_cfg(102,71) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 71,attr = [{1,1706},{2,34056},{3,857},{4,853}],cost = [{255,36120001,782}]};

get_lv_cfg(102,72) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 72,attr = [{1,1728},{2,34496},{3,868},{4,864}],cost = [{255,36120001,805}]};

get_lv_cfg(102,73) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 73,attr = [{1,1750},{2,34936},{3,879},{4,875}],cost = [{255,36120001,829}]};

get_lv_cfg(102,74) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 74,attr = [{1,1772},{2,35376},{3,890},{4,886}],cost = [{255,36120001,854}]};

get_lv_cfg(102,75) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 75,attr = [{1,1794},{2,35816},{3,901},{4,897}],cost = [{255,36120001,880}]};

get_lv_cfg(102,76) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 76,attr = [{1,1816},{2,36256},{3,912},{4,908}],cost = [{255,36120001,906}]};

get_lv_cfg(102,77) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 77,attr = [{1,1838},{2,36696},{3,923},{4,919}],cost = [{255,36120001,933}]};

get_lv_cfg(102,78) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 78,attr = [{1,1860},{2,37136},{3,934},{4,930}],cost = [{255,36120001,961}]};

get_lv_cfg(102,79) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 79,attr = [{1,1882},{2,37576},{3,945},{4,941}],cost = [{255,36120001,990}]};

get_lv_cfg(102,80) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 80,attr = [{1,1904},{2,38016},{3,956},{4,952}],cost = [{255,36120001,1020}]};

get_lv_cfg(102,81) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 81,attr = [{1,1926},{2,38456},{3,967},{4,963}],cost = [{255,36120001,1051}]};

get_lv_cfg(102,82) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 82,attr = [{1,1948},{2,38896},{3,978},{4,974}],cost = [{255,36120001,1083}]};

get_lv_cfg(102,83) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 83,attr = [{1,1970},{2,39336},{3,989},{4,985}],cost = [{255,36120001,1115}]};

get_lv_cfg(102,84) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 84,attr = [{1,1992},{2,39776},{3,1000},{4,996}],cost = [{255,36120001,1148}]};

get_lv_cfg(102,85) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 85,attr = [{1,2014},{2,40216},{3,1011},{4,1007}],cost = [{255,36120001,1182}]};

get_lv_cfg(102,86) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 86,attr = [{1,2036},{2,40656},{3,1022},{4,1018}],cost = [{255,36120001,1217}]};

get_lv_cfg(102,87) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 87,attr = [{1,2058},{2,41096},{3,1033},{4,1029}],cost = [{255,36120001,1254}]};

get_lv_cfg(102,88) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 88,attr = [{1,2080},{2,41536},{3,1044},{4,1040}],cost = [{255,36120001,1292}]};

get_lv_cfg(102,89) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 89,attr = [{1,2102},{2,41976},{3,1055},{4,1051}],cost = [{255,36120001,1331}]};

get_lv_cfg(102,90) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 90,attr = [{1,2124},{2,42416},{3,1066},{4,1062}],cost = [{255,36120001,1371}]};

get_lv_cfg(102,91) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 91,attr = [{1,2146},{2,42856},{3,1077},{4,1073}],cost = [{255,36120001,1412}]};

get_lv_cfg(102,92) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 92,attr = [{1,2168},{2,43296},{3,1088},{4,1084}],cost = [{255,36120001,1454}]};

get_lv_cfg(102,93) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 93,attr = [{1,2190},{2,43736},{3,1099},{4,1095}],cost = [{255,36120001,1498}]};

get_lv_cfg(102,94) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 94,attr = [{1,2212},{2,44176},{3,1110},{4,1106}],cost = [{255,36120001,1543}]};

get_lv_cfg(102,95) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 95,attr = [{1,2234},{2,44616},{3,1121},{4,1117}],cost = [{255,36120001,1589}]};

get_lv_cfg(102,96) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 96,attr = [{1,2256},{2,45056},{3,1132},{4,1128}],cost = [{255,36120001,1637}]};

get_lv_cfg(102,97) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 97,attr = [{1,2278},{2,45496},{3,1143},{4,1139}],cost = [{255,36120001,1686}]};

get_lv_cfg(102,98) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 98,attr = [{1,2300},{2,45936},{3,1154},{4,1150}],cost = [{255,36120001,1737}]};

get_lv_cfg(102,99) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 99,attr = [{1,2322},{2,46376},{3,1165},{4,1161}],cost = [{255,36120001,1789}]};

get_lv_cfg(102,100) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 100,attr = [{1,2344},{2,46816},{3,1176},{4,1172}],cost = [{255,36120001,1843}]};

get_lv_cfg(102,101) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 101,attr = [{1,2366},{2,47256},{3,1187},{4,1183}],cost = [{255,36120001,1898}]};

get_lv_cfg(102,102) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 102,attr = [{1,2388},{2,47696},{3,1198},{4,1194}],cost = [{255,36120001,1955}]};

get_lv_cfg(102,103) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 103,attr = [{1,2410},{2,48136},{3,1209},{4,1205}],cost = [{255,36120001,2014}]};

get_lv_cfg(102,104) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 104,attr = [{1,2432},{2,48576},{3,1220},{4,1216}],cost = [{255,36120001,2074}]};

get_lv_cfg(102,105) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 105,attr = [{1,2454},{2,49016},{3,1231},{4,1227}],cost = [{255,36120001,2136}]};

get_lv_cfg(102,106) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 106,attr = [{1,2476},{2,49456},{3,1242},{4,1238}],cost = [{255,36120001,2200}]};

get_lv_cfg(102,107) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 107,attr = [{1,2498},{2,49896},{3,1253},{4,1249}],cost = [{255,36120001,2266}]};

get_lv_cfg(102,108) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 108,attr = [{1,2520},{2,50336},{3,1264},{4,1260}],cost = [{255,36120001,2334}]};

get_lv_cfg(102,109) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 109,attr = [{1,2542},{2,50776},{3,1275},{4,1271}],cost = [{255,36120001,2404}]};

get_lv_cfg(102,110) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 110,attr = [{1,2564},{2,51216},{3,1286},{4,1282}],cost = [{255,36120001,2476}]};

get_lv_cfg(102,111) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 111,attr = [{1,2586},{2,51656},{3,1297},{4,1293}],cost = [{255,36120001,2550}]};

get_lv_cfg(102,112) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 112,attr = [{1,2608},{2,52096},{3,1308},{4,1304}],cost = [{255,36120001,2627}]};

get_lv_cfg(102,113) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 113,attr = [{1,2630},{2,52536},{3,1319},{4,1315}],cost = [{255,36120001,2706}]};

get_lv_cfg(102,114) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 114,attr = [{1,2652},{2,52976},{3,1330},{4,1326}],cost = [{255,36120001,2787}]};

get_lv_cfg(102,115) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 115,attr = [{1,2674},{2,53416},{3,1341},{4,1337}],cost = [{255,36120001,2871}]};

get_lv_cfg(102,116) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 116,attr = [{1,2696},{2,53856},{3,1352},{4,1348}],cost = [{255,36120001,2957}]};

get_lv_cfg(102,117) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 117,attr = [{1,2718},{2,54296},{3,1363},{4,1359}],cost = [{255,36120001,3046}]};

get_lv_cfg(102,118) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 118,attr = [{1,2740},{2,54736},{3,1374},{4,1370}],cost = [{255,36120001,3137}]};

get_lv_cfg(102,119) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 119,attr = [{1,2762},{2,55176},{3,1385},{4,1381}],cost = [{255,36120001,3231}]};

get_lv_cfg(102,120) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 120,attr = [{1,2784},{2,55616},{3,1396},{4,1392}],cost = [{255,36120001,3328}]};

get_lv_cfg(102,121) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 121,attr = [{1,2806},{2,56056},{3,1407},{4,1403}],cost = [{255,36120001,3428}]};

get_lv_cfg(102,122) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 122,attr = [{1,2828},{2,56496},{3,1418},{4,1414}],cost = [{255,36120001,3531}]};

get_lv_cfg(102,123) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 123,attr = [{1,2850},{2,56936},{3,1429},{4,1425}],cost = [{255,36120001,3637}]};

get_lv_cfg(102,124) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 124,attr = [{1,2872},{2,57376},{3,1440},{4,1436}],cost = [{255,36120001,3746}]};

get_lv_cfg(102,125) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 125,attr = [{1,2894},{2,57816},{3,1451},{4,1447}],cost = [{255,36120001,3858}]};

get_lv_cfg(102,126) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 126,attr = [{1,2916},{2,58256},{3,1462},{4,1458}],cost = [{255,36120001,3974}]};

get_lv_cfg(102,127) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 127,attr = [{1,2938},{2,58696},{3,1473},{4,1469}],cost = [{255,36120001,4093}]};

get_lv_cfg(102,128) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 128,attr = [{1,2960},{2,59136},{3,1484},{4,1480}],cost = [{255,36120001,4216}]};

get_lv_cfg(102,129) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 129,attr = [{1,2982},{2,59576},{3,1495},{4,1491}],cost = [{255,36120001,4342}]};

get_lv_cfg(102,130) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 130,attr = [{1,3004},{2,60016},{3,1506},{4,1502}],cost = [{255,36120001,4472}]};

get_lv_cfg(102,131) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 131,attr = [{1,3026},{2,60456},{3,1517},{4,1513}],cost = [{255,36120001,4606}]};

get_lv_cfg(102,132) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 132,attr = [{1,3048},{2,60896},{3,1528},{4,1524}],cost = [{255,36120001,4744}]};

get_lv_cfg(102,133) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 133,attr = [{1,3070},{2,61336},{3,1539},{4,1535}],cost = [{255,36120001,4886}]};

get_lv_cfg(102,134) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 134,attr = [{1,3092},{2,61776},{3,1550},{4,1546}],cost = [{255,36120001,5033}]};

get_lv_cfg(102,135) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 135,attr = [{1,3114},{2,62216},{3,1561},{4,1557}],cost = [{255,36120001,5184}]};

get_lv_cfg(102,136) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 136,attr = [{1,3136},{2,62656},{3,1572},{4,1568}],cost = [{255,36120001,5340}]};

get_lv_cfg(102,137) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 137,attr = [{1,3158},{2,63096},{3,1583},{4,1579}],cost = [{255,36120001,5500}]};

get_lv_cfg(102,138) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 138,attr = [{1,3180},{2,63536},{3,1594},{4,1590}],cost = [{255,36120001,5665}]};

get_lv_cfg(102,139) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 139,attr = [{1,3202},{2,63976},{3,1605},{4,1601}],cost = [{255,36120001,5835}]};

get_lv_cfg(102,140) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 140,attr = [{1,3224},{2,64416},{3,1616},{4,1612}],cost = [{255,36120001,6010}]};

get_lv_cfg(102,141) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 141,attr = [{1,3246},{2,64856},{3,1627},{4,1623}],cost = [{255,36120001,6190}]};

get_lv_cfg(102,142) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 142,attr = [{1,3268},{2,65296},{3,1638},{4,1634}],cost = [{255,36120001,6376}]};

get_lv_cfg(102,143) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 143,attr = [{1,3290},{2,65736},{3,1649},{4,1645}],cost = [{255,36120001,6567}]};

get_lv_cfg(102,144) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 144,attr = [{1,3312},{2,66176},{3,1660},{4,1656}],cost = [{255,36120001,6764}]};

get_lv_cfg(102,145) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 145,attr = [{1,3334},{2,66616},{3,1671},{4,1667}],cost = [{255,36120001,6967}]};

get_lv_cfg(102,146) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 146,attr = [{1,3356},{2,67056},{3,1682},{4,1678}],cost = [{255,36120001,7176}]};

get_lv_cfg(102,147) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 147,attr = [{1,3378},{2,67496},{3,1693},{4,1689}],cost = [{255,36120001,7391}]};

get_lv_cfg(102,148) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 148,attr = [{1,3400},{2,67936},{3,1704},{4,1700}],cost = [{255,36120001,7613}]};

get_lv_cfg(102,149) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 149,attr = [{1,3422},{2,68376},{3,1715},{4,1711}],cost = [{255,36120001,7841}]};

get_lv_cfg(102,150) ->
	#artifact_upgrate_cfg{id = 102,name = "德古拉披风",lv = 150,attr = [{1,3444},{2,68816},{3,1726},{4,1722}],cost = [{255,36120001,8076}]};

get_lv_cfg(103,1) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 1,attr = [{1,176},{2,3432},{3,80},{4,90}],cost = [{255,36120001,100}]};

get_lv_cfg(103,2) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 2,attr = [{1,198},{2,3872},{3,91},{4,101}],cost = [{255,36120001,102}]};

get_lv_cfg(103,3) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 3,attr = [{1,220},{2,4312},{3,102},{4,112}],cost = [{255,36120001,105}]};

get_lv_cfg(103,4) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 4,attr = [{1,242},{2,4752},{3,113},{4,123}],cost = [{255,36120001,108}]};

get_lv_cfg(103,5) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 5,attr = [{1,264},{2,5192},{3,124},{4,134}],cost = [{255,36120001,111}]};

get_lv_cfg(103,6) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 6,attr = [{1,286},{2,5632},{3,135},{4,145}],cost = [{255,36120001,114}]};

get_lv_cfg(103,7) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 7,attr = [{1,308},{2,6072},{3,146},{4,156}],cost = [{255,36120001,117}]};

get_lv_cfg(103,8) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 8,attr = [{1,330},{2,6512},{3,157},{4,167}],cost = [{255,36120001,121}]};

get_lv_cfg(103,9) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 9,attr = [{1,352},{2,6952},{3,168},{4,178}],cost = [{255,36120001,125}]};

get_lv_cfg(103,10) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 10,attr = [{1,374},{2,7392},{3,179},{4,189}],cost = [{255,36120001,129}]};

get_lv_cfg(103,11) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 11,attr = [{1,396},{2,7832},{3,190},{4,200}],cost = [{255,36120001,133}]};

get_lv_cfg(103,12) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 12,attr = [{1,418},{2,8272},{3,201},{4,211}],cost = [{255,36120001,137}]};

get_lv_cfg(103,13) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 13,attr = [{1,440},{2,8712},{3,212},{4,222}],cost = [{255,36120001,141}]};

get_lv_cfg(103,14) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 14,attr = [{1,462},{2,9152},{3,223},{4,233}],cost = [{255,36120001,145}]};

get_lv_cfg(103,15) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 15,attr = [{1,484},{2,9592},{3,234},{4,244}],cost = [{255,36120001,149}]};

get_lv_cfg(103,16) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 16,attr = [{1,506},{2,10032},{3,245},{4,255}],cost = [{255,36120001,153}]};

get_lv_cfg(103,17) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 17,attr = [{1,528},{2,10472},{3,256},{4,266}],cost = [{255,36120001,158}]};

get_lv_cfg(103,18) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 18,attr = [{1,550},{2,10912},{3,267},{4,277}],cost = [{255,36120001,163}]};

get_lv_cfg(103,19) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 19,attr = [{1,572},{2,11352},{3,278},{4,288}],cost = [{255,36120001,168}]};

get_lv_cfg(103,20) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 20,attr = [{1,594},{2,11792},{3,289},{4,299}],cost = [{255,36120001,173}]};

get_lv_cfg(103,21) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 21,attr = [{1,616},{2,12232},{3,300},{4,310}],cost = [{255,36120001,178}]};

get_lv_cfg(103,22) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 22,attr = [{1,638},{2,12672},{3,311},{4,321}],cost = [{255,36120001,183}]};

get_lv_cfg(103,23) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 23,attr = [{1,660},{2,13112},{3,322},{4,332}],cost = [{255,36120001,188}]};

get_lv_cfg(103,24) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 24,attr = [{1,682},{2,13552},{3,333},{4,343}],cost = [{255,36120001,194}]};

get_lv_cfg(103,25) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 25,attr = [{1,704},{2,13992},{3,344},{4,354}],cost = [{255,36120001,200}]};

get_lv_cfg(103,26) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 26,attr = [{1,726},{2,14432},{3,355},{4,365}],cost = [{255,36120001,206}]};

get_lv_cfg(103,27) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 27,attr = [{1,748},{2,14872},{3,366},{4,376}],cost = [{255,36120001,212}]};

get_lv_cfg(103,28) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 28,attr = [{1,770},{2,15312},{3,377},{4,387}],cost = [{255,36120001,218}]};

get_lv_cfg(103,29) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 29,attr = [{1,792},{2,15752},{3,388},{4,398}],cost = [{255,36120001,225}]};

get_lv_cfg(103,30) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 30,attr = [{1,814},{2,16192},{3,399},{4,409}],cost = [{255,36120001,232}]};

get_lv_cfg(103,31) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 31,attr = [{1,836},{2,16632},{3,410},{4,420}],cost = [{255,36120001,239}]};

get_lv_cfg(103,32) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 32,attr = [{1,858},{2,17072},{3,421},{4,431}],cost = [{255,36120001,246}]};

get_lv_cfg(103,33) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 33,attr = [{1,880},{2,17512},{3,432},{4,442}],cost = [{255,36120001,253}]};

get_lv_cfg(103,34) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 34,attr = [{1,902},{2,17952},{3,443},{4,453}],cost = [{255,36120001,261}]};

get_lv_cfg(103,35) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 35,attr = [{1,924},{2,18392},{3,454},{4,464}],cost = [{255,36120001,269}]};

get_lv_cfg(103,36) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 36,attr = [{1,946},{2,18832},{3,465},{4,475}],cost = [{255,36120001,277}]};

get_lv_cfg(103,37) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 37,attr = [{1,968},{2,19272},{3,476},{4,486}],cost = [{255,36120001,285}]};

get_lv_cfg(103,38) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 38,attr = [{1,990},{2,19712},{3,487},{4,497}],cost = [{255,36120001,294}]};

get_lv_cfg(103,39) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 39,attr = [{1,1012},{2,20152},{3,498},{4,508}],cost = [{255,36120001,303}]};

get_lv_cfg(103,40) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 40,attr = [{1,1034},{2,20592},{3,509},{4,519}],cost = [{255,36120001,312}]};

get_lv_cfg(103,41) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 41,attr = [{1,1056},{2,21032},{3,520},{4,530}],cost = [{255,36120001,321}]};

get_lv_cfg(103,42) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 42,attr = [{1,1078},{2,21472},{3,531},{4,541}],cost = [{255,36120001,331}]};

get_lv_cfg(103,43) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 43,attr = [{1,1100},{2,21912},{3,542},{4,552}],cost = [{255,36120001,341}]};

get_lv_cfg(103,44) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 44,attr = [{1,1122},{2,22352},{3,553},{4,563}],cost = [{255,36120001,351}]};

get_lv_cfg(103,45) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 45,attr = [{1,1144},{2,22792},{3,564},{4,574}],cost = [{255,36120001,362}]};

get_lv_cfg(103,46) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 46,attr = [{1,1166},{2,23232},{3,575},{4,585}],cost = [{255,36120001,373}]};

get_lv_cfg(103,47) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 47,attr = [{1,1188},{2,23672},{3,586},{4,596}],cost = [{255,36120001,384}]};

get_lv_cfg(103,48) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 48,attr = [{1,1210},{2,24112},{3,597},{4,607}],cost = [{255,36120001,396}]};

get_lv_cfg(103,49) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 49,attr = [{1,1232},{2,24552},{3,608},{4,618}],cost = [{255,36120001,408}]};

get_lv_cfg(103,50) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 50,attr = [{1,1254},{2,24992},{3,619},{4,629}],cost = [{255,36120001,420}]};

get_lv_cfg(103,51) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 51,attr = [{1,1276},{2,25432},{3,630},{4,640}],cost = [{255,36120001,433}]};

get_lv_cfg(103,52) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 52,attr = [{1,1298},{2,25872},{3,641},{4,651}],cost = [{255,36120001,446}]};

get_lv_cfg(103,53) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 53,attr = [{1,1320},{2,26312},{3,652},{4,662}],cost = [{255,36120001,459}]};

get_lv_cfg(103,54) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 54,attr = [{1,1342},{2,26752},{3,663},{4,673}],cost = [{255,36120001,473}]};

get_lv_cfg(103,55) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 55,attr = [{1,1364},{2,27192},{3,674},{4,684}],cost = [{255,36120001,487}]};

get_lv_cfg(103,56) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 56,attr = [{1,1386},{2,27632},{3,685},{4,695}],cost = [{255,36120001,502}]};

get_lv_cfg(103,57) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 57,attr = [{1,1408},{2,28072},{3,696},{4,706}],cost = [{255,36120001,517}]};

get_lv_cfg(103,58) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 58,attr = [{1,1430},{2,28512},{3,707},{4,717}],cost = [{255,36120001,533}]};

get_lv_cfg(103,59) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 59,attr = [{1,1452},{2,28952},{3,718},{4,728}],cost = [{255,36120001,549}]};

get_lv_cfg(103,60) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 60,attr = [{1,1474},{2,29392},{3,729},{4,739}],cost = [{255,36120001,565}]};

get_lv_cfg(103,61) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 61,attr = [{1,1496},{2,29832},{3,740},{4,750}],cost = [{255,36120001,582}]};

get_lv_cfg(103,62) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 62,attr = [{1,1518},{2,30272},{3,751},{4,761}],cost = [{255,36120001,599}]};

get_lv_cfg(103,63) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 63,attr = [{1,1540},{2,30712},{3,762},{4,772}],cost = [{255,36120001,617}]};

get_lv_cfg(103,64) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 64,attr = [{1,1562},{2,31152},{3,773},{4,783}],cost = [{255,36120001,636}]};

get_lv_cfg(103,65) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 65,attr = [{1,1584},{2,31592},{3,784},{4,794}],cost = [{255,36120001,655}]};

get_lv_cfg(103,66) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 66,attr = [{1,1606},{2,32032},{3,795},{4,805}],cost = [{255,36120001,675}]};

get_lv_cfg(103,67) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 67,attr = [{1,1628},{2,32472},{3,806},{4,816}],cost = [{255,36120001,695}]};

get_lv_cfg(103,68) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 68,attr = [{1,1650},{2,32912},{3,817},{4,827}],cost = [{255,36120001,716}]};

get_lv_cfg(103,69) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 69,attr = [{1,1672},{2,33352},{3,828},{4,838}],cost = [{255,36120001,737}]};

get_lv_cfg(103,70) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 70,attr = [{1,1694},{2,33792},{3,839},{4,849}],cost = [{255,36120001,759}]};

get_lv_cfg(103,71) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 71,attr = [{1,1716},{2,34232},{3,850},{4,860}],cost = [{255,36120001,782}]};

get_lv_cfg(103,72) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 72,attr = [{1,1738},{2,34672},{3,861},{4,871}],cost = [{255,36120001,805}]};

get_lv_cfg(103,73) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 73,attr = [{1,1760},{2,35112},{3,872},{4,882}],cost = [{255,36120001,829}]};

get_lv_cfg(103,74) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 74,attr = [{1,1782},{2,35552},{3,883},{4,893}],cost = [{255,36120001,854}]};

get_lv_cfg(103,75) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 75,attr = [{1,1804},{2,35992},{3,894},{4,904}],cost = [{255,36120001,880}]};

get_lv_cfg(103,76) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 76,attr = [{1,1826},{2,36432},{3,905},{4,915}],cost = [{255,36120001,906}]};

get_lv_cfg(103,77) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 77,attr = [{1,1848},{2,36872},{3,916},{4,926}],cost = [{255,36120001,933}]};

get_lv_cfg(103,78) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 78,attr = [{1,1870},{2,37312},{3,927},{4,937}],cost = [{255,36120001,961}]};

get_lv_cfg(103,79) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 79,attr = [{1,1892},{2,37752},{3,938},{4,948}],cost = [{255,36120001,990}]};

get_lv_cfg(103,80) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 80,attr = [{1,1914},{2,38192},{3,949},{4,959}],cost = [{255,36120001,1020}]};

get_lv_cfg(103,81) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 81,attr = [{1,1936},{2,38632},{3,960},{4,970}],cost = [{255,36120001,1051}]};

get_lv_cfg(103,82) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 82,attr = [{1,1958},{2,39072},{3,971},{4,981}],cost = [{255,36120001,1083}]};

get_lv_cfg(103,83) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 83,attr = [{1,1980},{2,39512},{3,982},{4,992}],cost = [{255,36120001,1115}]};

get_lv_cfg(103,84) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 84,attr = [{1,2002},{2,39952},{3,993},{4,1003}],cost = [{255,36120001,1148}]};

get_lv_cfg(103,85) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 85,attr = [{1,2024},{2,40392},{3,1004},{4,1014}],cost = [{255,36120001,1182}]};

get_lv_cfg(103,86) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 86,attr = [{1,2046},{2,40832},{3,1015},{4,1025}],cost = [{255,36120001,1217}]};

get_lv_cfg(103,87) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 87,attr = [{1,2068},{2,41272},{3,1026},{4,1036}],cost = [{255,36120001,1254}]};

get_lv_cfg(103,88) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 88,attr = [{1,2090},{2,41712},{3,1037},{4,1047}],cost = [{255,36120001,1292}]};

get_lv_cfg(103,89) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 89,attr = [{1,2112},{2,42152},{3,1048},{4,1058}],cost = [{255,36120001,1331}]};

get_lv_cfg(103,90) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 90,attr = [{1,2134},{2,42592},{3,1059},{4,1069}],cost = [{255,36120001,1371}]};

get_lv_cfg(103,91) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 91,attr = [{1,2156},{2,43032},{3,1070},{4,1080}],cost = [{255,36120001,1412}]};

get_lv_cfg(103,92) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 92,attr = [{1,2178},{2,43472},{3,1081},{4,1091}],cost = [{255,36120001,1454}]};

get_lv_cfg(103,93) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 93,attr = [{1,2200},{2,43912},{3,1092},{4,1102}],cost = [{255,36120001,1498}]};

get_lv_cfg(103,94) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 94,attr = [{1,2222},{2,44352},{3,1103},{4,1113}],cost = [{255,36120001,1543}]};

get_lv_cfg(103,95) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 95,attr = [{1,2244},{2,44792},{3,1114},{4,1124}],cost = [{255,36120001,1589}]};

get_lv_cfg(103,96) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 96,attr = [{1,2266},{2,45232},{3,1125},{4,1135}],cost = [{255,36120001,1637}]};

get_lv_cfg(103,97) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 97,attr = [{1,2288},{2,45672},{3,1136},{4,1146}],cost = [{255,36120001,1686}]};

get_lv_cfg(103,98) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 98,attr = [{1,2310},{2,46112},{3,1147},{4,1157}],cost = [{255,36120001,1737}]};

get_lv_cfg(103,99) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 99,attr = [{1,2332},{2,46552},{3,1158},{4,1168}],cost = [{255,36120001,1789}]};

get_lv_cfg(103,100) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 100,attr = [{1,2354},{2,46992},{3,1169},{4,1179}],cost = [{255,36120001,1843}]};

get_lv_cfg(103,101) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 101,attr = [{1,2376},{2,47432},{3,1180},{4,1190}],cost = [{255,36120001,1898}]};

get_lv_cfg(103,102) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 102,attr = [{1,2398},{2,47872},{3,1191},{4,1201}],cost = [{255,36120001,1955}]};

get_lv_cfg(103,103) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 103,attr = [{1,2420},{2,48312},{3,1202},{4,1212}],cost = [{255,36120001,2014}]};

get_lv_cfg(103,104) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 104,attr = [{1,2442},{2,48752},{3,1213},{4,1223}],cost = [{255,36120001,2074}]};

get_lv_cfg(103,105) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 105,attr = [{1,2464},{2,49192},{3,1224},{4,1234}],cost = [{255,36120001,2136}]};

get_lv_cfg(103,106) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 106,attr = [{1,2486},{2,49632},{3,1235},{4,1245}],cost = [{255,36120001,2200}]};

get_lv_cfg(103,107) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 107,attr = [{1,2508},{2,50072},{3,1246},{4,1256}],cost = [{255,36120001,2266}]};

get_lv_cfg(103,108) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 108,attr = [{1,2530},{2,50512},{3,1257},{4,1267}],cost = [{255,36120001,2334}]};

get_lv_cfg(103,109) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 109,attr = [{1,2552},{2,50952},{3,1268},{4,1278}],cost = [{255,36120001,2404}]};

get_lv_cfg(103,110) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 110,attr = [{1,2574},{2,51392},{3,1279},{4,1289}],cost = [{255,36120001,2476}]};

get_lv_cfg(103,111) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 111,attr = [{1,2596},{2,51832},{3,1290},{4,1300}],cost = [{255,36120001,2550}]};

get_lv_cfg(103,112) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 112,attr = [{1,2618},{2,52272},{3,1301},{4,1311}],cost = [{255,36120001,2627}]};

get_lv_cfg(103,113) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 113,attr = [{1,2640},{2,52712},{3,1312},{4,1322}],cost = [{255,36120001,2706}]};

get_lv_cfg(103,114) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 114,attr = [{1,2662},{2,53152},{3,1323},{4,1333}],cost = [{255,36120001,2787}]};

get_lv_cfg(103,115) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 115,attr = [{1,2684},{2,53592},{3,1334},{4,1344}],cost = [{255,36120001,2871}]};

get_lv_cfg(103,116) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 116,attr = [{1,2706},{2,54032},{3,1345},{4,1355}],cost = [{255,36120001,2957}]};

get_lv_cfg(103,117) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 117,attr = [{1,2728},{2,54472},{3,1356},{4,1366}],cost = [{255,36120001,3046}]};

get_lv_cfg(103,118) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 118,attr = [{1,2750},{2,54912},{3,1367},{4,1377}],cost = [{255,36120001,3137}]};

get_lv_cfg(103,119) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 119,attr = [{1,2772},{2,55352},{3,1378},{4,1388}],cost = [{255,36120001,3231}]};

get_lv_cfg(103,120) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 120,attr = [{1,2794},{2,55792},{3,1389},{4,1399}],cost = [{255,36120001,3328}]};

get_lv_cfg(103,121) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 121,attr = [{1,2816},{2,56232},{3,1400},{4,1410}],cost = [{255,36120001,3428}]};

get_lv_cfg(103,122) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 122,attr = [{1,2838},{2,56672},{3,1411},{4,1421}],cost = [{255,36120001,3531}]};

get_lv_cfg(103,123) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 123,attr = [{1,2860},{2,57112},{3,1422},{4,1432}],cost = [{255,36120001,3637}]};

get_lv_cfg(103,124) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 124,attr = [{1,2882},{2,57552},{3,1433},{4,1443}],cost = [{255,36120001,3746}]};

get_lv_cfg(103,125) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 125,attr = [{1,2904},{2,57992},{3,1444},{4,1454}],cost = [{255,36120001,3858}]};

get_lv_cfg(103,126) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 126,attr = [{1,2926},{2,58432},{3,1455},{4,1465}],cost = [{255,36120001,3974}]};

get_lv_cfg(103,127) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 127,attr = [{1,2948},{2,58872},{3,1466},{4,1476}],cost = [{255,36120001,4093}]};

get_lv_cfg(103,128) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 128,attr = [{1,2970},{2,59312},{3,1477},{4,1487}],cost = [{255,36120001,4216}]};

get_lv_cfg(103,129) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 129,attr = [{1,2992},{2,59752},{3,1488},{4,1498}],cost = [{255,36120001,4342}]};

get_lv_cfg(103,130) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 130,attr = [{1,3014},{2,60192},{3,1499},{4,1509}],cost = [{255,36120001,4472}]};

get_lv_cfg(103,131) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 131,attr = [{1,3036},{2,60632},{3,1510},{4,1520}],cost = [{255,36120001,4606}]};

get_lv_cfg(103,132) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 132,attr = [{1,3058},{2,61072},{3,1521},{4,1531}],cost = [{255,36120001,4744}]};

get_lv_cfg(103,133) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 133,attr = [{1,3080},{2,61512},{3,1532},{4,1542}],cost = [{255,36120001,4886}]};

get_lv_cfg(103,134) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 134,attr = [{1,3102},{2,61952},{3,1543},{4,1553}],cost = [{255,36120001,5033}]};

get_lv_cfg(103,135) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 135,attr = [{1,3124},{2,62392},{3,1554},{4,1564}],cost = [{255,36120001,5184}]};

get_lv_cfg(103,136) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 136,attr = [{1,3146},{2,62832},{3,1565},{4,1575}],cost = [{255,36120001,5340}]};

get_lv_cfg(103,137) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 137,attr = [{1,3168},{2,63272},{3,1576},{4,1586}],cost = [{255,36120001,5500}]};

get_lv_cfg(103,138) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 138,attr = [{1,3190},{2,63712},{3,1587},{4,1597}],cost = [{255,36120001,5665}]};

get_lv_cfg(103,139) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 139,attr = [{1,3212},{2,64152},{3,1598},{4,1608}],cost = [{255,36120001,5835}]};

get_lv_cfg(103,140) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 140,attr = [{1,3234},{2,64592},{3,1609},{4,1619}],cost = [{255,36120001,6010}]};

get_lv_cfg(103,141) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 141,attr = [{1,3256},{2,65032},{3,1620},{4,1630}],cost = [{255,36120001,6190}]};

get_lv_cfg(103,142) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 142,attr = [{1,3278},{2,65472},{3,1631},{4,1641}],cost = [{255,36120001,6376}]};

get_lv_cfg(103,143) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 143,attr = [{1,3300},{2,65912},{3,1642},{4,1652}],cost = [{255,36120001,6567}]};

get_lv_cfg(103,144) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 144,attr = [{1,3322},{2,66352},{3,1653},{4,1663}],cost = [{255,36120001,6764}]};

get_lv_cfg(103,145) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 145,attr = [{1,3344},{2,66792},{3,1664},{4,1674}],cost = [{255,36120001,6967}]};

get_lv_cfg(103,146) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 146,attr = [{1,3366},{2,67232},{3,1675},{4,1685}],cost = [{255,36120001,7176}]};

get_lv_cfg(103,147) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 147,attr = [{1,3388},{2,67672},{3,1686},{4,1696}],cost = [{255,36120001,7391}]};

get_lv_cfg(103,148) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 148,attr = [{1,3410},{2,68112},{3,1697},{4,1707}],cost = [{255,36120001,7613}]};

get_lv_cfg(103,149) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 149,attr = [{1,3432},{2,68552},{3,1708},{4,1718}],cost = [{255,36120001,7841}]};

get_lv_cfg(103,150) ->
	#artifact_upgrate_cfg{id = 103,name = "美杜莎之盾",lv = 150,attr = [{1,3454},{2,68992},{3,1719},{4,1729}],cost = [{255,36120001,8076}]};

get_lv_cfg(201,1) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 1,attr = [{1,474},{2,9936},{3,249},{4,231}],cost = [{255,36130001,80}]};

get_lv_cfg(201,2) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 2,attr = [{1,512},{2,10696},{3,268},{4,250}],cost = [{255,36130001,82}]};

get_lv_cfg(201,3) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 3,attr = [{1,550},{2,11456},{3,287},{4,269}],cost = [{255,36130001,84}]};

get_lv_cfg(201,4) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 4,attr = [{1,588},{2,12216},{3,306},{4,288}],cost = [{255,36130001,87}]};

get_lv_cfg(201,5) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 5,attr = [{1,626},{2,12976},{3,325},{4,307}],cost = [{255,36130001,90}]};

get_lv_cfg(201,6) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 6,attr = [{1,664},{2,13736},{3,344},{4,326}],cost = [{255,36130001,93}]};

get_lv_cfg(201,7) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 7,attr = [{1,702},{2,14496},{3,363},{4,345}],cost = [{255,36130001,96}]};

get_lv_cfg(201,8) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 8,attr = [{1,740},{2,15256},{3,382},{4,364}],cost = [{255,36130001,99}]};

get_lv_cfg(201,9) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 9,attr = [{1,778},{2,16016},{3,401},{4,383}],cost = [{255,36130001,102}]};

get_lv_cfg(201,10) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 10,attr = [{1,816},{2,16776},{3,420},{4,402}],cost = [{255,36130001,105}]};

get_lv_cfg(201,11) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 11,attr = [{1,854},{2,17536},{3,439},{4,421}],cost = [{255,36130001,108}]};

get_lv_cfg(201,12) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 12,attr = [{1,892},{2,18296},{3,458},{4,440}],cost = [{255,36130001,111}]};

get_lv_cfg(201,13) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 13,attr = [{1,930},{2,19056},{3,477},{4,459}],cost = [{255,36130001,114}]};

get_lv_cfg(201,14) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 14,attr = [{1,968},{2,19816},{3,496},{4,478}],cost = [{255,36130001,117}]};

get_lv_cfg(201,15) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 15,attr = [{1,1006},{2,20576},{3,515},{4,497}],cost = [{255,36130001,121}]};

get_lv_cfg(201,16) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 16,attr = [{1,1044},{2,21336},{3,534},{4,516}],cost = [{255,36130001,125}]};

get_lv_cfg(201,17) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 17,attr = [{1,1082},{2,22096},{3,553},{4,535}],cost = [{255,36130001,129}]};

get_lv_cfg(201,18) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 18,attr = [{1,1120},{2,22856},{3,572},{4,554}],cost = [{255,36130001,133}]};

get_lv_cfg(201,19) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 19,attr = [{1,1158},{2,23616},{3,591},{4,573}],cost = [{255,36130001,137}]};

get_lv_cfg(201,20) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 20,attr = [{1,1196},{2,24376},{3,610},{4,592}],cost = [{255,36130001,141}]};

get_lv_cfg(201,21) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 21,attr = [{1,1234},{2,25136},{3,629},{4,611}],cost = [{255,36130001,145}]};

get_lv_cfg(201,22) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 22,attr = [{1,1272},{2,25896},{3,648},{4,630}],cost = [{255,36130001,149}]};

get_lv_cfg(201,23) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 23,attr = [{1,1310},{2,26656},{3,667},{4,649}],cost = [{255,36130001,153}]};

get_lv_cfg(201,24) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 24,attr = [{1,1348},{2,27416},{3,686},{4,668}],cost = [{255,36130001,158}]};

get_lv_cfg(201,25) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 25,attr = [{1,1386},{2,28176},{3,705},{4,687}],cost = [{255,36130001,163}]};

get_lv_cfg(201,26) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 26,attr = [{1,1424},{2,28936},{3,724},{4,706}],cost = [{255,36130001,168}]};

get_lv_cfg(201,27) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 27,attr = [{1,1462},{2,29696},{3,743},{4,725}],cost = [{255,36130001,173}]};

get_lv_cfg(201,28) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 28,attr = [{1,1500},{2,30456},{3,762},{4,744}],cost = [{255,36130001,178}]};

get_lv_cfg(201,29) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 29,attr = [{1,1538},{2,31216},{3,781},{4,763}],cost = [{255,36130001,183}]};

get_lv_cfg(201,30) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 30,attr = [{1,1576},{2,31976},{3,800},{4,782}],cost = [{255,36130001,188}]};

get_lv_cfg(201,31) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 31,attr = [{1,1614},{2,32736},{3,819},{4,801}],cost = [{255,36130001,194}]};

get_lv_cfg(201,32) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 32,attr = [{1,1652},{2,33496},{3,838},{4,820}],cost = [{255,36130001,200}]};

get_lv_cfg(201,33) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 33,attr = [{1,1690},{2,34256},{3,857},{4,839}],cost = [{255,36130001,206}]};

get_lv_cfg(201,34) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 34,attr = [{1,1728},{2,35016},{3,876},{4,858}],cost = [{255,36130001,212}]};

get_lv_cfg(201,35) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 35,attr = [{1,1766},{2,35776},{3,895},{4,877}],cost = [{255,36130001,218}]};

get_lv_cfg(201,36) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 36,attr = [{1,1804},{2,36536},{3,914},{4,896}],cost = [{255,36130001,225}]};

get_lv_cfg(201,37) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 37,attr = [{1,1842},{2,37296},{3,933},{4,915}],cost = [{255,36130001,232}]};

get_lv_cfg(201,38) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 38,attr = [{1,1880},{2,38056},{3,952},{4,934}],cost = [{255,36130001,239}]};

get_lv_cfg(201,39) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 39,attr = [{1,1918},{2,38816},{3,971},{4,953}],cost = [{255,36130001,246}]};

get_lv_cfg(201,40) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 40,attr = [{1,1956},{2,39576},{3,990},{4,972}],cost = [{255,36130001,253}]};

get_lv_cfg(201,41) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 41,attr = [{1,1994},{2,40336},{3,1009},{4,991}],cost = [{255,36130001,261}]};

get_lv_cfg(201,42) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 42,attr = [{1,2032},{2,41096},{3,1028},{4,1010}],cost = [{255,36130001,269}]};

get_lv_cfg(201,43) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 43,attr = [{1,2070},{2,41856},{3,1047},{4,1029}],cost = [{255,36130001,277}]};

get_lv_cfg(201,44) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 44,attr = [{1,2108},{2,42616},{3,1066},{4,1048}],cost = [{255,36130001,285}]};

get_lv_cfg(201,45) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 45,attr = [{1,2146},{2,43376},{3,1085},{4,1067}],cost = [{255,36130001,294}]};

get_lv_cfg(201,46) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 46,attr = [{1,2184},{2,44136},{3,1104},{4,1086}],cost = [{255,36130001,303}]};

get_lv_cfg(201,47) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 47,attr = [{1,2222},{2,44896},{3,1123},{4,1105}],cost = [{255,36130001,312}]};

get_lv_cfg(201,48) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 48,attr = [{1,2260},{2,45656},{3,1142},{4,1124}],cost = [{255,36130001,321}]};

get_lv_cfg(201,49) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 49,attr = [{1,2298},{2,46416},{3,1161},{4,1143}],cost = [{255,36130001,331}]};

get_lv_cfg(201,50) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 50,attr = [{1,2336},{2,47176},{3,1180},{4,1162}],cost = [{255,36130001,341}]};

get_lv_cfg(201,51) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 51,attr = [{1,2374},{2,47936},{3,1199},{4,1181}],cost = [{255,36130001,351}]};

get_lv_cfg(201,52) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 52,attr = [{1,2412},{2,48696},{3,1218},{4,1200}],cost = [{255,36130001,362}]};

get_lv_cfg(201,53) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 53,attr = [{1,2450},{2,49456},{3,1237},{4,1219}],cost = [{255,36130001,373}]};

get_lv_cfg(201,54) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 54,attr = [{1,2488},{2,50216},{3,1256},{4,1238}],cost = [{255,36130001,384}]};

get_lv_cfg(201,55) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 55,attr = [{1,2526},{2,50976},{3,1275},{4,1257}],cost = [{255,36130001,396}]};

get_lv_cfg(201,56) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 56,attr = [{1,2564},{2,51736},{3,1294},{4,1276}],cost = [{255,36130001,408}]};

get_lv_cfg(201,57) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 57,attr = [{1,2602},{2,52496},{3,1313},{4,1295}],cost = [{255,36130001,420}]};

get_lv_cfg(201,58) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 58,attr = [{1,2640},{2,53256},{3,1332},{4,1314}],cost = [{255,36130001,433}]};

get_lv_cfg(201,59) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 59,attr = [{1,2678},{2,54016},{3,1351},{4,1333}],cost = [{255,36130001,446}]};

get_lv_cfg(201,60) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 60,attr = [{1,2716},{2,54776},{3,1370},{4,1352}],cost = [{255,36130001,459}]};

get_lv_cfg(201,61) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 61,attr = [{1,2754},{2,55536},{3,1389},{4,1371}],cost = [{255,36130001,473}]};

get_lv_cfg(201,62) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 62,attr = [{1,2792},{2,56296},{3,1408},{4,1390}],cost = [{255,36130001,487}]};

get_lv_cfg(201,63) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 63,attr = [{1,2830},{2,57056},{3,1427},{4,1409}],cost = [{255,36130001,502}]};

get_lv_cfg(201,64) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 64,attr = [{1,2868},{2,57816},{3,1446},{4,1428}],cost = [{255,36130001,517}]};

get_lv_cfg(201,65) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 65,attr = [{1,2906},{2,58576},{3,1465},{4,1447}],cost = [{255,36130001,533}]};

get_lv_cfg(201,66) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 66,attr = [{1,2944},{2,59336},{3,1484},{4,1466}],cost = [{255,36130001,549}]};

get_lv_cfg(201,67) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 67,attr = [{1,2982},{2,60096},{3,1503},{4,1485}],cost = [{255,36130001,565}]};

get_lv_cfg(201,68) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 68,attr = [{1,3020},{2,60856},{3,1522},{4,1504}],cost = [{255,36130001,582}]};

get_lv_cfg(201,69) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 69,attr = [{1,3058},{2,61616},{3,1541},{4,1523}],cost = [{255,36130001,599}]};

get_lv_cfg(201,70) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 70,attr = [{1,3096},{2,62376},{3,1560},{4,1542}],cost = [{255,36130001,617}]};

get_lv_cfg(201,71) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 71,attr = [{1,3134},{2,63136},{3,1579},{4,1561}],cost = [{255,36130001,636}]};

get_lv_cfg(201,72) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 72,attr = [{1,3172},{2,63896},{3,1598},{4,1580}],cost = [{255,36130001,655}]};

get_lv_cfg(201,73) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 73,attr = [{1,3210},{2,64656},{3,1617},{4,1599}],cost = [{255,36130001,675}]};

get_lv_cfg(201,74) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 74,attr = [{1,3248},{2,65416},{3,1636},{4,1618}],cost = [{255,36130001,695}]};

get_lv_cfg(201,75) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 75,attr = [{1,3286},{2,66176},{3,1655},{4,1637}],cost = [{255,36130001,716}]};

get_lv_cfg(201,76) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 76,attr = [{1,3324},{2,66936},{3,1674},{4,1656}],cost = [{255,36130001,737}]};

get_lv_cfg(201,77) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 77,attr = [{1,3362},{2,67696},{3,1693},{4,1675}],cost = [{255,36130001,759}]};

get_lv_cfg(201,78) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 78,attr = [{1,3400},{2,68456},{3,1712},{4,1694}],cost = [{255,36130001,782}]};

get_lv_cfg(201,79) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 79,attr = [{1,3438},{2,69216},{3,1731},{4,1713}],cost = [{255,36130001,805}]};

get_lv_cfg(201,80) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 80,attr = [{1,3476},{2,69976},{3,1750},{4,1732}],cost = [{255,36130001,829}]};

get_lv_cfg(201,81) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 81,attr = [{1,3514},{2,70736},{3,1769},{4,1751}],cost = [{255,36130001,854}]};

get_lv_cfg(201,82) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 82,attr = [{1,3552},{2,71496},{3,1788},{4,1770}],cost = [{255,36130001,880}]};

get_lv_cfg(201,83) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 83,attr = [{1,3590},{2,72256},{3,1807},{4,1789}],cost = [{255,36130001,906}]};

get_lv_cfg(201,84) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 84,attr = [{1,3628},{2,73016},{3,1826},{4,1808}],cost = [{255,36130001,933}]};

get_lv_cfg(201,85) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 85,attr = [{1,3666},{2,73776},{3,1845},{4,1827}],cost = [{255,36130001,961}]};

get_lv_cfg(201,86) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 86,attr = [{1,3704},{2,74536},{3,1864},{4,1846}],cost = [{255,36130001,990}]};

get_lv_cfg(201,87) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 87,attr = [{1,3742},{2,75296},{3,1883},{4,1865}],cost = [{255,36130001,1020}]};

get_lv_cfg(201,88) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 88,attr = [{1,3780},{2,76056},{3,1902},{4,1884}],cost = [{255,36130001,1051}]};

get_lv_cfg(201,89) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 89,attr = [{1,3818},{2,76816},{3,1921},{4,1903}],cost = [{255,36130001,1083}]};

get_lv_cfg(201,90) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 90,attr = [{1,3856},{2,77576},{3,1940},{4,1922}],cost = [{255,36130001,1115}]};

get_lv_cfg(201,91) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 91,attr = [{1,3894},{2,78336},{3,1959},{4,1941}],cost = [{255,36130001,1148}]};

get_lv_cfg(201,92) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 92,attr = [{1,3932},{2,79096},{3,1978},{4,1960}],cost = [{255,36130001,1182}]};

get_lv_cfg(201,93) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 93,attr = [{1,3970},{2,79856},{3,1997},{4,1979}],cost = [{255,36130001,1217}]};

get_lv_cfg(201,94) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 94,attr = [{1,4008},{2,80616},{3,2016},{4,1998}],cost = [{255,36130001,1254}]};

get_lv_cfg(201,95) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 95,attr = [{1,4046},{2,81376},{3,2035},{4,2017}],cost = [{255,36130001,1292}]};

get_lv_cfg(201,96) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 96,attr = [{1,4084},{2,82136},{3,2054},{4,2036}],cost = [{255,36130001,1331}]};

get_lv_cfg(201,97) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 97,attr = [{1,4122},{2,82896},{3,2073},{4,2055}],cost = [{255,36130001,1371}]};

get_lv_cfg(201,98) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 98,attr = [{1,4160},{2,83656},{3,2092},{4,2074}],cost = [{255,36130001,1412}]};

get_lv_cfg(201,99) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 99,attr = [{1,4198},{2,84416},{3,2111},{4,2093}],cost = [{255,36130001,1454}]};

get_lv_cfg(201,100) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 100,attr = [{1,4236},{2,85176},{3,2130},{4,2112}],cost = [{255,36130001,1498}]};

get_lv_cfg(201,101) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 101,attr = [{1,4274},{2,85936},{3,2149},{4,2131}],cost = [{255,36130001,1543}]};

get_lv_cfg(201,102) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 102,attr = [{1,4312},{2,86696},{3,2168},{4,2150}],cost = [{255,36130001,1589}]};

get_lv_cfg(201,103) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 103,attr = [{1,4350},{2,87456},{3,2187},{4,2169}],cost = [{255,36130001,1637}]};

get_lv_cfg(201,104) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 104,attr = [{1,4388},{2,88216},{3,2206},{4,2188}],cost = [{255,36130001,1686}]};

get_lv_cfg(201,105) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 105,attr = [{1,4426},{2,88976},{3,2225},{4,2207}],cost = [{255,36130001,1737}]};

get_lv_cfg(201,106) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 106,attr = [{1,4464},{2,89736},{3,2244},{4,2226}],cost = [{255,36130001,1789}]};

get_lv_cfg(201,107) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 107,attr = [{1,4502},{2,90496},{3,2263},{4,2245}],cost = [{255,36130001,1843}]};

get_lv_cfg(201,108) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 108,attr = [{1,4540},{2,91256},{3,2282},{4,2264}],cost = [{255,36130001,1898}]};

get_lv_cfg(201,109) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 109,attr = [{1,4578},{2,92016},{3,2301},{4,2283}],cost = [{255,36130001,1955}]};

get_lv_cfg(201,110) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 110,attr = [{1,4616},{2,92776},{3,2320},{4,2302}],cost = [{255,36130001,2014}]};

get_lv_cfg(201,111) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 111,attr = [{1,4654},{2,93536},{3,2339},{4,2321}],cost = [{255,36130001,2074}]};

get_lv_cfg(201,112) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 112,attr = [{1,4692},{2,94296},{3,2358},{4,2340}],cost = [{255,36130001,2136}]};

get_lv_cfg(201,113) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 113,attr = [{1,4730},{2,95056},{3,2377},{4,2359}],cost = [{255,36130001,2200}]};

get_lv_cfg(201,114) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 114,attr = [{1,4768},{2,95816},{3,2396},{4,2378}],cost = [{255,36130001,2266}]};

get_lv_cfg(201,115) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 115,attr = [{1,4806},{2,96576},{3,2415},{4,2397}],cost = [{255,36130001,2334}]};

get_lv_cfg(201,116) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 116,attr = [{1,4844},{2,97336},{3,2434},{4,2416}],cost = [{255,36130001,2404}]};

get_lv_cfg(201,117) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 117,attr = [{1,4882},{2,98096},{3,2453},{4,2435}],cost = [{255,36130001,2476}]};

get_lv_cfg(201,118) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 118,attr = [{1,4920},{2,98856},{3,2472},{4,2454}],cost = [{255,36130001,2550}]};

get_lv_cfg(201,119) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 119,attr = [{1,4958},{2,99616},{3,2491},{4,2473}],cost = [{255,36130001,2627}]};

get_lv_cfg(201,120) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 120,attr = [{1,4996},{2,100376},{3,2510},{4,2492}],cost = [{255,36130001,2706}]};

get_lv_cfg(201,121) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 121,attr = [{1,5034},{2,101136},{3,2529},{4,2511}],cost = [{255,36130001,2787}]};

get_lv_cfg(201,122) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 122,attr = [{1,5072},{2,101896},{3,2548},{4,2530}],cost = [{255,36130001,2871}]};

get_lv_cfg(201,123) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 123,attr = [{1,5110},{2,102656},{3,2567},{4,2549}],cost = [{255,36130001,2957}]};

get_lv_cfg(201,124) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 124,attr = [{1,5148},{2,103416},{3,2586},{4,2568}],cost = [{255,36130001,3046}]};

get_lv_cfg(201,125) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 125,attr = [{1,5186},{2,104176},{3,2605},{4,2587}],cost = [{255,36130001,3137}]};

get_lv_cfg(201,126) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 126,attr = [{1,5224},{2,104936},{3,2624},{4,2606}],cost = [{255,36130001,3231}]};

get_lv_cfg(201,127) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 127,attr = [{1,5262},{2,105696},{3,2643},{4,2625}],cost = [{255,36130001,3328}]};

get_lv_cfg(201,128) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 128,attr = [{1,5300},{2,106456},{3,2662},{4,2644}],cost = [{255,36130001,3428}]};

get_lv_cfg(201,129) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 129,attr = [{1,5338},{2,107216},{3,2681},{4,2663}],cost = [{255,36130001,3531}]};

get_lv_cfg(201,130) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 130,attr = [{1,5376},{2,107976},{3,2700},{4,2682}],cost = [{255,36130001,3637}]};

get_lv_cfg(201,131) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 131,attr = [{1,5414},{2,108736},{3,2719},{4,2701}],cost = [{255,36130001,3746}]};

get_lv_cfg(201,132) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 132,attr = [{1,5452},{2,109496},{3,2738},{4,2720}],cost = [{255,36130001,3858}]};

get_lv_cfg(201,133) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 133,attr = [{1,5490},{2,110256},{3,2757},{4,2739}],cost = [{255,36130001,3974}]};

get_lv_cfg(201,134) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 134,attr = [{1,5528},{2,111016},{3,2776},{4,2758}],cost = [{255,36130001,4093}]};

get_lv_cfg(201,135) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 135,attr = [{1,5566},{2,111776},{3,2795},{4,2777}],cost = [{255,36130001,4216}]};

get_lv_cfg(201,136) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 136,attr = [{1,5604},{2,112536},{3,2814},{4,2796}],cost = [{255,36130001,4342}]};

get_lv_cfg(201,137) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 137,attr = [{1,5642},{2,113296},{3,2833},{4,2815}],cost = [{255,36130001,4472}]};

get_lv_cfg(201,138) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 138,attr = [{1,5680},{2,114056},{3,2852},{4,2834}],cost = [{255,36130001,4606}]};

get_lv_cfg(201,139) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 139,attr = [{1,5718},{2,114816},{3,2871},{4,2853}],cost = [{255,36130001,4744}]};

get_lv_cfg(201,140) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 140,attr = [{1,5756},{2,115576},{3,2890},{4,2872}],cost = [{255,36130001,4886}]};

get_lv_cfg(201,141) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 141,attr = [{1,5794},{2,116336},{3,2909},{4,2891}],cost = [{255,36130001,5033}]};

get_lv_cfg(201,142) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 142,attr = [{1,5832},{2,117096},{3,2928},{4,2910}],cost = [{255,36130001,5184}]};

get_lv_cfg(201,143) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 143,attr = [{1,5870},{2,117856},{3,2947},{4,2929}],cost = [{255,36130001,5340}]};

get_lv_cfg(201,144) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 144,attr = [{1,5908},{2,118616},{3,2966},{4,2948}],cost = [{255,36130001,5500}]};

get_lv_cfg(201,145) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 145,attr = [{1,5946},{2,119376},{3,2985},{4,2967}],cost = [{255,36130001,5665}]};

get_lv_cfg(201,146) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 146,attr = [{1,5984},{2,120136},{3,3004},{4,2986}],cost = [{255,36130001,5835}]};

get_lv_cfg(201,147) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 147,attr = [{1,6022},{2,120896},{3,3023},{4,3005}],cost = [{255,36130001,6010}]};

get_lv_cfg(201,148) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 148,attr = [{1,6060},{2,121656},{3,3042},{4,3024}],cost = [{255,36130001,6190}]};

get_lv_cfg(201,149) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 149,attr = [{1,6098},{2,122416},{3,3061},{4,3043}],cost = [{255,36130001,6376}]};

get_lv_cfg(201,150) ->
	#artifact_upgrate_cfg{id = 201,name = "活力源泉",lv = 150,attr = [{1,6136},{2,123176},{3,3080},{4,3062}],cost = [{255,36130001,6567}]};

get_lv_cfg(202,1) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 1,attr = [{1,498},{2,9768},{3,261},{4,249}],cost = [{255,36130001,80}]};

get_lv_cfg(202,2) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 2,attr = [{1,536},{2,10528},{3,280},{4,268}],cost = [{255,36130001,82}]};

get_lv_cfg(202,3) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 3,attr = [{1,574},{2,11288},{3,299},{4,287}],cost = [{255,36130001,84}]};

get_lv_cfg(202,4) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 4,attr = [{1,612},{2,12048},{3,318},{4,306}],cost = [{255,36130001,87}]};

get_lv_cfg(202,5) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 5,attr = [{1,650},{2,12808},{3,337},{4,325}],cost = [{255,36130001,90}]};

get_lv_cfg(202,6) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 6,attr = [{1,688},{2,13568},{3,356},{4,344}],cost = [{255,36130001,93}]};

get_lv_cfg(202,7) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 7,attr = [{1,726},{2,14328},{3,375},{4,363}],cost = [{255,36130001,96}]};

get_lv_cfg(202,8) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 8,attr = [{1,764},{2,15088},{3,394},{4,382}],cost = [{255,36130001,99}]};

get_lv_cfg(202,9) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 9,attr = [{1,802},{2,15848},{3,413},{4,401}],cost = [{255,36130001,102}]};

get_lv_cfg(202,10) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 10,attr = [{1,840},{2,16608},{3,432},{4,420}],cost = [{255,36130001,105}]};

get_lv_cfg(202,11) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 11,attr = [{1,878},{2,17368},{3,451},{4,439}],cost = [{255,36130001,108}]};

get_lv_cfg(202,12) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 12,attr = [{1,916},{2,18128},{3,470},{4,458}],cost = [{255,36130001,111}]};

get_lv_cfg(202,13) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 13,attr = [{1,954},{2,18888},{3,489},{4,477}],cost = [{255,36130001,114}]};

get_lv_cfg(202,14) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 14,attr = [{1,992},{2,19648},{3,508},{4,496}],cost = [{255,36130001,117}]};

get_lv_cfg(202,15) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 15,attr = [{1,1030},{2,20408},{3,527},{4,515}],cost = [{255,36130001,121}]};

get_lv_cfg(202,16) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 16,attr = [{1,1068},{2,21168},{3,546},{4,534}],cost = [{255,36130001,125}]};

get_lv_cfg(202,17) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 17,attr = [{1,1106},{2,21928},{3,565},{4,553}],cost = [{255,36130001,129}]};

get_lv_cfg(202,18) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 18,attr = [{1,1144},{2,22688},{3,584},{4,572}],cost = [{255,36130001,133}]};

get_lv_cfg(202,19) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 19,attr = [{1,1182},{2,23448},{3,603},{4,591}],cost = [{255,36130001,137}]};

get_lv_cfg(202,20) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 20,attr = [{1,1220},{2,24208},{3,622},{4,610}],cost = [{255,36130001,141}]};

get_lv_cfg(202,21) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 21,attr = [{1,1258},{2,24968},{3,641},{4,629}],cost = [{255,36130001,145}]};

get_lv_cfg(202,22) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 22,attr = [{1,1296},{2,25728},{3,660},{4,648}],cost = [{255,36130001,149}]};

get_lv_cfg(202,23) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 23,attr = [{1,1334},{2,26488},{3,679},{4,667}],cost = [{255,36130001,153}]};

get_lv_cfg(202,24) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 24,attr = [{1,1372},{2,27248},{3,698},{4,686}],cost = [{255,36130001,158}]};

get_lv_cfg(202,25) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 25,attr = [{1,1410},{2,28008},{3,717},{4,705}],cost = [{255,36130001,163}]};

get_lv_cfg(202,26) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 26,attr = [{1,1448},{2,28768},{3,736},{4,724}],cost = [{255,36130001,168}]};

get_lv_cfg(202,27) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 27,attr = [{1,1486},{2,29528},{3,755},{4,743}],cost = [{255,36130001,173}]};

get_lv_cfg(202,28) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 28,attr = [{1,1524},{2,30288},{3,774},{4,762}],cost = [{255,36130001,178}]};

get_lv_cfg(202,29) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 29,attr = [{1,1562},{2,31048},{3,793},{4,781}],cost = [{255,36130001,183}]};

get_lv_cfg(202,30) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 30,attr = [{1,1600},{2,31808},{3,812},{4,800}],cost = [{255,36130001,188}]};

get_lv_cfg(202,31) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 31,attr = [{1,1638},{2,32568},{3,831},{4,819}],cost = [{255,36130001,194}]};

get_lv_cfg(202,32) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 32,attr = [{1,1676},{2,33328},{3,850},{4,838}],cost = [{255,36130001,200}]};

get_lv_cfg(202,33) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 33,attr = [{1,1714},{2,34088},{3,869},{4,857}],cost = [{255,36130001,206}]};

get_lv_cfg(202,34) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 34,attr = [{1,1752},{2,34848},{3,888},{4,876}],cost = [{255,36130001,212}]};

get_lv_cfg(202,35) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 35,attr = [{1,1790},{2,35608},{3,907},{4,895}],cost = [{255,36130001,218}]};

get_lv_cfg(202,36) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 36,attr = [{1,1828},{2,36368},{3,926},{4,914}],cost = [{255,36130001,225}]};

get_lv_cfg(202,37) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 37,attr = [{1,1866},{2,37128},{3,945},{4,933}],cost = [{255,36130001,232}]};

get_lv_cfg(202,38) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 38,attr = [{1,1904},{2,37888},{3,964},{4,952}],cost = [{255,36130001,239}]};

get_lv_cfg(202,39) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 39,attr = [{1,1942},{2,38648},{3,983},{4,971}],cost = [{255,36130001,246}]};

get_lv_cfg(202,40) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 40,attr = [{1,1980},{2,39408},{3,1002},{4,990}],cost = [{255,36130001,253}]};

get_lv_cfg(202,41) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 41,attr = [{1,2018},{2,40168},{3,1021},{4,1009}],cost = [{255,36130001,261}]};

get_lv_cfg(202,42) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 42,attr = [{1,2056},{2,40928},{3,1040},{4,1028}],cost = [{255,36130001,269}]};

get_lv_cfg(202,43) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 43,attr = [{1,2094},{2,41688},{3,1059},{4,1047}],cost = [{255,36130001,277}]};

get_lv_cfg(202,44) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 44,attr = [{1,2132},{2,42448},{3,1078},{4,1066}],cost = [{255,36130001,285}]};

get_lv_cfg(202,45) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 45,attr = [{1,2170},{2,43208},{3,1097},{4,1085}],cost = [{255,36130001,294}]};

get_lv_cfg(202,46) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 46,attr = [{1,2208},{2,43968},{3,1116},{4,1104}],cost = [{255,36130001,303}]};

get_lv_cfg(202,47) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 47,attr = [{1,2246},{2,44728},{3,1135},{4,1123}],cost = [{255,36130001,312}]};

get_lv_cfg(202,48) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 48,attr = [{1,2284},{2,45488},{3,1154},{4,1142}],cost = [{255,36130001,321}]};

get_lv_cfg(202,49) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 49,attr = [{1,2322},{2,46248},{3,1173},{4,1161}],cost = [{255,36130001,331}]};

get_lv_cfg(202,50) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 50,attr = [{1,2360},{2,47008},{3,1192},{4,1180}],cost = [{255,36130001,341}]};

get_lv_cfg(202,51) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 51,attr = [{1,2398},{2,47768},{3,1211},{4,1199}],cost = [{255,36130001,351}]};

get_lv_cfg(202,52) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 52,attr = [{1,2436},{2,48528},{3,1230},{4,1218}],cost = [{255,36130001,362}]};

get_lv_cfg(202,53) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 53,attr = [{1,2474},{2,49288},{3,1249},{4,1237}],cost = [{255,36130001,373}]};

get_lv_cfg(202,54) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 54,attr = [{1,2512},{2,50048},{3,1268},{4,1256}],cost = [{255,36130001,384}]};

get_lv_cfg(202,55) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 55,attr = [{1,2550},{2,50808},{3,1287},{4,1275}],cost = [{255,36130001,396}]};

get_lv_cfg(202,56) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 56,attr = [{1,2588},{2,51568},{3,1306},{4,1294}],cost = [{255,36130001,408}]};

get_lv_cfg(202,57) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 57,attr = [{1,2626},{2,52328},{3,1325},{4,1313}],cost = [{255,36130001,420}]};

get_lv_cfg(202,58) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 58,attr = [{1,2664},{2,53088},{3,1344},{4,1332}],cost = [{255,36130001,433}]};

get_lv_cfg(202,59) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 59,attr = [{1,2702},{2,53848},{3,1363},{4,1351}],cost = [{255,36130001,446}]};

get_lv_cfg(202,60) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 60,attr = [{1,2740},{2,54608},{3,1382},{4,1370}],cost = [{255,36130001,459}]};

get_lv_cfg(202,61) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 61,attr = [{1,2778},{2,55368},{3,1401},{4,1389}],cost = [{255,36130001,473}]};

get_lv_cfg(202,62) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 62,attr = [{1,2816},{2,56128},{3,1420},{4,1408}],cost = [{255,36130001,487}]};

get_lv_cfg(202,63) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 63,attr = [{1,2854},{2,56888},{3,1439},{4,1427}],cost = [{255,36130001,502}]};

get_lv_cfg(202,64) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 64,attr = [{1,2892},{2,57648},{3,1458},{4,1446}],cost = [{255,36130001,517}]};

get_lv_cfg(202,65) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 65,attr = [{1,2930},{2,58408},{3,1477},{4,1465}],cost = [{255,36130001,533}]};

get_lv_cfg(202,66) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 66,attr = [{1,2968},{2,59168},{3,1496},{4,1484}],cost = [{255,36130001,549}]};

get_lv_cfg(202,67) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 67,attr = [{1,3006},{2,59928},{3,1515},{4,1503}],cost = [{255,36130001,565}]};

get_lv_cfg(202,68) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 68,attr = [{1,3044},{2,60688},{3,1534},{4,1522}],cost = [{255,36130001,582}]};

get_lv_cfg(202,69) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 69,attr = [{1,3082},{2,61448},{3,1553},{4,1541}],cost = [{255,36130001,599}]};

get_lv_cfg(202,70) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 70,attr = [{1,3120},{2,62208},{3,1572},{4,1560}],cost = [{255,36130001,617}]};

get_lv_cfg(202,71) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 71,attr = [{1,3158},{2,62968},{3,1591},{4,1579}],cost = [{255,36130001,636}]};

get_lv_cfg(202,72) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 72,attr = [{1,3196},{2,63728},{3,1610},{4,1598}],cost = [{255,36130001,655}]};

get_lv_cfg(202,73) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 73,attr = [{1,3234},{2,64488},{3,1629},{4,1617}],cost = [{255,36130001,675}]};

get_lv_cfg(202,74) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 74,attr = [{1,3272},{2,65248},{3,1648},{4,1636}],cost = [{255,36130001,695}]};

get_lv_cfg(202,75) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 75,attr = [{1,3310},{2,66008},{3,1667},{4,1655}],cost = [{255,36130001,716}]};

get_lv_cfg(202,76) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 76,attr = [{1,3348},{2,66768},{3,1686},{4,1674}],cost = [{255,36130001,737}]};

get_lv_cfg(202,77) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 77,attr = [{1,3386},{2,67528},{3,1705},{4,1693}],cost = [{255,36130001,759}]};

get_lv_cfg(202,78) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 78,attr = [{1,3424},{2,68288},{3,1724},{4,1712}],cost = [{255,36130001,782}]};

get_lv_cfg(202,79) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 79,attr = [{1,3462},{2,69048},{3,1743},{4,1731}],cost = [{255,36130001,805}]};

get_lv_cfg(202,80) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 80,attr = [{1,3500},{2,69808},{3,1762},{4,1750}],cost = [{255,36130001,829}]};

get_lv_cfg(202,81) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 81,attr = [{1,3538},{2,70568},{3,1781},{4,1769}],cost = [{255,36130001,854}]};

get_lv_cfg(202,82) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 82,attr = [{1,3576},{2,71328},{3,1800},{4,1788}],cost = [{255,36130001,880}]};

get_lv_cfg(202,83) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 83,attr = [{1,3614},{2,72088},{3,1819},{4,1807}],cost = [{255,36130001,906}]};

get_lv_cfg(202,84) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 84,attr = [{1,3652},{2,72848},{3,1838},{4,1826}],cost = [{255,36130001,933}]};

get_lv_cfg(202,85) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 85,attr = [{1,3690},{2,73608},{3,1857},{4,1845}],cost = [{255,36130001,961}]};

get_lv_cfg(202,86) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 86,attr = [{1,3728},{2,74368},{3,1876},{4,1864}],cost = [{255,36130001,990}]};

get_lv_cfg(202,87) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 87,attr = [{1,3766},{2,75128},{3,1895},{4,1883}],cost = [{255,36130001,1020}]};

get_lv_cfg(202,88) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 88,attr = [{1,3804},{2,75888},{3,1914},{4,1902}],cost = [{255,36130001,1051}]};

get_lv_cfg(202,89) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 89,attr = [{1,3842},{2,76648},{3,1933},{4,1921}],cost = [{255,36130001,1083}]};

get_lv_cfg(202,90) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 90,attr = [{1,3880},{2,77408},{3,1952},{4,1940}],cost = [{255,36130001,1115}]};

get_lv_cfg(202,91) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 91,attr = [{1,3918},{2,78168},{3,1971},{4,1959}],cost = [{255,36130001,1148}]};

get_lv_cfg(202,92) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 92,attr = [{1,3956},{2,78928},{3,1990},{4,1978}],cost = [{255,36130001,1182}]};

get_lv_cfg(202,93) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 93,attr = [{1,3994},{2,79688},{3,2009},{4,1997}],cost = [{255,36130001,1217}]};

get_lv_cfg(202,94) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 94,attr = [{1,4032},{2,80448},{3,2028},{4,2016}],cost = [{255,36130001,1254}]};

get_lv_cfg(202,95) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 95,attr = [{1,4070},{2,81208},{3,2047},{4,2035}],cost = [{255,36130001,1292}]};

get_lv_cfg(202,96) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 96,attr = [{1,4108},{2,81968},{3,2066},{4,2054}],cost = [{255,36130001,1331}]};

get_lv_cfg(202,97) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 97,attr = [{1,4146},{2,82728},{3,2085},{4,2073}],cost = [{255,36130001,1371}]};

get_lv_cfg(202,98) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 98,attr = [{1,4184},{2,83488},{3,2104},{4,2092}],cost = [{255,36130001,1412}]};

get_lv_cfg(202,99) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 99,attr = [{1,4222},{2,84248},{3,2123},{4,2111}],cost = [{255,36130001,1454}]};

get_lv_cfg(202,100) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 100,attr = [{1,4260},{2,85008},{3,2142},{4,2130}],cost = [{255,36130001,1498}]};

get_lv_cfg(202,101) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 101,attr = [{1,4298},{2,85768},{3,2161},{4,2149}],cost = [{255,36130001,1543}]};

get_lv_cfg(202,102) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 102,attr = [{1,4336},{2,86528},{3,2180},{4,2168}],cost = [{255,36130001,1589}]};

get_lv_cfg(202,103) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 103,attr = [{1,4374},{2,87288},{3,2199},{4,2187}],cost = [{255,36130001,1637}]};

get_lv_cfg(202,104) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 104,attr = [{1,4412},{2,88048},{3,2218},{4,2206}],cost = [{255,36130001,1686}]};

get_lv_cfg(202,105) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 105,attr = [{1,4450},{2,88808},{3,2237},{4,2225}],cost = [{255,36130001,1737}]};

get_lv_cfg(202,106) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 106,attr = [{1,4488},{2,89568},{3,2256},{4,2244}],cost = [{255,36130001,1789}]};

get_lv_cfg(202,107) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 107,attr = [{1,4526},{2,90328},{3,2275},{4,2263}],cost = [{255,36130001,1843}]};

get_lv_cfg(202,108) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 108,attr = [{1,4564},{2,91088},{3,2294},{4,2282}],cost = [{255,36130001,1898}]};

get_lv_cfg(202,109) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 109,attr = [{1,4602},{2,91848},{3,2313},{4,2301}],cost = [{255,36130001,1955}]};

get_lv_cfg(202,110) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 110,attr = [{1,4640},{2,92608},{3,2332},{4,2320}],cost = [{255,36130001,2014}]};

get_lv_cfg(202,111) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 111,attr = [{1,4678},{2,93368},{3,2351},{4,2339}],cost = [{255,36130001,2074}]};

get_lv_cfg(202,112) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 112,attr = [{1,4716},{2,94128},{3,2370},{4,2358}],cost = [{255,36130001,2136}]};

get_lv_cfg(202,113) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 113,attr = [{1,4754},{2,94888},{3,2389},{4,2377}],cost = [{255,36130001,2200}]};

get_lv_cfg(202,114) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 114,attr = [{1,4792},{2,95648},{3,2408},{4,2396}],cost = [{255,36130001,2266}]};

get_lv_cfg(202,115) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 115,attr = [{1,4830},{2,96408},{3,2427},{4,2415}],cost = [{255,36130001,2334}]};

get_lv_cfg(202,116) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 116,attr = [{1,4868},{2,97168},{3,2446},{4,2434}],cost = [{255,36130001,2404}]};

get_lv_cfg(202,117) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 117,attr = [{1,4906},{2,97928},{3,2465},{4,2453}],cost = [{255,36130001,2476}]};

get_lv_cfg(202,118) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 118,attr = [{1,4944},{2,98688},{3,2484},{4,2472}],cost = [{255,36130001,2550}]};

get_lv_cfg(202,119) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 119,attr = [{1,4982},{2,99448},{3,2503},{4,2491}],cost = [{255,36130001,2627}]};

get_lv_cfg(202,120) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 120,attr = [{1,5020},{2,100208},{3,2522},{4,2510}],cost = [{255,36130001,2706}]};

get_lv_cfg(202,121) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 121,attr = [{1,5058},{2,100968},{3,2541},{4,2529}],cost = [{255,36130001,2787}]};

get_lv_cfg(202,122) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 122,attr = [{1,5096},{2,101728},{3,2560},{4,2548}],cost = [{255,36130001,2871}]};

get_lv_cfg(202,123) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 123,attr = [{1,5134},{2,102488},{3,2579},{4,2567}],cost = [{255,36130001,2957}]};

get_lv_cfg(202,124) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 124,attr = [{1,5172},{2,103248},{3,2598},{4,2586}],cost = [{255,36130001,3046}]};

get_lv_cfg(202,125) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 125,attr = [{1,5210},{2,104008},{3,2617},{4,2605}],cost = [{255,36130001,3137}]};

get_lv_cfg(202,126) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 126,attr = [{1,5248},{2,104768},{3,2636},{4,2624}],cost = [{255,36130001,3231}]};

get_lv_cfg(202,127) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 127,attr = [{1,5286},{2,105528},{3,2655},{4,2643}],cost = [{255,36130001,3328}]};

get_lv_cfg(202,128) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 128,attr = [{1,5324},{2,106288},{3,2674},{4,2662}],cost = [{255,36130001,3428}]};

get_lv_cfg(202,129) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 129,attr = [{1,5362},{2,107048},{3,2693},{4,2681}],cost = [{255,36130001,3531}]};

get_lv_cfg(202,130) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 130,attr = [{1,5400},{2,107808},{3,2712},{4,2700}],cost = [{255,36130001,3637}]};

get_lv_cfg(202,131) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 131,attr = [{1,5438},{2,108568},{3,2731},{4,2719}],cost = [{255,36130001,3746}]};

get_lv_cfg(202,132) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 132,attr = [{1,5476},{2,109328},{3,2750},{4,2738}],cost = [{255,36130001,3858}]};

get_lv_cfg(202,133) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 133,attr = [{1,5514},{2,110088},{3,2769},{4,2757}],cost = [{255,36130001,3974}]};

get_lv_cfg(202,134) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 134,attr = [{1,5552},{2,110848},{3,2788},{4,2776}],cost = [{255,36130001,4093}]};

get_lv_cfg(202,135) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 135,attr = [{1,5590},{2,111608},{3,2807},{4,2795}],cost = [{255,36130001,4216}]};

get_lv_cfg(202,136) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 136,attr = [{1,5628},{2,112368},{3,2826},{4,2814}],cost = [{255,36130001,4342}]};

get_lv_cfg(202,137) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 137,attr = [{1,5666},{2,113128},{3,2845},{4,2833}],cost = [{255,36130001,4472}]};

get_lv_cfg(202,138) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 138,attr = [{1,5704},{2,113888},{3,2864},{4,2852}],cost = [{255,36130001,4606}]};

get_lv_cfg(202,139) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 139,attr = [{1,5742},{2,114648},{3,2883},{4,2871}],cost = [{255,36130001,4744}]};

get_lv_cfg(202,140) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 140,attr = [{1,5780},{2,115408},{3,2902},{4,2890}],cost = [{255,36130001,4886}]};

get_lv_cfg(202,141) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 141,attr = [{1,5818},{2,116168},{3,2921},{4,2909}],cost = [{255,36130001,5033}]};

get_lv_cfg(202,142) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 142,attr = [{1,5856},{2,116928},{3,2940},{4,2928}],cost = [{255,36130001,5184}]};

get_lv_cfg(202,143) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 143,attr = [{1,5894},{2,117688},{3,2959},{4,2947}],cost = [{255,36130001,5340}]};

get_lv_cfg(202,144) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 144,attr = [{1,5932},{2,118448},{3,2978},{4,2966}],cost = [{255,36130001,5500}]};

get_lv_cfg(202,145) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 145,attr = [{1,5970},{2,119208},{3,2997},{4,2985}],cost = [{255,36130001,5665}]};

get_lv_cfg(202,146) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 146,attr = [{1,6008},{2,119968},{3,3016},{4,3004}],cost = [{255,36130001,5835}]};

get_lv_cfg(202,147) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 147,attr = [{1,6046},{2,120728},{3,3035},{4,3023}],cost = [{255,36130001,6010}]};

get_lv_cfg(202,148) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 148,attr = [{1,6084},{2,121488},{3,3054},{4,3042}],cost = [{255,36130001,6190}]};

get_lv_cfg(202,149) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 149,attr = [{1,6122},{2,122248},{3,3073},{4,3061}],cost = [{255,36130001,6376}]};

get_lv_cfg(202,150) ->
	#artifact_upgrate_cfg{id = 202,name = "命运沙漏",lv = 150,attr = [{1,6160},{2,123008},{3,3092},{4,3080}],cost = [{255,36130001,6567}]};

get_lv_cfg(203,1) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 1,attr = [{1,528},{2,10296},{3,240},{4,270}],cost = [{255,36130001,80}]};

get_lv_cfg(203,2) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 2,attr = [{1,566},{2,11056},{3,259},{4,289}],cost = [{255,36130001,82}]};

get_lv_cfg(203,3) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 3,attr = [{1,604},{2,11816},{3,278},{4,308}],cost = [{255,36130001,84}]};

get_lv_cfg(203,4) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 4,attr = [{1,642},{2,12576},{3,297},{4,327}],cost = [{255,36130001,87}]};

get_lv_cfg(203,5) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 5,attr = [{1,680},{2,13336},{3,316},{4,346}],cost = [{255,36130001,90}]};

get_lv_cfg(203,6) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 6,attr = [{1,718},{2,14096},{3,335},{4,365}],cost = [{255,36130001,93}]};

get_lv_cfg(203,7) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 7,attr = [{1,756},{2,14856},{3,354},{4,384}],cost = [{255,36130001,96}]};

get_lv_cfg(203,8) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 8,attr = [{1,794},{2,15616},{3,373},{4,403}],cost = [{255,36130001,99}]};

get_lv_cfg(203,9) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 9,attr = [{1,832},{2,16376},{3,392},{4,422}],cost = [{255,36130001,102}]};

get_lv_cfg(203,10) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 10,attr = [{1,870},{2,17136},{3,411},{4,441}],cost = [{255,36130001,105}]};

get_lv_cfg(203,11) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 11,attr = [{1,908},{2,17896},{3,430},{4,460}],cost = [{255,36130001,108}]};

get_lv_cfg(203,12) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 12,attr = [{1,946},{2,18656},{3,449},{4,479}],cost = [{255,36130001,111}]};

get_lv_cfg(203,13) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 13,attr = [{1,984},{2,19416},{3,468},{4,498}],cost = [{255,36130001,114}]};

get_lv_cfg(203,14) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 14,attr = [{1,1022},{2,20176},{3,487},{4,517}],cost = [{255,36130001,117}]};

get_lv_cfg(203,15) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 15,attr = [{1,1060},{2,20936},{3,506},{4,536}],cost = [{255,36130001,121}]};

get_lv_cfg(203,16) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 16,attr = [{1,1098},{2,21696},{3,525},{4,555}],cost = [{255,36130001,125}]};

get_lv_cfg(203,17) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 17,attr = [{1,1136},{2,22456},{3,544},{4,574}],cost = [{255,36130001,129}]};

get_lv_cfg(203,18) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 18,attr = [{1,1174},{2,23216},{3,563},{4,593}],cost = [{255,36130001,133}]};

get_lv_cfg(203,19) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 19,attr = [{1,1212},{2,23976},{3,582},{4,612}],cost = [{255,36130001,137}]};

get_lv_cfg(203,20) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 20,attr = [{1,1250},{2,24736},{3,601},{4,631}],cost = [{255,36130001,141}]};

get_lv_cfg(203,21) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 21,attr = [{1,1288},{2,25496},{3,620},{4,650}],cost = [{255,36130001,145}]};

get_lv_cfg(203,22) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 22,attr = [{1,1326},{2,26256},{3,639},{4,669}],cost = [{255,36130001,149}]};

get_lv_cfg(203,23) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 23,attr = [{1,1364},{2,27016},{3,658},{4,688}],cost = [{255,36130001,153}]};

get_lv_cfg(203,24) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 24,attr = [{1,1402},{2,27776},{3,677},{4,707}],cost = [{255,36130001,158}]};

get_lv_cfg(203,25) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 25,attr = [{1,1440},{2,28536},{3,696},{4,726}],cost = [{255,36130001,163}]};

get_lv_cfg(203,26) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 26,attr = [{1,1478},{2,29296},{3,715},{4,745}],cost = [{255,36130001,168}]};

get_lv_cfg(203,27) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 27,attr = [{1,1516},{2,30056},{3,734},{4,764}],cost = [{255,36130001,173}]};

get_lv_cfg(203,28) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 28,attr = [{1,1554},{2,30816},{3,753},{4,783}],cost = [{255,36130001,178}]};

get_lv_cfg(203,29) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 29,attr = [{1,1592},{2,31576},{3,772},{4,802}],cost = [{255,36130001,183}]};

get_lv_cfg(203,30) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 30,attr = [{1,1630},{2,32336},{3,791},{4,821}],cost = [{255,36130001,188}]};

get_lv_cfg(203,31) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 31,attr = [{1,1668},{2,33096},{3,810},{4,840}],cost = [{255,36130001,194}]};

get_lv_cfg(203,32) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 32,attr = [{1,1706},{2,33856},{3,829},{4,859}],cost = [{255,36130001,200}]};

get_lv_cfg(203,33) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 33,attr = [{1,1744},{2,34616},{3,848},{4,878}],cost = [{255,36130001,206}]};

get_lv_cfg(203,34) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 34,attr = [{1,1782},{2,35376},{3,867},{4,897}],cost = [{255,36130001,212}]};

get_lv_cfg(203,35) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 35,attr = [{1,1820},{2,36136},{3,886},{4,916}],cost = [{255,36130001,218}]};

get_lv_cfg(203,36) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 36,attr = [{1,1858},{2,36896},{3,905},{4,935}],cost = [{255,36130001,225}]};

get_lv_cfg(203,37) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 37,attr = [{1,1896},{2,37656},{3,924},{4,954}],cost = [{255,36130001,232}]};

get_lv_cfg(203,38) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 38,attr = [{1,1934},{2,38416},{3,943},{4,973}],cost = [{255,36130001,239}]};

get_lv_cfg(203,39) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 39,attr = [{1,1972},{2,39176},{3,962},{4,992}],cost = [{255,36130001,246}]};

get_lv_cfg(203,40) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 40,attr = [{1,2010},{2,39936},{3,981},{4,1011}],cost = [{255,36130001,253}]};

get_lv_cfg(203,41) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 41,attr = [{1,2048},{2,40696},{3,1000},{4,1030}],cost = [{255,36130001,261}]};

get_lv_cfg(203,42) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 42,attr = [{1,2086},{2,41456},{3,1019},{4,1049}],cost = [{255,36130001,269}]};

get_lv_cfg(203,43) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 43,attr = [{1,2124},{2,42216},{3,1038},{4,1068}],cost = [{255,36130001,277}]};

get_lv_cfg(203,44) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 44,attr = [{1,2162},{2,42976},{3,1057},{4,1087}],cost = [{255,36130001,285}]};

get_lv_cfg(203,45) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 45,attr = [{1,2200},{2,43736},{3,1076},{4,1106}],cost = [{255,36130001,294}]};

get_lv_cfg(203,46) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 46,attr = [{1,2238},{2,44496},{3,1095},{4,1125}],cost = [{255,36130001,303}]};

get_lv_cfg(203,47) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 47,attr = [{1,2276},{2,45256},{3,1114},{4,1144}],cost = [{255,36130001,312}]};

get_lv_cfg(203,48) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 48,attr = [{1,2314},{2,46016},{3,1133},{4,1163}],cost = [{255,36130001,321}]};

get_lv_cfg(203,49) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 49,attr = [{1,2352},{2,46776},{3,1152},{4,1182}],cost = [{255,36130001,331}]};

get_lv_cfg(203,50) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 50,attr = [{1,2390},{2,47536},{3,1171},{4,1201}],cost = [{255,36130001,341}]};

get_lv_cfg(203,51) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 51,attr = [{1,2428},{2,48296},{3,1190},{4,1220}],cost = [{255,36130001,351}]};

get_lv_cfg(203,52) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 52,attr = [{1,2466},{2,49056},{3,1209},{4,1239}],cost = [{255,36130001,362}]};

get_lv_cfg(203,53) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 53,attr = [{1,2504},{2,49816},{3,1228},{4,1258}],cost = [{255,36130001,373}]};

get_lv_cfg(203,54) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 54,attr = [{1,2542},{2,50576},{3,1247},{4,1277}],cost = [{255,36130001,384}]};

get_lv_cfg(203,55) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 55,attr = [{1,2580},{2,51336},{3,1266},{4,1296}],cost = [{255,36130001,396}]};

get_lv_cfg(203,56) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 56,attr = [{1,2618},{2,52096},{3,1285},{4,1315}],cost = [{255,36130001,408}]};

get_lv_cfg(203,57) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 57,attr = [{1,2656},{2,52856},{3,1304},{4,1334}],cost = [{255,36130001,420}]};

get_lv_cfg(203,58) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 58,attr = [{1,2694},{2,53616},{3,1323},{4,1353}],cost = [{255,36130001,433}]};

get_lv_cfg(203,59) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 59,attr = [{1,2732},{2,54376},{3,1342},{4,1372}],cost = [{255,36130001,446}]};

get_lv_cfg(203,60) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 60,attr = [{1,2770},{2,55136},{3,1361},{4,1391}],cost = [{255,36130001,459}]};

get_lv_cfg(203,61) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 61,attr = [{1,2808},{2,55896},{3,1380},{4,1410}],cost = [{255,36130001,473}]};

get_lv_cfg(203,62) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 62,attr = [{1,2846},{2,56656},{3,1399},{4,1429}],cost = [{255,36130001,487}]};

get_lv_cfg(203,63) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 63,attr = [{1,2884},{2,57416},{3,1418},{4,1448}],cost = [{255,36130001,502}]};

get_lv_cfg(203,64) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 64,attr = [{1,2922},{2,58176},{3,1437},{4,1467}],cost = [{255,36130001,517}]};

get_lv_cfg(203,65) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 65,attr = [{1,2960},{2,58936},{3,1456},{4,1486}],cost = [{255,36130001,533}]};

get_lv_cfg(203,66) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 66,attr = [{1,2998},{2,59696},{3,1475},{4,1505}],cost = [{255,36130001,549}]};

get_lv_cfg(203,67) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 67,attr = [{1,3036},{2,60456},{3,1494},{4,1524}],cost = [{255,36130001,565}]};

get_lv_cfg(203,68) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 68,attr = [{1,3074},{2,61216},{3,1513},{4,1543}],cost = [{255,36130001,582}]};

get_lv_cfg(203,69) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 69,attr = [{1,3112},{2,61976},{3,1532},{4,1562}],cost = [{255,36130001,599}]};

get_lv_cfg(203,70) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 70,attr = [{1,3150},{2,62736},{3,1551},{4,1581}],cost = [{255,36130001,617}]};

get_lv_cfg(203,71) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 71,attr = [{1,3188},{2,63496},{3,1570},{4,1600}],cost = [{255,36130001,636}]};

get_lv_cfg(203,72) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 72,attr = [{1,3226},{2,64256},{3,1589},{4,1619}],cost = [{255,36130001,655}]};

get_lv_cfg(203,73) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 73,attr = [{1,3264},{2,65016},{3,1608},{4,1638}],cost = [{255,36130001,675}]};

get_lv_cfg(203,74) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 74,attr = [{1,3302},{2,65776},{3,1627},{4,1657}],cost = [{255,36130001,695}]};

get_lv_cfg(203,75) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 75,attr = [{1,3340},{2,66536},{3,1646},{4,1676}],cost = [{255,36130001,716}]};

get_lv_cfg(203,76) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 76,attr = [{1,3378},{2,67296},{3,1665},{4,1695}],cost = [{255,36130001,737}]};

get_lv_cfg(203,77) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 77,attr = [{1,3416},{2,68056},{3,1684},{4,1714}],cost = [{255,36130001,759}]};

get_lv_cfg(203,78) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 78,attr = [{1,3454},{2,68816},{3,1703},{4,1733}],cost = [{255,36130001,782}]};

get_lv_cfg(203,79) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 79,attr = [{1,3492},{2,69576},{3,1722},{4,1752}],cost = [{255,36130001,805}]};

get_lv_cfg(203,80) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 80,attr = [{1,3530},{2,70336},{3,1741},{4,1771}],cost = [{255,36130001,829}]};

get_lv_cfg(203,81) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 81,attr = [{1,3568},{2,71096},{3,1760},{4,1790}],cost = [{255,36130001,854}]};

get_lv_cfg(203,82) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 82,attr = [{1,3606},{2,71856},{3,1779},{4,1809}],cost = [{255,36130001,880}]};

get_lv_cfg(203,83) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 83,attr = [{1,3644},{2,72616},{3,1798},{4,1828}],cost = [{255,36130001,906}]};

get_lv_cfg(203,84) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 84,attr = [{1,3682},{2,73376},{3,1817},{4,1847}],cost = [{255,36130001,933}]};

get_lv_cfg(203,85) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 85,attr = [{1,3720},{2,74136},{3,1836},{4,1866}],cost = [{255,36130001,961}]};

get_lv_cfg(203,86) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 86,attr = [{1,3758},{2,74896},{3,1855},{4,1885}],cost = [{255,36130001,990}]};

get_lv_cfg(203,87) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 87,attr = [{1,3796},{2,75656},{3,1874},{4,1904}],cost = [{255,36130001,1020}]};

get_lv_cfg(203,88) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 88,attr = [{1,3834},{2,76416},{3,1893},{4,1923}],cost = [{255,36130001,1051}]};

get_lv_cfg(203,89) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 89,attr = [{1,3872},{2,77176},{3,1912},{4,1942}],cost = [{255,36130001,1083}]};

get_lv_cfg(203,90) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 90,attr = [{1,3910},{2,77936},{3,1931},{4,1961}],cost = [{255,36130001,1115}]};

get_lv_cfg(203,91) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 91,attr = [{1,3948},{2,78696},{3,1950},{4,1980}],cost = [{255,36130001,1148}]};

get_lv_cfg(203,92) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 92,attr = [{1,3986},{2,79456},{3,1969},{4,1999}],cost = [{255,36130001,1182}]};

get_lv_cfg(203,93) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 93,attr = [{1,4024},{2,80216},{3,1988},{4,2018}],cost = [{255,36130001,1217}]};

get_lv_cfg(203,94) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 94,attr = [{1,4062},{2,80976},{3,2007},{4,2037}],cost = [{255,36130001,1254}]};

get_lv_cfg(203,95) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 95,attr = [{1,4100},{2,81736},{3,2026},{4,2056}],cost = [{255,36130001,1292}]};

get_lv_cfg(203,96) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 96,attr = [{1,4138},{2,82496},{3,2045},{4,2075}],cost = [{255,36130001,1331}]};

get_lv_cfg(203,97) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 97,attr = [{1,4176},{2,83256},{3,2064},{4,2094}],cost = [{255,36130001,1371}]};

get_lv_cfg(203,98) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 98,attr = [{1,4214},{2,84016},{3,2083},{4,2113}],cost = [{255,36130001,1412}]};

get_lv_cfg(203,99) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 99,attr = [{1,4252},{2,84776},{3,2102},{4,2132}],cost = [{255,36130001,1454}]};

get_lv_cfg(203,100) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 100,attr = [{1,4290},{2,85536},{3,2121},{4,2151}],cost = [{255,36130001,1498}]};

get_lv_cfg(203,101) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 101,attr = [{1,4328},{2,86296},{3,2140},{4,2170}],cost = [{255,36130001,1543}]};

get_lv_cfg(203,102) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 102,attr = [{1,4366},{2,87056},{3,2159},{4,2189}],cost = [{255,36130001,1589}]};

get_lv_cfg(203,103) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 103,attr = [{1,4404},{2,87816},{3,2178},{4,2208}],cost = [{255,36130001,1637}]};

get_lv_cfg(203,104) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 104,attr = [{1,4442},{2,88576},{3,2197},{4,2227}],cost = [{255,36130001,1686}]};

get_lv_cfg(203,105) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 105,attr = [{1,4480},{2,89336},{3,2216},{4,2246}],cost = [{255,36130001,1737}]};

get_lv_cfg(203,106) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 106,attr = [{1,4518},{2,90096},{3,2235},{4,2265}],cost = [{255,36130001,1789}]};

get_lv_cfg(203,107) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 107,attr = [{1,4556},{2,90856},{3,2254},{4,2284}],cost = [{255,36130001,1843}]};

get_lv_cfg(203,108) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 108,attr = [{1,4594},{2,91616},{3,2273},{4,2303}],cost = [{255,36130001,1898}]};

get_lv_cfg(203,109) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 109,attr = [{1,4632},{2,92376},{3,2292},{4,2322}],cost = [{255,36130001,1955}]};

get_lv_cfg(203,110) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 110,attr = [{1,4670},{2,93136},{3,2311},{4,2341}],cost = [{255,36130001,2014}]};

get_lv_cfg(203,111) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 111,attr = [{1,4708},{2,93896},{3,2330},{4,2360}],cost = [{255,36130001,2074}]};

get_lv_cfg(203,112) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 112,attr = [{1,4746},{2,94656},{3,2349},{4,2379}],cost = [{255,36130001,2136}]};

get_lv_cfg(203,113) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 113,attr = [{1,4784},{2,95416},{3,2368},{4,2398}],cost = [{255,36130001,2200}]};

get_lv_cfg(203,114) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 114,attr = [{1,4822},{2,96176},{3,2387},{4,2417}],cost = [{255,36130001,2266}]};

get_lv_cfg(203,115) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 115,attr = [{1,4860},{2,96936},{3,2406},{4,2436}],cost = [{255,36130001,2334}]};

get_lv_cfg(203,116) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 116,attr = [{1,4898},{2,97696},{3,2425},{4,2455}],cost = [{255,36130001,2404}]};

get_lv_cfg(203,117) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 117,attr = [{1,4936},{2,98456},{3,2444},{4,2474}],cost = [{255,36130001,2476}]};

get_lv_cfg(203,118) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 118,attr = [{1,4974},{2,99216},{3,2463},{4,2493}],cost = [{255,36130001,2550}]};

get_lv_cfg(203,119) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 119,attr = [{1,5012},{2,99976},{3,2482},{4,2512}],cost = [{255,36130001,2627}]};

get_lv_cfg(203,120) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 120,attr = [{1,5050},{2,100736},{3,2501},{4,2531}],cost = [{255,36130001,2706}]};

get_lv_cfg(203,121) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 121,attr = [{1,5088},{2,101496},{3,2520},{4,2550}],cost = [{255,36130001,2787}]};

get_lv_cfg(203,122) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 122,attr = [{1,5126},{2,102256},{3,2539},{4,2569}],cost = [{255,36130001,2871}]};

get_lv_cfg(203,123) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 123,attr = [{1,5164},{2,103016},{3,2558},{4,2588}],cost = [{255,36130001,2957}]};

get_lv_cfg(203,124) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 124,attr = [{1,5202},{2,103776},{3,2577},{4,2607}],cost = [{255,36130001,3046}]};

get_lv_cfg(203,125) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 125,attr = [{1,5240},{2,104536},{3,2596},{4,2626}],cost = [{255,36130001,3137}]};

get_lv_cfg(203,126) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 126,attr = [{1,5278},{2,105296},{3,2615},{4,2645}],cost = [{255,36130001,3231}]};

get_lv_cfg(203,127) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 127,attr = [{1,5316},{2,106056},{3,2634},{4,2664}],cost = [{255,36130001,3328}]};

get_lv_cfg(203,128) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 128,attr = [{1,5354},{2,106816},{3,2653},{4,2683}],cost = [{255,36130001,3428}]};

get_lv_cfg(203,129) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 129,attr = [{1,5392},{2,107576},{3,2672},{4,2702}],cost = [{255,36130001,3531}]};

get_lv_cfg(203,130) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 130,attr = [{1,5430},{2,108336},{3,2691},{4,2721}],cost = [{255,36130001,3637}]};

get_lv_cfg(203,131) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 131,attr = [{1,5468},{2,109096},{3,2710},{4,2740}],cost = [{255,36130001,3746}]};

get_lv_cfg(203,132) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 132,attr = [{1,5506},{2,109856},{3,2729},{4,2759}],cost = [{255,36130001,3858}]};

get_lv_cfg(203,133) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 133,attr = [{1,5544},{2,110616},{3,2748},{4,2778}],cost = [{255,36130001,3974}]};

get_lv_cfg(203,134) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 134,attr = [{1,5582},{2,111376},{3,2767},{4,2797}],cost = [{255,36130001,4093}]};

get_lv_cfg(203,135) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 135,attr = [{1,5620},{2,112136},{3,2786},{4,2816}],cost = [{255,36130001,4216}]};

get_lv_cfg(203,136) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 136,attr = [{1,5658},{2,112896},{3,2805},{4,2835}],cost = [{255,36130001,4342}]};

get_lv_cfg(203,137) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 137,attr = [{1,5696},{2,113656},{3,2824},{4,2854}],cost = [{255,36130001,4472}]};

get_lv_cfg(203,138) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 138,attr = [{1,5734},{2,114416},{3,2843},{4,2873}],cost = [{255,36130001,4606}]};

get_lv_cfg(203,139) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 139,attr = [{1,5772},{2,115176},{3,2862},{4,2892}],cost = [{255,36130001,4744}]};

get_lv_cfg(203,140) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 140,attr = [{1,5810},{2,115936},{3,2881},{4,2911}],cost = [{255,36130001,4886}]};

get_lv_cfg(203,141) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 141,attr = [{1,5848},{2,116696},{3,2900},{4,2930}],cost = [{255,36130001,5033}]};

get_lv_cfg(203,142) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 142,attr = [{1,5886},{2,117456},{3,2919},{4,2949}],cost = [{255,36130001,5184}]};

get_lv_cfg(203,143) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 143,attr = [{1,5924},{2,118216},{3,2938},{4,2968}],cost = [{255,36130001,5340}]};

get_lv_cfg(203,144) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 144,attr = [{1,5962},{2,118976},{3,2957},{4,2987}],cost = [{255,36130001,5500}]};

get_lv_cfg(203,145) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 145,attr = [{1,6000},{2,119736},{3,2976},{4,3006}],cost = [{255,36130001,5665}]};

get_lv_cfg(203,146) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 146,attr = [{1,6038},{2,120496},{3,2995},{4,3025}],cost = [{255,36130001,5835}]};

get_lv_cfg(203,147) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 147,attr = [{1,6076},{2,121256},{3,3014},{4,3044}],cost = [{255,36130001,6010}]};

get_lv_cfg(203,148) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 148,attr = [{1,6114},{2,122016},{3,3033},{4,3063}],cost = [{255,36130001,6190}]};

get_lv_cfg(203,149) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 149,attr = [{1,6152},{2,122776},{3,3052},{4,3082}],cost = [{255,36130001,6376}]};

get_lv_cfg(203,150) ->
	#artifact_upgrate_cfg{id = 203,name = "审批天平",lv = 150,attr = [{1,6190},{2,123536},{3,3071},{4,3101}],cost = [{255,36130001,6567}]};

get_lv_cfg(301,1) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 1,attr = [{1,948},{2,19872},{3,498},{4,462}],cost = [{255,36140001,65}]};

get_lv_cfg(301,2) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 2,attr = [{1,1010},{2,21112},{3,529},{4,493}],cost = [{255,36140001,67}]};

get_lv_cfg(301,3) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 3,attr = [{1,1072},{2,22352},{3,560},{4,524}],cost = [{255,36140001,69}]};

get_lv_cfg(301,4) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 4,attr = [{1,1134},{2,23592},{3,591},{4,555}],cost = [{255,36140001,71}]};

get_lv_cfg(301,5) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 5,attr = [{1,1196},{2,24832},{3,622},{4,586}],cost = [{255,36140001,73}]};

get_lv_cfg(301,6) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 6,attr = [{1,1258},{2,26072},{3,653},{4,617}],cost = [{255,36140001,75}]};

get_lv_cfg(301,7) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 7,attr = [{1,1320},{2,27312},{3,684},{4,648}],cost = [{255,36140001,77}]};

get_lv_cfg(301,8) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 8,attr = [{1,1382},{2,28552},{3,715},{4,679}],cost = [{255,36140001,79}]};

get_lv_cfg(301,9) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 9,attr = [{1,1444},{2,29792},{3,746},{4,710}],cost = [{255,36140001,81}]};

get_lv_cfg(301,10) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 10,attr = [{1,1506},{2,31032},{3,777},{4,741}],cost = [{255,36140001,83}]};

get_lv_cfg(301,11) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 11,attr = [{1,1568},{2,32272},{3,808},{4,772}],cost = [{255,36140001,85}]};

get_lv_cfg(301,12) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 12,attr = [{1,1630},{2,33512},{3,839},{4,803}],cost = [{255,36140001,88}]};

get_lv_cfg(301,13) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 13,attr = [{1,1692},{2,34752},{3,870},{4,834}],cost = [{255,36140001,91}]};

get_lv_cfg(301,14) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 14,attr = [{1,1754},{2,35992},{3,901},{4,865}],cost = [{255,36140001,94}]};

get_lv_cfg(301,15) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 15,attr = [{1,1816},{2,37232},{3,932},{4,896}],cost = [{255,36140001,97}]};

get_lv_cfg(301,16) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 16,attr = [{1,1878},{2,38472},{3,963},{4,927}],cost = [{255,36140001,100}]};

get_lv_cfg(301,17) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 17,attr = [{1,1940},{2,39712},{3,994},{4,958}],cost = [{255,36140001,103}]};

get_lv_cfg(301,18) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 18,attr = [{1,2002},{2,40952},{3,1025},{4,989}],cost = [{255,36140001,106}]};

get_lv_cfg(301,19) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 19,attr = [{1,2064},{2,42192},{3,1056},{4,1020}],cost = [{255,36140001,109}]};

get_lv_cfg(301,20) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 20,attr = [{1,2126},{2,43432},{3,1087},{4,1051}],cost = [{255,36140001,112}]};

get_lv_cfg(301,21) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 21,attr = [{1,2188},{2,44672},{3,1118},{4,1082}],cost = [{255,36140001,115}]};

get_lv_cfg(301,22) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 22,attr = [{1,2250},{2,45912},{3,1149},{4,1113}],cost = [{255,36140001,118}]};

get_lv_cfg(301,23) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 23,attr = [{1,2312},{2,47152},{3,1180},{4,1144}],cost = [{255,36140001,122}]};

get_lv_cfg(301,24) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 24,attr = [{1,2374},{2,48392},{3,1211},{4,1175}],cost = [{255,36140001,126}]};

get_lv_cfg(301,25) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 25,attr = [{1,2436},{2,49632},{3,1242},{4,1206}],cost = [{255,36140001,130}]};

get_lv_cfg(301,26) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 26,attr = [{1,2498},{2,50872},{3,1273},{4,1237}],cost = [{255,36140001,134}]};

get_lv_cfg(301,27) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 27,attr = [{1,2560},{2,52112},{3,1304},{4,1268}],cost = [{255,36140001,138}]};

get_lv_cfg(301,28) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 28,attr = [{1,2622},{2,53352},{3,1335},{4,1299}],cost = [{255,36140001,142}]};

get_lv_cfg(301,29) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 29,attr = [{1,2684},{2,54592},{3,1366},{4,1330}],cost = [{255,36140001,146}]};

get_lv_cfg(301,30) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 30,attr = [{1,2746},{2,55832},{3,1397},{4,1361}],cost = [{255,36140001,150}]};

get_lv_cfg(301,31) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 31,attr = [{1,2808},{2,57072},{3,1428},{4,1392}],cost = [{255,36140001,155}]};

get_lv_cfg(301,32) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 32,attr = [{1,2870},{2,58312},{3,1459},{4,1423}],cost = [{255,36140001,160}]};

get_lv_cfg(301,33) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 33,attr = [{1,2932},{2,59552},{3,1490},{4,1454}],cost = [{255,36140001,165}]};

get_lv_cfg(301,34) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 34,attr = [{1,2994},{2,60792},{3,1521},{4,1485}],cost = [{255,36140001,170}]};

get_lv_cfg(301,35) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 35,attr = [{1,3056},{2,62032},{3,1552},{4,1516}],cost = [{255,36140001,175}]};

get_lv_cfg(301,36) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 36,attr = [{1,3118},{2,63272},{3,1583},{4,1547}],cost = [{255,36140001,180}]};

get_lv_cfg(301,37) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 37,attr = [{1,3180},{2,64512},{3,1614},{4,1578}],cost = [{255,36140001,185}]};

get_lv_cfg(301,38) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 38,attr = [{1,3242},{2,65752},{3,1645},{4,1609}],cost = [{255,36140001,191}]};

get_lv_cfg(301,39) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 39,attr = [{1,3304},{2,66992},{3,1676},{4,1640}],cost = [{255,36140001,197}]};

get_lv_cfg(301,40) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 40,attr = [{1,3366},{2,68232},{3,1707},{4,1671}],cost = [{255,36140001,203}]};

get_lv_cfg(301,41) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 41,attr = [{1,3428},{2,69472},{3,1738},{4,1702}],cost = [{255,36140001,209}]};

get_lv_cfg(301,42) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 42,attr = [{1,3490},{2,70712},{3,1769},{4,1733}],cost = [{255,36140001,215}]};

get_lv_cfg(301,43) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 43,attr = [{1,3552},{2,71952},{3,1800},{4,1764}],cost = [{255,36140001,221}]};

get_lv_cfg(301,44) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 44,attr = [{1,3614},{2,73192},{3,1831},{4,1795}],cost = [{255,36140001,228}]};

get_lv_cfg(301,45) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 45,attr = [{1,3676},{2,74432},{3,1862},{4,1826}],cost = [{255,36140001,235}]};

get_lv_cfg(301,46) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 46,attr = [{1,3738},{2,75672},{3,1893},{4,1857}],cost = [{255,36140001,242}]};

get_lv_cfg(301,47) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 47,attr = [{1,3800},{2,76912},{3,1924},{4,1888}],cost = [{255,36140001,249}]};

get_lv_cfg(301,48) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 48,attr = [{1,3862},{2,78152},{3,1955},{4,1919}],cost = [{255,36140001,256}]};

get_lv_cfg(301,49) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 49,attr = [{1,3924},{2,79392},{3,1986},{4,1950}],cost = [{255,36140001,264}]};

get_lv_cfg(301,50) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 50,attr = [{1,3986},{2,80632},{3,2017},{4,1981}],cost = [{255,36140001,272}]};

get_lv_cfg(301,51) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 51,attr = [{1,4048},{2,81872},{3,2048},{4,2012}],cost = [{255,36140001,280}]};

get_lv_cfg(301,52) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 52,attr = [{1,4110},{2,83112},{3,2079},{4,2043}],cost = [{255,36140001,288}]};

get_lv_cfg(301,53) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 53,attr = [{1,4172},{2,84352},{3,2110},{4,2074}],cost = [{255,36140001,297}]};

get_lv_cfg(301,54) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 54,attr = [{1,4234},{2,85592},{3,2141},{4,2105}],cost = [{255,36140001,306}]};

get_lv_cfg(301,55) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 55,attr = [{1,4296},{2,86832},{3,2172},{4,2136}],cost = [{255,36140001,315}]};

get_lv_cfg(301,56) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 56,attr = [{1,4358},{2,88072},{3,2203},{4,2167}],cost = [{255,36140001,324}]};

get_lv_cfg(301,57) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 57,attr = [{1,4420},{2,89312},{3,2234},{4,2198}],cost = [{255,36140001,334}]};

get_lv_cfg(301,58) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 58,attr = [{1,4482},{2,90552},{3,2265},{4,2229}],cost = [{255,36140001,344}]};

get_lv_cfg(301,59) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 59,attr = [{1,4544},{2,91792},{3,2296},{4,2260}],cost = [{255,36140001,354}]};

get_lv_cfg(301,60) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 60,attr = [{1,4606},{2,93032},{3,2327},{4,2291}],cost = [{255,36140001,365}]};

get_lv_cfg(301,61) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 61,attr = [{1,4668},{2,94272},{3,2358},{4,2322}],cost = [{255,36140001,376}]};

get_lv_cfg(301,62) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 62,attr = [{1,4730},{2,95512},{3,2389},{4,2353}],cost = [{255,36140001,387}]};

get_lv_cfg(301,63) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 63,attr = [{1,4792},{2,96752},{3,2420},{4,2384}],cost = [{255,36140001,399}]};

get_lv_cfg(301,64) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 64,attr = [{1,4854},{2,97992},{3,2451},{4,2415}],cost = [{255,36140001,411}]};

get_lv_cfg(301,65) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 65,attr = [{1,4916},{2,99232},{3,2482},{4,2446}],cost = [{255,36140001,423}]};

get_lv_cfg(301,66) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 66,attr = [{1,4978},{2,100472},{3,2513},{4,2477}],cost = [{255,36140001,436}]};

get_lv_cfg(301,67) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 67,attr = [{1,5040},{2,101712},{3,2544},{4,2508}],cost = [{255,36140001,449}]};

get_lv_cfg(301,68) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 68,attr = [{1,5102},{2,102952},{3,2575},{4,2539}],cost = [{255,36140001,462}]};

get_lv_cfg(301,69) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 69,attr = [{1,5164},{2,104192},{3,2606},{4,2570}],cost = [{255,36140001,476}]};

get_lv_cfg(301,70) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 70,attr = [{1,5226},{2,105432},{3,2637},{4,2601}],cost = [{255,36140001,490}]};

get_lv_cfg(301,71) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 71,attr = [{1,5288},{2,106672},{3,2668},{4,2632}],cost = [{255,36140001,505}]};

get_lv_cfg(301,72) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 72,attr = [{1,5350},{2,107912},{3,2699},{4,2663}],cost = [{255,36140001,520}]};

get_lv_cfg(301,73) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 73,attr = [{1,5412},{2,109152},{3,2730},{4,2694}],cost = [{255,36140001,536}]};

get_lv_cfg(301,74) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 74,attr = [{1,5474},{2,110392},{3,2761},{4,2725}],cost = [{255,36140001,552}]};

get_lv_cfg(301,75) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 75,attr = [{1,5536},{2,111632},{3,2792},{4,2756}],cost = [{255,36140001,569}]};

get_lv_cfg(301,76) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 76,attr = [{1,5598},{2,112872},{3,2823},{4,2787}],cost = [{255,36140001,586}]};

get_lv_cfg(301,77) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 77,attr = [{1,5660},{2,114112},{3,2854},{4,2818}],cost = [{255,36140001,604}]};

get_lv_cfg(301,78) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 78,attr = [{1,5722},{2,115352},{3,2885},{4,2849}],cost = [{255,36140001,622}]};

get_lv_cfg(301,79) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 79,attr = [{1,5784},{2,116592},{3,2916},{4,2880}],cost = [{255,36140001,641}]};

get_lv_cfg(301,80) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 80,attr = [{1,5846},{2,117832},{3,2947},{4,2911}],cost = [{255,36140001,660}]};

get_lv_cfg(301,81) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 81,attr = [{1,5908},{2,119072},{3,2978},{4,2942}],cost = [{255,36140001,680}]};

get_lv_cfg(301,82) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 82,attr = [{1,5970},{2,120312},{3,3009},{4,2973}],cost = [{255,36140001,700}]};

get_lv_cfg(301,83) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 83,attr = [{1,6032},{2,121552},{3,3040},{4,3004}],cost = [{255,36140001,721}]};

get_lv_cfg(301,84) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 84,attr = [{1,6094},{2,122792},{3,3071},{4,3035}],cost = [{255,36140001,743}]};

get_lv_cfg(301,85) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 85,attr = [{1,6156},{2,124032},{3,3102},{4,3066}],cost = [{255,36140001,765}]};

get_lv_cfg(301,86) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 86,attr = [{1,6218},{2,125272},{3,3133},{4,3097}],cost = [{255,36140001,788}]};

get_lv_cfg(301,87) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 87,attr = [{1,6280},{2,126512},{3,3164},{4,3128}],cost = [{255,36140001,812}]};

get_lv_cfg(301,88) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 88,attr = [{1,6342},{2,127752},{3,3195},{4,3159}],cost = [{255,36140001,836}]};

get_lv_cfg(301,89) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 89,attr = [{1,6404},{2,128992},{3,3226},{4,3190}],cost = [{255,36140001,861}]};

get_lv_cfg(301,90) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 90,attr = [{1,6466},{2,130232},{3,3257},{4,3221}],cost = [{255,36140001,887}]};

get_lv_cfg(301,91) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 91,attr = [{1,6528},{2,131472},{3,3288},{4,3252}],cost = [{255,36140001,914}]};

get_lv_cfg(301,92) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 92,attr = [{1,6590},{2,132712},{3,3319},{4,3283}],cost = [{255,36140001,941}]};

get_lv_cfg(301,93) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 93,attr = [{1,6652},{2,133952},{3,3350},{4,3314}],cost = [{255,36140001,969}]};

get_lv_cfg(301,94) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 94,attr = [{1,6714},{2,135192},{3,3381},{4,3345}],cost = [{255,36140001,998}]};

get_lv_cfg(301,95) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 95,attr = [{1,6776},{2,136432},{3,3412},{4,3376}],cost = [{255,36140001,1028}]};

get_lv_cfg(301,96) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 96,attr = [{1,6838},{2,137672},{3,3443},{4,3407}],cost = [{255,36140001,1059}]};

get_lv_cfg(301,97) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 97,attr = [{1,6900},{2,138912},{3,3474},{4,3438}],cost = [{255,36140001,1091}]};

get_lv_cfg(301,98) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 98,attr = [{1,6962},{2,140152},{3,3505},{4,3469}],cost = [{255,36140001,1124}]};

get_lv_cfg(301,99) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 99,attr = [{1,7024},{2,141392},{3,3536},{4,3500}],cost = [{255,36140001,1158}]};

get_lv_cfg(301,100) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 100,attr = [{1,7086},{2,142632},{3,3567},{4,3531}],cost = [{255,36140001,1193}]};

get_lv_cfg(301,101) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 101,attr = [{1,7148},{2,143872},{3,3598},{4,3562}],cost = [{255,36140001,1229}]};

get_lv_cfg(301,102) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 102,attr = [{1,7210},{2,145112},{3,3629},{4,3593}],cost = [{255,36140001,1266}]};

get_lv_cfg(301,103) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 103,attr = [{1,7272},{2,146352},{3,3660},{4,3624}],cost = [{255,36140001,1304}]};

get_lv_cfg(301,104) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 104,attr = [{1,7334},{2,147592},{3,3691},{4,3655}],cost = [{255,36140001,1343}]};

get_lv_cfg(301,105) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 105,attr = [{1,7396},{2,148832},{3,3722},{4,3686}],cost = [{255,36140001,1383}]};

get_lv_cfg(301,106) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 106,attr = [{1,7458},{2,150072},{3,3753},{4,3717}],cost = [{255,36140001,1424}]};

get_lv_cfg(301,107) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 107,attr = [{1,7520},{2,151312},{3,3784},{4,3748}],cost = [{255,36140001,1467}]};

get_lv_cfg(301,108) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 108,attr = [{1,7582},{2,152552},{3,3815},{4,3779}],cost = [{255,36140001,1511}]};

get_lv_cfg(301,109) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 109,attr = [{1,7644},{2,153792},{3,3846},{4,3810}],cost = [{255,36140001,1556}]};

get_lv_cfg(301,110) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 110,attr = [{1,7706},{2,155032},{3,3877},{4,3841}],cost = [{255,36140001,1603}]};

get_lv_cfg(301,111) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 111,attr = [{1,7768},{2,156272},{3,3908},{4,3872}],cost = [{255,36140001,1651}]};

get_lv_cfg(301,112) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 112,attr = [{1,7830},{2,157512},{3,3939},{4,3903}],cost = [{255,36140001,1701}]};

get_lv_cfg(301,113) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 113,attr = [{1,7892},{2,158752},{3,3970},{4,3934}],cost = [{255,36140001,1752}]};

get_lv_cfg(301,114) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 114,attr = [{1,7954},{2,159992},{3,4001},{4,3965}],cost = [{255,36140001,1805}]};

get_lv_cfg(301,115) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 115,attr = [{1,8016},{2,161232},{3,4032},{4,3996}],cost = [{255,36140001,1859}]};

get_lv_cfg(301,116) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 116,attr = [{1,8078},{2,162472},{3,4063},{4,4027}],cost = [{255,36140001,1915}]};

get_lv_cfg(301,117) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 117,attr = [{1,8140},{2,163712},{3,4094},{4,4058}],cost = [{255,36140001,1972}]};

get_lv_cfg(301,118) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 118,attr = [{1,8202},{2,164952},{3,4125},{4,4089}],cost = [{255,36140001,2031}]};

get_lv_cfg(301,119) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 119,attr = [{1,8264},{2,166192},{3,4156},{4,4120}],cost = [{255,36140001,2092}]};

get_lv_cfg(301,120) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 120,attr = [{1,8326},{2,167432},{3,4187},{4,4151}],cost = [{255,36140001,2155}]};

get_lv_cfg(301,121) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 121,attr = [{1,8388},{2,168672},{3,4218},{4,4182}],cost = [{255,36140001,2220}]};

get_lv_cfg(301,122) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 122,attr = [{1,8450},{2,169912},{3,4249},{4,4213}],cost = [{255,36140001,2287}]};

get_lv_cfg(301,123) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 123,attr = [{1,8512},{2,171152},{3,4280},{4,4244}],cost = [{255,36140001,2356}]};

get_lv_cfg(301,124) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 124,attr = [{1,8574},{2,172392},{3,4311},{4,4275}],cost = [{255,36140001,2427}]};

get_lv_cfg(301,125) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 125,attr = [{1,8636},{2,173632},{3,4342},{4,4306}],cost = [{255,36140001,2500}]};

get_lv_cfg(301,126) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 126,attr = [{1,8698},{2,174872},{3,4373},{4,4337}],cost = [{255,36140001,2575}]};

get_lv_cfg(301,127) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 127,attr = [{1,8760},{2,176112},{3,4404},{4,4368}],cost = [{255,36140001,2652}]};

get_lv_cfg(301,128) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 128,attr = [{1,8822},{2,177352},{3,4435},{4,4399}],cost = [{255,36140001,2732}]};

get_lv_cfg(301,129) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 129,attr = [{1,8884},{2,178592},{3,4466},{4,4430}],cost = [{255,36140001,2814}]};

get_lv_cfg(301,130) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 130,attr = [{1,8946},{2,179832},{3,4497},{4,4461}],cost = [{255,36140001,2898}]};

get_lv_cfg(301,131) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 131,attr = [{1,9008},{2,181072},{3,4528},{4,4492}],cost = [{255,36140001,2985}]};

get_lv_cfg(301,132) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 132,attr = [{1,9070},{2,182312},{3,4559},{4,4523}],cost = [{255,36140001,3075}]};

get_lv_cfg(301,133) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 133,attr = [{1,9132},{2,183552},{3,4590},{4,4554}],cost = [{255,36140001,3167}]};

get_lv_cfg(301,134) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 134,attr = [{1,9194},{2,184792},{3,4621},{4,4585}],cost = [{255,36140001,3262}]};

get_lv_cfg(301,135) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 135,attr = [{1,9256},{2,186032},{3,4652},{4,4616}],cost = [{255,36140001,3360}]};

get_lv_cfg(301,136) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 136,attr = [{1,9318},{2,187272},{3,4683},{4,4647}],cost = [{255,36140001,3461}]};

get_lv_cfg(301,137) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 137,attr = [{1,9380},{2,188512},{3,4714},{4,4678}],cost = [{255,36140001,3565}]};

get_lv_cfg(301,138) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 138,attr = [{1,9442},{2,189752},{3,4745},{4,4709}],cost = [{255,36140001,3672}]};

get_lv_cfg(301,139) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 139,attr = [{1,9504},{2,190992},{3,4776},{4,4740}],cost = [{255,36140001,3782}]};

get_lv_cfg(301,140) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 140,attr = [{1,9566},{2,192232},{3,4807},{4,4771}],cost = [{255,36140001,3895}]};

get_lv_cfg(301,141) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 141,attr = [{1,9628},{2,193472},{3,4838},{4,4802}],cost = [{255,36140001,4012}]};

get_lv_cfg(301,142) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 142,attr = [{1,9690},{2,194712},{3,4869},{4,4833}],cost = [{255,36140001,4132}]};

get_lv_cfg(301,143) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 143,attr = [{1,9752},{2,195952},{3,4900},{4,4864}],cost = [{255,36140001,4256}]};

get_lv_cfg(301,144) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 144,attr = [{1,9814},{2,197192},{3,4931},{4,4895}],cost = [{255,36140001,4384}]};

get_lv_cfg(301,145) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 145,attr = [{1,9876},{2,198432},{3,4962},{4,4926}],cost = [{255,36140001,4516}]};

get_lv_cfg(301,146) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 146,attr = [{1,9938},{2,199672},{3,4993},{4,4957}],cost = [{255,36140001,4651}]};

get_lv_cfg(301,147) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 147,attr = [{1,10000},{2,200912},{3,5024},{4,4988}],cost = [{255,36140001,4791}]};

get_lv_cfg(301,148) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 148,attr = [{1,10062},{2,202152},{3,5055},{4,5019}],cost = [{255,36140001,4935}]};

get_lv_cfg(301,149) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 149,attr = [{1,10124},{2,203392},{3,5086},{4,5050}],cost = [{255,36140001,5083}]};

get_lv_cfg(301,150) ->
	#artifact_upgrate_cfg{id = 301,name = "雷神之锤",lv = 150,attr = [{1,10186},{2,204632},{3,5117},{4,5081}],cost = [{255,36140001,5235}]};

get_lv_cfg(302,1) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 1,attr = [{1,996},{2,19536},{3,522},{4,498}],cost = [{255,36140001,65}]};

get_lv_cfg(302,2) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 2,attr = [{1,1058},{2,20776},{3,553},{4,529}],cost = [{255,36140001,67}]};

get_lv_cfg(302,3) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 3,attr = [{1,1120},{2,22016},{3,584},{4,560}],cost = [{255,36140001,69}]};

get_lv_cfg(302,4) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 4,attr = [{1,1182},{2,23256},{3,615},{4,591}],cost = [{255,36140001,71}]};

get_lv_cfg(302,5) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 5,attr = [{1,1244},{2,24496},{3,646},{4,622}],cost = [{255,36140001,73}]};

get_lv_cfg(302,6) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 6,attr = [{1,1306},{2,25736},{3,677},{4,653}],cost = [{255,36140001,75}]};

get_lv_cfg(302,7) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 7,attr = [{1,1368},{2,26976},{3,708},{4,684}],cost = [{255,36140001,77}]};

get_lv_cfg(302,8) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 8,attr = [{1,1430},{2,28216},{3,739},{4,715}],cost = [{255,36140001,79}]};

get_lv_cfg(302,9) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 9,attr = [{1,1492},{2,29456},{3,770},{4,746}],cost = [{255,36140001,81}]};

get_lv_cfg(302,10) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 10,attr = [{1,1554},{2,30696},{3,801},{4,777}],cost = [{255,36140001,83}]};

get_lv_cfg(302,11) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 11,attr = [{1,1616},{2,31936},{3,832},{4,808}],cost = [{255,36140001,85}]};

get_lv_cfg(302,12) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 12,attr = [{1,1678},{2,33176},{3,863},{4,839}],cost = [{255,36140001,88}]};

get_lv_cfg(302,13) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 13,attr = [{1,1740},{2,34416},{3,894},{4,870}],cost = [{255,36140001,91}]};

get_lv_cfg(302,14) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 14,attr = [{1,1802},{2,35656},{3,925},{4,901}],cost = [{255,36140001,94}]};

get_lv_cfg(302,15) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 15,attr = [{1,1864},{2,36896},{3,956},{4,932}],cost = [{255,36140001,97}]};

get_lv_cfg(302,16) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 16,attr = [{1,1926},{2,38136},{3,987},{4,963}],cost = [{255,36140001,100}]};

get_lv_cfg(302,17) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 17,attr = [{1,1988},{2,39376},{3,1018},{4,994}],cost = [{255,36140001,103}]};

get_lv_cfg(302,18) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 18,attr = [{1,2050},{2,40616},{3,1049},{4,1025}],cost = [{255,36140001,106}]};

get_lv_cfg(302,19) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 19,attr = [{1,2112},{2,41856},{3,1080},{4,1056}],cost = [{255,36140001,109}]};

get_lv_cfg(302,20) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 20,attr = [{1,2174},{2,43096},{3,1111},{4,1087}],cost = [{255,36140001,112}]};

get_lv_cfg(302,21) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 21,attr = [{1,2236},{2,44336},{3,1142},{4,1118}],cost = [{255,36140001,115}]};

get_lv_cfg(302,22) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 22,attr = [{1,2298},{2,45576},{3,1173},{4,1149}],cost = [{255,36140001,118}]};

get_lv_cfg(302,23) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 23,attr = [{1,2360},{2,46816},{3,1204},{4,1180}],cost = [{255,36140001,122}]};

get_lv_cfg(302,24) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 24,attr = [{1,2422},{2,48056},{3,1235},{4,1211}],cost = [{255,36140001,126}]};

get_lv_cfg(302,25) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 25,attr = [{1,2484},{2,49296},{3,1266},{4,1242}],cost = [{255,36140001,130}]};

get_lv_cfg(302,26) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 26,attr = [{1,2546},{2,50536},{3,1297},{4,1273}],cost = [{255,36140001,134}]};

get_lv_cfg(302,27) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 27,attr = [{1,2608},{2,51776},{3,1328},{4,1304}],cost = [{255,36140001,138}]};

get_lv_cfg(302,28) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 28,attr = [{1,2670},{2,53016},{3,1359},{4,1335}],cost = [{255,36140001,142}]};

get_lv_cfg(302,29) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 29,attr = [{1,2732},{2,54256},{3,1390},{4,1366}],cost = [{255,36140001,146}]};

get_lv_cfg(302,30) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 30,attr = [{1,2794},{2,55496},{3,1421},{4,1397}],cost = [{255,36140001,150}]};

get_lv_cfg(302,31) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 31,attr = [{1,2856},{2,56736},{3,1452},{4,1428}],cost = [{255,36140001,155}]};

get_lv_cfg(302,32) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 32,attr = [{1,2918},{2,57976},{3,1483},{4,1459}],cost = [{255,36140001,160}]};

get_lv_cfg(302,33) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 33,attr = [{1,2980},{2,59216},{3,1514},{4,1490}],cost = [{255,36140001,165}]};

get_lv_cfg(302,34) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 34,attr = [{1,3042},{2,60456},{3,1545},{4,1521}],cost = [{255,36140001,170}]};

get_lv_cfg(302,35) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 35,attr = [{1,3104},{2,61696},{3,1576},{4,1552}],cost = [{255,36140001,175}]};

get_lv_cfg(302,36) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 36,attr = [{1,3166},{2,62936},{3,1607},{4,1583}],cost = [{255,36140001,180}]};

get_lv_cfg(302,37) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 37,attr = [{1,3228},{2,64176},{3,1638},{4,1614}],cost = [{255,36140001,185}]};

get_lv_cfg(302,38) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 38,attr = [{1,3290},{2,65416},{3,1669},{4,1645}],cost = [{255,36140001,191}]};

get_lv_cfg(302,39) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 39,attr = [{1,3352},{2,66656},{3,1700},{4,1676}],cost = [{255,36140001,197}]};

get_lv_cfg(302,40) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 40,attr = [{1,3414},{2,67896},{3,1731},{4,1707}],cost = [{255,36140001,203}]};

get_lv_cfg(302,41) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 41,attr = [{1,3476},{2,69136},{3,1762},{4,1738}],cost = [{255,36140001,209}]};

get_lv_cfg(302,42) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 42,attr = [{1,3538},{2,70376},{3,1793},{4,1769}],cost = [{255,36140001,215}]};

get_lv_cfg(302,43) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 43,attr = [{1,3600},{2,71616},{3,1824},{4,1800}],cost = [{255,36140001,221}]};

get_lv_cfg(302,44) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 44,attr = [{1,3662},{2,72856},{3,1855},{4,1831}],cost = [{255,36140001,228}]};

get_lv_cfg(302,45) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 45,attr = [{1,3724},{2,74096},{3,1886},{4,1862}],cost = [{255,36140001,235}]};

get_lv_cfg(302,46) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 46,attr = [{1,3786},{2,75336},{3,1917},{4,1893}],cost = [{255,36140001,242}]};

get_lv_cfg(302,47) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 47,attr = [{1,3848},{2,76576},{3,1948},{4,1924}],cost = [{255,36140001,249}]};

get_lv_cfg(302,48) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 48,attr = [{1,3910},{2,77816},{3,1979},{4,1955}],cost = [{255,36140001,256}]};

get_lv_cfg(302,49) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 49,attr = [{1,3972},{2,79056},{3,2010},{4,1986}],cost = [{255,36140001,264}]};

get_lv_cfg(302,50) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 50,attr = [{1,4034},{2,80296},{3,2041},{4,2017}],cost = [{255,36140001,272}]};

get_lv_cfg(302,51) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 51,attr = [{1,4096},{2,81536},{3,2072},{4,2048}],cost = [{255,36140001,280}]};

get_lv_cfg(302,52) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 52,attr = [{1,4158},{2,82776},{3,2103},{4,2079}],cost = [{255,36140001,288}]};

get_lv_cfg(302,53) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 53,attr = [{1,4220},{2,84016},{3,2134},{4,2110}],cost = [{255,36140001,297}]};

get_lv_cfg(302,54) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 54,attr = [{1,4282},{2,85256},{3,2165},{4,2141}],cost = [{255,36140001,306}]};

get_lv_cfg(302,55) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 55,attr = [{1,4344},{2,86496},{3,2196},{4,2172}],cost = [{255,36140001,315}]};

get_lv_cfg(302,56) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 56,attr = [{1,4406},{2,87736},{3,2227},{4,2203}],cost = [{255,36140001,324}]};

get_lv_cfg(302,57) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 57,attr = [{1,4468},{2,88976},{3,2258},{4,2234}],cost = [{255,36140001,334}]};

get_lv_cfg(302,58) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 58,attr = [{1,4530},{2,90216},{3,2289},{4,2265}],cost = [{255,36140001,344}]};

get_lv_cfg(302,59) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 59,attr = [{1,4592},{2,91456},{3,2320},{4,2296}],cost = [{255,36140001,354}]};

get_lv_cfg(302,60) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 60,attr = [{1,4654},{2,92696},{3,2351},{4,2327}],cost = [{255,36140001,365}]};

get_lv_cfg(302,61) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 61,attr = [{1,4716},{2,93936},{3,2382},{4,2358}],cost = [{255,36140001,376}]};

get_lv_cfg(302,62) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 62,attr = [{1,4778},{2,95176},{3,2413},{4,2389}],cost = [{255,36140001,387}]};

get_lv_cfg(302,63) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 63,attr = [{1,4840},{2,96416},{3,2444},{4,2420}],cost = [{255,36140001,399}]};

get_lv_cfg(302,64) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 64,attr = [{1,4902},{2,97656},{3,2475},{4,2451}],cost = [{255,36140001,411}]};

get_lv_cfg(302,65) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 65,attr = [{1,4964},{2,98896},{3,2506},{4,2482}],cost = [{255,36140001,423}]};

get_lv_cfg(302,66) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 66,attr = [{1,5026},{2,100136},{3,2537},{4,2513}],cost = [{255,36140001,436}]};

get_lv_cfg(302,67) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 67,attr = [{1,5088},{2,101376},{3,2568},{4,2544}],cost = [{255,36140001,449}]};

get_lv_cfg(302,68) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 68,attr = [{1,5150},{2,102616},{3,2599},{4,2575}],cost = [{255,36140001,462}]};

get_lv_cfg(302,69) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 69,attr = [{1,5212},{2,103856},{3,2630},{4,2606}],cost = [{255,36140001,476}]};

get_lv_cfg(302,70) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 70,attr = [{1,5274},{2,105096},{3,2661},{4,2637}],cost = [{255,36140001,490}]};

get_lv_cfg(302,71) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 71,attr = [{1,5336},{2,106336},{3,2692},{4,2668}],cost = [{255,36140001,505}]};

get_lv_cfg(302,72) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 72,attr = [{1,5398},{2,107576},{3,2723},{4,2699}],cost = [{255,36140001,520}]};

get_lv_cfg(302,73) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 73,attr = [{1,5460},{2,108816},{3,2754},{4,2730}],cost = [{255,36140001,536}]};

get_lv_cfg(302,74) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 74,attr = [{1,5522},{2,110056},{3,2785},{4,2761}],cost = [{255,36140001,552}]};

get_lv_cfg(302,75) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 75,attr = [{1,5584},{2,111296},{3,2816},{4,2792}],cost = [{255,36140001,569}]};

get_lv_cfg(302,76) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 76,attr = [{1,5646},{2,112536},{3,2847},{4,2823}],cost = [{255,36140001,586}]};

get_lv_cfg(302,77) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 77,attr = [{1,5708},{2,113776},{3,2878},{4,2854}],cost = [{255,36140001,604}]};

get_lv_cfg(302,78) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 78,attr = [{1,5770},{2,115016},{3,2909},{4,2885}],cost = [{255,36140001,622}]};

get_lv_cfg(302,79) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 79,attr = [{1,5832},{2,116256},{3,2940},{4,2916}],cost = [{255,36140001,641}]};

get_lv_cfg(302,80) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 80,attr = [{1,5894},{2,117496},{3,2971},{4,2947}],cost = [{255,36140001,660}]};

get_lv_cfg(302,81) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 81,attr = [{1,5956},{2,118736},{3,3002},{4,2978}],cost = [{255,36140001,680}]};

get_lv_cfg(302,82) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 82,attr = [{1,6018},{2,119976},{3,3033},{4,3009}],cost = [{255,36140001,700}]};

get_lv_cfg(302,83) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 83,attr = [{1,6080},{2,121216},{3,3064},{4,3040}],cost = [{255,36140001,721}]};

get_lv_cfg(302,84) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 84,attr = [{1,6142},{2,122456},{3,3095},{4,3071}],cost = [{255,36140001,743}]};

get_lv_cfg(302,85) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 85,attr = [{1,6204},{2,123696},{3,3126},{4,3102}],cost = [{255,36140001,765}]};

get_lv_cfg(302,86) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 86,attr = [{1,6266},{2,124936},{3,3157},{4,3133}],cost = [{255,36140001,788}]};

get_lv_cfg(302,87) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 87,attr = [{1,6328},{2,126176},{3,3188},{4,3164}],cost = [{255,36140001,812}]};

get_lv_cfg(302,88) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 88,attr = [{1,6390},{2,127416},{3,3219},{4,3195}],cost = [{255,36140001,836}]};

get_lv_cfg(302,89) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 89,attr = [{1,6452},{2,128656},{3,3250},{4,3226}],cost = [{255,36140001,861}]};

get_lv_cfg(302,90) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 90,attr = [{1,6514},{2,129896},{3,3281},{4,3257}],cost = [{255,36140001,887}]};

get_lv_cfg(302,91) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 91,attr = [{1,6576},{2,131136},{3,3312},{4,3288}],cost = [{255,36140001,914}]};

get_lv_cfg(302,92) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 92,attr = [{1,6638},{2,132376},{3,3343},{4,3319}],cost = [{255,36140001,941}]};

get_lv_cfg(302,93) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 93,attr = [{1,6700},{2,133616},{3,3374},{4,3350}],cost = [{255,36140001,969}]};

get_lv_cfg(302,94) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 94,attr = [{1,6762},{2,134856},{3,3405},{4,3381}],cost = [{255,36140001,998}]};

get_lv_cfg(302,95) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 95,attr = [{1,6824},{2,136096},{3,3436},{4,3412}],cost = [{255,36140001,1028}]};

get_lv_cfg(302,96) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 96,attr = [{1,6886},{2,137336},{3,3467},{4,3443}],cost = [{255,36140001,1059}]};

get_lv_cfg(302,97) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 97,attr = [{1,6948},{2,138576},{3,3498},{4,3474}],cost = [{255,36140001,1091}]};

get_lv_cfg(302,98) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 98,attr = [{1,7010},{2,139816},{3,3529},{4,3505}],cost = [{255,36140001,1124}]};

get_lv_cfg(302,99) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 99,attr = [{1,7072},{2,141056},{3,3560},{4,3536}],cost = [{255,36140001,1158}]};

get_lv_cfg(302,100) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 100,attr = [{1,7134},{2,142296},{3,3591},{4,3567}],cost = [{255,36140001,1193}]};

get_lv_cfg(302,101) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 101,attr = [{1,7196},{2,143536},{3,3622},{4,3598}],cost = [{255,36140001,1229}]};

get_lv_cfg(302,102) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 102,attr = [{1,7258},{2,144776},{3,3653},{4,3629}],cost = [{255,36140001,1266}]};

get_lv_cfg(302,103) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 103,attr = [{1,7320},{2,146016},{3,3684},{4,3660}],cost = [{255,36140001,1304}]};

get_lv_cfg(302,104) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 104,attr = [{1,7382},{2,147256},{3,3715},{4,3691}],cost = [{255,36140001,1343}]};

get_lv_cfg(302,105) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 105,attr = [{1,7444},{2,148496},{3,3746},{4,3722}],cost = [{255,36140001,1383}]};

get_lv_cfg(302,106) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 106,attr = [{1,7506},{2,149736},{3,3777},{4,3753}],cost = [{255,36140001,1424}]};

get_lv_cfg(302,107) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 107,attr = [{1,7568},{2,150976},{3,3808},{4,3784}],cost = [{255,36140001,1467}]};

get_lv_cfg(302,108) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 108,attr = [{1,7630},{2,152216},{3,3839},{4,3815}],cost = [{255,36140001,1511}]};

get_lv_cfg(302,109) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 109,attr = [{1,7692},{2,153456},{3,3870},{4,3846}],cost = [{255,36140001,1556}]};

get_lv_cfg(302,110) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 110,attr = [{1,7754},{2,154696},{3,3901},{4,3877}],cost = [{255,36140001,1603}]};

get_lv_cfg(302,111) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 111,attr = [{1,7816},{2,155936},{3,3932},{4,3908}],cost = [{255,36140001,1651}]};

get_lv_cfg(302,112) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 112,attr = [{1,7878},{2,157176},{3,3963},{4,3939}],cost = [{255,36140001,1701}]};

get_lv_cfg(302,113) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 113,attr = [{1,7940},{2,158416},{3,3994},{4,3970}],cost = [{255,36140001,1752}]};

get_lv_cfg(302,114) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 114,attr = [{1,8002},{2,159656},{3,4025},{4,4001}],cost = [{255,36140001,1805}]};

get_lv_cfg(302,115) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 115,attr = [{1,8064},{2,160896},{3,4056},{4,4032}],cost = [{255,36140001,1859}]};

get_lv_cfg(302,116) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 116,attr = [{1,8126},{2,162136},{3,4087},{4,4063}],cost = [{255,36140001,1915}]};

get_lv_cfg(302,117) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 117,attr = [{1,8188},{2,163376},{3,4118},{4,4094}],cost = [{255,36140001,1972}]};

get_lv_cfg(302,118) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 118,attr = [{1,8250},{2,164616},{3,4149},{4,4125}],cost = [{255,36140001,2031}]};

get_lv_cfg(302,119) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 119,attr = [{1,8312},{2,165856},{3,4180},{4,4156}],cost = [{255,36140001,2092}]};

get_lv_cfg(302,120) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 120,attr = [{1,8374},{2,167096},{3,4211},{4,4187}],cost = [{255,36140001,2155}]};

get_lv_cfg(302,121) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 121,attr = [{1,8436},{2,168336},{3,4242},{4,4218}],cost = [{255,36140001,2220}]};

get_lv_cfg(302,122) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 122,attr = [{1,8498},{2,169576},{3,4273},{4,4249}],cost = [{255,36140001,2287}]};

get_lv_cfg(302,123) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 123,attr = [{1,8560},{2,170816},{3,4304},{4,4280}],cost = [{255,36140001,2356}]};

get_lv_cfg(302,124) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 124,attr = [{1,8622},{2,172056},{3,4335},{4,4311}],cost = [{255,36140001,2427}]};

get_lv_cfg(302,125) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 125,attr = [{1,8684},{2,173296},{3,4366},{4,4342}],cost = [{255,36140001,2500}]};

get_lv_cfg(302,126) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 126,attr = [{1,8746},{2,174536},{3,4397},{4,4373}],cost = [{255,36140001,2575}]};

get_lv_cfg(302,127) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 127,attr = [{1,8808},{2,175776},{3,4428},{4,4404}],cost = [{255,36140001,2652}]};

get_lv_cfg(302,128) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 128,attr = [{1,8870},{2,177016},{3,4459},{4,4435}],cost = [{255,36140001,2732}]};

get_lv_cfg(302,129) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 129,attr = [{1,8932},{2,178256},{3,4490},{4,4466}],cost = [{255,36140001,2814}]};

get_lv_cfg(302,130) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 130,attr = [{1,8994},{2,179496},{3,4521},{4,4497}],cost = [{255,36140001,2898}]};

get_lv_cfg(302,131) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 131,attr = [{1,9056},{2,180736},{3,4552},{4,4528}],cost = [{255,36140001,2985}]};

get_lv_cfg(302,132) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 132,attr = [{1,9118},{2,181976},{3,4583},{4,4559}],cost = [{255,36140001,3075}]};

get_lv_cfg(302,133) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 133,attr = [{1,9180},{2,183216},{3,4614},{4,4590}],cost = [{255,36140001,3167}]};

get_lv_cfg(302,134) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 134,attr = [{1,9242},{2,184456},{3,4645},{4,4621}],cost = [{255,36140001,3262}]};

get_lv_cfg(302,135) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 135,attr = [{1,9304},{2,185696},{3,4676},{4,4652}],cost = [{255,36140001,3360}]};

get_lv_cfg(302,136) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 136,attr = [{1,9366},{2,186936},{3,4707},{4,4683}],cost = [{255,36140001,3461}]};

get_lv_cfg(302,137) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 137,attr = [{1,9428},{2,188176},{3,4738},{4,4714}],cost = [{255,36140001,3565}]};

get_lv_cfg(302,138) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 138,attr = [{1,9490},{2,189416},{3,4769},{4,4745}],cost = [{255,36140001,3672}]};

get_lv_cfg(302,139) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 139,attr = [{1,9552},{2,190656},{3,4800},{4,4776}],cost = [{255,36140001,3782}]};

get_lv_cfg(302,140) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 140,attr = [{1,9614},{2,191896},{3,4831},{4,4807}],cost = [{255,36140001,3895}]};

get_lv_cfg(302,141) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 141,attr = [{1,9676},{2,193136},{3,4862},{4,4838}],cost = [{255,36140001,4012}]};

get_lv_cfg(302,142) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 142,attr = [{1,9738},{2,194376},{3,4893},{4,4869}],cost = [{255,36140001,4132}]};

get_lv_cfg(302,143) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 143,attr = [{1,9800},{2,195616},{3,4924},{4,4900}],cost = [{255,36140001,4256}]};

get_lv_cfg(302,144) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 144,attr = [{1,9862},{2,196856},{3,4955},{4,4931}],cost = [{255,36140001,4384}]};

get_lv_cfg(302,145) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 145,attr = [{1,9924},{2,198096},{3,4986},{4,4962}],cost = [{255,36140001,4516}]};

get_lv_cfg(302,146) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 146,attr = [{1,9986},{2,199336},{3,5017},{4,4993}],cost = [{255,36140001,4651}]};

get_lv_cfg(302,147) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 147,attr = [{1,10048},{2,200576},{3,5048},{4,5024}],cost = [{255,36140001,4791}]};

get_lv_cfg(302,148) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 148,attr = [{1,10110},{2,201816},{3,5079},{4,5055}],cost = [{255,36140001,4935}]};

get_lv_cfg(302,149) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 149,attr = [{1,10172},{2,203056},{3,5110},{4,5086}],cost = [{255,36140001,5083}]};

get_lv_cfg(302,150) ->
	#artifact_upgrate_cfg{id = 302,name = "海神三叉戟",lv = 150,attr = [{1,10234},{2,204296},{3,5141},{4,5117}],cost = [{255,36140001,5235}]};

get_lv_cfg(303,1) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 1,attr = [{1,1056},{2,20592},{3,480},{4,540}],cost = [{255,36140001,65}]};

get_lv_cfg(303,2) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 2,attr = [{1,1118},{2,21832},{3,511},{4,571}],cost = [{255,36140001,67}]};

get_lv_cfg(303,3) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 3,attr = [{1,1180},{2,23072},{3,542},{4,602}],cost = [{255,36140001,69}]};

get_lv_cfg(303,4) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 4,attr = [{1,1242},{2,24312},{3,573},{4,633}],cost = [{255,36140001,71}]};

get_lv_cfg(303,5) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 5,attr = [{1,1304},{2,25552},{3,604},{4,664}],cost = [{255,36140001,73}]};

get_lv_cfg(303,6) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 6,attr = [{1,1366},{2,26792},{3,635},{4,695}],cost = [{255,36140001,75}]};

get_lv_cfg(303,7) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 7,attr = [{1,1428},{2,28032},{3,666},{4,726}],cost = [{255,36140001,77}]};

get_lv_cfg(303,8) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 8,attr = [{1,1490},{2,29272},{3,697},{4,757}],cost = [{255,36140001,79}]};

get_lv_cfg(303,9) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 9,attr = [{1,1552},{2,30512},{3,728},{4,788}],cost = [{255,36140001,81}]};

get_lv_cfg(303,10) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 10,attr = [{1,1614},{2,31752},{3,759},{4,819}],cost = [{255,36140001,83}]};

get_lv_cfg(303,11) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 11,attr = [{1,1676},{2,32992},{3,790},{4,850}],cost = [{255,36140001,85}]};

get_lv_cfg(303,12) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 12,attr = [{1,1738},{2,34232},{3,821},{4,881}],cost = [{255,36140001,88}]};

get_lv_cfg(303,13) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 13,attr = [{1,1800},{2,35472},{3,852},{4,912}],cost = [{255,36140001,91}]};

get_lv_cfg(303,14) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 14,attr = [{1,1862},{2,36712},{3,883},{4,943}],cost = [{255,36140001,94}]};

get_lv_cfg(303,15) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 15,attr = [{1,1924},{2,37952},{3,914},{4,974}],cost = [{255,36140001,97}]};

get_lv_cfg(303,16) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 16,attr = [{1,1986},{2,39192},{3,945},{4,1005}],cost = [{255,36140001,100}]};

get_lv_cfg(303,17) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 17,attr = [{1,2048},{2,40432},{3,976},{4,1036}],cost = [{255,36140001,103}]};

get_lv_cfg(303,18) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 18,attr = [{1,2110},{2,41672},{3,1007},{4,1067}],cost = [{255,36140001,106}]};

get_lv_cfg(303,19) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 19,attr = [{1,2172},{2,42912},{3,1038},{4,1098}],cost = [{255,36140001,109}]};

get_lv_cfg(303,20) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 20,attr = [{1,2234},{2,44152},{3,1069},{4,1129}],cost = [{255,36140001,112}]};

get_lv_cfg(303,21) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 21,attr = [{1,2296},{2,45392},{3,1100},{4,1160}],cost = [{255,36140001,115}]};

get_lv_cfg(303,22) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 22,attr = [{1,2358},{2,46632},{3,1131},{4,1191}],cost = [{255,36140001,118}]};

get_lv_cfg(303,23) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 23,attr = [{1,2420},{2,47872},{3,1162},{4,1222}],cost = [{255,36140001,122}]};

get_lv_cfg(303,24) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 24,attr = [{1,2482},{2,49112},{3,1193},{4,1253}],cost = [{255,36140001,126}]};

get_lv_cfg(303,25) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 25,attr = [{1,2544},{2,50352},{3,1224},{4,1284}],cost = [{255,36140001,130}]};

get_lv_cfg(303,26) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 26,attr = [{1,2606},{2,51592},{3,1255},{4,1315}],cost = [{255,36140001,134}]};

get_lv_cfg(303,27) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 27,attr = [{1,2668},{2,52832},{3,1286},{4,1346}],cost = [{255,36140001,138}]};

get_lv_cfg(303,28) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 28,attr = [{1,2730},{2,54072},{3,1317},{4,1377}],cost = [{255,36140001,142}]};

get_lv_cfg(303,29) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 29,attr = [{1,2792},{2,55312},{3,1348},{4,1408}],cost = [{255,36140001,146}]};

get_lv_cfg(303,30) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 30,attr = [{1,2854},{2,56552},{3,1379},{4,1439}],cost = [{255,36140001,150}]};

get_lv_cfg(303,31) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 31,attr = [{1,2916},{2,57792},{3,1410},{4,1470}],cost = [{255,36140001,155}]};

get_lv_cfg(303,32) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 32,attr = [{1,2978},{2,59032},{3,1441},{4,1501}],cost = [{255,36140001,160}]};

get_lv_cfg(303,33) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 33,attr = [{1,3040},{2,60272},{3,1472},{4,1532}],cost = [{255,36140001,165}]};

get_lv_cfg(303,34) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 34,attr = [{1,3102},{2,61512},{3,1503},{4,1563}],cost = [{255,36140001,170}]};

get_lv_cfg(303,35) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 35,attr = [{1,3164},{2,62752},{3,1534},{4,1594}],cost = [{255,36140001,175}]};

get_lv_cfg(303,36) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 36,attr = [{1,3226},{2,63992},{3,1565},{4,1625}],cost = [{255,36140001,180}]};

get_lv_cfg(303,37) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 37,attr = [{1,3288},{2,65232},{3,1596},{4,1656}],cost = [{255,36140001,185}]};

get_lv_cfg(303,38) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 38,attr = [{1,3350},{2,66472},{3,1627},{4,1687}],cost = [{255,36140001,191}]};

get_lv_cfg(303,39) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 39,attr = [{1,3412},{2,67712},{3,1658},{4,1718}],cost = [{255,36140001,197}]};

get_lv_cfg(303,40) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 40,attr = [{1,3474},{2,68952},{3,1689},{4,1749}],cost = [{255,36140001,203}]};

get_lv_cfg(303,41) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 41,attr = [{1,3536},{2,70192},{3,1720},{4,1780}],cost = [{255,36140001,209}]};

get_lv_cfg(303,42) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 42,attr = [{1,3598},{2,71432},{3,1751},{4,1811}],cost = [{255,36140001,215}]};

get_lv_cfg(303,43) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 43,attr = [{1,3660},{2,72672},{3,1782},{4,1842}],cost = [{255,36140001,221}]};

get_lv_cfg(303,44) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 44,attr = [{1,3722},{2,73912},{3,1813},{4,1873}],cost = [{255,36140001,228}]};

get_lv_cfg(303,45) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 45,attr = [{1,3784},{2,75152},{3,1844},{4,1904}],cost = [{255,36140001,235}]};

get_lv_cfg(303,46) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 46,attr = [{1,3846},{2,76392},{3,1875},{4,1935}],cost = [{255,36140001,242}]};

get_lv_cfg(303,47) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 47,attr = [{1,3908},{2,77632},{3,1906},{4,1966}],cost = [{255,36140001,249}]};

get_lv_cfg(303,48) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 48,attr = [{1,3970},{2,78872},{3,1937},{4,1997}],cost = [{255,36140001,256}]};

get_lv_cfg(303,49) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 49,attr = [{1,4032},{2,80112},{3,1968},{4,2028}],cost = [{255,36140001,264}]};

get_lv_cfg(303,50) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 50,attr = [{1,4094},{2,81352},{3,1999},{4,2059}],cost = [{255,36140001,272}]};

get_lv_cfg(303,51) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 51,attr = [{1,4156},{2,82592},{3,2030},{4,2090}],cost = [{255,36140001,280}]};

get_lv_cfg(303,52) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 52,attr = [{1,4218},{2,83832},{3,2061},{4,2121}],cost = [{255,36140001,288}]};

get_lv_cfg(303,53) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 53,attr = [{1,4280},{2,85072},{3,2092},{4,2152}],cost = [{255,36140001,297}]};

get_lv_cfg(303,54) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 54,attr = [{1,4342},{2,86312},{3,2123},{4,2183}],cost = [{255,36140001,306}]};

get_lv_cfg(303,55) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 55,attr = [{1,4404},{2,87552},{3,2154},{4,2214}],cost = [{255,36140001,315}]};

get_lv_cfg(303,56) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 56,attr = [{1,4466},{2,88792},{3,2185},{4,2245}],cost = [{255,36140001,324}]};

get_lv_cfg(303,57) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 57,attr = [{1,4528},{2,90032},{3,2216},{4,2276}],cost = [{255,36140001,334}]};

get_lv_cfg(303,58) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 58,attr = [{1,4590},{2,91272},{3,2247},{4,2307}],cost = [{255,36140001,344}]};

get_lv_cfg(303,59) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 59,attr = [{1,4652},{2,92512},{3,2278},{4,2338}],cost = [{255,36140001,354}]};

get_lv_cfg(303,60) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 60,attr = [{1,4714},{2,93752},{3,2309},{4,2369}],cost = [{255,36140001,365}]};

get_lv_cfg(303,61) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 61,attr = [{1,4776},{2,94992},{3,2340},{4,2400}],cost = [{255,36140001,376}]};

get_lv_cfg(303,62) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 62,attr = [{1,4838},{2,96232},{3,2371},{4,2431}],cost = [{255,36140001,387}]};

get_lv_cfg(303,63) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 63,attr = [{1,4900},{2,97472},{3,2402},{4,2462}],cost = [{255,36140001,399}]};

get_lv_cfg(303,64) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 64,attr = [{1,4962},{2,98712},{3,2433},{4,2493}],cost = [{255,36140001,411}]};

get_lv_cfg(303,65) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 65,attr = [{1,5024},{2,99952},{3,2464},{4,2524}],cost = [{255,36140001,423}]};

get_lv_cfg(303,66) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 66,attr = [{1,5086},{2,101192},{3,2495},{4,2555}],cost = [{255,36140001,436}]};

get_lv_cfg(303,67) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 67,attr = [{1,5148},{2,102432},{3,2526},{4,2586}],cost = [{255,36140001,449}]};

get_lv_cfg(303,68) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 68,attr = [{1,5210},{2,103672},{3,2557},{4,2617}],cost = [{255,36140001,462}]};

get_lv_cfg(303,69) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 69,attr = [{1,5272},{2,104912},{3,2588},{4,2648}],cost = [{255,36140001,476}]};

get_lv_cfg(303,70) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 70,attr = [{1,5334},{2,106152},{3,2619},{4,2679}],cost = [{255,36140001,490}]};

get_lv_cfg(303,71) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 71,attr = [{1,5396},{2,107392},{3,2650},{4,2710}],cost = [{255,36140001,505}]};

get_lv_cfg(303,72) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 72,attr = [{1,5458},{2,108632},{3,2681},{4,2741}],cost = [{255,36140001,520}]};

get_lv_cfg(303,73) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 73,attr = [{1,5520},{2,109872},{3,2712},{4,2772}],cost = [{255,36140001,536}]};

get_lv_cfg(303,74) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 74,attr = [{1,5582},{2,111112},{3,2743},{4,2803}],cost = [{255,36140001,552}]};

get_lv_cfg(303,75) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 75,attr = [{1,5644},{2,112352},{3,2774},{4,2834}],cost = [{255,36140001,569}]};

get_lv_cfg(303,76) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 76,attr = [{1,5706},{2,113592},{3,2805},{4,2865}],cost = [{255,36140001,586}]};

get_lv_cfg(303,77) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 77,attr = [{1,5768},{2,114832},{3,2836},{4,2896}],cost = [{255,36140001,604}]};

get_lv_cfg(303,78) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 78,attr = [{1,5830},{2,116072},{3,2867},{4,2927}],cost = [{255,36140001,622}]};

get_lv_cfg(303,79) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 79,attr = [{1,5892},{2,117312},{3,2898},{4,2958}],cost = [{255,36140001,641}]};

get_lv_cfg(303,80) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 80,attr = [{1,5954},{2,118552},{3,2929},{4,2989}],cost = [{255,36140001,660}]};

get_lv_cfg(303,81) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 81,attr = [{1,6016},{2,119792},{3,2960},{4,3020}],cost = [{255,36140001,680}]};

get_lv_cfg(303,82) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 82,attr = [{1,6078},{2,121032},{3,2991},{4,3051}],cost = [{255,36140001,700}]};

get_lv_cfg(303,83) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 83,attr = [{1,6140},{2,122272},{3,3022},{4,3082}],cost = [{255,36140001,721}]};

get_lv_cfg(303,84) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 84,attr = [{1,6202},{2,123512},{3,3053},{4,3113}],cost = [{255,36140001,743}]};

get_lv_cfg(303,85) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 85,attr = [{1,6264},{2,124752},{3,3084},{4,3144}],cost = [{255,36140001,765}]};

get_lv_cfg(303,86) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 86,attr = [{1,6326},{2,125992},{3,3115},{4,3175}],cost = [{255,36140001,788}]};

get_lv_cfg(303,87) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 87,attr = [{1,6388},{2,127232},{3,3146},{4,3206}],cost = [{255,36140001,812}]};

get_lv_cfg(303,88) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 88,attr = [{1,6450},{2,128472},{3,3177},{4,3237}],cost = [{255,36140001,836}]};

get_lv_cfg(303,89) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 89,attr = [{1,6512},{2,129712},{3,3208},{4,3268}],cost = [{255,36140001,861}]};

get_lv_cfg(303,90) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 90,attr = [{1,6574},{2,130952},{3,3239},{4,3299}],cost = [{255,36140001,887}]};

get_lv_cfg(303,91) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 91,attr = [{1,6636},{2,132192},{3,3270},{4,3330}],cost = [{255,36140001,914}]};

get_lv_cfg(303,92) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 92,attr = [{1,6698},{2,133432},{3,3301},{4,3361}],cost = [{255,36140001,941}]};

get_lv_cfg(303,93) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 93,attr = [{1,6760},{2,134672},{3,3332},{4,3392}],cost = [{255,36140001,969}]};

get_lv_cfg(303,94) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 94,attr = [{1,6822},{2,135912},{3,3363},{4,3423}],cost = [{255,36140001,998}]};

get_lv_cfg(303,95) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 95,attr = [{1,6884},{2,137152},{3,3394},{4,3454}],cost = [{255,36140001,1028}]};

get_lv_cfg(303,96) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 96,attr = [{1,6946},{2,138392},{3,3425},{4,3485}],cost = [{255,36140001,1059}]};

get_lv_cfg(303,97) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 97,attr = [{1,7008},{2,139632},{3,3456},{4,3516}],cost = [{255,36140001,1091}]};

get_lv_cfg(303,98) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 98,attr = [{1,7070},{2,140872},{3,3487},{4,3547}],cost = [{255,36140001,1124}]};

get_lv_cfg(303,99) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 99,attr = [{1,7132},{2,142112},{3,3518},{4,3578}],cost = [{255,36140001,1158}]};

get_lv_cfg(303,100) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 100,attr = [{1,7194},{2,143352},{3,3549},{4,3609}],cost = [{255,36140001,1193}]};

get_lv_cfg(303,101) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 101,attr = [{1,7256},{2,144592},{3,3580},{4,3640}],cost = [{255,36140001,1229}]};

get_lv_cfg(303,102) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 102,attr = [{1,7318},{2,145832},{3,3611},{4,3671}],cost = [{255,36140001,1266}]};

get_lv_cfg(303,103) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 103,attr = [{1,7380},{2,147072},{3,3642},{4,3702}],cost = [{255,36140001,1304}]};

get_lv_cfg(303,104) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 104,attr = [{1,7442},{2,148312},{3,3673},{4,3733}],cost = [{255,36140001,1343}]};

get_lv_cfg(303,105) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 105,attr = [{1,7504},{2,149552},{3,3704},{4,3764}],cost = [{255,36140001,1383}]};

get_lv_cfg(303,106) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 106,attr = [{1,7566},{2,150792},{3,3735},{4,3795}],cost = [{255,36140001,1424}]};

get_lv_cfg(303,107) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 107,attr = [{1,7628},{2,152032},{3,3766},{4,3826}],cost = [{255,36140001,1467}]};

get_lv_cfg(303,108) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 108,attr = [{1,7690},{2,153272},{3,3797},{4,3857}],cost = [{255,36140001,1511}]};

get_lv_cfg(303,109) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 109,attr = [{1,7752},{2,154512},{3,3828},{4,3888}],cost = [{255,36140001,1556}]};

get_lv_cfg(303,110) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 110,attr = [{1,7814},{2,155752},{3,3859},{4,3919}],cost = [{255,36140001,1603}]};

get_lv_cfg(303,111) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 111,attr = [{1,7876},{2,156992},{3,3890},{4,3950}],cost = [{255,36140001,1651}]};

get_lv_cfg(303,112) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 112,attr = [{1,7938},{2,158232},{3,3921},{4,3981}],cost = [{255,36140001,1701}]};

get_lv_cfg(303,113) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 113,attr = [{1,8000},{2,159472},{3,3952},{4,4012}],cost = [{255,36140001,1752}]};

get_lv_cfg(303,114) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 114,attr = [{1,8062},{2,160712},{3,3983},{4,4043}],cost = [{255,36140001,1805}]};

get_lv_cfg(303,115) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 115,attr = [{1,8124},{2,161952},{3,4014},{4,4074}],cost = [{255,36140001,1859}]};

get_lv_cfg(303,116) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 116,attr = [{1,8186},{2,163192},{3,4045},{4,4105}],cost = [{255,36140001,1915}]};

get_lv_cfg(303,117) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 117,attr = [{1,8248},{2,164432},{3,4076},{4,4136}],cost = [{255,36140001,1972}]};

get_lv_cfg(303,118) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 118,attr = [{1,8310},{2,165672},{3,4107},{4,4167}],cost = [{255,36140001,2031}]};

get_lv_cfg(303,119) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 119,attr = [{1,8372},{2,166912},{3,4138},{4,4198}],cost = [{255,36140001,2092}]};

get_lv_cfg(303,120) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 120,attr = [{1,8434},{2,168152},{3,4169},{4,4229}],cost = [{255,36140001,2155}]};

get_lv_cfg(303,121) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 121,attr = [{1,8496},{2,169392},{3,4200},{4,4260}],cost = [{255,36140001,2220}]};

get_lv_cfg(303,122) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 122,attr = [{1,8558},{2,170632},{3,4231},{4,4291}],cost = [{255,36140001,2287}]};

get_lv_cfg(303,123) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 123,attr = [{1,8620},{2,171872},{3,4262},{4,4322}],cost = [{255,36140001,2356}]};

get_lv_cfg(303,124) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 124,attr = [{1,8682},{2,173112},{3,4293},{4,4353}],cost = [{255,36140001,2427}]};

get_lv_cfg(303,125) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 125,attr = [{1,8744},{2,174352},{3,4324},{4,4384}],cost = [{255,36140001,2500}]};

get_lv_cfg(303,126) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 126,attr = [{1,8806},{2,175592},{3,4355},{4,4415}],cost = [{255,36140001,2575}]};

get_lv_cfg(303,127) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 127,attr = [{1,8868},{2,176832},{3,4386},{4,4446}],cost = [{255,36140001,2652}]};

get_lv_cfg(303,128) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 128,attr = [{1,8930},{2,178072},{3,4417},{4,4477}],cost = [{255,36140001,2732}]};

get_lv_cfg(303,129) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 129,attr = [{1,8992},{2,179312},{3,4448},{4,4508}],cost = [{255,36140001,2814}]};

get_lv_cfg(303,130) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 130,attr = [{1,9054},{2,180552},{3,4479},{4,4539}],cost = [{255,36140001,2898}]};

get_lv_cfg(303,131) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 131,attr = [{1,9116},{2,181792},{3,4510},{4,4570}],cost = [{255,36140001,2985}]};

get_lv_cfg(303,132) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 132,attr = [{1,9178},{2,183032},{3,4541},{4,4601}],cost = [{255,36140001,3075}]};

get_lv_cfg(303,133) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 133,attr = [{1,9240},{2,184272},{3,4572},{4,4632}],cost = [{255,36140001,3167}]};

get_lv_cfg(303,134) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 134,attr = [{1,9302},{2,185512},{3,4603},{4,4663}],cost = [{255,36140001,3262}]};

get_lv_cfg(303,135) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 135,attr = [{1,9364},{2,186752},{3,4634},{4,4694}],cost = [{255,36140001,3360}]};

get_lv_cfg(303,136) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 136,attr = [{1,9426},{2,187992},{3,4665},{4,4725}],cost = [{255,36140001,3461}]};

get_lv_cfg(303,137) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 137,attr = [{1,9488},{2,189232},{3,4696},{4,4756}],cost = [{255,36140001,3565}]};

get_lv_cfg(303,138) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 138,attr = [{1,9550},{2,190472},{3,4727},{4,4787}],cost = [{255,36140001,3672}]};

get_lv_cfg(303,139) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 139,attr = [{1,9612},{2,191712},{3,4758},{4,4818}],cost = [{255,36140001,3782}]};

get_lv_cfg(303,140) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 140,attr = [{1,9674},{2,192952},{3,4789},{4,4849}],cost = [{255,36140001,3895}]};

get_lv_cfg(303,141) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 141,attr = [{1,9736},{2,194192},{3,4820},{4,4880}],cost = [{255,36140001,4012}]};

get_lv_cfg(303,142) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 142,attr = [{1,9798},{2,195432},{3,4851},{4,4911}],cost = [{255,36140001,4132}]};

get_lv_cfg(303,143) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 143,attr = [{1,9860},{2,196672},{3,4882},{4,4942}],cost = [{255,36140001,4256}]};

get_lv_cfg(303,144) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 144,attr = [{1,9922},{2,197912},{3,4913},{4,4973}],cost = [{255,36140001,4384}]};

get_lv_cfg(303,145) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 145,attr = [{1,9984},{2,199152},{3,4944},{4,5004}],cost = [{255,36140001,4516}]};

get_lv_cfg(303,146) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 146,attr = [{1,10046},{2,200392},{3,4975},{4,5035}],cost = [{255,36140001,4651}]};

get_lv_cfg(303,147) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 147,attr = [{1,10108},{2,201632},{3,5006},{4,5066}],cost = [{255,36140001,4791}]};

get_lv_cfg(303,148) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 148,attr = [{1,10170},{2,202872},{3,5037},{4,5097}],cost = [{255,36140001,4935}]};

get_lv_cfg(303,149) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 149,attr = [{1,10232},{2,204112},{3,5068},{4,5128}],cost = [{255,36140001,5083}]};

get_lv_cfg(303,150) ->
	#artifact_upgrate_cfg{id = 303,name = "大力神斧",lv = 150,attr = [{1,10294},{2,205352},{3,5099},{4,5159}],cost = [{255,36140001,5235}]};

get_lv_cfg(_Id,_Lv) ->
	[].

