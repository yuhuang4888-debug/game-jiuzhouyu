%%%---------------------------------------
%%% module      : data_equip_spirit
%%% description : 装备铸灵配置
%%%
%%%---------------------------------------
-module(data_equip_spirit).
-compile(export_all).
-include("goods.hrl").



get_stage_cfg(1,1) ->
	#casting_spirit_stage_cfg{pos = 1,stage = 1,score = 0,max_lv = 10,attr = []};

get_stage_cfg(1,2) ->
	#casting_spirit_stage_cfg{pos = 1,stage = 2,score = 24000,max_lv = 20,attr = [{19,120}]};

get_stage_cfg(1,3) ->
	#casting_spirit_stage_cfg{pos = 1,stage = 3,score = 48000,max_lv = 30,attr = [{13,100}]};

get_stage_cfg(1,4) ->
	#casting_spirit_stage_cfg{pos = 1,stage = 4,score = 72000,max_lv = 40,attr = [{9,90}]};

get_stage_cfg(1,5) ->
	#casting_spirit_stage_cfg{pos = 1,stage = 5,score = 96000,max_lv = 50,attr = [{11,100}]};

get_stage_cfg(2,1) ->
	#casting_spirit_stage_cfg{pos = 2,stage = 1,score = 8000,max_lv = 10,attr = []};

get_stage_cfg(2,2) ->
	#casting_spirit_stage_cfg{pos = 2,stage = 2,score = 32000,max_lv = 20,attr = [{12,100}]};

get_stage_cfg(2,3) ->
	#casting_spirit_stage_cfg{pos = 2,stage = 3,score = 56000,max_lv = 30,attr = [{20,120}]};

get_stage_cfg(2,4) ->
	#casting_spirit_stage_cfg{pos = 2,stage = 4,score = 80000,max_lv = 40,attr = [{28,300}]};

get_stage_cfg(2,5) ->
	#casting_spirit_stage_cfg{pos = 2,stage = 5,score = 104000,max_lv = 50,attr = [{22,240}]};

get_stage_cfg(3,1) ->
	#casting_spirit_stage_cfg{pos = 3,stage = 1,score = 10000,max_lv = 10,attr = []};

get_stage_cfg(3,2) ->
	#casting_spirit_stage_cfg{pos = 3,stage = 2,score = 34000,max_lv = 20,attr = [{11,100}]};

get_stage_cfg(3,3) ->
	#casting_spirit_stage_cfg{pos = 3,stage = 3,score = 58000,max_lv = 30,attr = [{19,120}]};

get_stage_cfg(3,4) ->
	#casting_spirit_stage_cfg{pos = 3,stage = 4,score = 82000,max_lv = 40,attr = [{27,300}]};

get_stage_cfg(3,5) ->
	#casting_spirit_stage_cfg{pos = 3,stage = 5,score = 106000,max_lv = 50,attr = [{21,240}]};

get_stage_cfg(4,1) ->
	#casting_spirit_stage_cfg{pos = 4,stage = 1,score = 6000,max_lv = 10,attr = []};

get_stage_cfg(4,2) ->
	#casting_spirit_stage_cfg{pos = 4,stage = 2,score = 30000,max_lv = 20,attr = [{20,120}]};

get_stage_cfg(4,3) ->
	#casting_spirit_stage_cfg{pos = 4,stage = 3,score = 54000,max_lv = 30,attr = [{12,100}]};

get_stage_cfg(4,4) ->
	#casting_spirit_stage_cfg{pos = 4,stage = 4,score = 78000,max_lv = 40,attr = [{22,240}]};

get_stage_cfg(4,5) ->
	#casting_spirit_stage_cfg{pos = 4,stage = 5,score = 102000,max_lv = 50,attr = [{28,300}]};

get_stage_cfg(5,1) ->
	#casting_spirit_stage_cfg{pos = 5,stage = 1,score = 12000,max_lv = 10,attr = []};

get_stage_cfg(5,2) ->
	#casting_spirit_stage_cfg{pos = 5,stage = 2,score = 36000,max_lv = 20,attr = [{27,300}]};

get_stage_cfg(5,3) ->
	#casting_spirit_stage_cfg{pos = 5,stage = 3,score = 60000,max_lv = 30,attr = [{11,100}]};

get_stage_cfg(5,4) ->
	#casting_spirit_stage_cfg{pos = 5,stage = 4,score = 84000,max_lv = 40,attr = [{19,120}]};

get_stage_cfg(5,5) ->
	#casting_spirit_stage_cfg{pos = 5,stage = 5,score = 108000,max_lv = 50,attr = [{13,100}]};

get_stage_cfg(6,1) ->
	#casting_spirit_stage_cfg{pos = 6,stage = 1,score = 16000,max_lv = 10,attr = []};

get_stage_cfg(6,2) ->
	#casting_spirit_stage_cfg{pos = 6,stage = 2,score = 40000,max_lv = 20,attr = [{14,100}]};

get_stage_cfg(6,3) ->
	#casting_spirit_stage_cfg{pos = 6,stage = 3,score = 64000,max_lv = 30,attr = [{22,240}]};

get_stage_cfg(6,4) ->
	#casting_spirit_stage_cfg{pos = 6,stage = 4,score = 88000,max_lv = 40,attr = [{10,90}]};

get_stage_cfg(6,5) ->
	#casting_spirit_stage_cfg{pos = 6,stage = 5,score = 112000,max_lv = 50,attr = [{20,120}]};

get_stage_cfg(7,1) ->
	#casting_spirit_stage_cfg{pos = 7,stage = 1,score = 1000,max_lv = 10,attr = []};

get_stage_cfg(7,2) ->
	#casting_spirit_stage_cfg{pos = 7,stage = 2,score = 26000,max_lv = 20,attr = [{9,90}]};

get_stage_cfg(7,3) ->
	#casting_spirit_stage_cfg{pos = 7,stage = 3,score = 50000,max_lv = 30,attr = [{21,240}]};

get_stage_cfg(7,4) ->
	#casting_spirit_stage_cfg{pos = 7,stage = 4,score = 74000,max_lv = 40,attr = [{17,100}]};

get_stage_cfg(7,5) ->
	#casting_spirit_stage_cfg{pos = 7,stage = 5,score = 98000,max_lv = 50,attr = [{27,300}]};

get_stage_cfg(8,1) ->
	#casting_spirit_stage_cfg{pos = 8,stage = 1,score = 14000,max_lv = 10,attr = []};

get_stage_cfg(8,2) ->
	#casting_spirit_stage_cfg{pos = 8,stage = 2,score = 38000,max_lv = 20,attr = [{10,90}]};

get_stage_cfg(8,3) ->
	#casting_spirit_stage_cfg{pos = 8,stage = 3,score = 62000,max_lv = 30,attr = [{28,300}]};

get_stage_cfg(8,4) ->
	#casting_spirit_stage_cfg{pos = 8,stage = 4,score = 86000,max_lv = 40,attr = [{20,120}]};

get_stage_cfg(8,5) ->
	#casting_spirit_stage_cfg{pos = 8,stage = 5,score = 110000,max_lv = 50,attr = [{14,100}]};

get_stage_cfg(9,1) ->
	#casting_spirit_stage_cfg{pos = 9,stage = 1,score = 2000,max_lv = 10,attr = []};

get_stage_cfg(9,2) ->
	#casting_spirit_stage_cfg{pos = 9,stage = 2,score = 28000,max_lv = 20,attr = [{21,240}]};

get_stage_cfg(9,3) ->
	#casting_spirit_stage_cfg{pos = 9,stage = 3,score = 52000,max_lv = 30,attr = [{17,100}]};

get_stage_cfg(9,4) ->
	#casting_spirit_stage_cfg{pos = 9,stage = 4,score = 76000,max_lv = 40,attr = [{13,100}]};

get_stage_cfg(9,5) ->
	#casting_spirit_stage_cfg{pos = 9,stage = 5,score = 100000,max_lv = 50,attr = [{9,90}]};

get_stage_cfg(10,1) ->
	#casting_spirit_stage_cfg{pos = 10,stage = 1,score = 18000,max_lv = 10,attr = []};

get_stage_cfg(10,2) ->
	#casting_spirit_stage_cfg{pos = 10,stage = 2,score = 42000,max_lv = 20,attr = [{22,240}]};

get_stage_cfg(10,3) ->
	#casting_spirit_stage_cfg{pos = 10,stage = 3,score = 66000,max_lv = 30,attr = [{10,90}]};

get_stage_cfg(10,4) ->
	#casting_spirit_stage_cfg{pos = 10,stage = 4,score = 90000,max_lv = 40,attr = [{14,100}]};

get_stage_cfg(10,5) ->
	#casting_spirit_stage_cfg{pos = 10,stage = 5,score = 114000,max_lv = 50,attr = [{12,100}]};

get_stage_cfg(_Pos,_Stage) ->
	[].

