%%%---------------------------------------
%%% module      : data_fairy
%%% description : 精灵配置
%%%
%%%---------------------------------------
-module(data_fairy).
-compile(export_all).
-include("fairy.hrl").



get_fairy_info(1001) ->
	#fairy_info_cfg{fairy_id = 1001,name = "血焰魔蛋",figure_id = 301001,unlock_skill = [{801001,1},{801002,3},{801003,5}]};

get_fairy_info(1002) ->
	#fairy_info_cfg{fairy_id = 1002,name = "毛团咪啾",figure_id = 301002,unlock_skill = [{802001,1},{802002,3},{802003,5}]};

get_fairy_info(1003) ->
	#fairy_info_cfg{fairy_id = 1003,name = "机械猫熊",figure_id = 301003,unlock_skill = [{803001,1},{803002,3},{803003,5}]};

get_fairy_info(1004) ->
	#fairy_info_cfg{fairy_id = 1004,name = "恶魔兽娘",figure_id = 301004,unlock_skill = [{804001,1},{804002,3},{804003,5},{804004,7}]};

get_fairy_info(1005) ->
	#fairy_info_cfg{fairy_id = 1005,name = "海魅妖姬",figure_id = 301005,unlock_skill = [{805001,1},{805002,3},{805003,5},{805004,7}]};

get_fairy_info(1006) ->
	#fairy_info_cfg{fairy_id = 1006,name = "朋克偶像",figure_id = 301006,unlock_skill = [{806001,1},{806002,3},{806003,5},{806004,7}]};

get_fairy_info(1007) ->
	#fairy_info_cfg{fairy_id = 1007,name = "发条魔灵",figure_id = 301007,unlock_skill = [{807001,1},{807002,3},{807003,5},{807004,7}]};

get_fairy_info(1008) ->
	#fairy_info_cfg{fairy_id = 1008,name = "机械萌姬",figure_id = 301008,unlock_skill = [{808001,1},{808002,3},{808003,5},{808004,7}]};

get_fairy_info(1009) ->
	#fairy_info_cfg{fairy_id = 1009,name = "魔瞳之主",figure_id = 301009,unlock_skill = [{809001,1},{809002,3},{809003,5},{809004,7}]};

get_fairy_info(_Fairyid) ->
	[].

get_all_fairy_id() ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009].

get_fairy_stage(1001,0) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 0,attr = [{3,2000},{4,2000},{6,1600},{7,1600},{14,100}],cost = [{0,21030001,30}],skill_list = [801101]};

get_fairy_stage(1001,1) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 1,attr = [{3,3600},{4,3600},{6,2880},{7,2880},{14,180}],cost = [{0,21030001,40}],skill_list = [801001,801101]};

get_fairy_stage(1001,2) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 2,attr = [{3,5200},{4,5200},{6,4160},{7,4160},{14,260}],cost = [{0,21030001,50}],skill_list = [801001,801101]};

get_fairy_stage(1001,3) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 3,attr = [{3,6800},{4,6800},{6,5440},{7,5440},{14,340}],cost = [{0,21030001,60}],skill_list = [801001,801002,801101]};

get_fairy_stage(1001,4) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 4,attr = [{3,8400},{4,8400},{6,6720},{7,6720},{14,420}],cost = [{0,21030001,80}],skill_list = [801001,801002,801101]};

get_fairy_stage(1001,5) ->
	#fairy_stage_cfg{fairy_id = 1001,stage = 5,attr = [{3,10000},{4,10000},{6,8000},{7,8000},{14,500}],cost = [{0,21030001,150}],skill_list = [801001,801002,801003,801101]};

get_fairy_stage(1002,0) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 0,attr = [{2,80000},{4,2000},{5,1600},{8,1600},{44,1000}],cost = [{0,21030002,30}],skill_list = [802101]};

get_fairy_stage(1002,1) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 1,attr = [{2,144000},{4,3600},{5,2880},{8,2880},{44,1800}],cost = [{0,21030002,40}],skill_list = [802001,802101]};

get_fairy_stage(1002,2) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 2,attr = [{2,208000},{4,5200},{5,4160},{8,4160},{44,2600}],cost = [{0,21030002,50}],skill_list = [802001,802101]};

get_fairy_stage(1002,3) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 3,attr = [{2,272000},{4,6800},{5,5440},{8,5440},{44,3400}],cost = [{0,21030002,60}],skill_list = [802001,802002,802101]};

get_fairy_stage(1002,4) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 4,attr = [{2,336000},{4,8400},{5,6720},{8,6720},{44,4200}],cost = [{0,21030002,80}],skill_list = [802001,802002,802101]};

get_fairy_stage(1002,5) ->
	#fairy_stage_cfg{fairy_id = 1002,stage = 5,attr = [{2,400000},{4,10000},{5,8000},{8,8000},{44,5000}],cost = [{0,21030002,150}],skill_list = [802001,802002,802003,802101]};

get_fairy_stage(1003,0) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 0,attr = [{1,4000},{2,80000},{7,1600},{5,1600},{20,150}],cost = [{0,21030003,30}],skill_list = [803101]};

get_fairy_stage(1003,1) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 1,attr = [{1,7200},{2,144000},{7,2880},{5,2880},{20,270}],cost = [{0,21030003,40}],skill_list = [803001,803101]};

get_fairy_stage(1003,2) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 2,attr = [{1,10400},{2,208000},{7,4160},{5,4160},{20,390}],cost = [{0,21030003,50}],skill_list = [803001,803101]};

get_fairy_stage(1003,3) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 3,attr = [{1,13600},{2,272000},{7,5440},{5,5440},{20,510}],cost = [{0,21030003,60}],skill_list = [803001,803002,803101]};

get_fairy_stage(1003,4) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 4,attr = [{1,16800},{2,336000},{7,6720},{5,6720},{20,630}],cost = [{0,21030003,80}],skill_list = [803001,803002,803101]};

get_fairy_stage(1003,5) ->
	#fairy_stage_cfg{fairy_id = 1003,stage = 5,attr = [{1,20000},{2,400000},{7,8000},{5,8000},{20,750}],cost = [{0,21030003,150}],skill_list = [803001,803002,803003,803101]};

get_fairy_stage(1004,0) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 0,attr = [{1,4000},{4,2000},{6,1600},{8,1600},{45,250}],cost = [{0,21030004,30}],skill_list = [804101]};

get_fairy_stage(1004,1) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 1,attr = [{1,7200},{4,3600},{6,2880},{8,2880},{45,450}],cost = [{0,21030004,40}],skill_list = [804001,804101]};

get_fairy_stage(1004,2) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 2,attr = [{1,10400},{4,5200},{6,4160},{8,4160},{45,650}],cost = [{0,21030004,50}],skill_list = [804001,804101]};

get_fairy_stage(1004,3) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 3,attr = [{1,13600},{4,6800},{6,5440},{8,5440},{45,850}],cost = [{0,21030004,60}],skill_list = [804001,804002,804101]};

get_fairy_stage(1004,4) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 4,attr = [{1,16800},{4,8400},{6,6720},{8,6720},{45,1050}],cost = [{0,21030004,80}],skill_list = [804001,804002,804101]};

get_fairy_stage(1004,5) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 5,attr = [{1,20000},{4,10000},{6,8000},{8,8000},{45,1250}],cost = [{0,21030004,150}],skill_list = [804001,804002,804003,804101]};

get_fairy_stage(1004,6) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 6,attr = [{1,23200},{4,11600},{6,9280},{8,9280},{45,1450}],cost = [{0,21030004,220}],skill_list = [804001,804002,804003,804101]};

get_fairy_stage(1004,7) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 7,attr = [{1,26400},{4,13200},{6,10560},{8,10560},{45,1650}],cost = [{0,21030004,300}],skill_list = [804001,804002,804003,804004,804101]};

get_fairy_stage(1004,8) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 8,attr = [{1,29600},{4,14800},{6,11840},{8,11840},{45,1850}],cost = [{0,21030004,380}],skill_list = [804001,804002,804003,804004,804101]};

get_fairy_stage(1004,9) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 9,attr = [{1,32800},{4,16400},{6,13120},{8,13120},{45,2050}],cost = [{0,21030004,500}],skill_list = [804001,804002,804003,804004,804101]};

get_fairy_stage(1004,10) ->
	#fairy_stage_cfg{fairy_id = 1004,stage = 10,attr = [{1,36000},{4,18000},{6,14400},{8,14400},{45,2250}],cost = [{0,21030004,650}],skill_list = [804001,804002,804003,804004,804101]};

get_fairy_stage(1005,0) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 0,attr = [{2,80000},{3,2000},{5,1600},{6,1600},{22,400}],cost = [{0,21030005,30}],skill_list = [805101]};

get_fairy_stage(1005,1) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 1,attr = [{2,144000},{3,3600},{5,2880},{6,2880},{22,720}],cost = [{0,21030005,40}],skill_list = [805001,805101]};

get_fairy_stage(1005,2) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 2,attr = [{2,208000},{3,5200},{5,4160},{6,4160},{22,1040}],cost = [{0,21030005,50}],skill_list = [805001,805101]};

get_fairy_stage(1005,3) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 3,attr = [{2,272000},{3,6800},{5,5440},{6,5440},{22,1360}],cost = [{0,21030005,60}],skill_list = [805001,805002,805101]};

get_fairy_stage(1005,4) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 4,attr = [{2,336000},{3,8400},{5,6720},{6,6720},{22,1680}],cost = [{0,21030005,80}],skill_list = [805001,805002,805101]};

get_fairy_stage(1005,5) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 5,attr = [{2,400000},{3,10000},{5,8000},{6,8000},{22,2000}],cost = [{0,21030005,150}],skill_list = [805001,805002,805003,805101]};

get_fairy_stage(1005,6) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 6,attr = [{2,464000},{3,11600},{5,9280},{6,9280},{22,2320}],cost = [{0,21030005,220}],skill_list = [805001,805002,805003,805101]};

get_fairy_stage(1005,7) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 7,attr = [{2,528000},{3,13200},{5,10560},{6,10560},{22,2640}],cost = [{0,21030005,300}],skill_list = [805001,805002,805003,805004,805101]};

get_fairy_stage(1005,8) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 8,attr = [{2,592000},{3,14800},{5,11840},{6,11840},{22,2960}],cost = [{0,21030005,380}],skill_list = [805001,805002,805003,805004,805101]};

get_fairy_stage(1005,9) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 9,attr = [{2,656000},{3,16400},{5,13120},{6,13120},{22,3280}],cost = [{0,21030005,500}],skill_list = [805001,805002,805003,805004,805101]};

get_fairy_stage(1005,10) ->
	#fairy_stage_cfg{fairy_id = 1005,stage = 10,attr = [{2,720000},{3,18000},{5,14400},{6,14400},{22,3600}],cost = [{0,21030005,650}],skill_list = [805001,805002,805003,805004,805101]};

get_fairy_stage(1006,0) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 0,attr = [{1,7000},{3,3500},{6,2800},{7,2800},{20,240}],cost = [{0,21030006,30}],skill_list = [806101]};

get_fairy_stage(1006,1) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 1,attr = [{1,12600},{3,6300},{6,5040},{7,5040},{20,432}],cost = [{0,21030006,30}],skill_list = [806001,806101]};

get_fairy_stage(1006,2) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 2,attr = [{1,18200},{3,9100},{6,7280},{7,7280},{20,624}],cost = [{0,21030006,35}],skill_list = [806001,806101]};

get_fairy_stage(1006,3) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 3,attr = [{1,23800},{3,11900},{6,9520},{7,9520},{20,816}],cost = [{0,21030006,40}],skill_list = [806001,806002,806101]};

get_fairy_stage(1006,4) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 4,attr = [{1,29400},{3,14700},{6,11760},{7,11760},{20,1008}],cost = [{0,21030006,50}],skill_list = [806001,806002,806101]};

get_fairy_stage(1006,5) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 5,attr = [{1,35000},{3,17500},{6,14000},{7,14000},{20,1200}],cost = [{0,21030006,60}],skill_list = [806001,806002,806003,806101]};

get_fairy_stage(1006,6) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 6,attr = [{1,40600},{3,20300},{6,16240},{7,16240},{20,1392}],cost = [{0,21030006,70}],skill_list = [806001,806002,806003,806101]};

get_fairy_stage(1006,7) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 7,attr = [{1,46200},{3,23100},{6,18480},{7,18480},{20,1584}],cost = [{0,21030006,80}],skill_list = [806001,806002,806003,806004,806101]};

get_fairy_stage(1006,8) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 8,attr = [{1,51800},{3,25900},{6,20720},{7,20720},{20,1776}],cost = [{0,21030006,90}],skill_list = [806001,806002,806003,806004,806101]};

get_fairy_stage(1006,9) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 9,attr = [{1,57400},{3,28700},{6,22960},{7,22960},{20,1968}],cost = [{0,21030006,100}],skill_list = [806001,806002,806003,806004,806101]};

get_fairy_stage(1006,10) ->
	#fairy_stage_cfg{fairy_id = 1006,stage = 10,attr = [{1,63000},{3,31500},{6,25200},{7,25200},{20,2160}],cost = [{0,21030006,110}],skill_list = [806001,806002,806003,806004,806101]};

get_fairy_stage(1007,0) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 0,attr = [{2,130000},{4,3250},{5,2600},{8,2600},{27,600}],cost = [{0,21030007,30}],skill_list = [807101]};

get_fairy_stage(1007,1) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 1,attr = [{2,234000},{4,5850},{5,4680},{8,4680},{27,1080}],cost = [{0,21030007,30}],skill_list = [807001,807101]};

get_fairy_stage(1007,2) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 2,attr = [{2,338000},{4,8450},{5,6760},{8,6760},{27,1560}],cost = [{0,21030007,35}],skill_list = [807001,807101]};

get_fairy_stage(1007,3) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 3,attr = [{2,442000},{4,11050},{5,8840},{8,8840},{27,2040}],cost = [{0,21030007,40}],skill_list = [807001,807002,807101]};

get_fairy_stage(1007,4) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 4,attr = [{2,546000},{4,13650},{5,10920},{8,10920},{27,2520}],cost = [{0,21030007,50}],skill_list = [807001,807002,807101]};

get_fairy_stage(1007,5) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 5,attr = [{2,650000},{4,16250},{5,13000},{8,13000},{27,3000}],cost = [{0,21030007,60}],skill_list = [807001,807002,807003,807101]};

get_fairy_stage(1007,6) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 6,attr = [{2,754000},{4,18850},{5,15080},{8,15080},{27,3480}],cost = [{0,21030007,70}],skill_list = [807001,807002,807003,807101]};

get_fairy_stage(1007,7) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 7,attr = [{2,858000},{4,21450},{5,17160},{8,17160},{27,3960}],cost = [{0,21030007,80}],skill_list = [807001,807002,807003,807004,807101]};

get_fairy_stage(1007,8) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 8,attr = [{2,962000},{4,24050},{5,19240},{8,19240},{27,4440}],cost = [{0,21030007,90}],skill_list = [807001,807002,807003,807004,807101]};

get_fairy_stage(1007,9) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 9,attr = [{2,1066000},{4,26650},{5,21320},{8,21320},{27,4920}],cost = [{0,21030007,100}],skill_list = [807001,807002,807003,807004,807101]};

get_fairy_stage(1007,10) ->
	#fairy_stage_cfg{fairy_id = 1007,stage = 10,attr = [{2,1170000},{4,29250},{5,23400},{8,23400},{27,5400}],cost = [{0,21030007,110}],skill_list = [807001,807002,807003,807004,807101]};

get_fairy_stage(1008,0) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 0,attr = [{3,4000},{4,4000},{5,3200},{8,3200},{28,750}],cost = [{0,21030008,30}],skill_list = [808101]};

get_fairy_stage(1008,1) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 1,attr = [{3,7200},{4,7200},{5,5760},{8,5760},{28,1350}],cost = [{0,21030008,30}],skill_list = [808001,808101]};

get_fairy_stage(1008,2) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 2,attr = [{3,10400},{4,10400},{5,8320},{8,8320},{28,1950}],cost = [{0,21030008,35}],skill_list = [808001,808101]};

get_fairy_stage(1008,3) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 3,attr = [{3,13600},{4,13600},{5,10880},{8,10880},{28,2550}],cost = [{0,21030008,40}],skill_list = [808001,808002,808101]};

get_fairy_stage(1008,4) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 4,attr = [{3,16800},{4,16800},{5,13440},{8,13440},{28,3150}],cost = [{0,21030008,50}],skill_list = [808001,808002,808101]};

get_fairy_stage(1008,5) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 5,attr = [{3,20000},{4,20000},{5,16000},{8,16000},{28,3750}],cost = [{0,21030008,60}],skill_list = [808001,808002,808003,808101]};

get_fairy_stage(1008,6) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 6,attr = [{3,23200},{4,23200},{5,18560},{8,18560},{28,4350}],cost = [{0,21030008,70}],skill_list = [808001,808002,808003,808101]};

get_fairy_stage(1008,7) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 7,attr = [{3,26400},{4,26400},{5,21120},{8,21120},{28,4950}],cost = [{0,21030008,80}],skill_list = [808001,808002,808003,808004,808101]};

get_fairy_stage(1008,8) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 8,attr = [{3,29600},{4,29600},{5,23680},{8,23680},{28,5550}],cost = [{0,21030008,90}],skill_list = [808001,808002,808003,808004,808101]};

get_fairy_stage(1008,9) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 9,attr = [{3,32800},{4,32800},{5,26240},{8,26240},{28,6150}],cost = [{0,21030008,100}],skill_list = [808001,808002,808003,808004,808101]};

get_fairy_stage(1008,10) ->
	#fairy_stage_cfg{fairy_id = 1008,stage = 10,attr = [{3,36000},{4,36000},{5,28800},{8,28800},{28,6750}],cost = [{0,21030008,110}],skill_list = [808001,808002,808003,808004,808101]};

get_fairy_stage(1009,0) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 0,attr = [{1,8000},{3,4000},{7,3200},{6,3200},{19,350}],cost = [{0,21030009,30}],skill_list = [809101]};

get_fairy_stage(1009,1) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 1,attr = [{1,14400},{3,7200},{7,5760},{6,5760},{19,630}],cost = [{0,21030009,30}],skill_list = [809001,809101]};

get_fairy_stage(1009,2) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 2,attr = [{1,20800},{3,10400},{7,8320},{6,8320},{19,910}],cost = [{0,21030009,35}],skill_list = [809001,809101]};

get_fairy_stage(1009,3) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 3,attr = [{1,27200},{3,13600},{7,10880},{6,10880},{19,1190}],cost = [{0,21030009,40}],skill_list = [809001,809002,809101]};

get_fairy_stage(1009,4) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 4,attr = [{1,33600},{3,16800},{7,13440},{6,13440},{19,1470}],cost = [{0,21030009,50}],skill_list = [809001,809002,809101]};

get_fairy_stage(1009,5) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 5,attr = [{1,40000},{3,20000},{7,16000},{6,16000},{19,1750}],cost = [{0,21030009,60}],skill_list = [809001,809002,809003,809101]};

get_fairy_stage(1009,6) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 6,attr = [{1,46400},{3,23200},{7,18560},{6,18560},{19,2030}],cost = [{0,21030009,70}],skill_list = [809001,809002,809003,809101]};

get_fairy_stage(1009,7) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 7,attr = [{1,52800},{3,26400},{7,21120},{6,21120},{19,2310}],cost = [{0,21030009,80}],skill_list = [809001,809002,809003,809004,809101]};

get_fairy_stage(1009,8) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 8,attr = [{1,59200},{3,29600},{7,23680},{6,23680},{19,2590}],cost = [{0,21030009,90}],skill_list = [809001,809002,809003,809004,809101]};

get_fairy_stage(1009,9) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 9,attr = [{1,65600},{3,32800},{7,26240},{6,26240},{19,2870}],cost = [{0,21030009,100}],skill_list = [809001,809002,809003,809004,809101]};

get_fairy_stage(1009,10) ->
	#fairy_stage_cfg{fairy_id = 1009,stage = 10,attr = [{1,72000},{3,36000},{7,28800},{6,28800},{19,3150}],cost = [{0,21030009,110}],skill_list = [809001,809002,809003,809004,809101]};

get_fairy_stage(_Fairyid,_Stage) ->
	[].

get_all_lev_goods() ->
[21020001,21020002,21020003].


get_fairy_prop(21020001) ->
10;


get_fairy_prop(21020002) ->
50;


get_fairy_prop(21020003) ->
100;

get_fairy_prop(_Goodsid) ->
	[].

get_fairy_level(1001,0) ->
	#fairy_level_cfg{fairy_id = 1001,level = 0,attr = [{3,0},{4,0},{6,0},{7,0}],exp = 10};

get_fairy_level(1001,1) ->
	#fairy_level_cfg{fairy_id = 1001,level = 1,attr = [{3,20},{4,20},{6,16},{7,16}],exp = 11};

get_fairy_level(1001,2) ->
	#fairy_level_cfg{fairy_id = 1001,level = 2,attr = [{3,40},{4,40},{6,32},{7,32}],exp = 12};

get_fairy_level(1001,3) ->
	#fairy_level_cfg{fairy_id = 1001,level = 3,attr = [{3,60},{4,60},{6,48},{7,48}],exp = 14};

get_fairy_level(1001,4) ->
	#fairy_level_cfg{fairy_id = 1001,level = 4,attr = [{3,80},{4,80},{6,64},{7,64}],exp = 16};

get_fairy_level(1001,5) ->
	#fairy_level_cfg{fairy_id = 1001,level = 5,attr = [{3,100},{4,100},{6,80},{7,80}],exp = 18};

get_fairy_level(1001,6) ->
	#fairy_level_cfg{fairy_id = 1001,level = 6,attr = [{3,120},{4,120},{6,96},{7,96}],exp = 20};

get_fairy_level(1001,7) ->
	#fairy_level_cfg{fairy_id = 1001,level = 7,attr = [{3,140},{4,140},{6,112},{7,112}],exp = 23};

get_fairy_level(1001,8) ->
	#fairy_level_cfg{fairy_id = 1001,level = 8,attr = [{3,160},{4,160},{6,128},{7,128}],exp = 26};

get_fairy_level(1001,9) ->
	#fairy_level_cfg{fairy_id = 1001,level = 9,attr = [{3,180},{4,180},{6,144},{7,144}],exp = 29};

get_fairy_level(1001,10) ->
	#fairy_level_cfg{fairy_id = 1001,level = 10,attr = [{3,200},{4,200},{6,160},{7,160}],exp = 32};

get_fairy_level(1001,11) ->
	#fairy_level_cfg{fairy_id = 1001,level = 11,attr = [{3,220},{4,220},{6,176},{7,176}],exp = 35};

get_fairy_level(1001,12) ->
	#fairy_level_cfg{fairy_id = 1001,level = 12,attr = [{3,240},{4,240},{6,192},{7,192}],exp = 39};

get_fairy_level(1001,13) ->
	#fairy_level_cfg{fairy_id = 1001,level = 13,attr = [{3,260},{4,260},{6,208},{7,208}],exp = 43};

get_fairy_level(1001,14) ->
	#fairy_level_cfg{fairy_id = 1001,level = 14,attr = [{3,280},{4,280},{6,224},{7,224}],exp = 47};

get_fairy_level(1001,15) ->
	#fairy_level_cfg{fairy_id = 1001,level = 15,attr = [{3,300},{4,300},{6,240},{7,240}],exp = 52};

get_fairy_level(1001,16) ->
	#fairy_level_cfg{fairy_id = 1001,level = 16,attr = [{3,320},{4,320},{6,256},{7,256}],exp = 57};

get_fairy_level(1001,17) ->
	#fairy_level_cfg{fairy_id = 1001,level = 17,attr = [{3,340},{4,340},{6,272},{7,272}],exp = 63};

get_fairy_level(1001,18) ->
	#fairy_level_cfg{fairy_id = 1001,level = 18,attr = [{3,360},{4,360},{6,288},{7,288}],exp = 69};

