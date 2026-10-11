%%%---------------------------------------
%%% module      : data_exchange
%%% description : 物品兑换配置
%%%
%%%---------------------------------------
-module(data_exchange).
-compile(export_all).
-include("goods.hrl").



get(1101) ->
	#goods_exchange_cfg{id = 1101,type = 1,role_lv = 30,cost_list = [{255,36180001,3000}],obtain_list = [{0,22030002,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1102) ->
	#goods_exchange_cfg{id = 1102,type = 1,role_lv = 30,cost_list = [{255,36180001,1500}],obtain_list = [{0,1009010731,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1103) ->
	#goods_exchange_cfg{id = 1103,type = 1,role_lv = 30,cost_list = [{255,36180001,1500}],obtain_list = [{0,1007010731,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1104) ->
	#goods_exchange_cfg{id = 1104,type = 1,role_lv = 30,cost_list = [{255,36180001,25}],obtain_list = [{0,14010001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1105) ->
	#goods_exchange_cfg{id = 1105,type = 1,role_lv = 30,cost_list = [{255,36180001,25}],obtain_list = [{0,14020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1106) ->
	#goods_exchange_cfg{id = 1106,type = 1,role_lv = 30,cost_list = [{255,36180001,250}],obtain_list = [{0,22020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1107) ->
	#goods_exchange_cfg{id = 1107,type = 1,role_lv = 30,cost_list = [{255,36180001,250}],obtain_list = [{0,22020002,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1201) ->
	#goods_exchange_cfg{id = 1201,type = 1,role_lv = 400,cost_list = [{255,36180001,6000}],obtain_list = [{0,22030003,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1202) ->
	#goods_exchange_cfg{id = 1202,type = 1,role_lv = 400,cost_list = [{255,36180001,3000}],obtain_list = [{0,38041027,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1203) ->
	#goods_exchange_cfg{id = 1203,type = 1,role_lv = 400,cost_list = [{255,36180001,3000}],obtain_list = [{0,38041028,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1204) ->
	#goods_exchange_cfg{id = 1204,type = 1,role_lv = 400,cost_list = [{255,36180001,250}],obtain_list = [{0,14110002,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1205) ->
	#goods_exchange_cfg{id = 1205,type = 1,role_lv = 400,cost_list = [{255,36180001,500}],obtain_list = [{0,40030005,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1301) ->
	#goods_exchange_cfg{id = 1301,type = 1,role_lv = 450,cost_list = [{255,36180001,4500}],obtain_list = [{0,38040008,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1302) ->
	#goods_exchange_cfg{id = 1302,type = 1,role_lv = 450,cost_list = [{255,36180001,4500}],obtain_list = [{0,38040009,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1303) ->
	#goods_exchange_cfg{id = 1303,type = 1,role_lv = 450,cost_list = [{255,36180001,9000}],obtain_list = [{0,22030004,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1401) ->
	#goods_exchange_cfg{id = 1401,type = 2,role_lv = 1,cost_list = [{255,36255001,8000}],obtain_list = [{0,12020003,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 1,condition = []};

get(1402) ->
	#goods_exchange_cfg{id = 1402,type = 2,role_lv = 1,cost_list = [{255,36255001,6300}],obtain_list = [{0,38065011,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 1,condition = []};

get(1403) ->
	#goods_exchange_cfg{id = 1403,type = 2,role_lv = 1,cost_list = [{255,36255001,6000}],obtain_list = [{0,38210001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 1,condition = []};

get(1404) ->
	#goods_exchange_cfg{id = 1404,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,18010001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1405) ->
	#goods_exchange_cfg{id = 1405,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,18010002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1406) ->
	#goods_exchange_cfg{id = 1406,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,17010001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1407) ->
	#goods_exchange_cfg{id = 1407,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,17010002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1408) ->
	#goods_exchange_cfg{id = 1408,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,16010001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1409) ->
	#goods_exchange_cfg{id = 1409,type = 2,role_lv = 1,cost_list = [{255,36255001,880}],obtain_list = [{0,16010002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1410) ->
	#goods_exchange_cfg{id = 1410,type = 2,role_lv = 1,cost_list = [{255,36255001,1760}],obtain_list = [{0,14010001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1411) ->
	#goods_exchange_cfg{id = 1411,type = 2,role_lv = 1,cost_list = [{255,36255001,1760}],obtain_list = [{0,14020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1412) ->
	#goods_exchange_cfg{id = 1412,type = 2,role_lv = 1,cost_list = [{255,36255001,100}],obtain_list = [{0,18020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1501) ->
	#goods_exchange_cfg{id = 1501,type = 2,role_lv = 1,cost_list = [{255,36255001,100}],obtain_list = [{0,16020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1502) ->
	#goods_exchange_cfg{id = 1502,type = 2,role_lv = 1,cost_list = [{255,36255001,100}],obtain_list = [{0,17020001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1503) ->
	#goods_exchange_cfg{id = 1503,type = 2,role_lv = 1,cost_list = [{255,36255001,10}],obtain_list = [{0,38040005,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1504) ->
	#goods_exchange_cfg{id = 1504,type = 3,role_lv = 1,cost_list = [{255,36255002,300}],obtain_list = [{0,38065008,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 1,condition = []};

