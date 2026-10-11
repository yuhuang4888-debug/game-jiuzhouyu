%%%---------------------------------------
%%% module      : data_baby_new
%%% description : 宝宝配置(新)
%%%
%%%---------------------------------------
-module(data_baby_new).
-compile(export_all).
-include("rec_baby.hrl").




get_key(1) ->
305;


get_key(2) ->
[{2,0,288}];


get_key(3) ->
2;


get_key(4) ->
[{38040041,10},{38040042,50},{38040043,300}];


get_key(5) ->
10;


get_key(6) ->
[{0,38040041,1}];


get_key(7) ->
[{2,0,200}];


get_key(8) ->
[{38040031,10},{38040032,50},{38040033,100}];

get_key(_Key) ->
	0.

base_baby_raise(1) ->
	#base_baby_raise{task_id = 1,mod_id = 300,sub_mod = 7,open_lv = 85,num_con = 20,raise_exp = 65};

base_baby_raise(2) ->
	#base_baby_raise{task_id = 2,mod_id = 460,sub_mod = 12,open_lv = 78,num_con = 3,raise_exp = 65};

base_baby_raise(3) ->
	#base_baby_raise{task_id = 3,mod_id = 610,sub_mod = 13,open_lv = 180,num_con = 2,raise_exp = 65};

base_baby_raise(4) ->
	#base_baby_raise{task_id = 4,mod_id = 610,sub_mod = 5,open_lv = 120,num_con = 2,raise_exp = 65};

base_baby_raise(6) ->
	#base_baby_raise{task_id = 6,mod_id = 280,sub_mod = 0,open_lv = 78,num_con = 10,raise_exp = 40};

base_baby_raise(7) ->
	#base_baby_raise{task_id = 7,mod_id = 610,sub_mod = 32,open_lv = 320,num_con = 2,raise_exp = 50};

base_baby_raise(8) ->
	#base_baby_raise{task_id = 8,mod_id = 460,sub_mod = 4,open_lv = 240,num_con = 6,raise_exp = 60};

base_baby_raise(9) ->
	#base_baby_raise{task_id = 9,mod_id = 157,sub_mod = 0,open_lv = 50,num_con = 120,raise_exp = 100};

base_baby_raise(_Taskid) ->
	[].

get_all_baby_task() ->
[{1,85},{2,78},{3,180},{4,120},{6,78},{7,320},{8,240},{9,50}].


get_task_by_mod_id(300) ->
[{1,300,7,85}];


get_task_by_mod_id(460) ->
[{2,460,12,78},{8,460,4,240}];


get_task_by_mod_id(610) ->
[{3,610,13,180},{4,610,5,120},{7,610,32,320}];


get_task_by_mod_id(280) ->
[{6,280,0,78}];


get_task_by_mod_id(157) ->
[{9,157,0,50}];

get_task_by_mod_id(_Modid) ->
	[].

get_baby_stage(1,1,1) ->
	#base_baby_stage{type = 1,stage = 1,level = 1,exp_con = 10,base_attr = [{3,75},{4,75},{5,38},{6,38}],extra_attr = []};

get_baby_stage(1,1,2) ->
	#base_baby_stage{type = 1,stage = 1,level = 2,exp_con = 13,base_attr = [{3,90},{4,90},{5,45},{6,45}],extra_attr = []};

get_baby_stage(1,1,3) ->
	#base_baby_stage{type = 1,stage = 1,level = 3,exp_con = 17,base_attr = [{3,105},{4,105},{5,53},{6,53}],extra_attr = []};

get_baby_stage(1,1,4) ->
	#base_baby_stage{type = 1,stage = 1,level = 4,exp_con = 22,base_attr = [{3,120},{4,120},{5,60},{6,60}],extra_attr = []};

get_baby_stage(1,1,5) ->
	#base_baby_stage{type = 1,stage = 1,level = 5,exp_con = 25,base_attr = [{3,135},{4,135},{5,68},{6,68}],extra_attr = []};

get_baby_stage(1,1,6) ->
	#base_baby_stage{type = 1,stage = 1,level = 6,exp_con = 32,base_attr = [{3,150},{4,150},{5,75},{6,75}],extra_attr = []};

get_baby_stage(1,1,7) ->
	#base_baby_stage{type = 1,stage = 1,level = 7,exp_con = 38,base_attr = [{3,165},{4,165},{5,83},{6,83}],extra_attr = []};

get_baby_stage(1,1,8) ->
	#base_baby_stage{type = 1,stage = 1,level = 8,exp_con = 43,base_attr = [{3,185},{4,185},{5,93},{6,93}],extra_attr = []};

get_baby_stage(1,1,9) ->
	#base_baby_stage{type = 1,stage = 1,level = 9,exp_con = 50,base_attr = [{3,205},{4,205},{5,103},{6,103}],extra_attr = []};

get_baby_stage(1,1,10) ->
	#base_baby_stage{type = 1,stage = 1,level = 10,exp_con = 60,base_attr = [{3,220},{4,220},{5,110},{6,110}],extra_attr = []};

get_baby_stage(1,1,11) ->
	#base_baby_stage{type = 1,stage = 1,level = 11,exp_con = 30,base_attr = [{3,240},{4,240},{5,120},{6,120}],extra_attr = []};

get_baby_stage(1,1,12) ->
	#base_baby_stage{type = 1,stage = 1,level = 12,exp_con = 38,base_attr = [{3,265},{4,265},{5,133},{6,133}],extra_attr = []};

get_baby_stage(1,1,13) ->
	#base_baby_stage{type = 1,stage = 1,level = 13,exp_con = 45,base_attr = [{3,285},{4,285},{5,143},{6,143}],extra_attr = []};

get_baby_stage(1,1,14) ->
	#base_baby_stage{type = 1,stage = 1,level = 14,exp_con = 49,base_attr = [{3,310},{4,310},{5,155},{6,155}],extra_attr = []};

get_baby_stage(1,1,15) ->
	#base_baby_stage{type = 1,stage = 1,level = 15,exp_con = 58,base_attr = [{3,330},{4,330},{5,165},{6,165}],extra_attr = []};

get_baby_stage(1,1,16) ->
	#base_baby_stage{type = 1,stage = 1,level = 16,exp_con = 67,base_attr = [{3,355},{4,355},{5,178},{6,178}],extra_attr = []};

get_baby_stage(1,1,17) ->
	#base_baby_stage{type = 1,stage = 1,level = 17,exp_con = 75,base_attr = [{3,380},{4,380},{5,190},{6,190}],extra_attr = []};

get_baby_stage(1,1,18) ->
	#base_baby_stage{type = 1,stage = 1,level = 18,exp_con = 90,base_attr = [{3,405},{4,405},{5,203},{6,203}],extra_attr = []};

get_baby_stage(1,1,19) ->
	#base_baby_stage{type = 1,stage = 1,level = 19,exp_con = 102,base_attr = [{3,430},{4,430},{5,215},{6,215}],extra_attr = []};

get_baby_stage(1,1,20) ->
	#base_baby_stage{type = 1,stage = 1,level = 20,exp_con = 120,base_attr = [{3,460},{4,460},{5,230},{6,230}],extra_attr = []};

get_baby_stage(1,1,21) ->
	#base_baby_stage{type = 1,stage = 1,level = 21,exp_con = 80,base_attr = [{3,485},{4,485},{5,243},{6,243}],extra_attr = []};

get_baby_stage(1,1,22) ->
	#base_baby_stage{type = 1,stage = 1,level = 22,exp_con = 85,base_attr = [{3,515},{4,515},{5,258},{6,258}],extra_attr = []};

get_baby_stage(1,1,23) ->
	#base_baby_stage{type = 1,stage = 1,level = 23,exp_con = 95,base_attr = [{3,545},{4,545},{5,273},{6,273}],extra_attr = []};

get_baby_stage(1,1,24) ->
	#base_baby_stage{type = 1,stage = 1,level = 24,exp_con = 110,base_attr = [{3,575},{4,575},{5,288},{6,288}],extra_attr = []};

get_baby_stage(1,1,25) ->
	#base_baby_stage{type = 1,stage = 1,level = 25,exp_con = 125,base_attr = [{3,605},{4,605},{5,303},{6,303}],extra_attr = []};

get_baby_stage(1,1,26) ->
	#base_baby_stage{type = 1,stage = 1,level = 26,exp_con = 135,base_attr = [{3,635},{4,635},{5,318},{6,318}],extra_attr = []};

get_baby_stage(1,1,27) ->
	#base_baby_stage{type = 1,stage = 1,level = 27,exp_con = 145,base_attr = [{3,665},{4,665},{5,333},{6,333}],extra_attr = []};

get_baby_stage(1,1,28) ->
	#base_baby_stage{type = 1,stage = 1,level = 28,exp_con = 150,base_attr = [{3,700},{4,700},{5,350},{6,350}],extra_attr = []};

get_baby_stage(1,1,29) ->
	#base_baby_stage{type = 1,stage = 1,level = 29,exp_con = 155,base_attr = [{3,735},{4,735},{5,368},{6,368}],extra_attr = []};

get_baby_stage(1,1,30) ->
	#base_baby_stage{type = 1,stage = 1,level = 30,exp_con = 162,base_attr = [{3,770},{4,770},{5,385},{6,385}],extra_attr = []};

get_baby_stage(1,1,31) ->
	#base_baby_stage{type = 1,stage = 1,level = 31,exp_con = 115,base_attr = [{3,800},{4,800},{5,400},{6,400}],extra_attr = []};

get_baby_stage(1,1,32) ->
	#base_baby_stage{type = 1,stage = 1,level = 32,exp_con = 121,base_attr = [{3,840},{4,840},{5,420},{6,420}],extra_attr = []};

get_baby_stage(1,1,33) ->
	#base_baby_stage{type = 1,stage = 1,level = 33,exp_con = 127,base_attr = [{3,875},{4,875},{5,438},{6,438}],extra_attr = []};

get_baby_stage(1,1,34) ->
	#base_baby_stage{type = 1,stage = 1,level = 34,exp_con = 133,base_attr = [{3,910},{4,910},{5,455},{6,455}],extra_attr = []};

get_baby_stage(1,1,35) ->
	#base_baby_stage{type = 1,stage = 1,level = 35,exp_con = 139,base_attr = [{3,950},{4,950},{5,475},{6,475}],extra_attr = []};

get_baby_stage(1,1,36) ->
	#base_baby_stage{type = 1,stage = 1,level = 36,exp_con = 145,base_attr = [{3,985},{4,985},{5,493},{6,493}],extra_attr = []};

get_baby_stage(1,1,37) ->
	#base_baby_stage{type = 1,stage = 1,level = 37,exp_con = 151,base_attr = [{3,1025},{4,1025},{5,513},{6,513}],extra_attr = []};

get_baby_stage(1,1,38) ->
	#base_baby_stage{type = 1,stage = 1,level = 38,exp_con = 158,base_attr = [{3,1065},{4,1065},{5,533},{6,533}],extra_attr = []};

get_baby_stage(1,1,39) ->
	#base_baby_stage{type = 1,stage = 1,level = 39,exp_con = 166,base_attr = [{3,1105},{4,1105},{5,553},{6,553}],extra_attr = []};

get_baby_stage(1,1,40) ->
	#base_baby_stage{type = 1,stage = 1,level = 40,exp_con = 173,base_attr = [{3,1145},{4,1145},{5,573},{6,573}],extra_attr = []};

get_baby_stage(1,1,41) ->
	#base_baby_stage{type = 1,stage = 1,level = 41,exp_con = 180,base_attr = [{3,1185},{4,1185},{5,593},{6,593}],extra_attr = []};

get_baby_stage(1,1,42) ->
	#base_baby_stage{type = 1,stage = 1,level = 42,exp_con = 187,base_attr = [{3,1230},{4,1230},{5,615},{6,615}],extra_attr = []};

get_baby_stage(1,1,43) ->
	#base_baby_stage{type = 1,stage = 1,level = 43,exp_con = 194,base_attr = [{3,1270},{4,1270},{5,635},{6,635}],extra_attr = []};

get_baby_stage(1,1,44) ->
	#base_baby_stage{type = 1,stage = 1,level = 44,exp_con = 202,base_attr = [{3,1315},{4,1315},{5,658},{6,658}],extra_attr = []};

get_baby_stage(1,1,45) ->
	#base_baby_stage{type = 1,stage = 1,level = 45,exp_con = 209,base_attr = [{3,1360},{4,1360},{5,680},{6,680}],extra_attr = []};

get_baby_stage(1,1,46) ->
	#base_baby_stage{type = 1,stage = 1,level = 46,exp_con = 217,base_attr = [{3,1405},{4,1405},{5,703},{6,703}],extra_attr = []};

get_baby_stage(1,1,47) ->
	#base_baby_stage{type = 1,stage = 1,level = 47,exp_con = 226,base_attr = [{3,1450},{4,1450},{5,725},{6,725}],extra_attr = []};

get_baby_stage(1,1,48) ->
	#base_baby_stage{type = 1,stage = 1,level = 48,exp_con = 234,base_attr = [{3,1495},{4,1495},{5,748},{6,748}],extra_attr = []};

get_baby_stage(1,1,49) ->
	#base_baby_stage{type = 1,stage = 1,level = 49,exp_con = 242,base_attr = [{3,1545},{4,1545},{5,773},{6,773}],extra_attr = []};

get_baby_stage(1,1,50) ->
	#base_baby_stage{type = 1,stage = 1,level = 50,exp_con = 251,base_attr = [{3,1590},{4,1590},{5,795},{6,795}],extra_attr = []};

get_baby_stage(1,1,51) ->
	#base_baby_stage{type = 1,stage = 1,level = 51,exp_con = 259,base_attr = [{3,1640},{4,1640},{5,820},{6,820}],extra_attr = []};

get_baby_stage(1,1,52) ->
	#base_baby_stage{type = 1,stage = 1,level = 52,exp_con = 268,base_attr = [{3,1685},{4,1685},{5,843},{6,843}],extra_attr = []};

get_baby_stage(1,1,53) ->
	#base_baby_stage{type = 1,stage = 1,level = 53,exp_con = 276,base_attr = [{3,1735},{4,1735},{5,868},{6,868}],extra_attr = []};

get_baby_stage(1,1,54) ->
	#base_baby_stage{type = 1,stage = 1,level = 54,exp_con = 286,base_attr = [{3,1785},{4,1785},{5,893},{6,893}],extra_attr = []};

get_baby_stage(1,1,55) ->
	#base_baby_stage{type = 1,stage = 1,level = 55,exp_con = 295,base_attr = [{3,1835},{4,1835},{5,918},{6,918}],extra_attr = []};

get_baby_stage(1,1,56) ->
	#base_baby_stage{type = 1,stage = 1,level = 56,exp_con = 305,base_attr = [{3,1885},{4,1885},{5,943},{6,943}],extra_attr = []};

get_baby_stage(1,1,57) ->
	#base_baby_stage{type = 1,stage = 1,level = 57,exp_con = 314,base_attr = [{3,1940},{4,1940},{5,970},{6,970}],extra_attr = []};

get_baby_stage(1,1,58) ->
	#base_baby_stage{type = 1,stage = 1,level = 58,exp_con = 324,base_attr = [{3,1990},{4,1990},{5,995},{6,995}],extra_attr = []};

get_baby_stage(1,1,59) ->
	#base_baby_stage{type = 1,stage = 1,level = 59,exp_con = 334,base_attr = [{3,2045},{4,2045},{5,1023},{6,1023}],extra_attr = []};

get_baby_stage(1,1,60) ->
	#base_baby_stage{type = 1,stage = 1,level = 60,exp_con = 343,base_attr = [{3,2095},{4,2095},{5,1048},{6,1048}],extra_attr = []};

get_baby_stage(1,1,61) ->
	#base_baby_stage{type = 1,stage = 1,level = 61,exp_con = 353,base_attr = [{3,2150},{4,2150},{5,1075},{6,1075}],extra_attr = []};

get_baby_stage(1,1,62) ->
	#base_baby_stage{type = 1,stage = 1,level = 62,exp_con = 364,base_attr = [{3,2205},{4,2205},{5,1103},{6,1103}],extra_attr = []};

get_baby_stage(1,1,63) ->
	#base_baby_stage{type = 1,stage = 1,level = 63,exp_con = 374,base_attr = [{3,2260},{4,2260},{5,1130},{6,1130}],extra_attr = []};

get_baby_stage(1,1,64) ->
	#base_baby_stage{type = 1,stage = 1,level = 64,exp_con = 385,base_attr = [{3,2320},{4,2320},{5,1160},{6,1160}],extra_attr = []};

get_baby_stage(1,1,65) ->
	#base_baby_stage{type = 1,stage = 1,level = 65,exp_con = 396,base_attr = [{3,2375},{4,2375},{5,1188},{6,1188}],extra_attr = []};

get_baby_stage(1,1,66) ->
	#base_baby_stage{type = 1,stage = 1,level = 66,exp_con = 407,base_attr = [{3,2430},{4,2430},{5,1215},{6,1215}],extra_attr = []};

get_baby_stage(1,1,67) ->
	#base_baby_stage{type = 1,stage = 1,level = 67,exp_con = 418,base_attr = [{3,2490},{4,2490},{5,1245},{6,1245}],extra_attr = []};

get_baby_stage(1,1,68) ->
	#base_baby_stage{type = 1,stage = 1,level = 68,exp_con = 428,base_attr = [{3,2550},{4,2550},{5,1275},{6,1275}],extra_attr = []};

get_baby_stage(1,1,69) ->
	#base_baby_stage{type = 1,stage = 1,level = 69,exp_con = 439,base_attr = [{3,2605},{4,2605},{5,1303},{6,1303}],extra_attr = []};

get_baby_stage(1,1,70) ->
	#base_baby_stage{type = 1,stage = 1,level = 70,exp_con = 451,base_attr = [{3,2665},{4,2665},{5,1333},{6,1333}],extra_attr = []};

get_baby_stage(1,1,71) ->
	#base_baby_stage{type = 1,stage = 1,level = 71,exp_con = 463,base_attr = [{3,2725},{4,2725},{5,1363},{6,1363}],extra_attr = []};

get_baby_stage(1,1,72) ->
	#base_baby_stage{type = 1,stage = 1,level = 72,exp_con = 475,base_attr = [{3,2790},{4,2790},{5,1395},{6,1395}],extra_attr = []};

get_baby_stage(1,1,73) ->
	#base_baby_stage{type = 1,stage = 1,level = 73,exp_con = 487,base_attr = [{3,2850},{4,2850},{5,1425},{6,1425}],extra_attr = []};

get_baby_stage(1,1,74) ->
	#base_baby_stage{type = 1,stage = 1,level = 74,exp_con = 499,base_attr = [{3,2910},{4,2910},{5,1455},{6,1455}],extra_attr = []};

get_baby_stage(1,1,75) ->
	#base_baby_stage{type = 1,stage = 1,level = 75,exp_con = 511,base_attr = [{3,2975},{4,2975},{5,1488},{6,1488}],extra_attr = []};

get_baby_stage(1,1,76) ->
	#base_baby_stage{type = 1,stage = 1,level = 76,exp_con = 523,base_attr = [{3,3035},{4,3035},{5,1518},{6,1518}],extra_attr = []};

get_baby_stage(1,1,77) ->
	#base_baby_stage{type = 1,stage = 1,level = 77,exp_con = 535,base_attr = [{3,3100},{4,3100},{5,1550},{6,1550}],extra_attr = []};

get_baby_stage(1,1,78) ->
	#base_baby_stage{type = 1,stage = 1,level = 78,exp_con = 548,base_attr = [{3,3165},{4,3165},{5,1583},{6,1583}],extra_attr = []};

get_baby_stage(1,1,79) ->
	#base_baby_stage{type = 1,stage = 1,level = 79,exp_con = 562,base_attr = [{3,3230},{4,3230},{5,1615},{6,1615}],extra_attr = []};

get_baby_stage(1,1,80) ->
	#base_baby_stage{type = 1,stage = 1,level = 80,exp_con = 575,base_attr = [{3,3295},{4,3295},{5,1648},{6,1648}],extra_attr = []};

get_baby_stage(1,1,81) ->
	#base_baby_stage{type = 1,stage = 1,level = 81,exp_con = 588,base_attr = [{3,3360},{4,3360},{5,1680},{6,1680}],extra_attr = []};

get_baby_stage(1,1,82) ->
	#base_baby_stage{type = 1,stage = 1,level = 82,exp_con = 601,base_attr = [{3,3430},{4,3430},{5,1715},{6,1715}],extra_attr = []};

get_baby_stage(1,1,83) ->
	#base_baby_stage{type = 1,stage = 1,level = 83,exp_con = 614,base_attr = [{3,3495},{4,3495},{5,1748},{6,1748}],extra_attr = []};

get_baby_stage(1,1,84) ->
	#base_baby_stage{type = 1,stage = 1,level = 84,exp_con = 628,base_attr = [{3,3565},{4,3565},{5,1783},{6,1783}],extra_attr = []};

get_baby_stage(1,1,85) ->
	#base_baby_stage{type = 1,stage = 1,level = 85,exp_con = 641,base_attr = [{3,3630},{4,3630},{5,1815},{6,1815}],extra_attr = []};

get_baby_stage(1,1,86) ->
	#base_baby_stage{type = 1,stage = 1,level = 86,exp_con = 655,base_attr = [{3,3700},{4,3700},{5,1850},{6,1850}],extra_attr = []};

get_baby_stage(1,1,87) ->
	#base_baby_stage{type = 1,stage = 1,level = 87,exp_con = 670,base_attr = [{3,3770},{4,3770},{5,1885},{6,1885}],extra_attr = []};

get_baby_stage(1,1,88) ->
	#base_baby_stage{type = 1,stage = 1,level = 88,exp_con = 684,base_attr = [{3,3840},{4,3840},{5,1920},{6,1920}],extra_attr = []};

get_baby_stage(1,1,89) ->
	#base_baby_stage{type = 1,stage = 1,level = 89,exp_con = 698,base_attr = [{3,3910},{4,3910},{5,1955},{6,1955}],extra_attr = []};

get_baby_stage(1,1,90) ->
	#base_baby_stage{type = 1,stage = 1,level = 90,exp_con = 713,base_attr = [{3,3985},{4,3985},{5,1993},{6,1993}],extra_attr = []};

get_baby_stage(1,1,91) ->
	#base_baby_stage{type = 1,stage = 1,level = 91,exp_con = 727,base_attr = [{3,4055},{4,4055},{5,2028},{6,2028}],extra_attr = []};

get_baby_stage(1,1,92) ->
	#base_baby_stage{type = 1,stage = 1,level = 92,exp_con = 742,base_attr = [{3,4130},{4,4130},{5,2065},{6,2065}],extra_attr = []};

get_baby_stage(1,1,93) ->
	#base_baby_stage{type = 1,stage = 1,level = 93,exp_con = 756,base_attr = [{3,4200},{4,4200},{5,2100},{6,2100}],extra_attr = []};

get_baby_stage(1,1,94) ->
	#base_baby_stage{type = 1,stage = 1,level = 94,exp_con = 772,base_attr = [{3,4275},{4,4275},{5,2138},{6,2138}],extra_attr = []};

get_baby_stage(1,1,95) ->
	#base_baby_stage{type = 1,stage = 1,level = 95,exp_con = 787,base_attr = [{3,4350},{4,4350},{5,2175},{6,2175}],extra_attr = []};

get_baby_stage(1,1,96) ->
	#base_baby_stage{type = 1,stage = 1,level = 96,exp_con = 803,base_attr = [{3,4425},{4,4425},{5,2213},{6,2213}],extra_attr = []};

get_baby_stage(1,1,97) ->
	#base_baby_stage{type = 1,stage = 1,level = 97,exp_con = 818,base_attr = [{3,4500},{4,4500},{5,2250},{6,2250}],extra_attr = []};

get_baby_stage(1,1,98) ->
	#base_baby_stage{type = 1,stage = 1,level = 98,exp_con = 834,base_attr = [{3,4575},{4,4575},{5,2288},{6,2288}],extra_attr = []};

get_baby_stage(1,1,99) ->
	#base_baby_stage{type = 1,stage = 1,level = 99,exp_con = 850,base_attr = [{3,4650},{4,4650},{5,2325},{6,2325}],extra_attr = []};

get_baby_stage(1,1,100) ->
	#base_baby_stage{type = 1,stage = 1,level = 100,exp_con = 865,base_attr = [{3,4730},{4,4730},{5,2365},{6,2365}],extra_attr = []};

get_baby_stage(1,1,101) ->
	#base_baby_stage{type = 1,stage = 1,level = 101,exp_con = 881,base_attr = [{3,4805},{4,4805},{5,2403},{6,2403}],extra_attr = []};

get_baby_stage(1,1,102) ->
	#base_baby_stage{type = 1,stage = 1,level = 102,exp_con = 898,base_attr = [{3,4885},{4,4885},{5,2443},{6,2443}],extra_attr = []};

get_baby_stage(1,1,103) ->
	#base_baby_stage{type = 1,stage = 1,level = 103,exp_con = 914,base_attr = [{3,4965},{4,4965},{5,2483},{6,2483}],extra_attr = []};

get_baby_stage(1,1,104) ->
	#base_baby_stage{type = 1,stage = 1,level = 104,exp_con = 931,base_attr = [{3,5040},{4,5040},{5,2520},{6,2520}],extra_attr = []};

get_baby_stage(1,1,105) ->
	#base_baby_stage{type = 1,stage = 1,level = 105,exp_con = 948,base_attr = [{3,5120},{4,5120},{5,2560},{6,2560}],extra_attr = []};

get_baby_stage(1,1,106) ->
	#base_baby_stage{type = 1,stage = 1,level = 106,exp_con = 965,base_attr = [{3,5205},{4,5205},{5,2603},{6,2603}],extra_attr = []};

get_baby_stage(1,1,107) ->
	#base_baby_stage{type = 1,stage = 1,level = 107,exp_con = 982,base_attr = [{3,5285},{4,5285},{5,2643},{6,2643}],extra_attr = []};

get_baby_stage(1,1,108) ->
	#base_baby_stage{type = 1,stage = 1,level = 108,exp_con = 998,base_attr = [{3,5365},{4,5365},{5,2683},{6,2683}],extra_attr = []};

get_baby_stage(1,1,109) ->
	#base_baby_stage{type = 1,stage = 1,level = 109,exp_con = 1015,base_attr = [{3,5445},{4,5445},{5,2723},{6,2723}],extra_attr = []};

get_baby_stage(1,1,110) ->
	#base_baby_stage{type = 1,stage = 1,level = 110,exp_con = 1033,base_attr = [{3,5530},{4,5530},{5,2765},{6,2765}],extra_attr = []};

get_baby_stage(1,1,111) ->
	#base_baby_stage{type = 1,stage = 1,level = 111,exp_con = 1051,base_attr = [{3,5615},{4,5615},{5,2808},{6,2808}],extra_attr = []};

get_baby_stage(1,1,112) ->
	#base_baby_stage{type = 1,stage = 1,level = 112,exp_con = 1069,base_attr = [{3,5695},{4,5695},{5,2848},{6,2848}],extra_attr = []};

get_baby_stage(1,1,113) ->
	#base_baby_stage{type = 1,stage = 1,level = 113,exp_con = 1087,base_attr = [{3,5780},{4,5780},{5,2890},{6,2890}],extra_attr = []};

get_baby_stage(1,1,114) ->
	#base_baby_stage{type = 1,stage = 1,level = 114,exp_con = 1105,base_attr = [{3,5865},{4,5865},{5,2933},{6,2933}],extra_attr = []};

get_baby_stage(1,1,115) ->
	#base_baby_stage{type = 1,stage = 1,level = 115,exp_con = 1123,base_attr = [{3,5950},{4,5950},{5,2975},{6,2975}],extra_attr = []};

get_baby_stage(1,1,116) ->
	#base_baby_stage{type = 1,stage = 1,level = 116,exp_con = 1141,base_attr = [{3,6035},{4,6035},{5,3018},{6,3018}],extra_attr = []};

get_baby_stage(1,1,117) ->
	#base_baby_stage{type = 1,stage = 1,level = 117,exp_con = 1159,base_attr = [{3,6125},{4,6125},{5,3063},{6,3063}],extra_attr = []};

get_baby_stage(1,1,118) ->
	#base_baby_stage{type = 1,stage = 1,level = 118,exp_con = 1178,base_attr = [{3,6210},{4,6210},{5,3105},{6,3105}],extra_attr = []};

get_baby_stage(1,1,119) ->
	#base_baby_stage{type = 1,stage = 1,level = 119,exp_con = 1198,base_attr = [{3,6300},{4,6300},{5,3150},{6,3150}],extra_attr = []};

get_baby_stage(1,1,120) ->
	#base_baby_stage{type = 1,stage = 1,level = 120,exp_con = 1217,base_attr = [{3,6385},{4,6385},{5,3193},{6,3193}],extra_attr = []};

get_baby_stage(1,1,121) ->
	#base_baby_stage{type = 1,stage = 1,level = 121,exp_con = 1222,base_attr = [{3,6475},{4,6475},{5,3238},{6,3238}],extra_attr = []};

get_baby_stage(1,1,122) ->
	#base_baby_stage{type = 1,stage = 1,level = 122,exp_con = 1226,base_attr = [{3,6565},{4,6565},{5,3283},{6,3283}],extra_attr = []};

get_baby_stage(1,1,123) ->
	#base_baby_stage{type = 1,stage = 1,level = 123,exp_con = 1231,base_attr = [{3,6655},{4,6655},{5,3328},{6,3328}],extra_attr = []};

get_baby_stage(1,1,124) ->
	#base_baby_stage{type = 1,stage = 1,level = 124,exp_con = 1236,base_attr = [{3,6745},{4,6745},{5,3373},{6,3373}],extra_attr = []};

get_baby_stage(1,1,125) ->
	#base_baby_stage{type = 1,stage = 1,level = 125,exp_con = 1241,base_attr = [{3,6835},{4,6835},{5,3418},{6,3418}],extra_attr = []};

get_baby_stage(1,1,126) ->
	#base_baby_stage{type = 1,stage = 1,level = 126,exp_con = 1246,base_attr = [{3,6925},{4,6925},{5,3463},{6,3463}],extra_attr = []};

