%%%---------------------------------------
%%% module      : data_holy_ghost
%%% description : 圣灵配置
%%%
%%%---------------------------------------
-module(data_holy_ghost).
-compile(export_all).
-include("holy_ghost.hrl").



get_cfg(_Key) ->
	[].

get_holy_ghost(1) ->
	#base_holy_ghost{id = 1,name = "众神之王",active_cost = [],stage_cost = [{48010001,5},{48010002,15},{48010003,50}],fight_skill = [{26000000,1}],trigger_type = 3,trigger_prob = 500,norm_skill = [{26000001,10},{26000002,25},{26000003,40},{26000004,60}],figure_id = 480001};

get_holy_ghost(_Id) ->
	[].

get_holy_ghost_illu(1) ->
	#base_holy_ghost_figure{id = 1,name = "生命女神",active_cost = [{0,48040001,1}],effect_time = 2592000,skill = [{26100000,1}],trigger_type = 4,trigger_prob = 500,attr = [{1,750},{2,15000},{3,375},{4,375},{40,1000}],figure_id = 481001};

get_holy_ghost_illu(_Id) ->
	[].

get_holy_ghost_stage(1,1) ->
	#base_holy_ghost_stage{id = 1,stage = 1,exp = 30,is_tv = 0,attr = [{1,115},{2,1700},{3,68},{4,32}]};

get_holy_ghost_stage(1,2) ->
	#base_holy_ghost_stage{id = 1,stage = 2,exp = 31,is_tv = 0,attr = [{1,151},{2,2420},{3,104},{4,68}]};

get_holy_ghost_stage(1,3) ->
	#base_holy_ghost_stage{id = 1,stage = 3,exp = 32,is_tv = 0,attr = [{1,187},{2,3140},{3,140},{4,104}]};

get_holy_ghost_stage(1,4) ->
	#base_holy_ghost_stage{id = 1,stage = 4,exp = 33,is_tv = 0,attr = [{1,223},{2,3860},{3,176},{4,140}]};

get_holy_ghost_stage(1,5) ->
	#base_holy_ghost_stage{id = 1,stage = 5,exp = 34,is_tv = 0,attr = [{1,259},{2,4580},{3,212},{4,176}]};

get_holy_ghost_stage(1,6) ->
	#base_holy_ghost_stage{id = 1,stage = 6,exp = 35,is_tv = 0,attr = [{1,295},{2,5300},{3,248},{4,212}]};

get_holy_ghost_stage(1,7) ->
	#base_holy_ghost_stage{id = 1,stage = 7,exp = 36,is_tv = 0,attr = [{1,331},{2,6020},{3,284},{4,248}]};

get_holy_ghost_stage(1,8) ->
	#base_holy_ghost_stage{id = 1,stage = 8,exp = 37,is_tv = 0,attr = [{1,367},{2,6740},{3,320},{4,284}]};

get_holy_ghost_stage(1,9) ->
	#base_holy_ghost_stage{id = 1,stage = 9,exp = 38,is_tv = 0,attr = [{1,403},{2,7460},{3,356},{4,320}]};

get_holy_ghost_stage(1,10) ->
	#base_holy_ghost_stage{id = 1,stage = 10,exp = 40,is_tv = 1,attr = [{1,439},{2,8180},{3,392},{4,356}]};

get_holy_ghost_stage(1,11) ->
	#base_holy_ghost_stage{id = 1,stage = 11,exp = 42,is_tv = 0,attr = [{1,475},{2,8900},{3,428},{4,392}]};

get_holy_ghost_stage(1,12) ->
	#base_holy_ghost_stage{id = 1,stage = 12,exp = 44,is_tv = 0,attr = [{1,511},{2,9620},{3,464},{4,428}]};

get_holy_ghost_stage(1,13) ->
	#base_holy_ghost_stage{id = 1,stage = 13,exp = 46,is_tv = 0,attr = [{1,547},{2,10340},{3,500},{4,464}]};

get_holy_ghost_stage(1,14) ->
	#base_holy_ghost_stage{id = 1,stage = 14,exp = 48,is_tv = 0,attr = [{1,583},{2,11060},{3,536},{4,500}]};

get_holy_ghost_stage(1,15) ->
	#base_holy_ghost_stage{id = 1,stage = 15,exp = 50,is_tv = 0,attr = [{1,619},{2,11780},{3,572},{4,536}]};

