%%%---------------------------------------
%%% module      : data_demons
%%% description : 使魔配置
%%%
%%%---------------------------------------
-module(data_demons).
-compile(export_all).
-include("demons.hrl").




get_key(1) ->
450;


get_key(2) ->
[{1,[{7301001,10},{7301002,100}]},{2,[{7301003,10},{7301004,100}]},{3,[{7301005,10},{7301006,100}]}];


get_key(3) ->
3;


get_key(4) ->
4;


get_key(5) ->
0;


get_key(6) ->
[{1,2, [{1,0,10}]},{3,4, [{1,0,15}]},{5,6, [{1,0,20}]},{7,9, [{1,0,30}]},{10,9999, [{1,0,50}]}];


get_key(7) ->
0;


get_key(8) ->
8;


get_key(9) ->
200;


get_key(10) ->
[{2,{star, 0}},{3,{star, 4}}];


get_key(11) ->
3;

get_key(_Key) ->
	0.

get_demons_cfg(1001) ->
	#base_demons{demons_id = 1001,demons_name = "龟小忍",realm = 1,color = 3,cost = [],fetters = [1,2],resource = 1013};

get_demons_cfg(1002) ->
	#base_demons{demons_id = 1002,demons_name = "锤骷髅",realm = 1,color = 3,cost = [],fetters = [1,3],resource = 1002};

get_demons_cfg(1003) ->
	#base_demons{demons_id = 1003,demons_name = "囧小鸭",realm = 1,color = 3,cost = [],fetters = [2,7,10],resource = 1004};

get_demons_cfg(1004) ->
	#base_demons{demons_id = 1004,demons_name = "大耳犬",realm = 1,color = 3,cost = [],fetters = [2,8],resource = 1045};

get_demons_cfg(1005) ->
	#base_demons{demons_id = 1005,demons_name = "寿司车",realm = 2,color = 4,cost = [],fetters = [3,4,5],resource = 1009};

get_demons_cfg(1006) ->
	#base_demons{demons_id = 1006,demons_name = "天妇罗",realm = 2,color = 4,cost = [],fetters = [3,5],resource = 1000};

get_demons_cfg(1007) ->
	#base_demons{demons_id = 1007,demons_name = "亲子企鹅",realm = 2,color = 4,cost = [],fetters = [4,9],resource = 1016};

get_demons_cfg(1008) ->
	#base_demons{demons_id = 1008,demons_name = "猫猫球",realm = 2,color = 4,cost = [],fetters = [4,6],resource = 1034};

get_demons_cfg(1009) ->
	#base_demons{demons_id = 1009,demons_name = "木木子",realm = 3,color = 5,cost = [],fetters = [5,6,9],resource = 1024};

get_demons_cfg(1010) ->
	#base_demons{demons_id = 1010,demons_name = "小丑玩偶",realm = 3,color = 5,cost = [],fetters = [6,8],resource = 1025};

get_demons_cfg(1011) ->
	#base_demons{demons_id = 1011,demons_name = "白象猎人",realm = 3,color = 5,cost = [],fetters = [7],resource = 1017};

get_demons_cfg(1012) ->
	#base_demons{demons_id = 1012,demons_name = "灵巫子",realm = 3,color = 5,cost = [],fetters = [7,10],resource = 1035};

get_demons_cfg(1013) ->
	#base_demons{demons_id = 1013,demons_name = "时尚灵狐",realm = 3,color = 5,cost = [],fetters = [8],resource = 1039};

get_demons_cfg(1014) ->
	#base_demons{demons_id = 1014,demons_name = "海蛟王",realm = 3,color = 5,cost = [],fetters = [9],resource = 1005};

get_demons_cfg(1015) ->
	#base_demons{demons_id = 1015,demons_name = "恶狼武士",realm = 3,color = 5,cost = [],fetters = [10],resource = 1050};

get_demons_cfg(_Demonsid) ->
	[].

get_all_demons_id() ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015].

get_demons_level_cfg(1,0) ->
	#base_demons_level{demons_id = 1,level = 0,exp = 0,attr = [{1,0},{2,0},{3,0},{4,0}]};

get_demons_level_cfg(1,1) ->
	#base_demons_level{demons_id = 1,level = 1,exp = 20,attr = [{1,50},{2,1000},{3,25},{4,25}]};

get_demons_level_cfg(1,2) ->
	#base_demons_level{demons_id = 1,level = 2,exp = 30,attr = [{1,100},{2,2000},{3,50},{4,50}]};

get_demons_level_cfg(1,3) ->
	#base_demons_level{demons_id = 1,level = 3,exp = 40,attr = [{1,150},{2,3000},{3,75},{4,75}]};

get_demons_level_cfg(1,4) ->
	#base_demons_level{demons_id = 1,level = 4,exp = 50,attr = [{1,200},{2,4000},{3,100},{4,100}]};

get_demons_level_cfg(1,5) ->
	#base_demons_level{demons_id = 1,level = 5,exp = 60,attr = [{1,250},{2,5000},{3,125},{4,125}]};

get_demons_level_cfg(1,6) ->
	#base_demons_level{demons_id = 1,level = 6,exp = 80,attr = [{1,300},{2,6000},{3,150},{4,150}]};

get_demons_level_cfg(1,7) ->
	#base_demons_level{demons_id = 1,level = 7,exp = 100,attr = [{1,350},{2,7000},{3,175},{4,175}]};

get_demons_level_cfg(1,8) ->
	#base_demons_level{demons_id = 1,level = 8,exp = 120,attr = [{1,400},{2,8000},{3,200},{4,200}]};

get_demons_level_cfg(1,9) ->
	#base_demons_level{demons_id = 1,level = 9,exp = 150,attr = [{1,450},{2,9000},{3,225},{4,225}]};

get_demons_level_cfg(1,10) ->
	#base_demons_level{demons_id = 1,level = 10,exp = 200,attr = [{1,500},{2,10000},{3,250},{4,250}]};

get_demons_level_cfg(1,11) ->
	#base_demons_level{demons_id = 1,level = 11,exp = 26,attr = [{1,550},{2,11000},{3,275},{4,275}]};

get_demons_level_cfg(1,12) ->
	#base_demons_level{demons_id = 1,level = 12,exp = 39,attr = [{1,600},{2,12000},{3,300},{4,300}]};

get_demons_level_cfg(1,13) ->
	#base_demons_level{demons_id = 1,level = 13,exp = 52,attr = [{1,650},{2,13000},{3,325},{4,325}]};

get_demons_level_cfg(1,14) ->
	#base_demons_level{demons_id = 1,level = 14,exp = 65,attr = [{1,700},{2,14000},{3,350},{4,350}]};

get_demons_level_cfg(1,15) ->
	#base_demons_level{demons_id = 1,level = 15,exp = 78,attr = [{1,750},{2,15000},{3,375},{4,375}]};

get_demons_level_cfg(1,16) ->
	#base_demons_level{demons_id = 1,level = 16,exp = 104,attr = [{1,800},{2,16000},{3,400},{4,400}]};

get_demons_level_cfg(1,17) ->
	#base_demons_level{demons_id = 1,level = 17,exp = 130,attr = [{1,850},{2,17000},{3,425},{4,425}]};

get_demons_level_cfg(1,18) ->
	#base_demons_level{demons_id = 1,level = 18,exp = 156,attr = [{1,900},{2,18000},{3,450},{4,450}]};

get_demons_level_cfg(1,19) ->
	#base_demons_level{demons_id = 1,level = 19,exp = 195,attr = [{1,950},{2,19000},{3,475},{4,475}]};

get_demons_level_cfg(1,20) ->
	#base_demons_level{demons_id = 1,level = 20,exp = 260,attr = [{1,1000},{2,20000},{3,500},{4,500}]};

get_demons_level_cfg(1,21) ->
	#base_demons_level{demons_id = 1,level = 21,exp = 33,attr = [{1,1050},{2,21000},{3,525},{4,525}]};

get_demons_level_cfg(1,22) ->
	#base_demons_level{demons_id = 1,level = 22,exp = 50,attr = [{1,1100},{2,22000},{3,550},{4,550}]};

get_demons_level_cfg(1,23) ->
	#base_demons_level{demons_id = 1,level = 23,exp = 67,attr = [{1,1150},{2,23000},{3,575},{4,575}]};

get_demons_level_cfg(1,24) ->
	#base_demons_level{demons_id = 1,level = 24,exp = 84,attr = [{1,1200},{2,24000},{3,600},{4,600}]};

get_demons_level_cfg(1,25) ->
	#base_demons_level{demons_id = 1,level = 25,exp = 101,attr = [{1,1250},{2,25000},{3,625},{4,625}]};

get_demons_level_cfg(1,26) ->
	#base_demons_level{demons_id = 1,level = 26,exp = 135,attr = [{1,1300},{2,26000},{3,650},{4,650}]};

get_demons_level_cfg(1,27) ->
	#base_demons_level{demons_id = 1,level = 27,exp = 169,attr = [{1,1350},{2,27000},{3,675},{4,675}]};

get_demons_level_cfg(1,28) ->
	#base_demons_level{demons_id = 1,level = 28,exp = 202,attr = [{1,1400},{2,28000},{3,700},{4,700}]};

get_demons_level_cfg(1,29) ->
	#base_demons_level{demons_id = 1,level = 29,exp = 253,attr = [{1,1450},{2,29000},{3,725},{4,725}]};

get_demons_level_cfg(1,30) ->
	#base_demons_level{demons_id = 1,level = 30,exp = 338,attr = [{1,1500},{2,30000},{3,750},{4,750}]};

get_demons_level_cfg(1,31) ->
	#base_demons_level{demons_id = 1,level = 31,exp = 42,attr = [{1,1550},{2,31000},{3,775},{4,775}]};

get_demons_level_cfg(1,32) ->
	#base_demons_level{demons_id = 1,level = 32,exp = 65,attr = [{1,1600},{2,32000},{3,800},{4,800}]};

get_demons_level_cfg(1,33) ->
	#base_demons_level{demons_id = 1,level = 33,exp = 87,attr = [{1,1650},{2,33000},{3,825},{4,825}]};

get_demons_level_cfg(1,34) ->
	#base_demons_level{demons_id = 1,level = 34,exp = 109,attr = [{1,1700},{2,34000},{3,850},{4,850}]};

get_demons_level_cfg(1,35) ->
	#base_demons_level{demons_id = 1,level = 35,exp = 131,attr = [{1,1750},{2,35000},{3,875},{4,875}]};

get_demons_level_cfg(1,36) ->
	#base_demons_level{demons_id = 1,level = 36,exp = 175,attr = [{1,1800},{2,36000},{3,900},{4,900}]};

get_demons_level_cfg(1,37) ->
	#base_demons_level{demons_id = 1,level = 37,exp = 219,attr = [{1,1850},{2,37000},{3,925},{4,925}]};

get_demons_level_cfg(1,38) ->
	#base_demons_level{demons_id = 1,level = 38,exp = 262,attr = [{1,1900},{2,38000},{3,950},{4,950}]};

get_demons_level_cfg(1,39) ->
	#base_demons_level{demons_id = 1,level = 39,exp = 328,attr = [{1,1950},{2,39000},{3,975},{4,975}]};

get_demons_level_cfg(1,40) ->
	#base_demons_level{demons_id = 1,level = 40,exp = 439,attr = [{1,2000},{2,40000},{3,1000},{4,1000}]};

get_demons_level_cfg(1,41) ->
	#base_demons_level{demons_id = 1,level = 41,exp = 54,attr = [{1,2050},{2,41000},{3,1025},{4,1025}]};

get_demons_level_cfg(1,42) ->
	#base_demons_level{demons_id = 1,level = 42,exp = 84,attr = [{1,2100},{2,42000},{3,1050},{4,1050}]};

get_demons_level_cfg(1,43) ->
	#base_demons_level{demons_id = 1,level = 43,exp = 113,attr = [{1,2150},{2,43000},{3,1075},{4,1075}]};

get_demons_level_cfg(1,44) ->
	#base_demons_level{demons_id = 1,level = 44,exp = 141,attr = [{1,2200},{2,44000},{3,1100},{4,1100}]};

get_demons_level_cfg(1,45) ->
	#base_demons_level{demons_id = 1,level = 45,exp = 170,attr = [{1,2250},{2,45000},{3,1125},{4,1125}]};

get_demons_level_cfg(1,46) ->
	#base_demons_level{demons_id = 1,level = 46,exp = 227,attr = [{1,2300},{2,46000},{3,1150},{4,1150}]};

get_demons_level_cfg(1,47) ->
	#base_demons_level{demons_id = 1,level = 47,exp = 284,attr = [{1,2350},{2,47000},{3,1175},{4,1175}]};

get_demons_level_cfg(1,48) ->
	#base_demons_level{demons_id = 1,level = 48,exp = 340,attr = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_demons_level_cfg(1,49) ->
	#base_demons_level{demons_id = 1,level = 49,exp = 426,attr = [{1,2450},{2,49000},{3,1225},{4,1225}]};

get_demons_level_cfg(1,50) ->
	#base_demons_level{demons_id = 1,level = 50,exp = 570,attr = [{1,2500},{2,50000},{3,1250},{4,1250}]};

get_demons_level_cfg(1,51) ->
	#base_demons_level{demons_id = 1,level = 51,exp = 81,attr = [{1,2550},{2,51000},{3,1275},{4,1275}]};

get_demons_level_cfg(1,52) ->
	#base_demons_level{demons_id = 1,level = 52,exp = 126,attr = [{1,2600},{2,52000},{3,1300},{4,1300}]};

get_demons_level_cfg(1,53) ->
	#base_demons_level{demons_id = 1,level = 53,exp = 169,attr = [{1,2650},{2,53000},{3,1325},{4,1325}]};

get_demons_level_cfg(1,54) ->
	#base_demons_level{demons_id = 1,level = 54,exp = 211,attr = [{1,2700},{2,54000},{3,1350},{4,1350}]};

get_demons_level_cfg(1,55) ->
	#base_demons_level{demons_id = 1,level = 55,exp = 255,attr = [{1,2750},{2,55000},{3,1375},{4,1375}]};

get_demons_level_cfg(1,56) ->
	#base_demons_level{demons_id = 1,level = 56,exp = 340,attr = [{1,2800},{2,56000},{3,1400},{4,1400}]};

get_demons_level_cfg(1,57) ->
	#base_demons_level{demons_id = 1,level = 57,exp = 426,attr = [{1,2850},{2,57000},{3,1425},{4,1425}]};

get_demons_level_cfg(1,58) ->
	#base_demons_level{demons_id = 1,level = 58,exp = 510,attr = [{1,2900},{2,58000},{3,1450},{4,1450}]};

get_demons_level_cfg(1,59) ->
	#base_demons_level{demons_id = 1,level = 59,exp = 639,attr = [{1,2950},{2,59000},{3,1475},{4,1475}]};

get_demons_level_cfg(1,60) ->
	#base_demons_level{demons_id = 1,level = 60,exp = 855,attr = [{1,3000},{2,60000},{3,1500},{4,1500}]};

get_demons_level_cfg(1,61) ->
	#base_demons_level{demons_id = 1,level = 61,exp = 121,attr = [{1,3050},{2,61000},{3,1525},{4,1525}]};

get_demons_level_cfg(1,62) ->
	#base_demons_level{demons_id = 1,level = 62,exp = 189,attr = [{1,3100},{2,62000},{3,1550},{4,1550}]};

get_demons_level_cfg(1,63) ->
	#base_demons_level{demons_id = 1,level = 63,exp = 253,attr = [{1,3150},{2,63000},{3,1575},{4,1575}]};

get_demons_level_cfg(1,64) ->
	#base_demons_level{demons_id = 1,level = 64,exp = 316,attr = [{1,3200},{2,64000},{3,1600},{4,1600}]};

get_demons_level_cfg(1,65) ->
	#base_demons_level{demons_id = 1,level = 65,exp = 382,attr = [{1,3250},{2,65000},{3,1625},{4,1625}]};

get_demons_level_cfg(1,66) ->
	#base_demons_level{demons_id = 1,level = 66,exp = 510,attr = [{1,3300},{2,66000},{3,1650},{4,1650}]};

get_demons_level_cfg(1,67) ->
	#base_demons_level{demons_id = 1,level = 67,exp = 639,attr = [{1,3350},{2,67000},{3,1675},{4,1675}]};

get_demons_level_cfg(1,68) ->
	#base_demons_level{demons_id = 1,level = 68,exp = 765,attr = [{1,3400},{2,68000},{3,1700},{4,1700}]};

get_demons_level_cfg(1,69) ->
	#base_demons_level{demons_id = 1,level = 69,exp = 958,attr = [{1,3450},{2,69000},{3,1725},{4,1725}]};

get_demons_level_cfg(1,70) ->
	#base_demons_level{demons_id = 1,level = 70,exp = 1282,attr = [{1,3500},{2,70000},{3,1750},{4,1750}]};

get_demons_level_cfg(1,71) ->
	#base_demons_level{demons_id = 1,level = 71,exp = 181,attr = [{1,3550},{2,71000},{3,1775},{4,1775}]};

get_demons_level_cfg(1,72) ->
	#base_demons_level{demons_id = 1,level = 72,exp = 283,attr = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_demons_level_cfg(1,73) ->
	#base_demons_level{demons_id = 1,level = 73,exp = 379,attr = [{1,3650},{2,73000},{3,1825},{4,1825}]};

get_demons_level_cfg(1,74) ->
	#base_demons_level{demons_id = 1,level = 74,exp = 474,attr = [{1,3700},{2,74000},{3,1850},{4,1850}]};

get_demons_level_cfg(1,75) ->
	#base_demons_level{demons_id = 1,level = 75,exp = 573,attr = [{1,3750},{2,75000},{3,1875},{4,1875}]};

get_demons_level_cfg(1,76) ->
	#base_demons_level{demons_id = 1,level = 76,exp = 765,attr = [{1,3800},{2,76000},{3,1900},{4,1900}]};

get_demons_level_cfg(1,77) ->
	#base_demons_level{demons_id = 1,level = 77,exp = 958,attr = [{1,3850},{2,77000},{3,1925},{4,1925}]};

get_demons_level_cfg(1,78) ->
	#base_demons_level{demons_id = 1,level = 78,exp = 1147,attr = [{1,3900},{2,78000},{3,1950},{4,1950}]};

get_demons_level_cfg(1,79) ->
	#base_demons_level{demons_id = 1,level = 79,exp = 1437,attr = [{1,3950},{2,79000},{3,1975},{4,1975}]};

get_demons_level_cfg(1,80) ->
	#base_demons_level{demons_id = 1,level = 80,exp = 1923,attr = [{1,4000},{2,80000},{3,2000},{4,2000}]};

get_demons_level_cfg(1,81) ->
	#base_demons_level{demons_id = 1,level = 81,exp = 271,attr = [{1,4050},{2,81000},{3,2025},{4,2025}]};

get_demons_level_cfg(1,82) ->
	#base_demons_level{demons_id = 1,level = 82,exp = 424,attr = [{1,4100},{2,82000},{3,2050},{4,2050}]};

get_demons_level_cfg(1,83) ->
	#base_demons_level{demons_id = 1,level = 83,exp = 568,attr = [{1,4150},{2,83000},{3,2075},{4,2075}]};

get_demons_level_cfg(1,84) ->
	#base_demons_level{demons_id = 1,level = 84,exp = 711,attr = [{1,4200},{2,84000},{3,2100},{4,2100}]};

get_demons_level_cfg(1,85) ->
	#base_demons_level{demons_id = 1,level = 85,exp = 859,attr = [{1,4250},{2,85000},{3,2125},{4,2125}]};

get_demons_level_cfg(1,86) ->
	#base_demons_level{demons_id = 1,level = 86,exp = 1147,attr = [{1,4300},{2,86000},{3,2150},{4,2150}]};

get_demons_level_cfg(1,87) ->
	#base_demons_level{demons_id = 1,level = 87,exp = 1437,attr = [{1,4350},{2,87000},{3,2175},{4,2175}]};

get_demons_level_cfg(1,88) ->
	#base_demons_level{demons_id = 1,level = 88,exp = 1720,attr = [{1,4400},{2,88000},{3,2200},{4,2200}]};

get_demons_level_cfg(1,89) ->
	#base_demons_level{demons_id = 1,level = 89,exp = 2155,attr = [{1,4450},{2,89000},{3,2225},{4,2225}]};

get_demons_level_cfg(1,90) ->
	#base_demons_level{demons_id = 1,level = 90,exp = 2884,attr = [{1,4500},{2,90000},{3,2250},{4,2250}]};

get_demons_level_cfg(1,91) ->
	#base_demons_level{demons_id = 1,level = 91,exp = 406,attr = [{1,4550},{2,91000},{3,2275},{4,2275}]};

get_demons_level_cfg(1,92) ->
	#base_demons_level{demons_id = 1,level = 92,exp = 636,attr = [{1,4600},{2,92000},{3,2300},{4,2300}]};

get_demons_level_cfg(1,93) ->
	#base_demons_level{demons_id = 1,level = 93,exp = 852,attr = [{1,4650},{2,93000},{3,2325},{4,2325}]};

get_demons_level_cfg(1,94) ->
	#base_demons_level{demons_id = 1,level = 94,exp = 1066,attr = [{1,4700},{2,94000},{3,2350},{4,2350}]};