get_baby_stage(1,1,127) ->
	#base_baby_stage{type = 1,stage = 1,level = 127,exp_con = 1250,base_attr = [{3,7020},{4,7020},{5,3510},{6,3510}],extra_attr = []};

get_baby_stage(1,1,128) ->
	#base_baby_stage{type = 1,stage = 1,level = 128,exp_con = 1255,base_attr = [{3,7110},{4,7110},{5,3555},{6,3555}],extra_attr = []};

get_baby_stage(1,1,129) ->
	#base_baby_stage{type = 1,stage = 1,level = 129,exp_con = 1260,base_attr = [{3,7205},{4,7205},{5,3603},{6,3603}],extra_attr = []};

get_baby_stage(1,1,130) ->
	#base_baby_stage{type = 1,stage = 1,level = 130,exp_con = 1265,base_attr = [{3,7300},{4,7300},{5,3650},{6,3650}],extra_attr = []};

get_baby_stage(1,1,131) ->
	#base_baby_stage{type = 1,stage = 1,level = 131,exp_con = 1270,base_attr = [{3,7390},{4,7390},{5,3695},{6,3695}],extra_attr = []};

get_baby_stage(1,1,132) ->
	#base_baby_stage{type = 1,stage = 1,level = 132,exp_con = 1274,base_attr = [{3,7485},{4,7485},{5,3743},{6,3743}],extra_attr = []};

get_baby_stage(1,1,133) ->
	#base_baby_stage{type = 1,stage = 1,level = 133,exp_con = 1279,base_attr = [{3,7580},{4,7580},{5,3790},{6,3790}],extra_attr = []};

get_baby_stage(1,1,134) ->
	#base_baby_stage{type = 1,stage = 1,level = 134,exp_con = 1284,base_attr = [{3,7675},{4,7675},{5,3838},{6,3838}],extra_attr = []};

get_baby_stage(1,1,135) ->
	#base_baby_stage{type = 1,stage = 1,level = 135,exp_con = 1289,base_attr = [{3,7775},{4,7775},{5,3888},{6,3888}],extra_attr = []};

get_baby_stage(1,1,136) ->
	#base_baby_stage{type = 1,stage = 1,level = 136,exp_con = 1294,base_attr = [{3,7870},{4,7870},{5,3935},{6,3935}],extra_attr = []};

get_baby_stage(1,1,137) ->
	#base_baby_stage{type = 1,stage = 1,level = 137,exp_con = 1298,base_attr = [{3,7965},{4,7965},{5,3983},{6,3983}],extra_attr = []};

get_baby_stage(1,1,138) ->
	#base_baby_stage{type = 1,stage = 1,level = 138,exp_con = 1303,base_attr = [{3,8065},{4,8065},{5,4033},{6,4033}],extra_attr = []};

get_baby_stage(1,1,139) ->
	#base_baby_stage{type = 1,stage = 1,level = 139,exp_con = 1308,base_attr = [{3,8165},{4,8165},{5,4083},{6,4083}],extra_attr = []};

get_baby_stage(1,1,140) ->
	#base_baby_stage{type = 1,stage = 1,level = 140,exp_con = 1313,base_attr = [{3,8260},{4,8260},{5,4130},{6,4130}],extra_attr = []};

get_baby_stage(1,1,141) ->
	#base_baby_stage{type = 1,stage = 1,level = 141,exp_con = 1318,base_attr = [{3,8360},{4,8360},{5,4180},{6,4180}],extra_attr = []};

get_baby_stage(1,1,142) ->
	#base_baby_stage{type = 1,stage = 1,level = 142,exp_con = 1322,base_attr = [{3,8460},{4,8460},{5,4230},{6,4230}],extra_attr = []};

get_baby_stage(1,1,143) ->
	#base_baby_stage{type = 1,stage = 1,level = 143,exp_con = 1327,base_attr = [{3,8560},{4,8560},{5,4280},{6,4280}],extra_attr = []};

get_baby_stage(1,1,144) ->
	#base_baby_stage{type = 1,stage = 1,level = 144,exp_con = 1332,base_attr = [{3,8665},{4,8665},{5,4333},{6,4333}],extra_attr = []};

get_baby_stage(1,1,145) ->
	#base_baby_stage{type = 1,stage = 1,level = 145,exp_con = 1337,base_attr = [{3,8765},{4,8765},{5,4383},{6,4383}],extra_attr = []};

get_baby_stage(1,1,146) ->
	#base_baby_stage{type = 1,stage = 1,level = 146,exp_con = 1342,base_attr = [{3,8865},{4,8865},{5,4433},{6,4433}],extra_attr = []};

get_baby_stage(1,1,147) ->
	#base_baby_stage{type = 1,stage = 1,level = 147,exp_con = 1346,base_attr = [{3,8970},{4,8970},{5,4485},{6,4485}],extra_attr = []};

get_baby_stage(1,1,148) ->
	#base_baby_stage{type = 1,stage = 1,level = 148,exp_con = 1351,base_attr = [{3,9070},{4,9070},{5,4535},{6,4535}],extra_attr = []};

get_baby_stage(1,1,149) ->
	#base_baby_stage{type = 1,stage = 1,level = 149,exp_con = 1356,base_attr = [{3,9175},{4,9175},{5,4588},{6,4588}],extra_attr = []};

get_baby_stage(1,1,150) ->
	#base_baby_stage{type = 1,stage = 1,level = 150,exp_con = 1361,base_attr = [{3,9280},{4,9280},{5,4640},{6,4640}],extra_attr = []};

get_baby_stage(1,1,151) ->
	#base_baby_stage{type = 1,stage = 1,level = 151,exp_con = 1366,base_attr = [{3,9385},{4,9385},{5,4693},{6,4693}],extra_attr = []};

get_baby_stage(1,1,152) ->
	#base_baby_stage{type = 1,stage = 1,level = 152,exp_con = 1370,base_attr = [{3,9490},{4,9490},{5,4745},{6,4745}],extra_attr = []};

get_baby_stage(1,1,153) ->
	#base_baby_stage{type = 1,stage = 1,level = 153,exp_con = 1375,base_attr = [{3,9595},{4,9595},{5,4798},{6,4798}],extra_attr = []};

get_baby_stage(1,1,154) ->
	#base_baby_stage{type = 1,stage = 1,level = 154,exp_con = 1380,base_attr = [{3,9700},{4,9700},{5,4850},{6,4850}],extra_attr = []};

get_baby_stage(1,1,155) ->
	#base_baby_stage{type = 1,stage = 1,level = 155,exp_con = 1385,base_attr = [{3,9810},{4,9810},{5,4905},{6,4905}],extra_attr = []};

get_baby_stage(1,1,156) ->
	#base_baby_stage{type = 1,stage = 1,level = 156,exp_con = 1390,base_attr = [{3,9915},{4,9915},{5,4958},{6,4958}],extra_attr = []};

get_baby_stage(1,1,157) ->
	#base_baby_stage{type = 1,stage = 1,level = 157,exp_con = 1394,base_attr = [{3,10025},{4,10025},{5,5013},{6,5013}],extra_attr = []};

get_baby_stage(1,1,158) ->
	#base_baby_stage{type = 1,stage = 1,level = 158,exp_con = 1399,base_attr = [{3,10130},{4,10130},{5,5065},{6,5065}],extra_attr = []};

get_baby_stage(1,1,159) ->
	#base_baby_stage{type = 1,stage = 1,level = 159,exp_con = 1404,base_attr = [{3,10240},{4,10240},{5,5120},{6,5120}],extra_attr = []};

get_baby_stage(1,1,160) ->
	#base_baby_stage{type = 1,stage = 1,level = 160,exp_con = 1409,base_attr = [{3,10350},{4,10350},{5,5175},{6,5175}],extra_attr = []};

get_baby_stage(1,1,161) ->
	#base_baby_stage{type = 1,stage = 1,level = 161,exp_con = 1414,base_attr = [{3,10460},{4,10460},{5,5230},{6,5230}],extra_attr = []};

get_baby_stage(1,1,162) ->
	#base_baby_stage{type = 1,stage = 1,level = 162,exp_con = 1418,base_attr = [{3,10570},{4,10570},{5,5285},{6,5285}],extra_attr = []};

get_baby_stage(1,1,163) ->
	#base_baby_stage{type = 1,stage = 1,level = 163,exp_con = 1423,base_attr = [{3,10680},{4,10680},{5,5340},{6,5340}],extra_attr = []};

get_baby_stage(1,1,164) ->
	#base_baby_stage{type = 1,stage = 1,level = 164,exp_con = 1428,base_attr = [{3,10790},{4,10790},{5,5395},{6,5395}],extra_attr = []};

get_baby_stage(1,1,165) ->
	#base_baby_stage{type = 1,stage = 1,level = 165,exp_con = 1433,base_attr = [{3,10905},{4,10905},{5,5453},{6,5453}],extra_attr = []};

get_baby_stage(1,1,166) ->
	#base_baby_stage{type = 1,stage = 1,level = 166,exp_con = 1438,base_attr = [{3,11015},{4,11015},{5,5508},{6,5508}],extra_attr = []};

get_baby_stage(1,1,167) ->
	#base_baby_stage{type = 1,stage = 1,level = 167,exp_con = 1442,base_attr = [{3,11130},{4,11130},{5,5565},{6,5565}],extra_attr = []};

get_baby_stage(1,1,168) ->
	#base_baby_stage{type = 1,stage = 1,level = 168,exp_con = 1447,base_attr = [{3,11240},{4,11240},{5,5620},{6,5620}],extra_attr = []};

get_baby_stage(1,1,169) ->
	#base_baby_stage{type = 1,stage = 1,level = 169,exp_con = 1452,base_attr = [{3,11355},{4,11355},{5,5678},{6,5678}],extra_attr = []};

get_baby_stage(1,1,170) ->
	#base_baby_stage{type = 1,stage = 1,level = 170,exp_con = 1457,base_attr = [{3,11470},{4,11470},{5,5735},{6,5735}],extra_attr = []};

get_baby_stage(1,1,171) ->
	#base_baby_stage{type = 1,stage = 1,level = 171,exp_con = 1462,base_attr = [{3,11585},{4,11585},{5,5793},{6,5793}],extra_attr = []};

get_baby_stage(1,1,172) ->
	#base_baby_stage{type = 1,stage = 1,level = 172,exp_con = 1466,base_attr = [{3,11700},{4,11700},{5,5850},{6,5850}],extra_attr = []};

get_baby_stage(1,1,173) ->
	#base_baby_stage{type = 1,stage = 1,level = 173,exp_con = 1471,base_attr = [{3,11815},{4,11815},{5,5908},{6,5908}],extra_attr = []};

get_baby_stage(1,1,174) ->
	#base_baby_stage{type = 1,stage = 1,level = 174,exp_con = 1476,base_attr = [{3,11935},{4,11935},{5,5968},{6,5968}],extra_attr = []};

get_baby_stage(1,1,175) ->
	#base_baby_stage{type = 1,stage = 1,level = 175,exp_con = 1481,base_attr = [{3,12050},{4,12050},{5,6025},{6,6025}],extra_attr = []};

get_baby_stage(1,1,176) ->
	#base_baby_stage{type = 1,stage = 1,level = 176,exp_con = 1486,base_attr = [{3,12170},{4,12170},{5,6085},{6,6085}],extra_attr = []};

get_baby_stage(1,1,177) ->
	#base_baby_stage{type = 1,stage = 1,level = 177,exp_con = 1490,base_attr = [{3,12285},{4,12285},{5,6143},{6,6143}],extra_attr = []};

get_baby_stage(1,1,178) ->
	#base_baby_stage{type = 1,stage = 1,level = 178,exp_con = 1495,base_attr = [{3,12405},{4,12405},{5,6203},{6,6203}],extra_attr = []};

get_baby_stage(1,1,179) ->
	#base_baby_stage{type = 1,stage = 1,level = 179,exp_con = 1500,base_attr = [{3,12525},{4,12525},{5,6263},{6,6263}],extra_attr = []};

get_baby_stage(1,1,180) ->
	#base_baby_stage{type = 1,stage = 1,level = 180,exp_con = 1505,base_attr = [{3,12645},{4,12645},{5,6323},{6,6323}],extra_attr = []};

get_baby_stage(1,1,181) ->
	#base_baby_stage{type = 1,stage = 1,level = 181,exp_con = 1510,base_attr = [{3,12765},{4,12765},{5,6383},{6,6383}],extra_attr = []};

get_baby_stage(1,1,182) ->
	#base_baby_stage{type = 1,stage = 1,level = 182,exp_con = 1514,base_attr = [{3,12885},{4,12885},{5,6443},{6,6443}],extra_attr = []};

get_baby_stage(1,1,183) ->
	#base_baby_stage{type = 1,stage = 1,level = 183,exp_con = 1519,base_attr = [{3,13005},{4,13005},{5,6503},{6,6503}],extra_attr = []};

get_baby_stage(1,1,184) ->
	#base_baby_stage{type = 1,stage = 1,level = 184,exp_con = 1524,base_attr = [{3,13125},{4,13125},{5,6563},{6,6563}],extra_attr = []};

get_baby_stage(1,1,185) ->
	#base_baby_stage{type = 1,stage = 1,level = 185,exp_con = 1529,base_attr = [{3,13250},{4,13250},{5,6625},{6,6625}],extra_attr = []};

get_baby_stage(1,1,186) ->
	#base_baby_stage{type = 1,stage = 1,level = 186,exp_con = 1534,base_attr = [{3,13370},{4,13370},{5,6685},{6,6685}],extra_attr = []};

get_baby_stage(1,1,187) ->
	#base_baby_stage{type = 1,stage = 1,level = 187,exp_con = 1538,base_attr = [{3,13495},{4,13495},{5,6748},{6,6748}],extra_attr = []};

get_baby_stage(1,1,188) ->
	#base_baby_stage{type = 1,stage = 1,level = 188,exp_con = 1543,base_attr = [{3,13615},{4,13615},{5,6808},{6,6808}],extra_attr = []};

get_baby_stage(1,1,189) ->
	#base_baby_stage{type = 1,stage = 1,level = 189,exp_con = 1548,base_attr = [{3,13740},{4,13740},{5,6870},{6,6870}],extra_attr = []};

get_baby_stage(1,1,190) ->
	#base_baby_stage{type = 1,stage = 1,level = 190,exp_con = 1553,base_attr = [{3,13865},{4,13865},{5,6933},{6,6933}],extra_attr = []};

get_baby_stage(1,1,191) ->
	#base_baby_stage{type = 1,stage = 1,level = 191,exp_con = 1558,base_attr = [{3,13990},{4,13990},{5,6995},{6,6995}],extra_attr = []};

get_baby_stage(1,1,192) ->
	#base_baby_stage{type = 1,stage = 1,level = 192,exp_con = 1562,base_attr = [{3,14115},{4,14115},{5,7058},{6,7058}],extra_attr = []};

get_baby_stage(1,1,193) ->
	#base_baby_stage{type = 1,stage = 1,level = 193,exp_con = 1567,base_attr = [{3,14240},{4,14240},{5,7120},{6,7120}],extra_attr = []};

get_baby_stage(1,1,194) ->
	#base_baby_stage{type = 1,stage = 1,level = 194,exp_con = 1572,base_attr = [{3,14370},{4,14370},{5,7185},{6,7185}],extra_attr = []};

get_baby_stage(1,1,195) ->
	#base_baby_stage{type = 1,stage = 1,level = 195,exp_con = 1577,base_attr = [{3,14495},{4,14495},{5,7248},{6,7248}],extra_attr = []};

get_baby_stage(1,1,196) ->
	#base_baby_stage{type = 1,stage = 1,level = 196,exp_con = 1582,base_attr = [{3,14625},{4,14625},{5,7313},{6,7313}],extra_attr = []};

get_baby_stage(1,1,197) ->
	#base_baby_stage{type = 1,stage = 1,level = 197,exp_con = 1586,base_attr = [{3,14750},{4,14750},{5,7375},{6,7375}],extra_attr = []};

get_baby_stage(1,1,198) ->
	#base_baby_stage{type = 1,stage = 1,level = 198,exp_con = 1591,base_attr = [{3,14880},{4,14880},{5,7440},{6,7440}],extra_attr = []};

get_baby_stage(1,1,199) ->
	#base_baby_stage{type = 1,stage = 1,level = 199,exp_con = 1596,base_attr = [{3,15010},{4,15010},{5,7505},{6,7505}],extra_attr = []};

get_baby_stage(1,1,200) ->
	#base_baby_stage{type = 1,stage = 1,level = 200,exp_con = 1601,base_attr = [{3,15140},{4,15140},{5,7570},{6,7570}],extra_attr = []};

get_baby_stage(1,1,201) ->
	#base_baby_stage{type = 1,stage = 1,level = 201,exp_con = 1606,base_attr = [{3,15270},{4,15270},{5,7635},{6,7635}],extra_attr = []};

get_baby_stage(1,1,202) ->
	#base_baby_stage{type = 1,stage = 1,level = 202,exp_con = 1610,base_attr = [{3,15400},{4,15400},{5,7700},{6,7700}],extra_attr = []};

get_baby_stage(1,1,203) ->
	#base_baby_stage{type = 1,stage = 1,level = 203,exp_con = 1615,base_attr = [{3,15530},{4,15530},{5,7765},{6,7765}],extra_attr = []};

get_baby_stage(1,1,204) ->
	#base_baby_stage{type = 1,stage = 1,level = 204,exp_con = 1620,base_attr = [{3,15660},{4,15660},{5,7830},{6,7830}],extra_attr = []};

get_baby_stage(1,1,205) ->
	#base_baby_stage{type = 1,stage = 1,level = 205,exp_con = 1625,base_attr = [{3,15795},{4,15795},{5,7898},{6,7898}],extra_attr = []};

get_baby_stage(1,1,206) ->
	#base_baby_stage{type = 1,stage = 1,level = 206,exp_con = 1630,base_attr = [{3,15925},{4,15925},{5,7963},{6,7963}],extra_attr = []};

get_baby_stage(1,1,207) ->
	#base_baby_stage{type = 1,stage = 1,level = 207,exp_con = 1634,base_attr = [{3,16060},{4,16060},{5,8030},{6,8030}],extra_attr = []};

get_baby_stage(1,1,208) ->
	#base_baby_stage{type = 1,stage = 1,level = 208,exp_con = 1639,base_attr = [{3,16190},{4,16190},{5,8095},{6,8095}],extra_attr = []};

get_baby_stage(1,1,209) ->
	#base_baby_stage{type = 1,stage = 1,level = 209,exp_con = 1644,base_attr = [{3,16325},{4,16325},{5,8163},{6,8163}],extra_attr = []};

get_baby_stage(1,1,210) ->
	#base_baby_stage{type = 1,stage = 1,level = 210,exp_con = 1649,base_attr = [{3,16460},{4,16460},{5,8230},{6,8230}],extra_attr = []};

get_baby_stage(1,1,211) ->
	#base_baby_stage{type = 1,stage = 1,level = 211,exp_con = 1654,base_attr = [{3,16595},{4,16595},{5,8298},{6,8298}],extra_attr = []};

get_baby_stage(1,1,212) ->
	#base_baby_stage{type = 1,stage = 1,level = 212,exp_con = 1658,base_attr = [{3,16730},{4,16730},{5,8365},{6,8365}],extra_attr = []};

get_baby_stage(1,1,213) ->
	#base_baby_stage{type = 1,stage = 1,level = 213,exp_con = 1663,base_attr = [{3,16865},{4,16865},{5,8433},{6,8433}],extra_attr = []};

get_baby_stage(1,1,214) ->
	#base_baby_stage{type = 1,stage = 1,level = 214,exp_con = 1668,base_attr = [{3,17000},{4,17000},{5,8500},{6,8500}],extra_attr = []};

get_baby_stage(1,1,215) ->
	#base_baby_stage{type = 1,stage = 1,level = 215,exp_con = 1673,base_attr = [{3,17140},{4,17140},{5,8570},{6,8570}],extra_attr = []};

get_baby_stage(1,1,216) ->
	#base_baby_stage{type = 1,stage = 1,level = 216,exp_con = 1678,base_attr = [{3,17275},{4,17275},{5,8638},{6,8638}],extra_attr = []};

get_baby_stage(1,1,217) ->
	#base_baby_stage{type = 1,stage = 1,level = 217,exp_con = 1682,base_attr = [{3,17415},{4,17415},{5,8708},{6,8708}],extra_attr = []};

get_baby_stage(1,1,218) ->
	#base_baby_stage{type = 1,stage = 1,level = 218,exp_con = 1687,base_attr = [{3,17555},{4,17555},{5,8778},{6,8778}],extra_attr = []};

get_baby_stage(1,1,219) ->
	#base_baby_stage{type = 1,stage = 1,level = 219,exp_con = 1692,base_attr = [{3,17690},{4,17690},{5,8845},{6,8845}],extra_attr = []};

get_baby_stage(1,1,220) ->
	#base_baby_stage{type = 1,stage = 1,level = 220,exp_con = 1697,base_attr = [{3,17830},{4,17830},{5,8915},{6,8915}],extra_attr = []};

get_baby_stage(1,1,221) ->
	#base_baby_stage{type = 1,stage = 1,level = 221,exp_con = 1702,base_attr = [{3,17970},{4,17970},{5,8985},{6,8985}],extra_attr = []};

get_baby_stage(1,1,222) ->
	#base_baby_stage{type = 1,stage = 1,level = 222,exp_con = 1706,base_attr = [{3,18110},{4,18110},{5,9055},{6,9055}],extra_attr = []};

get_baby_stage(1,1,223) ->
	#base_baby_stage{type = 1,stage = 1,level = 223,exp_con = 1711,base_attr = [{3,18250},{4,18250},{5,9125},{6,9125}],extra_attr = []};

get_baby_stage(1,1,224) ->
	#base_baby_stage{type = 1,stage = 1,level = 224,exp_con = 1716,base_attr = [{3,18395},{4,18395},{5,9198},{6,9198}],extra_attr = []};

get_baby_stage(1,1,225) ->
	#base_baby_stage{type = 1,stage = 1,level = 225,exp_con = 1721,base_attr = [{3,18535},{4,18535},{5,9268},{6,9268}],extra_attr = []};

get_baby_stage(1,1,226) ->
	#base_baby_stage{type = 1,stage = 1,level = 226,exp_con = 1726,base_attr = [{3,18675},{4,18675},{5,9338},{6,9338}],extra_attr = []};

get_baby_stage(1,1,227) ->
	#base_baby_stage{type = 1,stage = 1,level = 227,exp_con = 1730,base_attr = [{3,18820},{4,18820},{5,9410},{6,9410}],extra_attr = []};

get_baby_stage(1,1,228) ->
	#base_baby_stage{type = 1,stage = 1,level = 228,exp_con = 1735,base_attr = [{3,18965},{4,18965},{5,9483},{6,9483}],extra_attr = []};

get_baby_stage(1,1,229) ->
	#base_baby_stage{type = 1,stage = 1,level = 229,exp_con = 1740,base_attr = [{3,19105},{4,19105},{5,9553},{6,9553}],extra_attr = []};

get_baby_stage(1,1,230) ->
	#base_baby_stage{type = 1,stage = 1,level = 230,exp_con = 1745,base_attr = [{3,19250},{4,19250},{5,9625},{6,9625}],extra_attr = []};

get_baby_stage(1,1,231) ->
	#base_baby_stage{type = 1,stage = 1,level = 231,exp_con = 1750,base_attr = [{3,19395},{4,19395},{5,9698},{6,9698}],extra_attr = []};

get_baby_stage(1,1,232) ->
	#base_baby_stage{type = 1,stage = 1,level = 232,exp_con = 1754,base_attr = [{3,19540},{4,19540},{5,9770},{6,9770}],extra_attr = []};

get_baby_stage(1,1,233) ->
	#base_baby_stage{type = 1,stage = 1,level = 233,exp_con = 1759,base_attr = [{3,19685},{4,19685},{5,9843},{6,9843}],extra_attr = []};

get_baby_stage(1,1,234) ->
	#base_baby_stage{type = 1,stage = 1,level = 234,exp_con = 1764,base_attr = [{3,19830},{4,19830},{5,9915},{6,9915}],extra_attr = []};

get_baby_stage(1,1,235) ->
	#base_baby_stage{type = 1,stage = 1,level = 235,exp_con = 1769,base_attr = [{3,19980},{4,19980},{5,9990},{6,9990}],extra_attr = []};

get_baby_stage(1,1,236) ->
	#base_baby_stage{type = 1,stage = 1,level = 236,exp_con = 1774,base_attr = [{3,20125},{4,20125},{5,10063},{6,10063}],extra_attr = []};

get_baby_stage(1,1,237) ->
	#base_baby_stage{type = 1,stage = 1,level = 237,exp_con = 1778,base_attr = [{3,20275},{4,20275},{5,10138},{6,10138}],extra_attr = []};

get_baby_stage(1,1,238) ->
	#base_baby_stage{type = 1,stage = 1,level = 238,exp_con = 1783,base_attr = [{3,20420},{4,20420},{5,10210},{6,10210}],extra_attr = []};

get_baby_stage(1,1,239) ->
	#base_baby_stage{type = 1,stage = 1,level = 239,exp_con = 1788,base_attr = [{3,20570},{4,20570},{5,10285},{6,10285}],extra_attr = []};

get_baby_stage(1,1,240) ->
	#base_baby_stage{type = 1,stage = 1,level = 240,exp_con = 1793,base_attr = [{3,20720},{4,20720},{5,10360},{6,10360}],extra_attr = []};

get_baby_stage(1,1,241) ->
	#base_baby_stage{type = 1,stage = 1,level = 241,exp_con = 1798,base_attr = [{3,20865},{4,20865},{5,10433},{6,10433}],extra_attr = []};

get_baby_stage(1,1,242) ->
	#base_baby_stage{type = 1,stage = 1,level = 242,exp_con = 1802,base_attr = [{3,21015},{4,21015},{5,10508},{6,10508}],extra_attr = []};

get_baby_stage(1,1,243) ->
	#base_baby_stage{type = 1,stage = 1,level = 243,exp_con = 1807,base_attr = [{3,21165},{4,21165},{5,10583},{6,10583}],extra_attr = []};

get_baby_stage(1,1,244) ->
	#base_baby_stage{type = 1,stage = 1,level = 244,exp_con = 1812,base_attr = [{3,21320},{4,21320},{5,10660},{6,10660}],extra_attr = []};

get_baby_stage(1,1,245) ->
	#base_baby_stage{type = 1,stage = 1,level = 245,exp_con = 1817,base_attr = [{3,21470},{4,21470},{5,10735},{6,10735}],extra_attr = []};

get_baby_stage(1,1,246) ->
	#base_baby_stage{type = 1,stage = 1,level = 246,exp_con = 1822,base_attr = [{3,21620},{4,21620},{5,10810},{6,10810}],extra_attr = []};

get_baby_stage(1,1,247) ->
	#base_baby_stage{type = 1,stage = 1,level = 247,exp_con = 1826,base_attr = [{3,21775},{4,21775},{5,10888},{6,10888}],extra_attr = []};

get_baby_stage(1,1,248) ->
	#base_baby_stage{type = 1,stage = 1,level = 248,exp_con = 1831,base_attr = [{3,21925},{4,21925},{5,10963},{6,10963}],extra_attr = []};

get_baby_stage(1,1,249) ->
	#base_baby_stage{type = 1,stage = 1,level = 249,exp_con = 1836,base_attr = [{3,22080},{4,22080},{5,11040},{6,11040}],extra_attr = []};

get_baby_stage(1,1,250) ->
	#base_baby_stage{type = 1,stage = 1,level = 250,exp_con = 1841,base_attr = [{3,22235},{4,22235},{5,11118},{6,11118}],extra_attr = []};

get_baby_stage(1,1,251) ->
	#base_baby_stage{type = 1,stage = 1,level = 251,exp_con = 1850,base_attr = [{3,22385},{4,22385},{5,11193},{6,11193}],extra_attr = []};

get_baby_stage(1,1,252) ->
	#base_baby_stage{type = 1,stage = 1,level = 252,exp_con = 1860,base_attr = [{3,22540},{4,22540},{5,11270},{6,11270}],extra_attr = []};

get_baby_stage(1,1,253) ->
	#base_baby_stage{type = 1,stage = 1,level = 253,exp_con = 1870,base_attr = [{3,22695},{4,22695},{5,11348},{6,11348}],extra_attr = []};

get_baby_stage(1,1,254) ->
	#base_baby_stage{type = 1,stage = 1,level = 254,exp_con = 1879,base_attr = [{3,22855},{4,22855},{5,11428},{6,11428}],extra_attr = []};

get_baby_stage(1,1,255) ->
	#base_baby_stage{type = 1,stage = 1,level = 255,exp_con = 1889,base_attr = [{3,23010},{4,23010},{5,11505},{6,11505}],extra_attr = []};

get_baby_stage(1,1,256) ->
	#base_baby_stage{type = 1,stage = 1,level = 256,exp_con = 1898,base_attr = [{3,23165},{4,23165},{5,11583},{6,11583}],extra_attr = []};

get_baby_stage(1,1,257) ->
	#base_baby_stage{type = 1,stage = 1,level = 257,exp_con = 1908,base_attr = [{3,23320},{4,23320},{5,11660},{6,11660}],extra_attr = []};

get_baby_stage(1,1,258) ->
	#base_baby_stage{type = 1,stage = 1,level = 258,exp_con = 1918,base_attr = [{3,23480},{4,23480},{5,11740},{6,11740}],extra_attr = []};

get_baby_stage(1,1,259) ->
	#base_baby_stage{type = 1,stage = 1,level = 259,exp_con = 1927,base_attr = [{3,23635},{4,23635},{5,11818},{6,11818}],extra_attr = []};

get_baby_stage(1,1,260) ->
	#base_baby_stage{type = 1,stage = 1,level = 260,exp_con = 1937,base_attr = [{3,23795},{4,23795},{5,11898},{6,11898}],extra_attr = []};

get_baby_stage(1,1,261) ->
	#base_baby_stage{type = 1,stage = 1,level = 261,exp_con = 1946,base_attr = [{3,23955},{4,23955},{5,11978},{6,11978}],extra_attr = []};