get_holy_ghost_stage(1,16) ->
	#base_holy_ghost_stage{id = 1,stage = 16,exp = 52,is_tv = 0,attr = [{1,655},{2,12500},{3,608},{4,572}]};

get_holy_ghost_stage(1,17) ->
	#base_holy_ghost_stage{id = 1,stage = 17,exp = 54,is_tv = 0,attr = [{1,691},{2,13220},{3,644},{4,608}]};

get_holy_ghost_stage(1,18) ->
	#base_holy_ghost_stage{id = 1,stage = 18,exp = 56,is_tv = 0,attr = [{1,727},{2,13940},{3,680},{4,644}]};

get_holy_ghost_stage(1,19) ->
	#base_holy_ghost_stage{id = 1,stage = 19,exp = 58,is_tv = 0,attr = [{1,763},{2,14660},{3,716},{4,680}]};

get_holy_ghost_stage(1,20) ->
	#base_holy_ghost_stage{id = 1,stage = 20,exp = 60,is_tv = 0,attr = [{1,799},{2,15380},{3,752},{4,716}]};

get_holy_ghost_stage(1,21) ->
	#base_holy_ghost_stage{id = 1,stage = 21,exp = 62,is_tv = 0,attr = [{1,835},{2,16100},{3,788},{4,752}]};

get_holy_ghost_stage(1,22) ->
	#base_holy_ghost_stage{id = 1,stage = 22,exp = 64,is_tv = 0,attr = [{1,871},{2,16820},{3,824},{4,788}]};

get_holy_ghost_stage(1,23) ->
	#base_holy_ghost_stage{id = 1,stage = 23,exp = 67,is_tv = 0,attr = [{1,907},{2,17540},{3,860},{4,824}]};

get_holy_ghost_stage(1,24) ->
	#base_holy_ghost_stage{id = 1,stage = 24,exp = 70,is_tv = 0,attr = [{1,943},{2,18260},{3,896},{4,860}]};

get_holy_ghost_stage(1,25) ->
	#base_holy_ghost_stage{id = 1,stage = 25,exp = 73,is_tv = 1,attr = [{1,979},{2,18980},{3,932},{4,896}]};

get_holy_ghost_stage(1,26) ->
	#base_holy_ghost_stage{id = 1,stage = 26,exp = 76,is_tv = 0,attr = [{1,1015},{2,19700},{3,968},{4,932}]};

get_holy_ghost_stage(1,27) ->
	#base_holy_ghost_stage{id = 1,stage = 27,exp = 79,is_tv = 0,attr = [{1,1051},{2,20420},{3,1004},{4,968}]};

get_holy_ghost_stage(1,28) ->
	#base_holy_ghost_stage{id = 1,stage = 28,exp = 82,is_tv = 0,attr = [{1,1087},{2,21140},{3,1040},{4,1004}]};

get_holy_ghost_stage(1,29) ->
	#base_holy_ghost_stage{id = 1,stage = 29,exp = 85,is_tv = 0,attr = [{1,1123},{2,21860},{3,1076},{4,1040}]};

get_holy_ghost_stage(1,30) ->
	#base_holy_ghost_stage{id = 1,stage = 30,exp = 88,is_tv = 0,attr = [{1,1159},{2,22580},{3,1112},{4,1076}]};

get_holy_ghost_stage(1,31) ->
	#base_holy_ghost_stage{id = 1,stage = 31,exp = 92,is_tv = 0,attr = [{1,1195},{2,23300},{3,1148},{4,1112}]};

get_holy_ghost_stage(1,32) ->
	#base_holy_ghost_stage{id = 1,stage = 32,exp = 96,is_tv = 0,attr = [{1,1231},{2,24020},{3,1184},{4,1148}]};

get_holy_ghost_stage(1,33) ->
	#base_holy_ghost_stage{id = 1,stage = 33,exp = 100,is_tv = 0,attr = [{1,1267},{2,24740},{3,1220},{4,1184}]};

get_holy_ghost_stage(1,34) ->
	#base_holy_ghost_stage{id = 1,stage = 34,exp = 104,is_tv = 0,attr = [{1,1303},{2,25460},{3,1256},{4,1220}]};

get_holy_ghost_stage(1,35) ->
	#base_holy_ghost_stage{id = 1,stage = 35,exp = 108,is_tv = 0,attr = [{1,1339},{2,26180},{3,1292},{4,1256}]};