get_demons_level_cfg(1,95) ->
	#base_demons_level{demons_id = 1,level = 95,exp = 1288,attr = [{1,4750},{2,95000},{3,2375},{4,2375}]};

get_demons_level_cfg(1,96) ->
	#base_demons_level{demons_id = 1,level = 96,exp = 1720,attr = [{1,4800},{2,96000},{3,2400},{4,2400}]};

get_demons_level_cfg(1,97) ->
	#base_demons_level{demons_id = 1,level = 97,exp = 2155,attr = [{1,4850},{2,97000},{3,2425},{4,2425}]};

get_demons_level_cfg(1,98) ->
	#base_demons_level{demons_id = 1,level = 98,exp = 2580,attr = [{1,4900},{2,98000},{3,2450},{4,2450}]};

get_demons_level_cfg(1,99) ->
	#base_demons_level{demons_id = 1,level = 99,exp = 3232,attr = [{1,4950},{2,99000},{3,2475},{4,2475}]};

get_demons_level_cfg(1,100) ->
	#base_demons_level{demons_id = 1,level = 100,exp = 4326,attr = [{1,5000},{2,100000},{3,2500},{4,2500}]};

get_demons_level_cfg(2,0) ->
	#base_demons_level{demons_id = 2,level = 0,exp = 0,attr = [{1,0},{2,0},{3,0},{4,0}]};

get_demons_level_cfg(2,1) ->
	#base_demons_level{demons_id = 2,level = 1,exp = 40,attr = [{1,75},{2,1500},{3,37},{4,37}]};

get_demons_level_cfg(2,2) ->
	#base_demons_level{demons_id = 2,level = 2,exp = 60,attr = [{1,150},{2,3000},{3,74},{4,74}]};

get_demons_level_cfg(2,3) ->
	#base_demons_level{demons_id = 2,level = 3,exp = 80,attr = [{1,225},{2,4500},{3,111},{4,111}]};

get_demons_level_cfg(2,4) ->
	#base_demons_level{demons_id = 2,level = 4,exp = 100,attr = [{1,300},{2,6000},{3,148},{4,148}]};

get_demons_level_cfg(2,5) ->
	#base_demons_level{demons_id = 2,level = 5,exp = 120,attr = [{1,375},{2,7500},{3,185},{4,185}]};

get_demons_level_cfg(2,6) ->
	#base_demons_level{demons_id = 2,level = 6,exp = 160,attr = [{1,450},{2,9000},{3,222},{4,222}]};

get_demons_level_cfg(2,7) ->
	#base_demons_level{demons_id = 2,level = 7,exp = 200,attr = [{1,525},{2,10500},{3,259},{4,259}]};

get_demons_level_cfg(2,8) ->
	#base_demons_level{demons_id = 2,level = 8,exp = 240,attr = [{1,600},{2,12000},{3,296},{4,296}]};

get_demons_level_cfg(2,9) ->
	#base_demons_level{demons_id = 2,level = 9,exp = 300,attr = [{1,675},{2,13500},{3,333},{4,333}]};

get_demons_level_cfg(2,10) ->
	#base_demons_level{demons_id = 2,level = 10,exp = 400,attr = [{1,750},{2,15000},{3,370},{4,370}]};

get_demons_level_cfg(2,11) ->
	#base_demons_level{demons_id = 2,level = 11,exp = 52,attr = [{1,825},{2,16500},{3,407},{4,407}]};

get_demons_level_cfg(2,12) ->
	#base_demons_level{demons_id = 2,level = 12,exp = 78,attr = [{1,900},{2,18000},{3,444},{4,444}]};

get_demons_level_cfg(2,13) ->
	#base_demons_level{demons_id = 2,level = 13,exp = 104,attr = [{1,975},{2,19500},{3,481},{4,481}]};

get_demons_level_cfg(2,14) ->
	#base_demons_level{demons_id = 2,level = 14,exp = 130,attr = [{1,1050},{2,21000},{3,518},{4,518}]};

get_demons_level_cfg(2,15) ->
	#base_demons_level{demons_id = 2,level = 15,exp = 156,attr = [{1,1125},{2,22500},{3,555},{4,555}]};

get_demons_level_cfg(2,16) ->
	#base_demons_level{demons_id = 2,level = 16,exp = 208,attr = [{1,1200},{2,24000},{3,592},{4,592}]};

get_demons_level_cfg(2,17) ->
	#base_demons_level{demons_id = 2,level = 17,exp = 260,attr = [{1,1275},{2,25500},{3,629},{4,629}]};

get_demons_level_cfg(2,18) ->
	#base_demons_level{demons_id = 2,level = 18,exp = 312,attr = [{1,1350},{2,27000},{3,666},{4,666}]};

get_demons_level_cfg(2,19) ->
	#base_demons_level{demons_id = 2,level = 19,exp = 390,attr = [{1,1425},{2,28500},{3,703},{4,703}]};

get_demons_level_cfg(2,20) ->
	#base_demons_level{demons_id = 2,level = 20,exp = 520,attr = [{1,1500},{2,30000},{3,740},{4,740}]};

get_demons_level_cfg(2,21) ->
	#base_demons_level{demons_id = 2,level = 21,exp = 66,attr = [{1,1575},{2,31500},{3,777},{4,777}]};

get_demons_level_cfg(2,22) ->
	#base_demons_level{demons_id = 2,level = 22,exp = 100,attr = [{1,1650},{2,33000},{3,814},{4,814}]};

get_demons_level_cfg(2,23) ->
	#base_demons_level{demons_id = 2,level = 23,exp = 134,attr = [{1,1725},{2,34500},{3,851},{4,851}]};

get_demons_level_cfg(2,24) ->
	#base_demons_level{demons_id = 2,level = 24,exp = 168,attr = [{1,1800},{2,36000},{3,888},{4,888}]};

get_demons_level_cfg(2,25) ->
	#base_demons_level{demons_id = 2,level = 25,exp = 202,attr = [{1,1875},{2,37500},{3,925},{4,925}]};

get_demons_level_cfg(2,26) ->
	#base_demons_level{demons_id = 2,level = 26,exp = 270,attr = [{1,1950},{2,39000},{3,962},{4,962}]};

get_demons_level_cfg(2,27) ->
	#base_demons_level{demons_id = 2,level = 27,exp = 338,attr = [{1,2025},{2,40500},{3,999},{4,999}]};

get_demons_level_cfg(2,28) ->
	#base_demons_level{demons_id = 2,level = 28,exp = 404,attr = [{1,2100},{2,42000},{3,1036},{4,1036}]};

get_demons_level_cfg(2,29) ->
	#base_demons_level{demons_id = 2,level = 29,exp = 506,attr = [{1,2175},{2,43500},{3,1073},{4,1073}]};

get_demons_level_cfg(2,30) ->
	#base_demons_level{demons_id = 2,level = 30,exp = 676,attr = [{1,2250},{2,45000},{3,1110},{4,1110}]};

get_demons_level_cfg(2,31) ->
	#base_demons_level{demons_id = 2,level = 31,exp = 84,attr = [{1,2325},{2,46500},{3,1147},{4,1147}]};

get_demons_level_cfg(2,32) ->
	#base_demons_level{demons_id = 2,level = 32,exp = 130,attr = [{1,2400},{2,48000},{3,1184},{4,1184}]};

get_demons_level_cfg(2,33) ->
	#base_demons_level{demons_id = 2,level = 33,exp = 174,attr = [{1,2475},{2,49500},{3,1221},{4,1221}]};

get_demons_level_cfg(2,34) ->
	#base_demons_level{demons_id = 2,level = 34,exp = 218,attr = [{1,2550},{2,51000},{3,1258},{4,1258}]};

get_demons_level_cfg(2,35) ->
	#base_demons_level{demons_id = 2,level = 35,exp = 262,attr = [{1,2625},{2,52500},{3,1295},{4,1295}]};

get_demons_level_cfg(2,36) ->
	#base_demons_level{demons_id = 2,level = 36,exp = 350,attr = [{1,2700},{2,54000},{3,1332},{4,1332}]};

get_demons_level_cfg(2,37) ->
	#base_demons_level{demons_id = 2,level = 37,exp = 438,attr = [{1,2775},{2,55500},{3,1369},{4,1369}]};

get_demons_level_cfg(2,38) ->
	#base_demons_level{demons_id = 2,level = 38,exp = 524,attr = [{1,2850},{2,57000},{3,1406},{4,1406}]};

get_demons_level_cfg(2,39) ->
	#base_demons_level{demons_id = 2,level = 39,exp = 656,attr = [{1,2925},{2,58500},{3,1443},{4,1443}]};

get_demons_level_cfg(2,40) ->
	#base_demons_level{demons_id = 2,level = 40,exp = 878,attr = [{1,3000},{2,60000},{3,1480},{4,1480}]};

get_demons_level_cfg(2,41) ->
	#base_demons_level{demons_id = 2,level = 41,exp = 108,attr = [{1,3075},{2,61500},{3,1517},{4,1517}]};

get_demons_level_cfg(2,42) ->
	#base_demons_level{demons_id = 2,level = 42,exp = 168,attr = [{1,3150},{2,63000},{3,1554},{4,1554}]};

get_demons_level_cfg(2,43) ->
	#base_demons_level{demons_id = 2,level = 43,exp = 226,attr = [{1,3225},{2,64500},{3,1591},{4,1591}]};

get_demons_level_cfg(2,44) ->
	#base_demons_level{demons_id = 2,level = 44,exp = 282,attr = [{1,3300},{2,66000},{3,1628},{4,1628}]};

get_demons_level_cfg(2,45) ->
	#base_demons_level{demons_id = 2,level = 45,exp = 340,attr = [{1,3375},{2,67500},{3,1665},{4,1665}]};

get_demons_level_cfg(2,46) ->
	#base_demons_level{demons_id = 2,level = 46,exp = 454,attr = [{1,3450},{2,69000},{3,1702},{4,1702}]};

get_demons_level_cfg(2,47) ->
	#base_demons_level{demons_id = 2,level = 47,exp = 568,attr = [{1,3525},{2,70500},{3,1739},{4,1739}]};

get_demons_level_cfg(2,48) ->
	#base_demons_level{demons_id = 2,level = 48,exp = 680,attr = [{1,3600},{2,72000},{3,1776},{4,1776}]};

get_demons_level_cfg(2,49) ->
	#base_demons_level{demons_id = 2,level = 49,exp = 852,attr = [{1,3675},{2,73500},{3,1813},{4,1813}]};

get_demons_level_cfg(2,50) ->
	#base_demons_level{demons_id = 2,level = 50,exp = 1140,attr = [{1,3750},{2,75000},{3,1850},{4,1850}]};

get_demons_level_cfg(2,51) ->
	#base_demons_level{demons_id = 2,level = 51,exp = 162,attr = [{1,3825},{2,76500},{3,1887},{4,1887}]};

get_demons_level_cfg(2,52) ->
	#base_demons_level{demons_id = 2,level = 52,exp = 252,attr = [{1,3900},{2,78000},{3,1924},{4,1924}]};

get_demons_level_cfg(2,53) ->
	#base_demons_level{demons_id = 2,level = 53,exp = 338,attr = [{1,3975},{2,79500},{3,1961},{4,1961}]};

get_demons_level_cfg(2,54) ->
	#base_demons_level{demons_id = 2,level = 54,exp = 422,attr = [{1,4050},{2,81000},{3,1998},{4,1998}]};

get_demons_level_cfg(2,55) ->
	#base_demons_level{demons_id = 2,level = 55,exp = 510,attr = [{1,4125},{2,82500},{3,2035},{4,2035}]};

get_demons_level_cfg(2,56) ->
	#base_demons_level{demons_id = 2,level = 56,exp = 680,attr = [{1,4200},{2,84000},{3,2072},{4,2072}]};

get_demons_level_cfg(2,57) ->
	#base_demons_level{demons_id = 2,level = 57,exp = 852,attr = [{1,4275},{2,85500},{3,2109},{4,2109}]};

get_demons_level_cfg(2,58) ->
	#base_demons_level{demons_id = 2,level = 58,exp = 1020,attr = [{1,4350},{2,87000},{3,2146},{4,2146}]};

get_demons_level_cfg(2,59) ->
	#base_demons_level{demons_id = 2,level = 59,exp = 1278,attr = [{1,4425},{2,88500},{3,2183},{4,2183}]};

get_demons_level_cfg(2,60) ->
	#base_demons_level{demons_id = 2,level = 60,exp = 1710,attr = [{1,4500},{2,90000},{3,2220},{4,2220}]};

get_demons_level_cfg(2,61) ->
	#base_demons_level{demons_id = 2,level = 61,exp = 242,attr = [{1,4575},{2,91500},{3,2257},{4,2257}]};

get_demons_level_cfg(2,62) ->
	#base_demons_level{demons_id = 2,level = 62,exp = 378,attr = [{1,4650},{2,93000},{3,2294},{4,2294}]};

get_demons_level_cfg(2,63) ->
	#base_demons_level{demons_id = 2,level = 63,exp = 506,attr = [{1,4725},{2,94500},{3,2331},{4,2331}]};

get_demons_level_cfg(2,64) ->
	#base_demons_level{demons_id = 2,level = 64,exp = 632,attr = [{1,4800},{2,96000},{3,2368},{4,2368}]};

get_demons_level_cfg(2,65) ->
	#base_demons_level{demons_id = 2,level = 65,exp = 764,attr = [{1,4875},{2,97500},{3,2405},{4,2405}]};

get_demons_level_cfg(2,66) ->
	#base_demons_level{demons_id = 2,level = 66,exp = 1020,attr = [{1,4950},{2,99000},{3,2442},{4,2442}]};

get_demons_level_cfg(2,67) ->
	#base_demons_level{demons_id = 2,level = 67,exp = 1278,attr = [{1,5025},{2,100500},{3,2479},{4,2479}]};

get_demons_level_cfg(2,68) ->
	#base_demons_level{demons_id = 2,level = 68,exp = 1530,attr = [{1,5100},{2,102000},{3,2516},{4,2516}]};

get_demons_level_cfg(2,69) ->
	#base_demons_level{demons_id = 2,level = 69,exp = 1916,attr = [{1,5175},{2,103500},{3,2553},{4,2553}]};

get_demons_level_cfg(2,70) ->
	#base_demons_level{demons_id = 2,level = 70,exp = 2564,attr = [{1,5250},{2,105000},{3,2590},{4,2590}]};

get_demons_level_cfg(2,71) ->
	#base_demons_level{demons_id = 2,level = 71,exp = 362,attr = [{1,5325},{2,106500},{3,2627},{4,2627}]};

get_demons_level_cfg(2,72) ->
	#base_demons_level{demons_id = 2,level = 72,exp = 566,attr = [{1,5400},{2,108000},{3,2664},{4,2664}]};

get_demons_level_cfg(2,73) ->
	#base_demons_level{demons_id = 2,level = 73,exp = 758,attr = [{1,5475},{2,109500},{3,2701},{4,2701}]};

get_demons_level_cfg(2,74) ->
	#base_demons_level{demons_id = 2,level = 74,exp = 948,attr = [{1,5550},{2,111000},{3,2738},{4,2738}]};

get_demons_level_cfg(2,75) ->
	#base_demons_level{demons_id = 2,level = 75,exp = 1146,attr = [{1,5625},{2,112500},{3,2775},{4,2775}]};

get_demons_level_cfg(2,76) ->
	#base_demons_level{demons_id = 2,level = 76,exp = 1530,attr = [{1,5700},{2,114000},{3,2812},{4,2812}]};

get_demons_level_cfg(2,77) ->
	#base_demons_level{demons_id = 2,level = 77,exp = 1916,attr = [{1,5775},{2,115500},{3,2849},{4,2849}]};

get_demons_level_cfg(2,78) ->
	#base_demons_level{demons_id = 2,level = 78,exp = 2294,attr = [{1,5850},{2,117000},{3,2886},{4,2886}]};

get_demons_level_cfg(2,79) ->
	#base_demons_level{demons_id = 2,level = 79,exp = 2874,attr = [{1,5925},{2,118500},{3,2923},{4,2923}]};

get_demons_level_cfg(2,80) ->
	#base_demons_level{demons_id = 2,level = 80,exp = 3846,attr = [{1,6000},{2,120000},{3,2960},{4,2960}]};

get_demons_level_cfg(2,81) ->
	#base_demons_level{demons_id = 2,level = 81,exp = 542,attr = [{1,6075},{2,121500},{3,2997},{4,2997}]};

get_demons_level_cfg(2,82) ->
	#base_demons_level{demons_id = 2,level = 82,exp = 848,attr = [{1,6150},{2,123000},{3,3034},{4,3034}]};

get_demons_level_cfg(2,83) ->
	#base_demons_level{demons_id = 2,level = 83,exp = 1136,attr = [{1,6225},{2,124500},{3,3071},{4,3071}]};

get_demons_level_cfg(2,84) ->
	#base_demons_level{demons_id = 2,level = 84,exp = 1422,attr = [{1,6300},{2,126000},{3,3108},{4,3108}]};

get_demons_level_cfg(2,85) ->
	#base_demons_level{demons_id = 2,level = 85,exp = 1718,attr = [{1,6375},{2,127500},{3,3145},{4,3145}]};

get_demons_level_cfg(2,86) ->
	#base_demons_level{demons_id = 2,level = 86,exp = 2294,attr = [{1,6450},{2,129000},{3,3182},{4,3182}]};

get_demons_level_cfg(2,87) ->
	#base_demons_level{demons_id = 2,level = 87,exp = 2874,attr = [{1,6525},{2,130500},{3,3219},{4,3219}]};

get_demons_level_cfg(2,88) ->
	#base_demons_level{demons_id = 2,level = 88,exp = 3440,attr = [{1,6600},{2,132000},{3,3256},{4,3256}]};

get_demons_level_cfg(2,89) ->
	#base_demons_level{demons_id = 2,level = 89,exp = 4310,attr = [{1,6675},{2,133500},{3,3293},{4,3293}]};

get_demons_level_cfg(2,90) ->
	#base_demons_level{demons_id = 2,level = 90,exp = 5768,attr = [{1,6750},{2,135000},{3,3330},{4,3330}]};

get_demons_level_cfg(2,91) ->
	#base_demons_level{demons_id = 2,level = 91,exp = 812,attr = [{1,6825},{2,136500},{3,3367},{4,3367}]};

get_demons_level_cfg(2,92) ->
	#base_demons_level{demons_id = 2,level = 92,exp = 1272,attr = [{1,6900},{2,138000},{3,3404},{4,3404}]};

get_demons_level_cfg(2,93) ->
	#base_demons_level{demons_id = 2,level = 93,exp = 1704,attr = [{1,6975},{2,139500},{3,3441},{4,3441}]};

get_demons_level_cfg(2,94) ->
	#base_demons_level{demons_id = 2,level = 94,exp = 2132,attr = [{1,7050},{2,141000},{3,3478},{4,3478}]};

get_demons_level_cfg(2,95) ->
	#base_demons_level{demons_id = 2,level = 95,exp = 2576,attr = [{1,7125},{2,142500},{3,3515},{4,3515}]};

get_demons_level_cfg(2,96) ->
	#base_demons_level{demons_id = 2,level = 96,exp = 3440,attr = [{1,7200},{2,144000},{3,3552},{4,3552}]};

get_demons_level_cfg(2,97) ->
	#base_demons_level{demons_id = 2,level = 97,exp = 4310,attr = [{1,7275},{2,145500},{3,3589},{4,3589}]};

get_demons_level_cfg(2,98) ->
	#base_demons_level{demons_id = 2,level = 98,exp = 5160,attr = [{1,7350},{2,147000},{3,3626},{4,3626}]};

get_demons_level_cfg(2,99) ->
	#base_demons_level{demons_id = 2,level = 99,exp = 6464,attr = [{1,7425},{2,148500},{3,3663},{4,3663}]};

get_demons_level_cfg(2,100) ->
	#base_demons_level{demons_id = 2,level = 100,exp = 8652,attr = [{1,7500},{2,150000},{3,3700},{4,3700}]};

get_demons_level_cfg(3,0) ->
	#base_demons_level{demons_id = 3,level = 0,exp = 0,attr = [{1,0},{2,0},{3,0},{4,0}]};

get_demons_level_cfg(3,1) ->
	#base_demons_level{demons_id = 3,level = 1,exp = 60,attr = [{1,100},{2,2000},{3,50},{4,50}]};

get_demons_level_cfg(3,2) ->
	#base_demons_level{demons_id = 3,level = 2,exp = 90,attr = [{1,200},{2,4000},{3,100},{4,100}]};

get_demons_level_cfg(3,3) ->
	#base_demons_level{demons_id = 3,level = 3,exp = 120,attr = [{1,300},{2,6000},{3,150},{4,150}]};

get_demons_level_cfg(3,4) ->
	#base_demons_level{demons_id = 3,level = 4,exp = 150,attr = [{1,400},{2,8000},{3,200},{4,200}]};

get_demons_level_cfg(3,5) ->
	#base_demons_level{demons_id = 3,level = 5,exp = 180,attr = [{1,500},{2,10000},{3,250},{4,250}]};

get_demons_level_cfg(3,6) ->
	#base_demons_level{demons_id = 3,level = 6,exp = 240,attr = [{1,600},{2,12000},{3,300},{4,300}]};

get_demons_level_cfg(3,7) ->
	#base_demons_level{demons_id = 3,level = 7,exp = 300,attr = [{1,700},{2,14000},{3,350},{4,350}]};

