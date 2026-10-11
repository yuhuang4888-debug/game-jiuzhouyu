%%%---------------------------------------
%%% module      : data_goods_effect
%%% description : 物品效果配置
%%%
%%%---------------------------------------
-module(data_goods_effect).
-compile(export_all).
-include("goods.hrl").



get(34) ->
	#goods_effect{goods_id = 34,goods_type = 0,buff_type = 0,effect_list = [{gold,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(35) ->
	#goods_effect{goods_id = 35,goods_type = 0,buff_type = 0,effect_list = [{bgold,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(4203001) ->
	#goods_effect{goods_id = 4203001,goods_type = 1,buff_type = 3,effect_list = [{attr,[{19,200},{20,200}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(4203002) ->
	#goods_effect{goods_id = 4203002,goods_type = 1,buff_type = 4,effect_list = [{attr,[{19,1000},{20,1000},{22,1000}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = [4061]};

get(36010001) ->
	#goods_effect{goods_id = 36010001,goods_type = 0,buff_type = 0,effect_list = [{gold,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36020001) ->
	#goods_effect{goods_id = 36020001,goods_type = 0,buff_type = 0,effect_list = [{bgold,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210001) ->
	#goods_effect{goods_id = 36210001,goods_type = 0,buff_type = 0,effect_list = [{charge_card,2}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210002) ->
	#goods_effect{goods_id = 36210002,goods_type = 0,buff_type = 0,effect_list = [{charge_card,3}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210003) ->
	#goods_effect{goods_id = 36210003,goods_type = 0,buff_type = 0,effect_list = [{charge_card,4}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210004) ->
	#goods_effect{goods_id = 36210004,goods_type = 0,buff_type = 0,effect_list = [{charge_card,5}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210005) ->
	#goods_effect{goods_id = 36210005,goods_type = 0,buff_type = 0,effect_list = [{charge_card,6}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210006) ->
	#goods_effect{goods_id = 36210006,goods_type = 0,buff_type = 0,effect_list = [{charge_card,7}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(36210007) ->
	#goods_effect{goods_id = 36210007,goods_type = 0,buff_type = 0,effect_list = [{charge_card,8}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37020001) ->
	#goods_effect{goods_id = 37020001,goods_type = 1,buff_type = 1,effect_list = [{exp_mon,0.5}],time = 3600,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37020002) ->
	#goods_effect{goods_id = 37020002,goods_type = 1,buff_type = 1,effect_list = [{exp_mon,1}],time = 3600,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37020003) ->
	#goods_effect{goods_id = 37020003,goods_type = 1,buff_type = 1,effect_list = [{exp_mon,2}],time = 3600,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37020004) ->
	#goods_effect{goods_id = 37020004,goods_type = 1,buff_type = 1,effect_list = [{exp_mon,3}],time = 3600,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37020005) ->
	#goods_effect{goods_id = 37020005,goods_type = 1,buff_type = 1,effect_list = [{exp_mon,1.5}],time = 3600,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37050001) ->
	#goods_effect{goods_id = 37050001,goods_type = 0,buff_type = 0,effect_list = [{currency,[{36255097,1}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37050002) ->
	#goods_effect{goods_id = 37050002,goods_type = 0,buff_type = 0,effect_list = [{currency,[{36255096,1}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37050003) ->
	#goods_effect{goods_id = 37050003,goods_type = 0,buff_type = 0,effect_list = [{currency,[{36255041,1}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37060001) ->
	#goods_effect{goods_id = 37060001,goods_type = 1,buff_type = 0,effect_list = [{effect_time, {91,1}}, {cattr, [{202,1000}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37060002) ->
	#goods_effect{goods_id = 37060002,goods_type = 1,buff_type = 0,effect_list = [{effect_time, {91,1}}, {mod_times, {470,0}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37060003) ->
	#goods_effect{goods_id = 37060003,goods_type = 1,buff_type = 0,effect_list = [{effect_time, {91,1}}, {cattr,[{203,1000}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37070001) ->
	#goods_effect{goods_id = 37070001,goods_type = 0,buff_type = 0,effect_list = [{prestige, [{36255100,1}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37070002) ->
	#goods_effect{goods_id = 37070002,goods_type = 0,buff_type = 0,effect_list = [{prestige,[{36255100,1}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37080001) ->
	#goods_effect{goods_id = 37080001,goods_type = 0,buff_type = 0,effect_list = [{guild_donate,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090001) ->
	#goods_effect{goods_id = 37090001,goods_type = 0,buff_type = 0,effect_list = [{level_up, {260, 1200000000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090002) ->
	#goods_effect{goods_id = 37090002,goods_type = 0,buff_type = 0,effect_list = [{level_up, {240, 960000000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090003) ->
	#goods_effect{goods_id = 37090003,goods_type = 0,buff_type = 0,effect_list = [{level_up, {180, 260000000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090004) ->
	#goods_effect{goods_id = 37090004,goods_type = 0,buff_type = 0,effect_list = [{level_up, {150, 130000000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090005) ->
	#goods_effect{goods_id = 37090005,goods_type = 0,buff_type = 0,effect_list = [{level_up, {190, 2036300}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090006) ->
	#goods_effect{goods_id = 37090006,goods_type = 0,buff_type = 0,effect_list = [{level_up, {231, 5892400}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090007) ->
	#goods_effect{goods_id = 37090007,goods_type = 0,buff_type = 0,effect_list = [{level_up, {255, 7676000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090008) ->
	#goods_effect{goods_id = 37090008,goods_type = 0,buff_type = 0,effect_list = [{level_up, {271, 24558600}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090009) ->
	#goods_effect{goods_id = 37090009,goods_type = 0,buff_type = 0,effect_list = [{level_up, {278, 26381000}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37090010) ->
	#goods_effect{goods_id = 37090010,goods_type = 0,buff_type = 0,effect_list = [{level_up, {286, 28567700}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37110001) ->
	#goods_effect{goods_id = 37110001,goods_type = 1,buff_type = 7,effect_list = [{zen_soul,1}],time = 7200,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37120001) ->
	#goods_effect{goods_id = 37120001,goods_type = 0,buff_type = 0,effect_list = [{fiesta_exp,1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37121001) ->
	#goods_effect{goods_id = 37121001,goods_type = 1,buff_type = 8,effect_list = [{attr,[{203,1000}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37121002) ->
	#goods_effect{goods_id = 37121002,goods_type = 1,buff_type = 8,effect_list = [{attr,[{202,1500}]}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37121003) ->
	#goods_effect{goods_id = 37121003,goods_type = 1,buff_type = 8,effect_list = [{mod_times,{470,0},1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(37140001) ->
	#goods_effect{goods_id = 37140001,goods_type = 0,buff_type = 0,effect_list = [{love_num, 1}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(38070001) ->
	#goods_effect{goods_id = 38070001,goods_type = 0,buff_type = 0,effect_list = [{onhook_time,5}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(38070002) ->
	#goods_effect{goods_id = 38070002,goods_type = 0,buff_type = 0,effect_list = [{onhook_time,2}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(38280001) ->
	#goods_effect{goods_id = 38280001,goods_type = 0,buff_type = 0,effect_list = [{dun_id, 20001}],time = 0,limit_type = 0,counter_module = 610,counter_id = 1,limit_scene = []};