get_lv_cfg(1,1,0) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(1,1,1) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(1,1,2) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(1,1,3) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(1,1,4) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(1,1,5) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(1,1,6) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(1,1,7) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(1,1,8) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(1,1,9) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(1,1,10) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(1,2,1) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(1,2,2) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(1,2,3) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(1,2,4) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(1,2,5) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(1,2,6) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(1,2,7) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(1,2,8) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(1,2,9) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(1,2,10) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(1,2,11) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(1,2,12) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(1,2,13) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(1,2,14) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(1,2,15) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(1,2,16) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(1,2,17) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(1,2,18) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(1,2,19) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(1,2,20) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(1,3,1) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(1,3,2) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(1,3,3) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(1,3,4) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(1,3,5) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(1,3,6) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(1,3,7) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(1,3,8) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(1,3,9) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(1,3,10) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(1,3,11) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(1,3,12) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(1,3,13) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(1,3,14) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(1,3,15) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(1,3,16) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(1,3,17) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(1,3,18) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(1,3,19) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(1,3,20) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(1,3,21) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(1,3,22) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(1,3,23) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(1,3,24) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(1,3,25) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(1,3,26) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(1,3,27) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(1,3,28) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(1,3,29) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(1,3,30) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(1,4,1) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(1,4,2) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(1,4,3) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(1,4,4) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(1,4,5) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(1,4,6) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(1,4,7) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(1,4,8) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(1,4,9) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(1,4,10) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(1,4,11) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(1,4,12) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(1,4,13) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(1,4,14) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(1,4,15) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(1,4,16) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(1,4,17) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(1,4,18) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(1,4,19) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(1,4,20) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(1,4,21) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(1,4,22) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(1,4,23) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(1,4,24) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(1,4,25) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(1,4,26) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(1,4,27) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(1,4,28) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(1,4,29) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(1,4,30) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(1,4,31) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(1,4,32) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(1,4,33) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(1,4,34) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(1,4,35) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(1,4,36) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(1,4,37) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(1,4,38) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(1,4,39) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(1,4,40) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(1,5,1) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(1,5,2) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(1,5,3) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(1,5,4) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(1,5,5) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(1,5,6) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(1,5,7) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(1,5,8) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(1,5,9) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(1,5,10) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(1,5,11) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(1,5,12) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(1,5,13) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(1,5,14) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(1,5,15) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(1,5,16) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(1,5,17) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(1,5,18) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(1,5,19) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(1,5,20) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(1,5,21) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(1,5,22) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(1,5,23) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(1,5,24) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(1,5,25) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(1,5,26) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(1,5,27) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(1,5,28) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(1,5,29) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(1,5,30) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(1,5,31) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(1,5,32) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(1,5,33) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(1,5,34) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(1,5,35) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(1,5,36) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(1,5,37) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(1,5,38) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(1,5,39) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(1,5,40) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(1,5,41) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(1,5,42) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(1,5,43) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(1,5,44) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(1,5,45) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(1,5,46) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(1,5,47) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(1,5,48) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(1,5,49) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(1,5,50) ->
	#casting_spirit_lv_cfg{pos = 1,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(2,1,0) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(2,1,1) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(2,1,2) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(2,1,3) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(2,1,4) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(2,1,5) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(2,1,6) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(2,1,7) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(2,1,8) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(2,1,9) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(2,1,10) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(2,2,1) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(2,2,2) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(2,2,3) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(2,2,4) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(2,2,5) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(2,2,6) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(2,2,7) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(2,2,8) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(2,2,9) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(2,2,10) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(2,2,11) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(2,2,12) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(2,2,13) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(2,2,14) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(2,2,15) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(2,2,16) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(2,2,17) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(2,2,18) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(2,2,19) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(2,2,20) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(2,3,1) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(2,3,2) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(2,3,3) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(2,3,4) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(2,3,5) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(2,3,6) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(2,3,7) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(2,3,8) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(2,3,9) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(2,3,10) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(2,3,11) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(2,3,12) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(2,3,13) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(2,3,14) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(2,3,15) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(2,3,16) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(2,3,17) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(2,3,18) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(2,3,19) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(2,3,20) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(2,3,21) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(2,3,22) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(2,3,23) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(2,3,24) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(2,3,25) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(2,3,26) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(2,3,27) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(2,3,28) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(2,3,29) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(2,3,30) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(2,4,1) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(2,4,2) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(2,4,3) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(2,4,4) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(2,4,5) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(2,4,6) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(2,4,7) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(2,4,8) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(2,4,9) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(2,4,10) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(2,4,11) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(2,4,12) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(2,4,13) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(2,4,14) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(2,4,15) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(2,4,16) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(2,4,17) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(2,4,18) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(2,4,19) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(2,4,20) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(2,4,21) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(2,4,22) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(2,4,23) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(2,4,24) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(2,4,25) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(2,4,26) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(2,4,27) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(2,4,28) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(2,4,29) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(2,4,30) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(2,4,31) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(2,4,32) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(2,4,33) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(2,4,34) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(2,4,35) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(2,4,36) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(2,4,37) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(2,4,38) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(2,4,39) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(2,4,40) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(2,5,1) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(2,5,2) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(2,5,3) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(2,5,4) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(2,5,5) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(2,5,6) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(2,5,7) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(2,5,8) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(2,5,9) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(2,5,10) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(2,5,11) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(2,5,12) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(2,5,13) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(2,5,14) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(2,5,15) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(2,5,16) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(2,5,17) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(2,5,18) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(2,5,19) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(2,5,20) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(2,5,21) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(2,5,22) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(2,5,23) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(2,5,24) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(2,5,25) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(2,5,26) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(2,5,27) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(2,5,28) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(2,5,29) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(2,5,30) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(2,5,31) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(2,5,32) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(2,5,33) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(2,5,34) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(2,5,35) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(2,5,36) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(2,5,37) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(2,5,38) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(2,5,39) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(2,5,40) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(2,5,41) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(2,5,42) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(2,5,43) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(2,5,44) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(2,5,45) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(2,5,46) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(2,5,47) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(2,5,48) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(2,5,49) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(2,5,50) ->
	#casting_spirit_lv_cfg{pos = 2,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(3,1,0) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(3,1,1) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(3,1,2) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(3,1,3) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(3,1,4) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(3,1,5) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(3,1,6) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(3,1,7) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(3,1,8) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(3,1,9) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(3,1,10) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(3,2,1) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(3,2,2) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(3,2,3) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(3,2,4) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(3,2,5) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(3,2,6) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(3,2,7) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(3,2,8) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(3,2,9) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(3,2,10) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(3,2,11) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(3,2,12) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(3,2,13) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(3,2,14) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(3,2,15) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(3,2,16) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(3,2,17) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(3,2,18) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(3,2,19) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(3,2,20) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(3,3,1) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(3,3,2) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(3,3,3) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(3,3,4) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(3,3,5) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(3,3,6) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(3,3,7) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(3,3,8) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(3,3,9) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(3,3,10) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(3,3,11) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(3,3,12) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(3,3,13) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(3,3,14) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(3,3,15) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(3,3,16) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(3,3,17) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(3,3,18) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(3,3,19) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(3,3,20) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(3,3,21) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(3,3,22) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(3,3,23) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(3,3,24) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(3,3,25) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(3,3,26) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(3,3,27) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(3,3,28) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(3,3,29) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(3,3,30) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(3,4,1) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(3,4,2) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(3,4,3) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(3,4,4) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(3,4,5) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(3,4,6) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(3,4,7) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(3,4,8) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(3,4,9) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(3,4,10) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(3,4,11) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(3,4,12) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(3,4,13) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(3,4,14) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(3,4,15) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(3,4,16) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(3,4,17) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(3,4,18) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(3,4,19) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(3,4,20) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(3,4,21) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(3,4,22) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(3,4,23) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(3,4,24) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(3,4,25) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(3,4,26) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(3,4,27) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(3,4,28) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(3,4,29) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(3,4,30) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(3,4,31) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(3,4,32) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(3,4,33) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(3,4,34) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(3,4,35) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(3,4,36) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(3,4,37) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(3,4,38) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(3,4,39) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(3,4,40) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(3,5,1) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(3,5,2) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(3,5,3) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(3,5,4) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(3,5,5) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(3,5,6) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(3,5,7) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(3,5,8) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(3,5,9) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(3,5,10) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(3,5,11) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(3,5,12) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(3,5,13) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(3,5,14) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(3,5,15) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(3,5,16) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(3,5,17) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(3,5,18) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(3,5,19) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(3,5,20) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(3,5,21) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(3,5,22) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(3,5,23) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(3,5,24) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(3,5,25) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(3,5,26) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(3,5,27) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(3,5,28) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(3,5,29) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(3,5,30) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(3,5,31) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(3,5,32) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(3,5,33) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(3,5,34) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(3,5,35) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(3,5,36) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(3,5,37) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(3,5,38) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(3,5,39) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(3,5,40) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(3,5,41) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(3,5,42) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(3,5,43) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(3,5,44) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(3,5,45) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(3,5,46) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(3,5,47) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(3,5,48) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(3,5,49) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(3,5,50) ->
	#casting_spirit_lv_cfg{pos = 3,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(4,1,0) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(4,1,1) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(4,1,2) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(4,1,3) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(4,1,4) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(4,1,5) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(4,1,6) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(4,1,7) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(4,1,8) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(4,1,9) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(4,1,10) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(4,2,1) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(4,2,2) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(4,2,3) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(4,2,4) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(4,2,5) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(4,2,6) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(4,2,7) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(4,2,8) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(4,2,9) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(4,2,10) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(4,2,11) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(4,2,12) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(4,2,13) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(4,2,14) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(4,2,15) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(4,2,16) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(4,2,17) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(4,2,18) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(4,2,19) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(4,2,20) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(4,3,1) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(4,3,2) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(4,3,3) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(4,3,4) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(4,3,5) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(4,3,6) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(4,3,7) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(4,3,8) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(4,3,9) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(4,3,10) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(4,3,11) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(4,3,12) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(4,3,13) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(4,3,14) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(4,3,15) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(4,3,16) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(4,3,17) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(4,3,18) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(4,3,19) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(4,3,20) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(4,3,21) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(4,3,22) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(4,3,23) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(4,3,24) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(4,3,25) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(4,3,26) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(4,3,27) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(4,3,28) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(4,3,29) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(4,3,30) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(4,4,1) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(4,4,2) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(4,4,3) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(4,4,4) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(4,4,5) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(4,4,6) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(4,4,7) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(4,4,8) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(4,4,9) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(4,4,10) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(4,4,11) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(4,4,12) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(4,4,13) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(4,4,14) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(4,4,15) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(4,4,16) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(4,4,17) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(4,4,18) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(4,4,19) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(4,4,20) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(4,4,21) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(4,4,22) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(4,4,23) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(4,4,24) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(4,4,25) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(4,4,26) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(4,4,27) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(4,4,28) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(4,4,29) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(4,4,30) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(4,4,31) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(4,4,32) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(4,4,33) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(4,4,34) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(4,4,35) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(4,4,36) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(4,4,37) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(4,4,38) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(4,4,39) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(4,4,40) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(4,5,1) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(4,5,2) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(4,5,3) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(4,5,4) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(4,5,5) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(4,5,6) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(4,5,7) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(4,5,8) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(4,5,9) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(4,5,10) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(4,5,11) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(4,5,12) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(4,5,13) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(4,5,14) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(4,5,15) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(4,5,16) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(4,5,17) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(4,5,18) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(4,5,19) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(4,5,20) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(4,5,21) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(4,5,22) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(4,5,23) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(4,5,24) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(4,5,25) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(4,5,26) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(4,5,27) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(4,5,28) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(4,5,29) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(4,5,30) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(4,5,31) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(4,5,32) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(4,5,33) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(4,5,34) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(4,5,35) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(4,5,36) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(4,5,37) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(4,5,38) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(4,5,39) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(4,5,40) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(4,5,41) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(4,5,42) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(4,5,43) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(4,5,44) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(4,5,45) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(4,5,46) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(4,5,47) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(4,5,48) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(4,5,49) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(4,5,50) ->
	#casting_spirit_lv_cfg{pos = 4,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(5,1,0) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(5,1,1) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(5,1,2) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(5,1,3) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(5,1,4) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(5,1,5) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(5,1,6) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(5,1,7) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(5,1,8) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(5,1,9) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(5,1,10) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(5,2,1) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(5,2,2) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(5,2,3) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(5,2,4) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(5,2,5) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(5,2,6) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(5,2,7) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(5,2,8) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(5,2,9) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(5,2,10) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(5,2,11) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(5,2,12) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(5,2,13) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(5,2,14) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(5,2,15) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(5,2,16) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(5,2,17) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(5,2,18) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(5,2,19) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(5,2,20) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(5,3,1) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(5,3,2) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(5,3,3) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(5,3,4) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(5,3,5) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(5,3,6) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(5,3,7) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(5,3,8) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(5,3,9) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(5,3,10) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(5,3,11) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(5,3,12) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(5,3,13) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(5,3,14) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(5,3,15) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(5,3,16) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(5,3,17) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(5,3,18) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(5,3,19) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(5,3,20) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(5,3,21) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(5,3,22) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(5,3,23) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(5,3,24) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(5,3,25) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(5,3,26) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(5,3,27) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(5,3,28) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(5,3,29) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(5,3,30) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(5,4,1) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(5,4,2) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(5,4,3) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(5,4,4) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(5,4,5) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(5,4,6) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(5,4,7) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(5,4,8) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(5,4,9) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(5,4,10) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(5,4,11) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(5,4,12) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(5,4,13) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(5,4,14) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(5,4,15) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(5,4,16) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(5,4,17) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(5,4,18) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(5,4,19) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(5,4,20) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(5,4,21) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(5,4,22) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(5,4,23) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(5,4,24) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(5,4,25) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(5,4,26) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(5,4,27) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(5,4,28) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(5,4,29) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(5,4,30) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(5,4,31) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(5,4,32) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(5,4,33) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(5,4,34) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(5,4,35) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(5,4,36) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(5,4,37) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(5,4,38) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(5,4,39) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(5,4,40) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(5,5,1) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(5,5,2) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(5,5,3) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(5,5,4) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(5,5,5) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(5,5,6) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(5,5,7) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(5,5,8) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(5,5,9) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(5,5,10) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(5,5,11) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(5,5,12) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(5,5,13) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(5,5,14) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(5,5,15) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(5,5,16) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(5,5,17) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(5,5,18) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(5,5,19) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(5,5,20) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(5,5,21) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(5,5,22) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(5,5,23) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(5,5,24) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(5,5,25) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(5,5,26) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(5,5,27) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(5,5,28) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(5,5,29) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(5,5,30) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(5,5,31) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(5,5,32) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(5,5,33) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(5,5,34) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(5,5,35) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(5,5,36) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(5,5,37) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(5,5,38) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(5,5,39) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(5,5,40) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(5,5,41) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(5,5,42) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(5,5,43) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(5,5,44) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(5,5,45) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(5,5,46) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(5,5,47) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(5,5,48) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(5,5,49) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(5,5,50) ->
	#casting_spirit_lv_cfg{pos = 5,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(6,1,0) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(6,1,1) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(6,1,2) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(6,1,3) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(6,1,4) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(6,1,5) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(6,1,6) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(6,1,7) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(6,1,8) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(6,1,9) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(6,1,10) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(6,2,1) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(6,2,2) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(6,2,3) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(6,2,4) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(6,2,5) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(6,2,6) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(6,2,7) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(6,2,8) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(6,2,9) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(6,2,10) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(6,2,11) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(6,2,12) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(6,2,13) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(6,2,14) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(6,2,15) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(6,2,16) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(6,2,17) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(6,2,18) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(6,2,19) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(6,2,20) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(6,3,1) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(6,3,2) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(6,3,3) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(6,3,4) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(6,3,5) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(6,3,6) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(6,3,7) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(6,3,8) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(6,3,9) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(6,3,10) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(6,3,11) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(6,3,12) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(6,3,13) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(6,3,14) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(6,3,15) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(6,3,16) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(6,3,17) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(6,3,18) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(6,3,19) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(6,3,20) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(6,3,21) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(6,3,22) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(6,3,23) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(6,3,24) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(6,3,25) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(6,3,26) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(6,3,27) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(6,3,28) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(6,3,29) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(6,3,30) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(6,4,1) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(6,4,2) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(6,4,3) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(6,4,4) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(6,4,5) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(6,4,6) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(6,4,7) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(6,4,8) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(6,4,9) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(6,4,10) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(6,4,11) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(6,4,12) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(6,4,13) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(6,4,14) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(6,4,15) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(6,4,16) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(6,4,17) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(6,4,18) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(6,4,19) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(6,4,20) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(6,4,21) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(6,4,22) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(6,4,23) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(6,4,24) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(6,4,25) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(6,4,26) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(6,4,27) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(6,4,28) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(6,4,29) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(6,4,30) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(6,4,31) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(6,4,32) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(6,4,33) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(6,4,34) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(6,4,35) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(6,4,36) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(6,4,37) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(6,4,38) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(6,4,39) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(6,4,40) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(6,5,1) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(6,5,2) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(6,5,3) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(6,5,4) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(6,5,5) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(6,5,6) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(6,5,7) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(6,5,8) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(6,5,9) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(6,5,10) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(6,5,11) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(6,5,12) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(6,5,13) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(6,5,14) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(6,5,15) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(6,5,16) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(6,5,17) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(6,5,18) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(6,5,19) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(6,5,20) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(6,5,21) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(6,5,22) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(6,5,23) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(6,5,24) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(6,5,25) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(6,5,26) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(6,5,27) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(6,5,28) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(6,5,29) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(6,5,30) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(6,5,31) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(6,5,32) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(6,5,33) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(6,5,34) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(6,5,35) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(6,5,36) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(6,5,37) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(6,5,38) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(6,5,39) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(6,5,40) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(6,5,41) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(6,5,42) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(6,5,43) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(6,5,44) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(6,5,45) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(6,5,46) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(6,5,47) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(6,5,48) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(6,5,49) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(6,5,50) ->
	#casting_spirit_lv_cfg{pos = 6,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(7,1,0) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(7,1,1) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(7,1,2) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(7,1,3) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(7,1,4) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(7,1,5) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(7,1,6) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(7,1,7) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(7,1,8) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(7,1,9) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(7,1,10) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(7,2,1) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(7,2,2) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(7,2,3) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(7,2,4) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(7,2,5) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(7,2,6) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(7,2,7) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(7,2,8) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(7,2,9) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(7,2,10) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(7,2,11) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(7,2,12) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(7,2,13) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(7,2,14) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(7,2,15) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(7,2,16) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(7,2,17) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(7,2,18) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(7,2,19) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(7,2,20) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(7,3,1) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(7,3,2) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(7,3,3) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(7,3,4) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(7,3,5) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(7,3,6) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(7,3,7) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(7,3,8) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(7,3,9) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(7,3,10) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(7,3,11) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(7,3,12) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(7,3,13) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(7,3,14) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(7,3,15) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(7,3,16) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(7,3,17) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(7,3,18) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(7,3,19) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(7,3,20) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(7,3,21) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(7,3,22) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(7,3,23) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(7,3,24) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(7,3,25) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(7,3,26) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(7,3,27) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(7,3,28) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(7,3,29) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(7,3,30) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(7,4,1) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(7,4,2) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(7,4,3) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(7,4,4) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(7,4,5) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(7,4,6) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(7,4,7) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(7,4,8) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(7,4,9) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(7,4,10) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(7,4,11) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(7,4,12) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(7,4,13) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(7,4,14) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(7,4,15) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(7,4,16) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(7,4,17) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(7,4,18) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(7,4,19) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(7,4,20) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(7,4,21) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(7,4,22) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(7,4,23) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(7,4,24) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(7,4,25) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(7,4,26) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(7,4,27) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(7,4,28) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(7,4,29) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(7,4,30) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(7,4,31) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(7,4,32) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(7,4,33) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(7,4,34) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(7,4,35) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(7,4,36) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(7,4,37) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(7,4,38) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(7,4,39) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(7,4,40) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(7,5,1) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(7,5,2) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(7,5,3) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(7,5,4) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(7,5,5) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(7,5,6) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(7,5,7) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(7,5,8) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(7,5,9) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(7,5,10) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(7,5,11) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(7,5,12) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(7,5,13) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(7,5,14) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(7,5,15) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(7,5,16) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(7,5,17) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(7,5,18) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(7,5,19) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(7,5,20) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(7,5,21) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(7,5,22) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(7,5,23) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(7,5,24) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(7,5,25) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(7,5,26) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(7,5,27) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(7,5,28) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(7,5,29) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(7,5,30) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(7,5,31) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(7,5,32) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(7,5,33) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(7,5,34) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(7,5,35) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(7,5,36) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(7,5,37) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(7,5,38) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(7,5,39) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(7,5,40) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(7,5,41) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(7,5,42) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(7,5,43) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(7,5,44) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(7,5,45) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(7,5,46) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(7,5,47) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(7,5,48) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(7,5,49) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(7,5,50) ->
	#casting_spirit_lv_cfg{pos = 7,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(8,1,0) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(8,1,1) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(8,1,2) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(8,1,3) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(8,1,4) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(8,1,5) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(8,1,6) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(8,1,7) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(8,1,8) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(8,1,9) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(8,1,10) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(8,2,1) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(8,2,2) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(8,2,3) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(8,2,4) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(8,2,5) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(8,2,6) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(8,2,7) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(8,2,8) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(8,2,9) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(8,2,10) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(8,2,11) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(8,2,12) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(8,2,13) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(8,2,14) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(8,2,15) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(8,2,16) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(8,2,17) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(8,2,18) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(8,2,19) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(8,2,20) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(8,3,1) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(8,3,2) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(8,3,3) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(8,3,4) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(8,3,5) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(8,3,6) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(8,3,7) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(8,3,8) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(8,3,9) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(8,3,10) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(8,3,11) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(8,3,12) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(8,3,13) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(8,3,14) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(8,3,15) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(8,3,16) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(8,3,17) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(8,3,18) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(8,3,19) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(8,3,20) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(8,3,21) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(8,3,22) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(8,3,23) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(8,3,24) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(8,3,25) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(8,3,26) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(8,3,27) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(8,3,28) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(8,3,29) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(8,3,30) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(8,4,1) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(8,4,2) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(8,4,3) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(8,4,4) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(8,4,5) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(8,4,6) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(8,4,7) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(8,4,8) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(8,4,9) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(8,4,10) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(8,4,11) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(8,4,12) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(8,4,13) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(8,4,14) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(8,4,15) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(8,4,16) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(8,4,17) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(8,4,18) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(8,4,19) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(8,4,20) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(8,4,21) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(8,4,22) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(8,4,23) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(8,4,24) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(8,4,25) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(8,4,26) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(8,4,27) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(8,4,28) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(8,4,29) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(8,4,30) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(8,4,31) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(8,4,32) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(8,4,33) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(8,4,34) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(8,4,35) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(8,4,36) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(8,4,37) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(8,4,38) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(8,4,39) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(8,4,40) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(8,5,1) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(8,5,2) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(8,5,3) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(8,5,4) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(8,5,5) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(8,5,6) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(8,5,7) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(8,5,8) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(8,5,9) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(8,5,10) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(8,5,11) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(8,5,12) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(8,5,13) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(8,5,14) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(8,5,15) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(8,5,16) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(8,5,17) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(8,5,18) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(8,5,19) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(8,5,20) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(8,5,21) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(8,5,22) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(8,5,23) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(8,5,24) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(8,5,25) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(8,5,26) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(8,5,27) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(8,5,28) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(8,5,29) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(8,5,30) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(8,5,31) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(8,5,32) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(8,5,33) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(8,5,34) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(8,5,35) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(8,5,36) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(8,5,37) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(8,5,38) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(8,5,39) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(8,5,40) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(8,5,41) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(8,5,42) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(8,5,43) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(8,5,44) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(8,5,45) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(8,5,46) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(8,5,47) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(8,5,48) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(8,5,49) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(8,5,50) ->
	#casting_spirit_lv_cfg{pos = 8,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(9,1,0) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(9,1,1) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(9,1,2) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(9,1,3) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(9,1,4) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(9,1,5) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(9,1,6) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(9,1,7) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(9,1,8) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(9,1,9) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(9,1,10) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(9,2,1) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(9,2,2) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(9,2,3) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(9,2,4) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(9,2,5) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(9,2,6) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(9,2,7) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(9,2,8) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(9,2,9) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(9,2,10) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(9,2,11) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(9,2,12) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(9,2,13) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(9,2,14) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(9,2,15) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(9,2,16) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(9,2,17) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(9,2,18) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(9,2,19) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(9,2,20) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(9,3,1) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(9,3,2) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(9,3,3) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(9,3,4) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(9,3,5) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(9,3,6) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(9,3,7) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(9,3,8) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(9,3,9) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(9,3,10) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(9,3,11) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(9,3,12) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(9,3,13) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(9,3,14) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(9,3,15) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(9,3,16) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(9,3,17) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(9,3,18) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(9,3,19) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(9,3,20) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(9,3,21) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(9,3,22) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(9,3,23) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(9,3,24) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(9,3,25) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(9,3,26) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(9,3,27) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(9,3,28) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(9,3,29) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(9,3,30) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(9,4,1) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(9,4,2) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(9,4,3) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(9,4,4) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(9,4,5) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(9,4,6) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(9,4,7) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(9,4,8) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(9,4,9) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(9,4,10) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(9,4,11) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(9,4,12) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(9,4,13) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(9,4,14) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(9,4,15) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(9,4,16) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(9,4,17) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(9,4,18) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(9,4,19) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(9,4,20) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(9,4,21) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(9,4,22) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(9,4,23) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(9,4,24) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(9,4,25) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(9,4,26) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(9,4,27) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(9,4,28) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(9,4,29) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(9,4,30) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(9,4,31) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(9,4,32) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(9,4,33) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(9,4,34) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(9,4,35) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(9,4,36) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(9,4,37) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(9,4,38) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(9,4,39) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(9,4,40) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(9,5,1) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(9,5,2) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(9,5,3) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(9,5,4) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(9,5,5) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(9,5,6) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(9,5,7) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(9,5,8) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(9,5,9) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(9,5,10) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(9,5,11) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(9,5,12) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(9,5,13) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(9,5,14) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(9,5,15) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(9,5,16) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(9,5,17) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(9,5,18) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(9,5,19) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(9,5,20) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(9,5,21) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(9,5,22) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(9,5,23) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(9,5,24) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(9,5,25) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(9,5,26) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(9,5,27) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(9,5,28) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(9,5,29) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(9,5,30) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(9,5,31) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(9,5,32) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(9,5,33) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(9,5,34) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(9,5,35) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(9,5,36) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(9,5,37) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(9,5,38) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(9,5,39) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(9,5,40) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(9,5,41) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(9,5,42) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(9,5,43) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(9,5,44) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(9,5,45) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(9,5,46) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(9,5,47) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(9,5,48) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(9,5,49) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(9,5,50) ->
	#casting_spirit_lv_cfg{pos = 9,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(10,1,0) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 0,attr_plus = 0,cost = [{255,38040018,100}]};