get_demons_level_cfg(3,8) ->
	#base_demons_level{demons_id = 3,level = 8,exp = 360,attr = [{1,800},{2,16000},{3,400},{4,400}]};

get_demons_level_cfg(3,9) ->
	#base_demons_level{demons_id = 3,level = 9,exp = 450,attr = [{1,900},{2,18000},{3,450},{4,450}]};

get_demons_level_cfg(3,10) ->
	#base_demons_level{demons_id = 3,level = 10,exp = 600,attr = [{1,1000},{2,20000},{3,500},{4,500}]};

get_demons_level_cfg(3,11) ->
	#base_demons_level{demons_id = 3,level = 11,exp = 78,attr = [{1,1100},{2,22000},{3,550},{4,550}]};

get_demons_level_cfg(3,12) ->
	#base_demons_level{demons_id = 3,level = 12,exp = 117,attr = [{1,1200},{2,24000},{3,600},{4,600}]};

get_demons_level_cfg(3,13) ->
	#base_demons_level{demons_id = 3,level = 13,exp = 156,attr = [{1,1300},{2,26000},{3,650},{4,650}]};

get_demons_level_cfg(3,14) ->
	#base_demons_level{demons_id = 3,level = 14,exp = 195,attr = [{1,1400},{2,28000},{3,700},{4,700}]};

get_demons_level_cfg(3,15) ->
	#base_demons_level{demons_id = 3,level = 15,exp = 234,attr = [{1,1500},{2,30000},{3,750},{4,750}]};

get_demons_level_cfg(3,16) ->
	#base_demons_level{demons_id = 3,level = 16,exp = 312,attr = [{1,1600},{2,32000},{3,800},{4,800}]};

get_demons_level_cfg(3,17) ->
	#base_demons_level{demons_id = 3,level = 17,exp = 390,attr = [{1,1700},{2,34000},{3,850},{4,850}]};

get_demons_level_cfg(3,18) ->
	#base_demons_level{demons_id = 3,level = 18,exp = 468,attr = [{1,1800},{2,36000},{3,900},{4,900}]};

get_demons_level_cfg(3,19) ->
	#base_demons_level{demons_id = 3,level = 19,exp = 585,attr = [{1,1900},{2,38000},{3,950},{4,950}]};

get_demons_level_cfg(3,20) ->
	#base_demons_level{demons_id = 3,level = 20,exp = 780,attr = [{1,2000},{2,40000},{3,1000},{4,1000}]};

get_demons_level_cfg(3,21) ->
	#base_demons_level{demons_id = 3,level = 21,exp = 99,attr = [{1,2100},{2,42000},{3,1050},{4,1050}]};

get_demons_level_cfg(3,22) ->
	#base_demons_level{demons_id = 3,level = 22,exp = 150,attr = [{1,2200},{2,44000},{3,1100},{4,1100}]};

get_demons_level_cfg(3,23) ->
	#base_demons_level{demons_id = 3,level = 23,exp = 201,attr = [{1,2300},{2,46000},{3,1150},{4,1150}]};

get_demons_level_cfg(3,24) ->
	#base_demons_level{demons_id = 3,level = 24,exp = 252,attr = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_demons_level_cfg(3,25) ->
	#base_demons_level{demons_id = 3,level = 25,exp = 303,attr = [{1,2500},{2,50000},{3,1250},{4,1250}]};

get_demons_level_cfg(3,26) ->
	#base_demons_level{demons_id = 3,level = 26,exp = 405,attr = [{1,2600},{2,52000},{3,1300},{4,1300}]};

get_demons_level_cfg(3,27) ->
	#base_demons_level{demons_id = 3,level = 27,exp = 507,attr = [{1,2700},{2,54000},{3,1350},{4,1350}]};

get_demons_level_cfg(3,28) ->
	#base_demons_level{demons_id = 3,level = 28,exp = 606,attr = [{1,2800},{2,56000},{3,1400},{4,1400}]};

get_demons_level_cfg(3,29) ->
	#base_demons_level{demons_id = 3,level = 29,exp = 759,attr = [{1,2900},{2,58000},{3,1450},{4,1450}]};

get_demons_level_cfg(3,30) ->
	#base_demons_level{demons_id = 3,level = 30,exp = 1014,attr = [{1,3000},{2,60000},{3,1500},{4,1500}]};

get_demons_level_cfg(3,31) ->
	#base_demons_level{demons_id = 3,level = 31,exp = 126,attr = [{1,3100},{2,62000},{3,1550},{4,1550}]};

get_demons_level_cfg(3,32) ->
	#base_demons_level{demons_id = 3,level = 32,exp = 195,attr = [{1,3200},{2,64000},{3,1600},{4,1600}]};

get_demons_level_cfg(3,33) ->
	#base_demons_level{demons_id = 3,level = 33,exp = 261,attr = [{1,3300},{2,66000},{3,1650},{4,1650}]};

get_demons_level_cfg(3,34) ->
	#base_demons_level{demons_id = 3,level = 34,exp = 327,attr = [{1,3400},{2,68000},{3,1700},{4,1700}]};

get_demons_level_cfg(3,35) ->
	#base_demons_level{demons_id = 3,level = 35,exp = 393,attr = [{1,3500},{2,70000},{3,1750},{4,1750}]};

get_demons_level_cfg(3,36) ->
	#base_demons_level{demons_id = 3,level = 36,exp = 525,attr = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_demons_level_cfg(3,37) ->
	#base_demons_level{demons_id = 3,level = 37,exp = 657,attr = [{1,3700},{2,74000},{3,1850},{4,1850}]};

get_demons_level_cfg(3,38) ->
	#base_demons_level{demons_id = 3,level = 38,exp = 786,attr = [{1,3800},{2,76000},{3,1900},{4,1900}]};

get_demons_level_cfg(3,39) ->
	#base_demons_level{demons_id = 3,level = 39,exp = 984,attr = [{1,3900},{2,78000},{3,1950},{4,1950}]};

get_demons_level_cfg(3,40) ->
	#base_demons_level{demons_id = 3,level = 40,exp = 1317,attr = [{1,4000},{2,80000},{3,2000},{4,2000}]};

get_demons_level_cfg(3,41) ->
	#base_demons_level{demons_id = 3,level = 41,exp = 162,attr = [{1,4100},{2,82000},{3,2050},{4,2050}]};

get_demons_level_cfg(3,42) ->
	#base_demons_level{demons_id = 3,level = 42,exp = 252,attr = [{1,4200},{2,84000},{3,2100},{4,2100}]};

get_demons_level_cfg(3,43) ->
	#base_demons_level{demons_id = 3,level = 43,exp = 339,attr = [{1,4300},{2,86000},{3,2150},{4,2150}]};

get_demons_level_cfg(3,44) ->
	#base_demons_level{demons_id = 3,level = 44,exp = 423,attr = [{1,4400},{2,88000},{3,2200},{4,2200}]};

get_demons_level_cfg(3,45) ->
	#base_demons_level{demons_id = 3,level = 45,exp = 510,attr = [{1,4500},{2,90000},{3,2250},{4,2250}]};

get_demons_level_cfg(3,46) ->
	#base_demons_level{demons_id = 3,level = 46,exp = 681,attr = [{1,4600},{2,92000},{3,2300},{4,2300}]};

get_demons_level_cfg(3,47) ->
	#base_demons_level{demons_id = 3,level = 47,exp = 852,attr = [{1,4700},{2,94000},{3,2350},{4,2350}]};

get_demons_level_cfg(3,48) ->
	#base_demons_level{demons_id = 3,level = 48,exp = 1020,attr = [{1,4800},{2,96000},{3,2400},{4,2400}]};

get_demons_level_cfg(3,49) ->
	#base_demons_level{demons_id = 3,level = 49,exp = 1278,attr = [{1,4900},{2,98000},{3,2450},{4,2450}]};

get_demons_level_cfg(3,50) ->
	#base_demons_level{demons_id = 3,level = 50,exp = 1710,attr = [{1,5000},{2,100000},{3,2500},{4,2500}]};

get_demons_level_cfg(3,51) ->
	#base_demons_level{demons_id = 3,level = 51,exp = 243,attr = [{1,5100},{2,102000},{3,2550},{4,2550}]};

get_demons_level_cfg(3,52) ->
	#base_demons_level{demons_id = 3,level = 52,exp = 378,attr = [{1,5200},{2,104000},{3,2600},{4,2600}]};

get_demons_level_cfg(3,53) ->
	#base_demons_level{demons_id = 3,level = 53,exp = 507,attr = [{1,5300},{2,106000},{3,2650},{4,2650}]};

get_demons_level_cfg(3,54) ->
	#base_demons_level{demons_id = 3,level = 54,exp = 633,attr = [{1,5400},{2,108000},{3,2700},{4,2700}]};

get_demons_level_cfg(3,55) ->
	#base_demons_level{demons_id = 3,level = 55,exp = 765,attr = [{1,5500},{2,110000},{3,2750},{4,2750}]};

get_demons_level_cfg(3,56) ->
	#base_demons_level{demons_id = 3,level = 56,exp = 1020,attr = [{1,5600},{2,112000},{3,2800},{4,2800}]};

get_demons_level_cfg(3,57) ->
	#base_demons_level{demons_id = 3,level = 57,exp = 1278,attr = [{1,5700},{2,114000},{3,2850},{4,2850}]};

get_demons_level_cfg(3,58) ->
	#base_demons_level{demons_id = 3,level = 58,exp = 1530,attr = [{1,5800},{2,116000},{3,2900},{4,2900}]};

get_demons_level_cfg(3,59) ->
	#base_demons_level{demons_id = 3,level = 59,exp = 1917,attr = [{1,5900},{2,118000},{3,2950},{4,2950}]};

get_demons_level_cfg(3,60) ->
	#base_demons_level{demons_id = 3,level = 60,exp = 2565,attr = [{1,6000},{2,120000},{3,3000},{4,3000}]};

get_demons_level_cfg(3,61) ->
	#base_demons_level{demons_id = 3,level = 61,exp = 363,attr = [{1,6100},{2,122000},{3,3050},{4,3050}]};

get_demons_level_cfg(3,62) ->
	#base_demons_level{demons_id = 3,level = 62,exp = 567,attr = [{1,6200},{2,124000},{3,3100},{4,3100}]};

get_demons_level_cfg(3,63) ->
	#base_demons_level{demons_id = 3,level = 63,exp = 759,attr = [{1,6300},{2,126000},{3,3150},{4,3150}]};

get_demons_level_cfg(3,64) ->
	#base_demons_level{demons_id = 3,level = 64,exp = 948,attr = [{1,6400},{2,128000},{3,3200},{4,3200}]};

get_demons_level_cfg(3,65) ->
	#base_demons_level{demons_id = 3,level = 65,exp = 1146,attr = [{1,6500},{2,130000},{3,3250},{4,3250}]};

get_demons_level_cfg(3,66) ->
	#base_demons_level{demons_id = 3,level = 66,exp = 1530,attr = [{1,6600},{2,132000},{3,3300},{4,3300}]};

get_demons_level_cfg(3,67) ->
	#base_demons_level{demons_id = 3,level = 67,exp = 1917,attr = [{1,6700},{2,134000},{3,3350},{4,3350}]};

get_demons_level_cfg(3,68) ->
	#base_demons_level{demons_id = 3,level = 68,exp = 2295,attr = [{1,6800},{2,136000},{3,3400},{4,3400}]};

get_demons_level_cfg(3,69) ->
	#base_demons_level{demons_id = 3,level = 69,exp = 2874,attr = [{1,6900},{2,138000},{3,3450},{4,3450}]};

get_demons_level_cfg(3,70) ->
	#base_demons_level{demons_id = 3,level = 70,exp = 3846,attr = [{1,7000},{2,140000},{3,3500},{4,3500}]};

get_demons_level_cfg(3,71) ->
	#base_demons_level{demons_id = 3,level = 71,exp = 543,attr = [{1,7100},{2,142000},{3,3550},{4,3550}]};

get_demons_level_cfg(3,72) ->
	#base_demons_level{demons_id = 3,level = 72,exp = 849,attr = [{1,7200},{2,144000},{3,3600},{4,3600}]};

get_demons_level_cfg(3,73) ->
	#base_demons_level{demons_id = 3,level = 73,exp = 1137,attr = [{1,7300},{2,146000},{3,3650},{4,3650}]};

get_demons_level_cfg(3,74) ->
	#base_demons_level{demons_id = 3,level = 74,exp = 1422,attr = [{1,7400},{2,148000},{3,3700},{4,3700}]};

get_demons_level_cfg(3,75) ->
	#base_demons_level{demons_id = 3,level = 75,exp = 1719,attr = [{1,7500},{2,150000},{3,3750},{4,3750}]};

get_demons_level_cfg(3,76) ->
	#base_demons_level{demons_id = 3,level = 76,exp = 2295,attr = [{1,7600},{2,152000},{3,3800},{4,3800}]};

get_demons_level_cfg(3,77) ->
	#base_demons_level{demons_id = 3,level = 77,exp = 2874,attr = [{1,7700},{2,154000},{3,3850},{4,3850}]};

get_demons_level_cfg(3,78) ->
	#base_demons_level{demons_id = 3,level = 78,exp = 3441,attr = [{1,7800},{2,156000},{3,3900},{4,3900}]};

get_demons_level_cfg(3,79) ->
	#base_demons_level{demons_id = 3,level = 79,exp = 4311,attr = [{1,7900},{2,158000},{3,3950},{4,3950}]};

get_demons_level_cfg(3,80) ->
	#base_demons_level{demons_id = 3,level = 80,exp = 5769,attr = [{1,8000},{2,160000},{3,4000},{4,4000}]};

get_demons_level_cfg(3,81) ->
	#base_demons_level{demons_id = 3,level = 81,exp = 813,attr = [{1,8100},{2,162000},{3,4050},{4,4050}]};

get_demons_level_cfg(3,82) ->
	#base_demons_level{demons_id = 3,level = 82,exp = 1272,attr = [{1,8200},{2,164000},{3,4100},{4,4100}]};

get_demons_level_cfg(3,83) ->
	#base_demons_level{demons_id = 3,level = 83,exp = 1704,attr = [{1,8300},{2,166000},{3,4150},{4,4150}]};

get_demons_level_cfg(3,84) ->
	#base_demons_level{demons_id = 3,level = 84,exp = 2133,attr = [{1,8400},{2,168000},{3,4200},{4,4200}]};

get_demons_level_cfg(3,85) ->
	#base_demons_level{demons_id = 3,level = 85,exp = 2577,attr = [{1,8500},{2,170000},{3,4250},{4,4250}]};

get_demons_level_cfg(3,86) ->
	#base_demons_level{demons_id = 3,level = 86,exp = 3441,attr = [{1,8600},{2,172000},{3,4300},{4,4300}]};

get_demons_level_cfg(3,87) ->
	#base_demons_level{demons_id = 3,level = 87,exp = 4311,attr = [{1,8700},{2,174000},{3,4350},{4,4350}]};

get_demons_level_cfg(3,88) ->
	#base_demons_level{demons_id = 3,level = 88,exp = 5160,attr = [{1,8800},{2,176000},{3,4400},{4,4400}]};

get_demons_level_cfg(3,89) ->
	#base_demons_level{demons_id = 3,level = 89,exp = 6465,attr = [{1,8900},{2,178000},{3,4450},{4,4450}]};

get_demons_level_cfg(3,90) ->
	#base_demons_level{demons_id = 3,level = 90,exp = 8652,attr = [{1,9000},{2,180000},{3,4500},{4,4500}]};

get_demons_level_cfg(3,91) ->
	#base_demons_level{demons_id = 3,level = 91,exp = 1218,attr = [{1,9100},{2,182000},{3,4550},{4,4550}]};

get_demons_level_cfg(3,92) ->
	#base_demons_level{demons_id = 3,level = 92,exp = 1908,attr = [{1,9200},{2,184000},{3,4600},{4,4600}]};

get_demons_level_cfg(3,93) ->
	#base_demons_level{demons_id = 3,level = 93,exp = 2556,attr = [{1,9300},{2,186000},{3,4650},{4,4650}]};

get_demons_level_cfg(3,94) ->
	#base_demons_level{demons_id = 3,level = 94,exp = 3198,attr = [{1,9400},{2,188000},{3,4700},{4,4700}]};

get_demons_level_cfg(3,95) ->
	#base_demons_level{demons_id = 3,level = 95,exp = 3864,attr = [{1,9500},{2,190000},{3,4750},{4,4750}]};

get_demons_level_cfg(3,96) ->
	#base_demons_level{demons_id = 3,level = 96,exp = 5160,attr = [{1,9600},{2,192000},{3,4800},{4,4800}]};

get_demons_level_cfg(3,97) ->
	#base_demons_level{demons_id = 3,level = 97,exp = 6465,attr = [{1,9700},{2,194000},{3,4850},{4,4850}]};

get_demons_level_cfg(3,98) ->
	#base_demons_level{demons_id = 3,level = 98,exp = 7740,attr = [{1,9800},{2,196000},{3,4900},{4,4900}]};

get_demons_level_cfg(3,99) ->
	#base_demons_level{demons_id = 3,level = 99,exp = 9696,attr = [{1,9900},{2,198000},{3,4950},{4,4950}]};

get_demons_level_cfg(3,100) ->
	#base_demons_level{demons_id = 3,level = 100,exp = 12978,attr = [{1,10000},{2,200000},{3,5000},{4,5000}]};

get_demons_level_cfg(_Demonsid,_Level) ->
	[].

get_demons_star_cfg(1001,0) ->
	#base_demons_star{demons_id = 1001,star = 0,cost = [{0,7302001,30}],attr = [{1,1600},{2,32000},{3,800},{4,800},{5,415},{6,415},{7,205},{8,205},{20,40}]};

get_demons_star_cfg(1001,1) ->
	#base_demons_star{demons_id = 1001,star = 1,cost = [{0,7302001,30}],attr = [{1,3520},{2,70400},{3,1760},{4,1760},{5,799},{6,799},{7,589},{8,589},{20,50}]};

get_demons_star_cfg(1001,2) ->
	#base_demons_star{demons_id = 1001,star = 2,cost = [{0,7302001,50}],attr = [{1,6720},{2,134400},{3,3360},{4,3360},{5,1439},{6,1439},{7,1229},{8,1229},{20,60}]};

get_demons_star_cfg(1001,3) ->
	#base_demons_star{demons_id = 1001,star = 3,cost = [{0,7302001,80}],attr = [{1,10720},{2,214400},{3,5360},{4,5360},{5,2239},{6,2239},{7,2029},{8,2029},{20,70}]};

get_demons_star_cfg(1001,4) ->
	#base_demons_star{demons_id = 1001,star = 4,cost = [{0,7302001,120}],attr = [{1,15840},{2,294400},{3,7920},{4,7920},{5,3263},{6,3263},{7,3053},{8,3053},{20,80}]};

get_demons_star_cfg(1001,5) ->
	#base_demons_star{demons_id = 1001,star = 5,cost = [{0,7302001,150}],attr = [{1,20960},{2,374400},{3,10480},{4,10480},{5,4287},{6,4287},{7,4077},{8,4077},{20,90}]};

get_demons_star_cfg(1001,6) ->
	#base_demons_star{demons_id = 1001,star = 6,cost = [{0,7302001,50}],attr = [{1,26080},{2,454400},{3,13040},{4,13040},{5,5311},{6,5311},{7,5101},{8,5101},{20,100}]};

get_demons_star_cfg(1001,7) ->
	#base_demons_star{demons_id = 1001,star = 7,cost = [{0,7302001,80}],attr = [{1,31200},{2,534400},{3,15600},{4,15600},{5,6335},{6,6335},{7,6125},{8,6125},{20,110}]};

get_demons_star_cfg(1001,8) ->
	#base_demons_star{demons_id = 1001,star = 8,cost = [{0,7302001,120}],attr = [{1,36320},{2,614400},{3,18160},{4,18160},{5,7359},{6,7359},{7,7149},{8,7149},{20,120}]};

get_demons_star_cfg(1001,9) ->
	#base_demons_star{demons_id = 1001,star = 9,cost = [{0,7302001,160}],attr = [{1,41440},{2,694400},{3,20720},{4,20720},{5,8383},{6,8383},{7,8173},{8,8173},{20,130}]};

get_demons_star_cfg(1001,10) ->
	#base_demons_star{demons_id = 1001,star = 10,cost = [{0,7302001,200}],attr = [{1,46560},{2,774400},{3,23280},{4,23280},{5,9407},{6,9407},{7,9197},{8,9197},{20,140}]};

get_demons_star_cfg(1002,0) ->
	#base_demons_star{demons_id = 1002,star = 0,cost = [{0,7302002,30}],attr = [{1,1700},{2,34000},{3,850},{4,850},{5,415},{6,415},{7,205},{8,205},{21,150}]};

get_demons_star_cfg(1002,1) ->
	#base_demons_star{demons_id = 1002,star = 1,cost = [{0,7302002,30}],attr = [{1,3740},{2,74800},{3,1870},{4,1870},{5,823},{6,823},{7,613},{8,613},{21,195}]};

get_demons_star_cfg(1002,2) ->
	#base_demons_star{demons_id = 1002,star = 2,cost = [{0,7302002,50}],attr = [{1,7140},{2,142800},{3,3570},{4,3570},{5,1503},{6,1503},{7,1293},{8,1293},{21,240}]};