get_fairy_level(1001,19) ->
	#fairy_level_cfg{fairy_id = 1001,level = 19,attr = [{3,380},{4,380},{6,304},{7,304}],exp = 76};

get_fairy_level(1001,20) ->
	#fairy_level_cfg{fairy_id = 1001,level = 20,attr = [{3,400},{4,400},{6,320},{7,320}],exp = 82};

get_fairy_level(1001,21) ->
	#fairy_level_cfg{fairy_id = 1001,level = 21,attr = [{3,420},{4,420},{6,336},{7,336}],exp = 89};

get_fairy_level(1001,22) ->
	#fairy_level_cfg{fairy_id = 1001,level = 22,attr = [{3,440},{4,440},{6,352},{7,352}],exp = 96};

get_fairy_level(1001,23) ->
	#fairy_level_cfg{fairy_id = 1001,level = 23,attr = [{3,460},{4,460},{6,368},{7,368}],exp = 104};

get_fairy_level(1001,24) ->
	#fairy_level_cfg{fairy_id = 1001,level = 24,attr = [{3,480},{4,480},{6,384},{7,384}],exp = 113};

get_fairy_level(1001,25) ->
	#fairy_level_cfg{fairy_id = 1001,level = 25,attr = [{3,500},{4,500},{6,400},{7,400}],exp = 122};

get_fairy_level(1001,26) ->
	#fairy_level_cfg{fairy_id = 1001,level = 26,attr = [{3,520},{4,520},{6,416},{7,416}],exp = 132};

get_fairy_level(1001,27) ->
	#fairy_level_cfg{fairy_id = 1001,level = 27,attr = [{3,540},{4,540},{6,432},{7,432}],exp = 143};

get_fairy_level(1001,28) ->
	#fairy_level_cfg{fairy_id = 1001,level = 28,attr = [{3,560},{4,560},{6,448},{7,448}],exp = 155};

get_fairy_level(1001,29) ->
	#fairy_level_cfg{fairy_id = 1001,level = 29,attr = [{3,580},{4,580},{6,464},{7,464}],exp = 168};

get_fairy_level(1001,30) ->
	#fairy_level_cfg{fairy_id = 1001,level = 30,attr = [{3,600},{4,600},{6,480},{7,480}],exp = 179};

get_fairy_level(1001,31) ->
	#fairy_level_cfg{fairy_id = 1001,level = 31,attr = [{3,620},{4,620},{6,496},{7,496}],exp = 190};

get_fairy_level(1001,32) ->
	#fairy_level_cfg{fairy_id = 1001,level = 32,attr = [{3,640},{4,640},{6,512},{7,512}],exp = 202};

get_fairy_level(1001,33) ->
	#fairy_level_cfg{fairy_id = 1001,level = 33,attr = [{3,660},{4,660},{6,528},{7,528}],exp = 215};

get_fairy_level(1001,34) ->
	#fairy_level_cfg{fairy_id = 1001,level = 34,attr = [{3,680},{4,680},{6,544},{7,544}],exp = 228};

get_fairy_level(1001,35) ->
	#fairy_level_cfg{fairy_id = 1001,level = 35,attr = [{3,700},{4,700},{6,560},{7,560}],exp = 242};

get_fairy_level(1001,36) ->
	#fairy_level_cfg{fairy_id = 1001,level = 36,attr = [{3,720},{4,720},{6,576},{7,576}],exp = 257};

get_fairy_level(1001,37) ->
	#fairy_level_cfg{fairy_id = 1001,level = 37,attr = [{3,740},{4,740},{6,592},{7,592}],exp = 273};

get_fairy_level(1001,38) ->
	#fairy_level_cfg{fairy_id = 1001,level = 38,attr = [{3,760},{4,760},{6,608},{7,608}],exp = 290};

get_fairy_level(1001,39) ->
	#fairy_level_cfg{fairy_id = 1001,level = 39,attr = [{3,780},{4,780},{6,624},{7,624}],exp = 308};

get_fairy_level(1001,40) ->
	#fairy_level_cfg{fairy_id = 1001,level = 40,attr = [{3,800},{4,800},{6,640},{7,640}],exp = 323};

get_fairy_level(1001,41) ->
	#fairy_level_cfg{fairy_id = 1001,level = 41,attr = [{3,820},{4,820},{6,656},{7,656}],exp = 339};

get_fairy_level(1001,42) ->
	#fairy_level_cfg{fairy_id = 1001,level = 42,attr = [{3,840},{4,840},{6,672},{7,672}],exp = 356};

get_fairy_level(1001,43) ->
	#fairy_level_cfg{fairy_id = 1001,level = 43,attr = [{3,860},{4,860},{6,688},{7,688}],exp = 374};

get_fairy_level(1001,44) ->
	#fairy_level_cfg{fairy_id = 1001,level = 44,attr = [{3,880},{4,880},{6,704},{7,704}],exp = 393};

get_fairy_level(1001,45) ->
	#fairy_level_cfg{fairy_id = 1001,level = 45,attr = [{3,900},{4,900},{6,720},{7,720}],exp = 413};

get_fairy_level(1001,46) ->
	#fairy_level_cfg{fairy_id = 1001,level = 46,attr = [{3,920},{4,920},{6,736},{7,736}],exp = 434};

get_fairy_level(1001,47) ->
	#fairy_level_cfg{fairy_id = 1001,level = 47,attr = [{3,940},{4,940},{6,752},{7,752}],exp = 456};

get_fairy_level(1001,48) ->
	#fairy_level_cfg{fairy_id = 1001,level = 48,attr = [{3,960},{4,960},{6,768},{7,768}],exp = 479};

get_fairy_level(1001,49) ->
	#fairy_level_cfg{fairy_id = 1001,level = 49,attr = [{3,980},{4,980},{6,784},{7,784}],exp = 503};

get_fairy_level(1001,50) ->
	#fairy_level_cfg{fairy_id = 1001,level = 50,attr = [{3,1000},{4,1000},{6,800},{7,800}],exp = 522};

get_fairy_level(1001,51) ->
	#fairy_level_cfg{fairy_id = 1001,level = 51,attr = [{3,1020},{4,1020},{6,816},{7,816}],exp = 542};

get_fairy_level(1001,52) ->
	#fairy_level_cfg{fairy_id = 1001,level = 52,attr = [{3,1040},{4,1040},{6,832},{7,832}],exp = 563};

get_fairy_level(1001,53) ->
	#fairy_level_cfg{fairy_id = 1001,level = 53,attr = [{3,1060},{4,1060},{6,848},{7,848}],exp = 585};

get_fairy_level(1001,54) ->
	#fairy_level_cfg{fairy_id = 1001,level = 54,attr = [{3,1080},{4,1080},{6,864},{7,864}],exp = 608};

get_fairy_level(1001,55) ->
	#fairy_level_cfg{fairy_id = 1001,level = 55,attr = [{3,1100},{4,1100},{6,880},{7,880}],exp = 631};

get_fairy_level(1001,56) ->
	#fairy_level_cfg{fairy_id = 1001,level = 56,attr = [{3,1120},{4,1120},{6,896},{7,896}],exp = 655};

get_fairy_level(1001,57) ->
	#fairy_level_cfg{fairy_id = 1001,level = 57,attr = [{3,1140},{4,1140},{6,912},{7,912}],exp = 680};

get_fairy_level(1001,58) ->
	#fairy_level_cfg{fairy_id = 1001,level = 58,attr = [{3,1160},{4,1160},{6,928},{7,928}],exp = 706};

get_fairy_level(1001,59) ->
	#fairy_level_cfg{fairy_id = 1001,level = 59,attr = [{3,1180},{4,1180},{6,944},{7,944}],exp = 733};

get_fairy_level(1001,60) ->
	#fairy_level_cfg{fairy_id = 1001,level = 60,attr = [{3,1200},{4,1200},{6,960},{7,960}],exp = 756};

get_fairy_level(1001,61) ->
	#fairy_level_cfg{fairy_id = 1001,level = 61,attr = [{3,1220},{4,1220},{6,976},{7,976}],exp = 780};

get_fairy_level(1001,62) ->
	#fairy_level_cfg{fairy_id = 1001,level = 62,attr = [{3,1240},{4,1240},{6,992},{7,992}],exp = 804};

get_fairy_level(1001,63) ->
	#fairy_level_cfg{fairy_id = 1001,level = 63,attr = [{3,1260},{4,1260},{6,1008},{7,1008}],exp = 829};

get_fairy_level(1001,64) ->
	#fairy_level_cfg{fairy_id = 1001,level = 64,attr = [{3,1280},{4,1280},{6,1024},{7,1024}],exp = 855};

get_fairy_level(1001,65) ->
	#fairy_level_cfg{fairy_id = 1001,level = 65,attr = [{3,1300},{4,1300},{6,1040},{7,1040}],exp = 882};

get_fairy_level(1001,66) ->
	#fairy_level_cfg{fairy_id = 1001,level = 66,attr = [{3,1320},{4,1320},{6,1056},{7,1056}],exp = 910};

get_fairy_level(1001,67) ->
	#fairy_level_cfg{fairy_id = 1001,level = 67,attr = [{3,1340},{4,1340},{6,1072},{7,1072}],exp = 938};

get_fairy_level(1001,68) ->
	#fairy_level_cfg{fairy_id = 1001,level = 68,attr = [{3,1360},{4,1360},{6,1088},{7,1088}],exp = 967};

get_fairy_level(1001,69) ->
	#fairy_level_cfg{fairy_id = 1001,level = 69,attr = [{3,1380},{4,1380},{6,1104},{7,1104}],exp = 997};

get_fairy_level(1001,70) ->
	#fairy_level_cfg{fairy_id = 1001,level = 70,attr = [{3,1400},{4,1400},{6,1120},{7,1120}],exp = 1023};

get_fairy_level(1001,71) ->
	#fairy_level_cfg{fairy_id = 1001,level = 71,attr = [{3,1420},{4,1420},{6,1136},{7,1136}],exp = 1050};

get_fairy_level(1001,72) ->
	#fairy_level_cfg{fairy_id = 1001,level = 72,attr = [{3,1440},{4,1440},{6,1152},{7,1152}],exp = 1078};

get_fairy_level(1001,73) ->
	#fairy_level_cfg{fairy_id = 1001,level = 73,attr = [{3,1460},{4,1460},{6,1168},{7,1168}],exp = 1106};

get_fairy_level(1001,74) ->
	#fairy_level_cfg{fairy_id = 1001,level = 74,attr = [{3,1480},{4,1480},{6,1184},{7,1184}],exp = 1135};

get_fairy_level(1001,75) ->
	#fairy_level_cfg{fairy_id = 1001,level = 75,attr = [{3,1500},{4,1500},{6,1200},{7,1200}],exp = 1165};

get_fairy_level(1001,76) ->
	#fairy_level_cfg{fairy_id = 1001,level = 76,attr = [{3,1520},{4,1520},{6,1216},{7,1216}],exp = 1196};

get_fairy_level(1001,77) ->
	#fairy_level_cfg{fairy_id = 1001,level = 77,attr = [{3,1540},{4,1540},{6,1232},{7,1232}],exp = 1227};

get_fairy_level(1001,78) ->
	#fairy_level_cfg{fairy_id = 1001,level = 78,attr = [{3,1560},{4,1560},{6,1248},{7,1248}],exp = 1259};

get_fairy_level(1001,79) ->
	#fairy_level_cfg{fairy_id = 1001,level = 79,attr = [{3,1580},{4,1580},{6,1264},{7,1264}],exp = 1292};

get_fairy_level(1001,80) ->
	#fairy_level_cfg{fairy_id = 1001,level = 80,attr = [{3,1600},{4,1600},{6,1280},{7,1280}],exp = 1320};

get_fairy_level(1001,81) ->
	#fairy_level_cfg{fairy_id = 1001,level = 81,attr = [{3,1620},{4,1620},{6,1296},{7,1296}],exp = 1349};

get_fairy_level(1001,82) ->
	#fairy_level_cfg{fairy_id = 1001,level = 82,attr = [{3,1640},{4,1640},{6,1312},{7,1312}],exp = 1378};

get_fairy_level(1001,83) ->
	#fairy_level_cfg{fairy_id = 1001,level = 83,attr = [{3,1660},{4,1660},{6,1328},{7,1328}],exp = 1408};

get_fairy_level(1001,84) ->
	#fairy_level_cfg{fairy_id = 1001,level = 84,attr = [{3,1680},{4,1680},{6,1344},{7,1344}],exp = 1439};

get_fairy_level(1001,85) ->
	#fairy_level_cfg{fairy_id = 1001,level = 85,attr = [{3,1700},{4,1700},{6,1360},{7,1360}],exp = 1470};

get_fairy_level(1001,86) ->
	#fairy_level_cfg{fairy_id = 1001,level = 86,attr = [{3,1720},{4,1720},{6,1376},{7,1376}],exp = 1502};

get_fairy_level(1001,87) ->
	#fairy_level_cfg{fairy_id = 1001,level = 87,attr = [{3,1740},{4,1740},{6,1392},{7,1392}],exp = 1535};

get_fairy_level(1001,88) ->
	#fairy_level_cfg{fairy_id = 1001,level = 88,attr = [{3,1760},{4,1760},{6,1408},{7,1408}],exp = 1568};

get_fairy_level(1001,89) ->
	#fairy_level_cfg{fairy_id = 1001,level = 89,attr = [{3,1780},{4,1780},{6,1424},{7,1424}],exp = 1602};

get_fairy_level(1001,90) ->
	#fairy_level_cfg{fairy_id = 1001,level = 90,attr = [{3,1800},{4,1800},{6,1440},{7,1440}],exp = 1632};

get_fairy_level(1001,91) ->
	#fairy_level_cfg{fairy_id = 1001,level = 91,attr = [{3,1820},{4,1820},{6,1456},{7,1456}],exp = 1662};

get_fairy_level(1001,92) ->
	#fairy_level_cfg{fairy_id = 1001,level = 92,attr = [{3,1840},{4,1840},{6,1472},{7,1472}],exp = 1693};

get_fairy_level(1001,93) ->
	#fairy_level_cfg{fairy_id = 1001,level = 93,attr = [{3,1860},{4,1860},{6,1488},{7,1488}],exp = 1724};

get_fairy_level(1001,94) ->
	#fairy_level_cfg{fairy_id = 1001,level = 94,attr = [{3,1880},{4,1880},{6,1504},{7,1504}],exp = 1756};

get_fairy_level(1001,95) ->
	#fairy_level_cfg{fairy_id = 1001,level = 95,attr = [{3,1900},{4,1900},{6,1520},{7,1520}],exp = 1789};

get_fairy_level(1001,96) ->
	#fairy_level_cfg{fairy_id = 1001,level = 96,attr = [{3,1920},{4,1920},{6,1536},{7,1536}],exp = 1822};

get_fairy_level(1001,97) ->
	#fairy_level_cfg{fairy_id = 1001,level = 97,attr = [{3,1940},{4,1940},{6,1552},{7,1552}],exp = 1856};

get_fairy_level(1001,98) ->
	#fairy_level_cfg{fairy_id = 1001,level = 98,attr = [{3,1960},{4,1960},{6,1568},{7,1568}],exp = 1890};

get_fairy_level(1001,99) ->
	#fairy_level_cfg{fairy_id = 1001,level = 99,attr = [{3,1980},{4,1980},{6,1584},{7,1584}],exp = 1925};

get_fairy_level(1001,100) ->
	#fairy_level_cfg{fairy_id = 1001,level = 100,attr = [{3,2000},{4,2000},{6,1600},{7,1600}],exp = 0};

get_fairy_level(1002,0) ->
	#fairy_level_cfg{fairy_id = 1002,level = 0,attr = [{2,0},{4,0},{5,0},{8,0}],exp = 10};

get_fairy_level(1002,1) ->
	#fairy_level_cfg{fairy_id = 1002,level = 1,attr = [{2,400},{4,20},{5,16},{8,16}],exp = 11};

get_fairy_level(1002,2) ->
	#fairy_level_cfg{fairy_id = 1002,level = 2,attr = [{2,800},{4,40},{5,32},{8,32}],exp = 12};

get_fairy_level(1002,3) ->
	#fairy_level_cfg{fairy_id = 1002,level = 3,attr = [{2,1200},{4,60},{5,48},{8,48}],exp = 14};

get_fairy_level(1002,4) ->
	#fairy_level_cfg{fairy_id = 1002,level = 4,attr = [{2,1600},{4,80},{5,64},{8,64}],exp = 16};

get_fairy_level(1002,5) ->
	#fairy_level_cfg{fairy_id = 1002,level = 5,attr = [{2,2000},{4,100},{5,80},{8,80}],exp = 18};

get_fairy_level(1002,6) ->
	#fairy_level_cfg{fairy_id = 1002,level = 6,attr = [{2,2400},{4,120},{5,96},{8,96}],exp = 20};

get_fairy_level(1002,7) ->
	#fairy_level_cfg{fairy_id = 1002,level = 7,attr = [{2,2800},{4,140},{5,112},{8,112}],exp = 23};

get_fairy_level(1002,8) ->
	#fairy_level_cfg{fairy_id = 1002,level = 8,attr = [{2,3200},{4,160},{5,128},{8,128}],exp = 26};

get_fairy_level(1002,9) ->
	#fairy_level_cfg{fairy_id = 1002,level = 9,attr = [{2,3600},{4,180},{5,144},{8,144}],exp = 29};

get_fairy_level(1002,10) ->
	#fairy_level_cfg{fairy_id = 1002,level = 10,attr = [{2,4000},{4,200},{5,160},{8,160}],exp = 32};

get_fairy_level(1002,11) ->
	#fairy_level_cfg{fairy_id = 1002,level = 11,attr = [{2,4400},{4,220},{5,176},{8,176}],exp = 35};

get_fairy_level(1002,12) ->
	#fairy_level_cfg{fairy_id = 1002,level = 12,attr = [{2,4800},{4,240},{5,192},{8,192}],exp = 39};

get_fairy_level(1002,13) ->
	#fairy_level_cfg{fairy_id = 1002,level = 13,attr = [{2,5200},{4,260},{5,208},{8,208}],exp = 43};

get_fairy_level(1002,14) ->
	#fairy_level_cfg{fairy_id = 1002,level = 14,attr = [{2,5600},{4,280},{5,224},{8,224}],exp = 47};

get_fairy_level(1002,15) ->
	#fairy_level_cfg{fairy_id = 1002,level = 15,attr = [{2,6000},{4,300},{5,240},{8,240}],exp = 52};

get_fairy_level(1002,16) ->
	#fairy_level_cfg{fairy_id = 1002,level = 16,attr = [{2,6400},{4,320},{5,256},{8,256}],exp = 57};

get_fairy_level(1002,17) ->
	#fairy_level_cfg{fairy_id = 1002,level = 17,attr = [{2,6800},{4,340},{5,272},{8,272}],exp = 63};

get_fairy_level(1002,18) ->
	#fairy_level_cfg{fairy_id = 1002,level = 18,attr = [{2,7200},{4,360},{5,288},{8,288}],exp = 69};

get_fairy_level(1002,19) ->
	#fairy_level_cfg{fairy_id = 1002,level = 19,attr = [{2,7600},{4,380},{5,304},{8,304}],exp = 76};

get_fairy_level(1002,20) ->
	#fairy_level_cfg{fairy_id = 1002,level = 20,attr = [{2,8000},{4,400},{5,320},{8,320}],exp = 82};

get_fairy_level(1002,21) ->
	#fairy_level_cfg{fairy_id = 1002,level = 21,attr = [{2,8400},{4,420},{5,336},{8,336}],exp = 89};

get_fairy_level(1002,22) ->
	#fairy_level_cfg{fairy_id = 1002,level = 22,attr = [{2,8800},{4,440},{5,352},{8,352}],exp = 96};

get_fairy_level(1002,23) ->
	#fairy_level_cfg{fairy_id = 1002,level = 23,attr = [{2,9200},{4,460},{5,368},{8,368}],exp = 104};

get_fairy_level(1002,24) ->
	#fairy_level_cfg{fairy_id = 1002,level = 24,attr = [{2,9600},{4,480},{5,384},{8,384}],exp = 113};

get_fairy_level(1002,25) ->
	#fairy_level_cfg{fairy_id = 1002,level = 25,attr = [{2,10000},{4,500},{5,400},{8,400}],exp = 122};

get_fairy_level(1002,26) ->
	#fairy_level_cfg{fairy_id = 1002,level = 26,attr = [{2,10400},{4,520},{5,416},{8,416}],exp = 132};

get_fairy_level(1002,27) ->
	#fairy_level_cfg{fairy_id = 1002,level = 27,attr = [{2,10800},{4,540},{5,432},{8,432}],exp = 143};

get_fairy_level(1002,28) ->
	#fairy_level_cfg{fairy_id = 1002,level = 28,attr = [{2,11200},{4,560},{5,448},{8,448}],exp = 155};

get_fairy_level(1002,29) ->
	#fairy_level_cfg{fairy_id = 1002,level = 29,attr = [{2,11600},{4,580},{5,464},{8,464}],exp = 168};

get_fairy_level(1002,30) ->
	#fairy_level_cfg{fairy_id = 1002,level = 30,attr = [{2,12000},{4,600},{5,480},{8,480}],exp = 179};

get_fairy_level(1002,31) ->
	#fairy_level_cfg{fairy_id = 1002,level = 31,attr = [{2,12400},{4,620},{5,496},{8,496}],exp = 190};

get_fairy_level(1002,32) ->
	#fairy_level_cfg{fairy_id = 1002,level = 32,attr = [{2,12800},{4,640},{5,512},{8,512}],exp = 202};

get_fairy_level(1002,33) ->
	#fairy_level_cfg{fairy_id = 1002,level = 33,attr = [{2,13200},{4,660},{5,528},{8,528}],exp = 215};

get_fairy_level(1002,34) ->
	#fairy_level_cfg{fairy_id = 1002,level = 34,attr = [{2,13600},{4,680},{5,544},{8,544}],exp = 228};

get_fairy_level(1002,35) ->
	#fairy_level_cfg{fairy_id = 1002,level = 35,attr = [{2,14000},{4,700},{5,560},{8,560}],exp = 242};

get_fairy_level(1002,36) ->
	#fairy_level_cfg{fairy_id = 1002,level = 36,attr = [{2,14400},{4,720},{5,576},{8,576}],exp = 257};

get_fairy_level(1002,37) ->
	#fairy_level_cfg{fairy_id = 1002,level = 37,attr = [{2,14800},{4,740},{5,592},{8,592}],exp = 273};

get_fairy_level(1002,38) ->
	#fairy_level_cfg{fairy_id = 1002,level = 38,attr = [{2,15200},{4,760},{5,608},{8,608}],exp = 290};

get_fairy_level(1002,39) ->
	#fairy_level_cfg{fairy_id = 1002,level = 39,attr = [{2,15600},{4,780},{5,624},{8,624}],exp = 308};

get_fairy_level(1002,40) ->
	#fairy_level_cfg{fairy_id = 1002,level = 40,attr = [{2,16000},{4,800},{5,640},{8,640}],exp = 323};

get_fairy_level(1002,41) ->
	#fairy_level_cfg{fairy_id = 1002,level = 41,attr = [{2,16400},{4,820},{5,656},{8,656}],exp = 339};

get_fairy_level(1002,42) ->
	#fairy_level_cfg{fairy_id = 1002,level = 42,attr = [{2,16800},{4,840},{5,672},{8,672}],exp = 356};

get_fairy_level(1002,43) ->
	#fairy_level_cfg{fairy_id = 1002,level = 43,attr = [{2,17200},{4,860},{5,688},{8,688}],exp = 374};

get_fairy_level(1002,44) ->
	#fairy_level_cfg{fairy_id = 1002,level = 44,attr = [{2,17600},{4,880},{5,704},{8,704}],exp = 393};

get_fairy_level(1002,45) ->
	#fairy_level_cfg{fairy_id = 1002,level = 45,attr = [{2,18000},{4,900},{5,720},{8,720}],exp = 413};