get(1505) ->
	#goods_exchange_cfg{id = 1505,type = 3,role_lv = 1,cost_list = [{255,36255002,4800}],obtain_list = [{0,35,1000}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1506) ->
	#goods_exchange_cfg{id = 1506,type = 3,role_lv = 1,cost_list = [{255,36255002,2400}],obtain_list = [{0,35,500}],lim_type = 3,module = 0,sub_module = 0,lim_num = 10,condition = []};

get(1507) ->
	#goods_exchange_cfg{id = 1507,type = 3,role_lv = 1,cost_list = [{255,36255002,1500}],obtain_list = [{0,35,300}],lim_type = 3,module = 0,sub_module = 0,lim_num = 20,condition = []};

get(1508) ->
	#goods_exchange_cfg{id = 1508,type = 3,role_lv = 1,cost_list = [{255,36255002,500}],obtain_list = [{0,35,100}],lim_type = 3,module = 0,sub_module = 0,lim_num = 50,condition = []};

get(1509) ->
	#goods_exchange_cfg{id = 1509,type = 3,role_lv = 1,cost_list = [{255,36255002,100}],obtain_list = [{0,20020001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 10,condition = []};

get(1601) ->
	#goods_exchange_cfg{id = 1601,type = 4,role_lv = 250,cost_list = [{255,36255003,8000}],obtain_list = [{0,68010007,10}],lim_type = 3,module = 0,sub_module = 0,lim_num = 3,condition = []};

get(1602) ->
	#goods_exchange_cfg{id = 1602,type = 4,role_lv = 250,cost_list = [{255,36255003,6000}],obtain_list = [{0,68010006,10}],lim_type = 3,module = 0,sub_module = 0,lim_num = 3,condition = []};

get(1603) ->
	#goods_exchange_cfg{id = 1603,type = 4,role_lv = 250,cost_list = [{255,36255003,5000}],obtain_list = [{0,68010005,10}],lim_type = 3,module = 0,sub_module = 0,lim_num = 3,condition = []};

get(1604) ->
	#goods_exchange_cfg{id = 1604,type = 4,role_lv = 250,cost_list = [{255,36255003,2000}],obtain_list = [{0,38240027,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 3,condition = []};

get(1605) ->
	#goods_exchange_cfg{id = 1605,type = 4,role_lv = 250,cost_list = [{255,36255003,4000}],obtain_list = [{0,5901002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 2,condition = []};

get(1606) ->
	#goods_exchange_cfg{id = 1606,type = 4,role_lv = 250,cost_list = [{255,36255003,4000}],obtain_list = [{0,5902002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 2,condition = []};

get(1607) ->
	#goods_exchange_cfg{id = 1607,type = 4,role_lv = 250,cost_list = [{255,36255003,2000}],obtain_list = [{0,38240201,10}],lim_type = 3,module = 0,sub_module = 0,lim_num = 1,condition = []};

get(1608) ->
	#goods_exchange_cfg{id = 1608,type = 4,role_lv = 250,cost_list = [{255,36255003,120}],obtain_list = [{0,32010003,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 5,condition = []};

get(1609) ->
	#goods_exchange_cfg{id = 1609,type = 4,role_lv = 250,cost_list = [{255,36255003,1000}],obtain_list = [{0,32010205,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 3,condition = []};

get(1610) ->
	#goods_exchange_cfg{id = 1610,type = 4,role_lv = 250,cost_list = [{255,36255003,500}],obtain_list = [{0,17010001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 2,condition = []};

get(1611) ->
	#goods_exchange_cfg{id = 1611,type = 4,role_lv = 250,cost_list = [{255,36255003,500}],obtain_list = [{0,17010002,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 2,condition = []};

get(1612) ->
	#goods_exchange_cfg{id = 1612,type = 4,role_lv = 250,cost_list = [{255,36255003,20}],obtain_list = [{0,16020001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 99,condition = []};