get_demons_star_cfg(1002,3) ->
	#base_demons_star{demons_id = 1002,star = 3,cost = [{0,7302002,80}],attr = [{1,11390},{2,227800},{3,5695},{4,5695},{5,2353},{6,2353},{7,2143},{8,2143},{21,285}]};

get_demons_star_cfg(1002,4) ->
	#base_demons_star{demons_id = 1002,star = 4,cost = [{0,7302002,120}],attr = [{1,16830},{2,312800},{3,8415},{4,8415},{5,3441},{6,3441},{7,3231},{8,3231},{21,330}]};

get_demons_star_cfg(1002,5) ->
	#base_demons_star{demons_id = 1002,star = 5,cost = [{0,7302002,150}],attr = [{1,22270},{2,397800},{3,11135},{4,11135},{5,4529},{6,4529},{7,4319},{8,4319},{21,375}]};

get_demons_star_cfg(1002,6) ->
	#base_demons_star{demons_id = 1002,star = 6,cost = [{0,7302002,50}],attr = [{1,27710},{2,482800},{3,13855},{4,13855},{5,5617},{6,5617},{7,5407},{8,5407},{21,420}]};

get_demons_star_cfg(1002,7) ->
	#base_demons_star{demons_id = 1002,star = 7,cost = [{0,7302002,80}],attr = [{1,33150},{2,567800},{3,16575},{4,16575},{5,6705},{6,6705},{7,6495},{8,6495},{21,465}]};

get_demons_star_cfg(1002,8) ->
	#base_demons_star{demons_id = 1002,star = 8,cost = [{0,7302002,120}],attr = [{1,38590},{2,652800},{3,19295},{4,19295},{5,7793},{6,7793},{7,7583},{8,7583},{21,510}]};

get_demons_star_cfg(1002,9) ->
	#base_demons_star{demons_id = 1002,star = 9,cost = [{0,7302002,160}],attr = [{1,44030},{2,737800},{3,22015},{4,22015},{5,8881},{6,8881},{7,8671},{8,8671},{21,555}]};

get_demons_star_cfg(1002,10) ->
	#base_demons_star{demons_id = 1002,star = 10,cost = [{0,7302002,200}],attr = [{1,49470},{2,822800},{3,24735},{4,24735},{5,9969},{6,9969},{7,9759},{8,9759},{21,600}]};

get_demons_star_cfg(1003,0) ->
	#base_demons_star{demons_id = 1003,star = 0,cost = [{0,7302003,30}],attr = [{1,1800},{2,36000},{3,900},{4,900},{5,415},{6,415},{7,205},{8,205},{25,300}]};

get_demons_star_cfg(1003,1) ->
	#base_demons_star{demons_id = 1003,star = 1,cost = [{0,7302003,30}],attr = [{1,3960},{2,79200},{3,1980},{4,1980},{5,847},{6,847},{7,637},{8,637},{25,390}]};

get_demons_star_cfg(1003,2) ->
	#base_demons_star{demons_id = 1003,star = 2,cost = [{0,7302003,50}],attr = [{1,7560},{2,151200},{3,3780},{4,3780},{5,1567},{6,1567},{7,1357},{8,1357},{25,480}]};

get_demons_star_cfg(1003,3) ->
	#base_demons_star{demons_id = 1003,star = 3,cost = [{0,7302003,80}],attr = [{1,12060},{2,241200},{3,6030},{4,6030},{5,2467},{6,2467},{7,2257},{8,2257},{25,570}]};

get_demons_star_cfg(1003,4) ->
	#base_demons_star{demons_id = 1003,star = 4,cost = [{0,7302003,120}],attr = [{1,17820},{2,331200},{3,8910},{4,8910},{5,3619},{6,3619},{7,3409},{8,3409},{25,660}]};

get_demons_star_cfg(1003,5) ->
	#base_demons_star{demons_id = 1003,star = 5,cost = [{0,7302003,150}],attr = [{1,23580},{2,421200},{3,11790},{4,11790},{5,4771},{6,4771},{7,4561},{8,4561},{25,750}]};

get_demons_star_cfg(1003,6) ->
	#base_demons_star{demons_id = 1003,star = 6,cost = [{0,7302003,50}],attr = [{1,29340},{2,511200},{3,14670},{4,14670},{5,5923},{6,5923},{7,5713},{8,5713},{25,840}]};

get_demons_star_cfg(1003,7) ->
	#base_demons_star{demons_id = 1003,star = 7,cost = [{0,7302003,80}],attr = [{1,35100},{2,601200},{3,17550},{4,17550},{5,7075},{6,7075},{7,6865},{8,6865},{25,930}]};

get_demons_star_cfg(1003,8) ->
	#base_demons_star{demons_id = 1003,star = 8,cost = [{0,7302003,120}],attr = [{1,40860},{2,691200},{3,20430},{4,20430},{5,8227},{6,8227},{7,8017},{8,8017},{25,1020}]};

get_demons_star_cfg(1003,9) ->
	#base_demons_star{demons_id = 1003,star = 9,cost = [{0,7302003,160}],attr = [{1,46620},{2,781200},{3,23310},{4,23310},{5,9379},{6,9379},{7,9169},{8,9169},{25,1110}]};

get_demons_star_cfg(1003,10) ->
	#base_demons_star{demons_id = 1003,star = 10,cost = [{0,7302003,200}],attr = [{1,52380},{2,871200},{3,26190},{4,26190},{5,10531},{6,10531},{7,10321},{8,10321},{25,1200}]};

get_demons_star_cfg(1004,0) ->
	#base_demons_star{demons_id = 1004,star = 0,cost = [{0,7302004,30}],attr = [{1,1900},{2,38000},{3,950},{4,950},{5,415},{6,415},{7,205},{8,205},{22,160}]};

get_demons_star_cfg(1004,1) ->
	#base_demons_star{demons_id = 1004,star = 1,cost = [{0,7302004,30}],attr = [{1,4180},{2,83600},{3,2090},{4,2090},{5,871},{6,871},{7,661},{8,661},{22,208}]};

get_demons_star_cfg(1004,2) ->
	#base_demons_star{demons_id = 1004,star = 2,cost = [{0,7302004,50}],attr = [{1,7980},{2,159600},{3,3990},{4,3990},{5,1631},{6,1631},{7,1421},{8,1421},{22,256}]};

get_demons_star_cfg(1004,3) ->
	#base_demons_star{demons_id = 1004,star = 3,cost = [{0,7302004,80}],attr = [{1,12730},{2,254600},{3,6365},{4,6365},{5,2581},{6,2581},{7,2371},{8,2371},{22,304}]};

get_demons_star_cfg(1004,4) ->
	#base_demons_star{demons_id = 1004,star = 4,cost = [{0,7302004,120}],attr = [{1,18810},{2,349600},{3,9405},{4,9405},{5,3797},{6,3797},{7,3587},{8,3587},{22,352}]};

get_demons_star_cfg(1004,5) ->
	#base_demons_star{demons_id = 1004,star = 5,cost = [{0,7302004,150}],attr = [{1,24890},{2,444600},{3,12445},{4,12445},{5,5013},{6,5013},{7,4803},{8,4803},{22,400}]};

get_demons_star_cfg(1004,6) ->
	#base_demons_star{demons_id = 1004,star = 6,cost = [{0,7302004,50}],attr = [{1,30970},{2,539600},{3,15485},{4,15485},{5,6229},{6,6229},{7,6019},{8,6019},{22,448}]};

get_demons_star_cfg(1004,7) ->
	#base_demons_star{demons_id = 1004,star = 7,cost = [{0,7302004,80}],attr = [{1,37050},{2,634600},{3,18525},{4,18525},{5,7445},{6,7445},{7,7235},{8,7235},{22,496}]};

get_demons_star_cfg(1004,8) ->
	#base_demons_star{demons_id = 1004,star = 8,cost = [{0,7302004,120}],attr = [{1,43130},{2,729600},{3,21565},{4,21565},{5,8661},{6,8661},{7,8451},{8,8451},{22,544}]};

get_demons_star_cfg(1004,9) ->
	#base_demons_star{demons_id = 1004,star = 9,cost = [{0,7302004,160}],attr = [{1,49210},{2,824600},{3,24605},{4,24605},{5,9877},{6,9877},{7,9667},{8,9667},{22,592}]};

get_demons_star_cfg(1004,10) ->
	#base_demons_star{demons_id = 1004,star = 10,cost = [{0,7302004,200}],attr = [{1,55290},{2,919600},{3,27645},{4,27645},{5,11093},{6,11093},{7,10883},{8,10883},{22,640}]};

get_demons_star_cfg(1005,0) ->
	#base_demons_star{demons_id = 1005,star = 0,cost = [{0,7302005,30}],attr = [{1,3000},{2,60000},{3,1500},{4,1500},{5,415},{6,415},{7,205},{8,205},{24,500}]};

get_demons_star_cfg(1005,1) ->
	#base_demons_star{demons_id = 1005,star = 1,cost = [{0,7302005,30}],attr = [{1,6600},{2,132000},{3,3300},{4,3300},{5,1135},{6,1135},{7,925},{8,925},{24,600}]};

get_demons_star_cfg(1005,2) ->
	#base_demons_star{demons_id = 1005,star = 2,cost = [{0,7302005,50}],attr = [{1,11100},{2,222000},{3,5550},{4,5550},{5,2035},{6,2035},{7,1825},{8,1825},{24,700}]};

get_demons_star_cfg(1005,3) ->
	#base_demons_star{demons_id = 1005,star = 3,cost = [{0,7302005,80}],attr = [{1,17100},{2,342000},{3,8550},{4,8550},{5,3235},{6,3235},{7,3025},{8,3025},{24,800}]};

get_demons_star_cfg(1005,4) ->
	#base_demons_star{demons_id = 1005,star = 4,cost = [{0,7302005,120}],attr = [{1,24600},{2,462000},{3,12300},{4,12300},{5,4735},{6,4735},{7,4525},{8,4525},{24,900}]};

get_demons_star_cfg(1005,5) ->
	#base_demons_star{demons_id = 1005,star = 5,cost = [{0,7302005,150}],attr = [{1,32100},{2,582000},{3,16050},{4,16050},{5,6235},{6,6235},{7,6025},{8,6025},{24,1000}]};

get_demons_star_cfg(1005,6) ->
	#base_demons_star{demons_id = 1005,star = 6,cost = [{0,7302005,50}],attr = [{1,39600},{2,702000},{3,19800},{4,19800},{5,7735},{6,7735},{7,7525},{8,7525},{24,1100}]};

get_demons_star_cfg(1005,7) ->
	#base_demons_star{demons_id = 1005,star = 7,cost = [{0,7302005,80}],attr = [{1,47100},{2,822000},{3,23550},{4,23550},{5,9235},{6,9235},{7,9025},{8,9025},{24,1200}]};

get_demons_star_cfg(1005,8) ->
	#base_demons_star{demons_id = 1005,star = 8,cost = [{0,7302005,120}],attr = [{1,54600},{2,942000},{3,27300},{4,27300},{5,10735},{6,10735},{7,10525},{8,10525},{24,1300}]};

get_demons_star_cfg(1005,9) ->
	#base_demons_star{demons_id = 1005,star = 9,cost = [{0,7302005,160}],attr = [{1,62100},{2,1062000},{3,31050},{4,31050},{5,12235},{6,12235},{7,12025},{8,12025},{24,1400}]};

get_demons_star_cfg(1005,10) ->
	#base_demons_star{demons_id = 1005,star = 10,cost = [{0,7302005,200}],attr = [{1,69600},{2,1182000},{3,34800},{4,34800},{5,13735},{6,13735},{7,13525},{8,13525},{24,1500}]};

get_demons_star_cfg(1006,0) ->
	#base_demons_star{demons_id = 1006,star = 0,cost = [{0,7302006,30}],attr = [{1,3200},{2,64000},{3,1600},{4,1600},{5,415},{6,415},{7,205},{8,205},{19,100}]};

get_demons_star_cfg(1006,1) ->
	#base_demons_star{demons_id = 1006,star = 1,cost = [{0,7302006,30}],attr = [{1,7040},{2,140800},{3,3520},{4,3520},{5,1183},{6,1183},{7,973},{8,973},{19,120}]};

get_demons_star_cfg(1006,2) ->
	#base_demons_star{demons_id = 1006,star = 2,cost = [{0,7302006,50}],attr = [{1,11840},{2,236800},{3,5920},{4,5920},{5,2143},{6,2143},{7,1933},{8,1933},{19,140}]};

get_demons_star_cfg(1006,3) ->
	#base_demons_star{demons_id = 1006,star = 3,cost = [{0,7302006,80}],attr = [{1,18240},{2,364800},{3,9120},{4,9120},{5,3423},{6,3423},{7,3213},{8,3213},{19,160}]};

get_demons_star_cfg(1006,4) ->
	#base_demons_star{demons_id = 1006,star = 4,cost = [{0,7302006,120}],attr = [{1,26240},{2,492800},{3,13120},{4,13120},{5,5023},{6,5023},{7,4813},{8,4813},{19,180}]};

get_demons_star_cfg(1006,5) ->
	#base_demons_star{demons_id = 1006,star = 5,cost = [{0,7302006,150}],attr = [{1,34240},{2,620800},{3,17120},{4,17120},{5,6623},{6,6623},{7,6413},{8,6413},{19,200}]};

get_demons_star_cfg(1006,6) ->
	#base_demons_star{demons_id = 1006,star = 6,cost = [{0,7302006,50}],attr = [{1,42240},{2,748800},{3,21120},{4,21120},{5,8223},{6,8223},{7,8013},{8,8013},{19,220}]};

get_demons_star_cfg(1006,7) ->
	#base_demons_star{demons_id = 1006,star = 7,cost = [{0,7302006,80}],attr = [{1,50240},{2,876800},{3,25120},{4,25120},{5,9823},{6,9823},{7,9613},{8,9613},{19,240}]};

get_demons_star_cfg(1006,8) ->
	#base_demons_star{demons_id = 1006,star = 8,cost = [{0,7302006,120}],attr = [{1,58240},{2,1004800},{3,29120},{4,29120},{5,11423},{6,11423},{7,11213},{8,11213},{19,260}]};

get_demons_star_cfg(1006,9) ->
	#base_demons_star{demons_id = 1006,star = 9,cost = [{0,7302006,160}],attr = [{1,66240},{2,1132800},{3,33120},{4,33120},{5,13023},{6,13023},{7,12813},{8,12813},{19,280}]};

get_demons_star_cfg(1006,10) ->
	#base_demons_star{demons_id = 1006,star = 10,cost = [{0,7302006,200}],attr = [{1,74240},{2,1260800},{3,37120},{4,37120},{5,14623},{6,14623},{7,14413},{8,14413},{19,300}]};

get_demons_star_cfg(1007,0) ->
	#base_demons_star{demons_id = 1007,star = 0,cost = [{0,7302007,30}],attr = [{1,3100},{2,62000},{3,1550},{4,1550},{5,415},{6,415},{7,205},{8,205},{22,250}]};

get_demons_star_cfg(1007,1) ->
	#base_demons_star{demons_id = 1007,star = 1,cost = [{0,7302007,30}],attr = [{1,6820},{2,136400},{3,3410},{4,3410},{5,1159},{6,1159},{7,949},{8,949},{22,300}]};

get_demons_star_cfg(1007,2) ->
	#base_demons_star{demons_id = 1007,star = 2,cost = [{0,7302007,50}],attr = [{1,11470},{2,229400},{3,5735},{4,5735},{5,2089},{6,2089},{7,1879},{8,1879},{22,350}]};

get_demons_star_cfg(1007,3) ->
	#base_demons_star{demons_id = 1007,star = 3,cost = [{0,7302007,80}],attr = [{1,17670},{2,353400},{3,8835},{4,8835},{5,3329},{6,3329},{7,3119},{8,3119},{22,400}]};

get_demons_star_cfg(1007,4) ->
	#base_demons_star{demons_id = 1007,star = 4,cost = [{0,7302007,120}],attr = [{1,25420},{2,477400},{3,12710},{4,12710},{5,4879},{6,4879},{7,4669},{8,4669},{22,450}]};

get_demons_star_cfg(1007,5) ->
	#base_demons_star{demons_id = 1007,star = 5,cost = [{0,7302007,150}],attr = [{1,33170},{2,601400},{3,16585},{4,16585},{5,6429},{6,6429},{7,6219},{8,6219},{22,500}]};

get_demons_star_cfg(1007,6) ->
	#base_demons_star{demons_id = 1007,star = 6,cost = [{0,7302007,50}],attr = [{1,40920},{2,725400},{3,20460},{4,20460},{5,7979},{6,7979},{7,7769},{8,7769},{22,550}]};

get_demons_star_cfg(1007,7) ->
	#base_demons_star{demons_id = 1007,star = 7,cost = [{0,7302007,80}],attr = [{1,48670},{2,849400},{3,24335},{4,24335},{5,9529},{6,9529},{7,9319},{8,9319},{22,600}]};

get_demons_star_cfg(1007,8) ->
	#base_demons_star{demons_id = 1007,star = 8,cost = [{0,7302007,120}],attr = [{1,56420},{2,973400},{3,28210},{4,28210},{5,11079},{6,11079},{7,10869},{8,10869},{22,650}]};

get_demons_star_cfg(1007,9) ->
	#base_demons_star{demons_id = 1007,star = 9,cost = [{0,7302007,160}],attr = [{1,64170},{2,1097400},{3,32085},{4,32085},{5,12629},{6,12629},{7,12419},{8,12419},{22,700}]};

get_demons_star_cfg(1007,10) ->
	#base_demons_star{demons_id = 1007,star = 10,cost = [{0,7302007,200}],attr = [{1,71920},{2,1221400},{3,35960},{4,35960},{5,14179},{6,14179},{7,13969},{8,13969},{22,750}]};

get_demons_star_cfg(1008,0) ->
	#base_demons_star{demons_id = 1008,star = 0,cost = [{0,7302008,30}],attr = [{1,3300},{2,66000},{3,1650},{4,1650},{5,415},{6,415},{7,205},{8,205},{20,100}]};

get_demons_star_cfg(1008,1) ->
	#base_demons_star{demons_id = 1008,star = 1,cost = [{0,7302008,30}],attr = [{1,7260},{2,145200},{3,3630},{4,3630},{5,1207},{6,1207},{7,997},{8,997},{20,120}]};

get_demons_star_cfg(1008,2) ->
	#base_demons_star{demons_id = 1008,star = 2,cost = [{0,7302008,50}],attr = [{1,12210},{2,244200},{3,6105},{4,6105},{5,2197},{6,2197},{7,1987},{8,1987},{20,140}]};

get_demons_star_cfg(1008,3) ->
	#base_demons_star{demons_id = 1008,star = 3,cost = [{0,7302008,80}],attr = [{1,18810},{2,376200},{3,9405},{4,9405},{5,3517},{6,3517},{7,3307},{8,3307},{20,160}]};

get_demons_star_cfg(1008,4) ->
	#base_demons_star{demons_id = 1008,star = 4,cost = [{0,7302008,120}],attr = [{1,27060},{2,508200},{3,13530},{4,13530},{5,5167},{6,5167},{7,4957},{8,4957},{20,180}]};

get_demons_star_cfg(1008,5) ->
	#base_demons_star{demons_id = 1008,star = 5,cost = [{0,7302008,150}],attr = [{1,35310},{2,640200},{3,17655},{4,17655},{5,6817},{6,6817},{7,6607},{8,6607},{20,200}]};

get_demons_star_cfg(1008,6) ->
	#base_demons_star{demons_id = 1008,star = 6,cost = [{0,7302008,50}],attr = [{1,43560},{2,772200},{3,21780},{4,21780},{5,8467},{6,8467},{7,8257},{8,8257},{20,220}]};

get_demons_star_cfg(1008,7) ->
	#base_demons_star{demons_id = 1008,star = 7,cost = [{0,7302008,80}],attr = [{1,51810},{2,904200},{3,25905},{4,25905},{5,10117},{6,10117},{7,9907},{8,9907},{20,240}]};

get_demons_star_cfg(1008,8) ->
	#base_demons_star{demons_id = 1008,star = 8,cost = [{0,7302008,120}],attr = [{1,60060},{2,1036200},{3,30030},{4,30030},{5,11767},{6,11767},{7,11557},{8,11557},{20,260}]};

get_demons_star_cfg(1008,9) ->
	#base_demons_star{demons_id = 1008,star = 9,cost = [{0,7302008,160}],attr = [{1,68310},{2,1168200},{3,34155},{4,34155},{5,13417},{6,13417},{7,13207},{8,13207},{20,280}]};

get_demons_star_cfg(1008,10) ->
	#base_demons_star{demons_id = 1008,star = 10,cost = [{0,7302008,200}],attr = [{1,76560},{2,1300200},{3,38280},{4,38280},{5,15067},{6,15067},{7,14857},{8,14857},{20,300}]};

get_demons_star_cfg(1009,0) ->
	#base_demons_star{demons_id = 1009,star = 0,cost = [{0,7302009,30}],attr = [{1,5000},{2,100000},{3,2500},{4,2500},{5,415},{6,415},{7,205},{8,205},{19,150}]};

get_demons_star_cfg(1009,1) ->
	#base_demons_star{demons_id = 1009,star = 1,cost = [{0,7302009,30}],attr = [{1,11000},{2,220000},{3,5500},{4,5500},{5,1615},{6,1615},{7,1405},{8,1405},{19,180}]};

