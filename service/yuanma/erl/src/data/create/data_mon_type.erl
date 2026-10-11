%%%---------------------------------------
%%% module      : data_mon_type
%%% description : 怪物boss伤害加成配置
%%%
%%%---------------------------------------
-module(data_mon_type).
-compile(export_all).
-include("scene.hrl").



get_lv_hurt(3,7,_Lv) when _Lv >= -999, _Lv =< -200 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=7,blv=-999,elv=-200,role_add_hurt=-0.80,mon_add_hurt=2.50};
get_lv_hurt(3,4,_Lv) when _Lv >= -999, _Lv =< -170 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-999,elv=-170,role_add_hurt=-0.80,mon_add_hurt=0.00};
get_lv_hurt(3,12,_Lv) when _Lv >= -999, _Lv =< -160 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-999,elv=-160,role_add_hurt=0.00,mon_add_hurt=1.50};
get_lv_hurt(3,7,_Lv) when _Lv >= -200, _Lv =< -170 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=7,blv=-200,elv=-170,role_add_hurt=-0.70,mon_add_hurt=2.00};
get_lv_hurt(3,4,_Lv) when _Lv >= -169, _Lv =< -160 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-169,elv=-160,role_add_hurt=-0.70,mon_add_hurt=0.00};
get_lv_hurt(3,7,_Lv) when _Lv >= -169, _Lv =< -150 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=7,blv=-169,elv=-150,role_add_hurt=-0.55,mon_add_hurt=1.50};
get_lv_hurt(3,4,_Lv) when _Lv >= -159, _Lv =< -150 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-159,elv=-150,role_add_hurt=-0.60,mon_add_hurt=0.00};
get_lv_hurt(3,12,_Lv) when _Lv >= -159, _Lv =< -150 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-159,elv=-150,role_add_hurt=0.00,mon_add_hurt=1.30};
get_lv_hurt(3,4,_Lv) when _Lv >= -149, _Lv =< -140 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-149,elv=-140,role_add_hurt=-0.50,mon_add_hurt=0.00};
get_lv_hurt(3,12,_Lv) when _Lv >= -149, _Lv =< -140 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-149,elv=-140,role_add_hurt=0.00,mon_add_hurt=1.10};
get_lv_hurt(3,7,_Lv) when _Lv >= -149, _Lv =< -120 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=7,blv=-149,elv=-120,role_add_hurt=-0.40,mon_add_hurt=1.30};
get_lv_hurt(3,4,_Lv) when _Lv >= -139, _Lv =< -130 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-139,elv=-130,role_add_hurt=-0.40,mon_add_hurt=0.00};
get_lv_hurt(3,12,_Lv) when _Lv >= -139, _Lv =< -130 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-139,elv=-130,role_add_hurt=0.00,mon_add_hurt=0.90};
get_lv_hurt(3,4,_Lv) when _Lv >= -129, _Lv =< -120 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=4,blv=-129,elv=-120,role_add_hurt=-0.30,mon_add_hurt=0.00};
get_lv_hurt(3,12,_Lv) when _Lv >= -129, _Lv =< -120 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-129,elv=-120,role_add_hurt=0.00,mon_add_hurt=0.70};
get_lv_hurt(3,12,_Lv) when _Lv >= -119, _Lv =< -110 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=12,blv=-119,elv=-110,role_add_hurt=0.00,mon_add_hurt=0.50};
get_lv_hurt(3,7,_Lv) when _Lv >= -119, _Lv =< -100 ->
	#mon_type_lv_hurt{mon_type=3,boss_type=7,blv=-119,elv=-100,role_add_hurt=-0.25,mon_add_hurt=1.00};
get_lv_hurt(4,10,_Lv) when _Lv >= -999, _Lv =< -150 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-999,elv=-150,role_add_hurt=-0.75,mon_add_hurt=2.50};
get_lv_hurt(4,10,_Lv) when _Lv >= -149, _Lv =< -140 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-149,elv=-140,role_add_hurt=-0.65,mon_add_hurt=2.00};
get_lv_hurt(4,10,_Lv) when _Lv >= -139, _Lv =< -130 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-139,elv=-130,role_add_hurt=-0.55,mon_add_hurt=1.50};
get_lv_hurt(4,10,_Lv) when _Lv >= -129, _Lv =< -120 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-129,elv=-120,role_add_hurt=-0.45,mon_add_hurt=1.10};
get_lv_hurt(4,10,_Lv) when _Lv >= -119, _Lv =< -110 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-119,elv=-110,role_add_hurt=-0.35,mon_add_hurt=0.80};
get_lv_hurt(4,10,_Lv) when _Lv >= -109, _Lv =< -100 ->
	#mon_type_lv_hurt{mon_type=4,boss_type=10,blv=-109,elv=-100,role_add_hurt=-0.25,mon_add_hurt=0.50};
get_lv_hurt(_Mon_type,_Boss_type,_Lv) ->
	[].

