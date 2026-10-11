%%%---------------------------------------
%%% module      : data_draconic
%%% description : 龙语配置
%%%
%%%---------------------------------------
-module(data_draconic).
-compile(export_all).
-include("draconic.hrl").




get_draconic_type(1) ->
[1];


get_draconic_type(2) ->
[1];


get_draconic_type(3) ->
[1];


get_draconic_type(4) ->
[1];


get_draconic_type(5) ->
[1];


get_draconic_type(6) ->
[1];


get_draconic_type(7) ->
[2];


get_draconic_type(8) ->
[2];


get_draconic_type(9) ->
[2];


get_draconic_type(10) ->
[2];


get_draconic_type(11) ->
[3];

get_draconic_type(_Id) ->
	[].

get_draconic_equip_info(7701301) ->
	#base_draconic_equip{id = 7701301,name = "莱亚之武",pos = 1,stage = 1,color = 3,strong = 100,base_attr = [{1,113},{7,90}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701302) ->
	#base_draconic_equip{id = 7701302,name = "西锋之武",pos = 1,stage = 2,color = 3,strong = 100,base_attr = [{1,188},{7,150}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701303) ->
	#base_draconic_equip{id = 7701303,name = "棘甲之武",pos = 1,stage = 3,color = 3,strong = 100,base_attr = [{1,281},{7,225}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701304) ->
	#base_draconic_equip{id = 7701304,name = "风漂之武",pos = 1,stage = 4,color = 3,strong = 100,base_attr = [{1,394},{7,315}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701305) ->
	#base_draconic_equip{id = 7701305,name = "异特之武",pos = 1,stage = 5,color = 3,strong = 100,base_attr = [{1,525},{7,420}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701306) ->
	#base_draconic_equip{id = 7701306,name = "迅猛之武",pos = 1,stage = 6,color = 3,strong = 100,base_attr = [{1,675},{7,540}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701307) ->
	#base_draconic_equip{id = 7701307,name = "冥噬之武",pos = 1,stage = 7,color = 3,strong = 100,base_attr = [{1,844},{7,675}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701308) ->
	#base_draconic_equip{id = 7701308,name = "荒海之武",pos = 1,stage = 8,color = 3,strong = 100,base_attr = [{1,1031},{7,825}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701309) ->
	#base_draconic_equip{id = 7701309,name = "暗鳞之武",pos = 1,stage = 9,color = 3,strong = 100,base_attr = [{1,1406},{7,1125}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701310) ->
	#base_draconic_equip{id = 7701310,name = "黑煌之武",pos = 1,stage = 10,color = 3,strong = 100,base_attr = [{1,1556},{7,1245}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701311) ->
	#base_draconic_equip{id = 7701311,name = "雷猎之武",pos = 1,stage = 11,color = 3,strong = 100,base_attr = [{1,2044},{7,1635}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701312) ->
	#base_draconic_equip{id = 7701312,name = "天辉之武",pos = 1,stage = 12,color = 3,strong = 100,base_attr = [{1,2269},{7,1815}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701313) ->
	#base_draconic_equip{id = 7701313,name = "苍穹之武",pos = 1,stage = 13,color = 3,strong = 100,base_attr = [{1,2831},{7,2265}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701314) ->
	#base_draconic_equip{id = 7701314,name = "绝翼之武",pos = 1,stage = 14,color = 3,strong = 100,base_attr = [{1,3056},{7,2445}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701315) ->
	#base_draconic_equip{id = 7701315,name = "恐暴之武",pos = 1,stage = 15,color = 3,strong = 100,base_attr = [{1,3750},{7,3000}],extra_attr = [],suit = 0};

get_draconic_equip_info(7701401) ->
	#base_draconic_equip{id = 7701401,name = "莱亚之武",pos = 1,stage = 1,color = 4,strong = 100,base_attr = [{1,188},{7,150}],extra_attr = [{22,2},{55,8},{51,30},{50,10}],suit = 4010};

get_draconic_equip_info(7701402) ->
	#base_draconic_equip{id = 7701402,name = "西锋之武",pos = 1,stage = 2,color = 4,strong = 100,base_attr = [{1,313},{7,250}],extra_attr = [{22,3},{55,13},{51,60},{50,20}],suit = 4020};

get_draconic_equip_info(7701403) ->
	#base_draconic_equip{id = 7701403,name = "棘甲之武",pos = 1,stage = 3,color = 4,strong = 100,base_attr = [{1,469},{7,375}],extra_attr = [{22,4},{55,19},{51,120},{50,40}],suit = 4030};

get_draconic_equip_info(7701404) ->
	#base_draconic_equip{id = 7701404,name = "风漂之武",pos = 1,stage = 4,color = 4,strong = 100,base_attr = [{1,656},{7,525}],extra_attr = [{22,5},{55,26},{51,240},{50,80}],suit = 4040};

get_draconic_equip_info(7701405) ->
	#base_draconic_equip{id = 7701405,name = "异特之武",pos = 1,stage = 5,color = 4,strong = 100,base_attr = [{1,875},{7,700}],extra_attr = [{22,7},{55,35},{51,300},{50,100}],suit = 4050};

get_draconic_equip_info(7701406) ->
	#base_draconic_equip{id = 7701406,name = "迅猛之武",pos = 1,stage = 6,color = 4,strong = 100,base_attr = [{1,1125},{7,900}],extra_attr = [{22,9},{55,45},{51,426},{50,142}],suit = 4060};

get_draconic_equip_info(7701407) ->
	#base_draconic_equip{id = 7701407,name = "冥噬之武",pos = 1,stage = 7,color = 4,strong = 100,base_attr = [{1,1406},{7,1125}],extra_attr = [{22,11},{55,56},{51,534},{50,178}],suit = 4070};

get_draconic_equip_info(7701408) ->
	#base_draconic_equip{id = 7701408,name = "荒海之武",pos = 1,stage = 8,color = 4,strong = 100,base_attr = [{1,1719},{7,1375}],extra_attr = [{22,14},{55,69},{51,660},{50,220}],suit = 4080};

get_draconic_equip_info(7701409) ->
	#base_draconic_equip{id = 7701409,name = "暗鳞之武",pos = 1,stage = 9,color = 4,strong = 100,base_attr = [{1,2344},{7,1875}],extra_attr = [{22,19},{55,94},{51,825},{50,275}],suit = 4090};

get_draconic_equip_info(7701410) ->
	#base_draconic_equip{id = 7701410,name = "黑煌之武",pos = 1,stage = 10,color = 4,strong = 100,base_attr = [{1,2594},{7,2075}],extra_attr = [{22,21},{55,104},{51,1050},{50,350}],suit = 4100};

get_draconic_equip_info(7701411) ->
	#base_draconic_equip{id = 7701411,name = "雷猎之武",pos = 1,stage = 11,color = 4,strong = 100,base_attr = [{1,3406},{7,2725}],extra_attr = [{22,27},{55,136},{51,1320},{50,440}],suit = 4110};

get_draconic_equip_info(7701412) ->
	#base_draconic_equip{id = 7701412,name = "天辉之武",pos = 1,stage = 12,color = 4,strong = 100,base_attr = [{1,3781},{7,3025}],extra_attr = [{22,30},{55,151},{51,1626},{50,542}],suit = 4120};

get_draconic_equip_info(7701413) ->
	#base_draconic_equip{id = 7701413,name = "苍穹之武",pos = 1,stage = 13,color = 4,strong = 100,base_attr = [{1,4719},{7,3775}],extra_attr = [{22,38},{55,189},{51,2034},{50,678}],suit = 4130};

get_draconic_equip_info(7701414) ->
	#base_draconic_equip{id = 7701414,name = "绝翼之武",pos = 1,stage = 14,color = 4,strong = 100,base_attr = [{1,5094},{7,4075}],extra_attr = [{22,41},{55,204},{51,2550},{50,850}],suit = 4140};

get_draconic_equip_info(7701415) ->
	#base_draconic_equip{id = 7701415,name = "恐暴之武",pos = 1,stage = 15,color = 4,strong = 100,base_attr = [{1,6250},{7,5000}],extra_attr = [{22,50},{55,250},{51,3180},{50,1060}],suit = 4150};

get_draconic_equip_info(7701503) ->
	#base_draconic_equip{id = 7701503,name = "异特之武",pos = 1,stage = 3,color = 5,strong = 100,base_attr = [{1,938},{7,750}],extra_attr = [{22,8},{55,38}],suit = 5000};

get_draconic_equip_info(7701505) ->
	#base_draconic_equip{id = 7701505,name = "异特之武",pos = 1,stage = 5,color = 5,strong = 100,base_attr = [{1,1750},{7,1400}],extra_attr = [{22,14},{55,70},{51,420},{50,140}],suit = 5010};

get_draconic_equip_info(7701506) ->
	#base_draconic_equip{id = 7701506,name = "迅猛之武",pos = 1,stage = 6,color = 5,strong = 100,base_attr = [{1,2250},{7,1800}],extra_attr = [{22,18},{55,90},{51,600},{50,200}],suit = 5020};

get_draconic_equip_info(7701507) ->
	#base_draconic_equip{id = 7701507,name = "冥噬之武",pos = 1,stage = 7,color = 5,strong = 100,base_attr = [{1,2813},{7,2250}],extra_attr = [{22,23},{55,113},{51,750},{50,250}],suit = 5030};

get_draconic_equip_info(7701508) ->
	#base_draconic_equip{id = 7701508,name = "荒海之武",pos = 1,stage = 8,color = 5,strong = 100,base_attr = [{1,3438},{7,2750}],extra_attr = [{22,28},{55,138},{51,930},{50,310}],suit = 5040};

get_draconic_equip_info(7701509) ->
	#base_draconic_equip{id = 7701509,name = "暗鳞之武",pos = 1,stage = 9,color = 5,strong = 100,base_attr = [{1,4688},{7,3750}],extra_attr = [{22,38},{55,188},{51,1170},{50,390}],suit = 5050};

get_draconic_equip_info(7701510) ->
	#base_draconic_equip{id = 7701510,name = "黑煌之武",pos = 1,stage = 10,color = 5,strong = 100,base_attr = [{1,5188},{7,4150}],extra_attr = [{22,42},{55,208},{51,1470},{50,490}],suit = 5060};

get_draconic_equip_info(7701511) ->
	#base_draconic_equip{id = 7701511,name = "雷猎之武",pos = 1,stage = 11,color = 5,strong = 100,base_attr = [{1,6813},{7,5450}],extra_attr = [{22,55},{55,273},{51,1830},{50,610}],suit = 5070};

get_draconic_equip_info(7701512) ->
	#base_draconic_equip{id = 7701512,name = "天辉之武",pos = 1,stage = 12,color = 5,strong = 100,base_attr = [{1,7563},{7,6050}],extra_attr = [{22,61},{55,303},{51,2280},{50,760}],suit = 5080};

get_draconic_equip_info(7701513) ->
	#base_draconic_equip{id = 7701513,name = "苍穹之武",pos = 1,stage = 13,color = 5,strong = 100,base_attr = [{1,9438},{7,7550}],extra_attr = [{22,76},{55,378},{51,2850},{50,950}],suit = 5090};

get_draconic_equip_info(7701514) ->
	#base_draconic_equip{id = 7701514,name = "绝翼之武",pos = 1,stage = 14,color = 5,strong = 100,base_attr = [{1,10188},{7,8150}],extra_attr = [{22,82},{55,408},{51,3570},{50,1190}],suit = 5100};

get_draconic_equip_info(7701515) ->
	#base_draconic_equip{id = 7701515,name = "恐暴之武",pos = 1,stage = 15,color = 5,strong = 100,base_attr = [{1,12500},{7,10000}],extra_attr = [{22,100},{55,500},{51,4470},{50,1490}],suit = 5110};

get_draconic_equip_info(7701609) ->
	#base_draconic_equip{id = 7701609,name = "暗鳞之武",pos = 1,stage = 9,color = 6,strong = 100,base_attr = [{1,9375},{7,7500}],extra_attr = [{22,75},{55,375},{51,1830},{50,610}],suit = 6010};

get_draconic_equip_info(7701610) ->
	#base_draconic_equip{id = 7701610,name = "黑煌之武",pos = 1,stage = 10,color = 6,strong = 100,base_attr = [{1,10375},{7,8300}],extra_attr = [{22,83},{55,415},{51,2280},{50,760}],suit = 6020};

get_draconic_equip_info(7701611) ->
	#base_draconic_equip{id = 7701611,name = "雷猎之武",pos = 1,stage = 11,color = 6,strong = 100,base_attr = [{1,13625},{7,10900}],extra_attr = [{22,109},{55,545},{51,2850},{50,950}],suit = 6030};

get_draconic_equip_info(7701612) ->
	#base_draconic_equip{id = 7701612,name = "天辉之武",pos = 1,stage = 12,color = 6,strong = 100,base_attr = [{1,15125},{7,12100}],extra_attr = [{22,121},{55,605},{51,3570},{50,1190}],suit = 6040};

get_draconic_equip_info(7701613) ->
	#base_draconic_equip{id = 7701613,name = "苍穹之武",pos = 1,stage = 13,color = 6,strong = 100,base_attr = [{1,18875},{7,15100}],extra_attr = [{22,151},{55,755},{51,4470},{50,1490}],suit = 6050};

get_draconic_equip_info(7701614) ->
	#base_draconic_equip{id = 7701614,name = "绝翼之武",pos = 1,stage = 14,color = 6,strong = 100,base_attr = [{1,20375},{7,16300}],extra_attr = [{22,163},{55,815},{51,5580},{50,1860}],suit = 6060};

get_draconic_equip_info(7701615) ->
	#base_draconic_equip{id = 7701615,name = "恐暴之武",pos = 1,stage = 15,color = 6,strong = 100,base_attr = [{1,25000},{7,20000}],extra_attr = [{22,200},{55,1000},{51,6990},{50,2330}],suit = 6070};

get_draconic_equip_info(7702301) ->
	#base_draconic_equip{id = 7702301,name = "莱亚之甲",pos = 2,stage = 1,color = 3,strong = 100,base_attr = [{2,2250},{6,72}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702302) ->
	#base_draconic_equip{id = 7702302,name = "西锋之甲",pos = 2,stage = 2,color = 3,strong = 100,base_attr = [{2,3750},{6,120}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702303) ->
	#base_draconic_equip{id = 7702303,name = "棘甲之甲",pos = 2,stage = 3,color = 3,strong = 100,base_attr = [{2,5625},{6,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702304) ->
	#base_draconic_equip{id = 7702304,name = "风漂之甲",pos = 2,stage = 4,color = 3,strong = 100,base_attr = [{2,7875},{6,252}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702305) ->
	#base_draconic_equip{id = 7702305,name = "异特之甲",pos = 2,stage = 5,color = 3,strong = 100,base_attr = [{2,10500},{6,336}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702306) ->
	#base_draconic_equip{id = 7702306,name = "迅猛之甲",pos = 2,stage = 6,color = 3,strong = 100,base_attr = [{2,13500},{6,432}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702307) ->
	#base_draconic_equip{id = 7702307,name = "冥噬之甲",pos = 2,stage = 7,color = 3,strong = 100,base_attr = [{2,16875},{6,540}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702308) ->
	#base_draconic_equip{id = 7702308,name = "荒海之甲",pos = 2,stage = 8,color = 3,strong = 100,base_attr = [{2,20625},{6,660}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702309) ->
	#base_draconic_equip{id = 7702309,name = "暗鳞之甲",pos = 2,stage = 9,color = 3,strong = 100,base_attr = [{2,28125},{6,900}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702310) ->
	#base_draconic_equip{id = 7702310,name = "黑煌之甲",pos = 2,stage = 10,color = 3,strong = 100,base_attr = [{2,31125},{6,996}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702311) ->
	#base_draconic_equip{id = 7702311,name = "雷猎之甲",pos = 2,stage = 11,color = 3,strong = 100,base_attr = [{2,40875},{6,1308}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702312) ->
	#base_draconic_equip{id = 7702312,name = "天辉之甲",pos = 2,stage = 12,color = 3,strong = 100,base_attr = [{2,45375},{6,1452}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702313) ->
	#base_draconic_equip{id = 7702313,name = "苍穹之甲",pos = 2,stage = 13,color = 3,strong = 100,base_attr = [{2,56625},{6,1812}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702314) ->
	#base_draconic_equip{id = 7702314,name = "绝翼之甲",pos = 2,stage = 14,color = 3,strong = 100,base_attr = [{2,61125},{6,1956}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702315) ->
	#base_draconic_equip{id = 7702315,name = "恐暴之甲",pos = 2,stage = 15,color = 3,strong = 100,base_attr = [{2,75000},{6,2400}],extra_attr = [],suit = 0};

get_draconic_equip_info(7702401) ->
	#base_draconic_equip{id = 7702401,name = "莱亚之甲",pos = 2,stage = 1,color = 4,strong = 100,base_attr = [{2,3750},{6,120}],extra_attr = [{20,1},{44,15},{50,30},{51,10}],suit = 4010};

get_draconic_equip_info(7702402) ->
	#base_draconic_equip{id = 7702402,name = "西锋之甲",pos = 2,stage = 2,color = 4,strong = 100,base_attr = [{2,6250},{6,200}],extra_attr = [{20,2},{44,25},{50,60},{51,20}],suit = 4020};

get_draconic_equip_info(7702403) ->
	#base_draconic_equip{id = 7702403,name = "棘甲之甲",pos = 2,stage = 3,color = 4,strong = 100,base_attr = [{2,9375},{6,300}],extra_attr = [{20,2},{44,38},{50,120},{51,40}],suit = 4030};

get_draconic_equip_info(7702404) ->
	#base_draconic_equip{id = 7702404,name = "风漂之甲",pos = 2,stage = 4,color = 4,strong = 100,base_attr = [{2,13125},{6,420}],extra_attr = [{20,3},{44,53},{50,240},{51,80}],suit = 4040};

get_draconic_equip_info(7702405) ->
	#base_draconic_equip{id = 7702405,name = "异特之甲",pos = 2,stage = 5,color = 4,strong = 100,base_attr = [{2,17500},{6,560}],extra_attr = [{20,4},{44,70},{50,300},{51,100}],suit = 4050};

get_draconic_equip_info(7702406) ->
	#base_draconic_equip{id = 7702406,name = "迅猛之甲",pos = 2,stage = 6,color = 4,strong = 100,base_attr = [{2,22500},{6,720}],extra_attr = [{20,6},{44,90},{50,426},{51,142}],suit = 4060};

get_draconic_equip_info(7702407) ->
	#base_draconic_equip{id = 7702407,name = "冥噬之甲",pos = 2,stage = 7,color = 4,strong = 100,base_attr = [{2,28125},{6,900}],extra_attr = [{20,7},{44,113},{50,534},{51,178}],suit = 4070};

get_draconic_equip_info(7702408) ->
	#base_draconic_equip{id = 7702408,name = "荒海之甲",pos = 2,stage = 8,color = 4,strong = 100,base_attr = [{2,34375},{6,1100}],extra_attr = [{20,8},{44,138},{50,660},{51,220}],suit = 4080};

get_draconic_equip_info(7702409) ->
	#base_draconic_equip{id = 7702409,name = "暗鳞之甲",pos = 2,stage = 9,color = 4,strong = 100,base_attr = [{2,46875},{6,1500}],extra_attr = [{20,11},{44,188},{50,825},{51,275}],suit = 4090};

get_draconic_equip_info(7702410) ->
	#base_draconic_equip{id = 7702410,name = "黑煌之甲",pos = 2,stage = 10,color = 4,strong = 100,base_attr = [{2,51875},{6,1660}],extra_attr = [{20,13},{44,208},{50,1050},{51,350}],suit = 4100};

get_draconic_equip_info(7702411) ->
	#base_draconic_equip{id = 7702411,name = "雷猎之甲",pos = 2,stage = 11,color = 4,strong = 100,base_attr = [{2,68125},{6,2180}],extra_attr = [{20,16},{44,273},{50,1320},{51,440}],suit = 4110};

get_draconic_equip_info(7702412) ->
	#base_draconic_equip{id = 7702412,name = "天辉之甲",pos = 2,stage = 12,color = 4,strong = 100,base_attr = [{2,75625},{6,2420}],extra_attr = [{20,18},{44,303},{50,1626},{51,542}],suit = 4120};

get_draconic_equip_info(7702413) ->
	#base_draconic_equip{id = 7702413,name = "苍穹之甲",pos = 2,stage = 13,color = 4,strong = 100,base_attr = [{2,94375},{6,3020}],extra_attr = [{20,23},{44,378},{50,2034},{51,678}],suit = 4130};

get_draconic_equip_info(7702414) ->
	#base_draconic_equip{id = 7702414,name = "绝翼之甲",pos = 2,stage = 14,color = 4,strong = 100,base_attr = [{2,101875},{6,3260}],extra_attr = [{20,25},{44,408},{50,2550},{51,850}],suit = 4140};

get_draconic_equip_info(7702415) ->
	#base_draconic_equip{id = 7702415,name = "恐暴之甲",pos = 2,stage = 15,color = 4,strong = 100,base_attr = [{2,125000},{6,4000}],extra_attr = [{20,30},{44,500},{50,3180},{51,1060}],suit = 4150};

get_draconic_equip_info(7702503) ->
	#base_draconic_equip{id = 7702503,name = "异特之甲",pos = 2,stage = 3,color = 5,strong = 100,base_attr = [{2,18750},{6,600}],extra_attr = [{20,5},{44,75}],suit = 5000};

get_draconic_equip_info(7702505) ->
	#base_draconic_equip{id = 7702505,name = "异特之甲",pos = 2,stage = 5,color = 5,strong = 100,base_attr = [{2,35000},{6,1120}],extra_attr = [{20,9},{44,140},{50,420},{51,140}],suit = 5010};

get_draconic_equip_info(7702506) ->
	#base_draconic_equip{id = 7702506,name = "迅猛之甲",pos = 2,stage = 6,color = 5,strong = 100,base_attr = [{2,45000},{6,1440}],extra_attr = [{20,11},{44,180},{50,600},{51,200}],suit = 5020};

get_draconic_equip_info(7702507) ->
	#base_draconic_equip{id = 7702507,name = "冥噬之甲",pos = 2,stage = 7,color = 5,strong = 100,base_attr = [{2,56250},{6,1800}],extra_attr = [{20,14},{44,225},{50,750},{51,250}],suit = 5030};

get_draconic_equip_info(7702508) ->
	#base_draconic_equip{id = 7702508,name = "荒海之甲",pos = 2,stage = 8,color = 5,strong = 100,base_attr = [{2,68750},{6,2200}],extra_attr = [{20,17},{44,275},{50,930},{51,310}],suit = 5040};

get_draconic_equip_info(7702509) ->
	#base_draconic_equip{id = 7702509,name = "暗鳞之甲",pos = 2,stage = 9,color = 5,strong = 100,base_attr = [{2,93750},{6,3000}],extra_attr = [{20,23},{44,375},{50,1170},{51,390}],suit = 5050};

get_draconic_equip_info(7702510) ->
	#base_draconic_equip{id = 7702510,name = "黑煌之甲",pos = 2,stage = 10,color = 5,strong = 100,base_attr = [{2,103750},{6,3320}],extra_attr = [{20,25},{44,415},{50,1470},{51,490}],suit = 5060};

get_draconic_equip_info(7702511) ->
	#base_draconic_equip{id = 7702511,name = "雷猎之甲",pos = 2,stage = 11,color = 5,strong = 100,base_attr = [{2,136250},{6,4360}],extra_attr = [{20,33},{44,545},{50,1830},{51,610}],suit = 5070};

get_draconic_equip_info(7702512) ->
	#base_draconic_equip{id = 7702512,name = "天辉之甲",pos = 2,stage = 12,color = 5,strong = 100,base_attr = [{2,151250},{6,4840}],extra_attr = [{20,37},{44,605},{50,2280},{51,760}],suit = 5080};

get_draconic_equip_info(7702513) ->
	#base_draconic_equip{id = 7702513,name = "苍穹之甲",pos = 2,stage = 13,color = 5,strong = 100,base_attr = [{2,188750},{6,6040}],extra_attr = [{20,46},{44,755},{50,2850},{51,950}],suit = 5090};

get_draconic_equip_info(7702514) ->
	#base_draconic_equip{id = 7702514,name = "绝翼之甲",pos = 2,stage = 14,color = 5,strong = 100,base_attr = [{2,203750},{6,6520}],extra_attr = [{20,49},{44,815},{50,3570},{51,1190}],suit = 5100};

get_draconic_equip_info(7702515) ->
	#base_draconic_equip{id = 7702515,name = "恐暴之甲",pos = 2,stage = 15,color = 5,strong = 100,base_attr = [{2,250000},{6,8000}],extra_attr = [{20,60},{44,1000},{50,4470},{51,1490}],suit = 5110};

get_draconic_equip_info(7702609) ->
	#base_draconic_equip{id = 7702609,name = "暗鳞之甲",pos = 2,stage = 9,color = 6,strong = 100,base_attr = [{2,187500},{6,6000}],extra_attr = [{20,45},{44,750},{50,1830},{51,610}],suit = 6010};

get_draconic_equip_info(7702610) ->
	#base_draconic_equip{id = 7702610,name = "黑煌之甲",pos = 2,stage = 10,color = 6,strong = 100,base_attr = [{2,207500},{6,6640}],extra_attr = [{20,50},{44,830},{50,2280},{51,760}],suit = 6020};

get_draconic_equip_info(7702611) ->
	#base_draconic_equip{id = 7702611,name = "雷猎之甲",pos = 2,stage = 11,color = 6,strong = 100,base_attr = [{2,272500},{6,8720}],extra_attr = [{20,65},{44,1090},{50,2850},{51,950}],suit = 6030};

get_draconic_equip_info(7702612) ->
	#base_draconic_equip{id = 7702612,name = "天辉之甲",pos = 2,stage = 12,color = 6,strong = 100,base_attr = [{2,302500},{6,9680}],extra_attr = [{20,73},{44,1210},{50,3570},{51,1190}],suit = 6040};

get_draconic_equip_info(7702613) ->
	#base_draconic_equip{id = 7702613,name = "苍穹之甲",pos = 2,stage = 13,color = 6,strong = 100,base_attr = [{2,377500},{6,12080}],extra_attr = [{20,91},{44,1510},{50,4470},{51,1490}],suit = 6050};

get_draconic_equip_info(7702614) ->
	#base_draconic_equip{id = 7702614,name = "绝翼之甲",pos = 2,stage = 14,color = 6,strong = 100,base_attr = [{2,407500},{6,13040}],extra_attr = [{20,98},{44,1630},{50,5580},{51,1860}],suit = 6060};

get_draconic_equip_info(7702615) ->
	#base_draconic_equip{id = 7702615,name = "恐暴之甲",pos = 2,stage = 15,color = 6,strong = 100,base_attr = [{2,500000},{6,16000}],extra_attr = [{20,120},{44,2000},{50,6990},{51,2330}],suit = 6070};

get_draconic_equip_info(7703301) ->
	#base_draconic_equip{id = 7703301,name = "莱亚之腿",pos = 3,stage = 1,color = 3,strong = 100,base_attr = [{2,1800},{4,45}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703302) ->
	#base_draconic_equip{id = 7703302,name = "西锋之腿",pos = 3,stage = 2,color = 3,strong = 100,base_attr = [{2,3000},{4,75}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703303) ->
	#base_draconic_equip{id = 7703303,name = "棘甲之腿",pos = 3,stage = 3,color = 3,strong = 100,base_attr = [{2,4500},{4,113}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703304) ->
	#base_draconic_equip{id = 7703304,name = "风漂之腿",pos = 3,stage = 4,color = 3,strong = 100,base_attr = [{2,6300},{4,158}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703305) ->
	#base_draconic_equip{id = 7703305,name = "异特之腿",pos = 3,stage = 5,color = 3,strong = 100,base_attr = [{2,8400},{4,210}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703306) ->
	#base_draconic_equip{id = 7703306,name = "迅猛之腿",pos = 3,stage = 6,color = 3,strong = 100,base_attr = [{2,10800},{4,270}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703307) ->
	#base_draconic_equip{id = 7703307,name = "冥噬之腿",pos = 3,stage = 7,color = 3,strong = 100,base_attr = [{2,13500},{4,338}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703308) ->
	#base_draconic_equip{id = 7703308,name = "荒海之腿",pos = 3,stage = 8,color = 3,strong = 100,base_attr = [{2,16500},{4,413}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703309) ->
	#base_draconic_equip{id = 7703309,name = "暗鳞之腿",pos = 3,stage = 9,color = 3,strong = 100,base_attr = [{2,22500},{4,563}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703310) ->
	#base_draconic_equip{id = 7703310,name = "黑煌之腿",pos = 3,stage = 10,color = 3,strong = 100,base_attr = [{2,24900},{4,623}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703311) ->
	#base_draconic_equip{id = 7703311,name = "雷猎之腿",pos = 3,stage = 11,color = 3,strong = 100,base_attr = [{2,32700},{4,818}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703312) ->
	#base_draconic_equip{id = 7703312,name = "天辉之腿",pos = 3,stage = 12,color = 3,strong = 100,base_attr = [{2,36300},{4,908}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703313) ->
	#base_draconic_equip{id = 7703313,name = "苍穹之腿",pos = 3,stage = 13,color = 3,strong = 100,base_attr = [{2,45300},{4,1133}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703314) ->
	#base_draconic_equip{id = 7703314,name = "绝翼之腿",pos = 3,stage = 14,color = 3,strong = 100,base_attr = [{2,48900},{4,1223}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703315) ->
	#base_draconic_equip{id = 7703315,name = "恐暴之腿",pos = 3,stage = 15,color = 3,strong = 100,base_attr = [{2,60000},{4,1500}],extra_attr = [],suit = 0};

get_draconic_equip_info(7703401) ->
	#base_draconic_equip{id = 7703401,name = "莱亚之腿",pos = 3,stage = 1,color = 4,strong = 100,base_attr = [{2,3000},{4,75}],extra_attr = [{22,2},{39,3},{50,20}],suit = 4010};

get_draconic_equip_info(7703402) ->
	#base_draconic_equip{id = 7703402,name = "西锋之腿",pos = 3,stage = 2,color = 4,strong = 100,base_attr = [{2,5000},{4,125}],extra_attr = [{22,3},{39,5},{50,40}],suit = 4020};

get_draconic_equip_info(7703403) ->
	#base_draconic_equip{id = 7703403,name = "棘甲之腿",pos = 3,stage = 3,color = 4,strong = 100,base_attr = [{2,7500},{4,188}],extra_attr = [{22,4},{39,8},{50,80}],suit = 4030};

get_draconic_equip_info(7703404) ->
	#base_draconic_equip{id = 7703404,name = "风漂之腿",pos = 3,stage = 4,color = 4,strong = 100,base_attr = [{2,10500},{4,263}],extra_attr = [{22,6},{39,11},{50,160}],suit = 4040};

get_draconic_equip_info(7703405) ->
	#base_draconic_equip{id = 7703405,name = "异特之腿",pos = 3,stage = 5,color = 4,strong = 100,base_attr = [{2,14000},{4,350}],extra_attr = [{22,8},{39,14},{50,200}],suit = 4050};

get_draconic_equip_info(7703406) ->
	#base_draconic_equip{id = 7703406,name = "迅猛之腿",pos = 3,stage = 6,color = 4,strong = 100,base_attr = [{2,18000},{4,450}],extra_attr = [{22,10},{39,18},{50,284}],suit = 4060};

get_draconic_equip_info(7703407) ->
	#base_draconic_equip{id = 7703407,name = "冥噬之腿",pos = 3,stage = 7,color = 4,strong = 100,base_attr = [{2,22500},{4,563}],extra_attr = [{22,13},{39,23},{50,356}],suit = 4070};

get_draconic_equip_info(7703408) ->
	#base_draconic_equip{id = 7703408,name = "荒海之腿",pos = 3,stage = 8,color = 4,strong = 100,base_attr = [{2,27500},{4,688}],extra_attr = [{22,15},{39,28},{50,440}],suit = 4080};

get_draconic_equip_info(7703409) ->
	#base_draconic_equip{id = 7703409,name = "暗鳞之腿",pos = 3,stage = 9,color = 4,strong = 100,base_attr = [{2,37500},{4,938}],extra_attr = [{22,21},{39,38},{50,550}],suit = 4090};

get_draconic_equip_info(7703410) ->
	#base_draconic_equip{id = 7703410,name = "黑煌之腿",pos = 3,stage = 10,color = 4,strong = 100,base_attr = [{2,41500},{4,1038}],extra_attr = [{22,23},{39,42},{50,700}],suit = 4100};

get_draconic_equip_info(7703411) ->
	#base_draconic_equip{id = 7703411,name = "雷猎之腿",pos = 3,stage = 11,color = 4,strong = 100,base_attr = [{2,54500},{4,1363}],extra_attr = [{22,30},{39,55},{50,880}],suit = 4110};

get_draconic_equip_info(7703412) ->
	#base_draconic_equip{id = 7703412,name = "天辉之腿",pos = 3,stage = 12,color = 4,strong = 100,base_attr = [{2,60500},{4,1513}],extra_attr = [{22,33},{39,61},{50,1084}],suit = 4120};

get_draconic_equip_info(7703413) ->
	#base_draconic_equip{id = 7703413,name = "苍穹之腿",pos = 3,stage = 13,color = 4,strong = 100,base_attr = [{2,75500},{4,1888}],extra_attr = [{22,42},{39,76},{50,1356}],suit = 4130};

get_draconic_equip_info(7703414) ->
	#base_draconic_equip{id = 7703414,name = "绝翼之腿",pos = 3,stage = 14,color = 4,strong = 100,base_attr = [{2,81500},{4,2038}],extra_attr = [{22,45},{39,82},{50,1700}],suit = 4140};

get_draconic_equip_info(7703415) ->
	#base_draconic_equip{id = 7703415,name = "恐暴之腿",pos = 3,stage = 15,color = 4,strong = 100,base_attr = [{2,100000},{4,2500}],extra_attr = [{22,55},{39,100},{50,2120}],suit = 4150};

get_draconic_equip_info(7703503) ->
	#base_draconic_equip{id = 7703503,name = "异特之腿",pos = 3,stage = 3,color = 5,strong = 100,base_attr = [{2,15000},{4,375}],extra_attr = [{22,9},{39,15}],suit = 5000};

get_draconic_equip_info(7703505) ->
	#base_draconic_equip{id = 7703505,name = "异特之腿",pos = 3,stage = 5,color = 5,strong = 100,base_attr = [{2,28000},{4,700}],extra_attr = [{22,16},{39,28},{50,280},{52,350}],suit = 5010};

get_draconic_equip_info(7703506) ->
	#base_draconic_equip{id = 7703506,name = "迅猛之腿",pos = 3,stage = 6,color = 5,strong = 100,base_attr = [{2,36000},{4,900}],extra_attr = [{22,20},{39,36},{50,400},{52,500}],suit = 5020};

get_draconic_equip_info(7703507) ->
	#base_draconic_equip{id = 7703507,name = "冥噬之腿",pos = 3,stage = 7,color = 5,strong = 100,base_attr = [{2,45000},{4,1125}],extra_attr = [{22,25},{39,45},{50,500},{52,625}],suit = 5030};

get_draconic_equip_info(7703508) ->
	#base_draconic_equip{id = 7703508,name = "荒海之腿",pos = 3,stage = 8,color = 5,strong = 100,base_attr = [{2,55000},{4,1375}],extra_attr = [{22,31},{39,55},{50,620},{52,775}],suit = 5040};

get_draconic_equip_info(7703509) ->
	#base_draconic_equip{id = 7703509,name = "暗鳞之腿",pos = 3,stage = 9,color = 5,strong = 100,base_attr = [{2,75000},{4,1875}],extra_attr = [{22,42},{39,75},{50,780},{52,975}],suit = 5050};

get_draconic_equip_info(7703510) ->
	#base_draconic_equip{id = 7703510,name = "黑煌之腿",pos = 3,stage = 10,color = 5,strong = 100,base_attr = [{2,83000},{4,2075}],extra_attr = [{22,46},{39,83},{50,980},{52,1225}],suit = 5060};

get_draconic_equip_info(7703511) ->
	#base_draconic_equip{id = 7703511,name = "雷猎之腿",pos = 3,stage = 11,color = 5,strong = 100,base_attr = [{2,109000},{4,2725}],extra_attr = [{22,60},{39,109},{50,1220},{52,1525}],suit = 5070};

get_draconic_equip_info(7703512) ->
	#base_draconic_equip{id = 7703512,name = "天辉之腿",pos = 3,stage = 12,color = 5,strong = 100,base_attr = [{2,121000},{4,3025}],extra_attr = [{22,67},{39,121},{50,1520},{52,1900}],suit = 5080};

get_draconic_equip_info(7703513) ->
	#base_draconic_equip{id = 7703513,name = "苍穹之腿",pos = 3,stage = 13,color = 5,strong = 100,base_attr = [{2,151000},{4,3775}],extra_attr = [{22,83},{39,151},{50,1900},{52,2375}],suit = 5090};

get_draconic_equip_info(7703514) ->
	#base_draconic_equip{id = 7703514,name = "绝翼之腿",pos = 3,stage = 14,color = 5,strong = 100,base_attr = [{2,163000},{4,4075}],extra_attr = [{22,90},{39,163},{50,2380},{52,2975}],suit = 5100};

get_draconic_equip_info(7703515) ->
	#base_draconic_equip{id = 7703515,name = "恐暴之腿",pos = 3,stage = 15,color = 5,strong = 100,base_attr = [{2,200000},{4,5000}],extra_attr = [{22,110},{39,200},{50,2980},{52,3725}],suit = 5110};

get_draconic_equip_info(7703609) ->
	#base_draconic_equip{id = 7703609,name = "暗鳞之腿",pos = 3,stage = 9,color = 6,strong = 100,base_attr = [{2,150000},{4,3750}],extra_attr = [{22,83},{39,150},{50,1220},{52,1525}],suit = 6010};

get_draconic_equip_info(7703610) ->
	#base_draconic_equip{id = 7703610,name = "黑煌之腿",pos = 3,stage = 10,color = 6,strong = 100,base_attr = [{2,166000},{4,4150}],extra_attr = [{22,91},{39,166},{50,1520},{52,1900}],suit = 6020};

get_draconic_equip_info(7703611) ->
	#base_draconic_equip{id = 7703611,name = "雷猎之腿",pos = 3,stage = 11,color = 6,strong = 100,base_attr = [{2,218000},{4,5450}],extra_attr = [{22,120},{39,218},{50,1900},{52,2375}],suit = 6030};

get_draconic_equip_info(7703612) ->
	#base_draconic_equip{id = 7703612,name = "天辉之腿",pos = 3,stage = 12,color = 6,strong = 100,base_attr = [{2,242000},{4,6050}],extra_attr = [{22,133},{39,242},{50,2380},{52,2975}],suit = 6040};

get_draconic_equip_info(7703613) ->
	#base_draconic_equip{id = 7703613,name = "苍穹之腿",pos = 3,stage = 13,color = 6,strong = 100,base_attr = [{2,302000},{4,7550}],extra_attr = [{22,166},{39,302},{50,2980},{52,3725}],suit = 6050};

get_draconic_equip_info(7703614) ->
	#base_draconic_equip{id = 7703614,name = "绝翼之腿",pos = 3,stage = 14,color = 6,strong = 100,base_attr = [{2,326000},{4,8150}],extra_attr = [{22,179},{39,326},{50,3720},{52,4650}],suit = 6060};

get_draconic_equip_info(7703615) ->
	#base_draconic_equip{id = 7703615,name = "恐暴之腿",pos = 3,stage = 15,color = 6,strong = 100,base_attr = [{2,400000},{4,10000}],extra_attr = [{22,220},{39,400},{50,4660},{52,5825}],suit = 6070};

get_draconic_equip_info(7704301) ->
	#base_draconic_equip{id = 7704301,name = "莱亚之盔",pos = 4,stage = 1,color = 3,strong = 100,base_attr = [{2,2250},{8,108}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704302) ->
	#base_draconic_equip{id = 7704302,name = "西锋之盔",pos = 4,stage = 2,color = 3,strong = 100,base_attr = [{2,3750},{8,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704303) ->
	#base_draconic_equip{id = 7704303,name = "棘甲之盔",pos = 4,stage = 3,color = 3,strong = 100,base_attr = [{2,5625},{8,270}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704304) ->
	#base_draconic_equip{id = 7704304,name = "风漂之盔",pos = 4,stage = 4,color = 3,strong = 100,base_attr = [{2,7875},{8,378}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704305) ->
	#base_draconic_equip{id = 7704305,name = "异特之盔",pos = 4,stage = 5,color = 3,strong = 100,base_attr = [{2,10500},{8,504}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704306) ->
	#base_draconic_equip{id = 7704306,name = "迅猛之盔",pos = 4,stage = 6,color = 3,strong = 100,base_attr = [{2,13500},{8,648}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704307) ->
	#base_draconic_equip{id = 7704307,name = "冥噬之盔",pos = 4,stage = 7,color = 3,strong = 100,base_attr = [{2,16875},{8,810}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704308) ->
	#base_draconic_equip{id = 7704308,name = "荒海之盔",pos = 4,stage = 8,color = 3,strong = 100,base_attr = [{2,20625},{8,990}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704309) ->
	#base_draconic_equip{id = 7704309,name = "暗鳞之盔",pos = 4,stage = 9,color = 3,strong = 100,base_attr = [{2,28125},{8,1350}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704310) ->
	#base_draconic_equip{id = 7704310,name = "黑煌之盔",pos = 4,stage = 10,color = 3,strong = 100,base_attr = [{2,31125},{8,1494}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704311) ->
	#base_draconic_equip{id = 7704311,name = "雷猎之盔",pos = 4,stage = 11,color = 3,strong = 100,base_attr = [{2,40875},{8,1962}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704312) ->
	#base_draconic_equip{id = 7704312,name = "天辉之盔",pos = 4,stage = 12,color = 3,strong = 100,base_attr = [{2,45375},{8,2178}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704313) ->
	#base_draconic_equip{id = 7704313,name = "苍穹之盔",pos = 4,stage = 13,color = 3,strong = 100,base_attr = [{2,56625},{8,2718}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704314) ->
	#base_draconic_equip{id = 7704314,name = "绝翼之盔",pos = 4,stage = 14,color = 3,strong = 100,base_attr = [{2,61125},{8,2934}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704315) ->
	#base_draconic_equip{id = 7704315,name = "恐暴之盔",pos = 4,stage = 15,color = 3,strong = 100,base_attr = [{2,75000},{8,3600}],extra_attr = [],suit = 0};

get_draconic_equip_info(7704401) ->
	#base_draconic_equip{id = 7704401,name = "莱亚之盔",pos = 4,stage = 1,color = 4,strong = 100,base_attr = [{2,3750},{8,180}],extra_attr = [{20,1},{45,3},{51,40}],suit = 4010};

get_draconic_equip_info(7704402) ->
	#base_draconic_equip{id = 7704402,name = "西锋之盔",pos = 4,stage = 2,color = 4,strong = 100,base_attr = [{2,6250},{8,300}],extra_attr = [{20,2},{45,5},{51,80}],suit = 4020};

get_draconic_equip_info(7704403) ->
	#base_draconic_equip{id = 7704403,name = "棘甲之盔",pos = 4,stage = 3,color = 4,strong = 100,base_attr = [{2,9375},{8,450}],extra_attr = [{20,2},{45,8},{51,160}],suit = 4030};

get_draconic_equip_info(7704404) ->
	#base_draconic_equip{id = 7704404,name = "风漂之盔",pos = 4,stage = 4,color = 4,strong = 100,base_attr = [{2,13125},{8,630}],extra_attr = [{20,3},{45,11},{51,320}],suit = 4040};

get_draconic_equip_info(7704405) ->
	#base_draconic_equip{id = 7704405,name = "异特之盔",pos = 4,stage = 5,color = 4,strong = 100,base_attr = [{2,17500},{8,840}],extra_attr = [{20,4},{45,14},{51,400}],suit = 4050};

get_draconic_equip_info(7704406) ->
	#base_draconic_equip{id = 7704406,name = "迅猛之盔",pos = 4,stage = 6,color = 4,strong = 100,base_attr = [{2,22500},{8,1080}],extra_attr = [{20,6},{45,18},{51,568}],suit = 4060};

get_draconic_equip_info(7704407) ->
	#base_draconic_equip{id = 7704407,name = "冥噬之盔",pos = 4,stage = 7,color = 4,strong = 100,base_attr = [{2,28125},{8,1350}],extra_attr = [{20,7},{45,23},{51,712}],suit = 4070};

get_draconic_equip_info(7704408) ->
	#base_draconic_equip{id = 7704408,name = "荒海之盔",pos = 4,stage = 8,color = 4,strong = 100,base_attr = [{2,34375},{8,1650}],extra_attr = [{20,8},{45,28},{51,880}],suit = 4080};

get_draconic_equip_info(7704409) ->
	#base_draconic_equip{id = 7704409,name = "暗鳞之盔",pos = 4,stage = 9,color = 4,strong = 100,base_attr = [{2,46875},{8,2250}],extra_attr = [{20,11},{45,38},{51,1100}],suit = 4090};

get_draconic_equip_info(7704410) ->
	#base_draconic_equip{id = 7704410,name = "黑煌之盔",pos = 4,stage = 10,color = 4,strong = 100,base_attr = [{2,51875},{8,2490}],extra_attr = [{20,13},{45,42},{51,1400}],suit = 4100};

get_draconic_equip_info(7704411) ->
	#base_draconic_equip{id = 7704411,name = "雷猎之盔",pos = 4,stage = 11,color = 4,strong = 100,base_attr = [{2,68125},{8,3270}],extra_attr = [{20,16},{45,55},{51,1760}],suit = 4110};

get_draconic_equip_info(7704412) ->
	#base_draconic_equip{id = 7704412,name = "天辉之盔",pos = 4,stage = 12,color = 4,strong = 100,base_attr = [{2,75625},{8,3630}],extra_attr = [{20,18},{45,61},{51,2168}],suit = 4120};

get_draconic_equip_info(7704413) ->
	#base_draconic_equip{id = 7704413,name = "苍穹之盔",pos = 4,stage = 13,color = 4,strong = 100,base_attr = [{2,94375},{8,4530}],extra_attr = [{20,23},{45,76},{51,2712}],suit = 4130};

get_draconic_equip_info(7704414) ->
	#base_draconic_equip{id = 7704414,name = "绝翼之盔",pos = 4,stage = 14,color = 4,strong = 100,base_attr = [{2,101875},{8,4890}],extra_attr = [{20,25},{45,82},{51,3400}],suit = 4140};

get_draconic_equip_info(7704415) ->
	#base_draconic_equip{id = 7704415,name = "恐暴之盔",pos = 4,stage = 15,color = 4,strong = 100,base_attr = [{2,125000},{8,6000}],extra_attr = [{20,30},{45,100},{51,4240}],suit = 4150};

get_draconic_equip_info(7704503) ->
	#base_draconic_equip{id = 7704503,name = "异特之盔",pos = 4,stage = 3,color = 5,strong = 100,base_attr = [{2,18750},{8,900}],extra_attr = [{20,5},{45,15}],suit = 5000};

get_draconic_equip_info(7704505) ->
	#base_draconic_equip{id = 7704505,name = "异特之盔",pos = 4,stage = 5,color = 5,strong = 100,base_attr = [{2,35000},{8,1680}],extra_attr = [{20,9},{45,28},{51,560},{52,350}],suit = 5010};

get_draconic_equip_info(7704506) ->
	#base_draconic_equip{id = 7704506,name = "迅猛之盔",pos = 4,stage = 6,color = 5,strong = 100,base_attr = [{2,45000},{8,2160}],extra_attr = [{20,11},{45,36},{51,800},{52,500}],suit = 5020};

get_draconic_equip_info(7704507) ->
	#base_draconic_equip{id = 7704507,name = "冥噬之盔",pos = 4,stage = 7,color = 5,strong = 100,base_attr = [{2,56250},{8,2700}],extra_attr = [{20,14},{45,45},{51,1000},{52,625}],suit = 5030};

get_draconic_equip_info(7704508) ->
	#base_draconic_equip{id = 7704508,name = "荒海之盔",pos = 4,stage = 8,color = 5,strong = 100,base_attr = [{2,68750},{8,3300}],extra_attr = [{20,17},{45,55},{51,1240},{52,775}],suit = 5040};

get_draconic_equip_info(7704509) ->
	#base_draconic_equip{id = 7704509,name = "暗鳞之盔",pos = 4,stage = 9,color = 5,strong = 100,base_attr = [{2,93750},{8,4500}],extra_attr = [{20,23},{45,75},{51,1560},{52,975}],suit = 5050};

get_draconic_equip_info(7704510) ->
	#base_draconic_equip{id = 7704510,name = "黑煌之盔",pos = 4,stage = 10,color = 5,strong = 100,base_attr = [{2,103750},{8,4980}],extra_attr = [{20,25},{45,83},{51,1960},{52,1225}],suit = 5060};

get_draconic_equip_info(7704511) ->
	#base_draconic_equip{id = 7704511,name = "雷猎之盔",pos = 4,stage = 11,color = 5,strong = 100,base_attr = [{2,136250},{8,6540}],extra_attr = [{20,33},{45,109},{51,2440},{52,1525}],suit = 5070};

get_draconic_equip_info(7704512) ->
	#base_draconic_equip{id = 7704512,name = "天辉之盔",pos = 4,stage = 12,color = 5,strong = 100,base_attr = [{2,151250},{8,7260}],extra_attr = [{20,37},{45,121},{51,3040},{52,1900}],suit = 5080};

get_draconic_equip_info(7704513) ->
	#base_draconic_equip{id = 7704513,name = "苍穹之盔",pos = 4,stage = 13,color = 5,strong = 100,base_attr = [{2,188750},{8,9060}],extra_attr = [{20,46},{45,151},{51,3800},{52,2375}],suit = 5090};

get_draconic_equip_info(7704514) ->
	#base_draconic_equip{id = 7704514,name = "绝翼之盔",pos = 4,stage = 14,color = 5,strong = 100,base_attr = [{2,203750},{8,9780}],extra_attr = [{20,49},{45,163},{51,4760},{52,2975}],suit = 5100};

get_draconic_equip_info(7704515) ->
	#base_draconic_equip{id = 7704515,name = "恐暴之盔",pos = 4,stage = 15,color = 5,strong = 100,base_attr = [{2,250000},{8,12000}],extra_attr = [{20,60},{45,200},{51,5960},{52,3725}],suit = 5110};

get_draconic_equip_info(7704609) ->
	#base_draconic_equip{id = 7704609,name = "暗鳞之盔",pos = 4,stage = 9,color = 6,strong = 100,base_attr = [{2,187500},{8,9000}],extra_attr = [{20,45},{45,150},{51,2440},{52,1525}],suit = 6010};

get_draconic_equip_info(7704610) ->
	#base_draconic_equip{id = 7704610,name = "黑煌之盔",pos = 4,stage = 10,color = 6,strong = 100,base_attr = [{2,207500},{8,9960}],extra_attr = [{20,50},{45,166},{51,3040},{52,1900}],suit = 6020};

get_draconic_equip_info(7704611) ->
	#base_draconic_equip{id = 7704611,name = "雷猎之盔",pos = 4,stage = 11,color = 6,strong = 100,base_attr = [{2,272500},{8,13080}],extra_attr = [{20,65},{45,218},{51,3800},{52,2375}],suit = 6030};

get_draconic_equip_info(7704612) ->
	#base_draconic_equip{id = 7704612,name = "天辉之盔",pos = 4,stage = 12,color = 6,strong = 100,base_attr = [{2,302500},{8,14520}],extra_attr = [{20,73},{45,242},{51,4760},{52,2975}],suit = 6040};

get_draconic_equip_info(7704613) ->
	#base_draconic_equip{id = 7704613,name = "苍穹之盔",pos = 4,stage = 13,color = 6,strong = 100,base_attr = [{2,377500},{8,18120}],extra_attr = [{20,91},{45,302},{51,5960},{52,3725}],suit = 6050};

get_draconic_equip_info(7704614) ->
	#base_draconic_equip{id = 7704614,name = "绝翼之盔",pos = 4,stage = 14,color = 6,strong = 100,base_attr = [{2,407500},{8,19560}],extra_attr = [{20,98},{45,326},{51,7440},{52,4650}],suit = 6060};

get_draconic_equip_info(7704615) ->
	#base_draconic_equip{id = 7704615,name = "恐暴之盔",pos = 4,stage = 15,color = 6,strong = 100,base_attr = [{2,500000},{8,24000}],extra_attr = [{20,120},{45,400},{51,9320},{52,5825}],suit = 6070};

get_draconic_equip_info(7705301) ->
	#base_draconic_equip{id = 7705301,name = "莱亚之靴",pos = 5,stage = 1,color = 3,strong = 100,base_attr = [{4,90},{6,108}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705302) ->
	#base_draconic_equip{id = 7705302,name = "西锋之靴",pos = 5,stage = 2,color = 3,strong = 100,base_attr = [{4,150},{6,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705303) ->
	#base_draconic_equip{id = 7705303,name = "棘甲之靴",pos = 5,stage = 3,color = 3,strong = 100,base_attr = [{4,225},{6,270}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705304) ->
	#base_draconic_equip{id = 7705304,name = "风漂之靴",pos = 5,stage = 4,color = 3,strong = 100,base_attr = [{4,315},{6,378}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705305) ->
	#base_draconic_equip{id = 7705305,name = "异特之靴",pos = 5,stage = 5,color = 3,strong = 100,base_attr = [{4,420},{6,504}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705306) ->
	#base_draconic_equip{id = 7705306,name = "迅猛之靴",pos = 5,stage = 6,color = 3,strong = 100,base_attr = [{4,540},{6,648}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705307) ->
	#base_draconic_equip{id = 7705307,name = "冥噬之靴",pos = 5,stage = 7,color = 3,strong = 100,base_attr = [{4,675},{6,810}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705308) ->
	#base_draconic_equip{id = 7705308,name = "荒海之靴",pos = 5,stage = 8,color = 3,strong = 100,base_attr = [{4,825},{6,990}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705309) ->
	#base_draconic_equip{id = 7705309,name = "暗鳞之靴",pos = 5,stage = 9,color = 3,strong = 100,base_attr = [{4,1125},{6,1350}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705310) ->
	#base_draconic_equip{id = 7705310,name = "黑煌之靴",pos = 5,stage = 10,color = 3,strong = 100,base_attr = [{4,1245},{6,1494}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705311) ->
	#base_draconic_equip{id = 7705311,name = "雷猎之靴",pos = 5,stage = 11,color = 3,strong = 100,base_attr = [{4,1635},{6,1962}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705312) ->
	#base_draconic_equip{id = 7705312,name = "天辉之靴",pos = 5,stage = 12,color = 3,strong = 100,base_attr = [{4,1815},{6,2178}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705313) ->
	#base_draconic_equip{id = 7705313,name = "苍穹之靴",pos = 5,stage = 13,color = 3,strong = 100,base_attr = [{4,2265},{6,2718}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705314) ->
	#base_draconic_equip{id = 7705314,name = "绝翼之靴",pos = 5,stage = 14,color = 3,strong = 100,base_attr = [{4,2445},{6,2934}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705315) ->
	#base_draconic_equip{id = 7705315,name = "恐暴之靴",pos = 5,stage = 15,color = 3,strong = 100,base_attr = [{4,3000},{6,3600}],extra_attr = [],suit = 0};

get_draconic_equip_info(7705401) ->
	#base_draconic_equip{id = 7705401,name = "莱亚之靴",pos = 5,stage = 1,color = 4,strong = 100,base_attr = [{4,150},{6,180}],extra_attr = [{22,2},{12,2},{50,40}],suit = 4010};

get_draconic_equip_info(7705402) ->
	#base_draconic_equip{id = 7705402,name = "西锋之靴",pos = 5,stage = 2,color = 4,strong = 100,base_attr = [{4,250},{6,300}],extra_attr = [{22,3},{12,3},{50,80}],suit = 4020};

get_draconic_equip_info(7705403) ->
	#base_draconic_equip{id = 7705403,name = "棘甲之靴",pos = 5,stage = 3,color = 4,strong = 100,base_attr = [{4,375},{6,450}],extra_attr = [{22,4},{12,4},{50,160}],suit = 4030};

get_draconic_equip_info(7705404) ->
	#base_draconic_equip{id = 7705404,name = "风漂之靴",pos = 5,stage = 4,color = 4,strong = 100,base_attr = [{4,525},{6,630}],extra_attr = [{22,5},{12,5},{50,320}],suit = 4040};

get_draconic_equip_info(7705405) ->
	#base_draconic_equip{id = 7705405,name = "异特之靴",pos = 5,stage = 5,color = 4,strong = 100,base_attr = [{4,700},{6,840}],extra_attr = [{22,7},{12,7},{50,400}],suit = 4050};

get_draconic_equip_info(7705406) ->
	#base_draconic_equip{id = 7705406,name = "迅猛之靴",pos = 5,stage = 6,color = 4,strong = 100,base_attr = [{4,900},{6,1080}],extra_attr = [{22,9},{12,9},{50,568}],suit = 4060};

get_draconic_equip_info(7705407) ->
	#base_draconic_equip{id = 7705407,name = "冥噬之靴",pos = 5,stage = 7,color = 4,strong = 100,base_attr = [{4,1125},{6,1350}],extra_attr = [{22,11},{12,11},{50,712}],suit = 4070};

get_draconic_equip_info(7705408) ->
	#base_draconic_equip{id = 7705408,name = "荒海之靴",pos = 5,stage = 8,color = 4,strong = 100,base_attr = [{4,1375},{6,1650}],extra_attr = [{22,14},{12,14},{50,880}],suit = 4080};

get_draconic_equip_info(7705409) ->
	#base_draconic_equip{id = 7705409,name = "暗鳞之靴",pos = 5,stage = 9,color = 4,strong = 100,base_attr = [{4,1875},{6,2250}],extra_attr = [{22,19},{12,19},{50,1100}],suit = 4090};

get_draconic_equip_info(7705410) ->
	#base_draconic_equip{id = 7705410,name = "黑煌之靴",pos = 5,stage = 10,color = 4,strong = 100,base_attr = [{4,2075},{6,2490}],extra_attr = [{22,21},{12,21},{50,1400}],suit = 4100};

get_draconic_equip_info(7705411) ->
	#base_draconic_equip{id = 7705411,name = "雷猎之靴",pos = 5,stage = 11,color = 4,strong = 100,base_attr = [{4,2725},{6,3270}],extra_attr = [{22,27},{12,27},{50,1760}],suit = 4110};

get_draconic_equip_info(7705412) ->
	#base_draconic_equip{id = 7705412,name = "天辉之靴",pos = 5,stage = 12,color = 4,strong = 100,base_attr = [{4,3025},{6,3630}],extra_attr = [{22,30},{12,30},{50,2168}],suit = 4120};

get_draconic_equip_info(7705413) ->
	#base_draconic_equip{id = 7705413,name = "苍穹之靴",pos = 5,stage = 13,color = 4,strong = 100,base_attr = [{4,3775},{6,4530}],extra_attr = [{22,38},{12,38},{50,2712}],suit = 4130};

get_draconic_equip_info(7705414) ->
	#base_draconic_equip{id = 7705414,name = "绝翼之靴",pos = 5,stage = 14,color = 4,strong = 100,base_attr = [{4,4075},{6,4890}],extra_attr = [{22,41},{12,41},{50,3400}],suit = 4140};

get_draconic_equip_info(7705415) ->
	#base_draconic_equip{id = 7705415,name = "恐暴之靴",pos = 5,stage = 15,color = 4,strong = 100,base_attr = [{4,5000},{6,6000}],extra_attr = [{22,50},{12,50},{50,4240}],suit = 4150};

get_draconic_equip_info(7705503) ->
	#base_draconic_equip{id = 7705503,name = "异特之靴",pos = 5,stage = 3,color = 5,strong = 100,base_attr = [{4,750},{6,900}],extra_attr = [{22,8},{12,8}],suit = 5000};

get_draconic_equip_info(7705505) ->
	#base_draconic_equip{id = 7705505,name = "异特之靴",pos = 5,stage = 5,color = 5,strong = 100,base_attr = [{4,1400},{6,1680}],extra_attr = [{22,14},{12,14},{50,560},{52,350}],suit = 5010};

get_draconic_equip_info(7705506) ->
	#base_draconic_equip{id = 7705506,name = "迅猛之靴",pos = 5,stage = 6,color = 5,strong = 100,base_attr = [{4,1800},{6,2160}],extra_attr = [{22,18},{12,18},{50,800},{52,500}],suit = 5020};

get_draconic_equip_info(7705507) ->
	#base_draconic_equip{id = 7705507,name = "冥噬之靴",pos = 5,stage = 7,color = 5,strong = 100,base_attr = [{4,2250},{6,2700}],extra_attr = [{22,23},{12,23},{50,1000},{52,625}],suit = 5030};

get_draconic_equip_info(7705508) ->
	#base_draconic_equip{id = 7705508,name = "荒海之靴",pos = 5,stage = 8,color = 5,strong = 100,base_attr = [{4,2750},{6,3300}],extra_attr = [{22,28},{12,28},{50,1240},{52,775}],suit = 5040};

get_draconic_equip_info(7705509) ->
	#base_draconic_equip{id = 7705509,name = "暗鳞之靴",pos = 5,stage = 9,color = 5,strong = 100,base_attr = [{4,3750},{6,4500}],extra_attr = [{22,38},{12,38},{50,1560},{52,975}],suit = 5050};

get_draconic_equip_info(7705510) ->
	#base_draconic_equip{id = 7705510,name = "黑煌之靴",pos = 5,stage = 10,color = 5,strong = 100,base_attr = [{4,4150},{6,4980}],extra_attr = [{22,42},{12,42},{50,1960},{52,1225}],suit = 5060};

get_draconic_equip_info(7705511) ->
	#base_draconic_equip{id = 7705511,name = "雷猎之靴",pos = 5,stage = 11,color = 5,strong = 100,base_attr = [{4,5450},{6,6540}],extra_attr = [{22,55},{12,55},{50,2440},{52,1525}],suit = 5070};

get_draconic_equip_info(7705512) ->
	#base_draconic_equip{id = 7705512,name = "天辉之靴",pos = 5,stage = 12,color = 5,strong = 100,base_attr = [{4,6050},{6,7260}],extra_attr = [{22,61},{12,61},{50,3040},{52,1900}],suit = 5080};

get_draconic_equip_info(7705513) ->
	#base_draconic_equip{id = 7705513,name = "苍穹之靴",pos = 5,stage = 13,color = 5,strong = 100,base_attr = [{4,7550},{6,9060}],extra_attr = [{22,76},{12,76},{50,3800},{52,2375}],suit = 5090};

get_draconic_equip_info(7705514) ->
	#base_draconic_equip{id = 7705514,name = "绝翼之靴",pos = 5,stage = 14,color = 5,strong = 100,base_attr = [{4,8150},{6,9780}],extra_attr = [{22,82},{12,82},{50,4760},{52,2975}],suit = 5100};

get_draconic_equip_info(7705515) ->
	#base_draconic_equip{id = 7705515,name = "恐暴之靴",pos = 5,stage = 15,color = 5,strong = 100,base_attr = [{4,10000},{6,12000}],extra_attr = [{22,100},{12,100},{50,5960},{52,3725}],suit = 5110};

get_draconic_equip_info(7705609) ->
	#base_draconic_equip{id = 7705609,name = "暗鳞之靴",pos = 5,stage = 9,color = 6,strong = 100,base_attr = [{4,7500},{6,9000}],extra_attr = [{22,75},{12,75},{50,2440},{52,1525}],suit = 6010};

get_draconic_equip_info(7705610) ->
	#base_draconic_equip{id = 7705610,name = "黑煌之靴",pos = 5,stage = 10,color = 6,strong = 100,base_attr = [{4,8300},{6,9960}],extra_attr = [{22,83},{12,83},{50,3040},{52,1900}],suit = 6020};

get_draconic_equip_info(7705611) ->
	#base_draconic_equip{id = 7705611,name = "雷猎之靴",pos = 5,stage = 11,color = 6,strong = 100,base_attr = [{4,10900},{6,13080}],extra_attr = [{22,109},{12,109},{50,3800},{52,2375}],suit = 6030};

get_draconic_equip_info(7705612) ->
	#base_draconic_equip{id = 7705612,name = "天辉之靴",pos = 5,stage = 12,color = 6,strong = 100,base_attr = [{4,12100},{6,14520}],extra_attr = [{22,121},{12,121},{50,4760},{52,2975}],suit = 6040};

get_draconic_equip_info(7705613) ->
	#base_draconic_equip{id = 7705613,name = "苍穹之靴",pos = 5,stage = 13,color = 6,strong = 100,base_attr = [{4,15100},{6,18120}],extra_attr = [{22,151},{12,151},{50,5960},{52,3725}],suit = 6050};

get_draconic_equip_info(7705614) ->
	#base_draconic_equip{id = 7705614,name = "绝翼之靴",pos = 5,stage = 14,color = 6,strong = 100,base_attr = [{4,16300},{6,19560}],extra_attr = [{22,163},{12,163},{50,7440},{52,4650}],suit = 6060};

get_draconic_equip_info(7705615) ->
	#base_draconic_equip{id = 7705615,name = "恐暴之靴",pos = 5,stage = 15,color = 6,strong = 100,base_attr = [{4,20000},{6,24000}],extra_attr = [{22,200},{12,200},{50,9320},{52,5825}],suit = 6070};

get_draconic_equip_info(7706301) ->
	#base_draconic_equip{id = 7706301,name = "莱亚之腕",pos = 6,stage = 1,color = 3,strong = 100,base_attr = [{3,90},{5,108}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706302) ->
	#base_draconic_equip{id = 7706302,name = "西锋之腕",pos = 6,stage = 2,color = 3,strong = 100,base_attr = [{3,150},{5,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706303) ->
	#base_draconic_equip{id = 7706303,name = "棘甲之腕",pos = 6,stage = 3,color = 3,strong = 100,base_attr = [{3,225},{5,270}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706304) ->
	#base_draconic_equip{id = 7706304,name = "风漂之腕",pos = 6,stage = 4,color = 3,strong = 100,base_attr = [{3,315},{5,378}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706305) ->
	#base_draconic_equip{id = 7706305,name = "异特之腕",pos = 6,stage = 5,color = 3,strong = 100,base_attr = [{3,420},{5,504}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706306) ->
	#base_draconic_equip{id = 7706306,name = "迅猛之腕",pos = 6,stage = 6,color = 3,strong = 100,base_attr = [{3,540},{5,648}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706307) ->
	#base_draconic_equip{id = 7706307,name = "冥噬之腕",pos = 6,stage = 7,color = 3,strong = 100,base_attr = [{3,675},{5,810}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706308) ->
	#base_draconic_equip{id = 7706308,name = "荒海之腕",pos = 6,stage = 8,color = 3,strong = 100,base_attr = [{3,825},{5,990}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706309) ->
	#base_draconic_equip{id = 7706309,name = "暗鳞之腕",pos = 6,stage = 9,color = 3,strong = 100,base_attr = [{3,1125},{5,1350}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706310) ->
	#base_draconic_equip{id = 7706310,name = "黑煌之腕",pos = 6,stage = 10,color = 3,strong = 100,base_attr = [{3,1245},{5,1494}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706311) ->
	#base_draconic_equip{id = 7706311,name = "雷猎之腕",pos = 6,stage = 11,color = 3,strong = 100,base_attr = [{3,1635},{5,1962}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706312) ->
	#base_draconic_equip{id = 7706312,name = "天辉之腕",pos = 6,stage = 12,color = 3,strong = 100,base_attr = [{3,1815},{5,2178}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706313) ->
	#base_draconic_equip{id = 7706313,name = "苍穹之腕",pos = 6,stage = 13,color = 3,strong = 100,base_attr = [{3,2265},{5,2718}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706314) ->
	#base_draconic_equip{id = 7706314,name = "绝翼之腕",pos = 6,stage = 14,color = 3,strong = 100,base_attr = [{3,2445},{5,2934}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706315) ->
	#base_draconic_equip{id = 7706315,name = "恐暴之腕",pos = 6,stage = 15,color = 3,strong = 100,base_attr = [{3,3000},{5,3600}],extra_attr = [],suit = 0};

get_draconic_equip_info(7706401) ->
	#base_draconic_equip{id = 7706401,name = "莱亚之腕",pos = 6,stage = 1,color = 4,strong = 100,base_attr = [{3,150},{5,180}],extra_attr = [{20,1},{28,5},{51,20}],suit = 4010};

get_draconic_equip_info(7706402) ->
	#base_draconic_equip{id = 7706402,name = "西锋之腕",pos = 6,stage = 2,color = 4,strong = 100,base_attr = [{3,250},{5,300}],extra_attr = [{20,2},{28,9},{51,40}],suit = 4020};

get_draconic_equip_info(7706403) ->
	#base_draconic_equip{id = 7706403,name = "棘甲之腕",pos = 6,stage = 3,color = 4,strong = 100,base_attr = [{3,375},{5,450}],extra_attr = [{20,2},{28,13},{51,80}],suit = 4030};

get_draconic_equip_info(7706404) ->
	#base_draconic_equip{id = 7706404,name = "风漂之腕",pos = 6,stage = 4,color = 4,strong = 100,base_attr = [{3,525},{5,630}],extra_attr = [{20,3},{28,19},{51,160}],suit = 4040};

get_draconic_equip_info(7706405) ->
	#base_draconic_equip{id = 7706405,name = "异特之腕",pos = 6,stage = 5,color = 4,strong = 100,base_attr = [{3,700},{5,840}],extra_attr = [{20,4},{28,25},{51,200}],suit = 4050};

get_draconic_equip_info(7706406) ->
	#base_draconic_equip{id = 7706406,name = "迅猛之腕",pos = 6,stage = 6,color = 4,strong = 100,base_attr = [{3,900},{5,1080}],extra_attr = [{20,6},{28,32},{51,284}],suit = 4060};

get_draconic_equip_info(7706407) ->
	#base_draconic_equip{id = 7706407,name = "冥噬之腕",pos = 6,stage = 7,color = 4,strong = 100,base_attr = [{3,1125},{5,1350}],extra_attr = [{20,7},{28,40},{51,356}],suit = 4070};

get_draconic_equip_info(7706408) ->
	#base_draconic_equip{id = 7706408,name = "荒海之腕",pos = 6,stage = 8,color = 4,strong = 100,base_attr = [{3,1375},{5,1650}],extra_attr = [{20,8},{28,48},{51,440}],suit = 4080};

get_draconic_equip_info(7706409) ->
	#base_draconic_equip{id = 7706409,name = "暗鳞之腕",pos = 6,stage = 9,color = 4,strong = 100,base_attr = [{3,1875},{5,2250}],extra_attr = [{20,11},{28,66},{51,550}],suit = 4090};

get_draconic_equip_info(7706410) ->
	#base_draconic_equip{id = 7706410,name = "黑煌之腕",pos = 6,stage = 10,color = 4,strong = 100,base_attr = [{3,2075},{5,2490}],extra_attr = [{20,13},{28,73},{51,700}],suit = 4100};

get_draconic_equip_info(7706411) ->
	#base_draconic_equip{id = 7706411,name = "雷猎之腕",pos = 6,stage = 11,color = 4,strong = 100,base_attr = [{3,2725},{5,3270}],extra_attr = [{20,16},{28,96},{51,880}],suit = 4110};

get_draconic_equip_info(7706412) ->
	#base_draconic_equip{id = 7706412,name = "天辉之腕",pos = 6,stage = 12,color = 4,strong = 100,base_attr = [{3,3025},{5,3630}],extra_attr = [{20,18},{28,106},{51,1084}],suit = 4120};

get_draconic_equip_info(7706413) ->
	#base_draconic_equip{id = 7706413,name = "苍穹之腕",pos = 6,stage = 13,color = 4,strong = 100,base_attr = [{3,3775},{5,4530}],extra_attr = [{20,23},{28,132},{51,1356}],suit = 4130};

get_draconic_equip_info(7706414) ->
	#base_draconic_equip{id = 7706414,name = "绝翼之腕",pos = 6,stage = 14,color = 4,strong = 100,base_attr = [{3,4075},{5,4890}],extra_attr = [{20,25},{28,143},{51,1700}],suit = 4140};

get_draconic_equip_info(7706415) ->
	#base_draconic_equip{id = 7706415,name = "恐暴之腕",pos = 6,stage = 15,color = 4,strong = 100,base_attr = [{3,5000},{5,6000}],extra_attr = [{20,30},{28,175},{51,2120}],suit = 4150};

get_draconic_equip_info(7706503) ->
	#base_draconic_equip{id = 7706503,name = "异特之腕",pos = 6,stage = 3,color = 5,strong = 100,base_attr = [{3,750},{5,900}],extra_attr = [{20,5},{28,27}],suit = 5000};

get_draconic_equip_info(7706505) ->
	#base_draconic_equip{id = 7706505,name = "异特之腕",pos = 6,stage = 5,color = 5,strong = 100,base_attr = [{3,1400},{5,1680}],extra_attr = [{20,9},{28,49},{51,280},{52,350}],suit = 5010};

get_draconic_equip_info(7706506) ->
	#base_draconic_equip{id = 7706506,name = "迅猛之腕",pos = 6,stage = 6,color = 5,strong = 100,base_attr = [{3,1800},{5,2160}],extra_attr = [{20,11},{28,63},{51,400},{52,500}],suit = 5020};

get_draconic_equip_info(7706507) ->
	#base_draconic_equip{id = 7706507,name = "冥噬之腕",pos = 6,stage = 7,color = 5,strong = 100,base_attr = [{3,2250},{5,2700}],extra_attr = [{20,14},{28,79},{51,500},{52,625}],suit = 5030};

get_draconic_equip_info(7706508) ->
	#base_draconic_equip{id = 7706508,name = "荒海之腕",pos = 6,stage = 8,color = 5,strong = 100,base_attr = [{3,2750},{5,3300}],extra_attr = [{20,17},{28,97},{51,620},{52,775}],suit = 5040};

get_draconic_equip_info(7706509) ->
	#base_draconic_equip{id = 7706509,name = "暗鳞之腕",pos = 6,stage = 9,color = 5,strong = 100,base_attr = [{3,3750},{5,4500}],extra_attr = [{20,23},{28,132},{51,780},{52,975}],suit = 5050};

get_draconic_equip_info(7706510) ->
	#base_draconic_equip{id = 7706510,name = "黑煌之腕",pos = 6,stage = 10,color = 5,strong = 100,base_attr = [{3,4150},{5,4980}],extra_attr = [{20,25},{28,146},{51,980},{52,1225}],suit = 5060};

get_draconic_equip_info(7706511) ->
	#base_draconic_equip{id = 7706511,name = "雷猎之腕",pos = 6,stage = 11,color = 5,strong = 100,base_attr = [{3,5450},{5,6540}],extra_attr = [{20,33},{28,191},{51,1220},{52,1525}],suit = 5070};

get_draconic_equip_info(7706512) ->
	#base_draconic_equip{id = 7706512,name = "天辉之腕",pos = 6,stage = 12,color = 5,strong = 100,base_attr = [{3,6050},{5,7260}],extra_attr = [{20,37},{28,212},{51,1520},{52,1900}],suit = 5080};

get_draconic_equip_info(7706513) ->
	#base_draconic_equip{id = 7706513,name = "苍穹之腕",pos = 6,stage = 13,color = 5,strong = 100,base_attr = [{3,7550},{5,9060}],extra_attr = [{20,46},{28,265},{51,1900},{52,2375}],suit = 5090};

get_draconic_equip_info(7706514) ->
	#base_draconic_equip{id = 7706514,name = "绝翼之腕",pos = 6,stage = 14,color = 5,strong = 100,base_attr = [{3,8150},{5,9780}],extra_attr = [{20,49},{28,286},{51,2380},{52,2975}],suit = 5100};

get_draconic_equip_info(7706515) ->
	#base_draconic_equip{id = 7706515,name = "恐暴之腕",pos = 6,stage = 15,color = 5,strong = 100,base_attr = [{3,10000},{5,12000}],extra_attr = [{20,60},{28,350},{51,2980},{52,3725}],suit = 5110};

get_draconic_equip_info(7706609) ->
	#base_draconic_equip{id = 7706609,name = "暗鳞之腕",pos = 6,stage = 9,color = 6,strong = 100,base_attr = [{3,7500},{5,9000}],extra_attr = [{20,45},{28,263},{51,1220},{52,1525}],suit = 6010};

get_draconic_equip_info(7706610) ->
	#base_draconic_equip{id = 7706610,name = "黑煌之腕",pos = 6,stage = 10,color = 6,strong = 100,base_attr = [{3,8300},{5,9960}],extra_attr = [{20,50},{28,291},{51,1520},{52,1900}],suit = 6020};

get_draconic_equip_info(7706611) ->
	#base_draconic_equip{id = 7706611,name = "雷猎之腕",pos = 6,stage = 11,color = 6,strong = 100,base_attr = [{3,10900},{5,13080}],extra_attr = [{20,65},{28,382},{51,1900},{52,2375}],suit = 6030};

get_draconic_equip_info(7706612) ->
	#base_draconic_equip{id = 7706612,name = "天辉之腕",pos = 6,stage = 12,color = 6,strong = 100,base_attr = [{3,12100},{5,14520}],extra_attr = [{20,73},{28,424},{51,2380},{52,2975}],suit = 6040};

get_draconic_equip_info(7706613) ->
	#base_draconic_equip{id = 7706613,name = "苍穹之腕",pos = 6,stage = 13,color = 6,strong = 100,base_attr = [{3,15100},{5,18120}],extra_attr = [{20,91},{28,529},{51,2980},{52,3725}],suit = 6050};

get_draconic_equip_info(7706614) ->
	#base_draconic_equip{id = 7706614,name = "绝翼之腕",pos = 6,stage = 14,color = 6,strong = 100,base_attr = [{3,16300},{5,19560}],extra_attr = [{20,98},{28,571},{51,3720},{52,4650}],suit = 6060};

get_draconic_equip_info(7706615) ->
	#base_draconic_equip{id = 7706615,name = "恐暴之腕",pos = 6,stage = 15,color = 6,strong = 100,base_attr = [{3,20000},{5,24000}],extra_attr = [{20,120},{28,700},{51,4660},{52,5825}],suit = 6070};

get_draconic_equip_info(7707301) ->
	#base_draconic_equip{id = 7707301,name = "莱亚龙瞳之灵",pos = 7,stage = 1,color = 3,strong = 100,base_attr = [{1,113},{5,72}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707302) ->
	#base_draconic_equip{id = 7707302,name = "西锋龙瞳之灵",pos = 7,stage = 2,color = 3,strong = 100,base_attr = [{1,188},{5,120}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707303) ->
	#base_draconic_equip{id = 7707303,name = "棘甲龙瞳之灵",pos = 7,stage = 3,color = 3,strong = 100,base_attr = [{1,281},{5,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707304) ->
	#base_draconic_equip{id = 7707304,name = "风漂龙瞳之灵",pos = 7,stage = 4,color = 3,strong = 100,base_attr = [{1,394},{5,252}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707305) ->
	#base_draconic_equip{id = 7707305,name = "异特龙瞳之灵",pos = 7,stage = 5,color = 3,strong = 100,base_attr = [{1,525},{5,336}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707306) ->
	#base_draconic_equip{id = 7707306,name = "迅猛龙瞳之灵",pos = 7,stage = 6,color = 3,strong = 100,base_attr = [{1,675},{5,432}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707307) ->
	#base_draconic_equip{id = 7707307,name = "冥噬龙瞳之灵",pos = 7,stage = 7,color = 3,strong = 100,base_attr = [{1,844},{5,540}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707308) ->
	#base_draconic_equip{id = 7707308,name = "荒海龙瞳之灵",pos = 7,stage = 8,color = 3,strong = 100,base_attr = [{1,1031},{5,660}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707309) ->
	#base_draconic_equip{id = 7707309,name = "暗鳞龙瞳之灵",pos = 7,stage = 9,color = 3,strong = 100,base_attr = [{1,1406},{5,900}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707310) ->
	#base_draconic_equip{id = 7707310,name = "黑煌龙瞳之灵",pos = 7,stage = 10,color = 3,strong = 100,base_attr = [{1,1556},{5,996}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707311) ->
	#base_draconic_equip{id = 7707311,name = "雷猎龙瞳之灵",pos = 7,stage = 11,color = 3,strong = 100,base_attr = [{1,2044},{5,1308}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707312) ->
	#base_draconic_equip{id = 7707312,name = "天辉龙瞳之灵",pos = 7,stage = 12,color = 3,strong = 100,base_attr = [{1,2269},{5,1452}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707313) ->
	#base_draconic_equip{id = 7707313,name = "苍穹龙瞳之灵",pos = 7,stage = 13,color = 3,strong = 100,base_attr = [{1,2831},{5,1812}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707314) ->
	#base_draconic_equip{id = 7707314,name = "绝翼龙瞳之灵",pos = 7,stage = 14,color = 3,strong = 100,base_attr = [{1,3056},{5,1956}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707315) ->
	#base_draconic_equip{id = 7707315,name = "恐暴龙瞳之灵",pos = 7,stage = 15,color = 3,strong = 100,base_attr = [{1,3750},{5,2400}],extra_attr = [],suit = 0};

get_draconic_equip_info(7707401) ->
	#base_draconic_equip{id = 7707401,name = "莱亚龙瞳之灵",pos = 7,stage = 1,color = 4,strong = 100,base_attr = [{1,188},{5,120}],extra_attr = [{19,1},{11,8}],suit = 4011};

get_draconic_equip_info(7707402) ->
	#base_draconic_equip{id = 7707402,name = "西锋龙瞳之灵",pos = 7,stage = 2,color = 4,strong = 100,base_attr = [{1,313},{5,200}],extra_attr = [{19,2},{11,13}],suit = 4021};

get_draconic_equip_info(7707403) ->
	#base_draconic_equip{id = 7707403,name = "棘甲龙瞳之灵",pos = 7,stage = 3,color = 4,strong = 100,base_attr = [{1,469},{5,300}],extra_attr = [{19,3},{11,19},{50,20}],suit = 4031};

get_draconic_equip_info(7707404) ->
	#base_draconic_equip{id = 7707404,name = "风漂龙瞳之灵",pos = 7,stage = 4,color = 4,strong = 100,base_attr = [{1,656},{5,420}],extra_attr = [{19,4},{11,26},{50,40}],suit = 4041};

get_draconic_equip_info(7707405) ->
	#base_draconic_equip{id = 7707405,name = "异特龙瞳之灵",pos = 7,stage = 5,color = 4,strong = 100,base_attr = [{1,875},{5,560}],extra_attr = [{19,5},{11,35},{50,50}],suit = 4051};

get_draconic_equip_info(7707406) ->
	#base_draconic_equip{id = 7707406,name = "迅猛龙瞳之灵",pos = 7,stage = 6,color = 4,strong = 100,base_attr = [{1,1125},{5,720}],extra_attr = [{19,7},{11,45},{50,71}],suit = 4061};

get_draconic_equip_info(7707407) ->
	#base_draconic_equip{id = 7707407,name = "冥噬龙瞳之灵",pos = 7,stage = 7,color = 4,strong = 100,base_attr = [{1,1406},{5,900}],extra_attr = [{19,9},{11,56},{50,89}],suit = 4071};

get_draconic_equip_info(7707408) ->
	#base_draconic_equip{id = 7707408,name = "荒海龙瞳之灵",pos = 7,stage = 8,color = 4,strong = 100,base_attr = [{1,1719},{5,1100}],extra_attr = [{19,10},{11,69},{50,110}],suit = 4081};

get_draconic_equip_info(7707409) ->
	#base_draconic_equip{id = 7707409,name = "暗鳞龙瞳之灵",pos = 7,stage = 9,color = 4,strong = 100,base_attr = [{1,2344},{5,1500}],extra_attr = [{19,14},{11,94},{50,138}],suit = 4091};

get_draconic_equip_info(7707410) ->
	#base_draconic_equip{id = 7707410,name = "黑煌龙瞳之灵",pos = 7,stage = 10,color = 4,strong = 100,base_attr = [{1,2594},{5,1660}],extra_attr = [{19,16},{11,104},{50,175}],suit = 4101};

get_draconic_equip_info(7707411) ->
	#base_draconic_equip{id = 7707411,name = "雷猎龙瞳之灵",pos = 7,stage = 11,color = 4,strong = 100,base_attr = [{1,3406},{5,2180}],extra_attr = [{19,21},{11,136},{50,220}],suit = 4111};

get_draconic_equip_info(7707412) ->
	#base_draconic_equip{id = 7707412,name = "天辉龙瞳之灵",pos = 7,stage = 12,color = 4,strong = 100,base_attr = [{1,3781},{5,2420}],extra_attr = [{19,23},{11,151},{50,271}],suit = 4121};

get_draconic_equip_info(7707413) ->
	#base_draconic_equip{id = 7707413,name = "苍穹龙瞳之灵",pos = 7,stage = 13,color = 4,strong = 100,base_attr = [{1,4719},{5,3020}],extra_attr = [{19,28},{11,189},{50,339}],suit = 4131};

get_draconic_equip_info(7707414) ->
	#base_draconic_equip{id = 7707414,name = "绝翼龙瞳之灵",pos = 7,stage = 14,color = 4,strong = 100,base_attr = [{1,5094},{5,3260}],extra_attr = [{19,31},{11,204},{50,425}],suit = 4141};

get_draconic_equip_info(7707415) ->
	#base_draconic_equip{id = 7707415,name = "恐暴龙瞳之灵",pos = 7,stage = 15,color = 4,strong = 100,base_attr = [{1,6250},{5,4000}],extra_attr = [{19,38},{11,250},{50,530}],suit = 4151};

get_draconic_equip_info(7707503) ->
	#base_draconic_equip{id = 7707503,name = "异特龙瞳之灵",pos = 7,stage = 3,color = 5,strong = 100,base_attr = [{1,938},{5,600}],extra_attr = [{19,6},{11,38},{50,28}],suit = 5001};

get_draconic_equip_info(7707505) ->
	#base_draconic_equip{id = 7707505,name = "异特龙瞳之灵",pos = 7,stage = 5,color = 5,strong = 100,base_attr = [{1,1750},{5,1120}],extra_attr = [{19,11},{11,70},{50,70}],suit = 5011};

get_draconic_equip_info(7707506) ->
	#base_draconic_equip{id = 7707506,name = "迅猛龙瞳之灵",pos = 7,stage = 6,color = 5,strong = 100,base_attr = [{1,2250},{5,1440}],extra_attr = [{19,14},{11,90},{50,100}],suit = 5021};

get_draconic_equip_info(7707507) ->
	#base_draconic_equip{id = 7707507,name = "冥噬龙瞳之灵",pos = 7,stage = 7,color = 5,strong = 100,base_attr = [{1,2813},{5,1800}],extra_attr = [{19,17},{11,113},{50,125}],suit = 5031};

get_draconic_equip_info(7707508) ->
	#base_draconic_equip{id = 7707508,name = "荒海龙瞳之灵",pos = 7,stage = 8,color = 5,strong = 100,base_attr = [{1,3438},{5,2200}],extra_attr = [{19,21},{11,138},{50,155}],suit = 5041};

get_draconic_equip_info(7707509) ->
	#base_draconic_equip{id = 7707509,name = "暗鳞龙瞳之灵",pos = 7,stage = 9,color = 5,strong = 100,base_attr = [{1,4688},{5,3000}],extra_attr = [{19,28},{11,188},{50,195}],suit = 5051};

get_draconic_equip_info(7707510) ->
	#base_draconic_equip{id = 7707510,name = "黑煌龙瞳之灵",pos = 7,stage = 10,color = 5,strong = 100,base_attr = [{1,5188},{5,3320}],extra_attr = [{19,31},{11,208},{50,245}],suit = 5061};

get_draconic_equip_info(7707511) ->
	#base_draconic_equip{id = 7707511,name = "雷猎龙瞳之灵",pos = 7,stage = 11,color = 5,strong = 100,base_attr = [{1,6813},{5,4360}],extra_attr = [{19,41},{11,273},{50,305}],suit = 5071};

get_draconic_equip_info(7707512) ->
	#base_draconic_equip{id = 7707512,name = "天辉龙瞳之灵",pos = 7,stage = 12,color = 5,strong = 100,base_attr = [{1,7563},{5,4840}],extra_attr = [{19,46},{11,303},{50,380}],suit = 5081};

get_draconic_equip_info(7707513) ->
	#base_draconic_equip{id = 7707513,name = "苍穹龙瞳之灵",pos = 7,stage = 13,color = 5,strong = 100,base_attr = [{1,9438},{5,6040}],extra_attr = [{19,57},{11,378},{50,475}],suit = 5091};

get_draconic_equip_info(7707514) ->
	#base_draconic_equip{id = 7707514,name = "绝翼龙瞳之灵",pos = 7,stage = 14,color = 5,strong = 100,base_attr = [{1,10188},{5,6520}],extra_attr = [{19,61},{11,408},{50,595}],suit = 5101};

get_draconic_equip_info(7707515) ->
	#base_draconic_equip{id = 7707515,name = "恐暴龙瞳之灵",pos = 7,stage = 15,color = 5,strong = 100,base_attr = [{1,12500},{5,8000}],extra_attr = [{19,75},{11,500},{50,745}],suit = 5111};

get_draconic_equip_info(7707609) ->
	#base_draconic_equip{id = 7707609,name = "暗鳞龙瞳之灵",pos = 7,stage = 9,color = 6,strong = 100,base_attr = [{1,9375},{5,6000}],extra_attr = [{19,56},{11,375},{50,305}],suit = 6011};

get_draconic_equip_info(7707610) ->
	#base_draconic_equip{id = 7707610,name = "黑煌龙瞳之灵",pos = 7,stage = 10,color = 6,strong = 100,base_attr = [{1,10375},{5,6640}],extra_attr = [{19,62},{11,415},{50,380}],suit = 6021};

get_draconic_equip_info(7707611) ->
	#base_draconic_equip{id = 7707611,name = "雷猎龙瞳之灵",pos = 7,stage = 11,color = 6,strong = 100,base_attr = [{1,13625},{5,8720}],extra_attr = [{19,82},{11,545},{50,475}],suit = 6031};

get_draconic_equip_info(7707612) ->
	#base_draconic_equip{id = 7707612,name = "天辉龙瞳之灵",pos = 7,stage = 12,color = 6,strong = 100,base_attr = [{1,15125},{5,9680}],extra_attr = [{19,91},{11,605},{50,595}],suit = 6041};

get_draconic_equip_info(7707613) ->
	#base_draconic_equip{id = 7707613,name = "苍穹龙瞳之灵",pos = 7,stage = 13,color = 6,strong = 100,base_attr = [{1,18875},{5,12080}],extra_attr = [{19,113},{11,755},{50,745}],suit = 6051};

get_draconic_equip_info(7707614) ->
	#base_draconic_equip{id = 7707614,name = "绝翼龙瞳之灵",pos = 7,stage = 14,color = 6,strong = 100,base_attr = [{1,20375},{5,13040}],extra_attr = [{19,122},{11,815},{50,930}],suit = 6061};

get_draconic_equip_info(7707615) ->
	#base_draconic_equip{id = 7707615,name = "恐暴龙瞳之灵",pos = 7,stage = 15,color = 6,strong = 100,base_attr = [{1,25000},{5,16000}],extra_attr = [{19,150},{11,1000},{50,1165}],suit = 6071};

get_draconic_equip_info(7708301) ->
	#base_draconic_equip{id = 7708301,name = "莱亚龙翼之灵",pos = 8,stage = 1,color = 3,strong = 100,base_attr = [{1,90},{3,45}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708302) ->
	#base_draconic_equip{id = 7708302,name = "西锋龙翼之灵",pos = 8,stage = 2,color = 3,strong = 100,base_attr = [{1,150},{3,75}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708303) ->
	#base_draconic_equip{id = 7708303,name = "棘甲龙翼之灵",pos = 8,stage = 3,color = 3,strong = 100,base_attr = [{1,225},{3,113}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708304) ->
	#base_draconic_equip{id = 7708304,name = "风漂龙翼之灵",pos = 8,stage = 4,color = 3,strong = 100,base_attr = [{1,315},{3,158}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708305) ->
	#base_draconic_equip{id = 7708305,name = "异特龙翼之灵",pos = 8,stage = 5,color = 3,strong = 100,base_attr = [{1,420},{3,210}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708306) ->
	#base_draconic_equip{id = 7708306,name = "迅猛龙翼之灵",pos = 8,stage = 6,color = 3,strong = 100,base_attr = [{1,540},{3,270}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708307) ->
	#base_draconic_equip{id = 7708307,name = "冥噬龙翼之灵",pos = 8,stage = 7,color = 3,strong = 100,base_attr = [{1,675},{3,338}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708308) ->
	#base_draconic_equip{id = 7708308,name = "荒海龙翼之灵",pos = 8,stage = 8,color = 3,strong = 100,base_attr = [{1,825},{3,413}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708309) ->
	#base_draconic_equip{id = 7708309,name = "暗鳞龙翼之灵",pos = 8,stage = 9,color = 3,strong = 100,base_attr = [{1,1125},{3,563}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708310) ->
	#base_draconic_equip{id = 7708310,name = "黑煌龙翼之灵",pos = 8,stage = 10,color = 3,strong = 100,base_attr = [{1,1245},{3,623}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708311) ->
	#base_draconic_equip{id = 7708311,name = "雷猎龙翼之灵",pos = 8,stage = 11,color = 3,strong = 100,base_attr = [{1,1635},{3,818}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708312) ->
	#base_draconic_equip{id = 7708312,name = "天辉龙翼之灵",pos = 8,stage = 12,color = 3,strong = 100,base_attr = [{1,1815},{3,908}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708313) ->
	#base_draconic_equip{id = 7708313,name = "苍穹龙翼之灵",pos = 8,stage = 13,color = 3,strong = 100,base_attr = [{1,2265},{3,1133}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708314) ->
	#base_draconic_equip{id = 7708314,name = "绝翼龙翼之灵",pos = 8,stage = 14,color = 3,strong = 100,base_attr = [{1,2445},{3,1223}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708315) ->
	#base_draconic_equip{id = 7708315,name = "恐暴龙翼之灵",pos = 8,stage = 15,color = 3,strong = 100,base_attr = [{1,3000},{3,1500}],extra_attr = [],suit = 0};

get_draconic_equip_info(7708401) ->
	#base_draconic_equip{id = 7708401,name = "莱亚龙翼之灵",pos = 8,stage = 1,color = 4,strong = 100,base_attr = [{1,150},{3,75}],extra_attr = [{21,2},{56,8}],suit = 4011};

get_draconic_equip_info(7708402) ->
	#base_draconic_equip{id = 7708402,name = "西锋龙翼之灵",pos = 8,stage = 2,color = 4,strong = 100,base_attr = [{1,250},{3,125}],extra_attr = [{21,4},{56,13}],suit = 4021};

get_draconic_equip_info(7708403) ->
	#base_draconic_equip{id = 7708403,name = "棘甲龙翼之灵",pos = 8,stage = 3,color = 4,strong = 100,base_attr = [{1,375},{3,188}],extra_attr = [{21,6},{56,19},{51,20}],suit = 4031};

get_draconic_equip_info(7708404) ->
	#base_draconic_equip{id = 7708404,name = "风漂龙翼之灵",pos = 8,stage = 4,color = 4,strong = 100,base_attr = [{1,525},{3,263}],extra_attr = [{21,8},{56,26},{51,40}],suit = 4041};

get_draconic_equip_info(7708405) ->
	#base_draconic_equip{id = 7708405,name = "异特龙翼之灵",pos = 8,stage = 5,color = 4,strong = 100,base_attr = [{1,700},{3,350}],extra_attr = [{21,11},{56,35},{51,50}],suit = 4051};

get_draconic_equip_info(7708406) ->
	#base_draconic_equip{id = 7708406,name = "迅猛龙翼之灵",pos = 8,stage = 6,color = 4,strong = 100,base_attr = [{1,900},{3,450}],extra_attr = [{21,14},{56,45},{51,71}],suit = 4061};

get_draconic_equip_info(7708407) ->
	#base_draconic_equip{id = 7708407,name = "冥噬龙翼之灵",pos = 8,stage = 7,color = 4,strong = 100,base_attr = [{1,1125},{3,563}],extra_attr = [{21,17},{56,56},{51,89}],suit = 4071};

get_draconic_equip_info(7708408) ->
	#base_draconic_equip{id = 7708408,name = "荒海龙翼之灵",pos = 8,stage = 8,color = 4,strong = 100,base_attr = [{1,1375},{3,688}],extra_attr = [{21,21},{56,69},{51,110}],suit = 4081};

get_draconic_equip_info(7708409) ->
	#base_draconic_equip{id = 7708409,name = "暗鳞龙翼之灵",pos = 8,stage = 9,color = 4,strong = 100,base_attr = [{1,1875},{3,938}],extra_attr = [{21,28},{56,94},{51,138}],suit = 4091};

get_draconic_equip_info(7708410) ->
	#base_draconic_equip{id = 7708410,name = "黑煌龙翼之灵",pos = 8,stage = 10,color = 4,strong = 100,base_attr = [{1,2075},{3,1038}],extra_attr = [{21,31},{56,104},{51,175}],suit = 4101};

get_draconic_equip_info(7708411) ->
	#base_draconic_equip{id = 7708411,name = "雷猎龙翼之灵",pos = 8,stage = 11,color = 4,strong = 100,base_attr = [{1,2725},{3,1363}],extra_attr = [{21,41},{56,136},{51,220}],suit = 4111};

get_draconic_equip_info(7708412) ->
	#base_draconic_equip{id = 7708412,name = "天辉龙翼之灵",pos = 8,stage = 12,color = 4,strong = 100,base_attr = [{1,3025},{3,1513}],extra_attr = [{21,46},{56,151},{51,271}],suit = 4121};

get_draconic_equip_info(7708413) ->
	#base_draconic_equip{id = 7708413,name = "苍穹龙翼之灵",pos = 8,stage = 13,color = 4,strong = 100,base_attr = [{1,3775},{3,1888}],extra_attr = [{21,57},{56,189},{51,339}],suit = 4131};

get_draconic_equip_info(7708414) ->
	#base_draconic_equip{id = 7708414,name = "绝翼龙翼之灵",pos = 8,stage = 14,color = 4,strong = 100,base_attr = [{1,4075},{3,2038}],extra_attr = [{21,61},{56,204},{51,425}],suit = 4141};

get_draconic_equip_info(7708415) ->
	#base_draconic_equip{id = 7708415,name = "恐暴龙翼之灵",pos = 8,stage = 15,color = 4,strong = 100,base_attr = [{1,5000},{3,2500}],extra_attr = [{21,75},{56,250},{51,530}],suit = 4151};

get_draconic_equip_info(7708503) ->
	#base_draconic_equip{id = 7708503,name = "异特龙翼之灵",pos = 8,stage = 3,color = 5,strong = 100,base_attr = [{1,750},{3,375}],extra_attr = [{21,12},{56,38},{51,28}],suit = 5001};

get_draconic_equip_info(7708505) ->
	#base_draconic_equip{id = 7708505,name = "异特龙翼之灵",pos = 8,stage = 5,color = 5,strong = 100,base_attr = [{1,1400},{3,700}],extra_attr = [{21,21},{56,70},{51,70}],suit = 5011};

get_draconic_equip_info(7708506) ->
	#base_draconic_equip{id = 7708506,name = "迅猛龙翼之灵",pos = 8,stage = 6,color = 5,strong = 100,base_attr = [{1,1800},{3,900}],extra_attr = [{21,27},{56,90},{51,100}],suit = 5021};

get_draconic_equip_info(7708507) ->
	#base_draconic_equip{id = 7708507,name = "冥噬龙翼之灵",pos = 8,stage = 7,color = 5,strong = 100,base_attr = [{1,2250},{3,1125}],extra_attr = [{21,34},{56,113},{51,125}],suit = 5031};

get_draconic_equip_info(7708508) ->
	#base_draconic_equip{id = 7708508,name = "荒海龙翼之灵",pos = 8,stage = 8,color = 5,strong = 100,base_attr = [{1,2750},{3,1375}],extra_attr = [{21,42},{56,138},{51,155}],suit = 5041};

get_draconic_equip_info(7708509) ->
	#base_draconic_equip{id = 7708509,name = "暗鳞龙翼之灵",pos = 8,stage = 9,color = 5,strong = 100,base_attr = [{1,3750},{3,1875}],extra_attr = [{21,57},{56,188},{51,195}],suit = 5051};

get_draconic_equip_info(7708510) ->
	#base_draconic_equip{id = 7708510,name = "黑煌龙翼之灵",pos = 8,stage = 10,color = 5,strong = 100,base_attr = [{1,4150},{3,2075}],extra_attr = [{21,63},{56,208},{51,245}],suit = 5061};

get_draconic_equip_info(7708511) ->
	#base_draconic_equip{id = 7708511,name = "雷猎龙翼之灵",pos = 8,stage = 11,color = 5,strong = 100,base_attr = [{1,5450},{3,2725}],extra_attr = [{21,82},{56,273},{51,305}],suit = 5071};

get_draconic_equip_info(7708512) ->
	#base_draconic_equip{id = 7708512,name = "天辉龙翼之灵",pos = 8,stage = 12,color = 5,strong = 100,base_attr = [{1,6050},{3,3025}],extra_attr = [{21,91},{56,303},{51,380}],suit = 5081};

get_draconic_equip_info(7708513) ->
	#base_draconic_equip{id = 7708513,name = "苍穹龙翼之灵",pos = 8,stage = 13,color = 5,strong = 100,base_attr = [{1,7550},{3,3775}],extra_attr = [{21,114},{56,378},{51,475}],suit = 5091};

get_draconic_equip_info(7708514) ->
	#base_draconic_equip{id = 7708514,name = "绝翼龙翼之灵",pos = 8,stage = 14,color = 5,strong = 100,base_attr = [{1,8150},{3,4075}],extra_attr = [{21,123},{56,408},{51,595}],suit = 5101};

get_draconic_equip_info(7708515) ->
	#base_draconic_equip{id = 7708515,name = "恐暴龙翼之灵",pos = 8,stage = 15,color = 5,strong = 100,base_attr = [{1,10000},{3,5000}],extra_attr = [{21,150},{56,500},{51,745}],suit = 5111};

get_draconic_equip_info(7708609) ->
	#base_draconic_equip{id = 7708609,name = "暗鳞龙翼之灵",pos = 8,stage = 9,color = 6,strong = 100,base_attr = [{1,7500},{3,3750}],extra_attr = [{21,113},{56,375},{51,305}],suit = 6011};

get_draconic_equip_info(7708610) ->
	#base_draconic_equip{id = 7708610,name = "黑煌龙翼之灵",pos = 8,stage = 10,color = 6,strong = 100,base_attr = [{1,8300},{3,4150}],extra_attr = [{21,125},{56,415},{51,380}],suit = 6021};

get_draconic_equip_info(7708611) ->
	#base_draconic_equip{id = 7708611,name = "雷猎龙翼之灵",pos = 8,stage = 11,color = 6,strong = 100,base_attr = [{1,10900},{3,5450}],extra_attr = [{21,164},{56,545},{51,475}],suit = 6031};

get_draconic_equip_info(7708612) ->
	#base_draconic_equip{id = 7708612,name = "天辉龙翼之灵",pos = 8,stage = 12,color = 6,strong = 100,base_attr = [{1,12100},{3,6050}],extra_attr = [{21,182},{56,605},{51,595}],suit = 6041};

get_draconic_equip_info(7708613) ->
	#base_draconic_equip{id = 7708613,name = "苍穹龙翼之灵",pos = 8,stage = 13,color = 6,strong = 100,base_attr = [{1,15100},{3,7550}],extra_attr = [{21,227},{56,755},{51,745}],suit = 6051};

get_draconic_equip_info(7708614) ->
	#base_draconic_equip{id = 7708614,name = "绝翼龙翼之灵",pos = 8,stage = 14,color = 6,strong = 100,base_attr = [{1,16300},{3,8150}],extra_attr = [{21,245},{56,815},{51,930}],suit = 6061};

get_draconic_equip_info(7708615) ->
	#base_draconic_equip{id = 7708615,name = "恐暴龙翼之灵",pos = 8,stage = 15,color = 6,strong = 100,base_attr = [{1,20000},{3,10000}],extra_attr = [{21,300},{56,1000},{51,1165}],suit = 6071};

get_draconic_equip_info(7709301) ->
	#base_draconic_equip{id = 7709301,name = "莱亚龙鳞之灵",pos = 9,stage = 1,color = 3,strong = 100,base_attr = [{4,90},{8,72}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709302) ->
	#base_draconic_equip{id = 7709302,name = "西锋龙鳞之灵",pos = 9,stage = 2,color = 3,strong = 100,base_attr = [{4,150},{8,120}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709303) ->
	#base_draconic_equip{id = 7709303,name = "棘甲龙鳞之灵",pos = 9,stage = 3,color = 3,strong = 100,base_attr = [{4,225},{8,180}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709304) ->
	#base_draconic_equip{id = 7709304,name = "风漂龙鳞之灵",pos = 9,stage = 4,color = 3,strong = 100,base_attr = [{4,315},{8,252}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709305) ->
	#base_draconic_equip{id = 7709305,name = "异特龙鳞之灵",pos = 9,stage = 5,color = 3,strong = 100,base_attr = [{4,420},{8,336}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709306) ->
	#base_draconic_equip{id = 7709306,name = "迅猛龙鳞之灵",pos = 9,stage = 6,color = 3,strong = 100,base_attr = [{4,540},{8,432}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709307) ->
	#base_draconic_equip{id = 7709307,name = "冥噬龙鳞之灵",pos = 9,stage = 7,color = 3,strong = 100,base_attr = [{4,675},{8,540}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709308) ->
	#base_draconic_equip{id = 7709308,name = "荒海龙鳞之灵",pos = 9,stage = 8,color = 3,strong = 100,base_attr = [{4,825},{8,660}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709309) ->
	#base_draconic_equip{id = 7709309,name = "暗鳞龙鳞之灵",pos = 9,stage = 9,color = 3,strong = 100,base_attr = [{4,1125},{8,900}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709310) ->
	#base_draconic_equip{id = 7709310,name = "黑煌龙鳞之灵",pos = 9,stage = 10,color = 3,strong = 100,base_attr = [{4,1245},{8,996}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709311) ->
	#base_draconic_equip{id = 7709311,name = "雷猎龙鳞之灵",pos = 9,stage = 11,color = 3,strong = 100,base_attr = [{4,1635},{8,1308}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709312) ->
	#base_draconic_equip{id = 7709312,name = "天辉龙鳞之灵",pos = 9,stage = 12,color = 3,strong = 100,base_attr = [{4,1815},{8,1452}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709313) ->
	#base_draconic_equip{id = 7709313,name = "苍穹龙鳞之灵",pos = 9,stage = 13,color = 3,strong = 100,base_attr = [{4,2265},{8,1812}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709314) ->
	#base_draconic_equip{id = 7709314,name = "绝翼龙鳞之灵",pos = 9,stage = 14,color = 3,strong = 100,base_attr = [{4,2445},{8,1956}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709315) ->
	#base_draconic_equip{id = 7709315,name = "恐暴龙鳞之灵",pos = 9,stage = 15,color = 3,strong = 100,base_attr = [{4,3000},{8,2400}],extra_attr = [],suit = 0};

get_draconic_equip_info(7709401) ->
	#base_draconic_equip{id = 7709401,name = "莱亚龙鳞之灵",pos = 9,stage = 1,color = 4,strong = 100,base_attr = [{4,150},{8,120}],extra_attr = [{19,1},{37,8}],suit = 4011};

get_draconic_equip_info(7709402) ->
	#base_draconic_equip{id = 7709402,name = "西锋龙鳞之灵",pos = 9,stage = 2,color = 4,strong = 100,base_attr = [{4,250},{8,200}],extra_attr = [{19,2},{37,13}],suit = 4021};

get_draconic_equip_info(7709403) ->
	#base_draconic_equip{id = 7709403,name = "棘甲龙鳞之灵",pos = 9,stage = 3,color = 4,strong = 100,base_attr = [{4,375},{8,300}],extra_attr = [{19,3},{37,19},{50,20}],suit = 4031};

get_draconic_equip_info(7709404) ->
	#base_draconic_equip{id = 7709404,name = "风漂龙鳞之灵",pos = 9,stage = 4,color = 4,strong = 100,base_attr = [{4,525},{8,420}],extra_attr = [{19,4},{37,26},{50,40}],suit = 4041};

get_draconic_equip_info(7709405) ->
	#base_draconic_equip{id = 7709405,name = "异特龙鳞之灵",pos = 9,stage = 5,color = 4,strong = 100,base_attr = [{4,700},{8,560}],extra_attr = [{19,5},{37,35},{50,50}],suit = 4051};

get_draconic_equip_info(7709406) ->
	#base_draconic_equip{id = 7709406,name = "迅猛龙鳞之灵",pos = 9,stage = 6,color = 4,strong = 100,base_attr = [{4,900},{8,720}],extra_attr = [{19,7},{37,45},{50,71}],suit = 4061};

get_draconic_equip_info(7709407) ->
	#base_draconic_equip{id = 7709407,name = "冥噬龙鳞之灵",pos = 9,stage = 7,color = 4,strong = 100,base_attr = [{4,1125},{8,900}],extra_attr = [{19,9},{37,56},{50,89}],suit = 4071};

get_draconic_equip_info(7709408) ->
	#base_draconic_equip{id = 7709408,name = "荒海龙鳞之灵",pos = 9,stage = 8,color = 4,strong = 100,base_attr = [{4,1375},{8,1100}],extra_attr = [{19,10},{37,69},{50,110}],suit = 4081};

get_draconic_equip_info(7709409) ->
	#base_draconic_equip{id = 7709409,name = "暗鳞龙鳞之灵",pos = 9,stage = 9,color = 4,strong = 100,base_attr = [{4,1875},{8,1500}],extra_attr = [{19,14},{37,94},{50,138}],suit = 4091};

get_draconic_equip_info(7709410) ->
	#base_draconic_equip{id = 7709410,name = "黑煌龙鳞之灵",pos = 9,stage = 10,color = 4,strong = 100,base_attr = [{4,2075},{8,1660}],extra_attr = [{19,16},{37,104},{50,175}],suit = 4101};

get_draconic_equip_info(7709411) ->
	#base_draconic_equip{id = 7709411,name = "雷猎龙鳞之灵",pos = 9,stage = 11,color = 4,strong = 100,base_attr = [{4,2725},{8,2180}],extra_attr = [{19,21},{37,136},{50,220}],suit = 4111};

get_draconic_equip_info(7709412) ->
	#base_draconic_equip{id = 7709412,name = "天辉龙鳞之灵",pos = 9,stage = 12,color = 4,strong = 100,base_attr = [{4,3025},{8,2420}],extra_attr = [{19,23},{37,151},{50,271}],suit = 4121};

get_draconic_equip_info(7709413) ->
	#base_draconic_equip{id = 7709413,name = "苍穹龙鳞之灵",pos = 9,stage = 13,color = 4,strong = 100,base_attr = [{4,3775},{8,3020}],extra_attr = [{19,28},{37,189},{50,339}],suit = 4131};

get_draconic_equip_info(7709414) ->
	#base_draconic_equip{id = 7709414,name = "绝翼龙鳞之灵",pos = 9,stage = 14,color = 4,strong = 100,base_attr = [{4,4075},{8,3260}],extra_attr = [{19,31},{37,204},{50,425}],suit = 4141};

get_draconic_equip_info(7709415) ->
	#base_draconic_equip{id = 7709415,name = "恐暴龙鳞之灵",pos = 9,stage = 15,color = 4,strong = 100,base_attr = [{4,5000},{8,4000}],extra_attr = [{19,38},{37,250},{50,530}],suit = 4151};

get_draconic_equip_info(7709503) ->
	#base_draconic_equip{id = 7709503,name = "异特龙鳞之灵",pos = 9,stage = 3,color = 5,strong = 100,base_attr = [{4,750},{8,600}],extra_attr = [{19,6},{37,38},{50,28},{52,28}],suit = 5001};

get_draconic_equip_info(7709505) ->
	#base_draconic_equip{id = 7709505,name = "异特龙鳞之灵",pos = 9,stage = 5,color = 5,strong = 100,base_attr = [{4,1400},{8,1120}],extra_attr = [{19,11},{37,70},{50,70},{52,70}],suit = 5011};

get_draconic_equip_info(7709506) ->
	#base_draconic_equip{id = 7709506,name = "迅猛龙鳞之灵",pos = 9,stage = 6,color = 5,strong = 100,base_attr = [{4,1800},{8,1440}],extra_attr = [{19,14},{37,90},{50,100},{52,100}],suit = 5021};

get_draconic_equip_info(7709507) ->
	#base_draconic_equip{id = 7709507,name = "冥噬龙鳞之灵",pos = 9,stage = 7,color = 5,strong = 100,base_attr = [{4,2250},{8,1800}],extra_attr = [{19,17},{37,113},{50,125},{52,125}],suit = 5031};

get_draconic_equip_info(7709508) ->
	#base_draconic_equip{id = 7709508,name = "荒海龙鳞之灵",pos = 9,stage = 8,color = 5,strong = 100,base_attr = [{4,2750},{8,2200}],extra_attr = [{19,21},{37,138},{50,155},{52,155}],suit = 5041};

get_draconic_equip_info(7709509) ->
	#base_draconic_equip{id = 7709509,name = "暗鳞龙鳞之灵",pos = 9,stage = 9,color = 5,strong = 100,base_attr = [{4,3750},{8,3000}],extra_attr = [{19,28},{37,188},{50,195},{52,195}],suit = 5051};

get_draconic_equip_info(7709510) ->
	#base_draconic_equip{id = 7709510,name = "黑煌龙鳞之灵",pos = 9,stage = 10,color = 5,strong = 100,base_attr = [{4,4150},{8,3320}],extra_attr = [{19,31},{37,208},{50,245},{52,245}],suit = 5061};

get_draconic_equip_info(7709511) ->
	#base_draconic_equip{id = 7709511,name = "雷猎龙鳞之灵",pos = 9,stage = 11,color = 5,strong = 100,base_attr = [{4,5450},{8,4360}],extra_attr = [{19,41},{37,273},{50,305},{52,305}],suit = 5071};

get_draconic_equip_info(7709512) ->
	#base_draconic_equip{id = 7709512,name = "天辉龙鳞之灵",pos = 9,stage = 12,color = 5,strong = 100,base_attr = [{4,6050},{8,4840}],extra_attr = [{19,46},{37,303},{50,380},{52,380}],suit = 5081};

get_draconic_equip_info(7709513) ->
	#base_draconic_equip{id = 7709513,name = "苍穹龙鳞之灵",pos = 9,stage = 13,color = 5,strong = 100,base_attr = [{4,7550},{8,6040}],extra_attr = [{19,57},{37,378},{50,475},{52,475}],suit = 5091};

get_draconic_equip_info(7709514) ->
	#base_draconic_equip{id = 7709514,name = "绝翼龙鳞之灵",pos = 9,stage = 14,color = 5,strong = 100,base_attr = [{4,8150},{8,6520}],extra_attr = [{19,61},{37,408},{50,595},{52,595}],suit = 5101};

get_draconic_equip_info(7709515) ->
	#base_draconic_equip{id = 7709515,name = "恐暴龙鳞之灵",pos = 9,stage = 15,color = 5,strong = 100,base_attr = [{4,10000},{8,8000}],extra_attr = [{19,75},{37,500},{50,745},{52,745}],suit = 5111};

get_draconic_equip_info(7709609) ->
	#base_draconic_equip{id = 7709609,name = "暗鳞龙鳞之灵",pos = 9,stage = 9,color = 6,strong = 100,base_attr = [{4,7500},{8,6000}],extra_attr = [{19,56},{37,375},{50,305},{52,305}],suit = 6011};

get_draconic_equip_info(7709610) ->
	#base_draconic_equip{id = 7709610,name = "黑煌龙鳞之灵",pos = 9,stage = 10,color = 6,strong = 100,base_attr = [{4,8300},{8,6640}],extra_attr = [{19,62},{37,415},{50,380},{52,380}],suit = 6021};

get_draconic_equip_info(7709611) ->
	#base_draconic_equip{id = 7709611,name = "雷猎龙鳞之灵",pos = 9,stage = 11,color = 6,strong = 100,base_attr = [{4,10900},{8,8720}],extra_attr = [{19,82},{37,545},{50,475},{52,475}],suit = 6031};

get_draconic_equip_info(7709612) ->
	#base_draconic_equip{id = 7709612,name = "天辉龙鳞之灵",pos = 9,stage = 12,color = 6,strong = 100,base_attr = [{4,12100},{8,9680}],extra_attr = [{19,91},{37,605},{50,595},{52,595}],suit = 6041};

get_draconic_equip_info(7709613) ->
	#base_draconic_equip{id = 7709613,name = "苍穹龙鳞之灵",pos = 9,stage = 13,color = 6,strong = 100,base_attr = [{4,15100},{8,12080}],extra_attr = [{19,113},{37,755},{50,745},{52,745}],suit = 6051};

get_draconic_equip_info(7709614) ->
	#base_draconic_equip{id = 7709614,name = "绝翼龙鳞之灵",pos = 9,stage = 14,color = 6,strong = 100,base_attr = [{4,16300},{8,13040}],extra_attr = [{19,122},{37,815},{50,930},{52,930}],suit = 6061};

get_draconic_equip_info(7709615) ->
	#base_draconic_equip{id = 7709615,name = "恐暴龙鳞之灵",pos = 9,stage = 15,color = 6,strong = 100,base_attr = [{4,20000},{8,16000}],extra_attr = [{19,150},{37,1000},{50,1165},{52,1165}],suit = 6071};

get_draconic_equip_info(7710301) ->
	#base_draconic_equip{id = 7710301,name = "莱亚龙爪之灵",pos = 10,stage = 1,color = 3,strong = 100,base_attr = [{3,90},{7,90}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710302) ->
	#base_draconic_equip{id = 7710302,name = "西锋龙爪之灵",pos = 10,stage = 2,color = 3,strong = 100,base_attr = [{3,150},{7,150}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710303) ->
	#base_draconic_equip{id = 7710303,name = "棘甲龙爪之灵",pos = 10,stage = 3,color = 3,strong = 100,base_attr = [{3,225},{7,225}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710304) ->
	#base_draconic_equip{id = 7710304,name = "风漂龙爪之灵",pos = 10,stage = 4,color = 3,strong = 100,base_attr = [{3,315},{7,315}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710305) ->
	#base_draconic_equip{id = 7710305,name = "异特龙爪之灵",pos = 10,stage = 5,color = 3,strong = 100,base_attr = [{3,420},{7,420}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710306) ->
	#base_draconic_equip{id = 7710306,name = "迅猛龙爪之灵",pos = 10,stage = 6,color = 3,strong = 100,base_attr = [{3,540},{7,540}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710307) ->
	#base_draconic_equip{id = 7710307,name = "冥噬龙爪之灵",pos = 10,stage = 7,color = 3,strong = 100,base_attr = [{3,675},{7,675}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710308) ->
	#base_draconic_equip{id = 7710308,name = "荒海龙爪之灵",pos = 10,stage = 8,color = 3,strong = 100,base_attr = [{3,825},{7,825}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710309) ->
	#base_draconic_equip{id = 7710309,name = "暗鳞龙爪之灵",pos = 10,stage = 9,color = 3,strong = 100,base_attr = [{3,1125},{7,1125}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710310) ->
	#base_draconic_equip{id = 7710310,name = "黑煌龙爪之灵",pos = 10,stage = 10,color = 3,strong = 100,base_attr = [{3,1245},{7,1245}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710311) ->
	#base_draconic_equip{id = 7710311,name = "雷猎龙爪之灵",pos = 10,stage = 11,color = 3,strong = 100,base_attr = [{3,1635},{7,1635}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710312) ->
	#base_draconic_equip{id = 7710312,name = "天辉龙爪之灵",pos = 10,stage = 12,color = 3,strong = 100,base_attr = [{3,1815},{7,1815}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710313) ->
	#base_draconic_equip{id = 7710313,name = "苍穹龙爪之灵",pos = 10,stage = 13,color = 3,strong = 100,base_attr = [{3,2265},{7,2265}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710314) ->
	#base_draconic_equip{id = 7710314,name = "绝翼龙爪之灵",pos = 10,stage = 14,color = 3,strong = 100,base_attr = [{3,2445},{7,2445}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710315) ->
	#base_draconic_equip{id = 7710315,name = "恐暴龙爪之灵",pos = 10,stage = 15,color = 3,strong = 100,base_attr = [{3,3000},{7,3000}],extra_attr = [],suit = 0};

get_draconic_equip_info(7710401) ->
	#base_draconic_equip{id = 7710401,name = "莱亚龙爪之灵",pos = 10,stage = 1,color = 4,strong = 100,base_attr = [{3,150},{7,150}],extra_attr = [{21,2},{17,3}],suit = 4011};

get_draconic_equip_info(7710402) ->
	#base_draconic_equip{id = 7710402,name = "西锋龙爪之灵",pos = 10,stage = 2,color = 4,strong = 100,base_attr = [{3,250},{7,250}],extra_attr = [{21,4},{17,5}],suit = 4021};

get_draconic_equip_info(7710403) ->
	#base_draconic_equip{id = 7710403,name = "棘甲龙爪之灵",pos = 10,stage = 3,color = 4,strong = 100,base_attr = [{3,375},{7,375}],extra_attr = [{21,6},{17,8},{51,20}],suit = 4031};

get_draconic_equip_info(7710404) ->
	#base_draconic_equip{id = 7710404,name = "风漂龙爪之灵",pos = 10,stage = 4,color = 4,strong = 100,base_attr = [{3,525},{7,525}],extra_attr = [{21,8},{17,11},{51,40}],suit = 4041};

get_draconic_equip_info(7710405) ->
	#base_draconic_equip{id = 7710405,name = "异特龙爪之灵",pos = 10,stage = 5,color = 4,strong = 100,base_attr = [{3,700},{7,700}],extra_attr = [{21,11},{17,14},{51,50}],suit = 4051};

get_draconic_equip_info(7710406) ->
	#base_draconic_equip{id = 7710406,name = "迅猛龙爪之灵",pos = 10,stage = 6,color = 4,strong = 100,base_attr = [{3,900},{7,900}],extra_attr = [{21,14},{17,18},{51,71}],suit = 4061};

get_draconic_equip_info(7710407) ->
	#base_draconic_equip{id = 7710407,name = "冥噬龙爪之灵",pos = 10,stage = 7,color = 4,strong = 100,base_attr = [{3,1125},{7,1125}],extra_attr = [{21,17},{17,23},{51,89}],suit = 4071};

get_draconic_equip_info(7710408) ->
	#base_draconic_equip{id = 7710408,name = "荒海龙爪之灵",pos = 10,stage = 8,color = 4,strong = 100,base_attr = [{3,1375},{7,1375}],extra_attr = [{21,21},{17,28},{51,110}],suit = 4081};

get_draconic_equip_info(7710409) ->
	#base_draconic_equip{id = 7710409,name = "暗鳞龙爪之灵",pos = 10,stage = 9,color = 4,strong = 100,base_attr = [{3,1875},{7,1875}],extra_attr = [{21,28},{17,38},{51,138}],suit = 4091};

get_draconic_equip_info(7710410) ->
	#base_draconic_equip{id = 7710410,name = "黑煌龙爪之灵",pos = 10,stage = 10,color = 4,strong = 100,base_attr = [{3,2075},{7,2075}],extra_attr = [{21,31},{17,42},{51,175}],suit = 4101};

get_draconic_equip_info(7710411) ->
	#base_draconic_equip{id = 7710411,name = "雷猎龙爪之灵",pos = 10,stage = 11,color = 4,strong = 100,base_attr = [{3,2725},{7,2725}],extra_attr = [{21,41},{17,55},{51,220}],suit = 4111};

get_draconic_equip_info(7710412) ->
	#base_draconic_equip{id = 7710412,name = "天辉龙爪之灵",pos = 10,stage = 12,color = 4,strong = 100,base_attr = [{3,3025},{7,3025}],extra_attr = [{21,46},{17,61},{51,271}],suit = 4121};

get_draconic_equip_info(7710413) ->
	#base_draconic_equip{id = 7710413,name = "苍穹龙爪之灵",pos = 10,stage = 13,color = 4,strong = 100,base_attr = [{3,3775},{7,3775}],extra_attr = [{21,57},{17,76},{51,339}],suit = 4131};

get_draconic_equip_info(7710414) ->
	#base_draconic_equip{id = 7710414,name = "绝翼龙爪之灵",pos = 10,stage = 14,color = 4,strong = 100,base_attr = [{3,4075},{7,4075}],extra_attr = [{21,61},{17,82},{51,425}],suit = 4141};

get_draconic_equip_info(7710415) ->
	#base_draconic_equip{id = 7710415,name = "恐暴龙爪之灵",pos = 10,stage = 15,color = 4,strong = 100,base_attr = [{3,5000},{7,5000}],extra_attr = [{21,75},{17,100},{51,530}],suit = 4151};

get_draconic_equip_info(7710503) ->
	#base_draconic_equip{id = 7710503,name = "异特龙爪之灵",pos = 10,stage = 3,color = 5,strong = 100,base_attr = [{3,750},{7,750}],extra_attr = [{21,12},{17,15},{51,28},{52,28}],suit = 5001};

get_draconic_equip_info(7710505) ->
	#base_draconic_equip{id = 7710505,name = "异特龙爪之灵",pos = 10,stage = 5,color = 5,strong = 100,base_attr = [{3,1400},{7,1400}],extra_attr = [{21,21},{17,28},{51,70},{52,70}],suit = 5011};

get_draconic_equip_info(7710506) ->
	#base_draconic_equip{id = 7710506,name = "迅猛龙爪之灵",pos = 10,stage = 6,color = 5,strong = 100,base_attr = [{3,1800},{7,1800}],extra_attr = [{21,27},{17,36},{51,100},{52,100}],suit = 5021};

get_draconic_equip_info(7710507) ->
	#base_draconic_equip{id = 7710507,name = "冥噬龙爪之灵",pos = 10,stage = 7,color = 5,strong = 100,base_attr = [{3,2250},{7,2250}],extra_attr = [{21,34},{17,45},{51,125},{52,125}],suit = 5031};

get_draconic_equip_info(7710508) ->
	#base_draconic_equip{id = 7710508,name = "荒海龙爪之灵",pos = 10,stage = 8,color = 5,strong = 100,base_attr = [{3,2750},{7,2750}],extra_attr = [{21,42},{17,55},{51,155},{52,155}],suit = 5041};

get_draconic_equip_info(7710509) ->
	#base_draconic_equip{id = 7710509,name = "暗鳞龙爪之灵",pos = 10,stage = 9,color = 5,strong = 100,base_attr = [{3,3750},{7,3750}],extra_attr = [{21,57},{17,75},{51,195},{52,195}],suit = 5051};

get_draconic_equip_info(7710510) ->
	#base_draconic_equip{id = 7710510,name = "黑煌龙爪之灵",pos = 10,stage = 10,color = 5,strong = 100,base_attr = [{3,4150},{7,4150}],extra_attr = [{21,63},{17,83},{51,245},{52,245}],suit = 5061};

get_draconic_equip_info(7710511) ->
	#base_draconic_equip{id = 7710511,name = "雷猎龙爪之灵",pos = 10,stage = 11,color = 5,strong = 100,base_attr = [{3,5450},{7,5450}],extra_attr = [{21,82},{17,109},{51,305},{52,305}],suit = 5071};

get_draconic_equip_info(7710512) ->
	#base_draconic_equip{id = 7710512,name = "天辉龙爪之灵",pos = 10,stage = 12,color = 5,strong = 100,base_attr = [{3,6050},{7,6050}],extra_attr = [{21,91},{17,121},{51,380},{52,380}],suit = 5081};

get_draconic_equip_info(7710513) ->
	#base_draconic_equip{id = 7710513,name = "苍穹龙爪之灵",pos = 10,stage = 13,color = 5,strong = 100,base_attr = [{3,7550},{7,7550}],extra_attr = [{21,114},{17,151},{51,475},{52,475}],suit = 5091};

get_draconic_equip_info(7710514) ->
	#base_draconic_equip{id = 7710514,name = "绝翼龙爪之灵",pos = 10,stage = 14,color = 5,strong = 100,base_attr = [{3,8150},{7,8150}],extra_attr = [{21,123},{17,163},{51,595},{52,595}],suit = 5101};

get_draconic_equip_info(7710515) ->
	#base_draconic_equip{id = 7710515,name = "恐暴龙爪之灵",pos = 10,stage = 15,color = 5,strong = 100,base_attr = [{3,10000},{7,10000}],extra_attr = [{21,150},{17,200},{51,745},{52,745}],suit = 5111};

get_draconic_equip_info(7710609) ->
	#base_draconic_equip{id = 7710609,name = "暗鳞龙爪之灵",pos = 10,stage = 9,color = 6,strong = 100,base_attr = [{3,7500},{7,7500}],extra_attr = [{21,113},{17,150},{51,305},{52,305}],suit = 6011};

get_draconic_equip_info(7710610) ->
	#base_draconic_equip{id = 7710610,name = "黑煌龙爪之灵",pos = 10,stage = 10,color = 6,strong = 100,base_attr = [{3,8300},{7,8300}],extra_attr = [{21,125},{17,166},{51,380},{52,380}],suit = 6021};

get_draconic_equip_info(7710611) ->
	#base_draconic_equip{id = 7710611,name = "雷猎龙爪之灵",pos = 10,stage = 11,color = 6,strong = 100,base_attr = [{3,10900},{7,10900}],extra_attr = [{21,164},{17,218},{51,475},{52,475}],suit = 6031};

get_draconic_equip_info(7710612) ->
	#base_draconic_equip{id = 7710612,name = "天辉龙爪之灵",pos = 10,stage = 12,color = 6,strong = 100,base_attr = [{3,12100},{7,12100}],extra_attr = [{21,182},{17,242},{51,595},{52,595}],suit = 6041};

get_draconic_equip_info(7710613) ->
	#base_draconic_equip{id = 7710613,name = "苍穹龙爪之灵",pos = 10,stage = 13,color = 6,strong = 100,base_attr = [{3,15100},{7,15100}],extra_attr = [{21,227},{17,302},{51,745},{52,745}],suit = 6051};

get_draconic_equip_info(7710614) ->
	#base_draconic_equip{id = 7710614,name = "绝翼龙爪之灵",pos = 10,stage = 14,color = 6,strong = 100,base_attr = [{3,16300},{7,16300}],extra_attr = [{21,245},{17,326},{51,930},{52,930}],suit = 6061};

get_draconic_equip_info(7710615) ->
	#base_draconic_equip{id = 7710615,name = "恐暴龙爪之灵",pos = 10,stage = 15,color = 6,strong = 100,base_attr = [{3,20000},{7,20000}],extra_attr = [{21,300},{17,400},{51,1165},{52,1165}],suit = 6071};

get_draconic_equip_info(7711301) ->
	#base_draconic_equip{id = 7711301,name = "莱亚龙力之核",pos = 11,stage = 1,color = 3,strong = 100,base_attr = [{1,135},{2,2700}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711302) ->
	#base_draconic_equip{id = 7711302,name = "西锋龙力之核",pos = 11,stage = 2,color = 3,strong = 100,base_attr = [{1,225},{2,4500}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711303) ->
	#base_draconic_equip{id = 7711303,name = "棘甲龙力之核",pos = 11,stage = 3,color = 3,strong = 100,base_attr = [{1,338},{2,6750}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711304) ->
	#base_draconic_equip{id = 7711304,name = "风漂龙力之核",pos = 11,stage = 4,color = 3,strong = 100,base_attr = [{1,473},{2,9450}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711305) ->
	#base_draconic_equip{id = 7711305,name = "异特龙力之核",pos = 11,stage = 5,color = 3,strong = 100,base_attr = [{1,630},{2,12600}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711306) ->
	#base_draconic_equip{id = 7711306,name = "迅猛龙力之核",pos = 11,stage = 6,color = 3,strong = 100,base_attr = [{1,810},{2,16200}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711307) ->
	#base_draconic_equip{id = 7711307,name = "冥噬龙力之核",pos = 11,stage = 7,color = 3,strong = 100,base_attr = [{1,1013},{2,20250}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711308) ->
	#base_draconic_equip{id = 7711308,name = "荒海龙力之核",pos = 11,stage = 8,color = 3,strong = 100,base_attr = [{1,1238},{2,24750}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711309) ->
	#base_draconic_equip{id = 7711309,name = "暗鳞龙力之核",pos = 11,stage = 9,color = 3,strong = 100,base_attr = [{1,1688},{2,33750}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711310) ->
	#base_draconic_equip{id = 7711310,name = "黑煌龙力之核",pos = 11,stage = 10,color = 3,strong = 100,base_attr = [{1,1868},{2,37350}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711311) ->
	#base_draconic_equip{id = 7711311,name = "雷猎龙力之核",pos = 11,stage = 11,color = 3,strong = 100,base_attr = [{1,2453},{2,49050}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711312) ->
	#base_draconic_equip{id = 7711312,name = "天辉龙力之核",pos = 11,stage = 12,color = 3,strong = 100,base_attr = [{1,2723},{2,54450}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711313) ->
	#base_draconic_equip{id = 7711313,name = "苍穹龙力之核",pos = 11,stage = 13,color = 3,strong = 100,base_attr = [{1,3398},{2,67950}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711314) ->
	#base_draconic_equip{id = 7711314,name = "绝翼龙力之核",pos = 11,stage = 14,color = 3,strong = 100,base_attr = [{1,3668},{2,73350}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711315) ->
	#base_draconic_equip{id = 7711315,name = "恐暴龙力之核",pos = 11,stage = 15,color = 3,strong = 100,base_attr = [{1,4500},{2,90000}],extra_attr = [],suit = 0};

get_draconic_equip_info(7711401) ->
	#base_draconic_equip{id = 7711401,name = "莱亚龙力之核",pos = 11,stage = 1,color = 4,strong = 100,base_attr = [{1,225},{2,4500}],extra_attr = [{19,2},{9,3}],suit = 4011};

get_draconic_equip_info(7711402) ->
	#base_draconic_equip{id = 7711402,name = "西锋龙力之核",pos = 11,stage = 2,color = 4,strong = 100,base_attr = [{1,375},{2,7500}],extra_attr = [{19,3},{9,5}],suit = 4021};

get_draconic_equip_info(7711403) ->
	#base_draconic_equip{id = 7711403,name = "棘甲龙力之核",pos = 11,stage = 3,color = 4,strong = 100,base_attr = [{1,563},{2,11250}],extra_attr = [{19,4},{9,8},{50,20},{51,20}],suit = 4031};

get_draconic_equip_info(7711404) ->
	#base_draconic_equip{id = 7711404,name = "风漂龙力之核",pos = 11,stage = 4,color = 4,strong = 100,base_attr = [{1,788},{2,15750}],extra_attr = [{19,5},{9,11},{50,40},{51,40}],suit = 4041};

get_draconic_equip_info(7711405) ->
	#base_draconic_equip{id = 7711405,name = "异特龙力之核",pos = 11,stage = 5,color = 4,strong = 100,base_attr = [{1,1050},{2,21000}],extra_attr = [{19,7},{9,14},{50,50},{51,50}],suit = 4051};

get_draconic_equip_info(7711406) ->
	#base_draconic_equip{id = 7711406,name = "迅猛龙力之核",pos = 11,stage = 6,color = 4,strong = 100,base_attr = [{1,1350},{2,27000}],extra_attr = [{19,9},{9,18},{50,71},{51,71}],suit = 4061};

get_draconic_equip_info(7711407) ->
	#base_draconic_equip{id = 7711407,name = "冥噬龙力之核",pos = 11,stage = 7,color = 4,strong = 100,base_attr = [{1,1688},{2,33750}],extra_attr = [{19,11},{9,23},{50,89},{51,89}],suit = 4071};

get_draconic_equip_info(7711408) ->
	#base_draconic_equip{id = 7711408,name = "荒海龙力之核",pos = 11,stage = 8,color = 4,strong = 100,base_attr = [{1,2063},{2,41250}],extra_attr = [{19,14},{9,28},{50,110},{51,110}],suit = 4081};

get_draconic_equip_info(7711409) ->
	#base_draconic_equip{id = 7711409,name = "暗鳞龙力之核",pos = 11,stage = 9,color = 4,strong = 100,base_attr = [{1,2813},{2,56250}],extra_attr = [{19,19},{9,38},{50,138},{51,138}],suit = 4091};

get_draconic_equip_info(7711410) ->
	#base_draconic_equip{id = 7711410,name = "黑煌龙力之核",pos = 11,stage = 10,color = 4,strong = 100,base_attr = [{1,3113},{2,62250}],extra_attr = [{19,21},{9,42},{50,175},{51,175}],suit = 4101};

get_draconic_equip_info(7711411) ->
	#base_draconic_equip{id = 7711411,name = "雷猎龙力之核",pos = 11,stage = 11,color = 4,strong = 100,base_attr = [{1,4088},{2,81750}],extra_attr = [{19,27},{9,55},{50,220},{51,220}],suit = 4111};

get_draconic_equip_info(7711412) ->
	#base_draconic_equip{id = 7711412,name = "天辉龙力之核",pos = 11,stage = 12,color = 4,strong = 100,base_attr = [{1,4538},{2,90750}],extra_attr = [{19,30},{9,61},{50,271},{51,271}],suit = 4121};

get_draconic_equip_info(7711413) ->
	#base_draconic_equip{id = 7711413,name = "苍穹龙力之核",pos = 11,stage = 13,color = 4,strong = 100,base_attr = [{1,5663},{2,113250}],extra_attr = [{19,38},{9,76},{50,339},{51,339}],suit = 4131};

get_draconic_equip_info(7711414) ->
	#base_draconic_equip{id = 7711414,name = "绝翼龙力之核",pos = 11,stage = 14,color = 4,strong = 100,base_attr = [{1,6113},{2,122250}],extra_attr = [{19,41},{9,82},{50,425},{51,425}],suit = 4141};

get_draconic_equip_info(7711415) ->
	#base_draconic_equip{id = 7711415,name = "恐暴龙力之核",pos = 11,stage = 15,color = 4,strong = 100,base_attr = [{1,7500},{2,150000}],extra_attr = [{19,50},{9,100},{50,530},{51,530}],suit = 4151};

get_draconic_equip_info(7711503) ->
	#base_draconic_equip{id = 7711503,name = "异特龙力之核",pos = 11,stage = 3,color = 5,strong = 100,base_attr = [{1,1125},{2,22500}],extra_attr = [{19,8},{9,15},{50,28},{51,28}],suit = 5001};

get_draconic_equip_info(7711505) ->
	#base_draconic_equip{id = 7711505,name = "异特龙力之核",pos = 11,stage = 5,color = 5,strong = 100,base_attr = [{1,2100},{2,42000}],extra_attr = [{19,14},{9,28},{50,70},{51,70}],suit = 5011};

get_draconic_equip_info(7711506) ->
	#base_draconic_equip{id = 7711506,name = "迅猛龙力之核",pos = 11,stage = 6,color = 5,strong = 100,base_attr = [{1,2700},{2,54000}],extra_attr = [{19,18},{9,36},{50,100},{51,100}],suit = 5021};

get_draconic_equip_info(7711507) ->
	#base_draconic_equip{id = 7711507,name = "冥噬龙力之核",pos = 11,stage = 7,color = 5,strong = 100,base_attr = [{1,3375},{2,67500}],extra_attr = [{19,23},{9,45},{50,125},{51,125}],suit = 5031};

get_draconic_equip_info(7711508) ->
	#base_draconic_equip{id = 7711508,name = "荒海龙力之核",pos = 11,stage = 8,color = 5,strong = 100,base_attr = [{1,4125},{2,82500}],extra_attr = [{19,28},{9,55},{50,155},{51,155}],suit = 5041};

get_draconic_equip_info(7711509) ->
	#base_draconic_equip{id = 7711509,name = "暗鳞龙力之核",pos = 11,stage = 9,color = 5,strong = 100,base_attr = [{1,5625},{2,112500}],extra_attr = [{19,38},{9,75},{50,195},{51,195}],suit = 5051};

get_draconic_equip_info(7711510) ->
	#base_draconic_equip{id = 7711510,name = "黑煌龙力之核",pos = 11,stage = 10,color = 5,strong = 100,base_attr = [{1,6225},{2,124500}],extra_attr = [{19,42},{9,83},{50,245},{51,245}],suit = 5061};

get_draconic_equip_info(7711511) ->
	#base_draconic_equip{id = 7711511,name = "雷猎龙力之核",pos = 11,stage = 11,color = 5,strong = 100,base_attr = [{1,8175},{2,163500}],extra_attr = [{19,55},{9,109},{50,305},{51,305}],suit = 5071};

get_draconic_equip_info(7711512) ->
	#base_draconic_equip{id = 7711512,name = "天辉龙力之核",pos = 11,stage = 12,color = 5,strong = 100,base_attr = [{1,9075},{2,181500}],extra_attr = [{19,61},{9,121},{50,380},{51,380}],suit = 5081};

get_draconic_equip_info(7711513) ->
	#base_draconic_equip{id = 7711513,name = "苍穹龙力之核",pos = 11,stage = 13,color = 5,strong = 100,base_attr = [{1,11325},{2,226500}],extra_attr = [{19,76},{9,151},{50,475},{51,475}],suit = 5091};

get_draconic_equip_info(7711514) ->
	#base_draconic_equip{id = 7711514,name = "绝翼龙力之核",pos = 11,stage = 14,color = 5,strong = 100,base_attr = [{1,12225},{2,244500}],extra_attr = [{19,82},{9,163},{50,595},{51,595}],suit = 5101};

get_draconic_equip_info(7711515) ->
	#base_draconic_equip{id = 7711515,name = "恐暴龙力之核",pos = 11,stage = 15,color = 5,strong = 100,base_attr = [{1,15000},{2,300000}],extra_attr = [{19,100},{9,200},{50,745},{51,745}],suit = 5111};

get_draconic_equip_info(7711609) ->
	#base_draconic_equip{id = 7711609,name = "暗鳞龙力之核",pos = 11,stage = 9,color = 6,strong = 100,base_attr = [{1,11250},{2,225000}],extra_attr = [{19,75},{9,150},{50,305},{51,305}],suit = 6011};

get_draconic_equip_info(7711610) ->
	#base_draconic_equip{id = 7711610,name = "黑煌龙力之核",pos = 11,stage = 10,color = 6,strong = 100,base_attr = [{1,12450},{2,249000}],extra_attr = [{19,83},{9,166},{50,380},{51,380}],suit = 6021};

get_draconic_equip_info(7711611) ->
	#base_draconic_equip{id = 7711611,name = "雷猎龙力之核",pos = 11,stage = 11,color = 6,strong = 100,base_attr = [{1,16350},{2,327000}],extra_attr = [{19,109},{9,218},{50,475},{51,475}],suit = 6031};

get_draconic_equip_info(7711612) ->
	#base_draconic_equip{id = 7711612,name = "天辉龙力之核",pos = 11,stage = 12,color = 6,strong = 100,base_attr = [{1,18150},{2,363000}],extra_attr = [{19,121},{9,242},{50,595},{51,595}],suit = 6041};

get_draconic_equip_info(7711613) ->
	#base_draconic_equip{id = 7711613,name = "苍穹龙力之核",pos = 11,stage = 13,color = 6,strong = 100,base_attr = [{1,22650},{2,453000}],extra_attr = [{19,151},{9,302},{50,745},{51,745}],suit = 6051};

get_draconic_equip_info(7711614) ->
	#base_draconic_equip{id = 7711614,name = "绝翼龙力之核",pos = 11,stage = 14,color = 6,strong = 100,base_attr = [{1,24450},{2,489000}],extra_attr = [{19,163},{9,326},{50,930},{51,930}],suit = 6061};

get_draconic_equip_info(7711615) ->
	#base_draconic_equip{id = 7711615,name = "恐暴龙力之核",pos = 11,stage = 15,color = 6,strong = 100,base_attr = [{1,30000},{2,600000}],extra_attr = [{19,200},{9,400},{50,1165},{51,1165}],suit = 6071};

get_draconic_equip_info(_Id) ->
	[].

get_all_equip(1,3) ->
[7701301,7702301,7703301,7704301,7705301,7706301,7707301,7708301,7709301,7710301,7711301];

get_all_equip(1,4) ->
[7701401,7702401,7703401,7704401,7705401,7706401,7707401,7708401,7709401,7710401,7711401];

get_all_equip(2,3) ->
[7701302,7702302,7703302,7704302,7705302,7706302,7707302,7708302,7709302,7710302,7711302];

get_all_equip(2,4) ->
[7701402,7702402,7703402,7704402,7705402,7706402,7707402,7708402,7709402,7710402,7711402];

get_all_equip(3,3) ->
[7701303,7702303,7703303,7704303,7705303,7706303,7707303,7708303,7709303,7710303,7711303];

get_all_equip(3,4) ->
[7701403,7702403,7703403,7704403,7705403,7706403,7707403,7708403,7709403,7710403,7711403];

get_all_equip(3,5) ->
[7701503,7702503,7703503,7704503,7705503,7706503,7707503,7708503,7709503,7710503,7711503];

get_all_equip(4,3) ->
[7701304,7702304,7703304,7704304,7705304,7706304,7707304,7708304,7709304,7710304,7711304];

get_all_equip(4,4) ->
[7701404,7702404,7703404,7704404,7705404,7706404,7707404,7708404,7709404,7710404,7711404];

get_all_equip(5,3) ->
[7701305,7702305,7703305,7704305,7705305,7706305,7707305,7708305,7709305,7710305,7711305];

get_all_equip(5,4) ->
[7701405,7702405,7703405,7704405,7705405,7706405,7707405,7708405,7709405,7710405,7711405];

get_all_equip(5,5) ->
[7701505,7702505,7703505,7704505,7705505,7706505,7707505,7708505,7709505,7710505,7711505];

get_all_equip(6,3) ->
[7701306,7702306,7703306,7704306,7705306,7706306,7707306,7708306,7709306,7710306,7711306];

get_all_equip(6,4) ->
[7701406,7702406,7703406,7704406,7705406,7706406,7707406,7708406,7709406,7710406,7711406];

get_all_equip(6,5) ->
[7701506,7702506,7703506,7704506,7705506,7706506,7707506,7708506,7709506,7710506,7711506];

get_all_equip(7,3) ->
[7701307,7702307,7703307,7704307,7705307,7706307,7707307,7708307,7709307,7710307,7711307];

get_all_equip(7,4) ->
[7701407,7702407,7703407,7704407,7705407,7706407,7707407,7708407,7709407,7710407,7711407];

get_all_equip(7,5) ->
[7701507,7702507,7703507,7704507,7705507,7706507,7707507,7708507,7709507,7710507,7711507];

get_all_equip(8,3) ->
[7701308,7702308,7703308,7704308,7705308,7706308,7707308,7708308,7709308,7710308,7711308];

get_all_equip(8,4) ->
[7701408,7702408,7703408,7704408,7705408,7706408,7707408,7708408,7709408,7710408,7711408];

get_all_equip(8,5) ->
[7701508,7702508,7703508,7704508,7705508,7706508,7707508,7708508,7709508,7710508,7711508];

get_all_equip(9,3) ->
[7701309,7702309,7703309,7704309,7705309,7706309,7707309,7708309,7709309,7710309,7711309];

get_all_equip(9,4) ->
[7701409,7702409,7703409,7704409,7705409,7706409,7707409,7708409,7709409,7710409,7711409];

get_all_equip(9,5) ->
[7701509,7702509,7703509,7704509,7705509,7706509,7707509,7708509,7709509,7710509,7711509];

get_all_equip(9,6) ->
[7701609,7702609,7703609,7704609,7705609,7706609,7707609,7708609,7709609,7710609,7711609];

get_all_equip(10,3) ->
[7701310,7702310,7703310,7704310,7705310,7706310,7707310,7708310,7709310,7710310,7711310];

get_all_equip(10,4) ->
[7701410,7702410,7703410,7704410,7705410,7706410,7707410,7708410,7709410,7710410,7711410];

get_all_equip(10,5) ->
[7701510,7702510,7703510,7704510,7705510,7706510,7707510,7708510,7709510,7710510,7711510];

get_all_equip(10,6) ->
[7701610,7702610,7703610,7704610,7705610,7706610,7707610,7708610,7709610,7710610,7711610];

get_all_equip(11,3) ->
[7701311,7702311,7703311,7704311,7705311,7706311,7707311,7708311,7709311,7710311,7711311];

get_all_equip(11,4) ->
[7701411,7702411,7703411,7704411,7705411,7706411,7707411,7708411,7709411,7710411,7711411];

get_all_equip(11,5) ->
[7701511,7702511,7703511,7704511,7705511,7706511,7707511,7708511,7709511,7710511,7711511];

get_all_equip(11,6) ->
[7701611,7702611,7703611,7704611,7705611,7706611,7707611,7708611,7709611,7710611,7711611];

get_all_equip(12,3) ->
[7701312,7702312,7703312,7704312,7705312,7706312,7707312,7708312,7709312,7710312,7711312];

get_all_equip(12,4) ->
[7701412,7702412,7703412,7704412,7705412,7706412,7707412,7708412,7709412,7710412,7711412];

get_all_equip(12,5) ->
[7701512,7702512,7703512,7704512,7705512,7706512,7707512,7708512,7709512,7710512,7711512];

get_all_equip(12,6) ->
[7701612,7702612,7703612,7704612,7705612,7706612,7707612,7708612,7709612,7710612,7711612];

get_all_equip(13,3) ->
[7701313,7702313,7703313,7704313,7705313,7706313,7707313,7708313,7709313,7710313,7711313];

get_all_equip(13,4) ->
[7701413,7702413,7703413,7704413,7705413,7706413,7707413,7708413,7709413,7710413,7711413];

get_all_equip(13,5) ->
[7701513,7702513,7703513,7704513,7705513,7706513,7707513,7708513,7709513,7710513,7711513];

get_all_equip(13,6) ->
[7701613,7702613,7703613,7704613,7705613,7706613,7707613,7708613,7709613,7710613,7711613];

get_all_equip(14,3) ->
[7701314,7702314,7703314,7704314,7705314,7706314,7707314,7708314,7709314,7710314,7711314];

get_all_equip(14,4) ->
[7701414,7702414,7703414,7704414,7705414,7706414,7707414,7708414,7709414,7710414,7711414];

get_all_equip(14,5) ->
[7701514,7702514,7703514,7704514,7705514,7706514,7707514,7708514,7709514,7710514,7711514];

get_all_equip(14,6) ->
[7701614,7702614,7703614,7704614,7705614,7706614,7707614,7708614,7709614,7710614,7711614];

get_all_equip(15,3) ->
[7701315,7702315,7703315,7704315,7705315,7706315,7707315,7708315,7709315,7710315,7711315];

get_all_equip(15,4) ->
[7701415,7702415,7703415,7704415,7705415,7706415,7707415,7708415,7709415,7710415,7711415];

get_all_equip(15,5) ->
[7701515,7702515,7703515,7704515,7705515,7706515,7707515,7708515,7709515,7710515,7711515];

get_all_equip(15,6) ->
[7701615,7702615,7703615,7704615,7705615,7706615,7707615,7708615,7709615,7710615,7711615];

get_all_equip(_Stage,_Color) ->
	[].

get_draconic_suit_info(4010) ->
	#base_draconic_suit{id = 4010,stage = 1,color = 4,name = "空眠守望",suit_type = 0,draconic = [7701401,7702401,7703401,7704401,7705401,7706401],attr = [{2,[{2,12000},{8,960},{38,80}]},{4,[{1,600},{5,960},{37,80}]},{6,[{4,1200},{2,19200},{10,12}]}],score = [{2,10800},{4,10800},{6,21600}]};

get_draconic_suit_info(4020) ->
	#base_draconic_suit{id = 4020,stage = 2,color = 4,name = "千刃守望",suit_type = 0,draconic = [7701402,7702402,7703402,7704402,7705402,7706402],attr = [{2,[{2,24000},{8,1920},{38,160}]},{4,[{1,1200},{5,1920},{37,160}]},{6,[{4,2400},{2,38400},{10,24}]}],score = [{2,21600},{4,21600},{6,43200}]};

get_draconic_suit_info(4030) ->
	#base_draconic_suit{id = 4030,stage = 3,color = 4,name = "北戈守望",suit_type = 0,draconic = [7701403,7702403,7703403,7704403,7705403,7706403],attr = [{2,[{2,36000},{8,2880},{38,240}]},{4,[{1,1800},{5,2880},{37,240}]},{6,[{4,3600},{2,57600},{10,36}]}],score = [{2,32400},{4,32400},{6,64800}]};

get_draconic_suit_info(4031) ->
	#base_draconic_suit{id = 4031,stage = 3,color = 4,name = "北戈龙裔",suit_type = 1,draconic = [7707403,7708403,7709403,7710403,7711403],attr = [{2,[{1,2520},{7,2880},{27,300}]},{4,[{2,50400},{6,2880},{28,300}]},{5,[{1,2880},{3,3600},{13,150}]}],score = [{2,39600},{4,39600},{5,64800}]};

get_draconic_suit_info(4040) ->
	#base_draconic_suit{id = 4040,stage = 4,color = 4,name = "苍炎守望",suit_type = 0,draconic = [7701404,7702404,7703404,7704404,7705404,7706404],attr = [{2,[{2,63000},{8,5040},{38,420}]},{4,[{1,3150},{5,5040},{37,420}]},{6,[{4,6300},{2,100800},{10,63}]}],score = [{2,56700},{4,56700},{6,113400}]};

get_draconic_suit_info(4050) ->
	#base_draconic_suit{id = 4050,stage = 5,color = 4,name = "伽夜守望",suit_type = 0,draconic = [7701405,7702405,7703405,7704405,7705405,7706405],attr = [{2,[{2,84000},{8,6720},{38,560}]},{4,[{1,4200},{5,6720},{37,560}]},{6,[{4,8400},{2,134400},{10,84}]}],score = [{2,75600},{4,75600},{6,151200}]};

get_draconic_suit_info(4051) ->
	#base_draconic_suit{id = 4051,stage = 5,color = 4,name = "伽夜龙裔",suit_type = 1,draconic = [7707405,7708405,7709405,7710405,7711405],attr = [{2,[{1,5880},{7,6720},{27,700}]},{4,[{2,117600},{6,6720},{28,700}]},{5,[{1,6720},{3,8400},{13,351}]}],score = [{2,92400},{4,92400},{5,151200}]};

get_draconic_suit_info(4060) ->
	#base_draconic_suit{id = 4060,stage = 6,color = 4,name = "雷冽守望",suit_type = 0,draconic = [7701406,7702406,7703406,7704406,7705406,7706406],attr = [{2,[{2,108000},{8,8640},{38,720}]},{4,[{1,5400},{5,8640},{37,720}]},{6,[{4,10800},{2,172800},{10,108}]}],score = [{2,97200},{4,97200},{6,194400}]};

get_draconic_suit_info(4061) ->
	#base_draconic_suit{id = 4061,stage = 6,color = 4,name = "雷冽龙裔",suit_type = 1,draconic = [7707406,7708406,7709406,7710406,7711406],attr = [{2,[{1,7560},{7,8640},{27,900}]},{4,[{2,151200},{6,8640},{28,900}]},{5,[{1,8640},{3,10800},{13,451}]}],score = [{2,118800},{4,118800},{5,194400}]};

get_draconic_suit_info(4070) ->
	#base_draconic_suit{id = 4070,stage = 7,color = 4,name = "胧月守望",suit_type = 0,draconic = [7701407,7702407,7703407,7704407,7705407,7706407],attr = [{2,[{2,135000},{8,10800},{38,900}]},{4,[{1,6750},{5,10800},{37,900}]},{6,[{4,13500},{2,216000},{10,135}]}],score = [{2,121500},{4,121500},{6,243000}]};

get_draconic_suit_info(4071) ->
	#base_draconic_suit{id = 4071,stage = 7,color = 4,name = "胧月龙裔",suit_type = 1,draconic = [7707407,7708407,7709407,7710407,7711407],attr = [{2,[{1,9450},{7,10800},{27,1125}]},{4,[{2,189000},{6,10800},{28,1125}]},{5,[{1,10800},{3,13500},{13,564}]}],score = [{2,148500},{4,148500},{5,243000}]};

get_draconic_suit_info(4080) ->
	#base_draconic_suit{id = 4080,stage = 8,color = 4,name = "虹刺守望",suit_type = 0,draconic = [7701408,7702408,7703408,7704408,7705408,7706408],attr = [{2,[{2,165000},{8,13200},{38,1100}]},{4,[{1,8250},{5,13200},{37,1100}]},{6,[{4,16500},{2,264000},{10,165}]}],score = [{2,148500},{4,148500},{6,297000}]};

get_draconic_suit_info(4081) ->
	#base_draconic_suit{id = 4081,stage = 8,color = 4,name = "虹刺龙裔",suit_type = 1,draconic = [7707408,7708408,7709408,7710408,7711408],attr = [{2,[{1,11550},{7,13200},{27,1375}]},{4,[{2,231000},{6,13200},{28,1375}]},{5,[{1,13200},{3,16500},{13,689}]}],score = [{2,181500},{4,181500},{5,297000}]};

get_draconic_suit_info(4090) ->
	#base_draconic_suit{id = 4090,stage = 9,color = 4,name = "咆哮守望",suit_type = 0,draconic = [7701409,7702409,7703409,7704409,7705409,7706409],attr = [{2,[{2,225000},{8,18000},{38,1500}]},{4,[{1,11250},{5,18000},{37,1500}]},{6,[{4,22500},{2,360000},{10,225}]}],score = [{2,202500},{4,202500},{6,405000}]};

get_draconic_suit_info(4091) ->
	#base_draconic_suit{id = 4091,stage = 9,color = 4,name = "咆哮龙裔",suit_type = 1,draconic = [7707409,7708409,7709409,7710409,7711409],attr = [{2,[{1,15750},{7,18000},{27,1875}]},{4,[{2,315000},{6,18000},{28,1875}]},{5,[{1,18000},{3,22500},{13,940}]}],score = [{2,247500},{4,247500},{5,405000}]};

get_draconic_suit_info(4100) ->
	#base_draconic_suit{id = 4100,stage = 10,color = 4,name = "影灭守望",suit_type = 0,draconic = [7701410,7702410,7703410,7704410,7705410,7706410],attr = [{2,[{2,249000},{8,19920},{38,1660}]},{4,[{1,12450},{5,19920},{37,1660}]},{6,[{4,24900},{2,398400},{10,249}]}],score = [{2,224100},{4,224100},{6,448200}]};

get_draconic_suit_info(4101) ->
	#base_draconic_suit{id = 4101,stage = 10,color = 4,name = "影灭龙裔",suit_type = 1,draconic = [7707410,7708410,7709410,7710410,7711410],attr = [{2,[{1,17430},{7,19920},{27,2075}]},{4,[{2,348600},{6,19920},{28,2075}]},{5,[{1,19920},{3,24900},{13,1040}]}],score = [{2,273900},{4,273900},{5,448200}]};

get_draconic_suit_info(4110) ->
	#base_draconic_suit{id = 4110,stage = 11,color = 4,name = "挥沌守望",suit_type = 0,draconic = [7701411,7702411,7703411,7704411,7705411,7706411],attr = [{2,[{2,327000},{8,26160},{38,2180}]},{4,[{1,16350},{5,26160},{37,2180}]},{6,[{4,32700},{2,523200},{10,327}]}],score = [{2,294300},{4,294300},{6,588600}]};

get_draconic_suit_info(4111) ->
	#base_draconic_suit{id = 4111,stage = 11,color = 4,name = "挥沌龙裔",suit_type = 1,draconic = [7707411,7708411,7709411,7710411,7711411],attr = [{2,[{1,22890},{7,26160},{27,2725}]},{4,[{2,457800},{6,26160},{28,2725}]},{5,[{1,26160},{3,32700},{13,1366}]}],score = [{2,359700},{4,359700},{5,588600}]};

get_draconic_suit_info(4120) ->
	#base_draconic_suit{id = 4120,stage = 12,color = 4,name = "灾祸守望",suit_type = 0,draconic = [7701412,7702412,7703412,7704412,7705412,7706412],attr = [{2,[{2,363000},{8,29040},{38,2420}]},{4,[{1,18150},{5,29040},{37,2420}]},{6,[{4,36300},{2,580800},{10,363}]}],score = [{2,326700},{4,326700},{6,653400}]};

get_draconic_suit_info(4121) ->
	#base_draconic_suit{id = 4121,stage = 12,color = 4,name = "灾祸龙裔",suit_type = 1,draconic = [7707412,7708412,7709412,7710412,7711412],attr = [{2,[{1,25410},{7,29040},{27,3025}]},{4,[{2,508200},{6,29040},{28,3025}]},{5,[{1,29040},{3,36300},{13,1516}]}],score = [{2,399300},{4,399300},{5,653400}]};

get_draconic_suit_info(4130) ->
	#base_draconic_suit{id = 4130,stage = 13,color = 4,name = "血垠守望",suit_type = 0,draconic = [7701413,7702413,7703413,7704413,7705413,7706413],attr = [{2,[{2,453000},{8,36240},{38,3020}]},{4,[{1,22650},{5,36240},{37,3020}]},{6,[{4,45300},{2,724800},{10,453}]}],score = [{2,407700},{4,407700},{6,815400}]};

get_draconic_suit_info(4131) ->
	#base_draconic_suit{id = 4131,stage = 13,color = 4,name = "血垠龙裔",suit_type = 1,draconic = [7707413,7708413,7709413,7710413,7711413],attr = [{2,[{1,31710},{7,36240},{27,3775}]},{4,[{2,634200},{6,36240},{28,3775}]},{5,[{1,36240},{3,45300},{13,1892}]}],score = [{2,498300},{4,498300},{5,815400}]};

get_draconic_suit_info(4140) ->
	#base_draconic_suit{id = 4140,stage = 14,color = 4,name = "逆鳞守望",suit_type = 0,draconic = [7701414,7702414,7703414,7704414,7705414,7706414],attr = [{2,[{2,489000},{8,39120},{38,3260}]},{4,[{1,24450},{5,39120},{37,3260}]},{6,[{4,48900},{2,782400},{10,489}]}],score = [{2,440100},{4,440100},{6,880200}]};

get_draconic_suit_info(4141) ->
	#base_draconic_suit{id = 4141,stage = 14,color = 4,name = "逆鳞龙裔",suit_type = 1,draconic = [7707414,7708414,7709414,7710414,7711414],attr = [{2,[{1,34230},{7,39120},{27,4075}]},{4,[{2,684600},{6,39120},{28,4075}]},{5,[{1,39120},{3,48900},{13,2042}]}],score = [{2,537900},{4,537900},{5,880200}]};

get_draconic_suit_info(4150) ->
	#base_draconic_suit{id = 4150,stage = 15,color = 4,name = "掠夺守望",suit_type = 0,draconic = [7701415,7702415,7703415,7704415,7705415,7706415],attr = [{2,[{2,600000},{8,48000},{38,4000}]},{4,[{1,30000},{5,48000},{37,4000}]},{6,[{4,60000},{2,960000},{10,600}]}],score = [{2,540000},{4,540000},{6,1080000}]};

get_draconic_suit_info(4151) ->
	#base_draconic_suit{id = 4151,stage = 15,color = 4,name = "掠夺龙裔",suit_type = 1,draconic = [7707415,7708415,7709415,7710415,7711415],attr = [{2,[{1,42000},{7,48000},{27,5000}]},{4,[{2,840000},{6,48000},{28,5000}]},{5,[{1,48000},{3,60000},{13,2506}]}],score = [{2,660000},{4,660000},{5,1080000}]};

get_draconic_suit_info(5001) ->
	#base_draconic_suit{id = 5001,stage = 3,color = 5,name = "巨板龙裔",suit_type = 1,draconic = [7707503,7708503,7709503,7710503,7711503],attr = [{2,[{1,3360},{7,3840},{27,630}]},{4,[{2,67200},{6,3840},{28,630}]},{5,[{1,3840},{3,4800},{13,316}]}],score = [{2,52800},{4,52800},{5,86400}]};

get_draconic_suit_info(5010) ->
	#base_draconic_suit{id = 5010,stage = 5,color = 5,name = "上永守望",suit_type = 0,draconic = [7701505,7702505,7703505,7704505,7705505,7706505],attr = [{2,[{2,112000},{8,8960},{38,672}]},{4,[{1,5600},{5,8960},{37,672}]},{6,[{4,11200},{2,179200},{10,101}]}],score = [{2,100800},{4,100800},{6,201600}]};

get_draconic_suit_info(5011) ->
	#base_draconic_suit{id = 5011,stage = 5,color = 5,name = "上永龙裔",suit_type = 1,draconic = [7707505,7708505,7709505,7710505,7711505],attr = [{2,[{1,7840},{7,8960},{27,840}]},{4,[{2,156800},{6,8960},{28,840}]},{5,[{1,8960},{3,11200},{13,421}]}],score = [{2,123200},{4,123200},{5,201600}]};

get_draconic_suit_info(5020) ->
	#base_draconic_suit{id = 5020,stage = 6,color = 5,name = "吾铭守望",suit_type = 0,draconic = [7701506,7702506,7703506,7704506,7705506,7706506],attr = [{2,[{2,144000},{8,11520},{38,864}]},{4,[{1,7200},{5,11520},{37,864}]},{6,[{4,14400},{2,230400},{10,130}]}],score = [{2,129600},{4,129600},{6,259200}]};

get_draconic_suit_info(5021) ->
	#base_draconic_suit{id = 5021,stage = 6,color = 5,name = "吾铭龙裔",suit_type = 1,draconic = [7707506,7708506,7709506,7710506,7711506],attr = [{2,[{1,10080},{7,11520},{27,1080}]},{4,[{2,201600},{6,11520},{28,1080}]},{5,[{1,11520},{3,14400},{13,541}]}],score = [{2,158400},{4,158400},{5,259200}]};

get_draconic_suit_info(5030) ->
	#base_draconic_suit{id = 5030,stage = 7,color = 5,name = "海德守望",suit_type = 0,draconic = [7701507,7702507,7703507,7704507,7705507,7706507],attr = [{2,[{2,180000},{8,14400},{38,1080}]},{4,[{1,9000},{5,14400},{37,1080}]},{6,[{4,18000},{2,288000},{10,162}]}],score = [{2,162000},{4,162000},{6,324000}]};

get_draconic_suit_info(5031) ->
	#base_draconic_suit{id = 5031,stage = 7,color = 5,name = "海德龙裔",suit_type = 1,draconic = [7707507,7708507,7709507,7710507,7711507],attr = [{2,[{1,12600},{7,14400},{27,1350}]},{4,[{2,252000},{6,14400},{28,1350}]},{5,[{1,14400},{3,18000},{13,677}]}],score = [{2,198000},{4,198000},{5,324000}]};

get_draconic_suit_info(5040) ->
	#base_draconic_suit{id = 5040,stage = 8,color = 5,name = "白疾守望",suit_type = 0,draconic = [7701508,7702508,7703508,7704508,7705508,7706508],attr = [{2,[{2,220000},{8,17600},{38,1320}]},{4,[{1,11000},{5,17600},{37,1320}]},{6,[{4,22000},{2,352000},{10,198}]}],score = [{2,198000},{4,198000},{6,396000}]};

get_draconic_suit_info(5041) ->
	#base_draconic_suit{id = 5041,stage = 8,color = 5,name = "白疾龙裔",suit_type = 1,draconic = [7707508,7708508,7709508,7710508,7711508],attr = [{2,[{1,15400},{7,17600},{27,1650}]},{4,[{2,308000},{6,17600},{28,1650}]},{5,[{1,17600},{3,22000},{13,827}]}],score = [{2,242000},{4,242000},{5,396000}]};

get_draconic_suit_info(5050) ->
	#base_draconic_suit{id = 5050,stage = 9,color = 5,name = "地晖守望",suit_type = 0,draconic = [7701509,7702509,7703509,7704509,7705509,7706509],attr = [{2,[{2,300000},{8,24000},{38,1800}]},{4,[{1,15000},{5,24000},{37,1800}]},{6,[{4,30000},{2,480000},{10,270}]}],score = [{2,270000},{4,270000},{6,540000}]};

get_draconic_suit_info(5051) ->
	#base_draconic_suit{id = 5051,stage = 9,color = 5,name = "地晖龙裔",suit_type = 1,draconic = [7707509,7708509,7709509,7710509,7711509],attr = [{2,[{1,21000},{7,24000},{27,2250}]},{4,[{2,420000},{6,24000},{28,2250}]},{5,[{1,24000},{3,30000},{13,1128}]}],score = [{2,330000},{4,330000},{5,540000}]};

get_draconic_suit_info(5060) ->
	#base_draconic_suit{id = 5060,stage = 10,color = 5,name = "冥噬守望",suit_type = 0,draconic = [7701510,7702510,7703510,7704510,7705510,7706510],attr = [{2,[{2,332000},{8,26560},{38,1992}]},{4,[{1,16600},{5,26560},{37,1992}]},{6,[{4,33200},{2,531200},{10,299}]}],score = [{2,298800},{4,298800},{6,597600}]};

get_draconic_suit_info(5061) ->
	#base_draconic_suit{id = 5061,stage = 10,color = 5,name = "冥噬龙裔",suit_type = 1,draconic = [7707510,7708510,7709510,7710510,7711510],attr = [{2,[{1,23240},{7,26560},{27,2490}]},{4,[{2,464800},{6,26560},{28,2490}]},{5,[{1,26560},{3,33200},{13,1248}]}],score = [{2,365200},{4,365200},{5,597600}]};

get_draconic_suit_info(5070) ->
	#base_draconic_suit{id = 5070,stage = 11,color = 5,name = "婪耀守望",suit_type = 0,draconic = [7701511,7702511,7703511,7704511,7705511,7706511],attr = [{2,[{2,436000},{8,34880},{38,2616}]},{4,[{1,21800},{5,34880},{37,2616}]},{6,[{4,43600},{2,697600},{10,392}]}],score = [{2,392400},{4,392400},{6,784800}]};

get_draconic_suit_info(5071) ->
	#base_draconic_suit{id = 5071,stage = 11,color = 5,name = "婪耀龙裔",suit_type = 1,draconic = [7707511,7708511,7709511,7710511,7711511],attr = [{2,[{1,30520},{7,34880},{27,3270}]},{4,[{2,610400},{6,34880},{28,3270}]},{5,[{1,34880},{3,43600},{13,1639}]}],score = [{2,479600},{4,479600},{5,784800}]};

get_draconic_suit_info(5080) ->
	#base_draconic_suit{id = 5080,stage = 12,color = 5,name = "寻辉守望",suit_type = 0,draconic = [7701512,7702512,7703512,7704512,7705512,7706512],attr = [{2,[{2,484000},{8,38720},{38,2904}]},{4,[{1,24200},{5,38720},{37,2904}]},{6,[{4,48400},{2,774400},{10,436}]}],score = [{2,435600},{4,435600},{6,871200}]};

get_draconic_suit_info(5081) ->
	#base_draconic_suit{id = 5081,stage = 12,color = 5,name = "寻辉龙裔",suit_type = 1,draconic = [7707512,7708512,7709512,7710512,7711512],attr = [{2,[{1,33880},{7,38720},{27,3630}]},{4,[{2,677600},{6,38720},{28,3630}]},{5,[{1,38720},{3,48400},{13,1819}]}],score = [{2,532400},{4,532400},{5,871200}]};

get_draconic_suit_info(5090) ->
	#base_draconic_suit{id = 5090,stage = 13,color = 5,name = "荒烬守望",suit_type = 0,draconic = [7701513,7702513,7703513,7704513,7705513,7706513],attr = [{2,[{2,604000},{8,48320},{38,3624}]},{4,[{1,30200},{5,48320},{37,3624}]},{6,[{4,60400},{2,966400},{10,544}]}],score = [{2,543600},{4,543600},{6,1087200}]};

get_draconic_suit_info(5091) ->
	#base_draconic_suit{id = 5091,stage = 13,color = 5,name = "荒烬龙裔",suit_type = 1,draconic = [7707513,7708513,7709513,7710513,7711513],attr = [{2,[{1,42280},{7,48320},{27,4530}]},{4,[{2,845600},{6,48320},{28,4530}]},{5,[{1,48320},{3,60400},{13,2270}]}],score = [{2,664400},{4,664400},{5,1087200}]};

get_draconic_suit_info(5100) ->
	#base_draconic_suit{id = 5100,stage = 14,color = 5,name = "蛊骸守望",suit_type = 0,draconic = [7701514,7702514,7703514,7704514,7705514,7706514],attr = [{2,[{2,652000},{8,52160},{38,3912}]},{4,[{1,32600},{5,52160},{37,3912}]},{6,[{4,65200},{2,1043200},{10,587}]}],score = [{2,586800},{4,586800},{6,1173600}]};

get_draconic_suit_info(5101) ->
	#base_draconic_suit{id = 5101,stage = 14,color = 5,name = "蛊骸龙裔",suit_type = 1,draconic = [7707514,7708514,7709514,7710514,7711514],attr = [{2,[{1,45640},{7,52160},{27,4890}]},{4,[{2,912800},{6,52160},{28,4890}]},{5,[{1,52160},{3,65200},{13,2450}]}],score = [{2,717200},{4,717200},{5,1173600}]};

get_draconic_suit_info(5110) ->
	#base_draconic_suit{id = 5110,stage = 15,color = 5,name = "恐暴守望",suit_type = 0,draconic = [7701515,7702515,7703515,7704515,7705515,7706515],attr = [{2,[{2,800000},{8,64000},{38,4800}]},{4,[{1,40000},{5,64000},{37,4800}]},{6,[{4,80000},{2,1280000},{10,720}]}],score = [{2,720000},{4,720000},{6,1440000}]};

get_draconic_suit_info(5111) ->
	#base_draconic_suit{id = 5111,stage = 15,color = 5,name = "恐暴龙裔",suit_type = 1,draconic = [7707515,7708515,7709515,7710515,7711515],attr = [{2,[{1,56000},{7,64000},{27,6000}]},{4,[{2,1120000},{6,64000},{28,6000}]},{5,[{1,64000},{3,80000},{13,3007}]}],score = [{2,880000},{4,880000},{5,1440000}]};

get_draconic_suit_info(6010) ->
	#base_draconic_suit{id = 6010,stage = 9,color = 6,name = "暗质守望",suit_type = 0,draconic = [7701609,7702609,7703609,7704609,7705609,7706609],attr = [{2,[{2,375000},{8,30000},{38,2160}]},{4,[{1,18750},{5,30000},{37,2160}]},{6,[{4,37500},{2,600000},{10,324}]}],score = [{2,337500},{4,337500},{6,675000}]};

get_draconic_suit_info(6011) ->
	#base_draconic_suit{id = 6011,stage = 9,color = 6,name = "暗质龙裔",suit_type = 1,draconic = [7707609,7708609,7709609,7710609,7711609],attr = [{2,[{1,26250},{7,30000},{27,2700}]},{4,[{2,525000},{6,30000},{28,2700}]},{5,[{1,30000},{3,37500},{13,1354}]}],score = [{2,412500},{4,412500},{5,675000}]};

get_draconic_suit_info(6020) ->
	#base_draconic_suit{id = 6020,stage = 10,color = 6,name = "黑煌守望",suit_type = 0,draconic = [7701610,7702610,7703610,7704610,7705610,7706610],attr = [{2,[{2,415000},{8,33200},{38,2390}]},{4,[{1,20750},{5,33200},{37,2390}]},{6,[{4,41500},{2,664000},{10,359}]}],score = [{2,373500},{4,373500},{6,747000}]};

get_draconic_suit_info(6021) ->
	#base_draconic_suit{id = 6021,stage = 10,color = 6,name = "黑煌龙裔",suit_type = 1,draconic = [7707610,7708610,7709610,7710610,7711610],attr = [{2,[{1,29050},{7,33200},{27,2988}]},{4,[{2,581000},{6,33200},{28,2988}]},{5,[{1,33200},{3,41500},{13,1498}]}],score = [{2,456500},{4,456500},{5,747000}]};

get_draconic_suit_info(6030) ->
	#base_draconic_suit{id = 6030,stage = 11,color = 6,name = "雷猎守望",suit_type = 0,draconic = [7701611,7702611,7703611,7704611,7705611,7706611],attr = [{2,[{2,545000},{8,43600},{38,3139}]},{4,[{1,27250},{5,43600},{37,3139}]},{6,[{4,54500},{2,872000},{10,470}]}],score = [{2,490500},{4,490500},{6,981000}]};

get_draconic_suit_info(6031) ->
	#base_draconic_suit{id = 6031,stage = 11,color = 6,name = "雷猎龙裔",suit_type = 1,draconic = [7707611,7708611,7709611,7710611,7711611],attr = [{2,[{1,38150},{7,43600},{27,3924}]},{4,[{2,763000},{6,43600},{28,3924}]},{5,[{1,43600},{3,54500},{13,1967}]}],score = [{2,599500},{4,599500},{5,981000}]};

get_draconic_suit_info(6040) ->
	#base_draconic_suit{id = 6040,stage = 12,color = 6,name = "天辉守望",suit_type = 0,draconic = [7701612,7702612,7703612,7704612,7705612,7706612],attr = [{2,[{2,605000},{8,48400},{38,3485}]},{4,[{1,30250},{5,48400},{37,3485}]},{6,[{4,60500},{2,968000},{10,523}]}],score = [{2,544500},{4,544500},{6,1089000}]};

get_draconic_suit_info(6041) ->
	#base_draconic_suit{id = 6041,stage = 12,color = 6,name = "天辉龙裔",suit_type = 1,draconic = [7707612,7708612,7709612,7710612,7711612],attr = [{2,[{1,42350},{7,48400},{27,4356}]},{4,[{2,847000},{6,48400},{28,4356}]},{5,[{1,48400},{3,60500},{13,2183}]}],score = [{2,665500},{4,665500},{5,1089000}]};

get_draconic_suit_info(6050) ->
	#base_draconic_suit{id = 6050,stage = 13,color = 6,name = "苍穹守望",suit_type = 0,draconic = [7701613,7702613,7703613,7704613,7705613,7706613],attr = [{2,[{2,755000},{8,60400},{38,4349}]},{4,[{1,37750},{5,60400},{37,4349}]},{6,[{4,75500},{2,1208000},{10,653}]}],score = [{2,679500},{4,679500},{6,1359000}]};

get_draconic_suit_info(6051) ->
	#base_draconic_suit{id = 6051,stage = 13,color = 6,name = "苍穹龙裔",suit_type = 1,draconic = [7707613,7708613,7709613,7710613,7711613],attr = [{2,[{1,52850},{7,60400},{27,5436}]},{4,[{2,1057000},{6,60400},{28,5436}]},{5,[{1,60400},{3,75500},{13,2724}]}],score = [{2,830500},{4,830500},{5,1359000}]};

get_draconic_suit_info(6060) ->
	#base_draconic_suit{id = 6060,stage = 14,color = 6,name = "绝翼守望",suit_type = 0,draconic = [7701614,7702614,7703614,7704614,7705614,7706614],attr = [{2,[{2,815000},{8,65200},{38,4694}]},{4,[{1,40750},{5,65200},{37,4694}]},{6,[{4,81500},{2,1304000},{10,704}]}],score = [{2,733500},{4,733500},{6,1467000}]};

get_draconic_suit_info(6061) ->
	#base_draconic_suit{id = 6061,stage = 14,color = 6,name = "绝翼龙裔",suit_type = 1,draconic = [7707614,7708614,7709614,7710614,7711614],attr = [{2,[{1,57050},{7,65200},{27,5868}]},{4,[{2,1141000},{6,65200},{28,5868}]},{5,[{1,65200},{3,81500},{13,2940}]}],score = [{2,896500},{4,896500},{5,1467000}]};

get_draconic_suit_info(6070) ->
	#base_draconic_suit{id = 6070,stage = 15,color = 6,name = "灭尽守望",suit_type = 0,draconic = [7701615,7702615,7703615,7704615,7705615,7706615],attr = [{2,[{2,1000000},{8,80000},{38,5760}]},{4,[{1,50000},{5,80000},{37,5760}]},{6,[{4,100000},{2,1600000},{10,864}]}],score = [{2,900000},{4,900000},{6,1800000}]};

get_draconic_suit_info(6071) ->
	#base_draconic_suit{id = 6071,stage = 15,color = 6,name = "灭尽龙裔",suit_type = 1,draconic = [7707615,7708615,7709615,7710615,7711615],attr = [{2,[{1,70000},{7,80000},{27,7200}]},{4,[{2,1400000},{6,80000},{28,7200}]},{5,[{1,80000},{3,100000},{13,3608}]}],score = [{2,1100000},{4,1100000},{5,1800000}]};

get_draconic_suit_info(_Id) ->
	[].

get_all_suit_id() ->
[4010,4020,4030,4031,4040,4050,4051,4060,4061,4070,4071,4080,4081,4090,4091,4100,4101,4110,4111,4120,4121,4130,4131,4140,4141,4150,4151,5001,5010,5011,5020,5021,5030,5031,5040,5041,5050,5051,5060,5061,5070,5071,5080,5081,5090,5091,5100,5101,5110,5111,6010,6011,6020,6021,6030,6031,6040,6041,6050,6051,6060,6061,6070,6071].

get_suit_id(1,4,0) ->
[4010];

get_suit_id(2,4,0) ->
[4020];

get_suit_id(3,4,0) ->
[4030];

get_suit_id(3,4,1) ->
[4031];

get_suit_id(3,5,1) ->
[5001];

get_suit_id(4,4,0) ->
[4040];

get_suit_id(5,4,0) ->
[4050];

get_suit_id(5,4,1) ->
[4051];

get_suit_id(5,5,0) ->
[5010];

get_suit_id(5,5,1) ->
[5011];

get_suit_id(6,4,0) ->
[4060];

get_suit_id(6,4,1) ->
[4061];

get_suit_id(6,5,0) ->
[5020];

get_suit_id(6,5,1) ->
[5021];

get_suit_id(7,4,0) ->
[4070];

get_suit_id(7,4,1) ->
[4071];

get_suit_id(7,5,0) ->
[5030];

get_suit_id(7,5,1) ->
[5031];

get_suit_id(8,4,0) ->
[4080];

get_suit_id(8,4,1) ->
[4081];

get_suit_id(8,5,0) ->
[5040];

get_suit_id(8,5,1) ->
[5041];

get_suit_id(9,4,0) ->
[4090];

get_suit_id(9,4,1) ->
[4091];

get_suit_id(9,5,0) ->
[5050];

get_suit_id(9,5,1) ->
[5051];

get_suit_id(9,6,0) ->
[6010];

get_suit_id(9,6,1) ->
[6011];

get_suit_id(10,4,0) ->
[4100];

get_suit_id(10,4,1) ->
[4101];

get_suit_id(10,5,0) ->
[5060];

get_suit_id(10,5,1) ->
[5061];

get_suit_id(10,6,0) ->
[6020];

get_suit_id(10,6,1) ->
[6021];

get_suit_id(11,4,0) ->
[4110];

get_suit_id(11,4,1) ->
[4111];

get_suit_id(11,5,0) ->
[5070];

get_suit_id(11,5,1) ->
[5071];

get_suit_id(11,6,0) ->
[6030];

get_suit_id(11,6,1) ->
[6031];

get_suit_id(12,4,0) ->
[4120];

get_suit_id(12,4,1) ->
[4121];

get_suit_id(12,5,0) ->
[5080];

get_suit_id(12,5,1) ->
[5081];

get_suit_id(12,6,0) ->
[6040];

get_suit_id(12,6,1) ->
[6041];

get_suit_id(13,4,0) ->
[4130];

get_suit_id(13,4,1) ->
[4131];

get_suit_id(13,5,0) ->
[5090];

get_suit_id(13,5,1) ->
[5091];

get_suit_id(13,6,0) ->
[6050];

get_suit_id(13,6,1) ->
[6051];

get_suit_id(14,4,0) ->
[4140];

get_suit_id(14,4,1) ->
[4141];

get_suit_id(14,5,0) ->
[5100];

get_suit_id(14,5,1) ->
[5101];

get_suit_id(14,6,0) ->
[6060];

get_suit_id(14,6,1) ->
[6061];

get_suit_id(15,4,0) ->
[4150];

get_suit_id(15,4,1) ->
[4151];

get_suit_id(15,5,0) ->
[5110];

get_suit_id(15,5,1) ->
[5111];

get_suit_id(15,6,0) ->
[6070];

get_suit_id(15,6,1) ->
[6071];

get_suit_id(_Stage,_Color,_Suittype) ->
	[].

get_draconic_strong_info(1,0) ->
	#base_draconic_strong{id = 1,lv = 0,cost = [],add_attr = [{4,0},{6,0}]};

get_draconic_strong_info(1,1) ->
	#base_draconic_strong{id = 1,lv = 1,cost = [{255,36255095,1000}],add_attr = [{4,14},{6,16}]};

get_draconic_strong_info(1,2) ->
	#base_draconic_strong{id = 1,lv = 2,cost = [{255,36255095,1250}],add_attr = [{4,28},{6,32}]};

get_draconic_strong_info(1,3) ->
	#base_draconic_strong{id = 1,lv = 3,cost = [{255,36255095,1510}],add_attr = [{4,42},{6,48}]};

get_draconic_strong_info(1,4) ->
	#base_draconic_strong{id = 1,lv = 4,cost = [{255,36255095,1790}],add_attr = [{4,56},{6,64}]};

get_draconic_strong_info(1,5) ->
	#base_draconic_strong{id = 1,lv = 5,cost = [{255,36255095,2080}],add_attr = [{4,70},{6,80}]};

get_draconic_strong_info(1,6) ->
	#base_draconic_strong{id = 1,lv = 6,cost = [{255,36255095,2380}],add_attr = [{4,84},{6,96}]};

get_draconic_strong_info(1,7) ->
	#base_draconic_strong{id = 1,lv = 7,cost = [{255,36255095,2700}],add_attr = [{4,98},{6,112}]};

get_draconic_strong_info(1,8) ->
	#base_draconic_strong{id = 1,lv = 8,cost = [{255,36255095,3040}],add_attr = [{4,112},{6,128}]};

get_draconic_strong_info(1,9) ->
	#base_draconic_strong{id = 1,lv = 9,cost = [{255,36255095,3390}],add_attr = [{4,126},{6,144}]};

get_draconic_strong_info(1,10) ->
	#base_draconic_strong{id = 1,lv = 10,cost = [{255,36255095,3760}],add_attr = [{4,140},{6,160}]};

get_draconic_strong_info(1,11) ->
	#base_draconic_strong{id = 1,lv = 11,cost = [{255,36255095,4150}],add_attr = [{4,154},{6,176}]};

get_draconic_strong_info(1,12) ->
	#base_draconic_strong{id = 1,lv = 12,cost = [{255,36255095,4560}],add_attr = [{4,168},{6,192}]};

get_draconic_strong_info(1,13) ->
	#base_draconic_strong{id = 1,lv = 13,cost = [{255,36255095,4990}],add_attr = [{4,182},{6,208}]};

get_draconic_strong_info(1,14) ->
	#base_draconic_strong{id = 1,lv = 14,cost = [{255,36255095,5440}],add_attr = [{4,196},{6,224}]};

get_draconic_strong_info(1,15) ->
	#base_draconic_strong{id = 1,lv = 15,cost = [{255,36255095,5910}],add_attr = [{4,210},{6,240}]};

get_draconic_strong_info(1,16) ->
	#base_draconic_strong{id = 1,lv = 16,cost = [{255,36255095,6410}],add_attr = [{4,224},{6,256}]};

get_draconic_strong_info(1,17) ->
	#base_draconic_strong{id = 1,lv = 17,cost = [{255,36255095,6930}],add_attr = [{4,238},{6,272}]};

get_draconic_strong_info(1,18) ->
	#base_draconic_strong{id = 1,lv = 18,cost = [{255,36255095,7480}],add_attr = [{4,252},{6,288}]};

get_draconic_strong_info(1,19) ->
	#base_draconic_strong{id = 1,lv = 19,cost = [{255,36255095,8050}],add_attr = [{4,266},{6,304}]};

get_draconic_strong_info(1,20) ->
	#base_draconic_strong{id = 1,lv = 20,cost = [{255,36255095,8650}],add_attr = [{4,280},{6,320}]};

get_draconic_strong_info(1,21) ->
	#base_draconic_strong{id = 1,lv = 21,cost = [{255,36255095,9280}],add_attr = [{4,294},{6,336}]};

get_draconic_strong_info(1,22) ->
	#base_draconic_strong{id = 1,lv = 22,cost = [{255,36255095,9940}],add_attr = [{4,308},{6,352}]};

get_draconic_strong_info(1,23) ->
	#base_draconic_strong{id = 1,lv = 23,cost = [{255,36255095,10640}],add_attr = [{4,322},{6,368}]};

get_draconic_strong_info(1,24) ->
	#base_draconic_strong{id = 1,lv = 24,cost = [{255,36255095,11370}],add_attr = [{4,336},{6,384}]};

get_draconic_strong_info(1,25) ->
	#base_draconic_strong{id = 1,lv = 25,cost = [{255,36255095,12140}],add_attr = [{4,350},{6,400}]};

get_draconic_strong_info(1,26) ->
	#base_draconic_strong{id = 1,lv = 26,cost = [{255,36255095,12950}],add_attr = [{4,364},{6,416}]};

get_draconic_strong_info(1,27) ->
	#base_draconic_strong{id = 1,lv = 27,cost = [{255,36255095,13800}],add_attr = [{4,378},{6,432}]};

get_draconic_strong_info(1,28) ->
	#base_draconic_strong{id = 1,lv = 28,cost = [{255,36255095,14690}],add_attr = [{4,392},{6,448}]};

get_draconic_strong_info(1,29) ->
	#base_draconic_strong{id = 1,lv = 29,cost = [{255,36255095,15620}],add_attr = [{4,406},{6,464}]};

get_draconic_strong_info(1,30) ->
	#base_draconic_strong{id = 1,lv = 30,cost = [{255,36255095,16600}],add_attr = [{4,420},{6,480}]};

get_draconic_strong_info(1,31) ->
	#base_draconic_strong{id = 1,lv = 31,cost = [{255,36255095,17630}],add_attr = [{4,434},{6,496}]};

get_draconic_strong_info(1,32) ->
	#base_draconic_strong{id = 1,lv = 32,cost = [{255,36255095,18710}],add_attr = [{4,448},{6,512}]};

get_draconic_strong_info(1,33) ->
	#base_draconic_strong{id = 1,lv = 33,cost = [{255,36255095,19850}],add_attr = [{4,462},{6,528}]};

get_draconic_strong_info(1,34) ->
	#base_draconic_strong{id = 1,lv = 34,cost = [{255,36255095,21040}],add_attr = [{4,476},{6,544}]};

get_draconic_strong_info(1,35) ->
	#base_draconic_strong{id = 1,lv = 35,cost = [{255,36255095,22290}],add_attr = [{4,490},{6,560}]};

get_draconic_strong_info(1,36) ->
	#base_draconic_strong{id = 1,lv = 36,cost = [{255,36255095,23600}],add_attr = [{4,504},{6,576}]};

get_draconic_strong_info(1,37) ->
	#base_draconic_strong{id = 1,lv = 37,cost = [{255,36255095,24980}],add_attr = [{4,518},{6,592}]};

get_draconic_strong_info(1,38) ->
	#base_draconic_strong{id = 1,lv = 38,cost = [{255,36255095,26430}],add_attr = [{4,532},{6,608}]};

get_draconic_strong_info(1,39) ->
	#base_draconic_strong{id = 1,lv = 39,cost = [{255,36255095,27950}],add_attr = [{4,546},{6,624}]};

get_draconic_strong_info(1,40) ->
	#base_draconic_strong{id = 1,lv = 40,cost = [{255,36255095,29550}],add_attr = [{4,560},{6,640}]};

get_draconic_strong_info(1,41) ->
	#base_draconic_strong{id = 1,lv = 41,cost = [{255,36255095,31230}],add_attr = [{4,574},{6,656}]};

get_draconic_strong_info(1,42) ->
	#base_draconic_strong{id = 1,lv = 42,cost = [{255,36255095,32990}],add_attr = [{4,588},{6,672}]};

get_draconic_strong_info(1,43) ->
	#base_draconic_strong{id = 1,lv = 43,cost = [{255,36255095,34840}],add_attr = [{4,602},{6,688}]};

get_draconic_strong_info(1,44) ->
	#base_draconic_strong{id = 1,lv = 44,cost = [{255,36255095,36780}],add_attr = [{4,616},{6,704}]};

get_draconic_strong_info(1,45) ->
	#base_draconic_strong{id = 1,lv = 45,cost = [{255,36255095,38820}],add_attr = [{4,630},{6,720}]};

get_draconic_strong_info(1,46) ->
	#base_draconic_strong{id = 1,lv = 46,cost = [{255,36255095,40960}],add_attr = [{4,644},{6,736}]};

get_draconic_strong_info(1,47) ->
	#base_draconic_strong{id = 1,lv = 47,cost = [{255,36255095,43210}],add_attr = [{4,658},{6,752}]};

get_draconic_strong_info(1,48) ->
	#base_draconic_strong{id = 1,lv = 48,cost = [{255,36255095,45570}],add_attr = [{4,672},{6,768}]};

get_draconic_strong_info(1,49) ->
	#base_draconic_strong{id = 1,lv = 49,cost = [{255,36255095,48050}],add_attr = [{4,686},{6,784}]};

get_draconic_strong_info(1,50) ->
	#base_draconic_strong{id = 1,lv = 50,cost = [{255,36255095,50650}],add_attr = [{4,700},{6,800}]};

get_draconic_strong_info(1,51) ->
	#base_draconic_strong{id = 1,lv = 51,cost = [{255,36255095,53380}],add_attr = [{4,714},{6,816}]};

get_draconic_strong_info(1,52) ->
	#base_draconic_strong{id = 1,lv = 52,cost = [{255,36255095,56250}],add_attr = [{4,728},{6,832}]};

get_draconic_strong_info(1,53) ->
	#base_draconic_strong{id = 1,lv = 53,cost = [{255,36255095,59260}],add_attr = [{4,742},{6,848}]};

get_draconic_strong_info(1,54) ->
	#base_draconic_strong{id = 1,lv = 54,cost = [{255,36255095,62420}],add_attr = [{4,756},{6,864}]};

get_draconic_strong_info(1,55) ->
	#base_draconic_strong{id = 1,lv = 55,cost = [{255,36255095,65740}],add_attr = [{4,770},{6,880}]};

get_draconic_strong_info(1,56) ->
	#base_draconic_strong{id = 1,lv = 56,cost = [{255,36255095,69230}],add_attr = [{4,784},{6,896}]};

get_draconic_strong_info(1,57) ->
	#base_draconic_strong{id = 1,lv = 57,cost = [{255,36255095,72890}],add_attr = [{4,798},{6,912}]};

get_draconic_strong_info(1,58) ->
	#base_draconic_strong{id = 1,lv = 58,cost = [{255,36255095,76730}],add_attr = [{4,812},{6,928}]};

get_draconic_strong_info(1,59) ->
	#base_draconic_strong{id = 1,lv = 59,cost = [{255,36255095,80770}],add_attr = [{4,826},{6,944}]};

get_draconic_strong_info(1,60) ->
	#base_draconic_strong{id = 1,lv = 60,cost = [{255,36255095,85010}],add_attr = [{4,840},{6,960}]};

get_draconic_strong_info(1,61) ->
	#base_draconic_strong{id = 1,lv = 61,cost = [{255,36255095,89460}],add_attr = [{4,854},{6,976}]};

get_draconic_strong_info(1,62) ->
	#base_draconic_strong{id = 1,lv = 62,cost = [{255,36255095,94130}],add_attr = [{4,868},{6,992}]};

get_draconic_strong_info(1,63) ->
	#base_draconic_strong{id = 1,lv = 63,cost = [{255,36255095,99040}],add_attr = [{4,882},{6,1008}]};

get_draconic_strong_info(1,64) ->
	#base_draconic_strong{id = 1,lv = 64,cost = [{255,36255095,104190}],add_attr = [{4,896},{6,1024}]};

get_draconic_strong_info(1,65) ->
	#base_draconic_strong{id = 1,lv = 65,cost = [{255,36255095,109600}],add_attr = [{4,910},{6,1040}]};

get_draconic_strong_info(1,66) ->
	#base_draconic_strong{id = 1,lv = 66,cost = [{255,36255095,115280}],add_attr = [{4,924},{6,1056}]};

get_draconic_strong_info(1,67) ->
	#base_draconic_strong{id = 1,lv = 67,cost = [{255,36255095,121240}],add_attr = [{4,938},{6,1072}]};

get_draconic_strong_info(1,68) ->
	#base_draconic_strong{id = 1,lv = 68,cost = [{255,36255095,127500}],add_attr = [{4,952},{6,1088}]};

get_draconic_strong_info(1,69) ->
	#base_draconic_strong{id = 1,lv = 69,cost = [{255,36255095,134080}],add_attr = [{4,966},{6,1104}]};

get_draconic_strong_info(1,70) ->
	#base_draconic_strong{id = 1,lv = 70,cost = [{255,36255095,140980}],add_attr = [{4,980},{6,1120}]};

get_draconic_strong_info(1,71) ->
	#base_draconic_strong{id = 1,lv = 71,cost = [{255,36255095,148230}],add_attr = [{4,994},{6,1136}]};

get_draconic_strong_info(1,72) ->
	#base_draconic_strong{id = 1,lv = 72,cost = [{255,36255095,155840}],add_attr = [{4,1008},{6,1152}]};

get_draconic_strong_info(1,73) ->
	#base_draconic_strong{id = 1,lv = 73,cost = [{255,36255095,163830}],add_attr = [{4,1022},{6,1168}]};

get_draconic_strong_info(1,74) ->
	#base_draconic_strong{id = 1,lv = 74,cost = [{255,36255095,172220}],add_attr = [{4,1036},{6,1184}]};

get_draconic_strong_info(1,75) ->
	#base_draconic_strong{id = 1,lv = 75,cost = [{255,36255095,181030}],add_attr = [{4,1050},{6,1200}]};

get_draconic_strong_info(1,76) ->
	#base_draconic_strong{id = 1,lv = 76,cost = [{255,36255095,190280}],add_attr = [{4,1064},{6,1216}]};

get_draconic_strong_info(1,77) ->
	#base_draconic_strong{id = 1,lv = 77,cost = [{255,36255095,199990}],add_attr = [{4,1078},{6,1232}]};

get_draconic_strong_info(1,78) ->
	#base_draconic_strong{id = 1,lv = 78,cost = [{255,36255095,210190}],add_attr = [{4,1092},{6,1248}]};

get_draconic_strong_info(1,79) ->
	#base_draconic_strong{id = 1,lv = 79,cost = [{255,36255095,220900}],add_attr = [{4,1106},{6,1264}]};

get_draconic_strong_info(1,80) ->
	#base_draconic_strong{id = 1,lv = 80,cost = [{255,36255095,232150}],add_attr = [{4,1120},{6,1280}]};

get_draconic_strong_info(1,81) ->
	#base_draconic_strong{id = 1,lv = 81,cost = [{255,36255095,243960}],add_attr = [{4,1134},{6,1296}]};

get_draconic_strong_info(1,82) ->
	#base_draconic_strong{id = 1,lv = 82,cost = [{255,36255095,256360}],add_attr = [{4,1148},{6,1312}]};

get_draconic_strong_info(1,83) ->
	#base_draconic_strong{id = 1,lv = 83,cost = [{255,36255095,269380}],add_attr = [{4,1162},{6,1328}]};

get_draconic_strong_info(1,84) ->
	#base_draconic_strong{id = 1,lv = 84,cost = [{255,36255095,283050}],add_attr = [{4,1176},{6,1344}]};

get_draconic_strong_info(1,85) ->
	#base_draconic_strong{id = 1,lv = 85,cost = [{255,36255095,297400}],add_attr = [{4,1190},{6,1360}]};

get_draconic_strong_info(1,86) ->
	#base_draconic_strong{id = 1,lv = 86,cost = [{255,36255095,312470}],add_attr = [{4,1204},{6,1376}]};

get_draconic_strong_info(1,87) ->
	#base_draconic_strong{id = 1,lv = 87,cost = [{255,36255095,328290}],add_attr = [{4,1218},{6,1392}]};

get_draconic_strong_info(1,88) ->
	#base_draconic_strong{id = 1,lv = 88,cost = [{255,36255095,344900}],add_attr = [{4,1232},{6,1408}]};

get_draconic_strong_info(1,89) ->
	#base_draconic_strong{id = 1,lv = 89,cost = [{255,36255095,362350}],add_attr = [{4,1246},{6,1424}]};

get_draconic_strong_info(1,90) ->
	#base_draconic_strong{id = 1,lv = 90,cost = [{255,36255095,380670}],add_attr = [{4,1260},{6,1440}]};

get_draconic_strong_info(1,91) ->
	#base_draconic_strong{id = 1,lv = 91,cost = [{255,36255095,399900}],add_attr = [{4,1274},{6,1456}]};

get_draconic_strong_info(1,92) ->
	#base_draconic_strong{id = 1,lv = 92,cost = [{255,36255095,420100}],add_attr = [{4,1288},{6,1472}]};

get_draconic_strong_info(1,93) ->
	#base_draconic_strong{id = 1,lv = 93,cost = [{255,36255095,441310}],add_attr = [{4,1302},{6,1488}]};

get_draconic_strong_info(1,94) ->
	#base_draconic_strong{id = 1,lv = 94,cost = [{255,36255095,463580}],add_attr = [{4,1316},{6,1504}]};

get_draconic_strong_info(1,95) ->
	#base_draconic_strong{id = 1,lv = 95,cost = [{255,36255095,486960}],add_attr = [{4,1330},{6,1520}]};

get_draconic_strong_info(1,96) ->
	#base_draconic_strong{id = 1,lv = 96,cost = [{255,36255095,511510}],add_attr = [{4,1344},{6,1536}]};

get_draconic_strong_info(1,97) ->
	#base_draconic_strong{id = 1,lv = 97,cost = [{255,36255095,537290}],add_attr = [{4,1358},{6,1552}]};

get_draconic_strong_info(1,98) ->
	#base_draconic_strong{id = 1,lv = 98,cost = [{255,36255095,564350}],add_attr = [{4,1372},{6,1568}]};

get_draconic_strong_info(1,99) ->
	#base_draconic_strong{id = 1,lv = 99,cost = [{255,36255095,592770}],add_attr = [{4,1386},{6,1584}]};

get_draconic_strong_info(1,100) ->
	#base_draconic_strong{id = 1,lv = 100,cost = [{255,36255095,622610}],add_attr = [{4,1400},{6,1600}]};

get_draconic_strong_info(2,0) ->
	#base_draconic_strong{id = 2,lv = 0,cost = [],add_attr = [{2,0},{6,0}]};

get_draconic_strong_info(2,1) ->
	#base_draconic_strong{id = 2,lv = 1,cost = [{255,36255095,1000}],add_attr = [{2,338},{6,11}]};

get_draconic_strong_info(2,2) ->
	#base_draconic_strong{id = 2,lv = 2,cost = [{255,36255095,1250}],add_attr = [{2,676},{6,22}]};

get_draconic_strong_info(2,3) ->
	#base_draconic_strong{id = 2,lv = 3,cost = [{255,36255095,1510}],add_attr = [{2,1014},{6,33}]};

get_draconic_strong_info(2,4) ->
	#base_draconic_strong{id = 2,lv = 4,cost = [{255,36255095,1790}],add_attr = [{2,1352},{6,44}]};

get_draconic_strong_info(2,5) ->
	#base_draconic_strong{id = 2,lv = 5,cost = [{255,36255095,2080}],add_attr = [{2,1690},{6,55}]};

get_draconic_strong_info(2,6) ->
	#base_draconic_strong{id = 2,lv = 6,cost = [{255,36255095,2380}],add_attr = [{2,2028},{6,66}]};

get_draconic_strong_info(2,7) ->
	#base_draconic_strong{id = 2,lv = 7,cost = [{255,36255095,2700}],add_attr = [{2,2366},{6,77}]};

get_draconic_strong_info(2,8) ->
	#base_draconic_strong{id = 2,lv = 8,cost = [{255,36255095,3040}],add_attr = [{2,2704},{6,88}]};

get_draconic_strong_info(2,9) ->
	#base_draconic_strong{id = 2,lv = 9,cost = [{255,36255095,3390}],add_attr = [{2,3042},{6,99}]};

get_draconic_strong_info(2,10) ->
	#base_draconic_strong{id = 2,lv = 10,cost = [{255,36255095,3760}],add_attr = [{2,3380},{6,110}]};

get_draconic_strong_info(2,11) ->
	#base_draconic_strong{id = 2,lv = 11,cost = [{255,36255095,4150}],add_attr = [{2,3718},{6,121}]};

get_draconic_strong_info(2,12) ->
	#base_draconic_strong{id = 2,lv = 12,cost = [{255,36255095,4560}],add_attr = [{2,4056},{6,132}]};

get_draconic_strong_info(2,13) ->
	#base_draconic_strong{id = 2,lv = 13,cost = [{255,36255095,4990}],add_attr = [{2,4394},{6,143}]};

get_draconic_strong_info(2,14) ->
	#base_draconic_strong{id = 2,lv = 14,cost = [{255,36255095,5440}],add_attr = [{2,4732},{6,154}]};

get_draconic_strong_info(2,15) ->
	#base_draconic_strong{id = 2,lv = 15,cost = [{255,36255095,5910}],add_attr = [{2,5070},{6,165}]};

get_draconic_strong_info(2,16) ->
	#base_draconic_strong{id = 2,lv = 16,cost = [{255,36255095,6410}],add_attr = [{2,5408},{6,176}]};

get_draconic_strong_info(2,17) ->
	#base_draconic_strong{id = 2,lv = 17,cost = [{255,36255095,6930}],add_attr = [{2,5746},{6,187}]};

get_draconic_strong_info(2,18) ->
	#base_draconic_strong{id = 2,lv = 18,cost = [{255,36255095,7480}],add_attr = [{2,6084},{6,198}]};

get_draconic_strong_info(2,19) ->
	#base_draconic_strong{id = 2,lv = 19,cost = [{255,36255095,8050}],add_attr = [{2,6422},{6,209}]};

get_draconic_strong_info(2,20) ->
	#base_draconic_strong{id = 2,lv = 20,cost = [{255,36255095,8650}],add_attr = [{2,6760},{6,220}]};

get_draconic_strong_info(2,21) ->
	#base_draconic_strong{id = 2,lv = 21,cost = [{255,36255095,9280}],add_attr = [{2,7098},{6,231}]};

get_draconic_strong_info(2,22) ->
	#base_draconic_strong{id = 2,lv = 22,cost = [{255,36255095,9940}],add_attr = [{2,7436},{6,242}]};

get_draconic_strong_info(2,23) ->
	#base_draconic_strong{id = 2,lv = 23,cost = [{255,36255095,10640}],add_attr = [{2,7774},{6,253}]};

get_draconic_strong_info(2,24) ->
	#base_draconic_strong{id = 2,lv = 24,cost = [{255,36255095,11370}],add_attr = [{2,8112},{6,264}]};

get_draconic_strong_info(2,25) ->
	#base_draconic_strong{id = 2,lv = 25,cost = [{255,36255095,12140}],add_attr = [{2,8450},{6,275}]};

get_draconic_strong_info(2,26) ->
	#base_draconic_strong{id = 2,lv = 26,cost = [{255,36255095,12950}],add_attr = [{2,8788},{6,286}]};

get_draconic_strong_info(2,27) ->
	#base_draconic_strong{id = 2,lv = 27,cost = [{255,36255095,13800}],add_attr = [{2,9126},{6,297}]};

get_draconic_strong_info(2,28) ->
	#base_draconic_strong{id = 2,lv = 28,cost = [{255,36255095,14690}],add_attr = [{2,9464},{6,308}]};

get_draconic_strong_info(2,29) ->
	#base_draconic_strong{id = 2,lv = 29,cost = [{255,36255095,15620}],add_attr = [{2,9802},{6,319}]};

get_draconic_strong_info(2,30) ->
	#base_draconic_strong{id = 2,lv = 30,cost = [{255,36255095,16600}],add_attr = [{2,10140},{6,330}]};

get_draconic_strong_info(2,31) ->
	#base_draconic_strong{id = 2,lv = 31,cost = [{255,36255095,17630}],add_attr = [{2,10478},{6,341}]};

get_draconic_strong_info(2,32) ->
	#base_draconic_strong{id = 2,lv = 32,cost = [{255,36255095,18710}],add_attr = [{2,10816},{6,352}]};

get_draconic_strong_info(2,33) ->
	#base_draconic_strong{id = 2,lv = 33,cost = [{255,36255095,19850}],add_attr = [{2,11154},{6,363}]};

get_draconic_strong_info(2,34) ->
	#base_draconic_strong{id = 2,lv = 34,cost = [{255,36255095,21040}],add_attr = [{2,11492},{6,374}]};

get_draconic_strong_info(2,35) ->
	#base_draconic_strong{id = 2,lv = 35,cost = [{255,36255095,22290}],add_attr = [{2,11830},{6,385}]};

get_draconic_strong_info(2,36) ->
	#base_draconic_strong{id = 2,lv = 36,cost = [{255,36255095,23600}],add_attr = [{2,12168},{6,396}]};

get_draconic_strong_info(2,37) ->
	#base_draconic_strong{id = 2,lv = 37,cost = [{255,36255095,24980}],add_attr = [{2,12506},{6,407}]};

get_draconic_strong_info(2,38) ->
	#base_draconic_strong{id = 2,lv = 38,cost = [{255,36255095,26430}],add_attr = [{2,12844},{6,418}]};

get_draconic_strong_info(2,39) ->
	#base_draconic_strong{id = 2,lv = 39,cost = [{255,36255095,27950}],add_attr = [{2,13182},{6,429}]};

get_draconic_strong_info(2,40) ->
	#base_draconic_strong{id = 2,lv = 40,cost = [{255,36255095,29550}],add_attr = [{2,13520},{6,440}]};

get_draconic_strong_info(2,41) ->
	#base_draconic_strong{id = 2,lv = 41,cost = [{255,36255095,31230}],add_attr = [{2,13858},{6,451}]};

get_draconic_strong_info(2,42) ->
	#base_draconic_strong{id = 2,lv = 42,cost = [{255,36255095,32990}],add_attr = [{2,14196},{6,462}]};

get_draconic_strong_info(2,43) ->
	#base_draconic_strong{id = 2,lv = 43,cost = [{255,36255095,34840}],add_attr = [{2,14534},{6,473}]};

get_draconic_strong_info(2,44) ->
	#base_draconic_strong{id = 2,lv = 44,cost = [{255,36255095,36780}],add_attr = [{2,14872},{6,484}]};

get_draconic_strong_info(2,45) ->
	#base_draconic_strong{id = 2,lv = 45,cost = [{255,36255095,38820}],add_attr = [{2,15210},{6,495}]};

get_draconic_strong_info(2,46) ->
	#base_draconic_strong{id = 2,lv = 46,cost = [{255,36255095,40960}],add_attr = [{2,15548},{6,506}]};

get_draconic_strong_info(2,47) ->
	#base_draconic_strong{id = 2,lv = 47,cost = [{255,36255095,43210}],add_attr = [{2,15886},{6,517}]};

get_draconic_strong_info(2,48) ->
	#base_draconic_strong{id = 2,lv = 48,cost = [{255,36255095,45570}],add_attr = [{2,16224},{6,528}]};

get_draconic_strong_info(2,49) ->
	#base_draconic_strong{id = 2,lv = 49,cost = [{255,36255095,48050}],add_attr = [{2,16562},{6,539}]};

get_draconic_strong_info(2,50) ->
	#base_draconic_strong{id = 2,lv = 50,cost = [{255,36255095,50650}],add_attr = [{2,16900},{6,550}]};

get_draconic_strong_info(2,51) ->
	#base_draconic_strong{id = 2,lv = 51,cost = [{255,36255095,53380}],add_attr = [{2,17238},{6,561}]};

get_draconic_strong_info(2,52) ->
	#base_draconic_strong{id = 2,lv = 52,cost = [{255,36255095,56250}],add_attr = [{2,17576},{6,572}]};

get_draconic_strong_info(2,53) ->
	#base_draconic_strong{id = 2,lv = 53,cost = [{255,36255095,59260}],add_attr = [{2,17914},{6,583}]};

get_draconic_strong_info(2,54) ->
	#base_draconic_strong{id = 2,lv = 54,cost = [{255,36255095,62420}],add_attr = [{2,18252},{6,594}]};

get_draconic_strong_info(2,55) ->
	#base_draconic_strong{id = 2,lv = 55,cost = [{255,36255095,65740}],add_attr = [{2,18590},{6,605}]};

get_draconic_strong_info(2,56) ->
	#base_draconic_strong{id = 2,lv = 56,cost = [{255,36255095,69230}],add_attr = [{2,18928},{6,616}]};

get_draconic_strong_info(2,57) ->
	#base_draconic_strong{id = 2,lv = 57,cost = [{255,36255095,72890}],add_attr = [{2,19266},{6,627}]};

get_draconic_strong_info(2,58) ->
	#base_draconic_strong{id = 2,lv = 58,cost = [{255,36255095,76730}],add_attr = [{2,19604},{6,638}]};

get_draconic_strong_info(2,59) ->
	#base_draconic_strong{id = 2,lv = 59,cost = [{255,36255095,80770}],add_attr = [{2,19942},{6,649}]};

get_draconic_strong_info(2,60) ->
	#base_draconic_strong{id = 2,lv = 60,cost = [{255,36255095,85010}],add_attr = [{2,20280},{6,660}]};

get_draconic_strong_info(2,61) ->
	#base_draconic_strong{id = 2,lv = 61,cost = [{255,36255095,89460}],add_attr = [{2,20618},{6,671}]};

get_draconic_strong_info(2,62) ->
	#base_draconic_strong{id = 2,lv = 62,cost = [{255,36255095,94130}],add_attr = [{2,20956},{6,682}]};

get_draconic_strong_info(2,63) ->
	#base_draconic_strong{id = 2,lv = 63,cost = [{255,36255095,99040}],add_attr = [{2,21294},{6,693}]};

get_draconic_strong_info(2,64) ->
	#base_draconic_strong{id = 2,lv = 64,cost = [{255,36255095,104190}],add_attr = [{2,21632},{6,704}]};

get_draconic_strong_info(2,65) ->
	#base_draconic_strong{id = 2,lv = 65,cost = [{255,36255095,109600}],add_attr = [{2,21970},{6,715}]};

get_draconic_strong_info(2,66) ->
	#base_draconic_strong{id = 2,lv = 66,cost = [{255,36255095,115280}],add_attr = [{2,22308},{6,726}]};

get_draconic_strong_info(2,67) ->
	#base_draconic_strong{id = 2,lv = 67,cost = [{255,36255095,121240}],add_attr = [{2,22646},{6,737}]};

get_draconic_strong_info(2,68) ->
	#base_draconic_strong{id = 2,lv = 68,cost = [{255,36255095,127500}],add_attr = [{2,22984},{6,748}]};

get_draconic_strong_info(2,69) ->
	#base_draconic_strong{id = 2,lv = 69,cost = [{255,36255095,134080}],add_attr = [{2,23322},{6,759}]};

get_draconic_strong_info(2,70) ->
	#base_draconic_strong{id = 2,lv = 70,cost = [{255,36255095,140980}],add_attr = [{2,23660},{6,770}]};

get_draconic_strong_info(2,71) ->
	#base_draconic_strong{id = 2,lv = 71,cost = [{255,36255095,148230}],add_attr = [{2,23998},{6,781}]};

get_draconic_strong_info(2,72) ->
	#base_draconic_strong{id = 2,lv = 72,cost = [{255,36255095,155840}],add_attr = [{2,24336},{6,792}]};

get_draconic_strong_info(2,73) ->
	#base_draconic_strong{id = 2,lv = 73,cost = [{255,36255095,163830}],add_attr = [{2,24674},{6,803}]};

get_draconic_strong_info(2,74) ->
	#base_draconic_strong{id = 2,lv = 74,cost = [{255,36255095,172220}],add_attr = [{2,25012},{6,814}]};

get_draconic_strong_info(2,75) ->
	#base_draconic_strong{id = 2,lv = 75,cost = [{255,36255095,181030}],add_attr = [{2,25350},{6,825}]};

get_draconic_strong_info(2,76) ->
	#base_draconic_strong{id = 2,lv = 76,cost = [{255,36255095,190280}],add_attr = [{2,25688},{6,836}]};

get_draconic_strong_info(2,77) ->
	#base_draconic_strong{id = 2,lv = 77,cost = [{255,36255095,199990}],add_attr = [{2,26026},{6,847}]};

get_draconic_strong_info(2,78) ->
	#base_draconic_strong{id = 2,lv = 78,cost = [{255,36255095,210190}],add_attr = [{2,26364},{6,858}]};

get_draconic_strong_info(2,79) ->
	#base_draconic_strong{id = 2,lv = 79,cost = [{255,36255095,220900}],add_attr = [{2,26702},{6,869}]};

get_draconic_strong_info(2,80) ->
	#base_draconic_strong{id = 2,lv = 80,cost = [{255,36255095,232150}],add_attr = [{2,27040},{6,880}]};

get_draconic_strong_info(2,81) ->
	#base_draconic_strong{id = 2,lv = 81,cost = [{255,36255095,243960}],add_attr = [{2,27378},{6,891}]};

get_draconic_strong_info(2,82) ->
	#base_draconic_strong{id = 2,lv = 82,cost = [{255,36255095,256360}],add_attr = [{2,27716},{6,902}]};

get_draconic_strong_info(2,83) ->
	#base_draconic_strong{id = 2,lv = 83,cost = [{255,36255095,269380}],add_attr = [{2,28054},{6,913}]};

get_draconic_strong_info(2,84) ->
	#base_draconic_strong{id = 2,lv = 84,cost = [{255,36255095,283050}],add_attr = [{2,28392},{6,924}]};

get_draconic_strong_info(2,85) ->
	#base_draconic_strong{id = 2,lv = 85,cost = [{255,36255095,297400}],add_attr = [{2,28730},{6,935}]};

get_draconic_strong_info(2,86) ->
	#base_draconic_strong{id = 2,lv = 86,cost = [{255,36255095,312470}],add_attr = [{2,29068},{6,946}]};

get_draconic_strong_info(2,87) ->
	#base_draconic_strong{id = 2,lv = 87,cost = [{255,36255095,328290}],add_attr = [{2,29406},{6,957}]};

get_draconic_strong_info(2,88) ->
	#base_draconic_strong{id = 2,lv = 88,cost = [{255,36255095,344900}],add_attr = [{2,29744},{6,968}]};

get_draconic_strong_info(2,89) ->
	#base_draconic_strong{id = 2,lv = 89,cost = [{255,36255095,362350}],add_attr = [{2,30082},{6,979}]};

get_draconic_strong_info(2,90) ->
	#base_draconic_strong{id = 2,lv = 90,cost = [{255,36255095,380670}],add_attr = [{2,30420},{6,990}]};

get_draconic_strong_info(2,91) ->
	#base_draconic_strong{id = 2,lv = 91,cost = [{255,36255095,399900}],add_attr = [{2,30758},{6,1001}]};

get_draconic_strong_info(2,92) ->
	#base_draconic_strong{id = 2,lv = 92,cost = [{255,36255095,420100}],add_attr = [{2,31096},{6,1012}]};

get_draconic_strong_info(2,93) ->
	#base_draconic_strong{id = 2,lv = 93,cost = [{255,36255095,441310}],add_attr = [{2,31434},{6,1023}]};

get_draconic_strong_info(2,94) ->
	#base_draconic_strong{id = 2,lv = 94,cost = [{255,36255095,463580}],add_attr = [{2,31772},{6,1034}]};

get_draconic_strong_info(2,95) ->
	#base_draconic_strong{id = 2,lv = 95,cost = [{255,36255095,486960}],add_attr = [{2,32110},{6,1045}]};

get_draconic_strong_info(2,96) ->
	#base_draconic_strong{id = 2,lv = 96,cost = [{255,36255095,511510}],add_attr = [{2,32448},{6,1056}]};

get_draconic_strong_info(2,97) ->
	#base_draconic_strong{id = 2,lv = 97,cost = [{255,36255095,537290}],add_attr = [{2,32786},{6,1067}]};

get_draconic_strong_info(2,98) ->
	#base_draconic_strong{id = 2,lv = 98,cost = [{255,36255095,564350}],add_attr = [{2,33124},{6,1078}]};

get_draconic_strong_info(2,99) ->
	#base_draconic_strong{id = 2,lv = 99,cost = [{255,36255095,592770}],add_attr = [{2,33462},{6,1089}]};

get_draconic_strong_info(2,100) ->
	#base_draconic_strong{id = 2,lv = 100,cost = [{255,36255095,622610}],add_attr = [{2,33800},{6,1100}]};

get_draconic_strong_info(3,0) ->
	#base_draconic_strong{id = 3,lv = 0,cost = [],add_attr = [{2,0},{4,0}]};

get_draconic_strong_info(3,1) ->
	#base_draconic_strong{id = 3,lv = 1,cost = [{255,36255095,1000}],add_attr = [{2,270},{4,7}]};

get_draconic_strong_info(3,2) ->
	#base_draconic_strong{id = 3,lv = 2,cost = [{255,36255095,1250}],add_attr = [{2,540},{4,14}]};

get_draconic_strong_info(3,3) ->
	#base_draconic_strong{id = 3,lv = 3,cost = [{255,36255095,1510}],add_attr = [{2,810},{4,21}]};

get_draconic_strong_info(3,4) ->
	#base_draconic_strong{id = 3,lv = 4,cost = [{255,36255095,1790}],add_attr = [{2,1080},{4,28}]};

get_draconic_strong_info(3,5) ->
	#base_draconic_strong{id = 3,lv = 5,cost = [{255,36255095,2080}],add_attr = [{2,1350},{4,35}]};

get_draconic_strong_info(3,6) ->
	#base_draconic_strong{id = 3,lv = 6,cost = [{255,36255095,2380}],add_attr = [{2,1620},{4,42}]};

get_draconic_strong_info(3,7) ->
	#base_draconic_strong{id = 3,lv = 7,cost = [{255,36255095,2700}],add_attr = [{2,1890},{4,49}]};

get_draconic_strong_info(3,8) ->
	#base_draconic_strong{id = 3,lv = 8,cost = [{255,36255095,3040}],add_attr = [{2,2160},{4,56}]};

get_draconic_strong_info(3,9) ->
	#base_draconic_strong{id = 3,lv = 9,cost = [{255,36255095,3390}],add_attr = [{2,2430},{4,63}]};

get_draconic_strong_info(3,10) ->
	#base_draconic_strong{id = 3,lv = 10,cost = [{255,36255095,3760}],add_attr = [{2,2700},{4,70}]};

get_draconic_strong_info(3,11) ->
	#base_draconic_strong{id = 3,lv = 11,cost = [{255,36255095,4150}],add_attr = [{2,2970},{4,77}]};

get_draconic_strong_info(3,12) ->
	#base_draconic_strong{id = 3,lv = 12,cost = [{255,36255095,4560}],add_attr = [{2,3240},{4,84}]};

get_draconic_strong_info(3,13) ->
	#base_draconic_strong{id = 3,lv = 13,cost = [{255,36255095,4990}],add_attr = [{2,3510},{4,91}]};

get_draconic_strong_info(3,14) ->
	#base_draconic_strong{id = 3,lv = 14,cost = [{255,36255095,5440}],add_attr = [{2,3780},{4,98}]};

get_draconic_strong_info(3,15) ->
	#base_draconic_strong{id = 3,lv = 15,cost = [{255,36255095,5910}],add_attr = [{2,4050},{4,105}]};

get_draconic_strong_info(3,16) ->
	#base_draconic_strong{id = 3,lv = 16,cost = [{255,36255095,6410}],add_attr = [{2,4320},{4,112}]};

get_draconic_strong_info(3,17) ->
	#base_draconic_strong{id = 3,lv = 17,cost = [{255,36255095,6930}],add_attr = [{2,4590},{4,119}]};

get_draconic_strong_info(3,18) ->
	#base_draconic_strong{id = 3,lv = 18,cost = [{255,36255095,7480}],add_attr = [{2,4860},{4,126}]};

get_draconic_strong_info(3,19) ->
	#base_draconic_strong{id = 3,lv = 19,cost = [{255,36255095,8050}],add_attr = [{2,5130},{4,133}]};

get_draconic_strong_info(3,20) ->
	#base_draconic_strong{id = 3,lv = 20,cost = [{255,36255095,8650}],add_attr = [{2,5400},{4,140}]};

get_draconic_strong_info(3,21) ->
	#base_draconic_strong{id = 3,lv = 21,cost = [{255,36255095,9280}],add_attr = [{2,5670},{4,147}]};

get_draconic_strong_info(3,22) ->
	#base_draconic_strong{id = 3,lv = 22,cost = [{255,36255095,9940}],add_attr = [{2,5940},{4,154}]};

get_draconic_strong_info(3,23) ->
	#base_draconic_strong{id = 3,lv = 23,cost = [{255,36255095,10640}],add_attr = [{2,6210},{4,161}]};

get_draconic_strong_info(3,24) ->
	#base_draconic_strong{id = 3,lv = 24,cost = [{255,36255095,11370}],add_attr = [{2,6480},{4,168}]};

get_draconic_strong_info(3,25) ->
	#base_draconic_strong{id = 3,lv = 25,cost = [{255,36255095,12140}],add_attr = [{2,6750},{4,175}]};

get_draconic_strong_info(3,26) ->
	#base_draconic_strong{id = 3,lv = 26,cost = [{255,36255095,12950}],add_attr = [{2,7020},{4,182}]};

get_draconic_strong_info(3,27) ->
	#base_draconic_strong{id = 3,lv = 27,cost = [{255,36255095,13800}],add_attr = [{2,7290},{4,189}]};

get_draconic_strong_info(3,28) ->
	#base_draconic_strong{id = 3,lv = 28,cost = [{255,36255095,14690}],add_attr = [{2,7560},{4,196}]};

get_draconic_strong_info(3,29) ->
	#base_draconic_strong{id = 3,lv = 29,cost = [{255,36255095,15620}],add_attr = [{2,7830},{4,203}]};

get_draconic_strong_info(3,30) ->
	#base_draconic_strong{id = 3,lv = 30,cost = [{255,36255095,16600}],add_attr = [{2,8100},{4,210}]};

get_draconic_strong_info(3,31) ->
	#base_draconic_strong{id = 3,lv = 31,cost = [{255,36255095,17630}],add_attr = [{2,8370},{4,217}]};

get_draconic_strong_info(3,32) ->
	#base_draconic_strong{id = 3,lv = 32,cost = [{255,36255095,18710}],add_attr = [{2,8640},{4,224}]};

get_draconic_strong_info(3,33) ->
	#base_draconic_strong{id = 3,lv = 33,cost = [{255,36255095,19850}],add_attr = [{2,8910},{4,231}]};

get_draconic_strong_info(3,34) ->
	#base_draconic_strong{id = 3,lv = 34,cost = [{255,36255095,21040}],add_attr = [{2,9180},{4,238}]};

get_draconic_strong_info(3,35) ->
	#base_draconic_strong{id = 3,lv = 35,cost = [{255,36255095,22290}],add_attr = [{2,9450},{4,245}]};

get_draconic_strong_info(3,36) ->
	#base_draconic_strong{id = 3,lv = 36,cost = [{255,36255095,23600}],add_attr = [{2,9720},{4,252}]};

get_draconic_strong_info(3,37) ->
	#base_draconic_strong{id = 3,lv = 37,cost = [{255,36255095,24980}],add_attr = [{2,9990},{4,259}]};

get_draconic_strong_info(3,38) ->
	#base_draconic_strong{id = 3,lv = 38,cost = [{255,36255095,26430}],add_attr = [{2,10260},{4,266}]};

get_draconic_strong_info(3,39) ->
	#base_draconic_strong{id = 3,lv = 39,cost = [{255,36255095,27950}],add_attr = [{2,10530},{4,273}]};

get_draconic_strong_info(3,40) ->
	#base_draconic_strong{id = 3,lv = 40,cost = [{255,36255095,29550}],add_attr = [{2,10800},{4,280}]};

get_draconic_strong_info(3,41) ->
	#base_draconic_strong{id = 3,lv = 41,cost = [{255,36255095,31230}],add_attr = [{2,11070},{4,287}]};

get_draconic_strong_info(3,42) ->
	#base_draconic_strong{id = 3,lv = 42,cost = [{255,36255095,32990}],add_attr = [{2,11340},{4,294}]};

get_draconic_strong_info(3,43) ->
	#base_draconic_strong{id = 3,lv = 43,cost = [{255,36255095,34840}],add_attr = [{2,11610},{4,301}]};

get_draconic_strong_info(3,44) ->
	#base_draconic_strong{id = 3,lv = 44,cost = [{255,36255095,36780}],add_attr = [{2,11880},{4,308}]};

get_draconic_strong_info(3,45) ->
	#base_draconic_strong{id = 3,lv = 45,cost = [{255,36255095,38820}],add_attr = [{2,12150},{4,315}]};

get_draconic_strong_info(3,46) ->
	#base_draconic_strong{id = 3,lv = 46,cost = [{255,36255095,40960}],add_attr = [{2,12420},{4,322}]};

get_draconic_strong_info(3,47) ->
	#base_draconic_strong{id = 3,lv = 47,cost = [{255,36255095,43210}],add_attr = [{2,12690},{4,329}]};

get_draconic_strong_info(3,48) ->
	#base_draconic_strong{id = 3,lv = 48,cost = [{255,36255095,45570}],add_attr = [{2,12960},{4,336}]};

get_draconic_strong_info(3,49) ->
	#base_draconic_strong{id = 3,lv = 49,cost = [{255,36255095,48050}],add_attr = [{2,13230},{4,343}]};

get_draconic_strong_info(3,50) ->
	#base_draconic_strong{id = 3,lv = 50,cost = [{255,36255095,50650}],add_attr = [{2,13500},{4,350}]};

get_draconic_strong_info(3,51) ->
	#base_draconic_strong{id = 3,lv = 51,cost = [{255,36255095,53380}],add_attr = [{2,13770},{4,357}]};

get_draconic_strong_info(3,52) ->
	#base_draconic_strong{id = 3,lv = 52,cost = [{255,36255095,56250}],add_attr = [{2,14040},{4,364}]};

get_draconic_strong_info(3,53) ->
	#base_draconic_strong{id = 3,lv = 53,cost = [{255,36255095,59260}],add_attr = [{2,14310},{4,371}]};

get_draconic_strong_info(3,54) ->
	#base_draconic_strong{id = 3,lv = 54,cost = [{255,36255095,62420}],add_attr = [{2,14580},{4,378}]};

get_draconic_strong_info(3,55) ->
	#base_draconic_strong{id = 3,lv = 55,cost = [{255,36255095,65740}],add_attr = [{2,14850},{4,385}]};

get_draconic_strong_info(3,56) ->
	#base_draconic_strong{id = 3,lv = 56,cost = [{255,36255095,69230}],add_attr = [{2,15120},{4,392}]};

get_draconic_strong_info(3,57) ->
	#base_draconic_strong{id = 3,lv = 57,cost = [{255,36255095,72890}],add_attr = [{2,15390},{4,399}]};

get_draconic_strong_info(3,58) ->
	#base_draconic_strong{id = 3,lv = 58,cost = [{255,36255095,76730}],add_attr = [{2,15660},{4,406}]};

get_draconic_strong_info(3,59) ->
	#base_draconic_strong{id = 3,lv = 59,cost = [{255,36255095,80770}],add_attr = [{2,15930},{4,413}]};

get_draconic_strong_info(3,60) ->
	#base_draconic_strong{id = 3,lv = 60,cost = [{255,36255095,85010}],add_attr = [{2,16200},{4,420}]};

get_draconic_strong_info(3,61) ->
	#base_draconic_strong{id = 3,lv = 61,cost = [{255,36255095,89460}],add_attr = [{2,16470},{4,427}]};

get_draconic_strong_info(3,62) ->
	#base_draconic_strong{id = 3,lv = 62,cost = [{255,36255095,94130}],add_attr = [{2,16740},{4,434}]};

get_draconic_strong_info(3,63) ->
	#base_draconic_strong{id = 3,lv = 63,cost = [{255,36255095,99040}],add_attr = [{2,17010},{4,441}]};

get_draconic_strong_info(3,64) ->
	#base_draconic_strong{id = 3,lv = 64,cost = [{255,36255095,104190}],add_attr = [{2,17280},{4,448}]};

get_draconic_strong_info(3,65) ->
	#base_draconic_strong{id = 3,lv = 65,cost = [{255,36255095,109600}],add_attr = [{2,17550},{4,455}]};

get_draconic_strong_info(3,66) ->
	#base_draconic_strong{id = 3,lv = 66,cost = [{255,36255095,115280}],add_attr = [{2,17820},{4,462}]};

get_draconic_strong_info(3,67) ->
	#base_draconic_strong{id = 3,lv = 67,cost = [{255,36255095,121240}],add_attr = [{2,18090},{4,469}]};

get_draconic_strong_info(3,68) ->
	#base_draconic_strong{id = 3,lv = 68,cost = [{255,36255095,127500}],add_attr = [{2,18360},{4,476}]};

get_draconic_strong_info(3,69) ->
	#base_draconic_strong{id = 3,lv = 69,cost = [{255,36255095,134080}],add_attr = [{2,18630},{4,483}]};

get_draconic_strong_info(3,70) ->
	#base_draconic_strong{id = 3,lv = 70,cost = [{255,36255095,140980}],add_attr = [{2,18900},{4,490}]};

get_draconic_strong_info(3,71) ->
	#base_draconic_strong{id = 3,lv = 71,cost = [{255,36255095,148230}],add_attr = [{2,19170},{4,497}]};

get_draconic_strong_info(3,72) ->
	#base_draconic_strong{id = 3,lv = 72,cost = [{255,36255095,155840}],add_attr = [{2,19440},{4,504}]};

get_draconic_strong_info(3,73) ->
	#base_draconic_strong{id = 3,lv = 73,cost = [{255,36255095,163830}],add_attr = [{2,19710},{4,511}]};

get_draconic_strong_info(3,74) ->
	#base_draconic_strong{id = 3,lv = 74,cost = [{255,36255095,172220}],add_attr = [{2,19980},{4,518}]};

get_draconic_strong_info(3,75) ->
	#base_draconic_strong{id = 3,lv = 75,cost = [{255,36255095,181030}],add_attr = [{2,20250},{4,525}]};

get_draconic_strong_info(3,76) ->
	#base_draconic_strong{id = 3,lv = 76,cost = [{255,36255095,190280}],add_attr = [{2,20520},{4,532}]};

get_draconic_strong_info(3,77) ->
	#base_draconic_strong{id = 3,lv = 77,cost = [{255,36255095,199990}],add_attr = [{2,20790},{4,539}]};

get_draconic_strong_info(3,78) ->
	#base_draconic_strong{id = 3,lv = 78,cost = [{255,36255095,210190}],add_attr = [{2,21060},{4,546}]};

get_draconic_strong_info(3,79) ->
	#base_draconic_strong{id = 3,lv = 79,cost = [{255,36255095,220900}],add_attr = [{2,21330},{4,553}]};

get_draconic_strong_info(3,80) ->
	#base_draconic_strong{id = 3,lv = 80,cost = [{255,36255095,232150}],add_attr = [{2,21600},{4,560}]};

get_draconic_strong_info(3,81) ->
	#base_draconic_strong{id = 3,lv = 81,cost = [{255,36255095,243960}],add_attr = [{2,21870},{4,567}]};

get_draconic_strong_info(3,82) ->
	#base_draconic_strong{id = 3,lv = 82,cost = [{255,36255095,256360}],add_attr = [{2,22140},{4,574}]};

get_draconic_strong_info(3,83) ->
	#base_draconic_strong{id = 3,lv = 83,cost = [{255,36255095,269380}],add_attr = [{2,22410},{4,581}]};

get_draconic_strong_info(3,84) ->
	#base_draconic_strong{id = 3,lv = 84,cost = [{255,36255095,283050}],add_attr = [{2,22680},{4,588}]};

get_draconic_strong_info(3,85) ->
	#base_draconic_strong{id = 3,lv = 85,cost = [{255,36255095,297400}],add_attr = [{2,22950},{4,595}]};

get_draconic_strong_info(3,86) ->
	#base_draconic_strong{id = 3,lv = 86,cost = [{255,36255095,312470}],add_attr = [{2,23220},{4,602}]};

get_draconic_strong_info(3,87) ->
	#base_draconic_strong{id = 3,lv = 87,cost = [{255,36255095,328290}],add_attr = [{2,23490},{4,609}]};

get_draconic_strong_info(3,88) ->
	#base_draconic_strong{id = 3,lv = 88,cost = [{255,36255095,344900}],add_attr = [{2,23760},{4,616}]};

get_draconic_strong_info(3,89) ->
	#base_draconic_strong{id = 3,lv = 89,cost = [{255,36255095,362350}],add_attr = [{2,24030},{4,623}]};

get_draconic_strong_info(3,90) ->
	#base_draconic_strong{id = 3,lv = 90,cost = [{255,36255095,380670}],add_attr = [{2,24300},{4,630}]};

get_draconic_strong_info(3,91) ->
	#base_draconic_strong{id = 3,lv = 91,cost = [{255,36255095,399900}],add_attr = [{2,24570},{4,637}]};

get_draconic_strong_info(3,92) ->
	#base_draconic_strong{id = 3,lv = 92,cost = [{255,36255095,420100}],add_attr = [{2,24840},{4,644}]};

get_draconic_strong_info(3,93) ->
	#base_draconic_strong{id = 3,lv = 93,cost = [{255,36255095,441310}],add_attr = [{2,25110},{4,651}]};

get_draconic_strong_info(3,94) ->
	#base_draconic_strong{id = 3,lv = 94,cost = [{255,36255095,463580}],add_attr = [{2,25380},{4,658}]};

get_draconic_strong_info(3,95) ->
	#base_draconic_strong{id = 3,lv = 95,cost = [{255,36255095,486960}],add_attr = [{2,25650},{4,665}]};

get_draconic_strong_info(3,96) ->
	#base_draconic_strong{id = 3,lv = 96,cost = [{255,36255095,511510}],add_attr = [{2,25920},{4,672}]};

get_draconic_strong_info(3,97) ->
	#base_draconic_strong{id = 3,lv = 97,cost = [{255,36255095,537290}],add_attr = [{2,26190},{4,679}]};

get_draconic_strong_info(3,98) ->
	#base_draconic_strong{id = 3,lv = 98,cost = [{255,36255095,564350}],add_attr = [{2,26460},{4,686}]};

get_draconic_strong_info(3,99) ->
	#base_draconic_strong{id = 3,lv = 99,cost = [{255,36255095,592770}],add_attr = [{2,26730},{4,693}]};

get_draconic_strong_info(3,100) ->
	#base_draconic_strong{id = 3,lv = 100,cost = [{255,36255095,622610}],add_attr = [{2,27000},{4,700}]};

get_draconic_strong_info(4,0) ->
	#base_draconic_strong{id = 4,lv = 0,cost = [],add_attr = [{2,0},{8,0}]};

get_draconic_strong_info(4,1) ->
	#base_draconic_strong{id = 4,lv = 1,cost = [{255,36255095,1000}],add_attr = [{2,338},{8,16}]};

get_draconic_strong_info(4,2) ->
	#base_draconic_strong{id = 4,lv = 2,cost = [{255,36255095,1250}],add_attr = [{2,676},{8,32}]};

get_draconic_strong_info(4,3) ->
	#base_draconic_strong{id = 4,lv = 3,cost = [{255,36255095,1510}],add_attr = [{2,1014},{8,48}]};

get_draconic_strong_info(4,4) ->
	#base_draconic_strong{id = 4,lv = 4,cost = [{255,36255095,1790}],add_attr = [{2,1352},{8,64}]};

get_draconic_strong_info(4,5) ->
	#base_draconic_strong{id = 4,lv = 5,cost = [{255,36255095,2080}],add_attr = [{2,1690},{8,80}]};

get_draconic_strong_info(4,6) ->
	#base_draconic_strong{id = 4,lv = 6,cost = [{255,36255095,2380}],add_attr = [{2,2028},{8,96}]};

get_draconic_strong_info(4,7) ->
	#base_draconic_strong{id = 4,lv = 7,cost = [{255,36255095,2700}],add_attr = [{2,2366},{8,112}]};

get_draconic_strong_info(4,8) ->
	#base_draconic_strong{id = 4,lv = 8,cost = [{255,36255095,3040}],add_attr = [{2,2704},{8,128}]};

get_draconic_strong_info(4,9) ->
	#base_draconic_strong{id = 4,lv = 9,cost = [{255,36255095,3390}],add_attr = [{2,3042},{8,144}]};

get_draconic_strong_info(4,10) ->
	#base_draconic_strong{id = 4,lv = 10,cost = [{255,36255095,3760}],add_attr = [{2,3380},{8,160}]};

get_draconic_strong_info(4,11) ->
	#base_draconic_strong{id = 4,lv = 11,cost = [{255,36255095,4150}],add_attr = [{2,3718},{8,176}]};

get_draconic_strong_info(4,12) ->
	#base_draconic_strong{id = 4,lv = 12,cost = [{255,36255095,4560}],add_attr = [{2,4056},{8,192}]};

get_draconic_strong_info(4,13) ->
	#base_draconic_strong{id = 4,lv = 13,cost = [{255,36255095,4990}],add_attr = [{2,4394},{8,208}]};

get_draconic_strong_info(4,14) ->
	#base_draconic_strong{id = 4,lv = 14,cost = [{255,36255095,5440}],add_attr = [{2,4732},{8,224}]};

get_draconic_strong_info(4,15) ->
	#base_draconic_strong{id = 4,lv = 15,cost = [{255,36255095,5910}],add_attr = [{2,5070},{8,240}]};

get_draconic_strong_info(4,16) ->
	#base_draconic_strong{id = 4,lv = 16,cost = [{255,36255095,6410}],add_attr = [{2,5408},{8,256}]};

get_draconic_strong_info(4,17) ->
	#base_draconic_strong{id = 4,lv = 17,cost = [{255,36255095,6930}],add_attr = [{2,5746},{8,272}]};

get_draconic_strong_info(4,18) ->
	#base_draconic_strong{id = 4,lv = 18,cost = [{255,36255095,7480}],add_attr = [{2,6084},{8,288}]};

get_draconic_strong_info(4,19) ->
	#base_draconic_strong{id = 4,lv = 19,cost = [{255,36255095,8050}],add_attr = [{2,6422},{8,304}]};

get_draconic_strong_info(4,20) ->
	#base_draconic_strong{id = 4,lv = 20,cost = [{255,36255095,8650}],add_attr = [{2,6760},{8,320}]};

get_draconic_strong_info(4,21) ->
	#base_draconic_strong{id = 4,lv = 21,cost = [{255,36255095,9280}],add_attr = [{2,7098},{8,336}]};

get_draconic_strong_info(4,22) ->
	#base_draconic_strong{id = 4,lv = 22,cost = [{255,36255095,9940}],add_attr = [{2,7436},{8,352}]};

get_draconic_strong_info(4,23) ->
	#base_draconic_strong{id = 4,lv = 23,cost = [{255,36255095,10640}],add_attr = [{2,7774},{8,368}]};

get_draconic_strong_info(4,24) ->
	#base_draconic_strong{id = 4,lv = 24,cost = [{255,36255095,11370}],add_attr = [{2,8112},{8,384}]};

get_draconic_strong_info(4,25) ->
	#base_draconic_strong{id = 4,lv = 25,cost = [{255,36255095,12140}],add_attr = [{2,8450},{8,400}]};

get_draconic_strong_info(4,26) ->
	#base_draconic_strong{id = 4,lv = 26,cost = [{255,36255095,12950}],add_attr = [{2,8788},{8,416}]};

get_draconic_strong_info(4,27) ->
	#base_draconic_strong{id = 4,lv = 27,cost = [{255,36255095,13800}],add_attr = [{2,9126},{8,432}]};

get_draconic_strong_info(4,28) ->
	#base_draconic_strong{id = 4,lv = 28,cost = [{255,36255095,14690}],add_attr = [{2,9464},{8,448}]};

get_draconic_strong_info(4,29) ->
	#base_draconic_strong{id = 4,lv = 29,cost = [{255,36255095,15620}],add_attr = [{2,9802},{8,464}]};

get_draconic_strong_info(4,30) ->
	#base_draconic_strong{id = 4,lv = 30,cost = [{255,36255095,16600}],add_attr = [{2,10140},{8,480}]};

get_draconic_strong_info(4,31) ->
	#base_draconic_strong{id = 4,lv = 31,cost = [{255,36255095,17630}],add_attr = [{2,10478},{8,496}]};

get_draconic_strong_info(4,32) ->
	#base_draconic_strong{id = 4,lv = 32,cost = [{255,36255095,18710}],add_attr = [{2,10816},{8,512}]};

get_draconic_strong_info(4,33) ->
	#base_draconic_strong{id = 4,lv = 33,cost = [{255,36255095,19850}],add_attr = [{2,11154},{8,528}]};

get_draconic_strong_info(4,34) ->
	#base_draconic_strong{id = 4,lv = 34,cost = [{255,36255095,21040}],add_attr = [{2,11492},{8,544}]};

get_draconic_strong_info(4,35) ->
	#base_draconic_strong{id = 4,lv = 35,cost = [{255,36255095,22290}],add_attr = [{2,11830},{8,560}]};

get_draconic_strong_info(4,36) ->
	#base_draconic_strong{id = 4,lv = 36,cost = [{255,36255095,23600}],add_attr = [{2,12168},{8,576}]};

get_draconic_strong_info(4,37) ->
	#base_draconic_strong{id = 4,lv = 37,cost = [{255,36255095,24980}],add_attr = [{2,12506},{8,592}]};

get_draconic_strong_info(4,38) ->
	#base_draconic_strong{id = 4,lv = 38,cost = [{255,36255095,26430}],add_attr = [{2,12844},{8,608}]};

get_draconic_strong_info(4,39) ->
	#base_draconic_strong{id = 4,lv = 39,cost = [{255,36255095,27950}],add_attr = [{2,13182},{8,624}]};

get_draconic_strong_info(4,40) ->
	#base_draconic_strong{id = 4,lv = 40,cost = [{255,36255095,29550}],add_attr = [{2,13520},{8,640}]};

get_draconic_strong_info(4,41) ->
	#base_draconic_strong{id = 4,lv = 41,cost = [{255,36255095,31230}],add_attr = [{2,13858},{8,656}]};

get_draconic_strong_info(4,42) ->
	#base_draconic_strong{id = 4,lv = 42,cost = [{255,36255095,32990}],add_attr = [{2,14196},{8,672}]};

get_draconic_strong_info(4,43) ->
	#base_draconic_strong{id = 4,lv = 43,cost = [{255,36255095,34840}],add_attr = [{2,14534},{8,688}]};

get_draconic_strong_info(4,44) ->
	#base_draconic_strong{id = 4,lv = 44,cost = [{255,36255095,36780}],add_attr = [{2,14872},{8,704}]};

get_draconic_strong_info(4,45) ->
	#base_draconic_strong{id = 4,lv = 45,cost = [{255,36255095,38820}],add_attr = [{2,15210},{8,720}]};

get_draconic_strong_info(4,46) ->
	#base_draconic_strong{id = 4,lv = 46,cost = [{255,36255095,40960}],add_attr = [{2,15548},{8,736}]};

get_draconic_strong_info(4,47) ->
	#base_draconic_strong{id = 4,lv = 47,cost = [{255,36255095,43210}],add_attr = [{2,15886},{8,752}]};

get_draconic_strong_info(4,48) ->
	#base_draconic_strong{id = 4,lv = 48,cost = [{255,36255095,45570}],add_attr = [{2,16224},{8,768}]};

get_draconic_strong_info(4,49) ->
	#base_draconic_strong{id = 4,lv = 49,cost = [{255,36255095,48050}],add_attr = [{2,16562},{8,784}]};

get_draconic_strong_info(4,50) ->
	#base_draconic_strong{id = 4,lv = 50,cost = [{255,36255095,50650}],add_attr = [{2,16900},{8,800}]};

get_draconic_strong_info(4,51) ->
	#base_draconic_strong{id = 4,lv = 51,cost = [{255,36255095,53380}],add_attr = [{2,17238},{8,816}]};

get_draconic_strong_info(4,52) ->
	#base_draconic_strong{id = 4,lv = 52,cost = [{255,36255095,56250}],add_attr = [{2,17576},{8,832}]};

get_draconic_strong_info(4,53) ->
	#base_draconic_strong{id = 4,lv = 53,cost = [{255,36255095,59260}],add_attr = [{2,17914},{8,848}]};

get_draconic_strong_info(4,54) ->
	#base_draconic_strong{id = 4,lv = 54,cost = [{255,36255095,62420}],add_attr = [{2,18252},{8,864}]};

get_draconic_strong_info(4,55) ->
	#base_draconic_strong{id = 4,lv = 55,cost = [{255,36255095,65740}],add_attr = [{2,18590},{8,880}]};

get_draconic_strong_info(4,56) ->
	#base_draconic_strong{id = 4,lv = 56,cost = [{255,36255095,69230}],add_attr = [{2,18928},{8,896}]};

get_draconic_strong_info(4,57) ->
	#base_draconic_strong{id = 4,lv = 57,cost = [{255,36255095,72890}],add_attr = [{2,19266},{8,912}]};

get_draconic_strong_info(4,58) ->
	#base_draconic_strong{id = 4,lv = 58,cost = [{255,36255095,76730}],add_attr = [{2,19604},{8,928}]};

get_draconic_strong_info(4,59) ->
	#base_draconic_strong{id = 4,lv = 59,cost = [{255,36255095,80770}],add_attr = [{2,19942},{8,944}]};

get_draconic_strong_info(4,60) ->
	#base_draconic_strong{id = 4,lv = 60,cost = [{255,36255095,85010}],add_attr = [{2,20280},{8,960}]};

get_draconic_strong_info(4,61) ->
	#base_draconic_strong{id = 4,lv = 61,cost = [{255,36255095,89460}],add_attr = [{2,20618},{8,976}]};

get_draconic_strong_info(4,62) ->
	#base_draconic_strong{id = 4,lv = 62,cost = [{255,36255095,94130}],add_attr = [{2,20956},{8,992}]};

get_draconic_strong_info(4,63) ->
	#base_draconic_strong{id = 4,lv = 63,cost = [{255,36255095,99040}],add_attr = [{2,21294},{8,1008}]};

get_draconic_strong_info(4,64) ->
	#base_draconic_strong{id = 4,lv = 64,cost = [{255,36255095,104190}],add_attr = [{2,21632},{8,1024}]};

get_draconic_strong_info(4,65) ->
	#base_draconic_strong{id = 4,lv = 65,cost = [{255,36255095,109600}],add_attr = [{2,21970},{8,1040}]};

get_draconic_strong_info(4,66) ->
	#base_draconic_strong{id = 4,lv = 66,cost = [{255,36255095,115280}],add_attr = [{2,22308},{8,1056}]};

get_draconic_strong_info(4,67) ->
	#base_draconic_strong{id = 4,lv = 67,cost = [{255,36255095,121240}],add_attr = [{2,22646},{8,1072}]};

get_draconic_strong_info(4,68) ->
	#base_draconic_strong{id = 4,lv = 68,cost = [{255,36255095,127500}],add_attr = [{2,22984},{8,1088}]};

get_draconic_strong_info(4,69) ->
	#base_draconic_strong{id = 4,lv = 69,cost = [{255,36255095,134080}],add_attr = [{2,23322},{8,1104}]};

get_draconic_strong_info(4,70) ->
	#base_draconic_strong{id = 4,lv = 70,cost = [{255,36255095,140980}],add_attr = [{2,23660},{8,1120}]};

get_draconic_strong_info(4,71) ->
	#base_draconic_strong{id = 4,lv = 71,cost = [{255,36255095,148230}],add_attr = [{2,23998},{8,1136}]};

get_draconic_strong_info(4,72) ->
	#base_draconic_strong{id = 4,lv = 72,cost = [{255,36255095,155840}],add_attr = [{2,24336},{8,1152}]};

get_draconic_strong_info(4,73) ->
	#base_draconic_strong{id = 4,lv = 73,cost = [{255,36255095,163830}],add_attr = [{2,24674},{8,1168}]};

get_draconic_strong_info(4,74) ->
	#base_draconic_strong{id = 4,lv = 74,cost = [{255,36255095,172220}],add_attr = [{2,25012},{8,1184}]};

get_draconic_strong_info(4,75) ->
	#base_draconic_strong{id = 4,lv = 75,cost = [{255,36255095,181030}],add_attr = [{2,25350},{8,1200}]};

get_draconic_strong_info(4,76) ->
	#base_draconic_strong{id = 4,lv = 76,cost = [{255,36255095,190280}],add_attr = [{2,25688},{8,1216}]};

get_draconic_strong_info(4,77) ->
	#base_draconic_strong{id = 4,lv = 77,cost = [{255,36255095,199990}],add_attr = [{2,26026},{8,1232}]};

get_draconic_strong_info(4,78) ->
	#base_draconic_strong{id = 4,lv = 78,cost = [{255,36255095,210190}],add_attr = [{2,26364},{8,1248}]};

get_draconic_strong_info(4,79) ->
	#base_draconic_strong{id = 4,lv = 79,cost = [{255,36255095,220900}],add_attr = [{2,26702},{8,1264}]};

get_draconic_strong_info(4,80) ->
	#base_draconic_strong{id = 4,lv = 80,cost = [{255,36255095,232150}],add_attr = [{2,27040},{8,1280}]};

get_draconic_strong_info(4,81) ->
	#base_draconic_strong{id = 4,lv = 81,cost = [{255,36255095,243960}],add_attr = [{2,27378},{8,1296}]};

get_draconic_strong_info(4,82) ->
	#base_draconic_strong{id = 4,lv = 82,cost = [{255,36255095,256360}],add_attr = [{2,27716},{8,1312}]};

get_draconic_strong_info(4,83) ->
	#base_draconic_strong{id = 4,lv = 83,cost = [{255,36255095,269380}],add_attr = [{2,28054},{8,1328}]};

get_draconic_strong_info(4,84) ->
	#base_draconic_strong{id = 4,lv = 84,cost = [{255,36255095,283050}],add_attr = [{2,28392},{8,1344}]};

get_draconic_strong_info(4,85) ->
	#base_draconic_strong{id = 4,lv = 85,cost = [{255,36255095,297400}],add_attr = [{2,28730},{8,1360}]};

get_draconic_strong_info(4,86) ->
	#base_draconic_strong{id = 4,lv = 86,cost = [{255,36255095,312470}],add_attr = [{2,29068},{8,1376}]};

get_draconic_strong_info(4,87) ->
	#base_draconic_strong{id = 4,lv = 87,cost = [{255,36255095,328290}],add_attr = [{2,29406},{8,1392}]};

get_draconic_strong_info(4,88) ->
	#base_draconic_strong{id = 4,lv = 88,cost = [{255,36255095,344900}],add_attr = [{2,29744},{8,1408}]};

get_draconic_strong_info(4,89) ->
	#base_draconic_strong{id = 4,lv = 89,cost = [{255,36255095,362350}],add_attr = [{2,30082},{8,1424}]};

get_draconic_strong_info(4,90) ->
	#base_draconic_strong{id = 4,lv = 90,cost = [{255,36255095,380670}],add_attr = [{2,30420},{8,1440}]};

get_draconic_strong_info(4,91) ->
	#base_draconic_strong{id = 4,lv = 91,cost = [{255,36255095,399900}],add_attr = [{2,30758},{8,1456}]};

get_draconic_strong_info(4,92) ->
	#base_draconic_strong{id = 4,lv = 92,cost = [{255,36255095,420100}],add_attr = [{2,31096},{8,1472}]};

get_draconic_strong_info(4,93) ->
	#base_draconic_strong{id = 4,lv = 93,cost = [{255,36255095,441310}],add_attr = [{2,31434},{8,1488}]};

get_draconic_strong_info(4,94) ->
	#base_draconic_strong{id = 4,lv = 94,cost = [{255,36255095,463580}],add_attr = [{2,31772},{8,1504}]};

get_draconic_strong_info(4,95) ->
	#base_draconic_strong{id = 4,lv = 95,cost = [{255,36255095,486960}],add_attr = [{2,32110},{8,1520}]};

get_draconic_strong_info(4,96) ->
	#base_draconic_strong{id = 4,lv = 96,cost = [{255,36255095,511510}],add_attr = [{2,32448},{8,1536}]};

get_draconic_strong_info(4,97) ->
	#base_draconic_strong{id = 4,lv = 97,cost = [{255,36255095,537290}],add_attr = [{2,32786},{8,1552}]};

get_draconic_strong_info(4,98) ->
	#base_draconic_strong{id = 4,lv = 98,cost = [{255,36255095,564350}],add_attr = [{2,33124},{8,1568}]};

get_draconic_strong_info(4,99) ->
	#base_draconic_strong{id = 4,lv = 99,cost = [{255,36255095,592770}],add_attr = [{2,33462},{8,1584}]};

get_draconic_strong_info(4,100) ->
	#base_draconic_strong{id = 4,lv = 100,cost = [{255,36255095,622610}],add_attr = [{2,33800},{8,1600}]};

get_draconic_strong_info(5,0) ->
	#base_draconic_strong{id = 5,lv = 0,cost = [],add_attr = [{1,0},{7,0}]};

get_draconic_strong_info(5,1) ->
	#base_draconic_strong{id = 5,lv = 1,cost = [{255,36255095,1000}],add_attr = [{1,17},{7,14}]};

get_draconic_strong_info(5,2) ->
	#base_draconic_strong{id = 5,lv = 2,cost = [{255,36255095,1250}],add_attr = [{1,34},{7,28}]};

get_draconic_strong_info(5,3) ->
	#base_draconic_strong{id = 5,lv = 3,cost = [{255,36255095,1510}],add_attr = [{1,51},{7,42}]};

get_draconic_strong_info(5,4) ->
	#base_draconic_strong{id = 5,lv = 4,cost = [{255,36255095,1790}],add_attr = [{1,68},{7,56}]};

get_draconic_strong_info(5,5) ->
	#base_draconic_strong{id = 5,lv = 5,cost = [{255,36255095,2080}],add_attr = [{1,85},{7,70}]};

get_draconic_strong_info(5,6) ->
	#base_draconic_strong{id = 5,lv = 6,cost = [{255,36255095,2380}],add_attr = [{1,102},{7,84}]};

get_draconic_strong_info(5,7) ->
	#base_draconic_strong{id = 5,lv = 7,cost = [{255,36255095,2700}],add_attr = [{1,119},{7,98}]};

get_draconic_strong_info(5,8) ->
	#base_draconic_strong{id = 5,lv = 8,cost = [{255,36255095,3040}],add_attr = [{1,136},{7,112}]};

get_draconic_strong_info(5,9) ->
	#base_draconic_strong{id = 5,lv = 9,cost = [{255,36255095,3390}],add_attr = [{1,153},{7,126}]};

get_draconic_strong_info(5,10) ->
	#base_draconic_strong{id = 5,lv = 10,cost = [{255,36255095,3760}],add_attr = [{1,170},{7,140}]};

get_draconic_strong_info(5,11) ->
	#base_draconic_strong{id = 5,lv = 11,cost = [{255,36255095,4150}],add_attr = [{1,187},{7,154}]};

get_draconic_strong_info(5,12) ->
	#base_draconic_strong{id = 5,lv = 12,cost = [{255,36255095,4560}],add_attr = [{1,204},{7,168}]};

get_draconic_strong_info(5,13) ->
	#base_draconic_strong{id = 5,lv = 13,cost = [{255,36255095,4990}],add_attr = [{1,221},{7,182}]};

get_draconic_strong_info(5,14) ->
	#base_draconic_strong{id = 5,lv = 14,cost = [{255,36255095,5440}],add_attr = [{1,238},{7,196}]};

get_draconic_strong_info(5,15) ->
	#base_draconic_strong{id = 5,lv = 15,cost = [{255,36255095,5910}],add_attr = [{1,255},{7,210}]};

get_draconic_strong_info(5,16) ->
	#base_draconic_strong{id = 5,lv = 16,cost = [{255,36255095,6410}],add_attr = [{1,272},{7,224}]};

get_draconic_strong_info(5,17) ->
	#base_draconic_strong{id = 5,lv = 17,cost = [{255,36255095,6930}],add_attr = [{1,289},{7,238}]};

get_draconic_strong_info(5,18) ->
	#base_draconic_strong{id = 5,lv = 18,cost = [{255,36255095,7480}],add_attr = [{1,306},{7,252}]};

get_draconic_strong_info(5,19) ->
	#base_draconic_strong{id = 5,lv = 19,cost = [{255,36255095,8050}],add_attr = [{1,323},{7,266}]};

get_draconic_strong_info(5,20) ->
	#base_draconic_strong{id = 5,lv = 20,cost = [{255,36255095,8650}],add_attr = [{1,340},{7,280}]};

get_draconic_strong_info(5,21) ->
	#base_draconic_strong{id = 5,lv = 21,cost = [{255,36255095,9280}],add_attr = [{1,357},{7,294}]};

get_draconic_strong_info(5,22) ->
	#base_draconic_strong{id = 5,lv = 22,cost = [{255,36255095,9940}],add_attr = [{1,374},{7,308}]};

get_draconic_strong_info(5,23) ->
	#base_draconic_strong{id = 5,lv = 23,cost = [{255,36255095,10640}],add_attr = [{1,391},{7,322}]};

get_draconic_strong_info(5,24) ->
	#base_draconic_strong{id = 5,lv = 24,cost = [{255,36255095,11370}],add_attr = [{1,408},{7,336}]};

get_draconic_strong_info(5,25) ->
	#base_draconic_strong{id = 5,lv = 25,cost = [{255,36255095,12140}],add_attr = [{1,425},{7,350}]};

get_draconic_strong_info(5,26) ->
	#base_draconic_strong{id = 5,lv = 26,cost = [{255,36255095,12950}],add_attr = [{1,442},{7,364}]};

get_draconic_strong_info(5,27) ->
	#base_draconic_strong{id = 5,lv = 27,cost = [{255,36255095,13800}],add_attr = [{1,459},{7,378}]};

get_draconic_strong_info(5,28) ->
	#base_draconic_strong{id = 5,lv = 28,cost = [{255,36255095,14690}],add_attr = [{1,476},{7,392}]};

get_draconic_strong_info(5,29) ->
	#base_draconic_strong{id = 5,lv = 29,cost = [{255,36255095,15620}],add_attr = [{1,493},{7,406}]};

get_draconic_strong_info(5,30) ->
	#base_draconic_strong{id = 5,lv = 30,cost = [{255,36255095,16600}],add_attr = [{1,510},{7,420}]};

get_draconic_strong_info(5,31) ->
	#base_draconic_strong{id = 5,lv = 31,cost = [{255,36255095,17630}],add_attr = [{1,527},{7,434}]};

get_draconic_strong_info(5,32) ->
	#base_draconic_strong{id = 5,lv = 32,cost = [{255,36255095,18710}],add_attr = [{1,544},{7,448}]};

get_draconic_strong_info(5,33) ->
	#base_draconic_strong{id = 5,lv = 33,cost = [{255,36255095,19850}],add_attr = [{1,561},{7,462}]};

get_draconic_strong_info(5,34) ->
	#base_draconic_strong{id = 5,lv = 34,cost = [{255,36255095,21040}],add_attr = [{1,578},{7,476}]};

get_draconic_strong_info(5,35) ->
	#base_draconic_strong{id = 5,lv = 35,cost = [{255,36255095,22290}],add_attr = [{1,595},{7,490}]};

get_draconic_strong_info(5,36) ->
	#base_draconic_strong{id = 5,lv = 36,cost = [{255,36255095,23600}],add_attr = [{1,612},{7,504}]};

get_draconic_strong_info(5,37) ->
	#base_draconic_strong{id = 5,lv = 37,cost = [{255,36255095,24980}],add_attr = [{1,629},{7,518}]};

get_draconic_strong_info(5,38) ->
	#base_draconic_strong{id = 5,lv = 38,cost = [{255,36255095,26430}],add_attr = [{1,646},{7,532}]};

get_draconic_strong_info(5,39) ->
	#base_draconic_strong{id = 5,lv = 39,cost = [{255,36255095,27950}],add_attr = [{1,663},{7,546}]};

get_draconic_strong_info(5,40) ->
	#base_draconic_strong{id = 5,lv = 40,cost = [{255,36255095,29550}],add_attr = [{1,680},{7,560}]};

get_draconic_strong_info(5,41) ->
	#base_draconic_strong{id = 5,lv = 41,cost = [{255,36255095,31230}],add_attr = [{1,697},{7,574}]};

get_draconic_strong_info(5,42) ->
	#base_draconic_strong{id = 5,lv = 42,cost = [{255,36255095,32990}],add_attr = [{1,714},{7,588}]};

get_draconic_strong_info(5,43) ->
	#base_draconic_strong{id = 5,lv = 43,cost = [{255,36255095,34840}],add_attr = [{1,731},{7,602}]};

get_draconic_strong_info(5,44) ->
	#base_draconic_strong{id = 5,lv = 44,cost = [{255,36255095,36780}],add_attr = [{1,748},{7,616}]};

get_draconic_strong_info(5,45) ->
	#base_draconic_strong{id = 5,lv = 45,cost = [{255,36255095,38820}],add_attr = [{1,765},{7,630}]};

get_draconic_strong_info(5,46) ->
	#base_draconic_strong{id = 5,lv = 46,cost = [{255,36255095,40960}],add_attr = [{1,782},{7,644}]};

get_draconic_strong_info(5,47) ->
	#base_draconic_strong{id = 5,lv = 47,cost = [{255,36255095,43210}],add_attr = [{1,799},{7,658}]};

get_draconic_strong_info(5,48) ->
	#base_draconic_strong{id = 5,lv = 48,cost = [{255,36255095,45570}],add_attr = [{1,816},{7,672}]};

get_draconic_strong_info(5,49) ->
	#base_draconic_strong{id = 5,lv = 49,cost = [{255,36255095,48050}],add_attr = [{1,833},{7,686}]};

get_draconic_strong_info(5,50) ->
	#base_draconic_strong{id = 5,lv = 50,cost = [{255,36255095,50650}],add_attr = [{1,850},{7,700}]};

get_draconic_strong_info(5,51) ->
	#base_draconic_strong{id = 5,lv = 51,cost = [{255,36255095,53380}],add_attr = [{1,867},{7,714}]};

get_draconic_strong_info(5,52) ->
	#base_draconic_strong{id = 5,lv = 52,cost = [{255,36255095,56250}],add_attr = [{1,884},{7,728}]};

get_draconic_strong_info(5,53) ->
	#base_draconic_strong{id = 5,lv = 53,cost = [{255,36255095,59260}],add_attr = [{1,901},{7,742}]};

get_draconic_strong_info(5,54) ->
	#base_draconic_strong{id = 5,lv = 54,cost = [{255,36255095,62420}],add_attr = [{1,918},{7,756}]};

get_draconic_strong_info(5,55) ->
	#base_draconic_strong{id = 5,lv = 55,cost = [{255,36255095,65740}],add_attr = [{1,935},{7,770}]};

get_draconic_strong_info(5,56) ->
	#base_draconic_strong{id = 5,lv = 56,cost = [{255,36255095,69230}],add_attr = [{1,952},{7,784}]};

get_draconic_strong_info(5,57) ->
	#base_draconic_strong{id = 5,lv = 57,cost = [{255,36255095,72890}],add_attr = [{1,969},{7,798}]};

get_draconic_strong_info(5,58) ->
	#base_draconic_strong{id = 5,lv = 58,cost = [{255,36255095,76730}],add_attr = [{1,986},{7,812}]};

get_draconic_strong_info(5,59) ->
	#base_draconic_strong{id = 5,lv = 59,cost = [{255,36255095,80770}],add_attr = [{1,1003},{7,826}]};

get_draconic_strong_info(5,60) ->
	#base_draconic_strong{id = 5,lv = 60,cost = [{255,36255095,85010}],add_attr = [{1,1020},{7,840}]};

get_draconic_strong_info(5,61) ->
	#base_draconic_strong{id = 5,lv = 61,cost = [{255,36255095,89460}],add_attr = [{1,1037},{7,854}]};

get_draconic_strong_info(5,62) ->
	#base_draconic_strong{id = 5,lv = 62,cost = [{255,36255095,94130}],add_attr = [{1,1054},{7,868}]};

get_draconic_strong_info(5,63) ->
	#base_draconic_strong{id = 5,lv = 63,cost = [{255,36255095,99040}],add_attr = [{1,1071},{7,882}]};

get_draconic_strong_info(5,64) ->
	#base_draconic_strong{id = 5,lv = 64,cost = [{255,36255095,104190}],add_attr = [{1,1088},{7,896}]};

get_draconic_strong_info(5,65) ->
	#base_draconic_strong{id = 5,lv = 65,cost = [{255,36255095,109600}],add_attr = [{1,1105},{7,910}]};

get_draconic_strong_info(5,66) ->
	#base_draconic_strong{id = 5,lv = 66,cost = [{255,36255095,115280}],add_attr = [{1,1122},{7,924}]};

get_draconic_strong_info(5,67) ->
	#base_draconic_strong{id = 5,lv = 67,cost = [{255,36255095,121240}],add_attr = [{1,1139},{7,938}]};

get_draconic_strong_info(5,68) ->
	#base_draconic_strong{id = 5,lv = 68,cost = [{255,36255095,127500}],add_attr = [{1,1156},{7,952}]};

get_draconic_strong_info(5,69) ->
	#base_draconic_strong{id = 5,lv = 69,cost = [{255,36255095,134080}],add_attr = [{1,1173},{7,966}]};

get_draconic_strong_info(5,70) ->
	#base_draconic_strong{id = 5,lv = 70,cost = [{255,36255095,140980}],add_attr = [{1,1190},{7,980}]};

get_draconic_strong_info(5,71) ->
	#base_draconic_strong{id = 5,lv = 71,cost = [{255,36255095,148230}],add_attr = [{1,1207},{7,994}]};

get_draconic_strong_info(5,72) ->
	#base_draconic_strong{id = 5,lv = 72,cost = [{255,36255095,155840}],add_attr = [{1,1224},{7,1008}]};

get_draconic_strong_info(5,73) ->
	#base_draconic_strong{id = 5,lv = 73,cost = [{255,36255095,163830}],add_attr = [{1,1241},{7,1022}]};

get_draconic_strong_info(5,74) ->
	#base_draconic_strong{id = 5,lv = 74,cost = [{255,36255095,172220}],add_attr = [{1,1258},{7,1036}]};

get_draconic_strong_info(5,75) ->
	#base_draconic_strong{id = 5,lv = 75,cost = [{255,36255095,181030}],add_attr = [{1,1275},{7,1050}]};

get_draconic_strong_info(5,76) ->
	#base_draconic_strong{id = 5,lv = 76,cost = [{255,36255095,190280}],add_attr = [{1,1292},{7,1064}]};

get_draconic_strong_info(5,77) ->
	#base_draconic_strong{id = 5,lv = 77,cost = [{255,36255095,199990}],add_attr = [{1,1309},{7,1078}]};

get_draconic_strong_info(5,78) ->
	#base_draconic_strong{id = 5,lv = 78,cost = [{255,36255095,210190}],add_attr = [{1,1326},{7,1092}]};

get_draconic_strong_info(5,79) ->
	#base_draconic_strong{id = 5,lv = 79,cost = [{255,36255095,220900}],add_attr = [{1,1343},{7,1106}]};

get_draconic_strong_info(5,80) ->
	#base_draconic_strong{id = 5,lv = 80,cost = [{255,36255095,232150}],add_attr = [{1,1360},{7,1120}]};

get_draconic_strong_info(5,81) ->
	#base_draconic_strong{id = 5,lv = 81,cost = [{255,36255095,243960}],add_attr = [{1,1377},{7,1134}]};

get_draconic_strong_info(5,82) ->
	#base_draconic_strong{id = 5,lv = 82,cost = [{255,36255095,256360}],add_attr = [{1,1394},{7,1148}]};

get_draconic_strong_info(5,83) ->
	#base_draconic_strong{id = 5,lv = 83,cost = [{255,36255095,269380}],add_attr = [{1,1411},{7,1162}]};

get_draconic_strong_info(5,84) ->
	#base_draconic_strong{id = 5,lv = 84,cost = [{255,36255095,283050}],add_attr = [{1,1428},{7,1176}]};

get_draconic_strong_info(5,85) ->
	#base_draconic_strong{id = 5,lv = 85,cost = [{255,36255095,297400}],add_attr = [{1,1445},{7,1190}]};

get_draconic_strong_info(5,86) ->
	#base_draconic_strong{id = 5,lv = 86,cost = [{255,36255095,312470}],add_attr = [{1,1462},{7,1204}]};

get_draconic_strong_info(5,87) ->
	#base_draconic_strong{id = 5,lv = 87,cost = [{255,36255095,328290}],add_attr = [{1,1479},{7,1218}]};

get_draconic_strong_info(5,88) ->
	#base_draconic_strong{id = 5,lv = 88,cost = [{255,36255095,344900}],add_attr = [{1,1496},{7,1232}]};

get_draconic_strong_info(5,89) ->
	#base_draconic_strong{id = 5,lv = 89,cost = [{255,36255095,362350}],add_attr = [{1,1513},{7,1246}]};

get_draconic_strong_info(5,90) ->
	#base_draconic_strong{id = 5,lv = 90,cost = [{255,36255095,380670}],add_attr = [{1,1530},{7,1260}]};

get_draconic_strong_info(5,91) ->
	#base_draconic_strong{id = 5,lv = 91,cost = [{255,36255095,399900}],add_attr = [{1,1547},{7,1274}]};

get_draconic_strong_info(5,92) ->
	#base_draconic_strong{id = 5,lv = 92,cost = [{255,36255095,420100}],add_attr = [{1,1564},{7,1288}]};

get_draconic_strong_info(5,93) ->
	#base_draconic_strong{id = 5,lv = 93,cost = [{255,36255095,441310}],add_attr = [{1,1581},{7,1302}]};

get_draconic_strong_info(5,94) ->
	#base_draconic_strong{id = 5,lv = 94,cost = [{255,36255095,463580}],add_attr = [{1,1598},{7,1316}]};

get_draconic_strong_info(5,95) ->
	#base_draconic_strong{id = 5,lv = 95,cost = [{255,36255095,486960}],add_attr = [{1,1615},{7,1330}]};

get_draconic_strong_info(5,96) ->
	#base_draconic_strong{id = 5,lv = 96,cost = [{255,36255095,511510}],add_attr = [{1,1632},{7,1344}]};

get_draconic_strong_info(5,97) ->
	#base_draconic_strong{id = 5,lv = 97,cost = [{255,36255095,537290}],add_attr = [{1,1649},{7,1358}]};

get_draconic_strong_info(5,98) ->
	#base_draconic_strong{id = 5,lv = 98,cost = [{255,36255095,564350}],add_attr = [{1,1666},{7,1372}]};

get_draconic_strong_info(5,99) ->
	#base_draconic_strong{id = 5,lv = 99,cost = [{255,36255095,592770}],add_attr = [{1,1683},{7,1386}]};

get_draconic_strong_info(5,100) ->
	#base_draconic_strong{id = 5,lv = 100,cost = [{255,36255095,622610}],add_attr = [{1,1700},{7,1400}]};

get_draconic_strong_info(6,0) ->
	#base_draconic_strong{id = 6,lv = 0,cost = [],add_attr = [{3,0},{5,0}]};

get_draconic_strong_info(6,1) ->
	#base_draconic_strong{id = 6,lv = 1,cost = [{255,36255095,1000}],add_attr = [{3,14},{5,16}]};

get_draconic_strong_info(6,2) ->
	#base_draconic_strong{id = 6,lv = 2,cost = [{255,36255095,1250}],add_attr = [{3,28},{5,32}]};

get_draconic_strong_info(6,3) ->
	#base_draconic_strong{id = 6,lv = 3,cost = [{255,36255095,1510}],add_attr = [{3,42},{5,48}]};

get_draconic_strong_info(6,4) ->
	#base_draconic_strong{id = 6,lv = 4,cost = [{255,36255095,1790}],add_attr = [{3,56},{5,64}]};

get_draconic_strong_info(6,5) ->
	#base_draconic_strong{id = 6,lv = 5,cost = [{255,36255095,2080}],add_attr = [{3,70},{5,80}]};

get_draconic_strong_info(6,6) ->
	#base_draconic_strong{id = 6,lv = 6,cost = [{255,36255095,2380}],add_attr = [{3,84},{5,96}]};

get_draconic_strong_info(6,7) ->
	#base_draconic_strong{id = 6,lv = 7,cost = [{255,36255095,2700}],add_attr = [{3,98},{5,112}]};

get_draconic_strong_info(6,8) ->
	#base_draconic_strong{id = 6,lv = 8,cost = [{255,36255095,3040}],add_attr = [{3,112},{5,128}]};

get_draconic_strong_info(6,9) ->
	#base_draconic_strong{id = 6,lv = 9,cost = [{255,36255095,3390}],add_attr = [{3,126},{5,144}]};

get_draconic_strong_info(6,10) ->
	#base_draconic_strong{id = 6,lv = 10,cost = [{255,36255095,3760}],add_attr = [{3,140},{5,160}]};

get_draconic_strong_info(6,11) ->
	#base_draconic_strong{id = 6,lv = 11,cost = [{255,36255095,4150}],add_attr = [{3,154},{5,176}]};

get_draconic_strong_info(6,12) ->
	#base_draconic_strong{id = 6,lv = 12,cost = [{255,36255095,4560}],add_attr = [{3,168},{5,192}]};

get_draconic_strong_info(6,13) ->
	#base_draconic_strong{id = 6,lv = 13,cost = [{255,36255095,4990}],add_attr = [{3,182},{5,208}]};

get_draconic_strong_info(6,14) ->
	#base_draconic_strong{id = 6,lv = 14,cost = [{255,36255095,5440}],add_attr = [{3,196},{5,224}]};

get_draconic_strong_info(6,15) ->
	#base_draconic_strong{id = 6,lv = 15,cost = [{255,36255095,5910}],add_attr = [{3,210},{5,240}]};

get_draconic_strong_info(6,16) ->
	#base_draconic_strong{id = 6,lv = 16,cost = [{255,36255095,6410}],add_attr = [{3,224},{5,256}]};

get_draconic_strong_info(6,17) ->
	#base_draconic_strong{id = 6,lv = 17,cost = [{255,36255095,6930}],add_attr = [{3,238},{5,272}]};

get_draconic_strong_info(6,18) ->
	#base_draconic_strong{id = 6,lv = 18,cost = [{255,36255095,7480}],add_attr = [{3,252},{5,288}]};

get_draconic_strong_info(6,19) ->
	#base_draconic_strong{id = 6,lv = 19,cost = [{255,36255095,8050}],add_attr = [{3,266},{5,304}]};

get_draconic_strong_info(6,20) ->
	#base_draconic_strong{id = 6,lv = 20,cost = [{255,36255095,8650}],add_attr = [{3,280},{5,320}]};

get_draconic_strong_info(6,21) ->
	#base_draconic_strong{id = 6,lv = 21,cost = [{255,36255095,9280}],add_attr = [{3,294},{5,336}]};

get_draconic_strong_info(6,22) ->
	#base_draconic_strong{id = 6,lv = 22,cost = [{255,36255095,9940}],add_attr = [{3,308},{5,352}]};

get_draconic_strong_info(6,23) ->
	#base_draconic_strong{id = 6,lv = 23,cost = [{255,36255095,10640}],add_attr = [{3,322},{5,368}]};

get_draconic_strong_info(6,24) ->
	#base_draconic_strong{id = 6,lv = 24,cost = [{255,36255095,11370}],add_attr = [{3,336},{5,384}]};

get_draconic_strong_info(6,25) ->
	#base_draconic_strong{id = 6,lv = 25,cost = [{255,36255095,12140}],add_attr = [{3,350},{5,400}]};

get_draconic_strong_info(6,26) ->
	#base_draconic_strong{id = 6,lv = 26,cost = [{255,36255095,12950}],add_attr = [{3,364},{5,416}]};

get_draconic_strong_info(6,27) ->
	#base_draconic_strong{id = 6,lv = 27,cost = [{255,36255095,13800}],add_attr = [{3,378},{5,432}]};

get_draconic_strong_info(6,28) ->
	#base_draconic_strong{id = 6,lv = 28,cost = [{255,36255095,14690}],add_attr = [{3,392},{5,448}]};

get_draconic_strong_info(6,29) ->
	#base_draconic_strong{id = 6,lv = 29,cost = [{255,36255095,15620}],add_attr = [{3,406},{5,464}]};

get_draconic_strong_info(6,30) ->
	#base_draconic_strong{id = 6,lv = 30,cost = [{255,36255095,16600}],add_attr = [{3,420},{5,480}]};

get_draconic_strong_info(6,31) ->
	#base_draconic_strong{id = 6,lv = 31,cost = [{255,36255095,17630}],add_attr = [{3,434},{5,496}]};

get_draconic_strong_info(6,32) ->
	#base_draconic_strong{id = 6,lv = 32,cost = [{255,36255095,18710}],add_attr = [{3,448},{5,512}]};

get_draconic_strong_info(6,33) ->
	#base_draconic_strong{id = 6,lv = 33,cost = [{255,36255095,19850}],add_attr = [{3,462},{5,528}]};

get_draconic_strong_info(6,34) ->
	#base_draconic_strong{id = 6,lv = 34,cost = [{255,36255095,21040}],add_attr = [{3,476},{5,544}]};

get_draconic_strong_info(6,35) ->
	#base_draconic_strong{id = 6,lv = 35,cost = [{255,36255095,22290}],add_attr = [{3,490},{5,560}]};

get_draconic_strong_info(6,36) ->
	#base_draconic_strong{id = 6,lv = 36,cost = [{255,36255095,23600}],add_attr = [{3,504},{5,576}]};

get_draconic_strong_info(6,37) ->
	#base_draconic_strong{id = 6,lv = 37,cost = [{255,36255095,24980}],add_attr = [{3,518},{5,592}]};

get_draconic_strong_info(6,38) ->
	#base_draconic_strong{id = 6,lv = 38,cost = [{255,36255095,26430}],add_attr = [{3,532},{5,608}]};

get_draconic_strong_info(6,39) ->
	#base_draconic_strong{id = 6,lv = 39,cost = [{255,36255095,27950}],add_attr = [{3,546},{5,624}]};

get_draconic_strong_info(6,40) ->
	#base_draconic_strong{id = 6,lv = 40,cost = [{255,36255095,29550}],add_attr = [{3,560},{5,640}]};

get_draconic_strong_info(6,41) ->
	#base_draconic_strong{id = 6,lv = 41,cost = [{255,36255095,31230}],add_attr = [{3,574},{5,656}]};

get_draconic_strong_info(6,42) ->
	#base_draconic_strong{id = 6,lv = 42,cost = [{255,36255095,32990}],add_attr = [{3,588},{5,672}]};

get_draconic_strong_info(6,43) ->
	#base_draconic_strong{id = 6,lv = 43,cost = [{255,36255095,34840}],add_attr = [{3,602},{5,688}]};

get_draconic_strong_info(6,44) ->
	#base_draconic_strong{id = 6,lv = 44,cost = [{255,36255095,36780}],add_attr = [{3,616},{5,704}]};

get_draconic_strong_info(6,45) ->
	#base_draconic_strong{id = 6,lv = 45,cost = [{255,36255095,38820}],add_attr = [{3,630},{5,720}]};

get_draconic_strong_info(6,46) ->
	#base_draconic_strong{id = 6,lv = 46,cost = [{255,36255095,40960}],add_attr = [{3,644},{5,736}]};

get_draconic_strong_info(6,47) ->
	#base_draconic_strong{id = 6,lv = 47,cost = [{255,36255095,43210}],add_attr = [{3,658},{5,752}]};

get_draconic_strong_info(6,48) ->
	#base_draconic_strong{id = 6,lv = 48,cost = [{255,36255095,45570}],add_attr = [{3,672},{5,768}]};

get_draconic_strong_info(6,49) ->
	#base_draconic_strong{id = 6,lv = 49,cost = [{255,36255095,48050}],add_attr = [{3,686},{5,784}]};

get_draconic_strong_info(6,50) ->
	#base_draconic_strong{id = 6,lv = 50,cost = [{255,36255095,50650}],add_attr = [{3,700},{5,800}]};

get_draconic_strong_info(6,51) ->
	#base_draconic_strong{id = 6,lv = 51,cost = [{255,36255095,53380}],add_attr = [{3,714},{5,816}]};

get_draconic_strong_info(6,52) ->
	#base_draconic_strong{id = 6,lv = 52,cost = [{255,36255095,56250}],add_attr = [{3,728},{5,832}]};

get_draconic_strong_info(6,53) ->
	#base_draconic_strong{id = 6,lv = 53,cost = [{255,36255095,59260}],add_attr = [{3,742},{5,848}]};

get_draconic_strong_info(6,54) ->
	#base_draconic_strong{id = 6,lv = 54,cost = [{255,36255095,62420}],add_attr = [{3,756},{5,864}]};

get_draconic_strong_info(6,55) ->
	#base_draconic_strong{id = 6,lv = 55,cost = [{255,36255095,65740}],add_attr = [{3,770},{5,880}]};

get_draconic_strong_info(6,56) ->
	#base_draconic_strong{id = 6,lv = 56,cost = [{255,36255095,69230}],add_attr = [{3,784},{5,896}]};

get_draconic_strong_info(6,57) ->
	#base_draconic_strong{id = 6,lv = 57,cost = [{255,36255095,72890}],add_attr = [{3,798},{5,912}]};

get_draconic_strong_info(6,58) ->
	#base_draconic_strong{id = 6,lv = 58,cost = [{255,36255095,76730}],add_attr = [{3,812},{5,928}]};

get_draconic_strong_info(6,59) ->
	#base_draconic_strong{id = 6,lv = 59,cost = [{255,36255095,80770}],add_attr = [{3,826},{5,944}]};

get_draconic_strong_info(6,60) ->
	#base_draconic_strong{id = 6,lv = 60,cost = [{255,36255095,85010}],add_attr = [{3,840},{5,960}]};

get_draconic_strong_info(6,61) ->
	#base_draconic_strong{id = 6,lv = 61,cost = [{255,36255095,89460}],add_attr = [{3,854},{5,976}]};

get_draconic_strong_info(6,62) ->
	#base_draconic_strong{id = 6,lv = 62,cost = [{255,36255095,94130}],add_attr = [{3,868},{5,992}]};

get_draconic_strong_info(6,63) ->
	#base_draconic_strong{id = 6,lv = 63,cost = [{255,36255095,99040}],add_attr = [{3,882},{5,1008}]};

get_draconic_strong_info(6,64) ->
	#base_draconic_strong{id = 6,lv = 64,cost = [{255,36255095,104190}],add_attr = [{3,896},{5,1024}]};

get_draconic_strong_info(6,65) ->
	#base_draconic_strong{id = 6,lv = 65,cost = [{255,36255095,109600}],add_attr = [{3,910},{5,1040}]};

get_draconic_strong_info(6,66) ->
	#base_draconic_strong{id = 6,lv = 66,cost = [{255,36255095,115280}],add_attr = [{3,924},{5,1056}]};

get_draconic_strong_info(6,67) ->
	#base_draconic_strong{id = 6,lv = 67,cost = [{255,36255095,121240}],add_attr = [{3,938},{5,1072}]};

get_draconic_strong_info(6,68) ->
	#base_draconic_strong{id = 6,lv = 68,cost = [{255,36255095,127500}],add_attr = [{3,952},{5,1088}]};

get_draconic_strong_info(6,69) ->
	#base_draconic_strong{id = 6,lv = 69,cost = [{255,36255095,134080}],add_attr = [{3,966},{5,1104}]};

get_draconic_strong_info(6,70) ->
	#base_draconic_strong{id = 6,lv = 70,cost = [{255,36255095,140980}],add_attr = [{3,980},{5,1120}]};

get_draconic_strong_info(6,71) ->
	#base_draconic_strong{id = 6,lv = 71,cost = [{255,36255095,148230}],add_attr = [{3,994},{5,1136}]};

get_draconic_strong_info(6,72) ->
	#base_draconic_strong{id = 6,lv = 72,cost = [{255,36255095,155840}],add_attr = [{3,1008},{5,1152}]};

get_draconic_strong_info(6,73) ->
	#base_draconic_strong{id = 6,lv = 73,cost = [{255,36255095,163830}],add_attr = [{3,1022},{5,1168}]};

get_draconic_strong_info(6,74) ->
	#base_draconic_strong{id = 6,lv = 74,cost = [{255,36255095,172220}],add_attr = [{3,1036},{5,1184}]};

get_draconic_strong_info(6,75) ->
	#base_draconic_strong{id = 6,lv = 75,cost = [{255,36255095,181030}],add_attr = [{3,1050},{5,1200}]};

get_draconic_strong_info(6,76) ->
	#base_draconic_strong{id = 6,lv = 76,cost = [{255,36255095,190280}],add_attr = [{3,1064},{5,1216}]};

get_draconic_strong_info(6,77) ->
	#base_draconic_strong{id = 6,lv = 77,cost = [{255,36255095,199990}],add_attr = [{3,1078},{5,1232}]};

get_draconic_strong_info(6,78) ->
	#base_draconic_strong{id = 6,lv = 78,cost = [{255,36255095,210190}],add_attr = [{3,1092},{5,1248}]};

get_draconic_strong_info(6,79) ->
	#base_draconic_strong{id = 6,lv = 79,cost = [{255,36255095,220900}],add_attr = [{3,1106},{5,1264}]};

get_draconic_strong_info(6,80) ->
	#base_draconic_strong{id = 6,lv = 80,cost = [{255,36255095,232150}],add_attr = [{3,1120},{5,1280}]};

get_draconic_strong_info(6,81) ->
	#base_draconic_strong{id = 6,lv = 81,cost = [{255,36255095,243960}],add_attr = [{3,1134},{5,1296}]};

get_draconic_strong_info(6,82) ->
	#base_draconic_strong{id = 6,lv = 82,cost = [{255,36255095,256360}],add_attr = [{3,1148},{5,1312}]};

get_draconic_strong_info(6,83) ->
	#base_draconic_strong{id = 6,lv = 83,cost = [{255,36255095,269380}],add_attr = [{3,1162},{5,1328}]};

get_draconic_strong_info(6,84) ->
	#base_draconic_strong{id = 6,lv = 84,cost = [{255,36255095,283050}],add_attr = [{3,1176},{5,1344}]};

get_draconic_strong_info(6,85) ->
	#base_draconic_strong{id = 6,lv = 85,cost = [{255,36255095,297400}],add_attr = [{3,1190},{5,1360}]};

get_draconic_strong_info(6,86) ->
	#base_draconic_strong{id = 6,lv = 86,cost = [{255,36255095,312470}],add_attr = [{3,1204},{5,1376}]};

get_draconic_strong_info(6,87) ->
	#base_draconic_strong{id = 6,lv = 87,cost = [{255,36255095,328290}],add_attr = [{3,1218},{5,1392}]};

get_draconic_strong_info(6,88) ->
	#base_draconic_strong{id = 6,lv = 88,cost = [{255,36255095,344900}],add_attr = [{3,1232},{5,1408}]};

get_draconic_strong_info(6,89) ->
	#base_draconic_strong{id = 6,lv = 89,cost = [{255,36255095,362350}],add_attr = [{3,1246},{5,1424}]};

get_draconic_strong_info(6,90) ->
	#base_draconic_strong{id = 6,lv = 90,cost = [{255,36255095,380670}],add_attr = [{3,1260},{5,1440}]};

get_draconic_strong_info(6,91) ->
	#base_draconic_strong{id = 6,lv = 91,cost = [{255,36255095,399900}],add_attr = [{3,1274},{5,1456}]};

get_draconic_strong_info(6,92) ->
	#base_draconic_strong{id = 6,lv = 92,cost = [{255,36255095,420100}],add_attr = [{3,1288},{5,1472}]};

get_draconic_strong_info(6,93) ->
	#base_draconic_strong{id = 6,lv = 93,cost = [{255,36255095,441310}],add_attr = [{3,1302},{5,1488}]};

get_draconic_strong_info(6,94) ->
	#base_draconic_strong{id = 6,lv = 94,cost = [{255,36255095,463580}],add_attr = [{3,1316},{5,1504}]};

get_draconic_strong_info(6,95) ->
	#base_draconic_strong{id = 6,lv = 95,cost = [{255,36255095,486960}],add_attr = [{3,1330},{5,1520}]};

get_draconic_strong_info(6,96) ->
	#base_draconic_strong{id = 6,lv = 96,cost = [{255,36255095,511510}],add_attr = [{3,1344},{5,1536}]};

get_draconic_strong_info(6,97) ->
	#base_draconic_strong{id = 6,lv = 97,cost = [{255,36255095,537290}],add_attr = [{3,1358},{5,1552}]};

get_draconic_strong_info(6,98) ->
	#base_draconic_strong{id = 6,lv = 98,cost = [{255,36255095,564350}],add_attr = [{3,1372},{5,1568}]};

get_draconic_strong_info(6,99) ->
	#base_draconic_strong{id = 6,lv = 99,cost = [{255,36255095,592770}],add_attr = [{3,1386},{5,1584}]};

get_draconic_strong_info(6,100) ->
	#base_draconic_strong{id = 6,lv = 100,cost = [{255,36255095,622610}],add_attr = [{3,1400},{5,1600}]};

get_draconic_strong_info(7,0) ->
	#base_draconic_strong{id = 7,lv = 0,cost = [],add_attr = [{1,0},{5,0}]};

get_draconic_strong_info(7,1) ->
	#base_draconic_strong{id = 7,lv = 1,cost = [{255,36255095,1000}],add_attr = [{1,17},{5,11}]};

get_draconic_strong_info(7,2) ->
	#base_draconic_strong{id = 7,lv = 2,cost = [{255,36255095,1250}],add_attr = [{1,34},{5,22}]};

get_draconic_strong_info(7,3) ->
	#base_draconic_strong{id = 7,lv = 3,cost = [{255,36255095,1510}],add_attr = [{1,51},{5,33}]};

get_draconic_strong_info(7,4) ->
	#base_draconic_strong{id = 7,lv = 4,cost = [{255,36255095,1790}],add_attr = [{1,68},{5,44}]};

get_draconic_strong_info(7,5) ->
	#base_draconic_strong{id = 7,lv = 5,cost = [{255,36255095,2080}],add_attr = [{1,85},{5,55}]};

get_draconic_strong_info(7,6) ->
	#base_draconic_strong{id = 7,lv = 6,cost = [{255,36255095,2380}],add_attr = [{1,102},{5,66}]};

get_draconic_strong_info(7,7) ->
	#base_draconic_strong{id = 7,lv = 7,cost = [{255,36255095,2700}],add_attr = [{1,119},{5,77}]};

get_draconic_strong_info(7,8) ->
	#base_draconic_strong{id = 7,lv = 8,cost = [{255,36255095,3040}],add_attr = [{1,136},{5,88}]};

get_draconic_strong_info(7,9) ->
	#base_draconic_strong{id = 7,lv = 9,cost = [{255,36255095,3390}],add_attr = [{1,153},{5,99}]};

get_draconic_strong_info(7,10) ->
	#base_draconic_strong{id = 7,lv = 10,cost = [{255,36255095,3760}],add_attr = [{1,170},{5,110}]};

get_draconic_strong_info(7,11) ->
	#base_draconic_strong{id = 7,lv = 11,cost = [{255,36255095,4150}],add_attr = [{1,187},{5,121}]};

get_draconic_strong_info(7,12) ->
	#base_draconic_strong{id = 7,lv = 12,cost = [{255,36255095,4560}],add_attr = [{1,204},{5,132}]};

get_draconic_strong_info(7,13) ->
	#base_draconic_strong{id = 7,lv = 13,cost = [{255,36255095,4990}],add_attr = [{1,221},{5,143}]};

get_draconic_strong_info(7,14) ->
	#base_draconic_strong{id = 7,lv = 14,cost = [{255,36255095,5440}],add_attr = [{1,238},{5,154}]};

get_draconic_strong_info(7,15) ->
	#base_draconic_strong{id = 7,lv = 15,cost = [{255,36255095,5910}],add_attr = [{1,255},{5,165}]};

get_draconic_strong_info(7,16) ->
	#base_draconic_strong{id = 7,lv = 16,cost = [{255,36255095,6410}],add_attr = [{1,272},{5,176}]};

get_draconic_strong_info(7,17) ->
	#base_draconic_strong{id = 7,lv = 17,cost = [{255,36255095,6930}],add_attr = [{1,289},{5,187}]};

get_draconic_strong_info(7,18) ->
	#base_draconic_strong{id = 7,lv = 18,cost = [{255,36255095,7480}],add_attr = [{1,306},{5,198}]};

get_draconic_strong_info(7,19) ->
	#base_draconic_strong{id = 7,lv = 19,cost = [{255,36255095,8050}],add_attr = [{1,323},{5,209}]};

get_draconic_strong_info(7,20) ->
	#base_draconic_strong{id = 7,lv = 20,cost = [{255,36255095,8650}],add_attr = [{1,340},{5,220}]};

get_draconic_strong_info(7,21) ->
	#base_draconic_strong{id = 7,lv = 21,cost = [{255,36255095,9280}],add_attr = [{1,357},{5,231}]};

get_draconic_strong_info(7,22) ->
	#base_draconic_strong{id = 7,lv = 22,cost = [{255,36255095,9940}],add_attr = [{1,374},{5,242}]};

get_draconic_strong_info(7,23) ->
	#base_draconic_strong{id = 7,lv = 23,cost = [{255,36255095,10640}],add_attr = [{1,391},{5,253}]};

get_draconic_strong_info(7,24) ->
	#base_draconic_strong{id = 7,lv = 24,cost = [{255,36255095,11370}],add_attr = [{1,408},{5,264}]};

get_draconic_strong_info(7,25) ->
	#base_draconic_strong{id = 7,lv = 25,cost = [{255,36255095,12140}],add_attr = [{1,425},{5,275}]};

get_draconic_strong_info(7,26) ->
	#base_draconic_strong{id = 7,lv = 26,cost = [{255,36255095,12950}],add_attr = [{1,442},{5,286}]};

get_draconic_strong_info(7,27) ->
	#base_draconic_strong{id = 7,lv = 27,cost = [{255,36255095,13800}],add_attr = [{1,459},{5,297}]};

get_draconic_strong_info(7,28) ->
	#base_draconic_strong{id = 7,lv = 28,cost = [{255,36255095,14690}],add_attr = [{1,476},{5,308}]};

get_draconic_strong_info(7,29) ->
	#base_draconic_strong{id = 7,lv = 29,cost = [{255,36255095,15620}],add_attr = [{1,493},{5,319}]};

get_draconic_strong_info(7,30) ->
	#base_draconic_strong{id = 7,lv = 30,cost = [{255,36255095,16600}],add_attr = [{1,510},{5,330}]};

get_draconic_strong_info(7,31) ->
	#base_draconic_strong{id = 7,lv = 31,cost = [{255,36255095,17630}],add_attr = [{1,527},{5,341}]};

get_draconic_strong_info(7,32) ->
	#base_draconic_strong{id = 7,lv = 32,cost = [{255,36255095,18710}],add_attr = [{1,544},{5,352}]};

get_draconic_strong_info(7,33) ->
	#base_draconic_strong{id = 7,lv = 33,cost = [{255,36255095,19850}],add_attr = [{1,561},{5,363}]};

get_draconic_strong_info(7,34) ->
	#base_draconic_strong{id = 7,lv = 34,cost = [{255,36255095,21040}],add_attr = [{1,578},{5,374}]};

get_draconic_strong_info(7,35) ->
	#base_draconic_strong{id = 7,lv = 35,cost = [{255,36255095,22290}],add_attr = [{1,595},{5,385}]};

get_draconic_strong_info(7,36) ->
	#base_draconic_strong{id = 7,lv = 36,cost = [{255,36255095,23600}],add_attr = [{1,612},{5,396}]};

get_draconic_strong_info(7,37) ->
	#base_draconic_strong{id = 7,lv = 37,cost = [{255,36255095,24980}],add_attr = [{1,629},{5,407}]};

get_draconic_strong_info(7,38) ->
	#base_draconic_strong{id = 7,lv = 38,cost = [{255,36255095,26430}],add_attr = [{1,646},{5,418}]};

get_draconic_strong_info(7,39) ->
	#base_draconic_strong{id = 7,lv = 39,cost = [{255,36255095,27950}],add_attr = [{1,663},{5,429}]};

get_draconic_strong_info(7,40) ->
	#base_draconic_strong{id = 7,lv = 40,cost = [{255,36255095,29550}],add_attr = [{1,680},{5,440}]};

get_draconic_strong_info(7,41) ->
	#base_draconic_strong{id = 7,lv = 41,cost = [{255,36255095,31230}],add_attr = [{1,697},{5,451}]};

get_draconic_strong_info(7,42) ->
	#base_draconic_strong{id = 7,lv = 42,cost = [{255,36255095,32990}],add_attr = [{1,714},{5,462}]};

get_draconic_strong_info(7,43) ->
	#base_draconic_strong{id = 7,lv = 43,cost = [{255,36255095,34840}],add_attr = [{1,731},{5,473}]};

get_draconic_strong_info(7,44) ->
	#base_draconic_strong{id = 7,lv = 44,cost = [{255,36255095,36780}],add_attr = [{1,748},{5,484}]};

get_draconic_strong_info(7,45) ->
	#base_draconic_strong{id = 7,lv = 45,cost = [{255,36255095,38820}],add_attr = [{1,765},{5,495}]};

get_draconic_strong_info(7,46) ->
	#base_draconic_strong{id = 7,lv = 46,cost = [{255,36255095,40960}],add_attr = [{1,782},{5,506}]};

get_draconic_strong_info(7,47) ->
	#base_draconic_strong{id = 7,lv = 47,cost = [{255,36255095,43210}],add_attr = [{1,799},{5,517}]};

get_draconic_strong_info(7,48) ->
	#base_draconic_strong{id = 7,lv = 48,cost = [{255,36255095,45570}],add_attr = [{1,816},{5,528}]};

get_draconic_strong_info(7,49) ->
	#base_draconic_strong{id = 7,lv = 49,cost = [{255,36255095,48050}],add_attr = [{1,833},{5,539}]};

get_draconic_strong_info(7,50) ->
	#base_draconic_strong{id = 7,lv = 50,cost = [{255,36255095,50650}],add_attr = [{1,850},{5,550}]};

get_draconic_strong_info(7,51) ->
	#base_draconic_strong{id = 7,lv = 51,cost = [{255,36255095,53380}],add_attr = [{1,867},{5,561}]};

get_draconic_strong_info(7,52) ->
	#base_draconic_strong{id = 7,lv = 52,cost = [{255,36255095,56250}],add_attr = [{1,884},{5,572}]};

get_draconic_strong_info(7,53) ->
	#base_draconic_strong{id = 7,lv = 53,cost = [{255,36255095,59260}],add_attr = [{1,901},{5,583}]};

get_draconic_strong_info(7,54) ->
	#base_draconic_strong{id = 7,lv = 54,cost = [{255,36255095,62420}],add_attr = [{1,918},{5,594}]};

get_draconic_strong_info(7,55) ->
	#base_draconic_strong{id = 7,lv = 55,cost = [{255,36255095,65740}],add_attr = [{1,935},{5,605}]};

get_draconic_strong_info(7,56) ->
	#base_draconic_strong{id = 7,lv = 56,cost = [{255,36255095,69230}],add_attr = [{1,952},{5,616}]};

get_draconic_strong_info(7,57) ->
	#base_draconic_strong{id = 7,lv = 57,cost = [{255,36255095,72890}],add_attr = [{1,969},{5,627}]};

get_draconic_strong_info(7,58) ->
	#base_draconic_strong{id = 7,lv = 58,cost = [{255,36255095,76730}],add_attr = [{1,986},{5,638}]};

get_draconic_strong_info(7,59) ->
	#base_draconic_strong{id = 7,lv = 59,cost = [{255,36255095,80770}],add_attr = [{1,1003},{5,649}]};

get_draconic_strong_info(7,60) ->
	#base_draconic_strong{id = 7,lv = 60,cost = [{255,36255095,85010}],add_attr = [{1,1020},{5,660}]};

get_draconic_strong_info(7,61) ->
	#base_draconic_strong{id = 7,lv = 61,cost = [{255,36255095,89460}],add_attr = [{1,1037},{5,671}]};

get_draconic_strong_info(7,62) ->
	#base_draconic_strong{id = 7,lv = 62,cost = [{255,36255095,94130}],add_attr = [{1,1054},{5,682}]};

get_draconic_strong_info(7,63) ->
	#base_draconic_strong{id = 7,lv = 63,cost = [{255,36255095,99040}],add_attr = [{1,1071},{5,693}]};

get_draconic_strong_info(7,64) ->
	#base_draconic_strong{id = 7,lv = 64,cost = [{255,36255095,104190}],add_attr = [{1,1088},{5,704}]};

get_draconic_strong_info(7,65) ->
	#base_draconic_strong{id = 7,lv = 65,cost = [{255,36255095,109600}],add_attr = [{1,1105},{5,715}]};

get_draconic_strong_info(7,66) ->
	#base_draconic_strong{id = 7,lv = 66,cost = [{255,36255095,115280}],add_attr = [{1,1122},{5,726}]};

get_draconic_strong_info(7,67) ->
	#base_draconic_strong{id = 7,lv = 67,cost = [{255,36255095,121240}],add_attr = [{1,1139},{5,737}]};

get_draconic_strong_info(7,68) ->
	#base_draconic_strong{id = 7,lv = 68,cost = [{255,36255095,127500}],add_attr = [{1,1156},{5,748}]};

get_draconic_strong_info(7,69) ->
	#base_draconic_strong{id = 7,lv = 69,cost = [{255,36255095,134080}],add_attr = [{1,1173},{5,759}]};

get_draconic_strong_info(7,70) ->
	#base_draconic_strong{id = 7,lv = 70,cost = [{255,36255095,140980}],add_attr = [{1,1190},{5,770}]};

get_draconic_strong_info(7,71) ->
	#base_draconic_strong{id = 7,lv = 71,cost = [{255,36255095,148230}],add_attr = [{1,1207},{5,781}]};

get_draconic_strong_info(7,72) ->
	#base_draconic_strong{id = 7,lv = 72,cost = [{255,36255095,155840}],add_attr = [{1,1224},{5,792}]};

get_draconic_strong_info(7,73) ->
	#base_draconic_strong{id = 7,lv = 73,cost = [{255,36255095,163830}],add_attr = [{1,1241},{5,803}]};

get_draconic_strong_info(7,74) ->
	#base_draconic_strong{id = 7,lv = 74,cost = [{255,36255095,172220}],add_attr = [{1,1258},{5,814}]};

get_draconic_strong_info(7,75) ->
	#base_draconic_strong{id = 7,lv = 75,cost = [{255,36255095,181030}],add_attr = [{1,1275},{5,825}]};

get_draconic_strong_info(7,76) ->
	#base_draconic_strong{id = 7,lv = 76,cost = [{255,36255095,190280}],add_attr = [{1,1292},{5,836}]};

get_draconic_strong_info(7,77) ->
	#base_draconic_strong{id = 7,lv = 77,cost = [{255,36255095,199990}],add_attr = [{1,1309},{5,847}]};

get_draconic_strong_info(7,78) ->
	#base_draconic_strong{id = 7,lv = 78,cost = [{255,36255095,210190}],add_attr = [{1,1326},{5,858}]};

get_draconic_strong_info(7,79) ->
	#base_draconic_strong{id = 7,lv = 79,cost = [{255,36255095,220900}],add_attr = [{1,1343},{5,869}]};

get_draconic_strong_info(7,80) ->
	#base_draconic_strong{id = 7,lv = 80,cost = [{255,36255095,232150}],add_attr = [{1,1360},{5,880}]};

get_draconic_strong_info(7,81) ->
	#base_draconic_strong{id = 7,lv = 81,cost = [{255,36255095,243960}],add_attr = [{1,1377},{5,891}]};

get_draconic_strong_info(7,82) ->
	#base_draconic_strong{id = 7,lv = 82,cost = [{255,36255095,256360}],add_attr = [{1,1394},{5,902}]};

get_draconic_strong_info(7,83) ->
	#base_draconic_strong{id = 7,lv = 83,cost = [{255,36255095,269380}],add_attr = [{1,1411},{5,913}]};

get_draconic_strong_info(7,84) ->
	#base_draconic_strong{id = 7,lv = 84,cost = [{255,36255095,283050}],add_attr = [{1,1428},{5,924}]};

get_draconic_strong_info(7,85) ->
	#base_draconic_strong{id = 7,lv = 85,cost = [{255,36255095,297400}],add_attr = [{1,1445},{5,935}]};

get_draconic_strong_info(7,86) ->
	#base_draconic_strong{id = 7,lv = 86,cost = [{255,36255095,312470}],add_attr = [{1,1462},{5,946}]};

get_draconic_strong_info(7,87) ->
	#base_draconic_strong{id = 7,lv = 87,cost = [{255,36255095,328290}],add_attr = [{1,1479},{5,957}]};

get_draconic_strong_info(7,88) ->
	#base_draconic_strong{id = 7,lv = 88,cost = [{255,36255095,344900}],add_attr = [{1,1496},{5,968}]};

get_draconic_strong_info(7,89) ->
	#base_draconic_strong{id = 7,lv = 89,cost = [{255,36255095,362350}],add_attr = [{1,1513},{5,979}]};

get_draconic_strong_info(7,90) ->
	#base_draconic_strong{id = 7,lv = 90,cost = [{255,36255095,380670}],add_attr = [{1,1530},{5,990}]};

get_draconic_strong_info(7,91) ->
	#base_draconic_strong{id = 7,lv = 91,cost = [{255,36255095,399900}],add_attr = [{1,1547},{5,1001}]};

get_draconic_strong_info(7,92) ->
	#base_draconic_strong{id = 7,lv = 92,cost = [{255,36255095,420100}],add_attr = [{1,1564},{5,1012}]};

get_draconic_strong_info(7,93) ->
	#base_draconic_strong{id = 7,lv = 93,cost = [{255,36255095,441310}],add_attr = [{1,1581},{5,1023}]};

get_draconic_strong_info(7,94) ->
	#base_draconic_strong{id = 7,lv = 94,cost = [{255,36255095,463580}],add_attr = [{1,1598},{5,1034}]};

get_draconic_strong_info(7,95) ->
	#base_draconic_strong{id = 7,lv = 95,cost = [{255,36255095,486960}],add_attr = [{1,1615},{5,1045}]};

get_draconic_strong_info(7,96) ->
	#base_draconic_strong{id = 7,lv = 96,cost = [{255,36255095,511510}],add_attr = [{1,1632},{5,1056}]};

get_draconic_strong_info(7,97) ->
	#base_draconic_strong{id = 7,lv = 97,cost = [{255,36255095,537290}],add_attr = [{1,1649},{5,1067}]};

get_draconic_strong_info(7,98) ->
	#base_draconic_strong{id = 7,lv = 98,cost = [{255,36255095,564350}],add_attr = [{1,1666},{5,1078}]};

get_draconic_strong_info(7,99) ->
	#base_draconic_strong{id = 7,lv = 99,cost = [{255,36255095,592770}],add_attr = [{1,1683},{5,1089}]};

get_draconic_strong_info(7,100) ->
	#base_draconic_strong{id = 7,lv = 100,cost = [{255,36255095,622610}],add_attr = [{1,1700},{5,1100}]};

get_draconic_strong_info(8,0) ->
	#base_draconic_strong{id = 8,lv = 0,cost = [],add_attr = [{1,0},{3,0}]};

get_draconic_strong_info(8,1) ->
	#base_draconic_strong{id = 8,lv = 1,cost = [{255,36255095,1000}],add_attr = [{1,14},{3,7}]};

get_draconic_strong_info(8,2) ->
	#base_draconic_strong{id = 8,lv = 2,cost = [{255,36255095,1250}],add_attr = [{1,28},{3,14}]};

get_draconic_strong_info(8,3) ->
	#base_draconic_strong{id = 8,lv = 3,cost = [{255,36255095,1510}],add_attr = [{1,42},{3,21}]};

get_draconic_strong_info(8,4) ->
	#base_draconic_strong{id = 8,lv = 4,cost = [{255,36255095,1790}],add_attr = [{1,56},{3,28}]};

get_draconic_strong_info(8,5) ->
	#base_draconic_strong{id = 8,lv = 5,cost = [{255,36255095,2080}],add_attr = [{1,70},{3,35}]};

get_draconic_strong_info(8,6) ->
	#base_draconic_strong{id = 8,lv = 6,cost = [{255,36255095,2380}],add_attr = [{1,84},{3,42}]};

get_draconic_strong_info(8,7) ->
	#base_draconic_strong{id = 8,lv = 7,cost = [{255,36255095,2700}],add_attr = [{1,98},{3,49}]};

get_draconic_strong_info(8,8) ->
	#base_draconic_strong{id = 8,lv = 8,cost = [{255,36255095,3040}],add_attr = [{1,112},{3,56}]};

get_draconic_strong_info(8,9) ->
	#base_draconic_strong{id = 8,lv = 9,cost = [{255,36255095,3390}],add_attr = [{1,126},{3,63}]};

get_draconic_strong_info(8,10) ->
	#base_draconic_strong{id = 8,lv = 10,cost = [{255,36255095,3760}],add_attr = [{1,140},{3,70}]};

get_draconic_strong_info(8,11) ->
	#base_draconic_strong{id = 8,lv = 11,cost = [{255,36255095,4150}],add_attr = [{1,154},{3,77}]};

get_draconic_strong_info(8,12) ->
	#base_draconic_strong{id = 8,lv = 12,cost = [{255,36255095,4560}],add_attr = [{1,168},{3,84}]};

get_draconic_strong_info(8,13) ->
	#base_draconic_strong{id = 8,lv = 13,cost = [{255,36255095,4990}],add_attr = [{1,182},{3,91}]};

get_draconic_strong_info(8,14) ->
	#base_draconic_strong{id = 8,lv = 14,cost = [{255,36255095,5440}],add_attr = [{1,196},{3,98}]};

get_draconic_strong_info(8,15) ->
	#base_draconic_strong{id = 8,lv = 15,cost = [{255,36255095,5910}],add_attr = [{1,210},{3,105}]};

get_draconic_strong_info(8,16) ->
	#base_draconic_strong{id = 8,lv = 16,cost = [{255,36255095,6410}],add_attr = [{1,224},{3,112}]};

get_draconic_strong_info(8,17) ->
	#base_draconic_strong{id = 8,lv = 17,cost = [{255,36255095,6930}],add_attr = [{1,238},{3,119}]};

get_draconic_strong_info(8,18) ->
	#base_draconic_strong{id = 8,lv = 18,cost = [{255,36255095,7480}],add_attr = [{1,252},{3,126}]};

get_draconic_strong_info(8,19) ->
	#base_draconic_strong{id = 8,lv = 19,cost = [{255,36255095,8050}],add_attr = [{1,266},{3,133}]};

get_draconic_strong_info(8,20) ->
	#base_draconic_strong{id = 8,lv = 20,cost = [{255,36255095,8650}],add_attr = [{1,280},{3,140}]};

get_draconic_strong_info(8,21) ->
	#base_draconic_strong{id = 8,lv = 21,cost = [{255,36255095,9280}],add_attr = [{1,294},{3,147}]};

get_draconic_strong_info(8,22) ->
	#base_draconic_strong{id = 8,lv = 22,cost = [{255,36255095,9940}],add_attr = [{1,308},{3,154}]};

get_draconic_strong_info(8,23) ->
	#base_draconic_strong{id = 8,lv = 23,cost = [{255,36255095,10640}],add_attr = [{1,322},{3,161}]};

get_draconic_strong_info(8,24) ->
	#base_draconic_strong{id = 8,lv = 24,cost = [{255,36255095,11370}],add_attr = [{1,336},{3,168}]};

get_draconic_strong_info(8,25) ->
	#base_draconic_strong{id = 8,lv = 25,cost = [{255,36255095,12140}],add_attr = [{1,350},{3,175}]};

get_draconic_strong_info(8,26) ->
	#base_draconic_strong{id = 8,lv = 26,cost = [{255,36255095,12950}],add_attr = [{1,364},{3,182}]};

get_draconic_strong_info(8,27) ->
	#base_draconic_strong{id = 8,lv = 27,cost = [{255,36255095,13800}],add_attr = [{1,378},{3,189}]};

get_draconic_strong_info(8,28) ->
	#base_draconic_strong{id = 8,lv = 28,cost = [{255,36255095,14690}],add_attr = [{1,392},{3,196}]};

get_draconic_strong_info(8,29) ->
	#base_draconic_strong{id = 8,lv = 29,cost = [{255,36255095,15620}],add_attr = [{1,406},{3,203}]};

get_draconic_strong_info(8,30) ->
	#base_draconic_strong{id = 8,lv = 30,cost = [{255,36255095,16600}],add_attr = [{1,420},{3,210}]};

get_draconic_strong_info(8,31) ->
	#base_draconic_strong{id = 8,lv = 31,cost = [{255,36255095,17630}],add_attr = [{1,434},{3,217}]};

get_draconic_strong_info(8,32) ->
	#base_draconic_strong{id = 8,lv = 32,cost = [{255,36255095,18710}],add_attr = [{1,448},{3,224}]};

get_draconic_strong_info(8,33) ->
	#base_draconic_strong{id = 8,lv = 33,cost = [{255,36255095,19850}],add_attr = [{1,462},{3,231}]};

get_draconic_strong_info(8,34) ->
	#base_draconic_strong{id = 8,lv = 34,cost = [{255,36255095,21040}],add_attr = [{1,476},{3,238}]};

get_draconic_strong_info(8,35) ->
	#base_draconic_strong{id = 8,lv = 35,cost = [{255,36255095,22290}],add_attr = [{1,490},{3,245}]};

get_draconic_strong_info(8,36) ->
	#base_draconic_strong{id = 8,lv = 36,cost = [{255,36255095,23600}],add_attr = [{1,504},{3,252}]};

get_draconic_strong_info(8,37) ->
	#base_draconic_strong{id = 8,lv = 37,cost = [{255,36255095,24980}],add_attr = [{1,518},{3,259}]};

get_draconic_strong_info(8,38) ->
	#base_draconic_strong{id = 8,lv = 38,cost = [{255,36255095,26430}],add_attr = [{1,532},{3,266}]};

get_draconic_strong_info(8,39) ->
	#base_draconic_strong{id = 8,lv = 39,cost = [{255,36255095,27950}],add_attr = [{1,546},{3,273}]};

get_draconic_strong_info(8,40) ->
	#base_draconic_strong{id = 8,lv = 40,cost = [{255,36255095,29550}],add_attr = [{1,560},{3,280}]};

get_draconic_strong_info(8,41) ->
	#base_draconic_strong{id = 8,lv = 41,cost = [{255,36255095,31230}],add_attr = [{1,574},{3,287}]};

get_draconic_strong_info(8,42) ->
	#base_draconic_strong{id = 8,lv = 42,cost = [{255,36255095,32990}],add_attr = [{1,588},{3,294}]};

get_draconic_strong_info(8,43) ->
	#base_draconic_strong{id = 8,lv = 43,cost = [{255,36255095,34840}],add_attr = [{1,602},{3,301}]};

get_draconic_strong_info(8,44) ->
	#base_draconic_strong{id = 8,lv = 44,cost = [{255,36255095,36780}],add_attr = [{1,616},{3,308}]};

get_draconic_strong_info(8,45) ->
	#base_draconic_strong{id = 8,lv = 45,cost = [{255,36255095,38820}],add_attr = [{1,630},{3,315}]};

get_draconic_strong_info(8,46) ->
	#base_draconic_strong{id = 8,lv = 46,cost = [{255,36255095,40960}],add_attr = [{1,644},{3,322}]};

get_draconic_strong_info(8,47) ->
	#base_draconic_strong{id = 8,lv = 47,cost = [{255,36255095,43210}],add_attr = [{1,658},{3,329}]};

get_draconic_strong_info(8,48) ->
	#base_draconic_strong{id = 8,lv = 48,cost = [{255,36255095,45570}],add_attr = [{1,672},{3,336}]};

get_draconic_strong_info(8,49) ->
	#base_draconic_strong{id = 8,lv = 49,cost = [{255,36255095,48050}],add_attr = [{1,686},{3,343}]};

get_draconic_strong_info(8,50) ->
	#base_draconic_strong{id = 8,lv = 50,cost = [{255,36255095,50650}],add_attr = [{1,700},{3,350}]};

get_draconic_strong_info(8,51) ->
	#base_draconic_strong{id = 8,lv = 51,cost = [{255,36255095,53380}],add_attr = [{1,714},{3,357}]};

get_draconic_strong_info(8,52) ->
	#base_draconic_strong{id = 8,lv = 52,cost = [{255,36255095,56250}],add_attr = [{1,728},{3,364}]};

get_draconic_strong_info(8,53) ->
	#base_draconic_strong{id = 8,lv = 53,cost = [{255,36255095,59260}],add_attr = [{1,742},{3,371}]};

get_draconic_strong_info(8,54) ->
	#base_draconic_strong{id = 8,lv = 54,cost = [{255,36255095,62420}],add_attr = [{1,756},{3,378}]};

get_draconic_strong_info(8,55) ->
	#base_draconic_strong{id = 8,lv = 55,cost = [{255,36255095,65740}],add_attr = [{1,770},{3,385}]};

get_draconic_strong_info(8,56) ->
	#base_draconic_strong{id = 8,lv = 56,cost = [{255,36255095,69230}],add_attr = [{1,784},{3,392}]};

get_draconic_strong_info(8,57) ->
	#base_draconic_strong{id = 8,lv = 57,cost = [{255,36255095,72890}],add_attr = [{1,798},{3,399}]};

get_draconic_strong_info(8,58) ->
	#base_draconic_strong{id = 8,lv = 58,cost = [{255,36255095,76730}],add_attr = [{1,812},{3,406}]};

get_draconic_strong_info(8,59) ->
	#base_draconic_strong{id = 8,lv = 59,cost = [{255,36255095,80770}],add_attr = [{1,826},{3,413}]};

get_draconic_strong_info(8,60) ->
	#base_draconic_strong{id = 8,lv = 60,cost = [{255,36255095,85010}],add_attr = [{1,840},{3,420}]};

get_draconic_strong_info(8,61) ->
	#base_draconic_strong{id = 8,lv = 61,cost = [{255,36255095,89460}],add_attr = [{1,854},{3,427}]};

get_draconic_strong_info(8,62) ->
	#base_draconic_strong{id = 8,lv = 62,cost = [{255,36255095,94130}],add_attr = [{1,868},{3,434}]};

get_draconic_strong_info(8,63) ->
	#base_draconic_strong{id = 8,lv = 63,cost = [{255,36255095,99040}],add_attr = [{1,882},{3,441}]};

get_draconic_strong_info(8,64) ->
	#base_draconic_strong{id = 8,lv = 64,cost = [{255,36255095,104190}],add_attr = [{1,896},{3,448}]};

get_draconic_strong_info(8,65) ->
	#base_draconic_strong{id = 8,lv = 65,cost = [{255,36255095,109600}],add_attr = [{1,910},{3,455}]};

get_draconic_strong_info(8,66) ->
	#base_draconic_strong{id = 8,lv = 66,cost = [{255,36255095,115280}],add_attr = [{1,924},{3,462}]};

get_draconic_strong_info(8,67) ->
	#base_draconic_strong{id = 8,lv = 67,cost = [{255,36255095,121240}],add_attr = [{1,938},{3,469}]};

get_draconic_strong_info(8,68) ->
	#base_draconic_strong{id = 8,lv = 68,cost = [{255,36255095,127500}],add_attr = [{1,952},{3,476}]};

get_draconic_strong_info(8,69) ->
	#base_draconic_strong{id = 8,lv = 69,cost = [{255,36255095,134080}],add_attr = [{1,966},{3,483}]};

get_draconic_strong_info(8,70) ->
	#base_draconic_strong{id = 8,lv = 70,cost = [{255,36255095,140980}],add_attr = [{1,980},{3,490}]};

get_draconic_strong_info(8,71) ->
	#base_draconic_strong{id = 8,lv = 71,cost = [{255,36255095,148230}],add_attr = [{1,994},{3,497}]};

get_draconic_strong_info(8,72) ->
	#base_draconic_strong{id = 8,lv = 72,cost = [{255,36255095,155840}],add_attr = [{1,1008},{3,504}]};

get_draconic_strong_info(8,73) ->
	#base_draconic_strong{id = 8,lv = 73,cost = [{255,36255095,163830}],add_attr = [{1,1022},{3,511}]};

get_draconic_strong_info(8,74) ->
	#base_draconic_strong{id = 8,lv = 74,cost = [{255,36255095,172220}],add_attr = [{1,1036},{3,518}]};

get_draconic_strong_info(8,75) ->
	#base_draconic_strong{id = 8,lv = 75,cost = [{255,36255095,181030}],add_attr = [{1,1050},{3,525}]};

get_draconic_strong_info(8,76) ->
	#base_draconic_strong{id = 8,lv = 76,cost = [{255,36255095,190280}],add_attr = [{1,1064},{3,532}]};

get_draconic_strong_info(8,77) ->
	#base_draconic_strong{id = 8,lv = 77,cost = [{255,36255095,199990}],add_attr = [{1,1078},{3,539}]};

get_draconic_strong_info(8,78) ->
	#base_draconic_strong{id = 8,lv = 78,cost = [{255,36255095,210190}],add_attr = [{1,1092},{3,546}]};

get_draconic_strong_info(8,79) ->
	#base_draconic_strong{id = 8,lv = 79,cost = [{255,36255095,220900}],add_attr = [{1,1106},{3,553}]};

get_draconic_strong_info(8,80) ->
	#base_draconic_strong{id = 8,lv = 80,cost = [{255,36255095,232150}],add_attr = [{1,1120},{3,560}]};

get_draconic_strong_info(8,81) ->
	#base_draconic_strong{id = 8,lv = 81,cost = [{255,36255095,243960}],add_attr = [{1,1134},{3,567}]};

get_draconic_strong_info(8,82) ->
	#base_draconic_strong{id = 8,lv = 82,cost = [{255,36255095,256360}],add_attr = [{1,1148},{3,574}]};

get_draconic_strong_info(8,83) ->
	#base_draconic_strong{id = 8,lv = 83,cost = [{255,36255095,269380}],add_attr = [{1,1162},{3,581}]};

get_draconic_strong_info(8,84) ->
	#base_draconic_strong{id = 8,lv = 84,cost = [{255,36255095,283050}],add_attr = [{1,1176},{3,588}]};

get_draconic_strong_info(8,85) ->
	#base_draconic_strong{id = 8,lv = 85,cost = [{255,36255095,297400}],add_attr = [{1,1190},{3,595}]};

get_draconic_strong_info(8,86) ->
	#base_draconic_strong{id = 8,lv = 86,cost = [{255,36255095,312470}],add_attr = [{1,1204},{3,602}]};

get_draconic_strong_info(8,87) ->
	#base_draconic_strong{id = 8,lv = 87,cost = [{255,36255095,328290}],add_attr = [{1,1218},{3,609}]};

get_draconic_strong_info(8,88) ->
	#base_draconic_strong{id = 8,lv = 88,cost = [{255,36255095,344900}],add_attr = [{1,1232},{3,616}]};

get_draconic_strong_info(8,89) ->
	#base_draconic_strong{id = 8,lv = 89,cost = [{255,36255095,362350}],add_attr = [{1,1246},{3,623}]};

get_draconic_strong_info(8,90) ->
	#base_draconic_strong{id = 8,lv = 90,cost = [{255,36255095,380670}],add_attr = [{1,1260},{3,630}]};

get_draconic_strong_info(8,91) ->
	#base_draconic_strong{id = 8,lv = 91,cost = [{255,36255095,399900}],add_attr = [{1,1274},{3,637}]};

get_draconic_strong_info(8,92) ->
	#base_draconic_strong{id = 8,lv = 92,cost = [{255,36255095,420100}],add_attr = [{1,1288},{3,644}]};

get_draconic_strong_info(8,93) ->
	#base_draconic_strong{id = 8,lv = 93,cost = [{255,36255095,441310}],add_attr = [{1,1302},{3,651}]};

get_draconic_strong_info(8,94) ->
	#base_draconic_strong{id = 8,lv = 94,cost = [{255,36255095,463580}],add_attr = [{1,1316},{3,658}]};

get_draconic_strong_info(8,95) ->
	#base_draconic_strong{id = 8,lv = 95,cost = [{255,36255095,486960}],add_attr = [{1,1330},{3,665}]};

get_draconic_strong_info(8,96) ->
	#base_draconic_strong{id = 8,lv = 96,cost = [{255,36255095,511510}],add_attr = [{1,1344},{3,672}]};

get_draconic_strong_info(8,97) ->
	#base_draconic_strong{id = 8,lv = 97,cost = [{255,36255095,537290}],add_attr = [{1,1358},{3,679}]};

get_draconic_strong_info(8,98) ->
	#base_draconic_strong{id = 8,lv = 98,cost = [{255,36255095,564350}],add_attr = [{1,1372},{3,686}]};

get_draconic_strong_info(8,99) ->
	#base_draconic_strong{id = 8,lv = 99,cost = [{255,36255095,592770}],add_attr = [{1,1386},{3,693}]};

get_draconic_strong_info(8,100) ->
	#base_draconic_strong{id = 8,lv = 100,cost = [{255,36255095,622610}],add_attr = [{1,1400},{3,700}]};

get_draconic_strong_info(9,0) ->
	#base_draconic_strong{id = 9,lv = 0,cost = [],add_attr = [{4,0},{8,0}]};

get_draconic_strong_info(9,1) ->
	#base_draconic_strong{id = 9,lv = 1,cost = [{255,36255095,1000}],add_attr = [{4,14},{8,11}]};

get_draconic_strong_info(9,2) ->
	#base_draconic_strong{id = 9,lv = 2,cost = [{255,36255095,1250}],add_attr = [{4,28},{8,22}]};

get_draconic_strong_info(9,3) ->
	#base_draconic_strong{id = 9,lv = 3,cost = [{255,36255095,1510}],add_attr = [{4,42},{8,33}]};

get_draconic_strong_info(9,4) ->
	#base_draconic_strong{id = 9,lv = 4,cost = [{255,36255095,1790}],add_attr = [{4,56},{8,44}]};

get_draconic_strong_info(9,5) ->
	#base_draconic_strong{id = 9,lv = 5,cost = [{255,36255095,2080}],add_attr = [{4,70},{8,55}]};

get_draconic_strong_info(9,6) ->
	#base_draconic_strong{id = 9,lv = 6,cost = [{255,36255095,2380}],add_attr = [{4,84},{8,66}]};

get_draconic_strong_info(9,7) ->
	#base_draconic_strong{id = 9,lv = 7,cost = [{255,36255095,2700}],add_attr = [{4,98},{8,77}]};

get_draconic_strong_info(9,8) ->
	#base_draconic_strong{id = 9,lv = 8,cost = [{255,36255095,3040}],add_attr = [{4,112},{8,88}]};

get_draconic_strong_info(9,9) ->
	#base_draconic_strong{id = 9,lv = 9,cost = [{255,36255095,3390}],add_attr = [{4,126},{8,99}]};

get_draconic_strong_info(9,10) ->
	#base_draconic_strong{id = 9,lv = 10,cost = [{255,36255095,3760}],add_attr = [{4,140},{8,110}]};

get_draconic_strong_info(9,11) ->
	#base_draconic_strong{id = 9,lv = 11,cost = [{255,36255095,4150}],add_attr = [{4,154},{8,121}]};

get_draconic_strong_info(9,12) ->
	#base_draconic_strong{id = 9,lv = 12,cost = [{255,36255095,4560}],add_attr = [{4,168},{8,132}]};

get_draconic_strong_info(9,13) ->
	#base_draconic_strong{id = 9,lv = 13,cost = [{255,36255095,4990}],add_attr = [{4,182},{8,143}]};

get_draconic_strong_info(9,14) ->
	#base_draconic_strong{id = 9,lv = 14,cost = [{255,36255095,5440}],add_attr = [{4,196},{8,154}]};

get_draconic_strong_info(9,15) ->
	#base_draconic_strong{id = 9,lv = 15,cost = [{255,36255095,5910}],add_attr = [{4,210},{8,165}]};

get_draconic_strong_info(9,16) ->
	#base_draconic_strong{id = 9,lv = 16,cost = [{255,36255095,6410}],add_attr = [{4,224},{8,176}]};

get_draconic_strong_info(9,17) ->
	#base_draconic_strong{id = 9,lv = 17,cost = [{255,36255095,6930}],add_attr = [{4,238},{8,187}]};

get_draconic_strong_info(9,18) ->
	#base_draconic_strong{id = 9,lv = 18,cost = [{255,36255095,7480}],add_attr = [{4,252},{8,198}]};

get_draconic_strong_info(9,19) ->
	#base_draconic_strong{id = 9,lv = 19,cost = [{255,36255095,8050}],add_attr = [{4,266},{8,209}]};

get_draconic_strong_info(9,20) ->
	#base_draconic_strong{id = 9,lv = 20,cost = [{255,36255095,8650}],add_attr = [{4,280},{8,220}]};

get_draconic_strong_info(9,21) ->
	#base_draconic_strong{id = 9,lv = 21,cost = [{255,36255095,9280}],add_attr = [{4,294},{8,231}]};

get_draconic_strong_info(9,22) ->
	#base_draconic_strong{id = 9,lv = 22,cost = [{255,36255095,9940}],add_attr = [{4,308},{8,242}]};

get_draconic_strong_info(9,23) ->
	#base_draconic_strong{id = 9,lv = 23,cost = [{255,36255095,10640}],add_attr = [{4,322},{8,253}]};

get_draconic_strong_info(9,24) ->
	#base_draconic_strong{id = 9,lv = 24,cost = [{255,36255095,11370}],add_attr = [{4,336},{8,264}]};

get_draconic_strong_info(9,25) ->
	#base_draconic_strong{id = 9,lv = 25,cost = [{255,36255095,12140}],add_attr = [{4,350},{8,275}]};

get_draconic_strong_info(9,26) ->
	#base_draconic_strong{id = 9,lv = 26,cost = [{255,36255095,12950}],add_attr = [{4,364},{8,286}]};

get_draconic_strong_info(9,27) ->
	#base_draconic_strong{id = 9,lv = 27,cost = [{255,36255095,13800}],add_attr = [{4,378},{8,297}]};

get_draconic_strong_info(9,28) ->
	#base_draconic_strong{id = 9,lv = 28,cost = [{255,36255095,14690}],add_attr = [{4,392},{8,308}]};

get_draconic_strong_info(9,29) ->
	#base_draconic_strong{id = 9,lv = 29,cost = [{255,36255095,15620}],add_attr = [{4,406},{8,319}]};

get_draconic_strong_info(9,30) ->
	#base_draconic_strong{id = 9,lv = 30,cost = [{255,36255095,16600}],add_attr = [{4,420},{8,330}]};

get_draconic_strong_info(9,31) ->
	#base_draconic_strong{id = 9,lv = 31,cost = [{255,36255095,17630}],add_attr = [{4,434},{8,341}]};

get_draconic_strong_info(9,32) ->
	#base_draconic_strong{id = 9,lv = 32,cost = [{255,36255095,18710}],add_attr = [{4,448},{8,352}]};

get_draconic_strong_info(9,33) ->
	#base_draconic_strong{id = 9,lv = 33,cost = [{255,36255095,19850}],add_attr = [{4,462},{8,363}]};

get_draconic_strong_info(9,34) ->
	#base_draconic_strong{id = 9,lv = 34,cost = [{255,36255095,21040}],add_attr = [{4,476},{8,374}]};

get_draconic_strong_info(9,35) ->
	#base_draconic_strong{id = 9,lv = 35,cost = [{255,36255095,22290}],add_attr = [{4,490},{8,385}]};

get_draconic_strong_info(9,36) ->
	#base_draconic_strong{id = 9,lv = 36,cost = [{255,36255095,23600}],add_attr = [{4,504},{8,396}]};

get_draconic_strong_info(9,37) ->
	#base_draconic_strong{id = 9,lv = 37,cost = [{255,36255095,24980}],add_attr = [{4,518},{8,407}]};

get_draconic_strong_info(9,38) ->
	#base_draconic_strong{id = 9,lv = 38,cost = [{255,36255095,26430}],add_attr = [{4,532},{8,418}]};

get_draconic_strong_info(9,39) ->
	#base_draconic_strong{id = 9,lv = 39,cost = [{255,36255095,27950}],add_attr = [{4,546},{8,429}]};

get_draconic_strong_info(9,40) ->
	#base_draconic_strong{id = 9,lv = 40,cost = [{255,36255095,29550}],add_attr = [{4,560},{8,440}]};

get_draconic_strong_info(9,41) ->
	#base_draconic_strong{id = 9,lv = 41,cost = [{255,36255095,31230}],add_attr = [{4,574},{8,451}]};

get_draconic_strong_info(9,42) ->
	#base_draconic_strong{id = 9,lv = 42,cost = [{255,36255095,32990}],add_attr = [{4,588},{8,462}]};

get_draconic_strong_info(9,43) ->
	#base_draconic_strong{id = 9,lv = 43,cost = [{255,36255095,34840}],add_attr = [{4,602},{8,473}]};

get_draconic_strong_info(9,44) ->
	#base_draconic_strong{id = 9,lv = 44,cost = [{255,36255095,36780}],add_attr = [{4,616},{8,484}]};

get_draconic_strong_info(9,45) ->
	#base_draconic_strong{id = 9,lv = 45,cost = [{255,36255095,38820}],add_attr = [{4,630},{8,495}]};

get_draconic_strong_info(9,46) ->
	#base_draconic_strong{id = 9,lv = 46,cost = [{255,36255095,40960}],add_attr = [{4,644},{8,506}]};

get_draconic_strong_info(9,47) ->
	#base_draconic_strong{id = 9,lv = 47,cost = [{255,36255095,43210}],add_attr = [{4,658},{8,517}]};

get_draconic_strong_info(9,48) ->
	#base_draconic_strong{id = 9,lv = 48,cost = [{255,36255095,45570}],add_attr = [{4,672},{8,528}]};

get_draconic_strong_info(9,49) ->
	#base_draconic_strong{id = 9,lv = 49,cost = [{255,36255095,48050}],add_attr = [{4,686},{8,539}]};

get_draconic_strong_info(9,50) ->
	#base_draconic_strong{id = 9,lv = 50,cost = [{255,36255095,50650}],add_attr = [{4,700},{8,550}]};

get_draconic_strong_info(9,51) ->
	#base_draconic_strong{id = 9,lv = 51,cost = [{255,36255095,53380}],add_attr = [{4,714},{8,561}]};

get_draconic_strong_info(9,52) ->
	#base_draconic_strong{id = 9,lv = 52,cost = [{255,36255095,56250}],add_attr = [{4,728},{8,572}]};

get_draconic_strong_info(9,53) ->
	#base_draconic_strong{id = 9,lv = 53,cost = [{255,36255095,59260}],add_attr = [{4,742},{8,583}]};

get_draconic_strong_info(9,54) ->
	#base_draconic_strong{id = 9,lv = 54,cost = [{255,36255095,62420}],add_attr = [{4,756},{8,594}]};

get_draconic_strong_info(9,55) ->
	#base_draconic_strong{id = 9,lv = 55,cost = [{255,36255095,65740}],add_attr = [{4,770},{8,605}]};

get_draconic_strong_info(9,56) ->
	#base_draconic_strong{id = 9,lv = 56,cost = [{255,36255095,69230}],add_attr = [{4,784},{8,616}]};

get_draconic_strong_info(9,57) ->
	#base_draconic_strong{id = 9,lv = 57,cost = [{255,36255095,72890}],add_attr = [{4,798},{8,627}]};

get_draconic_strong_info(9,58) ->
	#base_draconic_strong{id = 9,lv = 58,cost = [{255,36255095,76730}],add_attr = [{4,812},{8,638}]};

get_draconic_strong_info(9,59) ->
	#base_draconic_strong{id = 9,lv = 59,cost = [{255,36255095,80770}],add_attr = [{4,826},{8,649}]};

get_draconic_strong_info(9,60) ->
	#base_draconic_strong{id = 9,lv = 60,cost = [{255,36255095,85010}],add_attr = [{4,840},{8,660}]};

get_draconic_strong_info(9,61) ->
	#base_draconic_strong{id = 9,lv = 61,cost = [{255,36255095,89460}],add_attr = [{4,854},{8,671}]};

get_draconic_strong_info(9,62) ->
	#base_draconic_strong{id = 9,lv = 62,cost = [{255,36255095,94130}],add_attr = [{4,868},{8,682}]};

get_draconic_strong_info(9,63) ->
	#base_draconic_strong{id = 9,lv = 63,cost = [{255,36255095,99040}],add_attr = [{4,882},{8,693}]};

get_draconic_strong_info(9,64) ->
	#base_draconic_strong{id = 9,lv = 64,cost = [{255,36255095,104190}],add_attr = [{4,896},{8,704}]};

get_draconic_strong_info(9,65) ->
	#base_draconic_strong{id = 9,lv = 65,cost = [{255,36255095,109600}],add_attr = [{4,910},{8,715}]};

get_draconic_strong_info(9,66) ->
	#base_draconic_strong{id = 9,lv = 66,cost = [{255,36255095,115280}],add_attr = [{4,924},{8,726}]};

get_draconic_strong_info(9,67) ->
	#base_draconic_strong{id = 9,lv = 67,cost = [{255,36255095,121240}],add_attr = [{4,938},{8,737}]};

get_draconic_strong_info(9,68) ->
	#base_draconic_strong{id = 9,lv = 68,cost = [{255,36255095,127500}],add_attr = [{4,952},{8,748}]};

get_draconic_strong_info(9,69) ->
	#base_draconic_strong{id = 9,lv = 69,cost = [{255,36255095,134080}],add_attr = [{4,966},{8,759}]};

get_draconic_strong_info(9,70) ->
	#base_draconic_strong{id = 9,lv = 70,cost = [{255,36255095,140980}],add_attr = [{4,980},{8,770}]};

get_draconic_strong_info(9,71) ->
	#base_draconic_strong{id = 9,lv = 71,cost = [{255,36255095,148230}],add_attr = [{4,994},{8,781}]};

get_draconic_strong_info(9,72) ->
	#base_draconic_strong{id = 9,lv = 72,cost = [{255,36255095,155840}],add_attr = [{4,1008},{8,792}]};

get_draconic_strong_info(9,73) ->
	#base_draconic_strong{id = 9,lv = 73,cost = [{255,36255095,163830}],add_attr = [{4,1022},{8,803}]};

get_draconic_strong_info(9,74) ->
	#base_draconic_strong{id = 9,lv = 74,cost = [{255,36255095,172220}],add_attr = [{4,1036},{8,814}]};

get_draconic_strong_info(9,75) ->
	#base_draconic_strong{id = 9,lv = 75,cost = [{255,36255095,181030}],add_attr = [{4,1050},{8,825}]};

get_draconic_strong_info(9,76) ->
	#base_draconic_strong{id = 9,lv = 76,cost = [{255,36255095,190280}],add_attr = [{4,1064},{8,836}]};

get_draconic_strong_info(9,77) ->
	#base_draconic_strong{id = 9,lv = 77,cost = [{255,36255095,199990}],add_attr = [{4,1078},{8,847}]};

get_draconic_strong_info(9,78) ->
	#base_draconic_strong{id = 9,lv = 78,cost = [{255,36255095,210190}],add_attr = [{4,1092},{8,858}]};

get_draconic_strong_info(9,79) ->
	#base_draconic_strong{id = 9,lv = 79,cost = [{255,36255095,220900}],add_attr = [{4,1106},{8,869}]};

get_draconic_strong_info(9,80) ->
	#base_draconic_strong{id = 9,lv = 80,cost = [{255,36255095,232150}],add_attr = [{4,1120},{8,880}]};

get_draconic_strong_info(9,81) ->
	#base_draconic_strong{id = 9,lv = 81,cost = [{255,36255095,243960}],add_attr = [{4,1134},{8,891}]};

get_draconic_strong_info(9,82) ->
	#base_draconic_strong{id = 9,lv = 82,cost = [{255,36255095,256360}],add_attr = [{4,1148},{8,902}]};

get_draconic_strong_info(9,83) ->
	#base_draconic_strong{id = 9,lv = 83,cost = [{255,36255095,269380}],add_attr = [{4,1162},{8,913}]};

get_draconic_strong_info(9,84) ->
	#base_draconic_strong{id = 9,lv = 84,cost = [{255,36255095,283050}],add_attr = [{4,1176},{8,924}]};

get_draconic_strong_info(9,85) ->
	#base_draconic_strong{id = 9,lv = 85,cost = [{255,36255095,297400}],add_attr = [{4,1190},{8,935}]};

get_draconic_strong_info(9,86) ->
	#base_draconic_strong{id = 9,lv = 86,cost = [{255,36255095,312470}],add_attr = [{4,1204},{8,946}]};

get_draconic_strong_info(9,87) ->
	#base_draconic_strong{id = 9,lv = 87,cost = [{255,36255095,328290}],add_attr = [{4,1218},{8,957}]};

get_draconic_strong_info(9,88) ->
	#base_draconic_strong{id = 9,lv = 88,cost = [{255,36255095,344900}],add_attr = [{4,1232},{8,968}]};

get_draconic_strong_info(9,89) ->
	#base_draconic_strong{id = 9,lv = 89,cost = [{255,36255095,362350}],add_attr = [{4,1246},{8,979}]};

get_draconic_strong_info(9,90) ->
	#base_draconic_strong{id = 9,lv = 90,cost = [{255,36255095,380670}],add_attr = [{4,1260},{8,990}]};

get_draconic_strong_info(9,91) ->
	#base_draconic_strong{id = 9,lv = 91,cost = [{255,36255095,399900}],add_attr = [{4,1274},{8,1001}]};

get_draconic_strong_info(9,92) ->
	#base_draconic_strong{id = 9,lv = 92,cost = [{255,36255095,420100}],add_attr = [{4,1288},{8,1012}]};

get_draconic_strong_info(9,93) ->
	#base_draconic_strong{id = 9,lv = 93,cost = [{255,36255095,441310}],add_attr = [{4,1302},{8,1023}]};

get_draconic_strong_info(9,94) ->
	#base_draconic_strong{id = 9,lv = 94,cost = [{255,36255095,463580}],add_attr = [{4,1316},{8,1034}]};

get_draconic_strong_info(9,95) ->
	#base_draconic_strong{id = 9,lv = 95,cost = [{255,36255095,486960}],add_attr = [{4,1330},{8,1045}]};

get_draconic_strong_info(9,96) ->
	#base_draconic_strong{id = 9,lv = 96,cost = [{255,36255095,511510}],add_attr = [{4,1344},{8,1056}]};

get_draconic_strong_info(9,97) ->
	#base_draconic_strong{id = 9,lv = 97,cost = [{255,36255095,537290}],add_attr = [{4,1358},{8,1067}]};

get_draconic_strong_info(9,98) ->
	#base_draconic_strong{id = 9,lv = 98,cost = [{255,36255095,564350}],add_attr = [{4,1372},{8,1078}]};

get_draconic_strong_info(9,99) ->
	#base_draconic_strong{id = 9,lv = 99,cost = [{255,36255095,592770}],add_attr = [{4,1386},{8,1089}]};

get_draconic_strong_info(9,100) ->
	#base_draconic_strong{id = 9,lv = 100,cost = [{255,36255095,622610}],add_attr = [{4,1400},{8,1100}]};

get_draconic_strong_info(10,0) ->
	#base_draconic_strong{id = 10,lv = 0,cost = [],add_attr = [{3,0},{7,0}]};

get_draconic_strong_info(10,1) ->
	#base_draconic_strong{id = 10,lv = 1,cost = [{255,36255095,1000}],add_attr = [{3,14},{7,14}]};

get_draconic_strong_info(10,2) ->
	#base_draconic_strong{id = 10,lv = 2,cost = [{255,36255095,1250}],add_attr = [{3,28},{7,28}]};

get_draconic_strong_info(10,3) ->
	#base_draconic_strong{id = 10,lv = 3,cost = [{255,36255095,1510}],add_attr = [{3,42},{7,42}]};

get_draconic_strong_info(10,4) ->
	#base_draconic_strong{id = 10,lv = 4,cost = [{255,36255095,1790}],add_attr = [{3,56},{7,56}]};

get_draconic_strong_info(10,5) ->
	#base_draconic_strong{id = 10,lv = 5,cost = [{255,36255095,2080}],add_attr = [{3,70},{7,70}]};

get_draconic_strong_info(10,6) ->
	#base_draconic_strong{id = 10,lv = 6,cost = [{255,36255095,2380}],add_attr = [{3,84},{7,84}]};

get_draconic_strong_info(10,7) ->
	#base_draconic_strong{id = 10,lv = 7,cost = [{255,36255095,2700}],add_attr = [{3,98},{7,98}]};

get_draconic_strong_info(10,8) ->
	#base_draconic_strong{id = 10,lv = 8,cost = [{255,36255095,3040}],add_attr = [{3,112},{7,112}]};

get_draconic_strong_info(10,9) ->
	#base_draconic_strong{id = 10,lv = 9,cost = [{255,36255095,3390}],add_attr = [{3,126},{7,126}]};

get_draconic_strong_info(10,10) ->
	#base_draconic_strong{id = 10,lv = 10,cost = [{255,36255095,3760}],add_attr = [{3,140},{7,140}]};

get_draconic_strong_info(10,11) ->
	#base_draconic_strong{id = 10,lv = 11,cost = [{255,36255095,4150}],add_attr = [{3,154},{7,154}]};

get_draconic_strong_info(10,12) ->
	#base_draconic_strong{id = 10,lv = 12,cost = [{255,36255095,4560}],add_attr = [{3,168},{7,168}]};

get_draconic_strong_info(10,13) ->
	#base_draconic_strong{id = 10,lv = 13,cost = [{255,36255095,4990}],add_attr = [{3,182},{7,182}]};

get_draconic_strong_info(10,14) ->
	#base_draconic_strong{id = 10,lv = 14,cost = [{255,36255095,5440}],add_attr = [{3,196},{7,196}]};

get_draconic_strong_info(10,15) ->
	#base_draconic_strong{id = 10,lv = 15,cost = [{255,36255095,5910}],add_attr = [{3,210},{7,210}]};

get_draconic_strong_info(10,16) ->
	#base_draconic_strong{id = 10,lv = 16,cost = [{255,36255095,6410}],add_attr = [{3,224},{7,224}]};

get_draconic_strong_info(10,17) ->
	#base_draconic_strong{id = 10,lv = 17,cost = [{255,36255095,6930}],add_attr = [{3,238},{7,238}]};

get_draconic_strong_info(10,18) ->
	#base_draconic_strong{id = 10,lv = 18,cost = [{255,36255095,7480}],add_attr = [{3,252},{7,252}]};

get_draconic_strong_info(10,19) ->
	#base_draconic_strong{id = 10,lv = 19,cost = [{255,36255095,8050}],add_attr = [{3,266},{7,266}]};

get_draconic_strong_info(10,20) ->
	#base_draconic_strong{id = 10,lv = 20,cost = [{255,36255095,8650}],add_attr = [{3,280},{7,280}]};

get_draconic_strong_info(10,21) ->
	#base_draconic_strong{id = 10,lv = 21,cost = [{255,36255095,9280}],add_attr = [{3,294},{7,294}]};

get_draconic_strong_info(10,22) ->
	#base_draconic_strong{id = 10,lv = 22,cost = [{255,36255095,9940}],add_attr = [{3,308},{7,308}]};

get_draconic_strong_info(10,23) ->
	#base_draconic_strong{id = 10,lv = 23,cost = [{255,36255095,10640}],add_attr = [{3,322},{7,322}]};

get_draconic_strong_info(10,24) ->
	#base_draconic_strong{id = 10,lv = 24,cost = [{255,36255095,11370}],add_attr = [{3,336},{7,336}]};

get_draconic_strong_info(10,25) ->
	#base_draconic_strong{id = 10,lv = 25,cost = [{255,36255095,12140}],add_attr = [{3,350},{7,350}]};

get_draconic_strong_info(10,26) ->
	#base_draconic_strong{id = 10,lv = 26,cost = [{255,36255095,12950}],add_attr = [{3,364},{7,364}]};

get_draconic_strong_info(10,27) ->
	#base_draconic_strong{id = 10,lv = 27,cost = [{255,36255095,13800}],add_attr = [{3,378},{7,378}]};

get_draconic_strong_info(10,28) ->
	#base_draconic_strong{id = 10,lv = 28,cost = [{255,36255095,14690}],add_attr = [{3,392},{7,392}]};

get_draconic_strong_info(10,29) ->
	#base_draconic_strong{id = 10,lv = 29,cost = [{255,36255095,15620}],add_attr = [{3,406},{7,406}]};

get_draconic_strong_info(10,30) ->
	#base_draconic_strong{id = 10,lv = 30,cost = [{255,36255095,16600}],add_attr = [{3,420},{7,420}]};

get_draconic_strong_info(10,31) ->
	#base_draconic_strong{id = 10,lv = 31,cost = [{255,36255095,17630}],add_attr = [{3,434},{7,434}]};

get_draconic_strong_info(10,32) ->
	#base_draconic_strong{id = 10,lv = 32,cost = [{255,36255095,18710}],add_attr = [{3,448},{7,448}]};

get_draconic_strong_info(10,33) ->
	#base_draconic_strong{id = 10,lv = 33,cost = [{255,36255095,19850}],add_attr = [{3,462},{7,462}]};

get_draconic_strong_info(10,34) ->
	#base_draconic_strong{id = 10,lv = 34,cost = [{255,36255095,21040}],add_attr = [{3,476},{7,476}]};

get_draconic_strong_info(10,35) ->
	#base_draconic_strong{id = 10,lv = 35,cost = [{255,36255095,22290}],add_attr = [{3,490},{7,490}]};

get_draconic_strong_info(10,36) ->
	#base_draconic_strong{id = 10,lv = 36,cost = [{255,36255095,23600}],add_attr = [{3,504},{7,504}]};

get_draconic_strong_info(10,37) ->
	#base_draconic_strong{id = 10,lv = 37,cost = [{255,36255095,24980}],add_attr = [{3,518},{7,518}]};

get_draconic_strong_info(10,38) ->
	#base_draconic_strong{id = 10,lv = 38,cost = [{255,36255095,26430}],add_attr = [{3,532},{7,532}]};

get_draconic_strong_info(10,39) ->
	#base_draconic_strong{id = 10,lv = 39,cost = [{255,36255095,27950}],add_attr = [{3,546},{7,546}]};

get_draconic_strong_info(10,40) ->
	#base_draconic_strong{id = 10,lv = 40,cost = [{255,36255095,29550}],add_attr = [{3,560},{7,560}]};

get_draconic_strong_info(10,41) ->
	#base_draconic_strong{id = 10,lv = 41,cost = [{255,36255095,31230}],add_attr = [{3,574},{7,574}]};

get_draconic_strong_info(10,42) ->
	#base_draconic_strong{id = 10,lv = 42,cost = [{255,36255095,32990}],add_attr = [{3,588},{7,588}]};

get_draconic_strong_info(10,43) ->
	#base_draconic_strong{id = 10,lv = 43,cost = [{255,36255095,34840}],add_attr = [{3,602},{7,602}]};

get_draconic_strong_info(10,44) ->
	#base_draconic_strong{id = 10,lv = 44,cost = [{255,36255095,36780}],add_attr = [{3,616},{7,616}]};

get_draconic_strong_info(10,45) ->
	#base_draconic_strong{id = 10,lv = 45,cost = [{255,36255095,38820}],add_attr = [{3,630},{7,630}]};

get_draconic_strong_info(10,46) ->
	#base_draconic_strong{id = 10,lv = 46,cost = [{255,36255095,40960}],add_attr = [{3,644},{7,644}]};

get_draconic_strong_info(10,47) ->
	#base_draconic_strong{id = 10,lv = 47,cost = [{255,36255095,43210}],add_attr = [{3,658},{7,658}]};

get_draconic_strong_info(10,48) ->
	#base_draconic_strong{id = 10,lv = 48,cost = [{255,36255095,45570}],add_attr = [{3,672},{7,672}]};

get_draconic_strong_info(10,49) ->
	#base_draconic_strong{id = 10,lv = 49,cost = [{255,36255095,48050}],add_attr = [{3,686},{7,686}]};

get_draconic_strong_info(10,50) ->
	#base_draconic_strong{id = 10,lv = 50,cost = [{255,36255095,50650}],add_attr = [{3,700},{7,700}]};

get_draconic_strong_info(10,51) ->
	#base_draconic_strong{id = 10,lv = 51,cost = [{255,36255095,53380}],add_attr = [{3,714},{7,714}]};

get_draconic_strong_info(10,52) ->
	#base_draconic_strong{id = 10,lv = 52,cost = [{255,36255095,56250}],add_attr = [{3,728},{7,728}]};

get_draconic_strong_info(10,53) ->
	#base_draconic_strong{id = 10,lv = 53,cost = [{255,36255095,59260}],add_attr = [{3,742},{7,742}]};

get_draconic_strong_info(10,54) ->
	#base_draconic_strong{id = 10,lv = 54,cost = [{255,36255095,62420}],add_attr = [{3,756},{7,756}]};

get_draconic_strong_info(10,55) ->
	#base_draconic_strong{id = 10,lv = 55,cost = [{255,36255095,65740}],add_attr = [{3,770},{7,770}]};

get_draconic_strong_info(10,56) ->
	#base_draconic_strong{id = 10,lv = 56,cost = [{255,36255095,69230}],add_attr = [{3,784},{7,784}]};

get_draconic_strong_info(10,57) ->
	#base_draconic_strong{id = 10,lv = 57,cost = [{255,36255095,72890}],add_attr = [{3,798},{7,798}]};

get_draconic_strong_info(10,58) ->
	#base_draconic_strong{id = 10,lv = 58,cost = [{255,36255095,76730}],add_attr = [{3,812},{7,812}]};

get_draconic_strong_info(10,59) ->
	#base_draconic_strong{id = 10,lv = 59,cost = [{255,36255095,80770}],add_attr = [{3,826},{7,826}]};

get_draconic_strong_info(10,60) ->
	#base_draconic_strong{id = 10,lv = 60,cost = [{255,36255095,85010}],add_attr = [{3,840},{7,840}]};

get_draconic_strong_info(10,61) ->
	#base_draconic_strong{id = 10,lv = 61,cost = [{255,36255095,89460}],add_attr = [{3,854},{7,854}]};

get_draconic_strong_info(10,62) ->
	#base_draconic_strong{id = 10,lv = 62,cost = [{255,36255095,94130}],add_attr = [{3,868},{7,868}]};

get_draconic_strong_info(10,63) ->
	#base_draconic_strong{id = 10,lv = 63,cost = [{255,36255095,99040}],add_attr = [{3,882},{7,882}]};

get_draconic_strong_info(10,64) ->
	#base_draconic_strong{id = 10,lv = 64,cost = [{255,36255095,104190}],add_attr = [{3,896},{7,896}]};

get_draconic_strong_info(10,65) ->
	#base_draconic_strong{id = 10,lv = 65,cost = [{255,36255095,109600}],add_attr = [{3,910},{7,910}]};

get_draconic_strong_info(10,66) ->
	#base_draconic_strong{id = 10,lv = 66,cost = [{255,36255095,115280}],add_attr = [{3,924},{7,924}]};

get_draconic_strong_info(10,67) ->
	#base_draconic_strong{id = 10,lv = 67,cost = [{255,36255095,121240}],add_attr = [{3,938},{7,938}]};

get_draconic_strong_info(10,68) ->
	#base_draconic_strong{id = 10,lv = 68,cost = [{255,36255095,127500}],add_attr = [{3,952},{7,952}]};

get_draconic_strong_info(10,69) ->
	#base_draconic_strong{id = 10,lv = 69,cost = [{255,36255095,134080}],add_attr = [{3,966},{7,966}]};

get_draconic_strong_info(10,70) ->
	#base_draconic_strong{id = 10,lv = 70,cost = [{255,36255095,140980}],add_attr = [{3,980},{7,980}]};

get_draconic_strong_info(10,71) ->
	#base_draconic_strong{id = 10,lv = 71,cost = [{255,36255095,148230}],add_attr = [{3,994},{7,994}]};

get_draconic_strong_info(10,72) ->
	#base_draconic_strong{id = 10,lv = 72,cost = [{255,36255095,155840}],add_attr = [{3,1008},{7,1008}]};

get_draconic_strong_info(10,73) ->
	#base_draconic_strong{id = 10,lv = 73,cost = [{255,36255095,163830}],add_attr = [{3,1022},{7,1022}]};

get_draconic_strong_info(10,74) ->
	#base_draconic_strong{id = 10,lv = 74,cost = [{255,36255095,172220}],add_attr = [{3,1036},{7,1036}]};

get_draconic_strong_info(10,75) ->
	#base_draconic_strong{id = 10,lv = 75,cost = [{255,36255095,181030}],add_attr = [{3,1050},{7,1050}]};

get_draconic_strong_info(10,76) ->
	#base_draconic_strong{id = 10,lv = 76,cost = [{255,36255095,190280}],add_attr = [{3,1064},{7,1064}]};

get_draconic_strong_info(10,77) ->
	#base_draconic_strong{id = 10,lv = 77,cost = [{255,36255095,199990}],add_attr = [{3,1078},{7,1078}]};

get_draconic_strong_info(10,78) ->
	#base_draconic_strong{id = 10,lv = 78,cost = [{255,36255095,210190}],add_attr = [{3,1092},{7,1092}]};

get_draconic_strong_info(10,79) ->
	#base_draconic_strong{id = 10,lv = 79,cost = [{255,36255095,220900}],add_attr = [{3,1106},{7,1106}]};

get_draconic_strong_info(10,80) ->
	#base_draconic_strong{id = 10,lv = 80,cost = [{255,36255095,232150}],add_attr = [{3,1120},{7,1120}]};

get_draconic_strong_info(10,81) ->
	#base_draconic_strong{id = 10,lv = 81,cost = [{255,36255095,243960}],add_attr = [{3,1134},{7,1134}]};

get_draconic_strong_info(10,82) ->
	#base_draconic_strong{id = 10,lv = 82,cost = [{255,36255095,256360}],add_attr = [{3,1148},{7,1148}]};

get_draconic_strong_info(10,83) ->
	#base_draconic_strong{id = 10,lv = 83,cost = [{255,36255095,269380}],add_attr = [{3,1162},{7,1162}]};

get_draconic_strong_info(10,84) ->
	#base_draconic_strong{id = 10,lv = 84,cost = [{255,36255095,283050}],add_attr = [{3,1176},{7,1176}]};

get_draconic_strong_info(10,85) ->
	#base_draconic_strong{id = 10,lv = 85,cost = [{255,36255095,297400}],add_attr = [{3,1190},{7,1190}]};

get_draconic_strong_info(10,86) ->
	#base_draconic_strong{id = 10,lv = 86,cost = [{255,36255095,312470}],add_attr = [{3,1204},{7,1204}]};

get_draconic_strong_info(10,87) ->
	#base_draconic_strong{id = 10,lv = 87,cost = [{255,36255095,328290}],add_attr = [{3,1218},{7,1218}]};

get_draconic_strong_info(10,88) ->
	#base_draconic_strong{id = 10,lv = 88,cost = [{255,36255095,344900}],add_attr = [{3,1232},{7,1232}]};

get_draconic_strong_info(10,89) ->
	#base_draconic_strong{id = 10,lv = 89,cost = [{255,36255095,362350}],add_attr = [{3,1246},{7,1246}]};

get_draconic_strong_info(10,90) ->
	#base_draconic_strong{id = 10,lv = 90,cost = [{255,36255095,380670}],add_attr = [{3,1260},{7,1260}]};

get_draconic_strong_info(10,91) ->
	#base_draconic_strong{id = 10,lv = 91,cost = [{255,36255095,399900}],add_attr = [{3,1274},{7,1274}]};

get_draconic_strong_info(10,92) ->
	#base_draconic_strong{id = 10,lv = 92,cost = [{255,36255095,420100}],add_attr = [{3,1288},{7,1288}]};

get_draconic_strong_info(10,93) ->
	#base_draconic_strong{id = 10,lv = 93,cost = [{255,36255095,441310}],add_attr = [{3,1302},{7,1302}]};

get_draconic_strong_info(10,94) ->
	#base_draconic_strong{id = 10,lv = 94,cost = [{255,36255095,463580}],add_attr = [{3,1316},{7,1316}]};

get_draconic_strong_info(10,95) ->
	#base_draconic_strong{id = 10,lv = 95,cost = [{255,36255095,486960}],add_attr = [{3,1330},{7,1330}]};

get_draconic_strong_info(10,96) ->
	#base_draconic_strong{id = 10,lv = 96,cost = [{255,36255095,511510}],add_attr = [{3,1344},{7,1344}]};

get_draconic_strong_info(10,97) ->
	#base_draconic_strong{id = 10,lv = 97,cost = [{255,36255095,537290}],add_attr = [{3,1358},{7,1358}]};

get_draconic_strong_info(10,98) ->
	#base_draconic_strong{id = 10,lv = 98,cost = [{255,36255095,564350}],add_attr = [{3,1372},{7,1372}]};

get_draconic_strong_info(10,99) ->
	#base_draconic_strong{id = 10,lv = 99,cost = [{255,36255095,592770}],add_attr = [{3,1386},{7,1386}]};

get_draconic_strong_info(10,100) ->
	#base_draconic_strong{id = 10,lv = 100,cost = [{255,36255095,622610}],add_attr = [{3,1400},{7,1400}]};

get_draconic_strong_info(11,0) ->
	#base_draconic_strong{id = 11,lv = 0,cost = [],add_attr = [{1,0},{2,0}]};

get_draconic_strong_info(11,1) ->
	#base_draconic_strong{id = 11,lv = 1,cost = [{255,36255095,1000}],add_attr = [{1,20},{2,405}]};

get_draconic_strong_info(11,2) ->
	#base_draconic_strong{id = 11,lv = 2,cost = [{255,36255095,1250}],add_attr = [{1,40},{2,810}]};

get_draconic_strong_info(11,3) ->
	#base_draconic_strong{id = 11,lv = 3,cost = [{255,36255095,1510}],add_attr = [{1,60},{2,1215}]};

get_draconic_strong_info(11,4) ->
	#base_draconic_strong{id = 11,lv = 4,cost = [{255,36255095,1790}],add_attr = [{1,80},{2,1620}]};

get_draconic_strong_info(11,5) ->
	#base_draconic_strong{id = 11,lv = 5,cost = [{255,36255095,2080}],add_attr = [{1,100},{2,2025}]};

get_draconic_strong_info(11,6) ->
	#base_draconic_strong{id = 11,lv = 6,cost = [{255,36255095,2380}],add_attr = [{1,120},{2,2430}]};

get_draconic_strong_info(11,7) ->
	#base_draconic_strong{id = 11,lv = 7,cost = [{255,36255095,2700}],add_attr = [{1,140},{2,2835}]};

get_draconic_strong_info(11,8) ->
	#base_draconic_strong{id = 11,lv = 8,cost = [{255,36255095,3040}],add_attr = [{1,160},{2,3240}]};

get_draconic_strong_info(11,9) ->
	#base_draconic_strong{id = 11,lv = 9,cost = [{255,36255095,3390}],add_attr = [{1,180},{2,3645}]};

get_draconic_strong_info(11,10) ->
	#base_draconic_strong{id = 11,lv = 10,cost = [{255,36255095,3760}],add_attr = [{1,200},{2,4050}]};

get_draconic_strong_info(11,11) ->
	#base_draconic_strong{id = 11,lv = 11,cost = [{255,36255095,4150}],add_attr = [{1,220},{2,4455}]};

get_draconic_strong_info(11,12) ->
	#base_draconic_strong{id = 11,lv = 12,cost = [{255,36255095,4560}],add_attr = [{1,240},{2,4860}]};

get_draconic_strong_info(11,13) ->
	#base_draconic_strong{id = 11,lv = 13,cost = [{255,36255095,4990}],add_attr = [{1,260},{2,5265}]};

get_draconic_strong_info(11,14) ->
	#base_draconic_strong{id = 11,lv = 14,cost = [{255,36255095,5440}],add_attr = [{1,280},{2,5670}]};

get_draconic_strong_info(11,15) ->
	#base_draconic_strong{id = 11,lv = 15,cost = [{255,36255095,5910}],add_attr = [{1,300},{2,6075}]};

get_draconic_strong_info(11,16) ->
	#base_draconic_strong{id = 11,lv = 16,cost = [{255,36255095,6410}],add_attr = [{1,320},{2,6480}]};

get_draconic_strong_info(11,17) ->
	#base_draconic_strong{id = 11,lv = 17,cost = [{255,36255095,6930}],add_attr = [{1,340},{2,6885}]};

get_draconic_strong_info(11,18) ->
	#base_draconic_strong{id = 11,lv = 18,cost = [{255,36255095,7480}],add_attr = [{1,360},{2,7290}]};

get_draconic_strong_info(11,19) ->
	#base_draconic_strong{id = 11,lv = 19,cost = [{255,36255095,8050}],add_attr = [{1,380},{2,7695}]};

get_draconic_strong_info(11,20) ->
	#base_draconic_strong{id = 11,lv = 20,cost = [{255,36255095,8650}],add_attr = [{1,400},{2,8100}]};

get_draconic_strong_info(11,21) ->
	#base_draconic_strong{id = 11,lv = 21,cost = [{255,36255095,9280}],add_attr = [{1,420},{2,8505}]};

get_draconic_strong_info(11,22) ->
	#base_draconic_strong{id = 11,lv = 22,cost = [{255,36255095,9940}],add_attr = [{1,440},{2,8910}]};

get_draconic_strong_info(11,23) ->
	#base_draconic_strong{id = 11,lv = 23,cost = [{255,36255095,10640}],add_attr = [{1,460},{2,9315}]};

get_draconic_strong_info(11,24) ->
	#base_draconic_strong{id = 11,lv = 24,cost = [{255,36255095,11370}],add_attr = [{1,480},{2,9720}]};

get_draconic_strong_info(11,25) ->
	#base_draconic_strong{id = 11,lv = 25,cost = [{255,36255095,12140}],add_attr = [{1,500},{2,10125}]};

get_draconic_strong_info(11,26) ->
	#base_draconic_strong{id = 11,lv = 26,cost = [{255,36255095,12950}],add_attr = [{1,520},{2,10530}]};

get_draconic_strong_info(11,27) ->
	#base_draconic_strong{id = 11,lv = 27,cost = [{255,36255095,13800}],add_attr = [{1,540},{2,10935}]};

get_draconic_strong_info(11,28) ->
	#base_draconic_strong{id = 11,lv = 28,cost = [{255,36255095,14690}],add_attr = [{1,560},{2,11340}]};

get_draconic_strong_info(11,29) ->
	#base_draconic_strong{id = 11,lv = 29,cost = [{255,36255095,15620}],add_attr = [{1,580},{2,11745}]};

get_draconic_strong_info(11,30) ->
	#base_draconic_strong{id = 11,lv = 30,cost = [{255,36255095,16600}],add_attr = [{1,600},{2,12150}]};

get_draconic_strong_info(11,31) ->
	#base_draconic_strong{id = 11,lv = 31,cost = [{255,36255095,17630}],add_attr = [{1,620},{2,12555}]};

get_draconic_strong_info(11,32) ->
	#base_draconic_strong{id = 11,lv = 32,cost = [{255,36255095,18710}],add_attr = [{1,640},{2,12960}]};

get_draconic_strong_info(11,33) ->
	#base_draconic_strong{id = 11,lv = 33,cost = [{255,36255095,19850}],add_attr = [{1,660},{2,13365}]};

get_draconic_strong_info(11,34) ->
	#base_draconic_strong{id = 11,lv = 34,cost = [{255,36255095,21040}],add_attr = [{1,680},{2,13770}]};

get_draconic_strong_info(11,35) ->
	#base_draconic_strong{id = 11,lv = 35,cost = [{255,36255095,22290}],add_attr = [{1,700},{2,14175}]};

get_draconic_strong_info(11,36) ->
	#base_draconic_strong{id = 11,lv = 36,cost = [{255,36255095,23600}],add_attr = [{1,720},{2,14580}]};

get_draconic_strong_info(11,37) ->
	#base_draconic_strong{id = 11,lv = 37,cost = [{255,36255095,24980}],add_attr = [{1,740},{2,14985}]};

get_draconic_strong_info(11,38) ->
	#base_draconic_strong{id = 11,lv = 38,cost = [{255,36255095,26430}],add_attr = [{1,760},{2,15390}]};

get_draconic_strong_info(11,39) ->
	#base_draconic_strong{id = 11,lv = 39,cost = [{255,36255095,27950}],add_attr = [{1,780},{2,15795}]};

get_draconic_strong_info(11,40) ->
	#base_draconic_strong{id = 11,lv = 40,cost = [{255,36255095,29550}],add_attr = [{1,800},{2,16200}]};

get_draconic_strong_info(11,41) ->
	#base_draconic_strong{id = 11,lv = 41,cost = [{255,36255095,31230}],add_attr = [{1,820},{2,16605}]};

get_draconic_strong_info(11,42) ->
	#base_draconic_strong{id = 11,lv = 42,cost = [{255,36255095,32990}],add_attr = [{1,840},{2,17010}]};

get_draconic_strong_info(11,43) ->
	#base_draconic_strong{id = 11,lv = 43,cost = [{255,36255095,34840}],add_attr = [{1,860},{2,17415}]};

get_draconic_strong_info(11,44) ->
	#base_draconic_strong{id = 11,lv = 44,cost = [{255,36255095,36780}],add_attr = [{1,880},{2,17820}]};

get_draconic_strong_info(11,45) ->
	#base_draconic_strong{id = 11,lv = 45,cost = [{255,36255095,38820}],add_attr = [{1,900},{2,18225}]};

get_draconic_strong_info(11,46) ->
	#base_draconic_strong{id = 11,lv = 46,cost = [{255,36255095,40960}],add_attr = [{1,920},{2,18630}]};

get_draconic_strong_info(11,47) ->
	#base_draconic_strong{id = 11,lv = 47,cost = [{255,36255095,43210}],add_attr = [{1,940},{2,19035}]};

get_draconic_strong_info(11,48) ->
	#base_draconic_strong{id = 11,lv = 48,cost = [{255,36255095,45570}],add_attr = [{1,960},{2,19440}]};

get_draconic_strong_info(11,49) ->
	#base_draconic_strong{id = 11,lv = 49,cost = [{255,36255095,48050}],add_attr = [{1,980},{2,19845}]};

get_draconic_strong_info(11,50) ->
	#base_draconic_strong{id = 11,lv = 50,cost = [{255,36255095,50650}],add_attr = [{1,1000},{2,20250}]};

get_draconic_strong_info(11,51) ->
	#base_draconic_strong{id = 11,lv = 51,cost = [{255,36255095,53380}],add_attr = [{1,1020},{2,20655}]};

get_draconic_strong_info(11,52) ->
	#base_draconic_strong{id = 11,lv = 52,cost = [{255,36255095,56250}],add_attr = [{1,1040},{2,21060}]};

get_draconic_strong_info(11,53) ->
	#base_draconic_strong{id = 11,lv = 53,cost = [{255,36255095,59260}],add_attr = [{1,1060},{2,21465}]};

get_draconic_strong_info(11,54) ->
	#base_draconic_strong{id = 11,lv = 54,cost = [{255,36255095,62420}],add_attr = [{1,1080},{2,21870}]};

get_draconic_strong_info(11,55) ->
	#base_draconic_strong{id = 11,lv = 55,cost = [{255,36255095,65740}],add_attr = [{1,1100},{2,22275}]};

get_draconic_strong_info(11,56) ->
	#base_draconic_strong{id = 11,lv = 56,cost = [{255,36255095,69230}],add_attr = [{1,1120},{2,22680}]};

get_draconic_strong_info(11,57) ->
	#base_draconic_strong{id = 11,lv = 57,cost = [{255,36255095,72890}],add_attr = [{1,1140},{2,23085}]};

get_draconic_strong_info(11,58) ->
	#base_draconic_strong{id = 11,lv = 58,cost = [{255,36255095,76730}],add_attr = [{1,1160},{2,23490}]};

get_draconic_strong_info(11,59) ->
	#base_draconic_strong{id = 11,lv = 59,cost = [{255,36255095,80770}],add_attr = [{1,1180},{2,23895}]};

get_draconic_strong_info(11,60) ->
	#base_draconic_strong{id = 11,lv = 60,cost = [{255,36255095,85010}],add_attr = [{1,1200},{2,24300}]};

get_draconic_strong_info(11,61) ->
	#base_draconic_strong{id = 11,lv = 61,cost = [{255,36255095,89460}],add_attr = [{1,1220},{2,24705}]};

get_draconic_strong_info(11,62) ->
	#base_draconic_strong{id = 11,lv = 62,cost = [{255,36255095,94130}],add_attr = [{1,1240},{2,25110}]};

get_draconic_strong_info(11,63) ->
	#base_draconic_strong{id = 11,lv = 63,cost = [{255,36255095,99040}],add_attr = [{1,1260},{2,25515}]};

get_draconic_strong_info(11,64) ->
	#base_draconic_strong{id = 11,lv = 64,cost = [{255,36255095,104190}],add_attr = [{1,1280},{2,25920}]};

get_draconic_strong_info(11,65) ->
	#base_draconic_strong{id = 11,lv = 65,cost = [{255,36255095,109600}],add_attr = [{1,1300},{2,26325}]};

get_draconic_strong_info(11,66) ->
	#base_draconic_strong{id = 11,lv = 66,cost = [{255,36255095,115280}],add_attr = [{1,1320},{2,26730}]};

get_draconic_strong_info(11,67) ->
	#base_draconic_strong{id = 11,lv = 67,cost = [{255,36255095,121240}],add_attr = [{1,1340},{2,27135}]};

get_draconic_strong_info(11,68) ->
	#base_draconic_strong{id = 11,lv = 68,cost = [{255,36255095,127500}],add_attr = [{1,1360},{2,27540}]};

get_draconic_strong_info(11,69) ->
	#base_draconic_strong{id = 11,lv = 69,cost = [{255,36255095,134080}],add_attr = [{1,1380},{2,27945}]};

get_draconic_strong_info(11,70) ->
	#base_draconic_strong{id = 11,lv = 70,cost = [{255,36255095,140980}],add_attr = [{1,1400},{2,28350}]};

get_draconic_strong_info(11,71) ->
	#base_draconic_strong{id = 11,lv = 71,cost = [{255,36255095,148230}],add_attr = [{1,1420},{2,28755}]};

get_draconic_strong_info(11,72) ->
	#base_draconic_strong{id = 11,lv = 72,cost = [{255,36255095,155840}],add_attr = [{1,1440},{2,29160}]};

get_draconic_strong_info(11,73) ->
	#base_draconic_strong{id = 11,lv = 73,cost = [{255,36255095,163830}],add_attr = [{1,1460},{2,29565}]};

get_draconic_strong_info(11,74) ->
	#base_draconic_strong{id = 11,lv = 74,cost = [{255,36255095,172220}],add_attr = [{1,1480},{2,29970}]};

get_draconic_strong_info(11,75) ->
	#base_draconic_strong{id = 11,lv = 75,cost = [{255,36255095,181030}],add_attr = [{1,1500},{2,30375}]};

get_draconic_strong_info(11,76) ->
	#base_draconic_strong{id = 11,lv = 76,cost = [{255,36255095,190280}],add_attr = [{1,1520},{2,30780}]};

get_draconic_strong_info(11,77) ->
	#base_draconic_strong{id = 11,lv = 77,cost = [{255,36255095,199990}],add_attr = [{1,1540},{2,31185}]};

get_draconic_strong_info(11,78) ->
	#base_draconic_strong{id = 11,lv = 78,cost = [{255,36255095,210190}],add_attr = [{1,1560},{2,31590}]};

get_draconic_strong_info(11,79) ->
	#base_draconic_strong{id = 11,lv = 79,cost = [{255,36255095,220900}],add_attr = [{1,1580},{2,31995}]};

get_draconic_strong_info(11,80) ->
	#base_draconic_strong{id = 11,lv = 80,cost = [{255,36255095,232150}],add_attr = [{1,1600},{2,32400}]};

get_draconic_strong_info(11,81) ->
	#base_draconic_strong{id = 11,lv = 81,cost = [{255,36255095,243960}],add_attr = [{1,1620},{2,32805}]};

get_draconic_strong_info(11,82) ->
	#base_draconic_strong{id = 11,lv = 82,cost = [{255,36255095,256360}],add_attr = [{1,1640},{2,33210}]};

get_draconic_strong_info(11,83) ->
	#base_draconic_strong{id = 11,lv = 83,cost = [{255,36255095,269380}],add_attr = [{1,1660},{2,33615}]};

get_draconic_strong_info(11,84) ->
	#base_draconic_strong{id = 11,lv = 84,cost = [{255,36255095,283050}],add_attr = [{1,1680},{2,34020}]};

get_draconic_strong_info(11,85) ->
	#base_draconic_strong{id = 11,lv = 85,cost = [{255,36255095,297400}],add_attr = [{1,1700},{2,34425}]};

get_draconic_strong_info(11,86) ->
	#base_draconic_strong{id = 11,lv = 86,cost = [{255,36255095,312470}],add_attr = [{1,1720},{2,34830}]};

get_draconic_strong_info(11,87) ->
	#base_draconic_strong{id = 11,lv = 87,cost = [{255,36255095,328290}],add_attr = [{1,1740},{2,35235}]};

get_draconic_strong_info(11,88) ->
	#base_draconic_strong{id = 11,lv = 88,cost = [{255,36255095,344900}],add_attr = [{1,1760},{2,35640}]};

get_draconic_strong_info(11,89) ->
	#base_draconic_strong{id = 11,lv = 89,cost = [{255,36255095,362350}],add_attr = [{1,1780},{2,36045}]};

get_draconic_strong_info(11,90) ->
	#base_draconic_strong{id = 11,lv = 90,cost = [{255,36255095,380670}],add_attr = [{1,1800},{2,36450}]};

get_draconic_strong_info(11,91) ->
	#base_draconic_strong{id = 11,lv = 91,cost = [{255,36255095,399900}],add_attr = [{1,1820},{2,36855}]};

get_draconic_strong_info(11,92) ->
	#base_draconic_strong{id = 11,lv = 92,cost = [{255,36255095,420100}],add_attr = [{1,1840},{2,37260}]};

get_draconic_strong_info(11,93) ->
	#base_draconic_strong{id = 11,lv = 93,cost = [{255,36255095,441310}],add_attr = [{1,1860},{2,37665}]};

get_draconic_strong_info(11,94) ->
	#base_draconic_strong{id = 11,lv = 94,cost = [{255,36255095,463580}],add_attr = [{1,1880},{2,38070}]};

get_draconic_strong_info(11,95) ->
	#base_draconic_strong{id = 11,lv = 95,cost = [{255,36255095,486960}],add_attr = [{1,1900},{2,38475}]};

get_draconic_strong_info(11,96) ->
	#base_draconic_strong{id = 11,lv = 96,cost = [{255,36255095,511510}],add_attr = [{1,1920},{2,38880}]};

get_draconic_strong_info(11,97) ->
	#base_draconic_strong{id = 11,lv = 97,cost = [{255,36255095,537290}],add_attr = [{1,1940},{2,39285}]};

get_draconic_strong_info(11,98) ->
	#base_draconic_strong{id = 11,lv = 98,cost = [{255,36255095,564350}],add_attr = [{1,1960},{2,39690}]};

get_draconic_strong_info(11,99) ->
	#base_draconic_strong{id = 11,lv = 99,cost = [{255,36255095,592770}],add_attr = [{1,1980},{2,40095}]};

get_draconic_strong_info(11,100) ->
	#base_draconic_strong{id = 11,lv = 100,cost = [{255,36255095,622610}],add_attr = [{1,2000},{2,40500}]};

get_draconic_strong_info(_Id,_Lv) ->
	[].


get_draconic_value(3) ->
[660];

get_draconic_value(_Id) ->
	[].

get_special_suit_info(1001) ->
	#base_special_suit{id = 1001,stage = 1,color = 4,attr = [{1,1000},{3,2000},{19,3000}],score = 500};

get_special_suit_info(1002) ->
	#base_special_suit{id = 1002,stage = 2,color = 4,attr = [{1,1100},{3,2100},{19,3100}],score = 600};

get_special_suit_info(1003) ->
	#base_special_suit{id = 1003,stage = 3,color = 4,attr = [{1,1200},{3,2200},{19,3200}],score = 700};

get_special_suit_info(1004) ->
	#base_special_suit{id = 1004,stage = 4,color = 4,attr = [{1,1300},{3,2300},{19,3300}],score = 800};

get_special_suit_info(1005) ->
	#base_special_suit{id = 1005,stage = 5,color = 4,attr = [{1,1400},{3,2400},{19,3400}],score = 900};

get_special_suit_info(1006) ->
	#base_special_suit{id = 1006,stage = 6,color = 4,attr = [{1,1500},{3,2500},{19,3500}],score = 1000};

get_special_suit_info(1007) ->
	#base_special_suit{id = 1007,stage = 7,color = 4,attr = [{1,1600},{3,2600},{19,3600}],score = 1100};

get_special_suit_info(1008) ->
	#base_special_suit{id = 1008,stage = 8,color = 4,attr = [{1,1700},{3,2700},{19,3700}],score = 1200};

get_special_suit_info(1009) ->
	#base_special_suit{id = 1009,stage = 9,color = 4,attr = [{1,1800},{3,2800},{19,3800}],score = 1300};

get_special_suit_info(1010) ->
	#base_special_suit{id = 1010,stage = 10,color = 4,attr = [{1,1900},{3,2900},{19,3900}],score = 1400};

get_special_suit_info(1011) ->
	#base_special_suit{id = 1011,stage = 11,color = 4,attr = [{1,2000},{3,3000},{19,4000}],score = 1500};

get_special_suit_info(1012) ->
	#base_special_suit{id = 1012,stage = 12,color = 4,attr = [{1,2100},{3,3100},{19,4100}],score = 1600};

get_special_suit_info(1013) ->
	#base_special_suit{id = 1013,stage = 13,color = 4,attr = [{1,2200},{3,3200},{19,4200}],score = 1700};

get_special_suit_info(1014) ->
	#base_special_suit{id = 1014,stage = 14,color = 4,attr = [{1,2300},{3,3300},{19,4300}],score = 1800};

get_special_suit_info(1015) ->
	#base_special_suit{id = 1015,stage = 15,color = 4,attr = [{1,2400},{3,3400},{19,4400}],score = 1900};

get_special_suit_info(1016) ->
	#base_special_suit{id = 1016,stage = 16,color = 4,attr = [{1,2500},{3,3500},{19,4500}],score = 2000};

get_special_suit_info(1101) ->
	#base_special_suit{id = 1101,stage = 1,color = 5,attr = [{1,2600},{3,3600},{19,4600}],score = 2100};

get_special_suit_info(1102) ->
	#base_special_suit{id = 1102,stage = 2,color = 5,attr = [{1,2700},{3,3700},{19,4700}],score = 2200};

get_special_suit_info(1103) ->
	#base_special_suit{id = 1103,stage = 3,color = 5,attr = [{1,2800},{3,3800},{19,4800}],score = 2300};

get_special_suit_info(1104) ->
	#base_special_suit{id = 1104,stage = 4,color = 5,attr = [{1,2900},{3,3900},{19,4900}],score = 2400};

get_special_suit_info(1105) ->
	#base_special_suit{id = 1105,stage = 5,color = 5,attr = [{1,3000},{3,4000},{19,5000}],score = 2500};

get_special_suit_info(1106) ->
	#base_special_suit{id = 1106,stage = 6,color = 5,attr = [{1,3100},{3,4100},{19,5100}],score = 2600};

get_special_suit_info(1107) ->
	#base_special_suit{id = 1107,stage = 7,color = 5,attr = [{1,3200},{3,4200},{19,5200}],score = 2700};

get_special_suit_info(1108) ->
	#base_special_suit{id = 1108,stage = 8,color = 5,attr = [{1,3300},{3,4300},{19,5300}],score = 2800};

get_special_suit_info(1109) ->
	#base_special_suit{id = 1109,stage = 9,color = 5,attr = [{1,3400},{3,4400},{19,5400}],score = 2900};

get_special_suit_info(1110) ->
	#base_special_suit{id = 1110,stage = 10,color = 5,attr = [{1,3500},{3,4500},{19,5500}],score = 3000};

get_special_suit_info(1111) ->
	#base_special_suit{id = 1111,stage = 11,color = 5,attr = [{1,3600},{3,4600},{19,5600}],score = 3100};

get_special_suit_info(1112) ->
	#base_special_suit{id = 1112,stage = 12,color = 5,attr = [{1,3700},{3,4700},{19,5700}],score = 3200};

get_special_suit_info(1113) ->
	#base_special_suit{id = 1113,stage = 13,color = 5,attr = [{1,3800},{3,4800},{19,5800}],score = 3300};

get_special_suit_info(1114) ->
	#base_special_suit{id = 1114,stage = 14,color = 5,attr = [{1,3900},{3,4900},{19,5900}],score = 3400};

get_special_suit_info(1115) ->
	#base_special_suit{id = 1115,stage = 15,color = 5,attr = [{1,4000},{3,5000},{19,6000}],score = 3500};

get_special_suit_info(1116) ->
	#base_special_suit{id = 1116,stage = 16,color = 5,attr = [{1,4100},{3,5100},{19,6100}],score = 3600};

get_special_suit_info(1201) ->
	#base_special_suit{id = 1201,stage = 1,color = 6,attr = [{1,4200},{3,5200},{19,6200}],score = 3700};

get_special_suit_info(1202) ->
	#base_special_suit{id = 1202,stage = 2,color = 6,attr = [{1,4300},{3,5300},{19,6300}],score = 3800};

get_special_suit_info(1203) ->
	#base_special_suit{id = 1203,stage = 3,color = 6,attr = [{1,4400},{3,5400},{19,6400}],score = 3900};

get_special_suit_info(1204) ->
	#base_special_suit{id = 1204,stage = 4,color = 6,attr = [{1,4500},{3,5500},{19,6500}],score = 4000};

get_special_suit_info(1205) ->
	#base_special_suit{id = 1205,stage = 5,color = 6,attr = [{1,4600},{3,5600},{19,6600}],score = 4100};

get_special_suit_info(1206) ->
	#base_special_suit{id = 1206,stage = 6,color = 6,attr = [{1,4700},{3,5700},{19,6700}],score = 4200};

get_special_suit_info(1207) ->
	#base_special_suit{id = 1207,stage = 7,color = 6,attr = [{1,4800},{3,5800},{19,6800}],score = 4300};

get_special_suit_info(1208) ->
	#base_special_suit{id = 1208,stage = 8,color = 6,attr = [{1,4900},{3,5900},{19,6900}],score = 4400};

get_special_suit_info(1209) ->
	#base_special_suit{id = 1209,stage = 9,color = 6,attr = [{1,5000},{3,6000},{19,7000}],score = 4500};

get_special_suit_info(1210) ->
	#base_special_suit{id = 1210,stage = 10,color = 6,attr = [{1,5100},{3,6100},{19,7100}],score = 4600};

get_special_suit_info(1211) ->
	#base_special_suit{id = 1211,stage = 11,color = 6,attr = [{1,5200},{3,6200},{19,7200}],score = 4700};

get_special_suit_info(1212) ->
	#base_special_suit{id = 1212,stage = 12,color = 6,attr = [{1,5300},{3,6300},{19,7300}],score = 4800};

get_special_suit_info(1213) ->
	#base_special_suit{id = 1213,stage = 13,color = 6,attr = [{1,5400},{3,6400},{19,7400}],score = 4900};

get_special_suit_info(1214) ->
	#base_special_suit{id = 1214,stage = 14,color = 6,attr = [{1,5500},{3,6500},{19,7500}],score = 5000};

get_special_suit_info(1215) ->
	#base_special_suit{id = 1215,stage = 15,color = 6,attr = [{1,5600},{3,6600},{19,7600}],score = 5100};

get_special_suit_info(1216) ->
	#base_special_suit{id = 1216,stage = 16,color = 6,attr = [{1,5700},{3,6700},{19,7700}],score = 5200};

get_special_suit_info(_Id) ->
	[].

get_special_suit_id(1,4) ->
[1001];

get_special_suit_id(1,5) ->
[1101];

get_special_suit_id(1,6) ->
[1201];

get_special_suit_id(2,4) ->
[1002];

get_special_suit_id(2,5) ->
[1102];

get_special_suit_id(2,6) ->
[1202];

get_special_suit_id(3,4) ->
[1003];

get_special_suit_id(3,5) ->
[1103];

get_special_suit_id(3,6) ->
[1203];

get_special_suit_id(4,4) ->
[1004];

get_special_suit_id(4,5) ->
[1104];

get_special_suit_id(4,6) ->
[1204];

get_special_suit_id(5,4) ->
[1005];

get_special_suit_id(5,5) ->
[1105];

get_special_suit_id(5,6) ->
[1205];

get_special_suit_id(6,4) ->
[1006];

get_special_suit_id(6,5) ->
[1106];

get_special_suit_id(6,6) ->
[1206];

get_special_suit_id(7,4) ->
[1007];

get_special_suit_id(7,5) ->
[1107];

get_special_suit_id(7,6) ->
[1207];

get_special_suit_id(8,4) ->
[1008];

get_special_suit_id(8,5) ->
[1108];

get_special_suit_id(8,6) ->
[1208];

get_special_suit_id(9,4) ->
[1009];

get_special_suit_id(9,5) ->
[1109];

get_special_suit_id(9,6) ->
[1209];

get_special_suit_id(10,4) ->
[1010];

get_special_suit_id(10,5) ->
[1110];

get_special_suit_id(10,6) ->
[1210];

get_special_suit_id(11,4) ->
[1011];

get_special_suit_id(11,5) ->
[1111];

get_special_suit_id(11,6) ->
[1211];

get_special_suit_id(12,4) ->
[1012];

get_special_suit_id(12,5) ->
[1112];

get_special_suit_id(12,6) ->
[1212];

get_special_suit_id(13,4) ->
[1013];

get_special_suit_id(13,5) ->
[1113];

get_special_suit_id(13,6) ->
[1213];

get_special_suit_id(14,4) ->
[1014];

get_special_suit_id(14,5) ->
[1114];

get_special_suit_id(14,6) ->
[1214];

get_special_suit_id(15,4) ->
[1015];

get_special_suit_id(15,5) ->
[1115];

get_special_suit_id(15,6) ->
[1215];

get_special_suit_id(16,4) ->
[1016];

get_special_suit_id(16,5) ->
[1116];

get_special_suit_id(16,6) ->
[1216];

get_special_suit_id(_Stage,_Color) ->
	[].

