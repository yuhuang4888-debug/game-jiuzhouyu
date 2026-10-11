%%%---------------------------------------
%%% module      : data_companion
%%% description : 伙伴（新）配置
%%%
%%%---------------------------------------
-module(data_companion).
-compile(export_all).
-include("companion.hrl").



get_companion(1) ->
	#base_companion{id = 1,name = <<"星神未来"/utf8>>,figure_id = 1018,goods_id = 22030001,goods_num = 100,single_exp = 10,skill_list = [5201001,5201002,5201003,5201004],attack_skill = 5200000,jump = 0,train_goods_id = 22030101,train_attr = [{2,1000}],train_limit = 1000};

get_companion(2) ->
	#base_companion{id = 2,name = <<"乐神音姬"/utf8>>,figure_id = 1023,goods_id = 22030002,goods_num = 150,single_exp = 10,skill_list = [5202001,5202002,5202003,5202004],attack_skill = 5200000,jump = 190,train_goods_id = 22030102,train_attr = [{4,50}],train_limit = 1000};

get_companion(3) ->
	#base_companion{id = 3,name = <<"桃神沫沫"/utf8>>,figure_id = 1019,goods_id = 22030003,goods_num = 250,single_exp = 10,skill_list = [5203001,5203002,5203003,5203004],attack_skill = 5200000,jump = 190,train_goods_id = 22030103,train_attr = [{1,100}],train_limit = 1000};

get_companion(4) ->
	#base_companion{id = 4,name = <<"河神蔚蓝"/utf8>>,figure_id = 1022,goods_id = 22030004,goods_num = 300,single_exp = 10,skill_list = [5204001,5204002,5204003,5204004],attack_skill = 5200000,jump = 190,train_goods_id = 22030104,train_attr = [{3,100}],train_limit = 1000};

get_companion(5) ->
	#base_companion{id = 5,name = <<"雪神凝霜"/utf8>>,figure_id = 1004,goods_id = 22030005,goods_num = 500,single_exp = 10,skill_list = [5205001,5205002,5205003,5205004],attack_skill = 5200000,jump = 190,train_goods_id = 22030105,train_attr = [{2,2000}],train_limit = 1000};

get_companion(6) ->
	#base_companion{id = 6,name = <<"蛛神伊织"/utf8>>,figure_id = 1024,goods_id = 22030006,goods_num = 150,single_exp = 10,skill_list = [5206001,5206002,5206003,5206004],attack_skill = 5200000,jump = 72,train_goods_id = 22030106,train_attr = [{3,75}],train_limit = 1000};

get_companion(7) ->
	#base_companion{id = 7,name = <<"春神琉璃"/utf8>>,figure_id = 1029,goods_id = 22030007,goods_num = 300,single_exp = 10,skill_list = [5207001,5207002,5207003,5207004],attack_skill = 5200000,jump = 0,train_goods_id = 22030107,train_attr = [{2,2000}],train_limit = 1000};

get_companion(8) ->
	#base_companion{id = 8,name = <<"缘神侑希"/utf8>>,figure_id = 1033,goods_id = 22030008,goods_num = 1,single_exp = 10,skill_list = [5208001,5208002,5208003,5208004],attack_skill = 5200000,jump = 21,train_goods_id = 22030108,train_attr = [{1,100}],train_limit = 1000};

get_companion(9) ->
	#base_companion{id = 9,name = <<"武神沙耶"/utf8>>,figure_id = 1060,goods_id = 22030009,goods_num = 300,single_exp = 10,skill_list = [5209001,5209002,5209003,5209004],attack_skill = 5200000,jump = 0,train_goods_id = 22030109,train_attr = [{3,100}],train_limit = 1000};

get_companion(10) ->
	#base_companion{id = 10,name = <<"炽神樱乃"/utf8>>,figure_id = 1006,goods_id = 22030010,goods_num = 150,single_exp = 10,skill_list = [5210001,5210002,5210003,5210004],attack_skill = 5200000,jump = 34,train_goods_id = 22030110,train_attr = [{1,100}],train_limit = 1000};

get_companion(11) ->
	#base_companion{id = 11,name = <<"稻神丰宇"/utf8>>,figure_id = 1008,goods_id = 22030011,goods_num = 300,single_exp = 10,skill_list = [5211001,5211002,5211003,5211004],attack_skill = 5200000,jump = 0,train_goods_id = 22030111,train_attr = [{2,2000}],train_limit = 1000};

get_companion(12) ->
	#base_companion{id = 12,name = <<"魁神月和"/utf8>>,figure_id = 1009,goods_id = 22030012,goods_num = 300,single_exp = 10,skill_list = [5212001,5212002,5212003,5212004],attack_skill = 5200000,jump = 0,train_goods_id = 22030112,train_attr = [{3,100}],train_limit = 1000};

get_companion(_Id) ->
	[].

list_companion_id() ->
[1,2,3,4,5,6,7,8,9,10,11,12].

get_companion_skill(1,5201001) ->
	#base_companion_skill{companion_id = 1,skill_id = 5201001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(1,5201002) ->
	#base_companion_skill{companion_id = 1,skill_id = 5201002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(1,5201003) ->
	#base_companion_skill{companion_id = 1,skill_id = 5201003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(1,5201004) ->
	#base_companion_skill{companion_id = 1,skill_id = 5201004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(2,5202001) ->
	#base_companion_skill{companion_id = 2,skill_id = 5202001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(2,5202002) ->
	#base_companion_skill{companion_id = 2,skill_id = 5202002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(2,5202003) ->
	#base_companion_skill{companion_id = 2,skill_id = 5202003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(2,5202004) ->
	#base_companion_skill{companion_id = 2,skill_id = 5202004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(3,5203001) ->
	#base_companion_skill{companion_id = 3,skill_id = 5203001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(3,5203002) ->
	#base_companion_skill{companion_id = 3,skill_id = 5203002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(3,5203003) ->
	#base_companion_skill{companion_id = 3,skill_id = 5203003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(3,5203004) ->
	#base_companion_skill{companion_id = 3,skill_id = 5203004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(4,5204001) ->
	#base_companion_skill{companion_id = 4,skill_id = 5204001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(4,5204002) ->
	#base_companion_skill{companion_id = 4,skill_id = 5204002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(4,5204003) ->
	#base_companion_skill{companion_id = 4,skill_id = 5204003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(4,5204004) ->
	#base_companion_skill{companion_id = 4,skill_id = 5204004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(5,5205001) ->
	#base_companion_skill{companion_id = 5,skill_id = 5205001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(5,5205002) ->
	#base_companion_skill{companion_id = 5,skill_id = 5205002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(5,5205003) ->
	#base_companion_skill{companion_id = 5,skill_id = 5205003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(5,5205004) ->
	#base_companion_skill{companion_id = 5,skill_id = 5205004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(6,5206001) ->
	#base_companion_skill{companion_id = 6,skill_id = 5206001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(6,5206002) ->
	#base_companion_skill{companion_id = 6,skill_id = 5206002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(6,5206003) ->
	#base_companion_skill{companion_id = 6,skill_id = 5206003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(6,5206004) ->
	#base_companion_skill{companion_id = 6,skill_id = 5206004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(7,5207001) ->
	#base_companion_skill{companion_id = 7,skill_id = 5207001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(7,5207002) ->
	#base_companion_skill{companion_id = 7,skill_id = 5207002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(7,5207003) ->
	#base_companion_skill{companion_id = 7,skill_id = 5207003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(7,5207004) ->
	#base_companion_skill{companion_id = 7,skill_id = 5207004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(8,5208001) ->
	#base_companion_skill{companion_id = 8,skill_id = 5208001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(8,5208002) ->
	#base_companion_skill{companion_id = 8,skill_id = 5208002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(8,5208003) ->
	#base_companion_skill{companion_id = 8,skill_id = 5208003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(8,5208004) ->
	#base_companion_skill{companion_id = 8,skill_id = 5208004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(9,5209001) ->
	#base_companion_skill{companion_id = 9,skill_id = 5209001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(9,5209002) ->
	#base_companion_skill{companion_id = 9,skill_id = 5209002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(9,5209003) ->
	#base_companion_skill{companion_id = 9,skill_id = 5209003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(9,5209004) ->
	#base_companion_skill{companion_id = 9,skill_id = 5209004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(10,5210001) ->
	#base_companion_skill{companion_id = 10,skill_id = 5210001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(10,5210002) ->
	#base_companion_skill{companion_id = 10,skill_id = 5210002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(10,5210003) ->
	#base_companion_skill{companion_id = 10,skill_id = 5210003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(10,5210004) ->
	#base_companion_skill{companion_id = 10,skill_id = 5210004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(11,5211001) ->
	#base_companion_skill{companion_id = 11,skill_id = 5211001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(11,5211002) ->
	#base_companion_skill{companion_id = 11,skill_id = 5211002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(11,5211003) ->
	#base_companion_skill{companion_id = 11,skill_id = 5211003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(11,5211004) ->
	#base_companion_skill{companion_id = 11,skill_id = 5211004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(12,5212001) ->
	#base_companion_skill{companion_id = 12,skill_id = 5212001,skill_type = 0,main_skill_lv = 1,unlock_stage = 1};

get_companion_skill(12,5212002) ->
	#base_companion_skill{companion_id = 12,skill_id = 5212002,skill_type = 1,main_skill_lv = 2,unlock_stage = 3};

get_companion_skill(12,5212003) ->
	#base_companion_skill{companion_id = 12,skill_id = 5212003,skill_type = 1,main_skill_lv = 3,unlock_stage = 6};

get_companion_skill(12,5212004) ->
	#base_companion_skill{companion_id = 12,skill_id = 5212004,skill_type = 1,main_skill_lv = 4,unlock_stage = 8};

get_companion_skill(_Companionid,_Skillid) ->
	[].


list_companion_skill_id(1) ->
[5201001,5201002,5201003,5201004];


list_companion_skill_id(2) ->
[5202001,5202002,5202003,5202004];


list_companion_skill_id(3) ->
[5203001,5203002,5203003,5203004];


list_companion_skill_id(4) ->
[5204001,5204002,5204003,5204004];


list_companion_skill_id(5) ->
[5205001,5205002,5205003,5205004];


list_companion_skill_id(6) ->
[5206001,5206002,5206003,5206004];


list_companion_skill_id(7) ->
[5207001,5207002,5207003,5207004];


list_companion_skill_id(8) ->
[5208001,5208002,5208003,5208004];


list_companion_skill_id(9) ->
[5209001,5209002,5209003,5209004];


list_companion_skill_id(10) ->
[5210001,5210002,5210003,5210004];


list_companion_skill_id(11) ->
[5211001,5211002,5211003,5211004];


list_companion_skill_id(12) ->
[5212001,5212002,5212003,5212004];

list_companion_skill_id(_Companionid) ->
	[].

get_companion_stage(1,1,0) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,1000},{2,20000},{3,500},{4,500}],other = []};

get_companion_stage(1,1,1) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,1030},{2,20600},{3,515},{4,515}],other = []};

get_companion_stage(1,1,2) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,1060},{2,21200},{3,530},{4,530}],other = []};

get_companion_stage(1,1,3) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,1090},{2,21800},{3,545},{4,545}],other = []};

get_companion_stage(1,1,4) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,1120},{2,22400},{3,560},{4,560}],other = []};

get_companion_stage(1,1,5) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,1150},{2,23000},{3,575},{4,575}],other = []};

get_companion_stage(1,1,6) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,1180},{2,23600},{3,590},{4,590}],other = []};

get_companion_stage(1,1,7) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,1210},{2,24200},{3,605},{4,605}],other = []};

get_companion_stage(1,1,8) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,1240},{2,24800},{3,620},{4,620}],other = []};

get_companion_stage(1,1,9) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,1270},{2,25400},{3,635},{4,635}],other = []};

get_companion_stage(1,1,10) ->
	#base_companion_stage{companion_id = 1,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,1330},{2,26600},{3,665},{4,665}],other = [{biog_reward, [{2,0,100},{0, 22030001, 3},{0, 22030101, 1}]}]};

get_companion_stage(1,2,1) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,1360},{2,27200},{3,680},{4,680}],other = []};

get_companion_stage(1,2,2) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,1390},{2,27800},{3,695},{4,695}],other = []};

get_companion_stage(1,2,3) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,1420},{2,28400},{3,710},{4,710}],other = []};

get_companion_stage(1,2,4) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,1450},{2,29000},{3,725},{4,725}],other = []};

get_companion_stage(1,2,5) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,1480},{2,29600},{3,740},{4,740}],other = []};

get_companion_stage(1,2,6) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,1510},{2,30200},{3,755},{4,755}],other = []};

get_companion_stage(1,2,7) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,1540},{2,30800},{3,770},{4,770}],other = []};

get_companion_stage(1,2,8) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,1570},{2,31400},{3,785},{4,785}],other = []};

get_companion_stage(1,2,9) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,1600},{2,32000},{3,800},{4,800}],other = []};

get_companion_stage(1,2,10) ->
	#base_companion_stage{companion_id = 1,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,1660},{2,33200},{3,830},{4,830}],other = []};

get_companion_stage(1,3,1) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,1690},{2,33800},{3,845},{4,845}],other = []};

get_companion_stage(1,3,2) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,1720},{2,34400},{3,860},{4,860}],other = []};

get_companion_stage(1,3,3) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,1750},{2,35000},{3,875},{4,875}],other = []};

get_companion_stage(1,3,4) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,1780},{2,35600},{3,890},{4,890}],other = []};

get_companion_stage(1,3,5) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,1810},{2,36200},{3,905},{4,905}],other = []};

get_companion_stage(1,3,6) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,1840},{2,36800},{3,920},{4,920}],other = []};

get_companion_stage(1,3,7) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,1870},{2,37400},{3,935},{4,935}],other = []};

get_companion_stage(1,3,8) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,1900},{2,38000},{3,950},{4,950}],other = []};

get_companion_stage(1,3,9) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,1930},{2,38600},{3,965},{4,965}],other = []};

get_companion_stage(1,3,10) ->
	#base_companion_stage{companion_id = 1,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,1990},{2,39800},{3,995},{4,995}],other = [{biog_reward, [{2,0,200},{0, 22030001, 5},{0, 22030101, 3}]}]};

get_companion_stage(1,4,1) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,2020},{2,40400},{3,1010},{4,1010}],other = []};

get_companion_stage(1,4,2) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,2050},{2,41000},{3,1025},{4,1025}],other = []};

get_companion_stage(1,4,3) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,2080},{2,41600},{3,1040},{4,1040}],other = []};

get_companion_stage(1,4,4) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,2110},{2,42200},{3,1055},{4,1055}],other = []};

get_companion_stage(1,4,5) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,2140},{2,42800},{3,1070},{4,1070}],other = []};

get_companion_stage(1,4,6) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,2170},{2,43400},{3,1085},{4,1085}],other = []};

get_companion_stage(1,4,7) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,2200},{2,44000},{3,1100},{4,1100}],other = []};

get_companion_stage(1,4,8) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,2230},{2,44600},{3,1115},{4,1115}],other = []};

get_companion_stage(1,4,9) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,2260},{2,45200},{3,1130},{4,1130}],other = []};

get_companion_stage(1,4,10) ->
	#base_companion_stage{companion_id = 1,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,2320},{2,46400},{3,1160},{4,1160}],other = []};

get_companion_stage(1,5,1) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,2350},{2,47000},{3,1175},{4,1175}],other = []};

get_companion_stage(1,5,2) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,2380},{2,47600},{3,1190},{4,1190}],other = []};

get_companion_stage(1,5,3) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,2410},{2,48200},{3,1205},{4,1205}],other = []};

get_companion_stage(1,5,4) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,2440},{2,48800},{3,1220},{4,1220}],other = []};

get_companion_stage(1,5,5) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,2470},{2,49400},{3,1235},{4,1235}],other = []};

get_companion_stage(1,5,6) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,2500},{2,50000},{3,1250},{4,1250}],other = []};

get_companion_stage(1,5,7) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,2530},{2,50600},{3,1265},{4,1265}],other = []};

get_companion_stage(1,5,8) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,2560},{2,51200},{3,1280},{4,1280}],other = []};

get_companion_stage(1,5,9) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,2590},{2,51800},{3,1295},{4,1295}],other = []};

get_companion_stage(1,5,10) ->
	#base_companion_stage{companion_id = 1,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,2650},{2,53000},{3,1325},{4,1325}],other = [{biog_reward, [{2,0,250},{0, 22030001, 10},{0, 22030101, 5}]}]};

get_companion_stage(1,6,1) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,2680},{2,53600},{3,1340},{4,1340}],other = []};

get_companion_stage(1,6,2) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,2710},{2,54200},{3,1355},{4,1355}],other = []};

get_companion_stage(1,6,3) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,2740},{2,54800},{3,1370},{4,1370}],other = []};

get_companion_stage(1,6,4) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,2770},{2,55400},{3,1385},{4,1385}],other = []};

get_companion_stage(1,6,5) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,2800},{2,56000},{3,1400},{4,1400}],other = []};

get_companion_stage(1,6,6) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,2830},{2,56600},{3,1415},{4,1415}],other = []};

get_companion_stage(1,6,7) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,2860},{2,57200},{3,1430},{4,1430}],other = []};

get_companion_stage(1,6,8) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,2890},{2,57800},{3,1445},{4,1445}],other = []};

get_companion_stage(1,6,9) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,2920},{2,58400},{3,1460},{4,1460}],other = []};

get_companion_stage(1,6,10) ->
	#base_companion_stage{companion_id = 1,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,2980},{2,59600},{3,1490},{4,1490}],other = []};

get_companion_stage(1,7,1) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,3010},{2,60200},{3,1505},{4,1505}],other = []};

get_companion_stage(1,7,2) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,3040},{2,60800},{3,1520},{4,1520}],other = []};

get_companion_stage(1,7,3) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,3070},{2,61400},{3,1535},{4,1535}],other = []};

get_companion_stage(1,7,4) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,3100},{2,62000},{3,1550},{4,1550}],other = []};

get_companion_stage(1,7,5) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,3130},{2,62600},{3,1565},{4,1565}],other = []};

get_companion_stage(1,7,6) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,3160},{2,63200},{3,1580},{4,1580}],other = []};

get_companion_stage(1,7,7) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,3190},{2,63800},{3,1595},{4,1595}],other = []};

get_companion_stage(1,7,8) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,3220},{2,64400},{3,1610},{4,1610}],other = []};

get_companion_stage(1,7,9) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,3250},{2,65000},{3,1625},{4,1625}],other = []};

get_companion_stage(1,7,10) ->
	#base_companion_stage{companion_id = 1,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,3310},{2,66200},{3,1655},{4,1655}],other = []};

get_companion_stage(1,8,1) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,3340},{2,66800},{3,1670},{4,1670}],other = []};

get_companion_stage(1,8,2) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,3370},{2,67400},{3,1685},{4,1685}],other = []};

get_companion_stage(1,8,3) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,3400},{2,68000},{3,1700},{4,1700}],other = []};

get_companion_stage(1,8,4) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,3430},{2,68600},{3,1715},{4,1715}],other = []};

get_companion_stage(1,8,5) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,3460},{2,69200},{3,1730},{4,1730}],other = []};

get_companion_stage(1,8,6) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,3490},{2,69800},{3,1745},{4,1745}],other = []};

get_companion_stage(1,8,7) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,3520},{2,70400},{3,1760},{4,1760}],other = []};

get_companion_stage(1,8,8) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,3550},{2,71000},{3,1775},{4,1775}],other = []};

get_companion_stage(1,8,9) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,3580},{2,71600},{3,1790},{4,1790}],other = []};

get_companion_stage(1,8,10) ->
	#base_companion_stage{companion_id = 1,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,3640},{2,72800},{3,1820},{4,1820}],other = []};

get_companion_stage(1,9,1) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,3670},{2,73400},{3,1835},{4,1835}],other = []};

get_companion_stage(1,9,2) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,3700},{2,74000},{3,1850},{4,1850}],other = []};

get_companion_stage(1,9,3) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,3730},{2,74600},{3,1865},{4,1865}],other = []};

get_companion_stage(1,9,4) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,3760},{2,75200},{3,1880},{4,1880}],other = []};

get_companion_stage(1,9,5) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,3790},{2,75800},{3,1895},{4,1895}],other = []};

get_companion_stage(1,9,6) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,3820},{2,76400},{3,1910},{4,1910}],other = []};

get_companion_stage(1,9,7) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,3850},{2,77000},{3,1925},{4,1925}],other = []};

get_companion_stage(1,9,8) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,3880},{2,77600},{3,1940},{4,1940}],other = []};

get_companion_stage(1,9,9) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,3910},{2,78200},{3,1955},{4,1955}],other = []};

get_companion_stage(1,9,10) ->
	#base_companion_stage{companion_id = 1,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,3970},{2,79400},{3,1985},{4,1985}],other = []};

get_companion_stage(1,10,1) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],other = []};

get_companion_stage(1,10,2) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,4030},{2,80600},{3,2015},{4,2015}],other = []};

get_companion_stage(1,10,3) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,4060},{2,81200},{3,2030},{4,2030}],other = []};

get_companion_stage(1,10,4) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,4090},{2,81800},{3,2045},{4,2045}],other = []};

get_companion_stage(1,10,5) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,4120},{2,82400},{3,2060},{4,2060}],other = []};

get_companion_stage(1,10,6) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,4150},{2,83000},{3,2075},{4,2075}],other = []};

get_companion_stage(1,10,7) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,4180},{2,83600},{3,2090},{4,2090}],other = []};

get_companion_stage(1,10,8) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,4210},{2,84200},{3,2105},{4,2105}],other = []};

get_companion_stage(1,10,9) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,4240},{2,84800},{3,2120},{4,2120}],other = []};

get_companion_stage(1,10,10) ->
	#base_companion_stage{companion_id = 1,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,4300},{2,86000},{3,2150},{4,2150}],other = []};

get_companion_stage(1,11,1) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,4330},{2,86600},{3,2165},{4,2165}],other = []};

get_companion_stage(1,11,2) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,4360},{2,87200},{3,2180},{4,2180}],other = []};

get_companion_stage(1,11,3) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,4390},{2,87800},{3,2195},{4,2195}],other = []};

get_companion_stage(1,11,4) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,4420},{2,88400},{3,2210},{4,2210}],other = []};

get_companion_stage(1,11,5) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,4450},{2,89000},{3,2225},{4,2225}],other = []};

get_companion_stage(1,11,6) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,4480},{2,89600},{3,2240},{4,2240}],other = []};

get_companion_stage(1,11,7) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,4510},{2,90200},{3,2255},{4,2255}],other = []};

get_companion_stage(1,11,8) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,4540},{2,90800},{3,2270},{4,2270}],other = []};

get_companion_stage(1,11,9) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,4570},{2,91400},{3,2285},{4,2285}],other = []};

get_companion_stage(1,11,10) ->
	#base_companion_stage{companion_id = 1,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,4630},{2,92600},{3,2315},{4,2315}],other = []};

get_companion_stage(1,12,1) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,4660},{2,93200},{3,2330},{4,2330}],other = []};

get_companion_stage(1,12,2) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,4690},{2,93800},{3,2345},{4,2345}],other = []};

get_companion_stage(1,12,3) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,4720},{2,94400},{3,2360},{4,2360}],other = []};

get_companion_stage(1,12,4) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,4750},{2,95000},{3,2375},{4,2375}],other = []};

get_companion_stage(1,12,5) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,4780},{2,95600},{3,2390},{4,2390}],other = []};

get_companion_stage(1,12,6) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,4810},{2,96200},{3,2405},{4,2405}],other = []};

get_companion_stage(1,12,7) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,4840},{2,96800},{3,2420},{4,2420}],other = []};

get_companion_stage(1,12,8) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,4870},{2,97400},{3,2435},{4,2435}],other = []};

get_companion_stage(1,12,9) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,4900},{2,98000},{3,2450},{4,2450}],other = []};

get_companion_stage(1,12,10) ->
	#base_companion_stage{companion_id = 1,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,4960},{2,99200},{3,2480},{4,2480}],other = []};

get_companion_stage(1,13,1) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,4990},{2,99800},{3,2495},{4,2495}],other = []};

get_companion_stage(1,13,2) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,5020},{2,100400},{3,2510},{4,2510}],other = []};

get_companion_stage(1,13,3) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,5050},{2,101000},{3,2525},{4,2525}],other = []};

get_companion_stage(1,13,4) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,5080},{2,101600},{3,2540},{4,2540}],other = []};

get_companion_stage(1,13,5) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,5110},{2,102200},{3,2555},{4,2555}],other = []};

get_companion_stage(1,13,6) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,5140},{2,102800},{3,2570},{4,2570}],other = []};

get_companion_stage(1,13,7) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,5170},{2,103400},{3,2585},{4,2585}],other = []};

get_companion_stage(1,13,8) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,5200},{2,104000},{3,2600},{4,2600}],other = []};

get_companion_stage(1,13,9) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,5230},{2,104600},{3,2615},{4,2615}],other = []};

get_companion_stage(1,13,10) ->
	#base_companion_stage{companion_id = 1,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,5290},{2,105800},{3,2645},{4,2645}],other = []};

get_companion_stage(1,14,1) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,5320},{2,106400},{3,2660},{4,2660}],other = []};

get_companion_stage(1,14,2) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,5350},{2,107000},{3,2675},{4,2675}],other = []};

get_companion_stage(1,14,3) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,5380},{2,107600},{3,2690},{4,2690}],other = []};

get_companion_stage(1,14,4) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,5410},{2,108200},{3,2705},{4,2705}],other = []};

get_companion_stage(1,14,5) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,5440},{2,108800},{3,2720},{4,2720}],other = []};

get_companion_stage(1,14,6) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,5470},{2,109400},{3,2735},{4,2735}],other = []};

get_companion_stage(1,14,7) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,5500},{2,110000},{3,2750},{4,2750}],other = []};

get_companion_stage(1,14,8) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,5530},{2,110600},{3,2765},{4,2765}],other = []};

get_companion_stage(1,14,9) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,5560},{2,111200},{3,2780},{4,2780}],other = []};

get_companion_stage(1,14,10) ->
	#base_companion_stage{companion_id = 1,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,5620},{2,112400},{3,2810},{4,2810}],other = []};

get_companion_stage(1,15,1) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,5650},{2,113000},{3,2825},{4,2825}],other = []};

get_companion_stage(1,15,2) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,5680},{2,113600},{3,2840},{4,2840}],other = []};

get_companion_stage(1,15,3) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,5710},{2,114200},{3,2855},{4,2855}],other = []};

get_companion_stage(1,15,4) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,5740},{2,114800},{3,2870},{4,2870}],other = []};

get_companion_stage(1,15,5) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,5770},{2,115400},{3,2885},{4,2885}],other = []};

get_companion_stage(1,15,6) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,5800},{2,116000},{3,2900},{4,2900}],other = []};

get_companion_stage(1,15,7) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,5830},{2,116600},{3,2915},{4,2915}],other = []};

get_companion_stage(1,15,8) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,5860},{2,117200},{3,2930},{4,2930}],other = []};

get_companion_stage(1,15,9) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,5890},{2,117800},{3,2945},{4,2945}],other = []};

get_companion_stage(1,15,10) ->
	#base_companion_stage{companion_id = 1,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,5950},{2,119000},{3,2975},{4,2975}],other = []};

get_companion_stage(1,16,1) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,5980},{2,119600},{3,2990},{4,2990}],other = []};

get_companion_stage(1,16,2) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,6010},{2,120200},{3,3005},{4,3005}],other = []};

get_companion_stage(1,16,3) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,6040},{2,120800},{3,3020},{4,3020}],other = []};

get_companion_stage(1,16,4) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,6070},{2,121400},{3,3035},{4,3035}],other = []};

get_companion_stage(1,16,5) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,6100},{2,122000},{3,3050},{4,3050}],other = []};

get_companion_stage(1,16,6) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,6130},{2,122600},{3,3065},{4,3065}],other = []};

get_companion_stage(1,16,7) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,6160},{2,123200},{3,3080},{4,3080}],other = []};

get_companion_stage(1,16,8) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,6190},{2,123800},{3,3095},{4,3095}],other = []};

get_companion_stage(1,16,9) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,6220},{2,124400},{3,3110},{4,3110}],other = []};

get_companion_stage(1,16,10) ->
	#base_companion_stage{companion_id = 1,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,6280},{2,125600},{3,3140},{4,3140}],other = []};

get_companion_stage(1,17,1) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,6310},{2,126200},{3,3155},{4,3155}],other = []};

get_companion_stage(1,17,2) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,6340},{2,126800},{3,3170},{4,3170}],other = []};

get_companion_stage(1,17,3) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,6370},{2,127400},{3,3185},{4,3185}],other = []};

get_companion_stage(1,17,4) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],other = []};

get_companion_stage(1,17,5) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,6430},{2,128600},{3,3215},{4,3215}],other = []};

get_companion_stage(1,17,6) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,6460},{2,129200},{3,3230},{4,3230}],other = []};

get_companion_stage(1,17,7) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,6490},{2,129800},{3,3245},{4,3245}],other = []};

get_companion_stage(1,17,8) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,6520},{2,130400},{3,3260},{4,3260}],other = []};

get_companion_stage(1,17,9) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,6550},{2,131000},{3,3275},{4,3275}],other = []};

get_companion_stage(1,17,10) ->
	#base_companion_stage{companion_id = 1,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,6610},{2,132200},{3,3305},{4,3305}],other = []};

get_companion_stage(1,18,1) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,6640},{2,132800},{3,3320},{4,3320}],other = []};

get_companion_stage(1,18,2) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,6670},{2,133400},{3,3335},{4,3335}],other = []};

get_companion_stage(1,18,3) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,6700},{2,134000},{3,3350},{4,3350}],other = []};

get_companion_stage(1,18,4) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,6730},{2,134600},{3,3365},{4,3365}],other = []};

get_companion_stage(1,18,5) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,6760},{2,135200},{3,3380},{4,3380}],other = []};

get_companion_stage(1,18,6) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,6790},{2,135800},{3,3395},{4,3395}],other = []};

get_companion_stage(1,18,7) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,6820},{2,136400},{3,3410},{4,3410}],other = []};

get_companion_stage(1,18,8) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,6850},{2,137000},{3,3425},{4,3425}],other = []};

get_companion_stage(1,18,9) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,6880},{2,137600},{3,3440},{4,3440}],other = []};

get_companion_stage(1,18,10) ->
	#base_companion_stage{companion_id = 1,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,6940},{2,138800},{3,3470},{4,3470}],other = []};

get_companion_stage(1,19,1) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,6970},{2,139400},{3,3485},{4,3485}],other = []};

get_companion_stage(1,19,2) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],other = []};

get_companion_stage(1,19,3) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,7030},{2,140600},{3,3515},{4,3515}],other = []};

get_companion_stage(1,19,4) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,7060},{2,141200},{3,3530},{4,3530}],other = []};

get_companion_stage(1,19,5) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,7090},{2,141800},{3,3545},{4,3545}],other = []};

get_companion_stage(1,19,6) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,7120},{2,142400},{3,3560},{4,3560}],other = []};

get_companion_stage(1,19,7) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,7150},{2,143000},{3,3575},{4,3575}],other = []};

get_companion_stage(1,19,8) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,7180},{2,143600},{3,3590},{4,3590}],other = []};

get_companion_stage(1,19,9) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,7210},{2,144200},{3,3605},{4,3605}],other = []};

get_companion_stage(1,19,10) ->
	#base_companion_stage{companion_id = 1,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,7270},{2,145400},{3,3635},{4,3635}],other = []};

get_companion_stage(1,20,1) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,7300},{2,146000},{3,3650},{4,3650}],other = []};

get_companion_stage(1,20,2) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,7330},{2,146600},{3,3665},{4,3665}],other = []};

get_companion_stage(1,20,3) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,7360},{2,147200},{3,3680},{4,3680}],other = []};

get_companion_stage(1,20,4) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,7390},{2,147800},{3,3695},{4,3695}],other = []};

get_companion_stage(1,20,5) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,7420},{2,148400},{3,3710},{4,3710}],other = []};

get_companion_stage(1,20,6) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,7450},{2,149000},{3,3725},{4,3725}],other = []};

get_companion_stage(1,20,7) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,7480},{2,149600},{3,3740},{4,3740}],other = []};

get_companion_stage(1,20,8) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,7510},{2,150200},{3,3755},{4,3755}],other = []};

get_companion_stage(1,20,9) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,7540},{2,150800},{3,3770},{4,3770}],other = []};

get_companion_stage(1,20,10) ->
	#base_companion_stage{companion_id = 1,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,7600},{2,152000},{3,3800},{4,3800}],other = []};

get_companion_stage(1,21,1) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,7630},{2,152600},{3,3815},{4,3815}],other = []};

get_companion_stage(1,21,2) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,7660},{2,153200},{3,3830},{4,3830}],other = []};

get_companion_stage(1,21,3) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,7690},{2,153800},{3,3845},{4,3845}],other = []};

get_companion_stage(1,21,4) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,7720},{2,154400},{3,3860},{4,3860}],other = []};

get_companion_stage(1,21,5) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,7750},{2,155000},{3,3875},{4,3875}],other = []};

get_companion_stage(1,21,6) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,7780},{2,155600},{3,3890},{4,3890}],other = []};

get_companion_stage(1,21,7) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,7810},{2,156200},{3,3905},{4,3905}],other = []};

get_companion_stage(1,21,8) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,7840},{2,156800},{3,3920},{4,3920}],other = []};

get_companion_stage(1,21,9) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,7870},{2,157400},{3,3935},{4,3935}],other = []};

get_companion_stage(1,21,10) ->
	#base_companion_stage{companion_id = 1,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,7930},{2,158600},{3,3965},{4,3965}],other = []};

get_companion_stage(1,22,1) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,7960},{2,159200},{3,3980},{4,3980}],other = []};

get_companion_stage(1,22,2) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,7990},{2,159800},{3,3995},{4,3995}],other = []};

get_companion_stage(1,22,3) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,8020},{2,160400},{3,4010},{4,4010}],other = []};

get_companion_stage(1,22,4) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,8050},{2,161000},{3,4025},{4,4025}],other = []};

get_companion_stage(1,22,5) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,8080},{2,161600},{3,4040},{4,4040}],other = []};

get_companion_stage(1,22,6) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,8110},{2,162200},{3,4055},{4,4055}],other = []};

get_companion_stage(1,22,7) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,8140},{2,162800},{3,4070},{4,4070}],other = []};

get_companion_stage(1,22,8) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,8170},{2,163400},{3,4085},{4,4085}],other = []};

get_companion_stage(1,22,9) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,8200},{2,164000},{3,4100},{4,4100}],other = []};

get_companion_stage(1,22,10) ->
	#base_companion_stage{companion_id = 1,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,8260},{2,165200},{3,4130},{4,4130}],other = []};

get_companion_stage(1,23,1) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,8290},{2,165800},{3,4145},{4,4145}],other = []};

get_companion_stage(1,23,2) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,8320},{2,166400},{3,4160},{4,4160}],other = []};

get_companion_stage(1,23,3) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,8350},{2,167000},{3,4175},{4,4175}],other = []};

get_companion_stage(1,23,4) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,8380},{2,167600},{3,4190},{4,4190}],other = []};

get_companion_stage(1,23,5) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,8410},{2,168200},{3,4205},{4,4205}],other = []};

get_companion_stage(1,23,6) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,8440},{2,168800},{3,4220},{4,4220}],other = []};

get_companion_stage(1,23,7) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,8470},{2,169400},{3,4235},{4,4235}],other = []};

get_companion_stage(1,23,8) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,8500},{2,170000},{3,4250},{4,4250}],other = []};

get_companion_stage(1,23,9) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,8530},{2,170600},{3,4265},{4,4265}],other = []};

get_companion_stage(1,23,10) ->
	#base_companion_stage{companion_id = 1,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,8590},{2,171800},{3,4295},{4,4295}],other = []};

get_companion_stage(1,24,1) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,8620},{2,172400},{3,4310},{4,4310}],other = []};

get_companion_stage(1,24,2) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,8650},{2,173000},{3,4325},{4,4325}],other = []};

get_companion_stage(1,24,3) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,8680},{2,173600},{3,4340},{4,4340}],other = []};

get_companion_stage(1,24,4) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,8710},{2,174200},{3,4355},{4,4355}],other = []};

get_companion_stage(1,24,5) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,8740},{2,174800},{3,4370},{4,4370}],other = []};

get_companion_stage(1,24,6) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,8770},{2,175400},{3,4385},{4,4385}],other = []};

get_companion_stage(1,24,7) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,8800},{2,176000},{3,4400},{4,4400}],other = []};

get_companion_stage(1,24,8) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,8830},{2,176600},{3,4415},{4,4415}],other = []};

get_companion_stage(1,24,9) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,8860},{2,177200},{3,4430},{4,4430}],other = []};

get_companion_stage(1,24,10) ->
	#base_companion_stage{companion_id = 1,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,8920},{2,178400},{3,4460},{4,4460}],other = []};

get_companion_stage(1,25,1) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,8950},{2,179000},{3,4475},{4,4475}],other = []};

get_companion_stage(1,25,2) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,8980},{2,179600},{3,4490},{4,4490}],other = []};

get_companion_stage(1,25,3) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,9010},{2,180200},{3,4505},{4,4505}],other = []};

get_companion_stage(1,25,4) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,9040},{2,180800},{3,4520},{4,4520}],other = []};

get_companion_stage(1,25,5) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,9070},{2,181400},{3,4535},{4,4535}],other = []};

get_companion_stage(1,25,6) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,9100},{2,182000},{3,4550},{4,4550}],other = []};

get_companion_stage(1,25,7) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,9130},{2,182600},{3,4565},{4,4565}],other = []};

get_companion_stage(1,25,8) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,9160},{2,183200},{3,4580},{4,4580}],other = []};

get_companion_stage(1,25,9) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,9190},{2,183800},{3,4595},{4,4595}],other = []};

get_companion_stage(1,25,10) ->
	#base_companion_stage{companion_id = 1,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,9250},{2,185000},{3,4625},{4,4625}],other = []};

get_companion_stage(1,26,1) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,9280},{2,185600},{3,4640},{4,4640}],other = []};

get_companion_stage(1,26,2) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,9310},{2,186200},{3,4655},{4,4655}],other = []};

get_companion_stage(1,26,3) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,9340},{2,186800},{3,4670},{4,4670}],other = []};

get_companion_stage(1,26,4) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,9370},{2,187400},{3,4685},{4,4685}],other = []};

get_companion_stage(1,26,5) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,9400},{2,188000},{3,4700},{4,4700}],other = []};

get_companion_stage(1,26,6) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,9430},{2,188600},{3,4715},{4,4715}],other = []};

get_companion_stage(1,26,7) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,9460},{2,189200},{3,4730},{4,4730}],other = []};

get_companion_stage(1,26,8) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,9490},{2,189800},{3,4745},{4,4745}],other = []};

get_companion_stage(1,26,9) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,9520},{2,190400},{3,4760},{4,4760}],other = []};

get_companion_stage(1,26,10) ->
	#base_companion_stage{companion_id = 1,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,9580},{2,191600},{3,4790},{4,4790}],other = []};

get_companion_stage(1,27,1) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,9610},{2,192200},{3,4805},{4,4805}],other = []};

get_companion_stage(1,27,2) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,9640},{2,192800},{3,4820},{4,4820}],other = []};

get_companion_stage(1,27,3) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,9670},{2,193400},{3,4835},{4,4835}],other = []};

get_companion_stage(1,27,4) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,9700},{2,194000},{3,4850},{4,4850}],other = []};

get_companion_stage(1,27,5) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,9730},{2,194600},{3,4865},{4,4865}],other = []};

get_companion_stage(1,27,6) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,9760},{2,195200},{3,4880},{4,4880}],other = []};

get_companion_stage(1,27,7) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,9790},{2,195800},{3,4895},{4,4895}],other = []};

get_companion_stage(1,27,8) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,9820},{2,196400},{3,4910},{4,4910}],other = []};

get_companion_stage(1,27,9) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,9850},{2,197000},{3,4925},{4,4925}],other = []};

get_companion_stage(1,27,10) ->
	#base_companion_stage{companion_id = 1,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,9910},{2,198200},{3,4955},{4,4955}],other = []};

get_companion_stage(1,28,1) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,9940},{2,198800},{3,4970},{4,4970}],other = []};

get_companion_stage(1,28,2) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,9970},{2,199400},{3,4985},{4,4985}],other = []};

get_companion_stage(1,28,3) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,10000},{2,200000},{3,5000},{4,5000}],other = []};

get_companion_stage(1,28,4) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,10030},{2,200600},{3,5015},{4,5015}],other = []};

get_companion_stage(1,28,5) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,10060},{2,201200},{3,5030},{4,5030}],other = []};

get_companion_stage(1,28,6) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,10090},{2,201800},{3,5045},{4,5045}],other = []};

get_companion_stage(1,28,7) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,10120},{2,202400},{3,5060},{4,5060}],other = []};

get_companion_stage(1,28,8) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,10150},{2,203000},{3,5075},{4,5075}],other = []};

get_companion_stage(1,28,9) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,10180},{2,203600},{3,5090},{4,5090}],other = []};

get_companion_stage(1,28,10) ->
	#base_companion_stage{companion_id = 1,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,10240},{2,204800},{3,5120},{4,5120}],other = []};

get_companion_stage(1,29,1) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,10270},{2,205400},{3,5135},{4,5135}],other = []};

get_companion_stage(1,29,2) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,10300},{2,206000},{3,5150},{4,5150}],other = []};

get_companion_stage(1,29,3) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,10330},{2,206600},{3,5165},{4,5165}],other = []};

get_companion_stage(1,29,4) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,10360},{2,207200},{3,5180},{4,5180}],other = []};

get_companion_stage(1,29,5) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,10390},{2,207800},{3,5195},{4,5195}],other = []};

get_companion_stage(1,29,6) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,10420},{2,208400},{3,5210},{4,5210}],other = []};

get_companion_stage(1,29,7) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,10450},{2,209000},{3,5225},{4,5225}],other = []};

get_companion_stage(1,29,8) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,10480},{2,209600},{3,5240},{4,5240}],other = []};

get_companion_stage(1,29,9) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,10510},{2,210200},{3,5255},{4,5255}],other = []};

get_companion_stage(1,29,10) ->
	#base_companion_stage{companion_id = 1,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,10570},{2,211400},{3,5285},{4,5285}],other = []};

get_companion_stage(1,30,1) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,10600},{2,212000},{3,5300},{4,5300}],other = []};

get_companion_stage(1,30,2) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,10630},{2,212600},{3,5315},{4,5315}],other = []};

get_companion_stage(1,30,3) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,10660},{2,213200},{3,5330},{4,5330}],other = []};

get_companion_stage(1,30,4) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,10690},{2,213800},{3,5345},{4,5345}],other = []};

get_companion_stage(1,30,5) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,10720},{2,214400},{3,5360},{4,5360}],other = []};

get_companion_stage(1,30,6) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,10750},{2,215000},{3,5375},{4,5375}],other = []};

get_companion_stage(1,30,7) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,10780},{2,215600},{3,5390},{4,5390}],other = []};

get_companion_stage(1,30,8) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,10810},{2,216200},{3,5405},{4,5405}],other = []};

get_companion_stage(1,30,9) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,10840},{2,216800},{3,5420},{4,5420}],other = []};

get_companion_stage(1,30,10) ->
	#base_companion_stage{companion_id = 1,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,10900},{2,218000},{3,5450},{4,5450}],other = []};

get_companion_stage(2,1,0) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,1600},{2,32000},{3,800},{4,800}],other = []};

get_companion_stage(2,1,1) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 1,biography = 0,need_blessing = 13,attr = [{1,1634},{2,32680},{3,817},{4,817}],other = []};

get_companion_stage(2,1,2) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 2,biography = 0,need_blessing = 16,attr = [{1,1668},{2,33360},{3,834},{4,834}],other = []};

get_companion_stage(2,1,3) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 3,biography = 0,need_blessing = 19,attr = [{1,1702},{2,34040},{3,851},{4,851}],other = []};

get_companion_stage(2,1,4) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 4,biography = 0,need_blessing = 22,attr = [{1,1736},{2,34720},{3,868},{4,868}],other = []};

get_companion_stage(2,1,5) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 5,biography = 0,need_blessing = 26,attr = [{1,1770},{2,35400},{3,885},{4,885}],other = []};

get_companion_stage(2,1,6) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 6,biography = 0,need_blessing = 30,attr = [{1,1804},{2,36080},{3,902},{4,902}],other = []};

get_companion_stage(2,1,7) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 7,biography = 0,need_blessing = 35,attr = [{1,1838},{2,36760},{3,919},{4,919}],other = []};

get_companion_stage(2,1,8) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 8,biography = 0,need_blessing = 39,attr = [{1,1872},{2,37440},{3,936},{4,936}],other = []};

get_companion_stage(2,1,9) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 9,biography = 0,need_blessing = 44,attr = [{1,1906},{2,38120},{3,953},{4,953}],other = []};

get_companion_stage(2,1,10) ->
	#base_companion_stage{companion_id = 2,stage = 1,star = 10,biography = 1,need_blessing = 49,attr = [{1,1974},{2,39480},{3,987},{4,987}],other = [{biog_reward, [{2,0,100},{0, 22030002, 3},{0, 22030102, 1}]}]};

get_companion_stage(2,2,1) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 1,biography = 0,need_blessing = 54,attr = [{1,2008},{2,40160},{3,1004},{4,1004}],other = []};

get_companion_stage(2,2,2) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 2,biography = 0,need_blessing = 60,attr = [{1,2042},{2,40840},{3,1021},{4,1021}],other = []};

get_companion_stage(2,2,3) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 3,biography = 0,need_blessing = 66,attr = [{1,2076},{2,41520},{3,1038},{4,1038}],other = []};

get_companion_stage(2,2,4) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 4,biography = 0,need_blessing = 72,attr = [{1,2110},{2,42200},{3,1055},{4,1055}],other = []};

get_companion_stage(2,2,5) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 5,biography = 0,need_blessing = 78,attr = [{1,2144},{2,42880},{3,1072},{4,1072}],other = []};

get_companion_stage(2,2,6) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 6,biography = 0,need_blessing = 84,attr = [{1,2178},{2,43560},{3,1089},{4,1089}],other = []};

get_companion_stage(2,2,7) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 7,biography = 0,need_blessing = 90,attr = [{1,2212},{2,44240},{3,1106},{4,1106}],other = []};

get_companion_stage(2,2,8) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 8,biography = 0,need_blessing = 97,attr = [{1,2246},{2,44920},{3,1123},{4,1123}],other = []};

get_companion_stage(2,2,9) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 9,biography = 0,need_blessing = 104,attr = [{1,2280},{2,45600},{3,1140},{4,1140}],other = []};

get_companion_stage(2,2,10) ->
	#base_companion_stage{companion_id = 2,stage = 2,star = 10,biography = 0,need_blessing = 111,attr = [{1,2348},{2,46960},{3,1174},{4,1174}],other = []};

get_companion_stage(2,3,1) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 1,biography = 0,need_blessing = 118,attr = [{1,2382},{2,47640},{3,1191},{4,1191}],other = []};

get_companion_stage(2,3,2) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 2,biography = 0,need_blessing = 125,attr = [{1,2416},{2,48320},{3,1208},{4,1208}],other = []};

get_companion_stage(2,3,3) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 3,biography = 0,need_blessing = 133,attr = [{1,2450},{2,49000},{3,1225},{4,1225}],other = []};

get_companion_stage(2,3,4) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 4,biography = 0,need_blessing = 140,attr = [{1,2484},{2,49680},{3,1242},{4,1242}],other = []};

get_companion_stage(2,3,5) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 5,biography = 0,need_blessing = 148,attr = [{1,2518},{2,50360},{3,1259},{4,1259}],other = []};

get_companion_stage(2,3,6) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 6,biography = 0,need_blessing = 156,attr = [{1,2552},{2,51040},{3,1276},{4,1276}],other = []};

get_companion_stage(2,3,7) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 7,biography = 0,need_blessing = 164,attr = [{1,2586},{2,51720},{3,1293},{4,1293}],other = []};

get_companion_stage(2,3,8) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 8,biography = 0,need_blessing = 172,attr = [{1,2620},{2,52400},{3,1310},{4,1310}],other = []};

get_companion_stage(2,3,9) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 9,biography = 0,need_blessing = 180,attr = [{1,2654},{2,53080},{3,1327},{4,1327}],other = []};

get_companion_stage(2,3,10) ->
	#base_companion_stage{companion_id = 2,stage = 3,star = 10,biography = 2,need_blessing = 189,attr = [{1,2722},{2,54440},{3,1361},{4,1361}],other = [{biog_reward, [{2,0,200},{0, 22030002, 5},{0, 22030102, 3}]}]};

get_companion_stage(2,4,1) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 1,biography = 0,need_blessing = 197,attr = [{1,2756},{2,55120},{3,1378},{4,1378}],other = []};

get_companion_stage(2,4,2) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 2,biography = 0,need_blessing = 206,attr = [{1,2790},{2,55800},{3,1395},{4,1395}],other = []};

get_companion_stage(2,4,3) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 3,biography = 0,need_blessing = 215,attr = [{1,2824},{2,56480},{3,1412},{4,1412}],other = []};

get_companion_stage(2,4,4) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 4,biography = 0,need_blessing = 224,attr = [{1,2858},{2,57160},{3,1429},{4,1429}],other = []};

get_companion_stage(2,4,5) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 5,biography = 0,need_blessing = 233,attr = [{1,2892},{2,57840},{3,1446},{4,1446}],other = []};

get_companion_stage(2,4,6) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 6,biography = 0,need_blessing = 242,attr = [{1,2926},{2,58520},{3,1463},{4,1463}],other = []};

get_companion_stage(2,4,7) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 7,biography = 0,need_blessing = 251,attr = [{1,2960},{2,59200},{3,1480},{4,1480}],other = []};

get_companion_stage(2,4,8) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 8,biography = 0,need_blessing = 260,attr = [{1,2994},{2,59880},{3,1497},{4,1497}],other = []};

get_companion_stage(2,4,9) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 9,biography = 0,need_blessing = 270,attr = [{1,3028},{2,60560},{3,1514},{4,1514}],other = []};

get_companion_stage(2,4,10) ->
	#base_companion_stage{companion_id = 2,stage = 4,star = 10,biography = 0,need_blessing = 280,attr = [{1,3096},{2,61920},{3,1548},{4,1548}],other = []};

get_companion_stage(2,5,1) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 1,biography = 0,need_blessing = 289,attr = [{1,3130},{2,62600},{3,1565},{4,1565}],other = []};

get_companion_stage(2,5,2) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 2,biography = 0,need_blessing = 299,attr = [{1,3164},{2,63280},{3,1582},{4,1582}],other = []};

get_companion_stage(2,5,3) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 3,biography = 0,need_blessing = 309,attr = [{1,3198},{2,63960},{3,1599},{4,1599}],other = []};

get_companion_stage(2,5,4) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 4,biography = 0,need_blessing = 319,attr = [{1,3232},{2,64640},{3,1616},{4,1616}],other = []};

get_companion_stage(2,5,5) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 5,biography = 0,need_blessing = 330,attr = [{1,3266},{2,65320},{3,1633},{4,1633}],other = []};

get_companion_stage(2,5,6) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 6,biography = 0,need_blessing = 340,attr = [{1,3300},{2,66000},{3,1650},{4,1650}],other = []};

get_companion_stage(2,5,7) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 7,biography = 0,need_blessing = 351,attr = [{1,3334},{2,66680},{3,1667},{4,1667}],other = []};

get_companion_stage(2,5,8) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 8,biography = 0,need_blessing = 361,attr = [{1,3368},{2,67360},{3,1684},{4,1684}],other = []};

get_companion_stage(2,5,9) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 9,biography = 0,need_blessing = 372,attr = [{1,3402},{2,68040},{3,1701},{4,1701}],other = []};

get_companion_stage(2,5,10) ->
	#base_companion_stage{companion_id = 2,stage = 5,star = 10,biography = 3,need_blessing = 382,attr = [{1,3470},{2,69400},{3,1735},{4,1735}],other = [{biog_reward, [{2,0,250},{0, 22030002, 10},{0, 22030102, 5}]}]};

get_companion_stage(2,6,1) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 1,biography = 0,need_blessing = 393,attr = [{1,3504},{2,70080},{3,1752},{4,1752}],other = []};

get_companion_stage(2,6,2) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 2,biography = 0,need_blessing = 404,attr = [{1,3538},{2,70760},{3,1769},{4,1769}],other = []};

get_companion_stage(2,6,3) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 3,biography = 0,need_blessing = 415,attr = [{1,3572},{2,71440},{3,1786},{4,1786}],other = []};

get_companion_stage(2,6,4) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 4,biography = 0,need_blessing = 427,attr = [{1,3606},{2,72120},{3,1803},{4,1803}],other = []};

get_companion_stage(2,6,5) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 5,biography = 0,need_blessing = 438,attr = [{1,3640},{2,72800},{3,1820},{4,1820}],other = []};

get_companion_stage(2,6,6) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 6,biography = 0,need_blessing = 449,attr = [{1,3674},{2,73480},{3,1837},{4,1837}],other = []};

get_companion_stage(2,6,7) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 7,biography = 0,need_blessing = 461,attr = [{1,3708},{2,74160},{3,1854},{4,1854}],other = []};

get_companion_stage(2,6,8) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 8,biography = 0,need_blessing = 472,attr = [{1,3742},{2,74840},{3,1871},{4,1871}],other = []};

get_companion_stage(2,6,9) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 9,biography = 0,need_blessing = 484,attr = [{1,3776},{2,75520},{3,1888},{4,1888}],other = []};

get_companion_stage(2,6,10) ->
	#base_companion_stage{companion_id = 2,stage = 6,star = 10,biography = 0,need_blessing = 496,attr = [{1,3844},{2,76880},{3,1922},{4,1922}],other = []};

get_companion_stage(2,7,1) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 1,biography = 0,need_blessing = 508,attr = [{1,3878},{2,77560},{3,1939},{4,1939}],other = []};

get_companion_stage(2,7,2) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 2,biography = 0,need_blessing = 520,attr = [{1,3912},{2,78240},{3,1956},{4,1956}],other = []};

get_companion_stage(2,7,3) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 3,biography = 0,need_blessing = 532,attr = [{1,3946},{2,78920},{3,1973},{4,1973}],other = []};

get_companion_stage(2,7,4) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 4,biography = 0,need_blessing = 544,attr = [{1,3980},{2,79600},{3,1990},{4,1990}],other = []};

get_companion_stage(2,7,5) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 5,biography = 0,need_blessing = 556,attr = [{1,4014},{2,80280},{3,2007},{4,2007}],other = []};

get_companion_stage(2,7,6) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 6,biography = 0,need_blessing = 568,attr = [{1,4048},{2,80960},{3,2024},{4,2024}],other = []};

get_companion_stage(2,7,7) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 7,biography = 0,need_blessing = 581,attr = [{1,4082},{2,81640},{3,2041},{4,2041}],other = []};

get_companion_stage(2,7,8) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 8,biography = 0,need_blessing = 593,attr = [{1,4116},{2,82320},{3,2058},{4,2058}],other = []};

get_companion_stage(2,7,9) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 9,biography = 0,need_blessing = 606,attr = [{1,4150},{2,83000},{3,2075},{4,2075}],other = []};

get_companion_stage(2,7,10) ->
	#base_companion_stage{companion_id = 2,stage = 7,star = 10,biography = 0,need_blessing = 618,attr = [{1,4218},{2,84360},{3,2109},{4,2109}],other = []};

get_companion_stage(2,8,1) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 1,biography = 0,need_blessing = 631,attr = [{1,4252},{2,85040},{3,2126},{4,2126}],other = []};

get_companion_stage(2,8,2) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 2,biography = 0,need_blessing = 644,attr = [{1,4286},{2,85720},{3,2143},{4,2143}],other = []};

get_companion_stage(2,8,3) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 3,biography = 0,need_blessing = 657,attr = [{1,4320},{2,86400},{3,2160},{4,2160}],other = []};

get_companion_stage(2,8,4) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 4,biography = 0,need_blessing = 670,attr = [{1,4354},{2,87080},{3,2177},{4,2177}],other = []};

get_companion_stage(2,8,5) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 5,biography = 0,need_blessing = 683,attr = [{1,4388},{2,87760},{3,2194},{4,2194}],other = []};

get_companion_stage(2,8,6) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 6,biography = 0,need_blessing = 696,attr = [{1,4422},{2,88440},{3,2211},{4,2211}],other = []};

get_companion_stage(2,8,7) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 7,biography = 0,need_blessing = 710,attr = [{1,4456},{2,89120},{3,2228},{4,2228}],other = []};

get_companion_stage(2,8,8) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 8,biography = 0,need_blessing = 723,attr = [{1,4490},{2,89800},{3,2245},{4,2245}],other = []};

get_companion_stage(2,8,9) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 9,biography = 0,need_blessing = 737,attr = [{1,4524},{2,90480},{3,2262},{4,2262}],other = []};

get_companion_stage(2,8,10) ->
	#base_companion_stage{companion_id = 2,stage = 8,star = 10,biography = 0,need_blessing = 750,attr = [{1,4592},{2,91840},{3,2296},{4,2296}],other = []};

get_companion_stage(2,9,1) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 1,biography = 0,need_blessing = 764,attr = [{1,4626},{2,92520},{3,2313},{4,2313}],other = []};

get_companion_stage(2,9,2) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 2,biography = 0,need_blessing = 777,attr = [{1,4660},{2,93200},{3,2330},{4,2330}],other = []};

get_companion_stage(2,9,3) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 3,biography = 0,need_blessing = 791,attr = [{1,4694},{2,93880},{3,2347},{4,2347}],other = []};

get_companion_stage(2,9,4) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 4,biography = 0,need_blessing = 805,attr = [{1,4728},{2,94560},{3,2364},{4,2364}],other = []};

get_companion_stage(2,9,5) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 5,biography = 0,need_blessing = 819,attr = [{1,4762},{2,95240},{3,2381},{4,2381}],other = []};

get_companion_stage(2,9,6) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 6,biography = 0,need_blessing = 833,attr = [{1,4796},{2,95920},{3,2398},{4,2398}],other = []};

get_companion_stage(2,9,7) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 7,biography = 0,need_blessing = 847,attr = [{1,4830},{2,96600},{3,2415},{4,2415}],other = []};

get_companion_stage(2,9,8) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 8,biography = 0,need_blessing = 861,attr = [{1,4864},{2,97280},{3,2432},{4,2432}],other = []};

get_companion_stage(2,9,9) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 9,biography = 0,need_blessing = 876,attr = [{1,4898},{2,97960},{3,2449},{4,2449}],other = []};

get_companion_stage(2,9,10) ->
	#base_companion_stage{companion_id = 2,stage = 9,star = 10,biography = 0,need_blessing = 890,attr = [{1,4966},{2,99320},{3,2483},{4,2483}],other = []};

get_companion_stage(2,10,1) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 1,biography = 0,need_blessing = 904,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],other = []};

get_companion_stage(2,10,2) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 2,biography = 0,need_blessing = 919,attr = [{1,5034},{2,100680},{3,2517},{4,2517}],other = []};

get_companion_stage(2,10,3) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 3,biography = 0,need_blessing = 933,attr = [{1,5068},{2,101360},{3,2534},{4,2534}],other = []};

get_companion_stage(2,10,4) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 4,biography = 0,need_blessing = 948,attr = [{1,5102},{2,102040},{3,2551},{4,2551}],other = []};

get_companion_stage(2,10,5) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 5,biography = 0,need_blessing = 963,attr = [{1,5136},{2,102720},{3,2568},{4,2568}],other = []};

get_companion_stage(2,10,6) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 6,biography = 0,need_blessing = 978,attr = [{1,5170},{2,103400},{3,2585},{4,2585}],other = []};

get_companion_stage(2,10,7) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 7,biography = 0,need_blessing = 993,attr = [{1,5204},{2,104080},{3,2602},{4,2602}],other = []};

get_companion_stage(2,10,8) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 8,biography = 0,need_blessing = 1008,attr = [{1,5238},{2,104760},{3,2619},{4,2619}],other = []};

get_companion_stage(2,10,9) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 9,biography = 0,need_blessing = 1023,attr = [{1,5272},{2,105440},{3,2636},{4,2636}],other = []};

get_companion_stage(2,10,10) ->
	#base_companion_stage{companion_id = 2,stage = 10,star = 10,biography = 0,need_blessing = 1038,attr = [{1,5340},{2,106800},{3,2670},{4,2670}],other = []};

get_companion_stage(2,11,1) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 1,biography = 0,need_blessing = 1053,attr = [{1,5374},{2,107480},{3,2687},{4,2687}],other = []};

get_companion_stage(2,11,2) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 2,biography = 0,need_blessing = 1068,attr = [{1,5408},{2,108160},{3,2704},{4,2704}],other = []};

get_companion_stage(2,11,3) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 3,biography = 0,need_blessing = 1083,attr = [{1,5442},{2,108840},{3,2721},{4,2721}],other = []};

get_companion_stage(2,11,4) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 4,biography = 0,need_blessing = 1099,attr = [{1,5476},{2,109520},{3,2738},{4,2738}],other = []};

get_companion_stage(2,11,5) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 5,biography = 0,need_blessing = 1114,attr = [{1,5510},{2,110200},{3,2755},{4,2755}],other = []};

get_companion_stage(2,11,6) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 6,biography = 0,need_blessing = 1130,attr = [{1,5544},{2,110880},{3,2772},{4,2772}],other = []};

get_companion_stage(2,11,7) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 7,biography = 0,need_blessing = 1145,attr = [{1,5578},{2,111560},{3,2789},{4,2789}],other = []};

get_companion_stage(2,11,8) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 8,biography = 0,need_blessing = 1161,attr = [{1,5612},{2,112240},{3,2806},{4,2806}],other = []};

get_companion_stage(2,11,9) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 9,biography = 0,need_blessing = 1177,attr = [{1,5646},{2,112920},{3,2823},{4,2823}],other = []};

get_companion_stage(2,11,10) ->
	#base_companion_stage{companion_id = 2,stage = 11,star = 10,biography = 0,need_blessing = 1193,attr = [{1,5714},{2,114280},{3,2857},{4,2857}],other = []};

get_companion_stage(2,12,1) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 1,biography = 0,need_blessing = 1209,attr = [{1,5748},{2,114960},{3,2874},{4,2874}],other = []};

get_companion_stage(2,12,2) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 2,biography = 0,need_blessing = 1225,attr = [{1,5782},{2,115640},{3,2891},{4,2891}],other = []};

get_companion_stage(2,12,3) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 3,biography = 0,need_blessing = 1241,attr = [{1,5816},{2,116320},{3,2908},{4,2908}],other = []};

get_companion_stage(2,12,4) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 4,biography = 0,need_blessing = 1257,attr = [{1,5850},{2,117000},{3,2925},{4,2925}],other = []};

get_companion_stage(2,12,5) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 5,biography = 0,need_blessing = 1273,attr = [{1,5884},{2,117680},{3,2942},{4,2942}],other = []};

get_companion_stage(2,12,6) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 6,biography = 0,need_blessing = 1289,attr = [{1,5918},{2,118360},{3,2959},{4,2959}],other = []};

get_companion_stage(2,12,7) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 7,biography = 0,need_blessing = 1306,attr = [{1,5952},{2,119040},{3,2976},{4,2976}],other = []};

get_companion_stage(2,12,8) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 8,biography = 0,need_blessing = 1322,attr = [{1,5986},{2,119720},{3,2993},{4,2993}],other = []};

get_companion_stage(2,12,9) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 9,biography = 0,need_blessing = 1339,attr = [{1,6020},{2,120400},{3,3010},{4,3010}],other = []};

get_companion_stage(2,12,10) ->
	#base_companion_stage{companion_id = 2,stage = 12,star = 10,biography = 0,need_blessing = 1355,attr = [{1,6088},{2,121760},{3,3044},{4,3044}],other = []};

get_companion_stage(2,13,1) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 1,biography = 0,need_blessing = 1372,attr = [{1,6122},{2,122440},{3,3061},{4,3061}],other = []};

get_companion_stage(2,13,2) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 2,biography = 0,need_blessing = 1388,attr = [{1,6156},{2,123120},{3,3078},{4,3078}],other = []};

get_companion_stage(2,13,3) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 3,biography = 0,need_blessing = 1405,attr = [{1,6190},{2,123800},{3,3095},{4,3095}],other = []};

get_companion_stage(2,13,4) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 4,biography = 0,need_blessing = 1422,attr = [{1,6224},{2,124480},{3,3112},{4,3112}],other = []};

get_companion_stage(2,13,5) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 5,biography = 0,need_blessing = 1439,attr = [{1,6258},{2,125160},{3,3129},{4,3129}],other = []};

get_companion_stage(2,13,6) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 6,biography = 0,need_blessing = 1456,attr = [{1,6292},{2,125840},{3,3146},{4,3146}],other = []};

get_companion_stage(2,13,7) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 7,biography = 0,need_blessing = 1473,attr = [{1,6326},{2,126520},{3,3163},{4,3163}],other = []};

get_companion_stage(2,13,8) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 8,biography = 0,need_blessing = 1490,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],other = []};

get_companion_stage(2,13,9) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 9,biography = 0,need_blessing = 1507,attr = [{1,6394},{2,127880},{3,3197},{4,3197}],other = []};

get_companion_stage(2,13,10) ->
	#base_companion_stage{companion_id = 2,stage = 13,star = 10,biography = 0,need_blessing = 1524,attr = [{1,6462},{2,129240},{3,3231},{4,3231}],other = []};

get_companion_stage(2,14,1) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 1,biography = 0,need_blessing = 1541,attr = [{1,6496},{2,129920},{3,3248},{4,3248}],other = []};

get_companion_stage(2,14,2) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 2,biography = 0,need_blessing = 1559,attr = [{1,6530},{2,130600},{3,3265},{4,3265}],other = []};

get_companion_stage(2,14,3) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 3,biography = 0,need_blessing = 1576,attr = [{1,6564},{2,131280},{3,3282},{4,3282}],other = []};

get_companion_stage(2,14,4) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 4,biography = 0,need_blessing = 1594,attr = [{1,6598},{2,131960},{3,3299},{4,3299}],other = []};

get_companion_stage(2,14,5) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 5,biography = 0,need_blessing = 1611,attr = [{1,6632},{2,132640},{3,3316},{4,3316}],other = []};

get_companion_stage(2,14,6) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 6,biography = 0,need_blessing = 1629,attr = [{1,6666},{2,133320},{3,3333},{4,3333}],other = []};

get_companion_stage(2,14,7) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 7,biography = 0,need_blessing = 1646,attr = [{1,6700},{2,134000},{3,3350},{4,3350}],other = []};

get_companion_stage(2,14,8) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 8,biography = 0,need_blessing = 1664,attr = [{1,6734},{2,134680},{3,3367},{4,3367}],other = []};

get_companion_stage(2,14,9) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 9,biography = 0,need_blessing = 1682,attr = [{1,6768},{2,135360},{3,3384},{4,3384}],other = []};

get_companion_stage(2,14,10) ->
	#base_companion_stage{companion_id = 2,stage = 14,star = 10,biography = 0,need_blessing = 1700,attr = [{1,6836},{2,136720},{3,3418},{4,3418}],other = []};

get_companion_stage(2,15,1) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 1,biography = 0,need_blessing = 1718,attr = [{1,6870},{2,137400},{3,3435},{4,3435}],other = []};

get_companion_stage(2,15,2) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 2,biography = 0,need_blessing = 1736,attr = [{1,6904},{2,138080},{3,3452},{4,3452}],other = []};

get_companion_stage(2,15,3) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 3,biography = 0,need_blessing = 1754,attr = [{1,6938},{2,138760},{3,3469},{4,3469}],other = []};

get_companion_stage(2,15,4) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 4,biography = 0,need_blessing = 1772,attr = [{1,6972},{2,139440},{3,3486},{4,3486}],other = []};

get_companion_stage(2,15,5) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 5,biography = 0,need_blessing = 1790,attr = [{1,7006},{2,140120},{3,3503},{4,3503}],other = []};

get_companion_stage(2,15,6) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 6,biography = 0,need_blessing = 1808,attr = [{1,7040},{2,140800},{3,3520},{4,3520}],other = []};

get_companion_stage(2,15,7) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 7,biography = 0,need_blessing = 1826,attr = [{1,7074},{2,141480},{3,3537},{4,3537}],other = []};

get_companion_stage(2,15,8) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 8,biography = 0,need_blessing = 1845,attr = [{1,7108},{2,142160},{3,3554},{4,3554}],other = []};

get_companion_stage(2,15,9) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 9,biography = 0,need_blessing = 1863,attr = [{1,7142},{2,142840},{3,3571},{4,3571}],other = []};

get_companion_stage(2,15,10) ->
	#base_companion_stage{companion_id = 2,stage = 15,star = 10,biography = 0,need_blessing = 1881,attr = [{1,7210},{2,144200},{3,3605},{4,3605}],other = []};

get_companion_stage(2,16,1) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 1,biography = 0,need_blessing = 1900,attr = [{1,7244},{2,144880},{3,3622},{4,3622}],other = []};

get_companion_stage(2,16,2) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 2,biography = 0,need_blessing = 1919,attr = [{1,7278},{2,145560},{3,3639},{4,3639}],other = []};

get_companion_stage(2,16,3) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 3,biography = 0,need_blessing = 1937,attr = [{1,7312},{2,146240},{3,3656},{4,3656}],other = []};

get_companion_stage(2,16,4) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 4,biography = 0,need_blessing = 1956,attr = [{1,7346},{2,146920},{3,3673},{4,3673}],other = []};

get_companion_stage(2,16,5) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 5,biography = 0,need_blessing = 1975,attr = [{1,7380},{2,147600},{3,3690},{4,3690}],other = []};

get_companion_stage(2,16,6) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 6,biography = 0,need_blessing = 1994,attr = [{1,7414},{2,148280},{3,3707},{4,3707}],other = []};

get_companion_stage(2,16,7) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 7,biography = 0,need_blessing = 2012,attr = [{1,7448},{2,148960},{3,3724},{4,3724}],other = []};

get_companion_stage(2,16,8) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 8,biography = 0,need_blessing = 2031,attr = [{1,7482},{2,149640},{3,3741},{4,3741}],other = []};

get_companion_stage(2,16,9) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 9,biography = 0,need_blessing = 2050,attr = [{1,7516},{2,150320},{3,3758},{4,3758}],other = []};

get_companion_stage(2,16,10) ->
	#base_companion_stage{companion_id = 2,stage = 16,star = 10,biography = 0,need_blessing = 2069,attr = [{1,7584},{2,151680},{3,3792},{4,3792}],other = []};

get_companion_stage(2,17,1) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 1,biography = 0,need_blessing = 2089,attr = [{1,7618},{2,152360},{3,3809},{4,3809}],other = []};

get_companion_stage(2,17,2) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 2,biography = 0,need_blessing = 2108,attr = [{1,7652},{2,153040},{3,3826},{4,3826}],other = []};

get_companion_stage(2,17,3) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 3,biography = 0,need_blessing = 2127,attr = [{1,7686},{2,153720},{3,3843},{4,3843}],other = []};

get_companion_stage(2,17,4) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 4,biography = 0,need_blessing = 2146,attr = [{1,7720},{2,154400},{3,3860},{4,3860}],other = []};

get_companion_stage(2,17,5) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 5,biography = 0,need_blessing = 2166,attr = [{1,7754},{2,155080},{3,3877},{4,3877}],other = []};

get_companion_stage(2,17,6) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 6,biography = 0,need_blessing = 2185,attr = [{1,7788},{2,155760},{3,3894},{4,3894}],other = []};

get_companion_stage(2,17,7) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 7,biography = 0,need_blessing = 2205,attr = [{1,7822},{2,156440},{3,3911},{4,3911}],other = []};

get_companion_stage(2,17,8) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 8,biography = 0,need_blessing = 2224,attr = [{1,7856},{2,157120},{3,3928},{4,3928}],other = []};

get_companion_stage(2,17,9) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 9,biography = 0,need_blessing = 2244,attr = [{1,7890},{2,157800},{3,3945},{4,3945}],other = []};

get_companion_stage(2,17,10) ->
	#base_companion_stage{companion_id = 2,stage = 17,star = 10,biography = 0,need_blessing = 2263,attr = [{1,7958},{2,159160},{3,3979},{4,3979}],other = []};

get_companion_stage(2,18,1) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 1,biography = 0,need_blessing = 2283,attr = [{1,7992},{2,159840},{3,3996},{4,3996}],other = []};

get_companion_stage(2,18,2) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 2,biography = 0,need_blessing = 2303,attr = [{1,8026},{2,160520},{3,4013},{4,4013}],other = []};

get_companion_stage(2,18,3) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 3,biography = 0,need_blessing = 2323,attr = [{1,8060},{2,161200},{3,4030},{4,4030}],other = []};

get_companion_stage(2,18,4) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 4,biography = 0,need_blessing = 2342,attr = [{1,8094},{2,161880},{3,4047},{4,4047}],other = []};

get_companion_stage(2,18,5) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 5,biography = 0,need_blessing = 2362,attr = [{1,8128},{2,162560},{3,4064},{4,4064}],other = []};

get_companion_stage(2,18,6) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 6,biography = 0,need_blessing = 2382,attr = [{1,8162},{2,163240},{3,4081},{4,4081}],other = []};

get_companion_stage(2,18,7) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 7,biography = 0,need_blessing = 2402,attr = [{1,8196},{2,163920},{3,4098},{4,4098}],other = []};

get_companion_stage(2,18,8) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 8,biography = 0,need_blessing = 2422,attr = [{1,8230},{2,164600},{3,4115},{4,4115}],other = []};

get_companion_stage(2,18,9) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 9,biography = 0,need_blessing = 2443,attr = [{1,8264},{2,165280},{3,4132},{4,4132}],other = []};

get_companion_stage(2,18,10) ->
	#base_companion_stage{companion_id = 2,stage = 18,star = 10,biography = 0,need_blessing = 2463,attr = [{1,8332},{2,166640},{3,4166},{4,4166}],other = []};

get_companion_stage(2,19,1) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 1,biography = 0,need_blessing = 2483,attr = [{1,8366},{2,167320},{3,4183},{4,4183}],other = []};

get_companion_stage(2,19,2) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 2,biography = 0,need_blessing = 2503,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(2,19,3) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 3,biography = 0,need_blessing = 2524,attr = [{1,8434},{2,168680},{3,4217},{4,4217}],other = []};

get_companion_stage(2,19,4) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 4,biography = 0,need_blessing = 2544,attr = [{1,8468},{2,169360},{3,4234},{4,4234}],other = []};

get_companion_stage(2,19,5) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 5,biography = 0,need_blessing = 2565,attr = [{1,8502},{2,170040},{3,4251},{4,4251}],other = []};

get_companion_stage(2,19,6) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 6,biography = 0,need_blessing = 2585,attr = [{1,8536},{2,170720},{3,4268},{4,4268}],other = []};

get_companion_stage(2,19,7) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 7,biography = 0,need_blessing = 2606,attr = [{1,8570},{2,171400},{3,4285},{4,4285}],other = []};

get_companion_stage(2,19,8) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 8,biography = 0,need_blessing = 2626,attr = [{1,8604},{2,172080},{3,4302},{4,4302}],other = []};

get_companion_stage(2,19,9) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 9,biography = 0,need_blessing = 2647,attr = [{1,8638},{2,172760},{3,4319},{4,4319}],other = []};

get_companion_stage(2,19,10) ->
	#base_companion_stage{companion_id = 2,stage = 19,star = 10,biography = 0,need_blessing = 2668,attr = [{1,8706},{2,174120},{3,4353},{4,4353}],other = []};

get_companion_stage(2,20,1) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 1,biography = 0,need_blessing = 2689,attr = [{1,8740},{2,174800},{3,4370},{4,4370}],other = []};

get_companion_stage(2,20,2) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 2,biography = 0,need_blessing = 2710,attr = [{1,8774},{2,175480},{3,4387},{4,4387}],other = []};

get_companion_stage(2,20,3) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 3,biography = 0,need_blessing = 2731,attr = [{1,8808},{2,176160},{3,4404},{4,4404}],other = []};

get_companion_stage(2,20,4) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 4,biography = 0,need_blessing = 2752,attr = [{1,8842},{2,176840},{3,4421},{4,4421}],other = []};

get_companion_stage(2,20,5) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 5,biography = 0,need_blessing = 2773,attr = [{1,8876},{2,177520},{3,4438},{4,4438}],other = []};

get_companion_stage(2,20,6) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 6,biography = 0,need_blessing = 2794,attr = [{1,8910},{2,178200},{3,4455},{4,4455}],other = []};

get_companion_stage(2,20,7) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 7,biography = 0,need_blessing = 2815,attr = [{1,8944},{2,178880},{3,4472},{4,4472}],other = []};

get_companion_stage(2,20,8) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 8,biography = 0,need_blessing = 2836,attr = [{1,8978},{2,179560},{3,4489},{4,4489}],other = []};

get_companion_stage(2,20,9) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 9,biography = 0,need_blessing = 2857,attr = [{1,9012},{2,180240},{3,4506},{4,4506}],other = []};

get_companion_stage(2,20,10) ->
	#base_companion_stage{companion_id = 2,stage = 20,star = 10,biography = 0,need_blessing = 2878,attr = [{1,9080},{2,181600},{3,4540},{4,4540}],other = []};

get_companion_stage(2,21,1) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 1,biography = 0,need_blessing = 2900,attr = [{1,9114},{2,182280},{3,4557},{4,4557}],other = []};

get_companion_stage(2,21,2) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 2,biography = 0,need_blessing = 2921,attr = [{1,9148},{2,182960},{3,4574},{4,4574}],other = []};

get_companion_stage(2,21,3) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 3,biography = 0,need_blessing = 2943,attr = [{1,9182},{2,183640},{3,4591},{4,4591}],other = []};

get_companion_stage(2,21,4) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 4,biography = 0,need_blessing = 2964,attr = [{1,9216},{2,184320},{3,4608},{4,4608}],other = []};

get_companion_stage(2,21,5) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 5,biography = 0,need_blessing = 2986,attr = [{1,9250},{2,185000},{3,4625},{4,4625}],other = []};

get_companion_stage(2,21,6) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 6,biography = 0,need_blessing = 3007,attr = [{1,9284},{2,185680},{3,4642},{4,4642}],other = []};

get_companion_stage(2,21,7) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 7,biography = 0,need_blessing = 3029,attr = [{1,9318},{2,186360},{3,4659},{4,4659}],other = []};

get_companion_stage(2,21,8) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 8,biography = 0,need_blessing = 3051,attr = [{1,9352},{2,187040},{3,4676},{4,4676}],other = []};

get_companion_stage(2,21,9) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 9,biography = 0,need_blessing = 3072,attr = [{1,9386},{2,187720},{3,4693},{4,4693}],other = []};

get_companion_stage(2,21,10) ->
	#base_companion_stage{companion_id = 2,stage = 21,star = 10,biography = 0,need_blessing = 3094,attr = [{1,9454},{2,189080},{3,4727},{4,4727}],other = []};

get_companion_stage(2,22,1) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 1,biography = 0,need_blessing = 3116,attr = [{1,9488},{2,189760},{3,4744},{4,4744}],other = []};

get_companion_stage(2,22,2) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 2,biography = 0,need_blessing = 3138,attr = [{1,9522},{2,190440},{3,4761},{4,4761}],other = []};

get_companion_stage(2,22,3) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 3,biography = 0,need_blessing = 3160,attr = [{1,9556},{2,191120},{3,4778},{4,4778}],other = []};

get_companion_stage(2,22,4) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 4,biography = 0,need_blessing = 3182,attr = [{1,9590},{2,191800},{3,4795},{4,4795}],other = []};

get_companion_stage(2,22,5) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 5,biography = 0,need_blessing = 3204,attr = [{1,9624},{2,192480},{3,4812},{4,4812}],other = []};

get_companion_stage(2,22,6) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 6,biography = 0,need_blessing = 3226,attr = [{1,9658},{2,193160},{3,4829},{4,4829}],other = []};

get_companion_stage(2,22,7) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 7,biography = 0,need_blessing = 3248,attr = [{1,9692},{2,193840},{3,4846},{4,4846}],other = []};

get_companion_stage(2,22,8) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 8,biography = 0,need_blessing = 3271,attr = [{1,9726},{2,194520},{3,4863},{4,4863}],other = []};

get_companion_stage(2,22,9) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 9,biography = 0,need_blessing = 3293,attr = [{1,9760},{2,195200},{3,4880},{4,4880}],other = []};

get_companion_stage(2,22,10) ->
	#base_companion_stage{companion_id = 2,stage = 22,star = 10,biography = 0,need_blessing = 3315,attr = [{1,9828},{2,196560},{3,4914},{4,4914}],other = []};

get_companion_stage(2,23,1) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 1,biography = 0,need_blessing = 3338,attr = [{1,9862},{2,197240},{3,4931},{4,4931}],other = []};

get_companion_stage(2,23,2) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 2,biography = 0,need_blessing = 3360,attr = [{1,9896},{2,197920},{3,4948},{4,4948}],other = []};

get_companion_stage(2,23,3) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 3,biography = 0,need_blessing = 3383,attr = [{1,9930},{2,198600},{3,4965},{4,4965}],other = []};

get_companion_stage(2,23,4) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 4,biography = 0,need_blessing = 3405,attr = [{1,9964},{2,199280},{3,4982},{4,4982}],other = []};

get_companion_stage(2,23,5) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 5,biography = 0,need_blessing = 3428,attr = [{1,9998},{2,199960},{3,4999},{4,4999}],other = []};

get_companion_stage(2,23,6) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 6,biography = 0,need_blessing = 3450,attr = [{1,10032},{2,200640},{3,5016},{4,5016}],other = []};

get_companion_stage(2,23,7) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 7,biography = 0,need_blessing = 3473,attr = [{1,10066},{2,201320},{3,5033},{4,5033}],other = []};

get_companion_stage(2,23,8) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 8,biography = 0,need_blessing = 3496,attr = [{1,10100},{2,202000},{3,5050},{4,5050}],other = []};

get_companion_stage(2,23,9) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 9,biography = 0,need_blessing = 3518,attr = [{1,10134},{2,202680},{3,5067},{4,5067}],other = []};

get_companion_stage(2,23,10) ->
	#base_companion_stage{companion_id = 2,stage = 23,star = 10,biography = 0,need_blessing = 3541,attr = [{1,10202},{2,204040},{3,5101},{4,5101}],other = []};

get_companion_stage(2,24,1) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 1,biography = 0,need_blessing = 3564,attr = [{1,10236},{2,204720},{3,5118},{4,5118}],other = []};

get_companion_stage(2,24,2) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 2,biography = 0,need_blessing = 3587,attr = [{1,10270},{2,205400},{3,5135},{4,5135}],other = []};

get_companion_stage(2,24,3) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 3,biography = 0,need_blessing = 3610,attr = [{1,10304},{2,206080},{3,5152},{4,5152}],other = []};

get_companion_stage(2,24,4) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 4,biography = 0,need_blessing = 3633,attr = [{1,10338},{2,206760},{3,5169},{4,5169}],other = []};

get_companion_stage(2,24,5) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 5,biography = 0,need_blessing = 3656,attr = [{1,10372},{2,207440},{3,5186},{4,5186}],other = []};

get_companion_stage(2,24,6) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 6,biography = 0,need_blessing = 3679,attr = [{1,10406},{2,208120},{3,5203},{4,5203}],other = []};

get_companion_stage(2,24,7) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 7,biography = 0,need_blessing = 3702,attr = [{1,10440},{2,208800},{3,5220},{4,5220}],other = []};

get_companion_stage(2,24,8) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 8,biography = 0,need_blessing = 3726,attr = [{1,10474},{2,209480},{3,5237},{4,5237}],other = []};

get_companion_stage(2,24,9) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 9,biography = 0,need_blessing = 3749,attr = [{1,10508},{2,210160},{3,5254},{4,5254}],other = []};

get_companion_stage(2,24,10) ->
	#base_companion_stage{companion_id = 2,stage = 24,star = 10,biography = 0,need_blessing = 3772,attr = [{1,10576},{2,211520},{3,5288},{4,5288}],other = []};

get_companion_stage(2,25,1) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 1,biography = 0,need_blessing = 3795,attr = [{1,10610},{2,212200},{3,5305},{4,5305}],other = []};

get_companion_stage(2,25,2) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 2,biography = 0,need_blessing = 3819,attr = [{1,10644},{2,212880},{3,5322},{4,5322}],other = []};

get_companion_stage(2,25,3) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 3,biography = 0,need_blessing = 3842,attr = [{1,10678},{2,213560},{3,5339},{4,5339}],other = []};

get_companion_stage(2,25,4) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 4,biography = 0,need_blessing = 3866,attr = [{1,10712},{2,214240},{3,5356},{4,5356}],other = []};

get_companion_stage(2,25,5) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 5,biography = 0,need_blessing = 3889,attr = [{1,10746},{2,214920},{3,5373},{4,5373}],other = []};

get_companion_stage(2,25,6) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 6,biography = 0,need_blessing = 3913,attr = [{1,10780},{2,215600},{3,5390},{4,5390}],other = []};

get_companion_stage(2,25,7) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 7,biography = 0,need_blessing = 3937,attr = [{1,10814},{2,216280},{3,5407},{4,5407}],other = []};

get_companion_stage(2,25,8) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 8,biography = 0,need_blessing = 3960,attr = [{1,10848},{2,216960},{3,5424},{4,5424}],other = []};

get_companion_stage(2,25,9) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 9,biography = 0,need_blessing = 3984,attr = [{1,10882},{2,217640},{3,5441},{4,5441}],other = []};

get_companion_stage(2,25,10) ->
	#base_companion_stage{companion_id = 2,stage = 25,star = 10,biography = 0,need_blessing = 4008,attr = [{1,10950},{2,219000},{3,5475},{4,5475}],other = []};

get_companion_stage(2,26,1) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 1,biography = 0,need_blessing = 4032,attr = [{1,10984},{2,219680},{3,5492},{4,5492}],other = []};

get_companion_stage(2,26,2) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 2,biography = 0,need_blessing = 4056,attr = [{1,11018},{2,220360},{3,5509},{4,5509}],other = []};

get_companion_stage(2,26,3) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 3,biography = 0,need_blessing = 4080,attr = [{1,11052},{2,221040},{3,5526},{4,5526}],other = []};

get_companion_stage(2,26,4) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 4,biography = 0,need_blessing = 4104,attr = [{1,11086},{2,221720},{3,5543},{4,5543}],other = []};

get_companion_stage(2,26,5) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 5,biography = 0,need_blessing = 4128,attr = [{1,11120},{2,222400},{3,5560},{4,5560}],other = []};

get_companion_stage(2,26,6) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 6,biography = 0,need_blessing = 4152,attr = [{1,11154},{2,223080},{3,5577},{4,5577}],other = []};

get_companion_stage(2,26,7) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 7,biography = 0,need_blessing = 4176,attr = [{1,11188},{2,223760},{3,5594},{4,5594}],other = []};

get_companion_stage(2,26,8) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 8,biography = 0,need_blessing = 4200,attr = [{1,11222},{2,224440},{3,5611},{4,5611}],other = []};

get_companion_stage(2,26,9) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 9,biography = 0,need_blessing = 4224,attr = [{1,11256},{2,225120},{3,5628},{4,5628}],other = []};

get_companion_stage(2,26,10) ->
	#base_companion_stage{companion_id = 2,stage = 26,star = 10,biography = 0,need_blessing = 4248,attr = [{1,11324},{2,226480},{3,5662},{4,5662}],other = []};

get_companion_stage(2,27,1) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 1,biography = 0,need_blessing = 4273,attr = [{1,11358},{2,227160},{3,5679},{4,5679}],other = []};

get_companion_stage(2,27,2) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 2,biography = 0,need_blessing = 4297,attr = [{1,11392},{2,227840},{3,5696},{4,5696}],other = []};

get_companion_stage(2,27,3) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 3,biography = 0,need_blessing = 4321,attr = [{1,11426},{2,228520},{3,5713},{4,5713}],other = []};

get_companion_stage(2,27,4) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 4,biography = 0,need_blessing = 4346,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(2,27,5) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 5,biography = 0,need_blessing = 4370,attr = [{1,11494},{2,229880},{3,5747},{4,5747}],other = []};

get_companion_stage(2,27,6) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 6,biography = 0,need_blessing = 4395,attr = [{1,11528},{2,230560},{3,5764},{4,5764}],other = []};

get_companion_stage(2,27,7) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 7,biography = 0,need_blessing = 4419,attr = [{1,11562},{2,231240},{3,5781},{4,5781}],other = []};

get_companion_stage(2,27,8) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 8,biography = 0,need_blessing = 4444,attr = [{1,11596},{2,231920},{3,5798},{4,5798}],other = []};

get_companion_stage(2,27,9) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 9,biography = 0,need_blessing = 4469,attr = [{1,11630},{2,232600},{3,5815},{4,5815}],other = []};

get_companion_stage(2,27,10) ->
	#base_companion_stage{companion_id = 2,stage = 27,star = 10,biography = 0,need_blessing = 4493,attr = [{1,11698},{2,233960},{3,5849},{4,5849}],other = []};

get_companion_stage(2,28,1) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 1,biography = 0,need_blessing = 4518,attr = [{1,11732},{2,234640},{3,5866},{4,5866}],other = []};

get_companion_stage(2,28,2) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 2,biography = 0,need_blessing = 4543,attr = [{1,11766},{2,235320},{3,5883},{4,5883}],other = []};

get_companion_stage(2,28,3) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 3,biography = 0,need_blessing = 4568,attr = [{1,11800},{2,236000},{3,5900},{4,5900}],other = []};

get_companion_stage(2,28,4) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 4,biography = 0,need_blessing = 4593,attr = [{1,11834},{2,236680},{3,5917},{4,5917}],other = []};

get_companion_stage(2,28,5) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 5,biography = 0,need_blessing = 4618,attr = [{1,11868},{2,237360},{3,5934},{4,5934}],other = []};

get_companion_stage(2,28,6) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 6,biography = 0,need_blessing = 4643,attr = [{1,11902},{2,238040},{3,5951},{4,5951}],other = []};

get_companion_stage(2,28,7) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 7,biography = 0,need_blessing = 4668,attr = [{1,11936},{2,238720},{3,5968},{4,5968}],other = []};

get_companion_stage(2,28,8) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 8,biography = 0,need_blessing = 4693,attr = [{1,11970},{2,239400},{3,5985},{4,5985}],other = []};

get_companion_stage(2,28,9) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 9,biography = 0,need_blessing = 4718,attr = [{1,12004},{2,240080},{3,6002},{4,6002}],other = []};

get_companion_stage(2,28,10) ->
	#base_companion_stage{companion_id = 2,stage = 28,star = 10,biography = 0,need_blessing = 4743,attr = [{1,12072},{2,241440},{3,6036},{4,6036}],other = []};

get_companion_stage(2,29,1) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 1,biography = 0,need_blessing = 4768,attr = [{1,12106},{2,242120},{3,6053},{4,6053}],other = []};

get_companion_stage(2,29,2) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 2,biography = 0,need_blessing = 4794,attr = [{1,12140},{2,242800},{3,6070},{4,6070}],other = []};

get_companion_stage(2,29,3) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 3,biography = 0,need_blessing = 4819,attr = [{1,12174},{2,243480},{3,6087},{4,6087}],other = []};

get_companion_stage(2,29,4) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 4,biography = 0,need_blessing = 4844,attr = [{1,12208},{2,244160},{3,6104},{4,6104}],other = []};

get_companion_stage(2,29,5) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 5,biography = 0,need_blessing = 4870,attr = [{1,12242},{2,244840},{3,6121},{4,6121}],other = []};

get_companion_stage(2,29,6) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 6,biography = 0,need_blessing = 4895,attr = [{1,12276},{2,245520},{3,6138},{4,6138}],other = []};

get_companion_stage(2,29,7) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 7,biography = 0,need_blessing = 4921,attr = [{1,12310},{2,246200},{3,6155},{4,6155}],other = []};

get_companion_stage(2,29,8) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 8,biography = 0,need_blessing = 4946,attr = [{1,12344},{2,246880},{3,6172},{4,6172}],other = []};

get_companion_stage(2,29,9) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 9,biography = 0,need_blessing = 4972,attr = [{1,12378},{2,247560},{3,6189},{4,6189}],other = []};

get_companion_stage(2,29,10) ->
	#base_companion_stage{companion_id = 2,stage = 29,star = 10,biography = 0,need_blessing = 4997,attr = [{1,12446},{2,248920},{3,6223},{4,6223}],other = []};

get_companion_stage(2,30,1) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 1,biography = 0,need_blessing = 5023,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(2,30,2) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 2,biography = 0,need_blessing = 5049,attr = [{1,12514},{2,250280},{3,6257},{4,6257}],other = []};

get_companion_stage(2,30,3) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 3,biography = 0,need_blessing = 5074,attr = [{1,12548},{2,250960},{3,6274},{4,6274}],other = []};

get_companion_stage(2,30,4) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 4,biography = 0,need_blessing = 5100,attr = [{1,12582},{2,251640},{3,6291},{4,6291}],other = []};

get_companion_stage(2,30,5) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 5,biography = 0,need_blessing = 5126,attr = [{1,12616},{2,252320},{3,6308},{4,6308}],other = []};

get_companion_stage(2,30,6) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 6,biography = 0,need_blessing = 5152,attr = [{1,12650},{2,253000},{3,6325},{4,6325}],other = []};

get_companion_stage(2,30,7) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 7,biography = 0,need_blessing = 5178,attr = [{1,12684},{2,253680},{3,6342},{4,6342}],other = []};

get_companion_stage(2,30,8) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 8,biography = 0,need_blessing = 5204,attr = [{1,12718},{2,254360},{3,6359},{4,6359}],other = []};

get_companion_stage(2,30,9) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 9,biography = 0,need_blessing = 5230,attr = [{1,12752},{2,255040},{3,6376},{4,6376}],other = []};

get_companion_stage(2,30,10) ->
	#base_companion_stage{companion_id = 2,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,12820},{2,256400},{3,6410},{4,6410}],other = []};

get_companion_stage(3,1,0) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],other = []};

get_companion_stage(3,1,1) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 1,biography = 0,need_blessing = 13,attr = [{1,2436},{2,48720},{3,1218},{4,1218}],other = []};

get_companion_stage(3,1,2) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 2,biography = 0,need_blessing = 16,attr = [{1,2472},{2,49440},{3,1236},{4,1236}],other = []};

get_companion_stage(3,1,3) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 3,biography = 0,need_blessing = 19,attr = [{1,2508},{2,50160},{3,1254},{4,1254}],other = []};

get_companion_stage(3,1,4) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 4,biography = 0,need_blessing = 22,attr = [{1,2544},{2,50880},{3,1272},{4,1272}],other = []};

get_companion_stage(3,1,5) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 5,biography = 0,need_blessing = 26,attr = [{1,2580},{2,51600},{3,1290},{4,1290}],other = []};

get_companion_stage(3,1,6) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 6,biography = 0,need_blessing = 30,attr = [{1,2616},{2,52320},{3,1308},{4,1308}],other = []};

get_companion_stage(3,1,7) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 7,biography = 0,need_blessing = 35,attr = [{1,2652},{2,53040},{3,1326},{4,1326}],other = []};

get_companion_stage(3,1,8) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 8,biography = 0,need_blessing = 39,attr = [{1,2688},{2,53760},{3,1344},{4,1344}],other = []};

get_companion_stage(3,1,9) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 9,biography = 0,need_blessing = 44,attr = [{1,2724},{2,54480},{3,1362},{4,1362}],other = []};

get_companion_stage(3,1,10) ->
	#base_companion_stage{companion_id = 3,stage = 1,star = 10,biography = 1,need_blessing = 49,attr = [{1,2796},{2,55920},{3,1398},{4,1398}],other = [{biog_reward, [{2,0,100},{0, 22030003, 3},{0, 22030103, 1}]}]};

get_companion_stage(3,2,1) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 1,biography = 0,need_blessing = 54,attr = [{1,2832},{2,56640},{3,1416},{4,1416}],other = []};

get_companion_stage(3,2,2) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 2,biography = 0,need_blessing = 60,attr = [{1,2868},{2,57360},{3,1434},{4,1434}],other = []};

get_companion_stage(3,2,3) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 3,biography = 0,need_blessing = 66,attr = [{1,2904},{2,58080},{3,1452},{4,1452}],other = []};

get_companion_stage(3,2,4) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 4,biography = 0,need_blessing = 72,attr = [{1,2940},{2,58800},{3,1470},{4,1470}],other = []};

get_companion_stage(3,2,5) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 5,biography = 0,need_blessing = 78,attr = [{1,2976},{2,59520},{3,1488},{4,1488}],other = []};

get_companion_stage(3,2,6) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 6,biography = 0,need_blessing = 84,attr = [{1,3012},{2,60240},{3,1506},{4,1506}],other = []};

get_companion_stage(3,2,7) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 7,biography = 0,need_blessing = 90,attr = [{1,3048},{2,60960},{3,1524},{4,1524}],other = []};

get_companion_stage(3,2,8) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 8,biography = 0,need_blessing = 97,attr = [{1,3084},{2,61680},{3,1542},{4,1542}],other = []};

get_companion_stage(3,2,9) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 9,biography = 0,need_blessing = 104,attr = [{1,3120},{2,62400},{3,1560},{4,1560}],other = []};

get_companion_stage(3,2,10) ->
	#base_companion_stage{companion_id = 3,stage = 2,star = 10,biography = 0,need_blessing = 111,attr = [{1,3192},{2,63840},{3,1596},{4,1596}],other = []};

get_companion_stage(3,3,1) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 1,biography = 0,need_blessing = 118,attr = [{1,3228},{2,64560},{3,1614},{4,1614}],other = []};

get_companion_stage(3,3,2) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 2,biography = 0,need_blessing = 125,attr = [{1,3264},{2,65280},{3,1632},{4,1632}],other = []};

get_companion_stage(3,3,3) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 3,biography = 0,need_blessing = 133,attr = [{1,3300},{2,66000},{3,1650},{4,1650}],other = []};

get_companion_stage(3,3,4) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 4,biography = 0,need_blessing = 140,attr = [{1,3336},{2,66720},{3,1668},{4,1668}],other = []};

get_companion_stage(3,3,5) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 5,biography = 0,need_blessing = 148,attr = [{1,3372},{2,67440},{3,1686},{4,1686}],other = []};

get_companion_stage(3,3,6) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 6,biography = 0,need_blessing = 156,attr = [{1,3408},{2,68160},{3,1704},{4,1704}],other = []};

get_companion_stage(3,3,7) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 7,biography = 0,need_blessing = 164,attr = [{1,3444},{2,68880},{3,1722},{4,1722}],other = []};

get_companion_stage(3,3,8) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 8,biography = 0,need_blessing = 172,attr = [{1,3480},{2,69600},{3,1740},{4,1740}],other = []};

get_companion_stage(3,3,9) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 9,biography = 0,need_blessing = 180,attr = [{1,3516},{2,70320},{3,1758},{4,1758}],other = []};

get_companion_stage(3,3,10) ->
	#base_companion_stage{companion_id = 3,stage = 3,star = 10,biography = 2,need_blessing = 189,attr = [{1,3588},{2,71760},{3,1794},{4,1794}],other = [{biog_reward, [{2,0,200},{0, 22030003, 5},{0, 22030103, 3}]}]};

get_companion_stage(3,4,1) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 1,biography = 0,need_blessing = 197,attr = [{1,3624},{2,72480},{3,1812},{4,1812}],other = []};

get_companion_stage(3,4,2) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 2,biography = 0,need_blessing = 206,attr = [{1,3660},{2,73200},{3,1830},{4,1830}],other = []};

get_companion_stage(3,4,3) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 3,biography = 0,need_blessing = 215,attr = [{1,3696},{2,73920},{3,1848},{4,1848}],other = []};

get_companion_stage(3,4,4) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 4,biography = 0,need_blessing = 224,attr = [{1,3732},{2,74640},{3,1866},{4,1866}],other = []};

get_companion_stage(3,4,5) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 5,biography = 0,need_blessing = 233,attr = [{1,3768},{2,75360},{3,1884},{4,1884}],other = []};

get_companion_stage(3,4,6) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 6,biography = 0,need_blessing = 242,attr = [{1,3804},{2,76080},{3,1902},{4,1902}],other = []};

get_companion_stage(3,4,7) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 7,biography = 0,need_blessing = 251,attr = [{1,3840},{2,76800},{3,1920},{4,1920}],other = []};

get_companion_stage(3,4,8) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 8,biography = 0,need_blessing = 260,attr = [{1,3876},{2,77520},{3,1938},{4,1938}],other = []};

get_companion_stage(3,4,9) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 9,biography = 0,need_blessing = 270,attr = [{1,3912},{2,78240},{3,1956},{4,1956}],other = []};

get_companion_stage(3,4,10) ->
	#base_companion_stage{companion_id = 3,stage = 4,star = 10,biography = 0,need_blessing = 280,attr = [{1,3984},{2,79680},{3,1992},{4,1992}],other = []};

get_companion_stage(3,5,1) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 1,biography = 0,need_blessing = 289,attr = [{1,4020},{2,80400},{3,2010},{4,2010}],other = []};

get_companion_stage(3,5,2) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 2,biography = 0,need_blessing = 299,attr = [{1,4056},{2,81120},{3,2028},{4,2028}],other = []};

get_companion_stage(3,5,3) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 3,biography = 0,need_blessing = 309,attr = [{1,4092},{2,81840},{3,2046},{4,2046}],other = []};

get_companion_stage(3,5,4) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 4,biography = 0,need_blessing = 319,attr = [{1,4128},{2,82560},{3,2064},{4,2064}],other = []};

get_companion_stage(3,5,5) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 5,biography = 0,need_blessing = 330,attr = [{1,4164},{2,83280},{3,2082},{4,2082}],other = []};

get_companion_stage(3,5,6) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 6,biography = 0,need_blessing = 340,attr = [{1,4200},{2,84000},{3,2100},{4,2100}],other = []};

get_companion_stage(3,5,7) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 7,biography = 0,need_blessing = 351,attr = [{1,4236},{2,84720},{3,2118},{4,2118}],other = []};

get_companion_stage(3,5,8) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 8,biography = 0,need_blessing = 361,attr = [{1,4272},{2,85440},{3,2136},{4,2136}],other = []};

get_companion_stage(3,5,9) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 9,biography = 0,need_blessing = 372,attr = [{1,4308},{2,86160},{3,2154},{4,2154}],other = []};

get_companion_stage(3,5,10) ->
	#base_companion_stage{companion_id = 3,stage = 5,star = 10,biography = 3,need_blessing = 382,attr = [{1,4380},{2,87600},{3,2190},{4,2190}],other = [{biog_reward, [{2,0,250},{0, 22030003, 10},{0, 22030103, 5}]}]};

get_companion_stage(3,6,1) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 1,biography = 0,need_blessing = 393,attr = [{1,4416},{2,88320},{3,2208},{4,2208}],other = []};

get_companion_stage(3,6,2) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 2,biography = 0,need_blessing = 404,attr = [{1,4452},{2,89040},{3,2226},{4,2226}],other = []};

get_companion_stage(3,6,3) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 3,biography = 0,need_blessing = 415,attr = [{1,4488},{2,89760},{3,2244},{4,2244}],other = []};

get_companion_stage(3,6,4) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 4,biography = 0,need_blessing = 427,attr = [{1,4524},{2,90480},{3,2262},{4,2262}],other = []};

get_companion_stage(3,6,5) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 5,biography = 0,need_blessing = 438,attr = [{1,4560},{2,91200},{3,2280},{4,2280}],other = []};

get_companion_stage(3,6,6) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 6,biography = 0,need_blessing = 449,attr = [{1,4596},{2,91920},{3,2298},{4,2298}],other = []};

get_companion_stage(3,6,7) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 7,biography = 0,need_blessing = 461,attr = [{1,4632},{2,92640},{3,2316},{4,2316}],other = []};

get_companion_stage(3,6,8) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 8,biography = 0,need_blessing = 472,attr = [{1,4668},{2,93360},{3,2334},{4,2334}],other = []};

get_companion_stage(3,6,9) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 9,biography = 0,need_blessing = 484,attr = [{1,4704},{2,94080},{3,2352},{4,2352}],other = []};

get_companion_stage(3,6,10) ->
	#base_companion_stage{companion_id = 3,stage = 6,star = 10,biography = 0,need_blessing = 496,attr = [{1,4776},{2,95520},{3,2388},{4,2388}],other = []};

get_companion_stage(3,7,1) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 1,biography = 0,need_blessing = 508,attr = [{1,4812},{2,96240},{3,2406},{4,2406}],other = []};

get_companion_stage(3,7,2) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 2,biography = 0,need_blessing = 520,attr = [{1,4848},{2,96960},{3,2424},{4,2424}],other = []};

get_companion_stage(3,7,3) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 3,biography = 0,need_blessing = 532,attr = [{1,4884},{2,97680},{3,2442},{4,2442}],other = []};

get_companion_stage(3,7,4) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 4,biography = 0,need_blessing = 544,attr = [{1,4920},{2,98400},{3,2460},{4,2460}],other = []};

get_companion_stage(3,7,5) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 5,biography = 0,need_blessing = 556,attr = [{1,4956},{2,99120},{3,2478},{4,2478}],other = []};

get_companion_stage(3,7,6) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 6,biography = 0,need_blessing = 568,attr = [{1,4992},{2,99840},{3,2496},{4,2496}],other = []};

get_companion_stage(3,7,7) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 7,biography = 0,need_blessing = 581,attr = [{1,5028},{2,100560},{3,2514},{4,2514}],other = []};

get_companion_stage(3,7,8) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 8,biography = 0,need_blessing = 593,attr = [{1,5064},{2,101280},{3,2532},{4,2532}],other = []};

get_companion_stage(3,7,9) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 9,biography = 0,need_blessing = 606,attr = [{1,5100},{2,102000},{3,2550},{4,2550}],other = []};

get_companion_stage(3,7,10) ->
	#base_companion_stage{companion_id = 3,stage = 7,star = 10,biography = 0,need_blessing = 618,attr = [{1,5172},{2,103440},{3,2586},{4,2586}],other = []};

get_companion_stage(3,8,1) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 1,biography = 0,need_blessing = 631,attr = [{1,5208},{2,104160},{3,2604},{4,2604}],other = []};

get_companion_stage(3,8,2) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 2,biography = 0,need_blessing = 644,attr = [{1,5244},{2,104880},{3,2622},{4,2622}],other = []};

get_companion_stage(3,8,3) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 3,biography = 0,need_blessing = 657,attr = [{1,5280},{2,105600},{3,2640},{4,2640}],other = []};

get_companion_stage(3,8,4) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 4,biography = 0,need_blessing = 670,attr = [{1,5316},{2,106320},{3,2658},{4,2658}],other = []};

get_companion_stage(3,8,5) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 5,biography = 0,need_blessing = 683,attr = [{1,5352},{2,107040},{3,2676},{4,2676}],other = []};

get_companion_stage(3,8,6) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 6,biography = 0,need_blessing = 696,attr = [{1,5388},{2,107760},{3,2694},{4,2694}],other = []};

get_companion_stage(3,8,7) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 7,biography = 0,need_blessing = 710,attr = [{1,5424},{2,108480},{3,2712},{4,2712}],other = []};

get_companion_stage(3,8,8) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 8,biography = 0,need_blessing = 723,attr = [{1,5460},{2,109200},{3,2730},{4,2730}],other = []};

get_companion_stage(3,8,9) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 9,biography = 0,need_blessing = 737,attr = [{1,5496},{2,109920},{3,2748},{4,2748}],other = []};

get_companion_stage(3,8,10) ->
	#base_companion_stage{companion_id = 3,stage = 8,star = 10,biography = 0,need_blessing = 750,attr = [{1,5568},{2,111360},{3,2784},{4,2784}],other = []};

get_companion_stage(3,9,1) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 1,biography = 0,need_blessing = 764,attr = [{1,5604},{2,112080},{3,2802},{4,2802}],other = []};

get_companion_stage(3,9,2) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 2,biography = 0,need_blessing = 777,attr = [{1,5640},{2,112800},{3,2820},{4,2820}],other = []};

get_companion_stage(3,9,3) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 3,biography = 0,need_blessing = 791,attr = [{1,5676},{2,113520},{3,2838},{4,2838}],other = []};

get_companion_stage(3,9,4) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 4,biography = 0,need_blessing = 805,attr = [{1,5712},{2,114240},{3,2856},{4,2856}],other = []};

get_companion_stage(3,9,5) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 5,biography = 0,need_blessing = 819,attr = [{1,5748},{2,114960},{3,2874},{4,2874}],other = []};

get_companion_stage(3,9,6) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 6,biography = 0,need_blessing = 833,attr = [{1,5784},{2,115680},{3,2892},{4,2892}],other = []};

get_companion_stage(3,9,7) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 7,biography = 0,need_blessing = 847,attr = [{1,5820},{2,116400},{3,2910},{4,2910}],other = []};

get_companion_stage(3,9,8) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 8,biography = 0,need_blessing = 861,attr = [{1,5856},{2,117120},{3,2928},{4,2928}],other = []};

get_companion_stage(3,9,9) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 9,biography = 0,need_blessing = 876,attr = [{1,5892},{2,117840},{3,2946},{4,2946}],other = []};

get_companion_stage(3,9,10) ->
	#base_companion_stage{companion_id = 3,stage = 9,star = 10,biography = 0,need_blessing = 890,attr = [{1,5964},{2,119280},{3,2982},{4,2982}],other = []};

get_companion_stage(3,10,1) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 1,biography = 0,need_blessing = 904,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],other = []};

get_companion_stage(3,10,2) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 2,biography = 0,need_blessing = 919,attr = [{1,6036},{2,120720},{3,3018},{4,3018}],other = []};

get_companion_stage(3,10,3) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 3,biography = 0,need_blessing = 933,attr = [{1,6072},{2,121440},{3,3036},{4,3036}],other = []};

get_companion_stage(3,10,4) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 4,biography = 0,need_blessing = 948,attr = [{1,6108},{2,122160},{3,3054},{4,3054}],other = []};

get_companion_stage(3,10,5) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 5,biography = 0,need_blessing = 963,attr = [{1,6144},{2,122880},{3,3072},{4,3072}],other = []};

get_companion_stage(3,10,6) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 6,biography = 0,need_blessing = 978,attr = [{1,6180},{2,123600},{3,3090},{4,3090}],other = []};

get_companion_stage(3,10,7) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 7,biography = 0,need_blessing = 993,attr = [{1,6216},{2,124320},{3,3108},{4,3108}],other = []};

get_companion_stage(3,10,8) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 8,biography = 0,need_blessing = 1008,attr = [{1,6252},{2,125040},{3,3126},{4,3126}],other = []};

get_companion_stage(3,10,9) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 9,biography = 0,need_blessing = 1023,attr = [{1,6288},{2,125760},{3,3144},{4,3144}],other = []};

get_companion_stage(3,10,10) ->
	#base_companion_stage{companion_id = 3,stage = 10,star = 10,biography = 0,need_blessing = 1038,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],other = []};

get_companion_stage(3,11,1) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 1,biography = 0,need_blessing = 1053,attr = [{1,6396},{2,127920},{3,3198},{4,3198}],other = []};

get_companion_stage(3,11,2) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 2,biography = 0,need_blessing = 1068,attr = [{1,6432},{2,128640},{3,3216},{4,3216}],other = []};

get_companion_stage(3,11,3) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 3,biography = 0,need_blessing = 1083,attr = [{1,6468},{2,129360},{3,3234},{4,3234}],other = []};

get_companion_stage(3,11,4) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 4,biography = 0,need_blessing = 1099,attr = [{1,6504},{2,130080},{3,3252},{4,3252}],other = []};

get_companion_stage(3,11,5) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 5,biography = 0,need_blessing = 1114,attr = [{1,6540},{2,130800},{3,3270},{4,3270}],other = []};

get_companion_stage(3,11,6) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 6,biography = 0,need_blessing = 1130,attr = [{1,6576},{2,131520},{3,3288},{4,3288}],other = []};

get_companion_stage(3,11,7) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 7,biography = 0,need_blessing = 1145,attr = [{1,6612},{2,132240},{3,3306},{4,3306}],other = []};

get_companion_stage(3,11,8) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 8,biography = 0,need_blessing = 1161,attr = [{1,6648},{2,132960},{3,3324},{4,3324}],other = []};

get_companion_stage(3,11,9) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 9,biography = 0,need_blessing = 1177,attr = [{1,6684},{2,133680},{3,3342},{4,3342}],other = []};

get_companion_stage(3,11,10) ->
	#base_companion_stage{companion_id = 3,stage = 11,star = 10,biography = 0,need_blessing = 1193,attr = [{1,6756},{2,135120},{3,3378},{4,3378}],other = []};

get_companion_stage(3,12,1) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 1,biography = 0,need_blessing = 1209,attr = [{1,6792},{2,135840},{3,3396},{4,3396}],other = []};

get_companion_stage(3,12,2) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 2,biography = 0,need_blessing = 1225,attr = [{1,6828},{2,136560},{3,3414},{4,3414}],other = []};

get_companion_stage(3,12,3) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 3,biography = 0,need_blessing = 1241,attr = [{1,6864},{2,137280},{3,3432},{4,3432}],other = []};

get_companion_stage(3,12,4) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 4,biography = 0,need_blessing = 1257,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],other = []};

get_companion_stage(3,12,5) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 5,biography = 0,need_blessing = 1273,attr = [{1,6936},{2,138720},{3,3468},{4,3468}],other = []};

get_companion_stage(3,12,6) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 6,biography = 0,need_blessing = 1289,attr = [{1,6972},{2,139440},{3,3486},{4,3486}],other = []};

get_companion_stage(3,12,7) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 7,biography = 0,need_blessing = 1306,attr = [{1,7008},{2,140160},{3,3504},{4,3504}],other = []};

get_companion_stage(3,12,8) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 8,biography = 0,need_blessing = 1322,attr = [{1,7044},{2,140880},{3,3522},{4,3522}],other = []};

get_companion_stage(3,12,9) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 9,biography = 0,need_blessing = 1339,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],other = []};

get_companion_stage(3,12,10) ->
	#base_companion_stage{companion_id = 3,stage = 12,star = 10,biography = 0,need_blessing = 1355,attr = [{1,7152},{2,143040},{3,3576},{4,3576}],other = []};

get_companion_stage(3,13,1) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 1,biography = 0,need_blessing = 1372,attr = [{1,7188},{2,143760},{3,3594},{4,3594}],other = []};

get_companion_stage(3,13,2) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 2,biography = 0,need_blessing = 1388,attr = [{1,7224},{2,144480},{3,3612},{4,3612}],other = []};

get_companion_stage(3,13,3) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 3,biography = 0,need_blessing = 1405,attr = [{1,7260},{2,145200},{3,3630},{4,3630}],other = []};

get_companion_stage(3,13,4) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 4,biography = 0,need_blessing = 1422,attr = [{1,7296},{2,145920},{3,3648},{4,3648}],other = []};

get_companion_stage(3,13,5) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 5,biography = 0,need_blessing = 1439,attr = [{1,7332},{2,146640},{3,3666},{4,3666}],other = []};

get_companion_stage(3,13,6) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 6,biography = 0,need_blessing = 1456,attr = [{1,7368},{2,147360},{3,3684},{4,3684}],other = []};

get_companion_stage(3,13,7) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 7,biography = 0,need_blessing = 1473,attr = [{1,7404},{2,148080},{3,3702},{4,3702}],other = []};

get_companion_stage(3,13,8) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 8,biography = 0,need_blessing = 1490,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],other = []};

get_companion_stage(3,13,9) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 9,biography = 0,need_blessing = 1507,attr = [{1,7476},{2,149520},{3,3738},{4,3738}],other = []};

get_companion_stage(3,13,10) ->
	#base_companion_stage{companion_id = 3,stage = 13,star = 10,biography = 0,need_blessing = 1524,attr = [{1,7548},{2,150960},{3,3774},{4,3774}],other = []};

get_companion_stage(3,14,1) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 1,biography = 0,need_blessing = 1541,attr = [{1,7584},{2,151680},{3,3792},{4,3792}],other = []};

get_companion_stage(3,14,2) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 2,biography = 0,need_blessing = 1559,attr = [{1,7620},{2,152400},{3,3810},{4,3810}],other = []};

get_companion_stage(3,14,3) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 3,biography = 0,need_blessing = 1576,attr = [{1,7656},{2,153120},{3,3828},{4,3828}],other = []};

get_companion_stage(3,14,4) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 4,biography = 0,need_blessing = 1594,attr = [{1,7692},{2,153840},{3,3846},{4,3846}],other = []};

get_companion_stage(3,14,5) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 5,biography = 0,need_blessing = 1611,attr = [{1,7728},{2,154560},{3,3864},{4,3864}],other = []};

get_companion_stage(3,14,6) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 6,biography = 0,need_blessing = 1629,attr = [{1,7764},{2,155280},{3,3882},{4,3882}],other = []};

get_companion_stage(3,14,7) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 7,biography = 0,need_blessing = 1646,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],other = []};

get_companion_stage(3,14,8) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 8,biography = 0,need_blessing = 1664,attr = [{1,7836},{2,156720},{3,3918},{4,3918}],other = []};

get_companion_stage(3,14,9) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 9,biography = 0,need_blessing = 1682,attr = [{1,7872},{2,157440},{3,3936},{4,3936}],other = []};

get_companion_stage(3,14,10) ->
	#base_companion_stage{companion_id = 3,stage = 14,star = 10,biography = 0,need_blessing = 1700,attr = [{1,7944},{2,158880},{3,3972},{4,3972}],other = []};

get_companion_stage(3,15,1) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 1,biography = 0,need_blessing = 1718,attr = [{1,7980},{2,159600},{3,3990},{4,3990}],other = []};

get_companion_stage(3,15,2) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 2,biography = 0,need_blessing = 1736,attr = [{1,8016},{2,160320},{3,4008},{4,4008}],other = []};

get_companion_stage(3,15,3) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 3,biography = 0,need_blessing = 1754,attr = [{1,8052},{2,161040},{3,4026},{4,4026}],other = []};

get_companion_stage(3,15,4) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 4,biography = 0,need_blessing = 1772,attr = [{1,8088},{2,161760},{3,4044},{4,4044}],other = []};

get_companion_stage(3,15,5) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 5,biography = 0,need_blessing = 1790,attr = [{1,8124},{2,162480},{3,4062},{4,4062}],other = []};

get_companion_stage(3,15,6) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 6,biography = 0,need_blessing = 1808,attr = [{1,8160},{2,163200},{3,4080},{4,4080}],other = []};

get_companion_stage(3,15,7) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 7,biography = 0,need_blessing = 1826,attr = [{1,8196},{2,163920},{3,4098},{4,4098}],other = []};

get_companion_stage(3,15,8) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 8,biography = 0,need_blessing = 1845,attr = [{1,8232},{2,164640},{3,4116},{4,4116}],other = []};

get_companion_stage(3,15,9) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 9,biography = 0,need_blessing = 1863,attr = [{1,8268},{2,165360},{3,4134},{4,4134}],other = []};

get_companion_stage(3,15,10) ->
	#base_companion_stage{companion_id = 3,stage = 15,star = 10,biography = 0,need_blessing = 1881,attr = [{1,8340},{2,166800},{3,4170},{4,4170}],other = []};

get_companion_stage(3,16,1) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 1,biography = 0,need_blessing = 1900,attr = [{1,8376},{2,167520},{3,4188},{4,4188}],other = []};

get_companion_stage(3,16,2) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 2,biography = 0,need_blessing = 1919,attr = [{1,8412},{2,168240},{3,4206},{4,4206}],other = []};

get_companion_stage(3,16,3) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 3,biography = 0,need_blessing = 1937,attr = [{1,8448},{2,168960},{3,4224},{4,4224}],other = []};

get_companion_stage(3,16,4) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 4,biography = 0,need_blessing = 1956,attr = [{1,8484},{2,169680},{3,4242},{4,4242}],other = []};

get_companion_stage(3,16,5) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 5,biography = 0,need_blessing = 1975,attr = [{1,8520},{2,170400},{3,4260},{4,4260}],other = []};

get_companion_stage(3,16,6) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 6,biography = 0,need_blessing = 1994,attr = [{1,8556},{2,171120},{3,4278},{4,4278}],other = []};

get_companion_stage(3,16,7) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 7,biography = 0,need_blessing = 2012,attr = [{1,8592},{2,171840},{3,4296},{4,4296}],other = []};

get_companion_stage(3,16,8) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 8,biography = 0,need_blessing = 2031,attr = [{1,8628},{2,172560},{3,4314},{4,4314}],other = []};

get_companion_stage(3,16,9) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 9,biography = 0,need_blessing = 2050,attr = [{1,8664},{2,173280},{3,4332},{4,4332}],other = []};

get_companion_stage(3,16,10) ->
	#base_companion_stage{companion_id = 3,stage = 16,star = 10,biography = 0,need_blessing = 2069,attr = [{1,8736},{2,174720},{3,4368},{4,4368}],other = []};

get_companion_stage(3,17,1) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 1,biography = 0,need_blessing = 2089,attr = [{1,8772},{2,175440},{3,4386},{4,4386}],other = []};

get_companion_stage(3,17,2) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 2,biography = 0,need_blessing = 2108,attr = [{1,8808},{2,176160},{3,4404},{4,4404}],other = []};

get_companion_stage(3,17,3) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 3,biography = 0,need_blessing = 2127,attr = [{1,8844},{2,176880},{3,4422},{4,4422}],other = []};

get_companion_stage(3,17,4) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 4,biography = 0,need_blessing = 2146,attr = [{1,8880},{2,177600},{3,4440},{4,4440}],other = []};

get_companion_stage(3,17,5) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 5,biography = 0,need_blessing = 2166,attr = [{1,8916},{2,178320},{3,4458},{4,4458}],other = []};

get_companion_stage(3,17,6) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 6,biography = 0,need_blessing = 2185,attr = [{1,8952},{2,179040},{3,4476},{4,4476}],other = []};

get_companion_stage(3,17,7) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 7,biography = 0,need_blessing = 2205,attr = [{1,8988},{2,179760},{3,4494},{4,4494}],other = []};

get_companion_stage(3,17,8) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 8,biography = 0,need_blessing = 2224,attr = [{1,9024},{2,180480},{3,4512},{4,4512}],other = []};

get_companion_stage(3,17,9) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 9,biography = 0,need_blessing = 2244,attr = [{1,9060},{2,181200},{3,4530},{4,4530}],other = []};

get_companion_stage(3,17,10) ->
	#base_companion_stage{companion_id = 3,stage = 17,star = 10,biography = 0,need_blessing = 2263,attr = [{1,9132},{2,182640},{3,4566},{4,4566}],other = []};

get_companion_stage(3,18,1) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 1,biography = 0,need_blessing = 2283,attr = [{1,9168},{2,183360},{3,4584},{4,4584}],other = []};

get_companion_stage(3,18,2) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 2,biography = 0,need_blessing = 2303,attr = [{1,9204},{2,184080},{3,4602},{4,4602}],other = []};

get_companion_stage(3,18,3) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 3,biography = 0,need_blessing = 2323,attr = [{1,9240},{2,184800},{3,4620},{4,4620}],other = []};

get_companion_stage(3,18,4) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 4,biography = 0,need_blessing = 2342,attr = [{1,9276},{2,185520},{3,4638},{4,4638}],other = []};

get_companion_stage(3,18,5) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 5,biography = 0,need_blessing = 2362,attr = [{1,9312},{2,186240},{3,4656},{4,4656}],other = []};

get_companion_stage(3,18,6) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 6,biography = 0,need_blessing = 2382,attr = [{1,9348},{2,186960},{3,4674},{4,4674}],other = []};

get_companion_stage(3,18,7) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 7,biography = 0,need_blessing = 2402,attr = [{1,9384},{2,187680},{3,4692},{4,4692}],other = []};

get_companion_stage(3,18,8) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 8,biography = 0,need_blessing = 2422,attr = [{1,9420},{2,188400},{3,4710},{4,4710}],other = []};

get_companion_stage(3,18,9) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 9,biography = 0,need_blessing = 2443,attr = [{1,9456},{2,189120},{3,4728},{4,4728}],other = []};

get_companion_stage(3,18,10) ->
	#base_companion_stage{companion_id = 3,stage = 18,star = 10,biography = 0,need_blessing = 2463,attr = [{1,9528},{2,190560},{3,4764},{4,4764}],other = []};

get_companion_stage(3,19,1) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 1,biography = 0,need_blessing = 2483,attr = [{1,9564},{2,191280},{3,4782},{4,4782}],other = []};

get_companion_stage(3,19,2) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 2,biography = 0,need_blessing = 2503,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(3,19,3) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 3,biography = 0,need_blessing = 2524,attr = [{1,9636},{2,192720},{3,4818},{4,4818}],other = []};

get_companion_stage(3,19,4) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 4,biography = 0,need_blessing = 2544,attr = [{1,9672},{2,193440},{3,4836},{4,4836}],other = []};

get_companion_stage(3,19,5) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 5,biography = 0,need_blessing = 2565,attr = [{1,9708},{2,194160},{3,4854},{4,4854}],other = []};

get_companion_stage(3,19,6) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 6,biography = 0,need_blessing = 2585,attr = [{1,9744},{2,194880},{3,4872},{4,4872}],other = []};

get_companion_stage(3,19,7) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 7,biography = 0,need_blessing = 2606,attr = [{1,9780},{2,195600},{3,4890},{4,4890}],other = []};

get_companion_stage(3,19,8) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 8,biography = 0,need_blessing = 2626,attr = [{1,9816},{2,196320},{3,4908},{4,4908}],other = []};

get_companion_stage(3,19,9) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 9,biography = 0,need_blessing = 2647,attr = [{1,9852},{2,197040},{3,4926},{4,4926}],other = []};

get_companion_stage(3,19,10) ->
	#base_companion_stage{companion_id = 3,stage = 19,star = 10,biography = 0,need_blessing = 2668,attr = [{1,9924},{2,198480},{3,4962},{4,4962}],other = []};

get_companion_stage(3,20,1) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 1,biography = 0,need_blessing = 2689,attr = [{1,9960},{2,199200},{3,4980},{4,4980}],other = []};

get_companion_stage(3,20,2) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 2,biography = 0,need_blessing = 2710,attr = [{1,9996},{2,199920},{3,4998},{4,4998}],other = []};

get_companion_stage(3,20,3) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 3,biography = 0,need_blessing = 2731,attr = [{1,10032},{2,200640},{3,5016},{4,5016}],other = []};

get_companion_stage(3,20,4) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 4,biography = 0,need_blessing = 2752,attr = [{1,10068},{2,201360},{3,5034},{4,5034}],other = []};

get_companion_stage(3,20,5) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 5,biography = 0,need_blessing = 2773,attr = [{1,10104},{2,202080},{3,5052},{4,5052}],other = []};

get_companion_stage(3,20,6) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 6,biography = 0,need_blessing = 2794,attr = [{1,10140},{2,202800},{3,5070},{4,5070}],other = []};

get_companion_stage(3,20,7) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 7,biography = 0,need_blessing = 2815,attr = [{1,10176},{2,203520},{3,5088},{4,5088}],other = []};

get_companion_stage(3,20,8) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 8,biography = 0,need_blessing = 2836,attr = [{1,10212},{2,204240},{3,5106},{4,5106}],other = []};

get_companion_stage(3,20,9) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 9,biography = 0,need_blessing = 2857,attr = [{1,10248},{2,204960},{3,5124},{4,5124}],other = []};

get_companion_stage(3,20,10) ->
	#base_companion_stage{companion_id = 3,stage = 20,star = 10,biography = 0,need_blessing = 2878,attr = [{1,10320},{2,206400},{3,5160},{4,5160}],other = []};

get_companion_stage(3,21,1) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 1,biography = 0,need_blessing = 2900,attr = [{1,10356},{2,207120},{3,5178},{4,5178}],other = []};

get_companion_stage(3,21,2) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 2,biography = 0,need_blessing = 2921,attr = [{1,10392},{2,207840},{3,5196},{4,5196}],other = []};

get_companion_stage(3,21,3) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 3,biography = 0,need_blessing = 2943,attr = [{1,10428},{2,208560},{3,5214},{4,5214}],other = []};

get_companion_stage(3,21,4) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 4,biography = 0,need_blessing = 2964,attr = [{1,10464},{2,209280},{3,5232},{4,5232}],other = []};

get_companion_stage(3,21,5) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 5,biography = 0,need_blessing = 2986,attr = [{1,10500},{2,210000},{3,5250},{4,5250}],other = []};

get_companion_stage(3,21,6) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 6,biography = 0,need_blessing = 3007,attr = [{1,10536},{2,210720},{3,5268},{4,5268}],other = []};

get_companion_stage(3,21,7) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 7,biography = 0,need_blessing = 3029,attr = [{1,10572},{2,211440},{3,5286},{4,5286}],other = []};

get_companion_stage(3,21,8) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 8,biography = 0,need_blessing = 3051,attr = [{1,10608},{2,212160},{3,5304},{4,5304}],other = []};

get_companion_stage(3,21,9) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 9,biography = 0,need_blessing = 3072,attr = [{1,10644},{2,212880},{3,5322},{4,5322}],other = []};

get_companion_stage(3,21,10) ->
	#base_companion_stage{companion_id = 3,stage = 21,star = 10,biography = 0,need_blessing = 3094,attr = [{1,10716},{2,214320},{3,5358},{4,5358}],other = []};

get_companion_stage(3,22,1) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 1,biography = 0,need_blessing = 3116,attr = [{1,10752},{2,215040},{3,5376},{4,5376}],other = []};

get_companion_stage(3,22,2) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 2,biography = 0,need_blessing = 3138,attr = [{1,10788},{2,215760},{3,5394},{4,5394}],other = []};

get_companion_stage(3,22,3) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 3,biography = 0,need_blessing = 3160,attr = [{1,10824},{2,216480},{3,5412},{4,5412}],other = []};

get_companion_stage(3,22,4) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 4,biography = 0,need_blessing = 3182,attr = [{1,10860},{2,217200},{3,5430},{4,5430}],other = []};

get_companion_stage(3,22,5) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 5,biography = 0,need_blessing = 3204,attr = [{1,10896},{2,217920},{3,5448},{4,5448}],other = []};

get_companion_stage(3,22,6) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 6,biography = 0,need_blessing = 3226,attr = [{1,10932},{2,218640},{3,5466},{4,5466}],other = []};

get_companion_stage(3,22,7) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 7,biography = 0,need_blessing = 3248,attr = [{1,10968},{2,219360},{3,5484},{4,5484}],other = []};

get_companion_stage(3,22,8) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 8,biography = 0,need_blessing = 3271,attr = [{1,11004},{2,220080},{3,5502},{4,5502}],other = []};

get_companion_stage(3,22,9) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 9,biography = 0,need_blessing = 3293,attr = [{1,11040},{2,220800},{3,5520},{4,5520}],other = []};

get_companion_stage(3,22,10) ->
	#base_companion_stage{companion_id = 3,stage = 22,star = 10,biography = 0,need_blessing = 3315,attr = [{1,11112},{2,222240},{3,5556},{4,5556}],other = []};

get_companion_stage(3,23,1) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 1,biography = 0,need_blessing = 3338,attr = [{1,11148},{2,222960},{3,5574},{4,5574}],other = []};

get_companion_stage(3,23,2) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 2,biography = 0,need_blessing = 3360,attr = [{1,11184},{2,223680},{3,5592},{4,5592}],other = []};

get_companion_stage(3,23,3) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 3,biography = 0,need_blessing = 3383,attr = [{1,11220},{2,224400},{3,5610},{4,5610}],other = []};

get_companion_stage(3,23,4) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 4,biography = 0,need_blessing = 3405,attr = [{1,11256},{2,225120},{3,5628},{4,5628}],other = []};

get_companion_stage(3,23,5) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 5,biography = 0,need_blessing = 3428,attr = [{1,11292},{2,225840},{3,5646},{4,5646}],other = []};

get_companion_stage(3,23,6) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 6,biography = 0,need_blessing = 3450,attr = [{1,11328},{2,226560},{3,5664},{4,5664}],other = []};

get_companion_stage(3,23,7) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 7,biography = 0,need_blessing = 3473,attr = [{1,11364},{2,227280},{3,5682},{4,5682}],other = []};

get_companion_stage(3,23,8) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 8,biography = 0,need_blessing = 3496,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = []};

get_companion_stage(3,23,9) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 9,biography = 0,need_blessing = 3518,attr = [{1,11436},{2,228720},{3,5718},{4,5718}],other = []};

get_companion_stage(3,23,10) ->
	#base_companion_stage{companion_id = 3,stage = 23,star = 10,biography = 0,need_blessing = 3541,attr = [{1,11508},{2,230160},{3,5754},{4,5754}],other = []};

get_companion_stage(3,24,1) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 1,biography = 0,need_blessing = 3564,attr = [{1,11544},{2,230880},{3,5772},{4,5772}],other = []};

get_companion_stage(3,24,2) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 2,biography = 0,need_blessing = 3587,attr = [{1,11580},{2,231600},{3,5790},{4,5790}],other = []};

get_companion_stage(3,24,3) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 3,biography = 0,need_blessing = 3610,attr = [{1,11616},{2,232320},{3,5808},{4,5808}],other = []};

get_companion_stage(3,24,4) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 4,biography = 0,need_blessing = 3633,attr = [{1,11652},{2,233040},{3,5826},{4,5826}],other = []};

get_companion_stage(3,24,5) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 5,biography = 0,need_blessing = 3656,attr = [{1,11688},{2,233760},{3,5844},{4,5844}],other = []};

get_companion_stage(3,24,6) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 6,biography = 0,need_blessing = 3679,attr = [{1,11724},{2,234480},{3,5862},{4,5862}],other = []};

get_companion_stage(3,24,7) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 7,biography = 0,need_blessing = 3702,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],other = []};

get_companion_stage(3,24,8) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 8,biography = 0,need_blessing = 3726,attr = [{1,11796},{2,235920},{3,5898},{4,5898}],other = []};

get_companion_stage(3,24,9) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 9,biography = 0,need_blessing = 3749,attr = [{1,11832},{2,236640},{3,5916},{4,5916}],other = []};

get_companion_stage(3,24,10) ->
	#base_companion_stage{companion_id = 3,stage = 24,star = 10,biography = 0,need_blessing = 3772,attr = [{1,11904},{2,238080},{3,5952},{4,5952}],other = []};

get_companion_stage(3,25,1) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 1,biography = 0,need_blessing = 3795,attr = [{1,11940},{2,238800},{3,5970},{4,5970}],other = []};

get_companion_stage(3,25,2) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 2,biography = 0,need_blessing = 3819,attr = [{1,11976},{2,239520},{3,5988},{4,5988}],other = []};

get_companion_stage(3,25,3) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 3,biography = 0,need_blessing = 3842,attr = [{1,12012},{2,240240},{3,6006},{4,6006}],other = []};

get_companion_stage(3,25,4) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 4,biography = 0,need_blessing = 3866,attr = [{1,12048},{2,240960},{3,6024},{4,6024}],other = []};

get_companion_stage(3,25,5) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 5,biography = 0,need_blessing = 3889,attr = [{1,12084},{2,241680},{3,6042},{4,6042}],other = []};

get_companion_stage(3,25,6) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 6,biography = 0,need_blessing = 3913,attr = [{1,12120},{2,242400},{3,6060},{4,6060}],other = []};

get_companion_stage(3,25,7) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 7,biography = 0,need_blessing = 3937,attr = [{1,12156},{2,243120},{3,6078},{4,6078}],other = []};

get_companion_stage(3,25,8) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 8,biography = 0,need_blessing = 3960,attr = [{1,12192},{2,243840},{3,6096},{4,6096}],other = []};

get_companion_stage(3,25,9) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 9,biography = 0,need_blessing = 3984,attr = [{1,12228},{2,244560},{3,6114},{4,6114}],other = []};

get_companion_stage(3,25,10) ->
	#base_companion_stage{companion_id = 3,stage = 25,star = 10,biography = 0,need_blessing = 4008,attr = [{1,12300},{2,246000},{3,6150},{4,6150}],other = []};

get_companion_stage(3,26,1) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 1,biography = 0,need_blessing = 4032,attr = [{1,12336},{2,246720},{3,6168},{4,6168}],other = []};

get_companion_stage(3,26,2) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 2,biography = 0,need_blessing = 4056,attr = [{1,12372},{2,247440},{3,6186},{4,6186}],other = []};

get_companion_stage(3,26,3) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 3,biography = 0,need_blessing = 4080,attr = [{1,12408},{2,248160},{3,6204},{4,6204}],other = []};

get_companion_stage(3,26,4) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 4,biography = 0,need_blessing = 4104,attr = [{1,12444},{2,248880},{3,6222},{4,6222}],other = []};

get_companion_stage(3,26,5) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 5,biography = 0,need_blessing = 4128,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(3,26,6) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 6,biography = 0,need_blessing = 4152,attr = [{1,12516},{2,250320},{3,6258},{4,6258}],other = []};

get_companion_stage(3,26,7) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 7,biography = 0,need_blessing = 4176,attr = [{1,12552},{2,251040},{3,6276},{4,6276}],other = []};

get_companion_stage(3,26,8) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 8,biography = 0,need_blessing = 4200,attr = [{1,12588},{2,251760},{3,6294},{4,6294}],other = []};

get_companion_stage(3,26,9) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 9,biography = 0,need_blessing = 4224,attr = [{1,12624},{2,252480},{3,6312},{4,6312}],other = []};

get_companion_stage(3,26,10) ->
	#base_companion_stage{companion_id = 3,stage = 26,star = 10,biography = 0,need_blessing = 4248,attr = [{1,12696},{2,253920},{3,6348},{4,6348}],other = []};

get_companion_stage(3,27,1) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 1,biography = 0,need_blessing = 4273,attr = [{1,12732},{2,254640},{3,6366},{4,6366}],other = []};

get_companion_stage(3,27,2) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 2,biography = 0,need_blessing = 4297,attr = [{1,12768},{2,255360},{3,6384},{4,6384}],other = []};

get_companion_stage(3,27,3) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 3,biography = 0,need_blessing = 4321,attr = [{1,12804},{2,256080},{3,6402},{4,6402}],other = []};

get_companion_stage(3,27,4) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 4,biography = 0,need_blessing = 4346,attr = [{1,12840},{2,256800},{3,6420},{4,6420}],other = []};

get_companion_stage(3,27,5) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 5,biography = 0,need_blessing = 4370,attr = [{1,12876},{2,257520},{3,6438},{4,6438}],other = []};

get_companion_stage(3,27,6) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 6,biography = 0,need_blessing = 4395,attr = [{1,12912},{2,258240},{3,6456},{4,6456}],other = []};

get_companion_stage(3,27,7) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 7,biography = 0,need_blessing = 4419,attr = [{1,12948},{2,258960},{3,6474},{4,6474}],other = []};

get_companion_stage(3,27,8) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 8,biography = 0,need_blessing = 4444,attr = [{1,12984},{2,259680},{3,6492},{4,6492}],other = []};

get_companion_stage(3,27,9) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 9,biography = 0,need_blessing = 4469,attr = [{1,13020},{2,260400},{3,6510},{4,6510}],other = []};

get_companion_stage(3,27,10) ->
	#base_companion_stage{companion_id = 3,stage = 27,star = 10,biography = 0,need_blessing = 4493,attr = [{1,13092},{2,261840},{3,6546},{4,6546}],other = []};

get_companion_stage(3,28,1) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 1,biography = 0,need_blessing = 4518,attr = [{1,13128},{2,262560},{3,6564},{4,6564}],other = []};

get_companion_stage(3,28,2) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 2,biography = 0,need_blessing = 4543,attr = [{1,13164},{2,263280},{3,6582},{4,6582}],other = []};

get_companion_stage(3,28,3) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 3,biography = 0,need_blessing = 4568,attr = [{1,13200},{2,264000},{3,6600},{4,6600}],other = []};

get_companion_stage(3,28,4) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 4,biography = 0,need_blessing = 4593,attr = [{1,13236},{2,264720},{3,6618},{4,6618}],other = []};

get_companion_stage(3,28,5) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 5,biography = 0,need_blessing = 4618,attr = [{1,13272},{2,265440},{3,6636},{4,6636}],other = []};

get_companion_stage(3,28,6) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 6,biography = 0,need_blessing = 4643,attr = [{1,13308},{2,266160},{3,6654},{4,6654}],other = []};

get_companion_stage(3,28,7) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 7,biography = 0,need_blessing = 4668,attr = [{1,13344},{2,266880},{3,6672},{4,6672}],other = []};

get_companion_stage(3,28,8) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 8,biography = 0,need_blessing = 4693,attr = [{1,13380},{2,267600},{3,6690},{4,6690}],other = []};

get_companion_stage(3,28,9) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 9,biography = 0,need_blessing = 4718,attr = [{1,13416},{2,268320},{3,6708},{4,6708}],other = []};

get_companion_stage(3,28,10) ->
	#base_companion_stage{companion_id = 3,stage = 28,star = 10,biography = 0,need_blessing = 4743,attr = [{1,13488},{2,269760},{3,6744},{4,6744}],other = []};

get_companion_stage(3,29,1) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 1,biography = 0,need_blessing = 4768,attr = [{1,13524},{2,270480},{3,6762},{4,6762}],other = []};

get_companion_stage(3,29,2) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 2,biography = 0,need_blessing = 4794,attr = [{1,13560},{2,271200},{3,6780},{4,6780}],other = []};

get_companion_stage(3,29,3) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 3,biography = 0,need_blessing = 4819,attr = [{1,13596},{2,271920},{3,6798},{4,6798}],other = []};

get_companion_stage(3,29,4) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 4,biography = 0,need_blessing = 4844,attr = [{1,13632},{2,272640},{3,6816},{4,6816}],other = []};

get_companion_stage(3,29,5) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 5,biography = 0,need_blessing = 4870,attr = [{1,13668},{2,273360},{3,6834},{4,6834}],other = []};

get_companion_stage(3,29,6) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 6,biography = 0,need_blessing = 4895,attr = [{1,13704},{2,274080},{3,6852},{4,6852}],other = []};

get_companion_stage(3,29,7) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 7,biography = 0,need_blessing = 4921,attr = [{1,13740},{2,274800},{3,6870},{4,6870}],other = []};

get_companion_stage(3,29,8) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 8,biography = 0,need_blessing = 4946,attr = [{1,13776},{2,275520},{3,6888},{4,6888}],other = []};

get_companion_stage(3,29,9) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 9,biography = 0,need_blessing = 4972,attr = [{1,13812},{2,276240},{3,6906},{4,6906}],other = []};

get_companion_stage(3,29,10) ->
	#base_companion_stage{companion_id = 3,stage = 29,star = 10,biography = 0,need_blessing = 4997,attr = [{1,13884},{2,277680},{3,6942},{4,6942}],other = []};

get_companion_stage(3,30,1) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 1,biography = 0,need_blessing = 5023,attr = [{1,13920},{2,278400},{3,6960},{4,6960}],other = []};

get_companion_stage(3,30,2) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 2,biography = 0,need_blessing = 5049,attr = [{1,13956},{2,279120},{3,6978},{4,6978}],other = []};

get_companion_stage(3,30,3) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 3,biography = 0,need_blessing = 5074,attr = [{1,13992},{2,279840},{3,6996},{4,6996}],other = []};

get_companion_stage(3,30,4) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 4,biography = 0,need_blessing = 5100,attr = [{1,14028},{2,280560},{3,7014},{4,7014}],other = []};

get_companion_stage(3,30,5) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 5,biography = 0,need_blessing = 5126,attr = [{1,14064},{2,281280},{3,7032},{4,7032}],other = []};

get_companion_stage(3,30,6) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 6,biography = 0,need_blessing = 5152,attr = [{1,14100},{2,282000},{3,7050},{4,7050}],other = []};

get_companion_stage(3,30,7) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 7,biography = 0,need_blessing = 5178,attr = [{1,14136},{2,282720},{3,7068},{4,7068}],other = []};

get_companion_stage(3,30,8) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 8,biography = 0,need_blessing = 5204,attr = [{1,14172},{2,283440},{3,7086},{4,7086}],other = []};

get_companion_stage(3,30,9) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 9,biography = 0,need_blessing = 5230,attr = [{1,14208},{2,284160},{3,7104},{4,7104}],other = []};

get_companion_stage(3,30,10) ->
	#base_companion_stage{companion_id = 3,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,14280},{2,285600},{3,7140},{4,7140}],other = []};

get_companion_stage(4,1,0) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,3000},{2,60000},{3,1500},{4,1500}],other = []};

get_companion_stage(4,1,1) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 1,biography = 0,need_blessing = 13,attr = [{1,3036},{2,60720},{3,1518},{4,1518}],other = []};

get_companion_stage(4,1,2) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 2,biography = 0,need_blessing = 16,attr = [{1,3072},{2,61440},{3,1536},{4,1536}],other = []};

get_companion_stage(4,1,3) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 3,biography = 0,need_blessing = 19,attr = [{1,3108},{2,62160},{3,1554},{4,1554}],other = []};

get_companion_stage(4,1,4) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 4,biography = 0,need_blessing = 22,attr = [{1,3144},{2,62880},{3,1572},{4,1572}],other = []};

get_companion_stage(4,1,5) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 5,biography = 0,need_blessing = 26,attr = [{1,3180},{2,63600},{3,1590},{4,1590}],other = []};

get_companion_stage(4,1,6) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 6,biography = 0,need_blessing = 30,attr = [{1,3216},{2,64320},{3,1608},{4,1608}],other = []};

get_companion_stage(4,1,7) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 7,biography = 0,need_blessing = 35,attr = [{1,3252},{2,65040},{3,1626},{4,1626}],other = []};

get_companion_stage(4,1,8) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 8,biography = 0,need_blessing = 39,attr = [{1,3288},{2,65760},{3,1644},{4,1644}],other = []};

get_companion_stage(4,1,9) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 9,biography = 0,need_blessing = 44,attr = [{1,3324},{2,66480},{3,1662},{4,1662}],other = []};

get_companion_stage(4,1,10) ->
	#base_companion_stage{companion_id = 4,stage = 1,star = 10,biography = 1,need_blessing = 49,attr = [{1,3396},{2,67920},{3,1698},{4,1698}],other = [{biog_reward, [{2,0,100},{0, 22030004, 3},{0, 22030104, 1}]}]};

get_companion_stage(4,2,1) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 1,biography = 0,need_blessing = 54,attr = [{1,3432},{2,68640},{3,1716},{4,1716}],other = []};

get_companion_stage(4,2,2) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 2,biography = 0,need_blessing = 60,attr = [{1,3468},{2,69360},{3,1734},{4,1734}],other = []};

get_companion_stage(4,2,3) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 3,biography = 0,need_blessing = 66,attr = [{1,3504},{2,70080},{3,1752},{4,1752}],other = []};

get_companion_stage(4,2,4) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 4,biography = 0,need_blessing = 72,attr = [{1,3540},{2,70800},{3,1770},{4,1770}],other = []};

get_companion_stage(4,2,5) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 5,biography = 0,need_blessing = 78,attr = [{1,3576},{2,71520},{3,1788},{4,1788}],other = []};

get_companion_stage(4,2,6) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 6,biography = 0,need_blessing = 84,attr = [{1,3612},{2,72240},{3,1806},{4,1806}],other = []};

get_companion_stage(4,2,7) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 7,biography = 0,need_blessing = 90,attr = [{1,3648},{2,72960},{3,1824},{4,1824}],other = []};

get_companion_stage(4,2,8) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 8,biography = 0,need_blessing = 97,attr = [{1,3684},{2,73680},{3,1842},{4,1842}],other = []};

get_companion_stage(4,2,9) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 9,biography = 0,need_blessing = 104,attr = [{1,3720},{2,74400},{3,1860},{4,1860}],other = []};

get_companion_stage(4,2,10) ->
	#base_companion_stage{companion_id = 4,stage = 2,star = 10,biography = 0,need_blessing = 111,attr = [{1,3792},{2,75840},{3,1896},{4,1896}],other = []};

get_companion_stage(4,3,1) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 1,biography = 0,need_blessing = 118,attr = [{1,3828},{2,76560},{3,1914},{4,1914}],other = []};

get_companion_stage(4,3,2) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 2,biography = 0,need_blessing = 125,attr = [{1,3864},{2,77280},{3,1932},{4,1932}],other = []};

get_companion_stage(4,3,3) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 3,biography = 0,need_blessing = 133,attr = [{1,3900},{2,78000},{3,1950},{4,1950}],other = []};

get_companion_stage(4,3,4) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 4,biography = 0,need_blessing = 140,attr = [{1,3936},{2,78720},{3,1968},{4,1968}],other = []};

get_companion_stage(4,3,5) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 5,biography = 0,need_blessing = 148,attr = [{1,3972},{2,79440},{3,1986},{4,1986}],other = []};

get_companion_stage(4,3,6) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 6,biography = 0,need_blessing = 156,attr = [{1,4008},{2,80160},{3,2004},{4,2004}],other = []};

get_companion_stage(4,3,7) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 7,biography = 0,need_blessing = 164,attr = [{1,4044},{2,80880},{3,2022},{4,2022}],other = []};

get_companion_stage(4,3,8) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 8,biography = 0,need_blessing = 172,attr = [{1,4080},{2,81600},{3,2040},{4,2040}],other = []};

get_companion_stage(4,3,9) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 9,biography = 0,need_blessing = 180,attr = [{1,4116},{2,82320},{3,2058},{4,2058}],other = []};

get_companion_stage(4,3,10) ->
	#base_companion_stage{companion_id = 4,stage = 3,star = 10,biography = 2,need_blessing = 189,attr = [{1,4188},{2,83760},{3,2094},{4,2094}],other = [{biog_reward, [{2,0,200},{0, 22030004, 5},{0, 22030104, 3}]}]};

get_companion_stage(4,4,1) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 1,biography = 0,need_blessing = 197,attr = [{1,4224},{2,84480},{3,2112},{4,2112}],other = []};

get_companion_stage(4,4,2) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 2,biography = 0,need_blessing = 206,attr = [{1,4260},{2,85200},{3,2130},{4,2130}],other = []};

get_companion_stage(4,4,3) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 3,biography = 0,need_blessing = 215,attr = [{1,4296},{2,85920},{3,2148},{4,2148}],other = []};

get_companion_stage(4,4,4) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 4,biography = 0,need_blessing = 224,attr = [{1,4332},{2,86640},{3,2166},{4,2166}],other = []};

get_companion_stage(4,4,5) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 5,biography = 0,need_blessing = 233,attr = [{1,4368},{2,87360},{3,2184},{4,2184}],other = []};

get_companion_stage(4,4,6) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 6,biography = 0,need_blessing = 242,attr = [{1,4404},{2,88080},{3,2202},{4,2202}],other = []};

get_companion_stage(4,4,7) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 7,biography = 0,need_blessing = 251,attr = [{1,4440},{2,88800},{3,2220},{4,2220}],other = []};

get_companion_stage(4,4,8) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 8,biography = 0,need_blessing = 260,attr = [{1,4476},{2,89520},{3,2238},{4,2238}],other = []};

get_companion_stage(4,4,9) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 9,biography = 0,need_blessing = 270,attr = [{1,4512},{2,90240},{3,2256},{4,2256}],other = []};

get_companion_stage(4,4,10) ->
	#base_companion_stage{companion_id = 4,stage = 4,star = 10,biography = 0,need_blessing = 280,attr = [{1,4584},{2,91680},{3,2292},{4,2292}],other = []};

get_companion_stage(4,5,1) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 1,biography = 0,need_blessing = 289,attr = [{1,4620},{2,92400},{3,2310},{4,2310}],other = []};

get_companion_stage(4,5,2) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 2,biography = 0,need_blessing = 299,attr = [{1,4656},{2,93120},{3,2328},{4,2328}],other = []};

get_companion_stage(4,5,3) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 3,biography = 0,need_blessing = 309,attr = [{1,4692},{2,93840},{3,2346},{4,2346}],other = []};

get_companion_stage(4,5,4) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 4,biography = 0,need_blessing = 319,attr = [{1,4728},{2,94560},{3,2364},{4,2364}],other = []};

get_companion_stage(4,5,5) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 5,biography = 0,need_blessing = 330,attr = [{1,4764},{2,95280},{3,2382},{4,2382}],other = []};

get_companion_stage(4,5,6) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 6,biography = 0,need_blessing = 340,attr = [{1,4800},{2,96000},{3,2400},{4,2400}],other = []};

get_companion_stage(4,5,7) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 7,biography = 0,need_blessing = 351,attr = [{1,4836},{2,96720},{3,2418},{4,2418}],other = []};

get_companion_stage(4,5,8) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 8,biography = 0,need_blessing = 361,attr = [{1,4872},{2,97440},{3,2436},{4,2436}],other = []};

get_companion_stage(4,5,9) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 9,biography = 0,need_blessing = 372,attr = [{1,4908},{2,98160},{3,2454},{4,2454}],other = []};

get_companion_stage(4,5,10) ->
	#base_companion_stage{companion_id = 4,stage = 5,star = 10,biography = 3,need_blessing = 382,attr = [{1,4980},{2,99600},{3,2490},{4,2490}],other = [{biog_reward, [{2,0,250},{0, 22030004, 10},{0, 22030104, 5}]}]};

get_companion_stage(4,6,1) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 1,biography = 0,need_blessing = 393,attr = [{1,5016},{2,100320},{3,2508},{4,2508}],other = []};

get_companion_stage(4,6,2) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 2,biography = 0,need_blessing = 404,attr = [{1,5052},{2,101040},{3,2526},{4,2526}],other = []};

get_companion_stage(4,6,3) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 3,biography = 0,need_blessing = 415,attr = [{1,5088},{2,101760},{3,2544},{4,2544}],other = []};

get_companion_stage(4,6,4) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 4,biography = 0,need_blessing = 427,attr = [{1,5124},{2,102480},{3,2562},{4,2562}],other = []};

get_companion_stage(4,6,5) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 5,biography = 0,need_blessing = 438,attr = [{1,5160},{2,103200},{3,2580},{4,2580}],other = []};

get_companion_stage(4,6,6) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 6,biography = 0,need_blessing = 449,attr = [{1,5196},{2,103920},{3,2598},{4,2598}],other = []};

get_companion_stage(4,6,7) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 7,biography = 0,need_blessing = 461,attr = [{1,5232},{2,104640},{3,2616},{4,2616}],other = []};

get_companion_stage(4,6,8) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 8,biography = 0,need_blessing = 472,attr = [{1,5268},{2,105360},{3,2634},{4,2634}],other = []};

get_companion_stage(4,6,9) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 9,biography = 0,need_blessing = 484,attr = [{1,5304},{2,106080},{3,2652},{4,2652}],other = []};

get_companion_stage(4,6,10) ->
	#base_companion_stage{companion_id = 4,stage = 6,star = 10,biography = 0,need_blessing = 496,attr = [{1,5376},{2,107520},{3,2688},{4,2688}],other = []};

get_companion_stage(4,7,1) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 1,biography = 0,need_blessing = 508,attr = [{1,5412},{2,108240},{3,2706},{4,2706}],other = []};

get_companion_stage(4,7,2) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 2,biography = 0,need_blessing = 520,attr = [{1,5448},{2,108960},{3,2724},{4,2724}],other = []};

get_companion_stage(4,7,3) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 3,biography = 0,need_blessing = 532,attr = [{1,5484},{2,109680},{3,2742},{4,2742}],other = []};

get_companion_stage(4,7,4) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 4,biography = 0,need_blessing = 544,attr = [{1,5520},{2,110400},{3,2760},{4,2760}],other = []};

get_companion_stage(4,7,5) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 5,biography = 0,need_blessing = 556,attr = [{1,5556},{2,111120},{3,2778},{4,2778}],other = []};

get_companion_stage(4,7,6) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 6,biography = 0,need_blessing = 568,attr = [{1,5592},{2,111840},{3,2796},{4,2796}],other = []};

get_companion_stage(4,7,7) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 7,biography = 0,need_blessing = 581,attr = [{1,5628},{2,112560},{3,2814},{4,2814}],other = []};

get_companion_stage(4,7,8) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 8,biography = 0,need_blessing = 593,attr = [{1,5664},{2,113280},{3,2832},{4,2832}],other = []};

get_companion_stage(4,7,9) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 9,biography = 0,need_blessing = 606,attr = [{1,5700},{2,114000},{3,2850},{4,2850}],other = []};

get_companion_stage(4,7,10) ->
	#base_companion_stage{companion_id = 4,stage = 7,star = 10,biography = 0,need_blessing = 618,attr = [{1,5772},{2,115440},{3,2886},{4,2886}],other = []};

get_companion_stage(4,8,1) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 1,biography = 0,need_blessing = 631,attr = [{1,5808},{2,116160},{3,2904},{4,2904}],other = []};

get_companion_stage(4,8,2) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 2,biography = 0,need_blessing = 644,attr = [{1,5844},{2,116880},{3,2922},{4,2922}],other = []};

get_companion_stage(4,8,3) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 3,biography = 0,need_blessing = 657,attr = [{1,5880},{2,117600},{3,2940},{4,2940}],other = []};

get_companion_stage(4,8,4) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 4,biography = 0,need_blessing = 670,attr = [{1,5916},{2,118320},{3,2958},{4,2958}],other = []};

get_companion_stage(4,8,5) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 5,biography = 0,need_blessing = 683,attr = [{1,5952},{2,119040},{3,2976},{4,2976}],other = []};

get_companion_stage(4,8,6) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 6,biography = 0,need_blessing = 696,attr = [{1,5988},{2,119760},{3,2994},{4,2994}],other = []};

get_companion_stage(4,8,7) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 7,biography = 0,need_blessing = 710,attr = [{1,6024},{2,120480},{3,3012},{4,3012}],other = []};

get_companion_stage(4,8,8) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 8,biography = 0,need_blessing = 723,attr = [{1,6060},{2,121200},{3,3030},{4,3030}],other = []};

get_companion_stage(4,8,9) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 9,biography = 0,need_blessing = 737,attr = [{1,6096},{2,121920},{3,3048},{4,3048}],other = []};

get_companion_stage(4,8,10) ->
	#base_companion_stage{companion_id = 4,stage = 8,star = 10,biography = 0,need_blessing = 750,attr = [{1,6168},{2,123360},{3,3084},{4,3084}],other = []};

get_companion_stage(4,9,1) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 1,biography = 0,need_blessing = 764,attr = [{1,6204},{2,124080},{3,3102},{4,3102}],other = []};

get_companion_stage(4,9,2) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 2,biography = 0,need_blessing = 777,attr = [{1,6240},{2,124800},{3,3120},{4,3120}],other = []};

get_companion_stage(4,9,3) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 3,biography = 0,need_blessing = 791,attr = [{1,6276},{2,125520},{3,3138},{4,3138}],other = []};

get_companion_stage(4,9,4) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 4,biography = 0,need_blessing = 805,attr = [{1,6312},{2,126240},{3,3156},{4,3156}],other = []};

get_companion_stage(4,9,5) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 5,biography = 0,need_blessing = 819,attr = [{1,6348},{2,126960},{3,3174},{4,3174}],other = []};

get_companion_stage(4,9,6) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 6,biography = 0,need_blessing = 833,attr = [{1,6384},{2,127680},{3,3192},{4,3192}],other = []};

get_companion_stage(4,9,7) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 7,biography = 0,need_blessing = 847,attr = [{1,6420},{2,128400},{3,3210},{4,3210}],other = []};

get_companion_stage(4,9,8) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 8,biography = 0,need_blessing = 861,attr = [{1,6456},{2,129120},{3,3228},{4,3228}],other = []};

get_companion_stage(4,9,9) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 9,biography = 0,need_blessing = 876,attr = [{1,6492},{2,129840},{3,3246},{4,3246}],other = []};

get_companion_stage(4,9,10) ->
	#base_companion_stage{companion_id = 4,stage = 9,star = 10,biography = 0,need_blessing = 890,attr = [{1,6564},{2,131280},{3,3282},{4,3282}],other = []};

get_companion_stage(4,10,1) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 1,biography = 0,need_blessing = 904,attr = [{1,6600},{2,132000},{3,3300},{4,3300}],other = []};

get_companion_stage(4,10,2) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 2,biography = 0,need_blessing = 919,attr = [{1,6636},{2,132720},{3,3318},{4,3318}],other = []};

get_companion_stage(4,10,3) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 3,biography = 0,need_blessing = 933,attr = [{1,6672},{2,133440},{3,3336},{4,3336}],other = []};

get_companion_stage(4,10,4) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 4,biography = 0,need_blessing = 948,attr = [{1,6708},{2,134160},{3,3354},{4,3354}],other = []};

get_companion_stage(4,10,5) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 5,biography = 0,need_blessing = 963,attr = [{1,6744},{2,134880},{3,3372},{4,3372}],other = []};

get_companion_stage(4,10,6) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 6,biography = 0,need_blessing = 978,attr = [{1,6780},{2,135600},{3,3390},{4,3390}],other = []};

get_companion_stage(4,10,7) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 7,biography = 0,need_blessing = 993,attr = [{1,6816},{2,136320},{3,3408},{4,3408}],other = []};

get_companion_stage(4,10,8) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 8,biography = 0,need_blessing = 1008,attr = [{1,6852},{2,137040},{3,3426},{4,3426}],other = []};

get_companion_stage(4,10,9) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 9,biography = 0,need_blessing = 1023,attr = [{1,6888},{2,137760},{3,3444},{4,3444}],other = []};

get_companion_stage(4,10,10) ->
	#base_companion_stage{companion_id = 4,stage = 10,star = 10,biography = 0,need_blessing = 1038,attr = [{1,6960},{2,139200},{3,3480},{4,3480}],other = []};

get_companion_stage(4,11,1) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 1,biography = 0,need_blessing = 1053,attr = [{1,6996},{2,139920},{3,3498},{4,3498}],other = []};

get_companion_stage(4,11,2) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 2,biography = 0,need_blessing = 1068,attr = [{1,7032},{2,140640},{3,3516},{4,3516}],other = []};

get_companion_stage(4,11,3) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 3,biography = 0,need_blessing = 1083,attr = [{1,7068},{2,141360},{3,3534},{4,3534}],other = []};

get_companion_stage(4,11,4) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 4,biography = 0,need_blessing = 1099,attr = [{1,7104},{2,142080},{3,3552},{4,3552}],other = []};

get_companion_stage(4,11,5) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 5,biography = 0,need_blessing = 1114,attr = [{1,7140},{2,142800},{3,3570},{4,3570}],other = []};

get_companion_stage(4,11,6) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 6,biography = 0,need_blessing = 1130,attr = [{1,7176},{2,143520},{3,3588},{4,3588}],other = []};

get_companion_stage(4,11,7) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 7,biography = 0,need_blessing = 1145,attr = [{1,7212},{2,144240},{3,3606},{4,3606}],other = []};

get_companion_stage(4,11,8) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 8,biography = 0,need_blessing = 1161,attr = [{1,7248},{2,144960},{3,3624},{4,3624}],other = []};

get_companion_stage(4,11,9) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 9,biography = 0,need_blessing = 1177,attr = [{1,7284},{2,145680},{3,3642},{4,3642}],other = []};

get_companion_stage(4,11,10) ->
	#base_companion_stage{companion_id = 4,stage = 11,star = 10,biography = 0,need_blessing = 1193,attr = [{1,7356},{2,147120},{3,3678},{4,3678}],other = []};

get_companion_stage(4,12,1) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 1,biography = 0,need_blessing = 1209,attr = [{1,7392},{2,147840},{3,3696},{4,3696}],other = []};

get_companion_stage(4,12,2) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 2,biography = 0,need_blessing = 1225,attr = [{1,7428},{2,148560},{3,3714},{4,3714}],other = []};

get_companion_stage(4,12,3) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 3,biography = 0,need_blessing = 1241,attr = [{1,7464},{2,149280},{3,3732},{4,3732}],other = []};

get_companion_stage(4,12,4) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 4,biography = 0,need_blessing = 1257,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],other = []};

get_companion_stage(4,12,5) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 5,biography = 0,need_blessing = 1273,attr = [{1,7536},{2,150720},{3,3768},{4,3768}],other = []};

get_companion_stage(4,12,6) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 6,biography = 0,need_blessing = 1289,attr = [{1,7572},{2,151440},{3,3786},{4,3786}],other = []};

get_companion_stage(4,12,7) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 7,biography = 0,need_blessing = 1306,attr = [{1,7608},{2,152160},{3,3804},{4,3804}],other = []};

get_companion_stage(4,12,8) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 8,biography = 0,need_blessing = 1322,attr = [{1,7644},{2,152880},{3,3822},{4,3822}],other = []};

get_companion_stage(4,12,9) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 9,biography = 0,need_blessing = 1339,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],other = []};

get_companion_stage(4,12,10) ->
	#base_companion_stage{companion_id = 4,stage = 12,star = 10,biography = 0,need_blessing = 1355,attr = [{1,7752},{2,155040},{3,3876},{4,3876}],other = []};

get_companion_stage(4,13,1) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 1,biography = 0,need_blessing = 1372,attr = [{1,7788},{2,155760},{3,3894},{4,3894}],other = []};

get_companion_stage(4,13,2) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 2,biography = 0,need_blessing = 1388,attr = [{1,7824},{2,156480},{3,3912},{4,3912}],other = []};

get_companion_stage(4,13,3) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 3,biography = 0,need_blessing = 1405,attr = [{1,7860},{2,157200},{3,3930},{4,3930}],other = []};

get_companion_stage(4,13,4) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 4,biography = 0,need_blessing = 1422,attr = [{1,7896},{2,157920},{3,3948},{4,3948}],other = []};

get_companion_stage(4,13,5) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 5,biography = 0,need_blessing = 1439,attr = [{1,7932},{2,158640},{3,3966},{4,3966}],other = []};

get_companion_stage(4,13,6) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 6,biography = 0,need_blessing = 1456,attr = [{1,7968},{2,159360},{3,3984},{4,3984}],other = []};

get_companion_stage(4,13,7) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 7,biography = 0,need_blessing = 1473,attr = [{1,8004},{2,160080},{3,4002},{4,4002}],other = []};

get_companion_stage(4,13,8) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 8,biography = 0,need_blessing = 1490,attr = [{1,8040},{2,160800},{3,4020},{4,4020}],other = []};

get_companion_stage(4,13,9) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 9,biography = 0,need_blessing = 1507,attr = [{1,8076},{2,161520},{3,4038},{4,4038}],other = []};

get_companion_stage(4,13,10) ->
	#base_companion_stage{companion_id = 4,stage = 13,star = 10,biography = 0,need_blessing = 1524,attr = [{1,8148},{2,162960},{3,4074},{4,4074}],other = []};

get_companion_stage(4,14,1) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 1,biography = 0,need_blessing = 1541,attr = [{1,8184},{2,163680},{3,4092},{4,4092}],other = []};

get_companion_stage(4,14,2) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 2,biography = 0,need_blessing = 1559,attr = [{1,8220},{2,164400},{3,4110},{4,4110}],other = []};

get_companion_stage(4,14,3) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 3,biography = 0,need_blessing = 1576,attr = [{1,8256},{2,165120},{3,4128},{4,4128}],other = []};

get_companion_stage(4,14,4) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 4,biography = 0,need_blessing = 1594,attr = [{1,8292},{2,165840},{3,4146},{4,4146}],other = []};

get_companion_stage(4,14,5) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 5,biography = 0,need_blessing = 1611,attr = [{1,8328},{2,166560},{3,4164},{4,4164}],other = []};

get_companion_stage(4,14,6) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 6,biography = 0,need_blessing = 1629,attr = [{1,8364},{2,167280},{3,4182},{4,4182}],other = []};

get_companion_stage(4,14,7) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 7,biography = 0,need_blessing = 1646,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(4,14,8) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 8,biography = 0,need_blessing = 1664,attr = [{1,8436},{2,168720},{3,4218},{4,4218}],other = []};

get_companion_stage(4,14,9) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 9,biography = 0,need_blessing = 1682,attr = [{1,8472},{2,169440},{3,4236},{4,4236}],other = []};

get_companion_stage(4,14,10) ->
	#base_companion_stage{companion_id = 4,stage = 14,star = 10,biography = 0,need_blessing = 1700,attr = [{1,8544},{2,170880},{3,4272},{4,4272}],other = []};

get_companion_stage(4,15,1) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 1,biography = 0,need_blessing = 1718,attr = [{1,8580},{2,171600},{3,4290},{4,4290}],other = []};

get_companion_stage(4,15,2) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 2,biography = 0,need_blessing = 1736,attr = [{1,8616},{2,172320},{3,4308},{4,4308}],other = []};

get_companion_stage(4,15,3) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 3,biography = 0,need_blessing = 1754,attr = [{1,8652},{2,173040},{3,4326},{4,4326}],other = []};

get_companion_stage(4,15,4) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 4,biography = 0,need_blessing = 1772,attr = [{1,8688},{2,173760},{3,4344},{4,4344}],other = []};

get_companion_stage(4,15,5) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 5,biography = 0,need_blessing = 1790,attr = [{1,8724},{2,174480},{3,4362},{4,4362}],other = []};

get_companion_stage(4,15,6) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 6,biography = 0,need_blessing = 1808,attr = [{1,8760},{2,175200},{3,4380},{4,4380}],other = []};

get_companion_stage(4,15,7) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 7,biography = 0,need_blessing = 1826,attr = [{1,8796},{2,175920},{3,4398},{4,4398}],other = []};

get_companion_stage(4,15,8) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 8,biography = 0,need_blessing = 1845,attr = [{1,8832},{2,176640},{3,4416},{4,4416}],other = []};

get_companion_stage(4,15,9) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 9,biography = 0,need_blessing = 1863,attr = [{1,8868},{2,177360},{3,4434},{4,4434}],other = []};

get_companion_stage(4,15,10) ->
	#base_companion_stage{companion_id = 4,stage = 15,star = 10,biography = 0,need_blessing = 1881,attr = [{1,8940},{2,178800},{3,4470},{4,4470}],other = []};

get_companion_stage(4,16,1) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 1,biography = 0,need_blessing = 1900,attr = [{1,8976},{2,179520},{3,4488},{4,4488}],other = []};

get_companion_stage(4,16,2) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 2,biography = 0,need_blessing = 1919,attr = [{1,9012},{2,180240},{3,4506},{4,4506}],other = []};

get_companion_stage(4,16,3) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 3,biography = 0,need_blessing = 1937,attr = [{1,9048},{2,180960},{3,4524},{4,4524}],other = []};

get_companion_stage(4,16,4) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 4,biography = 0,need_blessing = 1956,attr = [{1,9084},{2,181680},{3,4542},{4,4542}],other = []};

get_companion_stage(4,16,5) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 5,biography = 0,need_blessing = 1975,attr = [{1,9120},{2,182400},{3,4560},{4,4560}],other = []};

get_companion_stage(4,16,6) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 6,biography = 0,need_blessing = 1994,attr = [{1,9156},{2,183120},{3,4578},{4,4578}],other = []};

get_companion_stage(4,16,7) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 7,biography = 0,need_blessing = 2012,attr = [{1,9192},{2,183840},{3,4596},{4,4596}],other = []};

get_companion_stage(4,16,8) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 8,biography = 0,need_blessing = 2031,attr = [{1,9228},{2,184560},{3,4614},{4,4614}],other = []};

get_companion_stage(4,16,9) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 9,biography = 0,need_blessing = 2050,attr = [{1,9264},{2,185280},{3,4632},{4,4632}],other = []};

get_companion_stage(4,16,10) ->
	#base_companion_stage{companion_id = 4,stage = 16,star = 10,biography = 0,need_blessing = 2069,attr = [{1,9336},{2,186720},{3,4668},{4,4668}],other = []};

get_companion_stage(4,17,1) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 1,biography = 0,need_blessing = 2089,attr = [{1,9372},{2,187440},{3,4686},{4,4686}],other = []};

get_companion_stage(4,17,2) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 2,biography = 0,need_blessing = 2108,attr = [{1,9408},{2,188160},{3,4704},{4,4704}],other = []};

get_companion_stage(4,17,3) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 3,biography = 0,need_blessing = 2127,attr = [{1,9444},{2,188880},{3,4722},{4,4722}],other = []};

get_companion_stage(4,17,4) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 4,biography = 0,need_blessing = 2146,attr = [{1,9480},{2,189600},{3,4740},{4,4740}],other = []};

get_companion_stage(4,17,5) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 5,biography = 0,need_blessing = 2166,attr = [{1,9516},{2,190320},{3,4758},{4,4758}],other = []};

get_companion_stage(4,17,6) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 6,biography = 0,need_blessing = 2185,attr = [{1,9552},{2,191040},{3,4776},{4,4776}],other = []};

get_companion_stage(4,17,7) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 7,biography = 0,need_blessing = 2205,attr = [{1,9588},{2,191760},{3,4794},{4,4794}],other = []};

get_companion_stage(4,17,8) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 8,biography = 0,need_blessing = 2224,attr = [{1,9624},{2,192480},{3,4812},{4,4812}],other = []};

get_companion_stage(4,17,9) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 9,biography = 0,need_blessing = 2244,attr = [{1,9660},{2,193200},{3,4830},{4,4830}],other = []};

get_companion_stage(4,17,10) ->
	#base_companion_stage{companion_id = 4,stage = 17,star = 10,biography = 0,need_blessing = 2263,attr = [{1,9732},{2,194640},{3,4866},{4,4866}],other = []};

get_companion_stage(4,18,1) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 1,biography = 0,need_blessing = 2283,attr = [{1,9768},{2,195360},{3,4884},{4,4884}],other = []};

get_companion_stage(4,18,2) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 2,biography = 0,need_blessing = 2303,attr = [{1,9804},{2,196080},{3,4902},{4,4902}],other = []};

get_companion_stage(4,18,3) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 3,biography = 0,need_blessing = 2323,attr = [{1,9840},{2,196800},{3,4920},{4,4920}],other = []};

get_companion_stage(4,18,4) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 4,biography = 0,need_blessing = 2342,attr = [{1,9876},{2,197520},{3,4938},{4,4938}],other = []};

get_companion_stage(4,18,5) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 5,biography = 0,need_blessing = 2362,attr = [{1,9912},{2,198240},{3,4956},{4,4956}],other = []};

get_companion_stage(4,18,6) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 6,biography = 0,need_blessing = 2382,attr = [{1,9948},{2,198960},{3,4974},{4,4974}],other = []};

get_companion_stage(4,18,7) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 7,biography = 0,need_blessing = 2402,attr = [{1,9984},{2,199680},{3,4992},{4,4992}],other = []};

get_companion_stage(4,18,8) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 8,biography = 0,need_blessing = 2422,attr = [{1,10020},{2,200400},{3,5010},{4,5010}],other = []};

get_companion_stage(4,18,9) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 9,biography = 0,need_blessing = 2443,attr = [{1,10056},{2,201120},{3,5028},{4,5028}],other = []};

get_companion_stage(4,18,10) ->
	#base_companion_stage{companion_id = 4,stage = 18,star = 10,biography = 0,need_blessing = 2463,attr = [{1,10128},{2,202560},{3,5064},{4,5064}],other = []};

get_companion_stage(4,19,1) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 1,biography = 0,need_blessing = 2483,attr = [{1,10164},{2,203280},{3,5082},{4,5082}],other = []};

get_companion_stage(4,19,2) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 2,biography = 0,need_blessing = 2503,attr = [{1,10200},{2,204000},{3,5100},{4,5100}],other = []};

get_companion_stage(4,19,3) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 3,biography = 0,need_blessing = 2524,attr = [{1,10236},{2,204720},{3,5118},{4,5118}],other = []};

get_companion_stage(4,19,4) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 4,biography = 0,need_blessing = 2544,attr = [{1,10272},{2,205440},{3,5136},{4,5136}],other = []};

get_companion_stage(4,19,5) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 5,biography = 0,need_blessing = 2565,attr = [{1,10308},{2,206160},{3,5154},{4,5154}],other = []};

get_companion_stage(4,19,6) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 6,biography = 0,need_blessing = 2585,attr = [{1,10344},{2,206880},{3,5172},{4,5172}],other = []};

get_companion_stage(4,19,7) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 7,biography = 0,need_blessing = 2606,attr = [{1,10380},{2,207600},{3,5190},{4,5190}],other = []};

get_companion_stage(4,19,8) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 8,biography = 0,need_blessing = 2626,attr = [{1,10416},{2,208320},{3,5208},{4,5208}],other = []};

get_companion_stage(4,19,9) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 9,biography = 0,need_blessing = 2647,attr = [{1,10452},{2,209040},{3,5226},{4,5226}],other = []};

get_companion_stage(4,19,10) ->
	#base_companion_stage{companion_id = 4,stage = 19,star = 10,biography = 0,need_blessing = 2668,attr = [{1,10524},{2,210480},{3,5262},{4,5262}],other = []};

get_companion_stage(4,20,1) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 1,biography = 0,need_blessing = 2689,attr = [{1,10560},{2,211200},{3,5280},{4,5280}],other = []};

get_companion_stage(4,20,2) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 2,biography = 0,need_blessing = 2710,attr = [{1,10596},{2,211920},{3,5298},{4,5298}],other = []};

get_companion_stage(4,20,3) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 3,biography = 0,need_blessing = 2731,attr = [{1,10632},{2,212640},{3,5316},{4,5316}],other = []};

get_companion_stage(4,20,4) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 4,biography = 0,need_blessing = 2752,attr = [{1,10668},{2,213360},{3,5334},{4,5334}],other = []};

get_companion_stage(4,20,5) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 5,biography = 0,need_blessing = 2773,attr = [{1,10704},{2,214080},{3,5352},{4,5352}],other = []};

get_companion_stage(4,20,6) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 6,biography = 0,need_blessing = 2794,attr = [{1,10740},{2,214800},{3,5370},{4,5370}],other = []};

get_companion_stage(4,20,7) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 7,biography = 0,need_blessing = 2815,attr = [{1,10776},{2,215520},{3,5388},{4,5388}],other = []};

get_companion_stage(4,20,8) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 8,biography = 0,need_blessing = 2836,attr = [{1,10812},{2,216240},{3,5406},{4,5406}],other = []};

get_companion_stage(4,20,9) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 9,biography = 0,need_blessing = 2857,attr = [{1,10848},{2,216960},{3,5424},{4,5424}],other = []};

get_companion_stage(4,20,10) ->
	#base_companion_stage{companion_id = 4,stage = 20,star = 10,biography = 0,need_blessing = 2878,attr = [{1,10920},{2,218400},{3,5460},{4,5460}],other = []};

get_companion_stage(4,21,1) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 1,biography = 0,need_blessing = 2900,attr = [{1,10956},{2,219120},{3,5478},{4,5478}],other = []};

get_companion_stage(4,21,2) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 2,biography = 0,need_blessing = 2921,attr = [{1,10992},{2,219840},{3,5496},{4,5496}],other = []};

get_companion_stage(4,21,3) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 3,biography = 0,need_blessing = 2943,attr = [{1,11028},{2,220560},{3,5514},{4,5514}],other = []};

get_companion_stage(4,21,4) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 4,biography = 0,need_blessing = 2964,attr = [{1,11064},{2,221280},{3,5532},{4,5532}],other = []};

get_companion_stage(4,21,5) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 5,biography = 0,need_blessing = 2986,attr = [{1,11100},{2,222000},{3,5550},{4,5550}],other = []};

get_companion_stage(4,21,6) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 6,biography = 0,need_blessing = 3007,attr = [{1,11136},{2,222720},{3,5568},{4,5568}],other = []};

get_companion_stage(4,21,7) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 7,biography = 0,need_blessing = 3029,attr = [{1,11172},{2,223440},{3,5586},{4,5586}],other = []};

get_companion_stage(4,21,8) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 8,biography = 0,need_blessing = 3051,attr = [{1,11208},{2,224160},{3,5604},{4,5604}],other = []};

get_companion_stage(4,21,9) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 9,biography = 0,need_blessing = 3072,attr = [{1,11244},{2,224880},{3,5622},{4,5622}],other = []};

get_companion_stage(4,21,10) ->
	#base_companion_stage{companion_id = 4,stage = 21,star = 10,biography = 0,need_blessing = 3094,attr = [{1,11316},{2,226320},{3,5658},{4,5658}],other = []};

get_companion_stage(4,22,1) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 1,biography = 0,need_blessing = 3116,attr = [{1,11352},{2,227040},{3,5676},{4,5676}],other = []};

get_companion_stage(4,22,2) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 2,biography = 0,need_blessing = 3138,attr = [{1,11388},{2,227760},{3,5694},{4,5694}],other = []};

get_companion_stage(4,22,3) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 3,biography = 0,need_blessing = 3160,attr = [{1,11424},{2,228480},{3,5712},{4,5712}],other = []};

get_companion_stage(4,22,4) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 4,biography = 0,need_blessing = 3182,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(4,22,5) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 5,biography = 0,need_blessing = 3204,attr = [{1,11496},{2,229920},{3,5748},{4,5748}],other = []};

get_companion_stage(4,22,6) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 6,biography = 0,need_blessing = 3226,attr = [{1,11532},{2,230640},{3,5766},{4,5766}],other = []};

get_companion_stage(4,22,7) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 7,biography = 0,need_blessing = 3248,attr = [{1,11568},{2,231360},{3,5784},{4,5784}],other = []};

get_companion_stage(4,22,8) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 8,biography = 0,need_blessing = 3271,attr = [{1,11604},{2,232080},{3,5802},{4,5802}],other = []};

get_companion_stage(4,22,9) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 9,biography = 0,need_blessing = 3293,attr = [{1,11640},{2,232800},{3,5820},{4,5820}],other = []};

get_companion_stage(4,22,10) ->
	#base_companion_stage{companion_id = 4,stage = 22,star = 10,biography = 0,need_blessing = 3315,attr = [{1,11712},{2,234240},{3,5856},{4,5856}],other = []};

get_companion_stage(4,23,1) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 1,biography = 0,need_blessing = 3338,attr = [{1,11748},{2,234960},{3,5874},{4,5874}],other = []};

get_companion_stage(4,23,2) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 2,biography = 0,need_blessing = 3360,attr = [{1,11784},{2,235680},{3,5892},{4,5892}],other = []};

get_companion_stage(4,23,3) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 3,biography = 0,need_blessing = 3383,attr = [{1,11820},{2,236400},{3,5910},{4,5910}],other = []};

get_companion_stage(4,23,4) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 4,biography = 0,need_blessing = 3405,attr = [{1,11856},{2,237120},{3,5928},{4,5928}],other = []};

get_companion_stage(4,23,5) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 5,biography = 0,need_blessing = 3428,attr = [{1,11892},{2,237840},{3,5946},{4,5946}],other = []};

get_companion_stage(4,23,6) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 6,biography = 0,need_blessing = 3450,attr = [{1,11928},{2,238560},{3,5964},{4,5964}],other = []};

get_companion_stage(4,23,7) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 7,biography = 0,need_blessing = 3473,attr = [{1,11964},{2,239280},{3,5982},{4,5982}],other = []};

get_companion_stage(4,23,8) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 8,biography = 0,need_blessing = 3496,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],other = []};

get_companion_stage(4,23,9) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 9,biography = 0,need_blessing = 3518,attr = [{1,12036},{2,240720},{3,6018},{4,6018}],other = []};

get_companion_stage(4,23,10) ->
	#base_companion_stage{companion_id = 4,stage = 23,star = 10,biography = 0,need_blessing = 3541,attr = [{1,12108},{2,242160},{3,6054},{4,6054}],other = []};

get_companion_stage(4,24,1) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 1,biography = 0,need_blessing = 3564,attr = [{1,12144},{2,242880},{3,6072},{4,6072}],other = []};

get_companion_stage(4,24,2) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 2,biography = 0,need_blessing = 3587,attr = [{1,12180},{2,243600},{3,6090},{4,6090}],other = []};

get_companion_stage(4,24,3) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 3,biography = 0,need_blessing = 3610,attr = [{1,12216},{2,244320},{3,6108},{4,6108}],other = []};

get_companion_stage(4,24,4) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 4,biography = 0,need_blessing = 3633,attr = [{1,12252},{2,245040},{3,6126},{4,6126}],other = []};

get_companion_stage(4,24,5) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 5,biography = 0,need_blessing = 3656,attr = [{1,12288},{2,245760},{3,6144},{4,6144}],other = []};

get_companion_stage(4,24,6) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 6,biography = 0,need_blessing = 3679,attr = [{1,12324},{2,246480},{3,6162},{4,6162}],other = []};

get_companion_stage(4,24,7) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 7,biography = 0,need_blessing = 3702,attr = [{1,12360},{2,247200},{3,6180},{4,6180}],other = []};

get_companion_stage(4,24,8) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 8,biography = 0,need_blessing = 3726,attr = [{1,12396},{2,247920},{3,6198},{4,6198}],other = []};

get_companion_stage(4,24,9) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 9,biography = 0,need_blessing = 3749,attr = [{1,12432},{2,248640},{3,6216},{4,6216}],other = []};

get_companion_stage(4,24,10) ->
	#base_companion_stage{companion_id = 4,stage = 24,star = 10,biography = 0,need_blessing = 3772,attr = [{1,12504},{2,250080},{3,6252},{4,6252}],other = []};

get_companion_stage(4,25,1) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 1,biography = 0,need_blessing = 3795,attr = [{1,12540},{2,250800},{3,6270},{4,6270}],other = []};

get_companion_stage(4,25,2) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 2,biography = 0,need_blessing = 3819,attr = [{1,12576},{2,251520},{3,6288},{4,6288}],other = []};

get_companion_stage(4,25,3) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 3,biography = 0,need_blessing = 3842,attr = [{1,12612},{2,252240},{3,6306},{4,6306}],other = []};

get_companion_stage(4,25,4) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 4,biography = 0,need_blessing = 3866,attr = [{1,12648},{2,252960},{3,6324},{4,6324}],other = []};

get_companion_stage(4,25,5) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 5,biography = 0,need_blessing = 3889,attr = [{1,12684},{2,253680},{3,6342},{4,6342}],other = []};

get_companion_stage(4,25,6) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 6,biography = 0,need_blessing = 3913,attr = [{1,12720},{2,254400},{3,6360},{4,6360}],other = []};

get_companion_stage(4,25,7) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 7,biography = 0,need_blessing = 3937,attr = [{1,12756},{2,255120},{3,6378},{4,6378}],other = []};

get_companion_stage(4,25,8) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 8,biography = 0,need_blessing = 3960,attr = [{1,12792},{2,255840},{3,6396},{4,6396}],other = []};

get_companion_stage(4,25,9) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 9,biography = 0,need_blessing = 3984,attr = [{1,12828},{2,256560},{3,6414},{4,6414}],other = []};

get_companion_stage(4,25,10) ->
	#base_companion_stage{companion_id = 4,stage = 25,star = 10,biography = 0,need_blessing = 4008,attr = [{1,12900},{2,258000},{3,6450},{4,6450}],other = []};

get_companion_stage(4,26,1) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 1,biography = 0,need_blessing = 4032,attr = [{1,12936},{2,258720},{3,6468},{4,6468}],other = []};

get_companion_stage(4,26,2) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 2,biography = 0,need_blessing = 4056,attr = [{1,12972},{2,259440},{3,6486},{4,6486}],other = []};

get_companion_stage(4,26,3) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 3,biography = 0,need_blessing = 4080,attr = [{1,13008},{2,260160},{3,6504},{4,6504}],other = []};

get_companion_stage(4,26,4) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 4,biography = 0,need_blessing = 4104,attr = [{1,13044},{2,260880},{3,6522},{4,6522}],other = []};

get_companion_stage(4,26,5) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 5,biography = 0,need_blessing = 4128,attr = [{1,13080},{2,261600},{3,6540},{4,6540}],other = []};

get_companion_stage(4,26,6) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 6,biography = 0,need_blessing = 4152,attr = [{1,13116},{2,262320},{3,6558},{4,6558}],other = []};

get_companion_stage(4,26,7) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 7,biography = 0,need_blessing = 4176,attr = [{1,13152},{2,263040},{3,6576},{4,6576}],other = []};

get_companion_stage(4,26,8) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 8,biography = 0,need_blessing = 4200,attr = [{1,13188},{2,263760},{3,6594},{4,6594}],other = []};

get_companion_stage(4,26,9) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 9,biography = 0,need_blessing = 4224,attr = [{1,13224},{2,264480},{3,6612},{4,6612}],other = []};

get_companion_stage(4,26,10) ->
	#base_companion_stage{companion_id = 4,stage = 26,star = 10,biography = 0,need_blessing = 4248,attr = [{1,13296},{2,265920},{3,6648},{4,6648}],other = []};

get_companion_stage(4,27,1) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 1,biography = 0,need_blessing = 4273,attr = [{1,13332},{2,266640},{3,6666},{4,6666}],other = []};

get_companion_stage(4,27,2) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 2,biography = 0,need_blessing = 4297,attr = [{1,13368},{2,267360},{3,6684},{4,6684}],other = []};

get_companion_stage(4,27,3) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 3,biography = 0,need_blessing = 4321,attr = [{1,13404},{2,268080},{3,6702},{4,6702}],other = []};

get_companion_stage(4,27,4) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 4,biography = 0,need_blessing = 4346,attr = [{1,13440},{2,268800},{3,6720},{4,6720}],other = []};

get_companion_stage(4,27,5) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 5,biography = 0,need_blessing = 4370,attr = [{1,13476},{2,269520},{3,6738},{4,6738}],other = []};

get_companion_stage(4,27,6) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 6,biography = 0,need_blessing = 4395,attr = [{1,13512},{2,270240},{3,6756},{4,6756}],other = []};

get_companion_stage(4,27,7) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 7,biography = 0,need_blessing = 4419,attr = [{1,13548},{2,270960},{3,6774},{4,6774}],other = []};

get_companion_stage(4,27,8) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 8,biography = 0,need_blessing = 4444,attr = [{1,13584},{2,271680},{3,6792},{4,6792}],other = []};

get_companion_stage(4,27,9) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 9,biography = 0,need_blessing = 4469,attr = [{1,13620},{2,272400},{3,6810},{4,6810}],other = []};

get_companion_stage(4,27,10) ->
	#base_companion_stage{companion_id = 4,stage = 27,star = 10,biography = 0,need_blessing = 4493,attr = [{1,13692},{2,273840},{3,6846},{4,6846}],other = []};

get_companion_stage(4,28,1) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 1,biography = 0,need_blessing = 4518,attr = [{1,13728},{2,274560},{3,6864},{4,6864}],other = []};

get_companion_stage(4,28,2) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 2,biography = 0,need_blessing = 4543,attr = [{1,13764},{2,275280},{3,6882},{4,6882}],other = []};

get_companion_stage(4,28,3) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 3,biography = 0,need_blessing = 4568,attr = [{1,13800},{2,276000},{3,6900},{4,6900}],other = []};

get_companion_stage(4,28,4) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 4,biography = 0,need_blessing = 4593,attr = [{1,13836},{2,276720},{3,6918},{4,6918}],other = []};

get_companion_stage(4,28,5) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 5,biography = 0,need_blessing = 4618,attr = [{1,13872},{2,277440},{3,6936},{4,6936}],other = []};

get_companion_stage(4,28,6) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 6,biography = 0,need_blessing = 4643,attr = [{1,13908},{2,278160},{3,6954},{4,6954}],other = []};

get_companion_stage(4,28,7) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 7,biography = 0,need_blessing = 4668,attr = [{1,13944},{2,278880},{3,6972},{4,6972}],other = []};

get_companion_stage(4,28,8) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 8,biography = 0,need_blessing = 4693,attr = [{1,13980},{2,279600},{3,6990},{4,6990}],other = []};

get_companion_stage(4,28,9) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 9,biography = 0,need_blessing = 4718,attr = [{1,14016},{2,280320},{3,7008},{4,7008}],other = []};

get_companion_stage(4,28,10) ->
	#base_companion_stage{companion_id = 4,stage = 28,star = 10,biography = 0,need_blessing = 4743,attr = [{1,14088},{2,281760},{3,7044},{4,7044}],other = []};

get_companion_stage(4,29,1) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 1,biography = 0,need_blessing = 4768,attr = [{1,14124},{2,282480},{3,7062},{4,7062}],other = []};

get_companion_stage(4,29,2) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 2,biography = 0,need_blessing = 4794,attr = [{1,14160},{2,283200},{3,7080},{4,7080}],other = []};

get_companion_stage(4,29,3) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 3,biography = 0,need_blessing = 4819,attr = [{1,14196},{2,283920},{3,7098},{4,7098}],other = []};

get_companion_stage(4,29,4) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 4,biography = 0,need_blessing = 4844,attr = [{1,14232},{2,284640},{3,7116},{4,7116}],other = []};

get_companion_stage(4,29,5) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 5,biography = 0,need_blessing = 4870,attr = [{1,14268},{2,285360},{3,7134},{4,7134}],other = []};

get_companion_stage(4,29,6) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 6,biography = 0,need_blessing = 4895,attr = [{1,14304},{2,286080},{3,7152},{4,7152}],other = []};

get_companion_stage(4,29,7) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 7,biography = 0,need_blessing = 4921,attr = [{1,14340},{2,286800},{3,7170},{4,7170}],other = []};

get_companion_stage(4,29,8) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 8,biography = 0,need_blessing = 4946,attr = [{1,14376},{2,287520},{3,7188},{4,7188}],other = []};

get_companion_stage(4,29,9) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 9,biography = 0,need_blessing = 4972,attr = [{1,14412},{2,288240},{3,7206},{4,7206}],other = []};

get_companion_stage(4,29,10) ->
	#base_companion_stage{companion_id = 4,stage = 29,star = 10,biography = 0,need_blessing = 4997,attr = [{1,14484},{2,289680},{3,7242},{4,7242}],other = []};

get_companion_stage(4,30,1) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 1,biography = 0,need_blessing = 5023,attr = [{1,14520},{2,290400},{3,7260},{4,7260}],other = []};

get_companion_stage(4,30,2) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 2,biography = 0,need_blessing = 5049,attr = [{1,14556},{2,291120},{3,7278},{4,7278}],other = []};

get_companion_stage(4,30,3) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 3,biography = 0,need_blessing = 5074,attr = [{1,14592},{2,291840},{3,7296},{4,7296}],other = []};

get_companion_stage(4,30,4) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 4,biography = 0,need_blessing = 5100,attr = [{1,14628},{2,292560},{3,7314},{4,7314}],other = []};

get_companion_stage(4,30,5) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 5,biography = 0,need_blessing = 5126,attr = [{1,14664},{2,293280},{3,7332},{4,7332}],other = []};

get_companion_stage(4,30,6) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 6,biography = 0,need_blessing = 5152,attr = [{1,14700},{2,294000},{3,7350},{4,7350}],other = []};

get_companion_stage(4,30,7) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 7,biography = 0,need_blessing = 5178,attr = [{1,14736},{2,294720},{3,7368},{4,7368}],other = []};

get_companion_stage(4,30,8) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 8,biography = 0,need_blessing = 5204,attr = [{1,14772},{2,295440},{3,7386},{4,7386}],other = []};

get_companion_stage(4,30,9) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 9,biography = 0,need_blessing = 5230,attr = [{1,14808},{2,296160},{3,7404},{4,7404}],other = []};

get_companion_stage(4,30,10) ->
	#base_companion_stage{companion_id = 4,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,14880},{2,297600},{3,7440},{4,7440}],other = []};

get_companion_stage(5,1,0) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,4500},{2,90000},{3,2250},{4,2250}],other = []};

get_companion_stage(5,1,1) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 1,biography = 0,need_blessing = 13,attr = [{1,4540},{2,90800},{3,2270},{4,2270}],other = []};

get_companion_stage(5,1,2) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 2,biography = 0,need_blessing = 16,attr = [{1,4580},{2,91600},{3,2290},{4,2290}],other = []};

get_companion_stage(5,1,3) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 3,biography = 0,need_blessing = 19,attr = [{1,4620},{2,92400},{3,2310},{4,2310}],other = []};

get_companion_stage(5,1,4) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 4,biography = 0,need_blessing = 22,attr = [{1,4660},{2,93200},{3,2330},{4,2330}],other = []};

get_companion_stage(5,1,5) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 5,biography = 0,need_blessing = 26,attr = [{1,4700},{2,94000},{3,2350},{4,2350}],other = []};

get_companion_stage(5,1,6) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 6,biography = 0,need_blessing = 30,attr = [{1,4740},{2,94800},{3,2370},{4,2370}],other = []};

get_companion_stage(5,1,7) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 7,biography = 0,need_blessing = 35,attr = [{1,4780},{2,95600},{3,2390},{4,2390}],other = []};

get_companion_stage(5,1,8) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 8,biography = 0,need_blessing = 39,attr = [{1,4820},{2,96400},{3,2410},{4,2410}],other = []};

get_companion_stage(5,1,9) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 9,biography = 0,need_blessing = 44,attr = [{1,4860},{2,97200},{3,2430},{4,2430}],other = []};

get_companion_stage(5,1,10) ->
	#base_companion_stage{companion_id = 5,stage = 1,star = 10,biography = 1,need_blessing = 49,attr = [{1,4940},{2,98800},{3,2470},{4,2470}],other = [{biog_reward, [{2,0,100},{0, 22030005, 3},{0, 22030105, 1}]}]};

get_companion_stage(5,2,1) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 1,biography = 0,need_blessing = 54,attr = [{1,4980},{2,99600},{3,2490},{4,2490}],other = []};

get_companion_stage(5,2,2) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 2,biography = 0,need_blessing = 60,attr = [{1,5020},{2,100400},{3,2510},{4,2510}],other = []};

get_companion_stage(5,2,3) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 3,biography = 0,need_blessing = 66,attr = [{1,5060},{2,101200},{3,2530},{4,2530}],other = []};

get_companion_stage(5,2,4) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 4,biography = 0,need_blessing = 72,attr = [{1,5100},{2,102000},{3,2550},{4,2550}],other = []};

get_companion_stage(5,2,5) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 5,biography = 0,need_blessing = 78,attr = [{1,5140},{2,102800},{3,2570},{4,2570}],other = []};

get_companion_stage(5,2,6) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 6,biography = 0,need_blessing = 84,attr = [{1,5180},{2,103600},{3,2590},{4,2590}],other = []};

get_companion_stage(5,2,7) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 7,biography = 0,need_blessing = 90,attr = [{1,5220},{2,104400},{3,2610},{4,2610}],other = []};

get_companion_stage(5,2,8) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 8,biography = 0,need_blessing = 97,attr = [{1,5260},{2,105200},{3,2630},{4,2630}],other = []};

get_companion_stage(5,2,9) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 9,biography = 0,need_blessing = 104,attr = [{1,5300},{2,106000},{3,2650},{4,2650}],other = []};

get_companion_stage(5,2,10) ->
	#base_companion_stage{companion_id = 5,stage = 2,star = 10,biography = 0,need_blessing = 111,attr = [{1,5380},{2,107600},{3,2690},{4,2690}],other = []};

get_companion_stage(5,3,1) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 1,biography = 0,need_blessing = 118,attr = [{1,5420},{2,108400},{3,2710},{4,2710}],other = []};

get_companion_stage(5,3,2) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 2,biography = 0,need_blessing = 125,attr = [{1,5460},{2,109200},{3,2730},{4,2730}],other = []};

get_companion_stage(5,3,3) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 3,biography = 0,need_blessing = 133,attr = [{1,5500},{2,110000},{3,2750},{4,2750}],other = []};

get_companion_stage(5,3,4) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 4,biography = 0,need_blessing = 140,attr = [{1,5540},{2,110800},{3,2770},{4,2770}],other = []};

get_companion_stage(5,3,5) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 5,biography = 0,need_blessing = 148,attr = [{1,5580},{2,111600},{3,2790},{4,2790}],other = []};

get_companion_stage(5,3,6) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 6,biography = 0,need_blessing = 156,attr = [{1,5620},{2,112400},{3,2810},{4,2810}],other = []};

get_companion_stage(5,3,7) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 7,biography = 0,need_blessing = 164,attr = [{1,5660},{2,113200},{3,2830},{4,2830}],other = []};

get_companion_stage(5,3,8) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 8,biography = 0,need_blessing = 172,attr = [{1,5700},{2,114000},{3,2850},{4,2850}],other = []};

get_companion_stage(5,3,9) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 9,biography = 0,need_blessing = 180,attr = [{1,5740},{2,114800},{3,2870},{4,2870}],other = []};

get_companion_stage(5,3,10) ->
	#base_companion_stage{companion_id = 5,stage = 3,star = 10,biography = 2,need_blessing = 189,attr = [{1,5820},{2,116400},{3,2910},{4,2910}],other = [{biog_reward, [{2,0,200},{0, 22030005, 5},{0, 22030105, 3}]}]};

get_companion_stage(5,4,1) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 1,biography = 0,need_blessing = 197,attr = [{1,5860},{2,117200},{3,2930},{4,2930}],other = []};

get_companion_stage(5,4,2) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 2,biography = 0,need_blessing = 206,attr = [{1,5900},{2,118000},{3,2950},{4,2950}],other = []};

get_companion_stage(5,4,3) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 3,biography = 0,need_blessing = 215,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],other = []};

get_companion_stage(5,4,4) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 4,biography = 0,need_blessing = 224,attr = [{1,5980},{2,119600},{3,2990},{4,2990}],other = []};

get_companion_stage(5,4,5) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 5,biography = 0,need_blessing = 233,attr = [{1,6020},{2,120400},{3,3010},{4,3010}],other = []};

get_companion_stage(5,4,6) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 6,biography = 0,need_blessing = 242,attr = [{1,6060},{2,121200},{3,3030},{4,3030}],other = []};

get_companion_stage(5,4,7) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 7,biography = 0,need_blessing = 251,attr = [{1,6100},{2,122000},{3,3050},{4,3050}],other = []};

get_companion_stage(5,4,8) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 8,biography = 0,need_blessing = 260,attr = [{1,6140},{2,122800},{3,3070},{4,3070}],other = []};

get_companion_stage(5,4,9) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 9,biography = 0,need_blessing = 270,attr = [{1,6180},{2,123600},{3,3090},{4,3090}],other = []};

get_companion_stage(5,4,10) ->
	#base_companion_stage{companion_id = 5,stage = 4,star = 10,biography = 0,need_blessing = 280,attr = [{1,6260},{2,125200},{3,3130},{4,3130}],other = []};

get_companion_stage(5,5,1) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 1,biography = 0,need_blessing = 289,attr = [{1,6300},{2,126000},{3,3150},{4,3150}],other = []};

get_companion_stage(5,5,2) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 2,biography = 0,need_blessing = 299,attr = [{1,6340},{2,126800},{3,3170},{4,3170}],other = []};

get_companion_stage(5,5,3) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 3,biography = 0,need_blessing = 309,attr = [{1,6380},{2,127600},{3,3190},{4,3190}],other = []};

get_companion_stage(5,5,4) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 4,biography = 0,need_blessing = 319,attr = [{1,6420},{2,128400},{3,3210},{4,3210}],other = []};

get_companion_stage(5,5,5) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 5,biography = 0,need_blessing = 330,attr = [{1,6460},{2,129200},{3,3230},{4,3230}],other = []};

get_companion_stage(5,5,6) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 6,biography = 0,need_blessing = 340,attr = [{1,6500},{2,130000},{3,3250},{4,3250}],other = []};

get_companion_stage(5,5,7) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 7,biography = 0,need_blessing = 351,attr = [{1,6540},{2,130800},{3,3270},{4,3270}],other = []};

get_companion_stage(5,5,8) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 8,biography = 0,need_blessing = 361,attr = [{1,6580},{2,131600},{3,3290},{4,3290}],other = []};

get_companion_stage(5,5,9) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 9,biography = 0,need_blessing = 372,attr = [{1,6620},{2,132400},{3,3310},{4,3310}],other = []};

get_companion_stage(5,5,10) ->
	#base_companion_stage{companion_id = 5,stage = 5,star = 10,biography = 3,need_blessing = 382,attr = [{1,6700},{2,134000},{3,3350},{4,3350}],other = [{biog_reward, [{2,0,250},{0, 22030005, 10},{0, 22030105, 5}]}]};

get_companion_stage(5,6,1) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 1,biography = 0,need_blessing = 393,attr = [{1,6740},{2,134800},{3,3370},{4,3370}],other = []};

get_companion_stage(5,6,2) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 2,biography = 0,need_blessing = 404,attr = [{1,6780},{2,135600},{3,3390},{4,3390}],other = []};

get_companion_stage(5,6,3) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 3,biography = 0,need_blessing = 415,attr = [{1,6820},{2,136400},{3,3410},{4,3410}],other = []};

get_companion_stage(5,6,4) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 4,biography = 0,need_blessing = 427,attr = [{1,6860},{2,137200},{3,3430},{4,3430}],other = []};

get_companion_stage(5,6,5) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 5,biography = 0,need_blessing = 438,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],other = []};

get_companion_stage(5,6,6) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 6,biography = 0,need_blessing = 449,attr = [{1,6940},{2,138800},{3,3470},{4,3470}],other = []};

get_companion_stage(5,6,7) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 7,biography = 0,need_blessing = 461,attr = [{1,6980},{2,139600},{3,3490},{4,3490}],other = []};

get_companion_stage(5,6,8) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 8,biography = 0,need_blessing = 472,attr = [{1,7020},{2,140400},{3,3510},{4,3510}],other = []};

get_companion_stage(5,6,9) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 9,biography = 0,need_blessing = 484,attr = [{1,7060},{2,141200},{3,3530},{4,3530}],other = []};

get_companion_stage(5,6,10) ->
	#base_companion_stage{companion_id = 5,stage = 6,star = 10,biography = 0,need_blessing = 496,attr = [{1,7140},{2,142800},{3,3570},{4,3570}],other = []};

get_companion_stage(5,7,1) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 1,biography = 0,need_blessing = 508,attr = [{1,7180},{2,143600},{3,3590},{4,3590}],other = []};

get_companion_stage(5,7,2) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 2,biography = 0,need_blessing = 520,attr = [{1,7220},{2,144400},{3,3610},{4,3610}],other = []};

get_companion_stage(5,7,3) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 3,biography = 0,need_blessing = 532,attr = [{1,7260},{2,145200},{3,3630},{4,3630}],other = []};

get_companion_stage(5,7,4) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 4,biography = 0,need_blessing = 544,attr = [{1,7300},{2,146000},{3,3650},{4,3650}],other = []};

get_companion_stage(5,7,5) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 5,biography = 0,need_blessing = 556,attr = [{1,7340},{2,146800},{3,3670},{4,3670}],other = []};

get_companion_stage(5,7,6) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 6,biography = 0,need_blessing = 568,attr = [{1,7380},{2,147600},{3,3690},{4,3690}],other = []};

get_companion_stage(5,7,7) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 7,biography = 0,need_blessing = 581,attr = [{1,7420},{2,148400},{3,3710},{4,3710}],other = []};

get_companion_stage(5,7,8) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 8,biography = 0,need_blessing = 593,attr = [{1,7460},{2,149200},{3,3730},{4,3730}],other = []};

get_companion_stage(5,7,9) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 9,biography = 0,need_blessing = 606,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],other = []};

get_companion_stage(5,7,10) ->
	#base_companion_stage{companion_id = 5,stage = 7,star = 10,biography = 0,need_blessing = 618,attr = [{1,7580},{2,151600},{3,3790},{4,3790}],other = []};

get_companion_stage(5,8,1) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 1,biography = 0,need_blessing = 631,attr = [{1,7620},{2,152400},{3,3810},{4,3810}],other = []};

get_companion_stage(5,8,2) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 2,biography = 0,need_blessing = 644,attr = [{1,7660},{2,153200},{3,3830},{4,3830}],other = []};

get_companion_stage(5,8,3) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 3,biography = 0,need_blessing = 657,attr = [{1,7700},{2,154000},{3,3850},{4,3850}],other = []};

get_companion_stage(5,8,4) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 4,biography = 0,need_blessing = 670,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],other = []};

get_companion_stage(5,8,5) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 5,biography = 0,need_blessing = 683,attr = [{1,7780},{2,155600},{3,3890},{4,3890}],other = []};

get_companion_stage(5,8,6) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 6,biography = 0,need_blessing = 696,attr = [{1,7820},{2,156400},{3,3910},{4,3910}],other = []};

get_companion_stage(5,8,7) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 7,biography = 0,need_blessing = 710,attr = [{1,7860},{2,157200},{3,3930},{4,3930}],other = []};

get_companion_stage(5,8,8) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 8,biography = 0,need_blessing = 723,attr = [{1,7900},{2,158000},{3,3950},{4,3950}],other = []};

get_companion_stage(5,8,9) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 9,biography = 0,need_blessing = 737,attr = [{1,7940},{2,158800},{3,3970},{4,3970}],other = []};

get_companion_stage(5,8,10) ->
	#base_companion_stage{companion_id = 5,stage = 8,star = 10,biography = 0,need_blessing = 750,attr = [{1,8020},{2,160400},{3,4010},{4,4010}],other = []};

get_companion_stage(5,9,1) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 1,biography = 0,need_blessing = 764,attr = [{1,8060},{2,161200},{3,4030},{4,4030}],other = []};

get_companion_stage(5,9,2) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 2,biography = 0,need_blessing = 777,attr = [{1,8100},{2,162000},{3,4050},{4,4050}],other = []};

get_companion_stage(5,9,3) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 3,biography = 0,need_blessing = 791,attr = [{1,8140},{2,162800},{3,4070},{4,4070}],other = []};

get_companion_stage(5,9,4) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 4,biography = 0,need_blessing = 805,attr = [{1,8180},{2,163600},{3,4090},{4,4090}],other = []};

get_companion_stage(5,9,5) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 5,biography = 0,need_blessing = 819,attr = [{1,8220},{2,164400},{3,4110},{4,4110}],other = []};

get_companion_stage(5,9,6) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 6,biography = 0,need_blessing = 833,attr = [{1,8260},{2,165200},{3,4130},{4,4130}],other = []};

get_companion_stage(5,9,7) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 7,biography = 0,need_blessing = 847,attr = [{1,8300},{2,166000},{3,4150},{4,4150}],other = []};

get_companion_stage(5,9,8) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 8,biography = 0,need_blessing = 861,attr = [{1,8340},{2,166800},{3,4170},{4,4170}],other = []};

get_companion_stage(5,9,9) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 9,biography = 0,need_blessing = 876,attr = [{1,8380},{2,167600},{3,4190},{4,4190}],other = []};

get_companion_stage(5,9,10) ->
	#base_companion_stage{companion_id = 5,stage = 9,star = 10,biography = 0,need_blessing = 890,attr = [{1,8460},{2,169200},{3,4230},{4,4230}],other = []};

get_companion_stage(5,10,1) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 1,biography = 0,need_blessing = 904,attr = [{1,8500},{2,170000},{3,4250},{4,4250}],other = []};

get_companion_stage(5,10,2) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 2,biography = 0,need_blessing = 919,attr = [{1,8540},{2,170800},{3,4270},{4,4270}],other = []};

get_companion_stage(5,10,3) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 3,biography = 0,need_blessing = 933,attr = [{1,8580},{2,171600},{3,4290},{4,4290}],other = []};

get_companion_stage(5,10,4) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 4,biography = 0,need_blessing = 948,attr = [{1,8620},{2,172400},{3,4310},{4,4310}],other = []};

get_companion_stage(5,10,5) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 5,biography = 0,need_blessing = 963,attr = [{1,8660},{2,173200},{3,4330},{4,4330}],other = []};

get_companion_stage(5,10,6) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 6,biography = 0,need_blessing = 978,attr = [{1,8700},{2,174000},{3,4350},{4,4350}],other = []};

get_companion_stage(5,10,7) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 7,biography = 0,need_blessing = 993,attr = [{1,8740},{2,174800},{3,4370},{4,4370}],other = []};

get_companion_stage(5,10,8) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 8,biography = 0,need_blessing = 1008,attr = [{1,8780},{2,175600},{3,4390},{4,4390}],other = []};

get_companion_stage(5,10,9) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 9,biography = 0,need_blessing = 1023,attr = [{1,8820},{2,176400},{3,4410},{4,4410}],other = []};

get_companion_stage(5,10,10) ->
	#base_companion_stage{companion_id = 5,stage = 10,star = 10,biography = 0,need_blessing = 1038,attr = [{1,8900},{2,178000},{3,4450},{4,4450}],other = []};

get_companion_stage(5,11,1) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 1,biography = 0,need_blessing = 1053,attr = [{1,8940},{2,178800},{3,4470},{4,4470}],other = []};

get_companion_stage(5,11,2) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 2,biography = 0,need_blessing = 1068,attr = [{1,8980},{2,179600},{3,4490},{4,4490}],other = []};

get_companion_stage(5,11,3) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 3,biography = 0,need_blessing = 1083,attr = [{1,9020},{2,180400},{3,4510},{4,4510}],other = []};

get_companion_stage(5,11,4) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 4,biography = 0,need_blessing = 1099,attr = [{1,9060},{2,181200},{3,4530},{4,4530}],other = []};

get_companion_stage(5,11,5) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 5,biography = 0,need_blessing = 1114,attr = [{1,9100},{2,182000},{3,4550},{4,4550}],other = []};

get_companion_stage(5,11,6) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 6,biography = 0,need_blessing = 1130,attr = [{1,9140},{2,182800},{3,4570},{4,4570}],other = []};

get_companion_stage(5,11,7) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 7,biography = 0,need_blessing = 1145,attr = [{1,9180},{2,183600},{3,4590},{4,4590}],other = []};

get_companion_stage(5,11,8) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 8,biography = 0,need_blessing = 1161,attr = [{1,9220},{2,184400},{3,4610},{4,4610}],other = []};

get_companion_stage(5,11,9) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 9,biography = 0,need_blessing = 1177,attr = [{1,9260},{2,185200},{3,4630},{4,4630}],other = []};

get_companion_stage(5,11,10) ->
	#base_companion_stage{companion_id = 5,stage = 11,star = 10,biography = 0,need_blessing = 1193,attr = [{1,9340},{2,186800},{3,4670},{4,4670}],other = []};

get_companion_stage(5,12,1) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 1,biography = 0,need_blessing = 1209,attr = [{1,9380},{2,187600},{3,4690},{4,4690}],other = []};

get_companion_stage(5,12,2) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 2,biography = 0,need_blessing = 1225,attr = [{1,9420},{2,188400},{3,4710},{4,4710}],other = []};

get_companion_stage(5,12,3) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 3,biography = 0,need_blessing = 1241,attr = [{1,9460},{2,189200},{3,4730},{4,4730}],other = []};

get_companion_stage(5,12,4) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 4,biography = 0,need_blessing = 1257,attr = [{1,9500},{2,190000},{3,4750},{4,4750}],other = []};

get_companion_stage(5,12,5) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 5,biography = 0,need_blessing = 1273,attr = [{1,9540},{2,190800},{3,4770},{4,4770}],other = []};

get_companion_stage(5,12,6) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 6,biography = 0,need_blessing = 1289,attr = [{1,9580},{2,191600},{3,4790},{4,4790}],other = []};

get_companion_stage(5,12,7) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 7,biography = 0,need_blessing = 1306,attr = [{1,9620},{2,192400},{3,4810},{4,4810}],other = []};

get_companion_stage(5,12,8) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 8,biography = 0,need_blessing = 1322,attr = [{1,9660},{2,193200},{3,4830},{4,4830}],other = []};

get_companion_stage(5,12,9) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 9,biography = 0,need_blessing = 1339,attr = [{1,9700},{2,194000},{3,4850},{4,4850}],other = []};

get_companion_stage(5,12,10) ->
	#base_companion_stage{companion_id = 5,stage = 12,star = 10,biography = 0,need_blessing = 1355,attr = [{1,9780},{2,195600},{3,4890},{4,4890}],other = []};

get_companion_stage(5,13,1) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 1,biography = 0,need_blessing = 1372,attr = [{1,9820},{2,196400},{3,4910},{4,4910}],other = []};

get_companion_stage(5,13,2) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 2,biography = 0,need_blessing = 1388,attr = [{1,9860},{2,197200},{3,4930},{4,4930}],other = []};

get_companion_stage(5,13,3) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 3,biography = 0,need_blessing = 1405,attr = [{1,9900},{2,198000},{3,4950},{4,4950}],other = []};

get_companion_stage(5,13,4) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 4,biography = 0,need_blessing = 1422,attr = [{1,9940},{2,198800},{3,4970},{4,4970}],other = []};

get_companion_stage(5,13,5) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 5,biography = 0,need_blessing = 1439,attr = [{1,9980},{2,199600},{3,4990},{4,4990}],other = []};

get_companion_stage(5,13,6) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 6,biography = 0,need_blessing = 1456,attr = [{1,10020},{2,200400},{3,5010},{4,5010}],other = []};

get_companion_stage(5,13,7) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 7,biography = 0,need_blessing = 1473,attr = [{1,10060},{2,201200},{3,5030},{4,5030}],other = []};

get_companion_stage(5,13,8) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 8,biography = 0,need_blessing = 1490,attr = [{1,10100},{2,202000},{3,5050},{4,5050}],other = []};

get_companion_stage(5,13,9) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 9,biography = 0,need_blessing = 1507,attr = [{1,10140},{2,202800},{3,5070},{4,5070}],other = []};

get_companion_stage(5,13,10) ->
	#base_companion_stage{companion_id = 5,stage = 13,star = 10,biography = 0,need_blessing = 1524,attr = [{1,10220},{2,204400},{3,5110},{4,5110}],other = []};

get_companion_stage(5,14,1) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 1,biography = 0,need_blessing = 1541,attr = [{1,10260},{2,205200},{3,5130},{4,5130}],other = []};

get_companion_stage(5,14,2) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 2,biography = 0,need_blessing = 1559,attr = [{1,10300},{2,206000},{3,5150},{4,5150}],other = []};

get_companion_stage(5,14,3) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 3,biography = 0,need_blessing = 1576,attr = [{1,10340},{2,206800},{3,5170},{4,5170}],other = []};

get_companion_stage(5,14,4) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 4,biography = 0,need_blessing = 1594,attr = [{1,10380},{2,207600},{3,5190},{4,5190}],other = []};

get_companion_stage(5,14,5) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 5,biography = 0,need_blessing = 1611,attr = [{1,10420},{2,208400},{3,5210},{4,5210}],other = []};

get_companion_stage(5,14,6) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 6,biography = 0,need_blessing = 1629,attr = [{1,10460},{2,209200},{3,5230},{4,5230}],other = []};

get_companion_stage(5,14,7) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 7,biography = 0,need_blessing = 1646,attr = [{1,10500},{2,210000},{3,5250},{4,5250}],other = []};

get_companion_stage(5,14,8) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 8,biography = 0,need_blessing = 1664,attr = [{1,10540},{2,210800},{3,5270},{4,5270}],other = []};

get_companion_stage(5,14,9) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 9,biography = 0,need_blessing = 1682,attr = [{1,10580},{2,211600},{3,5290},{4,5290}],other = []};

get_companion_stage(5,14,10) ->
	#base_companion_stage{companion_id = 5,stage = 14,star = 10,biography = 0,need_blessing = 1700,attr = [{1,10660},{2,213200},{3,5330},{4,5330}],other = []};

get_companion_stage(5,15,1) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 1,biography = 0,need_blessing = 1718,attr = [{1,10700},{2,214000},{3,5350},{4,5350}],other = []};

get_companion_stage(5,15,2) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 2,biography = 0,need_blessing = 1736,attr = [{1,10740},{2,214800},{3,5370},{4,5370}],other = []};

get_companion_stage(5,15,3) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 3,biography = 0,need_blessing = 1754,attr = [{1,10780},{2,215600},{3,5390},{4,5390}],other = []};

get_companion_stage(5,15,4) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 4,biography = 0,need_blessing = 1772,attr = [{1,10820},{2,216400},{3,5410},{4,5410}],other = []};

get_companion_stage(5,15,5) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 5,biography = 0,need_blessing = 1790,attr = [{1,10860},{2,217200},{3,5430},{4,5430}],other = []};

get_companion_stage(5,15,6) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 6,biography = 0,need_blessing = 1808,attr = [{1,10900},{2,218000},{3,5450},{4,5450}],other = []};

get_companion_stage(5,15,7) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 7,biography = 0,need_blessing = 1826,attr = [{1,10940},{2,218800},{3,5470},{4,5470}],other = []};

get_companion_stage(5,15,8) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 8,biography = 0,need_blessing = 1845,attr = [{1,10980},{2,219600},{3,5490},{4,5490}],other = []};

get_companion_stage(5,15,9) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 9,biography = 0,need_blessing = 1863,attr = [{1,11020},{2,220400},{3,5510},{4,5510}],other = []};

get_companion_stage(5,15,10) ->
	#base_companion_stage{companion_id = 5,stage = 15,star = 10,biography = 0,need_blessing = 1881,attr = [{1,11100},{2,222000},{3,5550},{4,5550}],other = []};

get_companion_stage(5,16,1) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 1,biography = 0,need_blessing = 1900,attr = [{1,11140},{2,222800},{3,5570},{4,5570}],other = []};

get_companion_stage(5,16,2) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 2,biography = 0,need_blessing = 1919,attr = [{1,11180},{2,223600},{3,5590},{4,5590}],other = []};

get_companion_stage(5,16,3) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 3,biography = 0,need_blessing = 1937,attr = [{1,11220},{2,224400},{3,5610},{4,5610}],other = []};

get_companion_stage(5,16,4) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 4,biography = 0,need_blessing = 1956,attr = [{1,11260},{2,225200},{3,5630},{4,5630}],other = []};

get_companion_stage(5,16,5) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 5,biography = 0,need_blessing = 1975,attr = [{1,11300},{2,226000},{3,5650},{4,5650}],other = []};

get_companion_stage(5,16,6) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 6,biography = 0,need_blessing = 1994,attr = [{1,11340},{2,226800},{3,5670},{4,5670}],other = []};

get_companion_stage(5,16,7) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 7,biography = 0,need_blessing = 2012,attr = [{1,11380},{2,227600},{3,5690},{4,5690}],other = []};

get_companion_stage(5,16,8) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 8,biography = 0,need_blessing = 2031,attr = [{1,11420},{2,228400},{3,5710},{4,5710}],other = []};

get_companion_stage(5,16,9) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 9,biography = 0,need_blessing = 2050,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(5,16,10) ->
	#base_companion_stage{companion_id = 5,stage = 16,star = 10,biography = 0,need_blessing = 2069,attr = [{1,11540},{2,230800},{3,5770},{4,5770}],other = []};

get_companion_stage(5,17,1) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 1,biography = 0,need_blessing = 2089,attr = [{1,11580},{2,231600},{3,5790},{4,5790}],other = []};

get_companion_stage(5,17,2) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 2,biography = 0,need_blessing = 2108,attr = [{1,11620},{2,232400},{3,5810},{4,5810}],other = []};

get_companion_stage(5,17,3) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 3,biography = 0,need_blessing = 2127,attr = [{1,11660},{2,233200},{3,5830},{4,5830}],other = []};

get_companion_stage(5,17,4) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 4,biography = 0,need_blessing = 2146,attr = [{1,11700},{2,234000},{3,5850},{4,5850}],other = []};

get_companion_stage(5,17,5) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 5,biography = 0,need_blessing = 2166,attr = [{1,11740},{2,234800},{3,5870},{4,5870}],other = []};

get_companion_stage(5,17,6) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 6,biography = 0,need_blessing = 2185,attr = [{1,11780},{2,235600},{3,5890},{4,5890}],other = []};

get_companion_stage(5,17,7) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 7,biography = 0,need_blessing = 2205,attr = [{1,11820},{2,236400},{3,5910},{4,5910}],other = []};

get_companion_stage(5,17,8) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 8,biography = 0,need_blessing = 2224,attr = [{1,11860},{2,237200},{3,5930},{4,5930}],other = []};

get_companion_stage(5,17,9) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 9,biography = 0,need_blessing = 2244,attr = [{1,11900},{2,238000},{3,5950},{4,5950}],other = []};

get_companion_stage(5,17,10) ->
	#base_companion_stage{companion_id = 5,stage = 17,star = 10,biography = 0,need_blessing = 2263,attr = [{1,11980},{2,239600},{3,5990},{4,5990}],other = []};

get_companion_stage(5,18,1) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 1,biography = 0,need_blessing = 2283,attr = [{1,12020},{2,240400},{3,6010},{4,6010}],other = []};

get_companion_stage(5,18,2) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 2,biography = 0,need_blessing = 2303,attr = [{1,12060},{2,241200},{3,6030},{4,6030}],other = []};

get_companion_stage(5,18,3) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 3,biography = 0,need_blessing = 2323,attr = [{1,12100},{2,242000},{3,6050},{4,6050}],other = []};

get_companion_stage(5,18,4) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 4,biography = 0,need_blessing = 2342,attr = [{1,12140},{2,242800},{3,6070},{4,6070}],other = []};

get_companion_stage(5,18,5) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 5,biography = 0,need_blessing = 2362,attr = [{1,12180},{2,243600},{3,6090},{4,6090}],other = []};

get_companion_stage(5,18,6) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 6,biography = 0,need_blessing = 2382,attr = [{1,12220},{2,244400},{3,6110},{4,6110}],other = []};

get_companion_stage(5,18,7) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 7,biography = 0,need_blessing = 2402,attr = [{1,12260},{2,245200},{3,6130},{4,6130}],other = []};

get_companion_stage(5,18,8) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 8,biography = 0,need_blessing = 2422,attr = [{1,12300},{2,246000},{3,6150},{4,6150}],other = []};

get_companion_stage(5,18,9) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 9,biography = 0,need_blessing = 2443,attr = [{1,12340},{2,246800},{3,6170},{4,6170}],other = []};

get_companion_stage(5,18,10) ->
	#base_companion_stage{companion_id = 5,stage = 18,star = 10,biography = 0,need_blessing = 2463,attr = [{1,12420},{2,248400},{3,6210},{4,6210}],other = []};

get_companion_stage(5,19,1) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 1,biography = 0,need_blessing = 2483,attr = [{1,12460},{2,249200},{3,6230},{4,6230}],other = []};

get_companion_stage(5,19,2) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 2,biography = 0,need_blessing = 2503,attr = [{1,12500},{2,250000},{3,6250},{4,6250}],other = []};

get_companion_stage(5,19,3) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 3,biography = 0,need_blessing = 2524,attr = [{1,12540},{2,250800},{3,6270},{4,6270}],other = []};

get_companion_stage(5,19,4) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 4,biography = 0,need_blessing = 2544,attr = [{1,12580},{2,251600},{3,6290},{4,6290}],other = []};

get_companion_stage(5,19,5) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 5,biography = 0,need_blessing = 2565,attr = [{1,12620},{2,252400},{3,6310},{4,6310}],other = []};

get_companion_stage(5,19,6) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 6,biography = 0,need_blessing = 2585,attr = [{1,12660},{2,253200},{3,6330},{4,6330}],other = []};

get_companion_stage(5,19,7) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 7,biography = 0,need_blessing = 2606,attr = [{1,12700},{2,254000},{3,6350},{4,6350}],other = []};

get_companion_stage(5,19,8) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 8,biography = 0,need_blessing = 2626,attr = [{1,12740},{2,254800},{3,6370},{4,6370}],other = []};

get_companion_stage(5,19,9) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 9,biography = 0,need_blessing = 2647,attr = [{1,12780},{2,255600},{3,6390},{4,6390}],other = []};

get_companion_stage(5,19,10) ->
	#base_companion_stage{companion_id = 5,stage = 19,star = 10,biography = 0,need_blessing = 2668,attr = [{1,12860},{2,257200},{3,6430},{4,6430}],other = []};

get_companion_stage(5,20,1) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 1,biography = 0,need_blessing = 2689,attr = [{1,12900},{2,258000},{3,6450},{4,6450}],other = []};

get_companion_stage(5,20,2) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 2,biography = 0,need_blessing = 2710,attr = [{1,12940},{2,258800},{3,6470},{4,6470}],other = []};

get_companion_stage(5,20,3) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 3,biography = 0,need_blessing = 2731,attr = [{1,12980},{2,259600},{3,6490},{4,6490}],other = []};

get_companion_stage(5,20,4) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 4,biography = 0,need_blessing = 2752,attr = [{1,13020},{2,260400},{3,6510},{4,6510}],other = []};

get_companion_stage(5,20,5) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 5,biography = 0,need_blessing = 2773,attr = [{1,13060},{2,261200},{3,6530},{4,6530}],other = []};

get_companion_stage(5,20,6) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 6,biography = 0,need_blessing = 2794,attr = [{1,13100},{2,262000},{3,6550},{4,6550}],other = []};

get_companion_stage(5,20,7) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 7,biography = 0,need_blessing = 2815,attr = [{1,13140},{2,262800},{3,6570},{4,6570}],other = []};

get_companion_stage(5,20,8) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 8,biography = 0,need_blessing = 2836,attr = [{1,13180},{2,263600},{3,6590},{4,6590}],other = []};

get_companion_stage(5,20,9) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 9,biography = 0,need_blessing = 2857,attr = [{1,13220},{2,264400},{3,6610},{4,6610}],other = []};

get_companion_stage(5,20,10) ->
	#base_companion_stage{companion_id = 5,stage = 20,star = 10,biography = 0,need_blessing = 2878,attr = [{1,13300},{2,266000},{3,6650},{4,6650}],other = []};

get_companion_stage(5,21,1) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 1,biography = 0,need_blessing = 2900,attr = [{1,13340},{2,266800},{3,6670},{4,6670}],other = []};

get_companion_stage(5,21,2) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 2,biography = 0,need_blessing = 2921,attr = [{1,13380},{2,267600},{3,6690},{4,6690}],other = []};

get_companion_stage(5,21,3) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 3,biography = 0,need_blessing = 2943,attr = [{1,13420},{2,268400},{3,6710},{4,6710}],other = []};

get_companion_stage(5,21,4) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 4,biography = 0,need_blessing = 2964,attr = [{1,13460},{2,269200},{3,6730},{4,6730}],other = []};

get_companion_stage(5,21,5) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 5,biography = 0,need_blessing = 2986,attr = [{1,13500},{2,270000},{3,6750},{4,6750}],other = []};

get_companion_stage(5,21,6) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 6,biography = 0,need_blessing = 3007,attr = [{1,13540},{2,270800},{3,6770},{4,6770}],other = []};

get_companion_stage(5,21,7) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 7,biography = 0,need_blessing = 3029,attr = [{1,13580},{2,271600},{3,6790},{4,6790}],other = []};

get_companion_stage(5,21,8) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 8,biography = 0,need_blessing = 3051,attr = [{1,13620},{2,272400},{3,6810},{4,6810}],other = []};

get_companion_stage(5,21,9) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 9,biography = 0,need_blessing = 3072,attr = [{1,13660},{2,273200},{3,6830},{4,6830}],other = []};

get_companion_stage(5,21,10) ->
	#base_companion_stage{companion_id = 5,stage = 21,star = 10,biography = 0,need_blessing = 3094,attr = [{1,13740},{2,274800},{3,6870},{4,6870}],other = []};

get_companion_stage(5,22,1) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 1,biography = 0,need_blessing = 3116,attr = [{1,13780},{2,275600},{3,6890},{4,6890}],other = []};

get_companion_stage(5,22,2) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 2,biography = 0,need_blessing = 3138,attr = [{1,13820},{2,276400},{3,6910},{4,6910}],other = []};

get_companion_stage(5,22,3) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 3,biography = 0,need_blessing = 3160,attr = [{1,13860},{2,277200},{3,6930},{4,6930}],other = []};

get_companion_stage(5,22,4) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 4,biography = 0,need_blessing = 3182,attr = [{1,13900},{2,278000},{3,6950},{4,6950}],other = []};

get_companion_stage(5,22,5) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 5,biography = 0,need_blessing = 3204,attr = [{1,13940},{2,278800},{3,6970},{4,6970}],other = []};

get_companion_stage(5,22,6) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 6,biography = 0,need_blessing = 3226,attr = [{1,13980},{2,279600},{3,6990},{4,6990}],other = []};

get_companion_stage(5,22,7) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 7,biography = 0,need_blessing = 3248,attr = [{1,14020},{2,280400},{3,7010},{4,7010}],other = []};

get_companion_stage(5,22,8) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 8,biography = 0,need_blessing = 3271,attr = [{1,14060},{2,281200},{3,7030},{4,7030}],other = []};

get_companion_stage(5,22,9) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 9,biography = 0,need_blessing = 3293,attr = [{1,14100},{2,282000},{3,7050},{4,7050}],other = []};

get_companion_stage(5,22,10) ->
	#base_companion_stage{companion_id = 5,stage = 22,star = 10,biography = 0,need_blessing = 3315,attr = [{1,14180},{2,283600},{3,7090},{4,7090}],other = []};

get_companion_stage(5,23,1) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 1,biography = 0,need_blessing = 3338,attr = [{1,14220},{2,284400},{3,7110},{4,7110}],other = []};

get_companion_stage(5,23,2) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 2,biography = 0,need_blessing = 3360,attr = [{1,14260},{2,285200},{3,7130},{4,7130}],other = []};

get_companion_stage(5,23,3) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 3,biography = 0,need_blessing = 3383,attr = [{1,14300},{2,286000},{3,7150},{4,7150}],other = []};

get_companion_stage(5,23,4) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 4,biography = 0,need_blessing = 3405,attr = [{1,14340},{2,286800},{3,7170},{4,7170}],other = []};

get_companion_stage(5,23,5) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 5,biography = 0,need_blessing = 3428,attr = [{1,14380},{2,287600},{3,7190},{4,7190}],other = []};

get_companion_stage(5,23,6) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 6,biography = 0,need_blessing = 3450,attr = [{1,14420},{2,288400},{3,7210},{4,7210}],other = []};

get_companion_stage(5,23,7) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 7,biography = 0,need_blessing = 3473,attr = [{1,14460},{2,289200},{3,7230},{4,7230}],other = []};

get_companion_stage(5,23,8) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 8,biography = 0,need_blessing = 3496,attr = [{1,14500},{2,290000},{3,7250},{4,7250}],other = []};

get_companion_stage(5,23,9) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 9,biography = 0,need_blessing = 3518,attr = [{1,14540},{2,290800},{3,7270},{4,7270}],other = []};

get_companion_stage(5,23,10) ->
	#base_companion_stage{companion_id = 5,stage = 23,star = 10,biography = 0,need_blessing = 3541,attr = [{1,14620},{2,292400},{3,7310},{4,7310}],other = []};

get_companion_stage(5,24,1) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 1,biography = 0,need_blessing = 3564,attr = [{1,14660},{2,293200},{3,7330},{4,7330}],other = []};

get_companion_stage(5,24,2) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 2,biography = 0,need_blessing = 3587,attr = [{1,14700},{2,294000},{3,7350},{4,7350}],other = []};

get_companion_stage(5,24,3) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 3,biography = 0,need_blessing = 3610,attr = [{1,14740},{2,294800},{3,7370},{4,7370}],other = []};

get_companion_stage(5,24,4) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 4,biography = 0,need_blessing = 3633,attr = [{1,14780},{2,295600},{3,7390},{4,7390}],other = []};

get_companion_stage(5,24,5) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 5,biography = 0,need_blessing = 3656,attr = [{1,14820},{2,296400},{3,7410},{4,7410}],other = []};

get_companion_stage(5,24,6) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 6,biography = 0,need_blessing = 3679,attr = [{1,14860},{2,297200},{3,7430},{4,7430}],other = []};

get_companion_stage(5,24,7) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 7,biography = 0,need_blessing = 3702,attr = [{1,14900},{2,298000},{3,7450},{4,7450}],other = []};

get_companion_stage(5,24,8) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 8,biography = 0,need_blessing = 3726,attr = [{1,14940},{2,298800},{3,7470},{4,7470}],other = []};

get_companion_stage(5,24,9) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 9,biography = 0,need_blessing = 3749,attr = [{1,14980},{2,299600},{3,7490},{4,7490}],other = []};

get_companion_stage(5,24,10) ->
	#base_companion_stage{companion_id = 5,stage = 24,star = 10,biography = 0,need_blessing = 3772,attr = [{1,15060},{2,301200},{3,7530},{4,7530}],other = []};

get_companion_stage(5,25,1) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 1,biography = 0,need_blessing = 3795,attr = [{1,15100},{2,302000},{3,7550},{4,7550}],other = []};

get_companion_stage(5,25,2) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 2,biography = 0,need_blessing = 3819,attr = [{1,15140},{2,302800},{3,7570},{4,7570}],other = []};

get_companion_stage(5,25,3) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 3,biography = 0,need_blessing = 3842,attr = [{1,15180},{2,303600},{3,7590},{4,7590}],other = []};

get_companion_stage(5,25,4) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 4,biography = 0,need_blessing = 3866,attr = [{1,15220},{2,304400},{3,7610},{4,7610}],other = []};

get_companion_stage(5,25,5) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 5,biography = 0,need_blessing = 3889,attr = [{1,15260},{2,305200},{3,7630},{4,7630}],other = []};

get_companion_stage(5,25,6) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 6,biography = 0,need_blessing = 3913,attr = [{1,15300},{2,306000},{3,7650},{4,7650}],other = []};

get_companion_stage(5,25,7) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 7,biography = 0,need_blessing = 3937,attr = [{1,15340},{2,306800},{3,7670},{4,7670}],other = []};

get_companion_stage(5,25,8) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 8,biography = 0,need_blessing = 3960,attr = [{1,15380},{2,307600},{3,7690},{4,7690}],other = []};

get_companion_stage(5,25,9) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 9,biography = 0,need_blessing = 3984,attr = [{1,15420},{2,308400},{3,7710},{4,7710}],other = []};

get_companion_stage(5,25,10) ->
	#base_companion_stage{companion_id = 5,stage = 25,star = 10,biography = 0,need_blessing = 4008,attr = [{1,15500},{2,310000},{3,7750},{4,7750}],other = []};

get_companion_stage(5,26,1) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 1,biography = 0,need_blessing = 4032,attr = [{1,15540},{2,310800},{3,7770},{4,7770}],other = []};

get_companion_stage(5,26,2) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 2,biography = 0,need_blessing = 4056,attr = [{1,15580},{2,311600},{3,7790},{4,7790}],other = []};

get_companion_stage(5,26,3) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 3,biography = 0,need_blessing = 4080,attr = [{1,15620},{2,312400},{3,7810},{4,7810}],other = []};

get_companion_stage(5,26,4) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 4,biography = 0,need_blessing = 4104,attr = [{1,15660},{2,313200},{3,7830},{4,7830}],other = []};

get_companion_stage(5,26,5) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 5,biography = 0,need_blessing = 4128,attr = [{1,15700},{2,314000},{3,7850},{4,7850}],other = []};

get_companion_stage(5,26,6) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 6,biography = 0,need_blessing = 4152,attr = [{1,15740},{2,314800},{3,7870},{4,7870}],other = []};

get_companion_stage(5,26,7) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 7,biography = 0,need_blessing = 4176,attr = [{1,15780},{2,315600},{3,7890},{4,7890}],other = []};

get_companion_stage(5,26,8) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 8,biography = 0,need_blessing = 4200,attr = [{1,15820},{2,316400},{3,7910},{4,7910}],other = []};

get_companion_stage(5,26,9) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 9,biography = 0,need_blessing = 4224,attr = [{1,15860},{2,317200},{3,7930},{4,7930}],other = []};

get_companion_stage(5,26,10) ->
	#base_companion_stage{companion_id = 5,stage = 26,star = 10,biography = 0,need_blessing = 4248,attr = [{1,15940},{2,318800},{3,7970},{4,7970}],other = []};

get_companion_stage(5,27,1) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 1,biography = 0,need_blessing = 4273,attr = [{1,15980},{2,319600},{3,7990},{4,7990}],other = []};

get_companion_stage(5,27,2) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 2,biography = 0,need_blessing = 4297,attr = [{1,16020},{2,320400},{3,8010},{4,8010}],other = []};

get_companion_stage(5,27,3) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 3,biography = 0,need_blessing = 4321,attr = [{1,16060},{2,321200},{3,8030},{4,8030}],other = []};

get_companion_stage(5,27,4) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 4,biography = 0,need_blessing = 4346,attr = [{1,16100},{2,322000},{3,8050},{4,8050}],other = []};

get_companion_stage(5,27,5) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 5,biography = 0,need_blessing = 4370,attr = [{1,16140},{2,322800},{3,8070},{4,8070}],other = []};

get_companion_stage(5,27,6) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 6,biography = 0,need_blessing = 4395,attr = [{1,16180},{2,323600},{3,8090},{4,8090}],other = []};

get_companion_stage(5,27,7) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 7,biography = 0,need_blessing = 4419,attr = [{1,16220},{2,324400},{3,8110},{4,8110}],other = []};

get_companion_stage(5,27,8) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 8,biography = 0,need_blessing = 4444,attr = [{1,16260},{2,325200},{3,8130},{4,8130}],other = []};

get_companion_stage(5,27,9) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 9,biography = 0,need_blessing = 4469,attr = [{1,16300},{2,326000},{3,8150},{4,8150}],other = []};

get_companion_stage(5,27,10) ->
	#base_companion_stage{companion_id = 5,stage = 27,star = 10,biography = 0,need_blessing = 4493,attr = [{1,16380},{2,327600},{3,8190},{4,8190}],other = []};

get_companion_stage(5,28,1) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 1,biography = 0,need_blessing = 4518,attr = [{1,16420},{2,328400},{3,8210},{4,8210}],other = []};

get_companion_stage(5,28,2) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 2,biography = 0,need_blessing = 4543,attr = [{1,16460},{2,329200},{3,8230},{4,8230}],other = []};

get_companion_stage(5,28,3) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 3,biography = 0,need_blessing = 4568,attr = [{1,16500},{2,330000},{3,8250},{4,8250}],other = []};

get_companion_stage(5,28,4) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 4,biography = 0,need_blessing = 4593,attr = [{1,16540},{2,330800},{3,8270},{4,8270}],other = []};

get_companion_stage(5,28,5) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 5,biography = 0,need_blessing = 4618,attr = [{1,16580},{2,331600},{3,8290},{4,8290}],other = []};

get_companion_stage(5,28,6) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 6,biography = 0,need_blessing = 4643,attr = [{1,16620},{2,332400},{3,8310},{4,8310}],other = []};

get_companion_stage(5,28,7) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 7,biography = 0,need_blessing = 4668,attr = [{1,16660},{2,333200},{3,8330},{4,8330}],other = []};

get_companion_stage(5,28,8) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 8,biography = 0,need_blessing = 4693,attr = [{1,16700},{2,334000},{3,8350},{4,8350}],other = []};

get_companion_stage(5,28,9) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 9,biography = 0,need_blessing = 4718,attr = [{1,16740},{2,334800},{3,8370},{4,8370}],other = []};

get_companion_stage(5,28,10) ->
	#base_companion_stage{companion_id = 5,stage = 28,star = 10,biography = 0,need_blessing = 4743,attr = [{1,16820},{2,336400},{3,8410},{4,8410}],other = []};

get_companion_stage(5,29,1) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 1,biography = 0,need_blessing = 4768,attr = [{1,16860},{2,337200},{3,8430},{4,8430}],other = []};

get_companion_stage(5,29,2) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 2,biography = 0,need_blessing = 4794,attr = [{1,16900},{2,338000},{3,8450},{4,8450}],other = []};

get_companion_stage(5,29,3) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 3,biography = 0,need_blessing = 4819,attr = [{1,16940},{2,338800},{3,8470},{4,8470}],other = []};

get_companion_stage(5,29,4) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 4,biography = 0,need_blessing = 4844,attr = [{1,16980},{2,339600},{3,8490},{4,8490}],other = []};

get_companion_stage(5,29,5) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 5,biography = 0,need_blessing = 4870,attr = [{1,17020},{2,340400},{3,8510},{4,8510}],other = []};

get_companion_stage(5,29,6) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 6,biography = 0,need_blessing = 4895,attr = [{1,17060},{2,341200},{3,8530},{4,8530}],other = []};

get_companion_stage(5,29,7) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 7,biography = 0,need_blessing = 4921,attr = [{1,17100},{2,342000},{3,8550},{4,8550}],other = []};

get_companion_stage(5,29,8) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 8,biography = 0,need_blessing = 4946,attr = [{1,17140},{2,342800},{3,8570},{4,8570}],other = []};

get_companion_stage(5,29,9) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 9,biography = 0,need_blessing = 4972,attr = [{1,17180},{2,343600},{3,8590},{4,8590}],other = []};

get_companion_stage(5,29,10) ->
	#base_companion_stage{companion_id = 5,stage = 29,star = 10,biography = 0,need_blessing = 4997,attr = [{1,17260},{2,345200},{3,8630},{4,8630}],other = []};

get_companion_stage(5,30,1) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 1,biography = 0,need_blessing = 5023,attr = [{1,17300},{2,346000},{3,8650},{4,8650}],other = []};

get_companion_stage(5,30,2) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 2,biography = 0,need_blessing = 5049,attr = [{1,17340},{2,346800},{3,8670},{4,8670}],other = []};

get_companion_stage(5,30,3) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 3,biography = 0,need_blessing = 5074,attr = [{1,17380},{2,347600},{3,8690},{4,8690}],other = []};

get_companion_stage(5,30,4) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 4,biography = 0,need_blessing = 5100,attr = [{1,17420},{2,348400},{3,8710},{4,8710}],other = []};

get_companion_stage(5,30,5) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 5,biography = 0,need_blessing = 5126,attr = [{1,17460},{2,349200},{3,8730},{4,8730}],other = []};

get_companion_stage(5,30,6) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 6,biography = 0,need_blessing = 5152,attr = [{1,17500},{2,350000},{3,8750},{4,8750}],other = []};

get_companion_stage(5,30,7) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,17540},{2,350800},{3,8770},{4,8770}],other = []};

get_companion_stage(5,30,8) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,17580},{2,351600},{3,8790},{4,8790}],other = []};

get_companion_stage(5,30,9) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,17620},{2,352400},{3,8810},{4,8810}],other = []};

get_companion_stage(5,30,10) ->
	#base_companion_stage{companion_id = 5,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,17700},{2,354000},{3,8850},{4,8850}],other = []};

get_companion_stage(6,1,0) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,3200},{2,64000},{3,1600},{4,1600}],other = []};

get_companion_stage(6,1,1) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],other = []};

get_companion_stage(6,1,2) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,3280},{2,65600},{3,1640},{4,1640}],other = []};

get_companion_stage(6,1,3) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,3320},{2,66400},{3,1660},{4,1660}],other = []};

get_companion_stage(6,1,4) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,3360},{2,67200},{3,1680},{4,1680}],other = []};

get_companion_stage(6,1,5) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,3400},{2,68000},{3,1700},{4,1700}],other = []};

get_companion_stage(6,1,6) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,3440},{2,68800},{3,1720},{4,1720}],other = []};

get_companion_stage(6,1,7) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,3480},{2,69600},{3,1740},{4,1740}],other = []};

get_companion_stage(6,1,8) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,3520},{2,70400},{3,1760},{4,1760}],other = []};

get_companion_stage(6,1,9) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,3560},{2,71200},{3,1780},{4,1780}],other = []};

get_companion_stage(6,1,10) ->
	#base_companion_stage{companion_id = 6,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,3640},{2,72800},{3,1820},{4,1820}],other = [{biog_reward, [{2,0,100},{0, 22030006, 3},{0, 22030106, 1}]}]};

get_companion_stage(6,2,1) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,3680},{2,73600},{3,1840},{4,1840}],other = []};

get_companion_stage(6,2,2) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,3720},{2,74400},{3,1860},{4,1860}],other = []};

get_companion_stage(6,2,3) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,3760},{2,75200},{3,1880},{4,1880}],other = []};

get_companion_stage(6,2,4) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,3800},{2,76000},{3,1900},{4,1900}],other = []};

get_companion_stage(6,2,5) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,3840},{2,76800},{3,1920},{4,1920}],other = []};

get_companion_stage(6,2,6) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,3880},{2,77600},{3,1940},{4,1940}],other = []};

get_companion_stage(6,2,7) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,3920},{2,78400},{3,1960},{4,1960}],other = []};

get_companion_stage(6,2,8) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,3960},{2,79200},{3,1980},{4,1980}],other = []};

get_companion_stage(6,2,9) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],other = []};

get_companion_stage(6,2,10) ->
	#base_companion_stage{companion_id = 6,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,4080},{2,81600},{3,2040},{4,2040}],other = []};

get_companion_stage(6,3,1) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,4120},{2,82400},{3,2060},{4,2060}],other = []};

get_companion_stage(6,3,2) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,4160},{2,83200},{3,2080},{4,2080}],other = []};

get_companion_stage(6,3,3) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,4200},{2,84000},{3,2100},{4,2100}],other = []};

get_companion_stage(6,3,4) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,4240},{2,84800},{3,2120},{4,2120}],other = []};

get_companion_stage(6,3,5) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,4280},{2,85600},{3,2140},{4,2140}],other = []};

get_companion_stage(6,3,6) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,4320},{2,86400},{3,2160},{4,2160}],other = []};

get_companion_stage(6,3,7) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,4360},{2,87200},{3,2180},{4,2180}],other = []};

get_companion_stage(6,3,8) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,4400},{2,88000},{3,2200},{4,2200}],other = []};

get_companion_stage(6,3,9) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,4440},{2,88800},{3,2220},{4,2220}],other = []};

get_companion_stage(6,3,10) ->
	#base_companion_stage{companion_id = 6,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,4520},{2,90400},{3,2260},{4,2260}],other = [{biog_reward, [{2,0,200},{0, 22030006, 5},{0, 22030106, 3}]}]};

get_companion_stage(6,4,1) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,4560},{2,91200},{3,2280},{4,2280}],other = []};

get_companion_stage(6,4,2) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,4600},{2,92000},{3,2300},{4,2300}],other = []};

get_companion_stage(6,4,3) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,4640},{2,92800},{3,2320},{4,2320}],other = []};

get_companion_stage(6,4,4) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,4680},{2,93600},{3,2340},{4,2340}],other = []};

get_companion_stage(6,4,5) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,4720},{2,94400},{3,2360},{4,2360}],other = []};

get_companion_stage(6,4,6) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,4760},{2,95200},{3,2380},{4,2380}],other = []};

get_companion_stage(6,4,7) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,4800},{2,96000},{3,2400},{4,2400}],other = []};

get_companion_stage(6,4,8) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,4840},{2,96800},{3,2420},{4,2420}],other = []};

get_companion_stage(6,4,9) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,4880},{2,97600},{3,2440},{4,2440}],other = []};

get_companion_stage(6,4,10) ->
	#base_companion_stage{companion_id = 6,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,4960},{2,99200},{3,2480},{4,2480}],other = []};

get_companion_stage(6,5,1) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],other = []};

get_companion_stage(6,5,2) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,5040},{2,100800},{3,2520},{4,2520}],other = []};

get_companion_stage(6,5,3) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,5080},{2,101600},{3,2540},{4,2540}],other = []};

get_companion_stage(6,5,4) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,5120},{2,102400},{3,2560},{4,2560}],other = []};

get_companion_stage(6,5,5) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,5160},{2,103200},{3,2580},{4,2580}],other = []};

get_companion_stage(6,5,6) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,5200},{2,104000},{3,2600},{4,2600}],other = []};

get_companion_stage(6,5,7) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,5240},{2,104800},{3,2620},{4,2620}],other = []};

get_companion_stage(6,5,8) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,5280},{2,105600},{3,2640},{4,2640}],other = []};

get_companion_stage(6,5,9) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,5320},{2,106400},{3,2660},{4,2660}],other = []};

get_companion_stage(6,5,10) ->
	#base_companion_stage{companion_id = 6,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,5400},{2,108000},{3,2700},{4,2700}],other = [{biog_reward, [{2,0,250},{0, 22030006, 10},{0, 22030106, 5}]}]};

get_companion_stage(6,6,1) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,5440},{2,108800},{3,2720},{4,2720}],other = []};

get_companion_stage(6,6,2) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,5480},{2,109600},{3,2740},{4,2740}],other = []};

get_companion_stage(6,6,3) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,5520},{2,110400},{3,2760},{4,2760}],other = []};

get_companion_stage(6,6,4) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,5560},{2,111200},{3,2780},{4,2780}],other = []};

get_companion_stage(6,6,5) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,5600},{2,112000},{3,2800},{4,2800}],other = []};

get_companion_stage(6,6,6) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,5640},{2,112800},{3,2820},{4,2820}],other = []};

get_companion_stage(6,6,7) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,5680},{2,113600},{3,2840},{4,2840}],other = []};

get_companion_stage(6,6,8) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,5720},{2,114400},{3,2860},{4,2860}],other = []};

get_companion_stage(6,6,9) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,5760},{2,115200},{3,2880},{4,2880}],other = []};

get_companion_stage(6,6,10) ->
	#base_companion_stage{companion_id = 6,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,5840},{2,116800},{3,2920},{4,2920}],other = []};

get_companion_stage(6,7,1) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,5880},{2,117600},{3,2940},{4,2940}],other = []};

get_companion_stage(6,7,2) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,5920},{2,118400},{3,2960},{4,2960}],other = []};

get_companion_stage(6,7,3) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,5960},{2,119200},{3,2980},{4,2980}],other = []};

get_companion_stage(6,7,4) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],other = []};

get_companion_stage(6,7,5) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,6040},{2,120800},{3,3020},{4,3020}],other = []};

get_companion_stage(6,7,6) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,6080},{2,121600},{3,3040},{4,3040}],other = []};

get_companion_stage(6,7,7) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,6120},{2,122400},{3,3060},{4,3060}],other = []};

get_companion_stage(6,7,8) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,6160},{2,123200},{3,3080},{4,3080}],other = []};

get_companion_stage(6,7,9) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,6200},{2,124000},{3,3100},{4,3100}],other = []};

get_companion_stage(6,7,10) ->
	#base_companion_stage{companion_id = 6,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,6280},{2,125600},{3,3140},{4,3140}],other = []};

get_companion_stage(6,8,1) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,6320},{2,126400},{3,3160},{4,3160}],other = []};

get_companion_stage(6,8,2) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],other = []};

get_companion_stage(6,8,3) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],other = []};

get_companion_stage(6,8,4) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,6440},{2,128800},{3,3220},{4,3220}],other = []};

get_companion_stage(6,8,5) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,6480},{2,129600},{3,3240},{4,3240}],other = []};

get_companion_stage(6,8,6) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,6520},{2,130400},{3,3260},{4,3260}],other = []};

get_companion_stage(6,8,7) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,6560},{2,131200},{3,3280},{4,3280}],other = []};

get_companion_stage(6,8,8) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,6600},{2,132000},{3,3300},{4,3300}],other = []};

get_companion_stage(6,8,9) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,6640},{2,132800},{3,3320},{4,3320}],other = []};

get_companion_stage(6,8,10) ->
	#base_companion_stage{companion_id = 6,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,6720},{2,134400},{3,3360},{4,3360}],other = []};

get_companion_stage(6,9,1) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,6760},{2,135200},{3,3380},{4,3380}],other = []};

get_companion_stage(6,9,2) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,6800},{2,136000},{3,3400},{4,3400}],other = []};

get_companion_stage(6,9,3) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,6840},{2,136800},{3,3420},{4,3420}],other = []};

get_companion_stage(6,9,4) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,6880},{2,137600},{3,3440},{4,3440}],other = []};

get_companion_stage(6,9,5) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,6920},{2,138400},{3,3460},{4,3460}],other = []};

get_companion_stage(6,9,6) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,6960},{2,139200},{3,3480},{4,3480}],other = []};

get_companion_stage(6,9,7) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],other = []};

get_companion_stage(6,9,8) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,7040},{2,140800},{3,3520},{4,3520}],other = []};

get_companion_stage(6,9,9) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],other = []};

get_companion_stage(6,9,10) ->
	#base_companion_stage{companion_id = 6,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,7160},{2,143200},{3,3580},{4,3580}],other = []};

get_companion_stage(6,10,1) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],other = []};

get_companion_stage(6,10,2) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,7240},{2,144800},{3,3620},{4,3620}],other = []};

get_companion_stage(6,10,3) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,7280},{2,145600},{3,3640},{4,3640}],other = []};

get_companion_stage(6,10,4) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],other = []};

get_companion_stage(6,10,5) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,7360},{2,147200},{3,3680},{4,3680}],other = []};

get_companion_stage(6,10,6) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,7400},{2,148000},{3,3700},{4,3700}],other = []};

get_companion_stage(6,10,7) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],other = []};

get_companion_stage(6,10,8) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,7480},{2,149600},{3,3740},{4,3740}],other = []};

get_companion_stage(6,10,9) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,7520},{2,150400},{3,3760},{4,3760}],other = []};

get_companion_stage(6,10,10) ->
	#base_companion_stage{companion_id = 6,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,7600},{2,152000},{3,3800},{4,3800}],other = []};

get_companion_stage(6,11,1) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,7640},{2,152800},{3,3820},{4,3820}],other = []};

get_companion_stage(6,11,2) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],other = []};

get_companion_stage(6,11,3) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,7720},{2,154400},{3,3860},{4,3860}],other = []};

get_companion_stage(6,11,4) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,7760},{2,155200},{3,3880},{4,3880}],other = []};

get_companion_stage(6,11,5) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],other = []};

get_companion_stage(6,11,6) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,7840},{2,156800},{3,3920},{4,3920}],other = []};

get_companion_stage(6,11,7) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,7880},{2,157600},{3,3940},{4,3940}],other = []};

get_companion_stage(6,11,8) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,7920},{2,158400},{3,3960},{4,3960}],other = []};

get_companion_stage(6,11,9) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,7960},{2,159200},{3,3980},{4,3980}],other = []};

get_companion_stage(6,11,10) ->
	#base_companion_stage{companion_id = 6,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,8040},{2,160800},{3,4020},{4,4020}],other = []};

get_companion_stage(6,12,1) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,8080},{2,161600},{3,4040},{4,4040}],other = []};

get_companion_stage(6,12,2) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,8120},{2,162400},{3,4060},{4,4060}],other = []};

get_companion_stage(6,12,3) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,8160},{2,163200},{3,4080},{4,4080}],other = []};

get_companion_stage(6,12,4) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,8200},{2,164000},{3,4100},{4,4100}],other = []};

get_companion_stage(6,12,5) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,8240},{2,164800},{3,4120},{4,4120}],other = []};

get_companion_stage(6,12,6) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,8280},{2,165600},{3,4140},{4,4140}],other = []};

get_companion_stage(6,12,7) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,8320},{2,166400},{3,4160},{4,4160}],other = []};

get_companion_stage(6,12,8) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,8360},{2,167200},{3,4180},{4,4180}],other = []};

get_companion_stage(6,12,9) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(6,12,10) ->
	#base_companion_stage{companion_id = 6,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,8480},{2,169600},{3,4240},{4,4240}],other = []};

get_companion_stage(6,13,1) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,8520},{2,170400},{3,4260},{4,4260}],other = []};

get_companion_stage(6,13,2) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,8560},{2,171200},{3,4280},{4,4280}],other = []};

get_companion_stage(6,13,3) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,8600},{2,172000},{3,4300},{4,4300}],other = []};

get_companion_stage(6,13,4) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,8640},{2,172800},{3,4320},{4,4320}],other = []};

get_companion_stage(6,13,5) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,8680},{2,173600},{3,4340},{4,4340}],other = []};

get_companion_stage(6,13,6) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,8720},{2,174400},{3,4360},{4,4360}],other = []};

get_companion_stage(6,13,7) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,8760},{2,175200},{3,4380},{4,4380}],other = []};

get_companion_stage(6,13,8) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,8800},{2,176000},{3,4400},{4,4400}],other = []};

get_companion_stage(6,13,9) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,8840},{2,176800},{3,4420},{4,4420}],other = []};

get_companion_stage(6,13,10) ->
	#base_companion_stage{companion_id = 6,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,8920},{2,178400},{3,4460},{4,4460}],other = []};

get_companion_stage(6,14,1) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,8960},{2,179200},{3,4480},{4,4480}],other = []};

get_companion_stage(6,14,2) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,9000},{2,180000},{3,4500},{4,4500}],other = []};

get_companion_stage(6,14,3) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,9040},{2,180800},{3,4520},{4,4520}],other = []};

get_companion_stage(6,14,4) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,9080},{2,181600},{3,4540},{4,4540}],other = []};

get_companion_stage(6,14,5) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,9120},{2,182400},{3,4560},{4,4560}],other = []};

get_companion_stage(6,14,6) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,9160},{2,183200},{3,4580},{4,4580}],other = []};

get_companion_stage(6,14,7) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,9200},{2,184000},{3,4600},{4,4600}],other = []};

get_companion_stage(6,14,8) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,9240},{2,184800},{3,4620},{4,4620}],other = []};

get_companion_stage(6,14,9) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,9280},{2,185600},{3,4640},{4,4640}],other = []};

get_companion_stage(6,14,10) ->
	#base_companion_stage{companion_id = 6,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,9360},{2,187200},{3,4680},{4,4680}],other = []};

get_companion_stage(6,15,1) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,9400},{2,188000},{3,4700},{4,4700}],other = []};

get_companion_stage(6,15,2) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,9440},{2,188800},{3,4720},{4,4720}],other = []};

get_companion_stage(6,15,3) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,9480},{2,189600},{3,4740},{4,4740}],other = []};

get_companion_stage(6,15,4) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,9520},{2,190400},{3,4760},{4,4760}],other = []};

get_companion_stage(6,15,5) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,9560},{2,191200},{3,4780},{4,4780}],other = []};

get_companion_stage(6,15,6) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(6,15,7) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,9640},{2,192800},{3,4820},{4,4820}],other = []};

get_companion_stage(6,15,8) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,9680},{2,193600},{3,4840},{4,4840}],other = []};

get_companion_stage(6,15,9) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,9720},{2,194400},{3,4860},{4,4860}],other = []};

get_companion_stage(6,15,10) ->
	#base_companion_stage{companion_id = 6,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,9800},{2,196000},{3,4900},{4,4900}],other = []};

get_companion_stage(6,16,1) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,9840},{2,196800},{3,4920},{4,4920}],other = []};

get_companion_stage(6,16,2) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,9880},{2,197600},{3,4940},{4,4940}],other = []};

get_companion_stage(6,16,3) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,9920},{2,198400},{3,4960},{4,4960}],other = []};

get_companion_stage(6,16,4) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,9960},{2,199200},{3,4980},{4,4980}],other = []};

get_companion_stage(6,16,5) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,10000},{2,200000},{3,5000},{4,5000}],other = []};

get_companion_stage(6,16,6) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,10040},{2,200800},{3,5020},{4,5020}],other = []};

get_companion_stage(6,16,7) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,10080},{2,201600},{3,5040},{4,5040}],other = []};

get_companion_stage(6,16,8) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,10120},{2,202400},{3,5060},{4,5060}],other = []};

get_companion_stage(6,16,9) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,10160},{2,203200},{3,5080},{4,5080}],other = []};

get_companion_stage(6,16,10) ->
	#base_companion_stage{companion_id = 6,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,10240},{2,204800},{3,5120},{4,5120}],other = []};

get_companion_stage(6,17,1) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,10280},{2,205600},{3,5140},{4,5140}],other = []};

get_companion_stage(6,17,2) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,10320},{2,206400},{3,5160},{4,5160}],other = []};

get_companion_stage(6,17,3) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,10360},{2,207200},{3,5180},{4,5180}],other = []};

get_companion_stage(6,17,4) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,10400},{2,208000},{3,5200},{4,5200}],other = []};

get_companion_stage(6,17,5) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,10440},{2,208800},{3,5220},{4,5220}],other = []};

get_companion_stage(6,17,6) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,10480},{2,209600},{3,5240},{4,5240}],other = []};

get_companion_stage(6,17,7) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,10520},{2,210400},{3,5260},{4,5260}],other = []};

get_companion_stage(6,17,8) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,10560},{2,211200},{3,5280},{4,5280}],other = []};

get_companion_stage(6,17,9) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,10600},{2,212000},{3,5300},{4,5300}],other = []};

get_companion_stage(6,17,10) ->
	#base_companion_stage{companion_id = 6,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,10680},{2,213600},{3,5340},{4,5340}],other = []};

get_companion_stage(6,18,1) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,10720},{2,214400},{3,5360},{4,5360}],other = []};

get_companion_stage(6,18,2) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,10760},{2,215200},{3,5380},{4,5380}],other = []};

get_companion_stage(6,18,3) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,10800},{2,216000},{3,5400},{4,5400}],other = []};

get_companion_stage(6,18,4) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,10840},{2,216800},{3,5420},{4,5420}],other = []};

get_companion_stage(6,18,5) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,10880},{2,217600},{3,5440},{4,5440}],other = []};

get_companion_stage(6,18,6) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,10920},{2,218400},{3,5460},{4,5460}],other = []};

get_companion_stage(6,18,7) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,10960},{2,219200},{3,5480},{4,5480}],other = []};

get_companion_stage(6,18,8) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,11000},{2,220000},{3,5500},{4,5500}],other = []};

get_companion_stage(6,18,9) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,11040},{2,220800},{3,5520},{4,5520}],other = []};

get_companion_stage(6,18,10) ->
	#base_companion_stage{companion_id = 6,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,11120},{2,222400},{3,5560},{4,5560}],other = []};

get_companion_stage(6,19,1) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,11160},{2,223200},{3,5580},{4,5580}],other = []};

get_companion_stage(6,19,2) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,11200},{2,224000},{3,5600},{4,5600}],other = []};

get_companion_stage(6,19,3) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,11240},{2,224800},{3,5620},{4,5620}],other = []};

get_companion_stage(6,19,4) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,11280},{2,225600},{3,5640},{4,5640}],other = []};

get_companion_stage(6,19,5) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,11320},{2,226400},{3,5660},{4,5660}],other = []};

get_companion_stage(6,19,6) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,11360},{2,227200},{3,5680},{4,5680}],other = []};

get_companion_stage(6,19,7) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = []};

get_companion_stage(6,19,8) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,11440},{2,228800},{3,5720},{4,5720}],other = []};

get_companion_stage(6,19,9) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,11480},{2,229600},{3,5740},{4,5740}],other = []};

get_companion_stage(6,19,10) ->
	#base_companion_stage{companion_id = 6,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,11560},{2,231200},{3,5780},{4,5780}],other = []};

get_companion_stage(6,20,1) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,11600},{2,232000},{3,5800},{4,5800}],other = []};

get_companion_stage(6,20,2) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,11640},{2,232800},{3,5820},{4,5820}],other = []};

get_companion_stage(6,20,3) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,11680},{2,233600},{3,5840},{4,5840}],other = []};

get_companion_stage(6,20,4) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,11720},{2,234400},{3,5860},{4,5860}],other = []};

get_companion_stage(6,20,5) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],other = []};

get_companion_stage(6,20,6) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,11800},{2,236000},{3,5900},{4,5900}],other = []};

get_companion_stage(6,20,7) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,11840},{2,236800},{3,5920},{4,5920}],other = []};

get_companion_stage(6,20,8) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,11880},{2,237600},{3,5940},{4,5940}],other = []};

get_companion_stage(6,20,9) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,11920},{2,238400},{3,5960},{4,5960}],other = []};

get_companion_stage(6,20,10) ->
	#base_companion_stage{companion_id = 6,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],other = []};

get_companion_stage(6,21,1) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,12040},{2,240800},{3,6020},{4,6020}],other = []};

get_companion_stage(6,21,2) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,12080},{2,241600},{3,6040},{4,6040}],other = []};

get_companion_stage(6,21,3) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,12120},{2,242400},{3,6060},{4,6060}],other = []};

get_companion_stage(6,21,4) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,12160},{2,243200},{3,6080},{4,6080}],other = []};

get_companion_stage(6,21,5) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,12200},{2,244000},{3,6100},{4,6100}],other = []};

get_companion_stage(6,21,6) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,12240},{2,244800},{3,6120},{4,6120}],other = []};

get_companion_stage(6,21,7) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,12280},{2,245600},{3,6140},{4,6140}],other = []};

get_companion_stage(6,21,8) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,12320},{2,246400},{3,6160},{4,6160}],other = []};

get_companion_stage(6,21,9) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,12360},{2,247200},{3,6180},{4,6180}],other = []};

get_companion_stage(6,21,10) ->
	#base_companion_stage{companion_id = 6,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,12440},{2,248800},{3,6220},{4,6220}],other = []};

get_companion_stage(6,22,1) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(6,22,2) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,12520},{2,250400},{3,6260},{4,6260}],other = []};

get_companion_stage(6,22,3) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,12560},{2,251200},{3,6280},{4,6280}],other = []};

get_companion_stage(6,22,4) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,12600},{2,252000},{3,6300},{4,6300}],other = []};

get_companion_stage(6,22,5) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,12640},{2,252800},{3,6320},{4,6320}],other = []};

get_companion_stage(6,22,6) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,12680},{2,253600},{3,6340},{4,6340}],other = []};

get_companion_stage(6,22,7) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,12720},{2,254400},{3,6360},{4,6360}],other = []};

get_companion_stage(6,22,8) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,12760},{2,255200},{3,6380},{4,6380}],other = []};

get_companion_stage(6,22,9) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,12800},{2,256000},{3,6400},{4,6400}],other = []};

get_companion_stage(6,22,10) ->
	#base_companion_stage{companion_id = 6,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,12880},{2,257600},{3,6440},{4,6440}],other = []};

get_companion_stage(6,23,1) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,12920},{2,258400},{3,6460},{4,6460}],other = []};

get_companion_stage(6,23,2) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,12960},{2,259200},{3,6480},{4,6480}],other = []};

get_companion_stage(6,23,3) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,13000},{2,260000},{3,6500},{4,6500}],other = []};

get_companion_stage(6,23,4) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,13040},{2,260800},{3,6520},{4,6520}],other = []};

get_companion_stage(6,23,5) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,13080},{2,261600},{3,6540},{4,6540}],other = []};

get_companion_stage(6,23,6) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,13120},{2,262400},{3,6560},{4,6560}],other = []};

get_companion_stage(6,23,7) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,13160},{2,263200},{3,6580},{4,6580}],other = []};

get_companion_stage(6,23,8) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,13200},{2,264000},{3,6600},{4,6600}],other = []};

get_companion_stage(6,23,9) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,13240},{2,264800},{3,6620},{4,6620}],other = []};

get_companion_stage(6,23,10) ->
	#base_companion_stage{companion_id = 6,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,13320},{2,266400},{3,6660},{4,6660}],other = []};

get_companion_stage(6,24,1) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,13360},{2,267200},{3,6680},{4,6680}],other = []};

get_companion_stage(6,24,2) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,13400},{2,268000},{3,6700},{4,6700}],other = []};

get_companion_stage(6,24,3) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,13440},{2,268800},{3,6720},{4,6720}],other = []};

get_companion_stage(6,24,4) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,13480},{2,269600},{3,6740},{4,6740}],other = []};

get_companion_stage(6,24,5) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,13520},{2,270400},{3,6760},{4,6760}],other = []};

get_companion_stage(6,24,6) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,13560},{2,271200},{3,6780},{4,6780}],other = []};

get_companion_stage(6,24,7) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,13600},{2,272000},{3,6800},{4,6800}],other = []};

get_companion_stage(6,24,8) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,13640},{2,272800},{3,6820},{4,6820}],other = []};

get_companion_stage(6,24,9) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,13680},{2,273600},{3,6840},{4,6840}],other = []};

get_companion_stage(6,24,10) ->
	#base_companion_stage{companion_id = 6,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,13760},{2,275200},{3,6880},{4,6880}],other = []};

get_companion_stage(6,25,1) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,13800},{2,276000},{3,6900},{4,6900}],other = []};

get_companion_stage(6,25,2) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,13840},{2,276800},{3,6920},{4,6920}],other = []};

get_companion_stage(6,25,3) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,13880},{2,277600},{3,6940},{4,6940}],other = []};

get_companion_stage(6,25,4) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,13920},{2,278400},{3,6960},{4,6960}],other = []};

get_companion_stage(6,25,5) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,13960},{2,279200},{3,6980},{4,6980}],other = []};

get_companion_stage(6,25,6) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,14000},{2,280000},{3,7000},{4,7000}],other = []};

get_companion_stage(6,25,7) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,14040},{2,280800},{3,7020},{4,7020}],other = []};

get_companion_stage(6,25,8) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,14080},{2,281600},{3,7040},{4,7040}],other = []};

get_companion_stage(6,25,9) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,14120},{2,282400},{3,7060},{4,7060}],other = []};

get_companion_stage(6,25,10) ->
	#base_companion_stage{companion_id = 6,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,14200},{2,284000},{3,7100},{4,7100}],other = []};

get_companion_stage(6,26,1) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,14240},{2,284800},{3,7120},{4,7120}],other = []};

get_companion_stage(6,26,2) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,14280},{2,285600},{3,7140},{4,7140}],other = []};

get_companion_stage(6,26,3) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,14320},{2,286400},{3,7160},{4,7160}],other = []};

get_companion_stage(6,26,4) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,14360},{2,287200},{3,7180},{4,7180}],other = []};

get_companion_stage(6,26,5) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,14400},{2,288000},{3,7200},{4,7200}],other = []};

get_companion_stage(6,26,6) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,14440},{2,288800},{3,7220},{4,7220}],other = []};

get_companion_stage(6,26,7) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,14480},{2,289600},{3,7240},{4,7240}],other = []};

get_companion_stage(6,26,8) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,14520},{2,290400},{3,7260},{4,7260}],other = []};

get_companion_stage(6,26,9) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,14560},{2,291200},{3,7280},{4,7280}],other = []};

get_companion_stage(6,26,10) ->
	#base_companion_stage{companion_id = 6,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,14640},{2,292800},{3,7320},{4,7320}],other = []};

get_companion_stage(6,27,1) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,14680},{2,293600},{3,7340},{4,7340}],other = []};

get_companion_stage(6,27,2) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,14720},{2,294400},{3,7360},{4,7360}],other = []};

get_companion_stage(6,27,3) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,14760},{2,295200},{3,7380},{4,7380}],other = []};

get_companion_stage(6,27,4) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,14800},{2,296000},{3,7400},{4,7400}],other = []};

get_companion_stage(6,27,5) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,14840},{2,296800},{3,7420},{4,7420}],other = []};

get_companion_stage(6,27,6) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,14880},{2,297600},{3,7440},{4,7440}],other = []};

get_companion_stage(6,27,7) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,14920},{2,298400},{3,7460},{4,7460}],other = []};

get_companion_stage(6,27,8) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,14960},{2,299200},{3,7480},{4,7480}],other = []};

get_companion_stage(6,27,9) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,15000},{2,300000},{3,7500},{4,7500}],other = []};

get_companion_stage(6,27,10) ->
	#base_companion_stage{companion_id = 6,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,15080},{2,301600},{3,7540},{4,7540}],other = []};

get_companion_stage(6,28,1) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,15120},{2,302400},{3,7560},{4,7560}],other = []};

get_companion_stage(6,28,2) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,15160},{2,303200},{3,7580},{4,7580}],other = []};

get_companion_stage(6,28,3) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,15200},{2,304000},{3,7600},{4,7600}],other = []};

get_companion_stage(6,28,4) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,15240},{2,304800},{3,7620},{4,7620}],other = []};

get_companion_stage(6,28,5) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,15280},{2,305600},{3,7640},{4,7640}],other = []};

get_companion_stage(6,28,6) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,15320},{2,306400},{3,7660},{4,7660}],other = []};

get_companion_stage(6,28,7) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,15360},{2,307200},{3,7680},{4,7680}],other = []};

get_companion_stage(6,28,8) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,15400},{2,308000},{3,7700},{4,7700}],other = []};

get_companion_stage(6,28,9) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,15440},{2,308800},{3,7720},{4,7720}],other = []};

get_companion_stage(6,28,10) ->
	#base_companion_stage{companion_id = 6,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,15520},{2,310400},{3,7760},{4,7760}],other = []};

get_companion_stage(6,29,1) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,15560},{2,311200},{3,7780},{4,7780}],other = []};

get_companion_stage(6,29,2) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,15600},{2,312000},{3,7800},{4,7800}],other = []};

get_companion_stage(6,29,3) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,15640},{2,312800},{3,7820},{4,7820}],other = []};

get_companion_stage(6,29,4) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,15680},{2,313600},{3,7840},{4,7840}],other = []};

get_companion_stage(6,29,5) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,15720},{2,314400},{3,7860},{4,7860}],other = []};

get_companion_stage(6,29,6) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,15760},{2,315200},{3,7880},{4,7880}],other = []};

get_companion_stage(6,29,7) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,15800},{2,316000},{3,7900},{4,7900}],other = []};

get_companion_stage(6,29,8) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,15840},{2,316800},{3,7920},{4,7920}],other = []};

get_companion_stage(6,29,9) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,15880},{2,317600},{3,7940},{4,7940}],other = []};

get_companion_stage(6,29,10) ->
	#base_companion_stage{companion_id = 6,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,15960},{2,319200},{3,7980},{4,7980}],other = []};

get_companion_stage(6,30,1) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,16000},{2,320000},{3,8000},{4,8000}],other = []};

get_companion_stage(6,30,2) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,16040},{2,320800},{3,8020},{4,8020}],other = []};

get_companion_stage(6,30,3) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,16080},{2,321600},{3,8040},{4,8040}],other = []};

get_companion_stage(6,30,4) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,16120},{2,322400},{3,8060},{4,8060}],other = []};

get_companion_stage(6,30,5) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,16160},{2,323200},{3,8080},{4,8080}],other = []};

get_companion_stage(6,30,6) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,16200},{2,324000},{3,8100},{4,8100}],other = []};

get_companion_stage(6,30,7) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,16240},{2,324800},{3,8120},{4,8120}],other = []};

get_companion_stage(6,30,8) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,16280},{2,325600},{3,8140},{4,8140}],other = []};

get_companion_stage(6,30,9) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,16320},{2,326400},{3,8160},{4,8160}],other = []};

get_companion_stage(6,30,10) ->
	#base_companion_stage{companion_id = 6,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,16400},{2,328000},{3,8200},{4,8200}],other = []};

get_companion_stage(7,1,0) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],other = []};

get_companion_stage(7,1,1) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,6060},{2,121200},{3,3030},{4,3030}],other = []};

get_companion_stage(7,1,2) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,6120},{2,122400},{3,3060},{4,3060}],other = []};

get_companion_stage(7,1,3) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,6180},{2,123600},{3,3090},{4,3090}],other = []};

get_companion_stage(7,1,4) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,6240},{2,124800},{3,3120},{4,3120}],other = []};

get_companion_stage(7,1,5) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,6300},{2,126000},{3,3150},{4,3150}],other = []};

get_companion_stage(7,1,6) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],other = []};

get_companion_stage(7,1,7) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,6420},{2,128400},{3,3210},{4,3210}],other = []};

get_companion_stage(7,1,8) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,6480},{2,129600},{3,3240},{4,3240}],other = []};

get_companion_stage(7,1,9) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,6540},{2,130800},{3,3270},{4,3270}],other = []};

get_companion_stage(7,1,10) ->
	#base_companion_stage{companion_id = 7,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,6660},{2,133200},{3,3330},{4,3330}],other = [{biog_reward, [{2,0,100},{0, 22030007, 3},{0, 22030107, 1}]}]};

get_companion_stage(7,2,1) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,6720},{2,134400},{3,3360},{4,3360}],other = []};

get_companion_stage(7,2,2) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,6780},{2,135600},{3,3390},{4,3390}],other = []};

get_companion_stage(7,2,3) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,6840},{2,136800},{3,3420},{4,3420}],other = []};

get_companion_stage(7,2,4) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],other = []};

get_companion_stage(7,2,5) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,6960},{2,139200},{3,3480},{4,3480}],other = []};

get_companion_stage(7,2,6) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,7020},{2,140400},{3,3510},{4,3510}],other = []};

get_companion_stage(7,2,7) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],other = []};

get_companion_stage(7,2,8) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,7140},{2,142800},{3,3570},{4,3570}],other = []};

get_companion_stage(7,2,9) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],other = []};

get_companion_stage(7,2,10) ->
	#base_companion_stage{companion_id = 7,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],other = []};

get_companion_stage(7,3,1) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,7380},{2,147600},{3,3690},{4,3690}],other = []};

get_companion_stage(7,3,2) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],other = []};

get_companion_stage(7,3,3) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],other = []};

get_companion_stage(7,3,4) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,7560},{2,151200},{3,3780},{4,3780}],other = []};

get_companion_stage(7,3,5) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,7620},{2,152400},{3,3810},{4,3810}],other = []};

get_companion_stage(7,3,6) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],other = []};

get_companion_stage(7,3,7) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],other = []};

get_companion_stage(7,3,8) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],other = []};

get_companion_stage(7,3,9) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,7860},{2,157200},{3,3930},{4,3930}],other = []};

get_companion_stage(7,3,10) ->
	#base_companion_stage{companion_id = 7,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,7980},{2,159600},{3,3990},{4,3990}],other = [{biog_reward, [{2,0,200},{0, 22030007, 5},{0, 22030107, 3}]}]};

get_companion_stage(7,4,1) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,8040},{2,160800},{3,4020},{4,4020}],other = []};

get_companion_stage(7,4,2) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,8100},{2,162000},{3,4050},{4,4050}],other = []};

get_companion_stage(7,4,3) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,8160},{2,163200},{3,4080},{4,4080}],other = []};

get_companion_stage(7,4,4) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,8220},{2,164400},{3,4110},{4,4110}],other = []};

get_companion_stage(7,4,5) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,8280},{2,165600},{3,4140},{4,4140}],other = []};

get_companion_stage(7,4,6) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,8340},{2,166800},{3,4170},{4,4170}],other = []};

get_companion_stage(7,4,7) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(7,4,8) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,8460},{2,169200},{3,4230},{4,4230}],other = []};

get_companion_stage(7,4,9) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,8520},{2,170400},{3,4260},{4,4260}],other = []};

get_companion_stage(7,4,10) ->
	#base_companion_stage{companion_id = 7,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,8640},{2,172800},{3,4320},{4,4320}],other = []};

get_companion_stage(7,5,1) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,8700},{2,174000},{3,4350},{4,4350}],other = []};

get_companion_stage(7,5,2) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,8760},{2,175200},{3,4380},{4,4380}],other = []};

get_companion_stage(7,5,3) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,8820},{2,176400},{3,4410},{4,4410}],other = []};

get_companion_stage(7,5,4) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,8880},{2,177600},{3,4440},{4,4440}],other = []};

get_companion_stage(7,5,5) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,8940},{2,178800},{3,4470},{4,4470}],other = []};

get_companion_stage(7,5,6) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,9000},{2,180000},{3,4500},{4,4500}],other = []};

get_companion_stage(7,5,7) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,9060},{2,181200},{3,4530},{4,4530}],other = []};

get_companion_stage(7,5,8) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,9120},{2,182400},{3,4560},{4,4560}],other = []};

get_companion_stage(7,5,9) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,9180},{2,183600},{3,4590},{4,4590}],other = []};

get_companion_stage(7,5,10) ->
	#base_companion_stage{companion_id = 7,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,9300},{2,186000},{3,4650},{4,4650}],other = [{biog_reward, [{2,0,250},{0, 22030007, 10},{0, 22030107, 5}]}]};

get_companion_stage(7,6,1) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,9360},{2,187200},{3,4680},{4,4680}],other = []};

get_companion_stage(7,6,2) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,9420},{2,188400},{3,4710},{4,4710}],other = []};

get_companion_stage(7,6,3) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,9480},{2,189600},{3,4740},{4,4740}],other = []};

get_companion_stage(7,6,4) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,9540},{2,190800},{3,4770},{4,4770}],other = []};

get_companion_stage(7,6,5) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(7,6,6) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,9660},{2,193200},{3,4830},{4,4830}],other = []};

get_companion_stage(7,6,7) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,9720},{2,194400},{3,4860},{4,4860}],other = []};

get_companion_stage(7,6,8) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,9780},{2,195600},{3,4890},{4,4890}],other = []};

get_companion_stage(7,6,9) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,9840},{2,196800},{3,4920},{4,4920}],other = []};

get_companion_stage(7,6,10) ->
	#base_companion_stage{companion_id = 7,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,9960},{2,199200},{3,4980},{4,4980}],other = []};

get_companion_stage(7,7,1) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,10020},{2,200400},{3,5010},{4,5010}],other = []};

get_companion_stage(7,7,2) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,10080},{2,201600},{3,5040},{4,5040}],other = []};

get_companion_stage(7,7,3) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,10140},{2,202800},{3,5070},{4,5070}],other = []};

get_companion_stage(7,7,4) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,10200},{2,204000},{3,5100},{4,5100}],other = []};

get_companion_stage(7,7,5) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,10260},{2,205200},{3,5130},{4,5130}],other = []};

get_companion_stage(7,7,6) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,10320},{2,206400},{3,5160},{4,5160}],other = []};

get_companion_stage(7,7,7) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,10380},{2,207600},{3,5190},{4,5190}],other = []};

get_companion_stage(7,7,8) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,10440},{2,208800},{3,5220},{4,5220}],other = []};

get_companion_stage(7,7,9) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,10500},{2,210000},{3,5250},{4,5250}],other = []};

get_companion_stage(7,7,10) ->
	#base_companion_stage{companion_id = 7,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,10620},{2,212400},{3,5310},{4,5310}],other = []};

get_companion_stage(7,8,1) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,10680},{2,213600},{3,5340},{4,5340}],other = []};

get_companion_stage(7,8,2) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,10740},{2,214800},{3,5370},{4,5370}],other = []};

get_companion_stage(7,8,3) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,10800},{2,216000},{3,5400},{4,5400}],other = []};

get_companion_stage(7,8,4) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,10860},{2,217200},{3,5430},{4,5430}],other = []};

get_companion_stage(7,8,5) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,10920},{2,218400},{3,5460},{4,5460}],other = []};

get_companion_stage(7,8,6) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,10980},{2,219600},{3,5490},{4,5490}],other = []};

get_companion_stage(7,8,7) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,11040},{2,220800},{3,5520},{4,5520}],other = []};

get_companion_stage(7,8,8) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,11100},{2,222000},{3,5550},{4,5550}],other = []};

get_companion_stage(7,8,9) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,11160},{2,223200},{3,5580},{4,5580}],other = []};

get_companion_stage(7,8,10) ->
	#base_companion_stage{companion_id = 7,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,11280},{2,225600},{3,5640},{4,5640}],other = []};

get_companion_stage(7,9,1) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,11340},{2,226800},{3,5670},{4,5670}],other = []};

get_companion_stage(7,9,2) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = []};

get_companion_stage(7,9,3) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(7,9,4) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,11520},{2,230400},{3,5760},{4,5760}],other = []};

get_companion_stage(7,9,5) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,11580},{2,231600},{3,5790},{4,5790}],other = []};

get_companion_stage(7,9,6) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,11640},{2,232800},{3,5820},{4,5820}],other = []};

get_companion_stage(7,9,7) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,11700},{2,234000},{3,5850},{4,5850}],other = []};

get_companion_stage(7,9,8) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],other = []};

get_companion_stage(7,9,9) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,11820},{2,236400},{3,5910},{4,5910}],other = []};

get_companion_stage(7,9,10) ->
	#base_companion_stage{companion_id = 7,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,11940},{2,238800},{3,5970},{4,5970}],other = []};

get_companion_stage(7,10,1) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],other = []};

get_companion_stage(7,10,2) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,12060},{2,241200},{3,6030},{4,6030}],other = []};

get_companion_stage(7,10,3) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,12120},{2,242400},{3,6060},{4,6060}],other = []};

get_companion_stage(7,10,4) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,12180},{2,243600},{3,6090},{4,6090}],other = []};

get_companion_stage(7,10,5) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,12240},{2,244800},{3,6120},{4,6120}],other = []};

get_companion_stage(7,10,6) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,12300},{2,246000},{3,6150},{4,6150}],other = []};

get_companion_stage(7,10,7) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,12360},{2,247200},{3,6180},{4,6180}],other = []};

get_companion_stage(7,10,8) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,12420},{2,248400},{3,6210},{4,6210}],other = []};

get_companion_stage(7,10,9) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(7,10,10) ->
	#base_companion_stage{companion_id = 7,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,12600},{2,252000},{3,6300},{4,6300}],other = []};

get_companion_stage(7,11,1) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,12660},{2,253200},{3,6330},{4,6330}],other = []};

get_companion_stage(7,11,2) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,12720},{2,254400},{3,6360},{4,6360}],other = []};

get_companion_stage(7,11,3) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,12780},{2,255600},{3,6390},{4,6390}],other = []};

get_companion_stage(7,11,4) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,12840},{2,256800},{3,6420},{4,6420}],other = []};

get_companion_stage(7,11,5) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,12900},{2,258000},{3,6450},{4,6450}],other = []};

get_companion_stage(7,11,6) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,12960},{2,259200},{3,6480},{4,6480}],other = []};

get_companion_stage(7,11,7) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,13020},{2,260400},{3,6510},{4,6510}],other = []};

get_companion_stage(7,11,8) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,13080},{2,261600},{3,6540},{4,6540}],other = []};

get_companion_stage(7,11,9) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,13140},{2,262800},{3,6570},{4,6570}],other = []};

get_companion_stage(7,11,10) ->
	#base_companion_stage{companion_id = 7,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,13260},{2,265200},{3,6630},{4,6630}],other = []};

get_companion_stage(7,12,1) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,13320},{2,266400},{3,6660},{4,6660}],other = []};

get_companion_stage(7,12,2) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,13380},{2,267600},{3,6690},{4,6690}],other = []};

get_companion_stage(7,12,3) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,13440},{2,268800},{3,6720},{4,6720}],other = []};

get_companion_stage(7,12,4) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,13500},{2,270000},{3,6750},{4,6750}],other = []};

get_companion_stage(7,12,5) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,13560},{2,271200},{3,6780},{4,6780}],other = []};

get_companion_stage(7,12,6) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,13620},{2,272400},{3,6810},{4,6810}],other = []};

get_companion_stage(7,12,7) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,13680},{2,273600},{3,6840},{4,6840}],other = []};

get_companion_stage(7,12,8) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,13740},{2,274800},{3,6870},{4,6870}],other = []};

get_companion_stage(7,12,9) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,13800},{2,276000},{3,6900},{4,6900}],other = []};

get_companion_stage(7,12,10) ->
	#base_companion_stage{companion_id = 7,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,13920},{2,278400},{3,6960},{4,6960}],other = []};

get_companion_stage(7,13,1) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,13980},{2,279600},{3,6990},{4,6990}],other = []};

get_companion_stage(7,13,2) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,14040},{2,280800},{3,7020},{4,7020}],other = []};

get_companion_stage(7,13,3) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,14100},{2,282000},{3,7050},{4,7050}],other = []};

get_companion_stage(7,13,4) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,14160},{2,283200},{3,7080},{4,7080}],other = []};

get_companion_stage(7,13,5) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,14220},{2,284400},{3,7110},{4,7110}],other = []};

get_companion_stage(7,13,6) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,14280},{2,285600},{3,7140},{4,7140}],other = []};

get_companion_stage(7,13,7) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,14340},{2,286800},{3,7170},{4,7170}],other = []};

get_companion_stage(7,13,8) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,14400},{2,288000},{3,7200},{4,7200}],other = []};

get_companion_stage(7,13,9) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,14460},{2,289200},{3,7230},{4,7230}],other = []};

get_companion_stage(7,13,10) ->
	#base_companion_stage{companion_id = 7,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,14580},{2,291600},{3,7290},{4,7290}],other = []};

get_companion_stage(7,14,1) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,14640},{2,292800},{3,7320},{4,7320}],other = []};

get_companion_stage(7,14,2) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,14700},{2,294000},{3,7350},{4,7350}],other = []};

get_companion_stage(7,14,3) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,14760},{2,295200},{3,7380},{4,7380}],other = []};

get_companion_stage(7,14,4) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,14820},{2,296400},{3,7410},{4,7410}],other = []};

get_companion_stage(7,14,5) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,14880},{2,297600},{3,7440},{4,7440}],other = []};

get_companion_stage(7,14,6) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,14940},{2,298800},{3,7470},{4,7470}],other = []};

get_companion_stage(7,14,7) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,15000},{2,300000},{3,7500},{4,7500}],other = []};

get_companion_stage(7,14,8) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,15060},{2,301200},{3,7530},{4,7530}],other = []};

get_companion_stage(7,14,9) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,15120},{2,302400},{3,7560},{4,7560}],other = []};

get_companion_stage(7,14,10) ->
	#base_companion_stage{companion_id = 7,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,15240},{2,304800},{3,7620},{4,7620}],other = []};

get_companion_stage(7,15,1) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,15300},{2,306000},{3,7650},{4,7650}],other = []};

get_companion_stage(7,15,2) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,15360},{2,307200},{3,7680},{4,7680}],other = []};

get_companion_stage(7,15,3) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,15420},{2,308400},{3,7710},{4,7710}],other = []};

get_companion_stage(7,15,4) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,15480},{2,309600},{3,7740},{4,7740}],other = []};

get_companion_stage(7,15,5) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,15540},{2,310800},{3,7770},{4,7770}],other = []};

get_companion_stage(7,15,6) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,15600},{2,312000},{3,7800},{4,7800}],other = []};

get_companion_stage(7,15,7) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,15660},{2,313200},{3,7830},{4,7830}],other = []};

get_companion_stage(7,15,8) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,15720},{2,314400},{3,7860},{4,7860}],other = []};

get_companion_stage(7,15,9) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,15780},{2,315600},{3,7890},{4,7890}],other = []};

get_companion_stage(7,15,10) ->
	#base_companion_stage{companion_id = 7,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,15900},{2,318000},{3,7950},{4,7950}],other = []};

get_companion_stage(7,16,1) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,15960},{2,319200},{3,7980},{4,7980}],other = []};

get_companion_stage(7,16,2) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,16020},{2,320400},{3,8010},{4,8010}],other = []};

get_companion_stage(7,16,3) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,16080},{2,321600},{3,8040},{4,8040}],other = []};

get_companion_stage(7,16,4) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,16140},{2,322800},{3,8070},{4,8070}],other = []};

get_companion_stage(7,16,5) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,16200},{2,324000},{3,8100},{4,8100}],other = []};

get_companion_stage(7,16,6) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,16260},{2,325200},{3,8130},{4,8130}],other = []};

get_companion_stage(7,16,7) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,16320},{2,326400},{3,8160},{4,8160}],other = []};

get_companion_stage(7,16,8) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,16380},{2,327600},{3,8190},{4,8190}],other = []};

get_companion_stage(7,16,9) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,16440},{2,328800},{3,8220},{4,8220}],other = []};

get_companion_stage(7,16,10) ->
	#base_companion_stage{companion_id = 7,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,16560},{2,331200},{3,8280},{4,8280}],other = []};

get_companion_stage(7,17,1) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,16620},{2,332400},{3,8310},{4,8310}],other = []};

get_companion_stage(7,17,2) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,16680},{2,333600},{3,8340},{4,8340}],other = []};

get_companion_stage(7,17,3) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,16740},{2,334800},{3,8370},{4,8370}],other = []};

get_companion_stage(7,17,4) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,16800},{2,336000},{3,8400},{4,8400}],other = []};

get_companion_stage(7,17,5) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,16860},{2,337200},{3,8430},{4,8430}],other = []};

get_companion_stage(7,17,6) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,16920},{2,338400},{3,8460},{4,8460}],other = []};

get_companion_stage(7,17,7) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,16980},{2,339600},{3,8490},{4,8490}],other = []};

get_companion_stage(7,17,8) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,17040},{2,340800},{3,8520},{4,8520}],other = []};

get_companion_stage(7,17,9) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,17100},{2,342000},{3,8550},{4,8550}],other = []};

get_companion_stage(7,17,10) ->
	#base_companion_stage{companion_id = 7,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,17220},{2,344400},{3,8610},{4,8610}],other = []};

get_companion_stage(7,18,1) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,17280},{2,345600},{3,8640},{4,8640}],other = []};

get_companion_stage(7,18,2) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,17340},{2,346800},{3,8670},{4,8670}],other = []};

get_companion_stage(7,18,3) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,17400},{2,348000},{3,8700},{4,8700}],other = []};

get_companion_stage(7,18,4) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,17460},{2,349200},{3,8730},{4,8730}],other = []};

get_companion_stage(7,18,5) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,17520},{2,350400},{3,8760},{4,8760}],other = []};

get_companion_stage(7,18,6) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,17580},{2,351600},{3,8790},{4,8790}],other = []};

get_companion_stage(7,18,7) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,17640},{2,352800},{3,8820},{4,8820}],other = []};

get_companion_stage(7,18,8) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,17700},{2,354000},{3,8850},{4,8850}],other = []};

get_companion_stage(7,18,9) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,17760},{2,355200},{3,8880},{4,8880}],other = []};

get_companion_stage(7,18,10) ->
	#base_companion_stage{companion_id = 7,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,17880},{2,357600},{3,8940},{4,8940}],other = []};

get_companion_stage(7,19,1) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,17940},{2,358800},{3,8970},{4,8970}],other = []};

get_companion_stage(7,19,2) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,18000},{2,360000},{3,9000},{4,9000}],other = []};

get_companion_stage(7,19,3) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,18060},{2,361200},{3,9030},{4,9030}],other = []};

get_companion_stage(7,19,4) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,18120},{2,362400},{3,9060},{4,9060}],other = []};

get_companion_stage(7,19,5) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,18180},{2,363600},{3,9090},{4,9090}],other = []};

get_companion_stage(7,19,6) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,18240},{2,364800},{3,9120},{4,9120}],other = []};

get_companion_stage(7,19,7) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,18300},{2,366000},{3,9150},{4,9150}],other = []};

get_companion_stage(7,19,8) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,18360},{2,367200},{3,9180},{4,9180}],other = []};

get_companion_stage(7,19,9) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,18420},{2,368400},{3,9210},{4,9210}],other = []};

get_companion_stage(7,19,10) ->
	#base_companion_stage{companion_id = 7,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,18540},{2,370800},{3,9270},{4,9270}],other = []};

get_companion_stage(7,20,1) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,18600},{2,372000},{3,9300},{4,9300}],other = []};

get_companion_stage(7,20,2) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,18660},{2,373200},{3,9330},{4,9330}],other = []};

get_companion_stage(7,20,3) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,18720},{2,374400},{3,9360},{4,9360}],other = []};

get_companion_stage(7,20,4) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,18780},{2,375600},{3,9390},{4,9390}],other = []};

get_companion_stage(7,20,5) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,18840},{2,376800},{3,9420},{4,9420}],other = []};

get_companion_stage(7,20,6) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,18900},{2,378000},{3,9450},{4,9450}],other = []};

get_companion_stage(7,20,7) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,18960},{2,379200},{3,9480},{4,9480}],other = []};

get_companion_stage(7,20,8) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,19020},{2,380400},{3,9510},{4,9510}],other = []};

get_companion_stage(7,20,9) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,19080},{2,381600},{3,9540},{4,9540}],other = []};

get_companion_stage(7,20,10) ->
	#base_companion_stage{companion_id = 7,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,19200},{2,384000},{3,9600},{4,9600}],other = []};

get_companion_stage(7,21,1) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,19260},{2,385200},{3,9630},{4,9630}],other = []};

get_companion_stage(7,21,2) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,19320},{2,386400},{3,9660},{4,9660}],other = []};

get_companion_stage(7,21,3) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,19380},{2,387600},{3,9690},{4,9690}],other = []};

get_companion_stage(7,21,4) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,19440},{2,388800},{3,9720},{4,9720}],other = []};

get_companion_stage(7,21,5) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,19500},{2,390000},{3,9750},{4,9750}],other = []};

get_companion_stage(7,21,6) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,19560},{2,391200},{3,9780},{4,9780}],other = []};

get_companion_stage(7,21,7) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,19620},{2,392400},{3,9810},{4,9810}],other = []};

get_companion_stage(7,21,8) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,19680},{2,393600},{3,9840},{4,9840}],other = []};

get_companion_stage(7,21,9) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,19740},{2,394800},{3,9870},{4,9870}],other = []};

get_companion_stage(7,21,10) ->
	#base_companion_stage{companion_id = 7,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,19860},{2,397200},{3,9930},{4,9930}],other = []};

get_companion_stage(7,22,1) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,19920},{2,398400},{3,9960},{4,9960}],other = []};

get_companion_stage(7,22,2) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,19980},{2,399600},{3,9990},{4,9990}],other = []};

get_companion_stage(7,22,3) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,20040},{2,400800},{3,10020},{4,10020}],other = []};

get_companion_stage(7,22,4) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,20100},{2,402000},{3,10050},{4,10050}],other = []};

get_companion_stage(7,22,5) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,20160},{2,403200},{3,10080},{4,10080}],other = []};

get_companion_stage(7,22,6) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,20220},{2,404400},{3,10110},{4,10110}],other = []};

get_companion_stage(7,22,7) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,20280},{2,405600},{3,10140},{4,10140}],other = []};

get_companion_stage(7,22,8) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,20340},{2,406800},{3,10170},{4,10170}],other = []};

get_companion_stage(7,22,9) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,20400},{2,408000},{3,10200},{4,10200}],other = []};

get_companion_stage(7,22,10) ->
	#base_companion_stage{companion_id = 7,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,20520},{2,410400},{3,10260},{4,10260}],other = []};

get_companion_stage(7,23,1) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,20580},{2,411600},{3,10290},{4,10290}],other = []};

get_companion_stage(7,23,2) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,20640},{2,412800},{3,10320},{4,10320}],other = []};

get_companion_stage(7,23,3) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,20700},{2,414000},{3,10350},{4,10350}],other = []};

get_companion_stage(7,23,4) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,20760},{2,415200},{3,10380},{4,10380}],other = []};

get_companion_stage(7,23,5) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,20820},{2,416400},{3,10410},{4,10410}],other = []};

get_companion_stage(7,23,6) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,20880},{2,417600},{3,10440},{4,10440}],other = []};

get_companion_stage(7,23,7) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,20940},{2,418800},{3,10470},{4,10470}],other = []};

get_companion_stage(7,23,8) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,21000},{2,420000},{3,10500},{4,10500}],other = []};

get_companion_stage(7,23,9) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,21060},{2,421200},{3,10530},{4,10530}],other = []};

get_companion_stage(7,23,10) ->
	#base_companion_stage{companion_id = 7,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,21180},{2,423600},{3,10590},{4,10590}],other = []};

get_companion_stage(7,24,1) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,21240},{2,424800},{3,10620},{4,10620}],other = []};

get_companion_stage(7,24,2) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,21300},{2,426000},{3,10650},{4,10650}],other = []};

get_companion_stage(7,24,3) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,21360},{2,427200},{3,10680},{4,10680}],other = []};

get_companion_stage(7,24,4) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,21420},{2,428400},{3,10710},{4,10710}],other = []};

get_companion_stage(7,24,5) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,21480},{2,429600},{3,10740},{4,10740}],other = []};

get_companion_stage(7,24,6) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,21540},{2,430800},{3,10770},{4,10770}],other = []};

get_companion_stage(7,24,7) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,21600},{2,432000},{3,10800},{4,10800}],other = []};

get_companion_stage(7,24,8) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,21660},{2,433200},{3,10830},{4,10830}],other = []};

get_companion_stage(7,24,9) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,21720},{2,434400},{3,10860},{4,10860}],other = []};

get_companion_stage(7,24,10) ->
	#base_companion_stage{companion_id = 7,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,21840},{2,436800},{3,10920},{4,10920}],other = []};

get_companion_stage(7,25,1) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,21900},{2,438000},{3,10950},{4,10950}],other = []};

get_companion_stage(7,25,2) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,21960},{2,439200},{3,10980},{4,10980}],other = []};

get_companion_stage(7,25,3) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,22020},{2,440400},{3,11010},{4,11010}],other = []};

get_companion_stage(7,25,4) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,22080},{2,441600},{3,11040},{4,11040}],other = []};

get_companion_stage(7,25,5) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,22140},{2,442800},{3,11070},{4,11070}],other = []};

get_companion_stage(7,25,6) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,22200},{2,444000},{3,11100},{4,11100}],other = []};

get_companion_stage(7,25,7) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,22260},{2,445200},{3,11130},{4,11130}],other = []};

get_companion_stage(7,25,8) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,22320},{2,446400},{3,11160},{4,11160}],other = []};

get_companion_stage(7,25,9) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,22380},{2,447600},{3,11190},{4,11190}],other = []};

get_companion_stage(7,25,10) ->
	#base_companion_stage{companion_id = 7,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,22500},{2,450000},{3,11250},{4,11250}],other = []};

get_companion_stage(7,26,1) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,22560},{2,451200},{3,11280},{4,11280}],other = []};

get_companion_stage(7,26,2) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,22620},{2,452400},{3,11310},{4,11310}],other = []};

get_companion_stage(7,26,3) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,22680},{2,453600},{3,11340},{4,11340}],other = []};

get_companion_stage(7,26,4) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,22740},{2,454800},{3,11370},{4,11370}],other = []};

get_companion_stage(7,26,5) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,22800},{2,456000},{3,11400},{4,11400}],other = []};

get_companion_stage(7,26,6) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,22860},{2,457200},{3,11430},{4,11430}],other = []};

get_companion_stage(7,26,7) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,22920},{2,458400},{3,11460},{4,11460}],other = []};

get_companion_stage(7,26,8) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,22980},{2,459600},{3,11490},{4,11490}],other = []};

get_companion_stage(7,26,9) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,23040},{2,460800},{3,11520},{4,11520}],other = []};

get_companion_stage(7,26,10) ->
	#base_companion_stage{companion_id = 7,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,23160},{2,463200},{3,11580},{4,11580}],other = []};

get_companion_stage(7,27,1) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,23220},{2,464400},{3,11610},{4,11610}],other = []};

get_companion_stage(7,27,2) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,23280},{2,465600},{3,11640},{4,11640}],other = []};

get_companion_stage(7,27,3) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,23340},{2,466800},{3,11670},{4,11670}],other = []};

get_companion_stage(7,27,4) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,23400},{2,468000},{3,11700},{4,11700}],other = []};

get_companion_stage(7,27,5) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,23460},{2,469200},{3,11730},{4,11730}],other = []};

get_companion_stage(7,27,6) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,23520},{2,470400},{3,11760},{4,11760}],other = []};

get_companion_stage(7,27,7) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,23580},{2,471600},{3,11790},{4,11790}],other = []};

get_companion_stage(7,27,8) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,23640},{2,472800},{3,11820},{4,11820}],other = []};

get_companion_stage(7,27,9) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,23700},{2,474000},{3,11850},{4,11850}],other = []};

get_companion_stage(7,27,10) ->
	#base_companion_stage{companion_id = 7,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,23820},{2,476400},{3,11910},{4,11910}],other = []};

get_companion_stage(7,28,1) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,23880},{2,477600},{3,11940},{4,11940}],other = []};

get_companion_stage(7,28,2) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,23940},{2,478800},{3,11970},{4,11970}],other = []};

get_companion_stage(7,28,3) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,24000},{2,480000},{3,12000},{4,12000}],other = []};

get_companion_stage(7,28,4) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,24060},{2,481200},{3,12030},{4,12030}],other = []};

get_companion_stage(7,28,5) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,24120},{2,482400},{3,12060},{4,12060}],other = []};

get_companion_stage(7,28,6) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,24180},{2,483600},{3,12090},{4,12090}],other = []};

get_companion_stage(7,28,7) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,24240},{2,484800},{3,12120},{4,12120}],other = []};

get_companion_stage(7,28,8) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,24300},{2,486000},{3,12150},{4,12150}],other = []};

get_companion_stage(7,28,9) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,24360},{2,487200},{3,12180},{4,12180}],other = []};

get_companion_stage(7,28,10) ->
	#base_companion_stage{companion_id = 7,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,24480},{2,489600},{3,12240},{4,12240}],other = []};

get_companion_stage(7,29,1) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,24540},{2,490800},{3,12270},{4,12270}],other = []};

get_companion_stage(7,29,2) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,24600},{2,492000},{3,12300},{4,12300}],other = []};

get_companion_stage(7,29,3) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,24660},{2,493200},{3,12330},{4,12330}],other = []};

get_companion_stage(7,29,4) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,24720},{2,494400},{3,12360},{4,12360}],other = []};

get_companion_stage(7,29,5) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,24780},{2,495600},{3,12390},{4,12390}],other = []};

get_companion_stage(7,29,6) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,24840},{2,496800},{3,12420},{4,12420}],other = []};

get_companion_stage(7,29,7) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,24900},{2,498000},{3,12450},{4,12450}],other = []};

get_companion_stage(7,29,8) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,24960},{2,499200},{3,12480},{4,12480}],other = []};

get_companion_stage(7,29,9) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,25020},{2,500400},{3,12510},{4,12510}],other = []};

get_companion_stage(7,29,10) ->
	#base_companion_stage{companion_id = 7,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,25140},{2,502800},{3,12570},{4,12570}],other = []};

get_companion_stage(7,30,1) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,25200},{2,504000},{3,12600},{4,12600}],other = []};

get_companion_stage(7,30,2) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,25260},{2,505200},{3,12630},{4,12630}],other = []};

get_companion_stage(7,30,3) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,25320},{2,506400},{3,12660},{4,12660}],other = []};

get_companion_stage(7,30,4) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,25380},{2,507600},{3,12690},{4,12690}],other = []};

get_companion_stage(7,30,5) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 5,biography = 0,need_blessing = 1647,attr = [{1,25440},{2,508800},{3,12720},{4,12720}],other = []};

get_companion_stage(7,30,6) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 6,biography = 0,need_blessing = 1654,attr = [{1,25500},{2,510000},{3,12750},{4,12750}],other = []};

get_companion_stage(7,30,7) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 7,biography = 0,need_blessing = 1661,attr = [{1,25560},{2,511200},{3,12780},{4,12780}],other = []};

get_companion_stage(7,30,8) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 8,biography = 0,need_blessing = 1668,attr = [{1,25620},{2,512400},{3,12810},{4,12810}],other = []};

get_companion_stage(7,30,9) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 9,biography = 0,need_blessing = 1675,attr = [{1,25680},{2,513600},{3,12840},{4,12840}],other = []};

get_companion_stage(7,30,10) ->
	#base_companion_stage{companion_id = 7,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,25800},{2,516000},{3,12900},{4,12900}],other = []};

get_companion_stage(8,1,0) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],other = []};

get_companion_stage(8,1,1) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,6050},{2,121000},{3,3025},{4,3025}],other = []};

get_companion_stage(8,1,2) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,6100},{2,122000},{3,3050},{4,3050}],other = []};

get_companion_stage(8,1,3) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 3,biography = 0,need_blessing = 16,attr = [{1,6150},{2,123000},{3,3075},{4,3075}],other = []};

get_companion_stage(8,1,4) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 4,biography = 0,need_blessing = 18,attr = [{1,6200},{2,124000},{3,3100},{4,3100}],other = []};

get_companion_stage(8,1,5) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 5,biography = 0,need_blessing = 20,attr = [{1,6250},{2,125000},{3,3125},{4,3125}],other = []};

get_companion_stage(8,1,6) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 6,biography = 0,need_blessing = 22,attr = [{1,6300},{2,126000},{3,3150},{4,3150}],other = []};

get_companion_stage(8,1,7) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 7,biography = 0,need_blessing = 25,attr = [{1,6350},{2,127000},{3,3175},{4,3175}],other = []};

get_companion_stage(8,1,8) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 8,biography = 0,need_blessing = 27,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],other = []};

get_companion_stage(8,1,9) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 9,biography = 0,need_blessing = 30,attr = [{1,6450},{2,129000},{3,3225},{4,3225}],other = []};

get_companion_stage(8,1,10) ->
	#base_companion_stage{companion_id = 8,stage = 1,star = 10,biography = 1,need_blessing = 33,attr = [{1,6550},{2,131000},{3,3275},{4,3275}],other = [{biog_reward, [{2,0,100},{0, 22030008, 3},{0, 22030108, 1}]}]};

get_companion_stage(8,2,1) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 1,biography = 0,need_blessing = 36,attr = [{1,6600},{2,132000},{3,3300},{4,3300}],other = []};

get_companion_stage(8,2,2) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 2,biography = 0,need_blessing = 38,attr = [{1,6650},{2,133000},{3,3325},{4,3325}],other = []};

get_companion_stage(8,2,3) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 3,biography = 0,need_blessing = 41,attr = [{1,6700},{2,134000},{3,3350},{4,3350}],other = []};

get_companion_stage(8,2,4) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 4,biography = 0,need_blessing = 44,attr = [{1,6750},{2,135000},{3,3375},{4,3375}],other = []};

get_companion_stage(8,2,5) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 5,biography = 0,need_blessing = 47,attr = [{1,6800},{2,136000},{3,3400},{4,3400}],other = []};

get_companion_stage(8,2,6) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 6,biography = 0,need_blessing = 50,attr = [{1,6850},{2,137000},{3,3425},{4,3425}],other = []};

get_companion_stage(8,2,7) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 7,biography = 0,need_blessing = 53,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],other = []};

get_companion_stage(8,2,8) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 8,biography = 0,need_blessing = 57,attr = [{1,6950},{2,139000},{3,3475},{4,3475}],other = []};

get_companion_stage(8,2,9) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 9,biography = 0,need_blessing = 60,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],other = []};

get_companion_stage(8,2,10) ->
	#base_companion_stage{companion_id = 8,stage = 2,star = 10,biography = 0,need_blessing = 63,attr = [{1,7100},{2,142000},{3,3550},{4,3550}],other = []};

get_companion_stage(8,3,1) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 1,biography = 0,need_blessing = 66,attr = [{1,7150},{2,143000},{3,3575},{4,3575}],other = []};

get_companion_stage(8,3,2) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 2,biography = 0,need_blessing = 70,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],other = []};

get_companion_stage(8,3,3) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 3,biography = 0,need_blessing = 73,attr = [{1,7250},{2,145000},{3,3625},{4,3625}],other = []};

get_companion_stage(8,3,4) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 4,biography = 0,need_blessing = 77,attr = [{1,7300},{2,146000},{3,3650},{4,3650}],other = []};

get_companion_stage(8,3,5) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 5,biography = 0,need_blessing = 80,attr = [{1,7350},{2,147000},{3,3675},{4,3675}],other = []};

get_companion_stage(8,3,6) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 6,biography = 0,need_blessing = 84,attr = [{1,7400},{2,148000},{3,3700},{4,3700}],other = []};

get_companion_stage(8,3,7) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 7,biography = 0,need_blessing = 87,attr = [{1,7450},{2,149000},{3,3725},{4,3725}],other = []};

get_companion_stage(8,3,8) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 8,biography = 0,need_blessing = 91,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],other = []};

get_companion_stage(8,3,9) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 9,biography = 0,need_blessing = 94,attr = [{1,7550},{2,151000},{3,3775},{4,3775}],other = []};

get_companion_stage(8,3,10) ->
	#base_companion_stage{companion_id = 8,stage = 3,star = 10,biography = 2,need_blessing = 98,attr = [{1,7650},{2,153000},{3,3825},{4,3825}],other = [{biog_reward, [{2,0,200},{0, 22030008, 5},{0, 22030108, 3}]}]};

get_companion_stage(8,4,1) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 1,biography = 0,need_blessing = 102,attr = [{1,7700},{2,154000},{3,3850},{4,3850}],other = []};

get_companion_stage(8,4,2) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 2,biography = 0,need_blessing = 105,attr = [{1,7750},{2,155000},{3,3875},{4,3875}],other = []};

get_companion_stage(8,4,3) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 3,biography = 0,need_blessing = 109,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],other = []};

get_companion_stage(8,4,4) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 4,biography = 0,need_blessing = 113,attr = [{1,7850},{2,157000},{3,3925},{4,3925}],other = []};

get_companion_stage(8,4,5) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 5,biography = 0,need_blessing = 117,attr = [{1,7900},{2,158000},{3,3950},{4,3950}],other = []};

get_companion_stage(8,4,6) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 6,biography = 0,need_blessing = 121,attr = [{1,7950},{2,159000},{3,3975},{4,3975}],other = []};

get_companion_stage(8,4,7) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 7,biography = 0,need_blessing = 125,attr = [{1,8000},{2,160000},{3,4000},{4,4000}],other = []};

get_companion_stage(8,4,8) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 8,biography = 0,need_blessing = 128,attr = [{1,8050},{2,161000},{3,4025},{4,4025}],other = []};

get_companion_stage(8,4,9) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 9,biography = 0,need_blessing = 132,attr = [{1,8100},{2,162000},{3,4050},{4,4050}],other = []};

get_companion_stage(8,4,10) ->
	#base_companion_stage{companion_id = 8,stage = 4,star = 10,biography = 0,need_blessing = 136,attr = [{1,8200},{2,164000},{3,4100},{4,4100}],other = []};

get_companion_stage(8,5,1) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 1,biography = 0,need_blessing = 140,attr = [{1,8250},{2,165000},{3,4125},{4,4125}],other = []};

get_companion_stage(8,5,2) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 2,biography = 0,need_blessing = 144,attr = [{1,8300},{2,166000},{3,4150},{4,4150}],other = []};

get_companion_stage(8,5,3) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 3,biography = 0,need_blessing = 148,attr = [{1,8350},{2,167000},{3,4175},{4,4175}],other = []};

get_companion_stage(8,5,4) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 4,biography = 0,need_blessing = 153,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(8,5,5) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 5,biography = 0,need_blessing = 157,attr = [{1,8450},{2,169000},{3,4225},{4,4225}],other = []};

get_companion_stage(8,5,6) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 6,biography = 0,need_blessing = 161,attr = [{1,8500},{2,170000},{3,4250},{4,4250}],other = []};

get_companion_stage(8,5,7) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 7,biography = 0,need_blessing = 165,attr = [{1,8550},{2,171000},{3,4275},{4,4275}],other = []};

get_companion_stage(8,5,8) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 8,biography = 0,need_blessing = 169,attr = [{1,8600},{2,172000},{3,4300},{4,4300}],other = []};

get_companion_stage(8,5,9) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 9,biography = 0,need_blessing = 173,attr = [{1,8650},{2,173000},{3,4325},{4,4325}],other = []};

get_companion_stage(8,5,10) ->
	#base_companion_stage{companion_id = 8,stage = 5,star = 10,biography = 3,need_blessing = 178,attr = [{1,8750},{2,175000},{3,4375},{4,4375}],other = [{biog_reward, [{2,0,250},{0, 22030008, 10},{0, 22030108, 5}]}]};

get_companion_stage(8,6,1) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 1,biography = 0,need_blessing = 182,attr = [{1,8800},{2,176000},{3,4400},{4,4400}],other = []};

get_companion_stage(8,6,2) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 2,biography = 0,need_blessing = 186,attr = [{1,8850},{2,177000},{3,4425},{4,4425}],other = []};

get_companion_stage(8,6,3) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 3,biography = 0,need_blessing = 191,attr = [{1,8900},{2,178000},{3,4450},{4,4450}],other = []};

get_companion_stage(8,6,4) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 4,biography = 0,need_blessing = 195,attr = [{1,8950},{2,179000},{3,4475},{4,4475}],other = []};

get_companion_stage(8,6,5) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 5,biography = 0,need_blessing = 199,attr = [{1,9000},{2,180000},{3,4500},{4,4500}],other = []};

get_companion_stage(8,6,6) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 6,biography = 0,need_blessing = 204,attr = [{1,9050},{2,181000},{3,4525},{4,4525}],other = []};

get_companion_stage(8,6,7) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 7,biography = 0,need_blessing = 208,attr = [{1,9100},{2,182000},{3,4550},{4,4550}],other = []};

get_companion_stage(8,6,8) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 8,biography = 0,need_blessing = 212,attr = [{1,9150},{2,183000},{3,4575},{4,4575}],other = []};

get_companion_stage(8,6,9) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 9,biography = 0,need_blessing = 217,attr = [{1,9200},{2,184000},{3,4600},{4,4600}],other = []};

get_companion_stage(8,6,10) ->
	#base_companion_stage{companion_id = 8,stage = 6,star = 10,biography = 0,need_blessing = 221,attr = [{1,9300},{2,186000},{3,4650},{4,4650}],other = []};

get_companion_stage(8,7,1) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 1,biography = 0,need_blessing = 226,attr = [{1,9350},{2,187000},{3,4675},{4,4675}],other = []};

get_companion_stage(8,7,2) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 2,biography = 0,need_blessing = 230,attr = [{1,9400},{2,188000},{3,4700},{4,4700}],other = []};

get_companion_stage(8,7,3) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 3,biography = 0,need_blessing = 235,attr = [{1,9450},{2,189000},{3,4725},{4,4725}],other = []};

get_companion_stage(8,7,4) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 4,biography = 0,need_blessing = 239,attr = [{1,9500},{2,190000},{3,4750},{4,4750}],other = []};

get_companion_stage(8,7,5) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 5,biography = 0,need_blessing = 244,attr = [{1,9550},{2,191000},{3,4775},{4,4775}],other = []};

get_companion_stage(8,7,6) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 6,biography = 0,need_blessing = 249,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(8,7,7) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 7,biography = 0,need_blessing = 253,attr = [{1,9650},{2,193000},{3,4825},{4,4825}],other = []};

get_companion_stage(8,7,8) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 8,biography = 0,need_blessing = 258,attr = [{1,9700},{2,194000},{3,4850},{4,4850}],other = []};

get_companion_stage(8,7,9) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 9,biography = 0,need_blessing = 263,attr = [{1,9750},{2,195000},{3,4875},{4,4875}],other = []};

get_companion_stage(8,7,10) ->
	#base_companion_stage{companion_id = 8,stage = 7,star = 10,biography = 0,need_blessing = 267,attr = [{1,9850},{2,197000},{3,4925},{4,4925}],other = []};

get_companion_stage(8,8,1) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 1,biography = 0,need_blessing = 272,attr = [{1,9900},{2,198000},{3,4950},{4,4950}],other = []};

get_companion_stage(8,8,2) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 2,biography = 0,need_blessing = 277,attr = [{1,9950},{2,199000},{3,4975},{4,4975}],other = []};

get_companion_stage(8,8,3) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 3,biography = 0,need_blessing = 281,attr = [{1,10000},{2,200000},{3,5000},{4,5000}],other = []};

get_companion_stage(8,8,4) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 4,biography = 0,need_blessing = 286,attr = [{1,10050},{2,201000},{3,5025},{4,5025}],other = []};

get_companion_stage(8,8,5) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 5,biography = 0,need_blessing = 291,attr = [{1,10100},{2,202000},{3,5050},{4,5050}],other = []};

get_companion_stage(8,8,6) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 6,biography = 0,need_blessing = 296,attr = [{1,10150},{2,203000},{3,5075},{4,5075}],other = []};

get_companion_stage(8,8,7) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 7,biography = 0,need_blessing = 301,attr = [{1,10200},{2,204000},{3,5100},{4,5100}],other = []};

get_companion_stage(8,8,8) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 8,biography = 0,need_blessing = 305,attr = [{1,10250},{2,205000},{3,5125},{4,5125}],other = []};

get_companion_stage(8,8,9) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 9,biography = 0,need_blessing = 310,attr = [{1,10300},{2,206000},{3,5150},{4,5150}],other = []};

get_companion_stage(8,8,10) ->
	#base_companion_stage{companion_id = 8,stage = 8,star = 10,biography = 0,need_blessing = 315,attr = [{1,10400},{2,208000},{3,5200},{4,5200}],other = []};

get_companion_stage(8,9,1) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 1,biography = 0,need_blessing = 320,attr = [{1,10450},{2,209000},{3,5225},{4,5225}],other = []};

get_companion_stage(8,9,2) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 2,biography = 0,need_blessing = 325,attr = [{1,10500},{2,210000},{3,5250},{4,5250}],other = []};

get_companion_stage(8,9,3) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 3,biography = 0,need_blessing = 330,attr = [{1,10550},{2,211000},{3,5275},{4,5275}],other = []};

get_companion_stage(8,9,4) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 4,biography = 0,need_blessing = 335,attr = [{1,10600},{2,212000},{3,5300},{4,5300}],other = []};

get_companion_stage(8,9,5) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 5,biography = 0,need_blessing = 340,attr = [{1,10650},{2,213000},{3,5325},{4,5325}],other = []};

get_companion_stage(8,9,6) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 6,biography = 0,need_blessing = 345,attr = [{1,10700},{2,214000},{3,5350},{4,5350}],other = []};

get_companion_stage(8,9,7) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 7,biography = 0,need_blessing = 350,attr = [{1,10750},{2,215000},{3,5375},{4,5375}],other = []};

get_companion_stage(8,9,8) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 8,biography = 0,need_blessing = 355,attr = [{1,10800},{2,216000},{3,5400},{4,5400}],other = []};

get_companion_stage(8,9,9) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 9,biography = 0,need_blessing = 360,attr = [{1,10850},{2,217000},{3,5425},{4,5425}],other = []};

get_companion_stage(8,9,10) ->
	#base_companion_stage{companion_id = 8,stage = 9,star = 10,biography = 0,need_blessing = 365,attr = [{1,10950},{2,219000},{3,5475},{4,5475}],other = []};

get_companion_stage(8,10,1) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 1,biography = 0,need_blessing = 370,attr = [{1,11000},{2,220000},{3,5500},{4,5500}],other = []};

get_companion_stage(8,10,2) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 2,biography = 0,need_blessing = 375,attr = [{1,11050},{2,221000},{3,5525},{4,5525}],other = []};

get_companion_stage(8,10,3) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 3,biography = 0,need_blessing = 380,attr = [{1,11100},{2,222000},{3,5550},{4,5550}],other = []};

get_companion_stage(8,10,4) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 4,biography = 0,need_blessing = 385,attr = [{1,11150},{2,223000},{3,5575},{4,5575}],other = []};

get_companion_stage(8,10,5) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 5,biography = 0,need_blessing = 390,attr = [{1,11200},{2,224000},{3,5600},{4,5600}],other = []};

get_companion_stage(8,10,6) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 6,biography = 0,need_blessing = 395,attr = [{1,11250},{2,225000},{3,5625},{4,5625}],other = []};

get_companion_stage(8,10,7) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 7,biography = 0,need_blessing = 400,attr = [{1,11300},{2,226000},{3,5650},{4,5650}],other = []};

get_companion_stage(8,10,8) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 8,biography = 0,need_blessing = 406,attr = [{1,11350},{2,227000},{3,5675},{4,5675}],other = []};

get_companion_stage(8,10,9) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 9,biography = 0,need_blessing = 411,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = []};

get_companion_stage(8,10,10) ->
	#base_companion_stage{companion_id = 8,stage = 10,star = 10,biography = 0,need_blessing = 416,attr = [{1,11500},{2,230000},{3,5750},{4,5750}],other = []};

get_companion_stage(8,11,1) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 1,biography = 0,need_blessing = 421,attr = [{1,11550},{2,231000},{3,5775},{4,5775}],other = []};

get_companion_stage(8,11,2) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 2,biography = 0,need_blessing = 426,attr = [{1,11600},{2,232000},{3,5800},{4,5800}],other = []};

get_companion_stage(8,11,3) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 3,biography = 0,need_blessing = 432,attr = [{1,11650},{2,233000},{3,5825},{4,5825}],other = []};

get_companion_stage(8,11,4) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 4,biography = 0,need_blessing = 437,attr = [{1,11700},{2,234000},{3,5850},{4,5850}],other = []};

get_companion_stage(8,11,5) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 5,biography = 0,need_blessing = 442,attr = [{1,11750},{2,235000},{3,5875},{4,5875}],other = []};

get_companion_stage(8,11,6) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 6,biography = 0,need_blessing = 447,attr = [{1,11800},{2,236000},{3,5900},{4,5900}],other = []};

get_companion_stage(8,11,7) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 7,biography = 0,need_blessing = 453,attr = [{1,11850},{2,237000},{3,5925},{4,5925}],other = []};

get_companion_stage(8,11,8) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 8,biography = 0,need_blessing = 458,attr = [{1,11900},{2,238000},{3,5950},{4,5950}],other = []};

get_companion_stage(8,11,9) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 9,biography = 0,need_blessing = 463,attr = [{1,11950},{2,239000},{3,5975},{4,5975}],other = []};

get_companion_stage(8,11,10) ->
	#base_companion_stage{companion_id = 8,stage = 11,star = 10,biography = 0,need_blessing = 469,attr = [{1,12050},{2,241000},{3,6025},{4,6025}],other = []};

get_companion_stage(8,12,1) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 1,biography = 0,need_blessing = 474,attr = [{1,12100},{2,242000},{3,6050},{4,6050}],other = []};

get_companion_stage(8,12,2) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 2,biography = 0,need_blessing = 480,attr = [{1,12150},{2,243000},{3,6075},{4,6075}],other = []};

get_companion_stage(8,12,3) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 3,biography = 0,need_blessing = 485,attr = [{1,12200},{2,244000},{3,6100},{4,6100}],other = []};

get_companion_stage(8,12,4) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 4,biography = 0,need_blessing = 490,attr = [{1,12250},{2,245000},{3,6125},{4,6125}],other = []};

get_companion_stage(8,12,5) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 5,biography = 0,need_blessing = 496,attr = [{1,12300},{2,246000},{3,6150},{4,6150}],other = []};

get_companion_stage(8,12,6) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 6,biography = 0,need_blessing = 501,attr = [{1,12350},{2,247000},{3,6175},{4,6175}],other = []};

get_companion_stage(8,12,7) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 7,biography = 0,need_blessing = 507,attr = [{1,12400},{2,248000},{3,6200},{4,6200}],other = []};

get_companion_stage(8,12,8) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 8,biography = 0,need_blessing = 512,attr = [{1,12450},{2,249000},{3,6225},{4,6225}],other = []};

get_companion_stage(8,12,9) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 9,biography = 0,need_blessing = 518,attr = [{1,12500},{2,250000},{3,6250},{4,6250}],other = []};

get_companion_stage(8,12,10) ->
	#base_companion_stage{companion_id = 8,stage = 12,star = 10,biography = 0,need_blessing = 523,attr = [{1,12600},{2,252000},{3,6300},{4,6300}],other = []};

get_companion_stage(8,13,1) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 1,biography = 0,need_blessing = 529,attr = [{1,12650},{2,253000},{3,6325},{4,6325}],other = []};

get_companion_stage(8,13,2) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 2,biography = 0,need_blessing = 534,attr = [{1,12700},{2,254000},{3,6350},{4,6350}],other = []};

get_companion_stage(8,13,3) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 3,biography = 0,need_blessing = 540,attr = [{1,12750},{2,255000},{3,6375},{4,6375}],other = []};

get_companion_stage(8,13,4) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 4,biography = 0,need_blessing = 545,attr = [{1,12800},{2,256000},{3,6400},{4,6400}],other = []};

get_companion_stage(8,13,5) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 5,biography = 0,need_blessing = 551,attr = [{1,12850},{2,257000},{3,6425},{4,6425}],other = []};

get_companion_stage(8,13,6) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 6,biography = 0,need_blessing = 556,attr = [{1,12900},{2,258000},{3,6450},{4,6450}],other = []};

get_companion_stage(8,13,7) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 7,biography = 0,need_blessing = 562,attr = [{1,12950},{2,259000},{3,6475},{4,6475}],other = []};

get_companion_stage(8,13,8) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 8,biography = 0,need_blessing = 567,attr = [{1,13000},{2,260000},{3,6500},{4,6500}],other = []};

get_companion_stage(8,13,9) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 9,biography = 0,need_blessing = 573,attr = [{1,13050},{2,261000},{3,6525},{4,6525}],other = []};

get_companion_stage(8,13,10) ->
	#base_companion_stage{companion_id = 8,stage = 13,star = 10,biography = 0,need_blessing = 579,attr = [{1,13150},{2,263000},{3,6575},{4,6575}],other = []};

get_companion_stage(8,14,1) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 1,biography = 0,need_blessing = 584,attr = [{1,13200},{2,264000},{3,6600},{4,6600}],other = []};

get_companion_stage(8,14,2) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 2,biography = 0,need_blessing = 590,attr = [{1,13250},{2,265000},{3,6625},{4,6625}],other = []};

get_companion_stage(8,14,3) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 3,biography = 0,need_blessing = 596,attr = [{1,13300},{2,266000},{3,6650},{4,6650}],other = []};

get_companion_stage(8,14,4) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 4,biography = 0,need_blessing = 601,attr = [{1,13350},{2,267000},{3,6675},{4,6675}],other = []};

get_companion_stage(8,14,5) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 5,biography = 0,need_blessing = 607,attr = [{1,13400},{2,268000},{3,6700},{4,6700}],other = []};

get_companion_stage(8,14,6) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 6,biography = 0,need_blessing = 613,attr = [{1,13450},{2,269000},{3,6725},{4,6725}],other = []};

get_companion_stage(8,14,7) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 7,biography = 0,need_blessing = 618,attr = [{1,13500},{2,270000},{3,6750},{4,6750}],other = []};

get_companion_stage(8,14,8) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 8,biography = 0,need_blessing = 624,attr = [{1,13550},{2,271000},{3,6775},{4,6775}],other = []};

get_companion_stage(8,14,9) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 9,biography = 0,need_blessing = 630,attr = [{1,13600},{2,272000},{3,6800},{4,6800}],other = []};

get_companion_stage(8,14,10) ->
	#base_companion_stage{companion_id = 8,stage = 14,star = 10,biography = 0,need_blessing = 636,attr = [{1,13700},{2,274000},{3,6850},{4,6850}],other = []};

get_companion_stage(8,15,1) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 1,biography = 0,need_blessing = 641,attr = [{1,13750},{2,275000},{3,6875},{4,6875}],other = []};

get_companion_stage(8,15,2) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 2,biography = 0,need_blessing = 647,attr = [{1,13800},{2,276000},{3,6900},{4,6900}],other = []};

get_companion_stage(8,15,3) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 3,biography = 0,need_blessing = 653,attr = [{1,13850},{2,277000},{3,6925},{4,6925}],other = []};

get_companion_stage(8,15,4) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 4,biography = 0,need_blessing = 659,attr = [{1,13900},{2,278000},{3,6950},{4,6950}],other = []};

get_companion_stage(8,15,5) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 5,biography = 0,need_blessing = 664,attr = [{1,13950},{2,279000},{3,6975},{4,6975}],other = []};

get_companion_stage(8,15,6) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 6,biography = 0,need_blessing = 670,attr = [{1,14000},{2,280000},{3,7000},{4,7000}],other = []};

get_companion_stage(8,15,7) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 7,biography = 0,need_blessing = 676,attr = [{1,14050},{2,281000},{3,7025},{4,7025}],other = []};

get_companion_stage(8,15,8) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 8,biography = 0,need_blessing = 682,attr = [{1,14100},{2,282000},{3,7050},{4,7050}],other = []};

get_companion_stage(8,15,9) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 9,biography = 0,need_blessing = 688,attr = [{1,14150},{2,283000},{3,7075},{4,7075}],other = []};

get_companion_stage(8,15,10) ->
	#base_companion_stage{companion_id = 8,stage = 15,star = 10,biography = 0,need_blessing = 694,attr = [{1,14250},{2,285000},{3,7125},{4,7125}],other = []};

get_companion_stage(8,16,1) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 1,biography = 0,need_blessing = 699,attr = [{1,14300},{2,286000},{3,7150},{4,7150}],other = []};

get_companion_stage(8,16,2) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 2,biography = 0,need_blessing = 705,attr = [{1,14350},{2,287000},{3,7175},{4,7175}],other = []};

get_companion_stage(8,16,3) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 3,biography = 0,need_blessing = 711,attr = [{1,14400},{2,288000},{3,7200},{4,7200}],other = []};

get_companion_stage(8,16,4) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 4,biography = 0,need_blessing = 717,attr = [{1,14450},{2,289000},{3,7225},{4,7225}],other = []};

get_companion_stage(8,16,5) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 5,biography = 0,need_blessing = 723,attr = [{1,14500},{2,290000},{3,7250},{4,7250}],other = []};

get_companion_stage(8,16,6) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 6,biography = 0,need_blessing = 729,attr = [{1,14550},{2,291000},{3,7275},{4,7275}],other = []};

get_companion_stage(8,16,7) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 7,biography = 0,need_blessing = 735,attr = [{1,14600},{2,292000},{3,7300},{4,7300}],other = []};

get_companion_stage(8,16,8) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 8,biography = 0,need_blessing = 741,attr = [{1,14650},{2,293000},{3,7325},{4,7325}],other = []};

get_companion_stage(8,16,9) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 9,biography = 0,need_blessing = 747,attr = [{1,14700},{2,294000},{3,7350},{4,7350}],other = []};

get_companion_stage(8,16,10) ->
	#base_companion_stage{companion_id = 8,stage = 16,star = 10,biography = 0,need_blessing = 753,attr = [{1,14800},{2,296000},{3,7400},{4,7400}],other = []};

get_companion_stage(8,17,1) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 1,biography = 0,need_blessing = 759,attr = [{1,14850},{2,297000},{3,7425},{4,7425}],other = []};

get_companion_stage(8,17,2) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 2,biography = 0,need_blessing = 765,attr = [{1,14900},{2,298000},{3,7450},{4,7450}],other = []};

get_companion_stage(8,17,3) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 3,biography = 0,need_blessing = 771,attr = [{1,14950},{2,299000},{3,7475},{4,7475}],other = []};

get_companion_stage(8,17,4) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 4,biography = 0,need_blessing = 777,attr = [{1,15000},{2,300000},{3,7500},{4,7500}],other = []};

get_companion_stage(8,17,5) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 5,biography = 0,need_blessing = 783,attr = [{1,15050},{2,301000},{3,7525},{4,7525}],other = []};

get_companion_stage(8,17,6) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 6,biography = 0,need_blessing = 789,attr = [{1,15100},{2,302000},{3,7550},{4,7550}],other = []};

get_companion_stage(8,17,7) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 7,biography = 0,need_blessing = 795,attr = [{1,15150},{2,303000},{3,7575},{4,7575}],other = []};

get_companion_stage(8,17,8) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 8,biography = 0,need_blessing = 801,attr = [{1,15200},{2,304000},{3,7600},{4,7600}],other = []};

get_companion_stage(8,17,9) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 9,biography = 0,need_blessing = 807,attr = [{1,15250},{2,305000},{3,7625},{4,7625}],other = []};

get_companion_stage(8,17,10) ->
	#base_companion_stage{companion_id = 8,stage = 17,star = 10,biography = 0,need_blessing = 813,attr = [{1,15350},{2,307000},{3,7675},{4,7675}],other = []};

get_companion_stage(8,18,1) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 1,biography = 0,need_blessing = 819,attr = [{1,15400},{2,308000},{3,7700},{4,7700}],other = []};

get_companion_stage(8,18,2) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 2,biography = 0,need_blessing = 825,attr = [{1,15450},{2,309000},{3,7725},{4,7725}],other = []};

get_companion_stage(8,18,3) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 3,biography = 0,need_blessing = 832,attr = [{1,15500},{2,310000},{3,7750},{4,7750}],other = []};

get_companion_stage(8,18,4) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 4,biography = 0,need_blessing = 838,attr = [{1,15550},{2,311000},{3,7775},{4,7775}],other = []};

get_companion_stage(8,18,5) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 5,biography = 0,need_blessing = 844,attr = [{1,15600},{2,312000},{3,7800},{4,7800}],other = []};

get_companion_stage(8,18,6) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 6,biography = 0,need_blessing = 850,attr = [{1,15650},{2,313000},{3,7825},{4,7825}],other = []};

get_companion_stage(8,18,7) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 7,biography = 0,need_blessing = 856,attr = [{1,15700},{2,314000},{3,7850},{4,7850}],other = []};

get_companion_stage(8,18,8) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 8,biography = 0,need_blessing = 862,attr = [{1,15750},{2,315000},{3,7875},{4,7875}],other = []};

get_companion_stage(8,18,9) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 9,biography = 0,need_blessing = 868,attr = [{1,15800},{2,316000},{3,7900},{4,7900}],other = []};

get_companion_stage(8,18,10) ->
	#base_companion_stage{companion_id = 8,stage = 18,star = 10,biography = 0,need_blessing = 875,attr = [{1,15900},{2,318000},{3,7950},{4,7950}],other = []};

get_companion_stage(8,19,1) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 1,biography = 0,need_blessing = 881,attr = [{1,15950},{2,319000},{3,7975},{4,7975}],other = []};

get_companion_stage(8,19,2) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 2,biography = 0,need_blessing = 887,attr = [{1,16000},{2,320000},{3,8000},{4,8000}],other = []};

get_companion_stage(8,19,3) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 3,biography = 0,need_blessing = 893,attr = [{1,16050},{2,321000},{3,8025},{4,8025}],other = []};

get_companion_stage(8,19,4) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 4,biography = 0,need_blessing = 900,attr = [{1,16100},{2,322000},{3,8050},{4,8050}],other = []};

get_companion_stage(8,19,5) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 5,biography = 0,need_blessing = 906,attr = [{1,16150},{2,323000},{3,8075},{4,8075}],other = []};

get_companion_stage(8,19,6) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 6,biography = 0,need_blessing = 912,attr = [{1,16200},{2,324000},{3,8100},{4,8100}],other = []};

get_companion_stage(8,19,7) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 7,biography = 0,need_blessing = 918,attr = [{1,16250},{2,325000},{3,8125},{4,8125}],other = []};

get_companion_stage(8,19,8) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 8,biography = 0,need_blessing = 925,attr = [{1,16300},{2,326000},{3,8150},{4,8150}],other = []};

get_companion_stage(8,19,9) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 9,biography = 0,need_blessing = 931,attr = [{1,16350},{2,327000},{3,8175},{4,8175}],other = []};

get_companion_stage(8,19,10) ->
	#base_companion_stage{companion_id = 8,stage = 19,star = 10,biography = 0,need_blessing = 937,attr = [{1,16450},{2,329000},{3,8225},{4,8225}],other = []};

get_companion_stage(8,20,1) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 1,biography = 0,need_blessing = 943,attr = [{1,16500},{2,330000},{3,8250},{4,8250}],other = []};

get_companion_stage(8,20,2) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 2,biography = 0,need_blessing = 950,attr = [{1,16550},{2,331000},{3,8275},{4,8275}],other = []};

get_companion_stage(8,20,3) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 3,biography = 0,need_blessing = 956,attr = [{1,16600},{2,332000},{3,8300},{4,8300}],other = []};

get_companion_stage(8,20,4) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 4,biography = 0,need_blessing = 962,attr = [{1,16650},{2,333000},{3,8325},{4,8325}],other = []};

get_companion_stage(8,20,5) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 5,biography = 0,need_blessing = 969,attr = [{1,16700},{2,334000},{3,8350},{4,8350}],other = []};

get_companion_stage(8,20,6) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 6,biography = 0,need_blessing = 975,attr = [{1,16750},{2,335000},{3,8375},{4,8375}],other = []};

get_companion_stage(8,20,7) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 7,biography = 0,need_blessing = 981,attr = [{1,16800},{2,336000},{3,8400},{4,8400}],other = []};

get_companion_stage(8,20,8) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 8,biography = 0,need_blessing = 988,attr = [{1,16850},{2,337000},{3,8425},{4,8425}],other = []};

get_companion_stage(8,20,9) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 9,biography = 0,need_blessing = 994,attr = [{1,16900},{2,338000},{3,8450},{4,8450}],other = []};

get_companion_stage(8,20,10) ->
	#base_companion_stage{companion_id = 8,stage = 20,star = 10,biography = 0,need_blessing = 1001,attr = [{1,17000},{2,340000},{3,8500},{4,8500}],other = []};

get_companion_stage(8,21,1) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 1,biography = 0,need_blessing = 1007,attr = [{1,17050},{2,341000},{3,8525},{4,8525}],other = []};

get_companion_stage(8,21,2) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 2,biography = 0,need_blessing = 1013,attr = [{1,17100},{2,342000},{3,8550},{4,8550}],other = []};

get_companion_stage(8,21,3) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 3,biography = 0,need_blessing = 1020,attr = [{1,17150},{2,343000},{3,8575},{4,8575}],other = []};

get_companion_stage(8,21,4) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 4,biography = 0,need_blessing = 1026,attr = [{1,17200},{2,344000},{3,8600},{4,8600}],other = []};

get_companion_stage(8,21,5) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 5,biography = 0,need_blessing = 1033,attr = [{1,17250},{2,345000},{3,8625},{4,8625}],other = []};

get_companion_stage(8,21,6) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 6,biography = 0,need_blessing = 1039,attr = [{1,17300},{2,346000},{3,8650},{4,8650}],other = []};

get_companion_stage(8,21,7) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 7,biography = 0,need_blessing = 1045,attr = [{1,17350},{2,347000},{3,8675},{4,8675}],other = []};

get_companion_stage(8,21,8) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 8,biography = 0,need_blessing = 1052,attr = [{1,17400},{2,348000},{3,8700},{4,8700}],other = []};

get_companion_stage(8,21,9) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 9,biography = 0,need_blessing = 1058,attr = [{1,17450},{2,349000},{3,8725},{4,8725}],other = []};

get_companion_stage(8,21,10) ->
	#base_companion_stage{companion_id = 8,stage = 21,star = 10,biography = 0,need_blessing = 1065,attr = [{1,17550},{2,351000},{3,8775},{4,8775}],other = []};

get_companion_stage(8,22,1) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 1,biography = 0,need_blessing = 1071,attr = [{1,17600},{2,352000},{3,8800},{4,8800}],other = []};

get_companion_stage(8,22,2) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 2,biography = 0,need_blessing = 1078,attr = [{1,17650},{2,353000},{3,8825},{4,8825}],other = []};

get_companion_stage(8,22,3) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 3,biography = 0,need_blessing = 1084,attr = [{1,17700},{2,354000},{3,8850},{4,8850}],other = []};

get_companion_stage(8,22,4) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 4,biography = 0,need_blessing = 1091,attr = [{1,17750},{2,355000},{3,8875},{4,8875}],other = []};

get_companion_stage(8,22,5) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 5,biography = 0,need_blessing = 1097,attr = [{1,17800},{2,356000},{3,8900},{4,8900}],other = []};

get_companion_stage(8,22,6) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 6,biography = 0,need_blessing = 1104,attr = [{1,17850},{2,357000},{3,8925},{4,8925}],other = []};

get_companion_stage(8,22,7) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 7,biography = 0,need_blessing = 1111,attr = [{1,17900},{2,358000},{3,8950},{4,8950}],other = []};

get_companion_stage(8,22,8) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 8,biography = 0,need_blessing = 1117,attr = [{1,17950},{2,359000},{3,8975},{4,8975}],other = []};

get_companion_stage(8,22,9) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 9,biography = 0,need_blessing = 1124,attr = [{1,18000},{2,360000},{3,9000},{4,9000}],other = []};

get_companion_stage(8,22,10) ->
	#base_companion_stage{companion_id = 8,stage = 22,star = 10,biography = 0,need_blessing = 1130,attr = [{1,18100},{2,362000},{3,9050},{4,9050}],other = []};

get_companion_stage(8,23,1) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 1,biography = 0,need_blessing = 1137,attr = [{1,18150},{2,363000},{3,9075},{4,9075}],other = []};

get_companion_stage(8,23,2) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 2,biography = 0,need_blessing = 1143,attr = [{1,18200},{2,364000},{3,9100},{4,9100}],other = []};

get_companion_stage(8,23,3) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 3,biography = 0,need_blessing = 1150,attr = [{1,18250},{2,365000},{3,9125},{4,9125}],other = []};

get_companion_stage(8,23,4) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 4,biography = 0,need_blessing = 1157,attr = [{1,18300},{2,366000},{3,9150},{4,9150}],other = []};

get_companion_stage(8,23,5) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 5,biography = 0,need_blessing = 1163,attr = [{1,18350},{2,367000},{3,9175},{4,9175}],other = []};

get_companion_stage(8,23,6) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 6,biography = 0,need_blessing = 1170,attr = [{1,18400},{2,368000},{3,9200},{4,9200}],other = []};

get_companion_stage(8,23,7) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 7,biography = 0,need_blessing = 1176,attr = [{1,18450},{2,369000},{3,9225},{4,9225}],other = []};

get_companion_stage(8,23,8) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 8,biography = 0,need_blessing = 1183,attr = [{1,18500},{2,370000},{3,9250},{4,9250}],other = []};

get_companion_stage(8,23,9) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 9,biography = 0,need_blessing = 1190,attr = [{1,18550},{2,371000},{3,9275},{4,9275}],other = []};

get_companion_stage(8,23,10) ->
	#base_companion_stage{companion_id = 8,stage = 23,star = 10,biography = 0,need_blessing = 1196,attr = [{1,18650},{2,373000},{3,9325},{4,9325}],other = []};

get_companion_stage(8,24,1) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 1,biography = 0,need_blessing = 1203,attr = [{1,18700},{2,374000},{3,9350},{4,9350}],other = []};

get_companion_stage(8,24,2) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 2,biography = 0,need_blessing = 1210,attr = [{1,18750},{2,375000},{3,9375},{4,9375}],other = []};

get_companion_stage(8,24,3) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 3,biography = 0,need_blessing = 1216,attr = [{1,18800},{2,376000},{3,9400},{4,9400}],other = []};

get_companion_stage(8,24,4) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 4,biography = 0,need_blessing = 1223,attr = [{1,18850},{2,377000},{3,9425},{4,9425}],other = []};

get_companion_stage(8,24,5) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 5,biography = 0,need_blessing = 1230,attr = [{1,18900},{2,378000},{3,9450},{4,9450}],other = []};

get_companion_stage(8,24,6) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 6,biography = 0,need_blessing = 1236,attr = [{1,18950},{2,379000},{3,9475},{4,9475}],other = []};

get_companion_stage(8,24,7) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 7,biography = 0,need_blessing = 1243,attr = [{1,19000},{2,380000},{3,9500},{4,9500}],other = []};

get_companion_stage(8,24,8) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 8,biography = 0,need_blessing = 1250,attr = [{1,19050},{2,381000},{3,9525},{4,9525}],other = []};

get_companion_stage(8,24,9) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 9,biography = 0,need_blessing = 1257,attr = [{1,19100},{2,382000},{3,9550},{4,9550}],other = []};

get_companion_stage(8,24,10) ->
	#base_companion_stage{companion_id = 8,stage = 24,star = 10,biography = 0,need_blessing = 1263,attr = [{1,19200},{2,384000},{3,9600},{4,9600}],other = []};

get_companion_stage(8,25,1) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 1,biography = 0,need_blessing = 1270,attr = [{1,19250},{2,385000},{3,9625},{4,9625}],other = []};

get_companion_stage(8,25,2) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 2,biography = 0,need_blessing = 1277,attr = [{1,19300},{2,386000},{3,9650},{4,9650}],other = []};

get_companion_stage(8,25,3) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 3,biography = 0,need_blessing = 1284,attr = [{1,19350},{2,387000},{3,9675},{4,9675}],other = []};

get_companion_stage(8,25,4) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 4,biography = 0,need_blessing = 1290,attr = [{1,19400},{2,388000},{3,9700},{4,9700}],other = []};

get_companion_stage(8,25,5) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 5,biography = 0,need_blessing = 1297,attr = [{1,19450},{2,389000},{3,9725},{4,9725}],other = []};

get_companion_stage(8,25,6) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 6,biography = 0,need_blessing = 1304,attr = [{1,19500},{2,390000},{3,9750},{4,9750}],other = []};

get_companion_stage(8,25,7) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 7,biography = 0,need_blessing = 1311,attr = [{1,19550},{2,391000},{3,9775},{4,9775}],other = []};

get_companion_stage(8,25,8) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 8,biography = 0,need_blessing = 1318,attr = [{1,19600},{2,392000},{3,9800},{4,9800}],other = []};

get_companion_stage(8,25,9) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 9,biography = 0,need_blessing = 1324,attr = [{1,19650},{2,393000},{3,9825},{4,9825}],other = []};

get_companion_stage(8,25,10) ->
	#base_companion_stage{companion_id = 8,stage = 25,star = 10,biography = 0,need_blessing = 1331,attr = [{1,19750},{2,395000},{3,9875},{4,9875}],other = []};

get_companion_stage(8,26,1) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 1,biography = 0,need_blessing = 1338,attr = [{1,19800},{2,396000},{3,9900},{4,9900}],other = []};

get_companion_stage(8,26,2) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 2,biography = 0,need_blessing = 1345,attr = [{1,19850},{2,397000},{3,9925},{4,9925}],other = []};

get_companion_stage(8,26,3) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 3,biography = 0,need_blessing = 1352,attr = [{1,19900},{2,398000},{3,9950},{4,9950}],other = []};

get_companion_stage(8,26,4) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 4,biography = 0,need_blessing = 1359,attr = [{1,19950},{2,399000},{3,9975},{4,9975}],other = []};

get_companion_stage(8,26,5) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 5,biography = 0,need_blessing = 1366,attr = [{1,20000},{2,400000},{3,10000},{4,10000}],other = []};

get_companion_stage(8,26,6) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 6,biography = 0,need_blessing = 1372,attr = [{1,20050},{2,401000},{3,10025},{4,10025}],other = []};

get_companion_stage(8,26,7) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 7,biography = 0,need_blessing = 1379,attr = [{1,20100},{2,402000},{3,10050},{4,10050}],other = []};

get_companion_stage(8,26,8) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 8,biography = 0,need_blessing = 1386,attr = [{1,20150},{2,403000},{3,10075},{4,10075}],other = []};

get_companion_stage(8,26,9) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 9,biography = 0,need_blessing = 1393,attr = [{1,20200},{2,404000},{3,10100},{4,10100}],other = []};

get_companion_stage(8,26,10) ->
	#base_companion_stage{companion_id = 8,stage = 26,star = 10,biography = 0,need_blessing = 1400,attr = [{1,20300},{2,406000},{3,10150},{4,10150}],other = []};

get_companion_stage(8,27,1) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 1,biography = 0,need_blessing = 1407,attr = [{1,20350},{2,407000},{3,10175},{4,10175}],other = []};

get_companion_stage(8,27,2) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 2,biography = 0,need_blessing = 1414,attr = [{1,20400},{2,408000},{3,10200},{4,10200}],other = []};

get_companion_stage(8,27,3) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 3,biography = 0,need_blessing = 1421,attr = [{1,20450},{2,409000},{3,10225},{4,10225}],other = []};

get_companion_stage(8,27,4) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 4,biography = 0,need_blessing = 1428,attr = [{1,20500},{2,410000},{3,10250},{4,10250}],other = []};

get_companion_stage(8,27,5) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 5,biography = 0,need_blessing = 1435,attr = [{1,20550},{2,411000},{3,10275},{4,10275}],other = []};

get_companion_stage(8,27,6) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 6,biography = 0,need_blessing = 1442,attr = [{1,20600},{2,412000},{3,10300},{4,10300}],other = []};

get_companion_stage(8,27,7) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 7,biography = 0,need_blessing = 1449,attr = [{1,20650},{2,413000},{3,10325},{4,10325}],other = []};

get_companion_stage(8,27,8) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 8,biography = 0,need_blessing = 1456,attr = [{1,20700},{2,414000},{3,10350},{4,10350}],other = []};

get_companion_stage(8,27,9) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 9,biography = 0,need_blessing = 1462,attr = [{1,20750},{2,415000},{3,10375},{4,10375}],other = []};

get_companion_stage(8,27,10) ->
	#base_companion_stage{companion_id = 8,stage = 27,star = 10,biography = 0,need_blessing = 1469,attr = [{1,20850},{2,417000},{3,10425},{4,10425}],other = []};

get_companion_stage(8,28,1) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 1,biography = 0,need_blessing = 1476,attr = [{1,20900},{2,418000},{3,10450},{4,10450}],other = []};

get_companion_stage(8,28,2) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 2,biography = 0,need_blessing = 1483,attr = [{1,20950},{2,419000},{3,10475},{4,10475}],other = []};

get_companion_stage(8,28,3) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 3,biography = 0,need_blessing = 1490,attr = [{1,21000},{2,420000},{3,10500},{4,10500}],other = []};

get_companion_stage(8,28,4) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 4,biography = 0,need_blessing = 1497,attr = [{1,21050},{2,421000},{3,10525},{4,10525}],other = []};

get_companion_stage(8,28,5) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 5,biography = 0,need_blessing = 1505,attr = [{1,21100},{2,422000},{3,10550},{4,10550}],other = []};

get_companion_stage(8,28,6) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 6,biography = 0,need_blessing = 1512,attr = [{1,21150},{2,423000},{3,10575},{4,10575}],other = []};

get_companion_stage(8,28,7) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 7,biography = 0,need_blessing = 1519,attr = [{1,21200},{2,424000},{3,10600},{4,10600}],other = []};

get_companion_stage(8,28,8) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 8,biography = 0,need_blessing = 1526,attr = [{1,21250},{2,425000},{3,10625},{4,10625}],other = []};

get_companion_stage(8,28,9) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 9,biography = 0,need_blessing = 1533,attr = [{1,21300},{2,426000},{3,10650},{4,10650}],other = []};

get_companion_stage(8,28,10) ->
	#base_companion_stage{companion_id = 8,stage = 28,star = 10,biography = 0,need_blessing = 1540,attr = [{1,21400},{2,428000},{3,10700},{4,10700}],other = []};

get_companion_stage(8,29,1) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 1,biography = 0,need_blessing = 1547,attr = [{1,21450},{2,429000},{3,10725},{4,10725}],other = []};

get_companion_stage(8,29,2) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 2,biography = 0,need_blessing = 1554,attr = [{1,21500},{2,430000},{3,10750},{4,10750}],other = []};

get_companion_stage(8,29,3) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 3,biography = 0,need_blessing = 1561,attr = [{1,21550},{2,431000},{3,10775},{4,10775}],other = []};

get_companion_stage(8,29,4) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 4,biography = 0,need_blessing = 1568,attr = [{1,21600},{2,432000},{3,10800},{4,10800}],other = []};

get_companion_stage(8,29,5) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 5,biography = 0,need_blessing = 1575,attr = [{1,21650},{2,433000},{3,10825},{4,10825}],other = []};

get_companion_stage(8,29,6) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 6,biography = 0,need_blessing = 1582,attr = [{1,21700},{2,434000},{3,10850},{4,10850}],other = []};

get_companion_stage(8,29,7) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 7,biography = 0,need_blessing = 1589,attr = [{1,21750},{2,435000},{3,10875},{4,10875}],other = []};

get_companion_stage(8,29,8) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 8,biography = 0,need_blessing = 1596,attr = [{1,21800},{2,436000},{3,10900},{4,10900}],other = []};

get_companion_stage(8,29,9) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 9,biography = 0,need_blessing = 1604,attr = [{1,21850},{2,437000},{3,10925},{4,10925}],other = []};

get_companion_stage(8,29,10) ->
	#base_companion_stage{companion_id = 8,stage = 29,star = 10,biography = 0,need_blessing = 1611,attr = [{1,21950},{2,439000},{3,10975},{4,10975}],other = []};

get_companion_stage(8,30,1) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 1,biography = 0,need_blessing = 1618,attr = [{1,22000},{2,440000},{3,11000},{4,11000}],other = []};

get_companion_stage(8,30,2) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 2,biography = 0,need_blessing = 1625,attr = [{1,22050},{2,441000},{3,11025},{4,11025}],other = []};

get_companion_stage(8,30,3) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 3,biography = 0,need_blessing = 1632,attr = [{1,22100},{2,442000},{3,11050},{4,11050}],other = []};

get_companion_stage(8,30,4) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,22150},{2,443000},{3,11075},{4,11075}],other = []};

get_companion_stage(8,30,5) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,22200},{2,444000},{3,11100},{4,11100}],other = []};

get_companion_stage(8,30,6) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,22250},{2,445000},{3,11125},{4,11125}],other = []};

get_companion_stage(8,30,7) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,22300},{2,446000},{3,11150},{4,11150}],other = []};

get_companion_stage(8,30,8) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,22350},{2,447000},{3,11175},{4,11175}],other = []};

get_companion_stage(8,30,9) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,22400},{2,448000},{3,11200},{4,11200}],other = []};

get_companion_stage(8,30,10) ->
	#base_companion_stage{companion_id = 8,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,22500},{2,450000},{3,11250},{4,11250}],other = []};

get_companion_stage(9,1,0) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],other = []};

get_companion_stage(9,1,1) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,6446},{2,128920},{3,3223},{4,3223}],other = []};

get_companion_stage(9,1,2) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,6492},{2,129840},{3,3246},{4,3246}],other = []};

get_companion_stage(9,1,3) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,6538},{2,130760},{3,3269},{4,3269}],other = []};

get_companion_stage(9,1,4) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,6584},{2,131680},{3,3292},{4,3292}],other = []};

get_companion_stage(9,1,5) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,6630},{2,132600},{3,3315},{4,3315}],other = []};

get_companion_stage(9,1,6) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,6676},{2,133520},{3,3338},{4,3338}],other = []};

get_companion_stage(9,1,7) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,6722},{2,134440},{3,3361},{4,3361}],other = []};

get_companion_stage(9,1,8) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,6768},{2,135360},{3,3384},{4,3384}],other = []};

get_companion_stage(9,1,9) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,6814},{2,136280},{3,3407},{4,3407}],other = []};

get_companion_stage(9,1,10) ->
	#base_companion_stage{companion_id = 9,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,6906},{2,138120},{3,3453},{4,3453}],other = [{biog_reward, [{2,0,100},{0, 22030009, 3},{0, 22030109, 1}]}]};

get_companion_stage(9,2,1) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,6952},{2,139040},{3,3476},{4,3476}],other = []};

get_companion_stage(9,2,2) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,6998},{2,139960},{3,3499},{4,3499}],other = []};

get_companion_stage(9,2,3) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,7044},{2,140880},{3,3522},{4,3522}],other = []};

get_companion_stage(9,2,4) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,7090},{2,141800},{3,3545},{4,3545}],other = []};

get_companion_stage(9,2,5) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,7136},{2,142720},{3,3568},{4,3568}],other = []};

get_companion_stage(9,2,6) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,7182},{2,143640},{3,3591},{4,3591}],other = []};

get_companion_stage(9,2,7) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,7228},{2,144560},{3,3614},{4,3614}],other = []};

get_companion_stage(9,2,8) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,7274},{2,145480},{3,3637},{4,3637}],other = []};

get_companion_stage(9,2,9) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],other = []};

get_companion_stage(9,2,10) ->
	#base_companion_stage{companion_id = 9,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,7412},{2,148240},{3,3706},{4,3706}],other = []};

get_companion_stage(9,3,1) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,7458},{2,149160},{3,3729},{4,3729}],other = []};

get_companion_stage(9,3,2) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,7504},{2,150080},{3,3752},{4,3752}],other = []};

get_companion_stage(9,3,3) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,7550},{2,151000},{3,3775},{4,3775}],other = []};

get_companion_stage(9,3,4) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,7596},{2,151920},{3,3798},{4,3798}],other = []};

get_companion_stage(9,3,5) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,7642},{2,152840},{3,3821},{4,3821}],other = []};

get_companion_stage(9,3,6) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,7688},{2,153760},{3,3844},{4,3844}],other = []};

get_companion_stage(9,3,7) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,7734},{2,154680},{3,3867},{4,3867}],other = []};

get_companion_stage(9,3,8) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,7780},{2,155600},{3,3890},{4,3890}],other = []};

get_companion_stage(9,3,9) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,7826},{2,156520},{3,3913},{4,3913}],other = []};

get_companion_stage(9,3,10) ->
	#base_companion_stage{companion_id = 9,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,7918},{2,158360},{3,3959},{4,3959}],other = [{biog_reward, [{2,0,200},{0, 22030009, 5},{0, 22030109, 3}]}]};

get_companion_stage(9,4,1) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,7964},{2,159280},{3,3982},{4,3982}],other = []};

get_companion_stage(9,4,2) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,8010},{2,160200},{3,4005},{4,4005}],other = []};

get_companion_stage(9,4,3) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,8056},{2,161120},{3,4028},{4,4028}],other = []};

get_companion_stage(9,4,4) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,8102},{2,162040},{3,4051},{4,4051}],other = []};

get_companion_stage(9,4,5) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,8148},{2,162960},{3,4074},{4,4074}],other = []};

get_companion_stage(9,4,6) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,8194},{2,163880},{3,4097},{4,4097}],other = []};

get_companion_stage(9,4,7) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,8240},{2,164800},{3,4120},{4,4120}],other = []};

get_companion_stage(9,4,8) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,8286},{2,165720},{3,4143},{4,4143}],other = []};

get_companion_stage(9,4,9) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,8332},{2,166640},{3,4166},{4,4166}],other = []};

get_companion_stage(9,4,10) ->
	#base_companion_stage{companion_id = 9,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,8424},{2,168480},{3,4212},{4,4212}],other = []};

get_companion_stage(9,5,1) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,8470},{2,169400},{3,4235},{4,4235}],other = []};

get_companion_stage(9,5,2) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,8516},{2,170320},{3,4258},{4,4258}],other = []};

get_companion_stage(9,5,3) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,8562},{2,171240},{3,4281},{4,4281}],other = []};

get_companion_stage(9,5,4) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,8608},{2,172160},{3,4304},{4,4304}],other = []};

get_companion_stage(9,5,5) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,8654},{2,173080},{3,4327},{4,4327}],other = []};

get_companion_stage(9,5,6) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,8700},{2,174000},{3,4350},{4,4350}],other = []};

get_companion_stage(9,5,7) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,8746},{2,174920},{3,4373},{4,4373}],other = []};

get_companion_stage(9,5,8) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,8792},{2,175840},{3,4396},{4,4396}],other = []};

get_companion_stage(9,5,9) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,8838},{2,176760},{3,4419},{4,4419}],other = []};

get_companion_stage(9,5,10) ->
	#base_companion_stage{companion_id = 9,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,8930},{2,178600},{3,4465},{4,4465}],other = [{biog_reward, [{2,0,250},{0, 22030009, 10},{0, 22030109, 5}]}]};

get_companion_stage(9,6,1) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,8976},{2,179520},{3,4488},{4,4488}],other = []};

get_companion_stage(9,6,2) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,9022},{2,180440},{3,4511},{4,4511}],other = []};

get_companion_stage(9,6,3) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,9068},{2,181360},{3,4534},{4,4534}],other = []};

get_companion_stage(9,6,4) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,9114},{2,182280},{3,4557},{4,4557}],other = []};

get_companion_stage(9,6,5) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,9160},{2,183200},{3,4580},{4,4580}],other = []};

get_companion_stage(9,6,6) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,9206},{2,184120},{3,4603},{4,4603}],other = []};

get_companion_stage(9,6,7) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,9252},{2,185040},{3,4626},{4,4626}],other = []};

get_companion_stage(9,6,8) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,9298},{2,185960},{3,4649},{4,4649}],other = []};

get_companion_stage(9,6,9) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,9344},{2,186880},{3,4672},{4,4672}],other = []};

get_companion_stage(9,6,10) ->
	#base_companion_stage{companion_id = 9,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,9436},{2,188720},{3,4718},{4,4718}],other = []};

get_companion_stage(9,7,1) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,9482},{2,189640},{3,4741},{4,4741}],other = []};

get_companion_stage(9,7,2) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,9528},{2,190560},{3,4764},{4,4764}],other = []};

get_companion_stage(9,7,3) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,9574},{2,191480},{3,4787},{4,4787}],other = []};

get_companion_stage(9,7,4) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,9620},{2,192400},{3,4810},{4,4810}],other = []};

get_companion_stage(9,7,5) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,9666},{2,193320},{3,4833},{4,4833}],other = []};

get_companion_stage(9,7,6) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,9712},{2,194240},{3,4856},{4,4856}],other = []};

get_companion_stage(9,7,7) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,9758},{2,195160},{3,4879},{4,4879}],other = []};

get_companion_stage(9,7,8) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,9804},{2,196080},{3,4902},{4,4902}],other = []};

get_companion_stage(9,7,9) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,9850},{2,197000},{3,4925},{4,4925}],other = []};

get_companion_stage(9,7,10) ->
	#base_companion_stage{companion_id = 9,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,9942},{2,198840},{3,4971},{4,4971}],other = []};

get_companion_stage(9,8,1) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,9988},{2,199760},{3,4994},{4,4994}],other = []};

get_companion_stage(9,8,2) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,10034},{2,200680},{3,5017},{4,5017}],other = []};

get_companion_stage(9,8,3) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,10080},{2,201600},{3,5040},{4,5040}],other = []};

get_companion_stage(9,8,4) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,10126},{2,202520},{3,5063},{4,5063}],other = []};

get_companion_stage(9,8,5) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,10172},{2,203440},{3,5086},{4,5086}],other = []};

get_companion_stage(9,8,6) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,10218},{2,204360},{3,5109},{4,5109}],other = []};

get_companion_stage(9,8,7) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,10264},{2,205280},{3,5132},{4,5132}],other = []};

get_companion_stage(9,8,8) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,10310},{2,206200},{3,5155},{4,5155}],other = []};

get_companion_stage(9,8,9) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,10356},{2,207120},{3,5178},{4,5178}],other = []};

get_companion_stage(9,8,10) ->
	#base_companion_stage{companion_id = 9,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,10448},{2,208960},{3,5224},{4,5224}],other = []};

get_companion_stage(9,9,1) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,10494},{2,209880},{3,5247},{4,5247}],other = []};

get_companion_stage(9,9,2) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,10540},{2,210800},{3,5270},{4,5270}],other = []};

get_companion_stage(9,9,3) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,10586},{2,211720},{3,5293},{4,5293}],other = []};

get_companion_stage(9,9,4) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,10632},{2,212640},{3,5316},{4,5316}],other = []};

get_companion_stage(9,9,5) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,10678},{2,213560},{3,5339},{4,5339}],other = []};

get_companion_stage(9,9,6) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,10724},{2,214480},{3,5362},{4,5362}],other = []};

get_companion_stage(9,9,7) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,10770},{2,215400},{3,5385},{4,5385}],other = []};

get_companion_stage(9,9,8) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,10816},{2,216320},{3,5408},{4,5408}],other = []};

get_companion_stage(9,9,9) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,10862},{2,217240},{3,5431},{4,5431}],other = []};

get_companion_stage(9,9,10) ->
	#base_companion_stage{companion_id = 9,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,10954},{2,219080},{3,5477},{4,5477}],other = []};

get_companion_stage(9,10,1) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,11000},{2,220000},{3,5500},{4,5500}],other = []};

get_companion_stage(9,10,2) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,11046},{2,220920},{3,5523},{4,5523}],other = []};

get_companion_stage(9,10,3) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,11092},{2,221840},{3,5546},{4,5546}],other = []};

get_companion_stage(9,10,4) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,11138},{2,222760},{3,5569},{4,5569}],other = []};

get_companion_stage(9,10,5) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,11184},{2,223680},{3,5592},{4,5592}],other = []};

get_companion_stage(9,10,6) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,11230},{2,224600},{3,5615},{4,5615}],other = []};

get_companion_stage(9,10,7) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,11276},{2,225520},{3,5638},{4,5638}],other = []};

get_companion_stage(9,10,8) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,11322},{2,226440},{3,5661},{4,5661}],other = []};

get_companion_stage(9,10,9) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,11368},{2,227360},{3,5684},{4,5684}],other = []};

get_companion_stage(9,10,10) ->
	#base_companion_stage{companion_id = 9,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(9,11,1) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,11506},{2,230120},{3,5753},{4,5753}],other = []};

get_companion_stage(9,11,2) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,11552},{2,231040},{3,5776},{4,5776}],other = []};

get_companion_stage(9,11,3) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,11598},{2,231960},{3,5799},{4,5799}],other = []};

get_companion_stage(9,11,4) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,11644},{2,232880},{3,5822},{4,5822}],other = []};

get_companion_stage(9,11,5) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,11690},{2,233800},{3,5845},{4,5845}],other = []};

get_companion_stage(9,11,6) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,11736},{2,234720},{3,5868},{4,5868}],other = []};

get_companion_stage(9,11,7) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,11782},{2,235640},{3,5891},{4,5891}],other = []};

get_companion_stage(9,11,8) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,11828},{2,236560},{3,5914},{4,5914}],other = []};

get_companion_stage(9,11,9) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,11874},{2,237480},{3,5937},{4,5937}],other = []};

get_companion_stage(9,11,10) ->
	#base_companion_stage{companion_id = 9,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,11966},{2,239320},{3,5983},{4,5983}],other = []};

get_companion_stage(9,12,1) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,12012},{2,240240},{3,6006},{4,6006}],other = []};

get_companion_stage(9,12,2) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,12058},{2,241160},{3,6029},{4,6029}],other = []};

get_companion_stage(9,12,3) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,12104},{2,242080},{3,6052},{4,6052}],other = []};

get_companion_stage(9,12,4) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,12150},{2,243000},{3,6075},{4,6075}],other = []};

get_companion_stage(9,12,5) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,12196},{2,243920},{3,6098},{4,6098}],other = []};

get_companion_stage(9,12,6) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,12242},{2,244840},{3,6121},{4,6121}],other = []};

get_companion_stage(9,12,7) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,12288},{2,245760},{3,6144},{4,6144}],other = []};

get_companion_stage(9,12,8) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,12334},{2,246680},{3,6167},{4,6167}],other = []};

get_companion_stage(9,12,9) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,12380},{2,247600},{3,6190},{4,6190}],other = []};

get_companion_stage(9,12,10) ->
	#base_companion_stage{companion_id = 9,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,12472},{2,249440},{3,6236},{4,6236}],other = []};

get_companion_stage(9,13,1) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,12518},{2,250360},{3,6259},{4,6259}],other = []};

get_companion_stage(9,13,2) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,12564},{2,251280},{3,6282},{4,6282}],other = []};

get_companion_stage(9,13,3) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,12610},{2,252200},{3,6305},{4,6305}],other = []};

get_companion_stage(9,13,4) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,12656},{2,253120},{3,6328},{4,6328}],other = []};

get_companion_stage(9,13,5) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,12702},{2,254040},{3,6351},{4,6351}],other = []};

get_companion_stage(9,13,6) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,12748},{2,254960},{3,6374},{4,6374}],other = []};

get_companion_stage(9,13,7) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,12794},{2,255880},{3,6397},{4,6397}],other = []};

get_companion_stage(9,13,8) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,12840},{2,256800},{3,6420},{4,6420}],other = []};

get_companion_stage(9,13,9) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,12886},{2,257720},{3,6443},{4,6443}],other = []};

get_companion_stage(9,13,10) ->
	#base_companion_stage{companion_id = 9,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,12978},{2,259560},{3,6489},{4,6489}],other = []};

get_companion_stage(9,14,1) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,13024},{2,260480},{3,6512},{4,6512}],other = []};

get_companion_stage(9,14,2) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,13070},{2,261400},{3,6535},{4,6535}],other = []};

get_companion_stage(9,14,3) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,13116},{2,262320},{3,6558},{4,6558}],other = []};

get_companion_stage(9,14,4) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,13162},{2,263240},{3,6581},{4,6581}],other = []};

get_companion_stage(9,14,5) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,13208},{2,264160},{3,6604},{4,6604}],other = []};

get_companion_stage(9,14,6) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,13254},{2,265080},{3,6627},{4,6627}],other = []};

get_companion_stage(9,14,7) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,13300},{2,266000},{3,6650},{4,6650}],other = []};

get_companion_stage(9,14,8) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,13346},{2,266920},{3,6673},{4,6673}],other = []};

get_companion_stage(9,14,9) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,13392},{2,267840},{3,6696},{4,6696}],other = []};

get_companion_stage(9,14,10) ->
	#base_companion_stage{companion_id = 9,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,13484},{2,269680},{3,6742},{4,6742}],other = []};

get_companion_stage(9,15,1) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,13530},{2,270600},{3,6765},{4,6765}],other = []};

get_companion_stage(9,15,2) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,13576},{2,271520},{3,6788},{4,6788}],other = []};

get_companion_stage(9,15,3) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,13622},{2,272440},{3,6811},{4,6811}],other = []};

get_companion_stage(9,15,4) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,13668},{2,273360},{3,6834},{4,6834}],other = []};

get_companion_stage(9,15,5) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,13714},{2,274280},{3,6857},{4,6857}],other = []};

get_companion_stage(9,15,6) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,13760},{2,275200},{3,6880},{4,6880}],other = []};

get_companion_stage(9,15,7) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,13806},{2,276120},{3,6903},{4,6903}],other = []};

get_companion_stage(9,15,8) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,13852},{2,277040},{3,6926},{4,6926}],other = []};

get_companion_stage(9,15,9) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,13898},{2,277960},{3,6949},{4,6949}],other = []};

get_companion_stage(9,15,10) ->
	#base_companion_stage{companion_id = 9,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,13990},{2,279800},{3,6995},{4,6995}],other = []};

get_companion_stage(9,16,1) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,14036},{2,280720},{3,7018},{4,7018}],other = []};

get_companion_stage(9,16,2) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,14082},{2,281640},{3,7041},{4,7041}],other = []};

get_companion_stage(9,16,3) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,14128},{2,282560},{3,7064},{4,7064}],other = []};

get_companion_stage(9,16,4) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,14174},{2,283480},{3,7087},{4,7087}],other = []};

get_companion_stage(9,16,5) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,14220},{2,284400},{3,7110},{4,7110}],other = []};

get_companion_stage(9,16,6) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,14266},{2,285320},{3,7133},{4,7133}],other = []};

get_companion_stage(9,16,7) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,14312},{2,286240},{3,7156},{4,7156}],other = []};

get_companion_stage(9,16,8) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,14358},{2,287160},{3,7179},{4,7179}],other = []};

get_companion_stage(9,16,9) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,14404},{2,288080},{3,7202},{4,7202}],other = []};

get_companion_stage(9,16,10) ->
	#base_companion_stage{companion_id = 9,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,14496},{2,289920},{3,7248},{4,7248}],other = []};

get_companion_stage(9,17,1) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,14542},{2,290840},{3,7271},{4,7271}],other = []};

get_companion_stage(9,17,2) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,14588},{2,291760},{3,7294},{4,7294}],other = []};

get_companion_stage(9,17,3) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,14634},{2,292680},{3,7317},{4,7317}],other = []};

get_companion_stage(9,17,4) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,14680},{2,293600},{3,7340},{4,7340}],other = []};

get_companion_stage(9,17,5) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,14726},{2,294520},{3,7363},{4,7363}],other = []};

get_companion_stage(9,17,6) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,14772},{2,295440},{3,7386},{4,7386}],other = []};

get_companion_stage(9,17,7) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,14818},{2,296360},{3,7409},{4,7409}],other = []};

get_companion_stage(9,17,8) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,14864},{2,297280},{3,7432},{4,7432}],other = []};

get_companion_stage(9,17,9) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,14910},{2,298200},{3,7455},{4,7455}],other = []};

get_companion_stage(9,17,10) ->
	#base_companion_stage{companion_id = 9,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,15002},{2,300040},{3,7501},{4,7501}],other = []};

get_companion_stage(9,18,1) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,15048},{2,300960},{3,7524},{4,7524}],other = []};

get_companion_stage(9,18,2) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,15094},{2,301880},{3,7547},{4,7547}],other = []};

get_companion_stage(9,18,3) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,15140},{2,302800},{3,7570},{4,7570}],other = []};

get_companion_stage(9,18,4) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,15186},{2,303720},{3,7593},{4,7593}],other = []};

get_companion_stage(9,18,5) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,15232},{2,304640},{3,7616},{4,7616}],other = []};

get_companion_stage(9,18,6) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,15278},{2,305560},{3,7639},{4,7639}],other = []};

get_companion_stage(9,18,7) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,15324},{2,306480},{3,7662},{4,7662}],other = []};

get_companion_stage(9,18,8) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,15370},{2,307400},{3,7685},{4,7685}],other = []};

get_companion_stage(9,18,9) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,15416},{2,308320},{3,7708},{4,7708}],other = []};

get_companion_stage(9,18,10) ->
	#base_companion_stage{companion_id = 9,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,15508},{2,310160},{3,7754},{4,7754}],other = []};

get_companion_stage(9,19,1) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,15554},{2,311080},{3,7777},{4,7777}],other = []};

get_companion_stage(9,19,2) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,15600},{2,312000},{3,7800},{4,7800}],other = []};

get_companion_stage(9,19,3) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,15646},{2,312920},{3,7823},{4,7823}],other = []};

get_companion_stage(9,19,4) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,15692},{2,313840},{3,7846},{4,7846}],other = []};

get_companion_stage(9,19,5) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,15738},{2,314760},{3,7869},{4,7869}],other = []};

get_companion_stage(9,19,6) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,15784},{2,315680},{3,7892},{4,7892}],other = []};

get_companion_stage(9,19,7) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,15830},{2,316600},{3,7915},{4,7915}],other = []};

get_companion_stage(9,19,8) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,15876},{2,317520},{3,7938},{4,7938}],other = []};

get_companion_stage(9,19,9) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,15922},{2,318440},{3,7961},{4,7961}],other = []};

get_companion_stage(9,19,10) ->
	#base_companion_stage{companion_id = 9,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,16014},{2,320280},{3,8007},{4,8007}],other = []};

get_companion_stage(9,20,1) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,16060},{2,321200},{3,8030},{4,8030}],other = []};

get_companion_stage(9,20,2) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,16106},{2,322120},{3,8053},{4,8053}],other = []};

get_companion_stage(9,20,3) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,16152},{2,323040},{3,8076},{4,8076}],other = []};

get_companion_stage(9,20,4) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,16198},{2,323960},{3,8099},{4,8099}],other = []};

get_companion_stage(9,20,5) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,16244},{2,324880},{3,8122},{4,8122}],other = []};

get_companion_stage(9,20,6) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,16290},{2,325800},{3,8145},{4,8145}],other = []};

get_companion_stage(9,20,7) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,16336},{2,326720},{3,8168},{4,8168}],other = []};

get_companion_stage(9,20,8) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,16382},{2,327640},{3,8191},{4,8191}],other = []};

get_companion_stage(9,20,9) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,16428},{2,328560},{3,8214},{4,8214}],other = []};

get_companion_stage(9,20,10) ->
	#base_companion_stage{companion_id = 9,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,16520},{2,330400},{3,8260},{4,8260}],other = []};

get_companion_stage(9,21,1) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,16566},{2,331320},{3,8283},{4,8283}],other = []};

get_companion_stage(9,21,2) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,16612},{2,332240},{3,8306},{4,8306}],other = []};

get_companion_stage(9,21,3) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,16658},{2,333160},{3,8329},{4,8329}],other = []};

get_companion_stage(9,21,4) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,16704},{2,334080},{3,8352},{4,8352}],other = []};

get_companion_stage(9,21,5) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,16750},{2,335000},{3,8375},{4,8375}],other = []};

get_companion_stage(9,21,6) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,16796},{2,335920},{3,8398},{4,8398}],other = []};

get_companion_stage(9,21,7) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,16842},{2,336840},{3,8421},{4,8421}],other = []};

get_companion_stage(9,21,8) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,16888},{2,337760},{3,8444},{4,8444}],other = []};

get_companion_stage(9,21,9) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,16934},{2,338680},{3,8467},{4,8467}],other = []};

get_companion_stage(9,21,10) ->
	#base_companion_stage{companion_id = 9,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,17026},{2,340520},{3,8513},{4,8513}],other = []};

get_companion_stage(9,22,1) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,17072},{2,341440},{3,8536},{4,8536}],other = []};

get_companion_stage(9,22,2) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,17118},{2,342360},{3,8559},{4,8559}],other = []};

get_companion_stage(9,22,3) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,17164},{2,343280},{3,8582},{4,8582}],other = []};

get_companion_stage(9,22,4) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,17210},{2,344200},{3,8605},{4,8605}],other = []};

get_companion_stage(9,22,5) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,17256},{2,345120},{3,8628},{4,8628}],other = []};

get_companion_stage(9,22,6) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,17302},{2,346040},{3,8651},{4,8651}],other = []};

get_companion_stage(9,22,7) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,17348},{2,346960},{3,8674},{4,8674}],other = []};

get_companion_stage(9,22,8) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,17394},{2,347880},{3,8697},{4,8697}],other = []};

get_companion_stage(9,22,9) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,17440},{2,348800},{3,8720},{4,8720}],other = []};

get_companion_stage(9,22,10) ->
	#base_companion_stage{companion_id = 9,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,17532},{2,350640},{3,8766},{4,8766}],other = []};

get_companion_stage(9,23,1) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,17578},{2,351560},{3,8789},{4,8789}],other = []};

get_companion_stage(9,23,2) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,17624},{2,352480},{3,8812},{4,8812}],other = []};

get_companion_stage(9,23,3) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,17670},{2,353400},{3,8835},{4,8835}],other = []};

get_companion_stage(9,23,4) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,17716},{2,354320},{3,8858},{4,8858}],other = []};

get_companion_stage(9,23,5) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,17762},{2,355240},{3,8881},{4,8881}],other = []};

get_companion_stage(9,23,6) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,17808},{2,356160},{3,8904},{4,8904}],other = []};

get_companion_stage(9,23,7) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,17854},{2,357080},{3,8927},{4,8927}],other = []};

get_companion_stage(9,23,8) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,17900},{2,358000},{3,8950},{4,8950}],other = []};

get_companion_stage(9,23,9) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,17946},{2,358920},{3,8973},{4,8973}],other = []};

get_companion_stage(9,23,10) ->
	#base_companion_stage{companion_id = 9,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,18038},{2,360760},{3,9019},{4,9019}],other = []};

get_companion_stage(9,24,1) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,18084},{2,361680},{3,9042},{4,9042}],other = []};

get_companion_stage(9,24,2) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,18130},{2,362600},{3,9065},{4,9065}],other = []};

get_companion_stage(9,24,3) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,18176},{2,363520},{3,9088},{4,9088}],other = []};

get_companion_stage(9,24,4) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,18222},{2,364440},{3,9111},{4,9111}],other = []};

get_companion_stage(9,24,5) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,18268},{2,365360},{3,9134},{4,9134}],other = []};

get_companion_stage(9,24,6) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,18314},{2,366280},{3,9157},{4,9157}],other = []};

get_companion_stage(9,24,7) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,18360},{2,367200},{3,9180},{4,9180}],other = []};

get_companion_stage(9,24,8) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,18406},{2,368120},{3,9203},{4,9203}],other = []};

get_companion_stage(9,24,9) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,18452},{2,369040},{3,9226},{4,9226}],other = []};

get_companion_stage(9,24,10) ->
	#base_companion_stage{companion_id = 9,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,18544},{2,370880},{3,9272},{4,9272}],other = []};

get_companion_stage(9,25,1) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,18590},{2,371800},{3,9295},{4,9295}],other = []};

get_companion_stage(9,25,2) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,18636},{2,372720},{3,9318},{4,9318}],other = []};

get_companion_stage(9,25,3) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,18682},{2,373640},{3,9341},{4,9341}],other = []};

get_companion_stage(9,25,4) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,18728},{2,374560},{3,9364},{4,9364}],other = []};

get_companion_stage(9,25,5) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,18774},{2,375480},{3,9387},{4,9387}],other = []};

get_companion_stage(9,25,6) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,18820},{2,376400},{3,9410},{4,9410}],other = []};

get_companion_stage(9,25,7) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,18866},{2,377320},{3,9433},{4,9433}],other = []};

get_companion_stage(9,25,8) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,18912},{2,378240},{3,9456},{4,9456}],other = []};

get_companion_stage(9,25,9) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,18958},{2,379160},{3,9479},{4,9479}],other = []};

get_companion_stage(9,25,10) ->
	#base_companion_stage{companion_id = 9,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,19050},{2,381000},{3,9525},{4,9525}],other = []};

get_companion_stage(9,26,1) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,19096},{2,381920},{3,9548},{4,9548}],other = []};

get_companion_stage(9,26,2) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,19142},{2,382840},{3,9571},{4,9571}],other = []};

get_companion_stage(9,26,3) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,19188},{2,383760},{3,9594},{4,9594}],other = []};

get_companion_stage(9,26,4) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,19234},{2,384680},{3,9617},{4,9617}],other = []};

get_companion_stage(9,26,5) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,19280},{2,385600},{3,9640},{4,9640}],other = []};

get_companion_stage(9,26,6) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,19326},{2,386520},{3,9663},{4,9663}],other = []};

get_companion_stage(9,26,7) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,19372},{2,387440},{3,9686},{4,9686}],other = []};

get_companion_stage(9,26,8) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,19418},{2,388360},{3,9709},{4,9709}],other = []};

get_companion_stage(9,26,9) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,19464},{2,389280},{3,9732},{4,9732}],other = []};

get_companion_stage(9,26,10) ->
	#base_companion_stage{companion_id = 9,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,19556},{2,391120},{3,9778},{4,9778}],other = []};

get_companion_stage(9,27,1) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,19602},{2,392040},{3,9801},{4,9801}],other = []};

get_companion_stage(9,27,2) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,19648},{2,392960},{3,9824},{4,9824}],other = []};

get_companion_stage(9,27,3) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,19694},{2,393880},{3,9847},{4,9847}],other = []};

get_companion_stage(9,27,4) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,19740},{2,394800},{3,9870},{4,9870}],other = []};

get_companion_stage(9,27,5) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,19786},{2,395720},{3,9893},{4,9893}],other = []};

get_companion_stage(9,27,6) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,19832},{2,396640},{3,9916},{4,9916}],other = []};

get_companion_stage(9,27,7) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,19878},{2,397560},{3,9939},{4,9939}],other = []};

get_companion_stage(9,27,8) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,19924},{2,398480},{3,9962},{4,9962}],other = []};

get_companion_stage(9,27,9) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,19970},{2,399400},{3,9985},{4,9985}],other = []};

get_companion_stage(9,27,10) ->
	#base_companion_stage{companion_id = 9,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,20062},{2,401240},{3,10031},{4,10031}],other = []};

get_companion_stage(9,28,1) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,20108},{2,402160},{3,10054},{4,10054}],other = []};

get_companion_stage(9,28,2) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,20154},{2,403080},{3,10077},{4,10077}],other = []};

get_companion_stage(9,28,3) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,20200},{2,404000},{3,10100},{4,10100}],other = []};

get_companion_stage(9,28,4) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,20246},{2,404920},{3,10123},{4,10123}],other = []};

get_companion_stage(9,28,5) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,20292},{2,405840},{3,10146},{4,10146}],other = []};

get_companion_stage(9,28,6) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,20338},{2,406760},{3,10169},{4,10169}],other = []};

get_companion_stage(9,28,7) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,20384},{2,407680},{3,10192},{4,10192}],other = []};

get_companion_stage(9,28,8) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,20430},{2,408600},{3,10215},{4,10215}],other = []};

get_companion_stage(9,28,9) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,20476},{2,409520},{3,10238},{4,10238}],other = []};

get_companion_stage(9,28,10) ->
	#base_companion_stage{companion_id = 9,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,20568},{2,411360},{3,10284},{4,10284}],other = []};

get_companion_stage(9,29,1) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,20614},{2,412280},{3,10307},{4,10307}],other = []};

get_companion_stage(9,29,2) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,20660},{2,413200},{3,10330},{4,10330}],other = []};

get_companion_stage(9,29,3) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,20706},{2,414120},{3,10353},{4,10353}],other = []};

get_companion_stage(9,29,4) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,20752},{2,415040},{3,10376},{4,10376}],other = []};

get_companion_stage(9,29,5) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,20798},{2,415960},{3,10399},{4,10399}],other = []};

get_companion_stage(9,29,6) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,20844},{2,416880},{3,10422},{4,10422}],other = []};

get_companion_stage(9,29,7) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,20890},{2,417800},{3,10445},{4,10445}],other = []};

get_companion_stage(9,29,8) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,20936},{2,418720},{3,10468},{4,10468}],other = []};

get_companion_stage(9,29,9) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,20982},{2,419640},{3,10491},{4,10491}],other = []};

get_companion_stage(9,29,10) ->
	#base_companion_stage{companion_id = 9,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,21074},{2,421480},{3,10537},{4,10537}],other = []};

get_companion_stage(9,30,1) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,21120},{2,422400},{3,10560},{4,10560}],other = []};

get_companion_stage(9,30,2) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,21166},{2,423320},{3,10583},{4,10583}],other = []};

get_companion_stage(9,30,3) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 3,biography = 0,need_blessing = 927,attr = [{1,21212},{2,424240},{3,10606},{4,10606}],other = []};

get_companion_stage(9,30,4) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 4,biography = 0,need_blessing = 931,attr = [{1,21258},{2,425160},{3,10629},{4,10629}],other = []};

get_companion_stage(9,30,5) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 5,biography = 0,need_blessing = 935,attr = [{1,21304},{2,426080},{3,10652},{4,10652}],other = []};

get_companion_stage(9,30,6) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 6,biography = 0,need_blessing = 939,attr = [{1,21350},{2,427000},{3,10675},{4,10675}],other = []};

get_companion_stage(9,30,7) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 7,biography = 0,need_blessing = 942,attr = [{1,21396},{2,427920},{3,10698},{4,10698}],other = []};

get_companion_stage(9,30,8) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 8,biography = 0,need_blessing = 946,attr = [{1,21442},{2,428840},{3,10721},{4,10721}],other = []};

get_companion_stage(9,30,9) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 9,biography = 0,need_blessing = 950,attr = [{1,21488},{2,429760},{3,10744},{4,10744}],other = []};

get_companion_stage(9,30,10) ->
	#base_companion_stage{companion_id = 9,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,21580},{2,431600},{3,10790},{4,10790}],other = []};

get_companion_stage(10,1,0) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,3000},{2,60000},{3,1500},{4,1500}],other = []};

get_companion_stage(10,1,1) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 1,biography = 0,need_blessing = 11,attr = [{1,3030},{2,60600},{3,1515},{4,1515}],other = []};

get_companion_stage(10,1,2) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 2,biography = 0,need_blessing = 13,attr = [{1,3060},{2,61200},{3,1530},{4,1530}],other = []};

get_companion_stage(10,1,3) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 3,biography = 0,need_blessing = 14,attr = [{1,3090},{2,61800},{3,1545},{4,1545}],other = []};

get_companion_stage(10,1,4) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 4,biography = 0,need_blessing = 16,attr = [{1,3120},{2,62400},{3,1560},{4,1560}],other = []};

get_companion_stage(10,1,5) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 5,biography = 0,need_blessing = 18,attr = [{1,3150},{2,63000},{3,1575},{4,1575}],other = []};

get_companion_stage(10,1,6) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 6,biography = 0,need_blessing = 20,attr = [{1,3180},{2,63600},{3,1590},{4,1590}],other = []};

get_companion_stage(10,1,7) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 7,biography = 0,need_blessing = 21,attr = [{1,3210},{2,64200},{3,1605},{4,1605}],other = []};

get_companion_stage(10,1,8) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 8,biography = 0,need_blessing = 23,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],other = []};

get_companion_stage(10,1,9) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 9,biography = 0,need_blessing = 25,attr = [{1,3270},{2,65400},{3,1635},{4,1635}],other = []};

get_companion_stage(10,1,10) ->
	#base_companion_stage{companion_id = 10,stage = 1,star = 10,biography = 1,need_blessing = 27,attr = [{1,3330},{2,66600},{3,1665},{4,1665}],other = [{biog_reward, [{2,0,100},{0, 22030010, 3},{0, 22030110, 1}]}]};

get_companion_stage(10,2,1) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 1,biography = 0,need_blessing = 29,attr = [{1,3360},{2,67200},{3,1680},{4,1680}],other = []};

get_companion_stage(10,2,2) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 2,biography = 0,need_blessing = 31,attr = [{1,3390},{2,67800},{3,1695},{4,1695}],other = []};

get_companion_stage(10,2,3) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 3,biography = 0,need_blessing = 33,attr = [{1,3420},{2,68400},{3,1710},{4,1710}],other = []};

get_companion_stage(10,2,4) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 4,biography = 0,need_blessing = 35,attr = [{1,3450},{2,69000},{3,1725},{4,1725}],other = []};

get_companion_stage(10,2,5) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 5,biography = 0,need_blessing = 37,attr = [{1,3480},{2,69600},{3,1740},{4,1740}],other = []};

get_companion_stage(10,2,6) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 6,biography = 0,need_blessing = 40,attr = [{1,3510},{2,70200},{3,1755},{4,1755}],other = []};

get_companion_stage(10,2,7) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 7,biography = 0,need_blessing = 42,attr = [{1,3540},{2,70800},{3,1770},{4,1770}],other = []};

get_companion_stage(10,2,8) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 8,biography = 0,need_blessing = 44,attr = [{1,3570},{2,71400},{3,1785},{4,1785}],other = []};

get_companion_stage(10,2,9) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 9,biography = 0,need_blessing = 46,attr = [{1,3600},{2,72000},{3,1800},{4,1800}],other = []};

get_companion_stage(10,2,10) ->
	#base_companion_stage{companion_id = 10,stage = 2,star = 10,biography = 0,need_blessing = 48,attr = [{1,3660},{2,73200},{3,1830},{4,1830}],other = []};

get_companion_stage(10,3,1) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 1,biography = 0,need_blessing = 51,attr = [{1,3690},{2,73800},{3,1845},{4,1845}],other = []};

get_companion_stage(10,3,2) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 2,biography = 0,need_blessing = 53,attr = [{1,3720},{2,74400},{3,1860},{4,1860}],other = []};

get_companion_stage(10,3,3) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 3,biography = 0,need_blessing = 55,attr = [{1,3750},{2,75000},{3,1875},{4,1875}],other = []};

get_companion_stage(10,3,4) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 4,biography = 0,need_blessing = 57,attr = [{1,3780},{2,75600},{3,1890},{4,1890}],other = []};

get_companion_stage(10,3,5) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 5,biography = 0,need_blessing = 60,attr = [{1,3810},{2,76200},{3,1905},{4,1905}],other = []};

get_companion_stage(10,3,6) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 6,biography = 0,need_blessing = 62,attr = [{1,3840},{2,76800},{3,1920},{4,1920}],other = []};

get_companion_stage(10,3,7) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 7,biography = 0,need_blessing = 64,attr = [{1,3870},{2,77400},{3,1935},{4,1935}],other = []};

get_companion_stage(10,3,8) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 8,biography = 0,need_blessing = 67,attr = [{1,3900},{2,78000},{3,1950},{4,1950}],other = []};

get_companion_stage(10,3,9) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 9,biography = 0,need_blessing = 69,attr = [{1,3930},{2,78600},{3,1965},{4,1965}],other = []};

get_companion_stage(10,3,10) ->
	#base_companion_stage{companion_id = 10,stage = 3,star = 10,biography = 2,need_blessing = 72,attr = [{1,3990},{2,79800},{3,1995},{4,1995}],other = [{biog_reward, [{2,0,200},{0, 22030010, 5},{0, 22030110, 3}]}]};

get_companion_stage(10,4,1) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 1,biography = 0,need_blessing = 74,attr = [{1,4020},{2,80400},{3,2010},{4,2010}],other = []};

get_companion_stage(10,4,2) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 2,biography = 0,need_blessing = 76,attr = [{1,4050},{2,81000},{3,2025},{4,2025}],other = []};

get_companion_stage(10,4,3) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 3,biography = 0,need_blessing = 79,attr = [{1,4080},{2,81600},{3,2040},{4,2040}],other = []};

get_companion_stage(10,4,4) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 4,biography = 0,need_blessing = 81,attr = [{1,4110},{2,82200},{3,2055},{4,2055}],other = []};

get_companion_stage(10,4,5) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 5,biography = 0,need_blessing = 84,attr = [{1,4140},{2,82800},{3,2070},{4,2070}],other = []};

get_companion_stage(10,4,6) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 6,biography = 0,need_blessing = 86,attr = [{1,4170},{2,83400},{3,2085},{4,2085}],other = []};

get_companion_stage(10,4,7) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 7,biography = 0,need_blessing = 89,attr = [{1,4200},{2,84000},{3,2100},{4,2100}],other = []};

get_companion_stage(10,4,8) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 8,biography = 0,need_blessing = 91,attr = [{1,4230},{2,84600},{3,2115},{4,2115}],other = []};

get_companion_stage(10,4,9) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 9,biography = 0,need_blessing = 94,attr = [{1,4260},{2,85200},{3,2130},{4,2130}],other = []};

get_companion_stage(10,4,10) ->
	#base_companion_stage{companion_id = 10,stage = 4,star = 10,biography = 0,need_blessing = 96,attr = [{1,4320},{2,86400},{3,2160},{4,2160}],other = []};

get_companion_stage(10,5,1) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 1,biography = 0,need_blessing = 99,attr = [{1,4350},{2,87000},{3,2175},{4,2175}],other = []};

get_companion_stage(10,5,2) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 2,biography = 0,need_blessing = 101,attr = [{1,4380},{2,87600},{3,2190},{4,2190}],other = []};

get_companion_stage(10,5,3) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 3,biography = 0,need_blessing = 104,attr = [{1,4410},{2,88200},{3,2205},{4,2205}],other = []};

get_companion_stage(10,5,4) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 4,biography = 0,need_blessing = 106,attr = [{1,4440},{2,88800},{3,2220},{4,2220}],other = []};

get_companion_stage(10,5,5) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 5,biography = 0,need_blessing = 109,attr = [{1,4470},{2,89400},{3,2235},{4,2235}],other = []};

get_companion_stage(10,5,6) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 6,biography = 0,need_blessing = 112,attr = [{1,4500},{2,90000},{3,2250},{4,2250}],other = []};

get_companion_stage(10,5,7) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 7,biography = 0,need_blessing = 114,attr = [{1,4530},{2,90600},{3,2265},{4,2265}],other = []};

get_companion_stage(10,5,8) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 8,biography = 0,need_blessing = 117,attr = [{1,4560},{2,91200},{3,2280},{4,2280}],other = []};

get_companion_stage(10,5,9) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 9,biography = 0,need_blessing = 119,attr = [{1,4590},{2,91800},{3,2295},{4,2295}],other = []};

get_companion_stage(10,5,10) ->
	#base_companion_stage{companion_id = 10,stage = 5,star = 10,biography = 3,need_blessing = 122,attr = [{1,4650},{2,93000},{3,2325},{4,2325}],other = [{biog_reward, [{2,0,250},{0, 22030010, 10},{0, 22030110, 5}]}]};

get_companion_stage(10,6,1) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 1,biography = 0,need_blessing = 125,attr = [{1,4680},{2,93600},{3,2340},{4,2340}],other = []};

get_companion_stage(10,6,2) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 2,biography = 0,need_blessing = 127,attr = [{1,4710},{2,94200},{3,2355},{4,2355}],other = []};

get_companion_stage(10,6,3) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 3,biography = 0,need_blessing = 130,attr = [{1,4740},{2,94800},{3,2370},{4,2370}],other = []};

get_companion_stage(10,6,4) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 4,biography = 0,need_blessing = 133,attr = [{1,4770},{2,95400},{3,2385},{4,2385}],other = []};

get_companion_stage(10,6,5) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 5,biography = 0,need_blessing = 135,attr = [{1,4800},{2,96000},{3,2400},{4,2400}],other = []};

get_companion_stage(10,6,6) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 6,biography = 0,need_blessing = 138,attr = [{1,4830},{2,96600},{3,2415},{4,2415}],other = []};

get_companion_stage(10,6,7) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 7,biography = 0,need_blessing = 141,attr = [{1,4860},{2,97200},{3,2430},{4,2430}],other = []};

get_companion_stage(10,6,8) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 8,biography = 0,need_blessing = 144,attr = [{1,4890},{2,97800},{3,2445},{4,2445}],other = []};

get_companion_stage(10,6,9) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 9,biography = 0,need_blessing = 146,attr = [{1,4920},{2,98400},{3,2460},{4,2460}],other = []};

get_companion_stage(10,6,10) ->
	#base_companion_stage{companion_id = 10,stage = 6,star = 10,biography = 0,need_blessing = 149,attr = [{1,4980},{2,99600},{3,2490},{4,2490}],other = []};

get_companion_stage(10,7,1) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 1,biography = 0,need_blessing = 152,attr = [{1,5010},{2,100200},{3,2505},{4,2505}],other = []};

get_companion_stage(10,7,2) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 2,biography = 0,need_blessing = 155,attr = [{1,5040},{2,100800},{3,2520},{4,2520}],other = []};

get_companion_stage(10,7,3) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 3,biography = 0,need_blessing = 157,attr = [{1,5070},{2,101400},{3,2535},{4,2535}],other = []};

get_companion_stage(10,7,4) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 4,biography = 0,need_blessing = 160,attr = [{1,5100},{2,102000},{3,2550},{4,2550}],other = []};

get_companion_stage(10,7,5) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 5,biography = 0,need_blessing = 163,attr = [{1,5130},{2,102600},{3,2565},{4,2565}],other = []};

get_companion_stage(10,7,6) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 6,biography = 0,need_blessing = 166,attr = [{1,5160},{2,103200},{3,2580},{4,2580}],other = []};

get_companion_stage(10,7,7) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 7,biography = 0,need_blessing = 168,attr = [{1,5190},{2,103800},{3,2595},{4,2595}],other = []};

get_companion_stage(10,7,8) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 8,biography = 0,need_blessing = 171,attr = [{1,5220},{2,104400},{3,2610},{4,2610}],other = []};

get_companion_stage(10,7,9) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 9,biography = 0,need_blessing = 174,attr = [{1,5250},{2,105000},{3,2625},{4,2625}],other = []};

get_companion_stage(10,7,10) ->
	#base_companion_stage{companion_id = 10,stage = 7,star = 10,biography = 0,need_blessing = 177,attr = [{1,5310},{2,106200},{3,2655},{4,2655}],other = []};

get_companion_stage(10,8,1) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 1,biography = 0,need_blessing = 180,attr = [{1,5340},{2,106800},{3,2670},{4,2670}],other = []};

get_companion_stage(10,8,2) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 2,biography = 0,need_blessing = 183,attr = [{1,5370},{2,107400},{3,2685},{4,2685}],other = []};

get_companion_stage(10,8,3) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 3,biography = 0,need_blessing = 185,attr = [{1,5400},{2,108000},{3,2700},{4,2700}],other = []};

get_companion_stage(10,8,4) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 4,biography = 0,need_blessing = 188,attr = [{1,5430},{2,108600},{3,2715},{4,2715}],other = []};

get_companion_stage(10,8,5) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 5,biography = 0,need_blessing = 191,attr = [{1,5460},{2,109200},{3,2730},{4,2730}],other = []};

get_companion_stage(10,8,6) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 6,biography = 0,need_blessing = 194,attr = [{1,5490},{2,109800},{3,2745},{4,2745}],other = []};

get_companion_stage(10,8,7) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 7,biography = 0,need_blessing = 197,attr = [{1,5520},{2,110400},{3,2760},{4,2760}],other = []};

get_companion_stage(10,8,8) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 8,biography = 0,need_blessing = 200,attr = [{1,5550},{2,111000},{3,2775},{4,2775}],other = []};

get_companion_stage(10,8,9) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 9,biography = 0,need_blessing = 203,attr = [{1,5580},{2,111600},{3,2790},{4,2790}],other = []};

get_companion_stage(10,8,10) ->
	#base_companion_stage{companion_id = 10,stage = 8,star = 10,biography = 0,need_blessing = 205,attr = [{1,5640},{2,112800},{3,2820},{4,2820}],other = []};

get_companion_stage(10,9,1) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 1,biography = 0,need_blessing = 208,attr = [{1,5670},{2,113400},{3,2835},{4,2835}],other = []};

get_companion_stage(10,9,2) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 2,biography = 0,need_blessing = 211,attr = [{1,5700},{2,114000},{3,2850},{4,2850}],other = []};

get_companion_stage(10,9,3) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 3,biography = 0,need_blessing = 214,attr = [{1,5730},{2,114600},{3,2865},{4,2865}],other = []};

get_companion_stage(10,9,4) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 4,biography = 0,need_blessing = 217,attr = [{1,5760},{2,115200},{3,2880},{4,2880}],other = []};

get_companion_stage(10,9,5) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 5,biography = 0,need_blessing = 220,attr = [{1,5790},{2,115800},{3,2895},{4,2895}],other = []};

get_companion_stage(10,9,6) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 6,biography = 0,need_blessing = 223,attr = [{1,5820},{2,116400},{3,2910},{4,2910}],other = []};

get_companion_stage(10,9,7) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 7,biography = 0,need_blessing = 226,attr = [{1,5850},{2,117000},{3,2925},{4,2925}],other = []};

get_companion_stage(10,9,8) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 8,biography = 0,need_blessing = 229,attr = [{1,5880},{2,117600},{3,2940},{4,2940}],other = []};

get_companion_stage(10,9,9) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 9,biography = 0,need_blessing = 232,attr = [{1,5910},{2,118200},{3,2955},{4,2955}],other = []};

get_companion_stage(10,9,10) ->
	#base_companion_stage{companion_id = 10,stage = 9,star = 10,biography = 0,need_blessing = 235,attr = [{1,5970},{2,119400},{3,2985},{4,2985}],other = []};

get_companion_stage(10,10,1) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 1,biography = 0,need_blessing = 238,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],other = []};

get_companion_stage(10,10,2) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 2,biography = 0,need_blessing = 241,attr = [{1,6030},{2,120600},{3,3015},{4,3015}],other = []};

get_companion_stage(10,10,3) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 3,biography = 0,need_blessing = 244,attr = [{1,6060},{2,121200},{3,3030},{4,3030}],other = []};

get_companion_stage(10,10,4) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 4,biography = 0,need_blessing = 247,attr = [{1,6090},{2,121800},{3,3045},{4,3045}],other = []};

get_companion_stage(10,10,5) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 5,biography = 0,need_blessing = 250,attr = [{1,6120},{2,122400},{3,3060},{4,3060}],other = []};

get_companion_stage(10,10,6) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 6,biography = 0,need_blessing = 253,attr = [{1,6150},{2,123000},{3,3075},{4,3075}],other = []};

get_companion_stage(10,10,7) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 7,biography = 0,need_blessing = 256,attr = [{1,6180},{2,123600},{3,3090},{4,3090}],other = []};

get_companion_stage(10,10,8) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 8,biography = 0,need_blessing = 259,attr = [{1,6210},{2,124200},{3,3105},{4,3105}],other = []};

get_companion_stage(10,10,9) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 9,biography = 0,need_blessing = 262,attr = [{1,6240},{2,124800},{3,3120},{4,3120}],other = []};

get_companion_stage(10,10,10) ->
	#base_companion_stage{companion_id = 10,stage = 10,star = 10,biography = 0,need_blessing = 265,attr = [{1,6300},{2,126000},{3,3150},{4,3150}],other = []};

get_companion_stage(10,11,1) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 1,biography = 0,need_blessing = 268,attr = [{1,6330},{2,126600},{3,3165},{4,3165}],other = []};

get_companion_stage(10,11,2) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 2,biography = 0,need_blessing = 271,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],other = []};

get_companion_stage(10,11,3) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 3,biography = 0,need_blessing = 274,attr = [{1,6390},{2,127800},{3,3195},{4,3195}],other = []};

get_companion_stage(10,11,4) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 4,biography = 0,need_blessing = 277,attr = [{1,6420},{2,128400},{3,3210},{4,3210}],other = []};

get_companion_stage(10,11,5) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 5,biography = 0,need_blessing = 280,attr = [{1,6450},{2,129000},{3,3225},{4,3225}],other = []};

get_companion_stage(10,11,6) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 6,biography = 0,need_blessing = 283,attr = [{1,6480},{2,129600},{3,3240},{4,3240}],other = []};

get_companion_stage(10,11,7) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 7,biography = 0,need_blessing = 286,attr = [{1,6510},{2,130200},{3,3255},{4,3255}],other = []};

get_companion_stage(10,11,8) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 8,biography = 0,need_blessing = 289,attr = [{1,6540},{2,130800},{3,3270},{4,3270}],other = []};

get_companion_stage(10,11,9) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 9,biography = 0,need_blessing = 292,attr = [{1,6570},{2,131400},{3,3285},{4,3285}],other = []};

get_companion_stage(10,11,10) ->
	#base_companion_stage{companion_id = 10,stage = 11,star = 10,biography = 0,need_blessing = 295,attr = [{1,6630},{2,132600},{3,3315},{4,3315}],other = []};

get_companion_stage(10,12,1) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 1,biography = 0,need_blessing = 298,attr = [{1,6660},{2,133200},{3,3330},{4,3330}],other = []};

get_companion_stage(10,12,2) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 2,biography = 0,need_blessing = 301,attr = [{1,6690},{2,133800},{3,3345},{4,3345}],other = []};

get_companion_stage(10,12,3) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 3,biography = 0,need_blessing = 305,attr = [{1,6720},{2,134400},{3,3360},{4,3360}],other = []};

get_companion_stage(10,12,4) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 4,biography = 0,need_blessing = 308,attr = [{1,6750},{2,135000},{3,3375},{4,3375}],other = []};

get_companion_stage(10,12,5) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 5,biography = 0,need_blessing = 311,attr = [{1,6780},{2,135600},{3,3390},{4,3390}],other = []};

get_companion_stage(10,12,6) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 6,biography = 0,need_blessing = 314,attr = [{1,6810},{2,136200},{3,3405},{4,3405}],other = []};

get_companion_stage(10,12,7) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 7,biography = 0,need_blessing = 317,attr = [{1,6840},{2,136800},{3,3420},{4,3420}],other = []};

get_companion_stage(10,12,8) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 8,biography = 0,need_blessing = 320,attr = [{1,6870},{2,137400},{3,3435},{4,3435}],other = []};

get_companion_stage(10,12,9) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 9,biography = 0,need_blessing = 323,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],other = []};

get_companion_stage(10,12,10) ->
	#base_companion_stage{companion_id = 10,stage = 12,star = 10,biography = 0,need_blessing = 326,attr = [{1,6960},{2,139200},{3,3480},{4,3480}],other = []};

get_companion_stage(10,13,1) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 1,biography = 0,need_blessing = 330,attr = [{1,6990},{2,139800},{3,3495},{4,3495}],other = []};

get_companion_stage(10,13,2) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 2,biography = 0,need_blessing = 333,attr = [{1,7020},{2,140400},{3,3510},{4,3510}],other = []};

get_companion_stage(10,13,3) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 3,biography = 0,need_blessing = 336,attr = [{1,7050},{2,141000},{3,3525},{4,3525}],other = []};

get_companion_stage(10,13,4) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 4,biography = 0,need_blessing = 339,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],other = []};

get_companion_stage(10,13,5) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 5,biography = 0,need_blessing = 342,attr = [{1,7110},{2,142200},{3,3555},{4,3555}],other = []};

get_companion_stage(10,13,6) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 6,biography = 0,need_blessing = 345,attr = [{1,7140},{2,142800},{3,3570},{4,3570}],other = []};

get_companion_stage(10,13,7) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 7,biography = 0,need_blessing = 348,attr = [{1,7170},{2,143400},{3,3585},{4,3585}],other = []};

get_companion_stage(10,13,8) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 8,biography = 0,need_blessing = 352,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],other = []};

get_companion_stage(10,13,9) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 9,biography = 0,need_blessing = 355,attr = [{1,7230},{2,144600},{3,3615},{4,3615}],other = []};

get_companion_stage(10,13,10) ->
	#base_companion_stage{companion_id = 10,stage = 13,star = 10,biography = 0,need_blessing = 358,attr = [{1,7290},{2,145800},{3,3645},{4,3645}],other = []};

get_companion_stage(10,14,1) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 1,biography = 0,need_blessing = 361,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],other = []};

get_companion_stage(10,14,2) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 2,biography = 0,need_blessing = 364,attr = [{1,7350},{2,147000},{3,3675},{4,3675}],other = []};

get_companion_stage(10,14,3) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 3,biography = 0,need_blessing = 368,attr = [{1,7380},{2,147600},{3,3690},{4,3690}],other = []};

get_companion_stage(10,14,4) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 4,biography = 0,need_blessing = 371,attr = [{1,7410},{2,148200},{3,3705},{4,3705}],other = []};

get_companion_stage(10,14,5) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 5,biography = 0,need_blessing = 374,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],other = []};

get_companion_stage(10,14,6) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 6,biography = 0,need_blessing = 377,attr = [{1,7470},{2,149400},{3,3735},{4,3735}],other = []};

get_companion_stage(10,14,7) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 7,biography = 0,need_blessing = 380,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],other = []};

get_companion_stage(10,14,8) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 8,biography = 0,need_blessing = 384,attr = [{1,7530},{2,150600},{3,3765},{4,3765}],other = []};

get_companion_stage(10,14,9) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 9,biography = 0,need_blessing = 387,attr = [{1,7560},{2,151200},{3,3780},{4,3780}],other = []};

get_companion_stage(10,14,10) ->
	#base_companion_stage{companion_id = 10,stage = 14,star = 10,biography = 0,need_blessing = 390,attr = [{1,7620},{2,152400},{3,3810},{4,3810}],other = []};

get_companion_stage(10,15,1) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 1,biography = 0,need_blessing = 393,attr = [{1,7650},{2,153000},{3,3825},{4,3825}],other = []};

get_companion_stage(10,15,2) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 2,biography = 0,need_blessing = 397,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],other = []};

get_companion_stage(10,15,3) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 3,biography = 0,need_blessing = 400,attr = [{1,7710},{2,154200},{3,3855},{4,3855}],other = []};

get_companion_stage(10,15,4) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 4,biography = 0,need_blessing = 403,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],other = []};

get_companion_stage(10,15,5) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 5,biography = 0,need_blessing = 406,attr = [{1,7770},{2,155400},{3,3885},{4,3885}],other = []};

get_companion_stage(10,15,6) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 6,biography = 0,need_blessing = 410,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],other = []};

get_companion_stage(10,15,7) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 7,biography = 0,need_blessing = 413,attr = [{1,7830},{2,156600},{3,3915},{4,3915}],other = []};

get_companion_stage(10,15,8) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 8,biography = 0,need_blessing = 416,attr = [{1,7860},{2,157200},{3,3930},{4,3930}],other = []};

get_companion_stage(10,15,9) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 9,biography = 0,need_blessing = 419,attr = [{1,7890},{2,157800},{3,3945},{4,3945}],other = []};

get_companion_stage(10,15,10) ->
	#base_companion_stage{companion_id = 10,stage = 15,star = 10,biography = 0,need_blessing = 423,attr = [{1,7950},{2,159000},{3,3975},{4,3975}],other = []};

get_companion_stage(10,16,1) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 1,biography = 0,need_blessing = 426,attr = [{1,7980},{2,159600},{3,3990},{4,3990}],other = []};

get_companion_stage(10,16,2) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 2,biography = 0,need_blessing = 429,attr = [{1,8010},{2,160200},{3,4005},{4,4005}],other = []};

get_companion_stage(10,16,3) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 3,biography = 0,need_blessing = 433,attr = [{1,8040},{2,160800},{3,4020},{4,4020}],other = []};

get_companion_stage(10,16,4) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 4,biography = 0,need_blessing = 436,attr = [{1,8070},{2,161400},{3,4035},{4,4035}],other = []};

get_companion_stage(10,16,5) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 5,biography = 0,need_blessing = 439,attr = [{1,8100},{2,162000},{3,4050},{4,4050}],other = []};

get_companion_stage(10,16,6) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 6,biography = 0,need_blessing = 442,attr = [{1,8130},{2,162600},{3,4065},{4,4065}],other = []};

get_companion_stage(10,16,7) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 7,biography = 0,need_blessing = 446,attr = [{1,8160},{2,163200},{3,4080},{4,4080}],other = []};

get_companion_stage(10,16,8) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 8,biography = 0,need_blessing = 449,attr = [{1,8190},{2,163800},{3,4095},{4,4095}],other = []};

get_companion_stage(10,16,9) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 9,biography = 0,need_blessing = 452,attr = [{1,8220},{2,164400},{3,4110},{4,4110}],other = []};

get_companion_stage(10,16,10) ->
	#base_companion_stage{companion_id = 10,stage = 16,star = 10,biography = 0,need_blessing = 456,attr = [{1,8280},{2,165600},{3,4140},{4,4140}],other = []};

get_companion_stage(10,17,1) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 1,biography = 0,need_blessing = 459,attr = [{1,8310},{2,166200},{3,4155},{4,4155}],other = []};

get_companion_stage(10,17,2) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 2,biography = 0,need_blessing = 462,attr = [{1,8340},{2,166800},{3,4170},{4,4170}],other = []};

get_companion_stage(10,17,3) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 3,biography = 0,need_blessing = 466,attr = [{1,8370},{2,167400},{3,4185},{4,4185}],other = []};

get_companion_stage(10,17,4) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 4,biography = 0,need_blessing = 469,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(10,17,5) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 5,biography = 0,need_blessing = 472,attr = [{1,8430},{2,168600},{3,4215},{4,4215}],other = []};

get_companion_stage(10,17,6) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 6,biography = 0,need_blessing = 476,attr = [{1,8460},{2,169200},{3,4230},{4,4230}],other = []};

get_companion_stage(10,17,7) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 7,biography = 0,need_blessing = 479,attr = [{1,8490},{2,169800},{3,4245},{4,4245}],other = []};

get_companion_stage(10,17,8) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 8,biography = 0,need_blessing = 482,attr = [{1,8520},{2,170400},{3,4260},{4,4260}],other = []};

get_companion_stage(10,17,9) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 9,biography = 0,need_blessing = 486,attr = [{1,8550},{2,171000},{3,4275},{4,4275}],other = []};

get_companion_stage(10,17,10) ->
	#base_companion_stage{companion_id = 10,stage = 17,star = 10,biography = 0,need_blessing = 489,attr = [{1,8610},{2,172200},{3,4305},{4,4305}],other = []};

get_companion_stage(10,18,1) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 1,biography = 0,need_blessing = 492,attr = [{1,8640},{2,172800},{3,4320},{4,4320}],other = []};

get_companion_stage(10,18,2) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 2,biography = 0,need_blessing = 496,attr = [{1,8670},{2,173400},{3,4335},{4,4335}],other = []};

get_companion_stage(10,18,3) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 3,biography = 0,need_blessing = 499,attr = [{1,8700},{2,174000},{3,4350},{4,4350}],other = []};

get_companion_stage(10,18,4) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 4,biography = 0,need_blessing = 503,attr = [{1,8730},{2,174600},{3,4365},{4,4365}],other = []};

get_companion_stage(10,18,5) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 5,biography = 0,need_blessing = 506,attr = [{1,8760},{2,175200},{3,4380},{4,4380}],other = []};

get_companion_stage(10,18,6) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 6,biography = 0,need_blessing = 509,attr = [{1,8790},{2,175800},{3,4395},{4,4395}],other = []};

get_companion_stage(10,18,7) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 7,biography = 0,need_blessing = 513,attr = [{1,8820},{2,176400},{3,4410},{4,4410}],other = []};

get_companion_stage(10,18,8) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 8,biography = 0,need_blessing = 516,attr = [{1,8850},{2,177000},{3,4425},{4,4425}],other = []};

get_companion_stage(10,18,9) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 9,biography = 0,need_blessing = 519,attr = [{1,8880},{2,177600},{3,4440},{4,4440}],other = []};

get_companion_stage(10,18,10) ->
	#base_companion_stage{companion_id = 10,stage = 18,star = 10,biography = 0,need_blessing = 523,attr = [{1,8940},{2,178800},{3,4470},{4,4470}],other = []};

get_companion_stage(10,19,1) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 1,biography = 0,need_blessing = 526,attr = [{1,8970},{2,179400},{3,4485},{4,4485}],other = []};

get_companion_stage(10,19,2) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 2,biography = 0,need_blessing = 530,attr = [{1,9000},{2,180000},{3,4500},{4,4500}],other = []};

get_companion_stage(10,19,3) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 3,biography = 0,need_blessing = 533,attr = [{1,9030},{2,180600},{3,4515},{4,4515}],other = []};

get_companion_stage(10,19,4) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 4,biography = 0,need_blessing = 536,attr = [{1,9060},{2,181200},{3,4530},{4,4530}],other = []};

get_companion_stage(10,19,5) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 5,biography = 0,need_blessing = 540,attr = [{1,9090},{2,181800},{3,4545},{4,4545}],other = []};

get_companion_stage(10,19,6) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 6,biography = 0,need_blessing = 543,attr = [{1,9120},{2,182400},{3,4560},{4,4560}],other = []};

get_companion_stage(10,19,7) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 7,biography = 0,need_blessing = 547,attr = [{1,9150},{2,183000},{3,4575},{4,4575}],other = []};

get_companion_stage(10,19,8) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 8,biography = 0,need_blessing = 550,attr = [{1,9180},{2,183600},{3,4590},{4,4590}],other = []};

get_companion_stage(10,19,9) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 9,biography = 0,need_blessing = 554,attr = [{1,9210},{2,184200},{3,4605},{4,4605}],other = []};

get_companion_stage(10,19,10) ->
	#base_companion_stage{companion_id = 10,stage = 19,star = 10,biography = 0,need_blessing = 557,attr = [{1,9270},{2,185400},{3,4635},{4,4635}],other = []};

get_companion_stage(10,20,1) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 1,biography = 0,need_blessing = 560,attr = [{1,9300},{2,186000},{3,4650},{4,4650}],other = []};

get_companion_stage(10,20,2) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 2,biography = 0,need_blessing = 564,attr = [{1,9330},{2,186600},{3,4665},{4,4665}],other = []};

get_companion_stage(10,20,3) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 3,biography = 0,need_blessing = 567,attr = [{1,9360},{2,187200},{3,4680},{4,4680}],other = []};

get_companion_stage(10,20,4) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 4,biography = 0,need_blessing = 571,attr = [{1,9390},{2,187800},{3,4695},{4,4695}],other = []};

get_companion_stage(10,20,5) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 5,biography = 0,need_blessing = 574,attr = [{1,9420},{2,188400},{3,4710},{4,4710}],other = []};

get_companion_stage(10,20,6) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 6,biography = 0,need_blessing = 578,attr = [{1,9450},{2,189000},{3,4725},{4,4725}],other = []};

get_companion_stage(10,20,7) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 7,biography = 0,need_blessing = 581,attr = [{1,9480},{2,189600},{3,4740},{4,4740}],other = []};

get_companion_stage(10,20,8) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 8,biography = 0,need_blessing = 585,attr = [{1,9510},{2,190200},{3,4755},{4,4755}],other = []};

get_companion_stage(10,20,9) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 9,biography = 0,need_blessing = 588,attr = [{1,9540},{2,190800},{3,4770},{4,4770}],other = []};

get_companion_stage(10,20,10) ->
	#base_companion_stage{companion_id = 10,stage = 20,star = 10,biography = 0,need_blessing = 592,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(10,21,1) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 1,biography = 0,need_blessing = 595,attr = [{1,9630},{2,192600},{3,4815},{4,4815}],other = []};

get_companion_stage(10,21,2) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 2,biography = 0,need_blessing = 598,attr = [{1,9660},{2,193200},{3,4830},{4,4830}],other = []};

get_companion_stage(10,21,3) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 3,biography = 0,need_blessing = 602,attr = [{1,9690},{2,193800},{3,4845},{4,4845}],other = []};

get_companion_stage(10,21,4) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 4,biography = 0,need_blessing = 605,attr = [{1,9720},{2,194400},{3,4860},{4,4860}],other = []};

get_companion_stage(10,21,5) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 5,biography = 0,need_blessing = 609,attr = [{1,9750},{2,195000},{3,4875},{4,4875}],other = []};

get_companion_stage(10,21,6) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 6,biography = 0,need_blessing = 612,attr = [{1,9780},{2,195600},{3,4890},{4,4890}],other = []};

get_companion_stage(10,21,7) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 7,biography = 0,need_blessing = 616,attr = [{1,9810},{2,196200},{3,4905},{4,4905}],other = []};

get_companion_stage(10,21,8) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 8,biography = 0,need_blessing = 619,attr = [{1,9840},{2,196800},{3,4920},{4,4920}],other = []};

get_companion_stage(10,21,9) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 9,biography = 0,need_blessing = 623,attr = [{1,9870},{2,197400},{3,4935},{4,4935}],other = []};

get_companion_stage(10,21,10) ->
	#base_companion_stage{companion_id = 10,stage = 21,star = 10,biography = 0,need_blessing = 626,attr = [{1,9930},{2,198600},{3,4965},{4,4965}],other = []};

get_companion_stage(10,22,1) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 1,biography = 0,need_blessing = 630,attr = [{1,9960},{2,199200},{3,4980},{4,4980}],other = []};

get_companion_stage(10,22,2) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 2,biography = 0,need_blessing = 633,attr = [{1,9990},{2,199800},{3,4995},{4,4995}],other = []};

get_companion_stage(10,22,3) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 3,biography = 0,need_blessing = 637,attr = [{1,10020},{2,200400},{3,5010},{4,5010}],other = []};

get_companion_stage(10,22,4) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 4,biography = 0,need_blessing = 640,attr = [{1,10050},{2,201000},{3,5025},{4,5025}],other = []};

get_companion_stage(10,22,5) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 5,biography = 0,need_blessing = 644,attr = [{1,10080},{2,201600},{3,5040},{4,5040}],other = []};

get_companion_stage(10,22,6) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 6,biography = 0,need_blessing = 647,attr = [{1,10110},{2,202200},{3,5055},{4,5055}],other = []};

get_companion_stage(10,22,7) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 7,biography = 0,need_blessing = 651,attr = [{1,10140},{2,202800},{3,5070},{4,5070}],other = []};

get_companion_stage(10,22,8) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 8,biography = 0,need_blessing = 655,attr = [{1,10170},{2,203400},{3,5085},{4,5085}],other = []};

get_companion_stage(10,22,9) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 9,biography = 0,need_blessing = 658,attr = [{1,10200},{2,204000},{3,5100},{4,5100}],other = []};

get_companion_stage(10,22,10) ->
	#base_companion_stage{companion_id = 10,stage = 22,star = 10,biography = 0,need_blessing = 662,attr = [{1,10260},{2,205200},{3,5130},{4,5130}],other = []};

get_companion_stage(10,23,1) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 1,biography = 0,need_blessing = 665,attr = [{1,10290},{2,205800},{3,5145},{4,5145}],other = []};

get_companion_stage(10,23,2) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 2,biography = 0,need_blessing = 669,attr = [{1,10320},{2,206400},{3,5160},{4,5160}],other = []};

get_companion_stage(10,23,3) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 3,biography = 0,need_blessing = 672,attr = [{1,10350},{2,207000},{3,5175},{4,5175}],other = []};

get_companion_stage(10,23,4) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 4,biography = 0,need_blessing = 676,attr = [{1,10380},{2,207600},{3,5190},{4,5190}],other = []};

get_companion_stage(10,23,5) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 5,biography = 0,need_blessing = 679,attr = [{1,10410},{2,208200},{3,5205},{4,5205}],other = []};

get_companion_stage(10,23,6) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 6,biography = 0,need_blessing = 683,attr = [{1,10440},{2,208800},{3,5220},{4,5220}],other = []};

get_companion_stage(10,23,7) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 7,biography = 0,need_blessing = 686,attr = [{1,10470},{2,209400},{3,5235},{4,5235}],other = []};

get_companion_stage(10,23,8) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 8,biography = 0,need_blessing = 690,attr = [{1,10500},{2,210000},{3,5250},{4,5250}],other = []};

get_companion_stage(10,23,9) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 9,biography = 0,need_blessing = 694,attr = [{1,10530},{2,210600},{3,5265},{4,5265}],other = []};

get_companion_stage(10,23,10) ->
	#base_companion_stage{companion_id = 10,stage = 23,star = 10,biography = 0,need_blessing = 697,attr = [{1,10590},{2,211800},{3,5295},{4,5295}],other = []};

get_companion_stage(10,24,1) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 1,biography = 0,need_blessing = 701,attr = [{1,10620},{2,212400},{3,5310},{4,5310}],other = []};

get_companion_stage(10,24,2) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 2,biography = 0,need_blessing = 704,attr = [{1,10650},{2,213000},{3,5325},{4,5325}],other = []};

get_companion_stage(10,24,3) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 3,biography = 0,need_blessing = 708,attr = [{1,10680},{2,213600},{3,5340},{4,5340}],other = []};

get_companion_stage(10,24,4) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 4,biography = 0,need_blessing = 711,attr = [{1,10710},{2,214200},{3,5355},{4,5355}],other = []};

get_companion_stage(10,24,5) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 5,biography = 0,need_blessing = 715,attr = [{1,10740},{2,214800},{3,5370},{4,5370}],other = []};

get_companion_stage(10,24,6) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 6,biography = 0,need_blessing = 719,attr = [{1,10770},{2,215400},{3,5385},{4,5385}],other = []};

get_companion_stage(10,24,7) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 7,biography = 0,need_blessing = 722,attr = [{1,10800},{2,216000},{3,5400},{4,5400}],other = []};

get_companion_stage(10,24,8) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 8,biography = 0,need_blessing = 726,attr = [{1,10830},{2,216600},{3,5415},{4,5415}],other = []};

get_companion_stage(10,24,9) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 9,biography = 0,need_blessing = 729,attr = [{1,10860},{2,217200},{3,5430},{4,5430}],other = []};

get_companion_stage(10,24,10) ->
	#base_companion_stage{companion_id = 10,stage = 24,star = 10,biography = 0,need_blessing = 733,attr = [{1,10920},{2,218400},{3,5460},{4,5460}],other = []};

get_companion_stage(10,25,1) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 1,biography = 0,need_blessing = 737,attr = [{1,10950},{2,219000},{3,5475},{4,5475}],other = []};

get_companion_stage(10,25,2) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 2,biography = 0,need_blessing = 740,attr = [{1,10980},{2,219600},{3,5490},{4,5490}],other = []};

get_companion_stage(10,25,3) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 3,biography = 0,need_blessing = 744,attr = [{1,11010},{2,220200},{3,5505},{4,5505}],other = []};

get_companion_stage(10,25,4) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 4,biography = 0,need_blessing = 747,attr = [{1,11040},{2,220800},{3,5520},{4,5520}],other = []};

get_companion_stage(10,25,5) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 5,biography = 0,need_blessing = 751,attr = [{1,11070},{2,221400},{3,5535},{4,5535}],other = []};

get_companion_stage(10,25,6) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 6,biography = 0,need_blessing = 755,attr = [{1,11100},{2,222000},{3,5550},{4,5550}],other = []};

get_companion_stage(10,25,7) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 7,biography = 0,need_blessing = 758,attr = [{1,11130},{2,222600},{3,5565},{4,5565}],other = []};

get_companion_stage(10,25,8) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 8,biography = 0,need_blessing = 762,attr = [{1,11160},{2,223200},{3,5580},{4,5580}],other = []};

get_companion_stage(10,25,9) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 9,biography = 0,need_blessing = 765,attr = [{1,11190},{2,223800},{3,5595},{4,5595}],other = []};

get_companion_stage(10,25,10) ->
	#base_companion_stage{companion_id = 10,stage = 25,star = 10,biography = 0,need_blessing = 769,attr = [{1,11250},{2,225000},{3,5625},{4,5625}],other = []};

get_companion_stage(10,26,1) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 1,biography = 0,need_blessing = 773,attr = [{1,11280},{2,225600},{3,5640},{4,5640}],other = []};

get_companion_stage(10,26,2) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 2,biography = 0,need_blessing = 776,attr = [{1,11310},{2,226200},{3,5655},{4,5655}],other = []};

get_companion_stage(10,26,3) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 3,biography = 0,need_blessing = 780,attr = [{1,11340},{2,226800},{3,5670},{4,5670}],other = []};

get_companion_stage(10,26,4) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 4,biography = 0,need_blessing = 784,attr = [{1,11370},{2,227400},{3,5685},{4,5685}],other = []};

get_companion_stage(10,26,5) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 5,biography = 0,need_blessing = 787,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = []};

get_companion_stage(10,26,6) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 6,biography = 0,need_blessing = 791,attr = [{1,11430},{2,228600},{3,5715},{4,5715}],other = []};

get_companion_stage(10,26,7) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 7,biography = 0,need_blessing = 794,attr = [{1,11460},{2,229200},{3,5730},{4,5730}],other = []};

get_companion_stage(10,26,8) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 8,biography = 0,need_blessing = 798,attr = [{1,11490},{2,229800},{3,5745},{4,5745}],other = []};

get_companion_stage(10,26,9) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 9,biography = 0,need_blessing = 802,attr = [{1,11520},{2,230400},{3,5760},{4,5760}],other = []};

get_companion_stage(10,26,10) ->
	#base_companion_stage{companion_id = 10,stage = 26,star = 10,biography = 0,need_blessing = 805,attr = [{1,11580},{2,231600},{3,5790},{4,5790}],other = []};

get_companion_stage(10,27,1) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 1,biography = 0,need_blessing = 809,attr = [{1,11610},{2,232200},{3,5805},{4,5805}],other = []};

get_companion_stage(10,27,2) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 2,biography = 0,need_blessing = 813,attr = [{1,11640},{2,232800},{3,5820},{4,5820}],other = []};

get_companion_stage(10,27,3) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 3,biography = 0,need_blessing = 816,attr = [{1,11670},{2,233400},{3,5835},{4,5835}],other = []};

get_companion_stage(10,27,4) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 4,biography = 0,need_blessing = 820,attr = [{1,11700},{2,234000},{3,5850},{4,5850}],other = []};

get_companion_stage(10,27,5) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 5,biography = 0,need_blessing = 824,attr = [{1,11730},{2,234600},{3,5865},{4,5865}],other = []};

get_companion_stage(10,27,6) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 6,biography = 0,need_blessing = 827,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],other = []};

get_companion_stage(10,27,7) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 7,biography = 0,need_blessing = 831,attr = [{1,11790},{2,235800},{3,5895},{4,5895}],other = []};

get_companion_stage(10,27,8) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 8,biography = 0,need_blessing = 835,attr = [{1,11820},{2,236400},{3,5910},{4,5910}],other = []};

get_companion_stage(10,27,9) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 9,biography = 0,need_blessing = 838,attr = [{1,11850},{2,237000},{3,5925},{4,5925}],other = []};

get_companion_stage(10,27,10) ->
	#base_companion_stage{companion_id = 10,stage = 27,star = 10,biography = 0,need_blessing = 842,attr = [{1,11910},{2,238200},{3,5955},{4,5955}],other = []};

get_companion_stage(10,28,1) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 1,biography = 0,need_blessing = 846,attr = [{1,11940},{2,238800},{3,5970},{4,5970}],other = []};

get_companion_stage(10,28,2) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 2,biography = 0,need_blessing = 849,attr = [{1,11970},{2,239400},{3,5985},{4,5985}],other = []};

get_companion_stage(10,28,3) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 3,biography = 0,need_blessing = 853,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],other = []};

get_companion_stage(10,28,4) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 4,biography = 0,need_blessing = 857,attr = [{1,12030},{2,240600},{3,6015},{4,6015}],other = []};

get_companion_stage(10,28,5) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 5,biography = 0,need_blessing = 861,attr = [{1,12060},{2,241200},{3,6030},{4,6030}],other = []};

get_companion_stage(10,28,6) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 6,biography = 0,need_blessing = 864,attr = [{1,12090},{2,241800},{3,6045},{4,6045}],other = []};

get_companion_stage(10,28,7) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 7,biography = 0,need_blessing = 868,attr = [{1,12120},{2,242400},{3,6060},{4,6060}],other = []};

get_companion_stage(10,28,8) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 8,biography = 0,need_blessing = 872,attr = [{1,12150},{2,243000},{3,6075},{4,6075}],other = []};

get_companion_stage(10,28,9) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 9,biography = 0,need_blessing = 875,attr = [{1,12180},{2,243600},{3,6090},{4,6090}],other = []};

get_companion_stage(10,28,10) ->
	#base_companion_stage{companion_id = 10,stage = 28,star = 10,biography = 0,need_blessing = 879,attr = [{1,12240},{2,244800},{3,6120},{4,6120}],other = []};

get_companion_stage(10,29,1) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 1,biography = 0,need_blessing = 883,attr = [{1,12270},{2,245400},{3,6135},{4,6135}],other = []};

get_companion_stage(10,29,2) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 2,biography = 0,need_blessing = 886,attr = [{1,12300},{2,246000},{3,6150},{4,6150}],other = []};

get_companion_stage(10,29,3) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 3,biography = 0,need_blessing = 890,attr = [{1,12330},{2,246600},{3,6165},{4,6165}],other = []};

get_companion_stage(10,29,4) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 4,biography = 0,need_blessing = 894,attr = [{1,12360},{2,247200},{3,6180},{4,6180}],other = []};

get_companion_stage(10,29,5) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 5,biography = 0,need_blessing = 898,attr = [{1,12390},{2,247800},{3,6195},{4,6195}],other = []};

get_companion_stage(10,29,6) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 6,biography = 0,need_blessing = 901,attr = [{1,12420},{2,248400},{3,6210},{4,6210}],other = []};

get_companion_stage(10,29,7) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 7,biography = 0,need_blessing = 905,attr = [{1,12450},{2,249000},{3,6225},{4,6225}],other = []};

get_companion_stage(10,29,8) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 8,biography = 0,need_blessing = 909,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(10,29,9) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 9,biography = 0,need_blessing = 913,attr = [{1,12510},{2,250200},{3,6255},{4,6255}],other = []};

get_companion_stage(10,29,10) ->
	#base_companion_stage{companion_id = 10,stage = 29,star = 10,biography = 0,need_blessing = 916,attr = [{1,12570},{2,251400},{3,6285},{4,6285}],other = []};

get_companion_stage(10,30,1) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 1,biography = 0,need_blessing = 920,attr = [{1,12600},{2,252000},{3,6300},{4,6300}],other = []};

get_companion_stage(10,30,2) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,12630},{2,252600},{3,6315},{4,6315}],other = []};

get_companion_stage(10,30,3) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,12660},{2,253200},{3,6330},{4,6330}],other = []};

get_companion_stage(10,30,4) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,12690},{2,253800},{3,6345},{4,6345}],other = []};

get_companion_stage(10,30,5) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,12720},{2,254400},{3,6360},{4,6360}],other = []};

get_companion_stage(10,30,6) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,12750},{2,255000},{3,6375},{4,6375}],other = []};

get_companion_stage(10,30,7) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,12780},{2,255600},{3,6390},{4,6390}],other = []};

get_companion_stage(10,30,8) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,12810},{2,256200},{3,6405},{4,6405}],other = []};

get_companion_stage(10,30,9) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,12840},{2,256800},{3,6420},{4,6420}],other = []};

get_companion_stage(10,30,10) ->
	#base_companion_stage{companion_id = 10,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,12900},{2,258000},{3,6450},{4,6450}],other = []};

get_companion_stage(11,1,0) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],other = []};

get_companion_stage(11,1,1) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],other = []};

get_companion_stage(11,1,2) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,7160},{2,143200},{3,3580},{4,3580}],other = []};

get_companion_stage(11,1,3) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,7240},{2,144800},{3,3620},{4,3620}],other = []};

get_companion_stage(11,1,4) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],other = []};

get_companion_stage(11,1,5) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,7400},{2,148000},{3,3700},{4,3700}],other = []};

get_companion_stage(11,1,6) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,7480},{2,149600},{3,3740},{4,3740}],other = []};

get_companion_stage(11,1,7) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,7560},{2,151200},{3,3780},{4,3780}],other = []};

get_companion_stage(11,1,8) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,7640},{2,152800},{3,3820},{4,3820}],other = []};

get_companion_stage(11,1,9) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,7720},{2,154400},{3,3860},{4,3860}],other = []};

get_companion_stage(11,1,10) ->
	#base_companion_stage{companion_id = 11,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,7880},{2,157600},{3,3940},{4,3940}],other = [{biog_reward, [{2,0,100},{0, 22030011, 3},{0, 22030111, 1}]}]};

get_companion_stage(11,2,1) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,7960},{2,159200},{3,3980},{4,3980}],other = []};

get_companion_stage(11,2,2) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,8040},{2,160800},{3,4020},{4,4020}],other = []};

get_companion_stage(11,2,3) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,8120},{2,162400},{3,4060},{4,4060}],other = []};

get_companion_stage(11,2,4) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,8200},{2,164000},{3,4100},{4,4100}],other = []};

get_companion_stage(11,2,5) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,8280},{2,165600},{3,4140},{4,4140}],other = []};

get_companion_stage(11,2,6) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,8360},{2,167200},{3,4180},{4,4180}],other = []};

get_companion_stage(11,2,7) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,8440},{2,168800},{3,4220},{4,4220}],other = []};

get_companion_stage(11,2,8) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,8520},{2,170400},{3,4260},{4,4260}],other = []};

get_companion_stage(11,2,9) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,8600},{2,172000},{3,4300},{4,4300}],other = []};

get_companion_stage(11,2,10) ->
	#base_companion_stage{companion_id = 11,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,8760},{2,175200},{3,4380},{4,4380}],other = []};

get_companion_stage(11,3,1) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,8840},{2,176800},{3,4420},{4,4420}],other = []};

get_companion_stage(11,3,2) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,8920},{2,178400},{3,4460},{4,4460}],other = []};

get_companion_stage(11,3,3) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,9000},{2,180000},{3,4500},{4,4500}],other = []};

get_companion_stage(11,3,4) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,9080},{2,181600},{3,4540},{4,4540}],other = []};

get_companion_stage(11,3,5) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,9160},{2,183200},{3,4580},{4,4580}],other = []};

get_companion_stage(11,3,6) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,9240},{2,184800},{3,4620},{4,4620}],other = []};

get_companion_stage(11,3,7) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,9320},{2,186400},{3,4660},{4,4660}],other = []};

get_companion_stage(11,3,8) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,9400},{2,188000},{3,4700},{4,4700}],other = []};

get_companion_stage(11,3,9) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,9480},{2,189600},{3,4740},{4,4740}],other = []};

get_companion_stage(11,3,10) ->
	#base_companion_stage{companion_id = 11,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,9640},{2,192800},{3,4820},{4,4820}],other = [{biog_reward, [{2,0,200},{0, 22030011, 5},{0, 22030111, 3}]}]};

get_companion_stage(11,4,1) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,9720},{2,194400},{3,4860},{4,4860}],other = []};

get_companion_stage(11,4,2) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,9800},{2,196000},{3,4900},{4,4900}],other = []};

get_companion_stage(11,4,3) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,9880},{2,197600},{3,4940},{4,4940}],other = []};

get_companion_stage(11,4,4) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,9960},{2,199200},{3,4980},{4,4980}],other = []};

get_companion_stage(11,4,5) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,10040},{2,200800},{3,5020},{4,5020}],other = []};

get_companion_stage(11,4,6) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,10120},{2,202400},{3,5060},{4,5060}],other = []};

get_companion_stage(11,4,7) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,10200},{2,204000},{3,5100},{4,5100}],other = []};

get_companion_stage(11,4,8) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,10280},{2,205600},{3,5140},{4,5140}],other = []};

get_companion_stage(11,4,9) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,10360},{2,207200},{3,5180},{4,5180}],other = []};

get_companion_stage(11,4,10) ->
	#base_companion_stage{companion_id = 11,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,10520},{2,210400},{3,5260},{4,5260}],other = []};

get_companion_stage(11,5,1) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,10600},{2,212000},{3,5300},{4,5300}],other = []};

get_companion_stage(11,5,2) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,10680},{2,213600},{3,5340},{4,5340}],other = []};

get_companion_stage(11,5,3) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,10760},{2,215200},{3,5380},{4,5380}],other = []};

get_companion_stage(11,5,4) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,10840},{2,216800},{3,5420},{4,5420}],other = []};

get_companion_stage(11,5,5) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,10920},{2,218400},{3,5460},{4,5460}],other = []};

get_companion_stage(11,5,6) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,11000},{2,220000},{3,5500},{4,5500}],other = []};

get_companion_stage(11,5,7) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,11080},{2,221600},{3,5540},{4,5540}],other = []};

get_companion_stage(11,5,8) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,11160},{2,223200},{3,5580},{4,5580}],other = []};

get_companion_stage(11,5,9) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,11240},{2,224800},{3,5620},{4,5620}],other = []};

get_companion_stage(11,5,10) ->
	#base_companion_stage{companion_id = 11,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,11400},{2,228000},{3,5700},{4,5700}],other = [{biog_reward, [{2,0,250},{0, 22030011, 10},{0, 22030111, 5}]}]};

get_companion_stage(11,6,1) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,11480},{2,229600},{3,5740},{4,5740}],other = []};

get_companion_stage(11,6,2) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,11560},{2,231200},{3,5780},{4,5780}],other = []};

get_companion_stage(11,6,3) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,11640},{2,232800},{3,5820},{4,5820}],other = []};

get_companion_stage(11,6,4) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,11720},{2,234400},{3,5860},{4,5860}],other = []};

get_companion_stage(11,6,5) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,11800},{2,236000},{3,5900},{4,5900}],other = []};

get_companion_stage(11,6,6) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,11880},{2,237600},{3,5940},{4,5940}],other = []};

get_companion_stage(11,6,7) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,11960},{2,239200},{3,5980},{4,5980}],other = []};

get_companion_stage(11,6,8) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,12040},{2,240800},{3,6020},{4,6020}],other = []};

get_companion_stage(11,6,9) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,12120},{2,242400},{3,6060},{4,6060}],other = []};

get_companion_stage(11,6,10) ->
	#base_companion_stage{companion_id = 11,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,12280},{2,245600},{3,6140},{4,6140}],other = []};

get_companion_stage(11,7,1) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,12360},{2,247200},{3,6180},{4,6180}],other = []};

get_companion_stage(11,7,2) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,12440},{2,248800},{3,6220},{4,6220}],other = []};

get_companion_stage(11,7,3) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,12520},{2,250400},{3,6260},{4,6260}],other = []};

get_companion_stage(11,7,4) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,12600},{2,252000},{3,6300},{4,6300}],other = []};

get_companion_stage(11,7,5) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,12680},{2,253600},{3,6340},{4,6340}],other = []};

get_companion_stage(11,7,6) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,12760},{2,255200},{3,6380},{4,6380}],other = []};

get_companion_stage(11,7,7) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,12840},{2,256800},{3,6420},{4,6420}],other = []};

get_companion_stage(11,7,8) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,12920},{2,258400},{3,6460},{4,6460}],other = []};

get_companion_stage(11,7,9) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,13000},{2,260000},{3,6500},{4,6500}],other = []};

get_companion_stage(11,7,10) ->
	#base_companion_stage{companion_id = 11,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,13160},{2,263200},{3,6580},{4,6580}],other = []};

get_companion_stage(11,8,1) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,13240},{2,264800},{3,6620},{4,6620}],other = []};

get_companion_stage(11,8,2) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,13320},{2,266400},{3,6660},{4,6660}],other = []};

get_companion_stage(11,8,3) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,13400},{2,268000},{3,6700},{4,6700}],other = []};

get_companion_stage(11,8,4) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,13480},{2,269600},{3,6740},{4,6740}],other = []};

get_companion_stage(11,8,5) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,13560},{2,271200},{3,6780},{4,6780}],other = []};

get_companion_stage(11,8,6) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,13640},{2,272800},{3,6820},{4,6820}],other = []};

get_companion_stage(11,8,7) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,13720},{2,274400},{3,6860},{4,6860}],other = []};

get_companion_stage(11,8,8) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,13800},{2,276000},{3,6900},{4,6900}],other = []};

get_companion_stage(11,8,9) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,13880},{2,277600},{3,6940},{4,6940}],other = []};

get_companion_stage(11,8,10) ->
	#base_companion_stage{companion_id = 11,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,14040},{2,280800},{3,7020},{4,7020}],other = []};

get_companion_stage(11,9,1) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,14120},{2,282400},{3,7060},{4,7060}],other = []};

get_companion_stage(11,9,2) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,14200},{2,284000},{3,7100},{4,7100}],other = []};

get_companion_stage(11,9,3) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,14280},{2,285600},{3,7140},{4,7140}],other = []};

get_companion_stage(11,9,4) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,14360},{2,287200},{3,7180},{4,7180}],other = []};

get_companion_stage(11,9,5) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,14440},{2,288800},{3,7220},{4,7220}],other = []};

get_companion_stage(11,9,6) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,14520},{2,290400},{3,7260},{4,7260}],other = []};

get_companion_stage(11,9,7) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,14600},{2,292000},{3,7300},{4,7300}],other = []};

get_companion_stage(11,9,8) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,14680},{2,293600},{3,7340},{4,7340}],other = []};

get_companion_stage(11,9,9) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,14760},{2,295200},{3,7380},{4,7380}],other = []};

get_companion_stage(11,9,10) ->
	#base_companion_stage{companion_id = 11,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,14920},{2,298400},{3,7460},{4,7460}],other = []};

get_companion_stage(11,10,1) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,15000},{2,300000},{3,7500},{4,7500}],other = []};

get_companion_stage(11,10,2) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,15080},{2,301600},{3,7540},{4,7540}],other = []};

get_companion_stage(11,10,3) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,15160},{2,303200},{3,7580},{4,7580}],other = []};

get_companion_stage(11,10,4) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,15240},{2,304800},{3,7620},{4,7620}],other = []};

get_companion_stage(11,10,5) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,15320},{2,306400},{3,7660},{4,7660}],other = []};

get_companion_stage(11,10,6) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,15400},{2,308000},{3,7700},{4,7700}],other = []};

get_companion_stage(11,10,7) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,15480},{2,309600},{3,7740},{4,7740}],other = []};

get_companion_stage(11,10,8) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,15560},{2,311200},{3,7780},{4,7780}],other = []};

get_companion_stage(11,10,9) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,15640},{2,312800},{3,7820},{4,7820}],other = []};

get_companion_stage(11,10,10) ->
	#base_companion_stage{companion_id = 11,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,15800},{2,316000},{3,7900},{4,7900}],other = []};

get_companion_stage(11,11,1) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,15880},{2,317600},{3,7940},{4,7940}],other = []};

get_companion_stage(11,11,2) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,15960},{2,319200},{3,7980},{4,7980}],other = []};

get_companion_stage(11,11,3) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,16040},{2,320800},{3,8020},{4,8020}],other = []};

get_companion_stage(11,11,4) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,16120},{2,322400},{3,8060},{4,8060}],other = []};

get_companion_stage(11,11,5) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,16200},{2,324000},{3,8100},{4,8100}],other = []};

get_companion_stage(11,11,6) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,16280},{2,325600},{3,8140},{4,8140}],other = []};

get_companion_stage(11,11,7) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,16360},{2,327200},{3,8180},{4,8180}],other = []};

get_companion_stage(11,11,8) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,16440},{2,328800},{3,8220},{4,8220}],other = []};

get_companion_stage(11,11,9) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,16520},{2,330400},{3,8260},{4,8260}],other = []};

get_companion_stage(11,11,10) ->
	#base_companion_stage{companion_id = 11,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,16680},{2,333600},{3,8340},{4,8340}],other = []};

get_companion_stage(11,12,1) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,16760},{2,335200},{3,8380},{4,8380}],other = []};

get_companion_stage(11,12,2) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,16840},{2,336800},{3,8420},{4,8420}],other = []};

get_companion_stage(11,12,3) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,16920},{2,338400},{3,8460},{4,8460}],other = []};

get_companion_stage(11,12,4) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,17000},{2,340000},{3,8500},{4,8500}],other = []};

get_companion_stage(11,12,5) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,17080},{2,341600},{3,8540},{4,8540}],other = []};

get_companion_stage(11,12,6) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,17160},{2,343200},{3,8580},{4,8580}],other = []};

get_companion_stage(11,12,7) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,17240},{2,344800},{3,8620},{4,8620}],other = []};

get_companion_stage(11,12,8) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,17320},{2,346400},{3,8660},{4,8660}],other = []};

get_companion_stage(11,12,9) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,17400},{2,348000},{3,8700},{4,8700}],other = []};

get_companion_stage(11,12,10) ->
	#base_companion_stage{companion_id = 11,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,17560},{2,351200},{3,8780},{4,8780}],other = []};

get_companion_stage(11,13,1) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,17640},{2,352800},{3,8820},{4,8820}],other = []};

get_companion_stage(11,13,2) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,17720},{2,354400},{3,8860},{4,8860}],other = []};

get_companion_stage(11,13,3) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,17800},{2,356000},{3,8900},{4,8900}],other = []};

get_companion_stage(11,13,4) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,17880},{2,357600},{3,8940},{4,8940}],other = []};

get_companion_stage(11,13,5) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,17960},{2,359200},{3,8980},{4,8980}],other = []};

get_companion_stage(11,13,6) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,18040},{2,360800},{3,9020},{4,9020}],other = []};

get_companion_stage(11,13,7) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,18120},{2,362400},{3,9060},{4,9060}],other = []};

get_companion_stage(11,13,8) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,18200},{2,364000},{3,9100},{4,9100}],other = []};

get_companion_stage(11,13,9) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,18280},{2,365600},{3,9140},{4,9140}],other = []};

get_companion_stage(11,13,10) ->
	#base_companion_stage{companion_id = 11,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,18440},{2,368800},{3,9220},{4,9220}],other = []};

get_companion_stage(11,14,1) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,18520},{2,370400},{3,9260},{4,9260}],other = []};

get_companion_stage(11,14,2) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,18600},{2,372000},{3,9300},{4,9300}],other = []};

get_companion_stage(11,14,3) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,18680},{2,373600},{3,9340},{4,9340}],other = []};

get_companion_stage(11,14,4) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,18760},{2,375200},{3,9380},{4,9380}],other = []};

get_companion_stage(11,14,5) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,18840},{2,376800},{3,9420},{4,9420}],other = []};

get_companion_stage(11,14,6) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,18920},{2,378400},{3,9460},{4,9460}],other = []};

get_companion_stage(11,14,7) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,19000},{2,380000},{3,9500},{4,9500}],other = []};

get_companion_stage(11,14,8) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,19080},{2,381600},{3,9540},{4,9540}],other = []};

get_companion_stage(11,14,9) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,19160},{2,383200},{3,9580},{4,9580}],other = []};

get_companion_stage(11,14,10) ->
	#base_companion_stage{companion_id = 11,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,19320},{2,386400},{3,9660},{4,9660}],other = []};

get_companion_stage(11,15,1) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,19400},{2,388000},{3,9700},{4,9700}],other = []};

get_companion_stage(11,15,2) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,19480},{2,389600},{3,9740},{4,9740}],other = []};

get_companion_stage(11,15,3) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,19560},{2,391200},{3,9780},{4,9780}],other = []};

get_companion_stage(11,15,4) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,19640},{2,392800},{3,9820},{4,9820}],other = []};

get_companion_stage(11,15,5) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,19720},{2,394400},{3,9860},{4,9860}],other = []};

get_companion_stage(11,15,6) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,19800},{2,396000},{3,9900},{4,9900}],other = []};

get_companion_stage(11,15,7) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,19880},{2,397600},{3,9940},{4,9940}],other = []};

get_companion_stage(11,15,8) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,19960},{2,399200},{3,9980},{4,9980}],other = []};

get_companion_stage(11,15,9) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,20040},{2,400800},{3,10020},{4,10020}],other = []};

get_companion_stage(11,15,10) ->
	#base_companion_stage{companion_id = 11,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,20200},{2,404000},{3,10100},{4,10100}],other = []};

get_companion_stage(11,16,1) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,20280},{2,405600},{3,10140},{4,10140}],other = []};

get_companion_stage(11,16,2) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,20360},{2,407200},{3,10180},{4,10180}],other = []};

get_companion_stage(11,16,3) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,20440},{2,408800},{3,10220},{4,10220}],other = []};

get_companion_stage(11,16,4) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,20520},{2,410400},{3,10260},{4,10260}],other = []};

get_companion_stage(11,16,5) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,20600},{2,412000},{3,10300},{4,10300}],other = []};

get_companion_stage(11,16,6) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,20680},{2,413600},{3,10340},{4,10340}],other = []};

get_companion_stage(11,16,7) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,20760},{2,415200},{3,10380},{4,10380}],other = []};

get_companion_stage(11,16,8) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,20840},{2,416800},{3,10420},{4,10420}],other = []};

get_companion_stage(11,16,9) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,20920},{2,418400},{3,10460},{4,10460}],other = []};

get_companion_stage(11,16,10) ->
	#base_companion_stage{companion_id = 11,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,21080},{2,421600},{3,10540},{4,10540}],other = []};

get_companion_stage(11,17,1) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,21160},{2,423200},{3,10580},{4,10580}],other = []};

get_companion_stage(11,17,2) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,21240},{2,424800},{3,10620},{4,10620}],other = []};

get_companion_stage(11,17,3) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,21320},{2,426400},{3,10660},{4,10660}],other = []};

get_companion_stage(11,17,4) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,21400},{2,428000},{3,10700},{4,10700}],other = []};

get_companion_stage(11,17,5) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,21480},{2,429600},{3,10740},{4,10740}],other = []};

get_companion_stage(11,17,6) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,21560},{2,431200},{3,10780},{4,10780}],other = []};

get_companion_stage(11,17,7) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,21640},{2,432800},{3,10820},{4,10820}],other = []};

get_companion_stage(11,17,8) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,21720},{2,434400},{3,10860},{4,10860}],other = []};

get_companion_stage(11,17,9) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,21800},{2,436000},{3,10900},{4,10900}],other = []};

get_companion_stage(11,17,10) ->
	#base_companion_stage{companion_id = 11,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,21960},{2,439200},{3,10980},{4,10980}],other = []};

get_companion_stage(11,18,1) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,22040},{2,440800},{3,11020},{4,11020}],other = []};

get_companion_stage(11,18,2) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,22120},{2,442400},{3,11060},{4,11060}],other = []};

get_companion_stage(11,18,3) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,22200},{2,444000},{3,11100},{4,11100}],other = []};

get_companion_stage(11,18,4) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,22280},{2,445600},{3,11140},{4,11140}],other = []};

get_companion_stage(11,18,5) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,22360},{2,447200},{3,11180},{4,11180}],other = []};

get_companion_stage(11,18,6) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,22440},{2,448800},{3,11220},{4,11220}],other = []};

get_companion_stage(11,18,7) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,22520},{2,450400},{3,11260},{4,11260}],other = []};

get_companion_stage(11,18,8) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,22600},{2,452000},{3,11300},{4,11300}],other = []};

get_companion_stage(11,18,9) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,22680},{2,453600},{3,11340},{4,11340}],other = []};

get_companion_stage(11,18,10) ->
	#base_companion_stage{companion_id = 11,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,22840},{2,456800},{3,11420},{4,11420}],other = []};

get_companion_stage(11,19,1) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,22920},{2,458400},{3,11460},{4,11460}],other = []};

get_companion_stage(11,19,2) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,23000},{2,460000},{3,11500},{4,11500}],other = []};

get_companion_stage(11,19,3) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,23080},{2,461600},{3,11540},{4,11540}],other = []};

get_companion_stage(11,19,4) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,23160},{2,463200},{3,11580},{4,11580}],other = []};

get_companion_stage(11,19,5) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,23240},{2,464800},{3,11620},{4,11620}],other = []};

get_companion_stage(11,19,6) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,23320},{2,466400},{3,11660},{4,11660}],other = []};

get_companion_stage(11,19,7) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,23400},{2,468000},{3,11700},{4,11700}],other = []};

get_companion_stage(11,19,8) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,23480},{2,469600},{3,11740},{4,11740}],other = []};

get_companion_stage(11,19,9) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,23560},{2,471200},{3,11780},{4,11780}],other = []};

get_companion_stage(11,19,10) ->
	#base_companion_stage{companion_id = 11,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,23720},{2,474400},{3,11860},{4,11860}],other = []};

get_companion_stage(11,20,1) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,23800},{2,476000},{3,11900},{4,11900}],other = []};

get_companion_stage(11,20,2) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,23880},{2,477600},{3,11940},{4,11940}],other = []};

get_companion_stage(11,20,3) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,23960},{2,479200},{3,11980},{4,11980}],other = []};

get_companion_stage(11,20,4) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,24040},{2,480800},{3,12020},{4,12020}],other = []};

get_companion_stage(11,20,5) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,24120},{2,482400},{3,12060},{4,12060}],other = []};

get_companion_stage(11,20,6) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,24200},{2,484000},{3,12100},{4,12100}],other = []};

get_companion_stage(11,20,7) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,24280},{2,485600},{3,12140},{4,12140}],other = []};

get_companion_stage(11,20,8) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,24360},{2,487200},{3,12180},{4,12180}],other = []};

get_companion_stage(11,20,9) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,24440},{2,488800},{3,12220},{4,12220}],other = []};

get_companion_stage(11,20,10) ->
	#base_companion_stage{companion_id = 11,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,24600},{2,492000},{3,12300},{4,12300}],other = []};

get_companion_stage(11,21,1) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,24680},{2,493600},{3,12340},{4,12340}],other = []};

get_companion_stage(11,21,2) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,24760},{2,495200},{3,12380},{4,12380}],other = []};

get_companion_stage(11,21,3) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,24840},{2,496800},{3,12420},{4,12420}],other = []};

get_companion_stage(11,21,4) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,24920},{2,498400},{3,12460},{4,12460}],other = []};

get_companion_stage(11,21,5) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,25000},{2,500000},{3,12500},{4,12500}],other = []};

get_companion_stage(11,21,6) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,25080},{2,501600},{3,12540},{4,12540}],other = []};

get_companion_stage(11,21,7) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,25160},{2,503200},{3,12580},{4,12580}],other = []};

get_companion_stage(11,21,8) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,25240},{2,504800},{3,12620},{4,12620}],other = []};

get_companion_stage(11,21,9) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,25320},{2,506400},{3,12660},{4,12660}],other = []};

get_companion_stage(11,21,10) ->
	#base_companion_stage{companion_id = 11,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,25480},{2,509600},{3,12740},{4,12740}],other = []};

get_companion_stage(11,22,1) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,25560},{2,511200},{3,12780},{4,12780}],other = []};

get_companion_stage(11,22,2) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,25640},{2,512800},{3,12820},{4,12820}],other = []};

get_companion_stage(11,22,3) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,25720},{2,514400},{3,12860},{4,12860}],other = []};

get_companion_stage(11,22,4) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,25800},{2,516000},{3,12900},{4,12900}],other = []};

get_companion_stage(11,22,5) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,25880},{2,517600},{3,12940},{4,12940}],other = []};

get_companion_stage(11,22,6) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,25960},{2,519200},{3,12980},{4,12980}],other = []};

get_companion_stage(11,22,7) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,26040},{2,520800},{3,13020},{4,13020}],other = []};

get_companion_stage(11,22,8) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,26120},{2,522400},{3,13060},{4,13060}],other = []};

get_companion_stage(11,22,9) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,26200},{2,524000},{3,13100},{4,13100}],other = []};

get_companion_stage(11,22,10) ->
	#base_companion_stage{companion_id = 11,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,26360},{2,527200},{3,13180},{4,13180}],other = []};

get_companion_stage(11,23,1) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,26440},{2,528800},{3,13220},{4,13220}],other = []};

get_companion_stage(11,23,2) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,26520},{2,530400},{3,13260},{4,13260}],other = []};

get_companion_stage(11,23,3) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,26600},{2,532000},{3,13300},{4,13300}],other = []};

get_companion_stage(11,23,4) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,26680},{2,533600},{3,13340},{4,13340}],other = []};

get_companion_stage(11,23,5) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,26760},{2,535200},{3,13380},{4,13380}],other = []};

get_companion_stage(11,23,6) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,26840},{2,536800},{3,13420},{4,13420}],other = []};

get_companion_stage(11,23,7) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,26920},{2,538400},{3,13460},{4,13460}],other = []};

get_companion_stage(11,23,8) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,27000},{2,540000},{3,13500},{4,13500}],other = []};

get_companion_stage(11,23,9) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,27080},{2,541600},{3,13540},{4,13540}],other = []};

get_companion_stage(11,23,10) ->
	#base_companion_stage{companion_id = 11,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,27240},{2,544800},{3,13620},{4,13620}],other = []};

get_companion_stage(11,24,1) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,27320},{2,546400},{3,13660},{4,13660}],other = []};

get_companion_stage(11,24,2) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,27400},{2,548000},{3,13700},{4,13700}],other = []};

get_companion_stage(11,24,3) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,27480},{2,549600},{3,13740},{4,13740}],other = []};

get_companion_stage(11,24,4) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,27560},{2,551200},{3,13780},{4,13780}],other = []};

get_companion_stage(11,24,5) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,27640},{2,552800},{3,13820},{4,13820}],other = []};

get_companion_stage(11,24,6) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,27720},{2,554400},{3,13860},{4,13860}],other = []};

get_companion_stage(11,24,7) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,27800},{2,556000},{3,13900},{4,13900}],other = []};

get_companion_stage(11,24,8) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,27880},{2,557600},{3,13940},{4,13940}],other = []};

get_companion_stage(11,24,9) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,27960},{2,559200},{3,13980},{4,13980}],other = []};

get_companion_stage(11,24,10) ->
	#base_companion_stage{companion_id = 11,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,28120},{2,562400},{3,14060},{4,14060}],other = []};

get_companion_stage(11,25,1) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,28200},{2,564000},{3,14100},{4,14100}],other = []};

get_companion_stage(11,25,2) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,28280},{2,565600},{3,14140},{4,14140}],other = []};

get_companion_stage(11,25,3) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,28360},{2,567200},{3,14180},{4,14180}],other = []};

get_companion_stage(11,25,4) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,28440},{2,568800},{3,14220},{4,14220}],other = []};

get_companion_stage(11,25,5) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,28520},{2,570400},{3,14260},{4,14260}],other = []};

get_companion_stage(11,25,6) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,28600},{2,572000},{3,14300},{4,14300}],other = []};

get_companion_stage(11,25,7) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,28680},{2,573600},{3,14340},{4,14340}],other = []};

get_companion_stage(11,25,8) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,28760},{2,575200},{3,14380},{4,14380}],other = []};

get_companion_stage(11,25,9) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,28840},{2,576800},{3,14420},{4,14420}],other = []};

get_companion_stage(11,25,10) ->
	#base_companion_stage{companion_id = 11,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,29000},{2,580000},{3,14500},{4,14500}],other = []};

get_companion_stage(11,26,1) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,29080},{2,581600},{3,14540},{4,14540}],other = []};

get_companion_stage(11,26,2) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,29160},{2,583200},{3,14580},{4,14580}],other = []};

get_companion_stage(11,26,3) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,29240},{2,584800},{3,14620},{4,14620}],other = []};

get_companion_stage(11,26,4) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,29320},{2,586400},{3,14660},{4,14660}],other = []};

get_companion_stage(11,26,5) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,29400},{2,588000},{3,14700},{4,14700}],other = []};

get_companion_stage(11,26,6) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,29480},{2,589600},{3,14740},{4,14740}],other = []};

get_companion_stage(11,26,7) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,29560},{2,591200},{3,14780},{4,14780}],other = []};

get_companion_stage(11,26,8) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,29640},{2,592800},{3,14820},{4,14820}],other = []};

get_companion_stage(11,26,9) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,29720},{2,594400},{3,14860},{4,14860}],other = []};

get_companion_stage(11,26,10) ->
	#base_companion_stage{companion_id = 11,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,29880},{2,597600},{3,14940},{4,14940}],other = []};

get_companion_stage(11,27,1) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,29960},{2,599200},{3,14980},{4,14980}],other = []};

get_companion_stage(11,27,2) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,30040},{2,600800},{3,15020},{4,15020}],other = []};

get_companion_stage(11,27,3) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,30120},{2,602400},{3,15060},{4,15060}],other = []};

get_companion_stage(11,27,4) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,30200},{2,604000},{3,15100},{4,15100}],other = []};

get_companion_stage(11,27,5) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,30280},{2,605600},{3,15140},{4,15140}],other = []};

get_companion_stage(11,27,6) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,30360},{2,607200},{3,15180},{4,15180}],other = []};

get_companion_stage(11,27,7) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,30440},{2,608800},{3,15220},{4,15220}],other = []};

get_companion_stage(11,27,8) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,30520},{2,610400},{3,15260},{4,15260}],other = []};

get_companion_stage(11,27,9) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,30600},{2,612000},{3,15300},{4,15300}],other = []};

get_companion_stage(11,27,10) ->
	#base_companion_stage{companion_id = 11,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,30760},{2,615200},{3,15380},{4,15380}],other = []};

get_companion_stage(11,28,1) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,30840},{2,616800},{3,15420},{4,15420}],other = []};

get_companion_stage(11,28,2) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,30920},{2,618400},{3,15460},{4,15460}],other = []};

get_companion_stage(11,28,3) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,31000},{2,620000},{3,15500},{4,15500}],other = []};

get_companion_stage(11,28,4) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,31080},{2,621600},{3,15540},{4,15540}],other = []};

get_companion_stage(11,28,5) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,31160},{2,623200},{3,15580},{4,15580}],other = []};

get_companion_stage(11,28,6) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,31240},{2,624800},{3,15620},{4,15620}],other = []};

get_companion_stage(11,28,7) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,31320},{2,626400},{3,15660},{4,15660}],other = []};

get_companion_stage(11,28,8) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,31400},{2,628000},{3,15700},{4,15700}],other = []};

get_companion_stage(11,28,9) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,31480},{2,629600},{3,15740},{4,15740}],other = []};

get_companion_stage(11,28,10) ->
	#base_companion_stage{companion_id = 11,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,31640},{2,632800},{3,15820},{4,15820}],other = []};

get_companion_stage(11,29,1) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,31720},{2,634400},{3,15860},{4,15860}],other = []};

get_companion_stage(11,29,2) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,31800},{2,636000},{3,15900},{4,15900}],other = []};

get_companion_stage(11,29,3) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,31880},{2,637600},{3,15940},{4,15940}],other = []};

get_companion_stage(11,29,4) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,31960},{2,639200},{3,15980},{4,15980}],other = []};

get_companion_stage(11,29,5) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,32040},{2,640800},{3,16020},{4,16020}],other = []};

get_companion_stage(11,29,6) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,32120},{2,642400},{3,16060},{4,16060}],other = []};

get_companion_stage(11,29,7) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,32200},{2,644000},{3,16100},{4,16100}],other = []};

get_companion_stage(11,29,8) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,32280},{2,645600},{3,16140},{4,16140}],other = []};

get_companion_stage(11,29,9) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,32360},{2,647200},{3,16180},{4,16180}],other = []};

get_companion_stage(11,29,10) ->
	#base_companion_stage{companion_id = 11,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,32520},{2,650400},{3,16260},{4,16260}],other = []};

get_companion_stage(11,30,1) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,32600},{2,652000},{3,16300},{4,16300}],other = []};

get_companion_stage(11,30,2) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,32680},{2,653600},{3,16340},{4,16340}],other = []};

get_companion_stage(11,30,3) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,32760},{2,655200},{3,16380},{4,16380}],other = []};

get_companion_stage(11,30,4) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,32840},{2,656800},{3,16420},{4,16420}],other = []};

get_companion_stage(11,30,5) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,32920},{2,658400},{3,16460},{4,16460}],other = []};

get_companion_stage(11,30,6) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,33000},{2,660000},{3,16500},{4,16500}],other = []};

get_companion_stage(11,30,7) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,33080},{2,661600},{3,16540},{4,16540}],other = []};

get_companion_stage(11,30,8) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,33160},{2,663200},{3,16580},{4,16580}],other = []};

get_companion_stage(11,30,9) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,33240},{2,664800},{3,16620},{4,16620}],other = []};

get_companion_stage(11,30,10) ->
	#base_companion_stage{companion_id = 11,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,33400},{2,668000},{3,16700},{4,16700}],other = []};

get_companion_stage(12,1,0) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 0,biography = 0,need_blessing = 10,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],other = []};

get_companion_stage(12,1,1) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 1,biography = 0,need_blessing = 12,attr = [{1,7280},{2,145600},{3,3640},{4,3640}],other = []};

get_companion_stage(12,1,2) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 2,biography = 0,need_blessing = 14,attr = [{1,7360},{2,147200},{3,3680},{4,3680}],other = []};

get_companion_stage(12,1,3) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 3,biography = 0,need_blessing = 17,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],other = []};

get_companion_stage(12,1,4) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 4,biography = 0,need_blessing = 20,attr = [{1,7520},{2,150400},{3,3760},{4,3760}],other = []};

get_companion_stage(12,1,5) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 5,biography = 0,need_blessing = 23,attr = [{1,7600},{2,152000},{3,3800},{4,3800}],other = []};

get_companion_stage(12,1,6) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 6,biography = 0,need_blessing = 26,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],other = []};

get_companion_stage(12,1,7) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 7,biography = 0,need_blessing = 29,attr = [{1,7760},{2,155200},{3,3880},{4,3880}],other = []};

get_companion_stage(12,1,8) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 8,biography = 0,need_blessing = 33,attr = [{1,7840},{2,156800},{3,3920},{4,3920}],other = []};

get_companion_stage(12,1,9) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 9,biography = 0,need_blessing = 36,attr = [{1,7920},{2,158400},{3,3960},{4,3960}],other = []};

get_companion_stage(12,1,10) ->
	#base_companion_stage{companion_id = 12,stage = 1,star = 10,biography = 1,need_blessing = 40,attr = [{1,8080},{2,161600},{3,4040},{4,4040}],other = [{biog_reward, [{2,0,100},{0, 22030012, 3},{0, 22030112, 1}]}]};

get_companion_stage(12,2,1) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 1,biography = 0,need_blessing = 44,attr = [{1,8160},{2,163200},{3,4080},{4,4080}],other = []};

get_companion_stage(12,2,2) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 2,biography = 0,need_blessing = 48,attr = [{1,8240},{2,164800},{3,4120},{4,4120}],other = []};

get_companion_stage(12,2,3) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 3,biography = 0,need_blessing = 52,attr = [{1,8320},{2,166400},{3,4160},{4,4160}],other = []};

get_companion_stage(12,2,4) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 4,biography = 0,need_blessing = 56,attr = [{1,8400},{2,168000},{3,4200},{4,4200}],other = []};

get_companion_stage(12,2,5) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 5,biography = 0,need_blessing = 60,attr = [{1,8480},{2,169600},{3,4240},{4,4240}],other = []};

get_companion_stage(12,2,6) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 6,biography = 0,need_blessing = 65,attr = [{1,8560},{2,171200},{3,4280},{4,4280}],other = []};

get_companion_stage(12,2,7) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 7,biography = 0,need_blessing = 69,attr = [{1,8640},{2,172800},{3,4320},{4,4320}],other = []};

get_companion_stage(12,2,8) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 8,biography = 0,need_blessing = 74,attr = [{1,8720},{2,174400},{3,4360},{4,4360}],other = []};

get_companion_stage(12,2,9) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 9,biography = 0,need_blessing = 78,attr = [{1,8800},{2,176000},{3,4400},{4,4400}],other = []};

get_companion_stage(12,2,10) ->
	#base_companion_stage{companion_id = 12,stage = 2,star = 10,biography = 0,need_blessing = 83,attr = [{1,8960},{2,179200},{3,4480},{4,4480}],other = []};

get_companion_stage(12,3,1) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 1,biography = 0,need_blessing = 88,attr = [{1,9040},{2,180800},{3,4520},{4,4520}],other = []};

get_companion_stage(12,3,2) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 2,biography = 0,need_blessing = 93,attr = [{1,9120},{2,182400},{3,4560},{4,4560}],other = []};

get_companion_stage(12,3,3) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 3,biography = 0,need_blessing = 98,attr = [{1,9200},{2,184000},{3,4600},{4,4600}],other = []};

get_companion_stage(12,3,4) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 4,biography = 0,need_blessing = 103,attr = [{1,9280},{2,185600},{3,4640},{4,4640}],other = []};

get_companion_stage(12,3,5) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 5,biography = 0,need_blessing = 108,attr = [{1,9360},{2,187200},{3,4680},{4,4680}],other = []};

get_companion_stage(12,3,6) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 6,biography = 0,need_blessing = 114,attr = [{1,9440},{2,188800},{3,4720},{4,4720}],other = []};

get_companion_stage(12,3,7) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 7,biography = 0,need_blessing = 119,attr = [{1,9520},{2,190400},{3,4760},{4,4760}],other = []};

get_companion_stage(12,3,8) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 8,biography = 0,need_blessing = 124,attr = [{1,9600},{2,192000},{3,4800},{4,4800}],other = []};

get_companion_stage(12,3,9) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 9,biography = 0,need_blessing = 130,attr = [{1,9680},{2,193600},{3,4840},{4,4840}],other = []};

get_companion_stage(12,3,10) ->
	#base_companion_stage{companion_id = 12,stage = 3,star = 10,biography = 2,need_blessing = 136,attr = [{1,9840},{2,196800},{3,4920},{4,4920}],other = [{biog_reward, [{2,0,200},{0, 22030012, 5},{0, 22030112, 3}]}]};

get_companion_stage(12,4,1) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 1,biography = 0,need_blessing = 141,attr = [{1,9920},{2,198400},{3,4960},{4,4960}],other = []};

get_companion_stage(12,4,2) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 2,biography = 0,need_blessing = 147,attr = [{1,10000},{2,200000},{3,5000},{4,5000}],other = []};

get_companion_stage(12,4,3) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 3,biography = 0,need_blessing = 153,attr = [{1,10080},{2,201600},{3,5040},{4,5040}],other = []};

get_companion_stage(12,4,4) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 4,biography = 0,need_blessing = 158,attr = [{1,10160},{2,203200},{3,5080},{4,5080}],other = []};

get_companion_stage(12,4,5) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 5,biography = 0,need_blessing = 164,attr = [{1,10240},{2,204800},{3,5120},{4,5120}],other = []};

get_companion_stage(12,4,6) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 6,biography = 0,need_blessing = 170,attr = [{1,10320},{2,206400},{3,5160},{4,5160}],other = []};

get_companion_stage(12,4,7) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 7,biography = 0,need_blessing = 176,attr = [{1,10400},{2,208000},{3,5200},{4,5200}],other = []};

get_companion_stage(12,4,8) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 8,biography = 0,need_blessing = 182,attr = [{1,10480},{2,209600},{3,5240},{4,5240}],other = []};

get_companion_stage(12,4,9) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 9,biography = 0,need_blessing = 189,attr = [{1,10560},{2,211200},{3,5280},{4,5280}],other = []};

get_companion_stage(12,4,10) ->
	#base_companion_stage{companion_id = 12,stage = 4,star = 10,biography = 0,need_blessing = 195,attr = [{1,10720},{2,214400},{3,5360},{4,5360}],other = []};

get_companion_stage(12,5,1) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 1,biography = 0,need_blessing = 201,attr = [{1,10800},{2,216000},{3,5400},{4,5400}],other = []};

get_companion_stage(12,5,2) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 2,biography = 0,need_blessing = 207,attr = [{1,10880},{2,217600},{3,5440},{4,5440}],other = []};

get_companion_stage(12,5,3) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 3,biography = 0,need_blessing = 214,attr = [{1,10960},{2,219200},{3,5480},{4,5480}],other = []};

get_companion_stage(12,5,4) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 4,biography = 0,need_blessing = 220,attr = [{1,11040},{2,220800},{3,5520},{4,5520}],other = []};

get_companion_stage(12,5,5) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 5,biography = 0,need_blessing = 227,attr = [{1,11120},{2,222400},{3,5560},{4,5560}],other = []};

get_companion_stage(12,5,6) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 6,biography = 0,need_blessing = 233,attr = [{1,11200},{2,224000},{3,5600},{4,5600}],other = []};

get_companion_stage(12,5,7) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 7,biography = 0,need_blessing = 240,attr = [{1,11280},{2,225600},{3,5640},{4,5640}],other = []};

get_companion_stage(12,5,8) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 8,biography = 0,need_blessing = 247,attr = [{1,11360},{2,227200},{3,5680},{4,5680}],other = []};

get_companion_stage(12,5,9) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 9,biography = 0,need_blessing = 253,attr = [{1,11440},{2,228800},{3,5720},{4,5720}],other = []};

get_companion_stage(12,5,10) ->
	#base_companion_stage{companion_id = 12,stage = 5,star = 10,biography = 3,need_blessing = 260,attr = [{1,11600},{2,232000},{3,5800},{4,5800}],other = [{biog_reward, [{2,0,250},{0, 22030012, 10},{0, 22030112, 5}]}]};

get_companion_stage(12,6,1) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 1,biography = 0,need_blessing = 267,attr = [{1,11680},{2,233600},{3,5840},{4,5840}],other = []};

get_companion_stage(12,6,2) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 2,biography = 0,need_blessing = 274,attr = [{1,11760},{2,235200},{3,5880},{4,5880}],other = []};

get_companion_stage(12,6,3) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 3,biography = 0,need_blessing = 281,attr = [{1,11840},{2,236800},{3,5920},{4,5920}],other = []};

get_companion_stage(12,6,4) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 4,biography = 0,need_blessing = 288,attr = [{1,11920},{2,238400},{3,5960},{4,5960}],other = []};

get_companion_stage(12,6,5) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 5,biography = 0,need_blessing = 295,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],other = []};

get_companion_stage(12,6,6) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 6,biography = 0,need_blessing = 302,attr = [{1,12080},{2,241600},{3,6040},{4,6040}],other = []};

get_companion_stage(12,6,7) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 7,biography = 0,need_blessing = 309,attr = [{1,12160},{2,243200},{3,6080},{4,6080}],other = []};

get_companion_stage(12,6,8) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 8,biography = 0,need_blessing = 316,attr = [{1,12240},{2,244800},{3,6120},{4,6120}],other = []};

get_companion_stage(12,6,9) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 9,biography = 0,need_blessing = 323,attr = [{1,12320},{2,246400},{3,6160},{4,6160}],other = []};

get_companion_stage(12,6,10) ->
	#base_companion_stage{companion_id = 12,stage = 6,star = 10,biography = 0,need_blessing = 331,attr = [{1,12480},{2,249600},{3,6240},{4,6240}],other = []};

get_companion_stage(12,7,1) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 1,biography = 0,need_blessing = 338,attr = [{1,12560},{2,251200},{3,6280},{4,6280}],other = []};

get_companion_stage(12,7,2) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 2,biography = 0,need_blessing = 345,attr = [{1,12640},{2,252800},{3,6320},{4,6320}],other = []};

get_companion_stage(12,7,3) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 3,biography = 0,need_blessing = 353,attr = [{1,12720},{2,254400},{3,6360},{4,6360}],other = []};

get_companion_stage(12,7,4) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 4,biography = 0,need_blessing = 360,attr = [{1,12800},{2,256000},{3,6400},{4,6400}],other = []};

get_companion_stage(12,7,5) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 5,biography = 0,need_blessing = 368,attr = [{1,12880},{2,257600},{3,6440},{4,6440}],other = []};

get_companion_stage(12,7,6) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 6,biography = 0,need_blessing = 375,attr = [{1,12960},{2,259200},{3,6480},{4,6480}],other = []};

get_companion_stage(12,7,7) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 7,biography = 0,need_blessing = 383,attr = [{1,13040},{2,260800},{3,6520},{4,6520}],other = []};

get_companion_stage(12,7,8) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 8,biography = 0,need_blessing = 390,attr = [{1,13120},{2,262400},{3,6560},{4,6560}],other = []};

get_companion_stage(12,7,9) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 9,biography = 0,need_blessing = 398,attr = [{1,13200},{2,264000},{3,6600},{4,6600}],other = []};

get_companion_stage(12,7,10) ->
	#base_companion_stage{companion_id = 12,stage = 7,star = 10,biography = 0,need_blessing = 406,attr = [{1,13360},{2,267200},{3,6680},{4,6680}],other = []};

get_companion_stage(12,8,1) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 1,biography = 0,need_blessing = 414,attr = [{1,13440},{2,268800},{3,6720},{4,6720}],other = []};

get_companion_stage(12,8,2) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 2,biography = 0,need_blessing = 421,attr = [{1,13520},{2,270400},{3,6760},{4,6760}],other = []};

get_companion_stage(12,8,3) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 3,biography = 0,need_blessing = 429,attr = [{1,13600},{2,272000},{3,6800},{4,6800}],other = []};

get_companion_stage(12,8,4) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 4,biography = 0,need_blessing = 437,attr = [{1,13680},{2,273600},{3,6840},{4,6840}],other = []};

get_companion_stage(12,8,5) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 5,biography = 0,need_blessing = 445,attr = [{1,13760},{2,275200},{3,6880},{4,6880}],other = []};

get_companion_stage(12,8,6) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 6,biography = 0,need_blessing = 453,attr = [{1,13840},{2,276800},{3,6920},{4,6920}],other = []};

get_companion_stage(12,8,7) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 7,biography = 0,need_blessing = 461,attr = [{1,13920},{2,278400},{3,6960},{4,6960}],other = []};

get_companion_stage(12,8,8) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 8,biography = 0,need_blessing = 469,attr = [{1,14000},{2,280000},{3,7000},{4,7000}],other = []};

get_companion_stage(12,8,9) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 9,biography = 0,need_blessing = 477,attr = [{1,14080},{2,281600},{3,7040},{4,7040}],other = []};

get_companion_stage(12,8,10) ->
	#base_companion_stage{companion_id = 12,stage = 8,star = 10,biography = 0,need_blessing = 485,attr = [{1,14240},{2,284800},{3,7120},{4,7120}],other = []};

get_companion_stage(12,9,1) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 1,biography = 0,need_blessing = 494,attr = [{1,14320},{2,286400},{3,7160},{4,7160}],other = []};

get_companion_stage(12,9,2) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 2,biography = 0,need_blessing = 502,attr = [{1,14400},{2,288000},{3,7200},{4,7200}],other = []};

get_companion_stage(12,9,3) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 3,biography = 0,need_blessing = 510,attr = [{1,14480},{2,289600},{3,7240},{4,7240}],other = []};

get_companion_stage(12,9,4) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 4,biography = 0,need_blessing = 518,attr = [{1,14560},{2,291200},{3,7280},{4,7280}],other = []};

get_companion_stage(12,9,5) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 5,biography = 0,need_blessing = 527,attr = [{1,14640},{2,292800},{3,7320},{4,7320}],other = []};

get_companion_stage(12,9,6) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 6,biography = 0,need_blessing = 535,attr = [{1,14720},{2,294400},{3,7360},{4,7360}],other = []};

get_companion_stage(12,9,7) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 7,biography = 0,need_blessing = 543,attr = [{1,14800},{2,296000},{3,7400},{4,7400}],other = []};

get_companion_stage(12,9,8) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 8,biography = 0,need_blessing = 552,attr = [{1,14880},{2,297600},{3,7440},{4,7440}],other = []};

get_companion_stage(12,9,9) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 9,biography = 0,need_blessing = 560,attr = [{1,14960},{2,299200},{3,7480},{4,7480}],other = []};

get_companion_stage(12,9,10) ->
	#base_companion_stage{companion_id = 12,stage = 9,star = 10,biography = 0,need_blessing = 569,attr = [{1,15120},{2,302400},{3,7560},{4,7560}],other = []};

get_companion_stage(12,10,1) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 1,biography = 0,need_blessing = 578,attr = [{1,15200},{2,304000},{3,7600},{4,7600}],other = []};

get_companion_stage(12,10,2) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 2,biography = 0,need_blessing = 586,attr = [{1,15280},{2,305600},{3,7640},{4,7640}],other = []};

get_companion_stage(12,10,3) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 3,biography = 0,need_blessing = 595,attr = [{1,15360},{2,307200},{3,7680},{4,7680}],other = []};

get_companion_stage(12,10,4) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 4,biography = 0,need_blessing = 603,attr = [{1,15440},{2,308800},{3,7720},{4,7720}],other = []};

get_companion_stage(12,10,5) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 5,biography = 0,need_blessing = 612,attr = [{1,15520},{2,310400},{3,7760},{4,7760}],other = []};

get_companion_stage(12,10,6) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 6,biography = 0,need_blessing = 621,attr = [{1,15600},{2,312000},{3,7800},{4,7800}],other = []};

get_companion_stage(12,10,7) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 7,biography = 0,need_blessing = 630,attr = [{1,15680},{2,313600},{3,7840},{4,7840}],other = []};

get_companion_stage(12,10,8) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 8,biography = 0,need_blessing = 638,attr = [{1,15760},{2,315200},{3,7880},{4,7880}],other = []};

get_companion_stage(12,10,9) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 9,biography = 0,need_blessing = 647,attr = [{1,15840},{2,316800},{3,7920},{4,7920}],other = []};

get_companion_stage(12,10,10) ->
	#base_companion_stage{companion_id = 12,stage = 10,star = 10,biography = 0,need_blessing = 656,attr = [{1,16000},{2,320000},{3,8000},{4,8000}],other = []};

get_companion_stage(12,11,1) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 1,biography = 0,need_blessing = 665,attr = [{1,16080},{2,321600},{3,8040},{4,8040}],other = []};

get_companion_stage(12,11,2) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 2,biography = 0,need_blessing = 674,attr = [{1,16160},{2,323200},{3,8080},{4,8080}],other = []};

get_companion_stage(12,11,3) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 3,biography = 0,need_blessing = 683,attr = [{1,16240},{2,324800},{3,8120},{4,8120}],other = []};

get_companion_stage(12,11,4) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 4,biography = 0,need_blessing = 692,attr = [{1,16320},{2,326400},{3,8160},{4,8160}],other = []};

get_companion_stage(12,11,5) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 5,biography = 0,need_blessing = 701,attr = [{1,16400},{2,328000},{3,8200},{4,8200}],other = []};

get_companion_stage(12,11,6) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 6,biography = 0,need_blessing = 710,attr = [{1,16480},{2,329600},{3,8240},{4,8240}],other = []};

get_companion_stage(12,11,7) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 7,biography = 0,need_blessing = 719,attr = [{1,16560},{2,331200},{3,8280},{4,8280}],other = []};

get_companion_stage(12,11,8) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 8,biography = 0,need_blessing = 729,attr = [{1,16640},{2,332800},{3,8320},{4,8320}],other = []};

get_companion_stage(12,11,9) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 9,biography = 0,need_blessing = 738,attr = [{1,16720},{2,334400},{3,8360},{4,8360}],other = []};

get_companion_stage(12,11,10) ->
	#base_companion_stage{companion_id = 12,stage = 11,star = 10,biography = 0,need_blessing = 747,attr = [{1,16880},{2,337600},{3,8440},{4,8440}],other = []};

get_companion_stage(12,12,1) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 1,biography = 0,need_blessing = 756,attr = [{1,16960},{2,339200},{3,8480},{4,8480}],other = []};

get_companion_stage(12,12,2) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 2,biography = 0,need_blessing = 765,attr = [{1,17040},{2,340800},{3,8520},{4,8520}],other = []};

get_companion_stage(12,12,3) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 3,biography = 0,need_blessing = 775,attr = [{1,17120},{2,342400},{3,8560},{4,8560}],other = []};

get_companion_stage(12,12,4) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 4,biography = 0,need_blessing = 784,attr = [{1,17200},{2,344000},{3,8600},{4,8600}],other = []};

get_companion_stage(12,12,5) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 5,biography = 0,need_blessing = 794,attr = [{1,17280},{2,345600},{3,8640},{4,8640}],other = []};

get_companion_stage(12,12,6) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 6,biography = 0,need_blessing = 803,attr = [{1,17360},{2,347200},{3,8680},{4,8680}],other = []};

get_companion_stage(12,12,7) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 7,biography = 0,need_blessing = 812,attr = [{1,17440},{2,348800},{3,8720},{4,8720}],other = []};

get_companion_stage(12,12,8) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 8,biography = 0,need_blessing = 822,attr = [{1,17520},{2,350400},{3,8760},{4,8760}],other = []};

get_companion_stage(12,12,9) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 9,biography = 0,need_blessing = 831,attr = [{1,17600},{2,352000},{3,8800},{4,8800}],other = []};

get_companion_stage(12,12,10) ->
	#base_companion_stage{companion_id = 12,stage = 12,star = 10,biography = 0,need_blessing = 841,attr = [{1,17760},{2,355200},{3,8880},{4,8880}],other = []};

get_companion_stage(12,13,1) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 1,biography = 0,need_blessing = 851,attr = [{1,17840},{2,356800},{3,8920},{4,8920}],other = []};

get_companion_stage(12,13,2) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 2,biography = 0,need_blessing = 860,attr = [{1,17920},{2,358400},{3,8960},{4,8960}],other = []};

get_companion_stage(12,13,3) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 3,biography = 0,need_blessing = 870,attr = [{1,18000},{2,360000},{3,9000},{4,9000}],other = []};

get_companion_stage(12,13,4) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 4,biography = 0,need_blessing = 880,attr = [{1,18080},{2,361600},{3,9040},{4,9040}],other = []};

get_companion_stage(12,13,5) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 5,biography = 0,need_blessing = 889,attr = [{1,18160},{2,363200},{3,9080},{4,9080}],other = []};

get_companion_stage(12,13,6) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 6,biography = 0,need_blessing = 899,attr = [{1,18240},{2,364800},{3,9120},{4,9120}],other = []};

get_companion_stage(12,13,7) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 7,biography = 0,need_blessing = 909,attr = [{1,18320},{2,366400},{3,9160},{4,9160}],other = []};

get_companion_stage(12,13,8) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 8,biography = 0,need_blessing = 919,attr = [{1,18400},{2,368000},{3,9200},{4,9200}],other = []};

get_companion_stage(12,13,9) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 9,biography = 0,need_blessing = 928,attr = [{1,18480},{2,369600},{3,9240},{4,9240}],other = []};

get_companion_stage(12,13,10) ->
	#base_companion_stage{companion_id = 12,stage = 13,star = 10,biography = 0,need_blessing = 938,attr = [{1,18640},{2,372800},{3,9320},{4,9320}],other = []};

get_companion_stage(12,14,1) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 1,biography = 0,need_blessing = 948,attr = [{1,18720},{2,374400},{3,9360},{4,9360}],other = []};

get_companion_stage(12,14,2) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 2,biography = 0,need_blessing = 958,attr = [{1,18800},{2,376000},{3,9400},{4,9400}],other = []};

get_companion_stage(12,14,3) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 3,biography = 0,need_blessing = 968,attr = [{1,18880},{2,377600},{3,9440},{4,9440}],other = []};

get_companion_stage(12,14,4) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 4,biography = 0,need_blessing = 978,attr = [{1,18960},{2,379200},{3,9480},{4,9480}],other = []};

get_companion_stage(12,14,5) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 5,biography = 0,need_blessing = 988,attr = [{1,19040},{2,380800},{3,9520},{4,9520}],other = []};

get_companion_stage(12,14,6) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 6,biography = 0,need_blessing = 998,attr = [{1,19120},{2,382400},{3,9560},{4,9560}],other = []};

get_companion_stage(12,14,7) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 7,biography = 0,need_blessing = 1008,attr = [{1,19200},{2,384000},{3,9600},{4,9600}],other = []};

get_companion_stage(12,14,8) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 8,biography = 0,need_blessing = 1018,attr = [{1,19280},{2,385600},{3,9640},{4,9640}],other = []};

get_companion_stage(12,14,9) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 9,biography = 0,need_blessing = 1028,attr = [{1,19360},{2,387200},{3,9680},{4,9680}],other = []};

get_companion_stage(12,14,10) ->
	#base_companion_stage{companion_id = 12,stage = 14,star = 10,biography = 0,need_blessing = 1038,attr = [{1,19520},{2,390400},{3,9760},{4,9760}],other = []};

get_companion_stage(12,15,1) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 1,biography = 0,need_blessing = 1049,attr = [{1,19600},{2,392000},{3,9800},{4,9800}],other = []};

get_companion_stage(12,15,2) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 2,biography = 0,need_blessing = 1059,attr = [{1,19680},{2,393600},{3,9840},{4,9840}],other = []};

get_companion_stage(12,15,3) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 3,biography = 0,need_blessing = 1069,attr = [{1,19760},{2,395200},{3,9880},{4,9880}],other = []};

get_companion_stage(12,15,4) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 4,biography = 0,need_blessing = 1079,attr = [{1,19840},{2,396800},{3,9920},{4,9920}],other = []};

get_companion_stage(12,15,5) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 5,biography = 0,need_blessing = 1090,attr = [{1,19920},{2,398400},{3,9960},{4,9960}],other = []};

get_companion_stage(12,15,6) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 6,biography = 0,need_blessing = 1100,attr = [{1,20000},{2,400000},{3,10000},{4,10000}],other = []};

get_companion_stage(12,15,7) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 7,biography = 0,need_blessing = 1110,attr = [{1,20080},{2,401600},{3,10040},{4,10040}],other = []};

get_companion_stage(12,15,8) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 8,biography = 0,need_blessing = 1121,attr = [{1,20160},{2,403200},{3,10080},{4,10080}],other = []};

get_companion_stage(12,15,9) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 9,biography = 0,need_blessing = 1131,attr = [{1,20240},{2,404800},{3,10120},{4,10120}],other = []};

get_companion_stage(12,15,10) ->
	#base_companion_stage{companion_id = 12,stage = 15,star = 10,biography = 0,need_blessing = 1141,attr = [{1,20400},{2,408000},{3,10200},{4,10200}],other = []};

get_companion_stage(12,16,1) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 1,biography = 0,need_blessing = 1152,attr = [{1,20480},{2,409600},{3,10240},{4,10240}],other = []};

get_companion_stage(12,16,2) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 2,biography = 0,need_blessing = 1162,attr = [{1,20560},{2,411200},{3,10280},{4,10280}],other = []};

get_companion_stage(12,16,3) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 3,biography = 0,need_blessing = 1173,attr = [{1,20640},{2,412800},{3,10320},{4,10320}],other = []};

get_companion_stage(12,16,4) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 4,biography = 0,need_blessing = 1183,attr = [{1,20720},{2,414400},{3,10360},{4,10360}],other = []};

get_companion_stage(12,16,5) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 5,biography = 0,need_blessing = 1194,attr = [{1,20800},{2,416000},{3,10400},{4,10400}],other = []};

get_companion_stage(12,16,6) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 6,biography = 0,need_blessing = 1205,attr = [{1,20880},{2,417600},{3,10440},{4,10440}],other = []};

get_companion_stage(12,16,7) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 7,biography = 0,need_blessing = 1215,attr = [{1,20960},{2,419200},{3,10480},{4,10480}],other = []};

get_companion_stage(12,16,8) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 8,biography = 0,need_blessing = 1226,attr = [{1,21040},{2,420800},{3,10520},{4,10520}],other = []};

get_companion_stage(12,16,9) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 9,biography = 0,need_blessing = 1237,attr = [{1,21120},{2,422400},{3,10560},{4,10560}],other = []};

get_companion_stage(12,16,10) ->
	#base_companion_stage{companion_id = 12,stage = 16,star = 10,biography = 0,need_blessing = 1247,attr = [{1,21280},{2,425600},{3,10640},{4,10640}],other = []};

get_companion_stage(12,17,1) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 1,biography = 0,need_blessing = 1258,attr = [{1,21360},{2,427200},{3,10680},{4,10680}],other = []};

get_companion_stage(12,17,2) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 2,biography = 0,need_blessing = 1269,attr = [{1,21440},{2,428800},{3,10720},{4,10720}],other = []};

get_companion_stage(12,17,3) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 3,biography = 0,need_blessing = 1279,attr = [{1,21520},{2,430400},{3,10760},{4,10760}],other = []};

get_companion_stage(12,17,4) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 4,biography = 0,need_blessing = 1290,attr = [{1,21600},{2,432000},{3,10800},{4,10800}],other = []};

get_companion_stage(12,17,5) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 5,biography = 0,need_blessing = 1301,attr = [{1,21680},{2,433600},{3,10840},{4,10840}],other = []};

get_companion_stage(12,17,6) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 6,biography = 0,need_blessing = 1312,attr = [{1,21760},{2,435200},{3,10880},{4,10880}],other = []};

get_companion_stage(12,17,7) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 7,biography = 0,need_blessing = 1323,attr = [{1,21840},{2,436800},{3,10920},{4,10920}],other = []};

get_companion_stage(12,17,8) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 8,biography = 0,need_blessing = 1334,attr = [{1,21920},{2,438400},{3,10960},{4,10960}],other = []};

get_companion_stage(12,17,9) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 9,biography = 0,need_blessing = 1345,attr = [{1,22000},{2,440000},{3,11000},{4,11000}],other = []};

get_companion_stage(12,17,10) ->
	#base_companion_stage{companion_id = 12,stage = 17,star = 10,biography = 0,need_blessing = 1356,attr = [{1,22160},{2,443200},{3,11080},{4,11080}],other = []};

get_companion_stage(12,18,1) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 1,biography = 0,need_blessing = 1367,attr = [{1,22240},{2,444800},{3,11120},{4,11120}],other = []};

get_companion_stage(12,18,2) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 2,biography = 0,need_blessing = 1378,attr = [{1,22320},{2,446400},{3,11160},{4,11160}],other = []};

get_companion_stage(12,18,3) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 3,biography = 0,need_blessing = 1389,attr = [{1,22400},{2,448000},{3,11200},{4,11200}],other = []};

get_companion_stage(12,18,4) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 4,biography = 0,need_blessing = 1400,attr = [{1,22480},{2,449600},{3,11240},{4,11240}],other = []};

get_companion_stage(12,18,5) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 5,biography = 0,need_blessing = 1411,attr = [{1,22560},{2,451200},{3,11280},{4,11280}],other = []};

get_companion_stage(12,18,6) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 6,biography = 0,need_blessing = 1422,attr = [{1,22640},{2,452800},{3,11320},{4,11320}],other = []};

get_companion_stage(12,18,7) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 7,biography = 0,need_blessing = 1433,attr = [{1,22720},{2,454400},{3,11360},{4,11360}],other = []};

get_companion_stage(12,18,8) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 8,biography = 0,need_blessing = 1444,attr = [{1,22800},{2,456000},{3,11400},{4,11400}],other = []};

get_companion_stage(12,18,9) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 9,biography = 0,need_blessing = 1455,attr = [{1,22880},{2,457600},{3,11440},{4,11440}],other = []};

get_companion_stage(12,18,10) ->
	#base_companion_stage{companion_id = 12,stage = 18,star = 10,biography = 0,need_blessing = 1467,attr = [{1,23040},{2,460800},{3,11520},{4,11520}],other = []};

get_companion_stage(12,19,1) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 1,biography = 0,need_blessing = 1478,attr = [{1,23120},{2,462400},{3,11560},{4,11560}],other = []};

get_companion_stage(12,19,2) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 2,biography = 0,need_blessing = 1489,attr = [{1,23200},{2,464000},{3,11600},{4,11600}],other = []};

get_companion_stage(12,19,3) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 3,biography = 0,need_blessing = 1500,attr = [{1,23280},{2,465600},{3,11640},{4,11640}],other = []};

get_companion_stage(12,19,4) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 4,biography = 0,need_blessing = 1512,attr = [{1,23360},{2,467200},{3,11680},{4,11680}],other = []};

get_companion_stage(12,19,5) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 5,biography = 0,need_blessing = 1523,attr = [{1,23440},{2,468800},{3,11720},{4,11720}],other = []};

get_companion_stage(12,19,6) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 6,biography = 0,need_blessing = 1534,attr = [{1,23520},{2,470400},{3,11760},{4,11760}],other = []};

get_companion_stage(12,19,7) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 7,biography = 0,need_blessing = 1546,attr = [{1,23600},{2,472000},{3,11800},{4,11800}],other = []};

get_companion_stage(12,19,8) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 8,biography = 0,need_blessing = 1557,attr = [{1,23680},{2,473600},{3,11840},{4,11840}],other = []};

get_companion_stage(12,19,9) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 9,biography = 0,need_blessing = 1569,attr = [{1,23760},{2,475200},{3,11880},{4,11880}],other = []};

get_companion_stage(12,19,10) ->
	#base_companion_stage{companion_id = 12,stage = 19,star = 10,biography = 0,need_blessing = 1580,attr = [{1,23920},{2,478400},{3,11960},{4,11960}],other = []};

get_companion_stage(12,20,1) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 1,biography = 0,need_blessing = 1592,attr = [{1,24000},{2,480000},{3,12000},{4,12000}],other = []};

get_companion_stage(12,20,2) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 2,biography = 0,need_blessing = 1603,attr = [{1,24080},{2,481600},{3,12040},{4,12040}],other = []};

get_companion_stage(12,20,3) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 3,biography = 0,need_blessing = 1615,attr = [{1,24160},{2,483200},{3,12080},{4,12080}],other = []};

get_companion_stage(12,20,4) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 4,biography = 0,need_blessing = 1626,attr = [{1,24240},{2,484800},{3,12120},{4,12120}],other = []};

get_companion_stage(12,20,5) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 5,biography = 0,need_blessing = 1638,attr = [{1,24320},{2,486400},{3,12160},{4,12160}],other = []};

get_companion_stage(12,20,6) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 6,biography = 0,need_blessing = 1649,attr = [{1,24400},{2,488000},{3,12200},{4,12200}],other = []};

get_companion_stage(12,20,7) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 7,biography = 0,need_blessing = 1661,attr = [{1,24480},{2,489600},{3,12240},{4,12240}],other = []};

get_companion_stage(12,20,8) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 8,biography = 0,need_blessing = 1673,attr = [{1,24560},{2,491200},{3,12280},{4,12280}],other = []};

get_companion_stage(12,20,9) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 9,biography = 0,need_blessing = 1684,attr = [{1,24640},{2,492800},{3,12320},{4,12320}],other = []};

get_companion_stage(12,20,10) ->
	#base_companion_stage{companion_id = 12,stage = 20,star = 10,biography = 0,need_blessing = 1696,attr = [{1,24800},{2,496000},{3,12400},{4,12400}],other = []};

get_companion_stage(12,21,1) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 1,biography = 0,need_blessing = 1708,attr = [{1,24880},{2,497600},{3,12440},{4,12440}],other = []};

get_companion_stage(12,21,2) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 2,biography = 0,need_blessing = 1719,attr = [{1,24960},{2,499200},{3,12480},{4,12480}],other = []};

get_companion_stage(12,21,3) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 3,biography = 0,need_blessing = 1731,attr = [{1,25040},{2,500800},{3,12520},{4,12520}],other = []};

get_companion_stage(12,21,4) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 4,biography = 0,need_blessing = 1743,attr = [{1,25120},{2,502400},{3,12560},{4,12560}],other = []};

get_companion_stage(12,21,5) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 5,biography = 0,need_blessing = 1755,attr = [{1,25200},{2,504000},{3,12600},{4,12600}],other = []};

get_companion_stage(12,21,6) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 6,biography = 0,need_blessing = 1767,attr = [{1,25280},{2,505600},{3,12640},{4,12640}],other = []};

get_companion_stage(12,21,7) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 7,biography = 0,need_blessing = 1778,attr = [{1,25360},{2,507200},{3,12680},{4,12680}],other = []};

get_companion_stage(12,21,8) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 8,biography = 0,need_blessing = 1790,attr = [{1,25440},{2,508800},{3,12720},{4,12720}],other = []};

get_companion_stage(12,21,9) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 9,biography = 0,need_blessing = 1802,attr = [{1,25520},{2,510400},{3,12760},{4,12760}],other = []};

get_companion_stage(12,21,10) ->
	#base_companion_stage{companion_id = 12,stage = 21,star = 10,biography = 0,need_blessing = 1814,attr = [{1,25680},{2,513600},{3,12840},{4,12840}],other = []};

get_companion_stage(12,22,1) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 1,biography = 0,need_blessing = 1826,attr = [{1,25760},{2,515200},{3,12880},{4,12880}],other = []};

get_companion_stage(12,22,2) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 2,biography = 0,need_blessing = 1838,attr = [{1,25840},{2,516800},{3,12920},{4,12920}],other = []};

get_companion_stage(12,22,3) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 3,biography = 0,need_blessing = 1850,attr = [{1,25920},{2,518400},{3,12960},{4,12960}],other = []};

get_companion_stage(12,22,4) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 4,biography = 0,need_blessing = 1862,attr = [{1,26000},{2,520000},{3,13000},{4,13000}],other = []};

get_companion_stage(12,22,5) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 5,biography = 0,need_blessing = 1874,attr = [{1,26080},{2,521600},{3,13040},{4,13040}],other = []};

get_companion_stage(12,22,6) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 6,biography = 0,need_blessing = 1886,attr = [{1,26160},{2,523200},{3,13080},{4,13080}],other = []};

get_companion_stage(12,22,7) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 7,biography = 0,need_blessing = 1898,attr = [{1,26240},{2,524800},{3,13120},{4,13120}],other = []};

get_companion_stage(12,22,8) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 8,biography = 0,need_blessing = 1910,attr = [{1,26320},{2,526400},{3,13160},{4,13160}],other = []};

get_companion_stage(12,22,9) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 9,biography = 0,need_blessing = 1922,attr = [{1,26400},{2,528000},{3,13200},{4,13200}],other = []};

get_companion_stage(12,22,10) ->
	#base_companion_stage{companion_id = 12,stage = 22,star = 10,biography = 0,need_blessing = 1935,attr = [{1,26560},{2,531200},{3,13280},{4,13280}],other = []};

get_companion_stage(12,23,1) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 1,biography = 0,need_blessing = 1947,attr = [{1,26640},{2,532800},{3,13320},{4,13320}],other = []};

get_companion_stage(12,23,2) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 2,biography = 0,need_blessing = 1959,attr = [{1,26720},{2,534400},{3,13360},{4,13360}],other = []};

get_companion_stage(12,23,3) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 3,biography = 0,need_blessing = 1971,attr = [{1,26800},{2,536000},{3,13400},{4,13400}],other = []};

get_companion_stage(12,23,4) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 4,biography = 0,need_blessing = 1983,attr = [{1,26880},{2,537600},{3,13440},{4,13440}],other = []};

get_companion_stage(12,23,5) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 5,biography = 0,need_blessing = 1996,attr = [{1,26960},{2,539200},{3,13480},{4,13480}],other = []};

get_companion_stage(12,23,6) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 6,biography = 0,need_blessing = 2008,attr = [{1,27040},{2,540800},{3,13520},{4,13520}],other = []};

get_companion_stage(12,23,7) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 7,biography = 0,need_blessing = 2020,attr = [{1,27120},{2,542400},{3,13560},{4,13560}],other = []};

get_companion_stage(12,23,8) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 8,biography = 0,need_blessing = 2032,attr = [{1,27200},{2,544000},{3,13600},{4,13600}],other = []};

get_companion_stage(12,23,9) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 9,biography = 0,need_blessing = 2045,attr = [{1,27280},{2,545600},{3,13640},{4,13640}],other = []};

get_companion_stage(12,23,10) ->
	#base_companion_stage{companion_id = 12,stage = 23,star = 10,biography = 0,need_blessing = 2057,attr = [{1,27440},{2,548800},{3,13720},{4,13720}],other = []};

get_companion_stage(12,24,1) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 1,biography = 0,need_blessing = 2070,attr = [{1,27520},{2,550400},{3,13760},{4,13760}],other = []};

get_companion_stage(12,24,2) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 2,biography = 0,need_blessing = 2082,attr = [{1,27600},{2,552000},{3,13800},{4,13800}],other = []};

get_companion_stage(12,24,3) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 3,biography = 0,need_blessing = 2094,attr = [{1,27680},{2,553600},{3,13840},{4,13840}],other = []};

get_companion_stage(12,24,4) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 4,biography = 0,need_blessing = 2107,attr = [{1,27760},{2,555200},{3,13880},{4,13880}],other = []};

get_companion_stage(12,24,5) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 5,biography = 0,need_blessing = 2119,attr = [{1,27840},{2,556800},{3,13920},{4,13920}],other = []};

get_companion_stage(12,24,6) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 6,biography = 0,need_blessing = 2132,attr = [{1,27920},{2,558400},{3,13960},{4,13960}],other = []};

get_companion_stage(12,24,7) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 7,biography = 0,need_blessing = 2144,attr = [{1,28000},{2,560000},{3,14000},{4,14000}],other = []};

get_companion_stage(12,24,8) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 8,biography = 0,need_blessing = 2157,attr = [{1,28080},{2,561600},{3,14040},{4,14040}],other = []};

get_companion_stage(12,24,9) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 9,biography = 0,need_blessing = 2169,attr = [{1,28160},{2,563200},{3,14080},{4,14080}],other = []};

get_companion_stage(12,24,10) ->
	#base_companion_stage{companion_id = 12,stage = 24,star = 10,biography = 0,need_blessing = 2182,attr = [{1,28320},{2,566400},{3,14160},{4,14160}],other = []};

get_companion_stage(12,25,1) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 1,biography = 0,need_blessing = 2195,attr = [{1,28400},{2,568000},{3,14200},{4,14200}],other = []};

get_companion_stage(12,25,2) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 2,biography = 0,need_blessing = 2207,attr = [{1,28480},{2,569600},{3,14240},{4,14240}],other = []};

get_companion_stage(12,25,3) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 3,biography = 0,need_blessing = 2220,attr = [{1,28560},{2,571200},{3,14280},{4,14280}],other = []};

get_companion_stage(12,25,4) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 4,biography = 0,need_blessing = 2232,attr = [{1,28640},{2,572800},{3,14320},{4,14320}],other = []};

get_companion_stage(12,25,5) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 5,biography = 0,need_blessing = 2245,attr = [{1,28720},{2,574400},{3,14360},{4,14360}],other = []};

get_companion_stage(12,25,6) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 6,biography = 0,need_blessing = 2258,attr = [{1,28800},{2,576000},{3,14400},{4,14400}],other = []};

get_companion_stage(12,25,7) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 7,biography = 0,need_blessing = 2270,attr = [{1,28880},{2,577600},{3,14440},{4,14440}],other = []};

get_companion_stage(12,25,8) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 8,biography = 0,need_blessing = 2283,attr = [{1,28960},{2,579200},{3,14480},{4,14480}],other = []};

get_companion_stage(12,25,9) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 9,biography = 0,need_blessing = 2296,attr = [{1,29040},{2,580800},{3,14520},{4,14520}],other = []};

get_companion_stage(12,25,10) ->
	#base_companion_stage{companion_id = 12,stage = 25,star = 10,biography = 0,need_blessing = 2309,attr = [{1,29200},{2,584000},{3,14600},{4,14600}],other = []};

get_companion_stage(12,26,1) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 1,biography = 0,need_blessing = 2322,attr = [{1,29280},{2,585600},{3,14640},{4,14640}],other = []};

get_companion_stage(12,26,2) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 2,biography = 0,need_blessing = 2334,attr = [{1,29360},{2,587200},{3,14680},{4,14680}],other = []};

get_companion_stage(12,26,3) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 3,biography = 0,need_blessing = 2347,attr = [{1,29440},{2,588800},{3,14720},{4,14720}],other = []};

get_companion_stage(12,26,4) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 4,biography = 0,need_blessing = 2360,attr = [{1,29520},{2,590400},{3,14760},{4,14760}],other = []};

get_companion_stage(12,26,5) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 5,biography = 0,need_blessing = 2373,attr = [{1,29600},{2,592000},{3,14800},{4,14800}],other = []};

get_companion_stage(12,26,6) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 6,biography = 0,need_blessing = 2386,attr = [{1,29680},{2,593600},{3,14840},{4,14840}],other = []};

get_companion_stage(12,26,7) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 7,biography = 0,need_blessing = 2399,attr = [{1,29760},{2,595200},{3,14880},{4,14880}],other = []};

get_companion_stage(12,26,8) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 8,biography = 0,need_blessing = 2412,attr = [{1,29840},{2,596800},{3,14920},{4,14920}],other = []};

get_companion_stage(12,26,9) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 9,biography = 0,need_blessing = 2425,attr = [{1,29920},{2,598400},{3,14960},{4,14960}],other = []};

get_companion_stage(12,26,10) ->
	#base_companion_stage{companion_id = 12,stage = 26,star = 10,biography = 0,need_blessing = 2438,attr = [{1,30080},{2,601600},{3,15040},{4,15040}],other = []};

get_companion_stage(12,27,1) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 1,biography = 0,need_blessing = 2451,attr = [{1,30160},{2,603200},{3,15080},{4,15080}],other = []};

get_companion_stage(12,27,2) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 2,biography = 0,need_blessing = 2464,attr = [{1,30240},{2,604800},{3,15120},{4,15120}],other = []};

get_companion_stage(12,27,3) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 3,biography = 0,need_blessing = 2477,attr = [{1,30320},{2,606400},{3,15160},{4,15160}],other = []};

get_companion_stage(12,27,4) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 4,biography = 0,need_blessing = 2490,attr = [{1,30400},{2,608000},{3,15200},{4,15200}],other = []};

get_companion_stage(12,27,5) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 5,biography = 0,need_blessing = 2503,attr = [{1,30480},{2,609600},{3,15240},{4,15240}],other = []};

get_companion_stage(12,27,6) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 6,biography = 0,need_blessing = 2516,attr = [{1,30560},{2,611200},{3,15280},{4,15280}],other = []};

get_companion_stage(12,27,7) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 7,biography = 0,need_blessing = 2529,attr = [{1,30640},{2,612800},{3,15320},{4,15320}],other = []};

get_companion_stage(12,27,8) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 8,biography = 0,need_blessing = 2542,attr = [{1,30720},{2,614400},{3,15360},{4,15360}],other = []};

get_companion_stage(12,27,9) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 9,biography = 0,need_blessing = 2555,attr = [{1,30800},{2,616000},{3,15400},{4,15400}],other = []};

get_companion_stage(12,27,10) ->
	#base_companion_stage{companion_id = 12,stage = 27,star = 10,biography = 0,need_blessing = 2568,attr = [{1,30960},{2,619200},{3,15480},{4,15480}],other = []};

get_companion_stage(12,28,1) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 1,biography = 0,need_blessing = 2582,attr = [{1,31040},{2,620800},{3,15520},{4,15520}],other = []};

get_companion_stage(12,28,2) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 2,biography = 0,need_blessing = 2595,attr = [{1,31120},{2,622400},{3,15560},{4,15560}],other = []};

get_companion_stage(12,28,3) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 3,biography = 0,need_blessing = 2608,attr = [{1,31200},{2,624000},{3,15600},{4,15600}],other = []};

get_companion_stage(12,28,4) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 4,biography = 0,need_blessing = 2621,attr = [{1,31280},{2,625600},{3,15640},{4,15640}],other = []};

get_companion_stage(12,28,5) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 5,biography = 0,need_blessing = 2635,attr = [{1,31360},{2,627200},{3,15680},{4,15680}],other = []};

get_companion_stage(12,28,6) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 6,biography = 0,need_blessing = 2648,attr = [{1,31440},{2,628800},{3,15720},{4,15720}],other = []};

get_companion_stage(12,28,7) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 7,biography = 0,need_blessing = 2661,attr = [{1,31520},{2,630400},{3,15760},{4,15760}],other = []};

get_companion_stage(12,28,8) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 8,biography = 0,need_blessing = 2674,attr = [{1,31600},{2,632000},{3,15800},{4,15800}],other = []};

get_companion_stage(12,28,9) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 9,biography = 0,need_blessing = 2688,attr = [{1,31680},{2,633600},{3,15840},{4,15840}],other = []};

get_companion_stage(12,28,10) ->
	#base_companion_stage{companion_id = 12,stage = 28,star = 10,biography = 0,need_blessing = 2701,attr = [{1,31840},{2,636800},{3,15920},{4,15920}],other = []};

get_companion_stage(12,29,1) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 1,biography = 0,need_blessing = 2715,attr = [{1,31920},{2,638400},{3,15960},{4,15960}],other = []};

get_companion_stage(12,29,2) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 2,biography = 0,need_blessing = 2728,attr = [{1,32000},{2,640000},{3,16000},{4,16000}],other = []};

get_companion_stage(12,29,3) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 3,biography = 0,need_blessing = 2741,attr = [{1,32080},{2,641600},{3,16040},{4,16040}],other = []};

get_companion_stage(12,29,4) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 4,biography = 0,need_blessing = 2755,attr = [{1,32160},{2,643200},{3,16080},{4,16080}],other = []};

get_companion_stage(12,29,5) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 5,biography = 0,need_blessing = 2768,attr = [{1,32240},{2,644800},{3,16120},{4,16120}],other = []};

get_companion_stage(12,29,6) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 6,biography = 0,need_blessing = 2782,attr = [{1,32320},{2,646400},{3,16160},{4,16160}],other = []};

get_companion_stage(12,29,7) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 7,biography = 0,need_blessing = 2795,attr = [{1,32400},{2,648000},{3,16200},{4,16200}],other = []};

get_companion_stage(12,29,8) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 8,biography = 0,need_blessing = 2809,attr = [{1,32480},{2,649600},{3,16240},{4,16240}],other = []};

get_companion_stage(12,29,9) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 9,biography = 0,need_blessing = 2822,attr = [{1,32560},{2,651200},{3,16280},{4,16280}],other = []};

get_companion_stage(12,29,10) ->
	#base_companion_stage{companion_id = 12,stage = 29,star = 10,biography = 0,need_blessing = 2836,attr = [{1,32720},{2,654400},{3,16360},{4,16360}],other = []};

get_companion_stage(12,30,1) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 1,biography = 0,need_blessing = 2849,attr = [{1,32800},{2,656000},{3,16400},{4,16400}],other = []};

get_companion_stage(12,30,2) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 2,biography = 0,need_blessing = 2863,attr = [{1,32880},{2,657600},{3,16440},{4,16440}],other = []};

get_companion_stage(12,30,3) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 3,biography = 0,need_blessing = 2877,attr = [{1,32960},{2,659200},{3,16480},{4,16480}],other = []};

get_companion_stage(12,30,4) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 4,biography = 0,need_blessing = 2890,attr = [{1,33040},{2,660800},{3,16520},{4,16520}],other = []};

get_companion_stage(12,30,5) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 5,biography = 0,need_blessing = 2904,attr = [{1,33120},{2,662400},{3,16560},{4,16560}],other = []};

get_companion_stage(12,30,6) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 6,biography = 0,need_blessing = 2918,attr = [{1,33200},{2,664000},{3,16600},{4,16600}],other = []};

get_companion_stage(12,30,7) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 7,biography = 0,need_blessing = 2931,attr = [{1,33280},{2,665600},{3,16640},{4,16640}],other = []};

get_companion_stage(12,30,8) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 8,biography = 0,need_blessing = 2945,attr = [{1,33360},{2,667200},{3,16680},{4,16680}],other = []};

get_companion_stage(12,30,9) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 9,biography = 0,need_blessing = 2959,attr = [{1,33440},{2,668800},{3,16720},{4,16720}],other = []};

get_companion_stage(12,30,10) ->
	#base_companion_stage{companion_id = 12,stage = 30,star = 10,biography = 0,need_blessing = 0,attr = [{1,33600},{2,672000},{3,16800},{4,16800}],other = []};

get_companion_stage(_Companionid,_Stage,_Star) ->
	[].

get_biog_stage_star(1,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(1,1) ->
[{1,10}];

get_biog_stage_star(1,2) ->
[{3,10}];

get_biog_stage_star(1,3) ->
[{5,10}];

get_biog_stage_star(2,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(2,1) ->
[{1,10}];

get_biog_stage_star(2,2) ->
[{3,10}];

get_biog_stage_star(2,3) ->
[{5,10}];

get_biog_stage_star(3,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(3,1) ->
[{1,10}];

get_biog_stage_star(3,2) ->
[{3,10}];

get_biog_stage_star(3,3) ->
[{5,10}];

get_biog_stage_star(4,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(4,1) ->
[{1,10}];

get_biog_stage_star(4,2) ->
[{3,10}];

get_biog_stage_star(4,3) ->
[{5,10}];

get_biog_stage_star(5,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(5,1) ->
[{1,10}];

get_biog_stage_star(5,2) ->
[{3,10}];

get_biog_stage_star(5,3) ->
[{5,10}];

get_biog_stage_star(6,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(6,1) ->
[{1,10}];

get_biog_stage_star(6,2) ->
[{3,10}];

get_biog_stage_star(6,3) ->
[{5,10}];

get_biog_stage_star(7,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(7,1) ->
[{1,10}];

get_biog_stage_star(7,2) ->
[{3,10}];

get_biog_stage_star(7,3) ->
[{5,10}];

get_biog_stage_star(8,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(8,1) ->
[{1,10}];

get_biog_stage_star(8,2) ->
[{3,10}];

get_biog_stage_star(8,3) ->
[{5,10}];

get_biog_stage_star(9,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(9,1) ->
[{1,10}];

get_biog_stage_star(9,2) ->
[{3,10}];

get_biog_stage_star(9,3) ->
[{5,10}];

get_biog_stage_star(10,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(10,1) ->
[{1,10}];

get_biog_stage_star(10,2) ->
[{3,10}];

get_biog_stage_star(10,3) ->
[{5,10}];

get_biog_stage_star(11,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(11,1) ->
[{1,10}];

get_biog_stage_star(11,2) ->
[{3,10}];

get_biog_stage_star(11,3) ->
[{5,10}];

get_biog_stage_star(12,0) ->
[{1,0},{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7},{2,8},{2,9},{2,10},{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{3,9},{4,1},{4,2},{4,3},{4,4},{4,5},{4,6},{4,7},{4,8},{4,9},{4,10},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{9,1},{9,2},{9,3},{9,4},{9,5},{9,6},{9,7},{9,8},{9,9},{9,10},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{10,8},{10,9},{10,10},{11,1},{11,2},{11,3},{11,4},{11,5},{11,6},{11,7},{11,8},{11,9},{11,10},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{12,7},{12,8},{12,9},{12,10},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{15,1},{15,2},{15,3},{15,4},{15,5},{15,6},{15,7},{15,8},{15,9},{15,10},{16,1},{16,2},{16,3},{16,4},{16,5},{16,6},{16,7},{16,8},{16,9},{16,10},{17,1},{17,2},{17,3},{17,4},{17,5},{17,6},{17,7},{17,8},{17,9},{17,10},{18,1},{18,2},{18,3},{18,4},{18,5},{18,6},{18,7},{18,8},{18,9},{18,10},{19,1},{19,2},{19,3},{19,4},{19,5},{19,6},{19,7},{19,8},{19,9},{19,10},{20,1},{20,2},{20,3},{20,4},{20,5},{20,6},{20,7},{20,8},{20,9},{20,10},{21,1},{21,2},{21,3},{21,4},{21,5},{21,6},{21,7},{21,8},{21,9},{21,10},{22,1},{22,2},{22,3},{22,4},{22,5},{22,6},{22,7},{22,8},{22,9},{22,10},{23,1},{23,2},{23,3},{23,4},{23,5},{23,6},{23,7},{23,8},{23,9},{23,10},{24,1},{24,2},{24,3},{24,4},{24,5},{24,6},{24,7},{24,8},{24,9},{24,10},{25,1},{25,2},{25,3},{25,4},{25,5},{25,6},{25,7},{25,8},{25,9},{25,10},{26,1},{26,2},{26,3},{26,4},{26,5},{26,6},{26,7},{26,8},{26,9},{26,10},{27,1},{27,2},{27,3},{27,4},{27,5},{27,6},{27,7},{27,8},{27,9},{27,10},{28,1},{28,2},{28,3},{28,4},{28,5},{28,6},{28,7},{28,8},{28,9},{28,10},{29,1},{29,2},{29,3},{29,4},{29,5},{29,6},{29,7},{29,8},{29,9},{29,10},{30,1},{30,2},{30,3},{30,4},{30,5},{30,6},{30,7},{30,8},{30,9},{30,10}];

get_biog_stage_star(12,1) ->
[{1,10}];

get_biog_stage_star(12,2) ->
[{3,10}];

get_biog_stage_star(12,3) ->
[{5,10}];

get_biog_stage_star(_Companionid,_Biography) ->
	[].


get_biog_lv_list(1) ->
[0,1,2,3];


get_biog_lv_list(2) ->
[0,1,2,3];


get_biog_lv_list(3) ->
[0,1,2,3];


get_biog_lv_list(4) ->
[0,1,2,3];


get_biog_lv_list(5) ->
[0,1,2,3];


get_biog_lv_list(6) ->
[0,1,2,3];


get_biog_lv_list(7) ->
[0,1,2,3];


get_biog_lv_list(8) ->
[0,1,2,3];


get_biog_lv_list(9) ->
[0,1,2,3];


get_biog_lv_list(10) ->
[0,1,2,3];


get_biog_lv_list(11) ->
[0,1,2,3];


get_biog_lv_list(12) ->
[0,1,2,3];

get_biog_lv_list(_Companionid) ->
	[].


get_value(1) ->
40;


get_value(2) ->
1;


get_value(3) ->
35;


get_value(4) ->
1;


get_value(5) ->
1;


get_value(6) ->
30;


get_value(7) ->
10;


get_value(8) ->
1;


get_value(9) ->
20002;


get_value(10) ->
[2000000];


get_value(11) ->
[8];


get_value(12) ->
[50000];


get_value(13) ->
0;

get_value(_Id) ->
	[].