get_lv_cfg(10,1,1) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 1,attr_plus = 200,cost = [{255,38040018,140}]};

get_lv_cfg(10,1,2) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 2,attr_plus = 400,cost = [{255,38040018,200}]};

get_lv_cfg(10,1,3) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 3,attr_plus = 600,cost = [{255,38040018,280}]};

get_lv_cfg(10,1,4) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 4,attr_plus = 800,cost = [{255,38040018,380}]};

get_lv_cfg(10,1,5) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 5,attr_plus = 1000,cost = [{255,38040018,500}]};

get_lv_cfg(10,1,6) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 6,attr_plus = 1200,cost = [{255,38040018,640}]};

get_lv_cfg(10,1,7) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 7,attr_plus = 1400,cost = [{255,38040018,800}]};

get_lv_cfg(10,1,8) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 8,attr_plus = 1600,cost = [{255,38040018,980}]};

get_lv_cfg(10,1,9) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 9,attr_plus = 1800,cost = [{255,38040018,1180}]};

get_lv_cfg(10,1,10) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 1,lv = 10,attr_plus = 2000,cost = [{255,38040018,500}]};

get_lv_cfg(10,2,1) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 1,attr_plus = 2200,cost = [{255,38040018,540}]};

get_lv_cfg(10,2,2) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 2,attr_plus = 2400,cost = [{255,38040018,600}]};