get_demons_star_cfg(1009,2) ->
	#base_demons_star{demons_id = 1009,star = 2,cost = [{0,7302009,50}],attr = [{1,18500},{2,370000},{3,9250},{4,9250},{5,3115},{6,3115},{7,2905},{8,2905},{19,210}]};

get_demons_star_cfg(1009,3) ->
	#base_demons_star{demons_id = 1009,star = 3,cost = [{0,7302009,80}],attr = [{1,28500},{2,570000},{3,14250},{4,14250},{5,5115},{6,5115},{7,4905},{8,4905},{19,240}]};

get_demons_star_cfg(1009,4) ->
	#base_demons_star{demons_id = 1009,star = 4,cost = [{0,7302009,120}],attr = [{1,41000},{2,770000},{3,20500},{4,20500},{5,7615},{6,7615},{7,7405},{8,7405},{19,270}]};

get_demons_star_cfg(1009,5) ->
	#base_demons_star{demons_id = 1009,star = 5,cost = [{0,7302009,150}],attr = [{1,53500},{2,970000},{3,26750},{4,26750},{5,10115},{6,10115},{7,9905},{8,9905},{19,300}]};

get_demons_star_cfg(1009,6) ->
	#base_demons_star{demons_id = 1009,star = 6,cost = [{0,7302009,50}],attr = [{1,66000},{2,1170000},{3,33000},{4,33000},{5,12615},{6,12615},{7,12405},{8,12405},{19,330}]};

get_demons_star_cfg(1009,7) ->
	#base_demons_star{demons_id = 1009,star = 7,cost = [{0,7302009,80}],attr = [{1,78500},{2,1370000},{3,39250},{4,39250},{5,15115},{6,15115},{7,14905},{8,14905},{19,360}]};

get_demons_star_cfg(1009,8) ->
	#base_demons_star{demons_id = 1009,star = 8,cost = [{0,7302009,120}],attr = [{1,91000},{2,1570000},{3,45500},{4,45500},{5,17615},{6,17615},{7,17405},{8,17405},{19,390}]};

get_demons_star_cfg(1009,9) ->
	#base_demons_star{demons_id = 1009,star = 9,cost = [{0,7302009,160}],attr = [{1,103500},{2,1770000},{3,51750},{4,51750},{5,20115},{6,20115},{7,19905},{8,19905},{19,420}]};

get_demons_star_cfg(1009,10) ->
	#base_demons_star{demons_id = 1009,star = 10,cost = [{0,7302009,200}],attr = [{1,116000},{2,1970000},{3,58000},{4,58000},{5,22615},{6,22615},{7,22405},{8,22405},{19,450}]};

get_demons_star_cfg(1010,0) ->
	#base_demons_star{demons_id = 1010,star = 0,cost = [{0,7302010,30}],attr = [{1,5200},{2,104000},{3,2600},{4,2600},{5,415},{6,415},{7,205},{8,205},{20,150}]};

get_demons_star_cfg(1010,1) ->
	#base_demons_star{demons_id = 1010,star = 1,cost = [{0,7302010,30}],attr = [{1,11440},{2,228800},{3,5720},{4,5720},{5,1663},{6,1663},{7,1453},{8,1453},{20,180}]};

get_demons_star_cfg(1010,2) ->
	#base_demons_star{demons_id = 1010,star = 2,cost = [{0,7302010,50}],attr = [{1,19240},{2,384800},{3,9620},{4,9620},{5,3223},{6,3223},{7,3013},{8,3013},{20,210}]};

get_demons_star_cfg(1010,3) ->
	#base_demons_star{demons_id = 1010,star = 3,cost = [{0,7302010,80}],attr = [{1,29640},{2,592800},{3,14820},{4,14820},{5,5303},{6,5303},{7,5093},{8,5093},{20,240}]};

get_demons_star_cfg(1010,4) ->
	#base_demons_star{demons_id = 1010,star = 4,cost = [{0,7302010,120}],attr = [{1,42640},{2,800800},{3,21320},{4,21320},{5,7903},{6,7903},{7,7693},{8,7693},{20,270}]};

get_demons_star_cfg(1010,5) ->
	#base_demons_star{demons_id = 1010,star = 5,cost = [{0,7302010,150}],attr = [{1,55640},{2,1008800},{3,27820},{4,27820},{5,10503},{6,10503},{7,10293},{8,10293},{20,300}]};

get_demons_star_cfg(1010,6) ->
	#base_demons_star{demons_id = 1010,star = 6,cost = [{0,7302010,50}],attr = [{1,68640},{2,1216800},{3,34320},{4,34320},{5,13103},{6,13103},{7,12893},{8,12893},{20,330}]};

get_demons_star_cfg(1010,7) ->
	#base_demons_star{demons_id = 1010,star = 7,cost = [{0,7302010,80}],attr = [{1,81640},{2,1424800},{3,40820},{4,40820},{5,15703},{6,15703},{7,15493},{8,15493},{20,360}]};

get_demons_star_cfg(1010,8) ->
	#base_demons_star{demons_id = 1010,star = 8,cost = [{0,7302010,120}],attr = [{1,94640},{2,1632800},{3,47320},{4,47320},{5,18303},{6,18303},{7,18093},{8,18093},{20,390}]};

get_demons_star_cfg(1010,9) ->
	#base_demons_star{demons_id = 1010,star = 9,cost = [{0,7302010,160}],attr = [{1,107640},{2,1840800},{3,53820},{4,53820},{5,20903},{6,20903},{7,20693},{8,20693},{20,420}]};

get_demons_star_cfg(1010,10) ->
	#base_demons_star{demons_id = 1010,star = 10,cost = [{0,7302010,200}],attr = [{1,120640},{2,2048800},{3,60320},{4,60320},{5,23503},{6,23503},{7,23293},{8,23293},{20,450}]};

get_demons_star_cfg(1011,0) ->
	#base_demons_star{demons_id = 1011,star = 0,cost = [{0,7302011,30}],attr = [{1,5300},{2,106000},{3,2650},{4,2650},{5,415},{6,415},{7,205},{8,205},{21,300}]};

get_demons_star_cfg(1011,1) ->
	#base_demons_star{demons_id = 1011,star = 1,cost = [{0,7302011,30}],attr = [{1,11660},{2,233200},{3,5830},{4,5830},{5,1687},{6,1687},{7,1477},{8,1477},{21,360}]};

get_demons_star_cfg(1011,2) ->
	#base_demons_star{demons_id = 1011,star = 2,cost = [{0,7302011,50}],attr = [{1,19610},{2,392200},{3,9805},{4,9805},{5,3277},{6,3277},{7,3067},{8,3067},{21,420}]};

get_demons_star_cfg(1011,3) ->
	#base_demons_star{demons_id = 1011,star = 3,cost = [{0,7302011,80}],attr = [{1,30210},{2,604200},{3,15105},{4,15105},{5,5397},{6,5397},{7,5187},{8,5187},{21,480}]};

get_demons_star_cfg(1011,4) ->
	#base_demons_star{demons_id = 1011,star = 4,cost = [{0,7302011,120}],attr = [{1,43460},{2,816200},{3,21730},{4,21730},{5,8047},{6,8047},{7,7837},{8,7837},{21,540}]};

get_demons_star_cfg(1011,5) ->
	#base_demons_star{demons_id = 1011,star = 5,cost = [{0,7302011,150}],attr = [{1,56710},{2,1028200},{3,28355},{4,28355},{5,10697},{6,10697},{7,10487},{8,10487},{21,60}]};

get_demons_star_cfg(1011,6) ->
	#base_demons_star{demons_id = 1011,star = 6,cost = [{0,7302011,50}],attr = [{1,69960},{2,1240200},{3,34980},{4,34980},{5,13347},{6,13347},{7,13137},{8,13137},{21,660}]};

get_demons_star_cfg(1011,7) ->
	#base_demons_star{demons_id = 1011,star = 7,cost = [{0,7302011,80}],attr = [{1,83210},{2,1452200},{3,41605},{4,41605},{5,15997},{6,15997},{7,15787},{8,15787},{21,720}]};

get_demons_star_cfg(1011,8) ->
	#base_demons_star{demons_id = 1011,star = 8,cost = [{0,7302011,120}],attr = [{1,96460},{2,1664200},{3,48230},{4,48230},{5,18647},{6,18647},{7,18437},{8,18437},{21,780}]};

get_demons_star_cfg(1011,9) ->
	#base_demons_star{demons_id = 1011,star = 9,cost = [{0,7302011,160}],attr = [{1,109710},{2,1876200},{3,54855},{4,54855},{5,21297},{6,21297},{7,21087},{8,21087},{21,840}]};

get_demons_star_cfg(1011,10) ->
	#base_demons_star{demons_id = 1011,star = 10,cost = [{0,7302011,200}],attr = [{1,122960},{2,2088200},{3,61480},{4,61480},{5,23947},{6,23947},{7,23737},{8,23737},{21,900}]};

get_demons_star_cfg(1012,0) ->
	#base_demons_star{demons_id = 1012,star = 0,cost = [{0,7302012,30}],attr = [{1,5400},{2,108000},{3,2700},{4,2700},{5,415},{6,415},{7,205},{8,205},{22,300}]};

get_demons_star_cfg(1012,1) ->
	#base_demons_star{demons_id = 1012,star = 1,cost = [{0,7302012,30}],attr = [{1,11880},{2,237600},{3,5940},{4,5940},{5,1711},{6,1711},{7,1501},{8,1501},{22,360}]};

get_demons_star_cfg(1012,2) ->
	#base_demons_star{demons_id = 1012,star = 2,cost = [{0,7302012,50}],attr = [{1,19980},{2,399600},{3,9990},{4,9990},{5,3331},{6,3331},{7,3121},{8,3121},{22,420}]};

get_demons_star_cfg(1012,3) ->
	#base_demons_star{demons_id = 1012,star = 3,cost = [{0,7302012,80}],attr = [{1,30780},{2,615600},{3,15390},{4,15390},{5,5491},{6,5491},{7,5281},{8,5281},{22,480}]};

get_demons_star_cfg(1012,4) ->
	#base_demons_star{demons_id = 1012,star = 4,cost = [{0,7302012,120}],attr = [{1,44280},{2,831600},{3,22140},{4,22140},{5,8191},{6,8191},{7,7981},{8,7981},{22,540}]};

get_demons_star_cfg(1012,5) ->
	#base_demons_star{demons_id = 1012,star = 5,cost = [{0,7302012,150}],attr = [{1,57780},{2,1047600},{3,28890},{4,28890},{5,10891},{6,10891},{7,10681},{8,10681},{22,600}]};

get_demons_star_cfg(1012,6) ->
	#base_demons_star{demons_id = 1012,star = 6,cost = [{0,7302012,50}],attr = [{1,71280},{2,1263600},{3,35640},{4,35640},{5,13591},{6,13591},{7,13381},{8,13381},{22,660}]};

get_demons_star_cfg(1012,7) ->
	#base_demons_star{demons_id = 1012,star = 7,cost = [{0,7302012,80}],attr = [{1,84780},{2,1479600},{3,42390},{4,42390},{5,16291},{6,16291},{7,16081},{8,16081},{22,720}]};

get_demons_star_cfg(1012,8) ->
	#base_demons_star{demons_id = 1012,star = 8,cost = [{0,7302012,120}],attr = [{1,98280},{2,1695600},{3,49140},{4,49140},{5,18991},{6,18991},{7,18781},{8,18781},{22,780}]};

get_demons_star_cfg(1012,9) ->
	#base_demons_star{demons_id = 1012,star = 9,cost = [{0,7302012,160}],attr = [{1,111780},{2,1911600},{3,55890},{4,55890},{5,21691},{6,21691},{7,21481},{8,21481},{22,840}]};

get_demons_star_cfg(1012,10) ->
	#base_demons_star{demons_id = 1012,star = 10,cost = [{0,7302012,200}],attr = [{1,125280},{2,2127600},{3,62640},{4,62640},{5,24391},{6,24391},{7,24181},{8,24181},{22,900}]};

get_demons_star_cfg(1013,0) ->
	#base_demons_star{demons_id = 1013,star = 0,cost = [{0,7302013,30}],attr = [{1,5500},{2,110000},{3,2750},{4,2750},{5,415},{6,415},{7,205},{8,205},{10,150}]};

get_demons_star_cfg(1013,1) ->
	#base_demons_star{demons_id = 1013,star = 1,cost = [{0,7302013,30}],attr = [{1,12100},{2,242000},{3,6050},{4,6050},{5,1735},{6,1735},{7,1525},{8,1525},{10,180}]};

get_demons_star_cfg(1013,2) ->
	#base_demons_star{demons_id = 1013,star = 2,cost = [{0,7302013,50}],attr = [{1,20350},{2,407000},{3,10175},{4,10175},{5,3385},{6,3385},{7,3175},{8,3175},{10,210}]};

get_demons_star_cfg(1013,3) ->
	#base_demons_star{demons_id = 1013,star = 3,cost = [{0,7302013,80}],attr = [{1,31350},{2,627000},{3,15675},{4,15675},{5,5585},{6,5585},{7,5375},{8,5375},{10,240}]};

get_demons_star_cfg(1013,4) ->
	#base_demons_star{demons_id = 1013,star = 4,cost = [{0,7302013,120}],attr = [{1,45100},{2,847000},{3,22550},{4,22550},{5,8335},{6,8335},{7,8125},{8,8125},{10,270}]};

get_demons_star_cfg(1013,5) ->
	#base_demons_star{demons_id = 1013,star = 5,cost = [{0,7302013,150}],attr = [{1,58850},{2,1067000},{3,29425},{4,29425},{5,11085},{6,11085},{7,10875},{8,10875},{10,300}]};

get_demons_star_cfg(1013,6) ->
	#base_demons_star{demons_id = 1013,star = 6,cost = [{0,7302013,50}],attr = [{1,72600},{2,1287000},{3,36300},{4,36300},{5,13835},{6,13835},{7,13625},{8,13625},{10,330}]};

get_demons_star_cfg(1013,7) ->
	#base_demons_star{demons_id = 1013,star = 7,cost = [{0,7302013,80}],attr = [{1,86350},{2,1507000},{3,43175},{4,43175},{5,16585},{6,16585},{7,16375},{8,16375},{10,360}]};

get_demons_star_cfg(1013,8) ->
	#base_demons_star{demons_id = 1013,star = 8,cost = [{0,7302013,120}],attr = [{1,100100},{2,1727000},{3,50050},{4,50050},{5,19335},{6,19335},{7,19125},{8,19125},{10,390}]};

get_demons_star_cfg(1013,9) ->
	#base_demons_star{demons_id = 1013,star = 9,cost = [{0,7302013,160}],attr = [{1,113850},{2,1947000},{3,56925},{4,56925},{5,22085},{6,22085},{7,21875},{8,21875},{10,420}]};

get_demons_star_cfg(1013,10) ->
	#base_demons_star{demons_id = 1013,star = 10,cost = [{0,7302013,200}],attr = [{1,127600},{2,2167000},{3,63800},{4,63800},{5,24835},{6,24835},{7,24625},{8,24625},{10,450}]};

get_demons_star_cfg(1014,0) ->
	#base_demons_star{demons_id = 1014,star = 0,cost = [{0,7302014,30}],attr = [{1,5600},{2,112000},{3,2800},{4,2800},{5,415},{6,415},{7,205},{8,205},{22,360}]};

get_demons_star_cfg(1014,1) ->
	#base_demons_star{demons_id = 1014,star = 1,cost = [{0,7302014,30}],attr = [{1,12320},{2,246400},{3,6160},{4,6160},{5,1759},{6,1759},{7,1549},{8,1549},{22,432}]};

get_demons_star_cfg(1014,2) ->
	#base_demons_star{demons_id = 1014,star = 2,cost = [{0,7302014,50}],attr = [{1,20720},{2,414400},{3,10360},{4,10360},{5,3439},{6,3439},{7,3229},{8,3229},{22,504}]};

get_demons_star_cfg(1014,3) ->
	#base_demons_star{demons_id = 1014,star = 3,cost = [{0,7302014,80}],attr = [{1,31920},{2,638400},{3,15960},{4,15960},{5,5679},{6,5679},{7,5469},{8,5469},{22,576}]};

get_demons_star_cfg(1014,4) ->
	#base_demons_star{demons_id = 1014,star = 4,cost = [{0,7302014,120}],attr = [{1,45920},{2,862400},{3,22960},{4,22960},{5,8479},{6,8479},{7,8269},{8,8269},{22,648}]};

get_demons_star_cfg(1014,5) ->
	#base_demons_star{demons_id = 1014,star = 5,cost = [{0,7302014,150}],attr = [{1,59920},{2,1086400},{3,29960},{4,29960},{5,11279},{6,11279},{7,11069},{8,11069},{22,720}]};

get_demons_star_cfg(1014,6) ->
	#base_demons_star{demons_id = 1014,star = 6,cost = [{0,7302014,50}],attr = [{1,73920},{2,1310400},{3,36960},{4,36960},{5,14079},{6,14079},{7,13869},{8,13869},{22,792}]};

get_demons_star_cfg(1014,7) ->
	#base_demons_star{demons_id = 1014,star = 7,cost = [{0,7302014,80}],attr = [{1,87920},{2,1534400},{3,43960},{4,43960},{5,16879},{6,16879},{7,16669},{8,16669},{22,864}]};

get_demons_star_cfg(1014,8) ->
	#base_demons_star{demons_id = 1014,star = 8,cost = [{0,7302014,120}],attr = [{1,101920},{2,1758400},{3,50960},{4,50960},{5,19679},{6,19679},{7,19469},{8,19469},{22,936}]};

get_demons_star_cfg(1014,9) ->
	#base_demons_star{demons_id = 1014,star = 9,cost = [{0,7302014,160}],attr = [{1,115920},{2,1982400},{3,57960},{4,57960},{5,22479},{6,22479},{7,22269},{8,22269},{22,1008}]};

get_demons_star_cfg(1014,10) ->
	#base_demons_star{demons_id = 1014,star = 10,cost = [{0,7302014,200}],attr = [{1,129920},{2,2206400},{3,64960},{4,64960},{5,25279},{6,25279},{7,25069},{8,25069},{22,1080}]};

get_demons_star_cfg(1015,0) ->
	#base_demons_star{demons_id = 1015,star = 0,cost = [{0,7302015,30}],attr = [{1,5600},{2,112000},{3,2800},{4,2800},{5,415},{6,415},{7,205},{8,205},{9,150}]};

get_demons_star_cfg(1015,1) ->
	#base_demons_star{demons_id = 1015,star = 1,cost = [{0,7302015,30}],attr = [{1,12320},{2,246400},{3,6160},{4,6160},{5,1759},{6,1759},{7,1549},{8,1549},{9,180}]};

get_demons_star_cfg(1015,2) ->
	#base_demons_star{demons_id = 1015,star = 2,cost = [{0,7302015,50}],attr = [{1,20720},{2,414400},{3,10360},{4,10360},{5,3439},{6,3439},{7,3229},{8,3229},{9,210}]};

get_demons_star_cfg(1015,3) ->
	#base_demons_star{demons_id = 1015,star = 3,cost = [{0,7302015,80}],attr = [{1,31920},{2,638400},{3,15960},{4,15960},{5,5679},{6,5679},{7,5469},{8,5469},{9,240}]};

get_demons_star_cfg(1015,4) ->
	#base_demons_star{demons_id = 1015,star = 4,cost = [{0,7302015,120}],attr = [{1,45920},{2,862400},{3,22960},{4,22960},{5,8479},{6,8479},{7,8269},{8,8269},{9,270}]};

get_demons_star_cfg(1015,5) ->
	#base_demons_star{demons_id = 1015,star = 5,cost = [{0,7302015,150}],attr = [{1,59920},{2,1086400},{3,29960},{4,29960},{5,11279},{6,11279},{7,11069},{8,11069},{9,300}]};

get_demons_star_cfg(1015,6) ->
	#base_demons_star{demons_id = 1015,star = 6,cost = [{0,7302015,50}],attr = [{1,73920},{2,1310400},{3,36960},{4,36960},{5,14079},{6,14079},{7,13869},{8,13869},{9,330}]};

get_demons_star_cfg(1015,7) ->
	#base_demons_star{demons_id = 1015,star = 7,cost = [{0,7302015,80}],attr = [{1,87920},{2,1534400},{3,43960},{4,43960},{5,16879},{6,16879},{7,16669},{8,16669},{9,360}]};

get_demons_star_cfg(1015,8) ->
	#base_demons_star{demons_id = 1015,star = 8,cost = [{0,7302015,120}],attr = [{1,101920},{2,1758400},{3,50960},{4,50960},{5,19679},{6,19679},{7,19469},{8,19469},{9,390}]};

get_demons_star_cfg(1015,9) ->
	#base_demons_star{demons_id = 1015,star = 9,cost = [{0,7302015,160}],attr = [{1,115920},{2,1982400},{3,57960},{4,57960},{5,22479},{6,22479},{7,22269},{8,22269},{9,420}]};

get_demons_star_cfg(1015,10) ->
	#base_demons_star{demons_id = 1015,star = 10,cost = [{0,7302015,200}],attr = [{1,129920},{2,2206400},{3,64960},{4,64960},{5,25279},{6,25279},{7,25069},{8,25069},{9,450}]};