get_holy_ghost_stage(1,36) ->
	#base_holy_ghost_stage{id = 1,stage = 36,exp = 112,is_tv = 0,attr = [{1,1375},{2,26900},{3,1328},{4,1292}]};

get_holy_ghost_stage(1,37) ->
	#base_holy_ghost_stage{id = 1,stage = 37,exp = 116,is_tv = 0,attr = [{1,1411},{2,27620},{3,1364},{4,1328}]};

get_holy_ghost_stage(1,38) ->
	#base_holy_ghost_stage{id = 1,stage = 38,exp = 121,is_tv = 0,attr = [{1,1447},{2,28340},{3,1400},{4,1364}]};

get_holy_ghost_stage(1,39) ->
	#base_holy_ghost_stage{id = 1,stage = 39,exp = 126,is_tv = 0,attr = [{1,1483},{2,29060},{3,1436},{4,1400}]};

get_holy_ghost_stage(1,40) ->
	#base_holy_ghost_stage{id = 1,stage = 40,exp = 131,is_tv = 1,attr = [{1,1519},{2,29780},{3,1472},{4,1436}]};

get_holy_ghost_stage(1,41) ->
	#base_holy_ghost_stage{id = 1,stage = 41,exp = 136,is_tv = 0,attr = [{1,1555},{2,30500},{3,1508},{4,1472}]};

get_holy_ghost_stage(1,42) ->
	#base_holy_ghost_stage{id = 1,stage = 42,exp = 141,is_tv = 0,attr = [{1,1591},{2,31220},{3,1544},{4,1508}]};

get_holy_ghost_stage(1,43) ->
	#base_holy_ghost_stage{id = 1,stage = 43,exp = 147,is_tv = 0,attr = [{1,1627},{2,31940},{3,1580},{4,1544}]};

get_holy_ghost_stage(1,44) ->
	#base_holy_ghost_stage{id = 1,stage = 44,exp = 153,is_tv = 0,attr = [{1,1663},{2,32660},{3,1616},{4,1580}]};

get_holy_ghost_stage(1,45) ->
	#base_holy_ghost_stage{id = 1,stage = 45,exp = 159,is_tv = 0,attr = [{1,1699},{2,33380},{3,1652},{4,1616}]};

get_holy_ghost_stage(1,46) ->
	#base_holy_ghost_stage{id = 1,stage = 46,exp = 165,is_tv = 0,attr = [{1,1735},{2,34100},{3,1688},{4,1652}]};

get_holy_ghost_stage(1,47) ->
	#base_holy_ghost_stage{id = 1,stage = 47,exp = 172,is_tv = 0,attr = [{1,1771},{2,34820},{3,1724},{4,1688}]};

get_holy_ghost_stage(1,48) ->
	#base_holy_ghost_stage{id = 1,stage = 48,exp = 179,is_tv = 0,attr = [{1,1807},{2,35540},{3,1760},{4,1724}]};

get_holy_ghost_stage(1,49) ->
	#base_holy_ghost_stage{id = 1,stage = 49,exp = 186,is_tv = 0,attr = [{1,1843},{2,36260},{3,1796},{4,1760}]};

get_holy_ghost_stage(1,50) ->
	#base_holy_ghost_stage{id = 1,stage = 50,exp = 193,is_tv = 0,attr = [{1,1879},{2,36980},{3,1832},{4,1796}]};

get_holy_ghost_stage(1,51) ->
	#base_holy_ghost_stage{id = 1,stage = 51,exp = 201,is_tv = 0,attr = [{1,1915},{2,37700},{3,1868},{4,1832}]};

get_holy_ghost_stage(1,52) ->
	#base_holy_ghost_stage{id = 1,stage = 52,exp = 209,is_tv = 0,attr = [{1,1951},{2,38420},{3,1904},{4,1868}]};

get_holy_ghost_stage(1,53) ->
	#base_holy_ghost_stage{id = 1,stage = 53,exp = 217,is_tv = 0,attr = [{1,1987},{2,39140},{3,1940},{4,1904}]};

get_holy_ghost_stage(1,54) ->
	#base_holy_ghost_stage{id = 1,stage = 54,exp = 226,is_tv = 0,attr = [{1,2023},{2,39860},{3,1976},{4,1940}]};