get(1613) ->
	#goods_exchange_cfg{id = 1613,type = 4,role_lv = 250,cost_list = [{255,36255003,20}],obtain_list = [{0,17020001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 99,condition = []};

get(1614) ->
	#goods_exchange_cfg{id = 1614,type = 4,role_lv = 250,cost_list = [{255,36255003,20}],obtain_list = [{0,18020001,1}],lim_type = 3,module = 0,sub_module = 0,lim_num = 99,condition = []};

get(1701) ->
	#goods_exchange_cfg{id = 1701,type = 5,role_lv = 30,cost_list = [{0,16030105,30}],obtain_list = [{0,16030005,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1702) ->
	#goods_exchange_cfg{id = 1702,type = 5,role_lv = 30,cost_list = [{0,18030102,5}],obtain_list = [{0,18030002,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1703) ->
	#goods_exchange_cfg{id = 1703,type = 5,role_lv = 30,cost_list = [{0,18030103,5}],obtain_list = [{0,18030003,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1704) ->
	#goods_exchange_cfg{id = 1704,type = 5,role_lv = 30,cost_list = [{0,18030104,5}],obtain_list = [{0,18030004,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1705) ->
	#goods_exchange_cfg{id = 1705,type = 5,role_lv = 30,cost_list = [{0,18030105,5}],obtain_list = [{0,18030005,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1706) ->
	#goods_exchange_cfg{id = 1706,type = 5,role_lv = 30,cost_list = [{0,18030106,5}],obtain_list = [{0,18030006,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1707) ->
	#goods_exchange_cfg{id = 1707,type = 5,role_lv = 30,cost_list = [{0,19030101,5}],obtain_list = [{0,19030001,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1708) ->
	#goods_exchange_cfg{id = 1708,type = 5,role_lv = 30,cost_list = [{0,19030102,100}],obtain_list = [{0,19030002,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1709) ->
	#goods_exchange_cfg{id = 1709,type = 5,role_lv = 30,cost_list = [{0,19030103,5}],obtain_list = [{0,19030003,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1710) ->
	#goods_exchange_cfg{id = 1710,type = 5,role_lv = 30,cost_list = [{0,19030104,5}],obtain_list = [{0,19030004,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1711) ->
	#goods_exchange_cfg{id = 1711,type = 5,role_lv = 30,cost_list = [{0,19030105,5}],obtain_list = [{0,19030005,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1712) ->
	#goods_exchange_cfg{id = 1712,type = 5,role_lv = 30,cost_list = [{0,19030106,5}],obtain_list = [{0,19030006,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1713) ->
	#goods_exchange_cfg{id = 1713,type = 5,role_lv = 30,cost_list = [{0,19030107,5}],obtain_list = [{0,19030007,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(1714) ->
	#goods_exchange_cfg{id = 1714,type = 5,role_lv = 30,cost_list = [{0,19030108,5}],obtain_list = [{0,19030008,1}],lim_type = 0,module = 0,sub_module = 0,lim_num = 0,condition = []};

