%%%---------------------------------------
%%% module      : data_eudemons_act
%%% description : 幻兽入侵配置
%%%
%%%---------------------------------------
-module(data_eudemons_act).
-compile(export_all).
-include("eudemons_act.hrl").




get_kv(1) ->
4401;


get_kv(2) ->
4401001;


get_kv(3) ->
{1651, 904};


get_kv(4) ->
[{8500,1},{7000,1},{5500,1},{4000,1},{2500,1},{1000,1}];


get_kv(5) ->
[{1268, 1176},{1268, 1176},{1268, 1176},{1268, 1176}];


get_kv(6) ->
14;


get_kv(7) ->
[{0,1001010842,1},{0,1001020842,1},{0,1004010842,1},{0,1004020842,1}];

get_kv(_Keyid) ->
	undefined.

get_killer_reward(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,14010003,1}];
get_killer_reward(1,_Wlv) when 251 =< _Wlv, _Wlv =< 400 ->
		[{0,14010004,1}];
get_killer_reward(1,_Wlv) when 401 =< _Wlv, _Wlv =< 550 ->
		[{0,14010005,1}];
get_killer_reward(1,_Wlv) when 551 =< _Wlv, _Wlv =< 9999 ->
		[{0,14010006,1}];
get_killer_reward(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,14010003,1}];
get_killer_reward(2,_Wlv) when 251 =< _Wlv, _Wlv =< 400 ->
		[{0,14010004,1}];
get_killer_reward(2,_Wlv) when 401 =< _Wlv, _Wlv =< 550 ->
		[{0,14010005,1}];
get_killer_reward(2,_Wlv) when 551 =< _Wlv, _Wlv =< 9999 ->
		[{0,14010006,1}];
get_killer_reward(_Act_id,_Wlv) ->
	[].

get_hurt_steps(1,1) ->
[50,100,150,200,250];

get_hurt_steps(1,251) ->
[50,100,150,200,250];

get_hurt_steps(1,501) ->
[50,100,150,200,250];

get_hurt_steps(2,1) ->
[50,100,150,200,250];

get_hurt_steps(2,251) ->
[50,100,150,200,250];

get_hurt_steps(2,501) ->
[50,100,150,200,250];

get_hurt_steps(_Actid,_Wlvmin) ->
	[].

get_hurt_steps_min_wlv(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(1,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(1,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(1,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(1,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(1,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(1,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(1,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(1,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(1,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(1,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(1,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(2,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		1;
get_hurt_steps_min_wlv(2,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(2,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(2,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(2,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(2,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		251;
get_hurt_steps_min_wlv(2,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(2,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(2,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(2,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(2,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		501;
get_hurt_steps_min_wlv(_Act_id,_Wlv) ->
	1.

get_hurt_step_reward(1,50,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,18020002,1}];
get_hurt_step_reward(1,100,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,16020002,1}];
get_hurt_step_reward(1,150,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,24010002,1}];
get_hurt_step_reward(1,200,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,20010002,1}];
get_hurt_step_reward(1,250,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,22010002,1}];
get_hurt_step_reward(1,50,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,18020002,2}];
get_hurt_step_reward(1,100,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,16020002,2}];
get_hurt_step_reward(1,150,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,24010002,2}];
get_hurt_step_reward(1,200,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,20010002,2}];
get_hurt_step_reward(1,250,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,22010002,2}];
get_hurt_step_reward(1,50,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,18020002,3}];
get_hurt_step_reward(1,100,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,16020002,3}];
get_hurt_step_reward(1,150,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,24010002,3}];
get_hurt_step_reward(1,200,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,20010002,3}];
get_hurt_step_reward(1,250,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,22010002,3}];
get_hurt_step_reward(2,50,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,18020002,1}];
get_hurt_step_reward(2,100,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,16020002,1}];
get_hurt_step_reward(2,150,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,24010002,1}];
get_hurt_step_reward(2,200,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,20010002,1}];
get_hurt_step_reward(2,250,_Wlv) when 1 =< _Wlv, _Wlv =< 250 ->
		[{0,22010002,1}];
get_hurt_step_reward(2,50,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,18020002,2}];
get_hurt_step_reward(2,100,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,16020002,2}];
get_hurt_step_reward(2,150,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,24010002,2}];
get_hurt_step_reward(2,200,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,20010002,2}];
get_hurt_step_reward(2,250,_Wlv) when 251 =< _Wlv, _Wlv =< 500 ->
		[{0,22010002,2}];
get_hurt_step_reward(2,50,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,18020002,3}];
get_hurt_step_reward(2,100,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,16020002,3}];
get_hurt_step_reward(2,150,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,24010002,3}];
get_hurt_step_reward(2,200,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,20010002,3}];
get_hurt_step_reward(2,250,_Wlv) when 501 =< _Wlv, _Wlv =< 9999 ->
		[{0,22010002,3}];
get_hurt_step_reward(_Act_id,_Hurt_value,_Wlv) ->
	[].

get_collect(1,_Num) when 1 =< _Num, _Num =< 5 ->
	#eudemons_act_collect{id=1,num_min=1,num_max=5,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=8,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(1,_Num) when 6 =< _Num, _Num =< 10 ->
	#eudemons_act_collect{id=1,num_min=6,num_max=10,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=15,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(1,_Num) when 11 =< _Num, _Num =< 15 ->
	#eudemons_act_collect{id=1,num_min=11,num_max=15,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=22,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(1,_Num) when 16 =< _Num, _Num =< 20 ->
	#eudemons_act_collect{id=1,num_min=16,num_max=20,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=30,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(2,_Num) when 1 =< _Num, _Num =< 5 ->
	#eudemons_act_collect{id=2,num_min=1,num_max=5,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=8,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(2,_Num) when 6 =< _Num, _Num =< 10 ->
	#eudemons_act_collect{id=2,num_min=6,num_max=10,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=15,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(2,_Num) when 11 =< _Num, _Num =< 15 ->
	#eudemons_act_collect{id=2,num_min=11,num_max=15,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=22,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(2,_Num) when 16 =< _Num, _Num =< 20 ->
	#eudemons_act_collect{id=2,num_min=16,num_max=20,base_collected_mon=[],rand_collected_mon=[{100,4401002}],rand_num=30,pos_list=[{783,1062},{983,1120},{993,1070},{1203,1345},{1451,1325},{1736,1412},{1898,1460},{1691,1217},{2166,1245},{2451,1335},{2686,987},{2391,922},{2496,680},{2176,550},{1936,447},{1473,572},{1731,415},{528,847},{808,805},{788,682},{1023,632},{1316,500},{1128,925},{1392,1100},{1607,1168},{1971,1114},{2156,889},{2001,713},{1698,655},{1460,652},{1280,763},{1472,989}]};
get_collect(_Id,_Num) ->
	[].