get_fairy_level(1002,46) ->
	#fairy_level_cfg{fairy_id = 1002,level = 46,attr = [{2,18400},{4,920},{5,736},{8,736}],exp = 434};

get_fairy_level(1002,47) ->
	#fairy_level_cfg{fairy_id = 1002,level = 47,attr = [{2,18800},{4,940},{5,752},{8,752}],exp = 456};

get_fairy_level(1002,48) ->
	#fairy_level_cfg{fairy_id = 1002,level = 48,attr = [{2,19200},{4,960},{5,768},{8,768}],exp = 479};

get_fairy_level(1002,49) ->
	#fairy_level_cfg{fairy_id = 1002,level = 49,attr = [{2,19600},{4,980},{5,784},{8,784}],exp = 503};

get_fairy_level(1002,50) ->
	#fairy_level_cfg{fairy_id = 1002,level = 50,attr = [{2,20000},{4,1000},{5,800},{8,800}],exp = 522};

get_fairy_level(1002,51) ->
	#fairy_level_cfg{fairy_id = 1002,level = 51,attr = [{2,20400},{4,1020},{5,816},{8,816}],exp = 542};

get_fairy_level(1002,52) ->
	#fairy_level_cfg{fairy_id = 1002,level = 52,attr = [{2,20800},{4,1040},{5,832},{8,832}],exp = 563};

get_fairy_level(1002,53) ->
	#fairy_level_cfg{fairy_id = 1002,level = 53,attr = [{2,21200},{4,1060},{5,848},{8,848}],exp = 585};

get_fairy_level(1002,54) ->
	#fairy_level_cfg{fairy_id = 1002,level = 54,attr = [{2,21600},{4,1080},{5,864},{8,864}],exp = 608};

get_fairy_level(1002,55) ->
	#fairy_level_cfg{fairy_id = 1002,level = 55,attr = [{2,22000},{4,1100},{5,880},{8,880}],exp = 631};

get_fairy_level(1002,56) ->
	#fairy_level_cfg{fairy_id = 1002,level = 56,attr = [{2,22400},{4,1120},{5,896},{8,896}],exp = 655};

get_fairy_level(1002,57) ->
	#fairy_level_cfg{fairy_id = 1002,level = 57,attr = [{2,22800},{4,1140},{5,912},{8,912}],exp = 680};

get_fairy_level(1002,58) ->
	#fairy_level_cfg{fairy_id = 1002,level = 58,attr = [{2,23200},{4,1160},{5,928},{8,928}],exp = 706};

get_fairy_level(1002,59) ->
	#fairy_level_cfg{fairy_id = 1002,level = 59,attr = [{2,23600},{4,1180},{5,944},{8,944}],exp = 733};

get_fairy_level(1002,60) ->
	#fairy_level_cfg{fairy_id = 1002,level = 60,attr = [{2,24000},{4,1200},{5,960},{8,960}],exp = 756};

get_fairy_level(1002,61) ->
	#fairy_level_cfg{fairy_id = 1002,level = 61,attr = [{2,24400},{4,1220},{5,976},{8,976}],exp = 780};

get_fairy_level(1002,62) ->
	#fairy_level_cfg{fairy_id = 1002,level = 62,attr = [{2,24800},{4,1240},{5,992},{8,992}],exp = 804};

get_fairy_level(1002,63) ->
	#fairy_level_cfg{fairy_id = 1002,level = 63,attr = [{2,25200},{4,1260},{5,1008},{8,1008}],exp = 829};

get_fairy_level(1002,64) ->
	#fairy_level_cfg{fairy_id = 1002,level = 64,attr = [{2,25600},{4,1280},{5,1024},{8,1024}],exp = 855};

get_fairy_level(1002,65) ->
	#fairy_level_cfg{fairy_id = 1002,level = 65,attr = [{2,26000},{4,1300},{5,1040},{8,1040}],exp = 882};

get_fairy_level(1002,66) ->
	#fairy_level_cfg{fairy_id = 1002,level = 66,attr = [{2,26400},{4,1320},{5,1056},{8,1056}],exp = 910};

get_fairy_level(1002,67) ->
	#fairy_level_cfg{fairy_id = 1002,level = 67,attr = [{2,26800},{4,1340},{5,1072},{8,1072}],exp = 938};

get_fairy_level(1002,68) ->
	#fairy_level_cfg{fairy_id = 1002,level = 68,attr = [{2,27200},{4,1360},{5,1088},{8,1088}],exp = 967};

get_fairy_level(1002,69) ->
	#fairy_level_cfg{fairy_id = 1002,level = 69,attr = [{2,27600},{4,1380},{5,1104},{8,1104}],exp = 997};

get_fairy_level(1002,70) ->
	#fairy_level_cfg{fairy_id = 1002,level = 70,attr = [{2,28000},{4,1400},{5,1120},{8,1120}],exp = 1023};

get_fairy_level(1002,71) ->
	#fairy_level_cfg{fairy_id = 1002,level = 71,attr = [{2,28400},{4,1420},{5,1136},{8,1136}],exp = 1050};

get_fairy_level(1002,72) ->
	#fairy_level_cfg{fairy_id = 1002,level = 72,attr = [{2,28800},{4,1440},{5,1152},{8,1152}],exp = 1078};

get_fairy_level(1002,73) ->
	#fairy_level_cfg{fairy_id = 1002,level = 73,attr = [{2,29200},{4,1460},{5,1168},{8,1168}],exp = 1106};

get_fairy_level(1002,74) ->
	#fairy_level_cfg{fairy_id = 1002,level = 74,attr = [{2,29600},{4,1480},{5,1184},{8,1184}],exp = 1135};

get_fairy_level(1002,75) ->
	#fairy_level_cfg{fairy_id = 1002,level = 75,attr = [{2,30000},{4,1500},{5,1200},{8,1200}],exp = 1165};

get_fairy_level(1002,76) ->
	#fairy_level_cfg{fairy_id = 1002,level = 76,attr = [{2,30400},{4,1520},{5,1216},{8,1216}],exp = 1196};

get_fairy_level(1002,77) ->
	#fairy_level_cfg{fairy_id = 1002,level = 77,attr = [{2,30800},{4,1540},{5,1232},{8,1232}],exp = 1227};

get_fairy_level(1002,78) ->
	#fairy_level_cfg{fairy_id = 1002,level = 78,attr = [{2,31200},{4,1560},{5,1248},{8,1248}],exp = 1259};

get_fairy_level(1002,79) ->
	#fairy_level_cfg{fairy_id = 1002,level = 79,attr = [{2,31600},{4,1580},{5,1264},{8,1264}],exp = 1292};

get_fairy_level(1002,80) ->
	#fairy_level_cfg{fairy_id = 1002,level = 80,attr = [{2,32000},{4,1600},{5,1280},{8,1280}],exp = 1320};

get_fairy_level(1002,81) ->
	#fairy_level_cfg{fairy_id = 1002,level = 81,attr = [{2,32400},{4,1620},{5,1296},{8,1296}],exp = 1349};

get_fairy_level(1002,82) ->
	#fairy_level_cfg{fairy_id = 1002,level = 82,attr = [{2,32800},{4,1640},{5,1312},{8,1312}],exp = 1378};

get_fairy_level(1002,83) ->
	#fairy_level_cfg{fairy_id = 1002,level = 83,attr = [{2,33200},{4,1660},{5,1328},{8,1328}],exp = 1408};

get_fairy_level(1002,84) ->
	#fairy_level_cfg{fairy_id = 1002,level = 84,attr = [{2,33600},{4,1680},{5,1344},{8,1344}],exp = 1439};

get_fairy_level(1002,85) ->
	#fairy_level_cfg{fairy_id = 1002,level = 85,attr = [{2,34000},{4,1700},{5,1360},{8,1360}],exp = 1470};

get_fairy_level(1002,86) ->
	#fairy_level_cfg{fairy_id = 1002,level = 86,attr = [{2,34400},{4,1720},{5,1376},{8,1376}],exp = 1502};

get_fairy_level(1002,87) ->
	#fairy_level_cfg{fairy_id = 1002,level = 87,attr = [{2,34800},{4,1740},{5,1392},{8,1392}],exp = 1535};

get_fairy_level(1002,88) ->
	#fairy_level_cfg{fairy_id = 1002,level = 88,attr = [{2,35200},{4,1760},{5,1408},{8,1408}],exp = 1568};

get_fairy_level(1002,89) ->
	#fairy_level_cfg{fairy_id = 1002,level = 89,attr = [{2,35600},{4,1780},{5,1424},{8,1424}],exp = 1602};

get_fairy_level(1002,90) ->
	#fairy_level_cfg{fairy_id = 1002,level = 90,attr = [{2,36000},{4,1800},{5,1440},{8,1440}],exp = 1632};

get_fairy_level(1002,91) ->
	#fairy_level_cfg{fairy_id = 1002,level = 91,attr = [{2,36400},{4,1820},{5,1456},{8,1456}],exp = 1662};

get_fairy_level(1002,92) ->
	#fairy_level_cfg{fairy_id = 1002,level = 92,attr = [{2,36800},{4,1840},{5,1472},{8,1472}],exp = 1693};

get_fairy_level(1002,93) ->
	#fairy_level_cfg{fairy_id = 1002,level = 93,attr = [{2,37200},{4,1860},{5,1488},{8,1488}],exp = 1724};

get_fairy_level(1002,94) ->
	#fairy_level_cfg{fairy_id = 1002,level = 94,attr = [{2,37600},{4,1880},{5,1504},{8,1504}],exp = 1756};

get_fairy_level(1002,95) ->
	#fairy_level_cfg{fairy_id = 1002,level = 95,attr = [{2,38000},{4,1900},{5,1520},{8,1520}],exp = 1789};

get_fairy_level(1002,96) ->
	#fairy_level_cfg{fairy_id = 1002,level = 96,attr = [{2,38400},{4,1920},{5,1536},{8,1536}],exp = 1822};

get_fairy_level(1002,97) ->
	#fairy_level_cfg{fairy_id = 1002,level = 97,attr = [{2,38800},{4,1940},{5,1552},{8,1552}],exp = 1856};

get_fairy_level(1002,98) ->
	#fairy_level_cfg{fairy_id = 1002,level = 98,attr = [{2,39200},{4,1960},{5,1568},{8,1568}],exp = 1890};

get_fairy_level(1002,99) ->
	#fairy_level_cfg{fairy_id = 1002,level = 99,attr = [{2,39600},{4,1980},{5,1584},{8,1584}],exp = 1925};

get_fairy_level(1002,100) ->
	#fairy_level_cfg{fairy_id = 1002,level = 100,attr = [{2,40000},{4,2000},{5,1600},{8,1600}],exp = 0};

get_fairy_level(1003,0) ->
	#fairy_level_cfg{fairy_id = 1003,level = 0,attr = [{1,0},{2,0},{7,0},{5,0}],exp = 10};

get_fairy_level(1003,1) ->
	#fairy_level_cfg{fairy_id = 1003,level = 1,attr = [{1,20},{2,400},{7,16},{5,16}],exp = 11};

get_fairy_level(1003,2) ->
	#fairy_level_cfg{fairy_id = 1003,level = 2,attr = [{1,40},{2,800},{7,32},{5,32}],exp = 12};

get_fairy_level(1003,3) ->
	#fairy_level_cfg{fairy_id = 1003,level = 3,attr = [{1,60},{2,1200},{7,48},{5,48}],exp = 14};

get_fairy_level(1003,4) ->
	#fairy_level_cfg{fairy_id = 1003,level = 4,attr = [{1,80},{2,1600},{7,64},{5,64}],exp = 16};

get_fairy_level(1003,5) ->
	#fairy_level_cfg{fairy_id = 1003,level = 5,attr = [{1,100},{2,2000},{7,80},{5,80}],exp = 18};

get_fairy_level(1003,6) ->
	#fairy_level_cfg{fairy_id = 1003,level = 6,attr = [{1,120},{2,2400},{7,96},{5,96}],exp = 20};

get_fairy_level(1003,7) ->
	#fairy_level_cfg{fairy_id = 1003,level = 7,attr = [{1,140},{2,2800},{7,112},{5,112}],exp = 23};

get_fairy_level(1003,8) ->
	#fairy_level_cfg{fairy_id = 1003,level = 8,attr = [{1,160},{2,3200},{7,128},{5,128}],exp = 26};

get_fairy_level(1003,9) ->
	#fairy_level_cfg{fairy_id = 1003,level = 9,attr = [{1,180},{2,3600},{7,144},{5,144}],exp = 29};

get_fairy_level(1003,10) ->
	#fairy_level_cfg{fairy_id = 1003,level = 10,attr = [{1,200},{2,4000},{7,160},{5,160}],exp = 32};

get_fairy_level(1003,11) ->
	#fairy_level_cfg{fairy_id = 1003,level = 11,attr = [{1,220},{2,4400},{7,176},{5,176}],exp = 35};

get_fairy_level(1003,12) ->
	#fairy_level_cfg{fairy_id = 1003,level = 12,attr = [{1,240},{2,4800},{7,192},{5,192}],exp = 39};

get_fairy_level(1003,13) ->
	#fairy_level_cfg{fairy_id = 1003,level = 13,attr = [{1,260},{2,5200},{7,208},{5,208}],exp = 43};

get_fairy_level(1003,14) ->
	#fairy_level_cfg{fairy_id = 1003,level = 14,attr = [{1,280},{2,5600},{7,224},{5,224}],exp = 47};

get_fairy_level(1003,15) ->
	#fairy_level_cfg{fairy_id = 1003,level = 15,attr = [{1,300},{2,6000},{7,240},{5,240}],exp = 52};

get_fairy_level(1003,16) ->
	#fairy_level_cfg{fairy_id = 1003,level = 16,attr = [{1,320},{2,6400},{7,256},{5,256}],exp = 57};

get_fairy_level(1003,17) ->
	#fairy_level_cfg{fairy_id = 1003,level = 17,attr = [{1,340},{2,6800},{7,272},{5,272}],exp = 63};

get_fairy_level(1003,18) ->
	#fairy_level_cfg{fairy_id = 1003,level = 18,attr = [{1,360},{2,7200},{7,288},{5,288}],exp = 69};

get_fairy_level(1003,19) ->
	#fairy_level_cfg{fairy_id = 1003,level = 19,attr = [{1,380},{2,7600},{7,304},{5,304}],exp = 76};

get_fairy_level(1003,20) ->
	#fairy_level_cfg{fairy_id = 1003,level = 20,attr = [{1,400},{2,8000},{7,320},{5,320}],exp = 82};

get_fairy_level(1003,21) ->
	#fairy_level_cfg{fairy_id = 1003,level = 21,attr = [{1,420},{2,8400},{7,336},{5,336}],exp = 89};

get_fairy_level(1003,22) ->
	#fairy_level_cfg{fairy_id = 1003,level = 22,attr = [{1,440},{2,8800},{7,352},{5,352}],exp = 96};

get_fairy_level(1003,23) ->
	#fairy_level_cfg{fairy_id = 1003,level = 23,attr = [{1,460},{2,9200},{7,368},{5,368}],exp = 104};

get_fairy_level(1003,24) ->
	#fairy_level_cfg{fairy_id = 1003,level = 24,attr = [{1,480},{2,9600},{7,384},{5,384}],exp = 113};

get_fairy_level(1003,25) ->
	#fairy_level_cfg{fairy_id = 1003,level = 25,attr = [{1,500},{2,10000},{7,400},{5,400}],exp = 122};

get_fairy_level(1003,26) ->
	#fairy_level_cfg{fairy_id = 1003,level = 26,attr = [{1,520},{2,10400},{7,416},{5,416}],exp = 132};

get_fairy_level(1003,27) ->
	#fairy_level_cfg{fairy_id = 1003,level = 27,attr = [{1,540},{2,10800},{7,432},{5,432}],exp = 143};

get_fairy_level(1003,28) ->
	#fairy_level_cfg{fairy_id = 1003,level = 28,attr = [{1,560},{2,11200},{7,448},{5,448}],exp = 155};

get_fairy_level(1003,29) ->
	#fairy_level_cfg{fairy_id = 1003,level = 29,attr = [{1,580},{2,11600},{7,464},{5,464}],exp = 168};

get_fairy_level(1003,30) ->
	#fairy_level_cfg{fairy_id = 1003,level = 30,attr = [{1,600},{2,12000},{7,480},{5,480}],exp = 179};

get_fairy_level(1003,31) ->
	#fairy_level_cfg{fairy_id = 1003,level = 31,attr = [{1,620},{2,12400},{7,496},{5,496}],exp = 190};

get_fairy_level(1003,32) ->
	#fairy_level_cfg{fairy_id = 1003,level = 32,attr = [{1,640},{2,12800},{7,512},{5,512}],exp = 202};

get_fairy_level(1003,33) ->
	#fairy_level_cfg{fairy_id = 1003,level = 33,attr = [{1,660},{2,13200},{7,528},{5,528}],exp = 215};

get_fairy_level(1003,34) ->
	#fairy_level_cfg{fairy_id = 1003,level = 34,attr = [{1,680},{2,13600},{7,544},{5,544}],exp = 228};

get_fairy_level(1003,35) ->
	#fairy_level_cfg{fairy_id = 1003,level = 35,attr = [{1,700},{2,14000},{7,560},{5,560}],exp = 242};

get_fairy_level(1003,36) ->
	#fairy_level_cfg{fairy_id = 1003,level = 36,attr = [{1,720},{2,14400},{7,576},{5,576}],exp = 257};

get_fairy_level(1003,37) ->
	#fairy_level_cfg{fairy_id = 1003,level = 37,attr = [{1,740},{2,14800},{7,592},{5,592}],exp = 273};

get_fairy_level(1003,38) ->
	#fairy_level_cfg{fairy_id = 1003,level = 38,attr = [{1,760},{2,15200},{7,608},{5,608}],exp = 290};

get_fairy_level(1003,39) ->
	#fairy_level_cfg{fairy_id = 1003,level = 39,attr = [{1,780},{2,15600},{7,624},{5,624}],exp = 308};

get_fairy_level(1003,40) ->
	#fairy_level_cfg{fairy_id = 1003,level = 40,attr = [{1,800},{2,16000},{7,640},{5,640}],exp = 323};

get_fairy_level(1003,41) ->
	#fairy_level_cfg{fairy_id = 1003,level = 41,attr = [{1,820},{2,16400},{7,656},{5,656}],exp = 339};

get_fairy_level(1003,42) ->
	#fairy_level_cfg{fairy_id = 1003,level = 42,attr = [{1,840},{2,16800},{7,672},{5,672}],exp = 356};

get_fairy_level(1003,43) ->
	#fairy_level_cfg{fairy_id = 1003,level = 43,attr = [{1,860},{2,17200},{7,688},{5,688}],exp = 374};

get_fairy_level(1003,44) ->
	#fairy_level_cfg{fairy_id = 1003,level = 44,attr = [{1,880},{2,17600},{7,704},{5,704}],exp = 393};

get_fairy_level(1003,45) ->
	#fairy_level_cfg{fairy_id = 1003,level = 45,attr = [{1,900},{2,18000},{7,720},{5,720}],exp = 413};

get_fairy_level(1003,46) ->
	#fairy_level_cfg{fairy_id = 1003,level = 46,attr = [{1,920},{2,18400},{7,736},{5,736}],exp = 434};

get_fairy_level(1003,47) ->
	#fairy_level_cfg{fairy_id = 1003,level = 47,attr = [{1,940},{2,18800},{7,752},{5,752}],exp = 456};

get_fairy_level(1003,48) ->
	#fairy_level_cfg{fairy_id = 1003,level = 48,attr = [{1,960},{2,19200},{7,768},{5,768}],exp = 479};

get_fairy_level(1003,49) ->
	#fairy_level_cfg{fairy_id = 1003,level = 49,attr = [{1,980},{2,19600},{7,784},{5,784}],exp = 503};

get_fairy_level(1003,50) ->
	#fairy_level_cfg{fairy_id = 1003,level = 50,attr = [{1,1000},{2,20000},{7,800},{5,800}],exp = 522};

get_fairy_level(1003,51) ->
	#fairy_level_cfg{fairy_id = 1003,level = 51,attr = [{1,1020},{2,20400},{7,816},{5,816}],exp = 542};

get_fairy_level(1003,52) ->
	#fairy_level_cfg{fairy_id = 1003,level = 52,attr = [{1,1040},{2,20800},{7,832},{5,832}],exp = 563};

get_fairy_level(1003,53) ->
	#fairy_level_cfg{fairy_id = 1003,level = 53,attr = [{1,1060},{2,21200},{7,848},{5,848}],exp = 585};

get_fairy_level(1003,54) ->
	#fairy_level_cfg{fairy_id = 1003,level = 54,attr = [{1,1080},{2,21600},{7,864},{5,864}],exp = 608};

get_fairy_level(1003,55) ->
	#fairy_level_cfg{fairy_id = 1003,level = 55,attr = [{1,1100},{2,22000},{7,880},{5,880}],exp = 631};

get_fairy_level(1003,56) ->
	#fairy_level_cfg{fairy_id = 1003,level = 56,attr = [{1,1120},{2,22400},{7,896},{5,896}],exp = 655};

get_fairy_level(1003,57) ->
	#fairy_level_cfg{fairy_id = 1003,level = 57,attr = [{1,1140},{2,22800},{7,912},{5,912}],exp = 680};

get_fairy_level(1003,58) ->
	#fairy_level_cfg{fairy_id = 1003,level = 58,attr = [{1,1160},{2,23200},{7,928},{5,928}],exp = 706};

get_fairy_level(1003,59) ->
	#fairy_level_cfg{fairy_id = 1003,level = 59,attr = [{1,1180},{2,23600},{7,944},{5,944}],exp = 733};

get_fairy_level(1003,60) ->
	#fairy_level_cfg{fairy_id = 1003,level = 60,attr = [{1,1200},{2,24000},{7,960},{5,960}],exp = 756};

get_fairy_level(1003,61) ->
	#fairy_level_cfg{fairy_id = 1003,level = 61,attr = [{1,1220},{2,24400},{7,976},{5,976}],exp = 780};

get_fairy_level(1003,62) ->
	#fairy_level_cfg{fairy_id = 1003,level = 62,attr = [{1,1240},{2,24800},{7,992},{5,992}],exp = 804};

get_fairy_level(1003,63) ->
	#fairy_level_cfg{fairy_id = 1003,level = 63,attr = [{1,1260},{2,25200},{7,1008},{5,1008}],exp = 829};

get_fairy_level(1003,64) ->
	#fairy_level_cfg{fairy_id = 1003,level = 64,attr = [{1,1280},{2,25600},{7,1024},{5,1024}],exp = 855};

get_fairy_level(1003,65) ->
	#fairy_level_cfg{fairy_id = 1003,level = 65,attr = [{1,1300},{2,26000},{7,1040},{5,1040}],exp = 882};

get_fairy_level(1003,66) ->
	#fairy_level_cfg{fairy_id = 1003,level = 66,attr = [{1,1320},{2,26400},{7,1056},{5,1056}],exp = 910};

get_fairy_level(1003,67) ->
	#fairy_level_cfg{fairy_id = 1003,level = 67,attr = [{1,1340},{2,26800},{7,1072},{5,1072}],exp = 938};

get_fairy_level(1003,68) ->
	#fairy_level_cfg{fairy_id = 1003,level = 68,attr = [{1,1360},{2,27200},{7,1088},{5,1088}],exp = 967};

get_fairy_level(1003,69) ->
	#fairy_level_cfg{fairy_id = 1003,level = 69,attr = [{1,1380},{2,27600},{7,1104},{5,1104}],exp = 997};

get_fairy_level(1003,70) ->
	#fairy_level_cfg{fairy_id = 1003,level = 70,attr = [{1,1400},{2,28000},{7,1120},{5,1120}],exp = 1023};

get_fairy_level(1003,71) ->
	#fairy_level_cfg{fairy_id = 1003,level = 71,attr = [{1,1420},{2,28400},{7,1136},{5,1136}],exp = 1050};

