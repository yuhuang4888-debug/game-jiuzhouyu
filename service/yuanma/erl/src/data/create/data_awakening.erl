%%%---------------------------------------
%%% module      : data_awakening
%%% description : 天命觉醒配置
%%%
%%%---------------------------------------
-module(data_awakening).
-compile(export_all).
-include("awakening.hrl").



get_awakening_cell_cfg(1) ->
	#awakening_cell_cfg{id = 1,task_id = 301400,name = "天命I",pre_id = 0,next_id = 2,priority_consume = [{0,38110001,8}],exp_consume = 15500000000,attr = [{1,270},{2,5400}]};

get_awakening_cell_cfg(2) ->
	#awakening_cell_cfg{id = 2,task_id = 301400,name = "天命II",pre_id = 1,next_id = 3,priority_consume = [{0,38110001,10}],exp_consume = 16000000000,attr = [{3,270},{4,270}]};

get_awakening_cell_cfg(3) ->
	#awakening_cell_cfg{id = 3,task_id = 301400,name = "天命III",pre_id = 2,next_id = 4,priority_consume = [{0,38110001,12}],exp_consume = 16500000000,attr = [{1,270},{3,270}]};

get_awakening_cell_cfg(4) ->
	#awakening_cell_cfg{id = 4,task_id = 301400,name = "天命IV",pre_id = 3,next_id = 5,priority_consume = [{0,38110001,14}],exp_consume = 17000000000,attr = [{2,5400},{4,270}]};

get_awakening_cell_cfg(5) ->
	#awakening_cell_cfg{id = 5,task_id = 301400,name = "天命V",pre_id = 4,next_id = 6,priority_consume = [{0,38110001,14}],exp_consume = 17500000000,attr = [{1,270},{4,270}]};

get_awakening_cell_cfg(6) ->
	#awakening_cell_cfg{id = 6,task_id = 301400,name = "天命VI",pre_id = 5,next_id = 7,priority_consume = [{0,38110001,16}],exp_consume = 18000000000,attr = [{2,5400},{3,270}]};

get_awakening_cell_cfg(7) ->
	#awakening_cell_cfg{id = 7,task_id = 301400,name = "天命VII",pre_id = 6,next_id = 8,priority_consume = [{0,38110001,16}],exp_consume = 18500000000,attr = [{1,270},{2,5400}]};

get_awakening_cell_cfg(8) ->
	#awakening_cell_cfg{id = 8,task_id = 301400,name = "天命VIII",pre_id = 7,next_id = 9,priority_consume = [{0,38110001,18}],exp_consume = 19000000000,attr = [{3,270},{4,270}]};

get_awakening_cell_cfg(9) ->
	#awakening_cell_cfg{id = 9,task_id = 301400,name = "天命IX",pre_id = 8,next_id = 10,priority_consume = [{0,38110001,20}],exp_consume = 19500000000,attr = [{1,270},{3,270}]};

get_awakening_cell_cfg(10) ->
	#awakening_cell_cfg{id = 10,task_id = 301400,name = "天命X",pre_id = 9,next_id = 0,priority_consume = [{0,38110001,22}],exp_consume = 20000000000,attr = [{2,5400},{4,270}]};

get_awakening_cell_cfg(11) ->
	#awakening_cell_cfg{id = 11,task_id = 301500,name = "不灭源力I",pre_id = 0,next_id = 12,priority_consume = [{0,38110002,15}],exp_consume = 90000000000,attr = [{1,360},{2,7200}]};

get_awakening_cell_cfg(12) ->
	#awakening_cell_cfg{id = 12,task_id = 301500,name = "不灭源力II",pre_id = 11,next_id = 13,priority_consume = [{0,38110002,15}],exp_consume = 95000000000,attr = [{3,360},{4,360}]};

get_awakening_cell_cfg(13) ->
	#awakening_cell_cfg{id = 13,task_id = 301500,name = "不灭源力III",pre_id = 12,next_id = 14,priority_consume = [{0,38110002,15}],exp_consume = 100000000000,attr = [{1,360},{3,360}]};