get(6001) ->
	#goods_exchange_cfg{id = 6001,type = 6,role_lv = 1,cost_list = [{0,6410102,20}],obtain_list = [{0,6310102,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6002) ->
	#goods_exchange_cfg{id = 6002,type = 6,role_lv = 1,cost_list = [{0,6410103,20}],obtain_list = [{0,6310103,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6003) ->
	#goods_exchange_cfg{id = 6003,type = 6,role_lv = 1,cost_list = [{0,6410104,30}],obtain_list = [{0,6310104,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6004) ->
	#goods_exchange_cfg{id = 6004,type = 6,role_lv = 1,cost_list = [{0,6410202,20}],obtain_list = [{0,6310202,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6005) ->
	#goods_exchange_cfg{id = 6005,type = 6,role_lv = 1,cost_list = [{0,6410203,20}],obtain_list = [{0,6310203,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6006) ->
	#goods_exchange_cfg{id = 6006,type = 6,role_lv = 1,cost_list = [{0,6410204,30}],obtain_list = [{0,6310204,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6007) ->
	#goods_exchange_cfg{id = 6007,type = 6,role_lv = 1,cost_list = [{0,6410302,20}],obtain_list = [{0,6310302,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6008) ->
	#goods_exchange_cfg{id = 6008,type = 6,role_lv = 1,cost_list = [{0,6410303,20}],obtain_list = [{0,6310303,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6009) ->
	#goods_exchange_cfg{id = 6009,type = 6,role_lv = 1,cost_list = [{0,6410304,30}],obtain_list = [{0,6310304,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6010) ->
	#goods_exchange_cfg{id = 6010,type = 6,role_lv = 1,cost_list = [{0,6410402,20}],obtain_list = [{0,6310402,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6011) ->
	#goods_exchange_cfg{id = 6011,type = 6,role_lv = 1,cost_list = [{0,6410403,20}],obtain_list = [{0,6310403,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6012) ->
	#goods_exchange_cfg{id = 6012,type = 6,role_lv = 1,cost_list = [{0,6410404,30}],obtain_list = [{0,6310404,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6013) ->
	#goods_exchange_cfg{id = 6013,type = 6,role_lv = 1,cost_list = [{0,6410502,20}],obtain_list = [{0,6310502,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6014) ->
	#goods_exchange_cfg{id = 6014,type = 6,role_lv = 1,cost_list = [{0,6410503,20}],obtain_list = [{0,6310503,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6015) ->
	#goods_exchange_cfg{id = 6015,type = 6,role_lv = 1,cost_list = [{0,6410504,30}],obtain_list = [{0,6310504,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6016) ->
	#goods_exchange_cfg{id = 6016,type = 6,role_lv = 1,cost_list = [{0,6410602,20}],obtain_list = [{0,6310602,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6017) ->
	#goods_exchange_cfg{id = 6017,type = 6,role_lv = 1,cost_list = [{0,6410603,20}],obtain_list = [{0,6310603,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6018) ->
	#goods_exchange_cfg{id = 6018,type = 6,role_lv = 1,cost_list = [{0,6410604,30}],obtain_list = [{0,6310604,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6019) ->
	#goods_exchange_cfg{id = 6019,type = 6,role_lv = 1,cost_list = [{0,6420703,25}],obtain_list = [{0,6320703,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6020) ->
	#goods_exchange_cfg{id = 6020,type = 6,role_lv = 1,cost_list = [{0,6420704,30}],obtain_list = [{0,6320704,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6021) ->
	#goods_exchange_cfg{id = 6021,type = 6,role_lv = 1,cost_list = [{0,6420705,50}],obtain_list = [{0,6320705,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6022) ->
	#goods_exchange_cfg{id = 6022,type = 6,role_lv = 1,cost_list = [{0,6420803,25}],obtain_list = [{0,6320803,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6023) ->
	#goods_exchange_cfg{id = 6023,type = 6,role_lv = 1,cost_list = [{0,6420804,30}],obtain_list = [{0,6320804,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6024) ->
	#goods_exchange_cfg{id = 6024,type = 6,role_lv = 1,cost_list = [{0,6420805,50}],obtain_list = [{0,6320805,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6025) ->
	#goods_exchange_cfg{id = 6025,type = 6,role_lv = 1,cost_list = [{0,6420903,25}],obtain_list = [{0,6320903,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6026) ->
	#goods_exchange_cfg{id = 6026,type = 6,role_lv = 1,cost_list = [{0,6420904,30}],obtain_list = [{0,6320904,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6027) ->
	#goods_exchange_cfg{id = 6027,type = 6,role_lv = 1,cost_list = [{0,6420905,50}],obtain_list = [{0,6320905,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6028) ->
	#goods_exchange_cfg{id = 6028,type = 6,role_lv = 1,cost_list = [{0,6421003,25}],obtain_list = [{0,6321003,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6029) ->
	#goods_exchange_cfg{id = 6029,type = 6,role_lv = 1,cost_list = [{0,6421004,30}],obtain_list = [{0,6321004,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6030) ->
	#goods_exchange_cfg{id = 6030,type = 6,role_lv = 1,cost_list = [{0,6421005,50}],obtain_list = [{0,6321005,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6031) ->
	#goods_exchange_cfg{id = 6031,type = 6,role_lv = 1,cost_list = [{0,6421103,25}],obtain_list = [{0,6321103,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6032) ->
	#goods_exchange_cfg{id = 6032,type = 6,role_lv = 1,cost_list = [{0,6421104,30}],obtain_list = [{0,6321104,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6033) ->
	#goods_exchange_cfg{id = 6033,type = 6,role_lv = 1,cost_list = [{0,6421105,50}],obtain_list = [{0,6321105,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6034) ->
	#goods_exchange_cfg{id = 6034,type = 6,role_lv = 1,cost_list = [{0,6421203,25}],obtain_list = [{0,6321203,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6035) ->
	#goods_exchange_cfg{id = 6035,type = 6,role_lv = 1,cost_list = [{0,6421204,30}],obtain_list = [{0,6321204,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6036) ->
	#goods_exchange_cfg{id = 6036,type = 6,role_lv = 1,cost_list = [{0,6421205,50}],obtain_list = [{0,6321205,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6037) ->
	#goods_exchange_cfg{id = 6037,type = 6,role_lv = 1,cost_list = [{0,6431304,30}],obtain_list = [{0,6331304,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6038) ->
	#goods_exchange_cfg{id = 6038,type = 6,role_lv = 1,cost_list = [{0,6431305,50}],obtain_list = [{0,6331305,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6039) ->
	#goods_exchange_cfg{id = 6039,type = 6,role_lv = 1,cost_list = [{0,6431404,30}],obtain_list = [{0,6331404,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6040) ->
	#goods_exchange_cfg{id = 6040,type = 6,role_lv = 1,cost_list = [{0,6431405,50}],obtain_list = [{0,6331405,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6041) ->
	#goods_exchange_cfg{id = 6041,type = 6,role_lv = 1,cost_list = [{0,6431504,30}],obtain_list = [{0,6331504,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6042) ->
	#goods_exchange_cfg{id = 6042,type = 6,role_lv = 1,cost_list = [{0,6431505,50}],obtain_list = [{0,6331505,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6043) ->
	#goods_exchange_cfg{id = 6043,type = 6,role_lv = 1,cost_list = [{0,6431604,30}],obtain_list = [{0,6331604,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(6044) ->
	#goods_exchange_cfg{id = 6044,type = 6,role_lv = 1,cost_list = [{0,6431605,50}],obtain_list = [{0,6331605,1}],lim_type = 0,module = 181,sub_module = 0,lim_num = 0,condition = []};