get_holy_ghost_stage(1,55) ->
	#base_holy_ghost_stage{id = 1,stage = 55,exp = 235,is_tv = 0,attr = [{1,2059},{2,40580},{3,2012},{4,1976}]};

get_holy_ghost_stage(1,56) ->
	#base_holy_ghost_stage{id = 1,stage = 56,exp = 244,is_tv = 0,attr = [{1,2095},{2,41300},{3,2048},{4,2012}]};

get_holy_ghost_stage(1,57) ->
	#base_holy_ghost_stage{id = 1,stage = 57,exp = 254,is_tv = 0,attr = [{1,2131},{2,42020},{3,2084},{4,2048}]};

get_holy_ghost_stage(1,58) ->
	#base_holy_ghost_stage{id = 1,stage = 58,exp = 264,is_tv = 0,attr = [{1,2167},{2,42740},{3,2120},{4,2084}]};

get_holy_ghost_stage(1,59) ->
	#base_holy_ghost_stage{id = 1,stage = 59,exp = 275,is_tv = 0,attr = [{1,2203},{2,43460},{3,2156},{4,2120}]};

get_holy_ghost_stage(1,60) ->
	#base_holy_ghost_stage{id = 1,stage = 60,exp = 286,is_tv = 1,attr = [{1,2239},{2,44180},{3,2192},{4,2156}]};

get_holy_ghost_stage(2,1) ->
	#base_holy_ghost_stage{id = 2,stage = 1,exp = 30,is_tv = 0,attr = [{1,115},{2,1700},{3,68},{4,32}]};

get_holy_ghost_stage(2,2) ->
	#base_holy_ghost_stage{id = 2,stage = 2,exp = 31,is_tv = 0,attr = [{1,151},{2,2420},{3,104},{4,68}]};

get_holy_ghost_stage(2,3) ->
	#base_holy_ghost_stage{id = 2,stage = 3,exp = 32,is_tv = 0,attr = [{1,187},{2,3140},{3,140},{4,104}]};

get_holy_ghost_stage(2,4) ->
	#base_holy_ghost_stage{id = 2,stage = 4,exp = 33,is_tv = 0,attr = [{1,223},{2,3860},{3,176},{4,140}]};

get_holy_ghost_stage(2,5) ->
	#base_holy_ghost_stage{id = 2,stage = 5,exp = 34,is_tv = 0,attr = [{1,259},{2,4580},{3,212},{4,176}]};

get_holy_ghost_stage(2,6) ->
	#base_holy_ghost_stage{id = 2,stage = 6,exp = 35,is_tv = 0,attr = [{1,295},{2,5300},{3,248},{4,212}]};

get_holy_ghost_stage(2,7) ->
	#base_holy_ghost_stage{id = 2,stage = 7,exp = 36,is_tv = 0,attr = [{1,331},{2,6020},{3,284},{4,248}]};

get_holy_ghost_stage(2,8) ->
	#base_holy_ghost_stage{id = 2,stage = 8,exp = 37,is_tv = 0,attr = [{1,367},{2,6740},{3,320},{4,284}]};

get_holy_ghost_stage(2,9) ->
	#base_holy_ghost_stage{id = 2,stage = 9,exp = 38,is_tv = 0,attr = [{1,403},{2,7460},{3,356},{4,320}]};

get_holy_ghost_stage(2,10) ->
	#base_holy_ghost_stage{id = 2,stage = 10,exp = 40,is_tv = 1,attr = [{1,439},{2,8180},{3,392},{4,356}]};

get_holy_ghost_stage(2,11) ->
	#base_holy_ghost_stage{id = 2,stage = 11,exp = 42,is_tv = 0,attr = [{1,475},{2,8900},{3,428},{4,392}]};

get_holy_ghost_stage(2,12) ->
	#base_holy_ghost_stage{id = 2,stage = 12,exp = 44,is_tv = 0,attr = [{1,511},{2,9620},{3,464},{4,428}]};

get_holy_ghost_stage(2,13) ->
	#base_holy_ghost_stage{id = 2,stage = 13,exp = 46,is_tv = 0,attr = [{1,547},{2,10340},{3,500},{4,464}]};

get_holy_ghost_stage(2,14) ->
	#base_holy_ghost_stage{id = 2,stage = 14,exp = 48,is_tv = 0,attr = [{1,583},{2,11060},{3,536},{4,500}]};