get_awakening_cell_cfg(14) ->
	#awakening_cell_cfg{id = 14,task_id = 301500,name = "不灭源力IV",pre_id = 13,next_id = 15,priority_consume = [{0,38110002,15}],exp_consume = 105000000000,attr = [{2,7200},{4,360}]};

get_awakening_cell_cfg(15) ->
	#awakening_cell_cfg{id = 15,task_id = 301500,name = "不灭源力V",pre_id = 14,next_id = 16,priority_consume = [{0,38110002,15}],exp_consume = 110000000000,attr = [{1,360},{4,360}]};

get_awakening_cell_cfg(16) ->
	#awakening_cell_cfg{id = 16,task_id = 301500,name = "超然源力I",pre_id = 15,next_id = 17,priority_consume = [{0,38110003,15}],exp_consume = 115000000000,attr = [{1,420},{2,8400}]};

get_awakening_cell_cfg(17) ->
	#awakening_cell_cfg{id = 17,task_id = 301500,name = "超然源力II",pre_id = 16,next_id = 18,priority_consume = [{0,38110003,15}],exp_consume = 120000000000,attr = [{3,420},{4,420}]};

get_awakening_cell_cfg(18) ->
	#awakening_cell_cfg{id = 18,task_id = 301500,name = "超然源力III",pre_id = 17,next_id = 19,priority_consume = [{0,38110003,15}],exp_consume = 125000000000,attr = [{1,420},{3,420}]};

get_awakening_cell_cfg(19) ->
	#awakening_cell_cfg{id = 19,task_id = 301500,name = "超然源力IV",pre_id = 18,next_id = 20,priority_consume = [{0,38110003,15}],exp_consume = 130000000000,attr = [{2,8400},{4,420}]};

get_awakening_cell_cfg(20) ->
	#awakening_cell_cfg{id = 20,task_id = 301500,name = "超然源力V",pre_id = 19,next_id = 21,priority_consume = [{0,38110003,15}],exp_consume = 135000000000,attr = [{1,420},{4,420}]};

get_awakening_cell_cfg(21) ->
	#awakening_cell_cfg{id = 21,task_id = 301500,name = "诡诈源力I",pre_id = 20,next_id = 22,priority_consume = [{0,38110004,15}],exp_consume = 140000000000,attr = [{1,480},{2,9600}]};

get_awakening_cell_cfg(22) ->
	#awakening_cell_cfg{id = 22,task_id = 301500,name = "诡诈源力II",pre_id = 21,next_id = 23,priority_consume = [{0,38110004,15}],exp_consume = 145000000000,attr = [{3,480},{4,480}]};

get_awakening_cell_cfg(23) ->
	#awakening_cell_cfg{id = 23,task_id = 301500,name = "诡诈源力III",pre_id = 22,next_id = 24,priority_consume = [{0,38110004,15}],exp_consume = 150000000000,attr = [{1,480},{3,480}]};

get_awakening_cell_cfg(24) ->
	#awakening_cell_cfg{id = 24,task_id = 301500,name = "诡诈源力IV",pre_id = 23,next_id = 25,priority_consume = [{0,38110004,15}],exp_consume = 155000000000,attr = [{2,9600},{4,480}]};

get_awakening_cell_cfg(25) ->
	#awakening_cell_cfg{id = 25,task_id = 301500,name = "诡诈源力V",pre_id = 24,next_id = 0,priority_consume = [{0,38110004,15}],exp_consume = 160000000000,attr = [{1,480},{4,480}]};

get_awakening_cell_cfg(26) ->
	#awakening_cell_cfg{id = 26,task_id = 301600,name = "混沌神格I",pre_id = 0,next_id = 27,priority_consume = [{0,38110005,10}],exp_consume = 600000000000,attr = [{1,420},{2,8400}]};