get_demons_star_cfg(_Demonsid,_Star) ->
	[].

get_demons_skill_cfg(1001,101) ->
	#base_demons_skill{demons_id = 1001,skill_id = 101,unlock_star = 0,sk_type = 1,usage = [{process,liveness,{150,20}},{start_calc,0,1}]};

get_demons_skill_cfg(1002,201) ->
	#base_demons_skill{demons_id = 1002,skill_id = 201,unlock_star = 0,sk_type = 1,usage = [{process,activity,80},{start_calc,0,5}]};

get_demons_skill_cfg(1003,301) ->
	#base_demons_skill{demons_id = 1003,skill_id = 301,unlock_star = 0,sk_type = 1,usage = [{process,kill_boss,{10,120}},{start_calc,0,5}]};

get_demons_skill_cfg(1004,401) ->
	#base_demons_skill{demons_id = 1004,skill_id = 401,unlock_star = 0,sk_type = 1,usage = [{process,kill_boss,{7,120}},{start_calc,0,5}]};

get_demons_skill_cfg(1005,501) ->
	#base_demons_skill{demons_id = 1005,skill_id = 501,unlock_star = 0,sk_type = 1,usage = [{process,kill_boss,{2,300}},{start_calc,0,5}]};

get_demons_skill_cfg(1006,601) ->
	#base_demons_skill{demons_id = 1006,skill_id = 601,unlock_star = 0,sk_type = 1,usage = [{process,kill_boss,{4,300}},{start_calc,0,5}]};

get_demons_skill_cfg(1007,701) ->
	#base_demons_skill{demons_id = 1007,skill_id = 701,unlock_star = 0,sk_type = 1,usage = [{process,daily_charge_reward,{2,20}},{start_calc,0,1}]};

get_demons_skill_cfg(1008,801) ->
	#base_demons_skill{demons_id = 1008,skill_id = 801,unlock_star = 0,sk_type = 1,usage = [{process,equip_rating,3000000},{start_calc,1000000,50000}]};

get_demons_skill_cfg(1009,901) ->
	#base_demons_skill{demons_id = 1009,skill_id = 901,unlock_star = 0,sk_type = 1,usage = [{process,dragon_level,1200},{start_calc,400,20}]};

get_demons_skill_cfg(1010,1001) ->
	#base_demons_skill{demons_id = 1010,skill_id = 1001,unlock_star = 0,sk_type = 1,usage = [{process,god_court,60},{start_calc,0,5}]};

get_demons_skill_cfg(1011,1101) ->
	#base_demons_skill{demons_id = 1011,skill_id = 1101,unlock_star = 0,sk_type = 1,usage = [{process,race_act,{40,10}},{start_calc,0,1}]};

get_demons_skill_cfg(1012,1201) ->
	#base_demons_skill{demons_id = 1012,skill_id = 1201,unlock_star = 0,sk_type = 1,usage = [{process,constellation_forge_lv,400},{start_calc,0,10}]};

get_demons_skill_cfg(1013,1301) ->
	#base_demons_skill{demons_id = 1013,skill_id = 1301,unlock_star = 0,sk_type = 1,usage = [{process,god_star,40},{start_calc,0,1}]};

get_demons_skill_cfg(1014,1401) ->
	#base_demons_skill{demons_id = 1014,skill_id = 1401,unlock_star = 0,sk_type = 1,usage = [{process,recharge,150000},{start_calc,0,1000}]};

get_demons_skill_cfg(1015,1501) ->
	#base_demons_skill{demons_id = 1015,skill_id = 1501,unlock_star = 0,sk_type = 1,usage = [{process,consume,100000},{start_calc,0,1000}]};

get_demons_skill_cfg(_Demonsid,_Skillid) ->
	[].


get_skill_by_demons_id(1001) ->
[{101,0,1}];


get_skill_by_demons_id(1002) ->
[{201,0,1}];


get_skill_by_demons_id(1003) ->
[{301,0,1}];


get_skill_by_demons_id(1004) ->
[{401,0,1}];


get_skill_by_demons_id(1005) ->
[{501,0,1}];


get_skill_by_demons_id(1006) ->
[{601,0,1}];


get_skill_by_demons_id(1007) ->
[{701,0,1}];


get_skill_by_demons_id(1008) ->
[{801,0,1}];


get_skill_by_demons_id(1009) ->
[{901,0,1}];


get_skill_by_demons_id(1010) ->
[{1001,0,1}];


get_skill_by_demons_id(1011) ->
[{1101,0,1}];


get_skill_by_demons_id(1012) ->
[{1201,0,1}];


get_skill_by_demons_id(1013) ->
[{1301,0,1}];


get_skill_by_demons_id(1014) ->
[{1401,0,1}];


get_skill_by_demons_id(1015) ->
[{1501,0,1}];

get_skill_by_demons_id(_Demonsid) ->
	[].


get_skill_by_sktype(1) ->
[{1001,101},{1002,201},{1003,301},{1004,401},{1005,501},{1006,601},{1007,701},{1008,801},{1009,901},{1010,1001},{1011,1101},{1012,1201},{1013,1301},{1014,1401},{1015,1501}];

get_skill_by_sktype(_Sktype) ->
	[].

get_fetters_cfg(1) ->
	#base_demons_fetters{fetters_id = 1,fetters_name = "以武会友",demons_ids = [1001,1002],attr = [{5,500},{8,800}]};

get_fetters_cfg(2) ->
	#base_demons_fetters{fetters_id = 2,fetters_name = "忠心耿耿",demons_ids = [1001,1003,1004],attr = [{4,1000},{6,1500}]};

get_fetters_cfg(3) ->
	#base_demons_fetters{fetters_id = 3,fetters_name = "不食烟火",demons_ids = [1002,1005,1006],attr = [{7,1500},{5,1500}]};

get_fetters_cfg(4) ->
	#base_demons_fetters{fetters_id = 4,fetters_name = "萌宠集合",demons_ids = [1005,1007,1008],attr = [{2,50000},{7,1500}]};

get_fetters_cfg(5) ->
	#base_demons_fetters{fetters_id = 5,fetters_name = "日料大餐",demons_ids = [1005,1006,1009],attr = [{1,2000},{4,2000}]};

get_fetters_cfg(6) ->
	#base_demons_fetters{fetters_id = 6,fetters_name = "猫咪玩具",demons_ids = [1008,1009,1010],attr = [{2,60000},{4,2500}]};

get_fetters_cfg(7) ->
	#base_demons_fetters{fetters_id = 7,fetters_name = "驯兽之王",demons_ids = [1003,1011,1012],attr = [{1,3000},{5,3000}]};

get_fetters_cfg(8) ->
	#base_demons_fetters{fetters_id = 8,fetters_name = "时尚天团",demons_ids = [1004,1010,1013],attr = [{7,3000},{8,3500}]};

get_fetters_cfg(9) ->
	#base_demons_fetters{fetters_id = 9,fetters_name = "天各一方",demons_ids = [1007,1009,1014],attr = [{2,80000},{6,2500}]};

get_fetters_cfg(10) ->
	#base_demons_fetters{fetters_id = 10,fetters_name = "森林传说",demons_ids = [1003,1012,1015],attr = [{1,3000},{2,100000}]};

get_fetters_cfg(_Fettersid) ->
	[].

get_all_fetters() ->
[1,2,3,4,5,6,7,8,9,10].

get_painting_cfg(1) ->
	#base_demons_painting{painting_id = 1,painting_num = 3,attr = [{1,1000},{2,20000},{3,500},{4,500}],reward = [{100,7302002,2},{0,7301001,10}]};

get_painting_cfg(2) ->
	#base_demons_painting{painting_id = 2,painting_num = 6,attr = [{1,2000},{2,40000},{3,1000},{4,1000}],reward = [{100,7302002,3},{0,7301001,12}]};

get_painting_cfg(3) ->
	#base_demons_painting{painting_id = 3,painting_num = 9,attr = [{1,3000},{2,60000},{3,1500},{4,1500}],reward = [{100,7302002,5},{0,7301001,14}]};

get_painting_cfg(4) ->
	#base_demons_painting{painting_id = 4,painting_num = 12,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],reward = [{100,7302002,8},{0,7301001,16},{0,7301003,10}]};

get_painting_cfg(5) ->
	#base_demons_painting{painting_id = 5,painting_num = 15,attr = [{1,5500},{2,110000},{3,2750},{4,2750}],reward = [{100,7302003,2},{0,7301001,18},{0,7301003,12}]};

get_painting_cfg(6) ->
	#base_demons_painting{painting_id = 6,painting_num = 20,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],reward = [{100,7302003,3},{0,7301001,20},{0,7301003,14}]};

get_painting_cfg(7) ->
	#base_demons_painting{painting_id = 7,painting_num = 30,attr = [{1,8500},{2,170000},{3,4250},{4,4250}],reward = [{100,7302003,5},{0,7301001,22},{0,7301003,16},{0,7301005,10}]};

get_painting_cfg(8) ->
	#base_demons_painting{painting_id = 8,painting_num = 40,attr = [{1,10000},{2,200000},{3,5000},{4,5000}],reward = [{100,7302003,8},{0,7301001,24},{0,7301003,18},{0,7301005,12}]};

get_painting_cfg(9) ->
	#base_demons_painting{painting_id = 9,painting_num = 50,attr = [{1,12000},{2,240000},{3,6000},{4,6000}],reward = [{100,7302007,2},{0,7301001,26},{0,7301003,20},{0,7301005,14}]};

get_painting_cfg(10) ->
	#base_demons_painting{painting_id = 10,painting_num = 60,attr = [{1,14000},{2,280000},{3,7000},{4,7000}],reward = [{100,7302007,3},{0,7301001,28},{0,7301003,22},{0,7301005,16}]};

get_painting_cfg(11) ->
	#base_demons_painting{painting_id = 11,painting_num = 70,attr = [{1,16000},{2,320000},{3,8000},{4,8000}],reward = [{100,7302007,5},{0,7301001,30},{0,7301003,24},{0,7301005,18}]};

get_painting_cfg(12) ->
	#base_demons_painting{painting_id = 12,painting_num = 80,attr = [{1,18000},{2,360000},{3,9000},{4,9000}],reward = [{100,7302008,2},{0,7301001,32},{0,7301003,26},{0,7301005,20}]};

get_painting_cfg(13) ->
	#base_demons_painting{painting_id = 13,painting_num = 90,attr = [{1,20000},{2,400000},{3,10000},{4,10000}],reward = [{100,7302008,3},{0,7301001,34},{0,7301003,28},{0,7301005,22}]};

get_painting_cfg(14) ->
	#base_demons_painting{painting_id = 14,painting_num = 100,attr = [{1,22000},{2,440000},{3,11000},{4,11000}],reward = [{100,7302008,5},{0,7301001,36},{0,7301003,30},{0,7301005,24}]};

get_painting_cfg(_Paintingid) ->
	[].

get_painting_attr_all() ->
[{3,[{1,1000},{2,20000},{3,500},{4,500}]},{6,[{1,2000},{2,40000},{3,1000},{4,1000}]},{9,[{1,3000},{2,60000},{3,1500},{4,1500}]},{12,[{1,4000},{2,80000},{3,2000},{4,2000}]},{15,[{1,5500},{2,110000},{3,2750},{4,2750}]},{20,[{1,7000},{2,140000},{3,3500},{4,3500}]},{30,[{1,8500},{2,170000},{3,4250},{4,4250}]},{40,[{1,10000},{2,200000},{3,5000},{4,5000}]},{50,[{1,12000},{2,240000},{3,6000},{4,6000}]},{60,[{1,14000},{2,280000},{3,7000},{4,7000}]},{70,[{1,16000},{2,320000},{3,8000},{4,8000}]},{80,[{1,18000},{2,360000},{3,9000},{4,9000}]},{90,[{1,20000},{2,400000},{3,10000},{4,10000}]},{100,[{1,22000},{2,440000},{3,11000},{4,11000}]}].

get_demons_skill_upgrade_cfg(101,1) ->
	#base_demons_skill_upgrade{skill_id = 101,level = 1,cost = [],usage = [{attr,[{2,2000}]},{buff,4,[{reward,[{0,7306001,1}]}]}]};

get_demons_skill_upgrade_cfg(201,1) ->
	#base_demons_skill_upgrade{skill_id = 201,level = 1,cost = [],usage = [{attr,[{1,120}]},{buff,9,4401002}]};

get_demons_skill_upgrade_cfg(301,1) ->
	#base_demons_skill_upgrade{skill_id = 301,level = 1,cost = [],usage = [{attr,[{3,200}]},{buff,2,[{onhook_time,18000},{reward,[{0,7306002,1}]}]}]};

get_demons_skill_upgrade_cfg(401,1) ->
	#base_demons_skill_upgrade{skill_id = 401,level = 1,cost = [],usage = [{attr,[{4,120}]},{buff,1,5000}]};

get_demons_skill_upgrade_cfg(501,1) ->
	#base_demons_skill_upgrade{skill_id = 501,level = 1,cost = [],usage = [{attr,[{8,300}]},{buff,7,1000}]};

get_demons_skill_upgrade_cfg(601,1) ->
	#base_demons_skill_upgrade{skill_id = 601,level = 1,cost = [],usage = [{attr,[{5,500}]},{buff,6,500}]};

get_demons_skill_upgrade_cfg(701,1) ->
	#base_demons_skill_upgrade{skill_id = 701,level = 1,cost = [],usage = [{attr,[{7,500}]}]};

get_demons_skill_upgrade_cfg(801,1) ->
	#base_demons_skill_upgrade{skill_id = 801,level = 1,cost = [],usage = [{attr,[{6,50}]}]};

get_demons_skill_upgrade_cfg(901,1) ->
	#base_demons_skill_upgrade{skill_id = 901,level = 1,cost = [],usage = [{attr,[{2,4000}]}]};

get_demons_skill_upgrade_cfg(1001,1) ->
	#base_demons_skill_upgrade{skill_id = 1001,level = 1,cost = [],usage = [{attr,[{46,125}]}]};

get_demons_skill_upgrade_cfg(1101,1) ->
	#base_demons_skill_upgrade{skill_id = 1101,level = 1,cost = [],usage = [{attr,[{1,1000}]},{buff,8,[{rank,1,1,5},{rank,2,3,4},{rank,4,10,3},{rank,11,15,3},{rank,16,50,1}]}]};

get_demons_skill_upgrade_cfg(1201,1) ->
	#base_demons_skill_upgrade{skill_id = 1201,level = 1,cost = [],usage = [{attr,[{4,150}]}]};

get_demons_skill_upgrade_cfg(1301,1) ->
	#base_demons_skill_upgrade{skill_id = 1301,level = 1,cost = [],usage = [{attr,[{2,4000}]}]};

get_demons_skill_upgrade_cfg(1401,1) ->
	#base_demons_skill_upgrade{skill_id = 1401,level = 1,cost = [],usage = [{attr,[{1,300}]}]};

get_demons_skill_upgrade_cfg(1501,1) ->
	#base_demons_skill_upgrade{skill_id = 1501,level = 1,cost = [],usage = [{attr,[{7,300}]}]};

get_demons_skill_upgrade_cfg(_Skillid,_Level) ->
	[].


get_skill_map(101) ->
[{4401001,4401016,0}];


get_skill_map(201) ->
[{4401002,4401017,0}];


get_skill_map(301) ->
[{4401003,4401018,0}];


get_skill_map(401) ->
[{4401004,4401019,0}];


get_skill_map(501) ->
[{4401005,4401020,0}];


get_skill_map(601) ->
[{4401006,4401021,0}];


get_skill_map(701) ->
[{4401007,4401022,0}];


get_skill_map(801) ->
[{4401008,4401023,0}];


get_skill_map(901) ->
[{4401009,4401024,0}];


get_skill_map(1001) ->
[{4401010,4401025,0}];


get_skill_map(1101) ->
[{4401011,4401026,0}];


get_skill_map(1201) ->
[{4401012,4401027,0}];


get_skill_map(1301) ->
[{4401013,4401028,0}];


get_skill_map(1401) ->
[{4401014,4401029,0}];


get_skill_map(1501) ->
[{4401015,4401030,0}];

get_skill_map(_Skillid) ->
	[].

get_skill_info(4201001) ->
	#base_demons_skill_add{skill_id = 4201001,goods_id = 7304101,quality = 1,sort = 1};

get_skill_info(4201002) ->
	#base_demons_skill_add{skill_id = 4201002,goods_id = 7304102,quality = 1,sort = 2};

get_skill_info(4201003) ->
	#base_demons_skill_add{skill_id = 4201003,goods_id = 7304103,quality = 1,sort = 3};

get_skill_info(4201004) ->
	#base_demons_skill_add{skill_id = 4201004,goods_id = 7304104,quality = 1,sort = 4};

get_skill_info(4202001) ->
	#base_demons_skill_add{skill_id = 4202001,goods_id = 7304201,quality = 2,sort = 1};

get_skill_info(4202002) ->
	#base_demons_skill_add{skill_id = 4202002,goods_id = 7304202,quality = 2,sort = 2};

get_skill_info(4202003) ->
	#base_demons_skill_add{skill_id = 4202003,goods_id = 7304203,quality = 2,sort = 3};

get_skill_info(4202004) ->
	#base_demons_skill_add{skill_id = 4202004,goods_id = 7304204,quality = 2,sort = 4};

get_skill_info(4203001) ->
	#base_demons_skill_add{skill_id = 4203001,goods_id = 7304301,quality = 3,sort = 1};

get_skill_info(4203002) ->
	#base_demons_skill_add{skill_id = 4203002,goods_id = 7304302,quality = 3,sort = 2};

get_skill_info(4203003) ->
	#base_demons_skill_add{skill_id = 4203003,goods_id = 7304303,quality = 3,sort = 3};

get_skill_info(4203004) ->
	#base_demons_skill_add{skill_id = 4203004,goods_id = 7304304,quality = 3,sort = 4};

get_skill_info(4203005) ->
	#base_demons_skill_add{skill_id = 4203005,goods_id = 7304305,quality = 3,sort = 5};

get_skill_info(4203006) ->
	#base_demons_skill_add{skill_id = 4203006,goods_id = 7304306,quality = 3,sort = 6};

get_skill_info(4203007) ->
	#base_demons_skill_add{skill_id = 4203007,goods_id = 7304307,quality = 3,sort = 7};

get_skill_info(4203008) ->
	#base_demons_skill_add{skill_id = 4203008,goods_id = 7304308,quality = 3,sort = 8};

get_skill_info(4203009) ->
	#base_demons_skill_add{skill_id = 4203009,goods_id = 7304309,quality = 3,sort = 9};

get_skill_info(4203010) ->
	#base_demons_skill_add{skill_id = 4203010,goods_id = 7304310,quality = 3,sort = 10};

get_skill_info(4203011) ->
	#base_demons_skill_add{skill_id = 4203011,goods_id = 7304311,quality = 3,sort = 11};

get_skill_info(4204001) ->
	#base_demons_skill_add{skill_id = 4204001,goods_id = 7304401,quality = 4,sort = 5};

get_skill_info(4204002) ->
	#base_demons_skill_add{skill_id = 4204002,goods_id = 7304402,quality = 4,sort = 6};

get_skill_info(4204003) ->
	#base_demons_skill_add{skill_id = 4204003,goods_id = 7304403,quality = 4,sort = 7};

get_skill_info(4204004) ->
	#base_demons_skill_add{skill_id = 4204004,goods_id = 7304404,quality = 4,sort = 8};

get_skill_info(4204005) ->
	#base_demons_skill_add{skill_id = 4204005,goods_id = 7304405,quality = 4,sort = 9};

get_skill_info(4204006) ->
	#base_demons_skill_add{skill_id = 4204006,goods_id = 7304406,quality = 4,sort = 10};

get_skill_info(4204007) ->
	#base_demons_skill_add{skill_id = 4204007,goods_id = 7304407,quality = 4,sort = 11};

get_skill_info(4205001) ->
	#base_demons_skill_add{skill_id = 4205001,goods_id = 7304501,quality = 5,sort = 12};

get_skill_info(_Skillid) ->
	[].


get_skill_id_by_goods(7304101) ->
4201001;


get_skill_id_by_goods(7304102) ->
4201002;


get_skill_id_by_goods(7304103) ->
4201003;


get_skill_id_by_goods(7304104) ->
4201004;


get_skill_id_by_goods(7304201) ->
4202001;


get_skill_id_by_goods(7304202) ->
4202002;


get_skill_id_by_goods(7304203) ->
4202003;


get_skill_id_by_goods(7304204) ->
4202004;


get_skill_id_by_goods(7304301) ->
4203001;


get_skill_id_by_goods(7304302) ->
4203002;


get_skill_id_by_goods(7304303) ->
4203003;


get_skill_id_by_goods(7304304) ->
4203004;


get_skill_id_by_goods(7304305) ->
4203005;


get_skill_id_by_goods(7304306) ->
4203006;


get_skill_id_by_goods(7304307) ->
4203007;


get_skill_id_by_goods(7304308) ->
4203008;


get_skill_id_by_goods(7304309) ->
4203009;


get_skill_id_by_goods(7304310) ->
4203010;


get_skill_id_by_goods(7304311) ->
4203011;


get_skill_id_by_goods(7304401) ->
4204001;


get_skill_id_by_goods(7304402) ->
4204002;


get_skill_id_by_goods(7304403) ->
4204003;