get_baby_stage(1,1,262) ->
	#base_baby_stage{type = 1,stage = 1,level = 262,exp_con = 1956,base_attr = [{3,24115},{4,24115},{5,12058},{6,12058}],extra_attr = []};

get_baby_stage(1,1,263) ->
	#base_baby_stage{type = 1,stage = 1,level = 263,exp_con = 1966,base_attr = [{3,24275},{4,24275},{5,12138},{6,12138}],extra_attr = []};

get_baby_stage(1,1,264) ->
	#base_baby_stage{type = 1,stage = 1,level = 264,exp_con = 1975,base_attr = [{3,24435},{4,24435},{5,12218},{6,12218}],extra_attr = []};

get_baby_stage(1,1,265) ->
	#base_baby_stage{type = 1,stage = 1,level = 265,exp_con = 1985,base_attr = [{3,24595},{4,24595},{5,12298},{6,12298}],extra_attr = []};

get_baby_stage(1,1,266) ->
	#base_baby_stage{type = 1,stage = 1,level = 266,exp_con = 1994,base_attr = [{3,24755},{4,24755},{5,12378},{6,12378}],extra_attr = []};

get_baby_stage(1,1,267) ->
	#base_baby_stage{type = 1,stage = 1,level = 267,exp_con = 2004,base_attr = [{3,24920},{4,24920},{5,12460},{6,12460}],extra_attr = []};

get_baby_stage(1,1,268) ->
	#base_baby_stage{type = 1,stage = 1,level = 268,exp_con = 2014,base_attr = [{3,25080},{4,25080},{5,12540},{6,12540}],extra_attr = []};

get_baby_stage(1,1,269) ->
	#base_baby_stage{type = 1,stage = 1,level = 269,exp_con = 2023,base_attr = [{3,25240},{4,25240},{5,12620},{6,12620}],extra_attr = []};

get_baby_stage(1,1,270) ->
	#base_baby_stage{type = 1,stage = 1,level = 270,exp_con = 2033,base_attr = [{3,25405},{4,25405},{5,12703},{6,12703}],extra_attr = []};

get_baby_stage(1,1,271) ->
	#base_baby_stage{type = 1,stage = 1,level = 271,exp_con = 2042,base_attr = [{3,25570},{4,25570},{5,12785},{6,12785}],extra_attr = []};

get_baby_stage(1,1,272) ->
	#base_baby_stage{type = 1,stage = 1,level = 272,exp_con = 2052,base_attr = [{3,25735},{4,25735},{5,12868},{6,12868}],extra_attr = []};

get_baby_stage(1,1,273) ->
	#base_baby_stage{type = 1,stage = 1,level = 273,exp_con = 2062,base_attr = [{3,25895},{4,25895},{5,12948},{6,12948}],extra_attr = []};

get_baby_stage(1,1,274) ->
	#base_baby_stage{type = 1,stage = 1,level = 274,exp_con = 2071,base_attr = [{3,26060},{4,26060},{5,13030},{6,13030}],extra_attr = []};

get_baby_stage(1,1,275) ->
	#base_baby_stage{type = 1,stage = 1,level = 275,exp_con = 2081,base_attr = [{3,26230},{4,26230},{5,13115},{6,13115}],extra_attr = []};

get_baby_stage(1,1,276) ->
	#base_baby_stage{type = 1,stage = 1,level = 276,exp_con = 2090,base_attr = [{3,26395},{4,26395},{5,13198},{6,13198}],extra_attr = []};

get_baby_stage(1,1,277) ->
	#base_baby_stage{type = 1,stage = 1,level = 277,exp_con = 2100,base_attr = [{3,26560},{4,26560},{5,13280},{6,13280}],extra_attr = []};

get_baby_stage(1,1,278) ->
	#base_baby_stage{type = 1,stage = 1,level = 278,exp_con = 2110,base_attr = [{3,26725},{4,26725},{5,13363},{6,13363}],extra_attr = []};

get_baby_stage(1,1,279) ->
	#base_baby_stage{type = 1,stage = 1,level = 279,exp_con = 2119,base_attr = [{3,26895},{4,26895},{5,13448},{6,13448}],extra_attr = []};

get_baby_stage(1,1,280) ->
	#base_baby_stage{type = 1,stage = 1,level = 280,exp_con = 2129,base_attr = [{3,27060},{4,27060},{5,13530},{6,13530}],extra_attr = []};

get_baby_stage(1,1,281) ->
	#base_baby_stage{type = 1,stage = 1,level = 281,exp_con = 2138,base_attr = [{3,27230},{4,27230},{5,13615},{6,13615}],extra_attr = []};

get_baby_stage(1,1,282) ->
	#base_baby_stage{type = 1,stage = 1,level = 282,exp_con = 2148,base_attr = [{3,27400},{4,27400},{5,13700},{6,13700}],extra_attr = []};

get_baby_stage(1,1,283) ->
	#base_baby_stage{type = 1,stage = 1,level = 283,exp_con = 2158,base_attr = [{3,27570},{4,27570},{5,13785},{6,13785}],extra_attr = []};

get_baby_stage(1,1,284) ->
	#base_baby_stage{type = 1,stage = 1,level = 284,exp_con = 2167,base_attr = [{3,27735},{4,27735},{5,13868},{6,13868}],extra_attr = []};

get_baby_stage(1,1,285) ->
	#base_baby_stage{type = 1,stage = 1,level = 285,exp_con = 2177,base_attr = [{3,27905},{4,27905},{5,13953},{6,13953}],extra_attr = []};

get_baby_stage(1,1,286) ->
	#base_baby_stage{type = 1,stage = 1,level = 286,exp_con = 2186,base_attr = [{3,28080},{4,28080},{5,14040},{6,14040}],extra_attr = []};

get_baby_stage(1,1,287) ->
	#base_baby_stage{type = 1,stage = 1,level = 287,exp_con = 2196,base_attr = [{3,28250},{4,28250},{5,14125},{6,14125}],extra_attr = []};

get_baby_stage(1,1,288) ->
	#base_baby_stage{type = 1,stage = 1,level = 288,exp_con = 2206,base_attr = [{3,28420},{4,28420},{5,14210},{6,14210}],extra_attr = []};

get_baby_stage(1,1,289) ->
	#base_baby_stage{type = 1,stage = 1,level = 289,exp_con = 2215,base_attr = [{3,28590},{4,28590},{5,14295},{6,14295}],extra_attr = []};

get_baby_stage(1,1,290) ->
	#base_baby_stage{type = 1,stage = 1,level = 290,exp_con = 2225,base_attr = [{3,28765},{4,28765},{5,14383},{6,14383}],extra_attr = []};

get_baby_stage(1,1,291) ->
	#base_baby_stage{type = 1,stage = 1,level = 291,exp_con = 2234,base_attr = [{3,28935},{4,28935},{5,14468},{6,14468}],extra_attr = []};

get_baby_stage(1,1,292) ->
	#base_baby_stage{type = 1,stage = 1,level = 292,exp_con = 2244,base_attr = [{3,29110},{4,29110},{5,14555},{6,14555}],extra_attr = []};

get_baby_stage(1,1,293) ->
	#base_baby_stage{type = 1,stage = 1,level = 293,exp_con = 2254,base_attr = [{3,29285},{4,29285},{5,14643},{6,14643}],extra_attr = []};

get_baby_stage(1,1,294) ->
	#base_baby_stage{type = 1,stage = 1,level = 294,exp_con = 2263,base_attr = [{3,29460},{4,29460},{5,14730},{6,14730}],extra_attr = []};

get_baby_stage(1,1,295) ->
	#base_baby_stage{type = 1,stage = 1,level = 295,exp_con = 2273,base_attr = [{3,29635},{4,29635},{5,14818},{6,14818}],extra_attr = []};

get_baby_stage(1,1,296) ->
	#base_baby_stage{type = 1,stage = 1,level = 296,exp_con = 2282,base_attr = [{3,29810},{4,29810},{5,14905},{6,14905}],extra_attr = []};

get_baby_stage(1,1,297) ->
	#base_baby_stage{type = 1,stage = 1,level = 297,exp_con = 2292,base_attr = [{3,29985},{4,29985},{5,14993},{6,14993}],extra_attr = []};

get_baby_stage(1,1,298) ->
	#base_baby_stage{type = 1,stage = 1,level = 298,exp_con = 2302,base_attr = [{3,30160},{4,30160},{5,15080},{6,15080}],extra_attr = []};

get_baby_stage(1,1,299) ->
	#base_baby_stage{type = 1,stage = 1,level = 299,exp_con = 2311,base_attr = [{3,30335},{4,30335},{5,15168},{6,15168}],extra_attr = []};

get_baby_stage(1,1,300) ->
	#base_baby_stage{type = 1,stage = 1,level = 300,exp_con = 2321,base_attr = [{3,30515},{4,30515},{5,15258},{6,15258}],extra_attr = []};

get_baby_stage(1,1,301) ->
	#base_baby_stage{type = 1,stage = 1,level = 301,exp_con = 2340,base_attr = [{3,30690},{4,30690},{5,15345},{6,15345}],extra_attr = []};

get_baby_stage(1,1,302) ->
	#base_baby_stage{type = 1,stage = 1,level = 302,exp_con = 2359,base_attr = [{3,30870},{4,30870},{5,15435},{6,15435}],extra_attr = []};

get_baby_stage(1,1,303) ->
	#base_baby_stage{type = 1,stage = 1,level = 303,exp_con = 2378,base_attr = [{3,31045},{4,31045},{5,15523},{6,15523}],extra_attr = []};

get_baby_stage(1,1,304) ->
	#base_baby_stage{type = 1,stage = 1,level = 304,exp_con = 2398,base_attr = [{3,31225},{4,31225},{5,15613},{6,15613}],extra_attr = []};

get_baby_stage(1,1,305) ->
	#base_baby_stage{type = 1,stage = 1,level = 305,exp_con = 2417,base_attr = [{3,31405},{4,31405},{5,15703},{6,15703}],extra_attr = []};

get_baby_stage(1,1,306) ->
	#base_baby_stage{type = 1,stage = 1,level = 306,exp_con = 2436,base_attr = [{3,31585},{4,31585},{5,15793},{6,15793}],extra_attr = []};

get_baby_stage(1,1,307) ->
	#base_baby_stage{type = 1,stage = 1,level = 307,exp_con = 2455,base_attr = [{3,31765},{4,31765},{5,15883},{6,15883}],extra_attr = []};

get_baby_stage(1,1,308) ->
	#base_baby_stage{type = 1,stage = 1,level = 308,exp_con = 2474,base_attr = [{3,31945},{4,31945},{5,15973},{6,15973}],extra_attr = []};

get_baby_stage(1,1,309) ->
	#base_baby_stage{type = 1,stage = 1,level = 309,exp_con = 2494,base_attr = [{3,32125},{4,32125},{5,16063},{6,16063}],extra_attr = []};

get_baby_stage(1,1,310) ->
	#base_baby_stage{type = 1,stage = 1,level = 310,exp_con = 2513,base_attr = [{3,32310},{4,32310},{5,16155},{6,16155}],extra_attr = []};

get_baby_stage(1,1,311) ->
	#base_baby_stage{type = 1,stage = 1,level = 311,exp_con = 2532,base_attr = [{3,32490},{4,32490},{5,16245},{6,16245}],extra_attr = []};

get_baby_stage(1,1,312) ->
	#base_baby_stage{type = 1,stage = 1,level = 312,exp_con = 2551,base_attr = [{3,32670},{4,32670},{5,16335},{6,16335}],extra_attr = []};

get_baby_stage(1,1,313) ->
	#base_baby_stage{type = 1,stage = 1,level = 313,exp_con = 2570,base_attr = [{3,32855},{4,32855},{5,16428},{6,16428}],extra_attr = []};

get_baby_stage(1,1,314) ->
	#base_baby_stage{type = 1,stage = 1,level = 314,exp_con = 2590,base_attr = [{3,33040},{4,33040},{5,16520},{6,16520}],extra_attr = []};

get_baby_stage(1,1,315) ->
	#base_baby_stage{type = 1,stage = 1,level = 315,exp_con = 2609,base_attr = [{3,33220},{4,33220},{5,16610},{6,16610}],extra_attr = []};

get_baby_stage(1,1,316) ->
	#base_baby_stage{type = 1,stage = 1,level = 316,exp_con = 2628,base_attr = [{3,33405},{4,33405},{5,16703},{6,16703}],extra_attr = []};

get_baby_stage(1,1,317) ->
	#base_baby_stage{type = 1,stage = 1,level = 317,exp_con = 2647,base_attr = [{3,33590},{4,33590},{5,16795},{6,16795}],extra_attr = []};

get_baby_stage(1,1,318) ->
	#base_baby_stage{type = 1,stage = 1,level = 318,exp_con = 2666,base_attr = [{3,33775},{4,33775},{5,16888},{6,16888}],extra_attr = []};

get_baby_stage(1,1,319) ->
	#base_baby_stage{type = 1,stage = 1,level = 319,exp_con = 2686,base_attr = [{3,33960},{4,33960},{5,16980},{6,16980}],extra_attr = []};

get_baby_stage(1,1,320) ->
	#base_baby_stage{type = 1,stage = 1,level = 320,exp_con = 2705,base_attr = [{3,34145},{4,34145},{5,17073},{6,17073}],extra_attr = []};

get_baby_stage(1,1,321) ->
	#base_baby_stage{type = 1,stage = 1,level = 321,exp_con = 2724,base_attr = [{3,34335},{4,34335},{5,17168},{6,17168}],extra_attr = []};

get_baby_stage(1,1,322) ->
	#base_baby_stage{type = 1,stage = 1,level = 322,exp_con = 2743,base_attr = [{3,34520},{4,34520},{5,17260},{6,17260}],extra_attr = []};

get_baby_stage(1,1,323) ->
	#base_baby_stage{type = 1,stage = 1,level = 323,exp_con = 2762,base_attr = [{3,34710},{4,34710},{5,17355},{6,17355}],extra_attr = []};

get_baby_stage(1,1,324) ->
	#base_baby_stage{type = 1,stage = 1,level = 324,exp_con = 2782,base_attr = [{3,34895},{4,34895},{5,17448},{6,17448}],extra_attr = []};

get_baby_stage(1,1,325) ->
	#base_baby_stage{type = 1,stage = 1,level = 325,exp_con = 2801,base_attr = [{3,35085},{4,35085},{5,17543},{6,17543}],extra_attr = []};

get_baby_stage(1,1,326) ->
	#base_baby_stage{type = 1,stage = 1,level = 326,exp_con = 2820,base_attr = [{3,35275},{4,35275},{5,17638},{6,17638}],extra_attr = []};

get_baby_stage(1,1,327) ->
	#base_baby_stage{type = 1,stage = 1,level = 327,exp_con = 2839,base_attr = [{3,35460},{4,35460},{5,17730},{6,17730}],extra_attr = []};

get_baby_stage(1,1,328) ->
	#base_baby_stage{type = 1,stage = 1,level = 328,exp_con = 2858,base_attr = [{3,35650},{4,35650},{5,17825},{6,17825}],extra_attr = []};

get_baby_stage(1,1,329) ->
	#base_baby_stage{type = 1,stage = 1,level = 329,exp_con = 2878,base_attr = [{3,35840},{4,35840},{5,17920},{6,17920}],extra_attr = []};

get_baby_stage(1,1,330) ->
	#base_baby_stage{type = 1,stage = 1,level = 330,exp_con = 2897,base_attr = [{3,36030},{4,36030},{5,18015},{6,18015}],extra_attr = []};

get_baby_stage(1,1,331) ->
	#base_baby_stage{type = 1,stage = 1,level = 331,exp_con = 2916,base_attr = [{3,36225},{4,36225},{5,18113},{6,18113}],extra_attr = []};

get_baby_stage(1,1,332) ->
	#base_baby_stage{type = 1,stage = 1,level = 332,exp_con = 2935,base_attr = [{3,36415},{4,36415},{5,18208},{6,18208}],extra_attr = []};

get_baby_stage(1,1,333) ->
	#base_baby_stage{type = 1,stage = 1,level = 333,exp_con = 2954,base_attr = [{3,36605},{4,36605},{5,18303},{6,18303}],extra_attr = []};

get_baby_stage(1,1,334) ->
	#base_baby_stage{type = 1,stage = 1,level = 334,exp_con = 2974,base_attr = [{3,36800},{4,36800},{5,18400},{6,18400}],extra_attr = []};

get_baby_stage(1,1,335) ->
	#base_baby_stage{type = 1,stage = 1,level = 335,exp_con = 2993,base_attr = [{3,36990},{4,36990},{5,18495},{6,18495}],extra_attr = []};

get_baby_stage(1,1,336) ->
	#base_baby_stage{type = 1,stage = 1,level = 336,exp_con = 3012,base_attr = [{3,37185},{4,37185},{5,18593},{6,18593}],extra_attr = []};

get_baby_stage(1,1,337) ->
	#base_baby_stage{type = 1,stage = 1,level = 337,exp_con = 3031,base_attr = [{3,37380},{4,37380},{5,18690},{6,18690}],extra_attr = []};

get_baby_stage(1,1,338) ->
	#base_baby_stage{type = 1,stage = 1,level = 338,exp_con = 3050,base_attr = [{3,37575},{4,37575},{5,18788},{6,18788}],extra_attr = []};

get_baby_stage(1,1,339) ->
	#base_baby_stage{type = 1,stage = 1,level = 339,exp_con = 3070,base_attr = [{3,37765},{4,37765},{5,18883},{6,18883}],extra_attr = []};

get_baby_stage(1,1,340) ->
	#base_baby_stage{type = 1,stage = 1,level = 340,exp_con = 3089,base_attr = [{3,37960},{4,37960},{5,18980},{6,18980}],extra_attr = []};

get_baby_stage(1,1,341) ->
	#base_baby_stage{type = 1,stage = 1,level = 341,exp_con = 3108,base_attr = [{3,38160},{4,38160},{5,19080},{6,19080}],extra_attr = []};

get_baby_stage(1,1,342) ->
	#base_baby_stage{type = 1,stage = 1,level = 342,exp_con = 3127,base_attr = [{3,38355},{4,38355},{5,19178},{6,19178}],extra_attr = []};

get_baby_stage(1,1,343) ->
	#base_baby_stage{type = 1,stage = 1,level = 343,exp_con = 3146,base_attr = [{3,38550},{4,38550},{5,19275},{6,19275}],extra_attr = []};

get_baby_stage(1,1,344) ->
	#base_baby_stage{type = 1,stage = 1,level = 344,exp_con = 3166,base_attr = [{3,38745},{4,38745},{5,19373},{6,19373}],extra_attr = []};

get_baby_stage(1,1,345) ->
	#base_baby_stage{type = 1,stage = 1,level = 345,exp_con = 3185,base_attr = [{3,38945},{4,38945},{5,19473},{6,19473}],extra_attr = []};

get_baby_stage(1,1,346) ->
	#base_baby_stage{type = 1,stage = 1,level = 346,exp_con = 3204,base_attr = [{3,39140},{4,39140},{5,19570},{6,19570}],extra_attr = []};

get_baby_stage(1,1,347) ->
	#base_baby_stage{type = 1,stage = 1,level = 347,exp_con = 3223,base_attr = [{3,39340},{4,39340},{5,19670},{6,19670}],extra_attr = []};

get_baby_stage(1,1,348) ->
	#base_baby_stage{type = 1,stage = 1,level = 348,exp_con = 3242,base_attr = [{3,39540},{4,39540},{5,19770},{6,19770}],extra_attr = []};

get_baby_stage(1,1,349) ->
	#base_baby_stage{type = 1,stage = 1,level = 349,exp_con = 3262,base_attr = [{3,39735},{4,39735},{5,19868},{6,19868}],extra_attr = []};

get_baby_stage(1,1,350) ->
	#base_baby_stage{type = 1,stage = 1,level = 350,exp_con = 3281,base_attr = [{3,39935},{4,39935},{5,19968},{6,19968}],extra_attr = []};

get_baby_stage(1,1,351) ->
	#base_baby_stage{type = 1,stage = 1,level = 351,exp_con = 3319,base_attr = [{3,40135},{4,40135},{5,20068},{6,20068}],extra_attr = []};

get_baby_stage(1,1,352) ->
	#base_baby_stage{type = 1,stage = 1,level = 352,exp_con = 3358,base_attr = [{3,40335},{4,40335},{5,20168},{6,20168}],extra_attr = []};

get_baby_stage(1,1,353) ->
	#base_baby_stage{type = 1,stage = 1,level = 353,exp_con = 3396,base_attr = [{3,40540},{4,40540},{5,20270},{6,20270}],extra_attr = []};

get_baby_stage(1,1,354) ->
	#base_baby_stage{type = 1,stage = 1,level = 354,exp_con = 3434,base_attr = [{3,40740},{4,40740},{5,20370},{6,20370}],extra_attr = []};

get_baby_stage(1,1,355) ->
	#base_baby_stage{type = 1,stage = 1,level = 355,exp_con = 3473,base_attr = [{3,40940},{4,40940},{5,20470},{6,20470}],extra_attr = []};

get_baby_stage(1,1,356) ->
	#base_baby_stage{type = 1,stage = 1,level = 356,exp_con = 3511,base_attr = [{3,41145},{4,41145},{5,20573},{6,20573}],extra_attr = []};

get_baby_stage(1,1,357) ->
	#base_baby_stage{type = 1,stage = 1,level = 357,exp_con = 3550,base_attr = [{3,41345},{4,41345},{5,20673},{6,20673}],extra_attr = []};

get_baby_stage(1,1,358) ->
	#base_baby_stage{type = 1,stage = 1,level = 358,exp_con = 3588,base_attr = [{3,41550},{4,41550},{5,20775},{6,20775}],extra_attr = []};

get_baby_stage(1,1,359) ->
	#base_baby_stage{type = 1,stage = 1,level = 359,exp_con = 3626,base_attr = [{3,41750},{4,41750},{5,20875},{6,20875}],extra_attr = []};

get_baby_stage(1,1,360) ->
	#base_baby_stage{type = 1,stage = 1,level = 360,exp_con = 3665,base_attr = [{3,41955},{4,41955},{5,20978},{6,20978}],extra_attr = []};

get_baby_stage(1,1,361) ->
	#base_baby_stage{type = 1,stage = 1,level = 361,exp_con = 3703,base_attr = [{3,42160},{4,42160},{5,21080},{6,21080}],extra_attr = []};

get_baby_stage(1,1,362) ->
	#base_baby_stage{type = 1,stage = 1,level = 362,exp_con = 3742,base_attr = [{3,42365},{4,42365},{5,21183},{6,21183}],extra_attr = []};

get_baby_stage(1,1,363) ->
	#base_baby_stage{type = 1,stage = 1,level = 363,exp_con = 3780,base_attr = [{3,42570},{4,42570},{5,21285},{6,21285}],extra_attr = []};

get_baby_stage(1,1,364) ->
	#base_baby_stage{type = 1,stage = 1,level = 364,exp_con = 3818,base_attr = [{3,42775},{4,42775},{5,21388},{6,21388}],extra_attr = []};

get_baby_stage(1,1,365) ->
	#base_baby_stage{type = 1,stage = 1,level = 365,exp_con = 3857,base_attr = [{3,42980},{4,42980},{5,21490},{6,21490}],extra_attr = []};

get_baby_stage(1,1,366) ->
	#base_baby_stage{type = 1,stage = 1,level = 366,exp_con = 3895,base_attr = [{3,43190},{4,43190},{5,21595},{6,21595}],extra_attr = []};

get_baby_stage(1,1,367) ->
	#base_baby_stage{type = 1,stage = 1,level = 367,exp_con = 3934,base_attr = [{3,43395},{4,43395},{5,21698},{6,21698}],extra_attr = []};

get_baby_stage(1,1,368) ->
	#base_baby_stage{type = 1,stage = 1,level = 368,exp_con = 3972,base_attr = [{3,43600},{4,43600},{5,21800},{6,21800}],extra_attr = []};

get_baby_stage(1,1,369) ->
	#base_baby_stage{type = 1,stage = 1,level = 369,exp_con = 4010,base_attr = [{3,43810},{4,43810},{5,21905},{6,21905}],extra_attr = []};

get_baby_stage(1,1,370) ->
	#base_baby_stage{type = 1,stage = 1,level = 370,exp_con = 4049,base_attr = [{3,44020},{4,44020},{5,22010},{6,22010}],extra_attr = []};

get_baby_stage(1,1,371) ->
	#base_baby_stage{type = 1,stage = 1,level = 371,exp_con = 4087,base_attr = [{3,44225},{4,44225},{5,22113},{6,22113}],extra_attr = []};

get_baby_stage(1,1,372) ->
	#base_baby_stage{type = 1,stage = 1,level = 372,exp_con = 4126,base_attr = [{3,44435},{4,44435},{5,22218},{6,22218}],extra_attr = []};

get_baby_stage(1,1,373) ->
	#base_baby_stage{type = 1,stage = 1,level = 373,exp_con = 4164,base_attr = [{3,44645},{4,44645},{5,22323},{6,22323}],extra_attr = []};

get_baby_stage(1,1,374) ->
	#base_baby_stage{type = 1,stage = 1,level = 374,exp_con = 4202,base_attr = [{3,44855},{4,44855},{5,22428},{6,22428}],extra_attr = []};

get_baby_stage(1,1,375) ->
	#base_baby_stage{type = 1,stage = 1,level = 375,exp_con = 4241,base_attr = [{3,45065},{4,45065},{5,22533},{6,22533}],extra_attr = []};

get_baby_stage(1,1,376) ->
	#base_baby_stage{type = 1,stage = 1,level = 376,exp_con = 4279,base_attr = [{3,45275},{4,45275},{5,22638},{6,22638}],extra_attr = []};

get_baby_stage(1,1,377) ->
	#base_baby_stage{type = 1,stage = 1,level = 377,exp_con = 4318,base_attr = [{3,45490},{4,45490},{5,22745},{6,22745}],extra_attr = []};

get_baby_stage(1,1,378) ->
	#base_baby_stage{type = 1,stage = 1,level = 378,exp_con = 4356,base_attr = [{3,45700},{4,45700},{5,22850},{6,22850}],extra_attr = []};

get_baby_stage(1,1,379) ->
	#base_baby_stage{type = 1,stage = 1,level = 379,exp_con = 4394,base_attr = [{3,45915},{4,45915},{5,22958},{6,22958}],extra_attr = []};

get_baby_stage(1,1,380) ->
	#base_baby_stage{type = 1,stage = 1,level = 380,exp_con = 4433,base_attr = [{3,46125},{4,46125},{5,23063},{6,23063}],extra_attr = []};

get_baby_stage(1,1,381) ->
	#base_baby_stage{type = 1,stage = 1,level = 381,exp_con = 4471,base_attr = [{3,46340},{4,46340},{5,23170},{6,23170}],extra_attr = []};

get_baby_stage(1,1,382) ->
	#base_baby_stage{type = 1,stage = 1,level = 382,exp_con = 4510,base_attr = [{3,46550},{4,46550},{5,23275},{6,23275}],extra_attr = []};

get_baby_stage(1,1,383) ->
	#base_baby_stage{type = 1,stage = 1,level = 383,exp_con = 4548,base_attr = [{3,46765},{4,46765},{5,23383},{6,23383}],extra_attr = []};

get_baby_stage(1,1,384) ->
	#base_baby_stage{type = 1,stage = 1,level = 384,exp_con = 4586,base_attr = [{3,46980},{4,46980},{5,23490},{6,23490}],extra_attr = []};

get_baby_stage(1,1,385) ->
	#base_baby_stage{type = 1,stage = 1,level = 385,exp_con = 4625,base_attr = [{3,47195},{4,47195},{5,23598},{6,23598}],extra_attr = []};

get_baby_stage(1,1,386) ->
	#base_baby_stage{type = 1,stage = 1,level = 386,exp_con = 4663,base_attr = [{3,47410},{4,47410},{5,23705},{6,23705}],extra_attr = []};

get_baby_stage(1,1,387) ->
	#base_baby_stage{type = 1,stage = 1,level = 387,exp_con = 4702,base_attr = [{3,47625},{4,47625},{5,23813},{6,23813}],extra_attr = []};

get_baby_stage(1,1,388) ->
	#base_baby_stage{type = 1,stage = 1,level = 388,exp_con = 4740,base_attr = [{3,47840},{4,47840},{5,23920},{6,23920}],extra_attr = []};

get_baby_stage(1,1,389) ->
	#base_baby_stage{type = 1,stage = 1,level = 389,exp_con = 4778,base_attr = [{3,48060},{4,48060},{5,24030},{6,24030}],extra_attr = []};

get_baby_stage(1,1,390) ->
	#base_baby_stage{type = 1,stage = 1,level = 390,exp_con = 4817,base_attr = [{3,48275},{4,48275},{5,24138},{6,24138}],extra_attr = []};

get_baby_stage(1,1,391) ->
	#base_baby_stage{type = 1,stage = 1,level = 391,exp_con = 4855,base_attr = [{3,48495},{4,48495},{5,24248},{6,24248}],extra_attr = []};

get_baby_stage(1,1,392) ->
	#base_baby_stage{type = 1,stage = 1,level = 392,exp_con = 4894,base_attr = [{3,48710},{4,48710},{5,24355},{6,24355}],extra_attr = []};

get_baby_stage(1,1,393) ->
	#base_baby_stage{type = 1,stage = 1,level = 393,exp_con = 4932,base_attr = [{3,48930},{4,48930},{5,24465},{6,24465}],extra_attr = []};

get_baby_stage(1,1,394) ->
	#base_baby_stage{type = 1,stage = 1,level = 394,exp_con = 4970,base_attr = [{3,49150},{4,49150},{5,24575},{6,24575}],extra_attr = []};

get_baby_stage(1,1,395) ->
	#base_baby_stage{type = 1,stage = 1,level = 395,exp_con = 5009,base_attr = [{3,49365},{4,49365},{5,24683},{6,24683}],extra_attr = []};

get_baby_stage(1,1,396) ->
	#base_baby_stage{type = 1,stage = 1,level = 396,exp_con = 5047,base_attr = [{3,49585},{4,49585},{5,24793},{6,24793}],extra_attr = []};