get_lv_cfg(10,2,3) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 3,attr_plus = 2600,cost = [{255,38040018,680}]};

get_lv_cfg(10,2,4) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 4,attr_plus = 2800,cost = [{255,38040018,780}]};

get_lv_cfg(10,2,5) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 5,attr_plus = 3000,cost = [{255,38040018,900}]};

get_lv_cfg(10,2,6) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 6,attr_plus = 3200,cost = [{255,38040018,1040}]};

get_lv_cfg(10,2,7) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 7,attr_plus = 3400,cost = [{255,38040018,1200}]};

get_lv_cfg(10,2,8) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 8,attr_plus = 3600,cost = [{255,38040018,1380}]};

get_lv_cfg(10,2,9) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 9,attr_plus = 3800,cost = [{255,38040018,1580}]};

get_lv_cfg(10,2,10) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 10,attr_plus = 4000,cost = [{255,38040018,1800}]};

get_lv_cfg(10,2,11) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 11,attr_plus = 4200,cost = [{255,38040018,2040}]};

get_lv_cfg(10,2,12) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 12,attr_plus = 4400,cost = [{255,38040018,2300}]};

get_lv_cfg(10,2,13) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 13,attr_plus = 4600,cost = [{255,38040018,2580}]};

get_lv_cfg(10,2,14) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 14,attr_plus = 4800,cost = [{255,38040018,2880}]};

get_lv_cfg(10,2,15) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 15,attr_plus = 5000,cost = [{255,38040018,3200}]};

get_lv_cfg(10,2,16) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 16,attr_plus = 5200,cost = [{255,38040018,3540}]};

get_lv_cfg(10,2,17) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 17,attr_plus = 5400,cost = [{255,38040018,3900}]};

get_lv_cfg(10,2,18) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 18,attr_plus = 5600,cost = [{255,38040018,4280}]};

get_lv_cfg(10,2,19) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 19,attr_plus = 5800,cost = [{255,38040018,4680}]};

get_lv_cfg(10,2,20) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 2,lv = 20,attr_plus = 6000,cost = [{255,38040018,2500}]};

get_lv_cfg(10,3,1) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 1,attr_plus = 6200,cost = [{255,38040018,2540}]};

get_lv_cfg(10,3,2) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 2,attr_plus = 6400,cost = [{255,38040018,2600}]};

get_lv_cfg(10,3,3) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 3,attr_plus = 6600,cost = [{255,38040018,2680}]};

get_lv_cfg(10,3,4) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 4,attr_plus = 6800,cost = [{255,38040018,2780}]};

get_lv_cfg(10,3,5) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 5,attr_plus = 7000,cost = [{255,38040018,2900}]};

get_lv_cfg(10,3,6) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 6,attr_plus = 7200,cost = [{255,38040018,3040}]};

get_lv_cfg(10,3,7) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 7,attr_plus = 7400,cost = [{255,38040018,3200}]};

get_lv_cfg(10,3,8) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 8,attr_plus = 7600,cost = [{255,38040018,3380}]};

get_lv_cfg(10,3,9) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 9,attr_plus = 7800,cost = [{255,38040018,3580}]};

get_lv_cfg(10,3,10) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 10,attr_plus = 8000,cost = [{255,38040018,3800}]};

get_lv_cfg(10,3,11) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 11,attr_plus = 8200,cost = [{255,38040018,4040}]};

get_lv_cfg(10,3,12) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 12,attr_plus = 8400,cost = [{255,38040018,4300}]};

get_lv_cfg(10,3,13) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 13,attr_plus = 8600,cost = [{255,38040018,4580}]};

get_lv_cfg(10,3,14) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 14,attr_plus = 8800,cost = [{255,38040018,4880}]};

get_lv_cfg(10,3,15) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 15,attr_plus = 9000,cost = [{255,38040018,5200}]};

get_lv_cfg(10,3,16) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 16,attr_plus = 9200,cost = [{255,38040018,5540}]};

get_lv_cfg(10,3,17) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 17,attr_plus = 9400,cost = [{255,38040018,5900}]};

get_lv_cfg(10,3,18) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 18,attr_plus = 9600,cost = [{255,38040018,6280}]};

get_lv_cfg(10,3,19) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 19,attr_plus = 9800,cost = [{255,38040018,6680}]};

get_lv_cfg(10,3,20) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 20,attr_plus = 10000,cost = [{255,38040018,7100}]};

get_lv_cfg(10,3,21) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 21,attr_plus = 10200,cost = [{255,38040018,7540}]};

get_lv_cfg(10,3,22) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 22,attr_plus = 10400,cost = [{255,38040018,8000}]};

get_lv_cfg(10,3,23) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 23,attr_plus = 10600,cost = [{255,38040018,8480}]};

get_lv_cfg(10,3,24) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 24,attr_plus = 10800,cost = [{255,38040018,8980}]};

get_lv_cfg(10,3,25) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 25,attr_plus = 11000,cost = [{255,38040018,9500}]};

get_lv_cfg(10,3,26) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 26,attr_plus = 11200,cost = [{255,38040018,10040}]};

get_lv_cfg(10,3,27) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 27,attr_plus = 11400,cost = [{255,38040018,10600}]};

get_lv_cfg(10,3,28) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 28,attr_plus = 11600,cost = [{255,38040018,11180}]};

get_lv_cfg(10,3,29) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 29,attr_plus = 11800,cost = [{255,38040018,11780}]};

get_lv_cfg(10,3,30) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 3,lv = 30,attr_plus = 12000,cost = [{255,38040018,7500}]};

get_lv_cfg(10,4,1) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 1,attr_plus = 12200,cost = [{255,38040018,7540}]};

get_lv_cfg(10,4,2) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 2,attr_plus = 12400,cost = [{255,38040018,7600}]};

get_lv_cfg(10,4,3) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 3,attr_plus = 12600,cost = [{255,38040018,7680}]};

get_lv_cfg(10,4,4) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 4,attr_plus = 12800,cost = [{255,38040018,7780}]};

get_lv_cfg(10,4,5) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 5,attr_plus = 13000,cost = [{255,38040018,7900}]};

get_lv_cfg(10,4,6) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 6,attr_plus = 13200,cost = [{255,38040018,8040}]};

get_lv_cfg(10,4,7) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 7,attr_plus = 13400,cost = [{255,38040018,8200}]};

get_lv_cfg(10,4,8) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 8,attr_plus = 13600,cost = [{255,38040018,8380}]};

get_lv_cfg(10,4,9) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 9,attr_plus = 13800,cost = [{255,38040018,8580}]};

get_lv_cfg(10,4,10) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 10,attr_plus = 14000,cost = [{255,38040018,8800}]};

get_lv_cfg(10,4,11) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 11,attr_plus = 14200,cost = [{255,38040018,9040}]};

get_lv_cfg(10,4,12) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 12,attr_plus = 14400,cost = [{255,38040018,9300}]};

get_lv_cfg(10,4,13) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 13,attr_plus = 14600,cost = [{255,38040018,9580}]};

get_lv_cfg(10,4,14) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 14,attr_plus = 14800,cost = [{255,38040018,9880}]};

get_lv_cfg(10,4,15) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 15,attr_plus = 15000,cost = [{255,38040018,10200}]};

get_lv_cfg(10,4,16) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 16,attr_plus = 15200,cost = [{255,38040018,10540}]};

get_lv_cfg(10,4,17) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 17,attr_plus = 15400,cost = [{255,38040018,10900}]};

get_lv_cfg(10,4,18) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 18,attr_plus = 15600,cost = [{255,38040018,11280}]};

get_lv_cfg(10,4,19) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 19,attr_plus = 15800,cost = [{255,38040018,11680}]};

get_lv_cfg(10,4,20) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 20,attr_plus = 16000,cost = [{255,38040018,12100}]};

get_lv_cfg(10,4,21) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 21,attr_plus = 16200,cost = [{255,38040018,12540}]};

get_lv_cfg(10,4,22) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 22,attr_plus = 16400,cost = [{255,38040018,13000}]};

get_lv_cfg(10,4,23) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 23,attr_plus = 16600,cost = [{255,38040018,13480}]};

get_lv_cfg(10,4,24) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 24,attr_plus = 16800,cost = [{255,38040018,13980}]};

get_lv_cfg(10,4,25) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 25,attr_plus = 17000,cost = [{255,38040018,14500}]};

get_lv_cfg(10,4,26) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 26,attr_plus = 17200,cost = [{255,38040018,15040}]};

get_lv_cfg(10,4,27) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 27,attr_plus = 17400,cost = [{255,38040018,15600}]};

get_lv_cfg(10,4,28) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 28,attr_plus = 17600,cost = [{255,38040018,16180}]};

get_lv_cfg(10,4,29) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 29,attr_plus = 17800,cost = [{255,38040018,16780}]};

get_lv_cfg(10,4,30) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 30,attr_plus = 18000,cost = [{255,38040018,17400}]};

get_lv_cfg(10,4,31) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 31,attr_plus = 18200,cost = [{255,38040018,18040}]};

get_lv_cfg(10,4,32) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 32,attr_plus = 18400,cost = [{255,38040018,18700}]};

get_lv_cfg(10,4,33) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 33,attr_plus = 18600,cost = [{255,38040018,19380}]};

get_lv_cfg(10,4,34) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 34,attr_plus = 18800,cost = [{255,38040018,20080}]};

get_lv_cfg(10,4,35) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 35,attr_plus = 19000,cost = [{255,38040018,20800}]};