get_fairy_level(1003,72) ->
	#fairy_level_cfg{fairy_id = 1003,level = 72,attr = [{1,1440},{2,28800},{7,1152},{5,1152}],exp = 1078};

get_fairy_level(1003,73) ->
	#fairy_level_cfg{fairy_id = 1003,level = 73,attr = [{1,1460},{2,29200},{7,1168},{5,1168}],exp = 1106};

get_fairy_level(1003,74) ->
	#fairy_level_cfg{fairy_id = 1003,level = 74,attr = [{1,1480},{2,29600},{7,1184},{5,1184}],exp = 1135};

get_fairy_level(1003,75) ->
	#fairy_level_cfg{fairy_id = 1003,level = 75,attr = [{1,1500},{2,30000},{7,1200},{5,1200}],exp = 1165};

get_fairy_level(1003,76) ->
	#fairy_level_cfg{fairy_id = 1003,level = 76,attr = [{1,1520},{2,30400},{7,1216},{5,1216}],exp = 1196};

get_fairy_level(1003,77) ->
	#fairy_level_cfg{fairy_id = 1003,level = 77,attr = [{1,1540},{2,30800},{7,1232},{5,1232}],exp = 1227};

get_fairy_level(1003,78) ->
	#fairy_level_cfg{fairy_id = 1003,level = 78,attr = [{1,1560},{2,31200},{7,1248},{5,1248}],exp = 1259};

get_fairy_level(1003,79) ->
	#fairy_level_cfg{fairy_id = 1003,level = 79,attr = [{1,1580},{2,31600},{7,1264},{5,1264}],exp = 1292};

get_fairy_level(1003,80) ->
	#fairy_level_cfg{fairy_id = 1003,level = 80,attr = [{1,1600},{2,32000},{7,1280},{5,1280}],exp = 1320};

get_fairy_level(1003,81) ->
	#fairy_level_cfg{fairy_id = 1003,level = 81,attr = [{1,1620},{2,32400},{7,1296},{5,1296}],exp = 1349};

get_fairy_level(1003,82) ->
	#fairy_level_cfg{fairy_id = 1003,level = 82,attr = [{1,1640},{2,32800},{7,1312},{5,1312}],exp = 1378};

get_fairy_level(1003,83) ->
	#fairy_level_cfg{fairy_id = 1003,level = 83,attr = [{1,1660},{2,33200},{7,1328},{5,1328}],exp = 1408};

get_fairy_level(1003,84) ->
	#fairy_level_cfg{fairy_id = 1003,level = 84,attr = [{1,1680},{2,33600},{7,1344},{5,1344}],exp = 1439};

get_fairy_level(1003,85) ->
	#fairy_level_cfg{fairy_id = 1003,level = 85,attr = [{1,1700},{2,34000},{7,1360},{5,1360}],exp = 1470};

get_fairy_level(1003,86) ->
	#fairy_level_cfg{fairy_id = 1003,level = 86,attr = [{1,1720},{2,34400},{7,1376},{5,1376}],exp = 1502};

get_fairy_level(1003,87) ->
	#fairy_level_cfg{fairy_id = 1003,level = 87,attr = [{1,1740},{2,34800},{7,1392},{5,1392}],exp = 1535};

get_fairy_level(1003,88) ->
	#fairy_level_cfg{fairy_id = 1003,level = 88,attr = [{1,1760},{2,35200},{7,1408},{5,1408}],exp = 1568};

get_fairy_level(1003,89) ->
	#fairy_level_cfg{fairy_id = 1003,level = 89,attr = [{1,1780},{2,35600},{7,1424},{5,1424}],exp = 1602};

get_fairy_level(1003,90) ->
	#fairy_level_cfg{fairy_id = 1003,level = 90,attr = [{1,1800},{2,36000},{7,1440},{5,1440}],exp = 1632};

get_fairy_level(1003,91) ->
	#fairy_level_cfg{fairy_id = 1003,level = 91,attr = [{1,1820},{2,36400},{7,1456},{5,1456}],exp = 1662};

get_fairy_level(1003,92) ->
	#fairy_level_cfg{fairy_id = 1003,level = 92,attr = [{1,1840},{2,36800},{7,1472},{5,1472}],exp = 1693};

get_fairy_level(1003,93) ->
	#fairy_level_cfg{fairy_id = 1003,level = 93,attr = [{1,1860},{2,37200},{7,1488},{5,1488}],exp = 1724};

get_fairy_level(1003,94) ->
	#fairy_level_cfg{fairy_id = 1003,level = 94,attr = [{1,1880},{2,37600},{7,1504},{5,1504}],exp = 1756};

get_fairy_level(1003,95) ->
	#fairy_level_cfg{fairy_id = 1003,level = 95,attr = [{1,1900},{2,38000},{7,1520},{5,1520}],exp = 1789};

get_fairy_level(1003,96) ->
	#fairy_level_cfg{fairy_id = 1003,level = 96,attr = [{1,1920},{2,38400},{7,1536},{5,1536}],exp = 1822};

get_fairy_level(1003,97) ->
	#fairy_level_cfg{fairy_id = 1003,level = 97,attr = [{1,1940},{2,38800},{7,1552},{5,1552}],exp = 1856};

get_fairy_level(1003,98) ->
	#fairy_level_cfg{fairy_id = 1003,level = 98,attr = [{1,1960},{2,39200},{7,1568},{5,1568}],exp = 1890};

get_fairy_level(1003,99) ->
	#fairy_level_cfg{fairy_id = 1003,level = 99,attr = [{1,1980},{2,39600},{7,1584},{5,1584}],exp = 1925};

get_fairy_level(1003,100) ->
	#fairy_level_cfg{fairy_id = 1003,level = 100,attr = [{1,2000},{2,40000},{7,1600},{5,1600}],exp = 0};

get_fairy_level(1004,0) ->
	#fairy_level_cfg{fairy_id = 1004,level = 0,attr = [{1,0},{4,0},{6,0},{8,0}],exp = 10};

get_fairy_level(1004,1) ->
	#fairy_level_cfg{fairy_id = 1004,level = 1,attr = [{1,20},{4,20},{6,16},{8,16}],exp = 11};

get_fairy_level(1004,2) ->
	#fairy_level_cfg{fairy_id = 1004,level = 2,attr = [{1,40},{4,40},{6,32},{8,32}],exp = 12};

get_fairy_level(1004,3) ->
	#fairy_level_cfg{fairy_id = 1004,level = 3,attr = [{1,60},{4,60},{6,48},{8,48}],exp = 14};

get_fairy_level(1004,4) ->
	#fairy_level_cfg{fairy_id = 1004,level = 4,attr = [{1,80},{4,80},{6,64},{8,64}],exp = 16};

get_fairy_level(1004,5) ->
	#fairy_level_cfg{fairy_id = 1004,level = 5,attr = [{1,100},{4,100},{6,80},{8,80}],exp = 18};

get_fairy_level(1004,6) ->
	#fairy_level_cfg{fairy_id = 1004,level = 6,attr = [{1,120},{4,120},{6,96},{8,96}],exp = 20};

get_fairy_level(1004,7) ->
	#fairy_level_cfg{fairy_id = 1004,level = 7,attr = [{1,140},{4,140},{6,112},{8,112}],exp = 23};

get_fairy_level(1004,8) ->
	#fairy_level_cfg{fairy_id = 1004,level = 8,attr = [{1,160},{4,160},{6,128},{8,128}],exp = 26};

get_fairy_level(1004,9) ->
	#fairy_level_cfg{fairy_id = 1004,level = 9,attr = [{1,180},{4,180},{6,144},{8,144}],exp = 29};

get_fairy_level(1004,10) ->
	#fairy_level_cfg{fairy_id = 1004,level = 10,attr = [{1,200},{4,200},{6,160},{8,160}],exp = 32};

get_fairy_level(1004,11) ->
	#fairy_level_cfg{fairy_id = 1004,level = 11,attr = [{1,220},{4,220},{6,176},{8,176}],exp = 35};

get_fairy_level(1004,12) ->
	#fairy_level_cfg{fairy_id = 1004,level = 12,attr = [{1,240},{4,240},{6,192},{8,192}],exp = 39};

get_fairy_level(1004,13) ->
	#fairy_level_cfg{fairy_id = 1004,level = 13,attr = [{1,260},{4,260},{6,208},{8,208}],exp = 43};

get_fairy_level(1004,14) ->
	#fairy_level_cfg{fairy_id = 1004,level = 14,attr = [{1,280},{4,280},{6,224},{8,224}],exp = 47};

get_fairy_level(1004,15) ->
	#fairy_level_cfg{fairy_id = 1004,level = 15,attr = [{1,300},{4,300},{6,240},{8,240}],exp = 52};

get_fairy_level(1004,16) ->
	#fairy_level_cfg{fairy_id = 1004,level = 16,attr = [{1,320},{4,320},{6,256},{8,256}],exp = 57};

get_fairy_level(1004,17) ->
	#fairy_level_cfg{fairy_id = 1004,level = 17,attr = [{1,340},{4,340},{6,272},{8,272}],exp = 63};

get_fairy_level(1004,18) ->
	#fairy_level_cfg{fairy_id = 1004,level = 18,attr = [{1,360},{4,360},{6,288},{8,288}],exp = 69};

get_fairy_level(1004,19) ->
	#fairy_level_cfg{fairy_id = 1004,level = 19,attr = [{1,380},{4,380},{6,304},{8,304}],exp = 76};

get_fairy_level(1004,20) ->
	#fairy_level_cfg{fairy_id = 1004,level = 20,attr = [{1,400},{4,400},{6,320},{8,320}],exp = 82};

get_fairy_level(1004,21) ->
	#fairy_level_cfg{fairy_id = 1004,level = 21,attr = [{1,420},{4,420},{6,336},{8,336}],exp = 89};

get_fairy_level(1004,22) ->
	#fairy_level_cfg{fairy_id = 1004,level = 22,attr = [{1,440},{4,440},{6,352},{8,352}],exp = 96};

get_fairy_level(1004,23) ->
	#fairy_level_cfg{fairy_id = 1004,level = 23,attr = [{1,460},{4,460},{6,368},{8,368}],exp = 104};

get_fairy_level(1004,24) ->
	#fairy_level_cfg{fairy_id = 1004,level = 24,attr = [{1,480},{4,480},{6,384},{8,384}],exp = 113};

get_fairy_level(1004,25) ->
	#fairy_level_cfg{fairy_id = 1004,level = 25,attr = [{1,500},{4,500},{6,400},{8,400}],exp = 122};

get_fairy_level(1004,26) ->
	#fairy_level_cfg{fairy_id = 1004,level = 26,attr = [{1,520},{4,520},{6,416},{8,416}],exp = 132};

get_fairy_level(1004,27) ->
	#fairy_level_cfg{fairy_id = 1004,level = 27,attr = [{1,540},{4,540},{6,432},{8,432}],exp = 143};

get_fairy_level(1004,28) ->
	#fairy_level_cfg{fairy_id = 1004,level = 28,attr = [{1,560},{4,560},{6,448},{8,448}],exp = 155};

get_fairy_level(1004,29) ->
	#fairy_level_cfg{fairy_id = 1004,level = 29,attr = [{1,580},{4,580},{6,464},{8,464}],exp = 168};

get_fairy_level(1004,30) ->
	#fairy_level_cfg{fairy_id = 1004,level = 30,attr = [{1,600},{4,600},{6,480},{8,480}],exp = 179};

get_fairy_level(1004,31) ->
	#fairy_level_cfg{fairy_id = 1004,level = 31,attr = [{1,620},{4,620},{6,496},{8,496}],exp = 190};

get_fairy_level(1004,32) ->
	#fairy_level_cfg{fairy_id = 1004,level = 32,attr = [{1,640},{4,640},{6,512},{8,512}],exp = 202};

get_fairy_level(1004,33) ->
	#fairy_level_cfg{fairy_id = 1004,level = 33,attr = [{1,660},{4,660},{6,528},{8,528}],exp = 215};

get_fairy_level(1004,34) ->
	#fairy_level_cfg{fairy_id = 1004,level = 34,attr = [{1,680},{4,680},{6,544},{8,544}],exp = 228};

get_fairy_level(1004,35) ->
	#fairy_level_cfg{fairy_id = 1004,level = 35,attr = [{1,700},{4,700},{6,560},{8,560}],exp = 242};

get_fairy_level(1004,36) ->
	#fairy_level_cfg{fairy_id = 1004,level = 36,attr = [{1,720},{4,720},{6,576},{8,576}],exp = 257};

get_fairy_level(1004,37) ->
	#fairy_level_cfg{fairy_id = 1004,level = 37,attr = [{1,740},{4,740},{6,592},{8,592}],exp = 273};

get_fairy_level(1004,38) ->
	#fairy_level_cfg{fairy_id = 1004,level = 38,attr = [{1,760},{4,760},{6,608},{8,608}],exp = 290};

get_fairy_level(1004,39) ->
	#fairy_level_cfg{fairy_id = 1004,level = 39,attr = [{1,780},{4,780},{6,624},{8,624}],exp = 308};

get_fairy_level(1004,40) ->
	#fairy_level_cfg{fairy_id = 1004,level = 40,attr = [{1,800},{4,800},{6,640},{8,640}],exp = 323};

get_fairy_level(1004,41) ->
	#fairy_level_cfg{fairy_id = 1004,level = 41,attr = [{1,820},{4,820},{6,656},{8,656}],exp = 339};

get_fairy_level(1004,42) ->
	#fairy_level_cfg{fairy_id = 1004,level = 42,attr = [{1,840},{4,840},{6,672},{8,672}],exp = 356};

get_fairy_level(1004,43) ->
	#fairy_level_cfg{fairy_id = 1004,level = 43,attr = [{1,860},{4,860},{6,688},{8,688}],exp = 374};

get_fairy_level(1004,44) ->
	#fairy_level_cfg{fairy_id = 1004,level = 44,attr = [{1,880},{4,880},{6,704},{8,704}],exp = 393};

get_fairy_level(1004,45) ->
	#fairy_level_cfg{fairy_id = 1004,level = 45,attr = [{1,900},{4,900},{6,720},{8,720}],exp = 413};

get_fairy_level(1004,46) ->
	#fairy_level_cfg{fairy_id = 1004,level = 46,attr = [{1,920},{4,920},{6,736},{8,736}],exp = 434};

get_fairy_level(1004,47) ->
	#fairy_level_cfg{fairy_id = 1004,level = 47,attr = [{1,940},{4,940},{6,752},{8,752}],exp = 456};

get_fairy_level(1004,48) ->
	#fairy_level_cfg{fairy_id = 1004,level = 48,attr = [{1,960},{4,960},{6,768},{8,768}],exp = 479};

get_fairy_level(1004,49) ->
	#fairy_level_cfg{fairy_id = 1004,level = 49,attr = [{1,980},{4,980},{6,784},{8,784}],exp = 503};

get_fairy_level(1004,50) ->
	#fairy_level_cfg{fairy_id = 1004,level = 50,attr = [{1,1000},{4,1000},{6,800},{8,800}],exp = 522};

get_fairy_level(1004,51) ->
	#fairy_level_cfg{fairy_id = 1004,level = 51,attr = [{1,1020},{4,1020},{6,816},{8,816}],exp = 542};

get_fairy_level(1004,52) ->
	#fairy_level_cfg{fairy_id = 1004,level = 52,attr = [{1,1040},{4,1040},{6,832},{8,832}],exp = 563};

get_fairy_level(1004,53) ->
	#fairy_level_cfg{fairy_id = 1004,level = 53,attr = [{1,1060},{4,1060},{6,848},{8,848}],exp = 585};

get_fairy_level(1004,54) ->
	#fairy_level_cfg{fairy_id = 1004,level = 54,attr = [{1,1080},{4,1080},{6,864},{8,864}],exp = 608};

get_fairy_level(1004,55) ->
	#fairy_level_cfg{fairy_id = 1004,level = 55,attr = [{1,1100},{4,1100},{6,880},{8,880}],exp = 631};

get_fairy_level(1004,56) ->
	#fairy_level_cfg{fairy_id = 1004,level = 56,attr = [{1,1120},{4,1120},{6,896},{8,896}],exp = 655};

get_fairy_level(1004,57) ->
	#fairy_level_cfg{fairy_id = 1004,level = 57,attr = [{1,1140},{4,1140},{6,912},{8,912}],exp = 680};

get_fairy_level(1004,58) ->
	#fairy_level_cfg{fairy_id = 1004,level = 58,attr = [{1,1160},{4,1160},{6,928},{8,928}],exp = 706};

get_fairy_level(1004,59) ->
	#fairy_level_cfg{fairy_id = 1004,level = 59,attr = [{1,1180},{4,1180},{6,944},{8,944}],exp = 733};

get_fairy_level(1004,60) ->
	#fairy_level_cfg{fairy_id = 1004,level = 60,attr = [{1,1200},{4,1200},{6,960},{8,960}],exp = 756};

get_fairy_level(1004,61) ->
	#fairy_level_cfg{fairy_id = 1004,level = 61,attr = [{1,1220},{4,1220},{6,976},{8,976}],exp = 780};

get_fairy_level(1004,62) ->
	#fairy_level_cfg{fairy_id = 1004,level = 62,attr = [{1,1240},{4,1240},{6,992},{8,992}],exp = 804};

get_fairy_level(1004,63) ->
	#fairy_level_cfg{fairy_id = 1004,level = 63,attr = [{1,1260},{4,1260},{6,1008},{8,1008}],exp = 829};

get_fairy_level(1004,64) ->
	#fairy_level_cfg{fairy_id = 1004,level = 64,attr = [{1,1280},{4,1280},{6,1024},{8,1024}],exp = 855};

get_fairy_level(1004,65) ->
	#fairy_level_cfg{fairy_id = 1004,level = 65,attr = [{1,1300},{4,1300},{6,1040},{8,1040}],exp = 882};

get_fairy_level(1004,66) ->
	#fairy_level_cfg{fairy_id = 1004,level = 66,attr = [{1,1320},{4,1320},{6,1056},{8,1056}],exp = 910};

get_fairy_level(1004,67) ->
	#fairy_level_cfg{fairy_id = 1004,level = 67,attr = [{1,1340},{4,1340},{6,1072},{8,1072}],exp = 938};

get_fairy_level(1004,68) ->
	#fairy_level_cfg{fairy_id = 1004,level = 68,attr = [{1,1360},{4,1360},{6,1088},{8,1088}],exp = 967};

get_fairy_level(1004,69) ->
	#fairy_level_cfg{fairy_id = 1004,level = 69,attr = [{1,1380},{4,1380},{6,1104},{8,1104}],exp = 997};

get_fairy_level(1004,70) ->
	#fairy_level_cfg{fairy_id = 1004,level = 70,attr = [{1,1400},{4,1400},{6,1120},{8,1120}],exp = 1023};

get_fairy_level(1004,71) ->
	#fairy_level_cfg{fairy_id = 1004,level = 71,attr = [{1,1420},{4,1420},{6,1136},{8,1136}],exp = 1050};

get_fairy_level(1004,72) ->
	#fairy_level_cfg{fairy_id = 1004,level = 72,attr = [{1,1440},{4,1440},{6,1152},{8,1152}],exp = 1078};

get_fairy_level(1004,73) ->
	#fairy_level_cfg{fairy_id = 1004,level = 73,attr = [{1,1460},{4,1460},{6,1168},{8,1168}],exp = 1106};

get_fairy_level(1004,74) ->
	#fairy_level_cfg{fairy_id = 1004,level = 74,attr = [{1,1480},{4,1480},{6,1184},{8,1184}],exp = 1135};

get_fairy_level(1004,75) ->
	#fairy_level_cfg{fairy_id = 1004,level = 75,attr = [{1,1500},{4,1500},{6,1200},{8,1200}],exp = 1165};

get_fairy_level(1004,76) ->
	#fairy_level_cfg{fairy_id = 1004,level = 76,attr = [{1,1520},{4,1520},{6,1216},{8,1216}],exp = 1196};

get_fairy_level(1004,77) ->
	#fairy_level_cfg{fairy_id = 1004,level = 77,attr = [{1,1540},{4,1540},{6,1232},{8,1232}],exp = 1227};

get_fairy_level(1004,78) ->
	#fairy_level_cfg{fairy_id = 1004,level = 78,attr = [{1,1560},{4,1560},{6,1248},{8,1248}],exp = 1259};

get_fairy_level(1004,79) ->
	#fairy_level_cfg{fairy_id = 1004,level = 79,attr = [{1,1580},{4,1580},{6,1264},{8,1264}],exp = 1292};

get_fairy_level(1004,80) ->
	#fairy_level_cfg{fairy_id = 1004,level = 80,attr = [{1,1600},{4,1600},{6,1280},{8,1280}],exp = 1320};

get_fairy_level(1004,81) ->
	#fairy_level_cfg{fairy_id = 1004,level = 81,attr = [{1,1620},{4,1620},{6,1296},{8,1296}],exp = 1349};

get_fairy_level(1004,82) ->
	#fairy_level_cfg{fairy_id = 1004,level = 82,attr = [{1,1640},{4,1640},{6,1312},{8,1312}],exp = 1378};

get_fairy_level(1004,83) ->
	#fairy_level_cfg{fairy_id = 1004,level = 83,attr = [{1,1660},{4,1660},{6,1328},{8,1328}],exp = 1408};

get_fairy_level(1004,84) ->
	#fairy_level_cfg{fairy_id = 1004,level = 84,attr = [{1,1680},{4,1680},{6,1344},{8,1344}],exp = 1439};

get_fairy_level(1004,85) ->
	#fairy_level_cfg{fairy_id = 1004,level = 85,attr = [{1,1700},{4,1700},{6,1360},{8,1360}],exp = 1470};

get_fairy_level(1004,86) ->
	#fairy_level_cfg{fairy_id = 1004,level = 86,attr = [{1,1720},{4,1720},{6,1376},{8,1376}],exp = 1502};

get_fairy_level(1004,87) ->
	#fairy_level_cfg{fairy_id = 1004,level = 87,attr = [{1,1740},{4,1740},{6,1392},{8,1392}],exp = 1535};

get_fairy_level(1004,88) ->
	#fairy_level_cfg{fairy_id = 1004,level = 88,attr = [{1,1760},{4,1760},{6,1408},{8,1408}],exp = 1568};

get_fairy_level(1004,89) ->
	#fairy_level_cfg{fairy_id = 1004,level = 89,attr = [{1,1780},{4,1780},{6,1424},{8,1424}],exp = 1602};

get_fairy_level(1004,90) ->
	#fairy_level_cfg{fairy_id = 1004,level = 90,attr = [{1,1800},{4,1800},{6,1440},{8,1440}],exp = 1632};

get_fairy_level(1004,91) ->
	#fairy_level_cfg{fairy_id = 1004,level = 91,attr = [{1,1820},{4,1820},{6,1456},{8,1456}],exp = 1662};

get_fairy_level(1004,92) ->
	#fairy_level_cfg{fairy_id = 1004,level = 92,attr = [{1,1840},{4,1840},{6,1472},{8,1472}],exp = 1693};

get_fairy_level(1004,93) ->
	#fairy_level_cfg{fairy_id = 1004,level = 93,attr = [{1,1860},{4,1860},{6,1488},{8,1488}],exp = 1724};

get_fairy_level(1004,94) ->
	#fairy_level_cfg{fairy_id = 1004,level = 94,attr = [{1,1880},{4,1880},{6,1504},{8,1504}],exp = 1756};

get_fairy_level(1004,95) ->
	#fairy_level_cfg{fairy_id = 1004,level = 95,attr = [{1,1900},{4,1900},{6,1520},{8,1520}],exp = 1789};

get_fairy_level(1004,96) ->
	#fairy_level_cfg{fairy_id = 1004,level = 96,attr = [{1,1920},{4,1920},{6,1536},{8,1536}],exp = 1822};