get_baby_stage(1,1,397) ->
	#base_baby_stage{type = 1,stage = 1,level = 397,exp_con = 5086,base_attr = [{3,49805},{4,49805},{5,24903},{6,24903}],extra_attr = []};

get_baby_stage(1,1,398) ->
	#base_baby_stage{type = 1,stage = 1,level = 398,exp_con = 5124,base_attr = [{3,50030},{4,50030},{5,25015},{6,25015}],extra_attr = []};

get_baby_stage(1,1,399) ->
	#base_baby_stage{type = 1,stage = 1,level = 399,exp_con = 5162,base_attr = [{3,50250},{4,50250},{5,25125},{6,25125}],extra_attr = []};

get_baby_stage(1,1,400) ->
	#base_baby_stage{type = 1,stage = 1,level = 400,exp_con = 5201,base_attr = [{3,50470},{4,50470},{5,25235},{6,25235}],extra_attr = []};

get_baby_stage(2,1,1) ->
	#base_baby_stage{type = 2,stage = 1,level = 1,exp_con = 10,base_attr = [{1,105},{2,2100},{7,26},{8,26}],extra_attr = []};

get_baby_stage(2,1,2) ->
	#base_baby_stage{type = 2,stage = 1,level = 2,exp_con = 13,base_attr = [{1,130},{2,2600},{7,33},{8,33}],extra_attr = []};

get_baby_stage(2,1,3) ->
	#base_baby_stage{type = 2,stage = 1,level = 3,exp_con = 16,base_attr = [{1,155},{2,3100},{7,39},{8,39}],extra_attr = []};

get_baby_stage(2,1,4) ->
	#base_baby_stage{type = 2,stage = 1,level = 4,exp_con = 20,base_attr = [{1,185},{2,3700},{7,46},{8,46}],extra_attr = []};

get_baby_stage(2,1,5) ->
	#base_baby_stage{type = 2,stage = 1,level = 5,exp_con = 25,base_attr = [{1,220},{2,4400},{7,55},{8,55}],extra_attr = []};

get_baby_stage(2,1,6) ->
	#base_baby_stage{type = 2,stage = 1,level = 6,exp_con = 31,base_attr = [{1,260},{2,5200},{7,65},{8,65}],extra_attr = []};

get_baby_stage(2,1,7) ->
	#base_baby_stage{type = 2,stage = 1,level = 7,exp_con = 39,base_attr = [{1,295},{2,5900},{7,74},{8,74}],extra_attr = []};

get_baby_stage(2,1,8) ->
	#base_baby_stage{type = 2,stage = 1,level = 8,exp_con = 49,base_attr = [{1,340},{2,6800},{7,85},{8,85}],extra_attr = []};

get_baby_stage(2,1,9) ->
	#base_baby_stage{type = 2,stage = 1,level = 9,exp_con = 61,base_attr = [{1,385},{2,7700},{7,96},{8,96}],extra_attr = []};

get_baby_stage(2,1,10) ->
	#base_baby_stage{type = 2,stage = 1,level = 10,exp_con = 90,base_attr = [{1,435},{2,8700},{7,109},{8,109}],extra_attr = []};

get_baby_stage(2,2,1) ->
	#base_baby_stage{type = 2,stage = 2,level = 1,exp_con = 50,base_attr = [{1,485},{2,9700},{7,121},{8,121}],extra_attr = []};

get_baby_stage(2,2,2) ->
	#base_baby_stage{type = 2,stage = 2,level = 2,exp_con = 55,base_attr = [{1,540},{2,10800},{7,135},{8,135}],extra_attr = []};

get_baby_stage(2,2,3) ->
	#base_baby_stage{type = 2,stage = 2,level = 3,exp_con = 61,base_attr = [{1,600},{2,12000},{7,150},{8,150}],extra_attr = []};

get_baby_stage(2,2,4) ->
	#base_baby_stage{type = 2,stage = 2,level = 4,exp_con = 67,base_attr = [{1,660},{2,13200},{7,165},{8,165}],extra_attr = []};

get_baby_stage(2,2,5) ->
	#base_baby_stage{type = 2,stage = 2,level = 5,exp_con = 73,base_attr = [{1,725},{2,14500},{7,181},{8,181}],extra_attr = []};

get_baby_stage(2,2,6) ->
	#base_baby_stage{type = 2,stage = 2,level = 6,exp_con = 79,base_attr = [{1,795},{2,15900},{7,199},{8,199}],extra_attr = []};

get_baby_stage(2,2,7) ->
	#base_baby_stage{type = 2,stage = 2,level = 7,exp_con = 86,base_attr = [{1,865},{2,17300},{7,216},{8,216}],extra_attr = []};

get_baby_stage(2,2,8) ->
	#base_baby_stage{type = 2,stage = 2,level = 8,exp_con = 93,base_attr = [{1,940},{2,18800},{7,235},{8,235}],extra_attr = []};

get_baby_stage(2,2,9) ->
	#base_baby_stage{type = 2,stage = 2,level = 9,exp_con = 101,base_attr = [{1,1015},{2,20300},{7,254},{8,254}],extra_attr = []};

get_baby_stage(2,2,10) ->
	#base_baby_stage{type = 2,stage = 2,level = 10,exp_con = 109,base_attr = [{1,1095},{2,21900},{7,274},{8,274}],extra_attr = []};

get_baby_stage(2,3,1) ->
	#base_baby_stage{type = 2,stage = 3,level = 1,exp_con = 118,base_attr = [{1,1180},{2,23600},{7,295},{8,295}],extra_attr = []};

get_baby_stage(2,3,2) ->
	#base_baby_stage{type = 2,stage = 3,level = 2,exp_con = 128,base_attr = [{1,1265},{2,25300},{7,316},{8,316}],extra_attr = []};

get_baby_stage(2,3,3) ->
	#base_baby_stage{type = 2,stage = 3,level = 3,exp_con = 139,base_attr = [{1,1355},{2,27100},{7,339},{8,339}],extra_attr = []};

get_baby_stage(2,3,4) ->
	#base_baby_stage{type = 2,stage = 3,level = 4,exp_con = 151,base_attr = [{1,1450},{2,29000},{7,363},{8,363}],extra_attr = []};

get_baby_stage(2,3,5) ->
	#base_baby_stage{type = 2,stage = 3,level = 5,exp_con = 164,base_attr = [{1,1545},{2,30900},{7,386},{8,386}],extra_attr = []};

get_baby_stage(2,3,6) ->
	#base_baby_stage{type = 2,stage = 3,level = 6,exp_con = 178,base_attr = [{1,1645},{2,32900},{7,411},{8,411}],extra_attr = []};

get_baby_stage(2,3,7) ->
	#base_baby_stage{type = 2,stage = 3,level = 7,exp_con = 193,base_attr = [{1,1750},{2,35000},{7,438},{8,438}],extra_attr = []};

get_baby_stage(2,3,8) ->
	#base_baby_stage{type = 2,stage = 3,level = 8,exp_con = 209,base_attr = [{1,1855},{2,37100},{7,464},{8,464}],extra_attr = []};

get_baby_stage(2,3,9) ->
	#base_baby_stage{type = 2,stage = 3,level = 9,exp_con = 226,base_attr = [{1,1965},{2,39300},{7,491},{8,491}],extra_attr = []};

get_baby_stage(2,3,10) ->
	#base_baby_stage{type = 2,stage = 3,level = 10,exp_con = 400,base_attr = [{1,2080},{2,41600},{7,520},{8,520}],extra_attr = []};

get_baby_stage(2,4,1) ->
	#base_baby_stage{type = 2,stage = 4,level = 1,exp_con = 425,base_attr = [{1,2195},{2,43900},{7,549},{8,549}],extra_attr = []};

get_baby_stage(2,4,2) ->
	#base_baby_stage{type = 2,stage = 4,level = 2,exp_con = 452,base_attr = [{1,2315},{2,46300},{7,579},{8,579}],extra_attr = []};

get_baby_stage(2,4,3) ->
	#base_baby_stage{type = 2,stage = 4,level = 3,exp_con = 480,base_attr = [{1,2440},{2,48800},{7,610},{8,610}],extra_attr = []};

get_baby_stage(2,4,4) ->
	#base_baby_stage{type = 2,stage = 4,level = 4,exp_con = 510,base_attr = [{1,2565},{2,51300},{7,641},{8,641}],extra_attr = []};

get_baby_stage(2,4,5) ->
	#base_baby_stage{type = 2,stage = 4,level = 5,exp_con = 542,base_attr = [{1,2695},{2,53900},{7,674},{8,674}],extra_attr = []};

get_baby_stage(2,4,6) ->
	#base_baby_stage{type = 2,stage = 4,level = 6,exp_con = 576,base_attr = [{1,2830},{2,56600},{7,708},{8,708}],extra_attr = []};

get_baby_stage(2,4,7) ->
	#base_baby_stage{type = 2,stage = 4,level = 7,exp_con = 612,base_attr = [{1,2965},{2,59300},{7,741},{8,741}],extra_attr = []};

get_baby_stage(2,4,8) ->
	#base_baby_stage{type = 2,stage = 4,level = 8,exp_con = 650,base_attr = [{1,3105},{2,62100},{7,776},{8,776}],extra_attr = []};

get_baby_stage(2,4,9) ->
	#base_baby_stage{type = 2,stage = 4,level = 9,exp_con = 691,base_attr = [{1,3250},{2,65000},{7,813},{8,813}],extra_attr = []};

get_baby_stage(2,4,10) ->
	#base_baby_stage{type = 2,stage = 4,level = 10,exp_con = 734,base_attr = [{1,3395},{2,67900},{7,849},{8,849}],extra_attr = []};

get_baby_stage(2,5,1) ->
	#base_baby_stage{type = 2,stage = 5,level = 1,exp_con = 780,base_attr = [{1,3545},{2,70900},{7,886},{8,886}],extra_attr = []};

get_baby_stage(2,5,2) ->
	#base_baby_stage{type = 2,stage = 5,level = 2,exp_con = 829,base_attr = [{1,3700},{2,74000},{7,925},{8,925}],extra_attr = []};

get_baby_stage(2,5,3) ->
	#base_baby_stage{type = 2,stage = 5,level = 3,exp_con = 881,base_attr = [{1,3855},{2,77100},{7,964},{8,964}],extra_attr = []};

get_baby_stage(2,5,4) ->
	#base_baby_stage{type = 2,stage = 5,level = 4,exp_con = 936,base_attr = [{1,4015},{2,80300},{7,1004},{8,1004}],extra_attr = []};

get_baby_stage(2,5,5) ->
	#base_baby_stage{type = 2,stage = 5,level = 5,exp_con = 995,base_attr = [{1,4180},{2,83600},{7,1045},{8,1045}],extra_attr = []};

get_baby_stage(2,5,6) ->
	#base_baby_stage{type = 2,stage = 5,level = 6,exp_con = 1057,base_attr = [{1,4350},{2,87000},{7,1088},{8,1088}],extra_attr = []};

get_baby_stage(2,5,7) ->
	#base_baby_stage{type = 2,stage = 5,level = 7,exp_con = 1123,base_attr = [{1,4520},{2,90400},{7,1130},{8,1130}],extra_attr = []};

get_baby_stage(2,5,8) ->
	#base_baby_stage{type = 2,stage = 5,level = 8,exp_con = 1193,base_attr = [{1,4695},{2,93900},{7,1174},{8,1174}],extra_attr = []};

get_baby_stage(2,5,9) ->
	#base_baby_stage{type = 2,stage = 5,level = 9,exp_con = 1268,base_attr = [{1,4870},{2,97400},{7,1218},{8,1218}],extra_attr = []};

get_baby_stage(2,5,10) ->
	#base_baby_stage{type = 2,stage = 5,level = 10,exp_con = 1347,base_attr = [{1,5050},{2,101000},{7,1263},{8,1263}],extra_attr = []};

get_baby_stage(2,6,1) ->
	#base_baby_stage{type = 2,stage = 6,level = 1,exp_con = 1431,base_attr = [{1,5235},{2,104700},{7,1309},{8,1309}],extra_attr = []};

get_baby_stage(2,6,2) ->
	#base_baby_stage{type = 2,stage = 6,level = 2,exp_con = 1520,base_attr = [{1,5425},{2,108500},{7,1356},{8,1356}],extra_attr = []};

get_baby_stage(2,6,3) ->
	#base_baby_stage{type = 2,stage = 6,level = 3,exp_con = 1615,base_attr = [{1,5615},{2,112300},{7,1404},{8,1404}],extra_attr = []};

get_baby_stage(2,6,4) ->
	#base_baby_stage{type = 2,stage = 6,level = 4,exp_con = 1716,base_attr = [{1,5810},{2,116200},{7,1453},{8,1453}],extra_attr = []};

get_baby_stage(2,6,5) ->
	#base_baby_stage{type = 2,stage = 6,level = 5,exp_con = 1823,base_attr = [{1,6010},{2,120200},{7,1503},{8,1503}],extra_attr = []};

get_baby_stage(2,6,6) ->
	#base_baby_stage{type = 2,stage = 6,level = 6,exp_con = 1937,base_attr = [{1,6210},{2,124200},{7,1553},{8,1553}],extra_attr = []};

get_baby_stage(2,6,7) ->
	#base_baby_stage{type = 2,stage = 6,level = 7,exp_con = 2058,base_attr = [{1,6415},{2,128300},{7,1604},{8,1604}],extra_attr = []};

get_baby_stage(2,6,8) ->
	#base_baby_stage{type = 2,stage = 6,level = 8,exp_con = 2187,base_attr = [{1,6625},{2,132500},{7,1656},{8,1656}],extra_attr = []};

get_baby_stage(2,6,9) ->
	#base_baby_stage{type = 2,stage = 6,level = 9,exp_con = 2324,base_attr = [{1,6840},{2,136800},{7,1710},{8,1710}],extra_attr = []};

get_baby_stage(2,6,10) ->
	#base_baby_stage{type = 2,stage = 6,level = 10,exp_con = 2469,base_attr = [{1,7055},{2,141100},{7,1764},{8,1764}],extra_attr = []};

get_baby_stage(2,7,1) ->
	#base_baby_stage{type = 2,stage = 7,level = 1,exp_con = 2623,base_attr = [{1,7275},{2,145500},{7,1819},{8,1819}],extra_attr = []};

get_baby_stage(2,7,2) ->
	#base_baby_stage{type = 2,stage = 7,level = 2,exp_con = 2787,base_attr = [{1,7495},{2,149900},{7,1874},{8,1874}],extra_attr = []};

get_baby_stage(2,7,3) ->
	#base_baby_stage{type = 2,stage = 7,level = 3,exp_con = 2961,base_attr = [{1,7725},{2,154500},{7,1931},{8,1931}],extra_attr = []};

get_baby_stage(2,7,4) ->
	#base_baby_stage{type = 2,stage = 7,level = 4,exp_con = 3146,base_attr = [{1,7955},{2,159100},{7,1989},{8,1989}],extra_attr = []};

get_baby_stage(2,7,5) ->
	#base_baby_stage{type = 2,stage = 7,level = 5,exp_con = 3343,base_attr = [{1,8185},{2,163700},{7,2046},{8,2046}],extra_attr = []};

get_baby_stage(2,7,6) ->
	#base_baby_stage{type = 2,stage = 7,level = 6,exp_con = 3552,base_attr = [{1,8425},{2,168500},{7,2106},{8,2106}],extra_attr = []};

get_baby_stage(2,7,7) ->
	#base_baby_stage{type = 2,stage = 7,level = 7,exp_con = 3774,base_attr = [{1,8665},{2,173300},{7,2166},{8,2166}],extra_attr = []};

get_baby_stage(2,7,8) ->
	#base_baby_stage{type = 2,stage = 7,level = 8,exp_con = 4010,base_attr = [{1,8910},{2,178200},{7,2228},{8,2228}],extra_attr = []};

get_baby_stage(2,7,9) ->
	#base_baby_stage{type = 2,stage = 7,level = 9,exp_con = 4261,base_attr = [{1,9155},{2,183100},{7,2289},{8,2289}],extra_attr = []};

get_baby_stage(2,7,10) ->
	#base_baby_stage{type = 2,stage = 7,level = 10,exp_con = 4527,base_attr = [{1,9410},{2,188200},{7,2353},{8,2353}],extra_attr = []};

get_baby_stage(2,8,1) ->
	#base_baby_stage{type = 2,stage = 8,level = 1,exp_con = 4810,base_attr = [{1,9665},{2,193300},{7,2416},{8,2416}],extra_attr = []};

get_baby_stage(2,8,2) ->
	#base_baby_stage{type = 2,stage = 8,level = 2,exp_con = 5111,base_attr = [{1,9920},{2,198400},{7,2480},{8,2480}],extra_attr = []};

get_baby_stage(2,8,3) ->
	#base_baby_stage{type = 2,stage = 8,level = 3,exp_con = 5430,base_attr = [{1,10185},{2,203700},{7,2546},{8,2546}],extra_attr = []};

get_baby_stage(2,8,4) ->
	#base_baby_stage{type = 2,stage = 8,level = 4,exp_con = 5769,base_attr = [{1,10450},{2,209000},{7,2613},{8,2613}],extra_attr = []};

get_baby_stage(2,8,5) ->
	#base_baby_stage{type = 2,stage = 8,level = 5,exp_con = 6130,base_attr = [{1,10720},{2,214400},{7,2680},{8,2680}],extra_attr = []};

get_baby_stage(2,8,6) ->
	#base_baby_stage{type = 2,stage = 8,level = 6,exp_con = 6513,base_attr = [{1,10990},{2,219800},{7,2748},{8,2748}],extra_attr = []};

get_baby_stage(2,8,7) ->
	#base_baby_stage{type = 2,stage = 8,level = 7,exp_con = 6920,base_attr = [{1,11270},{2,225400},{7,2818},{8,2818}],extra_attr = []};

get_baby_stage(2,8,8) ->
	#base_baby_stage{type = 2,stage = 8,level = 8,exp_con = 7353,base_attr = [{1,11550},{2,231000},{7,2888},{8,2888}],extra_attr = []};

get_baby_stage(2,8,9) ->
	#base_baby_stage{type = 2,stage = 8,level = 9,exp_con = 7813,base_attr = [{1,11835},{2,236700},{7,2959},{8,2959}],extra_attr = []};

get_baby_stage(2,8,10) ->
	#base_baby_stage{type = 2,stage = 8,level = 10,exp_con = 8301,base_attr = [{1,12120},{2,242400},{7,3030},{8,3030}],extra_attr = []};

get_baby_stage(2,9,1) ->
	#base_baby_stage{type = 2,stage = 9,level = 1,exp_con = 8820,base_attr = [{1,12410},{2,248200},{7,3103},{8,3103}],extra_attr = []};

get_baby_stage(2,9,2) ->
	#base_baby_stage{type = 2,stage = 9,level = 2,exp_con = 9371,base_attr = [{1,12705},{2,254100},{7,3176},{8,3176}],extra_attr = []};

get_baby_stage(2,9,3) ->
	#base_baby_stage{type = 2,stage = 9,level = 3,exp_con = 9957,base_attr = [{1,13005},{2,260100},{7,3251},{8,3251}],extra_attr = []};

get_baby_stage(2,9,4) ->
	#base_baby_stage{type = 2,stage = 9,level = 4,exp_con = 10579,base_attr = [{1,13305},{2,266100},{7,3326},{8,3326}],extra_attr = []};

get_baby_stage(2,9,5) ->
	#base_baby_stage{type = 2,stage = 9,level = 5,exp_con = 11240,base_attr = [{1,13610},{2,272200},{7,3403},{8,3403}],extra_attr = []};

get_baby_stage(2,9,6) ->
	#base_baby_stage{type = 2,stage = 9,level = 6,exp_con = 11943,base_attr = [{1,13920},{2,278400},{7,3480},{8,3480}],extra_attr = []};

get_baby_stage(2,9,7) ->
	#base_baby_stage{type = 2,stage = 9,level = 7,exp_con = 12689,base_attr = [{1,14235},{2,284700},{7,3559},{8,3559}],extra_attr = []};

get_baby_stage(2,9,8) ->
	#base_baby_stage{type = 2,stage = 9,level = 8,exp_con = 13482,base_attr = [{1,14550},{2,291000},{7,3638},{8,3638}],extra_attr = []};

get_baby_stage(2,9,9) ->
	#base_baby_stage{type = 2,stage = 9,level = 9,exp_con = 14325,base_attr = [{1,14870},{2,297400},{7,3718},{8,3718}],extra_attr = []};

get_baby_stage(2,9,10) ->
	#base_baby_stage{type = 2,stage = 9,level = 10,exp_con = 15220,base_attr = [{1,15195},{2,303900},{7,3799},{8,3799}],extra_attr = []};

get_baby_stage(2,10,1) ->
	#base_baby_stage{type = 2,stage = 10,level = 1,exp_con = 16171,base_attr = [{1,15520},{2,310400},{7,3880},{8,3880}],extra_attr = []};

get_baby_stage(2,10,2) ->
	#base_baby_stage{type = 2,stage = 10,level = 2,exp_con = 17182,base_attr = [{1,15850},{2,317000},{7,3963},{8,3963}],extra_attr = []};

get_baby_stage(2,10,3) ->
	#base_baby_stage{type = 2,stage = 10,level = 3,exp_con = 18256,base_attr = [{1,16185},{2,323700},{7,4046},{8,4046}],extra_attr = []};

get_baby_stage(2,10,4) ->
	#base_baby_stage{type = 2,stage = 10,level = 4,exp_con = 19397,base_attr = [{1,16525},{2,330500},{7,4131},{8,4131}],extra_attr = []};

get_baby_stage(2,10,5) ->
	#base_baby_stage{type = 2,stage = 10,level = 5,exp_con = 20609,base_attr = [{1,16865},{2,337300},{7,4216},{8,4216}],extra_attr = []};

get_baby_stage(2,10,6) ->
	#base_baby_stage{type = 2,stage = 10,level = 6,exp_con = 21897,base_attr = [{1,17210},{2,344200},{7,4303},{8,4303}],extra_attr = []};

get_baby_stage(2,10,7) ->
	#base_baby_stage{type = 2,stage = 10,level = 7,exp_con = 23266,base_attr = [{1,17560},{2,351200},{7,4390},{8,4390}],extra_attr = []};

get_baby_stage(2,10,8) ->
	#base_baby_stage{type = 2,stage = 10,level = 8,exp_con = 24720,base_attr = [{1,17915},{2,358300},{7,4479},{8,4479}],extra_attr = []};

get_baby_stage(2,10,9) ->
	#base_baby_stage{type = 2,stage = 10,level = 9,exp_con = 26265,base_attr = [{1,18270},{2,365400},{7,4568},{8,4568}],extra_attr = []};

get_baby_stage(2,10,10) ->
	#base_baby_stage{type = 2,stage = 10,level = 10,exp_con = 27907,base_attr = [{1,18630},{2,372600},{7,4658},{8,4658}],extra_attr = []};

get_baby_stage(2,11,1) ->
	#base_baby_stage{type = 2,stage = 11,level = 1,exp_con = 29651,base_attr = [{1,18995},{2,379900},{7,4749},{8,4749}],extra_attr = []};

get_baby_stage(2,11,2) ->
	#base_baby_stage{type = 2,stage = 11,level = 2,exp_con = 31504,base_attr = [{1,19365},{2,387300},{7,4841},{8,4841}],extra_attr = []};

get_baby_stage(2,11,3) ->
	#base_baby_stage{type = 2,stage = 11,level = 3,exp_con = 33473,base_attr = [{1,19735},{2,394700},{7,4934},{8,4934}],extra_attr = []};

get_baby_stage(2,11,4) ->
	#base_baby_stage{type = 2,stage = 11,level = 4,exp_con = 35565,base_attr = [{1,20110},{2,402200},{7,5028},{8,5028}],extra_attr = []};

get_baby_stage(2,11,5) ->
	#base_baby_stage{type = 2,stage = 11,level = 5,exp_con = 37788,base_attr = [{1,20490},{2,409800},{7,5123},{8,5123}],extra_attr = []};

get_baby_stage(2,11,6) ->
	#base_baby_stage{type = 2,stage = 11,level = 6,exp_con = 40150,base_attr = [{1,20870},{2,417400},{7,5218},{8,5218}],extra_attr = []};

get_baby_stage(2,11,7) ->
	#base_baby_stage{type = 2,stage = 11,level = 7,exp_con = 42659,base_attr = [{1,21260},{2,425200},{7,5315},{8,5315}],extra_attr = []};

get_baby_stage(2,11,8) ->
	#base_baby_stage{type = 2,stage = 11,level = 8,exp_con = 45325,base_attr = [{1,21650},{2,433000},{7,5413},{8,5413}],extra_attr = []};

get_baby_stage(2,11,9) ->
	#base_baby_stage{type = 2,stage = 11,level = 9,exp_con = 48158,base_attr = [{1,22040},{2,440800},{7,5510},{8,5510}],extra_attr = []};

get_baby_stage(2,11,10) ->
	#base_baby_stage{type = 2,stage = 11,level = 10,exp_con = 51168,base_attr = [{1,22440},{2,448800},{7,5610},{8,5610}],extra_attr = []};

get_baby_stage(2,12,1) ->
	#base_baby_stage{type = 2,stage = 12,level = 1,exp_con = 54366,base_attr = [{1,22840},{2,456800},{7,5710},{8,5710}],extra_attr = []};

get_baby_stage(2,12,2) ->
	#base_baby_stage{type = 2,stage = 12,level = 2,exp_con = 57764,base_attr = [{1,23245},{2,464900},{7,5811},{8,5811}],extra_attr = []};

get_baby_stage(2,12,3) ->
	#base_baby_stage{type = 2,stage = 12,level = 3,exp_con = 61374,base_attr = [{1,23655},{2,473100},{7,5914},{8,5914}],extra_attr = []};

get_baby_stage(2,12,4) ->
	#base_baby_stage{type = 2,stage = 12,level = 4,exp_con = 65210,base_attr = [{1,24065},{2,481300},{7,6016},{8,6016}],extra_attr = []};

get_baby_stage(2,12,5) ->
	#base_baby_stage{type = 2,stage = 12,level = 5,exp_con = 69286,base_attr = [{1,24480},{2,489600},{7,6120},{8,6120}],extra_attr = []};

get_baby_stage(2,12,6) ->
	#base_baby_stage{type = 2,stage = 12,level = 6,exp_con = 73616,base_attr = [{1,24900},{2,498000},{7,6225},{8,6225}],extra_attr = []};

get_baby_stage(2,12,7) ->
	#base_baby_stage{type = 2,stage = 12,level = 7,exp_con = 78217,base_attr = [{1,25325},{2,506500},{7,6331},{8,6331}],extra_attr = []};

get_baby_stage(2,12,8) ->
	#base_baby_stage{type = 2,stage = 12,level = 8,exp_con = 83106,base_attr = [{1,25755},{2,515100},{7,6439},{8,6439}],extra_attr = []};

get_baby_stage(2,12,9) ->
	#base_baby_stage{type = 2,stage = 12,level = 9,exp_con = 88300,base_attr = [{1,26185},{2,523700},{7,6546},{8,6546}],extra_attr = []};

get_baby_stage(2,12,10) ->
	#base_baby_stage{type = 2,stage = 12,level = 10,exp_con = 93819,base_attr = [{1,26620},{2,532400},{7,6655},{8,6655}],extra_attr = []};

get_baby_stage(_Type,_Stage,_Level) ->
	[].

get_baby_figure(1) ->
	#base_baby_figure{baby_id = 1,baby_name_con = "甜心萌娃",active_stage = 0,cost = [{0,68010001,30}],power = 84500};

get_baby_figure(2) ->
	#base_baby_figure{baby_id = 2,baby_name_con = "可爱奇奇",active_stage = 0,cost = [{0,68010002,30}],power = 112500};

get_baby_figure(3) ->
	#base_baby_figure{baby_id = 3,baby_name_con = "少女甜心",active_stage = 0,cost = [{0,68010003,30}],power = 132200};

get_baby_figure(4) ->
	#base_baby_figure{baby_id = 4,baby_name_con = "学院少年",active_stage = 0,cost = [{0,68010004,30}],power = 140700};

get_baby_figure(5) ->
	#base_baby_figure{baby_id = 5,baby_name_con = "甜梦公主",active_stage = 0,cost = [{0,68010005,30}],power = 150000};

get_baby_figure(6) ->
	#base_baby_figure{baby_id = 6,baby_name_con = "虎头萌娃",active_stage = 0,cost = [{0,68010006,30}],power = 246000};

get_baby_figure(7) ->
	#base_baby_figure{baby_id = 7,baby_name_con = "庆典少女",active_stage = 0,cost = [{0,68010007,30}],power = 362000};

get_baby_figure(8) ->
	#base_baby_figure{baby_id = 8,baby_name_con = "天才少年",active_stage = 0,cost = [{0,68010008,30}],power = 370000};

get_baby_figure(9) ->
	#base_baby_figure{baby_id = 9,baby_name_con = "清凉苏苏",active_stage = 0,cost = [{0,68010009,30}],power = 378000};

get_baby_figure(_Babyid) ->
	[].

get_baby_figure_star(1,1) ->
	#base_baby_figure_star{baby_id = 1,star = 1,cost = [],base_attr = [{2,60000},{4,1500},{5,750},{24,200}],power = 0};

get_baby_figure_star(1,2) ->
	#base_baby_figure_star{baby_id = 1,star = 2,cost = [{0,68010001,25}],base_attr = [{2,90000},{4,2250},{5,1125},{24,250}],power = 0};

get_baby_figure_star(1,3) ->
	#base_baby_figure_star{baby_id = 1,star = 3,cost = [{0,68010001,30}],base_attr = [{2,120000},{4,3000},{5,1500},{24,300}],power = 0};

get_baby_figure_star(1,4) ->
	#base_baby_figure_star{baby_id = 1,star = 4,cost = [{0,68010001,40}],base_attr = [{2,150000},{4,3750},{5,1875},{24,350}],power = 0};

get_baby_figure_star(1,5) ->
	#base_baby_figure_star{baby_id = 1,star = 5,cost = [{0,68010001,45}],base_attr = [{2,180000},{4,4500},{5,2250},{24,400}],power = 0};