get_lv_cfg(10,4,36) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 36,attr_plus = 19200,cost = [{255,38040018,21540}]};

get_lv_cfg(10,4,37) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 37,attr_plus = 19400,cost = [{255,38040018,22300}]};

get_lv_cfg(10,4,38) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 38,attr_plus = 19600,cost = [{255,38040018,23080}]};

get_lv_cfg(10,4,39) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 39,attr_plus = 19800,cost = [{255,38040018,23880}]};

get_lv_cfg(10,4,40) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 4,lv = 40,attr_plus = 20000,cost = [{255,38040018,12500}]};

get_lv_cfg(10,5,1) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 1,attr_plus = 20200,cost = [{255,38040018,12540}]};

get_lv_cfg(10,5,2) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 2,attr_plus = 20400,cost = [{255,38040018,12600}]};

get_lv_cfg(10,5,3) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 3,attr_plus = 20600,cost = [{255,38040018,12680}]};

get_lv_cfg(10,5,4) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 4,attr_plus = 20800,cost = [{255,38040018,12780}]};

get_lv_cfg(10,5,5) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 5,attr_plus = 21000,cost = [{255,38040018,12900}]};

get_lv_cfg(10,5,6) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 6,attr_plus = 21200,cost = [{255,38040018,13040}]};

get_lv_cfg(10,5,7) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 7,attr_plus = 21400,cost = [{255,38040018,13200}]};

get_lv_cfg(10,5,8) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 8,attr_plus = 21600,cost = [{255,38040018,13380}]};

get_lv_cfg(10,5,9) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 9,attr_plus = 21800,cost = [{255,38040018,13580}]};

get_lv_cfg(10,5,10) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 10,attr_plus = 22000,cost = [{255,38040018,13800}]};

get_lv_cfg(10,5,11) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 11,attr_plus = 22200,cost = [{255,38040018,14040}]};

get_lv_cfg(10,5,12) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 12,attr_plus = 22400,cost = [{255,38040018,14300}]};

get_lv_cfg(10,5,13) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 13,attr_plus = 22600,cost = [{255,38040018,14580}]};

get_lv_cfg(10,5,14) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 14,attr_plus = 22800,cost = [{255,38040018,14880}]};

get_lv_cfg(10,5,15) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 15,attr_plus = 23000,cost = [{255,38040018,15200}]};

get_lv_cfg(10,5,16) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 16,attr_plus = 23200,cost = [{255,38040018,15540}]};

get_lv_cfg(10,5,17) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 17,attr_plus = 23400,cost = [{255,38040018,15900}]};

get_lv_cfg(10,5,18) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 18,attr_plus = 23600,cost = [{255,38040018,16280}]};

get_lv_cfg(10,5,19) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 19,attr_plus = 23800,cost = [{255,38040018,16680}]};

get_lv_cfg(10,5,20) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 20,attr_plus = 24000,cost = [{255,38040018,17100}]};

get_lv_cfg(10,5,21) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 21,attr_plus = 24200,cost = [{255,38040018,17540}]};

get_lv_cfg(10,5,22) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 22,attr_plus = 24400,cost = [{255,38040018,18000}]};

get_lv_cfg(10,5,23) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 23,attr_plus = 24600,cost = [{255,38040018,18480}]};

get_lv_cfg(10,5,24) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 24,attr_plus = 24800,cost = [{255,38040018,18980}]};

get_lv_cfg(10,5,25) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 25,attr_plus = 25000,cost = [{255,38040018,19500}]};

get_lv_cfg(10,5,26) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 26,attr_plus = 25200,cost = [{255,38040018,20040}]};

get_lv_cfg(10,5,27) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 27,attr_plus = 25400,cost = [{255,38040018,20600}]};

get_lv_cfg(10,5,28) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 28,attr_plus = 25600,cost = [{255,38040018,21180}]};

get_lv_cfg(10,5,29) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 29,attr_plus = 25800,cost = [{255,38040018,21780}]};

get_lv_cfg(10,5,30) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 30,attr_plus = 26000,cost = [{255,38040018,22400}]};

get_lv_cfg(10,5,31) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 31,attr_plus = 26200,cost = [{255,38040018,23040}]};

get_lv_cfg(10,5,32) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 32,attr_plus = 26400,cost = [{255,38040018,23700}]};

get_lv_cfg(10,5,33) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 33,attr_plus = 26600,cost = [{255,38040018,24380}]};

get_lv_cfg(10,5,34) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 34,attr_plus = 26800,cost = [{255,38040018,25080}]};

get_lv_cfg(10,5,35) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 35,attr_plus = 27000,cost = [{255,38040018,25800}]};

get_lv_cfg(10,5,36) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 36,attr_plus = 27200,cost = [{255,38040018,26540}]};

get_lv_cfg(10,5,37) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 37,attr_plus = 27400,cost = [{255,38040018,27300}]};

get_lv_cfg(10,5,38) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 38,attr_plus = 27600,cost = [{255,38040018,28080}]};

get_lv_cfg(10,5,39) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 39,attr_plus = 27800,cost = [{255,38040018,28880}]};

get_lv_cfg(10,5,40) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 40,attr_plus = 28000,cost = [{255,38040018,29700}]};

get_lv_cfg(10,5,41) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 41,attr_plus = 28200,cost = [{255,38040018,30540}]};

get_lv_cfg(10,5,42) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 42,attr_plus = 28400,cost = [{255,38040018,31400}]};

get_lv_cfg(10,5,43) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 43,attr_plus = 28600,cost = [{255,38040018,32280}]};

get_lv_cfg(10,5,44) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 44,attr_plus = 28800,cost = [{255,38040018,33180}]};

get_lv_cfg(10,5,45) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 45,attr_plus = 29000,cost = [{255,38040018,34100}]};

get_lv_cfg(10,5,46) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 46,attr_plus = 29200,cost = [{255,38040018,35040}]};

get_lv_cfg(10,5,47) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 47,attr_plus = 29400,cost = [{255,38040018,36000}]};

get_lv_cfg(10,5,48) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 48,attr_plus = 29600,cost = [{255,38040018,36980}]};

get_lv_cfg(10,5,49) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 49,attr_plus = 29800,cost = [{255,38040018,37980}]};

get_lv_cfg(10,5,50) ->
	#casting_spirit_lv_cfg{pos = 10,stage = 5,lv = 50,attr_plus = 30000,cost = [{255,38040018,0}]};

get_lv_cfg(_Pos,_Stage,_Lv) ->
	[].

get_spirit_lv_cfg(0) ->
	#spirit_lv_cfg{lv = 0,attr = [{1,0},{2,0},{3,0},{4,0}],cost = [{255,38040018,500}]};

get_spirit_lv_cfg(1) ->
	#spirit_lv_cfg{lv = 1,attr = [{1,32},{2,640},{3,16},{4,16}],cost = [{255,38040018,550}]};

get_spirit_lv_cfg(2) ->
	#spirit_lv_cfg{lv = 2,attr = [{1,64},{2,1280},{3,32},{4,32}],cost = [{255,38040018,600}]};

get_spirit_lv_cfg(3) ->
	#spirit_lv_cfg{lv = 3,attr = [{1,96},{2,1920},{3,48},{4,48}],cost = [{255,38040018,650}]};

get_spirit_lv_cfg(4) ->
	#spirit_lv_cfg{lv = 4,attr = [{1,128},{2,2560},{3,64},{4,64}],cost = [{255,38040018,700}]};

get_spirit_lv_cfg(5) ->
	#spirit_lv_cfg{lv = 5,attr = [{1,160},{2,3200},{3,80},{4,80}],cost = [{255,38040018,750}]};

get_spirit_lv_cfg(6) ->
	#spirit_lv_cfg{lv = 6,attr = [{1,192},{2,3840},{3,96},{4,96}],cost = [{255,38040018,800}]};

get_spirit_lv_cfg(7) ->
	#spirit_lv_cfg{lv = 7,attr = [{1,224},{2,4480},{3,112},{4,112}],cost = [{255,38040018,850}]};

get_spirit_lv_cfg(8) ->
	#spirit_lv_cfg{lv = 8,attr = [{1,256},{2,5120},{3,128},{4,128}],cost = [{255,38040018,900}]};

get_spirit_lv_cfg(9) ->
	#spirit_lv_cfg{lv = 9,attr = [{1,288},{2,5760},{3,144},{4,144}],cost = [{255,38040018,950}]};

get_spirit_lv_cfg(10) ->
	#spirit_lv_cfg{lv = 10,attr = [{1,320},{2,6400},{3,160},{4,160}],cost = [{255,38040018,1000}]};

get_spirit_lv_cfg(11) ->
	#spirit_lv_cfg{lv = 11,attr = [{1,352},{2,7040},{3,176},{4,176}],cost = [{255,38040018,1050}]};

get_spirit_lv_cfg(12) ->
	#spirit_lv_cfg{lv = 12,attr = [{1,384},{2,7680},{3,192},{4,192}],cost = [{255,38040018,1100}]};

get_spirit_lv_cfg(13) ->
	#spirit_lv_cfg{lv = 13,attr = [{1,416},{2,8320},{3,208},{4,208}],cost = [{255,38040018,1150}]};

get_spirit_lv_cfg(14) ->
	#spirit_lv_cfg{lv = 14,attr = [{1,448},{2,8960},{3,224},{4,224}],cost = [{255,38040018,1200}]};

get_spirit_lv_cfg(15) ->
	#spirit_lv_cfg{lv = 15,attr = [{1,480},{2,9600},{3,240},{4,240}],cost = [{255,38040018,1250}]};

get_spirit_lv_cfg(16) ->
	#spirit_lv_cfg{lv = 16,attr = [{1,512},{2,10240},{3,256},{4,256}],cost = [{255,38040018,1300}]};

get_spirit_lv_cfg(17) ->
	#spirit_lv_cfg{lv = 17,attr = [{1,544},{2,10880},{3,272},{4,272}],cost = [{255,38040018,1350}]};

get_spirit_lv_cfg(18) ->
	#spirit_lv_cfg{lv = 18,attr = [{1,576},{2,11520},{3,288},{4,288}],cost = [{255,38040018,1400}]};

get_spirit_lv_cfg(19) ->
	#spirit_lv_cfg{lv = 19,attr = [{1,608},{2,12160},{3,304},{4,304}],cost = [{255,38040018,1450}]};

get_spirit_lv_cfg(20) ->
	#spirit_lv_cfg{lv = 20,attr = [{1,640},{2,12800},{3,320},{4,320}],cost = [{255,38040018,1500}]};

get_spirit_lv_cfg(21) ->
	#spirit_lv_cfg{lv = 21,attr = [{1,672},{2,13440},{3,336},{4,336}],cost = [{255,38040018,1550}]};

get_spirit_lv_cfg(22) ->
	#spirit_lv_cfg{lv = 22,attr = [{1,704},{2,14080},{3,352},{4,352}],cost = [{255,38040018,1600}]};

get_spirit_lv_cfg(23) ->
	#spirit_lv_cfg{lv = 23,attr = [{1,736},{2,14720},{3,368},{4,368}],cost = [{255,38040018,1650}]};

get_spirit_lv_cfg(24) ->
	#spirit_lv_cfg{lv = 24,attr = [{1,768},{2,15360},{3,384},{4,384}],cost = [{255,38040018,1700}]};

get_spirit_lv_cfg(25) ->
	#spirit_lv_cfg{lv = 25,attr = [{1,800},{2,16000},{3,400},{4,400}],cost = [{255,38040018,1750}]};

get_spirit_lv_cfg(26) ->
	#spirit_lv_cfg{lv = 26,attr = [{1,832},{2,16640},{3,416},{4,416}],cost = [{255,38040018,1800}]};