get_fairy_level(1004,97) ->
	#fairy_level_cfg{fairy_id = 1004,level = 97,attr = [{1,1940},{4,1940},{6,1552},{8,1552}],exp = 1856};

get_fairy_level(1004,98) ->
	#fairy_level_cfg{fairy_id = 1004,level = 98,attr = [{1,1960},{4,1960},{6,1568},{8,1568}],exp = 1890};

get_fairy_level(1004,99) ->
	#fairy_level_cfg{fairy_id = 1004,level = 99,attr = [{1,1980},{4,1980},{6,1584},{8,1584}],exp = 1925};

get_fairy_level(1004,100) ->
	#fairy_level_cfg{fairy_id = 1004,level = 100,attr = [{1,2000},{4,2000},{6,1600},{8,1600}],exp = 0};

get_fairy_level(1005,0) ->
	#fairy_level_cfg{fairy_id = 1005,level = 0,attr = [{2,0},{3,0},{5,0},{6,0}],exp = 10};

get_fairy_level(1005,1) ->
	#fairy_level_cfg{fairy_id = 1005,level = 1,attr = [{2,400},{3,20},{5,16},{6,16}],exp = 11};

get_fairy_level(1005,2) ->
	#fairy_level_cfg{fairy_id = 1005,level = 2,attr = [{2,800},{3,40},{5,32},{6,32}],exp = 12};

get_fairy_level(1005,3) ->
	#fairy_level_cfg{fairy_id = 1005,level = 3,attr = [{2,1200},{3,60},{5,48},{6,48}],exp = 14};

get_fairy_level(1005,4) ->
	#fairy_level_cfg{fairy_id = 1005,level = 4,attr = [{2,1600},{3,80},{5,64},{6,64}],exp = 16};

get_fairy_level(1005,5) ->
	#fairy_level_cfg{fairy_id = 1005,level = 5,attr = [{2,2000},{3,100},{5,80},{6,80}],exp = 18};

get_fairy_level(1005,6) ->
	#fairy_level_cfg{fairy_id = 1005,level = 6,attr = [{2,2400},{3,120},{5,96},{6,96}],exp = 20};

get_fairy_level(1005,7) ->
	#fairy_level_cfg{fairy_id = 1005,level = 7,attr = [{2,2800},{3,140},{5,112},{6,112}],exp = 23};

get_fairy_level(1005,8) ->
	#fairy_level_cfg{fairy_id = 1005,level = 8,attr = [{2,3200},{3,160},{5,128},{6,128}],exp = 26};

get_fairy_level(1005,9) ->
	#fairy_level_cfg{fairy_id = 1005,level = 9,attr = [{2,3600},{3,180},{5,144},{6,144}],exp = 29};

get_fairy_level(1005,10) ->
	#fairy_level_cfg{fairy_id = 1005,level = 10,attr = [{2,4000},{3,200},{5,160},{6,160}],exp = 32};

get_fairy_level(1005,11) ->
	#fairy_level_cfg{fairy_id = 1005,level = 11,attr = [{2,4400},{3,220},{5,176},{6,176}],exp = 35};

get_fairy_level(1005,12) ->
	#fairy_level_cfg{fairy_id = 1005,level = 12,attr = [{2,4800},{3,240},{5,192},{6,192}],exp = 39};

get_fairy_level(1005,13) ->
	#fairy_level_cfg{fairy_id = 1005,level = 13,attr = [{2,5200},{3,260},{5,208},{6,208}],exp = 43};

get_fairy_level(1005,14) ->
	#fairy_level_cfg{fairy_id = 1005,level = 14,attr = [{2,5600},{3,280},{5,224},{6,224}],exp = 47};

get_fairy_level(1005,15) ->
	#fairy_level_cfg{fairy_id = 1005,level = 15,attr = [{2,6000},{3,300},{5,240},{6,240}],exp = 52};

get_fairy_level(1005,16) ->
	#fairy_level_cfg{fairy_id = 1005,level = 16,attr = [{2,6400},{3,320},{5,256},{6,256}],exp = 57};

get_fairy_level(1005,17) ->
	#fairy_level_cfg{fairy_id = 1005,level = 17,attr = [{2,6800},{3,340},{5,272},{6,272}],exp = 63};

get_fairy_level(1005,18) ->
	#fairy_level_cfg{fairy_id = 1005,level = 18,attr = [{2,7200},{3,360},{5,288},{6,288}],exp = 69};

get_fairy_level(1005,19) ->
	#fairy_level_cfg{fairy_id = 1005,level = 19,attr = [{2,7600},{3,380},{5,304},{6,304}],exp = 76};

get_fairy_level(1005,20) ->
	#fairy_level_cfg{fairy_id = 1005,level = 20,attr = [{2,8000},{3,400},{5,320},{6,320}],exp = 82};

get_fairy_level(1005,21) ->
	#fairy_level_cfg{fairy_id = 1005,level = 21,attr = [{2,8400},{3,420},{5,336},{6,336}],exp = 89};

get_fairy_level(1005,22) ->
	#fairy_level_cfg{fairy_id = 1005,level = 22,attr = [{2,8800},{3,440},{5,352},{6,352}],exp = 96};

get_fairy_level(1005,23) ->
	#fairy_level_cfg{fairy_id = 1005,level = 23,attr = [{2,9200},{3,460},{5,368},{6,368}],exp = 104};

get_fairy_level(1005,24) ->
	#fairy_level_cfg{fairy_id = 1005,level = 24,attr = [{2,9600},{3,480},{5,384},{6,384}],exp = 113};

get_fairy_level(1005,25) ->
	#fairy_level_cfg{fairy_id = 1005,level = 25,attr = [{2,10000},{3,500},{5,400},{6,400}],exp = 122};

get_fairy_level(1005,26) ->
	#fairy_level_cfg{fairy_id = 1005,level = 26,attr = [{2,10400},{3,520},{5,416},{6,416}],exp = 132};

get_fairy_level(1005,27) ->
	#fairy_level_cfg{fairy_id = 1005,level = 27,attr = [{2,10800},{3,540},{5,432},{6,432}],exp = 143};

get_fairy_level(1005,28) ->
	#fairy_level_cfg{fairy_id = 1005,level = 28,attr = [{2,11200},{3,560},{5,448},{6,448}],exp = 155};

get_fairy_level(1005,29) ->
	#fairy_level_cfg{fairy_id = 1005,level = 29,attr = [{2,11600},{3,580},{5,464},{6,464}],exp = 168};

get_fairy_level(1005,30) ->
	#fairy_level_cfg{fairy_id = 1005,level = 30,attr = [{2,12000},{3,600},{5,480},{6,480}],exp = 179};

get_fairy_level(1005,31) ->
	#fairy_level_cfg{fairy_id = 1005,level = 31,attr = [{2,12400},{3,620},{5,496},{6,496}],exp = 190};

get_fairy_level(1005,32) ->
	#fairy_level_cfg{fairy_id = 1005,level = 32,attr = [{2,12800},{3,640},{5,512},{6,512}],exp = 202};

get_fairy_level(1005,33) ->
	#fairy_level_cfg{fairy_id = 1005,level = 33,attr = [{2,13200},{3,660},{5,528},{6,528}],exp = 215};

get_fairy_level(1005,34) ->
	#fairy_level_cfg{fairy_id = 1005,level = 34,attr = [{2,13600},{3,680},{5,544},{6,544}],exp = 228};

get_fairy_level(1005,35) ->
	#fairy_level_cfg{fairy_id = 1005,level = 35,attr = [{2,14000},{3,700},{5,560},{6,560}],exp = 242};

get_fairy_level(1005,36) ->
	#fairy_level_cfg{fairy_id = 1005,level = 36,attr = [{2,14400},{3,720},{5,576},{6,576}],exp = 257};

get_fairy_level(1005,37) ->
	#fairy_level_cfg{fairy_id = 1005,level = 37,attr = [{2,14800},{3,740},{5,592},{6,592}],exp = 273};

get_fairy_level(1005,38) ->
	#fairy_level_cfg{fairy_id = 1005,level = 38,attr = [{2,15200},{3,760},{5,608},{6,608}],exp = 290};

get_fairy_level(1005,39) ->
	#fairy_level_cfg{fairy_id = 1005,level = 39,attr = [{2,15600},{3,780},{5,624},{6,624}],exp = 308};

get_fairy_level(1005,40) ->
	#fairy_level_cfg{fairy_id = 1005,level = 40,attr = [{2,16000},{3,800},{5,640},{6,640}],exp = 323};

get_fairy_level(1005,41) ->
	#fairy_level_cfg{fairy_id = 1005,level = 41,attr = [{2,16400},{3,820},{5,656},{6,656}],exp = 339};

get_fairy_level(1005,42) ->
	#fairy_level_cfg{fairy_id = 1005,level = 42,attr = [{2,16800},{3,840},{5,672},{6,672}],exp = 356};

get_fairy_level(1005,43) ->
	#fairy_level_cfg{fairy_id = 1005,level = 43,attr = [{2,17200},{3,860},{5,688},{6,688}],exp = 374};

get_fairy_level(1005,44) ->
	#fairy_level_cfg{fairy_id = 1005,level = 44,attr = [{2,17600},{3,880},{5,704},{6,704}],exp = 393};

get_fairy_level(1005,45) ->
	#fairy_level_cfg{fairy_id = 1005,level = 45,attr = [{2,18000},{3,900},{5,720},{6,720}],exp = 413};

get_fairy_level(1005,46) ->
	#fairy_level_cfg{fairy_id = 1005,level = 46,attr = [{2,18400},{3,920},{5,736},{6,736}],exp = 434};

get_fairy_level(1005,47) ->
	#fairy_level_cfg{fairy_id = 1005,level = 47,attr = [{2,18800},{3,940},{5,752},{6,752}],exp = 456};

get_fairy_level(1005,48) ->
	#fairy_level_cfg{fairy_id = 1005,level = 48,attr = [{2,19200},{3,960},{5,768},{6,768}],exp = 479};

get_fairy_level(1005,49) ->
	#fairy_level_cfg{fairy_id = 1005,level = 49,attr = [{2,19600},{3,980},{5,784},{6,784}],exp = 503};

get_fairy_level(1005,50) ->
	#fairy_level_cfg{fairy_id = 1005,level = 50,attr = [{2,20000},{3,1000},{5,800},{6,800}],exp = 522};

get_fairy_level(1005,51) ->
	#fairy_level_cfg{fairy_id = 1005,level = 51,attr = [{2,20400},{3,1020},{5,816},{6,816}],exp = 542};

get_fairy_level(1005,52) ->
	#fairy_level_cfg{fairy_id = 1005,level = 52,attr = [{2,20800},{3,1040},{5,832},{6,832}],exp = 563};

get_fairy_level(1005,53) ->
	#fairy_level_cfg{fairy_id = 1005,level = 53,attr = [{2,21200},{3,1060},{5,848},{6,848}],exp = 585};

get_fairy_level(1005,54) ->
	#fairy_level_cfg{fairy_id = 1005,level = 54,attr = [{2,21600},{3,1080},{5,864},{6,864}],exp = 608};

get_fairy_level(1005,55) ->
	#fairy_level_cfg{fairy_id = 1005,level = 55,attr = [{2,22000},{3,1100},{5,880},{6,880}],exp = 631};

get_fairy_level(1005,56) ->
	#fairy_level_cfg{fairy_id = 1005,level = 56,attr = [{2,22400},{3,1120},{5,896},{6,896}],exp = 655};

get_fairy_level(1005,57) ->
	#fairy_level_cfg{fairy_id = 1005,level = 57,attr = [{2,22800},{3,1140},{5,912},{6,912}],exp = 680};

get_fairy_level(1005,58) ->
	#fairy_level_cfg{fairy_id = 1005,level = 58,attr = [{2,23200},{3,1160},{5,928},{6,928}],exp = 706};

get_fairy_level(1005,59) ->
	#fairy_level_cfg{fairy_id = 1005,level = 59,attr = [{2,23600},{3,1180},{5,944},{6,944}],exp = 733};

get_fairy_level(1005,60) ->
	#fairy_level_cfg{fairy_id = 1005,level = 60,attr = [{2,24000},{3,1200},{5,960},{6,960}],exp = 756};

get_fairy_level(1005,61) ->
	#fairy_level_cfg{fairy_id = 1005,level = 61,attr = [{2,24400},{3,1220},{5,976},{6,976}],exp = 780};

get_fairy_level(1005,62) ->
	#fairy_level_cfg{fairy_id = 1005,level = 62,attr = [{2,24800},{3,1240},{5,992},{6,992}],exp = 804};

get_fairy_level(1005,63) ->
	#fairy_level_cfg{fairy_id = 1005,level = 63,attr = [{2,25200},{3,1260},{5,1008},{6,1008}],exp = 829};

get_fairy_level(1005,64) ->
	#fairy_level_cfg{fairy_id = 1005,level = 64,attr = [{2,25600},{3,1280},{5,1024},{6,1024}],exp = 855};

get_fairy_level(1005,65) ->
	#fairy_level_cfg{fairy_id = 1005,level = 65,attr = [{2,26000},{3,1300},{5,1040},{6,1040}],exp = 882};

get_fairy_level(1005,66) ->
	#fairy_level_cfg{fairy_id = 1005,level = 66,attr = [{2,26400},{3,1320},{5,1056},{6,1056}],exp = 910};

get_fairy_level(1005,67) ->
	#fairy_level_cfg{fairy_id = 1005,level = 67,attr = [{2,26800},{3,1340},{5,1072},{6,1072}],exp = 938};

get_fairy_level(1005,68) ->
	#fairy_level_cfg{fairy_id = 1005,level = 68,attr = [{2,27200},{3,1360},{5,1088},{6,1088}],exp = 967};

get_fairy_level(1005,69) ->
	#fairy_level_cfg{fairy_id = 1005,level = 69,attr = [{2,27600},{3,1380},{5,1104},{6,1104}],exp = 997};

get_fairy_level(1005,70) ->
	#fairy_level_cfg{fairy_id = 1005,level = 70,attr = [{2,28000},{3,1400},{5,1120},{6,1120}],exp = 1023};

get_fairy_level(1005,71) ->
	#fairy_level_cfg{fairy_id = 1005,level = 71,attr = [{2,28400},{3,1420},{5,1136},{6,1136}],exp = 1050};

get_fairy_level(1005,72) ->
	#fairy_level_cfg{fairy_id = 1005,level = 72,attr = [{2,28800},{3,1440},{5,1152},{6,1152}],exp = 1078};

get_fairy_level(1005,73) ->
	#fairy_level_cfg{fairy_id = 1005,level = 73,attr = [{2,29200},{3,1460},{5,1168},{6,1168}],exp = 1106};

get_fairy_level(1005,74) ->
	#fairy_level_cfg{fairy_id = 1005,level = 74,attr = [{2,29600},{3,1480},{5,1184},{6,1184}],exp = 1135};

get_fairy_level(1005,75) ->
	#fairy_level_cfg{fairy_id = 1005,level = 75,attr = [{2,30000},{3,1500},{5,1200},{6,1200}],exp = 1165};

get_fairy_level(1005,76) ->
	#fairy_level_cfg{fairy_id = 1005,level = 76,attr = [{2,30400},{3,1520},{5,1216},{6,1216}],exp = 1196};

get_fairy_level(1005,77) ->
	#fairy_level_cfg{fairy_id = 1005,level = 77,attr = [{2,30800},{3,1540},{5,1232},{6,1232}],exp = 1227};

get_fairy_level(1005,78) ->
	#fairy_level_cfg{fairy_id = 1005,level = 78,attr = [{2,31200},{3,1560},{5,1248},{6,1248}],exp = 1259};

get_fairy_level(1005,79) ->
	#fairy_level_cfg{fairy_id = 1005,level = 79,attr = [{2,31600},{3,1580},{5,1264},{6,1264}],exp = 1292};

get_fairy_level(1005,80) ->
	#fairy_level_cfg{fairy_id = 1005,level = 80,attr = [{2,32000},{3,1600},{5,1280},{6,1280}],exp = 1320};

get_fairy_level(1005,81) ->
	#fairy_level_cfg{fairy_id = 1005,level = 81,attr = [{2,32400},{3,1620},{5,1296},{6,1296}],exp = 1349};

get_fairy_level(1005,82) ->
	#fairy_level_cfg{fairy_id = 1005,level = 82,attr = [{2,32800},{3,1640},{5,1312},{6,1312}],exp = 1378};

get_fairy_level(1005,83) ->
	#fairy_level_cfg{fairy_id = 1005,level = 83,attr = [{2,33200},{3,1660},{5,1328},{6,1328}],exp = 1408};

get_fairy_level(1005,84) ->
	#fairy_level_cfg{fairy_id = 1005,level = 84,attr = [{2,33600},{3,1680},{5,1344},{6,1344}],exp = 1439};

get_fairy_level(1005,85) ->
	#fairy_level_cfg{fairy_id = 1005,level = 85,attr = [{2,34000},{3,1700},{5,1360},{6,1360}],exp = 1470};

get_fairy_level(1005,86) ->
	#fairy_level_cfg{fairy_id = 1005,level = 86,attr = [{2,34400},{3,1720},{5,1376},{6,1376}],exp = 1502};

get_fairy_level(1005,87) ->
	#fairy_level_cfg{fairy_id = 1005,level = 87,attr = [{2,34800},{3,1740},{5,1392},{6,1392}],exp = 1535};

get_fairy_level(1005,88) ->
	#fairy_level_cfg{fairy_id = 1005,level = 88,attr = [{2,35200},{3,1760},{5,1408},{6,1408}],exp = 1568};

get_fairy_level(1005,89) ->
	#fairy_level_cfg{fairy_id = 1005,level = 89,attr = [{2,35600},{3,1780},{5,1424},{6,1424}],exp = 1602};

get_fairy_level(1005,90) ->
	#fairy_level_cfg{fairy_id = 1005,level = 90,attr = [{2,36000},{3,1800},{5,1440},{6,1440}],exp = 1632};

get_fairy_level(1005,91) ->
	#fairy_level_cfg{fairy_id = 1005,level = 91,attr = [{2,36400},{3,1820},{5,1456},{6,1456}],exp = 1662};

get_fairy_level(1005,92) ->
	#fairy_level_cfg{fairy_id = 1005,level = 92,attr = [{2,36800},{3,1840},{5,1472},{6,1472}],exp = 1693};

get_fairy_level(1005,93) ->
	#fairy_level_cfg{fairy_id = 1005,level = 93,attr = [{2,37200},{3,1860},{5,1488},{6,1488}],exp = 1724};

get_fairy_level(1005,94) ->
	#fairy_level_cfg{fairy_id = 1005,level = 94,attr = [{2,37600},{3,1880},{5,1504},{6,1504}],exp = 1756};

get_fairy_level(1005,95) ->
	#fairy_level_cfg{fairy_id = 1005,level = 95,attr = [{2,38000},{3,1900},{5,1520},{6,1520}],exp = 1789};

get_fairy_level(1005,96) ->
	#fairy_level_cfg{fairy_id = 1005,level = 96,attr = [{2,38400},{3,1920},{5,1536},{6,1536}],exp = 1822};

get_fairy_level(1005,97) ->
	#fairy_level_cfg{fairy_id = 1005,level = 97,attr = [{2,38800},{3,1940},{5,1552},{6,1552}],exp = 1856};

get_fairy_level(1005,98) ->
	#fairy_level_cfg{fairy_id = 1005,level = 98,attr = [{2,39200},{3,1960},{5,1568},{6,1568}],exp = 1890};

get_fairy_level(1005,99) ->
	#fairy_level_cfg{fairy_id = 1005,level = 99,attr = [{2,39600},{3,1980},{5,1584},{6,1584}],exp = 1925};

get_fairy_level(1005,100) ->
	#fairy_level_cfg{fairy_id = 1005,level = 100,attr = [{2,40000},{3,2000},{5,1600},{6,1600}],exp = 0};

get_fairy_level(1006,0) ->
	#fairy_level_cfg{fairy_id = 1006,level = 0,attr = [{1,0},{3,0},{6,0},{7,0}],exp = 10};

get_fairy_level(1006,1) ->
	#fairy_level_cfg{fairy_id = 1006,level = 1,attr = [{1,20},{3,20},{6,16},{7,16}],exp = 11};

get_fairy_level(1006,2) ->
	#fairy_level_cfg{fairy_id = 1006,level = 2,attr = [{1,40},{3,40},{6,32},{7,32}],exp = 12};

get_fairy_level(1006,3) ->
	#fairy_level_cfg{fairy_id = 1006,level = 3,attr = [{1,60},{3,60},{6,48},{7,48}],exp = 14};

get_fairy_level(1006,4) ->
	#fairy_level_cfg{fairy_id = 1006,level = 4,attr = [{1,80},{3,80},{6,64},{7,64}],exp = 16};

get_fairy_level(1006,5) ->
	#fairy_level_cfg{fairy_id = 1006,level = 5,attr = [{1,100},{3,100},{6,80},{7,80}],exp = 18};

get_fairy_level(1006,6) ->
	#fairy_level_cfg{fairy_id = 1006,level = 6,attr = [{1,120},{3,120},{6,96},{7,96}],exp = 20};

get_fairy_level(1006,7) ->
	#fairy_level_cfg{fairy_id = 1006,level = 7,attr = [{1,140},{3,140},{6,112},{7,112}],exp = 23};

get_fairy_level(1006,8) ->
	#fairy_level_cfg{fairy_id = 1006,level = 8,attr = [{1,160},{3,160},{6,128},{7,128}],exp = 26};

get_fairy_level(1006,9) ->
	#fairy_level_cfg{fairy_id = 1006,level = 9,attr = [{1,180},{3,180},{6,144},{7,144}],exp = 29};

get_fairy_level(1006,10) ->
	#fairy_level_cfg{fairy_id = 1006,level = 10,attr = [{1,200},{3,200},{6,160},{7,160}],exp = 32};

get_fairy_level(1006,11) ->
	#fairy_level_cfg{fairy_id = 1006,level = 11,attr = [{1,220},{3,220},{6,176},{7,176}],exp = 35};

get_fairy_level(1006,12) ->
	#fairy_level_cfg{fairy_id = 1006,level = 12,attr = [{1,240},{3,240},{6,192},{7,192}],exp = 39};

get_fairy_level(1006,13) ->
	#fairy_level_cfg{fairy_id = 1006,level = 13,attr = [{1,260},{3,260},{6,208},{7,208}],exp = 43};

get_fairy_level(1006,14) ->
	#fairy_level_cfg{fairy_id = 1006,level = 14,attr = [{1,280},{3,280},{6,224},{7,224}],exp = 47};

get_fairy_level(1006,15) ->
	#fairy_level_cfg{fairy_id = 1006,level = 15,attr = [{1,300},{3,300},{6,240},{7,240}],exp = 52};

get_fairy_level(1006,16) ->
	#fairy_level_cfg{fairy_id = 1006,level = 16,attr = [{1,320},{3,320},{6,256},{7,256}],exp = 57};

get_fairy_level(1006,17) ->
	#fairy_level_cfg{fairy_id = 1006,level = 17,attr = [{1,340},{3,340},{6,272},{7,272}],exp = 63};

get_fairy_level(1006,18) ->
	#fairy_level_cfg{fairy_id = 1006,level = 18,attr = [{1,360},{3,360},{6,288},{7,288}],exp = 69};

get_fairy_level(1006,19) ->
	#fairy_level_cfg{fairy_id = 1006,level = 19,attr = [{1,380},{3,380},{6,304},{7,304}],exp = 76};

get_fairy_level(1006,20) ->
	#fairy_level_cfg{fairy_id = 1006,level = 20,attr = [{1,400},{3,400},{6,320},{7,320}],exp = 82};

get_fairy_level(1006,21) ->
	#fairy_level_cfg{fairy_id = 1006,level = 21,attr = [{1,420},{3,420},{6,336},{7,336}],exp = 89};

get_fairy_level(1006,22) ->
	#fairy_level_cfg{fairy_id = 1006,level = 22,attr = [{1,440},{3,440},{6,352},{7,352}],exp = 96};