get_holy_ghost_stage(2,15) ->
	#base_holy_ghost_stage{id = 2,stage = 15,exp = 50,is_tv = 0,attr = [{1,619},{2,11780},{3,572},{4,536}]};

get_holy_ghost_stage(2,16) ->
	#base_holy_ghost_stage{id = 2,stage = 16,exp = 52,is_tv = 0,attr = [{1,655},{2,12500},{3,608},{4,572}]};

get_holy_ghost_stage(2,17) ->
	#base_holy_ghost_stage{id = 2,stage = 17,exp = 54,is_tv = 0,attr = [{1,691},{2,13220},{3,644},{4,608}]};

get_holy_ghost_stage(2,18) ->
	#base_holy_ghost_stage{id = 2,stage = 18,exp = 56,is_tv = 0,attr = [{1,727},{2,13940},{3,680},{4,644}]};

get_holy_ghost_stage(2,19) ->
	#base_holy_ghost_stage{id = 2,stage = 19,exp = 58,is_tv = 0,attr = [{1,763},{2,14660},{3,716},{4,680}]};

get_holy_ghost_stage(2,20) ->
	#base_holy_ghost_stage{id = 2,stage = 20,exp = 60,is_tv = 0,attr = [{1,799},{2,15380},{3,752},{4,716}]};

get_holy_ghost_stage(2,21) ->
	#base_holy_ghost_stage{id = 2,stage = 21,exp = 62,is_tv = 0,attr = [{1,835},{2,16100},{3,788},{4,752}]};

get_holy_ghost_stage(2,22) ->
	#base_holy_ghost_stage{id = 2,stage = 22,exp = 64,is_tv = 0,attr = [{1,871},{2,16820},{3,824},{4,788}]};

get_holy_ghost_stage(2,23) ->
	#base_holy_ghost_stage{id = 2,stage = 23,exp = 67,is_tv = 0,attr = [{1,907},{2,17540},{3,860},{4,824}]};

get_holy_ghost_stage(2,24) ->
	#base_holy_ghost_stage{id = 2,stage = 24,exp = 70,is_tv = 0,attr = [{1,943},{2,18260},{3,896},{4,860}]};

get_holy_ghost_stage(2,25) ->
	#base_holy_ghost_stage{id = 2,stage = 25,exp = 73,is_tv = 1,attr = [{1,979},{2,18980},{3,932},{4,896}]};

get_holy_ghost_stage(2,26) ->
	#base_holy_ghost_stage{id = 2,stage = 26,exp = 76,is_tv = 0,attr = [{1,1015},{2,19700},{3,968},{4,932}]};

get_holy_ghost_stage(2,27) ->
	#base_holy_ghost_stage{id = 2,stage = 27,exp = 79,is_tv = 0,attr = [{1,1051},{2,20420},{3,1004},{4,968}]};

get_holy_ghost_stage(2,28) ->
	#base_holy_ghost_stage{id = 2,stage = 28,exp = 82,is_tv = 0,attr = [{1,1087},{2,21140},{3,1040},{4,1004}]};

get_holy_ghost_stage(2,29) ->
	#base_holy_ghost_stage{id = 2,stage = 29,exp = 85,is_tv = 0,attr = [{1,1123},{2,21860},{3,1076},{4,1040}]};

get_holy_ghost_stage(2,30) ->
	#base_holy_ghost_stage{id = 2,stage = 30,exp = 88,is_tv = 0,attr = [{1,1159},{2,22580},{3,1112},{4,1076}]};

get_holy_ghost_stage(2,31) ->
	#base_holy_ghost_stage{id = 2,stage = 31,exp = 92,is_tv = 0,attr = [{1,1195},{2,23300},{3,1148},{4,1112}]};

get_holy_ghost_stage(2,32) ->
	#base_holy_ghost_stage{id = 2,stage = 32,exp = 96,is_tv = 0,attr = [{1,1231},{2,24020},{3,1184},{4,1148}]};

get_holy_ghost_stage(2,33) ->
	#base_holy_ghost_stage{id = 2,stage = 33,exp = 100,is_tv = 0,attr = [{1,1267},{2,24740},{3,1220},{4,1184}]};

get_holy_ghost_stage(2,34) ->
	#base_holy_ghost_stage{id = 2,stage = 34,exp = 104,is_tv = 0,attr = [{1,1303},{2,25460},{3,1256},{4,1220}]};