get_spirit_lv_cfg(27) ->
	#spirit_lv_cfg{lv = 27,attr = [{1,864},{2,17280},{3,432},{4,432}],cost = [{255,38040018,1850}]};

get_spirit_lv_cfg(28) ->
	#spirit_lv_cfg{lv = 28,attr = [{1,896},{2,17920},{3,448},{4,448}],cost = [{255,38040018,1900}]};

get_spirit_lv_cfg(29) ->
	#spirit_lv_cfg{lv = 29,attr = [{1,928},{2,18560},{3,464},{4,464}],cost = [{255,38040018,1950}]};

get_spirit_lv_cfg(30) ->
	#spirit_lv_cfg{lv = 30,attr = [{1,960},{2,19200},{3,480},{4,480}],cost = [{255,38040018,2000}]};

get_spirit_lv_cfg(31) ->
	#spirit_lv_cfg{lv = 31,attr = [{1,992},{2,19840},{3,496},{4,496}],cost = [{255,38040018,2050}]};

get_spirit_lv_cfg(32) ->
	#spirit_lv_cfg{lv = 32,attr = [{1,1024},{2,20480},{3,512},{4,512}],cost = [{255,38040018,2100}]};

get_spirit_lv_cfg(33) ->
	#spirit_lv_cfg{lv = 33,attr = [{1,1056},{2,21120},{3,528},{4,528}],cost = [{255,38040018,2150}]};

get_spirit_lv_cfg(34) ->
	#spirit_lv_cfg{lv = 34,attr = [{1,1088},{2,21760},{3,544},{4,544}],cost = [{255,38040018,2200}]};

get_spirit_lv_cfg(35) ->
	#spirit_lv_cfg{lv = 35,attr = [{1,1120},{2,22400},{3,560},{4,560}],cost = [{255,38040018,2250}]};

get_spirit_lv_cfg(36) ->
	#spirit_lv_cfg{lv = 36,attr = [{1,1152},{2,23040},{3,576},{4,576}],cost = [{255,38040018,2300}]};

get_spirit_lv_cfg(37) ->
	#spirit_lv_cfg{lv = 37,attr = [{1,1184},{2,23680},{3,592},{4,592}],cost = [{255,38040018,2350}]};

get_spirit_lv_cfg(38) ->
	#spirit_lv_cfg{lv = 38,attr = [{1,1216},{2,24320},{3,608},{4,608}],cost = [{255,38040018,2400}]};

get_spirit_lv_cfg(39) ->
	#spirit_lv_cfg{lv = 39,attr = [{1,1248},{2,24960},{3,624},{4,624}],cost = [{255,38040018,2450}]};

get_spirit_lv_cfg(40) ->
	#spirit_lv_cfg{lv = 40,attr = [{1,1280},{2,25600},{3,640},{4,640}],cost = [{255,38040018,2500}]};

get_spirit_lv_cfg(41) ->
	#spirit_lv_cfg{lv = 41,attr = [{1,1312},{2,26240},{3,656},{4,656}],cost = [{255,38040018,2550}]};

get_spirit_lv_cfg(42) ->
	#spirit_lv_cfg{lv = 42,attr = [{1,1344},{2,26880},{3,672},{4,672}],cost = [{255,38040018,2600}]};

get_spirit_lv_cfg(43) ->
	#spirit_lv_cfg{lv = 43,attr = [{1,1376},{2,27520},{3,688},{4,688}],cost = [{255,38040018,2650}]};

get_spirit_lv_cfg(44) ->
	#spirit_lv_cfg{lv = 44,attr = [{1,1408},{2,28160},{3,704},{4,704}],cost = [{255,38040018,2700}]};

get_spirit_lv_cfg(45) ->
	#spirit_lv_cfg{lv = 45,attr = [{1,1440},{2,28800},{3,720},{4,720}],cost = [{255,38040018,2750}]};

get_spirit_lv_cfg(46) ->
	#spirit_lv_cfg{lv = 46,attr = [{1,1472},{2,29440},{3,736},{4,736}],cost = [{255,38040018,2800}]};

get_spirit_lv_cfg(47) ->
	#spirit_lv_cfg{lv = 47,attr = [{1,1504},{2,30080},{3,752},{4,752}],cost = [{255,38040018,2850}]};

get_spirit_lv_cfg(48) ->
	#spirit_lv_cfg{lv = 48,attr = [{1,1536},{2,30720},{3,768},{4,768}],cost = [{255,38040018,2900}]};

get_spirit_lv_cfg(49) ->
	#spirit_lv_cfg{lv = 49,attr = [{1,1568},{2,31360},{3,784},{4,784}],cost = [{255,38040018,2950}]};

get_spirit_lv_cfg(50) ->
	#spirit_lv_cfg{lv = 50,attr = [{1,1600},{2,32000},{3,800},{4,800}],cost = [{255,38040018,3000}]};

get_spirit_lv_cfg(51) ->
	#spirit_lv_cfg{lv = 51,attr = [{1,1632},{2,32640},{3,816},{4,816}],cost = [{255,38040018,3050}]};

get_spirit_lv_cfg(52) ->
	#spirit_lv_cfg{lv = 52,attr = [{1,1664},{2,33280},{3,832},{4,832}],cost = [{255,38040018,3100}]};

get_spirit_lv_cfg(53) ->
	#spirit_lv_cfg{lv = 53,attr = [{1,1696},{2,33920},{3,848},{4,848}],cost = [{255,38040018,3150}]};

get_spirit_lv_cfg(54) ->
	#spirit_lv_cfg{lv = 54,attr = [{1,1728},{2,34560},{3,864},{4,864}],cost = [{255,38040018,3200}]};

get_spirit_lv_cfg(55) ->
	#spirit_lv_cfg{lv = 55,attr = [{1,1760},{2,35200},{3,880},{4,880}],cost = [{255,38040018,3250}]};

get_spirit_lv_cfg(56) ->
	#spirit_lv_cfg{lv = 56,attr = [{1,1792},{2,35840},{3,896},{4,896}],cost = [{255,38040018,3300}]};

get_spirit_lv_cfg(57) ->
	#spirit_lv_cfg{lv = 57,attr = [{1,1824},{2,36480},{3,912},{4,912}],cost = [{255,38040018,3350}]};

get_spirit_lv_cfg(58) ->
	#spirit_lv_cfg{lv = 58,attr = [{1,1856},{2,37120},{3,928},{4,928}],cost = [{255,38040018,3400}]};

get_spirit_lv_cfg(59) ->
	#spirit_lv_cfg{lv = 59,attr = [{1,1888},{2,37760},{3,944},{4,944}],cost = [{255,38040018,3450}]};

get_spirit_lv_cfg(60) ->
	#spirit_lv_cfg{lv = 60,attr = [{1,1920},{2,38400},{3,960},{4,960}],cost = [{255,38040018,3500}]};

get_spirit_lv_cfg(61) ->
	#spirit_lv_cfg{lv = 61,attr = [{1,1952},{2,39040},{3,976},{4,976}],cost = [{255,38040018,3550}]};

get_spirit_lv_cfg(62) ->
	#spirit_lv_cfg{lv = 62,attr = [{1,1984},{2,39680},{3,992},{4,992}],cost = [{255,38040018,3600}]};

get_spirit_lv_cfg(63) ->
	#spirit_lv_cfg{lv = 63,attr = [{1,2016},{2,40320},{3,1008},{4,1008}],cost = [{255,38040018,3650}]};

get_spirit_lv_cfg(64) ->
	#spirit_lv_cfg{lv = 64,attr = [{1,2048},{2,40960},{3,1024},{4,1024}],cost = [{255,38040018,3700}]};

get_spirit_lv_cfg(65) ->
	#spirit_lv_cfg{lv = 65,attr = [{1,2080},{2,41600},{3,1040},{4,1040}],cost = [{255,38040018,3750}]};

get_spirit_lv_cfg(66) ->
	#spirit_lv_cfg{lv = 66,attr = [{1,2112},{2,42240},{3,1056},{4,1056}],cost = [{255,38040018,3800}]};

get_spirit_lv_cfg(67) ->
	#spirit_lv_cfg{lv = 67,attr = [{1,2144},{2,42880},{3,1072},{4,1072}],cost = [{255,38040018,3850}]};

get_spirit_lv_cfg(68) ->
	#spirit_lv_cfg{lv = 68,attr = [{1,2176},{2,43520},{3,1088},{4,1088}],cost = [{255,38040018,3900}]};

get_spirit_lv_cfg(69) ->
	#spirit_lv_cfg{lv = 69,attr = [{1,2208},{2,44160},{3,1104},{4,1104}],cost = [{255,38040018,3950}]};

get_spirit_lv_cfg(70) ->
	#spirit_lv_cfg{lv = 70,attr = [{1,2240},{2,44800},{3,1120},{4,1120}],cost = [{255,38040018,4000}]};

get_spirit_lv_cfg(71) ->
	#spirit_lv_cfg{lv = 71,attr = [{1,2272},{2,45440},{3,1136},{4,1136}],cost = [{255,38040018,4050}]};

get_spirit_lv_cfg(72) ->
	#spirit_lv_cfg{lv = 72,attr = [{1,2304},{2,46080},{3,1152},{4,1152}],cost = [{255,38040018,4100}]};

get_spirit_lv_cfg(73) ->
	#spirit_lv_cfg{lv = 73,attr = [{1,2336},{2,46720},{3,1168},{4,1168}],cost = [{255,38040018,4150}]};

get_spirit_lv_cfg(74) ->
	#spirit_lv_cfg{lv = 74,attr = [{1,2368},{2,47360},{3,1184},{4,1184}],cost = [{255,38040018,4200}]};

get_spirit_lv_cfg(75) ->
	#spirit_lv_cfg{lv = 75,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],cost = [{255,38040018,4250}]};

get_spirit_lv_cfg(76) ->
	#spirit_lv_cfg{lv = 76,attr = [{1,2432},{2,48640},{3,1216},{4,1216}],cost = [{255,38040018,4300}]};

get_spirit_lv_cfg(77) ->
	#spirit_lv_cfg{lv = 77,attr = [{1,2464},{2,49280},{3,1232},{4,1232}],cost = [{255,38040018,4350}]};

get_spirit_lv_cfg(78) ->
	#spirit_lv_cfg{lv = 78,attr = [{1,2496},{2,49920},{3,1248},{4,1248}],cost = [{255,38040018,4400}]};

get_spirit_lv_cfg(79) ->
	#spirit_lv_cfg{lv = 79,attr = [{1,2528},{2,50560},{3,1264},{4,1264}],cost = [{255,38040018,4450}]};

get_spirit_lv_cfg(80) ->
	#spirit_lv_cfg{lv = 80,attr = [{1,2560},{2,51200},{3,1280},{4,1280}],cost = [{255,38040018,4500}]};

get_spirit_lv_cfg(81) ->
	#spirit_lv_cfg{lv = 81,attr = [{1,2592},{2,51840},{3,1296},{4,1296}],cost = [{255,38040018,4550}]};

get_spirit_lv_cfg(82) ->
	#spirit_lv_cfg{lv = 82,attr = [{1,2624},{2,52480},{3,1312},{4,1312}],cost = [{255,38040018,4600}]};

get_spirit_lv_cfg(83) ->
	#spirit_lv_cfg{lv = 83,attr = [{1,2656},{2,53120},{3,1328},{4,1328}],cost = [{255,38040018,4650}]};

get_spirit_lv_cfg(84) ->
	#spirit_lv_cfg{lv = 84,attr = [{1,2688},{2,53760},{3,1344},{4,1344}],cost = [{255,38040018,4700}]};

get_spirit_lv_cfg(85) ->
	#spirit_lv_cfg{lv = 85,attr = [{1,2720},{2,54400},{3,1360},{4,1360}],cost = [{255,38040018,4750}]};