get_baby_figure_star(1,6) ->
	#base_baby_figure_star{baby_id = 1,star = 6,cost = [{0,68010001,50}],base_attr = [{2,210000},{4,5250},{5,2625},{24,450}],power = 0};

get_baby_figure_star(1,7) ->
	#base_baby_figure_star{baby_id = 1,star = 7,cost = [{0,68010001,60}],base_attr = [{2,240000},{4,6000},{5,3000},{24,500}],power = 0};

get_baby_figure_star(1,8) ->
	#base_baby_figure_star{baby_id = 1,star = 8,cost = [{0,68010001,70}],base_attr = [{2,270000},{4,6750},{5,3375},{24,550}],power = 0};

get_baby_figure_star(1,9) ->
	#base_baby_figure_star{baby_id = 1,star = 9,cost = [{0,68010001,80}],base_attr = [{2,300000},{4,7500},{5,3750},{24,600}],power = 0};

get_baby_figure_star(1,10) ->
	#base_baby_figure_star{baby_id = 1,star = 10,cost = [{0,68010001,100}],base_attr = [{2,330000},{4,8250},{5,4125},{24,650}],power = 0};

get_baby_figure_star(1,11) ->
	#base_baby_figure_star{baby_id = 1,star = 11,cost = [{0,68010001,150}],base_attr = [{2,360000},{4,9000},{5,4500},{24,700}],power = 0};

get_baby_figure_star(1,12) ->
	#base_baby_figure_star{baby_id = 1,star = 12,cost = [{0,68010001,200}],base_attr = [{2,390000},{4,9750},{5,4875},{24,750}],power = 0};

get_baby_figure_star(1,13) ->
	#base_baby_figure_star{baby_id = 1,star = 13,cost = [{0,68010001,250}],base_attr = [{2,420000},{4,10500},{5,5250},{24,800}],power = 0};

get_baby_figure_star(1,14) ->
	#base_baby_figure_star{baby_id = 1,star = 14,cost = [{0,68010001,300}],base_attr = [{2,450000},{4,11250},{5,5625},{24,850}],power = 0};

get_baby_figure_star(1,15) ->
	#base_baby_figure_star{baby_id = 1,star = 15,cost = [{0,68010001,350}],base_attr = [{2,480000},{4,12000},{5,6000},{24,900}],power = 0};

get_baby_figure_star(2,1) ->
	#base_baby_figure_star{baby_id = 2,star = 1,cost = [],base_attr = [{2,65000},{4,1600},{5,800},{26,200}],power = 0};

get_baby_figure_star(2,2) ->
	#base_baby_figure_star{baby_id = 2,star = 2,cost = [{0,68010002,25}],base_attr = [{2,97500},{4,2400},{5,1200},{26,250}],power = 0};

get_baby_figure_star(2,3) ->
	#base_baby_figure_star{baby_id = 2,star = 3,cost = [{0,68010002,30}],base_attr = [{2,130000},{4,3200},{5,1600},{26,300}],power = 0};

get_baby_figure_star(2,4) ->
	#base_baby_figure_star{baby_id = 2,star = 4,cost = [{0,68010002,40}],base_attr = [{2,162500},{4,4000},{5,2000},{26,350}],power = 0};

get_baby_figure_star(2,5) ->
	#base_baby_figure_star{baby_id = 2,star = 5,cost = [{0,68010002,45}],base_attr = [{2,195000},{4,4800},{5,2400},{26,400}],power = 0};

get_baby_figure_star(2,6) ->
	#base_baby_figure_star{baby_id = 2,star = 6,cost = [{0,68010002,50}],base_attr = [{2,227500},{4,5600},{5,2800},{26,450}],power = 0};

get_baby_figure_star(2,7) ->
	#base_baby_figure_star{baby_id = 2,star = 7,cost = [{0,68010002,60}],base_attr = [{2,260000},{4,6400},{5,3200},{26,500}],power = 0};

get_baby_figure_star(2,8) ->
	#base_baby_figure_star{baby_id = 2,star = 8,cost = [{0,68010002,70}],base_attr = [{2,292500},{4,7200},{5,3600},{26,550}],power = 0};

get_baby_figure_star(2,9) ->
	#base_baby_figure_star{baby_id = 2,star = 9,cost = [{0,68010002,80}],base_attr = [{2,325000},{4,8000},{5,4000},{26,600}],power = 0};

get_baby_figure_star(2,10) ->
	#base_baby_figure_star{baby_id = 2,star = 10,cost = [{0,68010002,100}],base_attr = [{2,357500},{4,8800},{5,4400},{26,650}],power = 0};

get_baby_figure_star(2,11) ->
	#base_baby_figure_star{baby_id = 2,star = 11,cost = [{0,68010002,150}],base_attr = [{2,390000},{4,9600},{5,4800},{26,700}],power = 0};

get_baby_figure_star(2,12) ->
	#base_baby_figure_star{baby_id = 2,star = 12,cost = [{0,68010002,200}],base_attr = [{2,422500},{4,10400},{5,5200},{26,750}],power = 0};

get_baby_figure_star(2,13) ->
	#base_baby_figure_star{baby_id = 2,star = 13,cost = [{0,68010002,250}],base_attr = [{2,455000},{4,11200},{5,5600},{26,800}],power = 0};

get_baby_figure_star(2,14) ->
	#base_baby_figure_star{baby_id = 2,star = 14,cost = [{0,68010002,300}],base_attr = [{2,487500},{4,12000},{5,6000},{26,850}],power = 0};

get_baby_figure_star(2,15) ->
	#base_baby_figure_star{baby_id = 2,star = 15,cost = [{0,68010002,350}],base_attr = [{2,520000},{4,12800},{5,6400},{26,900}],power = 0};

get_baby_figure_star(3,1) ->
	#base_baby_figure_star{baby_id = 3,star = 1,cost = [],base_attr = [{2,70000},{4,2000},{8,1000},{23,240}],power = 0};

get_baby_figure_star(3,2) ->
	#base_baby_figure_star{baby_id = 3,star = 2,cost = [{0,68010003,25}],base_attr = [{2,105000},{4,3000},{8,1500},{23,300}],power = 0};

get_baby_figure_star(3,3) ->
	#base_baby_figure_star{baby_id = 3,star = 3,cost = [{0,68010003,30}],base_attr = [{2,140000},{4,4000},{8,2000},{23,360}],power = 0};

get_baby_figure_star(3,4) ->
	#base_baby_figure_star{baby_id = 3,star = 4,cost = [{0,68010003,40}],base_attr = [{2,175000},{4,5000},{8,2500},{23,420}],power = 0};

get_baby_figure_star(3,5) ->
	#base_baby_figure_star{baby_id = 3,star = 5,cost = [{0,68010003,45}],base_attr = [{2,210000},{4,6000},{8,3000},{23,480}],power = 0};

get_baby_figure_star(3,6) ->
	#base_baby_figure_star{baby_id = 3,star = 6,cost = [{0,68010003,50}],base_attr = [{2,245000},{4,7000},{8,3500},{23,540}],power = 0};

get_baby_figure_star(3,7) ->
	#base_baby_figure_star{baby_id = 3,star = 7,cost = [{0,68010003,60}],base_attr = [{2,280000},{4,8000},{8,4000},{23,600}],power = 0};

get_baby_figure_star(3,8) ->
	#base_baby_figure_star{baby_id = 3,star = 8,cost = [{0,68010003,70}],base_attr = [{2,315000},{4,9000},{8,4500},{23,660}],power = 0};

get_baby_figure_star(3,9) ->
	#base_baby_figure_star{baby_id = 3,star = 9,cost = [{0,68010003,80}],base_attr = [{2,350000},{4,10000},{8,5000},{23,720}],power = 0};

get_baby_figure_star(3,10) ->
	#base_baby_figure_star{baby_id = 3,star = 10,cost = [{0,68010003,100}],base_attr = [{2,385000},{4,11000},{8,5500},{23,780}],power = 0};

get_baby_figure_star(3,11) ->
	#base_baby_figure_star{baby_id = 3,star = 11,cost = [{0,68010003,150}],base_attr = [{2,420000},{4,12000},{8,6000},{23,840}],power = 0};

get_baby_figure_star(3,12) ->
	#base_baby_figure_star{baby_id = 3,star = 12,cost = [{0,68010003,200}],base_attr = [{2,455000},{4,13000},{8,6500},{23,900}],power = 0};

get_baby_figure_star(3,13) ->
	#base_baby_figure_star{baby_id = 3,star = 13,cost = [{0,68010003,250}],base_attr = [{2,490000},{4,14000},{8,7000},{23,960}],power = 0};

get_baby_figure_star(3,14) ->
	#base_baby_figure_star{baby_id = 3,star = 14,cost = [{0,68010003,300}],base_attr = [{2,525000},{4,15000},{8,7500},{23,1020}],power = 0};

get_baby_figure_star(3,15) ->
	#base_baby_figure_star{baby_id = 3,star = 15,cost = [{0,68010003,350}],base_attr = [{2,560000},{4,16000},{8,8000},{23,1080}],power = 0};

get_baby_figure_star(4,1) ->
	#base_baby_figure_star{baby_id = 4,star = 1,cost = [],base_attr = [{1,4200},{3,2100},{7,1050},{25,240}],power = 0};

get_baby_figure_star(4,2) ->
	#base_baby_figure_star{baby_id = 4,star = 2,cost = [{0,68010004,25}],base_attr = [{1,6300},{3,3150},{7,1575},{25,300}],power = 0};

get_baby_figure_star(4,3) ->
	#base_baby_figure_star{baby_id = 4,star = 3,cost = [{0,68010004,30}],base_attr = [{1,8400},{3,4200},{7,2100},{25,360}],power = 0};

get_baby_figure_star(4,4) ->
	#base_baby_figure_star{baby_id = 4,star = 4,cost = [{0,68010004,40}],base_attr = [{1,10500},{3,5250},{7,2625},{25,420}],power = 0};

get_baby_figure_star(4,5) ->
	#base_baby_figure_star{baby_id = 4,star = 5,cost = [{0,68010004,45}],base_attr = [{1,12600},{3,6300},{7,3150},{25,480}],power = 0};

get_baby_figure_star(4,6) ->
	#base_baby_figure_star{baby_id = 4,star = 6,cost = [{0,68010004,50}],base_attr = [{1,14700},{3,7350},{7,3675},{25,540}],power = 0};

get_baby_figure_star(4,7) ->
	#base_baby_figure_star{baby_id = 4,star = 7,cost = [{0,68010004,60}],base_attr = [{1,16800},{3,8400},{7,4200},{25,600}],power = 0};

get_baby_figure_star(4,8) ->
	#base_baby_figure_star{baby_id = 4,star = 8,cost = [{0,68010004,70}],base_attr = [{1,18900},{3,9450},{7,4725},{25,660}],power = 0};

get_baby_figure_star(4,9) ->
	#base_baby_figure_star{baby_id = 4,star = 9,cost = [{0,68010004,80}],base_attr = [{1,21000},{3,10500},{7,5250},{25,720}],power = 0};

get_baby_figure_star(4,10) ->
	#base_baby_figure_star{baby_id = 4,star = 10,cost = [{0,68010004,100}],base_attr = [{1,23100},{3,11550},{7,5775},{25,780}],power = 0};

get_baby_figure_star(4,11) ->
	#base_baby_figure_star{baby_id = 4,star = 11,cost = [{0,68010004,150}],base_attr = [{1,25200},{3,12600},{7,6300},{25,840}],power = 0};

get_baby_figure_star(4,12) ->
	#base_baby_figure_star{baby_id = 4,star = 12,cost = [{0,68010004,200}],base_attr = [{1,27300},{3,13650},{7,6825},{25,900}],power = 0};

get_baby_figure_star(4,13) ->
	#base_baby_figure_star{baby_id = 4,star = 13,cost = [{0,68010004,250}],base_attr = [{1,29400},{3,14700},{7,7350},{25,960}],power = 0};

get_baby_figure_star(4,14) ->
	#base_baby_figure_star{baby_id = 4,star = 14,cost = [{0,68010004,300}],base_attr = [{1,31500},{3,15750},{7,7875},{25,1020}],power = 0};

get_baby_figure_star(4,15) ->
	#base_baby_figure_star{baby_id = 4,star = 15,cost = [{0,68010004,350}],base_attr = [{1,33600},{3,16800},{7,8400},{25,1080}],power = 0};

get_baby_figure_star(5,1) ->
	#base_baby_figure_star{baby_id = 5,star = 1,cost = [],base_attr = [{2,80000},{4,2000},{5,1000},{7,1000},{22,100}],power = 0};

get_baby_figure_star(5,2) ->
	#base_baby_figure_star{baby_id = 5,star = 2,cost = [{0,68010005,25}],base_attr = [{2,120000},{4,3000},{5,1500},{7,1500},{22,125}],power = 0};

get_baby_figure_star(5,3) ->
	#base_baby_figure_star{baby_id = 5,star = 3,cost = [{0,68010005,30}],base_attr = [{2,160000},{4,4000},{5,2000},{7,2000},{22,150}],power = 0};

get_baby_figure_star(5,4) ->
	#base_baby_figure_star{baby_id = 5,star = 4,cost = [{0,68010005,40}],base_attr = [{2,200000},{4,5000},{5,2500},{7,2500},{22,175}],power = 0};

get_baby_figure_star(5,5) ->
	#base_baby_figure_star{baby_id = 5,star = 5,cost = [{0,68010005,45}],base_attr = [{2,240000},{4,6000},{5,3000},{7,3000},{22,200}],power = 0};

get_baby_figure_star(5,6) ->
	#base_baby_figure_star{baby_id = 5,star = 6,cost = [{0,68010005,50}],base_attr = [{2,280000},{4,7000},{5,3500},{7,3500},{22,225}],power = 0};

get_baby_figure_star(5,7) ->
	#base_baby_figure_star{baby_id = 5,star = 7,cost = [{0,68010005,60}],base_attr = [{2,320000},{4,8000},{5,4000},{7,4000},{22,250}],power = 0};

get_baby_figure_star(5,8) ->
	#base_baby_figure_star{baby_id = 5,star = 8,cost = [{0,68010005,70}],base_attr = [{2,360000},{4,9000},{5,4500},{7,4500},{22,275}],power = 0};

get_baby_figure_star(5,9) ->
	#base_baby_figure_star{baby_id = 5,star = 9,cost = [{0,68010005,80}],base_attr = [{2,400000},{4,10000},{5,5000},{7,5000},{22,300}],power = 0};

get_baby_figure_star(5,10) ->
	#base_baby_figure_star{baby_id = 5,star = 10,cost = [{0,68010005,100}],base_attr = [{2,440000},{4,11000},{5,5500},{7,5500},{22,325}],power = 0};

get_baby_figure_star(5,11) ->
	#base_baby_figure_star{baby_id = 5,star = 11,cost = [{0,68010005,150}],base_attr = [{2,480000},{4,12000},{5,6000},{7,6000},{22,350}],power = 0};

get_baby_figure_star(5,12) ->
	#base_baby_figure_star{baby_id = 5,star = 12,cost = [{0,68010005,200}],base_attr = [{2,520000},{4,13000},{5,6500},{7,6500},{22,375}],power = 0};

get_baby_figure_star(5,13) ->
	#base_baby_figure_star{baby_id = 5,star = 13,cost = [{0,68010005,250}],base_attr = [{2,560000},{4,14000},{5,7000},{7,7000},{22,400}],power = 0};

get_baby_figure_star(5,14) ->
	#base_baby_figure_star{baby_id = 5,star = 14,cost = [{0,68010005,300}],base_attr = [{2,600000},{4,15000},{5,7500},{7,7500},{22,425}],power = 0};

get_baby_figure_star(5,15) ->
	#base_baby_figure_star{baby_id = 5,star = 15,cost = [{0,68010005,350}],base_attr = [{2,640000},{4,16000},{5,8000},{7,8000},{22,450}],power = 0};

get_baby_figure_star(6,1) ->
	#base_baby_figure_star{baby_id = 6,star = 1,cost = [],base_attr = [{1,6500},{3,3500},{6,1300},{8,1300},{21,100}],power = 0};

get_baby_figure_star(6,2) ->
	#base_baby_figure_star{baby_id = 6,star = 2,cost = [{0,68010006,25}],base_attr = [{1,9750},{3,5250},{6,1950},{8,1950},{21,125}],power = 0};

get_baby_figure_star(6,3) ->
	#base_baby_figure_star{baby_id = 6,star = 3,cost = [{0,68010006,30}],base_attr = [{1,13000},{3,7000},{6,2600},{8,2600},{21,150}],power = 0};

get_baby_figure_star(6,4) ->
	#base_baby_figure_star{baby_id = 6,star = 4,cost = [{0,68010006,40}],base_attr = [{1,16250},{3,8750},{6,3250},{8,3250},{21,175}],power = 0};

get_baby_figure_star(6,5) ->
	#base_baby_figure_star{baby_id = 6,star = 5,cost = [{0,68010006,45}],base_attr = [{1,19500},{3,10500},{6,3900},{8,3900},{21,200}],power = 0};

get_baby_figure_star(6,6) ->
	#base_baby_figure_star{baby_id = 6,star = 6,cost = [{0,68010006,50}],base_attr = [{1,22750},{3,12250},{6,4550},{8,4550},{21,225}],power = 0};

get_baby_figure_star(6,7) ->
	#base_baby_figure_star{baby_id = 6,star = 7,cost = [{0,68010006,60}],base_attr = [{1,26000},{3,14000},{6,5200},{8,5200},{21,250}],power = 0};

get_baby_figure_star(6,8) ->
	#base_baby_figure_star{baby_id = 6,star = 8,cost = [{0,68010006,70}],base_attr = [{1,29250},{3,15750},{6,5850},{8,5850},{21,275}],power = 0};

get_baby_figure_star(6,9) ->
	#base_baby_figure_star{baby_id = 6,star = 9,cost = [{0,68010006,80}],base_attr = [{1,32500},{3,17500},{6,6500},{8,6500},{21,300}],power = 0};

get_baby_figure_star(6,10) ->
	#base_baby_figure_star{baby_id = 6,star = 10,cost = [{0,68010006,100}],base_attr = [{1,35750},{3,19250},{6,7150},{8,7150},{21,325}],power = 0};

get_baby_figure_star(6,11) ->
	#base_baby_figure_star{baby_id = 6,star = 11,cost = [{0,68010006,150}],base_attr = [{1,39000},{3,21000},{6,7800},{8,7800},{21,350}],power = 0};

get_baby_figure_star(6,12) ->
	#base_baby_figure_star{baby_id = 6,star = 12,cost = [{0,68010006,200}],base_attr = [{1,42250},{3,22750},{6,8450},{8,8450},{21,375}],power = 0};

get_baby_figure_star(6,13) ->
	#base_baby_figure_star{baby_id = 6,star = 13,cost = [{0,68010006,250}],base_attr = [{1,45500},{3,24500},{6,9100},{8,9100},{21,400}],power = 0};

get_baby_figure_star(6,14) ->
	#base_baby_figure_star{baby_id = 6,star = 14,cost = [{0,68010006,300}],base_attr = [{1,48750},{3,26250},{6,9750},{8,9750},{21,425}],power = 0};

get_baby_figure_star(6,15) ->
	#base_baby_figure_star{baby_id = 6,star = 15,cost = [{0,68010006,350}],base_attr = [{1,52000},{3,28000},{6,10400},{8,10400},{21,450}],power = 0};

get_baby_figure_star(7,1) ->
	#base_baby_figure_star{baby_id = 7,star = 1,cost = [],base_attr = [{2,160000},{4,5000},{5,2000},{7,2000},{20,120}],power = 0};

get_baby_figure_star(7,2) ->
	#base_baby_figure_star{baby_id = 7,star = 2,cost = [{0,68010007,25}],base_attr = [{2,240000},{4,7500},{5,3000},{7,3000},{20,150}],power = 0};

get_baby_figure_star(7,3) ->
	#base_baby_figure_star{baby_id = 7,star = 3,cost = [{0,68010007,30}],base_attr = [{2,320000},{4,10000},{5,4000},{7,4000},{20,180}],power = 0};

get_baby_figure_star(7,4) ->
	#base_baby_figure_star{baby_id = 7,star = 4,cost = [{0,68010007,40}],base_attr = [{2,400000},{4,12500},{5,5000},{7,5000},{20,210}],power = 0};

get_baby_figure_star(7,5) ->
	#base_baby_figure_star{baby_id = 7,star = 5,cost = [{0,68010007,45}],base_attr = [{2,480000},{4,15000},{5,6000},{7,6000},{20,240}],power = 0};

get_baby_figure_star(7,6) ->
	#base_baby_figure_star{baby_id = 7,star = 6,cost = [{0,68010007,50}],base_attr = [{2,560000},{4,17500},{5,7000},{7,7000},{20,270}],power = 0};

get_baby_figure_star(7,7) ->
	#base_baby_figure_star{baby_id = 7,star = 7,cost = [{0,68010007,60}],base_attr = [{2,640000},{4,20000},{5,8000},{7,8000},{20,300}],power = 0};

get_baby_figure_star(7,8) ->
	#base_baby_figure_star{baby_id = 7,star = 8,cost = [{0,68010007,70}],base_attr = [{2,720000},{4,22500},{5,9000},{7,9000},{20,330}],power = 0};

get_baby_figure_star(7,9) ->
	#base_baby_figure_star{baby_id = 7,star = 9,cost = [{0,68010007,80}],base_attr = [{2,800000},{4,25000},{5,10000},{7,10000},{20,360}],power = 0};

get_baby_figure_star(7,10) ->
	#base_baby_figure_star{baby_id = 7,star = 10,cost = [{0,68010007,100}],base_attr = [{2,880000},{4,27500},{5,11000},{7,11000},{20,390}],power = 0};

get_baby_figure_star(7,11) ->
	#base_baby_figure_star{baby_id = 7,star = 11,cost = [{0,68010007,150}],base_attr = [{2,960000},{4,30000},{5,12000},{7,12000},{20,420}],power = 0};

get_baby_figure_star(7,12) ->
	#base_baby_figure_star{baby_id = 7,star = 12,cost = [{0,68010007,200}],base_attr = [{2,1040000},{4,32500},{5,13000},{7,13000},{20,450}],power = 0};

get_baby_figure_star(7,13) ->
	#base_baby_figure_star{baby_id = 7,star = 13,cost = [{0,68010007,250}],base_attr = [{2,1120000},{4,35000},{5,14000},{7,14000},{20,480}],power = 0};

get_baby_figure_star(7,14) ->
	#base_baby_figure_star{baby_id = 7,star = 14,cost = [{0,68010007,300}],base_attr = [{2,1200000},{4,37500},{5,15000},{7,15000},{20,510}],power = 0};

get_baby_figure_star(7,15) ->
	#base_baby_figure_star{baby_id = 7,star = 15,cost = [{0,68010007,350}],base_attr = [{2,1280000},{4,40000},{5,16000},{7,16000},{20,540}],power = 0};

get_baby_figure_star(8,1) ->
	#base_baby_figure_star{baby_id = 8,star = 1,cost = [],base_attr = [{1,10000},{3,6000},{6,3000},{8,3000},{43,300}],power = 0};

get_baby_figure_star(8,2) ->
	#base_baby_figure_star{baby_id = 8,star = 2,cost = [{0,68010008,25}],base_attr = [{1,15000},{3,9000},{6,4500},{8,4500},{43,375}],power = 0};

get_baby_figure_star(8,3) ->
	#base_baby_figure_star{baby_id = 8,star = 3,cost = [{0,68010008,30}],base_attr = [{1,20000},{3,12000},{6,6000},{8,6000},{43,450}],power = 0};

get_baby_figure_star(8,4) ->
	#base_baby_figure_star{baby_id = 8,star = 4,cost = [{0,68010008,40}],base_attr = [{1,25000},{3,15000},{6,7500},{8,7500},{43,525}],power = 0};

get_baby_figure_star(8,5) ->
	#base_baby_figure_star{baby_id = 8,star = 5,cost = [{0,68010008,45}],base_attr = [{1,30000},{3,18000},{6,9000},{8,9000},{43,600}],power = 0};

get_baby_figure_star(8,6) ->
	#base_baby_figure_star{baby_id = 8,star = 6,cost = [{0,68010008,50}],base_attr = [{1,35000},{3,21000},{6,10500},{8,10500},{43,675}],power = 0};

get_baby_figure_star(8,7) ->
	#base_baby_figure_star{baby_id = 8,star = 7,cost = [{0,68010008,60}],base_attr = [{1,40000},{3,24000},{6,12000},{8,12000},{43,750}],power = 0};

get_baby_figure_star(8,8) ->
	#base_baby_figure_star{baby_id = 8,star = 8,cost = [{0,68010008,70}],base_attr = [{1,45000},{3,27000},{6,13500},{8,13500},{43,825}],power = 0};

get_baby_figure_star(8,9) ->
	#base_baby_figure_star{baby_id = 8,star = 9,cost = [{0,68010008,80}],base_attr = [{1,50000},{3,30000},{6,15000},{8,15000},{43,900}],power = 0};

get_baby_figure_star(8,10) ->
	#base_baby_figure_star{baby_id = 8,star = 10,cost = [{0,68010008,100}],base_attr = [{1,55000},{3,33000},{6,16500},{8,16500},{43,975}],power = 0};

get_baby_figure_star(8,11) ->
	#base_baby_figure_star{baby_id = 8,star = 11,cost = [{0,68010008,150}],base_attr = [{1,60000},{3,36000},{6,18000},{8,18000},{43,1050}],power = 0};

get_baby_figure_star(8,12) ->
	#base_baby_figure_star{baby_id = 8,star = 12,cost = [{0,68010008,200}],base_attr = [{1,65000},{3,39000},{6,19500},{8,19500},{43,1125}],power = 0};

get_baby_figure_star(8,13) ->
	#base_baby_figure_star{baby_id = 8,star = 13,cost = [{0,68010008,250}],base_attr = [{1,70000},{3,42000},{6,21000},{8,21000},{43,1200}],power = 0};

get_baby_figure_star(8,14) ->
	#base_baby_figure_star{baby_id = 8,star = 14,cost = [{0,68010008,300}],base_attr = [{1,75000},{3,45000},{6,22500},{8,22500},{43,1275}],power = 0};

get_baby_figure_star(8,15) ->
	#base_baby_figure_star{baby_id = 8,star = 15,cost = [{0,68010008,350}],base_attr = [{1,80000},{3,48000},{6,24000},{8,24000},{43,1350}],power = 0};

get_baby_figure_star(9,1) ->
	#base_baby_figure_star{baby_id = 9,star = 1,cost = [],base_attr = [{2,200000},{4,6400},{5,3200},{7,3200},{44,300}],power = 0};

get_baby_figure_star(9,2) ->
	#base_baby_figure_star{baby_id = 9,star = 2,cost = [{0,68010009,25}],base_attr = [{2,300000},{4,9600},{5,4800},{7,4800},{44,375}],power = 0};

get_baby_figure_star(9,3) ->
	#base_baby_figure_star{baby_id = 9,star = 3,cost = [{0,68010009,30}],base_attr = [{2,400000},{4,12800},{5,6400},{7,6400},{44,450}],power = 0};

get_baby_figure_star(9,4) ->
	#base_baby_figure_star{baby_id = 9,star = 4,cost = [{0,68010009,40}],base_attr = [{2,500000},{4,16000},{5,8000},{7,8000},{44,525}],power = 0};

get_baby_figure_star(9,5) ->
	#base_baby_figure_star{baby_id = 9,star = 5,cost = [{0,68010009,45}],base_attr = [{2,600000},{4,19200},{5,9600},{7,9600},{44,600}],power = 0};

get_baby_figure_star(9,6) ->
	#base_baby_figure_star{baby_id = 9,star = 6,cost = [{0,68010009,50}],base_attr = [{2,700000},{4,22400},{5,11200},{7,11200},{44,675}],power = 0};

get_baby_figure_star(9,7) ->
	#base_baby_figure_star{baby_id = 9,star = 7,cost = [{0,68010009,60}],base_attr = [{2,800000},{4,25600},{5,12800},{7,12800},{44,750}],power = 0};

get_baby_figure_star(9,8) ->
	#base_baby_figure_star{baby_id = 9,star = 8,cost = [{0,68010009,70}],base_attr = [{2,900000},{4,28800},{5,14400},{7,14400},{44,825}],power = 0};

get_baby_figure_star(9,9) ->
	#base_baby_figure_star{baby_id = 9,star = 9,cost = [{0,68010009,80}],base_attr = [{2,1000000},{4,32000},{5,16000},{7,16000},{44,900}],power = 0};

get_baby_figure_star(9,10) ->
	#base_baby_figure_star{baby_id = 9,star = 10,cost = [{0,68010009,100}],base_attr = [{2,1100000},{4,35200},{5,17600},{7,17600},{44,975}],power = 0};

get_baby_figure_star(9,11) ->
	#base_baby_figure_star{baby_id = 9,star = 11,cost = [{0,68010009,150}],base_attr = [{2,1200000},{4,38400},{5,19200},{7,19200},{44,1050}],power = 0};

get_baby_figure_star(9,12) ->
	#base_baby_figure_star{baby_id = 9,star = 12,cost = [{0,68010009,200}],base_attr = [{2,1300000},{4,41600},{5,20800},{7,20800},{44,1125}],power = 0};

get_baby_figure_star(9,13) ->
	#base_baby_figure_star{baby_id = 9,star = 13,cost = [{0,68010009,250}],base_attr = [{2,1400000},{4,44800},{5,22400},{7,22400},{44,1200}],power = 0};

get_baby_figure_star(9,14) ->
	#base_baby_figure_star{baby_id = 9,star = 14,cost = [{0,68010009,300}],base_attr = [{2,1500000},{4,48000},{5,24000},{7,24000},{44,1275}],power = 0};

get_baby_figure_star(9,15) ->
	#base_baby_figure_star{baby_id = 9,star = 15,cost = [{0,68010009,350}],base_attr = [{2,1600000},{4,51200},{5,25600},{7,25600},{44,1350}],power = 0};