get_awakening_cell_cfg(27) ->
	#awakening_cell_cfg{id = 27,task_id = 301600,name = "混沌神格II",pre_id = 26,next_id = 28,priority_consume = [{0,38110005,10}],exp_consume = 600000000000,attr = [{3,420},{4,420}]};

get_awakening_cell_cfg(28) ->
	#awakening_cell_cfg{id = 28,task_id = 301600,name = "混沌神格III",pre_id = 27,next_id = 29,priority_consume = [{0,38110005,10}],exp_consume = 600000000000,attr = [{1,420},{3,420}]};

get_awakening_cell_cfg(29) ->
	#awakening_cell_cfg{id = 29,task_id = 301600,name = "混沌神格IV",pre_id = 28,next_id = 30,priority_consume = [{0,38110005,10}],exp_consume = 600000000000,attr = [{2,8400},{4,420}]};

get_awakening_cell_cfg(30) ->
	#awakening_cell_cfg{id = 30,task_id = 301600,name = "混沌神格V",pre_id = 29,next_id = 31,priority_consume = [{0,38110005,10}],exp_consume = 600000000000,attr = [{1,420},{4,420}]};

get_awakening_cell_cfg(31) ->
	#awakening_cell_cfg{id = 31,task_id = 301600,name = "深渊神格I",pre_id = 30,next_id = 32,priority_consume = [{0,38110005,10}],exp_consume = 650000000000,attr = [{1,450},{2,9000}]};

get_awakening_cell_cfg(32) ->
	#awakening_cell_cfg{id = 32,task_id = 301600,name = "深渊神格II",pre_id = 31,next_id = 33,priority_consume = [{0,38110005,10}],exp_consume = 650000000000,attr = [{3,450},{4,450}]};

get_awakening_cell_cfg(33) ->
	#awakening_cell_cfg{id = 33,task_id = 301600,name = "深渊神格III",pre_id = 32,next_id = 34,priority_consume = [{0,38110005,10}],exp_consume = 650000000000,attr = [{1,450},{3,450}]};

get_awakening_cell_cfg(34) ->
	#awakening_cell_cfg{id = 34,task_id = 301600,name = "深渊神格IV",pre_id = 33,next_id = 35,priority_consume = [{0,38110005,10}],exp_consume = 650000000000,attr = [{2,9000},{4,450}]};

get_awakening_cell_cfg(35) ->
	#awakening_cell_cfg{id = 35,task_id = 301600,name = "深渊神格V",pre_id = 34,next_id = 36,priority_consume = [{0,38110005,10}],exp_consume = 650000000000,attr = [{1,450},{4,450}]};

get_awakening_cell_cfg(36) ->
	#awakening_cell_cfg{id = 36,task_id = 301600,name = "虚空神格I",pre_id = 35,next_id = 37,priority_consume = [{0,38110005,10}],exp_consume = 700000000000,attr = [{1,480},{2,9600}]};

get_awakening_cell_cfg(37) ->
	#awakening_cell_cfg{id = 37,task_id = 301600,name = "虚空神格II",pre_id = 36,next_id = 38,priority_consume = [{0,38110005,10}],exp_consume = 700000000000,attr = [{3,480},{4,480}]};

get_awakening_cell_cfg(38) ->
	#awakening_cell_cfg{id = 38,task_id = 301600,name = "虚空神格III",pre_id = 37,next_id = 39,priority_consume = [{0,38110005,10}],exp_consume = 700000000000,attr = [{1,480},{3,480}]};

get_awakening_cell_cfg(39) ->
	#awakening_cell_cfg{id = 39,task_id = 301600,name = "虚空神格IV",pre_id = 38,next_id = 40,priority_consume = [{0,38110005,10}],exp_consume = 700000000000,attr = [{2,9600},{4,480}]};

get_awakening_cell_cfg(40) ->
	#awakening_cell_cfg{id = 40,task_id = 301600,name = "虚空神格V",pre_id = 39,next_id = 41,priority_consume = [{0,38110005,10}],exp_consume = 700000000000,attr = [{1,480},{4,480}]};