get_skill_id_by_goods(7304404) ->
4204004;


get_skill_id_by_goods(7304405) ->
4204005;


get_skill_id_by_goods(7304406) ->
4204006;


get_skill_id_by_goods(7304407) ->
4204007;


get_skill_id_by_goods(7304501) ->
4205001;

get_skill_id_by_goods(_Goodsid) ->
	[].

get_shop_item(1) ->
	#base_demons_shop{id = 1,min_times = 0,max_times = 9,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 90,weight = 48000};

get_shop_item(2) ->
	#base_demons_shop{id = 2,min_times = 0,max_times = 9,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 90,weight = 48000};

get_shop_item(3) ->
	#base_demons_shop{id = 3,min_times = 0,max_times = 9,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 90,weight = 48000};

get_shop_item(4) ->
	#base_demons_shop{id = 4,min_times = 0,max_times = 9,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 90,weight = 48000};

get_shop_item(5) ->
	#base_demons_shop{id = 5,min_times = 0,max_times = 9,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 90,weight = 24912};

get_shop_item(6) ->
	#base_demons_shop{id = 6,min_times = 0,max_times = 9,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 90,weight = 24960};

get_shop_item(7) ->
	#base_demons_shop{id = 7,min_times = 0,max_times = 9,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 90,weight = 24480};

get_shop_item(8) ->
	#base_demons_shop{id = 8,min_times = 0,max_times = 9,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 90,weight = 24480};

get_shop_item(9) ->
	#base_demons_shop{id = 9,min_times = 0,max_times = 9,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 90,weight = 24000};

get_shop_item(10) ->
	#base_demons_shop{id = 10,min_times = 0,max_times = 9,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 90,weight = 24000};

get_shop_item(11) ->
	#base_demons_shop{id = 11,min_times = 0,max_times = 9,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 90,weight = 24000};

get_shop_item(12) ->
	#base_demons_shop{id = 12,min_times = 0,max_times = 9,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 90,weight = 24000};

get_shop_item(13) ->
	#base_demons_shop{id = 13,min_times = 0,max_times = 9,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 90,weight = 6960};

get_shop_item(14) ->
	#base_demons_shop{id = 14,min_times = 0,max_times = 9,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 90,weight = 6960};

get_shop_item(15) ->
	#base_demons_shop{id = 15,min_times = 0,max_times = 9,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 90,weight = 6960};

get_shop_item(16) ->
	#base_demons_shop{id = 16,min_times = 0,max_times = 9,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 90,weight = 6960};

get_shop_item(17) ->
	#base_demons_shop{id = 17,min_times = 0,max_times = 9,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 90,weight = 6960};

get_shop_item(18) ->
	#base_demons_shop{id = 18,min_times = 0,max_times = 9,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 90,weight = 7250};

get_shop_item(19) ->
	#base_demons_shop{id = 19,min_times = 0,max_times = 9,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(20) ->
	#base_demons_shop{id = 20,min_times = 0,max_times = 9,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(21) ->
	#base_demons_shop{id = 21,min_times = 0,max_times = 9,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 90,weight = 2250};

get_shop_item(22) ->
	#base_demons_shop{id = 22,min_times = 0,max_times = 9,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(23) ->
	#base_demons_shop{id = 23,min_times = 0,max_times = 9,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(24) ->
	#base_demons_shop{id = 24,min_times = 0,max_times = 9,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(25) ->
	#base_demons_shop{id = 25,min_times = 0,max_times = 9,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 90,weight = 7250};

get_shop_item(26) ->
	#base_demons_shop{id = 26,min_times = 0,max_times = 9,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 90,weight = 2250};

get_shop_item(27) ->
	#base_demons_shop{id = 27,min_times = 0,max_times = 9,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 90,weight = 2250};

get_shop_item(28) ->
	#base_demons_shop{id = 28,min_times = 0,max_times = 9,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(29) ->
	#base_demons_shop{id = 29,min_times = 0,max_times = 9,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(30) ->
	#base_demons_shop{id = 30,min_times = 0,max_times = 9,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 90,weight = 250};

get_shop_item(31) ->
	#base_demons_shop{id = 31,min_times = 0,max_times = 9,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(32) ->
	#base_demons_shop{id = 32,min_times = 0,max_times = 9,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(33) ->
	#base_demons_shop{id = 33,min_times = 0,max_times = 9,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(34) ->
	#base_demons_shop{id = 34,min_times = 0,max_times = 9,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 500};

get_shop_item(36) ->
	#base_demons_shop{id = 36,min_times = 0,max_times = 9,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 80,weight = 43000};

get_shop_item(37) ->
	#base_demons_shop{id = 37,min_times = 0,max_times = 9,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 80,weight = 43000};

get_shop_item(38) ->
	#base_demons_shop{id = 38,min_times = 0,max_times = 9,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 80,weight = 43000};

get_shop_item(39) ->
	#base_demons_shop{id = 39,min_times = 0,max_times = 9,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 80,weight = 43000};

get_shop_item(40) ->
	#base_demons_shop{id = 40,min_times = 0,max_times = 9,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 80,weight = 22317};

get_shop_item(41) ->
	#base_demons_shop{id = 41,min_times = 0,max_times = 9,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 80,weight = 22360};

get_shop_item(42) ->
	#base_demons_shop{id = 42,min_times = 0,max_times = 9,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 80,weight = 21930};

get_shop_item(43) ->
	#base_demons_shop{id = 43,min_times = 0,max_times = 9,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 80,weight = 21930};

get_shop_item(44) ->
	#base_demons_shop{id = 44,min_times = 0,max_times = 9,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 80,weight = 21500};

get_shop_item(45) ->
	#base_demons_shop{id = 45,min_times = 0,max_times = 9,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 80,weight = 21500};

get_shop_item(46) ->
	#base_demons_shop{id = 46,min_times = 0,max_times = 9,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 80,weight = 21500};

get_shop_item(47) ->
	#base_demons_shop{id = 47,min_times = 0,max_times = 9,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 80,weight = 21500};

get_shop_item(48) ->
	#base_demons_shop{id = 48,min_times = 0,max_times = 9,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 80,weight = 6235};

get_shop_item(49) ->
	#base_demons_shop{id = 49,min_times = 0,max_times = 9,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 80,weight = 6235};

get_shop_item(50) ->
	#base_demons_shop{id = 50,min_times = 0,max_times = 9,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 80,weight = 6235};

get_shop_item(51) ->
	#base_demons_shop{id = 51,min_times = 0,max_times = 9,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 80,weight = 6235};

get_shop_item(52) ->
	#base_demons_shop{id = 52,min_times = 0,max_times = 9,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 80,weight = 6235};

get_shop_item(53) ->
	#base_demons_shop{id = 53,min_times = 0,max_times = 9,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 80,weight = 6525};

get_shop_item(54) ->
	#base_demons_shop{id = 54,min_times = 0,max_times = 9,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(55) ->
	#base_demons_shop{id = 55,min_times = 0,max_times = 9,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(56) ->
	#base_demons_shop{id = 56,min_times = 0,max_times = 9,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 80,weight = 2025};

get_shop_item(57) ->
	#base_demons_shop{id = 57,min_times = 0,max_times = 9,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(58) ->
	#base_demons_shop{id = 58,min_times = 0,max_times = 9,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(59) ->
	#base_demons_shop{id = 59,min_times = 0,max_times = 9,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(60) ->
	#base_demons_shop{id = 60,min_times = 0,max_times = 9,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 80,weight = 6525};

get_shop_item(61) ->
	#base_demons_shop{id = 61,min_times = 0,max_times = 9,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 80,weight = 2025};

get_shop_item(62) ->
	#base_demons_shop{id = 62,min_times = 0,max_times = 9,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 80,weight = 2025};

get_shop_item(63) ->
	#base_demons_shop{id = 63,min_times = 0,max_times = 9,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(64) ->
	#base_demons_shop{id = 64,min_times = 0,max_times = 9,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(65) ->
	#base_demons_shop{id = 65,min_times = 0,max_times = 9,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 80,weight = 225};

get_shop_item(66) ->
	#base_demons_shop{id = 66,min_times = 0,max_times = 9,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(67) ->
	#base_demons_shop{id = 67,min_times = 0,max_times = 9,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(68) ->
	#base_demons_shop{id = 68,min_times = 0,max_times = 9,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(69) ->
	#base_demons_shop{id = 69,min_times = 0,max_times = 9,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 450};

get_shop_item(71) ->
	#base_demons_shop{id = 71,min_times = 0,max_times = 9,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 60,weight = 5000};

get_shop_item(72) ->
	#base_demons_shop{id = 72,min_times = 0,max_times = 9,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 60,weight = 5000};

get_shop_item(73) ->
	#base_demons_shop{id = 73,min_times = 0,max_times = 9,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 60,weight = 5000};

get_shop_item(74) ->
	#base_demons_shop{id = 74,min_times = 0,max_times = 9,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 60,weight = 5000};

get_shop_item(75) ->
	#base_demons_shop{id = 75,min_times = 0,max_times = 9,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 60,weight = 2595};

get_shop_item(76) ->
	#base_demons_shop{id = 76,min_times = 0,max_times = 9,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 60,weight = 2600};

get_shop_item(77) ->
	#base_demons_shop{id = 77,min_times = 0,max_times = 9,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 60,weight = 2550};

get_shop_item(78) ->
	#base_demons_shop{id = 78,min_times = 0,max_times = 9,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 60,weight = 2550};

get_shop_item(79) ->
	#base_demons_shop{id = 79,min_times = 0,max_times = 9,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2500};

get_shop_item(80) ->
	#base_demons_shop{id = 80,min_times = 0,max_times = 9,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2500};

get_shop_item(81) ->
	#base_demons_shop{id = 81,min_times = 0,max_times = 9,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2500};

get_shop_item(82) ->
	#base_demons_shop{id = 82,min_times = 0,max_times = 9,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2500};

get_shop_item(83) ->
	#base_demons_shop{id = 83,min_times = 0,max_times = 9,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 60,weight = 725};

get_shop_item(84) ->
	#base_demons_shop{id = 84,min_times = 0,max_times = 9,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 60,weight = 725};

get_shop_item(85) ->
	#base_demons_shop{id = 85,min_times = 0,max_times = 9,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 60,weight = 725};

get_shop_item(86) ->
	#base_demons_shop{id = 86,min_times = 0,max_times = 9,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 60,weight = 725};

get_shop_item(87) ->
	#base_demons_shop{id = 87,min_times = 0,max_times = 9,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 60,weight = 725};

get_shop_item(88) ->
	#base_demons_shop{id = 88,min_times = 0,max_times = 9,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 60,weight = 725};

get_shop_item(89) ->
	#base_demons_shop{id = 89,min_times = 0,max_times = 9,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(90) ->
	#base_demons_shop{id = 90,min_times = 0,max_times = 9,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(91) ->
	#base_demons_shop{id = 91,min_times = 0,max_times = 9,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 60,weight = 225};

get_shop_item(92) ->
	#base_demons_shop{id = 92,min_times = 0,max_times = 9,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(93) ->
	#base_demons_shop{id = 93,min_times = 0,max_times = 9,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(94) ->
	#base_demons_shop{id = 94,min_times = 0,max_times = 9,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(95) ->
	#base_demons_shop{id = 95,min_times = 0,max_times = 9,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 60,weight = 725};

get_shop_item(96) ->
	#base_demons_shop{id = 96,min_times = 0,max_times = 9,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 60,weight = 225};

get_shop_item(97) ->
	#base_demons_shop{id = 97,min_times = 0,max_times = 9,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 60,weight = 225};

get_shop_item(98) ->
	#base_demons_shop{id = 98,min_times = 0,max_times = 9,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(99) ->
	#base_demons_shop{id = 99,min_times = 0,max_times = 9,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(100) ->
	#base_demons_shop{id = 100,min_times = 0,max_times = 9,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 60,weight = 25};

get_shop_item(101) ->
	#base_demons_shop{id = 101,min_times = 0,max_times = 9,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(102) ->
	#base_demons_shop{id = 102,min_times = 0,max_times = 9,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(103) ->
	#base_demons_shop{id = 103,min_times = 0,max_times = 9,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(104) ->
	#base_demons_shop{id = 104,min_times = 0,max_times = 9,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 50};

get_shop_item(106) ->
	#base_demons_shop{id = 106,min_times = 0,max_times = 9,goods_id = 7301001,num = 5,price = 2,cost_num = 50,discount = 90,weight = 2000};

get_shop_item(107) ->
	#base_demons_shop{id = 107,min_times = 0,max_times = 9,goods_id = 7301001,num = 8,price = 2,cost_num = 80,discount = 90,weight = 2000};

get_shop_item(108) ->
	#base_demons_shop{id = 108,min_times = 0,max_times = 9,goods_id = 7301003,num = 5,price = 2,cost_num = 50,discount = 90,weight = 2000};

get_shop_item(109) ->
	#base_demons_shop{id = 109,min_times = 0,max_times = 9,goods_id = 7301005,num = 5,price = 2,cost_num = 50,discount = 90,weight = 2000};

get_shop_item(110) ->
	#base_demons_shop{id = 110,min_times = 0,max_times = 9,goods_id = 7304101,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1038};

get_shop_item(111) ->
	#base_demons_shop{id = 111,min_times = 0,max_times = 9,goods_id = 7304102,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1040};

get_shop_item(112) ->
	#base_demons_shop{id = 112,min_times = 0,max_times = 9,goods_id = 7304103,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1020};

get_shop_item(113) ->
	#base_demons_shop{id = 113,min_times = 0,max_times = 9,goods_id = 7304104,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1020};

get_shop_item(114) ->
	#base_demons_shop{id = 114,min_times = 0,max_times = 9,goods_id = 7304201,num = 1,price = 2,cost_num = 300,discount = 90,weight = 1000};

get_shop_item(115) ->
	#base_demons_shop{id = 115,min_times = 0,max_times = 9,goods_id = 7304202,num = 1,price = 2,cost_num = 300,discount = 90,weight = 1000};

get_shop_item(116) ->
	#base_demons_shop{id = 116,min_times = 0,max_times = 9,goods_id = 7304203,num = 1,price = 2,cost_num = 300,discount = 90,weight = 1000};

get_shop_item(117) ->
	#base_demons_shop{id = 117,min_times = 0,max_times = 9,goods_id = 7304204,num = 1,price = 2,cost_num = 300,discount = 90,weight = 1000};

get_shop_item(118) ->
	#base_demons_shop{id = 118,min_times = 0,max_times = 9,goods_id = 7304301,num = 1,price = 2,cost_num = 600,discount = 90,weight = 290};

get_shop_item(119) ->
	#base_demons_shop{id = 119,min_times = 0,max_times = 9,goods_id = 7304302,num = 1,price = 2,cost_num = 600,discount = 90,weight = 290};

get_shop_item(120) ->
	#base_demons_shop{id = 120,min_times = 0,max_times = 9,goods_id = 7304303,num = 1,price = 2,cost_num = 600,discount = 90,weight = 290};

get_shop_item(121) ->
	#base_demons_shop{id = 121,min_times = 0,max_times = 9,goods_id = 7304304,num = 1,price = 2,cost_num = 600,discount = 90,weight = 290};

get_shop_item(122) ->
	#base_demons_shop{id = 122,min_times = 0,max_times = 9,goods_id = 7302001,num = 3,price = 2,cost_num = 450,discount = 90,weight = 290};

get_shop_item(123) ->
	#base_demons_shop{id = 123,min_times = 0,max_times = 9,goods_id = 7301001,num = 5,price = 2,cost_num = 50,discount = 80,weight = 2000};

get_shop_item(124) ->
	#base_demons_shop{id = 124,min_times = 0,max_times = 9,goods_id = 7301001,num = 8,price = 2,cost_num = 80,discount = 80,weight = 2000};

get_shop_item(125) ->
	#base_demons_shop{id = 125,min_times = 0,max_times = 9,goods_id = 7301003,num = 5,price = 2,cost_num = 50,discount = 80,weight = 2000};

get_shop_item(126) ->
	#base_demons_shop{id = 126,min_times = 0,max_times = 9,goods_id = 7301005,num = 5,price = 2,cost_num = 50,discount = 80,weight = 2000};

get_shop_item(127) ->
	#base_demons_shop{id = 127,min_times = 0,max_times = 9,goods_id = 7304101,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1038};

get_shop_item(128) ->
	#base_demons_shop{id = 128,min_times = 0,max_times = 9,goods_id = 7304102,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1040};

get_shop_item(129) ->
	#base_demons_shop{id = 129,min_times = 0,max_times = 9,goods_id = 7304103,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1020};

get_shop_item(130) ->
	#base_demons_shop{id = 130,min_times = 0,max_times = 9,goods_id = 7304104,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1020};

get_shop_item(131) ->
	#base_demons_shop{id = 131,min_times = 0,max_times = 9,goods_id = 7304201,num = 1,price = 2,cost_num = 300,discount = 80,weight = 1000};

get_shop_item(132) ->
	#base_demons_shop{id = 132,min_times = 0,max_times = 9,goods_id = 7304202,num = 1,price = 2,cost_num = 300,discount = 80,weight = 1000};

get_shop_item(133) ->
	#base_demons_shop{id = 133,min_times = 0,max_times = 9,goods_id = 7304203,num = 1,price = 2,cost_num = 300,discount = 80,weight = 1000};

get_shop_item(134) ->
	#base_demons_shop{id = 134,min_times = 0,max_times = 9,goods_id = 7304204,num = 1,price = 2,cost_num = 300,discount = 80,weight = 1000};

get_shop_item(135) ->
	#base_demons_shop{id = 135,min_times = 0,max_times = 9,goods_id = 7304301,num = 1,price = 2,cost_num = 600,discount = 80,weight = 290};

get_shop_item(136) ->
	#base_demons_shop{id = 136,min_times = 0,max_times = 9,goods_id = 7304302,num = 1,price = 2,cost_num = 600,discount = 80,weight = 290};

get_shop_item(137) ->
	#base_demons_shop{id = 137,min_times = 0,max_times = 9,goods_id = 7304303,num = 1,price = 2,cost_num = 600,discount = 80,weight = 290};

get_shop_item(138) ->
	#base_demons_shop{id = 138,min_times = 0,max_times = 9,goods_id = 7304304,num = 1,price = 2,cost_num = 600,discount = 80,weight = 290};

get_shop_item(139) ->
	#base_demons_shop{id = 139,min_times = 0,max_times = 9,goods_id = 7302001,num = 3,price = 2,cost_num = 450,discount = 80,weight = 290};

get_shop_item(140) ->
	#base_demons_shop{id = 140,min_times = 10,max_times = 999,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 90,weight = 28800};

get_shop_item(141) ->
	#base_demons_shop{id = 141,min_times = 10,max_times = 999,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 90,weight = 28800};

get_shop_item(142) ->
	#base_demons_shop{id = 142,min_times = 10,max_times = 999,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 90,weight = 28800};

get_shop_item(143) ->
	#base_demons_shop{id = 143,min_times = 10,max_times = 999,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 90,weight = 28800};

get_shop_item(144) ->
	#base_demons_shop{id = 144,min_times = 10,max_times = 999,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 90,weight = 28800};

get_shop_item(145) ->
	#base_demons_shop{id = 145,min_times = 10,max_times = 999,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 90,weight = 28800};

get_shop_item(146) ->
	#base_demons_shop{id = 146,min_times = 10,max_times = 999,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 90,weight = 28800};

get_shop_item(147) ->
	#base_demons_shop{id = 147,min_times = 10,max_times = 999,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 90,weight = 28800};

get_shop_item(148) ->
	#base_demons_shop{id = 148,min_times = 10,max_times = 999,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 90,weight = 19200};

get_shop_item(149) ->
	#base_demons_shop{id = 149,min_times = 10,max_times = 999,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 90,weight = 19200};

get_shop_item(150) ->
	#base_demons_shop{id = 150,min_times = 10,max_times = 999,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 90,weight = 19200};

get_shop_item(151) ->
	#base_demons_shop{id = 151,min_times = 10,max_times = 999,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 90,weight = 19200};

get_shop_item(152) ->
	#base_demons_shop{id = 152,min_times = 10,max_times = 999,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 90,weight = 9600};

get_shop_item(153) ->
	#base_demons_shop{id = 153,min_times = 10,max_times = 999,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 90,weight = 9600};

get_shop_item(154) ->
	#base_demons_shop{id = 154,min_times = 10,max_times = 999,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 90,weight = 9600};

get_shop_item(155) ->
	#base_demons_shop{id = 155,min_times = 10,max_times = 999,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 90,weight = 9600};

get_shop_item(156) ->
	#base_demons_shop{id = 156,min_times = 10,max_times = 999,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 90,weight = 9600};

get_shop_item(157) ->
	#base_demons_shop{id = 157,min_times = 10,max_times = 999,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 90,weight = 10000};

get_shop_item(158) ->
	#base_demons_shop{id = 158,min_times = 10,max_times = 999,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(159) ->
	#base_demons_shop{id = 159,min_times = 10,max_times = 999,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(160) ->
	#base_demons_shop{id = 160,min_times = 10,max_times = 999,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 90,weight = 6000};

get_shop_item(161) ->
	#base_demons_shop{id = 161,min_times = 10,max_times = 999,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(162) ->
	#base_demons_shop{id = 162,min_times = 10,max_times = 999,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(163) ->
	#base_demons_shop{id = 163,min_times = 10,max_times = 999,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(164) ->
	#base_demons_shop{id = 164,min_times = 10,max_times = 999,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 90,weight = 10000};

