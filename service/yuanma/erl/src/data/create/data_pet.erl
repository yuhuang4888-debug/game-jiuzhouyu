%%%---------------------------------------
%%% module      : data_pet
%%% description : 宠物配置
%%%
%%%---------------------------------------
-module(data_pet).
-compile(export_all).
-include("pet.hrl").



get_stage_cfg(_) ->
	[].

get_all_stages() ->
[].

get_star_cfg(1,2) ->
	#pet_star_cfg{stage = 1,star = 2,max_blessing = 12,attr = [{1,37},{2,840},{3,21},{4,21}],combat = 1210};

get_star_cfg(1,3) ->
	#pet_star_cfg{stage = 1,star = 3,max_blessing = 14,attr = [{1,65},{2,1520},{3,38},{4,38}],combat = 2170};

get_star_cfg(1,4) ->
	#pet_star_cfg{stage = 1,star = 4,max_blessing = 17,attr = [{1,95},{2,2240},{3,56},{4,56}],combat = 3190};

get_star_cfg(1,5) ->
	#pet_star_cfg{stage = 1,star = 5,max_blessing = 20,attr = [{1,127},{2,3000},{3,75},{4,75}],combat = 4270};

get_star_cfg(1,6) ->
	#pet_star_cfg{stage = 1,star = 6,max_blessing = 24,attr = [{1,160},{2,3800},{3,95},{4,95}],combat = 5400};

get_star_cfg(1,7) ->
	#pet_star_cfg{stage = 1,star = 7,max_blessing = 29,attr = [{1,195},{2,4640},{3,116},{4,116}],combat = 6590};

get_star_cfg(1,8) ->
	#pet_star_cfg{stage = 1,star = 8,max_blessing = 34,attr = [{1,232},{2,5520},{3,138},{4,138}],combat = 7840};

get_star_cfg(1,9) ->
	#pet_star_cfg{stage = 1,star = 9,max_blessing = 40,attr = [{1,270},{2,6440},{3,161},{4,161}],combat = 9140};

get_star_cfg(1,10) ->
	#pet_star_cfg{stage = 1,star = 10,max_blessing = 46,attr = [{1,310},{2,7400},{3,185},{4,185}],combat = 10500};

get_star_cfg(2,1) ->
	#pet_star_cfg{stage = 2,star = 1,max_blessing = 53,attr = [{1,382},{2,9120},{3,228},{4,228}],combat = 12940};

get_star_cfg(2,2) ->
	#pet_star_cfg{stage = 2,star = 2,max_blessing = 61,attr = [{1,409},{2,9760},{3,244},{4,244}],combat = 13850};

get_star_cfg(2,3) ->
	#pet_star_cfg{stage = 2,star = 3,max_blessing = 69,attr = [{1,437},{2,10440},{3,261},{4,261}],combat = 14810};

get_star_cfg(2,4) ->
	#pet_star_cfg{stage = 2,star = 4,max_blessing = 78,attr = [{1,467},{2,11160},{3,279},{4,279}],combat = 15830};

get_star_cfg(2,5) ->
	#pet_star_cfg{stage = 2,star = 5,max_blessing = 87,attr = [{1,499},{2,11920},{3,298},{4,298}],combat = 16910};

get_star_cfg(2,6) ->
	#pet_star_cfg{stage = 2,star = 6,max_blessing = 97,attr = [{1,532},{2,12720},{3,318},{4,318}],combat = 18040};

get_star_cfg(2,7) ->
	#pet_star_cfg{stage = 2,star = 7,max_blessing = 108,attr = [{1,567},{2,13560},{3,339},{4,339}],combat = 19230};

get_star_cfg(2,8) ->
	#pet_star_cfg{stage = 2,star = 8,max_blessing = 119,attr = [{1,604},{2,14440},{3,361},{4,361}],combat = 20480};

get_star_cfg(2,9) ->
	#pet_star_cfg{stage = 2,star = 9,max_blessing = 131,attr = [{1,642},{2,15360},{3,384},{4,384}],combat = 21780};

get_star_cfg(2,10) ->
	#pet_star_cfg{stage = 2,star = 10,max_blessing = 143,attr = [{1,682},{2,16320},{3,408},{4,408}],combat = 23140};

get_star_cfg(3,1) ->
	#pet_star_cfg{stage = 3,star = 1,max_blessing = 156,attr = [{1,754},{2,18040},{3,451},{4,451}],combat = 25580};

get_star_cfg(3,2) ->
	#pet_star_cfg{stage = 3,star = 2,max_blessing = 170,attr = [{1,781},{2,18680},{3,467},{4,467}],combat = 26490};

get_star_cfg(3,3) ->
	#pet_star_cfg{stage = 3,star = 3,max_blessing = 184,attr = [{1,809},{2,19360},{3,484},{4,484}],combat = 27450};

get_star_cfg(3,4) ->
	#pet_star_cfg{stage = 3,star = 4,max_blessing = 199,attr = [{1,839},{2,20080},{3,502},{4,502}],combat = 28470};

get_star_cfg(3,5) ->
	#pet_star_cfg{stage = 3,star = 5,max_blessing = 214,attr = [{1,871},{2,20840},{3,521},{4,521}],combat = 29550};

get_star_cfg(3,6) ->
	#pet_star_cfg{stage = 3,star = 6,max_blessing = 230,attr = [{1,904},{2,21640},{3,541},{4,541}],combat = 30680};

get_star_cfg(3,7) ->
	#pet_star_cfg{stage = 3,star = 7,max_blessing = 247,attr = [{1,939},{2,22480},{3,562},{4,562}],combat = 31870};

get_star_cfg(3,8) ->
	#pet_star_cfg{stage = 3,star = 8,max_blessing = 264,attr = [{1,976},{2,23360},{3,584},{4,584}],combat = 33120};

get_star_cfg(3,9) ->
	#pet_star_cfg{stage = 3,star = 9,max_blessing = 282,attr = [{1,1014},{2,24280},{3,607},{4,607}],combat = 34420};

get_star_cfg(3,10) ->
	#pet_star_cfg{stage = 3,star = 10,max_blessing = 300,attr = [{1,1054},{2,25240},{3,631},{4,631}],combat = 35780};

get_star_cfg(4,1) ->
	#pet_star_cfg{stage = 4,star = 1,max_blessing = 319,attr = [{1,1126},{2,26960},{3,674},{4,674}],combat = 38220};

get_star_cfg(4,2) ->
	#pet_star_cfg{stage = 4,star = 2,max_blessing = 339,attr = [{1,1153},{2,27600},{3,690},{4,690}],combat = 39130};

get_star_cfg(4,3) ->
	#pet_star_cfg{stage = 4,star = 3,max_blessing = 359,attr = [{1,1181},{2,28280},{3,707},{4,707}],combat = 40090};

get_star_cfg(4,4) ->
	#pet_star_cfg{stage = 4,star = 4,max_blessing = 380,attr = [{1,1211},{2,29000},{3,725},{4,725}],combat = 41110};

get_star_cfg(4,5) ->
	#pet_star_cfg{stage = 4,star = 5,max_blessing = 401,attr = [{1,1243},{2,29760},{3,744},{4,744}],combat = 42190};

get_star_cfg(4,6) ->
	#pet_star_cfg{stage = 4,star = 6,max_blessing = 423,attr = [{1,1276},{2,30560},{3,764},{4,764}],combat = 43320};

get_star_cfg(4,7) ->
	#pet_star_cfg{stage = 4,star = 7,max_blessing = 446,attr = [{1,1311},{2,31400},{3,785},{4,785}],combat = 44510};

get_star_cfg(4,8) ->
	#pet_star_cfg{stage = 4,star = 8,max_blessing = 469,attr = [{1,1348},{2,32280},{3,807},{4,807}],combat = 45760};

get_star_cfg(4,9) ->
	#pet_star_cfg{stage = 4,star = 9,max_blessing = 493,attr = [{1,1386},{2,33200},{3,830},{4,830}],combat = 47060};

get_star_cfg(4,10) ->
	#pet_star_cfg{stage = 4,star = 10,max_blessing = 517,attr = [{1,1426},{2,34160},{3,854},{4,854}],combat = 48420};

get_star_cfg(5,1) ->
	#pet_star_cfg{stage = 5,star = 1,max_blessing = 542,attr = [{1,1498},{2,35880},{3,897},{4,897}],combat = 50860};

get_star_cfg(5,2) ->
	#pet_star_cfg{stage = 5,star = 2,max_blessing = 568,attr = [{1,1525},{2,36520},{3,913},{4,913}],combat = 51770};

get_star_cfg(5,3) ->
	#pet_star_cfg{stage = 5,star = 3,max_blessing = 594,attr = [{1,1553},{2,37200},{3,930},{4,930}],combat = 52730};

get_star_cfg(5,4) ->
	#pet_star_cfg{stage = 5,star = 4,max_blessing = 621,attr = [{1,1583},{2,37920},{3,948},{4,948}],combat = 53750};

get_star_cfg(5,5) ->
	#pet_star_cfg{stage = 5,star = 5,max_blessing = 648,attr = [{1,1615},{2,38680},{3,967},{4,967}],combat = 54830};

get_star_cfg(5,6) ->
	#pet_star_cfg{stage = 5,star = 6,max_blessing = 676,attr = [{1,1648},{2,39480},{3,987},{4,987}],combat = 55960};

get_star_cfg(5,7) ->
	#pet_star_cfg{stage = 5,star = 7,max_blessing = 705,attr = [{1,1683},{2,40320},{3,1008},{4,1008}],combat = 57150};

get_star_cfg(5,8) ->
	#pet_star_cfg{stage = 5,star = 8,max_blessing = 734,attr = [{1,1720},{2,41200},{3,1030},{4,1030}],combat = 58400};

get_star_cfg(5,9) ->
	#pet_star_cfg{stage = 5,star = 9,max_blessing = 764,attr = [{1,1758},{2,42120},{3,1053},{4,1053}],combat = 59700};

get_star_cfg(5,10) ->
	#pet_star_cfg{stage = 5,star = 10,max_blessing = 794,attr = [{1,1798},{2,43080},{3,1077},{4,1077}],combat = 61060};

get_star_cfg(6,1) ->
	#pet_star_cfg{stage = 6,star = 1,max_blessing = 825,attr = [{1,1870},{2,44800},{3,1120},{4,1120}],combat = 63500};

get_star_cfg(6,2) ->
	#pet_star_cfg{stage = 6,star = 2,max_blessing = 857,attr = [{1,1897},{2,45440},{3,1136},{4,1136}],combat = 64410};

get_star_cfg(6,3) ->
	#pet_star_cfg{stage = 6,star = 3,max_blessing = 889,attr = [{1,1925},{2,46120},{3,1153},{4,1153}],combat = 65370};

get_star_cfg(6,4) ->
	#pet_star_cfg{stage = 6,star = 4,max_blessing = 922,attr = [{1,1955},{2,46840},{3,1171},{4,1171}],combat = 66390};

get_star_cfg(6,5) ->
	#pet_star_cfg{stage = 6,star = 5,max_blessing = 955,attr = [{1,1987},{2,47600},{3,1190},{4,1190}],combat = 67470};

get_star_cfg(6,6) ->
	#pet_star_cfg{stage = 6,star = 6,max_blessing = 989,attr = [{1,2020},{2,48400},{3,1210},{4,1210}],combat = 68600};

get_star_cfg(6,7) ->
	#pet_star_cfg{stage = 6,star = 7,max_blessing = 1024,attr = [{1,2055},{2,49240},{3,1231},{4,1231}],combat = 69790};

get_star_cfg(6,8) ->
	#pet_star_cfg{stage = 6,star = 8,max_blessing = 1059,attr = [{1,2092},{2,50120},{3,1253},{4,1253}],combat = 71040};

get_star_cfg(6,9) ->
	#pet_star_cfg{stage = 6,star = 9,max_blessing = 1095,attr = [{1,2130},{2,51040},{3,1276},{4,1276}],combat = 72340};

get_star_cfg(6,10) ->
	#pet_star_cfg{stage = 6,star = 10,max_blessing = 1131,attr = [{1,2170},{2,52000},{3,1300},{4,1300}],combat = 73700};

get_star_cfg(7,1) ->
	#pet_star_cfg{stage = 7,star = 1,max_blessing = 1168,attr = [{1,2242},{2,53720},{3,1343},{4,1343}],combat = 76140};

get_star_cfg(7,2) ->
	#pet_star_cfg{stage = 7,star = 2,max_blessing = 1206,attr = [{1,2269},{2,54360},{3,1359},{4,1359}],combat = 77050};

get_star_cfg(7,3) ->
	#pet_star_cfg{stage = 7,star = 3,max_blessing = 1244,attr = [{1,2297},{2,55040},{3,1376},{4,1376}],combat = 78010};

get_star_cfg(7,4) ->
	#pet_star_cfg{stage = 7,star = 4,max_blessing = 1283,attr = [{1,2327},{2,55760},{3,1394},{4,1394}],combat = 79030};

get_star_cfg(7,5) ->
	#pet_star_cfg{stage = 7,star = 5,max_blessing = 1322,attr = [{1,2359},{2,56520},{3,1413},{4,1413}],combat = 80110};

get_star_cfg(7,6) ->
	#pet_star_cfg{stage = 7,star = 6,max_blessing = 1362,attr = [{1,2392},{2,57320},{3,1433},{4,1433}],combat = 81240};

get_star_cfg(7,7) ->
	#pet_star_cfg{stage = 7,star = 7,max_blessing = 1403,attr = [{1,2427},{2,58160},{3,1454},{4,1454}],combat = 82430};

get_star_cfg(7,8) ->
	#pet_star_cfg{stage = 7,star = 8,max_blessing = 1444,attr = [{1,2464},{2,59040},{3,1476},{4,1476}],combat = 83680};

get_star_cfg(7,9) ->
	#pet_star_cfg{stage = 7,star = 9,max_blessing = 1486,attr = [{1,2502},{2,59960},{3,1499},{4,1499}],combat = 84980};

get_star_cfg(7,10) ->
	#pet_star_cfg{stage = 7,star = 10,max_blessing = 1528,attr = [{1,2542},{2,60920},{3,1523},{4,1523}],combat = 86340};

get_star_cfg(8,1) ->
	#pet_star_cfg{stage = 8,star = 1,max_blessing = 1571,attr = [{1,2614},{2,62640},{3,1566},{4,1566}],combat = 88780};

get_star_cfg(8,2) ->
	#pet_star_cfg{stage = 8,star = 2,max_blessing = 1615,attr = [{1,2641},{2,63280},{3,1582},{4,1582}],combat = 89690};

get_star_cfg(8,3) ->
	#pet_star_cfg{stage = 8,star = 3,max_blessing = 1659,attr = [{1,2669},{2,63960},{3,1599},{4,1599}],combat = 90650};

get_star_cfg(8,4) ->
	#pet_star_cfg{stage = 8,star = 4,max_blessing = 1704,attr = [{1,2699},{2,64680},{3,1617},{4,1617}],combat = 91670};

get_star_cfg(8,5) ->
	#pet_star_cfg{stage = 8,star = 5,max_blessing = 1749,attr = [{1,2731},{2,65440},{3,1636},{4,1636}],combat = 92750};

get_star_cfg(8,6) ->
	#pet_star_cfg{stage = 8,star = 6,max_blessing = 1795,attr = [{1,2764},{2,66240},{3,1656},{4,1656}],combat = 93880};

get_star_cfg(8,7) ->
	#pet_star_cfg{stage = 8,star = 7,max_blessing = 1842,attr = [{1,2799},{2,67080},{3,1677},{4,1677}],combat = 95070};

get_star_cfg(8,8) ->
	#pet_star_cfg{stage = 8,star = 8,max_blessing = 1889,attr = [{1,2836},{2,67960},{3,1699},{4,1699}],combat = 96320};

get_star_cfg(8,9) ->
	#pet_star_cfg{stage = 8,star = 9,max_blessing = 1937,attr = [{1,2874},{2,68880},{3,1722},{4,1722}],combat = 97620};

get_star_cfg(8,10) ->
	#pet_star_cfg{stage = 8,star = 10,max_blessing = 1985,attr = [{1,2914},{2,69840},{3,1746},{4,1746}],combat = 98980};

get_star_cfg(9,1) ->
	#pet_star_cfg{stage = 9,star = 1,max_blessing = 2034,attr = [{1,2986},{2,71560},{3,1789},{4,1789}],combat = 101420};

get_star_cfg(9,2) ->
	#pet_star_cfg{stage = 9,star = 2,max_blessing = 2084,attr = [{1,3013},{2,72200},{3,1805},{4,1805}],combat = 102330};

get_star_cfg(9,3) ->
	#pet_star_cfg{stage = 9,star = 3,max_blessing = 2134,attr = [{1,3041},{2,72880},{3,1822},{4,1822}],combat = 103290};

get_star_cfg(9,4) ->
	#pet_star_cfg{stage = 9,star = 4,max_blessing = 2185,attr = [{1,3071},{2,73600},{3,1840},{4,1840}],combat = 104310};

get_star_cfg(9,5) ->
	#pet_star_cfg{stage = 9,star = 5,max_blessing = 2236,attr = [{1,3103},{2,74360},{3,1859},{4,1859}],combat = 105390};

get_star_cfg(9,6) ->
	#pet_star_cfg{stage = 9,star = 6,max_blessing = 2288,attr = [{1,3136},{2,75160},{3,1879},{4,1879}],combat = 106520};

get_star_cfg(9,7) ->
	#pet_star_cfg{stage = 9,star = 7,max_blessing = 2341,attr = [{1,3171},{2,76000},{3,1900},{4,1900}],combat = 107710};

get_star_cfg(9,8) ->
	#pet_star_cfg{stage = 9,star = 8,max_blessing = 2394,attr = [{1,3208},{2,76880},{3,1922},{4,1922}],combat = 108960};

get_star_cfg(9,9) ->
	#pet_star_cfg{stage = 9,star = 9,max_blessing = 2448,attr = [{1,3246},{2,77800},{3,1945},{4,1945}],combat = 110260};

get_star_cfg(9,10) ->
	#pet_star_cfg{stage = 9,star = 10,max_blessing = 0,attr = [{1,3286},{2,78760},{3,1969},{4,1969}],combat = 111620};

get_star_cfg(10,1) ->
	#pet_star_cfg{stage = 10,star = 1,max_blessing = 2557,attr = [{1,3358},{2,80480},{3,2012},{4,2012}],combat = 114060};

get_star_cfg(10,2) ->
	#pet_star_cfg{stage = 10,star = 2,max_blessing = 2613,attr = [{1,3385},{2,81120},{3,2028},{4,2028}],combat = 114970};

get_star_cfg(10,3) ->
	#pet_star_cfg{stage = 10,star = 3,max_blessing = 2669,attr = [{1,3413},{2,81800},{3,2045},{4,2045}],combat = 115930};

get_star_cfg(10,4) ->
	#pet_star_cfg{stage = 10,star = 4,max_blessing = 2726,attr = [{1,3443},{2,82520},{3,2063},{4,2063}],combat = 116950};

get_star_cfg(10,5) ->
	#pet_star_cfg{stage = 10,star = 5,max_blessing = 2783,attr = [{1,3475},{2,83280},{3,2082},{4,2082}],combat = 118030};

get_star_cfg(10,6) ->
	#pet_star_cfg{stage = 10,star = 6,max_blessing = 2841,attr = [{1,3508},{2,84080},{3,2102},{4,2102}],combat = 119160};

get_star_cfg(10,7) ->
	#pet_star_cfg{stage = 10,star = 7,max_blessing = 2900,attr = [{1,3543},{2,84920},{3,2123},{4,2123}],combat = 120350};

get_star_cfg(10,8) ->
	#pet_star_cfg{stage = 10,star = 8,max_blessing = 2959,attr = [{1,3580},{2,85800},{3,2145},{4,2145}],combat = 121600};

get_star_cfg(10,9) ->
	#pet_star_cfg{stage = 10,star = 9,max_blessing = 3019,attr = [{1,3618},{2,86720},{3,2168},{4,2168}],combat = 122900};

get_star_cfg(10,10) ->
	#pet_star_cfg{stage = 10,star = 10,max_blessing = 0,attr = [{1,3658},{2,87680},{3,2192},{4,2192}],combat = 124260};

get_star_cfg(_Stage,_Star) ->
	[].

get_lv_cfg(1) ->
	#pet_lv_cfg{lv = 1,max_exp = 20000,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 120,is_tv = 0};

get_lv_cfg(2) ->
	#pet_lv_cfg{lv = 2,max_exp = 20162,attr = [{1,4},{2,80},{3,2},{4,2}],combat = 240,is_tv = 0};

get_lv_cfg(3) ->
	#pet_lv_cfg{lv = 3,max_exp = 20325,attr = [{1,8},{2,160},{3,4},{4,4}],combat = 360,is_tv = 0};

get_lv_cfg(4) ->
	#pet_lv_cfg{lv = 4,max_exp = 20489,attr = [{1,12},{2,240},{3,6},{4,6}],combat = 480,is_tv = 0};

get_lv_cfg(5) ->
	#pet_lv_cfg{lv = 5,max_exp = 20655,attr = [{1,16},{2,320},{3,8},{4,8}],combat = 600,is_tv = 0};

get_lv_cfg(6) ->
	#pet_lv_cfg{lv = 6,max_exp = 20822,attr = [{1,20},{2,400},{3,10},{4,10}],combat = 720,is_tv = 0};

get_lv_cfg(7) ->
	#pet_lv_cfg{lv = 7,max_exp = 20990,attr = [{1,24},{2,480},{3,12},{4,12}],combat = 840,is_tv = 0};

get_lv_cfg(8) ->
	#pet_lv_cfg{lv = 8,max_exp = 21160,attr = [{1,28},{2,560},{3,14},{4,14}],combat = 960,is_tv = 0};

get_lv_cfg(9) ->
	#pet_lv_cfg{lv = 9,max_exp = 21331,attr = [{1,32},{2,640},{3,16},{4,16}],combat = 1080,is_tv = 0};

get_lv_cfg(10) ->
	#pet_lv_cfg{lv = 10,max_exp = 21503,attr = [{1,36},{2,720},{3,18},{4,18}],combat = 1200,is_tv = 0};

get_lv_cfg(11) ->
	#pet_lv_cfg{lv = 11,max_exp = 21677,attr = [{1,40},{2,800},{3,20},{4,20}],combat = 1320,is_tv = 0};

get_lv_cfg(12) ->
	#pet_lv_cfg{lv = 12,max_exp = 21852,attr = [{1,44},{2,880},{3,22},{4,22}],combat = 1440,is_tv = 0};

get_lv_cfg(13) ->
	#pet_lv_cfg{lv = 13,max_exp = 22029,attr = [{1,48},{2,960},{3,24},{4,24}],combat = 1560,is_tv = 0};

get_lv_cfg(14) ->
	#pet_lv_cfg{lv = 14,max_exp = 22207,attr = [{1,52},{2,1040},{3,26},{4,26}],combat = 1680,is_tv = 0};

get_lv_cfg(15) ->
	#pet_lv_cfg{lv = 15,max_exp = 22387,attr = [{1,56},{2,1120},{3,28},{4,28}],combat = 1800,is_tv = 0};

get_lv_cfg(16) ->
	#pet_lv_cfg{lv = 16,max_exp = 22568,attr = [{1,60},{2,1200},{3,30},{4,30}],combat = 1920,is_tv = 0};

get_lv_cfg(17) ->
	#pet_lv_cfg{lv = 17,max_exp = 22750,attr = [{1,64},{2,1280},{3,32},{4,32}],combat = 2040,is_tv = 0};

get_lv_cfg(18) ->
	#pet_lv_cfg{lv = 18,max_exp = 22934,attr = [{1,68},{2,1360},{3,34},{4,34}],combat = 2160,is_tv = 0};

get_lv_cfg(19) ->
	#pet_lv_cfg{lv = 19,max_exp = 23119,attr = [{1,72},{2,1440},{3,36},{4,36}],combat = 2280,is_tv = 0};

get_lv_cfg(20) ->
	#pet_lv_cfg{lv = 20,max_exp = 23306,attr = [{1,76},{2,1520},{3,38},{4,38}],combat = 2400,is_tv = 0};

get_lv_cfg(21) ->
	#pet_lv_cfg{lv = 21,max_exp = 23494,attr = [{1,80},{2,1600},{3,40},{4,40}],combat = 2520,is_tv = 0};

get_lv_cfg(22) ->
	#pet_lv_cfg{lv = 22,max_exp = 23684,attr = [{1,84},{2,1680},{3,42},{4,42}],combat = 2640,is_tv = 0};

get_lv_cfg(23) ->
	#pet_lv_cfg{lv = 23,max_exp = 23875,attr = [{1,88},{2,1760},{3,44},{4,44}],combat = 2760,is_tv = 0};

get_lv_cfg(24) ->
	#pet_lv_cfg{lv = 24,max_exp = 24068,attr = [{1,92},{2,1840},{3,46},{4,46}],combat = 2880,is_tv = 0};

get_lv_cfg(25) ->
	#pet_lv_cfg{lv = 25,max_exp = 24263,attr = [{1,96},{2,1920},{3,48},{4,48}],combat = 3000,is_tv = 0};

get_lv_cfg(26) ->
	#pet_lv_cfg{lv = 26,max_exp = 24459,attr = [{1,100},{2,2000},{3,50},{4,50}],combat = 3120,is_tv = 0};

get_lv_cfg(27) ->
	#pet_lv_cfg{lv = 27,max_exp = 24657,attr = [{1,104},{2,2080},{3,52},{4,52}],combat = 3240,is_tv = 0};

get_lv_cfg(28) ->
	#pet_lv_cfg{lv = 28,max_exp = 24856,attr = [{1,108},{2,2160},{3,54},{4,54}],combat = 3360,is_tv = 0};

get_lv_cfg(29) ->
	#pet_lv_cfg{lv = 29,max_exp = 25057,attr = [{1,112},{2,2240},{3,56},{4,56}],combat = 3480,is_tv = 0};

get_lv_cfg(30) ->
	#pet_lv_cfg{lv = 30,max_exp = 25260,attr = [{1,116},{2,2320},{3,58},{4,58}],combat = 3600,is_tv = 0};

get_lv_cfg(31) ->
	#pet_lv_cfg{lv = 31,max_exp = 25464,attr = [{1,120},{2,2400},{3,60},{4,60}],combat = 3720,is_tv = 0};

get_lv_cfg(32) ->
	#pet_lv_cfg{lv = 32,max_exp = 25670,attr = [{1,124},{2,2480},{3,62},{4,62}],combat = 3840,is_tv = 0};

get_lv_cfg(33) ->
	#pet_lv_cfg{lv = 33,max_exp = 25878,attr = [{1,128},{2,2560},{3,64},{4,64}],combat = 3960,is_tv = 0};

get_lv_cfg(34) ->
	#pet_lv_cfg{lv = 34,max_exp = 26087,attr = [{1,132},{2,2640},{3,66},{4,66}],combat = 4080,is_tv = 0};

get_lv_cfg(35) ->
	#pet_lv_cfg{lv = 35,max_exp = 26298,attr = [{1,136},{2,2720},{3,68},{4,68}],combat = 4200,is_tv = 0};

get_lv_cfg(36) ->
	#pet_lv_cfg{lv = 36,max_exp = 26511,attr = [{1,140},{2,2800},{3,70},{4,70}],combat = 4320,is_tv = 0};

get_lv_cfg(37) ->
	#pet_lv_cfg{lv = 37,max_exp = 26725,attr = [{1,144},{2,2880},{3,72},{4,72}],combat = 4440,is_tv = 0};

get_lv_cfg(38) ->
	#pet_lv_cfg{lv = 38,max_exp = 26941,attr = [{1,148},{2,2960},{3,74},{4,74}],combat = 4560,is_tv = 0};

get_lv_cfg(39) ->
	#pet_lv_cfg{lv = 39,max_exp = 27159,attr = [{1,152},{2,3040},{3,76},{4,76}],combat = 4680,is_tv = 0};

get_lv_cfg(40) ->
	#pet_lv_cfg{lv = 40,max_exp = 27379,attr = [{1,156},{2,3120},{3,78},{4,78}],combat = 4800,is_tv = 0};

get_lv_cfg(41) ->
	#pet_lv_cfg{lv = 41,max_exp = 27600,attr = [{1,160},{2,3200},{3,80},{4,80}],combat = 4920,is_tv = 0};

get_lv_cfg(42) ->
	#pet_lv_cfg{lv = 42,max_exp = 27823,attr = [{1,164},{2,3280},{3,82},{4,82}],combat = 5040,is_tv = 0};

get_lv_cfg(43) ->
	#pet_lv_cfg{lv = 43,max_exp = 28048,attr = [{1,168},{2,3360},{3,84},{4,84}],combat = 5160,is_tv = 0};

get_lv_cfg(44) ->
	#pet_lv_cfg{lv = 44,max_exp = 28275,attr = [{1,172},{2,3440},{3,86},{4,86}],combat = 5280,is_tv = 0};

get_lv_cfg(45) ->
	#pet_lv_cfg{lv = 45,max_exp = 28504,attr = [{1,176},{2,3520},{3,88},{4,88}],combat = 5400,is_tv = 0};

get_lv_cfg(46) ->
	#pet_lv_cfg{lv = 46,max_exp = 28734,attr = [{1,180},{2,3600},{3,90},{4,90}],combat = 5520,is_tv = 0};

get_lv_cfg(47) ->
	#pet_lv_cfg{lv = 47,max_exp = 28966,attr = [{1,184},{2,3680},{3,92},{4,92}],combat = 5640,is_tv = 0};

get_lv_cfg(48) ->
	#pet_lv_cfg{lv = 48,max_exp = 29200,attr = [{1,188},{2,3760},{3,94},{4,94}],combat = 5760,is_tv = 0};

get_lv_cfg(49) ->
	#pet_lv_cfg{lv = 49,max_exp = 29436,attr = [{1,192},{2,3840},{3,96},{4,96}],combat = 5880,is_tv = 0};

get_lv_cfg(50) ->
	#pet_lv_cfg{lv = 50,max_exp = 29674,attr = [{1,196},{2,3920},{3,98},{4,98}],combat = 6000,is_tv = 0};

get_lv_cfg(51) ->
	#pet_lv_cfg{lv = 51,max_exp = 29914,attr = [{1,200},{2,4000},{3,100},{4,100}],combat = 6120,is_tv = 0};

get_lv_cfg(52) ->
	#pet_lv_cfg{lv = 52,max_exp = 30156,attr = [{1,204},{2,4080},{3,102},{4,102}],combat = 6240,is_tv = 0};

get_lv_cfg(53) ->
	#pet_lv_cfg{lv = 53,max_exp = 30400,attr = [{1,208},{2,4160},{3,104},{4,104}],combat = 6360,is_tv = 0};

get_lv_cfg(54) ->
	#pet_lv_cfg{lv = 54,max_exp = 30646,attr = [{1,212},{2,4240},{3,106},{4,106}],combat = 6480,is_tv = 0};

get_lv_cfg(55) ->
	#pet_lv_cfg{lv = 55,max_exp = 30894,attr = [{1,216},{2,4320},{3,108},{4,108}],combat = 6600,is_tv = 0};

get_lv_cfg(56) ->
	#pet_lv_cfg{lv = 56,max_exp = 31144,attr = [{1,220},{2,4400},{3,110},{4,110}],combat = 6720,is_tv = 0};

get_lv_cfg(57) ->
	#pet_lv_cfg{lv = 57,max_exp = 31396,attr = [{1,224},{2,4480},{3,112},{4,112}],combat = 6840,is_tv = 0};

get_lv_cfg(58) ->
	#pet_lv_cfg{lv = 58,max_exp = 31650,attr = [{1,228},{2,4560},{3,114},{4,114}],combat = 6960,is_tv = 0};

get_lv_cfg(59) ->
	#pet_lv_cfg{lv = 59,max_exp = 31906,attr = [{1,232},{2,4640},{3,116},{4,116}],combat = 7080,is_tv = 0};

get_lv_cfg(60) ->
	#pet_lv_cfg{lv = 60,max_exp = 32164,attr = [{1,236},{2,4720},{3,118},{4,118}],combat = 7200,is_tv = 0};

get_lv_cfg(61) ->
	#pet_lv_cfg{lv = 61,max_exp = 32424,attr = [{1,240},{2,4800},{3,120},{4,120}],combat = 7320,is_tv = 0};

get_lv_cfg(62) ->
	#pet_lv_cfg{lv = 62,max_exp = 32686,attr = [{1,244},{2,4880},{3,122},{4,122}],combat = 7440,is_tv = 0};

get_lv_cfg(63) ->
	#pet_lv_cfg{lv = 63,max_exp = 32950,attr = [{1,248},{2,4960},{3,124},{4,124}],combat = 7560,is_tv = 0};

get_lv_cfg(64) ->
	#pet_lv_cfg{lv = 64,max_exp = 33216,attr = [{1,252},{2,5040},{3,126},{4,126}],combat = 7680,is_tv = 0};

get_lv_cfg(65) ->
	#pet_lv_cfg{lv = 65,max_exp = 33485,attr = [{1,256},{2,5120},{3,128},{4,128}],combat = 7800,is_tv = 0};

get_lv_cfg(66) ->
	#pet_lv_cfg{lv = 66,max_exp = 33756,attr = [{1,260},{2,5200},{3,130},{4,130}],combat = 7920,is_tv = 0};

get_lv_cfg(67) ->
	#pet_lv_cfg{lv = 67,max_exp = 34029,attr = [{1,264},{2,5280},{3,132},{4,132}],combat = 8040,is_tv = 0};

get_lv_cfg(68) ->
	#pet_lv_cfg{lv = 68,max_exp = 34304,attr = [{1,268},{2,5360},{3,134},{4,134}],combat = 8160,is_tv = 0};

get_lv_cfg(69) ->
	#pet_lv_cfg{lv = 69,max_exp = 34581,attr = [{1,272},{2,5440},{3,136},{4,136}],combat = 8280,is_tv = 0};

get_lv_cfg(70) ->
	#pet_lv_cfg{lv = 70,max_exp = 34861,attr = [{1,276},{2,5520},{3,138},{4,138}],combat = 8400,is_tv = 0};

get_lv_cfg(71) ->
	#pet_lv_cfg{lv = 71,max_exp = 35143,attr = [{1,280},{2,5600},{3,140},{4,140}],combat = 8520,is_tv = 0};

get_lv_cfg(72) ->
	#pet_lv_cfg{lv = 72,max_exp = 35427,attr = [{1,284},{2,5680},{3,142},{4,142}],combat = 8640,is_tv = 0};

get_lv_cfg(73) ->
	#pet_lv_cfg{lv = 73,max_exp = 35713,attr = [{1,288},{2,5760},{3,144},{4,144}],combat = 8760,is_tv = 0};

get_lv_cfg(74) ->
	#pet_lv_cfg{lv = 74,max_exp = 36002,attr = [{1,292},{2,5840},{3,146},{4,146}],combat = 8880,is_tv = 0};

get_lv_cfg(75) ->
	#pet_lv_cfg{lv = 75,max_exp = 36293,attr = [{1,296},{2,5920},{3,148},{4,148}],combat = 9000,is_tv = 0};

get_lv_cfg(76) ->
	#pet_lv_cfg{lv = 76,max_exp = 36586,attr = [{1,300},{2,6000},{3,150},{4,150}],combat = 9120,is_tv = 0};

get_lv_cfg(77) ->
	#pet_lv_cfg{lv = 77,max_exp = 36882,attr = [{1,304},{2,6080},{3,152},{4,152}],combat = 9240,is_tv = 0};

get_lv_cfg(78) ->
	#pet_lv_cfg{lv = 78,max_exp = 37180,attr = [{1,308},{2,6160},{3,154},{4,154}],combat = 9360,is_tv = 0};

get_lv_cfg(79) ->
	#pet_lv_cfg{lv = 79,max_exp = 37481,attr = [{1,312},{2,6240},{3,156},{4,156}],combat = 9480,is_tv = 0};

get_lv_cfg(80) ->
	#pet_lv_cfg{lv = 80,max_exp = 37784,attr = [{1,316},{2,6320},{3,158},{4,158}],combat = 9600,is_tv = 0};

get_lv_cfg(81) ->
	#pet_lv_cfg{lv = 81,max_exp = 38089,attr = [{1,320},{2,6400},{3,160},{4,160}],combat = 9720,is_tv = 0};

get_lv_cfg(82) ->
	#pet_lv_cfg{lv = 82,max_exp = 38397,attr = [{1,324},{2,6480},{3,162},{4,162}],combat = 9840,is_tv = 0};

get_lv_cfg(83) ->
	#pet_lv_cfg{lv = 83,max_exp = 38707,attr = [{1,328},{2,6560},{3,164},{4,164}],combat = 9960,is_tv = 0};

get_lv_cfg(84) ->
	#pet_lv_cfg{lv = 84,max_exp = 39020,attr = [{1,332},{2,6640},{3,166},{4,166}],combat = 10080,is_tv = 0};

get_lv_cfg(85) ->
	#pet_lv_cfg{lv = 85,max_exp = 39335,attr = [{1,336},{2,6720},{3,168},{4,168}],combat = 10200,is_tv = 0};

get_lv_cfg(86) ->
	#pet_lv_cfg{lv = 86,max_exp = 39653,attr = [{1,340},{2,6800},{3,170},{4,170}],combat = 10320,is_tv = 0};

get_lv_cfg(87) ->
	#pet_lv_cfg{lv = 87,max_exp = 39974,attr = [{1,344},{2,6880},{3,172},{4,172}],combat = 10440,is_tv = 0};

get_lv_cfg(88) ->
	#pet_lv_cfg{lv = 88,max_exp = 40297,attr = [{1,348},{2,6960},{3,174},{4,174}],combat = 10560,is_tv = 0};

get_lv_cfg(89) ->
	#pet_lv_cfg{lv = 89,max_exp = 40623,attr = [{1,352},{2,7040},{3,176},{4,176}],combat = 10680,is_tv = 0};

get_lv_cfg(90) ->
	#pet_lv_cfg{lv = 90,max_exp = 40951,attr = [{1,356},{2,7120},{3,178},{4,178}],combat = 10800,is_tv = 0};

get_lv_cfg(91) ->
	#pet_lv_cfg{lv = 91,max_exp = 41282,attr = [{1,360},{2,7200},{3,180},{4,180}],combat = 10920,is_tv = 0};

get_lv_cfg(92) ->
	#pet_lv_cfg{lv = 92,max_exp = 41616,attr = [{1,364},{2,7280},{3,182},{4,182}],combat = 11040,is_tv = 0};

get_lv_cfg(93) ->
	#pet_lv_cfg{lv = 93,max_exp = 41952,attr = [{1,368},{2,7360},{3,184},{4,184}],combat = 11160,is_tv = 0};

get_lv_cfg(94) ->
	#pet_lv_cfg{lv = 94,max_exp = 42291,attr = [{1,372},{2,7440},{3,186},{4,186}],combat = 11280,is_tv = 0};

get_lv_cfg(95) ->
	#pet_lv_cfg{lv = 95,max_exp = 42633,attr = [{1,376},{2,7520},{3,188},{4,188}],combat = 11400,is_tv = 0};

get_lv_cfg(96) ->
	#pet_lv_cfg{lv = 96,max_exp = 42978,attr = [{1,380},{2,7600},{3,190},{4,190}],combat = 11520,is_tv = 0};

get_lv_cfg(97) ->
	#pet_lv_cfg{lv = 97,max_exp = 43325,attr = [{1,384},{2,7680},{3,192},{4,192}],combat = 11640,is_tv = 0};

get_lv_cfg(98) ->
	#pet_lv_cfg{lv = 98,max_exp = 43675,attr = [{1,388},{2,7760},{3,194},{4,194}],combat = 11760,is_tv = 0};

get_lv_cfg(99) ->
	#pet_lv_cfg{lv = 99,max_exp = 44028,attr = [{1,392},{2,7840},{3,196},{4,196}],combat = 11880,is_tv = 0};

get_lv_cfg(100) ->
	#pet_lv_cfg{lv = 100,max_exp = 44384,attr = [{1,396},{2,7920},{3,198},{4,198}],combat = 12000,is_tv = 1};

get_lv_cfg(101) ->
	#pet_lv_cfg{lv = 101,max_exp = 44743,attr = [{1,400},{2,8000},{3,200},{4,200}],combat = 12120,is_tv = 0};

get_lv_cfg(102) ->
	#pet_lv_cfg{lv = 102,max_exp = 45105,attr = [{1,404},{2,8080},{3,202},{4,202}],combat = 12240,is_tv = 0};

get_lv_cfg(103) ->
	#pet_lv_cfg{lv = 103,max_exp = 45470,attr = [{1,408},{2,8160},{3,204},{4,204}],combat = 12360,is_tv = 0};

get_lv_cfg(104) ->
	#pet_lv_cfg{lv = 104,max_exp = 45838,attr = [{1,412},{2,8240},{3,206},{4,206}],combat = 12480,is_tv = 0};

get_lv_cfg(105) ->
	#pet_lv_cfg{lv = 105,max_exp = 46209,attr = [{1,416},{2,8320},{3,208},{4,208}],combat = 12600,is_tv = 0};

get_lv_cfg(106) ->
	#pet_lv_cfg{lv = 106,max_exp = 46583,attr = [{1,420},{2,8400},{3,210},{4,210}],combat = 12720,is_tv = 0};

get_lv_cfg(107) ->
	#pet_lv_cfg{lv = 107,max_exp = 46960,attr = [{1,424},{2,8480},{3,212},{4,212}],combat = 12840,is_tv = 0};

get_lv_cfg(108) ->
	#pet_lv_cfg{lv = 108,max_exp = 47340,attr = [{1,428},{2,8560},{3,214},{4,214}],combat = 12960,is_tv = 0};

get_lv_cfg(109) ->
	#pet_lv_cfg{lv = 109,max_exp = 47723,attr = [{1,432},{2,8640},{3,216},{4,216}],combat = 13080,is_tv = 0};

get_lv_cfg(110) ->
	#pet_lv_cfg{lv = 110,max_exp = 48109,attr = [{1,436},{2,8720},{3,218},{4,218}],combat = 13200,is_tv = 0};

get_lv_cfg(111) ->
	#pet_lv_cfg{lv = 111,max_exp = 48498,attr = [{1,440},{2,8800},{3,220},{4,220}],combat = 13320,is_tv = 0};

get_lv_cfg(112) ->
	#pet_lv_cfg{lv = 112,max_exp = 48890,attr = [{1,444},{2,8880},{3,222},{4,222}],combat = 13440,is_tv = 0};

get_lv_cfg(113) ->
	#pet_lv_cfg{lv = 113,max_exp = 49285,attr = [{1,448},{2,8960},{3,224},{4,224}],combat = 13560,is_tv = 0};

get_lv_cfg(114) ->
	#pet_lv_cfg{lv = 114,max_exp = 49683,attr = [{1,452},{2,9040},{3,226},{4,226}],combat = 13680,is_tv = 0};

get_lv_cfg(115) ->
	#pet_lv_cfg{lv = 115,max_exp = 50085,attr = [{1,456},{2,9120},{3,228},{4,228}],combat = 13800,is_tv = 0};

get_lv_cfg(116) ->
	#pet_lv_cfg{lv = 116,max_exp = 50490,attr = [{1,460},{2,9200},{3,230},{4,230}],combat = 13920,is_tv = 0};

get_lv_cfg(117) ->
	#pet_lv_cfg{lv = 117,max_exp = 50898,attr = [{1,464},{2,9280},{3,232},{4,232}],combat = 14040,is_tv = 0};

get_lv_cfg(118) ->
	#pet_lv_cfg{lv = 118,max_exp = 51310,attr = [{1,468},{2,9360},{3,234},{4,234}],combat = 14160,is_tv = 0};

get_lv_cfg(119) ->
	#pet_lv_cfg{lv = 119,max_exp = 51725,attr = [{1,472},{2,9440},{3,236},{4,236}],combat = 14280,is_tv = 0};

get_lv_cfg(120) ->
	#pet_lv_cfg{lv = 120,max_exp = 52143,attr = [{1,476},{2,9520},{3,238},{4,238}],combat = 14400,is_tv = 0};

get_lv_cfg(121) ->
	#pet_lv_cfg{lv = 121,max_exp = 52565,attr = [{1,480},{2,9600},{3,240},{4,240}],combat = 14520,is_tv = 0};

get_lv_cfg(122) ->
	#pet_lv_cfg{lv = 122,max_exp = 52990,attr = [{1,484},{2,9680},{3,242},{4,242}],combat = 14640,is_tv = 0};

get_lv_cfg(123) ->
	#pet_lv_cfg{lv = 123,max_exp = 53418,attr = [{1,488},{2,9760},{3,244},{4,244}],combat = 14760,is_tv = 0};

get_lv_cfg(124) ->
	#pet_lv_cfg{lv = 124,max_exp = 53850,attr = [{1,492},{2,9840},{3,246},{4,246}],combat = 14880,is_tv = 0};

get_lv_cfg(125) ->
	#pet_lv_cfg{lv = 125,max_exp = 54285,attr = [{1,496},{2,9920},{3,248},{4,248}],combat = 15000,is_tv = 0};

get_lv_cfg(126) ->
	#pet_lv_cfg{lv = 126,max_exp = 54724,attr = [{1,500},{2,10000},{3,250},{4,250}],combat = 15120,is_tv = 0};

get_lv_cfg(127) ->
	#pet_lv_cfg{lv = 127,max_exp = 55166,attr = [{1,504},{2,10080},{3,252},{4,252}],combat = 15240,is_tv = 0};

get_lv_cfg(128) ->
	#pet_lv_cfg{lv = 128,max_exp = 55612,attr = [{1,508},{2,10160},{3,254},{4,254}],combat = 15360,is_tv = 0};

get_lv_cfg(129) ->
	#pet_lv_cfg{lv = 129,max_exp = 56062,attr = [{1,512},{2,10240},{3,256},{4,256}],combat = 15480,is_tv = 0};

get_lv_cfg(130) ->
	#pet_lv_cfg{lv = 130,max_exp = 56515,attr = [{1,516},{2,10320},{3,258},{4,258}],combat = 15600,is_tv = 0};

get_lv_cfg(131) ->
	#pet_lv_cfg{lv = 131,max_exp = 56972,attr = [{1,520},{2,10400},{3,260},{4,260}],combat = 15720,is_tv = 0};

get_lv_cfg(132) ->
	#pet_lv_cfg{lv = 132,max_exp = 57433,attr = [{1,524},{2,10480},{3,262},{4,262}],combat = 15840,is_tv = 0};

get_lv_cfg(133) ->
	#pet_lv_cfg{lv = 133,max_exp = 57897,attr = [{1,528},{2,10560},{3,264},{4,264}],combat = 15960,is_tv = 0};

get_lv_cfg(134) ->
	#pet_lv_cfg{lv = 134,max_exp = 58365,attr = [{1,532},{2,10640},{3,266},{4,266}],combat = 16080,is_tv = 0};

get_lv_cfg(135) ->
	#pet_lv_cfg{lv = 135,max_exp = 58837,attr = [{1,536},{2,10720},{3,268},{4,268}],combat = 16200,is_tv = 0};

get_lv_cfg(136) ->
	#pet_lv_cfg{lv = 136,max_exp = 59313,attr = [{1,540},{2,10800},{3,270},{4,270}],combat = 16320,is_tv = 0};

get_lv_cfg(137) ->
	#pet_lv_cfg{lv = 137,max_exp = 59793,attr = [{1,544},{2,10880},{3,272},{4,272}],combat = 16440,is_tv = 0};

get_lv_cfg(138) ->
	#pet_lv_cfg{lv = 138,max_exp = 60276,attr = [{1,548},{2,10960},{3,274},{4,274}],combat = 16560,is_tv = 0};

get_lv_cfg(139) ->
	#pet_lv_cfg{lv = 139,max_exp = 60763,attr = [{1,552},{2,11040},{3,276},{4,276}],combat = 16680,is_tv = 0};

get_lv_cfg(140) ->
	#pet_lv_cfg{lv = 140,max_exp = 61254,attr = [{1,556},{2,11120},{3,278},{4,278}],combat = 16800,is_tv = 0};

get_lv_cfg(141) ->
	#pet_lv_cfg{lv = 141,max_exp = 61749,attr = [{1,560},{2,11200},{3,280},{4,280}],combat = 16920,is_tv = 0};

get_lv_cfg(142) ->
	#pet_lv_cfg{lv = 142,max_exp = 62248,attr = [{1,564},{2,11280},{3,282},{4,282}],combat = 17040,is_tv = 0};

get_lv_cfg(143) ->
	#pet_lv_cfg{lv = 143,max_exp = 62751,attr = [{1,568},{2,11360},{3,284},{4,284}],combat = 17160,is_tv = 0};

get_lv_cfg(144) ->
	#pet_lv_cfg{lv = 144,max_exp = 63258,attr = [{1,572},{2,11440},{3,286},{4,286}],combat = 17280,is_tv = 0};

get_lv_cfg(145) ->
	#pet_lv_cfg{lv = 145,max_exp = 63769,attr = [{1,576},{2,11520},{3,288},{4,288}],combat = 17400,is_tv = 0};

get_lv_cfg(146) ->
	#pet_lv_cfg{lv = 146,max_exp = 64285,attr = [{1,580},{2,11600},{3,290},{4,290}],combat = 17520,is_tv = 0};

get_lv_cfg(147) ->
	#pet_lv_cfg{lv = 147,max_exp = 64805,attr = [{1,584},{2,11680},{3,292},{4,292}],combat = 17640,is_tv = 0};

get_lv_cfg(148) ->
	#pet_lv_cfg{lv = 148,max_exp = 65329,attr = [{1,588},{2,11760},{3,294},{4,294}],combat = 17760,is_tv = 0};

get_lv_cfg(149) ->
	#pet_lv_cfg{lv = 149,max_exp = 65857,attr = [{1,592},{2,11840},{3,296},{4,296}],combat = 17880,is_tv = 0};

get_lv_cfg(150) ->
	#pet_lv_cfg{lv = 150,max_exp = 66389,attr = [{1,596},{2,11920},{3,298},{4,298}],combat = 18000,is_tv = 1};

get_lv_cfg(151) ->
	#pet_lv_cfg{lv = 151,max_exp = 66926,attr = [{1,600},{2,12000},{3,300},{4,300}],combat = 18120,is_tv = 0};

get_lv_cfg(152) ->
	#pet_lv_cfg{lv = 152,max_exp = 67467,attr = [{1,604},{2,12080},{3,302},{4,302}],combat = 18240,is_tv = 0};

get_lv_cfg(153) ->
	#pet_lv_cfg{lv = 153,max_exp = 68012,attr = [{1,608},{2,12160},{3,304},{4,304}],combat = 18360,is_tv = 0};

get_lv_cfg(154) ->
	#pet_lv_cfg{lv = 154,max_exp = 68562,attr = [{1,612},{2,12240},{3,306},{4,306}],combat = 18480,is_tv = 0};

get_lv_cfg(155) ->
	#pet_lv_cfg{lv = 155,max_exp = 69116,attr = [{1,616},{2,12320},{3,308},{4,308}],combat = 18600,is_tv = 0};

get_lv_cfg(156) ->
	#pet_lv_cfg{lv = 156,max_exp = 69675,attr = [{1,620},{2,12400},{3,310},{4,310}],combat = 18720,is_tv = 0};

get_lv_cfg(157) ->
	#pet_lv_cfg{lv = 157,max_exp = 70238,attr = [{1,624},{2,12480},{3,312},{4,312}],combat = 18840,is_tv = 0};

get_lv_cfg(158) ->
	#pet_lv_cfg{lv = 158,max_exp = 70806,attr = [{1,628},{2,12560},{3,314},{4,314}],combat = 18960,is_tv = 0};

get_lv_cfg(159) ->
	#pet_lv_cfg{lv = 159,max_exp = 71378,attr = [{1,632},{2,12640},{3,316},{4,316}],combat = 19080,is_tv = 0};

get_lv_cfg(160) ->
	#pet_lv_cfg{lv = 160,max_exp = 71955,attr = [{1,636},{2,12720},{3,318},{4,318}],combat = 19200,is_tv = 0};

get_lv_cfg(161) ->
	#pet_lv_cfg{lv = 161,max_exp = 72537,attr = [{1,640},{2,12800},{3,320},{4,320}],combat = 19320,is_tv = 0};

get_lv_cfg(162) ->
	#pet_lv_cfg{lv = 162,max_exp = 73123,attr = [{1,644},{2,12880},{3,322},{4,322}],combat = 19440,is_tv = 0};

get_lv_cfg(163) ->
	#pet_lv_cfg{lv = 163,max_exp = 73714,attr = [{1,648},{2,12960},{3,324},{4,324}],combat = 19560,is_tv = 0};

get_lv_cfg(164) ->
	#pet_lv_cfg{lv = 164,max_exp = 74310,attr = [{1,652},{2,13040},{3,326},{4,326}],combat = 19680,is_tv = 0};

get_lv_cfg(165) ->
	#pet_lv_cfg{lv = 165,max_exp = 74911,attr = [{1,656},{2,13120},{3,328},{4,328}],combat = 19800,is_tv = 0};

get_lv_cfg(166) ->
	#pet_lv_cfg{lv = 166,max_exp = 75517,attr = [{1,660},{2,13200},{3,330},{4,330}],combat = 19920,is_tv = 0};

get_lv_cfg(167) ->
	#pet_lv_cfg{lv = 167,max_exp = 76128,attr = [{1,664},{2,13280},{3,332},{4,332}],combat = 20040,is_tv = 0};

get_lv_cfg(168) ->
	#pet_lv_cfg{lv = 168,max_exp = 76743,attr = [{1,668},{2,13360},{3,334},{4,334}],combat = 20160,is_tv = 0};

get_lv_cfg(169) ->
	#pet_lv_cfg{lv = 169,max_exp = 77363,attr = [{1,672},{2,13440},{3,336},{4,336}],combat = 20280,is_tv = 0};

get_lv_cfg(170) ->
	#pet_lv_cfg{lv = 170,max_exp = 77988,attr = [{1,676},{2,13520},{3,338},{4,338}],combat = 20400,is_tv = 0};

get_lv_cfg(171) ->
	#pet_lv_cfg{lv = 171,max_exp = 78619,attr = [{1,680},{2,13600},{3,340},{4,340}],combat = 20520,is_tv = 0};

get_lv_cfg(172) ->
	#pet_lv_cfg{lv = 172,max_exp = 79255,attr = [{1,684},{2,13680},{3,342},{4,342}],combat = 20640,is_tv = 0};

get_lv_cfg(173) ->
	#pet_lv_cfg{lv = 173,max_exp = 79896,attr = [{1,688},{2,13760},{3,344},{4,344}],combat = 20760,is_tv = 0};

get_lv_cfg(174) ->
	#pet_lv_cfg{lv = 174,max_exp = 80542,attr = [{1,692},{2,13840},{3,346},{4,346}],combat = 20880,is_tv = 0};

get_lv_cfg(175) ->
	#pet_lv_cfg{lv = 175,max_exp = 81193,attr = [{1,696},{2,13920},{3,348},{4,348}],combat = 21000,is_tv = 0};

get_lv_cfg(176) ->
	#pet_lv_cfg{lv = 176,max_exp = 81849,attr = [{1,700},{2,14000},{3,350},{4,350}],combat = 21120,is_tv = 0};

get_lv_cfg(177) ->
	#pet_lv_cfg{lv = 177,max_exp = 82511,attr = [{1,704},{2,14080},{3,352},{4,352}],combat = 21240,is_tv = 0};

get_lv_cfg(178) ->
	#pet_lv_cfg{lv = 178,max_exp = 83178,attr = [{1,708},{2,14160},{3,354},{4,354}],combat = 21360,is_tv = 0};

get_lv_cfg(179) ->
	#pet_lv_cfg{lv = 179,max_exp = 83850,attr = [{1,712},{2,14240},{3,356},{4,356}],combat = 21480,is_tv = 0};

get_lv_cfg(180) ->
	#pet_lv_cfg{lv = 180,max_exp = 84528,attr = [{1,716},{2,14320},{3,358},{4,358}],combat = 21600,is_tv = 0};

get_lv_cfg(181) ->
	#pet_lv_cfg{lv = 181,max_exp = 85211,attr = [{1,720},{2,14400},{3,360},{4,360}],combat = 21720,is_tv = 0};

get_lv_cfg(182) ->
	#pet_lv_cfg{lv = 182,max_exp = 85900,attr = [{1,724},{2,14480},{3,362},{4,362}],combat = 21840,is_tv = 0};

get_lv_cfg(183) ->
	#pet_lv_cfg{lv = 183,max_exp = 86595,attr = [{1,728},{2,14560},{3,364},{4,364}],combat = 21960,is_tv = 0};

get_lv_cfg(184) ->
	#pet_lv_cfg{lv = 184,max_exp = 87295,attr = [{1,732},{2,14640},{3,366},{4,366}],combat = 22080,is_tv = 0};

get_lv_cfg(185) ->
	#pet_lv_cfg{lv = 185,max_exp = 88001,attr = [{1,736},{2,14720},{3,368},{4,368}],combat = 22200,is_tv = 0};

get_lv_cfg(186) ->
	#pet_lv_cfg{lv = 186,max_exp = 88712,attr = [{1,740},{2,14800},{3,370},{4,370}],combat = 22320,is_tv = 0};

get_lv_cfg(187) ->
	#pet_lv_cfg{lv = 187,max_exp = 89429,attr = [{1,744},{2,14880},{3,372},{4,372}],combat = 22440,is_tv = 0};

get_lv_cfg(188) ->
	#pet_lv_cfg{lv = 188,max_exp = 90152,attr = [{1,748},{2,14960},{3,374},{4,374}],combat = 22560,is_tv = 0};

get_lv_cfg(189) ->
	#pet_lv_cfg{lv = 189,max_exp = 90881,attr = [{1,752},{2,15040},{3,376},{4,376}],combat = 22680,is_tv = 0};

get_lv_cfg(190) ->
	#pet_lv_cfg{lv = 190,max_exp = 91616,attr = [{1,756},{2,15120},{3,378},{4,378}],combat = 22800,is_tv = 0};

get_lv_cfg(191) ->
	#pet_lv_cfg{lv = 191,max_exp = 92357,attr = [{1,760},{2,15200},{3,380},{4,380}],combat = 22920,is_tv = 0};

get_lv_cfg(192) ->
	#pet_lv_cfg{lv = 192,max_exp = 93104,attr = [{1,764},{2,15280},{3,382},{4,382}],combat = 23040,is_tv = 0};

get_lv_cfg(193) ->
	#pet_lv_cfg{lv = 193,max_exp = 93857,attr = [{1,768},{2,15360},{3,384},{4,384}],combat = 23160,is_tv = 0};

get_lv_cfg(194) ->
	#pet_lv_cfg{lv = 194,max_exp = 94616,attr = [{1,772},{2,15440},{3,386},{4,386}],combat = 23280,is_tv = 0};

get_lv_cfg(195) ->
	#pet_lv_cfg{lv = 195,max_exp = 95381,attr = [{1,776},{2,15520},{3,388},{4,388}],combat = 23400,is_tv = 0};

get_lv_cfg(196) ->
	#pet_lv_cfg{lv = 196,max_exp = 96152,attr = [{1,780},{2,15600},{3,390},{4,390}],combat = 23520,is_tv = 0};

get_lv_cfg(197) ->
	#pet_lv_cfg{lv = 197,max_exp = 96929,attr = [{1,784},{2,15680},{3,392},{4,392}],combat = 23640,is_tv = 0};

get_lv_cfg(198) ->
	#pet_lv_cfg{lv = 198,max_exp = 97713,attr = [{1,788},{2,15760},{3,394},{4,394}],combat = 23760,is_tv = 0};

get_lv_cfg(199) ->
	#pet_lv_cfg{lv = 199,max_exp = 98503,attr = [{1,792},{2,15840},{3,396},{4,396}],combat = 23880,is_tv = 0};

get_lv_cfg(200) ->
	#pet_lv_cfg{lv = 200,max_exp = 99299,attr = [{1,796},{2,15920},{3,398},{4,398}],combat = 24000,is_tv = 1};

get_lv_cfg(201) ->
	#pet_lv_cfg{lv = 201,max_exp = 100102,attr = [{1,800},{2,16000},{3,400},{4,400}],combat = 24120,is_tv = 0};

get_lv_cfg(202) ->
	#pet_lv_cfg{lv = 202,max_exp = 100911,attr = [{1,804},{2,16080},{3,402},{4,402}],combat = 24240,is_tv = 0};

get_lv_cfg(203) ->
	#pet_lv_cfg{lv = 203,max_exp = 101727,attr = [{1,808},{2,16160},{3,404},{4,404}],combat = 24360,is_tv = 0};

get_lv_cfg(204) ->
	#pet_lv_cfg{lv = 204,max_exp = 102549,attr = [{1,812},{2,16240},{3,406},{4,406}],combat = 24480,is_tv = 0};

get_lv_cfg(205) ->
	#pet_lv_cfg{lv = 205,max_exp = 103378,attr = [{1,816},{2,16320},{3,408},{4,408}],combat = 24600,is_tv = 0};

get_lv_cfg(206) ->
	#pet_lv_cfg{lv = 206,max_exp = 104214,attr = [{1,820},{2,16400},{3,410},{4,410}],combat = 24720,is_tv = 0};

get_lv_cfg(207) ->
	#pet_lv_cfg{lv = 207,max_exp = 105057,attr = [{1,824},{2,16480},{3,412},{4,412}],combat = 24840,is_tv = 0};

get_lv_cfg(208) ->
	#pet_lv_cfg{lv = 208,max_exp = 105906,attr = [{1,828},{2,16560},{3,414},{4,414}],combat = 24960,is_tv = 0};

get_lv_cfg(209) ->
	#pet_lv_cfg{lv = 209,max_exp = 106762,attr = [{1,832},{2,16640},{3,416},{4,416}],combat = 25080,is_tv = 0};

get_lv_cfg(210) ->
	#pet_lv_cfg{lv = 210,max_exp = 107625,attr = [{1,836},{2,16720},{3,418},{4,418}],combat = 25200,is_tv = 0};

get_lv_cfg(211) ->
	#pet_lv_cfg{lv = 211,max_exp = 108495,attr = [{1,840},{2,16800},{3,420},{4,420}],combat = 25320,is_tv = 0};

get_lv_cfg(212) ->
	#pet_lv_cfg{lv = 212,max_exp = 109372,attr = [{1,844},{2,16880},{3,422},{4,422}],combat = 25440,is_tv = 0};

get_lv_cfg(213) ->
	#pet_lv_cfg{lv = 213,max_exp = 110256,attr = [{1,848},{2,16960},{3,424},{4,424}],combat = 25560,is_tv = 0};

get_lv_cfg(214) ->
	#pet_lv_cfg{lv = 214,max_exp = 111147,attr = [{1,852},{2,17040},{3,426},{4,426}],combat = 25680,is_tv = 0};

get_lv_cfg(215) ->
	#pet_lv_cfg{lv = 215,max_exp = 112046,attr = [{1,856},{2,17120},{3,428},{4,428}],combat = 25800,is_tv = 0};

get_lv_cfg(216) ->
	#pet_lv_cfg{lv = 216,max_exp = 112952,attr = [{1,860},{2,17200},{3,430},{4,430}],combat = 25920,is_tv = 0};

get_lv_cfg(217) ->
	#pet_lv_cfg{lv = 217,max_exp = 113865,attr = [{1,864},{2,17280},{3,432},{4,432}],combat = 26040,is_tv = 0};

get_lv_cfg(218) ->
	#pet_lv_cfg{lv = 218,max_exp = 114786,attr = [{1,868},{2,17360},{3,434},{4,434}],combat = 26160,is_tv = 0};

get_lv_cfg(219) ->
	#pet_lv_cfg{lv = 219,max_exp = 115714,attr = [{1,872},{2,17440},{3,436},{4,436}],combat = 26280,is_tv = 0};

get_lv_cfg(220) ->
	#pet_lv_cfg{lv = 220,max_exp = 116650,attr = [{1,876},{2,17520},{3,438},{4,438}],combat = 26400,is_tv = 0};

get_lv_cfg(221) ->
	#pet_lv_cfg{lv = 221,max_exp = 117593,attr = [{1,880},{2,17600},{3,440},{4,440}],combat = 26520,is_tv = 0};

get_lv_cfg(222) ->
	#pet_lv_cfg{lv = 222,max_exp = 118544,attr = [{1,884},{2,17680},{3,442},{4,442}],combat = 26640,is_tv = 0};

get_lv_cfg(223) ->
	#pet_lv_cfg{lv = 223,max_exp = 119502,attr = [{1,888},{2,17760},{3,444},{4,444}],combat = 26760,is_tv = 0};

get_lv_cfg(224) ->
	#pet_lv_cfg{lv = 224,max_exp = 120468,attr = [{1,892},{2,17840},{3,446},{4,446}],combat = 26880,is_tv = 0};

get_lv_cfg(225) ->
	#pet_lv_cfg{lv = 225,max_exp = 121442,attr = [{1,896},{2,17920},{3,448},{4,448}],combat = 27000,is_tv = 0};

get_lv_cfg(226) ->
	#pet_lv_cfg{lv = 226,max_exp = 122424,attr = [{1,900},{2,18000},{3,450},{4,450}],combat = 27120,is_tv = 0};

get_lv_cfg(227) ->
	#pet_lv_cfg{lv = 227,max_exp = 123414,attr = [{1,904},{2,18080},{3,452},{4,452}],combat = 27240,is_tv = 0};

get_lv_cfg(228) ->
	#pet_lv_cfg{lv = 228,max_exp = 124412,attr = [{1,908},{2,18160},{3,454},{4,454}],combat = 27360,is_tv = 0};

get_lv_cfg(229) ->
	#pet_lv_cfg{lv = 229,max_exp = 125418,attr = [{1,912},{2,18240},{3,456},{4,456}],combat = 27480,is_tv = 0};

get_lv_cfg(230) ->
	#pet_lv_cfg{lv = 230,max_exp = 126432,attr = [{1,916},{2,18320},{3,458},{4,458}],combat = 27600,is_tv = 0};

get_lv_cfg(231) ->
	#pet_lv_cfg{lv = 231,max_exp = 127454,attr = [{1,920},{2,18400},{3,460},{4,460}],combat = 27720,is_tv = 0};

get_lv_cfg(232) ->
	#pet_lv_cfg{lv = 232,max_exp = 128484,attr = [{1,924},{2,18480},{3,462},{4,462}],combat = 27840,is_tv = 0};

get_lv_cfg(233) ->
	#pet_lv_cfg{lv = 233,max_exp = 129523,attr = [{1,928},{2,18560},{3,464},{4,464}],combat = 27960,is_tv = 0};

get_lv_cfg(234) ->
	#pet_lv_cfg{lv = 234,max_exp = 130570,attr = [{1,932},{2,18640},{3,466},{4,466}],combat = 28080,is_tv = 0};

get_lv_cfg(235) ->
	#pet_lv_cfg{lv = 235,max_exp = 131626,attr = [{1,936},{2,18720},{3,468},{4,468}],combat = 28200,is_tv = 0};

get_lv_cfg(236) ->
	#pet_lv_cfg{lv = 236,max_exp = 132690,attr = [{1,940},{2,18800},{3,470},{4,470}],combat = 28320,is_tv = 0};

get_lv_cfg(237) ->
	#pet_lv_cfg{lv = 237,max_exp = 133763,attr = [{1,944},{2,18880},{3,472},{4,472}],combat = 28440,is_tv = 0};

get_lv_cfg(238) ->
	#pet_lv_cfg{lv = 238,max_exp = 134844,attr = [{1,948},{2,18960},{3,474},{4,474}],combat = 28560,is_tv = 0};

get_lv_cfg(239) ->
	#pet_lv_cfg{lv = 239,max_exp = 135934,attr = [{1,952},{2,19040},{3,476},{4,476}],combat = 28680,is_tv = 0};

get_lv_cfg(240) ->
	#pet_lv_cfg{lv = 240,max_exp = 137033,attr = [{1,956},{2,19120},{3,478},{4,478}],combat = 28800,is_tv = 0};

get_lv_cfg(241) ->
	#pet_lv_cfg{lv = 241,max_exp = 138141,attr = [{1,960},{2,19200},{3,480},{4,480}],combat = 28920,is_tv = 0};

get_lv_cfg(242) ->
	#pet_lv_cfg{lv = 242,max_exp = 139258,attr = [{1,964},{2,19280},{3,482},{4,482}],combat = 29040,is_tv = 0};

get_lv_cfg(243) ->
	#pet_lv_cfg{lv = 243,max_exp = 140384,attr = [{1,968},{2,19360},{3,484},{4,484}],combat = 29160,is_tv = 0};

get_lv_cfg(244) ->
	#pet_lv_cfg{lv = 244,max_exp = 141519,attr = [{1,972},{2,19440},{3,486},{4,486}],combat = 29280,is_tv = 0};

get_lv_cfg(245) ->
	#pet_lv_cfg{lv = 245,max_exp = 142663,attr = [{1,976},{2,19520},{3,488},{4,488}],combat = 29400,is_tv = 0};

get_lv_cfg(246) ->
	#pet_lv_cfg{lv = 246,max_exp = 143816,attr = [{1,980},{2,19600},{3,490},{4,490}],combat = 29520,is_tv = 0};

get_lv_cfg(247) ->
	#pet_lv_cfg{lv = 247,max_exp = 144979,attr = [{1,984},{2,19680},{3,492},{4,492}],combat = 29640,is_tv = 0};

get_lv_cfg(248) ->
	#pet_lv_cfg{lv = 248,max_exp = 146151,attr = [{1,988},{2,19760},{3,494},{4,494}],combat = 29760,is_tv = 0};

get_lv_cfg(249) ->
	#pet_lv_cfg{lv = 249,max_exp = 147333,attr = [{1,992},{2,19840},{3,496},{4,496}],combat = 29880,is_tv = 0};

get_lv_cfg(250) ->
	#pet_lv_cfg{lv = 250,max_exp = 148524,attr = [{1,996},{2,19920},{3,498},{4,498}],combat = 30000,is_tv = 1};

get_lv_cfg(251) ->
	#pet_lv_cfg{lv = 251,max_exp = 149725,attr = [{1,1000},{2,20000},{3,500},{4,500}],combat = 30120,is_tv = 0};

get_lv_cfg(252) ->
	#pet_lv_cfg{lv = 252,max_exp = 150936,attr = [{1,1004},{2,20080},{3,502},{4,502}],combat = 30240,is_tv = 0};

get_lv_cfg(253) ->
	#pet_lv_cfg{lv = 253,max_exp = 152156,attr = [{1,1008},{2,20160},{3,504},{4,504}],combat = 30360,is_tv = 0};

get_lv_cfg(254) ->
	#pet_lv_cfg{lv = 254,max_exp = 153386,attr = [{1,1012},{2,20240},{3,506},{4,506}],combat = 30480,is_tv = 0};

get_lv_cfg(255) ->
	#pet_lv_cfg{lv = 255,max_exp = 154626,attr = [{1,1016},{2,20320},{3,508},{4,508}],combat = 30600,is_tv = 0};

get_lv_cfg(256) ->
	#pet_lv_cfg{lv = 256,max_exp = 155876,attr = [{1,1020},{2,20400},{3,510},{4,510}],combat = 30720,is_tv = 0};

get_lv_cfg(257) ->
	#pet_lv_cfg{lv = 257,max_exp = 157136,attr = [{1,1024},{2,20480},{3,512},{4,512}],combat = 30840,is_tv = 0};

get_lv_cfg(258) ->
	#pet_lv_cfg{lv = 258,max_exp = 158406,attr = [{1,1028},{2,20560},{3,514},{4,514}],combat = 30960,is_tv = 0};

get_lv_cfg(259) ->
	#pet_lv_cfg{lv = 259,max_exp = 159687,attr = [{1,1032},{2,20640},{3,516},{4,516}],combat = 31080,is_tv = 0};

get_lv_cfg(260) ->
	#pet_lv_cfg{lv = 260,max_exp = 160978,attr = [{1,1036},{2,20720},{3,518},{4,518}],combat = 31200,is_tv = 0};

get_lv_cfg(261) ->
	#pet_lv_cfg{lv = 261,max_exp = 162280,attr = [{1,1040},{2,20800},{3,520},{4,520}],combat = 31320,is_tv = 0};

get_lv_cfg(262) ->
	#pet_lv_cfg{lv = 262,max_exp = 163592,attr = [{1,1044},{2,20880},{3,522},{4,522}],combat = 31440,is_tv = 0};

get_lv_cfg(263) ->
	#pet_lv_cfg{lv = 263,max_exp = 164915,attr = [{1,1048},{2,20960},{3,524},{4,524}],combat = 31560,is_tv = 0};

get_lv_cfg(264) ->
	#pet_lv_cfg{lv = 264,max_exp = 166248,attr = [{1,1052},{2,21040},{3,526},{4,526}],combat = 31680,is_tv = 0};

get_lv_cfg(265) ->
	#pet_lv_cfg{lv = 265,max_exp = 167592,attr = [{1,1056},{2,21120},{3,528},{4,528}],combat = 31800,is_tv = 0};

get_lv_cfg(266) ->
	#pet_lv_cfg{lv = 266,max_exp = 168947,attr = [{1,1060},{2,21200},{3,530},{4,530}],combat = 31920,is_tv = 0};

get_lv_cfg(267) ->
	#pet_lv_cfg{lv = 267,max_exp = 170313,attr = [{1,1064},{2,21280},{3,532},{4,532}],combat = 32040,is_tv = 0};

get_lv_cfg(268) ->
	#pet_lv_cfg{lv = 268,max_exp = 171690,attr = [{1,1068},{2,21360},{3,534},{4,534}],combat = 32160,is_tv = 0};

get_lv_cfg(269) ->
	#pet_lv_cfg{lv = 269,max_exp = 173078,attr = [{1,1072},{2,21440},{3,536},{4,536}],combat = 32280,is_tv = 0};

get_lv_cfg(270) ->
	#pet_lv_cfg{lv = 270,max_exp = 174477,attr = [{1,1076},{2,21520},{3,538},{4,538}],combat = 32400,is_tv = 0};

get_lv_cfg(271) ->
	#pet_lv_cfg{lv = 271,max_exp = 175888,attr = [{1,1080},{2,21600},{3,540},{4,540}],combat = 32520,is_tv = 0};

get_lv_cfg(272) ->
	#pet_lv_cfg{lv = 272,max_exp = 177310,attr = [{1,1084},{2,21680},{3,542},{4,542}],combat = 32640,is_tv = 0};

get_lv_cfg(273) ->
	#pet_lv_cfg{lv = 273,max_exp = 178744,attr = [{1,1088},{2,21760},{3,544},{4,544}],combat = 32760,is_tv = 0};

get_lv_cfg(274) ->
	#pet_lv_cfg{lv = 274,max_exp = 180189,attr = [{1,1092},{2,21840},{3,546},{4,546}],combat = 32880,is_tv = 0};

get_lv_cfg(275) ->
	#pet_lv_cfg{lv = 275,max_exp = 181646,attr = [{1,1096},{2,21920},{3,548},{4,548}],combat = 33000,is_tv = 0};

get_lv_cfg(276) ->
	#pet_lv_cfg{lv = 276,max_exp = 183115,attr = [{1,1100},{2,22000},{3,550},{4,550}],combat = 33120,is_tv = 0};

get_lv_cfg(277) ->
	#pet_lv_cfg{lv = 277,max_exp = 184595,attr = [{1,1104},{2,22080},{3,552},{4,552}],combat = 33240,is_tv = 0};

get_lv_cfg(278) ->
	#pet_lv_cfg{lv = 278,max_exp = 186087,attr = [{1,1108},{2,22160},{3,554},{4,554}],combat = 33360,is_tv = 0};

get_lv_cfg(279) ->
	#pet_lv_cfg{lv = 279,max_exp = 187592,attr = [{1,1112},{2,22240},{3,556},{4,556}],combat = 33480,is_tv = 0};

get_lv_cfg(280) ->
	#pet_lv_cfg{lv = 280,max_exp = 189109,attr = [{1,1116},{2,22320},{3,558},{4,558}],combat = 33600,is_tv = 0};

get_lv_cfg(281) ->
	#pet_lv_cfg{lv = 281,max_exp = 190638,attr = [{1,1120},{2,22400},{3,560},{4,560}],combat = 33720,is_tv = 0};

get_lv_cfg(282) ->
	#pet_lv_cfg{lv = 282,max_exp = 192179,attr = [{1,1124},{2,22480},{3,562},{4,562}],combat = 33840,is_tv = 0};

get_lv_cfg(283) ->
	#pet_lv_cfg{lv = 283,max_exp = 193733,attr = [{1,1128},{2,22560},{3,564},{4,564}],combat = 33960,is_tv = 0};

get_lv_cfg(284) ->
	#pet_lv_cfg{lv = 284,max_exp = 195299,attr = [{1,1132},{2,22640},{3,566},{4,566}],combat = 34080,is_tv = 0};

get_lv_cfg(285) ->
	#pet_lv_cfg{lv = 285,max_exp = 196878,attr = [{1,1136},{2,22720},{3,568},{4,568}],combat = 34200,is_tv = 0};

get_lv_cfg(286) ->
	#pet_lv_cfg{lv = 286,max_exp = 198470,attr = [{1,1140},{2,22800},{3,570},{4,570}],combat = 34320,is_tv = 0};

get_lv_cfg(287) ->
	#pet_lv_cfg{lv = 287,max_exp = 200075,attr = [{1,1144},{2,22880},{3,572},{4,572}],combat = 34440,is_tv = 0};

get_lv_cfg(288) ->
	#pet_lv_cfg{lv = 288,max_exp = 201693,attr = [{1,1148},{2,22960},{3,574},{4,574}],combat = 34560,is_tv = 0};

get_lv_cfg(289) ->
	#pet_lv_cfg{lv = 289,max_exp = 203324,attr = [{1,1152},{2,23040},{3,576},{4,576}],combat = 34680,is_tv = 0};

get_lv_cfg(290) ->
	#pet_lv_cfg{lv = 290,max_exp = 204968,attr = [{1,1156},{2,23120},{3,578},{4,578}],combat = 34800,is_tv = 0};

get_lv_cfg(291) ->
	#pet_lv_cfg{lv = 291,max_exp = 206625,attr = [{1,1160},{2,23200},{3,580},{4,580}],combat = 34920,is_tv = 0};

get_lv_cfg(292) ->
	#pet_lv_cfg{lv = 292,max_exp = 208296,attr = [{1,1164},{2,23280},{3,582},{4,582}],combat = 35040,is_tv = 0};

get_lv_cfg(293) ->
	#pet_lv_cfg{lv = 293,max_exp = 209980,attr = [{1,1168},{2,23360},{3,584},{4,584}],combat = 35160,is_tv = 0};

get_lv_cfg(294) ->
	#pet_lv_cfg{lv = 294,max_exp = 211678,attr = [{1,1172},{2,23440},{3,586},{4,586}],combat = 35280,is_tv = 0};

get_lv_cfg(295) ->
	#pet_lv_cfg{lv = 295,max_exp = 213389,attr = [{1,1176},{2,23520},{3,588},{4,588}],combat = 35400,is_tv = 0};

get_lv_cfg(296) ->
	#pet_lv_cfg{lv = 296,max_exp = 215114,attr = [{1,1180},{2,23600},{3,590},{4,590}],combat = 35520,is_tv = 0};

get_lv_cfg(297) ->
	#pet_lv_cfg{lv = 297,max_exp = 216853,attr = [{1,1184},{2,23680},{3,592},{4,592}],combat = 35640,is_tv = 0};

get_lv_cfg(298) ->
	#pet_lv_cfg{lv = 298,max_exp = 218606,attr = [{1,1188},{2,23760},{3,594},{4,594}],combat = 35760,is_tv = 0};

get_lv_cfg(299) ->
	#pet_lv_cfg{lv = 299,max_exp = 220373,attr = [{1,1192},{2,23840},{3,596},{4,596}],combat = 35880,is_tv = 0};

get_lv_cfg(300) ->
	#pet_lv_cfg{lv = 300,max_exp = 222155,attr = [{1,1196},{2,23920},{3,598},{4,598}],combat = 36000,is_tv = 1};

get_lv_cfg(301) ->
	#pet_lv_cfg{lv = 301,max_exp = 223951,attr = [{1,1200},{2,24000},{3,600},{4,600}],combat = 36120,is_tv = 0};

get_lv_cfg(302) ->
	#pet_lv_cfg{lv = 302,max_exp = 225762,attr = [{1,1204},{2,24080},{3,602},{4,602}],combat = 36240,is_tv = 0};

get_lv_cfg(303) ->
	#pet_lv_cfg{lv = 303,max_exp = 227587,attr = [{1,1208},{2,24160},{3,604},{4,604}],combat = 36360,is_tv = 0};

get_lv_cfg(304) ->
	#pet_lv_cfg{lv = 304,max_exp = 229427,attr = [{1,1212},{2,24240},{3,606},{4,606}],combat = 36480,is_tv = 0};

get_lv_cfg(305) ->
	#pet_lv_cfg{lv = 305,max_exp = 231282,attr = [{1,1216},{2,24320},{3,608},{4,608}],combat = 36600,is_tv = 0};

get_lv_cfg(306) ->
	#pet_lv_cfg{lv = 306,max_exp = 233152,attr = [{1,1220},{2,24400},{3,610},{4,610}],combat = 36720,is_tv = 0};

get_lv_cfg(307) ->
	#pet_lv_cfg{lv = 307,max_exp = 235037,attr = [{1,1224},{2,24480},{3,612},{4,612}],combat = 36840,is_tv = 0};

get_lv_cfg(308) ->
	#pet_lv_cfg{lv = 308,max_exp = 236937,attr = [{1,1228},{2,24560},{3,614},{4,614}],combat = 36960,is_tv = 0};

get_lv_cfg(309) ->
	#pet_lv_cfg{lv = 309,max_exp = 238853,attr = [{1,1232},{2,24640},{3,616},{4,616}],combat = 37080,is_tv = 0};

get_lv_cfg(310) ->
	#pet_lv_cfg{lv = 310,max_exp = 240784,attr = [{1,1236},{2,24720},{3,618},{4,618}],combat = 37200,is_tv = 0};

get_lv_cfg(311) ->
	#pet_lv_cfg{lv = 311,max_exp = 242731,attr = [{1,1240},{2,24800},{3,620},{4,620}],combat = 37320,is_tv = 0};

get_lv_cfg(312) ->
	#pet_lv_cfg{lv = 312,max_exp = 244693,attr = [{1,1244},{2,24880},{3,622},{4,622}],combat = 37440,is_tv = 0};

get_lv_cfg(313) ->
	#pet_lv_cfg{lv = 313,max_exp = 246671,attr = [{1,1248},{2,24960},{3,624},{4,624}],combat = 37560,is_tv = 0};

get_lv_cfg(314) ->
	#pet_lv_cfg{lv = 314,max_exp = 248665,attr = [{1,1252},{2,25040},{3,626},{4,626}],combat = 37680,is_tv = 0};

get_lv_cfg(315) ->
	#pet_lv_cfg{lv = 315,max_exp = 250675,attr = [{1,1256},{2,25120},{3,628},{4,628}],combat = 37800,is_tv = 0};

get_lv_cfg(316) ->
	#pet_lv_cfg{lv = 316,max_exp = 252702,attr = [{1,1260},{2,25200},{3,630},{4,630}],combat = 37920,is_tv = 0};

get_lv_cfg(317) ->
	#pet_lv_cfg{lv = 317,max_exp = 254745,attr = [{1,1264},{2,25280},{3,632},{4,632}],combat = 38040,is_tv = 0};

get_lv_cfg(318) ->
	#pet_lv_cfg{lv = 318,max_exp = 256805,attr = [{1,1268},{2,25360},{3,634},{4,634}],combat = 38160,is_tv = 0};

get_lv_cfg(319) ->
	#pet_lv_cfg{lv = 319,max_exp = 258881,attr = [{1,1272},{2,25440},{3,636},{4,636}],combat = 38280,is_tv = 0};

get_lv_cfg(320) ->
	#pet_lv_cfg{lv = 320,max_exp = 260974,attr = [{1,1276},{2,25520},{3,638},{4,638}],combat = 38400,is_tv = 0};

get_lv_cfg(321) ->
	#pet_lv_cfg{lv = 321,max_exp = 263084,attr = [{1,1280},{2,25600},{3,640},{4,640}],combat = 38520,is_tv = 0};

get_lv_cfg(322) ->
	#pet_lv_cfg{lv = 322,max_exp = 265211,attr = [{1,1284},{2,25680},{3,642},{4,642}],combat = 38640,is_tv = 0};

get_lv_cfg(323) ->
	#pet_lv_cfg{lv = 323,max_exp = 267355,attr = [{1,1288},{2,25760},{3,644},{4,644}],combat = 38760,is_tv = 0};

get_lv_cfg(324) ->
	#pet_lv_cfg{lv = 324,max_exp = 269517,attr = [{1,1292},{2,25840},{3,646},{4,646}],combat = 38880,is_tv = 0};

get_lv_cfg(325) ->
	#pet_lv_cfg{lv = 325,max_exp = 271696,attr = [{1,1296},{2,25920},{3,648},{4,648}],combat = 39000,is_tv = 0};

get_lv_cfg(326) ->
	#pet_lv_cfg{lv = 326,max_exp = 273893,attr = [{1,1300},{2,26000},{3,650},{4,650}],combat = 39120,is_tv = 0};

get_lv_cfg(327) ->
	#pet_lv_cfg{lv = 327,max_exp = 276107,attr = [{1,1304},{2,26080},{3,652},{4,652}],combat = 39240,is_tv = 0};

get_lv_cfg(328) ->
	#pet_lv_cfg{lv = 328,max_exp = 278339,attr = [{1,1308},{2,26160},{3,654},{4,654}],combat = 39360,is_tv = 0};

get_lv_cfg(329) ->
	#pet_lv_cfg{lv = 329,max_exp = 280589,attr = [{1,1312},{2,26240},{3,656},{4,656}],combat = 39480,is_tv = 0};

get_lv_cfg(330) ->
	#pet_lv_cfg{lv = 330,max_exp = 282858,attr = [{1,1316},{2,26320},{3,658},{4,658}],combat = 39600,is_tv = 0};

get_lv_cfg(331) ->
	#pet_lv_cfg{lv = 331,max_exp = 285145,attr = [{1,1320},{2,26400},{3,660},{4,660}],combat = 39720,is_tv = 0};

get_lv_cfg(332) ->
	#pet_lv_cfg{lv = 332,max_exp = 287450,attr = [{1,1324},{2,26480},{3,662},{4,662}],combat = 39840,is_tv = 0};

get_lv_cfg(333) ->
	#pet_lv_cfg{lv = 333,max_exp = 289774,attr = [{1,1328},{2,26560},{3,664},{4,664}],combat = 39960,is_tv = 0};

get_lv_cfg(334) ->
	#pet_lv_cfg{lv = 334,max_exp = 292117,attr = [{1,1332},{2,26640},{3,666},{4,666}],combat = 40080,is_tv = 0};

get_lv_cfg(335) ->
	#pet_lv_cfg{lv = 335,max_exp = 294479,attr = [{1,1336},{2,26720},{3,668},{4,668}],combat = 40200,is_tv = 0};

get_lv_cfg(336) ->
	#pet_lv_cfg{lv = 336,max_exp = 296860,attr = [{1,1340},{2,26800},{3,670},{4,670}],combat = 40320,is_tv = 0};

get_lv_cfg(337) ->
	#pet_lv_cfg{lv = 337,max_exp = 299260,attr = [{1,1344},{2,26880},{3,672},{4,672}],combat = 40440,is_tv = 0};

get_lv_cfg(338) ->
	#pet_lv_cfg{lv = 338,max_exp = 301680,attr = [{1,1348},{2,26960},{3,674},{4,674}],combat = 40560,is_tv = 0};

get_lv_cfg(339) ->
	#pet_lv_cfg{lv = 339,max_exp = 304119,attr = [{1,1352},{2,27040},{3,676},{4,676}],combat = 40680,is_tv = 0};

get_lv_cfg(340) ->
	#pet_lv_cfg{lv = 340,max_exp = 306578,attr = [{1,1356},{2,27120},{3,678},{4,678}],combat = 40800,is_tv = 0};

get_lv_cfg(341) ->
	#pet_lv_cfg{lv = 341,max_exp = 309057,attr = [{1,1360},{2,27200},{3,680},{4,680}],combat = 40920,is_tv = 0};

get_lv_cfg(342) ->
	#pet_lv_cfg{lv = 342,max_exp = 311556,attr = [{1,1364},{2,27280},{3,682},{4,682}],combat = 41040,is_tv = 0};

get_lv_cfg(343) ->
	#pet_lv_cfg{lv = 343,max_exp = 314075,attr = [{1,1368},{2,27360},{3,684},{4,684}],combat = 41160,is_tv = 0};

get_lv_cfg(344) ->
	#pet_lv_cfg{lv = 344,max_exp = 316614,attr = [{1,1372},{2,27440},{3,686},{4,686}],combat = 41280,is_tv = 0};

get_lv_cfg(345) ->
	#pet_lv_cfg{lv = 345,max_exp = 319174,attr = [{1,1376},{2,27520},{3,688},{4,688}],combat = 41400,is_tv = 0};

get_lv_cfg(346) ->
	#pet_lv_cfg{lv = 346,max_exp = 321755,attr = [{1,1380},{2,27600},{3,690},{4,690}],combat = 41520,is_tv = 0};

get_lv_cfg(347) ->
	#pet_lv_cfg{lv = 347,max_exp = 324356,attr = [{1,1384},{2,27680},{3,692},{4,692}],combat = 41640,is_tv = 0};

get_lv_cfg(348) ->
	#pet_lv_cfg{lv = 348,max_exp = 326978,attr = [{1,1388},{2,27760},{3,694},{4,694}],combat = 41760,is_tv = 0};

get_lv_cfg(349) ->
	#pet_lv_cfg{lv = 349,max_exp = 329622,attr = [{1,1392},{2,27840},{3,696},{4,696}],combat = 41880,is_tv = 0};

get_lv_cfg(350) ->
	#pet_lv_cfg{lv = 350,max_exp = 332287,attr = [{1,1396},{2,27920},{3,698},{4,698}],combat = 42000,is_tv = 1};

get_lv_cfg(351) ->
	#pet_lv_cfg{lv = 351,max_exp = 334974,attr = [{1,1400},{2,28000},{3,700},{4,700}],combat = 42120,is_tv = 0};

get_lv_cfg(352) ->
	#pet_lv_cfg{lv = 352,max_exp = 337682,attr = [{1,1404},{2,28080},{3,702},{4,702}],combat = 42240,is_tv = 0};

get_lv_cfg(353) ->
	#pet_lv_cfg{lv = 353,max_exp = 340412,attr = [{1,1408},{2,28160},{3,704},{4,704}],combat = 42360,is_tv = 0};

get_lv_cfg(354) ->
	#pet_lv_cfg{lv = 354,max_exp = 343164,attr = [{1,1412},{2,28240},{3,706},{4,706}],combat = 42480,is_tv = 0};

get_lv_cfg(355) ->
	#pet_lv_cfg{lv = 355,max_exp = 345938,attr = [{1,1416},{2,28320},{3,708},{4,708}],combat = 42600,is_tv = 0};

get_lv_cfg(356) ->
	#pet_lv_cfg{lv = 356,max_exp = 348735,attr = [{1,1420},{2,28400},{3,710},{4,710}],combat = 42720,is_tv = 0};

get_lv_cfg(357) ->
	#pet_lv_cfg{lv = 357,max_exp = 351555,attr = [{1,1424},{2,28480},{3,712},{4,712}],combat = 42840,is_tv = 0};

get_lv_cfg(358) ->
	#pet_lv_cfg{lv = 358,max_exp = 354397,attr = [{1,1428},{2,28560},{3,714},{4,714}],combat = 42960,is_tv = 0};

get_lv_cfg(359) ->
	#pet_lv_cfg{lv = 359,max_exp = 357262,attr = [{1,1432},{2,28640},{3,716},{4,716}],combat = 43080,is_tv = 0};

get_lv_cfg(360) ->
	#pet_lv_cfg{lv = 360,max_exp = 360150,attr = [{1,1436},{2,28720},{3,718},{4,718}],combat = 43200,is_tv = 0};

get_lv_cfg(361) ->
	#pet_lv_cfg{lv = 361,max_exp = 363062,attr = [{1,1440},{2,28800},{3,720},{4,720}],combat = 43320,is_tv = 0};

get_lv_cfg(362) ->
	#pet_lv_cfg{lv = 362,max_exp = 365997,attr = [{1,1444},{2,28880},{3,722},{4,722}],combat = 43440,is_tv = 0};

get_lv_cfg(363) ->
	#pet_lv_cfg{lv = 363,max_exp = 368956,attr = [{1,1448},{2,28960},{3,724},{4,724}],combat = 43560,is_tv = 0};

get_lv_cfg(364) ->
	#pet_lv_cfg{lv = 364,max_exp = 371939,attr = [{1,1452},{2,29040},{3,726},{4,726}],combat = 43680,is_tv = 0};

get_lv_cfg(365) ->
	#pet_lv_cfg{lv = 365,max_exp = 374946,attr = [{1,1456},{2,29120},{3,728},{4,728}],combat = 43800,is_tv = 0};

get_lv_cfg(366) ->
	#pet_lv_cfg{lv = 366,max_exp = 377977,attr = [{1,1460},{2,29200},{3,730},{4,730}],combat = 43920,is_tv = 0};

get_lv_cfg(367) ->
	#pet_lv_cfg{lv = 367,max_exp = 381033,attr = [{1,1464},{2,29280},{3,732},{4,732}],combat = 44040,is_tv = 0};

get_lv_cfg(368) ->
	#pet_lv_cfg{lv = 368,max_exp = 384114,attr = [{1,1468},{2,29360},{3,734},{4,734}],combat = 44160,is_tv = 0};

get_lv_cfg(369) ->
	#pet_lv_cfg{lv = 369,max_exp = 387220,attr = [{1,1472},{2,29440},{3,736},{4,736}],combat = 44280,is_tv = 0};

get_lv_cfg(370) ->
	#pet_lv_cfg{lv = 370,max_exp = 390351,attr = [{1,1476},{2,29520},{3,738},{4,738}],combat = 44400,is_tv = 0};

get_lv_cfg(371) ->
	#pet_lv_cfg{lv = 371,max_exp = 393507,attr = [{1,1480},{2,29600},{3,740},{4,740}],combat = 44520,is_tv = 0};

get_lv_cfg(372) ->
	#pet_lv_cfg{lv = 372,max_exp = 396689,attr = [{1,1484},{2,29680},{3,742},{4,742}],combat = 44640,is_tv = 0};

get_lv_cfg(373) ->
	#pet_lv_cfg{lv = 373,max_exp = 399896,attr = [{1,1488},{2,29760},{3,744},{4,744}],combat = 44760,is_tv = 0};

get_lv_cfg(374) ->
	#pet_lv_cfg{lv = 374,max_exp = 403129,attr = [{1,1492},{2,29840},{3,746},{4,746}],combat = 44880,is_tv = 0};

get_lv_cfg(375) ->
	#pet_lv_cfg{lv = 375,max_exp = 406388,attr = [{1,1496},{2,29920},{3,748},{4,748}],combat = 45000,is_tv = 0};

get_lv_cfg(376) ->
	#pet_lv_cfg{lv = 376,max_exp = 409674,attr = [{1,1500},{2,30000},{3,750},{4,750}],combat = 45120,is_tv = 0};

get_lv_cfg(377) ->
	#pet_lv_cfg{lv = 377,max_exp = 412986,attr = [{1,1504},{2,30080},{3,752},{4,752}],combat = 45240,is_tv = 0};

get_lv_cfg(378) ->
	#pet_lv_cfg{lv = 378,max_exp = 416325,attr = [{1,1508},{2,30160},{3,754},{4,754}],combat = 45360,is_tv = 0};

get_lv_cfg(379) ->
	#pet_lv_cfg{lv = 379,max_exp = 419691,attr = [{1,1512},{2,30240},{3,756},{4,756}],combat = 45480,is_tv = 0};

get_lv_cfg(380) ->
	#pet_lv_cfg{lv = 380,max_exp = 423084,attr = [{1,1516},{2,30320},{3,758},{4,758}],combat = 45600,is_tv = 0};

get_lv_cfg(381) ->
	#pet_lv_cfg{lv = 381,max_exp = 426505,attr = [{1,1520},{2,30400},{3,760},{4,760}],combat = 45720,is_tv = 0};

get_lv_cfg(382) ->
	#pet_lv_cfg{lv = 382,max_exp = 429953,attr = [{1,1524},{2,30480},{3,762},{4,762}],combat = 45840,is_tv = 0};

get_lv_cfg(383) ->
	#pet_lv_cfg{lv = 383,max_exp = 433429,attr = [{1,1528},{2,30560},{3,764},{4,764}],combat = 45960,is_tv = 0};

get_lv_cfg(384) ->
	#pet_lv_cfg{lv = 384,max_exp = 436933,attr = [{1,1532},{2,30640},{3,766},{4,766}],combat = 46080,is_tv = 0};

get_lv_cfg(385) ->
	#pet_lv_cfg{lv = 385,max_exp = 440466,attr = [{1,1536},{2,30720},{3,768},{4,768}],combat = 46200,is_tv = 0};

get_lv_cfg(386) ->
	#pet_lv_cfg{lv = 386,max_exp = 444027,attr = [{1,1540},{2,30800},{3,770},{4,770}],combat = 46320,is_tv = 0};

get_lv_cfg(387) ->
	#pet_lv_cfg{lv = 387,max_exp = 447617,attr = [{1,1544},{2,30880},{3,772},{4,772}],combat = 46440,is_tv = 0};

get_lv_cfg(388) ->
	#pet_lv_cfg{lv = 388,max_exp = 451236,attr = [{1,1548},{2,30960},{3,774},{4,774}],combat = 46560,is_tv = 0};

get_lv_cfg(389) ->
	#pet_lv_cfg{lv = 389,max_exp = 454884,attr = [{1,1552},{2,31040},{3,776},{4,776}],combat = 46680,is_tv = 0};

get_lv_cfg(390) ->
	#pet_lv_cfg{lv = 390,max_exp = 458562,attr = [{1,1556},{2,31120},{3,778},{4,778}],combat = 46800,is_tv = 0};

get_lv_cfg(391) ->
	#pet_lv_cfg{lv = 391,max_exp = 462269,attr = [{1,1560},{2,31200},{3,780},{4,780}],combat = 46920,is_tv = 0};

get_lv_cfg(392) ->
	#pet_lv_cfg{lv = 392,max_exp = 466006,attr = [{1,1564},{2,31280},{3,782},{4,782}],combat = 47040,is_tv = 0};

get_lv_cfg(393) ->
	#pet_lv_cfg{lv = 393,max_exp = 469774,attr = [{1,1568},{2,31360},{3,784},{4,784}],combat = 47160,is_tv = 0};

get_lv_cfg(394) ->
	#pet_lv_cfg{lv = 394,max_exp = 473572,attr = [{1,1572},{2,31440},{3,786},{4,786}],combat = 47280,is_tv = 0};

get_lv_cfg(395) ->
	#pet_lv_cfg{lv = 395,max_exp = 477401,attr = [{1,1576},{2,31520},{3,788},{4,788}],combat = 47400,is_tv = 0};

get_lv_cfg(396) ->
	#pet_lv_cfg{lv = 396,max_exp = 481261,attr = [{1,1580},{2,31600},{3,790},{4,790}],combat = 47520,is_tv = 0};

get_lv_cfg(397) ->
	#pet_lv_cfg{lv = 397,max_exp = 485152,attr = [{1,1584},{2,31680},{3,792},{4,792}],combat = 47640,is_tv = 0};

get_lv_cfg(398) ->
	#pet_lv_cfg{lv = 398,max_exp = 489074,attr = [{1,1588},{2,31760},{3,794},{4,794}],combat = 47760,is_tv = 0};

get_lv_cfg(399) ->
	#pet_lv_cfg{lv = 399,max_exp = 493028,attr = [{1,1592},{2,31840},{3,796},{4,796}],combat = 47880,is_tv = 0};

get_lv_cfg(400) ->
	#pet_lv_cfg{lv = 400,max_exp = 497014,attr = [{1,1596},{2,31920},{3,798},{4,798}],combat = 48000,is_tv = 1};

get_lv_cfg(401) ->
	#pet_lv_cfg{lv = 401,max_exp = 501032,attr = [{1,1600},{2,32000},{3,800},{4,800}],combat = 48120,is_tv = 0};

get_lv_cfg(402) ->
	#pet_lv_cfg{lv = 402,max_exp = 505083,attr = [{1,1604},{2,32080},{3,802},{4,802}],combat = 48240,is_tv = 0};

get_lv_cfg(403) ->
	#pet_lv_cfg{lv = 403,max_exp = 509167,attr = [{1,1608},{2,32160},{3,804},{4,804}],combat = 48360,is_tv = 0};

get_lv_cfg(404) ->
	#pet_lv_cfg{lv = 404,max_exp = 513284,attr = [{1,1612},{2,32240},{3,806},{4,806}],combat = 48480,is_tv = 0};

get_lv_cfg(405) ->
	#pet_lv_cfg{lv = 405,max_exp = 517434,attr = [{1,1616},{2,32320},{3,808},{4,808}],combat = 48600,is_tv = 0};

get_lv_cfg(406) ->
	#pet_lv_cfg{lv = 406,max_exp = 521617,attr = [{1,1620},{2,32400},{3,810},{4,810}],combat = 48720,is_tv = 0};

get_lv_cfg(407) ->
	#pet_lv_cfg{lv = 407,max_exp = 525834,attr = [{1,1624},{2,32480},{3,812},{4,812}],combat = 48840,is_tv = 0};

get_lv_cfg(408) ->
	#pet_lv_cfg{lv = 408,max_exp = 530085,attr = [{1,1628},{2,32560},{3,814},{4,814}],combat = 48960,is_tv = 0};

get_lv_cfg(409) ->
	#pet_lv_cfg{lv = 409,max_exp = 534371,attr = [{1,1632},{2,32640},{3,816},{4,816}],combat = 49080,is_tv = 0};

get_lv_cfg(410) ->
	#pet_lv_cfg{lv = 410,max_exp = 538691,attr = [{1,1636},{2,32720},{3,818},{4,818}],combat = 49200,is_tv = 0};

get_lv_cfg(411) ->
	#pet_lv_cfg{lv = 411,max_exp = 543046,attr = [{1,1640},{2,32800},{3,820},{4,820}],combat = 49320,is_tv = 0};

get_lv_cfg(412) ->
	#pet_lv_cfg{lv = 412,max_exp = 547437,attr = [{1,1644},{2,32880},{3,822},{4,822}],combat = 49440,is_tv = 0};

get_lv_cfg(413) ->
	#pet_lv_cfg{lv = 413,max_exp = 551863,attr = [{1,1648},{2,32960},{3,824},{4,824}],combat = 49560,is_tv = 0};

get_lv_cfg(414) ->
	#pet_lv_cfg{lv = 414,max_exp = 556325,attr = [{1,1652},{2,33040},{3,826},{4,826}],combat = 49680,is_tv = 0};

get_lv_cfg(415) ->
	#pet_lv_cfg{lv = 415,max_exp = 560823,attr = [{1,1656},{2,33120},{3,828},{4,828}],combat = 49800,is_tv = 0};

get_lv_cfg(416) ->
	#pet_lv_cfg{lv = 416,max_exp = 565357,attr = [{1,1660},{2,33200},{3,830},{4,830}],combat = 49920,is_tv = 0};

get_lv_cfg(417) ->
	#pet_lv_cfg{lv = 417,max_exp = 569928,attr = [{1,1664},{2,33280},{3,832},{4,832}],combat = 50040,is_tv = 0};

get_lv_cfg(418) ->
	#pet_lv_cfg{lv = 418,max_exp = 574536,attr = [{1,1668},{2,33360},{3,834},{4,834}],combat = 50160,is_tv = 0};

get_lv_cfg(419) ->
	#pet_lv_cfg{lv = 419,max_exp = 579181,attr = [{1,1672},{2,33440},{3,836},{4,836}],combat = 50280,is_tv = 0};

get_lv_cfg(420) ->
	#pet_lv_cfg{lv = 420,max_exp = 583864,attr = [{1,1676},{2,33520},{3,838},{4,838}],combat = 50400,is_tv = 0};

get_lv_cfg(421) ->
	#pet_lv_cfg{lv = 421,max_exp = 588585,attr = [{1,1680},{2,33600},{3,840},{4,840}],combat = 50520,is_tv = 0};

get_lv_cfg(422) ->
	#pet_lv_cfg{lv = 422,max_exp = 593344,attr = [{1,1684},{2,33680},{3,842},{4,842}],combat = 50640,is_tv = 0};

get_lv_cfg(423) ->
	#pet_lv_cfg{lv = 423,max_exp = 598141,attr = [{1,1688},{2,33760},{3,844},{4,844}],combat = 50760,is_tv = 0};

get_lv_cfg(424) ->
	#pet_lv_cfg{lv = 424,max_exp = 602977,attr = [{1,1692},{2,33840},{3,846},{4,846}],combat = 50880,is_tv = 0};

get_lv_cfg(425) ->
	#pet_lv_cfg{lv = 425,max_exp = 607852,attr = [{1,1696},{2,33920},{3,848},{4,848}],combat = 51000,is_tv = 0};

get_lv_cfg(426) ->
	#pet_lv_cfg{lv = 426,max_exp = 612766,attr = [{1,1700},{2,34000},{3,850},{4,850}],combat = 51120,is_tv = 0};

get_lv_cfg(427) ->
	#pet_lv_cfg{lv = 427,max_exp = 617720,attr = [{1,1704},{2,34080},{3,852},{4,852}],combat = 51240,is_tv = 0};

get_lv_cfg(428) ->
	#pet_lv_cfg{lv = 428,max_exp = 622714,attr = [{1,1708},{2,34160},{3,854},{4,854}],combat = 51360,is_tv = 0};

get_lv_cfg(429) ->
	#pet_lv_cfg{lv = 429,max_exp = 627749,attr = [{1,1712},{2,34240},{3,856},{4,856}],combat = 51480,is_tv = 0};

get_lv_cfg(430) ->
	#pet_lv_cfg{lv = 430,max_exp = 632824,attr = [{1,1716},{2,34320},{3,858},{4,858}],combat = 51600,is_tv = 0};

get_lv_cfg(431) ->
	#pet_lv_cfg{lv = 431,max_exp = 637940,attr = [{1,1720},{2,34400},{3,860},{4,860}],combat = 51720,is_tv = 0};

get_lv_cfg(432) ->
	#pet_lv_cfg{lv = 432,max_exp = 643098,attr = [{1,1724},{2,34480},{3,862},{4,862}],combat = 51840,is_tv = 0};

get_lv_cfg(433) ->
	#pet_lv_cfg{lv = 433,max_exp = 648297,attr = [{1,1728},{2,34560},{3,864},{4,864}],combat = 51960,is_tv = 0};

get_lv_cfg(434) ->
	#pet_lv_cfg{lv = 434,max_exp = 653538,attr = [{1,1732},{2,34640},{3,866},{4,866}],combat = 52080,is_tv = 0};

get_lv_cfg(435) ->
	#pet_lv_cfg{lv = 435,max_exp = 658822,attr = [{1,1736},{2,34720},{3,868},{4,868}],combat = 52200,is_tv = 0};

get_lv_cfg(436) ->
	#pet_lv_cfg{lv = 436,max_exp = 664149,attr = [{1,1740},{2,34800},{3,870},{4,870}],combat = 52320,is_tv = 0};

get_lv_cfg(437) ->
	#pet_lv_cfg{lv = 437,max_exp = 669519,attr = [{1,1744},{2,34880},{3,872},{4,872}],combat = 52440,is_tv = 0};

get_lv_cfg(438) ->
	#pet_lv_cfg{lv = 438,max_exp = 674932,attr = [{1,1748},{2,34960},{3,874},{4,874}],combat = 52560,is_tv = 0};

get_lv_cfg(439) ->
	#pet_lv_cfg{lv = 439,max_exp = 680389,attr = [{1,1752},{2,35040},{3,876},{4,876}],combat = 52680,is_tv = 0};

get_lv_cfg(440) ->
	#pet_lv_cfg{lv = 440,max_exp = 685890,attr = [{1,1756},{2,35120},{3,878},{4,878}],combat = 52800,is_tv = 0};

get_lv_cfg(441) ->
	#pet_lv_cfg{lv = 441,max_exp = 691435,attr = [{1,1760},{2,35200},{3,880},{4,880}],combat = 52920,is_tv = 0};

get_lv_cfg(442) ->
	#pet_lv_cfg{lv = 442,max_exp = 697025,attr = [{1,1764},{2,35280},{3,882},{4,882}],combat = 53040,is_tv = 0};

get_lv_cfg(443) ->
	#pet_lv_cfg{lv = 443,max_exp = 702660,attr = [{1,1768},{2,35360},{3,884},{4,884}],combat = 53160,is_tv = 0};

get_lv_cfg(444) ->
	#pet_lv_cfg{lv = 444,max_exp = 708341,attr = [{1,1772},{2,35440},{3,886},{4,886}],combat = 53280,is_tv = 0};

get_lv_cfg(445) ->
	#pet_lv_cfg{lv = 445,max_exp = 714068,attr = [{1,1776},{2,35520},{3,888},{4,888}],combat = 53400,is_tv = 0};

get_lv_cfg(446) ->
	#pet_lv_cfg{lv = 446,max_exp = 719841,attr = [{1,1780},{2,35600},{3,890},{4,890}],combat = 53520,is_tv = 0};

get_lv_cfg(447) ->
	#pet_lv_cfg{lv = 447,max_exp = 725661,attr = [{1,1784},{2,35680},{3,892},{4,892}],combat = 53640,is_tv = 0};

get_lv_cfg(448) ->
	#pet_lv_cfg{lv = 448,max_exp = 731528,attr = [{1,1788},{2,35760},{3,894},{4,894}],combat = 53760,is_tv = 0};

get_lv_cfg(449) ->
	#pet_lv_cfg{lv = 449,max_exp = 737442,attr = [{1,1792},{2,35840},{3,896},{4,896}],combat = 53880,is_tv = 0};

get_lv_cfg(450) ->
	#pet_lv_cfg{lv = 450,max_exp = 743404,attr = [{1,1796},{2,35920},{3,898},{4,898}],combat = 54000,is_tv = 1};

get_lv_cfg(451) ->
	#pet_lv_cfg{lv = 451,max_exp = 749414,attr = [{1,1800},{2,36000},{3,900},{4,900}],combat = 54120,is_tv = 0};

get_lv_cfg(452) ->
	#pet_lv_cfg{lv = 452,max_exp = 755473,attr = [{1,1804},{2,36080},{3,902},{4,902}],combat = 54240,is_tv = 0};

get_lv_cfg(453) ->
	#pet_lv_cfg{lv = 453,max_exp = 761581,attr = [{1,1808},{2,36160},{3,904},{4,904}],combat = 54360,is_tv = 0};

get_lv_cfg(454) ->
	#pet_lv_cfg{lv = 454,max_exp = 767738,attr = [{1,1812},{2,36240},{3,906},{4,906}],combat = 54480,is_tv = 0};

get_lv_cfg(455) ->
	#pet_lv_cfg{lv = 455,max_exp = 773945,attr = [{1,1816},{2,36320},{3,908},{4,908}],combat = 54600,is_tv = 0};

get_lv_cfg(456) ->
	#pet_lv_cfg{lv = 456,max_exp = 780202,attr = [{1,1820},{2,36400},{3,910},{4,910}],combat = 54720,is_tv = 0};

get_lv_cfg(457) ->
	#pet_lv_cfg{lv = 457,max_exp = 786510,attr = [{1,1824},{2,36480},{3,912},{4,912}],combat = 54840,is_tv = 0};

get_lv_cfg(458) ->
	#pet_lv_cfg{lv = 458,max_exp = 792869,attr = [{1,1828},{2,36560},{3,914},{4,914}],combat = 54960,is_tv = 0};

get_lv_cfg(459) ->
	#pet_lv_cfg{lv = 459,max_exp = 799279,attr = [{1,1832},{2,36640},{3,916},{4,916}],combat = 55080,is_tv = 0};

get_lv_cfg(460) ->
	#pet_lv_cfg{lv = 460,max_exp = 805741,attr = [{1,1836},{2,36720},{3,918},{4,918}],combat = 55200,is_tv = 0};

get_lv_cfg(461) ->
	#pet_lv_cfg{lv = 461,max_exp = 812255,attr = [{1,1840},{2,36800},{3,920},{4,920}],combat = 55320,is_tv = 0};

get_lv_cfg(462) ->
	#pet_lv_cfg{lv = 462,max_exp = 818822,attr = [{1,1844},{2,36880},{3,922},{4,922}],combat = 55440,is_tv = 0};

get_lv_cfg(463) ->
	#pet_lv_cfg{lv = 463,max_exp = 825442,attr = [{1,1848},{2,36960},{3,924},{4,924}],combat = 55560,is_tv = 0};

get_lv_cfg(464) ->
	#pet_lv_cfg{lv = 464,max_exp = 832116,attr = [{1,1852},{2,37040},{3,926},{4,926}],combat = 55680,is_tv = 0};

get_lv_cfg(465) ->
	#pet_lv_cfg{lv = 465,max_exp = 838844,attr = [{1,1856},{2,37120},{3,928},{4,928}],combat = 55800,is_tv = 0};

get_lv_cfg(466) ->
	#pet_lv_cfg{lv = 466,max_exp = 845626,attr = [{1,1860},{2,37200},{3,930},{4,930}],combat = 55920,is_tv = 0};

get_lv_cfg(467) ->
	#pet_lv_cfg{lv = 467,max_exp = 852463,attr = [{1,1864},{2,37280},{3,932},{4,932}],combat = 56040,is_tv = 0};

get_lv_cfg(468) ->
	#pet_lv_cfg{lv = 468,max_exp = 859355,attr = [{1,1868},{2,37360},{3,934},{4,934}],combat = 56160,is_tv = 0};

get_lv_cfg(469) ->
	#pet_lv_cfg{lv = 469,max_exp = 866303,attr = [{1,1872},{2,37440},{3,936},{4,936}],combat = 56280,is_tv = 0};

get_lv_cfg(470) ->
	#pet_lv_cfg{lv = 470,max_exp = 873307,attr = [{1,1876},{2,37520},{3,938},{4,938}],combat = 56400,is_tv = 0};

get_lv_cfg(471) ->
	#pet_lv_cfg{lv = 471,max_exp = 880368,attr = [{1,1880},{2,37600},{3,940},{4,940}],combat = 56520,is_tv = 0};

get_lv_cfg(472) ->
	#pet_lv_cfg{lv = 472,max_exp = 887486,attr = [{1,1884},{2,37680},{3,942},{4,942}],combat = 56640,is_tv = 0};

get_lv_cfg(473) ->
	#pet_lv_cfg{lv = 473,max_exp = 894661,attr = [{1,1888},{2,37760},{3,944},{4,944}],combat = 56760,is_tv = 0};

get_lv_cfg(474) ->
	#pet_lv_cfg{lv = 474,max_exp = 901894,attr = [{1,1892},{2,37840},{3,946},{4,946}],combat = 56880,is_tv = 0};

get_lv_cfg(475) ->
	#pet_lv_cfg{lv = 475,max_exp = 909186,attr = [{1,1896},{2,37920},{3,948},{4,948}],combat = 57000,is_tv = 0};

get_lv_cfg(476) ->
	#pet_lv_cfg{lv = 476,max_exp = 916537,attr = [{1,1900},{2,38000},{3,950},{4,950}],combat = 57120,is_tv = 0};

get_lv_cfg(477) ->
	#pet_lv_cfg{lv = 477,max_exp = 923947,attr = [{1,1904},{2,38080},{3,952},{4,952}],combat = 57240,is_tv = 0};

get_lv_cfg(478) ->
	#pet_lv_cfg{lv = 478,max_exp = 931417,attr = [{1,1908},{2,38160},{3,954},{4,954}],combat = 57360,is_tv = 0};

get_lv_cfg(479) ->
	#pet_lv_cfg{lv = 479,max_exp = 938948,attr = [{1,1912},{2,38240},{3,956},{4,956}],combat = 57480,is_tv = 0};

get_lv_cfg(480) ->
	#pet_lv_cfg{lv = 480,max_exp = 946539,attr = [{1,1916},{2,38320},{3,958},{4,958}],combat = 57600,is_tv = 0};

get_lv_cfg(481) ->
	#pet_lv_cfg{lv = 481,max_exp = 954192,attr = [{1,1920},{2,38400},{3,960},{4,960}],combat = 57720,is_tv = 0};

get_lv_cfg(482) ->
	#pet_lv_cfg{lv = 482,max_exp = 961907,attr = [{1,1924},{2,38480},{3,962},{4,962}],combat = 57840,is_tv = 0};

get_lv_cfg(483) ->
	#pet_lv_cfg{lv = 483,max_exp = 969684,attr = [{1,1928},{2,38560},{3,964},{4,964}],combat = 57960,is_tv = 0};

get_lv_cfg(484) ->
	#pet_lv_cfg{lv = 484,max_exp = 977524,attr = [{1,1932},{2,38640},{3,966},{4,966}],combat = 58080,is_tv = 0};

get_lv_cfg(485) ->
	#pet_lv_cfg{lv = 485,max_exp = 985427,attr = [{1,1936},{2,38720},{3,968},{4,968}],combat = 58200,is_tv = 0};

get_lv_cfg(486) ->
	#pet_lv_cfg{lv = 486,max_exp = 993394,attr = [{1,1940},{2,38800},{3,970},{4,970}],combat = 58320,is_tv = 0};

get_lv_cfg(487) ->
	#pet_lv_cfg{lv = 487,max_exp = 1001426,attr = [{1,1944},{2,38880},{3,972},{4,972}],combat = 58440,is_tv = 0};

get_lv_cfg(488) ->
	#pet_lv_cfg{lv = 488,max_exp = 1009523,attr = [{1,1948},{2,38960},{3,974},{4,974}],combat = 58560,is_tv = 0};

get_lv_cfg(489) ->
	#pet_lv_cfg{lv = 489,max_exp = 1017685,attr = [{1,1952},{2,39040},{3,976},{4,976}],combat = 58680,is_tv = 0};

get_lv_cfg(490) ->
	#pet_lv_cfg{lv = 490,max_exp = 1025913,attr = [{1,1956},{2,39120},{3,978},{4,978}],combat = 58800,is_tv = 0};

get_lv_cfg(491) ->
	#pet_lv_cfg{lv = 491,max_exp = 1034208,attr = [{1,1960},{2,39200},{3,980},{4,980}],combat = 58920,is_tv = 0};

get_lv_cfg(492) ->
	#pet_lv_cfg{lv = 492,max_exp = 1042570,attr = [{1,1964},{2,39280},{3,982},{4,982}],combat = 59040,is_tv = 0};

get_lv_cfg(493) ->
	#pet_lv_cfg{lv = 493,max_exp = 1050999,attr = [{1,1968},{2,39360},{3,984},{4,984}],combat = 59160,is_tv = 0};

get_lv_cfg(494) ->
	#pet_lv_cfg{lv = 494,max_exp = 1059496,attr = [{1,1972},{2,39440},{3,986},{4,986}],combat = 59280,is_tv = 0};

get_lv_cfg(495) ->
	#pet_lv_cfg{lv = 495,max_exp = 1068062,attr = [{1,1976},{2,39520},{3,988},{4,988}],combat = 59400,is_tv = 0};

get_lv_cfg(496) ->
	#pet_lv_cfg{lv = 496,max_exp = 1076697,attr = [{1,1980},{2,39600},{3,990},{4,990}],combat = 59520,is_tv = 0};

get_lv_cfg(497) ->
	#pet_lv_cfg{lv = 497,max_exp = 1085402,attr = [{1,1984},{2,39680},{3,992},{4,992}],combat = 59640,is_tv = 0};

get_lv_cfg(498) ->
	#pet_lv_cfg{lv = 498,max_exp = 1094177,attr = [{1,1988},{2,39760},{3,994},{4,994}],combat = 59760,is_tv = 0};

get_lv_cfg(499) ->
	#pet_lv_cfg{lv = 499,max_exp = 1103023,attr = [{1,1992},{2,39840},{3,996},{4,996}],combat = 59880,is_tv = 0};

get_lv_cfg(500) ->
	#pet_lv_cfg{lv = 500,max_exp = 1111941,attr = [{1,1996},{2,39920},{3,998},{4,998}],combat = 60000,is_tv = 1};

get_lv_cfg(501) ->
	#pet_lv_cfg{lv = 501,max_exp = 1120931,attr = [{1,2000},{2,40000},{3,1000},{4,1000}],combat = 60120,is_tv = 0};

get_lv_cfg(502) ->
	#pet_lv_cfg{lv = 502,max_exp = 1129994,attr = [{1,2004},{2,40080},{3,1002},{4,1002}],combat = 60240,is_tv = 0};

get_lv_cfg(503) ->
	#pet_lv_cfg{lv = 503,max_exp = 1139130,attr = [{1,2008},{2,40160},{3,1004},{4,1004}],combat = 60360,is_tv = 0};

get_lv_cfg(504) ->
	#pet_lv_cfg{lv = 504,max_exp = 1148340,attr = [{1,2012},{2,40240},{3,1006},{4,1006}],combat = 60480,is_tv = 0};

get_lv_cfg(505) ->
	#pet_lv_cfg{lv = 505,max_exp = 1157624,attr = [{1,2016},{2,40320},{3,1008},{4,1008}],combat = 60600,is_tv = 0};

get_lv_cfg(506) ->
	#pet_lv_cfg{lv = 506,max_exp = 1166983,attr = [{1,2020},{2,40400},{3,1010},{4,1010}],combat = 60720,is_tv = 0};

get_lv_cfg(507) ->
	#pet_lv_cfg{lv = 507,max_exp = 1176418,attr = [{1,2024},{2,40480},{3,1012},{4,1012}],combat = 60840,is_tv = 0};

get_lv_cfg(508) ->
	#pet_lv_cfg{lv = 508,max_exp = 1185929,attr = [{1,2028},{2,40560},{3,1014},{4,1014}],combat = 60960,is_tv = 0};

get_lv_cfg(509) ->
	#pet_lv_cfg{lv = 509,max_exp = 1195517,attr = [{1,2032},{2,40640},{3,1016},{4,1016}],combat = 61080,is_tv = 0};

get_lv_cfg(510) ->
	#pet_lv_cfg{lv = 510,max_exp = 1205183,attr = [{1,2036},{2,40720},{3,1018},{4,1018}],combat = 61200,is_tv = 0};

get_lv_cfg(511) ->
	#pet_lv_cfg{lv = 511,max_exp = 1214927,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],combat = 61320,is_tv = 0};

get_lv_cfg(512) ->
	#pet_lv_cfg{lv = 512,max_exp = 1224750,attr = [{1,2044},{2,40880},{3,1022},{4,1022}],combat = 61440,is_tv = 0};

get_lv_cfg(513) ->
	#pet_lv_cfg{lv = 513,max_exp = 1234652,attr = [{1,2048},{2,40960},{3,1024},{4,1024}],combat = 61560,is_tv = 0};

get_lv_cfg(514) ->
	#pet_lv_cfg{lv = 514,max_exp = 1244634,attr = [{1,2052},{2,41040},{3,1026},{4,1026}],combat = 61680,is_tv = 0};

get_lv_cfg(515) ->
	#pet_lv_cfg{lv = 515,max_exp = 1254697,attr = [{1,2056},{2,41120},{3,1028},{4,1028}],combat = 61800,is_tv = 0};

get_lv_cfg(516) ->
	#pet_lv_cfg{lv = 516,max_exp = 1264841,attr = [{1,2060},{2,41200},{3,1030},{4,1030}],combat = 61920,is_tv = 0};

get_lv_cfg(517) ->
	#pet_lv_cfg{lv = 517,max_exp = 1275067,attr = [{1,2064},{2,41280},{3,1032},{4,1032}],combat = 62040,is_tv = 0};

get_lv_cfg(518) ->
	#pet_lv_cfg{lv = 518,max_exp = 1285376,attr = [{1,2068},{2,41360},{3,1034},{4,1034}],combat = 62160,is_tv = 0};

get_lv_cfg(519) ->
	#pet_lv_cfg{lv = 519,max_exp = 1295768,attr = [{1,2072},{2,41440},{3,1036},{4,1036}],combat = 62280,is_tv = 0};

get_lv_cfg(520) ->
	#pet_lv_cfg{lv = 520,max_exp = 1306244,attr = [{1,2076},{2,41520},{3,1038},{4,1038}],combat = 62400,is_tv = 0};

get_lv_cfg(521) ->
	#pet_lv_cfg{lv = 521,max_exp = 1316805,attr = [{1,2080},{2,41600},{3,1040},{4,1040}],combat = 62520,is_tv = 0};

get_lv_cfg(522) ->
	#pet_lv_cfg{lv = 522,max_exp = 1327451,attr = [{1,2084},{2,41680},{3,1042},{4,1042}],combat = 62640,is_tv = 0};

get_lv_cfg(523) ->
	#pet_lv_cfg{lv = 523,max_exp = 1338183,attr = [{1,2088},{2,41760},{3,1044},{4,1044}],combat = 62760,is_tv = 0};

get_lv_cfg(524) ->
	#pet_lv_cfg{lv = 524,max_exp = 1349002,attr = [{1,2092},{2,41840},{3,1046},{4,1046}],combat = 62880,is_tv = 0};

get_lv_cfg(525) ->
	#pet_lv_cfg{lv = 525,max_exp = 1359909,attr = [{1,2096},{2,41920},{3,1048},{4,1048}],combat = 63000,is_tv = 0};

get_lv_cfg(526) ->
	#pet_lv_cfg{lv = 526,max_exp = 1370904,attr = [{1,2100},{2,42000},{3,1050},{4,1050}],combat = 63120,is_tv = 0};

get_lv_cfg(527) ->
	#pet_lv_cfg{lv = 527,max_exp = 1381988,attr = [{1,2104},{2,42080},{3,1052},{4,1052}],combat = 63240,is_tv = 0};

get_lv_cfg(528) ->
	#pet_lv_cfg{lv = 528,max_exp = 1393161,attr = [{1,2108},{2,42160},{3,1054},{4,1054}],combat = 63360,is_tv = 0};

get_lv_cfg(529) ->
	#pet_lv_cfg{lv = 529,max_exp = 1404425,attr = [{1,2112},{2,42240},{3,1056},{4,1056}],combat = 63480,is_tv = 0};

get_lv_cfg(530) ->
	#pet_lv_cfg{lv = 530,max_exp = 1415780,attr = [{1,2116},{2,42320},{3,1058},{4,1058}],combat = 63600,is_tv = 0};

get_lv_cfg(531) ->
	#pet_lv_cfg{lv = 531,max_exp = 1427227,attr = [{1,2120},{2,42400},{3,1060},{4,1060}],combat = 63720,is_tv = 0};

get_lv_cfg(532) ->
	#pet_lv_cfg{lv = 532,max_exp = 1438766,attr = [{1,2124},{2,42480},{3,1062},{4,1062}],combat = 63840,is_tv = 0};

get_lv_cfg(533) ->
	#pet_lv_cfg{lv = 533,max_exp = 1450398,attr = [{1,2128},{2,42560},{3,1064},{4,1064}],combat = 63960,is_tv = 0};

get_lv_cfg(534) ->
	#pet_lv_cfg{lv = 534,max_exp = 1462124,attr = [{1,2132},{2,42640},{3,1066},{4,1066}],combat = 64080,is_tv = 0};

get_lv_cfg(535) ->
	#pet_lv_cfg{lv = 535,max_exp = 1473945,attr = [{1,2136},{2,42720},{3,1068},{4,1068}],combat = 64200,is_tv = 0};

get_lv_cfg(536) ->
	#pet_lv_cfg{lv = 536,max_exp = 1485862,attr = [{1,2140},{2,42800},{3,1070},{4,1070}],combat = 64320,is_tv = 0};

get_lv_cfg(537) ->
	#pet_lv_cfg{lv = 537,max_exp = 1497875,attr = [{1,2144},{2,42880},{3,1072},{4,1072}],combat = 64440,is_tv = 0};

get_lv_cfg(538) ->
	#pet_lv_cfg{lv = 538,max_exp = 1509985,attr = [{1,2148},{2,42960},{3,1074},{4,1074}],combat = 64560,is_tv = 0};

get_lv_cfg(539) ->
	#pet_lv_cfg{lv = 539,max_exp = 1522193,attr = [{1,2152},{2,43040},{3,1076},{4,1076}],combat = 64680,is_tv = 0};

get_lv_cfg(540) ->
	#pet_lv_cfg{lv = 540,max_exp = 1534500,attr = [{1,2156},{2,43120},{3,1078},{4,1078}],combat = 64800,is_tv = 0};

get_lv_cfg(541) ->
	#pet_lv_cfg{lv = 541,max_exp = 1546906,attr = [{1,2160},{2,43200},{3,1080},{4,1080}],combat = 64920,is_tv = 0};

get_lv_cfg(542) ->
	#pet_lv_cfg{lv = 542,max_exp = 1559413,attr = [{1,2164},{2,43280},{3,1082},{4,1082}],combat = 65040,is_tv = 0};

get_lv_cfg(543) ->
	#pet_lv_cfg{lv = 543,max_exp = 1572021,attr = [{1,2168},{2,43360},{3,1084},{4,1084}],combat = 65160,is_tv = 0};

get_lv_cfg(544) ->
	#pet_lv_cfg{lv = 544,max_exp = 1584731,attr = [{1,2172},{2,43440},{3,1086},{4,1086}],combat = 65280,is_tv = 0};

get_lv_cfg(545) ->
	#pet_lv_cfg{lv = 545,max_exp = 1597544,attr = [{1,2176},{2,43520},{3,1088},{4,1088}],combat = 65400,is_tv = 0};

get_lv_cfg(546) ->
	#pet_lv_cfg{lv = 546,max_exp = 1610460,attr = [{1,2180},{2,43600},{3,1090},{4,1090}],combat = 65520,is_tv = 0};

get_lv_cfg(547) ->
	#pet_lv_cfg{lv = 547,max_exp = 1623481,attr = [{1,2184},{2,43680},{3,1092},{4,1092}],combat = 65640,is_tv = 0};

get_lv_cfg(548) ->
	#pet_lv_cfg{lv = 548,max_exp = 1636607,attr = [{1,2188},{2,43760},{3,1094},{4,1094}],combat = 65760,is_tv = 0};

get_lv_cfg(549) ->
	#pet_lv_cfg{lv = 549,max_exp = 1649839,attr = [{1,2192},{2,43840},{3,1096},{4,1096}],combat = 65880,is_tv = 0};

get_lv_cfg(550) ->
	#pet_lv_cfg{lv = 550,max_exp = 1663178,attr = [{1,2196},{2,43920},{3,1098},{4,1098}],combat = 66000,is_tv = 1};

get_lv_cfg(551) ->
	#pet_lv_cfg{lv = 551,max_exp = 1676625,attr = [{1,2200},{2,44000},{3,1100},{4,1100}],combat = 66120,is_tv = 0};

get_lv_cfg(552) ->
	#pet_lv_cfg{lv = 552,max_exp = 1690181,attr = [{1,2204},{2,44080},{3,1102},{4,1102}],combat = 66240,is_tv = 0};

get_lv_cfg(553) ->
	#pet_lv_cfg{lv = 553,max_exp = 1703846,attr = [{1,2208},{2,44160},{3,1104},{4,1104}],combat = 66360,is_tv = 0};

get_lv_cfg(554) ->
	#pet_lv_cfg{lv = 554,max_exp = 1717622,attr = [{1,2212},{2,44240},{3,1106},{4,1106}],combat = 66480,is_tv = 0};

get_lv_cfg(555) ->
	#pet_lv_cfg{lv = 555,max_exp = 1731509,attr = [{1,2216},{2,44320},{3,1108},{4,1108}],combat = 66600,is_tv = 0};

get_lv_cfg(556) ->
	#pet_lv_cfg{lv = 556,max_exp = 1745508,attr = [{1,2220},{2,44400},{3,1110},{4,1110}],combat = 66720,is_tv = 0};

get_lv_cfg(557) ->
	#pet_lv_cfg{lv = 557,max_exp = 1759620,attr = [{1,2224},{2,44480},{3,1112},{4,1112}],combat = 66840,is_tv = 0};

get_lv_cfg(558) ->
	#pet_lv_cfg{lv = 558,max_exp = 1773847,attr = [{1,2228},{2,44560},{3,1114},{4,1114}],combat = 66960,is_tv = 0};

get_lv_cfg(559) ->
	#pet_lv_cfg{lv = 559,max_exp = 1788189,attr = [{1,2232},{2,44640},{3,1116},{4,1116}],combat = 67080,is_tv = 0};

get_lv_cfg(560) ->
	#pet_lv_cfg{lv = 560,max_exp = 1802647,attr = [{1,2236},{2,44720},{3,1118},{4,1118}],combat = 67200,is_tv = 0};

get_lv_cfg(561) ->
	#pet_lv_cfg{lv = 561,max_exp = 1817221,attr = [{1,2240},{2,44800},{3,1120},{4,1120}],combat = 67320,is_tv = 0};

get_lv_cfg(562) ->
	#pet_lv_cfg{lv = 562,max_exp = 1831913,attr = [{1,2244},{2,44880},{3,1122},{4,1122}],combat = 67440,is_tv = 0};

get_lv_cfg(563) ->
	#pet_lv_cfg{lv = 563,max_exp = 1846724,attr = [{1,2248},{2,44960},{3,1124},{4,1124}],combat = 67560,is_tv = 0};

get_lv_cfg(564) ->
	#pet_lv_cfg{lv = 564,max_exp = 1861655,attr = [{1,2252},{2,45040},{3,1126},{4,1126}],combat = 67680,is_tv = 0};

get_lv_cfg(565) ->
	#pet_lv_cfg{lv = 565,max_exp = 1876706,attr = [{1,2256},{2,45120},{3,1128},{4,1128}],combat = 67800,is_tv = 0};

get_lv_cfg(566) ->
	#pet_lv_cfg{lv = 566,max_exp = 1891879,attr = [{1,2260},{2,45200},{3,1130},{4,1130}],combat = 67920,is_tv = 0};

get_lv_cfg(567) ->
	#pet_lv_cfg{lv = 567,max_exp = 1907175,attr = [{1,2264},{2,45280},{3,1132},{4,1132}],combat = 68040,is_tv = 0};

get_lv_cfg(568) ->
	#pet_lv_cfg{lv = 568,max_exp = 1922595,attr = [{1,2268},{2,45360},{3,1134},{4,1134}],combat = 68160,is_tv = 0};

get_lv_cfg(569) ->
	#pet_lv_cfg{lv = 569,max_exp = 1938139,attr = [{1,2272},{2,45440},{3,1136},{4,1136}],combat = 68280,is_tv = 0};

get_lv_cfg(570) ->
	#pet_lv_cfg{lv = 570,max_exp = 1953809,attr = [{1,2276},{2,45520},{3,1138},{4,1138}],combat = 68400,is_tv = 0};

get_lv_cfg(571) ->
	#pet_lv_cfg{lv = 571,max_exp = 1969606,attr = [{1,2280},{2,45600},{3,1140},{4,1140}],combat = 68520,is_tv = 0};

get_lv_cfg(572) ->
	#pet_lv_cfg{lv = 572,max_exp = 1985530,attr = [{1,2284},{2,45680},{3,1142},{4,1142}],combat = 68640,is_tv = 0};

get_lv_cfg(573) ->
	#pet_lv_cfg{lv = 573,max_exp = 2001583,attr = [{1,2288},{2,45760},{3,1144},{4,1144}],combat = 68760,is_tv = 0};

get_lv_cfg(574) ->
	#pet_lv_cfg{lv = 574,max_exp = 2017766,attr = [{1,2292},{2,45840},{3,1146},{4,1146}],combat = 68880,is_tv = 0};

get_lv_cfg(575) ->
	#pet_lv_cfg{lv = 575,max_exp = 2034080,attr = [{1,2296},{2,45920},{3,1148},{4,1148}],combat = 69000,is_tv = 0};

get_lv_cfg(576) ->
	#pet_lv_cfg{lv = 576,max_exp = 2050526,attr = [{1,2300},{2,46000},{3,1150},{4,1150}],combat = 69120,is_tv = 0};

get_lv_cfg(577) ->
	#pet_lv_cfg{lv = 577,max_exp = 2067105,attr = [{1,2304},{2,46080},{3,1152},{4,1152}],combat = 69240,is_tv = 0};

get_lv_cfg(578) ->
	#pet_lv_cfg{lv = 578,max_exp = 2083818,attr = [{1,2308},{2,46160},{3,1154},{4,1154}],combat = 69360,is_tv = 0};

get_lv_cfg(579) ->
	#pet_lv_cfg{lv = 579,max_exp = 2100666,attr = [{1,2312},{2,46240},{3,1156},{4,1156}],combat = 69480,is_tv = 0};

get_lv_cfg(580) ->
	#pet_lv_cfg{lv = 580,max_exp = 2117650,attr = [{1,2316},{2,46320},{3,1158},{4,1158}],combat = 69600,is_tv = 0};

get_lv_cfg(581) ->
	#pet_lv_cfg{lv = 581,max_exp = 2134771,attr = [{1,2320},{2,46400},{3,1160},{4,1160}],combat = 69720,is_tv = 0};

get_lv_cfg(582) ->
	#pet_lv_cfg{lv = 582,max_exp = 2152031,attr = [{1,2324},{2,46480},{3,1162},{4,1162}],combat = 69840,is_tv = 0};

get_lv_cfg(583) ->
	#pet_lv_cfg{lv = 583,max_exp = 2169430,attr = [{1,2328},{2,46560},{3,1164},{4,1164}],combat = 69960,is_tv = 0};

get_lv_cfg(584) ->
	#pet_lv_cfg{lv = 584,max_exp = 2186970,attr = [{1,2332},{2,46640},{3,1166},{4,1166}],combat = 70080,is_tv = 0};

get_lv_cfg(585) ->
	#pet_lv_cfg{lv = 585,max_exp = 2204652,attr = [{1,2336},{2,46720},{3,1168},{4,1168}],combat = 70200,is_tv = 0};

get_lv_cfg(586) ->
	#pet_lv_cfg{lv = 586,max_exp = 2222477,attr = [{1,2340},{2,46800},{3,1170},{4,1170}],combat = 70320,is_tv = 0};

get_lv_cfg(587) ->
	#pet_lv_cfg{lv = 587,max_exp = 2240446,attr = [{1,2344},{2,46880},{3,1172},{4,1172}],combat = 70440,is_tv = 0};

get_lv_cfg(588) ->
	#pet_lv_cfg{lv = 588,max_exp = 2258560,attr = [{1,2348},{2,46960},{3,1174},{4,1174}],combat = 70560,is_tv = 0};

get_lv_cfg(589) ->
	#pet_lv_cfg{lv = 589,max_exp = 2276820,attr = [{1,2352},{2,47040},{3,1176},{4,1176}],combat = 70680,is_tv = 0};

get_lv_cfg(590) ->
	#pet_lv_cfg{lv = 590,max_exp = 2295228,attr = [{1,2356},{2,47120},{3,1178},{4,1178}],combat = 70800,is_tv = 0};

get_lv_cfg(591) ->
	#pet_lv_cfg{lv = 591,max_exp = 2313785,attr = [{1,2360},{2,47200},{3,1180},{4,1180}],combat = 70920,is_tv = 0};

get_lv_cfg(592) ->
	#pet_lv_cfg{lv = 592,max_exp = 2332492,attr = [{1,2364},{2,47280},{3,1182},{4,1182}],combat = 71040,is_tv = 0};

get_lv_cfg(593) ->
	#pet_lv_cfg{lv = 593,max_exp = 2351350,attr = [{1,2368},{2,47360},{3,1184},{4,1184}],combat = 71160,is_tv = 0};

get_lv_cfg(594) ->
	#pet_lv_cfg{lv = 594,max_exp = 2370361,attr = [{1,2372},{2,47440},{3,1186},{4,1186}],combat = 71280,is_tv = 0};

get_lv_cfg(595) ->
	#pet_lv_cfg{lv = 595,max_exp = 2389525,attr = [{1,2376},{2,47520},{3,1188},{4,1188}],combat = 71400,is_tv = 0};

get_lv_cfg(596) ->
	#pet_lv_cfg{lv = 596,max_exp = 2408844,attr = [{1,2380},{2,47600},{3,1190},{4,1190}],combat = 71520,is_tv = 0};

get_lv_cfg(597) ->
	#pet_lv_cfg{lv = 597,max_exp = 2428320,attr = [{1,2384},{2,47680},{3,1192},{4,1192}],combat = 71640,is_tv = 0};

get_lv_cfg(598) ->
	#pet_lv_cfg{lv = 598,max_exp = 2447953,attr = [{1,2388},{2,47760},{3,1194},{4,1194}],combat = 71760,is_tv = 0};

get_lv_cfg(599) ->
	#pet_lv_cfg{lv = 599,max_exp = 2467745,attr = [{1,2392},{2,47840},{3,1196},{4,1196}],combat = 71880,is_tv = 0};

get_lv_cfg(600) ->
	#pet_lv_cfg{lv = 600,max_exp = 2487697,attr = [{1,2396},{2,47920},{3,1198},{4,1198}],combat = 72000,is_tv = 1};

get_lv_cfg(601) ->
	#pet_lv_cfg{lv = 601,max_exp = 2507810,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],combat = 72120,is_tv = 0};

get_lv_cfg(602) ->
	#pet_lv_cfg{lv = 602,max_exp = 2528086,attr = [{1,2404},{2,48080},{3,1202},{4,1202}],combat = 72240,is_tv = 0};

get_lv_cfg(603) ->
	#pet_lv_cfg{lv = 603,max_exp = 2548526,attr = [{1,2408},{2,48160},{3,1204},{4,1204}],combat = 72360,is_tv = 0};

get_lv_cfg(604) ->
	#pet_lv_cfg{lv = 604,max_exp = 2569131,attr = [{1,2412},{2,48240},{3,1206},{4,1206}],combat = 72480,is_tv = 0};

get_lv_cfg(605) ->
	#pet_lv_cfg{lv = 605,max_exp = 2589902,attr = [{1,2416},{2,48320},{3,1208},{4,1208}],combat = 72600,is_tv = 0};

get_lv_cfg(606) ->
	#pet_lv_cfg{lv = 606,max_exp = 2610841,attr = [{1,2420},{2,48400},{3,1210},{4,1210}],combat = 72720,is_tv = 0};

get_lv_cfg(607) ->
	#pet_lv_cfg{lv = 607,max_exp = 2631950,attr = [{1,2424},{2,48480},{3,1212},{4,1212}],combat = 72840,is_tv = 0};

get_lv_cfg(608) ->
	#pet_lv_cfg{lv = 608,max_exp = 2653229,attr = [{1,2428},{2,48560},{3,1214},{4,1214}],combat = 72960,is_tv = 0};

get_lv_cfg(609) ->
	#pet_lv_cfg{lv = 609,max_exp = 2674680,attr = [{1,2432},{2,48640},{3,1216},{4,1216}],combat = 73080,is_tv = 0};

get_lv_cfg(610) ->
	#pet_lv_cfg{lv = 610,max_exp = 2696305,attr = [{1,2436},{2,48720},{3,1218},{4,1218}],combat = 73200,is_tv = 0};

get_lv_cfg(611) ->
	#pet_lv_cfg{lv = 611,max_exp = 2718105,attr = [{1,2440},{2,48800},{3,1220},{4,1220}],combat = 73320,is_tv = 0};

get_lv_cfg(612) ->
	#pet_lv_cfg{lv = 612,max_exp = 2740081,attr = [{1,2444},{2,48880},{3,1222},{4,1222}],combat = 73440,is_tv = 0};

get_lv_cfg(613) ->
	#pet_lv_cfg{lv = 613,max_exp = 2762235,attr = [{1,2448},{2,48960},{3,1224},{4,1224}],combat = 73560,is_tv = 0};

get_lv_cfg(614) ->
	#pet_lv_cfg{lv = 614,max_exp = 2784568,attr = [{1,2452},{2,49040},{3,1226},{4,1226}],combat = 73680,is_tv = 0};

get_lv_cfg(615) ->
	#pet_lv_cfg{lv = 615,max_exp = 2807081,attr = [{1,2456},{2,49120},{3,1228},{4,1228}],combat = 73800,is_tv = 0};

get_lv_cfg(616) ->
	#pet_lv_cfg{lv = 616,max_exp = 2829776,attr = [{1,2460},{2,49200},{3,1230},{4,1230}],combat = 73920,is_tv = 0};

get_lv_cfg(617) ->
	#pet_lv_cfg{lv = 617,max_exp = 2852655,attr = [{1,2464},{2,49280},{3,1232},{4,1232}],combat = 74040,is_tv = 0};

get_lv_cfg(618) ->
	#pet_lv_cfg{lv = 618,max_exp = 2875719,attr = [{1,2468},{2,49360},{3,1234},{4,1234}],combat = 74160,is_tv = 0};

get_lv_cfg(619) ->
	#pet_lv_cfg{lv = 619,max_exp = 2898969,attr = [{1,2472},{2,49440},{3,1236},{4,1236}],combat = 74280,is_tv = 0};

get_lv_cfg(620) ->
	#pet_lv_cfg{lv = 620,max_exp = 2922407,attr = [{1,2476},{2,49520},{3,1238},{4,1238}],combat = 74400,is_tv = 0};

get_lv_cfg(621) ->
	#pet_lv_cfg{lv = 621,max_exp = 2946035,attr = [{1,2480},{2,49600},{3,1240},{4,1240}],combat = 74520,is_tv = 0};

get_lv_cfg(622) ->
	#pet_lv_cfg{lv = 622,max_exp = 2969854,attr = [{1,2484},{2,49680},{3,1242},{4,1242}],combat = 74640,is_tv = 0};

get_lv_cfg(623) ->
	#pet_lv_cfg{lv = 623,max_exp = 2993865,attr = [{1,2488},{2,49760},{3,1244},{4,1244}],combat = 74760,is_tv = 0};

get_lv_cfg(624) ->
	#pet_lv_cfg{lv = 624,max_exp = 3018070,attr = [{1,2492},{2,49840},{3,1246},{4,1246}],combat = 74880,is_tv = 0};

get_lv_cfg(625) ->
	#pet_lv_cfg{lv = 625,max_exp = 3042471,attr = [{1,2496},{2,49920},{3,1248},{4,1248}],combat = 75000,is_tv = 0};

get_lv_cfg(626) ->
	#pet_lv_cfg{lv = 626,max_exp = 3067069,attr = [{1,2500},{2,50000},{3,1250},{4,1250}],combat = 75120,is_tv = 0};

get_lv_cfg(627) ->
	#pet_lv_cfg{lv = 627,max_exp = 3091866,attr = [{1,2504},{2,50080},{3,1252},{4,1252}],combat = 75240,is_tv = 0};

get_lv_cfg(628) ->
	#pet_lv_cfg{lv = 628,max_exp = 3116864,attr = [{1,2508},{2,50160},{3,1254},{4,1254}],combat = 75360,is_tv = 0};

get_lv_cfg(629) ->
	#pet_lv_cfg{lv = 629,max_exp = 3142064,attr = [{1,2512},{2,50240},{3,1256},{4,1256}],combat = 75480,is_tv = 0};

get_lv_cfg(630) ->
	#pet_lv_cfg{lv = 630,max_exp = 3167468,attr = [{1,2516},{2,50320},{3,1258},{4,1258}],combat = 75600,is_tv = 0};

get_lv_cfg(631) ->
	#pet_lv_cfg{lv = 631,max_exp = 3193077,attr = [{1,2520},{2,50400},{3,1260},{4,1260}],combat = 75720,is_tv = 0};

get_lv_cfg(632) ->
	#pet_lv_cfg{lv = 632,max_exp = 3218893,attr = [{1,2524},{2,50480},{3,1262},{4,1262}],combat = 75840,is_tv = 0};

get_lv_cfg(633) ->
	#pet_lv_cfg{lv = 633,max_exp = 3244918,attr = [{1,2528},{2,50560},{3,1264},{4,1264}],combat = 75960,is_tv = 0};

get_lv_cfg(634) ->
	#pet_lv_cfg{lv = 634,max_exp = 3271153,attr = [{1,2532},{2,50640},{3,1266},{4,1266}],combat = 76080,is_tv = 0};

get_lv_cfg(635) ->
	#pet_lv_cfg{lv = 635,max_exp = 3297600,attr = [{1,2536},{2,50720},{3,1268},{4,1268}],combat = 76200,is_tv = 0};

get_lv_cfg(636) ->
	#pet_lv_cfg{lv = 636,max_exp = 3324261,attr = [{1,2540},{2,50800},{3,1270},{4,1270}],combat = 76320,is_tv = 0};

get_lv_cfg(637) ->
	#pet_lv_cfg{lv = 637,max_exp = 3351138,attr = [{1,2544},{2,50880},{3,1272},{4,1272}],combat = 76440,is_tv = 0};

get_lv_cfg(638) ->
	#pet_lv_cfg{lv = 638,max_exp = 3378232,attr = [{1,2548},{2,50960},{3,1274},{4,1274}],combat = 76560,is_tv = 0};

get_lv_cfg(639) ->
	#pet_lv_cfg{lv = 639,max_exp = 3405545,attr = [{1,2552},{2,51040},{3,1276},{4,1276}],combat = 76680,is_tv = 0};

get_lv_cfg(640) ->
	#pet_lv_cfg{lv = 640,max_exp = 3433079,attr = [{1,2556},{2,51120},{3,1278},{4,1278}],combat = 76800,is_tv = 0};

get_lv_cfg(641) ->
	#pet_lv_cfg{lv = 641,max_exp = 3460835,attr = [{1,2560},{2,51200},{3,1280},{4,1280}],combat = 76920,is_tv = 0};

get_lv_cfg(642) ->
	#pet_lv_cfg{lv = 642,max_exp = 3488816,attr = [{1,2564},{2,51280},{3,1282},{4,1282}],combat = 77040,is_tv = 0};

get_lv_cfg(643) ->
	#pet_lv_cfg{lv = 643,max_exp = 3517023,attr = [{1,2568},{2,51360},{3,1284},{4,1284}],combat = 77160,is_tv = 0};

get_lv_cfg(644) ->
	#pet_lv_cfg{lv = 644,max_exp = 3545458,attr = [{1,2572},{2,51440},{3,1286},{4,1286}],combat = 77280,is_tv = 0};

get_lv_cfg(645) ->
	#pet_lv_cfg{lv = 645,max_exp = 3574123,attr = [{1,2576},{2,51520},{3,1288},{4,1288}],combat = 77400,is_tv = 0};

get_lv_cfg(646) ->
	#pet_lv_cfg{lv = 646,max_exp = 3603020,attr = [{1,2580},{2,51600},{3,1290},{4,1290}],combat = 77520,is_tv = 0};

get_lv_cfg(647) ->
	#pet_lv_cfg{lv = 647,max_exp = 3632150,attr = [{1,2584},{2,51680},{3,1292},{4,1292}],combat = 77640,is_tv = 0};

get_lv_cfg(648) ->
	#pet_lv_cfg{lv = 648,max_exp = 3661516,attr = [{1,2588},{2,51760},{3,1294},{4,1294}],combat = 77760,is_tv = 0};

get_lv_cfg(649) ->
	#pet_lv_cfg{lv = 649,max_exp = 3691119,attr = [{1,2592},{2,51840},{3,1296},{4,1296}],combat = 77880,is_tv = 0};

get_lv_cfg(650) ->
	#pet_lv_cfg{lv = 650,max_exp = 3720962,attr = [{1,2596},{2,51920},{3,1298},{4,1298}],combat = 78000,is_tv = 1};

get_lv_cfg(651) ->
	#pet_lv_cfg{lv = 651,max_exp = 3751046,attr = [{1,2600},{2,52000},{3,1300},{4,1300}],combat = 78120,is_tv = 0};

get_lv_cfg(652) ->
	#pet_lv_cfg{lv = 652,max_exp = 3781373,attr = [{1,2604},{2,52080},{3,1302},{4,1302}],combat = 78240,is_tv = 0};

get_lv_cfg(653) ->
	#pet_lv_cfg{lv = 653,max_exp = 3811945,attr = [{1,2608},{2,52160},{3,1304},{4,1304}],combat = 78360,is_tv = 0};

get_lv_cfg(654) ->
	#pet_lv_cfg{lv = 654,max_exp = 3842765,attr = [{1,2612},{2,52240},{3,1306},{4,1306}],combat = 78480,is_tv = 0};

get_lv_cfg(655) ->
	#pet_lv_cfg{lv = 655,max_exp = 3873834,attr = [{1,2616},{2,52320},{3,1308},{4,1308}],combat = 78600,is_tv = 0};

get_lv_cfg(656) ->
	#pet_lv_cfg{lv = 656,max_exp = 3905154,attr = [{1,2620},{2,52400},{3,1310},{4,1310}],combat = 78720,is_tv = 0};

get_lv_cfg(657) ->
	#pet_lv_cfg{lv = 657,max_exp = 3936727,attr = [{1,2624},{2,52480},{3,1312},{4,1312}],combat = 78840,is_tv = 0};

get_lv_cfg(658) ->
	#pet_lv_cfg{lv = 658,max_exp = 3968555,attr = [{1,2628},{2,52560},{3,1314},{4,1314}],combat = 78960,is_tv = 0};

get_lv_cfg(659) ->
	#pet_lv_cfg{lv = 659,max_exp = 4000641,attr = [{1,2632},{2,52640},{3,1316},{4,1316}],combat = 79080,is_tv = 0};

get_lv_cfg(660) ->
	#pet_lv_cfg{lv = 660,max_exp = 4032986,attr = [{1,2636},{2,52720},{3,1318},{4,1318}],combat = 79200,is_tv = 0};

get_lv_cfg(661) ->
	#pet_lv_cfg{lv = 661,max_exp = 4065593,attr = [{1,2640},{2,52800},{3,1320},{4,1320}],combat = 79320,is_tv = 0};

get_lv_cfg(662) ->
	#pet_lv_cfg{lv = 662,max_exp = 4098463,attr = [{1,2644},{2,52880},{3,1322},{4,1322}],combat = 79440,is_tv = 0};

get_lv_cfg(663) ->
	#pet_lv_cfg{lv = 663,max_exp = 4131599,attr = [{1,2648},{2,52960},{3,1324},{4,1324}],combat = 79560,is_tv = 0};

get_lv_cfg(664) ->
	#pet_lv_cfg{lv = 664,max_exp = 4165003,attr = [{1,2652},{2,53040},{3,1326},{4,1326}],combat = 79680,is_tv = 0};

get_lv_cfg(665) ->
	#pet_lv_cfg{lv = 665,max_exp = 4198677,attr = [{1,2656},{2,53120},{3,1328},{4,1328}],combat = 79800,is_tv = 0};

get_lv_cfg(666) ->
	#pet_lv_cfg{lv = 666,max_exp = 4232623,attr = [{1,2660},{2,53200},{3,1330},{4,1330}],combat = 79920,is_tv = 0};

get_lv_cfg(667) ->
	#pet_lv_cfg{lv = 667,max_exp = 4266844,attr = [{1,2664},{2,53280},{3,1332},{4,1332}],combat = 80040,is_tv = 0};

get_lv_cfg(668) ->
	#pet_lv_cfg{lv = 668,max_exp = 4301341,attr = [{1,2668},{2,53360},{3,1334},{4,1334}],combat = 80160,is_tv = 0};

get_lv_cfg(669) ->
	#pet_lv_cfg{lv = 669,max_exp = 4336117,attr = [{1,2672},{2,53440},{3,1336},{4,1336}],combat = 80280,is_tv = 0};

get_lv_cfg(670) ->
	#pet_lv_cfg{lv = 670,max_exp = 4371175,attr = [{1,2676},{2,53520},{3,1338},{4,1338}],combat = 80400,is_tv = 0};

get_lv_cfg(671) ->
	#pet_lv_cfg{lv = 671,max_exp = 4406516,attr = [{1,2680},{2,53600},{3,1340},{4,1340}],combat = 80520,is_tv = 0};

get_lv_cfg(672) ->
	#pet_lv_cfg{lv = 672,max_exp = 4442143,attr = [{1,2684},{2,53680},{3,1342},{4,1342}],combat = 80640,is_tv = 0};

get_lv_cfg(673) ->
	#pet_lv_cfg{lv = 673,max_exp = 4478058,attr = [{1,2688},{2,53760},{3,1344},{4,1344}],combat = 80760,is_tv = 0};

get_lv_cfg(674) ->
	#pet_lv_cfg{lv = 674,max_exp = 4514263,attr = [{1,2692},{2,53840},{3,1346},{4,1346}],combat = 80880,is_tv = 0};

get_lv_cfg(675) ->
	#pet_lv_cfg{lv = 675,max_exp = 4550761,attr = [{1,2696},{2,53920},{3,1348},{4,1348}],combat = 81000,is_tv = 0};

get_lv_cfg(676) ->
	#pet_lv_cfg{lv = 676,max_exp = 4587554,attr = [{1,2700},{2,54000},{3,1350},{4,1350}],combat = 81120,is_tv = 0};

get_lv_cfg(677) ->
	#pet_lv_cfg{lv = 677,max_exp = 4624644,attr = [{1,2704},{2,54080},{3,1352},{4,1352}],combat = 81240,is_tv = 0};

get_lv_cfg(678) ->
	#pet_lv_cfg{lv = 678,max_exp = 4662034,attr = [{1,2708},{2,54160},{3,1354},{4,1354}],combat = 81360,is_tv = 0};

get_lv_cfg(679) ->
	#pet_lv_cfg{lv = 679,max_exp = 4699727,attr = [{1,2712},{2,54240},{3,1356},{4,1356}],combat = 81480,is_tv = 0};

get_lv_cfg(680) ->
	#pet_lv_cfg{lv = 680,max_exp = 4737724,attr = [{1,2716},{2,54320},{3,1358},{4,1358}],combat = 81600,is_tv = 0};

get_lv_cfg(681) ->
	#pet_lv_cfg{lv = 681,max_exp = 4776028,attr = [{1,2720},{2,54400},{3,1360},{4,1360}],combat = 81720,is_tv = 0};

get_lv_cfg(682) ->
	#pet_lv_cfg{lv = 682,max_exp = 4814642,attr = [{1,2724},{2,54480},{3,1362},{4,1362}],combat = 81840,is_tv = 0};

get_lv_cfg(683) ->
	#pet_lv_cfg{lv = 683,max_exp = 4853568,attr = [{1,2728},{2,54560},{3,1364},{4,1364}],combat = 81960,is_tv = 0};

get_lv_cfg(684) ->
	#pet_lv_cfg{lv = 684,max_exp = 4892809,attr = [{1,2732},{2,54640},{3,1366},{4,1366}],combat = 82080,is_tv = 0};

get_lv_cfg(685) ->
	#pet_lv_cfg{lv = 685,max_exp = 4932367,attr = [{1,2736},{2,54720},{3,1368},{4,1368}],combat = 82200,is_tv = 0};

get_lv_cfg(686) ->
	#pet_lv_cfg{lv = 686,max_exp = 4972245,attr = [{1,2740},{2,54800},{3,1370},{4,1370}],combat = 82320,is_tv = 0};

get_lv_cfg(687) ->
	#pet_lv_cfg{lv = 687,max_exp = 5012446,attr = [{1,2744},{2,54880},{3,1372},{4,1372}],combat = 82440,is_tv = 0};

get_lv_cfg(688) ->
	#pet_lv_cfg{lv = 688,max_exp = 5052972,attr = [{1,2748},{2,54960},{3,1374},{4,1374}],combat = 82560,is_tv = 0};

get_lv_cfg(689) ->
	#pet_lv_cfg{lv = 689,max_exp = 5093825,attr = [{1,2752},{2,55040},{3,1376},{4,1376}],combat = 82680,is_tv = 0};

get_lv_cfg(690) ->
	#pet_lv_cfg{lv = 690,max_exp = 5135009,attr = [{1,2756},{2,55120},{3,1378},{4,1378}],combat = 82800,is_tv = 0};

get_lv_cfg(691) ->
	#pet_lv_cfg{lv = 691,max_exp = 5176526,attr = [{1,2760},{2,55200},{3,1380},{4,1380}],combat = 82920,is_tv = 0};

get_lv_cfg(692) ->
	#pet_lv_cfg{lv = 692,max_exp = 5218378,attr = [{1,2764},{2,55280},{3,1382},{4,1382}],combat = 83040,is_tv = 0};

get_lv_cfg(693) ->
	#pet_lv_cfg{lv = 693,max_exp = 5260569,attr = [{1,2768},{2,55360},{3,1384},{4,1384}],combat = 83160,is_tv = 0};

get_lv_cfg(694) ->
	#pet_lv_cfg{lv = 694,max_exp = 5303101,attr = [{1,2772},{2,55440},{3,1386},{4,1386}],combat = 83280,is_tv = 0};

get_lv_cfg(695) ->
	#pet_lv_cfg{lv = 695,max_exp = 5345977,attr = [{1,2776},{2,55520},{3,1388},{4,1388}],combat = 83400,is_tv = 0};

get_lv_cfg(696) ->
	#pet_lv_cfg{lv = 696,max_exp = 5389199,attr = [{1,2780},{2,55600},{3,1390},{4,1390}],combat = 83520,is_tv = 0};

get_lv_cfg(697) ->
	#pet_lv_cfg{lv = 697,max_exp = 5432771,attr = [{1,2784},{2,55680},{3,1392},{4,1392}],combat = 83640,is_tv = 0};

get_lv_cfg(698) ->
	#pet_lv_cfg{lv = 698,max_exp = 5476695,attr = [{1,2788},{2,55760},{3,1394},{4,1394}],combat = 83760,is_tv = 0};

get_lv_cfg(699) ->
	#pet_lv_cfg{lv = 699,max_exp = 5520974,attr = [{1,2792},{2,55840},{3,1396},{4,1396}],combat = 83880,is_tv = 0};

get_lv_cfg(700) ->
	#pet_lv_cfg{lv = 700,max_exp = 5565611,attr = [{1,2796},{2,55920},{3,1398},{4,1398}],combat = 84000,is_tv = 1};

get_lv_cfg(701) ->
	#pet_lv_cfg{lv = 701,max_exp = 5610609,attr = [{1,2800},{2,56000},{3,1400},{4,1400}],combat = 84120,is_tv = 0};

get_lv_cfg(702) ->
	#pet_lv_cfg{lv = 702,max_exp = 5655971,attr = [{1,2804},{2,56080},{3,1402},{4,1402}],combat = 84240,is_tv = 0};

get_lv_cfg(703) ->
	#pet_lv_cfg{lv = 703,max_exp = 5701700,attr = [{1,2808},{2,56160},{3,1404},{4,1404}],combat = 84360,is_tv = 0};

get_lv_cfg(704) ->
	#pet_lv_cfg{lv = 704,max_exp = 5747798,attr = [{1,2812},{2,56240},{3,1406},{4,1406}],combat = 84480,is_tv = 0};

get_lv_cfg(705) ->
	#pet_lv_cfg{lv = 705,max_exp = 5794269,attr = [{1,2816},{2,56320},{3,1408},{4,1408}],combat = 84600,is_tv = 0};

get_lv_cfg(706) ->
	#pet_lv_cfg{lv = 706,max_exp = 5841116,attr = [{1,2820},{2,56400},{3,1410},{4,1410}],combat = 84720,is_tv = 0};

get_lv_cfg(707) ->
	#pet_lv_cfg{lv = 707,max_exp = 5888341,attr = [{1,2824},{2,56480},{3,1412},{4,1412}],combat = 84840,is_tv = 0};

get_lv_cfg(708) ->
	#pet_lv_cfg{lv = 708,max_exp = 5935948,attr = [{1,2828},{2,56560},{3,1414},{4,1414}],combat = 84960,is_tv = 0};

get_lv_cfg(709) ->
	#pet_lv_cfg{lv = 709,max_exp = 5983940,attr = [{1,2832},{2,56640},{3,1416},{4,1416}],combat = 85080,is_tv = 0};

get_lv_cfg(710) ->
	#pet_lv_cfg{lv = 710,max_exp = 6032320,attr = [{1,2836},{2,56720},{3,1418},{4,1418}],combat = 85200,is_tv = 0};

get_lv_cfg(711) ->
	#pet_lv_cfg{lv = 711,max_exp = 6081091,attr = [{1,2840},{2,56800},{3,1420},{4,1420}],combat = 85320,is_tv = 0};

get_lv_cfg(712) ->
	#pet_lv_cfg{lv = 712,max_exp = 6130257,attr = [{1,2844},{2,56880},{3,1422},{4,1422}],combat = 85440,is_tv = 0};

get_lv_cfg(713) ->
	#pet_lv_cfg{lv = 713,max_exp = 6179820,attr = [{1,2848},{2,56960},{3,1424},{4,1424}],combat = 85560,is_tv = 0};

get_lv_cfg(714) ->
	#pet_lv_cfg{lv = 714,max_exp = 6229784,attr = [{1,2852},{2,57040},{3,1426},{4,1426}],combat = 85680,is_tv = 0};

get_lv_cfg(715) ->
	#pet_lv_cfg{lv = 715,max_exp = 6280152,attr = [{1,2856},{2,57120},{3,1428},{4,1428}],combat = 85800,is_tv = 0};

get_lv_cfg(716) ->
	#pet_lv_cfg{lv = 716,max_exp = 6330927,attr = [{1,2860},{2,57200},{3,1430},{4,1430}],combat = 85920,is_tv = 0};

get_lv_cfg(717) ->
	#pet_lv_cfg{lv = 717,max_exp = 6382113,attr = [{1,2864},{2,57280},{3,1432},{4,1432}],combat = 86040,is_tv = 0};

get_lv_cfg(718) ->
	#pet_lv_cfg{lv = 718,max_exp = 6433712,attr = [{1,2868},{2,57360},{3,1434},{4,1434}],combat = 86160,is_tv = 0};

get_lv_cfg(719) ->
	#pet_lv_cfg{lv = 719,max_exp = 6485729,attr = [{1,2872},{2,57440},{3,1436},{4,1436}],combat = 86280,is_tv = 0};

get_lv_cfg(720) ->
	#pet_lv_cfg{lv = 720,max_exp = 6538166,attr = [{1,2876},{2,57520},{3,1438},{4,1438}],combat = 86400,is_tv = 0};

get_lv_cfg(721) ->
	#pet_lv_cfg{lv = 721,max_exp = 6591027,attr = [{1,2880},{2,57600},{3,1440},{4,1440}],combat = 86520,is_tv = 0};

get_lv_cfg(722) ->
	#pet_lv_cfg{lv = 722,max_exp = 6644315,attr = [{1,2884},{2,57680},{3,1442},{4,1442}],combat = 86640,is_tv = 0};

get_lv_cfg(723) ->
	#pet_lv_cfg{lv = 723,max_exp = 6698034,attr = [{1,2888},{2,57760},{3,1444},{4,1444}],combat = 86760,is_tv = 0};

get_lv_cfg(724) ->
	#pet_lv_cfg{lv = 724,max_exp = 6752188,attr = [{1,2892},{2,57840},{3,1446},{4,1446}],combat = 86880,is_tv = 0};

get_lv_cfg(725) ->
	#pet_lv_cfg{lv = 725,max_exp = 6806779,attr = [{1,2896},{2,57920},{3,1448},{4,1448}],combat = 87000,is_tv = 0};

get_lv_cfg(726) ->
	#pet_lv_cfg{lv = 726,max_exp = 6861812,attr = [{1,2900},{2,58000},{3,1450},{4,1450}],combat = 87120,is_tv = 0};

get_lv_cfg(727) ->
	#pet_lv_cfg{lv = 727,max_exp = 6917290,attr = [{1,2904},{2,58080},{3,1452},{4,1452}],combat = 87240,is_tv = 0};

get_lv_cfg(728) ->
	#pet_lv_cfg{lv = 728,max_exp = 6973216,attr = [{1,2908},{2,58160},{3,1454},{4,1454}],combat = 87360,is_tv = 0};

get_lv_cfg(729) ->
	#pet_lv_cfg{lv = 729,max_exp = 7029594,attr = [{1,2912},{2,58240},{3,1456},{4,1456}],combat = 87480,is_tv = 0};

get_lv_cfg(730) ->
	#pet_lv_cfg{lv = 730,max_exp = 7086428,attr = [{1,2916},{2,58320},{3,1458},{4,1458}],combat = 87600,is_tv = 0};

get_lv_cfg(731) ->
	#pet_lv_cfg{lv = 731,max_exp = 7143722,attr = [{1,2920},{2,58400},{3,1460},{4,1460}],combat = 87720,is_tv = 0};

get_lv_cfg(732) ->
	#pet_lv_cfg{lv = 732,max_exp = 7201479,attr = [{1,2924},{2,58480},{3,1462},{4,1462}],combat = 87840,is_tv = 0};

get_lv_cfg(733) ->
	#pet_lv_cfg{lv = 733,max_exp = 7259703,attr = [{1,2928},{2,58560},{3,1464},{4,1464}],combat = 87960,is_tv = 0};

get_lv_cfg(734) ->
	#pet_lv_cfg{lv = 734,max_exp = 7318398,attr = [{1,2932},{2,58640},{3,1466},{4,1466}],combat = 88080,is_tv = 0};

get_lv_cfg(735) ->
	#pet_lv_cfg{lv = 735,max_exp = 7377567,attr = [{1,2936},{2,58720},{3,1468},{4,1468}],combat = 88200,is_tv = 0};

get_lv_cfg(736) ->
	#pet_lv_cfg{lv = 736,max_exp = 7437215,attr = [{1,2940},{2,58800},{3,1470},{4,1470}],combat = 88320,is_tv = 0};

get_lv_cfg(737) ->
	#pet_lv_cfg{lv = 737,max_exp = 7497345,attr = [{1,2944},{2,58880},{3,1472},{4,1472}],combat = 88440,is_tv = 0};

get_lv_cfg(738) ->
	#pet_lv_cfg{lv = 738,max_exp = 7557961,attr = [{1,2948},{2,58960},{3,1474},{4,1474}],combat = 88560,is_tv = 0};

get_lv_cfg(739) ->
	#pet_lv_cfg{lv = 739,max_exp = 7619067,attr = [{1,2952},{2,59040},{3,1476},{4,1476}],combat = 88680,is_tv = 0};

get_lv_cfg(740) ->
	#pet_lv_cfg{lv = 740,max_exp = 7680667,attr = [{1,2956},{2,59120},{3,1478},{4,1478}],combat = 88800,is_tv = 0};

get_lv_cfg(741) ->
	#pet_lv_cfg{lv = 741,max_exp = 7742765,attr = [{1,2960},{2,59200},{3,1480},{4,1480}],combat = 88920,is_tv = 0};

get_lv_cfg(742) ->
	#pet_lv_cfg{lv = 742,max_exp = 7805365,attr = [{1,2964},{2,59280},{3,1482},{4,1482}],combat = 89040,is_tv = 0};

get_lv_cfg(743) ->
	#pet_lv_cfg{lv = 743,max_exp = 7868471,attr = [{1,2968},{2,59360},{3,1484},{4,1484}],combat = 89160,is_tv = 0};

get_lv_cfg(744) ->
	#pet_lv_cfg{lv = 744,max_exp = 7932088,attr = [{1,2972},{2,59440},{3,1486},{4,1486}],combat = 89280,is_tv = 0};

get_lv_cfg(745) ->
	#pet_lv_cfg{lv = 745,max_exp = 7996219,attr = [{1,2976},{2,59520},{3,1488},{4,1488}],combat = 89400,is_tv = 0};

get_lv_cfg(746) ->
	#pet_lv_cfg{lv = 746,max_exp = 8060868,attr = [{1,2980},{2,59600},{3,1490},{4,1490}],combat = 89520,is_tv = 0};

get_lv_cfg(747) ->
	#pet_lv_cfg{lv = 747,max_exp = 8126040,attr = [{1,2984},{2,59680},{3,1492},{4,1492}],combat = 89640,is_tv = 0};

get_lv_cfg(748) ->
	#pet_lv_cfg{lv = 748,max_exp = 8191739,attr = [{1,2988},{2,59760},{3,1494},{4,1494}],combat = 89760,is_tv = 0};

get_lv_cfg(749) ->
	#pet_lv_cfg{lv = 749,max_exp = 8257969,attr = [{1,2992},{2,59840},{3,1496},{4,1496}],combat = 89880,is_tv = 0};

get_lv_cfg(750) ->
	#pet_lv_cfg{lv = 750,max_exp = 8324735,attr = [{1,2996},{2,59920},{3,1498},{4,1498}],combat = 90000,is_tv = 1};

get_lv_cfg(751) ->
	#pet_lv_cfg{lv = 751,max_exp = 8392040,attr = [{1,3000},{2,60000},{3,1500},{4,1500}],combat = 90120,is_tv = 0};

get_lv_cfg(752) ->
	#pet_lv_cfg{lv = 752,max_exp = 8459890,attr = [{1,3004},{2,60080},{3,1502},{4,1502}],combat = 90240,is_tv = 0};

get_lv_cfg(753) ->
	#pet_lv_cfg{lv = 753,max_exp = 8528288,attr = [{1,3008},{2,60160},{3,1504},{4,1504}],combat = 90360,is_tv = 0};

get_lv_cfg(754) ->
	#pet_lv_cfg{lv = 754,max_exp = 8597239,attr = [{1,3012},{2,60240},{3,1506},{4,1506}],combat = 90480,is_tv = 0};

get_lv_cfg(755) ->
	#pet_lv_cfg{lv = 755,max_exp = 8666748,attr = [{1,3016},{2,60320},{3,1508},{4,1508}],combat = 90600,is_tv = 0};

get_lv_cfg(756) ->
	#pet_lv_cfg{lv = 756,max_exp = 8736819,attr = [{1,3020},{2,60400},{3,1510},{4,1510}],combat = 90720,is_tv = 0};

get_lv_cfg(757) ->
	#pet_lv_cfg{lv = 757,max_exp = 8807456,attr = [{1,3024},{2,60480},{3,1512},{4,1512}],combat = 90840,is_tv = 0};

get_lv_cfg(758) ->
	#pet_lv_cfg{lv = 758,max_exp = 8878664,attr = [{1,3028},{2,60560},{3,1514},{4,1514}],combat = 90960,is_tv = 0};

get_lv_cfg(759) ->
	#pet_lv_cfg{lv = 759,max_exp = 8950448,attr = [{1,3032},{2,60640},{3,1516},{4,1516}],combat = 91080,is_tv = 0};

get_lv_cfg(760) ->
	#pet_lv_cfg{lv = 760,max_exp = 9022812,attr = [{1,3036},{2,60720},{3,1518},{4,1518}],combat = 91200,is_tv = 0};

get_lv_cfg(761) ->
	#pet_lv_cfg{lv = 761,max_exp = 9095761,attr = [{1,3040},{2,60800},{3,1520},{4,1520}],combat = 91320,is_tv = 0};

get_lv_cfg(762) ->
	#pet_lv_cfg{lv = 762,max_exp = 9169300,attr = [{1,3044},{2,60880},{3,1522},{4,1522}],combat = 91440,is_tv = 0};

get_lv_cfg(763) ->
	#pet_lv_cfg{lv = 763,max_exp = 9243434,attr = [{1,3048},{2,60960},{3,1524},{4,1524}],combat = 91560,is_tv = 0};

get_lv_cfg(764) ->
	#pet_lv_cfg{lv = 764,max_exp = 9318167,attr = [{1,3052},{2,61040},{3,1526},{4,1526}],combat = 91680,is_tv = 0};

get_lv_cfg(765) ->
	#pet_lv_cfg{lv = 765,max_exp = 9393504,attr = [{1,3056},{2,61120},{3,1528},{4,1528}],combat = 91800,is_tv = 0};

get_lv_cfg(766) ->
	#pet_lv_cfg{lv = 766,max_exp = 9469450,attr = [{1,3060},{2,61200},{3,1530},{4,1530}],combat = 91920,is_tv = 0};

get_lv_cfg(767) ->
	#pet_lv_cfg{lv = 767,max_exp = 9546011,attr = [{1,3064},{2,61280},{3,1532},{4,1532}],combat = 92040,is_tv = 0};

get_lv_cfg(768) ->
	#pet_lv_cfg{lv = 768,max_exp = 9623190,attr = [{1,3068},{2,61360},{3,1534},{4,1534}],combat = 92160,is_tv = 0};

get_lv_cfg(769) ->
	#pet_lv_cfg{lv = 769,max_exp = 9700993,attr = [{1,3072},{2,61440},{3,1536},{4,1536}],combat = 92280,is_tv = 0};

get_lv_cfg(770) ->
	#pet_lv_cfg{lv = 770,max_exp = 9779426,attr = [{1,3076},{2,61520},{3,1538},{4,1538}],combat = 92400,is_tv = 0};

get_lv_cfg(771) ->
	#pet_lv_cfg{lv = 771,max_exp = 9858493,attr = [{1,3080},{2,61600},{3,1540},{4,1540}],combat = 92520,is_tv = 0};

get_lv_cfg(772) ->
	#pet_lv_cfg{lv = 772,max_exp = 9938199,attr = [{1,3084},{2,61680},{3,1542},{4,1542}],combat = 92640,is_tv = 0};

get_lv_cfg(773) ->
	#pet_lv_cfg{lv = 773,max_exp = 10018549,attr = [{1,3088},{2,61760},{3,1544},{4,1544}],combat = 92760,is_tv = 0};

get_lv_cfg(774) ->
	#pet_lv_cfg{lv = 774,max_exp = 10099549,attr = [{1,3092},{2,61840},{3,1546},{4,1546}],combat = 92880,is_tv = 0};

get_lv_cfg(775) ->
	#pet_lv_cfg{lv = 775,max_exp = 10181204,attr = [{1,3096},{2,61920},{3,1548},{4,1548}],combat = 93000,is_tv = 0};

get_lv_cfg(776) ->
	#pet_lv_cfg{lv = 776,max_exp = 10263519,attr = [{1,3100},{2,62000},{3,1550},{4,1550}],combat = 93120,is_tv = 0};

get_lv_cfg(777) ->
	#pet_lv_cfg{lv = 777,max_exp = 10346500,attr = [{1,3104},{2,62080},{3,1552},{4,1552}],combat = 93240,is_tv = 0};

get_lv_cfg(778) ->
	#pet_lv_cfg{lv = 778,max_exp = 10430151,attr = [{1,3108},{2,62160},{3,1554},{4,1554}],combat = 93360,is_tv = 0};

get_lv_cfg(779) ->
	#pet_lv_cfg{lv = 779,max_exp = 10514479,attr = [{1,3112},{2,62240},{3,1556},{4,1556}],combat = 93480,is_tv = 0};

get_lv_cfg(780) ->
	#pet_lv_cfg{lv = 780,max_exp = 10599489,attr = [{1,3116},{2,62320},{3,1558},{4,1558}],combat = 93600,is_tv = 0};

get_lv_cfg(781) ->
	#pet_lv_cfg{lv = 781,max_exp = 10685186,attr = [{1,3120},{2,62400},{3,1560},{4,1560}],combat = 93720,is_tv = 0};

get_lv_cfg(782) ->
	#pet_lv_cfg{lv = 782,max_exp = 10771576,attr = [{1,3124},{2,62480},{3,1562},{4,1562}],combat = 93840,is_tv = 0};

get_lv_cfg(783) ->
	#pet_lv_cfg{lv = 783,max_exp = 10858664,attr = [{1,3128},{2,62560},{3,1564},{4,1564}],combat = 93960,is_tv = 0};

get_lv_cfg(784) ->
	#pet_lv_cfg{lv = 784,max_exp = 10946456,attr = [{1,3132},{2,62640},{3,1566},{4,1566}],combat = 94080,is_tv = 0};

get_lv_cfg(785) ->
	#pet_lv_cfg{lv = 785,max_exp = 11034958,attr = [{1,3136},{2,62720},{3,1568},{4,1568}],combat = 94200,is_tv = 0};

get_lv_cfg(786) ->
	#pet_lv_cfg{lv = 786,max_exp = 11124176,attr = [{1,3140},{2,62800},{3,1570},{4,1570}],combat = 94320,is_tv = 0};

get_lv_cfg(787) ->
	#pet_lv_cfg{lv = 787,max_exp = 11214115,attr = [{1,3144},{2,62880},{3,1572},{4,1572}],combat = 94440,is_tv = 0};

get_lv_cfg(788) ->
	#pet_lv_cfg{lv = 788,max_exp = 11304781,attr = [{1,3148},{2,62960},{3,1574},{4,1574}],combat = 94560,is_tv = 0};

get_lv_cfg(789) ->
	#pet_lv_cfg{lv = 789,max_exp = 11396180,attr = [{1,3152},{2,63040},{3,1576},{4,1576}],combat = 94680,is_tv = 0};

get_lv_cfg(790) ->
	#pet_lv_cfg{lv = 790,max_exp = 11488318,attr = [{1,3156},{2,63120},{3,1578},{4,1578}],combat = 94800,is_tv = 0};

get_lv_cfg(791) ->
	#pet_lv_cfg{lv = 791,max_exp = 11581201,attr = [{1,3160},{2,63200},{3,1580},{4,1580}],combat = 94920,is_tv = 0};

get_lv_cfg(792) ->
	#pet_lv_cfg{lv = 792,max_exp = 11674835,attr = [{1,3164},{2,63280},{3,1582},{4,1582}],combat = 95040,is_tv = 0};

get_lv_cfg(793) ->
	#pet_lv_cfg{lv = 793,max_exp = 11769226,attr = [{1,3168},{2,63360},{3,1584},{4,1584}],combat = 95160,is_tv = 0};

get_lv_cfg(794) ->
	#pet_lv_cfg{lv = 794,max_exp = 11864380,attr = [{1,3172},{2,63440},{3,1586},{4,1586}],combat = 95280,is_tv = 0};

get_lv_cfg(795) ->
	#pet_lv_cfg{lv = 795,max_exp = 11960304,attr = [{1,3176},{2,63520},{3,1588},{4,1588}],combat = 95400,is_tv = 0};

get_lv_cfg(796) ->
	#pet_lv_cfg{lv = 796,max_exp = 12057003,attr = [{1,3180},{2,63600},{3,1590},{4,1590}],combat = 95520,is_tv = 0};

get_lv_cfg(797) ->
	#pet_lv_cfg{lv = 797,max_exp = 12154484,attr = [{1,3184},{2,63680},{3,1592},{4,1592}],combat = 95640,is_tv = 0};

get_lv_cfg(798) ->
	#pet_lv_cfg{lv = 798,max_exp = 12252753,attr = [{1,3188},{2,63760},{3,1594},{4,1594}],combat = 95760,is_tv = 0};

get_lv_cfg(799) ->
	#pet_lv_cfg{lv = 799,max_exp = 12351817,attr = [{1,3192},{2,63840},{3,1596},{4,1596}],combat = 95880,is_tv = 0};

get_lv_cfg(800) ->
	#pet_lv_cfg{lv = 800,max_exp = 12451681,attr = [{1,3196},{2,63920},{3,1598},{4,1598}],combat = 96000,is_tv = 1};

get_lv_cfg(801) ->
	#pet_lv_cfg{lv = 801,max_exp = 12552353,attr = [{1,3200},{2,64000},{3,1600},{4,1600}],combat = 96120,is_tv = 0};

get_lv_cfg(802) ->
	#pet_lv_cfg{lv = 802,max_exp = 12653839,attr = [{1,3204},{2,64080},{3,1602},{4,1602}],combat = 96240,is_tv = 0};

get_lv_cfg(803) ->
	#pet_lv_cfg{lv = 803,max_exp = 12756145,attr = [{1,3208},{2,64160},{3,1604},{4,1604}],combat = 96360,is_tv = 0};

get_lv_cfg(804) ->
	#pet_lv_cfg{lv = 804,max_exp = 12859278,attr = [{1,3212},{2,64240},{3,1606},{4,1606}],combat = 96480,is_tv = 0};

get_lv_cfg(805) ->
	#pet_lv_cfg{lv = 805,max_exp = 12963245,attr = [{1,3216},{2,64320},{3,1608},{4,1608}],combat = 96600,is_tv = 0};

get_lv_cfg(806) ->
	#pet_lv_cfg{lv = 806,max_exp = 13068053,attr = [{1,3220},{2,64400},{3,1610},{4,1610}],combat = 96720,is_tv = 0};

get_lv_cfg(807) ->
	#pet_lv_cfg{lv = 807,max_exp = 13173708,attr = [{1,3224},{2,64480},{3,1612},{4,1612}],combat = 96840,is_tv = 0};

get_lv_cfg(808) ->
	#pet_lv_cfg{lv = 808,max_exp = 13280217,attr = [{1,3228},{2,64560},{3,1614},{4,1614}],combat = 96960,is_tv = 0};

get_lv_cfg(809) ->
	#pet_lv_cfg{lv = 809,max_exp = 13387588,attr = [{1,3232},{2,64640},{3,1616},{4,1616}],combat = 97080,is_tv = 0};

get_lv_cfg(810) ->
	#pet_lv_cfg{lv = 810,max_exp = 13495827,attr = [{1,3236},{2,64720},{3,1618},{4,1618}],combat = 97200,is_tv = 0};

get_lv_cfg(811) ->
	#pet_lv_cfg{lv = 811,max_exp = 13604941,attr = [{1,3240},{2,64800},{3,1620},{4,1620}],combat = 97320,is_tv = 0};

get_lv_cfg(812) ->
	#pet_lv_cfg{lv = 812,max_exp = 13714937,attr = [{1,3244},{2,64880},{3,1622},{4,1622}],combat = 97440,is_tv = 0};

get_lv_cfg(813) ->
	#pet_lv_cfg{lv = 813,max_exp = 13825822,attr = [{1,3248},{2,64960},{3,1624},{4,1624}],combat = 97560,is_tv = 0};

get_lv_cfg(814) ->
	#pet_lv_cfg{lv = 814,max_exp = 13937604,attr = [{1,3252},{2,65040},{3,1626},{4,1626}],combat = 97680,is_tv = 0};

get_lv_cfg(815) ->
	#pet_lv_cfg{lv = 815,max_exp = 14050290,attr = [{1,3256},{2,65120},{3,1628},{4,1628}],combat = 97800,is_tv = 0};

get_lv_cfg(816) ->
	#pet_lv_cfg{lv = 816,max_exp = 14163887,attr = [{1,3260},{2,65200},{3,1630},{4,1630}],combat = 97920,is_tv = 0};

get_lv_cfg(817) ->
	#pet_lv_cfg{lv = 817,max_exp = 14278402,attr = [{1,3264},{2,65280},{3,1632},{4,1632}],combat = 98040,is_tv = 0};

get_lv_cfg(818) ->
	#pet_lv_cfg{lv = 818,max_exp = 14393843,attr = [{1,3268},{2,65360},{3,1634},{4,1634}],combat = 98160,is_tv = 0};

get_lv_cfg(819) ->
	#pet_lv_cfg{lv = 819,max_exp = 14510217,attr = [{1,3272},{2,65440},{3,1636},{4,1636}],combat = 98280,is_tv = 0};

get_lv_cfg(820) ->
	#pet_lv_cfg{lv = 820,max_exp = 14627532,attr = [{1,3276},{2,65520},{3,1638},{4,1638}],combat = 98400,is_tv = 0};

get_lv_cfg(821) ->
	#pet_lv_cfg{lv = 821,max_exp = 14745796,attr = [{1,3280},{2,65600},{3,1640},{4,1640}],combat = 98520,is_tv = 0};

get_lv_cfg(822) ->
	#pet_lv_cfg{lv = 822,max_exp = 14865016,attr = [{1,3284},{2,65680},{3,1642},{4,1642}],combat = 98640,is_tv = 0};

get_lv_cfg(823) ->
	#pet_lv_cfg{lv = 823,max_exp = 14985200,attr = [{1,3288},{2,65760},{3,1644},{4,1644}],combat = 98760,is_tv = 0};

get_lv_cfg(824) ->
	#pet_lv_cfg{lv = 824,max_exp = 15106355,attr = [{1,3292},{2,65840},{3,1646},{4,1646}],combat = 98880,is_tv = 0};

get_lv_cfg(825) ->
	#pet_lv_cfg{lv = 825,max_exp = 15228490,attr = [{1,3296},{2,65920},{3,1648},{4,1648}],combat = 99000,is_tv = 0};

get_lv_cfg(826) ->
	#pet_lv_cfg{lv = 826,max_exp = 15351612,attr = [{1,3300},{2,66000},{3,1650},{4,1650}],combat = 99120,is_tv = 0};

get_lv_cfg(827) ->
	#pet_lv_cfg{lv = 827,max_exp = 15475730,attr = [{1,3304},{2,66080},{3,1652},{4,1652}],combat = 99240,is_tv = 0};

get_lv_cfg(828) ->
	#pet_lv_cfg{lv = 828,max_exp = 15600851,attr = [{1,3308},{2,66160},{3,1654},{4,1654}],combat = 99360,is_tv = 0};

get_lv_cfg(829) ->
	#pet_lv_cfg{lv = 829,max_exp = 15726984,attr = [{1,3312},{2,66240},{3,1656},{4,1656}],combat = 99480,is_tv = 0};

get_lv_cfg(830) ->
	#pet_lv_cfg{lv = 830,max_exp = 15854137,attr = [{1,3316},{2,66320},{3,1658},{4,1658}],combat = 99600,is_tv = 0};

get_lv_cfg(831) ->
	#pet_lv_cfg{lv = 831,max_exp = 15982318,attr = [{1,3320},{2,66400},{3,1660},{4,1660}],combat = 99720,is_tv = 0};

get_lv_cfg(832) ->
	#pet_lv_cfg{lv = 832,max_exp = 16111535,attr = [{1,3324},{2,66480},{3,1662},{4,1662}],combat = 99840,is_tv = 0};

get_lv_cfg(833) ->
	#pet_lv_cfg{lv = 833,max_exp = 16241797,attr = [{1,3328},{2,66560},{3,1664},{4,1664}],combat = 99960,is_tv = 0};

get_lv_cfg(834) ->
	#pet_lv_cfg{lv = 834,max_exp = 16373112,attr = [{1,3332},{2,66640},{3,1666},{4,1666}],combat = 100080,is_tv = 0};

get_lv_cfg(835) ->
	#pet_lv_cfg{lv = 835,max_exp = 16505489,attr = [{1,3336},{2,66720},{3,1668},{4,1668}],combat = 100200,is_tv = 0};

get_lv_cfg(836) ->
	#pet_lv_cfg{lv = 836,max_exp = 16638936,attr = [{1,3340},{2,66800},{3,1670},{4,1670}],combat = 100320,is_tv = 0};

get_lv_cfg(837) ->
	#pet_lv_cfg{lv = 837,max_exp = 16773462,attr = [{1,3344},{2,66880},{3,1672},{4,1672}],combat = 100440,is_tv = 0};

get_lv_cfg(838) ->
	#pet_lv_cfg{lv = 838,max_exp = 16909075,attr = [{1,3348},{2,66960},{3,1674},{4,1674}],combat = 100560,is_tv = 0};

get_lv_cfg(839) ->
	#pet_lv_cfg{lv = 839,max_exp = 17045785,attr = [{1,3352},{2,67040},{3,1676},{4,1676}],combat = 100680,is_tv = 0};

get_lv_cfg(840) ->
	#pet_lv_cfg{lv = 840,max_exp = 17183600,attr = [{1,3356},{2,67120},{3,1678},{4,1678}],combat = 100800,is_tv = 0};

get_lv_cfg(841) ->
	#pet_lv_cfg{lv = 841,max_exp = 17322529,attr = [{1,3360},{2,67200},{3,1680},{4,1680}],combat = 100920,is_tv = 0};

get_lv_cfg(842) ->
	#pet_lv_cfg{lv = 842,max_exp = 17462582,attr = [{1,3364},{2,67280},{3,1682},{4,1682}],combat = 101040,is_tv = 0};

get_lv_cfg(843) ->
	#pet_lv_cfg{lv = 843,max_exp = 17603767,attr = [{1,3368},{2,67360},{3,1684},{4,1684}],combat = 101160,is_tv = 0};

get_lv_cfg(844) ->
	#pet_lv_cfg{lv = 844,max_exp = 17746093,attr = [{1,3372},{2,67440},{3,1686},{4,1686}],combat = 101280,is_tv = 0};

get_lv_cfg(845) ->
	#pet_lv_cfg{lv = 845,max_exp = 17889570,attr = [{1,3376},{2,67520},{3,1688},{4,1688}],combat = 101400,is_tv = 0};

get_lv_cfg(846) ->
	#pet_lv_cfg{lv = 846,max_exp = 18034207,attr = [{1,3380},{2,67600},{3,1690},{4,1690}],combat = 101520,is_tv = 0};

get_lv_cfg(847) ->
	#pet_lv_cfg{lv = 847,max_exp = 18180014,attr = [{1,3384},{2,67680},{3,1692},{4,1692}],combat = 101640,is_tv = 0};

get_lv_cfg(848) ->
	#pet_lv_cfg{lv = 848,max_exp = 18326999,attr = [{1,3388},{2,67760},{3,1694},{4,1694}],combat = 101760,is_tv = 0};

get_lv_cfg(849) ->
	#pet_lv_cfg{lv = 849,max_exp = 18475173,attr = [{1,3392},{2,67840},{3,1696},{4,1696}],combat = 101880,is_tv = 0};

get_lv_cfg(850) ->
	#pet_lv_cfg{lv = 850,max_exp = 18624545,attr = [{1,3396},{2,67920},{3,1698},{4,1698}],combat = 102000,is_tv = 1};

get_lv_cfg(851) ->
	#pet_lv_cfg{lv = 851,max_exp = 18775124,attr = [{1,3400},{2,68000},{3,1700},{4,1700}],combat = 102120,is_tv = 0};

get_lv_cfg(852) ->
	#pet_lv_cfg{lv = 852,max_exp = 18926921,attr = [{1,3404},{2,68080},{3,1702},{4,1702}],combat = 102240,is_tv = 0};

get_lv_cfg(853) ->
	#pet_lv_cfg{lv = 853,max_exp = 19079945,attr = [{1,3408},{2,68160},{3,1704},{4,1704}],combat = 102360,is_tv = 0};

get_lv_cfg(854) ->
	#pet_lv_cfg{lv = 854,max_exp = 19234206,attr = [{1,3412},{2,68240},{3,1706},{4,1706}],combat = 102480,is_tv = 0};

get_lv_cfg(855) ->
	#pet_lv_cfg{lv = 855,max_exp = 19389715,attr = [{1,3416},{2,68320},{3,1708},{4,1708}],combat = 102600,is_tv = 0};

get_lv_cfg(856) ->
	#pet_lv_cfg{lv = 856,max_exp = 19546481,attr = [{1,3420},{2,68400},{3,1710},{4,1710}],combat = 102720,is_tv = 0};

get_lv_cfg(857) ->
	#pet_lv_cfg{lv = 857,max_exp = 19704514,attr = [{1,3424},{2,68480},{3,1712},{4,1712}],combat = 102840,is_tv = 0};

get_lv_cfg(858) ->
	#pet_lv_cfg{lv = 858,max_exp = 19863825,attr = [{1,3428},{2,68560},{3,1714},{4,1714}],combat = 102960,is_tv = 0};

get_lv_cfg(859) ->
	#pet_lv_cfg{lv = 859,max_exp = 20024424,attr = [{1,3432},{2,68640},{3,1716},{4,1716}],combat = 103080,is_tv = 0};

get_lv_cfg(860) ->
	#pet_lv_cfg{lv = 860,max_exp = 20186321,attr = [{1,3436},{2,68720},{3,1718},{4,1718}],combat = 103200,is_tv = 0};

get_lv_cfg(861) ->
	#pet_lv_cfg{lv = 861,max_exp = 20349527,attr = [{1,3440},{2,68800},{3,1720},{4,1720}],combat = 103320,is_tv = 0};

get_lv_cfg(862) ->
	#pet_lv_cfg{lv = 862,max_exp = 20514053,attr = [{1,3444},{2,68880},{3,1722},{4,1722}],combat = 103440,is_tv = 0};

get_lv_cfg(863) ->
	#pet_lv_cfg{lv = 863,max_exp = 20679909,attr = [{1,3448},{2,68960},{3,1724},{4,1724}],combat = 103560,is_tv = 0};

get_lv_cfg(864) ->
	#pet_lv_cfg{lv = 864,max_exp = 20847106,attr = [{1,3452},{2,69040},{3,1726},{4,1726}],combat = 103680,is_tv = 0};

get_lv_cfg(865) ->
	#pet_lv_cfg{lv = 865,max_exp = 21015655,attr = [{1,3456},{2,69120},{3,1728},{4,1728}],combat = 103800,is_tv = 0};

get_lv_cfg(866) ->
	#pet_lv_cfg{lv = 866,max_exp = 21185567,attr = [{1,3460},{2,69200},{3,1730},{4,1730}],combat = 103920,is_tv = 0};

get_lv_cfg(867) ->
	#pet_lv_cfg{lv = 867,max_exp = 21356852,attr = [{1,3464},{2,69280},{3,1732},{4,1732}],combat = 104040,is_tv = 0};

get_lv_cfg(868) ->
	#pet_lv_cfg{lv = 868,max_exp = 21529522,attr = [{1,3468},{2,69360},{3,1734},{4,1734}],combat = 104160,is_tv = 0};

get_lv_cfg(869) ->
	#pet_lv_cfg{lv = 869,max_exp = 21703588,attr = [{1,3472},{2,69440},{3,1736},{4,1736}],combat = 104280,is_tv = 0};

get_lv_cfg(870) ->
	#pet_lv_cfg{lv = 870,max_exp = 21879062,attr = [{1,3476},{2,69520},{3,1738},{4,1738}],combat = 104400,is_tv = 0};

get_lv_cfg(871) ->
	#pet_lv_cfg{lv = 871,max_exp = 22055954,attr = [{1,3480},{2,69600},{3,1740},{4,1740}],combat = 104520,is_tv = 0};

get_lv_cfg(872) ->
	#pet_lv_cfg{lv = 872,max_exp = 22234276,attr = [{1,3484},{2,69680},{3,1742},{4,1742}],combat = 104640,is_tv = 0};

get_lv_cfg(873) ->
	#pet_lv_cfg{lv = 873,max_exp = 22414040,attr = [{1,3488},{2,69760},{3,1744},{4,1744}],combat = 104760,is_tv = 0};

get_lv_cfg(874) ->
	#pet_lv_cfg{lv = 874,max_exp = 22595258,attr = [{1,3492},{2,69840},{3,1746},{4,1746}],combat = 104880,is_tv = 0};

get_lv_cfg(875) ->
	#pet_lv_cfg{lv = 875,max_exp = 22777941,attr = [{1,3496},{2,69920},{3,1748},{4,1748}],combat = 105000,is_tv = 0};

get_lv_cfg(876) ->
	#pet_lv_cfg{lv = 876,max_exp = 22962101,attr = [{1,3500},{2,70000},{3,1750},{4,1750}],combat = 105120,is_tv = 0};

get_lv_cfg(877) ->
	#pet_lv_cfg{lv = 877,max_exp = 23147750,attr = [{1,3504},{2,70080},{3,1752},{4,1752}],combat = 105240,is_tv = 0};

get_lv_cfg(878) ->
	#pet_lv_cfg{lv = 878,max_exp = 23334900,attr = [{1,3508},{2,70160},{3,1754},{4,1754}],combat = 105360,is_tv = 0};

get_lv_cfg(879) ->
	#pet_lv_cfg{lv = 879,max_exp = 23523563,attr = [{1,3512},{2,70240},{3,1756},{4,1756}],combat = 105480,is_tv = 0};

get_lv_cfg(880) ->
	#pet_lv_cfg{lv = 880,max_exp = 23713751,attr = [{1,3516},{2,70320},{3,1758},{4,1758}],combat = 105600,is_tv = 0};

get_lv_cfg(881) ->
	#pet_lv_cfg{lv = 881,max_exp = 23905477,attr = [{1,3520},{2,70400},{3,1760},{4,1760}],combat = 105720,is_tv = 0};

get_lv_cfg(882) ->
	#pet_lv_cfg{lv = 882,max_exp = 24098753,attr = [{1,3524},{2,70480},{3,1762},{4,1762}],combat = 105840,is_tv = 0};

get_lv_cfg(883) ->
	#pet_lv_cfg{lv = 883,max_exp = 24293591,attr = [{1,3528},{2,70560},{3,1764},{4,1764}],combat = 105960,is_tv = 0};

get_lv_cfg(884) ->
	#pet_lv_cfg{lv = 884,max_exp = 24490005,attr = [{1,3532},{2,70640},{3,1766},{4,1766}],combat = 106080,is_tv = 0};

get_lv_cfg(885) ->
	#pet_lv_cfg{lv = 885,max_exp = 24688007,attr = [{1,3536},{2,70720},{3,1768},{4,1768}],combat = 106200,is_tv = 0};

get_lv_cfg(886) ->
	#pet_lv_cfg{lv = 886,max_exp = 24887610,attr = [{1,3540},{2,70800},{3,1770},{4,1770}],combat = 106320,is_tv = 0};

get_lv_cfg(887) ->
	#pet_lv_cfg{lv = 887,max_exp = 25088826,attr = [{1,3544},{2,70880},{3,1772},{4,1772}],combat = 106440,is_tv = 0};

get_lv_cfg(888) ->
	#pet_lv_cfg{lv = 888,max_exp = 25291669,attr = [{1,3548},{2,70960},{3,1774},{4,1774}],combat = 106560,is_tv = 0};

get_lv_cfg(889) ->
	#pet_lv_cfg{lv = 889,max_exp = 25496152,attr = [{1,3552},{2,71040},{3,1776},{4,1776}],combat = 106680,is_tv = 0};

get_lv_cfg(890) ->
	#pet_lv_cfg{lv = 890,max_exp = 25702288,attr = [{1,3556},{2,71120},{3,1778},{4,1778}],combat = 106800,is_tv = 0};

get_lv_cfg(891) ->
	#pet_lv_cfg{lv = 891,max_exp = 25910091,attr = [{1,3560},{2,71200},{3,1780},{4,1780}],combat = 106920,is_tv = 0};

get_lv_cfg(892) ->
	#pet_lv_cfg{lv = 892,max_exp = 26119574,attr = [{1,3564},{2,71280},{3,1782},{4,1782}],combat = 107040,is_tv = 0};

get_lv_cfg(893) ->
	#pet_lv_cfg{lv = 893,max_exp = 26330751,attr = [{1,3568},{2,71360},{3,1784},{4,1784}],combat = 107160,is_tv = 0};

get_lv_cfg(894) ->
	#pet_lv_cfg{lv = 894,max_exp = 26543635,attr = [{1,3572},{2,71440},{3,1786},{4,1786}],combat = 107280,is_tv = 0};

get_lv_cfg(895) ->
	#pet_lv_cfg{lv = 895,max_exp = 26758240,attr = [{1,3576},{2,71520},{3,1788},{4,1788}],combat = 107400,is_tv = 0};

get_lv_cfg(896) ->
	#pet_lv_cfg{lv = 896,max_exp = 26974580,attr = [{1,3580},{2,71600},{3,1790},{4,1790}],combat = 107520,is_tv = 0};

get_lv_cfg(897) ->
	#pet_lv_cfg{lv = 897,max_exp = 27192669,attr = [{1,3584},{2,71680},{3,1792},{4,1792}],combat = 107640,is_tv = 0};

get_lv_cfg(898) ->
	#pet_lv_cfg{lv = 898,max_exp = 27412522,attr = [{1,3588},{2,71760},{3,1794},{4,1794}],combat = 107760,is_tv = 0};

get_lv_cfg(899) ->
	#pet_lv_cfg{lv = 899,max_exp = 27634152,attr = [{1,3592},{2,71840},{3,1796},{4,1796}],combat = 107880,is_tv = 0};

get_lv_cfg(900) ->
	#pet_lv_cfg{lv = 900,max_exp = 27857574,attr = [{1,3596},{2,71920},{3,1798},{4,1798}],combat = 108000,is_tv = 1};

get_lv_cfg(901) ->
	#pet_lv_cfg{lv = 901,max_exp = 28082802,attr = [{1,3600},{2,72000},{3,1800},{4,1800}],combat = 108120,is_tv = 0};

get_lv_cfg(902) ->
	#pet_lv_cfg{lv = 902,max_exp = 28309851,attr = [{1,3604},{2,72080},{3,1802},{4,1802}],combat = 108240,is_tv = 0};

get_lv_cfg(903) ->
	#pet_lv_cfg{lv = 903,max_exp = 28538736,attr = [{1,3608},{2,72160},{3,1804},{4,1804}],combat = 108360,is_tv = 0};

get_lv_cfg(904) ->
	#pet_lv_cfg{lv = 904,max_exp = 28769472,attr = [{1,3612},{2,72240},{3,1806},{4,1806}],combat = 108480,is_tv = 0};

get_lv_cfg(905) ->
	#pet_lv_cfg{lv = 905,max_exp = 29002073,attr = [{1,3616},{2,72320},{3,1808},{4,1808}],combat = 108600,is_tv = 0};

get_lv_cfg(906) ->
	#pet_lv_cfg{lv = 906,max_exp = 29236555,attr = [{1,3620},{2,72400},{3,1810},{4,1810}],combat = 108720,is_tv = 0};

get_lv_cfg(907) ->
	#pet_lv_cfg{lv = 907,max_exp = 29472933,attr = [{1,3624},{2,72480},{3,1812},{4,1812}],combat = 108840,is_tv = 0};

get_lv_cfg(908) ->
	#pet_lv_cfg{lv = 908,max_exp = 29711222,attr = [{1,3628},{2,72560},{3,1814},{4,1814}],combat = 108960,is_tv = 0};

get_lv_cfg(909) ->
	#pet_lv_cfg{lv = 909,max_exp = 29951437,attr = [{1,3632},{2,72640},{3,1816},{4,1816}],combat = 109080,is_tv = 0};

get_lv_cfg(910) ->
	#pet_lv_cfg{lv = 910,max_exp = 30193594,attr = [{1,3636},{2,72720},{3,1818},{4,1818}],combat = 109200,is_tv = 0};

get_lv_cfg(911) ->
	#pet_lv_cfg{lv = 911,max_exp = 30437709,attr = [{1,3640},{2,72800},{3,1820},{4,1820}],combat = 109320,is_tv = 0};

get_lv_cfg(912) ->
	#pet_lv_cfg{lv = 912,max_exp = 30683798,attr = [{1,3644},{2,72880},{3,1822},{4,1822}],combat = 109440,is_tv = 0};

get_lv_cfg(913) ->
	#pet_lv_cfg{lv = 913,max_exp = 30931877,attr = [{1,3648},{2,72960},{3,1824},{4,1824}],combat = 109560,is_tv = 0};

get_lv_cfg(914) ->
	#pet_lv_cfg{lv = 914,max_exp = 31181961,attr = [{1,3652},{2,73040},{3,1826},{4,1826}],combat = 109680,is_tv = 0};

get_lv_cfg(915) ->
	#pet_lv_cfg{lv = 915,max_exp = 31434067,attr = [{1,3656},{2,73120},{3,1828},{4,1828}],combat = 109800,is_tv = 0};

get_lv_cfg(916) ->
	#pet_lv_cfg{lv = 916,max_exp = 31688211,attr = [{1,3660},{2,73200},{3,1830},{4,1830}],combat = 109920,is_tv = 0};

get_lv_cfg(917) ->
	#pet_lv_cfg{lv = 917,max_exp = 31944410,attr = [{1,3664},{2,73280},{3,1832},{4,1832}],combat = 110040,is_tv = 0};

get_lv_cfg(918) ->
	#pet_lv_cfg{lv = 918,max_exp = 32202681,attr = [{1,3668},{2,73360},{3,1834},{4,1834}],combat = 110160,is_tv = 0};

get_lv_cfg(919) ->
	#pet_lv_cfg{lv = 919,max_exp = 32463040,attr = [{1,3672},{2,73440},{3,1836},{4,1836}],combat = 110280,is_tv = 0};

get_lv_cfg(920) ->
	#pet_lv_cfg{lv = 920,max_exp = 32725504,attr = [{1,3676},{2,73520},{3,1838},{4,1838}],combat = 110400,is_tv = 0};

get_lv_cfg(921) ->
	#pet_lv_cfg{lv = 921,max_exp = 32990090,attr = [{1,3680},{2,73600},{3,1840},{4,1840}],combat = 110520,is_tv = 0};

get_lv_cfg(922) ->
	#pet_lv_cfg{lv = 922,max_exp = 33256815,attr = [{1,3684},{2,73680},{3,1842},{4,1842}],combat = 110640,is_tv = 0};

get_lv_cfg(923) ->
	#pet_lv_cfg{lv = 923,max_exp = 33525696,attr = [{1,3688},{2,73760},{3,1844},{4,1844}],combat = 110760,is_tv = 0};

get_lv_cfg(924) ->
	#pet_lv_cfg{lv = 924,max_exp = 33796751,attr = [{1,3692},{2,73840},{3,1846},{4,1846}],combat = 110880,is_tv = 0};

get_lv_cfg(925) ->
	#pet_lv_cfg{lv = 925,max_exp = 34069998,attr = [{1,3696},{2,73920},{3,1848},{4,1848}],combat = 111000,is_tv = 0};

get_lv_cfg(926) ->
	#pet_lv_cfg{lv = 926,max_exp = 34345454,attr = [{1,3700},{2,74000},{3,1850},{4,1850}],combat = 111120,is_tv = 0};

get_lv_cfg(927) ->
	#pet_lv_cfg{lv = 927,max_exp = 34623137,attr = [{1,3704},{2,74080},{3,1852},{4,1852}],combat = 111240,is_tv = 0};

get_lv_cfg(928) ->
	#pet_lv_cfg{lv = 928,max_exp = 34903065,attr = [{1,3708},{2,74160},{3,1854},{4,1854}],combat = 111360,is_tv = 0};

get_lv_cfg(929) ->
	#pet_lv_cfg{lv = 929,max_exp = 35185256,attr = [{1,3712},{2,74240},{3,1856},{4,1856}],combat = 111480,is_tv = 0};

get_lv_cfg(930) ->
	#pet_lv_cfg{lv = 930,max_exp = 35469729,attr = [{1,3716},{2,74320},{3,1858},{4,1858}],combat = 111600,is_tv = 0};

get_lv_cfg(931) ->
	#pet_lv_cfg{lv = 931,max_exp = 35756502,attr = [{1,3720},{2,74400},{3,1860},{4,1860}],combat = 111720,is_tv = 0};

get_lv_cfg(932) ->
	#pet_lv_cfg{lv = 932,max_exp = 36045593,attr = [{1,3724},{2,74480},{3,1862},{4,1862}],combat = 111840,is_tv = 0};

get_lv_cfg(933) ->
	#pet_lv_cfg{lv = 933,max_exp = 36337022,attr = [{1,3728},{2,74560},{3,1864},{4,1864}],combat = 111960,is_tv = 0};

get_lv_cfg(934) ->
	#pet_lv_cfg{lv = 934,max_exp = 36630807,attr = [{1,3732},{2,74640},{3,1866},{4,1866}],combat = 112080,is_tv = 0};

get_lv_cfg(935) ->
	#pet_lv_cfg{lv = 935,max_exp = 36926967,attr = [{1,3736},{2,74720},{3,1868},{4,1868}],combat = 112200,is_tv = 0};

get_lv_cfg(936) ->
	#pet_lv_cfg{lv = 936,max_exp = 37225522,attr = [{1,3740},{2,74800},{3,1870},{4,1870}],combat = 112320,is_tv = 0};

get_lv_cfg(937) ->
	#pet_lv_cfg{lv = 937,max_exp = 37526490,attr = [{1,3744},{2,74880},{3,1872},{4,1872}],combat = 112440,is_tv = 0};

get_lv_cfg(938) ->
	#pet_lv_cfg{lv = 938,max_exp = 37829892,attr = [{1,3748},{2,74960},{3,1874},{4,1874}],combat = 112560,is_tv = 0};

get_lv_cfg(939) ->
	#pet_lv_cfg{lv = 939,max_exp = 38135747,attr = [{1,3752},{2,75040},{3,1876},{4,1876}],combat = 112680,is_tv = 0};

get_lv_cfg(940) ->
	#pet_lv_cfg{lv = 940,max_exp = 38444075,attr = [{1,3756},{2,75120},{3,1878},{4,1878}],combat = 112800,is_tv = 0};

get_lv_cfg(941) ->
	#pet_lv_cfg{lv = 941,max_exp = 38754895,attr = [{1,3760},{2,75200},{3,1880},{4,1880}],combat = 112920,is_tv = 0};

get_lv_cfg(942) ->
	#pet_lv_cfg{lv = 942,max_exp = 39068228,attr = [{1,3764},{2,75280},{3,1882},{4,1882}],combat = 113040,is_tv = 0};

get_lv_cfg(943) ->
	#pet_lv_cfg{lv = 943,max_exp = 39384095,attr = [{1,3768},{2,75360},{3,1884},{4,1884}],combat = 113160,is_tv = 0};

get_lv_cfg(944) ->
	#pet_lv_cfg{lv = 944,max_exp = 39702515,attr = [{1,3772},{2,75440},{3,1886},{4,1886}],combat = 113280,is_tv = 0};

get_lv_cfg(945) ->
	#pet_lv_cfg{lv = 945,max_exp = 40023510,attr = [{1,3776},{2,75520},{3,1888},{4,1888}],combat = 113400,is_tv = 0};

get_lv_cfg(946) ->
	#pet_lv_cfg{lv = 946,max_exp = 40347100,attr = [{1,3780},{2,75600},{3,1890},{4,1890}],combat = 113520,is_tv = 0};

get_lv_cfg(947) ->
	#pet_lv_cfg{lv = 947,max_exp = 40673306,attr = [{1,3784},{2,75680},{3,1892},{4,1892}],combat = 113640,is_tv = 0};

get_lv_cfg(948) ->
	#pet_lv_cfg{lv = 948,max_exp = 41002150,attr = [{1,3788},{2,75760},{3,1894},{4,1894}],combat = 113760,is_tv = 0};

get_lv_cfg(949) ->
	#pet_lv_cfg{lv = 949,max_exp = 41333652,attr = [{1,3792},{2,75840},{3,1896},{4,1896}],combat = 113880,is_tv = 0};

get_lv_cfg(950) ->
	#pet_lv_cfg{lv = 950,max_exp = 41667835,attr = [{1,3796},{2,75920},{3,1898},{4,1898}],combat = 114000,is_tv = 1};

get_lv_cfg(951) ->
	#pet_lv_cfg{lv = 951,max_exp = 42004719,attr = [{1,3800},{2,76000},{3,1900},{4,1900}],combat = 114120,is_tv = 0};

get_lv_cfg(952) ->
	#pet_lv_cfg{lv = 952,max_exp = 42344327,attr = [{1,3804},{2,76080},{3,1902},{4,1902}],combat = 114240,is_tv = 0};

get_lv_cfg(953) ->
	#pet_lv_cfg{lv = 953,max_exp = 42686681,attr = [{1,3808},{2,76160},{3,1904},{4,1904}],combat = 114360,is_tv = 0};

get_lv_cfg(954) ->
	#pet_lv_cfg{lv = 954,max_exp = 43031803,attr = [{1,3812},{2,76240},{3,1906},{4,1906}],combat = 114480,is_tv = 0};

get_lv_cfg(955) ->
	#pet_lv_cfg{lv = 955,max_exp = 43379715,attr = [{1,3816},{2,76320},{3,1908},{4,1908}],combat = 114600,is_tv = 0};

get_lv_cfg(956) ->
	#pet_lv_cfg{lv = 956,max_exp = 43730440,attr = [{1,3820},{2,76400},{3,1910},{4,1910}],combat = 114720,is_tv = 0};

get_lv_cfg(957) ->
	#pet_lv_cfg{lv = 957,max_exp = 44084001,attr = [{1,3824},{2,76480},{3,1912},{4,1912}],combat = 114840,is_tv = 0};

get_lv_cfg(958) ->
	#pet_lv_cfg{lv = 958,max_exp = 44440420,attr = [{1,3828},{2,76560},{3,1914},{4,1914}],combat = 114960,is_tv = 0};

get_lv_cfg(959) ->
	#pet_lv_cfg{lv = 959,max_exp = 44799721,attr = [{1,3832},{2,76640},{3,1916},{4,1916}],combat = 115080,is_tv = 0};

get_lv_cfg(960) ->
	#pet_lv_cfg{lv = 960,max_exp = 45161927,attr = [{1,3836},{2,76720},{3,1918},{4,1918}],combat = 115200,is_tv = 0};

get_lv_cfg(961) ->
	#pet_lv_cfg{lv = 961,max_exp = 45527061,attr = [{1,3840},{2,76800},{3,1920},{4,1920}],combat = 115320,is_tv = 0};

get_lv_cfg(962) ->
	#pet_lv_cfg{lv = 962,max_exp = 45895147,attr = [{1,3844},{2,76880},{3,1922},{4,1922}],combat = 115440,is_tv = 0};

get_lv_cfg(963) ->
	#pet_lv_cfg{lv = 963,max_exp = 46266209,attr = [{1,3848},{2,76960},{3,1924},{4,1924}],combat = 115560,is_tv = 0};

get_lv_cfg(964) ->
	#pet_lv_cfg{lv = 964,max_exp = 46640271,attr = [{1,3852},{2,77040},{3,1926},{4,1926}],combat = 115680,is_tv = 0};

get_lv_cfg(965) ->
	#pet_lv_cfg{lv = 965,max_exp = 47017358,attr = [{1,3856},{2,77120},{3,1928},{4,1928}],combat = 115800,is_tv = 0};

get_lv_cfg(966) ->
	#pet_lv_cfg{lv = 966,max_exp = 47397493,attr = [{1,3860},{2,77200},{3,1930},{4,1930}],combat = 115920,is_tv = 0};

get_lv_cfg(967) ->
	#pet_lv_cfg{lv = 967,max_exp = 47780702,attr = [{1,3864},{2,77280},{3,1932},{4,1932}],combat = 116040,is_tv = 0};

get_lv_cfg(968) ->
	#pet_lv_cfg{lv = 968,max_exp = 48167009,attr = [{1,3868},{2,77360},{3,1934},{4,1934}],combat = 116160,is_tv = 0};

get_lv_cfg(969) ->
	#pet_lv_cfg{lv = 969,max_exp = 48556439,attr = [{1,3872},{2,77440},{3,1936},{4,1936}],combat = 116280,is_tv = 0};

get_lv_cfg(970) ->
	#pet_lv_cfg{lv = 970,max_exp = 48949018,attr = [{1,3876},{2,77520},{3,1938},{4,1938}],combat = 116400,is_tv = 0};

get_lv_cfg(971) ->
	#pet_lv_cfg{lv = 971,max_exp = 49344771,attr = [{1,3880},{2,77600},{3,1940},{4,1940}],combat = 116520,is_tv = 0};

get_lv_cfg(972) ->
	#pet_lv_cfg{lv = 972,max_exp = 49743723,attr = [{1,3884},{2,77680},{3,1942},{4,1942}],combat = 116640,is_tv = 0};

get_lv_cfg(973) ->
	#pet_lv_cfg{lv = 973,max_exp = 50145901,attr = [{1,3888},{2,77760},{3,1944},{4,1944}],combat = 116760,is_tv = 0};

get_lv_cfg(974) ->
	#pet_lv_cfg{lv = 974,max_exp = 50551331,attr = [{1,3892},{2,77840},{3,1946},{4,1946}],combat = 116880,is_tv = 0};

get_lv_cfg(975) ->
	#pet_lv_cfg{lv = 975,max_exp = 50960039,attr = [{1,3896},{2,77920},{3,1948},{4,1948}],combat = 117000,is_tv = 0};

get_lv_cfg(976) ->
	#pet_lv_cfg{lv = 976,max_exp = 51372051,attr = [{1,3900},{2,78000},{3,1950},{4,1950}],combat = 117120,is_tv = 0};

get_lv_cfg(977) ->
	#pet_lv_cfg{lv = 977,max_exp = 51787394,attr = [{1,3904},{2,78080},{3,1952},{4,1952}],combat = 117240,is_tv = 0};

get_lv_cfg(978) ->
	#pet_lv_cfg{lv = 978,max_exp = 52206095,attr = [{1,3908},{2,78160},{3,1954},{4,1954}],combat = 117360,is_tv = 0};

get_lv_cfg(979) ->
	#pet_lv_cfg{lv = 979,max_exp = 52628181,attr = [{1,3912},{2,78240},{3,1956},{4,1956}],combat = 117480,is_tv = 0};

get_lv_cfg(980) ->
	#pet_lv_cfg{lv = 980,max_exp = 53053680,attr = [{1,3916},{2,78320},{3,1958},{4,1958}],combat = 117600,is_tv = 0};

get_lv_cfg(981) ->
	#pet_lv_cfg{lv = 981,max_exp = 53482619,attr = [{1,3920},{2,78400},{3,1960},{4,1960}],combat = 117720,is_tv = 0};

get_lv_cfg(982) ->
	#pet_lv_cfg{lv = 982,max_exp = 53915026,attr = [{1,3924},{2,78480},{3,1962},{4,1962}],combat = 117840,is_tv = 0};

get_lv_cfg(983) ->
	#pet_lv_cfg{lv = 983,max_exp = 54350929,attr = [{1,3928},{2,78560},{3,1964},{4,1964}],combat = 117960,is_tv = 0};

get_lv_cfg(984) ->
	#pet_lv_cfg{lv = 984,max_exp = 54790356,attr = [{1,3932},{2,78640},{3,1966},{4,1966}],combat = 118080,is_tv = 0};

get_lv_cfg(985) ->
	#pet_lv_cfg{lv = 985,max_exp = 55233336,attr = [{1,3936},{2,78720},{3,1968},{4,1968}],combat = 118200,is_tv = 0};

get_lv_cfg(986) ->
	#pet_lv_cfg{lv = 986,max_exp = 55679898,attr = [{1,3940},{2,78800},{3,1970},{4,1970}],combat = 118320,is_tv = 0};

get_lv_cfg(987) ->
	#pet_lv_cfg{lv = 987,max_exp = 56130070,attr = [{1,3944},{2,78880},{3,1972},{4,1972}],combat = 118440,is_tv = 0};

get_lv_cfg(988) ->
	#pet_lv_cfg{lv = 988,max_exp = 56583882,attr = [{1,3948},{2,78960},{3,1974},{4,1974}],combat = 118560,is_tv = 0};

get_lv_cfg(989) ->
	#pet_lv_cfg{lv = 989,max_exp = 57041363,attr = [{1,3952},{2,79040},{3,1976},{4,1976}],combat = 118680,is_tv = 0};

get_lv_cfg(990) ->
	#pet_lv_cfg{lv = 990,max_exp = 57502542,attr = [{1,3956},{2,79120},{3,1978},{4,1978}],combat = 118800,is_tv = 0};

get_lv_cfg(991) ->
	#pet_lv_cfg{lv = 991,max_exp = 57967450,attr = [{1,3960},{2,79200},{3,1980},{4,1980}],combat = 118920,is_tv = 0};

get_lv_cfg(992) ->
	#pet_lv_cfg{lv = 992,max_exp = 58436117,attr = [{1,3964},{2,79280},{3,1982},{4,1982}],combat = 119040,is_tv = 0};

get_lv_cfg(993) ->
	#pet_lv_cfg{lv = 993,max_exp = 58908573,attr = [{1,3968},{2,79360},{3,1984},{4,1984}],combat = 119160,is_tv = 0};

get_lv_cfg(994) ->
	#pet_lv_cfg{lv = 994,max_exp = 59384849,attr = [{1,3972},{2,79440},{3,1986},{4,1986}],combat = 119280,is_tv = 0};

get_lv_cfg(995) ->
	#pet_lv_cfg{lv = 995,max_exp = 59864976,attr = [{1,3976},{2,79520},{3,1988},{4,1988}],combat = 119400,is_tv = 0};

get_lv_cfg(996) ->
	#pet_lv_cfg{lv = 996,max_exp = 60348984,attr = [{1,3980},{2,79600},{3,1990},{4,1990}],combat = 119520,is_tv = 0};

get_lv_cfg(997) ->
	#pet_lv_cfg{lv = 997,max_exp = 60836906,attr = [{1,3984},{2,79680},{3,1992},{4,1992}],combat = 119640,is_tv = 0};

get_lv_cfg(998) ->
	#pet_lv_cfg{lv = 998,max_exp = 61328772,attr = [{1,3988},{2,79760},{3,1994},{4,1994}],combat = 119760,is_tv = 0};

get_lv_cfg(999) ->
	#pet_lv_cfg{lv = 999,max_exp = 61824615,attr = [{1,3992},{2,79840},{3,1996},{4,1996}],combat = 119880,is_tv = 0};

get_lv_cfg(1000) ->
	#pet_lv_cfg{lv = 1000,max_exp = 62324467,attr = [{1,3996},{2,79920},{3,1998},{4,1998}],combat = 120000,is_tv = 1};

get_lv_cfg(1001) ->
	#pet_lv_cfg{lv = 1001,max_exp = 62828360,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],combat = 120120,is_tv = 0};

get_lv_cfg(1002) ->
	#pet_lv_cfg{lv = 1002,max_exp = 63336327,attr = [{1,4004},{2,80080},{3,2002},{4,2002}],combat = 120240,is_tv = 0};

get_lv_cfg(1003) ->
	#pet_lv_cfg{lv = 1003,max_exp = 63848401,attr = [{1,4008},{2,80160},{3,2004},{4,2004}],combat = 120360,is_tv = 0};

get_lv_cfg(1004) ->
	#pet_lv_cfg{lv = 1004,max_exp = 64364615,attr = [{1,4012},{2,80240},{3,2006},{4,2006}],combat = 120480,is_tv = 0};

get_lv_cfg(1005) ->
	#pet_lv_cfg{lv = 1005,max_exp = 64885003,attr = [{1,4016},{2,80320},{3,2008},{4,2008}],combat = 120600,is_tv = 0};

get_lv_cfg(1006) ->
	#pet_lv_cfg{lv = 1006,max_exp = 65409598,attr = [{1,4020},{2,80400},{3,2010},{4,2010}],combat = 120720,is_tv = 0};

get_lv_cfg(1007) ->
	#pet_lv_cfg{lv = 1007,max_exp = 65938435,attr = [{1,4024},{2,80480},{3,2012},{4,2012}],combat = 120840,is_tv = 0};

get_lv_cfg(1008) ->
	#pet_lv_cfg{lv = 1008,max_exp = 66471547,attr = [{1,4028},{2,80560},{3,2014},{4,2014}],combat = 120960,is_tv = 0};

get_lv_cfg(1009) ->
	#pet_lv_cfg{lv = 1009,max_exp = 67008969,attr = [{1,4032},{2,80640},{3,2016},{4,2016}],combat = 121080,is_tv = 0};

get_lv_cfg(1010) ->
	#pet_lv_cfg{lv = 1010,max_exp = 67550737,attr = [{1,4036},{2,80720},{3,2018},{4,2018}],combat = 121200,is_tv = 0};

get_lv_cfg(1011) ->
	#pet_lv_cfg{lv = 1011,max_exp = 68096885,attr = [{1,4040},{2,80800},{3,2020},{4,2020}],combat = 121320,is_tv = 0};

get_lv_cfg(1012) ->
	#pet_lv_cfg{lv = 1012,max_exp = 68647448,attr = [{1,4044},{2,80880},{3,2022},{4,2022}],combat = 121440,is_tv = 0};

get_lv_cfg(1013) ->
	#pet_lv_cfg{lv = 1013,max_exp = 69202463,attr = [{1,4048},{2,80960},{3,2024},{4,2024}],combat = 121560,is_tv = 0};

get_lv_cfg(1014) ->
	#pet_lv_cfg{lv = 1014,max_exp = 69761965,attr = [{1,4052},{2,81040},{3,2026},{4,2026}],combat = 121680,is_tv = 0};

get_lv_cfg(1015) ->
	#pet_lv_cfg{lv = 1015,max_exp = 70325990,attr = [{1,4056},{2,81120},{3,2028},{4,2028}],combat = 121800,is_tv = 0};

get_lv_cfg(1016) ->
	#pet_lv_cfg{lv = 1016,max_exp = 70894576,attr = [{1,4060},{2,81200},{3,2030},{4,2030}],combat = 121920,is_tv = 0};

get_lv_cfg(1017) ->
	#pet_lv_cfg{lv = 1017,max_exp = 71467759,attr = [{1,4064},{2,81280},{3,2032},{4,2032}],combat = 122040,is_tv = 0};

get_lv_cfg(1018) ->
	#pet_lv_cfg{lv = 1018,max_exp = 72045576,attr = [{1,4068},{2,81360},{3,2034},{4,2034}],combat = 122160,is_tv = 0};

get_lv_cfg(1019) ->
	#pet_lv_cfg{lv = 1019,max_exp = 72628064,attr = [{1,4072},{2,81440},{3,2036},{4,2036}],combat = 122280,is_tv = 0};

get_lv_cfg(1020) ->
	#pet_lv_cfg{lv = 1020,max_exp = 73215262,attr = [{1,4076},{2,81520},{3,2038},{4,2038}],combat = 122400,is_tv = 0};

get_lv_cfg(1021) ->
	#pet_lv_cfg{lv = 1021,max_exp = 73807207,attr = [{1,4080},{2,81600},{3,2040},{4,2040}],combat = 122520,is_tv = 0};

get_lv_cfg(1022) ->
	#pet_lv_cfg{lv = 1022,max_exp = 74403938,attr = [{1,4084},{2,81680},{3,2042},{4,2042}],combat = 122640,is_tv = 0};

get_lv_cfg(1023) ->
	#pet_lv_cfg{lv = 1023,max_exp = 75005494,attr = [{1,4088},{2,81760},{3,2044},{4,2044}],combat = 122760,is_tv = 0};

get_lv_cfg(1024) ->
	#pet_lv_cfg{lv = 1024,max_exp = 75611913,attr = [{1,4092},{2,81840},{3,2046},{4,2046}],combat = 122880,is_tv = 0};

get_lv_cfg(1025) ->
	#pet_lv_cfg{lv = 1025,max_exp = 76223235,attr = [{1,4096},{2,81920},{3,2048},{4,2048}],combat = 123000,is_tv = 0};

get_lv_cfg(1026) ->
	#pet_lv_cfg{lv = 1026,max_exp = 76839500,attr = [{1,4100},{2,82000},{3,2050},{4,2050}],combat = 123120,is_tv = 0};

get_lv_cfg(1027) ->
	#pet_lv_cfg{lv = 1027,max_exp = 77460747,attr = [{1,4104},{2,82080},{3,2052},{4,2052}],combat = 123240,is_tv = 0};

get_lv_cfg(1028) ->
	#pet_lv_cfg{lv = 1028,max_exp = 78087017,attr = [{1,4108},{2,82160},{3,2054},{4,2054}],combat = 123360,is_tv = 0};

get_lv_cfg(1029) ->
	#pet_lv_cfg{lv = 1029,max_exp = 78718351,attr = [{1,4112},{2,82240},{3,2056},{4,2056}],combat = 123480,is_tv = 0};

get_lv_cfg(1030) ->
	#pet_lv_cfg{lv = 1030,max_exp = 79354789,attr = [{1,4116},{2,82320},{3,2058},{4,2058}],combat = 123600,is_tv = 0};

get_lv_cfg(1031) ->
	#pet_lv_cfg{lv = 1031,max_exp = 79996372,attr = [{1,4120},{2,82400},{3,2060},{4,2060}],combat = 123720,is_tv = 0};

get_lv_cfg(1032) ->
	#pet_lv_cfg{lv = 1032,max_exp = 80643143,attr = [{1,4124},{2,82480},{3,2062},{4,2062}],combat = 123840,is_tv = 0};

get_lv_cfg(1033) ->
	#pet_lv_cfg{lv = 1033,max_exp = 81295143,attr = [{1,4128},{2,82560},{3,2064},{4,2064}],combat = 123960,is_tv = 0};

get_lv_cfg(1034) ->
	#pet_lv_cfg{lv = 1034,max_exp = 81952414,attr = [{1,4132},{2,82640},{3,2066},{4,2066}],combat = 124080,is_tv = 0};

get_lv_cfg(1035) ->
	#pet_lv_cfg{lv = 1035,max_exp = 82614999,attr = [{1,4136},{2,82720},{3,2068},{4,2068}],combat = 124200,is_tv = 0};

get_lv_cfg(1036) ->
	#pet_lv_cfg{lv = 1036,max_exp = 83282941,attr = [{1,4140},{2,82800},{3,2070},{4,2070}],combat = 124320,is_tv = 0};

get_lv_cfg(1037) ->
	#pet_lv_cfg{lv = 1037,max_exp = 83956284,attr = [{1,4144},{2,82880},{3,2072},{4,2072}],combat = 124440,is_tv = 0};

get_lv_cfg(1038) ->
	#pet_lv_cfg{lv = 1038,max_exp = 84635071,attr = [{1,4148},{2,82960},{3,2074},{4,2074}],combat = 124560,is_tv = 0};

get_lv_cfg(1039) ->
	#pet_lv_cfg{lv = 1039,max_exp = 85319346,attr = [{1,4152},{2,83040},{3,2076},{4,2076}],combat = 124680,is_tv = 0};

get_lv_cfg(1040) ->
	#pet_lv_cfg{lv = 1040,max_exp = 86009153,attr = [{1,4156},{2,83120},{3,2078},{4,2078}],combat = 124800,is_tv = 0};

get_lv_cfg(1041) ->
	#pet_lv_cfg{lv = 1041,max_exp = 86704537,attr = [{1,4160},{2,83200},{3,2080},{4,2080}],combat = 124920,is_tv = 0};

get_lv_cfg(1042) ->
	#pet_lv_cfg{lv = 1042,max_exp = 87405543,attr = [{1,4164},{2,83280},{3,2082},{4,2082}],combat = 125040,is_tv = 0};

get_lv_cfg(1043) ->
	#pet_lv_cfg{lv = 1043,max_exp = 88112217,attr = [{1,4168},{2,83360},{3,2084},{4,2084}],combat = 125160,is_tv = 0};

get_lv_cfg(1044) ->
	#pet_lv_cfg{lv = 1044,max_exp = 88824604,attr = [{1,4172},{2,83440},{3,2086},{4,2086}],combat = 125280,is_tv = 0};

get_lv_cfg(1045) ->
	#pet_lv_cfg{lv = 1045,max_exp = 89542751,attr = [{1,4176},{2,83520},{3,2088},{4,2088}],combat = 125400,is_tv = 0};

get_lv_cfg(1046) ->
	#pet_lv_cfg{lv = 1046,max_exp = 90266704,attr = [{1,4180},{2,83600},{3,2090},{4,2090}],combat = 125520,is_tv = 0};

get_lv_cfg(1047) ->
	#pet_lv_cfg{lv = 1047,max_exp = 90996510,attr = [{1,4184},{2,83680},{3,2092},{4,2092}],combat = 125640,is_tv = 0};

get_lv_cfg(1048) ->
	#pet_lv_cfg{lv = 1048,max_exp = 91732217,attr = [{1,4188},{2,83760},{3,2094},{4,2094}],combat = 125760,is_tv = 0};

get_lv_cfg(1049) ->
	#pet_lv_cfg{lv = 1049,max_exp = 92473872,attr = [{1,4192},{2,83840},{3,2096},{4,2096}],combat = 125880,is_tv = 0};

get_lv_cfg(1050) ->
	#pet_lv_cfg{lv = 1050,max_exp = 93221523,attr = [{1,4196},{2,83920},{3,2098},{4,2098}],combat = 126000,is_tv = 0};

get_lv_cfg(1051) ->
	#pet_lv_cfg{lv = 1051,max_exp = 93975219,attr = [{1,4200},{2,84000},{3,2100},{4,2100}],combat = 126120,is_tv = 0};

get_lv_cfg(1052) ->
	#pet_lv_cfg{lv = 1052,max_exp = 94735009,attr = [{1,4204},{2,84080},{3,2102},{4,2102}],combat = 126240,is_tv = 0};

get_lv_cfg(1053) ->
	#pet_lv_cfg{lv = 1053,max_exp = 95500942,attr = [{1,4208},{2,84160},{3,2104},{4,2104}],combat = 126360,is_tv = 0};

get_lv_cfg(1054) ->
	#pet_lv_cfg{lv = 1054,max_exp = 96273067,attr = [{1,4212},{2,84240},{3,2106},{4,2106}],combat = 126480,is_tv = 0};

get_lv_cfg(1055) ->
	#pet_lv_cfg{lv = 1055,max_exp = 97051435,attr = [{1,4216},{2,84320},{3,2108},{4,2108}],combat = 126600,is_tv = 0};

get_lv_cfg(1056) ->
	#pet_lv_cfg{lv = 1056,max_exp = 97836096,attr = [{1,4220},{2,84400},{3,2110},{4,2110}],combat = 126720,is_tv = 0};

get_lv_cfg(1057) ->
	#pet_lv_cfg{lv = 1057,max_exp = 98627101,attr = [{1,4224},{2,84480},{3,2112},{4,2112}],combat = 126840,is_tv = 0};

get_lv_cfg(1058) ->
	#pet_lv_cfg{lv = 1058,max_exp = 99424501,attr = [{1,4228},{2,84560},{3,2114},{4,2114}],combat = 126960,is_tv = 0};

get_lv_cfg(1059) ->
	#pet_lv_cfg{lv = 1059,max_exp = 100228348,attr = [{1,4232},{2,84640},{3,2116},{4,2116}],combat = 127080,is_tv = 0};

get_lv_cfg(1060) ->
	#pet_lv_cfg{lv = 1060,max_exp = 101038694,attr = [{1,4236},{2,84720},{3,2118},{4,2118}],combat = 127200,is_tv = 0};

get_lv_cfg(1061) ->
	#pet_lv_cfg{lv = 1061,max_exp = 101855592,attr = [{1,4240},{2,84800},{3,2120},{4,2120}],combat = 127320,is_tv = 0};

get_lv_cfg(1062) ->
	#pet_lv_cfg{lv = 1062,max_exp = 102679094,attr = [{1,4244},{2,84880},{3,2122},{4,2122}],combat = 127440,is_tv = 0};

get_lv_cfg(1063) ->
	#pet_lv_cfg{lv = 1063,max_exp = 103509254,attr = [{1,4248},{2,84960},{3,2124},{4,2124}],combat = 127560,is_tv = 0};

get_lv_cfg(1064) ->
	#pet_lv_cfg{lv = 1064,max_exp = 104346126,attr = [{1,4252},{2,85040},{3,2126},{4,2126}],combat = 127680,is_tv = 0};

get_lv_cfg(1065) ->
	#pet_lv_cfg{lv = 1065,max_exp = 105189764,attr = [{1,4256},{2,85120},{3,2128},{4,2128}],combat = 127800,is_tv = 0};

get_lv_cfg(1066) ->
	#pet_lv_cfg{lv = 1066,max_exp = 106040223,attr = [{1,4260},{2,85200},{3,2130},{4,2130}],combat = 127920,is_tv = 0};

get_lv_cfg(1067) ->
	#pet_lv_cfg{lv = 1067,max_exp = 106897558,attr = [{1,4264},{2,85280},{3,2132},{4,2132}],combat = 128040,is_tv = 0};

get_lv_cfg(1068) ->
	#pet_lv_cfg{lv = 1068,max_exp = 107761825,attr = [{1,4268},{2,85360},{3,2134},{4,2134}],combat = 128160,is_tv = 0};

get_lv_cfg(1069) ->
	#pet_lv_cfg{lv = 1069,max_exp = 108633079,attr = [{1,4272},{2,85440},{3,2136},{4,2136}],combat = 128280,is_tv = 0};

get_lv_cfg(1070) ->
	#pet_lv_cfg{lv = 1070,max_exp = 109511377,attr = [{1,4276},{2,85520},{3,2138},{4,2138}],combat = 128400,is_tv = 0};

get_lv_cfg(1071) ->
	#pet_lv_cfg{lv = 1071,max_exp = 110396776,attr = [{1,4280},{2,85600},{3,2140},{4,2140}],combat = 128520,is_tv = 0};

get_lv_cfg(1072) ->
	#pet_lv_cfg{lv = 1072,max_exp = 111289334,attr = [{1,4284},{2,85680},{3,2142},{4,2142}],combat = 128640,is_tv = 0};

get_lv_cfg(1073) ->
	#pet_lv_cfg{lv = 1073,max_exp = 112189108,attr = [{1,4288},{2,85760},{3,2144},{4,2144}],combat = 128760,is_tv = 0};

get_lv_cfg(1074) ->
	#pet_lv_cfg{lv = 1074,max_exp = 113096157,attr = [{1,4292},{2,85840},{3,2146},{4,2146}],combat = 128880,is_tv = 0};

get_lv_cfg(1075) ->
	#pet_lv_cfg{lv = 1075,max_exp = 114010539,attr = [{1,4296},{2,85920},{3,2148},{4,2148}],combat = 129000,is_tv = 0};

get_lv_cfg(1076) ->
	#pet_lv_cfg{lv = 1076,max_exp = 114932314,attr = [{1,4300},{2,86000},{3,2150},{4,2150}],combat = 129120,is_tv = 0};

get_lv_cfg(1077) ->
	#pet_lv_cfg{lv = 1077,max_exp = 115861542,attr = [{1,4304},{2,86080},{3,2152},{4,2152}],combat = 129240,is_tv = 0};

get_lv_cfg(1078) ->
	#pet_lv_cfg{lv = 1078,max_exp = 116798283,attr = [{1,4308},{2,86160},{3,2154},{4,2154}],combat = 129360,is_tv = 0};

get_lv_cfg(1079) ->
	#pet_lv_cfg{lv = 1079,max_exp = 117742597,attr = [{1,4312},{2,86240},{3,2156},{4,2156}],combat = 129480,is_tv = 0};

get_lv_cfg(1080) ->
	#pet_lv_cfg{lv = 1080,max_exp = 118694546,attr = [{1,4316},{2,86320},{3,2158},{4,2158}],combat = 129600,is_tv = 0};

get_lv_cfg(1081) ->
	#pet_lv_cfg{lv = 1081,max_exp = 119654191,attr = [{1,4320},{2,86400},{3,2160},{4,2160}],combat = 129720,is_tv = 0};

get_lv_cfg(1082) ->
	#pet_lv_cfg{lv = 1082,max_exp = 120621595,attr = [{1,4324},{2,86480},{3,2162},{4,2162}],combat = 129840,is_tv = 0};

get_lv_cfg(1083) ->
	#pet_lv_cfg{lv = 1083,max_exp = 121596821,attr = [{1,4328},{2,86560},{3,2164},{4,2164}],combat = 129960,is_tv = 0};

get_lv_cfg(1084) ->
	#pet_lv_cfg{lv = 1084,max_exp = 122579931,attr = [{1,4332},{2,86640},{3,2166},{4,2166}],combat = 130080,is_tv = 0};

get_lv_cfg(1085) ->
	#pet_lv_cfg{lv = 1085,max_exp = 123570990,attr = [{1,4336},{2,86720},{3,2168},{4,2168}],combat = 130200,is_tv = 0};

get_lv_cfg(1086) ->
	#pet_lv_cfg{lv = 1086,max_exp = 124570061,attr = [{1,4340},{2,86800},{3,2170},{4,2170}],combat = 130320,is_tv = 0};

get_lv_cfg(1087) ->
	#pet_lv_cfg{lv = 1087,max_exp = 125577210,attr = [{1,4344},{2,86880},{3,2172},{4,2172}],combat = 130440,is_tv = 0};

get_lv_cfg(1088) ->
	#pet_lv_cfg{lv = 1088,max_exp = 126592502,attr = [{1,4348},{2,86960},{3,2174},{4,2174}],combat = 130560,is_tv = 0};

get_lv_cfg(1089) ->
	#pet_lv_cfg{lv = 1089,max_exp = 127616002,attr = [{1,4352},{2,87040},{3,2176},{4,2176}],combat = 130680,is_tv = 0};

get_lv_cfg(1090) ->
	#pet_lv_cfg{lv = 1090,max_exp = 128647777,attr = [{1,4356},{2,87120},{3,2178},{4,2178}],combat = 130800,is_tv = 0};

get_lv_cfg(1091) ->
	#pet_lv_cfg{lv = 1091,max_exp = 129687894,attr = [{1,4360},{2,87200},{3,2180},{4,2180}],combat = 130920,is_tv = 0};

get_lv_cfg(1092) ->
	#pet_lv_cfg{lv = 1092,max_exp = 130736421,attr = [{1,4364},{2,87280},{3,2182},{4,2182}],combat = 131040,is_tv = 0};

get_lv_cfg(1093) ->
	#pet_lv_cfg{lv = 1093,max_exp = 131793425,attr = [{1,4368},{2,87360},{3,2184},{4,2184}],combat = 131160,is_tv = 0};

get_lv_cfg(1094) ->
	#pet_lv_cfg{lv = 1094,max_exp = 132858975,attr = [{1,4372},{2,87440},{3,2186},{4,2186}],combat = 131280,is_tv = 0};

get_lv_cfg(1095) ->
	#pet_lv_cfg{lv = 1095,max_exp = 133933140,attr = [{1,4376},{2,87520},{3,2188},{4,2188}],combat = 131400,is_tv = 0};

get_lv_cfg(1096) ->
	#pet_lv_cfg{lv = 1096,max_exp = 135015989,attr = [{1,4380},{2,87600},{3,2190},{4,2190}],combat = 131520,is_tv = 0};

get_lv_cfg(1097) ->
	#pet_lv_cfg{lv = 1097,max_exp = 136107593,attr = [{1,4384},{2,87680},{3,2192},{4,2192}],combat = 131640,is_tv = 0};

get_lv_cfg(1098) ->
	#pet_lv_cfg{lv = 1098,max_exp = 137208023,attr = [{1,4388},{2,87760},{3,2194},{4,2194}],combat = 131760,is_tv = 0};

get_lv_cfg(1099) ->
	#pet_lv_cfg{lv = 1099,max_exp = 138317350,attr = [{1,4392},{2,87840},{3,2196},{4,2196}],combat = 131880,is_tv = 0};

get_lv_cfg(1100) ->
	#pet_lv_cfg{lv = 1100,max_exp = 139435646,attr = [{1,4396},{2,87920},{3,2198},{4,2198}],combat = 132000,is_tv = 1};

get_lv_cfg(1101) ->
	#pet_lv_cfg{lv = 1101,max_exp = 140562983,attr = [{1,4400},{2,88000},{3,2200},{4,2200}],combat = 132120,is_tv = 0};

get_lv_cfg(1102) ->
	#pet_lv_cfg{lv = 1102,max_exp = 141699435,attr = [{1,4404},{2,88080},{3,2202},{4,2202}],combat = 132240,is_tv = 0};

get_lv_cfg(1103) ->
	#pet_lv_cfg{lv = 1103,max_exp = 142845075,attr = [{1,4408},{2,88160},{3,2204},{4,2204}],combat = 132360,is_tv = 0};

get_lv_cfg(1104) ->
	#pet_lv_cfg{lv = 1104,max_exp = 143999977,attr = [{1,4412},{2,88240},{3,2206},{4,2206}],combat = 132480,is_tv = 0};

get_lv_cfg(1105) ->
	#pet_lv_cfg{lv = 1105,max_exp = 145164217,attr = [{1,4416},{2,88320},{3,2208},{4,2208}],combat = 132600,is_tv = 0};

get_lv_cfg(1106) ->
	#pet_lv_cfg{lv = 1106,max_exp = 146337870,attr = [{1,4420},{2,88400},{3,2210},{4,2210}],combat = 132720,is_tv = 0};

get_lv_cfg(1107) ->
	#pet_lv_cfg{lv = 1107,max_exp = 147521012,attr = [{1,4424},{2,88480},{3,2212},{4,2212}],combat = 132840,is_tv = 0};

get_lv_cfg(1108) ->
	#pet_lv_cfg{lv = 1108,max_exp = 148713719,attr = [{1,4428},{2,88560},{3,2214},{4,2214}],combat = 132960,is_tv = 0};

get_lv_cfg(1109) ->
	#pet_lv_cfg{lv = 1109,max_exp = 149916069,attr = [{1,4432},{2,88640},{3,2216},{4,2216}],combat = 133080,is_tv = 0};

get_lv_cfg(1110) ->
	#pet_lv_cfg{lv = 1110,max_exp = 151128140,attr = [{1,4436},{2,88720},{3,2218},{4,2218}],combat = 133200,is_tv = 0};

get_lv_cfg(1111) ->
	#pet_lv_cfg{lv = 1111,max_exp = 152350011,attr = [{1,4440},{2,88800},{3,2220},{4,2220}],combat = 133320,is_tv = 0};

get_lv_cfg(1112) ->
	#pet_lv_cfg{lv = 1112,max_exp = 153581761,attr = [{1,4444},{2,88880},{3,2222},{4,2222}],combat = 133440,is_tv = 0};

get_lv_cfg(1113) ->
	#pet_lv_cfg{lv = 1113,max_exp = 154823470,attr = [{1,4448},{2,88960},{3,2224},{4,2224}],combat = 133560,is_tv = 0};

get_lv_cfg(1114) ->
	#pet_lv_cfg{lv = 1114,max_exp = 156075218,attr = [{1,4452},{2,89040},{3,2226},{4,2226}],combat = 133680,is_tv = 0};

get_lv_cfg(1115) ->
	#pet_lv_cfg{lv = 1115,max_exp = 157337086,attr = [{1,4456},{2,89120},{3,2228},{4,2228}],combat = 133800,is_tv = 0};

get_lv_cfg(1116) ->
	#pet_lv_cfg{lv = 1116,max_exp = 158609156,attr = [{1,4460},{2,89200},{3,2230},{4,2230}],combat = 133920,is_tv = 0};

get_lv_cfg(1117) ->
	#pet_lv_cfg{lv = 1117,max_exp = 159891511,attr = [{1,4464},{2,89280},{3,2232},{4,2232}],combat = 134040,is_tv = 0};

get_lv_cfg(1118) ->
	#pet_lv_cfg{lv = 1118,max_exp = 161184234,attr = [{1,4468},{2,89360},{3,2234},{4,2234}],combat = 134160,is_tv = 0};

get_lv_cfg(1119) ->
	#pet_lv_cfg{lv = 1119,max_exp = 162487409,attr = [{1,4472},{2,89440},{3,2236},{4,2236}],combat = 134280,is_tv = 0};

get_lv_cfg(1120) ->
	#pet_lv_cfg{lv = 1120,max_exp = 163801120,attr = [{1,4476},{2,89520},{3,2238},{4,2238}],combat = 134400,is_tv = 0};

get_lv_cfg(1121) ->
	#pet_lv_cfg{lv = 1121,max_exp = 165125452,attr = [{1,4480},{2,89600},{3,2240},{4,2240}],combat = 134520,is_tv = 0};

get_lv_cfg(1122) ->
	#pet_lv_cfg{lv = 1122,max_exp = 166460491,attr = [{1,4484},{2,89680},{3,2242},{4,2242}],combat = 134640,is_tv = 0};

get_lv_cfg(1123) ->
	#pet_lv_cfg{lv = 1123,max_exp = 167806324,attr = [{1,4488},{2,89760},{3,2244},{4,2244}],combat = 134760,is_tv = 0};

get_lv_cfg(1124) ->
	#pet_lv_cfg{lv = 1124,max_exp = 169163038,attr = [{1,4492},{2,89840},{3,2246},{4,2246}],combat = 134880,is_tv = 0};

get_lv_cfg(1125) ->
	#pet_lv_cfg{lv = 1125,max_exp = 170530721,attr = [{1,4496},{2,89920},{3,2248},{4,2248}],combat = 135000,is_tv = 0};

get_lv_cfg(1126) ->
	#pet_lv_cfg{lv = 1126,max_exp = 171909462,attr = [{1,4500},{2,90000},{3,2250},{4,2250}],combat = 135120,is_tv = 0};

get_lv_cfg(1127) ->
	#pet_lv_cfg{lv = 1127,max_exp = 173299350,attr = [{1,4504},{2,90080},{3,2252},{4,2252}],combat = 135240,is_tv = 0};

get_lv_cfg(1128) ->
	#pet_lv_cfg{lv = 1128,max_exp = 174700475,attr = [{1,4508},{2,90160},{3,2254},{4,2254}],combat = 135360,is_tv = 0};

get_lv_cfg(1129) ->
	#pet_lv_cfg{lv = 1129,max_exp = 176112928,attr = [{1,4512},{2,90240},{3,2256},{4,2256}],combat = 135480,is_tv = 0};

get_lv_cfg(1130) ->
	#pet_lv_cfg{lv = 1130,max_exp = 177536801,attr = [{1,4516},{2,90320},{3,2258},{4,2258}],combat = 135600,is_tv = 0};

get_lv_cfg(1131) ->
	#pet_lv_cfg{lv = 1131,max_exp = 178972186,attr = [{1,4520},{2,90400},{3,2260},{4,2260}],combat = 135720,is_tv = 0};

get_lv_cfg(1132) ->
	#pet_lv_cfg{lv = 1132,max_exp = 180419176,attr = [{1,4524},{2,90480},{3,2262},{4,2262}],combat = 135840,is_tv = 0};

get_lv_cfg(1133) ->
	#pet_lv_cfg{lv = 1133,max_exp = 181877865,attr = [{1,4528},{2,90560},{3,2264},{4,2264}],combat = 135960,is_tv = 0};

get_lv_cfg(1134) ->
	#pet_lv_cfg{lv = 1134,max_exp = 183348348,attr = [{1,4532},{2,90640},{3,2266},{4,2266}],combat = 136080,is_tv = 0};

get_lv_cfg(1135) ->
	#pet_lv_cfg{lv = 1135,max_exp = 184830719,attr = [{1,4536},{2,90720},{3,2268},{4,2268}],combat = 136200,is_tv = 0};

get_lv_cfg(1136) ->
	#pet_lv_cfg{lv = 1136,max_exp = 186325075,attr = [{1,4540},{2,90800},{3,2270},{4,2270}],combat = 136320,is_tv = 0};

get_lv_cfg(1137) ->
	#pet_lv_cfg{lv = 1137,max_exp = 187831513,attr = [{1,4544},{2,90880},{3,2272},{4,2272}],combat = 136440,is_tv = 0};

get_lv_cfg(1138) ->
	#pet_lv_cfg{lv = 1138,max_exp = 189350131,attr = [{1,4548},{2,90960},{3,2274},{4,2274}],combat = 136560,is_tv = 0};

get_lv_cfg(1139) ->
	#pet_lv_cfg{lv = 1139,max_exp = 190881027,attr = [{1,4552},{2,91040},{3,2276},{4,2276}],combat = 136680,is_tv = 0};

get_lv_cfg(1140) ->
	#pet_lv_cfg{lv = 1140,max_exp = 192424300,attr = [{1,4556},{2,91120},{3,2278},{4,2278}],combat = 136800,is_tv = 0};

get_lv_cfg(1141) ->
	#pet_lv_cfg{lv = 1141,max_exp = 193980050,attr = [{1,4560},{2,91200},{3,2280},{4,2280}],combat = 136920,is_tv = 0};

get_lv_cfg(1142) ->
	#pet_lv_cfg{lv = 1142,max_exp = 195548379,attr = [{1,4564},{2,91280},{3,2282},{4,2282}],combat = 137040,is_tv = 0};

get_lv_cfg(1143) ->
	#pet_lv_cfg{lv = 1143,max_exp = 197129388,attr = [{1,4568},{2,91360},{3,2284},{4,2284}],combat = 137160,is_tv = 0};

get_lv_cfg(1144) ->
	#pet_lv_cfg{lv = 1144,max_exp = 198723179,attr = [{1,4572},{2,91440},{3,2286},{4,2286}],combat = 137280,is_tv = 0};

get_lv_cfg(1145) ->
	#pet_lv_cfg{lv = 1145,max_exp = 200329856,attr = [{1,4576},{2,91520},{3,2288},{4,2288}],combat = 137400,is_tv = 0};

get_lv_cfg(1146) ->
	#pet_lv_cfg{lv = 1146,max_exp = 201949523,attr = [{1,4580},{2,91600},{3,2290},{4,2290}],combat = 137520,is_tv = 0};

get_lv_cfg(1147) ->
	#pet_lv_cfg{lv = 1147,max_exp = 203582285,attr = [{1,4584},{2,91680},{3,2292},{4,2292}],combat = 137640,is_tv = 0};

get_lv_cfg(1148) ->
	#pet_lv_cfg{lv = 1148,max_exp = 205228248,attr = [{1,4588},{2,91760},{3,2294},{4,2294}],combat = 137760,is_tv = 0};

get_lv_cfg(1149) ->
	#pet_lv_cfg{lv = 1149,max_exp = 206887518,attr = [{1,4592},{2,91840},{3,2296},{4,2296}],combat = 137880,is_tv = 0};

get_lv_cfg(1150) ->
	#pet_lv_cfg{lv = 1150,max_exp = 208560204,attr = [{1,4596},{2,91920},{3,2298},{4,2298}],combat = 138000,is_tv = 1};

get_lv_cfg(1151) ->
	#pet_lv_cfg{lv = 1151,max_exp = 210246413,attr = [{1,4600},{2,92000},{3,2300},{4,2300}],combat = 138120,is_tv = 0};

get_lv_cfg(1152) ->
	#pet_lv_cfg{lv = 1152,max_exp = 211946255,attr = [{1,4604},{2,92080},{3,2302},{4,2302}],combat = 138240,is_tv = 0};

get_lv_cfg(1153) ->
	#pet_lv_cfg{lv = 1153,max_exp = 213659840,attr = [{1,4608},{2,92160},{3,2304},{4,2304}],combat = 138360,is_tv = 0};

get_lv_cfg(1154) ->
	#pet_lv_cfg{lv = 1154,max_exp = 215387280,attr = [{1,4612},{2,92240},{3,2306},{4,2306}],combat = 138480,is_tv = 0};

get_lv_cfg(1155) ->
	#pet_lv_cfg{lv = 1155,max_exp = 217128686,attr = [{1,4616},{2,92320},{3,2308},{4,2308}],combat = 138600,is_tv = 0};

get_lv_cfg(1156) ->
	#pet_lv_cfg{lv = 1156,max_exp = 218884171,attr = [{1,4620},{2,92400},{3,2310},{4,2310}],combat = 138720,is_tv = 0};

get_lv_cfg(1157) ->
	#pet_lv_cfg{lv = 1157,max_exp = 220653850,attr = [{1,4624},{2,92480},{3,2312},{4,2312}],combat = 138840,is_tv = 0};

get_lv_cfg(1158) ->
	#pet_lv_cfg{lv = 1158,max_exp = 222437836,attr = [{1,4628},{2,92560},{3,2314},{4,2314}],combat = 138960,is_tv = 0};

get_lv_cfg(1159) ->
	#pet_lv_cfg{lv = 1159,max_exp = 224236246,attr = [{1,4632},{2,92640},{3,2316},{4,2316}],combat = 139080,is_tv = 0};

get_lv_cfg(1160) ->
	#pet_lv_cfg{lv = 1160,max_exp = 226049196,attr = [{1,4636},{2,92720},{3,2318},{4,2318}],combat = 139200,is_tv = 0};

get_lv_cfg(1161) ->
	#pet_lv_cfg{lv = 1161,max_exp = 227876804,attr = [{1,4640},{2,92800},{3,2320},{4,2320}],combat = 139320,is_tv = 0};

get_lv_cfg(1162) ->
	#pet_lv_cfg{lv = 1162,max_exp = 229719188,attr = [{1,4644},{2,92880},{3,2322},{4,2322}],combat = 139440,is_tv = 0};

get_lv_cfg(1163) ->
	#pet_lv_cfg{lv = 1163,max_exp = 231576468,attr = [{1,4648},{2,92960},{3,2324},{4,2324}],combat = 139560,is_tv = 0};

get_lv_cfg(1164) ->
	#pet_lv_cfg{lv = 1164,max_exp = 233448764,attr = [{1,4652},{2,93040},{3,2326},{4,2326}],combat = 139680,is_tv = 0};

get_lv_cfg(1165) ->
	#pet_lv_cfg{lv = 1165,max_exp = 235336197,attr = [{1,4656},{2,93120},{3,2328},{4,2328}],combat = 139800,is_tv = 0};

get_lv_cfg(1166) ->
	#pet_lv_cfg{lv = 1166,max_exp = 237238890,attr = [{1,4660},{2,93200},{3,2330},{4,2330}],combat = 139920,is_tv = 0};

get_lv_cfg(1167) ->
	#pet_lv_cfg{lv = 1167,max_exp = 239156966,attr = [{1,4664},{2,93280},{3,2332},{4,2332}],combat = 140040,is_tv = 0};

get_lv_cfg(1168) ->
	#pet_lv_cfg{lv = 1168,max_exp = 241090550,attr = [{1,4668},{2,93360},{3,2334},{4,2334}],combat = 140160,is_tv = 0};

get_lv_cfg(1169) ->
	#pet_lv_cfg{lv = 1169,max_exp = 243039767,attr = [{1,4672},{2,93440},{3,2336},{4,2336}],combat = 140280,is_tv = 0};

get_lv_cfg(1170) ->
	#pet_lv_cfg{lv = 1170,max_exp = 245004744,attr = [{1,4676},{2,93520},{3,2338},{4,2338}],combat = 140400,is_tv = 0};

get_lv_cfg(1171) ->
	#pet_lv_cfg{lv = 1171,max_exp = 246985607,attr = [{1,4680},{2,93600},{3,2340},{4,2340}],combat = 140520,is_tv = 0};

get_lv_cfg(1172) ->
	#pet_lv_cfg{lv = 1172,max_exp = 248982486,attr = [{1,4684},{2,93680},{3,2342},{4,2342}],combat = 140640,is_tv = 0};

get_lv_cfg(1173) ->
	#pet_lv_cfg{lv = 1173,max_exp = 250995509,attr = [{1,4688},{2,93760},{3,2344},{4,2344}],combat = 140760,is_tv = 0};

get_lv_cfg(1174) ->
	#pet_lv_cfg{lv = 1174,max_exp = 253024808,attr = [{1,4692},{2,93840},{3,2346},{4,2346}],combat = 140880,is_tv = 0};

get_lv_cfg(1175) ->
	#pet_lv_cfg{lv = 1175,max_exp = 255070514,attr = [{1,4696},{2,93920},{3,2348},{4,2348}],combat = 141000,is_tv = 0};

get_lv_cfg(1176) ->
	#pet_lv_cfg{lv = 1176,max_exp = 257132759,attr = [{1,4700},{2,94000},{3,2350},{4,2350}],combat = 141120,is_tv = 0};

get_lv_cfg(1177) ->
	#pet_lv_cfg{lv = 1177,max_exp = 259211677,attr = [{1,4704},{2,94080},{3,2352},{4,2352}],combat = 141240,is_tv = 0};

get_lv_cfg(1178) ->
	#pet_lv_cfg{lv = 1178,max_exp = 261307403,attr = [{1,4708},{2,94160},{3,2354},{4,2354}],combat = 141360,is_tv = 0};

get_lv_cfg(1179) ->
	#pet_lv_cfg{lv = 1179,max_exp = 263420073,attr = [{1,4712},{2,94240},{3,2356},{4,2356}],combat = 141480,is_tv = 0};

get_lv_cfg(1180) ->
	#pet_lv_cfg{lv = 1180,max_exp = 265549824,attr = [{1,4716},{2,94320},{3,2358},{4,2358}],combat = 141600,is_tv = 0};

get_lv_cfg(1181) ->
	#pet_lv_cfg{lv = 1181,max_exp = 267696794,attr = [{1,4720},{2,94400},{3,2360},{4,2360}],combat = 141720,is_tv = 0};

get_lv_cfg(1182) ->
	#pet_lv_cfg{lv = 1182,max_exp = 269861123,attr = [{1,4724},{2,94480},{3,2362},{4,2362}],combat = 141840,is_tv = 0};

get_lv_cfg(1183) ->
	#pet_lv_cfg{lv = 1183,max_exp = 272042950,attr = [{1,4728},{2,94560},{3,2364},{4,2364}],combat = 141960,is_tv = 0};

get_lv_cfg(1184) ->
	#pet_lv_cfg{lv = 1184,max_exp = 274242417,attr = [{1,4732},{2,94640},{3,2366},{4,2366}],combat = 142080,is_tv = 0};

get_lv_cfg(1185) ->
	#pet_lv_cfg{lv = 1185,max_exp = 276459667,attr = [{1,4736},{2,94720},{3,2368},{4,2368}],combat = 142200,is_tv = 0};

get_lv_cfg(1186) ->
	#pet_lv_cfg{lv = 1186,max_exp = 278694843,attr = [{1,4740},{2,94800},{3,2370},{4,2370}],combat = 142320,is_tv = 0};

get_lv_cfg(1187) ->
	#pet_lv_cfg{lv = 1187,max_exp = 280948091,attr = [{1,4744},{2,94880},{3,2372},{4,2372}],combat = 142440,is_tv = 0};

get_lv_cfg(1188) ->
	#pet_lv_cfg{lv = 1188,max_exp = 283219556,attr = [{1,4748},{2,94960},{3,2374},{4,2374}],combat = 142560,is_tv = 0};

get_lv_cfg(1189) ->
	#pet_lv_cfg{lv = 1189,max_exp = 285509386,attr = [{1,4752},{2,95040},{3,2376},{4,2376}],combat = 142680,is_tv = 0};

get_lv_cfg(1190) ->
	#pet_lv_cfg{lv = 1190,max_exp = 287817729,attr = [{1,4756},{2,95120},{3,2378},{4,2378}],combat = 142800,is_tv = 0};

get_lv_cfg(1191) ->
	#pet_lv_cfg{lv = 1191,max_exp = 290144735,attr = [{1,4760},{2,95200},{3,2380},{4,2380}],combat = 142920,is_tv = 0};

get_lv_cfg(1192) ->
	#pet_lv_cfg{lv = 1192,max_exp = 292490555,attr = [{1,4764},{2,95280},{3,2382},{4,2382}],combat = 143040,is_tv = 0};

get_lv_cfg(1193) ->
	#pet_lv_cfg{lv = 1193,max_exp = 294855341,attr = [{1,4768},{2,95360},{3,2384},{4,2384}],combat = 143160,is_tv = 0};

get_lv_cfg(1194) ->
	#pet_lv_cfg{lv = 1194,max_exp = 297239246,attr = [{1,4772},{2,95440},{3,2386},{4,2386}],combat = 143280,is_tv = 0};

get_lv_cfg(1195) ->
	#pet_lv_cfg{lv = 1195,max_exp = 299642425,attr = [{1,4776},{2,95520},{3,2388},{4,2388}],combat = 143400,is_tv = 0};

get_lv_cfg(1196) ->
	#pet_lv_cfg{lv = 1196,max_exp = 302065034,attr = [{1,4780},{2,95600},{3,2390},{4,2390}],combat = 143520,is_tv = 0};

get_lv_cfg(1197) ->
	#pet_lv_cfg{lv = 1197,max_exp = 304507230,attr = [{1,4784},{2,95680},{3,2392},{4,2392}],combat = 143640,is_tv = 0};

get_lv_cfg(1198) ->
	#pet_lv_cfg{lv = 1198,max_exp = 306969171,attr = [{1,4788},{2,95760},{3,2394},{4,2394}],combat = 143760,is_tv = 0};

get_lv_cfg(1199) ->
	#pet_lv_cfg{lv = 1199,max_exp = 309451017,attr = [{1,4792},{2,95840},{3,2396},{4,2396}],combat = 143880,is_tv = 0};

get_lv_cfg(1200) ->
	#pet_lv_cfg{lv = 1200,max_exp = 311952928,attr = [{1,4796},{2,95920},{3,2398},{4,2398}],combat = 144000,is_tv = 1};

get_lv_cfg(1201) ->
	#pet_lv_cfg{lv = 1201,max_exp = 314475067,attr = [{1,4800},{2,96000},{3,2400},{4,2400}],combat = 144120,is_tv = 0};

get_lv_cfg(1202) ->
	#pet_lv_cfg{lv = 1202,max_exp = 317017598,attr = [{1,4804},{2,96080},{3,2402},{4,2402}],combat = 144240,is_tv = 0};

get_lv_cfg(1203) ->
	#pet_lv_cfg{lv = 1203,max_exp = 319580685,attr = [{1,4808},{2,96160},{3,2404},{4,2404}],combat = 144360,is_tv = 0};

get_lv_cfg(1204) ->
	#pet_lv_cfg{lv = 1204,max_exp = 322164495,attr = [{1,4812},{2,96240},{3,2406},{4,2406}],combat = 144480,is_tv = 0};

get_lv_cfg(1205) ->
	#pet_lv_cfg{lv = 1205,max_exp = 324769195,attr = [{1,4816},{2,96320},{3,2408},{4,2408}],combat = 144600,is_tv = 0};

get_lv_cfg(1206) ->
	#pet_lv_cfg{lv = 1206,max_exp = 327394954,attr = [{1,4820},{2,96400},{3,2410},{4,2410}],combat = 144720,is_tv = 0};

get_lv_cfg(1207) ->
	#pet_lv_cfg{lv = 1207,max_exp = 330041942,attr = [{1,4824},{2,96480},{3,2412},{4,2412}],combat = 144840,is_tv = 0};

get_lv_cfg(1208) ->
	#pet_lv_cfg{lv = 1208,max_exp = 332710331,attr = [{1,4828},{2,96560},{3,2414},{4,2414}],combat = 144960,is_tv = 0};

get_lv_cfg(1209) ->
	#pet_lv_cfg{lv = 1209,max_exp = 335400294,attr = [{1,4832},{2,96640},{3,2416},{4,2416}],combat = 145080,is_tv = 0};

get_lv_cfg(1210) ->
	#pet_lv_cfg{lv = 1210,max_exp = 338112005,attr = [{1,4836},{2,96720},{3,2418},{4,2418}],combat = 145200,is_tv = 0};

get_lv_cfg(1211) ->
	#pet_lv_cfg{lv = 1211,max_exp = 340845641,attr = [{1,4840},{2,96800},{3,2420},{4,2420}],combat = 145320,is_tv = 0};

get_lv_cfg(1212) ->
	#pet_lv_cfg{lv = 1212,max_exp = 343601378,attr = [{1,4844},{2,96880},{3,2422},{4,2422}],combat = 145440,is_tv = 0};

get_lv_cfg(1213) ->
	#pet_lv_cfg{lv = 1213,max_exp = 346379395,attr = [{1,4848},{2,96960},{3,2424},{4,2424}],combat = 145560,is_tv = 0};

get_lv_cfg(1214) ->
	#pet_lv_cfg{lv = 1214,max_exp = 349179872,attr = [{1,4852},{2,97040},{3,2426},{4,2426}],combat = 145680,is_tv = 0};

get_lv_cfg(1215) ->
	#pet_lv_cfg{lv = 1215,max_exp = 352002991,attr = [{1,4856},{2,97120},{3,2428},{4,2428}],combat = 145800,is_tv = 0};

get_lv_cfg(1216) ->
	#pet_lv_cfg{lv = 1216,max_exp = 354848935,attr = [{1,4860},{2,97200},{3,2430},{4,2430}],combat = 145920,is_tv = 0};

get_lv_cfg(1217) ->
	#pet_lv_cfg{lv = 1217,max_exp = 357717889,attr = [{1,4864},{2,97280},{3,2432},{4,2432}],combat = 146040,is_tv = 0};

get_lv_cfg(1218) ->
	#pet_lv_cfg{lv = 1218,max_exp = 360610038,attr = [{1,4868},{2,97360},{3,2434},{4,2434}],combat = 146160,is_tv = 0};

get_lv_cfg(1219) ->
	#pet_lv_cfg{lv = 1219,max_exp = 363525570,attr = [{1,4872},{2,97440},{3,2436},{4,2436}],combat = 146280,is_tv = 0};

get_lv_cfg(1220) ->
	#pet_lv_cfg{lv = 1220,max_exp = 366464674,attr = [{1,4876},{2,97520},{3,2438},{4,2438}],combat = 146400,is_tv = 0};

get_lv_cfg(1221) ->
	#pet_lv_cfg{lv = 1221,max_exp = 369427541,attr = [{1,4880},{2,97600},{3,2440},{4,2440}],combat = 146520,is_tv = 0};

get_lv_cfg(1222) ->
	#pet_lv_cfg{lv = 1222,max_exp = 372414363,attr = [{1,4884},{2,97680},{3,2442},{4,2442}],combat = 146640,is_tv = 0};

get_lv_cfg(1223) ->
	#pet_lv_cfg{lv = 1223,max_exp = 375425333,attr = [{1,4888},{2,97760},{3,2444},{4,2444}],combat = 146760,is_tv = 0};

get_lv_cfg(1224) ->
	#pet_lv_cfg{lv = 1224,max_exp = 378460647,attr = [{1,4892},{2,97840},{3,2446},{4,2446}],combat = 146880,is_tv = 0};

get_lv_cfg(1225) ->
	#pet_lv_cfg{lv = 1225,max_exp = 381520501,attr = [{1,4896},{2,97920},{3,2448},{4,2448}],combat = 147000,is_tv = 0};

get_lv_cfg(1226) ->
	#pet_lv_cfg{lv = 1226,max_exp = 384605094,attr = [{1,4900},{2,98000},{3,2450},{4,2450}],combat = 147120,is_tv = 0};

get_lv_cfg(1227) ->
	#pet_lv_cfg{lv = 1227,max_exp = 387714626,attr = [{1,4904},{2,98080},{3,2452},{4,2452}],combat = 147240,is_tv = 0};

get_lv_cfg(1228) ->
	#pet_lv_cfg{lv = 1228,max_exp = 390849299,attr = [{1,4908},{2,98160},{3,2454},{4,2454}],combat = 147360,is_tv = 0};

get_lv_cfg(1229) ->
	#pet_lv_cfg{lv = 1229,max_exp = 394009316,attr = [{1,4912},{2,98240},{3,2456},{4,2456}],combat = 147480,is_tv = 0};

get_lv_cfg(1230) ->
	#pet_lv_cfg{lv = 1230,max_exp = 397194881,attr = [{1,4916},{2,98320},{3,2458},{4,2458}],combat = 147600,is_tv = 0};

get_lv_cfg(1231) ->
	#pet_lv_cfg{lv = 1231,max_exp = 400406202,attr = [{1,4920},{2,98400},{3,2460},{4,2460}],combat = 147720,is_tv = 0};

get_lv_cfg(1232) ->
	#pet_lv_cfg{lv = 1232,max_exp = 403643486,attr = [{1,4924},{2,98480},{3,2462},{4,2462}],combat = 147840,is_tv = 0};

get_lv_cfg(1233) ->
	#pet_lv_cfg{lv = 1233,max_exp = 406906944,attr = [{1,4928},{2,98560},{3,2464},{4,2464}],combat = 147960,is_tv = 0};

get_lv_cfg(1234) ->
	#pet_lv_cfg{lv = 1234,max_exp = 410196787,attr = [{1,4932},{2,98640},{3,2466},{4,2466}],combat = 148080,is_tv = 0};

get_lv_cfg(1235) ->
	#pet_lv_cfg{lv = 1235,max_exp = 413513228,attr = [{1,4936},{2,98720},{3,2468},{4,2468}],combat = 148200,is_tv = 0};

get_lv_cfg(1236) ->
	#pet_lv_cfg{lv = 1236,max_exp = 416856482,attr = [{1,4940},{2,98800},{3,2470},{4,2470}],combat = 148320,is_tv = 0};

get_lv_cfg(1237) ->
	#pet_lv_cfg{lv = 1237,max_exp = 420226767,attr = [{1,4944},{2,98880},{3,2472},{4,2472}],combat = 148440,is_tv = 0};

get_lv_cfg(1238) ->
	#pet_lv_cfg{lv = 1238,max_exp = 423624300,attr = [{1,4948},{2,98960},{3,2474},{4,2474}],combat = 148560,is_tv = 0};

get_lv_cfg(1239) ->
	#pet_lv_cfg{lv = 1239,max_exp = 427049302,attr = [{1,4952},{2,99040},{3,2476},{4,2476}],combat = 148680,is_tv = 0};

get_lv_cfg(1240) ->
	#pet_lv_cfg{lv = 1240,max_exp = 430501996,attr = [{1,4956},{2,99120},{3,2478},{4,2478}],combat = 148800,is_tv = 0};

get_lv_cfg(1241) ->
	#pet_lv_cfg{lv = 1241,max_exp = 433982605,attr = [{1,4960},{2,99200},{3,2480},{4,2480}],combat = 148920,is_tv = 0};

get_lv_cfg(1242) ->
	#pet_lv_cfg{lv = 1242,max_exp = 437491354,attr = [{1,4964},{2,99280},{3,2482},{4,2482}],combat = 149040,is_tv = 0};

get_lv_cfg(1243) ->
	#pet_lv_cfg{lv = 1243,max_exp = 441028472,attr = [{1,4968},{2,99360},{3,2484},{4,2484}],combat = 149160,is_tv = 0};

get_lv_cfg(1244) ->
	#pet_lv_cfg{lv = 1244,max_exp = 444594187,attr = [{1,4972},{2,99440},{3,2486},{4,2486}],combat = 149280,is_tv = 0};

get_lv_cfg(1245) ->
	#pet_lv_cfg{lv = 1245,max_exp = 448188731,attr = [{1,4976},{2,99520},{3,2488},{4,2488}],combat = 149400,is_tv = 0};

get_lv_cfg(1246) ->
	#pet_lv_cfg{lv = 1246,max_exp = 451812337,attr = [{1,4980},{2,99600},{3,2490},{4,2490}],combat = 149520,is_tv = 0};

get_lv_cfg(1247) ->
	#pet_lv_cfg{lv = 1247,max_exp = 455465240,attr = [{1,4984},{2,99680},{3,2492},{4,2492}],combat = 149640,is_tv = 0};

get_lv_cfg(1248) ->
	#pet_lv_cfg{lv = 1248,max_exp = 459147676,attr = [{1,4988},{2,99760},{3,2494},{4,2494}],combat = 149760,is_tv = 0};

get_lv_cfg(1249) ->
	#pet_lv_cfg{lv = 1249,max_exp = 462859885,attr = [{1,4992},{2,99840},{3,2496},{4,2496}],combat = 149880,is_tv = 0};

get_lv_cfg(1250) ->
	#pet_lv_cfg{lv = 1250,max_exp = 466602107,attr = [{1,4996},{2,99920},{3,2498},{4,2498}],combat = 150000,is_tv = 1};

get_lv_cfg(1251) ->
	#pet_lv_cfg{lv = 1251,max_exp = 470374585,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],combat = 150120,is_tv = 0};

get_lv_cfg(1252) ->
	#pet_lv_cfg{lv = 1252,max_exp = 474177564,attr = [{1,5004},{2,100080},{3,2502},{4,2502}],combat = 150240,is_tv = 0};

get_lv_cfg(1253) ->
	#pet_lv_cfg{lv = 1253,max_exp = 478011290,attr = [{1,5008},{2,100160},{3,2504},{4,2504}],combat = 150360,is_tv = 0};

get_lv_cfg(1254) ->
	#pet_lv_cfg{lv = 1254,max_exp = 481876011,attr = [{1,5012},{2,100240},{3,2506},{4,2506}],combat = 150480,is_tv = 0};

get_lv_cfg(1255) ->
	#pet_lv_cfg{lv = 1255,max_exp = 485771979,attr = [{1,5016},{2,100320},{3,2508},{4,2508}],combat = 150600,is_tv = 0};

get_lv_cfg(1256) ->
	#pet_lv_cfg{lv = 1256,max_exp = 489699445,attr = [{1,5020},{2,100400},{3,2510},{4,2510}],combat = 150720,is_tv = 0};

get_lv_cfg(1257) ->
	#pet_lv_cfg{lv = 1257,max_exp = 493658665,attr = [{1,5024},{2,100480},{3,2512},{4,2512}],combat = 150840,is_tv = 0};

get_lv_cfg(1258) ->
	#pet_lv_cfg{lv = 1258,max_exp = 497649895,attr = [{1,5028},{2,100560},{3,2514},{4,2514}],combat = 150960,is_tv = 0};

get_lv_cfg(1259) ->
	#pet_lv_cfg{lv = 1259,max_exp = 501673394,attr = [{1,5032},{2,100640},{3,2516},{4,2516}],combat = 151080,is_tv = 0};

get_lv_cfg(1260) ->
	#pet_lv_cfg{lv = 1260,max_exp = 505729423,attr = [{1,5036},{2,100720},{3,2518},{4,2518}],combat = 151200,is_tv = 0};

get_lv_cfg(1261) ->
	#pet_lv_cfg{lv = 1261,max_exp = 509818245,attr = [{1,5040},{2,100800},{3,2520},{4,2520}],combat = 151320,is_tv = 0};

get_lv_cfg(1262) ->
	#pet_lv_cfg{lv = 1262,max_exp = 513940126,attr = [{1,5044},{2,100880},{3,2522},{4,2522}],combat = 151440,is_tv = 0};

get_lv_cfg(1263) ->
	#pet_lv_cfg{lv = 1263,max_exp = 518095332,attr = [{1,5048},{2,100960},{3,2524},{4,2524}],combat = 151560,is_tv = 0};

get_lv_cfg(1264) ->
	#pet_lv_cfg{lv = 1264,max_exp = 522284133,attr = [{1,5052},{2,101040},{3,2526},{4,2526}],combat = 151680,is_tv = 0};

get_lv_cfg(1265) ->
	#pet_lv_cfg{lv = 1265,max_exp = 526506800,attr = [{1,5056},{2,101120},{3,2528},{4,2528}],combat = 151800,is_tv = 0};

get_lv_cfg(1266) ->
	#pet_lv_cfg{lv = 1266,max_exp = 530763607,attr = [{1,5060},{2,101200},{3,2530},{4,2530}],combat = 151920,is_tv = 0};

get_lv_cfg(1267) ->
	#pet_lv_cfg{lv = 1267,max_exp = 535054831,attr = [{1,5064},{2,101280},{3,2532},{4,2532}],combat = 152040,is_tv = 0};

get_lv_cfg(1268) ->
	#pet_lv_cfg{lv = 1268,max_exp = 539380749,attr = [{1,5068},{2,101360},{3,2534},{4,2534}],combat = 152160,is_tv = 0};

get_lv_cfg(1269) ->
	#pet_lv_cfg{lv = 1269,max_exp = 543741642,attr = [{1,5072},{2,101440},{3,2536},{4,2536}],combat = 152280,is_tv = 0};

get_lv_cfg(1270) ->
	#pet_lv_cfg{lv = 1270,max_exp = 548137793,attr = [{1,5076},{2,101520},{3,2538},{4,2538}],combat = 152400,is_tv = 0};

get_lv_cfg(1271) ->
	#pet_lv_cfg{lv = 1271,max_exp = 552569487,attr = [{1,5080},{2,101600},{3,2540},{4,2540}],combat = 152520,is_tv = 0};

get_lv_cfg(1272) ->
	#pet_lv_cfg{lv = 1272,max_exp = 557037011,attr = [{1,5084},{2,101680},{3,2542},{4,2542}],combat = 152640,is_tv = 0};

get_lv_cfg(1273) ->
	#pet_lv_cfg{lv = 1273,max_exp = 561540655,attr = [{1,5088},{2,101760},{3,2544},{4,2544}],combat = 152760,is_tv = 0};

get_lv_cfg(1274) ->
	#pet_lv_cfg{lv = 1274,max_exp = 566080711,attr = [{1,5092},{2,101840},{3,2546},{4,2546}],combat = 152880,is_tv = 0};

get_lv_cfg(1275) ->
	#pet_lv_cfg{lv = 1275,max_exp = 570657474,attr = [{1,5096},{2,101920},{3,2548},{4,2548}],combat = 153000,is_tv = 0};

get_lv_cfg(1276) ->
	#pet_lv_cfg{lv = 1276,max_exp = 575271240,attr = [{1,5100},{2,102000},{3,2550},{4,2550}],combat = 153120,is_tv = 0};

get_lv_cfg(1277) ->
	#pet_lv_cfg{lv = 1277,max_exp = 579922308,attr = [{1,5104},{2,102080},{3,2552},{4,2552}],combat = 153240,is_tv = 0};

get_lv_cfg(1278) ->
	#pet_lv_cfg{lv = 1278,max_exp = 584610980,attr = [{1,5108},{2,102160},{3,2554},{4,2554}],combat = 153360,is_tv = 0};

get_lv_cfg(1279) ->
	#pet_lv_cfg{lv = 1279,max_exp = 589337560,attr = [{1,5112},{2,102240},{3,2556},{4,2556}],combat = 153480,is_tv = 0};

get_lv_cfg(1280) ->
	#pet_lv_cfg{lv = 1280,max_exp = 594102354,attr = [{1,5116},{2,102320},{3,2558},{4,2558}],combat = 153600,is_tv = 0};

get_lv_cfg(1281) ->
	#pet_lv_cfg{lv = 1281,max_exp = 598905672,attr = [{1,5120},{2,102400},{3,2560},{4,2560}],combat = 153720,is_tv = 0};

get_lv_cfg(1282) ->
	#pet_lv_cfg{lv = 1282,max_exp = 603747824,attr = [{1,5124},{2,102480},{3,2562},{4,2562}],combat = 153840,is_tv = 0};

get_lv_cfg(1283) ->
	#pet_lv_cfg{lv = 1283,max_exp = 608629125,attr = [{1,5128},{2,102560},{3,2564},{4,2564}],combat = 153960,is_tv = 0};

get_lv_cfg(1284) ->
	#pet_lv_cfg{lv = 1284,max_exp = 613549891,attr = [{1,5132},{2,102640},{3,2566},{4,2566}],combat = 154080,is_tv = 0};

get_lv_cfg(1285) ->
	#pet_lv_cfg{lv = 1285,max_exp = 618510442,attr = [{1,5136},{2,102720},{3,2568},{4,2568}],combat = 154200,is_tv = 0};

get_lv_cfg(1286) ->
	#pet_lv_cfg{lv = 1286,max_exp = 623511099,attr = [{1,5140},{2,102800},{3,2570},{4,2570}],combat = 154320,is_tv = 0};

get_lv_cfg(1287) ->
	#pet_lv_cfg{lv = 1287,max_exp = 628552186,attr = [{1,5144},{2,102880},{3,2572},{4,2572}],combat = 154440,is_tv = 0};

get_lv_cfg(1288) ->
	#pet_lv_cfg{lv = 1288,max_exp = 633634030,attr = [{1,5148},{2,102960},{3,2574},{4,2574}],combat = 154560,is_tv = 0};

get_lv_cfg(1289) ->
	#pet_lv_cfg{lv = 1289,max_exp = 638756961,attr = [{1,5152},{2,103040},{3,2576},{4,2576}],combat = 154680,is_tv = 0};

get_lv_cfg(1290) ->
	#pet_lv_cfg{lv = 1290,max_exp = 643921311,attr = [{1,5156},{2,103120},{3,2578},{4,2578}],combat = 154800,is_tv = 0};

get_lv_cfg(1291) ->
	#pet_lv_cfg{lv = 1291,max_exp = 649127415,attr = [{1,5160},{2,103200},{3,2580},{4,2580}],combat = 154920,is_tv = 0};

get_lv_cfg(1292) ->
	#pet_lv_cfg{lv = 1292,max_exp = 654375610,attr = [{1,5164},{2,103280},{3,2582},{4,2582}],combat = 155040,is_tv = 0};

get_lv_cfg(1293) ->
	#pet_lv_cfg{lv = 1293,max_exp = 659666237,attr = [{1,5168},{2,103360},{3,2584},{4,2584}],combat = 155160,is_tv = 0};

get_lv_cfg(1294) ->
	#pet_lv_cfg{lv = 1294,max_exp = 664999639,attr = [{1,5172},{2,103440},{3,2586},{4,2586}],combat = 155280,is_tv = 0};

get_lv_cfg(1295) ->
	#pet_lv_cfg{lv = 1295,max_exp = 670376161,attr = [{1,5176},{2,103520},{3,2588},{4,2588}],combat = 155400,is_tv = 0};

get_lv_cfg(1296) ->
	#pet_lv_cfg{lv = 1296,max_exp = 675796152,attr = [{1,5180},{2,103600},{3,2590},{4,2590}],combat = 155520,is_tv = 0};

get_lv_cfg(1297) ->
	#pet_lv_cfg{lv = 1297,max_exp = 681259964,attr = [{1,5184},{2,103680},{3,2592},{4,2592}],combat = 155640,is_tv = 0};

get_lv_cfg(1298) ->
	#pet_lv_cfg{lv = 1298,max_exp = 686767951,attr = [{1,5188},{2,103760},{3,2594},{4,2594}],combat = 155760,is_tv = 0};

get_lv_cfg(1299) ->
	#pet_lv_cfg{lv = 1299,max_exp = 692320470,attr = [{1,5192},{2,103840},{3,2596},{4,2596}],combat = 155880,is_tv = 0};

get_lv_cfg(1300) ->
	#pet_lv_cfg{lv = 1300,max_exp = 697917881,attr = [{1,5196},{2,103920},{3,2598},{4,2598}],combat = 156000,is_tv = 1};

get_lv_cfg(1301) ->
	#pet_lv_cfg{lv = 1301,max_exp = 703560547,attr = [{1,5200},{2,104000},{3,2600},{4,2600}],combat = 156120,is_tv = 0};

get_lv_cfg(1302) ->
	#pet_lv_cfg{lv = 1302,max_exp = 709248834,attr = [{1,5204},{2,104080},{3,2602},{4,2602}],combat = 156240,is_tv = 0};

get_lv_cfg(1303) ->
	#pet_lv_cfg{lv = 1303,max_exp = 714983111,attr = [{1,5208},{2,104160},{3,2604},{4,2604}],combat = 156360,is_tv = 0};

get_lv_cfg(1304) ->
	#pet_lv_cfg{lv = 1304,max_exp = 720763749,attr = [{1,5212},{2,104240},{3,2606},{4,2606}],combat = 156480,is_tv = 0};

get_lv_cfg(1305) ->
	#pet_lv_cfg{lv = 1305,max_exp = 726591124,attr = [{1,5216},{2,104320},{3,2608},{4,2608}],combat = 156600,is_tv = 0};

get_lv_cfg(1306) ->
	#pet_lv_cfg{lv = 1306,max_exp = 732465613,attr = [{1,5220},{2,104400},{3,2610},{4,2610}],combat = 156720,is_tv = 0};

get_lv_cfg(1307) ->
	#pet_lv_cfg{lv = 1307,max_exp = 738387597,attr = [{1,5224},{2,104480},{3,2612},{4,2612}],combat = 156840,is_tv = 0};

get_lv_cfg(1308) ->
	#pet_lv_cfg{lv = 1308,max_exp = 744357461,attr = [{1,5228},{2,104560},{3,2614},{4,2614}],combat = 156960,is_tv = 0};

get_lv_cfg(1309) ->
	#pet_lv_cfg{lv = 1309,max_exp = 750375591,attr = [{1,5232},{2,104640},{3,2616},{4,2616}],combat = 157080,is_tv = 0};

get_lv_cfg(1310) ->
	#pet_lv_cfg{lv = 1310,max_exp = 756442378,attr = [{1,5236},{2,104720},{3,2618},{4,2618}],combat = 157200,is_tv = 0};

get_lv_cfg(1311) ->
	#pet_lv_cfg{lv = 1311,max_exp = 762558215,attr = [{1,5240},{2,104800},{3,2620},{4,2620}],combat = 157320,is_tv = 0};

get_lv_cfg(1312) ->
	#pet_lv_cfg{lv = 1312,max_exp = 768723498,attr = [{1,5244},{2,104880},{3,2622},{4,2622}],combat = 157440,is_tv = 0};

get_lv_cfg(1313) ->
	#pet_lv_cfg{lv = 1313,max_exp = 774938627,attr = [{1,5248},{2,104960},{3,2624},{4,2624}],combat = 157560,is_tv = 0};

get_lv_cfg(1314) ->
	#pet_lv_cfg{lv = 1314,max_exp = 781204006,attr = [{1,5252},{2,105040},{3,2626},{4,2626}],combat = 157680,is_tv = 0};

get_lv_cfg(1315) ->
	#pet_lv_cfg{lv = 1315,max_exp = 787520040,attr = [{1,5256},{2,105120},{3,2628},{4,2628}],combat = 157800,is_tv = 0};

get_lv_cfg(1316) ->
	#pet_lv_cfg{lv = 1316,max_exp = 793887140,attr = [{1,5260},{2,105200},{3,2630},{4,2630}],combat = 157920,is_tv = 0};

get_lv_cfg(1317) ->
	#pet_lv_cfg{lv = 1317,max_exp = 800305718,attr = [{1,5264},{2,105280},{3,2632},{4,2632}],combat = 158040,is_tv = 0};

get_lv_cfg(1318) ->
	#pet_lv_cfg{lv = 1318,max_exp = 806776190,attr = [{1,5268},{2,105360},{3,2634},{4,2634}],combat = 158160,is_tv = 0};

get_lv_cfg(1319) ->
	#pet_lv_cfg{lv = 1319,max_exp = 813298975,attr = [{1,5272},{2,105440},{3,2636},{4,2636}],combat = 158280,is_tv = 0};

get_lv_cfg(1320) ->
	#pet_lv_cfg{lv = 1320,max_exp = 819874497,attr = [{1,5276},{2,105520},{3,2638},{4,2638}],combat = 158400,is_tv = 0};

get_lv_cfg(1321) ->
	#pet_lv_cfg{lv = 1321,max_exp = 826503182,attr = [{1,5280},{2,105600},{3,2640},{4,2640}],combat = 158520,is_tv = 0};

get_lv_cfg(1322) ->
	#pet_lv_cfg{lv = 1322,max_exp = 833185460,attr = [{1,5284},{2,105680},{3,2642},{4,2642}],combat = 158640,is_tv = 0};

get_lv_cfg(1323) ->
	#pet_lv_cfg{lv = 1323,max_exp = 839921764,attr = [{1,5288},{2,105760},{3,2644},{4,2644}],combat = 158760,is_tv = 0};

get_lv_cfg(1324) ->
	#pet_lv_cfg{lv = 1324,max_exp = 846712531,attr = [{1,5292},{2,105840},{3,2646},{4,2646}],combat = 158880,is_tv = 0};

get_lv_cfg(1325) ->
	#pet_lv_cfg{lv = 1325,max_exp = 853558202,attr = [{1,5296},{2,105920},{3,2648},{4,2648}],combat = 159000,is_tv = 0};

get_lv_cfg(1326) ->
	#pet_lv_cfg{lv = 1326,max_exp = 860459220,attr = [{1,5300},{2,106000},{3,2650},{4,2650}],combat = 159120,is_tv = 0};

get_lv_cfg(1327) ->
	#pet_lv_cfg{lv = 1327,max_exp = 867416033,attr = [{1,5304},{2,106080},{3,2652},{4,2652}],combat = 159240,is_tv = 0};

get_lv_cfg(1328) ->
	#pet_lv_cfg{lv = 1328,max_exp = 874429092,attr = [{1,5308},{2,106160},{3,2654},{4,2654}],combat = 159360,is_tv = 0};

get_lv_cfg(1329) ->
	#pet_lv_cfg{lv = 1329,max_exp = 881498851,attr = [{1,5312},{2,106240},{3,2656},{4,2656}],combat = 159480,is_tv = 0};

get_lv_cfg(1330) ->
	#pet_lv_cfg{lv = 1330,max_exp = 888625769,attr = [{1,5316},{2,106320},{3,2658},{4,2658}],combat = 159600,is_tv = 0};

get_lv_cfg(1331) ->
	#pet_lv_cfg{lv = 1331,max_exp = 895810308,attr = [{1,5320},{2,106400},{3,2660},{4,2660}],combat = 159720,is_tv = 0};

get_lv_cfg(1332) ->
	#pet_lv_cfg{lv = 1332,max_exp = 903052934,attr = [{1,5324},{2,106480},{3,2662},{4,2662}],combat = 159840,is_tv = 0};

get_lv_cfg(1333) ->
	#pet_lv_cfg{lv = 1333,max_exp = 910354117,attr = [{1,5328},{2,106560},{3,2664},{4,2664}],combat = 159960,is_tv = 0};

get_lv_cfg(1334) ->
	#pet_lv_cfg{lv = 1334,max_exp = 917714330,attr = [{1,5332},{2,106640},{3,2666},{4,2666}],combat = 160080,is_tv = 0};

get_lv_cfg(1335) ->
	#pet_lv_cfg{lv = 1335,max_exp = 925134050,attr = [{1,5336},{2,106720},{3,2668},{4,2668}],combat = 160200,is_tv = 0};

get_lv_cfg(1336) ->
	#pet_lv_cfg{lv = 1336,max_exp = 932613759,attr = [{1,5340},{2,106800},{3,2670},{4,2670}],combat = 160320,is_tv = 0};

get_lv_cfg(1337) ->
	#pet_lv_cfg{lv = 1337,max_exp = 940153941,attr = [{1,5344},{2,106880},{3,2672},{4,2672}],combat = 160440,is_tv = 0};

get_lv_cfg(1338) ->
	#pet_lv_cfg{lv = 1338,max_exp = 947755086,attr = [{1,5348},{2,106960},{3,2674},{4,2674}],combat = 160560,is_tv = 0};

get_lv_cfg(1339) ->
	#pet_lv_cfg{lv = 1339,max_exp = 955417686,attr = [{1,5352},{2,107040},{3,2676},{4,2676}],combat = 160680,is_tv = 0};

get_lv_cfg(1340) ->
	#pet_lv_cfg{lv = 1340,max_exp = 963142238,attr = [{1,5356},{2,107120},{3,2678},{4,2678}],combat = 160800,is_tv = 0};

get_lv_cfg(1341) ->
	#pet_lv_cfg{lv = 1341,max_exp = 970929243,attr = [{1,5360},{2,107200},{3,2680},{4,2680}],combat = 160920,is_tv = 0};

get_lv_cfg(1342) ->
	#pet_lv_cfg{lv = 1342,max_exp = 978779206,attr = [{1,5364},{2,107280},{3,2682},{4,2682}],combat = 161040,is_tv = 0};

get_lv_cfg(1343) ->
	#pet_lv_cfg{lv = 1343,max_exp = 986692636,attr = [{1,5368},{2,107360},{3,2684},{4,2684}],combat = 161160,is_tv = 0};

get_lv_cfg(1344) ->
	#pet_lv_cfg{lv = 1344,max_exp = 994670046,attr = [{1,5372},{2,107440},{3,2686},{4,2686}],combat = 161280,is_tv = 0};

get_lv_cfg(1345) ->
	#pet_lv_cfg{lv = 1345,max_exp = 1002711953,attr = [{1,5376},{2,107520},{3,2688},{4,2688}],combat = 161400,is_tv = 0};

get_lv_cfg(1346) ->
	#pet_lv_cfg{lv = 1346,max_exp = 1010818879,attr = [{1,5380},{2,107600},{3,2690},{4,2690}],combat = 161520,is_tv = 0};

get_lv_cfg(1347) ->
	#pet_lv_cfg{lv = 1347,max_exp = 1018991350,attr = [{1,5384},{2,107680},{3,2692},{4,2692}],combat = 161640,is_tv = 0};

get_lv_cfg(1348) ->
	#pet_lv_cfg{lv = 1348,max_exp = 1027229895,attr = [{1,5388},{2,107760},{3,2694},{4,2694}],combat = 161760,is_tv = 0};

get_lv_cfg(1349) ->
	#pet_lv_cfg{lv = 1349,max_exp = 1035535049,attr = [{1,5392},{2,107840},{3,2696},{4,2696}],combat = 161880,is_tv = 0};

get_lv_cfg(1350) ->
	#pet_lv_cfg{lv = 1350,max_exp = 1043907350,attr = [{1,5396},{2,107920},{3,2698},{4,2698}],combat = 162000,is_tv = 1};

get_lv_cfg(1351) ->
	#pet_lv_cfg{lv = 1351,max_exp = 1052347341,attr = [{1,5400},{2,108000},{3,2700},{4,2700}],combat = 162120,is_tv = 0};

get_lv_cfg(1352) ->
	#pet_lv_cfg{lv = 1352,max_exp = 1060855569,attr = [{1,5404},{2,108080},{3,2702},{4,2702}],combat = 162240,is_tv = 0};

get_lv_cfg(1353) ->
	#pet_lv_cfg{lv = 1353,max_exp = 1069432586,attr = [{1,5408},{2,108160},{3,2704},{4,2704}],combat = 162360,is_tv = 0};

get_lv_cfg(1354) ->
	#pet_lv_cfg{lv = 1354,max_exp = 1078078948,attr = [{1,5412},{2,108240},{3,2706},{4,2706}],combat = 162480,is_tv = 0};

get_lv_cfg(1355) ->
	#pet_lv_cfg{lv = 1355,max_exp = 1086795216,attr = [{1,5416},{2,108320},{3,2708},{4,2708}],combat = 162600,is_tv = 0};

get_lv_cfg(1356) ->
	#pet_lv_cfg{lv = 1356,max_exp = 1095581955,attr = [{1,5420},{2,108400},{3,2710},{4,2710}],combat = 162720,is_tv = 0};

get_lv_cfg(1357) ->
	#pet_lv_cfg{lv = 1357,max_exp = 1104439735,attr = [{1,5424},{2,108480},{3,2712},{4,2712}],combat = 162840,is_tv = 0};

get_lv_cfg(1358) ->
	#pet_lv_cfg{lv = 1358,max_exp = 1113369130,attr = [{1,5428},{2,108560},{3,2714},{4,2714}],combat = 162960,is_tv = 0};

get_lv_cfg(1359) ->
	#pet_lv_cfg{lv = 1359,max_exp = 1122370719,attr = [{1,5432},{2,108640},{3,2716},{4,2716}],combat = 163080,is_tv = 0};

get_lv_cfg(1360) ->
	#pet_lv_cfg{lv = 1360,max_exp = 1131445086,attr = [{1,5436},{2,108720},{3,2718},{4,2718}],combat = 163200,is_tv = 0};

get_lv_cfg(1361) ->
	#pet_lv_cfg{lv = 1361,max_exp = 1140592820,attr = [{1,5440},{2,108800},{3,2720},{4,2720}],combat = 163320,is_tv = 0};

get_lv_cfg(1362) ->
	#pet_lv_cfg{lv = 1362,max_exp = 1149814513,attr = [{1,5444},{2,108880},{3,2722},{4,2722}],combat = 163440,is_tv = 0};

get_lv_cfg(1363) ->
	#pet_lv_cfg{lv = 1363,max_exp = 1159110763,attr = [{1,5448},{2,108960},{3,2724},{4,2724}],combat = 163560,is_tv = 0};

get_lv_cfg(1364) ->
	#pet_lv_cfg{lv = 1364,max_exp = 1168482174,attr = [{1,5452},{2,109040},{3,2726},{4,2726}],combat = 163680,is_tv = 0};

get_lv_cfg(1365) ->
	#pet_lv_cfg{lv = 1365,max_exp = 1177929352,attr = [{1,5456},{2,109120},{3,2728},{4,2728}],combat = 163800,is_tv = 0};

get_lv_cfg(1366) ->
	#pet_lv_cfg{lv = 1366,max_exp = 1187452911,attr = [{1,5460},{2,109200},{3,2730},{4,2730}],combat = 163920,is_tv = 0};

get_lv_cfg(1367) ->
	#pet_lv_cfg{lv = 1367,max_exp = 1197053468,attr = [{1,5464},{2,109280},{3,2732},{4,2732}],combat = 164040,is_tv = 0};

get_lv_cfg(1368) ->
	#pet_lv_cfg{lv = 1368,max_exp = 1206731645,attr = [{1,5468},{2,109360},{3,2734},{4,2734}],combat = 164160,is_tv = 0};

get_lv_cfg(1369) ->
	#pet_lv_cfg{lv = 1369,max_exp = 1216488070,attr = [{1,5472},{2,109440},{3,2736},{4,2736}],combat = 164280,is_tv = 0};

get_lv_cfg(1370) ->
	#pet_lv_cfg{lv = 1370,max_exp = 1226323376,attr = [{1,5476},{2,109520},{3,2738},{4,2738}],combat = 164400,is_tv = 0};

get_lv_cfg(1371) ->
	#pet_lv_cfg{lv = 1371,max_exp = 1236238200,attr = [{1,5480},{2,109600},{3,2740},{4,2740}],combat = 164520,is_tv = 0};

get_lv_cfg(1372) ->
	#pet_lv_cfg{lv = 1372,max_exp = 1246233186,attr = [{1,5484},{2,109680},{3,2742},{4,2742}],combat = 164640,is_tv = 0};

get_lv_cfg(1373) ->
	#pet_lv_cfg{lv = 1373,max_exp = 1256308981,attr = [{1,5488},{2,109760},{3,2744},{4,2744}],combat = 164760,is_tv = 0};

get_lv_cfg(1374) ->
	#pet_lv_cfg{lv = 1374,max_exp = 1266466239,attr = [{1,5492},{2,109840},{3,2746},{4,2746}],combat = 164880,is_tv = 0};

get_lv_cfg(1375) ->
	#pet_lv_cfg{lv = 1375,max_exp = 1276705619,attr = [{1,5496},{2,109920},{3,2748},{4,2748}],combat = 165000,is_tv = 0};

get_lv_cfg(1376) ->
	#pet_lv_cfg{lv = 1376,max_exp = 1287027784,attr = [{1,5500},{2,110000},{3,2750},{4,2750}],combat = 165120,is_tv = 0};

get_lv_cfg(1377) ->
	#pet_lv_cfg{lv = 1377,max_exp = 1297433404,attr = [{1,5504},{2,110080},{3,2752},{4,2752}],combat = 165240,is_tv = 0};

get_lv_cfg(1378) ->
	#pet_lv_cfg{lv = 1378,max_exp = 1307923153,attr = [{1,5508},{2,110160},{3,2754},{4,2754}],combat = 165360,is_tv = 0};

get_lv_cfg(1379) ->
	#pet_lv_cfg{lv = 1379,max_exp = 1318497712,attr = [{1,5512},{2,110240},{3,2756},{4,2756}],combat = 165480,is_tv = 0};

get_lv_cfg(1380) ->
	#pet_lv_cfg{lv = 1380,max_exp = 1329157766,attr = [{1,5516},{2,110320},{3,2758},{4,2758}],combat = 165600,is_tv = 0};

get_lv_cfg(1381) ->
	#pet_lv_cfg{lv = 1381,max_exp = 1339904007,attr = [{1,5520},{2,110400},{3,2760},{4,2760}],combat = 165720,is_tv = 0};

get_lv_cfg(1382) ->
	#pet_lv_cfg{lv = 1382,max_exp = 1350737131,attr = [{1,5524},{2,110480},{3,2762},{4,2762}],combat = 165840,is_tv = 0};

get_lv_cfg(1383) ->
	#pet_lv_cfg{lv = 1383,max_exp = 1361657841,attr = [{1,5528},{2,110560},{3,2764},{4,2764}],combat = 165960,is_tv = 0};

get_lv_cfg(1384) ->
	#pet_lv_cfg{lv = 1384,max_exp = 1372666845,attr = [{1,5532},{2,110640},{3,2766},{4,2766}],combat = 166080,is_tv = 0};

get_lv_cfg(1385) ->
	#pet_lv_cfg{lv = 1385,max_exp = 1383764856,attr = [{1,5536},{2,110720},{3,2768},{4,2768}],combat = 166200,is_tv = 0};

get_lv_cfg(1386) ->
	#pet_lv_cfg{lv = 1386,max_exp = 1394952595,attr = [{1,5540},{2,110800},{3,2770},{4,2770}],combat = 166320,is_tv = 0};

get_lv_cfg(1387) ->
	#pet_lv_cfg{lv = 1387,max_exp = 1406230787,attr = [{1,5544},{2,110880},{3,2772},{4,2772}],combat = 166440,is_tv = 0};

get_lv_cfg(1388) ->
	#pet_lv_cfg{lv = 1388,max_exp = 1417600163,attr = [{1,5548},{2,110960},{3,2774},{4,2774}],combat = 166560,is_tv = 0};

get_lv_cfg(1389) ->
	#pet_lv_cfg{lv = 1389,max_exp = 1429061460,attr = [{1,5552},{2,111040},{3,2776},{4,2776}],combat = 166680,is_tv = 0};

get_lv_cfg(1390) ->
	#pet_lv_cfg{lv = 1390,max_exp = 1440615422,attr = [{1,5556},{2,111120},{3,2778},{4,2778}],combat = 166800,is_tv = 0};

get_lv_cfg(1391) ->
	#pet_lv_cfg{lv = 1391,max_exp = 1452262798,attr = [{1,5560},{2,111200},{3,2780},{4,2780}],combat = 166920,is_tv = 0};

get_lv_cfg(1392) ->
	#pet_lv_cfg{lv = 1392,max_exp = 1464004343,attr = [{1,5564},{2,111280},{3,2782},{4,2782}],combat = 167040,is_tv = 0};

get_lv_cfg(1393) ->
	#pet_lv_cfg{lv = 1393,max_exp = 1475840818,attr = [{1,5568},{2,111360},{3,2784},{4,2784}],combat = 167160,is_tv = 0};

get_lv_cfg(1394) ->
	#pet_lv_cfg{lv = 1394,max_exp = 1487772991,attr = [{1,5572},{2,111440},{3,2786},{4,2786}],combat = 167280,is_tv = 0};

get_lv_cfg(1395) ->
	#pet_lv_cfg{lv = 1395,max_exp = 1499801636,attr = [{1,5576},{2,111520},{3,2788},{4,2788}],combat = 167400,is_tv = 0};

get_lv_cfg(1396) ->
	#pet_lv_cfg{lv = 1396,max_exp = 1511927532,attr = [{1,5580},{2,111600},{3,2790},{4,2790}],combat = 167520,is_tv = 0};

get_lv_cfg(1397) ->
	#pet_lv_cfg{lv = 1397,max_exp = 1524151466,attr = [{1,5584},{2,111680},{3,2792},{4,2792}],combat = 167640,is_tv = 0};

get_lv_cfg(1398) ->
	#pet_lv_cfg{lv = 1398,max_exp = 1536474231,attr = [{1,5588},{2,111760},{3,2794},{4,2794}],combat = 167760,is_tv = 0};

get_lv_cfg(1399) ->
	#pet_lv_cfg{lv = 1399,max_exp = 1548896625,attr = [{1,5592},{2,111840},{3,2796},{4,2796}],combat = 167880,is_tv = 0};

get_lv_cfg(1400) ->
	#pet_lv_cfg{lv = 1400,max_exp = 1561419454,attr = [{1,5596},{2,111920},{3,2798},{4,2798}],combat = 168000,is_tv = 1};

get_lv_cfg(1401) ->
	#pet_lv_cfg{lv = 1401,max_exp = 1574043530,attr = [{1,5600},{2,112000},{3,2800},{4,2800}],combat = 168120,is_tv = 0};

get_lv_cfg(1402) ->
	#pet_lv_cfg{lv = 1402,max_exp = 1586769672,attr = [{1,5604},{2,112080},{3,2802},{4,2802}],combat = 168240,is_tv = 0};

get_lv_cfg(1403) ->
	#pet_lv_cfg{lv = 1403,max_exp = 1599598705,attr = [{1,5608},{2,112160},{3,2804},{4,2804}],combat = 168360,is_tv = 0};

get_lv_cfg(1404) ->
	#pet_lv_cfg{lv = 1404,max_exp = 1612531461,attr = [{1,5612},{2,112240},{3,2806},{4,2806}],combat = 168480,is_tv = 0};

get_lv_cfg(1405) ->
	#pet_lv_cfg{lv = 1405,max_exp = 1625568778,attr = [{1,5616},{2,112320},{3,2808},{4,2808}],combat = 168600,is_tv = 0};

get_lv_cfg(1406) ->
	#pet_lv_cfg{lv = 1406,max_exp = 1638711502,attr = [{1,5620},{2,112400},{3,2810},{4,2810}],combat = 168720,is_tv = 0};

get_lv_cfg(1407) ->
	#pet_lv_cfg{lv = 1407,max_exp = 1651960484,attr = [{1,5624},{2,112480},{3,2812},{4,2812}],combat = 168840,is_tv = 0};

get_lv_cfg(1408) ->
	#pet_lv_cfg{lv = 1408,max_exp = 1665316585,attr = [{1,5628},{2,112560},{3,2814},{4,2814}],combat = 168960,is_tv = 0};

get_lv_cfg(1409) ->
	#pet_lv_cfg{lv = 1409,max_exp = 1678780670,attr = [{1,5632},{2,112640},{3,2816},{4,2816}],combat = 169080,is_tv = 0};

get_lv_cfg(1410) ->
	#pet_lv_cfg{lv = 1410,max_exp = 1692353612,attr = [{1,5636},{2,112720},{3,2818},{4,2818}],combat = 169200,is_tv = 0};

get_lv_cfg(1411) ->
	#pet_lv_cfg{lv = 1411,max_exp = 1706036291,attr = [{1,5640},{2,112800},{3,2820},{4,2820}],combat = 169320,is_tv = 0};

get_lv_cfg(1412) ->
	#pet_lv_cfg{lv = 1412,max_exp = 1719829594,attr = [{1,5644},{2,112880},{3,2822},{4,2822}],combat = 169440,is_tv = 0};

get_lv_cfg(1413) ->
	#pet_lv_cfg{lv = 1413,max_exp = 1733734416,attr = [{1,5648},{2,112960},{3,2824},{4,2824}],combat = 169560,is_tv = 0};

get_lv_cfg(1414) ->
	#pet_lv_cfg{lv = 1414,max_exp = 1747751659,attr = [{1,5652},{2,113040},{3,2826},{4,2826}],combat = 169680,is_tv = 0};

get_lv_cfg(1415) ->
	#pet_lv_cfg{lv = 1415,max_exp = 1761882231,attr = [{1,5656},{2,113120},{3,2828},{4,2828}],combat = 169800,is_tv = 0};

get_lv_cfg(1416) ->
	#pet_lv_cfg{lv = 1416,max_exp = 1776127049,attr = [{1,5660},{2,113200},{3,2830},{4,2830}],combat = 169920,is_tv = 0};

get_lv_cfg(1417) ->
	#pet_lv_cfg{lv = 1417,max_exp = 1790487036,attr = [{1,5664},{2,113280},{3,2832},{4,2832}],combat = 170040,is_tv = 0};

get_lv_cfg(1418) ->
	#pet_lv_cfg{lv = 1418,max_exp = 1804963124,attr = [{1,5668},{2,113360},{3,2834},{4,2834}],combat = 170160,is_tv = 0};

get_lv_cfg(1419) ->
	#pet_lv_cfg{lv = 1419,max_exp = 1819556251,attr = [{1,5672},{2,113440},{3,2836},{4,2836}],combat = 170280,is_tv = 0};

get_lv_cfg(1420) ->
	#pet_lv_cfg{lv = 1420,max_exp = 1834267363,attr = [{1,5676},{2,113520},{3,2838},{4,2838}],combat = 170400,is_tv = 0};

get_lv_cfg(1421) ->
	#pet_lv_cfg{lv = 1421,max_exp = 1849097415,attr = [{1,5680},{2,113600},{3,2840},{4,2840}],combat = 170520,is_tv = 0};

get_lv_cfg(1422) ->
	#pet_lv_cfg{lv = 1422,max_exp = 1864047368,attr = [{1,5684},{2,113680},{3,2842},{4,2842}],combat = 170640,is_tv = 0};

get_lv_cfg(1423) ->
	#pet_lv_cfg{lv = 1423,max_exp = 1879118191,attr = [{1,5688},{2,113760},{3,2844},{4,2844}],combat = 170760,is_tv = 0};

get_lv_cfg(1424) ->
	#pet_lv_cfg{lv = 1424,max_exp = 1894310862,attr = [{1,5692},{2,113840},{3,2846},{4,2846}],combat = 170880,is_tv = 0};

get_lv_cfg(1425) ->
	#pet_lv_cfg{lv = 1425,max_exp = 1909626365,attr = [{1,5696},{2,113920},{3,2848},{4,2848}],combat = 171000,is_tv = 0};

get_lv_cfg(1426) ->
	#pet_lv_cfg{lv = 1426,max_exp = 1925065694,attr = [{1,5700},{2,114000},{3,2850},{4,2850}],combat = 171120,is_tv = 0};

get_lv_cfg(1427) ->
	#pet_lv_cfg{lv = 1427,max_exp = 1940629850,attr = [{1,5704},{2,114080},{3,2852},{4,2852}],combat = 171240,is_tv = 0};

get_lv_cfg(1428) ->
	#pet_lv_cfg{lv = 1428,max_exp = 1956319842,attr = [{1,5708},{2,114160},{3,2854},{4,2854}],combat = 171360,is_tv = 0};

get_lv_cfg(1429) ->
	#pet_lv_cfg{lv = 1429,max_exp = 1972136688,attr = [{1,5712},{2,114240},{3,2856},{4,2856}],combat = 171480,is_tv = 0};

get_lv_cfg(1430) ->
	#pet_lv_cfg{lv = 1430,max_exp = 1988081413,attr = [{1,5716},{2,114320},{3,2858},{4,2858}],combat = 171600,is_tv = 0};

get_lv_cfg(1431) ->
	#pet_lv_cfg{lv = 1431,max_exp = 2004155051,attr = [{1,5720},{2,114400},{3,2860},{4,2860}],combat = 171720,is_tv = 0};

get_lv_cfg(1432) ->
	#pet_lv_cfg{lv = 1432,max_exp = 2020358645,attr = [{1,5724},{2,114480},{3,2862},{4,2862}],combat = 171840,is_tv = 0};

get_lv_cfg(1433) ->
	#pet_lv_cfg{lv = 1433,max_exp = 2036693245,attr = [{1,5728},{2,114560},{3,2864},{4,2864}],combat = 171960,is_tv = 0};

get_lv_cfg(1434) ->
	#pet_lv_cfg{lv = 1434,max_exp = 2053159910,attr = [{1,5732},{2,114640},{3,2866},{4,2866}],combat = 172080,is_tv = 0};

get_lv_cfg(1435) ->
	#pet_lv_cfg{lv = 1435,max_exp = 2069759708,attr = [{1,5736},{2,114720},{3,2868},{4,2868}],combat = 172200,is_tv = 0};

get_lv_cfg(1436) ->
	#pet_lv_cfg{lv = 1436,max_exp = 2086493715,attr = [{1,5740},{2,114800},{3,2870},{4,2870}],combat = 172320,is_tv = 0};

get_lv_cfg(1437) ->
	#pet_lv_cfg{lv = 1437,max_exp = 2103363017,attr = [{1,5744},{2,114880},{3,2872},{4,2872}],combat = 172440,is_tv = 0};

get_lv_cfg(1438) ->
	#pet_lv_cfg{lv = 1438,max_exp = 2120368707,attr = [{1,5748},{2,114960},{3,2874},{4,2874}],combat = 172560,is_tv = 0};

get_lv_cfg(1439) ->
	#pet_lv_cfg{lv = 1439,max_exp = 2137511888,attr = [{1,5752},{2,115040},{3,2876},{4,2876}],combat = 172680,is_tv = 0};

get_lv_cfg(1440) ->
	#pet_lv_cfg{lv = 1440,max_exp = 2154793672,attr = [{1,5756},{2,115120},{3,2878},{4,2878}],combat = 172800,is_tv = 0};

get_lv_cfg(1441) ->
	#pet_lv_cfg{lv = 1441,max_exp = 2172215179,attr = [{1,5760},{2,115200},{3,2880},{4,2880}],combat = 172920,is_tv = 0};

get_lv_cfg(1442) ->
	#pet_lv_cfg{lv = 1442,max_exp = 2189777539,attr = [{1,5764},{2,115280},{3,2882},{4,2882}],combat = 173040,is_tv = 0};

get_lv_cfg(1443) ->
	#pet_lv_cfg{lv = 1443,max_exp = 2207481890,attr = [{1,5768},{2,115360},{3,2884},{4,2884}],combat = 173160,is_tv = 0};

get_lv_cfg(1444) ->
	#pet_lv_cfg{lv = 1444,max_exp = 2225329381,attr = [{1,5772},{2,115440},{3,2886},{4,2886}],combat = 173280,is_tv = 0};

get_lv_cfg(1445) ->
	#pet_lv_cfg{lv = 1445,max_exp = 2243321169,attr = [{1,5776},{2,115520},{3,2888},{4,2888}],combat = 173400,is_tv = 0};

get_lv_cfg(1446) ->
	#pet_lv_cfg{lv = 1446,max_exp = 2261458421,attr = [{1,5780},{2,115600},{3,2890},{4,2890}],combat = 173520,is_tv = 0};

get_lv_cfg(1447) ->
	#pet_lv_cfg{lv = 1447,max_exp = 2279742312,attr = [{1,5784},{2,115680},{3,2892},{4,2892}],combat = 173640,is_tv = 0};

get_lv_cfg(1448) ->
	#pet_lv_cfg{lv = 1448,max_exp = 2298174029,attr = [{1,5788},{2,115760},{3,2894},{4,2894}],combat = 173760,is_tv = 0};

get_lv_cfg(1449) ->
	#pet_lv_cfg{lv = 1449,max_exp = 2316754766,attr = [{1,5792},{2,115840},{3,2896},{4,2896}],combat = 173880,is_tv = 0};

get_lv_cfg(1450) ->
	#pet_lv_cfg{lv = 1450,max_exp = 2335485728,attr = [{1,5796},{2,115920},{3,2898},{4,2898}],combat = 174000,is_tv = 1};

get_lv_cfg(1451) ->
	#pet_lv_cfg{lv = 1451,max_exp = 2354368130,attr = [{1,5800},{2,116000},{3,2900},{4,2900}],combat = 174120,is_tv = 0};

get_lv_cfg(1452) ->
	#pet_lv_cfg{lv = 1452,max_exp = 2373403196,attr = [{1,5804},{2,116080},{3,2902},{4,2902}],combat = 174240,is_tv = 0};

get_lv_cfg(1453) ->
	#pet_lv_cfg{lv = 1453,max_exp = 2392592161,attr = [{1,5808},{2,116160},{3,2904},{4,2904}],combat = 174360,is_tv = 0};

get_lv_cfg(1454) ->
	#pet_lv_cfg{lv = 1454,max_exp = 2411936269,attr = [{1,5812},{2,116240},{3,2906},{4,2906}],combat = 174480,is_tv = 0};

get_lv_cfg(1455) ->
	#pet_lv_cfg{lv = 1455,max_exp = 2431436774,attr = [{1,5816},{2,116320},{3,2908},{4,2908}],combat = 174600,is_tv = 0};

get_lv_cfg(1456) ->
	#pet_lv_cfg{lv = 1456,max_exp = 2451094940,attr = [{1,5820},{2,116400},{3,2910},{4,2910}],combat = 174720,is_tv = 0};

get_lv_cfg(1457) ->
	#pet_lv_cfg{lv = 1457,max_exp = 2470912043,attr = [{1,5824},{2,116480},{3,2912},{4,2912}],combat = 174840,is_tv = 0};

get_lv_cfg(1458) ->
	#pet_lv_cfg{lv = 1458,max_exp = 2490889367,attr = [{1,5828},{2,116560},{3,2914},{4,2914}],combat = 174960,is_tv = 0};

get_lv_cfg(1459) ->
	#pet_lv_cfg{lv = 1459,max_exp = 2511028208,attr = [{1,5832},{2,116640},{3,2916},{4,2916}],combat = 175080,is_tv = 0};

get_lv_cfg(1460) ->
	#pet_lv_cfg{lv = 1460,max_exp = 2531329871,attr = [{1,5836},{2,116720},{3,2918},{4,2918}],combat = 175200,is_tv = 0};

get_lv_cfg(1461) ->
	#pet_lv_cfg{lv = 1461,max_exp = 2551795673,attr = [{1,5840},{2,116800},{3,2920},{4,2920}],combat = 175320,is_tv = 0};

get_lv_cfg(1462) ->
	#pet_lv_cfg{lv = 1462,max_exp = 2572426941,attr = [{1,5844},{2,116880},{3,2922},{4,2922}],combat = 175440,is_tv = 0};

get_lv_cfg(1463) ->
	#pet_lv_cfg{lv = 1463,max_exp = 2593225013,attr = [{1,5848},{2,116960},{3,2924},{4,2924}],combat = 175560,is_tv = 0};

get_lv_cfg(1464) ->
	#pet_lv_cfg{lv = 1464,max_exp = 2614191237,attr = [{1,5852},{2,117040},{3,2926},{4,2926}],combat = 175680,is_tv = 0};

get_lv_cfg(1465) ->
	#pet_lv_cfg{lv = 1465,max_exp = 2635326973,attr = [{1,5856},{2,117120},{3,2928},{4,2928}],combat = 175800,is_tv = 0};

get_lv_cfg(1466) ->
	#pet_lv_cfg{lv = 1466,max_exp = 2656633592,attr = [{1,5860},{2,117200},{3,2930},{4,2930}],combat = 175920,is_tv = 0};

get_lv_cfg(1467) ->
	#pet_lv_cfg{lv = 1467,max_exp = 2678112475,attr = [{1,5864},{2,117280},{3,2932},{4,2932}],combat = 176040,is_tv = 0};

get_lv_cfg(1468) ->
	#pet_lv_cfg{lv = 1468,max_exp = 2699765014,attr = [{1,5868},{2,117360},{3,2934},{4,2934}],combat = 176160,is_tv = 0};

get_lv_cfg(1469) ->
	#pet_lv_cfg{lv = 1469,max_exp = 2721592614,attr = [{1,5872},{2,117440},{3,2936},{4,2936}],combat = 176280,is_tv = 0};

get_lv_cfg(1470) ->
	#pet_lv_cfg{lv = 1470,max_exp = 2743596690,attr = [{1,5876},{2,117520},{3,2938},{4,2938}],combat = 176400,is_tv = 0};

get_lv_cfg(1471) ->
	#pet_lv_cfg{lv = 1471,max_exp = 2765778669,attr = [{1,5880},{2,117600},{3,2940},{4,2940}],combat = 176520,is_tv = 0};

get_lv_cfg(1472) ->
	#pet_lv_cfg{lv = 1472,max_exp = 2788139990,attr = [{1,5884},{2,117680},{3,2942},{4,2942}],combat = 176640,is_tv = 0};

get_lv_cfg(1473) ->
	#pet_lv_cfg{lv = 1473,max_exp = 2810682102,attr = [{1,5888},{2,117760},{3,2944},{4,2944}],combat = 176760,is_tv = 0};

get_lv_cfg(1474) ->
	#pet_lv_cfg{lv = 1474,max_exp = 2833406467,attr = [{1,5892},{2,117840},{3,2946},{4,2946}],combat = 176880,is_tv = 0};

get_lv_cfg(1475) ->
	#pet_lv_cfg{lv = 1475,max_exp = 2856314558,attr = [{1,5896},{2,117920},{3,2948},{4,2948}],combat = 177000,is_tv = 0};

get_lv_cfg(1476) ->
	#pet_lv_cfg{lv = 1476,max_exp = 2879407861,attr = [{1,5900},{2,118000},{3,2950},{4,2950}],combat = 177120,is_tv = 0};

get_lv_cfg(1477) ->
	#pet_lv_cfg{lv = 1477,max_exp = 2902687874,attr = [{1,5904},{2,118080},{3,2952},{4,2952}],combat = 177240,is_tv = 0};

get_lv_cfg(1478) ->
	#pet_lv_cfg{lv = 1478,max_exp = 2926156105,attr = [{1,5908},{2,118160},{3,2954},{4,2954}],combat = 177360,is_tv = 0};

get_lv_cfg(1479) ->
	#pet_lv_cfg{lv = 1479,max_exp = 2949814077,attr = [{1,5912},{2,118240},{3,2956},{4,2956}],combat = 177480,is_tv = 0};

get_lv_cfg(1480) ->
	#pet_lv_cfg{lv = 1480,max_exp = 2973663324,attr = [{1,5916},{2,118320},{3,2958},{4,2958}],combat = 177600,is_tv = 0};

get_lv_cfg(1481) ->
	#pet_lv_cfg{lv = 1481,max_exp = 2997705392,attr = [{1,5920},{2,118400},{3,2960},{4,2960}],combat = 177720,is_tv = 0};

get_lv_cfg(1482) ->
	#pet_lv_cfg{lv = 1482,max_exp = 3021941840,attr = [{1,5924},{2,118480},{3,2962},{4,2962}],combat = 177840,is_tv = 0};

get_lv_cfg(1483) ->
	#pet_lv_cfg{lv = 1483,max_exp = 3046374240,attr = [{1,5928},{2,118560},{3,2964},{4,2964}],combat = 177960,is_tv = 0};

get_lv_cfg(1484) ->
	#pet_lv_cfg{lv = 1484,max_exp = 3071004176,attr = [{1,5932},{2,118640},{3,2966},{4,2966}],combat = 178080,is_tv = 0};

get_lv_cfg(1485) ->
	#pet_lv_cfg{lv = 1485,max_exp = 3095833245,attr = [{1,5936},{2,118720},{3,2968},{4,2968}],combat = 178200,is_tv = 0};

get_lv_cfg(1486) ->
	#pet_lv_cfg{lv = 1486,max_exp = 3120863057,attr = [{1,5940},{2,118800},{3,2970},{4,2970}],combat = 178320,is_tv = 0};

get_lv_cfg(1487) ->
	#pet_lv_cfg{lv = 1487,max_exp = 3146095235,attr = [{1,5944},{2,118880},{3,2972},{4,2972}],combat = 178440,is_tv = 0};

get_lv_cfg(1488) ->
	#pet_lv_cfg{lv = 1488,max_exp = 3171531415,attr = [{1,5948},{2,118960},{3,2974},{4,2974}],combat = 178560,is_tv = 0};

get_lv_cfg(1489) ->
	#pet_lv_cfg{lv = 1489,max_exp = 3197173246,attr = [{1,5952},{2,119040},{3,2976},{4,2976}],combat = 178680,is_tv = 0};

get_lv_cfg(1490) ->
	#pet_lv_cfg{lv = 1490,max_exp = 3223022392,attr = [{1,5956},{2,119120},{3,2978},{4,2978}],combat = 178800,is_tv = 0};

get_lv_cfg(1491) ->
	#pet_lv_cfg{lv = 1491,max_exp = 3249080528,attr = [{1,5960},{2,119200},{3,2980},{4,2980}],combat = 178920,is_tv = 0};

get_lv_cfg(1492) ->
	#pet_lv_cfg{lv = 1492,max_exp = 3275349344,attr = [{1,5964},{2,119280},{3,2982},{4,2982}],combat = 179040,is_tv = 0};

get_lv_cfg(1493) ->
	#pet_lv_cfg{lv = 1493,max_exp = 3301830543,attr = [{1,5968},{2,119360},{3,2984},{4,2984}],combat = 179160,is_tv = 0};

get_lv_cfg(1494) ->
	#pet_lv_cfg{lv = 1494,max_exp = 3328525843,attr = [{1,5972},{2,119440},{3,2986},{4,2986}],combat = 179280,is_tv = 0};

get_lv_cfg(1495) ->
	#pet_lv_cfg{lv = 1495,max_exp = 3355436974,attr = [{1,5976},{2,119520},{3,2988},{4,2988}],combat = 179400,is_tv = 0};

get_lv_cfg(1496) ->
	#pet_lv_cfg{lv = 1496,max_exp = 3382565682,attr = [{1,5980},{2,119600},{3,2990},{4,2990}],combat = 179520,is_tv = 0};

get_lv_cfg(1497) ->
	#pet_lv_cfg{lv = 1497,max_exp = 3409913726,attr = [{1,5984},{2,119680},{3,2992},{4,2992}],combat = 179640,is_tv = 0};

get_lv_cfg(1498) ->
	#pet_lv_cfg{lv = 1498,max_exp = 3437482878,attr = [{1,5988},{2,119760},{3,2994},{4,2994}],combat = 179760,is_tv = 0};

get_lv_cfg(1499) ->
	#pet_lv_cfg{lv = 1499,max_exp = 3465274927,attr = [{1,5992},{2,119840},{3,2996},{4,2996}],combat = 179880,is_tv = 0};

get_lv_cfg(1500) ->
	#pet_lv_cfg{lv = 1500,max_exp = 3493291675,attr = [{1,5996},{2,119920},{3,2998},{4,2998}],combat = 180000,is_tv = 1};

get_lv_cfg(1501) ->
	#pet_lv_cfg{lv = 1501,max_exp = 3521534938,attr = [{1,6000},{2,120000},{3,3000},{4,3000}],combat = 180120,is_tv = 0};

get_lv_cfg(1502) ->
	#pet_lv_cfg{lv = 1502,max_exp = 3550006548,attr = [{1,6004},{2,120080},{3,3002},{4,3002}],combat = 180240,is_tv = 0};

get_lv_cfg(1503) ->
	#pet_lv_cfg{lv = 1503,max_exp = 3578708351,attr = [{1,6008},{2,120160},{3,3004},{4,3004}],combat = 180360,is_tv = 0};

get_lv_cfg(1504) ->
	#pet_lv_cfg{lv = 1504,max_exp = 3607642208,attr = [{1,6012},{2,120240},{3,3006},{4,3006}],combat = 180480,is_tv = 0};

get_lv_cfg(1505) ->
	#pet_lv_cfg{lv = 1505,max_exp = 3636809995,attr = [{1,6016},{2,120320},{3,3008},{4,3008}],combat = 180600,is_tv = 0};

get_lv_cfg(1506) ->
	#pet_lv_cfg{lv = 1506,max_exp = 3666213604,attr = [{1,6020},{2,120400},{3,3010},{4,3010}],combat = 180720,is_tv = 0};

get_lv_cfg(1507) ->
	#pet_lv_cfg{lv = 1507,max_exp = 3695854941,attr = [{1,6024},{2,120480},{3,3012},{4,3012}],combat = 180840,is_tv = 0};

get_lv_cfg(1508) ->
	#pet_lv_cfg{lv = 1508,max_exp = 3725735928,attr = [{1,6028},{2,120560},{3,3014},{4,3014}],combat = 180960,is_tv = 0};

get_lv_cfg(1509) ->
	#pet_lv_cfg{lv = 1509,max_exp = 3755858503,attr = [{1,6032},{2,120640},{3,3016},{4,3016}],combat = 181080,is_tv = 0};

get_lv_cfg(1510) ->
	#pet_lv_cfg{lv = 1510,max_exp = 3786224619,attr = [{1,6036},{2,120720},{3,3018},{4,3018}],combat = 181200,is_tv = 0};

get_lv_cfg(1511) ->
	#pet_lv_cfg{lv = 1511,max_exp = 3816836245,attr = [{1,6040},{2,120800},{3,3020},{4,3020}],combat = 181320,is_tv = 0};

get_lv_cfg(1512) ->
	#pet_lv_cfg{lv = 1512,max_exp = 3847695366,attr = [{1,6044},{2,120880},{3,3022},{4,3022}],combat = 181440,is_tv = 0};

get_lv_cfg(1513) ->
	#pet_lv_cfg{lv = 1513,max_exp = 3878803983,attr = [{1,6048},{2,120960},{3,3024},{4,3024}],combat = 181560,is_tv = 0};

get_lv_cfg(1514) ->
	#pet_lv_cfg{lv = 1514,max_exp = 3910164113,attr = [{1,6052},{2,121040},{3,3026},{4,3026}],combat = 181680,is_tv = 0};

get_lv_cfg(1515) ->
	#pet_lv_cfg{lv = 1515,max_exp = 3941777790,attr = [{1,6056},{2,121120},{3,3028},{4,3028}],combat = 181800,is_tv = 0};

get_lv_cfg(1516) ->
	#pet_lv_cfg{lv = 1516,max_exp = 3973647063,attr = [{1,6060},{2,121200},{3,3030},{4,3030}],combat = 181920,is_tv = 0};

get_lv_cfg(1517) ->
	#pet_lv_cfg{lv = 1517,max_exp = 4005774000,attr = [{1,6064},{2,121280},{3,3032},{4,3032}],combat = 182040,is_tv = 0};

get_lv_cfg(1518) ->
	#pet_lv_cfg{lv = 1518,max_exp = 4038160683,attr = [{1,6068},{2,121360},{3,3034},{4,3034}],combat = 182160,is_tv = 0};

get_lv_cfg(1519) ->
	#pet_lv_cfg{lv = 1519,max_exp = 4070809212,attr = [{1,6072},{2,121440},{3,3036},{4,3036}],combat = 182280,is_tv = 0};

get_lv_cfg(1520) ->
	#pet_lv_cfg{lv = 1520,max_exp = 4103721704,attr = [{1,6076},{2,121520},{3,3038},{4,3038}],combat = 182400,is_tv = 0};

get_lv_cfg(1521) ->
	#pet_lv_cfg{lv = 1521,max_exp = 4136900294,attr = [{1,6080},{2,121600},{3,3040},{4,3040}],combat = 182520,is_tv = 0};

get_lv_cfg(1522) ->
	#pet_lv_cfg{lv = 1522,max_exp = 4170347133,attr = [{1,6084},{2,121680},{3,3042},{4,3042}],combat = 182640,is_tv = 0};

get_lv_cfg(1523) ->
	#pet_lv_cfg{lv = 1523,max_exp = 4204064390,attr = [{1,6088},{2,121760},{3,3044},{4,3044}],combat = 182760,is_tv = 0};

get_lv_cfg(1524) ->
	#pet_lv_cfg{lv = 1524,max_exp = 4238054251,attr = [{1,6092},{2,121840},{3,3046},{4,3046}],combat = 182880,is_tv = 0};

get_lv_cfg(1525) ->
	#pet_lv_cfg{lv = 1525,max_exp = 4272318920,attr = [{1,6096},{2,121920},{3,3048},{4,3048}],combat = 183000,is_tv = 0};

get_lv_cfg(1526) ->
	#pet_lv_cfg{lv = 1526,max_exp = 4294967295,attr = [{1,6100},{2,122000},{3,3050},{4,3050}],combat = 183120,is_tv = 0};

get_lv_cfg(1527) ->
	#pet_lv_cfg{lv = 1527,max_exp = 4294967295,attr = [{1,6104},{2,122080},{3,3052},{4,3052}],combat = 183240,is_tv = 0};

get_lv_cfg(1528) ->
	#pet_lv_cfg{lv = 1528,max_exp = 4294967295,attr = [{1,6108},{2,122160},{3,3054},{4,3054}],combat = 183360,is_tv = 0};

get_lv_cfg(1529) ->
	#pet_lv_cfg{lv = 1529,max_exp = 4294967295,attr = [{1,6112},{2,122240},{3,3056},{4,3056}],combat = 183480,is_tv = 0};

get_lv_cfg(1530) ->
	#pet_lv_cfg{lv = 1530,max_exp = 4294967295,attr = [{1,6116},{2,122320},{3,3058},{4,3058}],combat = 183600,is_tv = 0};

get_lv_cfg(1531) ->
	#pet_lv_cfg{lv = 1531,max_exp = 4294967295,attr = [{1,6120},{2,122400},{3,3060},{4,3060}],combat = 183720,is_tv = 0};

get_lv_cfg(1532) ->
	#pet_lv_cfg{lv = 1532,max_exp = 4294967295,attr = [{1,6124},{2,122480},{3,3062},{4,3062}],combat = 183840,is_tv = 0};

get_lv_cfg(1533) ->
	#pet_lv_cfg{lv = 1533,max_exp = 4294967295,attr = [{1,6128},{2,122560},{3,3064},{4,3064}],combat = 183960,is_tv = 0};

get_lv_cfg(1534) ->
	#pet_lv_cfg{lv = 1534,max_exp = 4294967295,attr = [{1,6132},{2,122640},{3,3066},{4,3066}],combat = 184080,is_tv = 0};

get_lv_cfg(1535) ->
	#pet_lv_cfg{lv = 1535,max_exp = 4294967295,attr = [{1,6136},{2,122720},{3,3068},{4,3068}],combat = 184200,is_tv = 0};

get_lv_cfg(1536) ->
	#pet_lv_cfg{lv = 1536,max_exp = 4294967295,attr = [{1,6140},{2,122800},{3,3070},{4,3070}],combat = 184320,is_tv = 0};

get_lv_cfg(1537) ->
	#pet_lv_cfg{lv = 1537,max_exp = 4294967295,attr = [{1,6144},{2,122880},{3,3072},{4,3072}],combat = 184440,is_tv = 0};

get_lv_cfg(1538) ->
	#pet_lv_cfg{lv = 1538,max_exp = 4294967295,attr = [{1,6148},{2,122960},{3,3074},{4,3074}],combat = 184560,is_tv = 0};

get_lv_cfg(1539) ->
	#pet_lv_cfg{lv = 1539,max_exp = 4294967295,attr = [{1,6152},{2,123040},{3,3076},{4,3076}],combat = 184680,is_tv = 0};

get_lv_cfg(1540) ->
	#pet_lv_cfg{lv = 1540,max_exp = 4294967295,attr = [{1,6156},{2,123120},{3,3078},{4,3078}],combat = 184800,is_tv = 0};

get_lv_cfg(1541) ->
	#pet_lv_cfg{lv = 1541,max_exp = 4294967295,attr = [{1,6160},{2,123200},{3,3080},{4,3080}],combat = 184920,is_tv = 0};

get_lv_cfg(1542) ->
	#pet_lv_cfg{lv = 1542,max_exp = 4294967295,attr = [{1,6164},{2,123280},{3,3082},{4,3082}],combat = 185040,is_tv = 0};

get_lv_cfg(1543) ->
	#pet_lv_cfg{lv = 1543,max_exp = 4294967295,attr = [{1,6168},{2,123360},{3,3084},{4,3084}],combat = 185160,is_tv = 0};

get_lv_cfg(1544) ->
	#pet_lv_cfg{lv = 1544,max_exp = 4294967295,attr = [{1,6172},{2,123440},{3,3086},{4,3086}],combat = 185280,is_tv = 0};

get_lv_cfg(1545) ->
	#pet_lv_cfg{lv = 1545,max_exp = 4294967295,attr = [{1,6176},{2,123520},{3,3088},{4,3088}],combat = 185400,is_tv = 0};

get_lv_cfg(1546) ->
	#pet_lv_cfg{lv = 1546,max_exp = 4294967295,attr = [{1,6180},{2,123600},{3,3090},{4,3090}],combat = 185520,is_tv = 0};

get_lv_cfg(1547) ->
	#pet_lv_cfg{lv = 1547,max_exp = 4294967295,attr = [{1,6184},{2,123680},{3,3092},{4,3092}],combat = 185640,is_tv = 0};

get_lv_cfg(1548) ->
	#pet_lv_cfg{lv = 1548,max_exp = 4294967295,attr = [{1,6188},{2,123760},{3,3094},{4,3094}],combat = 185760,is_tv = 0};

get_lv_cfg(1549) ->
	#pet_lv_cfg{lv = 1549,max_exp = 4294967295,attr = [{1,6192},{2,123840},{3,3096},{4,3096}],combat = 185880,is_tv = 0};

get_lv_cfg(1550) ->
	#pet_lv_cfg{lv = 1550,max_exp = 4294967295,attr = [{1,6196},{2,123920},{3,3098},{4,3098}],combat = 186000,is_tv = 1};

get_lv_cfg(1551) ->
	#pet_lv_cfg{lv = 1551,max_exp = 4294967295,attr = [{1,6200},{2,124000},{3,3100},{4,3100}],combat = 186120,is_tv = 0};

get_lv_cfg(1552) ->
	#pet_lv_cfg{lv = 1552,max_exp = 4294967295,attr = [{1,6204},{2,124080},{3,3102},{4,3102}],combat = 186240,is_tv = 0};

get_lv_cfg(1553) ->
	#pet_lv_cfg{lv = 1553,max_exp = 4294967295,attr = [{1,6208},{2,124160},{3,3104},{4,3104}],combat = 186360,is_tv = 0};

get_lv_cfg(1554) ->
	#pet_lv_cfg{lv = 1554,max_exp = 4294967295,attr = [{1,6212},{2,124240},{3,3106},{4,3106}],combat = 186480,is_tv = 0};

get_lv_cfg(1555) ->
	#pet_lv_cfg{lv = 1555,max_exp = 4294967295,attr = [{1,6216},{2,124320},{3,3108},{4,3108}],combat = 186600,is_tv = 0};

get_lv_cfg(1556) ->
	#pet_lv_cfg{lv = 1556,max_exp = 4294967295,attr = [{1,6220},{2,124400},{3,3110},{4,3110}],combat = 186720,is_tv = 0};

get_lv_cfg(1557) ->
	#pet_lv_cfg{lv = 1557,max_exp = 4294967295,attr = [{1,6224},{2,124480},{3,3112},{4,3112}],combat = 186840,is_tv = 0};

get_lv_cfg(1558) ->
	#pet_lv_cfg{lv = 1558,max_exp = 4294967295,attr = [{1,6228},{2,124560},{3,3114},{4,3114}],combat = 186960,is_tv = 0};

get_lv_cfg(1559) ->
	#pet_lv_cfg{lv = 1559,max_exp = 4294967295,attr = [{1,6232},{2,124640},{3,3116},{4,3116}],combat = 187080,is_tv = 0};

get_lv_cfg(1560) ->
	#pet_lv_cfg{lv = 1560,max_exp = 4294967295,attr = [{1,6236},{2,124720},{3,3118},{4,3118}],combat = 187200,is_tv = 0};

get_lv_cfg(1561) ->
	#pet_lv_cfg{lv = 1561,max_exp = 4294967295,attr = [{1,6240},{2,124800},{3,3120},{4,3120}],combat = 187320,is_tv = 0};

get_lv_cfg(1562) ->
	#pet_lv_cfg{lv = 1562,max_exp = 4294967295,attr = [{1,6244},{2,124880},{3,3122},{4,3122}],combat = 187440,is_tv = 0};

get_lv_cfg(1563) ->
	#pet_lv_cfg{lv = 1563,max_exp = 4294967295,attr = [{1,6248},{2,124960},{3,3124},{4,3124}],combat = 187560,is_tv = 0};

get_lv_cfg(1564) ->
	#pet_lv_cfg{lv = 1564,max_exp = 4294967295,attr = [{1,6252},{2,125040},{3,3126},{4,3126}],combat = 187680,is_tv = 0};

get_lv_cfg(1565) ->
	#pet_lv_cfg{lv = 1565,max_exp = 4294967295,attr = [{1,6256},{2,125120},{3,3128},{4,3128}],combat = 187800,is_tv = 0};

get_lv_cfg(1566) ->
	#pet_lv_cfg{lv = 1566,max_exp = 4294967295,attr = [{1,6260},{2,125200},{3,3130},{4,3130}],combat = 187920,is_tv = 0};

get_lv_cfg(1567) ->
	#pet_lv_cfg{lv = 1567,max_exp = 4294967295,attr = [{1,6264},{2,125280},{3,3132},{4,3132}],combat = 188040,is_tv = 0};

get_lv_cfg(1568) ->
	#pet_lv_cfg{lv = 1568,max_exp = 4294967295,attr = [{1,6268},{2,125360},{3,3134},{4,3134}],combat = 188160,is_tv = 0};

get_lv_cfg(1569) ->
	#pet_lv_cfg{lv = 1569,max_exp = 4294967295,attr = [{1,6272},{2,125440},{3,3136},{4,3136}],combat = 188280,is_tv = 0};

get_lv_cfg(1570) ->
	#pet_lv_cfg{lv = 1570,max_exp = 4294967295,attr = [{1,6276},{2,125520},{3,3138},{4,3138}],combat = 188400,is_tv = 0};

get_lv_cfg(1571) ->
	#pet_lv_cfg{lv = 1571,max_exp = 4294967295,attr = [{1,6280},{2,125600},{3,3140},{4,3140}],combat = 188520,is_tv = 0};

get_lv_cfg(1572) ->
	#pet_lv_cfg{lv = 1572,max_exp = 4294967295,attr = [{1,6284},{2,125680},{3,3142},{4,3142}],combat = 188640,is_tv = 0};

get_lv_cfg(1573) ->
	#pet_lv_cfg{lv = 1573,max_exp = 4294967295,attr = [{1,6288},{2,125760},{3,3144},{4,3144}],combat = 188760,is_tv = 0};

get_lv_cfg(1574) ->
	#pet_lv_cfg{lv = 1574,max_exp = 4294967295,attr = [{1,6292},{2,125840},{3,3146},{4,3146}],combat = 188880,is_tv = 0};

get_lv_cfg(1575) ->
	#pet_lv_cfg{lv = 1575,max_exp = 4294967295,attr = [{1,6296},{2,125920},{3,3148},{4,3148}],combat = 189000,is_tv = 0};

get_lv_cfg(1576) ->
	#pet_lv_cfg{lv = 1576,max_exp = 4294967295,attr = [{1,6300},{2,126000},{3,3150},{4,3150}],combat = 189120,is_tv = 0};

get_lv_cfg(1577) ->
	#pet_lv_cfg{lv = 1577,max_exp = 4294967295,attr = [{1,6304},{2,126080},{3,3152},{4,3152}],combat = 189240,is_tv = 0};

get_lv_cfg(1578) ->
	#pet_lv_cfg{lv = 1578,max_exp = 4294967295,attr = [{1,6308},{2,126160},{3,3154},{4,3154}],combat = 189360,is_tv = 0};

get_lv_cfg(1579) ->
	#pet_lv_cfg{lv = 1579,max_exp = 4294967295,attr = [{1,6312},{2,126240},{3,3156},{4,3156}],combat = 189480,is_tv = 0};

get_lv_cfg(1580) ->
	#pet_lv_cfg{lv = 1580,max_exp = 4294967295,attr = [{1,6316},{2,126320},{3,3158},{4,3158}],combat = 189600,is_tv = 0};

get_lv_cfg(1581) ->
	#pet_lv_cfg{lv = 1581,max_exp = 4294967295,attr = [{1,6320},{2,126400},{3,3160},{4,3160}],combat = 189720,is_tv = 0};

get_lv_cfg(1582) ->
	#pet_lv_cfg{lv = 1582,max_exp = 4294967295,attr = [{1,6324},{2,126480},{3,3162},{4,3162}],combat = 189840,is_tv = 0};

get_lv_cfg(1583) ->
	#pet_lv_cfg{lv = 1583,max_exp = 4294967295,attr = [{1,6328},{2,126560},{3,3164},{4,3164}],combat = 189960,is_tv = 0};

get_lv_cfg(1584) ->
	#pet_lv_cfg{lv = 1584,max_exp = 4294967295,attr = [{1,6332},{2,126640},{3,3166},{4,3166}],combat = 190080,is_tv = 0};

get_lv_cfg(1585) ->
	#pet_lv_cfg{lv = 1585,max_exp = 4294967295,attr = [{1,6336},{2,126720},{3,3168},{4,3168}],combat = 190200,is_tv = 0};

get_lv_cfg(1586) ->
	#pet_lv_cfg{lv = 1586,max_exp = 4294967295,attr = [{1,6340},{2,126800},{3,3170},{4,3170}],combat = 190320,is_tv = 0};

get_lv_cfg(1587) ->
	#pet_lv_cfg{lv = 1587,max_exp = 4294967295,attr = [{1,6344},{2,126880},{3,3172},{4,3172}],combat = 190440,is_tv = 0};

get_lv_cfg(1588) ->
	#pet_lv_cfg{lv = 1588,max_exp = 4294967295,attr = [{1,6348},{2,126960},{3,3174},{4,3174}],combat = 190560,is_tv = 0};

get_lv_cfg(1589) ->
	#pet_lv_cfg{lv = 1589,max_exp = 4294967295,attr = [{1,6352},{2,127040},{3,3176},{4,3176}],combat = 190680,is_tv = 0};

get_lv_cfg(1590) ->
	#pet_lv_cfg{lv = 1590,max_exp = 4294967295,attr = [{1,6356},{2,127120},{3,3178},{4,3178}],combat = 190800,is_tv = 0};

get_lv_cfg(1591) ->
	#pet_lv_cfg{lv = 1591,max_exp = 4294967295,attr = [{1,6360},{2,127200},{3,3180},{4,3180}],combat = 190920,is_tv = 0};

get_lv_cfg(1592) ->
	#pet_lv_cfg{lv = 1592,max_exp = 4294967295,attr = [{1,6364},{2,127280},{3,3182},{4,3182}],combat = 191040,is_tv = 0};

get_lv_cfg(1593) ->
	#pet_lv_cfg{lv = 1593,max_exp = 4294967295,attr = [{1,6368},{2,127360},{3,3184},{4,3184}],combat = 191160,is_tv = 0};

get_lv_cfg(1594) ->
	#pet_lv_cfg{lv = 1594,max_exp = 4294967295,attr = [{1,6372},{2,127440},{3,3186},{4,3186}],combat = 191280,is_tv = 0};

get_lv_cfg(1595) ->
	#pet_lv_cfg{lv = 1595,max_exp = 4294967295,attr = [{1,6376},{2,127520},{3,3188},{4,3188}],combat = 191400,is_tv = 0};

get_lv_cfg(1596) ->
	#pet_lv_cfg{lv = 1596,max_exp = 4294967295,attr = [{1,6380},{2,127600},{3,3190},{4,3190}],combat = 191520,is_tv = 0};

get_lv_cfg(1597) ->
	#pet_lv_cfg{lv = 1597,max_exp = 4294967295,attr = [{1,6384},{2,127680},{3,3192},{4,3192}],combat = 191640,is_tv = 0};

get_lv_cfg(1598) ->
	#pet_lv_cfg{lv = 1598,max_exp = 4294967295,attr = [{1,6388},{2,127760},{3,3194},{4,3194}],combat = 191760,is_tv = 0};

get_lv_cfg(1599) ->
	#pet_lv_cfg{lv = 1599,max_exp = 4294967295,attr = [{1,6392},{2,127840},{3,3196},{4,3196}],combat = 191880,is_tv = 0};

get_lv_cfg(1600) ->
	#pet_lv_cfg{lv = 1600,max_exp = 4294967295,attr = [{1,6396},{2,127920},{3,3198},{4,3198}],combat = 192000,is_tv = 1};

get_lv_cfg(1601) ->
	#pet_lv_cfg{lv = 1601,max_exp = 4294967295,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],combat = 192120,is_tv = 0};

get_lv_cfg(1602) ->
	#pet_lv_cfg{lv = 1602,max_exp = 4294967295,attr = [{1,6404},{2,128080},{3,3202},{4,3202}],combat = 192240,is_tv = 0};

get_lv_cfg(1603) ->
	#pet_lv_cfg{lv = 1603,max_exp = 4294967295,attr = [{1,6408},{2,128160},{3,3204},{4,3204}],combat = 192360,is_tv = 0};

get_lv_cfg(1604) ->
	#pet_lv_cfg{lv = 1604,max_exp = 4294967295,attr = [{1,6412},{2,128240},{3,3206},{4,3206}],combat = 192480,is_tv = 0};

get_lv_cfg(1605) ->
	#pet_lv_cfg{lv = 1605,max_exp = 4294967295,attr = [{1,6416},{2,128320},{3,3208},{4,3208}],combat = 192600,is_tv = 0};

get_lv_cfg(1606) ->
	#pet_lv_cfg{lv = 1606,max_exp = 4294967295,attr = [{1,6420},{2,128400},{3,3210},{4,3210}],combat = 192720,is_tv = 0};

get_lv_cfg(1607) ->
	#pet_lv_cfg{lv = 1607,max_exp = 4294967295,attr = [{1,6424},{2,128480},{3,3212},{4,3212}],combat = 192840,is_tv = 0};

get_lv_cfg(1608) ->
	#pet_lv_cfg{lv = 1608,max_exp = 4294967295,attr = [{1,6428},{2,128560},{3,3214},{4,3214}],combat = 192960,is_tv = 0};

get_lv_cfg(1609) ->
	#pet_lv_cfg{lv = 1609,max_exp = 4294967295,attr = [{1,6432},{2,128640},{3,3216},{4,3216}],combat = 193080,is_tv = 0};

get_lv_cfg(1610) ->
	#pet_lv_cfg{lv = 1610,max_exp = 4294967295,attr = [{1,6436},{2,128720},{3,3218},{4,3218}],combat = 193200,is_tv = 0};

get_lv_cfg(1611) ->
	#pet_lv_cfg{lv = 1611,max_exp = 4294967295,attr = [{1,6440},{2,128800},{3,3220},{4,3220}],combat = 193320,is_tv = 0};

get_lv_cfg(1612) ->
	#pet_lv_cfg{lv = 1612,max_exp = 4294967295,attr = [{1,6444},{2,128880},{3,3222},{4,3222}],combat = 193440,is_tv = 0};

get_lv_cfg(1613) ->
	#pet_lv_cfg{lv = 1613,max_exp = 4294967295,attr = [{1,6448},{2,128960},{3,3224},{4,3224}],combat = 193560,is_tv = 0};

get_lv_cfg(1614) ->
	#pet_lv_cfg{lv = 1614,max_exp = 4294967295,attr = [{1,6452},{2,129040},{3,3226},{4,3226}],combat = 193680,is_tv = 0};

get_lv_cfg(1615) ->
	#pet_lv_cfg{lv = 1615,max_exp = 4294967295,attr = [{1,6456},{2,129120},{3,3228},{4,3228}],combat = 193800,is_tv = 0};

get_lv_cfg(1616) ->
	#pet_lv_cfg{lv = 1616,max_exp = 4294967295,attr = [{1,6460},{2,129200},{3,3230},{4,3230}],combat = 193920,is_tv = 0};

get_lv_cfg(1617) ->
	#pet_lv_cfg{lv = 1617,max_exp = 4294967295,attr = [{1,6464},{2,129280},{3,3232},{4,3232}],combat = 194040,is_tv = 0};

get_lv_cfg(1618) ->
	#pet_lv_cfg{lv = 1618,max_exp = 4294967295,attr = [{1,6468},{2,129360},{3,3234},{4,3234}],combat = 194160,is_tv = 0};

get_lv_cfg(1619) ->
	#pet_lv_cfg{lv = 1619,max_exp = 4294967295,attr = [{1,6472},{2,129440},{3,3236},{4,3236}],combat = 194280,is_tv = 0};

get_lv_cfg(1620) ->
	#pet_lv_cfg{lv = 1620,max_exp = 4294967295,attr = [{1,6476},{2,129520},{3,3238},{4,3238}],combat = 194400,is_tv = 0};

get_lv_cfg(1621) ->
	#pet_lv_cfg{lv = 1621,max_exp = 4294967295,attr = [{1,6480},{2,129600},{3,3240},{4,3240}],combat = 194520,is_tv = 0};

get_lv_cfg(1622) ->
	#pet_lv_cfg{lv = 1622,max_exp = 4294967295,attr = [{1,6484},{2,129680},{3,3242},{4,3242}],combat = 194640,is_tv = 0};

get_lv_cfg(1623) ->
	#pet_lv_cfg{lv = 1623,max_exp = 4294967295,attr = [{1,6488},{2,129760},{3,3244},{4,3244}],combat = 194760,is_tv = 0};

get_lv_cfg(1624) ->
	#pet_lv_cfg{lv = 1624,max_exp = 4294967295,attr = [{1,6492},{2,129840},{3,3246},{4,3246}],combat = 194880,is_tv = 0};

get_lv_cfg(1625) ->
	#pet_lv_cfg{lv = 1625,max_exp = 4294967295,attr = [{1,6496},{2,129920},{3,3248},{4,3248}],combat = 195000,is_tv = 0};

get_lv_cfg(1626) ->
	#pet_lv_cfg{lv = 1626,max_exp = 4294967295,attr = [{1,6500},{2,130000},{3,3250},{4,3250}],combat = 195120,is_tv = 0};

get_lv_cfg(1627) ->
	#pet_lv_cfg{lv = 1627,max_exp = 4294967295,attr = [{1,6504},{2,130080},{3,3252},{4,3252}],combat = 195240,is_tv = 0};

get_lv_cfg(1628) ->
	#pet_lv_cfg{lv = 1628,max_exp = 4294967295,attr = [{1,6508},{2,130160},{3,3254},{4,3254}],combat = 195360,is_tv = 0};

get_lv_cfg(1629) ->
	#pet_lv_cfg{lv = 1629,max_exp = 4294967295,attr = [{1,6512},{2,130240},{3,3256},{4,3256}],combat = 195480,is_tv = 0};

get_lv_cfg(1630) ->
	#pet_lv_cfg{lv = 1630,max_exp = 4294967295,attr = [{1,6516},{2,130320},{3,3258},{4,3258}],combat = 195600,is_tv = 0};

get_lv_cfg(1631) ->
	#pet_lv_cfg{lv = 1631,max_exp = 4294967295,attr = [{1,6520},{2,130400},{3,3260},{4,3260}],combat = 195720,is_tv = 0};

get_lv_cfg(1632) ->
	#pet_lv_cfg{lv = 1632,max_exp = 4294967295,attr = [{1,6524},{2,130480},{3,3262},{4,3262}],combat = 195840,is_tv = 0};

get_lv_cfg(1633) ->
	#pet_lv_cfg{lv = 1633,max_exp = 4294967295,attr = [{1,6528},{2,130560},{3,3264},{4,3264}],combat = 195960,is_tv = 0};

get_lv_cfg(1634) ->
	#pet_lv_cfg{lv = 1634,max_exp = 4294967295,attr = [{1,6532},{2,130640},{3,3266},{4,3266}],combat = 196080,is_tv = 0};

get_lv_cfg(1635) ->
	#pet_lv_cfg{lv = 1635,max_exp = 4294967295,attr = [{1,6536},{2,130720},{3,3268},{4,3268}],combat = 196200,is_tv = 0};

get_lv_cfg(1636) ->
	#pet_lv_cfg{lv = 1636,max_exp = 4294967295,attr = [{1,6540},{2,130800},{3,3270},{4,3270}],combat = 196320,is_tv = 0};

get_lv_cfg(1637) ->
	#pet_lv_cfg{lv = 1637,max_exp = 4294967295,attr = [{1,6544},{2,130880},{3,3272},{4,3272}],combat = 196440,is_tv = 0};

get_lv_cfg(1638) ->
	#pet_lv_cfg{lv = 1638,max_exp = 4294967295,attr = [{1,6548},{2,130960},{3,3274},{4,3274}],combat = 196560,is_tv = 0};

get_lv_cfg(1639) ->
	#pet_lv_cfg{lv = 1639,max_exp = 4294967295,attr = [{1,6552},{2,131040},{3,3276},{4,3276}],combat = 196680,is_tv = 0};

get_lv_cfg(1640) ->
	#pet_lv_cfg{lv = 1640,max_exp = 4294967295,attr = [{1,6556},{2,131120},{3,3278},{4,3278}],combat = 196800,is_tv = 0};

get_lv_cfg(1641) ->
	#pet_lv_cfg{lv = 1641,max_exp = 4294967295,attr = [{1,6560},{2,131200},{3,3280},{4,3280}],combat = 196920,is_tv = 0};

get_lv_cfg(1642) ->
	#pet_lv_cfg{lv = 1642,max_exp = 4294967295,attr = [{1,6564},{2,131280},{3,3282},{4,3282}],combat = 197040,is_tv = 0};

get_lv_cfg(1643) ->
	#pet_lv_cfg{lv = 1643,max_exp = 4294967295,attr = [{1,6568},{2,131360},{3,3284},{4,3284}],combat = 197160,is_tv = 0};

get_lv_cfg(1644) ->
	#pet_lv_cfg{lv = 1644,max_exp = 4294967295,attr = [{1,6572},{2,131440},{3,3286},{4,3286}],combat = 197280,is_tv = 0};

get_lv_cfg(1645) ->
	#pet_lv_cfg{lv = 1645,max_exp = 4294967295,attr = [{1,6576},{2,131520},{3,3288},{4,3288}],combat = 197400,is_tv = 0};

get_lv_cfg(1646) ->
	#pet_lv_cfg{lv = 1646,max_exp = 4294967295,attr = [{1,6580},{2,131600},{3,3290},{4,3290}],combat = 197520,is_tv = 0};

get_lv_cfg(1647) ->
	#pet_lv_cfg{lv = 1647,max_exp = 4294967295,attr = [{1,6584},{2,131680},{3,3292},{4,3292}],combat = 197640,is_tv = 0};

get_lv_cfg(1648) ->
	#pet_lv_cfg{lv = 1648,max_exp = 4294967295,attr = [{1,6588},{2,131760},{3,3294},{4,3294}],combat = 197760,is_tv = 0};

get_lv_cfg(1649) ->
	#pet_lv_cfg{lv = 1649,max_exp = 4294967295,attr = [{1,6592},{2,131840},{3,3296},{4,3296}],combat = 197880,is_tv = 0};

get_lv_cfg(1650) ->
	#pet_lv_cfg{lv = 1650,max_exp = 4294967295,attr = [{1,6596},{2,131920},{3,3298},{4,3298}],combat = 198000,is_tv = 1};

get_lv_cfg(1651) ->
	#pet_lv_cfg{lv = 1651,max_exp = 4294967295,attr = [{1,6600},{2,132000},{3,3300},{4,3300}],combat = 198120,is_tv = 0};

get_lv_cfg(1652) ->
	#pet_lv_cfg{lv = 1652,max_exp = 4294967295,attr = [{1,6604},{2,132080},{3,3302},{4,3302}],combat = 198240,is_tv = 0};

get_lv_cfg(1653) ->
	#pet_lv_cfg{lv = 1653,max_exp = 4294967295,attr = [{1,6608},{2,132160},{3,3304},{4,3304}],combat = 198360,is_tv = 0};

get_lv_cfg(1654) ->
	#pet_lv_cfg{lv = 1654,max_exp = 4294967295,attr = [{1,6612},{2,132240},{3,3306},{4,3306}],combat = 198480,is_tv = 0};

get_lv_cfg(1655) ->
	#pet_lv_cfg{lv = 1655,max_exp = 4294967295,attr = [{1,6616},{2,132320},{3,3308},{4,3308}],combat = 198600,is_tv = 0};

get_lv_cfg(1656) ->
	#pet_lv_cfg{lv = 1656,max_exp = 4294967295,attr = [{1,6620},{2,132400},{3,3310},{4,3310}],combat = 198720,is_tv = 0};

get_lv_cfg(1657) ->
	#pet_lv_cfg{lv = 1657,max_exp = 4294967295,attr = [{1,6624},{2,132480},{3,3312},{4,3312}],combat = 198840,is_tv = 0};

get_lv_cfg(1658) ->
	#pet_lv_cfg{lv = 1658,max_exp = 4294967295,attr = [{1,6628},{2,132560},{3,3314},{4,3314}],combat = 198960,is_tv = 0};

get_lv_cfg(1659) ->
	#pet_lv_cfg{lv = 1659,max_exp = 4294967295,attr = [{1,6632},{2,132640},{3,3316},{4,3316}],combat = 199080,is_tv = 0};

get_lv_cfg(1660) ->
	#pet_lv_cfg{lv = 1660,max_exp = 4294967295,attr = [{1,6636},{2,132720},{3,3318},{4,3318}],combat = 199200,is_tv = 0};

get_lv_cfg(1661) ->
	#pet_lv_cfg{lv = 1661,max_exp = 4294967295,attr = [{1,6640},{2,132800},{3,3320},{4,3320}],combat = 199320,is_tv = 0};

get_lv_cfg(1662) ->
	#pet_lv_cfg{lv = 1662,max_exp = 4294967295,attr = [{1,6644},{2,132880},{3,3322},{4,3322}],combat = 199440,is_tv = 0};

get_lv_cfg(1663) ->
	#pet_lv_cfg{lv = 1663,max_exp = 4294967295,attr = [{1,6648},{2,132960},{3,3324},{4,3324}],combat = 199560,is_tv = 0};

get_lv_cfg(1664) ->
	#pet_lv_cfg{lv = 1664,max_exp = 4294967295,attr = [{1,6652},{2,133040},{3,3326},{4,3326}],combat = 199680,is_tv = 0};

get_lv_cfg(1665) ->
	#pet_lv_cfg{lv = 1665,max_exp = 4294967295,attr = [{1,6656},{2,133120},{3,3328},{4,3328}],combat = 199800,is_tv = 0};

get_lv_cfg(1666) ->
	#pet_lv_cfg{lv = 1666,max_exp = 4294967295,attr = [{1,6660},{2,133200},{3,3330},{4,3330}],combat = 199920,is_tv = 0};

get_lv_cfg(1667) ->
	#pet_lv_cfg{lv = 1667,max_exp = 4294967295,attr = [{1,6664},{2,133280},{3,3332},{4,3332}],combat = 200040,is_tv = 0};

get_lv_cfg(1668) ->
	#pet_lv_cfg{lv = 1668,max_exp = 4294967295,attr = [{1,6668},{2,133360},{3,3334},{4,3334}],combat = 200160,is_tv = 0};

get_lv_cfg(1669) ->
	#pet_lv_cfg{lv = 1669,max_exp = 4294967295,attr = [{1,6672},{2,133440},{3,3336},{4,3336}],combat = 200280,is_tv = 0};

get_lv_cfg(1670) ->
	#pet_lv_cfg{lv = 1670,max_exp = 4294967295,attr = [{1,6676},{2,133520},{3,3338},{4,3338}],combat = 200400,is_tv = 0};

get_lv_cfg(1671) ->
	#pet_lv_cfg{lv = 1671,max_exp = 4294967295,attr = [{1,6680},{2,133600},{3,3340},{4,3340}],combat = 200520,is_tv = 0};

get_lv_cfg(1672) ->
	#pet_lv_cfg{lv = 1672,max_exp = 4294967295,attr = [{1,6684},{2,133680},{3,3342},{4,3342}],combat = 200640,is_tv = 0};

get_lv_cfg(1673) ->
	#pet_lv_cfg{lv = 1673,max_exp = 4294967295,attr = [{1,6688},{2,133760},{3,3344},{4,3344}],combat = 200760,is_tv = 0};

get_lv_cfg(1674) ->
	#pet_lv_cfg{lv = 1674,max_exp = 4294967295,attr = [{1,6692},{2,133840},{3,3346},{4,3346}],combat = 200880,is_tv = 0};

get_lv_cfg(1675) ->
	#pet_lv_cfg{lv = 1675,max_exp = 4294967295,attr = [{1,6696},{2,133920},{3,3348},{4,3348}],combat = 201000,is_tv = 0};

get_lv_cfg(1676) ->
	#pet_lv_cfg{lv = 1676,max_exp = 4294967295,attr = [{1,6700},{2,134000},{3,3350},{4,3350}],combat = 201120,is_tv = 0};

get_lv_cfg(1677) ->
	#pet_lv_cfg{lv = 1677,max_exp = 4294967295,attr = [{1,6704},{2,134080},{3,3352},{4,3352}],combat = 201240,is_tv = 0};

get_lv_cfg(1678) ->
	#pet_lv_cfg{lv = 1678,max_exp = 4294967295,attr = [{1,6708},{2,134160},{3,3354},{4,3354}],combat = 201360,is_tv = 0};

get_lv_cfg(1679) ->
	#pet_lv_cfg{lv = 1679,max_exp = 4294967295,attr = [{1,6712},{2,134240},{3,3356},{4,3356}],combat = 201480,is_tv = 0};

get_lv_cfg(1680) ->
	#pet_lv_cfg{lv = 1680,max_exp = 4294967295,attr = [{1,6716},{2,134320},{3,3358},{4,3358}],combat = 201600,is_tv = 0};

get_lv_cfg(1681) ->
	#pet_lv_cfg{lv = 1681,max_exp = 4294967295,attr = [{1,6720},{2,134400},{3,3360},{4,3360}],combat = 201720,is_tv = 0};

get_lv_cfg(1682) ->
	#pet_lv_cfg{lv = 1682,max_exp = 4294967295,attr = [{1,6724},{2,134480},{3,3362},{4,3362}],combat = 201840,is_tv = 0};

get_lv_cfg(1683) ->
	#pet_lv_cfg{lv = 1683,max_exp = 4294967295,attr = [{1,6728},{2,134560},{3,3364},{4,3364}],combat = 201960,is_tv = 0};

get_lv_cfg(1684) ->
	#pet_lv_cfg{lv = 1684,max_exp = 4294967295,attr = [{1,6732},{2,134640},{3,3366},{4,3366}],combat = 202080,is_tv = 0};

get_lv_cfg(1685) ->
	#pet_lv_cfg{lv = 1685,max_exp = 4294967295,attr = [{1,6736},{2,134720},{3,3368},{4,3368}],combat = 202200,is_tv = 0};

get_lv_cfg(1686) ->
	#pet_lv_cfg{lv = 1686,max_exp = 4294967295,attr = [{1,6740},{2,134800},{3,3370},{4,3370}],combat = 202320,is_tv = 0};

get_lv_cfg(1687) ->
	#pet_lv_cfg{lv = 1687,max_exp = 4294967295,attr = [{1,6744},{2,134880},{3,3372},{4,3372}],combat = 202440,is_tv = 0};

get_lv_cfg(1688) ->
	#pet_lv_cfg{lv = 1688,max_exp = 4294967295,attr = [{1,6748},{2,134960},{3,3374},{4,3374}],combat = 202560,is_tv = 0};

get_lv_cfg(1689) ->
	#pet_lv_cfg{lv = 1689,max_exp = 4294967295,attr = [{1,6752},{2,135040},{3,3376},{4,3376}],combat = 202680,is_tv = 0};

get_lv_cfg(1690) ->
	#pet_lv_cfg{lv = 1690,max_exp = 4294967295,attr = [{1,6756},{2,135120},{3,3378},{4,3378}],combat = 202800,is_tv = 0};

get_lv_cfg(1691) ->
	#pet_lv_cfg{lv = 1691,max_exp = 4294967295,attr = [{1,6760},{2,135200},{3,3380},{4,3380}],combat = 202920,is_tv = 0};

get_lv_cfg(1692) ->
	#pet_lv_cfg{lv = 1692,max_exp = 4294967295,attr = [{1,6764},{2,135280},{3,3382},{4,3382}],combat = 203040,is_tv = 0};

get_lv_cfg(1693) ->
	#pet_lv_cfg{lv = 1693,max_exp = 4294967295,attr = [{1,6768},{2,135360},{3,3384},{4,3384}],combat = 203160,is_tv = 0};

get_lv_cfg(1694) ->
	#pet_lv_cfg{lv = 1694,max_exp = 4294967295,attr = [{1,6772},{2,135440},{3,3386},{4,3386}],combat = 203280,is_tv = 0};

get_lv_cfg(1695) ->
	#pet_lv_cfg{lv = 1695,max_exp = 4294967295,attr = [{1,6776},{2,135520},{3,3388},{4,3388}],combat = 203400,is_tv = 0};

get_lv_cfg(1696) ->
	#pet_lv_cfg{lv = 1696,max_exp = 4294967295,attr = [{1,6780},{2,135600},{3,3390},{4,3390}],combat = 203520,is_tv = 0};

get_lv_cfg(1697) ->
	#pet_lv_cfg{lv = 1697,max_exp = 4294967295,attr = [{1,6784},{2,135680},{3,3392},{4,3392}],combat = 203640,is_tv = 0};

get_lv_cfg(1698) ->
	#pet_lv_cfg{lv = 1698,max_exp = 4294967295,attr = [{1,6788},{2,135760},{3,3394},{4,3394}],combat = 203760,is_tv = 0};

get_lv_cfg(1699) ->
	#pet_lv_cfg{lv = 1699,max_exp = 4294967295,attr = [{1,6792},{2,135840},{3,3396},{4,3396}],combat = 203880,is_tv = 0};

get_lv_cfg(1700) ->
	#pet_lv_cfg{lv = 1700,max_exp = 4294967295,attr = [{1,6796},{2,135920},{3,3398},{4,3398}],combat = 204000,is_tv = 1};

get_lv_cfg(1701) ->
	#pet_lv_cfg{lv = 1701,max_exp = 4294967295,attr = [{1,6800},{2,136000},{3,3400},{4,3400}],combat = 204120,is_tv = 0};

get_lv_cfg(1702) ->
	#pet_lv_cfg{lv = 1702,max_exp = 4294967295,attr = [{1,6804},{2,136080},{3,3402},{4,3402}],combat = 204240,is_tv = 0};

get_lv_cfg(1703) ->
	#pet_lv_cfg{lv = 1703,max_exp = 4294967295,attr = [{1,6808},{2,136160},{3,3404},{4,3404}],combat = 204360,is_tv = 0};

get_lv_cfg(1704) ->
	#pet_lv_cfg{lv = 1704,max_exp = 4294967295,attr = [{1,6812},{2,136240},{3,3406},{4,3406}],combat = 204480,is_tv = 0};

get_lv_cfg(1705) ->
	#pet_lv_cfg{lv = 1705,max_exp = 4294967295,attr = [{1,6816},{2,136320},{3,3408},{4,3408}],combat = 204600,is_tv = 0};

get_lv_cfg(1706) ->
	#pet_lv_cfg{lv = 1706,max_exp = 4294967295,attr = [{1,6820},{2,136400},{3,3410},{4,3410}],combat = 204720,is_tv = 0};

get_lv_cfg(1707) ->
	#pet_lv_cfg{lv = 1707,max_exp = 4294967295,attr = [{1,6824},{2,136480},{3,3412},{4,3412}],combat = 204840,is_tv = 0};

get_lv_cfg(1708) ->
	#pet_lv_cfg{lv = 1708,max_exp = 4294967295,attr = [{1,6828},{2,136560},{3,3414},{4,3414}],combat = 204960,is_tv = 0};

get_lv_cfg(1709) ->
	#pet_lv_cfg{lv = 1709,max_exp = 4294967295,attr = [{1,6832},{2,136640},{3,3416},{4,3416}],combat = 205080,is_tv = 0};

get_lv_cfg(1710) ->
	#pet_lv_cfg{lv = 1710,max_exp = 4294967295,attr = [{1,6836},{2,136720},{3,3418},{4,3418}],combat = 205200,is_tv = 0};

get_lv_cfg(1711) ->
	#pet_lv_cfg{lv = 1711,max_exp = 4294967295,attr = [{1,6840},{2,136800},{3,3420},{4,3420}],combat = 205320,is_tv = 0};

get_lv_cfg(1712) ->
	#pet_lv_cfg{lv = 1712,max_exp = 4294967295,attr = [{1,6844},{2,136880},{3,3422},{4,3422}],combat = 205440,is_tv = 0};

get_lv_cfg(1713) ->
	#pet_lv_cfg{lv = 1713,max_exp = 4294967295,attr = [{1,6848},{2,136960},{3,3424},{4,3424}],combat = 205560,is_tv = 0};

get_lv_cfg(1714) ->
	#pet_lv_cfg{lv = 1714,max_exp = 4294967295,attr = [{1,6852},{2,137040},{3,3426},{4,3426}],combat = 205680,is_tv = 0};

get_lv_cfg(1715) ->
	#pet_lv_cfg{lv = 1715,max_exp = 4294967295,attr = [{1,6856},{2,137120},{3,3428},{4,3428}],combat = 205800,is_tv = 0};

get_lv_cfg(1716) ->
	#pet_lv_cfg{lv = 1716,max_exp = 4294967295,attr = [{1,6860},{2,137200},{3,3430},{4,3430}],combat = 205920,is_tv = 0};

get_lv_cfg(1717) ->
	#pet_lv_cfg{lv = 1717,max_exp = 4294967295,attr = [{1,6864},{2,137280},{3,3432},{4,3432}],combat = 206040,is_tv = 0};

get_lv_cfg(1718) ->
	#pet_lv_cfg{lv = 1718,max_exp = 4294967295,attr = [{1,6868},{2,137360},{3,3434},{4,3434}],combat = 206160,is_tv = 0};

get_lv_cfg(1719) ->
	#pet_lv_cfg{lv = 1719,max_exp = 4294967295,attr = [{1,6872},{2,137440},{3,3436},{4,3436}],combat = 206280,is_tv = 0};

get_lv_cfg(1720) ->
	#pet_lv_cfg{lv = 1720,max_exp = 4294967295,attr = [{1,6876},{2,137520},{3,3438},{4,3438}],combat = 206400,is_tv = 0};

get_lv_cfg(1721) ->
	#pet_lv_cfg{lv = 1721,max_exp = 4294967295,attr = [{1,6880},{2,137600},{3,3440},{4,3440}],combat = 206520,is_tv = 0};

get_lv_cfg(1722) ->
	#pet_lv_cfg{lv = 1722,max_exp = 4294967295,attr = [{1,6884},{2,137680},{3,3442},{4,3442}],combat = 206640,is_tv = 0};

get_lv_cfg(1723) ->
	#pet_lv_cfg{lv = 1723,max_exp = 4294967295,attr = [{1,6888},{2,137760},{3,3444},{4,3444}],combat = 206760,is_tv = 0};

get_lv_cfg(1724) ->
	#pet_lv_cfg{lv = 1724,max_exp = 4294967295,attr = [{1,6892},{2,137840},{3,3446},{4,3446}],combat = 206880,is_tv = 0};

get_lv_cfg(1725) ->
	#pet_lv_cfg{lv = 1725,max_exp = 4294967295,attr = [{1,6896},{2,137920},{3,3448},{4,3448}],combat = 207000,is_tv = 0};

get_lv_cfg(1726) ->
	#pet_lv_cfg{lv = 1726,max_exp = 4294967295,attr = [{1,6900},{2,138000},{3,3450},{4,3450}],combat = 207120,is_tv = 0};

get_lv_cfg(1727) ->
	#pet_lv_cfg{lv = 1727,max_exp = 4294967295,attr = [{1,6904},{2,138080},{3,3452},{4,3452}],combat = 207240,is_tv = 0};

get_lv_cfg(1728) ->
	#pet_lv_cfg{lv = 1728,max_exp = 4294967295,attr = [{1,6908},{2,138160},{3,3454},{4,3454}],combat = 207360,is_tv = 0};

get_lv_cfg(1729) ->
	#pet_lv_cfg{lv = 1729,max_exp = 4294967295,attr = [{1,6912},{2,138240},{3,3456},{4,3456}],combat = 207480,is_tv = 0};

get_lv_cfg(1730) ->
	#pet_lv_cfg{lv = 1730,max_exp = 4294967295,attr = [{1,6916},{2,138320},{3,3458},{4,3458}],combat = 207600,is_tv = 0};

get_lv_cfg(1731) ->
	#pet_lv_cfg{lv = 1731,max_exp = 4294967295,attr = [{1,6920},{2,138400},{3,3460},{4,3460}],combat = 207720,is_tv = 0};

get_lv_cfg(1732) ->
	#pet_lv_cfg{lv = 1732,max_exp = 4294967295,attr = [{1,6924},{2,138480},{3,3462},{4,3462}],combat = 207840,is_tv = 0};

get_lv_cfg(1733) ->
	#pet_lv_cfg{lv = 1733,max_exp = 4294967295,attr = [{1,6928},{2,138560},{3,3464},{4,3464}],combat = 207960,is_tv = 0};

get_lv_cfg(1734) ->
	#pet_lv_cfg{lv = 1734,max_exp = 4294967295,attr = [{1,6932},{2,138640},{3,3466},{4,3466}],combat = 208080,is_tv = 0};

get_lv_cfg(1735) ->
	#pet_lv_cfg{lv = 1735,max_exp = 4294967295,attr = [{1,6936},{2,138720},{3,3468},{4,3468}],combat = 208200,is_tv = 0};

get_lv_cfg(1736) ->
	#pet_lv_cfg{lv = 1736,max_exp = 4294967295,attr = [{1,6940},{2,138800},{3,3470},{4,3470}],combat = 208320,is_tv = 0};

get_lv_cfg(1737) ->
	#pet_lv_cfg{lv = 1737,max_exp = 4294967295,attr = [{1,6944},{2,138880},{3,3472},{4,3472}],combat = 208440,is_tv = 0};

get_lv_cfg(1738) ->
	#pet_lv_cfg{lv = 1738,max_exp = 4294967295,attr = [{1,6948},{2,138960},{3,3474},{4,3474}],combat = 208560,is_tv = 0};

get_lv_cfg(1739) ->
	#pet_lv_cfg{lv = 1739,max_exp = 4294967295,attr = [{1,6952},{2,139040},{3,3476},{4,3476}],combat = 208680,is_tv = 0};

get_lv_cfg(1740) ->
	#pet_lv_cfg{lv = 1740,max_exp = 4294967295,attr = [{1,6956},{2,139120},{3,3478},{4,3478}],combat = 208800,is_tv = 0};

get_lv_cfg(1741) ->
	#pet_lv_cfg{lv = 1741,max_exp = 4294967295,attr = [{1,6960},{2,139200},{3,3480},{4,3480}],combat = 208920,is_tv = 0};

get_lv_cfg(1742) ->
	#pet_lv_cfg{lv = 1742,max_exp = 4294967295,attr = [{1,6964},{2,139280},{3,3482},{4,3482}],combat = 209040,is_tv = 0};

get_lv_cfg(1743) ->
	#pet_lv_cfg{lv = 1743,max_exp = 4294967295,attr = [{1,6968},{2,139360},{3,3484},{4,3484}],combat = 209160,is_tv = 0};

get_lv_cfg(1744) ->
	#pet_lv_cfg{lv = 1744,max_exp = 4294967295,attr = [{1,6972},{2,139440},{3,3486},{4,3486}],combat = 209280,is_tv = 0};

get_lv_cfg(1745) ->
	#pet_lv_cfg{lv = 1745,max_exp = 4294967295,attr = [{1,6976},{2,139520},{3,3488},{4,3488}],combat = 209400,is_tv = 0};

get_lv_cfg(1746) ->
	#pet_lv_cfg{lv = 1746,max_exp = 4294967295,attr = [{1,6980},{2,139600},{3,3490},{4,3490}],combat = 209520,is_tv = 0};

get_lv_cfg(1747) ->
	#pet_lv_cfg{lv = 1747,max_exp = 4294967295,attr = [{1,6984},{2,139680},{3,3492},{4,3492}],combat = 209640,is_tv = 0};

get_lv_cfg(1748) ->
	#pet_lv_cfg{lv = 1748,max_exp = 4294967295,attr = [{1,6988},{2,139760},{3,3494},{4,3494}],combat = 209760,is_tv = 0};

get_lv_cfg(1749) ->
	#pet_lv_cfg{lv = 1749,max_exp = 4294967295,attr = [{1,6992},{2,139840},{3,3496},{4,3496}],combat = 209880,is_tv = 0};

get_lv_cfg(1750) ->
	#pet_lv_cfg{lv = 1750,max_exp = 4294967295,attr = [{1,6996},{2,139920},{3,3498},{4,3498}],combat = 210000,is_tv = 1};

get_lv_cfg(1751) ->
	#pet_lv_cfg{lv = 1751,max_exp = 4294967295,attr = [{1,7000},{2,140000},{3,3500},{4,3500}],combat = 210120,is_tv = 0};

get_lv_cfg(1752) ->
	#pet_lv_cfg{lv = 1752,max_exp = 4294967295,attr = [{1,7004},{2,140080},{3,3502},{4,3502}],combat = 210240,is_tv = 0};

get_lv_cfg(1753) ->
	#pet_lv_cfg{lv = 1753,max_exp = 4294967295,attr = [{1,7008},{2,140160},{3,3504},{4,3504}],combat = 210360,is_tv = 0};

get_lv_cfg(1754) ->
	#pet_lv_cfg{lv = 1754,max_exp = 4294967295,attr = [{1,7012},{2,140240},{3,3506},{4,3506}],combat = 210480,is_tv = 0};

get_lv_cfg(1755) ->
	#pet_lv_cfg{lv = 1755,max_exp = 4294967295,attr = [{1,7016},{2,140320},{3,3508},{4,3508}],combat = 210600,is_tv = 0};

get_lv_cfg(1756) ->
	#pet_lv_cfg{lv = 1756,max_exp = 4294967295,attr = [{1,7020},{2,140400},{3,3510},{4,3510}],combat = 210720,is_tv = 0};

get_lv_cfg(1757) ->
	#pet_lv_cfg{lv = 1757,max_exp = 4294967295,attr = [{1,7024},{2,140480},{3,3512},{4,3512}],combat = 210840,is_tv = 0};

get_lv_cfg(1758) ->
	#pet_lv_cfg{lv = 1758,max_exp = 4294967295,attr = [{1,7028},{2,140560},{3,3514},{4,3514}],combat = 210960,is_tv = 0};

get_lv_cfg(1759) ->
	#pet_lv_cfg{lv = 1759,max_exp = 4294967295,attr = [{1,7032},{2,140640},{3,3516},{4,3516}],combat = 211080,is_tv = 0};

get_lv_cfg(1760) ->
	#pet_lv_cfg{lv = 1760,max_exp = 4294967295,attr = [{1,7036},{2,140720},{3,3518},{4,3518}],combat = 211200,is_tv = 0};

get_lv_cfg(1761) ->
	#pet_lv_cfg{lv = 1761,max_exp = 4294967295,attr = [{1,7040},{2,140800},{3,3520},{4,3520}],combat = 211320,is_tv = 0};

get_lv_cfg(1762) ->
	#pet_lv_cfg{lv = 1762,max_exp = 4294967295,attr = [{1,7044},{2,140880},{3,3522},{4,3522}],combat = 211440,is_tv = 0};

get_lv_cfg(1763) ->
	#pet_lv_cfg{lv = 1763,max_exp = 4294967295,attr = [{1,7048},{2,140960},{3,3524},{4,3524}],combat = 211560,is_tv = 0};

get_lv_cfg(1764) ->
	#pet_lv_cfg{lv = 1764,max_exp = 4294967295,attr = [{1,7052},{2,141040},{3,3526},{4,3526}],combat = 211680,is_tv = 0};

get_lv_cfg(1765) ->
	#pet_lv_cfg{lv = 1765,max_exp = 4294967295,attr = [{1,7056},{2,141120},{3,3528},{4,3528}],combat = 211800,is_tv = 0};

get_lv_cfg(1766) ->
	#pet_lv_cfg{lv = 1766,max_exp = 4294967295,attr = [{1,7060},{2,141200},{3,3530},{4,3530}],combat = 211920,is_tv = 0};

get_lv_cfg(1767) ->
	#pet_lv_cfg{lv = 1767,max_exp = 4294967295,attr = [{1,7064},{2,141280},{3,3532},{4,3532}],combat = 212040,is_tv = 0};

get_lv_cfg(1768) ->
	#pet_lv_cfg{lv = 1768,max_exp = 4294967295,attr = [{1,7068},{2,141360},{3,3534},{4,3534}],combat = 212160,is_tv = 0};

get_lv_cfg(1769) ->
	#pet_lv_cfg{lv = 1769,max_exp = 4294967295,attr = [{1,7072},{2,141440},{3,3536},{4,3536}],combat = 212280,is_tv = 0};

get_lv_cfg(1770) ->
	#pet_lv_cfg{lv = 1770,max_exp = 4294967295,attr = [{1,7076},{2,141520},{3,3538},{4,3538}],combat = 212400,is_tv = 0};

get_lv_cfg(1771) ->
	#pet_lv_cfg{lv = 1771,max_exp = 4294967295,attr = [{1,7080},{2,141600},{3,3540},{4,3540}],combat = 212520,is_tv = 0};

get_lv_cfg(1772) ->
	#pet_lv_cfg{lv = 1772,max_exp = 4294967295,attr = [{1,7084},{2,141680},{3,3542},{4,3542}],combat = 212640,is_tv = 0};

get_lv_cfg(1773) ->
	#pet_lv_cfg{lv = 1773,max_exp = 4294967295,attr = [{1,7088},{2,141760},{3,3544},{4,3544}],combat = 212760,is_tv = 0};

get_lv_cfg(1774) ->
	#pet_lv_cfg{lv = 1774,max_exp = 4294967295,attr = [{1,7092},{2,141840},{3,3546},{4,3546}],combat = 212880,is_tv = 0};

get_lv_cfg(1775) ->
	#pet_lv_cfg{lv = 1775,max_exp = 4294967295,attr = [{1,7096},{2,141920},{3,3548},{4,3548}],combat = 213000,is_tv = 0};

get_lv_cfg(1776) ->
	#pet_lv_cfg{lv = 1776,max_exp = 4294967295,attr = [{1,7100},{2,142000},{3,3550},{4,3550}],combat = 213120,is_tv = 0};

get_lv_cfg(1777) ->
	#pet_lv_cfg{lv = 1777,max_exp = 4294967295,attr = [{1,7104},{2,142080},{3,3552},{4,3552}],combat = 213240,is_tv = 0};

get_lv_cfg(1778) ->
	#pet_lv_cfg{lv = 1778,max_exp = 4294967295,attr = [{1,7108},{2,142160},{3,3554},{4,3554}],combat = 213360,is_tv = 0};

get_lv_cfg(1779) ->
	#pet_lv_cfg{lv = 1779,max_exp = 4294967295,attr = [{1,7112},{2,142240},{3,3556},{4,3556}],combat = 213480,is_tv = 0};

get_lv_cfg(1780) ->
	#pet_lv_cfg{lv = 1780,max_exp = 4294967295,attr = [{1,7116},{2,142320},{3,3558},{4,3558}],combat = 213600,is_tv = 0};

get_lv_cfg(1781) ->
	#pet_lv_cfg{lv = 1781,max_exp = 4294967295,attr = [{1,7120},{2,142400},{3,3560},{4,3560}],combat = 213720,is_tv = 0};

get_lv_cfg(1782) ->
	#pet_lv_cfg{lv = 1782,max_exp = 4294967295,attr = [{1,7124},{2,142480},{3,3562},{4,3562}],combat = 213840,is_tv = 0};

get_lv_cfg(1783) ->
	#pet_lv_cfg{lv = 1783,max_exp = 4294967295,attr = [{1,7128},{2,142560},{3,3564},{4,3564}],combat = 213960,is_tv = 0};

get_lv_cfg(1784) ->
	#pet_lv_cfg{lv = 1784,max_exp = 4294967295,attr = [{1,7132},{2,142640},{3,3566},{4,3566}],combat = 214080,is_tv = 0};

get_lv_cfg(1785) ->
	#pet_lv_cfg{lv = 1785,max_exp = 4294967295,attr = [{1,7136},{2,142720},{3,3568},{4,3568}],combat = 214200,is_tv = 0};

get_lv_cfg(1786) ->
	#pet_lv_cfg{lv = 1786,max_exp = 4294967295,attr = [{1,7140},{2,142800},{3,3570},{4,3570}],combat = 214320,is_tv = 0};

get_lv_cfg(1787) ->
	#pet_lv_cfg{lv = 1787,max_exp = 4294967295,attr = [{1,7144},{2,142880},{3,3572},{4,3572}],combat = 214440,is_tv = 0};

get_lv_cfg(1788) ->
	#pet_lv_cfg{lv = 1788,max_exp = 4294967295,attr = [{1,7148},{2,142960},{3,3574},{4,3574}],combat = 214560,is_tv = 0};

get_lv_cfg(1789) ->
	#pet_lv_cfg{lv = 1789,max_exp = 4294967295,attr = [{1,7152},{2,143040},{3,3576},{4,3576}],combat = 214680,is_tv = 0};

get_lv_cfg(1790) ->
	#pet_lv_cfg{lv = 1790,max_exp = 4294967295,attr = [{1,7156},{2,143120},{3,3578},{4,3578}],combat = 214800,is_tv = 0};

get_lv_cfg(1791) ->
	#pet_lv_cfg{lv = 1791,max_exp = 4294967295,attr = [{1,7160},{2,143200},{3,3580},{4,3580}],combat = 214920,is_tv = 0};

get_lv_cfg(1792) ->
	#pet_lv_cfg{lv = 1792,max_exp = 4294967295,attr = [{1,7164},{2,143280},{3,3582},{4,3582}],combat = 215040,is_tv = 0};

get_lv_cfg(1793) ->
	#pet_lv_cfg{lv = 1793,max_exp = 4294967295,attr = [{1,7168},{2,143360},{3,3584},{4,3584}],combat = 215160,is_tv = 0};

get_lv_cfg(1794) ->
	#pet_lv_cfg{lv = 1794,max_exp = 4294967295,attr = [{1,7172},{2,143440},{3,3586},{4,3586}],combat = 215280,is_tv = 0};

get_lv_cfg(1795) ->
	#pet_lv_cfg{lv = 1795,max_exp = 4294967295,attr = [{1,7176},{2,143520},{3,3588},{4,3588}],combat = 215400,is_tv = 0};

get_lv_cfg(1796) ->
	#pet_lv_cfg{lv = 1796,max_exp = 4294967295,attr = [{1,7180},{2,143600},{3,3590},{4,3590}],combat = 215520,is_tv = 0};

get_lv_cfg(1797) ->
	#pet_lv_cfg{lv = 1797,max_exp = 4294967295,attr = [{1,7184},{2,143680},{3,3592},{4,3592}],combat = 215640,is_tv = 0};

get_lv_cfg(1798) ->
	#pet_lv_cfg{lv = 1798,max_exp = 4294967295,attr = [{1,7188},{2,143760},{3,3594},{4,3594}],combat = 215760,is_tv = 0};

get_lv_cfg(1799) ->
	#pet_lv_cfg{lv = 1799,max_exp = 4294967295,attr = [{1,7192},{2,143840},{3,3596},{4,3596}],combat = 215880,is_tv = 0};

get_lv_cfg(1800) ->
	#pet_lv_cfg{lv = 1800,max_exp = 4294967295,attr = [{1,7196},{2,143920},{3,3598},{4,3598}],combat = 216000,is_tv = 1};

get_lv_cfg(1801) ->
	#pet_lv_cfg{lv = 1801,max_exp = 4294967295,attr = [{1,7200},{2,144000},{3,3600},{4,3600}],combat = 216120,is_tv = 0};

get_lv_cfg(1802) ->
	#pet_lv_cfg{lv = 1802,max_exp = 4294967295,attr = [{1,7204},{2,144080},{3,3602},{4,3602}],combat = 216240,is_tv = 0};

get_lv_cfg(1803) ->
	#pet_lv_cfg{lv = 1803,max_exp = 4294967295,attr = [{1,7208},{2,144160},{3,3604},{4,3604}],combat = 216360,is_tv = 0};

get_lv_cfg(1804) ->
	#pet_lv_cfg{lv = 1804,max_exp = 4294967295,attr = [{1,7212},{2,144240},{3,3606},{4,3606}],combat = 216480,is_tv = 0};

get_lv_cfg(1805) ->
	#pet_lv_cfg{lv = 1805,max_exp = 4294967295,attr = [{1,7216},{2,144320},{3,3608},{4,3608}],combat = 216600,is_tv = 0};

get_lv_cfg(1806) ->
	#pet_lv_cfg{lv = 1806,max_exp = 4294967295,attr = [{1,7220},{2,144400},{3,3610},{4,3610}],combat = 216720,is_tv = 0};

get_lv_cfg(1807) ->
	#pet_lv_cfg{lv = 1807,max_exp = 4294967295,attr = [{1,7224},{2,144480},{3,3612},{4,3612}],combat = 216840,is_tv = 0};

get_lv_cfg(1808) ->
	#pet_lv_cfg{lv = 1808,max_exp = 4294967295,attr = [{1,7228},{2,144560},{3,3614},{4,3614}],combat = 216960,is_tv = 0};

get_lv_cfg(1809) ->
	#pet_lv_cfg{lv = 1809,max_exp = 4294967295,attr = [{1,7232},{2,144640},{3,3616},{4,3616}],combat = 217080,is_tv = 0};

get_lv_cfg(1810) ->
	#pet_lv_cfg{lv = 1810,max_exp = 4294967295,attr = [{1,7236},{2,144720},{3,3618},{4,3618}],combat = 217200,is_tv = 0};

get_lv_cfg(1811) ->
	#pet_lv_cfg{lv = 1811,max_exp = 4294967295,attr = [{1,7240},{2,144800},{3,3620},{4,3620}],combat = 217320,is_tv = 0};

get_lv_cfg(1812) ->
	#pet_lv_cfg{lv = 1812,max_exp = 4294967295,attr = [{1,7244},{2,144880},{3,3622},{4,3622}],combat = 217440,is_tv = 0};

get_lv_cfg(1813) ->
	#pet_lv_cfg{lv = 1813,max_exp = 4294967295,attr = [{1,7248},{2,144960},{3,3624},{4,3624}],combat = 217560,is_tv = 0};

get_lv_cfg(1814) ->
	#pet_lv_cfg{lv = 1814,max_exp = 4294967295,attr = [{1,7252},{2,145040},{3,3626},{4,3626}],combat = 217680,is_tv = 0};

get_lv_cfg(1815) ->
	#pet_lv_cfg{lv = 1815,max_exp = 4294967295,attr = [{1,7256},{2,145120},{3,3628},{4,3628}],combat = 217800,is_tv = 0};

get_lv_cfg(1816) ->
	#pet_lv_cfg{lv = 1816,max_exp = 4294967295,attr = [{1,7260},{2,145200},{3,3630},{4,3630}],combat = 217920,is_tv = 0};

get_lv_cfg(1817) ->
	#pet_lv_cfg{lv = 1817,max_exp = 4294967295,attr = [{1,7264},{2,145280},{3,3632},{4,3632}],combat = 218040,is_tv = 0};

get_lv_cfg(1818) ->
	#pet_lv_cfg{lv = 1818,max_exp = 4294967295,attr = [{1,7268},{2,145360},{3,3634},{4,3634}],combat = 218160,is_tv = 0};

get_lv_cfg(1819) ->
	#pet_lv_cfg{lv = 1819,max_exp = 4294967295,attr = [{1,7272},{2,145440},{3,3636},{4,3636}],combat = 218280,is_tv = 0};

get_lv_cfg(1820) ->
	#pet_lv_cfg{lv = 1820,max_exp = 4294967295,attr = [{1,7276},{2,145520},{3,3638},{4,3638}],combat = 218400,is_tv = 0};

get_lv_cfg(1821) ->
	#pet_lv_cfg{lv = 1821,max_exp = 4294967295,attr = [{1,7280},{2,145600},{3,3640},{4,3640}],combat = 218520,is_tv = 0};

get_lv_cfg(1822) ->
	#pet_lv_cfg{lv = 1822,max_exp = 4294967295,attr = [{1,7284},{2,145680},{3,3642},{4,3642}],combat = 218640,is_tv = 0};

get_lv_cfg(1823) ->
	#pet_lv_cfg{lv = 1823,max_exp = 4294967295,attr = [{1,7288},{2,145760},{3,3644},{4,3644}],combat = 218760,is_tv = 0};

get_lv_cfg(1824) ->
	#pet_lv_cfg{lv = 1824,max_exp = 4294967295,attr = [{1,7292},{2,145840},{3,3646},{4,3646}],combat = 218880,is_tv = 0};

get_lv_cfg(1825) ->
	#pet_lv_cfg{lv = 1825,max_exp = 4294967295,attr = [{1,7296},{2,145920},{3,3648},{4,3648}],combat = 219000,is_tv = 0};

get_lv_cfg(1826) ->
	#pet_lv_cfg{lv = 1826,max_exp = 4294967295,attr = [{1,7300},{2,146000},{3,3650},{4,3650}],combat = 219120,is_tv = 0};

get_lv_cfg(1827) ->
	#pet_lv_cfg{lv = 1827,max_exp = 4294967295,attr = [{1,7304},{2,146080},{3,3652},{4,3652}],combat = 219240,is_tv = 0};

get_lv_cfg(1828) ->
	#pet_lv_cfg{lv = 1828,max_exp = 4294967295,attr = [{1,7308},{2,146160},{3,3654},{4,3654}],combat = 219360,is_tv = 0};

get_lv_cfg(1829) ->
	#pet_lv_cfg{lv = 1829,max_exp = 4294967295,attr = [{1,7312},{2,146240},{3,3656},{4,3656}],combat = 219480,is_tv = 0};

get_lv_cfg(1830) ->
	#pet_lv_cfg{lv = 1830,max_exp = 4294967295,attr = [{1,7316},{2,146320},{3,3658},{4,3658}],combat = 219600,is_tv = 0};

get_lv_cfg(1831) ->
	#pet_lv_cfg{lv = 1831,max_exp = 4294967295,attr = [{1,7320},{2,146400},{3,3660},{4,3660}],combat = 219720,is_tv = 0};

get_lv_cfg(1832) ->
	#pet_lv_cfg{lv = 1832,max_exp = 4294967295,attr = [{1,7324},{2,146480},{3,3662},{4,3662}],combat = 219840,is_tv = 0};

get_lv_cfg(1833) ->
	#pet_lv_cfg{lv = 1833,max_exp = 4294967295,attr = [{1,7328},{2,146560},{3,3664},{4,3664}],combat = 219960,is_tv = 0};

get_lv_cfg(1834) ->
	#pet_lv_cfg{lv = 1834,max_exp = 4294967295,attr = [{1,7332},{2,146640},{3,3666},{4,3666}],combat = 220080,is_tv = 0};

get_lv_cfg(1835) ->
	#pet_lv_cfg{lv = 1835,max_exp = 4294967295,attr = [{1,7336},{2,146720},{3,3668},{4,3668}],combat = 220200,is_tv = 0};

get_lv_cfg(1836) ->
	#pet_lv_cfg{lv = 1836,max_exp = 4294967295,attr = [{1,7340},{2,146800},{3,3670},{4,3670}],combat = 220320,is_tv = 0};

get_lv_cfg(1837) ->
	#pet_lv_cfg{lv = 1837,max_exp = 4294967295,attr = [{1,7344},{2,146880},{3,3672},{4,3672}],combat = 220440,is_tv = 0};

get_lv_cfg(1838) ->
	#pet_lv_cfg{lv = 1838,max_exp = 4294967295,attr = [{1,7348},{2,146960},{3,3674},{4,3674}],combat = 220560,is_tv = 0};

get_lv_cfg(1839) ->
	#pet_lv_cfg{lv = 1839,max_exp = 4294967295,attr = [{1,7352},{2,147040},{3,3676},{4,3676}],combat = 220680,is_tv = 0};

get_lv_cfg(1840) ->
	#pet_lv_cfg{lv = 1840,max_exp = 4294967295,attr = [{1,7356},{2,147120},{3,3678},{4,3678}],combat = 220800,is_tv = 0};

get_lv_cfg(1841) ->
	#pet_lv_cfg{lv = 1841,max_exp = 4294967295,attr = [{1,7360},{2,147200},{3,3680},{4,3680}],combat = 220920,is_tv = 0};

get_lv_cfg(1842) ->
	#pet_lv_cfg{lv = 1842,max_exp = 4294967295,attr = [{1,7364},{2,147280},{3,3682},{4,3682}],combat = 221040,is_tv = 0};

get_lv_cfg(1843) ->
	#pet_lv_cfg{lv = 1843,max_exp = 4294967295,attr = [{1,7368},{2,147360},{3,3684},{4,3684}],combat = 221160,is_tv = 0};

get_lv_cfg(1844) ->
	#pet_lv_cfg{lv = 1844,max_exp = 4294967295,attr = [{1,7372},{2,147440},{3,3686},{4,3686}],combat = 221280,is_tv = 0};

get_lv_cfg(1845) ->
	#pet_lv_cfg{lv = 1845,max_exp = 4294967295,attr = [{1,7376},{2,147520},{3,3688},{4,3688}],combat = 221400,is_tv = 0};

get_lv_cfg(1846) ->
	#pet_lv_cfg{lv = 1846,max_exp = 4294967295,attr = [{1,7380},{2,147600},{3,3690},{4,3690}],combat = 221520,is_tv = 0};

get_lv_cfg(1847) ->
	#pet_lv_cfg{lv = 1847,max_exp = 4294967295,attr = [{1,7384},{2,147680},{3,3692},{4,3692}],combat = 221640,is_tv = 0};

get_lv_cfg(1848) ->
	#pet_lv_cfg{lv = 1848,max_exp = 4294967295,attr = [{1,7388},{2,147760},{3,3694},{4,3694}],combat = 221760,is_tv = 0};

get_lv_cfg(1849) ->
	#pet_lv_cfg{lv = 1849,max_exp = 4294967295,attr = [{1,7392},{2,147840},{3,3696},{4,3696}],combat = 221880,is_tv = 0};

get_lv_cfg(1850) ->
	#pet_lv_cfg{lv = 1850,max_exp = 4294967295,attr = [{1,7396},{2,147920},{3,3698},{4,3698}],combat = 222000,is_tv = 1};

get_lv_cfg(1851) ->
	#pet_lv_cfg{lv = 1851,max_exp = 4294967295,attr = [{1,7400},{2,148000},{3,3700},{4,3700}],combat = 222120,is_tv = 0};

get_lv_cfg(1852) ->
	#pet_lv_cfg{lv = 1852,max_exp = 4294967295,attr = [{1,7404},{2,148080},{3,3702},{4,3702}],combat = 222240,is_tv = 0};

get_lv_cfg(1853) ->
	#pet_lv_cfg{lv = 1853,max_exp = 4294967295,attr = [{1,7408},{2,148160},{3,3704},{4,3704}],combat = 222360,is_tv = 0};

get_lv_cfg(1854) ->
	#pet_lv_cfg{lv = 1854,max_exp = 4294967295,attr = [{1,7412},{2,148240},{3,3706},{4,3706}],combat = 222480,is_tv = 0};

get_lv_cfg(1855) ->
	#pet_lv_cfg{lv = 1855,max_exp = 4294967295,attr = [{1,7416},{2,148320},{3,3708},{4,3708}],combat = 222600,is_tv = 0};

get_lv_cfg(1856) ->
	#pet_lv_cfg{lv = 1856,max_exp = 4294967295,attr = [{1,7420},{2,148400},{3,3710},{4,3710}],combat = 222720,is_tv = 0};

get_lv_cfg(1857) ->
	#pet_lv_cfg{lv = 1857,max_exp = 4294967295,attr = [{1,7424},{2,148480},{3,3712},{4,3712}],combat = 222840,is_tv = 0};

get_lv_cfg(1858) ->
	#pet_lv_cfg{lv = 1858,max_exp = 4294967295,attr = [{1,7428},{2,148560},{3,3714},{4,3714}],combat = 222960,is_tv = 0};

get_lv_cfg(1859) ->
	#pet_lv_cfg{lv = 1859,max_exp = 4294967295,attr = [{1,7432},{2,148640},{3,3716},{4,3716}],combat = 223080,is_tv = 0};

get_lv_cfg(1860) ->
	#pet_lv_cfg{lv = 1860,max_exp = 4294967295,attr = [{1,7436},{2,148720},{3,3718},{4,3718}],combat = 223200,is_tv = 0};

get_lv_cfg(1861) ->
	#pet_lv_cfg{lv = 1861,max_exp = 4294967295,attr = [{1,7440},{2,148800},{3,3720},{4,3720}],combat = 223320,is_tv = 0};

get_lv_cfg(1862) ->
	#pet_lv_cfg{lv = 1862,max_exp = 4294967295,attr = [{1,7444},{2,148880},{3,3722},{4,3722}],combat = 223440,is_tv = 0};

get_lv_cfg(1863) ->
	#pet_lv_cfg{lv = 1863,max_exp = 4294967295,attr = [{1,7448},{2,148960},{3,3724},{4,3724}],combat = 223560,is_tv = 0};

get_lv_cfg(1864) ->
	#pet_lv_cfg{lv = 1864,max_exp = 4294967295,attr = [{1,7452},{2,149040},{3,3726},{4,3726}],combat = 223680,is_tv = 0};

get_lv_cfg(1865) ->
	#pet_lv_cfg{lv = 1865,max_exp = 4294967295,attr = [{1,7456},{2,149120},{3,3728},{4,3728}],combat = 223800,is_tv = 0};

get_lv_cfg(1866) ->
	#pet_lv_cfg{lv = 1866,max_exp = 4294967295,attr = [{1,7460},{2,149200},{3,3730},{4,3730}],combat = 223920,is_tv = 0};

get_lv_cfg(1867) ->
	#pet_lv_cfg{lv = 1867,max_exp = 4294967295,attr = [{1,7464},{2,149280},{3,3732},{4,3732}],combat = 224040,is_tv = 0};

get_lv_cfg(1868) ->
	#pet_lv_cfg{lv = 1868,max_exp = 4294967295,attr = [{1,7468},{2,149360},{3,3734},{4,3734}],combat = 224160,is_tv = 0};

get_lv_cfg(1869) ->
	#pet_lv_cfg{lv = 1869,max_exp = 4294967295,attr = [{1,7472},{2,149440},{3,3736},{4,3736}],combat = 224280,is_tv = 0};

get_lv_cfg(1870) ->
	#pet_lv_cfg{lv = 1870,max_exp = 4294967295,attr = [{1,7476},{2,149520},{3,3738},{4,3738}],combat = 224400,is_tv = 0};

get_lv_cfg(1871) ->
	#pet_lv_cfg{lv = 1871,max_exp = 4294967295,attr = [{1,7480},{2,149600},{3,3740},{4,3740}],combat = 224520,is_tv = 0};

get_lv_cfg(1872) ->
	#pet_lv_cfg{lv = 1872,max_exp = 4294967295,attr = [{1,7484},{2,149680},{3,3742},{4,3742}],combat = 224640,is_tv = 0};

get_lv_cfg(1873) ->
	#pet_lv_cfg{lv = 1873,max_exp = 4294967295,attr = [{1,7488},{2,149760},{3,3744},{4,3744}],combat = 224760,is_tv = 0};

get_lv_cfg(1874) ->
	#pet_lv_cfg{lv = 1874,max_exp = 4294967295,attr = [{1,7492},{2,149840},{3,3746},{4,3746}],combat = 224880,is_tv = 0};

get_lv_cfg(1875) ->
	#pet_lv_cfg{lv = 1875,max_exp = 4294967295,attr = [{1,7496},{2,149920},{3,3748},{4,3748}],combat = 225000,is_tv = 0};

get_lv_cfg(1876) ->
	#pet_lv_cfg{lv = 1876,max_exp = 4294967295,attr = [{1,7500},{2,150000},{3,3750},{4,3750}],combat = 225120,is_tv = 0};

get_lv_cfg(1877) ->
	#pet_lv_cfg{lv = 1877,max_exp = 4294967295,attr = [{1,7504},{2,150080},{3,3752},{4,3752}],combat = 225240,is_tv = 0};

get_lv_cfg(1878) ->
	#pet_lv_cfg{lv = 1878,max_exp = 4294967295,attr = [{1,7508},{2,150160},{3,3754},{4,3754}],combat = 225360,is_tv = 0};

get_lv_cfg(1879) ->
	#pet_lv_cfg{lv = 1879,max_exp = 4294967295,attr = [{1,7512},{2,150240},{3,3756},{4,3756}],combat = 225480,is_tv = 0};

get_lv_cfg(1880) ->
	#pet_lv_cfg{lv = 1880,max_exp = 4294967295,attr = [{1,7516},{2,150320},{3,3758},{4,3758}],combat = 225600,is_tv = 0};

get_lv_cfg(1881) ->
	#pet_lv_cfg{lv = 1881,max_exp = 4294967295,attr = [{1,7520},{2,150400},{3,3760},{4,3760}],combat = 225720,is_tv = 0};

get_lv_cfg(1882) ->
	#pet_lv_cfg{lv = 1882,max_exp = 4294967295,attr = [{1,7524},{2,150480},{3,3762},{4,3762}],combat = 225840,is_tv = 0};

get_lv_cfg(1883) ->
	#pet_lv_cfg{lv = 1883,max_exp = 4294967295,attr = [{1,7528},{2,150560},{3,3764},{4,3764}],combat = 225960,is_tv = 0};

get_lv_cfg(1884) ->
	#pet_lv_cfg{lv = 1884,max_exp = 4294967295,attr = [{1,7532},{2,150640},{3,3766},{4,3766}],combat = 226080,is_tv = 0};

get_lv_cfg(1885) ->
	#pet_lv_cfg{lv = 1885,max_exp = 4294967295,attr = [{1,7536},{2,150720},{3,3768},{4,3768}],combat = 226200,is_tv = 0};

get_lv_cfg(1886) ->
	#pet_lv_cfg{lv = 1886,max_exp = 4294967295,attr = [{1,7540},{2,150800},{3,3770},{4,3770}],combat = 226320,is_tv = 0};

get_lv_cfg(1887) ->
	#pet_lv_cfg{lv = 1887,max_exp = 4294967295,attr = [{1,7544},{2,150880},{3,3772},{4,3772}],combat = 226440,is_tv = 0};

get_lv_cfg(1888) ->
	#pet_lv_cfg{lv = 1888,max_exp = 4294967295,attr = [{1,7548},{2,150960},{3,3774},{4,3774}],combat = 226560,is_tv = 0};

get_lv_cfg(1889) ->
	#pet_lv_cfg{lv = 1889,max_exp = 4294967295,attr = [{1,7552},{2,151040},{3,3776},{4,3776}],combat = 226680,is_tv = 0};

get_lv_cfg(1890) ->
	#pet_lv_cfg{lv = 1890,max_exp = 4294967295,attr = [{1,7556},{2,151120},{3,3778},{4,3778}],combat = 226800,is_tv = 0};

get_lv_cfg(1891) ->
	#pet_lv_cfg{lv = 1891,max_exp = 4294967295,attr = [{1,7560},{2,151200},{3,3780},{4,3780}],combat = 226920,is_tv = 0};

get_lv_cfg(1892) ->
	#pet_lv_cfg{lv = 1892,max_exp = 4294967295,attr = [{1,7564},{2,151280},{3,3782},{4,3782}],combat = 227040,is_tv = 0};

get_lv_cfg(1893) ->
	#pet_lv_cfg{lv = 1893,max_exp = 4294967295,attr = [{1,7568},{2,151360},{3,3784},{4,3784}],combat = 227160,is_tv = 0};

get_lv_cfg(1894) ->
	#pet_lv_cfg{lv = 1894,max_exp = 4294967295,attr = [{1,7572},{2,151440},{3,3786},{4,3786}],combat = 227280,is_tv = 0};

get_lv_cfg(1895) ->
	#pet_lv_cfg{lv = 1895,max_exp = 4294967295,attr = [{1,7576},{2,151520},{3,3788},{4,3788}],combat = 227400,is_tv = 0};

get_lv_cfg(1896) ->
	#pet_lv_cfg{lv = 1896,max_exp = 4294967295,attr = [{1,7580},{2,151600},{3,3790},{4,3790}],combat = 227520,is_tv = 0};

get_lv_cfg(1897) ->
	#pet_lv_cfg{lv = 1897,max_exp = 4294967295,attr = [{1,7584},{2,151680},{3,3792},{4,3792}],combat = 227640,is_tv = 0};

get_lv_cfg(1898) ->
	#pet_lv_cfg{lv = 1898,max_exp = 4294967295,attr = [{1,7588},{2,151760},{3,3794},{4,3794}],combat = 227760,is_tv = 0};

get_lv_cfg(1899) ->
	#pet_lv_cfg{lv = 1899,max_exp = 4294967295,attr = [{1,7592},{2,151840},{3,3796},{4,3796}],combat = 227880,is_tv = 0};

get_lv_cfg(1900) ->
	#pet_lv_cfg{lv = 1900,max_exp = 4294967295,attr = [{1,7596},{2,151920},{3,3798},{4,3798}],combat = 228000,is_tv = 1};

get_lv_cfg(1901) ->
	#pet_lv_cfg{lv = 1901,max_exp = 4294967295,attr = [{1,7600},{2,152000},{3,3800},{4,3800}],combat = 228120,is_tv = 0};

get_lv_cfg(1902) ->
	#pet_lv_cfg{lv = 1902,max_exp = 4294967295,attr = [{1,7604},{2,152080},{3,3802},{4,3802}],combat = 228240,is_tv = 0};

get_lv_cfg(1903) ->
	#pet_lv_cfg{lv = 1903,max_exp = 4294967295,attr = [{1,7608},{2,152160},{3,3804},{4,3804}],combat = 228360,is_tv = 0};

get_lv_cfg(1904) ->
	#pet_lv_cfg{lv = 1904,max_exp = 4294967295,attr = [{1,7612},{2,152240},{3,3806},{4,3806}],combat = 228480,is_tv = 0};

get_lv_cfg(1905) ->
	#pet_lv_cfg{lv = 1905,max_exp = 4294967295,attr = [{1,7616},{2,152320},{3,3808},{4,3808}],combat = 228600,is_tv = 0};

get_lv_cfg(1906) ->
	#pet_lv_cfg{lv = 1906,max_exp = 4294967295,attr = [{1,7620},{2,152400},{3,3810},{4,3810}],combat = 228720,is_tv = 0};

get_lv_cfg(1907) ->
	#pet_lv_cfg{lv = 1907,max_exp = 4294967295,attr = [{1,7624},{2,152480},{3,3812},{4,3812}],combat = 228840,is_tv = 0};

get_lv_cfg(1908) ->
	#pet_lv_cfg{lv = 1908,max_exp = 4294967295,attr = [{1,7628},{2,152560},{3,3814},{4,3814}],combat = 228960,is_tv = 0};

get_lv_cfg(1909) ->
	#pet_lv_cfg{lv = 1909,max_exp = 4294967295,attr = [{1,7632},{2,152640},{3,3816},{4,3816}],combat = 229080,is_tv = 0};

get_lv_cfg(1910) ->
	#pet_lv_cfg{lv = 1910,max_exp = 4294967295,attr = [{1,7636},{2,152720},{3,3818},{4,3818}],combat = 229200,is_tv = 0};

get_lv_cfg(1911) ->
	#pet_lv_cfg{lv = 1911,max_exp = 4294967295,attr = [{1,7640},{2,152800},{3,3820},{4,3820}],combat = 229320,is_tv = 0};

get_lv_cfg(1912) ->
	#pet_lv_cfg{lv = 1912,max_exp = 4294967295,attr = [{1,7644},{2,152880},{3,3822},{4,3822}],combat = 229440,is_tv = 0};

get_lv_cfg(1913) ->
	#pet_lv_cfg{lv = 1913,max_exp = 4294967295,attr = [{1,7648},{2,152960},{3,3824},{4,3824}],combat = 229560,is_tv = 0};

get_lv_cfg(1914) ->
	#pet_lv_cfg{lv = 1914,max_exp = 4294967295,attr = [{1,7652},{2,153040},{3,3826},{4,3826}],combat = 229680,is_tv = 0};

get_lv_cfg(1915) ->
	#pet_lv_cfg{lv = 1915,max_exp = 4294967295,attr = [{1,7656},{2,153120},{3,3828},{4,3828}],combat = 229800,is_tv = 0};

get_lv_cfg(1916) ->
	#pet_lv_cfg{lv = 1916,max_exp = 4294967295,attr = [{1,7660},{2,153200},{3,3830},{4,3830}],combat = 229920,is_tv = 0};

get_lv_cfg(1917) ->
	#pet_lv_cfg{lv = 1917,max_exp = 4294967295,attr = [{1,7664},{2,153280},{3,3832},{4,3832}],combat = 230040,is_tv = 0};

get_lv_cfg(1918) ->
	#pet_lv_cfg{lv = 1918,max_exp = 4294967295,attr = [{1,7668},{2,153360},{3,3834},{4,3834}],combat = 230160,is_tv = 0};

get_lv_cfg(1919) ->
	#pet_lv_cfg{lv = 1919,max_exp = 4294967295,attr = [{1,7672},{2,153440},{3,3836},{4,3836}],combat = 230280,is_tv = 0};

get_lv_cfg(1920) ->
	#pet_lv_cfg{lv = 1920,max_exp = 4294967295,attr = [{1,7676},{2,153520},{3,3838},{4,3838}],combat = 230400,is_tv = 0};

get_lv_cfg(1921) ->
	#pet_lv_cfg{lv = 1921,max_exp = 4294967295,attr = [{1,7680},{2,153600},{3,3840},{4,3840}],combat = 230520,is_tv = 0};

get_lv_cfg(1922) ->
	#pet_lv_cfg{lv = 1922,max_exp = 4294967295,attr = [{1,7684},{2,153680},{3,3842},{4,3842}],combat = 230640,is_tv = 0};

get_lv_cfg(1923) ->
	#pet_lv_cfg{lv = 1923,max_exp = 4294967295,attr = [{1,7688},{2,153760},{3,3844},{4,3844}],combat = 230760,is_tv = 0};

get_lv_cfg(1924) ->
	#pet_lv_cfg{lv = 1924,max_exp = 4294967295,attr = [{1,7692},{2,153840},{3,3846},{4,3846}],combat = 230880,is_tv = 0};

get_lv_cfg(1925) ->
	#pet_lv_cfg{lv = 1925,max_exp = 4294967295,attr = [{1,7696},{2,153920},{3,3848},{4,3848}],combat = 231000,is_tv = 0};

get_lv_cfg(1926) ->
	#pet_lv_cfg{lv = 1926,max_exp = 4294967295,attr = [{1,7700},{2,154000},{3,3850},{4,3850}],combat = 231120,is_tv = 0};

get_lv_cfg(1927) ->
	#pet_lv_cfg{lv = 1927,max_exp = 4294967295,attr = [{1,7704},{2,154080},{3,3852},{4,3852}],combat = 231240,is_tv = 0};

get_lv_cfg(1928) ->
	#pet_lv_cfg{lv = 1928,max_exp = 4294967295,attr = [{1,7708},{2,154160},{3,3854},{4,3854}],combat = 231360,is_tv = 0};

get_lv_cfg(1929) ->
	#pet_lv_cfg{lv = 1929,max_exp = 4294967295,attr = [{1,7712},{2,154240},{3,3856},{4,3856}],combat = 231480,is_tv = 0};

get_lv_cfg(1930) ->
	#pet_lv_cfg{lv = 1930,max_exp = 4294967295,attr = [{1,7716},{2,154320},{3,3858},{4,3858}],combat = 231600,is_tv = 0};

get_lv_cfg(1931) ->
	#pet_lv_cfg{lv = 1931,max_exp = 4294967295,attr = [{1,7720},{2,154400},{3,3860},{4,3860}],combat = 231720,is_tv = 0};

get_lv_cfg(1932) ->
	#pet_lv_cfg{lv = 1932,max_exp = 4294967295,attr = [{1,7724},{2,154480},{3,3862},{4,3862}],combat = 231840,is_tv = 0};

get_lv_cfg(1933) ->
	#pet_lv_cfg{lv = 1933,max_exp = 4294967295,attr = [{1,7728},{2,154560},{3,3864},{4,3864}],combat = 231960,is_tv = 0};

get_lv_cfg(1934) ->
	#pet_lv_cfg{lv = 1934,max_exp = 4294967295,attr = [{1,7732},{2,154640},{3,3866},{4,3866}],combat = 232080,is_tv = 0};

get_lv_cfg(1935) ->
	#pet_lv_cfg{lv = 1935,max_exp = 4294967295,attr = [{1,7736},{2,154720},{3,3868},{4,3868}],combat = 232200,is_tv = 0};

get_lv_cfg(1936) ->
	#pet_lv_cfg{lv = 1936,max_exp = 4294967295,attr = [{1,7740},{2,154800},{3,3870},{4,3870}],combat = 232320,is_tv = 0};

get_lv_cfg(1937) ->
	#pet_lv_cfg{lv = 1937,max_exp = 4294967295,attr = [{1,7744},{2,154880},{3,3872},{4,3872}],combat = 232440,is_tv = 0};

get_lv_cfg(1938) ->
	#pet_lv_cfg{lv = 1938,max_exp = 4294967295,attr = [{1,7748},{2,154960},{3,3874},{4,3874}],combat = 232560,is_tv = 0};

get_lv_cfg(1939) ->
	#pet_lv_cfg{lv = 1939,max_exp = 4294967295,attr = [{1,7752},{2,155040},{3,3876},{4,3876}],combat = 232680,is_tv = 0};

get_lv_cfg(1940) ->
	#pet_lv_cfg{lv = 1940,max_exp = 4294967295,attr = [{1,7756},{2,155120},{3,3878},{4,3878}],combat = 232800,is_tv = 0};

get_lv_cfg(1941) ->
	#pet_lv_cfg{lv = 1941,max_exp = 4294967295,attr = [{1,7760},{2,155200},{3,3880},{4,3880}],combat = 232920,is_tv = 0};

get_lv_cfg(1942) ->
	#pet_lv_cfg{lv = 1942,max_exp = 4294967295,attr = [{1,7764},{2,155280},{3,3882},{4,3882}],combat = 233040,is_tv = 0};

get_lv_cfg(1943) ->
	#pet_lv_cfg{lv = 1943,max_exp = 4294967295,attr = [{1,7768},{2,155360},{3,3884},{4,3884}],combat = 233160,is_tv = 0};

get_lv_cfg(1944) ->
	#pet_lv_cfg{lv = 1944,max_exp = 4294967295,attr = [{1,7772},{2,155440},{3,3886},{4,3886}],combat = 233280,is_tv = 0};

get_lv_cfg(1945) ->
	#pet_lv_cfg{lv = 1945,max_exp = 4294967295,attr = [{1,7776},{2,155520},{3,3888},{4,3888}],combat = 233400,is_tv = 0};

get_lv_cfg(1946) ->
	#pet_lv_cfg{lv = 1946,max_exp = 4294967295,attr = [{1,7780},{2,155600},{3,3890},{4,3890}],combat = 233520,is_tv = 0};

get_lv_cfg(1947) ->
	#pet_lv_cfg{lv = 1947,max_exp = 4294967295,attr = [{1,7784},{2,155680},{3,3892},{4,3892}],combat = 233640,is_tv = 0};

get_lv_cfg(1948) ->
	#pet_lv_cfg{lv = 1948,max_exp = 4294967295,attr = [{1,7788},{2,155760},{3,3894},{4,3894}],combat = 233760,is_tv = 0};

get_lv_cfg(1949) ->
	#pet_lv_cfg{lv = 1949,max_exp = 4294967295,attr = [{1,7792},{2,155840},{3,3896},{4,3896}],combat = 233880,is_tv = 0};

get_lv_cfg(1950) ->
	#pet_lv_cfg{lv = 1950,max_exp = 4294967295,attr = [{1,7796},{2,155920},{3,3898},{4,3898}],combat = 234000,is_tv = 1};

get_lv_cfg(1951) ->
	#pet_lv_cfg{lv = 1951,max_exp = 4294967295,attr = [{1,7800},{2,156000},{3,3900},{4,3900}],combat = 234120,is_tv = 0};

get_lv_cfg(1952) ->
	#pet_lv_cfg{lv = 1952,max_exp = 4294967295,attr = [{1,7804},{2,156080},{3,3902},{4,3902}],combat = 234240,is_tv = 0};

get_lv_cfg(1953) ->
	#pet_lv_cfg{lv = 1953,max_exp = 4294967295,attr = [{1,7808},{2,156160},{3,3904},{4,3904}],combat = 234360,is_tv = 0};

get_lv_cfg(1954) ->
	#pet_lv_cfg{lv = 1954,max_exp = 4294967295,attr = [{1,7812},{2,156240},{3,3906},{4,3906}],combat = 234480,is_tv = 0};

get_lv_cfg(1955) ->
	#pet_lv_cfg{lv = 1955,max_exp = 4294967295,attr = [{1,7816},{2,156320},{3,3908},{4,3908}],combat = 234600,is_tv = 0};

get_lv_cfg(1956) ->
	#pet_lv_cfg{lv = 1956,max_exp = 4294967295,attr = [{1,7820},{2,156400},{3,3910},{4,3910}],combat = 234720,is_tv = 0};

get_lv_cfg(1957) ->
	#pet_lv_cfg{lv = 1957,max_exp = 4294967295,attr = [{1,7824},{2,156480},{3,3912},{4,3912}],combat = 234840,is_tv = 0};

get_lv_cfg(1958) ->
	#pet_lv_cfg{lv = 1958,max_exp = 4294967295,attr = [{1,7828},{2,156560},{3,3914},{4,3914}],combat = 234960,is_tv = 0};

get_lv_cfg(1959) ->
	#pet_lv_cfg{lv = 1959,max_exp = 4294967295,attr = [{1,7832},{2,156640},{3,3916},{4,3916}],combat = 235080,is_tv = 0};

get_lv_cfg(1960) ->
	#pet_lv_cfg{lv = 1960,max_exp = 4294967295,attr = [{1,7836},{2,156720},{3,3918},{4,3918}],combat = 235200,is_tv = 0};

get_lv_cfg(1961) ->
	#pet_lv_cfg{lv = 1961,max_exp = 4294967295,attr = [{1,7840},{2,156800},{3,3920},{4,3920}],combat = 235320,is_tv = 0};

get_lv_cfg(1962) ->
	#pet_lv_cfg{lv = 1962,max_exp = 4294967295,attr = [{1,7844},{2,156880},{3,3922},{4,3922}],combat = 235440,is_tv = 0};

get_lv_cfg(1963) ->
	#pet_lv_cfg{lv = 1963,max_exp = 4294967295,attr = [{1,7848},{2,156960},{3,3924},{4,3924}],combat = 235560,is_tv = 0};

get_lv_cfg(1964) ->
	#pet_lv_cfg{lv = 1964,max_exp = 4294967295,attr = [{1,7852},{2,157040},{3,3926},{4,3926}],combat = 235680,is_tv = 0};

get_lv_cfg(1965) ->
	#pet_lv_cfg{lv = 1965,max_exp = 4294967295,attr = [{1,7856},{2,157120},{3,3928},{4,3928}],combat = 235800,is_tv = 0};

get_lv_cfg(1966) ->
	#pet_lv_cfg{lv = 1966,max_exp = 4294967295,attr = [{1,7860},{2,157200},{3,3930},{4,3930}],combat = 235920,is_tv = 0};

get_lv_cfg(1967) ->
	#pet_lv_cfg{lv = 1967,max_exp = 4294967295,attr = [{1,7864},{2,157280},{3,3932},{4,3932}],combat = 236040,is_tv = 0};

get_lv_cfg(1968) ->
	#pet_lv_cfg{lv = 1968,max_exp = 4294967295,attr = [{1,7868},{2,157360},{3,3934},{4,3934}],combat = 236160,is_tv = 0};

get_lv_cfg(1969) ->
	#pet_lv_cfg{lv = 1969,max_exp = 4294967295,attr = [{1,7872},{2,157440},{3,3936},{4,3936}],combat = 236280,is_tv = 0};

get_lv_cfg(1970) ->
	#pet_lv_cfg{lv = 1970,max_exp = 4294967295,attr = [{1,7876},{2,157520},{3,3938},{4,3938}],combat = 236400,is_tv = 0};

get_lv_cfg(1971) ->
	#pet_lv_cfg{lv = 1971,max_exp = 4294967295,attr = [{1,7880},{2,157600},{3,3940},{4,3940}],combat = 236520,is_tv = 0};

get_lv_cfg(1972) ->
	#pet_lv_cfg{lv = 1972,max_exp = 4294967295,attr = [{1,7884},{2,157680},{3,3942},{4,3942}],combat = 236640,is_tv = 0};

get_lv_cfg(1973) ->
	#pet_lv_cfg{lv = 1973,max_exp = 4294967295,attr = [{1,7888},{2,157760},{3,3944},{4,3944}],combat = 236760,is_tv = 0};

get_lv_cfg(1974) ->
	#pet_lv_cfg{lv = 1974,max_exp = 4294967295,attr = [{1,7892},{2,157840},{3,3946},{4,3946}],combat = 236880,is_tv = 0};

get_lv_cfg(1975) ->
	#pet_lv_cfg{lv = 1975,max_exp = 4294967295,attr = [{1,7896},{2,157920},{3,3948},{4,3948}],combat = 237000,is_tv = 0};

get_lv_cfg(1976) ->
	#pet_lv_cfg{lv = 1976,max_exp = 4294967295,attr = [{1,7900},{2,158000},{3,3950},{4,3950}],combat = 237120,is_tv = 0};

get_lv_cfg(1977) ->
	#pet_lv_cfg{lv = 1977,max_exp = 4294967295,attr = [{1,7904},{2,158080},{3,3952},{4,3952}],combat = 237240,is_tv = 0};

get_lv_cfg(1978) ->
	#pet_lv_cfg{lv = 1978,max_exp = 4294967295,attr = [{1,7908},{2,158160},{3,3954},{4,3954}],combat = 237360,is_tv = 0};

get_lv_cfg(1979) ->
	#pet_lv_cfg{lv = 1979,max_exp = 4294967295,attr = [{1,7912},{2,158240},{3,3956},{4,3956}],combat = 237480,is_tv = 0};

get_lv_cfg(1980) ->
	#pet_lv_cfg{lv = 1980,max_exp = 4294967295,attr = [{1,7916},{2,158320},{3,3958},{4,3958}],combat = 237600,is_tv = 0};

get_lv_cfg(1981) ->
	#pet_lv_cfg{lv = 1981,max_exp = 4294967295,attr = [{1,7920},{2,158400},{3,3960},{4,3960}],combat = 237720,is_tv = 0};

get_lv_cfg(1982) ->
	#pet_lv_cfg{lv = 1982,max_exp = 4294967295,attr = [{1,7924},{2,158480},{3,3962},{4,3962}],combat = 237840,is_tv = 0};

get_lv_cfg(1983) ->
	#pet_lv_cfg{lv = 1983,max_exp = 4294967295,attr = [{1,7928},{2,158560},{3,3964},{4,3964}],combat = 237960,is_tv = 0};

get_lv_cfg(1984) ->
	#pet_lv_cfg{lv = 1984,max_exp = 4294967295,attr = [{1,7932},{2,158640},{3,3966},{4,3966}],combat = 238080,is_tv = 0};

get_lv_cfg(1985) ->
	#pet_lv_cfg{lv = 1985,max_exp = 4294967295,attr = [{1,7936},{2,158720},{3,3968},{4,3968}],combat = 238200,is_tv = 0};

get_lv_cfg(1986) ->
	#pet_lv_cfg{lv = 1986,max_exp = 4294967295,attr = [{1,7940},{2,158800},{3,3970},{4,3970}],combat = 238320,is_tv = 0};

get_lv_cfg(1987) ->
	#pet_lv_cfg{lv = 1987,max_exp = 4294967295,attr = [{1,7944},{2,158880},{3,3972},{4,3972}],combat = 238440,is_tv = 0};

get_lv_cfg(1988) ->
	#pet_lv_cfg{lv = 1988,max_exp = 4294967295,attr = [{1,7948},{2,158960},{3,3974},{4,3974}],combat = 238560,is_tv = 0};

get_lv_cfg(1989) ->
	#pet_lv_cfg{lv = 1989,max_exp = 4294967295,attr = [{1,7952},{2,159040},{3,3976},{4,3976}],combat = 238680,is_tv = 0};

get_lv_cfg(1990) ->
	#pet_lv_cfg{lv = 1990,max_exp = 4294967295,attr = [{1,7956},{2,159120},{3,3978},{4,3978}],combat = 238800,is_tv = 0};

get_lv_cfg(1991) ->
	#pet_lv_cfg{lv = 1991,max_exp = 4294967295,attr = [{1,7960},{2,159200},{3,3980},{4,3980}],combat = 238920,is_tv = 0};

get_lv_cfg(1992) ->
	#pet_lv_cfg{lv = 1992,max_exp = 4294967295,attr = [{1,7964},{2,159280},{3,3982},{4,3982}],combat = 239040,is_tv = 0};

get_lv_cfg(1993) ->
	#pet_lv_cfg{lv = 1993,max_exp = 4294967295,attr = [{1,7968},{2,159360},{3,3984},{4,3984}],combat = 239160,is_tv = 0};

get_lv_cfg(1994) ->
	#pet_lv_cfg{lv = 1994,max_exp = 4294967295,attr = [{1,7972},{2,159440},{3,3986},{4,3986}],combat = 239280,is_tv = 0};

get_lv_cfg(1995) ->
	#pet_lv_cfg{lv = 1995,max_exp = 4294967295,attr = [{1,7976},{2,159520},{3,3988},{4,3988}],combat = 239400,is_tv = 0};

get_lv_cfg(1996) ->
	#pet_lv_cfg{lv = 1996,max_exp = 4294967295,attr = [{1,7980},{2,159600},{3,3990},{4,3990}],combat = 239520,is_tv = 0};

get_lv_cfg(1997) ->
	#pet_lv_cfg{lv = 1997,max_exp = 4294967295,attr = [{1,7984},{2,159680},{3,3992},{4,3992}],combat = 239640,is_tv = 0};

get_lv_cfg(1998) ->
	#pet_lv_cfg{lv = 1998,max_exp = 4294967295,attr = [{1,7988},{2,159760},{3,3994},{4,3994}],combat = 239760,is_tv = 0};

get_lv_cfg(1999) ->
	#pet_lv_cfg{lv = 1999,max_exp = 4294967295,attr = [{1,7992},{2,159840},{3,3996},{4,3996}],combat = 239880,is_tv = 0};

get_lv_cfg(2000) ->
	#pet_lv_cfg{lv = 2000,max_exp = 4294967295,attr = [{1,7996},{2,159920},{3,3998},{4,3998}],combat = 240000,is_tv = 1};

get_lv_cfg(_Lv) ->
	[].

get_goods_cfg(_) ->
	[].

get_goods_ids() ->
[].

get_goods_exp(0,0,0,18030001) ->
	#pet_goods_exp_cfg{stage = 0,color = 0,star = 0,goods_id = 18030001,exp = 2000};

get_goods_exp(1,1,0,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 1,star = 0,goods_id = 0,exp = 10787};

get_goods_exp(1,1,1,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 1,star = 1,goods_id = 0,exp = 10787};

get_goods_exp(1,1,2,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 1,star = 2,goods_id = 0,exp = 10787};

get_goods_exp(1,1,3,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 1,star = 3,goods_id = 0,exp = 10787};

get_goods_exp(1,2,0,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 2,star = 0,goods_id = 0,exp = 16181};

get_goods_exp(1,2,1,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 2,star = 1,goods_id = 0,exp = 16181};

get_goods_exp(1,2,2,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 2,star = 2,goods_id = 0,exp = 16181};

get_goods_exp(1,2,3,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 2,star = 3,goods_id = 0,exp = 16181};

get_goods_exp(1,3,0,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 3,star = 0,goods_id = 0,exp = 21574};

get_goods_exp(1,3,1,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 3,star = 1,goods_id = 0,exp = 21574};

get_goods_exp(1,3,2,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 3,star = 2,goods_id = 0,exp = 21574};

get_goods_exp(1,3,3,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 3,star = 3,goods_id = 0,exp = 21574};

get_goods_exp(1,4,0,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 4,star = 0,goods_id = 0,exp = 32361};

get_goods_exp(1,4,1,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 4,star = 1,goods_id = 0,exp = 32361};

get_goods_exp(1,4,2,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 4,star = 2,goods_id = 0,exp = 32361};

get_goods_exp(1,4,3,0) ->
	#pet_goods_exp_cfg{stage = 1,color = 4,star = 3,goods_id = 0,exp = 32361};

get_goods_exp(2,1,0,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 1,star = 0,goods_id = 0,exp = 11135};

get_goods_exp(2,1,1,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 1,star = 1,goods_id = 0,exp = 11135};

get_goods_exp(2,1,2,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 1,star = 2,goods_id = 0,exp = 11135};

get_goods_exp(2,1,3,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 1,star = 3,goods_id = 0,exp = 11135};

get_goods_exp(2,2,0,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 2,star = 0,goods_id = 0,exp = 16703};

get_goods_exp(2,2,1,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 2,star = 1,goods_id = 0,exp = 16703};

get_goods_exp(2,2,2,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 2,star = 2,goods_id = 0,exp = 16703};

get_goods_exp(2,2,3,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 2,star = 3,goods_id = 0,exp = 16703};

get_goods_exp(2,3,0,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 3,star = 0,goods_id = 0,exp = 22270};

get_goods_exp(2,3,1,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 3,star = 1,goods_id = 0,exp = 22270};

get_goods_exp(2,3,2,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 3,star = 2,goods_id = 0,exp = 22270};

get_goods_exp(2,3,3,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 3,star = 3,goods_id = 0,exp = 22270};

get_goods_exp(2,4,0,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 4,star = 0,goods_id = 0,exp = 33405};

get_goods_exp(2,4,1,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 4,star = 1,goods_id = 0,exp = 33405};

get_goods_exp(2,4,2,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 4,star = 2,goods_id = 0,exp = 33405};

get_goods_exp(2,4,3,0) ->
	#pet_goods_exp_cfg{stage = 2,color = 4,star = 3,goods_id = 0,exp = 33405};

get_goods_exp(3,1,0,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 1,star = 0,goods_id = 0,exp = 11483};

get_goods_exp(3,1,1,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 1,star = 1,goods_id = 0,exp = 11483};

get_goods_exp(3,1,2,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 1,star = 2,goods_id = 0,exp = 11483};

get_goods_exp(3,1,3,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 1,star = 3,goods_id = 0,exp = 11483};

get_goods_exp(3,2,0,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 2,star = 0,goods_id = 0,exp = 17225};

get_goods_exp(3,2,1,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 2,star = 1,goods_id = 0,exp = 17225};

get_goods_exp(3,2,2,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 2,star = 2,goods_id = 0,exp = 17225};

get_goods_exp(3,2,3,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 2,star = 3,goods_id = 0,exp = 17225};

get_goods_exp(3,3,0,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 3,star = 0,goods_id = 0,exp = 22966};

get_goods_exp(3,3,1,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 3,star = 1,goods_id = 0,exp = 22966};

get_goods_exp(3,3,2,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 3,star = 2,goods_id = 0,exp = 22966};

get_goods_exp(3,3,3,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 3,star = 3,goods_id = 0,exp = 22966};

get_goods_exp(3,4,0,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 4,star = 0,goods_id = 0,exp = 34449};

get_goods_exp(3,4,1,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 4,star = 1,goods_id = 0,exp = 34449};

get_goods_exp(3,4,2,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 4,star = 2,goods_id = 0,exp = 34449};

get_goods_exp(3,4,3,0) ->
	#pet_goods_exp_cfg{stage = 3,color = 4,star = 3,goods_id = 0,exp = 34449};

get_goods_exp(4,1,0,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 1,star = 0,goods_id = 0,exp = 11831};

get_goods_exp(4,1,1,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 1,star = 1,goods_id = 0,exp = 11831};

get_goods_exp(4,1,2,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 1,star = 2,goods_id = 0,exp = 11831};

get_goods_exp(4,1,3,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 1,star = 3,goods_id = 0,exp = 11831};

get_goods_exp(4,2,0,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 2,star = 0,goods_id = 0,exp = 17747};

get_goods_exp(4,2,1,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 2,star = 1,goods_id = 0,exp = 17747};

get_goods_exp(4,2,2,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 2,star = 2,goods_id = 0,exp = 17747};

get_goods_exp(4,2,3,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 2,star = 3,goods_id = 0,exp = 17747};

get_goods_exp(4,3,0,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 3,star = 0,goods_id = 0,exp = 23662};

get_goods_exp(4,3,1,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 3,star = 1,goods_id = 0,exp = 23662};

get_goods_exp(4,3,2,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 3,star = 2,goods_id = 0,exp = 23662};

get_goods_exp(4,3,3,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 3,star = 3,goods_id = 0,exp = 23662};

get_goods_exp(4,4,0,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 4,star = 0,goods_id = 0,exp = 35493};

get_goods_exp(4,4,1,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 4,star = 1,goods_id = 0,exp = 35493};

get_goods_exp(4,4,2,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 4,star = 2,goods_id = 0,exp = 35493};

get_goods_exp(4,4,3,0) ->
	#pet_goods_exp_cfg{stage = 4,color = 4,star = 3,goods_id = 0,exp = 35493};

get_goods_exp(5,1,0,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 1,star = 0,goods_id = 0,exp = 12179};

get_goods_exp(5,1,1,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 1,star = 1,goods_id = 0,exp = 12179};

get_goods_exp(5,1,2,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 1,star = 2,goods_id = 0,exp = 12179};

get_goods_exp(5,1,3,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 1,star = 3,goods_id = 0,exp = 12179};

get_goods_exp(5,2,0,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 2,star = 0,goods_id = 0,exp = 18269};

get_goods_exp(5,2,1,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 2,star = 1,goods_id = 0,exp = 18269};

get_goods_exp(5,2,2,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 2,star = 2,goods_id = 0,exp = 18269};

get_goods_exp(5,2,3,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 2,star = 3,goods_id = 0,exp = 18269};

get_goods_exp(5,3,0,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 3,star = 0,goods_id = 0,exp = 24358};

get_goods_exp(5,3,1,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 3,star = 1,goods_id = 0,exp = 24358};

get_goods_exp(5,3,2,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 3,star = 2,goods_id = 0,exp = 24358};

get_goods_exp(5,3,3,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 3,star = 3,goods_id = 0,exp = 24358};

get_goods_exp(5,4,0,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 4,star = 0,goods_id = 0,exp = 36537};

get_goods_exp(5,4,1,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 4,star = 1,goods_id = 0,exp = 36537};

get_goods_exp(5,4,2,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 4,star = 2,goods_id = 0,exp = 36537};

get_goods_exp(5,4,3,0) ->
	#pet_goods_exp_cfg{stage = 5,color = 4,star = 3,goods_id = 0,exp = 36537};

get_goods_exp(6,1,0,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 1,star = 0,goods_id = 0,exp = 14615};

get_goods_exp(6,1,1,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 1,star = 1,goods_id = 0,exp = 14615};

get_goods_exp(6,1,2,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 1,star = 2,goods_id = 0,exp = 14615};

get_goods_exp(6,1,3,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 1,star = 3,goods_id = 0,exp = 14615};

get_goods_exp(6,2,0,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 2,star = 0,goods_id = 0,exp = 21923};

get_goods_exp(6,2,1,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 2,star = 1,goods_id = 0,exp = 21923};

get_goods_exp(6,2,2,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 2,star = 2,goods_id = 0,exp = 21923};

get_goods_exp(6,2,3,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 2,star = 3,goods_id = 0,exp = 21923};

get_goods_exp(6,3,0,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 3,star = 0,goods_id = 0,exp = 29230};

get_goods_exp(6,3,1,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 3,star = 1,goods_id = 0,exp = 29230};

get_goods_exp(6,3,2,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 3,star = 2,goods_id = 0,exp = 29230};

get_goods_exp(6,3,3,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 3,star = 3,goods_id = 0,exp = 29230};

get_goods_exp(6,4,0,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 4,star = 0,goods_id = 0,exp = 43845};

get_goods_exp(6,4,1,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 4,star = 1,goods_id = 0,exp = 43845};

get_goods_exp(6,4,2,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 4,star = 2,goods_id = 0,exp = 43845};

get_goods_exp(6,4,3,0) ->
	#pet_goods_exp_cfg{stage = 6,color = 4,star = 3,goods_id = 0,exp = 43845};

get_goods_exp(7,1,0,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 1,star = 0,goods_id = 0,exp = 17167};

get_goods_exp(7,1,1,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 1,star = 1,goods_id = 0,exp = 17167};

get_goods_exp(7,1,2,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 1,star = 2,goods_id = 0,exp = 17167};

get_goods_exp(7,1,3,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 1,star = 3,goods_id = 0,exp = 17167};

get_goods_exp(7,2,0,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 2,star = 0,goods_id = 0,exp = 25751};

get_goods_exp(7,2,1,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 2,star = 1,goods_id = 0,exp = 25751};

get_goods_exp(7,2,2,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 2,star = 2,goods_id = 0,exp = 25751};

get_goods_exp(7,2,3,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 2,star = 3,goods_id = 0,exp = 25751};

get_goods_exp(7,3,0,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 3,star = 0,goods_id = 0,exp = 34334};

get_goods_exp(7,3,1,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 3,star = 1,goods_id = 0,exp = 34334};

get_goods_exp(7,3,2,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 3,star = 2,goods_id = 0,exp = 34334};

get_goods_exp(7,3,3,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 3,star = 3,goods_id = 0,exp = 34334};

get_goods_exp(7,4,0,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 4,star = 0,goods_id = 0,exp = 51501};

get_goods_exp(7,4,1,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 4,star = 1,goods_id = 0,exp = 51501};

get_goods_exp(7,4,2,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 4,star = 2,goods_id = 0,exp = 51501};

get_goods_exp(7,4,3,0) ->
	#pet_goods_exp_cfg{stage = 7,color = 4,star = 3,goods_id = 0,exp = 51501};

get_goods_exp(8,1,0,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 1,star = 0,goods_id = 0,exp = 17631};

get_goods_exp(8,1,1,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 1,star = 1,goods_id = 0,exp = 17631};

get_goods_exp(8,1,2,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 1,star = 2,goods_id = 0,exp = 17631};

get_goods_exp(8,1,3,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 1,star = 3,goods_id = 0,exp = 17631};

get_goods_exp(8,2,0,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 2,star = 0,goods_id = 0,exp = 26447};

get_goods_exp(8,2,1,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 2,star = 1,goods_id = 0,exp = 26447};

get_goods_exp(8,2,2,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 2,star = 2,goods_id = 0,exp = 26447};

get_goods_exp(8,2,3,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 2,star = 3,goods_id = 0,exp = 26447};

get_goods_exp(8,3,0,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 3,star = 0,goods_id = 0,exp = 35262};

get_goods_exp(8,3,1,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 3,star = 1,goods_id = 0,exp = 35262};

get_goods_exp(8,3,2,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 3,star = 2,goods_id = 0,exp = 35262};

get_goods_exp(8,3,3,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 3,star = 3,goods_id = 0,exp = 35262};

get_goods_exp(8,4,0,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 4,star = 0,goods_id = 0,exp = 52893};

get_goods_exp(8,4,1,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 4,star = 1,goods_id = 0,exp = 52893};

get_goods_exp(8,4,2,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 4,star = 2,goods_id = 0,exp = 52893};

get_goods_exp(8,4,3,0) ->
	#pet_goods_exp_cfg{stage = 8,color = 4,star = 3,goods_id = 0,exp = 52893};

get_goods_exp(9,1,0,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 1,star = 0,goods_id = 0,exp = 20357};

get_goods_exp(9,1,1,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 1,star = 1,goods_id = 0,exp = 20357};

get_goods_exp(9,1,2,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 1,star = 2,goods_id = 0,exp = 20357};

get_goods_exp(9,1,3,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 1,star = 3,goods_id = 0,exp = 20357};

get_goods_exp(9,2,0,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 2,star = 0,goods_id = 0,exp = 30536};

get_goods_exp(9,2,1,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 2,star = 1,goods_id = 0,exp = 30536};

get_goods_exp(9,2,2,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 2,star = 2,goods_id = 0,exp = 30536};

get_goods_exp(9,2,3,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 2,star = 3,goods_id = 0,exp = 30536};

get_goods_exp(9,3,0,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 3,star = 0,goods_id = 0,exp = 40714};

get_goods_exp(9,3,1,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 3,star = 1,goods_id = 0,exp = 40714};

get_goods_exp(9,3,2,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 3,star = 2,goods_id = 0,exp = 40714};

get_goods_exp(9,3,3,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 3,star = 3,goods_id = 0,exp = 40714};

get_goods_exp(9,4,0,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 4,star = 0,goods_id = 0,exp = 61071};

get_goods_exp(9,4,1,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 4,star = 1,goods_id = 0,exp = 61071};

get_goods_exp(9,4,2,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 4,star = 2,goods_id = 0,exp = 61071};

get_goods_exp(9,4,3,0) ->
	#pet_goods_exp_cfg{stage = 9,color = 4,star = 3,goods_id = 0,exp = 61071};

get_goods_exp(10,1,0,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 1,star = 0,goods_id = 0,exp = 20879};

get_goods_exp(10,1,1,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 1,star = 1,goods_id = 0,exp = 20879};

get_goods_exp(10,1,2,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 1,star = 2,goods_id = 0,exp = 20879};

get_goods_exp(10,1,3,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 1,star = 3,goods_id = 0,exp = 20879};

get_goods_exp(10,2,0,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 2,star = 0,goods_id = 0,exp = 31319};

get_goods_exp(10,2,1,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 2,star = 1,goods_id = 0,exp = 31319};

get_goods_exp(10,2,2,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 2,star = 2,goods_id = 0,exp = 31319};

get_goods_exp(10,2,3,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 2,star = 3,goods_id = 0,exp = 31319};

get_goods_exp(10,3,0,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 3,star = 0,goods_id = 0,exp = 41758};

get_goods_exp(10,3,1,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 3,star = 1,goods_id = 0,exp = 41758};

get_goods_exp(10,3,2,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 3,star = 2,goods_id = 0,exp = 41758};

get_goods_exp(10,3,3,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 3,star = 3,goods_id = 0,exp = 41758};

get_goods_exp(10,4,0,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 4,star = 0,goods_id = 0,exp = 62637};

get_goods_exp(10,4,1,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 4,star = 1,goods_id = 0,exp = 62637};

get_goods_exp(10,4,2,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 4,star = 2,goods_id = 0,exp = 62637};

get_goods_exp(10,4,3,0) ->
	#pet_goods_exp_cfg{stage = 10,color = 4,star = 3,goods_id = 0,exp = 62637};

get_goods_exp(11,1,0,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 1,star = 0,goods_id = 0,exp = 23778};

get_goods_exp(11,1,1,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 1,star = 1,goods_id = 0,exp = 23778};

get_goods_exp(11,1,2,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 1,star = 2,goods_id = 0,exp = 23778};

get_goods_exp(11,1,3,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 1,star = 3,goods_id = 0,exp = 23778};

get_goods_exp(11,2,0,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 2,star = 0,goods_id = 0,exp = 35667};

get_goods_exp(11,2,1,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 2,star = 1,goods_id = 0,exp = 35667};

get_goods_exp(11,2,2,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 2,star = 2,goods_id = 0,exp = 35667};

get_goods_exp(11,2,3,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 2,star = 3,goods_id = 0,exp = 35667};

get_goods_exp(11,3,0,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 3,star = 0,goods_id = 0,exp = 47556};

get_goods_exp(11,3,1,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 3,star = 1,goods_id = 0,exp = 47556};

get_goods_exp(11,3,2,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 3,star = 2,goods_id = 0,exp = 47556};

get_goods_exp(11,3,3,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 3,star = 3,goods_id = 0,exp = 47556};

get_goods_exp(11,4,0,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 4,star = 0,goods_id = 0,exp = 71334};

get_goods_exp(11,4,1,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 4,star = 1,goods_id = 0,exp = 71334};

get_goods_exp(11,4,2,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 4,star = 2,goods_id = 0,exp = 71334};

get_goods_exp(11,4,3,0) ->
	#pet_goods_exp_cfg{stage = 11,color = 4,star = 3,goods_id = 0,exp = 71334};

get_goods_exp(12,1,0,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 1,star = 0,goods_id = 0,exp = 24358};

get_goods_exp(12,1,1,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 1,star = 1,goods_id = 0,exp = 24358};

get_goods_exp(12,1,2,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 1,star = 2,goods_id = 0,exp = 24358};

get_goods_exp(12,1,3,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 1,star = 3,goods_id = 0,exp = 24358};

get_goods_exp(12,2,0,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 2,star = 0,goods_id = 0,exp = 36537};

get_goods_exp(12,2,1,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 2,star = 1,goods_id = 0,exp = 36537};

get_goods_exp(12,2,2,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 2,star = 2,goods_id = 0,exp = 36537};

get_goods_exp(12,2,3,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 2,star = 3,goods_id = 0,exp = 36537};

get_goods_exp(12,3,0,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 3,star = 0,goods_id = 0,exp = 48716};

get_goods_exp(12,3,1,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 3,star = 1,goods_id = 0,exp = 48716};

get_goods_exp(12,3,2,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 3,star = 2,goods_id = 0,exp = 48716};

get_goods_exp(12,3,3,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 3,star = 3,goods_id = 0,exp = 48716};

get_goods_exp(12,4,0,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 4,star = 0,goods_id = 0,exp = 73074};

get_goods_exp(12,4,1,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 4,star = 1,goods_id = 0,exp = 73074};

get_goods_exp(12,4,2,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 4,star = 2,goods_id = 0,exp = 73074};

get_goods_exp(12,4,3,0) ->
	#pet_goods_exp_cfg{stage = 12,color = 4,star = 3,goods_id = 0,exp = 73074};

get_goods_exp(13,1,0,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 1,star = 0,goods_id = 0,exp = 27432};

get_goods_exp(13,1,1,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 1,star = 1,goods_id = 0,exp = 27432};

get_goods_exp(13,1,2,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 1,star = 2,goods_id = 0,exp = 27432};

get_goods_exp(13,1,3,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 1,star = 3,goods_id = 0,exp = 27432};

get_goods_exp(13,2,0,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 2,star = 0,goods_id = 0,exp = 41148};

get_goods_exp(13,2,1,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 2,star = 1,goods_id = 0,exp = 41148};

get_goods_exp(13,2,2,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 2,star = 2,goods_id = 0,exp = 41148};

get_goods_exp(13,2,3,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 2,star = 3,goods_id = 0,exp = 41148};

get_goods_exp(13,3,0,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 3,star = 0,goods_id = 0,exp = 54864};

get_goods_exp(13,3,1,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 3,star = 1,goods_id = 0,exp = 54864};

get_goods_exp(13,3,2,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 3,star = 2,goods_id = 0,exp = 54864};

get_goods_exp(13,3,3,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 3,star = 3,goods_id = 0,exp = 54864};

get_goods_exp(13,4,0,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 4,star = 0,goods_id = 0,exp = 82296};

get_goods_exp(13,4,1,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 4,star = 1,goods_id = 0,exp = 82296};

get_goods_exp(13,4,2,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 4,star = 2,goods_id = 0,exp = 82296};

get_goods_exp(13,4,3,0) ->
	#pet_goods_exp_cfg{stage = 13,color = 4,star = 3,goods_id = 0,exp = 82296};

get_goods_exp(14,1,0,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 1,star = 0,goods_id = 0,exp = 28070};

get_goods_exp(14,1,1,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 1,star = 1,goods_id = 0,exp = 28070};

get_goods_exp(14,1,2,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 1,star = 2,goods_id = 0,exp = 28070};

get_goods_exp(14,1,3,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 1,star = 3,goods_id = 0,exp = 28070};

get_goods_exp(14,2,0,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 2,star = 0,goods_id = 0,exp = 42105};

get_goods_exp(14,2,1,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 2,star = 1,goods_id = 0,exp = 42105};

get_goods_exp(14,2,2,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 2,star = 2,goods_id = 0,exp = 42105};

get_goods_exp(14,2,3,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 2,star = 3,goods_id = 0,exp = 42105};

get_goods_exp(14,3,0,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 3,star = 0,goods_id = 0,exp = 56140};

get_goods_exp(14,3,1,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 3,star = 1,goods_id = 0,exp = 56140};

get_goods_exp(14,3,2,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 3,star = 2,goods_id = 0,exp = 56140};

get_goods_exp(14,3,3,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 3,star = 3,goods_id = 0,exp = 56140};

get_goods_exp(14,4,0,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 4,star = 0,goods_id = 0,exp = 84210};

get_goods_exp(14,4,1,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 4,star = 1,goods_id = 0,exp = 84210};

get_goods_exp(14,4,2,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 4,star = 2,goods_id = 0,exp = 84210};

get_goods_exp(14,4,3,0) ->
	#pet_goods_exp_cfg{stage = 14,color = 4,star = 3,goods_id = 0,exp = 84210};

get_goods_exp(15,1,0,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 1,star = 0,goods_id = 0,exp = 28708};

get_goods_exp(15,1,1,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 1,star = 1,goods_id = 0,exp = 28708};

get_goods_exp(15,1,2,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 1,star = 2,goods_id = 0,exp = 28708};

get_goods_exp(15,1,3,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 1,star = 3,goods_id = 0,exp = 28708};

get_goods_exp(15,2,0,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 2,star = 0,goods_id = 0,exp = 43062};

get_goods_exp(15,2,1,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 2,star = 1,goods_id = 0,exp = 43062};

get_goods_exp(15,2,2,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 2,star = 2,goods_id = 0,exp = 43062};

get_goods_exp(15,2,3,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 2,star = 3,goods_id = 0,exp = 43062};

get_goods_exp(15,3,0,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 3,star = 0,goods_id = 0,exp = 57416};

get_goods_exp(15,3,1,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 3,star = 1,goods_id = 0,exp = 57416};

get_goods_exp(15,3,2,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 3,star = 2,goods_id = 0,exp = 57416};

get_goods_exp(15,3,3,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 3,star = 3,goods_id = 0,exp = 57416};

get_goods_exp(15,4,0,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 4,star = 0,goods_id = 0,exp = 86124};

get_goods_exp(15,4,1,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 4,star = 1,goods_id = 0,exp = 86124};

get_goods_exp(15,4,2,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 4,star = 2,goods_id = 0,exp = 86124};

get_goods_exp(15,4,3,0) ->
	#pet_goods_exp_cfg{stage = 15,color = 4,star = 3,goods_id = 0,exp = 86124};

get_goods_exp(16,1,0,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 1,star = 0,goods_id = 0,exp = 29346};

get_goods_exp(16,1,1,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 1,star = 1,goods_id = 0,exp = 29346};

get_goods_exp(16,1,2,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 1,star = 2,goods_id = 0,exp = 29346};

get_goods_exp(16,1,3,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 1,star = 3,goods_id = 0,exp = 29346};

get_goods_exp(16,2,0,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 2,star = 0,goods_id = 0,exp = 44019};

get_goods_exp(16,2,1,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 2,star = 1,goods_id = 0,exp = 44019};

get_goods_exp(16,2,2,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 2,star = 2,goods_id = 0,exp = 44019};

get_goods_exp(16,2,3,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 2,star = 3,goods_id = 0,exp = 44019};

get_goods_exp(16,3,0,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 3,star = 0,goods_id = 0,exp = 58692};

get_goods_exp(16,3,1,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 3,star = 1,goods_id = 0,exp = 58692};

get_goods_exp(16,3,2,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 3,star = 2,goods_id = 0,exp = 58692};

get_goods_exp(16,3,3,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 3,star = 3,goods_id = 0,exp = 58692};

get_goods_exp(16,4,0,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 4,star = 0,goods_id = 0,exp = 88038};

get_goods_exp(16,4,1,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 4,star = 1,goods_id = 0,exp = 88038};

get_goods_exp(16,4,2,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 4,star = 2,goods_id = 0,exp = 88038};

get_goods_exp(16,4,3,0) ->
	#pet_goods_exp_cfg{stage = 16,color = 4,star = 3,goods_id = 0,exp = 88038};

get_goods_exp(_Stage,_Color,_Star,_Goodsid) ->
	[].

get_skill_cfg(13000001) ->
	#pet_skill_cfg{skill_id = 13000001,type = 1,ownership_id = 0,stage = 1};

get_skill_cfg(13000002) ->
	#pet_skill_cfg{skill_id = 13000002,type = 1,ownership_id = 0,stage = 3};

get_skill_cfg(13000003) ->
	#pet_skill_cfg{skill_id = 13000003,type = 1,ownership_id = 0,stage = 5};

get_skill_cfg(13000004) ->
	#pet_skill_cfg{skill_id = 13000004,type = 1,ownership_id = 0,stage = 7};

get_skill_cfg(13000005) ->
	#pet_skill_cfg{skill_id = 13000005,type = 1,ownership_id = 0,stage = 10};

get_skill_cfg(13010001) ->
	#pet_skill_cfg{skill_id = 13010001,type = 2,ownership_id = 1,stage = 3};

get_skill_cfg(13010002) ->
	#pet_skill_cfg{skill_id = 13010002,type = 2,ownership_id = 1,stage = 6};

get_skill_cfg(13010003) ->
	#pet_skill_cfg{skill_id = 13010003,type = 2,ownership_id = 1,stage = 10};

get_skill_cfg(13020001) ->
	#pet_skill_cfg{skill_id = 13020001,type = 2,ownership_id = 2,stage = 3};

get_skill_cfg(13020002) ->
	#pet_skill_cfg{skill_id = 13020002,type = 2,ownership_id = 2,stage = 6};

get_skill_cfg(13020003) ->
	#pet_skill_cfg{skill_id = 13020003,type = 2,ownership_id = 2,stage = 10};

get_skill_cfg(13020004) ->
	#pet_skill_cfg{skill_id = 13020004,type = 2,ownership_id = 2,stage = 1};

get_skill_cfg(13030001) ->
	#pet_skill_cfg{skill_id = 13030001,type = 2,ownership_id = 3,stage = 3};

get_skill_cfg(13030002) ->
	#pet_skill_cfg{skill_id = 13030002,type = 2,ownership_id = 3,stage = 6};

get_skill_cfg(13030003) ->
	#pet_skill_cfg{skill_id = 13030003,type = 2,ownership_id = 3,stage = 10};

get_skill_cfg(13030004) ->
	#pet_skill_cfg{skill_id = 13030004,type = 2,ownership_id = 3,stage = 1};

get_skill_cfg(13040001) ->
	#pet_skill_cfg{skill_id = 13040001,type = 2,ownership_id = 4,stage = 3};

get_skill_cfg(13040002) ->
	#pet_skill_cfg{skill_id = 13040002,type = 2,ownership_id = 4,stage = 6};

get_skill_cfg(13040003) ->
	#pet_skill_cfg{skill_id = 13040003,type = 2,ownership_id = 4,stage = 10};

get_skill_cfg(13040004) ->
	#pet_skill_cfg{skill_id = 13040004,type = 2,ownership_id = 4,stage = 1};

get_skill_cfg(13050001) ->
	#pet_skill_cfg{skill_id = 13050001,type = 2,ownership_id = 5,stage = 3};

get_skill_cfg(13050002) ->
	#pet_skill_cfg{skill_id = 13050002,type = 2,ownership_id = 5,stage = 6};

get_skill_cfg(13050003) ->
	#pet_skill_cfg{skill_id = 13050003,type = 2,ownership_id = 5,stage = 10};

get_skill_cfg(_Skillid) ->
	[].

get_unlock_skill(1,0,1) ->
[13000001];

get_unlock_skill(1,0,3) ->
[13000002];

get_unlock_skill(1,0,5) ->
[13000003];

get_unlock_skill(1,0,7) ->
[13000004];

get_unlock_skill(1,0,10) ->
[13000005];

get_unlock_skill(2,1,3) ->
[13010001];

get_unlock_skill(2,1,6) ->
[13010002];

get_unlock_skill(2,1,10) ->
[13010003];

get_unlock_skill(2,2,3) ->
[13020001];

get_unlock_skill(2,2,6) ->
[13020002];

get_unlock_skill(2,2,10) ->
[13020003];

get_unlock_skill(2,2,1) ->
[13020004];

get_unlock_skill(2,3,3) ->
[13030001];

get_unlock_skill(2,3,6) ->
[13030002];

get_unlock_skill(2,3,10) ->
[13030003];

get_unlock_skill(2,3,1) ->
[13030004];

get_unlock_skill(2,4,3) ->
[13040001];

get_unlock_skill(2,4,6) ->
[13040002];

get_unlock_skill(2,4,10) ->
[13040003];

get_unlock_skill(2,4,1) ->
[13040004];

get_unlock_skill(2,5,3) ->
[13050001];

get_unlock_skill(2,5,6) ->
[13050002];

get_unlock_skill(2,5,10) ->
[13050003];

get_unlock_skill(_Type,_Ownershipid,_Stage) ->
	[].

get_skill_by_type(1,0) ->
[13000001,13000002,13000003,13000004,13000005];

get_skill_by_type(2,1) ->
[13010001,13010002,13010003];

get_skill_by_type(2,2) ->
[13020001,13020002,13020003,13020004];

get_skill_by_type(2,3) ->
[13030001,13030002,13030003,13030004];

get_skill_by_type(2,4) ->
[13040001,13040002,13040003,13040004];

get_skill_by_type(2,5) ->
[13050001,13050002,13050003];

get_skill_by_type(_Type,_Ownershipid) ->
	[].

get_figure_cfg(1) ->
	#pet_figure_cfg{id = 1,name = "王国公主",desc = "变身为王国公主",figure = 2010420100,goods_id = 18040001,goods_num = 1,goods_exp = 300,stage_lim = 5,skill_list = [13010001,13010002,13010003],is_tv = 1,nskill_id = 13000001};

get_figure_cfg(2) ->
	#pet_figure_cfg{id = 2,name = "女武神",desc = "变身为女武神",figure = 181001,goods_id = 18040002,goods_num = 1,goods_exp = 300,stage_lim = 5,skill_list = [13020001,13020002,13020003],is_tv = 1,nskill_id = 13020004};

get_figure_cfg(3) ->
	#pet_figure_cfg{id = 3,name = "樱花忍者",desc = "变身为女忍者",figure = 181005,goods_id = 18040003,goods_num = 1,goods_exp = 500,stage_lim = 5,skill_list = [13030001,13030002,13030003],is_tv = 1,nskill_id = 13030004};

get_figure_cfg(4) ->
	#pet_figure_cfg{id = 4,name = "精灵王子",desc = "变身为精灵王子",figure = 181002,goods_id = 18040004,goods_num = 1,goods_exp = 300,stage_lim = 5,skill_list = [13040001,13040002,13040003],is_tv = 0,nskill_id = 13040004};

get_figure_cfg(5) ->
	#pet_figure_cfg{id = 5,name = "叛逆少女",desc = "叛逆少女",figure = 181006,goods_id = 18040005,goods_num = 1,goods_exp = 500,stage_lim = 5,skill_list = [13050001,13050002,13050003],is_tv = 1,nskill_id = 13000001};

get_figure_cfg(_Id) ->
	[].

get_figure_stage_cfg(1,0) ->
	#pet_figure_stage_cfg{id = 1,stage = 0,blessing = 1,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 0,is_tv = 0};

get_figure_stage_cfg(1,1) ->
	#pet_figure_stage_cfg{id = 1,stage = 1,blessing = 200,attr = [{1,280},{2,5600},{3,140},{4,140}],combat = 8400,is_tv = 0};

get_figure_stage_cfg(1,2) ->
	#pet_figure_stage_cfg{id = 1,stage = 2,blessing = 300,attr = [{1,400},{2,8000},{3,200},{4,200}],combat = 12000,is_tv = 0};

get_figure_stage_cfg(1,3) ->
	#pet_figure_stage_cfg{id = 1,stage = 3,blessing = 400,attr = [{1,520},{2,10400},{3,260},{4,260}],combat = 15600,is_tv = 1};

get_figure_stage_cfg(1,4) ->
	#pet_figure_stage_cfg{id = 1,stage = 4,blessing = 500,attr = [{1,640},{2,12800},{3,320},{4,320}],combat = 19200,is_tv = 0};

get_figure_stage_cfg(1,5) ->
	#pet_figure_stage_cfg{id = 1,stage = 5,blessing = 600,attr = [{1,760},{2,15200},{3,380},{4,380}],combat = 22800,is_tv = 0};

get_figure_stage_cfg(1,6) ->
	#pet_figure_stage_cfg{id = 1,stage = 6,blessing = 700,attr = [{1,880},{2,17600},{3,440},{4,440}],combat = 26400,is_tv = 1};

get_figure_stage_cfg(1,7) ->
	#pet_figure_stage_cfg{id = 1,stage = 7,blessing = 800,attr = [{1,1000},{2,20000},{3,500},{4,500}],combat = 30000,is_tv = 0};

get_figure_stage_cfg(1,8) ->
	#pet_figure_stage_cfg{id = 1,stage = 8,blessing = 900,attr = [{1,1120},{2,22400},{3,560},{4,560}],combat = 33600,is_tv = 0};

get_figure_stage_cfg(1,9) ->
	#pet_figure_stage_cfg{id = 1,stage = 9,blessing = 1000,attr = [{1,1240},{2,24800},{3,620},{4,620}],combat = 37200,is_tv = 0};

get_figure_stage_cfg(1,10) ->
	#pet_figure_stage_cfg{id = 1,stage = 10,blessing = 0,attr = [{1,1360},{2,27200},{3,680},{4,680}],combat = 40800,is_tv = 1};

get_figure_stage_cfg(2,0) ->
	#pet_figure_stage_cfg{id = 2,stage = 0,blessing = 1,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 0,is_tv = 0};

get_figure_stage_cfg(2,1) ->
	#pet_figure_stage_cfg{id = 2,stage = 1,blessing = 400,attr = [{1,500},{2,10000},{3,250},{4,250}],combat = 15000,is_tv = 0};

get_figure_stage_cfg(2,2) ->
	#pet_figure_stage_cfg{id = 2,stage = 2,blessing = 600,attr = [{1,680},{2,13600},{3,340},{4,340}],combat = 20400,is_tv = 0};

get_figure_stage_cfg(2,3) ->
	#pet_figure_stage_cfg{id = 2,stage = 3,blessing = 800,attr = [{1,860},{2,17200},{3,430},{4,430}],combat = 25800,is_tv = 1};

get_figure_stage_cfg(2,4) ->
	#pet_figure_stage_cfg{id = 2,stage = 4,blessing = 1000,attr = [{1,1040},{2,20800},{3,520},{4,520}],combat = 31200,is_tv = 0};

get_figure_stage_cfg(2,5) ->
	#pet_figure_stage_cfg{id = 2,stage = 5,blessing = 1200,attr = [{1,1220},{2,24400},{3,610},{4,610}],combat = 36600,is_tv = 0};

get_figure_stage_cfg(2,6) ->
	#pet_figure_stage_cfg{id = 2,stage = 6,blessing = 1400,attr = [{1,1400},{2,28000},{3,700},{4,700}],combat = 42000,is_tv = 1};

get_figure_stage_cfg(2,7) ->
	#pet_figure_stage_cfg{id = 2,stage = 7,blessing = 1600,attr = [{1,1580},{2,31600},{3,790},{4,790}],combat = 47400,is_tv = 0};

get_figure_stage_cfg(2,8) ->
	#pet_figure_stage_cfg{id = 2,stage = 8,blessing = 1800,attr = [{1,1760},{2,35200},{3,880},{4,880}],combat = 52800,is_tv = 0};

get_figure_stage_cfg(2,9) ->
	#pet_figure_stage_cfg{id = 2,stage = 9,blessing = 2000,attr = [{1,1940},{2,38800},{3,970},{4,970}],combat = 58200,is_tv = 0};

get_figure_stage_cfg(2,10) ->
	#pet_figure_stage_cfg{id = 2,stage = 10,blessing = 0,attr = [{1,2120},{2,42400},{3,1060},{4,1060}],combat = 63600,is_tv = 1};

get_figure_stage_cfg(3,0) ->
	#pet_figure_stage_cfg{id = 3,stage = 0,blessing = 1,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 0,is_tv = 0};

get_figure_stage_cfg(3,1) ->
	#pet_figure_stage_cfg{id = 3,stage = 1,blessing = 400,attr = [{1,750},{2,15000},{3,375},{4,375}],combat = 22500,is_tv = 0};

get_figure_stage_cfg(3,2) ->
	#pet_figure_stage_cfg{id = 3,stage = 2,blessing = 600,attr = [{1,930},{2,18600},{3,465},{4,465}],combat = 27900,is_tv = 0};

get_figure_stage_cfg(3,3) ->
	#pet_figure_stage_cfg{id = 3,stage = 3,blessing = 800,attr = [{1,1110},{2,22200},{3,555},{4,555}],combat = 33300,is_tv = 1};

get_figure_stage_cfg(3,4) ->
	#pet_figure_stage_cfg{id = 3,stage = 4,blessing = 1000,attr = [{1,1290},{2,25800},{3,645},{4,645}],combat = 38700,is_tv = 0};

get_figure_stage_cfg(3,5) ->
	#pet_figure_stage_cfg{id = 3,stage = 5,blessing = 1200,attr = [{1,1470},{2,29400},{3,735},{4,735}],combat = 44100,is_tv = 0};

get_figure_stage_cfg(3,6) ->
	#pet_figure_stage_cfg{id = 3,stage = 6,blessing = 1400,attr = [{1,1650},{2,33000},{3,825},{4,825}],combat = 49500,is_tv = 1};

get_figure_stage_cfg(3,7) ->
	#pet_figure_stage_cfg{id = 3,stage = 7,blessing = 1600,attr = [{1,1830},{2,36600},{3,915},{4,915}],combat = 54900,is_tv = 0};

get_figure_stage_cfg(3,8) ->
	#pet_figure_stage_cfg{id = 3,stage = 8,blessing = 1800,attr = [{1,2010},{2,40200},{3,1005},{4,1005}],combat = 60300,is_tv = 0};

get_figure_stage_cfg(3,9) ->
	#pet_figure_stage_cfg{id = 3,stage = 9,blessing = 2000,attr = [{1,2190},{2,43800},{3,1095},{4,1095}],combat = 65700,is_tv = 0};

get_figure_stage_cfg(3,10) ->
	#pet_figure_stage_cfg{id = 3,stage = 10,blessing = 0,attr = [{1,2370},{2,47400},{3,1185},{4,1185}],combat = 71100,is_tv = 1};

get_figure_stage_cfg(4,0) ->
	#pet_figure_stage_cfg{id = 4,stage = 0,blessing = 1,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 0,is_tv = 0};

get_figure_stage_cfg(4,1) ->
	#pet_figure_stage_cfg{id = 4,stage = 1,blessing = 400,attr = [{1,500},{2,10000},{3,250},{4,250}],combat = 15000,is_tv = 0};

get_figure_stage_cfg(4,2) ->
	#pet_figure_stage_cfg{id = 4,stage = 2,blessing = 600,attr = [{1,680},{2,13600},{3,340},{4,340}],combat = 20400,is_tv = 0};

get_figure_stage_cfg(4,3) ->
	#pet_figure_stage_cfg{id = 4,stage = 3,blessing = 800,attr = [{1,860},{2,17200},{3,430},{4,430}],combat = 25800,is_tv = 1};

get_figure_stage_cfg(4,4) ->
	#pet_figure_stage_cfg{id = 4,stage = 4,blessing = 1000,attr = [{1,1040},{2,20800},{3,520},{4,520}],combat = 31200,is_tv = 0};

get_figure_stage_cfg(4,5) ->
	#pet_figure_stage_cfg{id = 4,stage = 5,blessing = 1200,attr = [{1,1220},{2,24400},{3,610},{4,610}],combat = 36600,is_tv = 0};

get_figure_stage_cfg(4,6) ->
	#pet_figure_stage_cfg{id = 4,stage = 6,blessing = 1400,attr = [{1,1400},{2,28000},{3,700},{4,700}],combat = 42000,is_tv = 1};

get_figure_stage_cfg(4,7) ->
	#pet_figure_stage_cfg{id = 4,stage = 7,blessing = 1600,attr = [{1,1580},{2,31600},{3,790},{4,790}],combat = 47400,is_tv = 0};

get_figure_stage_cfg(4,8) ->
	#pet_figure_stage_cfg{id = 4,stage = 8,blessing = 1800,attr = [{1,1760},{2,35200},{3,880},{4,880}],combat = 52800,is_tv = 0};

get_figure_stage_cfg(4,9) ->
	#pet_figure_stage_cfg{id = 4,stage = 9,blessing = 2000,attr = [{1,1940},{2,38800},{3,970},{4,970}],combat = 58200,is_tv = 0};

get_figure_stage_cfg(4,10) ->
	#pet_figure_stage_cfg{id = 4,stage = 10,blessing = 0,attr = [{1,2120},{2,42400},{3,1060},{4,1060}],combat = 63600,is_tv = 1};

get_figure_stage_cfg(5,0) ->
	#pet_figure_stage_cfg{id = 5,stage = 0,blessing = 1,attr = [{1,0},{2,0},{3,0},{4,0}],combat = 0,is_tv = 0};

get_figure_stage_cfg(5,1) ->
	#pet_figure_stage_cfg{id = 5,stage = 1,blessing = 400,attr = [{1,1500},{2,30000},{3,750},{4,750}],combat = 45000,is_tv = 0};

get_figure_stage_cfg(5,2) ->
	#pet_figure_stage_cfg{id = 5,stage = 2,blessing = 600,attr = [{1,1680},{2,33600},{3,840},{4,840}],combat = 50400,is_tv = 0};

get_figure_stage_cfg(5,3) ->
	#pet_figure_stage_cfg{id = 5,stage = 3,blessing = 800,attr = [{1,1860},{2,37200},{3,930},{4,930}],combat = 55800,is_tv = 1};

get_figure_stage_cfg(5,4) ->
	#pet_figure_stage_cfg{id = 5,stage = 4,blessing = 1000,attr = [{1,2040},{2,40800},{3,1020},{4,1020}],combat = 61200,is_tv = 0};

get_figure_stage_cfg(5,5) ->
	#pet_figure_stage_cfg{id = 5,stage = 5,blessing = 1200,attr = [{1,2220},{2,44400},{3,1110},{4,1110}],combat = 66600,is_tv = 0};

get_figure_stage_cfg(5,6) ->
	#pet_figure_stage_cfg{id = 5,stage = 6,blessing = 1400,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],combat = 72000,is_tv = 1};

get_figure_stage_cfg(5,7) ->
	#pet_figure_stage_cfg{id = 5,stage = 7,blessing = 1600,attr = [{1,2580},{2,51600},{3,1290},{4,1290}],combat = 77400,is_tv = 0};

get_figure_stage_cfg(5,8) ->
	#pet_figure_stage_cfg{id = 5,stage = 8,blessing = 1800,attr = [{1,2760},{2,55200},{3,1380},{4,1380}],combat = 82800,is_tv = 0};

get_figure_stage_cfg(5,9) ->
	#pet_figure_stage_cfg{id = 5,stage = 9,blessing = 2000,attr = [{1,2940},{2,58800},{3,1470},{4,1470}],combat = 88200,is_tv = 0};

get_figure_stage_cfg(5,10) ->
	#pet_figure_stage_cfg{id = 5,stage = 10,blessing = 0,attr = [{1,3120},{2,62400},{3,1560},{4,1560}],combat = 93600,is_tv = 1};

get_figure_stage_cfg(_Id,_Stage) ->
	[].


get_constant_cfg(1) ->
18020001;


get_constant_cfg(2) ->
18020002;


get_constant_cfg(3) ->
5;


get_constant_cfg(4) ->
50;


get_constant_cfg(5) ->
18020001;


get_constant_cfg(6) ->
18020002;


get_constant_cfg(7) ->
5;


get_constant_cfg(8) ->
50;

get_constant_cfg(_Id) ->
	0.