get(38320001) ->
	#goods_effect{goods_id = 38320001,goods_type = 0,buff_type = 0,effect_list = [{protect_time, {22,600}}],time = 0,limit_type = 0,counter_module = 0,counter_id = 0,limit_scene = []};

get(_Goodsid) ->
	[].

get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 1, _Lv =< 170 ->
		163366;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 171, _Lv =< 220 ->
		693172;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 221, _Lv =< 270 ->
		1039930;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 271, _Lv =< 320 ->
		1560251;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 321, _Lv =< 370 ->
		2339032;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 371, _Lv =< 420 ->
		3507208;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 421, _Lv =< 470 ->
		5257841;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 471, _Lv =< 520 ->
		7887778;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 521, _Lv =< 570 ->
		11829934;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 571, _Lv =< 620 ->
		17753028;
get_goods_dynamic_exp(37010001,_Lv) when _Lv >= 621, _Lv =< 670 ->
		26635076;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 1, _Lv =< 1 ->
		1;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 2, _Lv =< 2 ->
		2;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 3, _Lv =< 3 ->
		5;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 4, _Lv =< 4 ->
		9;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 5, _Lv =< 5 ->
		15;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 6, _Lv =< 6 ->
		23;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 7, _Lv =< 7 ->
		33;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 8, _Lv =< 8 ->
		46;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 9, _Lv =< 9 ->
		62;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 10, _Lv =< 10 ->
		80;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 11, _Lv =< 11 ->
		101;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 12, _Lv =< 12 ->
		125;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 13, _Lv =< 13 ->
		153;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 14, _Lv =< 14 ->
		184;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 15, _Lv =< 15 ->
		219;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 16, _Lv =< 16 ->
		257;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 17, _Lv =< 17 ->
		299;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 18, _Lv =< 18 ->
		344;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 19, _Lv =< 19 ->
		394;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 20, _Lv =< 20 ->
		448;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 21, _Lv =< 21 ->
		506;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 22, _Lv =< 22 ->
		568;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 23, _Lv =< 23 ->
		635;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 24, _Lv =< 24 ->
		706;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 25, _Lv =< 25 ->
		782;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 26, _Lv =< 26 ->
		863;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 27, _Lv =< 27 ->
		948;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 28, _Lv =< 28 ->
		1038;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 29, _Lv =< 29 ->
		1133;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 30, _Lv =< 30 ->
		1233;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 31, _Lv =< 31 ->
		1338;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 32, _Lv =< 32 ->
		1449;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 33, _Lv =< 33 ->
		1565;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 34, _Lv =< 34 ->
		1686;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 35, _Lv =< 35 ->
		1813;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 36, _Lv =< 36 ->
		1945;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 37, _Lv =< 37 ->
		2083;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 38, _Lv =< 38 ->
		2226;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 39, _Lv =< 39 ->
		2375;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 40, _Lv =< 40 ->
		2531;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 41, _Lv =< 41 ->
		2692;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 42, _Lv =< 42 ->
		2859;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 43, _Lv =< 43 ->
		3032;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 44, _Lv =< 44 ->
		3211;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 45, _Lv =< 45 ->
		3397;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 46, _Lv =< 46 ->
		3589;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 47, _Lv =< 47 ->
		3787;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 48, _Lv =< 48 ->
		3991;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 49, _Lv =< 49 ->
		4203;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 50, _Lv =< 50 ->
		4420;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 51, _Lv =< 51 ->
		4644;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 52, _Lv =< 52 ->
		4875;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 53, _Lv =< 53 ->
		5113;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 54, _Lv =< 54 ->
		5358;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 55, _Lv =< 55 ->
		5609;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 56, _Lv =< 56 ->
		5868;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 57, _Lv =< 57 ->
		6133;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 58, _Lv =< 58 ->
		6406;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 59, _Lv =< 59 ->
		6685;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 60, _Lv =< 60 ->
		6972;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 61, _Lv =< 61 ->
		7266;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 62, _Lv =< 62 ->
		7568;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 63, _Lv =< 63 ->
		7877;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 64, _Lv =< 64 ->
		8193;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 65, _Lv =< 65 ->
		8517;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 66, _Lv =< 66 ->
		8848;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 67, _Lv =< 67 ->
		9187;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 68, _Lv =< 68 ->
		9533;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 69, _Lv =< 69 ->
		9888;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 70, _Lv =< 70 ->
		10250;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 71, _Lv =< 71 ->
		10620;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 72, _Lv =< 72 ->
		10998;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 73, _Lv =< 73 ->
		11384;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 74, _Lv =< 74 ->
		11777;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 75, _Lv =< 75 ->
		12179;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 76, _Lv =< 76 ->
		12589;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 77, _Lv =< 77 ->
		13007;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 78, _Lv =< 78 ->
		13434;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 79, _Lv =< 79 ->
		13869;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 80, _Lv =< 80 ->
		14312;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 81, _Lv =< 81 ->
		14763;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 82, _Lv =< 82 ->
		15223;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 83, _Lv =< 83 ->
		15691;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 84, _Lv =< 84 ->
		16168;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 85, _Lv =< 85 ->
		16654;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 86, _Lv =< 86 ->
		17148;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 87, _Lv =< 87 ->
		17651;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 88, _Lv =< 88 ->
		18162;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 89, _Lv =< 89 ->
		18682;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 90, _Lv =< 90 ->
		19212;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 91, _Lv =< 91 ->
		19750;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 92, _Lv =< 92 ->
		20297;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 93, _Lv =< 93 ->
		20853;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 94, _Lv =< 94 ->
		21418;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 95, _Lv =< 95 ->
		21992;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 96, _Lv =< 96 ->
		22575;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 97, _Lv =< 97 ->
		23168;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 98, _Lv =< 98 ->
		23769;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 99, _Lv =< 99 ->
		24380;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 100, _Lv =< 100 ->
		25001;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 101, _Lv =< 101 ->
		25630;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 102, _Lv =< 102 ->
		26270;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 103, _Lv =< 103 ->
		26918;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 104, _Lv =< 104 ->
		27576;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 105, _Lv =< 105 ->
		28244;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 106, _Lv =< 106 ->
		28921;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 107, _Lv =< 107 ->
		29608;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 108, _Lv =< 108 ->
		30305;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 109, _Lv =< 109 ->
		31011;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 110, _Lv =< 110 ->
		31727;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 111, _Lv =< 111 ->
		32453;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 112, _Lv =< 112 ->
		33189;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 113, _Lv =< 113 ->
		33935;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 114, _Lv =< 114 ->
		34691;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 115, _Lv =< 115 ->
		35456;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 116, _Lv =< 116 ->
		36232;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 117, _Lv =< 117 ->
		37018;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 118, _Lv =< 118 ->
		37814;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 119, _Lv =< 119 ->
		38620;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 120, _Lv =< 120 ->
		39437;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 121, _Lv =< 121 ->
		40264;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 122, _Lv =< 122 ->
		41101;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 123, _Lv =< 123 ->
		41948;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 124, _Lv =< 124 ->
		42806;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 125, _Lv =< 125 ->
		43674;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 126, _Lv =< 126 ->
		44553;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 127, _Lv =< 127 ->
		45442;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 128, _Lv =< 128 ->
		46342;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 129, _Lv =< 129 ->
		47252;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 130, _Lv =< 130 ->
		48173;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 131, _Lv =< 131 ->
		49105;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 132, _Lv =< 132 ->
		50047;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 133, _Lv =< 133 ->
		51001;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 134, _Lv =< 134 ->
		51965;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 135, _Lv =< 135 ->
		52940;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 136, _Lv =< 136 ->
		53925;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 137, _Lv =< 137 ->
		54922;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 138, _Lv =< 138 ->
		55930;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 139, _Lv =< 139 ->
		56949;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 140, _Lv =< 140 ->
		57978;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 141, _Lv =< 141 ->
		59019;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 142, _Lv =< 142 ->
		60071;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 143, _Lv =< 143 ->
		61134;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 144, _Lv =< 144 ->
		62209;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 145, _Lv =< 145 ->
		63294;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 146, _Lv =< 146 ->
		64391;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 147, _Lv =< 147 ->
		65500;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 148, _Lv =< 148 ->
		66619;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 149, _Lv =< 149 ->
		67750;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 150, _Lv =< 150 ->
		68893;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 151, _Lv =< 151 ->
		70047;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 152, _Lv =< 152 ->
		71212;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 153, _Lv =< 153 ->
		72389;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 154, _Lv =< 154 ->
		73578;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 155, _Lv =< 155 ->
		74778;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 156, _Lv =< 156 ->
		75990;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 157, _Lv =< 157 ->
		77214;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 158, _Lv =< 158 ->
		78449;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 159, _Lv =< 159 ->
		79696;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 160, _Lv =< 160 ->
		80955;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 161, _Lv =< 161 ->
		82226;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 162, _Lv =< 162 ->
		83509;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 163, _Lv =< 163 ->
		84803;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 164, _Lv =< 164 ->
		86110;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 165, _Lv =< 165 ->
		87429;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 166, _Lv =< 166 ->
		88759;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 167, _Lv =< 167 ->
		90102;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 168, _Lv =< 168 ->
		91457;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 169, _Lv =< 169 ->
		92824;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 170, _Lv =< 170 ->
		94203;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 171, _Lv =< 171 ->
		97734;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 172, _Lv =< 172 ->
		99228;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 173, _Lv =< 173 ->
		100736;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 174, _Lv =< 174 ->
		102257;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 175, _Lv =< 175 ->
		103793;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 176, _Lv =< 176 ->
		105344;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 177, _Lv =< 177 ->
		106908;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 178, _Lv =< 178 ->
		108486;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 179, _Lv =< 179 ->
		110079;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 180, _Lv =< 180 ->
		111686;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 181, _Lv =< 181 ->
		113308;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 182, _Lv =< 182 ->
		114944;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 183, _Lv =< 183 ->
		116594;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 184, _Lv =< 184 ->
		118259;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 185, _Lv =< 185 ->
		119938;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 186, _Lv =< 186 ->
		121632;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 187, _Lv =< 187 ->
		123341;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 188, _Lv =< 188 ->
		125065;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 189, _Lv =< 189 ->
		126803;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 190, _Lv =< 190 ->
		128556;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 191, _Lv =< 191 ->
		130323;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 192, _Lv =< 192 ->
		132106;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 193, _Lv =< 193 ->
		133904;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 194, _Lv =< 194 ->
		135716;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 195, _Lv =< 195 ->
		137544;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 196, _Lv =< 196 ->
		139386;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 197, _Lv =< 197 ->
		141244;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 198, _Lv =< 198 ->
		143117;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 199, _Lv =< 199 ->
		145005;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 200, _Lv =< 200 ->
		146909;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 201, _Lv =< 201 ->
		148827;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 202, _Lv =< 202 ->
		150761;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 203, _Lv =< 203 ->
		152711;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 204, _Lv =< 204 ->
		154676;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 205, _Lv =< 205 ->
		156656;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 206, _Lv =< 206 ->
		158652;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 207, _Lv =< 207 ->
		160664;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 208, _Lv =< 208 ->
		162691;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 209, _Lv =< 209 ->
		164733;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 210, _Lv =< 210 ->
		166792;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 211, _Lv =< 211 ->
		168866;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 212, _Lv =< 212 ->
		170956;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 213, _Lv =< 213 ->
		173062;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 214, _Lv =< 214 ->
		175184;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 215, _Lv =< 215 ->
		177322;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 216, _Lv =< 216 ->
		179476;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 217, _Lv =< 217 ->
		181645;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 218, _Lv =< 218 ->
		183831;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 219, _Lv =< 219 ->
		186033;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 220, _Lv =< 220 ->
		188251;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 221, _Lv =< 221 ->
		194737;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 222, _Lv =< 222 ->
		197103;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 223, _Lv =< 223 ->
		199487;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 224, _Lv =< 224 ->
		201889;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 225, _Lv =< 225 ->
		204309;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 226, _Lv =< 226 ->
		206748;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 227, _Lv =< 227 ->
		209204;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 228, _Lv =< 228 ->
		211678;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 229, _Lv =< 229 ->
		214171;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 230, _Lv =< 230 ->
		216682;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 231, _Lv =< 231 ->
		219212;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 232, _Lv =< 232 ->
		221760;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 233, _Lv =< 233 ->
		224326;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 234, _Lv =< 234 ->
		226911;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 235, _Lv =< 235 ->
		229514;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 236, _Lv =< 236 ->
		232137;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 237, _Lv =< 237 ->
		234777;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 238, _Lv =< 238 ->
		237437;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 239, _Lv =< 239 ->
		240115;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 240, _Lv =< 240 ->
		242812;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 241, _Lv =< 241 ->
		245528;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 242, _Lv =< 242 ->
		248263;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 243, _Lv =< 243 ->
		251017;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 244, _Lv =< 244 ->
		253790;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 245, _Lv =< 245 ->
		256582;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 246, _Lv =< 246 ->
		259393;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 247, _Lv =< 247 ->
		262224;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 248, _Lv =< 248 ->
		265074;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 249, _Lv =< 249 ->
		267943;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 250, _Lv =< 250 ->
		270831;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 251, _Lv =< 251 ->
		273739;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 252, _Lv =< 252 ->
		276666;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 253, _Lv =< 253 ->
		279613;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 254, _Lv =< 254 ->
		282579;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 255, _Lv =< 255 ->
		285565;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 256, _Lv =< 256 ->
		288571;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 257, _Lv =< 257 ->
		291597;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 258, _Lv =< 258 ->
		294642;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 259, _Lv =< 259 ->
		297707;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 260, _Lv =< 260 ->
		300792;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 261, _Lv =< 261 ->
		303897;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 262, _Lv =< 262 ->
		307022;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 263, _Lv =< 263 ->
		310166;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 264, _Lv =< 264 ->
		313331;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 265, _Lv =< 265 ->
		316517;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 266, _Lv =< 266 ->
		319722;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 267, _Lv =< 267 ->
		322948;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 268, _Lv =< 268 ->
		326194;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 269, _Lv =< 269 ->
		329460;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 270, _Lv =< 270 ->
		332747;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 271, _Lv =< 271 ->
		337343;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 272, _Lv =< 272 ->
		340849;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 273, _Lv =< 273 ->
		344378;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 274, _Lv =< 274 ->
		347930;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 275, _Lv =< 275 ->
		351506;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 276, _Lv =< 276 ->
		355106;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 277, _Lv =< 277 ->
		358729;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 278, _Lv =< 278 ->
		362376;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 279, _Lv =< 279 ->
		366047;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 280, _Lv =< 280 ->
		369741;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 281, _Lv =< 281 ->
		373460;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 282, _Lv =< 282 ->
		377202;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 283, _Lv =< 283 ->
		380969;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 284, _Lv =< 284 ->
		384760;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 285, _Lv =< 285 ->
		388574;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 286, _Lv =< 286 ->
		392414;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 287, _Lv =< 287 ->
		396277;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 288, _Lv =< 288 ->
		400165;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 289, _Lv =< 289 ->
		404077;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 290, _Lv =< 290 ->
		408014;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 291, _Lv =< 291 ->
		411976;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 292, _Lv =< 292 ->
		415962;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 293, _Lv =< 293 ->
		419973;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 294, _Lv =< 294 ->
		424008;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 295, _Lv =< 295 ->
		428069;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 296, _Lv =< 296 ->
		432154;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 297, _Lv =< 297 ->
		436265;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 298, _Lv =< 298 ->
		440400;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 299, _Lv =< 299 ->
		444561;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 300, _Lv =< 300 ->
		448747;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 301, _Lv =< 301 ->
		452959;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 302, _Lv =< 302 ->
		457195;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 303, _Lv =< 303 ->
		461457;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 304, _Lv =< 304 ->
		465745;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 305, _Lv =< 305 ->
		470058;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 306, _Lv =< 306 ->
		474397;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 307, _Lv =< 307 ->
		478761;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 308, _Lv =< 308 ->
		483151;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 309, _Lv =< 309 ->
		487567;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 310, _Lv =< 310 ->
		492009;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 311, _Lv =< 311 ->
		496477;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 312, _Lv =< 312 ->
		500971;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 313, _Lv =< 313 ->
		505491;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 314, _Lv =< 314 ->
		510037;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 315, _Lv =< 315 ->
		514610;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 316, _Lv =< 316 ->
		519209;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 317, _Lv =< 317 ->
		523834;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 318, _Lv =< 318 ->
		528485;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 319, _Lv =< 319 ->
		533163;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 320, _Lv =< 320 ->
		537868;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 321, _Lv =< 321 ->
		550314;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 322, _Lv =< 322 ->
		555265;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 323, _Lv =< 323 ->
		560246;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 324, _Lv =< 324 ->
		565255;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 325, _Lv =< 325 ->
		570293;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 326, _Lv =< 326 ->
		575361;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 327, _Lv =< 327 ->
		580458;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 328, _Lv =< 328 ->
		585584;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 329, _Lv =< 329 ->
		590740;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 330, _Lv =< 330 ->
		595925;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 331, _Lv =< 331 ->
		601140;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 332, _Lv =< 332 ->
		606384;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 333, _Lv =< 333 ->
		611659;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 334, _Lv =< 334 ->
		616963;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 335, _Lv =< 335 ->
		622297;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 336, _Lv =< 336 ->
		627661;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 337, _Lv =< 337 ->
		633056;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 338, _Lv =< 338 ->
		638480;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 339, _Lv =< 339 ->
		643935;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 340, _Lv =< 340 ->
		649420;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 341, _Lv =< 341 ->
		654935;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 342, _Lv =< 342 ->
		660481;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 343, _Lv =< 343 ->
		666058;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 344, _Lv =< 344 ->
		671665;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 345, _Lv =< 345 ->
		677302;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 346, _Lv =< 346 ->
		682971;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 347, _Lv =< 347 ->
		688671;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 348, _Lv =< 348 ->
		694401;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 349, _Lv =< 349 ->
		700163;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 350, _Lv =< 350 ->
		705955;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 351, _Lv =< 351 ->
		711779;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 352, _Lv =< 352 ->
		717634;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 353, _Lv =< 353 ->
		723521;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 354, _Lv =< 354 ->
		729438;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 355, _Lv =< 355 ->
		735388;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 356, _Lv =< 356 ->
		741369;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 357, _Lv =< 357 ->
		747381;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 358, _Lv =< 358 ->
		753426;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 359, _Lv =< 359 ->
		759502;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 360, _Lv =< 360 ->
		765610;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 361, _Lv =< 361 ->
		771750;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 362, _Lv =< 362 ->
		777922;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 363, _Lv =< 363 ->
		784126;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 364, _Lv =< 364 ->
		790363;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 365, _Lv =< 365 ->
		796631;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 366, _Lv =< 366 ->
		802932;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 367, _Lv =< 367 ->
		809266;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 368, _Lv =< 368 ->
		815632;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 369, _Lv =< 369 ->
		822030;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 370, _Lv =< 370 ->
		828462;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 371, _Lv =< 371 ->
		980924;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 372, _Lv =< 372 ->
		988942;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 373, _Lv =< 373 ->
		997003;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 374, _Lv =< 374 ->
		1005107;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 375, _Lv =< 375 ->
		1013256;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 376, _Lv =< 376 ->
		1021449;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 377, _Lv =< 377 ->
		1029686;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 378, _Lv =< 378 ->
		1037968;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 379, _Lv =< 379 ->
		1046294;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 380, _Lv =< 380 ->
		1054665;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 381, _Lv =< 381 ->
		1063080;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 382, _Lv =< 382 ->
		1071540;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 383, _Lv =< 383 ->
		1080045;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 384, _Lv =< 384 ->
		1088595;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 385, _Lv =< 385 ->
		1097190;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 386, _Lv =< 386 ->
		1105831;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 387, _Lv =< 387 ->
		1114517;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 388, _Lv =< 388 ->
		1123249;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 389, _Lv =< 389 ->
		1132026;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 390, _Lv =< 390 ->
		1140849;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 391, _Lv =< 391 ->
		1149718;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 392, _Lv =< 392 ->
		1158633;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 393, _Lv =< 393 ->
		1167594;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 394, _Lv =< 394 ->
		1176601;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 395, _Lv =< 395 ->
		1185655;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 396, _Lv =< 396 ->
		1194755;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 397, _Lv =< 397 ->
		1203902;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 398, _Lv =< 398 ->
		1213096;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 399, _Lv =< 399 ->
		1222337;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 400, _Lv =< 400 ->
		1231624;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 401, _Lv =< 401 ->
		1240959;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 402, _Lv =< 402 ->
		1250341;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 403, _Lv =< 403 ->
		1259770;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 404, _Lv =< 404 ->
		1269247;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 405, _Lv =< 405 ->
		1278771;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 406, _Lv =< 406 ->
		1288343;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 407, _Lv =< 407 ->
		1297963;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 408, _Lv =< 408 ->
		1307631;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 409, _Lv =< 409 ->
		1317347;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 410, _Lv =< 410 ->
		1327111;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 411, _Lv =< 411 ->
		1336923;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 412, _Lv =< 412 ->
		1346784;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 413, _Lv =< 413 ->
		1356693;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 414, _Lv =< 414 ->
		1366652;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 415, _Lv =< 415 ->
		1376658;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 416, _Lv =< 416 ->
		1386714;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 417, _Lv =< 417 ->
		1396819;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 418, _Lv =< 418 ->
		1406973;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 419, _Lv =< 419 ->
		1417177;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 420, _Lv =< 420 ->
		1427429;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 421, _Lv =< 421 ->
		1504388;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 422, _Lv =< 422 ->
		1515247;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 423, _Lv =< 423 ->
		1526158;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 424, _Lv =< 424 ->
		1537122;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 425, _Lv =< 425 ->
		1548138;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 426, _Lv =< 426 ->
		1559208;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 427, _Lv =< 427 ->
		1570330;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 428, _Lv =< 428 ->
		1581505;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 429, _Lv =< 429 ->
		1592733;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 430, _Lv =< 430 ->
		1604015;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 431, _Lv =< 431 ->
		1615350;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 432, _Lv =< 432 ->
		1626738;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 433, _Lv =< 433 ->
		1638181;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 434, _Lv =< 434 ->
		1649677;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 435, _Lv =< 435 ->
		1661227;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 436, _Lv =< 436 ->
		1672831;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 437, _Lv =< 437 ->
		1684489;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 438, _Lv =< 438 ->
		1696202;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 439, _Lv =< 439 ->
		1707969;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 440, _Lv =< 440 ->
		1719791;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 441, _Lv =< 441 ->
		1731667;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 442, _Lv =< 442 ->
		1743598;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 443, _Lv =< 443 ->
		1755584;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 444, _Lv =< 444 ->
		1767625;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 445, _Lv =< 445 ->
		1779722;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 446, _Lv =< 446 ->
		1791874;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 447, _Lv =< 447 ->
		1804081;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 448, _Lv =< 448 ->
		1816344;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 449, _Lv =< 449 ->
		1828662;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 450, _Lv =< 450 ->
		1841037;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 451, _Lv =< 451 ->
		1853467;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 452, _Lv =< 452 ->
		1865954;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 453, _Lv =< 453 ->
		1878497;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 454, _Lv =< 454 ->
		1891096;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 455, _Lv =< 455 ->
		1903752;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 456, _Lv =< 456 ->
		1916464;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 457, _Lv =< 457 ->
		1929233;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 458, _Lv =< 458 ->
		1942059;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 459, _Lv =< 459 ->
		1954942;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 460, _Lv =< 460 ->
		1967882;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 461, _Lv =< 461 ->
		1980880;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 462, _Lv =< 462 ->
		1993935;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 463, _Lv =< 463 ->
		2007047;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 464, _Lv =< 464 ->
		2020217;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 465, _Lv =< 465 ->
		2033445;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 466, _Lv =< 466 ->
		2046731;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 467, _Lv =< 467 ->
		2060074;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 468, _Lv =< 468 ->
		2073476;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 469, _Lv =< 469 ->
		2086936;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 470, _Lv =< 470 ->
		2100455;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 471, _Lv =< 471 ->
		2407538;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 472, _Lv =< 472 ->
		2423514;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 473, _Lv =< 473 ->
		2439563;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 474, _Lv =< 474 ->
		2455683;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 475, _Lv =< 475 ->
		2471875;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 476, _Lv =< 476 ->
		2488140;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 477, _Lv =< 477 ->
		2504477;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 478, _Lv =< 478 ->
		2520887;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 479, _Lv =< 479 ->
		2537370;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 480, _Lv =< 480 ->
		2553926;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 481, _Lv =< 481 ->
		2570555;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 482, _Lv =< 482 ->
		2587258;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 483, _Lv =< 483 ->
		2604034;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 484, _Lv =< 484 ->
		2620884;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 485, _Lv =< 485 ->
		2637808;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 486, _Lv =< 486 ->
		2654805;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 487, _Lv =< 487 ->
		2671878;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 488, _Lv =< 488 ->
		2689024;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 489, _Lv =< 489 ->
		2706245;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 490, _Lv =< 490 ->
		2723541;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 491, _Lv =< 491 ->
		2740912;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 492, _Lv =< 492 ->
		2758358;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 493, _Lv =< 493 ->
		2775880;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 494, _Lv =< 494 ->
		2793476;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 495, _Lv =< 495 ->
		2811149;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 496, _Lv =< 496 ->
		2828897;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 497, _Lv =< 497 ->
		2846721;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 498, _Lv =< 498 ->
		2864621;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 499, _Lv =< 499 ->
		2882598;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 500, _Lv =< 500 ->
		2900651;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 501, _Lv =< 501 ->
		2918781;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 502, _Lv =< 502 ->
		2936987;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 503, _Lv =< 503 ->
		2955271;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 504, _Lv =< 504 ->
		2973631;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 505, _Lv =< 505 ->
		2992069;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 506, _Lv =< 506 ->
		3010585;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 507, _Lv =< 507 ->
		3029178;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 508, _Lv =< 508 ->
		3047849;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 509, _Lv =< 509 ->
		3066598;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 510, _Lv =< 510 ->
		3085426;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 511, _Lv =< 511 ->
		3104331;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 512, _Lv =< 512 ->
		3123316;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 513, _Lv =< 513 ->
		3142379;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 514, _Lv =< 514 ->
		3161520;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 515, _Lv =< 515 ->
		3180741;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 516, _Lv =< 516 ->
		3200041;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 517, _Lv =< 517 ->
		3219421;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 518, _Lv =< 518 ->
		3238880;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 519, _Lv =< 519 ->
		3258419;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 520, _Lv =< 520 ->
		3278038;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 521, _Lv =< 521 ->
		4243657;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 522, _Lv =< 522 ->
		4269816;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 523, _Lv =< 523 ->
		4296086;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 524, _Lv =< 524 ->
		4322467;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 525, _Lv =< 525 ->
		4348959;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 526, _Lv =< 526 ->
		4375562;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 527, _Lv =< 527 ->
		4402278;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 528, _Lv =< 528 ->
		4429105;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 529, _Lv =< 529 ->
		4456044;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 530, _Lv =< 530 ->
		4483096;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 531, _Lv =< 531 ->
		4510261;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 532, _Lv =< 532 ->
		4537539;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 533, _Lv =< 533 ->
		4564930;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 534, _Lv =< 534 ->
		4592435;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 535, _Lv =< 535 ->
		4620053;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 536, _Lv =< 536 ->
		4647785;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 537, _Lv =< 537 ->
		4675632;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 538, _Lv =< 538 ->
		4703594;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 539, _Lv =< 539 ->
		4731670;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 540, _Lv =< 540 ->
		4759861;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 541, _Lv =< 541 ->
		4788168;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 542, _Lv =< 542 ->
		4816590;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 543, _Lv =< 543 ->
		4845128;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 544, _Lv =< 544 ->
		4873782;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 545, _Lv =< 545 ->
		4902553;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 546, _Lv =< 546 ->
		4931440;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 547, _Lv =< 547 ->
		4960444;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 548, _Lv =< 548 ->
		4989565;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 549, _Lv =< 549 ->
		5018804;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 550, _Lv =< 550 ->
		5048160;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 551, _Lv =< 551 ->
		5077634;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 552, _Lv =< 552 ->
		5107226;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 553, _Lv =< 553 ->
		5136937;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 554, _Lv =< 554 ->
		5166767;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 555, _Lv =< 555 ->
		5196715;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 556, _Lv =< 556 ->
		5226783;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 557, _Lv =< 557 ->
		5256970;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 558, _Lv =< 558 ->
		5287277;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 559, _Lv =< 559 ->
		5317703;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 560, _Lv =< 560 ->
		5348251;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 561, _Lv =< 561 ->
		5378918;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 562, _Lv =< 562 ->
		5409706;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 563, _Lv =< 563 ->
		5440616;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 564, _Lv =< 564 ->
		5471646;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 565, _Lv =< 565 ->
		5502799;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 566, _Lv =< 566 ->
		5534073;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 567, _Lv =< 567 ->
		5565469;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 568, _Lv =< 568 ->
		5596987;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 569, _Lv =< 569 ->
		5628628;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 570, _Lv =< 570 ->
		5660392;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 571, _Lv =< 571 ->
		6446385;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 572, _Lv =< 572 ->
		6482858;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 573, _Lv =< 573 ->
		6519473;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 574, _Lv =< 574 ->
		6556231;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 575, _Lv =< 575 ->
		6593132;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 576, _Lv =< 576 ->
		6630175;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 577, _Lv =< 577 ->
		6667362;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 578, _Lv =< 578 ->
		6704693;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 579, _Lv =< 579 ->
		6742167;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 580, _Lv =< 580 ->
		6779786;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 581, _Lv =< 581 ->
		6817549;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 582, _Lv =< 582 ->
		6855457;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 583, _Lv =< 583 ->
		6893511;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 584, _Lv =< 584 ->
		6931709;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 585, _Lv =< 585 ->
		6970054;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 586, _Lv =< 586 ->
		7008544;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 587, _Lv =< 587 ->
		7047181;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 588, _Lv =< 588 ->
		7085965;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 589, _Lv =< 589 ->
		7124896;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 590, _Lv =< 590 ->
		7163974;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 591, _Lv =< 591 ->
		7203199;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 592, _Lv =< 592 ->
		7242573;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 593, _Lv =< 593 ->
		7282094;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 594, _Lv =< 594 ->
		7321765;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 595, _Lv =< 595 ->
		7361584;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 596, _Lv =< 596 ->
		7401552;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 597, _Lv =< 597 ->
		7441670;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 598, _Lv =< 598 ->
		7481937;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 599, _Lv =< 599 ->
		7522355;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 600, _Lv =< 600 ->
		7562922;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 601, _Lv =< 601 ->
		7603641;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 602, _Lv =< 602 ->
		7644511;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 603, _Lv =< 603 ->
		7685531;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 604, _Lv =< 604 ->
		7726704;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 605, _Lv =< 605 ->
		7768028;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 606, _Lv =< 606 ->
		7809505;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 607, _Lv =< 607 ->
		7851134;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 608, _Lv =< 608 ->
		7892916;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 609, _Lv =< 609 ->
		7934851;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 610, _Lv =< 610 ->
		7976939;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 611, _Lv =< 611 ->
		8019181;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 612, _Lv =< 612 ->
		8061578;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 613, _Lv =< 613 ->
		8104128;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 614, _Lv =< 614 ->
		8146834;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 615, _Lv =< 615 ->
		8189694;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 616, _Lv =< 616 ->
		8232710;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 617, _Lv =< 617 ->
		8275881;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 618, _Lv =< 618 ->
		8319208;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 619, _Lv =< 619 ->
		8362692;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 620, _Lv =< 620 ->
		8406332;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 621, _Lv =< 621 ->
		10821086;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 622, _Lv =< 622 ->
		10879149;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 623, _Lv =< 623 ->
		10937430;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 624, _Lv =< 624 ->
		10995929;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 625, _Lv =< 625 ->
		11054646;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 626, _Lv =< 626 ->
		11113582;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 627, _Lv =< 627 ->
		11172738;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 628, _Lv =< 628 ->
		11232113;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 629, _Lv =< 629 ->
		11291709;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 630, _Lv =< 630 ->
		11351525;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 631, _Lv =< 631 ->
		11411563;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 632, _Lv =< 632 ->
		11471823;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 633, _Lv =< 633 ->
		11532304;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 634, _Lv =< 634 ->
		11593009;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 635, _Lv =< 635 ->
		11653936;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 636, _Lv =< 636 ->
		11715087;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 637, _Lv =< 637 ->
		11776462;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 638, _Lv =< 638 ->
		11838061;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 639, _Lv =< 639 ->
		11899886;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 640, _Lv =< 640 ->
		11961936;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 641, _Lv =< 641 ->
		12024212;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 642, _Lv =< 642 ->
		12086714;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 643, _Lv =< 643 ->
		12149443;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 644, _Lv =< 644 ->
		12212399;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 645, _Lv =< 645 ->
		12275584;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 646, _Lv =< 646 ->
		12338996;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 647, _Lv =< 647 ->
		12402637;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 648, _Lv =< 648 ->
		12466508;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 649, _Lv =< 649 ->
		12530608;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 650, _Lv =< 650 ->
		12594938;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 651, _Lv =< 651 ->
		12659499;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 652, _Lv =< 652 ->
		12724290;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 653, _Lv =< 653 ->
		12789314;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 654, _Lv =< 654 ->
		12854569;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 655, _Lv =< 655 ->
		12920057;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 656, _Lv =< 656 ->
		12985778;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 657, _Lv =< 657 ->
		13051732;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 658, _Lv =< 658 ->
		13117921;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 659, _Lv =< 659 ->
		13184343;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 660, _Lv =< 660 ->
		13251001;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 661, _Lv =< 661 ->
		13317893;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 662, _Lv =< 662 ->
		13385022;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 663, _Lv =< 663 ->
		13452387;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 664, _Lv =< 664 ->
		13519988;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 665, _Lv =< 665 ->
		13587827;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 666, _Lv =< 666 ->
		13655903;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 667, _Lv =< 667 ->
		13724218;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 668, _Lv =< 668 ->
		13792771;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 669, _Lv =< 669 ->
		13861564;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 670, _Lv =< 670 ->
		13930595;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 671, _Lv =< 671 ->
		13999867;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 672, _Lv =< 672 ->
		14069380;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 673, _Lv =< 673 ->
		14139134;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 674, _Lv =< 674 ->
		14209129;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 675, _Lv =< 675 ->
		14279366;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 676, _Lv =< 676 ->
		14349845;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 677, _Lv =< 677 ->
		14420567;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 678, _Lv =< 678 ->
		14491533;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 679, _Lv =< 679 ->
		14562743;