get_shop_item(165) ->
	#base_demons_shop{id = 165,min_times = 10,max_times = 999,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 90,weight = 15500};

get_shop_item(166) ->
	#base_demons_shop{id = 166,min_times = 10,max_times = 999,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 90,weight = 15500};

get_shop_item(167) ->
	#base_demons_shop{id = 167,min_times = 10,max_times = 999,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(168) ->
	#base_demons_shop{id = 168,min_times = 10,max_times = 999,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(169) ->
	#base_demons_shop{id = 169,min_times = 10,max_times = 999,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 90,weight = 1000};

get_shop_item(170) ->
	#base_demons_shop{id = 170,min_times = 10,max_times = 999,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(171) ->
	#base_demons_shop{id = 171,min_times = 10,max_times = 999,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(172) ->
	#base_demons_shop{id = 172,min_times = 10,max_times = 999,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(173) ->
	#base_demons_shop{id = 173,min_times = 10,max_times = 999,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 90,weight = 3500};

get_shop_item(175) ->
	#base_demons_shop{id = 175,min_times = 10,max_times = 999,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 80,weight = 25800};

get_shop_item(176) ->
	#base_demons_shop{id = 176,min_times = 10,max_times = 999,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 80,weight = 25800};

get_shop_item(177) ->
	#base_demons_shop{id = 177,min_times = 10,max_times = 999,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 80,weight = 25800};

get_shop_item(178) ->
	#base_demons_shop{id = 178,min_times = 10,max_times = 999,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 80,weight = 25800};

get_shop_item(179) ->
	#base_demons_shop{id = 179,min_times = 10,max_times = 999,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 80,weight = 25800};

get_shop_item(180) ->
	#base_demons_shop{id = 180,min_times = 10,max_times = 999,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 80,weight = 25800};

get_shop_item(181) ->
	#base_demons_shop{id = 181,min_times = 10,max_times = 999,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 80,weight = 25800};

get_shop_item(182) ->
	#base_demons_shop{id = 182,min_times = 10,max_times = 999,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 80,weight = 25800};

get_shop_item(183) ->
	#base_demons_shop{id = 183,min_times = 10,max_times = 999,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 80,weight = 17200};

get_shop_item(184) ->
	#base_demons_shop{id = 184,min_times = 10,max_times = 999,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 80,weight = 17200};

get_shop_item(185) ->
	#base_demons_shop{id = 185,min_times = 10,max_times = 999,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 80,weight = 17200};

get_shop_item(186) ->
	#base_demons_shop{id = 186,min_times = 10,max_times = 999,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 80,weight = 17200};

get_shop_item(187) ->
	#base_demons_shop{id = 187,min_times = 10,max_times = 999,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 80,weight = 8600};

get_shop_item(188) ->
	#base_demons_shop{id = 188,min_times = 10,max_times = 999,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 80,weight = 8600};

get_shop_item(189) ->
	#base_demons_shop{id = 189,min_times = 10,max_times = 999,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 80,weight = 8600};

get_shop_item(190) ->
	#base_demons_shop{id = 190,min_times = 10,max_times = 999,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 80,weight = 8600};

get_shop_item(191) ->
	#base_demons_shop{id = 191,min_times = 10,max_times = 999,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 80,weight = 8600};

get_shop_item(192) ->
	#base_demons_shop{id = 192,min_times = 10,max_times = 999,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 80,weight = 9000};

get_shop_item(193) ->
	#base_demons_shop{id = 193,min_times = 10,max_times = 999,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(194) ->
	#base_demons_shop{id = 194,min_times = 10,max_times = 999,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(195) ->
	#base_demons_shop{id = 195,min_times = 10,max_times = 999,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 80,weight = 5400};

get_shop_item(196) ->
	#base_demons_shop{id = 196,min_times = 10,max_times = 999,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(197) ->
	#base_demons_shop{id = 197,min_times = 10,max_times = 999,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(198) ->
	#base_demons_shop{id = 198,min_times = 10,max_times = 999,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(199) ->
	#base_demons_shop{id = 199,min_times = 10,max_times = 999,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 80,weight = 9000};

get_shop_item(200) ->
	#base_demons_shop{id = 200,min_times = 10,max_times = 999,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 80,weight = 13950};

get_shop_item(201) ->
	#base_demons_shop{id = 201,min_times = 10,max_times = 999,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 80,weight = 13950};

get_shop_item(202) ->
	#base_demons_shop{id = 202,min_times = 10,max_times = 999,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(203) ->
	#base_demons_shop{id = 203,min_times = 10,max_times = 999,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(204) ->
	#base_demons_shop{id = 204,min_times = 10,max_times = 999,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 80,weight = 900};

get_shop_item(205) ->
	#base_demons_shop{id = 205,min_times = 10,max_times = 999,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(206) ->
	#base_demons_shop{id = 206,min_times = 10,max_times = 999,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(207) ->
	#base_demons_shop{id = 207,min_times = 10,max_times = 999,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(208) ->
	#base_demons_shop{id = 208,min_times = 10,max_times = 999,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 80,weight = 3150};

get_shop_item(210) ->
	#base_demons_shop{id = 210,min_times = 10,max_times = 999,goods_id = 7301001,num = 5,price = 1,cost_num = 50,discount = 60,weight = 3000};

get_shop_item(211) ->
	#base_demons_shop{id = 211,min_times = 10,max_times = 999,goods_id = 7301001,num = 8,price = 1,cost_num = 80,discount = 60,weight = 3000};

get_shop_item(212) ->
	#base_demons_shop{id = 212,min_times = 10,max_times = 999,goods_id = 7301003,num = 5,price = 1,cost_num = 50,discount = 60,weight = 3000};

get_shop_item(213) ->
	#base_demons_shop{id = 213,min_times = 10,max_times = 999,goods_id = 7301005,num = 5,price = 1,cost_num = 50,discount = 60,weight = 3000};

get_shop_item(214) ->
	#base_demons_shop{id = 214,min_times = 10,max_times = 999,goods_id = 7304101,num = 1,price = 1,cost_num = 150,discount = 60,weight = 3000};

get_shop_item(215) ->
	#base_demons_shop{id = 215,min_times = 10,max_times = 999,goods_id = 7304102,num = 1,price = 1,cost_num = 150,discount = 60,weight = 3000};

get_shop_item(216) ->
	#base_demons_shop{id = 216,min_times = 10,max_times = 999,goods_id = 7304103,num = 1,price = 1,cost_num = 150,discount = 60,weight = 3000};

get_shop_item(217) ->
	#base_demons_shop{id = 217,min_times = 10,max_times = 999,goods_id = 7304104,num = 1,price = 1,cost_num = 150,discount = 60,weight = 3000};

get_shop_item(218) ->
	#base_demons_shop{id = 218,min_times = 10,max_times = 999,goods_id = 7304201,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2000};

get_shop_item(219) ->
	#base_demons_shop{id = 219,min_times = 10,max_times = 999,goods_id = 7304202,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2000};

get_shop_item(220) ->
	#base_demons_shop{id = 220,min_times = 10,max_times = 999,goods_id = 7304203,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2000};

get_shop_item(221) ->
	#base_demons_shop{id = 221,min_times = 10,max_times = 999,goods_id = 7304204,num = 1,price = 1,cost_num = 300,discount = 60,weight = 2000};

get_shop_item(222) ->
	#base_demons_shop{id = 222,min_times = 10,max_times = 999,goods_id = 7304301,num = 1,price = 1,cost_num = 600,discount = 60,weight = 1000};

get_shop_item(223) ->
	#base_demons_shop{id = 223,min_times = 10,max_times = 999,goods_id = 7304302,num = 1,price = 1,cost_num = 600,discount = 60,weight = 1000};

get_shop_item(224) ->
	#base_demons_shop{id = 224,min_times = 10,max_times = 999,goods_id = 7304303,num = 1,price = 1,cost_num = 600,discount = 60,weight = 1000};

get_shop_item(225) ->
	#base_demons_shop{id = 225,min_times = 10,max_times = 999,goods_id = 7304304,num = 1,price = 1,cost_num = 600,discount = 60,weight = 1000};

get_shop_item(226) ->
	#base_demons_shop{id = 226,min_times = 10,max_times = 999,goods_id = 7302001,num = 3,price = 1,cost_num = 450,discount = 60,weight = 1000};

get_shop_item(227) ->
	#base_demons_shop{id = 227,min_times = 10,max_times = 999,goods_id = 7302002,num = 3,price = 1,cost_num = 450,discount = 60,weight = 1000};

get_shop_item(228) ->
	#base_demons_shop{id = 228,min_times = 10,max_times = 999,goods_id = 7304305,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(229) ->
	#base_demons_shop{id = 229,min_times = 10,max_times = 999,goods_id = 7304306,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(230) ->
	#base_demons_shop{id = 230,min_times = 10,max_times = 999,goods_id = 7304307,num = 1,price = 1,cost_num = 1200,discount = 60,weight = 600};

get_shop_item(231) ->
	#base_demons_shop{id = 231,min_times = 10,max_times = 999,goods_id = 7304308,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(232) ->
	#base_demons_shop{id = 232,min_times = 10,max_times = 999,goods_id = 7304309,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(233) ->
	#base_demons_shop{id = 233,min_times = 10,max_times = 999,goods_id = 7304310,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(234) ->
	#base_demons_shop{id = 234,min_times = 10,max_times = 999,goods_id = 7304311,num = 1,price = 1,cost_num = 850,discount = 60,weight = 1000};

get_shop_item(235) ->
	#base_demons_shop{id = 235,min_times = 10,max_times = 999,goods_id = 7302003,num = 3,price = 1,cost_num = 900,discount = 60,weight = 1550};

get_shop_item(236) ->
	#base_demons_shop{id = 236,min_times = 10,max_times = 999,goods_id = 7302004,num = 3,price = 1,cost_num = 900,discount = 60,weight = 1550};

get_shop_item(237) ->
	#base_demons_shop{id = 237,min_times = 10,max_times = 999,goods_id = 7304401,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(238) ->
	#base_demons_shop{id = 238,min_times = 10,max_times = 999,goods_id = 7304402,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(239) ->
	#base_demons_shop{id = 239,min_times = 10,max_times = 999,goods_id = 7304403,num = 1,price = 1,cost_num = 2500,discount = 60,weight = 100};

get_shop_item(240) ->
	#base_demons_shop{id = 240,min_times = 10,max_times = 999,goods_id = 7304404,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(241) ->
	#base_demons_shop{id = 241,min_times = 10,max_times = 999,goods_id = 7304405,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(242) ->
	#base_demons_shop{id = 242,min_times = 10,max_times = 999,goods_id = 7304406,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(243) ->
	#base_demons_shop{id = 243,min_times = 10,max_times = 999,goods_id = 7304407,num = 1,price = 1,cost_num = 1800,discount = 60,weight = 350};

get_shop_item(245) ->
	#base_demons_shop{id = 245,min_times = 10,max_times = 999,goods_id = 7301001,num = 5,price = 2,cost_num = 50,discount = 90,weight = 1200};

get_shop_item(246) ->
	#base_demons_shop{id = 246,min_times = 10,max_times = 999,goods_id = 7301001,num = 8,price = 2,cost_num = 80,discount = 90,weight = 1200};

get_shop_item(247) ->
	#base_demons_shop{id = 247,min_times = 10,max_times = 999,goods_id = 7301003,num = 5,price = 2,cost_num = 50,discount = 90,weight = 1200};

get_shop_item(248) ->
	#base_demons_shop{id = 248,min_times = 10,max_times = 999,goods_id = 7301005,num = 5,price = 2,cost_num = 50,discount = 90,weight = 1200};

get_shop_item(249) ->
	#base_demons_shop{id = 249,min_times = 10,max_times = 999,goods_id = 7304101,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1200};

get_shop_item(250) ->
	#base_demons_shop{id = 250,min_times = 10,max_times = 999,goods_id = 7304102,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1200};

get_shop_item(251) ->
	#base_demons_shop{id = 251,min_times = 10,max_times = 999,goods_id = 7304103,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1200};

get_shop_item(252) ->
	#base_demons_shop{id = 252,min_times = 10,max_times = 999,goods_id = 7304104,num = 1,price = 2,cost_num = 150,discount = 90,weight = 1200};

get_shop_item(253) ->
	#base_demons_shop{id = 253,min_times = 10,max_times = 999,goods_id = 7304201,num = 1,price = 2,cost_num = 300,discount = 90,weight = 800};

get_shop_item(254) ->
	#base_demons_shop{id = 254,min_times = 10,max_times = 999,goods_id = 7304202,num = 1,price = 2,cost_num = 300,discount = 90,weight = 800};

get_shop_item(255) ->
	#base_demons_shop{id = 255,min_times = 10,max_times = 999,goods_id = 7304203,num = 1,price = 2,cost_num = 300,discount = 90,weight = 800};

get_shop_item(256) ->
	#base_demons_shop{id = 256,min_times = 10,max_times = 999,goods_id = 7304204,num = 1,price = 2,cost_num = 300,discount = 90,weight = 800};

get_shop_item(257) ->
	#base_demons_shop{id = 257,min_times = 10,max_times = 999,goods_id = 7304301,num = 1,price = 2,cost_num = 600,discount = 90,weight = 400};

get_shop_item(258) ->
	#base_demons_shop{id = 258,min_times = 10,max_times = 999,goods_id = 7304302,num = 1,price = 2,cost_num = 600,discount = 90,weight = 400};

get_shop_item(259) ->
	#base_demons_shop{id = 259,min_times = 10,max_times = 999,goods_id = 7304303,num = 1,price = 2,cost_num = 600,discount = 90,weight = 400};

get_shop_item(260) ->
	#base_demons_shop{id = 260,min_times = 10,max_times = 999,goods_id = 7304304,num = 1,price = 2,cost_num = 600,discount = 90,weight = 400};

get_shop_item(261) ->
	#base_demons_shop{id = 261,min_times = 10,max_times = 999,goods_id = 7302001,num = 3,price = 2,cost_num = 450,discount = 90,weight = 400};

get_shop_item(262) ->
	#base_demons_shop{id = 262,min_times = 10,max_times = 999,goods_id = 7301001,num = 5,price = 2,cost_num = 50,discount = 80,weight = 1200};

get_shop_item(263) ->
	#base_demons_shop{id = 263,min_times = 10,max_times = 999,goods_id = 7301001,num = 8,price = 2,cost_num = 80,discount = 80,weight = 1200};

get_shop_item(264) ->
	#base_demons_shop{id = 264,min_times = 10,max_times = 999,goods_id = 7301003,num = 5,price = 2,cost_num = 50,discount = 80,weight = 1200};

get_shop_item(265) ->
	#base_demons_shop{id = 265,min_times = 10,max_times = 999,goods_id = 7301005,num = 5,price = 2,cost_num = 50,discount = 80,weight = 1200};

get_shop_item(266) ->
	#base_demons_shop{id = 266,min_times = 10,max_times = 999,goods_id = 7304101,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1200};

get_shop_item(267) ->
	#base_demons_shop{id = 267,min_times = 10,max_times = 999,goods_id = 7304102,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1200};

get_shop_item(268) ->
	#base_demons_shop{id = 268,min_times = 10,max_times = 999,goods_id = 7304103,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1200};

get_shop_item(269) ->
	#base_demons_shop{id = 269,min_times = 10,max_times = 999,goods_id = 7304104,num = 1,price = 2,cost_num = 150,discount = 80,weight = 1200};

get_shop_item(270) ->
	#base_demons_shop{id = 270,min_times = 10,max_times = 999,goods_id = 7304201,num = 1,price = 2,cost_num = 300,discount = 80,weight = 800};

get_shop_item(271) ->
	#base_demons_shop{id = 271,min_times = 10,max_times = 999,goods_id = 7304202,num = 1,price = 2,cost_num = 300,discount = 80,weight = 800};

get_shop_item(272) ->
	#base_demons_shop{id = 272,min_times = 10,max_times = 999,goods_id = 7304203,num = 1,price = 2,cost_num = 300,discount = 80,weight = 800};

get_shop_item(273) ->
	#base_demons_shop{id = 273,min_times = 10,max_times = 999,goods_id = 7304204,num = 1,price = 2,cost_num = 300,discount = 80,weight = 800};

get_shop_item(274) ->
	#base_demons_shop{id = 274,min_times = 10,max_times = 999,goods_id = 7304301,num = 1,price = 2,cost_num = 600,discount = 80,weight = 400};

get_shop_item(275) ->
	#base_demons_shop{id = 275,min_times = 10,max_times = 999,goods_id = 7304302,num = 1,price = 2,cost_num = 600,discount = 80,weight = 400};

get_shop_item(276) ->
	#base_demons_shop{id = 276,min_times = 10,max_times = 999,goods_id = 7304303,num = 1,price = 2,cost_num = 600,discount = 80,weight = 400};

get_shop_item(277) ->
	#base_demons_shop{id = 277,min_times = 10,max_times = 999,goods_id = 7304304,num = 1,price = 2,cost_num = 600,discount = 80,weight = 400};

get_shop_item(278) ->
	#base_demons_shop{id = 278,min_times = 10,max_times = 999,goods_id = 7302001,num = 3,price = 2,cost_num = 450,discount = 80,weight = 400};

get_shop_item(_Id) ->
	[].

get_refresh_range() ->
[{0,9},{10,999}].

get_all_shop_id(0,9) ->
[{48000,1},{48000,2},{48000,3},{48000,4},{24912,5},{24960,6},{24480,7},{24480,8},{24000,9},{24000,10},{24000,11},{24000,12},{6960,13},{6960,14},{6960,15},{6960,16},{6960,17},{7250,18},{7250,19},{7250,20},{2250,21},{7250,22},{7250,23},{7250,24},{7250,25},{2250,26},{2250,27},{500,28},{500,29},{250,30},{500,31},{500,32},{500,33},{500,34},{43000,36},{43000,37},{43000,38},{43000,39},{22317,40},{22360,41},{21930,42},{21930,43},{21500,44},{21500,45},{21500,46},{21500,47},{6235,48},{6235,49},{6235,50},{6235,51},{6235,52},{6525,53},{6525,54},{6525,55},{2025,56},{6525,57},{6525,58},{6525,59},{6525,60},{2025,61},{2025,62},{450,63},{450,64},{225,65},{450,66},{450,67},{450,68},{450,69},{5000,71},{5000,72},{5000,73},{5000,74},{2595,75},{2600,76},{2550,77},{2550,78},{2500,79},{2500,80},{2500,81},{2500,82},{725,83},{725,84},{725,85},{725,86},{725,87},{725,88},{725,89},{725,90},{225,91},{725,92},{725,93},{725,94},{725,95},{225,96},{225,97},{50,98},{50,99},{25,100},{50,101},{50,102},{50,103},{50,104},{2000,106},{2000,107},{2000,108},{2000,109},{1038,110},{1040,111},{1020,112},{1020,113},{1000,114},{1000,115},{1000,116},{1000,117},{290,118},{290,119},{290,120},{290,121},{290,122},{2000,123},{2000,124},{2000,125},{2000,126},{1038,127},{1040,128},{1020,129},{1020,130},{1000,131},{1000,132},{1000,133},{1000,134},{290,135},{290,136},{290,137},{290,138},{290,139}];

get_all_shop_id(10,999) ->
[{28800,140},{28800,141},{28800,142},{28800,143},{28800,144},{28800,145},{28800,146},{28800,147},{19200,148},{19200,149},{19200,150},{19200,151},{9600,152},{9600,153},{9600,154},{9600,155},{9600,156},{10000,157},{10000,158},{10000,159},{6000,160},{10000,161},{10000,162},{10000,163},{10000,164},{15500,165},{15500,166},{3500,167},{3500,168},{1000,169},{3500,170},{3500,171},{3500,172},{3500,173},{25800,175},{25800,176},{25800,177},{25800,178},{25800,179},{25800,180},{25800,181},{25800,182},{17200,183},{17200,184},{17200,185},{17200,186},{8600,187},{8600,188},{8600,189},{8600,190},{8600,191},{9000,192},{9000,193},{9000,194},{5400,195},{9000,196},{9000,197},{9000,198},{9000,199},{13950,200},{13950,201},{3150,202},{3150,203},{900,204},{3150,205},{3150,206},{3150,207},{3150,208},{3000,210},{3000,211},{3000,212},{3000,213},{3000,214},{3000,215},{3000,216},{3000,217},{2000,218},{2000,219},{2000,220},{2000,221},{1000,222},{1000,223},{1000,224},{1000,225},{1000,226},{1000,227},{1000,228},{1000,229},{600,230},{1000,231},{1000,232},{1000,233},{1000,234},{1550,235},{1550,236},{350,237},{350,238},{100,239},{350,240},{350,241},{350,242},{350,243},{1200,245},{1200,246},{1200,247},{1200,248},{1200,249},{1200,250},{1200,251},{1200,252},{800,253},{800,254},{800,255},{800,256},{400,257},{400,258},{400,259},{400,260},{400,261},{1200,262},{1200,263},{1200,264},{1200,265},{1200,266},{1200,267},{1200,268},{1200,269},{800,270},{800,271},{800,272},{800,273},{400,274},{400,275},{400,276},{400,277},{400,278}];

get_all_shop_id(_Mintimes,_Maxtimes) ->
	[].