get_awakening_cell_cfg(41) ->
	#awakening_cell_cfg{id = 41,task_id = 301600,name = "灾厄神格I",pre_id = 40,next_id = 42,priority_consume = [{0,38110005,10}],exp_consume = 750000000000,attr = [{1,510},{2,10800}]};

get_awakening_cell_cfg(42) ->
	#awakening_cell_cfg{id = 42,task_id = 301600,name = "灾厄神格II",pre_id = 41,next_id = 43,priority_consume = [{0,38110005,10}],exp_consume = 750000000000,attr = [{3,510},{4,510}]};

get_awakening_cell_cfg(43) ->
	#awakening_cell_cfg{id = 43,task_id = 301600,name = "灾厄神格III",pre_id = 42,next_id = 44,priority_consume = [{0,38110005,10}],exp_consume = 750000000000,attr = [{1,510},{3,510}]};

get_awakening_cell_cfg(44) ->
	#awakening_cell_cfg{id = 44,task_id = 301600,name = "灾厄神格IV",pre_id = 43,next_id = 45,priority_consume = [{0,38110005,10}],exp_consume = 750000000000,attr = [{2,10800},{4,510}]};

get_awakening_cell_cfg(45) ->
	#awakening_cell_cfg{id = 45,task_id = 301600,name = "灾厄神格V",pre_id = 44,next_id = 0,priority_consume = [{0,38110005,10}],exp_consume = 750000000000,attr = [{1,510},{4,510}]};

get_awakening_cell_cfg(46) ->
	#awakening_cell_cfg{id = 46,task_id = 301700,name = "永生命盘I",pre_id = 0,next_id = 47,priority_consume = [{0,38110009,10}],exp_consume = 3000000000000,attr = [{1,450},{2,9000}]};

get_awakening_cell_cfg(47) ->
	#awakening_cell_cfg{id = 47,task_id = 301700,name = "永生命盘II",pre_id = 46,next_id = 48,priority_consume = [{0,38110009,10}],exp_consume = 3000000000000,attr = [{3,450},{4,450}]};

get_awakening_cell_cfg(48) ->
	#awakening_cell_cfg{id = 48,task_id = 301700,name = "永生命盘III",pre_id = 47,next_id = 49,priority_consume = [{0,38110009,10}],exp_consume = 3000000000000,attr = [{1,450},{3,450}]};

get_awakening_cell_cfg(49) ->
	#awakening_cell_cfg{id = 49,task_id = 301700,name = "永生命盘IV",pre_id = 48,next_id = 50,priority_consume = [{0,38110009,10}],exp_consume = 3000000000000,attr = [{2,9000},{4,450}]};

get_awakening_cell_cfg(50) ->
	#awakening_cell_cfg{id = 50,task_id = 301700,name = "永生命盘V",pre_id = 49,next_id = 51,priority_consume = [{0,38110009,10}],exp_consume = 3000000000000,attr = [{1,450},{4,450}]};

get_awakening_cell_cfg(51) ->
	#awakening_cell_cfg{id = 51,task_id = 301700,name = "天穹命盘I",pre_id = 50,next_id = 52,priority_consume = [{0,38110009,10}],exp_consume = 3200000000000,attr = [{1,480},{2,9600}]};

get_awakening_cell_cfg(52) ->
	#awakening_cell_cfg{id = 52,task_id = 301700,name = "天穹命盘II",pre_id = 51,next_id = 53,priority_consume = [{0,38110009,10}],exp_consume = 3200000000000,attr = [{3,480},{4,480}]};

get_awakening_cell_cfg(53) ->
	#awakening_cell_cfg{id = 53,task_id = 301700,name = "天穹命盘III",pre_id = 52,next_id = 54,priority_consume = [{0,38110009,10}],exp_consume = 3200000000000,attr = [{1,480},{3,480}]};