get_spirit_lv_cfg(86) ->
	#spirit_lv_cfg{lv = 86,attr = [{1,2752},{2,55040},{3,1376},{4,1376}],cost = [{255,38040018,4800}]};

get_spirit_lv_cfg(87) ->
	#spirit_lv_cfg{lv = 87,attr = [{1,2784},{2,55680},{3,1392},{4,1392}],cost = [{255,38040018,4850}]};

get_spirit_lv_cfg(88) ->
	#spirit_lv_cfg{lv = 88,attr = [{1,2816},{2,56320},{3,1408},{4,1408}],cost = [{255,38040018,4900}]};

get_spirit_lv_cfg(89) ->
	#spirit_lv_cfg{lv = 89,attr = [{1,2848},{2,56960},{3,1424},{4,1424}],cost = [{255,38040018,4950}]};

get_spirit_lv_cfg(90) ->
	#spirit_lv_cfg{lv = 90,attr = [{1,2880},{2,57600},{3,1440},{4,1440}],cost = [{255,38040018,5000}]};

get_spirit_lv_cfg(91) ->
	#spirit_lv_cfg{lv = 91,attr = [{1,2912},{2,58240},{3,1456},{4,1456}],cost = [{255,38040018,5050}]};

get_spirit_lv_cfg(92) ->
	#spirit_lv_cfg{lv = 92,attr = [{1,2944},{2,58880},{3,1472},{4,1472}],cost = [{255,38040018,5100}]};

get_spirit_lv_cfg(93) ->
	#spirit_lv_cfg{lv = 93,attr = [{1,2976},{2,59520},{3,1488},{4,1488}],cost = [{255,38040018,5150}]};

get_spirit_lv_cfg(94) ->
	#spirit_lv_cfg{lv = 94,attr = [{1,3008},{2,60160},{3,1504},{4,1504}],cost = [{255,38040018,5200}]};

get_spirit_lv_cfg(95) ->
	#spirit_lv_cfg{lv = 95,attr = [{1,3040},{2,60800},{3,1520},{4,1520}],cost = [{255,38040018,5250}]};

get_spirit_lv_cfg(96) ->
	#spirit_lv_cfg{lv = 96,attr = [{1,3072},{2,61440},{3,1536},{4,1536}],cost = [{255,38040018,5300}]};

get_spirit_lv_cfg(97) ->
	#spirit_lv_cfg{lv = 97,attr = [{1,3104},{2,62080},{3,1552},{4,1552}],cost = [{255,38040018,5350}]};

get_spirit_lv_cfg(98) ->
	#spirit_lv_cfg{lv = 98,attr = [{1,3136},{2,62720},{3,1568},{4,1568}],cost = [{255,38040018,5400}]};

get_spirit_lv_cfg(99) ->
	#spirit_lv_cfg{lv = 99,attr = [{1,3168},{2,63360},{3,1584},{4,1584}],cost = [{255,38040018,5450}]};

get_spirit_lv_cfg(100) ->
	#spirit_lv_cfg{lv = 100,attr = [{1,3200},{2,64000},{3,1600},{4,1600}],cost = [{255,38040018,5500}]};

get_spirit_lv_cfg(101) ->
	#spirit_lv_cfg{lv = 101,attr = [{1,3232},{2,64640},{3,1616},{4,1616}],cost = [{255,38040018,5550}]};

get_spirit_lv_cfg(102) ->
	#spirit_lv_cfg{lv = 102,attr = [{1,3264},{2,65280},{3,1632},{4,1632}],cost = [{255,38040018,5600}]};

get_spirit_lv_cfg(103) ->
	#spirit_lv_cfg{lv = 103,attr = [{1,3296},{2,65920},{3,1648},{4,1648}],cost = [{255,38040018,5650}]};

get_spirit_lv_cfg(104) ->
	#spirit_lv_cfg{lv = 104,attr = [{1,3328},{2,66560},{3,1664},{4,1664}],cost = [{255,38040018,5700}]};

get_spirit_lv_cfg(105) ->
	#spirit_lv_cfg{lv = 105,attr = [{1,3360},{2,67200},{3,1680},{4,1680}],cost = [{255,38040018,5750}]};

get_spirit_lv_cfg(106) ->
	#spirit_lv_cfg{lv = 106,attr = [{1,3392},{2,67840},{3,1696},{4,1696}],cost = [{255,38040018,5800}]};

get_spirit_lv_cfg(107) ->
	#spirit_lv_cfg{lv = 107,attr = [{1,3424},{2,68480},{3,1712},{4,1712}],cost = [{255,38040018,5850}]};

get_spirit_lv_cfg(108) ->
	#spirit_lv_cfg{lv = 108,attr = [{1,3456},{2,69120},{3,1728},{4,1728}],cost = [{255,38040018,5900}]};

get_spirit_lv_cfg(109) ->
	#spirit_lv_cfg{lv = 109,attr = [{1,3488},{2,69760},{3,1744},{4,1744}],cost = [{255,38040018,5950}]};

get_spirit_lv_cfg(110) ->
	#spirit_lv_cfg{lv = 110,attr = [{1,3520},{2,70400},{3,1760},{4,1760}],cost = [{255,38040018,6000}]};

get_spirit_lv_cfg(111) ->
	#spirit_lv_cfg{lv = 111,attr = [{1,3552},{2,71040},{3,1776},{4,1776}],cost = [{255,38040018,6050}]};

get_spirit_lv_cfg(112) ->
	#spirit_lv_cfg{lv = 112,attr = [{1,3584},{2,71680},{3,1792},{4,1792}],cost = [{255,38040018,6100}]};

get_spirit_lv_cfg(113) ->
	#spirit_lv_cfg{lv = 113,attr = [{1,3616},{2,72320},{3,1808},{4,1808}],cost = [{255,38040018,6150}]};

get_spirit_lv_cfg(114) ->
	#spirit_lv_cfg{lv = 114,attr = [{1,3648},{2,72960},{3,1824},{4,1824}],cost = [{255,38040018,6200}]};

get_spirit_lv_cfg(115) ->
	#spirit_lv_cfg{lv = 115,attr = [{1,3680},{2,73600},{3,1840},{4,1840}],cost = [{255,38040018,6250}]};

get_spirit_lv_cfg(116) ->
	#spirit_lv_cfg{lv = 116,attr = [{1,3712},{2,74240},{3,1856},{4,1856}],cost = [{255,38040018,6300}]};

get_spirit_lv_cfg(117) ->
	#spirit_lv_cfg{lv = 117,attr = [{1,3744},{2,74880},{3,1872},{4,1872}],cost = [{255,38040018,6350}]};

get_spirit_lv_cfg(118) ->
	#spirit_lv_cfg{lv = 118,attr = [{1,3776},{2,75520},{3,1888},{4,1888}],cost = [{255,38040018,6400}]};

get_spirit_lv_cfg(119) ->
	#spirit_lv_cfg{lv = 119,attr = [{1,3808},{2,76160},{3,1904},{4,1904}],cost = [{255,38040018,6450}]};

get_spirit_lv_cfg(120) ->
	#spirit_lv_cfg{lv = 120,attr = [{1,3840},{2,76800},{3,1920},{4,1920}],cost = [{255,38040018,6500}]};

get_spirit_lv_cfg(121) ->
	#spirit_lv_cfg{lv = 121,attr = [{1,3872},{2,77440},{3,1936},{4,1936}],cost = [{255,38040018,6550}]};

get_spirit_lv_cfg(122) ->
	#spirit_lv_cfg{lv = 122,attr = [{1,3904},{2,78080},{3,1952},{4,1952}],cost = [{255,38040018,6600}]};

get_spirit_lv_cfg(123) ->
	#spirit_lv_cfg{lv = 123,attr = [{1,3936},{2,78720},{3,1968},{4,1968}],cost = [{255,38040018,6650}]};

get_spirit_lv_cfg(124) ->
	#spirit_lv_cfg{lv = 124,attr = [{1,3968},{2,79360},{3,1984},{4,1984}],cost = [{255,38040018,6700}]};

get_spirit_lv_cfg(125) ->
	#spirit_lv_cfg{lv = 125,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],cost = [{255,38040018,6750}]};

get_spirit_lv_cfg(126) ->
	#spirit_lv_cfg{lv = 126,attr = [{1,4032},{2,80640},{3,2016},{4,2016}],cost = [{255,38040018,6800}]};

get_spirit_lv_cfg(127) ->
	#spirit_lv_cfg{lv = 127,attr = [{1,4064},{2,81280},{3,2032},{4,2032}],cost = [{255,38040018,6850}]};

get_spirit_lv_cfg(128) ->
	#spirit_lv_cfg{lv = 128,attr = [{1,4096},{2,81920},{3,2048},{4,2048}],cost = [{255,38040018,6900}]};

get_spirit_lv_cfg(129) ->
	#spirit_lv_cfg{lv = 129,attr = [{1,4128},{2,82560},{3,2064},{4,2064}],cost = [{255,38040018,6950}]};

get_spirit_lv_cfg(130) ->
	#spirit_lv_cfg{lv = 130,attr = [{1,4160},{2,83200},{3,2080},{4,2080}],cost = [{255,38040018,7000}]};

get_spirit_lv_cfg(131) ->
	#spirit_lv_cfg{lv = 131,attr = [{1,4192},{2,83840},{3,2096},{4,2096}],cost = [{255,38040018,7050}]};

get_spirit_lv_cfg(132) ->
	#spirit_lv_cfg{lv = 132,attr = [{1,4224},{2,84480},{3,2112},{4,2112}],cost = [{255,38040018,7100}]};

get_spirit_lv_cfg(133) ->
	#spirit_lv_cfg{lv = 133,attr = [{1,4256},{2,85120},{3,2128},{4,2128}],cost = [{255,38040018,7150}]};

get_spirit_lv_cfg(134) ->
	#spirit_lv_cfg{lv = 134,attr = [{1,4288},{2,85760},{3,2144},{4,2144}],cost = [{255,38040018,7200}]};

get_spirit_lv_cfg(135) ->
	#spirit_lv_cfg{lv = 135,attr = [{1,4320},{2,86400},{3,2160},{4,2160}],cost = [{255,38040018,7250}]};

get_spirit_lv_cfg(136) ->
	#spirit_lv_cfg{lv = 136,attr = [{1,4352},{2,87040},{3,2176},{4,2176}],cost = [{255,38040018,7300}]};

get_spirit_lv_cfg(137) ->
	#spirit_lv_cfg{lv = 137,attr = [{1,4384},{2,87680},{3,2192},{4,2192}],cost = [{255,38040018,7350}]};

get_spirit_lv_cfg(138) ->
	#spirit_lv_cfg{lv = 138,attr = [{1,4416},{2,88320},{3,2208},{4,2208}],cost = [{255,38040018,7400}]};

get_spirit_lv_cfg(139) ->
	#spirit_lv_cfg{lv = 139,attr = [{1,4448},{2,88960},{3,2224},{4,2224}],cost = [{255,38040018,7450}]};

get_spirit_lv_cfg(140) ->
	#spirit_lv_cfg{lv = 140,attr = [{1,4480},{2,89600},{3,2240},{4,2240}],cost = [{255,38040018,7500}]};

get_spirit_lv_cfg(141) ->
	#spirit_lv_cfg{lv = 141,attr = [{1,4512},{2,90240},{3,2256},{4,2256}],cost = [{255,38040018,7550}]};

get_spirit_lv_cfg(142) ->
	#spirit_lv_cfg{lv = 142,attr = [{1,4544},{2,90880},{3,2272},{4,2272}],cost = [{255,38040018,7600}]};

get_spirit_lv_cfg(143) ->
	#spirit_lv_cfg{lv = 143,attr = [{1,4576},{2,91520},{3,2288},{4,2288}],cost = [{255,38040018,7650}]};

