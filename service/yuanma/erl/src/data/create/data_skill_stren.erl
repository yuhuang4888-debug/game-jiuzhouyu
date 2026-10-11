%%%---------------------------------------
%%% module      : data_skill_stren
%%% description : 技能强化配置
%%%
%%%---------------------------------------
-module(data_skill_stren).
-compile(export_all).
-include("skill.hrl").



get_skill_id_list() ->
[100101,100201,100301,100401,100501,100601,200101,200102,200201,200202,200301,200401,200402,200501,200502,200601].

get_stren(100101,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100101,min_stren=0,max_stren=0,hurt=192,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100101,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100101,min_stren=1,max_stren=15,hurt=200,per_hurt=8,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=60,per_power=60};
get_stren(100101,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100101,min_stren=16,max_stren=40,hurt=320,per_hurt=8,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=960,per_power=60};
get_stren(100101,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100101,min_stren=41,max_stren=1500,hurt=520,per_hurt=8,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=2460,per_power=60};
get_stren(100201,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100201,min_stren=0,max_stren=0,hurt=234,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100201,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100201,min_stren=1,max_stren=15,hurt=244,per_hurt=10,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=70,per_power=70};
get_stren(100201,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100201,min_stren=16,max_stren=40,hurt=391,per_hurt=10,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1120,per_power=70};
get_stren(100201,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100201,min_stren=41,max_stren=1500,hurt=636,per_hurt=10,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=2870,per_power=70};
get_stren(100301,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100301,min_stren=0,max_stren=0,hurt=278,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100301,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100301,min_stren=1,max_stren=15,hurt=289,per_hurt=12,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=80,per_power=80};
get_stren(100301,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100301,min_stren=16,max_stren=40,hurt=462,per_hurt=12,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1280,per_power=80};
get_stren(100301,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100301,min_stren=41,max_stren=1500,hurt=751,per_hurt=12,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=3280,per_power=80};
get_stren(100401,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100401,min_stren=0,max_stren=0,hurt=342,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100401,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100401,min_stren=1,max_stren=15,hurt=356,per_hurt=14,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=90,per_power=90};
get_stren(100401,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100401,min_stren=16,max_stren=40,hurt=569,per_hurt=14,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1440,per_power=90};
get_stren(100401,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100401,min_stren=41,max_stren=1500,hurt=924,per_hurt=14,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=3690,per_power=90};
get_stren(100501,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100501,min_stren=0,max_stren=0,hurt=405,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100501,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100501,min_stren=1,max_stren=15,hurt=422,per_hurt=17,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=100,per_power=100};
get_stren(100501,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100501,min_stren=16,max_stren=40,hurt=676,per_hurt=17,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1600,per_power=100};
get_stren(100501,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100501,min_stren=41,max_stren=1500,hurt=1098,per_hurt=17,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=4100,per_power=100};
get_stren(100601,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=100601,min_stren=0,max_stren=0,hurt=490,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(100601,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=100601,min_stren=1,max_stren=15,hurt=511,per_hurt=20,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=110,per_power=110};
get_stren(100601,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=100601,min_stren=16,max_stren=40,hurt=818,per_hurt=20,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1760,per_power=110};
get_stren(100601,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=100601,min_stren=41,max_stren=1500,hurt=1329,per_hurt=20,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=4510,per_power=110};
get_stren(200101,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200101,min_stren=0,max_stren=0,hurt=192,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200101,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200101,min_stren=1,max_stren=15,hurt=200,per_hurt=8,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=60,per_power=60};
get_stren(200101,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200101,min_stren=16,max_stren=40,hurt=320,per_hurt=8,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=960,per_power=60};
get_stren(200101,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200101,min_stren=41,max_stren=1500,hurt=520,per_hurt=8,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=2460,per_power=60};
get_stren(200102,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200102,min_stren=0,max_stren=0,hurt=192,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200201,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200201,min_stren=0,max_stren=0,hurt=234,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200201,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200201,min_stren=1,max_stren=15,hurt=244,per_hurt=10,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=70,per_power=70};
get_stren(200201,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200201,min_stren=16,max_stren=40,hurt=391,per_hurt=10,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1120,per_power=70};
get_stren(200201,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200201,min_stren=41,max_stren=1500,hurt=636,per_hurt=10,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=2870,per_power=70};
get_stren(200202,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200202,min_stren=0,max_stren=0,hurt=234,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200301,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200301,min_stren=0,max_stren=0,hurt=278,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200301,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200301,min_stren=1,max_stren=15,hurt=289,per_hurt=12,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=80,per_power=80};
get_stren(200301,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200301,min_stren=16,max_stren=40,hurt=462,per_hurt=12,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1280,per_power=80};
get_stren(200301,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200301,min_stren=41,max_stren=1500,hurt=751,per_hurt=12,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=3280,per_power=80};
get_stren(200401,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200401,min_stren=0,max_stren=0,hurt=342,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200401,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200401,min_stren=1,max_stren=15,hurt=356,per_hurt=14,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=90,per_power=90};
get_stren(200401,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200401,min_stren=16,max_stren=40,hurt=569,per_hurt=14,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1440,per_power=90};
get_stren(200401,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200401,min_stren=41,max_stren=1500,hurt=924,per_hurt=14,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=3690,per_power=90};
get_stren(200402,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200402,min_stren=0,max_stren=0,hurt=342,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200501,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200501,min_stren=0,max_stren=0,hurt=405,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200501,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200501,min_stren=1,max_stren=15,hurt=422,per_hurt=17,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=100,per_power=100};
get_stren(200501,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200501,min_stren=16,max_stren=40,hurt=676,per_hurt=17,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1600,per_power=100};
get_stren(200501,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200501,min_stren=41,max_stren=1500,hurt=1098,per_hurt=17,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=4100,per_power=100};
get_stren(200502,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200502,min_stren=0,max_stren=0,hurt=405,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200601,_Stren) when _Stren >= 0, _Stren =< 0 ->
	#base_skill_stren{skill_id=200601,min_stren=0,max_stren=0,hurt=490,per_hurt=0,cost=[],per_cost=[],condition=[],power=0,per_power=0};
get_stren(200601,_Stren) when _Stren >= 1, _Stren =< 15 ->
	#base_skill_stren{skill_id=200601,min_stren=1,max_stren=15,hurt=511,per_hurt=20,cost=[{3,0,1000}],per_cost=[{3,0,200}],condition=[],power=110,per_power=110};
get_stren(200601,_Stren) when _Stren >= 16, _Stren =< 40 ->
	#base_skill_stren{skill_id=200601,min_stren=16,max_stren=40,hurt=818,per_hurt=20,cost=[{3,0,4300}],per_cost=[{3,0,500}],condition=[],power=1760,per_power=110};
get_stren(200601,_Stren) when _Stren >= 41, _Stren =< 1500 ->
	#base_skill_stren{skill_id=200601,min_stren=41,max_stren=1500,hurt=1329,per_hurt=20,cost=[{3,0,17300}],per_cost=[{3,0,1000}],condition=[],power=4510,per_power=110};
get_stren(_Skill_id,_Stren) ->
	[].