get_baby_figure_star(10,1) ->
	#base_baby_figure_star{baby_id = 10,star = 1,cost = [],base_attr = [{1,12000},{3,7000},{6,3500},{8,3500},{55,400}],power = 0};

get_baby_figure_star(10,2) ->
	#base_baby_figure_star{baby_id = 10,star = 2,cost = [{0,68010010,25}],base_attr = [{1,18000},{3,10500},{6,5250},{8,5250},{55,500}],power = 0};

get_baby_figure_star(10,3) ->
	#base_baby_figure_star{baby_id = 10,star = 3,cost = [{0,68010010,30}],base_attr = [{1,24000},{3,14000},{6,7000},{8,7000},{55,600}],power = 0};

get_baby_figure_star(10,4) ->
	#base_baby_figure_star{baby_id = 10,star = 4,cost = [{0,68010010,40}],base_attr = [{1,30000},{3,17500},{6,8750},{8,8750},{55,700}],power = 0};

get_baby_figure_star(10,5) ->
	#base_baby_figure_star{baby_id = 10,star = 5,cost = [{0,68010010,45}],base_attr = [{1,36000},{3,21000},{6,10500},{8,10500},{55,800}],power = 0};

get_baby_figure_star(10,6) ->
	#base_baby_figure_star{baby_id = 10,star = 6,cost = [{0,68010010,50}],base_attr = [{1,42000},{3,24500},{6,12250},{8,12250},{55,900}],power = 0};

get_baby_figure_star(10,7) ->
	#base_baby_figure_star{baby_id = 10,star = 7,cost = [{0,68010010,60}],base_attr = [{1,48000},{3,28000},{6,14000},{8,14000},{55,1000}],power = 0};

get_baby_figure_star(10,8) ->
	#base_baby_figure_star{baby_id = 10,star = 8,cost = [{0,68010010,70}],base_attr = [{1,54000},{3,31500},{6,15750},{8,15750},{55,1100}],power = 0};

get_baby_figure_star(10,9) ->
	#base_baby_figure_star{baby_id = 10,star = 9,cost = [{0,68010010,80}],base_attr = [{1,60000},{3,35000},{6,17500},{8,17500},{55,1200}],power = 0};

get_baby_figure_star(10,10) ->
	#base_baby_figure_star{baby_id = 10,star = 10,cost = [{0,68010010,100}],base_attr = [{1,66000},{3,38500},{6,19250},{8,19250},{55,1300}],power = 0};

get_baby_figure_star(10,11) ->
	#base_baby_figure_star{baby_id = 10,star = 11,cost = [{0,68010010,150}],base_attr = [{1,72000},{3,42000},{6,21000},{8,21000},{55,1400}],power = 0};

get_baby_figure_star(10,12) ->
	#base_baby_figure_star{baby_id = 10,star = 12,cost = [{0,68010010,200}],base_attr = [{1,78000},{3,45500},{6,22750},{8,22750},{55,1500}],power = 0};

get_baby_figure_star(10,13) ->
	#base_baby_figure_star{baby_id = 10,star = 13,cost = [{0,68010010,250}],base_attr = [{1,84000},{3,49000},{6,24500},{8,24500},{55,1600}],power = 0};

get_baby_figure_star(10,14) ->
	#base_baby_figure_star{baby_id = 10,star = 14,cost = [{0,68010010,300}],base_attr = [{1,90000},{3,52500},{6,26250},{8,26250},{55,1700}],power = 0};

get_baby_figure_star(10,15) ->
	#base_baby_figure_star{baby_id = 10,star = 15,cost = [{0,68010010,350}],base_attr = [{1,96000},{3,56000},{6,28000},{8,28000},{55,1800}],power = 0};

get_baby_figure_star(11,1) ->
	#base_baby_figure_star{baby_id = 11,star = 1,cost = [],base_attr = [{2,200000},{4,6400},{5,3200},{7,3200},{19,100}],power = 0};

get_baby_figure_star(11,2) ->
	#base_baby_figure_star{baby_id = 11,star = 2,cost = [{0,68010011,25}],base_attr = [{2,300000},{4,9600},{5,4800},{7,4800},{19,125}],power = 0};

get_baby_figure_star(11,3) ->
	#base_baby_figure_star{baby_id = 11,star = 3,cost = [{0,68010011,30}],base_attr = [{2,400000},{4,12800},{5,6400},{7,6400},{19,150}],power = 0};

get_baby_figure_star(11,4) ->
	#base_baby_figure_star{baby_id = 11,star = 4,cost = [{0,68010011,40}],base_attr = [{2,500000},{4,16000},{5,8000},{7,8000},{19,175}],power = 0};

get_baby_figure_star(11,5) ->
	#base_baby_figure_star{baby_id = 11,star = 5,cost = [{0,68010011,45}],base_attr = [{2,600000},{4,19200},{5,9600},{7,9600},{19,200}],power = 0};

get_baby_figure_star(11,6) ->
	#base_baby_figure_star{baby_id = 11,star = 6,cost = [{0,68010011,50}],base_attr = [{2,700000},{4,22400},{5,11200},{7,11200},{19,225}],power = 0};

get_baby_figure_star(11,7) ->
	#base_baby_figure_star{baby_id = 11,star = 7,cost = [{0,68010011,60}],base_attr = [{2,800000},{4,25600},{5,12800},{7,12800},{19,250}],power = 0};

get_baby_figure_star(11,8) ->
	#base_baby_figure_star{baby_id = 11,star = 8,cost = [{0,68010011,70}],base_attr = [{2,900000},{4,28800},{5,14400},{7,14400},{19,275}],power = 0};

get_baby_figure_star(11,9) ->
	#base_baby_figure_star{baby_id = 11,star = 9,cost = [{0,68010011,80}],base_attr = [{2,1000000},{4,32000},{5,16000},{7,16000},{19,300}],power = 0};

get_baby_figure_star(11,10) ->
	#base_baby_figure_star{baby_id = 11,star = 10,cost = [{0,68010011,100}],base_attr = [{2,1100000},{4,35200},{5,17600},{7,17600},{19,325}],power = 0};

get_baby_figure_star(11,11) ->
	#base_baby_figure_star{baby_id = 11,star = 11,cost = [{0,68010011,150}],base_attr = [{2,1200000},{4,38400},{5,19200},{7,19200},{19,350}],power = 0};

get_baby_figure_star(11,12) ->
	#base_baby_figure_star{baby_id = 11,star = 12,cost = [{0,68010011,200}],base_attr = [{2,1300000},{4,41600},{5,20800},{7,20800},{19,375}],power = 0};

get_baby_figure_star(11,13) ->
	#base_baby_figure_star{baby_id = 11,star = 13,cost = [{0,68010011,250}],base_attr = [{2,1400000},{4,44800},{5,22400},{7,22400},{19,400}],power = 0};

get_baby_figure_star(11,14) ->
	#base_baby_figure_star{baby_id = 11,star = 14,cost = [{0,68010011,300}],base_attr = [{2,1500000},{4,48000},{5,24000},{7,24000},{19,425}],power = 0};

get_baby_figure_star(11,15) ->
	#base_baby_figure_star{baby_id = 11,star = 15,cost = [{0,68010011,350}],base_attr = [{2,1600000},{4,51200},{5,25600},{7,25600},{19,450}],power = 0};

get_baby_figure_star(12,1) ->
	#base_baby_figure_star{baby_id = 12,star = 1,cost = [],base_attr = [{1,12500},{3,7400},{6,3700},{8,3700},{56,400}],power = 0};

get_baby_figure_star(12,2) ->
	#base_baby_figure_star{baby_id = 12,star = 2,cost = [{0,68010012,25}],base_attr = [{1,18750},{3,11100},{6,5550},{8,5550},{56,500}],power = 0};

get_baby_figure_star(12,3) ->
	#base_baby_figure_star{baby_id = 12,star = 3,cost = [{0,68010012,30}],base_attr = [{1,25000},{3,14800},{6,7400},{8,7400},{56,600}],power = 0};

get_baby_figure_star(12,4) ->
	#base_baby_figure_star{baby_id = 12,star = 4,cost = [{0,68010012,40}],base_attr = [{1,31250},{3,18500},{6,9250},{8,9250},{56,700}],power = 0};

get_baby_figure_star(12,5) ->
	#base_baby_figure_star{baby_id = 12,star = 5,cost = [{0,68010012,45}],base_attr = [{1,37500},{3,22200},{6,11100},{8,11100},{56,800}],power = 0};

get_baby_figure_star(12,6) ->
	#base_baby_figure_star{baby_id = 12,star = 6,cost = [{0,68010012,50}],base_attr = [{1,43750},{3,25900},{6,12950},{8,12950},{56,900}],power = 0};

get_baby_figure_star(12,7) ->
	#base_baby_figure_star{baby_id = 12,star = 7,cost = [{0,68010012,60}],base_attr = [{1,50000},{3,29600},{6,14800},{8,14800},{56,1000}],power = 0};

get_baby_figure_star(12,8) ->
	#base_baby_figure_star{baby_id = 12,star = 8,cost = [{0,68010012,70}],base_attr = [{1,56250},{3,33300},{6,16650},{8,16650},{56,1100}],power = 0};

get_baby_figure_star(12,9) ->
	#base_baby_figure_star{baby_id = 12,star = 9,cost = [{0,68010012,80}],base_attr = [{1,62500},{3,37000},{6,18500},{8,18500},{56,1200}],power = 0};

get_baby_figure_star(12,10) ->
	#base_baby_figure_star{baby_id = 12,star = 10,cost = [{0,68010012,100}],base_attr = [{1,68750},{3,40700},{6,20350},{8,20350},{56,1300}],power = 0};

get_baby_figure_star(12,11) ->
	#base_baby_figure_star{baby_id = 12,star = 11,cost = [{0,68010012,150}],base_attr = [{1,75000},{3,44400},{6,22200},{8,22200},{56,1400}],power = 0};

get_baby_figure_star(12,12) ->
	#base_baby_figure_star{baby_id = 12,star = 12,cost = [{0,68010012,200}],base_attr = [{1,81250},{3,48100},{6,24050},{8,24050},{56,1500}],power = 0};

get_baby_figure_star(12,13) ->
	#base_baby_figure_star{baby_id = 12,star = 13,cost = [{0,68010012,250}],base_attr = [{1,87500},{3,51800},{6,25900},{8,25900},{56,1600}],power = 0};

get_baby_figure_star(12,14) ->
	#base_baby_figure_star{baby_id = 12,star = 14,cost = [{0,68010012,300}],base_attr = [{1,93750},{3,55500},{6,27750},{8,27750},{56,1700}],power = 0};

get_baby_figure_star(12,15) ->
	#base_baby_figure_star{baby_id = 12,star = 15,cost = [{0,68010012,350}],base_attr = [{1,100000},{3,59200},{6,29600},{8,29600},{56,1800}],power = 0};

get_baby_figure_star(13,1) ->
	#base_baby_figure_star{baby_id = 13,star = 1,cost = [],base_attr = [{2,240000},{4,8000},{5,4000},{7,4000},{20,120}],power = 0};

get_baby_figure_star(13,2) ->
	#base_baby_figure_star{baby_id = 13,star = 2,cost = [{0,68010013,25}],base_attr = [{2,360000},{4,12000},{5,6000},{7,6000},{20,150}],power = 0};

get_baby_figure_star(13,3) ->
	#base_baby_figure_star{baby_id = 13,star = 3,cost = [{0,68010013,30}],base_attr = [{2,480000},{4,16000},{5,8000},{7,8000},{20,180}],power = 0};

get_baby_figure_star(13,4) ->
	#base_baby_figure_star{baby_id = 13,star = 4,cost = [{0,68010013,40}],base_attr = [{2,600000},{4,20000},{5,10000},{7,10000},{20,210}],power = 0};

get_baby_figure_star(13,5) ->
	#base_baby_figure_star{baby_id = 13,star = 5,cost = [{0,68010013,45}],base_attr = [{2,720000},{4,24000},{5,12000},{7,12000},{20,240}],power = 0};

get_baby_figure_star(13,6) ->
	#base_baby_figure_star{baby_id = 13,star = 6,cost = [{0,68010013,50}],base_attr = [{2,840000},{4,28000},{5,14000},{7,14000},{20,270}],power = 0};

get_baby_figure_star(13,7) ->
	#base_baby_figure_star{baby_id = 13,star = 7,cost = [{0,68010013,60}],base_attr = [{2,960000},{4,32000},{5,16000},{7,16000},{20,300}],power = 0};

get_baby_figure_star(13,8) ->
	#base_baby_figure_star{baby_id = 13,star = 8,cost = [{0,68010013,70}],base_attr = [{2,1080000},{4,36000},{5,18000},{7,18000},{20,330}],power = 0};

get_baby_figure_star(13,9) ->
	#base_baby_figure_star{baby_id = 13,star = 9,cost = [{0,68010013,80}],base_attr = [{2,1200000},{4,40000},{5,20000},{7,20000},{20,360}],power = 0};

get_baby_figure_star(13,10) ->
	#base_baby_figure_star{baby_id = 13,star = 10,cost = [{0,68010013,100}],base_attr = [{2,1320000},{4,44000},{5,22000},{7,22000},{20,390}],power = 0};

get_baby_figure_star(13,11) ->
	#base_baby_figure_star{baby_id = 13,star = 11,cost = [{0,68010013,150}],base_attr = [{2,1440000},{4,48000},{5,24000},{7,24000},{20,420}],power = 0};

get_baby_figure_star(13,12) ->
	#base_baby_figure_star{baby_id = 13,star = 12,cost = [{0,68010013,200}],base_attr = [{2,1560000},{4,52000},{5,26000},{7,26000},{20,450}],power = 0};

get_baby_figure_star(13,13) ->
	#base_baby_figure_star{baby_id = 13,star = 13,cost = [{0,68010013,250}],base_attr = [{2,1680000},{4,56000},{5,28000},{7,28000},{20,480}],power = 0};

get_baby_figure_star(13,14) ->
	#base_baby_figure_star{baby_id = 13,star = 14,cost = [{0,68010013,300}],base_attr = [{2,1800000},{4,60000},{5,30000},{7,30000},{20,510}],power = 0};

get_baby_figure_star(13,15) ->
	#base_baby_figure_star{baby_id = 13,star = 15,cost = [{0,68010013,350}],base_attr = [{2,1920000},{4,64000},{5,32000},{7,32000},{20,540}],power = 0};

get_baby_figure_star(_Babyid,_Star) ->
	[].

get_praise_reward_by_rank(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38040043,1},{0,32010222,3}];
get_praise_reward_by_rank(_Rank) when _Rank >= 2, _Rank =< 3 ->
		[{0,38040042,3},{0,32010222,2}];
get_praise_reward_by_rank(_Rank) when _Rank >= 4, _Rank =< 10 ->
		[{0,38040042,2},{0,32010222,1}];
get_praise_reward_by_rank(_Rank) when _Rank >= 11, _Rank =< 20 ->
		[{0,38040041,3},{0,38040041,2}];
get_praise_reward_by_rank(_Rank) when _Rank >= 21, _Rank =< 50 ->
		[{0,38040041,2},{0,38040041,1}];
get_praise_reward_by_rank(_Rank) when _Rank >= 51, _Rank =< 100 ->
		[{0,38040041,1},{0,38040041,1}];
get_praise_reward_by_rank(_Rank) ->
	0.

get_baby_equip(65010100) ->
	#base_baby_equip{goods_id = 65010100,pos_id = 1,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2094};

get_baby_equip(65010200) ->
	#base_baby_equip{goods_id = 65010200,pos_id = 1,color = 2,equip_stage = 1,skills = 2001001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4188};

get_baby_equip(65010300) ->
	#base_baby_equip{goods_id = 65010300,pos_id = 1,color = 3,equip_stage = 1,skills = 2001002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 8376};

get_baby_equip(65010400) ->
	#base_baby_equip{goods_id = 65010400,pos_id = 1,color = 4,equip_stage = 1,skills = 2001003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 17450};

get_baby_equip(65010500) ->
	#base_baby_equip{goods_id = 65010500,pos_id = 1,color = 5,equip_stage = 1,skills = 2001004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 34899};

get_baby_equip(65010600) ->
	#base_baby_equip{goods_id = 65010600,pos_id = 1,color = 6,equip_stage = 1,skills = 2001005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65010601) ->
	#base_baby_equip{goods_id = 65010601,pos_id = 1,color = 6,equip_stage = 1,skills = 2001005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65020100) ->
	#base_baby_equip{goods_id = 65020100,pos_id = 2,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2094};

get_baby_equip(65020200) ->
	#base_baby_equip{goods_id = 65020200,pos_id = 2,color = 2,equip_stage = 1,skills = 2002001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4188};

get_baby_equip(65020300) ->
	#base_baby_equip{goods_id = 65020300,pos_id = 2,color = 3,equip_stage = 1,skills = 2002002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 8376};

get_baby_equip(65020301) ->
	#base_baby_equip{goods_id = 65020301,pos_id = 2,color = 3,equip_stage = 1,skills = 2002002,gen_ratio = 10000,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 8376};

get_baby_equip(65020400) ->
	#base_baby_equip{goods_id = 65020400,pos_id = 2,color = 4,equip_stage = 1,skills = 2002003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 17450};

get_baby_equip(65020500) ->
	#base_baby_equip{goods_id = 65020500,pos_id = 2,color = 5,equip_stage = 1,skills = 2002004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 34899};

get_baby_equip(65020600) ->
	#base_baby_equip{goods_id = 65020600,pos_id = 2,color = 6,equip_stage = 1,skills = 2002005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65020601) ->
	#base_baby_equip{goods_id = 65020601,pos_id = 2,color = 6,equip_stage = 1,skills = 2002005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65030100) ->
	#base_baby_equip{goods_id = 65030100,pos_id = 3,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2094};

get_baby_equip(65030200) ->
	#base_baby_equip{goods_id = 65030200,pos_id = 3,color = 2,equip_stage = 1,skills = 2003001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4188};

get_baby_equip(65030300) ->
	#base_baby_equip{goods_id = 65030300,pos_id = 3,color = 3,equip_stage = 1,skills = 2003002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 8376};

get_baby_equip(65030400) ->
	#base_baby_equip{goods_id = 65030400,pos_id = 3,color = 4,equip_stage = 1,skills = 2003003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 17450};

get_baby_equip(65030500) ->
	#base_baby_equip{goods_id = 65030500,pos_id = 3,color = 5,equip_stage = 1,skills = 2003004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 34899};

get_baby_equip(65030600) ->
	#base_baby_equip{goods_id = 65030600,pos_id = 3,color = 6,equip_stage = 1,skills = 2003005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65030601) ->
	#base_baby_equip{goods_id = 65030601,pos_id = 3,color = 6,equip_stage = 1,skills = 2003005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65040100) ->
	#base_baby_equip{goods_id = 65040100,pos_id = 4,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2094};

get_baby_equip(65040200) ->
	#base_baby_equip{goods_id = 65040200,pos_id = 4,color = 2,equip_stage = 1,skills = 2004001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4188};

get_baby_equip(65040300) ->
	#base_baby_equip{goods_id = 65040300,pos_id = 4,color = 3,equip_stage = 1,skills = 2004002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 8376};

get_baby_equip(65040400) ->
	#base_baby_equip{goods_id = 65040400,pos_id = 4,color = 4,equip_stage = 1,skills = 2004003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 17450};

get_baby_equip(65040500) ->
	#base_baby_equip{goods_id = 65040500,pos_id = 4,color = 5,equip_stage = 1,skills = 2004004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 34899};

get_baby_equip(65040600) ->
	#base_baby_equip{goods_id = 65040600,pos_id = 4,color = 6,equip_stage = 1,skills = 2004005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65040601) ->
	#base_baby_equip{goods_id = 65040601,pos_id = 4,color = 6,equip_stage = 1,skills = 2004005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 69799};

get_baby_equip(65050100) ->
	#base_baby_equip{goods_id = 65050100,pos_id = 5,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2255};

get_baby_equip(65050200) ->
	#base_baby_equip{goods_id = 65050200,pos_id = 5,color = 2,equip_stage = 1,skills = 2005001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4510};

get_baby_equip(65050300) ->
	#base_baby_equip{goods_id = 65050300,pos_id = 5,color = 3,equip_stage = 1,skills = 2005002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 9020};

get_baby_equip(65050400) ->
	#base_baby_equip{goods_id = 65050400,pos_id = 5,color = 4,equip_stage = 1,skills = 2005003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 18792};

get_baby_equip(65050500) ->
	#base_baby_equip{goods_id = 65050500,pos_id = 5,color = 5,equip_stage = 1,skills = 2005004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 37584};

get_baby_equip(65050600) ->
	#base_baby_equip{goods_id = 65050600,pos_id = 5,color = 6,equip_stage = 1,skills = 2005005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 75168};

get_baby_equip(65050601) ->
	#base_baby_equip{goods_id = 65050601,pos_id = 5,color = 6,equip_stage = 1,skills = 2005005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 75168};

get_baby_equip(65060100) ->
	#base_baby_equip{goods_id = 65060100,pos_id = 6,color = 1,equip_stage = 1,skills = 0,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 2255};

get_baby_equip(65060200) ->
	#base_baby_equip{goods_id = 65060200,pos_id = 6,color = 2,equip_stage = 1,skills = 2006001,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 4510};

get_baby_equip(65060300) ->
	#base_baby_equip{goods_id = 65060300,pos_id = 6,color = 3,equip_stage = 1,skills = 2006002,gen_ratio = 0,compose_ratio = [{1,1500},{2,3000},{3,4500},{4,6000},{5,7500},{6,10000}],score = 9020};

get_baby_equip(65060400) ->
	#base_baby_equip{goods_id = 65060400,pos_id = 6,color = 4,equip_stage = 1,skills = 2006003,gen_ratio = 0,compose_ratio = [{1,1800},{2,3600},{3,5400},{4,7200},{5,10000},{6,10000}],score = 18792};

get_baby_equip(65060500) ->
	#base_baby_equip{goods_id = 65060500,pos_id = 6,color = 5,equip_stage = 1,skills = 2006004,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 37584};

get_baby_equip(65060600) ->
	#base_baby_equip{goods_id = 65060600,pos_id = 6,color = 6,equip_stage = 1,skills = 2006005,gen_ratio = 0,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 75168};

get_baby_equip(65060601) ->
	#base_baby_equip{goods_id = 65060601,pos_id = 6,color = 6,equip_stage = 1,skills = 2006005,gen_ratio = 10000,compose_ratio = [{1,2500},{2,5000},{3,7500},{4,10000},{5,10000},{6,10000}],score = 75168};

get_baby_equip(_Goodsid) ->
	[].

get_baby_equip_stren(1,0,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{1,67},{4,72}]};

get_baby_equip_stren(1,0,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{1,134},{4,145}]};

get_baby_equip_stren(1,0,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{1,201},{4,217}]};

get_baby_equip_stren(1,0,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{1,268},{4,290}]};

get_baby_equip_stren(1,0,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{1,336},{4,362}]};

get_baby_equip_stren(1,0,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{1,403},{4,435}]};

get_baby_equip_stren(1,0,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{1,470},{4,507}]};

get_baby_equip_stren(1,0,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{1,537},{4,580}]};

get_baby_equip_stren(1,0,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{1,604},{4,652}]};

get_baby_equip_stren(1,0,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{1,671},{4,725}]};

get_baby_equip_stren(1,1,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{1,872},{4,942}]};

get_baby_equip_stren(1,1,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{1,940},{4,1015}]};

get_baby_equip_stren(1,1,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{1,1007},{4,1087}]};

get_baby_equip_stren(1,1,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{1,1074},{4,1160}]};

get_baby_equip_stren(1,1,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{1,1141},{4,1232}]};

get_baby_equip_stren(1,1,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{1,1208},{4,1305}]};

get_baby_equip_stren(1,1,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{1,1275},{4,1377}]};

get_baby_equip_stren(1,1,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{1,1342},{4,1450}]};

get_baby_equip_stren(1,1,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{1,1409},{4,1522}]};

get_baby_equip_stren(1,1,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{1,1477},{4,1595}]};

get_baby_equip_stren(1,1,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{1,1544},{4,1667}]};

get_baby_equip_stren(1,2,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{1,1745},{4,1885}]};

get_baby_equip_stren(1,2,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{1,1812},{4,1957}]};

get_baby_equip_stren(1,2,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{1,1879},{4,2030}]};

get_baby_equip_stren(1,2,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{1,1946},{4,2102}]};

get_baby_equip_stren(1,2,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{1,2013},{4,2174}]};

get_baby_equip_stren(1,2,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{1,2081},{4,2247}]};

get_baby_equip_stren(1,2,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{1,2148},{4,2319}]};

get_baby_equip_stren(1,2,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{1,2215},{4,2392}]};

get_baby_equip_stren(1,2,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{1,2282},{4,2464}]};

get_baby_equip_stren(1,2,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{1,2349},{4,2537}]};

get_baby_equip_stren(1,2,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{1,2416},{4,2609}]};

get_baby_equip_stren(1,3,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{1,2617},{4,2827}]};

get_baby_equip_stren(1,3,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{1,2685},{4,2899}]};

get_baby_equip_stren(1,3,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{1,2752},{4,2972}]};

get_baby_equip_stren(1,3,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{1,2819},{4,3044}]};

get_baby_equip_stren(1,3,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{1,2886},{4,3117}]};

get_baby_equip_stren(1,3,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{1,2953},{4,3189}]};

get_baby_equip_stren(1,3,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{1,3020},{4,3262}]};

get_baby_equip_stren(1,3,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{1,3087},{4,3334}]};

get_baby_equip_stren(1,3,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{1,3154},{4,3407}]};

get_baby_equip_stren(1,3,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{1,3221},{4,3479}]};

get_baby_equip_stren(1,3,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{1,3289},{4,3552}]};

get_baby_equip_stren(1,4,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{1,3490},{4,3769}]};

get_baby_equip_stren(1,4,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{1,3557},{4,3842}]};

get_baby_equip_stren(1,4,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{1,3624},{4,3914}]};

get_baby_equip_stren(1,4,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{1,3691},{4,3987}]};

get_baby_equip_stren(1,4,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{1,3758},{4,4059}]};

get_baby_equip_stren(1,4,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{1,3826},{4,4132}]};

get_baby_equip_stren(1,4,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{1,3893},{4,4204}]};

get_baby_equip_stren(1,4,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{1,3960},{4,4277}]};

get_baby_equip_stren(1,4,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{1,4027},{4,4349}]};

get_baby_equip_stren(1,4,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{1,4094},{4,4421}]};

get_baby_equip_stren(1,4,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{1,4161},{4,4494}]};

get_baby_equip_stren(1,5,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{1,4362},{4,4711}]};

get_baby_equip_stren(1,5,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{1,4430},{4,4784}]};

get_baby_equip_stren(1,5,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{1,4497},{4,4856}]};

get_baby_equip_stren(1,5,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{1,4564},{4,4929}]};

get_baby_equip_stren(1,5,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{1,4631},{4,5001}]};

get_baby_equip_stren(1,5,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{1,4698},{4,5074}]};

get_baby_equip_stren(1,5,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{1,4765},{4,5146}]};

get_baby_equip_stren(1,5,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{1,4832},{4,5219}]};

get_baby_equip_stren(1,5,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{1,4899},{4,5291}]};

get_baby_equip_stren(1,5,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{1,4966},{4,5364}]};

get_baby_equip_stren(1,5,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{1,5034},{4,5436}]};

get_baby_equip_stren(1,6,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{1,5235},{4,5654}]};

get_baby_equip_stren(1,6,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{1,5302},{4,5726}]};

get_baby_equip_stren(1,6,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{1,5369},{4,5799}]};

get_baby_equip_stren(1,6,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{1,5436},{4,5871}]};

get_baby_equip_stren(1,6,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{1,5503},{4,5944}]};

get_baby_equip_stren(1,6,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{1,5570},{4,6016}]};

get_baby_equip_stren(1,6,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{1,5638},{4,6089}]};

get_baby_equip_stren(1,6,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{1,5705},{4,6161}]};

get_baby_equip_stren(1,6,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{1,5772},{4,6234}]};

get_baby_equip_stren(1,6,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{1,5839},{4,6306}]};

get_baby_equip_stren(1,6,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{1,5906},{4,6379}]};

get_baby_equip_stren(1,7,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{1,6107},{4,6596}]};

get_baby_equip_stren(1,7,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{1,6174},{4,6668}]};

get_baby_equip_stren(1,7,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{1,6242},{4,6741}]};

get_baby_equip_stren(1,7,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{1,6309},{4,6813}]};

get_baby_equip_stren(1,7,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{1,6376},{4,6886}]};

get_baby_equip_stren(1,7,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{1,6443},{4,6958}]};

get_baby_equip_stren(1,7,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{1,6510},{4,7031}]};

get_baby_equip_stren(1,7,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{1,6577},{4,7103}]};

get_baby_equip_stren(1,7,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{1,6644},{4,7176}]};

get_baby_equip_stren(1,7,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{1,6711},{4,7248}]};

get_baby_equip_stren(1,7,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{1,6779},{4,7321}]};

get_baby_equip_stren(1,8,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{1,6980},{4,7538}]};

get_baby_equip_stren(1,8,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{1,7047},{4,7611}]};

get_baby_equip_stren(1,8,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{1,7114},{4,7683}]};

get_baby_equip_stren(1,8,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{1,7181},{4,7756}]};

get_baby_equip_stren(1,8,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{1,7248},{4,7828}]};

get_baby_equip_stren(1,8,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{1,7315},{4,7901}]};

get_baby_equip_stren(1,8,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{1,7383},{4,7973}]};

get_baby_equip_stren(1,8,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{1,7450},{4,8046}]};

get_baby_equip_stren(1,8,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{1,7517},{4,8118}]};

get_baby_equip_stren(1,8,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{1,7584},{4,8191}]};

get_baby_equip_stren(1,8,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{1,7651},{4,8263}]};

get_baby_equip_stren(1,9,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{1,7852},{4,8481}]};

get_baby_equip_stren(1,9,1) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{1,7919},{4,8553}]};

get_baby_equip_stren(1,9,2) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{1,7987},{4,8626}]};

get_baby_equip_stren(1,9,3) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{1,8054},{4,8698}]};