get_fairy_level(1006,23) ->
	#fairy_level_cfg{fairy_id = 1006,level = 23,attr = [{1,460},{3,460},{6,368},{7,368}],exp = 104};

get_fairy_level(1006,24) ->
	#fairy_level_cfg{fairy_id = 1006,level = 24,attr = [{1,480},{3,480},{6,384},{7,384}],exp = 113};

get_fairy_level(1006,25) ->
	#fairy_level_cfg{fairy_id = 1006,level = 25,attr = [{1,500},{3,500},{6,400},{7,400}],exp = 122};

get_fairy_level(1006,26) ->
	#fairy_level_cfg{fairy_id = 1006,level = 26,attr = [{1,520},{3,520},{6,416},{7,416}],exp = 132};

get_fairy_level(1006,27) ->
	#fairy_level_cfg{fairy_id = 1006,level = 27,attr = [{1,540},{3,540},{6,432},{7,432}],exp = 143};

get_fairy_level(1006,28) ->
	#fairy_level_cfg{fairy_id = 1006,level = 28,attr = [{1,560},{3,560},{6,448},{7,448}],exp = 155};

get_fairy_level(1006,29) ->
	#fairy_level_cfg{fairy_id = 1006,level = 29,attr = [{1,580},{3,580},{6,464},{7,464}],exp = 168};

get_fairy_level(1006,30) ->
	#fairy_level_cfg{fairy_id = 1006,level = 30,attr = [{1,600},{3,600},{6,480},{7,480}],exp = 179};

get_fairy_level(1006,31) ->
	#fairy_level_cfg{fairy_id = 1006,level = 31,attr = [{1,620},{3,620},{6,496},{7,496}],exp = 190};

get_fairy_level(1006,32) ->
	#fairy_level_cfg{fairy_id = 1006,level = 32,attr = [{1,640},{3,640},{6,512},{7,512}],exp = 202};

get_fairy_level(1006,33) ->
	#fairy_level_cfg{fairy_id = 1006,level = 33,attr = [{1,660},{3,660},{6,528},{7,528}],exp = 215};

get_fairy_level(1006,34) ->
	#fairy_level_cfg{fairy_id = 1006,level = 34,attr = [{1,680},{3,680},{6,544},{7,544}],exp = 228};

get_fairy_level(1006,35) ->
	#fairy_level_cfg{fairy_id = 1006,level = 35,attr = [{1,700},{3,700},{6,560},{7,560}],exp = 242};

get_fairy_level(1006,36) ->
	#fairy_level_cfg{fairy_id = 1006,level = 36,attr = [{1,720},{3,720},{6,576},{7,576}],exp = 257};

get_fairy_level(1006,37) ->
	#fairy_level_cfg{fairy_id = 1006,level = 37,attr = [{1,740},{3,740},{6,592},{7,592}],exp = 273};

get_fairy_level(1006,38) ->
	#fairy_level_cfg{fairy_id = 1006,level = 38,attr = [{1,760},{3,760},{6,608},{7,608}],exp = 290};

get_fairy_level(1006,39) ->
	#fairy_level_cfg{fairy_id = 1006,level = 39,attr = [{1,780},{3,780},{6,624},{7,624}],exp = 308};

get_fairy_level(1006,40) ->
	#fairy_level_cfg{fairy_id = 1006,level = 40,attr = [{1,800},{3,800},{6,640},{7,640}],exp = 323};

get_fairy_level(1006,41) ->
	#fairy_level_cfg{fairy_id = 1006,level = 41,attr = [{1,820},{3,820},{6,656},{7,656}],exp = 339};

get_fairy_level(1006,42) ->
	#fairy_level_cfg{fairy_id = 1006,level = 42,attr = [{1,840},{3,840},{6,672},{7,672}],exp = 356};

get_fairy_level(1006,43) ->
	#fairy_level_cfg{fairy_id = 1006,level = 43,attr = [{1,860},{3,860},{6,688},{7,688}],exp = 374};

get_fairy_level(1006,44) ->
	#fairy_level_cfg{fairy_id = 1006,level = 44,attr = [{1,880},{3,880},{6,704},{7,704}],exp = 393};

get_fairy_level(1006,45) ->
	#fairy_level_cfg{fairy_id = 1006,level = 45,attr = [{1,900},{3,900},{6,720},{7,720}],exp = 413};

get_fairy_level(1006,46) ->
	#fairy_level_cfg{fairy_id = 1006,level = 46,attr = [{1,920},{3,920},{6,736},{7,736}],exp = 434};

get_fairy_level(1006,47) ->
	#fairy_level_cfg{fairy_id = 1006,level = 47,attr = [{1,940},{3,940},{6,752},{7,752}],exp = 456};

get_fairy_level(1006,48) ->
	#fairy_level_cfg{fairy_id = 1006,level = 48,attr = [{1,960},{3,960},{6,768},{7,768}],exp = 479};

get_fairy_level(1006,49) ->
	#fairy_level_cfg{fairy_id = 1006,level = 49,attr = [{1,980},{3,980},{6,784},{7,784}],exp = 503};

get_fairy_level(1006,50) ->
	#fairy_level_cfg{fairy_id = 1006,level = 50,attr = [{1,1000},{3,1000},{6,800},{7,800}],exp = 522};

get_fairy_level(1006,51) ->
	#fairy_level_cfg{fairy_id = 1006,level = 51,attr = [{1,1020},{3,1020},{6,816},{7,816}],exp = 542};

get_fairy_level(1006,52) ->
	#fairy_level_cfg{fairy_id = 1006,level = 52,attr = [{1,1040},{3,1040},{6,832},{7,832}],exp = 563};

get_fairy_level(1006,53) ->
	#fairy_level_cfg{fairy_id = 1006,level = 53,attr = [{1,1060},{3,1060},{6,848},{7,848}],exp = 585};

get_fairy_level(1006,54) ->
	#fairy_level_cfg{fairy_id = 1006,level = 54,attr = [{1,1080},{3,1080},{6,864},{7,864}],exp = 608};

get_fairy_level(1006,55) ->
	#fairy_level_cfg{fairy_id = 1006,level = 55,attr = [{1,1100},{3,1100},{6,880},{7,880}],exp = 631};

get_fairy_level(1006,56) ->
	#fairy_level_cfg{fairy_id = 1006,level = 56,attr = [{1,1120},{3,1120},{6,896},{7,896}],exp = 655};

get_fairy_level(1006,57) ->
	#fairy_level_cfg{fairy_id = 1006,level = 57,attr = [{1,1140},{3,1140},{6,912},{7,912}],exp = 680};

get_fairy_level(1006,58) ->
	#fairy_level_cfg{fairy_id = 1006,level = 58,attr = [{1,1160},{3,1160},{6,928},{7,928}],exp = 706};

get_fairy_level(1006,59) ->
	#fairy_level_cfg{fairy_id = 1006,level = 59,attr = [{1,1180},{3,1180},{6,944},{7,944}],exp = 733};

get_fairy_level(1006,60) ->
	#fairy_level_cfg{fairy_id = 1006,level = 60,attr = [{1,1200},{3,1200},{6,960},{7,960}],exp = 756};

get_fairy_level(1006,61) ->
	#fairy_level_cfg{fairy_id = 1006,level = 61,attr = [{1,1220},{3,1220},{6,976},{7,976}],exp = 780};

get_fairy_level(1006,62) ->
	#fairy_level_cfg{fairy_id = 1006,level = 62,attr = [{1,1240},{3,1240},{6,992},{7,992}],exp = 804};

get_fairy_level(1006,63) ->
	#fairy_level_cfg{fairy_id = 1006,level = 63,attr = [{1,1260},{3,1260},{6,1008},{7,1008}],exp = 829};

get_fairy_level(1006,64) ->
	#fairy_level_cfg{fairy_id = 1006,level = 64,attr = [{1,1280},{3,1280},{6,1024},{7,1024}],exp = 855};

get_fairy_level(1006,65) ->
	#fairy_level_cfg{fairy_id = 1006,level = 65,attr = [{1,1300},{3,1300},{6,1040},{7,1040}],exp = 882};

get_fairy_level(1006,66) ->
	#fairy_level_cfg{fairy_id = 1006,level = 66,attr = [{1,1320},{3,1320},{6,1056},{7,1056}],exp = 910};

get_fairy_level(1006,67) ->
	#fairy_level_cfg{fairy_id = 1006,level = 67,attr = [{1,1340},{3,1340},{6,1072},{7,1072}],exp = 938};

get_fairy_level(1006,68) ->
	#fairy_level_cfg{fairy_id = 1006,level = 68,attr = [{1,1360},{3,1360},{6,1088},{7,1088}],exp = 967};

get_fairy_level(1006,69) ->
	#fairy_level_cfg{fairy_id = 1006,level = 69,attr = [{1,1380},{3,1380},{6,1104},{7,1104}],exp = 997};

get_fairy_level(1006,70) ->
	#fairy_level_cfg{fairy_id = 1006,level = 70,attr = [{1,1400},{3,1400},{6,1120},{7,1120}],exp = 1023};

get_fairy_level(1006,71) ->
	#fairy_level_cfg{fairy_id = 1006,level = 71,attr = [{1,1420},{3,1420},{6,1136},{7,1136}],exp = 1050};

get_fairy_level(1006,72) ->
	#fairy_level_cfg{fairy_id = 1006,level = 72,attr = [{1,1440},{3,1440},{6,1152},{7,1152}],exp = 1078};

get_fairy_level(1006,73) ->
	#fairy_level_cfg{fairy_id = 1006,level = 73,attr = [{1,1460},{3,1460},{6,1168},{7,1168}],exp = 1106};

get_fairy_level(1006,74) ->
	#fairy_level_cfg{fairy_id = 1006,level = 74,attr = [{1,1480},{3,1480},{6,1184},{7,1184}],exp = 1135};

get_fairy_level(1006,75) ->
	#fairy_level_cfg{fairy_id = 1006,level = 75,attr = [{1,1500},{3,1500},{6,1200},{7,1200}],exp = 1165};

get_fairy_level(1006,76) ->
	#fairy_level_cfg{fairy_id = 1006,level = 76,attr = [{1,1520},{3,1520},{6,1216},{7,1216}],exp = 1196};

get_fairy_level(1006,77) ->
	#fairy_level_cfg{fairy_id = 1006,level = 77,attr = [{1,1540},{3,1540},{6,1232},{7,1232}],exp = 1227};

get_fairy_level(1006,78) ->
	#fairy_level_cfg{fairy_id = 1006,level = 78,attr = [{1,1560},{3,1560},{6,1248},{7,1248}],exp = 1259};

get_fairy_level(1006,79) ->
	#fairy_level_cfg{fairy_id = 1006,level = 79,attr = [{1,1580},{3,1580},{6,1264},{7,1264}],exp = 1292};

get_fairy_level(1006,80) ->
	#fairy_level_cfg{fairy_id = 1006,level = 80,attr = [{1,1600},{3,1600},{6,1280},{7,1280}],exp = 1320};

get_fairy_level(1006,81) ->
	#fairy_level_cfg{fairy_id = 1006,level = 81,attr = [{1,1620},{3,1620},{6,1296},{7,1296}],exp = 1349};

get_fairy_level(1006,82) ->
	#fairy_level_cfg{fairy_id = 1006,level = 82,attr = [{1,1640},{3,1640},{6,1312},{7,1312}],exp = 1378};

get_fairy_level(1006,83) ->
	#fairy_level_cfg{fairy_id = 1006,level = 83,attr = [{1,1660},{3,1660},{6,1328},{7,1328}],exp = 1408};

get_fairy_level(1006,84) ->
	#fairy_level_cfg{fairy_id = 1006,level = 84,attr = [{1,1680},{3,1680},{6,1344},{7,1344}],exp = 1439};

get_fairy_level(1006,85) ->
	#fairy_level_cfg{fairy_id = 1006,level = 85,attr = [{1,1700},{3,1700},{6,1360},{7,1360}],exp = 1470};

get_fairy_level(1006,86) ->
	#fairy_level_cfg{fairy_id = 1006,level = 86,attr = [{1,1720},{3,1720},{6,1376},{7,1376}],exp = 1502};

get_fairy_level(1006,87) ->
	#fairy_level_cfg{fairy_id = 1006,level = 87,attr = [{1,1740},{3,1740},{6,1392},{7,1392}],exp = 1535};

get_fairy_level(1006,88) ->
	#fairy_level_cfg{fairy_id = 1006,level = 88,attr = [{1,1760},{3,1760},{6,1408},{7,1408}],exp = 1568};

get_fairy_level(1006,89) ->
	#fairy_level_cfg{fairy_id = 1006,level = 89,attr = [{1,1780},{3,1780},{6,1424},{7,1424}],exp = 1602};

get_fairy_level(1006,90) ->
	#fairy_level_cfg{fairy_id = 1006,level = 90,attr = [{1,1800},{3,1800},{6,1440},{7,1440}],exp = 1632};

get_fairy_level(1006,91) ->
	#fairy_level_cfg{fairy_id = 1006,level = 91,attr = [{1,1820},{3,1820},{6,1456},{7,1456}],exp = 1662};

get_fairy_level(1006,92) ->
	#fairy_level_cfg{fairy_id = 1006,level = 92,attr = [{1,1840},{3,1840},{6,1472},{7,1472}],exp = 1693};

get_fairy_level(1006,93) ->
	#fairy_level_cfg{fairy_id = 1006,level = 93,attr = [{1,1860},{3,1860},{6,1488},{7,1488}],exp = 1724};

get_fairy_level(1006,94) ->
	#fairy_level_cfg{fairy_id = 1006,level = 94,attr = [{1,1880},{3,1880},{6,1504},{7,1504}],exp = 1756};

get_fairy_level(1006,95) ->
	#fairy_level_cfg{fairy_id = 1006,level = 95,attr = [{1,1900},{3,1900},{6,1520},{7,1520}],exp = 1789};

get_fairy_level(1006,96) ->
	#fairy_level_cfg{fairy_id = 1006,level = 96,attr = [{1,1920},{3,1920},{6,1536},{7,1536}],exp = 1822};

get_fairy_level(1006,97) ->
	#fairy_level_cfg{fairy_id = 1006,level = 97,attr = [{1,1940},{3,1940},{6,1552},{7,1552}],exp = 1856};

get_fairy_level(1006,98) ->
	#fairy_level_cfg{fairy_id = 1006,level = 98,attr = [{1,1960},{3,1960},{6,1568},{7,1568}],exp = 1890};

get_fairy_level(1006,99) ->
	#fairy_level_cfg{fairy_id = 1006,level = 99,attr = [{1,1980},{3,1980},{6,1584},{7,1584}],exp = 1925};

get_fairy_level(1006,100) ->
	#fairy_level_cfg{fairy_id = 1006,level = 100,attr = [{1,2000},{3,2000},{6,1600},{7,1600}],exp = 0};

get_fairy_level(1007,0) ->
	#fairy_level_cfg{fairy_id = 1007,level = 0,attr = [{2,0},{4,0},{5,0},{8,0}],exp = 10};

get_fairy_level(1007,1) ->
	#fairy_level_cfg{fairy_id = 1007,level = 1,attr = [{2,400},{4,20},{5,16},{8,16}],exp = 11};

get_fairy_level(1007,2) ->
	#fairy_level_cfg{fairy_id = 1007,level = 2,attr = [{2,800},{4,40},{5,32},{8,32}],exp = 12};

get_fairy_level(1007,3) ->
	#fairy_level_cfg{fairy_id = 1007,level = 3,attr = [{2,1200},{4,60},{5,48},{8,48}],exp = 14};

get_fairy_level(1007,4) ->
	#fairy_level_cfg{fairy_id = 1007,level = 4,attr = [{2,1600},{4,80},{5,64},{8,64}],exp = 16};

get_fairy_level(1007,5) ->
	#fairy_level_cfg{fairy_id = 1007,level = 5,attr = [{2,2000},{4,100},{5,80},{8,80}],exp = 18};

get_fairy_level(1007,6) ->
	#fairy_level_cfg{fairy_id = 1007,level = 6,attr = [{2,2400},{4,120},{5,96},{8,96}],exp = 20};

get_fairy_level(1007,7) ->
	#fairy_level_cfg{fairy_id = 1007,level = 7,attr = [{2,2800},{4,140},{5,112},{8,112}],exp = 23};

get_fairy_level(1007,8) ->
	#fairy_level_cfg{fairy_id = 1007,level = 8,attr = [{2,3200},{4,160},{5,128},{8,128}],exp = 26};

get_fairy_level(1007,9) ->
	#fairy_level_cfg{fairy_id = 1007,level = 9,attr = [{2,3600},{4,180},{5,144},{8,144}],exp = 29};

get_fairy_level(1007,10) ->
	#fairy_level_cfg{fairy_id = 1007,level = 10,attr = [{2,4000},{4,200},{5,160},{8,160}],exp = 32};

get_fairy_level(1007,11) ->
	#fairy_level_cfg{fairy_id = 1007,level = 11,attr = [{2,4400},{4,220},{5,176},{8,176}],exp = 35};

get_fairy_level(1007,12) ->
	#fairy_level_cfg{fairy_id = 1007,level = 12,attr = [{2,4800},{4,240},{5,192},{8,192}],exp = 39};

get_fairy_level(1007,13) ->
	#fairy_level_cfg{fairy_id = 1007,level = 13,attr = [{2,5200},{4,260},{5,208},{8,208}],exp = 43};

get_fairy_level(1007,14) ->
	#fairy_level_cfg{fairy_id = 1007,level = 14,attr = [{2,5600},{4,280},{5,224},{8,224}],exp = 47};

get_fairy_level(1007,15) ->
	#fairy_level_cfg{fairy_id = 1007,level = 15,attr = [{2,6000},{4,300},{5,240},{8,240}],exp = 52};

get_fairy_level(1007,16) ->
	#fairy_level_cfg{fairy_id = 1007,level = 16,attr = [{2,6400},{4,320},{5,256},{8,256}],exp = 57};

get_fairy_level(1007,17) ->
	#fairy_level_cfg{fairy_id = 1007,level = 17,attr = [{2,6800},{4,340},{5,272},{8,272}],exp = 63};

get_fairy_level(1007,18) ->
	#fairy_level_cfg{fairy_id = 1007,level = 18,attr = [{2,7200},{4,360},{5,288},{8,288}],exp = 69};

get_fairy_level(1007,19) ->
	#fairy_level_cfg{fairy_id = 1007,level = 19,attr = [{2,7600},{4,380},{5,304},{8,304}],exp = 76};

get_fairy_level(1007,20) ->
	#fairy_level_cfg{fairy_id = 1007,level = 20,attr = [{2,8000},{4,400},{5,320},{8,320}],exp = 82};

get_fairy_level(1007,21) ->
	#fairy_level_cfg{fairy_id = 1007,level = 21,attr = [{2,8400},{4,420},{5,336},{8,336}],exp = 89};

get_fairy_level(1007,22) ->
	#fairy_level_cfg{fairy_id = 1007,level = 22,attr = [{2,8800},{4,440},{5,352},{8,352}],exp = 96};

get_fairy_level(1007,23) ->
	#fairy_level_cfg{fairy_id = 1007,level = 23,attr = [{2,9200},{4,460},{5,368},{8,368}],exp = 104};

get_fairy_level(1007,24) ->
	#fairy_level_cfg{fairy_id = 1007,level = 24,attr = [{2,9600},{4,480},{5,384},{8,384}],exp = 113};

get_fairy_level(1007,25) ->
	#fairy_level_cfg{fairy_id = 1007,level = 25,attr = [{2,10000},{4,500},{5,400},{8,400}],exp = 122};

get_fairy_level(1007,26) ->
	#fairy_level_cfg{fairy_id = 1007,level = 26,attr = [{2,10400},{4,520},{5,416},{8,416}],exp = 132};

get_fairy_level(1007,27) ->
	#fairy_level_cfg{fairy_id = 1007,level = 27,attr = [{2,10800},{4,540},{5,432},{8,432}],exp = 143};

get_fairy_level(1007,28) ->
	#fairy_level_cfg{fairy_id = 1007,level = 28,attr = [{2,11200},{4,560},{5,448},{8,448}],exp = 155};

get_fairy_level(1007,29) ->
	#fairy_level_cfg{fairy_id = 1007,level = 29,attr = [{2,11600},{4,580},{5,464},{8,464}],exp = 168};

get_fairy_level(1007,30) ->
	#fairy_level_cfg{fairy_id = 1007,level = 30,attr = [{2,12000},{4,600},{5,480},{8,480}],exp = 179};

get_fairy_level(1007,31) ->
	#fairy_level_cfg{fairy_id = 1007,level = 31,attr = [{2,12400},{4,620},{5,496},{8,496}],exp = 190};

get_fairy_level(1007,32) ->
	#fairy_level_cfg{fairy_id = 1007,level = 32,attr = [{2,12800},{4,640},{5,512},{8,512}],exp = 202};

get_fairy_level(1007,33) ->
	#fairy_level_cfg{fairy_id = 1007,level = 33,attr = [{2,13200},{4,660},{5,528},{8,528}],exp = 215};

get_fairy_level(1007,34) ->
	#fairy_level_cfg{fairy_id = 1007,level = 34,attr = [{2,13600},{4,680},{5,544},{8,544}],exp = 228};

get_fairy_level(1007,35) ->
	#fairy_level_cfg{fairy_id = 1007,level = 35,attr = [{2,14000},{4,700},{5,560},{8,560}],exp = 242};

get_fairy_level(1007,36) ->
	#fairy_level_cfg{fairy_id = 1007,level = 36,attr = [{2,14400},{4,720},{5,576},{8,576}],exp = 257};

get_fairy_level(1007,37) ->
	#fairy_level_cfg{fairy_id = 1007,level = 37,attr = [{2,14800},{4,740},{5,592},{8,592}],exp = 273};

get_fairy_level(1007,38) ->
	#fairy_level_cfg{fairy_id = 1007,level = 38,attr = [{2,15200},{4,760},{5,608},{8,608}],exp = 290};

get_fairy_level(1007,39) ->
	#fairy_level_cfg{fairy_id = 1007,level = 39,attr = [{2,15600},{4,780},{5,624},{8,624}],exp = 308};

get_fairy_level(1007,40) ->
	#fairy_level_cfg{fairy_id = 1007,level = 40,attr = [{2,16000},{4,800},{5,640},{8,640}],exp = 323};

get_fairy_level(1007,41) ->
	#fairy_level_cfg{fairy_id = 1007,level = 41,attr = [{2,16400},{4,820},{5,656},{8,656}],exp = 339};

get_fairy_level(1007,42) ->
	#fairy_level_cfg{fairy_id = 1007,level = 42,attr = [{2,16800},{4,840},{5,672},{8,672}],exp = 356};

get_fairy_level(1007,43) ->
	#fairy_level_cfg{fairy_id = 1007,level = 43,attr = [{2,17200},{4,860},{5,688},{8,688}],exp = 374};

get_fairy_level(1007,44) ->
	#fairy_level_cfg{fairy_id = 1007,level = 44,attr = [{2,17600},{4,880},{5,704},{8,704}],exp = 393};

get_fairy_level(1007,45) ->
	#fairy_level_cfg{fairy_id = 1007,level = 45,attr = [{2,18000},{4,900},{5,720},{8,720}],exp = 413};

get_fairy_level(1007,46) ->
	#fairy_level_cfg{fairy_id = 1007,level = 46,attr = [{2,18400},{4,920},{5,736},{8,736}],exp = 434};

get_fairy_level(1007,47) ->
	#fairy_level_cfg{fairy_id = 1007,level = 47,attr = [{2,18800},{4,940},{5,752},{8,752}],exp = 456};

get_fairy_level(1007,48) ->
	#fairy_level_cfg{fairy_id = 1007,level = 48,attr = [{2,19200},{4,960},{5,768},{8,768}],exp = 479};

