%%%---------------------------------------
%%% module      : data_seal
%%% description : 圣印配置
%%%
%%%---------------------------------------
-module(data_seal).
-compile(export_all).
-include("seal.hrl").




get_seal_type(1) ->
1;


get_seal_type(2) ->
1;


get_seal_type(3) ->
1;


get_seal_type(4) ->
1;


get_seal_type(5) ->
1;


get_seal_type(6) ->
1;


get_seal_type(7) ->
2;


get_seal_type(8) ->
2;


get_seal_type(9) ->
2;


get_seal_type(10) ->
2;


get_seal_type(11) ->
3;

get_seal_type(_Id) ->
	[].

get_seal_equip_info(6001304) ->
	#base_seal_equip{id = 6001304,name = "力量魔之靴",pos = 1,stage = 4,color = 3,strong = 100,base_attr = [{4,151},{6,171}],extra_attr = [],suit = 0};

get_seal_equip_info(6001305) ->
	#base_seal_equip{id = 6001305,name = "愤怒魔之靴",pos = 1,stage = 5,color = 3,strong = 100,base_attr = [{4,259},{6,292}],extra_attr = [],suit = 0};

get_seal_equip_info(6001306) ->
	#base_seal_equip{id = 6001306,name = "征服魔之靴",pos = 1,stage = 6,color = 3,strong = 100,base_attr = [{4,366},{6,411}],extra_attr = [],suit = 0};

get_seal_equip_info(6001307) ->
	#base_seal_equip{id = 6001307,name = "无畏魔之靴",pos = 1,stage = 7,color = 3,strong = 100,base_attr = [{4,522},{6,587}],extra_attr = [],suit = 0};

get_seal_equip_info(6001308) ->
	#base_seal_equip{id = 6001308,name = "冲锋魔之靴",pos = 1,stage = 8,color = 3,strong = 100,base_attr = [{4,885},{6,997}],extra_attr = [],suit = 0};

get_seal_equip_info(6001309) ->
	#base_seal_equip{id = 6001309,name = "卓越魔之靴",pos = 1,stage = 9,color = 3,strong = 100,base_attr = [{4,964},{6,1086}],extra_attr = [],suit = 0};

get_seal_equip_info(6001310) ->
	#base_seal_equip{id = 6001310,name = "屠夫魔之靴",pos = 1,stage = 10,color = 3,strong = 100,base_attr = [{4,1332},{6,1500}],extra_attr = [],suit = 0};

get_seal_equip_info(6001311) ->
	#base_seal_equip{id = 6001311,name = "野蛮魔之靴",pos = 1,stage = 11,color = 3,strong = 100,base_attr = [{4,1497},{6,1684}],extra_attr = [],suit = 0};

get_seal_equip_info(6001312) ->
	#base_seal_equip{id = 6001312,name = "致命魔之靴",pos = 1,stage = 12,color = 3,strong = 100,base_attr = [{4,1874},{6,2110}],extra_attr = [],suit = 0};

get_seal_equip_info(6001313) ->
	#base_seal_equip{id = 6001313,name = "狂怒魔之靴",pos = 1,stage = 13,color = 3,strong = 100,base_attr = [{4,2042},{6,2298}],extra_attr = [],suit = 0};

get_seal_equip_info(6001314) ->
	#base_seal_equip{id = 6001314,name = "无情魔之靴",pos = 1,stage = 14,color = 3,strong = 100,base_attr = [{4,2434},{6,2739}],extra_attr = [],suit = 0};

get_seal_equip_info(6001315) ->
	#base_seal_equip{id = 6001315,name = "暴怒魔之靴",pos = 1,stage = 15,color = 3,strong = 100,base_attr = [{4,2604},{6,2929}],extra_attr = [],suit = 0};

get_seal_equip_info(6001316) ->
	#base_seal_equip{id = 6001316,name = "残忍魔之靴",pos = 1,stage = 16,color = 3,strong = 100,base_attr = [{4,3002},{6,3380}],extra_attr = [],suit = 0};

get_seal_equip_info(6001317) ->
	#base_seal_equip{id = 6001317,name = "冷酷魔之靴",pos = 1,stage = 17,color = 3,strong = 100,base_attr = [{4,3177},{6,3574}],extra_attr = [],suit = 0};

get_seal_equip_info(6001318) ->
	#base_seal_equip{id = 6001318,name = "利刃魔之靴",pos = 1,stage = 18,color = 3,strong = 100,base_attr = [{4,3581},{6,4030}],extra_attr = [],suit = 0};

get_seal_equip_info(6001404) ->
	#base_seal_equip{id = 6001404,name = "幽魅魔之靴",pos = 1,stage = 4,color = 4,strong = 100,base_attr = [{4,268},{6,302}],extra_attr = [],suit = 4040};

get_seal_equip_info(6001405) ->
	#base_seal_equip{id = 6001405,name = "复仇魔之靴",pos = 1,stage = 5,color = 4,strong = 100,base_attr = [{4,461},{6,518}],extra_attr = [],suit = 4050};

get_seal_equip_info(6001406) ->
	#base_seal_equip{id = 6001406,name = "毁灭魔之靴",pos = 1,stage = 6,color = 4,strong = 100,base_attr = [{4,651},{6,731}],extra_attr = [],suit = 4060};

get_seal_equip_info(6001407) ->
	#base_seal_equip{id = 6001407,name = "灾变魔之靴",pos = 1,stage = 7,color = 4,strong = 100,base_attr = [{4,930},{6,1045}],extra_attr = [],suit = 4070};

get_seal_equip_info(6001408) ->
	#base_seal_equip{id = 6001408,name = "恶毒魔之靴",pos = 1,stage = 8,color = 4,strong = 100,base_attr = [{4,1575},{6,1770}],extra_attr = [],suit = 4080};

get_seal_equip_info(6001409) ->
	#base_seal_equip{id = 6001409,name = "腐蚀魔之靴",pos = 1,stage = 9,color = 4,strong = 100,base_attr = [{4,1715},{6,1928}],extra_attr = [],suit = 4090};

get_seal_equip_info(6001410) ->
	#base_seal_equip{id = 6001410,name = "瘟疫魔之靴",pos = 1,stage = 10,color = 4,strong = 100,base_attr = [{4,2344},{6,2638}],extra_attr = [],suit = 4100};

get_seal_equip_info(6001411) ->
	#base_seal_equip{id = 6001411,name = "无间魔之靴",pos = 1,stage = 11,color = 4,strong = 100,base_attr = [{4,2680},{6,3015}],extra_attr = [],suit = 4110};

get_seal_equip_info(6001412) ->
	#base_seal_equip{id = 6001412,name = "虚空魔之靴",pos = 1,stage = 12,color = 4,strong = 100,base_attr = [{4,3399},{6,3825}],extra_attr = [],suit = 4120};

get_seal_equip_info(6001413) ->
	#base_seal_equip{id = 6001413,name = "双煞魔之靴",pos = 1,stage = 13,color = 4,strong = 100,base_attr = [{4,3796},{6,4270}],extra_attr = [],suit = 4130};

get_seal_equip_info(6001414) ->
	#base_seal_equip{id = 6001414,name = "坟冢魔之靴",pos = 1,stage = 14,color = 4,strong = 100,base_attr = [{4,4635},{6,5214}],extra_attr = [],suit = 4140};

get_seal_equip_info(6001415) ->
	#base_seal_equip{id = 6001415,name = "梦魇魔之靴",pos = 1,stage = 15,color = 4,strong = 100,base_attr = [{4,5092},{6,5728}],extra_attr = [],suit = 4150};

get_seal_equip_info(6001416) ->
	#base_seal_equip{id = 6001416,name = "碧魔魔之靴",pos = 1,stage = 16,color = 4,strong = 100,base_attr = [{4,6051},{6,6807}],extra_attr = [],suit = 4160};

get_seal_equip_info(6001417) ->
	#base_seal_equip{id = 6001417,name = "炼狱魔之靴",pos = 1,stage = 17,color = 4,strong = 100,base_attr = [{4,6566},{6,7387}],extra_attr = [],suit = 4170};

get_seal_equip_info(6001418) ->
	#base_seal_equip{id = 6001418,name = "吞天魔之靴",pos = 1,stage = 18,color = 4,strong = 100,base_attr = [{4,7645},{6,8601}],extra_attr = [],suit = 4180};

get_seal_equip_info(6001507) ->
	#base_seal_equip{id = 6001507,name = "烈阳魔之靴",pos = 1,stage = 7,color = 5,strong = 100,base_attr = [{4,2294},{6,2582}],extra_attr = [],suit = 5070};

get_seal_equip_info(6001508) ->
	#base_seal_equip{id = 6001508,name = "清秋魔之靴",pos = 1,stage = 8,color = 5,strong = 100,base_attr = [{4,3040},{6,3419}],extra_attr = [],suit = 5080};

get_seal_equip_info(6001509) ->
	#base_seal_equip{id = 6001509,name = "北辰魔之靴",pos = 1,stage = 9,color = 5,strong = 100,base_attr = [{4,3184},{6,3581}],extra_attr = [],suit = 5090};

get_seal_equip_info(6001510) ->
	#base_seal_equip{id = 6001510,name = "弦风魔之靴",pos = 1,stage = 10,color = 5,strong = 100,base_attr = [{4,4037},{6,4543}],extra_attr = [],suit = 5100};

get_seal_equip_info(6001511) ->
	#base_seal_equip{id = 6001511,name = "水月魔之靴",pos = 1,stage = 11,color = 5,strong = 100,base_attr = [{4,4507},{6,5071}],extra_attr = [],suit = 5110};

get_seal_equip_info(6001512) ->
	#base_seal_equip{id = 6001512,name = "熔火魔之靴",pos = 1,stage = 12,color = 5,strong = 100,base_attr = [{4,5504},{6,6193}],extra_attr = [],suit = 5120};

get_seal_equip_info(6001513) ->
	#base_seal_equip{id = 6001513,name = "幽泣魔之靴",pos = 1,stage = 13,color = 5,strong = 100,base_attr = [{4,6046},{6,6802}],extra_attr = [],suit = 5130};

get_seal_equip_info(6001514) ->
	#base_seal_equip{id = 6001514,name = "永夜魔之靴",pos = 1,stage = 14,color = 5,strong = 100,base_attr = [{4,7184},{6,8084}],extra_attr = [],suit = 5140};

get_seal_equip_info(6001515) ->
	#base_seal_equip{id = 6001515,name = "荣光魔之靴",pos = 1,stage = 15,color = 5,strong = 100,base_attr = [{4,7797},{6,8773}],extra_attr = [],suit = 5150};

get_seal_equip_info(6001516) ->
	#base_seal_equip{id = 6001516,name = "千锻魔之靴",pos = 1,stage = 16,color = 5,strong = 100,base_attr = [{4,9078},{6,10214}],extra_attr = [],suit = 5160};

get_seal_equip_info(6001517) ->
	#base_seal_equip{id = 6001517,name = "琉璃魔之靴",pos = 1,stage = 17,color = 5,strong = 100,base_attr = [{4,9692},{6,10903}],extra_attr = [],suit = 5170};

get_seal_equip_info(6001518) ->
	#base_seal_equip{id = 6001518,name = "织木魔之靴",pos = 1,stage = 18,color = 5,strong = 100,base_attr = [{4,10971},{6,12344}],extra_attr = [],suit = 5180};

get_seal_equip_info(6001608) ->
	#base_seal_equip{id = 6001608,name = "暗灭魔之靴",pos = 1,stage = 8,color = 7,strong = 100,base_attr = [{4,3818},{6,4295}],extra_attr = [],suit = 6080};

get_seal_equip_info(6001609) ->
	#base_seal_equip{id = 6001609,name = "梦长魔之靴",pos = 1,stage = 9,color = 7,strong = 100,base_attr = [{4,4271},{6,4805}],extra_attr = [],suit = 6090};

get_seal_equip_info(6001610) ->
	#base_seal_equip{id = 6001610,name = "御空魔之靴",pos = 1,stage = 10,color = 7,strong = 100,base_attr = [{4,4692},{6,5278}],extra_attr = [],suit = 6100};

get_seal_equip_info(6001611) ->
	#base_seal_equip{id = 6001611,name = "逸尘魔之靴",pos = 1,stage = 11,color = 7,strong = 100,base_attr = [{4,5575},{6,6274}],extra_attr = [],suit = 6110};

get_seal_equip_info(6001612) ->
	#base_seal_equip{id = 6001612,name = "天狼魔之靴",pos = 1,stage = 12,color = 7,strong = 100,base_attr = [{4,6051},{6,6807}],extra_attr = [],suit = 6120};

get_seal_equip_info(6001613) ->
	#base_seal_equip{id = 6001613,name = "天音魔之靴",pos = 1,stage = 13,color = 7,strong = 100,base_attr = [{4,7045},{6,7926}],extra_attr = [],suit = 6130};

get_seal_equip_info(6001614) ->
	#base_seal_equip{id = 6001614,name = "天舞魔之靴",pos = 1,stage = 14,color = 7,strong = 100,base_attr = [{4,7520},{6,8460}],extra_attr = [],suit = 6140};

get_seal_equip_info(6001615) ->
	#base_seal_equip{id = 6001615,name = "天琊魔之靴",pos = 1,stage = 15,color = 7,strong = 100,base_attr = [{4,8513},{6,9579}],extra_attr = [],suit = 6150};

get_seal_equip_info(6001616) ->
	#base_seal_equip{id = 6001616,name = "天罚魔之靴",pos = 1,stage = 16,color = 7,strong = 100,base_attr = [{4,11884},{6,13372}],extra_attr = [],suit = 6160};

get_seal_equip_info(6002304) ->
	#base_seal_equip{id = 6002304,name = "力量魔之盔",pos = 2,stage = 4,color = 3,strong = 100,base_attr = [{2,3024},{6,171}],extra_attr = [],suit = 0};

get_seal_equip_info(6002305) ->
	#base_seal_equip{id = 6002305,name = "愤怒魔之盔",pos = 2,stage = 5,color = 3,strong = 100,base_attr = [{2,5184},{6,292}],extra_attr = [],suit = 0};

get_seal_equip_info(6002306) ->
	#base_seal_equip{id = 6002306,name = "征服魔之盔",pos = 2,stage = 6,color = 3,strong = 100,base_attr = [{2,7309},{6,411}],extra_attr = [],suit = 0};

get_seal_equip_info(6002307) ->
	#base_seal_equip{id = 6002307,name = "无畏魔之盔",pos = 2,stage = 7,color = 3,strong = 100,base_attr = [{2,10445},{6,587}],extra_attr = [],suit = 0};

get_seal_equip_info(6002308) ->
	#base_seal_equip{id = 6002308,name = "冲锋魔之盔",pos = 2,stage = 8,color = 3,strong = 100,base_attr = [{2,17707},{6,997}],extra_attr = [],suit = 0};

get_seal_equip_info(6002309) ->
	#base_seal_equip{id = 6002309,name = "卓越魔之盔",pos = 2,stage = 9,color = 3,strong = 100,base_attr = [{2,19289},{6,1086}],extra_attr = [],suit = 0};

get_seal_equip_info(6002310) ->
	#base_seal_equip{id = 6002310,name = "屠夫魔之盔",pos = 2,stage = 10,color = 3,strong = 100,base_attr = [{2,26651},{6,1500}],extra_attr = [],suit = 0};

get_seal_equip_info(6002311) ->
	#base_seal_equip{id = 6002311,name = "野蛮魔之盔",pos = 2,stage = 11,color = 3,strong = 100,base_attr = [{2,29922},{6,1684}],extra_attr = [],suit = 0};

get_seal_equip_info(6002312) ->
	#base_seal_equip{id = 6002312,name = "致命魔之盔",pos = 2,stage = 12,color = 3,strong = 100,base_attr = [{2,37488},{6,2110}],extra_attr = [],suit = 0};

get_seal_equip_info(6002313) ->
	#base_seal_equip{id = 6002313,name = "狂怒魔之盔",pos = 2,stage = 13,color = 3,strong = 100,base_attr = [{2,40828},{6,2298}],extra_attr = [],suit = 0};

get_seal_equip_info(6002314) ->
	#base_seal_equip{id = 6002314,name = "无情魔之盔",pos = 2,stage = 14,color = 3,strong = 100,base_attr = [{2,48666},{6,2739}],extra_attr = [],suit = 0};

get_seal_equip_info(6002315) ->
	#base_seal_equip{id = 6002315,name = "暴怒魔之盔",pos = 2,stage = 15,color = 3,strong = 100,base_attr = [{2,52074},{6,2929}],extra_attr = [],suit = 0};

get_seal_equip_info(6002316) ->
	#base_seal_equip{id = 6002316,name = "残忍魔之盔",pos = 2,stage = 16,color = 3,strong = 100,base_attr = [{2,60049},{6,3380}],extra_attr = [],suit = 0};

get_seal_equip_info(6002317) ->
	#base_seal_equip{id = 6002317,name = "冷酷魔之盔",pos = 2,stage = 17,color = 3,strong = 100,base_attr = [{2,63525},{6,3574}],extra_attr = [],suit = 0};

get_seal_equip_info(6002318) ->
	#base_seal_equip{id = 6002318,name = "利刃魔之盔",pos = 2,stage = 18,color = 3,strong = 100,base_attr = [{2,71636},{6,4030}],extra_attr = [],suit = 0};

get_seal_equip_info(6002404) ->
	#base_seal_equip{id = 6002404,name = "幽魅魔之盔",pos = 2,stage = 4,color = 4,strong = 100,base_attr = [{2,5368},{6,302}],extra_attr = [],suit = 4040};

get_seal_equip_info(6002405) ->
	#base_seal_equip{id = 6002405,name = "复仇魔之盔",pos = 2,stage = 5,color = 4,strong = 100,base_attr = [{2,9216},{6,518}],extra_attr = [],suit = 4050};

get_seal_equip_info(6002406) ->
	#base_seal_equip{id = 6002406,name = "毁灭魔之盔",pos = 2,stage = 6,color = 4,strong = 100,base_attr = [{2,13002},{6,731}],extra_attr = [],suit = 4060};

get_seal_equip_info(6002407) ->
	#base_seal_equip{id = 6002407,name = "灾变魔之盔",pos = 2,stage = 7,color = 4,strong = 100,base_attr = [{2,18576},{6,1045}],extra_attr = [],suit = 4070};

get_seal_equip_info(6002408) ->
	#base_seal_equip{id = 6002408,name = "恶毒魔之盔",pos = 2,stage = 8,color = 4,strong = 100,base_attr = [{2,31487},{6,1770}],extra_attr = [],suit = 4080};

get_seal_equip_info(6002409) ->
	#base_seal_equip{id = 6002409,name = "腐蚀魔之盔",pos = 2,stage = 9,color = 4,strong = 100,base_attr = [{2,34299},{6,1928}],extra_attr = [],suit = 4090};

get_seal_equip_info(6002410) ->
	#base_seal_equip{id = 6002410,name = "瘟疫魔之盔",pos = 2,stage = 10,color = 4,strong = 100,base_attr = [{2,46891},{6,2638}],extra_attr = [],suit = 4100};

get_seal_equip_info(6002411) ->
	#base_seal_equip{id = 6002411,name = "无间魔之盔",pos = 2,stage = 11,color = 4,strong = 100,base_attr = [{2,53605},{6,3015}],extra_attr = [],suit = 4110};

get_seal_equip_info(6002412) ->
	#base_seal_equip{id = 6002412,name = "虚空魔之盔",pos = 2,stage = 12,color = 4,strong = 100,base_attr = [{2,67997},{6,3825}],extra_attr = [],suit = 4120};

get_seal_equip_info(6002413) ->
	#base_seal_equip{id = 6002413,name = "双煞魔之盔",pos = 2,stage = 13,color = 4,strong = 100,base_attr = [{2,75910},{6,4270}],extra_attr = [],suit = 4130};

get_seal_equip_info(6002414) ->
	#base_seal_equip{id = 6002414,name = "坟冢魔之盔",pos = 2,stage = 14,color = 4,strong = 100,base_attr = [{2,92700},{6,5214}],extra_attr = [],suit = 4140};

get_seal_equip_info(6002415) ->
	#base_seal_equip{id = 6002415,name = "梦魇魔之盔",pos = 2,stage = 15,color = 4,strong = 100,base_attr = [{2,101815},{6,5728}],extra_attr = [],suit = 4150};

get_seal_equip_info(6002416) ->
	#base_seal_equip{id = 6002416,name = "碧魔魔之盔",pos = 2,stage = 16,color = 4,strong = 100,base_attr = [{2,121004},{6,6807}],extra_attr = [],suit = 4160};

get_seal_equip_info(6002417) ->
	#base_seal_equip{id = 6002417,name = "炼狱魔之盔",pos = 2,stage = 17,color = 4,strong = 100,base_attr = [{2,131316},{6,7387}],extra_attr = [],suit = 4170};

get_seal_equip_info(6002418) ->
	#base_seal_equip{id = 6002418,name = "吞天魔之盔",pos = 2,stage = 18,color = 4,strong = 100,base_attr = [{2,152903},{6,8601}],extra_attr = [],suit = 4180};

get_seal_equip_info(6002507) ->
	#base_seal_equip{id = 6002507,name = "烈阳魔之盔",pos = 2,stage = 7,color = 5,strong = 100,base_attr = [{2,45891},{6,2582}],extra_attr = [],suit = 5070};

get_seal_equip_info(6002508) ->
	#base_seal_equip{id = 6002508,name = "清秋魔之盔",pos = 2,stage = 8,color = 5,strong = 100,base_attr = [{2,60780},{6,3419}],extra_attr = [],suit = 5080};

get_seal_equip_info(6002509) ->
	#base_seal_equip{id = 6002509,name = "北辰魔之盔",pos = 2,stage = 9,color = 5,strong = 100,base_attr = [{2,63657},{6,3581}],extra_attr = [],suit = 5090};

get_seal_equip_info(6002510) ->
	#base_seal_equip{id = 6002510,name = "弦风魔之盔",pos = 2,stage = 10,color = 5,strong = 100,base_attr = [{2,80745},{6,4543}],extra_attr = [],suit = 5100};

get_seal_equip_info(6002511) ->
	#base_seal_equip{id = 6002511,name = "水月魔之盔",pos = 2,stage = 11,color = 5,strong = 100,base_attr = [{2,90144},{6,5071}],extra_attr = [],suit = 5110};

get_seal_equip_info(6002512) ->
	#base_seal_equip{id = 6002512,name = "熔火魔之盔",pos = 2,stage = 12,color = 5,strong = 100,base_attr = [{2,110083},{6,6193}],extra_attr = [],suit = 5120};

get_seal_equip_info(6002513) ->
	#base_seal_equip{id = 6002513,name = "幽泣魔之盔",pos = 2,stage = 13,color = 5,strong = 100,base_attr = [{2,120904},{6,6802}],extra_attr = [],suit = 5130};

get_seal_equip_info(6002514) ->
	#base_seal_equip{id = 6002514,name = "永夜魔之盔",pos = 2,stage = 14,color = 5,strong = 100,base_attr = [{2,143691},{6,8084}],extra_attr = [],suit = 5140};

get_seal_equip_info(6002515) ->
	#base_seal_equip{id = 6002515,name = "荣光魔之盔",pos = 2,stage = 15,color = 5,strong = 100,base_attr = [{2,155937},{6,8773}],extra_attr = [],suit = 5150};

get_seal_equip_info(6002516) ->
	#base_seal_equip{id = 6002516,name = "千锻魔之盔",pos = 2,stage = 16,color = 5,strong = 100,base_attr = [{2,181573},{6,10214}],extra_attr = [],suit = 5160};

get_seal_equip_info(6002517) ->
	#base_seal_equip{id = 6002517,name = "琉璃魔之盔",pos = 2,stage = 17,color = 5,strong = 100,base_attr = [{2,193819},{6,10903}],extra_attr = [],suit = 5170};

get_seal_equip_info(6002518) ->
	#base_seal_equip{id = 6002518,name = "织木魔之盔",pos = 2,stage = 18,color = 5,strong = 100,base_attr = [{2,219454},{6,12344}],extra_attr = [],suit = 5180};

get_seal_equip_info(6002608) ->
	#base_seal_equip{id = 6002608,name = "暗灭魔之盔",pos = 2,stage = 8,color = 7,strong = 100,base_attr = [{2,76356},{6,4295}],extra_attr = [],suit = 6080};

get_seal_equip_info(6002609) ->
	#base_seal_equip{id = 6002609,name = "梦长魔之盔",pos = 2,stage = 9,color = 7,strong = 100,base_attr = [{2,85424},{6,4805}],extra_attr = [],suit = 6090};

get_seal_equip_info(6002610) ->
	#base_seal_equip{id = 6002610,name = "御空魔之盔",pos = 2,stage = 10,color = 7,strong = 100,base_attr = [{2,93822},{6,5278}],extra_attr = [],suit = 6100};

get_seal_equip_info(6002611) ->
	#base_seal_equip{id = 6002611,name = "逸尘魔之盔",pos = 2,stage = 11,color = 7,strong = 100,base_attr = [{2,111504},{6,6274}],extra_attr = [],suit = 6110};

get_seal_equip_info(6002612) ->
	#base_seal_equip{id = 6002612,name = "天狼魔之盔",pos = 2,stage = 12,color = 7,strong = 100,base_attr = [{2,121008},{6,6807}],extra_attr = [],suit = 6120};

get_seal_equip_info(6002613) ->
	#base_seal_equip{id = 6002613,name = "天音魔之盔",pos = 2,stage = 13,color = 7,strong = 100,base_attr = [{2,140901},{6,7926}],extra_attr = [],suit = 6130};

get_seal_equip_info(6002614) ->
	#base_seal_equip{id = 6002614,name = "天舞魔之盔",pos = 2,stage = 14,color = 7,strong = 100,base_attr = [{2,150404},{6,8460}],extra_attr = [],suit = 6140};

get_seal_equip_info(6002615) ->
	#base_seal_equip{id = 6002615,name = "天琊魔之盔",pos = 2,stage = 15,color = 7,strong = 100,base_attr = [{2,170296},{6,9579}],extra_attr = [],suit = 6150};

get_seal_equip_info(6002616) ->
	#base_seal_equip{id = 6002616,name = "天罚魔之盔",pos = 2,stage = 16,color = 7,strong = 100,base_attr = [{2,237736},{6,13372}],extra_attr = [],suit = 6160};

get_seal_equip_info(6003304) ->
	#base_seal_equip{id = 6003304,name = "力量魔之裤",pos = 3,stage = 4,color = 3,strong = 100,base_attr = [{2,3024},{4,171}],extra_attr = [],suit = 0};

get_seal_equip_info(6003305) ->
	#base_seal_equip{id = 6003305,name = "愤怒魔之裤",pos = 3,stage = 5,color = 3,strong = 100,base_attr = [{2,5184},{4,292}],extra_attr = [],suit = 0};

get_seal_equip_info(6003306) ->
	#base_seal_equip{id = 6003306,name = "征服魔之裤",pos = 3,stage = 6,color = 3,strong = 100,base_attr = [{2,7309},{4,411}],extra_attr = [],suit = 0};

get_seal_equip_info(6003307) ->
	#base_seal_equip{id = 6003307,name = "无畏魔之裤",pos = 3,stage = 7,color = 3,strong = 100,base_attr = [{2,10445},{4,587}],extra_attr = [],suit = 0};

get_seal_equip_info(6003308) ->
	#base_seal_equip{id = 6003308,name = "冲锋魔之裤",pos = 3,stage = 8,color = 3,strong = 100,base_attr = [{2,17707},{4,997}],extra_attr = [],suit = 0};

get_seal_equip_info(6003309) ->
	#base_seal_equip{id = 6003309,name = "卓越魔之裤",pos = 3,stage = 9,color = 3,strong = 100,base_attr = [{2,19289},{4,1086}],extra_attr = [],suit = 0};

get_seal_equip_info(6003310) ->
	#base_seal_equip{id = 6003310,name = "屠夫魔之裤",pos = 3,stage = 10,color = 3,strong = 100,base_attr = [{2,26651},{4,1500}],extra_attr = [],suit = 0};

get_seal_equip_info(6003311) ->
	#base_seal_equip{id = 6003311,name = "野蛮魔之裤",pos = 3,stage = 11,color = 3,strong = 100,base_attr = [{2,29922},{4,1684}],extra_attr = [],suit = 0};

get_seal_equip_info(6003312) ->
	#base_seal_equip{id = 6003312,name = "致命魔之裤",pos = 3,stage = 12,color = 3,strong = 100,base_attr = [{2,37488},{4,2110}],extra_attr = [],suit = 0};

get_seal_equip_info(6003313) ->
	#base_seal_equip{id = 6003313,name = "狂怒魔之裤",pos = 3,stage = 13,color = 3,strong = 100,base_attr = [{2,40828},{4,2298}],extra_attr = [],suit = 0};

get_seal_equip_info(6003314) ->
	#base_seal_equip{id = 6003314,name = "无情魔之裤",pos = 3,stage = 14,color = 3,strong = 100,base_attr = [{2,48666},{4,2739}],extra_attr = [],suit = 0};

get_seal_equip_info(6003315) ->
	#base_seal_equip{id = 6003315,name = "暴怒魔之裤",pos = 3,stage = 15,color = 3,strong = 100,base_attr = [{2,52074},{4,2929}],extra_attr = [],suit = 0};

get_seal_equip_info(6003316) ->
	#base_seal_equip{id = 6003316,name = "残忍魔之裤",pos = 3,stage = 16,color = 3,strong = 100,base_attr = [{2,60049},{4,3380}],extra_attr = [],suit = 0};

get_seal_equip_info(6003317) ->
	#base_seal_equip{id = 6003317,name = "冷酷魔之裤",pos = 3,stage = 17,color = 3,strong = 100,base_attr = [{2,63525},{4,3574}],extra_attr = [],suit = 0};

get_seal_equip_info(6003318) ->
	#base_seal_equip{id = 6003318,name = "利刃魔之裤",pos = 3,stage = 18,color = 3,strong = 100,base_attr = [{2,71636},{4,4030}],extra_attr = [],suit = 0};

get_seal_equip_info(6003404) ->
	#base_seal_equip{id = 6003404,name = "幽魅魔之裤",pos = 3,stage = 4,color = 4,strong = 100,base_attr = [{2,5368},{4,302}],extra_attr = [],suit = 4040};

get_seal_equip_info(6003405) ->
	#base_seal_equip{id = 6003405,name = "复仇魔之裤",pos = 3,stage = 5,color = 4,strong = 100,base_attr = [{2,9216},{4,518}],extra_attr = [],suit = 4050};

get_seal_equip_info(6003406) ->
	#base_seal_equip{id = 6003406,name = "毁灭魔之裤",pos = 3,stage = 6,color = 4,strong = 100,base_attr = [{2,13002},{4,731}],extra_attr = [],suit = 4060};

get_seal_equip_info(6003407) ->
	#base_seal_equip{id = 6003407,name = "灾变魔之裤",pos = 3,stage = 7,color = 4,strong = 100,base_attr = [{2,18576},{4,1045}],extra_attr = [],suit = 4070};

get_seal_equip_info(6003408) ->
	#base_seal_equip{id = 6003408,name = "恶毒魔之裤",pos = 3,stage = 8,color = 4,strong = 100,base_attr = [{2,31487},{4,1770}],extra_attr = [],suit = 4080};

get_seal_equip_info(6003409) ->
	#base_seal_equip{id = 6003409,name = "腐蚀魔之裤",pos = 3,stage = 9,color = 4,strong = 100,base_attr = [{2,34299},{4,1928}],extra_attr = [],suit = 4090};

get_seal_equip_info(6003410) ->
	#base_seal_equip{id = 6003410,name = "瘟疫魔之裤",pos = 3,stage = 10,color = 4,strong = 100,base_attr = [{2,46891},{4,2638}],extra_attr = [],suit = 4100};

get_seal_equip_info(6003411) ->
	#base_seal_equip{id = 6003411,name = "无间魔之裤",pos = 3,stage = 11,color = 4,strong = 100,base_attr = [{2,53605},{4,3015}],extra_attr = [],suit = 4110};

get_seal_equip_info(6003412) ->
	#base_seal_equip{id = 6003412,name = "虚空魔之裤",pos = 3,stage = 12,color = 4,strong = 100,base_attr = [{2,67997},{4,3825}],extra_attr = [],suit = 4120};

get_seal_equip_info(6003413) ->
	#base_seal_equip{id = 6003413,name = "双煞魔之裤",pos = 3,stage = 13,color = 4,strong = 100,base_attr = [{2,75910},{4,4270}],extra_attr = [],suit = 4130};

get_seal_equip_info(6003414) ->
	#base_seal_equip{id = 6003414,name = "坟冢魔之裤",pos = 3,stage = 14,color = 4,strong = 100,base_attr = [{2,92700},{4,5214}],extra_attr = [],suit = 4140};

get_seal_equip_info(6003415) ->
	#base_seal_equip{id = 6003415,name = "梦魇魔之裤",pos = 3,stage = 15,color = 4,strong = 100,base_attr = [{2,101815},{4,5728}],extra_attr = [],suit = 4150};

get_seal_equip_info(6003416) ->
	#base_seal_equip{id = 6003416,name = "碧魔魔之裤",pos = 3,stage = 16,color = 4,strong = 100,base_attr = [{2,121004},{4,6807}],extra_attr = [],suit = 4160};

get_seal_equip_info(6003417) ->
	#base_seal_equip{id = 6003417,name = "炼狱魔之裤",pos = 3,stage = 17,color = 4,strong = 100,base_attr = [{2,131316},{4,7387}],extra_attr = [],suit = 4170};

get_seal_equip_info(6003418) ->
	#base_seal_equip{id = 6003418,name = "吞天魔之裤",pos = 3,stage = 18,color = 4,strong = 100,base_attr = [{2,152903},{4,8601}],extra_attr = [],suit = 4180};

get_seal_equip_info(6003507) ->
	#base_seal_equip{id = 6003507,name = "烈阳魔之裤",pos = 3,stage = 7,color = 5,strong = 100,base_attr = [{2,45891},{4,2582}],extra_attr = [],suit = 5070};

get_seal_equip_info(6003508) ->
	#base_seal_equip{id = 6003508,name = "清秋魔之裤",pos = 3,stage = 8,color = 5,strong = 100,base_attr = [{2,60780},{4,3419}],extra_attr = [],suit = 5080};

get_seal_equip_info(6003509) ->
	#base_seal_equip{id = 6003509,name = "北辰魔之裤",pos = 3,stage = 9,color = 5,strong = 100,base_attr = [{2,63657},{4,3581}],extra_attr = [],suit = 5090};

get_seal_equip_info(6003510) ->
	#base_seal_equip{id = 6003510,name = "弦风魔之裤",pos = 3,stage = 10,color = 5,strong = 100,base_attr = [{2,80745},{4,4543}],extra_attr = [],suit = 5100};

get_seal_equip_info(6003511) ->
	#base_seal_equip{id = 6003511,name = "水月魔之裤",pos = 3,stage = 11,color = 5,strong = 100,base_attr = [{2,90144},{4,5071}],extra_attr = [],suit = 5110};

get_seal_equip_info(6003512) ->
	#base_seal_equip{id = 6003512,name = "熔火魔之裤",pos = 3,stage = 12,color = 5,strong = 100,base_attr = [{2,110083},{4,6193}],extra_attr = [],suit = 5120};

get_seal_equip_info(6003513) ->
	#base_seal_equip{id = 6003513,name = "幽泣魔之裤",pos = 3,stage = 13,color = 5,strong = 100,base_attr = [{2,120904},{4,6802}],extra_attr = [],suit = 5130};

get_seal_equip_info(6003514) ->
	#base_seal_equip{id = 6003514,name = "永夜魔之裤",pos = 3,stage = 14,color = 5,strong = 100,base_attr = [{2,143691},{4,8084}],extra_attr = [],suit = 5140};

get_seal_equip_info(6003515) ->
	#base_seal_equip{id = 6003515,name = "荣光魔之裤",pos = 3,stage = 15,color = 5,strong = 100,base_attr = [{2,155937},{4,8773}],extra_attr = [],suit = 5150};

get_seal_equip_info(6003516) ->
	#base_seal_equip{id = 6003516,name = "千锻魔之裤",pos = 3,stage = 16,color = 5,strong = 100,base_attr = [{2,181573},{4,10214}],extra_attr = [],suit = 5160};

get_seal_equip_info(6003517) ->
	#base_seal_equip{id = 6003517,name = "琉璃魔之裤",pos = 3,stage = 17,color = 5,strong = 100,base_attr = [{2,193819},{4,10903}],extra_attr = [],suit = 5170};

get_seal_equip_info(6003518) ->
	#base_seal_equip{id = 6003518,name = "织木魔之裤",pos = 3,stage = 18,color = 5,strong = 100,base_attr = [{2,219454},{4,12344}],extra_attr = [],suit = 5180};

get_seal_equip_info(6003608) ->
	#base_seal_equip{id = 6003608,name = "暗灭魔之裤",pos = 3,stage = 8,color = 7,strong = 100,base_attr = [{2,76356},{4,4295}],extra_attr = [],suit = 6080};

get_seal_equip_info(6003609) ->
	#base_seal_equip{id = 6003609,name = "梦长魔之裤",pos = 3,stage = 9,color = 7,strong = 100,base_attr = [{2,85424},{4,4805}],extra_attr = [],suit = 6090};

get_seal_equip_info(6003610) ->
	#base_seal_equip{id = 6003610,name = "御空魔之裤",pos = 3,stage = 10,color = 7,strong = 100,base_attr = [{2,93822},{4,5278}],extra_attr = [],suit = 6100};

get_seal_equip_info(6003611) ->
	#base_seal_equip{id = 6003611,name = "逸尘魔之裤",pos = 3,stage = 11,color = 7,strong = 100,base_attr = [{2,111504},{4,6274}],extra_attr = [],suit = 6110};

get_seal_equip_info(6003612) ->
	#base_seal_equip{id = 6003612,name = "天狼魔之裤",pos = 3,stage = 12,color = 7,strong = 100,base_attr = [{2,121008},{4,6807}],extra_attr = [],suit = 6120};

get_seal_equip_info(6003613) ->
	#base_seal_equip{id = 6003613,name = "天音魔之裤",pos = 3,stage = 13,color = 7,strong = 100,base_attr = [{2,140901},{4,7926}],extra_attr = [],suit = 6130};

get_seal_equip_info(6003614) ->
	#base_seal_equip{id = 6003614,name = "天舞魔之裤",pos = 3,stage = 14,color = 7,strong = 100,base_attr = [{2,150404},{4,8460}],extra_attr = [],suit = 6140};

get_seal_equip_info(6003615) ->
	#base_seal_equip{id = 6003615,name = "天琊魔之裤",pos = 3,stage = 15,color = 7,strong = 100,base_attr = [{2,170296},{4,9579}],extra_attr = [],suit = 6150};

get_seal_equip_info(6003616) ->
	#base_seal_equip{id = 6003616,name = "天罚魔之裤",pos = 3,stage = 16,color = 7,strong = 100,base_attr = [{2,237736},{4,13372}],extra_attr = [],suit = 6160};

get_seal_equip_info(6004304) ->
	#base_seal_equip{id = 6004304,name = "力量魔之腕",pos = 4,stage = 4,color = 3,strong = 100,base_attr = [{2,3024},{8,171}],extra_attr = [],suit = 0};

get_seal_equip_info(6004305) ->
	#base_seal_equip{id = 6004305,name = "愤怒魔之腕",pos = 4,stage = 5,color = 3,strong = 100,base_attr = [{2,5184},{8,292}],extra_attr = [],suit = 0};

get_seal_equip_info(6004306) ->
	#base_seal_equip{id = 6004306,name = "征服魔之腕",pos = 4,stage = 6,color = 3,strong = 100,base_attr = [{2,7309},{8,411}],extra_attr = [],suit = 0};

get_seal_equip_info(6004307) ->
	#base_seal_equip{id = 6004307,name = "无畏魔之腕",pos = 4,stage = 7,color = 3,strong = 100,base_attr = [{2,10445},{8,587}],extra_attr = [],suit = 0};

get_seal_equip_info(6004308) ->
	#base_seal_equip{id = 6004308,name = "冲锋魔之腕",pos = 4,stage = 8,color = 3,strong = 100,base_attr = [{2,17707},{8,997}],extra_attr = [],suit = 0};

get_seal_equip_info(6004309) ->
	#base_seal_equip{id = 6004309,name = "卓越魔之腕",pos = 4,stage = 9,color = 3,strong = 100,base_attr = [{2,19289},{8,1086}],extra_attr = [],suit = 0};

get_seal_equip_info(6004310) ->
	#base_seal_equip{id = 6004310,name = "屠夫魔之腕",pos = 4,stage = 10,color = 3,strong = 100,base_attr = [{2,26651},{8,1500}],extra_attr = [],suit = 0};

get_seal_equip_info(6004311) ->
	#base_seal_equip{id = 6004311,name = "野蛮魔之腕",pos = 4,stage = 11,color = 3,strong = 100,base_attr = [{2,29922},{8,1684}],extra_attr = [],suit = 0};

get_seal_equip_info(6004312) ->
	#base_seal_equip{id = 6004312,name = "致命魔之腕",pos = 4,stage = 12,color = 3,strong = 100,base_attr = [{2,37488},{8,2110}],extra_attr = [],suit = 0};

get_seal_equip_info(6004313) ->
	#base_seal_equip{id = 6004313,name = "狂怒魔之腕",pos = 4,stage = 13,color = 3,strong = 100,base_attr = [{2,40828},{8,2298}],extra_attr = [],suit = 0};

get_seal_equip_info(6004314) ->
	#base_seal_equip{id = 6004314,name = "无情魔之腕",pos = 4,stage = 14,color = 3,strong = 100,base_attr = [{2,48666},{8,2739}],extra_attr = [],suit = 0};

get_seal_equip_info(6004315) ->
	#base_seal_equip{id = 6004315,name = "暴怒魔之腕",pos = 4,stage = 15,color = 3,strong = 100,base_attr = [{2,52074},{8,2929}],extra_attr = [],suit = 0};

get_seal_equip_info(6004316) ->
	#base_seal_equip{id = 6004316,name = "残忍魔之腕",pos = 4,stage = 16,color = 3,strong = 100,base_attr = [{2,60049},{8,3380}],extra_attr = [],suit = 0};

get_seal_equip_info(6004317) ->
	#base_seal_equip{id = 6004317,name = "冷酷魔之腕",pos = 4,stage = 17,color = 3,strong = 100,base_attr = [{2,63525},{8,3574}],extra_attr = [],suit = 0};

get_seal_equip_info(6004318) ->
	#base_seal_equip{id = 6004318,name = "利刃魔之腕",pos = 4,stage = 18,color = 3,strong = 100,base_attr = [{2,71636},{8,4030}],extra_attr = [],suit = 0};

get_seal_equip_info(6004404) ->
	#base_seal_equip{id = 6004404,name = "幽魅魔之腕",pos = 4,stage = 4,color = 4,strong = 100,base_attr = [{2,5368},{8,302}],extra_attr = [],suit = 4040};

get_seal_equip_info(6004405) ->
	#base_seal_equip{id = 6004405,name = "复仇魔之腕",pos = 4,stage = 5,color = 4,strong = 100,base_attr = [{2,9216},{8,518}],extra_attr = [],suit = 4050};

get_seal_equip_info(6004406) ->
	#base_seal_equip{id = 6004406,name = "毁灭魔之腕",pos = 4,stage = 6,color = 4,strong = 100,base_attr = [{2,13002},{8,731}],extra_attr = [],suit = 4060};

get_seal_equip_info(6004407) ->
	#base_seal_equip{id = 6004407,name = "灾变魔之腕",pos = 4,stage = 7,color = 4,strong = 100,base_attr = [{2,18576},{8,1045}],extra_attr = [],suit = 4070};

get_seal_equip_info(6004408) ->
	#base_seal_equip{id = 6004408,name = "恶毒魔之腕",pos = 4,stage = 8,color = 4,strong = 100,base_attr = [{2,31487},{8,1770}],extra_attr = [],suit = 4080};

get_seal_equip_info(6004409) ->
	#base_seal_equip{id = 6004409,name = "腐蚀魔之腕",pos = 4,stage = 9,color = 4,strong = 100,base_attr = [{2,34299},{8,1928}],extra_attr = [],suit = 4090};

get_seal_equip_info(6004410) ->
	#base_seal_equip{id = 6004410,name = "瘟疫魔之腕",pos = 4,stage = 10,color = 4,strong = 100,base_attr = [{2,46891},{8,2638}],extra_attr = [],suit = 4100};

get_seal_equip_info(6004411) ->
	#base_seal_equip{id = 6004411,name = "无间魔之腕",pos = 4,stage = 11,color = 4,strong = 100,base_attr = [{2,53605},{8,3015}],extra_attr = [],suit = 4110};

get_seal_equip_info(6004412) ->
	#base_seal_equip{id = 6004412,name = "虚空魔之腕",pos = 4,stage = 12,color = 4,strong = 100,base_attr = [{2,67997},{8,3825}],extra_attr = [],suit = 4120};

get_seal_equip_info(6004413) ->
	#base_seal_equip{id = 6004413,name = "双煞魔之腕",pos = 4,stage = 13,color = 4,strong = 100,base_attr = [{2,75910},{8,4270}],extra_attr = [],suit = 4130};

get_seal_equip_info(6004414) ->
	#base_seal_equip{id = 6004414,name = "坟冢魔之腕",pos = 4,stage = 14,color = 4,strong = 100,base_attr = [{2,92700},{8,5214}],extra_attr = [],suit = 4140};

get_seal_equip_info(6004415) ->
	#base_seal_equip{id = 6004415,name = "梦魇魔之腕",pos = 4,stage = 15,color = 4,strong = 100,base_attr = [{2,101815},{8,5728}],extra_attr = [],suit = 4150};

get_seal_equip_info(6004416) ->
	#base_seal_equip{id = 6004416,name = "碧魔魔之腕",pos = 4,stage = 16,color = 4,strong = 100,base_attr = [{2,121004},{8,6807}],extra_attr = [],suit = 4160};

get_seal_equip_info(6004417) ->
	#base_seal_equip{id = 6004417,name = "炼狱魔之腕",pos = 4,stage = 17,color = 4,strong = 100,base_attr = [{2,131316},{8,7387}],extra_attr = [],suit = 4170};

get_seal_equip_info(6004418) ->
	#base_seal_equip{id = 6004418,name = "吞天魔之腕",pos = 4,stage = 18,color = 4,strong = 100,base_attr = [{2,152903},{8,8601}],extra_attr = [],suit = 4180};

get_seal_equip_info(6004507) ->
	#base_seal_equip{id = 6004507,name = "烈阳魔之腕",pos = 4,stage = 7,color = 5,strong = 100,base_attr = [{2,45891},{8,2582}],extra_attr = [],suit = 5070};

get_seal_equip_info(6004508) ->
	#base_seal_equip{id = 6004508,name = "清秋魔之腕",pos = 4,stage = 8,color = 5,strong = 100,base_attr = [{2,60780},{8,3419}],extra_attr = [],suit = 5080};

get_seal_equip_info(6004509) ->
	#base_seal_equip{id = 6004509,name = "北辰魔之腕",pos = 4,stage = 9,color = 5,strong = 100,base_attr = [{2,63657},{8,3581}],extra_attr = [],suit = 5090};

get_seal_equip_info(6004510) ->
	#base_seal_equip{id = 6004510,name = "弦风魔之腕",pos = 4,stage = 10,color = 5,strong = 100,base_attr = [{2,80745},{8,4543}],extra_attr = [],suit = 5100};

get_seal_equip_info(6004511) ->
	#base_seal_equip{id = 6004511,name = "水月魔之腕",pos = 4,stage = 11,color = 5,strong = 100,base_attr = [{2,90144},{8,5071}],extra_attr = [],suit = 5110};

get_seal_equip_info(6004512) ->
	#base_seal_equip{id = 6004512,name = "熔火魔之腕",pos = 4,stage = 12,color = 5,strong = 100,base_attr = [{2,110083},{8,6193}],extra_attr = [],suit = 5120};

get_seal_equip_info(6004513) ->
	#base_seal_equip{id = 6004513,name = "幽泣魔之腕",pos = 4,stage = 13,color = 5,strong = 100,base_attr = [{2,120904},{8,6802}],extra_attr = [],suit = 5130};

get_seal_equip_info(6004514) ->
	#base_seal_equip{id = 6004514,name = "永夜魔之腕",pos = 4,stage = 14,color = 5,strong = 100,base_attr = [{2,143691},{8,8084}],extra_attr = [],suit = 5140};

get_seal_equip_info(6004515) ->
	#base_seal_equip{id = 6004515,name = "荣光魔之腕",pos = 4,stage = 15,color = 5,strong = 100,base_attr = [{2,155937},{8,8773}],extra_attr = [],suit = 5150};

get_seal_equip_info(6004516) ->
	#base_seal_equip{id = 6004516,name = "千锻魔之腕",pos = 4,stage = 16,color = 5,strong = 100,base_attr = [{2,181573},{8,10214}],extra_attr = [],suit = 5160};

get_seal_equip_info(6004517) ->
	#base_seal_equip{id = 6004517,name = "琉璃魔之腕",pos = 4,stage = 17,color = 5,strong = 100,base_attr = [{2,193819},{8,10903}],extra_attr = [],suit = 5170};

get_seal_equip_info(6004518) ->
	#base_seal_equip{id = 6004518,name = "织木魔之腕",pos = 4,stage = 18,color = 5,strong = 100,base_attr = [{2,219454},{8,12344}],extra_attr = [],suit = 5180};

get_seal_equip_info(6004608) ->
	#base_seal_equip{id = 6004608,name = "暗灭魔之腕",pos = 4,stage = 8,color = 7,strong = 100,base_attr = [{2,76356},{8,4295}],extra_attr = [],suit = 6080};

get_seal_equip_info(6004609) ->
	#base_seal_equip{id = 6004609,name = "梦长魔之腕",pos = 4,stage = 9,color = 7,strong = 100,base_attr = [{2,85424},{8,4805}],extra_attr = [],suit = 6090};

get_seal_equip_info(6004610) ->
	#base_seal_equip{id = 6004610,name = "御空魔之腕",pos = 4,stage = 10,color = 7,strong = 100,base_attr = [{2,93822},{8,5278}],extra_attr = [],suit = 6100};

get_seal_equip_info(6004611) ->
	#base_seal_equip{id = 6004611,name = "逸尘魔之腕",pos = 4,stage = 11,color = 7,strong = 100,base_attr = [{2,111504},{8,6274}],extra_attr = [],suit = 6110};

get_seal_equip_info(6004612) ->
	#base_seal_equip{id = 6004612,name = "天狼魔之腕",pos = 4,stage = 12,color = 7,strong = 100,base_attr = [{2,121008},{8,6807}],extra_attr = [],suit = 6120};

get_seal_equip_info(6004613) ->
	#base_seal_equip{id = 6004613,name = "天音魔之腕",pos = 4,stage = 13,color = 7,strong = 100,base_attr = [{2,140901},{8,7926}],extra_attr = [],suit = 6130};

get_seal_equip_info(6004614) ->
	#base_seal_equip{id = 6004614,name = "天舞魔之腕",pos = 4,stage = 14,color = 7,strong = 100,base_attr = [{2,150404},{8,8460}],extra_attr = [],suit = 6140};

get_seal_equip_info(6004615) ->
	#base_seal_equip{id = 6004615,name = "天琊魔之腕",pos = 4,stage = 15,color = 7,strong = 100,base_attr = [{2,170296},{8,9579}],extra_attr = [],suit = 6150};

get_seal_equip_info(6004616) ->
	#base_seal_equip{id = 6004616,name = "天罚魔之腕",pos = 4,stage = 16,color = 7,strong = 100,base_attr = [{2,237736},{8,13372}],extra_attr = [],suit = 6160};

get_seal_equip_info(6005304) ->
	#base_seal_equip{id = 6005304,name = "力量魔之铠",pos = 5,stage = 4,color = 3,strong = 100,base_attr = [{4,151},{8,171}],extra_attr = [],suit = 0};

get_seal_equip_info(6005305) ->
	#base_seal_equip{id = 6005305,name = "愤怒魔之铠",pos = 5,stage = 5,color = 3,strong = 100,base_attr = [{4,259},{8,292}],extra_attr = [],suit = 0};

get_seal_equip_info(6005306) ->
	#base_seal_equip{id = 6005306,name = "征服魔之铠",pos = 5,stage = 6,color = 3,strong = 100,base_attr = [{4,366},{8,411}],extra_attr = [],suit = 0};

get_seal_equip_info(6005307) ->
	#base_seal_equip{id = 6005307,name = "无畏魔之铠",pos = 5,stage = 7,color = 3,strong = 100,base_attr = [{4,522},{8,587}],extra_attr = [],suit = 0};

get_seal_equip_info(6005308) ->
	#base_seal_equip{id = 6005308,name = "冲锋魔之铠",pos = 5,stage = 8,color = 3,strong = 100,base_attr = [{4,885},{8,997}],extra_attr = [],suit = 0};

get_seal_equip_info(6005309) ->
	#base_seal_equip{id = 6005309,name = "卓越魔之铠",pos = 5,stage = 9,color = 3,strong = 100,base_attr = [{4,964},{8,1086}],extra_attr = [],suit = 0};

get_seal_equip_info(6005310) ->
	#base_seal_equip{id = 6005310,name = "屠夫魔之铠",pos = 5,stage = 10,color = 3,strong = 100,base_attr = [{4,1332},{8,1500}],extra_attr = [],suit = 0};

get_seal_equip_info(6005311) ->
	#base_seal_equip{id = 6005311,name = "野蛮魔之铠",pos = 5,stage = 11,color = 3,strong = 100,base_attr = [{4,1497},{8,1684}],extra_attr = [],suit = 0};

get_seal_equip_info(6005312) ->
	#base_seal_equip{id = 6005312,name = "致命魔之铠",pos = 5,stage = 12,color = 3,strong = 100,base_attr = [{4,1874},{8,2110}],extra_attr = [],suit = 0};

get_seal_equip_info(6005313) ->
	#base_seal_equip{id = 6005313,name = "狂怒魔之铠",pos = 5,stage = 13,color = 3,strong = 100,base_attr = [{4,2042},{8,2298}],extra_attr = [],suit = 0};

get_seal_equip_info(6005314) ->
	#base_seal_equip{id = 6005314,name = "无情魔之铠",pos = 5,stage = 14,color = 3,strong = 100,base_attr = [{4,2434},{8,2739}],extra_attr = [],suit = 0};

get_seal_equip_info(6005315) ->
	#base_seal_equip{id = 6005315,name = "暴怒魔之铠",pos = 5,stage = 15,color = 3,strong = 100,base_attr = [{4,2604},{8,2929}],extra_attr = [],suit = 0};

get_seal_equip_info(6005316) ->
	#base_seal_equip{id = 6005316,name = "残忍魔之铠",pos = 5,stage = 16,color = 3,strong = 100,base_attr = [{4,3002},{8,3380}],extra_attr = [],suit = 0};

get_seal_equip_info(6005317) ->
	#base_seal_equip{id = 6005317,name = "冷酷魔之铠",pos = 5,stage = 17,color = 3,strong = 100,base_attr = [{4,3177},{8,3574}],extra_attr = [],suit = 0};

get_seal_equip_info(6005318) ->
	#base_seal_equip{id = 6005318,name = "利刃魔之铠",pos = 5,stage = 18,color = 3,strong = 100,base_attr = [{4,3581},{8,4030}],extra_attr = [],suit = 0};

get_seal_equip_info(6005404) ->
	#base_seal_equip{id = 6005404,name = "幽魅魔之铠",pos = 5,stage = 4,color = 4,strong = 100,base_attr = [{4,268},{8,302}],extra_attr = [],suit = 4040};

get_seal_equip_info(6005405) ->
	#base_seal_equip{id = 6005405,name = "复仇魔之铠",pos = 5,stage = 5,color = 4,strong = 100,base_attr = [{4,461},{8,518}],extra_attr = [],suit = 4050};

get_seal_equip_info(6005406) ->
	#base_seal_equip{id = 6005406,name = "毁灭魔之铠",pos = 5,stage = 6,color = 4,strong = 100,base_attr = [{4,651},{8,731}],extra_attr = [],suit = 4060};

get_seal_equip_info(6005407) ->
	#base_seal_equip{id = 6005407,name = "灾变魔之铠",pos = 5,stage = 7,color = 4,strong = 100,base_attr = [{4,930},{8,1045}],extra_attr = [],suit = 4070};

get_seal_equip_info(6005408) ->
	#base_seal_equip{id = 6005408,name = "恶毒魔之铠",pos = 5,stage = 8,color = 4,strong = 100,base_attr = [{4,1575},{8,1770}],extra_attr = [],suit = 4080};

get_seal_equip_info(6005409) ->
	#base_seal_equip{id = 6005409,name = "腐蚀魔之铠",pos = 5,stage = 9,color = 4,strong = 100,base_attr = [{4,1715},{8,1928}],extra_attr = [],suit = 4090};

get_seal_equip_info(6005410) ->
	#base_seal_equip{id = 6005410,name = "瘟疫魔之铠",pos = 5,stage = 10,color = 4,strong = 100,base_attr = [{4,2344},{8,2638}],extra_attr = [],suit = 4100};

get_seal_equip_info(6005411) ->
	#base_seal_equip{id = 6005411,name = "无间魔之铠",pos = 5,stage = 11,color = 4,strong = 100,base_attr = [{4,2680},{8,3015}],extra_attr = [],suit = 4110};

get_seal_equip_info(6005412) ->
	#base_seal_equip{id = 6005412,name = "虚空魔之铠",pos = 5,stage = 12,color = 4,strong = 100,base_attr = [{4,3399},{8,3825}],extra_attr = [],suit = 4120};

get_seal_equip_info(6005413) ->
	#base_seal_equip{id = 6005413,name = "双煞魔之铠",pos = 5,stage = 13,color = 4,strong = 100,base_attr = [{4,3796},{8,4270}],extra_attr = [],suit = 4130};

get_seal_equip_info(6005414) ->
	#base_seal_equip{id = 6005414,name = "坟冢魔之铠",pos = 5,stage = 14,color = 4,strong = 100,base_attr = [{4,4635},{8,5214}],extra_attr = [],suit = 4140};

get_seal_equip_info(6005415) ->
	#base_seal_equip{id = 6005415,name = "梦魇魔之铠",pos = 5,stage = 15,color = 4,strong = 100,base_attr = [{4,5092},{8,5728}],extra_attr = [],suit = 4150};

get_seal_equip_info(6005416) ->
	#base_seal_equip{id = 6005416,name = "碧魔魔之铠",pos = 5,stage = 16,color = 4,strong = 100,base_attr = [{4,6051},{8,6807}],extra_attr = [],suit = 4160};

get_seal_equip_info(6005417) ->
	#base_seal_equip{id = 6005417,name = "炼狱魔之铠",pos = 5,stage = 17,color = 4,strong = 100,base_attr = [{4,6566},{8,7387}],extra_attr = [],suit = 4170};

get_seal_equip_info(6005418) ->
	#base_seal_equip{id = 6005418,name = "吞天魔之铠",pos = 5,stage = 18,color = 4,strong = 100,base_attr = [{4,7645},{8,8601}],extra_attr = [],suit = 4180};

get_seal_equip_info(6005507) ->
	#base_seal_equip{id = 6005507,name = "烈阳魔之铠",pos = 5,stage = 7,color = 5,strong = 100,base_attr = [{4,2294},{8,2582}],extra_attr = [],suit = 5070};

get_seal_equip_info(6005508) ->
	#base_seal_equip{id = 6005508,name = "清秋魔之铠",pos = 5,stage = 8,color = 5,strong = 100,base_attr = [{4,3040},{8,3419}],extra_attr = [],suit = 5080};

get_seal_equip_info(6005509) ->
	#base_seal_equip{id = 6005509,name = "北辰魔之铠",pos = 5,stage = 9,color = 5,strong = 100,base_attr = [{4,3184},{8,3581}],extra_attr = [],suit = 5090};

get_seal_equip_info(6005510) ->
	#base_seal_equip{id = 6005510,name = "弦风魔之铠",pos = 5,stage = 10,color = 5,strong = 100,base_attr = [{4,4037},{8,4543}],extra_attr = [],suit = 5100};

get_seal_equip_info(6005511) ->
	#base_seal_equip{id = 6005511,name = "水月魔之铠",pos = 5,stage = 11,color = 5,strong = 100,base_attr = [{4,4507},{8,5071}],extra_attr = [],suit = 5110};

get_seal_equip_info(6005512) ->
	#base_seal_equip{id = 6005512,name = "熔火魔之铠",pos = 5,stage = 12,color = 5,strong = 100,base_attr = [{4,5504},{8,6193}],extra_attr = [],suit = 5120};

get_seal_equip_info(6005513) ->
	#base_seal_equip{id = 6005513,name = "幽泣魔之铠",pos = 5,stage = 13,color = 5,strong = 100,base_attr = [{4,6046},{8,6802}],extra_attr = [],suit = 5130};

get_seal_equip_info(6005514) ->
	#base_seal_equip{id = 6005514,name = "永夜魔之铠",pos = 5,stage = 14,color = 5,strong = 100,base_attr = [{4,7184},{8,8084}],extra_attr = [],suit = 5140};

get_seal_equip_info(6005515) ->
	#base_seal_equip{id = 6005515,name = "荣光魔之铠",pos = 5,stage = 15,color = 5,strong = 100,base_attr = [{4,7797},{8,8773}],extra_attr = [],suit = 5150};

get_seal_equip_info(6005516) ->
	#base_seal_equip{id = 6005516,name = "千锻魔之铠",pos = 5,stage = 16,color = 5,strong = 100,base_attr = [{4,9078},{8,10214}],extra_attr = [],suit = 5160};

get_seal_equip_info(6005517) ->
	#base_seal_equip{id = 6005517,name = "琉璃魔之铠",pos = 5,stage = 17,color = 5,strong = 100,base_attr = [{4,9692},{8,10903}],extra_attr = [],suit = 5170};

get_seal_equip_info(6005518) ->
	#base_seal_equip{id = 6005518,name = "织木魔之铠",pos = 5,stage = 18,color = 5,strong = 100,base_attr = [{4,10971},{8,12344}],extra_attr = [],suit = 5180};

get_seal_equip_info(6005608) ->
	#base_seal_equip{id = 6005608,name = "暗灭魔之铠",pos = 5,stage = 8,color = 7,strong = 100,base_attr = [{4,3818},{8,4295}],extra_attr = [],suit = 6080};

get_seal_equip_info(6005609) ->
	#base_seal_equip{id = 6005609,name = "梦长魔之铠",pos = 5,stage = 9,color = 7,strong = 100,base_attr = [{4,4271},{8,4805}],extra_attr = [],suit = 6090};

get_seal_equip_info(6005610) ->
	#base_seal_equip{id = 6005610,name = "御空魔之铠",pos = 5,stage = 10,color = 7,strong = 100,base_attr = [{4,4692},{8,5278}],extra_attr = [],suit = 6100};

get_seal_equip_info(6005611) ->
	#base_seal_equip{id = 6005611,name = "逸尘魔之铠",pos = 5,stage = 11,color = 7,strong = 100,base_attr = [{4,5575},{8,6274}],extra_attr = [],suit = 6110};

get_seal_equip_info(6005612) ->
	#base_seal_equip{id = 6005612,name = "天狼魔之铠",pos = 5,stage = 12,color = 7,strong = 100,base_attr = [{4,6051},{8,6807}],extra_attr = [],suit = 6120};

get_seal_equip_info(6005613) ->
	#base_seal_equip{id = 6005613,name = "天音魔之铠",pos = 5,stage = 13,color = 7,strong = 100,base_attr = [{4,7045},{8,7926}],extra_attr = [],suit = 6130};

get_seal_equip_info(6005614) ->
	#base_seal_equip{id = 6005614,name = "天舞魔之铠",pos = 5,stage = 14,color = 7,strong = 100,base_attr = [{4,7520},{8,8460}],extra_attr = [],suit = 6140};

get_seal_equip_info(6005615) ->
	#base_seal_equip{id = 6005615,name = "天琊魔之铠",pos = 5,stage = 15,color = 7,strong = 100,base_attr = [{4,8513},{8,9579}],extra_attr = [],suit = 6150};

get_seal_equip_info(6005616) ->
	#base_seal_equip{id = 6005616,name = "天罚魔之铠",pos = 5,stage = 16,color = 7,strong = 100,base_attr = [{4,11884},{8,13372}],extra_attr = [],suit = 6160};

get_seal_equip_info(6006304) ->
	#base_seal_equip{id = 6006304,name = "力量魔之力",pos = 6,stage = 4,color = 3,strong = 100,base_attr = [{3,227},{7,113}],extra_attr = [],suit = 0};

get_seal_equip_info(6006305) ->
	#base_seal_equip{id = 6006305,name = "愤怒魔之力",pos = 6,stage = 5,color = 3,strong = 100,base_attr = [{3,389},{7,194}],extra_attr = [],suit = 0};

get_seal_equip_info(6006306) ->
	#base_seal_equip{id = 6006306,name = "征服魔之力",pos = 6,stage = 6,color = 3,strong = 100,base_attr = [{3,548},{7,275}],extra_attr = [],suit = 0};

get_seal_equip_info(6006307) ->
	#base_seal_equip{id = 6006307,name = "无畏魔之力",pos = 6,stage = 7,color = 3,strong = 100,base_attr = [{3,784},{7,392}],extra_attr = [],suit = 0};

get_seal_equip_info(6006308) ->
	#base_seal_equip{id = 6006308,name = "冲锋魔之力",pos = 6,stage = 8,color = 3,strong = 100,base_attr = [{3,1328},{7,665}],extra_attr = [],suit = 0};

get_seal_equip_info(6006309) ->
	#base_seal_equip{id = 6006309,name = "卓越魔之力",pos = 6,stage = 9,color = 3,strong = 100,base_attr = [{3,1447},{7,724}],extra_attr = [],suit = 0};

get_seal_equip_info(6006310) ->
	#base_seal_equip{id = 6006310,name = "屠夫魔之力",pos = 6,stage = 10,color = 3,strong = 100,base_attr = [{3,1999},{7,1000}],extra_attr = [],suit = 0};

get_seal_equip_info(6006311) ->
	#base_seal_equip{id = 6006311,name = "野蛮魔之力",pos = 6,stage = 11,color = 3,strong = 100,base_attr = [{3,2245},{7,1122}],extra_attr = [],suit = 0};

get_seal_equip_info(6006312) ->
	#base_seal_equip{id = 6006312,name = "致命魔之力",pos = 6,stage = 12,color = 3,strong = 100,base_attr = [{3,2812},{7,1406}],extra_attr = [],suit = 0};

get_seal_equip_info(6006313) ->
	#base_seal_equip{id = 6006313,name = "狂怒魔之力",pos = 6,stage = 13,color = 3,strong = 100,base_attr = [{3,3063},{7,1531}],extra_attr = [],suit = 0};

get_seal_equip_info(6006314) ->
	#base_seal_equip{id = 6006314,name = "无情魔之力",pos = 6,stage = 14,color = 3,strong = 100,base_attr = [{3,3649},{7,1826}],extra_attr = [],suit = 0};

get_seal_equip_info(6006315) ->
	#base_seal_equip{id = 6006315,name = "暴怒魔之力",pos = 6,stage = 15,color = 3,strong = 100,base_attr = [{3,3905},{7,1953}],extra_attr = [],suit = 0};

get_seal_equip_info(6006316) ->
	#base_seal_equip{id = 6006316,name = "残忍魔之力",pos = 6,stage = 16,color = 3,strong = 100,base_attr = [{3,4504},{7,2252}],extra_attr = [],suit = 0};

get_seal_equip_info(6006317) ->
	#base_seal_equip{id = 6006317,name = "冷酷魔之力",pos = 6,stage = 17,color = 3,strong = 100,base_attr = [{3,4764},{7,2383}],extra_attr = [],suit = 0};

get_seal_equip_info(6006318) ->
	#base_seal_equip{id = 6006318,name = "利刃魔之力",pos = 6,stage = 18,color = 3,strong = 100,base_attr = [{3,5373},{7,2687}],extra_attr = [],suit = 0};

get_seal_equip_info(6006404) ->
	#base_seal_equip{id = 6006404,name = "幽魅魔之力",pos = 6,stage = 4,color = 4,strong = 100,base_attr = [{3,403},{7,202}],extra_attr = [],suit = 4040};

get_seal_equip_info(6006405) ->
	#base_seal_equip{id = 6006405,name = "复仇魔之力",pos = 6,stage = 5,color = 4,strong = 100,base_attr = [{3,691},{7,346}],extra_attr = [],suit = 4050};

get_seal_equip_info(6006406) ->
	#base_seal_equip{id = 6006406,name = "毁灭魔之力",pos = 6,stage = 6,color = 4,strong = 100,base_attr = [{3,975},{7,488}],extra_attr = [],suit = 4060};

get_seal_equip_info(6006407) ->
	#base_seal_equip{id = 6006407,name = "灾变魔之力",pos = 6,stage = 7,color = 4,strong = 100,base_attr = [{3,1392},{7,696}],extra_attr = [],suit = 4070};

get_seal_equip_info(6006408) ->
	#base_seal_equip{id = 6006408,name = "恶毒魔之力",pos = 6,stage = 8,color = 4,strong = 100,base_attr = [{3,2361},{7,1181}],extra_attr = [],suit = 4080};

get_seal_equip_info(6006409) ->
	#base_seal_equip{id = 6006409,name = "腐蚀魔之力",pos = 6,stage = 9,color = 4,strong = 100,base_attr = [{3,2599},{7,1287}],extra_attr = [],suit = 4090};

get_seal_equip_info(6006410) ->
	#base_seal_equip{id = 6006410,name = "瘟疫魔之力",pos = 6,stage = 10,color = 4,strong = 100,base_attr = [{3,3553},{7,1758}],extra_attr = [],suit = 4100};

get_seal_equip_info(6006411) ->
	#base_seal_equip{id = 6006411,name = "无间魔之力",pos = 6,stage = 11,color = 4,strong = 100,base_attr = [{3,4063},{7,2011}],extra_attr = [],suit = 4110};

get_seal_equip_info(6006412) ->
	#base_seal_equip{id = 6006412,name = "虚空魔之力",pos = 6,stage = 12,color = 4,strong = 100,base_attr = [{3,5153},{7,2549}],extra_attr = [],suit = 4120};

get_seal_equip_info(6006413) ->
	#base_seal_equip{id = 6006413,name = "双煞魔之力",pos = 6,stage = 13,color = 4,strong = 100,base_attr = [{3,5752},{7,2847}],extra_attr = [],suit = 4130};

get_seal_equip_info(6006414) ->
	#base_seal_equip{id = 6006414,name = "坟冢魔之力",pos = 6,stage = 14,color = 4,strong = 100,base_attr = [{3,7025},{7,3475}],extra_attr = [],suit = 4140};

get_seal_equip_info(6006415) ->
	#base_seal_equip{id = 6006415,name = "梦魇魔之力",pos = 6,stage = 15,color = 4,strong = 100,base_attr = [{3,7716},{7,3817}],extra_attr = [],suit = 4150};

get_seal_equip_info(6006416) ->
	#base_seal_equip{id = 6006416,name = "碧魔魔之力",pos = 6,stage = 16,color = 4,strong = 100,base_attr = [{3,9170},{7,4537}],extra_attr = [],suit = 4160};

get_seal_equip_info(6006417) ->
	#base_seal_equip{id = 6006417,name = "炼狱魔之力",pos = 6,stage = 17,color = 4,strong = 100,base_attr = [{3,9951},{7,4923}],extra_attr = [],suit = 4170};

get_seal_equip_info(6006418) ->
	#base_seal_equip{id = 6006418,name = "吞天魔之力",pos = 6,stage = 18,color = 4,strong = 100,base_attr = [{3,11587},{7,5733}],extra_attr = [],suit = 4180};

get_seal_equip_info(6006507) ->
	#base_seal_equip{id = 6006507,name = "烈阳魔之力",pos = 6,stage = 7,color = 5,strong = 100,base_attr = [{3,3478},{7,1720}],extra_attr = [],suit = 5070};

get_seal_equip_info(6006508) ->
	#base_seal_equip{id = 6006508,name = "清秋魔之力",pos = 6,stage = 8,color = 5,strong = 100,base_attr = [{3,4607},{7,2279}],extra_attr = [],suit = 5080};

get_seal_equip_info(6006509) ->
	#base_seal_equip{id = 6006509,name = "北辰魔之力",pos = 6,stage = 9,color = 5,strong = 100,base_attr = [{3,4825},{7,2387}],extra_attr = [],suit = 5090};

get_seal_equip_info(6006510) ->
	#base_seal_equip{id = 6006510,name = "弦风魔之力",pos = 6,stage = 10,color = 5,strong = 100,base_attr = [{3,6120},{7,3027}],extra_attr = [],suit = 5100};

get_seal_equip_info(6006511) ->
	#base_seal_equip{id = 6006511,name = "水月魔之力",pos = 6,stage = 11,color = 5,strong = 100,base_attr = [{3,6832},{7,3380}],extra_attr = [],suit = 5110};

get_seal_equip_info(6006512) ->
	#base_seal_equip{id = 6006512,name = "熔火魔之力",pos = 6,stage = 12,color = 5,strong = 100,base_attr = [{3,8343},{7,4127}],extra_attr = [],suit = 5120};

get_seal_equip_info(6006513) ->
	#base_seal_equip{id = 6006513,name = "幽泣魔之力",pos = 6,stage = 13,color = 5,strong = 100,base_attr = [{3,9163},{7,4533}],extra_attr = [],suit = 5130};

get_seal_equip_info(6006514) ->
	#base_seal_equip{id = 6006514,name = "永夜魔之力",pos = 6,stage = 14,color = 5,strong = 100,base_attr = [{3,10890},{7,5387}],extra_attr = [],suit = 5140};

get_seal_equip_info(6006515) ->
	#base_seal_equip{id = 6006515,name = "荣光魔之力",pos = 6,stage = 15,color = 5,strong = 100,base_attr = [{3,11817},{7,5848}],extra_attr = [],suit = 5150};

get_seal_equip_info(6006516) ->
	#base_seal_equip{id = 6006516,name = "千锻魔之力",pos = 6,stage = 16,color = 5,strong = 100,base_attr = [{3,13760},{7,6807}],extra_attr = [],suit = 5160};

get_seal_equip_info(6006517) ->
	#base_seal_equip{id = 6006517,name = "琉璃魔之力",pos = 6,stage = 17,color = 5,strong = 100,base_attr = [{3,14688},{7,7268}],extra_attr = [],suit = 5170};

get_seal_equip_info(6006518) ->
	#base_seal_equip{id = 6006518,name = "织木魔之力",pos = 6,stage = 18,color = 5,strong = 100,base_attr = [{3,16631},{7,8229}],extra_attr = [],suit = 5180};

get_seal_equip_info(6006608) ->
	#base_seal_equip{id = 6006608,name = "暗灭魔之力",pos = 6,stage = 8,color = 7,strong = 100,base_attr = [{3,5788},{7,2863}],extra_attr = [],suit = 6080};

get_seal_equip_info(6006609) ->
	#base_seal_equip{id = 6006609,name = "梦长魔之力",pos = 6,stage = 9,color = 7,strong = 100,base_attr = [{3,6474},{7,3202}],extra_attr = [],suit = 6090};

get_seal_equip_info(6006610) ->
	#base_seal_equip{id = 6006610,name = "御空魔之力",pos = 6,stage = 10,color = 7,strong = 100,base_attr = [{3,7110},{7,3517}],extra_attr = [],suit = 6100};

get_seal_equip_info(6006611) ->
	#base_seal_equip{id = 6006611,name = "逸尘魔之力",pos = 6,stage = 11,color = 7,strong = 100,base_attr = [{3,8450},{7,4180}],extra_attr = [],suit = 6110};

get_seal_equip_info(6006612) ->
	#base_seal_equip{id = 6006612,name = "天狼魔之力",pos = 6,stage = 12,color = 7,strong = 100,base_attr = [{3,9170},{7,4537}],extra_attr = [],suit = 6120};

get_seal_equip_info(6006613) ->
	#base_seal_equip{id = 6006613,name = "天音魔之力",pos = 6,stage = 13,color = 7,strong = 100,base_attr = [{3,10677},{7,5282}],extra_attr = [],suit = 6130};

get_seal_equip_info(6006614) ->
	#base_seal_equip{id = 6006614,name = "天舞魔之力",pos = 6,stage = 14,color = 7,strong = 100,base_attr = [{3,11398},{7,5639}],extra_attr = [],suit = 6140};

get_seal_equip_info(6006615) ->
	#base_seal_equip{id = 6006615,name = "天琊魔之力",pos = 6,stage = 15,color = 7,strong = 100,base_attr = [{3,12906},{7,6386}],extra_attr = [],suit = 6150};

get_seal_equip_info(6006616) ->
	#base_seal_equip{id = 6006616,name = "天罚魔之力",pos = 6,stage = 16,color = 7,strong = 100,base_attr = [{3,18017},{7,8915}],extra_attr = [],suit = 6160};

get_seal_equip_info(6007304) ->
	#base_seal_equip{id = 6007304,name = "力量灵之晶核",pos = 7,stage = 4,color = 3,strong = 100,base_attr = [{3,227},{5,113}],extra_attr = [],suit = 0};

get_seal_equip_info(6007305) ->
	#base_seal_equip{id = 6007305,name = "愤怒灵之晶核",pos = 7,stage = 5,color = 3,strong = 100,base_attr = [{3,389},{5,194}],extra_attr = [],suit = 0};

get_seal_equip_info(6007306) ->
	#base_seal_equip{id = 6007306,name = "征服灵之晶核",pos = 7,stage = 6,color = 3,strong = 100,base_attr = [{3,548},{5,275}],extra_attr = [],suit = 0};

get_seal_equip_info(6007307) ->
	#base_seal_equip{id = 6007307,name = "无畏灵之晶核",pos = 7,stage = 7,color = 3,strong = 100,base_attr = [{3,784},{5,392}],extra_attr = [],suit = 0};

get_seal_equip_info(6007308) ->
	#base_seal_equip{id = 6007308,name = "冲锋灵之晶核",pos = 7,stage = 8,color = 3,strong = 100,base_attr = [{3,1328},{5,665}],extra_attr = [],suit = 0};

get_seal_equip_info(6007309) ->
	#base_seal_equip{id = 6007309,name = "卓越灵之晶核",pos = 7,stage = 9,color = 3,strong = 100,base_attr = [{3,1447},{5,724}],extra_attr = [],suit = 0};

get_seal_equip_info(6007310) ->
	#base_seal_equip{id = 6007310,name = "屠夫灵之晶核",pos = 7,stage = 10,color = 3,strong = 100,base_attr = [{3,1999},{5,1000}],extra_attr = [],suit = 0};

get_seal_equip_info(6007311) ->
	#base_seal_equip{id = 6007311,name = "野蛮灵之晶核",pos = 7,stage = 11,color = 3,strong = 100,base_attr = [{3,2245},{5,1122}],extra_attr = [],suit = 0};

get_seal_equip_info(6007312) ->
	#base_seal_equip{id = 6007312,name = "致命灵之晶核",pos = 7,stage = 12,color = 3,strong = 100,base_attr = [{3,2812},{5,1406}],extra_attr = [],suit = 0};

get_seal_equip_info(6007313) ->
	#base_seal_equip{id = 6007313,name = "狂怒灵之晶核",pos = 7,stage = 13,color = 3,strong = 100,base_attr = [{3,3063},{5,1531}],extra_attr = [],suit = 0};

get_seal_equip_info(6007314) ->
	#base_seal_equip{id = 6007314,name = "无情灵之晶核",pos = 7,stage = 14,color = 3,strong = 100,base_attr = [{3,3649},{5,1826}],extra_attr = [],suit = 0};

get_seal_equip_info(6007315) ->
	#base_seal_equip{id = 6007315,name = "暴怒灵之晶核",pos = 7,stage = 15,color = 3,strong = 100,base_attr = [{3,3905},{5,1953}],extra_attr = [],suit = 0};

get_seal_equip_info(6007316) ->
	#base_seal_equip{id = 6007316,name = "残忍灵之晶核",pos = 7,stage = 16,color = 3,strong = 100,base_attr = [{3,4504},{5,2252}],extra_attr = [],suit = 0};

get_seal_equip_info(6007317) ->
	#base_seal_equip{id = 6007317,name = "冷酷灵之晶核",pos = 7,stage = 17,color = 3,strong = 100,base_attr = [{3,4764},{5,2383}],extra_attr = [],suit = 0};

get_seal_equip_info(6007318) ->
	#base_seal_equip{id = 6007318,name = "利刃灵之晶核",pos = 7,stage = 18,color = 3,strong = 100,base_attr = [{3,5373},{5,2687}],extra_attr = [],suit = 0};

get_seal_equip_info(6007404) ->
	#base_seal_equip{id = 6007404,name = "幽魅灵之晶核",pos = 7,stage = 4,color = 4,strong = 100,base_attr = [{3,403},{5,202}],extra_attr = [],suit = 4041};

get_seal_equip_info(6007405) ->
	#base_seal_equip{id = 6007405,name = "复仇灵之晶核",pos = 7,stage = 5,color = 4,strong = 100,base_attr = [{3,691},{5,346}],extra_attr = [],suit = 4051};

get_seal_equip_info(6007406) ->
	#base_seal_equip{id = 6007406,name = "毁灭灵之晶核",pos = 7,stage = 6,color = 4,strong = 100,base_attr = [{3,975},{5,488}],extra_attr = [],suit = 4061};

get_seal_equip_info(6007407) ->
	#base_seal_equip{id = 6007407,name = "灾变灵之晶核",pos = 7,stage = 7,color = 4,strong = 100,base_attr = [{3,1392},{5,696}],extra_attr = [],suit = 4071};

get_seal_equip_info(6007408) ->
	#base_seal_equip{id = 6007408,name = "恶毒灵之晶核",pos = 7,stage = 8,color = 4,strong = 100,base_attr = [{3,2361},{5,1181}],extra_attr = [],suit = 4081};

get_seal_equip_info(6007409) ->
	#base_seal_equip{id = 6007409,name = "腐蚀灵之晶核",pos = 7,stage = 9,color = 4,strong = 100,base_attr = [{3,2572},{5,1287}],extra_attr = [],suit = 4091};

get_seal_equip_info(6007410) ->
	#base_seal_equip{id = 6007410,name = "瘟疫灵之晶核",pos = 7,stage = 10,color = 4,strong = 100,base_attr = [{3,3516},{5,1758}],extra_attr = [],suit = 4101};

get_seal_equip_info(6007411) ->
	#base_seal_equip{id = 6007411,name = "无间灵之晶核",pos = 7,stage = 11,color = 4,strong = 100,base_attr = [{3,4019},{5,2011}],extra_attr = [],suit = 4111};

get_seal_equip_info(6007412) ->
	#base_seal_equip{id = 6007412,name = "虚空灵之晶核",pos = 7,stage = 12,color = 4,strong = 100,base_attr = [{3,5099},{5,2549}],extra_attr = [],suit = 4121};

get_seal_equip_info(6007413) ->
	#base_seal_equip{id = 6007413,name = "双煞灵之晶核",pos = 7,stage = 13,color = 4,strong = 100,base_attr = [{3,5693},{5,2847}],extra_attr = [],suit = 4131};

get_seal_equip_info(6007414) ->
	#base_seal_equip{id = 6007414,name = "坟冢灵之晶核",pos = 7,stage = 14,color = 4,strong = 100,base_attr = [{3,6951},{5,3475}],extra_attr = [],suit = 4141};

get_seal_equip_info(6007415) ->
	#base_seal_equip{id = 6007415,name = "梦魇灵之晶核",pos = 7,stage = 15,color = 4,strong = 100,base_attr = [{3,7635},{5,3817}],extra_attr = [],suit = 4151};

get_seal_equip_info(6007416) ->
	#base_seal_equip{id = 6007416,name = "碧魔灵之晶核",pos = 7,stage = 16,color = 4,strong = 100,base_attr = [{3,9074},{5,4537}],extra_attr = [],suit = 4161};

get_seal_equip_info(6007417) ->
	#base_seal_equip{id = 6007417,name = "炼狱灵之晶核",pos = 7,stage = 17,color = 4,strong = 100,base_attr = [{3,9846},{5,4923}],extra_attr = [],suit = 4171};

get_seal_equip_info(6007418) ->
	#base_seal_equip{id = 6007418,name = "吞天灵之晶核",pos = 7,stage = 18,color = 4,strong = 100,base_attr = [{3,11465},{5,5733}],extra_attr = [],suit = 4181};

get_seal_equip_info(6007507) ->
	#base_seal_equip{id = 6007507,name = "烈阳灵之晶核",pos = 7,stage = 7,color = 5,strong = 100,base_attr = [{3,3442},{5,1720}],extra_attr = [],suit = 5071};

get_seal_equip_info(6007508) ->
	#base_seal_equip{id = 6007508,name = "清秋灵之晶核",pos = 7,stage = 8,color = 5,strong = 100,base_attr = [{3,4559},{5,2279}],extra_attr = [],suit = 5081};

get_seal_equip_info(6007509) ->
	#base_seal_equip{id = 6007509,name = "北辰灵之晶核",pos = 7,stage = 9,color = 5,strong = 100,base_attr = [{3,4774},{5,2387}],extra_attr = [],suit = 5091};

get_seal_equip_info(6007510) ->
	#base_seal_equip{id = 6007510,name = "弦风灵之晶核",pos = 7,stage = 10,color = 5,strong = 100,base_attr = [{3,6055},{5,3027}],extra_attr = [],suit = 5101};

get_seal_equip_info(6007511) ->
	#base_seal_equip{id = 6007511,name = "水月灵之晶核",pos = 7,stage = 11,color = 5,strong = 100,base_attr = [{3,6761},{5,3380}],extra_attr = [],suit = 5111};

get_seal_equip_info(6007512) ->
	#base_seal_equip{id = 6007512,name = "熔火灵之晶核",pos = 7,stage = 12,color = 5,strong = 100,base_attr = [{3,8256},{5,4127}],extra_attr = [],suit = 5121};

get_seal_equip_info(6007513) ->
	#base_seal_equip{id = 6007513,name = "幽泣灵之晶核",pos = 7,stage = 13,color = 5,strong = 100,base_attr = [{3,9067},{5,4533}],extra_attr = [],suit = 5131};

get_seal_equip_info(6007514) ->
	#base_seal_equip{id = 6007514,name = "永夜灵之晶核",pos = 7,stage = 14,color = 5,strong = 100,base_attr = [{3,10775},{5,5387}],extra_attr = [],suit = 5141};

get_seal_equip_info(6007515) ->
	#base_seal_equip{id = 6007515,name = "荣光灵之晶核",pos = 7,stage = 15,color = 5,strong = 100,base_attr = [{3,11692},{5,5848}],extra_attr = [],suit = 5151};

get_seal_equip_info(6007516) ->
	#base_seal_equip{id = 6007516,name = "千锻灵之晶核",pos = 7,stage = 16,color = 5,strong = 100,base_attr = [{3,13615},{5,6807}],extra_attr = [],suit = 5161};

get_seal_equip_info(6007517) ->
	#base_seal_equip{id = 6007517,name = "琉璃灵之晶核",pos = 7,stage = 17,color = 5,strong = 100,base_attr = [{3,14532},{5,7268}],extra_attr = [],suit = 5171};

get_seal_equip_info(6007518) ->
	#base_seal_equip{id = 6007518,name = "织木灵之晶核",pos = 7,stage = 18,color = 5,strong = 100,base_attr = [{3,16455},{5,8229}],extra_attr = [],suit = 5181};

get_seal_equip_info(6007608) ->
	#base_seal_equip{id = 6007608,name = "暗灭灵之晶核",pos = 7,stage = 8,color = 7,strong = 100,base_attr = [{3,5726},{5,2863}],extra_attr = [],suit = 6081};

get_seal_equip_info(6007609) ->
	#base_seal_equip{id = 6007609,name = "梦长灵之晶核",pos = 7,stage = 9,color = 7,strong = 100,base_attr = [{3,6407},{5,3202}],extra_attr = [],suit = 6091};

get_seal_equip_info(6007610) ->
	#base_seal_equip{id = 6007610,name = "御空灵之晶核",pos = 7,stage = 10,color = 7,strong = 100,base_attr = [{3,7035},{5,3517}],extra_attr = [],suit = 6101};

get_seal_equip_info(6007611) ->
	#base_seal_equip{id = 6007611,name = "逸尘灵之晶核",pos = 7,stage = 11,color = 7,strong = 100,base_attr = [{3,8361},{5,4180}],extra_attr = [],suit = 6111};

get_seal_equip_info(6007612) ->
	#base_seal_equip{id = 6007612,name = "天狼灵之晶核",pos = 7,stage = 12,color = 7,strong = 100,base_attr = [{3,9074},{5,4537}],extra_attr = [],suit = 6121};

get_seal_equip_info(6007613) ->
	#base_seal_equip{id = 6007613,name = "天音灵之晶核",pos = 7,stage = 13,color = 7,strong = 100,base_attr = [{3,10565},{5,5282}],extra_attr = [],suit = 6131};

get_seal_equip_info(6007614) ->
	#base_seal_equip{id = 6007614,name = "天舞灵之晶核",pos = 7,stage = 14,color = 7,strong = 100,base_attr = [{3,11278},{5,5639}],extra_attr = [],suit = 6141};

get_seal_equip_info(6007615) ->
	#base_seal_equip{id = 6007615,name = "天琊灵之晶核",pos = 7,stage = 15,color = 7,strong = 100,base_attr = [{3,12769},{5,6386}],extra_attr = [],suit = 6151};

get_seal_equip_info(6007616) ->
	#base_seal_equip{id = 6007616,name = "天罚灵之晶核",pos = 7,stage = 16,color = 7,strong = 100,base_attr = [{3,17825},{5,8915}],extra_attr = [],suit = 6161};

get_seal_equip_info(6008304) ->
	#base_seal_equip{id = 6008304,name = "力量灵之脸具",pos = 8,stage = 4,color = 3,strong = 100,base_attr = [{1,227},{5,113}],extra_attr = [],suit = 0};

get_seal_equip_info(6008305) ->
	#base_seal_equip{id = 6008305,name = "愤怒灵之脸具",pos = 8,stage = 5,color = 3,strong = 100,base_attr = [{1,389},{5,194}],extra_attr = [],suit = 0};

get_seal_equip_info(6008306) ->
	#base_seal_equip{id = 6008306,name = "征服灵之脸具",pos = 8,stage = 6,color = 3,strong = 100,base_attr = [{1,548},{5,275}],extra_attr = [],suit = 0};

get_seal_equip_info(6008307) ->
	#base_seal_equip{id = 6008307,name = "无畏灵之脸具",pos = 8,stage = 7,color = 3,strong = 100,base_attr = [{1,784},{5,392}],extra_attr = [],suit = 0};

get_seal_equip_info(6008308) ->
	#base_seal_equip{id = 6008308,name = "冲锋灵之脸具",pos = 8,stage = 8,color = 3,strong = 100,base_attr = [{1,1328},{5,665}],extra_attr = [],suit = 0};

get_seal_equip_info(6008309) ->
	#base_seal_equip{id = 6008309,name = "卓越灵之脸具",pos = 8,stage = 9,color = 3,strong = 100,base_attr = [{1,1447},{5,724}],extra_attr = [],suit = 0};

get_seal_equip_info(6008310) ->
	#base_seal_equip{id = 6008310,name = "屠夫灵之脸具",pos = 8,stage = 10,color = 3,strong = 100,base_attr = [{1,1999},{5,1000}],extra_attr = [],suit = 0};

get_seal_equip_info(6008311) ->
	#base_seal_equip{id = 6008311,name = "野蛮灵之脸具",pos = 8,stage = 11,color = 3,strong = 100,base_attr = [{1,2245},{5,1122}],extra_attr = [],suit = 0};

get_seal_equip_info(6008312) ->
	#base_seal_equip{id = 6008312,name = "致命灵之脸具",pos = 8,stage = 12,color = 3,strong = 100,base_attr = [{1,2812},{5,1406}],extra_attr = [],suit = 0};

get_seal_equip_info(6008313) ->
	#base_seal_equip{id = 6008313,name = "狂怒灵之脸具",pos = 8,stage = 13,color = 3,strong = 100,base_attr = [{1,3063},{5,1531}],extra_attr = [],suit = 0};

get_seal_equip_info(6008314) ->
	#base_seal_equip{id = 6008314,name = "无情灵之脸具",pos = 8,stage = 14,color = 3,strong = 100,base_attr = [{1,3649},{5,1826}],extra_attr = [],suit = 0};

get_seal_equip_info(6008315) ->
	#base_seal_equip{id = 6008315,name = "暴怒灵之脸具",pos = 8,stage = 15,color = 3,strong = 100,base_attr = [{1,3905},{5,1953}],extra_attr = [],suit = 0};

get_seal_equip_info(6008316) ->
	#base_seal_equip{id = 6008316,name = "残忍灵之脸具",pos = 8,stage = 16,color = 3,strong = 100,base_attr = [{1,4504},{5,2252}],extra_attr = [],suit = 0};

get_seal_equip_info(6008317) ->
	#base_seal_equip{id = 6008317,name = "冷酷灵之脸具",pos = 8,stage = 17,color = 3,strong = 100,base_attr = [{1,4764},{5,2383}],extra_attr = [],suit = 0};

get_seal_equip_info(6008318) ->
	#base_seal_equip{id = 6008318,name = "利刃灵之脸具",pos = 8,stage = 18,color = 3,strong = 100,base_attr = [{1,5373},{5,2687}],extra_attr = [],suit = 0};

get_seal_equip_info(6008404) ->
	#base_seal_equip{id = 6008404,name = "幽魅灵之脸具",pos = 8,stage = 4,color = 4,strong = 100,base_attr = [{1,403},{5,202}],extra_attr = [],suit = 4041};

get_seal_equip_info(6008405) ->
	#base_seal_equip{id = 6008405,name = "复仇灵之脸具",pos = 8,stage = 5,color = 4,strong = 100,base_attr = [{1,691},{5,346}],extra_attr = [],suit = 4051};

get_seal_equip_info(6008406) ->
	#base_seal_equip{id = 6008406,name = "毁灭灵之脸具",pos = 8,stage = 6,color = 4,strong = 100,base_attr = [{1,975},{5,488}],extra_attr = [],suit = 4061};

get_seal_equip_info(6008407) ->
	#base_seal_equip{id = 6008407,name = "灾变灵之脸具",pos = 8,stage = 7,color = 4,strong = 100,base_attr = [{1,1392},{5,696}],extra_attr = [],suit = 4071};

get_seal_equip_info(6008408) ->
	#base_seal_equip{id = 6008408,name = "恶毒灵之脸具",pos = 8,stage = 8,color = 4,strong = 100,base_attr = [{1,2361},{5,1181}],extra_attr = [],suit = 4081};

get_seal_equip_info(6008409) ->
	#base_seal_equip{id = 6008409,name = "腐蚀灵之脸具",pos = 8,stage = 9,color = 4,strong = 100,base_attr = [{1,2572},{5,1287}],extra_attr = [],suit = 4091};

get_seal_equip_info(6008410) ->
	#base_seal_equip{id = 6008410,name = "瘟疫灵之脸具",pos = 8,stage = 10,color = 4,strong = 100,base_attr = [{1,3516},{5,1758}],extra_attr = [],suit = 4101};

get_seal_equip_info(6008411) ->
	#base_seal_equip{id = 6008411,name = "无间灵之脸具",pos = 8,stage = 11,color = 4,strong = 100,base_attr = [{1,4019},{5,2011}],extra_attr = [],suit = 4111};

get_seal_equip_info(6008412) ->
	#base_seal_equip{id = 6008412,name = "虚空灵之脸具",pos = 8,stage = 12,color = 4,strong = 100,base_attr = [{1,5099},{5,2549}],extra_attr = [],suit = 4121};

get_seal_equip_info(6008413) ->
	#base_seal_equip{id = 6008413,name = "双煞灵之脸具",pos = 8,stage = 13,color = 4,strong = 100,base_attr = [{1,5693},{5,2847}],extra_attr = [],suit = 4131};

get_seal_equip_info(6008414) ->
	#base_seal_equip{id = 6008414,name = "坟冢灵之脸具",pos = 8,stage = 14,color = 4,strong = 100,base_attr = [{1,6951},{5,3475}],extra_attr = [],suit = 4141};

get_seal_equip_info(6008415) ->
	#base_seal_equip{id = 6008415,name = "梦魇灵之脸具",pos = 8,stage = 15,color = 4,strong = 100,base_attr = [{1,7635},{5,3817}],extra_attr = [],suit = 4151};

get_seal_equip_info(6008416) ->
	#base_seal_equip{id = 6008416,name = "碧魔灵之脸具",pos = 8,stage = 16,color = 4,strong = 100,base_attr = [{1,9074},{5,4537}],extra_attr = [],suit = 4161};

get_seal_equip_info(6008417) ->
	#base_seal_equip{id = 6008417,name = "炼狱灵之脸具",pos = 8,stage = 17,color = 4,strong = 100,base_attr = [{1,9846},{5,4923}],extra_attr = [],suit = 4171};

get_seal_equip_info(6008418) ->
	#base_seal_equip{id = 6008418,name = "吞天灵之脸具",pos = 8,stage = 18,color = 4,strong = 100,base_attr = [{1,11465},{5,5733}],extra_attr = [],suit = 4181};

get_seal_equip_info(6008507) ->
	#base_seal_equip{id = 6008507,name = "烈阳灵之脸具",pos = 8,stage = 7,color = 5,strong = 100,base_attr = [{1,3442},{5,1720}],extra_attr = [],suit = 5071};

get_seal_equip_info(6008508) ->
	#base_seal_equip{id = 6008508,name = "清秋灵之脸具",pos = 8,stage = 8,color = 5,strong = 100,base_attr = [{1,4559},{5,2279}],extra_attr = [],suit = 5081};

get_seal_equip_info(6008509) ->
	#base_seal_equip{id = 6008509,name = "北辰灵之脸具",pos = 8,stage = 9,color = 5,strong = 100,base_attr = [{1,4774},{5,2387}],extra_attr = [],suit = 5091};

get_seal_equip_info(6008510) ->
	#base_seal_equip{id = 6008510,name = "弦风灵之脸具",pos = 8,stage = 10,color = 5,strong = 100,base_attr = [{1,6055},{5,3027}],extra_attr = [],suit = 5101};

get_seal_equip_info(6008511) ->
	#base_seal_equip{id = 6008511,name = "水月灵之脸具",pos = 8,stage = 11,color = 5,strong = 100,base_attr = [{1,6761},{5,3380}],extra_attr = [],suit = 5111};

get_seal_equip_info(6008512) ->
	#base_seal_equip{id = 6008512,name = "熔火灵之脸具",pos = 8,stage = 12,color = 5,strong = 100,base_attr = [{1,8256},{5,4127}],extra_attr = [],suit = 5121};

get_seal_equip_info(6008513) ->
	#base_seal_equip{id = 6008513,name = "幽泣灵之脸具",pos = 8,stage = 13,color = 5,strong = 100,base_attr = [{1,9067},{5,4533}],extra_attr = [],suit = 5131};

get_seal_equip_info(6008514) ->
	#base_seal_equip{id = 6008514,name = "永夜灵之脸具",pos = 8,stage = 14,color = 5,strong = 100,base_attr = [{1,10775},{5,5387}],extra_attr = [],suit = 5141};

get_seal_equip_info(6008515) ->
	#base_seal_equip{id = 6008515,name = "荣光灵之脸具",pos = 8,stage = 15,color = 5,strong = 100,base_attr = [{1,11692},{5,5848}],extra_attr = [],suit = 5151};

get_seal_equip_info(6008516) ->
	#base_seal_equip{id = 6008516,name = "千锻灵之脸具",pos = 8,stage = 16,color = 5,strong = 100,base_attr = [{1,13615},{5,6807}],extra_attr = [],suit = 5161};

get_seal_equip_info(6008517) ->
	#base_seal_equip{id = 6008517,name = "琉璃灵之脸具",pos = 8,stage = 17,color = 5,strong = 100,base_attr = [{1,14532},{5,7268}],extra_attr = [],suit = 5171};

get_seal_equip_info(6008518) ->
	#base_seal_equip{id = 6008518,name = "织木灵之脸具",pos = 8,stage = 18,color = 5,strong = 100,base_attr = [{1,16455},{5,8229}],extra_attr = [],suit = 5181};

get_seal_equip_info(6008608) ->
	#base_seal_equip{id = 6008608,name = "暗灭灵之脸具",pos = 8,stage = 8,color = 7,strong = 100,base_attr = [{1,5726},{5,2863}],extra_attr = [],suit = 6081};

get_seal_equip_info(6008609) ->
	#base_seal_equip{id = 6008609,name = "梦长灵之脸具",pos = 8,stage = 9,color = 7,strong = 100,base_attr = [{1,6407},{5,3202}],extra_attr = [],suit = 6091};

get_seal_equip_info(6008610) ->
	#base_seal_equip{id = 6008610,name = "御空灵之脸具",pos = 8,stage = 10,color = 7,strong = 100,base_attr = [{1,7035},{5,3517}],extra_attr = [],suit = 6101};

get_seal_equip_info(6008611) ->
	#base_seal_equip{id = 6008611,name = "逸尘灵之脸具",pos = 8,stage = 11,color = 7,strong = 100,base_attr = [{1,8361},{5,4180}],extra_attr = [],suit = 6111};

get_seal_equip_info(6008612) ->
	#base_seal_equip{id = 6008612,name = "天狼灵之脸具",pos = 8,stage = 12,color = 7,strong = 100,base_attr = [{1,9074},{5,4537}],extra_attr = [],suit = 6121};

get_seal_equip_info(6008613) ->
	#base_seal_equip{id = 6008613,name = "天音灵之脸具",pos = 8,stage = 13,color = 7,strong = 100,base_attr = [{1,10565},{5,5282}],extra_attr = [],suit = 6131};

get_seal_equip_info(6008614) ->
	#base_seal_equip{id = 6008614,name = "天舞灵之脸具",pos = 8,stage = 14,color = 7,strong = 100,base_attr = [{1,11278},{5,5639}],extra_attr = [],suit = 6141};

get_seal_equip_info(6008615) ->
	#base_seal_equip{id = 6008615,name = "天琊灵之脸具",pos = 8,stage = 15,color = 7,strong = 100,base_attr = [{1,12769},{5,6386}],extra_attr = [],suit = 6151};

get_seal_equip_info(6008616) ->
	#base_seal_equip{id = 6008616,name = "天罚灵之脸具",pos = 8,stage = 16,color = 7,strong = 100,base_attr = [{1,17825},{5,8915}],extra_attr = [],suit = 6161};

get_seal_equip_info(6009304) ->
	#base_seal_equip{id = 6009304,name = "力量灵之项链",pos = 9,stage = 4,color = 3,strong = 100,base_attr = [{1,227},{7,113}],extra_attr = [],suit = 0};

get_seal_equip_info(6009305) ->
	#base_seal_equip{id = 6009305,name = "愤怒灵之项链",pos = 9,stage = 5,color = 3,strong = 100,base_attr = [{1,389},{7,194}],extra_attr = [],suit = 0};

get_seal_equip_info(6009306) ->
	#base_seal_equip{id = 6009306,name = "征服灵之项链",pos = 9,stage = 6,color = 3,strong = 100,base_attr = [{1,548},{7,275}],extra_attr = [],suit = 0};

get_seal_equip_info(6009307) ->
	#base_seal_equip{id = 6009307,name = "无畏灵之项链",pos = 9,stage = 7,color = 3,strong = 100,base_attr = [{1,784},{7,392}],extra_attr = [],suit = 0};

get_seal_equip_info(6009308) ->
	#base_seal_equip{id = 6009308,name = "冲锋灵之项链",pos = 9,stage = 8,color = 3,strong = 100,base_attr = [{1,1328},{7,665}],extra_attr = [],suit = 0};

get_seal_equip_info(6009309) ->
	#base_seal_equip{id = 6009309,name = "卓越灵之项链",pos = 9,stage = 9,color = 3,strong = 100,base_attr = [{1,1447},{7,724}],extra_attr = [],suit = 0};

get_seal_equip_info(6009310) ->
	#base_seal_equip{id = 6009310,name = "屠夫灵之项链",pos = 9,stage = 10,color = 3,strong = 100,base_attr = [{1,1999},{7,1000}],extra_attr = [],suit = 0};

get_seal_equip_info(6009311) ->
	#base_seal_equip{id = 6009311,name = "野蛮灵之项链",pos = 9,stage = 11,color = 3,strong = 100,base_attr = [{1,2245},{7,1122}],extra_attr = [],suit = 0};

get_seal_equip_info(6009312) ->
	#base_seal_equip{id = 6009312,name = "致命灵之项链",pos = 9,stage = 12,color = 3,strong = 100,base_attr = [{1,2812},{7,1406}],extra_attr = [],suit = 0};

get_seal_equip_info(6009313) ->
	#base_seal_equip{id = 6009313,name = "狂怒灵之项链",pos = 9,stage = 13,color = 3,strong = 100,base_attr = [{1,3063},{7,1531}],extra_attr = [],suit = 0};

get_seal_equip_info(6009314) ->
	#base_seal_equip{id = 6009314,name = "无情灵之项链",pos = 9,stage = 14,color = 3,strong = 100,base_attr = [{1,3649},{7,1826}],extra_attr = [],suit = 0};

get_seal_equip_info(6009315) ->
	#base_seal_equip{id = 6009315,name = "暴怒灵之项链",pos = 9,stage = 15,color = 3,strong = 100,base_attr = [{1,3905},{7,1953}],extra_attr = [],suit = 0};

get_seal_equip_info(6009316) ->
	#base_seal_equip{id = 6009316,name = "残忍灵之项链",pos = 9,stage = 16,color = 3,strong = 100,base_attr = [{1,4504},{7,2252}],extra_attr = [],suit = 0};

get_seal_equip_info(6009317) ->
	#base_seal_equip{id = 6009317,name = "冷酷灵之项链",pos = 9,stage = 17,color = 3,strong = 100,base_attr = [{1,4764},{7,2383}],extra_attr = [],suit = 0};

get_seal_equip_info(6009318) ->
	#base_seal_equip{id = 6009318,name = "利刃灵之项链",pos = 9,stage = 18,color = 3,strong = 100,base_attr = [{1,5373},{7,2687}],extra_attr = [],suit = 0};

get_seal_equip_info(6009404) ->
	#base_seal_equip{id = 6009404,name = "幽魅灵之项链",pos = 9,stage = 4,color = 4,strong = 100,base_attr = [{1,403},{7,202}],extra_attr = [],suit = 4041};

get_seal_equip_info(6009405) ->
	#base_seal_equip{id = 6009405,name = "复仇灵之项链",pos = 9,stage = 5,color = 4,strong = 100,base_attr = [{1,691},{7,346}],extra_attr = [],suit = 4051};

get_seal_equip_info(6009406) ->
	#base_seal_equip{id = 6009406,name = "毁灭灵之项链",pos = 9,stage = 6,color = 4,strong = 100,base_attr = [{1,975},{7,488}],extra_attr = [],suit = 4061};

get_seal_equip_info(6009407) ->
	#base_seal_equip{id = 6009407,name = "灾变灵之项链",pos = 9,stage = 7,color = 4,strong = 100,base_attr = [{1,1392},{7,696}],extra_attr = [],suit = 4071};

get_seal_equip_info(6009408) ->
	#base_seal_equip{id = 6009408,name = "恶毒灵之项链",pos = 9,stage = 8,color = 4,strong = 100,base_attr = [{1,2361},{7,1181}],extra_attr = [],suit = 4081};

get_seal_equip_info(6009409) ->
	#base_seal_equip{id = 6009409,name = "腐蚀灵之项链",pos = 9,stage = 9,color = 4,strong = 100,base_attr = [{1,2572},{7,1287}],extra_attr = [],suit = 4091};

get_seal_equip_info(6009410) ->
	#base_seal_equip{id = 6009410,name = "瘟疫灵之项链",pos = 9,stage = 10,color = 4,strong = 100,base_attr = [{1,3516},{7,1758}],extra_attr = [],suit = 4101};

get_seal_equip_info(6009411) ->
	#base_seal_equip{id = 6009411,name = "无间灵之项链",pos = 9,stage = 11,color = 4,strong = 100,base_attr = [{1,4019},{7,2011}],extra_attr = [],suit = 4111};

get_seal_equip_info(6009412) ->
	#base_seal_equip{id = 6009412,name = "虚空灵之项链",pos = 9,stage = 12,color = 4,strong = 100,base_attr = [{1,5099},{7,2549}],extra_attr = [],suit = 4121};

get_seal_equip_info(6009413) ->
	#base_seal_equip{id = 6009413,name = "双煞灵之项链",pos = 9,stage = 13,color = 4,strong = 100,base_attr = [{1,5693},{7,2847}],extra_attr = [],suit = 4131};

get_seal_equip_info(6009414) ->
	#base_seal_equip{id = 6009414,name = "坟冢灵之项链",pos = 9,stage = 14,color = 4,strong = 100,base_attr = [{1,6951},{7,3475}],extra_attr = [],suit = 4141};

get_seal_equip_info(6009415) ->
	#base_seal_equip{id = 6009415,name = "梦魇灵之项链",pos = 9,stage = 15,color = 4,strong = 100,base_attr = [{1,7635},{7,3817}],extra_attr = [],suit = 4151};

get_seal_equip_info(6009416) ->
	#base_seal_equip{id = 6009416,name = "碧魔灵之项链",pos = 9,stage = 16,color = 4,strong = 100,base_attr = [{1,9074},{7,4537}],extra_attr = [],suit = 4161};

get_seal_equip_info(6009417) ->
	#base_seal_equip{id = 6009417,name = "炼狱灵之项链",pos = 9,stage = 17,color = 4,strong = 100,base_attr = [{1,9846},{7,4923}],extra_attr = [],suit = 4171};

get_seal_equip_info(6009418) ->
	#base_seal_equip{id = 6009418,name = "吞天灵之项链",pos = 9,stage = 18,color = 4,strong = 100,base_attr = [{1,11465},{7,5733}],extra_attr = [],suit = 4181};

get_seal_equip_info(6009507) ->
	#base_seal_equip{id = 6009507,name = "烈阳灵之项链",pos = 9,stage = 7,color = 5,strong = 100,base_attr = [{1,3442},{7,1720}],extra_attr = [],suit = 5071};

get_seal_equip_info(6009508) ->
	#base_seal_equip{id = 6009508,name = "清秋灵之项链",pos = 9,stage = 8,color = 5,strong = 100,base_attr = [{1,4559},{7,2279}],extra_attr = [],suit = 5081};

get_seal_equip_info(6009509) ->
	#base_seal_equip{id = 6009509,name = "北辰灵之项链",pos = 9,stage = 9,color = 5,strong = 100,base_attr = [{1,4774},{7,2387}],extra_attr = [],suit = 5091};

get_seal_equip_info(6009510) ->
	#base_seal_equip{id = 6009510,name = "弦风灵之项链",pos = 9,stage = 10,color = 5,strong = 100,base_attr = [{1,6055},{7,3027}],extra_attr = [],suit = 5101};

get_seal_equip_info(6009511) ->
	#base_seal_equip{id = 6009511,name = "水月灵之项链",pos = 9,stage = 11,color = 5,strong = 100,base_attr = [{1,6761},{7,3380}],extra_attr = [],suit = 5111};

get_seal_equip_info(6009512) ->
	#base_seal_equip{id = 6009512,name = "熔火灵之项链",pos = 9,stage = 12,color = 5,strong = 100,base_attr = [{1,8256},{7,4127}],extra_attr = [],suit = 5121};

get_seal_equip_info(6009513) ->
	#base_seal_equip{id = 6009513,name = "幽泣灵之项链",pos = 9,stage = 13,color = 5,strong = 100,base_attr = [{1,9067},{7,4533}],extra_attr = [],suit = 5131};

get_seal_equip_info(6009514) ->
	#base_seal_equip{id = 6009514,name = "永夜灵之项链",pos = 9,stage = 14,color = 5,strong = 100,base_attr = [{1,10775},{7,5387}],extra_attr = [],suit = 5141};

get_seal_equip_info(6009515) ->
	#base_seal_equip{id = 6009515,name = "荣光灵之项链",pos = 9,stage = 15,color = 5,strong = 100,base_attr = [{1,11692},{7,5848}],extra_attr = [],suit = 5151};

get_seal_equip_info(6009516) ->
	#base_seal_equip{id = 6009516,name = "千锻灵之项链",pos = 9,stage = 16,color = 5,strong = 100,base_attr = [{1,13615},{7,6807}],extra_attr = [],suit = 5161};

get_seal_equip_info(6009517) ->
	#base_seal_equip{id = 6009517,name = "琉璃灵之项链",pos = 9,stage = 17,color = 5,strong = 100,base_attr = [{1,14532},{7,7268}],extra_attr = [],suit = 5171};

get_seal_equip_info(6009518) ->
	#base_seal_equip{id = 6009518,name = "织木灵之项链",pos = 9,stage = 18,color = 5,strong = 100,base_attr = [{1,16455},{7,8229}],extra_attr = [],suit = 5181};

get_seal_equip_info(6009608) ->
	#base_seal_equip{id = 6009608,name = "暗灭灵之项链",pos = 9,stage = 8,color = 7,strong = 100,base_attr = [{1,5726},{7,2863}],extra_attr = [],suit = 6081};

get_seal_equip_info(6009609) ->
	#base_seal_equip{id = 6009609,name = "梦长灵之项链",pos = 9,stage = 9,color = 7,strong = 100,base_attr = [{1,6407},{7,3202}],extra_attr = [],suit = 6091};

get_seal_equip_info(6009610) ->
	#base_seal_equip{id = 6009610,name = "御空灵之项链",pos = 9,stage = 10,color = 7,strong = 100,base_attr = [{1,7035},{7,3517}],extra_attr = [],suit = 6101};

get_seal_equip_info(6009611) ->
	#base_seal_equip{id = 6009611,name = "逸尘灵之项链",pos = 9,stage = 11,color = 7,strong = 100,base_attr = [{1,8361},{7,4180}],extra_attr = [],suit = 6111};

get_seal_equip_info(6009612) ->
	#base_seal_equip{id = 6009612,name = "天狼灵之项链",pos = 9,stage = 12,color = 7,strong = 100,base_attr = [{1,9074},{7,4537}],extra_attr = [],suit = 6121};

get_seal_equip_info(6009613) ->
	#base_seal_equip{id = 6009613,name = "天音灵之项链",pos = 9,stage = 13,color = 7,strong = 100,base_attr = [{1,10565},{7,5282}],extra_attr = [],suit = 6131};

get_seal_equip_info(6009614) ->
	#base_seal_equip{id = 6009614,name = "天舞灵之项链",pos = 9,stage = 14,color = 7,strong = 100,base_attr = [{1,11278},{7,5639}],extra_attr = [],suit = 6141};

get_seal_equip_info(6009615) ->
	#base_seal_equip{id = 6009615,name = "天琊灵之项链",pos = 9,stage = 15,color = 7,strong = 100,base_attr = [{1,12769},{7,6386}],extra_attr = [],suit = 6151};

get_seal_equip_info(6009616) ->
	#base_seal_equip{id = 6009616,name = "天罚灵之项链",pos = 9,stage = 16,color = 7,strong = 100,base_attr = [{1,17825},{7,8915}],extra_attr = [],suit = 6161};

get_seal_equip_info(6010304) ->
	#base_seal_equip{id = 6010304,name = "力量灵之戒指",pos = 10,stage = 4,color = 3,strong = 100,base_attr = [{3,227},{7,113}],extra_attr = [],suit = 0};

get_seal_equip_info(6010305) ->
	#base_seal_equip{id = 6010305,name = "愤怒灵之戒指",pos = 10,stage = 5,color = 3,strong = 100,base_attr = [{3,389},{7,194}],extra_attr = [],suit = 0};

get_seal_equip_info(6010306) ->
	#base_seal_equip{id = 6010306,name = "征服灵之戒指",pos = 10,stage = 6,color = 3,strong = 100,base_attr = [{3,548},{7,275}],extra_attr = [],suit = 0};

get_seal_equip_info(6010307) ->
	#base_seal_equip{id = 6010307,name = "无畏灵之戒指",pos = 10,stage = 7,color = 3,strong = 100,base_attr = [{3,784},{7,392}],extra_attr = [],suit = 0};

get_seal_equip_info(6010308) ->
	#base_seal_equip{id = 6010308,name = "冲锋灵之戒指",pos = 10,stage = 8,color = 3,strong = 100,base_attr = [{3,1328},{7,665}],extra_attr = [],suit = 0};

get_seal_equip_info(6010309) ->
	#base_seal_equip{id = 6010309,name = "卓越灵之戒指",pos = 10,stage = 9,color = 3,strong = 100,base_attr = [{3,1447},{7,724}],extra_attr = [],suit = 0};

get_seal_equip_info(6010310) ->
	#base_seal_equip{id = 6010310,name = "屠夫灵之戒指",pos = 10,stage = 10,color = 3,strong = 100,base_attr = [{3,1999},{7,1000}],extra_attr = [],suit = 0};

get_seal_equip_info(6010311) ->
	#base_seal_equip{id = 6010311,name = "野蛮灵之戒指",pos = 10,stage = 11,color = 3,strong = 100,base_attr = [{3,2245},{7,1122}],extra_attr = [],suit = 0};

get_seal_equip_info(6010312) ->
	#base_seal_equip{id = 6010312,name = "致命灵之戒指",pos = 10,stage = 12,color = 3,strong = 100,base_attr = [{3,2812},{7,1406}],extra_attr = [],suit = 0};

get_seal_equip_info(6010313) ->
	#base_seal_equip{id = 6010313,name = "狂怒灵之戒指",pos = 10,stage = 13,color = 3,strong = 100,base_attr = [{3,3063},{7,1531}],extra_attr = [],suit = 0};

get_seal_equip_info(6010314) ->
	#base_seal_equip{id = 6010314,name = "无情灵之戒指",pos = 10,stage = 14,color = 3,strong = 100,base_attr = [{3,3649},{7,1826}],extra_attr = [],suit = 0};

get_seal_equip_info(6010315) ->
	#base_seal_equip{id = 6010315,name = "暴怒灵之戒指",pos = 10,stage = 15,color = 3,strong = 100,base_attr = [{3,3905},{7,1953}],extra_attr = [],suit = 0};

get_seal_equip_info(6010316) ->
	#base_seal_equip{id = 6010316,name = "残忍灵之戒指",pos = 10,stage = 16,color = 3,strong = 100,base_attr = [{3,4504},{7,2252}],extra_attr = [],suit = 0};

get_seal_equip_info(6010317) ->
	#base_seal_equip{id = 6010317,name = "冷酷灵之戒指",pos = 10,stage = 17,color = 3,strong = 100,base_attr = [{3,4764},{7,2383}],extra_attr = [],suit = 0};

get_seal_equip_info(6010318) ->
	#base_seal_equip{id = 6010318,name = "利刃灵之戒指",pos = 10,stage = 18,color = 3,strong = 100,base_attr = [{3,5373},{7,2687}],extra_attr = [],suit = 0};

get_seal_equip_info(6010404) ->
	#base_seal_equip{id = 6010404,name = "幽魅灵之戒指",pos = 10,stage = 4,color = 4,strong = 100,base_attr = [{3,403},{7,202}],extra_attr = [],suit = 4041};

get_seal_equip_info(6010405) ->
	#base_seal_equip{id = 6010405,name = "复仇灵之戒指",pos = 10,stage = 5,color = 4,strong = 100,base_attr = [{3,691},{7,346}],extra_attr = [],suit = 4051};

get_seal_equip_info(6010406) ->
	#base_seal_equip{id = 6010406,name = "毁灭灵之戒指",pos = 10,stage = 6,color = 4,strong = 100,base_attr = [{3,975},{7,488}],extra_attr = [],suit = 4061};

get_seal_equip_info(6010407) ->
	#base_seal_equip{id = 6010407,name = "灾变灵之戒指",pos = 10,stage = 7,color = 4,strong = 100,base_attr = [{3,1392},{7,696}],extra_attr = [],suit = 4071};

get_seal_equip_info(6010408) ->
	#base_seal_equip{id = 6010408,name = "恶毒灵之戒指",pos = 10,stage = 8,color = 4,strong = 100,base_attr = [{3,2361},{7,1181}],extra_attr = [],suit = 4081};

get_seal_equip_info(6010409) ->
	#base_seal_equip{id = 6010409,name = "腐蚀灵之戒指",pos = 10,stage = 9,color = 4,strong = 100,base_attr = [{3,2572},{7,1287}],extra_attr = [],suit = 4091};

get_seal_equip_info(6010410) ->
	#base_seal_equip{id = 6010410,name = "瘟疫灵之戒指",pos = 10,stage = 10,color = 4,strong = 100,base_attr = [{3,3516},{7,1758}],extra_attr = [],suit = 4101};

get_seal_equip_info(6010411) ->
	#base_seal_equip{id = 6010411,name = "无间灵之戒指",pos = 10,stage = 11,color = 4,strong = 100,base_attr = [{3,4019},{7,2011}],extra_attr = [],suit = 4111};

get_seal_equip_info(6010412) ->
	#base_seal_equip{id = 6010412,name = "虚空灵之戒指",pos = 10,stage = 12,color = 4,strong = 100,base_attr = [{3,5099},{7,2549}],extra_attr = [],suit = 4121};

get_seal_equip_info(6010413) ->
	#base_seal_equip{id = 6010413,name = "双煞灵之戒指",pos = 10,stage = 13,color = 4,strong = 100,base_attr = [{3,5693},{7,2847}],extra_attr = [],suit = 4131};

get_seal_equip_info(6010414) ->
	#base_seal_equip{id = 6010414,name = "坟冢灵之戒指",pos = 10,stage = 14,color = 4,strong = 100,base_attr = [{3,6951},{7,3475}],extra_attr = [],suit = 4141};

get_seal_equip_info(6010415) ->
	#base_seal_equip{id = 6010415,name = "梦魇灵之戒指",pos = 10,stage = 15,color = 4,strong = 100,base_attr = [{3,7635},{7,3817}],extra_attr = [],suit = 4151};

get_seal_equip_info(6010416) ->
	#base_seal_equip{id = 6010416,name = "碧魔灵之戒指",pos = 10,stage = 16,color = 4,strong = 100,base_attr = [{3,9074},{7,4537}],extra_attr = [],suit = 4161};

get_seal_equip_info(6010417) ->
	#base_seal_equip{id = 6010417,name = "炼狱灵之戒指",pos = 10,stage = 17,color = 4,strong = 100,base_attr = [{3,9846},{7,4923}],extra_attr = [],suit = 4171};

get_seal_equip_info(6010418) ->
	#base_seal_equip{id = 6010418,name = "吞天灵之戒指",pos = 10,stage = 18,color = 4,strong = 100,base_attr = [{3,11465},{7,5733}],extra_attr = [],suit = 4181};

get_seal_equip_info(6010507) ->
	#base_seal_equip{id = 6010507,name = "烈阳灵之戒指",pos = 10,stage = 7,color = 5,strong = 100,base_attr = [{3,3442},{7,1720}],extra_attr = [],suit = 5071};

get_seal_equip_info(6010508) ->
	#base_seal_equip{id = 6010508,name = "清秋灵之戒指",pos = 10,stage = 8,color = 5,strong = 100,base_attr = [{3,4559},{7,2279}],extra_attr = [],suit = 5081};

get_seal_equip_info(6010509) ->
	#base_seal_equip{id = 6010509,name = "北辰灵之戒指",pos = 10,stage = 9,color = 5,strong = 100,base_attr = [{3,4774},{7,2387}],extra_attr = [],suit = 5091};

get_seal_equip_info(6010510) ->
	#base_seal_equip{id = 6010510,name = "弦风灵之戒指",pos = 10,stage = 10,color = 5,strong = 100,base_attr = [{3,6055},{7,3027}],extra_attr = [],suit = 5101};

get_seal_equip_info(6010511) ->
	#base_seal_equip{id = 6010511,name = "水月灵之戒指",pos = 10,stage = 11,color = 5,strong = 100,base_attr = [{3,6761},{7,3380}],extra_attr = [],suit = 5111};

get_seal_equip_info(6010512) ->
	#base_seal_equip{id = 6010512,name = "熔火灵之戒指",pos = 10,stage = 12,color = 5,strong = 100,base_attr = [{3,8256},{7,4127}],extra_attr = [],suit = 5121};

get_seal_equip_info(6010513) ->
	#base_seal_equip{id = 6010513,name = "幽泣灵之戒指",pos = 10,stage = 13,color = 5,strong = 100,base_attr = [{3,9067},{7,4533}],extra_attr = [],suit = 5131};

get_seal_equip_info(6010514) ->
	#base_seal_equip{id = 6010514,name = "永夜灵之戒指",pos = 10,stage = 14,color = 5,strong = 100,base_attr = [{3,10775},{7,5387}],extra_attr = [],suit = 5141};

get_seal_equip_info(6010515) ->
	#base_seal_equip{id = 6010515,name = "荣光灵之戒指",pos = 10,stage = 15,color = 5,strong = 100,base_attr = [{3,11692},{7,5848}],extra_attr = [],suit = 5151};

get_seal_equip_info(6010516) ->
	#base_seal_equip{id = 6010516,name = "千锻灵之戒指",pos = 10,stage = 16,color = 5,strong = 100,base_attr = [{3,13615},{7,6807}],extra_attr = [],suit = 5161};

get_seal_equip_info(6010517) ->
	#base_seal_equip{id = 6010517,name = "琉璃灵之戒指",pos = 10,stage = 17,color = 5,strong = 100,base_attr = [{3,14532},{7,7268}],extra_attr = [],suit = 5171};

get_seal_equip_info(6010518) ->
	#base_seal_equip{id = 6010518,name = "织木灵之戒指",pos = 10,stage = 18,color = 5,strong = 100,base_attr = [{3,16455},{7,8229}],extra_attr = [],suit = 5181};

get_seal_equip_info(6010608) ->
	#base_seal_equip{id = 6010608,name = "暗灭灵之戒指",pos = 10,stage = 8,color = 7,strong = 100,base_attr = [{3,5726},{7,2863}],extra_attr = [],suit = 6081};

get_seal_equip_info(6010609) ->
	#base_seal_equip{id = 6010609,name = "梦长灵之戒指",pos = 10,stage = 9,color = 7,strong = 100,base_attr = [{3,6407},{7,3202}],extra_attr = [],suit = 6091};

get_seal_equip_info(6010610) ->
	#base_seal_equip{id = 6010610,name = "御空灵之戒指",pos = 10,stage = 10,color = 7,strong = 100,base_attr = [{3,7035},{7,3517}],extra_attr = [],suit = 6101};

get_seal_equip_info(6010611) ->
	#base_seal_equip{id = 6010611,name = "逸尘灵之戒指",pos = 10,stage = 11,color = 7,strong = 100,base_attr = [{3,8361},{7,4180}],extra_attr = [],suit = 6111};

get_seal_equip_info(6010612) ->
	#base_seal_equip{id = 6010612,name = "天狼灵之戒指",pos = 10,stage = 12,color = 7,strong = 100,base_attr = [{3,9074},{7,4537}],extra_attr = [],suit = 6121};

get_seal_equip_info(6010613) ->
	#base_seal_equip{id = 6010613,name = "天音灵之戒指",pos = 10,stage = 13,color = 7,strong = 100,base_attr = [{3,10565},{7,5282}],extra_attr = [],suit = 6131};

get_seal_equip_info(6010614) ->
	#base_seal_equip{id = 6010614,name = "天舞灵之戒指",pos = 10,stage = 14,color = 7,strong = 100,base_attr = [{3,11278},{7,5639}],extra_attr = [],suit = 6141};

get_seal_equip_info(6010615) ->
	#base_seal_equip{id = 6010615,name = "天琊灵之戒指",pos = 10,stage = 15,color = 7,strong = 100,base_attr = [{3,12769},{7,6386}],extra_attr = [],suit = 6151};

get_seal_equip_info(6010616) ->
	#base_seal_equip{id = 6010616,name = "天罚灵之戒指",pos = 10,stage = 16,color = 7,strong = 100,base_attr = [{3,17825},{7,8915}],extra_attr = [],suit = 6161};

get_seal_equip_info(6011304) ->
	#base_seal_equip{id = 6011304,name = "力量神之圣器",pos = 11,stage = 4,color = 3,strong = 100,base_attr = [{1,455},{2,2275}],extra_attr = [],suit = 0};

get_seal_equip_info(6011305) ->
	#base_seal_equip{id = 6011305,name = "愤怒神之圣器",pos = 11,stage = 5,color = 3,strong = 100,base_attr = [{1,778},{2,3888}],extra_attr = [],suit = 0};

get_seal_equip_info(6011306) ->
	#base_seal_equip{id = 6011306,name = "征服神之圣器",pos = 11,stage = 6,color = 3,strong = 100,base_attr = [{1,1097},{2,5495}],extra_attr = [],suit = 0};

get_seal_equip_info(6011307) ->
	#base_seal_equip{id = 6011307,name = "无畏神之圣器",pos = 11,stage = 7,color = 3,strong = 100,base_attr = [{1,1566},{2,7834}],extra_attr = [],suit = 0};

get_seal_equip_info(6011308) ->
	#base_seal_equip{id = 6011308,name = "冲锋神之圣器",pos = 11,stage = 8,color = 3,strong = 100,base_attr = [{1,2657},{2,13293}],extra_attr = [],suit = 0};

get_seal_equip_info(6011309) ->
	#base_seal_equip{id = 6011309,name = "卓越神之圣器",pos = 11,stage = 9,color = 3,strong = 100,base_attr = [{1,2894},{2,14473}],extra_attr = [],suit = 0};

get_seal_equip_info(6011310) ->
	#base_seal_equip{id = 6011310,name = "屠夫神之圣器",pos = 11,stage = 10,color = 3,strong = 100,base_attr = [{1,3999},{2,19994}],extra_attr = [],suit = 0};

get_seal_equip_info(6011311) ->
	#base_seal_equip{id = 6011311,name = "野蛮神之圣器",pos = 11,stage = 11,color = 3,strong = 100,base_attr = [{1,4490},{2,22447}],extra_attr = [],suit = 0};

get_seal_equip_info(6011312) ->
	#base_seal_equip{id = 6011312,name = "致命神之圣器",pos = 11,stage = 12,color = 3,strong = 100,base_attr = [{1,5623},{2,28127}],extra_attr = [],suit = 0};

get_seal_equip_info(6011313) ->
	#base_seal_equip{id = 6011313,name = "狂怒神之圣器",pos = 11,stage = 13,color = 3,strong = 100,base_attr = [{1,6126},{2,30627}],extra_attr = [],suit = 0};

get_seal_equip_info(6011314) ->
	#base_seal_equip{id = 6011314,name = "无情神之圣器",pos = 11,stage = 14,color = 3,strong = 100,base_attr = [{1,7300},{2,36511}],extra_attr = [],suit = 0};

get_seal_equip_info(6011315) ->
	#base_seal_equip{id = 6011315,name = "暴怒神之圣器",pos = 11,stage = 15,color = 3,strong = 100,base_attr = [{1,7811},{2,39056}],extra_attr = [],suit = 0};

get_seal_equip_info(6011316) ->
	#base_seal_equip{id = 6011316,name = "残忍神之圣器",pos = 11,stage = 16,color = 3,strong = 100,base_attr = [{1,9008},{2,45054}],extra_attr = [],suit = 0};

get_seal_equip_info(6011317) ->
	#base_seal_equip{id = 6011317,name = "冷酷神之圣器",pos = 11,stage = 17,color = 3,strong = 100,base_attr = [{1,9528},{2,47644}],extra_attr = [],suit = 0};

get_seal_equip_info(6011318) ->
	#base_seal_equip{id = 6011318,name = "利刃神之圣器",pos = 11,stage = 18,color = 3,strong = 100,base_attr = [{1,10747},{2,53733}],extra_attr = [],suit = 0};

get_seal_equip_info(6011404) ->
	#base_seal_equip{id = 6011404,name = "幽魅神之圣器",pos = 11,stage = 4,color = 4,strong = 100,base_attr = [{1,806},{2,4032}],extra_attr = [],suit = 4041};

get_seal_equip_info(6011405) ->
	#base_seal_equip{id = 6011405,name = "复仇神之圣器",pos = 11,stage = 5,color = 4,strong = 100,base_attr = [{1,1382},{2,6912}],extra_attr = [],suit = 4051};

get_seal_equip_info(6011406) ->
	#base_seal_equip{id = 6011406,name = "毁灭神之圣器",pos = 11,stage = 6,color = 4,strong = 100,base_attr = [{1,1949},{2,9746}],extra_attr = [],suit = 4061};

get_seal_equip_info(6011407) ->
	#base_seal_equip{id = 6011407,name = "灾变神之圣器",pos = 11,stage = 7,color = 4,strong = 100,base_attr = [{1,2786},{2,13926}],extra_attr = [],suit = 4071};

get_seal_equip_info(6011408) ->
	#base_seal_equip{id = 6011408,name = "恶毒神之圣器",pos = 11,stage = 8,color = 4,strong = 100,base_attr = [{1,4721},{2,23610}],extra_attr = [],suit = 4081};

get_seal_equip_info(6011409) ->
	#base_seal_equip{id = 6011409,name = "腐蚀神之圣器",pos = 11,stage = 9,color = 4,strong = 100,base_attr = [{1,5143},{2,25719}],extra_attr = [],suit = 4091};

get_seal_equip_info(6011410) ->
	#base_seal_equip{id = 6011410,name = "瘟疫神之圣器",pos = 11,stage = 10,color = 4,strong = 100,base_attr = [{1,7032},{2,35162}],extra_attr = [],suit = 4101};

get_seal_equip_info(6011411) ->
	#base_seal_equip{id = 6011411,name = "无间神之圣器",pos = 11,stage = 11,color = 4,strong = 100,base_attr = [{1,8040},{2,40197}],extra_attr = [],suit = 4111};

get_seal_equip_info(6011412) ->
	#base_seal_equip{id = 6011412,name = "虚空神之圣器",pos = 11,stage = 12,color = 4,strong = 100,base_attr = [{1,10198},{2,50988}],extra_attr = [],suit = 4121};

get_seal_equip_info(6011413) ->
	#base_seal_equip{id = 6011413,name = "双煞神之圣器",pos = 11,stage = 13,color = 4,strong = 100,base_attr = [{1,11386},{2,56924}],extra_attr = [],suit = 4131};

get_seal_equip_info(6011414) ->
	#base_seal_equip{id = 6011414,name = "坟冢神之圣器",pos = 11,stage = 14,color = 4,strong = 100,base_attr = [{1,13902},{2,69513}],extra_attr = [],suit = 4141};

get_seal_equip_info(6011415) ->
	#base_seal_equip{id = 6011415,name = "梦魇神之圣器",pos = 11,stage = 15,color = 4,strong = 100,base_attr = [{1,15271},{2,76348}],extra_attr = [],suit = 4151};

get_seal_equip_info(6011416) ->
	#base_seal_equip{id = 6011416,name = "碧魔神之圣器",pos = 11,stage = 16,color = 4,strong = 100,base_attr = [{1,18146},{2,90737}],extra_attr = [],suit = 4161};

get_seal_equip_info(6011417) ->
	#base_seal_equip{id = 6011417,name = "炼狱神之圣器",pos = 11,stage = 17,color = 4,strong = 100,base_attr = [{1,19694},{2,98470}],extra_attr = [],suit = 4171};

get_seal_equip_info(6011418) ->
	#base_seal_equip{id = 6011418,name = "吞天神之圣器",pos = 11,stage = 18,color = 4,strong = 100,base_attr = [{1,22932},{2,114656}],extra_attr = [],suit = 4181};

get_seal_equip_info(6011507) ->
	#base_seal_equip{id = 6011507,name = "烈阳神之圣器",pos = 11,stage = 7,color = 5,strong = 100,base_attr = [{1,6883},{2,34413}],extra_attr = [],suit = 5071};

get_seal_equip_info(6011508) ->
	#base_seal_equip{id = 6011508,name = "清秋神之圣器",pos = 11,stage = 8,color = 5,strong = 100,base_attr = [{1,9116},{2,45578}],extra_attr = [],suit = 5081};

get_seal_equip_info(6011509) ->
	#base_seal_equip{id = 6011509,name = "北辰神之圣器",pos = 11,stage = 9,color = 5,strong = 100,base_attr = [{1,9547},{2,47733}],extra_attr = [],suit = 5091};

get_seal_equip_info(6011510) ->
	#base_seal_equip{id = 6011510,name = "弦风神之圣器",pos = 11,stage = 10,color = 5,strong = 100,base_attr = [{1,12110},{2,60549}],extra_attr = [],suit = 5101};

get_seal_equip_info(6011511) ->
	#base_seal_equip{id = 6011511,name = "水月神之圣器",pos = 11,stage = 11,color = 5,strong = 100,base_attr = [{1,13520},{2,67596}],extra_attr = [],suit = 5111};

get_seal_equip_info(6011512) ->
	#base_seal_equip{id = 6011512,name = "熔火神之圣器",pos = 11,stage = 12,color = 5,strong = 100,base_attr = [{1,16509},{2,82547}],extra_attr = [],suit = 5121};

get_seal_equip_info(6011513) ->
	#base_seal_equip{id = 6011513,name = "幽泣神之圣器",pos = 11,stage = 13,color = 5,strong = 100,base_attr = [{1,18133},{2,90663}],extra_attr = [],suit = 5131};

get_seal_equip_info(6011514) ->
	#base_seal_equip{id = 6011514,name = "永夜神之圣器",pos = 11,stage = 14,color = 5,strong = 100,base_attr = [{1,21550},{2,107750}],extra_attr = [],suit = 5141};

get_seal_equip_info(6011515) ->
	#base_seal_equip{id = 6011515,name = "荣光神之圣器",pos = 11,stage = 15,color = 5,strong = 100,base_attr = [{1,23387},{2,116931}],extra_attr = [],suit = 5151};

get_seal_equip_info(6011516) ->
	#base_seal_equip{id = 6011516,name = "千锻神之圣器",pos = 11,stage = 16,color = 5,strong = 100,base_attr = [{1,27231},{2,136155}],extra_attr = [],suit = 5161};

get_seal_equip_info(6011517) ->
	#base_seal_equip{id = 6011517,name = "琉璃神之圣器",pos = 11,stage = 17,color = 5,strong = 100,base_attr = [{1,29067},{2,145337}],extra_attr = [],suit = 5171};

get_seal_equip_info(6011518) ->
	#base_seal_equip{id = 6011518,name = "织木神之圣器",pos = 11,stage = 18,color = 5,strong = 100,base_attr = [{1,32913},{2,164561}],extra_attr = [],suit = 5181};

get_seal_equip_info(6011608) ->
	#base_seal_equip{id = 6011608,name = "暗灭神之圣器",pos = 11,stage = 8,color = 7,strong = 100,base_attr = [{1,11451},{2,57257}],extra_attr = [],suit = 6081};

get_seal_equip_info(6011609) ->
	#base_seal_equip{id = 6011609,name = "梦长神之圣器",pos = 11,stage = 9,color = 7,strong = 100,base_attr = [{1,12811},{2,64056}],extra_attr = [],suit = 6091};

get_seal_equip_info(6011610) ->
	#base_seal_equip{id = 6011610,name = "御空灵之圣器",pos = 11,stage = 10,color = 7,strong = 100,base_attr = [{1,14072},{2,70355}],extra_attr = [],suit = 6101};

get_seal_equip_info(6011611) ->
	#base_seal_equip{id = 6011611,name = "逸尘神之圣器",pos = 11,stage = 11,color = 7,strong = 100,base_attr = [{1,16723},{2,83614}],extra_attr = [],suit = 6111};

get_seal_equip_info(6011612) ->
	#base_seal_equip{id = 6011612,name = "天狼神之圣器",pos = 11,stage = 12,color = 7,strong = 100,base_attr = [{1,18149},{2,90739}],extra_attr = [],suit = 6121};

get_seal_equip_info(6011613) ->
	#base_seal_equip{id = 6011613,name = "天音神之圣器",pos = 11,stage = 13,color = 7,strong = 100,base_attr = [{1,21132},{2,105657}],extra_attr = [],suit = 6131};

get_seal_equip_info(6011614) ->
	#base_seal_equip{id = 6011614,name = "天舞神之圣器",pos = 11,stage = 14,color = 7,strong = 100,base_attr = [{1,22557},{2,112782}],extra_attr = [],suit = 6141};

get_seal_equip_info(6011615) ->
	#base_seal_equip{id = 6011615,name = "天琊神之圣器",pos = 11,stage = 15,color = 7,strong = 100,base_attr = [{1,25540},{2,127699}],extra_attr = [],suit = 6151};

get_seal_equip_info(6011616) ->
	#base_seal_equip{id = 6011616,name = "天罚神之圣器",pos = 11,stage = 16,color = 7,strong = 100,base_attr = [{1,35655},{2,178270}],extra_attr = [],suit = 6161};

get_seal_equip_info(_Id) ->
	[].

get_all_equip(4,3) ->
[6001304,6002304,6003304,6004304,6005304,6006304,6007304,6008304,6009304,6010304,6011304];

get_all_equip(4,4) ->
[6001404,6002404,6003404,6004404,6005404,6006404,6007404,6008404,6009404,6010404,6011404];

get_all_equip(5,3) ->
[6001305,6002305,6003305,6004305,6005305,6006305,6007305,6008305,6009305,6010305,6011305];

get_all_equip(5,4) ->
[6001405,6002405,6003405,6004405,6005405,6006405,6007405,6008405,6009405,6010405,6011405];

get_all_equip(6,3) ->
[6001306,6002306,6003306,6004306,6005306,6006306,6007306,6008306,6009306,6010306,6011306];

get_all_equip(6,4) ->
[6001406,6002406,6003406,6004406,6005406,6006406,6007406,6008406,6009406,6010406,6011406];

get_all_equip(7,3) ->
[6001307,6002307,6003307,6004307,6005307,6006307,6007307,6008307,6009307,6010307,6011307];

get_all_equip(7,4) ->
[6001407,6002407,6003407,6004407,6005407,6006407,6007407,6008407,6009407,6010407,6011407];

get_all_equip(7,5) ->
[6001507,6002507,6003507,6004507,6005507,6006507,6007507,6008507,6009507,6010507,6011507];

get_all_equip(8,3) ->
[6001308,6002308,6003308,6004308,6005308,6006308,6007308,6008308,6009308,6010308,6011308];

get_all_equip(8,4) ->
[6001408,6002408,6003408,6004408,6005408,6006408,6007408,6008408,6009408,6010408,6011408];

get_all_equip(8,5) ->
[6001508,6002508,6003508,6004508,6005508,6006508,6007508,6008508,6009508,6010508,6011508];

get_all_equip(8,7) ->
[6001608,6002608,6003608,6004608,6005608,6006608,6007608,6008608,6009608,6010608,6011608];

get_all_equip(9,3) ->
[6001309,6002309,6003309,6004309,6005309,6006309,6007309,6008309,6009309,6010309,6011309];

get_all_equip(9,4) ->
[6001409,6002409,6003409,6004409,6005409,6006409,6007409,6008409,6009409,6010409,6011409];

get_all_equip(9,5) ->
[6001509,6002509,6003509,6004509,6005509,6006509,6007509,6008509,6009509,6010509,6011509];

get_all_equip(9,7) ->
[6001609,6002609,6003609,6004609,6005609,6006609,6007609,6008609,6009609,6010609,6011609];

get_all_equip(10,3) ->
[6001310,6002310,6003310,6004310,6005310,6006310,6007310,6008310,6009310,6010310,6011310];

get_all_equip(10,4) ->
[6001410,6002410,6003410,6004410,6005410,6006410,6007410,6008410,6009410,6010410,6011410];

get_all_equip(10,5) ->
[6001510,6002510,6003510,6004510,6005510,6006510,6007510,6008510,6009510,6010510,6011510];

get_all_equip(10,7) ->
[6001610,6002610,6003610,6004610,6005610,6006610,6007610,6008610,6009610,6010610,6011610];

get_all_equip(11,3) ->
[6001311,6002311,6003311,6004311,6005311,6006311,6007311,6008311,6009311,6010311,6011311];

get_all_equip(11,4) ->
[6001411,6002411,6003411,6004411,6005411,6006411,6007411,6008411,6009411,6010411,6011411];

get_all_equip(11,5) ->
[6001511,6002511,6003511,6004511,6005511,6006511,6007511,6008511,6009511,6010511,6011511];

get_all_equip(11,7) ->
[6001611,6002611,6003611,6004611,6005611,6006611,6007611,6008611,6009611,6010611,6011611];

get_all_equip(12,3) ->
[6001312,6002312,6003312,6004312,6005312,6006312,6007312,6008312,6009312,6010312,6011312];

get_all_equip(12,4) ->
[6001412,6002412,6003412,6004412,6005412,6006412,6007412,6008412,6009412,6010412,6011412];

get_all_equip(12,5) ->
[6001512,6002512,6003512,6004512,6005512,6006512,6007512,6008512,6009512,6010512,6011512];

get_all_equip(12,7) ->
[6001612,6002612,6003612,6004612,6005612,6006612,6007612,6008612,6009612,6010612,6011612];

get_all_equip(13,3) ->
[6001313,6002313,6003313,6004313,6005313,6006313,6007313,6008313,6009313,6010313,6011313];

get_all_equip(13,4) ->
[6001413,6002413,6003413,6004413,6005413,6006413,6007413,6008413,6009413,6010413,6011413];

get_all_equip(13,5) ->
[6001513,6002513,6003513,6004513,6005513,6006513,6007513,6008513,6009513,6010513,6011513];

get_all_equip(13,7) ->
[6001613,6002613,6003613,6004613,6005613,6006613,6007613,6008613,6009613,6010613,6011613];

get_all_equip(14,3) ->
[6001314,6002314,6003314,6004314,6005314,6006314,6007314,6008314,6009314,6010314,6011314];

get_all_equip(14,4) ->
[6001414,6002414,6003414,6004414,6005414,6006414,6007414,6008414,6009414,6010414,6011414];

get_all_equip(14,5) ->
[6001514,6002514,6003514,6004514,6005514,6006514,6007514,6008514,6009514,6010514,6011514];

get_all_equip(14,7) ->
[6001614,6002614,6003614,6004614,6005614,6006614,6007614,6008614,6009614,6010614,6011614];

get_all_equip(15,3) ->
[6001315,6002315,6003315,6004315,6005315,6006315,6007315,6008315,6009315,6010315,6011315];

get_all_equip(15,4) ->
[6001415,6002415,6003415,6004415,6005415,6006415,6007415,6008415,6009415,6010415,6011415];

get_all_equip(15,5) ->
[6001515,6002515,6003515,6004515,6005515,6006515,6007515,6008515,6009515,6010515,6011515];

get_all_equip(15,7) ->
[6001615,6002615,6003615,6004615,6005615,6006615,6007615,6008615,6009615,6010615,6011615];

get_all_equip(16,3) ->
[6001316,6002316,6003316,6004316,6005316,6006316,6007316,6008316,6009316,6010316,6011316];

get_all_equip(16,4) ->
[6001416,6002416,6003416,6004416,6005416,6006416,6007416,6008416,6009416,6010416,6011416];

get_all_equip(16,5) ->
[6001516,6002516,6003516,6004516,6005516,6006516,6007516,6008516,6009516,6010516,6011516];

get_all_equip(16,7) ->
[6001616,6002616,6003616,6004616,6005616,6006616,6007616,6008616,6009616,6010616,6011616];

get_all_equip(17,3) ->
[6001317,6002317,6003317,6004317,6005317,6006317,6007317,6008317,6009317,6010317,6011317];

get_all_equip(17,4) ->
[6001417,6002417,6003417,6004417,6005417,6006417,6007417,6008417,6009417,6010417,6011417];

get_all_equip(17,5) ->
[6001517,6002517,6003517,6004517,6005517,6006517,6007517,6008517,6009517,6010517,6011517];

get_all_equip(18,3) ->
[6001318,6002318,6003318,6004318,6005318,6006318,6007318,6008318,6009318,6010318,6011318];

get_all_equip(18,4) ->
[6001418,6002418,6003418,6004418,6005418,6006418,6007418,6008418,6009418,6010418,6011418];

get_all_equip(18,5) ->
[6001518,6002518,6003518,6004518,6005518,6006518,6007518,6008518,6009518,6010518,6011518];

get_all_equip(_Stage,_Color) ->
	[].

get_same_pos_equip(4,3,1) ->
[6001304];

get_same_pos_equip(4,3,2) ->
[6002304];

get_same_pos_equip(4,3,3) ->
[6003304];

get_same_pos_equip(4,3,4) ->
[6004304];

get_same_pos_equip(4,3,5) ->
[6005304];

get_same_pos_equip(4,3,6) ->
[6006304];

get_same_pos_equip(4,3,7) ->
[6007304];

get_same_pos_equip(4,3,8) ->
[6008304];

get_same_pos_equip(4,3,9) ->
[6009304];

get_same_pos_equip(4,3,10) ->
[6010304];

get_same_pos_equip(4,3,11) ->
[6011304];

get_same_pos_equip(4,4,1) ->
[6001404];

get_same_pos_equip(4,4,2) ->
[6002404];

get_same_pos_equip(4,4,3) ->
[6003404];

get_same_pos_equip(4,4,4) ->
[6004404];

get_same_pos_equip(4,4,5) ->
[6005404];

get_same_pos_equip(4,4,6) ->
[6006404];

get_same_pos_equip(4,4,7) ->
[6007404];

get_same_pos_equip(4,4,8) ->
[6008404];

get_same_pos_equip(4,4,9) ->
[6009404];

get_same_pos_equip(4,4,10) ->
[6010404];

get_same_pos_equip(4,4,11) ->
[6011404];

get_same_pos_equip(5,3,1) ->
[6001305];

get_same_pos_equip(5,3,2) ->
[6002305];

get_same_pos_equip(5,3,3) ->
[6003305];

get_same_pos_equip(5,3,4) ->
[6004305];

get_same_pos_equip(5,3,5) ->
[6005305];

get_same_pos_equip(5,3,6) ->
[6006305];

get_same_pos_equip(5,3,7) ->
[6007305];

get_same_pos_equip(5,3,8) ->
[6008305];

get_same_pos_equip(5,3,9) ->
[6009305];

get_same_pos_equip(5,3,10) ->
[6010305];

get_same_pos_equip(5,3,11) ->
[6011305];

get_same_pos_equip(5,4,1) ->
[6001405];

get_same_pos_equip(5,4,2) ->
[6002405];

get_same_pos_equip(5,4,3) ->
[6003405];

get_same_pos_equip(5,4,4) ->
[6004405];

get_same_pos_equip(5,4,5) ->
[6005405];

get_same_pos_equip(5,4,6) ->
[6006405];

get_same_pos_equip(5,4,7) ->
[6007405];

get_same_pos_equip(5,4,8) ->
[6008405];

get_same_pos_equip(5,4,9) ->
[6009405];

get_same_pos_equip(5,4,10) ->
[6010405];

get_same_pos_equip(5,4,11) ->
[6011405];

get_same_pos_equip(6,3,1) ->
[6001306];

get_same_pos_equip(6,3,2) ->
[6002306];

get_same_pos_equip(6,3,3) ->
[6003306];

get_same_pos_equip(6,3,4) ->
[6004306];

get_same_pos_equip(6,3,5) ->
[6005306];

get_same_pos_equip(6,3,6) ->
[6006306];

get_same_pos_equip(6,3,7) ->
[6007306];

get_same_pos_equip(6,3,8) ->
[6008306];

get_same_pos_equip(6,3,9) ->
[6009306];

get_same_pos_equip(6,3,10) ->
[6010306];

get_same_pos_equip(6,3,11) ->
[6011306];

get_same_pos_equip(6,4,1) ->
[6001406];

get_same_pos_equip(6,4,2) ->
[6002406];

get_same_pos_equip(6,4,3) ->
[6003406];

get_same_pos_equip(6,4,4) ->
[6004406];

get_same_pos_equip(6,4,5) ->
[6005406];

get_same_pos_equip(6,4,6) ->
[6006406];

get_same_pos_equip(6,4,7) ->
[6007406];

get_same_pos_equip(6,4,8) ->
[6008406];

get_same_pos_equip(6,4,9) ->
[6009406];

get_same_pos_equip(6,4,10) ->
[6010406];

get_same_pos_equip(6,4,11) ->
[6011406];

get_same_pos_equip(7,3,1) ->
[6001307];

get_same_pos_equip(7,3,2) ->
[6002307];

get_same_pos_equip(7,3,3) ->
[6003307];

get_same_pos_equip(7,3,4) ->
[6004307];

get_same_pos_equip(7,3,5) ->
[6005307];

get_same_pos_equip(7,3,6) ->
[6006307];

get_same_pos_equip(7,3,7) ->
[6007307];

get_same_pos_equip(7,3,8) ->
[6008307];

get_same_pos_equip(7,3,9) ->
[6009307];

get_same_pos_equip(7,3,10) ->
[6010307];

get_same_pos_equip(7,3,11) ->
[6011307];

get_same_pos_equip(7,4,1) ->
[6001407];

get_same_pos_equip(7,4,2) ->
[6002407];

get_same_pos_equip(7,4,3) ->
[6003407];

get_same_pos_equip(7,4,4) ->
[6004407];

get_same_pos_equip(7,4,5) ->
[6005407];

get_same_pos_equip(7,4,6) ->
[6006407];

get_same_pos_equip(7,4,7) ->
[6007407];

get_same_pos_equip(7,4,8) ->
[6008407];

get_same_pos_equip(7,4,9) ->
[6009407];

get_same_pos_equip(7,4,10) ->
[6010407];

get_same_pos_equip(7,4,11) ->
[6011407];

get_same_pos_equip(7,5,1) ->
[6001507];

get_same_pos_equip(7,5,2) ->
[6002507];

get_same_pos_equip(7,5,3) ->
[6003507];

get_same_pos_equip(7,5,4) ->
[6004507];

get_same_pos_equip(7,5,5) ->
[6005507];

get_same_pos_equip(7,5,6) ->
[6006507];

get_same_pos_equip(7,5,7) ->
[6007507];

get_same_pos_equip(7,5,8) ->
[6008507];

get_same_pos_equip(7,5,9) ->
[6009507];

get_same_pos_equip(7,5,10) ->
[6010507];

get_same_pos_equip(7,5,11) ->
[6011507];

get_same_pos_equip(8,3,1) ->
[6001308];

get_same_pos_equip(8,3,2) ->
[6002308];

get_same_pos_equip(8,3,3) ->
[6003308];

get_same_pos_equip(8,3,4) ->
[6004308];

get_same_pos_equip(8,3,5) ->
[6005308];

get_same_pos_equip(8,3,6) ->
[6006308];

get_same_pos_equip(8,3,7) ->
[6007308];

get_same_pos_equip(8,3,8) ->
[6008308];

get_same_pos_equip(8,3,9) ->
[6009308];

get_same_pos_equip(8,3,10) ->
[6010308];

get_same_pos_equip(8,3,11) ->
[6011308];

get_same_pos_equip(8,4,1) ->
[6001408];

get_same_pos_equip(8,4,2) ->
[6002408];

get_same_pos_equip(8,4,3) ->
[6003408];

get_same_pos_equip(8,4,4) ->
[6004408];

get_same_pos_equip(8,4,5) ->
[6005408];

get_same_pos_equip(8,4,6) ->
[6006408];

get_same_pos_equip(8,4,7) ->
[6007408];

get_same_pos_equip(8,4,8) ->
[6008408];

get_same_pos_equip(8,4,9) ->
[6009408];

get_same_pos_equip(8,4,10) ->
[6010408];

get_same_pos_equip(8,4,11) ->
[6011408];

get_same_pos_equip(8,5,1) ->
[6001508];

get_same_pos_equip(8,5,2) ->
[6002508];

get_same_pos_equip(8,5,3) ->
[6003508];

get_same_pos_equip(8,5,4) ->
[6004508];

get_same_pos_equip(8,5,5) ->
[6005508];

get_same_pos_equip(8,5,6) ->
[6006508];

get_same_pos_equip(8,5,7) ->
[6007508];

get_same_pos_equip(8,5,8) ->
[6008508];

get_same_pos_equip(8,5,9) ->
[6009508];

get_same_pos_equip(8,5,10) ->
[6010508];

get_same_pos_equip(8,5,11) ->
[6011508];

get_same_pos_equip(8,7,1) ->
[6001608];

get_same_pos_equip(8,7,2) ->
[6002608];

get_same_pos_equip(8,7,3) ->
[6003608];

get_same_pos_equip(8,7,4) ->
[6004608];

get_same_pos_equip(8,7,5) ->
[6005608];

get_same_pos_equip(8,7,6) ->
[6006608];

get_same_pos_equip(8,7,7) ->
[6007608];

get_same_pos_equip(8,7,8) ->
[6008608];

get_same_pos_equip(8,7,9) ->
[6009608];

get_same_pos_equip(8,7,10) ->
[6010608];

get_same_pos_equip(8,7,11) ->
[6011608];

get_same_pos_equip(9,3,1) ->
[6001309];

get_same_pos_equip(9,3,2) ->
[6002309];

get_same_pos_equip(9,3,3) ->
[6003309];

get_same_pos_equip(9,3,4) ->
[6004309];

get_same_pos_equip(9,3,5) ->
[6005309];

get_same_pos_equip(9,3,6) ->
[6006309];

get_same_pos_equip(9,3,7) ->
[6007309];

get_same_pos_equip(9,3,8) ->
[6008309];

get_same_pos_equip(9,3,9) ->
[6009309];

get_same_pos_equip(9,3,10) ->
[6010309];

get_same_pos_equip(9,3,11) ->
[6011309];

get_same_pos_equip(9,4,1) ->
[6001409];

get_same_pos_equip(9,4,2) ->
[6002409];

get_same_pos_equip(9,4,3) ->
[6003409];

get_same_pos_equip(9,4,4) ->
[6004409];

get_same_pos_equip(9,4,5) ->
[6005409];

get_same_pos_equip(9,4,6) ->
[6006409];

get_same_pos_equip(9,4,7) ->
[6007409];

get_same_pos_equip(9,4,8) ->
[6008409];

get_same_pos_equip(9,4,9) ->
[6009409];

get_same_pos_equip(9,4,10) ->
[6010409];

get_same_pos_equip(9,4,11) ->
[6011409];

get_same_pos_equip(9,5,1) ->
[6001509];

get_same_pos_equip(9,5,2) ->
[6002509];

get_same_pos_equip(9,5,3) ->
[6003509];

get_same_pos_equip(9,5,4) ->
[6004509];

get_same_pos_equip(9,5,5) ->
[6005509];

get_same_pos_equip(9,5,6) ->
[6006509];

get_same_pos_equip(9,5,7) ->
[6007509];

get_same_pos_equip(9,5,8) ->
[6008509];

get_same_pos_equip(9,5,9) ->
[6009509];

get_same_pos_equip(9,5,10) ->
[6010509];

get_same_pos_equip(9,5,11) ->
[6011509];

get_same_pos_equip(9,7,1) ->
[6001609];

get_same_pos_equip(9,7,2) ->
[6002609];

get_same_pos_equip(9,7,3) ->
[6003609];

get_same_pos_equip(9,7,4) ->
[6004609];

get_same_pos_equip(9,7,5) ->
[6005609];

get_same_pos_equip(9,7,6) ->
[6006609];

get_same_pos_equip(9,7,7) ->
[6007609];

get_same_pos_equip(9,7,8) ->
[6008609];

get_same_pos_equip(9,7,9) ->
[6009609];

get_same_pos_equip(9,7,10) ->
[6010609];

get_same_pos_equip(9,7,11) ->
[6011609];

get_same_pos_equip(10,3,1) ->
[6001310];

get_same_pos_equip(10,3,2) ->
[6002310];

get_same_pos_equip(10,3,3) ->
[6003310];

get_same_pos_equip(10,3,4) ->
[6004310];

get_same_pos_equip(10,3,5) ->
[6005310];

get_same_pos_equip(10,3,6) ->
[6006310];

get_same_pos_equip(10,3,7) ->
[6007310];

get_same_pos_equip(10,3,8) ->
[6008310];

get_same_pos_equip(10,3,9) ->
[6009310];

get_same_pos_equip(10,3,10) ->
[6010310];

get_same_pos_equip(10,3,11) ->
[6011310];

get_same_pos_equip(10,4,1) ->
[6001410];

get_same_pos_equip(10,4,2) ->
[6002410];

get_same_pos_equip(10,4,3) ->
[6003410];

get_same_pos_equip(10,4,4) ->
[6004410];

get_same_pos_equip(10,4,5) ->
[6005410];

get_same_pos_equip(10,4,6) ->
[6006410];

get_same_pos_equip(10,4,7) ->
[6007410];

get_same_pos_equip(10,4,8) ->
[6008410];

get_same_pos_equip(10,4,9) ->
[6009410];

get_same_pos_equip(10,4,10) ->
[6010410];

get_same_pos_equip(10,4,11) ->
[6011410];

get_same_pos_equip(10,5,1) ->
[6001510];

get_same_pos_equip(10,5,2) ->
[6002510];

get_same_pos_equip(10,5,3) ->
[6003510];

get_same_pos_equip(10,5,4) ->
[6004510];

get_same_pos_equip(10,5,5) ->
[6005510];

get_same_pos_equip(10,5,6) ->
[6006510];

get_same_pos_equip(10,5,7) ->
[6007510];

get_same_pos_equip(10,5,8) ->
[6008510];

get_same_pos_equip(10,5,9) ->
[6009510];

get_same_pos_equip(10,5,10) ->
[6010510];

get_same_pos_equip(10,5,11) ->
[6011510];

get_same_pos_equip(10,7,1) ->
[6001610];

get_same_pos_equip(10,7,2) ->
[6002610];

get_same_pos_equip(10,7,3) ->
[6003610];

get_same_pos_equip(10,7,4) ->
[6004610];

get_same_pos_equip(10,7,5) ->
[6005610];

get_same_pos_equip(10,7,6) ->
[6006610];

get_same_pos_equip(10,7,7) ->
[6007610];

get_same_pos_equip(10,7,8) ->
[6008610];

get_same_pos_equip(10,7,9) ->
[6009610];

get_same_pos_equip(10,7,10) ->
[6010610];

get_same_pos_equip(10,7,11) ->
[6011610];

get_same_pos_equip(11,3,1) ->
[6001311];

get_same_pos_equip(11,3,2) ->
[6002311];

get_same_pos_equip(11,3,3) ->
[6003311];

get_same_pos_equip(11,3,4) ->
[6004311];

get_same_pos_equip(11,3,5) ->
[6005311];

get_same_pos_equip(11,3,6) ->
[6006311];

get_same_pos_equip(11,3,7) ->
[6007311];

get_same_pos_equip(11,3,8) ->
[6008311];

get_same_pos_equip(11,3,9) ->
[6009311];

get_same_pos_equip(11,3,10) ->
[6010311];

get_same_pos_equip(11,3,11) ->
[6011311];

get_same_pos_equip(11,4,1) ->
[6001411];

get_same_pos_equip(11,4,2) ->
[6002411];

get_same_pos_equip(11,4,3) ->
[6003411];

get_same_pos_equip(11,4,4) ->
[6004411];

get_same_pos_equip(11,4,5) ->
[6005411];

get_same_pos_equip(11,4,6) ->
[6006411];

get_same_pos_equip(11,4,7) ->
[6007411];

get_same_pos_equip(11,4,8) ->
[6008411];

get_same_pos_equip(11,4,9) ->
[6009411];

get_same_pos_equip(11,4,10) ->
[6010411];

get_same_pos_equip(11,4,11) ->
[6011411];

get_same_pos_equip(11,5,1) ->
[6001511];

get_same_pos_equip(11,5,2) ->
[6002511];

get_same_pos_equip(11,5,3) ->
[6003511];

get_same_pos_equip(11,5,4) ->
[6004511];

get_same_pos_equip(11,5,5) ->
[6005511];

get_same_pos_equip(11,5,6) ->
[6006511];

get_same_pos_equip(11,5,7) ->
[6007511];

get_same_pos_equip(11,5,8) ->
[6008511];

get_same_pos_equip(11,5,9) ->
[6009511];

get_same_pos_equip(11,5,10) ->
[6010511];

get_same_pos_equip(11,5,11) ->
[6011511];

get_same_pos_equip(11,7,1) ->
[6001611];

get_same_pos_equip(11,7,2) ->
[6002611];

get_same_pos_equip(11,7,3) ->
[6003611];

get_same_pos_equip(11,7,4) ->
[6004611];

get_same_pos_equip(11,7,5) ->
[6005611];

get_same_pos_equip(11,7,6) ->
[6006611];

get_same_pos_equip(11,7,7) ->
[6007611];

get_same_pos_equip(11,7,8) ->
[6008611];

get_same_pos_equip(11,7,9) ->
[6009611];

get_same_pos_equip(11,7,10) ->
[6010611];

get_same_pos_equip(11,7,11) ->
[6011611];

get_same_pos_equip(12,3,1) ->
[6001312];

get_same_pos_equip(12,3,2) ->
[6002312];

get_same_pos_equip(12,3,3) ->
[6003312];

get_same_pos_equip(12,3,4) ->
[6004312];

get_same_pos_equip(12,3,5) ->
[6005312];

get_same_pos_equip(12,3,6) ->
[6006312];

get_same_pos_equip(12,3,7) ->
[6007312];

get_same_pos_equip(12,3,8) ->
[6008312];

get_same_pos_equip(12,3,9) ->
[6009312];

get_same_pos_equip(12,3,10) ->
[6010312];

get_same_pos_equip(12,3,11) ->
[6011312];

get_same_pos_equip(12,4,1) ->
[6001412];

get_same_pos_equip(12,4,2) ->
[6002412];

get_same_pos_equip(12,4,3) ->
[6003412];

get_same_pos_equip(12,4,4) ->
[6004412];

get_same_pos_equip(12,4,5) ->
[6005412];

get_same_pos_equip(12,4,6) ->
[6006412];

get_same_pos_equip(12,4,7) ->
[6007412];

get_same_pos_equip(12,4,8) ->
[6008412];

get_same_pos_equip(12,4,9) ->
[6009412];

get_same_pos_equip(12,4,10) ->
[6010412];

get_same_pos_equip(12,4,11) ->
[6011412];

get_same_pos_equip(12,5,1) ->
[6001512];

get_same_pos_equip(12,5,2) ->
[6002512];

get_same_pos_equip(12,5,3) ->
[6003512];

get_same_pos_equip(12,5,4) ->
[6004512];

get_same_pos_equip(12,5,5) ->
[6005512];

get_same_pos_equip(12,5,6) ->
[6006512];

get_same_pos_equip(12,5,7) ->
[6007512];

get_same_pos_equip(12,5,8) ->
[6008512];

get_same_pos_equip(12,5,9) ->
[6009512];

get_same_pos_equip(12,5,10) ->
[6010512];

get_same_pos_equip(12,5,11) ->
[6011512];

get_same_pos_equip(12,7,1) ->
[6001612];

get_same_pos_equip(12,7,2) ->
[6002612];

get_same_pos_equip(12,7,3) ->
[6003612];

get_same_pos_equip(12,7,4) ->
[6004612];

get_same_pos_equip(12,7,5) ->
[6005612];

get_same_pos_equip(12,7,6) ->
[6006612];

get_same_pos_equip(12,7,7) ->
[6007612];

get_same_pos_equip(12,7,8) ->
[6008612];

get_same_pos_equip(12,7,9) ->
[6009612];

get_same_pos_equip(12,7,10) ->
[6010612];

get_same_pos_equip(12,7,11) ->
[6011612];

get_same_pos_equip(13,3,1) ->
[6001313];

get_same_pos_equip(13,3,2) ->
[6002313];

get_same_pos_equip(13,3,3) ->
[6003313];

get_same_pos_equip(13,3,4) ->
[6004313];

get_same_pos_equip(13,3,5) ->
[6005313];

get_same_pos_equip(13,3,6) ->
[6006313];

get_same_pos_equip(13,3,7) ->
[6007313];

get_same_pos_equip(13,3,8) ->
[6008313];

get_same_pos_equip(13,3,9) ->
[6009313];

get_same_pos_equip(13,3,10) ->
[6010313];

get_same_pos_equip(13,3,11) ->
[6011313];

get_same_pos_equip(13,4,1) ->
[6001413];

get_same_pos_equip(13,4,2) ->
[6002413];

get_same_pos_equip(13,4,3) ->
[6003413];

get_same_pos_equip(13,4,4) ->
[6004413];

get_same_pos_equip(13,4,5) ->
[6005413];

get_same_pos_equip(13,4,6) ->
[6006413];

get_same_pos_equip(13,4,7) ->
[6007413];

get_same_pos_equip(13,4,8) ->
[6008413];

get_same_pos_equip(13,4,9) ->
[6009413];

get_same_pos_equip(13,4,10) ->
[6010413];

get_same_pos_equip(13,4,11) ->
[6011413];

get_same_pos_equip(13,5,1) ->
[6001513];

get_same_pos_equip(13,5,2) ->
[6002513];

get_same_pos_equip(13,5,3) ->
[6003513];

get_same_pos_equip(13,5,4) ->
[6004513];

get_same_pos_equip(13,5,5) ->
[6005513];

get_same_pos_equip(13,5,6) ->
[6006513];

get_same_pos_equip(13,5,7) ->
[6007513];

get_same_pos_equip(13,5,8) ->
[6008513];

get_same_pos_equip(13,5,9) ->
[6009513];

get_same_pos_equip(13,5,10) ->
[6010513];

get_same_pos_equip(13,5,11) ->
[6011513];

get_same_pos_equip(13,7,1) ->
[6001613];

get_same_pos_equip(13,7,2) ->
[6002613];

get_same_pos_equip(13,7,3) ->
[6003613];

get_same_pos_equip(13,7,4) ->
[6004613];

get_same_pos_equip(13,7,5) ->
[6005613];

get_same_pos_equip(13,7,6) ->
[6006613];

get_same_pos_equip(13,7,7) ->
[6007613];

get_same_pos_equip(13,7,8) ->
[6008613];

get_same_pos_equip(13,7,9) ->
[6009613];

get_same_pos_equip(13,7,10) ->
[6010613];

get_same_pos_equip(13,7,11) ->
[6011613];

get_same_pos_equip(14,3,1) ->
[6001314];

get_same_pos_equip(14,3,2) ->
[6002314];

get_same_pos_equip(14,3,3) ->
[6003314];

get_same_pos_equip(14,3,4) ->
[6004314];

get_same_pos_equip(14,3,5) ->
[6005314];

get_same_pos_equip(14,3,6) ->
[6006314];

get_same_pos_equip(14,3,7) ->
[6007314];

get_same_pos_equip(14,3,8) ->
[6008314];

get_same_pos_equip(14,3,9) ->
[6009314];

get_same_pos_equip(14,3,10) ->
[6010314];

get_same_pos_equip(14,3,11) ->
[6011314];

get_same_pos_equip(14,4,1) ->
[6001414];

get_same_pos_equip(14,4,2) ->
[6002414];

get_same_pos_equip(14,4,3) ->
[6003414];

get_same_pos_equip(14,4,4) ->
[6004414];

get_same_pos_equip(14,4,5) ->
[6005414];

get_same_pos_equip(14,4,6) ->
[6006414];

get_same_pos_equip(14,4,7) ->
[6007414];

get_same_pos_equip(14,4,8) ->
[6008414];

get_same_pos_equip(14,4,9) ->
[6009414];

get_same_pos_equip(14,4,10) ->
[6010414];

get_same_pos_equip(14,4,11) ->
[6011414];

get_same_pos_equip(14,5,1) ->
[6001514];

get_same_pos_equip(14,5,2) ->
[6002514];

get_same_pos_equip(14,5,3) ->
[6003514];

get_same_pos_equip(14,5,4) ->
[6004514];

get_same_pos_equip(14,5,5) ->
[6005514];

get_same_pos_equip(14,5,6) ->
[6006514];

get_same_pos_equip(14,5,7) ->
[6007514];

get_same_pos_equip(14,5,8) ->
[6008514];

get_same_pos_equip(14,5,9) ->
[6009514];

get_same_pos_equip(14,5,10) ->
[6010514];

get_same_pos_equip(14,5,11) ->
[6011514];

get_same_pos_equip(14,7,1) ->
[6001614];

get_same_pos_equip(14,7,2) ->
[6002614];

get_same_pos_equip(14,7,3) ->
[6003614];

get_same_pos_equip(14,7,4) ->
[6004614];

get_same_pos_equip(14,7,5) ->
[6005614];

get_same_pos_equip(14,7,6) ->
[6006614];

get_same_pos_equip(14,7,7) ->
[6007614];

get_same_pos_equip(14,7,8) ->
[6008614];

get_same_pos_equip(14,7,9) ->
[6009614];

get_same_pos_equip(14,7,10) ->
[6010614];

get_same_pos_equip(14,7,11) ->
[6011614];

get_same_pos_equip(15,3,1) ->
[6001315];

get_same_pos_equip(15,3,2) ->
[6002315];

get_same_pos_equip(15,3,3) ->
[6003315];

get_same_pos_equip(15,3,4) ->
[6004315];

get_same_pos_equip(15,3,5) ->
[6005315];

get_same_pos_equip(15,3,6) ->
[6006315];

get_same_pos_equip(15,3,7) ->
[6007315];

get_same_pos_equip(15,3,8) ->
[6008315];

get_same_pos_equip(15,3,9) ->
[6009315];

get_same_pos_equip(15,3,10) ->
[6010315];

get_same_pos_equip(15,3,11) ->
[6011315];

get_same_pos_equip(15,4,1) ->
[6001415];

get_same_pos_equip(15,4,2) ->
[6002415];

get_same_pos_equip(15,4,3) ->
[6003415];

get_same_pos_equip(15,4,4) ->
[6004415];

get_same_pos_equip(15,4,5) ->
[6005415];

get_same_pos_equip(15,4,6) ->
[6006415];

get_same_pos_equip(15,4,7) ->
[6007415];

get_same_pos_equip(15,4,8) ->
[6008415];

get_same_pos_equip(15,4,9) ->
[6009415];

get_same_pos_equip(15,4,10) ->
[6010415];

get_same_pos_equip(15,4,11) ->
[6011415];

get_same_pos_equip(15,5,1) ->
[6001515];

get_same_pos_equip(15,5,2) ->
[6002515];

get_same_pos_equip(15,5,3) ->
[6003515];

get_same_pos_equip(15,5,4) ->
[6004515];

get_same_pos_equip(15,5,5) ->
[6005515];

get_same_pos_equip(15,5,6) ->
[6006515];

get_same_pos_equip(15,5,7) ->
[6007515];

get_same_pos_equip(15,5,8) ->
[6008515];

get_same_pos_equip(15,5,9) ->
[6009515];

get_same_pos_equip(15,5,10) ->
[6010515];

get_same_pos_equip(15,5,11) ->
[6011515];

get_same_pos_equip(15,7,1) ->
[6001615];

get_same_pos_equip(15,7,2) ->
[6002615];

get_same_pos_equip(15,7,3) ->
[6003615];

get_same_pos_equip(15,7,4) ->
[6004615];

get_same_pos_equip(15,7,5) ->
[6005615];

get_same_pos_equip(15,7,6) ->
[6006615];

get_same_pos_equip(15,7,7) ->
[6007615];

get_same_pos_equip(15,7,8) ->
[6008615];

get_same_pos_equip(15,7,9) ->
[6009615];

get_same_pos_equip(15,7,10) ->
[6010615];

get_same_pos_equip(15,7,11) ->
[6011615];

get_same_pos_equip(16,3,1) ->
[6001316];

get_same_pos_equip(16,3,2) ->
[6002316];

get_same_pos_equip(16,3,3) ->
[6003316];

get_same_pos_equip(16,3,4) ->
[6004316];

get_same_pos_equip(16,3,5) ->
[6005316];

get_same_pos_equip(16,3,6) ->
[6006316];

get_same_pos_equip(16,3,7) ->
[6007316];

get_same_pos_equip(16,3,8) ->
[6008316];

get_same_pos_equip(16,3,9) ->
[6009316];

get_same_pos_equip(16,3,10) ->
[6010316];

get_same_pos_equip(16,3,11) ->
[6011316];

get_same_pos_equip(16,4,1) ->
[6001416];

get_same_pos_equip(16,4,2) ->
[6002416];

get_same_pos_equip(16,4,3) ->
[6003416];

get_same_pos_equip(16,4,4) ->
[6004416];

get_same_pos_equip(16,4,5) ->
[6005416];

get_same_pos_equip(16,4,6) ->
[6006416];

get_same_pos_equip(16,4,7) ->
[6007416];

get_same_pos_equip(16,4,8) ->
[6008416];

get_same_pos_equip(16,4,9) ->
[6009416];

get_same_pos_equip(16,4,10) ->
[6010416];

get_same_pos_equip(16,4,11) ->
[6011416];

get_same_pos_equip(16,5,1) ->
[6001516];

get_same_pos_equip(16,5,2) ->
[6002516];

get_same_pos_equip(16,5,3) ->
[6003516];

get_same_pos_equip(16,5,4) ->
[6004516];

get_same_pos_equip(16,5,5) ->
[6005516];

get_same_pos_equip(16,5,6) ->
[6006516];

get_same_pos_equip(16,5,7) ->
[6007516];

get_same_pos_equip(16,5,8) ->
[6008516];

get_same_pos_equip(16,5,9) ->
[6009516];

get_same_pos_equip(16,5,10) ->
[6010516];

get_same_pos_equip(16,5,11) ->
[6011516];

get_same_pos_equip(16,7,1) ->
[6001616];

get_same_pos_equip(16,7,2) ->
[6002616];

get_same_pos_equip(16,7,3) ->
[6003616];

get_same_pos_equip(16,7,4) ->
[6004616];

get_same_pos_equip(16,7,5) ->
[6005616];

get_same_pos_equip(16,7,6) ->
[6006616];

get_same_pos_equip(16,7,7) ->
[6007616];

get_same_pos_equip(16,7,8) ->
[6008616];

get_same_pos_equip(16,7,9) ->
[6009616];

get_same_pos_equip(16,7,10) ->
[6010616];

get_same_pos_equip(16,7,11) ->
[6011616];

get_same_pos_equip(17,3,1) ->
[6001317];

get_same_pos_equip(17,3,2) ->
[6002317];

get_same_pos_equip(17,3,3) ->
[6003317];

get_same_pos_equip(17,3,4) ->
[6004317];

get_same_pos_equip(17,3,5) ->
[6005317];

get_same_pos_equip(17,3,6) ->
[6006317];

get_same_pos_equip(17,3,7) ->
[6007317];

get_same_pos_equip(17,3,8) ->
[6008317];

get_same_pos_equip(17,3,9) ->
[6009317];

get_same_pos_equip(17,3,10) ->
[6010317];

get_same_pos_equip(17,3,11) ->
[6011317];

get_same_pos_equip(17,4,1) ->
[6001417];

get_same_pos_equip(17,4,2) ->
[6002417];

get_same_pos_equip(17,4,3) ->
[6003417];

get_same_pos_equip(17,4,4) ->
[6004417];

get_same_pos_equip(17,4,5) ->
[6005417];

get_same_pos_equip(17,4,6) ->
[6006417];

get_same_pos_equip(17,4,7) ->
[6007417];

get_same_pos_equip(17,4,8) ->
[6008417];

get_same_pos_equip(17,4,9) ->
[6009417];

get_same_pos_equip(17,4,10) ->
[6010417];

get_same_pos_equip(17,4,11) ->
[6011417];

get_same_pos_equip(17,5,1) ->
[6001517];

get_same_pos_equip(17,5,2) ->
[6002517];

get_same_pos_equip(17,5,3) ->
[6003517];

get_same_pos_equip(17,5,4) ->
[6004517];

get_same_pos_equip(17,5,5) ->
[6005517];

get_same_pos_equip(17,5,6) ->
[6006517];

get_same_pos_equip(17,5,7) ->
[6007517];

get_same_pos_equip(17,5,8) ->
[6008517];

get_same_pos_equip(17,5,9) ->
[6009517];

get_same_pos_equip(17,5,10) ->
[6010517];

get_same_pos_equip(17,5,11) ->
[6011517];

get_same_pos_equip(18,3,1) ->
[6001318];

get_same_pos_equip(18,3,2) ->
[6002318];

get_same_pos_equip(18,3,3) ->
[6003318];

get_same_pos_equip(18,3,4) ->
[6004318];

get_same_pos_equip(18,3,5) ->
[6005318];

get_same_pos_equip(18,3,6) ->
[6006318];

get_same_pos_equip(18,3,7) ->
[6007318];

get_same_pos_equip(18,3,8) ->
[6008318];

get_same_pos_equip(18,3,9) ->
[6009318];

get_same_pos_equip(18,3,10) ->
[6010318];

get_same_pos_equip(18,3,11) ->
[6011318];

get_same_pos_equip(18,4,1) ->
[6001418];

get_same_pos_equip(18,4,2) ->
[6002418];

get_same_pos_equip(18,4,3) ->
[6003418];

get_same_pos_equip(18,4,4) ->
[6004418];

get_same_pos_equip(18,4,5) ->
[6005418];

get_same_pos_equip(18,4,6) ->
[6006418];

get_same_pos_equip(18,4,7) ->
[6007418];

get_same_pos_equip(18,4,8) ->
[6008418];

get_same_pos_equip(18,4,9) ->
[6009418];

get_same_pos_equip(18,4,10) ->
[6010418];

get_same_pos_equip(18,4,11) ->
[6011418];

get_same_pos_equip(18,5,1) ->
[6001518];

get_same_pos_equip(18,5,2) ->
[6002518];

get_same_pos_equip(18,5,3) ->
[6003518];

get_same_pos_equip(18,5,4) ->
[6004518];

get_same_pos_equip(18,5,5) ->
[6005518];

get_same_pos_equip(18,5,6) ->
[6006518];

get_same_pos_equip(18,5,7) ->
[6007518];

get_same_pos_equip(18,5,8) ->
[6008518];

get_same_pos_equip(18,5,9) ->
[6009518];

get_same_pos_equip(18,5,10) ->
[6010518];

get_same_pos_equip(18,5,11) ->
[6011518];

get_same_pos_equip(_Stage,_Color,_Pos) ->
	[].

get_seal_suit_info(4040) ->
	#base_seal_suit{id = 4040,stage = 4,color = 4,name = "幽魅魂装",suit_type = 0,seal = [6001404,6002404,6003404,6004404,6005404,6006404],attr = [{2,[{4,580},{6,580},{54,10}]},{4,[{2,11592},{8,580},{56,15}]},{6,[{4,580},{2,11592},{28,10}]}],score = []};

get_seal_suit_info(4041) ->
	#base_seal_suit{id = 4041,stage = 4,color = 4,name = "幽魅传承",suit_type = 1,seal = [6007404,6008404,6009404,6010404,6011404],attr = [{2,[{3,580},{5,580},{53,15}]},{4,[{1,580},{7,580},{55,25}]},{5,[{1,580},{3,580},{27,10}]}],score = []};

get_seal_suit_info(4050) ->
	#base_seal_suit{id = 4050,stage = 5,color = 4,name = "复仇魂装",suit_type = 0,seal = [6001405,6002405,6003405,6004405,6005405,6006405],attr = [{2,[{4,983},{6,983},{54,16}]},{4,[{2,19656},{8,983},{56,24}]},{6,[{4,983},{2,19656},{28,16}]}],score = []};

get_seal_suit_info(4051) ->
	#base_seal_suit{id = 4051,stage = 5,color = 4,name = "复仇传承",suit_type = 1,seal = [6007405,6008405,6009405,6010405,6011405],attr = [{2,[{3,983},{5,983},{53,24}]},{4,[{1,983},{7,983},{55,40}]},{5,[{1,983},{3,983},{27,16}]}],score = []};

get_seal_suit_info(4060) ->
	#base_seal_suit{id = 4060,stage = 6,color = 4,name = "毁灭魂装",suit_type = 0,seal = [6001406,6002406,6003406,6004406,6005406,6006406],attr = [{2,[{4,1383},{6,1383},{54,23}]},{4,[{2,27670},{8,1383},{56,35}]},{6,[{4,1383},{2,27670},{28,23}]}],score = []};

get_seal_suit_info(4061) ->
	#base_seal_suit{id = 4061,stage = 6,color = 4,name = "毁灭传承",suit_type = 1,seal = [6007406,6008406,6009406,6010406,6011406],attr = [{2,[{3,1383},{5,1383},{53,35}]},{4,[{1,1383},{7,1383},{55,58}]},{5,[{1,1383},{3,1383},{27,23}]}],score = []};

get_seal_suit_info(4070) ->
	#base_seal_suit{id = 4070,stage = 7,color = 4,name = "灾变魂装",suit_type = 0,seal = [6001407,6002407,6003407,6004407,6005407,6006407],attr = [{2,[{4,1982},{6,1982},{54,32}]},{4,[{2,39648},{8,1982},{56,48}]},{6,[{4,1982},{2,39648},{28,32}]}],score = []};

get_seal_suit_info(4071) ->
	#base_seal_suit{id = 4071,stage = 7,color = 4,name = "灾变传承",suit_type = 1,seal = [6007407,6008407,6009407,6010407,6011407],attr = [{2,[{3,1982},{5,1982},{53,48}]},{4,[{1,1982},{7,1982},{55,80}]},{5,[{1,1982},{3,1982},{27,32}]}],score = []};

get_seal_suit_info(4080) ->
	#base_seal_suit{id = 4080,stage = 8,color = 4,name = "恶毒魂装",suit_type = 0,seal = [6001408,6002408,6003408,6004408,6005408,6006408],attr = [{2,[{4,3353},{6,3353},{54,48}]},{4,[{2,67053},{8,3353},{56,72}]},{6,[{4,3353},{2,67053},{28,48}]}],score = []};

get_seal_suit_info(4081) ->
	#base_seal_suit{id = 4081,stage = 8,color = 4,name = "恶毒传承",suit_type = 1,seal = [6007408,6008408,6009408,6010408,6011408],attr = [{2,[{3,3353},{5,3353},{53,72}]},{4,[{1,3353},{7,3353},{55,120}]},{5,[{1,3353},{3,3353},{27,48}]}],score = []};

get_seal_suit_info(4090) ->
	#base_seal_suit{id = 4090,stage = 9,color = 4,name = "腐蚀魂装",suit_type = 0,seal = [6001409,6002409,6003409,6004409,6005409,6006409],attr = [{2,[{4,3658},{6,3658},{54,72}]},{4,[{2,73158},{8,3658},{56,108}]},{6,[{4,3658},{2,73158},{28,72}]}],score = []};

get_seal_suit_info(4091) ->
	#base_seal_suit{id = 4091,stage = 9,color = 4,name = "腐蚀传承",suit_type = 1,seal = [6007409,6008409,6009409,6010409,6011409],attr = [{2,[{3,3658},{5,3658},{53,108}]},{4,[{1,3658},{7,3658},{55,180}]},{5,[{1,3658},{3,3658},{27,72}]}],score = []};

get_seal_suit_info(4100) ->
	#base_seal_suit{id = 4100,stage = 10,color = 4,name = "瘟疫魂装",suit_type = 0,seal = [6001410,6002410,6003410,6004410,6005410,6006410],attr = [{2,[{4,5050},{6,5050},{54,86}]},{4,[{2,100990},{8,5050},{56,129}]},{6,[{4,5050},{2,100990},{28,86}]}],score = []};

get_seal_suit_info(4101) ->
	#base_seal_suit{id = 4101,stage = 10,color = 4,name = "瘟疫传承",suit_type = 1,seal = [6007410,6008410,6009410,6010410,6011410],attr = [{2,[{3,5050},{5,5050},{53,129}]},{4,[{1,5050},{7,5050},{55,215}]},{5,[{1,5050},{3,5050},{27,86}]}],score = []};

get_seal_suit_info(4110) ->
	#base_seal_suit{id = 4110,stage = 11,color = 4,name = "无间魂装",suit_type = 0,seal = [6001411,6002411,6003411,6004411,6005411,6006411],attr = [{2,[{4,5676},{6,5676},{54,112}]},{4,[{2,113515},{8,5676},{56,168}]},{6,[{4,5676},{2,113515},{28,112}]}],score = []};

get_seal_suit_info(4111) ->
	#base_seal_suit{id = 4111,stage = 11,color = 4,name = "无间传承",suit_type = 1,seal = [6007411,6008411,6009411,6010411,6011411],attr = [{2,[{3,5676},{5,5676},{53,168}]},{4,[{1,5676},{7,5676},{55,280}]},{5,[{1,5676},{3,5676},{27,112}]}],score = []};

get_seal_suit_info(4120) ->
	#base_seal_suit{id = 4120,stage = 12,color = 4,name = "虚空魂装",suit_type = 0,seal = [6001412,6002412,6003412,6004412,6005412,6006412],attr = [{2,[{4,7107},{6,7107},{54,135}]},{4,[{2,142142},{8,7107},{56,203}]},{6,[{4,7107},{2,142142},{28,135}]}],score = []};

get_seal_suit_info(4121) ->
	#base_seal_suit{id = 4121,stage = 12,color = 4,name = "虚空传承",suit_type = 1,seal = [6007412,6008412,6009412,6010412,6011412],attr = [{2,[{3,7107},{5,7107},{53,203}]},{4,[{1,7107},{7,7107},{55,338}]},{5,[{1,7107},{3,7107},{27,135}]}],score = []};

get_seal_suit_info(4130) ->
	#base_seal_suit{id = 4130,stage = 13,color = 4,name = "双煞魂装",suit_type = 0,seal = [6001413,6002413,6003413,6004413,6005413,6006413],attr = [{2,[{4,7743},{6,7743},{54,170}]},{4,[{2,154865},{8,7743},{56,255}]},{6,[{4,7743},{2,154865},{28,170}]}],score = []};

get_seal_suit_info(4131) ->
	#base_seal_suit{id = 4131,stage = 13,color = 4,name = "双煞传承",suit_type = 1,seal = [6007413,6008413,6009413,6010413,6011413],attr = [{2,[{3,7743},{5,7743},{53,255}]},{4,[{1,7743},{7,7743},{55,425}]},{5,[{1,7743},{3,7743},{27,170}]}],score = []};

get_seal_suit_info(4140) ->
	#base_seal_suit{id = 4140,stage = 14,color = 4,name = "坟冢魂装",suit_type = 0,seal = [6001414,6002414,6003414,6004414,6005414,6006414],attr = [{2,[{4,9224},{6,9224},{54,195}]},{4,[{2,184486},{8,9224},{56,293}]},{6,[{4,9224},{2,184486},{28,195}]}],score = []};

get_seal_suit_info(4141) ->
	#base_seal_suit{id = 4141,stage = 14,color = 4,name = "坟冢传承",suit_type = 1,seal = [6007414,6008414,6009414,6010414,6011414],attr = [{2,[{3,9224},{5,9224},{53,293}]},{4,[{1,9224},{7,9224},{55,488}]},{5,[{1,9224},{3,9224},{27,195}]}],score = []};

get_seal_suit_info(4150) ->
	#base_seal_suit{id = 4150,stage = 15,color = 4,name = "梦魇魂装",suit_type = 0,seal = [6001415,6002415,6003415,6004415,6005415,6006415],attr = [{2,[{4,9870},{6,9870},{54,240}]},{4,[{2,197408},{8,9870},{56,360}]},{6,[{4,9870},{2,197408},{28,240}]}],score = []};

get_seal_suit_info(4151) ->
	#base_seal_suit{id = 4151,stage = 15,color = 4,name = "梦魇传承",suit_type = 1,seal = [6007415,6008415,6009415,6010415,6011415],attr = [{2,[{3,9870},{5,9870},{53,360}]},{4,[{1,9870},{7,9870},{55,600}]},{5,[{1,9870},{3,9870},{27,240}]}],score = []};

get_seal_suit_info(4160) ->
	#base_seal_suit{id = 4160,stage = 16,color = 4,name = "碧魔魂装",suit_type = 0,seal = [6001416,6002416,6003416,6004416,6005416,6006416],attr = [{2,[{4,11381},{6,11381},{54,276}]},{4,[{2,227626},{8,11381},{56,414}]},{6,[{4,11381},{2,227626},{28,276}]}],score = []};

get_seal_suit_info(4161) ->
	#base_seal_suit{id = 4161,stage = 16,color = 4,name = "碧魔传承",suit_type = 1,seal = [6007416,6008416,6009416,6010416,6011416],attr = [{2,[{3,11381},{5,11381},{53,414}]},{4,[{1,11381},{7,11381},{55,690}]},{5,[{1,11381},{3,11381},{27,276}]}],score = []};

get_seal_suit_info(4170) ->
	#base_seal_suit{id = 4170,stage = 17,color = 4,name = "炼狱魂装",suit_type = 0,seal = [6001417,6002417,6003417,6004417,6005417,6006417],attr = [{2,[{4,12047},{6,12047},{54,331}]},{4,[{2,240946},{8,12047},{56,497}]},{6,[{4,12047},{2,240946},{28,331}]}],score = []};

get_seal_suit_info(4171) ->
	#base_seal_suit{id = 4171,stage = 17,color = 4,name = "炼狱传承",suit_type = 1,seal = [6007417,6008417,6009417,6010417,6011417],attr = [{2,[{3,12047},{5,12047},{53,497}]},{4,[{1,12047},{7,12047},{55,828}]},{5,[{1,12047},{3,12047},{27,331}]}],score = []};

get_seal_suit_info(4180) ->
	#base_seal_suit{id = 4180,stage = 18,color = 4,name = "吞天魂装",suit_type = 0,seal = [6001418,6002418,6003418,6004418,6005418,6006418],attr = [{2,[{4,13578},{6,13578},{54,380}]},{4,[{2,271561},{8,13578},{56,570}]},{6,[{4,13578},{2,271561},{28,380}]}],score = []};

get_seal_suit_info(4181) ->
	#base_seal_suit{id = 4181,stage = 18,color = 4,name = "吞天传承",suit_type = 1,seal = [6007418,6008418,6009418,6010418,6011418],attr = [{2,[{3,13578},{5,13578},{53,570}]},{4,[{1,13578},{7,13578},{55,950}]},{5,[{1,13578},{3,13578},{27,380}]}],score = []};

get_seal_suit_info(5070) ->
	#base_seal_suit{id = 5070,stage = 7,color = 5,name = "烈阳魂装",suit_type = 0,seal = [6001507,6002507,6003507,6004507,6005507,6006507],attr = [{2,[{4,3998},{6,3998},{54,70}]},{4,[{2,79958},{8,3998},{56,105}]},{6,[{4,3998},{2,79958},{28,70}]}],score = []};

get_seal_suit_info(5071) ->
	#base_seal_suit{id = 5071,stage = 7,color = 5,name = "烈阳传承",suit_type = 1,seal = [6007507,6008507,6009507,6010507,6011507],attr = [{2,[{3,3998},{5,3998},{53,105}]},{4,[{1,3998},{7,3998},{55,175}]},{5,[{1,3998},{3,3998},{27,70}]}],score = []};

get_seal_suit_info(5080) ->
	#base_seal_suit{id = 5080,stage = 8,color = 5,name = "清秋魂装",suit_type = 0,seal = [6001508,6002508,6003508,6004508,6005508,6006508],attr = [{2,[{4,4898},{6,4898},{54,83}]},{4,[{2,97960},{8,4898},{56,125}]},{6,[{4,4898},{2,97960},{28,83}]}],score = []};

get_seal_suit_info(5081) ->
	#base_seal_suit{id = 5081,stage = 8,color = 5,name = "清秋传承",suit_type = 1,seal = [6007508,6008508,6009508,6010508,6011508],attr = [{2,[{3,4898},{5,4898},{53,125}]},{4,[{1,4898},{7,4898},{55,209}]},{5,[{1,4898},{3,4898},{27,83}]}],score = []};

get_seal_suit_info(5090) ->
	#base_seal_suit{id = 5090,stage = 9,color = 5,name = "北辰魂装",suit_type = 0,seal = [6001509,6002509,6003509,6004509,6005509,6006509],attr = [{2,[{4,5505},{6,5505},{54,109}]},{4,[{2,110110},{8,5505},{56,163}]},{6,[{4,5505},{2,110110},{28,109}]}],score = []};

get_seal_suit_info(5091) ->
	#base_seal_suit{id = 5091,stage = 9,color = 5,name = "北辰传承",suit_type = 1,seal = [6007509,6008509,6009509,6010509,6011509],attr = [{2,[{3,5505},{5,5505},{53,163}]},{4,[{1,5505},{7,5505},{55,272}]},{5,[{1,5505},{3,5505},{27,109}]}],score = []};

get_seal_suit_info(5100) ->
	#base_seal_suit{id = 5100,stage = 10,color = 5,name = "弦风魂装",suit_type = 0,seal = [6001510,6002510,6003510,6004510,6005510,6006510],attr = [{2,[{4,6894},{6,6894},{54,131}]},{4,[{2,137878},{8,6894},{56,197}]},{6,[{4,6894},{2,137878},{28,131}]}],score = []};

get_seal_suit_info(5101) ->
	#base_seal_suit{id = 5101,stage = 10,color = 5,name = "弦风传承",suit_type = 1,seal = [6007510,6008510,6009510,6010510,6011510],attr = [{2,[{3,6894},{5,6894},{53,197}]},{4,[{1,6894},{7,6894},{55,328}]},{5,[{1,6894},{3,6894},{27,131}]}],score = []};

get_seal_suit_info(5110) ->
	#base_seal_suit{id = 5110,stage = 11,color = 5,name = "水月魂装",suit_type = 0,seal = [6001511,6002511,6003511,6004511,6005511,6006511],attr = [{2,[{4,7510},{6,7510},{54,165}]},{4,[{2,150219},{8,7510},{56,247}]},{6,[{4,7510},{2,150219},{28,165}]}],score = []};

get_seal_suit_info(5111) ->
	#base_seal_suit{id = 5111,stage = 11,color = 5,name = "水月传承",suit_type = 1,seal = [6007511,6008511,6009511,6010511,6011511],attr = [{2,[{3,7510},{5,7510},{53,247}]},{4,[{1,7510},{7,7510},{55,412}]},{5,[{1,7510},{3,7510},{27,165}]}],score = []};

get_seal_suit_info(5120) ->
	#base_seal_suit{id = 5120,stage = 12,color = 5,name = "熔火魂装",suit_type = 0,seal = [6001512,6002512,6003512,6004512,6005512,6006512],attr = [{2,[{4,8947},{6,8947},{54,189}]},{4,[{2,178951},{8,8947},{56,284}]},{6,[{4,8947},{2,178951},{28,189}]}],score = []};

get_seal_suit_info(5121) ->
	#base_seal_suit{id = 5121,stage = 12,color = 5,name = "熔火传承",suit_type = 1,seal = [6007512,6008512,6009512,6010512,6011512],attr = [{2,[{3,8947},{5,8947},{53,284}]},{4,[{1,8947},{7,8947},{55,473}]},{5,[{1,8947},{3,8947},{27,189}]}],score = []};

get_seal_suit_info(5130) ->
	#base_seal_suit{id = 5130,stage = 13,color = 5,name = "幽泣魂装",suit_type = 0,seal = [6001513,6002513,6003513,6004513,6005513,6006513],attr = [{2,[{4,9574},{6,9574},{54,233}]},{4,[{2,191486},{8,9574},{56,349}]},{6,[{4,9574},{2,191486},{28,233}]}],score = []};

get_seal_suit_info(5131) ->
	#base_seal_suit{id = 5131,stage = 13,color = 5,name = "幽泣传承",suit_type = 1,seal = [6007513,6008513,6009513,6010513,6011513],attr = [{2,[{3,9574},{5,9574},{53,349}]},{4,[{1,9574},{7,9574},{55,582}]},{5,[{1,9574},{3,9574},{27,233}]}],score = []};

get_seal_suit_info(5140) ->
	#base_seal_suit{id = 5140,stage = 14,color = 5,name = "永夜魂装",suit_type = 0,seal = [6001514,6002514,6003514,6004514,6005514,6006514],attr = [{2,[{4,11041},{6,11041},{54,268}]},{4,[{2,220797},{8,11041},{56,402}]},{6,[{4,11041},{2,220797},{28,268}]}],score = []};

get_seal_suit_info(5141) ->
	#base_seal_suit{id = 5141,stage = 14,color = 5,name = "永夜传承",suit_type = 1,seal = [6007514,6008514,6009514,6010514,6011514],attr = [{2,[{3,11041},{5,11041},{53,402}]},{4,[{1,11041},{7,11041},{55,669}]},{5,[{1,11041},{3,11041},{27,268}]}],score = []};

get_seal_suit_info(5150) ->
	#base_seal_suit{id = 5150,stage = 15,color = 5,name = "荣光魂装",suit_type = 0,seal = [6001515,6002515,6003515,6004515,6005515,6006515],attr = [{2,[{4,11685},{6,11685},{54,321}]},{4,[{2,233718},{8,11685},{56,482}]},{6,[{4,11685},{2,233718},{28,321}]}],score = []};

get_seal_suit_info(5151) ->
	#base_seal_suit{id = 5151,stage = 15,color = 5,name = "荣光传承",suit_type = 1,seal = [6007515,6008515,6009515,6010515,6011515],attr = [{2,[{3,11685},{5,11685},{53,482}]},{4,[{1,11685},{7,11685},{55,803}]},{5,[{1,11685},{3,11685},{27,321}]}],score = []};

get_seal_suit_info(5160) ->
	#base_seal_suit{id = 5160,stage = 16,color = 5,name = "千锻魂装",suit_type = 0,seal = [6001516,6002516,6003516,6004516,6005516,6006516],attr = [{2,[{4,13171},{6,13171},{54,369}]},{4,[{2,263414},{8,13171},{56,553}]},{6,[{4,13171},{2,263414},{28,369}]}],score = []};

get_seal_suit_info(5161) ->
	#base_seal_suit{id = 5161,stage = 16,color = 5,name = "千锻传承",suit_type = 1,seal = [6007516,6008516,6009516,6010516,6011516],attr = [{2,[{3,13171},{5,13171},{53,553}]},{4,[{1,13171},{7,13171},{55,922}]},{5,[{1,13171},{3,13171},{27,369}]}],score = []};

get_seal_suit_info(5170) ->
	#base_seal_suit{id = 5170,stage = 17,color = 5,name = "琉璃魂装",suit_type = 0,seal = [6001517,6002517,6003517,6004517,6005517,6006517],attr = [{2,[{4,13815},{6,13815},{54,422}]},{4,[{2,276335},{8,13815},{56,633}]},{6,[{4,13815},{2,276335},{28,422}]}],score = []};

get_seal_suit_info(5171) ->
	#base_seal_suit{id = 5171,stage = 17,color = 5,name = "琉璃传承",suit_type = 1,seal = [6007517,6008517,6009517,6010517,6011517],attr = [{2,[{3,13815},{5,13815},{53,633}]},{4,[{1,13815},{7,13815},{55,1056}]},{5,[{1,13815},{3,13815},{27,422}]}],score = []};

get_seal_suit_info(5180) ->
	#base_seal_suit{id = 5180,stage = 18,color = 5,name = "织木魂装",suit_type = 0,seal = [6001518,6002518,6003518,6004518,6005518,6006518],attr = [{2,[{4,15301},{6,15301},{54,470}]},{4,[{2,306031},{8,15301},{56,704}]},{6,[{4,15301},{2,306031},{28,470}]}],score = []};

get_seal_suit_info(5181) ->
	#base_seal_suit{id = 5181,stage = 18,color = 5,name = "织木传承",suit_type = 1,seal = [6007518,6008518,6009518,6010518,6011518],attr = [{2,[{3,15301},{5,15301},{53,704}]},{4,[{1,15301},{7,15301},{55,1175}]},{5,[{1,15301},{3,15301},{27,470}]}],score = []};

get_seal_suit_info(6080) ->
	#base_seal_suit{id = 6080,stage = 8,color = 7,name = "暗灭魂装",suit_type = 0,seal = [6001608,6002608,6003608,6004608,6005608,6006608],attr = [{2,[{4,7031},{6,7031},{54,160}]},{4,[{2,140620},{8,7031},{56,240}]},{6,[{4,7031},{2,140620},{28,160}]}],score = []};

get_seal_suit_info(6081) ->
	#base_seal_suit{id = 6081,stage = 8,color = 7,name = "暗灭传承",suit_type = 1,seal = [6007608,6008608,6009608,6010608,6011608],attr = [{2,[{3,7031},{5,7031},{53,240}]},{4,[{1,7031},{7,7031},{55,400}]},{5,[{1,7031},{3,7031},{27,160}]}],score = []};

get_seal_suit_info(6090) ->
	#base_seal_suit{id = 6090,stage = 9,color = 7,name = "梦长魂装",suit_type = 0,seal = [6001609,6002609,6003609,6004609,6005609,6006609],attr = [{2,[{4,7660},{6,7660},{54,183}]},{4,[{2,153200},{8,7660},{56,275}]},{6,[{4,7660},{2,153200},{28,183}]}],score = []};

get_seal_suit_info(6091) ->
	#base_seal_suit{id = 6091,stage = 9,color = 7,name = "梦长传承",suit_type = 1,seal = [6007609,6008609,6009609,6010609,6011609],attr = [{2,[{3,7660},{5,7660},{53,275}]},{4,[{1,7660},{7,7660},{55,459}]},{5,[{1,7660},{3,7660},{27,183}]}],score = []};

get_seal_suit_info(6100) ->
	#base_seal_suit{id = 6100,stage = 10,color = 7,name = "御空魂装",suit_type = 0,seal = [6001610,6002610,6003610,6004610,6005610,6006610],attr = [{2,[{4,9126},{6,9126},{54,226}]},{4,[{2,182530},{8,9126},{56,339}]},{6,[{4,9126},{2,182530},{28,226}]}],score = []};

get_seal_suit_info(6101) ->
	#base_seal_suit{id = 6101,stage = 10,color = 7,name = "御空传承",suit_type = 1,seal = [6007610,6008610,6009610,6010610,6011610],attr = [{2,[{3,9126},{5,9126},{53,339}]},{4,[{1,9126},{7,9126},{55,565}]},{5,[{1,9126},{3,9126},{27,226}]}],score = []};

get_seal_suit_info(6110) ->
	#base_seal_suit{id = 6110,stage = 11,color = 7,name = "逸尘魂装",suit_type = 0,seal = [6001611,6002611,6003611,6004611,6005611,6006611],attr = [{2,[{4,9765},{6,9765},{54,260}]},{4,[{2,195315},{8,9765},{56,390}]},{6,[{4,9765},{2,195315},{28,260}]}],score = []};

get_seal_suit_info(6111) ->
	#base_seal_suit{id = 6111,stage = 11,color = 7,name = "逸尘传承",suit_type = 1,seal = [6007611,6008611,6009611,6010611,6011611],attr = [{2,[{3,9765},{5,9765},{53,390}]},{4,[{1,9765},{7,9765},{55,649}]},{5,[{1,9765},{3,9765},{27,260}]}],score = []};

get_seal_suit_info(6120) ->
	#base_seal_suit{id = 6120,stage = 12,color = 7,name = "天狼魂装",suit_type = 0,seal = [6001612,6002612,6003612,6004612,6005612,6006612],attr = [{2,[{4,11262},{6,11262},{54,311}]},{4,[{2,225213},{8,11262},{56,468}]},{6,[{4,11262},{2,225213},{28,311}]}],score = []};

get_seal_suit_info(6121) ->
	#base_seal_suit{id = 6121,stage = 12,color = 7,name = "天狼传承",suit_type = 1,seal = [6007612,6008612,6009612,6010612,6011612],attr = [{2,[{3,11262},{5,11262},{53,468}]},{4,[{1,11262},{7,11262},{55,779}]},{5,[{1,11262},{3,11262},{27,311}]}],score = []};

get_seal_suit_info(6130) ->
	#base_seal_suit{id = 6130,stage = 13,color = 7,name = "天音魂装",suit_type = 0,seal = [6001613,6002613,6003613,6004613,6005613,6006613],attr = [{2,[{4,11919},{6,11919},{54,358}]},{4,[{2,238392},{8,11919},{56,536}]},{6,[{4,11919},{2,238392},{28,358}]}],score = []};

get_seal_suit_info(6131) ->
	#base_seal_suit{id = 6131,stage = 13,color = 7,name = "天音传承",suit_type = 1,seal = [6007613,6008613,6009613,6010613,6011613],attr = [{2,[{3,11919},{5,11919},{53,536}]},{4,[{1,11919},{7,11919},{55,894}]},{5,[{1,11919},{3,11919},{27,358}]}],score = []};

get_seal_suit_info(6140) ->
	#base_seal_suit{id = 6140,stage = 14,color = 7,name = "天舞魂装",suit_type = 0,seal = [6001614,6002614,6003614,6004614,6005614,6006614],attr = [{2,[{4,13435},{6,13435},{54,409}]},{4,[{2,268682},{8,13435},{56,614}]},{6,[{4,13435},{2,268682},{28,409}]}],score = []};

get_seal_suit_info(6141) ->
	#base_seal_suit{id = 6141,stage = 14,color = 7,name = "天舞传承",suit_type = 1,seal = [6007614,6008614,6009614,6010614,6011614],attr = [{2,[{3,13435},{5,13435},{53,614}]},{4,[{1,13435},{7,13435},{55,1024}]},{5,[{1,13435},{3,13435},{27,409}]}],score = []};

get_seal_suit_info(6150) ->
	#base_seal_suit{id = 6150,stage = 15,color = 7,name = "天琊魂装",suit_type = 0,seal = [6001615,6002615,6003615,6004615,6005615,6006615],attr = [{2,[{4,14092},{6,14092},{54,456}]},{4,[{2,281861},{8,14092},{56,683}]},{6,[{4,14092},{2,281861},{28,456}]}],score = []};

get_seal_suit_info(6151) ->
	#base_seal_suit{id = 6151,stage = 15,color = 7,name = "天琊传承",suit_type = 1,seal = [6007615,6008615,6009615,6010615,6011615],attr = [{2,[{3,14092},{5,14092},{53,683}]},{4,[{1,14092},{7,14092},{55,1140}]},{5,[{1,14092},{3,14092},{27,456}]}],score = []};

get_seal_suit_info(6160) ->
	#base_seal_suit{id = 6160,stage = 16,color = 7,name = "天罚魂装",suit_type = 0,seal = [6001616,6002616,6003616,6004616,6005616,6006616],attr = [{2,[{4,15607},{6,15607},{54,507}]},{4,[{2,312152},{8,15607},{56,761}]},{6,[{4,15607},{2,312152},{28,507}]}],score = []};

get_seal_suit_info(6161) ->
	#base_seal_suit{id = 6161,stage = 16,color = 7,name = "天罚传承",suit_type = 1,seal = [6007616,6008616,6009616,6010616,6011616],attr = [{2,[{3,15607},{5,15607},{53,761}]},{4,[{1,15607},{7,15607},{55,1270}]},{5,[{1,15607},{3,15607},{27,507}]}],score = []};

get_seal_suit_info(_Id) ->
	[].

get_all_suit_id() ->
[4040,4041,4050,4051,4060,4061,4070,4071,4080,4081,4090,4091,4100,4101,4110,4111,4120,4121,4130,4131,4140,4141,4150,4151,4160,4161,4170,4171,4180,4181,5070,5071,5080,5081,5090,5091,5100,5101,5110,5111,5120,5121,5130,5131,5140,5141,5150,5151,5160,5161,5170,5171,5180,5181,6080,6081,6090,6091,6100,6101,6110,6111,6120,6121,6130,6131,6140,6141,6150,6151,6160,6161].

get_suit_id(4,4,0) ->
[4040];

get_suit_id(4,4,1) ->
[4041];

get_suit_id(5,4,0) ->
[4050];

get_suit_id(5,4,1) ->
[4051];

get_suit_id(6,4,0) ->
[4060];

get_suit_id(6,4,1) ->
[4061];

get_suit_id(7,4,0) ->
[4070];

get_suit_id(7,4,1) ->
[4071];

get_suit_id(7,5,0) ->
[5070];

get_suit_id(7,5,1) ->
[5071];

get_suit_id(8,4,0) ->
[4080];

get_suit_id(8,4,1) ->
[4081];

get_suit_id(8,5,0) ->
[5080];

get_suit_id(8,5,1) ->
[5081];

get_suit_id(8,7,0) ->
[6080];

get_suit_id(8,7,1) ->
[6081];

get_suit_id(9,4,0) ->
[4090];

get_suit_id(9,4,1) ->
[4091];

get_suit_id(9,5,0) ->
[5090];

get_suit_id(9,5,1) ->
[5091];

get_suit_id(9,7,0) ->
[6090];

get_suit_id(9,7,1) ->
[6091];

get_suit_id(10,4,0) ->
[4100];

get_suit_id(10,4,1) ->
[4101];

get_suit_id(10,5,0) ->
[5100];

get_suit_id(10,5,1) ->
[5101];

get_suit_id(10,7,0) ->
[6100];

get_suit_id(10,7,1) ->
[6101];

get_suit_id(11,4,0) ->
[4110];

get_suit_id(11,4,1) ->
[4111];

get_suit_id(11,5,0) ->
[5110];

get_suit_id(11,5,1) ->
[5111];

get_suit_id(11,7,0) ->
[6110];

get_suit_id(11,7,1) ->
[6111];

get_suit_id(12,4,0) ->
[4120];

get_suit_id(12,4,1) ->
[4121];

get_suit_id(12,5,0) ->
[5120];

get_suit_id(12,5,1) ->
[5121];

get_suit_id(12,7,0) ->
[6120];

get_suit_id(12,7,1) ->
[6121];

get_suit_id(13,4,0) ->
[4130];

get_suit_id(13,4,1) ->
[4131];

get_suit_id(13,5,0) ->
[5130];

get_suit_id(13,5,1) ->
[5131];

get_suit_id(13,7,0) ->
[6130];

get_suit_id(13,7,1) ->
[6131];

get_suit_id(14,4,0) ->
[4140];

get_suit_id(14,4,1) ->
[4141];

get_suit_id(14,5,0) ->
[5140];

get_suit_id(14,5,1) ->
[5141];

get_suit_id(14,7,0) ->
[6140];

get_suit_id(14,7,1) ->
[6141];

get_suit_id(15,4,0) ->
[4150];

get_suit_id(15,4,1) ->
[4151];

get_suit_id(15,5,0) ->
[5150];

get_suit_id(15,5,1) ->
[5151];

get_suit_id(15,7,0) ->
[6150];

get_suit_id(15,7,1) ->
[6151];

get_suit_id(16,4,0) ->
[4160];

get_suit_id(16,4,1) ->
[4161];

get_suit_id(16,5,0) ->
[5160];

get_suit_id(16,5,1) ->
[5161];

get_suit_id(16,7,0) ->
[6160];

get_suit_id(16,7,1) ->
[6161];

get_suit_id(17,4,0) ->
[4170];

get_suit_id(17,4,1) ->
[4171];

get_suit_id(17,5,0) ->
[5170];

get_suit_id(17,5,1) ->
[5171];

get_suit_id(18,4,0) ->
[4180];

get_suit_id(18,4,1) ->
[4181];

get_suit_id(18,5,0) ->
[5180];

get_suit_id(18,5,1) ->
[5181];

get_suit_id(_Stage,_Color,_Suittype) ->
	[].

get_seal_strong_info(1,0) ->
	#base_seal_strong{id = 1,lv = 0,cost = [],add_attr = [{4,0},{6,0}]};

get_seal_strong_info(1,1) ->
	#base_seal_strong{id = 1,lv = 1,cost = [{255,23,10}],add_attr = [{4,10},{6,5}]};

get_seal_strong_info(1,2) ->
	#base_seal_strong{id = 1,lv = 2,cost = [{255,23,14}],add_attr = [{4,20},{6,10}]};

get_seal_strong_info(1,3) ->
	#base_seal_strong{id = 1,lv = 3,cost = [{255,23,19}],add_attr = [{4,30},{6,15}]};

get_seal_strong_info(1,4) ->
	#base_seal_strong{id = 1,lv = 4,cost = [{255,23,25}],add_attr = [{4,40},{6,20}]};

get_seal_strong_info(1,5) ->
	#base_seal_strong{id = 1,lv = 5,cost = [{255,23,32}],add_attr = [{4,50},{6,25}]};

get_seal_strong_info(1,6) ->
	#base_seal_strong{id = 1,lv = 6,cost = [{255,23,40}],add_attr = [{4,60},{6,30}]};

get_seal_strong_info(1,7) ->
	#base_seal_strong{id = 1,lv = 7,cost = [{255,23,49}],add_attr = [{4,70},{6,35}]};

get_seal_strong_info(1,8) ->
	#base_seal_strong{id = 1,lv = 8,cost = [{255,23,59}],add_attr = [{4,80},{6,40}]};

get_seal_strong_info(1,9) ->
	#base_seal_strong{id = 1,lv = 9,cost = [{255,23,70}],add_attr = [{4,90},{6,45}]};

get_seal_strong_info(1,10) ->
	#base_seal_strong{id = 1,lv = 10,cost = [{255,23,82}],add_attr = [{4,100},{6,50}]};

get_seal_strong_info(1,11) ->
	#base_seal_strong{id = 1,lv = 11,cost = [{255,23,95}],add_attr = [{4,110},{6,55}]};

get_seal_strong_info(1,12) ->
	#base_seal_strong{id = 1,lv = 12,cost = [{255,23,108}],add_attr = [{4,120},{6,60}]};

get_seal_strong_info(1,13) ->
	#base_seal_strong{id = 1,lv = 13,cost = [{255,23,123}],add_attr = [{4,130},{6,65}]};

get_seal_strong_info(1,14) ->
	#base_seal_strong{id = 1,lv = 14,cost = [{255,23,138}],add_attr = [{4,140},{6,70}]};

get_seal_strong_info(1,15) ->
	#base_seal_strong{id = 1,lv = 15,cost = [{255,23,154}],add_attr = [{4,150},{6,75}]};

get_seal_strong_info(1,16) ->
	#base_seal_strong{id = 1,lv = 16,cost = [{255,23,171}],add_attr = [{4,160},{6,80}]};

get_seal_strong_info(1,17) ->
	#base_seal_strong{id = 1,lv = 17,cost = [{255,23,189}],add_attr = [{4,170},{6,85}]};

get_seal_strong_info(1,18) ->
	#base_seal_strong{id = 1,lv = 18,cost = [{255,23,207}],add_attr = [{4,180},{6,90}]};

get_seal_strong_info(1,19) ->
	#base_seal_strong{id = 1,lv = 19,cost = [{255,23,227}],add_attr = [{4,190},{6,95}]};

get_seal_strong_info(1,20) ->
	#base_seal_strong{id = 1,lv = 20,cost = [{255,23,247}],add_attr = [{4,200},{6,100}]};

get_seal_strong_info(1,21) ->
	#base_seal_strong{id = 1,lv = 21,cost = [{255,23,268}],add_attr = [{4,210},{6,105}]};

get_seal_strong_info(1,22) ->
	#base_seal_strong{id = 1,lv = 22,cost = [{255,23,290}],add_attr = [{4,220},{6,110}]};

get_seal_strong_info(1,23) ->
	#base_seal_strong{id = 1,lv = 23,cost = [{255,23,312}],add_attr = [{4,230},{6,115}]};

get_seal_strong_info(1,24) ->
	#base_seal_strong{id = 1,lv = 24,cost = [{255,23,335}],add_attr = [{4,240},{6,120}]};

get_seal_strong_info(1,25) ->
	#base_seal_strong{id = 1,lv = 25,cost = [{255,23,359}],add_attr = [{4,250},{6,125}]};

get_seal_strong_info(1,26) ->
	#base_seal_strong{id = 1,lv = 26,cost = [{255,23,384}],add_attr = [{4,260},{6,130}]};

get_seal_strong_info(1,27) ->
	#base_seal_strong{id = 1,lv = 27,cost = [{255,23,410}],add_attr = [{4,270},{6,135}]};

get_seal_strong_info(1,28) ->
	#base_seal_strong{id = 1,lv = 28,cost = [{255,23,436}],add_attr = [{4,280},{6,140}]};

get_seal_strong_info(1,29) ->
	#base_seal_strong{id = 1,lv = 29,cost = [{255,23,463}],add_attr = [{4,290},{6,145}]};

get_seal_strong_info(1,30) ->
	#base_seal_strong{id = 1,lv = 30,cost = [{255,23,491}],add_attr = [{4,300},{6,150}]};

get_seal_strong_info(1,31) ->
	#base_seal_strong{id = 1,lv = 31,cost = [{255,23,519}],add_attr = [{4,310},{6,155}]};

get_seal_strong_info(1,32) ->
	#base_seal_strong{id = 1,lv = 32,cost = [{255,23,548}],add_attr = [{4,320},{6,160}]};

get_seal_strong_info(1,33) ->
	#base_seal_strong{id = 1,lv = 33,cost = [{255,23,578}],add_attr = [{4,330},{6,165}]};

get_seal_strong_info(1,34) ->
	#base_seal_strong{id = 1,lv = 34,cost = [{255,23,609}],add_attr = [{4,340},{6,170}]};

get_seal_strong_info(1,35) ->
	#base_seal_strong{id = 1,lv = 35,cost = [{255,23,640}],add_attr = [{4,350},{6,175}]};

get_seal_strong_info(1,36) ->
	#base_seal_strong{id = 1,lv = 36,cost = [{255,23,672}],add_attr = [{4,360},{6,180}]};

get_seal_strong_info(1,37) ->
	#base_seal_strong{id = 1,lv = 37,cost = [{255,23,705}],add_attr = [{4,370},{6,185}]};

get_seal_strong_info(1,38) ->
	#base_seal_strong{id = 1,lv = 38,cost = [{255,23,738}],add_attr = [{4,380},{6,190}]};

get_seal_strong_info(1,39) ->
	#base_seal_strong{id = 1,lv = 39,cost = [{255,23,772}],add_attr = [{4,390},{6,195}]};

get_seal_strong_info(1,40) ->
	#base_seal_strong{id = 1,lv = 40,cost = [{255,23,807}],add_attr = [{4,400},{6,200}]};

get_seal_strong_info(1,41) ->
	#base_seal_strong{id = 1,lv = 41,cost = [{255,23,842}],add_attr = [{4,410},{6,205}]};

get_seal_strong_info(1,42) ->
	#base_seal_strong{id = 1,lv = 42,cost = [{255,23,878}],add_attr = [{4,420},{6,210}]};

get_seal_strong_info(1,43) ->
	#base_seal_strong{id = 1,lv = 43,cost = [{255,23,915}],add_attr = [{4,430},{6,215}]};

get_seal_strong_info(1,44) ->
	#base_seal_strong{id = 1,lv = 44,cost = [{255,23,953}],add_attr = [{4,440},{6,220}]};

get_seal_strong_info(1,45) ->
	#base_seal_strong{id = 1,lv = 45,cost = [{255,23,991}],add_attr = [{4,450},{6,225}]};

get_seal_strong_info(1,46) ->
	#base_seal_strong{id = 1,lv = 46,cost = [{255,23,1030}],add_attr = [{4,460},{6,230}]};

get_seal_strong_info(1,47) ->
	#base_seal_strong{id = 1,lv = 47,cost = [{255,23,1069}],add_attr = [{4,470},{6,235}]};

get_seal_strong_info(1,48) ->
	#base_seal_strong{id = 1,lv = 48,cost = [{255,23,1109}],add_attr = [{4,480},{6,240}]};

get_seal_strong_info(1,49) ->
	#base_seal_strong{id = 1,lv = 49,cost = [{255,23,1150}],add_attr = [{4,490},{6,245}]};

get_seal_strong_info(1,50) ->
	#base_seal_strong{id = 1,lv = 50,cost = [{255,23,1192}],add_attr = [{4,500},{6,250}]};

get_seal_strong_info(1,51) ->
	#base_seal_strong{id = 1,lv = 51,cost = [{255,23,1234}],add_attr = [{4,510},{6,255}]};

get_seal_strong_info(1,52) ->
	#base_seal_strong{id = 1,lv = 52,cost = [{255,23,1277}],add_attr = [{4,520},{6,260}]};

get_seal_strong_info(1,53) ->
	#base_seal_strong{id = 1,lv = 53,cost = [{255,23,1320}],add_attr = [{4,530},{6,265}]};

get_seal_strong_info(1,54) ->
	#base_seal_strong{id = 1,lv = 54,cost = [{255,23,1364}],add_attr = [{4,540},{6,270}]};

get_seal_strong_info(1,55) ->
	#base_seal_strong{id = 1,lv = 55,cost = [{255,23,1409}],add_attr = [{4,550},{6,275}]};

get_seal_strong_info(1,56) ->
	#base_seal_strong{id = 1,lv = 56,cost = [{255,23,1454}],add_attr = [{4,560},{6,280}]};

get_seal_strong_info(1,57) ->
	#base_seal_strong{id = 1,lv = 57,cost = [{255,23,1500}],add_attr = [{4,570},{6,285}]};

get_seal_strong_info(1,58) ->
	#base_seal_strong{id = 1,lv = 58,cost = [{255,23,1547}],add_attr = [{4,580},{6,290}]};

get_seal_strong_info(1,59) ->
	#base_seal_strong{id = 1,lv = 59,cost = [{255,23,1594}],add_attr = [{4,590},{6,295}]};

get_seal_strong_info(1,60) ->
	#base_seal_strong{id = 1,lv = 60,cost = [{255,23,1642}],add_attr = [{4,600},{6,300}]};

get_seal_strong_info(1,61) ->
	#base_seal_strong{id = 1,lv = 61,cost = [{255,23,1691}],add_attr = [{4,610},{6,305}]};

get_seal_strong_info(1,62) ->
	#base_seal_strong{id = 1,lv = 62,cost = [{255,23,1740}],add_attr = [{4,620},{6,310}]};

get_seal_strong_info(1,63) ->
	#base_seal_strong{id = 1,lv = 63,cost = [{255,23,1790}],add_attr = [{4,630},{6,315}]};

get_seal_strong_info(1,64) ->
	#base_seal_strong{id = 1,lv = 64,cost = [{255,23,1840}],add_attr = [{4,640},{6,320}]};

get_seal_strong_info(1,65) ->
	#base_seal_strong{id = 1,lv = 65,cost = [{255,23,1891}],add_attr = [{4,650},{6,325}]};

get_seal_strong_info(1,66) ->
	#base_seal_strong{id = 1,lv = 66,cost = [{255,23,1943}],add_attr = [{4,660},{6,330}]};

get_seal_strong_info(1,67) ->
	#base_seal_strong{id = 1,lv = 67,cost = [{255,23,1995}],add_attr = [{4,670},{6,335}]};

get_seal_strong_info(1,68) ->
	#base_seal_strong{id = 1,lv = 68,cost = [{255,23,2048}],add_attr = [{4,680},{6,340}]};

get_seal_strong_info(1,69) ->
	#base_seal_strong{id = 1,lv = 69,cost = [{255,23,2102}],add_attr = [{4,690},{6,345}]};

get_seal_strong_info(1,70) ->
	#base_seal_strong{id = 1,lv = 70,cost = [{255,23,2156}],add_attr = [{4,700},{6,350}]};

get_seal_strong_info(1,71) ->
	#base_seal_strong{id = 1,lv = 71,cost = [{255,23,2211}],add_attr = [{4,710},{6,355}]};

get_seal_strong_info(1,72) ->
	#base_seal_strong{id = 1,lv = 72,cost = [{255,23,2266}],add_attr = [{4,720},{6,360}]};

get_seal_strong_info(1,73) ->
	#base_seal_strong{id = 1,lv = 73,cost = [{255,23,2322}],add_attr = [{4,730},{6,365}]};

get_seal_strong_info(1,74) ->
	#base_seal_strong{id = 1,lv = 74,cost = [{255,23,2379}],add_attr = [{4,740},{6,370}]};

get_seal_strong_info(1,75) ->
	#base_seal_strong{id = 1,lv = 75,cost = [{255,23,2436}],add_attr = [{4,750},{6,375}]};

get_seal_strong_info(1,76) ->
	#base_seal_strong{id = 1,lv = 76,cost = [{255,23,2494}],add_attr = [{4,760},{6,380}]};

get_seal_strong_info(1,77) ->
	#base_seal_strong{id = 1,lv = 77,cost = [{255,23,2552}],add_attr = [{4,770},{6,385}]};

get_seal_strong_info(1,78) ->
	#base_seal_strong{id = 1,lv = 78,cost = [{255,23,2612}],add_attr = [{4,780},{6,390}]};

get_seal_strong_info(1,79) ->
	#base_seal_strong{id = 1,lv = 79,cost = [{255,23,2671}],add_attr = [{4,790},{6,395}]};

get_seal_strong_info(1,80) ->
	#base_seal_strong{id = 1,lv = 80,cost = [{255,23,2731}],add_attr = [{4,800},{6,400}]};

get_seal_strong_info(1,81) ->
	#base_seal_strong{id = 1,lv = 81,cost = [{255,23,2792}],add_attr = [{4,810},{6,405}]};

get_seal_strong_info(1,82) ->
	#base_seal_strong{id = 1,lv = 82,cost = [{255,23,2854}],add_attr = [{4,820},{6,410}]};

get_seal_strong_info(1,83) ->
	#base_seal_strong{id = 1,lv = 83,cost = [{255,23,2916}],add_attr = [{4,830},{6,415}]};

get_seal_strong_info(1,84) ->
	#base_seal_strong{id = 1,lv = 84,cost = [{255,23,2978}],add_attr = [{4,840},{6,420}]};

get_seal_strong_info(1,85) ->
	#base_seal_strong{id = 1,lv = 85,cost = [{255,23,3042}],add_attr = [{4,850},{6,425}]};

get_seal_strong_info(1,86) ->
	#base_seal_strong{id = 1,lv = 86,cost = [{255,23,3105}],add_attr = [{4,860},{6,430}]};

get_seal_strong_info(1,87) ->
	#base_seal_strong{id = 1,lv = 87,cost = [{255,23,3170}],add_attr = [{4,870},{6,435}]};

get_seal_strong_info(1,88) ->
	#base_seal_strong{id = 1,lv = 88,cost = [{255,23,3235}],add_attr = [{4,880},{6,440}]};

get_seal_strong_info(1,89) ->
	#base_seal_strong{id = 1,lv = 89,cost = [{255,23,3300}],add_attr = [{4,890},{6,445}]};

get_seal_strong_info(1,90) ->
	#base_seal_strong{id = 1,lv = 90,cost = [{255,23,3366}],add_attr = [{4,900},{6,450}]};

get_seal_strong_info(1,91) ->
	#base_seal_strong{id = 1,lv = 91,cost = [{255,23,3433}],add_attr = [{4,910},{6,455}]};

get_seal_strong_info(1,92) ->
	#base_seal_strong{id = 1,lv = 92,cost = [{255,23,3501}],add_attr = [{4,920},{6,460}]};

get_seal_strong_info(1,93) ->
	#base_seal_strong{id = 1,lv = 93,cost = [{255,23,3568}],add_attr = [{4,930},{6,465}]};

get_seal_strong_info(1,94) ->
	#base_seal_strong{id = 1,lv = 94,cost = [{255,23,3637}],add_attr = [{4,940},{6,470}]};

get_seal_strong_info(1,95) ->
	#base_seal_strong{id = 1,lv = 95,cost = [{255,23,3706}],add_attr = [{4,950},{6,475}]};

get_seal_strong_info(1,96) ->
	#base_seal_strong{id = 1,lv = 96,cost = [{255,23,3776}],add_attr = [{4,960},{6,480}]};

get_seal_strong_info(1,97) ->
	#base_seal_strong{id = 1,lv = 97,cost = [{255,23,3846}],add_attr = [{4,970},{6,485}]};

get_seal_strong_info(1,98) ->
	#base_seal_strong{id = 1,lv = 98,cost = [{255,23,3917}],add_attr = [{4,980},{6,490}]};

get_seal_strong_info(1,99) ->
	#base_seal_strong{id = 1,lv = 99,cost = [{255,23,3988}],add_attr = [{4,990},{6,495}]};

get_seal_strong_info(1,100) ->
	#base_seal_strong{id = 1,lv = 100,cost = [{255,23,4060}],add_attr = [{4,1000},{6,500}]};

get_seal_strong_info(2,0) ->
	#base_seal_strong{id = 2,lv = 0,cost = [],add_attr = [{2,0},{6,0}]};

get_seal_strong_info(2,1) ->
	#base_seal_strong{id = 2,lv = 1,cost = [{255,23,10}],add_attr = [{2,200},{6,5}]};

get_seal_strong_info(2,2) ->
	#base_seal_strong{id = 2,lv = 2,cost = [{255,23,14}],add_attr = [{2,400},{6,10}]};

get_seal_strong_info(2,3) ->
	#base_seal_strong{id = 2,lv = 3,cost = [{255,23,19}],add_attr = [{2,600},{6,15}]};

get_seal_strong_info(2,4) ->
	#base_seal_strong{id = 2,lv = 4,cost = [{255,23,25}],add_attr = [{2,800},{6,20}]};

get_seal_strong_info(2,5) ->
	#base_seal_strong{id = 2,lv = 5,cost = [{255,23,32}],add_attr = [{2,1000},{6,25}]};

get_seal_strong_info(2,6) ->
	#base_seal_strong{id = 2,lv = 6,cost = [{255,23,40}],add_attr = [{2,1200},{6,30}]};

get_seal_strong_info(2,7) ->
	#base_seal_strong{id = 2,lv = 7,cost = [{255,23,49}],add_attr = [{2,1400},{6,35}]};

get_seal_strong_info(2,8) ->
	#base_seal_strong{id = 2,lv = 8,cost = [{255,23,59}],add_attr = [{2,1600},{6,40}]};

get_seal_strong_info(2,9) ->
	#base_seal_strong{id = 2,lv = 9,cost = [{255,23,70}],add_attr = [{2,1800},{6,45}]};

get_seal_strong_info(2,10) ->
	#base_seal_strong{id = 2,lv = 10,cost = [{255,23,82}],add_attr = [{2,2000},{6,50}]};

get_seal_strong_info(2,11) ->
	#base_seal_strong{id = 2,lv = 11,cost = [{255,23,95}],add_attr = [{2,2200},{6,55}]};

get_seal_strong_info(2,12) ->
	#base_seal_strong{id = 2,lv = 12,cost = [{255,23,108}],add_attr = [{2,2400},{6,60}]};

get_seal_strong_info(2,13) ->
	#base_seal_strong{id = 2,lv = 13,cost = [{255,23,123}],add_attr = [{2,2600},{6,65}]};

get_seal_strong_info(2,14) ->
	#base_seal_strong{id = 2,lv = 14,cost = [{255,23,138}],add_attr = [{2,2800},{6,70}]};

get_seal_strong_info(2,15) ->
	#base_seal_strong{id = 2,lv = 15,cost = [{255,23,154}],add_attr = [{2,3000},{6,75}]};

get_seal_strong_info(2,16) ->
	#base_seal_strong{id = 2,lv = 16,cost = [{255,23,171}],add_attr = [{2,3200},{6,80}]};

get_seal_strong_info(2,17) ->
	#base_seal_strong{id = 2,lv = 17,cost = [{255,23,189}],add_attr = [{2,3400},{6,85}]};

get_seal_strong_info(2,18) ->
	#base_seal_strong{id = 2,lv = 18,cost = [{255,23,207}],add_attr = [{2,3600},{6,90}]};

get_seal_strong_info(2,19) ->
	#base_seal_strong{id = 2,lv = 19,cost = [{255,23,227}],add_attr = [{2,3800},{6,95}]};

get_seal_strong_info(2,20) ->
	#base_seal_strong{id = 2,lv = 20,cost = [{255,23,247}],add_attr = [{2,4000},{6,100}]};

get_seal_strong_info(2,21) ->
	#base_seal_strong{id = 2,lv = 21,cost = [{255,23,268}],add_attr = [{2,4200},{6,105}]};

get_seal_strong_info(2,22) ->
	#base_seal_strong{id = 2,lv = 22,cost = [{255,23,290}],add_attr = [{2,4400},{6,110}]};

get_seal_strong_info(2,23) ->
	#base_seal_strong{id = 2,lv = 23,cost = [{255,23,312}],add_attr = [{2,4600},{6,115}]};

get_seal_strong_info(2,24) ->
	#base_seal_strong{id = 2,lv = 24,cost = [{255,23,335}],add_attr = [{2,4800},{6,120}]};

get_seal_strong_info(2,25) ->
	#base_seal_strong{id = 2,lv = 25,cost = [{255,23,359}],add_attr = [{2,5000},{6,125}]};

get_seal_strong_info(2,26) ->
	#base_seal_strong{id = 2,lv = 26,cost = [{255,23,384}],add_attr = [{2,5200},{6,130}]};

get_seal_strong_info(2,27) ->
	#base_seal_strong{id = 2,lv = 27,cost = [{255,23,410}],add_attr = [{2,5400},{6,135}]};

get_seal_strong_info(2,28) ->
	#base_seal_strong{id = 2,lv = 28,cost = [{255,23,436}],add_attr = [{2,5600},{6,140}]};

get_seal_strong_info(2,29) ->
	#base_seal_strong{id = 2,lv = 29,cost = [{255,23,463}],add_attr = [{2,5800},{6,145}]};

get_seal_strong_info(2,30) ->
	#base_seal_strong{id = 2,lv = 30,cost = [{255,23,491}],add_attr = [{2,6000},{6,150}]};

get_seal_strong_info(2,31) ->
	#base_seal_strong{id = 2,lv = 31,cost = [{255,23,519}],add_attr = [{2,6200},{6,155}]};

get_seal_strong_info(2,32) ->
	#base_seal_strong{id = 2,lv = 32,cost = [{255,23,548}],add_attr = [{2,6400},{6,160}]};

get_seal_strong_info(2,33) ->
	#base_seal_strong{id = 2,lv = 33,cost = [{255,23,578}],add_attr = [{2,6600},{6,165}]};

get_seal_strong_info(2,34) ->
	#base_seal_strong{id = 2,lv = 34,cost = [{255,23,609}],add_attr = [{2,6800},{6,170}]};

get_seal_strong_info(2,35) ->
	#base_seal_strong{id = 2,lv = 35,cost = [{255,23,640}],add_attr = [{2,7000},{6,175}]};

get_seal_strong_info(2,36) ->
	#base_seal_strong{id = 2,lv = 36,cost = [{255,23,672}],add_attr = [{2,7200},{6,180}]};

get_seal_strong_info(2,37) ->
	#base_seal_strong{id = 2,lv = 37,cost = [{255,23,705}],add_attr = [{2,7400},{6,185}]};

get_seal_strong_info(2,38) ->
	#base_seal_strong{id = 2,lv = 38,cost = [{255,23,738}],add_attr = [{2,7600},{6,190}]};

get_seal_strong_info(2,39) ->
	#base_seal_strong{id = 2,lv = 39,cost = [{255,23,772}],add_attr = [{2,7800},{6,195}]};

get_seal_strong_info(2,40) ->
	#base_seal_strong{id = 2,lv = 40,cost = [{255,23,807}],add_attr = [{2,8000},{6,200}]};

get_seal_strong_info(2,41) ->
	#base_seal_strong{id = 2,lv = 41,cost = [{255,23,842}],add_attr = [{2,8200},{6,205}]};

get_seal_strong_info(2,42) ->
	#base_seal_strong{id = 2,lv = 42,cost = [{255,23,878}],add_attr = [{2,8400},{6,210}]};

get_seal_strong_info(2,43) ->
	#base_seal_strong{id = 2,lv = 43,cost = [{255,23,915}],add_attr = [{2,8600},{6,215}]};

get_seal_strong_info(2,44) ->
	#base_seal_strong{id = 2,lv = 44,cost = [{255,23,953}],add_attr = [{2,8800},{6,220}]};

get_seal_strong_info(2,45) ->
	#base_seal_strong{id = 2,lv = 45,cost = [{255,23,991}],add_attr = [{2,9000},{6,225}]};

get_seal_strong_info(2,46) ->
	#base_seal_strong{id = 2,lv = 46,cost = [{255,23,1030}],add_attr = [{2,9200},{6,230}]};

get_seal_strong_info(2,47) ->
	#base_seal_strong{id = 2,lv = 47,cost = [{255,23,1069}],add_attr = [{2,9400},{6,235}]};

get_seal_strong_info(2,48) ->
	#base_seal_strong{id = 2,lv = 48,cost = [{255,23,1109}],add_attr = [{2,9600},{6,240}]};

get_seal_strong_info(2,49) ->
	#base_seal_strong{id = 2,lv = 49,cost = [{255,23,1150}],add_attr = [{2,9800},{6,245}]};

get_seal_strong_info(2,50) ->
	#base_seal_strong{id = 2,lv = 50,cost = [{255,23,1192}],add_attr = [{2,10000},{6,250}]};

get_seal_strong_info(2,51) ->
	#base_seal_strong{id = 2,lv = 51,cost = [{255,23,1234}],add_attr = [{2,10200},{6,255}]};

get_seal_strong_info(2,52) ->
	#base_seal_strong{id = 2,lv = 52,cost = [{255,23,1277}],add_attr = [{2,10400},{6,260}]};

get_seal_strong_info(2,53) ->
	#base_seal_strong{id = 2,lv = 53,cost = [{255,23,1320}],add_attr = [{2,10600},{6,265}]};

get_seal_strong_info(2,54) ->
	#base_seal_strong{id = 2,lv = 54,cost = [{255,23,1364}],add_attr = [{2,10800},{6,270}]};

get_seal_strong_info(2,55) ->
	#base_seal_strong{id = 2,lv = 55,cost = [{255,23,1409}],add_attr = [{2,11000},{6,275}]};

get_seal_strong_info(2,56) ->
	#base_seal_strong{id = 2,lv = 56,cost = [{255,23,1454}],add_attr = [{2,11200},{6,280}]};

get_seal_strong_info(2,57) ->
	#base_seal_strong{id = 2,lv = 57,cost = [{255,23,1500}],add_attr = [{2,11400},{6,285}]};

get_seal_strong_info(2,58) ->
	#base_seal_strong{id = 2,lv = 58,cost = [{255,23,1547}],add_attr = [{2,11600},{6,290}]};

get_seal_strong_info(2,59) ->
	#base_seal_strong{id = 2,lv = 59,cost = [{255,23,1594}],add_attr = [{2,11800},{6,295}]};

get_seal_strong_info(2,60) ->
	#base_seal_strong{id = 2,lv = 60,cost = [{255,23,1642}],add_attr = [{2,12000},{6,300}]};

get_seal_strong_info(2,61) ->
	#base_seal_strong{id = 2,lv = 61,cost = [{255,23,1691}],add_attr = [{2,12200},{6,305}]};

get_seal_strong_info(2,62) ->
	#base_seal_strong{id = 2,lv = 62,cost = [{255,23,1740}],add_attr = [{2,12400},{6,310}]};

get_seal_strong_info(2,63) ->
	#base_seal_strong{id = 2,lv = 63,cost = [{255,23,1790}],add_attr = [{2,12600},{6,315}]};

get_seal_strong_info(2,64) ->
	#base_seal_strong{id = 2,lv = 64,cost = [{255,23,1840}],add_attr = [{2,12800},{6,320}]};

get_seal_strong_info(2,65) ->
	#base_seal_strong{id = 2,lv = 65,cost = [{255,23,1891}],add_attr = [{2,13000},{6,325}]};

get_seal_strong_info(2,66) ->
	#base_seal_strong{id = 2,lv = 66,cost = [{255,23,1943}],add_attr = [{2,13200},{6,330}]};

get_seal_strong_info(2,67) ->
	#base_seal_strong{id = 2,lv = 67,cost = [{255,23,1995}],add_attr = [{2,13400},{6,335}]};

get_seal_strong_info(2,68) ->
	#base_seal_strong{id = 2,lv = 68,cost = [{255,23,2048}],add_attr = [{2,13600},{6,340}]};

get_seal_strong_info(2,69) ->
	#base_seal_strong{id = 2,lv = 69,cost = [{255,23,2102}],add_attr = [{2,13800},{6,345}]};

get_seal_strong_info(2,70) ->
	#base_seal_strong{id = 2,lv = 70,cost = [{255,23,2156}],add_attr = [{2,14000},{6,350}]};

get_seal_strong_info(2,71) ->
	#base_seal_strong{id = 2,lv = 71,cost = [{255,23,2211}],add_attr = [{2,14200},{6,355}]};

get_seal_strong_info(2,72) ->
	#base_seal_strong{id = 2,lv = 72,cost = [{255,23,2266}],add_attr = [{2,14400},{6,360}]};

get_seal_strong_info(2,73) ->
	#base_seal_strong{id = 2,lv = 73,cost = [{255,23,2322}],add_attr = [{2,14600},{6,365}]};

get_seal_strong_info(2,74) ->
	#base_seal_strong{id = 2,lv = 74,cost = [{255,23,2379}],add_attr = [{2,14800},{6,370}]};

get_seal_strong_info(2,75) ->
	#base_seal_strong{id = 2,lv = 75,cost = [{255,23,2436}],add_attr = [{2,15000},{6,375}]};

get_seal_strong_info(2,76) ->
	#base_seal_strong{id = 2,lv = 76,cost = [{255,23,2494}],add_attr = [{2,15200},{6,380}]};

get_seal_strong_info(2,77) ->
	#base_seal_strong{id = 2,lv = 77,cost = [{255,23,2552}],add_attr = [{2,15400},{6,385}]};

get_seal_strong_info(2,78) ->
	#base_seal_strong{id = 2,lv = 78,cost = [{255,23,2612}],add_attr = [{2,15600},{6,390}]};

get_seal_strong_info(2,79) ->
	#base_seal_strong{id = 2,lv = 79,cost = [{255,23,2671}],add_attr = [{2,15800},{6,395}]};

get_seal_strong_info(2,80) ->
	#base_seal_strong{id = 2,lv = 80,cost = [{255,23,2731}],add_attr = [{2,16000},{6,400}]};

get_seal_strong_info(2,81) ->
	#base_seal_strong{id = 2,lv = 81,cost = [{255,23,2792}],add_attr = [{2,16200},{6,405}]};

get_seal_strong_info(2,82) ->
	#base_seal_strong{id = 2,lv = 82,cost = [{255,23,2854}],add_attr = [{2,16400},{6,410}]};

get_seal_strong_info(2,83) ->
	#base_seal_strong{id = 2,lv = 83,cost = [{255,23,2916}],add_attr = [{2,16600},{6,415}]};

get_seal_strong_info(2,84) ->
	#base_seal_strong{id = 2,lv = 84,cost = [{255,23,2978}],add_attr = [{2,16800},{6,420}]};

get_seal_strong_info(2,85) ->
	#base_seal_strong{id = 2,lv = 85,cost = [{255,23,3042}],add_attr = [{2,17000},{6,425}]};

get_seal_strong_info(2,86) ->
	#base_seal_strong{id = 2,lv = 86,cost = [{255,23,3105}],add_attr = [{2,17200},{6,430}]};

get_seal_strong_info(2,87) ->
	#base_seal_strong{id = 2,lv = 87,cost = [{255,23,3170}],add_attr = [{2,17400},{6,435}]};

get_seal_strong_info(2,88) ->
	#base_seal_strong{id = 2,lv = 88,cost = [{255,23,3235}],add_attr = [{2,17600},{6,440}]};

get_seal_strong_info(2,89) ->
	#base_seal_strong{id = 2,lv = 89,cost = [{255,23,3300}],add_attr = [{2,17800},{6,445}]};

get_seal_strong_info(2,90) ->
	#base_seal_strong{id = 2,lv = 90,cost = [{255,23,3366}],add_attr = [{2,18000},{6,450}]};

get_seal_strong_info(2,91) ->
	#base_seal_strong{id = 2,lv = 91,cost = [{255,23,3433}],add_attr = [{2,18200},{6,455}]};

get_seal_strong_info(2,92) ->
	#base_seal_strong{id = 2,lv = 92,cost = [{255,23,3501}],add_attr = [{2,18400},{6,460}]};

get_seal_strong_info(2,93) ->
	#base_seal_strong{id = 2,lv = 93,cost = [{255,23,3568}],add_attr = [{2,18600},{6,465}]};

get_seal_strong_info(2,94) ->
	#base_seal_strong{id = 2,lv = 94,cost = [{255,23,3637}],add_attr = [{2,18800},{6,470}]};

get_seal_strong_info(2,95) ->
	#base_seal_strong{id = 2,lv = 95,cost = [{255,23,3706}],add_attr = [{2,19000},{6,475}]};

get_seal_strong_info(2,96) ->
	#base_seal_strong{id = 2,lv = 96,cost = [{255,23,3776}],add_attr = [{2,19200},{6,480}]};

get_seal_strong_info(2,97) ->
	#base_seal_strong{id = 2,lv = 97,cost = [{255,23,3846}],add_attr = [{2,19400},{6,485}]};

get_seal_strong_info(2,98) ->
	#base_seal_strong{id = 2,lv = 98,cost = [{255,23,3917}],add_attr = [{2,19600},{6,490}]};

get_seal_strong_info(2,99) ->
	#base_seal_strong{id = 2,lv = 99,cost = [{255,23,3988}],add_attr = [{2,19800},{6,495}]};

get_seal_strong_info(2,100) ->
	#base_seal_strong{id = 2,lv = 100,cost = [{255,23,4060}],add_attr = [{2,20000},{6,500}]};

get_seal_strong_info(3,0) ->
	#base_seal_strong{id = 3,lv = 0,cost = [],add_attr = [{2,0},{4,0}]};

get_seal_strong_info(3,1) ->
	#base_seal_strong{id = 3,lv = 1,cost = [{255,23,10}],add_attr = [{2,200},{4,5}]};

get_seal_strong_info(3,2) ->
	#base_seal_strong{id = 3,lv = 2,cost = [{255,23,14}],add_attr = [{2,400},{4,10}]};

get_seal_strong_info(3,3) ->
	#base_seal_strong{id = 3,lv = 3,cost = [{255,23,19}],add_attr = [{2,600},{4,15}]};

get_seal_strong_info(3,4) ->
	#base_seal_strong{id = 3,lv = 4,cost = [{255,23,25}],add_attr = [{2,800},{4,20}]};

get_seal_strong_info(3,5) ->
	#base_seal_strong{id = 3,lv = 5,cost = [{255,23,32}],add_attr = [{2,1000},{4,25}]};

get_seal_strong_info(3,6) ->
	#base_seal_strong{id = 3,lv = 6,cost = [{255,23,40}],add_attr = [{2,1200},{4,30}]};

get_seal_strong_info(3,7) ->
	#base_seal_strong{id = 3,lv = 7,cost = [{255,23,49}],add_attr = [{2,1400},{4,35}]};

get_seal_strong_info(3,8) ->
	#base_seal_strong{id = 3,lv = 8,cost = [{255,23,59}],add_attr = [{2,1600},{4,40}]};

get_seal_strong_info(3,9) ->
	#base_seal_strong{id = 3,lv = 9,cost = [{255,23,70}],add_attr = [{2,1800},{4,45}]};

get_seal_strong_info(3,10) ->
	#base_seal_strong{id = 3,lv = 10,cost = [{255,23,82}],add_attr = [{2,2000},{4,50}]};

get_seal_strong_info(3,11) ->
	#base_seal_strong{id = 3,lv = 11,cost = [{255,23,95}],add_attr = [{2,2200},{4,55}]};

get_seal_strong_info(3,12) ->
	#base_seal_strong{id = 3,lv = 12,cost = [{255,23,108}],add_attr = [{2,2400},{4,60}]};

get_seal_strong_info(3,13) ->
	#base_seal_strong{id = 3,lv = 13,cost = [{255,23,123}],add_attr = [{2,2600},{4,65}]};

get_seal_strong_info(3,14) ->
	#base_seal_strong{id = 3,lv = 14,cost = [{255,23,138}],add_attr = [{2,2800},{4,70}]};

get_seal_strong_info(3,15) ->
	#base_seal_strong{id = 3,lv = 15,cost = [{255,23,154}],add_attr = [{2,3000},{4,75}]};

get_seal_strong_info(3,16) ->
	#base_seal_strong{id = 3,lv = 16,cost = [{255,23,171}],add_attr = [{2,3200},{4,80}]};

get_seal_strong_info(3,17) ->
	#base_seal_strong{id = 3,lv = 17,cost = [{255,23,189}],add_attr = [{2,3400},{4,85}]};

get_seal_strong_info(3,18) ->
	#base_seal_strong{id = 3,lv = 18,cost = [{255,23,207}],add_attr = [{2,3600},{4,90}]};

get_seal_strong_info(3,19) ->
	#base_seal_strong{id = 3,lv = 19,cost = [{255,23,227}],add_attr = [{2,3800},{4,95}]};

get_seal_strong_info(3,20) ->
	#base_seal_strong{id = 3,lv = 20,cost = [{255,23,247}],add_attr = [{2,4000},{4,100}]};

get_seal_strong_info(3,21) ->
	#base_seal_strong{id = 3,lv = 21,cost = [{255,23,268}],add_attr = [{2,4200},{4,105}]};

get_seal_strong_info(3,22) ->
	#base_seal_strong{id = 3,lv = 22,cost = [{255,23,290}],add_attr = [{2,4400},{4,110}]};

get_seal_strong_info(3,23) ->
	#base_seal_strong{id = 3,lv = 23,cost = [{255,23,312}],add_attr = [{2,4600},{4,115}]};

get_seal_strong_info(3,24) ->
	#base_seal_strong{id = 3,lv = 24,cost = [{255,23,335}],add_attr = [{2,4800},{4,120}]};

get_seal_strong_info(3,25) ->
	#base_seal_strong{id = 3,lv = 25,cost = [{255,23,359}],add_attr = [{2,5000},{4,125}]};

get_seal_strong_info(3,26) ->
	#base_seal_strong{id = 3,lv = 26,cost = [{255,23,384}],add_attr = [{2,5200},{4,130}]};

get_seal_strong_info(3,27) ->
	#base_seal_strong{id = 3,lv = 27,cost = [{255,23,410}],add_attr = [{2,5400},{4,135}]};

get_seal_strong_info(3,28) ->
	#base_seal_strong{id = 3,lv = 28,cost = [{255,23,436}],add_attr = [{2,5600},{4,140}]};

get_seal_strong_info(3,29) ->
	#base_seal_strong{id = 3,lv = 29,cost = [{255,23,463}],add_attr = [{2,5800},{4,145}]};

get_seal_strong_info(3,30) ->
	#base_seal_strong{id = 3,lv = 30,cost = [{255,23,491}],add_attr = [{2,6000},{4,150}]};

get_seal_strong_info(3,31) ->
	#base_seal_strong{id = 3,lv = 31,cost = [{255,23,519}],add_attr = [{2,6200},{4,155}]};

get_seal_strong_info(3,32) ->
	#base_seal_strong{id = 3,lv = 32,cost = [{255,23,548}],add_attr = [{2,6400},{4,160}]};

get_seal_strong_info(3,33) ->
	#base_seal_strong{id = 3,lv = 33,cost = [{255,23,578}],add_attr = [{2,6600},{4,165}]};

get_seal_strong_info(3,34) ->
	#base_seal_strong{id = 3,lv = 34,cost = [{255,23,609}],add_attr = [{2,6800},{4,170}]};

get_seal_strong_info(3,35) ->
	#base_seal_strong{id = 3,lv = 35,cost = [{255,23,640}],add_attr = [{2,7000},{4,175}]};

get_seal_strong_info(3,36) ->
	#base_seal_strong{id = 3,lv = 36,cost = [{255,23,672}],add_attr = [{2,7200},{4,180}]};

get_seal_strong_info(3,37) ->
	#base_seal_strong{id = 3,lv = 37,cost = [{255,23,705}],add_attr = [{2,7400},{4,185}]};

get_seal_strong_info(3,38) ->
	#base_seal_strong{id = 3,lv = 38,cost = [{255,23,738}],add_attr = [{2,7600},{4,190}]};

get_seal_strong_info(3,39) ->
	#base_seal_strong{id = 3,lv = 39,cost = [{255,23,772}],add_attr = [{2,7800},{4,195}]};

get_seal_strong_info(3,40) ->
	#base_seal_strong{id = 3,lv = 40,cost = [{255,23,807}],add_attr = [{2,8000},{4,200}]};

get_seal_strong_info(3,41) ->
	#base_seal_strong{id = 3,lv = 41,cost = [{255,23,842}],add_attr = [{2,8200},{4,205}]};

get_seal_strong_info(3,42) ->
	#base_seal_strong{id = 3,lv = 42,cost = [{255,23,878}],add_attr = [{2,8400},{4,210}]};

get_seal_strong_info(3,43) ->
	#base_seal_strong{id = 3,lv = 43,cost = [{255,23,915}],add_attr = [{2,8600},{4,215}]};

get_seal_strong_info(3,44) ->
	#base_seal_strong{id = 3,lv = 44,cost = [{255,23,953}],add_attr = [{2,8800},{4,220}]};

get_seal_strong_info(3,45) ->
	#base_seal_strong{id = 3,lv = 45,cost = [{255,23,991}],add_attr = [{2,9000},{4,225}]};

get_seal_strong_info(3,46) ->
	#base_seal_strong{id = 3,lv = 46,cost = [{255,23,1030}],add_attr = [{2,9200},{4,230}]};

get_seal_strong_info(3,47) ->
	#base_seal_strong{id = 3,lv = 47,cost = [{255,23,1069}],add_attr = [{2,9400},{4,235}]};

get_seal_strong_info(3,48) ->
	#base_seal_strong{id = 3,lv = 48,cost = [{255,23,1109}],add_attr = [{2,9600},{4,240}]};

get_seal_strong_info(3,49) ->
	#base_seal_strong{id = 3,lv = 49,cost = [{255,23,1150}],add_attr = [{2,9800},{4,245}]};

get_seal_strong_info(3,50) ->
	#base_seal_strong{id = 3,lv = 50,cost = [{255,23,1192}],add_attr = [{2,10000},{4,250}]};

get_seal_strong_info(3,51) ->
	#base_seal_strong{id = 3,lv = 51,cost = [{255,23,1234}],add_attr = [{2,10200},{4,255}]};

get_seal_strong_info(3,52) ->
	#base_seal_strong{id = 3,lv = 52,cost = [{255,23,1277}],add_attr = [{2,10400},{4,260}]};

get_seal_strong_info(3,53) ->
	#base_seal_strong{id = 3,lv = 53,cost = [{255,23,1320}],add_attr = [{2,10600},{4,265}]};

get_seal_strong_info(3,54) ->
	#base_seal_strong{id = 3,lv = 54,cost = [{255,23,1364}],add_attr = [{2,10800},{4,270}]};

get_seal_strong_info(3,55) ->
	#base_seal_strong{id = 3,lv = 55,cost = [{255,23,1409}],add_attr = [{2,11000},{4,275}]};

get_seal_strong_info(3,56) ->
	#base_seal_strong{id = 3,lv = 56,cost = [{255,23,1454}],add_attr = [{2,11200},{4,280}]};

get_seal_strong_info(3,57) ->
	#base_seal_strong{id = 3,lv = 57,cost = [{255,23,1500}],add_attr = [{2,11400},{4,285}]};

get_seal_strong_info(3,58) ->
	#base_seal_strong{id = 3,lv = 58,cost = [{255,23,1547}],add_attr = [{2,11600},{4,290}]};

get_seal_strong_info(3,59) ->
	#base_seal_strong{id = 3,lv = 59,cost = [{255,23,1594}],add_attr = [{2,11800},{4,295}]};

get_seal_strong_info(3,60) ->
	#base_seal_strong{id = 3,lv = 60,cost = [{255,23,1642}],add_attr = [{2,12000},{4,300}]};

get_seal_strong_info(3,61) ->
	#base_seal_strong{id = 3,lv = 61,cost = [{255,23,1691}],add_attr = [{2,12200},{4,305}]};

get_seal_strong_info(3,62) ->
	#base_seal_strong{id = 3,lv = 62,cost = [{255,23,1740}],add_attr = [{2,12400},{4,310}]};

get_seal_strong_info(3,63) ->
	#base_seal_strong{id = 3,lv = 63,cost = [{255,23,1790}],add_attr = [{2,12600},{4,315}]};

get_seal_strong_info(3,64) ->
	#base_seal_strong{id = 3,lv = 64,cost = [{255,23,1840}],add_attr = [{2,12800},{4,320}]};

get_seal_strong_info(3,65) ->
	#base_seal_strong{id = 3,lv = 65,cost = [{255,23,1891}],add_attr = [{2,13000},{4,325}]};

get_seal_strong_info(3,66) ->
	#base_seal_strong{id = 3,lv = 66,cost = [{255,23,1943}],add_attr = [{2,13200},{4,330}]};

get_seal_strong_info(3,67) ->
	#base_seal_strong{id = 3,lv = 67,cost = [{255,23,1995}],add_attr = [{2,13400},{4,335}]};

get_seal_strong_info(3,68) ->
	#base_seal_strong{id = 3,lv = 68,cost = [{255,23,2048}],add_attr = [{2,13600},{4,340}]};

get_seal_strong_info(3,69) ->
	#base_seal_strong{id = 3,lv = 69,cost = [{255,23,2102}],add_attr = [{2,13800},{4,345}]};

get_seal_strong_info(3,70) ->
	#base_seal_strong{id = 3,lv = 70,cost = [{255,23,2156}],add_attr = [{2,14000},{4,350}]};

get_seal_strong_info(3,71) ->
	#base_seal_strong{id = 3,lv = 71,cost = [{255,23,2211}],add_attr = [{2,14200},{4,355}]};

get_seal_strong_info(3,72) ->
	#base_seal_strong{id = 3,lv = 72,cost = [{255,23,2266}],add_attr = [{2,14400},{4,360}]};

get_seal_strong_info(3,73) ->
	#base_seal_strong{id = 3,lv = 73,cost = [{255,23,2322}],add_attr = [{2,14600},{4,365}]};

get_seal_strong_info(3,74) ->
	#base_seal_strong{id = 3,lv = 74,cost = [{255,23,2379}],add_attr = [{2,14800},{4,370}]};

get_seal_strong_info(3,75) ->
	#base_seal_strong{id = 3,lv = 75,cost = [{255,23,2436}],add_attr = [{2,15000},{4,375}]};

get_seal_strong_info(3,76) ->
	#base_seal_strong{id = 3,lv = 76,cost = [{255,23,2494}],add_attr = [{2,15200},{4,380}]};

get_seal_strong_info(3,77) ->
	#base_seal_strong{id = 3,lv = 77,cost = [{255,23,2552}],add_attr = [{2,15400},{4,385}]};

get_seal_strong_info(3,78) ->
	#base_seal_strong{id = 3,lv = 78,cost = [{255,23,2612}],add_attr = [{2,15600},{4,390}]};

get_seal_strong_info(3,79) ->
	#base_seal_strong{id = 3,lv = 79,cost = [{255,23,2671}],add_attr = [{2,15800},{4,395}]};

get_seal_strong_info(3,80) ->
	#base_seal_strong{id = 3,lv = 80,cost = [{255,23,2731}],add_attr = [{2,16000},{4,400}]};

get_seal_strong_info(3,81) ->
	#base_seal_strong{id = 3,lv = 81,cost = [{255,23,2792}],add_attr = [{2,16200},{4,405}]};

get_seal_strong_info(3,82) ->
	#base_seal_strong{id = 3,lv = 82,cost = [{255,23,2854}],add_attr = [{2,16400},{4,410}]};

get_seal_strong_info(3,83) ->
	#base_seal_strong{id = 3,lv = 83,cost = [{255,23,2916}],add_attr = [{2,16600},{4,415}]};

get_seal_strong_info(3,84) ->
	#base_seal_strong{id = 3,lv = 84,cost = [{255,23,2978}],add_attr = [{2,16800},{4,420}]};

get_seal_strong_info(3,85) ->
	#base_seal_strong{id = 3,lv = 85,cost = [{255,23,3042}],add_attr = [{2,17000},{4,425}]};

get_seal_strong_info(3,86) ->
	#base_seal_strong{id = 3,lv = 86,cost = [{255,23,3105}],add_attr = [{2,17200},{4,430}]};

get_seal_strong_info(3,87) ->
	#base_seal_strong{id = 3,lv = 87,cost = [{255,23,3170}],add_attr = [{2,17400},{4,435}]};

get_seal_strong_info(3,88) ->
	#base_seal_strong{id = 3,lv = 88,cost = [{255,23,3235}],add_attr = [{2,17600},{4,440}]};

get_seal_strong_info(3,89) ->
	#base_seal_strong{id = 3,lv = 89,cost = [{255,23,3300}],add_attr = [{2,17800},{4,445}]};

get_seal_strong_info(3,90) ->
	#base_seal_strong{id = 3,lv = 90,cost = [{255,23,3366}],add_attr = [{2,18000},{4,450}]};

get_seal_strong_info(3,91) ->
	#base_seal_strong{id = 3,lv = 91,cost = [{255,23,3433}],add_attr = [{2,18200},{4,455}]};

get_seal_strong_info(3,92) ->
	#base_seal_strong{id = 3,lv = 92,cost = [{255,23,3501}],add_attr = [{2,18400},{4,460}]};

get_seal_strong_info(3,93) ->
	#base_seal_strong{id = 3,lv = 93,cost = [{255,23,3568}],add_attr = [{2,18600},{4,465}]};

get_seal_strong_info(3,94) ->
	#base_seal_strong{id = 3,lv = 94,cost = [{255,23,3637}],add_attr = [{2,18800},{4,470}]};

get_seal_strong_info(3,95) ->
	#base_seal_strong{id = 3,lv = 95,cost = [{255,23,3706}],add_attr = [{2,19000},{4,475}]};

get_seal_strong_info(3,96) ->
	#base_seal_strong{id = 3,lv = 96,cost = [{255,23,3776}],add_attr = [{2,19200},{4,480}]};

get_seal_strong_info(3,97) ->
	#base_seal_strong{id = 3,lv = 97,cost = [{255,23,3846}],add_attr = [{2,19400},{4,485}]};

get_seal_strong_info(3,98) ->
	#base_seal_strong{id = 3,lv = 98,cost = [{255,23,3917}],add_attr = [{2,19600},{4,490}]};

get_seal_strong_info(3,99) ->
	#base_seal_strong{id = 3,lv = 99,cost = [{255,23,3988}],add_attr = [{2,19800},{4,495}]};

get_seal_strong_info(3,100) ->
	#base_seal_strong{id = 3,lv = 100,cost = [{255,23,4060}],add_attr = [{2,20000},{4,500}]};

get_seal_strong_info(4,0) ->
	#base_seal_strong{id = 4,lv = 0,cost = [],add_attr = [{2,0},{8,0}]};

get_seal_strong_info(4,1) ->
	#base_seal_strong{id = 4,lv = 1,cost = [{255,23,10}],add_attr = [{2,200},{8,5}]};

get_seal_strong_info(4,2) ->
	#base_seal_strong{id = 4,lv = 2,cost = [{255,23,14}],add_attr = [{2,400},{8,10}]};

get_seal_strong_info(4,3) ->
	#base_seal_strong{id = 4,lv = 3,cost = [{255,23,19}],add_attr = [{2,600},{8,15}]};

get_seal_strong_info(4,4) ->
	#base_seal_strong{id = 4,lv = 4,cost = [{255,23,25}],add_attr = [{2,800},{8,20}]};

get_seal_strong_info(4,5) ->
	#base_seal_strong{id = 4,lv = 5,cost = [{255,23,32}],add_attr = [{2,1000},{8,25}]};

get_seal_strong_info(4,6) ->
	#base_seal_strong{id = 4,lv = 6,cost = [{255,23,40}],add_attr = [{2,1200},{8,30}]};

get_seal_strong_info(4,7) ->
	#base_seal_strong{id = 4,lv = 7,cost = [{255,23,49}],add_attr = [{2,1400},{8,35}]};

get_seal_strong_info(4,8) ->
	#base_seal_strong{id = 4,lv = 8,cost = [{255,23,59}],add_attr = [{2,1600},{8,40}]};

get_seal_strong_info(4,9) ->
	#base_seal_strong{id = 4,lv = 9,cost = [{255,23,70}],add_attr = [{2,1800},{8,45}]};

get_seal_strong_info(4,10) ->
	#base_seal_strong{id = 4,lv = 10,cost = [{255,23,82}],add_attr = [{2,2000},{8,50}]};

get_seal_strong_info(4,11) ->
	#base_seal_strong{id = 4,lv = 11,cost = [{255,23,95}],add_attr = [{2,2200},{8,55}]};

get_seal_strong_info(4,12) ->
	#base_seal_strong{id = 4,lv = 12,cost = [{255,23,108}],add_attr = [{2,2400},{8,60}]};

get_seal_strong_info(4,13) ->
	#base_seal_strong{id = 4,lv = 13,cost = [{255,23,123}],add_attr = [{2,2600},{8,65}]};

get_seal_strong_info(4,14) ->
	#base_seal_strong{id = 4,lv = 14,cost = [{255,23,138}],add_attr = [{2,2800},{8,70}]};

get_seal_strong_info(4,15) ->
	#base_seal_strong{id = 4,lv = 15,cost = [{255,23,154}],add_attr = [{2,3000},{8,75}]};

get_seal_strong_info(4,16) ->
	#base_seal_strong{id = 4,lv = 16,cost = [{255,23,171}],add_attr = [{2,3200},{8,80}]};

get_seal_strong_info(4,17) ->
	#base_seal_strong{id = 4,lv = 17,cost = [{255,23,189}],add_attr = [{2,3400},{8,85}]};

get_seal_strong_info(4,18) ->
	#base_seal_strong{id = 4,lv = 18,cost = [{255,23,207}],add_attr = [{2,3600},{8,90}]};

get_seal_strong_info(4,19) ->
	#base_seal_strong{id = 4,lv = 19,cost = [{255,23,227}],add_attr = [{2,3800},{8,95}]};

get_seal_strong_info(4,20) ->
	#base_seal_strong{id = 4,lv = 20,cost = [{255,23,247}],add_attr = [{2,4000},{8,100}]};

get_seal_strong_info(4,21) ->
	#base_seal_strong{id = 4,lv = 21,cost = [{255,23,268}],add_attr = [{2,4200},{8,105}]};

get_seal_strong_info(4,22) ->
	#base_seal_strong{id = 4,lv = 22,cost = [{255,23,290}],add_attr = [{2,4400},{8,110}]};

get_seal_strong_info(4,23) ->
	#base_seal_strong{id = 4,lv = 23,cost = [{255,23,312}],add_attr = [{2,4600},{8,115}]};

get_seal_strong_info(4,24) ->
	#base_seal_strong{id = 4,lv = 24,cost = [{255,23,335}],add_attr = [{2,4800},{8,120}]};

get_seal_strong_info(4,25) ->
	#base_seal_strong{id = 4,lv = 25,cost = [{255,23,359}],add_attr = [{2,5000},{8,125}]};

get_seal_strong_info(4,26) ->
	#base_seal_strong{id = 4,lv = 26,cost = [{255,23,384}],add_attr = [{2,5200},{8,130}]};

get_seal_strong_info(4,27) ->
	#base_seal_strong{id = 4,lv = 27,cost = [{255,23,410}],add_attr = [{2,5400},{8,135}]};

get_seal_strong_info(4,28) ->
	#base_seal_strong{id = 4,lv = 28,cost = [{255,23,436}],add_attr = [{2,5600},{8,140}]};

get_seal_strong_info(4,29) ->
	#base_seal_strong{id = 4,lv = 29,cost = [{255,23,463}],add_attr = [{2,5800},{8,145}]};

get_seal_strong_info(4,30) ->
	#base_seal_strong{id = 4,lv = 30,cost = [{255,23,491}],add_attr = [{2,6000},{8,150}]};

get_seal_strong_info(4,31) ->
	#base_seal_strong{id = 4,lv = 31,cost = [{255,23,519}],add_attr = [{2,6200},{8,155}]};

get_seal_strong_info(4,32) ->
	#base_seal_strong{id = 4,lv = 32,cost = [{255,23,548}],add_attr = [{2,6400},{8,160}]};

get_seal_strong_info(4,33) ->
	#base_seal_strong{id = 4,lv = 33,cost = [{255,23,578}],add_attr = [{2,6600},{8,165}]};

get_seal_strong_info(4,34) ->
	#base_seal_strong{id = 4,lv = 34,cost = [{255,23,609}],add_attr = [{2,6800},{8,170}]};

get_seal_strong_info(4,35) ->
	#base_seal_strong{id = 4,lv = 35,cost = [{255,23,640}],add_attr = [{2,7000},{8,175}]};

get_seal_strong_info(4,36) ->
	#base_seal_strong{id = 4,lv = 36,cost = [{255,23,672}],add_attr = [{2,7200},{8,180}]};

get_seal_strong_info(4,37) ->
	#base_seal_strong{id = 4,lv = 37,cost = [{255,23,705}],add_attr = [{2,7400},{8,185}]};

get_seal_strong_info(4,38) ->
	#base_seal_strong{id = 4,lv = 38,cost = [{255,23,738}],add_attr = [{2,7600},{8,190}]};

get_seal_strong_info(4,39) ->
	#base_seal_strong{id = 4,lv = 39,cost = [{255,23,772}],add_attr = [{2,7800},{8,195}]};

get_seal_strong_info(4,40) ->
	#base_seal_strong{id = 4,lv = 40,cost = [{255,23,807}],add_attr = [{2,8000},{8,200}]};

get_seal_strong_info(4,41) ->
	#base_seal_strong{id = 4,lv = 41,cost = [{255,23,842}],add_attr = [{2,8200},{8,205}]};

get_seal_strong_info(4,42) ->
	#base_seal_strong{id = 4,lv = 42,cost = [{255,23,878}],add_attr = [{2,8400},{8,210}]};

get_seal_strong_info(4,43) ->
	#base_seal_strong{id = 4,lv = 43,cost = [{255,23,915}],add_attr = [{2,8600},{8,215}]};

get_seal_strong_info(4,44) ->
	#base_seal_strong{id = 4,lv = 44,cost = [{255,23,953}],add_attr = [{2,8800},{8,220}]};

get_seal_strong_info(4,45) ->
	#base_seal_strong{id = 4,lv = 45,cost = [{255,23,991}],add_attr = [{2,9000},{8,225}]};

get_seal_strong_info(4,46) ->
	#base_seal_strong{id = 4,lv = 46,cost = [{255,23,1030}],add_attr = [{2,9200},{8,230}]};

get_seal_strong_info(4,47) ->
	#base_seal_strong{id = 4,lv = 47,cost = [{255,23,1069}],add_attr = [{2,9400},{8,235}]};

get_seal_strong_info(4,48) ->
	#base_seal_strong{id = 4,lv = 48,cost = [{255,23,1109}],add_attr = [{2,9600},{8,240}]};

get_seal_strong_info(4,49) ->
	#base_seal_strong{id = 4,lv = 49,cost = [{255,23,1150}],add_attr = [{2,9800},{8,245}]};

get_seal_strong_info(4,50) ->
	#base_seal_strong{id = 4,lv = 50,cost = [{255,23,1192}],add_attr = [{2,10000},{8,250}]};

get_seal_strong_info(4,51) ->
	#base_seal_strong{id = 4,lv = 51,cost = [{255,23,1234}],add_attr = [{2,10200},{8,255}]};

get_seal_strong_info(4,52) ->
	#base_seal_strong{id = 4,lv = 52,cost = [{255,23,1277}],add_attr = [{2,10400},{8,260}]};

get_seal_strong_info(4,53) ->
	#base_seal_strong{id = 4,lv = 53,cost = [{255,23,1320}],add_attr = [{2,10600},{8,265}]};

get_seal_strong_info(4,54) ->
	#base_seal_strong{id = 4,lv = 54,cost = [{255,23,1364}],add_attr = [{2,10800},{8,270}]};

get_seal_strong_info(4,55) ->
	#base_seal_strong{id = 4,lv = 55,cost = [{255,23,1409}],add_attr = [{2,11000},{8,275}]};

get_seal_strong_info(4,56) ->
	#base_seal_strong{id = 4,lv = 56,cost = [{255,23,1454}],add_attr = [{2,11200},{8,280}]};

get_seal_strong_info(4,57) ->
	#base_seal_strong{id = 4,lv = 57,cost = [{255,23,1500}],add_attr = [{2,11400},{8,285}]};

get_seal_strong_info(4,58) ->
	#base_seal_strong{id = 4,lv = 58,cost = [{255,23,1547}],add_attr = [{2,11600},{8,290}]};

get_seal_strong_info(4,59) ->
	#base_seal_strong{id = 4,lv = 59,cost = [{255,23,1594}],add_attr = [{2,11800},{8,295}]};

get_seal_strong_info(4,60) ->
	#base_seal_strong{id = 4,lv = 60,cost = [{255,23,1642}],add_attr = [{2,12000},{8,300}]};

get_seal_strong_info(4,61) ->
	#base_seal_strong{id = 4,lv = 61,cost = [{255,23,1691}],add_attr = [{2,12200},{8,305}]};

get_seal_strong_info(4,62) ->
	#base_seal_strong{id = 4,lv = 62,cost = [{255,23,1740}],add_attr = [{2,12400},{8,310}]};

get_seal_strong_info(4,63) ->
	#base_seal_strong{id = 4,lv = 63,cost = [{255,23,1790}],add_attr = [{2,12600},{8,315}]};

get_seal_strong_info(4,64) ->
	#base_seal_strong{id = 4,lv = 64,cost = [{255,23,1840}],add_attr = [{2,12800},{8,320}]};

get_seal_strong_info(4,65) ->
	#base_seal_strong{id = 4,lv = 65,cost = [{255,23,1891}],add_attr = [{2,13000},{8,325}]};

get_seal_strong_info(4,66) ->
	#base_seal_strong{id = 4,lv = 66,cost = [{255,23,1943}],add_attr = [{2,13200},{8,330}]};

get_seal_strong_info(4,67) ->
	#base_seal_strong{id = 4,lv = 67,cost = [{255,23,1995}],add_attr = [{2,13400},{8,335}]};

get_seal_strong_info(4,68) ->
	#base_seal_strong{id = 4,lv = 68,cost = [{255,23,2048}],add_attr = [{2,13600},{8,340}]};

get_seal_strong_info(4,69) ->
	#base_seal_strong{id = 4,lv = 69,cost = [{255,23,2102}],add_attr = [{2,13800},{8,345}]};

get_seal_strong_info(4,70) ->
	#base_seal_strong{id = 4,lv = 70,cost = [{255,23,2156}],add_attr = [{2,14000},{8,350}]};

get_seal_strong_info(4,71) ->
	#base_seal_strong{id = 4,lv = 71,cost = [{255,23,2211}],add_attr = [{2,14200},{8,355}]};

get_seal_strong_info(4,72) ->
	#base_seal_strong{id = 4,lv = 72,cost = [{255,23,2266}],add_attr = [{2,14400},{8,360}]};

get_seal_strong_info(4,73) ->
	#base_seal_strong{id = 4,lv = 73,cost = [{255,23,2322}],add_attr = [{2,14600},{8,365}]};

get_seal_strong_info(4,74) ->
	#base_seal_strong{id = 4,lv = 74,cost = [{255,23,2379}],add_attr = [{2,14800},{8,370}]};

get_seal_strong_info(4,75) ->
	#base_seal_strong{id = 4,lv = 75,cost = [{255,23,2436}],add_attr = [{2,15000},{8,375}]};

get_seal_strong_info(4,76) ->
	#base_seal_strong{id = 4,lv = 76,cost = [{255,23,2494}],add_attr = [{2,15200},{8,380}]};

get_seal_strong_info(4,77) ->
	#base_seal_strong{id = 4,lv = 77,cost = [{255,23,2552}],add_attr = [{2,15400},{8,385}]};

get_seal_strong_info(4,78) ->
	#base_seal_strong{id = 4,lv = 78,cost = [{255,23,2612}],add_attr = [{2,15600},{8,390}]};

get_seal_strong_info(4,79) ->
	#base_seal_strong{id = 4,lv = 79,cost = [{255,23,2671}],add_attr = [{2,15800},{8,395}]};

get_seal_strong_info(4,80) ->
	#base_seal_strong{id = 4,lv = 80,cost = [{255,23,2731}],add_attr = [{2,16000},{8,400}]};

get_seal_strong_info(4,81) ->
	#base_seal_strong{id = 4,lv = 81,cost = [{255,23,2792}],add_attr = [{2,16200},{8,405}]};

get_seal_strong_info(4,82) ->
	#base_seal_strong{id = 4,lv = 82,cost = [{255,23,2854}],add_attr = [{2,16400},{8,410}]};

get_seal_strong_info(4,83) ->
	#base_seal_strong{id = 4,lv = 83,cost = [{255,23,2916}],add_attr = [{2,16600},{8,415}]};

get_seal_strong_info(4,84) ->
	#base_seal_strong{id = 4,lv = 84,cost = [{255,23,2978}],add_attr = [{2,16800},{8,420}]};

get_seal_strong_info(4,85) ->
	#base_seal_strong{id = 4,lv = 85,cost = [{255,23,3042}],add_attr = [{2,17000},{8,425}]};

get_seal_strong_info(4,86) ->
	#base_seal_strong{id = 4,lv = 86,cost = [{255,23,3105}],add_attr = [{2,17200},{8,430}]};

get_seal_strong_info(4,87) ->
	#base_seal_strong{id = 4,lv = 87,cost = [{255,23,3170}],add_attr = [{2,17400},{8,435}]};

get_seal_strong_info(4,88) ->
	#base_seal_strong{id = 4,lv = 88,cost = [{255,23,3235}],add_attr = [{2,17600},{8,440}]};

get_seal_strong_info(4,89) ->
	#base_seal_strong{id = 4,lv = 89,cost = [{255,23,3300}],add_attr = [{2,17800},{8,445}]};

get_seal_strong_info(4,90) ->
	#base_seal_strong{id = 4,lv = 90,cost = [{255,23,3366}],add_attr = [{2,18000},{8,450}]};

get_seal_strong_info(4,91) ->
	#base_seal_strong{id = 4,lv = 91,cost = [{255,23,3433}],add_attr = [{2,18200},{8,455}]};

get_seal_strong_info(4,92) ->
	#base_seal_strong{id = 4,lv = 92,cost = [{255,23,3501}],add_attr = [{2,18400},{8,460}]};

get_seal_strong_info(4,93) ->
	#base_seal_strong{id = 4,lv = 93,cost = [{255,23,3568}],add_attr = [{2,18600},{8,465}]};

get_seal_strong_info(4,94) ->
	#base_seal_strong{id = 4,lv = 94,cost = [{255,23,3637}],add_attr = [{2,18800},{8,470}]};

get_seal_strong_info(4,95) ->
	#base_seal_strong{id = 4,lv = 95,cost = [{255,23,3706}],add_attr = [{2,19000},{8,475}]};

get_seal_strong_info(4,96) ->
	#base_seal_strong{id = 4,lv = 96,cost = [{255,23,3776}],add_attr = [{2,19200},{8,480}]};

get_seal_strong_info(4,97) ->
	#base_seal_strong{id = 4,lv = 97,cost = [{255,23,3846}],add_attr = [{2,19400},{8,485}]};

get_seal_strong_info(4,98) ->
	#base_seal_strong{id = 4,lv = 98,cost = [{255,23,3917}],add_attr = [{2,19600},{8,490}]};

get_seal_strong_info(4,99) ->
	#base_seal_strong{id = 4,lv = 99,cost = [{255,23,3988}],add_attr = [{2,19800},{8,495}]};

get_seal_strong_info(4,100) ->
	#base_seal_strong{id = 4,lv = 100,cost = [{255,23,4060}],add_attr = [{2,20000},{8,500}]};

get_seal_strong_info(5,0) ->
	#base_seal_strong{id = 5,lv = 0,cost = [],add_attr = [{4,0},{8,0}]};

get_seal_strong_info(5,1) ->
	#base_seal_strong{id = 5,lv = 1,cost = [{255,23,10}],add_attr = [{4,10},{8,5}]};

get_seal_strong_info(5,2) ->
	#base_seal_strong{id = 5,lv = 2,cost = [{255,23,14}],add_attr = [{4,20},{8,10}]};

get_seal_strong_info(5,3) ->
	#base_seal_strong{id = 5,lv = 3,cost = [{255,23,19}],add_attr = [{4,30},{8,15}]};

get_seal_strong_info(5,4) ->
	#base_seal_strong{id = 5,lv = 4,cost = [{255,23,25}],add_attr = [{4,40},{8,20}]};

get_seal_strong_info(5,5) ->
	#base_seal_strong{id = 5,lv = 5,cost = [{255,23,32}],add_attr = [{4,50},{8,25}]};

get_seal_strong_info(5,6) ->
	#base_seal_strong{id = 5,lv = 6,cost = [{255,23,40}],add_attr = [{4,60},{8,30}]};

get_seal_strong_info(5,7) ->
	#base_seal_strong{id = 5,lv = 7,cost = [{255,23,49}],add_attr = [{4,70},{8,35}]};

get_seal_strong_info(5,8) ->
	#base_seal_strong{id = 5,lv = 8,cost = [{255,23,59}],add_attr = [{4,80},{8,40}]};

get_seal_strong_info(5,9) ->
	#base_seal_strong{id = 5,lv = 9,cost = [{255,23,70}],add_attr = [{4,90},{8,45}]};

get_seal_strong_info(5,10) ->
	#base_seal_strong{id = 5,lv = 10,cost = [{255,23,82}],add_attr = [{4,100},{8,50}]};

get_seal_strong_info(5,11) ->
	#base_seal_strong{id = 5,lv = 11,cost = [{255,23,95}],add_attr = [{4,110},{8,55}]};

get_seal_strong_info(5,12) ->
	#base_seal_strong{id = 5,lv = 12,cost = [{255,23,108}],add_attr = [{4,120},{8,60}]};

get_seal_strong_info(5,13) ->
	#base_seal_strong{id = 5,lv = 13,cost = [{255,23,123}],add_attr = [{4,130},{8,65}]};

get_seal_strong_info(5,14) ->
	#base_seal_strong{id = 5,lv = 14,cost = [{255,23,138}],add_attr = [{4,140},{8,70}]};

get_seal_strong_info(5,15) ->
	#base_seal_strong{id = 5,lv = 15,cost = [{255,23,154}],add_attr = [{4,150},{8,75}]};

get_seal_strong_info(5,16) ->
	#base_seal_strong{id = 5,lv = 16,cost = [{255,23,171}],add_attr = [{4,160},{8,80}]};

get_seal_strong_info(5,17) ->
	#base_seal_strong{id = 5,lv = 17,cost = [{255,23,189}],add_attr = [{4,170},{8,85}]};

get_seal_strong_info(5,18) ->
	#base_seal_strong{id = 5,lv = 18,cost = [{255,23,207}],add_attr = [{4,180},{8,90}]};

get_seal_strong_info(5,19) ->
	#base_seal_strong{id = 5,lv = 19,cost = [{255,23,227}],add_attr = [{4,190},{8,95}]};

get_seal_strong_info(5,20) ->
	#base_seal_strong{id = 5,lv = 20,cost = [{255,23,247}],add_attr = [{4,200},{8,100}]};

get_seal_strong_info(5,21) ->
	#base_seal_strong{id = 5,lv = 21,cost = [{255,23,268}],add_attr = [{4,210},{8,105}]};

get_seal_strong_info(5,22) ->
	#base_seal_strong{id = 5,lv = 22,cost = [{255,23,290}],add_attr = [{4,220},{8,110}]};

get_seal_strong_info(5,23) ->
	#base_seal_strong{id = 5,lv = 23,cost = [{255,23,312}],add_attr = [{4,230},{8,115}]};

get_seal_strong_info(5,24) ->
	#base_seal_strong{id = 5,lv = 24,cost = [{255,23,335}],add_attr = [{4,240},{8,120}]};

get_seal_strong_info(5,25) ->
	#base_seal_strong{id = 5,lv = 25,cost = [{255,23,359}],add_attr = [{4,250},{8,125}]};

get_seal_strong_info(5,26) ->
	#base_seal_strong{id = 5,lv = 26,cost = [{255,23,384}],add_attr = [{4,260},{8,130}]};

get_seal_strong_info(5,27) ->
	#base_seal_strong{id = 5,lv = 27,cost = [{255,23,410}],add_attr = [{4,270},{8,135}]};

get_seal_strong_info(5,28) ->
	#base_seal_strong{id = 5,lv = 28,cost = [{255,23,436}],add_attr = [{4,280},{8,140}]};

get_seal_strong_info(5,29) ->
	#base_seal_strong{id = 5,lv = 29,cost = [{255,23,463}],add_attr = [{4,290},{8,145}]};

get_seal_strong_info(5,30) ->
	#base_seal_strong{id = 5,lv = 30,cost = [{255,23,491}],add_attr = [{4,300},{8,150}]};

get_seal_strong_info(5,31) ->
	#base_seal_strong{id = 5,lv = 31,cost = [{255,23,519}],add_attr = [{4,310},{8,155}]};

get_seal_strong_info(5,32) ->
	#base_seal_strong{id = 5,lv = 32,cost = [{255,23,548}],add_attr = [{4,320},{8,160}]};

get_seal_strong_info(5,33) ->
	#base_seal_strong{id = 5,lv = 33,cost = [{255,23,578}],add_attr = [{4,330},{8,165}]};

get_seal_strong_info(5,34) ->
	#base_seal_strong{id = 5,lv = 34,cost = [{255,23,609}],add_attr = [{4,340},{8,170}]};

get_seal_strong_info(5,35) ->
	#base_seal_strong{id = 5,lv = 35,cost = [{255,23,640}],add_attr = [{4,350},{8,175}]};

get_seal_strong_info(5,36) ->
	#base_seal_strong{id = 5,lv = 36,cost = [{255,23,672}],add_attr = [{4,360},{8,180}]};

get_seal_strong_info(5,37) ->
	#base_seal_strong{id = 5,lv = 37,cost = [{255,23,705}],add_attr = [{4,370},{8,185}]};

get_seal_strong_info(5,38) ->
	#base_seal_strong{id = 5,lv = 38,cost = [{255,23,738}],add_attr = [{4,380},{8,190}]};

get_seal_strong_info(5,39) ->
	#base_seal_strong{id = 5,lv = 39,cost = [{255,23,772}],add_attr = [{4,390},{8,195}]};

get_seal_strong_info(5,40) ->
	#base_seal_strong{id = 5,lv = 40,cost = [{255,23,807}],add_attr = [{4,400},{8,200}]};

get_seal_strong_info(5,41) ->
	#base_seal_strong{id = 5,lv = 41,cost = [{255,23,842}],add_attr = [{4,410},{8,205}]};

get_seal_strong_info(5,42) ->
	#base_seal_strong{id = 5,lv = 42,cost = [{255,23,878}],add_attr = [{4,420},{8,210}]};

get_seal_strong_info(5,43) ->
	#base_seal_strong{id = 5,lv = 43,cost = [{255,23,915}],add_attr = [{4,430},{8,215}]};

get_seal_strong_info(5,44) ->
	#base_seal_strong{id = 5,lv = 44,cost = [{255,23,953}],add_attr = [{4,440},{8,220}]};

get_seal_strong_info(5,45) ->
	#base_seal_strong{id = 5,lv = 45,cost = [{255,23,991}],add_attr = [{4,450},{8,225}]};

get_seal_strong_info(5,46) ->
	#base_seal_strong{id = 5,lv = 46,cost = [{255,23,1030}],add_attr = [{4,460},{8,230}]};

get_seal_strong_info(5,47) ->
	#base_seal_strong{id = 5,lv = 47,cost = [{255,23,1069}],add_attr = [{4,470},{8,235}]};

get_seal_strong_info(5,48) ->
	#base_seal_strong{id = 5,lv = 48,cost = [{255,23,1109}],add_attr = [{4,480},{8,240}]};

get_seal_strong_info(5,49) ->
	#base_seal_strong{id = 5,lv = 49,cost = [{255,23,1150}],add_attr = [{4,490},{8,245}]};

get_seal_strong_info(5,50) ->
	#base_seal_strong{id = 5,lv = 50,cost = [{255,23,1192}],add_attr = [{4,500},{8,250}]};

get_seal_strong_info(5,51) ->
	#base_seal_strong{id = 5,lv = 51,cost = [{255,23,1234}],add_attr = [{4,510},{8,255}]};

get_seal_strong_info(5,52) ->
	#base_seal_strong{id = 5,lv = 52,cost = [{255,23,1277}],add_attr = [{4,520},{8,260}]};

get_seal_strong_info(5,53) ->
	#base_seal_strong{id = 5,lv = 53,cost = [{255,23,1320}],add_attr = [{4,530},{8,265}]};

get_seal_strong_info(5,54) ->
	#base_seal_strong{id = 5,lv = 54,cost = [{255,23,1364}],add_attr = [{4,540},{8,270}]};

get_seal_strong_info(5,55) ->
	#base_seal_strong{id = 5,lv = 55,cost = [{255,23,1409}],add_attr = [{4,550},{8,275}]};

get_seal_strong_info(5,56) ->
	#base_seal_strong{id = 5,lv = 56,cost = [{255,23,1454}],add_attr = [{4,560},{8,280}]};

get_seal_strong_info(5,57) ->
	#base_seal_strong{id = 5,lv = 57,cost = [{255,23,1500}],add_attr = [{4,570},{8,285}]};

get_seal_strong_info(5,58) ->
	#base_seal_strong{id = 5,lv = 58,cost = [{255,23,1547}],add_attr = [{4,580},{8,290}]};

get_seal_strong_info(5,59) ->
	#base_seal_strong{id = 5,lv = 59,cost = [{255,23,1594}],add_attr = [{4,590},{8,295}]};

get_seal_strong_info(5,60) ->
	#base_seal_strong{id = 5,lv = 60,cost = [{255,23,1642}],add_attr = [{4,600},{8,300}]};

get_seal_strong_info(5,61) ->
	#base_seal_strong{id = 5,lv = 61,cost = [{255,23,1691}],add_attr = [{4,610},{8,305}]};

get_seal_strong_info(5,62) ->
	#base_seal_strong{id = 5,lv = 62,cost = [{255,23,1740}],add_attr = [{4,620},{8,310}]};

get_seal_strong_info(5,63) ->
	#base_seal_strong{id = 5,lv = 63,cost = [{255,23,1790}],add_attr = [{4,630},{8,315}]};

get_seal_strong_info(5,64) ->
	#base_seal_strong{id = 5,lv = 64,cost = [{255,23,1840}],add_attr = [{4,640},{8,320}]};

get_seal_strong_info(5,65) ->
	#base_seal_strong{id = 5,lv = 65,cost = [{255,23,1891}],add_attr = [{4,650},{8,325}]};

get_seal_strong_info(5,66) ->
	#base_seal_strong{id = 5,lv = 66,cost = [{255,23,1943}],add_attr = [{4,660},{8,330}]};

get_seal_strong_info(5,67) ->
	#base_seal_strong{id = 5,lv = 67,cost = [{255,23,1995}],add_attr = [{4,670},{8,335}]};

get_seal_strong_info(5,68) ->
	#base_seal_strong{id = 5,lv = 68,cost = [{255,23,2048}],add_attr = [{4,680},{8,340}]};

get_seal_strong_info(5,69) ->
	#base_seal_strong{id = 5,lv = 69,cost = [{255,23,2102}],add_attr = [{4,690},{8,345}]};

get_seal_strong_info(5,70) ->
	#base_seal_strong{id = 5,lv = 70,cost = [{255,23,2156}],add_attr = [{4,700},{8,350}]};

get_seal_strong_info(5,71) ->
	#base_seal_strong{id = 5,lv = 71,cost = [{255,23,2211}],add_attr = [{4,710},{8,355}]};

get_seal_strong_info(5,72) ->
	#base_seal_strong{id = 5,lv = 72,cost = [{255,23,2266}],add_attr = [{4,720},{8,360}]};

get_seal_strong_info(5,73) ->
	#base_seal_strong{id = 5,lv = 73,cost = [{255,23,2322}],add_attr = [{4,730},{8,365}]};

get_seal_strong_info(5,74) ->
	#base_seal_strong{id = 5,lv = 74,cost = [{255,23,2379}],add_attr = [{4,740},{8,370}]};

get_seal_strong_info(5,75) ->
	#base_seal_strong{id = 5,lv = 75,cost = [{255,23,2436}],add_attr = [{4,750},{8,375}]};

get_seal_strong_info(5,76) ->
	#base_seal_strong{id = 5,lv = 76,cost = [{255,23,2494}],add_attr = [{4,760},{8,380}]};

get_seal_strong_info(5,77) ->
	#base_seal_strong{id = 5,lv = 77,cost = [{255,23,2552}],add_attr = [{4,770},{8,385}]};

get_seal_strong_info(5,78) ->
	#base_seal_strong{id = 5,lv = 78,cost = [{255,23,2612}],add_attr = [{4,780},{8,390}]};

get_seal_strong_info(5,79) ->
	#base_seal_strong{id = 5,lv = 79,cost = [{255,23,2671}],add_attr = [{4,790},{8,395}]};

get_seal_strong_info(5,80) ->
	#base_seal_strong{id = 5,lv = 80,cost = [{255,23,2731}],add_attr = [{4,800},{8,400}]};

get_seal_strong_info(5,81) ->
	#base_seal_strong{id = 5,lv = 81,cost = [{255,23,2792}],add_attr = [{4,810},{8,405}]};

get_seal_strong_info(5,82) ->
	#base_seal_strong{id = 5,lv = 82,cost = [{255,23,2854}],add_attr = [{4,820},{8,410}]};

get_seal_strong_info(5,83) ->
	#base_seal_strong{id = 5,lv = 83,cost = [{255,23,2916}],add_attr = [{4,830},{8,415}]};

get_seal_strong_info(5,84) ->
	#base_seal_strong{id = 5,lv = 84,cost = [{255,23,2978}],add_attr = [{4,840},{8,420}]};

get_seal_strong_info(5,85) ->
	#base_seal_strong{id = 5,lv = 85,cost = [{255,23,3042}],add_attr = [{4,850},{8,425}]};

get_seal_strong_info(5,86) ->
	#base_seal_strong{id = 5,lv = 86,cost = [{255,23,3105}],add_attr = [{4,860},{8,430}]};

get_seal_strong_info(5,87) ->
	#base_seal_strong{id = 5,lv = 87,cost = [{255,23,3170}],add_attr = [{4,870},{8,435}]};

get_seal_strong_info(5,88) ->
	#base_seal_strong{id = 5,lv = 88,cost = [{255,23,3235}],add_attr = [{4,880},{8,440}]};

get_seal_strong_info(5,89) ->
	#base_seal_strong{id = 5,lv = 89,cost = [{255,23,3300}],add_attr = [{4,890},{8,445}]};

get_seal_strong_info(5,90) ->
	#base_seal_strong{id = 5,lv = 90,cost = [{255,23,3366}],add_attr = [{4,900},{8,450}]};

get_seal_strong_info(5,91) ->
	#base_seal_strong{id = 5,lv = 91,cost = [{255,23,3433}],add_attr = [{4,910},{8,455}]};

get_seal_strong_info(5,92) ->
	#base_seal_strong{id = 5,lv = 92,cost = [{255,23,3501}],add_attr = [{4,920},{8,460}]};

get_seal_strong_info(5,93) ->
	#base_seal_strong{id = 5,lv = 93,cost = [{255,23,3568}],add_attr = [{4,930},{8,465}]};

get_seal_strong_info(5,94) ->
	#base_seal_strong{id = 5,lv = 94,cost = [{255,23,3637}],add_attr = [{4,940},{8,470}]};

get_seal_strong_info(5,95) ->
	#base_seal_strong{id = 5,lv = 95,cost = [{255,23,3706}],add_attr = [{4,950},{8,475}]};

get_seal_strong_info(5,96) ->
	#base_seal_strong{id = 5,lv = 96,cost = [{255,23,3776}],add_attr = [{4,960},{8,480}]};

get_seal_strong_info(5,97) ->
	#base_seal_strong{id = 5,lv = 97,cost = [{255,23,3846}],add_attr = [{4,970},{8,485}]};

get_seal_strong_info(5,98) ->
	#base_seal_strong{id = 5,lv = 98,cost = [{255,23,3917}],add_attr = [{4,980},{8,490}]};

get_seal_strong_info(5,99) ->
	#base_seal_strong{id = 5,lv = 99,cost = [{255,23,3988}],add_attr = [{4,990},{8,495}]};

get_seal_strong_info(5,100) ->
	#base_seal_strong{id = 5,lv = 100,cost = [{255,23,4060}],add_attr = [{4,1000},{8,500}]};

get_seal_strong_info(6,0) ->
	#base_seal_strong{id = 6,lv = 0,cost = [],add_attr = [{3,0},{7,0}]};

get_seal_strong_info(6,1) ->
	#base_seal_strong{id = 6,lv = 1,cost = [{255,23,10}],add_attr = [{3,10},{7,5}]};

get_seal_strong_info(6,2) ->
	#base_seal_strong{id = 6,lv = 2,cost = [{255,23,14}],add_attr = [{3,20},{7,10}]};

get_seal_strong_info(6,3) ->
	#base_seal_strong{id = 6,lv = 3,cost = [{255,23,19}],add_attr = [{3,30},{7,15}]};

get_seal_strong_info(6,4) ->
	#base_seal_strong{id = 6,lv = 4,cost = [{255,23,25}],add_attr = [{3,40},{7,20}]};

get_seal_strong_info(6,5) ->
	#base_seal_strong{id = 6,lv = 5,cost = [{255,23,32}],add_attr = [{3,50},{7,25}]};

get_seal_strong_info(6,6) ->
	#base_seal_strong{id = 6,lv = 6,cost = [{255,23,40}],add_attr = [{3,60},{7,30}]};

get_seal_strong_info(6,7) ->
	#base_seal_strong{id = 6,lv = 7,cost = [{255,23,49}],add_attr = [{3,70},{7,35}]};

get_seal_strong_info(6,8) ->
	#base_seal_strong{id = 6,lv = 8,cost = [{255,23,59}],add_attr = [{3,80},{7,40}]};

get_seal_strong_info(6,9) ->
	#base_seal_strong{id = 6,lv = 9,cost = [{255,23,70}],add_attr = [{3,90},{7,45}]};

get_seal_strong_info(6,10) ->
	#base_seal_strong{id = 6,lv = 10,cost = [{255,23,82}],add_attr = [{3,100},{7,50}]};

get_seal_strong_info(6,11) ->
	#base_seal_strong{id = 6,lv = 11,cost = [{255,23,95}],add_attr = [{3,110},{7,55}]};

get_seal_strong_info(6,12) ->
	#base_seal_strong{id = 6,lv = 12,cost = [{255,23,108}],add_attr = [{3,120},{7,60}]};

get_seal_strong_info(6,13) ->
	#base_seal_strong{id = 6,lv = 13,cost = [{255,23,123}],add_attr = [{3,130},{7,65}]};

get_seal_strong_info(6,14) ->
	#base_seal_strong{id = 6,lv = 14,cost = [{255,23,138}],add_attr = [{3,140},{7,70}]};

get_seal_strong_info(6,15) ->
	#base_seal_strong{id = 6,lv = 15,cost = [{255,23,154}],add_attr = [{3,150},{7,75}]};

get_seal_strong_info(6,16) ->
	#base_seal_strong{id = 6,lv = 16,cost = [{255,23,171}],add_attr = [{3,160},{7,80}]};

get_seal_strong_info(6,17) ->
	#base_seal_strong{id = 6,lv = 17,cost = [{255,23,189}],add_attr = [{3,170},{7,85}]};

get_seal_strong_info(6,18) ->
	#base_seal_strong{id = 6,lv = 18,cost = [{255,23,207}],add_attr = [{3,180},{7,90}]};

get_seal_strong_info(6,19) ->
	#base_seal_strong{id = 6,lv = 19,cost = [{255,23,227}],add_attr = [{3,190},{7,95}]};

get_seal_strong_info(6,20) ->
	#base_seal_strong{id = 6,lv = 20,cost = [{255,23,247}],add_attr = [{3,200},{7,100}]};

get_seal_strong_info(6,21) ->
	#base_seal_strong{id = 6,lv = 21,cost = [{255,23,268}],add_attr = [{3,210},{7,105}]};

get_seal_strong_info(6,22) ->
	#base_seal_strong{id = 6,lv = 22,cost = [{255,23,290}],add_attr = [{3,220},{7,110}]};

get_seal_strong_info(6,23) ->
	#base_seal_strong{id = 6,lv = 23,cost = [{255,23,312}],add_attr = [{3,230},{7,115}]};

get_seal_strong_info(6,24) ->
	#base_seal_strong{id = 6,lv = 24,cost = [{255,23,335}],add_attr = [{3,240},{7,120}]};

get_seal_strong_info(6,25) ->
	#base_seal_strong{id = 6,lv = 25,cost = [{255,23,359}],add_attr = [{3,250},{7,125}]};

get_seal_strong_info(6,26) ->
	#base_seal_strong{id = 6,lv = 26,cost = [{255,23,384}],add_attr = [{3,260},{7,130}]};

get_seal_strong_info(6,27) ->
	#base_seal_strong{id = 6,lv = 27,cost = [{255,23,410}],add_attr = [{3,270},{7,135}]};

get_seal_strong_info(6,28) ->
	#base_seal_strong{id = 6,lv = 28,cost = [{255,23,436}],add_attr = [{3,280},{7,140}]};

get_seal_strong_info(6,29) ->
	#base_seal_strong{id = 6,lv = 29,cost = [{255,23,463}],add_attr = [{3,290},{7,145}]};

get_seal_strong_info(6,30) ->
	#base_seal_strong{id = 6,lv = 30,cost = [{255,23,491}],add_attr = [{3,300},{7,150}]};

get_seal_strong_info(6,31) ->
	#base_seal_strong{id = 6,lv = 31,cost = [{255,23,519}],add_attr = [{3,310},{7,155}]};

get_seal_strong_info(6,32) ->
	#base_seal_strong{id = 6,lv = 32,cost = [{255,23,548}],add_attr = [{3,320},{7,160}]};

get_seal_strong_info(6,33) ->
	#base_seal_strong{id = 6,lv = 33,cost = [{255,23,578}],add_attr = [{3,330},{7,165}]};

get_seal_strong_info(6,34) ->
	#base_seal_strong{id = 6,lv = 34,cost = [{255,23,609}],add_attr = [{3,340},{7,170}]};

get_seal_strong_info(6,35) ->
	#base_seal_strong{id = 6,lv = 35,cost = [{255,23,640}],add_attr = [{3,350},{7,175}]};

get_seal_strong_info(6,36) ->
	#base_seal_strong{id = 6,lv = 36,cost = [{255,23,672}],add_attr = [{3,360},{7,180}]};

get_seal_strong_info(6,37) ->
	#base_seal_strong{id = 6,lv = 37,cost = [{255,23,705}],add_attr = [{3,370},{7,185}]};

get_seal_strong_info(6,38) ->
	#base_seal_strong{id = 6,lv = 38,cost = [{255,23,738}],add_attr = [{3,380},{7,190}]};

get_seal_strong_info(6,39) ->
	#base_seal_strong{id = 6,lv = 39,cost = [{255,23,772}],add_attr = [{3,390},{7,195}]};

get_seal_strong_info(6,40) ->
	#base_seal_strong{id = 6,lv = 40,cost = [{255,23,807}],add_attr = [{3,400},{7,200}]};

get_seal_strong_info(6,41) ->
	#base_seal_strong{id = 6,lv = 41,cost = [{255,23,842}],add_attr = [{3,410},{7,205}]};

get_seal_strong_info(6,42) ->
	#base_seal_strong{id = 6,lv = 42,cost = [{255,23,878}],add_attr = [{3,420},{7,210}]};

get_seal_strong_info(6,43) ->
	#base_seal_strong{id = 6,lv = 43,cost = [{255,23,915}],add_attr = [{3,430},{7,215}]};

get_seal_strong_info(6,44) ->
	#base_seal_strong{id = 6,lv = 44,cost = [{255,23,953}],add_attr = [{3,440},{7,220}]};

get_seal_strong_info(6,45) ->
	#base_seal_strong{id = 6,lv = 45,cost = [{255,23,991}],add_attr = [{3,450},{7,225}]};

get_seal_strong_info(6,46) ->
	#base_seal_strong{id = 6,lv = 46,cost = [{255,23,1030}],add_attr = [{3,460},{7,230}]};

get_seal_strong_info(6,47) ->
	#base_seal_strong{id = 6,lv = 47,cost = [{255,23,1069}],add_attr = [{3,470},{7,235}]};

get_seal_strong_info(6,48) ->
	#base_seal_strong{id = 6,lv = 48,cost = [{255,23,1109}],add_attr = [{3,480},{7,240}]};

get_seal_strong_info(6,49) ->
	#base_seal_strong{id = 6,lv = 49,cost = [{255,23,1150}],add_attr = [{3,490},{7,245}]};

get_seal_strong_info(6,50) ->
	#base_seal_strong{id = 6,lv = 50,cost = [{255,23,1192}],add_attr = [{3,500},{7,250}]};

get_seal_strong_info(6,51) ->
	#base_seal_strong{id = 6,lv = 51,cost = [{255,23,1234}],add_attr = [{3,510},{7,255}]};

get_seal_strong_info(6,52) ->
	#base_seal_strong{id = 6,lv = 52,cost = [{255,23,1277}],add_attr = [{3,520},{7,260}]};

get_seal_strong_info(6,53) ->
	#base_seal_strong{id = 6,lv = 53,cost = [{255,23,1320}],add_attr = [{3,530},{7,265}]};

get_seal_strong_info(6,54) ->
	#base_seal_strong{id = 6,lv = 54,cost = [{255,23,1364}],add_attr = [{3,540},{7,270}]};

get_seal_strong_info(6,55) ->
	#base_seal_strong{id = 6,lv = 55,cost = [{255,23,1409}],add_attr = [{3,550},{7,275}]};

get_seal_strong_info(6,56) ->
	#base_seal_strong{id = 6,lv = 56,cost = [{255,23,1454}],add_attr = [{3,560},{7,280}]};

get_seal_strong_info(6,57) ->
	#base_seal_strong{id = 6,lv = 57,cost = [{255,23,1500}],add_attr = [{3,570},{7,285}]};

get_seal_strong_info(6,58) ->
	#base_seal_strong{id = 6,lv = 58,cost = [{255,23,1547}],add_attr = [{3,580},{7,290}]};

get_seal_strong_info(6,59) ->
	#base_seal_strong{id = 6,lv = 59,cost = [{255,23,1594}],add_attr = [{3,590},{7,295}]};

get_seal_strong_info(6,60) ->
	#base_seal_strong{id = 6,lv = 60,cost = [{255,23,1642}],add_attr = [{3,600},{7,300}]};

get_seal_strong_info(6,61) ->
	#base_seal_strong{id = 6,lv = 61,cost = [{255,23,1691}],add_attr = [{3,610},{7,305}]};

get_seal_strong_info(6,62) ->
	#base_seal_strong{id = 6,lv = 62,cost = [{255,23,1740}],add_attr = [{3,620},{7,310}]};

get_seal_strong_info(6,63) ->
	#base_seal_strong{id = 6,lv = 63,cost = [{255,23,1790}],add_attr = [{3,630},{7,315}]};

get_seal_strong_info(6,64) ->
	#base_seal_strong{id = 6,lv = 64,cost = [{255,23,1840}],add_attr = [{3,640},{7,320}]};

get_seal_strong_info(6,65) ->
	#base_seal_strong{id = 6,lv = 65,cost = [{255,23,1891}],add_attr = [{3,650},{7,325}]};

get_seal_strong_info(6,66) ->
	#base_seal_strong{id = 6,lv = 66,cost = [{255,23,1943}],add_attr = [{3,660},{7,330}]};

get_seal_strong_info(6,67) ->
	#base_seal_strong{id = 6,lv = 67,cost = [{255,23,1995}],add_attr = [{3,670},{7,335}]};

get_seal_strong_info(6,68) ->
	#base_seal_strong{id = 6,lv = 68,cost = [{255,23,2048}],add_attr = [{3,680},{7,340}]};

get_seal_strong_info(6,69) ->
	#base_seal_strong{id = 6,lv = 69,cost = [{255,23,2102}],add_attr = [{3,690},{7,345}]};

get_seal_strong_info(6,70) ->
	#base_seal_strong{id = 6,lv = 70,cost = [{255,23,2156}],add_attr = [{3,700},{7,350}]};

get_seal_strong_info(6,71) ->
	#base_seal_strong{id = 6,lv = 71,cost = [{255,23,2211}],add_attr = [{3,710},{7,355}]};

get_seal_strong_info(6,72) ->
	#base_seal_strong{id = 6,lv = 72,cost = [{255,23,2266}],add_attr = [{3,720},{7,360}]};

get_seal_strong_info(6,73) ->
	#base_seal_strong{id = 6,lv = 73,cost = [{255,23,2322}],add_attr = [{3,730},{7,365}]};

get_seal_strong_info(6,74) ->
	#base_seal_strong{id = 6,lv = 74,cost = [{255,23,2379}],add_attr = [{3,740},{7,370}]};

get_seal_strong_info(6,75) ->
	#base_seal_strong{id = 6,lv = 75,cost = [{255,23,2436}],add_attr = [{3,750},{7,375}]};

get_seal_strong_info(6,76) ->
	#base_seal_strong{id = 6,lv = 76,cost = [{255,23,2494}],add_attr = [{3,760},{7,380}]};

get_seal_strong_info(6,77) ->
	#base_seal_strong{id = 6,lv = 77,cost = [{255,23,2552}],add_attr = [{3,770},{7,385}]};

get_seal_strong_info(6,78) ->
	#base_seal_strong{id = 6,lv = 78,cost = [{255,23,2612}],add_attr = [{3,780},{7,390}]};

get_seal_strong_info(6,79) ->
	#base_seal_strong{id = 6,lv = 79,cost = [{255,23,2671}],add_attr = [{3,790},{7,395}]};

get_seal_strong_info(6,80) ->
	#base_seal_strong{id = 6,lv = 80,cost = [{255,23,2731}],add_attr = [{3,800},{7,400}]};

get_seal_strong_info(6,81) ->
	#base_seal_strong{id = 6,lv = 81,cost = [{255,23,2792}],add_attr = [{3,810},{7,405}]};

get_seal_strong_info(6,82) ->
	#base_seal_strong{id = 6,lv = 82,cost = [{255,23,2854}],add_attr = [{3,820},{7,410}]};

get_seal_strong_info(6,83) ->
	#base_seal_strong{id = 6,lv = 83,cost = [{255,23,2916}],add_attr = [{3,830},{7,415}]};

get_seal_strong_info(6,84) ->
	#base_seal_strong{id = 6,lv = 84,cost = [{255,23,2978}],add_attr = [{3,840},{7,420}]};

get_seal_strong_info(6,85) ->
	#base_seal_strong{id = 6,lv = 85,cost = [{255,23,3042}],add_attr = [{3,850},{7,425}]};

get_seal_strong_info(6,86) ->
	#base_seal_strong{id = 6,lv = 86,cost = [{255,23,3105}],add_attr = [{3,860},{7,430}]};

get_seal_strong_info(6,87) ->
	#base_seal_strong{id = 6,lv = 87,cost = [{255,23,3170}],add_attr = [{3,870},{7,435}]};

get_seal_strong_info(6,88) ->
	#base_seal_strong{id = 6,lv = 88,cost = [{255,23,3235}],add_attr = [{3,880},{7,440}]};

get_seal_strong_info(6,89) ->
	#base_seal_strong{id = 6,lv = 89,cost = [{255,23,3300}],add_attr = [{3,890},{7,445}]};

get_seal_strong_info(6,90) ->
	#base_seal_strong{id = 6,lv = 90,cost = [{255,23,3366}],add_attr = [{3,900},{7,450}]};

get_seal_strong_info(6,91) ->
	#base_seal_strong{id = 6,lv = 91,cost = [{255,23,3433}],add_attr = [{3,910},{7,455}]};

get_seal_strong_info(6,92) ->
	#base_seal_strong{id = 6,lv = 92,cost = [{255,23,3501}],add_attr = [{3,920},{7,460}]};

get_seal_strong_info(6,93) ->
	#base_seal_strong{id = 6,lv = 93,cost = [{255,23,3568}],add_attr = [{3,930},{7,465}]};

get_seal_strong_info(6,94) ->
	#base_seal_strong{id = 6,lv = 94,cost = [{255,23,3637}],add_attr = [{3,940},{7,470}]};

get_seal_strong_info(6,95) ->
	#base_seal_strong{id = 6,lv = 95,cost = [{255,23,3706}],add_attr = [{3,950},{7,475}]};

get_seal_strong_info(6,96) ->
	#base_seal_strong{id = 6,lv = 96,cost = [{255,23,3776}],add_attr = [{3,960},{7,480}]};

get_seal_strong_info(6,97) ->
	#base_seal_strong{id = 6,lv = 97,cost = [{255,23,3846}],add_attr = [{3,970},{7,485}]};

get_seal_strong_info(6,98) ->
	#base_seal_strong{id = 6,lv = 98,cost = [{255,23,3917}],add_attr = [{3,980},{7,490}]};

get_seal_strong_info(6,99) ->
	#base_seal_strong{id = 6,lv = 99,cost = [{255,23,3988}],add_attr = [{3,990},{7,495}]};

get_seal_strong_info(6,100) ->
	#base_seal_strong{id = 6,lv = 100,cost = [{255,23,4060}],add_attr = [{3,1000},{7,500}]};

get_seal_strong_info(7,0) ->
	#base_seal_strong{id = 7,lv = 0,cost = [],add_attr = [{3,0},{5,0}]};

get_seal_strong_info(7,1) ->
	#base_seal_strong{id = 7,lv = 1,cost = [{255,23,10}],add_attr = [{3,10},{5,5}]};

get_seal_strong_info(7,2) ->
	#base_seal_strong{id = 7,lv = 2,cost = [{255,23,14}],add_attr = [{3,20},{5,10}]};

get_seal_strong_info(7,3) ->
	#base_seal_strong{id = 7,lv = 3,cost = [{255,23,19}],add_attr = [{3,30},{5,15}]};

get_seal_strong_info(7,4) ->
	#base_seal_strong{id = 7,lv = 4,cost = [{255,23,25}],add_attr = [{3,40},{5,20}]};

get_seal_strong_info(7,5) ->
	#base_seal_strong{id = 7,lv = 5,cost = [{255,23,32}],add_attr = [{3,50},{5,25}]};

get_seal_strong_info(7,6) ->
	#base_seal_strong{id = 7,lv = 6,cost = [{255,23,40}],add_attr = [{3,60},{5,30}]};

get_seal_strong_info(7,7) ->
	#base_seal_strong{id = 7,lv = 7,cost = [{255,23,49}],add_attr = [{3,70},{5,35}]};

get_seal_strong_info(7,8) ->
	#base_seal_strong{id = 7,lv = 8,cost = [{255,23,59}],add_attr = [{3,80},{5,40}]};

get_seal_strong_info(7,9) ->
	#base_seal_strong{id = 7,lv = 9,cost = [{255,23,70}],add_attr = [{3,90},{5,45}]};

get_seal_strong_info(7,10) ->
	#base_seal_strong{id = 7,lv = 10,cost = [{255,23,82}],add_attr = [{3,100},{5,50}]};

get_seal_strong_info(7,11) ->
	#base_seal_strong{id = 7,lv = 11,cost = [{255,23,95}],add_attr = [{3,110},{5,55}]};

get_seal_strong_info(7,12) ->
	#base_seal_strong{id = 7,lv = 12,cost = [{255,23,108}],add_attr = [{3,120},{5,60}]};

get_seal_strong_info(7,13) ->
	#base_seal_strong{id = 7,lv = 13,cost = [{255,23,123}],add_attr = [{3,130},{5,65}]};

get_seal_strong_info(7,14) ->
	#base_seal_strong{id = 7,lv = 14,cost = [{255,23,138}],add_attr = [{3,140},{5,70}]};

get_seal_strong_info(7,15) ->
	#base_seal_strong{id = 7,lv = 15,cost = [{255,23,154}],add_attr = [{3,150},{5,75}]};

get_seal_strong_info(7,16) ->
	#base_seal_strong{id = 7,lv = 16,cost = [{255,23,171}],add_attr = [{3,160},{5,80}]};

get_seal_strong_info(7,17) ->
	#base_seal_strong{id = 7,lv = 17,cost = [{255,23,189}],add_attr = [{3,170},{5,85}]};

get_seal_strong_info(7,18) ->
	#base_seal_strong{id = 7,lv = 18,cost = [{255,23,207}],add_attr = [{3,180},{5,90}]};

get_seal_strong_info(7,19) ->
	#base_seal_strong{id = 7,lv = 19,cost = [{255,23,227}],add_attr = [{3,190},{5,95}]};

get_seal_strong_info(7,20) ->
	#base_seal_strong{id = 7,lv = 20,cost = [{255,23,247}],add_attr = [{3,200},{5,100}]};

get_seal_strong_info(7,21) ->
	#base_seal_strong{id = 7,lv = 21,cost = [{255,23,268}],add_attr = [{3,210},{5,105}]};

get_seal_strong_info(7,22) ->
	#base_seal_strong{id = 7,lv = 22,cost = [{255,23,290}],add_attr = [{3,220},{5,110}]};

get_seal_strong_info(7,23) ->
	#base_seal_strong{id = 7,lv = 23,cost = [{255,23,312}],add_attr = [{3,230},{5,115}]};

get_seal_strong_info(7,24) ->
	#base_seal_strong{id = 7,lv = 24,cost = [{255,23,335}],add_attr = [{3,240},{5,120}]};

get_seal_strong_info(7,25) ->
	#base_seal_strong{id = 7,lv = 25,cost = [{255,23,359}],add_attr = [{3,250},{5,125}]};

get_seal_strong_info(7,26) ->
	#base_seal_strong{id = 7,lv = 26,cost = [{255,23,384}],add_attr = [{3,260},{5,130}]};

get_seal_strong_info(7,27) ->
	#base_seal_strong{id = 7,lv = 27,cost = [{255,23,410}],add_attr = [{3,270},{5,135}]};

get_seal_strong_info(7,28) ->
	#base_seal_strong{id = 7,lv = 28,cost = [{255,23,436}],add_attr = [{3,280},{5,140}]};

get_seal_strong_info(7,29) ->
	#base_seal_strong{id = 7,lv = 29,cost = [{255,23,463}],add_attr = [{3,290},{5,145}]};

get_seal_strong_info(7,30) ->
	#base_seal_strong{id = 7,lv = 30,cost = [{255,23,491}],add_attr = [{3,300},{5,150}]};

get_seal_strong_info(7,31) ->
	#base_seal_strong{id = 7,lv = 31,cost = [{255,23,519}],add_attr = [{3,310},{5,155}]};

get_seal_strong_info(7,32) ->
	#base_seal_strong{id = 7,lv = 32,cost = [{255,23,548}],add_attr = [{3,320},{5,160}]};

get_seal_strong_info(7,33) ->
	#base_seal_strong{id = 7,lv = 33,cost = [{255,23,578}],add_attr = [{3,330},{5,165}]};

get_seal_strong_info(7,34) ->
	#base_seal_strong{id = 7,lv = 34,cost = [{255,23,609}],add_attr = [{3,340},{5,170}]};

get_seal_strong_info(7,35) ->
	#base_seal_strong{id = 7,lv = 35,cost = [{255,23,640}],add_attr = [{3,350},{5,175}]};

get_seal_strong_info(7,36) ->
	#base_seal_strong{id = 7,lv = 36,cost = [{255,23,672}],add_attr = [{3,360},{5,180}]};

get_seal_strong_info(7,37) ->
	#base_seal_strong{id = 7,lv = 37,cost = [{255,23,705}],add_attr = [{3,370},{5,185}]};

get_seal_strong_info(7,38) ->
	#base_seal_strong{id = 7,lv = 38,cost = [{255,23,738}],add_attr = [{3,380},{5,190}]};

get_seal_strong_info(7,39) ->
	#base_seal_strong{id = 7,lv = 39,cost = [{255,23,772}],add_attr = [{3,390},{5,195}]};

get_seal_strong_info(7,40) ->
	#base_seal_strong{id = 7,lv = 40,cost = [{255,23,807}],add_attr = [{3,400},{5,200}]};

get_seal_strong_info(7,41) ->
	#base_seal_strong{id = 7,lv = 41,cost = [{255,23,842}],add_attr = [{3,410},{5,205}]};

get_seal_strong_info(7,42) ->
	#base_seal_strong{id = 7,lv = 42,cost = [{255,23,878}],add_attr = [{3,420},{5,210}]};

get_seal_strong_info(7,43) ->
	#base_seal_strong{id = 7,lv = 43,cost = [{255,23,915}],add_attr = [{3,430},{5,215}]};

get_seal_strong_info(7,44) ->
	#base_seal_strong{id = 7,lv = 44,cost = [{255,23,953}],add_attr = [{3,440},{5,220}]};

get_seal_strong_info(7,45) ->
	#base_seal_strong{id = 7,lv = 45,cost = [{255,23,991}],add_attr = [{3,450},{5,225}]};

get_seal_strong_info(7,46) ->
	#base_seal_strong{id = 7,lv = 46,cost = [{255,23,1030}],add_attr = [{3,460},{5,230}]};

get_seal_strong_info(7,47) ->
	#base_seal_strong{id = 7,lv = 47,cost = [{255,23,1069}],add_attr = [{3,470},{5,235}]};

get_seal_strong_info(7,48) ->
	#base_seal_strong{id = 7,lv = 48,cost = [{255,23,1109}],add_attr = [{3,480},{5,240}]};

get_seal_strong_info(7,49) ->
	#base_seal_strong{id = 7,lv = 49,cost = [{255,23,1150}],add_attr = [{3,490},{5,245}]};

get_seal_strong_info(7,50) ->
	#base_seal_strong{id = 7,lv = 50,cost = [{255,23,1192}],add_attr = [{3,500},{5,250}]};

get_seal_strong_info(7,51) ->
	#base_seal_strong{id = 7,lv = 51,cost = [{255,23,1234}],add_attr = [{3,510},{5,255}]};

get_seal_strong_info(7,52) ->
	#base_seal_strong{id = 7,lv = 52,cost = [{255,23,1277}],add_attr = [{3,520},{5,260}]};

get_seal_strong_info(7,53) ->
	#base_seal_strong{id = 7,lv = 53,cost = [{255,23,1320}],add_attr = [{3,530},{5,265}]};

get_seal_strong_info(7,54) ->
	#base_seal_strong{id = 7,lv = 54,cost = [{255,23,1364}],add_attr = [{3,540},{5,270}]};

get_seal_strong_info(7,55) ->
	#base_seal_strong{id = 7,lv = 55,cost = [{255,23,1409}],add_attr = [{3,550},{5,275}]};

get_seal_strong_info(7,56) ->
	#base_seal_strong{id = 7,lv = 56,cost = [{255,23,1454}],add_attr = [{3,560},{5,280}]};

get_seal_strong_info(7,57) ->
	#base_seal_strong{id = 7,lv = 57,cost = [{255,23,1500}],add_attr = [{3,570},{5,285}]};

get_seal_strong_info(7,58) ->
	#base_seal_strong{id = 7,lv = 58,cost = [{255,23,1547}],add_attr = [{3,580},{5,290}]};

get_seal_strong_info(7,59) ->
	#base_seal_strong{id = 7,lv = 59,cost = [{255,23,1594}],add_attr = [{3,590},{5,295}]};

get_seal_strong_info(7,60) ->
	#base_seal_strong{id = 7,lv = 60,cost = [{255,23,1642}],add_attr = [{3,600},{5,300}]};

get_seal_strong_info(7,61) ->
	#base_seal_strong{id = 7,lv = 61,cost = [{255,23,1691}],add_attr = [{3,610},{5,305}]};

get_seal_strong_info(7,62) ->
	#base_seal_strong{id = 7,lv = 62,cost = [{255,23,1740}],add_attr = [{3,620},{5,310}]};

get_seal_strong_info(7,63) ->
	#base_seal_strong{id = 7,lv = 63,cost = [{255,23,1790}],add_attr = [{3,630},{5,315}]};

get_seal_strong_info(7,64) ->
	#base_seal_strong{id = 7,lv = 64,cost = [{255,23,1840}],add_attr = [{3,640},{5,320}]};

get_seal_strong_info(7,65) ->
	#base_seal_strong{id = 7,lv = 65,cost = [{255,23,1891}],add_attr = [{3,650},{5,325}]};

get_seal_strong_info(7,66) ->
	#base_seal_strong{id = 7,lv = 66,cost = [{255,23,1943}],add_attr = [{3,660},{5,330}]};

get_seal_strong_info(7,67) ->
	#base_seal_strong{id = 7,lv = 67,cost = [{255,23,1995}],add_attr = [{3,670},{5,335}]};

get_seal_strong_info(7,68) ->
	#base_seal_strong{id = 7,lv = 68,cost = [{255,23,2048}],add_attr = [{3,680},{5,340}]};

get_seal_strong_info(7,69) ->
	#base_seal_strong{id = 7,lv = 69,cost = [{255,23,2102}],add_attr = [{3,690},{5,345}]};

get_seal_strong_info(7,70) ->
	#base_seal_strong{id = 7,lv = 70,cost = [{255,23,2156}],add_attr = [{3,700},{5,350}]};

get_seal_strong_info(7,71) ->
	#base_seal_strong{id = 7,lv = 71,cost = [{255,23,2211}],add_attr = [{3,710},{5,355}]};

get_seal_strong_info(7,72) ->
	#base_seal_strong{id = 7,lv = 72,cost = [{255,23,2266}],add_attr = [{3,720},{5,360}]};

get_seal_strong_info(7,73) ->
	#base_seal_strong{id = 7,lv = 73,cost = [{255,23,2322}],add_attr = [{3,730},{5,365}]};

get_seal_strong_info(7,74) ->
	#base_seal_strong{id = 7,lv = 74,cost = [{255,23,2379}],add_attr = [{3,740},{5,370}]};

get_seal_strong_info(7,75) ->
	#base_seal_strong{id = 7,lv = 75,cost = [{255,23,2436}],add_attr = [{3,750},{5,375}]};

get_seal_strong_info(7,76) ->
	#base_seal_strong{id = 7,lv = 76,cost = [{255,23,2494}],add_attr = [{3,760},{5,380}]};

get_seal_strong_info(7,77) ->
	#base_seal_strong{id = 7,lv = 77,cost = [{255,23,2552}],add_attr = [{3,770},{5,385}]};

get_seal_strong_info(7,78) ->
	#base_seal_strong{id = 7,lv = 78,cost = [{255,23,2612}],add_attr = [{3,780},{5,390}]};

get_seal_strong_info(7,79) ->
	#base_seal_strong{id = 7,lv = 79,cost = [{255,23,2671}],add_attr = [{3,790},{5,395}]};

get_seal_strong_info(7,80) ->
	#base_seal_strong{id = 7,lv = 80,cost = [{255,23,2731}],add_attr = [{3,800},{5,400}]};

get_seal_strong_info(7,81) ->
	#base_seal_strong{id = 7,lv = 81,cost = [{255,23,2792}],add_attr = [{3,810},{5,405}]};

get_seal_strong_info(7,82) ->
	#base_seal_strong{id = 7,lv = 82,cost = [{255,23,2854}],add_attr = [{3,820},{5,410}]};

get_seal_strong_info(7,83) ->
	#base_seal_strong{id = 7,lv = 83,cost = [{255,23,2916}],add_attr = [{3,830},{5,415}]};

get_seal_strong_info(7,84) ->
	#base_seal_strong{id = 7,lv = 84,cost = [{255,23,2978}],add_attr = [{3,840},{5,420}]};

get_seal_strong_info(7,85) ->
	#base_seal_strong{id = 7,lv = 85,cost = [{255,23,3042}],add_attr = [{3,850},{5,425}]};

get_seal_strong_info(7,86) ->
	#base_seal_strong{id = 7,lv = 86,cost = [{255,23,3105}],add_attr = [{3,860},{5,430}]};

get_seal_strong_info(7,87) ->
	#base_seal_strong{id = 7,lv = 87,cost = [{255,23,3170}],add_attr = [{3,870},{5,435}]};

get_seal_strong_info(7,88) ->
	#base_seal_strong{id = 7,lv = 88,cost = [{255,23,3235}],add_attr = [{3,880},{5,440}]};

get_seal_strong_info(7,89) ->
	#base_seal_strong{id = 7,lv = 89,cost = [{255,23,3300}],add_attr = [{3,890},{5,445}]};

get_seal_strong_info(7,90) ->
	#base_seal_strong{id = 7,lv = 90,cost = [{255,23,3366}],add_attr = [{3,900},{5,450}]};

get_seal_strong_info(7,91) ->
	#base_seal_strong{id = 7,lv = 91,cost = [{255,23,3433}],add_attr = [{3,910},{5,455}]};

get_seal_strong_info(7,92) ->
	#base_seal_strong{id = 7,lv = 92,cost = [{255,23,3501}],add_attr = [{3,920},{5,460}]};

get_seal_strong_info(7,93) ->
	#base_seal_strong{id = 7,lv = 93,cost = [{255,23,3568}],add_attr = [{3,930},{5,465}]};

get_seal_strong_info(7,94) ->
	#base_seal_strong{id = 7,lv = 94,cost = [{255,23,3637}],add_attr = [{3,940},{5,470}]};

get_seal_strong_info(7,95) ->
	#base_seal_strong{id = 7,lv = 95,cost = [{255,23,3706}],add_attr = [{3,950},{5,475}]};

get_seal_strong_info(7,96) ->
	#base_seal_strong{id = 7,lv = 96,cost = [{255,23,3776}],add_attr = [{3,960},{5,480}]};

get_seal_strong_info(7,97) ->
	#base_seal_strong{id = 7,lv = 97,cost = [{255,23,3846}],add_attr = [{3,970},{5,485}]};

get_seal_strong_info(7,98) ->
	#base_seal_strong{id = 7,lv = 98,cost = [{255,23,3917}],add_attr = [{3,980},{5,490}]};

get_seal_strong_info(7,99) ->
	#base_seal_strong{id = 7,lv = 99,cost = [{255,23,3988}],add_attr = [{3,990},{5,495}]};

get_seal_strong_info(7,100) ->
	#base_seal_strong{id = 7,lv = 100,cost = [{255,23,4060}],add_attr = [{3,1000},{5,500}]};

get_seal_strong_info(8,0) ->
	#base_seal_strong{id = 8,lv = 0,cost = [],add_attr = [{1,0},{5,0}]};

get_seal_strong_info(8,1) ->
	#base_seal_strong{id = 8,lv = 1,cost = [{255,23,10}],add_attr = [{1,10},{5,5}]};

get_seal_strong_info(8,2) ->
	#base_seal_strong{id = 8,lv = 2,cost = [{255,23,14}],add_attr = [{1,20},{5,10}]};

get_seal_strong_info(8,3) ->
	#base_seal_strong{id = 8,lv = 3,cost = [{255,23,19}],add_attr = [{1,30},{5,15}]};

get_seal_strong_info(8,4) ->
	#base_seal_strong{id = 8,lv = 4,cost = [{255,23,25}],add_attr = [{1,40},{5,20}]};

get_seal_strong_info(8,5) ->
	#base_seal_strong{id = 8,lv = 5,cost = [{255,23,32}],add_attr = [{1,50},{5,25}]};

get_seal_strong_info(8,6) ->
	#base_seal_strong{id = 8,lv = 6,cost = [{255,23,40}],add_attr = [{1,60},{5,30}]};

get_seal_strong_info(8,7) ->
	#base_seal_strong{id = 8,lv = 7,cost = [{255,23,49}],add_attr = [{1,70},{5,35}]};

get_seal_strong_info(8,8) ->
	#base_seal_strong{id = 8,lv = 8,cost = [{255,23,59}],add_attr = [{1,80},{5,40}]};

get_seal_strong_info(8,9) ->
	#base_seal_strong{id = 8,lv = 9,cost = [{255,23,70}],add_attr = [{1,90},{5,45}]};

get_seal_strong_info(8,10) ->
	#base_seal_strong{id = 8,lv = 10,cost = [{255,23,82}],add_attr = [{1,100},{5,50}]};

get_seal_strong_info(8,11) ->
	#base_seal_strong{id = 8,lv = 11,cost = [{255,23,95}],add_attr = [{1,110},{5,55}]};

get_seal_strong_info(8,12) ->
	#base_seal_strong{id = 8,lv = 12,cost = [{255,23,108}],add_attr = [{1,120},{5,60}]};

get_seal_strong_info(8,13) ->
	#base_seal_strong{id = 8,lv = 13,cost = [{255,23,123}],add_attr = [{1,130},{5,65}]};

get_seal_strong_info(8,14) ->
	#base_seal_strong{id = 8,lv = 14,cost = [{255,23,138}],add_attr = [{1,140},{5,70}]};

get_seal_strong_info(8,15) ->
	#base_seal_strong{id = 8,lv = 15,cost = [{255,23,154}],add_attr = [{1,150},{5,75}]};

get_seal_strong_info(8,16) ->
	#base_seal_strong{id = 8,lv = 16,cost = [{255,23,171}],add_attr = [{1,160},{5,80}]};

get_seal_strong_info(8,17) ->
	#base_seal_strong{id = 8,lv = 17,cost = [{255,23,189}],add_attr = [{1,170},{5,85}]};

get_seal_strong_info(8,18) ->
	#base_seal_strong{id = 8,lv = 18,cost = [{255,23,207}],add_attr = [{1,180},{5,90}]};

get_seal_strong_info(8,19) ->
	#base_seal_strong{id = 8,lv = 19,cost = [{255,23,227}],add_attr = [{1,190},{5,95}]};

get_seal_strong_info(8,20) ->
	#base_seal_strong{id = 8,lv = 20,cost = [{255,23,247}],add_attr = [{1,200},{5,100}]};

get_seal_strong_info(8,21) ->
	#base_seal_strong{id = 8,lv = 21,cost = [{255,23,268}],add_attr = [{1,210},{5,105}]};

get_seal_strong_info(8,22) ->
	#base_seal_strong{id = 8,lv = 22,cost = [{255,23,290}],add_attr = [{1,220},{5,110}]};

get_seal_strong_info(8,23) ->
	#base_seal_strong{id = 8,lv = 23,cost = [{255,23,312}],add_attr = [{1,230},{5,115}]};

get_seal_strong_info(8,24) ->
	#base_seal_strong{id = 8,lv = 24,cost = [{255,23,335}],add_attr = [{1,240},{5,120}]};

get_seal_strong_info(8,25) ->
	#base_seal_strong{id = 8,lv = 25,cost = [{255,23,359}],add_attr = [{1,250},{5,125}]};

get_seal_strong_info(8,26) ->
	#base_seal_strong{id = 8,lv = 26,cost = [{255,23,384}],add_attr = [{1,260},{5,130}]};

get_seal_strong_info(8,27) ->
	#base_seal_strong{id = 8,lv = 27,cost = [{255,23,410}],add_attr = [{1,270},{5,135}]};

get_seal_strong_info(8,28) ->
	#base_seal_strong{id = 8,lv = 28,cost = [{255,23,436}],add_attr = [{1,280},{5,140}]};

get_seal_strong_info(8,29) ->
	#base_seal_strong{id = 8,lv = 29,cost = [{255,23,463}],add_attr = [{1,290},{5,145}]};

get_seal_strong_info(8,30) ->
	#base_seal_strong{id = 8,lv = 30,cost = [{255,23,491}],add_attr = [{1,300},{5,150}]};

get_seal_strong_info(8,31) ->
	#base_seal_strong{id = 8,lv = 31,cost = [{255,23,519}],add_attr = [{1,310},{5,155}]};

get_seal_strong_info(8,32) ->
	#base_seal_strong{id = 8,lv = 32,cost = [{255,23,548}],add_attr = [{1,320},{5,160}]};

get_seal_strong_info(8,33) ->
	#base_seal_strong{id = 8,lv = 33,cost = [{255,23,578}],add_attr = [{1,330},{5,165}]};

get_seal_strong_info(8,34) ->
	#base_seal_strong{id = 8,lv = 34,cost = [{255,23,609}],add_attr = [{1,340},{5,170}]};

get_seal_strong_info(8,35) ->
	#base_seal_strong{id = 8,lv = 35,cost = [{255,23,640}],add_attr = [{1,350},{5,175}]};

get_seal_strong_info(8,36) ->
	#base_seal_strong{id = 8,lv = 36,cost = [{255,23,672}],add_attr = [{1,360},{5,180}]};

get_seal_strong_info(8,37) ->
	#base_seal_strong{id = 8,lv = 37,cost = [{255,23,705}],add_attr = [{1,370},{5,185}]};

get_seal_strong_info(8,38) ->
	#base_seal_strong{id = 8,lv = 38,cost = [{255,23,738}],add_attr = [{1,380},{5,190}]};

get_seal_strong_info(8,39) ->
	#base_seal_strong{id = 8,lv = 39,cost = [{255,23,772}],add_attr = [{1,390},{5,195}]};

get_seal_strong_info(8,40) ->
	#base_seal_strong{id = 8,lv = 40,cost = [{255,23,807}],add_attr = [{1,400},{5,200}]};

get_seal_strong_info(8,41) ->
	#base_seal_strong{id = 8,lv = 41,cost = [{255,23,842}],add_attr = [{1,410},{5,205}]};

get_seal_strong_info(8,42) ->
	#base_seal_strong{id = 8,lv = 42,cost = [{255,23,878}],add_attr = [{1,420},{5,210}]};

get_seal_strong_info(8,43) ->
	#base_seal_strong{id = 8,lv = 43,cost = [{255,23,915}],add_attr = [{1,430},{5,215}]};

get_seal_strong_info(8,44) ->
	#base_seal_strong{id = 8,lv = 44,cost = [{255,23,953}],add_attr = [{1,440},{5,220}]};

get_seal_strong_info(8,45) ->
	#base_seal_strong{id = 8,lv = 45,cost = [{255,23,991}],add_attr = [{1,450},{5,225}]};

get_seal_strong_info(8,46) ->
	#base_seal_strong{id = 8,lv = 46,cost = [{255,23,1030}],add_attr = [{1,460},{5,230}]};

get_seal_strong_info(8,47) ->
	#base_seal_strong{id = 8,lv = 47,cost = [{255,23,1069}],add_attr = [{1,470},{5,235}]};

get_seal_strong_info(8,48) ->
	#base_seal_strong{id = 8,lv = 48,cost = [{255,23,1109}],add_attr = [{1,480},{5,240}]};

get_seal_strong_info(8,49) ->
	#base_seal_strong{id = 8,lv = 49,cost = [{255,23,1150}],add_attr = [{1,490},{5,245}]};

get_seal_strong_info(8,50) ->
	#base_seal_strong{id = 8,lv = 50,cost = [{255,23,1192}],add_attr = [{1,500},{5,250}]};

get_seal_strong_info(8,51) ->
	#base_seal_strong{id = 8,lv = 51,cost = [{255,23,1234}],add_attr = [{1,510},{5,255}]};

get_seal_strong_info(8,52) ->
	#base_seal_strong{id = 8,lv = 52,cost = [{255,23,1277}],add_attr = [{1,520},{5,260}]};

get_seal_strong_info(8,53) ->
	#base_seal_strong{id = 8,lv = 53,cost = [{255,23,1320}],add_attr = [{1,530},{5,265}]};

get_seal_strong_info(8,54) ->
	#base_seal_strong{id = 8,lv = 54,cost = [{255,23,1364}],add_attr = [{1,540},{5,270}]};

get_seal_strong_info(8,55) ->
	#base_seal_strong{id = 8,lv = 55,cost = [{255,23,1409}],add_attr = [{1,550},{5,275}]};

get_seal_strong_info(8,56) ->
	#base_seal_strong{id = 8,lv = 56,cost = [{255,23,1454}],add_attr = [{1,560},{5,280}]};

get_seal_strong_info(8,57) ->
	#base_seal_strong{id = 8,lv = 57,cost = [{255,23,1500}],add_attr = [{1,570},{5,285}]};

get_seal_strong_info(8,58) ->
	#base_seal_strong{id = 8,lv = 58,cost = [{255,23,1547}],add_attr = [{1,580},{5,290}]};

get_seal_strong_info(8,59) ->
	#base_seal_strong{id = 8,lv = 59,cost = [{255,23,1594}],add_attr = [{1,590},{5,295}]};

get_seal_strong_info(8,60) ->
	#base_seal_strong{id = 8,lv = 60,cost = [{255,23,1642}],add_attr = [{1,600},{5,300}]};

get_seal_strong_info(8,61) ->
	#base_seal_strong{id = 8,lv = 61,cost = [{255,23,1691}],add_attr = [{1,610},{5,305}]};

get_seal_strong_info(8,62) ->
	#base_seal_strong{id = 8,lv = 62,cost = [{255,23,1740}],add_attr = [{1,620},{5,310}]};

get_seal_strong_info(8,63) ->
	#base_seal_strong{id = 8,lv = 63,cost = [{255,23,1790}],add_attr = [{1,630},{5,315}]};

get_seal_strong_info(8,64) ->
	#base_seal_strong{id = 8,lv = 64,cost = [{255,23,1840}],add_attr = [{1,640},{5,320}]};

get_seal_strong_info(8,65) ->
	#base_seal_strong{id = 8,lv = 65,cost = [{255,23,1891}],add_attr = [{1,650},{5,325}]};

get_seal_strong_info(8,66) ->
	#base_seal_strong{id = 8,lv = 66,cost = [{255,23,1943}],add_attr = [{1,660},{5,330}]};

get_seal_strong_info(8,67) ->
	#base_seal_strong{id = 8,lv = 67,cost = [{255,23,1995}],add_attr = [{1,670},{5,335}]};

get_seal_strong_info(8,68) ->
	#base_seal_strong{id = 8,lv = 68,cost = [{255,23,2048}],add_attr = [{1,680},{5,340}]};

get_seal_strong_info(8,69) ->
	#base_seal_strong{id = 8,lv = 69,cost = [{255,23,2102}],add_attr = [{1,690},{5,345}]};

get_seal_strong_info(8,70) ->
	#base_seal_strong{id = 8,lv = 70,cost = [{255,23,2156}],add_attr = [{1,700},{5,350}]};

get_seal_strong_info(8,71) ->
	#base_seal_strong{id = 8,lv = 71,cost = [{255,23,2211}],add_attr = [{1,710},{5,355}]};

get_seal_strong_info(8,72) ->
	#base_seal_strong{id = 8,lv = 72,cost = [{255,23,2266}],add_attr = [{1,720},{5,360}]};

get_seal_strong_info(8,73) ->
	#base_seal_strong{id = 8,lv = 73,cost = [{255,23,2322}],add_attr = [{1,730},{5,365}]};

get_seal_strong_info(8,74) ->
	#base_seal_strong{id = 8,lv = 74,cost = [{255,23,2379}],add_attr = [{1,740},{5,370}]};

get_seal_strong_info(8,75) ->
	#base_seal_strong{id = 8,lv = 75,cost = [{255,23,2436}],add_attr = [{1,750},{5,375}]};

get_seal_strong_info(8,76) ->
	#base_seal_strong{id = 8,lv = 76,cost = [{255,23,2494}],add_attr = [{1,760},{5,380}]};

get_seal_strong_info(8,77) ->
	#base_seal_strong{id = 8,lv = 77,cost = [{255,23,2552}],add_attr = [{1,770},{5,385}]};

get_seal_strong_info(8,78) ->
	#base_seal_strong{id = 8,lv = 78,cost = [{255,23,2612}],add_attr = [{1,780},{5,390}]};

get_seal_strong_info(8,79) ->
	#base_seal_strong{id = 8,lv = 79,cost = [{255,23,2671}],add_attr = [{1,790},{5,395}]};

get_seal_strong_info(8,80) ->
	#base_seal_strong{id = 8,lv = 80,cost = [{255,23,2731}],add_attr = [{1,800},{5,400}]};

get_seal_strong_info(8,81) ->
	#base_seal_strong{id = 8,lv = 81,cost = [{255,23,2792}],add_attr = [{1,810},{5,405}]};

get_seal_strong_info(8,82) ->
	#base_seal_strong{id = 8,lv = 82,cost = [{255,23,2854}],add_attr = [{1,820},{5,410}]};

get_seal_strong_info(8,83) ->
	#base_seal_strong{id = 8,lv = 83,cost = [{255,23,2916}],add_attr = [{1,830},{5,415}]};

get_seal_strong_info(8,84) ->
	#base_seal_strong{id = 8,lv = 84,cost = [{255,23,2978}],add_attr = [{1,840},{5,420}]};

get_seal_strong_info(8,85) ->
	#base_seal_strong{id = 8,lv = 85,cost = [{255,23,3042}],add_attr = [{1,850},{5,425}]};

get_seal_strong_info(8,86) ->
	#base_seal_strong{id = 8,lv = 86,cost = [{255,23,3105}],add_attr = [{1,860},{5,430}]};

get_seal_strong_info(8,87) ->
	#base_seal_strong{id = 8,lv = 87,cost = [{255,23,3170}],add_attr = [{1,870},{5,435}]};

get_seal_strong_info(8,88) ->
	#base_seal_strong{id = 8,lv = 88,cost = [{255,23,3235}],add_attr = [{1,880},{5,440}]};

get_seal_strong_info(8,89) ->
	#base_seal_strong{id = 8,lv = 89,cost = [{255,23,3300}],add_attr = [{1,890},{5,445}]};

get_seal_strong_info(8,90) ->
	#base_seal_strong{id = 8,lv = 90,cost = [{255,23,3366}],add_attr = [{1,900},{5,450}]};

get_seal_strong_info(8,91) ->
	#base_seal_strong{id = 8,lv = 91,cost = [{255,23,3433}],add_attr = [{1,910},{5,455}]};

get_seal_strong_info(8,92) ->
	#base_seal_strong{id = 8,lv = 92,cost = [{255,23,3501}],add_attr = [{1,920},{5,460}]};

get_seal_strong_info(8,93) ->
	#base_seal_strong{id = 8,lv = 93,cost = [{255,23,3568}],add_attr = [{1,930},{5,465}]};

get_seal_strong_info(8,94) ->
	#base_seal_strong{id = 8,lv = 94,cost = [{255,23,3637}],add_attr = [{1,940},{5,470}]};

get_seal_strong_info(8,95) ->
	#base_seal_strong{id = 8,lv = 95,cost = [{255,23,3706}],add_attr = [{1,950},{5,475}]};

get_seal_strong_info(8,96) ->
	#base_seal_strong{id = 8,lv = 96,cost = [{255,23,3776}],add_attr = [{1,960},{5,480}]};

get_seal_strong_info(8,97) ->
	#base_seal_strong{id = 8,lv = 97,cost = [{255,23,3846}],add_attr = [{1,970},{5,485}]};

get_seal_strong_info(8,98) ->
	#base_seal_strong{id = 8,lv = 98,cost = [{255,23,3917}],add_attr = [{1,980},{5,490}]};

get_seal_strong_info(8,99) ->
	#base_seal_strong{id = 8,lv = 99,cost = [{255,23,3988}],add_attr = [{1,990},{5,495}]};

get_seal_strong_info(8,100) ->
	#base_seal_strong{id = 8,lv = 100,cost = [{255,23,4060}],add_attr = [{1,1000},{5,500}]};

get_seal_strong_info(9,0) ->
	#base_seal_strong{id = 9,lv = 0,cost = [],add_attr = [{1,0},{7,0}]};

get_seal_strong_info(9,1) ->
	#base_seal_strong{id = 9,lv = 1,cost = [{255,23,10}],add_attr = [{1,10},{7,5}]};

get_seal_strong_info(9,2) ->
	#base_seal_strong{id = 9,lv = 2,cost = [{255,23,14}],add_attr = [{1,20},{7,10}]};

get_seal_strong_info(9,3) ->
	#base_seal_strong{id = 9,lv = 3,cost = [{255,23,19}],add_attr = [{1,30},{7,15}]};

get_seal_strong_info(9,4) ->
	#base_seal_strong{id = 9,lv = 4,cost = [{255,23,25}],add_attr = [{1,40},{7,20}]};

get_seal_strong_info(9,5) ->
	#base_seal_strong{id = 9,lv = 5,cost = [{255,23,32}],add_attr = [{1,50},{7,25}]};

get_seal_strong_info(9,6) ->
	#base_seal_strong{id = 9,lv = 6,cost = [{255,23,40}],add_attr = [{1,60},{7,30}]};

get_seal_strong_info(9,7) ->
	#base_seal_strong{id = 9,lv = 7,cost = [{255,23,49}],add_attr = [{1,70},{7,35}]};

get_seal_strong_info(9,8) ->
	#base_seal_strong{id = 9,lv = 8,cost = [{255,23,59}],add_attr = [{1,80},{7,40}]};

get_seal_strong_info(9,9) ->
	#base_seal_strong{id = 9,lv = 9,cost = [{255,23,70}],add_attr = [{1,90},{7,45}]};

get_seal_strong_info(9,10) ->
	#base_seal_strong{id = 9,lv = 10,cost = [{255,23,82}],add_attr = [{1,100},{7,50}]};

get_seal_strong_info(9,11) ->
	#base_seal_strong{id = 9,lv = 11,cost = [{255,23,95}],add_attr = [{1,110},{7,55}]};

get_seal_strong_info(9,12) ->
	#base_seal_strong{id = 9,lv = 12,cost = [{255,23,108}],add_attr = [{1,120},{7,60}]};

get_seal_strong_info(9,13) ->
	#base_seal_strong{id = 9,lv = 13,cost = [{255,23,123}],add_attr = [{1,130},{7,65}]};

get_seal_strong_info(9,14) ->
	#base_seal_strong{id = 9,lv = 14,cost = [{255,23,138}],add_attr = [{1,140},{7,70}]};

get_seal_strong_info(9,15) ->
	#base_seal_strong{id = 9,lv = 15,cost = [{255,23,154}],add_attr = [{1,150},{7,75}]};

get_seal_strong_info(9,16) ->
	#base_seal_strong{id = 9,lv = 16,cost = [{255,23,171}],add_attr = [{1,160},{7,80}]};

get_seal_strong_info(9,17) ->
	#base_seal_strong{id = 9,lv = 17,cost = [{255,23,189}],add_attr = [{1,170},{7,85}]};

get_seal_strong_info(9,18) ->
	#base_seal_strong{id = 9,lv = 18,cost = [{255,23,207}],add_attr = [{1,180},{7,90}]};

get_seal_strong_info(9,19) ->
	#base_seal_strong{id = 9,lv = 19,cost = [{255,23,227}],add_attr = [{1,190},{7,95}]};

get_seal_strong_info(9,20) ->
	#base_seal_strong{id = 9,lv = 20,cost = [{255,23,247}],add_attr = [{1,200},{7,100}]};

get_seal_strong_info(9,21) ->
	#base_seal_strong{id = 9,lv = 21,cost = [{255,23,268}],add_attr = [{1,210},{7,105}]};

get_seal_strong_info(9,22) ->
	#base_seal_strong{id = 9,lv = 22,cost = [{255,23,290}],add_attr = [{1,220},{7,110}]};

get_seal_strong_info(9,23) ->
	#base_seal_strong{id = 9,lv = 23,cost = [{255,23,312}],add_attr = [{1,230},{7,115}]};

get_seal_strong_info(9,24) ->
	#base_seal_strong{id = 9,lv = 24,cost = [{255,23,335}],add_attr = [{1,240},{7,120}]};

get_seal_strong_info(9,25) ->
	#base_seal_strong{id = 9,lv = 25,cost = [{255,23,359}],add_attr = [{1,250},{7,125}]};

get_seal_strong_info(9,26) ->
	#base_seal_strong{id = 9,lv = 26,cost = [{255,23,384}],add_attr = [{1,260},{7,130}]};

get_seal_strong_info(9,27) ->
	#base_seal_strong{id = 9,lv = 27,cost = [{255,23,410}],add_attr = [{1,270},{7,135}]};

get_seal_strong_info(9,28) ->
	#base_seal_strong{id = 9,lv = 28,cost = [{255,23,436}],add_attr = [{1,280},{7,140}]};

get_seal_strong_info(9,29) ->
	#base_seal_strong{id = 9,lv = 29,cost = [{255,23,463}],add_attr = [{1,290},{7,145}]};

get_seal_strong_info(9,30) ->
	#base_seal_strong{id = 9,lv = 30,cost = [{255,23,491}],add_attr = [{1,300},{7,150}]};

get_seal_strong_info(9,31) ->
	#base_seal_strong{id = 9,lv = 31,cost = [{255,23,519}],add_attr = [{1,310},{7,155}]};

get_seal_strong_info(9,32) ->
	#base_seal_strong{id = 9,lv = 32,cost = [{255,23,548}],add_attr = [{1,320},{7,160}]};

get_seal_strong_info(9,33) ->
	#base_seal_strong{id = 9,lv = 33,cost = [{255,23,578}],add_attr = [{1,330},{7,165}]};

get_seal_strong_info(9,34) ->
	#base_seal_strong{id = 9,lv = 34,cost = [{255,23,609}],add_attr = [{1,340},{7,170}]};

get_seal_strong_info(9,35) ->
	#base_seal_strong{id = 9,lv = 35,cost = [{255,23,640}],add_attr = [{1,350},{7,175}]};

get_seal_strong_info(9,36) ->
	#base_seal_strong{id = 9,lv = 36,cost = [{255,23,672}],add_attr = [{1,360},{7,180}]};

get_seal_strong_info(9,37) ->
	#base_seal_strong{id = 9,lv = 37,cost = [{255,23,705}],add_attr = [{1,370},{7,185}]};

get_seal_strong_info(9,38) ->
	#base_seal_strong{id = 9,lv = 38,cost = [{255,23,738}],add_attr = [{1,380},{7,190}]};

get_seal_strong_info(9,39) ->
	#base_seal_strong{id = 9,lv = 39,cost = [{255,23,772}],add_attr = [{1,390},{7,195}]};

get_seal_strong_info(9,40) ->
	#base_seal_strong{id = 9,lv = 40,cost = [{255,23,807}],add_attr = [{1,400},{7,200}]};

get_seal_strong_info(9,41) ->
	#base_seal_strong{id = 9,lv = 41,cost = [{255,23,842}],add_attr = [{1,410},{7,205}]};

get_seal_strong_info(9,42) ->
	#base_seal_strong{id = 9,lv = 42,cost = [{255,23,878}],add_attr = [{1,420},{7,210}]};

get_seal_strong_info(9,43) ->
	#base_seal_strong{id = 9,lv = 43,cost = [{255,23,915}],add_attr = [{1,430},{7,215}]};

get_seal_strong_info(9,44) ->
	#base_seal_strong{id = 9,lv = 44,cost = [{255,23,953}],add_attr = [{1,440},{7,220}]};

get_seal_strong_info(9,45) ->
	#base_seal_strong{id = 9,lv = 45,cost = [{255,23,991}],add_attr = [{1,450},{7,225}]};

get_seal_strong_info(9,46) ->
	#base_seal_strong{id = 9,lv = 46,cost = [{255,23,1030}],add_attr = [{1,460},{7,230}]};

get_seal_strong_info(9,47) ->
	#base_seal_strong{id = 9,lv = 47,cost = [{255,23,1069}],add_attr = [{1,470},{7,235}]};

get_seal_strong_info(9,48) ->
	#base_seal_strong{id = 9,lv = 48,cost = [{255,23,1109}],add_attr = [{1,480},{7,240}]};

get_seal_strong_info(9,49) ->
	#base_seal_strong{id = 9,lv = 49,cost = [{255,23,1150}],add_attr = [{1,490},{7,245}]};

get_seal_strong_info(9,50) ->
	#base_seal_strong{id = 9,lv = 50,cost = [{255,23,1192}],add_attr = [{1,500},{7,250}]};

get_seal_strong_info(9,51) ->
	#base_seal_strong{id = 9,lv = 51,cost = [{255,23,1234}],add_attr = [{1,510},{7,255}]};

get_seal_strong_info(9,52) ->
	#base_seal_strong{id = 9,lv = 52,cost = [{255,23,1277}],add_attr = [{1,520},{7,260}]};

get_seal_strong_info(9,53) ->
	#base_seal_strong{id = 9,lv = 53,cost = [{255,23,1320}],add_attr = [{1,530},{7,265}]};

get_seal_strong_info(9,54) ->
	#base_seal_strong{id = 9,lv = 54,cost = [{255,23,1364}],add_attr = [{1,540},{7,270}]};

get_seal_strong_info(9,55) ->
	#base_seal_strong{id = 9,lv = 55,cost = [{255,23,1409}],add_attr = [{1,550},{7,275}]};

get_seal_strong_info(9,56) ->
	#base_seal_strong{id = 9,lv = 56,cost = [{255,23,1454}],add_attr = [{1,560},{7,280}]};

get_seal_strong_info(9,57) ->
	#base_seal_strong{id = 9,lv = 57,cost = [{255,23,1500}],add_attr = [{1,570},{7,285}]};

get_seal_strong_info(9,58) ->
	#base_seal_strong{id = 9,lv = 58,cost = [{255,23,1547}],add_attr = [{1,580},{7,290}]};

get_seal_strong_info(9,59) ->
	#base_seal_strong{id = 9,lv = 59,cost = [{255,23,1594}],add_attr = [{1,590},{7,295}]};

get_seal_strong_info(9,60) ->
	#base_seal_strong{id = 9,lv = 60,cost = [{255,23,1642}],add_attr = [{1,600},{7,300}]};

get_seal_strong_info(9,61) ->
	#base_seal_strong{id = 9,lv = 61,cost = [{255,23,1691}],add_attr = [{1,610},{7,305}]};

get_seal_strong_info(9,62) ->
	#base_seal_strong{id = 9,lv = 62,cost = [{255,23,1740}],add_attr = [{1,620},{7,310}]};

get_seal_strong_info(9,63) ->
	#base_seal_strong{id = 9,lv = 63,cost = [{255,23,1790}],add_attr = [{1,630},{7,315}]};

get_seal_strong_info(9,64) ->
	#base_seal_strong{id = 9,lv = 64,cost = [{255,23,1840}],add_attr = [{1,640},{7,320}]};

get_seal_strong_info(9,65) ->
	#base_seal_strong{id = 9,lv = 65,cost = [{255,23,1891}],add_attr = [{1,650},{7,325}]};

get_seal_strong_info(9,66) ->
	#base_seal_strong{id = 9,lv = 66,cost = [{255,23,1943}],add_attr = [{1,660},{7,330}]};

get_seal_strong_info(9,67) ->
	#base_seal_strong{id = 9,lv = 67,cost = [{255,23,1995}],add_attr = [{1,670},{7,335}]};

get_seal_strong_info(9,68) ->
	#base_seal_strong{id = 9,lv = 68,cost = [{255,23,2048}],add_attr = [{1,680},{7,340}]};

get_seal_strong_info(9,69) ->
	#base_seal_strong{id = 9,lv = 69,cost = [{255,23,2102}],add_attr = [{1,690},{7,345}]};

get_seal_strong_info(9,70) ->
	#base_seal_strong{id = 9,lv = 70,cost = [{255,23,2156}],add_attr = [{1,700},{7,350}]};

get_seal_strong_info(9,71) ->
	#base_seal_strong{id = 9,lv = 71,cost = [{255,23,2211}],add_attr = [{1,710},{7,355}]};

get_seal_strong_info(9,72) ->
	#base_seal_strong{id = 9,lv = 72,cost = [{255,23,2266}],add_attr = [{1,720},{7,360}]};

get_seal_strong_info(9,73) ->
	#base_seal_strong{id = 9,lv = 73,cost = [{255,23,2322}],add_attr = [{1,730},{7,365}]};

get_seal_strong_info(9,74) ->
	#base_seal_strong{id = 9,lv = 74,cost = [{255,23,2379}],add_attr = [{1,740},{7,370}]};

get_seal_strong_info(9,75) ->
	#base_seal_strong{id = 9,lv = 75,cost = [{255,23,2436}],add_attr = [{1,750},{7,375}]};

get_seal_strong_info(9,76) ->
	#base_seal_strong{id = 9,lv = 76,cost = [{255,23,2494}],add_attr = [{1,760},{7,380}]};

get_seal_strong_info(9,77) ->
	#base_seal_strong{id = 9,lv = 77,cost = [{255,23,2552}],add_attr = [{1,770},{7,385}]};

get_seal_strong_info(9,78) ->
	#base_seal_strong{id = 9,lv = 78,cost = [{255,23,2612}],add_attr = [{1,780},{7,390}]};

get_seal_strong_info(9,79) ->
	#base_seal_strong{id = 9,lv = 79,cost = [{255,23,2671}],add_attr = [{1,790},{7,395}]};

get_seal_strong_info(9,80) ->
	#base_seal_strong{id = 9,lv = 80,cost = [{255,23,2731}],add_attr = [{1,800},{7,400}]};

get_seal_strong_info(9,81) ->
	#base_seal_strong{id = 9,lv = 81,cost = [{255,23,2792}],add_attr = [{1,810},{7,405}]};

get_seal_strong_info(9,82) ->
	#base_seal_strong{id = 9,lv = 82,cost = [{255,23,2854}],add_attr = [{1,820},{7,410}]};

get_seal_strong_info(9,83) ->
	#base_seal_strong{id = 9,lv = 83,cost = [{255,23,2916}],add_attr = [{1,830},{7,415}]};

get_seal_strong_info(9,84) ->
	#base_seal_strong{id = 9,lv = 84,cost = [{255,23,2978}],add_attr = [{1,840},{7,420}]};

get_seal_strong_info(9,85) ->
	#base_seal_strong{id = 9,lv = 85,cost = [{255,23,3042}],add_attr = [{1,850},{7,425}]};

get_seal_strong_info(9,86) ->
	#base_seal_strong{id = 9,lv = 86,cost = [{255,23,3105}],add_attr = [{1,860},{7,430}]};

get_seal_strong_info(9,87) ->
	#base_seal_strong{id = 9,lv = 87,cost = [{255,23,3170}],add_attr = [{1,870},{7,435}]};

get_seal_strong_info(9,88) ->
	#base_seal_strong{id = 9,lv = 88,cost = [{255,23,3235}],add_attr = [{1,880},{7,440}]};

get_seal_strong_info(9,89) ->
	#base_seal_strong{id = 9,lv = 89,cost = [{255,23,3300}],add_attr = [{1,890},{7,445}]};

get_seal_strong_info(9,90) ->
	#base_seal_strong{id = 9,lv = 90,cost = [{255,23,3366}],add_attr = [{1,900},{7,450}]};

get_seal_strong_info(9,91) ->
	#base_seal_strong{id = 9,lv = 91,cost = [{255,23,3433}],add_attr = [{1,910},{7,455}]};

get_seal_strong_info(9,92) ->
	#base_seal_strong{id = 9,lv = 92,cost = [{255,23,3501}],add_attr = [{1,920},{7,460}]};

get_seal_strong_info(9,93) ->
	#base_seal_strong{id = 9,lv = 93,cost = [{255,23,3568}],add_attr = [{1,930},{7,465}]};

get_seal_strong_info(9,94) ->
	#base_seal_strong{id = 9,lv = 94,cost = [{255,23,3637}],add_attr = [{1,940},{7,470}]};

get_seal_strong_info(9,95) ->
	#base_seal_strong{id = 9,lv = 95,cost = [{255,23,3706}],add_attr = [{1,950},{7,475}]};

get_seal_strong_info(9,96) ->
	#base_seal_strong{id = 9,lv = 96,cost = [{255,23,3776}],add_attr = [{1,960},{7,480}]};

get_seal_strong_info(9,97) ->
	#base_seal_strong{id = 9,lv = 97,cost = [{255,23,3846}],add_attr = [{1,970},{7,485}]};

get_seal_strong_info(9,98) ->
	#base_seal_strong{id = 9,lv = 98,cost = [{255,23,3917}],add_attr = [{1,980},{7,490}]};

get_seal_strong_info(9,99) ->
	#base_seal_strong{id = 9,lv = 99,cost = [{255,23,3988}],add_attr = [{1,990},{7,495}]};

get_seal_strong_info(9,100) ->
	#base_seal_strong{id = 9,lv = 100,cost = [{255,23,4060}],add_attr = [{1,1000},{7,500}]};

get_seal_strong_info(10,0) ->
	#base_seal_strong{id = 10,lv = 0,cost = [],add_attr = [{3,0},{7,0}]};

get_seal_strong_info(10,1) ->
	#base_seal_strong{id = 10,lv = 1,cost = [{255,23,10}],add_attr = [{3,10},{7,5}]};

get_seal_strong_info(10,2) ->
	#base_seal_strong{id = 10,lv = 2,cost = [{255,23,14}],add_attr = [{3,20},{7,10}]};

get_seal_strong_info(10,3) ->
	#base_seal_strong{id = 10,lv = 3,cost = [{255,23,19}],add_attr = [{3,30},{7,15}]};

get_seal_strong_info(10,4) ->
	#base_seal_strong{id = 10,lv = 4,cost = [{255,23,25}],add_attr = [{3,40},{7,20}]};

get_seal_strong_info(10,5) ->
	#base_seal_strong{id = 10,lv = 5,cost = [{255,23,32}],add_attr = [{3,50},{7,25}]};

get_seal_strong_info(10,6) ->
	#base_seal_strong{id = 10,lv = 6,cost = [{255,23,40}],add_attr = [{3,60},{7,30}]};

get_seal_strong_info(10,7) ->
	#base_seal_strong{id = 10,lv = 7,cost = [{255,23,49}],add_attr = [{3,70},{7,35}]};

get_seal_strong_info(10,8) ->
	#base_seal_strong{id = 10,lv = 8,cost = [{255,23,59}],add_attr = [{3,80},{7,40}]};

get_seal_strong_info(10,9) ->
	#base_seal_strong{id = 10,lv = 9,cost = [{255,23,70}],add_attr = [{3,90},{7,45}]};

get_seal_strong_info(10,10) ->
	#base_seal_strong{id = 10,lv = 10,cost = [{255,23,82}],add_attr = [{3,100},{7,50}]};

get_seal_strong_info(10,11) ->
	#base_seal_strong{id = 10,lv = 11,cost = [{255,23,95}],add_attr = [{3,110},{7,55}]};

get_seal_strong_info(10,12) ->
	#base_seal_strong{id = 10,lv = 12,cost = [{255,23,108}],add_attr = [{3,120},{7,60}]};

get_seal_strong_info(10,13) ->
	#base_seal_strong{id = 10,lv = 13,cost = [{255,23,123}],add_attr = [{3,130},{7,65}]};

get_seal_strong_info(10,14) ->
	#base_seal_strong{id = 10,lv = 14,cost = [{255,23,138}],add_attr = [{3,140},{7,70}]};

get_seal_strong_info(10,15) ->
	#base_seal_strong{id = 10,lv = 15,cost = [{255,23,154}],add_attr = [{3,150},{7,75}]};

get_seal_strong_info(10,16) ->
	#base_seal_strong{id = 10,lv = 16,cost = [{255,23,171}],add_attr = [{3,160},{7,80}]};

get_seal_strong_info(10,17) ->
	#base_seal_strong{id = 10,lv = 17,cost = [{255,23,189}],add_attr = [{3,170},{7,85}]};

get_seal_strong_info(10,18) ->
	#base_seal_strong{id = 10,lv = 18,cost = [{255,23,207}],add_attr = [{3,180},{7,90}]};

get_seal_strong_info(10,19) ->
	#base_seal_strong{id = 10,lv = 19,cost = [{255,23,227}],add_attr = [{3,190},{7,95}]};

get_seal_strong_info(10,20) ->
	#base_seal_strong{id = 10,lv = 20,cost = [{255,23,247}],add_attr = [{3,200},{7,100}]};

get_seal_strong_info(10,21) ->
	#base_seal_strong{id = 10,lv = 21,cost = [{255,23,268}],add_attr = [{3,210},{7,105}]};

get_seal_strong_info(10,22) ->
	#base_seal_strong{id = 10,lv = 22,cost = [{255,23,290}],add_attr = [{3,220},{7,110}]};

get_seal_strong_info(10,23) ->
	#base_seal_strong{id = 10,lv = 23,cost = [{255,23,312}],add_attr = [{3,230},{7,115}]};

get_seal_strong_info(10,24) ->
	#base_seal_strong{id = 10,lv = 24,cost = [{255,23,335}],add_attr = [{3,240},{7,120}]};

get_seal_strong_info(10,25) ->
	#base_seal_strong{id = 10,lv = 25,cost = [{255,23,359}],add_attr = [{3,250},{7,125}]};

get_seal_strong_info(10,26) ->
	#base_seal_strong{id = 10,lv = 26,cost = [{255,23,384}],add_attr = [{3,260},{7,130}]};

get_seal_strong_info(10,27) ->
	#base_seal_strong{id = 10,lv = 27,cost = [{255,23,410}],add_attr = [{3,270},{7,135}]};

get_seal_strong_info(10,28) ->
	#base_seal_strong{id = 10,lv = 28,cost = [{255,23,436}],add_attr = [{3,280},{7,140}]};

get_seal_strong_info(10,29) ->
	#base_seal_strong{id = 10,lv = 29,cost = [{255,23,463}],add_attr = [{3,290},{7,145}]};

get_seal_strong_info(10,30) ->
	#base_seal_strong{id = 10,lv = 30,cost = [{255,23,491}],add_attr = [{3,300},{7,150}]};

get_seal_strong_info(10,31) ->
	#base_seal_strong{id = 10,lv = 31,cost = [{255,23,519}],add_attr = [{3,310},{7,155}]};

get_seal_strong_info(10,32) ->
	#base_seal_strong{id = 10,lv = 32,cost = [{255,23,548}],add_attr = [{3,320},{7,160}]};

get_seal_strong_info(10,33) ->
	#base_seal_strong{id = 10,lv = 33,cost = [{255,23,578}],add_attr = [{3,330},{7,165}]};

get_seal_strong_info(10,34) ->
	#base_seal_strong{id = 10,lv = 34,cost = [{255,23,609}],add_attr = [{3,340},{7,170}]};

get_seal_strong_info(10,35) ->
	#base_seal_strong{id = 10,lv = 35,cost = [{255,23,640}],add_attr = [{3,350},{7,175}]};

get_seal_strong_info(10,36) ->
	#base_seal_strong{id = 10,lv = 36,cost = [{255,23,672}],add_attr = [{3,360},{7,180}]};

get_seal_strong_info(10,37) ->
	#base_seal_strong{id = 10,lv = 37,cost = [{255,23,705}],add_attr = [{3,370},{7,185}]};

get_seal_strong_info(10,38) ->
	#base_seal_strong{id = 10,lv = 38,cost = [{255,23,738}],add_attr = [{3,380},{7,190}]};

get_seal_strong_info(10,39) ->
	#base_seal_strong{id = 10,lv = 39,cost = [{255,23,772}],add_attr = [{3,390},{7,195}]};

get_seal_strong_info(10,40) ->
	#base_seal_strong{id = 10,lv = 40,cost = [{255,23,807}],add_attr = [{3,400},{7,200}]};

get_seal_strong_info(10,41) ->
	#base_seal_strong{id = 10,lv = 41,cost = [{255,23,842}],add_attr = [{3,410},{7,205}]};

get_seal_strong_info(10,42) ->
	#base_seal_strong{id = 10,lv = 42,cost = [{255,23,878}],add_attr = [{3,420},{7,210}]};

get_seal_strong_info(10,43) ->
	#base_seal_strong{id = 10,lv = 43,cost = [{255,23,915}],add_attr = [{3,430},{7,215}]};

get_seal_strong_info(10,44) ->
	#base_seal_strong{id = 10,lv = 44,cost = [{255,23,953}],add_attr = [{3,440},{7,220}]};

get_seal_strong_info(10,45) ->
	#base_seal_strong{id = 10,lv = 45,cost = [{255,23,991}],add_attr = [{3,450},{7,225}]};

get_seal_strong_info(10,46) ->
	#base_seal_strong{id = 10,lv = 46,cost = [{255,23,1030}],add_attr = [{3,460},{7,230}]};

get_seal_strong_info(10,47) ->
	#base_seal_strong{id = 10,lv = 47,cost = [{255,23,1069}],add_attr = [{3,470},{7,235}]};

get_seal_strong_info(10,48) ->
	#base_seal_strong{id = 10,lv = 48,cost = [{255,23,1109}],add_attr = [{3,480},{7,240}]};

get_seal_strong_info(10,49) ->
	#base_seal_strong{id = 10,lv = 49,cost = [{255,23,1150}],add_attr = [{3,490},{7,245}]};

get_seal_strong_info(10,50) ->
	#base_seal_strong{id = 10,lv = 50,cost = [{255,23,1192}],add_attr = [{3,500},{7,250}]};

get_seal_strong_info(10,51) ->
	#base_seal_strong{id = 10,lv = 51,cost = [{255,23,1234}],add_attr = [{3,510},{7,255}]};

get_seal_strong_info(10,52) ->
	#base_seal_strong{id = 10,lv = 52,cost = [{255,23,1277}],add_attr = [{3,520},{7,260}]};

get_seal_strong_info(10,53) ->
	#base_seal_strong{id = 10,lv = 53,cost = [{255,23,1320}],add_attr = [{3,530},{7,265}]};

get_seal_strong_info(10,54) ->
	#base_seal_strong{id = 10,lv = 54,cost = [{255,23,1364}],add_attr = [{3,540},{7,270}]};

get_seal_strong_info(10,55) ->
	#base_seal_strong{id = 10,lv = 55,cost = [{255,23,1409}],add_attr = [{3,550},{7,275}]};

get_seal_strong_info(10,56) ->
	#base_seal_strong{id = 10,lv = 56,cost = [{255,23,1454}],add_attr = [{3,560},{7,280}]};

get_seal_strong_info(10,57) ->
	#base_seal_strong{id = 10,lv = 57,cost = [{255,23,1500}],add_attr = [{3,570},{7,285}]};

get_seal_strong_info(10,58) ->
	#base_seal_strong{id = 10,lv = 58,cost = [{255,23,1547}],add_attr = [{3,580},{7,290}]};

get_seal_strong_info(10,59) ->
	#base_seal_strong{id = 10,lv = 59,cost = [{255,23,1594}],add_attr = [{3,590},{7,295}]};

get_seal_strong_info(10,60) ->
	#base_seal_strong{id = 10,lv = 60,cost = [{255,23,1642}],add_attr = [{3,600},{7,300}]};

get_seal_strong_info(10,61) ->
	#base_seal_strong{id = 10,lv = 61,cost = [{255,23,1691}],add_attr = [{3,610},{7,305}]};

get_seal_strong_info(10,62) ->
	#base_seal_strong{id = 10,lv = 62,cost = [{255,23,1740}],add_attr = [{3,620},{7,310}]};

get_seal_strong_info(10,63) ->
	#base_seal_strong{id = 10,lv = 63,cost = [{255,23,1790}],add_attr = [{3,630},{7,315}]};

get_seal_strong_info(10,64) ->
	#base_seal_strong{id = 10,lv = 64,cost = [{255,23,1840}],add_attr = [{3,640},{7,320}]};

get_seal_strong_info(10,65) ->
	#base_seal_strong{id = 10,lv = 65,cost = [{255,23,1891}],add_attr = [{3,650},{7,325}]};

get_seal_strong_info(10,66) ->
	#base_seal_strong{id = 10,lv = 66,cost = [{255,23,1943}],add_attr = [{3,660},{7,330}]};

get_seal_strong_info(10,67) ->
	#base_seal_strong{id = 10,lv = 67,cost = [{255,23,1995}],add_attr = [{3,670},{7,335}]};

get_seal_strong_info(10,68) ->
	#base_seal_strong{id = 10,lv = 68,cost = [{255,23,2048}],add_attr = [{3,680},{7,340}]};

get_seal_strong_info(10,69) ->
	#base_seal_strong{id = 10,lv = 69,cost = [{255,23,2102}],add_attr = [{3,690},{7,345}]};

get_seal_strong_info(10,70) ->
	#base_seal_strong{id = 10,lv = 70,cost = [{255,23,2156}],add_attr = [{3,700},{7,350}]};

get_seal_strong_info(10,71) ->
	#base_seal_strong{id = 10,lv = 71,cost = [{255,23,2211}],add_attr = [{3,710},{7,355}]};

get_seal_strong_info(10,72) ->
	#base_seal_strong{id = 10,lv = 72,cost = [{255,23,2266}],add_attr = [{3,720},{7,360}]};

get_seal_strong_info(10,73) ->
	#base_seal_strong{id = 10,lv = 73,cost = [{255,23,2322}],add_attr = [{3,730},{7,365}]};

get_seal_strong_info(10,74) ->
	#base_seal_strong{id = 10,lv = 74,cost = [{255,23,2379}],add_attr = [{3,740},{7,370}]};

get_seal_strong_info(10,75) ->
	#base_seal_strong{id = 10,lv = 75,cost = [{255,23,2436}],add_attr = [{3,750},{7,375}]};

get_seal_strong_info(10,76) ->
	#base_seal_strong{id = 10,lv = 76,cost = [{255,23,2494}],add_attr = [{3,760},{7,380}]};

get_seal_strong_info(10,77) ->
	#base_seal_strong{id = 10,lv = 77,cost = [{255,23,2552}],add_attr = [{3,770},{7,385}]};

get_seal_strong_info(10,78) ->
	#base_seal_strong{id = 10,lv = 78,cost = [{255,23,2612}],add_attr = [{3,780},{7,390}]};

get_seal_strong_info(10,79) ->
	#base_seal_strong{id = 10,lv = 79,cost = [{255,23,2671}],add_attr = [{3,790},{7,395}]};

get_seal_strong_info(10,80) ->
	#base_seal_strong{id = 10,lv = 80,cost = [{255,23,2731}],add_attr = [{3,800},{7,400}]};

get_seal_strong_info(10,81) ->
	#base_seal_strong{id = 10,lv = 81,cost = [{255,23,2792}],add_attr = [{3,810},{7,405}]};

get_seal_strong_info(10,82) ->
	#base_seal_strong{id = 10,lv = 82,cost = [{255,23,2854}],add_attr = [{3,820},{7,410}]};

get_seal_strong_info(10,83) ->
	#base_seal_strong{id = 10,lv = 83,cost = [{255,23,2916}],add_attr = [{3,830},{7,415}]};

get_seal_strong_info(10,84) ->
	#base_seal_strong{id = 10,lv = 84,cost = [{255,23,2978}],add_attr = [{3,840},{7,420}]};

get_seal_strong_info(10,85) ->
	#base_seal_strong{id = 10,lv = 85,cost = [{255,23,3042}],add_attr = [{3,850},{7,425}]};

get_seal_strong_info(10,86) ->
	#base_seal_strong{id = 10,lv = 86,cost = [{255,23,3105}],add_attr = [{3,860},{7,430}]};

get_seal_strong_info(10,87) ->
	#base_seal_strong{id = 10,lv = 87,cost = [{255,23,3170}],add_attr = [{3,870},{7,435}]};

get_seal_strong_info(10,88) ->
	#base_seal_strong{id = 10,lv = 88,cost = [{255,23,3235}],add_attr = [{3,880},{7,440}]};

get_seal_strong_info(10,89) ->
	#base_seal_strong{id = 10,lv = 89,cost = [{255,23,3300}],add_attr = [{3,890},{7,445}]};

get_seal_strong_info(10,90) ->
	#base_seal_strong{id = 10,lv = 90,cost = [{255,23,3366}],add_attr = [{3,900},{7,450}]};

get_seal_strong_info(10,91) ->
	#base_seal_strong{id = 10,lv = 91,cost = [{255,23,3433}],add_attr = [{3,910},{7,455}]};

get_seal_strong_info(10,92) ->
	#base_seal_strong{id = 10,lv = 92,cost = [{255,23,3501}],add_attr = [{3,920},{7,460}]};

get_seal_strong_info(10,93) ->
	#base_seal_strong{id = 10,lv = 93,cost = [{255,23,3568}],add_attr = [{3,930},{7,465}]};

get_seal_strong_info(10,94) ->
	#base_seal_strong{id = 10,lv = 94,cost = [{255,23,3637}],add_attr = [{3,940},{7,470}]};

get_seal_strong_info(10,95) ->
	#base_seal_strong{id = 10,lv = 95,cost = [{255,23,3706}],add_attr = [{3,950},{7,475}]};

get_seal_strong_info(10,96) ->
	#base_seal_strong{id = 10,lv = 96,cost = [{255,23,3776}],add_attr = [{3,960},{7,480}]};

get_seal_strong_info(10,97) ->
	#base_seal_strong{id = 10,lv = 97,cost = [{255,23,3846}],add_attr = [{3,970},{7,485}]};

get_seal_strong_info(10,98) ->
	#base_seal_strong{id = 10,lv = 98,cost = [{255,23,3917}],add_attr = [{3,980},{7,490}]};

get_seal_strong_info(10,99) ->
	#base_seal_strong{id = 10,lv = 99,cost = [{255,23,3988}],add_attr = [{3,990},{7,495}]};

get_seal_strong_info(10,100) ->
	#base_seal_strong{id = 10,lv = 100,cost = [{255,23,4060}],add_attr = [{3,1000},{7,500}]};

get_seal_strong_info(11,0) ->
	#base_seal_strong{id = 11,lv = 0,cost = [],add_attr = [{1,0},{2,0}]};

get_seal_strong_info(11,1) ->
	#base_seal_strong{id = 11,lv = 1,cost = [{255,23,10}],add_attr = [{1,10},{2,200}]};

get_seal_strong_info(11,2) ->
	#base_seal_strong{id = 11,lv = 2,cost = [{255,23,14}],add_attr = [{1,20},{2,400}]};

get_seal_strong_info(11,3) ->
	#base_seal_strong{id = 11,lv = 3,cost = [{255,23,19}],add_attr = [{1,30},{2,600}]};

get_seal_strong_info(11,4) ->
	#base_seal_strong{id = 11,lv = 4,cost = [{255,23,25}],add_attr = [{1,40},{2,800}]};

get_seal_strong_info(11,5) ->
	#base_seal_strong{id = 11,lv = 5,cost = [{255,23,32}],add_attr = [{1,50},{2,1000}]};

get_seal_strong_info(11,6) ->
	#base_seal_strong{id = 11,lv = 6,cost = [{255,23,40}],add_attr = [{1,60},{2,1200}]};

get_seal_strong_info(11,7) ->
	#base_seal_strong{id = 11,lv = 7,cost = [{255,23,49}],add_attr = [{1,70},{2,1400}]};

get_seal_strong_info(11,8) ->
	#base_seal_strong{id = 11,lv = 8,cost = [{255,23,59}],add_attr = [{1,80},{2,1600}]};

get_seal_strong_info(11,9) ->
	#base_seal_strong{id = 11,lv = 9,cost = [{255,23,70}],add_attr = [{1,90},{2,1800}]};

get_seal_strong_info(11,10) ->
	#base_seal_strong{id = 11,lv = 10,cost = [{255,23,82}],add_attr = [{1,100},{2,2000}]};

get_seal_strong_info(11,11) ->
	#base_seal_strong{id = 11,lv = 11,cost = [{255,23,95}],add_attr = [{1,110},{2,2200}]};

get_seal_strong_info(11,12) ->
	#base_seal_strong{id = 11,lv = 12,cost = [{255,23,108}],add_attr = [{1,120},{2,2400}]};

get_seal_strong_info(11,13) ->
	#base_seal_strong{id = 11,lv = 13,cost = [{255,23,123}],add_attr = [{1,130},{2,2600}]};

get_seal_strong_info(11,14) ->
	#base_seal_strong{id = 11,lv = 14,cost = [{255,23,138}],add_attr = [{1,140},{2,2800}]};

get_seal_strong_info(11,15) ->
	#base_seal_strong{id = 11,lv = 15,cost = [{255,23,154}],add_attr = [{1,150},{2,3000}]};

get_seal_strong_info(11,16) ->
	#base_seal_strong{id = 11,lv = 16,cost = [{255,23,171}],add_attr = [{1,160},{2,3200}]};

get_seal_strong_info(11,17) ->
	#base_seal_strong{id = 11,lv = 17,cost = [{255,23,189}],add_attr = [{1,170},{2,3400}]};

get_seal_strong_info(11,18) ->
	#base_seal_strong{id = 11,lv = 18,cost = [{255,23,207}],add_attr = [{1,180},{2,3600}]};

get_seal_strong_info(11,19) ->
	#base_seal_strong{id = 11,lv = 19,cost = [{255,23,227}],add_attr = [{1,190},{2,3800}]};

get_seal_strong_info(11,20) ->
	#base_seal_strong{id = 11,lv = 20,cost = [{255,23,247}],add_attr = [{1,200},{2,4000}]};

get_seal_strong_info(11,21) ->
	#base_seal_strong{id = 11,lv = 21,cost = [{255,23,268}],add_attr = [{1,210},{2,4200}]};

get_seal_strong_info(11,22) ->
	#base_seal_strong{id = 11,lv = 22,cost = [{255,23,290}],add_attr = [{1,220},{2,4400}]};

get_seal_strong_info(11,23) ->
	#base_seal_strong{id = 11,lv = 23,cost = [{255,23,312}],add_attr = [{1,230},{2,4600}]};

get_seal_strong_info(11,24) ->
	#base_seal_strong{id = 11,lv = 24,cost = [{255,23,335}],add_attr = [{1,240},{2,4800}]};

get_seal_strong_info(11,25) ->
	#base_seal_strong{id = 11,lv = 25,cost = [{255,23,359}],add_attr = [{1,250},{2,5000}]};

get_seal_strong_info(11,26) ->
	#base_seal_strong{id = 11,lv = 26,cost = [{255,23,384}],add_attr = [{1,260},{2,5200}]};

get_seal_strong_info(11,27) ->
	#base_seal_strong{id = 11,lv = 27,cost = [{255,23,410}],add_attr = [{1,270},{2,5400}]};

get_seal_strong_info(11,28) ->
	#base_seal_strong{id = 11,lv = 28,cost = [{255,23,436}],add_attr = [{1,280},{2,5600}]};

get_seal_strong_info(11,29) ->
	#base_seal_strong{id = 11,lv = 29,cost = [{255,23,463}],add_attr = [{1,290},{2,5800}]};

get_seal_strong_info(11,30) ->
	#base_seal_strong{id = 11,lv = 30,cost = [{255,23,491}],add_attr = [{1,300},{2,6000}]};

get_seal_strong_info(11,31) ->
	#base_seal_strong{id = 11,lv = 31,cost = [{255,23,519}],add_attr = [{1,310},{2,6200}]};

get_seal_strong_info(11,32) ->
	#base_seal_strong{id = 11,lv = 32,cost = [{255,23,548}],add_attr = [{1,320},{2,6400}]};

get_seal_strong_info(11,33) ->
	#base_seal_strong{id = 11,lv = 33,cost = [{255,23,578}],add_attr = [{1,330},{2,6600}]};

get_seal_strong_info(11,34) ->
	#base_seal_strong{id = 11,lv = 34,cost = [{255,23,609}],add_attr = [{1,340},{2,6800}]};

get_seal_strong_info(11,35) ->
	#base_seal_strong{id = 11,lv = 35,cost = [{255,23,640}],add_attr = [{1,350},{2,7000}]};

get_seal_strong_info(11,36) ->
	#base_seal_strong{id = 11,lv = 36,cost = [{255,23,672}],add_attr = [{1,360},{2,7200}]};

get_seal_strong_info(11,37) ->
	#base_seal_strong{id = 11,lv = 37,cost = [{255,23,705}],add_attr = [{1,370},{2,7400}]};

get_seal_strong_info(11,38) ->
	#base_seal_strong{id = 11,lv = 38,cost = [{255,23,738}],add_attr = [{1,380},{2,7600}]};

get_seal_strong_info(11,39) ->
	#base_seal_strong{id = 11,lv = 39,cost = [{255,23,772}],add_attr = [{1,390},{2,7800}]};

get_seal_strong_info(11,40) ->
	#base_seal_strong{id = 11,lv = 40,cost = [{255,23,807}],add_attr = [{1,400},{2,8000}]};

get_seal_strong_info(11,41) ->
	#base_seal_strong{id = 11,lv = 41,cost = [{255,23,842}],add_attr = [{1,410},{2,8200}]};

get_seal_strong_info(11,42) ->
	#base_seal_strong{id = 11,lv = 42,cost = [{255,23,878}],add_attr = [{1,420},{2,8400}]};

get_seal_strong_info(11,43) ->
	#base_seal_strong{id = 11,lv = 43,cost = [{255,23,915}],add_attr = [{1,430},{2,8600}]};

get_seal_strong_info(11,44) ->
	#base_seal_strong{id = 11,lv = 44,cost = [{255,23,953}],add_attr = [{1,440},{2,8800}]};

get_seal_strong_info(11,45) ->
	#base_seal_strong{id = 11,lv = 45,cost = [{255,23,991}],add_attr = [{1,450},{2,9000}]};

get_seal_strong_info(11,46) ->
	#base_seal_strong{id = 11,lv = 46,cost = [{255,23,1030}],add_attr = [{1,460},{2,9200}]};

get_seal_strong_info(11,47) ->
	#base_seal_strong{id = 11,lv = 47,cost = [{255,23,1069}],add_attr = [{1,470},{2,9400}]};

get_seal_strong_info(11,48) ->
	#base_seal_strong{id = 11,lv = 48,cost = [{255,23,1109}],add_attr = [{1,480},{2,9600}]};

get_seal_strong_info(11,49) ->
	#base_seal_strong{id = 11,lv = 49,cost = [{255,23,1150}],add_attr = [{1,490},{2,9800}]};

get_seal_strong_info(11,50) ->
	#base_seal_strong{id = 11,lv = 50,cost = [{255,23,1192}],add_attr = [{1,500},{2,10000}]};

get_seal_strong_info(11,51) ->
	#base_seal_strong{id = 11,lv = 51,cost = [{255,23,1234}],add_attr = [{1,510},{2,10200}]};

get_seal_strong_info(11,52) ->
	#base_seal_strong{id = 11,lv = 52,cost = [{255,23,1277}],add_attr = [{1,520},{2,10400}]};

get_seal_strong_info(11,53) ->
	#base_seal_strong{id = 11,lv = 53,cost = [{255,23,1320}],add_attr = [{1,530},{2,10600}]};

get_seal_strong_info(11,54) ->
	#base_seal_strong{id = 11,lv = 54,cost = [{255,23,1364}],add_attr = [{1,540},{2,10800}]};

get_seal_strong_info(11,55) ->
	#base_seal_strong{id = 11,lv = 55,cost = [{255,23,1409}],add_attr = [{1,550},{2,11000}]};

get_seal_strong_info(11,56) ->
	#base_seal_strong{id = 11,lv = 56,cost = [{255,23,1454}],add_attr = [{1,560},{2,11200}]};

get_seal_strong_info(11,57) ->
	#base_seal_strong{id = 11,lv = 57,cost = [{255,23,1500}],add_attr = [{1,570},{2,11400}]};

get_seal_strong_info(11,58) ->
	#base_seal_strong{id = 11,lv = 58,cost = [{255,23,1547}],add_attr = [{1,580},{2,11600}]};

get_seal_strong_info(11,59) ->
	#base_seal_strong{id = 11,lv = 59,cost = [{255,23,1594}],add_attr = [{1,590},{2,11800}]};

get_seal_strong_info(11,60) ->
	#base_seal_strong{id = 11,lv = 60,cost = [{255,23,1642}],add_attr = [{1,600},{2,12000}]};

get_seal_strong_info(11,61) ->
	#base_seal_strong{id = 11,lv = 61,cost = [{255,23,1691}],add_attr = [{1,610},{2,12200}]};

get_seal_strong_info(11,62) ->
	#base_seal_strong{id = 11,lv = 62,cost = [{255,23,1740}],add_attr = [{1,620},{2,12400}]};

get_seal_strong_info(11,63) ->
	#base_seal_strong{id = 11,lv = 63,cost = [{255,23,1790}],add_attr = [{1,630},{2,12600}]};

get_seal_strong_info(11,64) ->
	#base_seal_strong{id = 11,lv = 64,cost = [{255,23,1840}],add_attr = [{1,640},{2,12800}]};

get_seal_strong_info(11,65) ->
	#base_seal_strong{id = 11,lv = 65,cost = [{255,23,1891}],add_attr = [{1,650},{2,13000}]};

get_seal_strong_info(11,66) ->
	#base_seal_strong{id = 11,lv = 66,cost = [{255,23,1943}],add_attr = [{1,660},{2,13200}]};

get_seal_strong_info(11,67) ->
	#base_seal_strong{id = 11,lv = 67,cost = [{255,23,1995}],add_attr = [{1,670},{2,13400}]};

get_seal_strong_info(11,68) ->
	#base_seal_strong{id = 11,lv = 68,cost = [{255,23,2048}],add_attr = [{1,680},{2,13600}]};

get_seal_strong_info(11,69) ->
	#base_seal_strong{id = 11,lv = 69,cost = [{255,23,2102}],add_attr = [{1,690},{2,13800}]};

get_seal_strong_info(11,70) ->
	#base_seal_strong{id = 11,lv = 70,cost = [{255,23,2156}],add_attr = [{1,700},{2,14000}]};

get_seal_strong_info(11,71) ->
	#base_seal_strong{id = 11,lv = 71,cost = [{255,23,2211}],add_attr = [{1,710},{2,14200}]};

get_seal_strong_info(11,72) ->
	#base_seal_strong{id = 11,lv = 72,cost = [{255,23,2266}],add_attr = [{1,720},{2,14400}]};

get_seal_strong_info(11,73) ->
	#base_seal_strong{id = 11,lv = 73,cost = [{255,23,2322}],add_attr = [{1,730},{2,14600}]};

get_seal_strong_info(11,74) ->
	#base_seal_strong{id = 11,lv = 74,cost = [{255,23,2379}],add_attr = [{1,740},{2,14800}]};

get_seal_strong_info(11,75) ->
	#base_seal_strong{id = 11,lv = 75,cost = [{255,23,2436}],add_attr = [{1,750},{2,15000}]};

get_seal_strong_info(11,76) ->
	#base_seal_strong{id = 11,lv = 76,cost = [{255,23,2494}],add_attr = [{1,760},{2,15200}]};

get_seal_strong_info(11,77) ->
	#base_seal_strong{id = 11,lv = 77,cost = [{255,23,2552}],add_attr = [{1,770},{2,15400}]};

get_seal_strong_info(11,78) ->
	#base_seal_strong{id = 11,lv = 78,cost = [{255,23,2612}],add_attr = [{1,780},{2,15600}]};

get_seal_strong_info(11,79) ->
	#base_seal_strong{id = 11,lv = 79,cost = [{255,23,2671}],add_attr = [{1,790},{2,15800}]};

get_seal_strong_info(11,80) ->
	#base_seal_strong{id = 11,lv = 80,cost = [{255,23,2731}],add_attr = [{1,800},{2,16000}]};

get_seal_strong_info(11,81) ->
	#base_seal_strong{id = 11,lv = 81,cost = [{255,23,2792}],add_attr = [{1,810},{2,16200}]};

get_seal_strong_info(11,82) ->
	#base_seal_strong{id = 11,lv = 82,cost = [{255,23,2854}],add_attr = [{1,820},{2,16400}]};

get_seal_strong_info(11,83) ->
	#base_seal_strong{id = 11,lv = 83,cost = [{255,23,2916}],add_attr = [{1,830},{2,16600}]};

get_seal_strong_info(11,84) ->
	#base_seal_strong{id = 11,lv = 84,cost = [{255,23,2978}],add_attr = [{1,840},{2,16800}]};

get_seal_strong_info(11,85) ->
	#base_seal_strong{id = 11,lv = 85,cost = [{255,23,3042}],add_attr = [{1,850},{2,17000}]};

get_seal_strong_info(11,86) ->
	#base_seal_strong{id = 11,lv = 86,cost = [{255,23,3105}],add_attr = [{1,860},{2,17200}]};

get_seal_strong_info(11,87) ->
	#base_seal_strong{id = 11,lv = 87,cost = [{255,23,3170}],add_attr = [{1,870},{2,17400}]};

get_seal_strong_info(11,88) ->
	#base_seal_strong{id = 11,lv = 88,cost = [{255,23,3235}],add_attr = [{1,880},{2,17600}]};

get_seal_strong_info(11,89) ->
	#base_seal_strong{id = 11,lv = 89,cost = [{255,23,3300}],add_attr = [{1,890},{2,17800}]};

get_seal_strong_info(11,90) ->
	#base_seal_strong{id = 11,lv = 90,cost = [{255,23,3366}],add_attr = [{1,900},{2,18000}]};

get_seal_strong_info(11,91) ->
	#base_seal_strong{id = 11,lv = 91,cost = [{255,23,3433}],add_attr = [{1,910},{2,18200}]};

get_seal_strong_info(11,92) ->
	#base_seal_strong{id = 11,lv = 92,cost = [{255,23,3501}],add_attr = [{1,920},{2,18400}]};

get_seal_strong_info(11,93) ->
	#base_seal_strong{id = 11,lv = 93,cost = [{255,23,3568}],add_attr = [{1,930},{2,18600}]};

get_seal_strong_info(11,94) ->
	#base_seal_strong{id = 11,lv = 94,cost = [{255,23,3637}],add_attr = [{1,940},{2,18800}]};

get_seal_strong_info(11,95) ->
	#base_seal_strong{id = 11,lv = 95,cost = [{255,23,3706}],add_attr = [{1,950},{2,19000}]};

get_seal_strong_info(11,96) ->
	#base_seal_strong{id = 11,lv = 96,cost = [{255,23,3776}],add_attr = [{1,960},{2,19200}]};

get_seal_strong_info(11,97) ->
	#base_seal_strong{id = 11,lv = 97,cost = [{255,23,3846}],add_attr = [{1,970},{2,19400}]};

get_seal_strong_info(11,98) ->
	#base_seal_strong{id = 11,lv = 98,cost = [{255,23,3917}],add_attr = [{1,980},{2,19600}]};

get_seal_strong_info(11,99) ->
	#base_seal_strong{id = 11,lv = 99,cost = [{255,23,3988}],add_attr = [{1,990},{2,19800}]};

get_seal_strong_info(11,100) ->
	#base_seal_strong{id = 11,lv = 100,cost = [{255,23,4060}],add_attr = [{1,1000},{2,20000}]};

get_seal_strong_info(_Id,_Lv) ->
	[].


get_per_add_attr(6101001) ->
[{4,100}];


get_per_add_attr(6101002) ->
[{3,100}];


get_per_add_attr(6101003) ->
[{2,2000}];


get_per_add_attr(6101004) ->
[{1,200},{2,4000}];

get_per_add_attr(_Goodsid) ->
	[].

get_seal_pill_limit(_GoodsTypeId,_RoleLv) when _GoodsTypeId == 6101001, _RoleLv >= 0, _RoleLv =< 9999 ->
		1000;
get_seal_pill_limit(_GoodsTypeId,_RoleLv) when _GoodsTypeId == 6101002, _RoleLv >= 0, _RoleLv =< 9999 ->
		1000;
get_seal_pill_limit(_GoodsTypeId,_RoleLv) when _GoodsTypeId == 6101003, _RoleLv >= 0, _RoleLv =< 9999 ->
		1000;
get_seal_pill_limit(_GoodsTypeId,_RoleLv) when _GoodsTypeId == 6101004, _RoleLv >= 0, _RoleLv =< 9999 ->
		500;
get_seal_pill_limit(_GoodsTypeId,_RoleLv) ->
	[].


get_seal_value(1) ->
[200];


get_seal_value(2) ->
[6104001];


get_seal_value(3) ->
[95];


get_seal_value(4) ->
[[{0,[2,4,6]},{1,[2,4,5]}]];


get_seal_value(5) ->
[[{0, [1,2,3,4,5,6]},{1, [7,8,9,10,11]}]];

get_seal_value(_Id) ->
	[].


get_rating_by_color(3) ->
[{1,6}];


get_rating_by_color(4) ->
[{2,0}];


get_rating_by_color(5) ->
[{3,0}];


get_rating_by_color(6) ->
[{4,0}];

get_rating_by_color(_Color) ->
	[].