get_baby_equip_stren(1,9,4) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{1,8121},{4,8770}]};

get_baby_equip_stren(1,9,5) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{1,8188},{4,8843}]};

get_baby_equip_stren(1,9,6) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{1,8255},{4,8915}]};

get_baby_equip_stren(1,9,7) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{1,8322},{4,8988}]};

get_baby_equip_stren(1,9,8) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{1,8389},{4,9060}]};

get_baby_equip_stren(1,9,9) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{1,8456},{4,9133}]};

get_baby_equip_stren(1,9,10) ->
	#base_baby_equip_stren{pos_id = 1,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{1,8523},{4,9205}]};

get_baby_equip_stren(1,10,0) ->
	#base_baby_equip_stren{pos_id = 1,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{1,8725},{4,9423}]};

get_baby_equip_stren(2,0,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{3,72},{2,1342}]};

get_baby_equip_stren(2,0,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{3,145},{2,2685}]};

get_baby_equip_stren(2,0,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{3,217},{2,4027}]};

get_baby_equip_stren(2,0,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{3,290},{2,5369}]};

get_baby_equip_stren(2,0,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{3,362},{2,6711}]};

get_baby_equip_stren(2,0,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{3,435},{2,8054}]};

get_baby_equip_stren(2,0,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{3,507},{2,9396}]};

get_baby_equip_stren(2,0,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{3,580},{2,10738}]};

get_baby_equip_stren(2,0,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{3,652},{2,12081}]};

get_baby_equip_stren(2,0,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{3,725},{2,13423}]};

get_baby_equip_stren(2,1,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{3,942},{2,17450}]};

get_baby_equip_stren(2,1,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{3,1015},{2,18792}]};

get_baby_equip_stren(2,1,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{3,1087},{2,20134}]};

get_baby_equip_stren(2,1,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{3,1160},{2,21477}]};

get_baby_equip_stren(2,1,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{3,1232},{2,22819}]};

get_baby_equip_stren(2,1,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{3,1305},{2,24161}]};

get_baby_equip_stren(2,1,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{3,1377},{2,25503}]};

get_baby_equip_stren(2,1,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{3,1450},{2,26846}]};

get_baby_equip_stren(2,1,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{3,1522},{2,28188}]};

get_baby_equip_stren(2,1,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{3,1595},{2,29530}]};

get_baby_equip_stren(2,1,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{3,1667},{2,30872}]};

get_baby_equip_stren(2,2,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{3,1885},{2,34899}]};

get_baby_equip_stren(2,2,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{3,1957},{2,36242}]};

get_baby_equip_stren(2,2,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{3,2030},{2,37584}]};

get_baby_equip_stren(2,2,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{3,2102},{2,38926}]};

get_baby_equip_stren(2,2,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{3,2174},{2,40268}]};

get_baby_equip_stren(2,2,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{3,2247},{2,41611}]};

get_baby_equip_stren(2,2,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{3,2319},{2,42953}]};

get_baby_equip_stren(2,2,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{3,2392},{2,44295}]};

get_baby_equip_stren(2,2,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{3,2464},{2,45638}]};

get_baby_equip_stren(2,2,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{3,2537},{2,46980}]};

get_baby_equip_stren(2,2,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{3,2609},{2,48322}]};

get_baby_equip_stren(2,3,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{3,2827},{2,52349}]};

get_baby_equip_stren(2,3,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{3,2899},{2,53691}]};

get_baby_equip_stren(2,3,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{3,2972},{2,55034}]};

get_baby_equip_stren(2,3,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{3,3044},{2,56376}]};

get_baby_equip_stren(2,3,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{3,3117},{2,57718}]};

get_baby_equip_stren(2,3,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{3,3189},{2,59060}]};

get_baby_equip_stren(2,3,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{3,3262},{2,60403}]};

get_baby_equip_stren(2,3,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{3,3334},{2,61745}]};

get_baby_equip_stren(2,3,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{3,3407},{2,63087}]};

get_baby_equip_stren(2,3,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{3,3479},{2,64430}]};

get_baby_equip_stren(2,3,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{3,3552},{2,65772}]};

get_baby_equip_stren(2,4,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{3,3769},{2,69799}]};

get_baby_equip_stren(2,4,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{3,3842},{2,71141}]};

get_baby_equip_stren(2,4,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{3,3914},{2,72483}]};

get_baby_equip_stren(2,4,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{3,3987},{2,73826}]};

get_baby_equip_stren(2,4,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{3,4059},{2,75168}]};

get_baby_equip_stren(2,4,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{3,4132},{2,76510}]};

get_baby_equip_stren(2,4,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{3,4204},{2,77852}]};

get_baby_equip_stren(2,4,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{3,4277},{2,79195}]};

get_baby_equip_stren(2,4,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{3,4349},{2,80537}]};

get_baby_equip_stren(2,4,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{3,4421},{2,81879}]};

get_baby_equip_stren(2,4,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{3,4494},{2,83221}]};

get_baby_equip_stren(2,5,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{3,4711},{2,87248}]};

get_baby_equip_stren(2,5,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{3,4784},{2,88591}]};

get_baby_equip_stren(2,5,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{3,4856},{2,89933}]};

get_baby_equip_stren(2,5,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{3,4929},{2,91275}]};

get_baby_equip_stren(2,5,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{3,5001},{2,92617}]};

get_baby_equip_stren(2,5,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{3,5074},{2,93960}]};

get_baby_equip_stren(2,5,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{3,5146},{2,95302}]};

get_baby_equip_stren(2,5,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{3,5219},{2,96644}]};

get_baby_equip_stren(2,5,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{3,5291},{2,97987}]};

get_baby_equip_stren(2,5,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{3,5364},{2,99329}]};

get_baby_equip_stren(2,5,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{3,5436},{2,100671}]};

get_baby_equip_stren(2,6,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{3,5654},{2,104698}]};

get_baby_equip_stren(2,6,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{3,5726},{2,106040}]};

get_baby_equip_stren(2,6,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{3,5799},{2,107383}]};

get_baby_equip_stren(2,6,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{3,5871},{2,108725}]};

get_baby_equip_stren(2,6,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{3,5944},{2,110067}]};

get_baby_equip_stren(2,6,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{3,6016},{2,111409}]};

get_baby_equip_stren(2,6,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{3,6089},{2,112752}]};

get_baby_equip_stren(2,6,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{3,6161},{2,114094}]};

get_baby_equip_stren(2,6,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{3,6234},{2,115436}]};

get_baby_equip_stren(2,6,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{3,6306},{2,116779}]};

get_baby_equip_stren(2,6,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{3,6379},{2,118121}]};

get_baby_equip_stren(2,7,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{3,6596},{2,122148}]};

get_baby_equip_stren(2,7,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{3,6668},{2,123490}]};

get_baby_equip_stren(2,7,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{3,6741},{2,124832}]};

get_baby_equip_stren(2,7,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{3,6813},{2,126174}]};

get_baby_equip_stren(2,7,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{3,6886},{2,127517}]};

get_baby_equip_stren(2,7,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{3,6958},{2,128859}]};

get_baby_equip_stren(2,7,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{3,7031},{2,130201}]};

get_baby_equip_stren(2,7,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{3,7103},{2,131544}]};

get_baby_equip_stren(2,7,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{3,7176},{2,132886}]};

get_baby_equip_stren(2,7,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{3,7248},{2,134228}]};

get_baby_equip_stren(2,7,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{3,7321},{2,135570}]};

get_baby_equip_stren(2,8,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{3,7538},{2,139597}]};

get_baby_equip_stren(2,8,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{3,7611},{2,140940}]};

get_baby_equip_stren(2,8,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{3,7683},{2,142282}]};

get_baby_equip_stren(2,8,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{3,7756},{2,143624}]};

get_baby_equip_stren(2,8,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{3,7828},{2,144966}]};

get_baby_equip_stren(2,8,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{3,7901},{2,146309}]};

get_baby_equip_stren(2,8,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{3,7973},{2,147651}]};

get_baby_equip_stren(2,8,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{3,8046},{2,148993}]};

get_baby_equip_stren(2,8,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{3,8118},{2,150336}]};

get_baby_equip_stren(2,8,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{3,8191},{2,151678}]};

get_baby_equip_stren(2,8,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{3,8263},{2,153020}]};

get_baby_equip_stren(2,9,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{3,8481},{2,157047}]};

get_baby_equip_stren(2,9,1) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{3,8553},{2,158389}]};

get_baby_equip_stren(2,9,2) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{3,8626},{2,159732}]};

get_baby_equip_stren(2,9,3) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{3,8698},{2,161074}]};

get_baby_equip_stren(2,9,4) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{3,8770},{2,162416}]};

get_baby_equip_stren(2,9,5) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{3,8843},{2,163758}]};

get_baby_equip_stren(2,9,6) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{3,8915},{2,165101}]};

get_baby_equip_stren(2,9,7) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{3,8988},{2,166443}]};

get_baby_equip_stren(2,9,8) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{3,9060},{2,167785}]};

get_baby_equip_stren(2,9,9) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{3,9133},{2,169128}]};

get_baby_equip_stren(2,9,10) ->
	#base_baby_equip_stren{pos_id = 2,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{3,9205},{2,170470}]};

get_baby_equip_stren(2,10,0) ->
	#base_baby_equip_stren{pos_id = 2,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{3,9423},{2,174497}]};

get_baby_equip_stren(3,0,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{1,67},{3,72}]};

get_baby_equip_stren(3,0,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{1,134},{3,145}]};

get_baby_equip_stren(3,0,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{1,201},{3,217}]};

get_baby_equip_stren(3,0,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{1,268},{3,290}]};

get_baby_equip_stren(3,0,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{1,336},{3,362}]};

get_baby_equip_stren(3,0,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{1,403},{3,435}]};

get_baby_equip_stren(3,0,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{1,470},{3,507}]};

get_baby_equip_stren(3,0,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{1,537},{3,580}]};

get_baby_equip_stren(3,0,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{1,604},{3,652}]};

get_baby_equip_stren(3,0,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{1,671},{3,725}]};

get_baby_equip_stren(3,1,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{1,872},{3,942}]};

get_baby_equip_stren(3,1,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{1,940},{3,1015}]};

get_baby_equip_stren(3,1,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{1,1007},{3,1087}]};

get_baby_equip_stren(3,1,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{1,1074},{3,1160}]};

get_baby_equip_stren(3,1,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{1,1141},{3,1232}]};

get_baby_equip_stren(3,1,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{1,1208},{3,1305}]};

get_baby_equip_stren(3,1,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{1,1275},{3,1377}]};

get_baby_equip_stren(3,1,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{1,1342},{3,1450}]};

get_baby_equip_stren(3,1,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{1,1409},{3,1522}]};

get_baby_equip_stren(3,1,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{1,1477},{3,1595}]};

get_baby_equip_stren(3,1,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{1,1544},{3,1667}]};

get_baby_equip_stren(3,2,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{1,1745},{3,1885}]};

get_baby_equip_stren(3,2,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{1,1812},{3,1957}]};

get_baby_equip_stren(3,2,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{1,1879},{3,2030}]};

get_baby_equip_stren(3,2,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{1,1946},{3,2102}]};

get_baby_equip_stren(3,2,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{1,2013},{3,2174}]};

get_baby_equip_stren(3,2,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{1,2081},{3,2247}]};

get_baby_equip_stren(3,2,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{1,2148},{3,2319}]};

get_baby_equip_stren(3,2,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{1,2215},{3,2392}]};

get_baby_equip_stren(3,2,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{1,2282},{3,2464}]};

get_baby_equip_stren(3,2,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{1,2349},{3,2537}]};

get_baby_equip_stren(3,2,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{1,2416},{3,2609}]};

get_baby_equip_stren(3,3,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{1,2617},{3,2827}]};

get_baby_equip_stren(3,3,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{1,2685},{3,2899}]};

get_baby_equip_stren(3,3,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{1,2752},{3,2972}]};

get_baby_equip_stren(3,3,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{1,2819},{3,3044}]};

get_baby_equip_stren(3,3,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{1,2886},{3,3117}]};

get_baby_equip_stren(3,3,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{1,2953},{3,3189}]};

get_baby_equip_stren(3,3,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{1,3020},{3,3262}]};

get_baby_equip_stren(3,3,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{1,3087},{3,3334}]};

get_baby_equip_stren(3,3,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{1,3154},{3,3407}]};

get_baby_equip_stren(3,3,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{1,3221},{3,3479}]};

get_baby_equip_stren(3,3,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{1,3289},{3,3552}]};

get_baby_equip_stren(3,4,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{1,3490},{3,3769}]};

get_baby_equip_stren(3,4,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{1,3557},{3,3842}]};

get_baby_equip_stren(3,4,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{1,3624},{3,3914}]};

get_baby_equip_stren(3,4,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{1,3691},{3,3987}]};

get_baby_equip_stren(3,4,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{1,3758},{3,4059}]};

get_baby_equip_stren(3,4,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{1,3826},{3,4132}]};

get_baby_equip_stren(3,4,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{1,3893},{3,4204}]};

get_baby_equip_stren(3,4,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{1,3960},{3,4277}]};

get_baby_equip_stren(3,4,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{1,4027},{3,4349}]};

get_baby_equip_stren(3,4,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{1,4094},{3,4421}]};

get_baby_equip_stren(3,4,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{1,4161},{3,4494}]};

get_baby_equip_stren(3,5,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{1,4362},{3,4711}]};

get_baby_equip_stren(3,5,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{1,4430},{3,4784}]};

get_baby_equip_stren(3,5,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{1,4497},{3,4856}]};

get_baby_equip_stren(3,5,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{1,4564},{3,4929}]};

get_baby_equip_stren(3,5,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{1,4631},{3,5001}]};

get_baby_equip_stren(3,5,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{1,4698},{3,5074}]};

get_baby_equip_stren(3,5,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{1,4765},{3,5146}]};

get_baby_equip_stren(3,5,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{1,4832},{3,5219}]};

get_baby_equip_stren(3,5,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{1,4899},{3,5291}]};

get_baby_equip_stren(3,5,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{1,4966},{3,5364}]};

get_baby_equip_stren(3,5,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{1,5034},{3,5436}]};

get_baby_equip_stren(3,6,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{1,5235},{3,5654}]};

get_baby_equip_stren(3,6,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{1,5302},{3,5726}]};

get_baby_equip_stren(3,6,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{1,5369},{3,5799}]};

get_baby_equip_stren(3,6,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{1,5436},{3,5871}]};

get_baby_equip_stren(3,6,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{1,5503},{3,5944}]};

get_baby_equip_stren(3,6,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{1,5570},{3,6016}]};

get_baby_equip_stren(3,6,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{1,5638},{3,6089}]};

get_baby_equip_stren(3,6,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{1,5705},{3,6161}]};

get_baby_equip_stren(3,6,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{1,5772},{3,6234}]};

get_baby_equip_stren(3,6,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{1,5839},{3,6306}]};

get_baby_equip_stren(3,6,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{1,5906},{3,6379}]};

get_baby_equip_stren(3,7,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{1,6107},{3,6596}]};

get_baby_equip_stren(3,7,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{1,6174},{3,6668}]};

get_baby_equip_stren(3,7,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{1,6242},{3,6741}]};

get_baby_equip_stren(3,7,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{1,6309},{3,6813}]};

get_baby_equip_stren(3,7,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{1,6376},{3,6886}]};

get_baby_equip_stren(3,7,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{1,6443},{3,6958}]};

get_baby_equip_stren(3,7,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{1,6510},{3,7031}]};

get_baby_equip_stren(3,7,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{1,6577},{3,7103}]};

get_baby_equip_stren(3,7,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{1,6644},{3,7176}]};

get_baby_equip_stren(3,7,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{1,6711},{3,7248}]};

get_baby_equip_stren(3,7,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{1,6779},{3,7321}]};

get_baby_equip_stren(3,8,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{1,6980},{3,7538}]};

get_baby_equip_stren(3,8,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{1,7047},{3,7611}]};

get_baby_equip_stren(3,8,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{1,7114},{3,7683}]};

get_baby_equip_stren(3,8,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{1,7181},{3,7756}]};

get_baby_equip_stren(3,8,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{1,7248},{3,7828}]};

get_baby_equip_stren(3,8,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{1,7315},{3,7901}]};

get_baby_equip_stren(3,8,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{1,7383},{3,7973}]};

get_baby_equip_stren(3,8,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{1,7450},{3,8046}]};

get_baby_equip_stren(3,8,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{1,7517},{3,8118}]};

get_baby_equip_stren(3,8,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{1,7584},{3,8191}]};

get_baby_equip_stren(3,8,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{1,7651},{3,8263}]};

get_baby_equip_stren(3,9,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{1,7852},{3,8481}]};

get_baby_equip_stren(3,9,1) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{1,7919},{3,8553}]};

get_baby_equip_stren(3,9,2) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{1,7987},{3,8626}]};

get_baby_equip_stren(3,9,3) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{1,8054},{3,8698}]};

get_baby_equip_stren(3,9,4) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{1,8121},{3,8770}]};

get_baby_equip_stren(3,9,5) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{1,8188},{3,8843}]};

get_baby_equip_stren(3,9,6) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{1,8255},{3,8915}]};

get_baby_equip_stren(3,9,7) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{1,8322},{3,8988}]};

get_baby_equip_stren(3,9,8) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{1,8389},{3,9060}]};

get_baby_equip_stren(3,9,9) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{1,8456},{3,9133}]};

get_baby_equip_stren(3,9,10) ->
	#base_baby_equip_stren{pos_id = 3,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{1,8523},{3,9205}]};

get_baby_equip_stren(3,10,0) ->
	#base_baby_equip_stren{pos_id = 3,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{1,8725},{3,9423}]};

get_baby_equip_stren(4,0,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{4,72},{2,1342}]};

get_baby_equip_stren(4,0,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{4,145},{2,2685}]};

get_baby_equip_stren(4,0,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{4,217},{2,4027}]};

get_baby_equip_stren(4,0,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{4,290},{2,5369}]};

get_baby_equip_stren(4,0,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{4,362},{2,6711}]};

get_baby_equip_stren(4,0,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{4,435},{2,8054}]};

get_baby_equip_stren(4,0,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{4,507},{2,9396}]};

get_baby_equip_stren(4,0,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{4,580},{2,10738}]};

get_baby_equip_stren(4,0,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{4,652},{2,12081}]};

get_baby_equip_stren(4,0,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{4,725},{2,13423}]};

get_baby_equip_stren(4,1,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{4,942},{2,17450}]};

get_baby_equip_stren(4,1,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{4,1015},{2,18792}]};

get_baby_equip_stren(4,1,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{4,1087},{2,20134}]};

get_baby_equip_stren(4,1,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{4,1160},{2,21477}]};

get_baby_equip_stren(4,1,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{4,1232},{2,22819}]};

get_baby_equip_stren(4,1,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{4,1305},{2,24161}]};

get_baby_equip_stren(4,1,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{4,1377},{2,25503}]};

get_baby_equip_stren(4,1,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{4,1450},{2,26846}]};

get_baby_equip_stren(4,1,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{4,1522},{2,28188}]};

get_baby_equip_stren(4,1,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{4,1595},{2,29530}]};

get_baby_equip_stren(4,1,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{4,1667},{2,30872}]};

get_baby_equip_stren(4,2,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{4,1885},{2,34899}]};

get_baby_equip_stren(4,2,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{4,1957},{2,36242}]};

get_baby_equip_stren(4,2,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{4,2030},{2,37584}]};

get_baby_equip_stren(4,2,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{4,2102},{2,38926}]};

get_baby_equip_stren(4,2,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{4,2174},{2,40268}]};

get_baby_equip_stren(4,2,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{4,2247},{2,41611}]};

get_baby_equip_stren(4,2,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{4,2319},{2,42953}]};

get_baby_equip_stren(4,2,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{4,2392},{2,44295}]};

get_baby_equip_stren(4,2,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{4,2464},{2,45638}]};

get_baby_equip_stren(4,2,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{4,2537},{2,46980}]};

get_baby_equip_stren(4,2,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{4,2609},{2,48322}]};

get_baby_equip_stren(4,3,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{4,2827},{2,52349}]};

get_baby_equip_stren(4,3,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{4,2899},{2,53691}]};

get_baby_equip_stren(4,3,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{4,2972},{2,55034}]};

get_baby_equip_stren(4,3,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{4,3044},{2,56376}]};

get_baby_equip_stren(4,3,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{4,3117},{2,57718}]};

get_baby_equip_stren(4,3,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{4,3189},{2,59060}]};

get_baby_equip_stren(4,3,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{4,3262},{2,60403}]};

get_baby_equip_stren(4,3,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{4,3334},{2,61745}]};

get_baby_equip_stren(4,3,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{4,3407},{2,63087}]};

get_baby_equip_stren(4,3,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{4,3479},{2,64430}]};

get_baby_equip_stren(4,3,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{4,3552},{2,65772}]};

get_baby_equip_stren(4,4,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{4,3769},{2,69799}]};

get_baby_equip_stren(4,4,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{4,3842},{2,71141}]};

get_baby_equip_stren(4,4,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{4,3914},{2,72483}]};

get_baby_equip_stren(4,4,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{4,3987},{2,73826}]};

get_baby_equip_stren(4,4,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{4,4059},{2,75168}]};

get_baby_equip_stren(4,4,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{4,4132},{2,76510}]};

get_baby_equip_stren(4,4,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{4,4204},{2,77852}]};

get_baby_equip_stren(4,4,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{4,4277},{2,79195}]};

get_baby_equip_stren(4,4,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{4,4349},{2,80537}]};

get_baby_equip_stren(4,4,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{4,4421},{2,81879}]};

get_baby_equip_stren(4,4,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{4,4494},{2,83221}]};

get_baby_equip_stren(4,5,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{4,4711},{2,87248}]};

get_baby_equip_stren(4,5,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{4,4784},{2,88591}]};

get_baby_equip_stren(4,5,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{4,4856},{2,89933}]};

get_baby_equip_stren(4,5,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{4,4929},{2,91275}]};

get_baby_equip_stren(4,5,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{4,5001},{2,92617}]};

get_baby_equip_stren(4,5,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{4,5074},{2,93960}]};

get_baby_equip_stren(4,5,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{4,5146},{2,95302}]};

get_baby_equip_stren(4,5,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{4,5219},{2,96644}]};

get_baby_equip_stren(4,5,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{4,5291},{2,97987}]};

get_baby_equip_stren(4,5,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{4,5364},{2,99329}]};

get_baby_equip_stren(4,5,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{4,5436},{2,100671}]};

get_baby_equip_stren(4,6,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{4,5654},{2,104698}]};

get_baby_equip_stren(4,6,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{4,5726},{2,106040}]};

get_baby_equip_stren(4,6,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{4,5799},{2,107383}]};

get_baby_equip_stren(4,6,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{4,5871},{2,108725}]};

get_baby_equip_stren(4,6,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{4,5944},{2,110067}]};

get_baby_equip_stren(4,6,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{4,6016},{2,111409}]};

get_baby_equip_stren(4,6,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{4,6089},{2,112752}]};

get_baby_equip_stren(4,6,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{4,6161},{2,114094}]};

get_baby_equip_stren(4,6,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{4,6234},{2,115436}]};

get_baby_equip_stren(4,6,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{4,6306},{2,116779}]};

get_baby_equip_stren(4,6,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{4,6379},{2,118121}]};

get_baby_equip_stren(4,7,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{4,6596},{2,122148}]};

get_baby_equip_stren(4,7,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{4,6668},{2,123490}]};

get_baby_equip_stren(4,7,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{4,6741},{2,124832}]};

get_baby_equip_stren(4,7,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{4,6813},{2,126174}]};

get_baby_equip_stren(4,7,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{4,6886},{2,127517}]};

get_baby_equip_stren(4,7,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{4,6958},{2,128859}]};

get_baby_equip_stren(4,7,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{4,7031},{2,130201}]};

get_baby_equip_stren(4,7,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{4,7103},{2,131544}]};

get_baby_equip_stren(4,7,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{4,7176},{2,132886}]};

get_baby_equip_stren(4,7,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{4,7248},{2,134228}]};

get_baby_equip_stren(4,7,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{4,7321},{2,135570}]};

get_baby_equip_stren(4,8,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{4,7538},{2,139597}]};

get_baby_equip_stren(4,8,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{4,7611},{2,140940}]};

get_baby_equip_stren(4,8,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{4,7683},{2,142282}]};

get_baby_equip_stren(4,8,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{4,7756},{2,143624}]};

get_baby_equip_stren(4,8,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{4,7828},{2,144966}]};

get_baby_equip_stren(4,8,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{4,7901},{2,146309}]};

get_baby_equip_stren(4,8,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{4,7973},{2,147651}]};

get_baby_equip_stren(4,8,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{4,8046},{2,148993}]};

get_baby_equip_stren(4,8,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{4,8118},{2,150336}]};

get_baby_equip_stren(4,8,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{4,8191},{2,151678}]};

get_baby_equip_stren(4,8,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{4,8263},{2,153020}]};

get_baby_equip_stren(4,9,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{4,8481},{2,157047}]};

get_baby_equip_stren(4,9,1) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{4,8553},{2,158389}]};

get_baby_equip_stren(4,9,2) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{4,8626},{2,159732}]};

get_baby_equip_stren(4,9,3) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{4,8698},{2,161074}]};

get_baby_equip_stren(4,9,4) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{4,8770},{2,162416}]};

get_baby_equip_stren(4,9,5) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{4,8843},{2,163758}]};

get_baby_equip_stren(4,9,6) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{4,8915},{2,165101}]};

get_baby_equip_stren(4,9,7) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{4,8988},{2,166443}]};

get_baby_equip_stren(4,9,8) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{4,9060},{2,167785}]};

get_baby_equip_stren(4,9,9) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{4,9133},{2,169128}]};

get_baby_equip_stren(4,9,10) ->
	#base_baby_equip_stren{pos_id = 4,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{4,9205},{2,170470}]};

get_baby_equip_stren(4,10,0) ->
	#base_baby_equip_stren{pos_id = 4,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{4,9423},{2,174497}]};

get_baby_equip_stren(5,0,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{1,67},{3,16},{2,1342}]};

get_baby_equip_stren(5,0,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{1,134},{3,32},{2,2685}]};

get_baby_equip_stren(5,0,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{1,201},{3,48},{2,4027}]};

get_baby_equip_stren(5,0,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{1,268},{3,64},{2,5369}]};

get_baby_equip_stren(5,0,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{1,336},{3,81},{2,6711}]};

get_baby_equip_stren(5,0,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{1,403},{3,97},{2,8054}]};

get_baby_equip_stren(5,0,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{1,470},{3,113},{2,9396}]};

get_baby_equip_stren(5,0,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{1,537},{3,129},{2,10738}]};

get_baby_equip_stren(5,0,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{1,604},{3,145},{2,12081}]};

get_baby_equip_stren(5,0,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{1,671},{3,161},{2,13423}]};

get_baby_equip_stren(5,1,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{1,872},{3,209},{2,17450}]};

get_baby_equip_stren(5,1,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{1,940},{3,226},{2,18792}]};

get_baby_equip_stren(5,1,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{1,1007},{3,242},{2,20134}]};

get_baby_equip_stren(5,1,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{1,1074},{3,258},{2,21477}]};

get_baby_equip_stren(5,1,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{1,1141},{3,274},{2,22819}]};

get_baby_equip_stren(5,1,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{1,1208},{3,290},{2,24161}]};

get_baby_equip_stren(5,1,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{1,1275},{3,306},{2,25503}]};

get_baby_equip_stren(5,1,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{1,1342},{3,322},{2,26846}]};

get_baby_equip_stren(5,1,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{1,1409},{3,338},{2,28188}]};

get_baby_equip_stren(5,1,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{1,1477},{3,354},{2,29530}]};

get_baby_equip_stren(5,1,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{1,1544},{3,370},{2,30872}]};

get_baby_equip_stren(5,2,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{1,1745},{3,419},{2,34899}]};

get_baby_equip_stren(5,2,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{1,1812},{3,435},{2,36242}]};

get_baby_equip_stren(5,2,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{1,1879},{3,451},{2,37584}]};

get_baby_equip_stren(5,2,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{1,1946},{3,467},{2,38926}]};

get_baby_equip_stren(5,2,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{1,2013},{3,483},{2,40268}]};

get_baby_equip_stren(5,2,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{1,2081},{3,499},{2,41611}]};

get_baby_equip_stren(5,2,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{1,2148},{3,515},{2,42953}]};

get_baby_equip_stren(5,2,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{1,2215},{3,532},{2,44295}]};

get_baby_equip_stren(5,2,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{1,2282},{3,548},{2,45638}]};

get_baby_equip_stren(5,2,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{1,2349},{3,564},{2,46980}]};

get_baby_equip_stren(5,2,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{1,2416},{3,580},{2,48322}]};

get_baby_equip_stren(5,3,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{1,2617},{3,628},{2,52349}]};

get_baby_equip_stren(5,3,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{1,2685},{3,644},{2,53691}]};

get_baby_equip_stren(5,3,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{1,2752},{3,660},{2,55034}]};

get_baby_equip_stren(5,3,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{1,2819},{3,677},{2,56376}]};

get_baby_equip_stren(5,3,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{1,2886},{3,693},{2,57718}]};

get_baby_equip_stren(5,3,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{1,2953},{3,709},{2,59060}]};

get_baby_equip_stren(5,3,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{1,3020},{3,725},{2,60403}]};

get_baby_equip_stren(5,3,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{1,3087},{3,741},{2,61745}]};

get_baby_equip_stren(5,3,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{1,3154},{3,757},{2,63087}]};

get_baby_equip_stren(5,3,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{1,3221},{3,773},{2,64430}]};

get_baby_equip_stren(5,3,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{1,3289},{3,789},{2,65772}]};

get_baby_equip_stren(5,4,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{1,3490},{3,838},{2,69799}]};

get_baby_equip_stren(5,4,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{1,3557},{3,854},{2,71141}]};

get_baby_equip_stren(5,4,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{1,3624},{3,870},{2,72483}]};

get_baby_equip_stren(5,4,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{1,3691},{3,886},{2,73826}]};

