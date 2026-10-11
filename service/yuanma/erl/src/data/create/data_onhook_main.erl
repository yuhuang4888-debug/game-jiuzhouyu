%%%---------------------------------------
%%% module      : data_onhook_main
%%% description : 主线挂机配置
%%%
%%%---------------------------------------
-module(data_onhook_main).
-compile(export_all).
-include("onhook.hrl").



get_onhook_drop(_Chapter) when _Chapter =< 0 ->
	#onhook_drop{chapter=0,origin_chapter=0,coin=4000,coin_add=0,exp=45000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[{2,[{101021010,10000},{101041010,10000},{101061010,10000},{101081010,10000},{101101010,10000},{102041010,10000}]},{3,[{101022010,10000},{101042010,10000},{101062010,10000},{101082010,10000},{101102010,10000},{102042010,10000}]},{4,[{101023011,10000},{101043011,10000},{101063011,10000},{101083011,10000},{101103011,10000},{102043011,10000}]}]};
get_onhook_drop(_Chapter) when _Chapter =< 1 ->
	#onhook_drop{chapter=1,origin_chapter=1,coin=5000,coin_add=0,exp=50000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2 ->
	#onhook_drop{chapter=2,origin_chapter=2,coin=5600,coin_add=0,exp=55000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3 ->
	#onhook_drop{chapter=3,origin_chapter=3,coin=6200,coin_add=0,exp=60000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4 ->
	#onhook_drop{chapter=4,origin_chapter=4,coin=6800,coin_add=0,exp=65000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 5 ->
	#onhook_drop{chapter=5,origin_chapter=5,coin=7400,coin_add=0,exp=70000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 6 ->
	#onhook_drop{chapter=6,origin_chapter=6,coin=8000,coin_add=0,exp=75000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 7 ->
	#onhook_drop{chapter=7,origin_chapter=7,coin=8600,coin_add=0,exp=80000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 8 ->
	#onhook_drop{chapter=8,origin_chapter=8,coin=9200,coin_add=0,exp=85000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 9 ->
	#onhook_drop{chapter=9,origin_chapter=9,coin=9800,coin_add=0,exp=90000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 10 ->
	#onhook_drop{chapter=10,origin_chapter=10,coin=10400,coin_add=0,exp=95000,exp_add=0,mon_soul=0,sdrop_num=50,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,0,40000},{4,0,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 11 ->
	#onhook_drop{chapter=11,origin_chapter=11,coin=11000,coin_add=0,exp=100000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 12 ->
	#onhook_drop{chapter=12,origin_chapter=12,coin=11600,coin_add=0,exp=105000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 13 ->
	#onhook_drop{chapter=13,origin_chapter=13,coin=12200,coin_add=0,exp=110000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 14 ->
	#onhook_drop{chapter=14,origin_chapter=14,coin=12800,coin_add=0,exp=115000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 15 ->
	#onhook_drop{chapter=15,origin_chapter=15,coin=13400,coin_add=0,exp=120000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 16 ->
	#onhook_drop{chapter=16,origin_chapter=16,coin=14000,coin_add=0,exp=125000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 17 ->
	#onhook_drop{chapter=17,origin_chapter=17,coin=14600,coin_add=0,exp=130000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 18 ->
	#onhook_drop{chapter=18,origin_chapter=18,coin=15200,coin_add=0,exp=135000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 19 ->
	#onhook_drop{chapter=19,origin_chapter=19,coin=15800,coin_add=0,exp=140000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 20 ->
	#onhook_drop{chapter=20,origin_chapter=20,coin=16400,coin_add=0,exp=145000,exp_add=0,mon_soul=0,sdrop_num=51,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 21 ->
	#onhook_drop{chapter=21,origin_chapter=21,coin=17000,coin_add=0,exp=150000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 22 ->
	#onhook_drop{chapter=22,origin_chapter=22,coin=17600,coin_add=0,exp=155000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 23 ->
	#onhook_drop{chapter=23,origin_chapter=23,coin=18200,coin_add=0,exp=160000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 24 ->
	#onhook_drop{chapter=24,origin_chapter=24,coin=18800,coin_add=0,exp=165000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 25 ->
	#onhook_drop{chapter=25,origin_chapter=25,coin=19400,coin_add=0,exp=170000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 26 ->
	#onhook_drop{chapter=26,origin_chapter=26,coin=20000,coin_add=0,exp=175000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 27 ->
	#onhook_drop{chapter=27,origin_chapter=27,coin=20600,coin_add=0,exp=180000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 28 ->
	#onhook_drop{chapter=28,origin_chapter=28,coin=21200,coin_add=0,exp=185000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 29 ->
	#onhook_drop{chapter=29,origin_chapter=29,coin=21800,coin_add=0,exp=190000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 30 ->
	#onhook_drop{chapter=30,origin_chapter=30,coin=22400,coin_add=0,exp=195000,exp_add=0,mon_soul=0,sdrop_num=52,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 40 ->
	#onhook_drop{chapter=40,origin_chapter=31,coin=23000,coin_add=600,exp=200000,exp_add=5000,mon_soul=0,sdrop_num=53,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 50 ->
	#onhook_drop{chapter=50,origin_chapter=41,coin=29000,coin_add=600,exp=250000,exp_add=5000,mon_soul=0,sdrop_num=54,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 60 ->
	#onhook_drop{chapter=60,origin_chapter=51,coin=35000,coin_add=600,exp=300000,exp_add=5000,mon_soul=0,sdrop_num=55,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 70 ->
	#onhook_drop{chapter=70,origin_chapter=61,coin=41000,coin_add=600,exp=350000,exp_add=5000,mon_soul=0,sdrop_num=56,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 80 ->
	#onhook_drop{chapter=80,origin_chapter=71,coin=47000,coin_add=100,exp=400000,exp_add=5000,mon_soul=0,sdrop_num=57,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 90 ->
	#onhook_drop{chapter=90,origin_chapter=81,coin=48000,coin_add=100,exp=450000,exp_add=5000,mon_soul=0,sdrop_num=58,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 100 ->
	#onhook_drop{chapter=100,origin_chapter=91,coin=49000,coin_add=100,exp=500000,exp_add=5000,mon_soul=0,sdrop_num=59,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 110 ->
	#onhook_drop{chapter=110,origin_chapter=101,coin=50000,coin_add=100,exp=550000,exp_add=5000,mon_soul=0,sdrop_num=60,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 120 ->
	#onhook_drop{chapter=120,origin_chapter=111,coin=51000,coin_add=100,exp=600000,exp_add=5000,mon_soul=0,sdrop_num=61,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 130 ->
	#onhook_drop{chapter=130,origin_chapter=121,coin=52000,coin_add=100,exp=650000,exp_add=5000,mon_soul=0,sdrop_num=62,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 140 ->
	#onhook_drop{chapter=140,origin_chapter=131,coin=53000,coin_add=100,exp=700000,exp_add=5000,mon_soul=0,sdrop_num=63,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 150 ->
	#onhook_drop{chapter=150,origin_chapter=141,coin=54000,coin_add=100,exp=750000,exp_add=5000,mon_soul=0,sdrop_num=64,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 160 ->
	#onhook_drop{chapter=160,origin_chapter=151,coin=55000,coin_add=100,exp=800000,exp_add=5000,mon_soul=0,sdrop_num=65,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 170 ->
	#onhook_drop{chapter=170,origin_chapter=161,coin=56000,coin_add=100,exp=850000,exp_add=5000,mon_soul=0,sdrop_num=66,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 180 ->
	#onhook_drop{chapter=180,origin_chapter=171,coin=57000,coin_add=100,exp=900000,exp_add=5000,mon_soul=0,sdrop_num=67,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 190 ->
	#onhook_drop{chapter=190,origin_chapter=181,coin=58000,coin_add=100,exp=950000,exp_add=5000,mon_soul=0,sdrop_num=68,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 200 ->
	#onhook_drop{chapter=200,origin_chapter=191,coin=59000,coin_add=100,exp=1000000,exp_add=5000,mon_soul=0,sdrop_num=69,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 210 ->
	#onhook_drop{chapter=210,origin_chapter=201,coin=60000,coin_add=100,exp=1050000,exp_add=5000,mon_soul=0,sdrop_num=70,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 220 ->
	#onhook_drop{chapter=220,origin_chapter=211,coin=61000,coin_add=100,exp=1100000,exp_add=5000,mon_soul=0,sdrop_num=71,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 230 ->
	#onhook_drop{chapter=230,origin_chapter=221,coin=62000,coin_add=100,exp=1150000,exp_add=5000,mon_soul=0,sdrop_num=72,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 240 ->
	#onhook_drop{chapter=240,origin_chapter=231,coin=63000,coin_add=100,exp=1200000,exp_add=5000,mon_soul=0,sdrop_num=73,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 250 ->
	#onhook_drop{chapter=250,origin_chapter=241,coin=64000,coin_add=100,exp=1250000,exp_add=5000,mon_soul=0,sdrop_num=74,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 260 ->
	#onhook_drop{chapter=260,origin_chapter=251,coin=65000,coin_add=100,exp=1300000,exp_add=5000,mon_soul=0,sdrop_num=75,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 270 ->
	#onhook_drop{chapter=270,origin_chapter=261,coin=66000,coin_add=100,exp=1350000,exp_add=5000,mon_soul=0,sdrop_num=76,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 280 ->
	#onhook_drop{chapter=280,origin_chapter=271,coin=67000,coin_add=100,exp=1400000,exp_add=5000,mon_soul=0,sdrop_num=77,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 290 ->
	#onhook_drop{chapter=290,origin_chapter=281,coin=68000,coin_add=100,exp=1450000,exp_add=5000,mon_soul=0,sdrop_num=78,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 300 ->
	#onhook_drop{chapter=300,origin_chapter=291,coin=69000,coin_add=100,exp=1500000,exp_add=5000,mon_soul=0,sdrop_num=79,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 310 ->
	#onhook_drop{chapter=310,origin_chapter=301,coin=70000,coin_add=100,exp=1550000,exp_add=5000,mon_soul=0,sdrop_num=80,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 320 ->
	#onhook_drop{chapter=320,origin_chapter=311,coin=71000,coin_add=100,exp=1600000,exp_add=5000,mon_soul=0,sdrop_num=81,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 330 ->
	#onhook_drop{chapter=330,origin_chapter=321,coin=72000,coin_add=100,exp=1650000,exp_add=5000,mon_soul=0,sdrop_num=82,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 340 ->
	#onhook_drop{chapter=340,origin_chapter=331,coin=73000,coin_add=100,exp=1700000,exp_add=5000,mon_soul=0,sdrop_num=83,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 350 ->
	#onhook_drop{chapter=350,origin_chapter=341,coin=74000,coin_add=100,exp=1750000,exp_add=5000,mon_soul=0,sdrop_num=84,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 360 ->
	#onhook_drop{chapter=360,origin_chapter=351,coin=75000,coin_add=100,exp=1800000,exp_add=5000,mon_soul=0,sdrop_num=85,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 370 ->
	#onhook_drop{chapter=370,origin_chapter=361,coin=76000,coin_add=100,exp=1850000,exp_add=5000,mon_soul=0,sdrop_num=86,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 380 ->
	#onhook_drop{chapter=380,origin_chapter=371,coin=77000,coin_add=100,exp=1900000,exp_add=5000,mon_soul=0,sdrop_num=87,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 390 ->
	#onhook_drop{chapter=390,origin_chapter=381,coin=78000,coin_add=100,exp=1950000,exp_add=5000,mon_soul=0,sdrop_num=88,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 400 ->
	#onhook_drop{chapter=400,origin_chapter=391,coin=79000,coin_add=100,exp=2000000,exp_add=5000,mon_soul=0,sdrop_num=89,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 410 ->
	#onhook_drop{chapter=410,origin_chapter=401,coin=80000,coin_add=100,exp=2050000,exp_add=5000,mon_soul=0,sdrop_num=90,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 420 ->
	#onhook_drop{chapter=420,origin_chapter=411,coin=81000,coin_add=100,exp=2100000,exp_add=5000,mon_soul=0,sdrop_num=91,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 430 ->
	#onhook_drop{chapter=430,origin_chapter=421,coin=82000,coin_add=100,exp=2150000,exp_add=5000,mon_soul=0,sdrop_num=92,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 440 ->
	#onhook_drop{chapter=440,origin_chapter=431,coin=83000,coin_add=100,exp=2200000,exp_add=5000,mon_soul=0,sdrop_num=93,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 450 ->
	#onhook_drop{chapter=450,origin_chapter=441,coin=84000,coin_add=100,exp=2250000,exp_add=5000,mon_soul=0,sdrop_num=94,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 460 ->
	#onhook_drop{chapter=460,origin_chapter=451,coin=85000,coin_add=100,exp=2300000,exp_add=5000,mon_soul=0,sdrop_num=95,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 470 ->
	#onhook_drop{chapter=470,origin_chapter=461,coin=86000,coin_add=100,exp=2350000,exp_add=5000,mon_soul=0,sdrop_num=96,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 480 ->
	#onhook_drop{chapter=480,origin_chapter=471,coin=87000,coin_add=100,exp=2400000,exp_add=5000,mon_soul=0,sdrop_num=97,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 490 ->
	#onhook_drop{chapter=490,origin_chapter=481,coin=88000,coin_add=100,exp=2450000,exp_add=5000,mon_soul=0,sdrop_num=98,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 500 ->
	#onhook_drop{chapter=500,origin_chapter=491,coin=89000,coin_add=100,exp=2500000,exp_add=5000,mon_soul=0,sdrop_num=99,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 510 ->
	#onhook_drop{chapter=510,origin_chapter=501,coin=90000,coin_add=100,exp=2550000,exp_add=5000,mon_soul=0,sdrop_num=100,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 520 ->
	#onhook_drop{chapter=520,origin_chapter=511,coin=91000,coin_add=100,exp=2600000,exp_add=5000,mon_soul=0,sdrop_num=101,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 530 ->
	#onhook_drop{chapter=530,origin_chapter=521,coin=92000,coin_add=100,exp=2650000,exp_add=5000,mon_soul=0,sdrop_num=102,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 540 ->
	#onhook_drop{chapter=540,origin_chapter=531,coin=93000,coin_add=100,exp=2700000,exp_add=5000,mon_soul=0,sdrop_num=103,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 550 ->
	#onhook_drop{chapter=550,origin_chapter=541,coin=94000,coin_add=100,exp=2750000,exp_add=5000,mon_soul=0,sdrop_num=104,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 560 ->
	#onhook_drop{chapter=560,origin_chapter=551,coin=95000,coin_add=100,exp=2800000,exp_add=5000,mon_soul=0,sdrop_num=105,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 570 ->
	#onhook_drop{chapter=570,origin_chapter=561,coin=96000,coin_add=100,exp=2850000,exp_add=5000,mon_soul=0,sdrop_num=106,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 580 ->
	#onhook_drop{chapter=580,origin_chapter=571,coin=97000,coin_add=100,exp=2900000,exp_add=5000,mon_soul=0,sdrop_num=107,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 590 ->
	#onhook_drop{chapter=590,origin_chapter=581,coin=98000,coin_add=100,exp=2950000,exp_add=5000,mon_soul=0,sdrop_num=108,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 600 ->
	#onhook_drop{chapter=600,origin_chapter=591,coin=99000,coin_add=100,exp=3000000,exp_add=5000,mon_soul=0,sdrop_num=109,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 610 ->
	#onhook_drop{chapter=610,origin_chapter=601,coin=100000,coin_add=100,exp=3050000,exp_add=5000,mon_soul=0,sdrop_num=110,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 620 ->
	#onhook_drop{chapter=620,origin_chapter=611,coin=101000,coin_add=100,exp=3100000,exp_add=5000,mon_soul=0,sdrop_num=111,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 630 ->
	#onhook_drop{chapter=630,origin_chapter=621,coin=102000,coin_add=100,exp=3150000,exp_add=5000,mon_soul=0,sdrop_num=112,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 640 ->
	#onhook_drop{chapter=640,origin_chapter=631,coin=103000,coin_add=100,exp=3200000,exp_add=5000,mon_soul=0,sdrop_num=113,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 650 ->
	#onhook_drop{chapter=650,origin_chapter=641,coin=104000,coin_add=100,exp=3250000,exp_add=5000,mon_soul=0,sdrop_num=114,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 660 ->
	#onhook_drop{chapter=660,origin_chapter=651,coin=105000,coin_add=100,exp=3300000,exp_add=5000,mon_soul=0,sdrop_num=115,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 670 ->
	#onhook_drop{chapter=670,origin_chapter=661,coin=106000,coin_add=100,exp=3350000,exp_add=5000,mon_soul=0,sdrop_num=116,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 680 ->
	#onhook_drop{chapter=680,origin_chapter=671,coin=107000,coin_add=100,exp=3400000,exp_add=5000,mon_soul=0,sdrop_num=117,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 690 ->
	#onhook_drop{chapter=690,origin_chapter=681,coin=108000,coin_add=100,exp=3450000,exp_add=5000,mon_soul=0,sdrop_num=118,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 700 ->
	#onhook_drop{chapter=700,origin_chapter=691,coin=109000,coin_add=100,exp=3500000,exp_add=5000,mon_soul=0,sdrop_num=119,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 710 ->
	#onhook_drop{chapter=710,origin_chapter=701,coin=110000,coin_add=100,exp=3555000,exp_add=10000,mon_soul=0,sdrop_num=120,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 720 ->
	#onhook_drop{chapter=720,origin_chapter=711,coin=111000,coin_add=100,exp=3655000,exp_add=10000,mon_soul=0,sdrop_num=121,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 730 ->
	#onhook_drop{chapter=730,origin_chapter=721,coin=112000,coin_add=100,exp=3755000,exp_add=10000,mon_soul=0,sdrop_num=122,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 740 ->
	#onhook_drop{chapter=740,origin_chapter=731,coin=113000,coin_add=100,exp=3855000,exp_add=10000,mon_soul=0,sdrop_num=123,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 750 ->
	#onhook_drop{chapter=750,origin_chapter=741,coin=114000,coin_add=100,exp=3955000,exp_add=10000,mon_soul=0,sdrop_num=124,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 760 ->
	#onhook_drop{chapter=760,origin_chapter=751,coin=115000,coin_add=100,exp=4060000,exp_add=15000,mon_soul=0,sdrop_num=125,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 770 ->
	#onhook_drop{chapter=770,origin_chapter=761,coin=116000,coin_add=100,exp=4210000,exp_add=15000,mon_soul=0,sdrop_num=126,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 780 ->
	#onhook_drop{chapter=780,origin_chapter=771,coin=117000,coin_add=100,exp=4360000,exp_add=15000,mon_soul=0,sdrop_num=127,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 790 ->
	#onhook_drop{chapter=790,origin_chapter=781,coin=118000,coin_add=100,exp=4510000,exp_add=15000,mon_soul=0,sdrop_num=128,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 800 ->
	#onhook_drop{chapter=800,origin_chapter=791,coin=119000,coin_add=100,exp=4660000,exp_add=15000,mon_soul=0,sdrop_num=129,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 810 ->
	#onhook_drop{chapter=810,origin_chapter=801,coin=120000,coin_add=100,exp=4815000,exp_add=20000,mon_soul=0,sdrop_num=130,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 820 ->
	#onhook_drop{chapter=820,origin_chapter=811,coin=121000,coin_add=100,exp=5015000,exp_add=20000,mon_soul=0,sdrop_num=131,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 830 ->
	#onhook_drop{chapter=830,origin_chapter=821,coin=122000,coin_add=100,exp=5215000,exp_add=20000,mon_soul=0,sdrop_num=132,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 840 ->
	#onhook_drop{chapter=840,origin_chapter=831,coin=123000,coin_add=100,exp=5415000,exp_add=20000,mon_soul=0,sdrop_num=133,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 850 ->
	#onhook_drop{chapter=850,origin_chapter=841,coin=124000,coin_add=100,exp=5615000,exp_add=20000,mon_soul=0,sdrop_num=134,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 860 ->
	#onhook_drop{chapter=860,origin_chapter=851,coin=125000,coin_add=100,exp=5820000,exp_add=25000,mon_soul=0,sdrop_num=135,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 870 ->
	#onhook_drop{chapter=870,origin_chapter=861,coin=126000,coin_add=100,exp=6070000,exp_add=25000,mon_soul=0,sdrop_num=136,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 880 ->
	#onhook_drop{chapter=880,origin_chapter=871,coin=127000,coin_add=100,exp=6320000,exp_add=25000,mon_soul=0,sdrop_num=137,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 890 ->
	#onhook_drop{chapter=890,origin_chapter=881,coin=128000,coin_add=100,exp=6570000,exp_add=25000,mon_soul=0,sdrop_num=138,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 900 ->
	#onhook_drop{chapter=900,origin_chapter=891,coin=129000,coin_add=100,exp=6820000,exp_add=25000,mon_soul=0,sdrop_num=139,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 910 ->
	#onhook_drop{chapter=910,origin_chapter=901,coin=130000,coin_add=100,exp=7070000,exp_add=25000,mon_soul=0,sdrop_num=140,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 920 ->
	#onhook_drop{chapter=920,origin_chapter=911,coin=131000,coin_add=100,exp=7320000,exp_add=25000,mon_soul=0,sdrop_num=141,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 930 ->
	#onhook_drop{chapter=930,origin_chapter=921,coin=132000,coin_add=100,exp=7570000,exp_add=25000,mon_soul=0,sdrop_num=142,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 940 ->
	#onhook_drop{chapter=940,origin_chapter=931,coin=133000,coin_add=100,exp=7820000,exp_add=25000,mon_soul=0,sdrop_num=143,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 950 ->
	#onhook_drop{chapter=950,origin_chapter=941,coin=134000,coin_add=100,exp=8070000,exp_add=25000,mon_soul=0,sdrop_num=144,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 960 ->
	#onhook_drop{chapter=960,origin_chapter=951,coin=135000,coin_add=100,exp=8320000,exp_add=25000,mon_soul=0,sdrop_num=145,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 970 ->
	#onhook_drop{chapter=970,origin_chapter=961,coin=136000,coin_add=100,exp=8570000,exp_add=25000,mon_soul=0,sdrop_num=146,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 980 ->
	#onhook_drop{chapter=980,origin_chapter=971,coin=137000,coin_add=100,exp=8820000,exp_add=25000,mon_soul=0,sdrop_num=147,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 990 ->
	#onhook_drop{chapter=990,origin_chapter=981,coin=138000,coin_add=100,exp=9070000,exp_add=25000,mon_soul=0,sdrop_num=148,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1000 ->
	#onhook_drop{chapter=1000,origin_chapter=991,coin=139000,coin_add=100,exp=9320000,exp_add=25000,mon_soul=0,sdrop_num=149,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1010 ->
	#onhook_drop{chapter=1010,origin_chapter=1001,coin=140000,coin_add=100,exp=9570000,exp_add=25000,mon_soul=0,sdrop_num=150,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1020 ->
	#onhook_drop{chapter=1020,origin_chapter=1011,coin=141000,coin_add=100,exp=9820000,exp_add=25000,mon_soul=0,sdrop_num=151,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1030 ->
	#onhook_drop{chapter=1030,origin_chapter=1021,coin=142000,coin_add=100,exp=10070000,exp_add=25000,mon_soul=0,sdrop_num=152,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1040 ->
	#onhook_drop{chapter=1040,origin_chapter=1031,coin=143000,coin_add=100,exp=10320000,exp_add=25000,mon_soul=0,sdrop_num=153,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1050 ->
	#onhook_drop{chapter=1050,origin_chapter=1041,coin=144000,coin_add=100,exp=10570000,exp_add=25000,mon_soul=0,sdrop_num=154,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1060 ->
	#onhook_drop{chapter=1060,origin_chapter=1051,coin=145000,coin_add=100,exp=10820000,exp_add=25000,mon_soul=0,sdrop_num=155,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1070 ->
	#onhook_drop{chapter=1070,origin_chapter=1061,coin=146000,coin_add=100,exp=11070000,exp_add=25000,mon_soul=0,sdrop_num=156,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1080 ->
	#onhook_drop{chapter=1080,origin_chapter=1071,coin=147000,coin_add=100,exp=11320000,exp_add=25000,mon_soul=0,sdrop_num=157,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1090 ->
	#onhook_drop{chapter=1090,origin_chapter=1081,coin=148000,coin_add=100,exp=11570000,exp_add=25000,mon_soul=0,sdrop_num=158,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1100 ->
	#onhook_drop{chapter=1100,origin_chapter=1091,coin=149000,coin_add=100,exp=11820000,exp_add=25000,mon_soul=0,sdrop_num=159,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1110 ->
	#onhook_drop{chapter=1110,origin_chapter=1101,coin=150000,coin_add=100,exp=12070000,exp_add=25000,mon_soul=0,sdrop_num=160,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1120 ->
	#onhook_drop{chapter=1120,origin_chapter=1111,coin=151000,coin_add=100,exp=12320000,exp_add=25000,mon_soul=0,sdrop_num=161,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1130 ->
	#onhook_drop{chapter=1130,origin_chapter=1121,coin=152000,coin_add=100,exp=12570000,exp_add=25000,mon_soul=0,sdrop_num=162,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1140 ->
	#onhook_drop{chapter=1140,origin_chapter=1131,coin=153000,coin_add=100,exp=12820000,exp_add=25000,mon_soul=0,sdrop_num=163,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1150 ->
	#onhook_drop{chapter=1150,origin_chapter=1141,coin=154000,coin_add=100,exp=13070000,exp_add=25000,mon_soul=0,sdrop_num=164,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1160 ->
	#onhook_drop{chapter=1160,origin_chapter=1151,coin=155000,coin_add=100,exp=13320000,exp_add=25000,mon_soul=0,sdrop_num=165,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1170 ->
	#onhook_drop{chapter=1170,origin_chapter=1161,coin=156000,coin_add=100,exp=13570000,exp_add=25000,mon_soul=0,sdrop_num=166,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1180 ->
	#onhook_drop{chapter=1180,origin_chapter=1171,coin=157000,coin_add=100,exp=13820000,exp_add=25000,mon_soul=0,sdrop_num=167,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1190 ->
	#onhook_drop{chapter=1190,origin_chapter=1181,coin=158000,coin_add=100,exp=14070000,exp_add=25000,mon_soul=0,sdrop_num=168,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1200 ->
	#onhook_drop{chapter=1200,origin_chapter=1191,coin=159000,coin_add=100,exp=14320000,exp_add=25000,mon_soul=0,sdrop_num=169,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1210 ->
	#onhook_drop{chapter=1210,origin_chapter=1201,coin=160000,coin_add=100,exp=14570000,exp_add=25000,mon_soul=0,sdrop_num=170,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1220 ->
	#onhook_drop{chapter=1220,origin_chapter=1211,coin=161000,coin_add=100,exp=14820000,exp_add=25000,mon_soul=0,sdrop_num=171,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1230 ->
	#onhook_drop{chapter=1230,origin_chapter=1221,coin=162000,coin_add=100,exp=15070000,exp_add=25000,mon_soul=0,sdrop_num=172,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1240 ->
	#onhook_drop{chapter=1240,origin_chapter=1231,coin=163000,coin_add=100,exp=15320000,exp_add=25000,mon_soul=0,sdrop_num=173,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1250 ->
	#onhook_drop{chapter=1250,origin_chapter=1241,coin=164000,coin_add=100,exp=15570000,exp_add=25000,mon_soul=0,sdrop_num=174,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1260 ->
	#onhook_drop{chapter=1260,origin_chapter=1251,coin=165000,coin_add=100,exp=15820000,exp_add=25000,mon_soul=0,sdrop_num=175,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1270 ->
	#onhook_drop{chapter=1270,origin_chapter=1261,coin=166000,coin_add=100,exp=16070000,exp_add=25000,mon_soul=0,sdrop_num=176,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1280 ->
	#onhook_drop{chapter=1280,origin_chapter=1271,coin=167000,coin_add=100,exp=16320000,exp_add=25000,mon_soul=0,sdrop_num=177,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1290 ->
	#onhook_drop{chapter=1290,origin_chapter=1281,coin=168000,coin_add=100,exp=16570000,exp_add=25000,mon_soul=0,sdrop_num=178,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1300 ->
	#onhook_drop{chapter=1300,origin_chapter=1291,coin=169000,coin_add=100,exp=16820000,exp_add=25000,mon_soul=0,sdrop_num=179,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1310 ->
	#onhook_drop{chapter=1310,origin_chapter=1301,coin=170000,coin_add=100,exp=17070000,exp_add=25000,mon_soul=0,sdrop_num=180,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1320 ->
	#onhook_drop{chapter=1320,origin_chapter=1311,coin=171000,coin_add=100,exp=17320000,exp_add=25000,mon_soul=0,sdrop_num=181,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1330 ->
	#onhook_drop{chapter=1330,origin_chapter=1321,coin=172000,coin_add=100,exp=17570000,exp_add=25000,mon_soul=0,sdrop_num=182,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1340 ->
	#onhook_drop{chapter=1340,origin_chapter=1331,coin=173000,coin_add=100,exp=17820000,exp_add=25000,mon_soul=0,sdrop_num=183,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1350 ->
	#onhook_drop{chapter=1350,origin_chapter=1341,coin=174000,coin_add=100,exp=18070000,exp_add=25000,mon_soul=0,sdrop_num=184,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1360 ->
	#onhook_drop{chapter=1360,origin_chapter=1351,coin=175000,coin_add=100,exp=18320000,exp_add=25000,mon_soul=0,sdrop_num=185,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1370 ->
	#onhook_drop{chapter=1370,origin_chapter=1361,coin=176000,coin_add=100,exp=18570000,exp_add=25000,mon_soul=0,sdrop_num=186,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1380 ->
	#onhook_drop{chapter=1380,origin_chapter=1371,coin=177000,coin_add=100,exp=18820000,exp_add=25000,mon_soul=0,sdrop_num=187,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1390 ->
	#onhook_drop{chapter=1390,origin_chapter=1381,coin=178000,coin_add=100,exp=19070000,exp_add=25000,mon_soul=0,sdrop_num=188,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1400 ->
	#onhook_drop{chapter=1400,origin_chapter=1391,coin=179000,coin_add=100,exp=19320000,exp_add=25000,mon_soul=0,sdrop_num=189,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1410 ->
	#onhook_drop{chapter=1410,origin_chapter=1401,coin=180000,coin_add=100,exp=19570000,exp_add=25000,mon_soul=0,sdrop_num=190,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1420 ->
	#onhook_drop{chapter=1420,origin_chapter=1411,coin=181000,coin_add=100,exp=19820000,exp_add=25000,mon_soul=0,sdrop_num=191,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1430 ->
	#onhook_drop{chapter=1430,origin_chapter=1421,coin=182000,coin_add=100,exp=20070000,exp_add=25000,mon_soul=0,sdrop_num=192,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1440 ->
	#onhook_drop{chapter=1440,origin_chapter=1431,coin=183000,coin_add=100,exp=20320000,exp_add=25000,mon_soul=0,sdrop_num=193,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1450 ->
	#onhook_drop{chapter=1450,origin_chapter=1441,coin=184000,coin_add=100,exp=20570000,exp_add=25000,mon_soul=0,sdrop_num=194,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1460 ->
	#onhook_drop{chapter=1460,origin_chapter=1451,coin=185000,coin_add=100,exp=20820000,exp_add=25000,mon_soul=0,sdrop_num=195,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1470 ->
	#onhook_drop{chapter=1470,origin_chapter=1461,coin=186000,coin_add=100,exp=21070000,exp_add=25000,mon_soul=0,sdrop_num=196,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1480 ->
	#onhook_drop{chapter=1480,origin_chapter=1471,coin=187000,coin_add=100,exp=21320000,exp_add=25000,mon_soul=0,sdrop_num=197,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1490 ->
	#onhook_drop{chapter=1490,origin_chapter=1481,coin=188000,coin_add=100,exp=21570000,exp_add=25000,mon_soul=0,sdrop_num=198,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1500 ->
	#onhook_drop{chapter=1500,origin_chapter=1491,coin=189000,coin_add=100,exp=21820000,exp_add=25000,mon_soul=0,sdrop_num=199,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1510 ->
	#onhook_drop{chapter=1510,origin_chapter=1501,coin=190000,coin_add=100,exp=22070000,exp_add=25000,mon_soul=0,sdrop_num=200,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1520 ->
	#onhook_drop{chapter=1520,origin_chapter=1511,coin=191000,coin_add=100,exp=22320000,exp_add=25000,mon_soul=0,sdrop_num=201,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1530 ->
	#onhook_drop{chapter=1530,origin_chapter=1521,coin=192000,coin_add=100,exp=22570000,exp_add=25000,mon_soul=0,sdrop_num=202,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1540 ->
	#onhook_drop{chapter=1540,origin_chapter=1531,coin=193000,coin_add=100,exp=22820000,exp_add=25000,mon_soul=0,sdrop_num=203,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1550 ->
	#onhook_drop{chapter=1550,origin_chapter=1541,coin=194000,coin_add=100,exp=23070000,exp_add=25000,mon_soul=0,sdrop_num=204,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1560 ->
	#onhook_drop{chapter=1560,origin_chapter=1551,coin=195000,coin_add=100,exp=23320000,exp_add=25000,mon_soul=0,sdrop_num=205,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1570 ->
	#onhook_drop{chapter=1570,origin_chapter=1561,coin=196000,coin_add=100,exp=23570000,exp_add=25000,mon_soul=0,sdrop_num=206,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1580 ->
	#onhook_drop{chapter=1580,origin_chapter=1571,coin=197000,coin_add=100,exp=23820000,exp_add=25000,mon_soul=0,sdrop_num=207,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1590 ->
	#onhook_drop{chapter=1590,origin_chapter=1581,coin=198000,coin_add=100,exp=24070000,exp_add=25000,mon_soul=0,sdrop_num=208,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1600 ->
	#onhook_drop{chapter=1600,origin_chapter=1591,coin=199000,coin_add=100,exp=24320000,exp_add=25000,mon_soul=0,sdrop_num=209,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1610 ->
	#onhook_drop{chapter=1610,origin_chapter=1601,coin=200000,coin_add=100,exp=24595000,exp_add=50000,mon_soul=0,sdrop_num=210,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1620 ->
	#onhook_drop{chapter=1620,origin_chapter=1611,coin=201000,coin_add=100,exp=25095000,exp_add=50000,mon_soul=0,sdrop_num=211,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1630 ->
	#onhook_drop{chapter=1630,origin_chapter=1621,coin=202000,coin_add=100,exp=25595000,exp_add=50000,mon_soul=0,sdrop_num=212,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1640 ->
	#onhook_drop{chapter=1640,origin_chapter=1631,coin=203000,coin_add=100,exp=26095000,exp_add=50000,mon_soul=0,sdrop_num=213,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1650 ->
	#onhook_drop{chapter=1650,origin_chapter=1641,coin=204000,coin_add=100,exp=26595000,exp_add=50000,mon_soul=0,sdrop_num=214,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1660 ->
	#onhook_drop{chapter=1660,origin_chapter=1651,coin=205000,coin_add=100,exp=27095000,exp_add=50000,mon_soul=0,sdrop_num=215,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1670 ->
	#onhook_drop{chapter=1670,origin_chapter=1661,coin=206000,coin_add=100,exp=27595000,exp_add=50000,mon_soul=0,sdrop_num=216,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1680 ->
	#onhook_drop{chapter=1680,origin_chapter=1671,coin=207000,coin_add=100,exp=28095000,exp_add=50000,mon_soul=0,sdrop_num=217,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1690 ->
	#onhook_drop{chapter=1690,origin_chapter=1681,coin=208000,coin_add=100,exp=28595000,exp_add=50000,mon_soul=0,sdrop_num=218,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1700 ->
	#onhook_drop{chapter=1700,origin_chapter=1691,coin=209000,coin_add=100,exp=29095000,exp_add=50000,mon_soul=0,sdrop_num=219,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1710 ->
	#onhook_drop{chapter=1710,origin_chapter=1701,coin=210000,coin_add=100,exp=29595000,exp_add=50000,mon_soul=0,sdrop_num=220,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1720 ->
	#onhook_drop{chapter=1720,origin_chapter=1711,coin=211000,coin_add=100,exp=30095000,exp_add=50000,mon_soul=0,sdrop_num=221,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1730 ->
	#onhook_drop{chapter=1730,origin_chapter=1721,coin=212000,coin_add=100,exp=30595000,exp_add=50000,mon_soul=0,sdrop_num=222,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1740 ->
	#onhook_drop{chapter=1740,origin_chapter=1731,coin=213000,coin_add=100,exp=31095000,exp_add=50000,mon_soul=0,sdrop_num=223,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1750 ->
	#onhook_drop{chapter=1750,origin_chapter=1741,coin=214000,coin_add=100,exp=31595000,exp_add=50000,mon_soul=0,sdrop_num=224,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1760 ->
	#onhook_drop{chapter=1760,origin_chapter=1751,coin=215000,coin_add=100,exp=32095000,exp_add=50000,mon_soul=0,sdrop_num=225,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1770 ->
	#onhook_drop{chapter=1770,origin_chapter=1761,coin=216000,coin_add=100,exp=32595000,exp_add=50000,mon_soul=0,sdrop_num=226,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1780 ->
	#onhook_drop{chapter=1780,origin_chapter=1771,coin=217000,coin_add=100,exp=33095000,exp_add=50000,mon_soul=0,sdrop_num=227,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1790 ->
	#onhook_drop{chapter=1790,origin_chapter=1781,coin=218000,coin_add=100,exp=33595000,exp_add=50000,mon_soul=0,sdrop_num=228,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1800 ->
	#onhook_drop{chapter=1800,origin_chapter=1791,coin=219000,coin_add=100,exp=34095000,exp_add=50000,mon_soul=0,sdrop_num=229,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1810 ->
	#onhook_drop{chapter=1810,origin_chapter=1801,coin=220000,coin_add=100,exp=34595000,exp_add=50000,mon_soul=0,sdrop_num=230,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1820 ->
	#onhook_drop{chapter=1820,origin_chapter=1811,coin=221000,coin_add=100,exp=35095000,exp_add=50000,mon_soul=0,sdrop_num=231,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1830 ->
	#onhook_drop{chapter=1830,origin_chapter=1821,coin=222000,coin_add=100,exp=35595000,exp_add=50000,mon_soul=0,sdrop_num=232,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1840 ->
	#onhook_drop{chapter=1840,origin_chapter=1831,coin=223000,coin_add=100,exp=36095000,exp_add=50000,mon_soul=0,sdrop_num=233,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1850 ->
	#onhook_drop{chapter=1850,origin_chapter=1841,coin=224000,coin_add=100,exp=36595000,exp_add=50000,mon_soul=0,sdrop_num=234,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1860 ->
	#onhook_drop{chapter=1860,origin_chapter=1851,coin=225000,coin_add=100,exp=37095000,exp_add=50000,mon_soul=0,sdrop_num=235,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1870 ->
	#onhook_drop{chapter=1870,origin_chapter=1861,coin=226000,coin_add=100,exp=37595000,exp_add=50000,mon_soul=0,sdrop_num=236,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1880 ->
	#onhook_drop{chapter=1880,origin_chapter=1871,coin=227000,coin_add=100,exp=38095000,exp_add=50000,mon_soul=0,sdrop_num=237,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1890 ->
	#onhook_drop{chapter=1890,origin_chapter=1881,coin=228000,coin_add=100,exp=38595000,exp_add=50000,mon_soul=0,sdrop_num=238,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1900 ->
	#onhook_drop{chapter=1900,origin_chapter=1891,coin=229000,coin_add=100,exp=39095000,exp_add=50000,mon_soul=0,sdrop_num=239,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1910 ->
	#onhook_drop{chapter=1910,origin_chapter=1901,coin=230000,coin_add=100,exp=39595000,exp_add=50000,mon_soul=0,sdrop_num=240,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1920 ->
	#onhook_drop{chapter=1920,origin_chapter=1911,coin=231000,coin_add=100,exp=40095000,exp_add=50000,mon_soul=0,sdrop_num=241,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1930 ->
	#onhook_drop{chapter=1930,origin_chapter=1921,coin=232000,coin_add=100,exp=40595000,exp_add=50000,mon_soul=0,sdrop_num=242,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1940 ->
	#onhook_drop{chapter=1940,origin_chapter=1931,coin=233000,coin_add=100,exp=41095000,exp_add=50000,mon_soul=0,sdrop_num=243,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1950 ->
	#onhook_drop{chapter=1950,origin_chapter=1941,coin=234000,coin_add=100,exp=41595000,exp_add=50000,mon_soul=0,sdrop_num=244,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1960 ->
	#onhook_drop{chapter=1960,origin_chapter=1951,coin=235000,coin_add=100,exp=42095000,exp_add=50000,mon_soul=0,sdrop_num=245,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1970 ->
	#onhook_drop{chapter=1970,origin_chapter=1961,coin=236000,coin_add=100,exp=42595000,exp_add=50000,mon_soul=0,sdrop_num=246,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1980 ->
	#onhook_drop{chapter=1980,origin_chapter=1971,coin=237000,coin_add=100,exp=43095000,exp_add=50000,mon_soul=0,sdrop_num=247,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 1990 ->
	#onhook_drop{chapter=1990,origin_chapter=1981,coin=238000,coin_add=100,exp=43595000,exp_add=50000,mon_soul=0,sdrop_num=248,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2000 ->
	#onhook_drop{chapter=2000,origin_chapter=1991,coin=239000,coin_add=100,exp=44095000,exp_add=50000,mon_soul=0,sdrop_num=249,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2010 ->
	#onhook_drop{chapter=2010,origin_chapter=2001,coin=240000,coin_add=100,exp=44595000,exp_add=50000,mon_soul=0,sdrop_num=250,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2020 ->
	#onhook_drop{chapter=2020,origin_chapter=2011,coin=241000,coin_add=100,exp=45095000,exp_add=50000,mon_soul=0,sdrop_num=251,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2030 ->
	#onhook_drop{chapter=2030,origin_chapter=2021,coin=242000,coin_add=100,exp=45595000,exp_add=50000,mon_soul=0,sdrop_num=252,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2040 ->
	#onhook_drop{chapter=2040,origin_chapter=2031,coin=243000,coin_add=100,exp=46095000,exp_add=50000,mon_soul=0,sdrop_num=253,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2050 ->
	#onhook_drop{chapter=2050,origin_chapter=2041,coin=244000,coin_add=100,exp=46595000,exp_add=50000,mon_soul=0,sdrop_num=254,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2060 ->
	#onhook_drop{chapter=2060,origin_chapter=2051,coin=245000,coin_add=100,exp=47095000,exp_add=50000,mon_soul=0,sdrop_num=255,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2070 ->
	#onhook_drop{chapter=2070,origin_chapter=2061,coin=246000,coin_add=100,exp=47595000,exp_add=50000,mon_soul=0,sdrop_num=256,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2080 ->
	#onhook_drop{chapter=2080,origin_chapter=2071,coin=247000,coin_add=100,exp=48095000,exp_add=50000,mon_soul=0,sdrop_num=257,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2090 ->
	#onhook_drop{chapter=2090,origin_chapter=2081,coin=248000,coin_add=100,exp=48595000,exp_add=50000,mon_soul=0,sdrop_num=258,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2100 ->
	#onhook_drop{chapter=2100,origin_chapter=2091,coin=249000,coin_add=100,exp=49095000,exp_add=50000,mon_soul=0,sdrop_num=259,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2110 ->
	#onhook_drop{chapter=2110,origin_chapter=2101,coin=250000,coin_add=100,exp=49595000,exp_add=50000,mon_soul=0,sdrop_num=260,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2120 ->
	#onhook_drop{chapter=2120,origin_chapter=2111,coin=251000,coin_add=100,exp=50095000,exp_add=50000,mon_soul=0,sdrop_num=261,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2130 ->
	#onhook_drop{chapter=2130,origin_chapter=2121,coin=252000,coin_add=100,exp=50595000,exp_add=50000,mon_soul=0,sdrop_num=262,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2140 ->
	#onhook_drop{chapter=2140,origin_chapter=2131,coin=253000,coin_add=100,exp=51095000,exp_add=50000,mon_soul=0,sdrop_num=263,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2150 ->
	#onhook_drop{chapter=2150,origin_chapter=2141,coin=254000,coin_add=100,exp=51595000,exp_add=50000,mon_soul=0,sdrop_num=264,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2160 ->
	#onhook_drop{chapter=2160,origin_chapter=2151,coin=255000,coin_add=100,exp=52095000,exp_add=50000,mon_soul=0,sdrop_num=265,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2170 ->
	#onhook_drop{chapter=2170,origin_chapter=2161,coin=256000,coin_add=100,exp=52595000,exp_add=50000,mon_soul=0,sdrop_num=266,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2180 ->
	#onhook_drop{chapter=2180,origin_chapter=2171,coin=257000,coin_add=100,exp=53095000,exp_add=50000,mon_soul=0,sdrop_num=267,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2190 ->
	#onhook_drop{chapter=2190,origin_chapter=2181,coin=258000,coin_add=100,exp=53595000,exp_add=50000,mon_soul=0,sdrop_num=268,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2200 ->
	#onhook_drop{chapter=2200,origin_chapter=2191,coin=259000,coin_add=100,exp=54095000,exp_add=50000,mon_soul=0,sdrop_num=269,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2210 ->
	#onhook_drop{chapter=2210,origin_chapter=2201,coin=260000,coin_add=100,exp=54595000,exp_add=50000,mon_soul=0,sdrop_num=270,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2220 ->
	#onhook_drop{chapter=2220,origin_chapter=2211,coin=261000,coin_add=100,exp=55095000,exp_add=50000,mon_soul=0,sdrop_num=271,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2230 ->
	#onhook_drop{chapter=2230,origin_chapter=2221,coin=262000,coin_add=100,exp=55595000,exp_add=50000,mon_soul=0,sdrop_num=272,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2240 ->
	#onhook_drop{chapter=2240,origin_chapter=2231,coin=263000,coin_add=100,exp=56095000,exp_add=50000,mon_soul=0,sdrop_num=273,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2250 ->
	#onhook_drop{chapter=2250,origin_chapter=2241,coin=264000,coin_add=100,exp=56595000,exp_add=50000,mon_soul=0,sdrop_num=274,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2260 ->
	#onhook_drop{chapter=2260,origin_chapter=2251,coin=265000,coin_add=100,exp=57095000,exp_add=50000,mon_soul=0,sdrop_num=275,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2270 ->
	#onhook_drop{chapter=2270,origin_chapter=2261,coin=266000,coin_add=100,exp=57595000,exp_add=50000,mon_soul=0,sdrop_num=276,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2280 ->
	#onhook_drop{chapter=2280,origin_chapter=2271,coin=267000,coin_add=100,exp=58095000,exp_add=50000,mon_soul=0,sdrop_num=277,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2290 ->
	#onhook_drop{chapter=2290,origin_chapter=2281,coin=268000,coin_add=100,exp=58595000,exp_add=50000,mon_soul=0,sdrop_num=278,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2300 ->
	#onhook_drop{chapter=2300,origin_chapter=2291,coin=269000,coin_add=100,exp=59095000,exp_add=50000,mon_soul=0,sdrop_num=279,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2310 ->
	#onhook_drop{chapter=2310,origin_chapter=2301,coin=270000,coin_add=100,exp=59595000,exp_add=50000,mon_soul=0,sdrop_num=280,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2320 ->
	#onhook_drop{chapter=2320,origin_chapter=2311,coin=271000,coin_add=100,exp=60095000,exp_add=50000,mon_soul=0,sdrop_num=281,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2330 ->
	#onhook_drop{chapter=2330,origin_chapter=2321,coin=272000,coin_add=100,exp=60595000,exp_add=50000,mon_soul=0,sdrop_num=282,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2340 ->
	#onhook_drop{chapter=2340,origin_chapter=2331,coin=273000,coin_add=100,exp=61095000,exp_add=50000,mon_soul=0,sdrop_num=283,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2350 ->
	#onhook_drop{chapter=2350,origin_chapter=2341,coin=274000,coin_add=100,exp=61595000,exp_add=50000,mon_soul=0,sdrop_num=284,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2360 ->
	#onhook_drop{chapter=2360,origin_chapter=2351,coin=275000,coin_add=100,exp=62095000,exp_add=50000,mon_soul=0,sdrop_num=285,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2370 ->
	#onhook_drop{chapter=2370,origin_chapter=2361,coin=276000,coin_add=100,exp=62595000,exp_add=50000,mon_soul=0,sdrop_num=286,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2380 ->
	#onhook_drop{chapter=2380,origin_chapter=2371,coin=277000,coin_add=100,exp=63095000,exp_add=50000,mon_soul=0,sdrop_num=287,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2390 ->
	#onhook_drop{chapter=2390,origin_chapter=2381,coin=278000,coin_add=100,exp=63595000,exp_add=50000,mon_soul=0,sdrop_num=288,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2400 ->
	#onhook_drop{chapter=2400,origin_chapter=2391,coin=279000,coin_add=100,exp=64095000,exp_add=50000,mon_soul=0,sdrop_num=289,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2410 ->
	#onhook_drop{chapter=2410,origin_chapter=2401,coin=280000,coin_add=100,exp=64595000,exp_add=50000,mon_soul=0,sdrop_num=290,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2420 ->
	#onhook_drop{chapter=2420,origin_chapter=2411,coin=281000,coin_add=100,exp=65095000,exp_add=50000,mon_soul=0,sdrop_num=291,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2430 ->
	#onhook_drop{chapter=2430,origin_chapter=2421,coin=282000,coin_add=100,exp=65595000,exp_add=50000,mon_soul=0,sdrop_num=292,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2440 ->
	#onhook_drop{chapter=2440,origin_chapter=2431,coin=283000,coin_add=100,exp=66095000,exp_add=50000,mon_soul=0,sdrop_num=293,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2450 ->
	#onhook_drop{chapter=2450,origin_chapter=2441,coin=284000,coin_add=100,exp=66595000,exp_add=50000,mon_soul=0,sdrop_num=294,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2460 ->
	#onhook_drop{chapter=2460,origin_chapter=2451,coin=285000,coin_add=100,exp=67095000,exp_add=50000,mon_soul=0,sdrop_num=295,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2470 ->
	#onhook_drop{chapter=2470,origin_chapter=2461,coin=286000,coin_add=100,exp=67595000,exp_add=50000,mon_soul=0,sdrop_num=296,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2480 ->
	#onhook_drop{chapter=2480,origin_chapter=2471,coin=287000,coin_add=100,exp=68095000,exp_add=50000,mon_soul=0,sdrop_num=297,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2490 ->
	#onhook_drop{chapter=2490,origin_chapter=2481,coin=288000,coin_add=100,exp=68595000,exp_add=50000,mon_soul=0,sdrop_num=298,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2500 ->
	#onhook_drop{chapter=2500,origin_chapter=2491,coin=289000,coin_add=100,exp=69095000,exp_add=50000,mon_soul=0,sdrop_num=299,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2510 ->
	#onhook_drop{chapter=2510,origin_chapter=2501,coin=290000,coin_add=100,exp=69595000,exp_add=50000,mon_soul=0,sdrop_num=300,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2520 ->
	#onhook_drop{chapter=2520,origin_chapter=2511,coin=291000,coin_add=100,exp=70095000,exp_add=50000,mon_soul=0,sdrop_num=301,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2530 ->
	#onhook_drop{chapter=2530,origin_chapter=2521,coin=292000,coin_add=100,exp=70595000,exp_add=50000,mon_soul=0,sdrop_num=302,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2540 ->
	#onhook_drop{chapter=2540,origin_chapter=2531,coin=293000,coin_add=100,exp=71095000,exp_add=50000,mon_soul=0,sdrop_num=303,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2550 ->
	#onhook_drop{chapter=2550,origin_chapter=2541,coin=294000,coin_add=100,exp=71595000,exp_add=50000,mon_soul=0,sdrop_num=304,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2560 ->
	#onhook_drop{chapter=2560,origin_chapter=2551,coin=295000,coin_add=100,exp=72095000,exp_add=50000,mon_soul=0,sdrop_num=305,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2570 ->
	#onhook_drop{chapter=2570,origin_chapter=2561,coin=296000,coin_add=100,exp=72595000,exp_add=50000,mon_soul=0,sdrop_num=306,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2580 ->
	#onhook_drop{chapter=2580,origin_chapter=2571,coin=297000,coin_add=100,exp=73095000,exp_add=50000,mon_soul=0,sdrop_num=307,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2590 ->
	#onhook_drop{chapter=2590,origin_chapter=2581,coin=298000,coin_add=100,exp=73595000,exp_add=50000,mon_soul=0,sdrop_num=308,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2600 ->
	#onhook_drop{chapter=2600,origin_chapter=2591,coin=299000,coin_add=100,exp=74095000,exp_add=50000,mon_soul=0,sdrop_num=309,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2610 ->
	#onhook_drop{chapter=2610,origin_chapter=2601,coin=300000,coin_add=100,exp=74595000,exp_add=50000,mon_soul=0,sdrop_num=310,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2620 ->
	#onhook_drop{chapter=2620,origin_chapter=2611,coin=301000,coin_add=100,exp=75095000,exp_add=50000,mon_soul=0,sdrop_num=311,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2630 ->
	#onhook_drop{chapter=2630,origin_chapter=2621,coin=302000,coin_add=100,exp=75595000,exp_add=50000,mon_soul=0,sdrop_num=312,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2640 ->
	#onhook_drop{chapter=2640,origin_chapter=2631,coin=303000,coin_add=100,exp=76095000,exp_add=50000,mon_soul=0,sdrop_num=313,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2650 ->
	#onhook_drop{chapter=2650,origin_chapter=2641,coin=304000,coin_add=100,exp=76595000,exp_add=50000,mon_soul=0,sdrop_num=314,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2660 ->
	#onhook_drop{chapter=2660,origin_chapter=2651,coin=305000,coin_add=100,exp=77095000,exp_add=50000,mon_soul=0,sdrop_num=315,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2670 ->
	#onhook_drop{chapter=2670,origin_chapter=2661,coin=306000,coin_add=100,exp=77595000,exp_add=50000,mon_soul=0,sdrop_num=316,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2680 ->
	#onhook_drop{chapter=2680,origin_chapter=2671,coin=307000,coin_add=100,exp=78095000,exp_add=50000,mon_soul=0,sdrop_num=317,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2690 ->
	#onhook_drop{chapter=2690,origin_chapter=2681,coin=308000,coin_add=100,exp=78595000,exp_add=50000,mon_soul=0,sdrop_num=318,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2700 ->
	#onhook_drop{chapter=2700,origin_chapter=2691,coin=309000,coin_add=100,exp=79095000,exp_add=50000,mon_soul=0,sdrop_num=319,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2710 ->
	#onhook_drop{chapter=2710,origin_chapter=2701,coin=310000,coin_add=100,exp=79595000,exp_add=50000,mon_soul=0,sdrop_num=320,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2720 ->
	#onhook_drop{chapter=2720,origin_chapter=2711,coin=311000,coin_add=100,exp=80095000,exp_add=50000,mon_soul=0,sdrop_num=321,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2730 ->
	#onhook_drop{chapter=2730,origin_chapter=2721,coin=312000,coin_add=100,exp=80595000,exp_add=50000,mon_soul=0,sdrop_num=322,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2740 ->
	#onhook_drop{chapter=2740,origin_chapter=2731,coin=313000,coin_add=100,exp=81095000,exp_add=50000,mon_soul=0,sdrop_num=323,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2750 ->
	#onhook_drop{chapter=2750,origin_chapter=2741,coin=314000,coin_add=100,exp=81595000,exp_add=50000,mon_soul=0,sdrop_num=324,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2760 ->
	#onhook_drop{chapter=2760,origin_chapter=2751,coin=315000,coin_add=100,exp=82095000,exp_add=50000,mon_soul=0,sdrop_num=325,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2770 ->
	#onhook_drop{chapter=2770,origin_chapter=2761,coin=316000,coin_add=100,exp=82595000,exp_add=50000,mon_soul=0,sdrop_num=326,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2780 ->
	#onhook_drop{chapter=2780,origin_chapter=2771,coin=317000,coin_add=100,exp=83095000,exp_add=50000,mon_soul=0,sdrop_num=327,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2790 ->
	#onhook_drop{chapter=2790,origin_chapter=2781,coin=318000,coin_add=100,exp=83595000,exp_add=50000,mon_soul=0,sdrop_num=328,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2800 ->
	#onhook_drop{chapter=2800,origin_chapter=2791,coin=319000,coin_add=100,exp=84095000,exp_add=50000,mon_soul=0,sdrop_num=329,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2810 ->
	#onhook_drop{chapter=2810,origin_chapter=2801,coin=320000,coin_add=100,exp=84595000,exp_add=50000,mon_soul=0,sdrop_num=330,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2820 ->
	#onhook_drop{chapter=2820,origin_chapter=2811,coin=321000,coin_add=100,exp=85095000,exp_add=50000,mon_soul=0,sdrop_num=331,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2830 ->
	#onhook_drop{chapter=2830,origin_chapter=2821,coin=322000,coin_add=100,exp=85595000,exp_add=50000,mon_soul=0,sdrop_num=332,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2840 ->
	#onhook_drop{chapter=2840,origin_chapter=2831,coin=323000,coin_add=100,exp=86095000,exp_add=50000,mon_soul=0,sdrop_num=333,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2850 ->
	#onhook_drop{chapter=2850,origin_chapter=2841,coin=324000,coin_add=100,exp=86595000,exp_add=50000,mon_soul=0,sdrop_num=334,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2860 ->
	#onhook_drop{chapter=2860,origin_chapter=2851,coin=325000,coin_add=100,exp=87095000,exp_add=50000,mon_soul=0,sdrop_num=335,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2870 ->
	#onhook_drop{chapter=2870,origin_chapter=2861,coin=326000,coin_add=100,exp=87595000,exp_add=50000,mon_soul=0,sdrop_num=336,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2880 ->
	#onhook_drop{chapter=2880,origin_chapter=2871,coin=327000,coin_add=100,exp=88095000,exp_add=50000,mon_soul=0,sdrop_num=337,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2890 ->
	#onhook_drop{chapter=2890,origin_chapter=2881,coin=328000,coin_add=100,exp=88595000,exp_add=50000,mon_soul=0,sdrop_num=338,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2900 ->
	#onhook_drop{chapter=2900,origin_chapter=2891,coin=329000,coin_add=100,exp=89095000,exp_add=50000,mon_soul=0,sdrop_num=339,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2910 ->
	#onhook_drop{chapter=2910,origin_chapter=2901,coin=330000,coin_add=100,exp=89595000,exp_add=50000,mon_soul=0,sdrop_num=340,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2920 ->
	#onhook_drop{chapter=2920,origin_chapter=2911,coin=331000,coin_add=100,exp=90095000,exp_add=50000,mon_soul=0,sdrop_num=341,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2930 ->
	#onhook_drop{chapter=2930,origin_chapter=2921,coin=332000,coin_add=100,exp=90595000,exp_add=50000,mon_soul=0,sdrop_num=342,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2940 ->
	#onhook_drop{chapter=2940,origin_chapter=2931,coin=333000,coin_add=100,exp=91095000,exp_add=50000,mon_soul=0,sdrop_num=343,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2950 ->
	#onhook_drop{chapter=2950,origin_chapter=2941,coin=334000,coin_add=100,exp=91595000,exp_add=50000,mon_soul=0,sdrop_num=344,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2960 ->
	#onhook_drop{chapter=2960,origin_chapter=2951,coin=335000,coin_add=100,exp=92095000,exp_add=50000,mon_soul=0,sdrop_num=345,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2970 ->
	#onhook_drop{chapter=2970,origin_chapter=2961,coin=336000,coin_add=100,exp=92595000,exp_add=50000,mon_soul=0,sdrop_num=346,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2980 ->
	#onhook_drop{chapter=2980,origin_chapter=2971,coin=337000,coin_add=100,exp=93095000,exp_add=50000,mon_soul=0,sdrop_num=347,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 2990 ->
	#onhook_drop{chapter=2990,origin_chapter=2981,coin=338000,coin_add=100,exp=93595000,exp_add=50000,mon_soul=0,sdrop_num=348,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3000 ->
	#onhook_drop{chapter=3000,origin_chapter=2991,coin=339000,coin_add=100,exp=94095000,exp_add=50000,mon_soul=0,sdrop_num=349,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3010 ->
	#onhook_drop{chapter=3010,origin_chapter=3001,coin=340000,coin_add=100,exp=94595000,exp_add=50000,mon_soul=0,sdrop_num=350,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3020 ->
	#onhook_drop{chapter=3020,origin_chapter=3011,coin=341000,coin_add=100,exp=95095000,exp_add=50000,mon_soul=0,sdrop_num=351,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3030 ->
	#onhook_drop{chapter=3030,origin_chapter=3021,coin=342000,coin_add=100,exp=95595000,exp_add=50000,mon_soul=0,sdrop_num=352,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3040 ->
	#onhook_drop{chapter=3040,origin_chapter=3031,coin=343000,coin_add=100,exp=96095000,exp_add=50000,mon_soul=0,sdrop_num=353,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3050 ->
	#onhook_drop{chapter=3050,origin_chapter=3041,coin=344000,coin_add=100,exp=96595000,exp_add=50000,mon_soul=0,sdrop_num=354,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3060 ->
	#onhook_drop{chapter=3060,origin_chapter=3051,coin=345000,coin_add=100,exp=97095000,exp_add=50000,mon_soul=0,sdrop_num=355,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3070 ->
	#onhook_drop{chapter=3070,origin_chapter=3061,coin=346000,coin_add=100,exp=97595000,exp_add=50000,mon_soul=0,sdrop_num=356,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3080 ->
	#onhook_drop{chapter=3080,origin_chapter=3071,coin=347000,coin_add=100,exp=98095000,exp_add=50000,mon_soul=0,sdrop_num=357,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3090 ->
	#onhook_drop{chapter=3090,origin_chapter=3081,coin=348000,coin_add=100,exp=98595000,exp_add=50000,mon_soul=0,sdrop_num=358,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3100 ->
	#onhook_drop{chapter=3100,origin_chapter=3091,coin=349000,coin_add=100,exp=99095000,exp_add=50000,mon_soul=0,sdrop_num=359,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3110 ->
	#onhook_drop{chapter=3110,origin_chapter=3101,coin=350000,coin_add=100,exp=99625000,exp_add=80000,mon_soul=0,sdrop_num=360,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3120 ->
	#onhook_drop{chapter=3120,origin_chapter=3111,coin=351000,coin_add=100,exp=100425000,exp_add=80000,mon_soul=0,sdrop_num=361,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3130 ->
	#onhook_drop{chapter=3130,origin_chapter=3121,coin=352000,coin_add=100,exp=101225000,exp_add=80000,mon_soul=0,sdrop_num=362,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3140 ->
	#onhook_drop{chapter=3140,origin_chapter=3131,coin=353000,coin_add=100,exp=102025000,exp_add=80000,mon_soul=0,sdrop_num=363,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3150 ->
	#onhook_drop{chapter=3150,origin_chapter=3141,coin=354000,coin_add=100,exp=102825000,exp_add=80000,mon_soul=0,sdrop_num=364,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3160 ->
	#onhook_drop{chapter=3160,origin_chapter=3151,coin=355000,coin_add=100,exp=103625000,exp_add=80000,mon_soul=0,sdrop_num=365,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3170 ->
	#onhook_drop{chapter=3170,origin_chapter=3161,coin=356000,coin_add=100,exp=104425000,exp_add=80000,mon_soul=0,sdrop_num=366,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3180 ->
	#onhook_drop{chapter=3180,origin_chapter=3171,coin=357000,coin_add=100,exp=105225000,exp_add=80000,mon_soul=0,sdrop_num=367,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3190 ->
	#onhook_drop{chapter=3190,origin_chapter=3181,coin=358000,coin_add=100,exp=106025000,exp_add=80000,mon_soul=0,sdrop_num=368,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3200 ->
	#onhook_drop{chapter=3200,origin_chapter=3191,coin=359000,coin_add=100,exp=106825000,exp_add=80000,mon_soul=0,sdrop_num=369,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3210 ->
	#onhook_drop{chapter=3210,origin_chapter=3201,coin=360000,coin_add=100,exp=107625000,exp_add=80000,mon_soul=0,sdrop_num=370,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3220 ->
	#onhook_drop{chapter=3220,origin_chapter=3211,coin=361000,coin_add=100,exp=108425000,exp_add=80000,mon_soul=0,sdrop_num=371,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3230 ->
	#onhook_drop{chapter=3230,origin_chapter=3221,coin=362000,coin_add=100,exp=109225000,exp_add=80000,mon_soul=0,sdrop_num=372,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3240 ->
	#onhook_drop{chapter=3240,origin_chapter=3231,coin=363000,coin_add=100,exp=110025000,exp_add=80000,mon_soul=0,sdrop_num=373,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3250 ->
	#onhook_drop{chapter=3250,origin_chapter=3241,coin=364000,coin_add=100,exp=110825000,exp_add=80000,mon_soul=0,sdrop_num=374,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3260 ->
	#onhook_drop{chapter=3260,origin_chapter=3251,coin=365000,coin_add=100,exp=111625000,exp_add=80000,mon_soul=0,sdrop_num=375,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3270 ->
	#onhook_drop{chapter=3270,origin_chapter=3261,coin=366000,coin_add=100,exp=112425000,exp_add=80000,mon_soul=0,sdrop_num=376,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3280 ->
	#onhook_drop{chapter=3280,origin_chapter=3271,coin=367000,coin_add=100,exp=113225000,exp_add=80000,mon_soul=0,sdrop_num=377,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3290 ->
	#onhook_drop{chapter=3290,origin_chapter=3281,coin=368000,coin_add=100,exp=114025000,exp_add=80000,mon_soul=0,sdrop_num=378,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3300 ->
	#onhook_drop{chapter=3300,origin_chapter=3291,coin=369000,coin_add=100,exp=114825000,exp_add=80000,mon_soul=0,sdrop_num=379,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3310 ->
	#onhook_drop{chapter=3310,origin_chapter=3301,coin=370000,coin_add=100,exp=115625000,exp_add=80000,mon_soul=0,sdrop_num=380,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3320 ->
	#onhook_drop{chapter=3320,origin_chapter=3311,coin=371000,coin_add=100,exp=116425000,exp_add=80000,mon_soul=0,sdrop_num=381,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3330 ->
	#onhook_drop{chapter=3330,origin_chapter=3321,coin=372000,coin_add=100,exp=117225000,exp_add=80000,mon_soul=0,sdrop_num=382,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3340 ->
	#onhook_drop{chapter=3340,origin_chapter=3331,coin=373000,coin_add=100,exp=118025000,exp_add=80000,mon_soul=0,sdrop_num=383,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3350 ->
	#onhook_drop{chapter=3350,origin_chapter=3341,coin=374000,coin_add=100,exp=118825000,exp_add=80000,mon_soul=0,sdrop_num=384,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3360 ->
	#onhook_drop{chapter=3360,origin_chapter=3351,coin=375000,coin_add=100,exp=119625000,exp_add=80000,mon_soul=0,sdrop_num=385,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3370 ->
	#onhook_drop{chapter=3370,origin_chapter=3361,coin=376000,coin_add=100,exp=120425000,exp_add=80000,mon_soul=0,sdrop_num=386,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3380 ->
	#onhook_drop{chapter=3380,origin_chapter=3371,coin=377000,coin_add=100,exp=121225000,exp_add=80000,mon_soul=0,sdrop_num=387,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3390 ->
	#onhook_drop{chapter=3390,origin_chapter=3381,coin=378000,coin_add=100,exp=122025000,exp_add=80000,mon_soul=0,sdrop_num=388,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3400 ->
	#onhook_drop{chapter=3400,origin_chapter=3391,coin=379000,coin_add=100,exp=122825000,exp_add=80000,mon_soul=0,sdrop_num=389,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3410 ->
	#onhook_drop{chapter=3410,origin_chapter=3401,coin=380000,coin_add=100,exp=123625000,exp_add=80000,mon_soul=0,sdrop_num=390,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3420 ->
	#onhook_drop{chapter=3420,origin_chapter=3411,coin=381000,coin_add=100,exp=124425000,exp_add=80000,mon_soul=0,sdrop_num=391,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3430 ->
	#onhook_drop{chapter=3430,origin_chapter=3421,coin=382000,coin_add=100,exp=125225000,exp_add=80000,mon_soul=0,sdrop_num=392,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3440 ->
	#onhook_drop{chapter=3440,origin_chapter=3431,coin=383000,coin_add=100,exp=126025000,exp_add=80000,mon_soul=0,sdrop_num=393,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3450 ->
	#onhook_drop{chapter=3450,origin_chapter=3441,coin=384000,coin_add=100,exp=126825000,exp_add=80000,mon_soul=0,sdrop_num=394,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3460 ->
	#onhook_drop{chapter=3460,origin_chapter=3451,coin=385000,coin_add=100,exp=127625000,exp_add=80000,mon_soul=0,sdrop_num=395,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3470 ->
	#onhook_drop{chapter=3470,origin_chapter=3461,coin=386000,coin_add=100,exp=128425000,exp_add=80000,mon_soul=0,sdrop_num=396,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3480 ->
	#onhook_drop{chapter=3480,origin_chapter=3471,coin=387000,coin_add=100,exp=129225000,exp_add=80000,mon_soul=0,sdrop_num=397,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3490 ->
	#onhook_drop{chapter=3490,origin_chapter=3481,coin=388000,coin_add=100,exp=130025000,exp_add=80000,mon_soul=0,sdrop_num=398,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3500 ->
	#onhook_drop{chapter=3500,origin_chapter=3491,coin=389000,coin_add=100,exp=130825000,exp_add=80000,mon_soul=0,sdrop_num=399,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3510 ->
	#onhook_drop{chapter=3510,origin_chapter=3501,coin=390000,coin_add=100,exp=131625000,exp_add=80000,mon_soul=0,sdrop_num=400,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3520 ->
	#onhook_drop{chapter=3520,origin_chapter=3511,coin=391000,coin_add=100,exp=132425000,exp_add=80000,mon_soul=0,sdrop_num=401,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3530 ->
	#onhook_drop{chapter=3530,origin_chapter=3521,coin=392000,coin_add=100,exp=133225000,exp_add=80000,mon_soul=0,sdrop_num=402,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3540 ->
	#onhook_drop{chapter=3540,origin_chapter=3531,coin=393000,coin_add=100,exp=134025000,exp_add=80000,mon_soul=0,sdrop_num=403,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3550 ->
	#onhook_drop{chapter=3550,origin_chapter=3541,coin=394000,coin_add=100,exp=134825000,exp_add=80000,mon_soul=0,sdrop_num=404,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3560 ->
	#onhook_drop{chapter=3560,origin_chapter=3551,coin=395000,coin_add=100,exp=135625000,exp_add=80000,mon_soul=0,sdrop_num=405,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3570 ->
	#onhook_drop{chapter=3570,origin_chapter=3561,coin=396000,coin_add=100,exp=136425000,exp_add=80000,mon_soul=0,sdrop_num=406,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3580 ->
	#onhook_drop{chapter=3580,origin_chapter=3571,coin=397000,coin_add=100,exp=137225000,exp_add=80000,mon_soul=0,sdrop_num=407,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3590 ->
	#onhook_drop{chapter=3590,origin_chapter=3581,coin=398000,coin_add=100,exp=138025000,exp_add=80000,mon_soul=0,sdrop_num=408,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3600 ->
	#onhook_drop{chapter=3600,origin_chapter=3591,coin=399000,coin_add=100,exp=138825000,exp_add=80000,mon_soul=0,sdrop_num=409,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3610 ->
	#onhook_drop{chapter=3610,origin_chapter=3601,coin=400000,coin_add=100,exp=139625000,exp_add=80000,mon_soul=0,sdrop_num=410,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3620 ->
	#onhook_drop{chapter=3620,origin_chapter=3611,coin=401000,coin_add=100,exp=140425000,exp_add=80000,mon_soul=0,sdrop_num=411,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3630 ->
	#onhook_drop{chapter=3630,origin_chapter=3621,coin=402000,coin_add=100,exp=141225000,exp_add=80000,mon_soul=0,sdrop_num=412,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3640 ->
	#onhook_drop{chapter=3640,origin_chapter=3631,coin=403000,coin_add=100,exp=142025000,exp_add=80000,mon_soul=0,sdrop_num=413,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3650 ->
	#onhook_drop{chapter=3650,origin_chapter=3641,coin=404000,coin_add=100,exp=142825000,exp_add=80000,mon_soul=0,sdrop_num=414,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3660 ->
	#onhook_drop{chapter=3660,origin_chapter=3651,coin=405000,coin_add=100,exp=143625000,exp_add=80000,mon_soul=0,sdrop_num=415,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3670 ->
	#onhook_drop{chapter=3670,origin_chapter=3661,coin=406000,coin_add=100,exp=144425000,exp_add=80000,mon_soul=0,sdrop_num=416,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3680 ->
	#onhook_drop{chapter=3680,origin_chapter=3671,coin=407000,coin_add=100,exp=145225000,exp_add=80000,mon_soul=0,sdrop_num=417,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3690 ->
	#onhook_drop{chapter=3690,origin_chapter=3681,coin=408000,coin_add=100,exp=146025000,exp_add=80000,mon_soul=0,sdrop_num=418,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3700 ->
	#onhook_drop{chapter=3700,origin_chapter=3691,coin=409000,coin_add=100,exp=146825000,exp_add=80000,mon_soul=0,sdrop_num=419,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3710 ->
	#onhook_drop{chapter=3710,origin_chapter=3701,coin=410000,coin_add=100,exp=147625000,exp_add=80000,mon_soul=0,sdrop_num=420,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3720 ->
	#onhook_drop{chapter=3720,origin_chapter=3711,coin=411000,coin_add=100,exp=148425000,exp_add=80000,mon_soul=0,sdrop_num=421,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3730 ->
	#onhook_drop{chapter=3730,origin_chapter=3721,coin=412000,coin_add=100,exp=149225000,exp_add=80000,mon_soul=0,sdrop_num=422,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3740 ->
	#onhook_drop{chapter=3740,origin_chapter=3731,coin=413000,coin_add=100,exp=150025000,exp_add=80000,mon_soul=0,sdrop_num=423,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3750 ->
	#onhook_drop{chapter=3750,origin_chapter=3741,coin=414000,coin_add=100,exp=150825000,exp_add=80000,mon_soul=0,sdrop_num=424,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3760 ->
	#onhook_drop{chapter=3760,origin_chapter=3751,coin=415000,coin_add=100,exp=151625000,exp_add=80000,mon_soul=0,sdrop_num=425,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3770 ->
	#onhook_drop{chapter=3770,origin_chapter=3761,coin=416000,coin_add=100,exp=152425000,exp_add=80000,mon_soul=0,sdrop_num=426,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3780 ->
	#onhook_drop{chapter=3780,origin_chapter=3771,coin=417000,coin_add=100,exp=153225000,exp_add=80000,mon_soul=0,sdrop_num=427,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3790 ->
	#onhook_drop{chapter=3790,origin_chapter=3781,coin=418000,coin_add=100,exp=154025000,exp_add=80000,mon_soul=0,sdrop_num=428,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3800 ->
	#onhook_drop{chapter=3800,origin_chapter=3791,coin=419000,coin_add=100,exp=154825000,exp_add=80000,mon_soul=0,sdrop_num=429,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3810 ->
	#onhook_drop{chapter=3810,origin_chapter=3801,coin=420000,coin_add=100,exp=155625000,exp_add=80000,mon_soul=0,sdrop_num=430,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3820 ->
	#onhook_drop{chapter=3820,origin_chapter=3811,coin=421000,coin_add=100,exp=156425000,exp_add=80000,mon_soul=0,sdrop_num=431,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3830 ->
	#onhook_drop{chapter=3830,origin_chapter=3821,coin=422000,coin_add=100,exp=157225000,exp_add=80000,mon_soul=0,sdrop_num=432,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3840 ->
	#onhook_drop{chapter=3840,origin_chapter=3831,coin=423000,coin_add=100,exp=158025000,exp_add=80000,mon_soul=0,sdrop_num=433,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3850 ->
	#onhook_drop{chapter=3850,origin_chapter=3841,coin=424000,coin_add=100,exp=158825000,exp_add=80000,mon_soul=0,sdrop_num=434,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3860 ->
	#onhook_drop{chapter=3860,origin_chapter=3851,coin=425000,coin_add=100,exp=159625000,exp_add=80000,mon_soul=0,sdrop_num=435,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3870 ->
	#onhook_drop{chapter=3870,origin_chapter=3861,coin=426000,coin_add=100,exp=160425000,exp_add=80000,mon_soul=0,sdrop_num=436,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3880 ->
	#onhook_drop{chapter=3880,origin_chapter=3871,coin=427000,coin_add=100,exp=161225000,exp_add=80000,mon_soul=0,sdrop_num=437,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3890 ->
	#onhook_drop{chapter=3890,origin_chapter=3881,coin=428000,coin_add=100,exp=162025000,exp_add=80000,mon_soul=0,sdrop_num=438,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3900 ->
	#onhook_drop{chapter=3900,origin_chapter=3891,coin=429000,coin_add=100,exp=162825000,exp_add=80000,mon_soul=0,sdrop_num=439,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3910 ->
	#onhook_drop{chapter=3910,origin_chapter=3901,coin=430000,coin_add=100,exp=163625000,exp_add=80000,mon_soul=0,sdrop_num=440,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3920 ->
	#onhook_drop{chapter=3920,origin_chapter=3911,coin=431000,coin_add=100,exp=164425000,exp_add=80000,mon_soul=0,sdrop_num=441,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3930 ->
	#onhook_drop{chapter=3930,origin_chapter=3921,coin=432000,coin_add=100,exp=165225000,exp_add=80000,mon_soul=0,sdrop_num=442,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3940 ->
	#onhook_drop{chapter=3940,origin_chapter=3931,coin=433000,coin_add=100,exp=166025000,exp_add=80000,mon_soul=0,sdrop_num=443,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3950 ->
	#onhook_drop{chapter=3950,origin_chapter=3941,coin=434000,coin_add=100,exp=166825000,exp_add=80000,mon_soul=0,sdrop_num=444,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3960 ->
	#onhook_drop{chapter=3960,origin_chapter=3951,coin=435000,coin_add=100,exp=167625000,exp_add=80000,mon_soul=0,sdrop_num=445,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3970 ->
	#onhook_drop{chapter=3970,origin_chapter=3961,coin=436000,coin_add=100,exp=168425000,exp_add=80000,mon_soul=0,sdrop_num=446,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3980 ->
	#onhook_drop{chapter=3980,origin_chapter=3971,coin=437000,coin_add=100,exp=169225000,exp_add=80000,mon_soul=0,sdrop_num=447,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 3990 ->
	#onhook_drop{chapter=3990,origin_chapter=3981,coin=438000,coin_add=100,exp=170025000,exp_add=80000,mon_soul=0,sdrop_num=448,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4000 ->
	#onhook_drop{chapter=4000,origin_chapter=3991,coin=439000,coin_add=100,exp=170825000,exp_add=80000,mon_soul=0,sdrop_num=449,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4010 ->
	#onhook_drop{chapter=4010,origin_chapter=4001,coin=440000,coin_add=100,exp=171625000,exp_add=80000,mon_soul=0,sdrop_num=450,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4020 ->
	#onhook_drop{chapter=4020,origin_chapter=4011,coin=441000,coin_add=100,exp=172425000,exp_add=80000,mon_soul=0,sdrop_num=451,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4030 ->
	#onhook_drop{chapter=4030,origin_chapter=4021,coin=442000,coin_add=100,exp=173225000,exp_add=80000,mon_soul=0,sdrop_num=452,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4040 ->
	#onhook_drop{chapter=4040,origin_chapter=4031,coin=443000,coin_add=100,exp=174025000,exp_add=80000,mon_soul=0,sdrop_num=453,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4050 ->
	#onhook_drop{chapter=4050,origin_chapter=4041,coin=444000,coin_add=100,exp=174825000,exp_add=80000,mon_soul=0,sdrop_num=454,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4060 ->
	#onhook_drop{chapter=4060,origin_chapter=4051,coin=445000,coin_add=100,exp=175625000,exp_add=80000,mon_soul=0,sdrop_num=455,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4070 ->
	#onhook_drop{chapter=4070,origin_chapter=4061,coin=446000,coin_add=100,exp=176425000,exp_add=80000,mon_soul=0,sdrop_num=456,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4080 ->
	#onhook_drop{chapter=4080,origin_chapter=4071,coin=447000,coin_add=100,exp=177225000,exp_add=80000,mon_soul=0,sdrop_num=457,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4090 ->
	#onhook_drop{chapter=4090,origin_chapter=4081,coin=448000,coin_add=100,exp=178025000,exp_add=80000,mon_soul=0,sdrop_num=458,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4100 ->
	#onhook_drop{chapter=4100,origin_chapter=4091,coin=449000,coin_add=100,exp=178825000,exp_add=80000,mon_soul=0,sdrop_num=459,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4110 ->
	#onhook_drop{chapter=4110,origin_chapter=4101,coin=450000,coin_add=100,exp=179625000,exp_add=80000,mon_soul=0,sdrop_num=460,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4120 ->
	#onhook_drop{chapter=4120,origin_chapter=4111,coin=451000,coin_add=100,exp=180425000,exp_add=80000,mon_soul=0,sdrop_num=461,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4130 ->
	#onhook_drop{chapter=4130,origin_chapter=4121,coin=452000,coin_add=100,exp=181225000,exp_add=80000,mon_soul=0,sdrop_num=462,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4140 ->
	#onhook_drop{chapter=4140,origin_chapter=4131,coin=453000,coin_add=100,exp=182025000,exp_add=80000,mon_soul=0,sdrop_num=463,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4150 ->
	#onhook_drop{chapter=4150,origin_chapter=4141,coin=454000,coin_add=100,exp=182825000,exp_add=80000,mon_soul=0,sdrop_num=464,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4160 ->
	#onhook_drop{chapter=4160,origin_chapter=4151,coin=455000,coin_add=100,exp=183625000,exp_add=80000,mon_soul=0,sdrop_num=465,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4170 ->
	#onhook_drop{chapter=4170,origin_chapter=4161,coin=456000,coin_add=100,exp=184425000,exp_add=80000,mon_soul=0,sdrop_num=466,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4180 ->
	#onhook_drop{chapter=4180,origin_chapter=4171,coin=457000,coin_add=100,exp=185225000,exp_add=80000,mon_soul=0,sdrop_num=467,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4190 ->
	#onhook_drop{chapter=4190,origin_chapter=4181,coin=458000,coin_add=100,exp=186025000,exp_add=80000,mon_soul=0,sdrop_num=468,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4200 ->
	#onhook_drop{chapter=4200,origin_chapter=4191,coin=459000,coin_add=100,exp=186825000,exp_add=80000,mon_soul=0,sdrop_num=469,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4210 ->
	#onhook_drop{chapter=4210,origin_chapter=4201,coin=460000,coin_add=100,exp=187625000,exp_add=80000,mon_soul=0,sdrop_num=470,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4220 ->
	#onhook_drop{chapter=4220,origin_chapter=4211,coin=461000,coin_add=100,exp=188425000,exp_add=80000,mon_soul=0,sdrop_num=471,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4230 ->
	#onhook_drop{chapter=4230,origin_chapter=4221,coin=462000,coin_add=100,exp=189225000,exp_add=80000,mon_soul=0,sdrop_num=472,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4240 ->
	#onhook_drop{chapter=4240,origin_chapter=4231,coin=463000,coin_add=100,exp=190025000,exp_add=80000,mon_soul=0,sdrop_num=473,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4250 ->
	#onhook_drop{chapter=4250,origin_chapter=4241,coin=464000,coin_add=100,exp=190825000,exp_add=80000,mon_soul=0,sdrop_num=474,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4260 ->
	#onhook_drop{chapter=4260,origin_chapter=4251,coin=465000,coin_add=100,exp=191625000,exp_add=80000,mon_soul=0,sdrop_num=475,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4270 ->
	#onhook_drop{chapter=4270,origin_chapter=4261,coin=466000,coin_add=100,exp=192425000,exp_add=80000,mon_soul=0,sdrop_num=476,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4280 ->
	#onhook_drop{chapter=4280,origin_chapter=4271,coin=467000,coin_add=100,exp=193225000,exp_add=80000,mon_soul=0,sdrop_num=477,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4290 ->
	#onhook_drop{chapter=4290,origin_chapter=4281,coin=468000,coin_add=100,exp=194025000,exp_add=80000,mon_soul=0,sdrop_num=478,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4300 ->
	#onhook_drop{chapter=4300,origin_chapter=4291,coin=469000,coin_add=100,exp=194825000,exp_add=80000,mon_soul=0,sdrop_num=479,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4310 ->
	#onhook_drop{chapter=4310,origin_chapter=4301,coin=470000,coin_add=100,exp=195625000,exp_add=80000,mon_soul=0,sdrop_num=480,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4320 ->
	#onhook_drop{chapter=4320,origin_chapter=4311,coin=471000,coin_add=100,exp=196425000,exp_add=80000,mon_soul=0,sdrop_num=481,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4330 ->
	#onhook_drop{chapter=4330,origin_chapter=4321,coin=472000,coin_add=100,exp=197225000,exp_add=80000,mon_soul=0,sdrop_num=482,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4340 ->
	#onhook_drop{chapter=4340,origin_chapter=4331,coin=473000,coin_add=100,exp=198025000,exp_add=80000,mon_soul=0,sdrop_num=483,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4350 ->
	#onhook_drop{chapter=4350,origin_chapter=4341,coin=474000,coin_add=100,exp=198825000,exp_add=80000,mon_soul=0,sdrop_num=484,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4360 ->
	#onhook_drop{chapter=4360,origin_chapter=4351,coin=475000,coin_add=100,exp=199625000,exp_add=80000,mon_soul=0,sdrop_num=485,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4370 ->
	#onhook_drop{chapter=4370,origin_chapter=4361,coin=476000,coin_add=100,exp=200425000,exp_add=80000,mon_soul=0,sdrop_num=486,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4380 ->
	#onhook_drop{chapter=4380,origin_chapter=4371,coin=477000,coin_add=100,exp=201225000,exp_add=80000,mon_soul=0,sdrop_num=487,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4390 ->
	#onhook_drop{chapter=4390,origin_chapter=4381,coin=478000,coin_add=100,exp=202025000,exp_add=80000,mon_soul=0,sdrop_num=488,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4400 ->
	#onhook_drop{chapter=4400,origin_chapter=4391,coin=479000,coin_add=100,exp=202825000,exp_add=80000,mon_soul=0,sdrop_num=489,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4410 ->
	#onhook_drop{chapter=4410,origin_chapter=4401,coin=480000,coin_add=100,exp=203625000,exp_add=80000,mon_soul=0,sdrop_num=490,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4420 ->
	#onhook_drop{chapter=4420,origin_chapter=4411,coin=481000,coin_add=100,exp=204425000,exp_add=80000,mon_soul=0,sdrop_num=491,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4430 ->
	#onhook_drop{chapter=4430,origin_chapter=4421,coin=482000,coin_add=100,exp=205225000,exp_add=80000,mon_soul=0,sdrop_num=492,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4440 ->
	#onhook_drop{chapter=4440,origin_chapter=4431,coin=483000,coin_add=100,exp=206025000,exp_add=80000,mon_soul=0,sdrop_num=493,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4450 ->
	#onhook_drop{chapter=4450,origin_chapter=4441,coin=484000,coin_add=100,exp=206825000,exp_add=80000,mon_soul=0,sdrop_num=494,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4460 ->
	#onhook_drop{chapter=4460,origin_chapter=4451,coin=485000,coin_add=100,exp=207625000,exp_add=80000,mon_soul=0,sdrop_num=495,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4470 ->
	#onhook_drop{chapter=4470,origin_chapter=4461,coin=486000,coin_add=100,exp=208425000,exp_add=80000,mon_soul=0,sdrop_num=496,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4480 ->
	#onhook_drop{chapter=4480,origin_chapter=4471,coin=487000,coin_add=100,exp=209225000,exp_add=80000,mon_soul=0,sdrop_num=497,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4490 ->
	#onhook_drop{chapter=4490,origin_chapter=4481,coin=488000,coin_add=100,exp=210025000,exp_add=80000,mon_soul=0,sdrop_num=498,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4500 ->
	#onhook_drop{chapter=4500,origin_chapter=4491,coin=489000,coin_add=100,exp=210825000,exp_add=80000,mon_soul=0,sdrop_num=499,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4510 ->
	#onhook_drop{chapter=4510,origin_chapter=4501,coin=490000,coin_add=100,exp=211625000,exp_add=80000,mon_soul=0,sdrop_num=500,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4520 ->
	#onhook_drop{chapter=4520,origin_chapter=4511,coin=491000,coin_add=100,exp=212425000,exp_add=80000,mon_soul=0,sdrop_num=501,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4530 ->
	#onhook_drop{chapter=4530,origin_chapter=4521,coin=492000,coin_add=100,exp=213225000,exp_add=80000,mon_soul=0,sdrop_num=502,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4540 ->
	#onhook_drop{chapter=4540,origin_chapter=4531,coin=493000,coin_add=100,exp=214025000,exp_add=80000,mon_soul=0,sdrop_num=503,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4550 ->
	#onhook_drop{chapter=4550,origin_chapter=4541,coin=494000,coin_add=100,exp=214825000,exp_add=80000,mon_soul=0,sdrop_num=504,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4560 ->
	#onhook_drop{chapter=4560,origin_chapter=4551,coin=495000,coin_add=100,exp=215625000,exp_add=80000,mon_soul=0,sdrop_num=505,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4570 ->
	#onhook_drop{chapter=4570,origin_chapter=4561,coin=496000,coin_add=100,exp=216425000,exp_add=80000,mon_soul=0,sdrop_num=506,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4580 ->
	#onhook_drop{chapter=4580,origin_chapter=4571,coin=497000,coin_add=100,exp=217225000,exp_add=80000,mon_soul=0,sdrop_num=507,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4590 ->
	#onhook_drop{chapter=4590,origin_chapter=4581,coin=498000,coin_add=100,exp=218025000,exp_add=80000,mon_soul=0,sdrop_num=508,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4600 ->
	#onhook_drop{chapter=4600,origin_chapter=4591,coin=499000,coin_add=100,exp=218825000,exp_add=80000,mon_soul=0,sdrop_num=509,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4610 ->
	#onhook_drop{chapter=4610,origin_chapter=4601,coin=500000,coin_add=100,exp=219625000,exp_add=80000,mon_soul=0,sdrop_num=510,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4620 ->
	#onhook_drop{chapter=4620,origin_chapter=4611,coin=501000,coin_add=100,exp=220425000,exp_add=80000,mon_soul=0,sdrop_num=511,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4630 ->
	#onhook_drop{chapter=4630,origin_chapter=4621,coin=502000,coin_add=100,exp=221225000,exp_add=80000,mon_soul=0,sdrop_num=512,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4640 ->
	#onhook_drop{chapter=4640,origin_chapter=4631,coin=503000,coin_add=100,exp=222025000,exp_add=80000,mon_soul=0,sdrop_num=513,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4650 ->
	#onhook_drop{chapter=4650,origin_chapter=4641,coin=504000,coin_add=100,exp=222825000,exp_add=80000,mon_soul=0,sdrop_num=514,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4660 ->
	#onhook_drop{chapter=4660,origin_chapter=4651,coin=505000,coin_add=100,exp=223625000,exp_add=80000,mon_soul=0,sdrop_num=515,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4670 ->
	#onhook_drop{chapter=4670,origin_chapter=4661,coin=506000,coin_add=100,exp=224425000,exp_add=80000,mon_soul=0,sdrop_num=516,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4680 ->
	#onhook_drop{chapter=4680,origin_chapter=4671,coin=507000,coin_add=100,exp=225225000,exp_add=80000,mon_soul=0,sdrop_num=517,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4690 ->
	#onhook_drop{chapter=4690,origin_chapter=4681,coin=508000,coin_add=100,exp=226025000,exp_add=80000,mon_soul=0,sdrop_num=518,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4700 ->
	#onhook_drop{chapter=4700,origin_chapter=4691,coin=509000,coin_add=100,exp=226825000,exp_add=80000,mon_soul=0,sdrop_num=519,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4710 ->
	#onhook_drop{chapter=4710,origin_chapter=4701,coin=510000,coin_add=100,exp=227625000,exp_add=80000,mon_soul=0,sdrop_num=520,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4720 ->
	#onhook_drop{chapter=4720,origin_chapter=4711,coin=511000,coin_add=100,exp=228425000,exp_add=80000,mon_soul=0,sdrop_num=521,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4730 ->
	#onhook_drop{chapter=4730,origin_chapter=4721,coin=512000,coin_add=100,exp=229225000,exp_add=80000,mon_soul=0,sdrop_num=522,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4740 ->
	#onhook_drop{chapter=4740,origin_chapter=4731,coin=513000,coin_add=100,exp=230025000,exp_add=80000,mon_soul=0,sdrop_num=523,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4750 ->
	#onhook_drop{chapter=4750,origin_chapter=4741,coin=514000,coin_add=100,exp=230825000,exp_add=80000,mon_soul=0,sdrop_num=524,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4760 ->
	#onhook_drop{chapter=4760,origin_chapter=4751,coin=515000,coin_add=100,exp=231625000,exp_add=80000,mon_soul=0,sdrop_num=525,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4770 ->
	#onhook_drop{chapter=4770,origin_chapter=4761,coin=516000,coin_add=100,exp=232425000,exp_add=80000,mon_soul=0,sdrop_num=526,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4780 ->
	#onhook_drop{chapter=4780,origin_chapter=4771,coin=517000,coin_add=100,exp=233225000,exp_add=80000,mon_soul=0,sdrop_num=527,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4790 ->
	#onhook_drop{chapter=4790,origin_chapter=4781,coin=518000,coin_add=100,exp=234025000,exp_add=80000,mon_soul=0,sdrop_num=528,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4800 ->
	#onhook_drop{chapter=4800,origin_chapter=4791,coin=519000,coin_add=100,exp=234825000,exp_add=80000,mon_soul=0,sdrop_num=529,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4810 ->
	#onhook_drop{chapter=4810,origin_chapter=4801,coin=520000,coin_add=100,exp=235625000,exp_add=80000,mon_soul=0,sdrop_num=530,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4820 ->
	#onhook_drop{chapter=4820,origin_chapter=4811,coin=521000,coin_add=100,exp=236425000,exp_add=80000,mon_soul=0,sdrop_num=531,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4830 ->
	#onhook_drop{chapter=4830,origin_chapter=4821,coin=522000,coin_add=100,exp=237225000,exp_add=80000,mon_soul=0,sdrop_num=532,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4840 ->
	#onhook_drop{chapter=4840,origin_chapter=4831,coin=523000,coin_add=100,exp=238025000,exp_add=80000,mon_soul=0,sdrop_num=533,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4850 ->
	#onhook_drop{chapter=4850,origin_chapter=4841,coin=524000,coin_add=100,exp=238825000,exp_add=80000,mon_soul=0,sdrop_num=534,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4860 ->
	#onhook_drop{chapter=4860,origin_chapter=4851,coin=525000,coin_add=100,exp=239625000,exp_add=80000,mon_soul=0,sdrop_num=535,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4870 ->
	#onhook_drop{chapter=4870,origin_chapter=4861,coin=526000,coin_add=100,exp=240425000,exp_add=80000,mon_soul=0,sdrop_num=536,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4880 ->
	#onhook_drop{chapter=4880,origin_chapter=4871,coin=527000,coin_add=100,exp=241225000,exp_add=80000,mon_soul=0,sdrop_num=537,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4890 ->
	#onhook_drop{chapter=4890,origin_chapter=4881,coin=528000,coin_add=100,exp=242025000,exp_add=80000,mon_soul=0,sdrop_num=538,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4900 ->
	#onhook_drop{chapter=4900,origin_chapter=4891,coin=529000,coin_add=100,exp=242825000,exp_add=80000,mon_soul=0,sdrop_num=539,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4910 ->
	#onhook_drop{chapter=4910,origin_chapter=4901,coin=530000,coin_add=100,exp=243625000,exp_add=80000,mon_soul=0,sdrop_num=540,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4920 ->
	#onhook_drop{chapter=4920,origin_chapter=4911,coin=531000,coin_add=100,exp=244425000,exp_add=80000,mon_soul=0,sdrop_num=541,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4930 ->
	#onhook_drop{chapter=4930,origin_chapter=4921,coin=532000,coin_add=100,exp=245225000,exp_add=80000,mon_soul=0,sdrop_num=542,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4940 ->
	#onhook_drop{chapter=4940,origin_chapter=4931,coin=533000,coin_add=100,exp=246025000,exp_add=80000,mon_soul=0,sdrop_num=543,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4950 ->
	#onhook_drop{chapter=4950,origin_chapter=4941,coin=534000,coin_add=100,exp=246825000,exp_add=80000,mon_soul=0,sdrop_num=544,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4960 ->
	#onhook_drop{chapter=4960,origin_chapter=4951,coin=535000,coin_add=100,exp=247625000,exp_add=80000,mon_soul=0,sdrop_num=545,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4970 ->
	#onhook_drop{chapter=4970,origin_chapter=4961,coin=536000,coin_add=100,exp=248425000,exp_add=80000,mon_soul=0,sdrop_num=546,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4980 ->
	#onhook_drop{chapter=4980,origin_chapter=4971,coin=537000,coin_add=100,exp=249225000,exp_add=80000,mon_soul=0,sdrop_num=547,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 4990 ->
	#onhook_drop{chapter=4990,origin_chapter=4981,coin=538000,coin_add=100,exp=250025000,exp_add=80000,mon_soul=0,sdrop_num=548,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) when _Chapter =< 5000 ->
	#onhook_drop{chapter=5000,origin_chapter=4991,coin=539000,coin_add=100,exp=250825000,exp_add=80000,mon_soul=0,sdrop_num=549,static_award=[],edrop_num=25,equip_award_rule=[{2,2,50000},{3,1,40000},{4,1,10000}],equip_award=[]};
get_onhook_drop(_Chapter) ->
	false.

get_onhook_scene(_Lv) when _Lv >= 1, _Lv =< 75 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 76, _Lv =< 130 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 131, _Lv =< 220 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 221, _Lv =< 310 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 311, _Lv =< 420 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 421, _Lv =< 580 ->
		[{1010,1}];
get_onhook_scene(_Lv) when _Lv >= 581, _Lv =< 9999 ->
		[{1010,1}];
get_onhook_scene(_Lv) ->
	[].