get_fairy_level(1007,49) ->
	#fairy_level_cfg{fairy_id = 1007,level = 49,attr = [{2,19600},{4,980},{5,784},{8,784}],exp = 503};

get_fairy_level(1007,50) ->
	#fairy_level_cfg{fairy_id = 1007,level = 50,attr = [{2,20000},{4,1000},{5,800},{8,800}],exp = 522};

get_fairy_level(1007,51) ->
	#fairy_level_cfg{fairy_id = 1007,level = 51,attr = [{2,20400},{4,1020},{5,816},{8,816}],exp = 542};

get_fairy_level(1007,52) ->
	#fairy_level_cfg{fairy_id = 1007,level = 52,attr = [{2,20800},{4,1040},{5,832},{8,832}],exp = 563};

get_fairy_level(1007,53) ->
	#fairy_level_cfg{fairy_id = 1007,level = 53,attr = [{2,21200},{4,1060},{5,848},{8,848}],exp = 585};

get_fairy_level(1007,54) ->
	#fairy_level_cfg{fairy_id = 1007,level = 54,attr = [{2,21600},{4,1080},{5,864},{8,864}],exp = 608};

get_fairy_level(1007,55) ->
	#fairy_level_cfg{fairy_id = 1007,level = 55,attr = [{2,22000},{4,1100},{5,880},{8,880}],exp = 631};

get_fairy_level(1007,56) ->
	#fairy_level_cfg{fairy_id = 1007,level = 56,attr = [{2,22400},{4,1120},{5,896},{8,896}],exp = 655};

get_fairy_level(1007,57) ->
	#fairy_level_cfg{fairy_id = 1007,level = 57,attr = [{2,22800},{4,1140},{5,912},{8,912}],exp = 680};

get_fairy_level(1007,58) ->
	#fairy_level_cfg{fairy_id = 1007,level = 58,attr = [{2,23200},{4,1160},{5,928},{8,928}],exp = 706};

get_fairy_level(1007,59) ->
	#fairy_level_cfg{fairy_id = 1007,level = 59,attr = [{2,23600},{4,1180},{5,944},{8,944}],exp = 733};

get_fairy_level(1007,60) ->
	#fairy_level_cfg{fairy_id = 1007,level = 60,attr = [{2,24000},{4,1200},{5,960},{8,960}],exp = 756};

get_fairy_level(1007,61) ->
	#fairy_level_cfg{fairy_id = 1007,level = 61,attr = [{2,24400},{4,1220},{5,976},{8,976}],exp = 780};

get_fairy_level(1007,62) ->
	#fairy_level_cfg{fairy_id = 1007,level = 62,attr = [{2,24800},{4,1240},{5,992},{8,992}],exp = 804};

get_fairy_level(1007,63) ->
	#fairy_level_cfg{fairy_id = 1007,level = 63,attr = [{2,25200},{4,1260},{5,1008},{8,1008}],exp = 829};

get_fairy_level(1007,64) ->
	#fairy_level_cfg{fairy_id = 1007,level = 64,attr = [{2,25600},{4,1280},{5,1024},{8,1024}],exp = 855};

get_fairy_level(1007,65) ->
	#fairy_level_cfg{fairy_id = 1007,level = 65,attr = [{2,26000},{4,1300},{5,1040},{8,1040}],exp = 882};

get_fairy_level(1007,66) ->
	#fairy_level_cfg{fairy_id = 1007,level = 66,attr = [{2,26400},{4,1320},{5,1056},{8,1056}],exp = 910};

get_fairy_level(1007,67) ->
	#fairy_level_cfg{fairy_id = 1007,level = 67,attr = [{2,26800},{4,1340},{5,1072},{8,1072}],exp = 938};

get_fairy_level(1007,68) ->
	#fairy_level_cfg{fairy_id = 1007,level = 68,attr = [{2,27200},{4,1360},{5,1088},{8,1088}],exp = 967};

get_fairy_level(1007,69) ->
	#fairy_level_cfg{fairy_id = 1007,level = 69,attr = [{2,27600},{4,1380},{5,1104},{8,1104}],exp = 997};

get_fairy_level(1007,70) ->
	#fairy_level_cfg{fairy_id = 1007,level = 70,attr = [{2,28000},{4,1400},{5,1120},{8,1120}],exp = 1023};

get_fairy_level(1007,71) ->
	#fairy_level_cfg{fairy_id = 1007,level = 71,attr = [{2,28400},{4,1420},{5,1136},{8,1136}],exp = 1050};

get_fairy_level(1007,72) ->
	#fairy_level_cfg{fairy_id = 1007,level = 72,attr = [{2,28800},{4,1440},{5,1152},{8,1152}],exp = 1078};

get_fairy_level(1007,73) ->
	#fairy_level_cfg{fairy_id = 1007,level = 73,attr = [{2,29200},{4,1460},{5,1168},{8,1168}],exp = 1106};

get_fairy_level(1007,74) ->
	#fairy_level_cfg{fairy_id = 1007,level = 74,attr = [{2,29600},{4,1480},{5,1184},{8,1184}],exp = 1135};

get_fairy_level(1007,75) ->
	#fairy_level_cfg{fairy_id = 1007,level = 75,attr = [{2,30000},{4,1500},{5,1200},{8,1200}],exp = 1165};

get_fairy_level(1007,76) ->
	#fairy_level_cfg{fairy_id = 1007,level = 76,attr = [{2,30400},{4,1520},{5,1216},{8,1216}],exp = 1196};

get_fairy_level(1007,77) ->
	#fairy_level_cfg{fairy_id = 1007,level = 77,attr = [{2,30800},{4,1540},{5,1232},{8,1232}],exp = 1227};

get_fairy_level(1007,78) ->
	#fairy_level_cfg{fairy_id = 1007,level = 78,attr = [{2,31200},{4,1560},{5,1248},{8,1248}],exp = 1259};

get_fairy_level(1007,79) ->
	#fairy_level_cfg{fairy_id = 1007,level = 79,attr = [{2,31600},{4,1580},{5,1264},{8,1264}],exp = 1292};

get_fairy_level(1007,80) ->
	#fairy_level_cfg{fairy_id = 1007,level = 80,attr = [{2,32000},{4,1600},{5,1280},{8,1280}],exp = 1320};

get_fairy_level(1007,81) ->
	#fairy_level_cfg{fairy_id = 1007,level = 81,attr = [{2,32400},{4,1620},{5,1296},{8,1296}],exp = 1349};

get_fairy_level(1007,82) ->
	#fairy_level_cfg{fairy_id = 1007,level = 82,attr = [{2,32800},{4,1640},{5,1312},{8,1312}],exp = 1378};

get_fairy_level(1007,83) ->
	#fairy_level_cfg{fairy_id = 1007,level = 83,attr = [{2,33200},{4,1660},{5,1328},{8,1328}],exp = 1408};

get_fairy_level(1007,84) ->
	#fairy_level_cfg{fairy_id = 1007,level = 84,attr = [{2,33600},{4,1680},{5,1344},{8,1344}],exp = 1439};

get_fairy_level(1007,85) ->
	#fairy_level_cfg{fairy_id = 1007,level = 85,attr = [{2,34000},{4,1700},{5,1360},{8,1360}],exp = 1470};

get_fairy_level(1007,86) ->
	#fairy_level_cfg{fairy_id = 1007,level = 86,attr = [{2,34400},{4,1720},{5,1376},{8,1376}],exp = 1502};

get_fairy_level(1007,87) ->
	#fairy_level_cfg{fairy_id = 1007,level = 87,attr = [{2,34800},{4,1740},{5,1392},{8,1392}],exp = 1535};

get_fairy_level(1007,88) ->
	#fairy_level_cfg{fairy_id = 1007,level = 88,attr = [{2,35200},{4,1760},{5,1408},{8,1408}],exp = 1568};

get_fairy_level(1007,89) ->
	#fairy_level_cfg{fairy_id = 1007,level = 89,attr = [{2,35600},{4,1780},{5,1424},{8,1424}],exp = 1602};

get_fairy_level(1007,90) ->
	#fairy_level_cfg{fairy_id = 1007,level = 90,attr = [{2,36000},{4,1800},{5,1440},{8,1440}],exp = 1632};

get_fairy_level(1007,91) ->
	#fairy_level_cfg{fairy_id = 1007,level = 91,attr = [{2,36400},{4,1820},{5,1456},{8,1456}],exp = 1662};

get_fairy_level(1007,92) ->
	#fairy_level_cfg{fairy_id = 1007,level = 92,attr = [{2,36800},{4,1840},{5,1472},{8,1472}],exp = 1693};

get_fairy_level(1007,93) ->
	#fairy_level_cfg{fairy_id = 1007,level = 93,attr = [{2,37200},{4,1860},{5,1488},{8,1488}],exp = 1724};

get_fairy_level(1007,94) ->
	#fairy_level_cfg{fairy_id = 1007,level = 94,attr = [{2,37600},{4,1880},{5,1504},{8,1504}],exp = 1756};

get_fairy_level(1007,95) ->
	#fairy_level_cfg{fairy_id = 1007,level = 95,attr = [{2,38000},{4,1900},{5,1520},{8,1520}],exp = 1789};

get_fairy_level(1007,96) ->
	#fairy_level_cfg{fairy_id = 1007,level = 96,attr = [{2,38400},{4,1920},{5,1536},{8,1536}],exp = 1822};

get_fairy_level(1007,97) ->
	#fairy_level_cfg{fairy_id = 1007,level = 97,attr = [{2,38800},{4,1940},{5,1552},{8,1552}],exp = 1856};

get_fairy_level(1007,98) ->
	#fairy_level_cfg{fairy_id = 1007,level = 98,attr = [{2,39200},{4,1960},{5,1568},{8,1568}],exp = 1890};

get_fairy_level(1007,99) ->
	#fairy_level_cfg{fairy_id = 1007,level = 99,attr = [{2,39600},{4,1980},{5,1584},{8,1584}],exp = 1925};

get_fairy_level(1007,100) ->
	#fairy_level_cfg{fairy_id = 1007,level = 100,attr = [{2,40000},{4,2000},{5,1600},{8,1600}],exp = 0};

get_fairy_level(1008,0) ->
	#fairy_level_cfg{fairy_id = 1008,level = 0,attr = [{3,0},{4,0},{5,0},{8,0}],exp = 10};

get_fairy_level(1008,1) ->
	#fairy_level_cfg{fairy_id = 1008,level = 1,attr = [{3,20},{4,20},{5,16},{8,16}],exp = 11};

get_fairy_level(1008,2) ->
	#fairy_level_cfg{fairy_id = 1008,level = 2,attr = [{3,40},{4,40},{5,32},{8,32}],exp = 12};

get_fairy_level(1008,3) ->
	#fairy_level_cfg{fairy_id = 1008,level = 3,attr = [{3,60},{4,60},{5,48},{8,48}],exp = 14};

get_fairy_level(1008,4) ->
	#fairy_level_cfg{fairy_id = 1008,level = 4,attr = [{3,80},{4,80},{5,64},{8,64}],exp = 16};

get_fairy_level(1008,5) ->
	#fairy_level_cfg{fairy_id = 1008,level = 5,attr = [{3,100},{4,100},{5,80},{8,80}],exp = 18};

get_fairy_level(1008,6) ->
	#fairy_level_cfg{fairy_id = 1008,level = 6,attr = [{3,120},{4,120},{5,96},{8,96}],exp = 20};

get_fairy_level(1008,7) ->
	#fairy_level_cfg{fairy_id = 1008,level = 7,attr = [{3,140},{4,140},{5,112},{8,112}],exp = 23};

get_fairy_level(1008,8) ->
	#fairy_level_cfg{fairy_id = 1008,level = 8,attr = [{3,160},{4,160},{5,128},{8,128}],exp = 26};

get_fairy_level(1008,9) ->
	#fairy_level_cfg{fairy_id = 1008,level = 9,attr = [{3,180},{4,180},{5,144},{8,144}],exp = 29};

get_fairy_level(1008,10) ->
	#fairy_level_cfg{fairy_id = 1008,level = 10,attr = [{3,200},{4,200},{5,160},{8,160}],exp = 32};

get_fairy_level(1008,11) ->
	#fairy_level_cfg{fairy_id = 1008,level = 11,attr = [{3,220},{4,220},{5,176},{8,176}],exp = 35};

get_fairy_level(1008,12) ->
	#fairy_level_cfg{fairy_id = 1008,level = 12,attr = [{3,240},{4,240},{5,192},{8,192}],exp = 39};

get_fairy_level(1008,13) ->
	#fairy_level_cfg{fairy_id = 1008,level = 13,attr = [{3,260},{4,260},{5,208},{8,208}],exp = 43};

get_fairy_level(1008,14) ->
	#fairy_level_cfg{fairy_id = 1008,level = 14,attr = [{3,280},{4,280},{5,224},{8,224}],exp = 47};

get_fairy_level(1008,15) ->
	#fairy_level_cfg{fairy_id = 1008,level = 15,attr = [{3,300},{4,300},{5,240},{8,240}],exp = 52};

get_fairy_level(1008,16) ->
	#fairy_level_cfg{fairy_id = 1008,level = 16,attr = [{3,320},{4,320},{5,256},{8,256}],exp = 57};

get_fairy_level(1008,17) ->
	#fairy_level_cfg{fairy_id = 1008,level = 17,attr = [{3,340},{4,340},{5,272},{8,272}],exp = 63};

get_fairy_level(1008,18) ->
	#fairy_level_cfg{fairy_id = 1008,level = 18,attr = [{3,360},{4,360},{5,288},{8,288}],exp = 69};

get_fairy_level(1008,19) ->
	#fairy_level_cfg{fairy_id = 1008,level = 19,attr = [{3,380},{4,380},{5,304},{8,304}],exp = 76};

get_fairy_level(1008,20) ->
	#fairy_level_cfg{fairy_id = 1008,level = 20,attr = [{3,400},{4,400},{5,320},{8,320}],exp = 82};

get_fairy_level(1008,21) ->
	#fairy_level_cfg{fairy_id = 1008,level = 21,attr = [{3,420},{4,420},{5,336},{8,336}],exp = 89};

get_fairy_level(1008,22) ->
	#fairy_level_cfg{fairy_id = 1008,level = 22,attr = [{3,440},{4,440},{5,352},{8,352}],exp = 96};

get_fairy_level(1008,23) ->
	#fairy_level_cfg{fairy_id = 1008,level = 23,attr = [{3,460},{4,460},{5,368},{8,368}],exp = 104};

get_fairy_level(1008,24) ->
	#fairy_level_cfg{fairy_id = 1008,level = 24,attr = [{3,480},{4,480},{5,384},{8,384}],exp = 113};

get_fairy_level(1008,25) ->
	#fairy_level_cfg{fairy_id = 1008,level = 25,attr = [{3,500},{4,500},{5,400},{8,400}],exp = 122};

get_fairy_level(1008,26) ->
	#fairy_level_cfg{fairy_id = 1008,level = 26,attr = [{3,520},{4,520},{5,416},{8,416}],exp = 132};

get_fairy_level(1008,27) ->
	#fairy_level_cfg{fairy_id = 1008,level = 27,attr = [{3,540},{4,540},{5,432},{8,432}],exp = 143};

get_fairy_level(1008,28) ->
	#fairy_level_cfg{fairy_id = 1008,level = 28,attr = [{3,560},{4,560},{5,448},{8,448}],exp = 155};

get_fairy_level(1008,29) ->
	#fairy_level_cfg{fairy_id = 1008,level = 29,attr = [{3,580},{4,580},{5,464},{8,464}],exp = 168};

get_fairy_level(1008,30) ->
	#fairy_level_cfg{fairy_id = 1008,level = 30,attr = [{3,600},{4,600},{5,480},{8,480}],exp = 179};

get_fairy_level(1008,31) ->
	#fairy_level_cfg{fairy_id = 1008,level = 31,attr = [{3,620},{4,620},{5,496},{8,496}],exp = 190};

get_fairy_level(1008,32) ->
	#fairy_level_cfg{fairy_id = 1008,level = 32,attr = [{3,640},{4,640},{5,512},{8,512}],exp = 202};

get_fairy_level(1008,33) ->
	#fairy_level_cfg{fairy_id = 1008,level = 33,attr = [{3,660},{4,660},{5,528},{8,528}],exp = 215};

get_fairy_level(1008,34) ->
	#fairy_level_cfg{fairy_id = 1008,level = 34,attr = [{3,680},{4,680},{5,544},{8,544}],exp = 228};

get_fairy_level(1008,35) ->
	#fairy_level_cfg{fairy_id = 1008,level = 35,attr = [{3,700},{4,700},{5,560},{8,560}],exp = 242};

get_fairy_level(1008,36) ->
	#fairy_level_cfg{fairy_id = 1008,level = 36,attr = [{3,720},{4,720},{5,576},{8,576}],exp = 257};

get_fairy_level(1008,37) ->
	#fairy_level_cfg{fairy_id = 1008,level = 37,attr = [{3,740},{4,740},{5,592},{8,592}],exp = 273};

get_fairy_level(1008,38) ->
	#fairy_level_cfg{fairy_id = 1008,level = 38,attr = [{3,760},{4,760},{5,608},{8,608}],exp = 290};

get_fairy_level(1008,39) ->
	#fairy_level_cfg{fairy_id = 1008,level = 39,attr = [{3,780},{4,780},{5,624},{8,624}],exp = 308};

get_fairy_level(1008,40) ->
	#fairy_level_cfg{fairy_id = 1008,level = 40,attr = [{3,800},{4,800},{5,640},{8,640}],exp = 323};

get_fairy_level(1008,41) ->
	#fairy_level_cfg{fairy_id = 1008,level = 41,attr = [{3,820},{4,820},{5,656},{8,656}],exp = 339};

get_fairy_level(1008,42) ->
	#fairy_level_cfg{fairy_id = 1008,level = 42,attr = [{3,840},{4,840},{5,672},{8,672}],exp = 356};

get_fairy_level(1008,43) ->
	#fairy_level_cfg{fairy_id = 1008,level = 43,attr = [{3,860},{4,860},{5,688},{8,688}],exp = 374};

get_fairy_level(1008,44) ->
	#fairy_level_cfg{fairy_id = 1008,level = 44,attr = [{3,880},{4,880},{5,704},{8,704}],exp = 393};

get_fairy_level(1008,45) ->
	#fairy_level_cfg{fairy_id = 1008,level = 45,attr = [{3,900},{4,900},{5,720},{8,720}],exp = 413};

get_fairy_level(1008,46) ->
	#fairy_level_cfg{fairy_id = 1008,level = 46,attr = [{3,920},{4,920},{5,736},{8,736}],exp = 434};

get_fairy_level(1008,47) ->
	#fairy_level_cfg{fairy_id = 1008,level = 47,attr = [{3,940},{4,940},{5,752},{8,752}],exp = 456};

get_fairy_level(1008,48) ->
	#fairy_level_cfg{fairy_id = 1008,level = 48,attr = [{3,960},{4,960},{5,768},{8,768}],exp = 479};

get_fairy_level(1008,49) ->
	#fairy_level_cfg{fairy_id = 1008,level = 49,attr = [{3,980},{4,980},{5,784},{8,784}],exp = 503};

get_fairy_level(1008,50) ->
	#fairy_level_cfg{fairy_id = 1008,level = 50,attr = [{3,1000},{4,1000},{5,800},{8,800}],exp = 522};

get_fairy_level(1008,51) ->
	#fairy_level_cfg{fairy_id = 1008,level = 51,attr = [{3,1020},{4,1020},{5,816},{8,816}],exp = 542};

get_fairy_level(1008,52) ->
	#fairy_level_cfg{fairy_id = 1008,level = 52,attr = [{3,1040},{4,1040},{5,832},{8,832}],exp = 563};

get_fairy_level(1008,53) ->
	#fairy_level_cfg{fairy_id = 1008,level = 53,attr = [{3,1060},{4,1060},{5,848},{8,848}],exp = 585};

get_fairy_level(1008,54) ->
	#fairy_level_cfg{fairy_id = 1008,level = 54,attr = [{3,1080},{4,1080},{5,864},{8,864}],exp = 608};

get_fairy_level(1008,55) ->
	#fairy_level_cfg{fairy_id = 1008,level = 55,attr = [{3,1100},{4,1100},{5,880},{8,880}],exp = 631};

get_fairy_level(1008,56) ->
	#fairy_level_cfg{fairy_id = 1008,level = 56,attr = [{3,1120},{4,1120},{5,896},{8,896}],exp = 655};

get_fairy_level(1008,57) ->
	#fairy_level_cfg{fairy_id = 1008,level = 57,attr = [{3,1140},{4,1140},{5,912},{8,912}],exp = 680};

get_fairy_level(1008,58) ->
	#fairy_level_cfg{fairy_id = 1008,level = 58,attr = [{3,1160},{4,1160},{5,928},{8,928}],exp = 706};

get_fairy_level(1008,59) ->
	#fairy_level_cfg{fairy_id = 1008,level = 59,attr = [{3,1180},{4,1180},{5,944},{8,944}],exp = 733};

get_fairy_level(1008,60) ->
	#fairy_level_cfg{fairy_id = 1008,level = 60,attr = [{3,1200},{4,1200},{5,960},{8,960}],exp = 756};

get_fairy_level(1008,61) ->
	#fairy_level_cfg{fairy_id = 1008,level = 61,attr = [{3,1220},{4,1220},{5,976},{8,976}],exp = 780};

get_fairy_level(1008,62) ->
	#fairy_level_cfg{fairy_id = 1008,level = 62,attr = [{3,1240},{4,1240},{5,992},{8,992}],exp = 804};

get_fairy_level(1008,63) ->
	#fairy_level_cfg{fairy_id = 1008,level = 63,attr = [{3,1260},{4,1260},{5,1008},{8,1008}],exp = 829};

get_fairy_level(1008,64) ->
	#fairy_level_cfg{fairy_id = 1008,level = 64,attr = [{3,1280},{4,1280},{5,1024},{8,1024}],exp = 855};

get_fairy_level(1008,65) ->
	#fairy_level_cfg{fairy_id = 1008,level = 65,attr = [{3,1300},{4,1300},{5,1040},{8,1040}],exp = 882};

get_fairy_level(1008,66) ->
	#fairy_level_cfg{fairy_id = 1008,level = 66,attr = [{3,1320},{4,1320},{5,1056},{8,1056}],exp = 910};

get_fairy_level(1008,67) ->
	#fairy_level_cfg{fairy_id = 1008,level = 67,attr = [{3,1340},{4,1340},{5,1072},{8,1072}],exp = 938};

get_fairy_level(1008,68) ->
	#fairy_level_cfg{fairy_id = 1008,level = 68,attr = [{3,1360},{4,1360},{5,1088},{8,1088}],exp = 967};

get_fairy_level(1008,69) ->
	#fairy_level_cfg{fairy_id = 1008,level = 69,attr = [{3,1380},{4,1380},{5,1104},{8,1104}],exp = 997};

get_fairy_level(1008,70) ->
	#fairy_level_cfg{fairy_id = 1008,level = 70,attr = [{3,1400},{4,1400},{5,1120},{8,1120}],exp = 1023};

get_fairy_level(1008,71) ->
	#fairy_level_cfg{fairy_id = 1008,level = 71,attr = [{3,1420},{4,1420},{5,1136},{8,1136}],exp = 1050};

get_fairy_level(1008,72) ->
	#fairy_level_cfg{fairy_id = 1008,level = 72,attr = [{3,1440},{4,1440},{5,1152},{8,1152}],exp = 1078};

get_fairy_level(1008,73) ->
	#fairy_level_cfg{fairy_id = 1008,level = 73,attr = [{3,1460},{4,1460},{5,1168},{8,1168}],exp = 1106};

get_fairy_level(1008,74) ->
	#fairy_level_cfg{fairy_id = 1008,level = 74,attr = [{3,1480},{4,1480},{5,1184},{8,1184}],exp = 1135};

get_fairy_level(1008,75) ->
	#fairy_level_cfg{fairy_id = 1008,level = 75,attr = [{3,1500},{4,1500},{5,1200},{8,1200}],exp = 1165};