get_holy_ghost_stage(2,35) ->
	#base_holy_ghost_stage{id = 2,stage = 35,exp = 108,is_tv = 0,attr = [{1,1339},{2,26180},{3,1292},{4,1256}]};

get_holy_ghost_stage(2,36) ->
	#base_holy_ghost_stage{id = 2,stage = 36,exp = 112,is_tv = 0,attr = [{1,1375},{2,26900},{3,1328},{4,1292}]};

get_holy_ghost_stage(2,37) ->
	#base_holy_ghost_stage{id = 2,stage = 37,exp = 116,is_tv = 0,attr = [{1,1411},{2,27620},{3,1364},{4,1328}]};

get_holy_ghost_stage(2,38) ->
	#base_holy_ghost_stage{id = 2,stage = 38,exp = 121,is_tv = 0,attr = [{1,1447},{2,28340},{3,1400},{4,1364}]};

get_holy_ghost_stage(2,39) ->
	#base_holy_ghost_stage{id = 2,stage = 39,exp = 126,is_tv = 0,attr = [{1,1483},{2,29060},{3,1436},{4,1400}]};

get_holy_ghost_stage(2,40) ->
	#base_holy_ghost_stage{id = 2,stage = 40,exp = 131,is_tv = 1,attr = [{1,1519},{2,29780},{3,1472},{4,1436}]};

get_holy_ghost_stage(2,41) ->
	#base_holy_ghost_stage{id = 2,stage = 41,exp = 136,is_tv = 0,attr = [{1,1555},{2,30500},{3,1508},{4,1472}]};

get_holy_ghost_stage(2,42) ->
	#base_holy_ghost_stage{id = 2,stage = 42,exp = 141,is_tv = 0,attr = [{1,1591},{2,31220},{3,1544},{4,1508}]};

get_holy_ghost_stage(2,43) ->
	#base_holy_ghost_stage{id = 2,stage = 43,exp = 147,is_tv = 0,attr = [{1,1627},{2,31940},{3,1580},{4,1544}]};

get_holy_ghost_stage(2,44) ->
	#base_holy_ghost_stage{id = 2,stage = 44,exp = 153,is_tv = 0,attr = [{1,1663},{2,32660},{3,1616},{4,1580}]};

get_holy_ghost_stage(2,45) ->
	#base_holy_ghost_stage{id = 2,stage = 45,exp = 159,is_tv = 0,attr = [{1,1699},{2,33380},{3,1652},{4,1616}]};

get_holy_ghost_stage(2,46) ->
	#base_holy_ghost_stage{id = 2,stage = 46,exp = 165,is_tv = 0,attr = [{1,1735},{2,34100},{3,1688},{4,1652}]};

get_holy_ghost_stage(2,47) ->
	#base_holy_ghost_stage{id = 2,stage = 47,exp = 172,is_tv = 0,attr = [{1,1771},{2,34820},{3,1724},{4,1688}]};

get_holy_ghost_stage(2,48) ->
	#base_holy_ghost_stage{id = 2,stage = 48,exp = 179,is_tv = 0,attr = [{1,1807},{2,35540},{3,1760},{4,1724}]};

get_holy_ghost_stage(2,49) ->
	#base_holy_ghost_stage{id = 2,stage = 49,exp = 186,is_tv = 0,attr = [{1,1843},{2,36260},{3,1796},{4,1760}]};

get_holy_ghost_stage(2,50) ->
	#base_holy_ghost_stage{id = 2,stage = 50,exp = 193,is_tv = 0,attr = [{1,1879},{2,36980},{3,1832},{4,1796}]};

get_holy_ghost_stage(2,51) ->
	#base_holy_ghost_stage{id = 2,stage = 51,exp = 201,is_tv = 0,attr = [{1,1915},{2,37700},{3,1868},{4,1832}]};

get_holy_ghost_stage(2,52) ->
	#base_holy_ghost_stage{id = 2,stage = 52,exp = 209,is_tv = 0,attr = [{1,1951},{2,38420},{3,1904},{4,1868}]};

get_holy_ghost_stage(2,53) ->
	#base_holy_ghost_stage{id = 2,stage = 53,exp = 217,is_tv = 0,attr = [{1,1987},{2,39140},{3,1940},{4,1904}]};