get(7001) ->
	#goods_exchange_cfg{id = 7001,type = 7,role_lv = 1,cost_list = [{0,22020001,20}],obtain_list = [{0,22030001,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = [{finish_dun,37019}]};

get(7002) ->
	#goods_exchange_cfg{id = 7002,type = 7,role_lv = 1,cost_list = [{0,22020001,24}],obtain_list = [{0,22030002,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = [{finish_dun,37029}]};

get(7003) ->
	#goods_exchange_cfg{id = 7003,type = 7,role_lv = 1,cost_list = [{0,22020001,32}],obtain_list = [{0,22030003,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = [{finish_dun,37039}]};

get(7004) ->
	#goods_exchange_cfg{id = 7004,type = 7,role_lv = 1,cost_list = [{0,22020001,40}],obtain_list = [{0,22030004,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = [{finish_dun,37049}]};

get(7005) ->
	#goods_exchange_cfg{id = 7005,type = 7,role_lv = 1,cost_list = [{0,22020001,48}],obtain_list = [{0,22030005,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = [{finish_dun,37059}]};

get(7006) ->
	#goods_exchange_cfg{id = 7006,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030006,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7007) ->
	#goods_exchange_cfg{id = 7007,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030007,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7008) ->
	#goods_exchange_cfg{id = 7008,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030008,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7009) ->
	#goods_exchange_cfg{id = 7009,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030009,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7010) ->
	#goods_exchange_cfg{id = 7010,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030010,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7011) ->
	#goods_exchange_cfg{id = 7011,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030011,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(7012) ->
	#goods_exchange_cfg{id = 7012,type = 7,role_lv = 1,cost_list = [{0,22020001,1}],obtain_list = [{0,22030012,1}],lim_type = 0,module = 142,sub_module = 0,lim_num = 0,condition = []};

get(_Id) ->
	[].


get_ids(1) ->
[1101,1102,1103,1104,1105,1106,1107,1201,1202,1203,1204,1205,1301,1302,1303];


get_ids(2) ->
[1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412,1501,1502,1503];


get_ids(3) ->
[1504,1505,1506,1507,1508,1509];


get_ids(4) ->
[1601,1602,1603,1604,1605,1606,1607,1608,1609,1610,1611,1612,1613,1614];


get_ids(5) ->
[1701,1702,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714];


get_ids(6) ->
[6001,6002,6003,6004,6005,6006,6007,6008,6009,6010,6011,6012,6013,6014,6015,6016,6017,6018,6019,6020,6021,6022,6023,6024,6025,6026,6027,6028,6029,6030,6031,6032,6033,6034,6035,6036,6037,6038,6039,6040,6041,6042,6043,6044];


get_ids(7) ->
[7001,7002,7003,7004,7005,7006,7007,7008,7009,7010,7011,7012];

get_ids(_Type) ->
	[].