get_awakening_cell_cfg(54) ->
	#awakening_cell_cfg{id = 54,task_id = 301700,name = "天穹命盘IV",pre_id = 53,next_id = 55,priority_consume = [{0,38110009,10}],exp_consume = 3200000000000,attr = [{2,9600},{4,480}]};

get_awakening_cell_cfg(55) ->
	#awakening_cell_cfg{id = 55,task_id = 301700,name = "天穹命盘V",pre_id = 54,next_id = 56,priority_consume = [{0,38110009,10}],exp_consume = 3200000000000,attr = [{1,480},{4,480}]};

get_awakening_cell_cfg(56) ->
	#awakening_cell_cfg{id = 56,task_id = 301700,name = "浩劫命盘I",pre_id = 55,next_id = 57,priority_consume = [{0,38110009,10}],exp_consume = 3400000000000,attr = [{1,510},{2,10200}]};

get_awakening_cell_cfg(57) ->
	#awakening_cell_cfg{id = 57,task_id = 301700,name = "浩劫命盘II",pre_id = 56,next_id = 58,priority_consume = [{0,38110009,10}],exp_consume = 3400000000000,attr = [{3,510},{4,510}]};

get_awakening_cell_cfg(58) ->
	#awakening_cell_cfg{id = 58,task_id = 301700,name = "浩劫命盘III",pre_id = 57,next_id = 59,priority_consume = [{0,38110009,10}],exp_consume = 3400000000000,attr = [{1,510},{3,510}]};

get_awakening_cell_cfg(59) ->
	#awakening_cell_cfg{id = 59,task_id = 301700,name = "浩劫命盘IV",pre_id = 58,next_id = 60,priority_consume = [{0,38110009,10}],exp_consume = 3400000000000,attr = [{2,10200},{4,510}]};

get_awakening_cell_cfg(60) ->
	#awakening_cell_cfg{id = 60,task_id = 301700,name = "浩劫命盘V",pre_id = 59,next_id = 61,priority_consume = [{0,38110009,10}],exp_consume = 3400000000000,attr = [{1,510},{4,510}]};

get_awakening_cell_cfg(61) ->
	#awakening_cell_cfg{id = 61,task_id = 301700,name = "明耀命盘I",pre_id = 60,next_id = 62,priority_consume = [{0,38110009,10}],exp_consume = 3600000000000,attr = [{1,540},{2,10800}]};

get_awakening_cell_cfg(62) ->
	#awakening_cell_cfg{id = 62,task_id = 301700,name = "明耀命盘II",pre_id = 61,next_id = 63,priority_consume = [{0,38110009,10}],exp_consume = 3600000000000,attr = [{3,540},{4,540}]};

get_awakening_cell_cfg(63) ->
	#awakening_cell_cfg{id = 63,task_id = 301700,name = "明耀命盘III",pre_id = 62,next_id = 64,priority_consume = [{0,38110009,10}],exp_consume = 3600000000000,attr = [{1,540},{3,540}]};

get_awakening_cell_cfg(64) ->
	#awakening_cell_cfg{id = 64,task_id = 301700,name = "明耀命盘IV",pre_id = 63,next_id = 65,priority_consume = [{0,38110009,10}],exp_consume = 3600000000000,attr = [{2,10800},{4,540}]};

get_awakening_cell_cfg(65) ->
	#awakening_cell_cfg{id = 65,task_id = 301700,name = "明耀命盘V",pre_id = 64,next_id = 0,priority_consume = [{0,38110009,10}],exp_consume = 3600000000000,attr = [{1,540},{4,540}]};

get_awakening_cell_cfg(_Id) ->
	[].


get_awakening_cell_id_list(301400) ->
[1,2,3,4,5,6,7,8,9,10];


get_awakening_cell_id_list(301500) ->
[11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];


get_awakening_cell_id_list(301600) ->
[26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45];


get_awakening_cell_id_list(301700) ->
[46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65];

get_awakening_cell_id_list(_Taskid) ->
	[].