get_spirit_lv_cfg(144) ->
	#spirit_lv_cfg{lv = 144,attr = [{1,4608},{2,92160},{3,2304},{4,2304}],cost = [{255,38040018,7700}]};

get_spirit_lv_cfg(145) ->
	#spirit_lv_cfg{lv = 145,attr = [{1,4640},{2,92800},{3,2320},{4,2320}],cost = [{255,38040018,7750}]};

get_spirit_lv_cfg(146) ->
	#spirit_lv_cfg{lv = 146,attr = [{1,4672},{2,93440},{3,2336},{4,2336}],cost = [{255,38040018,7800}]};

get_spirit_lv_cfg(147) ->
	#spirit_lv_cfg{lv = 147,attr = [{1,4704},{2,94080},{3,2352},{4,2352}],cost = [{255,38040018,7850}]};

get_spirit_lv_cfg(148) ->
	#spirit_lv_cfg{lv = 148,attr = [{1,4736},{2,94720},{3,2368},{4,2368}],cost = [{255,38040018,7900}]};

get_spirit_lv_cfg(149) ->
	#spirit_lv_cfg{lv = 149,attr = [{1,4768},{2,95360},{3,2384},{4,2384}],cost = [{255,38040018,7950}]};

get_spirit_lv_cfg(150) ->
	#spirit_lv_cfg{lv = 150,attr = [{1,4800},{2,96000},{3,2400},{4,2400}],cost = [{255,38040018,8000}]};

get_spirit_lv_cfg(151) ->
	#spirit_lv_cfg{lv = 151,attr = [{1,4832},{2,96640},{3,2416},{4,2416}],cost = [{255,38040018,8050}]};

get_spirit_lv_cfg(152) ->
	#spirit_lv_cfg{lv = 152,attr = [{1,4864},{2,97280},{3,2432},{4,2432}],cost = [{255,38040018,8100}]};

get_spirit_lv_cfg(153) ->
	#spirit_lv_cfg{lv = 153,attr = [{1,4896},{2,97920},{3,2448},{4,2448}],cost = [{255,38040018,8150}]};

get_spirit_lv_cfg(154) ->
	#spirit_lv_cfg{lv = 154,attr = [{1,4928},{2,98560},{3,2464},{4,2464}],cost = [{255,38040018,8200}]};

get_spirit_lv_cfg(155) ->
	#spirit_lv_cfg{lv = 155,attr = [{1,4960},{2,99200},{3,2480},{4,2480}],cost = [{255,38040018,8250}]};

get_spirit_lv_cfg(156) ->
	#spirit_lv_cfg{lv = 156,attr = [{1,4992},{2,99840},{3,2496},{4,2496}],cost = [{255,38040018,8300}]};

get_spirit_lv_cfg(157) ->
	#spirit_lv_cfg{lv = 157,attr = [{1,5024},{2,100480},{3,2512},{4,2512}],cost = [{255,38040018,8350}]};

get_spirit_lv_cfg(158) ->
	#spirit_lv_cfg{lv = 158,attr = [{1,5056},{2,101120},{3,2528},{4,2528}],cost = [{255,38040018,8400}]};

get_spirit_lv_cfg(159) ->
	#spirit_lv_cfg{lv = 159,attr = [{1,5088},{2,101760},{3,2544},{4,2544}],cost = [{255,38040018,8450}]};

get_spirit_lv_cfg(160) ->
	#spirit_lv_cfg{lv = 160,attr = [{1,5120},{2,102400},{3,2560},{4,2560}],cost = [{255,38040018,8500}]};

get_spirit_lv_cfg(161) ->
	#spirit_lv_cfg{lv = 161,attr = [{1,5152},{2,103040},{3,2576},{4,2576}],cost = [{255,38040018,8550}]};

get_spirit_lv_cfg(162) ->
	#spirit_lv_cfg{lv = 162,attr = [{1,5184},{2,103680},{3,2592},{4,2592}],cost = [{255,38040018,8600}]};

get_spirit_lv_cfg(163) ->
	#spirit_lv_cfg{lv = 163,attr = [{1,5216},{2,104320},{3,2608},{4,2608}],cost = [{255,38040018,8650}]};

get_spirit_lv_cfg(164) ->
	#spirit_lv_cfg{lv = 164,attr = [{1,5248},{2,104960},{3,2624},{4,2624}],cost = [{255,38040018,8700}]};

get_spirit_lv_cfg(165) ->
	#spirit_lv_cfg{lv = 165,attr = [{1,5280},{2,105600},{3,2640},{4,2640}],cost = [{255,38040018,8750}]};

get_spirit_lv_cfg(166) ->
	#spirit_lv_cfg{lv = 166,attr = [{1,5312},{2,106240},{3,2656},{4,2656}],cost = [{255,38040018,8800}]};

get_spirit_lv_cfg(167) ->
	#spirit_lv_cfg{lv = 167,attr = [{1,5344},{2,106880},{3,2672},{4,2672}],cost = [{255,38040018,8850}]};

get_spirit_lv_cfg(168) ->
	#spirit_lv_cfg{lv = 168,attr = [{1,5376},{2,107520},{3,2688},{4,2688}],cost = [{255,38040018,8900}]};

get_spirit_lv_cfg(169) ->
	#spirit_lv_cfg{lv = 169,attr = [{1,5408},{2,108160},{3,2704},{4,2704}],cost = [{255,38040018,8950}]};

get_spirit_lv_cfg(170) ->
	#spirit_lv_cfg{lv = 170,attr = [{1,5440},{2,108800},{3,2720},{4,2720}],cost = [{255,38040018,9000}]};

get_spirit_lv_cfg(171) ->
	#spirit_lv_cfg{lv = 171,attr = [{1,5472},{2,109440},{3,2736},{4,2736}],cost = [{255,38040018,9050}]};

get_spirit_lv_cfg(172) ->
	#spirit_lv_cfg{lv = 172,attr = [{1,5504},{2,110080},{3,2752},{4,2752}],cost = [{255,38040018,9100}]};

get_spirit_lv_cfg(173) ->
	#spirit_lv_cfg{lv = 173,attr = [{1,5536},{2,110720},{3,2768},{4,2768}],cost = [{255,38040018,9150}]};

get_spirit_lv_cfg(174) ->
	#spirit_lv_cfg{lv = 174,attr = [{1,5568},{2,111360},{3,2784},{4,2784}],cost = [{255,38040018,9200}]};

get_spirit_lv_cfg(175) ->
	#spirit_lv_cfg{lv = 175,attr = [{1,5600},{2,112000},{3,2800},{4,2800}],cost = [{255,38040018,9250}]};

get_spirit_lv_cfg(176) ->
	#spirit_lv_cfg{lv = 176,attr = [{1,5632},{2,112640},{3,2816},{4,2816}],cost = [{255,38040018,9300}]};

get_spirit_lv_cfg(177) ->
	#spirit_lv_cfg{lv = 177,attr = [{1,5664},{2,113280},{3,2832},{4,2832}],cost = [{255,38040018,9350}]};

get_spirit_lv_cfg(178) ->
	#spirit_lv_cfg{lv = 178,attr = [{1,5696},{2,113920},{3,2848},{4,2848}],cost = [{255,38040018,9400}]};

get_spirit_lv_cfg(179) ->
	#spirit_lv_cfg{lv = 179,attr = [{1,5728},{2,114560},{3,2864},{4,2864}],cost = [{255,38040018,9450}]};

get_spirit_lv_cfg(180) ->
	#spirit_lv_cfg{lv = 180,attr = [{1,5760},{2,115200},{3,2880},{4,2880}],cost = [{255,38040018,9500}]};

get_spirit_lv_cfg(181) ->
	#spirit_lv_cfg{lv = 181,attr = [{1,5792},{2,115840},{3,2896},{4,2896}],cost = [{255,38040018,9550}]};

get_spirit_lv_cfg(182) ->
	#spirit_lv_cfg{lv = 182,attr = [{1,5824},{2,116480},{3,2912},{4,2912}],cost = [{255,38040018,9600}]};

get_spirit_lv_cfg(183) ->
	#spirit_lv_cfg{lv = 183,attr = [{1,5856},{2,117120},{3,2928},{4,2928}],cost = [{255,38040018,9650}]};

get_spirit_lv_cfg(184) ->
	#spirit_lv_cfg{lv = 184,attr = [{1,5888},{2,117760},{3,2944},{4,2944}],cost = [{255,38040018,9700}]};

get_spirit_lv_cfg(185) ->
	#spirit_lv_cfg{lv = 185,attr = [{1,5920},{2,118400},{3,2960},{4,2960}],cost = [{255,38040018,9750}]};

get_spirit_lv_cfg(186) ->
	#spirit_lv_cfg{lv = 186,attr = [{1,5952},{2,119040},{3,2976},{4,2976}],cost = [{255,38040018,9800}]};

get_spirit_lv_cfg(187) ->
	#spirit_lv_cfg{lv = 187,attr = [{1,5984},{2,119680},{3,2992},{4,2992}],cost = [{255,38040018,9850}]};

get_spirit_lv_cfg(188) ->
	#spirit_lv_cfg{lv = 188,attr = [{1,6016},{2,120320},{3,3008},{4,3008}],cost = [{255,38040018,9900}]};

get_spirit_lv_cfg(189) ->
	#spirit_lv_cfg{lv = 189,attr = [{1,6048},{2,120960},{3,3024},{4,3024}],cost = [{255,38040018,9950}]};

get_spirit_lv_cfg(190) ->
	#spirit_lv_cfg{lv = 190,attr = [{1,6080},{2,121600},{3,3040},{4,3040}],cost = [{255,38040018,10000}]};

get_spirit_lv_cfg(191) ->
	#spirit_lv_cfg{lv = 191,attr = [{1,6112},{2,122240},{3,3056},{4,3056}],cost = [{255,38040018,10050}]};

get_spirit_lv_cfg(192) ->
	#spirit_lv_cfg{lv = 192,attr = [{1,6144},{2,122880},{3,3072},{4,3072}],cost = [{255,38040018,10100}]};

get_spirit_lv_cfg(193) ->
	#spirit_lv_cfg{lv = 193,attr = [{1,6176},{2,123520},{3,3088},{4,3088}],cost = [{255,38040018,10150}]};

get_spirit_lv_cfg(194) ->
	#spirit_lv_cfg{lv = 194,attr = [{1,6208},{2,124160},{3,3104},{4,3104}],cost = [{255,38040018,10200}]};

get_spirit_lv_cfg(195) ->
	#spirit_lv_cfg{lv = 195,attr = [{1,6240},{2,124800},{3,3120},{4,3120}],cost = [{255,38040018,10250}]};

get_spirit_lv_cfg(196) ->
	#spirit_lv_cfg{lv = 196,attr = [{1,6272},{2,125440},{3,3136},{4,3136}],cost = [{255,38040018,10300}]};

get_spirit_lv_cfg(197) ->
	#spirit_lv_cfg{lv = 197,attr = [{1,6304},{2,126080},{3,3152},{4,3152}],cost = [{255,38040018,10350}]};

get_spirit_lv_cfg(198) ->
	#spirit_lv_cfg{lv = 198,attr = [{1,6336},{2,126720},{3,3168},{4,3168}],cost = [{255,38040018,10400}]};

get_spirit_lv_cfg(199) ->
	#spirit_lv_cfg{lv = 199,attr = [{1,6368},{2,127360},{3,3184},{4,3184}],cost = [{255,38040018,10450}]};

get_spirit_lv_cfg(200) ->
	#spirit_lv_cfg{lv = 200,attr = [{1,6400},{2,128000},{3,3200},{4,3200}],cost = [{255,38040018,0}]};

get_spirit_lv_cfg(_Lv) ->
	[].