get_goods_dynamic_exp(37010002,_Lv) when _Lv >= 680, _Lv =< 9999 ->
		14634197;
get_goods_dynamic_exp(37010003,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		500000;
get_goods_dynamic_exp(37010004,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1000000;
get_goods_dynamic_exp(37010005,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2000000;
get_goods_dynamic_exp(37010006,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		5000000;
get_goods_dynamic_exp(37010007,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		300000;
get_goods_dynamic_exp(37010008,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		400000;
get_goods_dynamic_exp(37010009,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		30000000;
get_goods_dynamic_exp(37010010,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		50000000;
get_goods_dynamic_exp(37010011,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		100000000;
get_goods_dynamic_exp(37010012,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1279968;
get_goods_dynamic_exp(37010013,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1632528;
get_goods_dynamic_exp(37010014,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2448768;
get_goods_dynamic_exp(37010015,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		3673200;
get_goods_dynamic_exp(37010016,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		5509824;
get_goods_dynamic_exp(37010017,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		8264736;
get_goods_dynamic_exp(37010018,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		12397104;
get_goods_dynamic_exp(37010019,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		18595680;
get_goods_dynamic_exp(37010020,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		27893520;
get_goods_dynamic_exp(37010021,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		49207488;
get_goods_dynamic_exp(37010022,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		73811232;
get_goods_dynamic_exp(37010023,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		120069312;
get_goods_dynamic_exp(37010024,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		211816512;
get_goods_dynamic_exp(37010025,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		299090000;
get_goods_dynamic_exp(37010026,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		570610000;
get_goods_dynamic_exp(37010027,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		972490000;
get_goods_dynamic_exp(37010028,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1327890000;
get_goods_dynamic_exp(37010029,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010030,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2556340000;
get_goods_dynamic_exp(37010031,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		3231700000;
get_goods_dynamic_exp(37010032,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2421740000;
get_goods_dynamic_exp(37010033,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010034,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010035,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010036,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010037,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010038,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010039,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010040,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010041,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010042,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010043,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4294967295;
get_goods_dynamic_exp(37010044,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		4168790000;
get_goods_dynamic_exp(37010045,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2115130000;
get_goods_dynamic_exp(37010046,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		938950000;
get_goods_dynamic_exp(37010047,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		510310000;
get_goods_dynamic_exp(37010048,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		510310000;
get_goods_dynamic_exp(37010049,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		59414600;
get_goods_dynamic_exp(37010050,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		72199411;
get_goods_dynamic_exp(37010051,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		83308176;
get_goods_dynamic_exp(37010052,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		138847564;
get_goods_dynamic_exp(37010053,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		180501804;
get_goods_dynamic_exp(37010054,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		234652370;
get_goods_dynamic_exp(37010055,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		78000000;
get_goods_dynamic_exp(37010056,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		93600000;
get_goods_dynamic_exp(37010057,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		112320000;
get_goods_dynamic_exp(37010058,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		134784000;
get_goods_dynamic_exp(37010059,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		161740800;
get_goods_dynamic_exp(37010060,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		194088960;
get_goods_dynamic_exp(37010061,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		232906752;
get_goods_dynamic_exp(37010062,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		279488102;
get_goods_dynamic_exp(37010063,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		335385722;
get_goods_dynamic_exp(37010064,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		402462866;
get_goods_dynamic_exp(37010065,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		482955439;
get_goods_dynamic_exp(37010066,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		579546527;
get_goods_dynamic_exp(37010067,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		695455832;
get_goods_dynamic_exp(37010068,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		834546998;
get_goods_dynamic_exp(37010069,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		49000000;
get_goods_dynamic_exp(37010070,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		163000000;
get_goods_dynamic_exp(37010071,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		180000000;
get_goods_dynamic_exp(37010072,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		198000000;
get_goods_dynamic_exp(37010073,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		217000000;
get_goods_dynamic_exp(37010074,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		239000000;
get_goods_dynamic_exp(37010075,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		263000000;
get_goods_dynamic_exp(37010076,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		289000000;
get_goods_dynamic_exp(37010077,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		318000000;
get_goods_dynamic_exp(37010078,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		350000000;
get_goods_dynamic_exp(37010079,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		385000000;
get_goods_dynamic_exp(37010080,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		424000000;
get_goods_dynamic_exp(37010081,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		466000000;
get_goods_dynamic_exp(37010082,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		513000000;
get_goods_dynamic_exp(37010083,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		18000000;
get_goods_dynamic_exp(37010084,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		45000000;
get_goods_dynamic_exp(37010085,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		90000000;
get_goods_dynamic_exp(37010086,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		54000000;
get_goods_dynamic_exp(37010087,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		135000000;
get_goods_dynamic_exp(37010088,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		270000000;
get_goods_dynamic_exp(37010089,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		300000000;
get_goods_dynamic_exp(37010090,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		750000000;
get_goods_dynamic_exp(37010091,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1500000000;
get_goods_dynamic_exp(37010092,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		300000000;
get_goods_dynamic_exp(37010093,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		750000000;
get_goods_dynamic_exp(37010094,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1500000000;
get_goods_dynamic_exp(37010095,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		480000000;
get_goods_dynamic_exp(37010096,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		1200000000;
get_goods_dynamic_exp(37010097,_Lv) when _Lv >= 1, _Lv =< 9999 ->
		2400000000;
get_goods_dynamic_exp(_Goods_id,_Lv) ->
	0.