get_fairy_level(1008,76) ->
	#fairy_level_cfg{fairy_id = 1008,level = 76,attr = [{3,1520},{4,1520},{5,1216},{8,1216}],exp = 1196};

get_fairy_level(1008,77) ->
	#fairy_level_cfg{fairy_id = 1008,level = 77,attr = [{3,1540},{4,1540},{5,1232},{8,1232}],exp = 1227};

get_fairy_level(1008,78) ->
	#fairy_level_cfg{fairy_id = 1008,level = 78,attr = [{3,1560},{4,1560},{5,1248},{8,1248}],exp = 1259};

get_fairy_level(1008,79) ->
	#fairy_level_cfg{fairy_id = 1008,level = 79,attr = [{3,1580},{4,1580},{5,1264},{8,1264}],exp = 1292};

get_fairy_level(1008,80) ->
	#fairy_level_cfg{fairy_id = 1008,level = 80,attr = [{3,1600},{4,1600},{5,1280},{8,1280}],exp = 1320};

get_fairy_level(1008,81) ->
	#fairy_level_cfg{fairy_id = 1008,level = 81,attr = [{3,1620},{4,1620},{5,1296},{8,1296}],exp = 1349};

get_fairy_level(1008,82) ->
	#fairy_level_cfg{fairy_id = 1008,level = 82,attr = [{3,1640},{4,1640},{5,1312},{8,1312}],exp = 1378};

get_fairy_level(1008,83) ->
	#fairy_level_cfg{fairy_id = 1008,level = 83,attr = [{3,1660},{4,1660},{5,1328},{8,1328}],exp = 1408};

get_fairy_level(1008,84) ->
	#fairy_level_cfg{fairy_id = 1008,level = 84,attr = [{3,1680},{4,1680},{5,1344},{8,1344}],exp = 1439};

get_fairy_level(1008,85) ->
	#fairy_level_cfg{fairy_id = 1008,level = 85,attr = [{3,1700},{4,1700},{5,1360},{8,1360}],exp = 1470};

get_fairy_level(1008,86) ->
	#fairy_level_cfg{fairy_id = 1008,level = 86,attr = [{3,1720},{4,1720},{5,1376},{8,1376}],exp = 1502};

get_fairy_level(1008,87) ->
	#fairy_level_cfg{fairy_id = 1008,level = 87,attr = [{3,1740},{4,1740},{5,1392},{8,1392}],exp = 1535};

get_fairy_level(1008,88) ->
	#fairy_level_cfg{fairy_id = 1008,level = 88,attr = [{3,1760},{4,1760},{5,1408},{8,1408}],exp = 1568};

get_fairy_level(1008,89) ->
	#fairy_level_cfg{fairy_id = 1008,level = 89,attr = [{3,1780},{4,1780},{5,1424},{8,1424}],exp = 1602};

get_fairy_level(1008,90) ->
	#fairy_level_cfg{fairy_id = 1008,level = 90,attr = [{3,1800},{4,1800},{5,1440},{8,1440}],exp = 1632};

get_fairy_level(1008,91) ->
	#fairy_level_cfg{fairy_id = 1008,level = 91,attr = [{3,1820},{4,1820},{5,1456},{8,1456}],exp = 1662};

get_fairy_level(1008,92) ->
	#fairy_level_cfg{fairy_id = 1008,level = 92,attr = [{3,1840},{4,1840},{5,1472},{8,1472}],exp = 1693};

get_fairy_level(1008,93) ->
	#fairy_level_cfg{fairy_id = 1008,level = 93,attr = [{3,1860},{4,1860},{5,1488},{8,1488}],exp = 1724};

get_fairy_level(1008,94) ->
	#fairy_level_cfg{fairy_id = 1008,level = 94,attr = [{3,1880},{4,1880},{5,1504},{8,1504}],exp = 1756};

get_fairy_level(1008,95) ->
	#fairy_level_cfg{fairy_id = 1008,level = 95,attr = [{3,1900},{4,1900},{5,1520},{8,1520}],exp = 1789};

get_fairy_level(1008,96) ->
	#fairy_level_cfg{fairy_id = 1008,level = 96,attr = [{3,1920},{4,1920},{5,1536},{8,1536}],exp = 1822};

get_fairy_level(1008,97) ->
	#fairy_level_cfg{fairy_id = 1008,level = 97,attr = [{3,1940},{4,1940},{5,1552},{8,1552}],exp = 1856};

get_fairy_level(1008,98) ->
	#fairy_level_cfg{fairy_id = 1008,level = 98,attr = [{3,1960},{4,1960},{5,1568},{8,1568}],exp = 1890};

get_fairy_level(1008,99) ->
	#fairy_level_cfg{fairy_id = 1008,level = 99,attr = [{3,1980},{4,1980},{5,1584},{8,1584}],exp = 1925};

get_fairy_level(1008,100) ->
	#fairy_level_cfg{fairy_id = 1008,level = 100,attr = [{3,2000},{4,2000},{5,1600},{8,1600}],exp = 0};

get_fairy_level(1009,0) ->
	#fairy_level_cfg{fairy_id = 1009,level = 0,attr = [{1,0},{3,0},{7,0},{6,0}],exp = 10};

get_fairy_level(1009,1) ->
	#fairy_level_cfg{fairy_id = 1009,level = 1,attr = [{1,20},{3,20},{7,16},{6,16}],exp = 11};

get_fairy_level(1009,2) ->
	#fairy_level_cfg{fairy_id = 1009,level = 2,attr = [{1,40},{3,40},{7,32},{6,32}],exp = 12};

get_fairy_level(1009,3) ->
	#fairy_level_cfg{fairy_id = 1009,level = 3,attr = [{1,60},{3,60},{7,48},{6,48}],exp = 14};

get_fairy_level(1009,4) ->
	#fairy_level_cfg{fairy_id = 1009,level = 4,attr = [{1,80},{3,80},{7,64},{6,64}],exp = 16};

get_fairy_level(1009,5) ->
	#fairy_level_cfg{fairy_id = 1009,level = 5,attr = [{1,100},{3,100},{7,80},{6,80}],exp = 18};

get_fairy_level(1009,6) ->
	#fairy_level_cfg{fairy_id = 1009,level = 6,attr = [{1,120},{3,120},{7,96},{6,96}],exp = 20};

get_fairy_level(1009,7) ->
	#fairy_level_cfg{fairy_id = 1009,level = 7,attr = [{1,140},{3,140},{7,112},{6,112}],exp = 23};

get_fairy_level(1009,8) ->
	#fairy_level_cfg{fairy_id = 1009,level = 8,attr = [{1,160},{3,160},{7,128},{6,128}],exp = 26};

get_fairy_level(1009,9) ->
	#fairy_level_cfg{fairy_id = 1009,level = 9,attr = [{1,180},{3,180},{7,144},{6,144}],exp = 29};

get_fairy_level(1009,10) ->
	#fairy_level_cfg{fairy_id = 1009,level = 10,attr = [{1,200},{3,200},{7,160},{6,160}],exp = 32};

get_fairy_level(1009,11) ->
	#fairy_level_cfg{fairy_id = 1009,level = 11,attr = [{1,220},{3,220},{7,176},{6,176}],exp = 35};

get_fairy_level(1009,12) ->
	#fairy_level_cfg{fairy_id = 1009,level = 12,attr = [{1,240},{3,240},{7,192},{6,192}],exp = 39};

get_fairy_level(1009,13) ->
	#fairy_level_cfg{fairy_id = 1009,level = 13,attr = [{1,260},{3,260},{7,208},{6,208}],exp = 43};

get_fairy_level(1009,14) ->
	#fairy_level_cfg{fairy_id = 1009,level = 14,attr = [{1,280},{3,280},{7,224},{6,224}],exp = 47};

get_fairy_level(1009,15) ->
	#fairy_level_cfg{fairy_id = 1009,level = 15,attr = [{1,300},{3,300},{7,240},{6,240}],exp = 52};

get_fairy_level(1009,16) ->
	#fairy_level_cfg{fairy_id = 1009,level = 16,attr = [{1,320},{3,320},{7,256},{6,256}],exp = 57};

get_fairy_level(1009,17) ->
	#fairy_level_cfg{fairy_id = 1009,level = 17,attr = [{1,340},{3,340},{7,272},{6,272}],exp = 63};

get_fairy_level(1009,18) ->
	#fairy_level_cfg{fairy_id = 1009,level = 18,attr = [{1,360},{3,360},{7,288},{6,288}],exp = 69};

get_fairy_level(1009,19) ->
	#fairy_level_cfg{fairy_id = 1009,level = 19,attr = [{1,380},{3,380},{7,304},{6,304}],exp = 76};

get_fairy_level(1009,20) ->
	#fairy_level_cfg{fairy_id = 1009,level = 20,attr = [{1,400},{3,400},{7,320},{6,320}],exp = 82};

get_fairy_level(1009,21) ->
	#fairy_level_cfg{fairy_id = 1009,level = 21,attr = [{1,420},{3,420},{7,336},{6,336}],exp = 89};

get_fairy_level(1009,22) ->
	#fairy_level_cfg{fairy_id = 1009,level = 22,attr = [{1,440},{3,440},{7,352},{6,352}],exp = 96};

get_fairy_level(1009,23) ->
	#fairy_level_cfg{fairy_id = 1009,level = 23,attr = [{1,460},{3,460},{7,368},{6,368}],exp = 104};

get_fairy_level(1009,24) ->
	#fairy_level_cfg{fairy_id = 1009,level = 24,attr = [{1,480},{3,480},{7,384},{6,384}],exp = 113};

get_fairy_level(1009,25) ->
	#fairy_level_cfg{fairy_id = 1009,level = 25,attr = [{1,500},{3,500},{7,400},{6,400}],exp = 122};

get_fairy_level(1009,26) ->
	#fairy_level_cfg{fairy_id = 1009,level = 26,attr = [{1,520},{3,520},{7,416},{6,416}],exp = 132};

get_fairy_level(1009,27) ->
	#fairy_level_cfg{fairy_id = 1009,level = 27,attr = [{1,540},{3,540},{7,432},{6,432}],exp = 143};

get_fairy_level(1009,28) ->
	#fairy_level_cfg{fairy_id = 1009,level = 28,attr = [{1,560},{3,560},{7,448},{6,448}],exp = 155};

get_fairy_level(1009,29) ->
	#fairy_level_cfg{fairy_id = 1009,level = 29,attr = [{1,580},{3,580},{7,464},{6,464}],exp = 168};

get_fairy_level(1009,30) ->
	#fairy_level_cfg{fairy_id = 1009,level = 30,attr = [{1,600},{3,600},{7,480},{6,480}],exp = 179};

get_fairy_level(1009,31) ->
	#fairy_level_cfg{fairy_id = 1009,level = 31,attr = [{1,620},{3,620},{7,496},{6,496}],exp = 190};

get_fairy_level(1009,32) ->
	#fairy_level_cfg{fairy_id = 1009,level = 32,attr = [{1,640},{3,640},{7,512},{6,512}],exp = 202};

get_fairy_level(1009,33) ->
	#fairy_level_cfg{fairy_id = 1009,level = 33,attr = [{1,660},{3,660},{7,528},{6,528}],exp = 215};

get_fairy_level(1009,34) ->
	#fairy_level_cfg{fairy_id = 1009,level = 34,attr = [{1,680},{3,680},{7,544},{6,544}],exp = 228};

get_fairy_level(1009,35) ->
	#fairy_level_cfg{fairy_id = 1009,level = 35,attr = [{1,700},{3,700},{7,560},{6,560}],exp = 242};

get_fairy_level(1009,36) ->
	#fairy_level_cfg{fairy_id = 1009,level = 36,attr = [{1,720},{3,720},{7,576},{6,576}],exp = 257};

get_fairy_level(1009,37) ->
	#fairy_level_cfg{fairy_id = 1009,level = 37,attr = [{1,740},{3,740},{7,592},{6,592}],exp = 273};

get_fairy_level(1009,38) ->
	#fairy_level_cfg{fairy_id = 1009,level = 38,attr = [{1,760},{3,760},{7,608},{6,608}],exp = 290};

get_fairy_level(1009,39) ->
	#fairy_level_cfg{fairy_id = 1009,level = 39,attr = [{1,780},{3,780},{7,624},{6,624}],exp = 308};

get_fairy_level(1009,40) ->
	#fairy_level_cfg{fairy_id = 1009,level = 40,attr = [{1,800},{3,800},{7,640},{6,640}],exp = 323};

get_fairy_level(1009,41) ->
	#fairy_level_cfg{fairy_id = 1009,level = 41,attr = [{1,820},{3,820},{7,656},{6,656}],exp = 339};

get_fairy_level(1009,42) ->
	#fairy_level_cfg{fairy_id = 1009,level = 42,attr = [{1,840},{3,840},{7,672},{6,672}],exp = 356};

get_fairy_level(1009,43) ->
	#fairy_level_cfg{fairy_id = 1009,level = 43,attr = [{1,860},{3,860},{7,688},{6,688}],exp = 374};

get_fairy_level(1009,44) ->
	#fairy_level_cfg{fairy_id = 1009,level = 44,attr = [{1,880},{3,880},{7,704},{6,704}],exp = 393};

get_fairy_level(1009,45) ->
	#fairy_level_cfg{fairy_id = 1009,level = 45,attr = [{1,900},{3,900},{7,720},{6,720}],exp = 413};

get_fairy_level(1009,46) ->
	#fairy_level_cfg{fairy_id = 1009,level = 46,attr = [{1,920},{3,920},{7,736},{6,736}],exp = 434};

get_fairy_level(1009,47) ->
	#fairy_level_cfg{fairy_id = 1009,level = 47,attr = [{1,940},{3,940},{7,752},{6,752}],exp = 456};

get_fairy_level(1009,48) ->
	#fairy_level_cfg{fairy_id = 1009,level = 48,attr = [{1,960},{3,960},{7,768},{6,768}],exp = 479};

get_fairy_level(1009,49) ->
	#fairy_level_cfg{fairy_id = 1009,level = 49,attr = [{1,980},{3,980},{7,784},{6,784}],exp = 503};

get_fairy_level(1009,50) ->
	#fairy_level_cfg{fairy_id = 1009,level = 50,attr = [{1,1000},{3,1000},{7,800},{6,800}],exp = 522};

get_fairy_level(1009,51) ->
	#fairy_level_cfg{fairy_id = 1009,level = 51,attr = [{1,1020},{3,1020},{7,816},{6,816}],exp = 542};

get_fairy_level(1009,52) ->
	#fairy_level_cfg{fairy_id = 1009,level = 52,attr = [{1,1040},{3,1040},{7,832},{6,832}],exp = 563};

get_fairy_level(1009,53) ->
	#fairy_level_cfg{fairy_id = 1009,level = 53,attr = [{1,1060},{3,1060},{7,848},{6,848}],exp = 585};

get_fairy_level(1009,54) ->
	#fairy_level_cfg{fairy_id = 1009,level = 54,attr = [{1,1080},{3,1080},{7,864},{6,864}],exp = 608};

get_fairy_level(1009,55) ->
	#fairy_level_cfg{fairy_id = 1009,level = 55,attr = [{1,1100},{3,1100},{7,880},{6,880}],exp = 631};

get_fairy_level(1009,56) ->
	#fairy_level_cfg{fairy_id = 1009,level = 56,attr = [{1,1120},{3,1120},{7,896},{6,896}],exp = 655};

get_fairy_level(1009,57) ->
	#fairy_level_cfg{fairy_id = 1009,level = 57,attr = [{1,1140},{3,1140},{7,912},{6,912}],exp = 680};

get_fairy_level(1009,58) ->
	#fairy_level_cfg{fairy_id = 1009,level = 58,attr = [{1,1160},{3,1160},{7,928},{6,928}],exp = 706};

get_fairy_level(1009,59) ->
	#fairy_level_cfg{fairy_id = 1009,level = 59,attr = [{1,1180},{3,1180},{7,944},{6,944}],exp = 733};

get_fairy_level(1009,60) ->
	#fairy_level_cfg{fairy_id = 1009,level = 60,attr = [{1,1200},{3,1200},{7,960},{6,960}],exp = 756};

get_fairy_level(1009,61) ->
	#fairy_level_cfg{fairy_id = 1009,level = 61,attr = [{1,1220},{3,1220},{7,976},{6,976}],exp = 780};

get_fairy_level(1009,62) ->
	#fairy_level_cfg{fairy_id = 1009,level = 62,attr = [{1,1240},{3,1240},{7,992},{6,992}],exp = 804};

get_fairy_level(1009,63) ->
	#fairy_level_cfg{fairy_id = 1009,level = 63,attr = [{1,1260},{3,1260},{7,1008},{6,1008}],exp = 829};

get_fairy_level(1009,64) ->
	#fairy_level_cfg{fairy_id = 1009,level = 64,attr = [{1,1280},{3,1280},{7,1024},{6,1024}],exp = 855};

get_fairy_level(1009,65) ->
	#fairy_level_cfg{fairy_id = 1009,level = 65,attr = [{1,1300},{3,1300},{7,1040},{6,1040}],exp = 882};

get_fairy_level(1009,66) ->
	#fairy_level_cfg{fairy_id = 1009,level = 66,attr = [{1,1320},{3,1320},{7,1056},{6,1056}],exp = 910};

get_fairy_level(1009,67) ->
	#fairy_level_cfg{fairy_id = 1009,level = 67,attr = [{1,1340},{3,1340},{7,1072},{6,1072}],exp = 938};

get_fairy_level(1009,68) ->
	#fairy_level_cfg{fairy_id = 1009,level = 68,attr = [{1,1360},{3,1360},{7,1088},{6,1088}],exp = 967};

get_fairy_level(1009,69) ->
	#fairy_level_cfg{fairy_id = 1009,level = 69,attr = [{1,1380},{3,1380},{7,1104},{6,1104}],exp = 997};

get_fairy_level(1009,70) ->
	#fairy_level_cfg{fairy_id = 1009,level = 70,attr = [{1,1400},{3,1400},{7,1120},{6,1120}],exp = 1023};

get_fairy_level(1009,71) ->
	#fairy_level_cfg{fairy_id = 1009,level = 71,attr = [{1,1420},{3,1420},{7,1136},{6,1136}],exp = 1050};

get_fairy_level(1009,72) ->
	#fairy_level_cfg{fairy_id = 1009,level = 72,attr = [{1,1440},{3,1440},{7,1152},{6,1152}],exp = 1078};

get_fairy_level(1009,73) ->
	#fairy_level_cfg{fairy_id = 1009,level = 73,attr = [{1,1460},{3,1460},{7,1168},{6,1168}],exp = 1106};

get_fairy_level(1009,74) ->
	#fairy_level_cfg{fairy_id = 1009,level = 74,attr = [{1,1480},{3,1480},{7,1184},{6,1184}],exp = 1135};

get_fairy_level(1009,75) ->
	#fairy_level_cfg{fairy_id = 1009,level = 75,attr = [{1,1500},{3,1500},{7,1200},{6,1200}],exp = 1165};

get_fairy_level(1009,76) ->
	#fairy_level_cfg{fairy_id = 1009,level = 76,attr = [{1,1520},{3,1520},{7,1216},{6,1216}],exp = 1196};

get_fairy_level(1009,77) ->
	#fairy_level_cfg{fairy_id = 1009,level = 77,attr = [{1,1540},{3,1540},{7,1232},{6,1232}],exp = 1227};

get_fairy_level(1009,78) ->
	#fairy_level_cfg{fairy_id = 1009,level = 78,attr = [{1,1560},{3,1560},{7,1248},{6,1248}],exp = 1259};

get_fairy_level(1009,79) ->
	#fairy_level_cfg{fairy_id = 1009,level = 79,attr = [{1,1580},{3,1580},{7,1264},{6,1264}],exp = 1292};

get_fairy_level(1009,80) ->
	#fairy_level_cfg{fairy_id = 1009,level = 80,attr = [{1,1600},{3,1600},{7,1280},{6,1280}],exp = 1320};

get_fairy_level(1009,81) ->
	#fairy_level_cfg{fairy_id = 1009,level = 81,attr = [{1,1620},{3,1620},{7,1296},{6,1296}],exp = 1349};

get_fairy_level(1009,82) ->
	#fairy_level_cfg{fairy_id = 1009,level = 82,attr = [{1,1640},{3,1640},{7,1312},{6,1312}],exp = 1378};

get_fairy_level(1009,83) ->
	#fairy_level_cfg{fairy_id = 1009,level = 83,attr = [{1,1660},{3,1660},{7,1328},{6,1328}],exp = 1408};

get_fairy_level(1009,84) ->
	#fairy_level_cfg{fairy_id = 1009,level = 84,attr = [{1,1680},{3,1680},{7,1344},{6,1344}],exp = 1439};

get_fairy_level(1009,85) ->
	#fairy_level_cfg{fairy_id = 1009,level = 85,attr = [{1,1700},{3,1700},{7,1360},{6,1360}],exp = 1470};

get_fairy_level(1009,86) ->
	#fairy_level_cfg{fairy_id = 1009,level = 86,attr = [{1,1720},{3,1720},{7,1376},{6,1376}],exp = 1502};

get_fairy_level(1009,87) ->
	#fairy_level_cfg{fairy_id = 1009,level = 87,attr = [{1,1740},{3,1740},{7,1392},{6,1392}],exp = 1535};

get_fairy_level(1009,88) ->
	#fairy_level_cfg{fairy_id = 1009,level = 88,attr = [{1,1760},{3,1760},{7,1408},{6,1408}],exp = 1568};

get_fairy_level(1009,89) ->
	#fairy_level_cfg{fairy_id = 1009,level = 89,attr = [{1,1780},{3,1780},{7,1424},{6,1424}],exp = 1602};

get_fairy_level(1009,90) ->
	#fairy_level_cfg{fairy_id = 1009,level = 90,attr = [{1,1800},{3,1800},{7,1440},{6,1440}],exp = 1632};

get_fairy_level(1009,91) ->
	#fairy_level_cfg{fairy_id = 1009,level = 91,attr = [{1,1820},{3,1820},{7,1456},{6,1456}],exp = 1662};

get_fairy_level(1009,92) ->
	#fairy_level_cfg{fairy_id = 1009,level = 92,attr = [{1,1840},{3,1840},{7,1472},{6,1472}],exp = 1693};

get_fairy_level(1009,93) ->
	#fairy_level_cfg{fairy_id = 1009,level = 93,attr = [{1,1860},{3,1860},{7,1488},{6,1488}],exp = 1724};

get_fairy_level(1009,94) ->
	#fairy_level_cfg{fairy_id = 1009,level = 94,attr = [{1,1880},{3,1880},{7,1504},{6,1504}],exp = 1756};

get_fairy_level(1009,95) ->
	#fairy_level_cfg{fairy_id = 1009,level = 95,attr = [{1,1900},{3,1900},{7,1520},{6,1520}],exp = 1789};

get_fairy_level(1009,96) ->
	#fairy_level_cfg{fairy_id = 1009,level = 96,attr = [{1,1920},{3,1920},{7,1536},{6,1536}],exp = 1822};

get_fairy_level(1009,97) ->
	#fairy_level_cfg{fairy_id = 1009,level = 97,attr = [{1,1940},{3,1940},{7,1552},{6,1552}],exp = 1856};

get_fairy_level(1009,98) ->
	#fairy_level_cfg{fairy_id = 1009,level = 98,attr = [{1,1960},{3,1960},{7,1568},{6,1568}],exp = 1890};

get_fairy_level(1009,99) ->
	#fairy_level_cfg{fairy_id = 1009,level = 99,attr = [{1,1980},{3,1980},{7,1584},{6,1584}],exp = 1925};

get_fairy_level(1009,100) ->
	#fairy_level_cfg{fairy_id = 1009,level = 100,attr = [{1,2000},{3,2000},{7,1600},{6,1600}],exp = 0};

get_fairy_level(_Fairyid,_Level) ->
	[].