get_holy_ghost_stage(2,54) ->
	#base_holy_ghost_stage{id = 2,stage = 54,exp = 226,is_tv = 0,attr = [{1,2023},{2,39860},{3,1976},{4,1940}]};

get_holy_ghost_stage(2,55) ->
	#base_holy_ghost_stage{id = 2,stage = 55,exp = 235,is_tv = 0,attr = [{1,2059},{2,40580},{3,2012},{4,1976}]};

get_holy_ghost_stage(2,56) ->
	#base_holy_ghost_stage{id = 2,stage = 56,exp = 244,is_tv = 0,attr = [{1,2095},{2,41300},{3,2048},{4,2012}]};

get_holy_ghost_stage(2,57) ->
	#base_holy_ghost_stage{id = 2,stage = 57,exp = 254,is_tv = 0,attr = [{1,2131},{2,42020},{3,2084},{4,2048}]};

get_holy_ghost_stage(2,58) ->
	#base_holy_ghost_stage{id = 2,stage = 58,exp = 264,is_tv = 0,attr = [{1,2167},{2,42740},{3,2120},{4,2084}]};

get_holy_ghost_stage(2,59) ->
	#base_holy_ghost_stage{id = 2,stage = 59,exp = 275,is_tv = 0,attr = [{1,2203},{2,43460},{3,2156},{4,2120}]};

get_holy_ghost_stage(2,60) ->
	#base_holy_ghost_stage{id = 2,stage = 60,exp = 286,is_tv = 1,attr = [{1,2239},{2,44180},{3,2192},{4,2156}]};

get_holy_ghost_stage(_Id,_Stage) ->
	[].

get_holy_ghost_awake(1,1) ->
	#base_holy_ghost_awake{id = 1,lv = 1,cost = [{0,48020001,1}],fight_skill_lv = [{26000000,2}],attr = [{41,50},{68,2500}]};

get_holy_ghost_awake(1,2) ->
	#base_holy_ghost_awake{id = 1,lv = 2,cost = [{0,48020001,2}],fight_skill_lv = [{26000000,3}],attr = [{41,100},{68,5000}]};

get_holy_ghost_awake(1,3) ->
	#base_holy_ghost_awake{id = 1,lv = 3,cost = [{0,48020001,4}],fight_skill_lv = [{26000000,4}],attr = [{41,150},{68,7500}]};

get_holy_ghost_awake(1,4) ->
	#base_holy_ghost_awake{id = 1,lv = 4,cost = [{0,48020001,8}],fight_skill_lv = [{26000000,5}],attr = [{41,200},{68,10000}]};

get_holy_ghost_awake(_Id,_Lv) ->
	[].

get_bound(1) ->
	#base_holy_ghost_bound{id = 1,attr = [{1,1500}],condition = [{1,3}]};

get_bound(_Id) ->
	[].

get_bound_ids() ->
[1].

get_bound_skill(1) ->
	#base_holy_ghost_bound_skill{id = 1,skill = [],condition = []};

get_bound_skill(_Id) ->
	[].

get_bound_skill_ids() ->
[1].

get_holy_ghost_relic(48030001) ->
	#base_holy_ghost_relic{good_id = 48030001,id = 1,attr = [{15,60},{16,60}],num_limit = [{1,9999,300}]};

get_holy_ghost_relic(48030002) ->
	#base_holy_ghost_relic{good_id = 48030002,id = 2,attr = [{1,90},{15,90}],num_limit = [{1,9999,300}]};

get_holy_ghost_relic(48030003) ->
	#base_holy_ghost_relic{good_id = 48030003,id = 3,attr = [{2,3000},{16,90},{20,50}],num_limit = [{1,9999,100}]};

get_holy_ghost_relic(_Goodid) ->
	[].

get_relic_good_ids() ->
[48030001,48030002,48030003].

get_relic_open(1) ->
	#base_holy_ghost_relic_open{id = 1,name = "冰霜遗迹",lv_limit = 300,figure_id = 4801001};

get_relic_open(2) ->
	#base_holy_ghost_relic_open{id = 2,name = "烈焰遗迹",lv_limit = 300,figure_id = 4801002};

get_relic_open(3) ->
	#base_holy_ghost_relic_open{id = 3,name = "神圣遗迹",lv_limit = 300,figure_id = 4801003};

get_relic_open(_Id) ->
	[].

get_relic_ids() ->
[1,2,3].