get_baby_equip_stren(5,4,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{1,3758},{3,902},{2,75168}]};

get_baby_equip_stren(5,4,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{1,3826},{3,918},{2,76510}]};

get_baby_equip_stren(5,4,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{1,3893},{3,934},{2,77852}]};

get_baby_equip_stren(5,4,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{1,3960},{3,950},{2,79195}]};

get_baby_equip_stren(5,4,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{1,4027},{3,966},{2,80537}]};

get_baby_equip_stren(5,4,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{1,4094},{3,983},{2,81879}]};

get_baby_equip_stren(5,4,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{1,4161},{3,999},{2,83221}]};

get_baby_equip_stren(5,5,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{1,4362},{3,1047},{2,87248}]};

get_baby_equip_stren(5,5,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{1,4430},{3,1063},{2,88591}]};

get_baby_equip_stren(5,5,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{1,4497},{3,1079},{2,89933}]};

get_baby_equip_stren(5,5,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{1,4564},{3,1095},{2,91275}]};

get_baby_equip_stren(5,5,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{1,4631},{3,1111},{2,92617}]};

get_baby_equip_stren(5,5,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{1,4698},{3,1128},{2,93960}]};

get_baby_equip_stren(5,5,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{1,4765},{3,1144},{2,95302}]};

get_baby_equip_stren(5,5,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{1,4832},{3,1160},{2,96644}]};

get_baby_equip_stren(5,5,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{1,4899},{3,1176},{2,97987}]};

get_baby_equip_stren(5,5,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{1,4966},{3,1192},{2,99329}]};

get_baby_equip_stren(5,5,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{1,5034},{3,1208},{2,100671}]};

get_baby_equip_stren(5,6,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{1,5235},{3,1256},{2,104698}]};

get_baby_equip_stren(5,6,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{1,5302},{3,1272},{2,106040}]};

get_baby_equip_stren(5,6,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{1,5369},{3,1289},{2,107383}]};

get_baby_equip_stren(5,6,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{1,5436},{3,1305},{2,108725}]};

get_baby_equip_stren(5,6,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{1,5503},{3,1321},{2,110067}]};

get_baby_equip_stren(5,6,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{1,5570},{3,1337},{2,111409}]};

get_baby_equip_stren(5,6,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{1,5638},{3,1353},{2,112752}]};

get_baby_equip_stren(5,6,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{1,5705},{3,1369},{2,114094}]};

get_baby_equip_stren(5,6,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{1,5772},{3,1385},{2,115436}]};

get_baby_equip_stren(5,6,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{1,5839},{3,1401},{2,116779}]};

get_baby_equip_stren(5,6,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{1,5906},{3,1417},{2,118121}]};

get_baby_equip_stren(5,7,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{1,6107},{3,1466},{2,122148}]};

get_baby_equip_stren(5,7,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{1,6174},{3,1482},{2,123490}]};

get_baby_equip_stren(5,7,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{1,6242},{3,1498},{2,124832}]};

get_baby_equip_stren(5,7,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{1,6309},{3,1514},{2,126174}]};

get_baby_equip_stren(5,7,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{1,6376},{3,1530},{2,127517}]};

get_baby_equip_stren(5,7,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{1,6443},{3,1546},{2,128859}]};

get_baby_equip_stren(5,7,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{1,6510},{3,1562},{2,130201}]};

get_baby_equip_stren(5,7,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{1,6577},{3,1579},{2,131544}]};

get_baby_equip_stren(5,7,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{1,6644},{3,1595},{2,132886}]};

get_baby_equip_stren(5,7,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{1,6711},{3,1611},{2,134228}]};

get_baby_equip_stren(5,7,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{1,6779},{3,1627},{2,135570}]};

get_baby_equip_stren(5,8,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{1,6980},{3,1675},{2,139597}]};

get_baby_equip_stren(5,8,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{1,7047},{3,1691},{2,140940}]};

get_baby_equip_stren(5,8,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{1,7114},{3,1707},{2,142282}]};

get_baby_equip_stren(5,8,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{1,7181},{3,1723},{2,143624}]};

get_baby_equip_stren(5,8,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{1,7248},{3,1740},{2,144966}]};

get_baby_equip_stren(5,8,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{1,7315},{3,1756},{2,146309}]};

get_baby_equip_stren(5,8,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{1,7383},{3,1772},{2,147651}]};

get_baby_equip_stren(5,8,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{1,7450},{3,1788},{2,148993}]};

get_baby_equip_stren(5,8,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{1,7517},{3,1804},{2,150336}]};

get_baby_equip_stren(5,8,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{1,7584},{3,1820},{2,151678}]};

get_baby_equip_stren(5,8,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{1,7651},{3,1836},{2,153020}]};

get_baby_equip_stren(5,9,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{1,7852},{3,1885},{2,157047}]};

get_baby_equip_stren(5,9,1) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{1,7919},{3,1901},{2,158389}]};

get_baby_equip_stren(5,9,2) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{1,7987},{3,1917},{2,159732}]};

get_baby_equip_stren(5,9,3) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{1,8054},{3,1933},{2,161074}]};

get_baby_equip_stren(5,9,4) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{1,8121},{3,1949},{2,162416}]};

get_baby_equip_stren(5,9,5) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{1,8188},{3,1965},{2,163758}]};

get_baby_equip_stren(5,9,6) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{1,8255},{3,1981},{2,165101}]};

get_baby_equip_stren(5,9,7) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{1,8322},{3,1997},{2,166443}]};

get_baby_equip_stren(5,9,8) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{1,8389},{3,2013},{2,167785}]};

get_baby_equip_stren(5,9,9) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{1,8456},{3,2030},{2,169128}]};

get_baby_equip_stren(5,9,10) ->
	#base_baby_equip_stren{pos_id = 5,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{1,8523},{3,2046},{2,170470}]};

get_baby_equip_stren(5,10,0) ->
	#base_baby_equip_stren{pos_id = 5,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{1,8725},{3,2094},{2,174497}]};

get_baby_equip_stren(6,0,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 1,point_con = 10,base_attr = [{1,67},{2,1342},{4,16}]};

get_baby_equip_stren(6,0,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 2,point_con = 11,base_attr = [{1,134},{2,2685},{4,32}]};

get_baby_equip_stren(6,0,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 3,point_con = 12,base_attr = [{1,201},{2,4027},{4,48}]};

get_baby_equip_stren(6,0,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 4,point_con = 13,base_attr = [{1,268},{2,5369},{4,64}]};

get_baby_equip_stren(6,0,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 5,point_con = 15,base_attr = [{1,336},{2,6711},{4,81}]};

get_baby_equip_stren(6,0,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 6,point_con = 16,base_attr = [{1,403},{2,8054},{4,97}]};

get_baby_equip_stren(6,0,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 7,point_con = 18,base_attr = [{1,470},{2,9396},{4,113}]};

get_baby_equip_stren(6,0,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 8,point_con = 19,base_attr = [{1,537},{2,10738},{4,129}]};

get_baby_equip_stren(6,0,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 9,point_con = 21,base_attr = [{1,604},{2,12081},{4,145}]};

get_baby_equip_stren(6,0,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 0,stage_lv = 10,point_con = 0,base_attr = [{1,671},{2,13423},{4,161}]};

get_baby_equip_stren(6,1,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 0,point_con = 24,base_attr = [{1,872},{2,17450},{4,209}]};

get_baby_equip_stren(6,1,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 1,point_con = 25,base_attr = [{1,940},{2,18792},{4,226}]};

get_baby_equip_stren(6,1,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 2,point_con = 28,base_attr = [{1,1007},{2,20134},{4,242}]};

get_baby_equip_stren(6,1,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 3,point_con = 30,base_attr = [{1,1074},{2,21477},{4,258}]};

get_baby_equip_stren(6,1,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 4,point_con = 32,base_attr = [{1,1141},{2,22819},{4,274}]};

get_baby_equip_stren(6,1,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 5,point_con = 35,base_attr = [{1,1208},{2,24161},{4,290}]};

get_baby_equip_stren(6,1,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 6,point_con = 37,base_attr = [{1,1275},{2,25503},{4,306}]};

get_baby_equip_stren(6,1,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 7,point_con = 40,base_attr = [{1,1342},{2,26846},{4,322}]};

get_baby_equip_stren(6,1,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 8,point_con = 44,base_attr = [{1,1409},{2,28188},{4,338}]};

get_baby_equip_stren(6,1,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 9,point_con = 0,base_attr = [{1,1477},{2,29530},{4,354}]};

get_baby_equip_stren(6,1,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 1,stage_lv = 10,point_con = 47,base_attr = [{1,1544},{2,30872},{4,370}]};

get_baby_equip_stren(6,2,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 0,point_con = 51,base_attr = [{1,1745},{2,34899},{4,419}]};

get_baby_equip_stren(6,2,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 1,point_con = 54,base_attr = [{1,1812},{2,36242},{4,435}]};

get_baby_equip_stren(6,2,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 2,point_con = 58,base_attr = [{1,1879},{2,37584},{4,451}]};

get_baby_equip_stren(6,2,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 3,point_con = 62,base_attr = [{1,1946},{2,38926},{4,467}]};

get_baby_equip_stren(6,2,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 4,point_con = 67,base_attr = [{1,2013},{2,40268},{4,483}]};

get_baby_equip_stren(6,2,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 5,point_con = 71,base_attr = [{1,2081},{2,41611},{4,499}]};

get_baby_equip_stren(6,2,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 6,point_con = 76,base_attr = [{1,2148},{2,42953},{4,515}]};

get_baby_equip_stren(6,2,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 7,point_con = 82,base_attr = [{1,2215},{2,44295},{4,532}]};

get_baby_equip_stren(6,2,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 8,point_con = 87,base_attr = [{1,2282},{2,45638},{4,548}]};

get_baby_equip_stren(6,2,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 9,point_con = 0,base_attr = [{1,2349},{2,46980},{4,564}]};

get_baby_equip_stren(6,2,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 2,stage_lv = 10,point_con = 94,base_attr = [{1,2416},{2,48322},{4,580}]};

get_baby_equip_stren(6,3,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 0,point_con = 100,base_attr = [{1,2617},{2,52349},{4,628}]};

get_baby_equip_stren(6,3,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 1,point_con = 107,base_attr = [{1,2685},{2,53691},{4,644}]};

get_baby_equip_stren(6,3,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 2,point_con = 115,base_attr = [{1,2752},{2,55034},{4,660}]};

get_baby_equip_stren(6,3,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 3,point_con = 123,base_attr = [{1,2819},{2,56376},{4,677}]};

get_baby_equip_stren(6,3,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 4,point_con = 131,base_attr = [{1,2886},{2,57718},{4,693}]};

get_baby_equip_stren(6,3,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 5,point_con = 140,base_attr = [{1,2953},{2,59060},{4,709}]};

get_baby_equip_stren(6,3,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 6,point_con = 150,base_attr = [{1,3020},{2,60403},{4,725}]};

get_baby_equip_stren(6,3,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 7,point_con = 161,base_attr = [{1,3087},{2,61745},{4,741}]};

get_baby_equip_stren(6,3,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 8,point_con = 172,base_attr = [{1,3154},{2,63087},{4,757}]};

get_baby_equip_stren(6,3,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 9,point_con = 0,base_attr = [{1,3221},{2,64430},{4,773}]};

get_baby_equip_stren(6,3,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 3,stage_lv = 10,point_con = 184,base_attr = [{1,3289},{2,65772},{4,789}]};

get_baby_equip_stren(6,4,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 0,point_con = 197,base_attr = [{1,3490},{2,69799},{4,838}]};

get_baby_equip_stren(6,4,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 1,point_con = 207,base_attr = [{1,3557},{2,71141},{4,854}]};

get_baby_equip_stren(6,4,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 2,point_con = 217,base_attr = [{1,3624},{2,72483},{4,870}]};

get_baby_equip_stren(6,4,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 3,point_con = 228,base_attr = [{1,3691},{2,73826},{4,886}]};

get_baby_equip_stren(6,4,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 4,point_con = 239,base_attr = [{1,3758},{2,75168},{4,902}]};

get_baby_equip_stren(6,4,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 5,point_con = 251,base_attr = [{1,3826},{2,76510},{4,918}]};

get_baby_equip_stren(6,4,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 6,point_con = 264,base_attr = [{1,3893},{2,77852},{4,934}]};

get_baby_equip_stren(6,4,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 7,point_con = 277,base_attr = [{1,3960},{2,79195},{4,950}]};

get_baby_equip_stren(6,4,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 8,point_con = 291,base_attr = [{1,4027},{2,80537},{4,966}]};

get_baby_equip_stren(6,4,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 9,point_con = 0,base_attr = [{1,4094},{2,81879},{4,983}]};

get_baby_equip_stren(6,4,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 4,stage_lv = 10,point_con = 306,base_attr = [{1,4161},{2,83221},{4,999}]};

get_baby_equip_stren(6,5,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 0,point_con = 321,base_attr = [{1,4362},{2,87248},{4,1047}]};

get_baby_equip_stren(6,5,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 1,point_con = 337,base_attr = [{1,4430},{2,88591},{4,1063}]};

get_baby_equip_stren(6,5,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 2,point_con = 354,base_attr = [{1,4497},{2,89933},{4,1079}]};

get_baby_equip_stren(6,5,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 3,point_con = 371,base_attr = [{1,4564},{2,91275},{4,1095}]};

get_baby_equip_stren(6,5,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 4,point_con = 390,base_attr = [{1,4631},{2,92617},{4,1111}]};

get_baby_equip_stren(6,5,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 5,point_con = 410,base_attr = [{1,4698},{2,93960},{4,1128}]};

get_baby_equip_stren(6,5,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 6,point_con = 430,base_attr = [{1,4765},{2,95302},{4,1144}]};

get_baby_equip_stren(6,5,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 7,point_con = 452,base_attr = [{1,4832},{2,96644},{4,1160}]};

get_baby_equip_stren(6,5,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 8,point_con = 474,base_attr = [{1,4899},{2,97987},{4,1176}]};

get_baby_equip_stren(6,5,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 9,point_con = 0,base_attr = [{1,4966},{2,99329},{4,1192}]};

get_baby_equip_stren(6,5,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 5,stage_lv = 10,point_con = 498,base_attr = [{1,5034},{2,100671},{4,1208}]};

get_baby_equip_stren(6,6,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 0,point_con = 523,base_attr = [{1,5235},{2,104698},{4,1256}]};

get_baby_equip_stren(6,6,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 1,point_con = 541,base_attr = [{1,5302},{2,106040},{4,1272}]};

get_baby_equip_stren(6,6,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 2,point_con = 560,base_attr = [{1,5369},{2,107383},{4,1289}]};

get_baby_equip_stren(6,6,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 3,point_con = 580,base_attr = [{1,5436},{2,108725},{4,1305}]};

get_baby_equip_stren(6,6,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 4,point_con = 600,base_attr = [{1,5503},{2,110067},{4,1321}]};

get_baby_equip_stren(6,6,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 5,point_con = 621,base_attr = [{1,5570},{2,111409},{4,1337}]};

get_baby_equip_stren(6,6,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 6,point_con = 643,base_attr = [{1,5638},{2,112752},{4,1353}]};

get_baby_equip_stren(6,6,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 7,point_con = 665,base_attr = [{1,5705},{2,114094},{4,1369}]};

get_baby_equip_stren(6,6,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 8,point_con = 688,base_attr = [{1,5772},{2,115436},{4,1385}]};

get_baby_equip_stren(6,6,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 9,point_con = 0,base_attr = [{1,5839},{2,116779},{4,1401}]};

get_baby_equip_stren(6,6,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 6,stage_lv = 10,point_con = 712,base_attr = [{1,5906},{2,118121},{4,1417}]};

get_baby_equip_stren(6,7,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 0,point_con = 737,base_attr = [{1,6107},{2,122148},{4,1466}]};

get_baby_equip_stren(6,7,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 1,point_con = 763,base_attr = [{1,6174},{2,123490},{4,1482}]};

get_baby_equip_stren(6,7,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 2,point_con = 790,base_attr = [{1,6242},{2,124832},{4,1498}]};

get_baby_equip_stren(6,7,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 3,point_con = 817,base_attr = [{1,6309},{2,126174},{4,1514}]};

get_baby_equip_stren(6,7,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 4,point_con = 846,base_attr = [{1,6376},{2,127517},{4,1530}]};

get_baby_equip_stren(6,7,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 5,point_con = 876,base_attr = [{1,6443},{2,128859},{4,1546}]};

get_baby_equip_stren(6,7,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 6,point_con = 906,base_attr = [{1,6510},{2,130201},{4,1562}]};

get_baby_equip_stren(6,7,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 7,point_con = 938,base_attr = [{1,6577},{2,131544},{4,1579}]};

get_baby_equip_stren(6,7,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 8,point_con = 971,base_attr = [{1,6644},{2,132886},{4,1595}]};

get_baby_equip_stren(6,7,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 9,point_con = 0,base_attr = [{1,6711},{2,134228},{4,1611}]};

get_baby_equip_stren(6,7,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 7,stage_lv = 10,point_con = 1005,base_attr = [{1,6779},{2,135570},{4,1627}]};

get_baby_equip_stren(6,8,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 0,point_con = 1040,base_attr = [{1,6980},{2,139597},{4,1675}]};

get_baby_equip_stren(6,8,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 1,point_con = 1056,base_attr = [{1,7047},{2,140940},{4,1691}]};

get_baby_equip_stren(6,8,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 2,point_con = 1071,base_attr = [{1,7114},{2,142282},{4,1707}]};

get_baby_equip_stren(6,8,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 3,point_con = 1088,base_attr = [{1,7181},{2,143624},{4,1723}]};

get_baby_equip_stren(6,8,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 4,point_con = 1104,base_attr = [{1,7248},{2,144966},{4,1740}]};

get_baby_equip_stren(6,8,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 5,point_con = 1120,base_attr = [{1,7315},{2,146309},{4,1756}]};

get_baby_equip_stren(6,8,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 6,point_con = 1137,base_attr = [{1,7383},{2,147651},{4,1772}]};

get_baby_equip_stren(6,8,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 7,point_con = 1154,base_attr = [{1,7450},{2,148993},{4,1788}]};

get_baby_equip_stren(6,8,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 8,point_con = 1172,base_attr = [{1,7517},{2,150336},{4,1804}]};

get_baby_equip_stren(6,8,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 9,point_con = 0,base_attr = [{1,7584},{2,151678},{4,1820}]};

get_baby_equip_stren(6,8,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 8,stage_lv = 10,point_con = 1189,base_attr = [{1,7651},{2,153020},{4,1836}]};

get_baby_equip_stren(6,9,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 0,point_con = 1207,base_attr = [{1,7852},{2,157047},{4,1885}]};

get_baby_equip_stren(6,9,1) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 1,point_con = 1225,base_attr = [{1,7919},{2,158389},{4,1901}]};

get_baby_equip_stren(6,9,2) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 2,point_con = 1243,base_attr = [{1,7987},{2,159732},{4,1917}]};

get_baby_equip_stren(6,9,3) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 3,point_con = 1262,base_attr = [{1,8054},{2,161074},{4,1933}]};

get_baby_equip_stren(6,9,4) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 4,point_con = 1281,base_attr = [{1,8121},{2,162416},{4,1949}]};

get_baby_equip_stren(6,9,5) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 5,point_con = 1300,base_attr = [{1,8188},{2,163758},{4,1965}]};

get_baby_equip_stren(6,9,6) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 6,point_con = 1320,base_attr = [{1,8255},{2,165101},{4,1981}]};

get_baby_equip_stren(6,9,7) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 7,point_con = 1340,base_attr = [{1,8322},{2,166443},{4,1997}]};

get_baby_equip_stren(6,9,8) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 8,point_con = 1360,base_attr = [{1,8389},{2,167785},{4,2013}]};

get_baby_equip_stren(6,9,9) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 9,point_con = 1380,base_attr = [{1,8456},{2,169128},{4,2030}]};

get_baby_equip_stren(6,9,10) ->
	#base_baby_equip_stren{pos_id = 6,stage = 9,stage_lv = 10,point_con = 0,base_attr = [{1,8523},{2,170470},{4,2046}]};

get_baby_equip_stren(6,10,0) ->
	#base_baby_equip_stren{pos_id = 6,stage = 10,stage_lv = 0,point_con = 0,base_attr = [{1,8725},{2,174497},{4,2094}]};

get_baby_equip_stren(_Posid,_Stage,_Stagelv) ->
	[].

get_equip_max_level(1,0) -> 10;
get_equip_max_level(1,1) -> 10;
get_equip_max_level(1,10) -> 0;
get_equip_max_level(1,2) -> 10;
get_equip_max_level(1,3) -> 10;
get_equip_max_level(1,4) -> 10;
get_equip_max_level(1,5) -> 10;
get_equip_max_level(1,6) -> 10;
get_equip_max_level(1,7) -> 10;
get_equip_max_level(1,8) -> 10;
get_equip_max_level(1,9) -> 10;
get_equip_max_level(2,0) -> 10;
get_equip_max_level(2,1) -> 10;
get_equip_max_level(2,10) -> 0;
get_equip_max_level(2,2) -> 10;
get_equip_max_level(2,3) -> 10;
get_equip_max_level(2,4) -> 10;
get_equip_max_level(2,5) -> 10;
get_equip_max_level(2,6) -> 10;
get_equip_max_level(2,7) -> 10;
get_equip_max_level(2,8) -> 10;
get_equip_max_level(2,9) -> 10;
get_equip_max_level(3,0) -> 10;
get_equip_max_level(3,1) -> 10;
get_equip_max_level(3,10) -> 0;
get_equip_max_level(3,2) -> 10;
get_equip_max_level(3,3) -> 10;
get_equip_max_level(3,4) -> 10;
get_equip_max_level(3,5) -> 10;
get_equip_max_level(3,6) -> 10;
get_equip_max_level(3,7) -> 10;
get_equip_max_level(3,8) -> 10;
get_equip_max_level(3,9) -> 10;
get_equip_max_level(4,0) -> 10;
get_equip_max_level(4,1) -> 10;
get_equip_max_level(4,10) -> 0;
get_equip_max_level(4,2) -> 10;
get_equip_max_level(4,3) -> 10;
get_equip_max_level(4,4) -> 10;
get_equip_max_level(4,5) -> 10;
get_equip_max_level(4,6) -> 10;
get_equip_max_level(4,7) -> 10;
get_equip_max_level(4,8) -> 10;
get_equip_max_level(4,9) -> 10;
get_equip_max_level(5,0) -> 10;
get_equip_max_level(5,1) -> 10;
get_equip_max_level(5,10) -> 0;
get_equip_max_level(5,2) -> 10;
get_equip_max_level(5,3) -> 10;
get_equip_max_level(5,4) -> 10;
get_equip_max_level(5,5) -> 10;
get_equip_max_level(5,6) -> 10;
get_equip_max_level(5,7) -> 10;
get_equip_max_level(5,8) -> 10;
get_equip_max_level(5,9) -> 10;
get_equip_max_level(6,0) -> 10;
get_equip_max_level(6,1) -> 10;
get_equip_max_level(6,10) -> 0;
get_equip_max_level(6,2) -> 10;
get_equip_max_level(6,3) -> 10;
get_equip_max_level(6,4) -> 10;
get_equip_max_level(6,5) -> 10;
get_equip_max_level(6,6) -> 10;
get_equip_max_level(6,7) -> 10;
get_equip_max_level(6,8) -> 10;
get_equip_max_level(6,9) -> 10;
get_equip_max_level(_Pos_id,_Stage) -> 0.

get_baby_equip_stage(1) ->
	#base_baby_equip_stage{stage = 1,cost = [{0,38040034,1}],base_attr = [{1,[{68,4000}]}, {2, [{68,4000}]}, {3, [{68,4000}]}, {4, [{68,4000}]}, {5, [{68,4000}]}, {6, [{68,4000}]}]};

get_baby_equip_stage(2) ->
	#base_baby_equip_stage{stage = 2,cost = [{0,38040034,2}],base_attr = [{1,[{68,8000}]}, {2, [{68,8000}]}, {3, [{68,8000}]}, {4, [{68,8000}]}, {5, [{68,8000}]}, {6, [{68,8000}]}]};

get_baby_equip_stage(3) ->
	#base_baby_equip_stage{stage = 3,cost = [{0,38040034,3}],base_attr = [{1,[{68,12000}]}, {2, [{68,12000}]}, {3, [{68,12000}]}, {4, [{68,12000}]}, {5, [{68,12000}]}, {6, [{68,12000}]}]};

get_baby_equip_stage(4) ->
	#base_baby_equip_stage{stage = 4,cost = [{0,38040034,5}],base_attr = [{1,[{68,16000}]}, {2, [{68,16000}]}, {3, [{68,16000}]}, {4, [{68,16000}]}, {5, [{68,16000}]}, {6, [{68,16000}]}]};

get_baby_equip_stage(5) ->
	#base_baby_equip_stage{stage = 5,cost = [{0,38040034,7},{0,38040035,1}],base_attr = [{1,[{68,20000}]}, {2, [{68,20000}]}, {3, [{68,20000}]}, {4, [{68,20000}]}, {5, [{68,20000}]}, {6, [{68,20000}]}]};

get_baby_equip_stage(6) ->
	#base_baby_equip_stage{stage = 6,cost = [{0,38040034,10},{0,38040035,2}],base_attr = [{1,[{68,24000}]}, {2, [{68,24000}]}, {3, [{68,24000}]}, {4, [{68,24000}]}, {5, [{68,24000}]}, {6, [{68,24000}]}]};

get_baby_equip_stage(7) ->
	#base_baby_equip_stage{stage = 7,cost = [{0,38040034,13},{0,38040035,3},{0,38040036,1}],base_attr = [{1,[{68,28000}]}, {2, [{68,28000}]}, {3, [{68,28000}]}, {4, [{68,28000}]}, {5, [{68,28000}]}, {6, [{68,28000}]}]};

get_baby_equip_stage(8) ->
	#base_baby_equip_stage{stage = 8,cost = [{0,38040034,16},{0,38040035,5},{0,38040036,2}],base_attr = [{1,[{68,32000}]}, {2, [{68,32000}]}, {3, [{68,32000}]}, {4, [{68,32000}]}, {5, [{68,32000}]}, {6, [{68,32000}]}]};

get_baby_equip_stage(9) ->
	#base_baby_equip_stage{stage = 9,cost = [{0,38040034,20},{0,38040035,7},{0,38040036,3}],base_attr = [{1,[{68,36000}]}, {2, [{68,36000}]}, {3, [{68,36000}]}, {4, [{68,36000}]}, {5, [{68,36000}]}, {6, [{68,36000}]}]};

get_baby_equip_stage(10) ->
	#base_baby_equip_stage{stage = 10,cost = [{0,38040034,25},{0,38040035,10},{0,38040036,5}],base_attr = [{1,[{68,40000}]}, {2, [{68,40000}]}, {3, [{68,40000}]}, {4, [{68,40000}]}, {5, [{68,40000}]}, {6, [{68,40000}]}]};

get_baby_equip_stage(_Stage) ->
	[].

get_baby_equip_engrave(2,38040037) ->
	#base_baby_equip_engrave{color = 2,goods_id = 38040037,num = 2,ratio = 500};

get_baby_equip_engrave(2,38040038) ->
	#base_baby_equip_engrave{color = 2,goods_id = 38040038,num = 2,ratio = 1000};

get_baby_equip_engrave(2,38040039) ->
	#base_baby_equip_engrave{color = 2,goods_id = 38040039,num = 1,ratio = 5000};

get_baby_equip_engrave(2,38040040) ->
	#base_baby_equip_engrave{color = 2,goods_id = 38040040,num = 1,ratio = 10000};

get_baby_equip_engrave(3,38040037) ->
	#base_baby_equip_engrave{color = 3,goods_id = 38040037,num = 4,ratio = 250};

get_baby_equip_engrave(3,38040038) ->
	#base_baby_equip_engrave{color = 3,goods_id = 38040038,num = 4,ratio = 500};

get_baby_equip_engrave(3,38040039) ->
	#base_baby_equip_engrave{color = 3,goods_id = 38040039,num = 1,ratio = 2500};

get_baby_equip_engrave(3,38040040) ->
	#base_baby_equip_engrave{color = 3,goods_id = 38040040,num = 1,ratio = 5000};

get_baby_equip_engrave(4,38040037) ->
	#base_baby_equip_engrave{color = 4,goods_id = 38040037,num = 6,ratio = 167};

get_baby_equip_engrave(4,38040038) ->
	#base_baby_equip_engrave{color = 4,goods_id = 38040038,num = 6,ratio = 333};

get_baby_equip_engrave(4,38040039) ->
	#base_baby_equip_engrave{color = 4,goods_id = 38040039,num = 1,ratio = 1667};

get_baby_equip_engrave(4,38040040) ->
	#base_baby_equip_engrave{color = 4,goods_id = 38040040,num = 1,ratio = 3333};

get_baby_equip_engrave(5,38040037) ->
	#base_baby_equip_engrave{color = 5,goods_id = 38040037,num = 8,ratio = 125};

get_baby_equip_engrave(5,38040038) ->
	#base_baby_equip_engrave{color = 5,goods_id = 38040038,num = 8,ratio = 250};

get_baby_equip_engrave(5,38040039) ->
	#base_baby_equip_engrave{color = 5,goods_id = 38040039,num = 1,ratio = 1250};

get_baby_equip_engrave(5,38040040) ->
	#base_baby_equip_engrave{color = 5,goods_id = 38040040,num = 1,ratio = 2500};

get_baby_equip_engrave(6,38040037) ->
	#base_baby_equip_engrave{color = 6,goods_id = 38040037,num = 10,ratio = 100};

get_baby_equip_engrave(6,38040038) ->
	#base_baby_equip_engrave{color = 6,goods_id = 38040038,num = 10,ratio = 200};

get_baby_equip_engrave(6,38040039) ->
	#base_baby_equip_engrave{color = 6,goods_id = 38040039,num = 1,ratio = 1000};

get_baby_equip_engrave(6,38040040) ->
	#base_baby_equip_engrave{color = 6,goods_id = 38040040,num = 1,ratio = 2000};

get_baby_equip_engrave(_Color,_Goodsid) ->
	[].

